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
      :cHeader             := "Incidencia/Fecha"
      :bEditValue          := {|| alltrim( ( D():ClientesIncidencias( ::getView() ) )->mDesInc ) + CRLF + dtoc( ( D():ClientesIncidenciasNombre( ::getView() ) )->dFecInc ) }   // 
      :nWidth              := 600
   end with

   with object ( ::addColumn() )
      :cHeader             := "Tipo"
      :bEditValue          := {|| D():getNombreTipoIncicencias( ( D():ClientesIncidencias( ::getView() ) )->cCodTip, ::getView() ) }
//      :bEditValue          := {|| ( D():ClientesIncidencias( ::getView() ) )->cCodTip }
      :nWidth              := 600
   end with

Return ( self )

//---------------------------------------------------------------------------//