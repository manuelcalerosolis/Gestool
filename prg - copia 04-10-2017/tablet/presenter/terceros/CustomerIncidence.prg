#include "FiveWin.Ch"
#include "Factu.ch" 

CLASS CustomerIncidence FROM Editable

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
   METHOD onPreSaveAppend()   

   METHOD startDialog()          INLINE ( msginfo( ::oViewEdit:getTitleDocumento() ) )

   METHOD onPreSaveEdit()        INLINE ( .t. )
   METHOD onPreEnd()             INLINE ( .t. )

ENDCLASS

//---------------------------------------------------------------------------//

METHOD New( oSender ) CLASS CustomerIncidence

   ::oSender               := oSender

   ::nView                 := oSender:nView

   ::oViewEdit             := CustomerIncidenceView():New( self ) 
   ::oViewEdit:setTitleDocumento( "incidencias" )  

   ::oViewNavigator        := CustomerIncidenceViewNavigator():New( self )
   ::oViewNavigator:setTitleDocumento( "Incidencias clientes" )  

   ::setEnviroment()

Return ( self )

//---------------------------------------------------------------------------//

METHOD showNavigator() CLASS CustomerIncidence

   ::idClient              := D():ClientesId( ::nView )

   ::setScope( ::idClient )

   ::oViewNavigator:showView()

   ::quitScope()

Return ( self )

//---------------------------------------------------------------------------//

METHOD onPostGetDocumento() CLASS CustomerIncidence

   local cTipo := hGet( ::hDictionaryMaster, "Tipo" )

   if !empty( cTipo )
      ::cNombreIncidencia  := D():getNombreTipoIncicencias( cTipo, ::nView )
   end if 

Return ( .t. )   

//---------------------------------------------------------------------------//

METHOD onPreSaveAppend() CLASS CustomerIncidence

   local cTipo := ""

   if !empty( ::cNombreIncidencia )
      cTipo    := D():getCodigoTipoIncicencias( ::cNombreIncidencia, ::nView )   
   end if 

   hSet( ::hDictionaryMaster, "Código", ::idClient )  
   hSet( ::hDictionaryMaster, "Tipo", cTipo ) 

Return ( .t. )   

//---------------------------------------------------------------------------//

