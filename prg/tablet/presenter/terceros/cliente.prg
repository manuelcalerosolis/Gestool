#include "FiveWin.Ch"
#include "Factu.ch" 

CLASS Cliente FROM Ventas

   DATA oClienteIncidencia

   DATA oViewIncidencia

   METHOD New()

   METHOD setEnviroment()        INLINE ( ::setDataTable( "Client" ) ) 
   
   METHOD showIncidencia()

   METHOD Resource()

ENDCLASS

//---------------------------------------------------------------------------//

METHOD New() CLASS Cliente

   if ::OpenFiles()

      ::oViewNavigator        := ClienteViewSearchNavigator():New( self )

      ::oViewEdit             := ClienteView():New( self )

      ::oClienteIncidencia    := ClienteIncidencia():New( self )

      // ::oViewIncidencia       := ClienteIncidenciaViewNavigator():New( self )

      ::setEnviroment()

      ::oViewNavigator:showView()

      msgAlert( "salida de show showNavigator")

      ::CloseFiles()

   end if   

Return ( self )

//---------------------------------------------------------------------------//

METHOD Resource( nMode ) CLASS Cliente

   ::oViewEdit:SetTextoTipoDocumento( LblTitle( nMode ) + "cliente" )
   
Return ( ::oViewEdit:Resource( nMode ) )   

//---------------------------------------------------------------------------//

METHOD showIncidencia() CLASS Cliente
   
   ::oClienteIncidencia:showNavigator()

Return ( self )


   ::oViewIncidencia:setTextoTipoDocumento( "Incidencias : " + alltrim( D():ClientesNombre( ::nView ) ) )

   ::oClienteIncidencia:setScope( D():ClientesId( ::nView ) )
                                          
   ::oViewIncidencia:Resource()

   ::oClienteIncidencia:quitScope()

Return ( self )

//---------------------------------------------------------------------------//



