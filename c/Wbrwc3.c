#include <Windows.h>

#define S_ANY          0xFFFF
#define S_UNDEF        0x0000
#define S_WORD         0x0001
#define S_LNUM         0x0002
#define S_DNUM         0x0008
#define S_LDATE        0x0020
#define S_LOG          0x0080
#define S_SYM          0x0100
#define S_ALIAS        0x0200
#define S_CHAR         0x0400
#define S_MEMO         ( 0x0800 | S_CHAR )
#define S_BLOCK        0x1000
#define S_VREF         0x2000
#define S_MREF         0x4000
#define S_ANYREF       0x6000
#define S_ARRAY        0x8000
#define S_OBJECT       S_ARRAY
#define S_ANYNUM       ( S_LNUM | S_DNUM )
#define S_ANYEXP       ( S_ANYNUM | S_CHAR | S_LDATE | S_LOG )

#define UNDEF        0
#define CHARACTER    1
#define NUMERIC      2
#define LOGICAL      4
#define DATE         8
#define ALIAS       16
#define MPTR        32      /* or'ed with type when passed by reference */
#define MEMO        64
#define ARRAY      512
#define BLOCK     1024
#define DOUBLE    2048

#define CLIPPER void pascal

#define PCOUNT()     ( _parinfo(0) )

#define ISCHAR( s )    ( _param( s, S_CHAR )   != NULL )
#define ISNUM( s )     ( _param( s, S_ANYNUM ) != NULL )
#define ISLOGICAL( s ) ( _param( s, S_LOG )    != NULL )
#define ISARRAY( s )   ( _param( s, S_ARRAY )  != NULL )
#define ISDATE( s )    ( _param( s, S_LDATE )  != NULL )
#define ISBLOCK( s )   ( _param( s, S_BLOCK )  != NULL )
#define ISBYREF( s )   ( _param( s, S_ANYREF ) != NULL )

#define HA_LEFT    0  // by CeSoTech Alineaciones Horizontales y Verticales
#define HA_RIGHT   1
#define HA_CENTER  2
#define VA_TOP     4
#define VA_BOTTOM  8
#define VA_CENTER  32

static BOOL bAdjLastCol  ; // CeSoTech
static BOOL bAdjBrowse   ; // CeSoTech
static BOOL bDrawHeaders ; // CeSoTech
static BOOL bDrawFooters ; // CeSoTech
static WORD wHeaderHeight; // CeSoTech
static WORD wFooterHeight; // CeSoTech
static WORD wLineHeight  ; // CeSoTech

static BOOL bWorking;



WORD WBrwRowsC( HWND hWnd, HDC hDC, HFONT hFont ); // CeSoTech

void FW_DrawText( HDC hDC, RECT * rct, LPCSTR pText,
                         WORD wAlign, int iLen, HFONT hFont,
                         BOOL bHeadFoot ) ; // CeSoTech
void FW_DrawBitmapCenter( HDC hDC, HBITMAP hBmp, RECT * rct, WORD nStyle, BOOL bFocused ) ;

void MaskRegion( HDC hDC, RECT * rct, COLORREF cTrColor,
                 COLORREF cBackColor );

FrameDot( HDC hDC, RECT * pRect );

extern void lMsg( long );

extern void WndDrawBox( HDC, LPRECT, HPEN, HPEN );
extern void DrawBitmap( HDC, HBITMAP, WORD wCol, WORD wRow, WORD wWidth,
                        WORD wHeight, DWORD dwRaster );

static void PaintTheLine( HDC hDC, RECT * rct, WORD wIndex,
                               void *pAtext, void *pAsizes,
                               HPEN hWhitePen, HPEN hGrayPen, BOOL bTree,
                               void *pAJustify, WORD wPressed,
                               BOOL bHeader, WORD nStyle,
                               WORD nFocus, BOOL bFocused,
                               void *pTextColor, void *pBkColor,
                               WORD wRowPos, WORD nHeightCtrl,
                               LONG nClrLine, BOOL bFooter,
                               BOOL bSelect, void *pFont,
                               BOOL bDrawFocusRect ) ;



void DrawMasked( HDC, HBITMAP, WORD wCol, WORD wRow );

void MsgStr( long l );
LPSTR Str( WORD w );

static long GetInt( void * Array, LONG wIndex );
static void *pSkip = NULL;

extern void * _tos;
extern void * _eval;
extern void * _SymEVAL;
extern short _itemGetL( void * );

extern void _put( void );
extern unsigned short _0POP( void );
extern unsigned short _xpushm( void * );
extern unsigned short _xpopm( void * );

extern unsigned short _cAt( void *, long, unsigned short, void * );
extern long _sptol( void * );
extern short _sptoq( void * );

extern long pascal _VARRAYLEN( void * );
extern char * pascal _VSTR( void * );

extern unsigned short _itemType( void * );
extern long _itemSize( void * );

extern void _putsym( void * );
extern unsigned short _xeval( unsigned short );
extern void _putln( long );

extern short _parinfo( short );
extern long  _parnl( short, ... );

extern short _parni( short, ... );
extern short _parl( short, ... );
extern void * _param( unsigned short, unsigned short );

extern unsigned short _cEval0( void * );

extern void _retl( short );

extern void _reta( long );
extern short _storni( short, short, ... );

extern void * _get_sym( char * );
extern long _parinfa( short, unsigned short );

extern void _putq( short );
extern void _retni( short );
extern unsigned short _xsend( unsigned short );

extern void nCuentame( LONG Num );

typedef struct
{
    WORD wType;
    LONG lDummy;
    WORD wWord;         // for LOGICAL clipvars -> Casting to (BOOL)
    WORD wDummy[ 3 ];
} CLV_WORD;

//---------------------------------------------------------------------------//

static void MaskRegion( HDC hdc, RECT * rct, COLORREF cTransparentColor,
                        COLORREF cBackgroundColor )

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

static long GetInt( void * Array, LONG wIndex )
{
    long iRet;
    _put();
    _cAt( Array, wIndex, S_ANY, _tos );
    iRet = _sptol( _tos );
    _0POP();

    return iRet;
}

//-----------------------------------------------------------------------=
                                                        // ÚÄ1ra Col.a Pintar
                                                        // ³
static void PaintTheLine( HDC hDC, RECT * rct, WORD wIndex,
                               void *pAtext, void *pAsizes,
                               HPEN hWhitePen, HPEN hGrayPen, BOOL bTree,
                               void *pAJustify, WORD wPressed,
                               BOOL bHeader, WORD nStyle,
                               WORD wFocus, BOOL bFocused,
                               void *pTextColor, void *pBkColor,
                               WORD wRowPos, WORD nHeightCtrl,
                               LONG nClrLine, BOOL bFooter,
                               BOOL bSelect, void *pFont,
                               BOOL bDrawFocusRect )
{
   RECT box, wholebox, rctadj;
   int iMaxRight = rct->right;

   WORD wLenJust = 0 ;
   WORD wLen     = _VARRAYLEN( pAtext );
   WORD wType, wcLen;
   LONG lValue;
   char * cValue;
   HPEN hOldPen, hPen;
   BITMAP bmp;
   WORD wRow, wCol;
   LONG lColor ;
   HBRUSH hBrush;
   LONG lTextColorOld = -1 ; // CeSoTech
   LONG lBkColorOld   = -1 ; // CeSoTech
   void * pEvalOld ;
   HFONT hFont ; // CeSoTech
   WORD wAlign ; // CeSoTech

   // CeSoTech
   LONG nClrLineC = ( nStyle == 2 || nStyle == 6 || nStyle == 8 ||
                      nStyle == 10 ) ? GetSysColor( COLOR_BTNSHADOW ) : 0 ;

   // CeSoTech
   if ( nClrLine >= 0 )   // Desde Clipper manda color especifico linea
      nClrLineC = nClrLine ;

   if ( ! bDrawHeaders )
      bHeader = FALSE ;

   if ( bFooter )
      bHeader = TRUE ; //-> Para que lo pinte con similar aspecto

   //CeSoTech
   // Si es un estilo sin separadores horizontales, pintar uno mas arriba
   //CeSoTech para que que bien completa el area !!!
   if ( ! (bHeader) && (nStyle == 0 || nStyle == 5 || nStyle == 6 ||
                        nStyle == 9 || nStyle == 10) )
      rct->top--       ;

   wholebox.top    = rct->top+1;
   wholebox.left   = rct->left;
   wholebox.bottom = rct->bottom;
   wholebox.right  = rct->right;

   rct->right  = 0;

   box.top    = rct->top ;
   box.bottom = rct->bottom - 1;

   if( !wIndex || wIndex > wLen )
       wIndex = 1;

   if ( pAJustify )
       wLenJust = _VARRAYLEN( pAJustify );

   while( wIndex <= wLen )
   {

        rct->left   = rct->right;

        rct->right  = ( wIndex == wLen ? iMaxRight
                                      : rct->left + GetInt( pAsizes, wIndex ) );

        // CeSoTech // Cuando estoy estoy en la ultima celda, NO pintar hasta
                    // el final si no existe ajuste de ultima columna.
        if ( ( wIndex == wLen ) && ( ! bAdjLastCol )  )
        {
           rct->right  = rct->left + GetInt( pAsizes, wIndex ) +( bHeader ? 1 : 0 ) ;
           if ( !bAdjBrowse )
              wholebox.right = rct->right ; // Tambien ajusto el borde focus

        }
        // CeSoTech //

        wAlign = HA_LEFT | VA_CENTER ;  // Alineacion por defecto
        wcLen = 0;
        ///////// INICIO Toma de datos celda !!!

        if ( wIndex <= wLenJust )
        {
          _put();
          //_cAt( pAJustify, wIndex, S_ANY, _tos );
          _cAt( pAJustify, wIndex, S_LOG, _tos );
          wAlign = ( WORD ) _itemGetL( _tos );
          //wAlign = _sptol( _tos ); //_sptoq( _tos );
          _0POP();
        }
        _put();
        _cAt( pAtext, wIndex, S_ANY, _tos );
        wType = _itemType( _tos );
        // aki esta er tema
        if ( wType & NUMERIC )
           lValue = _sptol( _tos );
        else if ( wType & CHARACTER )
        {
           cValue = _VSTR( _tos );
           wcLen = _itemSize( _tos );
        }

        _0POP();
        ///////// FIN Toma de datos celda !!!

        if( wFocus > 0 && wIndex != wFocus )
        {
           if( rct->right >= iMaxRight )
           {
               wIndex = wLen + 1;   // ya no pintamos m s
           }
           else
              ++wIndex;
           continue;
        }

        if( bTree || ( GetInt( pAsizes, wIndex ) > 0 ) )    //Si NO es columna oculta (x Freeze)
        {                                                   //(Es lo mismo no hacer esto,

           if( (wType & NUMERIC) && bTree )
           {
               if( lValue )
               {
                  DrawMasked( hDC, (HBITMAP) lValue, ( rct->top < 1 ? 1 : rct->top ), rct->left );
               }
           }
           else  // Si es Numerico Bmp no Tree, o , es Character !!!!
           {

               if ( pBkColor )  // Bloque de Color Fondo Celda
               {
                  _putsym( _SymEVAL );
                  _xpushm( pBkColor );
                  _putln( wRowPos );
                  _putln( wIndex );
                  _putln( bFooter ? 2 : ( bHeader ? 1 : ( bSelect ? 3 : 0 ) ) );
                  _xeval( 3 ) ;
                  if ( _parinfo( -1 ) & NUMERIC )
                    lBkColorOld = SetBkColor( hDC, _parnl( - 1 ) ) ;
               }

               if( pTextColor ) // Bloque de Color Texto Celda
               {
                  _putsym( _SymEVAL );
                  _xpushm( pTextColor );
                  _putln( wRowPos );
                  _putln( wIndex );
                  _putln( bFooter ? 2 : ( bHeader ? 1 : ( bSelect ? 3 : 0 ) ) );
                  _xeval( 3 ) ;
                  if ( _parinfo( -1 ) & NUMERIC )
                    lTextColorOld = SetTextColor( hDC, _parnl( - 1 ) ) ;
               }

               hFont = 0 ;
               if( pFont )      // Bloque de Font Celda
               {
                  _putsym( _SymEVAL );
                  _xpushm( pFont );
                  _putln( wRowPos );
                  _putln( wIndex );
                  _putln( bFooter ? 2 : ( bHeader ? 1 : ( bSelect ? 3 : 0 ) ) );
                  _xeval( 3 ) ;
                  if ( _parinfo( -1 ) & NUMERIC )
                     hFont = (HFONT) _parnl( - 1 ) ;
               }

               /////// CeSoTech ///////
               if (!bHeader) rct->top ++;

               if( wType & NUMERIC )   // Es un BitMap
               {
                  FW_DrawBitmapCenter( hDC, (HBITMAP) lValue, rct, nStyle, bSelect );
               }
               else                    // Es una Cadena
               {
                  FW_DrawText( hDC, rct,
                               ( wType & CHARACTER ) ? cValue : "",
                               wAlign, wcLen, hFont, bHeader ) ;

               }


               /////// CeSoTech restauracion de colores //////
               if ( lTextColorOld >= 0 )
               {
                  SetTextColor( hDC, lTextColorOld ) ;
                  lTextColorOld = -1 ;
               }
               if ( lBkColorOld >= 0 )
               {
                  SetBkColor( hDC, lBkColorOld ) ;
                  lBkColorOld = -1 ;
               }


               /// CeSoTech ///
               // Si hay modalidad ajustar el Browse y no hay ajuste de ultima
               // columna, deber‚ pintar hasta el final hasta cubrir toda
               // el area, hasta llegar a la derecha del control. (Col.Ficticia)
               if ( bAdjBrowse && wIndex == wLen && !bAdjLastCol &&
                    rct->right <= iMaxRight )
               {
                  rctadj.top    = rct->top;
                  rctadj.left   = rct->right ;
                  rctadj.bottom = rct->bottom;
                  rctadj.right  = wholebox.right  ;

                  if ( nStyle == 3 )
                     rctadj.top--;

                  if ( wFocus == 0 )  // Si No es CellStyle (Pinto hasta final)
                     ExtTextOut( hDC, 0, rct->top, ETO_OPAQUE, &rctadj, "", 0, 0 );

                  if ( bHeader ) // Pinto Bordes Header Falso
                   {
                      rctadj.right  = wholebox.right - 2  ;
                      rctadj.bottom = rctadj.bottom - 2 ;
                      WndDrawBox( hDC, &rctadj, hWhitePen, hGrayPen );
                      rctadj.bottom++  ;
                      rctadj.right++  ;
                      WndDrawBox( hDC, &rctadj, hWhitePen, GetStockObject( BLACK_PEN ) );

                      if ( bFooter ) // Si es Footer (Linea Negra de Arriba Foot)
                      {
                        hPen = GetStockObject( BLACK_PEN );
                        hOldPen = SelectObject( hDC, hPen );
                        MoveToEx( hDC, rctadj.left-1, rctadj.top-1, NULL );
                        LineTo( hDC, rctadj.right+1, rctadj.top-1 );
                        SelectObject( hDC, hOldPen );
                      }

                  }
               }
               /// CeSoTech Fin ///

               if (!bHeader) rct->top --;
           }

           box.left   = rct->left;

           box.right  = ( wIndex < wLen && rct->right <= iMaxRight ?
                                                        rct->right - 1 :
                                                        iMaxRight - 1 );

           // CeSoTech // El Borde derecho de Box de la ultima columna,
                       // no estirarlo cuando no exista ajuste de ultima columna
                       // PERO cuando nLineStyle (nStyle) es 7/8 (Lineas Horiz)
                       // queda anti-estetico cortar los renglones, cuando no hay
                       // ajuste ult.col. y hay ajuste de browse. Por ello
                       // se verificara que para cortar el borde no se de esta
                       // condicion.
           if ( ( wIndex == wLen ) && ( ! bAdjLastCol ) )
           {
              if (! (!bHeader && (nStyle==7 || nStyle==8) && !bAdjLastCol && bAdjBrowse) )
               box.right  = rct->left + GetInt( pAsizes, wIndex ) - 1 ;
           }

           if( ! bTree )
           {
              WndDrawBox( hDC, &box, hGrayPen, hWhitePen );
           }
           else
           {
              if( ! ( wType & NUMERIC ) )
              {
                 box.left -= 16;
              }
           }

          // CeSoTech if( bFocused && wFocus > 0 && wIndex == wFocus )
           if( bDrawFocusRect && bFocused && wFocus > 0 &&
               wIndex == wFocus && nStyle != 3)
           {
            rct->left++;
            rct->top++;
            DrawFocusRect( hDC, rct );
            rct->left--;
            rct->top--;
           }

        }

        if( rct->right >= iMaxRight )
        {
            wIndex = wLen + 1;   // ya no pintamos m s
        }
        else
           ++wIndex;


   }

   if (bDrawFocusRect && !bTree && bFocused && wFocus==0 && nStyle!=3) // CeSoTech
      DrawFocusRect( hDC, &wholebox );

}

//---------------------------------------------------------------------------//
CLIPPER WBRWSELBOX( void ) // ( hWnd, hDC, nRow, nFirstCol, nCurCol,;
                             //   lFocus, aSizes, hFont)
{
   HWND hWnd        = (HWND) _parnl( 1 );
   HDC hDC          = (HDC) _parnl( 2 );
   WORD wRow        = _parni( 3 );
   WORD wIndex      = _parni( 4 );
   WORD wCol        = _parni( 5 );
   BOOL bFocused    = _parl( 6 );
   void * pAsizes   = _param( 7, S_ANY );
   HFONT hFont      = (HFONT) _parnl( 8 );
   BOOL bDestroyDC  = FALSE;
   TEXTMETRIC tm;
   RECT rct;
   HFONT hOldFont;

   if( ! hDC )
   {
      bDestroyDC = TRUE;
      hDC = GetDC( hWnd );
   }

   if( hFont )
      hOldFont = SelectObject( hDC, hFont );

   GetClientRect( hWnd, &rct );
   GetTextMetrics( hDC, &tm );

   if( hFont )
      SelectObject( hDC, hOldFont );

   tm.tmHeight += 1;

   if ( ! bDrawHeaders )  // By CeSoTech
      wRow-- ;

   rct.top    = tm.tmHeight * wRow ;
   rct.bottom = tm.tmHeight * ( wRow + 1) - 1;
   rct.left   = 0;

   while( wIndex < wCol )
      rct.left  += GetInt( pAsizes, wIndex++ );

   rct.right  =  rct.left+GetInt( pAsizes, wCol ) - 1;

   MaskRegion( hDC, &rct, GetBkColor( hDC ), GetSysColor(COLOR_ACTIVECAPTION) );

   if( bFocused )
      DrawFocusRect( hDC, &rct );

   if( bDestroyDC )
      ReleaseDC( hWnd, hDC );
}

//---------------------------------------------------------------------------//
CLIPPER WBRWLINE( void ) // ( hWnd, hDC, nRow, aText, aSizes, nFirstItem, ;
                           // nClrFore, nClrBack, hFont, lTree, aJustify, nPressed,
                           // nStyle, nColAct, lFocused )
                           // bTextColor, bBkColor, nClrLine, lFooter, lSelect,
                           // bFont, lDrawFocusRect ) // New's by CesoTech

{
   HWND hWnd        = (HWND) _parnl( 1 );
   HDC hDC          = (HDC) _parnl( 2 );
   WORD wRow        = _parni( 3 );
   BOOL bDestroyDC  = FALSE;
   WORD wHeight;
   RECT rct, box;
   void * bClrFore;
   void * bClrBack;
   COLORREF clrFore = 0;
   COLORREF clrBack = 0;
   HPEN hGrayPen    ;
   HPEN hWhitePen   ;
   HFONT hFont      = (HFONT) _parnl( 9 );
   HFONT hOldFont;
   BOOL bTree       = _parl( 10 );
   BOOL bFooter     = ISLOGICAL( 19 ) ? _parl( 19 ) : FALSE ;  // CeSoTech

   WORD nHeightCtrl ; // by CeSoTech

   hGrayPen    = CreatePen( PS_SOLID, 1, GetSysColor( COLOR_BTNSHADOW ) ) ; // RGB( 128, 128, 128 ) );
   hWhitePen   = CreatePen( PS_SOLID, 1, GetSysColor( COLOR_BTNHIGHLIGHT ) ); // GetStockObject( WHITE_PEN );

   if( PCOUNT() > 6 )
   {
      if( ISBLOCK( 7 ) )
      {
         bClrFore = _param( 7, -1 );
         _cEval0( bClrFore );
         clrFore = _parnl( -1 );
      }
      else
      {
         clrFore = _parnl( 7 );
      }
   }

   if( PCOUNT() > 7 )
   {
      if( ISBLOCK( 8 ) )
      {
         bClrBack = _param( 8, -1 );
         _cEval0( bClrBack );
         clrBack = _parnl( -1 );
      }
      else
      {
         clrBack = _parnl( 8 );
      }
   }

   if( ! hDC )
   {
      bDestroyDC = TRUE;
      hDC = GetDC( hWnd );
   }

   if( hFont )
      hOldFont = SelectObject( hDC, hFont );

   GetClientRect( hWnd, &rct );

   nHeightCtrl = rct.bottom-rct.top ; // by CeSoTech

   SetTextColor( hDC, clrFore );
   SetBkColor( hDC, clrBack );

   wHeight = wLineHeight + 1 ;

   if ( ( wRow == 0 ) && bDrawHeaders )  // Es una Cabecera
      wHeight = wHeaderHeight + 1 ;

   if ( ! bFooter )
   {
      if ( ( wRow == 0 ) && bDrawHeaders )  // Es una Cabecera
      {
         rct.top    = 0 ;
         rct.bottom = wHeaderHeight + 1 ;
      }
      else
      {
        rct.top    = ( bDrawHeaders ? wHeaderHeight+1 : 0 ) + (wHeight * (wRow-1) )  ;
        rct.bottom = ( bDrawHeaders ? wHeaderHeight+1 : 0 ) + (wHeight * wRow)  ;
      }

   } else {
      rct.top    = rct.bottom - (wFooterHeight+1) ;
   }

   rct.left   = 0;

   PaintTheLine( hDC, &rct, _parni( 6 ), _param( 4, -1 ), _param( 5, -1 ),
                 hWhitePen, hGrayPen, bTree,
                 ISARRAY(11) ? _param( 11, -1 ) : 0, _parni( 12 ),
                 (wRow == 0), _parni( 13 ),
                 _parni( 14 ), _parl( 15 ),
                 ISBLOCK( 16 ) ? _param( 16, -1 ) : 0,   // CeSoTech
                 ISBLOCK( 17 ) ? _param( 17, -1 ) : 0,   // CeSoTech
                 wRow, nHeightCtrl,                      // CeSoTech
                 ISNUM( 18 ) ? _parnl( 18 ) : -1,        // CeSoTech
                 bFooter,                                // CeSoTech
                 ISLOGICAL( 20 ) ? _parl( 20 ) : FALSE,  // CeSoTech
                 ISBLOCK( 21 ) ? _param( 21, -1 ) : 0,   // CeSoTech
                 ISLOGICAL( 22 ) ? _parl( 22 ) : FALSE );// CeSoTech

   DeleteObject( hGrayPen );
   DeleteObject( hWhitePen );

   if( hFont )
      SelectObject( hDC, hOldFont );

   if( bDestroyDC )
       ReleaseDC( hWnd, hDC );

   _reta( 2 );
   _storni( rct.top,    -1, 1 );
   _storni( rct.bottom, -1, 2 );

}

//---------------------------------------------------------------------------//
CLIPPER AWBRWROWDIM( void )

{
   HWND hWnd      = (HWND) _parnl( 1 );
   WORD wRow      = (WORD) _parnl( 2 );
   HFONT hFont    = (HFONT) _parnl( 3 );
   HFONT hOldFont;
   HDC  hDC       = GetDC( hWnd );
   TEXTMETRIC tm;

   if( hFont )
      hOldFont = SelectObject( hDC, hFont );

   GetTextMetrics( hDC, &tm );
   tm.tmHeight += 1;

   if( hFont )
      SelectObject( hDC, hOldFont );

   ReleaseDC( hWnd, hDC );

   _reta( 2 );
   _storni( tm.tmHeight * wRow++, -1, 1 );
   _storni( tm.tmHeight * wRow,   -1, 2 );
}

//---------------------------------------------------------------------------//

WORD SCREENBASEX( WORD wX )
{
    return 4 * wX / LOWORD( GetDialogBaseUnits() );
}

//---------------------------------------------------------------------------//

WORD SCREENBASEY( WORD wY )
{
    return 8 * wY / HIWORD( GetDialogBaseUnits() );
}


//---------------------------------------------------------------------------//
CLIPPER WBRWRECT( void ) // ( hWnd, nRow, aSizes, nFirstItem, nCol,
                           //   nLineStyle, nWidthVScroll )
{
   HWND hWnd        = ( HWND ) _parnl( 1 );

   HDC hDC          = GetDC( hWnd );
   WORD wRow        = _parni( 2 );
   WORD wHeight ;
   RECT rct;
   WORD nStyle = ISNUM( 6 ) ? _parni( 6 ) : -1 ; // CeSoTech


   void * paSizes   = _param( 3, S_ARRAY );
   WORD wLen        = _VARRAYLEN( paSizes );
   WORD wIndex      = _parni( 4 );
   WORD wCol        = _parni( 5 );
   WORD wMaxRight;
   LONG l;

   if( !wCol || wCol > wLen )
        return;


   GetWindowRect( hWnd, &rct );
   wMaxRight = rct.right - 2;

   wHeight = wLineHeight + 1 ;

   rct.top    = rct.top + ( bDrawHeaders ? wHeaderHeight+1 : 0 ) +
                (wHeight * (wRow-1) ) ;


   rct.bottom = rct.top + wHeight;
   rct.right  = rct.left;

   while( wIndex <= wCol )
   {
        rct.left   = rct.right;
        rct.right  = ( wIndex == wLen && bAdjLastCol ? wMaxRight
                                         : rct.left + GetInt( paSizes, wIndex ) );

        if( rct.right >= wMaxRight )
        {
            wIndex = wCol + 1;   // ya no pintamos m s
            rct.right = wMaxRight;
        }
        else
            wIndex++;
   }



   ReleaseDC( hWnd, hDC );

   _reta( 4 );

   // Si es un estilo sin separadores horizontales, pintar uno mas arriba
   //CeSoTech para que que bien completa el area !!!
   if (nStyle == 0 || nStyle == 5 || nStyle == 6 || nStyle == 9 || nStyle == 10)
      rct.top-- ;  // Las coord.de edicion deberan ser mas arriba tambien !!!


   _storni( rct.top,    -1, 1 );
   _storni( rct.left,   -1, 2 );
   _storni( rct.bottom, -1, 3 );
   _storni( ( wMaxRight <= rct.right ) ?
              wMaxRight - _parni( 7 ) : rct.right, -1, 4 );
}

//---------------------------------------------------------------------------//
CLIPPER WBRWPANE( void ) // ( hWnd, hDC, Self, bLine, aSizes, nFirstItem,
                           //   nClrFore, nClrBack, hFont, aJustify, nStyle
                           //   lCellStyle, lFocused ) -> nRowsSkipped
                           //   bTextColor, bBkColor, nClrLine, nColorFondo, bFont ) // New's by CesoTech
{
   HWND hWnd        = ( HWND ) _parnl( 1 );
   HDC hDC          = ( HDC ) _parnl( 2 );
   WORD wRows;
   WORD wLastBottom = 0;
   WORD wRow        = 1;
   WORD wSkipped    = 1;
   void * Self    = _param( 3, -1 );
   void * bLine   = _param( 4, -1 );
   void * pASizes = _param( 5, -1 );
   HFONT hFont      = ( HFONT ) _parnl( 9 );
   HFONT hOldFont;
   BOOL bDestroyDC  = FALSE;
   WORD wHeight ;
   RECT rct, box, client;
   WORD wIndex      = _parni( 6 );
   void * bClrFore = 0;
   void * bClrBack = 0;
   COLORREF clrFore = 0;
   COLORREF clrBack = 0;
   HPEN hGrayPen    = CreatePen( PS_SOLID, 1, GetSysColor( COLOR_BTNSHADOW ) ) ; // RGB( 128, 128, 128 ) );
   HPEN hWhitePen   = CreatePen( PS_SOLID, 1, GetSysColor( COLOR_BTNHIGHLIGHT ) ); // GetStockObject( WHITE_PEN );

   BOOL bColBlock   = ( _itemType( pASizes ) & BLOCK );

   void * pAJustify = ISARRAY( 10 ) ? _param( 10, -1 ): 0;
   WORD nHeightCtrl ; // by CeSoTech
   WORD nStyle = _parni( 11 );

   if( PCOUNT() > 6 )
   {
      if( ISBLOCK( 7 ) )
         bClrFore = _param( 7, -1 );
      else
         clrFore = _parnl( 7 );
   }

   if( PCOUNT() > 7 )
   {
      if( ISBLOCK( 8 ) )
      {
         bClrBack = _param( 8, -1 );
         _cEval0( bClrBack );
         clrBack = _parnl( -1 );
      }
      else
         clrBack = _parnl( 8 );
   }

   if( ! hDC )
   {
      bDestroyDC = TRUE;
      hDC = GetDC( hWnd );
   }

   if( ! pSkip )
       pSkip = _get_sym( "SKIP" );

   if( hFont )
      hOldFont = SelectObject( hDC, hFont );

   /////////////////////////
   // Borremos el Area de la derecha no coubierta
   if ( !bAdjBrowse && !bAdjLastCol )
   {
       GetClientRect( hWnd, &rct );
       SetBkColor( hDC, _parnl( 17 ) ) ;

       for( wIndex=wIndex ; wIndex <= (WORD) _parinfa( 5, NULL); wIndex++ )
       {
            rct.left += _parni( 5, wIndex ) ;
       }

       if ( !(nStyle == 0 || nStyle == 7 || nStyle == 8 || nStyle == 3) )
          rct.left++;

       ExtTextOut( hDC, rct.left, rct.top, ETO_OPAQUE | ETO_CLIPPED,
                   &rct, "", 0, 0 );

       wIndex = _parni( 6 );
       GetClientRect( hWnd, &rct );
   }
   /////////////////////////

   GetClientRect( hWnd, &client );

   nHeightCtrl = client.bottom-client.top ; // by CeSoTech

   wHeight = wLineHeight + 1 ;

   wRows = WBrwRowsC( hWnd, hDC, hFont );

   if( ! bClrFore )
      SetTextColor( hDC, clrFore );
      SetBkColor( hDC, clrBack );

   while( wRow <= wRows && wSkipped == 1 )
   {
      rct.top    = client.top + ( bDrawHeaders ? wHeaderHeight+1 : 0 ) +
                   (wHeight * (wRow-1) ) ;

      rct.bottom = rct.top + wHeight;
      rct.left   = 0;
      rct.right  = client.right;

      _cEval0( bLine );
      _xpushm( _eval );

      if( bClrFore )
      {
         _cEval0( bClrFore );
         SetTextColor( hDC, _parnl( -1 ) );
      }

      if( bClrBack )
      {
         _cEval0( bClrBack );
         SetBkColor( hDC, _parnl( -1 ) );
      }

      if( bColBlock )
         _cEval0( pASizes );

      PaintTheLine( hDC, &rct, wIndex, _tos,
                    ( bColBlock ? _eval : pASizes ),
                    hWhitePen, hGrayPen,
                    bColBlock, pAJustify, 0, FALSE, _parni( 11 ),
                    _parni ( 12 ), _parl( 13 ),
                    ISBLOCK( 14 ) ? _param( 14, -1 ) : 0,   // CeSoTech
                    ISBLOCK( 15 ) ? _param( 15, -1 ) : 0,   // CeSoTech
                    wRow, nHeightCtrl,                      // CeSoTech
                    ISNUM( 16 ) ? _parnl( 16 ) : -1,        // CeSoTech
                    FALSE, FALSE,                           // CeSoTech
                    ISBLOCK( 18 ) ? _param( 18, -1 ) : 0,   // CeSoTech
                    FALSE ) ;

      _0POP();

      _putsym( pSkip );
      _xpushm( Self );
      _putq( 1 );
      _xsend( 1 );

      wLastBottom = rct.bottom ;
      wSkipped = _parni( -1 );

      if( wSkipped == 1 )
          wRow++;
   }

   ////////////////////////
   // Borremos el Area de Abajo no cubierta
   GetClientRect( hWnd, &rct );
   SetBkColor( hDC, _parnl( 17 ) ) ;

   rct.top = wLastBottom + 1 ;
   if ( wLastBottom == 0 ) // No Mostro Registros
      rct.top = ( bDrawHeaders ? wHeaderHeight+1 : 0 ) ;

   rct.bottom-=  1 + ( bDrawFooters ? wFooterHeight+1 : 0 ) ;

   if (nStyle == 0 || nStyle == 5 || nStyle == 6 ||
       nStyle == 9 || nStyle == 10 || nStyle == 3 )
      rct.top--;

   if ( !bDrawFooters )
      rct.bottom++;


   if ( rct.top < rct.bottom )
   {
      ExtTextOut( hDC, rct.left, rct.top, ETO_OPAQUE | ETO_CLIPPED,
                  &rct, "", 0, 0 );
   }
   ////////////////////////

   DeleteObject( hGrayPen );
   DeleteObject( hWhitePen );

   if( hFont )
      SelectObject( hDC, hOldFont );

   if( bDestroyDC )
       ReleaseDC( hWnd, hDC );

   _retni( wRow );

}


//---------------------------------------------------------------------------//
CLIPPER WBRWSET() // ( lAdjLastCol, lAdjBrowse, lDrawHeaders, lDrawFooters )
{                                                                  // CeSoTech
    bAdjLastCol  =  _parl( 1 ) ; // Ajuste o no de ultima columna al control.
    bAdjBrowse   =  _parl( 2 ) ; // Ajuste del Browse a la derecha
                                 // cuando no existe ajuste de ultima columna.
    bDrawHeaders = _parl( 3 )  ; // Si quiere visualizar Headers !!!
    bDrawFooters = _parl( 4 )  ; // Si se quiere visualizar Footers !!!

    wHeaderHeight= _parni( 5 )  ;
    wFooterHeight= _parni( 6 )  ;
    wLineHeight  = _parni( 7 )  ;

}

//----------------------------------------------------------------------------//
// Devuelve Nro. de Filas de Datos (No incluye Headers ni Footers)
static WORD WBrwRowsC( HWND hWnd, HDC hDC, HFONT hFont )
{
   WORD wHeight;
   RECT rct;
   WORD wRows;
   BOOL bDCDestroy = FALSE;
   HFONT hOldFont;

   if( ! hDC )
   {
      bDCDestroy = TRUE;
      hDC = GetDC( hWnd );
   }

   if( hFont )
      hOldFont = SelectObject( hDC, hFont );

   wHeight = wLineHeight + 1 ;

   GetClientRect( hWnd, &rct );
   wRows = ( ( rct.bottom - rct.top - 2 ) -
             ( bDrawHeaders ? wHeaderHeight+1 : 0 ) -
             ( bDrawFooters ? wFooterHeight+1 : 0 ) ) / wHeight ;

   if( hFont )
      SelectObject( hDC, hOldFont );

   if( bDCDestroy )
      ReleaseDC( hWnd, hDC );

   return wRows;
}

//----------------------------------------------------------------------------//

CLIPPER WBRWROWS( void ) // ( hWnd, hDC, hFont )
{
   _retni( WBrwRowsC( ( HWND ) _parnl( 1 ), ( HDC ) _parnl( 2 ),
                      ( HFONT ) _parnl( 3 ) ) );
}
//----------------------------------------------------------------------------//

CLIPPER WBRWSCRL( void ) // ( hWnd, nRows, hFont, nLineStyle )
{
   HWND hWnd   = ( HWND ) _parnl( 1 );
   int wRows  = _parni( 2 );
   HFONT hFont = ( HFONT ) _parnl( 3 );
   HFONT hOldFont;
   HDC hDC     = GetDC( hWnd );
   RECT rct;
   WORD nStyle = _parni( 4 );

   if( hFont )
      hOldFont = SelectObject( hDC, hFont );

   GetClientRect( hWnd, &rct );

   if ( bDrawHeaders )
      rct.top += wHeaderHeight+1 ;


   // Defino Bottom de Area del Scroll
   rct.bottom = ( WBrwRowsC( hWnd, hDC, hFont ) * (wLineHeight+1) ) +
                ( bDrawHeaders ? wHeaderHeight+1 : 0 )  ;


   // Si es un estilo sin separadores horizontales, pintar uno mas arriba
   // CeSoTech para que que bien completa el area !!!
   // El Area Scroll deber  entonces no tomar el separator (forma parte de ant)
   if ( !(nStyle == 0 || nStyle == 5 || nStyle == 6 ||
          nStyle == 9 || nStyle == 10 || nStyle == 3 ) )
      rct.bottom++;   // Debe tomarse dado que no pinta celda 1 una mas arriba

   ScrollWindowEx( hWnd, 0, -( (wLineHeight+1) * wRows ), 0, &rct, 0, 0, 0 );

   if( hFont )
      SelectObject( hDC, hOldFont );

   ReleaseDC( hWnd, hDC );
}

//----------------------------------------------------------------------------//
CLIPPER WBRWHEIGHT( void ) // ( hWnd, hFont )
{
   HWND hWnd   = ( HWND ) _parnl( 1 );
   HFONT hFont = ( HFONT ) _parnl( 2 );
   HFONT hOldFont;
   HDC hDC     = GetDC( hWnd );
   TEXTMETRIC tm;

   if( hFont )
      hOldFont = SelectObject( hDC, hFont );

   GetTextMetrics( hDC, &tm );
   _retni( tm.tmHeight ) ;

   if( hFont )
      SelectObject( hDC, hOldFont );

   ReleaseDC( hWnd, hDC );
}

//----------------------------------------------------------------------------//
void FW_DrawText( HDC hDC, RECT * rct, LPCSTR pText,
                         WORD wAlign, int iWidth,
                         HFONT hFont, BOOL bHeadFoot )

{
   RECT rcttmp     ;
   int iHeight     ;
   UINT uiFlag     ;
   HFONT hOldFont  ;
   int iFactor     ;

   if( hFont )
      hOldFont = SelectObject( hDC, hFont );

   /////////////////////////////
   // Alineaciones Verticales //
   /////////////////////////////
   iHeight = DrawText( hDC, pText, iWidth, &rcttmp, DT_CALCRECT ) ;
   iFactor = ( ( rct->bottom - rct->top ) - iHeight ) / 2 ;

   if ( wAlign & VA_TOP )
      iFactor = 0 ;

   if ( wAlign & VA_BOTTOM )
   {
      iFactor = ( rct->bottom - rct->top ) - iHeight - ( bHeadFoot ? 1 : 0 ) ;
   }


   rcttmp.top    = rct->top + iFactor ;
   rcttmp.bottom = rct->bottom ;
   rcttmp.left   = rct->left   ;
   rcttmp.right  = rct->right ;

   if ( rcttmp.top < rct->top )
     rcttmp.top = rct->top ;

   ///////////////////////////////
   // Alineaciones Horizontales //
   ///////////////////////////////
   uiFlag = DT_LEFT ;
   rcttmp.left+= 2 ;

   if ( wAlign & HA_CENTER )
   {
     rcttmp.left-= 2 ;
     uiFlag = DT_CENTER ;
   }

   if ( wAlign & HA_RIGHT )
   {
     rcttmp.left-= 2 ;
     uiFlag = DT_RIGHT ;
     rcttmp.right-= 2 + ( bHeadFoot ? 1 : 0 ) ;
   }

   ExtTextOut( hDC, 0, 0, ETO_OPAQUE | ETO_CLIPPED, rct, "", 0, 0 ) ;
   DrawText( hDC, pText, iWidth, &rcttmp, uiFlag | DT_NOPREFIX ) ;

   if( hFont )
      SelectObject( hDC, hOldFont );

}
//----------------------------------------------------------------------------//

void FW_DrawBitmapCenter( HDC hDC, HBITMAP hBmp, RECT * rct, WORD nStyle, BOOL bSelect )
{
   WORD wWidth   ;
   WORD wHeight  ;
   WORD wRow ;
   WORD wCol ;
   BITMAP bm;
   LONG lBkColorBMP, lBkColor = GetBkColor( hDC );
   BOOL bFlag = FALSE ;

   if ( (nStyle == 0 || nStyle == 3 || nStyle == 5 ||
         nStyle == 6 || nStyle == 9 || nStyle == 10) && bSelect )
   {
      rct->bottom-- ;
      bFlag = TRUE ;
   }

   wWidth  = rct->right - rct->left ;
   wHeight = rct->bottom - rct->top ;
   GetObject( hBmp, sizeof( BITMAP ), ( LPSTR ) &bm );

   if ( wHeight > bm.bmHeight )
   {
      wRow = rct->top + ( ( wHeight - bm.bmHeight ) / 2 ) ;
      wHeight = bm.bmHeight ;
   } else
   {
      wRow = rct->top ;
   }

   if ( wWidth > bm.bmWidth )
   {
      wCol = rct->left + ( ( wWidth - bm.bmWidth ) / 2 ) ;
      wWidth = bm.bmWidth ;
   } else
   {
      wCol = rct->left ;
   }

   rct->bottom++;
   ExtTextOut( hDC, 0, rct->top, ETO_OPAQUE, rct, "", 0, 0 );
   rct->bottom--;

   if ( hBmp > 0 )
   {
      DrawBitmap( hDC, hBmp, wRow, wCol, wWidth, wHeight, 0 ) ;
      if( ( lBkColorBMP = GetPixel( hDC, wCol, wRow ) ) != lBkColor)
           MaskRegion( hDC, rct, lBkColorBMP, lBkColor );
   }

   if (bFlag)
      rct->bottom++ ;


}

//----------------------------------------------------------------------------//

void __pascal LAND( void )
{
   _retl( ( _parnl( 1 ) & _parnl( 2 ) ) != 0 );
}
