#include "FiveWin.ch"

#define LTGRAY_BRUSH        1
#define RT_BITMAP           2

#define OPAQUE              2
#define TRANSPARENT         1

#define COLOR_BTNFACE      15
#define COLOR_BTNSHADOW    16
#define COLOR_BTNHIGHLIGHT 20

#define NO_FOCUSWIDTH      25
#define GWL_STYLE         -16

#define TME_LEAVE           2
#define WM_MOUSELEAVE     675

#define DT_TOP              0
#define DT_LEFT             0
#define DT_CENTER           1
#define DT_RIGHT            2
#define DT_VCENTER          4
#define DT_BOTTOM           8
#define DT_WORDBREAK       16
#define DT_SINGLELINE      32
#define DT_CALCRECT      1024

#define BTN_UP              1
#define BTN_DOWN            2
#define BTN_DISABLE         3
#define BTN_OVERMOUSE       4

#ifdef __XPP__
   #define Super ::TControl
   #define New _New
#endif

#define LAYOUT_CENTER  0
#define LAYOUT_TOP     1
#define LAYOUT_LEFT    2
#define LAYOUT_BOTTOM  3
#define LAYOUT_RIGHT   4

#define DST_BITMAP      4
#define DSS_UNION      16
#define DSS_DISABLED   32
#define DSS_MONO      128

#define SRCCOPY      0x00CC0020

static aLayouts := { "TOP", "LEFT", "BOTTOM", "RIGHT" }

//----------------------------------------------------------------------------//

CLASS TBtnBmp FROM TControl

   DATA   bAction
   DATA   cAction   // A string description of the action
   DATA   lPressed, lAdjust, lGroup AS LOGICAL
   DATA   lWorking, lBtnUp, lBtnDown
   DATA   lBoxSelect
   DATA   hBitmap1, hPalette1
   DATA   hBitmap2, hPalette2
   DATA   hBitmap3, hPalette3
   DATA   hBitmap4, hPalette4
   DATA   hRgn
   DATA   cResName1, cResName2, cResName3, cResName4
   DATA   cBmpFile1, cBmpFile2, cBmpFile3, cBmpFile4
   DATA   lProcessing AS LOGICAL INIT .F.
   DATA   lBorder AS LOGICAL INIT .T.
   DATA   lRound AS LOGICAL INIT .T.
   DATA   oPopup
   DATA   nLayout
   DATA   lMOver // mouse is over it
   DATA   l2007   INIT .F.
   DATA   lBarBtn INIT .F.


   CLASSDATA lRegistered AS LOGICAL

   METHOD New( nTop, nLeft, nWidth, nHeight,;
               cResName1, cResName2, cBmpFile1, cBmpFile2,;
               bAction, oWnd, cMsg, bWhen, lAdjust, lUpdate,;
               cPrompt, oFont, cResName3, cBmpFile3, lBorder, cLayout, ;
               l2007, cResName4, cBmpFile4 ) CONSTRUCTOR

   METHOD NewBar( cResName1, cResName2, cBmpFile1, cBmpFile2,;
                  cMsg, bAction, lGroup, oBar, lAdjust, bWhen,;
                  cToolTip, lPressed, bDrop, cAction, nPos,;
                  cResName3, cBmpFile3, lBorder, cLayout, cResName4, cBmpFile4 ) CONSTRUCTOR

   METHOD ReDefine( nId, cResName1, cResName2, cBmpFile1, cBmpFile2,;
                    cMsg, bAction, oBar, lAdjust, bWhen, lUpdate,;
                    cToolTip, cPrompt, oFont, cResName3,;
                    cBmpFile3, lBorder, cLayout, cResName4, cBmpFile4 ) CONSTRUCTOR

   METHOD Click()
   METHOD Display() INLINE ::BeginPaint(), ::Paint(), ::EndPaint(), 0

   METHOD Disable() INLINE Super:Disable(), ::Refresh()
   METHOD Enable()  INLINE Super:Enable(), ::Refresh()

   METHOD End() INLINE ::Destroy()

   METHOD EraseBkGnd( hDC ) INLINE 1

   METHOD FreeBitmaps()

   METHOD GoUp() INLINE ::lPressed := ::lBtnDown := .f.,;
                        ::Refresh()

   METHOD GoDown() INLINE ::lPressed := ::lBtnDown := .T.,;
                        ::Refresh()

   METHOD ResetBorder() INLINE ::lBorder := .f.,;
                        ::Refresh()

   METHOD cGenPRG()
   METHOD LButtonDown( nRow, nCol )
   METHOD LButtonUp( nRow, nCol )
   METHOD LoadBitmaps( cResName1, cResName2, cBmpFile1, cBmpFile2, cResName3, cBmpFile3, cResName4, cBmpFile4 )

   METHOD GotFocus( hCtlLost )

   METHOD Initiate( hDlg )

   METHOD KeyChar( nKey, nFlags )
   METHOD KeyDown( nKey, nFlags )

   METHOD LostFocus()

   METHOD Paint()

   METHOD MouseMove( nRow, nCol, nKeyFlags )

   METHOD Destroy()

   METHOD SetFile( cBmpUpFile, cBmpDownFile )

   METHOD Toggle() INLINE ::lBtnDown := ! ::lBtnDown,;
                          ::lPressed := ::lBtnDown,;
                          ::Refresh()

   METHOD HandleEvent( nMsg, nWParam, nLParam )

   METHOD MouseLeave( nRow, nCol, nFlags )

   METHOD ShowPopup()

   METHOD SetColor( nClrText, nClrPane )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( nTop, nLeft, nWidth, nHeight,;
            cResName1, cResName2, cBmpFile1, cBmpFile2,;
            bAction, oWnd, cMsg, bWhen, lAdjust, lUpdate,;
            cPrompt, oFont, cResName3, cBmpFile3, lBorder, cLayout, ;
            l2007, cResName4, cBmpFile4,lTransparent, cToolTip, nId )  CLASS TBtnBmp

   DEFAULT cMsg := " ", nWidth := 20, nHeight := 20, lAdjust := .f.,;
           lUpdate := .f., oWnd := GetWndDefault(), lBorder := .t.,;
           l2007 := .f., cLayout := "TOP", lTransparent := .f. ,;
           nId := ::GetNewId()

   ::nStyle    = nOR( WS_CHILD, WS_VISIBLE,; // WS_CLIPSIBLINGS
                      If( lBorder,if( l2007,0,WS_BORDER), 0 ),;
                      If( lBorder .and. !Upper( oWnd:ClassName() )$"TBAR;TOUTLOOK;TXBROWSE" , WS_TABSTOP, 0 ) )

   ::nId       = nId
   ::oWnd      = oWnd
   ::bAction   = bAction
   ::cMsg      = cMsg
   ::nTop      = nTop
   ::nLeft     = nLeft
   ::nBottom   = nTop + nHeight - 1
   ::nRight    = nLeft + nWidth - 1
   ::lPressed  = .f.
   ::lWorking  = .f.
   ::lAdjust   = lAdjust
   ::lDrag     = .f.
   ::lCaptured = .f.
   ::bWhen     = bWhen
   ::nClrText  = ::oWnd:nClrText
   ::nClrPane  = GetSysColor( COLOR_BTNFACE )
   ::lUpdate   = lUpdate
   ::l97Look   = !lBorder
   ::lBorder   = lBorder
   ::lBtnDown  = .f.
   ::nLayout   = AScan( aLayouts, cLayout )

   ::lTransparent = lTransparent

   ::cToolTip = cToolTip

   ::lBoxSelect = .t.

   ::hBitmap1  = 0
   ::hPalette1 = 0
   ::hBitmap2  = 0
   ::hPalette2 = 0
   ::hBitmap3  = 0
   ::hPalette3 = 0
   ::hBitmap4  = 0
   ::hPalette4 = 0

   ::cCaption  = cPrompt
   ::oFont     := oFont
   ::nDlgCode  = If( Upper( ::oWnd:ClassName() ) == "TBAR", nil, DLGC_WANTALLKEYS )
   ::lMOver    = .F.
   ::l2007     = l2007

   #ifdef __XPP__
      DEFAULT ::lRegistered := .f.
      ::lProcessing = .f.
      #undef New
   #endif

   ::Register( nOR( CS_VREDRAW, CS_HREDRAW ) )

   if ! Empty( oWnd:hWnd )
      ::Create()
      ::SetColor( If( ValType( ::nClrText ) == "B", Eval( ::nClrText, ::lMOver ), ::nClrText ), ::nClrPane )
      oWnd:AddControl( Self )
   else
      oWnd:DefControl( Self )
   endif

   ::LoadBitmaps( cResName1, cResName2, cBmpFile1, cBmpFile2,;
                  cResName3, cBmpFile3, cResName4, cBmpFile4  )

return Self

//----------------------------------------------------------------------------//

METHOD NewBar( cResName1, cResName2, cBmpFile1, cBmpFile2, cMsg, bAction,;
               lGroup, oBar, lAdjust, bWhen, cToolTip, lPressed,;
               bDrop, cAction, nPos, cPrompt, oFont, cResName3, cBmpFile3,;
               lBorder, oPopup, cLayout, cResName4, cBmpFile4, lTransparent) CLASS TBtnBmp

   DEFAULT cMsg := "", lAdjust := .f., lPressed := .f., lBorder := .t.,; //ojo
           cLayout := "TOP", lTransparent := .f.

   if Upper( oBar:ClassName() ) == "TBAR" .and. oBar:l2007
      ::nStyle    = nOR( WS_CHILD, WS_VISIBLE )
   else
      ::nStyle    = nOR( If( lBorder, WS_BORDER, 0 ), WS_CHILD, WS_VISIBLE )
   endif
   ::l97Look   = !lBorder
   ::nId       = ::GetNewId()
   ::oWnd      = oBar
   ::bAction   = bAction
   ::cMsg      = cMsg
   ::nTop      = oBar:GetBtnTop( lGroup, nPos )
   ::nLeft     = oBar:GetBtnLeft( lGroup, nPos )
   ::nBottom   = ::nTop + oBar:nBtnHeight + 1 - If( oBar:l3D .and. !oBar:l2007, 7, 0 )
   ::nRight    = ::nLeft + oBar:nBtnWidth - If( oBar:l3D .and. !oBar:l2007, 2, 0 ) + ;
                 If( oPopup != nil, 13, 0 )
   ::lPressed  = lPressed
   ::lCaptured = .f.
   ::lWorking  = .f.
   ::lDrag     = .f.
   ::lBtnDown  = lPressed
   ::lAdjust   = lAdjust
   ::lGroup    = lGroup
   ::bWhen     = bWhen
   ::nClrText  = ::oWnd:nClrText
   ::nClrPane  = GetSysColor( COLOR_BTNFACE )
   ::oCursor   = oBar:oCursor
   ::cToolTip  = cToolTip
   ::bDropOver = bDrop
   ::cResName1 = cResName1
   ::cResName2 = cResName2
   ::cBmpFile1 = cBmpFile1
   ::cBmpFile2 = cBmpFile2
   ::cAction   = cAction
   ::cCaption  = cPrompt
   ::oFont     = oFont
   ::lBorder   = lBorder

   ::lTransparent = lTransparent

   ::lBoxSelect = .t.

   ::nLayout   = AScan( aLayouts, cLayout )
   ::hBitmap1  = 0
   ::hPalette1 = 0
   ::hBitmap2  = 0
   ::hPalette2 = 0
   ::hBitmap3  = 0
   ::hPalette3 = 0
   ::hBitmap4  = 0
   ::hPalette4 = 0

   ::oPopup    = oPopup
   ::nDlgCode  = If( Upper( ::oWnd:ClassName() ) == "TBAR", nil, DLGC_WANTALLKEYS )
   ::lMOver    = .F.
   ::lBarBtn   = .T.

   #ifdef __XPP__
      DEFAULT ::lRegistered := .f.
      ::lProcessing = .f.
   #endif

   ::Register( nOR( CS_VREDRAW, CS_HREDRAW ) )

   ::Create()
   oBar:Add( Self, nPos )
   ::SetColor( If( ValType( ::nClrText ) == "B", Eval( ::nClrText, ::lMOver ), ::nClrText ), ::nClrPane )

   ::LoadBitmaps( cResName1, cResName2, cBmpFile1, cBmpFile2,;
                  cResName3, cBmpFile3, cResName4, cBmpFile4 )

   if bWhen != nil .and. ! ::lWhen()
      ::Disable()
   endif

return Self

//----------------------------------------------------------------------------//

METHOD ReDefine( nId, cResName1, cResName2, cBmpFile1, cBmpFile2, cMsg,;
                 bAction, oBar, lAdjust, bWhen, lUpdate, cToolTip,;
                 cPrompt, oFont, cResName3, cBmpFile3, lBorder, cLayout, ;
                 l2007, cResName4, cBmpFile4, lTransparent ) CLASS TBtnBmp

   DEFAULT cMsg := "", lAdjust := .f., lUpdate := .f., lBorder := .t.,;
           cLayout := "TOP", l2007 := .f., oBar := GetWndDefault()

   ::l97Look   = ! lBorder
   ::nId       = nId
   ::oWnd      = oBar
   ::bAction   = bAction
   ::cMsg      = cMsg
   ::lPressed  = .f.
   ::lCaptured = .f.
   ::lWorking  = .f.
   ::lDrag     = .f.
   ::lAdjust   = lAdjust
   ::bWhen     = bWhen
   ::nClrPane  = GetSysColor( COLOR_BTNFACE )
   ::lUpdate   = lUpdate
   ::cToolTip  = cToolTip
   ::cCaption  = cPrompt
   ::oFont     = oFont
   ::lBorder   = lBorder
   ::lBtnDown  = .f.
   ::nLayout   = AScan( aLayouts, cLayout )
   ::nDlgCode  = DLGC_WANTALLKEYS
   ::lMOver    = .F.

   ::lTransparent = lTransparent

   ::lBoxSelect = .t.

   ::hBitmap1  = 0
   ::hPalette1 = 0
   ::hBitmap2  = 0
   ::hPalette2 = 0
   ::hBitmap3  = 0
   ::hPalette3 = 0
   ::hBitmap4  = 0
   ::hPalette4 = 0
   ::lBarBtn   = .F.
   ::l2007     = l2007

   #ifdef __XPP__
      ::lProcessing = .f.
   #endif

   ::Register( nOR( CS_VREDRAW, CS_HREDRAW ) )

   oBar:DefControl( Self )

   ::LoadBitmaps( cResName1, cResName2, cBmpFile1, cBmpFile2,;
                  cResName3, cBmpFile3, cResName4, cBmpFile4 )

return Self

//----------------------------------------------------------------------------//

METHOD Click() CLASS TBtnBmp

   if ::bWhen != NIL
      if ! Eval( ::bWhen )
         MsgBeep()
         return NIL
      endif
   endif

   if ! ::lProcessing .and. !::lPressed
      ::lProcessing = .t.

      if ::bAction != nil
         Eval( ::bAction, Self )
      endif

      Super:Click()         // keep it here, the latest!
      ::lProcessing = .f.
   endif

return nil

//----------------------------------------------------------------------------//

METHOD GotFocus( hCtlLost ) CLASS TBtnBmp

   local nWidth, lDlg
   local nAdj := 0

   if lAnd( GetWindowLong( ::hWnd, GWL_STYLE ), WS_TABSTOP )
      if ( nWidth := ::nWidth() ) > NO_FOCUSWIDTH
//         lDlg = ( Upper( ::oWnd:ClassName() ) == "TDIALOG" )
         nAdj := if ( ::l2007, 2, 0 )
         DrawFocusRect( ::GetDC(), 2, 2, ::nHeight() - 4 + nAdj, nWidth - 4 + nAdj )
         ::ReleaseDC()
      endif
   endif

return Super:GotFocus()

//----------------------------------------------------------------------------//

METHOD Initiate( hDlg ) CLASS TBtnBmp

   local uValue

   ::SetColor( If( ValType( ::nClrText ) == "B", Eval( ::nClrText, ::lMOver ), ::nClrText ), ::nClrPane )

   uValue = Super:Initiate( hDlg )

   DEFAULT ::cCaption := GetWindowText( ::hWnd )

return uValue

//----------------------------------------------------------------------------//

METHOD KeyChar( nKey, nFlags ) CLASS TBtnBmp

   if nKey == VK_RETURN .or. nKey == VK_SPACE
      ::lPressed = .t.
      ::Refresh()
   else
      return Super:KeyChar( nKey, nFlags )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD LostFocus() CLASS TBtnBmp

   local nWidth, lDlg, nAdj

   if ::l97Look .and. ::lBorder
      ReleaseCapture()
      ::lBorder := .f.
      ::Refresh()
   endif

   if lAnd( GetWindowLong( ::hWnd, GWL_STYLE ), WS_TABSTOP )
      if ( nWidth := ::nWidth() ) > NO_FOCUSWIDTH
//         lDlg = ( Upper( ::oWnd:ClassName() ) == "TDIALOG" )
         nAdj := if ( ::l2007, 2, 0 )
         DrawFocusRect( ::hDC, 2, 2, ::nHeight() - 4 + nAdj, nWidth - 4 + nAdj )
      endif
      ::Refresh()
   endif
   if ::lPressed
      ::lPressed := .f.
      ::refresh()
   endif

return Super:LostFocus()

//----------------------------------------------------------------------------//

METHOD cGenPRG() CLASS TBtnBmp

   local cPrg := ""

   cPrg += CRLF + CRLF + "   DEFINE BTNBMP OF oBar " + ;
              'ACTION MsgInfo( "Not defined yet" )'

return cPrg

//----------------------------------------------------------------------------//

METHOD LButtonDown( nRow, nCol ) CLASS TBtnBmp

   if ::lDrag .or. ! Empty( ::oDragCursor )
      return Super:LButtonDown( nRow, nCol )
   endif

   ::lWorking = .t.
   ::lBtnUp   = .f.

   SetFocus( ::hWnd )    // To let the main window child control
   SysRefresh()          // process its valid

   if GetFocus() == ::hWnd
      ::lCaptured = .t.
      ::lPressed  = .t.
      ::Capture()
      ::Refresh() // .f.
   endif

   ::lWorking = .f.

   if ::lBtnUp
      ::LButtonUp( nRow, nCol )
      ::lBtnUp = .f.
   endif

return 0

//----------------------------------------------------------------------------//

METHOD LButtonUp( nRow, nCol )  CLASS TBtnBmp

   local oWnd
   local lClick := IsOverWnd( ::hWnd, nRow, nCol )

   if ::lDrag .or. ! Empty( ::oDragCursor )
      return Super:LButtonUp( nRow, nCol )
   endif

   if ::bLButtonUp != nil
      Eval( ::bLButtonUp, nRow, nCol)
   endif

   ::lBtnUp  = .t.

   if ! ::lWorking
      if ::lCaptured
         ::lCaptured = .f.
         ReleaseCapture()
         if ! ::lPressed
            if ::lBtnDown
               ::lPressed = .t.
               ::Refresh()
            endif
         else
            if ! ::lBtnDown
               ::lPressed = .f.
               ::Refresh()
            endif
         endif
         if lClick
            if ::oPopup != nil
               if nCol >= ::nWidth() - 13
                  if ::oWnd:oWnd != nil .and. Upper( ::oWnd:oWnd:Classname() ) == "TBAR"
                     oWnd := ::oWnd:oWnd
                  else
                     oWnd := ::oWnd
                  endif
                  oWnd:NcMouseMove() // close the tooltip
                  oWnd:oPopup = ::oPopup
                  ::oPopup:Activate( ::nTop + ::nHeight(), ::nLeft, oWnd, .f. )
                  oWnd:oPopup = nil
                  ::Refresh()
               else
                  ::Click()
               endif
            else
               ::Click()
            endif
         endif
      endif
   endif

return 0

//----------------------------------------------------------------------------//

METHOD Destroy() CLASS TBtnBmp

   ::FreeBitmaps()
   if ::oPopup != nil
      ::oPopup:End()
   endif
   Super:Destroy()

return 0

//----------------------------------------------------------------------------//

METHOD SetFile( cBmpUpFile, cBmpDownFile ) CLASS TBtnBmp

   ::FreeBitmaps()
   ::LoadBitmaps( nil, nil, cBmpUpFile, cBmpDownFile )
   ::Refresh()

return nil

//----------------------------------------------------------------------------//

METHOD FreeBitmaps() CLASS TBtnBmp

   if ::hBitmap1 != 0
      PalBmpFree( ::hBitmap1, ::hPalette1 )
   endif

   if ::hBitmap2 != 0
      PalBmpFree( ::hBitmap2, ::hPalette2 )
   endif

   if ::hBitmap3 != 0
      PalBmpFree( ::hBitmap3, ::hPalette3 )
   endif

   if ::hBitmap4 != 0
      PalBmpFree( ::hBitmap4, ::hPalette4 )
   endif

   ::hBitmap1  = 0
   ::hPalette1 = 0
   ::hBitmap2  = 0
   ::hPalette2 = 0
   ::hBitmap3  = 0
   ::hPalette3 = 0
   ::hBitmap4  = 0
   ::hPalette4 = 0

return nil

//----------------------------------------------------------------------------//

METHOD LoadBitmaps( cResName1, cResName2, cBmpFile1, cBmpFile2,;
                    cResName3, cBmpFile3, cResName4, cBmpFile4 ) CLASS TBtnBmp

   local aBmpPal

   if ! Empty( cResName1 )
      aBmpPal = PalBmpLoad( cResName1 )
      ::hBitmap1  = aBmpPal[ 1 ]
      ::hPalette1 = aBmpPal[ 2 ]
   endif

   if ! Empty( cResName2 )
      aBmpPal = PalBmpLoad( cResName2 )
      ::hBitmap2  = aBmpPal[ 1 ]
      ::hPalette2 = aBmpPal[ 2 ]
   endif

   if ! Empty( cResName3 )
      aBmpPal = PalBmpLoad( cResName3 )
      ::hBitmap3  = aBmpPal[ 1 ]
      ::hPalette3 = aBmpPal[ 2 ]
   endif

   if ! Empty( cResName4 )
      aBmpPal = PalBmpLoad( cResName4 )
      ::hBitmap4  = aBmpPal[ 1 ]
      ::hPalette4 = aBmpPal[ 2 ]
   endif


   if ! Empty( cBmpFile1 )
      if File( cBmpFile1 )
         ::cBmpFile1 = cBmpFile1
         aBmpPal     = PalBmpRead( ::GetDC(), cBmpFile1 )
         ::hBitmap1  = aBmpPal[ 1 ]
         ::hPalette1 = aBmpPal[ 2 ]
         ::ReleaseDC()
      endif
   endif

   if ! Empty( cBmpFile2 )
      if File( cBmpFile2 )
         ::cBmpFile2 = cBmpFile2
         aBmpPal     = PalBmpRead( ::GetDC(), cBmpFile2 )
         ::hBitmap2  = aBmpPal[ 1 ]
         ::hPalette2 = aBmpPal[ 2 ]
         ::ReleaseDC()
      endif
   endif

   if ! Empty( cBmpFile3 )
      if File( cBmpFile3 )
         ::cBmpFile3 = cBmpFile3
         aBmpPal     = PalBmpRead( ::GetDC(), cBmpFile3 )
         ::hBitmap3  = aBmpPal[ 1 ]
         ::hPalette3 = aBmpPal[ 2 ]
         ::ReleaseDC()
      endif
   endif

   if ! Empty( cBmpFile4 )
      if File( cBmpFile4 )
         ::cBmpFile4 = cBmpFile4
         aBmpPal     = PalBmpRead( ::GetDC(), cBmpFile4 )
         ::hBitmap4  = aBmpPal[ 1 ]
         ::hPalette4 = aBmpPal[ 2 ]
         ::ReleaseDC()
      endif
   endif

   if ! Empty( ::hBitmap1 )
      PalBmpNew( ::hWnd, ::hBitmap1, ::hPalette1 )
   endif

   if ! Empty( ::hBitmap2 )
      PalBmpNew( ::hWnd, ::hBitmap2, ::hPalette2 )
   endif

   if ! Empty( ::hBitmap3 )
      PalBmpNew( ::hWnd, ::hBitmap3, ::hPalette3 )
   endif

   if ! Empty( ::hBitmap4 )
      PalBmpNew( ::hWnd, ::hBitmap4, ::hPalette4 )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD MouseMove( nRow, nCol, nKeyFlags ) CLASS TBtnBmp

   if ! ::lMOver
      ::lMOver = .T.
      ::Refresh()
   endif

   if ::lDrag .or. ! Empty( ::oDragCursor )
      return Super:MouseMove( nRow, nCol, nKeyFlags )
   endif

   Super:MouseMove( nRow, nCol, nKeyFlags )

   IF !::l2007
      if IsOverWnd( ::hWnd, nRow, nCol )
         if !::lCaptured
            if ::l97Look
               ::Capture()
               if !::lBorder
                  ::lBorder := .t.
                  ::Refresh()
               endif
            endif
         else
            if ! ::lPressed
               ::lPressed := .t.
               ::Refresh()
            endif
         endif
      else
         if !::lCaptured
            if ::l97Look
               ReleaseCapture()
               if ::lBorder
                  ::lBorder := .f.
                  ::Refresh()
               endif
            endif
         else
            if ::lPressed
               ::lBorder  :=  ! ::l97Look
               ::lPressed := .f.
               ::Refresh()
            endif
         endif
      endif
   endif
   ::oWnd:SetMsg( ::cMsg )

   TrackMouseEvent( ::hWnd, TME_LEAVE )

return 0

//----------------------------------------------------------------------------//

METHOD Paint() CLASS TBtnBmp

   local hOldFont, nRow, nCol, nWidth, nHeight
   local hDC, hOldPen, hDarkPen, hLightPen, lDlg
   local aInfo := ::DispBegin()
   local hBmpOld, nZeroZeroClr, nOldClr, oFont, hBmp, nClr
   local nTop, nLeft, hOlFont
   local nBmpHeight := 0, nBmpWidth := 0, nBmpTop := 0, nBmpLeft := 0
   local nTxtTop := 0, nTxtLeft := 6, nTxtRight := ::nWidth - 6
   local nFontHeight := 11, nStyle := 0
   local lMultiLine  := .f.
   local hRGN, hPen, hBlackBrush, hOldBrush
   local nAdjustBorder := 0, nAdjust := 0
   local nBtn := 1, nLine:=1, nOffset := 0, nMaxWidth := 0
   local cWord := "", cWord2 := "", nLayOut := 1

   if ::oPopup != nil
      nTxtRight -= 12
   endif

   if ::lBarBtn
      ::lRound = .F.
   endif

   if ::lBarBtn
      ::l2007 = ::oWnd:l2007
         if ::oWnd:oFont != nil
            if ::oWnd:oFont:cFaceName != "Tahoma"
               DEFINE FONT oFont NAME "Tahoma" SIZE 0, -11
               ::oWnd:SetFont( oFont )
            endif
            ::SetFont( ::oWnd:oFont )
         else
            DEFINE FONT oFont NAME "Tahoma" SIZE 0, -11
            ::oWnd:SetFont( oFont )
            ::SetFont( oFont )
         endif

   else
      if ::oFont == nil
         ::SetFont( ::oWnd:oFont )
         if ::oFont == nil .and. ! Empty( ::oWnd )
           ::SetFont( ::oWnd:oWnd:oFont )
         endif
      else
         ::SetFont( ::oFont )
      endif
   endif

   hBmp := if ( ::lPressed, if(  empty( ::hBitmap2 ), if ( ::lMOver .and. !empty( ::hBitmap4 ), ::hBitmap4, ::hBitmap1 ),;
                  ::hBitmap2 ), if ( ! IsWindowEnabled( ::hWnd ) .and. ! Empty( ::hBitmap3 ),;
                  ::hBitmap3, if ( ::lMOver .and. !empty( ::hBitmap4 ), ::hBitmap4, ::hBitmap1 ) ) )

   nBtn := if ( ::lPressed, if(  empty( ::hBitmap2 ), if ( ::lMOver .and. !empty( ::hBitmap4 ), 4, 1 ),;
                  2 ), if ( ! IsWindowEnabled( ::hWnd ) .and. ! Empty( 3 ),;
                  3, if ( ::lMOver .and. !empty( ::hBitmap4 ), 4, 1 ) ) )

   lMultiLine  := ! Empty( ::cCaption ) .and. CRLF $ ::cCaption

   if lMultiLine
      cWord := cStrWord( ::cCaption, nOffset, CRLF )
      while nOffset < len( ::cCaption )
         nMaxWidth := max( nMaxWidth, len( cWord2 := cStrWord( ::cCaption, @nOffset, CRLF ) ) )
         if len( cWord ) < nMaxWidth
           cWord := cWord2
         endif
      end
      nLine = MLCount( ::cCaption )
   else
      cWord := ::cCaption
   endif


   if ! Empty( hBmp )
      if ::lAdjust
         hBmp := resizebmp( hBmp, ::nWidth, ::nHeight )
      endif

      nBmpWidth      := nBmpWidth( hBmp )
      nBmpHeight     := nBmpHeight( hBmp )
      nBmpLeft       := ( ::nWidth - nBmpWidth ) / 2
      nBmpTop        := ( ::nHeight - nBmpHeight ) / 2
      if ! Empty( ::cCaption )
         DEFAULT ::nLayOut := 1

         do case
            case ::nLayOut == 1 // top
               nBmpTop     := ::nHeight / 2 - ( nBmpHeight + nLine * ::nGetChrHeight() ) / 2 - 4

            case ::nLayOut == 2 // left
               nBmpLeft    :=  ::nWidth / 2 - ( nBmpWidth + ::GetWidth( cWord ) ) / 2 + 4

            case ::nLayOut == 3 // bottom
               nBmpTop := ( ::nHeight / 2 ) - ( nBmpHeight / 2 ) + ( nLine * ::nGetChrHeight() ) / 2 + 4

            case ::nLayOut == 4 // right
               nBmpLeft    := ( ::nWidth / 2 ) - ( nBmpWidth / 2 ) + ( ::GetWidth( cWord ) ) / 2 - 4
            otherwise
         endcase
      endif
   endif

   nLayOut := ::nLayOut
   if ! Empty( ::cCaption )

         DEFAULT ::nLayOut := 1
         do case
            case ::nLayOut == 1 // top
               if !empty( hBmp )
                  nTxtTop := nBmpTop + nBmpHeight + 4
               else
                  nTxtTop := ::nHeight - ( nLine * ::nGetChrHeight() ) - 4
               endif

            case ::nLayOut == 2 // left
               nTxtTop := ::nHeight / 2 - ( ::nGetChrHeight() * nLine ) /2 - 4
               if ::lAdjust
                  nTxtLeft := 4
               else
                  if !empty( hBmp )
                     nTxtLeft := nBmpLeft + nBmpWidth + 4
                     nLayOut := 4
                  else
                     nTxtLeft :=  4
                  endif
            endif

            case ::nLayOut == 3 // bottom
               if !empty( hBmp )
                  nTxtTop := nBmpTop - ( nLine * ::nGetChrHeight() ) - 4
               else
                  nTxtTop := 4
               endif

            case ::nLayOut == 4 // right
               nTxtTop := (::nHeight / 2) - ( ( ::nGetChrHeight() * nLine ) / 2 ) - 4
               if ::lAdjust
                  nTxtRight := ::nWidth - 4
               else
                  if !empty( hBmp )
                     nTxtRight := nBmpLeft - 4
                     nLayOut := 2
                  else
                     nTxtRight := ::nWidth
                  endif

               endif

            otherwise
               nTxtTop = ::nHeight / 2 - ( ::nGetChrHeight() * nLine ) /2 + 2
         endcase
   endif


   if ::l2007
      if ! Empty( ::cCaption )
         if ::oFont == nil
            ::SetFont( ::oWnd:oFont )
            if ::oFont == nil .and. ! Empty( ::oWnd )
               ::SetFont( ::oWnd:oWnd:oFont )
            endif
         endif
      endif
      if ::lPressed
         nBmpTop++
         nBmpLeft++
         nAdjust := 1
      endif

     if ! ::lBarBtn
        if Empty( ::hRgn ) .and. ::lRound
           ::hRgn := CreateRoundRectRgn( ::hWnd, 6, 6 )
           SetWindowRgn( ::hWnd, ::hRgn )
        endif

        nAdjustBorder = If( ::lBorder, If( ::lBarBtn, 0, 3 ), 0 )

        if ::lBorder
           if ::lRound
              RoundBox( ::hDC, 1, 1, ::nWidth, ::nHeight, 6, 6, RGB( 237, 242, 248 ) )
              RoundBox( ::hDC, 0, 0, ::nWidth-1, ::nHeight-1, 6, 6, RGB( 141, 178, 227 ), 1 )
           else
              Rectangle( ::hDC, 0, 0, ::nHeight, ::nWidth )
           endif
        endif
     endif

     if ::oPopUp != nil
        if ::nLayOut != 2 // left
           nBmpLeft -= 6
        endif
     endif

     hBmpOld = SelectObject( ::hDC, hBmp )
     nZeroZeroClr = GetPixel( ::hDC, 0, 0 )
     SelectObject( ::hDC, hBmpOld )

     if ! Empty( hBmp )
           nOldClr = SetBkColor( ::hDC, nRGB( 255, 255, 255 ) )
           TransBmp( hBmp, nBmpWidth, nBmpHeight, nZeroZeroClr, ::hDC,;
                     if( ::lAdjust, nAdjust, nBmpLeft ), ;
                     if( ::lAdjust, nAdjust, nBmpTop ),;
                     if (::lAdjust, ::nWidth, nBmpWidth ) ,;
                     if( ::lAdjust, ::nHeight, nBmpHeight ) )
          SetBkColor( ::hDC, nOldClr )
     endif

     if ! Empty( ::cCaption )
        nStyle   := nOr( if( ::nLayOut == 0, DT_CENTER,nLayOut), DT_WORDBREAK ,;
        if ( ::nLayOut%2 == 0, DT_VCENTER, DT_TOP ) )
        nClr = If( IsWindowEnabled( ::hWnd ), ::nClrText, CLR_HGRAY )
        SetTextColor( ::hDC, If( ValType( nClr ) == "B", Eval( nClr, ::lMOver ), nClr ) )
        SetBkMode( ::hDC, 1 )
        hOldFont = SelectObject( ::hDC, If( ::lBarBtn, ::oWnd:oFont:hFont, ::oFont:hFont ) )
        DrawText( ::hDC, ::cCaption,{nTxtTop+nAdjust, nTxtLeft+nAdjust, ::nHeight+nAdjust-4, nTxtRight+nAdjust},nStyle  )
        SelectObject( ::hDC, hOldFont )
     endif

     if ( ::lMOver .and. ::lBoxSelect )
        if !::lRound
           WndBox2007( ::hDC, nAdjustBorder, nAdjustBorder, ::nHeight - nAdjustBorder-1, ::nWidth - nAdjustBorder-1, nRGB( 221, 207, 155 ) )
        else
           RoundBox( ::hDC, 2, 2, ::nWidth-3, ::nHeight-3, 6, 6,  nRGB( 221, 207, 155 ) )
        endif
     endif

     if ::oPopup != nil
        nHeight = ::nHeight
        nWidth  = ::nWidth
        hDC     = ::hDC
        hBlackBrush = GetStockObject( 4 )
        hOldBrush   = SelectObject( hDC, hBlackBrush )
        PolyPolygon( hDC, { { nWidth - 9 + If( ::lPressed, 1, 0 ), nHeight / 2 - 1 + If( ::lPressed, 1, 0 )},;
           { nWidth - 7 + If( ::lPressed, 1, 0 ), nHeight / 2 + 1 + If( ::lPressed, 1, 0 )},;
           { nWidth - 5 + If( ::lPressed, 1, 0 ), nHeight / 2 - 1 + If( ::lPressed, 1, 0 )},;
           { nWidth - 9 + If( ::lPressed, 1, 0 ), nHeight / 2 - 1 + If( ::lPressed, 1, 0 )} } )
        if ::lBorder .or. ::lPressed .or. ::lMOver
           hDarkPen  = CreatePen( PS_SOLID, 1, GetSysColor( COLOR_BTNSHADOW ) )
           hLightPen = CreatePen( PS_SOLID, 1, GetSysColor( COLOR_BTNHIGHLIGHT ) )
           hOldPen = SelectObject( hDC, hLightPen )
           MoveTo( hDC, nWidth - 12 + If( ::lPressed, 1, 0 ), 1 )
           LineTo( hDC, nWidth - 12 + If( ::lPressed, 1, 0 ), nHeight - 1 )
           SelectObject( hDC, hDarkPen )
           MoveTo( hDC, nWidth - 13 + If( ::lPressed, 1, 0 ), 1 )
           LineTo( hDC, nWidth - 13 + If( ::lPressed, 1, 0 ), nHeight - 1 )
           SelectObject( hDC, hOldPen )
           DeleteObject( hDarkPen )
           DeleteObject( hLightPen )
        endif
        SelectObject( hDC, hOldBrush )
        DeleteObject( hBlackBrush )
     endif

     if ! IsWindowEnabled( ::hWnd ) .and. Empty( ::hBitmap3 )
        // BtnDisable( ::hWnd, ::hDC )
     endif

     DEFAULT ::lFocused := .f. // XPP requirement

     if lAnd( GetWindowLong( ::hWnd, GWL_STYLE ), WS_TABSTOP ) .and. ::lFocused .and. !::lBarBtn
        if ( nWidth := ::nWidth() ) > NO_FOCUSWIDTH
           lDlg = ( Upper( ::oWnd:ClassName() ) == "TDIALOG" )
           #ifdef __CLIPPER__
              if lDlg
                 DrawFocusRect( ::hDC, 2, 2, ::nHeight() - 2, nWidth - 2 )
              else
                 DrawFocusRect( ::hDC, 4, 4, ::nHeight() - 4, nWidth - 4 )
              endif
           #else
              if lDlg
                 DrawFocusRect( ::hDC, 2, 2, ::nHeight() - 2, nWidth - 2 )
              else
                 DrawFocusRect( ::hDC, 4, 4, ::nHeight() - 4, nWidth - 4 )
              endif
           #endif
        endif
     endif

     ::DispEnd( aInfo )
     return nil
  endif

  if ::lPressed
     nBmpTop++
     nBmpLeft++
     nAdjust := 1
  endif

  if ::lTransparent .and. ! Empty( ::oBrush:hBitmap )
     SetBrushOrgEx( ::hDC, nBmpWidth( ::oBrush:hBitmap ) - ::nLeft, nBmpHeight( ::oBrush:hBitmap ) - ::nTop )
  endif
  FillRect( ::hDC, GetClientRect( ::hWnd ), ::oBrush:hBrush )

  IF !Empty( hBmp )
     if IsAppThemed() .or. !::lTransparent
        PalBtnPaint( ::hWnd, if( ::lMOver .and. !Empty( ::hBitmap4 ), ::hBitmap4, ::hBitmap1 ),;
                  if( ::lMOver .and. !Empty( ::hBitmap4 ), ::hPalette4, ::hPalette1 ),;
                  if ( ::lAdjust .and. empty( ::hBitmap2 ), ::hBitmap1,::hBitmap2 ),;
                  if ( ::lAdjust .and. empty( ::hBitmap2 ), ::hPalette1,::hPalette2),;
                  ::hBitmap3, ::hPalette3, ::lPressed, ::lAdjust, ::lBorder,;
                  ::oPopup != nil,;
                  ::nClrPane, if ( ::cCaption == "...", ::cCaption,) , ::nLayout,;
                  If( ::oFont != nil, ::oFont:hFont, 0 ),;
                  If( ValType( ::nClrText ) == "B", Eval( ::nClrText, ::lMOver ), ::nClrText ), ::hDC,;
                  Upper( ::oWnd:ClassName() ) != "TBAR" )
      else
        hBmpOld = SelectObject( ::hDC, hBmp )
        nZeroZeroClr = GetPixel( ::hDC, 0, 0 )
        SelectObject( ::hDC, hBmpOld )
        nOldClr = SetBkColor( ::hDC, nRGB( 255, 255, 255 ) )
        TransBmp( hBmp, nBmpWidth, nBmpHeight, nZeroZeroClr, ::hDC,;
                     if( ::lAdjust, nAdjust, nBmpLeft + nAdjust ), ;
                     if( ::lAdjust, nAdjust, nBmpTop + nAdjust ),;
                     if (::lAdjust, ::nWidth, nBmpWidth ) ,;
                     if( ::lAdjust, ::nHeight, nBmpHeight ) )
        SetBkColor( ::hDC, nOldClr )
    endif

  else
        PalBtnPaint( ::hWnd, if( ::lMOver .and. !Empty( ::hBitmap4 ), ::hBitmap4, ::hBitmap1 ),;
                  if( ::lMOver .and. !Empty( ::hBitmap4 ), ::hPalette4, ::hPalette1 ),;
                  if ( ::lAdjust .and. empty( ::hBitmap2 ), ::hBitmap1,::hBitmap2 ),;
                  if ( ::lAdjust .and. empty( ::hBitmap2 ), ::hPalette1,::hPalette2),;
                  ::hBitmap3, ::hPalette3, ::lPressed, ::lAdjust, ::lBorder,;
                  ::oPopup != nil,;
                  ::nClrPane, if ( ::cCaption == "...", ::cCaption,) , ::nLayout,;
                  If( ::oFont != nil, ::oFont:hFont, 0 ),;
                  If( ValType( ::nClrText ) == "B", Eval( ::nClrText, ::lMOver ), ::nClrText ), ::hDC,;
                  Upper( ::oWnd:ClassName() ) != "TBAR" )
  endif

  if !empty( ::cCaption ) .and. ::cCaption != "..."
        nStyle   := nOr( if( ::nLayOut == 0, DT_CENTER,nLayOut), DT_WORDBREAK ,;
        if ( ::nLayOut%2 == 0, DT_VCENTER, DT_TOP ) )
        nClr = If( IsWindowEnabled( ::hWnd ), ::nClrText, CLR_HGRAY )
        SetTextColor( ::hDC, If( ValType( nClr ) == "B", Eval( nClr, ::lMOver ), nClr ) )
        SetBkMode( ::hDC, 1 )
        hOldFont = SelectObject( ::hDC, If( ::lBarBtn, ::oWnd:oFont:hFont, ::oFont:hFont ) )
        DrawText( ::hDC, ::cCaption,{nTxtTop+nAdjust, nTxtLeft+nAdjust, ::nHeight+nAdjust-4, nTxtRight+nAdjust},nStyle  )
        SelectObject( ::hDC, hOldFont )
        DeleteObject( hOldFont )
   endif

  if ::oPopup != nil
     nHeight = ::nHeight
     nWidth  = ::nWidth
     hDC     = ::hDC
     hBlackBrush = GetStockObject( 4 )
     hOldBrush = SelectObject( hDC, hBlackBrush )
     PolyPolygon( hDC, { { nWidth - 9 + If( ::lPressed, 1, 0 ), nHeight / 2 - 1 + If( ::lPressed, 1, 0 )},;
        { nWidth - 7 + If( ::lPressed, 1, 0 ), nHeight / 2 + 1 + If( ::lPressed, 1, 0 )},;
        { nWidth - 5 + If( ::lPressed, 1, 0 ), nHeight / 2 - 1 + If( ::lPressed, 1, 0 )},;
        { nWidth - 9 + If( ::lPressed, 1, 0 ), nHeight / 2 - 1 + If( ::lPressed, 1, 0 )} } )
     if ::lBorder .or. ::lPressed
        hDarkPen  = CreatePen( PS_SOLID, 1, GetSysColor( COLOR_BTNSHADOW ) )
        hLightPen = CreatePen( PS_SOLID, 1, GetSysColor( COLOR_BTNHIGHLIGHT ) )
        hOldPen = SelectObject( hDC, hLightPen )
        MoveTo( hDC, nWidth - 12 + If( ::lPressed, 1, 0 ), 1 )
        LineTo( hDC, nWidth - 12 + If( ::lPressed, 1, 0 ), nHeight - 1 )
        SelectObject( hDC, hDarkPen )
        MoveTo( hDC, nWidth - 13 + If( ::lPressed, 1, 0 ), 1 )
        LineTo( hDC, nWidth - 13 + If( ::lPressed, 1, 0 ), nHeight - 1 )
        SelectObject( hDC, hOldPen )
        DeleteObject( hDarkPen )
        DeleteObject( hLightPen )
     endif
     SelectObject( hDC, hOldBrush )
     DeleteObject( hBlackBrush )
  endif

  if ! IsWindowEnabled( ::hWnd ) .and. Empty( ::hBitmap3 )
     BtnDisable( ::hWnd, ::hDC )
  endif

  DEFAULT ::lFocused := .f. // XPP requirement

  if lAnd( GetWindowLong( ::hWnd, GWL_STYLE ), WS_TABSTOP ) .and. ::lFocused
     if ( nWidth := ::nWidth() ) > NO_FOCUSWIDTH
        lDlg = ( Upper( ::oWnd:ClassName() ) == "TDIALOG" )
        #ifdef __CLIPPER__
           if lDlg
              DrawFocusRect( ::hDC, 2, 2, ::nHeight() - 2, nWidth - 2 )
           else
              DrawFocusRect( ::hDC, 4, 4, ::nHeight() - 4, nWidth - 4 )
           endif
        #else
           DrawFocusRect( ::hDC, 2, 2, ::nHeight() - 4, nWidth - 4 )
        #endif
     endif
  endif

   ::DispEnd( aInfo )

return nil

//----------------------------------------------------------------------------//

METHOD KeyDown( nKey, nFlags ) CLASS TBtnBmp

   do case
      case nKey == VK_UP .or. nKey == VK_LEFT
           ::oWnd:GoPrevCtrl( ::hWnd )
      case nKey == VK_DOWN .or. nKey == VK_RIGHT
           ::oWnd:GoNextCtrl( ::hWnd )
   endcase


return Super:KeyDown( nKey, nFlags )

//----------------------------------------------------------------------------//

METHOD HandleEvent( nMsg, nWParam, nLParam ) CLASS TBtnBmp

   if nMsg == WM_MOUSELEAVE
      return ::MouseLeave( nHiWord( nLParam ), nLoWord( nLParam ), nWParam )
   endif

   if nMsg == WM_KEYUP
      if ::lPressed
         ::lPressed := .f.
         ::refresh()
         ::click()
      endif
   endif

return Super:HandleEvent( nMsg, nWParam, nLParam )

//----------------------------------------------------------------------------//

METHOD MouseLeave( nRow, nCol, nFlags ) CLASS TBtnBmp

   ::lMOver = .F.
   ::Refresh()

return nil


//----------------------------------------------------------------------------//

METHOD ShowPopup() CLASS TBtnBmp

   local oWnd

   if ::oPopup != nil
      if ::oWnd:oWnd != nil .and. Upper( ::oWnd:oWnd:Classname() ) == "TBAR"
         oWnd := ::oWnd:oWnd
      else
         oWnd := ::oWnd
      endif
      if GetClassName( GetParent( Self:hWnd ) ) != "TBAR"
         oWnd = oWndFromhWnd( GetParent( Self:hWnd ) )
      endif
      oWnd:NcMouseMove() // close the tooltip
      oWnd:oPopup = ::oPopup
      ::oPopup:Activate( ::nTop + ::nHeight(), ::nLeft, oWnd, .f. )
      oWnd:oPopup = nil
      ::Refresh()
   endif

return nil

//----------------------------------------------------------------------------//

METHOD SetColor( nClrText, nClrPane ) CLASS TBtnBmp

   local nOldClrText := ::nClrText

   Super:SetColor( nClrText, nClrPane )

   if ValType( nOldClrText ) == "B"
      ::nClrText = nOldClrText
   endif

return nil

//----------------------------------------------------------------------------//

static function CheckArray( aArray )
   local nI
   local aRet := {}
   if ValType( aArray ) == 'A' .and. ;
      Len( aArray ) == 1 .and. ;
      ValType( aArray[ 1 ] ) == 'A'
      aArray   := aArray[ 1 ]
   endif
   for nI = 1 to 4
      if nI > len( aArray )
         aadd( aRet, 0 )
      else
         aadd( aRet, if( empty( aArray[ nI ] ), 0, aArray[ nI ] ) )
      endif
   next

return aRet

#pragma BEGINDUMP

#include <hbapi.h>
#include <windows.h>

HB_FUNC( ROUNDBOX )

{
	 HDC hDC = ( HDC ) hb_parni( 1 );
   HBRUSH hBrush = (HBRUSH) GetStockObject( 5 );
   HBRUSH hOldBrush = (HBRUSH) SelectObject( hDC, hBrush );
   HPEN hPen ;
   HPEN hOldPen ;

   if( hb_pcount() > 8 )
   {
      hPen = CreatePen( PS_SOLID, hb_parnl( 9 ), (COLORREF)hb_parnl( 8 ));
   }
   else
   {
      hPen = CreatePen( PS_SOLID, 1, (COLORREF)hb_parnl( 8 ));
   }

   hOldPen = (HPEN) SelectObject( hDC, hPen );
   hb_retl( RoundRect(         hDC ,
                               hb_parni( 2 ),
                               hb_parni( 3 ),
                               hb_parni( 4 ),
                               hb_parni( 5 ),
                               hb_parni( 6 ),
                               hb_parni( 7 ) ) );

   SelectObject( hDC, hOldBrush );
   DeleteObject( hBrush );
   SelectObject( hDC, hOldPen );
   DeleteObject( hPen );


}

HB_FUNC( RESIZEBMP )
{
	 HBITMAP hbmpSrc =  ( HBITMAP ) hb_parnl( 1 );
   HBITMAP hbmpOldSrc, hbmpOldDest, hbmpNew;
   HDC     hdcSrc, hdcDest;
   BITMAP  bmp;
   LONG    w = hb_parnl( 2 );
   LONG    h = hb_parnl( 3 );

   hdcSrc = CreateCompatibleDC( NULL );
   hdcDest = CreateCompatibleDC( hdcSrc );

   GetObject( hbmpSrc, sizeof( BITMAP ), &bmp );

   hbmpOldSrc = ( HBITMAP ) SelectObject( hdcSrc, hbmpSrc );

   hbmpNew = CreateCompatibleBitmap( hdcSrc, w, h );

   hbmpOldDest = ( HBITMAP ) SelectObject( hdcDest, hbmpNew );

   StretchBlt( hdcDest, 0, 0, w, h, hdcSrc, 0, 0, bmp.bmWidth, bmp.bmHeight,
           SRCCOPY);

   SelectObject( hdcDest, hbmpOldDest );
   SelectObject( hdcSrc, hbmpOldSrc );

   DeleteDC( hdcDest );
   DeleteDC( hdcSrc );

   hb_retnl( ( LONG ) hbmpNew );
}

HB_FUNC ( CREATEROUNDRECTRGN )
{
  HWND  hWnd = ( HWND ) hb_parnl( 1 ) ;
  HRGN hRgn;
  RECT rct;

  GetClientRect( hWnd, &rct ) ;

  hRgn = CreateRoundRectRgn( rct.left, rct.top,
                             rct.right - rct.left,
                             rct.bottom - rct.top, hb_parnl( 2 ), hb_parnl( 3 ) ) ;

  hb_retnl ((long) hRgn);
}

HB_FUNC ( SETWINDOWRGN )
{
  INT iSuccess;

  iSuccess = SetWindowRgn ( (HWND) hb_parnl(1), (HRGN) hb_parnl(2), TRUE );

  hb_retni( iSuccess );
}

#pragma ENDDUMP