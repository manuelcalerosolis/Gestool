#include "FiveWin.Ch"
#include "Factu.ch" 

CLASS Cliente FROM Ventas

   DATA oClienteIncidencia

   METHOD New()

   METHOD setEnviroment()        INLINE ( ::setDataTable( "Client" ) ) 
   
   METHOD setNavigator() 
   
   METHOD Resource()

ENDCLASS

//---------------------------------------------------------------------------//

METHOD New() CLASS Cliente

   ::oViewNavigator       := ClienteViewSearchNavigator():New( self )

   ::oViewEdit            := ClienteView():New( self )

   if ::OpenFiles()

      // ::oClienteIncidencia    := ClienteIncidencia():New( Self )
      
      ::setEnviroment()

      ::setNavigator()

      ::CloseFiles()

   end if   

return ( self )

//---------------------------------------------------------------------------//

METHOD setNavigator() CLASS Cliente

   // ::oViewNavigator       := ClienteViewSearchNavigator():New( self )

   if !Empty( ::oViewNavigator )
      ::oViewNavigator:Resource()
   end if

return ( self )

//---------------------------------------------------------------------------//

METHOD Resource( nMode ) CLASS Cliente

   local lResource         := .f.

   // ::oViewEdit             := ClienteView():New( self )

   if !Empty( ::oViewEdit )

      ::oViewEdit:SetTextoTipoDocumento( LblTitle( nMode ) + "cliente" )
      
      lResource            := ::oViewEdit:Resource( nMode )

   end if

Return ( lResource )   

//---------------------------------------------------------------------------//


