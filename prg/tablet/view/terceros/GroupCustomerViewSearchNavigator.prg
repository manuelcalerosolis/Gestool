#include "FiveWin.Ch"
#include "Factu.ch" 

CLASS GroupCustomerViewSearchNavigator FROM ViewSearchNavigator

   METHOD setItemsBusqueda()           INLINE ( ::hashItemsSearch := { "Nombre" => "CNOMGRP", "Código" => "CCODGRP" } )

   METHOD setColumns()

   METHOD botonesAcciones()            INLINE ( self )

END CLASS

//---------------------------------------------------------------------------//

METHOD setColumns() CLASS GroupCustomerViewSearchNavigator

   ::setBrowseConfigurationName( "grid_grupo_de_cliente" )

   with object ( ::addColumn() )
      :cHeader          := "Grupo de cliente"
      :bEditValue       := {|| ( ( D():GrupoClientes( ::getView() ) )->CCODGRP + CRLF + ( D():GrupoClientes( ::getView() ) )->CNOMGRP )  }
      :nWidth           := 900
   end with

Return ( self )

//---------------------------------------------------------------------------//