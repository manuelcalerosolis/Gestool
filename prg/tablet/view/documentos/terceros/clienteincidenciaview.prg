#include "FiveWin.Ch"
#include "Factu.ch" 

CLASS ClienteIncidenciaView FROM ViewNavigator

   METHOD getWorkArea()                INLINE ( D():Get( "CliInc", ::nView ) )

   METHOD setTextoTipoDocumento()      INLINE ( ::cTextoTipoDocumento := "Clientes" ) 

   METHOD setItemsBusqueda( aItems )   INLINE ( ::aItemsBusqueda := { "Código", "Nombre" } )   

   METHOD setColumns()

END CLASS

//---------------------------------------------------------------------------//

METHOD setColumns() CLASS ClienteViewSearchNavigator

   ::setBrowseConfigurationName( "Grid clientes incidencia" )

   with object ( ::addColumn() )
      :cHeader           := "Cliente"
      :bEditValue        := {|| ( D():ClientesId( ::getView() ) + CRLF + D():ClientesNombre( ::getView() ) )  }
      :nWidth            := 320
   end with

Return ( self )

//---------------------------------------------------------------------------//