#include "FiveWin.Ch"
#include "Factu.ch" 

CLASS Cliente FROM Ventas

   DATA oViewIncidencia

   METHOD New()

   METHOD setEnviroment()        INLINE ( ::setDataTable( "Client" ) ) 
   
   METHOD showNavigator()        INLINE ( ::oViewNavigator:Resource() ) 
   
   METHOD showIncidencia()       INLINE ( ::oViewIncidencia:setTextoTipoDocumento( "Incidencias : " + alltrim( D():ClientesNombre( ::nView ) ) ),;
                                          ::oViewIncidencia:Resource() )

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

return ( self )

//---------------------------------------------------------------------------//

METHOD Resource( nMode ) CLASS Cliente

   ::oViewEdit:SetTextoTipoDocumento( LblTitle( nMode ) + "cliente" )
   
Return ( ::oViewEdit:Resource( nMode ) )   

//---------------------------------------------------------------------------//


