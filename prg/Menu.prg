#include "FiveWin.Ch"
#include "Menu.ch"

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
   DATA   aItems
   DATA   oWnd
   DATA   lSysMenu, lPopup
   DATA   nHelpId
   DATA   cVarName

   CLASSDATA aProperties INIT { "aItems", "cVarName" }
   CLASSDATA oLastItem

   METHOD New( lPopup, oWnd )  CONSTRUCTOR
   METHOD ReDefine( cResName, lPopup ) CONSTRUCTOR
   METHOD NewSys( oWnd )       CONSTRUCTOR

   METHOD Add( oMenuItem )

   METHOD AddEdit()

   METHOD AddFile()

   METHOD AddHelp( cAbout, cCopyRight )

   METHOD AddMdi()

   METHOD Insert( oMenuItem, nAt )

   METHOD Initiate()

   METHOD Command( nCommand )

   METHOD LastItem() INLINE ::oLastItem

   METHOD Load( cInfo )

   METHOD GetMenuItem( nItemId ) INLINE  SearchItem( ::aItems, nItemId )

   METHOD GetPopup( hPopup )

   METHOD GetSubMenu( hPopup ) INLINE SearchSubMenu( Self, hPopup )

   METHOD HelpTopic()

   METHOD Activate( nRow, nCol, oWnd )

   METHOD DelItems()

   METHOD Refresh() INLINE ::oWnd:SetMenu( Self )

   METHOD Reset() INLINE If( ::lSysMenu, GetSystemMenu( ::oWnd:hWnd, .t. ),;
                         DestroyMenu( ::hMenu ) ), ::hMenu := CreateMenu(),;
                         ::aItems := {}

   METHOD Destroy() INLINE DestroyItems( ::aItems )

   METHOD End()

   METHOD Hilite( nPopUp ) INLINE ;
                           HiliteMenuItem( ::oWnd:hWnd, ::hMenu, nPopUp - 1,;
                                           nOr( MF_HILITE, MF_BYPOSITION ) )

   METHOD UnHilite( nPopUp ) INLINE ;
                           HiliteMenuItem( ::oWnd:hWnd, ::hMenu, nPopUp - 1,;
                                           nOr( MF_UNHILITE, MF_BYPOSITION ) )

   METHOD Disable() INLINE ASend( ::aItems, "Disable" ),;
                           If( ::oWnd != nil, ::Refresh(),)

   METHOD Enable() INLINE ASend( ::aItems, "Enable" ),;
                          If( ::oWnd != nil, ::Refresh(),)

   METHOD Save()

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( lPopup, oWnd ) CLASS TMenu

   DEFAULT lPopup := .f. // , oWnd := GetWndDefault()

   ::hMenu    = If( lPopup, CreatePopupMenu(), CreateMenu() )
   ::aItems   = {}
   ::lSysMenu = .f.
   ::lPopup   = lPopup

   if lPopup
      AAdd( aPopups, Self )
   endif

   if oWnd != nil
      oWnd:SetMenu( Self )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD End() CLASS TMenu

   local nAt

   if ::oWnd != nil
      SetMenu( ::oWnd:hWnd, 0 )
   endif

   ::DelItems()
   if ::hMenu != 0
      DestroyMenu( ::hMenu )
      ::hMenu = 0
   endif

   ::Destroy()

   if ( nAt := AScan( aPopups, { | o | o == Self } ) ) != 0
      ADel( aPopups, nAt )
      ASize( aPopups, Len( aPopups ) - 1 )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD ReDefine( cResName, lPopup ) CLASS TMenu

   local hMenu := LoadMenu( GetResources(), cResName )
   local n

   ::hMenu    = hMenu
   ::aItems   = {}
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

return nil

//----------------------------------------------------------------------------//

METHOD NewSys( oWnd ) CLASS TMenu

   local n

   if oWnd != nil
      ::oWnd  = oWnd
      ::hMenu = GetSystemMenu( oWnd:hWnd, .f. )
   endif
   ::aItems   = {}
   ::lSysMenu = .t.

return nil

//----------------------------------------------------------------------------//

METHOD Add( oMenuItem ) CLASS TMenu

   AAdd( ::aItems, oMenuItem )

   oMenuItem:oMenu = Self

   if ValType( oMenuItem:bAction ) == "O" .and. ;
      Upper( oMenuItem:bAction:ClassName() ) == "TMENU"
      if oMenuItem:cPrompt != nil
         AppendMenu( ::hMenu, nOr( MF_POPUP, MF_ENABLED,;
                          If( oMenuItem:hBmpPal != 0, MF_OWNERDRAW, 0 ),;
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
                     oMenuItem:bAction:hMenu, oMenuItem:hBmpPal )
      endif
      AAdd( aPopups, oMenuItem:bAction )
   else
      if oMenuItem:cPrompt != nil
         AppendMenu( ::hMenu,;
                     nOR( If( oMenuItem:lActive,;
                          nOr( MF_ENABLED, If( oMenuItem:hBmpPal != 0, MF_OWNERDRAW, 0 ) ),;
                          nOR( MF_DISABLED, MF_GRAYED ) ),;
                          If( oMenuItem:lChecked, MF_CHECKED, 0 ),;
                          If( oMenuItem:lHelp, MF_HELP, 0 ),;
                          If( oMenuItem:lBreak, MF_BREAK, 0 ) ),;
                     oMenuItem:nId, oMenuItem:cPrompt )
      else
         if oMenuItem:hBmpPal != 0
            AppendMenu( ::hMenu, nOr( MF_BITMAP,;
                        If( oMenuItem:lBreak, MF_BREAK, 0 ) ),;
                        oMenuItem:nId, oMenuItem:hBmpPal )
         else
            AppendMenu( ::hMenu, MF_SEPARATOR, oMenuItem:nId, "" )
         endif
      endif
   endif

return nil

//----------------------------------------------------------------------------//

METHOD DelItems() CLASS TMenu

   while Len( ::aItems ) > 0
      ATail( ::aItems ):Destroy()
   end

return nil

//----------------------------------------------------------------------------//

METHOD GetPopup( hPopup ) CLASS TMenu

   local nAt := AScan( aPopups, { | oPopup | oPopup:hMenu == hPopup } )

return If( nAt != 0, aPopups[ nAt ], nil )

//----------------------------------------------------------------------------//

static function SearchSubMenu( oMenu, hMenu )

   local n, oSubMenu

   for n = 1 to Len( oMenu:aItems )
      if ValType( oSubMenu := oMenu:aItems[ n ]:bAction ) == "O"
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

   local oPrevItem := If( nAt <= Len( ::aItems ), ::aItems[ nAt ], nil )

   if oPrevItem == nil
      ::Add( oMenuItem )
      return nil
   endif

   AAdd( ::aItems, nil )
   AIns( ::aItems, nAt )

   ::aItems[ nAt ] = oMenuItem

   oMenuItem:oMenu = Self

   if Upper( oMenuItem:bAction:ClassName() ) == "TMENU"
      if oMenuItem:hBmpPal == 0
         InsertMenu( ::hMenu, oPrevItem:nId, nOr( MF_POPUP,;
                     If( oMenuItem:lHelp, MF_HELP, 0 ),;
                     If( oMenuItem:lBreak, MF_BREAK, 0 ) ),;
                     oMenuItem:bAction:hMenu,;
                     oMenuItem:cPrompt )
      else
         InsertMenu( ::hMenu, oPrevItem:nId, nOR( MF_POPUP, MF_BITMAP,;
                     If( oMenuItem:lHelp, MF_HELP, 0 ),;
                     If( oMenuItem:lBreak, MF_BREAK, 0 ) ),;
                     oMenuItem:bAction:hMenu, oMenuItem:hBmpPal )
      endif
   else
      if oMenuItem:cPrompt != nil
         InsertMenu( ::hMenu, oPrevItem:nId, ;
                     nOR( If( oMenuItem:lActive, MF_ENABLED,;
                     nOR( MF_DISABLED, MF_GRAYED ) ),;
                     If( oMenuItem:lChecked, MF_CHECKED, 0 ),;
                     If( oMenuItem:lHelp, MF_HELP, 0 ),;
                     If( oMenuItem:lBreak, MF_BREAK, 0 ) ),;
                     oMenuItem:nId, oMenuItem:cPrompt )
      else
         if oMenuItem:hBmpPal != 0
            InsertMenu( ::hMenu, oPrevItem:nId, nOr( MF_BITMAP,;
                        If( oMenuItem:lBreak, MF_BREAK, 0 ) ),;
                        oMenuItem:nId, oMenuItem:hBmpPal )
         else
            InsertMenu( ::hMenu, oPrevItem:nId, MF_SEPARATOR,;
                        oMenuItem:nId, "" )
         endif
      endif
   endif

return nil

//----------------------------------------------------------------------------//

METHOD Initiate() CLASS TMenu

   local n, lWhen
   local oItem

   for n = 1 to Len( ::aItems )
      oItem = ::aItems[ n ]
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
      if ValType( oMenuItem:bAction ) == "B"
         ::oLastItem = oMenuItem
         Eval( oMenuItem:bAction, oMenuItem )
      endif
   endif

return nil

//----------------------------------------------------------------------------//

METHOD Activate( nRow, nCol, oWnd ) CLASS TMenu

   local aPoint := { nRow, nCol }

   if oWnd != nil
      aPoint = ClientToScreen( oWnd:hWnd, aPoint )

      if oWnd:oPopup != nil
         oWnd:oPopup:End()
      endif
      oWnd:oPopup = Self
      TrackPopup( ::hMenu, 2, aPoint[ 1 ], aPoint[ 2 ],;
                  0, oWnd:hWnd )
      SysRefresh()
      ::End()
      oWnd:oPopup = nil
   endif

return nil

//----------------------------------------------------------------------------//

static function SearchItem( aItems, nId )

   local n      := 1
   local lFound := .f.
   local oReturn
   local bAction

   // if hClass == nil
   //   hClass = TMenu():ClassH()
   // endif

   while n <= Len( aItems ) .and. ! lFound
      if aItems[ n ]:nId == nId
         return aItems[ n ]
      else
         bAction = aItems[ n ]:bAction
         if ValType( bAction ) == "O" .and. Upper( bAction:ClassName() ) == "TMENU"
            if aItems[ n ]:bAction:hMenu == nId
               return aItems[ n ]
            else
               oReturn = SearchItem( aItems[ n ]:bAction:aItems, nId )
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

static function DestroyItem( aItems )

   local n := 1
   local oItem

   // if hClass == nil
   //   hClass = TMenu():ClassH()
   // endif

   while n <= Len( aItems )
      oItem = aItems[ n ]
      if oItem:bAction != nil
         if ValType( oItem:bAction ) == "O" .and. ;
            Upper( oItem:bAction:ClassName() ) == "TMENU"
            DestroyItem( oItem:bAction:aItems )
         endif
      endif
      oItem:End()
      // oItem:Destroy()   Sid, I think this has been already done
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
         oMenuItem          = TMenuItem()
         oMenuItem:nId      = GetMItemID( hMenu, n - 1 )
         oMenuItem:cPrompt  = GetMenuString( hMenu, n - 1, MF_BYPOSITION )
         oMenuItem:cMsg     = ""
         oMenuItem:lChecked = lAnd( GetMenuState( hMenu, n - 1, MF_BYPOSITION ), MF_CHECKED )
         oMenuItem:lActive  = ! lAnd( GetMenuState( hMenu, n - 1,;
                              MF_BYPOSITION ), nOr( MF_DISABLED, MF_GRAYED ) )
         oMenuItem:oMenu    = oMenu
         oMenuItem:hBmpPal  = 0
         oMenuItem:lHelp    = .f.
         oMenuItem:lBreak   = lAnd( GetMenuState( hMenu, n - 1, MF_BYPOSITION ), MF_BREAK )
         AAdd( oMenu:aItems, oMenuItem )
         if ( hSubMenu := GetSubMenu( hMenu, n - 1 ) ) != 0
            oSubMenu          = TMenu()
            oSubMenu:hMenu    = hSubMenu
            oSubMenu:lSysMenu = .f.
            oSubMenu:aItems   = {}
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

      MENUITEM "C&lose All"       ACTION ::SysRefresh(); oWnd:CloseAll(); SysRefresh() ;
         MESSAGE "Close all open windows" ;
         WHEN Len( ::oWnd:oWndClient:aWnd ) > 0
   ENDMENU

return nil

//----------------------------------------------------------------------------//

METHOD AddHelp( cAbout, cCopyRight ) CLASS TMenu

   MENUITEM "&Help"
   MENU
      MENUITEM "&Contents"    ACTION HelpIndex() ;
         MESSAGE "Show the help contents"

      MENUITEM "&Search for Help on..."  + Chr( 9 ) + "F1" ;
         ACTION HelpSearch() MESSAGE "Search the help for a specific item"

      MENUITEM "Using &help"  ACTION HelpIndex() ;
         MESSAGE "Show the help index"

      SEPARATOR

      MENUITEM "&About..."    ACTION MsgAbout( cAbout, cCopyRight ) ;
         MESSAGE "Displays program information and copyright"
   ENDMENU

return nil

//----------------------------------------------------------------------------//

METHOD AddEdit() CLASS TMenu

   local oClp

   MENUITEM "&Edit"
   MENU
      MENUITEM "&Undo" + Chr( 9 ) + "Ctrl+Z" ;
         MESSAGE "Undoes the last action" ;
         ACTION  ::oWnd:UnDo()

      MENUITEM "&Redo" + Chr( 9 ) + "Ctrl+A" ;
         MESSAGE "Redoes the previously undone action" ;
         ACTION  ::oWnd:ReDo()

      SEPARATOR

      MENUITEM "Cu&t" + Chr( 9 ) + "Ctrl+X" ;
         MESSAGE "Removes the selection and puts it on the Clipboard" ;
         ACTION ::oWnd:Cut()

      MENUITEM "&Copy" + Chr( 9 ) + "Ctrl+C" ;
         MESSAGE "Copies the selection and puts it on the Clipboard" ;
         ACTION ::oWnd:Copy()

      MENUITEM "&Paste" + Chr( 9 ) + "Ctrl+V" ;
         MESSAGE "Insert Clipboard contents at the insertion point" ;
         ACTION ::oWnd:Paste() ;
         WHEN   ( oClp := TClipboard():New(), ! oClp:IsEmpty() )

      MENUITEM "&Delete" + Chr( 9 ) + "Del" ;
         MESSAGE "Erases the selection" ;
         ACTION  ::oWnd:Delete() ;
         ACCELERATOR 0, VK_DELETE

      MENUITEM "&Select All" ;
         MESSAGE "Selects the entire document" ;
         ACTION  ::oWnd:SelectAll()

      SEPARATOR

      MENUITEM "&Find..." + Chr( 9 ) + "Ctrl+F" ;
         MESSAGE "Finds the specified text" ;
         ACTION ::oWnd:Find() ;
         ACCELERATOR ACC_CONTROL, Asc( "F" )

      MENUITEM "Find &Next" + Chr( 9 ) + "F3" ;
         MESSAGE "Repeats the last find" ;
         ACTION  ::oWnd:FindNext()

      MENUITEM "R&eplace..." + Chr( 9 ) + "Ctrl+H" ;
         MESSAGE "Replace specific text with different text" ;
         ACTION  ::oWnd:Replace()

      SEPARATOR

      MENUITEM "Pr&operties" + Chr( 9 ) + "Alt+Enter" ;
         MESSAGE "Edits properties of the current selection" ;
         ACTION ::oWnd:Properties()

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