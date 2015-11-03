#include "FiveWin.Ch"
#include "Factu.ch" 

CLASS ProductViewSearchNavigator FROM ViewSearchNavigator

   METHOD setItemsBusqueda()           INLINE ( ::hashItemsSearch := { "Nombre" => "Nombre", "Código" => "Codigo" } )

   METHOD setColumns()

   METHOD botonesAcciones()            INLINE ( self )

END CLASS

//---------------------------------------------------------------------------//

METHOD setColumns() CLASS ProductViewSearchNavigator

   ::setBrowseConfigurationName( "grid_articulo" )

   with object ( ::addColumn() )
      :cHeader          := "Artículo"
      :bEditValue       := {|| ( ( D():Articulos( ::getView() ) )->Codigo + CRLF + ( D():Articulos( ::getView() ) )->Nombre )  }
      :nWidth           := 420
   end with

   with object ( ::addColumn() )
      :cHeader          := "Precio / Precio I.V.A."
      :bEditValue       := {|| ( Trans( ( D():Articulos( ::getView() ) )->pVenta1, cPouDiv() ) + CRLF + Trans( ( D():Articulos( ::getView() ) )->pVtaIva1, cPouDiv() ) ) }
      :nWidth           := 420
      :nDataStrAlign    := 1
      :nHeadStrAlign    := 1
   end with

Return ( self )

//---------------------------------------------------------------------------//