#include "FiveWin.Ch"
#include "Factu.ch" 

CLASS GetSelector

   DATA oController

   DATA oDialog

   DATA bValue

   DATA cPicture                       INIT "@!"                                  

   DATA oLink
   
   DATA oGet
   DATA cGet

   DATA oHelp
   DATA cHelp

   DATA cOriginal

   DATA cKey                           INIT  "codigo"

   DATA uFields

   DATA oEvents

   DATA bWhen
   DATA bValid

   METHOD New( oController ) CONSTRUCTOR
   METHOD End()                                 

   METHOD setKey( cKey )               INLINE ( ::cKey := cKey )
   METHOD getKey()                     INLINE ( ::cKey )

   METHOD setPrompt( cPrompt )         INLINE ( ::cPrompt := cPrompt )
   METHOD getPrompt()                  INLINE ( if( empty( ::cPrompt ), ::getKey(), ::cPrompt ) )

   METHOD getLinkText()                VIRTUAL
   METHOD setLinkText( cText )         INLINE ( if( !empty( ::oLink ), ::oLink:setText( cText ), ) )
   
   METHOD cText( value )               INLINE ( if( !empty( ::oGet ), ::oGet:cText( value ), ) )
   
   METHOD Disable()                    INLINE ( if( !empty( ::oGet ), ::oGet:Disable(), ) )
   METHOD Enable()                     INLINE ( if( !empty( ::oGet ), ::oGet:Enable(), ) )

   METHOD getView()                    INLINE ( ::oController:oController:getDialogView() )

   METHOD Build( hBuilder )

   METHOD Activate( idGet, idText, oDlg )

   METHOD addGetSelector( cLink, oTaskPanel ) 

   METHOD Bind( bValue )               INLINE ( ::bValue := bValue )
   
   METHOD setValid( bValid )           INLINE ( ::bValid := bValid )
   METHOD setWhen( bWhen )             INLINE ( ::bWhen := bWhen, if( !empty( ::oGet ), ::oGet:bWhen := ::bWhen, ) )

   METHOD helpAction()
   METHOD validAction()

   METHOD assignResults( hResult )

   METHOD loadHelpText()
      METHOD cleanHelpText()                    
      METHOD setHelpText( value )               

   METHOD getFields()                  INLINE ( ::uFields := ::oController:getModel():getField( "nombre", ::getKey(), ::oGet:varGet() ) )
   
   METHOD start()                      INLINE ( ::loadHelpText( .t. ) )

   METHOD showMessage()

   METHOD varGet()                     INLINE ( if( !empty( ::oGet ), ::oGet:varGet(), ) )
  
   METHOD Hide()
   METHOD Show()
  
   METHOD setFocus()                   INLINE ( if( !empty( ::oGet ), ::oGet:setFocus(), ) )
  
   METHOD Refresh()                    INLINE ( if( !empty( ::oGet ), ::oGet:Refresh(), ) )
  
   METHOD lValid()                     INLINE ( if( !empty( ::oGet ), ::oGet:lValid(), ) )
   METHOD evalWhen()                   INLINE ( if( !empty( ::oGet ) .and. !empty( ::bWhen ), ( if( eval( ::bWhen ), ::oGet:Enable(), ::oGet:Disable() ) ), ) )

   METHOD getHelp()                    INLINE ( if( empty( ::oHelp ), ::oGet:oHelpText, ::oHelp ) )

   // Events-------------------------------------------------------------------

   METHOD setEvent( cEvent, bEvent )   INLINE ( if( !empty( ::oEvents ), ::oEvents:set( cEvent, bEvent ), ) )
   METHOD fireEvent( cEvent, uValue )  INLINE ( if( !empty( ::oEvents ), ::oEvents:fire( cEvent, uValue ), ) )

   METHOD isChangeGet()                INLINE ( ::varGet() != ::getOriginal() )
   METHOD isNotChangeGet()             INLINE ( ::varGet() == ::getOriginal() )

   METHOD setOriginal( cOriginal )     INLINE ( ::cOriginal := cOriginal )
   METHOD getOriginal()                INLINE ( ::cOriginal )

   METHOD setBlank()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS GetSelector

   ::oController  := oController

   ::oEvents      := Events():New()

   if !empty( ::oController:getController() )
      ::bWhen     := {|| ::oController:getController():isNotZoomMode() } 
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS GetSelector

   if !empty( ::oEvents )
      ::oEvents:End()
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD Build( hBuilder ) CLASS GetSelector

   local idGet    := if( hhaskey( hBuilder, "idGet" ),   hBuilder[ "idGet" ],    nil )
   local idText   := if( hhaskey( hBuilder, "idText" ),  hBuilder[ "idText" ],   nil )
   local idSay    := if( hhaskey( hBuilder, "idSay" ),   hBuilder[ "idSay"],     nil )
   local idLink   := if( hhaskey( hBuilder, "idLink" ),  hBuilder[ "idLink"],    nil )
   local oDlg     := if( hhaskey( hBuilder, "oDialog" ), hBuilder[ "oDialog" ],  nil )

RETURN ( ::Activate( idGet, idText, oDlg, idSay, idLink ) )

//---------------------------------------------------------------------------//

METHOD Activate( idGet, idText, oDlg, idSay, idLink ) CLASS GetSelector

   if isFalse( ::fireEvent( 'activating' ) )
      RETURN ( nil )
   end if

   ::setOriginal( eval( ::bValue ) )

   ::oGet               := TGetHlp():ReDefine( idGet, ::bValue, oDlg, , ::cPicture, {|| ::validAction() }, , , , , , .t., ::bWhen, , .f., .f., , , , , {|| ::helpAction() }, , "Lupa", idSay, idText )

   if !empty( idLink )   

   ::oLink              := TSay():ReDefine( idLink, ::getLinkText(), oDlg, , rgb( 10, 152, 234 ), , .f., oFontBold(), .f., .f. )

   ::oLink:lWantClick   := .t.
   ::oLink:OnClick      := {|| ::oController:Edit( ::oController:getModel():getIdWhereCodigo( eval( ::bValue ) ) ) }

   end if 

   ::fireEvent( 'activated' ) 

RETURN ( ::oGet )

//---------------------------------------------------------------------------//

METHOD addGetSelector( cLink, oTaskPanel ) CLASS GetSelector

   local nTop           := oTaskPanel:getTopControl()

   if isFalse( ::fireEvent( 'activating' ) )
      RETURN ( nil )
   end if

   ::setOriginal( eval( ::bValue ) )

   ::oLink              := TSay():New( nTop + 3, 10, {|| cLink }, oTaskPanel, , , .f., .f., .f., .t., Rgb( 10, 152, 234 ), Rgb( 255, 255, 255 ), , , .f., .f., .f., .f., .f., .f., .f., "oLink", , .f. )

   ::oLink:lWantClick   := .t.
   ::oLink:OnClick      := {|| ::oController:Edit( ::oController:getModel():getIdWhereCodigo( ::cGet ) ) }

   ::oGet               := TGet():New( nTop, 120, ::bValue, oTaskPanel, 100, 22, , {|| ::validAction() }, , , , .f., , .t., , .f., ::bWhen, .f., .f., , .f., .f., , , , , , , , {|| ::helpAction() }, "Lupa", "oGet" )

   ::oHelp              := TGetHlp():New( nTop, 222, bSETGET( ::cHelp ), oTaskPanel, 360, 22, , , , , , .f., , .t., , .f., {|| .f. }, .f., .f., , .f., .f., , , .f. )

   ::loadHelpText( .t. )

   oTaskPanel:setHeight( ::oGet:nTop, ::oGet:nHeight )

   ::fireEvent( 'activated' ) 

RETURN ( ::oGet )

//---------------------------------------------------------------------------//

METHOD helpAction() CLASS GetSelector

   local hResult
  
   if isFalse( ::fireEvent( 'helping' ) )
      RETURN ( .f. )
   end if

   hResult        := ::oController:ActivateSelectorView()

   if hb_isnil( hResult )
      RETURN ( .f. )
   end if 

   ::assignResults( hResult )

   ::fireEvent( 'helped' ) 

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD assignResults( hResult ) CLASS GetSelector

   if hhaskey( hResult, ::getKey() )
      ::cText( hGet( hResult, ::getKey() ) )
   end if

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD validAction() CLASS GetSelector

   if isFalse( ::fireEvent( 'validating' ) )
      RETURN ( .f. )
   end if

   if !empty( ::bValid ) .and. !eval( ::bValid, ::oGet ) 
      RETURN ( .f. )
   end if 

   ::oGet:oWnd:nLastKey    := 0

   if !( ::isChangeGet() )
      RETURN ( .t. )
   end if 

   if ::loadHelpText()
      
      ::setOriginal( ::varGet() )
      
      ::fireEvent( 'validated' )
      
      RETURN ( .t. )
   
   end if  

RETURN ( .f. )

//---------------------------------------------------------------------------//

METHOD loadHelpText( lSilenceMode ) CLASS GetSelector

   local value             := ""

   DEFAULT lSilenceMode    := .f.

   if empty( ::oGet )
      RETURN ( .t. )
   end if

   if isFalse( ::fireEvent( 'loading' ) )
      RETURN ( .f. )
   end if

   ::cleanHelpText()

   if empty( ::oGet:varGet() )

      ::fireEvent( 'loadingEmpty' )

      RETURN ( .t. )

   end if

   ::getFields()

   if empty( ::uFields )

      ::fireEvent( 'loadedError' )

      ::showMessage( lSilenceMode )

      RETURN ( .f. )

   end if

   ::setHelpText( ::uFields )

   ::oGet:Refresh()

   ::fireEvent( 'loaded' ) 

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD showMessage( lSilenceMode ) CLASS GetSelector

   if lSilenceMode 
      RETURN ( nil )
   end if 

   if empty( ::getView() )
      msgStop( ::oController:cTitle + " no encontrado" )
   else
      ::getView():showMessage( ::oController:cTitle + " no encontrado" )
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD cleanHelpText() CLASS GetSelector

   if isFalse( ::fireEvent( 'cleaningHelpText' ) )
      RETURN ( .f. )
   end if

   ::getHelp():cText( "" ) 

   ::fireEvent( 'cleanedHelpText' ) 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD setHelpText( value ) CLASS GetSelector            

   if isFalse( ::fireEvent( 'settingHelpText' ) )
      RETURN ( .f. )
   end if

   ::getHelp():cText( value ) 

   ::fireEvent( 'settedHelpText' ) 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD Hide() CLASS GetSelector

   if !empty( ::oGet )
      ::oGet:Hide()
   end if

   if !empty( ::oLink )
      ::oLink:Hide()
   end if

   if !empty( ::oHelp )
      ::oHelp:Hide()
   end if

RETURN ( nil )                                

//---------------------------------------------------------------------------//

METHOD Show() CLASS GetSelector

   if !empty( ::oGet )
      ::oGet:Show()
   end if

   if !empty( ::oLink )
      ::oLink:Show()
   end if

   if !empty( ::oHelp )
      ::oHelp:Show()
   end if

RETURN ( nil )                                

//---------------------------------------------------------------------------//

METHOD setBlank()

   ::oGet:varPut( space( 20 ) )

   ::cleanHelpText()

   ::Refresh()

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
