#include "FiveWin.Ch"
#include "Factu.ch" 

CLASS Cliente FROM Ventas

   METHOD New()

   METHOD setAreas()          INLINE ( ::setWorkArea( D():Clientes( ::nView ) ) )
   
   METHOD setNavigator() 
   
   METHOD propiedadesBrowse()

ENDCLASS

//---------------------------------------------------------------------------//

METHOD New() CLASS Cliente

   if ::OpenFiles()
      
      ::setAreas()

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
      
      ::oViewNavigator:setWorkArea( ::getWorkArea() )

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
