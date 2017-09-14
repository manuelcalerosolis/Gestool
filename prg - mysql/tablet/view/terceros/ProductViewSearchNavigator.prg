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
      :cHeader          := "Precio 1 / Precio 1 I.V.A."
      :bEditValue       := {|| ( Trans( ( D():Articulos( ::getView() ) )->pVenta1, cPouDiv() ) + CRLF + Trans( ( D():Articulos( ::getView() ) )->pVtaIva1, cPouDiv() ) ) }
      :nWidth           := 420
      :nDataStrAlign    := 1
      :nHeadStrAlign    := 1
   end with

   with object ( ::addColumn() )
      :cHeader          := "Precio 2 / Precio 2 I.V.A."
      :bEditValue       := {|| ( Trans( ( D():Articulos( ::getView() ) )->pVenta2, cPouDiv() ) + CRLF + Trans( ( D():Articulos( ::getView() ) )->pVtaIva2, cPouDiv() ) ) }
      :nWidth           := 420
      :nDataStrAlign    := 1
      :nHeadStrAlign    := 1
      :lHide            := .t.
   end with

   with object ( ::addColumn() )
      :cHeader          := "Precio 3  / Precio 3  I.V.A."
      :bEditValue       := {|| ( Trans( ( D():Articulos( ::getView() ) )->pVenta3 , cPouDiv() ) + CRLF + Trans( ( D():Articulos( ::getView() ) )->pVtaIva3, cPouDiv() ) ) }
      :nWidth           := 420
      :nDataStrAlign    := 1
      :nHeadStrAlign    := 1
      :lHide            := .t.
   end with

   with object ( ::addColumn() )
      :cHeader          := "Precio 4  / Precio 4  I.V.A."
      :bEditValue       := {|| ( Trans( ( D():Articulos( ::getView() ) )->pVenta4 , cPouDiv() ) + CRLF + Trans( ( D():Articulos( ::getView() ) )->pVtaIva4, cPouDiv() ) ) }
      :nWidth           := 420
      :nDataStrAlign    := 1
      :nHeadStrAlign    := 1
      :lHide            := .t.
   end with

   with object ( ::addColumn() )
      :cHeader          := "Precio 5  / Precio 5  I.V.A."
      :bEditValue       := {|| ( Trans( ( D():Articulos( ::getView() ) )->pVenta5 , cPouDiv() ) + CRLF + Trans( ( D():Articulos( ::getView() ) )->pVtaIva5, cPouDiv() ) ) }
      :nWidth           := 420
      :nDataStrAlign    := 1
      :nHeadStrAlign    := 1
      :lHide            := .t.
   end with

   with object ( ::addColumn() )
      :cHeader          := "Precio 6  / Precio 6  I.V.A."
      :bEditValue       := {|| ( Trans( ( D():Articulos( ::getView() ) )->pVenta6 , cPouDiv() ) + CRLF + Trans( ( D():Articulos( ::getView() ) )->pVtaIva6, cPouDiv() ) ) }
      :nWidth           := 420
      :nDataStrAlign    := 1
      :nHeadStrAlign    := 1
      :lHide            := .t.
   end with

Return ( self )

//---------------------------------------------------------------------------//