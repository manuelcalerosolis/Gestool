* ============================================================================
* CLASS TSButton Version 1.0 1/Dec/2001
* This class was built taking chunks from some FiveWin Classes and some
* from my own crop.
*
* It consists in two programs, this one and BPaint.c which takes care of
* painting job. The constructing commands are defined in TSButton.ch header
* file.
*
* Author: Manuel Mercado
* You can freely use this class just by respecting the authorïs name.
* ============================================================================

#include "FiveWin.Ch"

#define BM_SETSTYLE  WM_USER + 4
#define GWL_STYLE             (-16)
#define COLOR_BTNFACE         15
#define NO_FOCUSWIDTH         25

#ifdef __XPP__
   #define Super ::TControl
   #define New _New
#EndIf

//----------------------------------------------------------------------------//

CLASS TSButton FROM TControl

   DATA   hBmpPal1, hBmpPal2, hBmpPal3, hBmpPal4
   DATA   cAccel
   DATA   cTipTool
   DATA   bAction
   DATA   lBtnUp, lBtnDown, lOpaque, lKillFont, lGroup, lMulti, lWorking, lV22
   DATA   lDefault, lAdjust, lPressed, lSizePend AS LOGICAL
   DATA   lProcessing, lMouseOver, lMenuPress AS LOGICAL
   DATA   nClrFore, nClrBack, nCaptPos, nBorder, nWakeUp
   DATA   oPBrush, bMenu

   CLASSDATA lRegistered AS LOGICAL

   METHOD New( nTop, nLeft, cPrompt, oWnd, aResource, aFile, aSize, lPixel, ;
               bAction, bWhen, bValid, lDefault, oFont, cMsg, cToolTip, ;
               nHelpId, nBorder, lCancel, lAdjust, aColors, nCaptPos, ;
               lOpaque, oPBrush, lW97, bMenu ) CONSTRUCTOR

   METHOD ReDefine( nId, aResource, aFile, cMsg, bAction, nHelpId, ;
                    nBorder, oWnd, bWhen, bValid, cToolTip, cPrompt, oFont,;
                    lCancel, nCaptPos, aColors, lOpaque, oPBrush,lW97, ;
                    bMenu, lAdjust ) CONSTRUCTOR

   METHOD NewBar( oBar, aSize, cPrompt, aResource, aFile, bAction, bWhen, ;
                  oFont, cMsg, cToolTip, nHelpId, nBorder, lCancel, lAdjust, ;
                  aColors, nCaptPos, lOpaque, lW97, oPBrush, bMenu, lGroup, ;
                  nPos, bDrop ) CONSTRUCTOR

   METHOD Click()

   METHOD cToChar() INLINE Super:cToChar( "BUTTON" )

   METHOD Default()

   METHOD Destroy()

   Method Disable( nWakeup )

   METHOD Display()

   METHOD Enable() INLINE ::nWakeup := 0, Super:Enable()

   METHOD FreeBitmaps()

   METHOD GetDlgCode( nLastKey )

   METHOD GetWH( lWidth )

   METHOD GotFocus( hCtlLost )

   METHOD HandleEvent( nMsg, nWParam, nLParam )

   METHOD Initiate( hDlg ) INLINE Super:Initiate( hDlg ), ::Default()

   METHOD KeyDown( nKey, nFlags )

   METHOD LDblClick( nRow, nCol, nKeyFlags ) INLINE If( ::nWakeup > 0, 0, ;
                                             Super:LDblClick( nRow, nCol, nKeyFlags ) )

   METHOD LoadBitmaps( aResource, aFile )

   METHOD LButtonDown( nRow, nCol, nKeyFlags )

   METHOD LButtonUp( nRow, nCol, nKeyFlags )

   METHOD LostFocus()

   METHOD MouseMove( nRow, nCol, nKeyFlags )

   METHOD NewGroup( aBtn, nTop, nLeft, aPrompt, oWnd, aResource, aFile, ;
                    aSize, lPixel, aAction, bWhen, bValid, lDefault, oFont, ;
                    cMsg, cToolTip, nHelpId, nBorder, lCancel, lAdjust, ;
                    aColors, nCaptPos, lOpaque, oPBrush, lW97, bMenu )

   METHOD nRows()

   METHOD Paint()

   METHOD RButtonDown( nRow, nCol, nKeyFlags )

   METHOD RButtonUp( nRow, nCol, nKeyFlags )

   METHOD Refresh( lRepaint )

   METHOD SetColor( uClrText, uClrPane )

   METHOD SetText( cCaption )

ENDCLASS

* ============================================================================
* METHOD TSButton:New() Version 1.0 1/Dec/2001
* ============================================================================

METHOD New( nTop, nLeft, cPrompt, oWnd, aResource, aFile, aSize, lPixel, ;
            bAction, bWhen, bValid, lDefault, oFont, cMsg, cToolTip, nHelpId, ;
            nBorder, lCancel, lAdjust, aColors, nCaptPos, lOpaque, ;
            oPBrush, lW97, bMenu, lSBGroup ) CLASS TSButton

   Local nFntWidth, nFntHeight, ;
         aClrTmp := Array( 2 ), ;
         aResTmp := Array( 4 ), ;
         aSizTmp := Array( 2 ), ;
         aFilTmp := Array( 4 )

   If aColors != Nil
      Aeval( aColors, { | bColor, nEle | aClrTmp[ nEle ] := bColor } )
   EndIf

   If aResource != Nil
      Aeval( aResource, { | cRes, nEle | aResTmp[ nEle ] := cRes } )
   EndIf

   If aFile != Nil
      Aeval( aFile, { | cFil, nEle | aFilTmp[ nEle ] := cFil } )
   EndIf

   If aSize != Nil
      Aeval( aSize, { | nSize, nEle | aSizTmp[ nEle ] := nSize } )
   EndIf

   Default nTop     := 0, nLeft := 0, ;
           nHelpId  := 0, ;
           cPrompt  := "", ;
           lOpaque  := .F., ;
           oWnd     := GetWndDefault(), ;
           lAdjust  := .F., ;
           lW97     := .F.

   Default aClrTmp [ 1 ] := CLR_BLACK, ;
           aClrTmp [ 2 ] := If( lW97, oWnd:nClrPane, GetSysColor( COLOR_BTNFACE ) )

   Default oFont    := oWnd:oFont, ;
           cMsg     := "", ;
           nHelpId  := 100, ;
           lDefault := .F., lPixel := .F., ;
           lCancel  := .F., ;
           lSBGroup := .F., ;
           nCaptPos := 4  // caption position 1 = top  2 = left 3 = bottom
                          //                  4 = right 5 = center

   Default nBorder  := If( ! lW97, "BORDER", "NOBORDER" )

   nBorder := If( nBorder == "NOBOX", 0, If( nBorder == "NOBORDER", 1, 2 ) )

   nBorder := If( lW97, 1, nBorder )

   nFntWidth  = If( oFont != Nil .and. oFont:nWidth != Nil, oFont:nWidth,    7 )
   nFntHeight = If( oFont != Nil .and. oFont:nHeight != Nil, oFont:nHeight, 10 )

   If aSizTmp[ 1 ] == Nil
      ::lSizePend := If( aSizTmp[ 1 ] == Nil, .T., .F. )
   EndIf

   Default aSizTmp[ 1 ] := ( Len( cPrompt ) + 2 ) * nFntWidth, ;
           aSizTmp[ 2 ] := nFntHeight + Int( nFntHeight / 4 )

   ::cCaption  = cPrompt
   ::nTop      = nTop * If( ! lPixel, nFntHeight + Int( nFntHeight / 4 ), 1 )
   ::nLeft     = nLeft * If( ! lPixel, nFntWidth, 1 )
   ::nBottom   = ::nTop  + aSizTmp[ 2 ]
   ::nRight    = ::nLeft + aSizTmp[ 1 ]
   ::nHelpId   = nHelpId
   ::bAction   = bAction
   ::oWnd      = oWnd
   ::oFont     = oFont
   ::nStyle    = nOR( WS_CHILD, WS_VISIBLE, If( ! lSBGroup, WS_TABSTOP, 0 ), ;
                      WS_CLIPSIBLINGS, If( lDefault, BS_DEFPUSHBUTTON, 0 ) )

   ::nId       = ::GetNewId()
   ::lCaptured = .F.
   ::cMsg      = cMsg
   ::bWhen     = bWhen
   ::bValid    = bValid
   ::lDefault  = lDefault
   ::lCancel   = lCancel
   ::cToolTip  = cToolTip
   ::cTipTool  = cToolTip
   ::nBorder   = nBorder
   ::hBmpPal1  := 0
   ::hBmpPal2  := 0
   ::hBmpPal3  := 0
   ::hBmpPal4  := 0
   ::lProcessing = .F.
   ::lMouseOver  = .F.
   ::lPressed  = .F.
   ::nCaptPos  = nCaptPos
   ::nClrFore  = aClrTmp[ 1 ]
   ::nClrBack  = aClrTmp[ 2 ]
   ::lOpaque   = lOpaque
   ::oPBrush   = oPBrush
   ::l97Look   = lW97
   ::lAdjust   = lAdjust
   ::bMenu     = bMenu
   ::nWakeUp   = 0
   ::nDlgCode  = If( Upper( ::oWnd:ClassName() ) == "TBAR" .or. ;
                     Upper( ::oWnd:ClassName() ) == "TSBAR" .or. ;
                     bMenu != Nil, Nil, DLGC_WANTALLKEYS )


   Default ::lMulti := .F.

   If ::bMenu != Nil .and. ::bAction == Nil
      ::bAction := ::bMenu
   EndIf

   #ifdef __XPP__
      Default ::lRegistered := .F.
              ::lProcessing = .F.
   #EndIf

   ::Register( nOR( CS_VREDRAW, CS_HREDRAW ) )

   If ! Empty( oWnd:hWnd )
      ::Create()
      oWnd:AddControl( Self )
   Else
      oWnd:DefControl( Self )
   EndIf

   ::LoadBitMaps( aResTmp, aFilTmp )
   ::Default()

Return Self

* ============================================================================
* METHOD TSButton:NewBar() Version 1.0 1/Dec/2001
* ============================================================================

METHOD NewBar( oBar, aSize, cPrompt, aResource, aFile, bAction, bWhen, oFont, ;
               cMsg, cToolTip, nHelpId, nBorder, lCancel, lAdjust, aColors, ;
               nCaptPos, lOpaque, lW97, oPBrush, bMenu, lGroup, nPos, ;
               bDrop ) CLASS TSButton

   Local aClrTmp := Array( 2 ), ;
         aResTmp := Array( 4 ), ;
         aSizTmp := Array( 2 ), ;
         aFilTmp := Array( 4 )

   If aColors != Nil
      Aeval( aColors, { | bColor, nEle | aClrTmp[ nEle ] := bColor } )
   EndIf

   If aResource != Nil
      Aeval( aResource, { | cRes, nEle | aResTmp[ nEle ] := cRes } )
   EndIf

   If aFile != Nil
      Aeval( aFile, { | cFil, nEle | aFilTmp[ nEle ] := cFil } )
   EndIf

   If aSize != Nil
      Aeval( aSize, { | nSize, nEle | aSizTmp[ nEle ] := nSize } )
   EndIf

   Default oFont    := oBar:oWnd:oFont, ;
           cMsg     := "", ;
           lGroup   := .F., ;
           lCancel  := .F., ;
           lOpaque  := .F., ;
           lW97     := .F., ;
           lAdjust  := .F., ;
           nCaptPos := 4    // caption position 1 = top  2 = left 3 = bottom
                            //                  4 = right 5 = center

   Default aClrTmp [ 1 ] := CLR_BLACK, ;
           aClrTmp [ 2 ] := If( lW97, oBar:nClrPane, ;
                                GetSysColor( COLOR_BTNFACE ) )

   nBorder := If( nBorder != Nil .and. nBorder == "NOBOX", 0, ;
              If( nBorder != Nil .and. nBorder == "NOBORDER", 1, 2 ) )

   nBorder := If( lW97, 1, nBorder )

   If aSizTmp[ 1 ] == Nil
      ::lSizePend := If( aSizTmp[ 1 ] == Nil, .T., .F. )
   EndIf

   Default aSizTmp [ 1 ] := oBar:nBtnWidth, ;
           aSizTmp [ 2 ] := oBar:nBtnHeight

   ::nStyle    = nOR( WS_CHILD, WS_VISIBLE )
   ::nTop      = oBar:GetBtnTop( lGroup, nPos )
   ::nLeft     = oBar:GetBtnLeft( lGroup, nPos )
   ::nBottom   = ::nTop + oBar:nBtnHeight + 1 - If( oBar:l3D, 7, 0 )
   ::nRight    = ::nLeft + aSizTmp[ 1 ] - If( oBar:l3D, 2, 0 )
   ::nId       = ::GetNewId()
   ::bAction   = bAction
   ::hWnd      = 0
   ::nHelpId   = nHelpId
   ::oWnd      = oBar
   ::oFont     = oFont
   ::lCaptured = .F.
   ::lDrag     = .F.
   ::cMsg      = cMsg
   ::bWhen     = bWhen
   ::cCaption  = cPrompt
   ::lCancel   = lCancel
   ::cToolTip  = cToolTip
   ::cTipTool  = cToolTip
   ::nBorder   = nBorder
   ::bDropOver = bDrop
   ::lPressed  = .F.
   ::lProcessing = .F.
   ::lMouseOver  = .F.
   ::hBmpPal1  := 0
   ::hBmpPal2  := 0
   ::hBmpPal3  := 0
   ::hBmpPal4  := 0
   ::nCaptPos  = nCaptPos
   ::nClrFore  = aClrTmp[ 1 ]
   ::nClrBack  = aClrTmp[ 2 ]
   ::lOpaque   = lOpaque
   ::oPBrush    = oPBrush
   ::l97Look   = lW97
   ::bMenu     = bMenu
   ::lGroup    = lGroup
   ::nWakeUp   := 0

   Default ::lMulti := .F.

   If ::bMenu != Nil .and. ::bAction == Nil
      ::bAction := ::bMenu
   EndIf

   #ifdef __XPP__
      DEFAULT ::lRegistered := .f.
      ::lProcessing = .f.
   #endif

   ::Register( nOR( CS_VREDRAW, CS_HREDRAW ) )

   ::Create()
   oBar:Add( Self, nPos )

   If bWhen != Nil .and. ! ::lWhen()
      ::Disable()
   EndIf

   ::LoadBitMaps( aResTmp, aFilTmp )
   ::Default()

Return Self

* ============================================================================
* METHOD TSButton:Redefine() Version 1.0 1/Dec/2001
* ============================================================================

METHOD ReDefine( nId, aResource, aFile, cMsg, bAction, nHelpId, nBorder, ;
                 oWnd, bWhen, bValid, cToolTip, cPrompt, oFont, lCancel, ;
                 nCaptPos, aColors, lOpaque, oPBrush, lW97, bMenu, ;
                 lAdjust ) CLASS TSButton

   Local aClrTmp := Array( 2 ), ;
         aResTmp := Array( 4 ), ;
         aFilTmp := Array( 4 )

   If aColors != Nil
      Aeval( aColors, { | bColor, nEle | aClrTmp[ nEle ] := bColor } )
   EndIf

   If aResource != Nil
      Aeval( aResource, { | cRes, nEle | aResTmp[ nEle ] := cRes } )
   EndIf

   If aFile != Nil
      Aeval( aFile, { | cFil, nEle | aFilTmp[ nEle ] := cFil } )
   EndIf

   Default oWnd     := GetWndDefault(), ;
           lCancel  := .F., ;
           cMsg     := "", ;
           lOpaque  := .F., ;
           lAdjust  := .F., ;
           lW97     := .F., ;
           nCaptPos := 4    // caption position 1 = top  2 = left 3 = bottom
                            //                  4 = right 5 = center

   Default aClrTmp [ 1 ] := CLR_BLACK, ;
           aClrTmp [ 2 ] := If( lW97, oWnd:nClrPane, GetSysColor( COLOR_BTNFACE ) )

   Default nBorder := "BORDER"

   nBorder := If( nBorder == "NOBOX", 0, If( nBorder == "NOBORDER", 1, 2 ) )

   nBorder := If( lW97, 1, nBorder )

   ::nId       := nId
   ::bAction   := bAction
   ::hWnd      := 0
   ::nHelpId   := nHelpId
   ::oWnd      := oWnd
   ::oFont     := oFont
   ::lCaptured := .F.
   ::lDrag     := .F.
   ::cMsg      := cMsg
   ::bWhen     := bWhen
   ::bValid    := bValid
   ::cCaption  := cPrompt
   ::lCancel   := lCancel
   ::cToolTip  := cToolTip
   ::cTipTool  := cToolTip
   ::nBorder   := nBorder
   ::lPressed  := .F.
   ::lProcessing := .F.
   ::lMouseOver  := .F.
   ::hBmpPal1  := 0
   ::hBmpPal2  := 0
   ::hBmpPal3  := 0
   ::hBmpPal4  := 0
   ::nCaptPos  := nCaptPos
   ::nClrFore  := aClrTmp[ 1 ]
   ::nClrBack  := aClrTmp[ 2 ]
   ::lOpaque   := lOpaque
   ::oPBrush   := oPBrush
   ::l97Look   := lW97
   ::lAdjust   := lAdjust
   ::bMenu     := bMenu
   ::nWakeup   := 0
   ::nDlgCode  := If( Upper( ::oWnd:ClassName() ) == "TBAR" .or. ;
                      Upper( ::oWnd:ClassName() ) == "TSBAR" .or. ;
                      bMenu != Nil, Nil, DLGC_WANTALLKEYS )

   Default ::lMulti := .F.

   If ::bMenu != Nil .and. ::bAction == Nil
      ::bAction := ::bMenu
   EndIf

   #ifdef __XPP__
      ::lProcessing = .f.
   #endif

   ::Register( nOR( CS_VREDRAW, CS_HREDRAW ) )

   oWnd:DefControl( Self )

   ::LoadBitMaps( aResTmp, aFilTmp )

Return Self

* ============================================================================
* METHOD TSButton:Click() Version 1.0 1/Dec/2001
* ============================================================================

METHOD Click() CLASS TSButton

   If ! ::lProcessing
      ::lProcessing = .t.

      ::SetFocus()

      If ::OnClick != Nil
         OSend( ::oWnd, ::OnClick, Self )
      EndIf

      If ::bAction != Nil
         Eval( ::bAction, Self )
      EndIf

      Super:Click()

      ::SendMsg( BM_SETSTYLE, BS_DEFPUSHBUTTON, 1 )
      ::lProcessing = .f.

   EndIf

Return Nil

* ============================================================================
* METHOD TSButton:Default() Version 1.0 1/Dec/2001
* ============================================================================

METHOD Default() CLASS TSButton

   Local nAt

   ::lDefault := lAnd( GetWindowLong( ::hWnd, GWL_STYLE ),;
                       BS_DEFPUSHBUTTON )
   ::lProcessing := .F.
   ::lWorking := .F.

   If ::lSizePend
      ::nRight  := ::nLeft + ::GetWH( .T. )
      If Upper( ::oWnd:ClassName ) != "TBAR" .and. ;
         Upper( ::oWnd:ClassName() ) != "TSBAR"
         ::nBottom := ::nTop  + ::GetWH( .F. )
      EndIf
      ::Move( ::nTop, ::nLeft, ::nRight - ::nLeft + 1, ::nBottom - ::nTop + 1, .T. )
      ::lSizePend := .F.
   EndIf

   If ! Empty( ::cCaption )
      SetWindowText( ::hWnd, ::cCaption )
      nAt := At( "&", ::cCaption )
      ::cAccel := If( nAt > 0, Substr( ::cCaption, nAt + 1, 1 ), Nil )
   EndIf

   If lAnd( GetWindowLong( ::hWnd, GWL_STYLE ), WS_BORDER )
      SetWindowLong( ::hWnd, GWL_STYLE,;
                     nAnd( GetWindowLong( ::hWnd, GWL_STYLE ), ;
                           nNot( WS_BORDER ) ) )

   EndIf

   ::lKillFont := .F.

   If ValType( ::oFont ) != "O"
      If ValType( ::oWnd:oFont ) != "O"
         If ValType( ::oWnd:oWnd:oFont ) != "O" .and. ;
            ( Upper( ::oWnd:ClassName ) == "TBAR" .or. ;
              Upper( ::oWnd:ClassName ) == "TSBAR" )

            DEFINE FONT ::oFont NAME "MS Sans Serif" SIZE 0, -8
            ::lKillFont := .T.

         Else
            ::oFont := ::oWnd:oWnd:oFont
         EndIf
      Else
         ::oFont := ::oWnd:oFont
      EndIf
   EndIf

   ::lDrag     = .F.
   ::lCaptured = .F.

Return 0

* ============================================================================
* METHOD TSButton:Destroy() Version 1.0 1/Dec/2001
* ============================================================================

METHOD Destroy() CLASS TSButton

   ::FreeBitmaps()

   If ::lKillFont
      ::oFont:End()
   EndIf

   Super:Destroy()

Return 0

* ============================================================================
* METHOD TSButton:Disable() Version 1.0 1/Dec/2001
* ============================================================================

METHOD Disable( nWakeup ) CLASS TSButton

   If nWakeup != Nil .and. Valtype( nWakeup ) == "N" .and. nWakeup < 145
      ::nWakeup := nWakeup
      Return 0
   EndIf

Return Super:Disable()

* ============================================================================
* METHOD TSButton:Display() Version 1.0 1/Dec/2001
* ============================================================================

METHOD Display() CLASS TSButton

   If ::oWnd:hWnd == 0 .or. ! ::oWnd:lVisible
		Return 0
   EndIf

   ::BeginPaint()
	::Paint()
   ::EndPaint()

Return 0

* ============================================================================
* METHOD TSButton:FreeBitMaps() Version 1.0 1/Dec/2001
* ============================================================================

METHOD FreeBitMaps() CLASS TSButton

   If ! Empty( ::hBmpPal1 )
      If ::lV22
         PalBmpFree( ::hBmpPal1[ 1 ], ::hBmpPal1[ 2 ] )
      Else
         PalBmpFree( ::hBmpPal1 )
      EndIf
   EndIf

   If ! Empty( ::hBmpPal2 )
      If ::lV22
         PalBmpFree( ::hBmpPal2[ 1 ], ::hBmpPal2[ 2 ] )
      Else
         PalBmpFree( ::hBmpPal2 )
      EndIf
   EndIf

   If ! Empty( ::hBmpPal3 )
      If ::lV22
         PalBmpFree( ::hBmpPal3[ 1 ], ::hBmpPal3[ 2 ] )
      Else
         PalBmpFree( ::hBmpPal3 )
      EndIf
   EndIf

   If !Empty( ::hBmpPal4 )
      If ::lV22
         PalBmpFree( ::hBmpPal4[ 1 ], ::hBmpPal4[ 2 ] )
      Else
         PalBmpFree( ::hBmpPal4 )
      EndIf
   EndIf

   ::hBmpPal1 := 0
   ::hBmpPal2 := 0
   ::hBmpPal3 := 0
   ::hBmpPal4 := 0

Return Nil

* ============================================================================
* METHOD TSButton:GetDlgCode() Version 1.0 1/Dec/2001
* ============================================================================

METHOD GetDlgCode( nLastKey ) CLASS TSButton

   If nLastkey > 0 .and. nLastkey == ::nWakeup
      ::nWakeup := 0
   EndIf

   If ! ::oWnd:lValidating .and. ::oWnd:oCtlFocus != Nil .and. ;
      ::oWnd:oCtlFocus:hWnd == ::hWnd .and. ::cAccel != Nil .and. ;
      GetAsyncKeyState( Asc( Upper( ::cAccel ) ) ) .and. ::nWakeup == 0

      ::SendMsg( FM_CLICK )

   EndIf

Return Super:GetDlgCode( nLastKey )

* ============================================================================
* METHOD TSButton:GetWH() Version 1.0 1/Dec/2001
* ============================================================================

METHOD GetWH( lWidth ) CLASS TSButton

   Local nRet, ;
         nBmpWH  := 0, ;
         nTextWH := 0


   If ::lV22 == Nil
      ::lV22 := CheckBmpPal()
   EndIf

   If ! Empty( ::hBmpPal1 )
      If ::lV22
         nBmpWH := If( lWidth, nBmpWidth( ::hBmpPal1[ 1 ] ), ;
                               nBmpHeight( ::hBmpPal1[ 1 ] ) )
      Else
         nBmpWH := nbmpwidth( ::hBmpPal1 )
      EndIf

   EndIf

   If ! Empty( ::cCaption )
      If lWidth
         nTextWH :=  GetTextWidth( ::GetDC(), StrTran( ::cCaption, "&" ), ;
                                  ::oFont:hFont )
      Else
         nTextWH :=  GetTextHeight( ::hWnd, ::GetDC )

         If ::nCaptPos == 5
            nTextWH := 0
         EndIf

      EndIf

      ::ReleaseDC()

   EndIf

   If lWidth
      If ::nCaptPos = 2 .or. ::nCaptPos == 4
         nRet := nTextWH + nBmpWH + 10 + If( ::bMenu != Nil, 12, 0 )
      ElseIf ::nCaptPos < 5
         nRet := nBmpWH + 10 + If( ::bMenu != Nil, 12, 0 )
      Else
         nRet := Max( nBmpWH, nTextWH ) + 10 + If( ::bMenu != Nil, 12, 0 )
      EndIf
   Else
      nRet := nBmpWH + nTextWH + 5
   EndIf

Return nRet

* ============================================================================
* METHOD TSButton:GotFocus() Version 1.0 1/Dec/2001
* ============================================================================

METHOD GotFocus( hCtlLost ) CLASS TSButton

   If ::nWakeup > 0
      Return 1
   EndIf

   If ! ::lDrag
      If Upper( ::oWnd:ClassName() ) != "TDIALOG" .or. ;
         ( ::oWnd:oWnd != Nil .and. ;
         ( Upper( ::oWnd:oWnd:ClassName() ) == "TFOLDER" .or. ;
           Upper( ::oWnd:oWnd:ClassName() ) == "TPAGES" ) ) .or. ;
         ::oWnd:nLastKey == VK_RETURN .or. ;
         ( ::oWnd:oCtlFocus != Nil .and. ;
         Upper( ::oWnd:oCtlFocus:ClassName() ) == "TMULTIGET" )

         ::SendMsg( BM_SETSTYLE, BS_DEFPUSHBUTTON, 1 )

      EndIf
   EndIf

   ::lFocused       = .T.
   ::oWnd:nResult   = Self
   ::oWnd:oCtlFocus = Self
   ::oWnd:hCtlFocus = ::hWnd
   ::SetMsg( ::cMsg )

   If ::lDrag .and. Upper( ::oWnd:ClassName() ) != "TBAR" .and. ;
      Upper( ::oWnd:ClassName() ) != "TSBAR" .and. ::bMenu == Nil
      ::ShowDots()
   EndIf

   If ::bGotFocus != Nil
      Return Eval( ::bGotFocus, Self, hCtlLost )
   EndIf

Return Nil

* ============================================================================
* METHOD TSButton:HandleEvent() Version 1.0 1/Dec/2001
* Do nothing, used for some tests
* ============================================================================

METHOD HandleEvent( nMsg, nWParam, nLParam ) CLASS TSButton

Return Super:HandleEvent( nMsg, nWParam, nLParam )

* ============================================================================
* METHOD TSButton:KeyDown() Version 1.0 1/Dec/2001
* ============================================================================

METHOD KeyDown( nKey, nFlags ) CLASS TSButton

   Do Case
      Case nKey == VK_UP .or. nKey == VK_LEFT
           ::oWnd:GoPrevCtrl( ::hWnd )
           Return 0

      Case nKey == VK_DOWN .or. nKey == VK_RIGHT
           ::oWnd:GoNextCtrl( ::hWnd )
           Return 0

      Case nKey == VK_RETURN
           ::lPressed := .T.
           ::Paint()
           PostMessage( ::hWnd, FM_CLICK )
           InKey( .15 )
           ::lPressed := .F.
           ::Paint()
           Return 0

   Endcase

Return Super:KeyDown( nKey, nFlags )

* ============================================================================
* METHOD TSButton:LButtonDown() Version 1.0 1/Dec/2001
* ============================================================================

METHOD LButtonDown( nRow, nCol, nKeyFlags ) CLASS TSButton

   Local lMenuPress := ( nCol > ( ::nWidth() - 13 ) ) .and. ( ::bMenu != Nil )

   If ::lProcessing .or. ( ::nWakeup > 0 .and. ::nWakeup != VK_LBUTTON )
      Return 0
   EndIf

   If ::nWakeup > 0
      ::nWakeup := 0
   EndIf

   If ! ::lCancel .and. ::oWnd:oCtlFocus != Nil .and. ;
      ::oWnd:oCtlFocus:hWnd != ::hWnd
      ::oWnd:oCtlFocus:LostFocus()
   EndIf

   If ! ::lCancel .and. ::oWnd:oCtlFocus != Nil .and. ;
      ::oWnd:oCtlFocus:bValid != Nil .and. ! ::oWnd:oCtlFocus:lValid
        MsgBeep()
        Return 1
   EndIf

   If lMenuPress

      ::lMenuPress := .T.
      ::Paint()
      ::lWorking := .T.
      ::lProcessing := .T.

      Eval( ::bMenu, Self )

      ::lMouseOver := .F.
      ::lProcessing := .F.
      ::lWorking := .F.
      ::lMenuPress := .F.
      ::lPressed := .F.
      ::Paint()
      ::cToolTip := ::cTipTool

      Return 0

   EndIf

   If Upper( ::oWnd:ClassName() ) == "TBAR" .or. ;
      Upper( ::oWnd:ClassName() ) == "TSBAR"

      ::cTooltip := Nil
      ::CheckToolTip()

      ::lPressed := .T.
      ::Paint()
      ::lWorking := .T.
      ::lProcessing := .T.

      Eval( ::bAction, Self )

      ::lMouseOver := .F.
      ::lProcessing := .F.
      ::lWorking := .F.
      ::lMenuPress := .F.
      ::lPressed := .F.
      ::Paint()
      ::cToolTip := ::cTipTool

      If ::lFocused
         ::KillFocus()
      EndIf

      Return 0

   EndIf

   ::oWnd:nLastKey = 1002

   ::GotFocus()
   ::nLastRow   := nRow
   ::nLastCol   := nCol
   ::lPressed   := .T.
   ::lMouseOver := .F.
   ::Paint()
   ::cToolTip   := Nil
   ::CheckToolTip()

   If ::lDrag

      ::HideDots()
      CursorCatch()

      If ! ::lCaptured
         ::Capture()
         ::lCaptured = .T.
      EndIf
      Return 0

   Else
      If ::bLClicked != Nil
         Return Eval( ::bLClicked, nRow, nCol, nKeyFlags )
      EndIf
   EndIf

Return 0

* ============================================================================
* METHOD TSButton:LButtonUp() Version 1.0 1/Dec/2001
* ============================================================================

METHOD LButtonUp( nRow, nCol, nKeyFlags ) CLASS TSButton

   ::oWnd:nLastKey = 1003

   If ::lProcessing
      Return 0
   EndIf

   If IsOverWnd( ::hWnd, nRow, nCol ) .and. ! ::oWnd:oCtlFocus == Nil .and. ;
      ::oWnd:oCtlFocus:hWnd == ::hWnd
      PostMessage( ::hWnd, FM_CLICK )
   Else
      ::lPressed := .F.
      ::lMouseOver := .F.
      ::cToolTip := ::cTipTool
      ::Paint()
      Return 0
   EndIf

   If ::lDrag
      If ::lCaptured
         ReleaseCapture()
         ::lCaptured = .F.
         If ::aDots != Nil
            ::ShowDots()
         EndIf
         ::nMResize = 0
      EndIf

      If GetFocus() != ::hWnd .and. ( Upper( ::oWnd:ClassName ) != "TBAR" .or.;
                                      Upper( ::oWnd:ClassName ) != "TSBAR" )
         SetFocus( ::hWnd )
      EndIf

      Return 0

   EndIf

   ::lPressed := .F.
   ::Paint()
   ::cToolTip := ::cTipTool

Return 0

* ============================================================================
* METHOD TSButton:LoadBitMaps() Version 1.0 1/Dec/2001
* ============================================================================

METHOD LoadBitmaps( aResource, aFile ) CLASS TSButton

   Local nEle

   ::lV22 := CheckBmpPal()

   If ! Empty( aResource[ 1 ] )
      If aResource[ 1 ] == aResource[ 2 ] .and. ;
         aResource[ 1 ] == aResource[ 3 ] .and. ;
         aResource[ 1 ] == aResource[ 4 ]

         ::lMulti := .T.

      EndIf
   EndIf

   If ! Empty( aResource[ 1 ] )
      ::hBmpPal1 := PalBmpLoad( aResource[ 1 ] )
   EndIf

   If ! Empty( aResource[ 2 ] ) .and. ! ::lMulti
      ::hBmpPal2 := PalBmpLoad( aResource[ 2 ] )
   EndIf

   If ! Empty( aResource[ 3 ] ) .and. ! ::lMulti
      ::hBmpPal3 := PalBmpLoad( aResource[ 3 ] )
   EndIf

   If ! Empty( aResource[ 4 ] ) .and. ! ::lMulti
      ::hBmpPal4 := PalBmpLoad( aResource[ 4 ] )
   EndIf

   For nEle := 1 To Len( aFile )
      If ! Empty( aFile[ nEle ] ) .and. ! ( "." $ aFile[ nEle ] )
         aFile[ nEle ] := Alltrim( aFile[ nEle ] ) + ".bmp"
      EndIf
   Next

   If ! Empty( aFile[ 1 ] )
      If aFile[ 1 ] == aFile[ 2 ] .and. aFile[ 1 ] == aFile[ 3 ] .and. ;
         aFile[ 1 ] == aFile[ 4 ]

         ::lMulti := .T.

      EndIf
   EndIf

   If ! Empty( aFile[ 1 ] )
      If File( aFile[ 1 ] )
         ::hBmpPal1  := PalBmpRead( ::GetDC(), aFile[ 1 ] )
         ::ReleaseDC()
      EndIf
   EndIf

   If ! Empty( aFile[ 2 ] ) .and. ! ::lMulti
      If File( aFile[ 2 ] )
         ::hBmpPal2  := PalBmpRead( ::GetDC(), aFile[ 2 ] )
         ::ReleaseDC()
      EndIf
   EndIf

   If ! Empty( aFile[ 3 ] ) .and. ! ::lMulti
      If File( aFile[ 3 ] )
         ::hBmpPal3  := PalBmpRead( ::GetDC(), aFile[ 3 ] )
         ::ReleaseDC()
      EndIf
   EndIf

   If ! Empty( aFile[ 4 ] ) .and. ! ::lMulti
      If File( aFile[ 4 ] )
         ::hBmpPal4  := PalBmpRead( ::GetDC(), aFile[ 4 ] )
         ::ReleaseDC()
      EndIf
   EndIf

   If ! Empty( ::hBmpPal1 )
      If ::lV22
         PalBmpNew( ::hWnd, ::hBmpPal1[ 1 ], ::hBmpPal1[ 2 ] )
      Else
         PalBmpNew( ::hWnd, ::hBmpPal1 )
      EndIf
   EndIf

   If ! Empty( ::hBmpPal2 )
      If ::lV22
         PalBmpNew( ::hWnd, ::hBmpPal2[ 1 ], ::hBmpPal2[ 2 ] )
      Else
         PalBmpNew( ::hWnd, ::hBmpPal2 )
      EndIf
   EndIf

   If ! Empty( ::hBmpPal3 )
      If ::lV22
         PalBmpNew( ::hWnd, ::hBmpPal3[ 1 ], ::hBmpPal3[ 2 ] )
      Else
         PalBmpNew( ::hWnd, ::hBmpPal3 )
      EndIf
   EndIf

   If ! Empty( ::hBmpPal4 )
      If ::lV22
         PalBmpNew( ::hWnd, ::hBmpPal4[ 1 ], ::hBmpPal4[ 2 ] )
      Else
         PalBmpNew( ::hWnd, ::hBmpPal4 )
      EndIf
   EndIf

Return Nil

* ============================================================================
* METHOD TSButton:Lostfocus() Version 1.0 1/Dec/2001
* ============================================================================

METHOD LostFocus() CLASS TSButton

   If ! ::lDrag
      If ::oWnd:ClassName() != "TDIALOG" .or. ;
         ( ::oWnd:oWnd != Nil .and. ;
         ( ::oWnd:oWnd:ClassName() == "TFOLDER" .or. ;
           ::oWnd:oWnd:ClassName() == "TPAGES" ) )
         ::SendMsg( BM_SETSTYLE, BS_PUSHBUTTON, 1 )
      EndIf
   EndIf

   Super:LostFocus()

   ::lFocused := .F.
   ::Paint()

Return 0

* ============================================================================
* METHOD TSButton:MouseMove() Version 1.0 1/Dec/2001
* ============================================================================

METHOD MouseMove( nRow, nCol, nKeyFlags ) CLASS TSButton

   Local nWidth, lDlg

   If ::oDragCursor != Nil
      Return Super:MouseMove( nRow, nCol, nKeyFlags )
   EndIf

   If ::lProcessing
      Return 0
   EndIf

   If IsOverWnd( ::hWnd, nRow, nCol ) .and. ! ::lPressed
      If ! ::lCaptured
         ::Capture()
         If ! ::lMouseOver
            ::lMouseOver := .T.
            ::Paint()
         EndIf
      EndIf
   ElseIf ! ::lPressed .and. ! ::lWorking
      If ::lMouseOver
         ::lMouseOver := .F.
         ::lMenuPress := .F.
         ::cToolTip := ::cTipTool
         ::Paint()
      EndIf
      ReleaseCapture()

   EndIf

   ::oWnd:SetMsg( ::cMsg )
   ::CheckToolTip()
   CursorHand()

Return 0

* ============================================================================
* METHOD TSButton:nRows() Version 1.0 1/Dec/2001
* ============================================================================

METHOD nRows() CLASS TSButton

   Local nAt, cRest, ;
         nOcurs := 0

   If ( nAt := At( Chr( 13 ), ::cCaption ) ) > 0

      nOcurs := 1
      cRest := Substr( ::cCaption, nAt + 2 )

      While ( nAt := At( Chr( 13 ), cRest ) ) > 0
         nOcurs++
         cRest := Substr( cRest, nAt + 2 )
      EndDo

   EndIf

Return nOcurs + 1

* ============================================================================
* METHOD TSButton:Paint() Version 1.0 1/Dec/2001
* ============================================================================

METHOD Paint() CLASS TSButton

   Local nWidth, lDlg, nBmpH, lNoBmp, hBmpPal, hPalette, lBox, nClrTo, ;
         nClip    := 0, ;
         lHorz    := .F., ;
         nCaptPos := ::nCaptPos, ;
         nClrText := If( ValType( ::nClrFore ) == "B", Eval( ::nClrFore, Self ), ;
                         ::nClrFore ), ;
         nClrPane := If( ValType( ::nClrBack ) == "B", Eval( ::nClrBack, Self ), ;
                         ::nClrBack ), ;
         hBrush   := If( ::oPBrush != Nil, ::oPBrush:hBrush, 0 ), ;
         lOpaque  := ::lOpaque, ;
         lMenu    := ::bMenu != Nil, ;
         lFocused := ::lFocused, ;
         nBorder  := ::nBorder, ;
         cClassName := If( ::hWnd != Nil, Upper( ::oWnd:ClassName ), "" )

   Local hBmpPal1 := ::hBmpPal1, ;
         hBmpPal2 := ::hBmpPal2, ;
         hBmpPal3 := ::hBmpPal3, ;
         hBmpPal4 := ::hBmpPal4

   If ::hWnd == Nil .or. ::hWnd == 0 .or. nBorder == Nil
      Return 0
   EndIf

   lNoBmp := Empty( hBmpPal1 ) .and. Empty( hBmpPal2 ) .and. ;
             Empty( hBmpPal3 ) .and. Empty( hBmpPal4 )

   If ! lNoBmp
      nBmpH := If( ! ::lV22, nBmpHeight( hBmpPal1 ), nBmpHeight( hBmpPal1[ 1 ] ) )
      If nBmpH > ::nHeight
         ::_nHeight( nBmpH )
      End
   Else
      nCaptPos := 0
   EndIf

   If ! Empty( hBmpPal2 ) .and. Empty( hBmpPal4 )
      hBmpPal4 := hBmpPal2
   EndIf

   Do Case
      Case  ( ! IsWindowEnabled( ::hWnd ) .or. ::nWakeUp > 0 ) .and. ;
            ( ! Empty( hBmpPal3 ) .or. ::lMulti )
         If ! ::lMulti
            hBmpPal  := If( ::lV22, hBmpPal3[ 1 ], hBmpPal3 )
            hPalette := If( ::lV22, hBmpPal3[ 2 ], 0 )
         EndIf

         nClip := If( ::lMulti, 3, 0 )

      Case  ::lPressed .and. ( ! Empty( hBmpPal2 )  .or. ::lMulti )
         If ! ::lMulti
            hBmpPal  := If( ::lV22, hBmpPal2[ 1 ], hBmpPal2 )
            hPalette := If( ::lV22, hBmpPal2[ 2 ], 0 )
         EndIf
         nClip := If( ::lMulti, 2 , 0 )

      Case ::lMouseOver .and. ( ! Empty( hBmpPal4 )  .or. ::lMulti )
         If ! ::lMulti
            hBmpPal  := If( ::lV22, hBmpPal4[ 1 ], hBmpPal4 )
            hPalette := If( ::lV22, hBmpPal4[ 2 ], 0 )
         EndIf
         nClip := If( ::lMulti, 4, 0 )

      Case ! Empty( hBmpPal1 )
         hBmpPal  := If( ::lV22, hBmpPal1[ 1 ], hBmpPal1 )
         hPalette := If( ::lV22, hBmpPal1[ 2 ], 0 )
         nClip := If( ::lMulti, 1, 0 )

   EndCase

   If ::lMulti
      hBmpPal  := If( ::lV22, hBmpPal1[ 1 ], hBmpPal1 )
      hPalette := If( ::lV22, hBmpPal1[ 2 ], 0 )
   EndIf

   lFocused := If( ! lAnd( ::nStyle, WS_TABSTOP ) .or. ;
               cClassName == "TBAR" .or. ;
               cClassName == "TSBAR", .F., lFocused )

   lBox := If( nBorder == 0, .F., ;
           If( ::lPressed .or. nBorder == 2, .T., ;
           If( nBorder == 1 .and. ::lMouseOver, .T., .F. ) ) )

   If nBorder = 1 .and. cClassName != "TBAR" .and. cClassName != "TSBAR" .and. ;
      ! ::l97Look
      lBox = .T.
   EndIf

   If ValType( nClrPane ) == "A"
      If Len( nClrPane ) > 2 .and. Valtype( nClrPane[ 3 ] ) == "L"
         lHorz := nClrPane[ 3 ]
      EndIf
      nClrTo   := nClrPane[ 2 ]
      nClrPane := nClrPane[ 1 ]
   Else
      lHorz := .F.
      nClrTo := 0
   EndIf

   If ::nWakeup > 0
      lBox := .F.
   EndIf

   SBtnPaint( ::hWnd, hBmpPal, hPalette, ::lPressed, ::oFont:hFont, ;
              ::cCaption, nCaptPos, nClrText, nClrPane, ::lMouseOver, ;
              lOpaque, hBrush, ::nRows(), ::l97Look, ::lAdjust, lMenu, ;
              ::lMenuPress, lFocused, ::lV22, nBorder == 2, lBox, nClip, ;
              nClrTo, lHorz )

   If ! IsWindowEnabled( ::hWnd ) .and. Empty( ::hBmpPal3 ) .and. ! ::lMulti
      BtnDisabled( ::hWnd )
   EndIf

Return 0

* ============================================================================
* METHOD TSButton:RButtonDown() Version 1.0 1/Dec/2001
* ============================================================================

METHOD RButtonDown( nRow, nCol, nKeyFlags ) CLASS TSButton

   If ::lProcessing .or. ( ::nWakeup > 0 .and. ::nWakeup != VK_RBUTTON )
      Return 0
   EndIf

   If ::nWakeup > 0
      ::nWakeup := 0
   EndIf

   If ::bRClicked != Nil
      ::lProcessing := .T.
      Eval( ::bRClicked, Self, nRow, nCol )
      ::lMouseOver := .F.
      ::lProcessing := .F.
      ::Paint()
   Endif

Return 0

* ============================================================================
* METHOD TSButton:RButtonUp() Version 1.0 1/Dec/2001
* ============================================================================

METHOD RButtonUp( nRow, nCol, nKeyFlags ) CLASS TSButton

   If ::lProcessing
      Return 0
   EndIf

   If ::bRButtonUp != nil
      Eval( ::bRButtonUp, nRow, nCol, nKeyFlags )
   EndIf

Return Nil

* ============================================================================
* METHOD TSButton:Refresh() Version 1.0 1/Dec/2001
* ============================================================================

METHOD Refresh( lRepaint ) CLASS TSButton

   If ::hWnd != Nil .and. ::hWnd > 0 .and. ;
      ( Upper( ::oWnd:ClassName ) == "TBAR" .or. ;
        Upper( ::oWnd:ClassName ) == "TSBAR" )
      ::oWnd:AEvalWhen()
   ElseIf ::hWnd == Nil .or. ::hWnd == 0
      Return 0
   EndIf

   Super:Refresh( lRepaint )

Return 0

* ============================================================================
* METHOD TSButton:SetColor() Version 1.0 1/Dec/2001
* ============================================================================

METHOD SetColor( nClrText, nClrPane ) CLASS TSButton

   Local nClr := If( Valtype( nClrText ) == "B", Eval( nClrText ), nClrText )

   If ValType( nClr ) == "N"
      ::nClrFore := nClrText
   EndIf

   nClr := If( Valtype( nClrPane ) == "B", Eval( nClrPane ), nClrPane )

   If ValType( nClr ) == "N"
      ::nClrBack := nClrPane
   EndIf

   ::Refresh( .T. )

Return Self

* ============================================================================
* METHOD TSButton:SetText() Version 1.0 1/Dec/2001
* ============================================================================

METHOD SetText( cCaption ) CLASS TSButton

   If ! Empty( cCaption ) .and. ValType( cCaption ) == "C"
      ::cCaption := cCaption
      SetWindowText( ::hWnd, cCaption )
      ::Refresh( .T. )
   EndIf

Return Self

* ============================================================================
* FUNCTION TSButton CheckBmpPal() Version 1.0 1/Dec/2001
* ============================================================================

Static Function CheckBmpPal()

   Local xVar , ;
         oBmp   := TBitmap():Define( "Test" ), ;
         bError := ErrorBlock( { | x | Break( x ) } )

   Begin Sequence
      xVar := oBmp:hBmpPal
   Recover
      ErrorBlock( bError )
      oBmp:End()
      Return .T.
   End Sequence

   ErrorBlock( bError )
   oBmp:End()

Return .F.

* ============================================================================
* METHOD TSButton:NewGroup() Version 1.0 1/Dec/2001
* ============================================================================

METHOD NewGroup( aBtn, nTop, nLeft, aPrompt, oWnd, aResource, aFile, aSize, ;
                 lPixel, aAction, bWhen, bValid, lDefault, oFont, cMsg, ;
                 cToolTip, nHelpId, nBorder, lCancel, lAdjust, aColors, ;
                 nCaptPos, lOpaque, oPBrush, lW97, bMenu ) CLASS TSButton

   Local nFntWidth, nFntHeight, nEle, nSub, nAct, nTop1, nLeft1, ;
         aSizTmp := Array( 2 )

   If aSize != Nil
      Aeval( aSize, { | nSize, nEle | aSizTmp[ nEle ] := nSize } )
   EndIf

   nFntWidth  = If( oFont != Nil .and. oFont:nWidth != Nil, oFont:nWidth,    7 )
   nFntHeight = If( oFont != Nil .and. oFont:nHeight != Nil, oFont:nHeight, 10 )

   Default aSizTmp[ 1 ] := ( Len( aPrompt[ 1 ] ) + 2 ) * nFntWidth, ;
           aSizTmp[ 2 ] := nFntHeight + Int( nFntHeight / 4 )

   nAct   := 1
   nTop1  := nTop
   nLeft1 := nLeft

   For nEle := 1 To Len( aBtn )
      If ValType( aBtn[ nEle ] ) == "A"
         For nSub := 1 To Len( aBtn[ nEle ] )

            aBtn[ nEle, nSub ] := TSButton():New( nTop1, nLeft1, aPrompt[ nAct ], ;
                                     oWnd, aResource, aFile, aSize, lPixel, ;
                                     aAction[ nAct++ ], bWhen, bValid,, ;
                                     oFont, cMsg, cToolTip , nHelpId, ;
                                     nBorder, lCancel, lAdjust, aColors, ;
                                     nCaptPos, lOpaque, oPBrush, lW97, ;
                                     bMenu, .T. )

            nLeft1 += ( aSizTmp[ 1 ] + 1 )
         Next

         nTop1 += ( aSizTmp[ 2 ] + 1 )
         nLeft1 := nLeft
      Else
         aBtn[ nEle ] := TSButton():New( nTop1, nLeft1, aPrompt[ nAct ], ;
                                  oWnd, aResource, aFile, aSize, lPixel, ;
                                  aAction[ nAct++ ], bWhen, bValid,, ;
                                  oFont, cMsg, cToolTip , nHelpId, ;
                                  nBorder, lCancel, lAdjust, aColors, ;
                                  nCaptPos, lOpaque, oPBrush, lW97, ;
                                  bMenu, .T. )

         nLeft1 += ( aSizTmp[ 1 ] + 1 )
      EndIf
   Next

Return Nil