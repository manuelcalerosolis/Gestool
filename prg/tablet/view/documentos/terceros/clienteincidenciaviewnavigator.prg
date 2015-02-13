#include "FiveWin.Ch"
#include "Factu.ch" 

CLASS ClienteIncidenciaViewNavigator FROM ViewNavigator

   METHOD setColumns()

END CLASS

//---------------------------------------------------------------------------//

METHOD setColumns() CLASS ClienteIncidenciaViewNavigator

   ::setBrowseConfigurationName( "Grid clientes incidencias" )

   with object ( ::addColumn() )
      :cHeader           := "Incidencia"
      :bEditValue        := {|| D():ClientesIncidenciasId( ::getView() ) + CRLF + D():ClientesIncidenciasNombre( ::getView() ) }
      :nWidth            := 320
   end with

Return ( self )

//---------------------------------------------------------------------------//