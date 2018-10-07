#include "FiveWin.Ch"

#define LTGRAY_BRUSH    1
#define RT_BITMAP       2

#define OPAQUE          0
#define TRANSPARENT     1

#define COLOR_BTNFACE   15
#define COLOR_BTNTEXT   18

#define NO_FOCUSWIDTH   25

#define SRCCOPY         13369376

#ifdef __XPP__
   #define New _New
#endif

//----------------------------------------------------------------------------//

CLASS TWebBtn FROM TControl

   CLASSDATA lRegistered   AS LOGICAL
   CLASSDATA aBitMaps      AS ARRAY INIT {}

   DATA   bAction
   DATA   cAction
   DATA   lPressed
   DATA   lCaptured
   DATA   lBeginGrp        AS LOGICAL
   DATA   lWorking
   DATA   lBtnUp, lBtnDown
   DATA   hBmpPal1, hBmpPal2, hBmpPal3
   DATA   cResName1, cResName2, cResName3
   DATA   cBmpFile1, cBmpFile2, cBmpFile3
   DATA   lProcessing      AS LOGICAL INIT   .f.
   DATA   lBorder          AS LOGICAL INIT   .f.
   DATA   oFontOver
   DATA   nClrTextOver
   DATA   nClrPaneOver
   DATA   nClrBTop
   DATA   nClrBBot
   DATA   nClrBTopOver
   DATA   nClrBBotOver
   DATA   nPad
   DATA   nStepBmp         AS NUMERIC  INIT  16
   DATA   bMenu
   DATA   lMenu            AS LOGIC    INIT  .f.
   DATA   lIsOverMenu      AS LOGIC
   DATA   lOpnGroup        AS LOGIC    INIT  .f.
   DATA   lInGroup         AS LOGIC    INIT  .f.
   DATA   lSelect          AS LOGIC    INIT  .f.
   DATA   lNowSelect       AS LOGIC    INIT  .f.
   DATA   lTransparent     AS LOGIC    INIT  .f.
   DATA   lSingleLine      AS LOGIC    INIT  .t.

   DATA   nDlgCode         INIT DLGC_WANTALLKEYS

   METHOD New( nTop, nLeft, nWidth, nHeight, cResName1, cResName2,;
               cBmpFile1, cBmpFile2, bAction, oWnd, cMsg, bWhen,;
               lUpdate, bSetGet, cPad, oFont, oFontOver, cResName3,;
               cBmpFile3, nClrText, nClrTextOver, nClrPane,;
               nClrPaneOver, lBorder, bMenu, oGroup, lSelect ) CONSTRUCTOR

   METHOD NewBar( cResName1, cResName2, cBmpFile1, cBmpFile2,;
                  bAction, oBar, cMsg, bWhen, lUpdate,;
                  cPrompt, cPad, oFont, oFontOver, cResName3, cBmpFile3,;
                  nClrText, nClrTextOver, nClrPane, nClrPaneOver, lBorder,;
                  cToolTip, bDrop, bMenu, lBeginGrp, oGroup ) CONSTRUCTOR

   METHOD ReDefine(  nId, cResName1, cResName2, cBmpFile1, cBmpFile2,;
                     bAction, oWnd, cMsg, bWhen, lUpdate,;
                     bSetGet, cPad, oFont, oFontOver, cResName3, cBmpFile3,;
                     nClrText, nClrTextOver, nClrPane, nClrPaneOver, lBorder,;
                     cToolTip, bDrop, bMenu, lBeginGrp, oBrush ) CONSTRUCTOR

   METHOD Click( lMenu )

   METHOD Display() INLINE ::BeginPaint(), ::Paint(), ::EndPaint(), 0

   METHOD FreeBitmaps()

   METHOD HideBitmaps()

   METHOD GoDown() INLINE ::lPressed := ::lBtnDown := .t., ::Refresh()

   METHOD GoUp() INLINE ::lPressed := ::lBtnDown := .f., ::Refresh()

   METHOD LButtonDown( nRow, nCol )

   METHOD LButtonUp( nRow, nCol )

   METHOD LoadBmp( cResName1, cResName2, cBmpFile1, cBmpFile2 )

   METHOD GotFocus( hCtlLost )

   METHOD Initiate( hDlg )

   METHOD KeyChar( nKey, nFlags )

   METHOD LostFocus()

   METHOD EraseBkGnd( hDC ) INLINE 1

   METHOD Paint()

   METHOD MouseMove( nRow, nCol, nKeyFlags )

   METHOD Toggle()

   METHOD SetText( cText ) INLINE ;
                    (   if ( ::lWhen(), ::cCaption := cValToChar( cText ), ::cCaption := "" ),;
                        SetWindowText( ::hWnd, ::cCaption ),;
                        ::Refresh() )

   METHOD cText( cText )   SETGET

   METHOD End() INLINE ( ::Destroy(), ::Super:End() ) 

   METHOD VarGet()      INLINE   ( ::cCaption )

   METHOD Destroy()

   METHOD ShowPaint()      INLINE ( ::Show(), ::Paint() )

   METHOD SetTransparent() INLINE ( ::lTransparent := .t. )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( nTop, nLeft, nWidth, nHeight, cResName1, cResName2,;
            cBmpFile1, cBmpFile2, bAction, oWnd, cMsg, bWhen,;
            lUpdate, bSetGet, cPad, oFont, oFontOver, cResName3,;
            cBmpFile3, nClrText, nClrTextOver, nClrPane,;
            nClrPaneOver, lBorder, bMenu, oGroup, lSelect )  CLASS TWebBtn

   DEFAULT  cMsg           := " ", ;
            nWidth         := 20,;
            nHeight        := 20,;
            lUpdate        := .f.,;
            oWnd           := GetWndDefault(), ;
            nClrText       := GetSysColor( COLOR_BTNTEXT ),;
            nClrTextOver   := GetSysColor( COLOR_BTNTEXT ),;
            nClrPane       := if( oWnd != nil, oWnd:nClrPane, GetSysColor( COLOR_BTNFACE ) ),;
            nClrPaneOver   := if( oWnd != nil, oWnd:nClrPane, GetSysColor( COLOR_BTNFACE ) ),;
            cPad           := "LEFT" ,;
            lBorder        := .f.,;
            oFont          := TFont():New( "Verdana", 0, -10, .f., .t. ),;
            oFontOver      := TFont():New( "Verdana", 0, -10, .f., .t., , , , , .t. ),;
            oGroup         := nil,;
            lSelect        := .f.

   ::nStyle       = nOR( WS_CHILD, WS_VISIBLE, If( Upper( oWnd:ClassName() ) != "TWEBBAR", WS_TABSTOP, 0 ) )
   ::nId          = ::GetNewId()
   ::oWnd         = oWnd
   ::bAction      = bAction
   ::bMenu        = bMenu
   ::cMsg         = cMsg
   ::nTop         = nTop
   ::nLeft        = nLeft
   ::nBottom      = nTop + nHeight - 1
   ::nRight       = nLeft + nWidth - 1
   ::lPressed     = .f.
   ::lWorking     = .f.
   ::lDrag        = .f.
   ::lCaptured    = .f.
   ::bWhen        = bWhen
   ::lUpdate      = lUpdate
   ::lBorder      = lBorder
   ::lBtnDown     = .f.

   ::hBmpPal1     = 0
   ::hBmpPal2     = 0

   if ValType( bSetGet ) == "C"
      ::cCaption  = bSetGet
   elseif ValType( bSetGet ) == "B" .and. ::lWhen()
      ::cCaption  = cValToChar( Eval( bSetGet ) )
	else
      ::cCaption  = ""
	endif

   ::bSetGet      = bSetGet
   ::nPad         = Max( aScan( {"LEFT", "CENTER", "RIGHT" }, Upper( cPad ) ), 1 )
   ::oFont        = oFont
   ::oFontOver    = oFontOver

   ::nClrText     = nClrText
   ::nClrTextOver = nClrTextOver
   ::nClrPane     = nClrPane
   ::nClrPaneOver = nClrPaneOver
   ::nClrBTop     = nClrText
   ::nClrBBot     = nClrText
   ::nClrBTopOver = nClrText
   ::nClrBBotOver = nClrText

   ::oCursor      = TCursor():New( , "HAND" )
   ::oBrush       = TBrush():New( "NULL" )

   ::lSelect      = lSelect
   ::lNowSelect   = .f.

   #ifdef __XPP__
      DEFAULT ::lRegistered := .f.
      ::lProcessing = .f.
   #endif

   ::Register( nOR( CS_VREDRAW, CS_HREDRAW ) )

   if ! Empty( oWnd:hWnd )
      ::Create()
      // ::SetColor( ::nClrText, ::nClrPane )
      oWnd:AddControl( Self )
   else
      oWnd:DefControl( Self )
   endif

   ::LoadBmp( cResName1, cResName2, cBmpFile1, cBmpFile2, cResName3, cBmpFile3 )

RETURN Self

//----------------------------------------------------------------------------//

METHOD NewBar( cResName1, cResName2, cBmpFile1, cBmpFile2,;
               bAction, oWnd, cMsg, bWhen, lUpdate, bSetGet,;
               cPad, oFont, oFontOver, cResName3, cBmpFile3,;
               nClrText, nClrTextOver, nClrPane, nClrPaneOver, lBorder,;
               cToolTip, bDrop, bMenu, lBeginGrp, lOpened, oGroup, lSelect ) CLASS TWebBtn

   DEFAULT  cMsg           := " ", ;
            lUpdate        := .f.,;
            oWnd           := GetWndDefault(), ;
            nClrText       := Rgb( 255, 154, 49 ),;
            nClrTextOver   := Rgb( 255, 255, 255 ),;
            nClrPane       := GetSysColor( COLOR_BTNFACE ),;
            nClrPaneOver   := GetSysColor( COLOR_BTNFACE ),;
            cPad           := "LEFT" ,;
            lBorder        := .f.,;
            oFont          := TFont():New( "Verdana", 0, -10, .f., .f. ),;
            oFontOver      := TFont():New( "Verdana", 0, -10, .f., .f., , , , , .t. ),;
            lBeginGrp      := .f.,;
            lOpened        := .t.,;
            oGroup         := nil,;
            lSelect        := .f.

   ::nStyle                := nOR( WS_CHILD, WS_VISIBLE )
   ::nId                   := ::GetNewId()
   ::oWnd                  := oWnd
   ::bAction               := bAction
   ::bMenu                 := bMenu
   ::cMsg                  := cMsg
   ::nTop                  := 0
   ::nLeft                 := oWnd:nLeftMargin
   ::nBottom               := oWnd:nCtlHeight
   ::nRight                := oWnd:nWidth - oWnd:nLeftMargin - oWnd:nRightMargin - 2
   ::lCaptured             := .f.
   ::lWorking              := .f.
   ::lDrag                 := .f.
   ::lBeginGrp             := lBeginGrp
   ::bWhen                 := bWhen
   ::cToolTip              := cToolTip
   ::bDropOver             := bDrop
   ::cResName1             := cResName1
   ::cResName2             := cResName2
   ::cBmpFile1             := cBmpFile1
   ::cBmpFile2             := cBmpFile2
   ::bAction               := bAction
   ::oFont                 := oFont
   ::oFontOver             := oFontOver
   ::lBorder               := lBorder
   ::lActive               := lOpened

   if hb_ischar( bSetGet ) 
      ::cCaption           := bSetGet
   elseif hb_isblock( bSetGet ) .and. ::lWhen()
      ::cCaption           := cValToChar( Eval( bSetGet ) )
	else
      ::cCaption           := ""
	endif

   ::bSetGet               := bSetGet
   ::hBmpPal1              := 0
   ::hBmpPal2              := 0
   ::nPad                  := Max( aScan( {"LEFT", "CENTER", "RIGHT" }, Upper( cPad ) ), 1 )

   ::nClrText              := nClrText
   ::nClrTextOver          := nClrTextOver
   ::nClrPane              := nClrPane
   ::nClrPaneOver          := nClrPaneOver
   ::nClrBTop              := nClrText
   ::nClrBBot              := nClrText
   ::nClrBTopOver          := nClrText
   ::nClrBBotOver          := nClrText

   ::oCursor               := TCursor():New( , "HAND" )
   ::oBrush                := TBrush():New( "NULL" )

   ::lSelect               := lSelect

   ::Register( nOR( CS_VREDRAW, CS_HREDRAW ) )

   ::Create()

   oWnd:Add( Self )

   if !empty( oGroup )
      oGroup:AddControl( Self )
      ::lInGroup           := .t.
   end if

   ::LoadBmp( cResName1, cResName2, cBmpFile1, cBmpFile2, cResName3, cBmpFile3 )

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD ReDefine(  nId, cResName1, cResName2, cBmpFile1, cBmpFile2,;
                  bAction, oWnd, cMsg, bWhen, lUpdate, bSetGet, cPad, ;
                  oFont, oFontOver, cResName3, cBmpFile3, nClrText, nClrTextOver,;
                  nClrPane, nClrPaneOver, lBorder, cToolTip, bDrop, bMenu,;
                  lBeginGrp, oBrush, lOpened, oGroup, lSelect ) CLASS TWebBtn

   DEFAULT  cMsg           := " ",;
            lUpdate        := .f.,;
            lBorder        := .f.,;
            oWnd           := GetWndDefault(),;
            oFont          := TFont():New( GetSysFont(), 0, -12, .f., .f. ),;
            oFontOver      := TFont():New( GetSysFont(), 0, -12, .f., .f., , , , , .t. ),;
            cPad           := "LEFT" ,;
            nClrText       := GetSysColor( COLOR_BTNTEXT ),;
            nClrTextOver   := GetSysColor( COLOR_BTNTEXT ),;
            nClrPane       := if( oWnd != nil, oWnd:nClrPane, GetSysColor( COLOR_BTNFACE ) ),;
            nClrPaneOver   := if( oWnd != nil, oWnd:nClrPane, GetSysColor( COLOR_BTNFACE ) ),;
            oBrush         := TBrush():New( "NULL" )

   ::nId          := nId
   ::oWnd         := oWnd
   ::hWnd         := 0
   ::bAction      := bAction
   ::bMenu        := bMenu
   ::cMsg         := cMsg
   ::lPressed     := .f.
   ::lCaptured    := .f.
   ::lWorking     := .f.
   ::lDrag        := .f.
   ::lTransparent := .f.
   ::oFont        := oFont
   ::oFontOver    := oFontOver
   ::nPad         := Max( aScan( {"LEFT", "CENTER", "RIGHT" }, Upper( cPad ) ), 1 )
   ::nClrText     := nClrText
   ::nClrTextOver := nClrTextOver
   ::nClrPane     := nClrPane
   ::nClrPaneOver := nClrPaneOver
   ::bWhen        := bWhen
   ::lUpdate      := lUpdate
   ::cToolTip     := cToolTip
   ::lBorder      := lBorder
   ::lBtnDown     := .f.
   ::oCursor      := TCursor():New( , "HAND" )
   ::nClrBTop     := nClrText
   ::nClrBBot     := nClrText
   ::nClrBTopOver := nClrText
   ::nClrBBotOver := nClrText

   if ValType( bSetGet ) == "C"
      ::cCaption  := bSetGet
   elseif ValType( bSetGet ) == "B" .and. ::lWhen()
      ::cCaption  := cValToChar( Eval( bSetGet ) )
	else
      ::cCaption  := ""
	endif

   ::bSetGet      := bSetGet
   ::hBmpPal1     := 0
   ::hBmpPal2     := 0

   if ::oFont != nil
      ::SetFont( ::oFont )
   else
      ::SetFont( ::oWnd:oFont )
   endif

   ::Register( nOR( CS_VREDRAW, CS_HREDRAW ) )

   ::LoadBmp( cResName1, cResName2, cBmpFile1, cBmpFile2, cResName3, cBmpFile3 )

   oWnd:DefControl( Self )

   if !empty( ::oBrush )
      ::oBrush:End()
   endif

   ::oBrush       := oBrush

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD Click( lMenu ) CLASS TWebBtn

   DEFAULT lMenu        := .f.

   if !::lProcessing
      ::lProcessing     := .t.

      if ::bMenu != nil .and. lMenu
         Eval( ::bMenu, Self )
      elseif ::bAction != nil
         Eval( ::bAction, if( !Empty( ::Cargo ), ::Cargo, Self ) )
      endif

      if ::lSelect
         if ::oWnd != nil .and. ::oWnd:ClassName() == "TWEBBAR"
            ::oWnd:Reset()
         end if
         ::lNowSelect   := .t.
         if ::oWnd != nil .and. ::oWnd:ClassName() == "TWEBBAR"
            ::oWnd:GetOption()
         end if
      end if

      ::Super:Click()         // keep it here, the latest!
      ::lProcessing     := .f.
   endif

RETURN nil

//----------------------------------------------------------------------------//

METHOD GotFocus( hCtlLost ) CLASS TWebBtn

RETURN ::Super:GotFocus()

//----------------------------------------------------------------------------//

METHOD Initiate( hDlg ) CLASS TWebBtn

   LOCAL aRect

   ::Super:Initiate( hDlg )

   if ! Empty( ::cCaption )
      SetWindowText( ::hWnd, ::cCaption )
   else
      ::cCaption  := GetWindowText( ::hWnd )
   endif

   aRect          := GetCoors( ::hWnd )

   ::nTop         := aRect[1]
   ::nLeft        := aRect[2]
   ::nBottom      := aRect[3]
   ::nRight       := aRect[4]

RETURN nil

//----------------------------------------------------------------------------//

METHOD KeyChar( nKey, nFlags ) CLASS TWebBtn

   if nKey == VK_RETURN .or. nKey == VK_SPACE
      ::Click()
   else
      RETURN ::Super:KeyChar( nKey, nFlags )
   endif

RETURN nil

//----------------------------------------------------------------------------//

METHOD LostFocus() CLASS TWebBtn

   if ::lCaptured
      ::lCaptured = .f.
      ReleaseCapture()
   end if

   ::Refresh()

RETURN ::Super:LostFocus()

//----------------------------------------------------------------------------//

METHOD LButtonDown( nRow, nCol ) CLASS TWebBtn

   if ::oDragCursor != nil
      RETURN ::Super:LButtonDown( nRow, nCol )
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

RETURN 0

//----------------------------------------------------------------------------//

METHOD LButtonUp( nRow, nCol )  CLASS TWebBtn

   local lClick := IsOverWnd( ::hWnd, nRow, nCol )

   if ::oDragCursor != nil
      RETURN ::Super:LButtonUp( nRow, nCol )
   endif

   ::lBtnUp  = .t.

   if ! ::lWorking
      if ::lCaptured
         ::lCaptured = .f.
         ReleaseCapture()
         if lClick
            ::Click( nCol > ::nRight - ::nStepBmp )
         endif
      endif
   endif

RETURN 0

//----------------------------------------------------------------------------//

METHOD Destroy() CLASS TWebBtn

   // if !Empty( ::oFont )
   //    ::oFont:end()
   // end if 

   // if !Empty( ::oFontOver )
   //    ::oFontOver:end()
   // end if 

   if ::oCursor != nil
      ::oCursor:end()
   end if

   if ::oBrush != nil
      ::oBrush:end()
   end if

   if ::oDragCursor != nil
      ::oDragCursor:end()
   end if

   ::Super:Destroy()

RETURN ( 0 )

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

RETURN nil

//----------------------------------------------------------------------------//

METHOD HideBitmaps() CLASS TWebBtn

   ::hBmpPal1 = 0
   ::hBmpPal2 = 0
   ::hBmpPal3 = 0

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD LoadBmp( cResName1, cResName2, cBmpFile1, cBmpFile2, cResName3, cBmpFile3 ) CLASS TWebBtn

   local nPos

   nPos  := aScan( ::aBitMaps, {| cBmp | cBmp[ 1 ] == cResName1 .or. cBmp[ 1 ] == cBmpFile1 } )

   if nPos != 0

      ::hBmpPal1     := ::aBitMaps[ nPos, 2 ]

   else

      if !Empty( cResName1 )
         #ifdef __C3__
         ::hBmpPal1  := PalBmpLoad( cResName1 )[ 1 ]
         #else
         ::hBmpPal1  := PalBmpLoad( cResName1 )
         #endif
         ::cBmpFile1 := cResName1
      endif

      if !Empty( cBmpFile1 ) .and. File( cBmpFile1 )

         ::cBmpFile1 := cBmpFile1
         #ifdef __C3__
         ::hBmpPal1  := PalBmpRead( ::GetDC(), cBmpFile1 )[ 1 ]
         #else
         ::hBmpPal1  := PalBmpRead( ::GetDC(), cBmpFile1 )
         #endif
         ::ReleaseDC()
      endif

      if  !Empty( ::cBmpFile1 )
         aAdd( ::aBitMaps, { ::cBmpFile1, ::hBmpPal1 } )
      end if

      if ! Empty( ::hBmpPal1 )
         PalBmpNew( ::hWnd, ::hBmpPal1 )
      endif

   end if

   /*
   Segundo bitmap--------------------------------------------------------------
   */

   nPos  := aScan( ::aBitMaps, {| cBmp | cBmp[ 1 ] == cResName2 .or. cBmp[ 1 ] == cBmpFile2 } )

   if nPos != 0

      ::hBmpPal2     := ::aBitMaps[ nPos, 2 ]

   else

      if ! Empty( cResName2 )
         #ifdef __C3__
         ::hBmpPal2  := PalBmpLoad( cResName2 )[ 1 ]
         #else
         ::hBmpPal2  := PalBmpLoad( cResName2 )
         #endif
         ::cBmpFile2 := cResName2
      endif

      if ! Empty( cBmpFile2 ) .and. File( cBmpFile2 )
         ::cBmpFile2 := cBmpFile2
         #ifdef __C3__
         ::hBmpPal2  := PalBmpRead( ::GetDC(), cBmpFile2 )[ 1 ]
         #else
         ::hBmpPal2  := PalBmpRead( ::GetDC(), cBmpFile2 )
         #endif
         ::ReleaseDC()
      endif

      if  !Empty( ::cBmpFile2 )
         aAdd( ::aBitMaps, { ::cBmpFile2, ::hBmpPal2 } )
      end if

      if ! Empty( ::hBmpPal2 )
         PalBmpNew( ::hWnd, ::hBmpPal2 )
      endif

   end if

   /*
   Tercer bitmap---------------------------------------------------------------
   */

   nPos  := aScan( ::aBitMaps, {| cBmp | cBmp[ 1 ] == cResName3 .or. cBmp[ 1 ] == cBmpFile3 } )

   if nPos != 0

      ::hBmpPal3     := ::aBitMaps[ nPos, 2 ]

   else

      if ! Empty( cResName3 )
         ::hBmpPal3  := PalBmpLoad( cResName3 )
         #ifdef __C3__
         ::hBmpPal3  := PalBmpLoad( cResName3 )[ 1 ]
         #else
         ::hBmpPal3  := PalBmpLoad( cResName3 )
         #endif
         ::cBmpFile3 := cResName3
      endif

      if ! Empty( cBmpFile3 ) .and. File( cBmpFile3 )
         ::cBmpFile3 := cBmpFile3
         #ifdef __C3__
         ::hBmpPal3  := PalBmpRead( ::GetDC(), cBmpFile3 )[ 1 ]
         #else
         ::hBmpPal3  := PalBmpRead( ::GetDC(), cBmpFile3 )
         #endif
         ::ReleaseDC()
      endif

      if  !Empty( ::cBmpFile3 )
         aAdd( ::aBitMaps, { ::cBmpFile3, ::hBmpPal3 } )
      end if

      if ! Empty( ::hBmpPal3 )
         PalBmpNew( ::hWnd, ::hBmpPal3 )
      endif

   end if

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD MouseMove( nRow, nCol, nKeyFlags ) CLASS TWebBtn

   local lMenu := nCol > ::nRight - 18 .and. ::bMenu != nil

   ::Super:MouseMove( nRow, nCol, nKeyFlags )

   /*
   Si no esta cpturado damos el valor inicial a lIsOverMenu
   */

   if !::lCaptured
      ::lIsOverMenu  := lMenu
   end if

   /*
   Pintado del control
   */

   if IsOverWnd( ::hWnd, nRow, nCol )
      if !::lCaptured .or. ::lIsOverMenu != lMenu
         ::lCaptured    := .t.
         ::lIsOverMenu  := lMenu
         ::Capture()
         ::Paint()
      end if
   else
      ::lCaptured    := .f.
      ::lIsOverMenu  := .f.
      ::Paint()
      ReleaseCapture()
   end if

   ::oWnd:SetMsg( ::cMsg )

RETURN 0

//----------------------------------------------------------------------------//

METHOD Toggle()

   ::lOpnGroup := !::lOpnGroup

   if !Empty( ::aControls )
      aEval( ::aControls, {|o| if( ::lOpnGroup, ( o:Enable(), o:Show() ), ( o:Disable(), o:Disable() ) ) } )
   end if

   ::oWnd:Resize()
   ::oWnd:Refresh()

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD Paint()

   local lWebBar        := Upper( ::oWnd:ClassName() ) == "TWEBBAR"

   if !::lTransparent

   CleanWB( ::hWnd,;
            ::hDC,;
            ::nWidth,;
            ::nHeight,;
            ::nLeft,;
            ::nTop,;
            if( lWebBar, ::oWnd:hBmpPal, nil ),;
            if( ::lCaptured, ::nClrPaneOver, ::nClrPane ) )

   end if

   /*
   if !lWebBar
      ? ::cCaption
      ? ::oFont:hFont                                 // 7
      ? ::oFontOver:hFont                             // 8
      ? ::nClrText                                    // 9
      ? ::nClrTextOver                                // 0
      ? ::lTransparent
   end if
   */

   PaintWB( ::hWnd,;                                        // 1
            ::hDC,;                                         // 2
            ::lCaptured,;                                   // 3
            ::cCaption,;                                    // 4
            ::bMenu != nil,;                                // 5
            ::hBmpPal1,;                                    // 6
            ::oFont:hFont,;                                 // 7
            ::oFontOver:hFont,;                             // 8
            ::nClrText,;                                    // 9
            ::nClrTextOver,;                                // 0
            ::nTop,;                                        // 11
            ::nLeft,;                                       // 12
            ::nHeight,;                                     // 13
            ::nWidth,;                                      // 14
            ::nPad,;                                        // 15
            ::hBmpPal2,;                                    // 16
            if( lWebBar, ::oWnd:nLeftMargin,  0 ),;         // 17
            if( lWebBar, ::oWnd:nRightMargin, 0 ),;         // 18
            if( lWebBar, ::oWnd:nTopMargin,   0 ),;         // 19
            if( lWebBar, ::oWnd:nDnMargin,    0 ),;         // 20
            ::lIsOverMenu,;                                 // 21
            ::lBorder,;                                     // 22
            ::nClrBTop,;                                    // 23
            ::nClrBBot,;                                    // 24
            ::nClrBTopOver,;                                // 25
            ::nClrBBotOver,;                                // 26
            ::lBtnDown,;                                    // 27
            lWebBar,;                                       // 28
            ::lOpnGroup,;                                   // 29
            ::lNowSelect,;                                  // 30
            ::lTransparent,;                                // 31
            ::lSingleLine )                                 // 32

RETURN nil

//----------------------------------------------------------------------------//

METHOD cText( uVal )

   if PCount() == 1      // OJO Con Objects 2.0 PCount() es PCount() + 1
      Eval( ::bSetGet, uVal )
      ::SetText( uVal )
   endif

RETURN ( GetWindowText( ::hWnd ) )

//----------------------------------------------------------------------------//

#ifndef __XHARBOUR__

#pragma BEGINDUMP

#include "windows.h"
#include "hbapi.h"

#define S_ANY              0xFFFF
#define S_ARRAY            0x8000

#define UNDEF                 0
#define CHARACTER             1
#define NUMERIC               2
#define LOGICAL               4
#define DATE                  8
#define ALIAS                16
#define MPTR                 32      /* or'ed with type when passed by reference */
#define MEMO                 64
#define ARRAY               512
#define BLOCK              1024
#define DOUBLE             2048

#define PCOUNT()           (_parinfo(0))
#define ISCHAR(n)          (_parinfo(n) & CHARACTER)
#define ISNUM(n)           (_parinfo(n) & NUMERIC)
#define ISLOG(n)           (_parinfo(n) & LOGICAL)
#define ISLOGICAL(n)       (_parinfo(n) & LOGICAL)
#define ISDATE(n)          (_parinfo(n) & DATE)
#define ISMEMO(n)          (_parinfo(n) & MEMO)
#define ISBYREF(n)         (_parinfo(n) & MPTR)
#define ISARRAY(n)         (_parinfo(n) & ARRAY)
#define ALENGTH(n)         (_parinfa(n, 0))
#define ISBLOCK(n)         (_parinfo(n) & BLOCK)

#define DT_EDITCONTROL     0x00002000
#define DT_MODIFYSTRING    0x00010000
#define DT_WORD_ELLIPSIS   0x00040000
#define DT_END_ELLIPSIS    0x00008000

#define TRANSPARENT        1
#define OPAQUE             2

#define BORDER_SPACE       2
#define MENU_SPACE         18

void DrawMasked( HDC hDC, HBITMAP hBmp, WORD wRow, WORD wCol );
void DrawBitmap( HDC hDC, HBITMAP hBmp, WORD wCol, WORD wRow, WORD wWidth, WORD wHeight, DWORD dwRaster );
void WndDrawBox( HDC hDC, RECT * rct, HPEN hPUpLeft, HPEN hPBotRit );

//---------------------------------------------------------------------------//

//---------------------------------------------------------------------------//

HB_FUNC( PAINTWB )   // hWnd, hDC, bIsOver, strText, bIsMenu, hPalBmp1, hFont, hFontOver
{                           // nClrText, nClrTextOver, nTop, nLeft, nHeight, nWidth, nPad
                            // hPalBmp2, bIsOverMenu

    int hOldDC;

    HFONT hOldFont;
    BITMAP bm;
    RECT rct;
    RECT brdrct;
    HBRUSH hBrush;
    HBRUSH hBrushOld;
    HPEN hOldPen;
    HPEN hPen;
    BOOL bDestroyDC         = FALSE;

    HWND hWnd               = ( HWND ) hb_parnl( 1 );
    HDC hDC                 = ( HDC ) hb_parnl( 2 );

    BOOL bIsOver            = hb_parl( 3 );
    LPSTR strText           = ( LPSTR ) hb_parc( 4 );
    WORD wLen               = hb_parclen( 4 );
    BOOL bIsMenu            = hb_parl( 5 );
    HBITMAP hPalBmp1        = ( HBITMAP ) hb_parnl( 6 );
    HFONT hFont             = ( HFONT ) hb_parnl( 7 );
    HFONT hFontOver         = ( HFONT ) hb_parnl( 8 );
    COLORREF clrText        = hb_parnl( 9 );
    COLORREF clrTextOver    = hb_parnl( 10 );
    WORD wPad               = hb_parnl( 15 );
    HBITMAP hPalBmp2        = ( HBITMAP ) hb_parnl( 16 );
    BOOL bIsOverMenu        = hb_parl( 21 );
    BOOL bBorder            = hb_parl( 22 );
    COLORREF clrBrdTop      = hb_parnl( 23 );
    COLORREF clrBrdBot      = hb_parnl( 24 );
    COLORREF clrBrdTopOver  = hb_parnl( 25 );
    COLORREF clrBrdBotOver  = hb_parnl( 26 );
    BOOL bPressed           = hb_parl( 27 );
    BOOL bWebBar            = hb_parl( 28 );
    BOOL bOpnGrp            = hb_parl( 29 );
    BOOL bSelect            = hb_parl( 30 );
    BOOL bTransparent       = hb_parl( 31 );
    BOOL bSingleLine        = hb_parl( 32 );

    POINT pt[3];
    int iBitmapPosition;


    if ( bPressed )
    {
        bIsOver             = bPressed;
    }

    if( ! hDC )
    {
        bDestroyDC          = TRUE;
        hDC                 = GetDC( hWnd );
    }

    hOldDC                  = SaveDC( hDC );

    rct.top                 = BORDER_SPACE;
    rct.left                = BORDER_SPACE;
    if ( LOWORD( hPalBmp1 ) )
        {
        GetObject( ( HGDIOBJ ) LOWORD( hPalBmp1 ), sizeof( BITMAP ), ( LPSTR ) &bm );
        rct.left            = bm.bmWidth > 0 ? BORDER_SPACE + bm.bmWidth + BORDER_SPACE : BORDER_SPACE ;
        }
    rct.bottom              = hb_parnl( 13 ) - BORDER_SPACE;
    rct.right               = hb_parnl( 14 ) - ( bWebBar ? MENU_SPACE : 0 );

    SetBkMode( hDC, TRANSPARENT );

    hOldFont                = SelectObject( hDC, bIsOver && !bIsOverMenu ? hFontOver : hFont );
    SetTextColor( hDC, bIsOver && !bIsOverMenu ? clrTextOver : clrText );

    if ( LOWORD( hPalBmp1 ) )
    {
        switch ( wPad )
        {
            case 1 :
                if ( bTransparent )
                {
                    DrawMasked( hDC, bIsOver ? hPalBmp2 : hPalBmp1, ( ( rct.bottom - rct.top ) - bm.bmHeight ) / 2 , BORDER_SPACE );
                }
                else
                {
                    DrawBitmap( hDC, bIsOver ? hPalBmp2 : hPalBmp1, ( ( rct.bottom - rct.top ) - bm.bmHeight ) / 2 , BORDER_SPACE, bm.bmWidth, bm.bmHeight, 0 );
                }
                break;

            case 2 :
                iBitmapPosition = ( rct.right - rct.left ) - ( bm.bmWidth / 2 );
                if ( iBitmapPosition < 0 )
                {
                    iBitmapPosition = 0 ;
                }

                if ( bTransparent )
                {
                    DrawMasked( hDC, bIsOver ? hPalBmp2 : hPalBmp1, ( ( rct.bottom - rct.top ) - bm.bmHeight ) / 2 , iBitmapPosition );
                }
                else
                {
                    DrawBitmap( hDC, bIsOver ? hPalBmp2 : hPalBmp1, ( ( rct.bottom - rct.top ) - bm.bmHeight ) / 2 , iBitmapPosition, bm.bmWidth, bm.bmHeight, 0 );
                }
                break;
        }
    }

    switch ( wPad )
    {
        case 1 :
            DrawText( hDC, strText, wLen, &rct, ( DT_EDITCONTROL | ( bSingleLine ? DT_SINGLELINE : DT_WORDBREAK ) | DT_END_ELLIPSIS | DT_TOP | DT_LEFT ) );
            break;
        case 2 :
            DrawText( hDC, strText, wLen, &rct, ( DT_EDITCONTROL | ( bSingleLine ? DT_SINGLELINE : DT_WORDBREAK ) | DT_END_ELLIPSIS | DT_TOP | DT_CENTER ) );
            break;
        case 3 :
            DrawText( hDC, strText, wLen, &rct, ( DT_EDITCONTROL | ( bSingleLine ? DT_SINGLELINE : DT_WORDBREAK ) | DT_END_ELLIPSIS | DT_TOP | DT_RIGHT ) );
            break;
    }

    if ( bIsMenu )
    {
        hPen            = CreatePen( PS_SOLID, 1,  bIsOverMenu ? clrTextOver : clrText );
        hOldPen         = SelectObject( hDC, hPen );
        hBrush          = CreateSolidBrush(  bIsOverMenu ? clrTextOver : clrText );
        hBrushOld       = SelectObject( hDC, hBrush );

        if( bOpnGrp )
        {
            MoveToEx( hDC, rct.right +  4,  9, NULL );
            LineTo( hDC, rct.right + 10,  9 );
            LineTo( hDC, rct.right +  7,  6 );
            LineTo( hDC, rct.right +  4,  9 );

            ExtFloodFill( hDC, rct.right + 7, 8, bIsOverMenu ? clrTextOver : clrText, 0 );
        }
        else
        {
            MoveToEx( hDC, rct.right +  4,  6, NULL );
            LineTo( hDC, rct.right + 10,  6 );
            LineTo( hDC, rct.right +  7,  9 );
            LineTo( hDC, rct.right +  4,  6 );

            ExtFloodFill( hDC, rct.right + 6, 7, bIsOverMenu ? clrTextOver : clrText, 0 );
        }
        SelectObject( hDC, hOldPen );
        DeleteObject( hPen );
        SelectObject( hDC, hBrushOld );
        DeleteObject( hBrush );
    }

    SetBkMode( hDC, OPAQUE );
    SelectObject( hDC, hOldFont );

    if ( bBorder )
    {
        GetClientRect( hWnd, &brdrct );

        hPen            = CreatePen( PS_SOLID, 1, bIsOver ? clrBrdTopOver : clrBrdTop );
        hOldPen         = SelectObject( hDC, hPen );
        MoveToEx( hDC, 0, brdrct.bottom, NULL );
        LineTo( hDC, 0, 0 );
        LineTo( hDC, brdrct.right, 0 );
        SelectObject( hDC, hOldPen );
        DeleteObject( hPen );

        hPen            = CreatePen( PS_SOLID, 1, bIsOver ? clrBrdBotOver : clrBrdBot );
        hOldPen         = SelectObject( hDC, hPen );
        MoveToEx( hDC, 0, brdrct.bottom - 1, NULL );
        LineTo( hDC, brdrct.right - 1, brdrct.bottom - 1 );
        LineTo( hDC, brdrct.right - 1, 0 );
        SelectObject( hDC, hOldPen );
        DeleteObject( hPen );
    }

    if( bSelect )
    {
        GetClientRect( hWnd, &brdrct );

        hPen            = CreatePen( PS_SOLID, 1, clrText );
        hOldPen         = SelectObject( hDC, hPen );
        MoveToEx( hDC, brdrct.right - 1, 0, NULL );
        LineTo( hDC, brdrct.right - 1, 1 );
        LineTo( hDC, 0, 1 );
        LineTo( hDC, 0, brdrct.bottom - 4 );
        LineTo( hDC, brdrct.right - 1, brdrct.bottom - 4 );
        LineTo( hDC, brdrct.right - 1, brdrct.bottom - 2 );
        SelectObject( hDC, hOldPen );
        DeleteObject( hPen );
    }

    RestoreDC( hDC, hOldDC );

    if( bDestroyDC )
        ReleaseDC( hWnd, hDC );

}
//---------------------------------------------------------------------------//

HB_FUNC( CLEANWB )   // hWnd, hDC, nWidth, nHeight, nLeft, nTop, hPalBmpBk, nColor
{

    HDC hDCMemX;
    HBITMAP hBmpOld;
    HBRUSH hBrush;
    RECT rct;
    BOOL bDestroyDC         = FALSE;

    HWND hWnd               = ( HWND ) hb_parnl( 1 );
    HDC hDC                 = ( HDC ) hb_parnl( 2 );
    HBITMAP hPalBmpBk       = ( HBITMAP ) hb_parnl( 7 );
    COLORREF nColor         = hb_parnl( 8 );

    if( ! hDC )
    {
        bDestroyDC          = TRUE;
        hDC                 = GetDC( hWnd );
    }

    if( hPalBmpBk != 0 )
    {
        hDCMemX             = CreateCompatibleDC( hDC );
        hBmpOld             = SelectObject( hDCMemX, hPalBmpBk );

        BitBlt( hDC, 0, 0, hb_parnl( 3 ), hb_parnl( 4 ), hDCMemX, hb_parnl( 5 ), hb_parnl( 6 ), SRCCOPY );

        SelectObject( hDCMemX, hBmpOld );
        DeleteDC( hDCMemX );
    }
    else
    {
        hBrush              = CreateSolidBrush( nColor ) ;
        GetClientRect( hWnd, &rct );
        FillRect( hDC, &rct, hBrush ) ;
        DeleteObject( hBrush );
    }

    if( bDestroyDC )
        ReleaseDC( hWnd, hDC );
}

//---------------------------------------------------------------------------//

HB_FUNC( COMPATDC ) 
{
   hb_retnl( ( long ) CreateCompatibleDC( ( HDC ) hb_parnl( 1 ) ) );

}

//---------------------------------------------------------------------------//

HB_FUNC( COMPATBMP ) 
{
   hb_retnl( ( long ) CreateCompatibleBitmap( ( HDC ) hb_parnl( 1 ), hb_parnl( 2 ), hb_parnl( 3 ) ) );

}

//---------------------------------------------------------------------------//

#pragma ENDDUMP

#endif


