#include "WinTen.h"
#include "Windows.h"
#include "ClipApi.h"

void WindowBoxIn( HDC hDC, RECT * pRect );
void WindowBox( HDC hDC, RECT * pRect );
void DrawMasked( HDC hDC, HBITMAP hBmp, WORD wRow, WORD wCol );
void DrawGray( HDC hDC, HBITMAP hBmp, WORD wRow, WORD wCol );

// En Dib.c
extern HGLOBAL DibRead( LPSTR szDibName );
extern LPSTR DibBits( LPBITMAPINFOHEADER lpBmp );
// extern HPALETTE CreateDIBPalette ( HGLOBAL hDIB );
extern WORD far pascal wDIBColors( LPBITMAPINFOHEADER lpBmp );

HANDLE GetResources( void );

extern int PalBmpRealize( HWND hWnd, LONG hPalBmp );
extern BOOL IsForePalette( LONG hPalBmp );

void RegisterResource( HANDLE hRes, LPSTR szType );

//---------------------------------------------------------------------------//

void MaskRegion(HDC hdc, RECT * rct,
                       COLORREF cTransparentColor,
                       COLORREF cBackgroundColor)

{
   HDC        hdcTemp, hdcObject, hdcBack, hdcMem;
   POINT      ptSize;
   COLORREF   cColor;
   HBITMAP    bmAndObject, bmAndBack, bmBackOld, bmObjectOld,
              bmAndTemp, bmTempOld, bmAndMem, bmMemOld;
   HBRUSH     hBrush, hBrOld;

   ptSize.x = rct->right - rct->left + 1;
   ptSize.y = rct->bottom - rct->top + 1;

   hBrush      = CreateSolidBrush(cBackgroundColor);

   hdcTemp     = CreateCompatibleDC(hdc);
   hdcObject   = CreateCompatibleDC(hdc);
   hdcBack     = CreateCompatibleDC(hdc);
   hdcMem      = CreateCompatibleDC(hdc);

   bmAndTemp   = CreateCompatibleBitmap(hdc, ptSize.x, ptSize.y);
   bmAndMem    = CreateCompatibleBitmap(hdc, ptSize.x, ptSize.y);
   bmAndObject = CreateBitmap(ptSize.x, ptSize.y, 1, 1, NULL);
   bmAndBack   = CreateBitmap(ptSize.x, ptSize.y, 1, 1, NULL);

   bmTempOld   = SelectObject(hdcTemp, bmAndTemp);
   bmMemOld    = SelectObject(hdcMem, bmAndMem);
   bmBackOld   = SelectObject(hdcBack, bmAndBack);
   bmObjectOld = SelectObject(hdcObject, bmAndObject);

   hBrOld      = SelectObject(hdcMem, hBrush);

   BitBlt(hdcTemp, 0, 0, ptSize.x, ptSize.y, hdc, rct->left, rct->top, SRCCOPY);

   SetMapMode(hdcTemp, GetMapMode(hdc));

   cColor = SetBkColor(hdcTemp, cTransparentColor);

   BitBlt(hdcObject, 0, 0, ptSize.x, ptSize.y, hdcTemp, 0, 0, SRCCOPY);

   SetBkColor(hdcTemp, cColor);

   BitBlt(hdcBack, 0, 0, ptSize.x, ptSize.y, hdcObject, 0, 0, NOTSRCCOPY);
   PatBlt(hdcMem, 0,0, ptSize.x, ptSize.y, PATCOPY);
   BitBlt(hdcMem, 0, 0, ptSize.x, ptSize.y, hdcObject, 0, 0, SRCAND);
   BitBlt(hdcTemp, 0, 0, ptSize.x, ptSize.y, hdcBack, 0, 0, SRCAND);
   BitBlt(hdcMem, 0, 0, ptSize.x, ptSize.y, hdcTemp, 0, 0, SRCPAINT);
//   BitBlt(hdc, rct->left-1, rct->top-1, ptSize.x, ptSize.y, hdcMem, 0, 0, SRCCOPY);
   BitBlt(hdc, rct->left, rct->top, ptSize.x, ptSize.y, hdcMem, 0, 0, SRCCOPY);

   DeleteObject(SelectObject(hdcMem, hBrOld));
   DeleteObject(SelectObject(hdcTemp, bmTempOld));
   DeleteObject(SelectObject(hdcMem, bmMemOld));
   DeleteObject(SelectObject(hdcBack, bmBackOld));
   DeleteObject(SelectObject(hdcObject, bmObjectOld));
   DeleteDC(hdcMem);
   DeleteDC(hdcBack);
   DeleteDC(hdcObject);
   DeleteDC(hdcTemp);
}

//---------------------------------------------------------------------------//

static HBITMAP CreateMemBitmap( HDC hDC, LPBITMAPINFO pBitmap )
{
   HBITMAP hBitmap = 0;

   if( hDC && pBitmap )
       hBitmap =  CreateDIBitmap( hDC,
                       &pBitmap->bmiHeader,
                       CBM_INIT,
                       DibBits( &pBitmap->bmiHeader ),
                       pBitmap,
                       DIB_RGB_COLORS );

   return hBitmap;
}

//---------------------------------------------------------------------------//

CLIPPER PBMPCOLORS( PARAMS ) // ( hBmpPal )
{
    LPLOGPALETTE     lpPal;
    LONG hBmpPal = _parnl( 1 );

    if( HIWORD( hBmpPal ) )
    {
        _retni( ( (LPLOGPALETTE) GlobalLock ( ( HGLOBAL ) HIWORD( hBmpPal ) ) )->palNumEntries );
        GlobalUnlock( ( HGLOBAL ) HIWORD( hBmpPal ) );
    }
    else
       _retni( 16 );

}

//---------------------------------------------------------------------------//

#define PALVERSION 0x0300   // Windows 3.0 y posteriores.

static HPALETTE near CreateDIBPalette ( LPBITMAPINFO lpbmi )
{
   LPLOGPALETTE     lpPal;
   HANDLE           hLogPal;
   HPALETTE         hPal = 0;
   int              i, wNumColors;

   if (!lpbmi )
      return 0;

   wNumColors   = wDIBColors ( (LPBITMAPINFOHEADER) lpbmi );

   if( wNumColors > 16 )
   {
      hLogPal = GlobalAlloc ( GHND, sizeof (LOGPALETTE) +
                             sizeof (PALETTEENTRY) * wNumColors );

      if( !hLogPal )
         return 0;

      lpPal = (LPLOGPALETTE) GlobalLock ( hLogPal );

      lpPal->palVersion    = PALVERSION;
      lpPal->palNumEntries = wNumColors;

      for (i = 0;  i < wNumColors;  i++)
      {
          lpPal->palPalEntry[i].peRed   = lpbmi->bmiColors[i].rgbRed;
          lpPal->palPalEntry[i].peGreen = lpbmi->bmiColors[i].rgbGreen;
          lpPal->palPalEntry[i].peBlue  = lpbmi->bmiColors[i].rgbBlue;
          lpPal->palPalEntry[i].peFlags = 0;
      }

      hPal = CreatePalette ( lpPal );
      // RegisterResource( hPal, "PAL" );

      GlobalUnlock ( hLogPal );
      GlobalFree   ( hLogPal );
   }

   return hPal;

}

//---------------------------------------------------------------------------//

LONG hPalBitmapNew( HDC hDC, LPBITMAPINFO pbmi )
{
    HBITMAP  hBitmap;
    HPALETTE hPal = 0;
    BOOL     bDestroyDC = ( hDC == 0 );
    HPALETTE oldPal;

    if( bDestroyDC )
        hDC = GetDC( 0 );

    if( wDIBColors( &pbmi->bmiHeader ) > 16 )
        hPal = CreateDIBPalette ( pbmi );

    if( hPal )
    {
        oldPal = SelectPalette( hDC, hPal, FALSE );
        RealizePalette( hDC );
    }

    hBitmap = CreateMemBitmap( hDC, pbmi );
    // RegisterResource( hBitmap, "BMP" );

    if( hPal )
    {
        SelectPalette( hDC, oldPal, TRUE );
        RealizePalette( hDC );
    }

    if( bDestroyDC )
        ReleaseDC( 0, hDC );

                    // Low, High
    return MAKELONG( hBitmap, hPal );

}

//---------------------------------------------------------------------------//

CLIPPER PALBMPREAD( PARAMS ) // ( hDC, cBitmapFile )
{
    HGLOBAL hDib = DibRead( _parc( 2 ) );

    _retnl( hPalBitmapNew( ( HDC ) _parnl( 1 ), (LPBITMAPINFO) GlobalLock( hDib ) ) );

    GlobalUnlock( hDib );
    GlobalFree( hDib );
}

//---------------------------------------------------------------------------//

CLIPPER PALBMPLOAD( PARAMS ) // ( cResourceName )
{
    HRSRC  hRes = FindResource( GetResources(),
                  IF( ISCHAR( 1 ), _parc( 1 ), MAKEINTRESOURCE( _parni( 1 ) ) ),
                  RT_BITMAP );
    HANDLE hResource = IF( hRes, LoadResource( GetResources(), hRes ), 0 );

    if( hRes )
    {
       #ifndef __FLAT__
          _retnl( hPalBitmapNew( 0, (LPBITMAPINFO) GlobalLock( hResource ) ) );
          GlobalUnlock( hResource );
          FreeResource( hResource );
       #else
          _retnl( hPalBitmapNew( 0, hResource ) );
       #endif
    }
    else
       _retnl( 0 );
}

//---------------------------------------------------------------------------//

CLIPPER PALBMPREAL( PARAMS ) // PalBmpRealize( hWnd, hPalBmp )
{
   _retni( PalBmpRealize( ( HWND ) _parnl( 1 ), _parnl( 2 ) ) );
}

//---------------------------------------------------------------------------//

void hPalBitmapDraw( HDC hDC, WORD wCol, WORD wRow, LONG hPalBmp,
                     WORD wWidth, WORD wHeight, DWORD dwRaster, BOOL bTransparent, COLORREF nColor )
{
    HDC       hDcMem;
    BITMAP    bm;
    HBITMAP   hBmpOld;
    HPALETTE  oldPal;
    WORD      nRow, nCol;
    RECT      rct;

    if( !hDC || !LOWORD( hPalBmp ) )
       return;

    if( ! dwRaster )
       dwRaster = SRCCOPY;

    _bset( ( LPBYTE ) &bm, 0, sizeof( BITMAP ) );

    GetObject( ( HDC ) LOWORD( hPalBmp ), sizeof(BITMAP), (LPSTR)&bm );

    if( wWidth && wHeight && ( bm.bmWidth != wWidth || bm.bmHeight != wHeight ) )
    {
        HPALETTE hPal    = ( HPALETTE ) HIWORD( hPalBmp );
        BITMAP  bm2;
        HBITMAP hBitmap2;
        HDC     hDcMem2;
        HPALETTE oldPal1, oldPal2;
        HBITMAP  hBmpOld2;
        int iOldMode;

        bm2 = bm;
        bm2.bmWidth      = wWidth;
        bm2.bmHeight     = wHeight;
        bm2.bmWidthBytes = ( bm2.bmWidth * bm2.bmBitsPixel + 15 ) / 16 * 2;

        hBitmap2 = CreateBitmapIndirect( &bm2 );

        hDcMem   = CreateCompatibleDC( hDC );
        hDcMem2  = CreateCompatibleDC( hDC );

        hBmpOld  = SelectObject( hDcMem, ( HGDIOBJ ) LOWORD( hPalBmp ) );
        hBmpOld2 = SelectObject( hDcMem2, hBitmap2 );

        if( hPal )
        {
            oldPal   = SelectPalette( hDC, hPal, ! IsForePalette( hPalBmp ) );
            RealizePalette( hDC );
            oldPal2  = SelectPalette( hDcMem2, hPal, FALSE );
            oldPal1  = SelectPalette( hDcMem, hPal, FALSE );
        }

        iOldMode = SetStretchBltMode( hDC, STRETCH_DELETESCANS );

        BitBlt( hDcMem2, wRow, wCol, wWidth, wHeight,
                hDcMem, 0, 0, dwRaster );

        StretchBlt( hDC, wRow, wCol, bm2.bmWidth, bm2.bmHeight,
                    hDcMem, 0, 0, bm.bmWidth, bm.bmHeight, SRCCOPY );

        SetStretchBltMode( hDC, iOldMode );

        if( hPal )
        {
            SelectPalette( hDcMem2, oldPal2, TRUE );
            SelectPalette( hDcMem, oldPal1, TRUE );
            SelectPalette( hDC, oldPal, TRUE );
        }

        SelectObject( hDcMem, hBmpOld );
        SelectObject( hDcMem2, hBmpOld2 );

        DeleteDC( hDcMem2 );
        DeleteObject( hBitmap2 );

    }
    else
    {
        hDcMem  = CreateCompatibleDC( hDC );
        hBmpOld = SelectObject( hDcMem, ( HGDIOBJ ) LOWORD( hPalBmp ) );

//        nColor  = GetPixel( hDcMem, 0, 0 );

        if( bTransparent )
           if( GetPixel( hDcMem, 0, 0 ) != GetSysColor( COLOR_BTNFACE ) )
            {
               rct.top = 0;
               rct.left = 0;
               rct.right = bm.bmWidth - 1;
               rct.bottom = bm.bmHeight -1;
               MaskRegion( hDcMem, &rct, GetPixel( hDcMem, 0, 0 ), nColor );
//                           GetSysColor( COLOR_BTNFACE ));
            }
           /*
              for( nRow = 0; nRow < bm.bmHeight; nRow++ )
                 for( nCol = 0; nCol < bm.bmWidth; nCol++ )
                    if( GetPixel( hDcMem, nCol, nRow ) == nColor )
                       SetPixel( hDcMem, nCol, nRow, GetSysColor( COLOR_BTNFACE ) );
           */

        if( HIWORD( hPalBmp ) )
        {
            oldPal   = SelectPalette( hDC, ( HGDIOBJ ) HIWORD( hPalBmp ), ! IsForePalette( hPalBmp ) );
            RealizePalette( hDC );
        }

        BitBlt( hDC, wRow, wCol, bm.bmWidth, bm.bmHeight, hDcMem, 0, 0, dwRaster );

        if( HIWORD( hPalBmp ) )
            SelectPalette( hDC, oldPal, TRUE );

        SelectObject( hDcMem, hBmpOld );
    }
    DeleteDC( hDcMem );
}

//---------------------------------------------------------------------------//

CLIPPER PALBMPDRAW( PARAMS ) // ( hDC, row, col, hPalBmp, nWidth, nHeight, nlRaster,
                     // lTransparent )
{
     hPalBitmapDraw( ( HDC ) _parnl( 1 ), _parni( 2 ), _parni( 3 ), _parnl( 4 ),
                     _parni( 5 ), _parni( 6 ), _parnl( 7 ), _parl( 8 ), _parnl( 9 ) );
}

//---------------------------------------------------------------------------//

CLIPPER PBMPWIDTH( PARAMS ) // ( ::hPalBmp )
{
    BITMAP bm;

    GetObject( ( HGDIOBJ ) LOWORD( _parnl( 1 ) ), sizeof(BITMAP), (LPSTR)&bm );

    _retni( bm.bmWidth );

}

//---------------------------------------------------------------------------//

CLIPPER PBMPHEIGHT( PARAMS ) // ( ::hPalBmp )
{
    BITMAP bm;

    GetObject( ( HGDIOBJ ) LOWORD( _parnl( 1 ) ), sizeof(BITMAP), (LPSTR)&bm );

    _retni( bm.bmHeight );
}

//---------------------------------------------------------------------------//

CLIPPER NBMPHEIGHT( PARAMS ) // ( hBitmap ) --> nHeight  // standard windows bitmap!
{
    BITMAP bm;

    GetObject( ( HBITMAP ) _parnl( 1 ), sizeof( BITMAP ), ( LPSTR ) &bm );

    _retni( bm.bmHeight );
}

//---------------------------------------------------------------------------//

CLIPPER NBMPWIDTH( PARAMS ) // ( hBitmap ) --> nWidth  // standard windows bitmap!
{
    BITMAP bm;

    GetObject( ( HBITMAP ) _parnl( 1 ), sizeof( BITMAP ), ( LPSTR ) &bm );

    _retni( bm.bmWidth );
}

//---------------------------------------------------------------------------//

CLIPPER PALBTNPAIN( PARAMS ) // ( hWnd, hPalBmp1, hPalBmp2, lPressed, lAdjust,;
                     //   hPalBmp3, lBorder, nColor )
{
    HWND hWnd       = ( HWND ) _parnl( 1 );
    LONG hPalBmp1   = _parnl( 2 );
    LONG hPalBmp2   = _parnl( 3 );
    LONG hPal;
    BOOL bPressed   = _parl( 4 );
    BOOL bAdjust    = _parl( 5 );
    LONG hPalBmp3   = _parnl( 6 );
    BOOL bBorder    = _parl( 7 );
    WORD nLabelHight= _parnl( 8 );
    WORD nMenuWidth = _parnl( 9 );
    BOOL bMenu      = _parl( 10 );
    COLORREF nColor = _parnl( 11 ); //
    RECT rct;
    BITMAP bm;
    HDC hDC         = GetDC( hWnd );
    HPEN hGray      = CreatePen( PS_SOLID, 1, GetSysColor( COLOR_BTNSHADOW ) );
    HPEN hHigh      = CreatePen( PS_SOLID, 1, GetSysColor( COLOR_BTNHIGHLIGHT ) );
    HPEN hText      = CreatePen( PS_SOLID, 1, GetSysColor( COLOR_BTNTEXT ) );
    HPEN hOldPen;


    /*
    char cadena[256];
    wsprintf( cadena, "Color=%d", nColor );
    MessageBox( 0, cadena, cadena, MB_OK );
    */

    GetClientRect( hWnd, &rct );

    if( LOWORD(nMenuWidth) )
    {
       hOldPen = SelectObject( hDC, hText );

       MoveTo( hDC, rct.right - nMenuWidth/2 + IF(bPressed,1,0) - 3 , (rct.bottom-rct.top)/2 - 2 );
       LineTo( hDC, rct.right - nMenuWidth/2 + IF(bPressed,1,0) + 2 , (rct.bottom-rct.top)/2 - 2 );
       MoveTo( hDC, rct.right - nMenuWidth/2 + IF(bPressed,1,0) - 2 , (rct.bottom-rct.top)/2 - 1 );
       LineTo( hDC, rct.right - nMenuWidth/2 + IF(bPressed,1,0) + 1 , (rct.bottom-rct.top)/2 - 1 );
       MoveTo( hDC, rct.right - nMenuWidth/2 + IF(bPressed,1,0) - 1 , (rct.bottom-rct.top)/2 );
       LineTo( hDC, rct.right - nMenuWidth/2 + IF(bPressed,1,0) , (rct.bottom-rct.top)/2 );

       if( bBorder && !bPressed )
       {

        SelectObject( hDC, hGray );

        MoveTo( hDC, rct.right - nMenuWidth - 2 + IF(bPressed,1,0) , rct.top );
        LineTo( hDC, rct.right - nMenuWidth - 2 + IF(bPressed,1,0) , rct.bottom );

        SelectObject( hDC, hHigh );
        MoveTo( hDC, rct.right - nMenuWidth - 1 + IF(bPressed,1,0) , rct.top );
        LineTo( hDC, rct.right - nMenuWidth - 1 + IF(bPressed,1,0) , rct.bottom );

       }

       SelectObject( hDC, hOldPen );

    }

    DeleteObject( hHigh );
    DeleteObject( hGray );
    DeleteObject( hText );

    if( LOWORD( hPalBmp3 ) && ! IsWindowEnabled( hWnd ) )
    {
       hPalBitmapDraw( hDC, 1, 1, hPalBmp3,
       IF( bAdjust, rct.right, 0 ), IF( bAdjust, rct.bottom, 0 ), 0, TRUE, nColor );
       rct.bottom--;
       rct.right--;
       if( bBorder )
          WindowBox( hDC, &rct );
    }
    else
    {
       if( LOWORD( hPalBmp2 ) && bBorder )
           hPal = hPalBmp2;
       else
           hPal = hPalBmp1;

       if( bPressed )
       {
          if( LOWORD( hPal ) )
          {
             GetObject( ( HGDIOBJ ) LOWORD( hPal ), sizeof( BITMAP ), ( LPSTR ) &bm );

             hPalBitmapDraw( hDC, ( ( rct.bottom - rct.top - nLabelHight ) / 2 ) - ( bm.bmHeight / 2 ) + IF( bMenu , 0 , 1 ) ,
                                  ( ( rct.right - rct.left - nMenuWidth ) / 2 ) - ( bm.bmWidth / 2 ) + IF( bMenu , 0 , 1 ), hPal,
                    IF( bAdjust, rct.right, 0 ), IF( bAdjust, rct.bottom, 0 ), 0, TRUE, nColor );
          }
          rct.bottom--;
          rct.right--;
          if( LOWORD(nMenuWidth) && bBorder )
          {
             rct.right = rct.right - nMenuWidth - 1 ;
             if( bMenu )
               WindowBox( hDC, &rct );
             else
               WindowBoxIn( hDC, &rct );
             rct.left = rct.right + 1 ;
             rct.right = rct.right + nMenuWidth + 1 ;
          }
          WindowBoxIn( hDC, &rct );
       }
       else
       {
          if( LOWORD( hPal ) )
          {
             GetObject( ( HGDIOBJ ) LOWORD( hPal ), sizeof( BITMAP ), ( LPSTR ) &bm );

             hPalBitmapDraw( hDC, ( ( rct.bottom - rct.top - nLabelHight ) / 2 ) - ( bm.bmHeight / 2 )  ,
                                  ( ( rct.right - rct.left - nMenuWidth ) / 2 ) - ( bm.bmWidth / 2 ) , hPal,
                    IF( bAdjust, rct.right, 0 ), IF( bAdjust, rct.bottom, 0 ), 0, TRUE, nColor );
          }
          rct.bottom--;
          rct.right--;
          if( bBorder )
             WindowBox( hDC, &rct );
       }
    }

    ReleaseDC( hWnd, hDC );
}

//---------------------------------------------------------------------------//

CLIPPER CompatDC() // ( hDC )
{
   _retni( CreateCompatibleDC( _parni( 1 ) ) );

}

//---------------------------------------------------------------------------//

CLIPPER CompatBmp() // ( hDC, nWidth, nHeight )
{
   _retni( CreateCompatibleBitmap( _parni( 1 ), _parni( 2 ), _parni( 3 ) ) );

}

//---------------------------------------------------------------------------//

CLIPPER BITBLT() // ( hdcDest, nXDest, nYDest, nWidth, nHeight,
                 //   hdcSrc,  nXSrc , nYSrc, dwRop )

{
   _retl( BitBlt( _parni(1), _parni(2), _parni(3), _parni(4), _parni(5),
                  _parni(6), _parni(7), _parni(8), _parnl(9) ));

}

//---------------------------------------------------------------------------//


CLIPPER StretchBLt()
{
   _retl(StretchBlt( _parni(1),_parni(2),_parni(3),_parni(4),_parni(5),
                     _parni(6),_parni(7),_parni(8),_parni(9),_parni(10),
                     _parnl(11)));

}

CLIPPER MakeMem() // hDC, nWidth, nHeight, nColor
{

 HDC     hDC           ;
 HDC     hDCMem        ;
 HBRUSH  hBrush        ;
 HBITMAP hBmp, hOldBmp ;
 int nWidth, nHeight   ;
 int nColor            ;
 RECT rct              ;

 hDC     = _parni( 1 ) ;
 nWidth  = _parni( 2 ) ;
 nHeight = _parni( 3 ) ;
 nColor  = _parni( 4 ) ;

 rct.top    =       0 ;
 rct.left   =       0 ;
 rct.bottom = nHeight ;
 rct.right  = nWidth  ;



 hDCMem  = CreateCompatibleDC( hDC );
 hBmp    = CreateCompatibleBitmap( hDC, nWidth, nHeight ) ;

 hOldBmp = SelectObject( hDCMem, hBmp ) ;

 hBrush  = CreateSolidBrush( nColor ) ;

 FillRect( hDCMem, &rct, hBrush ) ;

 SelectObject( hDCMem, hOldBmp ) ;

 DeleteObject( hBrush ) ;

 DeleteDC( hDCMem );

_retnl( hBmp );

}