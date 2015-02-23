#include "FiveWin.Ch"
#include "Factu.ch" 

CLASS ClienteIncidencia FROM Editable

   DATA oSender

   METHOD New( oSender )

   METHOD setEnviroment()        INLINE ( ::setDataTable( "CliInc" ) ) 

   METHOD setScope( id )         INLINE ( D():setScopeClientesIncidencias( id, ::nView ) )
   METHOD quitScope()            INLINE ( D():quitScopeClientesIncidencias( ::nView ) )

   METHOD showNavigator()
   
   METHOD Resource()

   METHOD saveAppendDocumento()

ENDCLASS

//---------------------------------------------------------------------------//

METHOD New( oSender ) CLASS ClienteIncidencia

   ::oSender               := oSender

   ::nView                 := oSender:nView

   ::oViewEdit             := ClienteIncidenciaView():New( self )   

   ::oViewNavigator        := ClienteIncidenciaViewNavigator():New( self )

   ::setEnviroment()

Return ( self )

//---------------------------------------------------------------------------//

METHOD Resource( nMode ) CLASS ClienteIncidencia

   ::oViewEdit:SetTextoTipoDocumento( LblTitle( nMode ) + "incidencia : " + alltrim( D():ClientesNombre( ::nView ) ) )
   
Return ( ::oViewEdit:Resource( nMode ) )   

//---------------------------------------------------------------------------//

METHOD showNavigator() CLASS ClienteIncidencia

   ::setScope( D():ClientesId( ::nView ) )

   ::oViewNavigator:showView()

   ::quitScope()

Return ( self )

//---------------------------------------------------------------------------//

METHOD saveAppendDocumento() CLASS ClienteIncidencia

   hSet( ::hDictionaryMaster, "Código", D():ClientesId( ::nView ) )

Return ( ::Super:saveAppendDocumento() )

//---------------------------------------------------------------------------//