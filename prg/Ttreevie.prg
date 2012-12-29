// Win32 TreeView support

#include "FiveWin.ch"
#include "Constant.ch"

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
#define SC_KEYMENU       61696 //  0xF100

#define TVS_HASBUTTONS       1
#define TVS_HASLINES         2
#define TVS_LINESATROOT      4
#define TVS_SHOWSELALWAYS   32 //  0x0020
#define TVS_DISABLEDRAGDROP 16 //  0x0010
#define TVS_CHECKBOXES     256 //  0x0100
#define TVS_TRACKSELECT    512 //   0x0200

#ifdef __CLIPPER__
   #define CTRL_NAME "SysTreeView"
#else
   #define CTRL_NAME "SysTreeView32"
#endif

#ifdef __XPP__
   #define Super ::TControl
   #define ScanItems ScanItem
#endif

//----------------------------------------------------------------------------//

CLASS TTreeView FROM TControl

   DATA   aItems
   DATA   oImageList
   DATA   bChanged

   CLASSDATA aProperties ;
      INIT { "aItems", "cTitle", "cVarName", "l3D", "nClrText",;
             "nClrPane", "nAlign", "nTop", "nLeft",;
             "nWidth", "nHeight", "oFont", "Cargo" }

   METHOD New( nTop, nLeft, oWnd, nClrFore,;
               nClrBack, lPixel, lDesign, nWidth, nHeight,;
               cMsg, lCheckBoxes ) CONSTRUCTOR

   METHOD ReDefine( nId, oWnd, nClrFore, nClrBack, lDesign, cMsg ) CONSTRUCTOR

   METHOD Add( cPrompt, nImage, nValue )

   METHOD VScroll( nWParam, nLParam ) VIRTUAL   // standard behavior requested

   METHOD HScroll( nWParam, nLParam ) VIRTUAL

   METHOD CollapseAll( oItem ) INLINE ScanItems( ::aItems, .f. ),;
      oItem := ::GetSelected(), if( oItem <> nil, oItem:MakeVisible(), nil )

   METHOD CollapseBranch( oItem ) INLINE ;
      If( oItem == nil, oItem := ::GetSelected(),), ;
      If( oItem != nil, ( oItem:Collapse(), ScanItems( oItem:aItems, .f. ), oItem:MakeVisible() ),)

   METHOD Expand() INLINE AEval( ::aItems, { | oItem | oItem:Expand() } )

   METHOD ExpandAll( oItem ) INLINE ScanItems( ::aItems, .t. ),;
      oItem := ::GetSelected(), if( oItem <> nil, oItem:MakeVisible(), nil )

   METHOD ExpandBranch( oItem ) INLINE ;
      If( oItem == nil, oItem := ::GetSelected(), nil ), ;
      If( oItem != nil, ( oItem:Expand(), ScanItems( oItem:aItems, .t. ), oItem:MakeVisible() ), nil )

   METHOD GetSelected()
   METHOD GetItem( hItem )

   METHOD Select( oItem ) INLINE TVSelect( ::hWnd, oItem:hItem )

   METHOD GetSelText() INLINE TVGetSelText( ::hWnd )

   METHOD GoTop() INLINE If( Len( ::aItems ) > 0, ::Select( ::aItems[ 1 ] ),)

   METHOD SelChanged() INLINE If( ::bChanged != nil, Eval( ::bChanged, Self ), nil )

   METHOD SetImageList( oImageList )

   METHOD DeleteAll() INLINE ( TVDelAllItems( ::hWnd ), ::aItems := {} )

   METHOD HitTest( nRow, nCol )

   METHOD HandleEvent( nMsg, nWParam, nLParam )

   METHOD Initiate( hDlg ) INLINE Super:Initiate( hDlg ), ::SetColor( ::nClrText, ::nClrPane )

   METHOD cToChar() INLINE Super:cToChar( CTRL_NAME )

   METHOD SetColor( nClrText, nClrPane ) INLINE ;
      Super:SetColor( nClrText, nClrPane ), TVSetColor( ::hWnd, nClrText, nClrPane )

   METHOD Toggle() INLINE AEval( ::aItems, { | oItem | oItem:Toggle() } )

   METHOD ToggleAll( oItem ) INLINE ScanItems( ::aItems, , .t. ), ;
      oItem := ::GetSelected(), If( oItem <> nil, oItem:MakeVisible(), nil )

   METHOD ToggleBranch( oItem ) INLINE ;
      If( oItem == nil, oItem := ::GetSelected(), nil ), ;
      If( oItem != nil, ( oItem:Toggle(), ScanItems( oItem:aItems, , .t. ), oItem:MakeVisible() ), nil )

   METHOD GetCheck( oItem ) INLINE ;
      If( oItem == nil, oItem := ::GetSelected(), nil ), ;
      TVGetCheck( ::hWnd, oItem:hItem )

   METHOD SetCheck( oItem, lOnOff ) INLINE ;
      If( oItem == nil, oItem := ::GetSelected(), nil ), ;
      TVSetCheck( ::hWnd, oItem:hItem, lOnOff )

   METHOD SetItems( aItems )

   Method SetItemHeight( nHeight )  INLINE ( TvSetItemHeight( ::hWnd, nHeight ) )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( nTop, nLeft, oWnd, nClrFore,;
            nClrBack, lPixel, lDesign, nWidth, nHeight, cMsg, lCheckBoxes ) CLASS TTreeView

   DEFAULT nTop        := 0, nLeft := 0,;
           oWnd        := GetWndDefault(),;
           nClrFore    := oWnd:nClrText,;
           nClrBack    := GetSysColor( COLOR_WINDOW ),;
           lPixel      := .f.,;
           lDesign     := .f.,;
           nWidth      := 150, nHeight := 150,;
           lCheckBoxes := .F.

   ::nStyle    = nOR(   WS_CHILD,;
                        WS_VISIBLE,;
                        TVS_DISABLEDRAGDROP,;
                        TVS_TRACKSELECT,;
                        TVS_HASBUTTONS )

   ::nStyle    = nOR(   WS_CHILD,;
                        WS_VISIBLE,;
                        TVS_DISABLEDRAGDROP,;
                        TVS_TRACKSELECT,;
                        TVS_HASBUTTONS )


                        // TVS_HASLINES,;

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

   if ! Empty( oWnd:hWnd )
      ::Create( CTRL_NAME )
      oWnd:AddControl( Self )
      ::SetColor( nClrFore, nClrBack )
   else
      oWnd:DefControl( Self )
   endif

   ::Default()
   ::lDrag = lDesign

   if lDesign
      ::CheckDots()
   endif

return Self

//----------------------------------------------------------------------------//

METHOD ReDefine( nId, oWnd, nClrFore, nClrBack, lDesign, cMsg ) CLASS TTreeView

   DEFAULT oWnd     := GetWndDefault(),;
           nClrFore := oWnd:nClrText,;
           nClrBack := oWnd:nClrPane,; // GetSysColor( COLOR_WINDOW ),;
           lDesign  := .f.

   ::nId     = nId
   ::oWnd    = oWnd
   ::aItems  = {}
   ::nClrText = nClrFore
   ::nClrPane = nClrBack

   ::Register( nOR( CS_VREDRAW, CS_HREDRAW, TVS_HASBUTTONS, TVS_HASLINES, TVS_LINESATROOT ) )

   oWnd:DefControl( Self )

return Self

//----------------------------------------------------------------------------//

METHOD Add( cPrompt, nImage, nValue ) CLASS TTreeView

   local oItem

   oItem := TTVItem():New( TVInsertItem( ::hWnd, cPrompt,, nImage, nValue ), Self )

   oItem:cPrompt := cPrompt
   oItem:nImage  := nImage

   AAdd( ::aItems, oItem )

return oItem

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

METHOD GetSelected() CLASS TTreeView

return SearchItem( ::aItems, TVGetSelected( ::hWnd ) )

//----------------------------------------------------------------------------//

METHOD GetItem( hItem ) CLASS TTreeView

return SearchItem( ::aItems, hItem )

//----------------------------------------------------------------------------//

METHOD HitTest( nRow, nCol ) CLASS TTreeView

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

METHOD HandleEvent( nMsg, nWParam, nLParam ) CLASS TTreeView

   do case
      case nMsg == WM_CHAR
           if nWParam == VK_RETURN
              return 1
           endif
   endcase

return Super:HandleEvent( nMsg, nWParam, nLParam )

//----------------------------------------------------------------------------//

METHOD SetItems( aItems ) CLASS TTreeView

   local n

   for n = 1 to Len( aItems )
      ::Add( aItems[ n ] )
   next

return nil

//----------------------------------------------------------------------------//

static function SearchItem( aItems, hItem )

   local n, oItem

   for n = 1 to Len( aItems )
      if Len( aItems[ n ]:aItems ) > 0
         if ( oItem := SearchItem( aItems[ n ]:aItems, hItem ) ) != nil
            return oItem
         endif
      endif
      if aItems[ n ]:hItem == hItem
         return aItems[ n ]
      endif
   next

return nil

//----------------------------------------------------------------------------//