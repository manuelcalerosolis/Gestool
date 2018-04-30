#include "FiveWin.Ch"
#include "Factu.ch" 

CLASS GetSelector

   DATA oController

   DATA oDialog

   DATA bValue

   DATA oGet
   DATA cGet

   DATA cKey                                    INIT "uuid"

   DATA oView

   METHOD New( oSender )

   METHOD setKey( cKey )                        INLINE ( ::cKey := cKey )
   METHOD getKey()                              INLINE ( ::cKey )

   METHOD setView( oView )                      INLINE ( ::oView := oView )

   METHOD Activate( idGet, idText, oDlg )
   METHOD Bind( bValue )                        INLINE ( ::bValue := bValue )

   METHOD helpAction()
   METHOD validAction()

   METHOD start()                               INLINE ( ::validAction() )

   METHOD evalValue( value )                    INLINE ( eval( ::bValue, value ) )

   METHOD showMessage()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oSender ) CLASS GetSelector

   ::oController  := oSender

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Activate( idGet, idText, oDlg ) CLASS GetSelector

   ::cGet         := eval( ::bValue )

   REDEFINE GET   ::oGet ;
      VAR         ::cGet ;
      ID          idGet ;
      IDTEXT      idText ;
      BITMAP      "Lupa" ;
      OF          oDlg

   ::oGet:bHelp   := {|| ::helpAction() }
   ::oGet:bValid  := {|| ::validAction() }

RETURN ( ::oGet )

//---------------------------------------------------------------------------//

METHOD helpAction() CLASS GetSelector

   local hResult

   hResult        := ::oController:ActivateSelectorViewNoCenter()

   if hb_isnil( hResult )
      ::oGet:cText( "" )
      RETURN ( .f. )
   end if 

   if hhaskey( hResult, ::getKey() )

      ::oGet:cText( hGet( hResult, ::getKey() ) )

      ::evalValue( hGet( hResult, ::getKey() ) )

   end if

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD validAction( lSilenceMode ) CLASS GetSelector

   local value             := ""

   DEFAULT lSilenceMode    := .f.

   if empty( ::oGet )
      RETURN ( .t. )
   end if

   ::evalValue( ::oGet:VarGet() )

   ::oGet:oHelptext:cText( value )

   if empty( ::oGet:VarGet() )
      RETURN ( .t. )
   end if

   value                   := ::oController:oModel:getField( "nombre", ::getKey(), ::oGet:VarGet() )

   if empty( value )
      ::showMessage( lSilenceMode )
      RETURN ( .f. )
   end if

   ::evalValue( ::oGet:VarGet() )

   ::oGet:oHelptext:cText( value )

   ::oGet:Refresh()

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD showMessage( lSilenceMode )

   if lSilenceMode 
      RETURN ( self )
   end if 

   if empty( ::oView ) .or. empty( ::oView:oMessage )
      msgStop( ::oController:cTitle + " no encontrado" )
   else
      ::oView:showMessage( ::oController:cTitle + " no encontrado" )
   end if 

RETURN ( self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
