// Windows 95 TreeView control support C routines

#define NONAMELESSUNION

#define _WIN32_IE 0x0500
#include <Windows.h>
#include <CommCtrl.h>
#include <hbapi.h>

#if defined( __MINGW_H ) || defined( _MSC_VER ) 
   #define TreeView_SetItemState(hwndTV, hti, data, _mask) \
   { TVITEM _ms_TVi;\
     _ms_TVi.mask = TVIF_STATE; \
     _ms_TVi.hItem = hti; \
     _ms_TVi.stateMask = _mask;\
     _ms_TVi.state = data;\
     SendMessage((hwndTV), TVM_SETITEM, 0, (LPARAM)(TV_ITEM *)&_ms_TVi);\
   }

   #define TreeView_SetCheckState(hwndTV, hti, fCheck) \
      TreeView_SetItemState(hwndTV, hti, INDEXTOSTATEIMAGEMASK((fCheck)?2:1), TVIS_STATEIMAGEMASK)
  	
   #define TreeView_GetCheckState(hwndTV, hti) \
      ((((UINT)(SNDMSG((hwndTV), TVM_GETITEMSTATE, (WPARAM)(hti), TVIS_STATEIMAGEMASK))) >> 12) -1)  	

   #define TreeView_SetItemHeight(hwnd,  iHeight) \
      (int)SNDMSG((hwnd), TVM_SETITEMHEIGHT, (WPARAM)(iHeight), 0)

#endif

#ifdef _MSC_VER
   #define TVM_GETITEMSTATE  (TV_FIRST + 39)
#endif   

//-------------------------------------------------------------------------//

HB_FUNC( TVINSERTITEM ) // ( hWnd, cItemText, hItem, nImage )
{
   TV_INSERTSTRUCT is;

   memset( ( char * ) &is, 0, sizeof( TV_INSERTSTRUCT ) );

   is.hParent      = ( HTREEITEM ) hb_parnl( 3 );
   is.hInsertAfter = TVI_LAST;

//    #if (_WIN32_IE >= 0x0400)
   #if __BORLANDC__ <= 1410
      is.DUMMYUNIONNAME.item.pszText = ( LPSTR ) hb_parc( 2 );
      is.DUMMYUNIONNAME.item.mask    = TVIF_TEXT | TVIF_IMAGE | TVIF_SELECTEDIMAGE;
      is.DUMMYUNIONNAME.item.iImage  = hb_parnl( 4 );
      is.DUMMYUNIONNAME.item.iSelectedImage = hb_parnl( 4 );
      is.DUMMYUNIONNAME.item.lParam = hb_parnl( 5 );
   #else
      is.item.pszText = hb_parc( 2 );
      is.item.mask    = TVIF_TEXT | TVIF_IMAGE | TVIF_SELECTEDIMAGE;
      is.item.iImage  = hb_parnl( 4 );
      is.item.iSelectedImage = hb_parnl( 4 );
      is.item.lParam  = hb_parnl( 5 );
   #endif

   hb_retnl( SendMessage( ( HWND ) hb_parnl( 1 ), TVM_INSERTITEM, 0,
           ( LPARAM )( LPTV_INSERTSTRUCT )( &is ) ) );
}

//-------------------------------------------------------------------------//

HB_FUNC( TVSETIMAGELIST ) // ( hWnd, hImageList, nType )
{
   hb_retnl( ( LONG ) TreeView_SetImageList( ( HWND ) hb_parnl( 1 ),
            ( HIMAGELIST ) hb_parnl( 2 ), hb_parnl( 3 ) ) );
}

//-------------------------------------------------------------------------//

HB_FUNC( TVGETSELTEXT ) // ( hWnd ) --> cText
{
   HWND hWnd = ( HWND ) hb_parnl( 1 );
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

      hb_retc( tvi.pszText );
   }
   else
      hb_retc( "" );
}

//-------------------------------------------------------------------------//

HB_FUNC( TVGETTEXT ) // ( hWnd, hItem ) --> cText
{
   HTREEITEM hItem = ( HTREEITEM ) hb_parnl( 2 );
   TV_ITEM tvi;
   BYTE buffer[ 100 ];

   tvi.mask       = TVIF_TEXT;
   tvi.hItem      = hItem;
   tvi.pszText    = ( char * ) buffer;
   tvi.cchTextMax = 100;
   TreeView_GetItem( ( HWND ) hb_parnl( 1 ), &tvi );

   hb_retc( tvi.pszText );
}

//-------------------------------------------------------------------------//

HB_FUNC( TVSETITEMTEXT ) // ( hWnd, hItem, cText )
{
   HWND hWnd = ( HWND ) hb_parnl( 1 );
   TV_ITEM tvi;
   BOOL bResult;
   BYTE buffer[ 100 ];   

   tvi.hItem = ( HTREEITEM ) hb_parnl( 2 );
   tvi.mask       = TVIF_TEXT;
   tvi.pszText    = ( char * ) buffer;
   tvi.cchTextMax = sizeof( buffer );
   bResult = TreeView_GetItem( hWnd, &tvi );

   if( bResult )
   {
      tvi.mask       = TVIF_TEXT;
      tvi.hItem      = ( HTREEITEM ) hb_parnl( 2 );
      tvi.pszText    = ( LPSTR ) hb_parc( 3 );
      tvi.cchTextMax = hb_parclen( 3 );
      TreeView_SetItem( hWnd, &tvi );
   }
}

//-------------------------------------------------------------------------//

HB_FUNC( TVGETSELECTED ) // ( hWnd ) --> hItem
{
   hb_retnl( ( LONG ) TreeView_GetSelection( ( HWND ) hb_parnl( 1 ) ) );
}

//-------------------------------------------------------------------------//

HB_FUNC( TVDELALLITEMS ) // ( hWnd ) --> lSuccess
{
   hb_retl( ( BOOL ) TreeView_DeleteAllItems( ( HWND ) hb_parnl( 1 ) ) );
}

//-------------------------------------------------------------------------//

HB_FUNC( TVHITTEST ) // ( hWnd, nRow, nCol ) --> hItem
{
   HWND hWnd = ( HWND ) hb_parnl( 1 );
   TV_HITTESTINFO lpht;
   HTREEITEM hItem;

   lpht.pt.x = hb_parnl( 3 );
   lpht.pt.y = hb_parnl( 2 );

   hItem = TreeView_HitTest( hWnd, &lpht );

   if ((hItem != NULL) && (lpht.flags & TVHT_ONITEM))
    hb_retnl( ( LONG ) hItem );
   else
    hb_retnl( ( LONG ) 0 );
}

//-------------------------------------------------------------------------//

HB_FUNC( TVSELECT ) // ( hWnd, hItem ) --> lSuccess
{
   HWND hWnd = ( HWND ) hb_parnl( 1 );
   HTREEITEM hItem = ( HTREEITEM ) hb_parnl( 2 );

   hb_retl( ( BOOL ) TreeView_Select( hWnd, hItem, TVGN_CARET ) );
}

//-------------------------------------------------------------------------//

HB_FUNC( TVDELETEITEM ) // ( hWnd, hItem ) --> lSuccess
{
   HWND hWnd = ( HWND ) hb_parnl( 1 );
   HTREEITEM hItem = ( HTREEITEM ) hb_parnl( 2 );

   hb_retl( TreeView_DeleteItem( hWnd, hItem ) );
}

//-------------------------------------------------------------------------//

HB_FUNC( TVGETPARENT ) // ( hWnd, hItem ) --> hParentItem
{
   HWND hWnd = ( HWND ) hb_parnl( 1 );
   HTREEITEM hItem = ( HTREEITEM ) hb_parnl( 2 );

   hb_retnl( ( unsigned long ) TreeView_GetParent( hWnd, hItem ) );   	
}   

//-------------------------------------------------------------------------//

HB_FUNC( TVSETTEXTIMAGE ) // ( hWnd, hItem, cText, nImage )
{ 
   HWND hWnd = ( HWND ) hb_parnl( 1 ); 
   HTREEITEM hItem = ( HTREEITEM ) hb_parnl( 2 ); 
   TV_ITEM tvi; 
   
   tvi.hItem   = hItem; 
   tvi.mask    = TVIF_TEXT | TVIF_IMAGE | TVIF_SELECTEDIMAGE; 
   tvi.pszText = ( LPSTR ) hb_parc( 3 ); 
   tvi.iImage  = hb_parnl( 4 ); 
   tvi.iSelectedImage = hb_parnl( 4 ); 
   TreeView_SetItem( hWnd, &tvi ); 
} 

//-------------------------------------------------------------------------//

HB_FUNC( TVSETCOLOR ) // hWnd, nClrFore, nClrBack
{
   COLORREF clr = TreeView_SetBkColor( ( HWND ) hb_parnl( 1 ), hb_parnl( 3 ) );
   COLORREF clr2 = TreeView_SetTextColor( ( HWND ) hb_parnl( 1 ), hb_parnl( 2 ) );

   HB_SYMBOL_UNUSED( clr );
   HB_SYMBOL_UNUSED( clr2 ); 
}

//-------------------------------------------------------------------------//

HB_FUNC( TVSETCHECK ) // hTreeView, hItem, lOnOff 
{ 
   TreeView_SetCheckState( ( HWND ) hb_parnl( 1 ), 
                           ( HTREEITEM ) hb_parnl( 2 ), hb_parl( 3 ) ); 
}

//-------------------------------------------------------------------------//

HB_FUNC( TVGETCHECK ) // hTreeView, hItem --> lOnOff 
{ 
   hb_retl( TreeView_GetCheckState( ( HWND ) hb_parnl( 1 ), 
                                  ( HTREEITEM ) hb_parnl( 2 ) ) ); 
}

//-------------------------------------------------------------------------//

HB_FUNC( TVIPARAM ) // hItem --> nLParam 
{ 
   hb_retnl( ( ( TV_ITEM * ) hb_parnl( 1 ) )->lParam ); 
}

//-------------------------------------------------------------------------//

HB_FUNC( TVSETITEMIMAGE ) // ( hWnd, hItem, iImage ) --> lSuccess
{
   HWND hWnd = ( HWND ) hb_parnl( 1 );
   UINT iImage = hb_parni( 3 ) + 1;
   TV_ITEM pitem;

   pitem.hItem = ( HTREEITEM ) hb_parnl( 2 );
   pitem.mask = TVIF_IMAGE | TVIF_SELECTEDIMAGE;
   pitem.iImage = iImage;
   pitem.iSelectedImage = iImage;

   hb_retl( TreeView_SetItem( hWnd, ( LPTV_ITEM )( &pitem ) ) );
}

//-------------------------------------------------------------------------//

HB_FUNC( TVSETITEMHEIGHT )// ( hWnd, cyItemn ) --> lSuccess
{
   hb_retni( ( INT ) TreeView_SetItemHeight( ( HWND ) hb_parnl( 1 ), hb_parni( 2 ) ) );
}
