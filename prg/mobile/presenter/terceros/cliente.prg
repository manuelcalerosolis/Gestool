#include "FiveWin.Ch"
#include "Factu.ch" 

CLASS Cliente FROM Ventas

   DATA oClienteIncidencia

   METHOD New()

   METHOD setEnviroment()        INLINE ( ::setDataTable( "Client" ) ) 
   
   METHOD setNavigator() 
   
   METHOD propiedadesBrowse()

   METHOD Resource()

ENDCLASS

//---------------------------------------------------------------------------//

METHOD New() CLASS Cliente

   if ::OpenFiles()

      ::oClienteIncidencia    := ClienteIncidencia():New( Self )
      
      ::setEnviroment()

      ::setNavigator()

      ::CloseFiles()

   end if   

return ( self )

//---------------------------------------------------------------------------//

METHOD setNavigator() CLASS Cliente

   ::oViewNavigator       := ViewNavigator():New( self )

   if !Empty( ::oViewNavigator )

      ::oViewNavigator:setTextoTipoDocuento( "Clientes" )

      ::oViewNavigator:setItemsBusqueda( { "Código", "Nombre" } )
      
      ::oViewNavigator:ResourceViewNavigator()

   end if

return ( self )

//---------------------------------------------------------------------------//

METHOD propiedadesBrowse() CLASS Cliente

   ::oViewNavigator:setBrowseConfigurationName( "Grid clientes" )

   with object ( ::oViewNavigator:oBrowse:AddCol() )
      :cHeader           := "Código"
      :bEditValue        := {|| D():ClientesId( ::nView ) }
      :nWidth            := 160
   end with

   with object ( ::oViewNavigator:oBrowse:AddCol() )
      :cHeader           := "Cliente"
      :bEditValue        := {|| D():ClientesNombre( ::nView )  }
      :nWidth            := 320
   end with

Return ( self )

//---------------------------------------------------------------------------//

METHOD Resource( nMode ) CLASS Cliente

   ::oViewEdit       := ViewCliente():New( self )

   if !Empty( ::oViewEdit )

      ::oViewEdit:setTextoTipoDocuento( LblTitle( nMode ) + "cliente" )
      
      ::oViewEdit:ResourceViewEdit( nMode )

   end if

Return ( .t. )   

//---------------------------------------------------------------------------//


