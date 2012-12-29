// Win32 ListView Common Control support
// (c) FiveTech Software

#include "FiveWin.ch"
#include "Constant.ch"

#define COLOR_WINDOW          5
#define COLOR_WINDOWTEXT      8
#define COLOR_BTNFACE         15
#define COLOR_BTNSHADOW       16
#define COLOR_BTNHIGHLIGHT    20

#define NM_CLICK              -2

#define WM_ERASEBKGND         20

#define LVM_FIRST             4096 // 0x1000
#define LVM_SETIMAGELIST      ( LVM_FIRST + 3 )
#define LVM_SETICONSPACING    ( LVM_FIRST + 53 )
#define LVM_SETHOTITEM        ( LVM_FIRST + 60 )
#define LVM_CANCELEDITLABEL   ( LVM_FIRST + 179 )

#define LVN_FIRST             -100
#define LVN_ITEMCHANGED       ( LVN_FIRST - 1 )

#define LVSIL_NORMAL          0
#define LVSIL_SMALL           1
#define LVSIL_STATE           2

#define lvgsNORMAL            0
#define lvgsCOLLAPSED         1
#define lvgsHIDDEN            2

#ifdef __XPP__
   #define Super ::TControl
   #define New _New
#endif

#define CTRL_CLASS            "SysListView32"

//----------------------------------------------------------------------------//

CLASS TListView FROM TControl

   CLASSDATA aProperties   INIT { "nAlign", "nClrText", "nClrPane", "nOption", "nTop", "nLeft", "nWidth", "nHeight", "Cargo" }

   DATA  aPrompts
   DATA  aCargo
   DATA  aItems            INIT {}
   DATA  aGroups           INIT {}
   DATA  bAction
   DATA  bClick
   DATA  nOption

   METHOD New( nTop, nLeft, aPrompts, bAction, oWnd, nClrFore,;
               nClrBack, lPixel, lDesign, nWidth, nHeight,;
               cMsg ) CONSTRUCTOR

   METHOD ReDefine( nId, oWnd, bAction ) CONSTRUCTOR

   METHOD Default()

   METHOD Display()                          INLINE ::BeginPaint(), ::Paint(), ::EndPaint(), 0

   METHOD EraseBkGnd( hDC )                  INLINE 1

   METHOD InsertItem( nImageIndex, cText )   INLINE LVInsertItem( ::hWnd, nImageIndex, cText )

   METHOD InsertItemGroup( nImageIndex, cText, nGroup ) INLINE LVInsertItemGroup( ::hWnd, nImageIndex, cText, nGroup )
   METHOD aAddItemGroup( nImageIndex, cText, nGroup )

   METHOD InsertGroup( nGroupIndex, cText )  INLINE LVInsertGroupInList( ::hWnd, nGroupIndex, cText )

   METHOD SetIconSpacing( x, y )             INLINE SendMessage( ::hWnd, LVM_SETICONSPACING, 0, nMakeLong( x, y ) )
   METHOD SetHotItem( nItem )                INLINE SendMessage( ::hWnd, LVM_SETHOTITEM, nItem, 0 )

   METHOD EnableGroupView()                  INLINE LVEnableGroupView( ::hWnd )
   METHOD FindItem( cText )                  INLINE LVFindItem( ::hWnd, cText )
   METHOD SetItemSelect( nItem )             INLINE LVSetItemSelect( ::hWnd, nItem )

   METHOD Paint()

   METHOD Notify( nIdCtrl, nPtrNMHDR )

   METHOD SetImageList( oImageList, nType )

   METHOD HScroll( nWParam, nLParam ) VIRTUAL  // required for default behavior
   METHOD VScroll( nWParam, nLParam ) VIRTUAL  // required for default behavior

   METHOD GetItem( nItem )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( nTop, nLeft, aPrompts, bAction, oWnd, nClrFore,;
            nClrBack, lPixel, lDesign, nWidth, nHeight, cMsg ) CLASS TListView

   DEFAULT nTop     := 0, nLeft := 0,;
           aPrompts := { "&One", "&Two", "T&hree" },;
           oWnd     := GetWndDefault(),;
           nClrFore := oWnd:nClrText,;
           nClrBack := GetSysColor( COLOR_BTNFACE ),;
           lPixel   := .f.,;
           lDesign  := .f.,;
           nWidth   := 200, nHeight := 21

   #ifdef __XPP__
      #undef New
   #endif

   ::nStyle    = nOR( WS_CHILD, WS_VISIBLE, If( lDesign, WS_CLIPSIBLINGS, 0 ), WS_TABSTOP )
   ::nId       = ::GetNewId()
   ::oWnd      = oWnd
   ::aPrompts  = aPrompts
   ::bAction   = bAction
   ::cMsg      = cMsg
   ::nTop      = If( lPixel, nTop, nTop * SAY_CHARPIX_H )
   ::nLeft     = If( lPixel, nLeft, nLeft * SAY_CHARPIX_W )
   ::nBottom   = ::nTop + nHeight - 1
   ::nRight    = ::nLeft + nWidth - 1
   ::lDrag     = lDesign
   ::lCaptured = .f.
   ::oFont     = TFont():New( "Ms Sans Serif", 0, -9 )
   ::nClrText  = nClrFore
   ::nClrPane  = nClrBack
   ::nOption   = 1
   ::aCargo    = {}

   if ! Empty( oWnd:hWnd )
      ::Create( CTRL_CLASS )
      oWnd:AddControl( Self )
   else
      oWnd:DefControl( Self )
   endif

   ::Default()

   if lDesign
      ::CheckDots()
   endif

return Self

//----------------------------------------------------------------------------//

METHOD ReDefine( nId, oWnd, bAction ) CLASS TListView

   DEFAULT oWnd   := GetWndDefault()

   ::nId          := nId
   ::oWnd         := oWnd
   ::bAction      := bAction
   ::aPrompts     := {}
   ::aCargo       := {}

   oWnd:DefControl( Self )

return Self

//----------------------------------------------------------------------------//

METHOD Default() CLASS TListView

   local n

   for n = 1 to Len( ::aPrompts )
      ::InsertItem( n - 1, ::aPrompts[ n ] )
   next

return Super:Default()

//----------------------------------------------------------------------------//

METHOD Paint() CLASS TListView

   local aInfo := ::DispBegin()

   if ::oBrush != nil
      FillRect( ::hDC, GetClientRect( ::hWnd ), ::oBrush:hBrush )
   else
      CallWindowProc( ::nOldProc, ::hWnd, WM_ERASEBKGND, ::hDC, 0 )
   endif

   CallWindowProc( ::nOldProc, ::hWnd, WM_PAINT, ::hDC, 0 )

   ::DispEnd( aInfo )

return 1

//----------------------------------------------------------------------------//

METHOD Notify( nIdCtrl, nPtrNMHDR ) CLASS TListView

   local nOption
   local nCode       := GetNMHDRCode( nPtrNMHDR )

   do case
      case nCode == NM_CLICK

         nOption     := GetNMListViewItem( nPtrNMHDR ) + 1

         if ::bClick != nil
            ::nOption   := nOption
            Eval( ::bClick, ::nOption, Self )
         endif

      case nCode == LVN_ITEMCHANGED

         nOption     := GetNMListViewItem( nPtrNMHDR ) + 1

         if ::nOption != nOption

            ::nOption := nOption

            if ::bAction != nil
               Eval( ::bAction, ::nOption, Self )
            endif

         endif

   endcase

Return nil

//----------------------------------------------------------------------------//

METHOD SetImageList( oImageList, nType ) CLASS TListView

   local nResult

   DEFAULT nType := LVSIL_NORMAL

   nResult = SendMessage( ::hWnd, LVM_SETIMAGELIST, nType, oImageList:hImageList )

   SysRefresh()

Return nResult

//----------------------------------------------------------------------------//

METHOD aAddItemGroup( nImageIndex, cText, nGroup, Cargo ) CLASS TListView

   aAdd( ::aPrompts, cText )
   aAdd( ::aCargo, Cargo )

Return ( LVInsertItemGroup( ::hWnd, nImageIndex, cText, nGroup ) )

//----------------------------------------------------------------------------//

METHOD GetItem( nItem ) CLASS TListView

   if nItem > 0 .and. nItem <= len( ::aItems )
      Return ( ::aItems[ nItem ] )
   end if

Return ( nil )

//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------

CLASS TListViewItem

   DATA  oParent

   DATA  cText    INIT ""
   DATA  cToolTip INIT ""
   DATA  nImage   INIT 0
   DATA  nGroup   INIT 0
   DATA  nIndent  INIT 0
   DATA  lChecked INIT .f.

   DATA  nItem    INIT 0

   DATA  Cargo

   METHOD New( oParent, nPos )   CONSTRUCTOR
   METHOD Create( oParent )      CONSTRUCTOR
   METHOD Destroy()              INLINE ( ::oParent := nil )
   METHOD Delete()
   METHOD SetGroup( nGroup )

   METHOD InsertInList()
   METHOD GetId()                VIRTUAL

ENDCLASS

//------------------------------------------------------------------------------

METHOD New( oParent ) CLASS TListViewItem

   if !Empty( oParent )
      ::oParent   := oParent
   end if

RETURN Self

//------------------------------------------------------------------------------

METHOD Create( oParent ) CLASS TListViewItem

   if !Empty( oParent )
      ::oParent   := oParent
   end if

   if !Empty( ::oParent ) .and. ::oParent:hWnd != 0
      if ::InsertInList() > -1
         aAdd( ::oParent:aItems, Self )
      end if
   end if

RETURN Self

//------------------------------------------------------------------------------

METHOD InsertInList()

   local nItem

   nItem          := LvInsertInList( ::oParent:hWnd, ::nImage, ::cText, ::nGroup )
   if nItem > -1
      ::nItem     := nItem
   end if

RETURN ( nItem )

//------------------------------------------------------------------------------

METHOD Delete() CLASS TListViewItem

   LOCAL aItems
   LOCAL lSuccess

   if ( lSuccess := ::DeleteItemC() )

      ::lParam    := 0
      aItems      := ::oParent:aItems

      if ::nItem == Len( aItems )
         aSize( aItems, ::nItem - 1 )
      elseif ::nItem > 0
         aItems[ ::nItem ] := nil
      endif

      ::nItem    := 0

   endif

RETURN lSuccess

//------------------------------------------------------------------------------

METHOD SetGroup( nGroup ) CLASS TListViewItem

   LOCAL nLen

   if nGroup > 0 .and. aScan( ::oParent:aGroups, {|v| v:nItem == nGroup } ) > 0
      LVSetGroup( nGroup )
   end if

RETURN ::nGroup

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------

CLASS TListViewGroup

   DATA cHeader      INIT ""
   DATA nState       INIT lvgsNORMAL

   DATA nGroupId

   DATA oParent

   METHOD New( oParent )      CONSTRUCTOR
   METHOD Create( oParent )   CONSTRUCTOR
   METHOD Destroy()           INLINE ( ::oParent := nil )

   METHOD InsertInList()

   METHOD SetState( nState )

ENDCLASS

//------------------------------------------------------------------------------

METHOD New( oParent, nPos ) CLASS TListViewGroup

   if !Empty( oParent )
      ::oParent   := oParent
   end if

RETURN Self

//------------------------------------------------------------------------------

METHOD Create( oParent ) CLASS TListViewGroup

   if !Empty( oParent )
      ::oParent   := oParent
   end if

   if ::nGroupId == nil
      ::nGroupId  := Len( ::oParent:aGroups ) + 1
   endif

   if !Empty( ::oParent ) .and. ( ::oParent:hWnd != 0 )
      if ::InsertInList() > -1
         aAdd( ::oParent:aGroups, Self )
      end if
   end if

RETURN Self

//------------------------------------------------------------------------------

METHOD InsertInList()

   local nGroupId

   nGroupId       := LvInsertGroupInList( ::oParent:hWnd, ::nGroupId, ::cHeader, ::nState )
   if nGroupId > -1
      ::nGroupId  := nGroupId
   end if

RETURN ( nGroupId )

//------------------------------------------------------------------------------

METHOD SetState( nState )

   ::nState       := nState

RETURN ( LvGroupSetState( ::oParent:hWnd, ::nGroupId, ::nState ) )

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------

#pragma BEGINDUMP

#define HB_OS_WIN_32_USED
#define _WIN32_IE 0x0560

#define NONAMELESSUNION

#ifndef __FLAT__
   #define LPCWSTR LPSTR
   #define LPWSTR  LPSTR
   #define NMHDR   void *
   #define WCHAR   char
#endif

#include <Windows.h>
#include <CommCtrl.h>

void _bset( char * pDest, LONG lValue, LONG lLen );

typedef struct _LVITEM {
  UINT mask;
  int iItem;
  int iSubItem;
  UINT state;
  UINT stateMask;
  LPTSTR pszText;
  int cchTextMax;
  int iImage;
  LPARAM lParam;
  #if (_WIN32_IE >= 0x0300)
    int iIndent;
  #endif
    int iGroupId;
} LVITEMNEW;

typedef struct tagLVGROUP
{
    UINT    cbSize;
    UINT    mask;
    LPWSTR  pszHeader;
    int     cchHeader;
    LPWSTR  pszFooter;
    int     cchFooter;
    int     iGroupId;
    UINT    stateMask;
    UINT    state;
    UINT    uAlign;
} LVGROUP, *PLVGROUP;

#define LVGF_NONE               0x00000000
#define LVGF_HEADER             0x00000001
#define LVGF_FOOTER             0x00000002
#define LVGF_STATE              0x00000004
#define LVGF_ALIGN              0x00000008
#define LVGF_GROUPID            0x00000010

#define LVGF_SUBSETITEMS        0x00010000  // readonly, cItems holds count of items in visible subset, iFirstItem is valid

#define LVIF_GROUPID            0x0100
#define LVIF_COLUMNS            0x0200

#define LVM_INSERTGROUP         (LVM_FIRST + 145)
#define ListView_InsertGroup(hwnd, index, pgrp)       SNDMSG((hwnd), LVM_INSERTGROUP, (WPARAM)(index), (LPARAM)(pgrp))

#define LVM_ENABLEGROUPVIEW     (LVM_FIRST + 157)
#define ListView_EnableGroupView(hwnd, fEnable)       SNDMSG((hwnd), LVM_ENABLEGROUPVIEW, (WPARAM)(fEnable), 0)

#define LVM_SETGROUPINFO         (LVM_FIRST + 147)
#define ListView_SetGroupInfo(hwnd, iGroupId, pgrp)   SNDMSG((hwnd), LVM_SETGROUPINFO, (WPARAM)iGroupId, (LPARAM)pgrp)

#define LVIS_FOCUSED            0x0001
#define LVIS_SELECTED           0x0002
#define LVIS_CUT                0x0004
#define LVIS_DROPHILITED        0x0008
#define LVIS_ACTIVATING         0x0020

#define LVIS_OVERLAYMASK        0x0F00
#define LVIS_STATEIMAGEMASK     0xF000

#define LVGS_NORMAL             0x00000000
#define LVGS_COLLAPSED          0x00000001
#define LVGS_HIDDEN             0x00000002
#define LVGS_NOHEADER           0x00000004
#define LVGS_COLLAPSIBLE        0x00000008
#define LVGS_FOCUSED            0x00000010
#define LVGS_SELECTED           0x00000020
#define LVGS_SUBSETED           0x00000040
#define LVGS_SUBSETLINKFOCUSED  0x00000080

//-------------------------------------------------------------------------//

LPWSTR AnsiToWide( LPSTR szAnsi )
{
   int nLen = MultiByteToWideChar( CP_ACP, MB_PRECOMPOSED, szAnsi, -1, NULL, 0 );

   if( nLen )
   {
      LPWSTR szWide = ( LPWSTR ) hb_xgrab( nLen * 2 );

      if( MultiByteToWideChar( CP_ACP, MB_PRECOMPOSED, szAnsi, -1, szWide, nLen ) )
         return szWide;
      else
         hb_xfree( szWide );
   }

   return NULL;
}

//-------------------------------------------------------------------------//

HB_FUNC ( LVINSERTITEM ) // ( hWnd, nImageListIndex, cText ) --> nItem
{
   LVITEMNEW lvi;
   HWND hWnd   = ( HWND ) hb_parnl( 1 );

   _bset( ( char * ) &lvi, 0, sizeof( lvi ) );

   lvi.mask    = LVIF_TEXT | LVIF_IMAGE;
   lvi.iItem   = ListView_GetItemCount( hWnd );
   lvi.iImage  = hb_parnl( 2 );
   lvi.pszText = ( LPTSTR ) hb_parc( 3 );

   hb_retnl( ListView_InsertItem( hWnd, &lvi ) );
}

//-------------------------------------------------------------------------//

HB_FUNC ( LVINSERTITEMGROUP ) // ( hWnd, nImageListIndex, cText ) --> nItem
{
   LVITEMNEW lvi;
   HWND hWnd      = ( HWND ) hb_parnl( 1 );

   _bset( ( char * ) &lvi, 0, sizeof( lvi ) );

   lvi.mask       = LVIF_TEXT | LVIF_IMAGE | LVIF_GROUPID;
   lvi.iItem      = ListView_GetItemCount( hWnd );
   lvi.iImage     = hb_parnl( 2 );
   lvi.pszText    = ( LPTSTR ) hb_parc( 3 );
   lvi.iGroupId   = hb_parnl( 4 );

   hb_retnl( ListView_InsertItem( hWnd, &lvi ) );
}

//-------------------------------------------------------------------------//

HB_FUNC( LVINSERTINLIST )
{
   LVITEMNEW lvi;
   HWND hWnd         = ( HWND ) hb_parnl( 1 );
   int nGroup        = hb_parnl( 4 );

   _bset( ( char * ) &lvi, 0, sizeof( lvi ) );

   lvi.mask          = LVIF_IMAGE | LVIF_TEXT | LVIF_GROUPID;
   lvi.iItem         = ListView_GetItemCount( hWnd );
   lvi.iImage        = hb_parnl( 2 );
   lvi.pszText       = ( LPTSTR ) hb_parc( 3 );

   if( nGroup )
      {
      lvi.mask       |= LVIF_GROUPID;
      lvi.iGroupId   = nGroup;
      }

   hb_retnl( ListView_InsertItem( hWnd, &lvi ) );
}

//-------------------------------------------------------------------------//
// hwndList is the HWND of the control.

HB_FUNC ( LVINSERTGROUPINLIST ) // ( pnmv ) --> nItem
{
   LVGROUP group;

   HWND hWnd         = ( HWND ) hb_parnl( 1 );
   LPWSTR pWide      = AnsiToWide( ( LPTSTR ) hb_parc( 3 ) );
   int nState        = hb_parnl( 4 );

   _bset( ( char * ) &group, 0, sizeof( group ) );

   group.cbSize      = sizeof( LVGROUP );
   group.iGroupId    = hb_parnl( 2 );
   group.pszHeader   = pWide;

   switch( nState )
      {
      case 0   :

         group.mask  = LVGF_GROUPID | LVGF_HEADER | LVGF_SUBSETITEMS ;
         /*
         group.mask  = LVGF_STATE | LVGF_GROUPID | LVGF_HEADER | LVGF_SUBSETITEMS ;
         group.state = LVGS_COLLAPSIBLE | LVGS_NORMAL;
         */
         break;

      case 1   :

         group.mask  = LVGF_STATE | LVGF_GROUPID | LVGF_HEADER | LVGF_SUBSETITEMS ;
         group.state = LVGS_SELECTED | LVGS_COLLAPSIBLE | LVGS_COLLAPSED;
         break;

      case 2   :

         group.mask  = LVGF_STATE;
         group.state = LVGS_SELECTED | LVGS_HIDDEN;
         break;
      }

    hb_retnl( ListView_InsertGroup( hWnd, -1, &group) );

    hb_xfree( ( void * ) pWide );
}

//-------------------------------------------------------------------------//

HB_FUNC ( LVGROUPSETSTATE )
{
   LVGROUP group;

   HWND hWnd         = ( HWND ) hb_parnl( 1 );
   int nIndex        = hb_parni( 2 );
   int nState        = hb_parni( 3 );

   _bset( ( char * ) &group, 0, sizeof( group ) );

   group.cbSize      = sizeof( LVGROUP );
   group.iGroupId    = nIndex;

   switch( nState )
      {
      case LVGS_NORMAL   :
         group.mask  = LVGF_STATE | LVGF_GROUPID | LVGF_HEADER | LVGF_SUBSETITEMS ;
         group.state = LVGS_SELECTED | LVGS_NORMAL;
         break;

      case LVGS_COLLAPSED:
         group.mask  = LVGF_STATE | LVGF_GROUPID | LVGF_HEADER | LVGF_SUBSETITEMS ;
         group.state = LVGS_SELECTED | LVGS_COLLAPSIBLE | LVGS_COLLAPSED;
         break;

      case LVGS_HIDDEN   :
         group.mask  = LVGF_STATE;
         group.state = LVGS_SELECTED | LVGS_HIDDEN;
         break;
      }

   ListView_SetGroupInfo( hWnd, nIndex, (LPARAM) &group );

   InvalidateRect( hWnd, NULL, FALSE );

   hb_retni( nState );
}

//-------------------------------------------------------------------------//

HB_FUNC ( LVENABLEGROUPVIEW ) // ( pnmv ) --> nItem
{
    hb_retnl( ListView_EnableGroupView( ( HWND ) hb_parnl( 1 ), 1 ) );
}

//-------------------------------------------------------------------------//

HB_FUNC ( LVFINDITEM ) // ( hWnd, nImageListIndex, cText ) --> nItem
{
   LVFINDINFO lvi;

   HWND hWnd   = ( HWND ) hb_parnl( 1 );

   _bset( ( char * ) &lvi, 0, sizeof( lvi ) );

   lvi.flags   = LVFI_PARTIAL;
   lvi.psz     = ( LPTSTR ) hb_parc( 2 );

   hb_retnl( ListView_FindItem( hWnd, -1, &lvi ) );
}

//-------------------------------------------------------------------------//

HB_FUNC ( LVSETITEMSELECT )
{
   HWND hWnd   = ( HWND ) hb_parnl( 1 );

   ListView_EnsureVisible( hWnd, hb_parnl( 2 ), FALSE );
   ListView_SetItemState( hWnd, -1, 0, LVIS_SELECTED );
   ListView_SetItemState( hWnd, hb_parnl( 2 ), (LVIS_SELECTED | LVIS_FOCUSED), (LVIS_SELECTED | LVIS_FOCUSED) );
}

//-------------------------------------------------------------------------//

HB_FUNC( LVSETGROUP )
{
   HWND hWnd   = ( HWND ) hb_parnl( 1 );
   int nId     = hb_parnl( 2 );
   int nGroup  = hb_parnl( 3 );

   LVITEMNEW lvi;
   _bset( ( char * ) &lvi, 0, sizeof( lvi ) );
   lvi.iItem      = nId;
   lvi.mask       = LVIF_GROUPID | LVIF_COLUMNS;
   lvi.iGroupId   = nGroup;
   ListView_SetItem( hWnd, ( LPARAM ) &lvi );

   hb_retnl( nGroup );
}

#pragma ENDDUMP

//-----------------------------------------------------------------------------