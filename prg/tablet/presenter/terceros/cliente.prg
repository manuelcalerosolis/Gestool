#include "FiveWin.Ch"
#include "Factu.ch" 

CLASS Cliente FROM Ventas

   DATA oViewIncidencia

   METHOD New()

   METHOD setEnviroment()        INLINE ( ::setDataTable( "Client" ) ) 
   
   METHOD showNavigator()        INLINE ( ::oViewNavigator:showView() ) 
   
   METHOD showIncidencia()

   METHOD Resource()

ENDCLASS

//---------------------------------------------------------------------------//

METHOD New() CLASS Cliente

   ::oViewNavigator        := ClienteViewSearchNavigator():New( self )

   ::oViewEdit             := ClienteView():New( self )

   ::oViewIncidencia       := ClienteIncidenciaViewNavigator():New( self )

   if ::OpenFiles()
      
      ::setEnviroment()

      ::showNavigator()

      ::CloseFiles()

   end if   

Return ( self )

//---------------------------------------------------------------------------//

METHOD Resource( nMode ) CLASS Cliente

   ::oViewEdit:SetTextoTipoDocumento( LblTitle( nMode ) + "cliente" )
   
Return ( ::oViewEdit:Resource( nMode ) )   

//---------------------------------------------------------------------------//

METHOD showIncidencia() CLASS Cliente

   ::oViewIncidencia:setTextoTipoDocumento( "Incidencias : " + alltrim( D():ClientesNombre( ::nView ) ) )

   D():setScopeClientesIncidencias( nil, ::nView )
                                          
   ::oViewIncidencia:Resource()

   D():quitScopeClientesIncidencias( ::nView )

Return ( self )

//---------------------------------------------------------------------------//



