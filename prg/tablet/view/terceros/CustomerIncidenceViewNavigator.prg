#include "FiveWin.Ch"
#include "Factu.ch" 

CLASS CustomerIncidenceViewNavigator FROM ViewNavigator

   METHOD setColumns()

   METHOD getWorkArea()    INLINE ( D():ClientesIncidencias( ::getView() ) )

   METHOD getTextoTipoDocumento();
                           INLINE ( "Incidencias : " + alltrim( D():ClientesNombre( ::getView() ) ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD setColumns() CLASS CustomerIncidenceViewNavigator

   ::setBrowseConfigurationName( "grid_clientes_incidencias" )

   with object ( ::addColumn() )
      :cHeader             := "Incidencia"
      :bEditValue          := {|| alltrim( ( D():ClientesIncidencias( ::getView() ) )->mDesInc )  }
      :nWidth              := 500
   end with

   with object ( ::addColumn() )
      :cHeader             := "Tipo/Fecha"
      :bEditValue          := {||   D():getNombreTipoIncicencias( ( D():ClientesIncidencias( ::getView() ) )->cCodTip, ::getView() ) + CRLF + ;
                                    dateTimeToString( ( D():ClientesIncidencias( ::getView() ) )->dFecInc, ( D():ClientesIncidencias( ::getView() ) )->tTimInc ) }
      :nWidth              := 500
   end with

Return ( self )

//---------------------------------------------------------------------------//