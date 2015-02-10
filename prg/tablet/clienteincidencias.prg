#include "FiveWin.Ch"
#include "Factu.ch" 

CLASS ClienteIncidencia FROM Editable

   METHOD New( oSender )

   METHOD setEnviroment()        INLINE ( ::setDataTable( "CliInc" ) ) 
   
   METHOD setNavigator() 
   
   METHOD propiedadesBrowse()

   METHOD Resource()

ENDCLASS

//---------------------------------------------------------------------------//

METHOD New( oSender ) CLASS ClienteIncidencia

   ::oSender   := oSender

   ::setEnviroment()

   ::setNavigator()

return ( self )

//---------------------------------------------------------------------------//

METHOD setNavigator() CLASS ClienteIncidencia

   ::oViewNavigator       := ViewNavigator():New( self )

   if !Empty( ::oViewNavigator )

      ::oViewNavigator:setTextoTipoDocuento( "Clientes" )

      ::oViewNavigator:setItemsBusqueda( { "Código", "Nombre" } )
      
      ::oViewNavigator:ResourceViewNavigator()

   end if

return ( self )

//---------------------------------------------------------------------------//

METHOD propiedadesBrowse() CLASS ClienteIncidencia

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

METHOD Resource( nMode ) CLASS ClienteIncidencia

   ::oViewEdit       := ViewCliente():New( self )

   if !Empty( ::oViewEdit )

      ::oViewEdit:setTextoTipoDocuento( LblTitle( nMode ) + "cliente" )
      
      ::oViewEdit:ResourceViewEdit( nMode )

   end if

Return ( .t. )   

//---------------------------------------------------------------------------//


