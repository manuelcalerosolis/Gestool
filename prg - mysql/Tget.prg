#include "FiveWin.ch"
#include "Constant.ch"
#include "Set.ch"

#define GWL_STYLE          -16

#define COLOR_WINDOW         5
#define COLOR_WINDOWTEXT     8
#define COLOR_BTNFACE       15
#define COLOR_GRAYTEXT      17

#define ES_CENTER            1

#define DM_GETDEFID    WM_USER
#define WM_ERASEBKGND       20
#define WM_CUT             768
#define WM_PASTE           770
#define WM_CLEAR           771
#define WM_NCCALCSIZE      131   // 0x0083

#define CW_USEDEFAULT    32768

#define EM_GETSEL          176
#define EM_SETSEL          177
#define EM_UNDO            199

#define EM_SETMARGINS      211 // 0x00D3
#define EM_GETMARGINS      212 // 0x00D4
#define EC_LEFTMARGINS       1 // 0x0001
#define EC_RIGHTMARGINS      2 // 0x0002

#define EM_LIMITTEXT       197

#define WS_EX_CLIENTEDGE   512

#define ETO_OPAQUE           2
#define ETO_CLIPPED          4

#define TA_LEFT              0
#define TA_RIGHT             2
#define TA_CENTER            6

#define SM_CYHSCROLL         3

#define SWP_NOSIZE           1
#define SWP_NOMOVE           2
#define SWP_NOZORDER         4
#define SWP_FRAMECHANGED    32

#define EM_SETCUEBANNER 0x1501
#define TRANSPARENT          1

//----------------------------------------------------------------------------//

CLASS TGet FROM TControl

   DATA   oGet, oBtn, bAction
   DATA   bMin, bMax
   DATA   nPos
   DATA   lReadOnly, lPassword
   DATA   cError, cBmpName
   DATA   hHeap
   DATA   cPicture
   DATA   bPostKey
   DATA   lSpinner
   DATA   nOldClrPane // Old background color, if color changed with focus
   DATA   nClrTextDis, nClrPaneDis
   DATA   nBmpWidth
   DATA   lAdjustBtn // Adjust buutton get
   DATA   lBtnTransparent
   DATA   cCueText
   DATA   nTxtStyle
   DATA   lKeepFocus INIT .T. // keep the focus after pressing the ACTION button

   CLASSDATA lDisColors INIT .T. // Use standard disabled colors
   CLASSDATA lClrFocus  INIT .F. // change GET color when focused
   CLASSDATA nClrFocus  INIT nRGB( 235, 235, 145 ) // color to use when GET is focused and lClrFocus is .T.

   METHOD New( nRow, nCol, bSetGet, oWnd, nWidth, nHeight, cPict, bValid,;
               nClrFore, nClrBack, oFont, lDesign, oCursor, lPixel,;
               cMsg, lUpdate, bWhen, lCenter, lRight, bChanged,;
               lReadOnly, lPassword, lNoBorder, nHelpId,;
               lSpinner, bUp, bDown, bMin, bMax, bAction, cBmpName, cVarName,;
               cCueText, cVarName ) CONSTRUCTOR

   METHOD Assign() INLINE ::oGet:Assign()

   METHOD cToChar() INLINE ::Super:cToChar( "EDIT" )

   METHOD Copy()

   METHOD Create( cClsName )

   METHOD CreateButton()

   METHOD Cut()

   METHOD Default()

   METHOD Destroy()

   METHOD Display() INLINE ::BeginPaint(), ::Paint(), ::EndPaint(), 0

   METHOD EraseBkGnd( hDC ) INLINE 1

   METHOD GenLocals()

   METHOD cGenPrg()

   METHOD GetDlgCode( nLastKey )

   METHOD GoHome()

   METHOD GotFocus( hCtlLost )

   METHOD HandleEvent( nMsg, nWParam, nLParam )

   METHOD Initiate( hDlg )

   METHOD KeyDown( nKey, nFlags )
   METHOD KeyChar( nKey, nFlags )
   METHOD KeyUp( nKey, nFlags )

   METHOD LButtonDown( nRow, nCol, nFlags )
   METHOD LButtonUp( nRow, nCol, nFlags )

   // Call this method to use unlimited text size
   METHOD LimitText() INLINE SendMessage( ::hWnd, EM_LIMITTEXT, 0, 0 )

   METHOD LostFocus( hCtlFocus )

   METHOD MouseMove( nRow, nCol, nKeyFlags )

   METHOD cText( cText ) SETGET

   METHOD ReDefine( nId, bSetGet, oWnd, nHelpId, cPict, bValid,;
                    nClrFore, nClrBack, oFont, oCursor, cMsg,;
                    lUpdate, bWhen, bChanged, lReadOnly,;
                    lSpinner, bUp, bDown, bMin, bMax, bAction, cBmpName, cVarName, cCueText ) CONSTRUCTOR

   METHOD Refresh() INLINE ::oGet:SetFocus(),;
                           ::oGet:UpdateBuffer(),;
                           ::DispText(),;
                           ::GoHome()

   METHOD DispText()
   METHOD GetSel()
   METHOD GetSelPos( @nStart, @nEnd )
   METHOD GetDelSel( nStart, nEnd )

   METHOD EditUpdate()

   METHOD HideSel() INLINE ::SetSel( -1, 0 )

   METHOD lValid()

   METHOD Paint()

   METHOD Paste( cText )

   METHOD RButtonDown( nRow, nCol, nFlags )

   METHOD Resize( nType, nWidth, nHeight )

   METHOD SaveToRC( nIndent )

   METHOD SelectAll() INLINE ::SetSel( 0, -1 )

   METHOD SelFile( cMask, cTitle )

   METHOD SetMargins( nLeft, nRight ) INLINE ;
          nLeft := If( nLeft == nil, 0, nLeft ),;
          nRight := If( nRight == nil, 0, nRight ),;
          SendMessage( ::hWnd, EM_SETMARGINS,;
          nOR( EC_LEFTMARGINS, EC_RIGHTMARGINS ), nMakeLong( nLeft, nRight ) )

    METHOD GetMargins( nResult ) INLINE ;
           nResult := SendMessage( ::hWnd, EM_GETMARGINS, 0, 0 ),;
           { nLoWord( nResult ), nHiWord( nResult ) }  // { nLeft, nRight }

   MESSAGE SetPos() METHOD _SetPos( nStart, nEnd )

   #ifdef __CLIPPER__
   METHOD SetSel( nStart, nEnd ) INLINE ;
                  nStart := If( nStart == nil, 1, nStart ),;
                  nEnd   := If( nEnd == nil, nStart, nEnd ),;
                  SendMessage( ::hWnd, EM_SETSEL, 0,;
                  nMakeLong( nStart - If( nStart > 0, 1, 0 ),;
                  nEnd - If( nEnd > 0, 1, 0 ) ) ),;
                  ::nPos := nStart
   #else
   METHOD SetSel( nStart, nEnd ) INLINE ;
                  nStart := If( nStart == nil, 1, nStart ),;
                  nEnd   := If( nEnd == nil, nStart, nEnd ),;
                  SendMessage( ::hWnd, EM_SETSEL, nStart, nEnd ),;
                  ::nPos := nStart
   #endif

   METHOD Move( nTop, nLeft, nBottom, nRight, lRepaint )

   METHOD UnDo() INLINE ::cText := ::oGet:Original

   METHOD Spinner( bUp, bDown, bMin, bMax )

   METHOD Value() INLINE ::VarGet()

   METHOD VarPut( uVal ) INLINE  If( ValType( ::bSetGet ) == "B",;
                                     Eval( ::bSetGet, uVal ),)

   METHOD Inc()   OPERATOR "++"
   METHOD Dec()   OPERATOR "--"
   METHOD ScrollDate( nDirection )
   METHOD ScrollNumber( nDirection )

   METHOD SetColorFocus( nClrFocus )

   METHOD SetCueBanner( lOnFocus, cText ) INLINE SendMessage( ::hWnd, EM_SETCUEBANNER, lOnFocus, AnsiToWide( cText ) )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( nRow, nCol, bSetGet, oWnd, nWidth, nHeight, cPict, bValid,;
            nClrFore, nClrBack, oFont, lDesign, oCursor, lPixel, cMsg,;
            lUpdate, bWhen, lCenter, lRight, bChanged, lReadOnly,;
            lPassword, lNoBorder, nHelpId, lSpinner,;
            bUp, bDown, bMin, bMax, bAction, cBmpName, cVarName,;
            cCueText ) CLASS TGet

   local cText := Space( 50 )

   DEFAULT nClrFore  := GetSysColor( COLOR_WINDOWTEXT ),;
           nClrBack  := GetSysColor( COLOR_WINDOW ),;
           oWnd      := GetWndDefault(),;
           nHeight   := If( oFont != nil, oFont:nHeight, 12 ),;
           lDesign   := .f., lPixel := .f., lUpdate := .f.,;
           lCenter   := .f., lRight := .f.,;
           lReadOnly := .f., lPassword := .f.,;
           lSpinner  := .f.,;
           nRow      := 0, nCol := 0, lNoBorder := .f.,;
           bSetGet   := bSETGET( cText )

   ::cCaption = If( cPict == nil, cValToChar( Eval( bSetGet ) ), ;
                    Transform( Eval( bSetGet ), cPict ) )

   if lSpinner
      nHeight := Max( 15, nHeight )
   endif

   ::nTop     = nRow * If( lPixel, 1, GET_CHARPIX_H )  //13
   ::nLeft    = nCol * If( lPixel, 1, GET_CHARPIX_W )  // 8
   ::nBottom  = ::nTop + nHeight - 1
   ::nRight   = ::nLeft + If( nWidth == nil, ( 1 + Len( ::cCaption ) ) * 3.5, ;
                                               nWidth - 1 ) + ;
                If( lSpinner, 20, 0 )
   ::oWnd      = oWnd
   ::nStyle    = nOR( WS_CHILD, WS_VISIBLE,;
                      ES_AUTOHSCROLL,;
                      If( ! lReadOnly, WS_TABSTOP, 0 ),;
                      If( lDesign, WS_CLIPSIBLINGS, 0 ),;
                      If( lSpinner, WS_VSCROLL, 0 ),;
                      If( lReadOnly, ES_READONLY, 0 ),;
                      If( lCenter, ES_CENTER, If( lRight, ES_RIGHT, ES_LEFT ) ) )
                   // If( lCenter .OR. lRight, ES_MULTILINE, 0 ),; Only needed for Win31

   #ifdef __CLIPPER__
      if ! lNoBorder
         ::nStyle = nOr( ::nStyle, WS_BORDER )
      endif
   #else
      if ! IsAppThemed()
         if ! lNoBorder
            ::nStyle = nOr( ::nStyle, WS_BORDER )
         endif
      else
         if ! lNoBorder
            ::nStyle = nOr( ::nStyle, If( oWnd:IsKindOf( "TDIALOG" ), WS_BORDER, 0 ) )
            ::nExStyle = WS_EX_CLIENTEDGE
         endif
      endif
   #endif

   ::nStyle    = If( lNoBorder, nAnd( ::nStyle, nNot( WS_BORDER ) ), ::nStyle )
   ::nId       = ::GetNewId()
   ::bSetGet   = bSetGet
   ::oGet      = FWGetNew( 20, 20, bSetGet, cVarName, cPict )
   ::bValid    = bValid
   ::lDrag     = lDesign
   ::lCaptured = .f.
   ::lPassword = lPassword
//   ::oFont     = oFont
   ::SetFont( oFont )
   ::oCursor   = oCursor
   ::cMsg      = cMsg
   ::lUpdate   = lUpdate
   ::bWhen     = bWhen
   ::bChange   = bChanged
   ::nPos      = 1  // 0   14/Aug/98
   ::lReadOnly = lReadOnly
   ::lFocused  = .f.
   ::nHelpId   = nHelpId
   ::cPicture  = cPict
   ::bPostKey  = { | x, y | y }
   ::lSpinner  = lSpinner
   ::hHeap     = 0
   ::bAction   = bAction
   ::cBmpName  = cBmpName
   ::cCueText  = cCueText
   ::nTxtStyle = nOR( ETO_CLIPPED, ETO_OPAQUE )

   ::SetColor( nClrFore, nClrBack )
   ::lAdjustBtn = .f.
   ::lBtnTransparent = .f.

   ::oGet:SetFocus()
   ::cCaption = ::oGet:Buffer
   ::oGet:KillFocus()

    ::nClrTextDis = nClrFore
    ::nClrPaneDis = ::nClrPane // nClrBack

    if lPassword .and. oFont == nil
       DEFINE FONT ::oFont NAME "Arial" SIZE 0, -14 BOLD
    endif

   if ! Empty( oWnd:hWnd )
      ::Create( "EDIT" )
      if ::oFont != nil
         ::SetFont( ::oFont )
      else
         ::GetFont()
      endif
      oWnd:AddControl( Self )
      ::CreateButton()
   else
      oWnd:DefControl( Self )
   endif

   DEFAULT cVarName := "oGet" + ::GetCtrlIndex()

   ::cVarName = cVarName

   if lDesign
      ::CheckDots()
   endif

   if lSpinner
      ::Spinner( bUp, bDown, bMin, bMax )
   endif

return Self

//----------------------------------------------------------------------------//

METHOD ReDefine( nId, bSetGet, oWnd, nHelpId, cPict, bValid, nClrFore,;
                 nClrBack, oFont, oCursor, cMsg, lUpdate, bWhen, bChanged,;
                 lReadOnly, lSpinner, bUp, bDown, bMin, bMax, bAction, cBmpName,;
                 cVarName, cCueText ) CLASS TGet

   DEFAULT oWnd     := GetWndDefault(),;
           nClrFore := GetSysColor( COLOR_WINDOWTEXT ),;
           nClrBack := GetSysColor( COLOR_WINDOW ),;
           lUpdate  := .f., lReadOnly := .f., lSpinner := .f.


   if Eval( bSetGet ) == nil
      Eval( bSetGet, Space( 30 ) )
   endif

   ::nId       = nId
   ::oWnd      = oWnd
   ::nHelpId   = nHelpId
   ::bSetGet   = bSetGet
   ::oGet      = FWGetNew( 20, 20, bSetGet, cVarName, cPict )
   ::bValid    = bValid
   ::lDrag     = .f.
   ::lCaptured = .f.
   ::lPassword = .f.
//   ::oFont     = oFont
   ::SetFont( oFont )
   ::oCursor   = oCursor
   ::cMsg      = cMsg
   ::lUpdate   = lUpdate
   ::bWhen     = bWhen
   ::bChange   = bChanged
   ::nPos      =  1  // 0   14/Aug/98
   ::lReadOnly = lReadOnly
   ::lFocused  = .f.
   ::cPicture  = cPict
   ::bPostKey  = { | x, y | y }
   ::lSpinner  = lSpinner
   ::hHeap     = 0
   ::bAction   = bAction
   ::cBmpName  = cBmpName
   ::nClrTextDis = nClrFore
   ::nClrPaneDis = nClrBack
   ::cCueText  = cCueText
   ::nTxtStyle = nOR( ETO_CLIPPED, ETO_OPAQUE )

   ::SetColor( nClrFore, nClrBack )
   ::lAdjustBtn = .f.
   ::lBtnTransparent = .f.

   if lSpinner
      ::Spinner( bUp, bDown, bMin, bMax )
   endif

   oWnd:DefControl( Self )

return Self

//----------------------------------------------------------------------------//

METHOD Create( cClsName ) CLASS TGet

   local hHeap

   DEFAULT cClsName := ::ClassName(), ::cCaption := "",;
           ::nStyle := WS_OVERLAPPEDWINDOW,;
           ::nTop   := 0, ::nLeft := 0, ::nBottom := 10, ::nRight := 10,;
           ::nId    := 0

   if ::oWnd != nil
      ::nStyle = nOR( ::nStyle, WS_CHILD )
   endif

   if ::nBottom != CW_USEDEFAULT
      ::hWnd = MGetCreate( cClsName, ::cCaption, ::nStyle, ;
                           ::nLeft, ::nTop, ::nRight - ::nLeft + 1, ;
                           ::nBottom - ::nTop + 1, ;
                           If( ::oWnd != nil, ::oWnd:hWnd, 0 ), ;
                           ::nId, @hHeap, ::nExStyle )
    else
      ::hWnd = MGetCreate( cClsName, ::cCaption, ::nStyle, ;
                           ::nLeft, ::nTop, ::nRight, ::nBottom, ;
                           If( ::oWnd != nil, ::oWnd:hWnd, 0 ), ;
                           ::nId, @hHeap, ::nExStyle )
    endif

   if ::hWnd == 0
      WndCreateError( Self )
   else
      ::Link()
      if ::oFont != nil
         ::SetFont( ::oFont )
      endif
      ::hHeap = hHeap
   endif

return nil

//----------------------------------------------------------------------------//

METHOD CreateButton() CLASS TGet

   local oThis := Self
   local hBitmap
   local nBmpWidth := 1
   local lFileBmp := .t.

   if ValType( ::bAction ) == "B" .and. Upper( ::ClassName() ) == "TGET"
      if Empty( ::cBmpName )
         @ 0, ::nWidth - ::nHeight - If( ::lSpinner, 20, 0 ) BUTTONBMP ::oBtn OF Self ;
         ACTION ( Eval( oThis:bAction, oThis ), if( ::lKeepFocus, oThis:SetFocus(), nil ) ) ;
         SIZE ::nHeight - 4, ::nHeight - 4 PIXEL
         if Empty( ::oBtn:hBitmap )
            ::oBtn:SetText( "..." )
         endif
      else

         hBitmap   = If( ( lFileBmp := File( ::cBmpName ) ), ReadBitmap( 0, ::cBmpName ),;
                     LoadBitmap( GetResources(), ::cBmpName ) )

         if ::lAdjustBtn
            nBmpWidth := nBmpWidth( hBitmap ) + 5
            ::SetMargins( 1, nBmpWidth )
         else
            nBmpWidth := ::nHeight - 4
         endif

         if ::lBtnTransparent
            ::oBtn := TBtnBmp():New( 0, ::nWidth - nBmpWidth - If( ::lSpinner, 20, 4 ), nBmpWidth, ::nHeight - 4,;
            if ( !lFileBmp, ::cBmpName, ),,if ( lFileBmp, ::cBmpName, ),,{|| Eval( oThis:bAction, oThis ),oThis:SetFocus() },;
            Self,,,,,,,,,.f.)
            ::oBtn:lTransparent := ::lBtnTransparent
         else
            ::oBtn := TButtonBmp():New( 0, ::nWidth - nBmpWidth - If( ::lSpinner, 20, 4 ),, Self, {|| Eval( oThis:bAction, oThis ),oThis:SetFocus() }, ;
            nBmpWidth, ::nHeight - 4,,,,.t.,,,,,,,::cBmpName )
         endif

         DeleteObject( hBitmap )

      endif
      ::oBtn:lCancel = .T. // so the GET VALID is not fired when the button is focused

      if Upper( ::oWnd:ClassName() ) == "TDIALOG" .and. ::oWnd:lResize16
         ::oBtn:nWidth  = ::nHeight - 5
         ::oBtn:nHeight = ::nHeight - 5
         ::oBtn:nLeft   = ( ::nWidth * 1.167 ) - ::nHeight
      endif

      if ! IsAppThemed()
         ::oBtn:SetPos( 2, ::oBtn:nLeft + 2 )
      endif

      /*
      // We force a WM_NCCALCSIZE msg to be sent to the GET
      SetWindowPos( ::hWnd, 0, 0, 0, 0, 0,;
                    nOr( SWP_NOMOVE, SWP_NOSIZE, SWP_NOZORDER, SWP_FRAMECHANGED ) )
      */
   endif

return nil

//----------------------------------------------------------------------------//

METHOD GetDlgCode( nLastKey ) CLASS TGet

   if Len( ::oWnd:aControls ) == 1
      return DLGC_WANTALLKEYS
   endif

   ::oWnd:nLastKey = nLastKey

   if ::oWnd:IsKindOf( "TXBROWSE" )
      return DLGC_WANTALLKEYS
   else
      if ::oWnd:oWnd != nil .and. ;
         ::oWnd:oWnd:ClassName() $ "TFOLDER,TFOLDEREX,TMDICHILD,TWINDOW,TDIALOG"
         return DLGC_WANTALLKEYS
      endif
   endif

return DLGC_WANTALLKEYS // DLGC_WANTTAB // nil

//----------------------------------------------------------------------------//

METHOD HandleEvent( nMsg, nWParam, nLParam ) CLASS TGet

   local oClp, cText, n

   do case
      case nMsg == WM_CUT
           CallWindowProc( ::nOldProc, ::hWnd, WM_CUT, 0, 0 )
           ::oGet:buffer = Pad( GetWindowText( ::hWnd ), Len( ::oGet:buffer ) )
           DEFINE CLIPBOARD oClp OF Self FORMAT TEXT
           ::oGet:Pos -= Len( oClp:GetText() )
           oClp:End()
           ::oGet:Assign()
           if ::bChange != nil
              Eval( ::bChange,,, Self )
           endif
           return 0

      case nMsg == WM_PASTE
           if GetFocus() == ::hWnd
              CallWindowProc( ::nOldProc, ::hWnd, WM_PASTE, 0, 0 )
              if ValType( ::oGet:Original ) $ "CM"
                 SetWindowText( ::hWnd, SubStr( GetWindowText( ::hWnd ), 1, Len( ::oGet:Original ) ) )
              endif
              ::oGet:Buffer = GetWindowText( ::hWnd )
              ::oGet:Pos = GetCaretPos()[ 2 ]
              ::oGet:Assign()
              if ::bChange != nil
                 Eval( ::bChange,,, Self )
              endif
           endif
           return 0

      case nMsg == WM_CLEAR
           CallWindowProc( ::nOldProc, ::hWnd, WM_CLEAR, 0, 0 )
           ::oGet:buffer = Space( Len( ::oGet:buffer ) )
           ::SetPos( 1 )
           ::oGet:Assign()
           if ::bChange != nil
              Eval( ::bChange,,, Self )
           endif
           return 0

      /*
      case nMsg == WM_NCCALCSIZE
           if nWParam == 1
              NCCSRight( nLParam, ::oBtn:nWidth )
           endif
           return 0
      */
   endcase

return ::Super:HandleEvent( nMsg, nWParam, nLParam )

//----------------------------------------------------------------------------//

METHOD Initiate( hDlg ) CLASS TGet

   ::Super:Initiate( hDlg )
   ::oGet:SetFocus()

   if lAnd( GetWindowLong( ::hWnd, GWL_STYLE ), ES_PASSWORD )
      ::lPassword = .t.
   endif

   // Ballon tooltip when CapsLock is on on XP
   if ::lPassword
      SetWindowLong( ::hWnd, GWL_STYLE,;
                     nOr( GetWindowLong( ::hWnd, GWL_STYLE ), ES_PASSWORD ) )
   endif

   SetWindowLong( ::hWnd, GWL_STYLE,;
                  nOr( GetWindowLong( ::hWnd, GWL_STYLE ), ES_AUTOHSCROLL ) )

   if ::lReadOnly .and. ::nClrText == GetSysColor( COLOR_WINDOWTEXT ) ;
      .and. ::nClrPane == GetSysColor( COLOR_WINDOW )
      ::SetColor( GetSysColor( COLOR_GRAYTEXT ), GetSysColor( COLOR_BTNFACE ) )
      // ::Disable()
   endif

   ::DispText()
   // fix initial position bug when @R is used in picture clause
   if ::cPicture # nil .and. "@R" $ ::cPicture
      ::oGet:Home()
      ::SetPos( ::oGet:Pos )
   endif
   ::oGet:KillFocus()

   if ValType( ::bAction ) == "B"
      ::SetMargins( 1, ::nHeight )
   else
      ::SetMargins( 1, 1 )
   endif

   ::CreateButton()

   if ! Empty( ::cCueText )
      SendWideStringMessage( ::hWnd, EM_SETCUEBANNER, .T., ::cCueText )
   endif

return nil

//---------------------------------------------------------------------------//
// Updates the text and the EDIT cursor position based on the DATA oGet

METHOD EditUpdate() CLASS TGet

   if ::oGet:HasFocus
      ::DispText()
   endif

   ::SetPos( ::oGet:Pos )

return nil

//---------------------------------------------------------------------------//

METHOD cText( uVal ) CLASS TGet

   local cWindowText

   if PCount() == 1
      ::oGet:VarPut( uVal )
      ::Refresh()
   endif

   cWindowText := GetWindowText( ::hWnd )

return If( ! Empty( ::cCueText ) .and. cWindowText == "", ::oGet:buffer, cWindowText )

//----------------------------------------------------------------------------//

METHOD GetSel() CLASS TGet

   local n      := ::SendMsg( EM_GETSEL )
   local nStart := nLoWord( n )
   local nEnd   := nHiWord( n )

return If( nStart != nEnd, SubStr( ::cText, nStart + 1, nEnd - nStart ), "" )

//----------------------------------------------------------------------------//

METHOD GetSelPos( nStart, nEnd ) CLASS TGet

   local n := ::SendMsg( EM_GETSEL )
   nStart  := nLoWord( n )
   nEnd    := nHiWord( n )

return nil

//----------------------------------------------------------------------------//

METHOD GetDelSel( nStart, nEnd ) CLASS TGet

   ::oGet:buffer = Left( ::oGet:buffer, Min( nEnd, nStart ) ) ;
                   + Right( ::oGet:buffer, ;
                            Len( ::oGet:buffer ) - Max( nEnd, nStart ) ) ;
                   + Space( Abs( nStart - nEnd ) )

   // if ! Empty( ::oGet:Picture )  Eric reported bug, working solution A.L.Dec-2007
   //    ::SendMsg( WM_KILLFOCUS )
   //    ::SendMsg( WM_SETFOCUS )
   // endif

   ::oGet:Assign()

   #ifndef __CLIPPER__
      if ::oGet:Type $ "DN"
         ::oGet:KillFocus()
         ::oGet:SetFocus()
      endif
   #endif

   ::oGet:Reset()
   ::oGet:pos := Min( nStart, nEnd ) + 1

return nil

//---------------------------------------------------------------------------//

METHOD MouseMove( nRow, nCol, nKeyFlags ) CLASS TGet

   if ::lDrag
      return ::Super:MouseMove( nRow, nCol, nKeyFlags )
   else
      ::oWnd:SetMsg( ::cMsg )        // Many thanks to HMP
      if ::oCursor != nil
         SetCursor( ::oCursor:hCursor )
      else
         CursorIBeam()
      endif
      ::CheckToolTip()

      if ::bMMoved != nil
         return Eval( ::bMMoved, nRow, nCol, nKeyFlags )
      endif
      if ::oBtn != nil
         ::oBtn:Refresh()
      endif
   endif

return nil      // We want standard Get behavior !!!

//---------------------------------------------------------------------------//

METHOD Copy() CLASS TGet

   local oClp

   DEFINE CLIPBOARD oClp OF Self ;
      FORMAT TEXT

   if oClp:Open()
      oClp:Clear()
      oClp:SetText( ::GetSel() )
      oClp:End()
   else
      msgStop( "The clipboard is not available now!" )
   endif

return nil

//---------------------------------------------------------------------------//

METHOD Default() CLASS TGet

   if ::oFont != nil
      ::SetFont( ::oFont )
   else
      ::GetFont()
   endif

return nil

//---------------------------------------------------------------------------//

METHOD Destroy() CLASS TGet

   if ::hHeap != 0
      ::hHeap = 0
   endif

return ::Super:Destroy()

//---------------------------------------------------------------------------//

METHOD GenLocals() CLASS TGet

return ", " + ::cVarName + ", " + "c" + SubStr( ::cVarName, 2 ) + " := " + ;
       If( Empty( ::GetText() ), "Space( 20 )", '"' + ::GetText() + '"' )

//---------------------------------------------------------------------------//

METHOD cGenPrg() CLASS TGet

   local cCode := ""

   cCode += CRLF + "   @ " + Str( ::nTop, 3 ) + ", " + Str( ::nLeft, 3 ) + ;
            " GET " + ::cVarName + " VAR " + "c" + SubStr( ::cVarName, 2 ) + ;
            " SIZE " + Str( ::nWidth, 3 ) + ", " + Str( ::nHeight, 3 ) + ;
            " PIXEL OF " + ::oWnd:cVarName + CRLF

return cCode

//---------------------------------------------------------------------------//

METHOD KeyDown( nKey, nFlags ) CLASS TGet

   local nHi, nLo, nPos, nLastHi := -1, uVal

   ::nLastKey = nKey

   if ::bKeyDown != nil
      if ValType( uVal := Eval( ::bKeyDown, nKey, nFlags, Self ) ) == "N" .and. ;
         uVal == 0
         return 0
      endif
   endif

   do case
        case nKey == VK_PRIOR
             if ::lSpinner
                Self--
             endif

        case nKey == VK_NEXT
             if ::lSpinner
                Self++
             endif

      case nKey == VK_UP
           if Len( ::oWnd:aControls ) > 1
               ::oWnd:GoPrevCtrl( ::hWnd )
               return 1   // avoid default behavior
           endif

      case nKey == VK_DOWN
           if Len( ::oWnd:aControls ) > 1
               ::oWnd:GoNextCtrl( ::hWnd )
               return 1
           endif

      case nKey == VK_LEFT
           if ::oGet:buffer != nil .and. ::nPos >= Len( ::oGet:buffer )
              ::GetSelPos( @nLo, @nHi )
              ::oGet:Pos = nLo + 1
              ::nPos := nLo + 1
           endif
           if GetKeyState( VK_CONTROL )
              ::oGet:WordLeft()
           else
              ::oGet:Left()
              #ifndef __XHARBOUR__
                 ::nPos--
                 ::oGet:Pos := ::nPos
              #endif
           endif

           ::oGet:Pos = Max( ::oGet:Pos, 1 )

           while .t.
              CallWindowProc( ::nOldProc, ::hWnd, WM_KEYDOWN, nKey, nFlags )
              ::GetSelPos( @nLo, @nHi )
              if nLo <= ::oGet:Pos - 1
                 EXIT
              endif
           end
           ::nPos = nLo + 1
           if ::nPos < ::oGet:Pos
              #ifndef __XHARBOUR__
                 ::SetPos( ::oGet:Pos-1 )
              #else
                 ::SetPos( ::oGet:Pos )
              #endif
           else
              ::oGet:Pos = ::nPos
           endif
           if ::oBtn != nil
              ::oBtn:Refresh()
           endif
           return 0

      case nKey == VK_RIGHT
           nPos = ::oGet:Pos
           if GetKeyState( VK_CONTROL )
              ::oGet:wordRight()
           else
              ::oGet:right()
           endif
           if nPos <> ::oGet:Pos
              while .t.
                 CallWindowProc( ::nOldProc, ::hWnd, WM_KEYDOWN, nKey, nFlags )
                 ::GetSelPos( @nLo, @nHi )
                 if nHi + 1 >= ::oGet:Pos .or. ::lPassword .or. ;
                    nHi == nLastHi
                    EXIT
                 endif
                 nLastHi = nHi
              end
              ::oGet:Pos = nHi + 1
              ::nPos     = nHi + 1
           elseif nPos == Len( ::oGet:buffer )
//              ::nPos++
//              ::oGet:Pos := ::nPos
              ::GetSelPos( @nLo, @nHi )
              ::oGet:Pos = nLo + 1
              ::nPos := nLo + 1
              CallWindowProc( ::nOldProc, ::hWnd, WM_KEYDOWN, nKey, nFlags )

           endif
           if ::oBtn != nil
              ::oBtn:Refresh()
           endif

           return 0
                                          // Many thanks to HMP
      case nKey == VK_INSERT .and. ! GetKeyState( VK_SHIFT ) ;
           .and. ! GetKeyState( VK_CONTROL )   // to copy to the clipboard

           Set( _SET_INSERT, ! Set( _SET_INSERT ) )
           DestroyCaret()
           if Set( _SET_INSERT )
              CreateCaret( ::hWnd, 0, 6, ::nGetChrHeight() - 1 )
           else
              CreateCaret( ::hWnd, 0, 2, ::nGetChrHeight() )
           endif
           ShowCaret( ::hWnd )
           return 0

      case ( nKey == VK_INSERT .and. GetKeyState( VK_SHIFT ) ) .or. ;
           ( nKey == ASC("V") .and. GetKeyState( VK_CONTROL ) ) .or. ;
           ( nKey == ASC('X') .and. GetKeyState( VK_CONTROL ) ) .and. ;
           ! lAnd( nFlags, 2 ** 29 )

          if ! ::lReadOnly
             CallWindowProc( ::nOldProc, ::hWnd, WM_KEYDOWN, nKey, nFlags )
             SysRefresh()
             if ValType( ::oGet:buffer ) = "C"
                ::oGet:buffer = Pad( GetWindowText( ::hWnd ), Len( ::oGet:buffer ) )
                SetWindowText( ::hWnd, ::oGet:buffer )
             else
                ::oGet:buffer = GetWindowText( ::hWnd )
             endif
             ::oGet:Assign()
             // ::GetSelPos( @nLo, @nHi )
             // ::nPos = nHi + 1
             // ::oGet:Pos = ::nPos
             if ::bChange != nil
                Eval( ::bChange, nKey, nFlags, Self )
             endif
          endif

          return 0

      case nKey == VK_HOME .or. nKey == VK_END

           if GetKeyState( VK_SHIFT )
              CallWindowProc( ::nOldProc, ::hWnd, WM_KEYDOWN, nKey, nFlags )

              ::GetSelPos( @nLo, @nHi )
              ::oGet:Pos = nLo + 1
              ::nPos = nLo + 1
           else
               if nKey == VK_HOME
                  ::oGet:Home()
                  ::SetPos( ::oGet:Pos )
               endif

               if nKey == VK_END
                  ::oGet:End()
                  if ::oGet:Pos == len( ::oGet:buffer )
                     ::SetPos( ::oGet:Pos + 1)
                  else
                     ::SetPos( ::oGet:Pos )
                  endif
               endif
           endif
           if ::oBtn != nil
              ::oBtn:Refresh()
           endif
           return 0

      case nKey == VK_DELETE .or. nKey == VK_BACK

           if ::lReadOnly
              return 0
           endif

           if ::lDrag
              return ::Super:KeyDown( nKey, nFlags )
           endif

           ::GetSelPos( @nLo, @nHi )

           // Deletes selection
           if nHi != nLo
              ::GetDelSel( nLo, nHi )
              if GetKeyState( VK_SHIFT )
                 CallWindowProc( ::nOldProc, ::hWnd, WM_KEYDOWN, nKey, nFlags )
              endif
           else
              if nKey == VK_DELETE
                 #ifndef __XHARBOUR__
                    if ::nPos > len( ::oGet:buffer() )
                       return 0
                    endif
                 #endif
                 ::oGet:Delete()
              else
                 #ifndef __XHARBOUR__
                    if hb_isstring( ::oGet:buffer ) .and. ( ::nPos > len( ::oGet:buffer ) )
                       ::oGet:Delete()
                    else
                       ::oGet:BackSpace()
                    endif

              endif
           endif
           ::EditUpdate()
           if ::bChange != nil
              Eval( ::bChange, nKey, nFlags, Self )
           endif

           return 0

                 #else
                 ::oGet:BackSpace()
              endif
           endif
           ::EditUpdate()
           if ::bChange != nil
              Eval( ::bChange, nKey, nFlags, Self )
           endif
           return 0
                 #endif

   endcase

return ::Super:KeyDown( nKey, nFlags )

//---------------------------------------------------------------------------//

METHOD KeyChar( nKey, nFlags ) CLASS TGet

   local nHi, nLo
   local lAccept
   local bKeyAction := SetKey( nKey )
   local nDefButton

   if ::bKeyChar != nil
      if Eval( ::bKeyChar, nKey, nFlags, Self ) == 0
         return 0
      endif
   endif

   if nKey == VK_ESCAPE  // avoids a beep!
      ::oWnd:KeyChar( nKey, nFlags )
      return 1
   endif

   #ifndef __XPP__
   if ! Empty( ::cPicture ) .and. '@!' $ ::cPicture
      nKey = Asc( CharUpper( nKey ) )
   endif
   #endif

   if bKeyAction != nil .and. lAnd( nFlags, 16777216 ) // function Key
      Eval( bKeyAction, ProcName( 4 ), ProcLine( 4 ), Self )
      return 0         // Already processed, API do nothing
   endif

   if ::lReadOnly
      if nKey == VK_ESCAPE
         ::oWnd:End()
      endif
      return 0
   endif

   do case
      case nKey == VK_BACK       // Already processed at KeyDown
           return 0

      // case nKey == VK_ESCAPE
      //     return 0

      case nKey == VK_TAB .and. GetKeyState( VK_SHIFT )
           if ::bChange != nil .and. ( ::oGet:Changed .or. ::oGet:UnTransform() != ::oGet:Original )
              lAccept = Eval( ::bChange, nKey, nFlags, Self )
              if ValType( lAccept ) == "L" .and. lAccept
                 if ::oWnd:IsKindOf( "TCOMBOBOX" )
                    ::oWnd:oWnd:GoPrevCtrl( ::hWnd )
                 else
                    ::oWnd:GoPrevCtrl( ::hWnd )
                 endif
              endif
           else
              if ::oWnd:IsKindOf( "TCOMBOBOX" )
                 ::oWnd:oWnd:GoPrevCtrl( ::hWnd )
              else
                 ::oWnd:GoPrevCtrl( ::hWnd )
              endif
           endif
           return 0

      case nKey == VK_TAB .or. nKey == VK_RETURN
           if ::bChange != nil .and. ( ::oGet:Changed .or. ::oGet:UnTransform() != ::oGet:Original )
              lAccept = Eval( ::bChange, nKey, nFlags, Self )
              if ValType( lAccept ) == "L"
                 if lAccept
                    ::oWnd:GoNextCtrl( ::hWnd )
                 endif
              else
                 ::oWnd:GoNextCtrl( ::hWnd )
              endif
           else
              ::oWnd:GoNextCtrl( ::hWnd )
           endif

           #ifndef __CLIPPER__
               if nKey == VK_RETURN  // Execute DEFPUSHBUTTON Action
                  ::Super:KeyChar( nKey, nFlags )
               endif
           #endif

           return 0

      case nKey >= 32 .and. nKey < 256
           if ::oGet:buffer == nil
              return 0
           endif
           if ::nPos > Len( ::oGet:buffer ) + 1
              return 0
           endif

           ::GetSelPos( @nLo, @nHi )

           // Delete selection
           if nHi != nLo
              ::GetDelSel( nLo, nHi )
              ::EditUpdate()
           endif
           if ::oGet:Type == "N" .and. ;
              ( Chr( nKey ) == "." .or. Chr( nKey ) == "," )
              if ::oGet:Clear()
              #ifndef __XHARBOUR__
                 ::oGet:DelEnd()
              #endif
              endif
              ::oGet:ToDecPos()
           else
              if Set( _SET_INSERT )             // many thanks to HMP
                 ::oGet:Insert( Chr( nKey ) )
              else
                 ::oGet:Overstrike( Chr( nKey ) )
              end
           endif
           if ::oGet:Rejected
              if Set( _SET_BELL )
                 MsgBeep()
              endif
           endif
           ::EditUpdate()
           if nHi+1 == len( ::oGet:buffer )
              ::SetPos( nHi+2 )
           endif
           if ::oGet:TypeOut
              if ! Set( _SET_CONFIRM )
                 ::oWnd:nLastKey = VK_RETURN
                 ::oWnd:GoNextCtrl( ::hWnd )
              else
                 if Set( _SET_BELL )
                    MsgBeep()
                 endif
              endif
           endif
           if ::bChange != nil
              lAccept = Eval( ::bChange, nKey, nFlags, Self )
              if ValType( lAccept ) == "L" .and. ! lAccept
                 return 0
              endif
           endif
           Eval( ::bPostKey, Self, ::oGet:Buffer )
           if ::oBtn != nil
              ::oBtn:Refresh()
           endif

      otherwise
           return ::Super:KeyChar( nKey, nFlags )
   endcase

return 0

//---------------------------------------------------------------------------//

METHOD lValid() CLASS TGet

   local lRet := .t.

   if ::oGet:BadDate
      ::oGet:KillFocus()
      ::oGet:SetFocus()
      MsgBeep()
      return .f.
   else
      ::oGet:Assign()
      if ValType( ::bValid ) == "B"
         lRet := Eval( ::bValid, Self  )
         if ! lRet
            ::oWnd:nLastKey = 0
         endif
      endif
   endif

return lRet

//---------------------------------------------------------------------------//

METHOD LostFocus( hCtlFocus ) CLASS TGet

   ::Super:LostFocus( hCtlFocus )

   if ! ::lPassword
      if ::oGet:buffer != GetWindowText( ::hWnd )  // right click popup action
         ::oGet:buffer  = GetWindowText( ::hWnd )
         ::oGet:Assign()
      endif
   endif

   if ! Empty( ::cPicture ) .and. ::oGet:Type == "N"
      ::oGet:Assign()
      ::oGet:Picture := ::cPicture
      ::oGet:UpdateBuffer()
      ::oGet:KillFocus()
   endif

   ::oGet:SetFocus()   // to avoid oGet:buffer be nil

   if ! ::oGet:BadDate .and. ! ::lReadOnly .and. ;
      ( ::oGet:changed .or. ::oGet:unTransform() <> ::oGet:original )
      ::oGet:Assign()     // for adjust numbers
      // ::oGet:UpdateBuffer()
   endif

   if ::lClrFocus
      if ::nOldClrPane != nil
         ::SetColor( ::nClrText, ::nOldClrPane )
      endif
   endif

   if ::oGet:Type == "D"
      ::oGet:KillFocus()
      ::oGet:SetFocus()
   endif
   ::DispText()

   if ! ::oGet:BadDate
      ::oGet:KillFocus()
   else
      ::oGet:Pos = 1
      ::nPos = 1
   endif

return nil

//----------------------------------------------------------------------------//

METHOD Paint() CLASS TGet

   local aInfo := ::DispBegin()
   local hOldFont
   local nClrBtnTxt, nClrBtnPane
   local nOldMode

   nClrBtnTxt := ::nClrText
   nClrBtnPane := ::nClrPane

   if ::oBrush != nil
      FillRect( ::hDC, GetClientRect( ::hWnd ), ::oBrush:hBrush )
   else
      CallWindowProc( ::nOldProc, ::hWnd, WM_ERASEBKGND, ::hDC, 0 )
   endif

   if IsWindowEnabled( ::hWnd ) .and. ! ::lReadOnly
      CallWindowProc( ::nOldProc, ::hWnd, WM_PAINT, ::hDC, 0 )
   else
      if ::lDisColors
         SetTextColor( ::hDC, GetSysColor( COLOR_GRAYTEXT ) )
         SetBkColor( ::hDC, GetSysColor( COLOR_WINDOW ) )
         nClrBtnPane := GetSysColor( COLOR_WINDOW )
      else
         if ValType( ::nClrTextDis ) == "B"
            SetTextColor( ::hDC, Eval( ::nClrTextDis ) )
         elseif ValType( ::nClrTextDis ) == "N"
            if ::nClrTextDis >= 0
               SetTextColor( ::hDC, ::nClrTextDis  )
               nClrBtnTxt := ::nClrTextDis
            else
               SetTextColor( ::hDC, ::nClrText )
            endif
        endif

        if ValType( ::nClrPaneDis ) == "B"
            SetBkColor( ::hDC, Eval( ::nClrPaneDis ) )
        elseif ValType( ::nClrPaneDis ) == "N"
            if ::nClrPaneDis >= 0
               SetBkColor( ::hDC, ::nClrPaneDis  )
               nClrBtnPane := ::nClrPaneDis
            else
               SetBkColor( ::hDC, ::nClrPane )
            endif
        endif
      endif

      if ::oFont != nil
         hOldFont = SelectObject( ::hDC, ::oFont:hFont )
      endif

      nOldMode = SetBkMode( ::hDC, TRANSPARENT )

      do case
         case lAnd( GetWindowLong( ::hWnd, GWL_STYLE ), ES_CENTER )
              SetTextAlign( ::hDC, TA_CENTER )
              if ::lSpinner
                 ExtTextOut( ::hDC, 1, ( ::nWidth() - 3 - GetSysMetrics( SM_CYHSCROLL ) ) / 2,;
                    { 0, 0, ::nHeight(), ::nWidth() }, GetWindowText( ::hWnd ), ::nTxtStyle )
              else
                 ExtTextOut( ::hDC, 1, ( ::nWidth() - 3 ) / 2,;
                   { 0, 0, ::nHeight(), ::nWidth() }, GetWindowText( ::hWnd ), ::nTxtStyle )
              endif

                 case lAnd( GetWindowLong( ::hWnd, GWL_STYLE ), ES_RIGHT )
              SetTextAlign( ::hDC, TA_RIGHT )
              if ::lSpinner
                 ExtTextOut( ::hDC, 1, ::nWidth() - 7 - GetSysMetrics( SM_CYHSCROLL ),;
                    { 0, 0, ::nHeight(), ::nWidth() }, GetWindowText( ::hWnd ), ::nTxtStyle )
              else
                  if ValType( ::bAction ) == "B"
                      ExtTextOut( ::hDC, 1, ::nWidth() - 7 - ::nHeight,;
                    { 0, 0, ::nHeight(), ::nWidth() }, GetWindowText( ::hWnd ), ::nTxtStyle )
                 else
                    ExtTextOut( ::hDC, 1, ::nWidth() - 7 ,;
                    { 0, 0, ::nHeight(), ::nWidth() }, GetWindowText( ::hWnd ), ::nTxtStyle )
                  endif
              endif

         otherwise
              SetTextAlign( ::hDC, TA_LEFT )
              ExtTextOut( ::hDC, 1, 2,;
                { 0, 0, ::nHeight(), ::nWidth() }, GetWindowText( ::hWnd ), ::nTxtStyle )
      endcase

      if ::oFont != nil
         SelectObject( ::hDC, hOldFont )
      endif

      SetBkMode( ::hDC, nOldMode )

   endif


   if ValType( ::bPainted ) == "B"
      Eval( ::bPainted, ::hDC, ::cPS, Self )
   endif

// button

  if ::oBtn != nil .and. ::lBtnTransparent
     ::oBtn:SetColor( nClrBtnTxt, nClrBtnPane )
  endif


  ::DispEnd( aInfo )

return 1

//----------------------------------------------------------------------------//

METHOD Paste( cText ) CLASS TGet

   local oClp, cTemp, nLen

   DEFINE CLIPBOARD oClp OF Self FORMAT TEXT

   if cText == nil
      if oClp:Open()
         cText = oClp:GetText()
         oClp:Close()
      else
         msgStop( "The clipboard is not available!" )
      endif
   endif

   if ! Empty( cText )
      cTemp = ::GetText()
      nLen = Len( ::oGet:Buffer )

      do case
         case ValType( cTemp ) == "C"
              ::oGet:Buffer = SubStr( cTemp, 1, ::nPos - 1 ) + Trim( cText ) + ;
                        SubStr( cTemp, ::nPos )

         case ValType( cTemp ) == "N"
              cTemp = cValToChar( cTemp )
              ::oGet:Buffer = Val( SubStr( cTemp, 1, ::nPos - 1 ) + Trim( cText ) + ;
                             SubStr( cTemp, ::nPos ) )

         case ValType( cTemp ) == "D"
              cTemp = cValToChar( cTemp )
              ::oGet:Buffer = CToD( SubStr( cTemp, 1, ::nPos - 1 ) + Trim( cText ) + ;
                              SubStr( cTemp, ::nPos ) )
      endcase

      ::oGet:Buffer = Pad( ::oGet:Buffer, nLen )

      ::DispText() // from buffer to screen

      if ::bChange != nil
         Eval( ::bChange,,, Self )
      endif

      if ::oBtn != nil
         ::oBtn:Refresh()
      endif

   endif

return nil


//----------------------------------------------------------------------------//

METHOD DispText() CLASS TGet

   if ::lPassword .and. ::oGet:Type == "C"
      #ifdef __CLIPPER__
         SetWindowText( ::hWnd, Replicate( "*", Len( Trim( ::oGet:buffer ) ) ) )
      #else
         SetWindowText( ::hWnd, Replicate( If( IsAppThemed(), Chr( 149 ), "*" ),;
                                           Len( Trim( ::oGet:buffer ) ) ) )
      #endif
   else
      SetWindowText( ::hWnd, If( ! Empty( ::cCueText );
                                   .and. Empty( ::oGet:VarGet() );
                                   .and. GetFocus() != ::hWnd,;  // Focus is outside
                                   "", ::oGet:buffer ) )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD Move( nTop, nLeft, nBottom, nRight, lRepaint ) CLASS TGet

   ::Super:Move( nTop, nLeft, nBottom, nRight, lRepaint )
   MoveGet( ::hWnd, ::nRight - ::nLeft, ::nBottom - ::nTop )

return nil

//----------------------------------------------------------------------------//

METHOD GoHome() CLASS TGet

   ::oGet:Home()
   if ::oGet:Type == "N"  // flag to clear buffer if typing is detected
      ::oGet:Clear := .t.
   endif
   ::SetPos( ::oGet:Pos )

return Self

//----------------------------------------------------------------------------//

METHOD GotFocus( hCtlLost ) CLASS TGet

    ::lFocused = .T.

    #ifdef __XHARBOUR__
       ::oGet:VarGet()
    #endif

    if ! Empty( ::cPicture ) .and. ::oGet:Type == "N"
       ::oGet:Picture := StrTran( ::cPicture, ",", "" )
    endif

    if ! ::lDrag
       ::oGet:KillFocus()   // to properly initialize internal status
       ::oGet:SetFocus()
       if Upper( ::oWnd:ClassName() ) == "TCOMBOBOX"
          ::oGet:Buffer := ::oGet:Original
       endif
       if ::lClrFocus
          ::nOldClrPane = ::nClrPane
          ::SetColor( ::nClrText,;
              If( ValType( ::nClrFocus ) == "B", Eval( ::nClrFocus ), ::nClrFocus ) )
       endif
       ::DispText()
       if ::oGet:Type $ "DN" .or. ::oGet:Pos != 1 // 28/06/05 AL
          ::nPos := ::oGet:Pos // 1   28/06/05 AL
       endif
       ::oGet:Pos := ::nPos
       ::SetPos( ::nPos )
       CallWindowProc( ::nOldProc, ::hWnd, WM_SETFOCUS )
       if Set( _SET_INSERT )
          DestroyCaret()
          CreateCaret( ::hWnd, 0, 6, ::nGetChrHeight() - 1 )
          ShowCaret( ::hWnd )
       endif
    else
       HideCaret( ::hWnd )
    endif

    ::Super:GotFocus( hCtlLost )

return 0

//----------------------------------------------------------------------------//

METHOD LButtonDown( nRow, nCol, nFlags ) CLASS TGet

   local nLo, nHi

   if ::lDrag
      return ::Super:LButtonDown( nRow, nCol, nFlags )
   else
      CallWindowProc( ::nOldProc, ::hWnd, WM_LBUTTONDOWN, nFlags,;
                      nMakeLong( nCol, nRow ) )
      ::GetSelPos( @nLo, @nHi )
      ::nPos = nHi + 1
      if ::oGet:Type != "N" .and. ::nPos == 1
         ::oGet:Home()
         ::SetPos( ::oGet:Pos )
      else
         ::oGet:Pos = ::nPos
      endif
      if ::bLClicked != nil
         Eval( ::bLClicked, nRow, nCol, nFlags, Self )
      endif
      if ::oBtn != nil
         ::oBtn:Refresh()
      endif
      return 1
   endif

return nil

//----------------------------------------------------------------------------//

METHOD LButtonUp( nRow, nCol, nFlags ) CLASS TGet

   local nLo, nHi, cText

   if ::lDrag
      ::Super:LButtonUp( nRow, nCol, nFlags )
      SysRefresh()
      ::Refresh()
      return 0
   else
      cText = ::GetText()
      if Left( cText, 1 ) == "("
         ::nPos = 2
         ::SetPos( ::nPos )
      elseif Empty( cText ) .or. RTrim( cText ) == "  /  /" .or. ;
         AllTrim( cText ) == "0" .or. ;
         RTrim( cText ) == "   -  -"
         ::nPos = 1
         ::SetPos( ::nPos )
      else
         ::GetSelPos( @nLo, @nHi )
         ::oGet:pos = nHi + 1
         ::nPos = nHi + 1 // don't use ::oGet:pos here! as it does not allow higher values
      endif
      if ::oBtn != nil
         ::oBtn:Refresh()
      endif
   endif
   if ::oGet:buffer != nil .and. ::nPos > Len( ::oGet:buffer )
      ::nPos = Len( ::oGet:buffer ) + 1
      ::oGet:pos = ::nPos
   endif

return nil

//----------------------------------------------------------------------------//

METHOD KeyUp( nVKey, nFlags ) CLASS TGet

   local nLo

   if ( nVKey == VK_INSERT .and. GetKeyState( VK_SHIFT ) ) .or. ;
      ( nVKey == 86 .and. GetKeyState( VK_CONTROL ) )
      nLo = Len( ::oGet:buffer )
      ::oGet:buffer = Pad( GetWindowText( ::hWnd ), nLo )
      if ::SendMsg( EM_GETSEL ) != 0
         ::oGet:pos = Min( nHiWord( ::SendMsg( EM_GETSEL ) ) + 1, nLo )
      else
         // ::oGet:pos =
      endif
      ::EditUpdate()
   elseif nVKey == VK_UP .or. nVKey == VK_DOWN
         return 1  // We have not processed the key and we don't let
                   // the edit to do it
   endif

return nil

//----------------------------------------------------------------------------//

METHOD RButtonDown( nRow, nCol, nFlags ) CLASS TGet

   if GetFocus() != ::hWnd
      ::SetFocus()
      SysRefresh()              // In case there is a VALID somewhere
      if GetFocus() != ::hWnd
         return nil
      endif
   endif

   if ::bRClicked != nil
      return Eval( ::bRClicked, nRow, nCol, nFlags )
   endif

return nil  // Invokes default popup menu

//----------------------------------------------------------------------------//

METHOD Resize( nType, nWidth, nHeight ) CLASS TGet

   if ::lDrag       // a line remains on the surface
      ::Refresh()
   endif

return ::Super:ReSize( nType, nWidth, nHeight )

//----------------------------------------------------------------------------//

METHOD SaveToRC( nIndent ) CLASS TGet

   local cRC := Space( nIndent ) + "EDITTEXT "

   // cRC += '"' + ::cCaption + '", '
   cRC += AllTrim( Str( ::nId ) ) + ", "
   cRC += AllTrim( Str( ::nTop ) ) + ", "
   cRC += AllTrim( Str( ::nLeft ) ) + ", "
   cRC += AllTrim( Str( ::nWidth ) ) + ", "
   cRC += AllTrim( Str( ::nHeight ) )

return cRC

//----------------------------------------------------------------------------//

METHOD SelFile( cMask, cTitle ) CLASS TGet

   local cFileName := Eval( ::bSetGet )

   DEFAULT cFileName := "*.*",;
           cMask := cFileName, cTitle := "Please select a file"

   cFileName = cGetFile( cMask, cTitle )

   if ! Empty( cFileName )
      ::VarPut( cFileName )
      ::Refresh()
   endif

return cFileName

//----------------------------------------------------------------------------//

METHOD _SetPos( nStart, nEnd ) CLASS TGet

   DEFAULT nStart := 1, nEnd := nStart

   #ifdef __CLIPPER__
      ::SendMsg( EM_SETSEL, 0,;
                 nMakeLong( nStart - If( nStart > 0, 1, 0 ),;
                 nEnd - If( nEnd > 0, 1, 0 ) ) )
   #else
      ::SendMsg( EM_SETSEL, nStart - If( nStart > 0, 1, 0 ),;
                 nEnd - If( nEnd > 0, 1, 0 ) )
   #endif

   ::nPos := nStart
   if ::lFocused
      ::oGet:Pos = nStart
   endif

return nil

//----------------------------------------------------------------------------//

METHOD Cut() CLASS TGet

   local nLo, nHi, cTemp

   if ::lReadOnly
      msgStop( "The get is read only!", "Can't cut" )
      return nil
   endif

   ::Copy()
   ::GetSelPos( @nLo, @nHi )

   if nHi != nLo
      ::GetDelSel( nLo, nHi )
   endif

   ::EditUpdate()
   cTemp = ::VarGet()

   do case
      case ValType( cTemp ) == "C"
           Eval( ::bSetGet, ::GetText() )

      case ValType( cTemp ) == "N"
           Eval( ::bSetGet, Val( ::GetText() ) )

      case ValType( cTemp ) == "D"
           Eval( ::bSetGet, CToD( ::GetText() ) )
   endcase

   ::EditUpdate()

   // EMW - the text has been changed!
   if ::bChange != nil
      Eval( ::bChange,,, Self )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD Inc() CLASS TGet

   LOCAL xValue

   if ! ::oGet:BadDate .and. ! ::lReadOnly
      ::oGet:Assign()
      ::oGet:UpdateBuffer()
   endif

   #ifndef __XPP__
      xValue := ::Value
   #else
      xValue := ::VarGet()
   #endif

   if Valtype( xValue ) $ "ND"

      if Valtype( xValue ) == "N"
         ::ScrollNumber( 1 )
      else
         ::ScrollDate( 1 )
      endif

      #ifndef __XPP__
         if ::Value != xValue .and. ::bChange != nil
      #else
         if ::VarGet() != xValue .and. ::bChange != nil
      #endif
         Eval( ::bChange,,, Self )
      endif

   endif

RETURN Self

//----------------------------------------------------------------------------//

METHOD Dec() CLASS TGet

   LOCAL xValue

   if ! ::oGet:BadDate .and. ! ::lReadOnly
      ::oGet:Assign()
      ::oGet:UpdateBuffer()
   endif

   #ifndef __XPP__
      xValue := ::Value
   #else
      xValue := ::VarGet()
   #endif

   if Valtype( xValue ) $ "ND"

      if Valtype( xValue ) == "N"
         ::ScrollNumber( -1 )
      else
         ::ScrollDate( -1 )
      endif

      #ifndef __XPP__
         if ::Value != xValue .and. ::bChange != nil
      #else
         if ::VarGet() != xValue .and. ::bChange != nil
      #endif
         Eval( ::bChange,,, Self )
      endif

   endif

RETURN Self

//----------------------------------------------------------------------------//

METHOD Spinner( bUp, bDown, bMin, bMax ) CLASS TGet

   If ::lReadOnly
      return nil
   Endif

   ::bMin := bMin
   ::bMax := bMax

   DEFINE SCROLLBAR ::oVScroll VERTICAL OF Self

   #ifndef __XPP__
      DEFAULT bUp   := {|| Self++ } ,;
              bDown := {|| Self-- }
   #else
      DEFAULT bUp   := {|| ::TGet:Inc() } ,;
              bDown := {|| ::TGet:Dec() }
   #endif

   ::oVScroll:bGoUp   := {|| If( GetFocus() != ::hWnd, ::SetFocus(),),;
                             Eval( bUp ) }
   ::oVScroll:bGoDown := {|| If( GetFocus() != ::hWnd, ::SetFocus(),),;
                             Eval( bDown ) }

RETURN NIL

//----------------------------------------------------------------------------//

METHOD ScrollDate( nDirection ) CLASS TGet

   LOCAL cFormat, cDate, cType
   LOCAL dDate
   LOCAL nYear, nDay, nMonth, nPos

   #ifndef __XPP__
      dDate := ::Value
   #else
      dDate := ::VarGet()
   #endif

   nPos    := ::nPos
   cFormat := Set( _SET_DATEFORMAT, "yyyy.mm.dd" )
   nYear   := Year( dDate )
   nMonth  := Month( dDate )
   nDay    := Day( dDate )
   cType   := Upper( Substr( cFormat, nPos, 1 ) )

   If ! cType $ "MDY" .and. nPos > 1
      cType = Upper( Substr( cFormat, nPos - 1, 1 ) )
   Endif

   do case
   case cType == "D"
      dDate += nDirection
   case cType == "M"
      nMonth += nDirection
      if nMonth > 12
         nMonth := 1
         nYear  ++
      elseif nMonth < 1
         nMonth := 12
         nYear  --
      endif
      cDate  := Str( nYear, 4 ) + "." + StrZero( nMonth, 2 ) + "." + StrZero( nDay, 2 )
      dDate  := Ctod(cDate)
      If Empty( dDate )
         nDay  := LastDay( Ctod( Str( nYear, 4 ) + "." + StrZero( nMonth, 2 ) + ".01" ) )
         cDate := Str( nYear, 4 ) + "." + StrZero( nMonth, 2 ) + "." + StrZero( nDay, 2 )
         dDate := Ctod(cDate)
      Endif
   case cType == "Y"
      nYear += nDirection
      cDate := Str( nYear, 4 ) + "." + StrZero( nMonth, 2 ) + "." + StrZero( nDay, 2 )
      dDate := Ctod(cDate)
   end case

   Set( _SET_DATEFORMAT, cFormat )

   if nDirection > 0
      if ::bMax != NIL .and. dDate > Eval( ::bMax )
         MessageBeep()
      else
         ::cText( dDate )
      endif
   else
      if ::bMin != NIL .and. dDate < Eval( ::bMin )
         MessageBeep()
      else
         ::cText( dDate )
      endif
   endif

#ifndef __CLIPPER__
   do case
   case cType == "D"
      ::SetSel( 0, 2 )
   case cType == "M"
      ::SetSel( 3, 5 )
      ::nPos := 5
   case cType == "Y"
      ::SetSel( 6, 12 )
      ::nPos := Len(cDate) - 1
   end case
#else
   ::SetPos( nPos )
#endif


RETURN nil

//----------------------------------------------------------------------------//

METHOD ScrollNumber( nDirection ) CLASS TGet

   LOCAL nValue, nDec, nPos

   #ifndef __XPP__
      nValue := ::Value
   #else
      nValue := ::VarGet()
   #endif

   nPos := ::nPos

   if !Empty( ::oGet:DecPos ) .and. nPos >= ::oGet:DecPos
      nDec   := Max( 1, nPos - ::oGet:DecPos - 1 )
      If nDirection > 0
         nValue += 1 / ( 10 ^ nDec )
      else
         nValue -= 1 / ( 10 ^ nDec )
      Endif
   else
      nValue += nDirection
   endif

   if nDirection > 0
      if ::bMax != NIL .and. nValue > Eval( ::bMax )
         MessageBeep()
      else
         ::cText( nValue )
      endif
   else
      if ::bMin != NIL .and. nValue < Eval( ::bMin )
         MessageBeep()
      else
         ::cText( nValue )
      endif
   endif

   ::oGet:KillFocus()
   ::oGet:SetFocus()
   ::SetPos( nPos )

RETURN nil

//----------------------------------------------------------------------------//

METHOD SetColorFocus( nClrFocus ) CLASS TGet

   local nOldClrFocus := ::nClrFocus

   ::lClrFocus = .T.

   if nClrFocus != nil
      ::nClrFocus = nClrFocus
   endif

return nOldClrFocus

//----------------------------------------------------------------------------//

function SetGetColorFocus( nClrFocus )

return TGet():SetColorFocus( nClrFocus )

//----------------------------------------------------------------------------//

static function LastDay( dDate )

   local nMonth := Month( dDate )

   while Month( dDate ) == nMonth
      dDate++
   end

   dDate--

return Day( dDate )

//----------------------------------------------------------------------------//
