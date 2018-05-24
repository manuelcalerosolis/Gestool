#include "FiveWin.Ch"
#include "Factu.ch" 

CLASS GetSelector

   DATA oController

   DATA oDialog

   DATA bValue

   DATA bValid

   DATA oGet
   DATA cGet

   DATA cKey                                    INIT  "codigo"

   DATA oView

   DATA oEvents

   METHOD New( oSender )
   METHOD End()                                 

   METHOD setKey( cKey )                        INLINE ( ::cKey := cKey )
   METHOD getKey()                              INLINE ( ::cKey )

   METHOD setView( oView )                      INLINE ( ::oView := oView )
   METHOD getView()                             INLINE ( iif( hb_isnil( ::oView ), ::oController:oDialogView, ::oView ) )

   METHOD Build( hBuilder )

   METHOD Activate( idGet, idText, oDlg )
   METHOD Bind( bValue )                        INLINE ( ::bValue := bValue )
   
   METHOD setValid( bValid )                    INLINE ( ::bValid := bValid )

   METHOD helpAction()

   METHOD validAction()

   METHOD loadHelpText()

   METHOD start()                               INLINE ( ::loadHelpText( .t. ) )

   METHOD evalValue( value )                    INLINE ( eval( ::bValue, value ) )

   METHOD showMessage()

   METHOD Hide()                                INLINE ( if( !empty( ::oGet ), ::oGet:Hide(), ) )
   METHOD Show()                                INLINE ( if( !empty( ::oGet ), ::oGet:Show(), ) )

   // Events-------------------------------------------------------------------

   METHOD setEvent( cEvent, bEvent )            INLINE ( if( !empty( ::oEvents ), ::oEvents:set( cEvent, bEvent ), ) )
   METHOD fireEvent( cEvent )                   INLINE ( if( !empty( ::oEvents ), ::oEvents:fire( cEvent ), ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS GetSelector

   ::oController  := oController

   ::oEvents      := Events():New()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End()

   if !empty( ::oEvents )
      ::oEvents:End()
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD Build( hBuilder ) CLASS GetSelector

   local idGet    := if( hhaskey( hBuilder, "idGet" ),   hBuilder[ "idGet" ],    nil )
   local idText   := if( hhaskey( hBuilder, "idText" ),  hBuilder[ "idText" ],   nil )
   local idSay    := if( hhaskey( hBuilder, "idSay" ),   hBuilder[ "idSay"],     nil )
   local oDlg     := if( hhaskey( hBuilder, "oDialog" ), hBuilder[ "oDialog" ],  nil )

RETURN ( ::Activate( idGet, idText, oDlg, idSay ) )

//---------------------------------------------------------------------------//

METHOD Activate( idGet, idText, oDlg, idSay ) CLASS GetSelector

   if isFalse( ::fireEvent( 'activating' ) )
      RETURN ( nil )
   end if

   ::cGet         := eval( ::bValue )

   REDEFINE GET   ::oGet ;
      VAR         ::cGet ;
      ID          idGet ;
      IDTEXT      idText ;
      IDSAY       idSay ;
      BITMAP      "Lupa" ;
      WHEN        ( ::oController:getSenderController():isNotZoomMode() ) ;
      OF          oDlg

   ::oGet:bHelp   := {|| ::helpAction() }
   ::oGet:bValid  := {|| ::validAction() }

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
      ::oGet:cText( "" )
      RETURN ( .f. )
   end if 

   if hhaskey( hResult, ::getKey() )

      ::oGet:cText( hGet( hResult, ::getKey() ) )

      ::evalValue( hGet( hResult, ::getKey() ) )

   end if

   ::fireEvent( 'helped' ) 

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD validAction()

   if empty( ::bValid ) .or. eval( ::bValid, ::cGet )
      RETURN ( ::loadHelpText() )
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

   ::evalValue( ::oGet:varGet() )

   ::oGet:oHelptext:cText( value )

   if empty( ::oGet:varGet() )

      ::fireEvent( 'loadingEmpty' )
      
      RETURN ( .t. )

   end if

   value                   := ::oController:oModel:getField( "nombre", ::getKey(), ::oGet:varGet() )

   if empty( value )

      ::fireEvent( 'loadedError' )

      ::showMessage( lSilenceMode )

      RETURN ( .f. )

   end if

   ::evalValue( ::oGet:varGet() )

   ::oGet:oHelptext:cText( value )

   ::oGet:Refresh()

   ::fireEvent( 'loaded' ) 

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD showMessage( lSilenceMode )

   if lSilenceMode 
      RETURN ( self )
   end if 

   if empty( ::getView() ) .or. empty( ::getView():oMessage )
      msgStop( ::oController:cTitle + " no encontrado" )
   else
      ::getView():showMessage( ::oController:cTitle + " no encontrado" )
   end if 

RETURN ( self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
