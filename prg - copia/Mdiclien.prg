#include "FiveWin.ch"

#define MDIS_ALLCHILDSTYLES   1

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
#define WM_SYSCOMMAND       274   // 0x0112

#define WM_GETFONT           49  // 0x0031

#define SC_CLOSE          61536   // 0xF060
#define SC_NEXT           61504
#define SC_RESTORE        61728

#ifdef __XPP__
   #define Super ::TWindow
#endif

//----------------------------------------------------------------------------//

CLASS TMdiClient FROM TWindow

   CLASSDATA lRegistered AS LOGICAL

   DATA   aWnd

   METHOD New( oWnd, nSubMenu, nIdChildFirst, oBrush, lVScroll, lHScroll ) ;
                                                                 CONSTRUCTOR

   METHOD Display() INLINE ::BeginPaint(), ::Paint(), ::EndPaint(), 0

   METHOD Tile( lHor )   INLINE  lHor := If( lHor == nil, .f., lHor ),;
                                 ::SendMsg( WM_MDITILE, If( lHor, 1, 0 ) )

   METHOD Cascade()      INLINE  ::SendMsg( WM_MDICASCADE )
   METHOD ArrangeIcons() INLINE  ::SendMsg( WM_MDIICONARRANGE )
   METHOD NextWindow()   INLINE  ::SendMsg( WM_MDINEXT,, 1 )
   METHOD PrevWindow()   INLINE  ::SendMsg( WM_MDINEXT )

   METHOD GetActive()
   METHOD Add( oWnd )    INLINE AAdd( ::aWnd, oWnd )

   METHOD ChildNew( nTop, nLeft, nBottom, nRight, cTitle, nStyle )

   METHOD ChildActivate( oWnd ) INLINE ::SendMsg( WM_MDIACTIVATE, oWnd:hWnd )

   METHOD ChildMaximize( oWnd ) INLINE ::SendMsg( WM_MDIMAXIMIZE, oWnd:hWnd )

   METHOD ChildRestore( oWnd )  INLINE ::SendMsg( WM_MDIRESTORE, oWnd:hWnd )

   METHOD ChildClose( oWnd )

   METHOD ChildNext( oWnd, lPrev ) INLINE ;
                           lPrev := If( lPrev == nil, .f., lPrev ),;
                           ::SendMsg( WM_MDINEXT, oWnd:hWnd, If( lPrev, 1, 0 ) )

   // This method fixes some resizing bugs we had !

   METHOD ReSize( nSizeType, nWidth, nHeigh ) VIRTUAL

   METHOD lCloseAll()

   #ifdef __CLIPPER__
      METHOD IconizeAll() INLINE ASend( ::aWnd, "Iconize" )
   #else
      METHOD IconizeAll() INLINE ASend( ::aWnd, "Iconize()" )
   #endif

   MESSAGE Select METHOD _Select( nWindow )

   METHOD SetMenu( oMenu, nMenuInfo )

   METHOD  KeyDown( nKey, nFlags )

   METHOD  MouseMove( nRow, nCol, nFlags ) INLINE ::oWnd:SetMsg(),;
                        Super:MouseMove( nRow, nCol, nFlags )

   // Keep this here to properly get focus on MdiChild oControl!

   METHOD GotFocus() INLINE ::lFocused := .t.,;
                     If( ::bGotFocus != nil, Eval( ::bGotFocus ),), nil

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( oWnd, nSubMenu, nIdChildFirst, oBrush, lVscroll, lHScroll ) CLASS TMdiClient

   local cClientCreateStruct

   #ifdef __CLIPPER__
      cClientCreateStruct := ;
      I2Bin( GetSubMenu( oWnd:oMenu:hMenu, nSubMenu - 1 ) ) + ;
      I2Bin( nIdChildFirst )
   #else
      cClientCreateStruct := ;
      L2Bin( GetSubMenu( oWnd:oMenu:hMenu, nSubMenu - 1 ) ) + ;
      L2Bin( nIdChildFirst )
   #endif

   DEFAULT lVScroll := .f., lHScroll := .f.

   ::nStyle = nOr( WS_CHILD, WS_VISIBLE, WS_CLIPSIBLINGS, WS_CLIPCHILDREN,;
                   MDIS_ALLCHILDSTYLES,;
                   If( lVScroll, WS_VSCROLL, 0 ),;
                   If( lHScroll, WS_HSCROLL, 0 ) )

   ::aWnd    = {}
   ::oWnd    = oWnd
   ::oBrush  = oBrush
   ::nTop    = 0
   ::nLeft   = 0
   ::nBottom = 0
   ::nRight  = 0
   ::hWnd    = CreateWindow( "MDICLIENT", "", ::nStyle,;
                             0, 0, 0, 0, oWnd:hWnd, 1, cClientCreateStruct )
   ::Link()
   ::lVisible    = .t.
   ::lValidating = .f.

//   if lVScroll .or. lHScroll
//      SysRefresh()  // We give Windows some time to stabilize so
//   endif            // Some ScrollBar notifications get done!

   if lVScroll
      DEFINE SCROLLBAR ::oVScroll VERTICAL RANGE 1, 10 PAGESTEP 1 OF Self
   endif

   if lHScroll
      DEFINE SCROLLBAR ::oHScroll HORIZONTAL RANGE 1, 10 PAGESTEP 1 OF Self
   endif

   ::GetFont()

return Self

//----------------------------------------------------------------------------//

METHOD ChildNew( nTop, nLeft, nBottom, nRight, cTitle, nStyle ) CLASS TMdiClient

   local oWndChild := TMdiChild():New( nTop, nLeft, nBottom, nRight, cTitle,;
                                       nStyle,, ::oWnd )

   oWndChild:Show()
   oWndChild:SetFocus()

return oWndChild

//----------------------------------------------------------------------------//

METHOD GetActive() CLASS TMdiClient

   #ifdef __CLIPPER__
      local hWndAt := nLoWord( ::SendMsg( WM_MDIGETACTIVE ) )
   #else
      local hWndAt := ::SendMsg( WM_MDIGETACTIVE )
   #endif

   local oWnd, nAt

   if hWndAt != 0
      if ( nAt := AScan( ::aWnd, { | oWnd | oWnd:hWnd == hWndAt } ) ) != 0
         oWnd = ::aWnd[ nAt ]
      endif
   endif

return oWnd

//----------------------------------------------------------------------------//

METHOD ChildClose( oWnd ) CLASS TMdiClient

   local nAt := AScan( ::aWnd, { | oChild | oChild:hWnd == oWnd:hWnd } )

   if nAt != 0
      ::SendMsg( WM_MDIDESTROY, oWnd:hWnd )
      ADel( ::aWnd, nAt )
      ASize( ::aWnd, Len( ::aWnd ) - 1 )
      SetWndDefault( nil )
      if ::oWnd:oWndActive == oWnd
         ::oWnd:oWndActive = nil
      endif
   endif

return nil

//----------------------------------------------------------------------------//

METHOD lCloseAll() CLASS TMdiClient

   while Len( ::aWnd ) > 0  .and. ATail( ::aWnd ):End()
      SysRefresh()
   end

return Len( ::aWnd ) == 0

//----------------------------------------------------------------------------//

METHOD _Select( nWindow ) CLASS TMdiClient

   DEFAULT nWindow := 0

   if ! Empty( ::aWnd ) .and. nWindow >= 1 .and. nWindow <= Len( ::aWnd )
      ::SendMsg( WM_MDIACTIVATE, ::aWnd[ nWindow ]:hWnd )
   else
      ::SendMsg( WM_MDIACTIVATE, 0 )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD KeyDown( nKey, nFlags ) CLASS TMdiClient

   // When the MdiChilds are iconized, they don't receive WM_KEYDOWN messages.
   // MdiClient receives those messages and there is no a standard behavior
   // so we have to process them !

   if nKey == VK_F4 .and. GetKeyState( VK_CONTROL )
      SendMessage( ::SendMsg( WM_MDIGETACTIVE ), WM_SYSCOMMAND, SC_CLOSE )
      return 0
   endif

   if nKey == VK_F6 .and. GetKeyState( VK_CONTROL )
      SendMessage( ::SendMsg( WM_MDIGETACTIVE ), WM_SYSCOMMAND, SC_NEXT )
      return 0
   endif

   if nKey == VK_RETURN
      SendMessage( ::SendMsg( WM_MDIGETACTIVE ), WM_SYSCOMMAND, SC_RESTORE )
      return 0
   endif

return Super:KeyDown( nKey, nFlags )

//----------------------------------------------------------------------------//

METHOD SetMenu( oMenu, nMenuInfo ) CLASS TMdiClient

   if oMenu != nil
      DEFAULT nMenuInfo := Len( oMenu:aItems )

      #ifdef __CLIPPER__
         ::SendMsg( WM_MDISETMENU, 0,;
         nMakeLong( oMenu:hMenu, GetSubMenu( oMenu:hMenu, nMenuInfo - 1 ) ) )
      #else
         ::SendMsg( WM_MDISETMENU, oMenu:hMenu,;
                    GetSubMenu( oMenu:hMenu, nMenuInfo - 1 ) )
      #endif

      if oMenu:oAccTable != nil
         oMenu:oAcctable:Activate()
      endif

      DrawMenuBar( ::oWnd:hWnd )
   endif

return nil

//----------------------------------------------------------------------------//




























































































































































































































































































































































































































































































































































































































































































































































































