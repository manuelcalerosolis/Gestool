
// Windows 95 TreeView control support C routines

#define NONAMELESSUNION

#include <WinTen.h>
#include <Windows.h>
#include <ClipApi.h>

#ifdef __CLIPPER__
   #ifndef __C3__
      #define LPCWSTR LPSTR      /* CommCtrl.h fixes for 16 bits */
      #define LPWSTR  LPSTR
      #define WCHAR   BYTE
      typedef struct tagNMHDR
      {
         HWND hwndFrom;
         UINT idFrom;
         UINT code;
      } NMHDR;
   #endif
#endif

#include <CommCtrl.h>

//-------------------------------------------------------------------------//

#ifdef __HARBOUR__
   CLIPPER TVINSERTITEM( PARAMS ) // ( hWnd, cItemText, hItem, nImage )
#else
   CLIPPER TVINSERTIT( PARAMS ) // EM( hWnd, cItemText, hItem, nImage )
#endif
{
   TV_INSERTSTRUCT is;

   _bset( ( char * ) &is, 0, sizeof( TV_INSERTSTRUCT ) );

   is.hParent      = ( HTREEITEM ) _parnl( 3 );
   is.hInsertAfter = TVI_LAST;

   #if (_WIN32_IE >= 0x0400)
      is.DUMMYUNIONNAME.item.pszText = _parc( 2 );
      is.DUMMYUNIONNAME.item.mask    = TVIF_TEXT | TVIF_IMAGE | TVIF_SELECTEDIMAGE;
      is.DUMMYUNIONNAME.item.iImage  = _parnl( 4 );
      is.DUMMYUNIONNAME.item.iSelectedImage = _parnl( 4 );
   #else
      is.item.pszText = _parc( 2 );
      is.item.mask    = TVIF_TEXT | TVIF_IMAGE | TVIF_SELECTEDIMAGE;
      is.item.iImage  = _parnl( 4 );
      is.item.iSelectedImage = _parnl( 4 );
   #endif

   _retnl( SendMessage( ( HWND ) _parnl( 1 ), TVM_INSERTITEM, 0,
           ( LPARAM )( LPTV_INSERTSTRUCT )( &is ) ) );
}

//-------------------------------------------------------------------------//

HB_FUNC(TVSETIMAGELIST ) // ( hWnd, hImageList, nType )
{
   _retnl( ( LONG ) TreeView_SetImageList( ( HWND ) _parnl( 1 ),
            ( HIMAGELIST ) _parnl( 2 ), _parnl( 3 ) ) );
}

//-------------------------------------------------------------------------//

#ifdef __HARBOUR__
   CLIPPER TVGETSELTEXT( PARAMS ) // ( hWnd ) --> cText
#else
   CLIPPER TVGETSELTE( PARAMS ) // XT( hWnd ) --> cText
#endif
{
   HWND hWnd = ( HWND ) _parnl( 1 );
   HTREEITEM hItem = TreeView_GetSelection( hWnd );
   TV_ITEM tvi;
   BYTE buffer[ 100 ];

   if( hItem )
   {
      tvi.mask       = TVIF_TEXT;
      tvi.hItem      = hItem;
      tvi.pszText    = ( char * ) buffer;
      tvi.cchTextMax = 100;
      TreeView_GetItem( hWnd, &tvi );

      _retc( tvi.pszText );
   }
   else
      _retc( "" );
}

//-------------------------------------------------------------------------//

#ifdef __HARBOUR__
   CLIPPER TVSETITEMTEXT( PARAMS ) // ( hWnd, hItem, cText )
#else
   CLIPPER TVSETITEMT( PARAMS ) // EXT( hWnd, hItem, cText ) --> cText
#endif
{
   HWND hWnd = ( HWND ) _parnl( 1 );
   TV_ITEM tvi;
   BOOL bResult;
   BYTE buffer[ 100 ];

   tvi.hItem = ( HTREEITEM ) _parnl( 2 );
   tvi.mask       = TVIF_TEXT;
   tvi.pszText    = ( char * ) buffer;
   tvi.cchTextMax = sizeof( buffer );
   bResult = TreeView_GetItem( hWnd, &tvi );

   if( bResult )
   {
      tvi.mask       = TVIF_TEXT;
      tvi.hItem      = ( HTREEITEM ) _parnl( 2 );
      tvi.pszText    = _parc( 3 );
      tvi.cchTextMax = _parclen( 3 );
      TreeView_SetItem( hWnd, &tvi );
   }
}

//-------------------------------------------------------------------------//

#ifdef __HARBOUR__
   CLIPPER TVGETSELECTED( PARAMS ) // ( hWnd ) --> hItem
#else
   CLIPPER TVGETSELEC( PARAMS ) // TED( hWnd ) --> hItem
#endif
{
   _retnl( ( LONG ) TreeView_GetSelection( ( HWND ) _parnl( 1 ) ) );
}

//-------------------------------------------------------------------------//

#ifdef __HARBOUR__
   CLIPPER TVDELALLITEMS( PARAMS ) // ( hWnd ) --> lSuccess
#else
   CLIPPER TVDELALLIT( PARAMS ) // ( hWnd ) --> lSuccess
#endif
{
   _retl( ( BOOL ) TreeView_DeleteAllItems( ( HWND ) _parnl( 1 ) ) );
}

//-------------------------------------------------------------------------//

HB_FUNC(TVDELETEALLITEMS) // ( hWnd ) --> lSuccess
{
   _retl( ( BOOL ) TreeView_DeleteAllItems( ( HWND ) _parnl( 1 ) ) );
}

//-------------------------------------------------------------------------//

#ifdef __HARBOUR__
   CLIPPER TVHITTEST( PARAMS ) // ( hWnd, nRow, nCol ) --> hItem
#else
   CLIPPER TVHITTEST( PARAMS ) // ( hWnd, nRow, nCol ) --> hItem
#endif
{
   HWND hWnd = ( HWND ) _parnl( 1 );
   TV_HITTESTINFO lpht;
   HTREEITEM hItem;

   lpht.pt.x = _parnl( 3 );
   lpht.pt.y = _parnl( 2 );

   hItem = TreeView_HitTest( hWnd, &lpht );

   if ((hItem != NULL) && (lpht.flags & TVHT_ONITEM))
    _retnl( ( LONG ) hItem );
   else
    _retnl( ( LONG ) 0 );
}

//-------------------------------------------------------------------------//


#ifdef __HARBOUR__
   CLIPPER TVSELECT( PARAMS ) // ( hWnd, hItem ) --> lSuccess
#else
   CLIPPER TVSELECT( PARAMS ) // ( hWnd, hItem ) --> lSuccess
#endif
{
   HWND hWnd = ( HWND ) _parnl( 1 );
   HTREEITEM hItem = ( HTREEITEM ) _parnl( 2 );

   _retl( ( BOOL ) TreeView_Select( hWnd, hItem, TVGN_CARET ) );
}

//-------------------------------------------------------------------------//

#ifdef __HARBOUR__
   CLIPPER TVDELETEITEM( PARAMS ) // ( hWnd, hItem ) --> lSuccess
#else
   CLIPPER TVDELETEIT( PARAMS ) //EM ( hWnd, hItem ) --> lSuccess
#endif
{
   HWND hWnd = ( HWND ) _parnl( 1 );
   HTREEITEM hItem = ( HTREEITEM ) _parnl( 2 );

   _retl( TreeView_DeleteItem( hWnd, hItem ) );
}

//-------------------------------------------------------------------------//

#ifdef __HARBOUR__
   CLIPPER TVGETPARENT( PARAMS ) // ( hWnd, hItem ) --> hParentItem
#else
   CLIPPER TVGETPAREN( PARAMS ) //T ( hWnd, hItem ) --> hParentItem
#endif
{
   HWND hWnd = ( HWND ) _parnl( 1 );
   HTREEITEM hItem = ( HTREEITEM ) _parnl( 2 );

   _retnl( ( unsigned long ) TreeView_GetParent( hWnd, hItem ) );
}

//-------------------------------------------------------------------------//

#ifdef __HARBOUR__
   CLIPPER TVSETTEXTIMAGE( PARAMS ) // ( hWnd, hItem, cText, nImage )
#else
   CLIPPER TVSETTEXTI( PARAMS )
#endif
{
   HWND hWnd = ( HWND ) _parnl( 1 );
   HTREEITEM hItem = ( HTREEITEM ) _parnl( 2 );
   TV_ITEM tvi;

   tvi.hItem   = hItem;
   tvi.mask    = TVIF_TEXT | TVIF_IMAGE | TVIF_SELECTEDIMAGE;
   tvi.pszText = _parc( 3 );
   tvi.iImage  = _parnl( 4 );
   tvi.iSelectedImage = _parnl( 4 );
   TreeView_SetItem( hWnd, &tvi );
}

//-------------------------------------------------------------------------//

CLIPPER TVSETCOLOR( PARAMS ) // hWnd, nClrFore, nClrBack
{
   TreeView_SetBkColor( ( HWND ) _parnl( 1 ), _parnl( 3 ) );
   TreeView_SetTextColor( ( HWND ) _parnl( 1 ), _parnl( 2 ) );
}

//-------------------------------------------------------------------------//

HB_FUNC(TVSETITEMHEIGHT) // ( hWnd, cyItemn ) --> lSuccess
{
   _retni( ( INT ) TreeView_SetItemHeight( ( HWND ) _parnl( 1 ), _parni( 2 ) ) );
}

//-------------------------------------------------------------------------//

HB_FUNC(TVSETITEMIMAGE) // ( hWnd, hItem, iImage ) --> lSuccess
{
   HWND hWnd = ( HWND ) _parnl( 1 );
   UINT iImage = _parni( 3 ) + 1;
   TV_ITEM pitem;

   pitem.hItem = ( HTREEITEM ) _parnl( 2 );
   pitem.mask = TVIF_IMAGE | TVIF_SELECTEDIMAGE;
   pitem.iImage = iImage;
   pitem.iSelectedImage = iImage;

   _retl( TreeView_SetItem( hWnd, ( LPTV_ITEM )( &pitem ) ) );
}

//-------------------------------------------------------------------------//

HB_FUNC(TVGETCHECKSTATE) // ( hWnd, hItem ) --> lSuccess
{
   _retl( ( BOOL ) TreeView_GetCheckState( ( HWND ) _parnl( 1 ), ( HTREEITEM ) _parnl( 2 ) ) );
}

//-------------------------------------------------------------------------//

HB_FUNC(TVSETCHECKSTATE) // ( hWnd, hItem, lCheck ) --> lSuccess
{
   TreeView_SetCheckState( ( HWND ) _parnl( 1 ), ( HTREEITEM ) _parnl( 2 ), _parl( 3 ) );

   _retl( ( BOOL ) TreeView_GetCheckState( ( HWND ) _parnl( 1 ), ( HTREEITEM ) _parnl( 2 ) ) );
}

//-------------------------------------------------------------------------//




















































































































































































































































