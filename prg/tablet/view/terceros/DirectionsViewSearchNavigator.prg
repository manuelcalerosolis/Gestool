#include "FiveWin.Ch"
#include "Factu.ch" 

CLASS DirectionsViewSearchNavigator FROM ViewSearchNavigator

   METHOD setItemsBusqueda()           INLINE ( ::hashItemsSearch := { "Nombre" => "cNomObr", "Código" => "cCliDir" } )

   METHOD setColumns()

   METHOD botonesAcciones()            INLINE ( self )

   METHOD validBarraBusqueda()         INLINE ( .t. )

END CLASS

//---------------------------------------------------------------------------//

METHOD setColumns() CLASS DirectionsViewSearchNavigator

   ::setBrowseConfigurationName( "grid_direcciones" )

   with object ( ::addColumn() )
      :cHeader          := "Cliente"
      :bEditValue       := {|| ( D():ClientesDirecciones( ::getView() ) )->cCodCli }
      :nWidth           := 200
   end with

   with object ( ::addColumn() )
      :cHeader          := "Dirección"
      :bEditValue       := {|| ( ( D():ClientesDirecciones( ::getView() ) )->cCodObr + CRLF + ( D():ClientesDirecciones( ::getView() ) )->cNomObr )  }
      :nWidth           := 900
   end with

Return ( self )

//---------------------------------------------------------------------------//