// Windows 95 TreeView support

#include "FiveWin.Ch"
#include "Constant.ch"

#define GWL_STYLE          -16
#define GWL_EXSTYLE        -20

#define COLOR_WINDOW         5
#define COLOR_WINDOWTEXT     8
#define COLOR_BTNFACE       15
#define COLOR_BTNSHADOW     16
#define COLOR_BTNHIGHLIGHT  20

#define FD_BORDER            8
#define FD_HEIGHT           22

#define DT_CENTER            1
#define DT_VCENTER           4

#define WINDING              2
#define SC_KEYMENU       61696 // 0xF100

#define TVS_HASBUTTONS       1
#define TVS_HASLINES         2
#define TVS_LINESATROOT      4
#define TVS_DISABLEDRAGDROP 16 //   0x0010
#define TVS_SHOWSELALWAYS   32 //   0x0020
#define TVS_TRACKSELECT    512 //   0x0200

#define TVN_FIRST               (-400) // treeview
#define TVN_ITEMEXPANDINGA      (TVN_FIRST-5)
#define TVN_ITEMEXPANDINGW      (TVN_FIRST-54)
#define TVN_ITEMEXPANDEDA       (TVN_FIRST-6)
#define TVN_SELCHANGEDW         (TVN_FIRST-51)


#define CTRL_NAME               "SysTreeView32"

//====== Generic WM_NOTIFY notification codes =================================

#define NM_OUTOFMEMORY          (NM_FIRST-1)
#define NM_CLICK                (NM_FIRST-2)    // uses NMCLICK struct
#define NM_DBLCLK               (NM_FIRST-3)
#define NM_RETURN               (NM_FIRST-4)
#define NM_RCLICK               (NM_FIRST-5)    // uses NMCLICK struct
#define NM_RDBLCLK              (NM_FIRST-6)
#define NM_SETFOCUS             (NM_FIRST-7)
#define NM_KILLFOCUS            (NM_FIRST-8)
#define NM_CUSTOMDRAW           (NM_FIRST-12)
#define NM_HOVER                (NM_FIRST-13)
#define NM_NCHITTEST            (NM_FIRST-14)   // uses NMMOUSE struct
#define NM_KEYDOWN              (NM_FIRST-15)   // uses NMKEY struct
#define NM_RELEASEDCAPTURE      (NM_FIRST-16)
#define NM_SETCURSOR            (NM_FIRST-17)   // uses NMMOUSE struct
#define NM_CHAR                 (NM_FIRST-18)   // uses NMCHAR struct
#define NM_TOOLTIPSCREATED      (NM_FIRST-19)   // notify of when the tooltips window is create
#define NM_LDOWN                (NM_FIRST-20)
#define NM_RDOWN                (NM_FIRST-21)

//====== WM_NOTIFY codes (NMHDR.code values) ==================================

#define NM_FIRST                (0U-  0U)       // generic to all controls
#define NM_LAST                 (0U- 99U)

#define LVN_FIRST               (0U-100U)       // listview
#define LVN_LAST                (0U-199U)

//----------------------------------------------------------------------------//

CLASS TTreeView FROM TControl

   DATA   aItems
   DATA   oImageList
   DATA   bChanged
   DATA   bItemChanged
   DATA   bItemSelectChanged
   DATA   bAction

   METHOD New( nTop, nLeft, oWnd, nClrFore,;
               nClrBack, lPixel, lDesign, nWidth, nHeight,;
               cMsg ) CONSTRUCTOR

   METHOD ReDefine( nId, oWnd, nClrFore, nClrBack, lDesign, cMsg ) CONSTRUCTOR

   METHOD Add( cPrompt, nImage )

   METHOD VScroll( nWParam, nLParam ) VIRTUAL   // standard behavior requested

   METHOD HScroll( nWParam, nLParam ) VIRTUAL

   METHOD Expand() INLINE AEval( ::aItems, { | oItem | oItem:Expand() } )

   METHOD ExpandAll( oItem ) INLINE ScanItems( ::aItems, .t. )

   METHOD GetItem( hItem )

   METHOD Select( oItem ) INLINE TVSelect( ::hWnd, oItem:hItem )

   METHOD GetSelText() INLINE TVGetSelText( ::hWnd )

   METHOD SelChanged() INLINE If( ::bChanged != nil, Eval( ::bChanged, Self ), nil )

   METHOD SetImageList( oImageList )

   METHOD GetSelected()

   METHOD GetText( cPrompt ) INLINE ScanTextItem( ::aItems, cPrompt )

   #ifdef __HARBOUR__
      METHOD DeleteAll() INLINE ( TvDeleteAllItems( ::hWnd ), ::aItems := {} )
   #else
      METHOD DeleteAll() INLINE ( TvDelAllItems( ::hWnd ), ::aItems := {} )
   #endif

   Method SetItemHeight( nHeight )  INLINE ( TvSetItemHeight( ::hWnd, nHeight ) )

   METHOD HitTest(nRow, nCol)

   Method SetTrackSelect() INLINE SetWindowLong( ::hWnd, GWL_EXSTYLE, nOr( GetWindowLong( ::hWnd, GWL_EXSTYLE ), TVS_TRACKSELECT ) )

   METHOD MouseMove( nRow, nCol, nKeyFlags )    VIRTUAL

   METHOD Notify( nIdCtrl, nPtrNMHDR )

   METHOD Toggle() INLINE aEval( ::aItems, {| oItem | oItem:Toggle() } )

   METHOD ToggleBranch( oItem ) INLINE ;
      If( oItem == nil, oItem := ::GetSelected(), nil ), ;
      If( oItem != nil, ( oItem:Toggle(), ScanItems( oItem:aItems, , .t. ) ), nil )

   METHOD GetCheck( oItem ) INLINE ;
      If( oItem == nil, oItem := ::GetSelected(), nil ), ;
      TVGetCheck( ::hWnd, oItem:hItem )

   METHOD SetCheck( oItem, lOnOff ) INLINE ;
      If( oItem == nil, oItem := ::GetSelected(), nil ), ;
      TVSetCheckState( ::hWnd, oItem:hItem, lOnOff )
      // TVSetCheck( ::hWnd, oItem:hItem, lOnOff )

   METHOD SetColor( nClrText, nClrPane ) INLINE ;
      Super:SetColor( nClrText, nClrPane ), ;
      TVSetColor( ::hWnd, nClrText, nClrPane )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( nTop, nLeft, oWnd, nClrFore,;
            nClrBack, lPixel, lDesign, nWidth, nHeight, cMsg ) CLASS TTreeView

   DEFAULT nTop      := 0,;
           nLeft     := 0,;
           oWnd      := GetWndDefault(),;
           nClrFore  := oWnd:nClrText,;
           nClrBack  := GetSysColor( COLOR_WINDOW ),;
           lPixel    := .f.,;
           lDesign   := .f.,;
           nWidth    := 200,;
           nHeight   := 150

   ::nStyle    = nOR(   WS_CHILD,;
                        WS_VISIBLE,;
                        TVS_DISABLEDRAGDROP,;
                        TVS_TRACKSELECT,;
                        TVS_LINESATROOT,;
                        TVS_HASBUTTONS )

//                      TVS_SHOWSELALWAYS,;
//                      WS_TABSTOP,;
//                      TVS_HASLINES,;

   ::nId       = ::GetNewId()
   ::oWnd      = oWnd
   ::cMsg      = cMsg
   ::nTop      = If( lPixel, nTop, nTop * SAY_CHARPIX_H )
   ::nLeft     = If( lPixel, nLeft, nLeft * SAY_CHARPIX_W )
   ::nBottom   = ::nTop + nHeight - 1
   ::nRight    = ::nLeft + nWidth - 1
   ::lDrag     = lDesign
   ::lCaptured = .f.
   ::nClrText  = nClrFore
   ::nClrPane  = nClrBack
   ::aItems    = {}

   if !Empty( oWnd:hWnd )
      ::Create( CTRL_NAME )
      oWnd:AddControl( Self )
      ::SetColor( nClrFore, nClrBack )
   else
      oWnd:DefControl( Self )
   endif

   ::Default()

   if lDesign
      ::CheckDots()
   endif

return Self

//----------------------------------------------------------------------------//

METHOD ReDefine( nId, oWnd, nClrFore, nClrBack, lDesign, cMsg ) CLASS TTreeView

   DEFAULT oWnd     := GetWndDefault(),;
           nClrFore := oWnd:nClrText,;
           nClrBack := GetSysColor( COLOR_WINDOW ),;
           lDesign  := .f.

   ::nId     = nId
   ::oWnd    = oWnd
   ::aItems  = {}

   ::Register( nOR(     CS_VREDRAW,;
                        CS_HREDRAW,;
                        TVS_HASBUTTONS,;
                        TVS_HASLINES,;
                        TVS_TRACKSELECT,;
                        TVS_LINESATROOT ) )
   oWnd:DefControl( Self )

return Self

//----------------------------------------------------------------------------//

METHOD Add( cPrompt, nImage, bAction ) CLASS TTreeView

   local oItem

   oItem := TTVItem():New( TVInsertItem( ::hWnd, cPrompt, , nImage ), Self )

   oItem:cPrompt := cPrompt
   oItem:nImage  := nImage
   oItem:bAction := bAction

   AAdd( ::aItems, oItem )

return oItem

//----------------------------------------------------------------------------//

METHOD GetItem( hItem ) CLASS TTreeView

   DEFAULT hItem  := TVGetSelected( ::hWnd )

return ScanItem( ::aItems, hItem )

//----------------------------------------------------------------------------//

METHOD HitTest(nRow, nCol) CLASS TTreeView

   local hItem

   hItem := TVHitTest( ::hWnd, nRow, nCol )

   If hItem > 0
      return ::GetItem( hItem )
   Endif

return nil

//----------------------------------------------------------------------------//

METHOD SetImageList( oImageList ) CLASS TTreeView

   ::oImageList = oImageList

   TVSetImageList( ::hWnd, oImageList:hImageList, 0 )

return nil

//----------------------------------------------------------------------------//

METHOD GetSelected()

   local oItem := ScanItem( ::aItems, TVGetSelected( ::hWnd ) )

   if !Empty( oItem )
      Return ( oItem )
   end if

Return ( Self )

//----------------------------------------------------------------------------//

METHOD Notify( nIdCtrl, nPtrNMHDR ) CLASS TTreeView

   local nCode := GetNMHDRCode( nPtrNMHDR )

   do case
      case nCode == -24 //-419 // -401 // -530 //TVN_SELCHANGEDW

         if !Empty( ::bItemSelectChanged )
            Eval( ::bItemSelectChanged, Self )
         end if

      case nCode == -401 //-419 // -401 // -530 //TVN_SELCHANGEDW

         if !Empty( ::bItemChanged )
            Eval( ::bItemChanged, Self )
         end if

   end case

return ( nil )

//----------------------------------------------------------------------------//

static function ScanItems( aItems, lExpand, lToggle )

   local oItem, i

   DEFAULT lExpand := .t., lToggle := .f.

   for i := 1 to Len( aItems )

       oItem = aItems[ i ]

       if lToggle
          oItem:Toggle()
       elseif lExpand
          oItem:Expand()
       else
          oItem:Collapse()
       endif

       if Len( oItem:aItems ) != 0
          ScanItems( oItem:aItems, lExpand, lToggle )
       endif
   next

return nil

//----------------------------------------------------------------------------//

static function ScanPosItem( aItems, hItem )

   local n

   for n = 1 to Len( aItems )
      if aItems[ n ]:hItem == hItem
         return ( n )
      endif
      if Len( aItems[ n ]:aItems ) > 0
         return ScanPosItem( aItems[ n ]:aItems, hItem )
      endif
   next

return nil

//----------------------------------------------------------------------------//

static function ScanItem( aItems, hItem )

   local n, oItem

   for n = 1 to Len( aItems )
      if Len( aItems[ n ]:aItems ) > 0
         if ( oItem := ScanItem( aItems[ n ]:aItems, hItem ) ) != nil
            return oItem
         endif
      endif
      if aItems[ n ]:hItem == hItem
         return aItems[ n ]
      endif
   next

return nil

//----------------------------------------------------------------------------//

static function ScanTextItem( aItems, cPrompt )

   local n, oItem

   for n = 1 to Len( aItems )
      if Len( aItems[ n ]:aItems ) > 0
         if ( oItem := ScanTextItem( aItems[ n ]:aItems, cPrompt ) ) != nil
            return oItem
         endif
      endif
      if aItems[ n ]:cPrompt == cPrompt
         return aItems[ n ]
      endif
   next

return nil

//----------------------------------------------------------------------------//