#include "FiveWin.ch"
#include "Constant.ch"

//------------------------------------------------------------------------------

CLASS TListViewItem FROM TControl

   DATA  cText    INIT ""
   DATA  cToolTip INIT ""
   DATA  nImage   INIT 0
   DATA  nGroup   INIT 0
   DATA  nIndent  INIT 0
   DATA  lChecked INIT .f.

   DATA  nIndex   INIT 0

   DATA  Cargo

   METHOD New( oParent, nPos ) CONSTRUCTOR
   METHOD Create( oParent )    CONSTRUCTOR
   METHOD Free()               INLINE ::oParent := Nil
   METHOD Delete()
   METHOD Edit()
   METHOD CancelEdit()         INLINE ::oParent:SendMsg( LVM_CANCELEDITLABEL, 0, 0 )
   METHOD EnsureVisible()
   METHOD Select()

   METHOD InsertInList()
   METHOD GetId()
   METHOD DeleteItemC()
   METHOD GetItemRect()

ENDCLASS

//------------------------------------------------------------------------------

METHOD New( oParent, nPos ) CLASS TListViewItem

   if nPos != nil
      ::nIndex := nPos
   endif

RETURN Self

//------------------------------------------------------------------------------

METHOD Create( oParent ) CLASS TListViewItem

   if ::nIndex == nil
      ::nIndex := Len( ::oParent:aItems ) + 1
   endif

   if ::oParent:hWnd != 0
      ::InsertInList()
   endif

RETURN Self

//------------------------------------------------------------------------------

METHOD Delete() CLASS TListViewItem

   LOCAL aItems
   LOCAL lSuccess

   if ( lSuccess := ::DeleteItemC() )
      ::lParam    := 0
      aItems      := ::oParent:aItems
      if ::nIndex == Len( aItems )
         Asize( aItems, ::nIndex - 1 )
      elseif ::nIndex > 0
         aItems[ ::nIndex ] := nil
      endif
      ::nIndex := 0
   endif

RETURN lSuccess

//------------------------------------------------------------------------------

METHOD SetGroup( nGroup ) CLASS TListViewItem

   LOCAL nLen

   IF nGroup > 0 .and. aScan( ::oParent:aGroups, {|v| v:nIndex == nGroup } ) > 0
      SetGroupC( nGroup )
   ENDIF

RETURN ::nGroup

//------------------------------------------------------------------------------

#pragma BEGINDUMP

#define HB_OS_WIN_32_USED
#define _WIN32_IE 0x0560

#include <windows.h>
#include <commctrl.h>
#include "Xailer.h"

#ifdef UNICODE
   #define LPNMLVDISPINFO LPNMLVDISPINFOW
#else
   #define LPNMLVDISPINFO LPNMLVDISPINFOA
#endif

#undef LV_ITEM

typedef struct LV_ITEM {
    UINT mask;
    int iItem;
    int iSubItem;
    UINT state;
    UINT stateMask;
    LPSTR pszText;
    int cchTextMax;
    int iImage;
    LPARAM lParam;
#if (_WIN32_IE >= 0x0300)
    int iIndent;
#endif
#if (_WIN32_IE >= 0x560)
    int iGroupId;
    UINT cColumns; // tile view columns
    PUINT puColumns;
#endif
} LV_ITEM, *LPLV_ITEM;

typedef struct LVSETINFOTIP {
    UINT cbSize;
    DWORD dwFlags;
    LPWSTR pszText;
    int iItem;
    int iSubItem;
} LVSETINFOTIP, *PLVSETINFOTIP;

#define LVIF_GROUPID             0x100
#define LVIF_COLUMNS             0x200
#define  LVM_SETINFOTIP         (LVM_FIRST + 173)

//------------------------------------------------------------------------------

static int GetId( HWND hWnd, LPARAM lParam )
{
   int nId = -1;

   if( hWnd && lParam )
      {
      LVFINDINFO lvfi;
      memset( &lvfi, 0, sizeof( lvfi ) );
      lvfi.flags = LVFI_PARAM;
      lvfi.lParam = lParam;
      nId = ListView_FindItem( hWnd, -1, &lvfi );
      }

   return( nId );
}

//------------------------------------------------------------------------------

static BOOL HasCheckBoxes( HWND hWnd )
{
   DWORD nExStyle = ListView_GetExtendedListViewStyle( hWnd );

   return( nExStyle & LVS_EX_CHECKBOXES );
}
//------------------------------------------------------------------------------

HB_FUNC_STATIC( XLISTVIEWITEM_INSERTINLIST )
{
   PHB_ITEM Self = hb_stackSelfItem();
   HWND hWnd     = GetHandleOf( XA_ObjGetItem( Self, "oParent" ) );
   int nIndex    = XA_ObjGetNL( Self, "FnIndex" ) - 1;
   int nImage    = XA_ObjGetNL( Self, "FnImage" ) - 1;
   int nGroup    = XA_ObjGetNL( Self, "FnGroup" );
   int nIndent   = XA_ObjGetNL( Self, "FnIndent" );
   int lParam    = XA_ObjGetNL( Self, "lParam" );
   char * cText  = XA_ObjGetC( Self, "FcText" );
   BOOL lChecked = XA_ObjGetL( Self, "FlChecked" );
   LV_ITEM lvi;
   long nGrip;

   if( !lParam )
      {
      nGrip = (long) hb_gcGripGet( Self );
      XA_ObjSendNL( Self, "lParam", nGrip );
      }
   else
      nGrip = lParam;

   memset( &lvi, 0, sizeof( lvi ) );

   lvi.mask = LVIF_IMAGE | LVIF_TEXT | LVIF_PARAM;

   lvi.iItem = nIndex;
   lvi.iSubItem = 0;
   lvi.iImage = nImage;
   lvi.lParam = nGrip;

   if( nIndent )
      {
      lvi.mask |= LVIF_INDENT;
      lvi.iIndent = nIndent;
      }

   if( nGroup )
      {
      lvi.mask |= LVIF_GROUPID | LVIF_COLUMNS;
      lvi.iGroupId = nGroup;
      }

   if( cText )
      {
      lvi.pszText = cText;
      lvi.cchTextMax = strlen( cText );
      }

   nIndex = SendMessage( hWnd, LVM_INSERTITEM, 0, (LPARAM) &lvi );

   if( nIndex > -1 )
      {
      PHB_ITEM aData = XA_ObjGetItemCopy( Self, "FaData" );
      int nCols, nFor;

      nCols = hb_arrayLen( aData );

      for( nFor = 1; nFor <= nCols; nFor++ )
         ListView_SetItemText( hWnd, nIndex, nFor, hb_arrayGetCPtr( aData, nFor ) );

      hb_itemRelease( aData );

      if( lChecked )
         ListView_SetCheckState( hWnd, nIndex, TRUE );
      }
   hb_retni( nIndex );
}

//------------------------------------------------------------------------------

HB_FUNC_STATIC( XLISTVIEWITEM_GETID )
{
   PHB_ITEM Self = hb_stackSelfItem();
   HWND hWnd     = GetHandleOf( XA_ObjGetItem( Self, "oParent" ) );
   LPARAM lParam = XA_ObjGetNL( Self, "lParam" );
   int nId       = -1;

   if( lParam )
      {
      LVFINDINFO lvfi;
      memset( &lvfi, 0, sizeof( lvfi ) );
      lvfi.flags = LVFI_PARAM;
      lvfi.lParam = lParam;
      nId = ListView_FindItem( hWnd, -1, &lvfi );
      }

   hb_retni( nId );
}

//------------------------------------------------------------------------------

HB_FUNC_STATIC( XLISTVIEWITEM_SETTEXT )
{
   PHB_ITEM Self = hb_stackSelfItem();
   HWND hWnd     = GetHandleOf( XA_ObjGetItem( Self, "oParent" ) );
   LPARAM lParam = XA_ObjGetNL( Self, "lParam" );
   int nSubItem  = ISNUM( 2 ) ? hb_parni( 2 ) : 0;
   int nId;

   if( ( nId =  GetId( hWnd, lParam ) ) > -1 )
      ListView_SetItemText( hWnd, nId, nSubItem, hb_parc( 1 ) );

   if( !nSubItem )
      XA_ObjSendC( Self, "FcText", hb_parc( 1 ) );

   hb_retc( hb_parc( 1 ) );
}

//------------------------------------------------------------------------------

HB_FUNC_STATIC( XLISTVIEWITEM_GETTEXT )
{
   PHB_ITEM Self = hb_stackSelfItem();
   HWND hWnd     = GetHandleOf( XA_ObjGetItem( Self, "oParent" ) );
   LPARAM lParam = XA_ObjGetNL( Self, "lParam" );
   char * cText  = XA_ObjGetC( Self, "FcText" );
   int nId;

   if( ( nId =  GetId( hWnd, lParam ) ) > -1 )
      {
      char cBuffer[ 256 ];
      memset( &cBuffer, 0, 256 );
      ListView_GetItemText( hWnd, nId, 0, (LPSTR) &cBuffer, 255 );
      XA_ObjSendC( Self, "FcText", (LPSTR) &cBuffer );
      cText = (LPSTR) &cBuffer;
      }

   hb_retc( cText );
}

//------------------------------------------------------------------------------

HB_FUNC_STATIC( XLISTVIEWITEM_SETDATA )
{
   PHB_ITEM Self  = hb_stackSelfItem();
   PHB_ITEM aData = hb_param( 1, HB_IT_ARRAY );
   HWND hWnd      = GetHandleOf( XA_ObjGetItem( Self, "oParent" ) );
   LPARAM lParam  = XA_ObjGetNL( Self, "lParam" );
   int nId;

   if( aData )
      XA_ObjSendItem( Self, "_FaData", aData );

   aData = XA_ObjGetItemCopy( Self, "FaData" );


   if( ( nId =  GetId( hWnd, lParam ) ) > -1 )
      {
      int nCols, nFor;
      nCols = hb_arrayLen( aData );
      for( nFor = 1; nFor <= nCols; nFor++ )
         ListView_SetItemText( hWnd, nId, nFor, hb_arrayGetCPtr( aData, nFor ) );
      }

   hb_itemRelease( aData );
   hb_ret();
}


//------------------------------------------------------------------------------

HB_FUNC_STATIC( XLISTVIEWITEM_DELETEITEMC )
{
   PHB_ITEM Self = hb_stackSelfItem();
   HWND hWnd     = GetHandleOf( XA_ObjGetItem( Self, "oParent" ) );
   LPARAM lParam = XA_ObjGetNL( Self, "lParam" );
   int nId;

   if( ( nId =  GetId( hWnd, lParam ) ) > -1 )
      {
      if ( ListView_DeleteItem( hWnd, nId ) )
         {
         hb_gcGripDrop( (PHB_ITEM) lParam );
         hb_retl( TRUE );
         }
      else
         hb_retl( FALSE );
      }
   else
      hb_retl( FALSE );

}

//------------------------------------------------------------------------------

HB_FUNC_STATIC( XLISTVIEWITEM_EDIT )
{
   PHB_ITEM Self = hb_stackSelfItem();
   HWND hWnd     = GetHandleOf( XA_ObjGetItem( Self, "oParent" ) );
   LPARAM lParam = XA_ObjGetNL( Self, "lParam" );
   int nId;

   if( ( nId =  GetId( hWnd, lParam ) ) > -1 )
      {
      SetFocus( hWnd );
      ListView_EnsureVisible( hWnd, nId, FALSE );
      hb_retnl( (long) ListView_EditLabel( hWnd, nId ) );
      }
   else
      hb_retnl( 0 );
}

//------------------------------------------------------------------------------

HB_FUNC_STATIC( XLISTVIEWITEM_ENSUREVISIBLE )
{
   PHB_ITEM Self = hb_stackSelfItem();
   HWND hWnd     = GetHandleOf( XA_ObjGetItem( Self, "oParent" ) );
   LPARAM lParam = XA_ObjGetNL( Self, "lParam" );
   int nId;

   if( ( nId =  GetId( hWnd, lParam ) ) > -1 )
      hb_retl( ListView_EnsureVisible( hWnd, nId, FALSE ) );
   else
      hb_retl( FALSE );
}

//------------------------------------------------------------------------------

HB_FUNC_STATIC( XLISTVIEWITEM_SETCHECKED )
{
   PHB_ITEM Self = hb_stackSelfItem();
   HWND hWnd     = GetHandleOf( XA_ObjGetItem( Self, "oParent" ) );
   LPARAM lParam = XA_ObjGetNL( Self, "lParam" );
   BOOL lChecked = hb_parl( 1 );
   int nId;

   if( HasCheckBoxes( hWnd ) && ( nId =  GetId( hWnd, lParam ) ) > -1 )
      ListView_SetCheckState( hWnd, nId, lChecked );

   XA_ObjSendL( Self, "FlChecked", lChecked );
   hb_retl( lChecked );
}

//------------------------------------------------------------------------------

HB_FUNC_STATIC( XLISTVIEWITEM_GETCHECKED )
{
   PHB_ITEM Self = hb_stackSelfItem();
   HWND hWnd     = GetHandleOf( XA_ObjGetItem( Self, "oParent" ) );
   LPARAM lParam = XA_ObjGetNL( Self, "lParam" );
   BOOL lChecked = XA_ObjGetL( Self, "FlChecked" );
   int nId;

   if( HasCheckBoxes( hWnd ) && ( nId =  GetId( hWnd, lParam ) ) > -1 )
      {
      lChecked = ListView_GetCheckState( hWnd, nId );
      XA_ObjSendL( Self, "FlChecked", lChecked );
      }

   hb_retl( lChecked );
}

//------------------------------------------------------------------------------

HB_FUNC_STATIC( XLISTVIEWITEM_SETIMAGE )
{
   PHB_ITEM Self = hb_stackSelfItem();
   HWND hWnd     = GetHandleOf( XA_ObjGetItem( Self, "oParent" ) );
   LPARAM lParam = XA_ObjGetNL( Self, "lParam" );
   int nImage    = hb_parnl( 1 )- 1;
   int nId;

   if( ( nId =  GetId( hWnd, lParam ) ) > -1 )
      {
      LV_ITEM lvi;
      memset( &lvi, 0, sizeof( lvi ) );
      lvi.iItem = nId;
      lvi.mask = LVIF_IMAGE;
      lvi.iImage = nImage;
      ListView_SetItem( hWnd, (LPARAM) &lvi );
      }

   XA_ObjSendNL( Self, "FnImage", nImage + 1 );

   hb_retnl( nImage + 1 );
}

//------------------------------------------------------------------------------

HB_FUNC_STATIC( XLISTVIEWITEM_SETGROUPC )
{
   PHB_ITEM Self = hb_stackSelfItem();
   HWND hWnd     = GetHandleOf( XA_ObjGetItem( Self, "oParent" ) );
   LPARAM lParam = XA_ObjGetNL( Self, "lParam" );
   int nGroup    = hb_parnl( 1 );
   int nId;

   if( ( nId =  GetId( hWnd, lParam ) ) > -1 )
      {
      LV_ITEM lvi;
      memset( &lvi, 0, sizeof( lvi ) );
      lvi.iItem = nId;
      lvi.mask = LVIF_GROUPID | LVIF_COLUMNS;
      lvi.iGroupId = nGroup;
      ListView_SetItem( hWnd, (LPARAM) &lvi );
      }

   XA_ObjSendNL( Self, "FnGroup", nGroup );

   hb_retnl( nGroup );
}

//------------------------------------------------------------------------------

HB_FUNC_STATIC( XLISTVIEWITEM_SETINDENT )
{
   PHB_ITEM Self = hb_stackSelfItem();
   HWND hWnd     = GetHandleOf( XA_ObjGetItem( Self, "oParent" ) );
   LPARAM lParam = XA_ObjGetNL( Self, "lParam" );
   int nIndent   = hb_parnl( 1 );
   int nId;

   if( ( nId =  GetId( hWnd, lParam ) ) > -1 )
      {
      LV_ITEM lvi;
      memset( &lvi, 0, sizeof( lvi ) );
      lvi.iItem = nId;
      lvi.mask = LVIF_INDENT;
      lvi.iIndent = nIndent;
      ListView_SetItem( hWnd, (LPARAM) &lvi );
      }

   XA_ObjSendNL( Self, "FnIndent", nIndent );

   hb_retnl( nIndent );
}

//------------------------------------------------------------------------------

HB_FUNC_STATIC( XLISTVIEWITEM_GETITEMRECT )
{
   PHB_ITEM Self = hb_stackSelfItem();
   HWND hWnd     = GetHandleOf( XA_ObjGetItem( Self, "oParent" ) );
   LPARAM lParam = XA_ObjGetNL( Self, "lParam" );
   int nId;

   if( ( nId =  GetId( hWnd, lParam ) ) > -1 )
      {
      RECT rect;
      if( ListView_GetItemRect( hWnd, nId, &rect, LVIR_BOUNDS ) )
         {
         hb_reta( 4 );
         hb_stornl( rect.left + 2, -1, 1 );
         hb_stornl( rect.top + 2, -1, 2 );
         hb_stornl( rect.right + 2, -1, 3 );
         hb_stornl( rect.bottom + 2, -1, 4 );
         }
      else
         hb_ret();
      }
}

//------------------------------------------------------------------------------

HB_FUNC_STATIC( XLISTVIEWITEM_SELECT )
{
   PHB_ITEM Self = hb_stackSelfItem();
   HWND hWnd     = GetHandleOf( XA_ObjGetItem( Self, "oParent" ) );
   LPARAM lParam = XA_ObjGetNL( Self, "lParam" );
   int nId;

   if( ( nId =  GetId( hWnd, lParam ) ) > -1 )
      {
      ListView_EnsureVisible( hWnd, nId, FALSE );
      ListView_SetItemState( hWnd, -1, 0, LVIS_SELECTED );
      ListView_SetItemState( hWnd, nId, LVIS_FOCUSED | LVIS_SELECTED,
                             LVIS_FOCUSED | LVIS_SELECTED );
      }
}

#pragma ENDDUMP