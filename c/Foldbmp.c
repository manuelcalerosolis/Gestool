#include <WinTen.h>
#include <Windows.h>
#include <ClipApi.h>

#define FD_HEIGHT    22
#define FD_BORDER     4

#define FLD_BMP      26

#define CLR_BLACK           0
#define CLR_GRAY      8421504

#define SETBLACKPEN( hDC )  SelectObject( hDC, GetStockObject( BLACK_PEN ) )
#define SETWHITEPEN( hDC )  SelectObject( hDC, hWhitePen )

#ifdef __FLAT__
   ULONG __paralen( void *, ULONG ulIndex, ... );
#endif

void DrawMasked( HDC, HBITMAP, WORD, WORD );
void DrawGray( HDC, HBITMAP, WORD, WORD );
void FrameDot( HDC, LPRECT rct );

//----------------------------------------------------------------------------//

CLIPPER FLDPAINT( PARAMS ) // ( hWnd, hDC, aPrompts, hFont1, hFont2,
                           //   nClrPane, nOption, aEnable, nSize, lWin95,
                           //   aBmps, nDir, nTabClr, nFocusClr,
                           //   nAlign, nOffset ) --> nil
{
   HWND hWnd      = ( HWND ) _parni( 1 );
   HDC hDC        = ( HDC ) _parni( 2 );
   HPEN hDarkPen  = CreatePen( PS_SOLID, 1, GetSysColor( COLOR_BTNSHADOW ) );
   HPEN hWhitePen = CreatePen( PS_SOLID, 1, GetSysColor( COLOR_BTNHIGHLIGHT ) ); // RGB( 128, 128, 128 ) );
   HPEN hPen;

   #ifndef __FLAT__
   WORD wPrompts  = _VARRAYLEN( _param( 3, -1 ) );
   #else
   WORD wPrompts = __paralen( params, 3, 0 );
   #endif

   #ifndef __FLAT__
   WORD wBmps = _VARRAYLEN( _param( 11, -1 ) );
   #else
   WORD wBmps = __paralen( params, 11, 0 );
   #endif

   HFONT hFont1   = ( HFONT ) _parni( 4 );
   HFONT hFont2   = ( HFONT ) _parni( 5 );
   LONG rgbPane   = _parnl( 6 );
   WORD wOption   = _parni( 7 );
   WORD wSize     = _parni( 9 );
   BOOL bWin95    = _parl( 10 );
   WORD wWidth, wHeight, wLeft, w, t ;
   RECT rct;
   SIZE pt;
   HBITMAP hBmp;
   WORD wInc      = 10;

   LONG lTabClr   = _parnl( 13 );
   LONG lFocusClr = _parnl( 14 );
   WORD wAlign    = _parnl( 15 );
   WORD wOffset   = _parnl( 16 );

   if( ! wPrompts )
      return;

   if( wBmps )
      wInc = FLD_BMP;

   #ifdef __XPP__
      SysRefresh();   // process pending msgs
   #endif

   GetWindowRect( hWnd, &rct );
   wHeight = rct.bottom - rct.top;
   wWidth  = rct.right - rct.left;

   if( ! wWidth )
      return;

   if( ! wSize )
      wSize = wWidth / wPrompts;

   /* Not used. Keep the compiler silent */
   bWin95 = bWin95;

   SelectObject( hDC, hFont1 );

   #ifdef __FLAT__
   #define _parc( x, y )    PARC( x, params, y )
   #define _parl( x, y )    PARL( x, params, y )
   #define _parclen( x, y ) PARCLEN( x, params, y )
   #endif

   #ifndef __FLAT__
      wSize = GetTextExtent( hDC, _parc( 3, 1 ), _parclen( 3, 1 ) ) + wInc;
   #else
      GetTextExtentPoint( hDC, _parc( 3, 1 ),
        _parclen( 3, 1 ), &pt );
        wSize = pt.cx + wInc;
   #endif

   SETWHITEPEN( hDC );
   MoveTo( hDC, 0, wHeight - 1 );
   LineTo( hDC, 0, 2 + IF( wOption != 1, 2, 0 ) +
                       IF( wOffset, FD_HEIGHT - IF( wOption != 1, 4, 2 ), 0 ) );

   SETBLACKPEN( hDC );
   MoveTo( hDC, 0, wHeight - 1 );
   LineTo( hDC, wWidth, wHeight - 1 );

   SETBLACKPEN( hDC );
   MoveTo( hDC, wWidth - 1, wHeight - 1 );
   LineTo( hDC, wWidth - 1, FD_HEIGHT - 1 );

   SelectObject( hDC, hDarkPen );
   MoveTo( hDC, 1, wHeight - 2 );
   LineTo( hDC, wWidth - 2, wHeight - 2 );
   MoveTo( hDC, wWidth - 2, wHeight - 2 );
   LineTo( hDC, wWidth - 2, FD_HEIGHT - 1 );

   SETWHITEPEN( hDC );
   MoveTo( hDC, 0, FD_HEIGHT );
   LineTo( hDC, wOffset + 1, FD_HEIGHT );

   wLeft = wOffset;

   for( w = 0; w < wPrompts; w++ )
   {
      SETWHITEPEN( hDC );
      if( ( w + 1 != wOption + 1 ) )
      {
         MoveTo( hDC, wLeft, FD_HEIGHT - 1 );
         LineTo( hDC, wLeft, 3 + IF( w + 1 != wOption, 2, 0 ) );
         LineTo( hDC, wLeft + 2, 1 + IF( w + 1 != wOption, 2, 0 ) );
      }

      MoveTo( hDC, wLeft + 2 - IF( ( w + 1 == wOption + 1 ), 2, 0 ),
                   1 + IF( w + 1 != wOption, 2, 0 ) );
      LineTo( hDC, wLeft + wSize - 1 + IF( w + 1 == wOption - 1, 2, 0 ),
                   1 + IF( w + 1 != wOption, 2, 0 ) );

      if( ( w + 1 != wOption - 1 ) || ( w + 1 == wOption ) )
      {
         SETBLACKPEN( hDC );
         MoveTo( hDC, wLeft + wSize - 1, 2 + IF( w + 1 != wOption, 2, 0 ) );
         LineTo( hDC, wLeft + wSize, 3 + IF( w + 1 != wOption, 2, 0 ) );
         LineTo( hDC, wLeft + wSize, FD_HEIGHT + 1 );

         SelectObject( hDC, hDarkPen );
         MoveTo( hDC, wLeft + wSize - 1, 3 + IF( w + 1 != wOption, 2, 0 ) );
         LineTo( hDC, wLeft + wSize - 1, FD_HEIGHT );
      }

      if( w + 1 != wOption )
      {
         SETWHITEPEN( hDC );
         MoveTo( hDC, wLeft - 1 + IF( w == 0, 2, 0 ), FD_HEIGHT );
         LineTo( hDC, wLeft + wSize + IF( ( w + 1 ) < wPrompts, 2, -1 ), FD_HEIGHT );
      }
      else
      {
         SelectObject( hDC, hDarkPen );
         MoveTo( hDC, wLeft + wSize - 1, 3 );
         LineTo( hDC, wLeft + wSize - 1, FD_HEIGHT + 1 );
      }

      rct.top    = 5 + IF( w + 1 != wOption, 2, 0 );
      rct.left   = wLeft + FD_BORDER - 1;
      rct.bottom = FD_HEIGHT - 3 + IF( w + 1 != wOption, 2, 0 );
      rct.right  = wLeft + wSize - FD_BORDER + IF( wBmps, wInc / 2, 2 );

      hBmp  = ( HBITMAP ) _parnl( 11, w + 1 );
      if( hBmp )
      {
        if( _parl( 8, w + 1 ) )
           DrawMasked( hDC, hBmp, rct.top - 1, rct.left + IF( _parclen( 3, w + 1 ), 0, 2 ) );
        else
           DrawGray( hDC, hBmp, rct.top - 1, rct.left + IF( _parclen( 3, w + 1 ), 0, 2 ) );
      }

      if( _parl( 8, w + 1 ) )
      {
         if( w == wOption - 1 )
         {
            SelectObject( hDC, hFont2 );
            SetTextColor( hDC, lFocusClr );
         }
         else
         {
            SelectObject( hDC, hFont1 );
            SetTextColor( hDC, lTabClr );
         }
      }
      else
      {
         SetTextColor( hDC, CLR_GRAY );
         SelectObject( hDC, hFont1 );
      }

      SetBkColor( hDC, rgbPane );
      DrawText( hDC, _parc( 3, w + 1 ), _parclen( 3, w + 1 ),
                &rct, DT_CENTER );

      if( w == wOption - 1 )
      {
         SetTextColor( hDC, CLR_BLACK );
         t = rct.right;
         rct.right -= IF( wBmps, wInc / 2, 2 );
         --rct.top;
         FrameDot( hDC, &rct );
         rct.right = t;
         ++rct.top;
      }

      wLeft += wSize + 1;

      #ifndef __FLAT__
         wSize = GetTextExtent( hDC, _parc( 3, w + 2 ),
                                _parclen( 3, w + 2 ) ) + wInc;
      #else
         GetTextExtentPoint( hDC, _parc( 3, w + 2 ),
                             _parclen( 3, w + 2 ), &pt );
         wSize = pt.cx + wInc;
      #endif

      if( ( wLeft + wSize + 2 ) > wWidth )
         wSize = wWidth - wLeft - 2;

      if( w + 2 == wPrompts && wAlign == 2 ) //Right
         wSize = wWidth - wLeft - 1;
   }

   if( wAlign == 1 || wAlign == 3 )  //Right
   {
      SETWHITEPEN( hDC );
      MoveTo( hDC, wLeft - 1 - ( wOption != wPrompts ), FD_HEIGHT );
      LineTo( hDC, wWidth - 2, FD_HEIGHT );
   }

   SelectObject( hDC, hPen );
   DeleteObject( hDarkPen );
   DeleteObject( hWhitePen );

   SetBkColor( hDC, rgbPane );
   ReleaseDC( hWnd, hDC );
}

//----------------------------------------------------------------------------//
