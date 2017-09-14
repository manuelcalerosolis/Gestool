#include "FiveWin.Ch"
#include "Factu.ch" 

CLASS StoreViewSearchNavigator FROM ViewSearchNavigator

   METHOD setItemsBusqueda()           INLINE ( ::hashItemsSearch := { "Nombre" => "Nombre", "C�digo" => "Codigo" } )

   METHOD setColumns()

   METHOD botonesAcciones()            INLINE ( self )

END CLASS

//---------------------------------------------------------------------------//

METHOD setColumns() CLASS StoreViewSearchNavigator

   ::setBrowseConfigurationName( "grid_store" )

   with object ( ::addColumn() )
      :cHeader          := "Almac�n"
      :bEditValue       := {|| ( ( D():Almacen( ::getView() ) )->cCodAlm + CRLF + ( D():Almacen( ::getView() ) )->cNomAlm )  }
      :nWidth           := 420
   end with

Return ( self )

//---------------------------------------------------------------------------//