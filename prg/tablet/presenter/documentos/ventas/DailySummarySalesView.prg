#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Xbrowse.ch"

CLASS DailySummarySalesView FROM ViewBase

   DATA oPedido               INIT ""
   DATA oPedidoTotal          INIT ""
   DATA oAlbaran              INIT ""
   DATA oAlbaranTotal         INIT ""
   DATA oFactura              INIT ""
   DATA oFacturaTotal         INIT ""
   DATA oTotal                INIT ""

   METHOD New()

   METHOD insertControls()

   METHOD defineAceptarCancelar()

   METHOD defineCabecera()

   METHOD definePedidos()

   METHOD defineAlbaranes()
   
   METHOD defineFacturas()

   METHOD defineTotal()

   METHOD getTitleTipoDocumento()   INLINE ( ::getTextoTipoDocumento() )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oSender ) CLASS DailySummarySalesView

   ::oSender   := oSender

Return ( self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

METHOD insertControls() CLASS DailySummarySalesView

   ::defineCabecera()

   ::definePedidos()

   ::defineAlbaranes()

   ::defineFacturas()

   ::defineTotal()

Return( Self )

//---------------------------------------------------------------------------//

METHOD defineAceptarCancelar() CLASS DailySummarySalesView

   
   TGridImage():Build(  {  "nTop"      => 5,;
                           "nLeft"     => {|| GridWidth( 10.5, ::oDlg ) },;
                           "nWidth"    => 64,;
                           "nHeight"   => 64,;
                           "cResName"  => "flat_check_64",;
                           "bLClicked" => {|| ::oDlg:End() },;
                           "oWnd"      => ::oDlg } )

Return ( self )

//---------------------------------------------------------------------------//

METHOD defineCabecera() CLASS DailySummarySalesView

   
   TGridSay():Build( {  "nRow"      => 67,;
                        "nCol"      => {|| GridWidth( 4.5, ::oDlg ) },;
                        "bText"     => {|| "Numero de documentos" },;
                        "oWnd"      => ::oDlg,;
                        "oFont"     => oGridFontBold(),;
                        "lPixels"   => .t.,;
                        "nClrText"  => Rgb( 0, 0, 0 ),;
                        "nClrBack"  => Rgb( 255, 255, 255 ),;
                        "nWidth"    => {|| GridWidth( 2.5, ::oDlg ) },;
                        "nHeight"   => 23,;
                        "lDesign"   => .f. } )


   TGridSay():Build( {  "nRow"      => 67,;
                        "nCol"      => {|| GridWidth( 7.5, ::oDlg ) },;
                        "bText"     => {|| "Total" },;
                        "oWnd"      => ::oDlg,;
                        "oFont"     => oGridFontBold(),;
                        "lPixels"   => .t.,;
                        "nClrText"  => Rgb( 0, 0, 0 ),;
                        "nClrBack"  => Rgb( 255, 255, 255 ),;
                        "nWidth"    => {|| GridWidth( 0.5, ::oDlg ) },;
                        "nHeight"   => 23,;
                        "lDesign"   => .f. } )

   
Return ( self )

//---------------------------------------------------------------------------//

METHOD definePedidos() CLASS DailySummarySalesView

   ::oSender:CalculatePedido()

   TGridSay():Build( {  "nRow"      => 120,;
                        "nCol"      => {|| GridWidth( 0.5, ::oDlg ) },;
                        "bText"     => {|| "Pedidos de clientes: " },;
                        "oWnd"      => ::oDlg,;
                        "oFont"     => oGridFont(),;
                        "lPixels"   => .t.,;
                        "nClrText"  => Rgb( 0, 0, 0 ),;
                        "nClrBack"  => Rgb( 255, 255, 255 ),;
                        "nWidth"    => {|| GridWidth( 2, ::oDlg ) },;
                        "nHeight"   => 23,;
                        "lDesign"   => .f. } )

   TGridGet():Build( {  "nRow"      => 120,;
                        "nCol"      => {|| GridWidth( 4.5, ::oDlg ) },;
                        "bSetGet"   => {|u| ::oPedido },;
                        "oWnd"      => ::oDlg,;
                        "lPixels"   => .t.,;
                        "nWidth"    => {|| GridWidth( 2, ::oDlg ) },;
                        "nHeight"   => 23,;
                        "lRight"    => .t.,;
                        "bWhen"     => {|| .f. } } )

   TGridGet():Build( {  "nRow"      => 120,;
                        "nCol"      => {|| GridWidth( 7.5, ::oDlg ) },;
                        "bSetGet"   => {|u| ::oPedidoTotal },;
                        "oWnd"      => ::oDlg,;
                        "lPixels"   => .t.,;
                        "nWidth"    => {|| GridWidth( 2, ::oDlg ) },;
                        "nHeight"   => 23,;
                        "lRight"    => .t.,;
                        "bWhen"     => {|| .f. } } )


Return( Self )

//---------------------------------------------------------------------------//

METHOD defineAlbaranes() CLASS DailySummarySalesView

   ::oSender:CalculateAlbaran()

   TGridSay():Build( {  "nRow"      => 148,;
                        "nCol"      => {|| GridWidth( 0.5, ::oDlg ) },;
                        "bText"     => {|| "Albaranes de clientes: " },;
                        "oWnd"      => ::oDlg,;
                        "oFont"     => oGridFont(),;
                        "lPixels"   => .t.,;
                        "nClrText"  => Rgb( 0, 0, 0 ),;
                        "nClrBack"  => Rgb( 255, 255, 255 ),;
                        "nWidth"    => {|| GridWidth( 2, ::oDlg ) },;
                        "nHeight"   => 23,;
                        "lDesign"   => .f. } )

   TGridGet():Build( {  "nRow"      => 148,;
                        "nCol"      => {|| GridWidth( 4.5, ::oDlg ) },;
                        "bSetGet"   => {|u| ::oAlbaran },;
                        "oWnd"      => ::oDlg,;
                        "lPixels"   => .t.,;
                        "nWidth"    => {|| GridWidth( 2, ::oDlg ) },;
                        "nHeight"   => 23,;
                        "lRight"    => .t.,;
                        "bWhen"     => {|| .f. } } )

   TGridGet():Build( {  "nRow"      => 148,;
                        "nCol"      => {|| GridWidth( 7.5, ::oDlg ) },;
                        "bSetGet"   => {|u| ::oAlbaranTotal },;
                        "oWnd"      => ::oDlg,;
                        "lPixels"   => .t.,;
                        "nWidth"    => {|| GridWidth( 2, ::oDlg ) },;
                        "nHeight"   => 23,;
                        "lRight"    => .t.,;
                        "bWhen"     => {|| .f. } } )


Return( Self )

//---------------------------------------------------------------------------//

METHOD defineFacturas() CLASS DailySummarySalesView

   ::oSender:CalculateFactura()

   TGridSay():Build( {  "nRow"      => 176,;
                        "nCol"      => {|| GridWidth( 0.5, ::oDlg ) },;
                        "bText"     => {|| "Facturas de clientes: " },;
                        "oWnd"      => ::oDlg,;
                        "oFont"     => oGridFont(),;
                        "lPixels"   => .t.,;
                        "nClrText"  => Rgb( 0, 0, 0 ),;
                        "nClrBack"  => Rgb( 255, 255, 255 ),;
                        "nWidth"    => {|| GridWidth( 2, ::oDlg ) },;
                        "nHeight"   => 23,;
                        "lDesign"   => .f. } )

   TGridGet():Build( {  "nRow"      => 176,;
                        "nCol"      => {|| GridWidth( 4.5, ::oDlg ) },;
                        "bSetGet"   => {|u| ::oFactura },;
                        "oWnd"      => ::oDlg,;
                        "lPixels"   => .t.,;
                        "nWidth"    => {|| GridWidth( 2, ::oDlg ) },;
                        "nHeight"   => 23,;
                        "lRight"    => .t.,;
                        "bWhen"     => {|| .f. } } )

   TGridGet():Build( {  "nRow"      => 176,;
                        "nCol"      => {|| GridWidth( 7.5, ::oDlg ) },;
                        "bSetGet"   => {|u| ::oFacturaTotal },;
                        "oWnd"      => ::oDlg,;
                        "lPixels"   => .t.,;
                        "nWidth"    => {|| GridWidth( 2, ::oDlg ) },;
                        "nHeight"   => 23,;
                        "lRight"    => .t.,;
                        "bWhen"     => {|| .f. } } )


Return( Self )

//---------------------------------------------------------------------------//

METHOD defineTotal() CLASS DailySummarySalesView

   ::oSender:CalculateTotal()

   TGridGet():Build(   {   "nRow"      => 204,;
                           "nCol"      => {|| GridWidth( 7.5, ::oDlg ) },;
                           "bSetGet"   => {|u| ::oTotal },;
                           "oWnd"      => ::oDlg,;
                           "oFont"     => oGridFontBold(),;
                           "lPixels"   => .t.,;
                           "nWidth"    => {|| GridWidth( 2, ::oDlg ) },;
                           "nHeight"   => 23,;
                           "lRight"    => .t.,;
                           "bWhen"     => {|| .f. } } )

Return( Self )

//---------------------------------------------------------------------------//

/*METHOD defineRuta() CLASS DailySummarySalesView

   local aCbxRuta       := { "Domingo", "Lunes", "Martes", "Miércoles", "Jueves", "Viernes", "Sábado", "Todos" }
   local cCbxRuta       := aCbxRuta[ Dow( GetSysDate() ) ]
   local cSayTextRuta

   TGridSay():Build(    {  "nRow"      => 67,;
                           "nCol"      => {|| GridWidth( 0.5, ::oDlg ) },;
                           "bText"     => {|| "Ruta" },;
                           "oWnd"      => ::oDlg,;
                           "oFont"     => oGridFont(),;
                           "lPixels"   => .t.,;
                           "nClrText"  => Rgb( 0, 0, 0 ),;
                           "nClrBack"  => Rgb( 255, 255, 255 ),;
                           "nWidth"    => {|| GridWidth( 1, ::oDlg ) },;
                           "nHeight"   => 23,;
                           "lDesign"   => .f. } )

   ::oCbxRuta     := TGridComboBox():Build(  {  "nRow"      => 67,;
                                                "nCol"      => {|| GridWidth( 2.5, ::oDlg ) },;
                                                "bSetGet"   => {|u| if( PCount() == 0, cCbxRuta, cCbxRuta := u ) },;
                                                "oWnd"      => ::oDlg,;
                                                "nWidth"    => {|| GridWidth( 2, ::oDlg ) },;
                                                "nHeight"   => 25,;
                                                "aItems"    => aCbxRuta,;
                                                "bChange"   => {|| ::oSender:ChangeRuta( ::oCbxRuta, ::oGetCliente, ::oGetDireccion, ::oSayTextRuta ) } } )

   TGridImage():Build(  {  "nTop"      => 63,;
                           "nLeft"     => {|| GridWidth( 4.5, ::oDlg ) },;
                           "nWidth"    => 64,;
                           "nHeight"   => 64,;
                           "cResName"  => "flat_left_64",;
                           "bLClicked" => {|| ::oSender:priorClient( ::oCbxRuta, ::oSayTextRuta, ::oGetCliente, ::oGetDireccion ) },;
                           "oWnd"      => ::oDlg } )

   TGridImage():Build(  {  "nTop"      => 63,;
                           "nLeft"     => {|| GridWidth( 6, ::oDlg ) },;
                           "nWidth"    => 64,;
                           "nHeight"   => 64,;
                           "cResName"  => "flat_right_64",;
                           "bLClicked" => {|| ::oSender:nextClient( ::oCbxRuta, ::oSayTextRuta, ::oGetCliente, ::oGetDireccion ) },;
                           "oWnd"      => ::oDlg } )

   ::oSayTextRuta := TGridGet():Build(    {  "nRow"      => 67,;
                                             "nCol"      => {|| GridWidth( 7, ::oDlg ) },;
                                             "bSetGet"   => {|u| if( PCount() == 0, cSayTextRuta, cSayTextRuta := u ) },;
                                             "oWnd"      => ::oDlg,;
                                             "nWidth"    => {|| GridWidth( 4.5, ::oDlg ) },;
                                             "nHeight"   => 23,;
                                             "bWhen"     => {|| .f. },;
                                             "lPixels"   => .t. } )
   

Return ( self )

//---------------------------------------------------------------------------//

METHOD defineCliente() CLASS DailySummarySalesView

   TGridUrllink():Build({  "nTop"      => 95,;
                           "nLeft"     => {|| GridWidth( 0.5, ::oDlg ) },;
                           "cURL"      => "Cliente",;
                           "oWnd"      => ::oDlg,;
                           "oFont"     => oGridFont(),;
                           "lPixel"    => .t.,;
                           "nClrInit"  => nGridColor(),;
                           "nClrOver"  => nGridColor(),;
                           "nClrVisit" => nGridColor(),;
                           "bAction"   => {|| GridBrwClient( ::oGetCliente, ::oNombreCliente ) } } )

   ::oGetCliente        := TGridGet():Build( {  "nRow"      => 95,;
                                                "nCol"      => {|| GridWidth( 2.5, ::oDlg ) },;
                                                "bSetGet"   => {|u| ::SetGetValue( u, "Cliente" ) },;
                                                "oWnd"      => ::oDlg,;
                                                "nWidth"    => {|| GridWidth( 2, ::oDlg ) },;
                                                "nHeight"   => 23,;
                                                "lPixels"   => .t.,;
                                                "bValid"    => {|| ::oSender:lValidCliente( ::oGetCliente, ::oNombreCliente, ::nMode, ::getSerie ) } } )
   
   ::oNombreCliente     := TGridGet():Build( {  "nRow"      => 95,;
                                                "nCol"      => {|| GridWidth( 4.5, ::oDlg ) },;
                                                "bSetGet"   => {|u| ::SetGetValue( u, "NombreCliente" ) },;
                                                "oWnd"      => ::oDlg,;
                                                "lPixels"   => .t.,;
                                                "nWidth"    => {|| GridWidth( 7, ::oDlg ) },;
                                                "nHeight"   => 23 } )

Return ( self )

//---------------------------------------------------------------------------//

METHOD defineDireccion() CLASS DailySummarySalesView

   local cTextoNombreDireccion  := Space( 200 )
   local oGetNombreDireccion

   TGridUrllink():Build(   {  "nTop"      => 120,;
                              "nLeft"     => {|| GridWidth( 0.5, ::oDlg ) },;
                              "cURL"      => "Dirección",;
                              "oWnd"      => ::oDlg,;
                              "oFont"     => oGridFont(),;
                              "lPixel"    => .t.,;
                              "nClrInit"  => nGridColor(),;
                              "nClrOver"  => nGridColor(),;
                              "nClrVisit" => nGridColor(),;
                              "bAction"   => {|| GridBrwObras( ::oGetDireccion, oGetNombreDireccion, hGet( ::oSender:hDictionaryMaster, "Cliente" ) ) } } )

   ::oGetDireccion      := TGridGet():Build( {  "nRow"      => 120,;
                                                "nCol"      => {|| GridWidth( 2.5, ::oDlg ) },;
                                                "bSetGet"   => {|u| ::SetGetValue( u, "Direccion" ) },;
                                                "oWnd"      => ::oDlg,;
                                                "nWidth"    => {|| GridWidth( 2, ::oDlg ) },;
                                                "nHeight"   => 23,;
                                                "lPixels"   => .t.,;
                                                "bValid"    => {|| ::oSender:lValidDireccion( ::oGetDireccion, oGetNombreDireccion, hGet( ::oSender:hDictionaryMaster, "Cliente" ) ) } } )

   oGetNombreDireccion  := TGridGet():Build( {  "nRow"      => 120,;
                                                "nCol"      => {|| GridWidth( 4.5, ::oDlg ) },;
                                                "bSetGet"   => {|u| if( PCount() == 0, cTextoNombreDireccion, cTextoNombreDireccion := u ) },;
                                                "oWnd"      => ::oDlg,;
                                                "nWidth"    => {|| GridWidth( 7, ::oDlg ) },;
                                                "lPixels"   => .t.,;
                                                "nHeight"   => 23 } )

Return ( self )

//---------------------------------------------------------------------------//

METHOD defineBotonesAcciones() CLASS DailySummarySalesView

   if oUser():lAdministrador()

      TGridImage():Build(  {  "nTop"      => 145,;
                              "nLeft"     => {|| GridWidth( 0.5, ::oDlg ) },;
                              "nWidth"    => 64,;
                              "nHeight"   => 64,;
                              "cResName"  => "flat_add_64",;
                              "bLClicked" => {|| ::oSender:AppendDetail(), ::RefreshBrowse() },;
                              "oWnd"      => ::oDlg } )

      TGridImage():Build(  {  "nTop"      => 145,;
                              "nLeft"     => {|| GridWidth( 2, ::oDlg ) },;
                              "nWidth"    => 64,;
                              "nHeight"   => 64,;
                              "cResName"  => "flat_edit_64",;
                              "bLClicked" => {|| ::oSender:EditDetail( ::oBrowse:nArrayAt ), ::RefreshBrowse() },;
                              "oWnd"      => ::oDlg } )

      TGridImage():Build(  {  "nTop"      => 145,;
                              "nLeft"     => {|| GridWidth( 3.5, ::oDlg ) },;
                              "nWidth"    => 64,;
                              "nHeight"   => 64,;
                              "cResName"  => "flat_minus_64",;
                              "bLClicked" => {|| ::oSender:DeleteDetail( ::oBrowse:nArrayAt ), ::RefreshBrowse()},;
                              "oWnd"      => ::oDlg } )
   endif

Return ( self )

//---------------------------------------------------------------------------//

METHOD defineBotonesMovimiento() CLASS DailySummarySalesView

   TGridImage():Build(  {  "nTop"      => 145,;
                           "nLeft"     => {|| GridWidth( 7.5, ::oDlg ) },;
                           "nWidth"    => 64,;
                           "nHeight"   => 64,;
                           "cResName"  => "flat_page_up_64",;
                           "bLClicked" => {|| ::oBrowse:PageUp(), ::oBrowse:Select( 0 ), ::oBrowse:Select( 1 ), ::oBrowse:Refresh()  },;
                           "oWnd"      => ::oDlg } )

   TGridImage():Build(  {  "nTop"      => 145,;
                           "nLeft"     => {|| GridWidth( 8.5, ::oDlg ) },;
                           "nWidth"    => 64,;
                           "nHeight"   => 64,;
                           "cResName"  => "flat_up_64",;
                           "bLClicked" => {|| ::oBrowse:GoUp(), ::oBrowse:Select( 0 ), ::oBrowse:Select( 1 ), ::oBrowse:Refresh()  },;
                           "oWnd"      => ::oDlg } )

   TGridImage():Build(  {  "nTop"      => 145,;
                           "nLeft"     => {|| GridWidth( 9.5, ::oDlg ) },;
                           "nWidth"    => 64,;
                           "nHeight"   => 64,;
                           "cResName"  => "flat_down_64",;
                           "bLClicked" => {|| ::oBrowse:GoDown(), ::oBrowse:Select( 0 ), ::oBrowse:Select( 1 ), ::oBrowse:Refresh() },;
                           "oWnd"      => ::oDlg } )

   TGridImage():Build(  {  "nTop"      => 145,;
                           "nLeft"     => {|| GridWidth( 10.5, ::oDlg ) },;
                           "nWidth"    => 64,;
                           "nHeight"   => 64,;
                           "cResName"  => "flat_page_down_64",;
                           "bLClicked" => {|| ::oBrowse:PageDown(), ::oBrowse:Select( 0 ), ::oBrowse:Select( 1 ), ::oBrowse:Refresh() },;
                           "oWnd"      => ::oDlg } )


Return ( self ) 
*/

//---------------------------------------------------------------------------//   
//---------------------------------------------------------------------------//