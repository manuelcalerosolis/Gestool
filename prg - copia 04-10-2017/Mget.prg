#include "FiveWin.Ch"
#include "Constant.ch"
#include "print.ch"
//#include "Set.ch"

#ifdef __CLIPPER__
   #define EM_GETSEL       (WM_USER+0)
   #define EM_SETSEL       (WM_USER+1)
   #define EM_UNDO         (WM_USER+23)
   #define EM_LINEFROMCHAR (WM_USER+25)
   #define EM_GETLINECOUNT (WM_USER+10)
   #define EM_LINEINDEX    (WM_USER+11)
   #define EM_CANUNDO      (WM_USER+22)
#else
   #define EM_GETSEL               176
   #define EM_SETSEL               177
   #define EM_UNDO                 199
   #define EM_LINEFROMCHAR         201
   #define EM_GETLINECOUNT         186
   #define EM_LINEINDEX            187
   #define EM_CANUNDO              198

   #ifdef __XPP__
      #define Super  ::TControl
      #define New    _New
      #define GetNew _GetNew
      #define GetDelSel _GetDelSel
   #endif
#endif

#define COLOR_WINDOW              5
#define COLOR_WINDOWTEXT          8

#define ES_CENTER                 1

#define WM_ERASEBKGND            20
#define WM_SETFONT               48
#define WM_CUT                  768   //  0x300
#define WM_PASTE                770   //  0x302
#define WM_CLEAR                771   //  0x303

#define CW_USEDEFAULT         32768

#define GWL_STYLE             ( -16)

#define EM_LIMITTEXT            197

//----------------------------------------------------------------------------//

CLASS TMultiGet FROM TControl

   DATA   lReadOnly
   DATA   nPos
   DATA   hHeap AS NUMERIC INIT 0

   METHOD New( nRow, nCol, bSetGet, oWnd, nWidth, nHeight, oFont,;
               lHScroll, nClrFore, nClrBack, oCursor, lPixel, cMsg,;
               lUpdate, bWhen, lCenter, lRight, lReadOnly, bValid,;
               bChanged, lDesign, lNoVScroll ) CONSTRUCTOR

   METHOD ReDefine( nId, bSetGet, oWnd, nHelpId, nClrFore, nClrBack, oFont,;
                    oCursor, cMsg, lUpdate, bWhen, lReadOnly, bValid,;
                    bChanged ) CONSTRUCTOR

   METHOD AdjClient() INLINE Super:AdjClient(), MoveGet( ::hWnd )

   #ifndef __HARBOUR__
      METHOD Append( cText, nLen ) INLINE ;
                     nLen := ::Len()  ,;
                     SendMessage( ::hWnd, EM_SETSEL, 0,;
                                  nMakeLong( nLen, nLen ) ),;
                     ::Replace( cText )
   #else
      METHOD Append( cText, nLen ) INLINE ;
                     nLen := ::Len()  ,;
                     SendMessage( ::hWnd, EM_SETSEL, nLen, nLen ),;
                     ::Replace( cText )
   #endif

   METHOD cToChar() INLINE  Super:cToChar( "EDIT" )

   METHOD Copy()

   METHOD Create( cClsName )

   METHOD Cut()

   METHOD Del()

   METHOD Default()

   METHOD DelLine( nLine )

   METHOD Destroy()

   #ifndef __C3__
      METHOD Display() INLINE ::BeginPaint(), ::Paint(), ::EndPaint(), 1
   #endif

   METHOD DlgGoLine()

   METHOD EraseBkGnd( hDC ) INLINE 1

   METHOD Find( cText ) INLINE  DlgFindText( cText, Self )

   METHOD GetLine( nLine ) INLINE MGetLine( ::hWnd, nLine )

   METHOD GetLineCount() INLINE SendMessage( ::hWnd, EM_GETLINECOUNT )

   METHOD GotFocus()

   METHOD GetRow()
   METHOD GetCol()

   METHOD GoBottom() INLINE ::SetPos( Len( AllTrim( ::GetText() ) ) )

   METHOD GoTo( nLine ) INLINE ;
                ::SetPos( SendMessage( ::hWnd, EM_LINEINDEX, nLine, 0 ) )

   METHOD HideSel() INLINE ::SetSel( -1, 0 )

   METHOD Initiate( hDlg )

   METHOD LButtonDown( nRow, nCol, nFlags )

   METHOD LButtonUp( nRow, nCol, nFlags )

   METHOD Len() INLINE GetWinTxtLenght( ::hWnd )

   // Call this method to use unlimited text size
   METHOD LimitText() INLINE SendMessage( ::hWnd, EM_LIMITTEXT, 0, 0 )

   METHOD LineIndex( nLine ) INLINE ::SendMsg( EM_LINEINDEX, nLine )

   METHOD LostFocus( hCtlFocus )

   METHOD MouseMove( nRow, nCol, nKeyFlags )

   METHOD Move( nTop, nLeft, nBottom, nRight, lRepaint )

   METHOD cText( cText ) SETGET

   METHOD Paint()

   METHOD Paste( cText )

   METHOD Print()

   METHOD RButtonDown( nRow, nCol, nFlags )

   METHOD Refresh() INLINE ;
                    SetWindowText( ::hWnd, cValToChar( Eval( ::bSetGet ) ) )

   // METHOD Save() INLINE Eval( ::bSetGet, GetWindowText( ::hWnd ) )

   METHOD Replace( cText ) INLINE ;
                           MGetReplace( ::hWnd, cText ),;
                           Eval( ::bSetGet, ::GetText() )

   METHOD SaveToFile( cFileName ) INLINE MemoWrit( cFileName, ::GetText() )

   METHOD SelectAll() INLINE ::SetSel( 0, -1 )

   METHOD SetCoors( oRect )

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

   METHOD VScroll( nWParam, nLParam ) VIRTUAL

   METHOD HScroll( nWParam, nLParam ) VIRTUAL

   METHOD GetSel()
   METHOD GetSelPos( @nStart, @nEnd )

   METHOD KeyChar( nKey, nFlags )

   METHOD KeyDown( nKey, nFlags )

   #ifdef __CLIPPER__
   METHOD SetPos( nStart, nEnd ) INLINE ;
                 nEnd := If( nEnd == nil, nStart, nEnd ),;
                 ::SendMsg( EM_SETSEL, 0, nMakeLong( nStart, nEnd ) ),;
                 ::nPos := nStart
   #else
   METHOD SetPos( nStart, nEnd ) INLINE ;
                 nEnd := If( nEnd == nil, nStart, nEnd ),;
                 ::SendMsg( EM_SETSEL, nStart - If( nStart > 0, 1, 0 ), nEnd - If( nEnd > 0, 1, 0 ) ),;
                 ::nPos := nStart
   #endif

   METHOD UnDo() INLINE ::SendMsg( EM_UNDO ),;
                        Eval( ::bSetGet, ::GetText() )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( nRow, nCol, bSetGet, oWnd, nWidth, nHeight, oFont, lHScroll,;
            nClrFore, nClrBack, oCursor, lPixel, cMsg, lUpdate,;
            bWhen, lCenter, lRight, lReadOnly, bValid, bChanged,;
            lDesign, lNoBorder, lNoVScroll ) CLASS TMultiGet

   DEFAULT lHScroll   := .f.,;
           nClrFore   := GetSysColor( COLOR_WINDOWTEXT ),;
           nClrBack   := GetSysColor( COLOR_WINDOW ),;
           lPixel     := .f., lUpdate := .f.,;
           lCenter    := .f., lRight := .f.,;
           lReadOnly  := .f., lDesign := .f.,;
           oWnd       := GetWndDefault(),;
           nRow       := 0, nCol := 0,;
           lNoVScroll := .f., lNoBorder := .f.

   if bSetGet != nil
      ::cCaption = cValToChar( Eval( bSetGet ) )
   else
      ::cCaption = ""
   endif

   ::nTop     = nRow * If( lPixel, 1, MGET_CHARPIX_H )  //13
   ::nLeft    = nCol * If( lPixel, 1, MGET_CHARPIX_W )	// 8
   ::nBottom  = If( nHeight == nil, ::nTop + 11, ::nTop + nHeight )
   ::nRight   = If( nWidth == nil, ::nLeft + Len( ::cCaption ) * 3.5, ;
                    ::nLeft + nWidth )
   ::bSetGet  = bSetGet
   ::oWnd     = oWnd
   ::nStyle   = nOR( WS_CHILD, WS_VISIBLE, ES_LEFT,;
                     ES_WANTRETURN, ES_MULTILINE,;
                     If( ! lReadOnly, WS_TABSTOP, 0 ),;
                     If( ! lNoBorder, WS_BORDER, 0 ),;
                     If( ! lNoVScroll, WS_VSCROLL, 0 ),;
                     If( lDesign, WS_CLIPSIBLINGS, 0 ),;
                     If( lHScroll, WS_HSCROLL, 0 ),;
                     If( lCenter, ES_CENTER, If( lRight, ES_RIGHT, ES_LEFT ) ) )

   ::nId       = ::GetNewId()
   ::cCaption  = RTrim( ::cCaption )
   ::lDrag     = lDesign
   ::lCaptured = .f.
   ::oCursor   = oCursor
   ::oFont     = oFont
   ::cMsg      = cMsg
   ::lUpdate   = lUpdate
   ::bWhen     = bWhen
   ::bValid    = bValid
   ::lReadOnly = lReadOnly
   ::nPos      = 0
   ::bChange   = bChanged

   ::SetColor( nClrFore, nClrBack )

   if ! Empty( oWnd:hWnd )
      ::Create( "EDIT" )
      if ::oFont != nil .or. ::oWnd:oFont != nil
         PostMessage( ::hWnd, WM_SETFONT,;
                      If( oFont != nil, oFont:hFont,;
                          ::oWnd:oFont:hFont ) )
      endif
      oWnd:AddControl( Self )
   else
      oWnd:DefControl( Self )
   endif

   ::GetFont()

   if lDesign
      ::CheckDots()
   endif

return Self

//----------------------------------------------------------------------------//

METHOD ReDefine( nId, bSetGet, oWnd, nHelpId, nClrFore, nClrBack, oFont,;
             oCursor, cMsg, lUpdate, bWhen, lReadOnly, bValid, bChanged ) CLASS TMultiGet

   DEFAULT nClrFore := GetSysColor( COLOR_WINDOWTEXT ),;
           nClrBack := GetSysColor( COLOR_WINDOW ),;
           lUpdate  := .f., lReadOnly := .f.

   ::nId       = nId
   ::bSetGet   = bSetGet
   ::oWnd      = oWnd
   ::nHelpId   = nHelpId
   ::lDrag     = .f.
   ::lCaptured = .f.
   ::oFont     = oFont
   ::oCursor   = oCursor
   ::cMsg      = cMsg
   ::lUpdate   = lUpdate
   ::bWhen     = bWhen
   ::bValid    = bValid
   ::lReadOnly = lReadOnly
   ::nPos      = 0
   ::bChange   = bChanged

   ::SetColor( nClrFore, nClrBack )

   oWnd:DefControl( Self )

return Self

//----------------------------------------------------------------------------//

METHOD Initiate( hDlg ) CLASS TMultiGet

   ::LimitText()
   Super:Initiate( hDlg )
   SetWindowText( ::hWnd, cValToChar( Eval( ::bSetGet ) ) )
   ::Default()

return nil

//----------------------------------------------------------------------------//

METHOD cText( cText ) CLASS TMultiGet

   if PCount() == 1
      SetWindowText( ::hWnd, cText )
      Eval( ::bSetGet, cText )
   endif

return GetWindowText( ::hWnd )

//----------------------------------------------------------------------------//

METHOD Copy() CLASS TMultiGet

   local oClp

   #ifdef __XPP__
      #undef New
   #endif

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

METHOD Create( cClsName ) CLASS TMultiGet

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

METHOD Cut() CLASS TMultiGet

   if ::lReadOnly
      msgStop( "The get is read only!", "Can't cut" )
      return nil
   endif

   ::SendMsg( WM_CUT )
   Eval( ::bSetGet, ::GetText() )

   // EMW - the text has been changed!
   if ::bChange != nil
       Eval( ::bChange,,, Self )
   endif

return nil

//*** EMW - Added method to delete selected text without affecting clipboard
//---------------------------------------------------------------------------//

METHOD Del() CLASS TMultiGet

   if ::lReadOnly
      msgStop( "The get is read only!", "Can't delete" )
      return nil
   endif

   ::SendMsg( WM_CLEAR )
   Eval( ::bSetGet, ::GetText() )

   if ::bChange != nil
       Eval( ::bChange,,, Self )
   endif

return nil
//*** EMW - End of addition

//----------------------------------------------------------------------------//

METHOD DelLine( nLine ) CLASS TMultiGet

   DEFAULT nLine := ::GetRow()

   ::SendMsg( EM_SETSEL, .f.,;
              nMakeLong( ::SendMsg( EM_LINEINDEX, nLine - 1 ),;
                         ::SendMsg( EM_LINEINDEX, nLine ) ) )
   ::Cut()
   Eval( ::bSetGet, GetWindowText( ::hWnd ) )

   // EMW - the text has been changed!
   if ::bChange != nil
       Eval( ::bChange,,, Self )
   endif

return nil

//---------------------------------------------------------------------------//

METHOD Destroy() CLASS TMultiGet

   if ::hHeap != 0
      // LocalShrink( ::hHeap, 0 )
      ::hHeap = 0
   endif

return Super:Destroy()

//---------------------------------------------------------------------------//

METHOD DlgGoLine() CLASS TMultiGet

   local oDlgGoLine, nLine := ::GetRow()

   DEFINE DIALOG oDlgGoLine FROM 5,5 TO 10,29 TITLE "Go To"

   @ 0.5, 2 SAY "Line:" OF oDlgGoLine
   @ 0.5, 5 GET nLine OF oDlgGoLine PICTURE "99999" SIZE 25, 11

   @ 1.3, 2 BUTTON "&Ok"  OF oDlgGoLine SIZE 32, 11 ;
      ACTION ( ::GoToLine( nLine ), oDlgGoLine:End() ) DEFAULT

   @ 1.3, 9.5 BUTTON "&Cancel" OF oDlgGoLine SIZE 32, 11 ;
      ACTION oDlgGoLine:End()

   ACTIVATE DIALOG oDlgGoLine CENTERED

return nil

//---------------------------------------------------------------------------//

METHOD GetSel() CLASS TMultiGet

   local n      := ::SendMsg( EM_GETSEL )
   local nStart := nLoWord( n )
   local nEnd   := nHiWord( n )

return If( nStart != nEnd, SubStr( ::cText, nStart + 1, nEnd - nStart + 1 ), "" )

//----------------------------------------------------------------------------//

METHOD GetSelPos( nStart, nEnd ) CLASS TMultiGet

   local n := ::SendMsg( EM_GETSEL )
   nStart  := nLoWord( n )
   nEnd    := nHiWord( n )

return nil

//----------------------------------------------------------------------------//

METHOD GetRow() CLASS TMultiGet

return ::SendMsg( EM_LINEFROMCHAR,;
                  nLoWord( ::SendMsg( EM_GETSEL ) ) ) + 1

//----------------------------------------------------------------------------//

METHOD GetCol() CLASS TMultiGet

return nLoWord( ::SendMsg( EM_GETSEL ) ) - ;
       ::SendMsg( EM_LINEINDEX, ::GetRow() -1 , 0 ) + 1

//----------------------------------------------------------------------------//

METHOD LButtonDown( nRow, nCol, nFlags ) CLASS TMultiGet

   ::nPos = nLoWord( ::PostMsg( EM_GETSEL ) )

return Super:LButtonDown( nRow, nCol, nFlags )

//----------------------------------------------------------------------------//

METHOD LButtonUp( nRow, nCol, nFlags ) CLASS TMultiGet

   if ::lDrag
      Super:LButtonUp( nRow, nCol, nFlags )
      SysRefresh()
      ::Refresh()
      return 0
   endif

return Super:LButtonUp( nRow, nCol, nFlags )

//----------------------------------------------------------------------------//

METHOD MouseMove( nRow, nCol, nKeyFlags ) CLASS TMultiGet

   if ::lDrag
      return Super:MouseMove( nRow, nCol, nKeyFlags )
   else
      ::oWnd:SetMsg( ::cMsg )
      if ::oCursor != nil
         SetCursor( ::oCursor:hCursor )
      else
         CursorIBeam()
      endif

      ::CheckToolTip()

      if ::bMMoved != nil
         Eval( ::bMMoved, nRow, nCol, nKeyFlags )
      endif
   endif

return nil      // We want standard MultiLine Get behavior !!!

//---------------------------------------------------------------------------//

METHOD KeyDown( nKey, nFlags ) CLASS TMultiGet

   do case
      case ( nKey == VK_INSERT .and. GetKeyState( VK_SHIFT ) ) .or. ;
           ( nKey == ASC("V") .and. GetKeyState( VK_CONTROL ) ) .or. ;
           ( nKey == ASC('X') .and. GetKeyState( VK_CONTROL ) )

          if !::lReadOnly
             CallWindowProc( ::nOldProc, ::hWnd, WM_KEYDOWN, nKey, nFlags )
             if ::bChange != nil
                Eval( ::bChange, nKey, nFlags, Self )
             endif
          endif

          return 0

      case nKey == VK_DELETE
           if ::lReadOnly
              return 0
           endif
           if ::bChange != nil
              Eval( ::bChange, nKey, nFlags, Self )
           endif
   endcase

return Super:KeyDown( nKey, nFlags )

//---------------------------------------------------------------------------//

METHOD KeyChar( nKey, nFlags ) CLASS TMultiGet

   local bKeyAction := SetKey( nKey )

   if bKeyAction != nil .and. lAnd( nFlags, 16777216 ) // function Key
      Eval( bKeyAction, ProcName( 4 ), ProcLine( 4 ), Self )
      return 0         // Already processed, API do nothing
   endif

   if ::lReadOnly
      if nKey == VK_RETURN
         ::oWnd:GoNextCtrl( ::hWnd )
      endif
      return 0
   endif

   if nKey == VK_RETURN .and. ;
      lAnd( GetWindowLong( ::hWnd, GWL_STYLE ), ES_WANTRETURN )
      ::oWnd:nLastKey = 0
      return nil
   endif

   if nKey == VK_ESCAPE  // Windows API already sends it to dialogs!!!
      if ::oWnd:ChildLevel( TDialog() ) != 0 .and. ::oWnd:lModal
         return nil
      endif
      if ::oWnd:ChildLevel( TDialog() ) != 0 .and. ::oWnd:oWnd != nil .and. ;
         ::oWnd:oWnd:ChildLevel( TPages() ) != 0
         ::oWnd:oWnd:oWnd:End()
      endif
      if ::oWnd:oWnd:ClassName() == "TFOLDER" .and. ::oWnd:oWnd != nil
         ::oWnd:oWnd:oWnd:End()
      endif

   endif

   if nKey == VK_TAB
      return Super:KeyChar( nKey, nFlags )
   endif

   if !::lReadOnly
      CallWindowProc( ::nOldProc, ::hWnd, WM_CHAR, nKey, nFlags )
      Eval( ::bSetGet, ::GetText() )
      if ::bChange != nil
         Eval( ::bChange, nKey, nFlags, Self )
      endif
      return 0
   endif

return Super:KeyChar( nKey, nFlags )

//---------------------------------------------------------------------------//

METHOD Paint() CLASS TMultiGet

   local aInfo := ::DispBegin()

   if ::oBrush != nil
      FillRect( ::hDC, GetClientRect( ::hWnd ), ::oBrush:hBrush )
   else
      CallWindowProc( ::nOldProc, ::hWnd, WM_ERASEBKGND, ::hDC, 0 )
   endif

   CallWindowProc( ::nOldProc, ::hWnd, WM_PAINT, ::hDC, 0 )

   if ValType( ::bPainted ) == "B"
      Eval( ::bPainted, ::hDC, ::cPS, Self )
   endif

   ::DispEnd( aInfo )

return 1

//----------------------------------------------------------------------------//


METHOD Paste( cText ) CLASS TMultiGet

   local oClp

   #ifdef __XPP__
      #undef New
   #endif

   DEFINE CLIPBOARD oClp OF Self FORMAT TEXT

   if ! Empty( cText )
      oClp:SetText( cText )
   endif

   ::SendMsg( WM_PASTE )
   Eval( ::bSetGet, ::GetText() )

   if ::bChange != nil
       Eval( ::bChange,,, Self )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD RButtonDown( nRow, nCol, nFlags ) CLASS TMultiGet

   local oMenu, oClp

   if GetFocus() != ::hWnd
      ::SetFocus()
      SysRefresh()            // In case there is a VALID somewhere
      if GetFocus() != ::hWnd
         return nil
      endif
   endif

   #ifdef __XPP__
      #undef New
   #endif

   if ::bRClicked != nil
      return Eval( ::bRClicked, nRow, nCol, nFlags )
   endif

   DEFINE CLIPBOARD oClp OF Self FORMAT TEXT

   MENU oMenu POPUP
      if ::SendMsg( EM_CANUNDO ) != 0
         #ifndef __XPP__
            MENUITEM "&Undo" ACTION ::UnDo()
         #else
            MENUITEM "&Undo" ACTION ::TMultiGet:UnDo()
         #endif
      else
         #ifndef __XPP__
            MENUITEM "&Undo" ACTION ::UnDo() DISABLED
         #else
            MENUITEM "&Undo" ACTION ::TMultiGet:UnDo() DISABLED
         #endif
      endif

      SEPARATOR

      if ! Empty( ::GetSel() ) .and. !::lReadOnly
         #ifndef __XPP__
            MENUITEM "Cu&t"  ACTION ::Cut()
         #else
            MENUITEM "Cu&t"  ACTION ::TMultiGet:Cut()
         #endif
      else
         #ifndef __XPP__
            MENUITEM "Cu&t"  ACTION ::Cut() DISABLED
         #else
            MENUITEM "Cu&t"  ACTION ::TMultiGet:Cut() DISABLED
         #endif
      endif

      if ! Empty( ::GetSel() )
         #ifndef __XPP__
            MENUITEM "&Copy" ACTION ::Copy()
         #else
            MENUITEM "&Copy" ACTION ::TMultiGet:Copy()
         #endif
      else
         #ifndef __XPP__
            MENUITEM "&Copy" ACTION ::Copy() DISABLED
         #else
            MENUITEM "&Copy" ACTION ::TMultiGet:Copy() DISABLED
         #endif
      endif

      if ! Empty( oClp:GetText() ) .and. !::lReadOnly
         #ifndef __XPP__
            MENUITEM "&Paste" ACTION ::Paste()
         #else
            MENUITEM "&Paste" ACTION ::TMultiGet:Paste()
         #endif
      else
         #ifndef __XPP__
            MENUITEM "&Paste" ACTION ::Paste() DISABLED
         #else
            MENUITEM "&Paste" ACTION ::TMultiGet:Paste() DISABLED
         #endif
      endif

      if ! Empty( ::GetSel() ) .and. !::lReadOnly
         #ifndef __XPP__
            MENUITEM "&Delete" ACTION ::Del()
         #else
            MENUITEM "&Delete" ACTION ::TMultiGet:Del()
         #endif
      else
         #ifndef __XPP__
            MENUITEM "&Delete" ACTION ::Del() DISABLED
         #else
            MENUITEM "&Delete" ACTION ::TMultiGet:Del() DISABLED
         #endif
      endif

      if Upper( ::ClassName() ) == "TRICHEDIT"
         SEPARATOR
         MENUITEM "&Font" ACTION ::SetCharFormat()
      endif

      SEPARATOR
      #ifndef __XPP__
         MENUITEM "P&rint" ACTION ::Print()
      #else
         MENUITEM "P&rint" ACTION ::TMultiGet:Print()
      #endif
      SEPARATOR

      #ifndef __XPP__
         MENUITEM "Select &All" ACTION ::SelectAll()
      #else
         MENUITEM "Select &All" ACTION ::TMultiGet:SelectAll()
      #endif
   ENDMENU

   ACTIVATE POPUP oMenu AT nRow - 60, nCol OF Self

return 0             // Message already processed

//----------------------------------------------------------------------------//

METHOD GotFocus() CLASS TMultiGet

   Super:GotFocus()

   // ::SetPos( ::nPos )
   CallWindowProc( ::nOldProc, ::hWnd, WM_SETFOCUS )

   if Set( _SET_INSERT )
      DestroyCaret()
      CreateCaret( ::hWnd, 0, 6, ::nGetChrHeight() )
      ShowCaret( ::hWnd )
   endif

return 0

//----------------------------------------------------------------------------//

METHOD LostFocus( hCtlFocus ) CLASS TMultiGet

   Super:LostFocus( hCtlFocus )

   if ::bSetGet != nil
      Eval( ::bSetGet, GetWindowText( ::hWnd ) )
   endif

   ::nPos = nLoWord( ::SendMsg( EM_GETSEL ) )

return nil

//----------------------------------------------------------------------------//

METHOD Default() CLASS TMultiGet

   if ::oFont != nil
      ::SetFont( ::oFont )
   else
      ::SetFont( ::oWnd:oFont )
   endif

return nil

//---------------------------------------------------------------------------//

METHOD Move( nTop, nLeft, nBottom, nRight, lRepaint ) CLASS TMultiGet

   Super:Move( nTop, nLeft, nBottom, nRight, lRepaint )
   MoveGet( ::hWnd )

return nil

//----------------------------------------------------------------------------//

METHOD SetCoors( oRect ) CLASS TMultiGet

   Super:SetCoors( oRect )
   MoveGet( ::hWnd )

return nil

//----------------------------------------------------------------------------//

METHOD Print() CLASS TMultiGet

   local oPrn, oFont
   local nRowStep
   local nRow := 0, nCol := 0, n, n1 := 0
   local nLines := ::GetLineCount()

   PRINT oPrn  NAME "Notes"

      if Empty( oPrn:hDC )
         MsgStop( "Printer not ready!" )
         return self
      endif

      CursorWait()

      DEFINE FONT oFont NAME GetSysFont() SIZE 0, -11 OF oPrn

      nRowStep = oPrn:nVertRes() / 60   // We want 60 rows

      PAGE
         for n = 1 to nLines  // rows
             oPrn:Say( nRow, nCol, ::GetLine( n ), oFont )
             nRow += nRowStep
             n1 ++
             IF n1 == 60
                nRow := 0
                n1 := 0
                ENDPAGE
                PAGE
             ENDIF
         next
      ENDPAGE
   ENDPRINT

   oFont:End()      // Destroy the font object
   CursorArrow()

return nil

//----------------------------------------------------------------------------//