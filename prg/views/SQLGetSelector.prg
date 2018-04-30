#include "FiveWin.Ch"
#include "Factu.ch" 

CLASS GetSelector

   DATA oController

   DATA idGet
   DATA idHelpGet

   DATA oDialog

   DATA bValue

   DATA oGet
   DATA cGet

   DATA cKey                                    INIT "uuid"

   METHOD New( oSender )

   METHOD setKey( cKey )                        INLINE ( ::cKey := cKey )
   METHOD getKey()                              INLINE ( ::cKey )

   METHOD Activate( idGet, idText, oDlg )
   METHOD Bind( bValue )                        INLINE ( ::bValue := bValue )

   METHOD helpAction()
   METHOD validAction()

   METHOD start()                               INLINE ( ::validAction() )

   METHOD saveValue( value )                    INLINE ( eval( ::bValue, value ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oSender ) CLASS GetSelector

   ::oController     := oSender

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
      RETURN ( Self )
   end if 

   msgalert( hb_valtoexp( hResult ), "hResult" )

   if hhaskey( hResult, ::getKey() )

      ::oGet:cText( hGet( hResult, ::getKey() ) )

      ::saveValue( hGet( hResult, ::getKey() ) )

   end if

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD validAction() CLASS GetSelector

   local value

   if Empty( ::oGet )
      return ( .f. )
   end if

   if Empty( ::oGet:VarGet() )
      Return ( .t. )
   end if

   value       := ::oController:oModel:getField( "nombre", ::getKey(), ::oGet:VarGet() )

   if Empty( value )
      MsgStop( ::oController:cTitle + " no encontrado" )
      return ( .f. )
   else
      ::saveValue( ::oGet:VarGet() )
      ::oGet:oHelptext:cText( value )
      ::oGet:Refresh()
   end if

RETURN ( .t. )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
