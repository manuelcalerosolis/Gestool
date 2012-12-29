#include "FiveWin.Ch"

#define LTGRAY_BRUSH    1
#define RT_BITMAP       2

#define OPAQUE          0
#define TRANSPARENT     1

#define COLOR_BTNFACE  15
#define COLOR_BTNTEXT  18

#define NO_FOCUSWIDTH  25

#de

#define SRCCOPY        13369376

#ifdef __XPP__
   #define Super ::TControl
   #define New _New
#endif

//----------------------------------------------------------------------------//

Function TestWebBnt()

   local oDlg
   local oOutLook
   local oWebBtn1
   local oWebBtn2
   local oWebBtn3
   local oBtn4
   local oFont       := TFont():New( "Ms Sans Serif", 0, -10, .f., .t. )
   local oFontOver   := TFont():New( "Ms Sans Serif", 0, -10, .f., .t., , , , , .t. )

   DEFINE WINDOW oDlg FROM 10, 10 TO 400, 600 ;
      PIXEL ;
      TITLE "Test de WebBtn" ;
      COLOR "W/BG"

   oOutLook := TWebBar():New(    10,;                         // nTop,;
                                 05,;                         // nLeft, ;
                                 140,;                        // nWidth,;
                                 200,;                        // nHeight, ;
                                 14,;                         // nCtlHeight ,;
                                 "WebBmp.bmp",;               // cBitmap, ;
                                 nil,;                        // cResBmp, ;
                                 Rgb( 255, 154, 49 ),;        // nClrFore, ;
                                 Rgb( 255, 154, 49 ), ;       // nClrBack, ;
                                 nil,;                        // nStyle, ;
                                 nil,;                        // oBrush, ;
                                 nil, ;                       // oFont, ;
                                 .t.,;                        // lPixel, ;
                                 nil,;                        // cMsg, ;
                                 oDlg )                       // oWnd, ;
                                                              // nHelpID, ;
                                                              // bRClick )

   oWebBtn1 := oOutLook:AddItem( "BMPESTADO3",;                      // cResName1, ;
                                 "BMPESTADO1",;                      // cResName2, ;
                                 nil,;                               // cBmpFile1, ;
                                 nil,;                               // cBmpFile2,;
                                 {|| msginfo("C") },;                // bAction, ;
                                 oOutLook,;                          // oBar, ;
                                 "Message",;                         // cMsg, ;
                                 nil,;                               // bWhen, ;
                                 .t.,;                               // lUpdate,;
                                 "Texto C" ,;                        // cPrompt, ;
                                 "RIGHT" ,;                          // cPad, ;
                                 oFont,;                             // oFont, ;
                                 oFontOver,;                         // oFontOver, ;
                                 Rgb( 255, 154, 49 ),;               // nClrText,;
                                 Rgb( 255, 154, 49 ),;               // nClrTextOver,
                                 Rgb( 255, 154, 49 ),;               // nClrPane, ;
                                 Rgb( 255, 154, 49 ),;               // nClrPaneOver,
                                 .f. )                               // lBorder )

   oWebBtn2 := oOutLook:AddItem( "BMPESTADO3",;                      // cResName1, ;
                                 "BMPESTADO1",;                      // cResName2, ;
                                 nil,;                               // cBmpFile1, ;
                                 nil,;                               // cBmpFile2,;
                                 {|| msginfo("B") },;                // bAction, ;
                                 oOutLook,;                          // oBar, ;
                                 "Message",;                         // cMsg, ;
                                 nil,;                               // bWhen, ;
                                 .t.,;                               // lUpdate,;
                                 "Texto B" ,;                        // cPrompt, ;
                                 "CENTER" ,;                         // cPad, ;
                                 oFont,;                             // oFont, ;
                                 oFontOver,;                         // oFontOver, ;
                                 Rgb( 0, 0, 0 ),;                    // nClrText,;
                                 Rgb( 0, 0, 0 ),;                    // nClrTextOver,
                                 Rgb( 255, 154, 49 ),;               // nClrPane, ;
                                 Rgb( 255, 154, 49 ),;               // nClrPaneOver,
                                 .f. )                               // lBorder )

   oWebBtn3 := oOutLook:AddItem( "BMPESTADO3",;                      // cResName1, ;
                                 "BMPESTADO1",;                      // cResName2, ;
                                 nil,;                               // cBmpFile1, ;
                                 nil,;                               // cBmpFile2,;
                                 {|| msginfo("A") },;                // bAction, ;
                                 oOutLook,;                          // oBar, ;
                                 "Message",;                         // cMsg, ;
                                 nil,;                               // bWhen, ;
                                 .t.,;                               // lUpdate,;
                                 "Texto A" ,;                        // cPrompt, ;
                                 "LEFT" ,;                           // cPad, ;
                                 oFont,;                             // oFont, ;
                                 oFontOver,;                         // oFontOver, ;
                                 Rgb( 0, 0, 0 ),;                    // nClrText,;
                                 Rgb( 0, 0, 0 ),;                    // nClrTextOver,
                                 Rgb( 255, 154, 49 ),;               // nClrPane, ;
                                 Rgb( 255, 154, 49 ),;               // nClrPaneOver,
                                 .f. )                               // lBorder )
   oDlg:bStart := {|| TestPaint( oWebBtn1, oWebBtn2, oWebBtn3 ) }

   ACTIVATE WINDOW oDlg

return nil

//---------------------------------------------------------------------------//

static function  TestPaint( oWebBtn1, oWebBtn2, oWebBtn3 )

   local n

   msginfo( "pon el indicador" )

   for n:= 1 to 10000000
      oWebBtn1:paint( n % 2 == 0 )
      oWebBtn2:paint( n % 2 == 0 )
      oWebBtn3:paint( n % 2 == 0 )
   next

return nil


//----------------------------------------------------------------------------//

CLASS TWebBtn FROM TControl

   DATA   bAction
   DATA   cAction   // A string description of the action
   DATA   lPressed, lCaptured, lAdjust, lGroup AS LOGICAL
   DATA   lWorking, lBtnUp, lBtnDown
   DATA   hBmpPal1, hBmpPal2, hBmpPal3
   DATA   cResName1, cResName2, cResName3
   DATA   cBmpFile1, cBmpFile2, cBmpFile3
   DATA   lProcessing AS LOGICAL INIT .f.
   DATA   lBorder AS LOGICAL INIT .t.
   DATA   oFontOver
   DATA   nClrTextOver
   DATA   nClrPaneOver
   DATA   nPad
   DATA   nStepBmp

   CLASSDATA lRegistered AS LOGICAL

   DATA   nDlgCode INIT DLGC_WANTALLKEYS

   METHOD New( nTop, nLeft, nWidth, nHeight,;
               cResName1, cResName2, cBmpFile1, cBmpFile2,;
               bAction, oWnd, cMsg, bWhen, lAdjust, lUpdate,;
               cPrompt, cPad, oFont, oFontOver, cResName3, cBmpFile3,;
               nClrText, nClrTextOver, nClrPane, nClrPaneOver, lBorder ) CONSTRUCTOR

   METHOD NewBar( nHeight, cResName1, cResName2, cBmpFile1, cBmpFile2,;
                  bAction, oWnd, cMsg, bWhen, lAdjust, lUpdate,;
                  cPrompt, cPad, oFont, oFontOver, cResName3, cBmpFile3,;
                  nClrText, nClrTextOver, nClrPane, nClrPaneOver, lBorder ) CONSTRUCTOR

   METHOD ReDefine( nId, cResName1, cResName2, cBmpFile1, cBmpFile2,;
                    cMsg, bAction, oBar, lAdjust, bWhen, lUpdate,;
                    cToolTip, cPrompt, oFont, oFontOver, cResName3,;
                    cBmpFile3, lBorder ) CONSTRUCTOR

   METHOD Click()
   METHOD Display() INLINE ::BeginPaint(), ::Paint(), ::EndPaint(), 0
   METHOD FreeBitmaps()

   METHOD GoUp() INLINE ::lPressed := ::lBtnDown := .f.,;
                        ::Refresh()
   METHOD cGenPRG()
   METHOD LButtonDown( nRow, nCol )
   METHOD LButtonUp( nRow, nCol )
   METHOD LoadBitmaps( cResName1, cResName2, cBmpFile1, cBmpFile2 )

   METHOD GotFocus( hCtlLost )

   METHOD Initiate( hDlg )

   METHOD KeyChar( nKey, nFlags )

   METHOD LostFocus()

   METHOD Paint()

   METHOD MouseMove( nRow, nCol, nKeyFlags )

   METHOD End() INLINE ( if( ::hWnd == 0, ::Destroy(), Super:End() ) )

   METHOD Destroy()

   METHOD SetFile( cBmpUpFile, cBmpDownFile )

   METHOD AdjText( cText, nBmpWidth )

   METHOD CleanBk()

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( nTop, nLeft, nWidth, nHeight,;
            cResName1, cResName2, cBmpFile1, cBmpFile2,;
            bAction, oWnd, cMsg, bWhen, lAdjust, lUpdate,;
            cPrompt, cPad, oFont, oFontOver, cResName3, cBmpFile3,;
            nClrText, nClrTextOver, nClrPane, nClrPaneOver, lBorder )  CLASS TWebBtn

   DEFAULT  cMsg           := " ", ;
            nWidth         := 20,;
            nHeight        := 20,;
            lAdjust        := .f.,;
            lUpdate        := .f.,;
            oWnd           := GetWndDefault(), ;
            nClrText       := GetSysColor( COLOR_BTNTEXT ),;
            nClrTextOver   := GetSysColor( COLOR_BTNTEXT ),;
            nClrPane       := GetSysColor( COLOR_BTNFACE ),;
            nClrPaneOver   := GetSysColor( COLOR_BTNFACE ),;
            cPad           := "LEFT" ,;
            lBorder        := .t.,;
            oFont          := TFont():New( "Verdana", 0, -10, .f., .t. ),;
            oFontOver      := TFont():New( "Verdana", 0, -10, .f., .t., , , , , .t. )

   ::nStyle    = nOR( WS_CHILD, WS_VISIBLE,; // WS_CLIPSIBLINGS
                      If( lBorder, WS_BORDER, 0 ),;
                      If( Upper( oWnd:ClassName() ) != "TBAR", WS_TABSTOP, 0 ) )
   ::nId          = ::GetNewId()
   ::oWnd         = oWnd
   ::bAction      = bAction
   ::cMsg         = cMsg
   ::nTop         = nTop
   ::nLeft        = nLeft
   ::nBottom      = nTop + nHeight - 1
   ::nRight       = nLeft + nWidth - 1
   ::lPressed     = .f.
   ::lWorking     = .f.
   ::lAdjust      = lAdjust
   ::lDrag        = .f.
   ::lCaptured    = .f.
   ::bWhen        = bWhen
   ::lUpdate      = lUpdate
   ::l97Look      = !lBorder
   ::lBorder      = lBorder
   ::lBtnDown     = .f.

   ::hBmpPal1     = 0
   ::hBmpPal2     = 0
   ::cCaption     = cPrompt
   ::nPad         = Max( aScan( {"LEFT", "CENTER", "RIGHT" }, Upper( cPad ) ), 1 )
   ::oFont        = oFont
   ::oFontOver    = oFontOver

   ::nClrText     = nClrText
   ::nClrTextOver = nClrTextOver
   ::nClrPane     = nClrPane
   ::nClrPaneOver = nClrPaneOver

   ::oCursor      = TCursor():New( , "HAND" )

   ::nStepBmp     = 15

   #ifdef __XPP__
      DEFAULT ::lRegistered := .f.
      ::lProcessing = .f.
   #endif

   ::Register( nOR( CS_VREDRAW, CS_HREDRAW ) )

   if ! Empty( oWnd:hWnd )
      ::Create()
      ::SetColor( ::nClrText, ::nClrPane )
      oWnd:AddControl( Self )
   else
      oWnd:DefControl( Self )
   endif

   ::LoadBitmaps( cResName1, cResName2, cBmpFile1, cBmpFile2,;
                  cResName3, cBmpFile3 )

return Self

//----------------------------------------------------------------------------//

METHOD NewBar( cResName1, cResName2, cBmpFile1, cBmpFile2,;
               bAction, oBar, cMsg, bWhen, lAdjust, lUpdate,;
               cPrompt, cPad, oFont, oFontOver, cResName3, cBmpFile3,;
               nClrText, nClrTextOver, nClrPane, nClrPaneOver, lBorder,;
               cToolTip, bDrop )  CLASS TWebBtn

   DEFAULT  cMsg           := " ", ;
            lUpdate        := .f.,;
            oBar           := GetWndDefault(), ;
            nClrText       := Rgb( 255, 154, 49 ),;
            nClrTextOver   := Rgb( 255, 154, 49 ),;
            nClrPane       := GetSysColor( COLOR_BTNFACE ),;
            nClrPaneOver   := GetSysColor( COLOR_BTNFACE ),;
            cPad           := "LEFT" ,;
            lBorder        := .t.,;
            cToolTip       := nil ,;
            bDrop          := nil ,;
            oFont          := TFont():New( "Verdana", 0, -10, .f., .t. ),;
            oFontOver      := TFont():New( "Verdana", 0, -10, .f., .t., , , , , .t. )

   ::nStyle       = nOR( If( lBorder, WS_BORDER, 0 ), WS_CHILD, WS_VISIBLE )
   ::l97Look      = !lBorder
   ::nId          = ::GetNewId()
   ::oWnd         = oBar
   ::bAction      = bAction
   ::cMsg         = cMsg
   ::nTop         = 0
   ::nLeft        = 0
   ::nBottom      = oBar:nCtlHeight
   ::nRight       = oBar:nWidth - 2
   ::lCaptured    = .f.
   ::lWorking     = .f.
   ::lDrag        = .f.
   ::lAdjust      = lAdjust
   ::lGroup       = .f.
   ::bWhen        = bWhen
   ::cToolTip     = cToolTip
   ::bDropOver    = bDrop
   ::cResName1    = cResName1
   ::cResName2    = cResName2
   ::cBmpFile1    = cBmpFile1
   ::cBmpFile2    = cBmpFile2
   ::bAction      = bAction
   ::cCaption     = cPrompt
   ::oFont        = oFont
   ::oFontOver    = oFontOver
   ::lBorder      = lBorder

   ::hBmpPal1     = 0
   ::hBmpPal2     = 0
   ::cCaption     = cPrompt
   ::nPad         = Max( aScan( {"LEFT", "CENTER", "RIGHT" }, Upper( cPad ) ), 1 )
   ::oFont        = oFont
   ::oFontOver    = oFontOver

   ::nClrText     = nClrText
   ::nClrTextOver = nClrTextOver
   ::nClrPane     = nClrPane
   ::nClrPaneOver = nClrPaneOver

   ::oCursor      = TCursor():New( , "HAND" )

   #ifdef __XPP__
      DEFAULT ::lRegistered := .f.
      ::lProcessing = .f.
   #endif

   ::Register( nOR( CS_VREDRAW, CS_HREDRAW ) )

   ::Create()
   oBar:Add( Self )
   ::SetColor( ::nClrText, ::nClrPane )

   ::LoadBitmaps( cResName1, cResName2, cBmpFile1, cBmpFile2,;
                  cResName3, cBmpFile3 )

return Self

//----------------------------------------------------------------------------//

METHOD ReDefine( nId, cResName1, cResName2, cBmpFile1, cBmpFile2, cMsg,;
                 bAction, oBar, lAdjust, bWhen, lUpdate, cToolTip,;
                 cPrompt, oFont, cResName3, cBmpFile3, lBorder ) CLASS TWebBtn

   DEFAULT cMsg := "", lAdjust := .f., lUpdate := .f., lBorder := .t.

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

   ::hBmpPal1  = 0
   ::hBmpPal2  = 0

   ::Register( nOR( CS_VREDRAW, CS_HREDRAW ) )

   oBar:DefControl( Self )

   ::LoadBitmaps( cResName1, cResName2, cBmpFile1, cBmpFile2,;
                  cResName3, cBmpFile3 )

return Self

//----------------------------------------------------------------------------//

METHOD Click() CLASS TWebBtn

   if ! ::lProcessing
      ::lProcessing = .t.

      if ::bAction != nil
         Eval( ::bAction, Self )
      endif

      Super:Click()         // keep it here, the latest!
      ::lProcessing = .f.
   endif

return nil

//----------------------------------------------------------------------------//

METHOD GotFocus( hCtlLost ) CLASS TWebBtn

return Super:GotFocus()

//----------------------------------------------------------------------------//

METHOD Initiate( hDlg ) CLASS TWebBtn

   ::SetColor( ::nClrtext, ::nClrPane )

return Super:Initiate( hDlg )

//----------------------------------------------------------------------------//

METHOD KeyChar( nKey, nFlags ) CLASS TWebBtn

   if nKey == VK_RETURN .or. nKey == VK_SPACE
      ::Click()
   else
      return Super:KeyChar( nKey, nFlags )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD LostFocus() CLASS TWebBtn

   local nWidth

   if ::l97Look .and. ::lBorder
      ReleaseCapture()
      ::lBorder := .f.
      ::Refresh()
   endif

return Super:LostFocus()

//----------------------------------------------------------------------------//

METHOD cGenPRG() CLASS TWebBtn

   local cPrg := ""

   cPrg += CRLF + CRLF + "   DEFINE BTNBMP OF oBar " + ;
              'ACTION MsgInfo( "Not defined yet" )'

return cPrg

//----------------------------------------------------------------------------//

METHOD LButtonDown( nRow, nCol ) CLASS TWebBtn

   if ::oDragCursor != nil
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

METHOD LButtonUp( nRow, nCol )  CLASS TWebBtn

   local lClick := IsOverWnd( ::hWnd, nRow, nCol )

   if ::oDragCursor != nil
      return Super:LButtonUp( nRow, nCol )
   endif

   ::lBtnUp  = .t.

   if ! ::lWorking
      if ::lCaptured
         ::lCaptured = .f.
         ReleaseCapture()
         if lClick
            ::Click()
         endif
      endif
   endif

return 0

//----------------------------------------------------------------------------//

METHOD Destroy() CLASS TWebBtn

   ::FreeBitmaps()

   ::oFont:End()
   ::oFontOver:End()

   Super:Destroy()

return 0

//----------------------------------------------------------------------------//

METHOD SetFile( cBmpUpFile, cBmpDownFile ) CLASS TWebBtn

   ::FreeBitmaps()
   ::LoadBitmaps( nil, nil, cBmpUpFile, cBmpDownFile )
   ::Refresh()

return nil

//----------------------------------------------------------------------------//

METHOD FreeBitmaps() CLASS TWebBtn

   if ::hBmpPal1 != 0
      DeleteObject( ::hBmpPal1 )
   endif

   if ::hBmpPal2 != 0
      DeleteObject( ::hBmpPal2 )
   endif

   if ::hBmpPal3 != 0
      DeleteObject( ::hBmpPal3 )
   endif

   ::hBmpPal1 = 0
   ::hBmpPal2 = 0
   ::hBmpPal3 = 0

return nil

//----------------------------------------------------------------------------//

METHOD LoadBitmaps( cResName1, cResName2, cBmpFile1, cBmpFile2,;
                    cResName3, cBmpFile3 ) CLASS TWebBtn

    if ! Empty( cResName1 )
      ::hBmpPal1 := PalBmpLoad( cResName1 )[1]
   endif

   if ! Empty( cResName2 )
      ::hBmpPal2 := PalBmpLoad( cResName2 )[1]
   endif

   if ! Empty( cResName3 )
      ::hBmpPal3 := PalBmpLoad( cResName3 )[1]
   endif

   if ! Empty( cBmpFile1 )
      if File( cBmpFile1 )
         ::cBmpFile1 := cBmpFile1
         ::hBmpPal1  := PalBmpRead( ::GetDC(), cBmpFile1 )
         ::ReleaseDC()
      endif
   endif

   if ! Empty( cBmpFile2 )
      if File( cBmpFile2 )
         ::hBmpPal2  := PalBmpRead( ::GetDC(), cBmpFile2 )
         ::ReleaseDC()
      endif
   endif

   if ! Empty( cBmpFile3 )
      if File( cBmpFile3 )
         ::hBmpPal3  := PalBmpRead( ::GetDC(), cBmpFile3 )
         ::ReleaseDC()
      endif
   endif

   if ! Empty( ::hBmpPal1 )
      PalBmpNew( ::hWnd, ::hBmpPal1 )
   endif

   if ! Empty( ::hBmpPal2 )
      PalBmpNew( ::hWnd, ::hBmpPal2 )
   endif

   if ! Empty( ::hBmpPal3 )
      PalBmpNew( ::hWnd, ::hBmpPal3 )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD MouseMove( nRow, nCol, nKeyFlags ) CLASS TWebBtn

   if ::oDragCursor != nil
      return Super:MouseMove( nRow, nCol, nKeyFlags )
   endif

   Super:MouseMove( nRow, nCol, nKeyFlags )

   if IsOverWnd( ::hWnd, nRow, nCol )
      if !::lCaptured
         ::lCaptured := .t.
         ::Capture()
         ::Paint( .t. )
      end if
   else
      ::lCaptured := .f.
      ReleaseCapture()
      ::Paint( .f. )
   end if

   ::oWnd:SetMsg( ::cMsg )

return 0

//----------------------------------------------------------------------------//

METHOD Paint( lOver ) CLASS TWebBtn

   local hOldFont
   local nRow
   local nCol
   local nWidth
   local nHeight
   local nBmpWidth   := nbmpwidth( ::hBmpPal1 )
   local nBmpHeight  := nBmpHeight( ::hBmpPal1 )
   local cText       := ::AdjText( ::cCaption, nBmpWidth )

   DEFAULT lOver  := .f.

   if ! IsWindowEnabled( ::hWnd )
      BtnDisabled( ::hWnd )
   endif

   if ! Empty( ::cCaption )
      if ::oFont == nil
         ::oFont = ::oWnd:oFont
      endif

      nWidth  = GetTextWidth( ::hDC, cText, ::oFont:hFont )
      nHeight = ::oFont:nHeight
      nRow    = ( ::nHeight / 2 ) - ( nHeight / 2 ) - 1

      do case
      case ::nPad == 1 // LEFT
         nCol   := ( nBmpWidth + ::nStepBmp )
      case ::nPad == 2 // CENTER
         nCol   := ( ( ( ::nWidth - nBmpWidth - ::nStepBmp ) / 2 ) - ( nWidth / 2 ) ) + nBmpWidth + ::nStepBmp
      case ::nPad == 3 // RIGHT
         nCol   := ( ::nWidth - nWidth ) - ::nStepBmp
      end case

      ::GetDC()

      ::CleanBk()

      SetBkMode( ::hDC, TRANSPARENT )

      if lOver
         PalBmpDraw( ::hDC, nRow, 0, ::hBmpPal2, nBmpWidth, nBmpHeight,, .t., ::nClrPane )
         hOldFont = SelectObject( ::hDC, ::oFontOver:hFont )
         SetTextColor( ::hDC, ::nClrTextOver )
      else
         PalBmpDraw( ::hDC, nRow, 0, ::hBmpPal1, nBmpWidth, nBmpHeight,, .t., ::nClrPane )
         hOldFont = SelectObject( ::hDC, ::oFont:hFont )
         SetTextColor( ::hDC, ::nClrText )
      end if

      TextOut( ::hDC, nRow, nCol, cText )
      SelectObject( ::hDC, hOldFont )

      SetBkMode( ::hDC, OPAQUE )

      ::ReleaseDC()

   endif

return nil

//----------------------------------------------------------------------------//

METHOD AdjText( cText, nBmpWidth )

   local n
   local nLen
   local nWidth

   if nBmpWidth < 0
      nBmpWidth   := 0
   end if

   nWidth         := ::nWidth - nBmpWidth - ( ::nStepBmp * 2 )

   if GetTextWidth( ::hDC, cText, ::oFont:hFont ) < nWidth
      return cText
   endif

   nLen           := len( cText )

   while GetTextWidth( ::hDC, cText + "...", ::oFont:hFont ) > nWidth
      cText := substr( cText, 1, --nLen )
   enddo

return cText + "..."

//----------------------------------------------------------------------------//

METHOD CleanBk()

   local hDCMem
   local hBmp
   local hOldBmp

   hDCMem  := CreateCDC( ::hDC )
   hBmp    := nLoWord( ::oWnd:hBmpPal )         // Referancia al bitmap de la clase contenedora
   hOldBmp := SelectObject( hDCMem, hBmp )      // Seleccionamos el objeto

   BitBlt( ::hDC, 0, 0, ::nWidth, ::nHeight, hDCMem, ::nLeft, ::nTop, SRCCOPY )

   SelectObject( hDCMem, hOldBmp )
   DeleteDC( hDCMem )

return nil

//----------------------------------------------------------------------------//