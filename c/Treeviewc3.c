// Windows 95 TreeView control support C routines

#define NONAMELESSUNION

#include <Windows.h>
#include <CommCtrl.h>
#include "Extend.api"

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

extern void _bset( void *, BYTE, ULONG );

#define TVM_SETITEMHEIGHT       (TV_FIRST + 27)
#define TVM_GETITEMSTATE        (TV_FIRST + 39)
#define LVM_SETITEMSTATE        (LVM_FIRST + 43)
#define TVIS_STATEIMAGEMASK     0xF000
#define INDEXTOSTATEIMAGEMASK(i) ((i) << 12)

#define TreeView_SetItemHeight(hwnd,  iHeight) \
    (int)SNDMSG((hwnd), TVM_SETITEMHEIGHT, (WPARAM)(iHeight), 0)
#define TreeView_GetCheckState(hwndTV, hti) \
  ((((UINT)(SNDMSG((hwndTV), TVM_GETITEMSTATE, (WPARAM)(hti), TVIS_STATEIMAGEMASK))) >> 12) -1)
#define TreeView_SetCheckState(hwndTV, hti, fCheck) \
  TreeView_SetItemState(hwndTV, hti, INDEXTOSTATEIMAGEMASK((fCheck)?2:1), TVIS_STATEIMAGEMASK)
#define TreeView_SetItemState(hwndTV, hti, data, _mask) \
{ TV_ITEM _ms_TVi;\
  _ms_TVi.mask = TVIF_STATE; \
  _ms_TVi.hItem = hti; \
  _ms_TVi.stateMask = _mask;\
  _ms_TVi.state = data;\
  SNDMSG((hwndTV), TVM_SETITEM, 0, (LPARAM)(TV_ITEM FAR *)&_ms_TVi);\
}

//-------------------------------------------------------------------------//

#ifdef __C3__
   CLIPPER TVINSERTITEM() // ( hWnd, cItemText, hItem, nImage )
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

#ifdef __C3__
   CLIPPER TVSETIMAGELIST() // ( hWnd, hImageList, nType )
#else
   CLIPPER TVSETIMAGE( PARAMS ) // LIST( hWnd, hImageList, nType )
#endif

{
   //_retnl( ( LONG ) 0 );
   _retnl( ( LONG ) TreeView_SetImageList( ( HWND ) _parnl( 1 ), ( HIMAGELIST ) _parnl( 2 ), _parnl( 3 ) ) );
}

//-------------------------------------------------------------------------//

#ifdef __C3__
   CLIPPER TVGETSELTEXT() // ( hWnd ) --> cText
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

#ifdef __C3__
   CLIPPER TVGETSELECTED() // ( hWnd ) --> hItem
#else
   CLIPPER TVGETSELEC( PARAMS ) // TED( hWnd ) --> hItem
#endif
{
   _retnl( ( LONG ) TreeView_GetSelection( ( HWND ) _parnl( 1 ) ) );
}

//-------------------------------------------------------------------------//


#ifdef __C3__
   CLIPPER TVDELETEALLITEMS() // ( hWnd ) --> lSuccess
#else
   CLIPPER TVDELALLIT( PARAMS ) // ( hWnd ) --> lSuccess
#endif
{
   _retl( ( BOOL ) TreeView_DeleteAllItems( ( HWND ) _parnl( 1 ) ) );
}

//-------------------------------------------------------------------------//

#ifdef __C3__
   CLIPPER TVHITTEST() // ( hWnd, nRow, nCol ) --> hItem
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

#ifdef __C3__
   CLIPPER TVSELECT() // ( hWnd, hItem ) --> lSuccess
#else
   CLIPPER TVSELECT( PARAMS ) // ( hWnd, hItem ) --> lSuccess
#endif
{
   HWND hWnd = ( HWND ) _parnl( 1 );
   HTREEITEM hItem = ( HTREEITEM ) _parnl( 2 );

   _retl( ( BOOL ) TreeView_Select( hWnd, hItem, TVGN_CARET ) );
}

//-------------------------------------------------------------------------//

#ifdef __C3__
   CLIPPER TVDELETEITEM() // ( hWnd, hItem ) --> lSuccess
#else
   CLIPPER TVDELETEITEM( PARAMS ) //EM ( hWnd, hItem ) --> lSuccess
#endif
{
   HWND hWnd = ( HWND ) _parnl( 1 );
   HTREEITEM hItem = ( HTREEITEM ) _parnl( 2 );

   _retl( TreeView_DeleteItem( hWnd, hItem ) );
}

//-------------------------------------------------------------------------//

#ifdef __C3__
   CLIPPER TVSETITEMIMAGE() // ( hWnd, hItem, iImage ) --> lSuccess
#else
   CLIPPER TVSETITM( PARAMS ) // ( hWnd, hItem, iImage ) --> lSuccess
#endif
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

CLIPPER TVGETCHECKSTATE() // ( hWnd, hItem ) --> lSuccess
{
   _retl( ( BOOL ) TreeView_GetCheckState( ( HWND ) _parnl( 1 ), ( HTREEITEM ) _parnl( 2 ) ) );
}

//-------------------------------------------------------------------------//

CLIPPER TVSETCHECKSTATE() // ( hWnd, hItem, lCheck ) --> lSuccess
{
   TreeView_SetCheckState( ( HWND ) _parnl( 1 ), ( HTREEITEM ) _parnl( 2 ), _parl( 3 ) );

   _retl( ( BOOL ) TreeView_GetCheckState( ( HWND ) _parnl( 1 ), ( HTREEITEM ) _parnl( 2 ) ) );
}

//-------------------------------------------------------------------------//

CLIPPER TVSETITEMHEIGHT() // ( hWnd, cyItemn ) --> lSuccess
{
   _retni( ( INT ) TreeView_SetItemHeight( ( HWND ) _parnl( 1 ), _parni( 2 ) ) );
}