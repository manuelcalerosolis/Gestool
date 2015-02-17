#include "FiveWin.Ch"
#include "Factu.ch" 

CLASS ClienteIncidencia FROM Editable

   DATA oSender

   METHOD New( oSender )

   METHOD setEnviroment()        INLINE ( ::setDataTable( "CliInc" ) ) 

   METHOD setScope( id )         INLINE ( D():setScopeClientesIncidencias( id, ::nView ) )
   METHOD quitsetScope()         INLINE ( D():quitScopeClientesIncidencias( ::nView ) )

   METHOD showNavigator()
   
   METHOD Resource()

ENDCLASS

//---------------------------------------------------------------------------//

METHOD New( oSender ) CLASS ClienteIncidencia

   ::oSender               := oSender

   ::nView                 := oSender:nView

   ::oViewNavigator        := ClienteIncidenciaViewNavigator():New( self )

   ::setEnviroment()

Return ( self )

//---------------------------------------------------------------------------//

METHOD Resource( nMode ) CLASS ClienteIncidencia

   msgAlert( "Resource not defined yet!")

Return ( .t. )   

//---------------------------------------------------------------------------//

METHOD showNavigator()

   ::setScope( D():ClientesId( ::nView ) )

   ::oViewNavigator:showView()

   ::quitsetScope()

Return ( self )

//---------------------------------------------------------------------------//
