#include "FiveWin.Ch"
#include "Objects.ch"
#include "Menu.ch"
#include "Constant.ch"

#define EM_SETMARGINS            211
#define EC_LEFTMARGIN            1
#define EC_RIGHTMARGIN           2
#define EM_LIMITTEXT             197
#define EM_SETLIMITTEXT          EM_LIMITTEXT   // win40 Name change

//----------------------------------------------------------------------------//

CLASS TGetHlp FROM TGet

   DATA bHelp
   DATA bMult
   DATA cBmp
   DATA oBmp
   DATA oSay
   DATA oHelpText
   DATA cHelpText                   INIT  Space( 50 )

   DATA Original

   DATA bKeyUp

   DATA lGotFocus
   DATA lNeedGetFocus

   DATA bOldWhen
   DATA bOldValid
   DATA bOldLostFocus

   DATA bPreValidate
   DATA bPostValidate

   DATA nMargin                     INIT 16

   DATA cError                      INIT ""

   METHOD New()                     CONSTRUCTOR
   METHOD ReDefine()                CONSTRUCTOR

   METHOD Display()

   METHOD Destroy()

   METHOD EvalHelp()

   METHOD KeyChar( nKey, nFlags )
   METHOD KeyUp( nKey, nFlags )     INLINE ( if( !empty( ::bKeyUp ), eval( ::bKeyUp ), ), ::Super:KeyUp( nKey, nFlags ) )

   METHOD SetPicture( cPicture )    INLINE ( ::cPicture  := cPicture, ::oGet:Picture := cPicture, ::Refresh()  )   // MCS

   METHOD Home()                    INLINE ( ::oGet:Home(), ::SetPos( ::oGet:Pos ) )

   METHOD EvalMult()                INLINE ( if( ::bMult != nil, eval( ::bMult, Self ), ) )

   METHOD Hide()                    

   METHOD Show()

   METHOD SetText( cText )          INLINE ( if( ::oSay != nil, ::oSay:SetText( cText ), ::cText( cText ) ) )

   METHOD evalPreValidate()         INLINE ( if( ::bPreValidate != nil, eval( ::bPreValidate, Self ), ) )
   METHOD evalPostValidate()        INLINE ( if( ::bPostValidate != nil, eval( ::bPostValidate, Self ), ) )

   METHOD HardEnable()
   
   METHOD HardDisable()

   METHOD GotFocus()

   METHOD GetDlgCode( nLastKey )

   METHOD LostFocus( hCtlFocus )

   METHOD lValid()

   METHOD setError( cError )

   METHOD getOriginal()                INLINE ( ::Original )
   METHOD setOriginal( value )         INLINE ( ::Original := value )
   METHOD isOriginalChanged( value )   INLINE ( ::Original != value )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( nRow, nCol, bSetGet, oWnd, nWidth, nHeight, cPict, bValid,;
            nClrFore, nClrBack, oFont, lDesign, oCursor, lPixel, cMsg,;
            lUpdate, bWhen, lCenter, lRight, bChanged, lReadOnly,;
            lPassword, lNoBorder, nHelpId, lSpinner, bUp, bDown, bMin,;
            bMax, bHelp, bMult, cBmp ) CLASS TGetHlp

   DEFAULT cBmp      := ""

   ::Super:New(  nRow, nCol, bSetGet, oWnd, nWidth, nHeight, cPict, bValid,;
               nClrFore, nClrBack, oFont, lDesign, oCursor, lPixel, cMsg,;
               lUpdate, bWhen, lCenter, lRight, bChanged, lReadOnly,;
               lPassword, lNoBorder, nHelpId, lSpinner, bUp, bDown, bMin,;
               bMax )

   ::bHelp           := bHelp
   ::bMult           := bMult
   ::cBmp            := cBmp

   ::lNeedGetFocus   := .f.
   ::lGotFocus       := .f.

RETURN Self

//----------------------------------------------------------------------------//

METHOD ReDefine( nId, bSetGet, oWnd, nHelpId, cPict, bValid, nClrFore,;
                 nClrBack, oFont, oCursor, cMsg, lUpdate, bWhen, bChanged,;
                 lReadOnly, lSpinner, bUp, bDown, bMin, bMax, bHelp, bMult,;
                 cBmp, nIdSay, nIdText ) CLASS TGetHlp

   local oError
   local oBlock

   oBlock            := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   DEFAULT cBmp      := ""

   ::Super:ReDefine( nId, bSetGet, oWnd, nHelpId, cPict, bValid, nClrFore,;
                     nClrBack, oFont, oCursor, cMsg, lUpdate, bWhen, bChanged,;
                     lReadOnly, lSpinner, bUp, bDown, bMin, bMax )

   ::bHelp           := bHelp
   ::bMult           := bMult
   ::cBmp            := cBmp

   ::lNeedGetFocus   := .f.
   ::lGotFocus       := .f.

   ::lVisible        := .t.

   if !empty( nIdSay )
      ::oSay         := TSay():ReDefine( nIdSay, nil, oWnd )
   end if

   if !empty( nIdText )
      ::oHelpText    := TGet():ReDefine( nIdText, { | u | If( PCount() == 0, ::cHelpText, ::cHelpText := u ) }, oWnd, , , , , , oFont, , , .f., {||.f.} )
   end if

   RECOVER USING oError

      msgStop( "Imposible crear el control TGetHlp." + CRLF + ErrorMessage( oError ) )

   END SEQUENCE
   ErrorBlock( oBlock )

RETURN Self

//----------------------------------------------------------------------------//

METHOD Display() CLASS TGetHlp

   if !Empty( ::cBmp ) .and. Empty( ::oBmp )

      ::oBmp               := TBitmap():New( 0, Self:nWidth - ( ::nMargin + 4 ),,, ::cBmp, ,.t., Self, {|| ::EvalHelp()},,,,,,,,.t. )
      ::oBmp:lTransparent  := .t.

      SendMessage( ::hWnd, EM_SETMARGINS, nOr( EC_LEFTMARGIN, EC_RIGHTMARGIN ), nMakeLong( 0, ::nMargin ) )

   end if

RETURN ::Super:display()

//----------------------------------------------------------------------------//

METHOD Destroy() CLASS TGetHlp

   if ::oBmp != nil
      ::oBmp:End()
   end if

   if ::oSay != nil
      ::oSay:End()
   end if

   if ::oHelpText != nil
      ::oHelpText:End()
   end if

RETURN ( ::Super:Destroy() )

//---------------------------------------------------------------------------//

METHOD Hide()

   if ::oSay != nil
      ::oSay:Hide()
   end if 

   if ::oHelpText != nil
      ::oHelpText:Hide()
   end if 

RETURN ( ::Super:Hide() )

//---------------------------------------------------------------------------//

METHOD Show()
   
   if ::oSay != nil
      ::oSay:Show()
   end if 
   
   if ::oHelpText != nil
      ::oHelpText:Show()
   end if 
   
RETURN ( ::Super:Show() )

//---------------------------------------------------------------------------//

METHOD KeyChar( nKey, nFlags ) CLASS TGetHlp

   local nHi, nLo
   local lAccept
   local bKeyAction := SetKey( nKey )

   if nKey == VK_ESCAPE  // avoids a beep!
      ::oWnd:KeyChar( nKey, nFlags )
      RETURN 1
   endif

   if ! Empty( ::cPicture ) .and. '@!' $ ::cPicture
      nKey = Asc( Upper( Chr( nKey ) ) )
   endif

   if bKeyAction != nil .and. lAnd( nFlags, 16777216 ) // function Key
      Eval( bKeyAction, ProcName( 4 ), ProcLine( 4 ), Self )
      RETURN 0         // Already processed, API do nothing
   endif

   if ::lReadOnly
      if nKey == VK_ESCAPE
         ::oWnd:End()
      endif
      RETURN 0
   endif

   do case
      case nKey == VK_EXECUTE .AND. ::bHelp != nil
         ::EvalHelp()

      case nKey == VK_PRINT .AND. ::bMult != nil
         ::EvalMult()

      case nKey == VK_BACK       // Already processed at KeyDown
           RETURN 0

      case nKey == VK_TAB .and. GetKeyState( VK_SHIFT )
           if ::bChange != nil
              lAccept = Eval( ::bChange, nKey, nFlags, Self )
              if hb_islogical( lAccept ) .and. lAccept
                 if Upper( ::oWnd:ClassName() ) == "TCOMBOBOX"
                    ::oWnd:oWnd:GoPrevCtrl( ::hWnd )
                 else
                    ::oWnd:GoPrevCtrl( ::hWnd )
                 endif
              endif
           else
              if Upper( ::oWnd:ClassName() ) == "TCOMBOBOX"
                 ::oWnd:oWnd:GoPrevCtrl( ::hWnd )
              else
                 ::oWnd:GoPrevCtrl( ::hWnd )
              endif
           endif
           RETURN 0

      case nKey == VK_TAB .or. nKey == VK_RETURN
           if ::bChange != nil .and. ( ::oGet:Changed .or. ( ::oGet:buffer != nil .and. ::oGet:UnTransform() != ::oGet:Original ) )
              lAccept = Eval( ::bChange, nKey, nFlags, Self )
              if hb_islogical( lAccept ) .and. lAccept
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

           RETURN 0

      case nKey >= 32 .and. nKey < 256

           #ifdef __HARBOUR__
           // <lk> deadkey+tab [or enter] previously pressed will cause a r/t error
              if ::oGet:buffer == nil
                 RETURN 0
              endif
           #endif

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

           ::oGet:Assign()     // MCS

           if ::bChange != nil
              lAccept = Eval( ::bChange, nKey, nFlags, Self )
              if hb_islogical( lAccept ) .and. ! lAccept
                 RETURN 0
              endif
           endif

           Eval( ::bPostKey, Self, ::oGet:Buffer )

      otherwise
           RETURN ::Super:KeyChar( nKey, nFlags )

   endcase

RETURN ( 0 )

//---------------------------------------------------------------------------//

METHOD EvalHelp()

   if hb_isblock( ::bLostFocus )
      ::bOldLostFocus   := ::bLostFocus
      ::bLostFocus      := nil
   endif

   if hb_isblock( ::bValid )
      ::bOldValid       := ::bValid
      ::bValid          := nil
   endif

   if hb_isblock( ::bHelp )
      Eval( ::bHelp, Self )
   end if

   if hb_isblock( ::bOldLostFocus )
      ::bLostFocus      := ::bOldLostFocus
      ::bOldLostFocus   := nil
   endif

   if hb_isblock( ::bOldValid )
      ::bValid          := ::bOldValid
      ::bOldValid       := nil
   endif

   if hb_isblock( ::bLostFocus )
      Eval( ::bLostFocus )
   endif

   if hb_isblock( ::bValid )
      Eval( ::bValid )
   endif

RETURN Self

//---------------------------------------------------------------------------//

METHOD HardEnable() CLASS TGetHlp

   ::bWhen     := ::bOldWhen

RETURN ( ::Enable() )

//---------------------------------------------------------------------------//

METHOD HardDisable() CLASS TGetHlp

   ::bOldWhen  := ::bWhen
   ::bWhen     := {|| .f. }

RETURN ( ::Disable() )

//---------------------------------------------------------------------------//

METHOD GotFocus() CLASS TGetHlp

    ::lFocused = .t.

    if ! Empty( ::cPicture ) .and. ::oGet:type == "N"
       ::oGet:Picture := StrTran( ::cPicture, ",", "" )
    endif

    if ! ::lDrag
       ::oGet:KillFocus()   // to properly initialize internal status
       ::oGet:SetFocus()
       if Upper( ::oWnd:ClassName() ) == "TCOMBOBOX"
          ::oGet:Buffer := ::oGet:Original
       endif
       ::DispText()
       if ::oGet:type $ "DN"
          ::nPos := 1
       endif
       ::oGet:Pos := ::nPos
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

   if ::oGet:type == "C"
      ::SetSel( 0, Len( Rtrim( ::oGet:VarGet() ) ) )
   else
      ::SelectAll()
   end if

RETURN 0

//----------------------------------------------------------------------------//

METHOD GetDlgCode( nLastKey ) CLASS TGetHlp

   if Len( ::oWnd:aControls ) == 1
      RETURN DLGC_WANTALLKEYS
   endif

   ::oWnd:nLastKey = nLastKey

RETURN DLGC_WANTALLKEYS

//----------------------------------------------------------------------------//

METHOD LostFocus( hCtlFocus ) CLASS TGetHlp

   ::Super:LostFocus( hCtlFocus )

   if !::lPassword
      if ::oGet:buffer != GetWindowText( ::hWnd )  // right click popup action
         ::oGet:buffer  := GetWindowText( ::hWnd )
         ::oGet:Assign()
      endif
   endif

   if !Empty( ::cPicture ) .and. ::oGet:type == "N"
      ::oGet:Assign()
      ::oGet:Picture    := ::cPicture
      ::oGet:UpdateBuffer()
      ::oGet:KillFocus()
   endif

   ::oGet:SetFocus()       // to avoid oGet:buffer be nil

   if !::oGet:BadDate .and. !::lReadOnly .and. ( ::oGet:changed .or. ::oGet:unTransform() != ::oGet:original )
      ::oGet:Assign()      // for adjust numbers
   endif

   ::DispText()

   if !::oGet:BadDate
      ::oGet:KillFocus()
   else
      ::oGet:Pos        := 1
      ::nPos            := 1
   endif

   if ::lNeedGetFocus
      ::lGotFocus       := .t.
   end if

RETURN nil

//----------------------------------------------------------------------------//

METHOD lValid() CLASS TGetHlp

   local lRet   := .t.

   ::evalPreValidate()

   if ::oGet:BadDate
      ::oGet:KillFocus()
      ::oGet:SetFocus()
      msgBeep()
      RETURN .f.
   end if  

   ::oGet:Assign()
   
   if ( isBlock( ::bValid ) )

      lRet     := eval( ::bValid, Self )
      if isLogic( lRet ) .and. !( lRet )
         ::oWnd:nLastKey   := 0
      else 
         lRet  := .t.
      end if

   end if 

   ::evalPostValidate()

RETURN lRet

//---------------------------------------------------------------------------//

METHOD setError( cError )

   ::cError    := cError
   
   if !empty( ::cError )
      ::setColor( Rgb( 255, 255, 255 ), Rgb( 255, 102, 102 ) )
   else 
      ::setColor( Rgb( 0, 0, 0 ), Rgb( 255, 255, 255 ) )
   end if 

RETURN ( Self )

//---------------------------------------------------------------------------//
