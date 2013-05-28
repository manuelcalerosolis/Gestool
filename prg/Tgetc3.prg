#include "FiveWin.Ch"
#include "Constant.ch"
#include "Set.ch"

#define ES_PASSWORD         32   // 0x020
#define GWL_STYLE          -16

#define COLOR_WINDOW         5
#define COLOR_WINDOWTEXT     8
#define COLOR_BTNFACE       15
#define COLOR_GRAYTEXT      17

#define ES_CENTER            1

#define DM_GETDEFID  WM_USER

#define MB_ICONEXCLAMATION  48   // 0x0030

#define CW_USEDEFAULT    32768

#ifdef __CLIPPER__
   #define EM_GETSEL    (WM_USER+0)
   #define EM_SETSEL    (WM_USER+1)
   #define EM_UNDO     (WM_USER+23)
#else
   #define EM_GETSEL      176
   #define EM_SETSEL      177
   #define EM_UNDO        199
   #ifdef __XPP__
      #define Super  ::TControl
      #define New    _New
      #define GetNew _GetNew
      #define GetDelSel _GetDelSel
   #endif
#endif

//----------------------------------------------------------------------------//

CLASS TGet FROM TControl

   DATA   oGet
   DATA   bMin, bMax
   DATA   nClrDef
   DATA   nPos
   DATA   lReadOnly, lPassword
   DATA   cError AS String
   DATA   hHeap AS NUMERIC  INIT 0  // Own heap for @ ..., ... GET
   DATA   cPicture

   METHOD New( nRow, nCol, bSetGet, oWnd, nWidth, nHeight, cPict, bValid,;
               nClrFore, nClrBack, oFont, lDesign, oCursor, lPixel,;
               cMsg, lUpdate, bWhen, lCenter, lRight, bChanged,;
               lReadOnly, lPassword, lNoBorder, nHelpId,;
               lSpinner, bUp, bDown, bMin, bMax ) CONSTRUCTOR

   METHOD Assign() INLINE ::oGet:Assign()

   METHOD cToChar() INLINE Super:cToChar( "EDIT" )

   METHOD Copy()

   METHOD Create( cClsName )

   METHOD Cut()

   METHOD Default()

   METHOD Destroy()

   METHOD cGenPrg()

   METHOD GetDlgCode( nLastKey )

   METHOD GotFocus()

   METHOD Initiate( hDlg )

   METHOD KeyDown( nKey, nFlags )
   METHOD KeyChar( nKey, nFlags )
   METHOD KeyUp( nKey, nFlags )

   METHOD LButtonDown( nRow, nCol, nFlags )
   METHOD LButtonUp( nRow, nCol, nFlags )

   METHOD LostFocus( hCtlFocus )

   METHOD MouseMove( nRow, nCol, nKeyFlags )

   METHOD cText( cText ) SETGET

   METHOD ReDefine( nId, bSetGet, oWnd, nHelpId, cPict, bValid,;
                    nClrFore, nClrBack, oFont, oCursor, cMsg,;
                    lUpdate, bWhen, bChanged, lReadOnly,;
                    lSpinner, bUp, bDown, bMin, bMax ) CONSTRUCTOR

   METHOD Refresh() INLINE ::oGet:SetFocus(),;
                           ::oGet:UpdateBuffer(),;
                           ::DispText(),;
                           ::SetPos( 1 )

   METHOD DispText()
   METHOD GetSel()
   METHOD GetSelPos( @nStart, @nEnd )
   METHOD GetDelSel( nStart, nEnd )

   METHOD EditUpdate()

   METHOD HideSel() INLINE ::SetSel( -1, 0 )

   METHOD lValid()

   METHOD Paste( cText )

   METHOD RButtonDown( nRow, nCol, nFlags )

   METHOD Resize( nType, nWidth, nHeight )

   METHOD SelectAll() INLINE ::SetSel( 0, -1 )

   METHOD SelFile( cMask, cTitle )

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

   #ifndef __CLIPPER__
      #ifndef __C3__
      METHOD VarPut( uVal ) INLINE  If( ValType( ::bSetGet ) == "B",;
                       ( Eval( ::bSetGet, uVal ), ::oGet:Type := ValType( uVal ) ),)
      #endif
   #endif

   METHOD Inc()   OPERATOR "++"
   METHOD Dec()   OPERATOR "--"
   METHOD ScrollDate( nDirection )
   METHOD ScrollNumber( nDirection )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( nRow, nCol, bSetGet, oWnd, nWidth, nHeight, cPict, bValid,;
            nClrFore, nClrBack, oFont, lDesign, oCursor, lPixel, cMsg,;
            lUpdate, bWhen, lCenter, lRight, bChanged, lReadOnly,;
            lPassword, lNoBorder, nHelpId, lSpinner,;
            bUp, bDown, bMin, bMax ) CLASS TGet

#ifdef __XPP__
   #undef New
#endif

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

   ::nTop     = nRow * If( lPixel, 1, GET_CHARPIX_H )	 //13
   ::nLeft    = nCol * If( lPixel, 1, GET_CHARPIX_W )	 // 8
   ::nBottom  = ::nTop + nHeight - 1
   ::nRight   = ::nLeft + If( nWidth == nil, ( 1 + Len( ::cCaption ) ) * 3.5, ;
                                               nWidth - 1 ) + ;
                If( lSpinner, 20, 0 )
   ::oWnd      = oWnd
   ::nStyle    = nOR( WS_CHILD, WS_VISIBLE,;
                      ES_AUTOHSCROLL, WS_BORDER,;
                      If( ! lReadOnly, WS_TABSTOP, 0 ),;
                      If( lDesign, WS_CLIPSIBLINGS, 0 ),;
                      If( lSpinner, WS_VSCROLL, 0 ),;
                      If( lReadOnly, ES_READONLY, 0 ),;
                      If( lCenter, ES_CENTER, If( lRight, ES_RIGHT, ES_LEFT ) ) )
//                      If( lCenter .OR. lRight, ES_MULTILINE, 0 ),; Only needed for Win31

   ::nStyle    = If( lNoBorder, nAnd( ::nStyle, nNot( WS_BORDER ) ), ::nStyle )
   ::nId       = ::GetNewId()
   ::bSetGet   = bSetGet
   ::oGet      = GetNew( 20, 20, bSetGet,, cPict )
   ::bValid    = bValid
   ::lDrag     = lDesign
   ::lCaptured = .f.
   ::lPassword = lPassword
   ::oFont     = oFont
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

   ::SetColor( nClrFore, nClrBack )
   ::nClrDef := nClrBack

   ::oGet:SetFocus()
   ::cCaption = ::oGet:Buffer
   ::oGet:KillFocus()

   if ! Empty( oWnd:hWnd )
      ::Create( "EDIT" )
      if oFont != nil
         ::SetFont( oFont )
      endif
      ::GetFont()
      oWnd:AddControl( Self )
   else
      oWnd:DefControl( Self )
   endif

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
                 lReadOnly, lSpinner, bUp, bDown, bMin, bMax ) CLASS TGet

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
   ::oGet      = GetNew( 20, 20, bSetGet,, cPict )
   ::bValid    = bValid
   ::lDrag     = .f.
   ::lCaptured = .f.
   ::lPassword = .f.
   ::oFont     = oFont
   ::oCursor   = oCursor
   ::cMsg      = cMsg
   ::lUpdate   = lUpdate
   ::bWhen     = bWhen
   ::bChange   = bChanged
   ::nPos      =  1  // 0   14/Aug/98
   ::lReadOnly = lReadOnly
   ::lFocused  = .f.
   ::cPicture  = cPict

   ::SetColor( nClrFore, nClrBack )
   ::nClrDef := nClrBack

   if lSpinner
      ::Spinner(bUp, bDown, bMin, bMax)
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
                           ::nId, @hHeap )
    else
      ::hWnd = MGetCreate( cClsName, ::cCaption, ::nStyle, ;
                           ::nLeft, ::nTop, ::nRight, ::nBottom, ;
                           If( ::oWnd != nil, ::oWnd:hWnd, 0 ), ;
                           ::nId, @hHeap )
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

METHOD GetDlgCode( nLastKey ) CLASS TGet

   #ifdef __CLIPPER__
   // Needed to do non-modal editing on a browse
      if Len( ::oWnd:aControls ) == 1 .and. ::oWnd:ChildLevel( TWBrowse() ) != 0
         return DLGC_WANTALLKEYS
      endif
   #else
      if Len( ::oWnd:aControls ) == 1
         return DLGC_WANTALLKEYS
      endif
   #endif

#ifndef __HARBOUR__
   return Super:GetDlgCode( nLastKey )
#else
   ::oWnd:nLastKey = nLastKey
   return DLGC_WANTALLKEYS
#endif

//----------------------------------------------------------------------------//

METHOD Initiate( hDlg ) CLASS TGet

   Super:Initiate( hDlg )
   ::oGet:SetFocus()

   if lAnd( GetWindowLong( ::hWnd, GWL_STYLE ), ES_PASSWORD )
      ::lPassword = .t.
   endif

   if ::lReadOnly .and. ::nClrText == GetSysColor( COLOR_WINDOWTEXT ) ;
      .and. ::nClrPane == GetSysColor( COLOR_WINDOW )
      ::SetColor(GetSysColor(COLOR_GRAYTEXT) , GetSysColor( COLOR_BTNFACE ))
//     ::Disable()
   endif

   ::DispText()
   ::oGet:KillFocus()

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

   if PCount() == 1      // OJO Con Objects 2.0 PCount() es PCount() + 1
      ::oGet:VarPut( uVal )
      ::Refresh()
   endif

return GetWindowText( ::hWnd )

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

   ::oGet:Assign()

   #ifndef __CLIPPER__
      if ::oGet:Type == "D"
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
      return Super:MouseMove( nRow, nCol, nKeyFlags )
   else
      ::oWnd:SetMsg( ::cMsg )        // Many thanks to HMP
      if ::oCursor != nil
         SetCursor( ::oCursor:hCursor )
      else
         CursorIBeam()
      endif
      ::CheckToolTip()
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
      // LocalShrink( ::hHeap, 0 )
      ::hHeap = 0
   endif

return Super:Destroy()

//---------------------------------------------------------------------------//

METHOD cGenPrg() CLASS TGet

   local cCode := ""

   cCode += CRLF + "   @ " + Str( ::nTop, 3 ) + ", " + Str( ::nLeft, 3 ) + ;
            " GET oGet SIZE " + Str( ::nRight - ::nLeft + 1, 3 ) + ;
            ", " + Str( ::nBottom - ::nTop + 1, 3 ) + ;
            " PIXEL OF oWnd " + CRLF

return cCode

//---------------------------------------------------------------------------//

METHOD KeyDown( nKey, nFlags ) CLASS TGet

   local nHi, nLo, nPos

   ::nLastKey = nKey

   do case
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
           if GetKeyState( VK_CONTROL )
              ::oGet:WordLeft()
           else
              ::oGet:Left()
           endif
           while .t.
              CallWindowProc( ::nOldProc, ::hWnd, WM_KEYDOWN, nKey, nFlags )
              ::GetSelPos( @nLo, @nHi )
              if nLo <= ::oGet:Pos - 1
                 EXIT
              endif
           end
           ::nPos = nLo + 1
           if ::nPos < ::oGet:Pos
              ::SetPos( ::oGet:Pos )
           else
              ::oGet:Pos = ::nPos
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
                 if nHi + 1 >= ::oGet:Pos .or. ::lPassword  // >= changed 12/12
                    EXIT
                 endif
              end
              ::oGet:Pos = nHi + 1
              ::nPos     = nHi + 1
           endif
           return 0
                                          // Many thanks to HMP
      case nKey == VK_INSERT .and. ! GetKeyState( VK_SHIFT ) ;
           .and. ! GetKeyState( VK_CONTROL )   // to copy to the clipboard

           Set( _SET_INSERT, ! Set( _SET_INSERT ) )
           DestroyCaret()
           if Set( _SET_INSERT )
              CreateCaret( ::hWnd, 0, 6, ::nGetChrHeight() )
           else
              CreateCaret( ::hWnd, 0, 2, ::nGetChrHeight() )
           endif
           ShowCaret( ::hWnd )
           return 0

      case ( nKey == VK_INSERT .and. GetKeyState( VK_SHIFT ) ) .or. ;
           ( nKey == ASC("V") .and. GetKeyState( VK_CONTROL ) ) .or. ;
           ( nKey == ASC('X') .and. GetKeyState( VK_CONTROL ) )

          if ! ::lReadOnly
             CallWindowProc( ::nOldProc, ::hWnd, WM_KEYDOWN, nKey, nFlags )
             SysRefresh()
             ::oGet:buffer = GetWindowText( ::hWnd )
             ::oGet:Assign()
             ::GetSelPos( @nLo, @nHi )
             ::nPos = nHi + 1
             ::oGet:Pos = ::nPos
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
                  ::SetPos( ::oGet:Pos )
               endif
           endif
           return 0

      case nKey == VK_DELETE .or. nKey == VK_BACK

           if ::lReadOnly
              return 0
           endif

           if ::lDrag
              return Super:KeyDown( nKey, nFlags )
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
                 ::oGet:Delete()
              else
                 ::oGet:BackSpace()
              endif
           endif
           ::EditUpdate()
           if ::bChange != nil
              Eval( ::bChange, nKey, nFlags, Self )
           endif
           return 0
   endcase

return Super:KeyDown( nKey, nFlags )

//---------------------------------------------------------------------------//

METHOD KeyChar( nKey, nFlags ) CLASS TGet

   local nHi, nLo
   local lAccept
   local bKeyAction := SetKey( nKey )
   local nDefButton

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

      //case nKey == VK_ESCAPE
      //     return 0

      case nKey == VK_TAB .and. GetKeyState( VK_SHIFT )
           if ::bChange != nil
              lAccept = Eval( ::bChange, nKey, nFlags, Self )
              if ValType( lAccept ) == "L" .and. lAccept
                 ::oWnd:GoPrevCtrl( ::hWnd )
              endif
           else
              ::oWnd:GoPrevCtrl( ::hWnd )
           endif
           return 0

      case nKey == VK_TAB .or. nKey == VK_RETURN
           if ::bChange != nil
              lAccept = Eval( ::bChange, nKey, nFlags, Self )
              if ValType( lAccept ) == "L" .and. lAccept
                 ::oWnd:GoNextCtrl( ::hWnd )
              endif
           else
              ::oWnd:GoNextCtrl( ::hWnd )
           endif

           // Hernan Ceccarelli added 18-December-2001
           #ifdef __HARBOUR__
               if nKey == VK_RETURN  // Execute DEFPUSHBUTTON Action
                  Super:KeyChar( nKey, nFlags )
               endif
           #endif

           return 0

      case nKey >= 32 .and. nKey < 256
           ::GetSelPos( @nLo, @nHi )
           // Delete selection
           if nHi != nLo
              ::GetDelSel( nLo, nHi )
              ::EditUpdate()
           endif
           if ::oGet:Type == "N" .and. ;
              ( Chr( nKey ) == "." .or. Chr( nKey ) == "," )
              ::oGet:ToDecPos()
           else
              if ::bChange != nil
                 lAccept = Eval( ::bChange, nKey, nFlags, Self )
                 if ValType( lAccept ) == "L" .and. ! lAccept
                    return 0
                 endif
              endif
              if Set( _SET_INSERT )             // many thanks to HMP
                 ::oGet:Insert( Chr( nKey ) )
              else
                 ::oGet:Overstrike( Chr( nKey ) )
              end
           endif
           if ::oGet:Rejected()
              MsgBeep()
           endif
           ::EditUpdate()
           if ::oGet:TypeOut
              if ! Set( _SET_CONFIRM )
                 ::oWnd:nLastKey = VK_RETURN  // VK_DOWN 17/10/95
                 ::oWnd:GoNextCtrl( ::hWnd )
              else
                 MsgBeep()
              endif
           endif

      otherwise
           return Super:KeyChar( nKey, nFlags )
   endcase

return 0

//---------------------------------------------------------------------------//

METHOD lValid() CLASS TGet

   local lRet := .t.

   if ::oGet:BadDate
      MsgBeep()
      return .f.
   else
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

   Super:LostFocus( hCtlFocus )

   if ! ::lPassword
      if ::oGet:buffer != GetWindowText( ::hWnd )  // right click popup action
         ::oGet:buffer  = GetWindowText( ::hWnd )
         ::oGet:Assign()
      endif
   endif

   if ! Empty( ::cPicture ) .and. ::oGet:type == "N"
      ::oGet:Assign()
      ::oGet:Picture := ::cPicture
      ::oGet:UpdateBuffer()
      ::oGet:KillFocus()
   endif

   ::oGet:SetFocus()   // to avoid oGet:buffer be nil

   if ! ::oGet:BadDate .and. ! ::lReadOnly .and. ;
      ( ::oGet:changed .or. ::oGet:unTransform() <> ::oGet:original )
      ::oGet:Assign()     // for adjust numbers
      ::oGet:UpdateBuffer()
   endif

   ::DispText()

   if ! ::oGet:BadDate
      ::oGet:KillFocus()
   else
      ::oGet:Pos = 1
      ::nPos = 1
      #ifndef __CLIPPER__
         #ifndef __C3__
            ::oGet:TypeOut = .f.
         #endif
      #endif
   endif

return nil

//----------------------------------------------------------------------------//

METHOD Paste( cText ) CLASS TGet

   local oClp
   local cTemp

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

      ::DispText() // from buffer to screen

      // EMW - the text has been changed!
      if ::bChange != nil
         Eval( ::bChange,,, Self )
      endif

   endif

return nil

//----------------------------------------------------------------------------//

METHOD DispText() CLASS TGet

   if ::lPassword .and. ::oGet:Type == "C"
      SetWindowText( ::hWnd, Replicate( "*", Len( Trim( ::oGet:buffer ) ) ) )
   else
      SetWindowText( ::hWnd, ::oGet:buffer )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD Move( nTop, nLeft, nBottom, nRight, lRepaint ) CLASS TGet

   Super:Move( nTop, nLeft, nBottom, nRight, lRepaint )
   MoveGet( ::hWnd, ::nRight - ::nLeft, ::nBottom - ::nTop )

return nil

//----------------------------------------------------------------------------//

METHOD GotFocus() CLASS TGet

   if ! Empty( ::cPicture ) .and. ::oGet:type == "N"
      ::oGet:Picture := StrTran( ::cPicture, ",", "" )
   endif

   if ! ::lDrag
      ::oGet:KillFocus()   // to properly initialize internal status
      ::oGet:SetFocus()
      ::DispText()
      if ::oGet:type $ "DN"
         ::nPos :=  1
         ::oGet:Pos = ::nPos
      else
         ::nPos = ::oGet:Pos
      endif
      ::SetPos( ::nPos )
      CallWindowProc( ::nOldProc, ::hWnd, WM_SETFOCUS )
      if Set( _SET_INSERT )
         DestroyCaret()
         CreateCaret( ::hWnd, 0, 6, ::nGetChrHeight() )
         ShowCaret( ::hWnd )
      endif
   else
      HideCaret( ::hWnd )
   endif

   /*
   Modificado por Manuel Calero__________________________________________________________
   */

   ::SetSel( 0, Len( Trim( ::GetText() ) ) )
   //::SelectAll()

   /*
   Fin de las modificaciones_____________________________________________________________
   */

   Super:GotFocus()

return 0

//----------------------------------------------------------------------------//

METHOD LButtonDown( nRow, nCol, nFlags ) CLASS TGet

   local nLo, nHi

   if ::lDrag
      return Super:LButtonDown( nRow, nCol, nFlags )
   else
      CallWindowProc( ::nOldProc, ::hWnd, WM_LBUTTONDOWN, nFlags,;
                      nMakeLong( nCol, nRow ) )
      ::GetSelPos( @nLo, @nHi )
      ::nPos = nHi + 1
      if ::nPos == 1
         ::oGet:Home()
         ::SetPos( ::oGet:Pos )
      else
         ::oGet:Pos = ::nPos
      endif

      /*
      Modificado por Manuel Calero_____________________________________________

      ::SelectAll()
      */

      /*
      Fin de las modificaciones________________________________________________
      */

      return 1
   endif

return nil

//----------------------------------------------------------------------------//

METHOD LButtonUp( nRow, nCol, nFlags ) CLASS TGet

   local nLo, nHi, cText

   if ::lDrag
      Super:LButtonUp( nRow, nCol, nFlags )
      SysRefresh()
      ::Refresh()
      return 0
   else
      cText = ::GetText()
      If Left( cText, 1 ) == "("
         ::nPos = 2
         ::SetPos( ::nPos )
      elseif Empty( cText ) .or. cText == "  /  /" .or. ;
         AllTrim( cText ) == "0" .or. ;
         AllTrim( cText ) == "   -  -"
         ::nPos = 1
         ::SetPos( ::nPos )
      else
         ::GetSelPos( @nLo, @nHi )
         ::oGet:pos = nHi + 1
         ::nPos = ::oGet:pos
      endif
   endif

return nil

//----------------------------------------------------------------------------//

METHOD KeyUp( nVKey, nFlags ) CLASS TGet

   local nLo

   if ( nVKey == VK_INSERT .and. GetKeyState( VK_SHIFT ) ) .or. ;
      ( nVKey == 86 .and. GetKeyState( VK_CONTROL ) )
      nLo = Len( ::oGet:buffer )
      ::oGet:buffer = Pad( GetWindowText( ::hWnd ), nLo )
      ::oGet:pos    = Min( nHiWord( ::SendMsg( EM_GETSEL ) ) + 1, nLo )
      ::EditUpdate()  // Many thanks to HMP
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

return Super:ReSize( nType, nWidth, nHeight )

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

   DEFAULT nEnd := nStart

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

   If !cType$"MDY" .and. nPos > 1
      cType := Upper( Substr( cFormat, nPos - 1, 1 ) )
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

   ::SetPos( nPos )

RETURN nil

//----------------------------------------------------------------------------//

STATIC FUNCTION Lastday( dDate )

   LOCAL nMonth := Month( dDate )

   DO WHILE Month( dDate ) == nMonth
      dDate++
   ENDDO

   dDate--

RETURN Day( dDate )