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

   TGridImage():Build(  {  "nTop"      => 75,;
                           "nLeft"     => {|| GridWidth( 0.5, ::oDlg ) },;
                           "nWidth"    => 64,;
                           "nHeight"   => 64,;
                           "cResName"  => "gc_plus_64",;
                           "bLClicked" => {|| if( ::oSender:Append(), ::refreshBrowse(), ) },;
                           "oWnd"      => ::oDlg } )

   if ::oSender:lAlowEdit

   TGridImage():Build(  {  "nTop"      => 75,;
                           "nLeft"     => {|| GridWidth( 2, ::oDlg ) },;
                           "nWidth"    => 64,;
                           "nHeight"   => 64,;
                           "cResName"  => "gc_pencil_64",;
                           "bLClicked" => {|| if( ::oSender:Edit(), ::refreshBrowse(), ) },;
                           "oWnd"      => ::oDlg } )

   else

   TGridImage():Build(  {  "nTop"      => 75,;
                           "nLeft"     => {|| GridWidth( 2, ::oDlg ) },;
                           "nWidth"    => 64,;
                           "nHeight"   => 64,;
                           "cResName"  => "gc_binocular_64",;
                           "bLClicked" => {|| if( ::oSender:Zoom(), ::refreshBrowse(), ) },;
                           "oWnd"      => ::oDlg } )

   end if

   TGridImage():Build(  {  "nTop"      => 75,;
                           "nLeft"     => {|| GridWidth( 3.5, ::oDlg ) },;
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