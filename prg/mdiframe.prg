#include "FiveWin.ch"
#include "Constant.ch"

#define SC_RESTORE     61728
#define SC_MINIMIZE    61472
#define SC_CLOSE       61536
#define SC_NEXT        61504

#define SIZE_MAXIMIZED     2
#define CW_USEDEFAULT  32768

#define WM_GETFONT        49  // 0x0031

#define BAR_TOP            1
#define BAR_LEFT           2
#define BAR_RIGHT          3
#define BAR_DOWN           4
#define BAR_FLOAT          5

#define COLOR_WINDOW       5
#define WM_SETICON       128  // 0x80

#define COLOR_WINDOWTEXT     8
#define COLOR_APPWORKSPACE  12

#ifdef __XPP__
   #define Super ::TWindow
#endif

static oWndMain

//----------------------------------------------------------------------------//

CLASS TMdiFrame FROM TWindow

   DATA   oWndActive
   DATA   oWndClient
   DATA   oMenuStart
   DATA   nMenuInfo
   DATA   bOnOpen

   CLASSDATA lRegistered AS LOGICAL

   METHOD New( nTop, nLeft, nBottom, nRight, cTitle, nStyle, oMenu,;
               oBrush, oIcon, nClrFore, nClrBack, lVScroll,;
               lHScroll, nMenuInfo, cBorder, oWnd, lPixel ) CONSTRUCTOR

   METHOD ChildNew( nTop, nLeft, nBottom, nRight, cTitle, nStyle ) INLINE ;
          ::oWndClient:ChildNew( nTop, nLeft, nBottom, nRight, cTitle, nStyle )

   METHOD Cascade()      INLINE ::oWndClient:Cascade()
   METHOD CloseAll()     INLINE ::oWndClient:lCloseAll()

   METHOD IconizeAll()   INLINE ::oWndClient:IconizeAll()

   METHOD Tile( lHor )   INLINE ::oWndClient:Tile( lHor )
   METHOD ArrangeIcons() INLINE ::oWndClient:ArrangeIcons()
   
   METHOD Zoom()         INLINE ::oWndClient:Zoom()
   
   METHOD CloseActive()  INLINE ::oWndClient:CloseActive()

   METHOD NextWindow() INLINE ::oWndClient:NextWindow()
   METHOD PrevWindow() INLINE ::oWndClient:PrevWindow()

   METHOD ReSize( nSizeType, nWidth, nHeight )

   METHOD Command( nWParam, nLParam )

   METHOD Copy() INLINE If( ::oWndActive != nil, ::oWndActive:Copy(),)
   METHOD Cut()  INLINE If( ::oWndActive != nil, ::oWndActive:Cut(),)

   METHOD Delete()  INLINE If( ::oWndActive != nil, ::oWndActive:Delete(),)
   METHOD FindNext()  INLINE If( ::oWndActive != nil, ::oWndActive:FindNext(),)

   METHOD Open() INLINE If( ::bOnOpen != nil, Eval( ::bOnOpen, Self ),)

   METHOD Paste( cText ) INLINE ;
          If( ::oWndActive != nil, ::oWndActive:Paste( cText ),)

   METHOD Print() INLINE ;
          If( ::oWndActive != nil, ::oWndActive:Print(),)

   METHOD ReDo()  INLINE If( ::oWndActive != nil, ::oWndActive:ReDo(),)
   METHOD UnDo()  INLINE If( ::oWndActive != nil, ::oWndActive:UnDo(),)

   METHOD Find( cText ) INLINE ;
          If( ::oWndActive != nil, ::oWndActive:Find( cText ),)

   METHOD End()

   METHOD Properties()  INLINE If( ::oWndActive != nil, ::oWndActive:Properties(),)

   METHOD Replace()  INLINE If( ::oWndActive != nil, ::oWndActive:Replace(),)

   METHOD Select( nWindow ) INLINE ::oWndClient:Select( nWindow )

   METHOD SelectAll()  INLINE If( ::oWndActive != nil, ::oWndActive:SelectAll(),)

   METHOD SetMenu( oMenu, nMenuInfo )

   METHOD GotFocus()
   
   // METHOD SysCommand( nWParam, nLParam )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( nTop, nLeft, nBottom, nRight, cTitle, nStyle, oMenu, oBrush,;
            oIcon, nClrFore, nClrBack, lVScroll, lHScroll, nMenuInfo,;
            cBorder, oWnd, lPixel ) CLASS TMdiFrame

   local n

   DEFAULT nStyle    := nOR( WS_OVERLAPPEDWINDOW, WS_CLIPCHILDREN ),;
           lVScroll  := .f., lHScroll := .f.,;
           nMenuInfo := If( oMenu != nil, ;
                        ( n := AScan( oMenu:aItems, { |o| o:cPrompt == "&Window" } ), ;
                          If( n > 0, n, Max( Len( oMenu:aItems ) - 1, 1 ) ) ), 2 ),;
           nClrFore  := GetSysColor( COLOR_WINDOWTEXT ),;
           nClrBack := GetSysColor( COLOR_APPWORKSPACE ),;
           lPixel    := .f.

   ::nTop        = If( nTop    != nil, nTop    * If( lPixel, 1, MDIF_CHARPIX_H ), CW_USEDEFAULT )      //16
   ::nLeft       = If( nLeft   != nil, nLeft   * If( lPixel, 1, MDIF_CHARPIX_W ), CW_USEDEFAULT )       // 8
   ::nBottom     = If( nBottom != nil, nBottom * If( lPixel, 1, MDIF_CHARPIX_H ), CW_USEDEFAULT )    //16
   ::nRight      = If( nRight  != nil, nRight  * If( lPixel, 1, MDIF_CHARPIX_W ), CW_USEDEFAULT )    //  8
   ::nStyle      = nStyle
   ::cCaption    = cTitle
   ::nId         = 0
   ::oIcon       = oIcon
   ::lValidating = .f.
   ::lVisible    = .t.
   ::oWnd        = oWnd
   ::oMenu       = oMenu
   ::nMenuInfo   = nMenuInfo

   #ifdef __XPP__
      DEFAULT ::lRegistered := .f.
   #endif

   if ValType( oIcon ) == "C"
      if File( oIcon )
         DEFINE ICON oIcon FILENAME oIcon
      else
         DEFINE ICON oIcon RESOURCE oIcon
      endif
      ::oIcon = oIcon
   endif

   if oMenu == nil
      MENU oMenu
         MENUITEM "&Childs"
         MENU
            MENUITEM "New..." ACTION ::ChildNew()
            SEPARATOR
            MENUITEM "E&xit"  ACTION ::End()
         ENDMENU
         oMenu:AddMdi()
         oMenu:AddHelp( "FiveWin", "(c) FiveTech" )

      ENDMENU
      ::oMenu = oMenu
   endif

   ::Register()
   ::Create()                   // After this the window is subclassed and
   ::nOldProc = GetFrameProc()  // we install the MdiFrame procedure now !!!

   ::SetColor( nClrFore, nClrBack, oBrush )
                                        // SubMenu, nChild
   ::oWndClient = TMdiClient():New( Self, nMenuInfo, 1,, lVScroll,;
                                    lHScroll )
   ::oWndClient:SetColor( nClrFore, nClrBack, oBrush )

   ::SetMenu( oMenu, ::nMenuInfo )

   if ::oFont == nil
      ::oFont = ::GetFont()
   endif

   /*
   if oIcon != nil
      SendMessage( ::hWnd, WM_SETICON, 0, oIcon:hIcon )
   endif
   */

   oWndMain = Self
   SetWndDefault( Self )

return Self

//----------------------------------------------------------------------------//

METHOD ReSize( nSizeType, nWidth, nHeight ) CLASS TMdiFrame

   local hTop, hBottom, hLeft, hRight

   // Super:ReSize( nSizeType, nWidth, nHeight )

   if ::oTop != nil
      hTop = ::oTop:hWnd
   endif

   if ::oBar != nil
      hTop = ::oBar:hWnd
   endif

   if ::oBottom != nil
      hBottom = ::oBottom:hWnd
   endif

   if ::oMsgBar != nil
      hBottom = ::oMsgBar:hWnd
   endif

   if ::oLeft != nil
      hLeft = ::oLeft:hWnd
   endif

   if ::oRight != nil
      hRight = ::oRight:hWnd
   endif

   WndAdjClient( ::oWndClient:hWnd, hTop, hBottom, hLeft, hRight, .t. )

   Super:ReSize( nSizeType, nWidth, nHeight )

return 0

//----------------------------------------------------------------------------//

METHOD Command( nWParam, nLParam ) CLASS TMdiFrame

   local lToolBar := .f.

   #ifndef __CLIPPER__
      lToolBar = ( GetClassName( nLParam ) == "ToolbarWindow32" )
   #endif

   do case
      case ! lToolBar .and. nWParam < 100   // MdiChild Menu Selection
           return nil

      otherwise
         Super:Command( nWParam, nLParam )
         #ifndef __CLIPPER__
            if lToolBar
               return 0  // Important: No further processing
            endif
         #endif
   endcase

return nil

//----------------------------------------------------------------------------//

METHOD End() CLASS TMdiFrame

   if ::bValid != nil
      if ! Eval( ::bValid )
         return .f.
      endif
   endif

   if ::oWndClient:lCloseAll()
      ::PostMsg( WM_CLOSE )
   else
      return .f.
   endif

return .t.

//----------------------------------------------------------------------------//

METHOD SetMenu( oMenu, nMenuInfo ) CLASS TMdiFrame 

  DEFAULT nMenuInfo := ::nMenuInfo

  ::nMenuInfo = nMenuInfo

  if ::oMenuStart == nil
     ::oMenuStart = oMenu
     Super:SetMenu( oMenu )
  else
     ::oMenu = oMenu
     oMenu:oWnd = Self
     nMenuInfo := If( nMenuInfo > 0, nMenuInfo, Len( oMenu:aItems ) + 1 + ;
                      nMenuInfo )
     ::oWndClient:SetMenu( oMenu, nMenuInfo )
  endif

return nil

//----------------------------------------------------------------------------//
 
function GetWndFrame() ; return oWndMain      // Default Frame Window

//----------------------------------------------------------------------------//

METHOD GotFocus() CLASS TMdiFrame

   ::lFocused = .t.

   if ::bGotFocus != nil
      Eval( ::bGotFocus )
   endif

return nil

//----------------------------------------------------------------------------//

/*

METHOD SysCommand( nWParam, nLParam ) CLASS TMdiFrame

   local nLoWord

   if nWParam == 61589 .and. ::oWndActive != nil
      MsgInfo( nLoWord( nLParam ), nHiWord( nLParam ) )
      nLoWord = nLoWord( nLParam )
      
      do case
         case nLoWord == 994
              ::oWndActive:Restore()
              return 0
              
         case nLoWord == 1014
              ::oWndActive:End()
              return 0
              
         case nLoWord >= 968 nLoWord == 975
              ::oWndActive:Iconize()
              return 0
      endcase                 
   endif
   
return Super:SysCommand( nWParam, nLParam )

*/

//----------------------------------------------------------------------------//