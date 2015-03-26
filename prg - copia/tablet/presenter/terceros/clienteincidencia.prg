#include "FiveWin.Ch"
#include "Factu.ch" 

CLASS ClienteIncidencia FROM Editable

   DATA oSender

   DATA idClient

   DATA cNombreIncidencia

   METHOD New( oSender )

   METHOD setEnviroment()        INLINE ( ::setDataTable( "CliInc" ) ) 

   METHOD setScope( id )         INLINE ( D():setScopeClientesIncidencias( id, ::nView ) )
   METHOD quitScope()            INLINE ( D():quitScopeClientesIncidencias( ::nView ) )

   METHOD showNavigator()

   METHOD Resource()             INLINE ( ::oViewEdit:Resource() )   

   METHOD onPostGetDocumento()
   METHOD onPreSaveDocumento()   

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

METHOD showNavigator() CLASS ClienteIncidencia

   ::idClient              := D():ClientesId( ::nView )

   ::setScope( ::idClient )

   ::oViewNavigator:showView()

   ::quitScope()

Return ( self )

//---------------------------------------------------------------------------//

METHOD onPostGetDocumento() CLASS ClienteIncidencia

   local cTipo := hGet( ::hDictionaryMaster, "Tipo" )

   if !empty( cTipo )
      ::cNombreIncidencia  := D():getNombreTipoIncicencias( cTipo, ::nView )
   end if 

Return ( .t. )   

//---------------------------------------------------------------------------//

METHOD onPreSaveDocumento() CLASS ClienteIncidencia

   local cTipo := ""

   if !empty( ::cNombreIncidencia )
      cTipo    := D():getCodigoTipoIncicencias( ::cNombreIncidencia, ::nView )   
   end if 

   hSet( ::hDictionaryMaster, "Código", ::idClient )  
   hSet( ::hDictionaryMaster, "Tipo", cTipo ) 

Return ( .t. )   

//---------------------------------------------------------------------------//

