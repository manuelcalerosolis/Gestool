#include <WinTen.h>
#include <Windows.h>
#include <ClipApi.h>

//----------------------------------------------------------------------------//

WORD GetWindowRows( HWND hWnd, HDC hDC, HFONT hFont, WORD nRowHeight )
{
   TEXTMETRIC tm;
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

   GetTextMetrics( hDC, &tm );
   tm.tmHeight = nRowHeight == 0 ? tm.tmHeight += 1 : nRowHeight ; // mcalero

   GetClientRect( hWnd, &rct );
   wRows = ( rct.bottom - rct.top ) / tm.tmHeight;

   if( hFont )
      SelectObject( hDC, hOldFont );

   if( bDCDestroy )
      ReleaseDC( hWnd, hDC );

   return wRows;
}

//----------------------------------------------------------------------------//

CLIPPER NWROWS( PARAMS )        // hWnd, hDC, hFont
{
   _retni( GetWindowRows( ( HWND ) _parnl( 1 ), ( HDC ) _parnl( 2 ),
                          ( HFONT ) _parnl( 3 ), ( WORD ) _parni( 4 ) ) );
}

//----------------------------------------------------------------------------//

WORD GetWindowRow( HWND hWnd, HDC hDC, WORD wGraphRow, HFONT hFont, WORD nRowHeight ) // -> wTextRow
{
   TEXTMETRIC tm;
   RECT rct;
   WORD wRow;
   BOOL bDCDestroy = FALSE;
   HFONT hOldFont;

   if( ! hDC )
   {
      bDCDestroy = TRUE;
      hDC = GetDC( hWnd );
   }

   if( hFont )
      hOldFont = SelectObject( hDC, hFont );

   GetTextMetrics( hDC, &tm );
   tm.tmHeight = nRowHeight == 0 ? tm.tmHeight += 1 : nRowHeight ; // mcalero

   GetClientRect( hWnd, &rct );
   wRow = ( wGraphRow - rct.top ) / tm.tmHeight;

   if( hFont )
      SelectObject( hDC, hOldFont );

   if( bDCDestroy )
      ReleaseDC( hWnd, hDC );

   return wRow;
}

//----------------------------------------------------------------------------//

CLIPPER NWROW( PARAMS )        // hWnd, hDC, nGraphRow, hFont, nRowHeight -> nTextRow
{
   _retni( GetWindowRow( ( HWND ) _parnl( 1 ), ( HDC ) _parnl( 2 ),
                         _parni( 3 ), ( HFONT ) _parnl( 4 ), ( WORD ) _parni( 5 ) ) );
}

//----------------------------------------------------------------------------//