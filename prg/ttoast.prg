//
// Cristobal Navarro Lopez ( 10/03/2016 )
// Class TToast Notification
// Last Modification 14/10/2018

#include "fivewin.ch"
#include "colores.ch"

#define CW_USEDEFAULT             32768
#define SRCCOPY                13369376

#define DT_TOP               0x00000000
#define DT_LEFT              0x00000000
#define DT_CENTER            0x00000001
#define DT_RIGHT             0x00000002
#define DT_VCENTER           0x00000004
#define DT_BOTTOM            0x00000008
#define DT_WORDBREAK         0x00000010
#define DT_SINGLELINE        0x00000020
#define DT_EXPANDTABS        0x00000040
#define DT_TABSTOP           0x00000080
#define DT_NOCLIP            0x00000100
#define DT_EXTERNALLEADING   0x00000200
#define DT_CALCRECT          0x00000400
#define DT_NOPREFIX          0x00000800
#define DT_INTERNAL          0x00001000

#define CS_DROPSHADOW        0x00020000
#define WS_EX_TOOLWINDOW     0x00000080

#define LWA_ALPHA            0x00000002
#define LWA_COLORKEY         0x00000001
#define GWL_EXSTYLE                 -20
#define WS_EX_LAYERED            524288

//----------------------------------------------------------------------------//

Static aTToast   := {}
Static nTimeHide := 0.003

//----------------------------------------------------------------------------//

CLASS TToast FROM TWindow

   CLASSDATA lRegistered AS LOGICAL

   DATA lSplitHdr        AS LOGICAL INIT .F.
   DATA lLeft            AS LOGICAL INIT .F.

   DATA lLineHeader      AS LOGICAL INIT .F.
   DATA lLineFoot        AS LOGICAL INIT .F.
   DATA lBorder          AS LOGICAL INIT .T.
   DATA lBtnClose        AS LOGICAL INIT .T.
   DATA lBtnSetup        AS LOGICAL INIT .T.

   DATA cHeader
   DATA cBmpLeft         AS CHARACTER INIT  ""
   DATA cBody
   DATA cBmpFoot         AS CHARACTER INIT  ""
   DATA cFoot
   DATA lRightAlignBody  AS LOGICAL INIT .F.

   DATA cLibHeader
   DATA cBmpHeader
   DATA cLibLeft
   DATA cLibFoot
   DATA cTumbNail        AS CHARACTER INIT ""
   DATA cHeader2         //AS CHARACTER INIT  Space( 255 )

   DATA nClrPane2
   DATA nClrBorder       AS NUMERIC INIT 0
   DATA nClrSepara1      AS NUMERIC INIT RGB( 157, 188, 219 )
   DATA nClrSepara2      AS NUMERIC INIT CLR_WHITE

   DATA nClrTextHeader
   DATA nClrTextBody
   DATA nClrTextFoot

   DATA oFontHdr
   DATA oFontHdr2
   DATA oFontBody
   DATA oFontFoot

   DATA aHeader          AS ARRAY INIT { 0, 0, 0, 0 }
   DATA aHeader2         AS ARRAY INIT { 0, 0, 0, 0 }
   DATA aBody            AS ARRAY INIT { 0, 0, 0, 0 }
   DATA aLeft            AS ARRAY INIT { 0, 0, 0, 0 }
   DATA aRight           AS ARRAY INIT { 0, 0, 0, 0 }
   DATA aFoot            AS ARRAY INIT { 0, 0, 0, 0 }
   DATA aBtnClose        AS ARRAY INIT { 0, 0, 0, 0 }

   DATA nWRadio
   DATA nHRadio
   DATA nGetColor

   DATA aOldPos
   DATA nOldRow
   DATA nOldCol
   DATA hRgn
   DATA nMResize

   DATA nFixWidth
   DATA nFixHeight
   DATA bBmpHdr
   DATA bBmpLeft
   DATA bOwnerDraw
   DATA bBmpFoot

   DATA oTimer
   DATA lShowAgain
   DATA nTimer
   DATA lAlert
   DATA oWndEvent
   DATA lRightAlignFoot  AS LOGICAL INIT .F.
   DATA bMnuFoot
   DATA lUpPos
   DATA lLeftPos         AS LOGICAL INIT .F.
   DATA lHistory         AS LOGICAL INIT .F.
   DATA nIT              AS NUMERIC INIT 0
   DATA bReturn
   DATA nToast
   DATA aCtrlsH          AS ARRAY INIT {}
   DATA aCtrlsB          AS ARRAY INIT {}
   DATA aCtrlsL          AS ARRAY INIT {}
   DATA aCtrlsR          AS ARRAY INIT {}
   DATA aCtrlsF          AS ARRAY INIT {}

   DATA nLevel           AS NUMERIC INIT 255
   DATA l2007            AS LOGICAL INIT .F.

   DATA nXOffSet         INIT 0
   DATA nYOffSet         INIT 0

   DATA lWordBreak       INIT .T.
   DATA lCenterText      INIT .F.

   METHOD New( nTop, nLeft, nWidth, nHeight, oWnd, lDisenio, nClrPane, nClrPane2,;
               nClrText, nWRadio, nHRadio, nLev, lShadow, lAlert, nTime, lUp, ;
               cFace, nFont, bRet, lLeftP, l2007 ) CONSTRUCTOR
   METHOD NewToast( nType, cText, cBmp, nWidth, nHeight, oWnd, nClrPane, nClrPane2, ;
                 nClrText, nLev, nTime, lUp, bRet, lLeftP, lAlert, lShadow, ;
                 nOffY, nOffX, nFont )
   METHOD ActivaAlert( oWnd )
   METHOD AddToast() INLINE AAdd( aTToast, Self )
   METHOD DelToast( n ) INLINE ( n := if( Empty( n ), ::nIT, n ), ;
                                 ADel( aTToast, ::nIT ), ;
                                 ASize( aTToast, Len( aTToast ) - 1 ) )
   METHOD Initialize() INLINE aTToast := {}
   //METHOD History()
   METHOD aToast() INLINE aTToast
   METHOD BuildTimer()
   METHOD CreateFromCode() INLINE ::ActivaAlert()
   METHOD Default()
   METHOD Destroy()
   METHOD Display()  INLINE ( ::BeginPaint(), ::Paint(), ::EndPaint(), 0 )
   METHOD EndPaint() INLINE ( ::nPaintCount--, EndPaint( ::hWnd, ::cPS ), ::cPS := nil, ::hDC := nil, 0 )
   METHOD GetDefaultSize()
   //METHOD GetSize()
   METHOD lBody() INLINE !Hb_IsNil( ::cBody )
   METHOD lHeader() INLINE !Hb_IsNil( ::cHeader )
   METHOD lFoot()   INLINE !Hb_IsNil( ::cFoot )
   METHOD LButtonDown( nRow, nCol, nKeyFlags, lTouch )
   METHOD LButtonUp( nRow, nCol, nFlags )
   METHOD LDblClick( nRow, nCol, nKeyFlags )
   METHOD MouseMove( nRow, nCol, nKeyFlags )
   //METHOD MouseWheel( nKeys, nDelta, nXPos, nYPos )
   METHOD MnuPopupFoot()
   //METHOD HandleEvent( nMsg, nWParam, nLParam )
   METHOD Paint()
   METHOD PaintHdr( hDC, rc )
   METHOD PaintHdr2( hDC, rc )
   METHOD PaintBody( hDC, rc )
   METHOD PaintFoot( hDC, rc )
   METHOD PaintToast( hDC, rc )
   METHOD RButtonDown( nRow, nCol, nFlags )
   METHOD ReSize( nSizeType, nWidth, nHeight )
   METHOD SetSize( nWidth, nHeight ) INLINE ::Super:SetSize( nWidth, nHeight, .T. )
   METHOD TToolWindow()

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( nTop, nLeft, nWidth, nHeight, oWnd, lDisenio, nClrPane, nClrPane2,;
            nClrText, nWRadio, nHRadio, nLev, lShadow, lAlert, nTime, lUp, ;
            cFace, nFont, bRet, lLeftP, l2007 ) CLASS TToast

   local nStyle
   local nStyleEx    := WS_EX_TOOLWINDOW  //WS_EX_LEFTSCROLLBAR
   local nBottom
   local nRight
   DEFAULT lAlert    := .T.
   DEFAULT nTime     := 5000
   DEFAULT nFont     := -12
   DEFAULT lUp       := .F.
   DEFAULT bRet      := { || .T. }
   DEFAULT lLeftP    := .F.
   DEFAULT l2007     := .F.

   ::l2007   := l2007
   //if ! ::l2007
   if IsWin8() .or. IsWindows10()
      DEFAULT nClrPane  := Rgb( 20, 20, 20 ) //44, 44, 44 )
      DEFAULT nClrPane2 := nClrPane
      DEFAULT nClrText  := CLR_WHITE
      DEFAULT cFace     := "Segoe MDL2 Assets" //"Segoe UI" //Calibri
      DEFAULT nWRadio   := 2
      DEFAULT nHRadio   := 2
      DEFAULT nLev      := 222
      DEFAULT lShadow   := .T.
   else
      DEFAULT nClrPane  := CLR_WHITE
      DEFAULT nClrPane2 := nClrPane
      DEFAULT nClrText  := 0
      DEFAULT cFace     := "Tahoma"  //"Verdana"
      DEFAULT nWRadio   := 2
      DEFAULT nHRadio   := 2
      DEFAULT nLev      := 255
      DEFAULT lShadow   := .T.
   endif
   //::nClrPane   := nClrPane
   ::nClrPane2  := nClrPane2
   //::nClrText   := nClrText
   ::nClrBorder := RGB( 118, 118, 118 )
   nStyle       := nOR( WS_POPUP )
   ::nLevel     := nLev
   ::lAlert     := lAlert
   ::lUpPos     := lUp
   ::bReturn    := bRet
   ::oWndEvent  := oWnd
   ::lLeftPos   := lLeftP
   if ::lAlert
      if !::lLeftPos
         if ! ::lUpPos
            nTop      := ScreenHeight() - nHeight - 1 //- if( lShadow, 4, 0 )
            nLeft     := ScreenWidth()  - nWidth  - 1 //- if( lShadow, 8, 5 )
         else
            nTop      := 1 // 22 * if( IsWin8() .or. IsWindows10(), 2, 1 )
            nLeft     := ScreenWidth()  - nWidth  - 1 //if( lShadow, 4, 4 )
         endif
      else
         if ! ::lUpPos
            nTop      := ScreenHeight() - nHeight - 1 //if( lShadow, 4, 0 )
            nLeft     := 1 //if( lShadow, 8, 5 )
         else
            nTop      := 1 //22 * if( IsWin8() .or. IsWindows10(), 2, 1 )
            nLeft     := 1 //if( lShadow, 4, 2 )
         endif
      endif
      oWnd      := nil
   endif
   nTop         -= ::nYOffSet
   nLeft        -= ::nXOffSet
   nBottom      := nTop  + nHeight
   nRight       := nLeft + nWidth
   if ::lAlert
      ::Super:New( nTop, nLeft, nBottom, nRight,, nStyle,,,, nil,,, nClrText, nClrPane,,,,,,,.T., nStyleEx,,,)
   endif

   ::nWRadio    := nWRadio
   ::nHRadio    := nHRadio
   ::nTimer     := nTime
   ::lShowAgain := .T.
   ::cTitle     := "Title"

   DEFINE FONT ::oFontHdr   NAME cFace      SIZE 0, nFont - 9 BOLD
   DEFINE FONT ::oFontHdr2  NAME cFace      SIZE 0, nFont - 6
   DEFINE FONT ::oFontBody  NAME "Calibri"  SIZE 0, nFont - 6
   DEFINE FONT ::oFontFoot  NAME cFace      SIZE 0, nFont - 10 //BOLD

   if !::lAlert
      ::oWnd       := oWnd
      ::nTop       := nTop
      ::nLeft      := nLeft
      ::nBottom    := nBottom
      ::nRight     := nRight
      ::nStyle     := nStyle

      ::Register( nOR( CS_VREDRAW, CS_HREDRAW, IF( lShadow, CS_DROPSHADOW, 0 ) ) ) //, 131072
      ::Create()
   else
      if lShadow
         ::Shadow()
      endif
   endif
   SetTransparent( Self, nLev, )  //nClrPane

   ::hRgn    := nil
   ::Default( .T. )
   ::nToast  := 0

return Self

//----------------------------------------------------------------------------//

METHOD NewToast( nType, cText, cBmp, nWidth, nHeight, oWnd, nClrPane, nClrPane2, ;
                 nClrText, nLev, nTime, lUp, bRet, lLeftP, lAlert, lShadow, ;
                 nOffY, nOffX, nFont ) CLASS TToast

   local nStyle
   local nTop
   local nLeft
   local nBottom
   local nRight
   local nStyleEx    := WS_EX_TOOLWINDOW  //WS_EX_LEFTSCROLLBAR
   local nWRadio
   local nHRadio
   local cFace
   local aPoint

   DEFAULT lShadow   := .T.
   DEFAULT lAlert    := .T.
   DEFAULT nTime     := 5000
   DEFAULT lUp       := .F.
   DEFAULT bRet      := { || .T. }
   DEFAULT nWidth    := 290
   DEFAULT nHeight   := 128
   DEFAULT nType     := 1
   DEFAULT lLeftP    := .F.
   DEFAULT nOffY     := 0
   DEFAULT nOffX     := 0
   DEFAULT nFont     := -12

   if IsWin8() .or. IsWindows10()
      DEFAULT nClrPane  := Rgb( 44, 44, 44 )
      DEFAULT nClrPane2 := nClrPane
      DEFAULT nClrText  := CLR_WHITE
      DEFAULT cFace     := "Segoe UI Symbol" //Calibri
      DEFAULT nWRadio   := 2
      DEFAULT nHRadio   := 2
      DEFAULT nLev      := 222
   else
      DEFAULT nClrPane  := CLR_WHITE
      DEFAULT nClrPane2 := nClrPane
      DEFAULT nClrText  := 0
      DEFAULT cFace     := "Tahoma"  //"Verdana"
      DEFAULT nWRadio   := 2
      DEFAULT nHRadio   := 2
      DEFAULT nLev      := 255
   endif
   nStyle       := nOR( WS_POPUP )
   ::nClrPane   := nClrPane
   ::nClrPane2  := nClrPane2
   ::nClrText   := nClrText
   ::nClrBorder := RGB( 118, 118, 118 )
   ::nWRadio    := nWRadio
   ::nHRadio    := nHRadio
   ::nLevel     := nLev
   ::lAlert     := lAlert
   ::lUpPos     := lUp
   ::bReturn    := bRet
   ::oWndEvent  := oWnd
   ::nToast     := nType
   ::lLeftPos   := lLeftP
   ::nYOffSet   := nOffY
   ::nXOffSet   := nOffX
   if ::lAlert
      if !::lLeftPos
         if ! ::lUpPos
            nTop      := if( !Hb_IsNil( ::oWndEvent ), ::oWndEvent:GetCliAreaRect()[ 3 ], ScreenHeight() ) - ;
                              nHeight - if( lShadow, 4, 0 )
            nLeft     := if( !Hb_IsNil( ::oWndEvent ), ::oWndEvent:GetCliAreaRect()[ 4 ], ScreenWidth() ) - ;
                              nWidth  - if( lShadow, 4, 2 )
         else
            nTop      := 2
            nLeft     := if( !Hb_IsNil( ::oWndEvent ), ::oWndEvent:GetCliAreaRect()[ 4 ], ScreenWidth() ) - ;
                              nWidth  - if( lShadow, 4, 0 )
         endif
      else
         if ! ::lUpPos
            nTop      := if( !Hb_IsNil( ::oWndEvent ), ::oWndEvent:GetCliAreaRect()[ 3 ], ScreenHeight() ) - ;
                              nHeight - if( lShadow, 4, 0 )
            nLeft     := if( lShadow, 4, 2 )
         else
            nTop      := 2
            nLeft     := if( lShadow, 4, 2 )
         endif
      endif
   endif
   nTop          -= ::nYOffSet
   nLeft         -= ::nXOffSet
   nWidth        := Max( nWidth, 100 )
   nHeight       := Max( nHeight, 36 )
   nBottom       := nTop  + nHeight
   nRight        := nLeft + nWidth
   if ::lAlert
      if !Empty( ::oWndEvent )
         aPoint  := ClientToScreen( ::oWndEvent:hWnd, { nTop, nLeft } )
         aPoint  := ScreenToClient( ::hWnd, aPoint )
         aPoint[ 1 ] -= 2
         nTop    := aPoint[ 1 ]
         nLeft   := aPoint[ 2 ]
         nBottom := aPoint[ 1 ] + nHeight
         nRight  := aPoint[ 2 ] + nWidth
      endif
      ::Super:New( nTop, nLeft, nBottom, nRight,, nStyle,,,, ::oWndEvent,,, nClrText, nClrPane,,,,,,,.T., nStyleEx,,,)
   endif

   ::nTimer     := nTime
   ::lShowAgain := .T.
   ::cTitle     := "Title"

   DEFINE FONT ::oFontHdr   NAME cFace      SIZE 0, nFont - 6 BOLD
   DEFINE FONT ::oFontHdr2  NAME cFace      SIZE 0, nFont
   DEFINE FONT ::oFontBody  NAME "Calibri"  SIZE 0, nFont - 6
   DEFINE FONT ::oFontFoot  NAME cFace      SIZE 0, nFont - 10 //BOLD

   if !::lAlert
      ::Register( nOR( CS_VREDRAW, CS_HREDRAW, IF( lShadow, CS_DROPSHADOW, 0 ) ) ) //, 131072
      ::Create()
   else
      if lShadow
         ::Shadow()
      endif
   endif
   SetTransparent( Self, nLev, )  //nClrPane

   ::hRgn   := nil
   ::Default( .T. )

   ::cBody     := cText
   if !hb_IsNil( cBmp )
      ::cBmpLeft  := cBmp
      ::lLeft     := .T.
   endif

   ::bInit   := { || Self:TToolWindow(), ;
                     if( !HB_IsNIL( ::oWndEvent ), Self:oWndEvent:SetFocus(), ), ;
                     Self:nIT := Len( aTToast ), ;
                     if( Self:lHistory, Self:AddToast(), ) }

return Self


//----------------------------------------------------------------------------//

METHOD ActivaAlert() CLASS TToast

   local n
   local oBtnC
   local oBtnS
   local nRow
   local nCol
   local rc     := { 0, 0, ::nHeight, ::nWidth }
   local o      := Self

   if !Empty( ::aCtrlsH ) //.and. ::lHeader()
      For n = 1 to Len( ::aCtrlsH )
          ::aCtrlsH[ n ][ 2 ] := Eval( ::aCtrlsH[ n ][ 1 ], Self )
      Next n
   endif

   if !Empty( ::aCtrlsL ) //.and. ::lHeader()
      For n = 1 to Len( ::aCtrlsL )
          ::aCtrlsL[ n ][ 2 ] := Eval( ::aCtrlsL[ n ][ 1 ], Self )
      Next n
   endif
   if !Empty( ::aCtrlsR ) //.and. ::lHeader()
      For n = 1 to Len( ::aCtrlsR )
          ::aCtrlsR[ n ][ 2 ] := Eval( ::aCtrlsR[ n ][ 1 ], Self )
      Next n
   endif
   if !Empty( ::aCtrlsB ) //.and. ::lHeader()
      For n = 1 to Len( ::aCtrlsB )
          ::aCtrlsB[ n ][ 2 ] := Eval( ::aCtrlsB[ n ][ 1 ], Self )
      Next n
   endif
   if !Empty( ::aCtrlsF ) //.and. ::lHeader()
      For n = 1 to Len( ::aCtrlsF )
          ::aCtrlsF[ n ][ 2 ] := Eval( ::aCtrlsF[ n ][ 1 ], Self )
      Next n
   endif
   if ::lBtnClose
      @ rc[ 1 ] + 2, rc[ 4 ] - 34 FLATBTN oBtnC PROMPT "x" ;
         SIZE 30, 30 ;
         COLOR ::nClrTextHeader, ::nClrPane OF Self ;
         FONT ::oFontHdr2 ;
         ACTION ( o:BuildTimer( .T. ), o:End() ) ;
         NOBORDER
   endif
   if ::lBtnSetup
      @ if( ::lFoot(), rc[ 3 ] - 36, rc[ 1 ] + 2 ), ;
        if( ::lFoot(), rc[ 4 ] - 36, rc[ 4 ] - 36 ) ;
         FLATBTN oBtnS PROMPT Hb_Utf8Chr( 57621 ) ;
         SIZE 34, 34 ;
         COLOR ::nClrTextHeader, ::nClrPane OF Self ;
         FONT ::oFontHdr2 ;
         ACTION ( nRow := rc[ 3 ] - 36, nCol := rc[ 4 ] - 36,;
                  o:MnuPopupFoot( nRow, nCol ) ) ;
         NOBORDER
   endif

   ACTIVATE WINDOW Self

Return nil

//----------------------------------------------------------------------------//

METHOD Destroy() CLASS TToast

   if !Empty( ::oFontHdr )
      ::oFontHdr :End()
   endif
   if !Empty( ::oFontHdr2 )
      ::oFontHdr2:End()
   endif
   if !Empty( ::oFontBody )
      ::oFontBody:End()
   endif
   if !Empty( ::oFontFoot )
      ::oFontFoot:End()
   endif
   if !Empty( ::hRgn )
      DeleteObject( ::hRgn )
   endif
   ::Super:Destroy()
   if ::lHistory
      ::DelToast()
   endif

Return Eval( ::bReturn ) //, oSelf

//----------------------------------------------------------------------------//

METHOD TToolWindow() CLASS TToast

   //::nExStyle   := nOr( WS_EX_TOOLWINDOW, WS_EX_TOPMOST, WS_EX_ACCEPTFILES ) //, WS_EX_NOPARENTNOTIFY )
   SetWindowLong( ::hWnd, GWL_EXSTYLE,;
                  nOr( GetWindowLong( ::hWnd, GWL_EXSTYLE ), WS_EX_TOOLWINDOW, ;
                       WS_EX_TOPMOST, WS_EX_ACCEPTFILES ) )

   //SetWindowPos( ::hWnd, 0, ::nTop, ::nLeft, ::nRight - ::nLeft + 1,;
   //              ::nBottom - ::nTop + 1, 55 )
   // 55 is nOr( SWP_NOSIZE, SWP_NOMOVE, SWP_NOZORDER,;
   // SWP_NOACTIVATE, SWP_FRAMECHANGED )

return nil

//----------------------------------------------------------------------------//

METHOD GetDefaultSize() CLASS TToast

   local rc        := GetClientRect( ::hWnd )
   local aSize     := { rc[ 3 ] - rc[ 1 ], rc[ 4 ] - rc[ 2 ] }

return aSize

//----------------------------------------------------------------------------//

METHOD MnuPopupFoot( nRow, nCol ) CLASS TToast

   local oMnu
   local oMnu1

   MENU oMnu POPUP 2015
        MENUITEM "Configuration" CHARICON 57621 //ACTION AlertConfig()
        SEPARATOR
        if ::bMnuFoot != nil
        MENUITEM "User" CHARICON 57694
        oMnu1  := Eval( ::bMnuFoot, nRow, nCol, Self )
        SEPARATOR
        endif
        MENUITEM "Exit" CHARICON 57884 ;
           ACTION ( ::oTimer:Deactivate(), ::oTimer:End(), ::End() )
   ENDMENU
   ACTIVATE MENU oMnu AT nRow, nCol OF Self

Return oMnu

//----------------------------------------------------------------------------//
/*
METHOD GetSize() CLASS TToast

   local rc        := 0
   local aSize     := { 0, 0 }
   local hBmp      := 0
   local hDC       := ::hDC //CreateCompatibleDC( ::hDC )
   local hOldFont  := 0
   local n         := 0
   local nH        := 0
   local nHBmp     := 0
   local nHText    := 0
   local nHeight   := 0
   local nLen      := 0
   local nW        := 0
   local nW2       := 0
   local nWB       := 0
   local nWBmp     := 0
   local nWBodyTxt := 227
   local nWF       := 0
   local nWH       := 0
   local nWidth    := 0
   local aHeader1  := { 0, 0, 0, 0, 0, 0 }
   local aHeader2  := { 0, 0, 0, 0, 0, 0 }
   local aBody     := { 0, 0, 0, 0, 0, 0 }
   local aLeft     := { 0, 0, 0, 0, 0, 0 }
   local aRight    := { 0, 0, 0, 0, 0, 0 }
   local aFooter   := { 0, 0, 0, 0, 0, 0 }
   local aAlert    := { 0, 0, 0, 0, 0, 0 }

   if ::nFixWidth != nil .and. ::nFixHeight != nil
	    return { ::nFixWidth, ::nFixHeight }
	 endif
	
	rc          := GetClientRect( ::hWnd )
   //nWidth      := nWBodyTxt
   For n := 1 to 4
      aHeader1[ n ] := rc[ n ]
      aHeader2[ n ] := rc[ n ]
      aBody[ n ]    := rc[ n ]
      aLeft[ n ]    := rc[ n ]
      aRight[ n ]   := rc[ n ]
      aFooter[ n ]  := rc[ n ]
      aAlert[ n ]   := rc[ n ]
   Next n

   // Header

   nHeight     := 0
   nH          := 0
   hBmp        := 0
   nWBmp       := 0
	nHBmp       := 0
   nWidth      := 0
   if ::lHeader()
      nHeight  := ::oFontHdr:nHeight * 2
      nWidth   := GetTextWidth( 0, ::cHeader, ::oFontHdr:hFont ) + 16
   endif
   if ! Empty( ::cBmpHeader )
	   hBmp     := LoadImageEx( ::cBmpHeader )
   else
      if ::bBmpHdr != nil
         hBmp   := Eval( ::bBmpHdr, Self )
      endif
   endif
   if hBmp != 0
      nWBmp    := BmpWidth ( hBmp )
      nHBmp    := BmpHeight( hBmp )
      DeleteObject( hBmp )
   endif
   aHeader1[ 3 ] := Max( nHeight, nHBmp )
   aHeader1[ 2 ] := nWBmp
   if ::lHeader()
      nH       := DrawText( hDC, AllTrim( ::cHeader ), aHeader1,;
            nOr( if( ::lRightAlignBody, DT_RIGHT, DT_LEFT ), DT_WORDBREAK, DT_CALCRECT ) )
   endif
   aHeader1[ 5 ] := nH
   aHeader1[ 6 ] := nWBmp

   // Footer

   nHeight     := 0
   nH          := 0
   hBmp        := 0
   nWBmp       := 0
	nHBmp       := 0
   nWidth      := 0
   if ::lFoot()
      nHeight  := ::oFontHdr:nHeight * 2
      nWidth   := GetTextWidth( 0, ::cFoot, ::oFontFoot:hFont ) + 16
      nH       := DrawText( hDC, AllTrim( ::cFoot ), aFooter,;
            nOr( if( ::lRightAlignBody, DT_RIGHT, DT_LEFT ), DT_WORDBREAK, DT_CALCRECT ) )
   endif
   if ! Empty( ::cBmpFoot )
	   hBmp     := LoadImageEx( ::cBmpFoot )
   else
      if ::bBmpFoot != nil
         hBmp   := Eval( ::bBmpFoot, Self )
      endif
   endif
   if hBmp != 0
      nWBmp    := BmpWidth ( hBmp )
      nHBmp    := BmpHeight( hBmp )
      DeleteObject( hBmp )
   endif
   aFooter[ 2 ] := nWBmp
   aFooter[ 3 ] := Max( nHeight, nHBmp )  //, nH
   if ::lFoot()
      nH       := DrawText( hDC, AllTrim( ::cFoot ), aFooter,;
            nOr( if( ::lRightAlignBody, DT_RIGHT, DT_LEFT ), DT_WORDBREAK, DT_CALCRECT ) )
   endif
   aFooter[ 5 ] := nH

   // Left side image

   nHeight     := 0
   nH          := 0
   hBmp        := 0
   nWBmp       := 0
   nHBmp       := 0
   nWidth      := 0
   if ! Empty( ::cBmpLeft )
       hBmp     := LoadImageEx( ::cBmpLeft )
   else
      if ::bBmpLeft != nil
         hBmp   := Eval( ::bBmpLeft, Self )
      endif
   endif
   if hBmp != 0
      nWBmp    := BmpWidth ( hBmp )
      nHBmp    := BmpHeight( hBmp )
      DeleteObject( hBmp )
   endif
   aLeft[ 1 ]  := aHeader1[ 3 ] + 1
   aLeft[ 3 ]  := aFooter[ 1 ] - 1
   aLeft[ 4 ]  := nWBmp

   // Right side

   nHeight     := 0
   nH          := 0
   hBmp        := 0
   nWBmp       := 0
	nHBmp       := 0
   nWidth      := 0
   if ::lFoot()
      nHeight  := ::oFontBody:nHeight * 2
      nWidth   := GetTextWidth( 0, ::cBody, ::oFontBody:hFont ) + 16
      nH       := DrawText( hDC, AllTrim( ::cBody ), aRight,;
            nOr( if( ::lRightAlignBody, DT_RIGHT, DT_LEFT ), DT_WORDBREAK, DT_CALCRECT ) )
   endif


   aRight[ 1 ]  := aHeader1[ 3 ] + 1
   aRight[ 3 ]  := aFooter[ 1 ] - 1
   aRight[ 3 ]  := Max( aRight[ 3 ], aRight[ 1 ] + nHeight - 1 )
   aRight[ 3 ]  := Max( aLeft[ 3 ], aRight[ 3 ] )
   aRight[ 2 ]  := aLeft[ 4 ] + 1
   aLeft[ 3 ]   := aRight[ 3 ]
   aFooter[ 1 ] := aRight[ 3 ] + 1

   aBody[ 1 ]   := aRight[ 1 ]
   aBody[ 2 ]   := aLeft[ 2 ]
   aBody[ 3 ]   := aRight[ 3 ]
   aBody[ 4 ]   := aRight[ 4 ]
   aBody[ 5 ]   := nH

   nHeight     := 0
   nH          := 0
   hBmp        := 0
   nWBmp       := 0
	nHBmp       := 0
   nWidth      := 0
   //DeleteDC( hDC )
   //aSize       := { nWidth, nHeight }
   For n := 1 to 5
      FWLOG n, aHeader1[ n ], aHeader2[ n ], aBody[ n ], aLeft[ n ], aRight[ n ], aFooter[ n ], aAlert[ n ]
   Next n

return aSize
*/
//----------------------------------------------------------------------------//

METHOD Default( lShowDlg ) CLASS TToast

   local rc         := { 0, 0, ::nHeight, ::nWidth }
   local o          := Self

   DEFAULT lShowDlg := .F.

   ::hRgn = CreateRoundRectRgn( { rc[ 1 ], rc[ 2 ], rc[ 3 ], rc[ 4 ] },;
                                ::nWRadio, ::nHRadio )
   SetWindowRgn( ::hWnd, ::hRgn, .T. )
   DeleteObject( ::hRgn )

return 0

//----------------------------------------------------------------------------//
/*
METHOD HandleEvent( nMsg, nWParam, nLParam ) CLASS TToast


   if nMsg == 20
      return 1
   endif


return ::Super:HandleEvent( nMsg, nWParam, nLParam )
*/

//----------------------------------------------------------------------------//

METHOD MouseMove( nRow, nCol, nKeyFlags ) CLASS TToast

   ::Super:MouseMove( nRow, nCol, nKeyFlags )

Return nil

//----------------------------------------------------------------------------//

METHOD RButtonDown( nRow, nCol, nFlags ) CLASS TToast

   ::Super:RButtonDown( nRow, nCol, nFlags )
   ::BuildTimer()
   ::oWndEvent:SetFocus()

Return nil

//----------------------------------------------------------------------------//

METHOD LButtonDown( nRow, nCol, nKeyFlags, lTouch ) CLASS TToast

   ::Super:LButtonDown( nRow, nCol, nKeyFlags, lTouch )
   ::BuildTimer()
   ::oWndEvent:SetFocus()

Return nil

//----------------------------------------------------------------------------//

METHOD LButtonUp( nRow, nCol, nFlags ) CLASS TToast

   ::Super:LButtonUp( nRow, nCol, nFlags )

Return nil

//----------------------------------------------------------------------------//

METHOD LDblClick( nRow, nCol, nKeyFlags ) CLASS TToast

   ::Super:LDblClick( nRow, nCol, nKeyFlags )
   ::BuildTimer()
   ::oWndEvent:SetFocus()

Return nil

//----------------------------------------------------------------------------//

METHOD ReSize( nSizeType, nWidth, nHeight ) CLASS TToast

   ::Default()
   //::Refresh()

return ::Super:ReSize( nSizeType, nWidth, nHeight )

//----------------------------------------------------------------------------//

METHOD BuildTimer( lEnd ) CLASS TToast

   DEFAULT lEnd   := .F.
   if ::oTimer != nil
      ::oTimer:Deactivate()
      ::oTimer:End()
   endif

   if !lEnd
      if ::nTimer > 0
         DEFINE TIMER ::oTimer INTERVAL ::nTimer ;
            ACTION ( ::lShowAgain := .F.,;  //::Hide(),
               ::oTimer:Deactivate(), ::oTimer:End(), ::End() ) OF Self
         ACTIVATE TIMER ::oTimer
      endif
   endif

Return nil

//----------------------------------------------------------------------------//

METHOD Paint() CLASS TToast

   local hDCMem   := ::hDC      //CreateCompatibleDC( ::hDC )
   local rc
   local nWRadio  := ::nWRadio
   local nHRadio  := ::nHRadio
   local nClrText
   local hBrush
   local hRgn
   local aInfo     := ::DispBegin()
   //local hBmpMem  := CreateCompatibleBitmap( ::hDC, rc[ 4 ] - rc[ 2 ],;
   //                                          rc[ 3 ] - rc[ 1 ] )
   //local hOldBmp  := SelectObject( hDCMem, hBmpMem )

   rc       := GetClientRect( ::hWnd )
   nClrText := SetTextColor( hDCMem, ::nClrText )
   hRgn     := CreateRoundRectRgn( { rc[ 1 ], rc[ 2 ], rc[ 3 ], rc[ 4 ] },;
                                        ::nWRadio, ::nHRadio )

   ::BuildTimer()

   rc[ 3 ]--
   rc[ 4 ]--
   nWRadio += 2
   nHRadio += 2
   VerticalGradient( hDCMem, { rc[ 1 ] - 1, rc[ 2 ], rc[ 3 ], rc[ 4 ] },;
                     ::nClrPane, ::nClrPane2 )

   if ::bOwnerDraw == nil
      if Empty( ::nToast )
         ::PaintHdr( hDCMem, rc )
         //::PaintHdr2( hDCMem, rc )
         ::PaintFoot( hDCMem, rc )
         ::PaintBody( hDCMem, rc )
      else
         ::PaintToast( hDCMem, rc )
      endif
   else
      Eval( ::bOwnerDraw, hDCMem )
   endif

   hBrush = CreateSolidBrush( ::nClrBorder )
   if ::lBorder
      FrameRgn( hDCMem, hRgn, hBrush, 1, 1 )
   endif
   DeleteObject( hBrush )
   DeleteObject( hRgn )

   SetTextColor( hDCMem, nClrText )

   DeleteDC( hDCMem )
   //BitBlt( ::hDC, 0, 0, rc[ 4 ] - rc[ 2 ], rc[ 3 ] - rc[ 1 ], hDCMem, 0, 0, SRCCOPY )
   //SelectObject( hDCMem, hOldBmp )
   //DeleteObject( hBmpMem )
   //::GetSize()
   ::DispEnd( aInfo )

return 0

//----------------------------------------------------------------------------//

METHOD PaintHdr( hDC, rc ) CLASS TToast

   local hBmpHdr
   local nWBmpHdr  := 0
   local hOldFont
   local nClrText
   local lIcon     := .F.
   local nTop
   local nMode
   local oBtnClose
   local nH        := ::oFontHdr:nHeight * 3

   ::aHeader = { rc[ 1 ], rc[ 2 ], rc[ 1 ] + if( ::lHeader, nH, 0 ), rc[ 4 ] }  //25
   //::aHeader[ 3 ] += if( ::lLineHeader, 0, 5 )
   // 25 pixels
   if ::lHeader() .or. ! Empty( ::cBmpHeader ) .or. ::lBtnClose
      if ! Empty( ::cBmpHeader )
         hBmpHdr = LoadImageEx( ::cBmpHeader )
         if hBmpHdr  != 0
            nWBmpHdr := BmpWidth( hBmpHdr )
            ::aHeader[ 3 ] += Max( BmpHeight( hBmpHdr ), ::oFontHdr:nHeight )
            nTop     := ( ::aHeader[ 1 ] + ;
                        ( ::aHeader[ 3 ] - ::aHeader[ 1 ] ) / 2 ) - ;
                        BmpHeight( hBmpHdr ) / 2
            nTop     := Max( nTop, 5 )
            DrawMasked( hDC, hBmpHdr, nTop, 5 )
            DeleteObject( hBmpHdr )
         endif
      else
         if !Empty( ::cHeader )
            ::aHeader[ 3 ] += ::oFontHdr:nHeight
         endif
      endif
      //if ::lBody() .or. ::lBtnClose
      hOldFont = SelectObject( hDC, ::oFontHdr:hFont )
      if ::nClrTextHeader != nil
         nClrText = SetTextColor( hDC, ::nCLrTextHeader )
      endif
      nMode = SetBkMode( hDC, 1 )
      if !Hb_IsNil( ::cHeader )
         DrawText( hDC, ::cHeader, { ::aHeader[ 1 ], ::aHeader[ 2 ] + 10 + ;
             If( hBmpHdr != 0, nWBmpHdr, 0 ), ::aHeader[ 3 ] - 5,;
             ::aHeader[ 4 ] - 5 - if( ::lBtnClose, 30, 0 ) }, ;
             nOr( DT_VCENTER, DT_SINGLELINE, 8192 ) )
      endif
      SetBkMode( hDC, nMode )
      if ::nClrTextHeader != nil
         SetTextColor( hDC, nClrText )
      endif
      SelectObject( hDC, hOldFont )
      //endif
      if ::lLineHeader
         Line( hDC, ::aHeader[ 3 ], ::aHeader[ 2 ] + 5, ::aHeader[ 3 ],;
               ::aHeader[ 4 ] - 5, ::nClrSepara1, )
      endif
   else
      ::aHeader = { rc[ 1 ], rc[ 2 ], rc[ 1 ], rc[ 4 ] }
   endif

return 0

//----------------------------------------------------------------------------//

METHOD PaintHdr2( hDC, rc ) CLASS TToast

   local hOldFont
   local nClrText

   ::aHeader2 = { ::aHeader[ 3 ], rc[ 2 ], ::aHeader[ 3 ], rc[ 4 ] }

   if ::lHeader
      if ::lSplitHdr
         ::aHeader2 = { ::aHeader[ 3 ], rc[ 2 ], ::aHeader[ 3 ] + 25, rc[ 4 ] }
      endif

      if ::lLineHeader
         Line( hDC, ::aHeader2[ 3 ], ::aHeader2[ 2 ] + 5, ::aHeader2[ 3 ],;
               ::aHeader2[ 4 ] - 5, ::nClrSepara1 )
      endif

      hOldFont = SelectObject( hDC, ::oFontHdr2:hFont )

      if ::nClrTextHeader != nil
         nClrText := SetTextColor( hDC, ::nCLrTextHeader )
      endif

      if ::lSplitHdr .and. ! Empty( ::cHeader2 )
         DrawText( hDC, ::cHeader2, { ::aHeader2[ 1 ] + 1, ::aHeader2[ 2 ] + 20,;
                   ::aHeader2[ 3 ], ::aHeader2[ 4 ] - 2 }, nOR( DT_WORDBREAK, 8192 ) )
      endif

      if ::nClrTextHeader != nil
         SetTextColor( hDC, nClrText )
      endif

      SelectObject( hDC, hOldFont )
  endif

return 0

//----------------------------------------------------------------------------//

METHOD PaintBody( hDC, rc ) CLASS TToast

   local hOldFont
   local nWBmp    := 0
   local nHBmp    := 0
   local nClrText
   local lIcon    := .F.
   local nMode
   local hBmpLeft := 0
   local n
   local nLen
   local nW
   local nW2
   local aLeft
   local nTop
   local nH       := 0

   ::aLeft = { 0, 0, 0, 0, 0, 0 }
   ::aBody = { ::aHeader[ 3 ] + If( ::lLineHeader, 5, 0 ), rc[ 2 ],;
               if( ::lFoot(), ::aFoot[ 1 ], rc[ 3 ] ), rc[ 4 ], 0, 0 }
   if Empty( ::cBmpLeft )
      ::aLeft = { ::aBody[ 1 ], rc[ 2 ], ::aBody[ 3 ],;
                  If( ::lLeft, ( rc[ 4 ] - rc[ 2 ] ) * 0.33, rc[ 4 ] ) }
   else
      //nHBmp := FW_DrawImage( ::hDC, ::cBmpLeft, { ::aBody[ 1 ], rc[ 2 ] + 5, ::aBody[ 3 ], } )
      //nWBmp := nHBmp
      //::aLeft = { ::aBody[ 1 ], rc[ 2 ], ::aBody[ 3 ], nWBmp }
      hBmpLeft = LoadImageEx( ::cBmpLeft )
      if hBmpLeft != 0
         nWBmp = BmpWidth( hBmpLeft )
         ::aLeft = { ::aBody[ 1 ], rc[ 2 ], ::aBody[ 3 ], nWBmp + 10 }
         nTop     := ( ::aLeft[ 1 ] + ;
                     ( ::aLeft[ 3 ] - ::aLeft[ 1 ] ) / 2 ) - ;
                     BmpHeight( hBmpLeft ) / 2
         nTop     := Max( nTop, 5 )
         DrawMasked( hDC, hBmpLeft, nTop, ::aLeft[ 2 ] + 5 )
         DeleteObject( hBmpLeft )
      endif
   endif

   if ::bBmpLeft != nil
      hBmpLeft := Eval( ::bBmpLeft, self )
      if hBmpLeft != 0
         nWBmp := BmpWidth( hBmpLeft )
         ::aLeft := { ::aBody[ 1 ], rc[ 2 ], ::aBody[ 3 ], nWBmp + 10 }
         DrawMasked( hDC, hBmpLeft, ::aLeft[ 1 ] + 5, ::aLeft[ 2 ] + 5 )
         DeleteObject( hBmpLeft )
      endif
   endif

   if ::lLeft
      ::aRight = { ::aBody[ 1 ], ::aLeft[ 4 ] + 15, ::aBody[ 3 ] - 5, rc[ 4 ] - 10, 0, 0 }
   else
      ::lSplitHdr  := ::lLeft
      ::aRight = { ::aBody[ 1 ], rc[ 2 ] + 15, ::aBody[ 3 ] - 5, rc[ 4 ] - 10, 0, 0 }
   endif
   nTop   := ::aRight[ 1 ]
   if !hb_IsNil( ::cBody )
      hOldFont := SelectObject( hDC, ::oFontBody:hFont )
      if ::nClrTextFoot != nil
         nClrText := SetTextColor( hDC, ::nClrTextBody )
      endif
      nMode := SetBkMode( hDC, 1 )
      nH    := DrawText( hDC, AllTrim( ::cBody ), ::aRight,;
             nOr( if( ::lRightAlignBody, DT_RIGHT, DT_LEFT ), DT_WORDBREAK, DT_CALCRECT ) )
      if nH > ( ::aRight[ 3 ] - ::aRight[ 1 ] )
         nH := -( ::aRight[ 3 ] )//-( nH / 3 ) - if( !::lFoot, 10, 0 )
      endif
      if !::lHeader
         ::aRight[ 1 ] := 0
         if !::lFoot()
            ::aRight[ 3 ] := rc[ 3 ]
            ::aRight[ 1 ] := ( ( rc[ 3 ] - rc[ 1 ] ) / 2 - ( nH / 2 ) )
         else
            ::aRight[ 3 ] := ::aFoot[ 1 ] - 5
         endif
      else
         ::aRight[ 1 ]    := ::aHeader[ 3 ] + If( ::lLineHeader, 5, 0 )
         if ::lFoot()
            ::aRight[ 1 ] := ( ::aFoot[ 1 ] - 5 - ::aRight[ 1 ] ) / 2
         else
            ::aRight[ 1 ] := ( rc[ 3 ] - 5 - ::aRight[ 1 ] ) / 2
         endif
      endif
      DrawText( hDC, AllTrim( ::cBody ), ::aRight,;
             nOr( If( ::lRightAlignBody, DT_RIGHT, DT_LEFT ), DT_WORDBREAK ) )
             //nOr( DT_CENTER, DT_WORDBREAK ) )
      SetBkMode( hDC, nMode )
      if ::nClrTextFoot != nil
         SetTextColor( hDC, nClrText )
      endif
      SelectObject( hDC, hOldFont )
   endif
   if ::lSplitHdr
      ::aRight[ 1 ]  := nTop + if( !::lLineHeader, 5, 0 )
      if !::lFoot() .and. Empty( ::cBmpFoot ) .and. !::lBtnSetup
         ::aRight[ 3 ] := rc[ 3 ] - 5
      else
         ::aRight[ 3 ] := ::aFoot[ 1 ] - 5
      endif
      Line( hDC, ::aRight[ 1 ], ::aRight[ 2 ] - 10, ::aRight[ 3 ],;
            ::aRight[ 2 ] - 10, ::nClrSepara1 )
   endif

return 0

//----------------------------------------------------------------------------//

METHOD PaintFoot( hDC, rc ) CLASS TToast

   local hOldFont
   local hBmpFoot
   local nWFoot    := 0
   local nClrText
   local lIcon     := .F.
   local nMode

   ::aFoot = { rc[ 3 ] - if( ::lFoot, 5, 0 ), rc[ 2 ], rc[ 3 ], rc[ 4 ] }
   //::aFoot[ 1 ] += if( ::lLineFoot, 0, 5 )
   if ::lFoot() .or. ! Empty( ::cBmpFoot )
      if ! Empty( ::cBmpFoot )
         hBmpFoot = LoadImageEx( ::cBmpFoot )
         if hBmpFoot != 0
            nWFoot   := BmpWidth( hBmpFoot )
            ::aFoot[ 1 ] -= Max( BmpHeight( hBmpFoot ), ::oFontFoot:nHeight ) + 10
            DrawMasked( hDC, hBmpFoot,;
                     ( ::aFoot[ 1 ] + ( ::aFoot[ 3 ] - ::aFoot[ 1 ] ) / 2 ) - ;
                       BmpHeight( hBmpFoot ) / 2, 5 )
            DeleteObject( hBmpFoot )
         endif
      else
         ::aFoot[ 1 ] -= ::oFontFoot:nHeight
      endif
   else
      ::aFoot = { rc[ 3 ], rc[ 2 ], rc[ 3 ], rc[ 4 ] }
   endif
   if ::lFoot()
      hOldFont = SelectObject( hDC, ::oFontFoot:hFont )
      if ::nClrTextFoot != nil
         nClrText = SetTextColor( hDC, ::nClrTextFoot )
      endif
      nMode = SetBkMode( hDC, 1 )
      DrawText( hDC, ::cFoot, { ::aFoot[ 1 ], ::aFoot[ 2 ] + 10 + nWFoot,;
                 ::aFoot[ 3 ], ::aFoot[ 4 ] - if( ::lBtnSetup, 43, 0 ) }, ;
                 nOr( DT_VCENTER, DT_SINGLELINE, 8192, ;
                      if( ::lRightAlignFoot, DT_RIGHT, DT_LEFT ) ) )
      SetBkMode( hDC, nMode )
      if ::nClrTextFoot != nil
         SetTextColor( hDC, nClrText )
      endif
      SelectObject( hDC, hOldFont )
   endif
   if ::lLineFoot
      Line( hDC, ::aFoot[ 1 ], ::aFoot[ 2 ] + 5, ::aFoot[ 1 ], ::aFoot[ 4 ] - 5,;
            ::nClrSepara1 )
   endif

return 0

//----------------------------------------------------------------------------//

//https://msdn.microsoft.com/en-us/library/windows/apps/windows.ui.notifications.toasttemplatetype

METHOD PaintToast( hDC, rc ) CLASS TToast

   local hOldFont
   local nWBmp    := 0
   local nHBmp    := 0
   local nClrText
   local lIcon    := .F.
   local nMode
   local hBmpLeft := 0
   local n
   local nLen
   local nW
   local nW2
   local aLeft
   local nTop
   local nH       := 0
   local aLines   := {}
   local nLines   := 0
   //local aInfo    := ::DispBegin()

   ::aLeft = { 0, 0, 0, 0, 0, 0 }
   ::aBody = { rc[ 1 ], rc[ 2 ], rc[ 3 ], rc[ 4 ] }
   if Empty( ::cBmpLeft )
      ::aLeft = { ::aBody[ 1 ], rc[ 2 ], ::aBody[ 3 ],;
                  If( ::lLeft, ( rc[ 4 ] - rc[ 2 ] ) * 0.33, rc[ 4 ] ) }
   else
      //nHBmp := ( FW_DrawImage( ::hDC, ::cBmpLeft, { ::aBody[ 1 ], rc[ 2 ] + 5, ::aBody[ 3 ], } ) )
      //nWBmp := nHBmp
      //::aLeft = { ::aBody[ 1 ], rc[ 2 ], ::aBody[ 3 ], nWBmp }
      hBmpLeft = LoadImageEx( ::cBmpLeft )
      if hBmpLeft != 0
         nWBmp := BmpWidth( hBmpLeft )
         nHBmp := BmpHeight( hBmpLeft )
         ::aLeft = { ::aBody[ 1 ], rc[ 2 ], ::aBody[ 3 ], nWBmp + 10 }
         nTop     := ( ::aLeft[ 1 ] + ;
                     ( ::aLeft[ 3 ] - ::aLeft[ 1 ] ) / 2 ) - ( nHBmp / 2 )
         nTop     := Max( nTop, 5 )
         DrawMasked( hDC, hBmpLeft, nTop, ::aLeft[ 2 ] + 5 )
         DeleteObject( hBmpLeft )
      endif
   endif

   if ::bBmpLeft != nil
      hBmpLeft := Eval( ::bBmpLeft, self )
      if hBmpLeft != 0
         nWBmp := BmpWidth( hBmpLeft )
         ::aLeft := { ::aBody[ 1 ], rc[ 2 ], ::aBody[ 3 ], nWBmp + 10 }
         DrawMasked( hDC, hBmpLeft, ::aLeft[ 1 ] + 5, ::aLeft[ 2 ] + 5 )
         DeleteObject( hBmpLeft )
      endif
   endif

   if ::lLeft
      ::aRight = { ::aBody[ 1 ], ::aLeft[ 4 ] + 15, ::aBody[ 3 ] - 5, rc[ 4 ] - 10, 0, 0 }
   else
      ::lSplitHdr  := ::lLeft
      ::aRight = { ::aBody[ 1 ], rc[ 2 ] + 15, ::aBody[ 3 ] - 5, rc[ 4 ] - 10, 0, 0 }
   endif
   nTop   := ::aRight[ 1 ]
   if !hb_IsNil( ::cBody )
      nLines   := NumAt( ::cBody, CRLF )
      // Separar las lineas para aplicar el estilo del Template

      hOldFont := SelectObject( hDC, ::oFontBody:hFont )
      if ::nClrTextFoot != nil
         nClrText := SetTextColor( hDC, ::nClrTextBody )
      endif
      nMode := SetBkMode( hDC, 1 )
      nH    := DrawText( hDC, AllTrim( ::cBody ), ::aRight,;
                 nOr( if( !::lCenterText, ;
                      if( ::lRightAlignBody, DT_RIGHT, DT_LEFT ), ;
                      nOr( DT_CENTER, DT_VCENTER ) ), ;
                  if( ::lWordBreak, DT_WORDBREAK, 0 ), DT_CALCRECT ) )
      if nH > ( ::aRight[ 3 ] - ::aRight[ 1 ] )
         nH := -( ::aRight[ 3 ] )  //-( nH / 3 ) - if( !::lFoot, 10, 0 )
      endif

      ::aRight[ 1 ] := 0
      ::aRight[ 3 ] := rc[ 3 ]
      ::aRight[ 1 ] := ( ( rc[ 3 ] - rc[ 1 ] ) / 2 - ( nH / 2 ) )
      DrawText( hDC, AllTrim( ::cBody ), ::aRight,;
                 nOr( if( !::lCenterText, ;
                      if( ::lRightAlignBody, DT_RIGHT, DT_LEFT ), ;
                      nOr( DT_CENTER, DT_VCENTER ) ), ;
                  if( ::lWordBreak, DT_WORDBREAK, 0 ) ) )

      SetBkMode( hDC, nMode )
      if ::nClrTextFoot != nil
         SetTextColor( hDC, nClrText )
      endif
      SelectObject( hDC, hOldFont )
   endif
   if ::lSplitHdr
      ::aRight[ 1 ]  := nTop + if( !::lLineHeader, 5, 0 )
      if !::lFoot()
         ::aRight[ 3 ] := rc[ 3 ] - 5
      endif
      Line( hDC, ::aRight[ 1 ], ::aRight[ 2 ] - 10, ::aRight[ 3 ],;
            ::aRight[ 2 ] - 10, ::nClrSepara1 )
   endif
   //::DispEnd( aInfo )

return 0

//----------------------------------------------------------------------------//

static function Line( hDC, nTop, nLeft, nBottom, nRight, nColor, nWidth )

   local hPen
   local hOldPen

   DEFAULT nColor := CLR_BLACK
   DEFAULT nWidth := 0.5

   hPen = CreatePen( PS_SOLID, nWidth, nColor )
   hOldPen = SelectObject( hDC, hPen )

   MoveTo( hDC, nLeft, nTop )
   LineTo( hDC, nRight, nBottom ) //Top )

   SelectObject( hDC, hOldPen )
   DeleteObject( hPen )

return 0

//----------------------------------------------------------------------------//

Static Function SetTransparent( oObj, nLev, nColor ) //oWnd )

   DEFAULT nLev   := 255
   DEFAULT nColor := nRGB( 255, 255, 255 )

   SetWindowLong( oObj:hWnd, GWL_EXSTYLE, WS_EX_LAYERED )   // nOr( 524288, 32 )
   SetLayeredWindowATTributes( oObj:hWnd, nColor, nLev, 3 )  //?? nOr( LWA_COLORKEY, LWA_ALPHA )

Return Nil

//----------------------------------------------------------------------------//

Function TipTimeHide( nTime )

   if !HB_IsNIL( nTime )
      nTimeHide := nTime
   endif

Return nTimeHide

//----------------------------------------------------------------------------//

Function TipTransFlicker( oObj )

   TipTransHide( oObj )
   TipTransShow( oObj )
   TipTransHide( oObj )

return nil

//----------------------------------------------------------------------------//

Function TipTransHide( oObj )

   local x

   for x = oObj:nLevel to 0 step -1
      SetLayeredWindowAttributes( oObj:hWnd, , x, LWA_ALPHA )
      SysWait( nTimeHide )
   next x

return nil

//----------------------------------------------------------------------------//

Function TipTransShow( oObj )

   local x

   for x = 0 to oObj:nLevel
      SetLayeredWindowAttributes( oObj:hWnd, , x, LWA_ALPHA )
      SysWait( nTimeHide )
   next x

return nil

//----------------------------------------------------------------------------//






/*
#define Show                       7
#define CreateToastNotification    7
#define CreateToastNotifierWithId  8
#define Item                       8
#define GetTemplateContent         9
#define CreateTextNode            12
#define GetElementsByTagName      17
#define AppendChild               23
*/
//----------------------------------------------------------------------------//
/*
function Toast( cFirstLine, cSecondLine, cThirdLine, cImage )

   local pString, cIID, pToastFactory
   local pXml, pNodeList, pXmlNode, pXmlText, pXmlNodeChild, pXMlImage
   local pNotification, pNotificationFactory, pNotifier

   RoInitialize( 1 )

   pString = WinRTString( "Windows.UI.Notifications.ToastNotificationManager" )

   // "50AC103F-D235-4598-BBEF-98FE4D1A3AD4"
   cIID = Chr( 0x3F ) + Chr( 0x10 ) + Chr( 0xAC ) + Chr( 0x50 ) + ;
          Chr( 0x35 ) + Chr( 0xD2 ) + Chr( 0x98 ) + Chr( 0x45 ) + ;
          Chr( 0xBB ) + Chr( 0xEF ) + Chr( 0x98 ) + Chr( 0xFE ) + ;
          Chr( 0x4D ) + Chr( 0x1A ) + Chr( 0x3A ) + Chr( 0xD4 )

   RoGetActivationFactory( pString, cIID, @pToastFactory )

   WindowsDeleteString( pString );

   WinRTMethod( pToastFactory, GetTemplateContent, 7, @pXml )

   pString = WinRTString( "text" )
   WinRTMethod( pXml, GetElementsByTagName, pString, @pNodeList )
   WindowsDeleteString( pString )

   WinRTMethod( pNodeList, Item, 0, @pXmlNode )
   pString = WinRTString( cFirstLine )
   WinRTMethod( pXml, CreateTextNode, pString, @pXmlText )
   WindowsDeleteString( pString )
   WinRTMethod( pXmlNode, AppendChild, pXmlText, @pXmlNodeChild )

   WinRTMethod( pNodeList, Item, 1, @pXmlNode )
   pString = WinRTString( cSecondLine )
   WinRTMethod( pXml, CreateTextNode, pString, @pXmlText )
   WindowsDeleteString( pString )
   WinRTMethod( pXmlNode, AppendChild, pXmlText, @pXmlNodeChild )

   WinRTMethod( pNodeList, Item, 2, @pXmlNode )
   pString = WinRTString( cThirdLine )
   WinRTMethod( pXml, CreateTextNode, pString, @pXmlText )
   WindowsDeleteString( pString )
   WinRTMethod( pXmlNode, AppendChild, pXmlText, @pXmlNodeChild )


   //pString = WinRTString( "image" )
   //WinRTMethod( pXml, GetElementsByTagName, pString, @pNodeList )
   //WindowsDeleteString( pString )

   //WinRTMethod( pNodeList, Item, 0, @pXmlNode )
   //pString = WinRTString( cImage )
   //WinRTMethod( pXml, CreateTextNode, pString, @pXmlText )
   //WindowsDeleteString( pString )
   //WinRTMethod( pXmlNode, AppendChild, pXmlText, @pXmlNodeChild )


   // 04124B20-82C6-4229-B109-FD9ED4662B53
   cIID = Chr( 0x20 ) + Chr( 0x4B ) + Chr( 0x12 ) + Chr( 0x04 ) + ;
          Chr( 0xC6 ) + Chr( 0x82 ) + Chr( 0x29 ) + Chr( 0x42 ) + ;
          Chr( 0xB1 ) + Chr( 0x09 ) + Chr( 0xFD ) + Chr( 0x9E ) + ;
          Chr( 0xD4 ) + Chr( 0x66 ) + Chr( 0x2B ) + Chr( 0x53 )

   pString = WinRTString( "Windows.UI.Notifications.ToastNotification" )
   RoGetActivationFactory( pString, cIID, @pNotificationFactory )
   WindowsDeleteString( pString )

   WinRTMethod( pNotificationFactory, CreateToastNotification, pXML, @pNotification )

   pString = WinRTString( cFirstLine )
   WinRTMethod( pToastFactory, CreateToastNotifierWithId, pString, @pNotifier )
   WindowsDeleteString( pString )

   WinRTMethod( pNotifier, Show, pNotification )

   RoUninitialize()

return nil
*/
/*
function WinRTString( cText )

   local pString

   WindowsCreateString( AnsiToWide( cText ), Len( cText ), @pString )

return pString

DLL FUNCTION RoInitialize( nType AS LONG ) AS LONG PASCAL LIB "combase.dll"

DLL FUNCTION RoUninitialize() AS VOID PASCAL LIB "combase.dll"

DLL FUNCTION WindowsCreateString( cWideText AS LPSTR, nLength AS LONG, @pString AS PTR ) ;
   AS LONG PASCAL LIB "combase.dll"

DLL FUNCTION WindowsDeleteString( pString AS PTR ) AS LONG PASCAL LIB "combase.dll"

DLL FUNCTION RoGetActivationFactory( pString AS PTR, REFIID AS LPSTR, @pFactory AS PTR ) ;
   AS LONG PASCAL LIB "combase.dll"
*/

//#pragma BEGINDUMP
/*
#include <Windows.h>
#include <hbapi.h>

#ifndef _WIN64
   #ifndef HB_LONGLONG
      #define HB_LONGLONG long
      #define hb_storvnll hb_stornl
   #endif
#endif

typedef void * ( __stdcall * PMETHOD0 )( void * );
typedef void * ( __stdcall * PMETHOD1 )( void *, void * );
typedef void * ( __stdcall * PMETHOD2 )( void *, void *, void * );

HB_FUNC( WINRTMETHOD ) // pInspectable, nMethod, params...
{
   IUnknown * unknown = ( IUnknown * ) hb_parnll( 1 );
   void * pMethod = ( ( void ** ) unknown->lpVtbl )[ hb_parnl( 2 ) - 1 ];
   IUnknown * pReturn;

   switch( hb_pcount() )
   {
      case 3:
         if( HB_ISBYREF( 3 ) )
            hb_retnll( ( HB_LONGLONG ) ( ( PMETHOD1 ) pMethod )( unknown, &pReturn ) );
         else
            hb_retnll( ( HB_LONGLONG ) ( ( PMETHOD1 ) pMethod )( unknown, ( IUnknown * ) hb_parnll( 3 ) ) );
         break;

      case 4:
         if( HB_ISBYREF( 4 ) )
            hb_retnll( ( HB_LONGLONG ) ( ( PMETHOD2 ) pMethod )( unknown, ( void * ) hb_parnll( 3 ), &pReturn ) );
         else
            hb_retnll( ( HB_LONGLONG ) ( ( PMETHOD2 ) pMethod )( unknown, ( void * ) hb_parnll( 3 ), ( IUnknown * ) hb_parnll( 4 ) ) );
         break;
   }

   if( HB_ISBYREF( 3 ) )
      hb_storvnll( ( HB_LONGLONG ) pReturn, 3 );

   if( HB_ISBYREF( 4 ) )
      hb_storvnll( ( HB_LONGLONG ) pReturn, 4 );
}
*/

/*
HB_FUNC( SIZEOFUNKNOWNGET )
{
   IUnknown * pInsp = ( IUnknown * ) hb_parnl( 1 );

   hb_retnl( sizeof( * pInsp->lpVtbl ) );
}

HB_FUNC( SIZEOFUNKNOWN )
{
   IUnknown unknown;

   hb_retnl( sizeof( * unknown.lpVtbl ) );
}
*/
/*
HB_FUNC( SIZEOFVTBL )
{
   hb_retnl( sizeof( struct IInspectableVtbl ) );
}
*/
//#pragma ENDDUMP

