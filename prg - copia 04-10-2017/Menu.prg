#include "FiveWin.ch"

#define MF_ENABLED       0
#define MF_GRAYED        1
#define MF_DISABLED      2
#define MF_BITMAP        4
#define MF_CHECKED       8
#define MF_POPUP        16  // 0x0010
#define MF_BREAK        64
#define MF_BYPOSITION 1024  // 0x0400
#define MF_SEPARATOR  2048  // 0x0800
#define MF_HELP      16384  // 0x4000
#define MF_HILITE      128  // 0x0080
#define MF_UNHILITE      0
#define MF_OWNERDRAW   256  // 0x0100

static hClass
static aPopups := {}

//----------------------------------------------------------------------------//

CLASS TMenu

   DATA   hMenu
   DATA   aMenuItems
   DATA   oWnd
   DATA   lSysMenu, lPopup
   DATA   nHelpId
   DATA   cVarName
   DATA   oAccTable       // Accelerators table object
   DATA   oMenuItemPopup  // Many thanks to Hernán! It overcomes the limitation
                          // of API TrackPopupMenu() under 16 bits
   DATA   l2007, l2010
   DATA   OnInit          // Visual FW

   CLASSDATA aProperties INIT { "aItems", "cVarName" }
   CLASSDATA aEvents INIT { { "OnInit", "oMenu" } }
   CLASSDATA oLastItem

   METHOD New( lPopup, oWnd, l2007 )  CONSTRUCTOR
   METHOD ReDefine( cResName, lPopup ) CONSTRUCTOR
   METHOD NewSys( oWnd )       CONSTRUCTOR

   METHOD Add( oMenuItem, lRoot )

   METHOD AddEdit()

   METHOD AddFile()

   METHOD AddHelp( cAbout, cCopyRight )

   METHOD AddMdi()

   METHOD aItems() INLINE ::aMenuItems

   METHOD _aItems( aItems )

   METHOD Insert( oMenuItem, nAt )

   METHOD Initiate()

   METHOD cGenPrg()

   METHOD Command( nCommand )

   METHOD LastItem() INLINE ::oLastItem

   METHOD Load( cInfo )

   METHOD GetMenuItem( nItemId ) INLINE SearchItem( ::aMenuItems, nItemId )

   METHOD GetPopup( hPopup )

   METHOD GetSubMenu( hPopup ) INLINE SearchSubMenu( Self, hPopup )

   METHOD HelpTopic()

   METHOD Activate( nRow, nCol, oWnd, lEnd )

   METHOD DelItems()

   METHOD Refresh() INLINE ::oWnd:SetMenu( Self )

   METHOD Reset() INLINE If( ::lSysMenu, GetSystemMenu( ::oWnd:hWnd, .t. ),;
                         DestroyMenu( ::hMenu ) ), ::hMenu := CreateMenu(),;
                         ::aMenuItems := {}

   // METHOD SetSkin()   INLINE if( ::l2007, set2007SkinMenu(), if( ::l2010, set2010SkinMenu(), ) )

   METHOD Destroy() INLINE ( DestroyItems( ::aMenuItems ) )

   METHOD End()

   METHOD Hilite( nPopUp ) INLINE ;
                           HiliteMenuItem( ::oWnd:hWnd, ::hMenu, nPopUp - 1,;
                                           nOr( MF_HILITE, MF_BYPOSITION ) )

   METHOD UnHilite( nPopUp ) INLINE ;
                           HiliteMenuItem( ::oWnd:hWnd, ::hMenu, nPopUp - 1,;
                                           nOr( MF_UNHILITE, MF_BYPOSITION ) )

   METHOD Disable() INLINE ASend( ::aMenuItems, "Disable()" )

   METHOD Enable() INLINE ASend( ::aMenuItems, "Enable()" ),;
                             If( ::oWnd != nil, ::Refresh(),)

   METHOD Save()

   METHOD SaveToText( nIndent )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( lPopup, oWnd, l2007, l2010 ) CLASS TMenu

   DEFAULT lPopup := .F., l2007 := .F., l2010 := .F. // , oWnd := GetWndDefault()

   ::hMenu    = If( lPopup, CreatePopupMenu(), CreateMenu() )
   ::aMenuItems = {}
   ::lSysMenu = .F.
   ::lPopup   = lPopup
   ::l2007    = l2007
   ::l2010    = l2010

   // ::SetSkin()

   if lPopup
      AAdd( aPopups, Self )
   endif

   if oWnd != nil
      oWnd:SetMenu( Self )
   endif

return Self

//----------------------------------------------------------------------------//

METHOD End() CLASS TMenu

   local nAt

   if ::oWnd != nil
      SetMenu( ::oWnd:hWnd, 0 )
   endif

   ::Destroy()
   ::DelItems()
   if ::hMenu != 0
      DestroyMenu( ::hMenu )
      ::hMenu = 0
   endif

   if ( nAt := AScan( aPopups, { | o | o == Self } ) ) != 0
      ADel( aPopups, nAt )
      ASize( aPopups, Len( aPopups ) - 1 )
   endif

   if ::oAccTable != nil
      ::oAccTable:End()
   endif

return nil

//----------------------------------------------------------------------------//

METHOD ReDefine( cResName, lPopup ) CLASS TMenu

   local hMenu := LoadMenu( GetResources(), cResName )
   local n

   ::hMenu    = hMenu
   ::aMenuItems   = {}
   ::lSysMenu = .f.
   ::lPopup   = lPopup

   if lPopup
      // Windows does not provides a way of storing only Popups in resources
      // so we are going to create one on the fly copying it from the
      // one placed at resources
      ::hMenu = CreatePopupMenu()
      MenuClone( ::hMenu, hMenu )
      DestroyMenu( hMenu )
   endif

   ResBuild( Self )

return Self

//----------------------------------------------------------------------------//

METHOD NewSys( oWnd ) CLASS TMenu

   local n

   if oWnd != nil
      ::oWnd  = oWnd
      ::hMenu = GetSystemMenu( oWnd:hWnd, .f. )
   endif
   ::aMenuItems   = {}
   ::lSysMenu = .t.
   ::lPopup   = .F.

return Self

//----------------------------------------------------------------------------//

METHOD Add( oMenuItem, lRoot ) CLASS TMenu

   DEFAULT lRoot := .F., ::l2007 := .F., ::l2010 := .F.

//   ::SetSkin()

   AAdd( ::aMenuItems, oMenuItem )

   oMenuItem:oMenu = Self

   if ValType( oMenuItem:bAction ) == "O" .and. ;
      Upper( oMenuItem:bAction:ClassName() ) == "TMENU"
      if oMenuItem:cPrompt != nil
         AppendMenu( ::hMenu, nOr( MF_POPUP, MF_ENABLED, If( ::l2007 .OR. ::l2010, MF_OWNERDRAW, 0 ),;
                          If( oMenuItem:hBitmap != 0 .or. ( IsWinNT() .and. ! lRoot .and. ! ::lSysmenu), MF_OWNERDRAW, 0 ),;
                          If( oMenuItem:lHelp, MF_HELP, 0 ),;
                          If( oMenuItem:lChecked, MF_CHECKED, 0 ),;
                          If( ! oMenuItem:lActive, MF_GRAYED, 0 ),;
                          If( oMenuItem:lBreak, MF_BREAK, 0 ) ),;
                     oMenuItem:bAction:hMenu,;
                     oMenuItem:cPrompt )
      else
         AppendMenu( ::hMenu, nOR( MF_POPUP, MF_BITMAP,;
                          If( oMenuItem:lChecked, MF_CHECKED, 0 ),;
                          If( ! oMenuItem:lActive, MF_GRAYED, 0 ),;
                          If( oMenuItem:lHelp, MF_HELP, 0 ),;
                          If( oMenuItem:lBreak, MF_BREAK, 0 ) ),;
                     oMenuItem:bAction:hMenu, oMenuItem:hBitmap )
      endif
      AAdd( aPopups, oMenuItem:bAction )
   else
      if oMenuItem:cPrompt != nil
         AppendMenu( ::hMenu,;
                     nOR( If( oMenuItem:lActive,;
                          nOr( MF_ENABLED, If( ::l2007 .OR. ::l2010, MF_OWNERDRAW, 0 ), If( oMenuItem:hBitmap != 0 .or. ;
                          ( /* .f. .and. */ IsWinNT() .and. ! lRoot .and. ! ::lSysMenu ),;
                          MF_OWNERDRAW, 0 ) ),;
                          nOR( MF_DISABLED, MF_GRAYED, MF_OWNERDRAW ) ),;
                          If( oMenuItem:lChecked, MF_CHECKED, 0 ),;
                          If( oMenuItem:lHelp, MF_HELP, 0 ),;
                          If( oMenuItem:lBreak, MF_BREAK, 0 ) ),;
                     oMenuItem:nId, oMenuItem:cPrompt )
      else
         if oMenuItem:hBitmap != 0
            #ifdef __XPP__
               if oMenuItem:lBreak == nil
                  oMenuItem:lBreak = .f.
               endif
            #endif
            AppendMenu( ::hMenu, nOr( MF_BITMAP,;
                        If( oMenuItem:lBreak, MF_BREAK, 0 ) ),;
                        oMenuItem:nId, oMenuItem:hBitmap )
         else
            AppendMenu( ::hMenu, nOr( MF_SEPARATOR, If( ::l2007 .OR. ::l2010, MF_OWNERDRAW, 0 ) ), oMenuItem:nId, "" )
         endif
      endif
   endif

return nil

//----------------------------------------------------------------------------//

METHOD _aItems( aNewItems ) CLASS TMenu

   local n

   for n = 1 to Len( aNewItems )
      ::Add( aNewItems[ n ] )
   next

return nil

//----------------------------------------------------------------------------//

METHOD DelItems() CLASS TMenu

   while Len( ::aMenuItems ) > 0
      ATail( ::aMenuItems ):Destroy()
   end

return nil

//----------------------------------------------------------------------------//

METHOD GetPopup( hPopup ) CLASS TMenu

   local nAt := AScan( aPopups, { | oPopup | oPopup:hMenu == hPopup } )

return If( nAt != 0, aPopups[ nAt ], nil )

//----------------------------------------------------------------------------//

static function SearchSubMenu( oMenu, hMenu )

   local n, oSubMenu

   for n = 1 to Len( oMenu:aMenuItems )
      if ValType( oSubMenu := oMenu:aMenuItems[ n ]:bAction ) == "O"
         if oSubMenu:hMenu == hMenu
            return oSubMenu
         endif
         if ( oSubMenu := SearchSubMenu( oSubMenu, hMenu ) ) != nil
            return oSubMenu
         endif
      endif
   next

return nil

//----------------------------------------------------------------------------//

METHOD Insert( oMenuItem, nAt ) CLASS TMenu

   local oPrevItem := If( nAt <= Len( ::aMenuItems ), ::aMenuItems[ nAt ], nil )

   if oPrevItem == nil
      ::Add( oMenuItem )
      return nil
   endif

   AAdd( ::aMenuItems, nil )
   AIns( ::aMenuItems, nAt )

   ::aMenuItems[ nAt ] = oMenuItem

   oMenuItem:oMenu = Self

   if ValType( oMenuItem:bAction ) == "O" .and. Upper( oMenuItem:bAction:ClassName() ) == "TMENU"
      if oMenuItem:hBitmap == 0
         InsertMenu( ::hMenu, oPrevItem:nId, nOr( MF_POPUP,;
                     If( oMenuItem:lHelp, MF_HELP, 0 ),;
                     If( oMenuItem:lBreak, MF_BREAK, 0 ) ),;
                     oMenuItem:bAction:hMenu,;
                     oMenuItem:cPrompt )
      else
         InsertMenu( ::hMenu, oPrevItem:nId, nOR( MF_POPUP, MF_BITMAP,;
                     If( oMenuItem:lHelp, MF_HELP, 0 ),;
                     If( oMenuItem:lBreak, MF_BREAK, 0 ) ),;
                     oMenuItem:bAction:hMenu, oMenuItem:hBitmap )
      endif
   else
      if oMenuItem:cPrompt != nil
         InsertMenu( ::hMenu, oPrevItem:nId, ;
                    nOR( If( oMenuItem:lActive,;
                    nOr( MF_ENABLED, If( oMenuItem:hBitmap != 0 .or. ;
                    ( IsWinNT() .and. ! ::lSysMenu ),;
                    MF_OWNERDRAW, 0 ) ),;
                    nOR( MF_DISABLED, MF_GRAYED ) ),;
                    If( oMenuItem:lChecked, MF_CHECKED, 0 ),;
                    If( oMenuItem:lHelp, MF_HELP, 0 ),;
                    If( oMenuItem:lBreak, MF_BREAK, 0 ) ),;
                    oMenuItem:nId, oMenuItem:cPrompt )
      else
         if oMenuItem:hBitmap != 0
            InsertMenu( ::hMenu, oPrevItem:nId, nOr( MF_BITMAP,;
                        If( oMenuItem:lBreak, MF_BREAK, 0 ) ),;
                        oMenuItem:nId, oMenuItem:hBitmap )
         else
            InsertMenu( ::hMenu, oPrevItem:nId, MF_SEPARATOR,;
                        oMenuItem:nId, "" )
         endif
      endif
   endif

return nil

//----------------------------------------------------------------------------//

METHOD cGenPrg() CLASS TMenu

   local cPrg := "", nLevel := 2

   GenSubMenu( Self, @cPrg, nLevel )

return cPrg

//----------------------------------------------------------------------------//

static function GenSubMenu( oMenu, cPrg, nLevel )

   local n

   cPrg += Replicate( " ", ( nLevel - 1 ) * 3 ) + "MENU" + If( nLevel == 2, " oMenu", "" ) + ;
           If( oMenu:lPopup, " POPUP", "" ) + CRLF

   for n = 1 to Len( oMenu:aItems )
      cPrg += Replicate( " ", ( nLevel - 1 ) * 3 ) + '   MENUITEM "' + oMenu:aItems[ n ]:cPrompt + '"' + CRLF
      if ValType( oMenu:aItems[ n ]:bAction ) == "O"
         GenSubMenu( oMenu:aItems[ n ]:bAction, @cPrg, nLevel + 1 )
      endif
   next

   cPrg += Replicate( " ", ( nLevel - 1 ) * 3 ) + "ENDMENU" + CRLF

return cPrg

//----------------------------------------------------------------------------//

METHOD Initiate() CLASS TMenu

   local n, lWhen
   local oItem

   DEFAULT ::l2007 := .F., ::l2010 := .F.

//   ::SetSkin()

   if cWinVersion() != "98"
      if ::l2007 .or. ::l2010
         MITEMS2007( ::hMenu )
      endif
   endif

   for n = 1 to Len( ::aMenuItems )
      oItem = ::aMenuItems[ n ]
      if ! Empty( oItem:bWhen )
         lWhen = Eval( oItem:bWhen, oItem )
         if ValType( lWhen ) == "L"
            if lWhen
               oItem:Enable()
            else
               oItem:Disable()
            endif
         endif
      endif
   next

return nil

//----------------------------------------------------------------------------//

METHOD Command( nCommand ) CLASS TMenu

   local oMenuItem := ::GetMenuItem( nCommand )

   if oMenuItem != nil
      if ValType( oMenuItem:bAction ) == "B" .or. ValType( oMenuItem:OnClick ) == "B"
         if oMenuItem:bWhen != nil .and. ! Eval( oMenuItem:bWhen, oMenuItem )
            return nil
         endif
         ::oLastItem = oMenuItem

         if ::lPopup
            ::oMenuItemPopup = oMenuItem
         else
            if oMenuItem:bAction != nil
               Eval( oMenuItem:bAction, oMenuItem )
            else
               Eval( oMenuItem:OnClick, ::oWnd, oMenuItem )
            endif
         endif
      endif
   endif

return nil

//----------------------------------------------------------------------------//

METHOD Activate( nRow, nCol, oWnd, lEnd, nFlags ) CLASS TMenu

   local aPoint := { nRow, nCol }

   DEFAULT lEnd := .t., nFlags := 0

   if oWnd != nil
      aPoint = ClientToScreen( oWnd:hWnd, aPoint )

      if lEnd
         if oWnd:oPopup != nil
            oWnd:oPopup:End()
         endif
      endif
      oWnd:oPopup = Self
      ::Initiate()

      TrackPopup( ::hMenu, nOr( 2, nFlags ), aPoint[ 1 ], aPoint[ 2 ], 0, oWnd:hWnd )

      SysRefresh()
      if ::oMenuItemPopup != nil
         Eval( ::oMenuItemPopup:bAction, ::oMenuItemPopup )
         ::oMenuItemPopup = nil
      endif

      if lEnd
         ::End()
         oWnd:oPopup = nil
      endif
   endif

return nil

//----------------------------------------------------------------------------//

static function SearchItem( aMenuItems, nId )

   local n      := 1
   local lFound := .f.
   local oReturn
   local bAction

   while n <= Len( aMenuItems ) .and. ! lFound
      if aMenuItems[ n ]:nId == nId
         return aMenuItems[ n ]
      else
         bAction = aMenuItems[ n ]:bAction
         if ValType( bAction ) == "O" .and. Upper( bAction:ClassName() ) == "TMENU"
            if aMenuItems[ n ]:bAction:hMenu == nId
               return aMenuItems[ n ]
            else
               oReturn = SearchItem( aMenuItems[ n ]:bAction:aMenuItems, nId )
               if oReturn != nil
                  exit
               endif
            endif
         endif
      endif
      n++
   end

return oReturn

//----------------------------------------------------------------------------//

static function DestroyItems( aMenuItems )

   local n := 1
   local oItem

   while n <= Len( aMenuItems )
      oItem = aMenuItems[ n ]
      if oItem:bAction != nil
         if ValType( oItem:bAction ) == "O" .and. ;
            Upper( oItem:bAction:ClassName() ) == "TMENU"
            DestroyItems( oItem:bAction:aMenuItems )
         endif
      endif
      oItem:End()
      n++
   end

return nil

//----------------------------------------------------------------------------//

static function ResBuild( oMenu )

   local n
   local hMenu := oMenu:hMenu
   local hSubMenu
   local oSubMenu, oMenuItem

   for n = 1 to GetMItemCount( hMenu )
         #ifndef __XPP__
            oMenuItem          = TMenuItem()
         #else
            oMenuItem          = TMenuItem():New()
         #endif
         oMenuItem:nId      = GetMItemID( hMenu, n - 1 )
         oMenuItem:cPrompt  = GetMenuString( hMenu, n - 1, MF_BYPOSITION )
         oMenuItem:cMsg     = ""
         oMenuItem:lChecked = lAnd( GetMenuState( hMenu, n - 1, MF_BYPOSITION ), MF_CHECKED )
         oMenuItem:lActive  = ! lAnd( GetMenuState( hMenu, n - 1,;
                              MF_BYPOSITION ), nOr( MF_DISABLED, MF_GRAYED ) )
         oMenuItem:oMenu    = oMenu
         oMenuItem:hBitmap  = 0
         oMenuItem:lHelp    = .f.
         oMenuItem:lBreak   = lAnd( GetMenuState( hMenu, n - 1, MF_BYPOSITION ), MF_BREAK )
         AAdd( oMenu:aMenuItems, oMenuItem )
         if ( hSubMenu := GetSubMenu( hMenu, n - 1 ) ) != 0
            #ifndef __XPP__
               oSubMenu          = TMenu()
            #else
               oSubMenu          = TMenu():New()
            #endif
            oSubMenu:hMenu    = hSubMenu
            oSubMenu:lSysMenu = .f.
            oSubMenu:aMenuItems   = {}
            oMenuItem:bAction = oSubMenu
            ResBuild( oSubMenu )
         endif
   next

return nil

//----------------------------------------------------------------------------//

static function MenuClone( hTarget, hSource )

   local n
   local hSubTarget, hSubSource

   for n = 1 to GetMItemCount( hSource )
      hSubSource = GetSubMenu( hSource, n - 1 )
      if hSubSource != 0
         hSubTarget = CreatePopupMenu()
         MenuClone( hSubTarget, hSubSource )
      endif
      if lAnd( GetMenuState( hSource, n - 1, MF_BYPOSITION ), MF_SEPARATOR )
         AppendMenu( hTarget, MF_SEPARATOR, GetMItemId( hSource, n - 1 ), "" )
      else
         AppendMenu( hTarget,;
                     nLoByte( GetMenuState( hSource, n - 1, MF_BYPOSITION ) ),;
                     If( hSubSource != 0, hSubTarget,;
                         GetMItemId( hSource, n - 1 ) ),;
                     GetMenuString( hSource, n - 1, MF_BYPOSITION ) )
      endif
   next

return nil

//----------------------------------------------------------------------------//

METHOD AddMdi() CLASS TMenu

   #ifdef __XPP__
      #translate oWnd:ArrangeIcons => oWnd:TMdiFrame:ArrangeIcons
      #translate oWnd:Cascade      => oWnd:TMdiFrame:Cascade
      #translate oWnd:CloseAll     => oWnd:TMdiFrame:CloseAll
      #translate oWnd:IconizeAll   => oWnd:TMdiFrame:IconizeAll
      #translate oWnd:NextWindow   => oWnd:TMdiFrame:NextWindow
      #translate oWnd:Tile         => oWnd:TMdiFrame:Tile
      #translate oWnd:oWndClient   => oWnd:TMdiFrame:oWndClient
   #endif

   MENUITEM "&Window"
   MENU
      MENUITEM "&Tile Vertical"   ACTION ::oWnd:Tile() ;
         MESSAGE "Vertical arranges the windows as nonoverlapping tiles" ;
         WHEN Len( ::oWnd:oWndClient:aWnd ) > 0

      MENUITEM "&Tile Horizontal" ACTION ::oWnd:Tile( .t. ) ;
         MESSAGE "Horizontal arranges the windows as nonoverlapping tiles" ;
         WHEN Len( ::oWnd:oWndClient:aWnd ) > 0

      MENUITEM "&Cascade"         ACTION ::oWnd:Cascade() ;
         MESSAGE "Arranges the windows so they overlap" ;
         WHEN Len( ::oWnd:oWndClient:aWnd ) > 0

      MENUITEM "&Next Window" + Chr( 9 ) + "Ctrl+F6" ;
         ACTION ::oWnd:NextWindow() MESSAGE "Selects the next window" ;
         WHEN Len( ::oWnd:oWndClient:aWnd ) > 1

      SEPARATOR

      MENUITEM "&Arrange Icons"   ACTION ::oWnd:ArrangeIcons() ;
         MESSAGE "Arrange icons at the bottom of the window" ;
         WHEN Len( ::oWnd:oWndClient:aWnd ) > 0

      MENUITEM "&Iconize All"     ACTION ::oWnd:IconizeAll() ;
         MESSAGE "Iconize all open windows" ;
         WHEN Len( ::oWnd:oWndClient:aWnd ) > 0

      MENUITEM "C&lose All"       ACTION ::oWnd:CloseAll() ;
         MESSAGE "Close all open windows" ;
         WHEN Len( ::oWnd:oWndClient:aWnd ) > 0
   ENDMENU

return nil

//----------------------------------------------------------------------------//

METHOD AddHelp( cAbout, cCopyRight ) CLASS TMenu

   MENUITEM "&Help"
   MENU
      if FindResource( GetResources(), "Contents", 2 ) != 0
         MENUITEM "&Contents"    ACTION HelpIndex() RESOURCE "Contents" ;
            MESSAGE "Show the help contents"
      else
         MENUITEM "&Contents"    ACTION HelpIndex() ;
            MESSAGE "Show the help contents"
      endif

      if FindResource( GetResources(), "SearchHelp", 2 ) != 0
         MENUITEM "&Search for Help on..."  + Chr( 9 ) + "F1" RESOURCE "SearchHelp" ;
            ACTION HelpSearch() MESSAGE "Search the help for a specific item"
      else
         MENUITEM "&Search for Help on..."  + Chr( 9 ) + "F1" ;
            ACTION HelpSearch() MESSAGE "Search the help for a specific item"
      endif

      MENUITEM "Using &help"  ACTION HelpIndex() ;
         MESSAGE "Show the help index"

      SEPARATOR

      if FindResource( GetResources(), "about", 2 ) != 0
         if ValType( cAbout ) == "B"
            MENUITEM "&About..."    ACTION Eval( cAbout ) RESOURCE "About" ;
               MESSAGE "Displays program information and copyright"
         else
            MENUITEM "&About..."    ACTION MsgAbout( cAbout, cCopyRight ) RESOURCE "About" ;
               MESSAGE "Displays program information and copyright"
         endif
      else
         if ValType( cAbout ) == "B"
            MENUITEM "&About..."    ACTION Eval( cAbout ) ;
               MESSAGE "Displays program information and copyright"
         else
            MENUITEM "&About..."    ACTION MsgAbout( cAbout, cCopyRight ) ;
               MESSAGE "Displays program information and copyright"
         endif
      endif
   ENDMENU

return nil

//----------------------------------------------------------------------------//

METHOD AddEdit() CLASS TMenu

   local oClp

   MENUITEM "&Edit"
   MENU
      if FindResource( GetResources(), "UnDo", 2 ) != 0
         MENUITEM "&Undo" + Chr( 9 ) + "Ctrl+Z" ;
            MESSAGE "Undoes the last action" ;
            ACTION  ::oWnd:UnDo() RESOURCE "UnDo"
      else
         MENUITEM "&Undo" + Chr( 9 ) + "Ctrl+Z" ;
            MESSAGE "Undoes the last action" ;
            ACTION  ::oWnd:UnDo()
      endif

      if FindResource( GetResources(), "ReDo", 2 ) != 0
         MENUITEM "&Redo" + Chr( 9 ) + "Ctrl+A" ;
            MESSAGE "Redoes the previously undone action" ;
            ACTION  ::oWnd:ReDo() RESOURCE "ReDo"
      else
         MENUITEM "&Redo" + Chr( 9 ) + "Ctrl+A" ;
            MESSAGE "Redoes the previously undone action" ;
            ACTION  ::oWnd:ReDo()
      endif

      SEPARATOR

      if FindResource( GetResources(), "Cut", 2 ) != 0
         MENUITEM "Cu&t" + Chr( 9 ) + "Ctrl+X" ;
            MESSAGE "Removes the selection and puts it on the Clipboard" ;
            ACTION ::oWnd:Cut() RESOURCE "Cut"
      else
         MENUITEM "Cu&t" + Chr( 9 ) + "Ctrl+X" ;
            MESSAGE "Removes the selection and puts it on the Clipboard" ;
            ACTION ::oWnd:Cut()
      endif

      if FindResource( GetResources(), "Copy", 2 ) != 0
         MENUITEM "&Copy" + Chr( 9 ) + "Ctrl+C" ;
            MESSAGE "Copies the selection and puts it on the Clipboard" ;
            ACTION ::oWnd:Copy() RESOURCE "Copy"
      else
         MENUITEM "&Copy" + Chr( 9 ) + "Ctrl+C" ;
            MESSAGE "Copies the selection and puts it on the Clipboard" ;
            ACTION ::oWnd:Copy()
      endif

      if FindResource( GetResources(), "Paste", 2 ) != 0
         MENUITEM "&Paste" + Chr( 9 ) + "Ctrl+V" ;
            MESSAGE "Insert Clipboard contents at the insertion point" ;
            ACTION ::oWnd:Paste() ;
            WHEN   ( oClp := TClipboard():New(), ! oClp:IsEmpty() ) RESOURCE "Paste"
      else
         MENUITEM "&Paste" + Chr( 9 ) + "Ctrl+V" ;
            MESSAGE "Insert Clipboard contents at the insertion point" ;
            ACTION ::oWnd:Paste() ;
            WHEN   ( oClp := TClipboard():New(), ! oClp:IsEmpty() )
      endif

      if FindResource( GetResources(), "Delete", 2 ) != 0
         MENUITEM "&Delete" + Chr( 9 ) + "Del" RESOURCE "Delete" ;
            MESSAGE "Erases the selection" ;
            ACTION  ::oWnd:Delete() // ;
            // ACCELERATOR 0, VK_DELETE
      else
         MENUITEM "&Delete" + Chr( 9 ) + "Del" ;
            MESSAGE "Erases the selection" ;
            ACTION  ::oWnd:Delete() // ;
            // ACCELERATOR 0, VK_DELETE
      endif

      MENUITEM "&Select All" ;
         MESSAGE "Selects the entire document" ;
         ACTION  ::oWnd:SelectAll()

      SEPARATOR

      if FindResource( GetResources(), "Find", 2 ) != 0
         MENUITEM "&Find..." + Chr( 9 ) + "Ctrl+F" RESOURCE "Find" ;
            MESSAGE "Finds the specified text" ;
            ACTION ::oWnd:Find() ;
            ACCELERATOR ACC_CONTROL, Asc( "F" )
      else
         MENUITEM "&Find..." + Chr( 9 ) + "Ctrl+F" ;
            MESSAGE "Finds the specified text" ;
            ACTION ::oWnd:Find() ;
            ACCELERATOR ACC_CONTROL, Asc( "F" )
      endif

      MENUITEM "Find &Next" + Chr( 9 ) + "F3" ;
         MESSAGE "Repeats the last find" ;
         ACTION  ::oWnd:FindNext()

      MENUITEM "R&eplace..." + Chr( 9 ) + "Ctrl+H" ;
         MESSAGE "Replace specific text with different text" ;
         ACTION  ::oWnd:Replace()

      SEPARATOR

      if FindResource( GetResources(), "Properties", 2 ) != 0
         MENUITEM "Pr&operties" + Chr( 9 ) + "Alt+Enter" RESOURCE "Properties" ;
            MESSAGE "Edits properties of the current selection" ;
            ACTION ::oWnd:Properties()
      else
         MENUITEM "Pr&operties" + Chr( 9 ) + "Alt+Enter" ;
            MESSAGE "Edits properties of the current selection" ;
            ACTION ::oWnd:Properties()
      endif

   ENDMENU

return nil

//----------------------------------------------------------------------------//

METHOD AddFile() CLASS TMenu

   MENUITEM "&File"
   MENU
      MENUITEM "&New..." + Chr( 9 ) + "Ctrl+N" ;
         MESSAGE "Creates a new file" ;
         ACCELERATOR ACC_CONTROL, Asc( "N" )

      MENUITEM "&Open..." + Chr( 9 ) + "Ctrl+O" ;
         MESSAGE "Open an existing file" ;
         ACCELERATOR ACC_CONTROL, Asc( "O" ) ;
         ACTION ::oWnd:Open()

      MENUITEM "&Save" + Chr( 9 ) + "Ctrl+S" ;
         MESSAGE "Saves the active file" ;
         ACCELERATOR ACC_CONTROL, Asc( "S" )

      MENUITEM "Save &as..." + Chr( 9 ) + "Alt+A" ;
         MESSAGE "Saves the active file under a new name" ;
         ACCELERATOR ACC_ALT, Asc( "A" )

      MENUITEM "Save al&l" ;
         MESSAGE "Saves all open files"

      SEPARATOR

      MENUITEM "&Print..." + Chr( 9 ) + "Ctrl+P" ;
         MESSAGE "Prints the active file" ;
         ACCELERATOR ACC_CONTROL, Asc( "P" ) ;
         ACTION ::oWnd:Print()

      MENUITEM "P&rinter Setup..." + Chr( 9 ) + "Alt+P" ;
         MESSAGE "Select and setup the printer" ;
         ACCELERATOR ACC_ALT, Asc( "P" ) ;
         ACTION PrinterSetup()

      SEPARATOR

      MENUITEM "&Exit..." + Chr( 9 ) + "Alt+F4" ;
         MESSAGE "Quits this application" ;
         ACTION ::oWnd:End()

   ENDMENU

return nil

//----------------------------------------------------------------------------//

METHOD HelpTopic() CLASS TMenu

   if Empty( ::nHelpId )
      if ::oWnd != nil
         ::oWnd:HelpTopic()
      else
         HelpIndex()
      endif
   else
      HelpTopic( ::nHelpId )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD Save() CLASS TMenu

   local n
   local cType, cInfo := ""
   local oWnd  := &( ::ClassName() + "()" )
   local uData, nProps := 0

   oWnd:New()

   for n = 1 to Len( ::aProperties )
       if ! ( uData := OSend( Self, ::aProperties[ n ] ) ) == ;
          OSend( oWnd, ::aProperties[ n ] )
          cInfo += ( I2Bin( Len( ::aProperties[ n ] ) ) + ;
                     ::aProperties[ n ] )
          nProps++
          cType = ValType( uData )
          do case
             case cType == "A"
                  cInfo += ASave( uData )

             case cType == "O"
                  cInfo += uData:Save()

             otherwise
                  cInfo += ( cType + I2Bin( Len( uData := cValToChar( uData ) ) ) + ;
                             uData )
          endcase
       endif
   next

   oWnd:End()

return "O" + I2Bin( 2 + Len( ::ClassName() ) + 2 + Len( cInfo ) ) + ;
       I2Bin( Len( ::ClassName() ) ) + ;
       ::ClassName() + I2Bin( nProps ) + cInfo

//----------------------------------------------------------------------------//

METHOD SaveToText( nIndent ) CLASS TMenu

   local n, m, cType, cInfo
   local cMethod, uData, nProps := 0
   local oMenu := &( ::ClassName() + "()" )
   local cParams1, cParams2

   DEFAULT nIndent := 0

   DEFAULT ::cVarName := "oMenu"

   cInfo := Space( nIndent ) + "OBJECT " + If( nIndent > 0, "::", "" ) + ;
            ::cVarName + " AS " + ;
            If( nIndent > 0, Upper( Left( ::ClassName(), 2 ) ) + ;
            Lower( SubStr( ::ClassName(), 3 ) ), ::cClassName ) + ;
            CRLF + CRLF

   oMenu = oMenu:New()

   for n = 1 to Len( ::aProperties )
       // if ::aProperties[ n ] == "cVarName"

       // else
          if ! ( uData := OSend( Self, ::aProperties[ n ] ) ) == ;
             OSend( oMenu, ::aProperties[ n ] )
             nProps++
             cType = ValType( uData )
             do case
                case cType == "C"
                     cInfo += Space( nIndent ) + "   ::" + ::aProperties[ n ] + " = "
                     cInfo += '"' + uData + '"' + CRLF

                case cType == "A"
                     cInfo += Space( nIndent + 3 ) + "::" + ::aProperties[ n ] + ;
                              " = Array( " + AllTrim( Str( Len( uData ) ) ) + " )" + CRLF + CRLF
                     cInfo += AToText( uData, ::aProperties[ n ], nIndent + 3 )

                case cType == "O"
                     cInfo += CRLF + uData:SaveToText( nIndent + 3 )

                otherwise
                     cInfo += Space( nIndent ) + "   ::" + ::aProperties[ n ] + " = "
                     cInfo += cValToChar( uData ) + CRLF
             endcase
          endif
       // endif
   next

   if ::aEvents != nil
      for n = 1 to Len( ::aEvents )
         if ( cMethod := OSend( Self, ::aEvents[ n ][ 1 ] ) ) != nil
            cInfo += Space( nIndent ) + "   ::" + ::aEvents[ n ][ 1 ] + " = "
            nProps++
            cParams1 = "{ | Self"
            cParams2 = "( Self"
            for m = 2 to Len( ::aEvents[ n ] )
               cParams1 += ", " + ::aEvents[ n ][ m ]
               cParams2 += ", " + ::aEvents[ n ][ m ]
            next
            cParams1 += " | "
            cParams2 += " )"
            if ::oWnd != nil
               cInfo += cParams1 + "::oWnd:" + cMethod + cParams2 + " }" + CRLF
            else
               cInfo += cParams1 + " ::" + cMethod + cParams2 + " }" + CRLF
            endif
         endif
      next
   endif

   cInfo += CRLF + Space( nIndent ) + "ENDOBJECT" + If( nIndent != 0, CRLF, "" )

   oMenu:End()

return cInfo

//----------------------------------------------------------------------------//

static function ASave( aArray )

   local n, cType, uData
   local cInfo := ""

   for n = 1 to Len( aArray )
      cType = ValType( aArray[ n ] )
      do case
         case cType == "A"
              cInfo += ASave( aArray[ n ] )

         case cType == "O"
              cInfo += aArray[ n ]:Save()

         otherwise
              cInfo += ( cType + I2Bin( Len( uData := cValToChar( uData ) ) ) + ;
                         uData )
      endcase
   next

return "A" + I2Bin( 2 + Len( cInfo ) ) + I2Bin( Len( aArray ) ) + cInfo

//----------------------------------------------------------------------------//

static function ARead( cInfo )

   local nPos := 1, nLen, n
   local aArray, cType, cBuffer

   nLen   = Bin2I( SubStr( cInfo, nPos, 2 ) )
   nPos  += 2
   aArray = Array( nLen )

   for n = 1 to Len( aArray )
      cType = SubStr( cInfo, nPos++, 1 )
      nLen  = Bin2I( SubStr( cInfo, nPos, 2 ) )
      nPos += 2
      cBuffer = SubStr( cInfo, nPos, nLen )
      nPos += nLen
      do case
         case cType == "A"
              aArray[ n ] = ARead( cBuffer )

         case cType == "O"
              aArray[ n ] = ORead( cBuffer )

         case cType == "C"
              aArray[ n ] = cBuffer

         case cType == "D"
              aArray[ n ] = CToD( cBuffer )

         case cType == "L"
              aArray[ n ] = ( cBuffer == "T" )

         case cType == "N"
              aArray[ n ] = Val( cBuffer )
      endcase
   next

return aArray

//----------------------------------------------------------------------------//

METHOD Load( cInfo ) CLASS TMenu

   local nPos := 1, nProps, n, nLen
   local cData, cType, cBuffer

   nProps = Bin2I( SubStr( cInfo, nPos, 2 ) )
   nPos += 2

   for n = 1 to nProps
      nLen  = Bin2I( SubStr( cInfo, nPos, 2 ) )
      nPos += 2
      cData = SubStr( cInfo, nPos, nLen )
      nPos += nLen
      cType = SubStr( cInfo, nPos++, 1 )
      nLen  = Bin2I( SubStr( cInfo, nPos, 2 ) )
      nPos += 2
      cBuffer = SubStr( cInfo, nPos, nLen )
      nPos += nLen
      do case
         case cType == "A"
              OSend( Self, "_" + cData, ARead( cBuffer ) )

         case cType == "O"
              OSend( Self, "_" + cData, ORead( cBuffer ) )

         case cType == "C"
              OSend( Self, "_" + cData, cBuffer )

         case cType == "L"
              OSend( Self, "_" + cData, cBuffer == "T" )

         case cType == "N"
              OSend( Self, "_" + cData, Val( cBuffer ) )
      endcase
   next

return nil

//----------------------------------------------------------------------------//

EXIT PROCEDURE FW_MenuExit

return

//----------------------------------------------------------------------------//

