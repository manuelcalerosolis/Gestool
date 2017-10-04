#include "FiveWin.Ch"
#include "Constant.ch"

#define WM_MDICREATE        544   // 0x0220
#define WM_MDIDESTROY       545   // 0x0221
#define WM_MDIACTIVATE      546   // 0x0222
#define WM_MDIRESTORE       547   // 0x0223
#define WM_MDINEXT          548   // 0x0224
#define WM_MDIMAXIMIZE      549   // 0x0225
#define WM_MDITILE          550   // 0x0226
#define WM_MDICASCADE       551   // 0x0227
#define WM_MDIICONARRANGE   552   // 0x0228
#define WM_MDIGETACTIVE     553   // 0x0229
#define WM_MDISETMENU       560   // 0x0230

#define WM_CHILDACTIVATE     34   // 0x22
#define WM_GETFONT           49   // 0x0031

#define WM_NCACTIVATE       134   // 0x0086

#define SC_RESTORE        61728
#define SC_CLOSE          61536   // 0xF060
#define SC_MINIMIZE       61472
#define SC_NEXT           61504
#define SC_MAXIMIZE       61488   // 0xF030

#define IDC_ARROW         32512
#define WM_SYSCOMMAND       274   // 0x0112

#define CW_USEDEFAULT     32768

#define BAR_TOP         1
#define BAR_LEFT        2
#define BAR_RIGHT       3
#define BAR_DOWN        4
#define BAR_FLOAT       5

#define CS_DBLCLKS      8

#ifdef __XPP__
   #define Super ::TWindow
#endif

//----------------------------------------------------------------------------//

CLASS TMdiChild FROM TWindow

   DATA   oWndClient, oControl
   DATA   lKeepMenu
   DATA   nMenuInfo

   CLASSDATA lRegistered AS LOGICAL

   METHOD New( nTop, nLeft, nBottom, nRight, cTitle, nStyle, oMenu,;
               oWnd, oIcon, lVScroll, nClrText, nClrBack, oCursor,;
               oBrush, lPixel, lHScroll, nHelpId, cBorder, lSysMenu,;
               lCaption, lMin, lMax, nMenuInfo ) CONSTRUCTOR

   METHOD Maximize() INLINE ::oWndClient:ChildMaximize( Self )

   METHOD MdiActivate( lOn, hWndAct, hWndDeAct )

   METHOD Restore()  INLINE ::oWndClient:ChildRestore( Self )

   METHOD Activate( cShow, bLClicked, bRClicked, bMoved, bResized, bPainted,;
                    bKeyDown, bInit, bUp, bDown, bPgUp, bPgDn,;
                    bLeft, bRight, bPgLeft, bPgRight, bValid )

   METHOD End()

   METHOD Center() INLINE WndCenter( ::hWnd, ::oWndClient:hWnd )

   METHOD Copy() INLINE If( ::oControl != nil, ::oControl:Copy(), )
   METHOD Cut()  INLINE If( ::oControl != nil, ::oControl:Cut(), )

   METHOD Delete() INLINE ;
               If( ::oControl != nil, ::oControl:Delete(), )

   METHOD Paste( cText ) INLINE ;
               If( ::oControl != nil, ::oControl:Paste( cText ), )

   METHOD Find( cText ) INLINE ;
               If( ::oControl != nil, ::oControl:Find( cText ), )

   METHOD FindNext() INLINE ;
               If( ::oControl != nil, ::oControl:FindNext(), )

   METHOD Print( oTarget, nRow, nCol, nScale )

   METHOD GotFocus() INLINE Super:GotFocus(),;
                            ::oWnd:oWndActive := Self

   METHOD HandleEvent( nMsg, nWParam, nLParam )

   METHOD Next() INLINE ::oWndClient:ChildNext( Self )
   METHOD Prev() INLINE ::oWndClient:ChildNext( Self, .t. )

   METHOD KeyDown( nKey, nFlags )
   METHOD KeyChar( nKey, nFlags )

   METHOD Properties() INLINE ;
               If( ::oControl != nil, ::oControl:Properties(), )

   METHOD Replace() INLINE ;
               If( ::oControl != nil, ::oControl:Replace(), )

   METHOD SelectAll() INLINE ;
               If( ::oControl != nil, ::oControl:SelectAll(), )

   METHOD SetControl( oCtrl ) INLINE ;
          ::oClient := ::oControl := oCtrl, ::ReSize()

   METHOD SetMenu( oMenu, nMenuInfo ) INLINE ::oMenu := oMenu,;
             ::oWnd:SetMenu( oMenu, ::nMenuInfo := nMenuInfo )

   METHOD SetFocus() INLINE ::oWnd:oWndClient:ChildActivate( Self )

   METHOD ReDo() INLINE ;
               If( ::oControl != nil, ::oControl:ReDo(), )

   METHOD UnDo() INLINE ;
               If( ::oControl != nil, ::oControl:UnDo(), )

   METHOD IsZoomed() INLINE IsZoomed( ::hWnd )
   METHOD IsIconic() INLINE IsIconic( ::hWnd )


ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( nTop, nLeft, nBottom, nRight, cTitle, nStyle, oMenu, oWnd,;
            oIcon, lVScroll, nClrFore, nClrBack, oCursor, oBrush,;
            lPixel, lHScroll, nHelpId, cBorder, lSysMenu, lCaption,;
            lMin, lMax, nMenuInfo ) CLASS TMdiChild

   DEFAULT cTitle   := "MDI Child " + AllTrim( Str( Len( oWnd:oWndClient:aWnd ) + 1 ) ),;
           lVScroll := .f., lHScroll := .f.,;
           oWnd     := GetWndFrame(),;
           nClrFore := oWnd:oWndClient:nClrText,;
           nClrBack := oWnd:oWndClient:nClrPane,;
           nStyle   := 0,;
           cBorder  := "SINGLE", lSysMenu := .t., lCaption := .t.,;
           lMin     := .t., lMax := .t., lPixel := .f.

   if nStyle == 0
      nStyle = nOr( WS_CLIPCHILDREN, WS_VISIBLE, ;
                    If( cBorder == "NONE",   0, 0 ),;
                    If( cBorder == "SINGLE", WS_THICKFRAME, 0 ),;
                    If( lCaption, WS_CAPTION, 0 ),;
                    If( lSysMenu .and. lCaption, WS_SYSMENU, 0 ),;
                    If( lMin .and. lCaption, WS_MINIMIZEBOX, 0 ),;
                    If( lMax .and. lCaption, WS_MAXIMIZEBOX, 0 ),;
                    If( lVScroll, WS_VSCROLL, 0 ),;
                    If( lHScroll, WS_HSCROLL, 0 ) )
   endif

   ::nTop       = If( nTop    != nil, nTop * If( ! lPixel, MDIC_CHARPIX_H, 1 ), CW_USEDEFAULT )         // 16
   ::nLeft      = If( nLeft   != nil, nLeft * If( ! lPixel,  MDIC_CHARPIX_W, 1 ), CW_USEDEFAULT )       // 8
   ::nBottom    = If( nBottom != nil, nBottom * If( ! lPixel, MDIC_CHARPIX_H, 1 ), CW_USEDEFAULT )		  // 16
   ::nRight     = If( nRight  != nil, nRight  * If( ! lPixel,  MDIC_CHARPIX_W, 1 ), CW_USEDEFAULT )		// 8
   ::oWndClient = oWnd:oWndClient
   ::oWnd       = oWnd
   ::nStyle     = nStyle
   ::oIcon      = oIcon
   ::lVisible   = .t.
   ::aControls  = {}
   ::nHelpId    = nHelpId
   ::cCaption   = cTitle
   ::lKeepMenu  = .f.
   ::nMenuInfo  = nMenuInfo

   if ValType( oIcon ) == "C"
      if File( oIcon )
         DEFINE ICON oIcon FILENAME oIcon
      else
         DEFINE ICON oIcon RESOURCE oIcon
      endif
      ::oIcon = oIcon
   endif

   ::oCursor    = oCursor

   ::SetColor( nClrFore, nClrBack, oBrush )

   #ifndef __CLIPPER__
      DEFAULT ::lRegistered := .f.  // Harbour and XPP keeps failing here
   #endif

   if ! ::lRegistered
      ::lRegistered = RegisterClass( "TMDICHILD",;
                                     nOR( CS_VREDRAW, CS_HREDRAW, CS_DBLCLKS ),;
                                     0, 0, 0, 0, 0, "", GetMDIChlProc() )
   endif

   ::hWnd = ::oWndClient:SendMsg( WM_MDICREATE, 0,;
        cMdiStruct( "TMDICHILD", cTitle,;
                    ::nTop, ::nLeft, ::nBottom, ::nRight,;
                    ::nStyle ) )
   ::Link()

   if oMenu != nil
      ::SetMenu( oMenu, nMenuInfo )
   endif

   if lVScroll
      DEFINE SCROLLBAR ::oVScroll VERTICAL OF Self
   endif
   if lHScroll
      DEFINE SCROLLBAR ::oHScroll HORIZONTAL OF Self
   endif

   ::GetFont()

   ::oWndClient:Add( Self )

   SetWndDefault( Self )              // Set Default DEFINEd Window
   ::oWnd:oWndActive = Self

   ::SendMsg( WM_NCACTIVATE, 1 ) // Thanks to EMG

return Self

//----------------------------------------------------------------------------//

METHOD Activate( cShow, bLClicked, bRClicked, bMoved, bResized, bPainted,;
                 bKeyDown, bInit, bUp, bDown, bPgUp, bPgDn, bLeft, bRight,;
                 bPgLeft, bPgRight, bValid ) CLASS TMdiChild

   ::oWndClient:ChildActivate( Self )

   Super:Activate( cShow, bLClicked, bRClicked, bMoved, bResized, bPainted,;
                   bKeyDown, bInit, bUp, bDown, bPgUp, bPgDn, bLeft, bRight,;
                   bPgLeft, bPgRight, bValid )

   ::lVisible := .t.

   If ::oControl != nil
      ::oControl:SetFocus()
   Endif

return nil

//----------------------------------------------------------------------------//

METHOD End() CLASS TMdiChild

   local lEnd := .t.

   if ::bValid != nil
      if Eval( ::bValid )
         if ::oMenu != nil .and. ! ::lKeepMenu
            ::oMenu:End()
         endif
         ::oWndClient:ChildClose( Self )
      else
         lEnd = .f.
      endif
   else
      if ::oMenu != nil .and. ! ::lKeepMenu
         ::oMenu:End()
      endif
      ::oWndClient:ChildClose( Self )
   endif

return lEnd

//----------------------------------------------------------------------------//

METHOD KeyDown( nKey, nFlags ) CLASS TMdiChild

   // There is no a standard behavior for WM_KEYDOWN messages so we have
   // to process them !

   if nKey == VK_F4 .and. GetKeyState( VK_CONTROL )
      ::SendMsg( WM_SYSCOMMAND, SC_CLOSE )
      return 0
   endif

   if nKey == VK_F6 .and. GetKeyState( VK_CONTROL )
      ::SendMsg( WM_SYSCOMMAND, SC_NEXT )
      return 0
   endif

return Super:KeyDown( nKey, nFlags )

//----------------------------------------------------------------------------//

METHOD KeyChar( nKey, nFlags ) CLASS TMdiChild

   if nKey == VK_ESCAPE
      ::End()
      return 0
   endif

return Super:KeyChar( nKey, nFlags )

//----------------------------------------------------------------------------//

METHOD HandleEvent( nMsg, nWParam, nLParam ) CLASS TMdiChild

   #ifdef __CLIPPER__
      if nMsg == WM_MDIACTIVATE
         return ::MdiActivate( nWParam == 1, nLoWord( nLParam ),;
                               nHiWord( nLParam ) )
      endif
   #else
      if nMsg == WM_MDIACTIVATE
         return ::MdiActivate( ::hWnd == nLParam, nLParam, nWParam )
      endif
   #endif

return Super:HandleEvent( nMsg, nWParam, nLParam )

//----------------------------------------------------------------------------//

METHOD MdiActivate( lOn, hWndAct, hWndDeAct ) CLASS TMdiChild

   if lOn
      if ::oMenu != nil
         ::oWnd:SetMenu( ::oMenu, ::nMenuInfo )
      endif
   else
      if ::oMenu != nil
         ::oWnd:SetMenu( ::oWnd:oMenuStart )
      endif
   endif

return nil

//----------------------------------------------------------------------------//

METHOD Print( oTarget, nRow, nCol, nScale ) CLASS TMdiChild

   if ::bPrint != nil
      Eval( ::bPrint, Self )
      return nil
   endif

   if ::oControl != nil
      ::oControl:Print( oTarget, nRow, nCol, nScale )
   else
      Super:Print( oTarget, nRow, nCol, nScale )
   endif

return nil

//----------------------------------------------------------------------------//