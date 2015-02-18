#include "FiveWin.Ch"
#include "Factu.ch" 

CLASS ClienteViewSearchNavigator FROM ViewSearchNavigator

   METHOD setTextoTipoDocumento()      INLINE ( ::cTextoTipoDocumento := "Clientes" ) 

   METHOD setItemsBusqueda( aItems )   INLINE ( ::aItemsBusqueda := { "Código", "Nombre" } )   

   METHOD setColumns()

   METHOD botonesAcciones()

END CLASS

//---------------------------------------------------------------------------//

METHOD botonesAcciones() CLASS ClienteViewSearchNavigator

   ::Super:botonesAcciones()

   TGridImage():Build(  {  "nTop"      => 75,;
                           "nLeft"     => {|| GridWidth( 5, ::oDlg ) },;
                           "nWidth"    => 64,;
                           "nHeight"   => 64,;
                           "cResName"  => "flat_about_64",;
                           "bLClicked" => {|| ::oSender:showIncidencia() },;
                           "oWnd"      => ::oDlg } )

Return ( self )

//---------------------------------------------------------------------------//

METHOD setColumns() CLASS ClienteViewSearchNavigator

   ::setBrowseConfigurationName( "Grid clientes" )

   with object ( ::addColumn() )
      :cHeader           := "Cliente"
      :bEditValue        := {|| ( D():ClientesId( ::getView() ) + CRLF + D():ClientesNombre( ::getView() ) )  }
      :nWidth            := 320
   end with

Return ( self )

//---------------------------------------------------------------------------//