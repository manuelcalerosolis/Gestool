#include "FiveWin.Ch"
#include "Factu.ch" 

CLASS GetSelector

   DATA oController

   DATA oDialog

   DATA bValue

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

   METHOD Activate( idGet, idText, oDlg )
   METHOD Bind( bValue )                        INLINE ( ::bValue := bValue )

   METHOD helpAction()
   METHOD validAction()

   METHOD start()                               INLINE ( ::validAction() )

   METHOD evalValue( value )                    INLINE ( eval( ::bValue, value ) )

   METHOD showMessage()

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

METHOD Activate( idGet, idText, oDlg ) CLASS GetSelector

   if isFalse( ::fireEvent( 'activating' ) )
      RETURN ( .f. )
   end if

   ::cGet         := eval( ::bValue )

   REDEFINE GET   ::oGet ;
      VAR         ::cGet ;
      ID          idGet ;
      IDTEXT      idText ;
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

   hResult        := ::oController:ActivateSelectorViewNoCenter()

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

METHOD validAction( lSilenceMode ) CLASS GetSelector

   local value             := ""

   DEFAULT lSilenceMode    := .f.

   if empty( ::oGet )
      RETURN ( .t. )
   end if

   if isFalse( ::fireEvent( 'validating' ) )
      RETURN ( .f. )
   end if

   ::evalValue( ::oGet:VarGet() )

   ::oGet:oHelptext:cText( value )

   if empty( ::oGet:VarGet() )

      ::fireEvent( 'validatingEmpty' )
      
      RETURN ( .t. )

   end if

   value                   := ::oController:oModel:getField( "nombre", ::getKey(), ::oGet:VarGet() )

   if empty( value )

      ::fireEvent( 'validatedError' )

      ::showMessage( lSilenceMode )

      RETURN ( .f. )

   end if

   ::evalValue( ::oGet:VarGet() )

   ::oGet:oHelptext:cText( value )

   ::oGet:Refresh()

   ::fireEvent( 'validated' ) 

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
