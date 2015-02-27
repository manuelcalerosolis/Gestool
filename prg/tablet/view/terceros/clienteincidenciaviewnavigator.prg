#include "FiveWin.Ch"
#include "Factu.ch" 

CLASS ClienteIncidenciaViewNavigator FROM ViewNavigator

   METHOD setColumns()

   METHOD getWorkArea()    INLINE ( D():ClientesIncidencias( ::getView() ) )

   METHOD getTextoTipoDocumento();
                           INLINE ( "Incidencias : " + alltrim( D():ClientesNombre( ::getView() ) ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD setColumns() CLASS ClienteIncidenciaViewNavigator

   ::setBrowseConfigurationName( "Grid clientes incidencias" )

   with object ( ::addColumn() )
      :cHeader             := "Incidencia"
      :bEditValue          := {|| alltrim( ( D():ClientesIncidencias( ::getView() ) )->mDesInc )  }
      :nWidth              := 500
   end with

   with object ( ::addColumn() )
      :cHeader             := "Tipo/Fecha"
      :bEditValue          := {|| D():getNombreTipoIncicencias( ( D():ClientesIncidencias( ::getView() ) )->cCodTip, ::getView() ) + CRLF + dtoc( ( D():ClientesIncidencias( ::getView() ) )->dFecInc ) }
      :nWidth              := 500
   end with

Return ( self )

//---------------------------------------------------------------------------//