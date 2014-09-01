// Win32 ListView Common Control support

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

#define CTRL_CLASS            "SysListView32"

//----------------------------------------------------------------------------//

CLASS TListView FROM TControl

   CLASSDATA aProperties   INIT { "nAlign", "nClrText", "nClrPane", "nOption",;
                                  "nTop", "nLeft", "nWidth", "nHeight", "Cargo" }

   DATA  aPrompts
   DATA  aItems            INIT {}
   DATA  aGroups           INIT {}
   DATA  bAction
   DATA  bClick
   DATA  nOption
   DATA  nGroups           INIT 0

   METHOD New( nTop, nLeft, aPrompts, bAction, oWnd, nClrFore,;
               nClrBack, lPixel, lDesign, nWidth, nHeight,;
               cMsg ) CONSTRUCTOR

   METHOD ReDefine( nId, oWnd, bAction ) CONSTRUCTOR

   METHOD Default()

   METHOD Display()                          INLINE ::BeginPaint(), ::Paint(), ::EndPaint(), 0

   METHOD EraseBkGnd( hDC )                  INLINE 1

   METHOD InsertItem( nImageIndex, cText, nGroup )  INLINE LVInsertItem( ::hWnd, nImageIndex, cText, nGroup )

   METHOD InsertGroup( cText )               INLINE LVInsertGroup( ::hWnd, cText, ::nGroups++ )

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

   oWnd:DefControl( Self )

return Self

//----------------------------------------------------------------------------//

METHOD Default() CLASS TListView

   local n

   ::InsertGroup( "default" )

   for n = 1 to Len( ::aPrompts )
      ::InsertItem( n - 1, ::aPrompts[ n ] )
   next

return ::Super:Default()

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
   local nCode          := GetNMHDRCode( nPtrNMHDR )

   do case
      case nCode == NM_CLICK
         nOption = GetNMListViewItem( nPtrNMHDR ) + 1

         if ::bClick != nil
            ::nOption   := nOption
            Eval( ::bClick, ::nOption, Self )
         endif

      case nCode == LVN_ITEMCHANGED
         nOption = GetNMListViewItem( nPtrNMHDR ) + 1

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

METHOD GetItem( nItem ) CLASS TListView

   if nItem > 0 .and. nItem <= Len( ::aItems )
      return ::aItems[ nItem ]
   endif

return nil

//----------------------------------------------------------------------------//

CLASS TListViewItem

   DATA  oParent

   DATA  cText    INIT ""
   DATA  cToolTip INIT ""
   DATA  nImage   INIT 0
   DATA  nGroup   INIT 0
   DATA  nIndent  INIT 0
   DATA  lChecked INIT .F.

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

   if ! Empty( oParent )
      ::oParent := oParent
   end if

return Self

//------------------------------------------------------------------------------

METHOD Create( oParent ) CLASS TListViewItem

   if !Empty( oParent )
      ::oParent = oParent
   endif

   if ! Empty( ::oParent ) .and. ::oParent:hWnd != 0
      if ::InsertInList() > -1
         AAdd( ::oParent:aItems, Self )
      endif
   endif

return Self

//----------------------------------------------------------------------------//

METHOD InsertInList()

   local nItem := LvInsertInList( ::oParent:hWnd, ::nImage, ::cText, ::nGroup )
   
   if nItem > -1
      ::nItem = nItem
   endif

return nItem

//----------------------------------------------------------------------------//

METHOD Delete() CLASS TListViewItem

   local aItems, lSuccess

   if ( lSuccess := ::DeleteItemC() )

      ::lParam = 0
      aItems   = ::oParent:aItems

      if ::nItem == Len( aItems )
         ASize( aItems, ::nItem - 1 )
      elseif ::nItem > 0
         aItems[ ::nItem ] := nil
      endif

      ::nItem = 0

   endif

return lSuccess

//----------------------------------------------------------------------------//

METHOD SetGroup( nGroup ) CLASS TListViewItem

   local nLen

   if nGroup > 0 .and. AScan( ::oParent:aGroups, { |v| v:nItem == nGroup } ) > 0
      LVSetGroup( nGroup )
   endif

return ::nGroup

//----------------------------------------------------------------------------//

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

   if ! Empty( oParent )
      ::oParent := oParent
   endif

return Self

//----------------------------------------------------------------------------//

METHOD Create( oParent ) CLASS TListViewGroup

   if ! Empty( oParent )
      ::oParent = oParent
   endif

   if ::nGroupId == nil
      ::nGroupId = Len( ::oParent:aGroups ) + 1
   endif

   if ! Empty( ::oParent ) .and. ( ::oParent:hWnd != 0 )
      if ::InsertInList() > -1
         AAdd( ::oParent:aGroups, Self )
      endif
   endif

RETURN Self

//----------------------------------------------------------------------------//

METHOD InsertInList() CLASS TListViewGroup

   local nGroupId := LvInsertGroupInList( ::oParent:hWnd, ::nGroupId, ::cHeader,;
                                          ::nState )
   
   if nGroupId > -1
      ::nGroupId = nGroupId
   endif

return nGroupId

//----------------------------------------------------------------------------//

METHOD SetState( nState ) CLASS TListViewGroup

   ::nState = nState

return LVGroupSetState( ::oParent:hWnd, ::nGroupId, ::nState )

//----------------------------------------------------------------------------//