#include "FiveWin.Ch"
#include "Factu.ch" 

CLASS CustomerViewSearchNavigator FROM ViewSearchNavigator

   METHOD setItemsBusqueda()           INLINE ( ::hashItemsSearch := {  "Establecimiento" => "NbrEst",;
                                                                        "Nombre" => "Titulo",;
                                                                        "Código" => "Cod",;
                                                                        "Población" => "Poblacion" } )

   METHOD setColumns()

   METHOD botonesAcciones()

END CLASS

//---------------------------------------------------------------------------//

METHOD botonesAcciones() CLASS CustomerViewSearchNavigator

   ::Super:botonesAcciones()

   TGridImage():Build(  {  "nTop"      => 75,;
                           "nLeft"     => {|| GridWidth( 5, ::oDlg ) },;
                           "nWidth"    => 64,;
                           "nHeight"   => 64,;
                           "cResName"  => "gc_speech_balloon_answer_64",;
                           "bLClicked" => {|| ::oSender:showIncidencia() },;
                           "oWnd"      => ::oDlg } )

Return ( self )

//---------------------------------------------------------------------------//

METHOD setColumns() CLASS CustomerViewSearchNavigator

   ::setBrowseConfigurationName( "grid_clientes" )

   with object ( ::addColumn() )
      :cHeader           := "Cliente"
      :bEditValue        := {|| ( D():ClientesId( ::getView() ) + CRLF + D():ClientesNombre( ::getView() ) )  }
      :nWidth            := 420
   end with

   with object ( ::addColumn() )
      :cHeader           := "Dirección/Tlf."
      :bEditValue        := {|| ( D():Clientes( ::getView() ) )->Domicilio + CRLF + ( D():Clientes( ::getView() ) )->Telefono }
      :nWidth            := 420
   end with

   with object ( ::addColumn() )
      :cHeader           := "Población/Código postal"
      :bEditValue        := {|| ( D():Clientes( ::getView() ) )->Poblacion + CRLF + ( D():Clientes( ::getView() ) )->CodPostal }
      :nWidth            := 420
   end with

   with object ( ::addColumn() )
      :cHeader           := "Establecimiento/Contacto"
      :bEditValue        := {|| ( D():Clientes( ::getView() ) )->NbrEst + CRLF + ( D():Clientes( ::getView() ) )->cPerCto }
      :nWidth            := 420
   end with

Return ( self )

//---------------------------------------------------------------------------//