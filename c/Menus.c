#include <WinTen.h>
#include <Windows.h>
#include <ClipApi.h>

#define  ISNIL( c )      ( ( _lbase + c + 1 )->wType & NIL )

BOOL bStrAt( BYTE bChar, LPSTR szText );
LPSTR StrToken( LPSTR szText, WORD wOcurrence, BYTE bSeparator, LPWORD pwLen );

void WindowBoxIn( HDC hDC, RECT * pRect );
void WndDrawBox( HDC hDC, RECT * rct, HPEN hPUpLeft, HPEN hPBotRit );
void WindowInset( HDC hDC, RECT * pRect );
void WindowRaised( HDC hDC, RECT * pRect );
void DrawBitmap( HDC, HBITMAP, WORD, WORD, WORD, WORD, DWORD );
void DrawMasked( HDC, HBITMAP, WORD, WORD );
void DrawGrayed( HDC, HBITMAP, WORD, WORD );
void RectDisable( HDC, LPRECT );

//----------------------------------------------------------------------------//

CLIPPER CREATEMENU( PARAMS )
{
   _retnl( ( LONG ) CreateMenu() );
}

//----------------------------------------------------------------------------//

CLIPPER CREATEPOPU( PARAMS )
{
   _retnl( ( LONG ) CreatePopupMenu() );
}

//----------------------------------------------------------------------------//

CLIPPER TRACKPOPUP( PARAMS )
{
  _retl( TrackPopupMenu( ( HANDLE ) _parnl( 1 ), _parni( 2 ), _parni( 4 ),
         _parni( 3 ), _parni( 5 ), ( HANDLE ) _parni( 6 ), NULL ) );
}

//----------------------------------------------------------------------------//

CLIPPER ENABLEMENU( PARAMS )   // ITEM()
{
   _retl( EnableMenuItem( ( HMENU ) _parnl( 1 ), _parni( 2 ), _parni( 3 ) ) );
}

//----------------------------------------------------------------------------//

CLIPPER CHECKMENUI( PARAMS )   // TEM()
{
   _retl( CheckMenuItem( ( HMENU ) _parnl( 1 ), _parni( 2 ), _parni( 3 ) ) );
}

//----------------------------------------------------------------------------//

CLIPPER GETMITEMCO( PARAMS )   // UNT()
{
   _retni( GetMenuItemCount( ( HMENU ) _parnl( 1 ) ) );
}

//----------------------------------------------------------------------------//

CLIPPER GETMITEMID( PARAMS )    // hMenu, nPos
{
   _retni( GetMenuItemID( ( HMENU ) _parnl( 1 ), _parni( 2 ) ) );
}

//----------------------------------------------------------------------------//

CLIPPER GETSYSTEMM( PARAMS )    // ENU()
{
   _retnl( ( LONG ) GetSystemMenu( ( HMENU ) _parnl( 1 ), _parl( 2 ) ) );
}

//----------------------------------------------------------------------------//

CLIPPER DESTROYMEN( PARAMS )   //  U()   hMenu
{
   _retl( DestroyMenu( ( HMENU ) _parnl( 1 ) ) );
}

//----------------------------------------------------------------------------//

CLIPPER GETSUBMENU( PARAMS )    // hMenu, nPos
{
   _retnl( ( LONG ) GetSubMenu( ( HMENU ) _parnl( 1 ), _parni( 2 ) ) );
}

//----------------------------------------------------------------------------//

CLIPPER GETMENUSTR( PARAMS )    // ING()   hMenu, nId, nPosOrValue
{
   BYTE bBuffer[ 200 ];
   WORD wLen = GetMenuString( ( HMENU ) _parnl( 1 ), _parni( 2 ), bBuffer, 199,
                              _parni( 3 ) );

   _retclen( bBuffer, wLen );
}

//----------------------------------------------------------------------------//

CLIPPER GETMENUSTA( PARAMS )    // TE()   hMenu, nId, nFlags
{
   _retni( GetMenuState( ( HMENU ) _parnl( 1 ), _parni( 2 ), _parni( 3 ) ) );
}

//----------------------------------------------------------------------------//

CLIPPER DRAWMENUBA( PARAMS )    // R()    hWnd
{
   DrawMenuBar( ( HWND ) _parnl( 1 ) );
}

//----------------------------------------------------------------------------//

CLIPPER HILITEMENU( PARAMS )  // ITEM()  hWnd, hMenu, idItem, nHiliteFlags
{
   _retl( HiliteMenuItem( ( HWND ) _parnl( 1 ), ( HMENU ) _parnl( 2 ),
                          _parni( 3 ), _parni( 4 ) ) );
}

//----------------------------------------------------------------------------//

CLIPPER LOADMENU( PARAMS )
{
   _retnl( ( LONG ) LoadMenu( ( HANDLE ) _parnl( 1 ),
                     ( LPSTR ) IF( ISCHAR( 2 ), _parc( 2 ),
                                   MAKEINTRESOURCE( _parni( 2 ) ) ) ) );
}

//----------------------------------------------------------------------------//

CLIPPER APPENDMENU( PARAMS )
{
   _retl( AppendMenu( ( HMENU ) _parnl( 1 ), ( UINT ) _parni( 2 ), _parni( 3 ),
                    IF( ISCHAR( 4 ), _parc( 4 ), ( LPSTR ) _parnl( 4 ) ) ) );
}

//----------------------------------------------------------------------------//

CLIPPER SETMENU( PARAMS )
{
   _retl( SetMenu( ( HWND ) _parnl( 1 ), ( HMENU ) _parnl( 2 ) ) );
}

//----------------------------------------------------------------------------//

CLIPPER MODIFYMENU( PARAMS )
{
   _retl( ModifyMenu( ( HMENU ) _parnl( 1 ), ( UINT ) _parni( 2 ),
          _parni( 3 ), ( UINT ) _parni( 4 ),
          IF( ISCHAR( 5 ), _parc( 5 ), ( LPSTR ) _parnl( 5 ) ) ) );
}

//----------------------------------------------------------------------------//

CLIPPER INSERTMENU( PARAMS ) // ( hMenu, nIdItem, nFlags, nNewItem, cPrompt ) --> lSuccess
{
   _retl( InsertMenu( ( HMENU ) _parnl( 1 ), _parni( 2 ), _parni( 3 ),
                      _parni( 4 ), _parc( 5 ) ) );
}

//----------------------------------------------------------------------------//

CLIPPER REMOVEMENU( PARAMS ) // ( hMenu, nItem, nFlags ) --> lSuccess
{
   _retl( RemoveMenu( ( HMENU ) _parnl( 1 ),
                      ( UINT ) _parni( 2 ),
                      ( UINT ) _parni( 3 ) ) );
}

//----------------------------------------------------------------------------//

CLIPPER MENUDRAWIT( PARAMS ) // EM( pDrawItemStruct, cPrompt, lTop, hBitmap,;
                             // nColorBk, nColorText,  )
{
   LPDRAWITEMSTRUCT lpdis   = ( LPDRAWITEMSTRUCT ) _parnl( 1 );
   LPSTR szPrompt           = _parc( 2 );
   BOOL bTab                = bStrAt( 9, szPrompt );
   BOOL bTop                = _parl( 3 );
   HBITMAP hBmp             = ( HBITMAP ) _parnl( 4 );
   COLORREF clrBk           = ISNIL( _parl( 5 ) ) ? GetSysColor( COLOR_MENU ) : _parl( 5 );
   WORD wLen;
   HPEN hNormal;
   HBRUSH hBrush;
   LOGBRUSH lb;
   RECT rct;
   char cChr[256];

/*
   wsprintf( cChr, "color=%d", _parnl( 5 ) );
   MessageBox( 0, cChr, "Coords", MB_OK );
*/

   switch( lpdis->itemAction )
   {
      case ODA_DRAWENTIRE:
      case ODA_SELECT:
           lb.lbStyle = BS_SOLID;

           lb.lbColor = clrBk; // GetSysColor( COLOR_MENU );
           hBrush = CreateBrushIndirect( &lb );
           FillRect( lpdis->hDC, &lpdis->rcItem, hBrush );
           DeleteObject( hBrush );

           if( lpdis->itemState & ODS_SELECTED &&
               ! ( lpdis->itemState & ODS_GRAYED ) )
           {
              lb.lbColor = GetSysColor( COLOR_HIGHLIGHT );
              SetBkColor( lpdis->hDC, GetSysColor( COLOR_HIGHLIGHT ) );
              SetTextColor( lpdis->hDC, GetSysColor( COLOR_HIGHLIGHTTEXT ) );
              lpdis->rcItem.left += 19;
           }
           else
              lb.lbColor = clrBk; // GetSysColor( COLOR_MENU );

           hBrush = CreateBrushIndirect( &lb );
           FillRect( lpdis->hDC, &lpdis->rcItem, hBrush );
           DeleteObject( hBrush );

           if( lpdis->itemState & ODS_SELECTED &&
              ! ( lpdis->itemState & ODS_GRAYED ) )
              lpdis->rcItem.left -= 19;

           rct.top    = lpdis->rcItem.top;
           rct.left   = lpdis->rcItem.left;
           rct.right  = 17;
           rct.bottom = lpdis->rcItem.bottom - 1;

           if( lpdis->itemState & ODS_SELECTED )
              if( ! ( lpdis->itemState & ODS_GRAYED ) &&
                  ! ( lpdis->itemState & ODS_CHECKED ) )
                 WindowRaised( lpdis->hDC, &rct );

           if( lpdis->itemState & ODS_CHECKED )
              WindowInset( lpdis->hDC, &rct );

           if( hBmp )
           {
              if( ! ( lpdis->itemState & ODS_CHECKED ) )
                 DrawMasked( lpdis->hDC, hBmp, lpdis->rcItem.top + 1,
                             lpdis->rcItem.left + 1 );
              else
                 if( ! ( lpdis->itemState & ODS_SELECTED ) )
                    DrawGrayed( lpdis->hDC, hBmp, lpdis->rcItem.top + 1,
                                lpdis->rcItem.left + 1 );
                 else
                    DrawMasked( lpdis->hDC, hBmp, lpdis->rcItem.top + 1,
                                lpdis->rcItem.left + 1 );
           }

           lpdis->rcItem.top  += 2;
           lpdis->rcItem.left += 21;
           if( !bTab )
           {
              DrawText( lpdis->hDC, szPrompt, -1, &lpdis->rcItem, DT_LEFT );
           }
           else
           {
              lpdis->rcItem.right -= 21;
              DrawText( lpdis->hDC, StrToken(szPrompt, 1, 9, &wLen), wLen, &lpdis->rcItem, DT_LEFT );
              DrawText( lpdis->hDC, StrToken(szPrompt, 2, 9, &wLen), wLen, &lpdis->rcItem, DT_RIGHT );
              lpdis->rcItem.right += 21;
           }
           lpdis->rcItem.top  -= 2;
           lpdis->rcItem.left -= 21;

           if( lpdis->itemState & ODS_GRAYED )
              RectDisable( lpdis->hDC, &lpdis->rcItem );

           _retl( TRUE );
           break;

      case ODA_FOCUS:
           _retl( FALSE );
           break;
   }
}

//----------------------------------------------------------------------------//

CLIPPER MENUMEASUR( PARAMS ) // EITEM( pMeasureItemStruct, nLen )
{
   LPMEASUREITEMSTRUCT lp = ( LPMEASUREITEMSTRUCT ) _parnl( 1 );

   lp->itemWidth  = _parni( 2 );
   lp->itemHeight = 18;
}

//----------------------------------------------------------------------------//

CLIPPER GETMEAITEM( PARAMS ) // ( pMeasureItemStruct ) --> nMenuItemID
{
   LPMEASUREITEMSTRUCT lp = ( LPMEASUREITEMSTRUCT ) _parnl( 1 );

   _retnl( lp->itemID );
}

//----------------------------------------------------------------------------//

CLIPPER GETDRAWITE( PARAMS ) // M( pDrawItemStruct ) --> nMenuItemID
{
   LPDRAWITEMSTRUCT lpdis = ( LPDRAWITEMSTRUCT ) _parnl( 1 );

   _retnl( lpdis->itemID );
}

//----------------------------------------------------------------------------//

CLIPPER GETDRAWMEN( PARAMS ) // U( pDrawItemStruct ) --> hMenu
{
   LPDRAWITEMSTRUCT lpdis = ( LPDRAWITEMSTRUCT ) _parnl( 1 );

   _retnl( ( LONG ) lpdis->hwndItem );
}

//----------------------------------------------------------------------------//

CLIPPER ISMENU( PARAMS )
{
   _retl( IsMenu( ( HMENU ) _parnl( 1 ) ) );
}

//----------------------------------------------------------------------------//