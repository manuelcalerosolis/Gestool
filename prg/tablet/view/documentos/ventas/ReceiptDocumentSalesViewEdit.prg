#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Xbrowse.ch"

CLASS ReceiptDocumentSalesViewEdit FROM ViewEdit  
  
   DATA oCbxEstado
   DATA aCbxEstado                        INIT { "Cobrado", "Pendiente" }
   DATA cCbxEstado

   DATA oImporteGastos

   DATA nImporteOriginal 

   METHOD New()

   METHOD insertControls()

   METHOD startDialog()                   INLINE ( ::nImporteOriginal := ::getValue( "ImporteCobro" ) )
   METHOD validDialog()                   INLINE ( msgalert("validDialog"), ::validImporteCobro() )

   METHOD defineNumeroRecibo( nRow )

   METHOD defineFechaExpedicion( nRow )
   METHOD defineFechaVencimiento( nRow )

   METHOD defineImporte( nRow )   

   METHOD defineImporteCobro( nRow )   
   METHOD defineImporteGastos( nRow )   

   METHOD defineCliente( nRow )

   METHOD defineFormaPago( nRow )

   METHOD defineAgente( nRow )

   METHOD defineConcepto( nRow )

   METHOD definePagadoPor( nRow )

   METHOD defineEstado( nRow )

   METHOD cTextoEstado()

   METHOD defineAceptarCancelar()

   METHOD validImporteCobro()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oSender ) CLASS ReceiptDocumentSalesViewEdit

   ::oSender            := oSender

Return ( self )

//---------------------------------------------------------------------------//

METHOD insertControls() CLASS ReceiptDocumentSalesViewEdit

   ::defineNumeroRecibo()

   ::defineFechaExpedicion()
   ::defineFechaVencimiento()

   ::defineEstado()

   ::defineImporte()

   ::defineImporteCobro()

   ::defineImporteGastos()

   ::defineCliente()

   ::defineFormaPago()

   ::defineAgente()

   ::defineConcepto()

   ::definePagadoPor()

Return ( self )

//---------------------------------------------------------------------------//

METHOD defineCliente( nRow ) CLASS ReceiptDocumentSalesViewEdit

   DEFAULT nRow         := 250

   TGridSay():Build(    {  "nRow"      => nRow,;
                           "nCol"      => {|| GridWidth( 0.5, ::oDlg ) },;
                           "bText"     => {|| "Cliente" },;
                           "oWnd"      => ::oDlg,;
                           "oFont"     => oGridFont(),;
                           "lPixels"   => .t.,;
                           "nClrText"  => Rgb( 0, 0, 0 ),;
                           "nClrBack"  => Rgb( 255, 255, 255 ),;
                           "nWidth"    => {|| GridWidth( 1.5, ::oDlg ) },;
                           "nHeight"   => 23,;
                           "lDesign"   => .f. } )

   TGridGet():Build(    {  "nRow"      => nRow,;
                           "nCol"      => {|| GridWidth( 2.5, ::oDlg ) },;
                           "bSetGet"   => {|u| ::SetGetValue( u, "Cliente" ) },;
                           "oWnd"      => ::oDlg,;
                           "nWidth"    => {|| GridWidth( 2.5, ::oDlg ) },;
                           "nHeight"   => 23,;
                           "lPixels"   => .t.,;
                           "bWhen"     => {|| .f. },;
                           "bValid"    => {|| .t. } } )
   
   TGridGet():Build(    {  "nRow"      => nRow,;
                           "nCol"      => {|| GridWidth( 5, ::oDlg ) },;
                           "bSetGet"   => {|u| ::SetGetValue( u, "NombreCliente" ) },;
                           "oWnd"      => ::oDlg,;
                           "lPixels"   => .t.,;
                           "nWidth"    => {|| GridWidth( 5, ::oDlg ) },;
                           "nHeight"   => 23,;
                           "bWhen"     => {|| .f. } } )

Return ( self )

//---------------------------------------------------------------------------//

METHOD defineFormaPago( nRow ) CLASS ReceiptDocumentSalesViewEdit

   local cSayTextFPago  := retFld( hGet( ::oSender:hDictionaryMaster, "Pago" ), D():FormasPago( ::oSender:nView ) )

   DEFAULT nRow         := 275

   TGridSay():Build(    {  "nRow"      => nRow,;
                           "nCol"      => {|| GridWidth( 0.5, ::oDlg ) },;
                           "bText"     => {|| "Forma pago" },;
                           "oWnd"      => ::oDlg,;
                           "oFont"     => oGridFont(),;
                           "lPixels"   => .t.,;
                           "nClrText"  => Rgb( 0, 0, 0 ),;
                           "nClrBack"  => Rgb( 255, 255, 255 ),;
                           "nWidth"    => {|| GridWidth( 1.5, ::oDlg ) },;
                           "nHeight"   => 23,;
                           "lDesign"   => .f. } )

   TGridGet():Build(    {  "nRow"      => nRow,;
                           "nCol"      => {|| GridWidth( 2.5, ::oDlg ) },;
                           "bSetGet"   => {|u| ::SetGetValue( u, "Pago" ) },;
                           "oWnd"      => ::oDlg,;
                           "nWidth"    => {|| GridWidth( 2.5, ::oDlg ) },;
                           "nHeight"   => 23,;
                           "lPixels"   => .t.,;
                           "bWhen"     => {|| .f. },;
                           "bValid"    => {|| .t. } } )
   
   TGridGet():Build(    {  "nRow"      => nRow,;
                           "nCol"      => {|| GridWidth( 5, ::oDlg ) },;
                           "bSetGet"   => {|u| if( PCount() == 0, cSayTextFPago, cSayTextFPago := u ) },;
                           "oWnd"      => ::oDlg,;
                           "lPixels"   => .t.,;
                           "nWidth"    => {|| GridWidth( 5, ::oDlg ) },;
                           "nHeight"   => 23,;
                           "bWhen"     => {|| .f. } } )

Return ( self )

//---------------------------------------------------------------------------//

METHOD defineNumeroRecibo( nRow ) CLASS ReceiptDocumentSalesViewEdit

   local cNumero        := ""

   DEFAULT nRow         := 75

   cNumero              := hGet( ::oSender:hDictionaryMaster, "Serie" )
   cNumero              += "/"
   cNumero              += AllTrim( Str( hGet( ::oSender:hDictionaryMaster, "Numero" ) ) )
   cNumero              += "/"
   cNumero              += hGet( ::oSender:hDictionaryMaster, "Sufijo" )
   cNumero              += "-"
   cNumero              += AllTrim( Str( hGet( ::oSender:hDictionaryMaster, "NumeroRecibo" ) ) )

   TGridSay():Build(    {  "nRow"      => nRow,;
                           "nCol"      => {|| GridWidth( 0.5, ::oDlg ) },;
                           "bText"     => {|| "Número" },;
                           "oWnd"      => ::oDlg,;
                           "oFont"     => oGridFont(),;
                           "lPixels"   => .t.,;
                           "nClrText"  => Rgb( 0, 0, 0 ),;
                           "nClrBack"  => Rgb( 255, 255, 255 ),;
                           "nWidth"    => {|| GridWidth( 1.5, ::oDlg ) },;
                           "nHeight"   => 23,;
                           "lDesign"   => .f. } )

   TGridGet():Build(    {  "nRow"      => nRow,;
                           "nCol"      => {|| GridWidth( 2.5, ::oDlg ) },;
                           "bSetGet"   => {|u| if( PCount() == 0, cNumero, cNumero := u ) },;
                           "oWnd"      => ::oDlg,;
                           "nWidth"    => {|| GridWidth( 2.5, ::oDlg ) },;
                           "nHeight"   => 23,;
                           "lPixels"   => .t.,;
                           "bWhen"     => {|| .f. },;
                           "bValid"    => {|| .t. } } )

Return ( self )

//---------------------------------------------------------------------------//

METHOD defineFechaExpedicion( nRow ) CLASS ReceiptDocumentSalesViewEdit

   DEFAULT nRow         := 100

   TGridSay():Build(    {  "nRow"      => nRow,;
                           "nCol"      => {|| GridWidth( 0.5, ::oDlg ) },;
                           "bText"     => {|| "F. Exp." },;
                           "oWnd"      => ::oDlg,;
                           "oFont"     => oGridFont(),;
                           "lPixels"   => .t.,;
                           "nClrText"  => Rgb( 0, 0, 0 ),;
                           "nClrBack"  => Rgb( 255, 255, 255 ),;
                           "nWidth"    => {|| GridWidth( 1.5, ::oDlg ) },;
                           "nHeight"   => 23,;
                           "lDesign"   => .f. } )

   TGridGet():Build(    {  "nRow"      => nRow,;
                           "nCol"      => {|| GridWidth( 2.5, ::oDlg ) },;
                           "bSetGet"   => {|u| ::SetGetValue( u, "FechaExpedicion" ) },;
                           "oWnd"      => ::oDlg,;
                           "nWidth"    => {|| GridWidth( 2.5, ::oDlg ) },;
                           "nHeight"   => 23,;
                           "lPixels"   => .t.,;
                           "bWhen"     => {|| .f. },;
                           "bValid"    => {|| .t. } } )

Return ( self )

//---------------------------------------------------------------------------//

METHOD defineFechaVencimiento( nRow ) CLASS ReceiptDocumentSalesViewEdit

   DEFAULT nRow         := 125

   TGridSay():Build(    {  "nRow"      => nRow,;
                           "nCol"      => {|| GridWidth( 0.5, ::oDlg ) },;
                           "bText"     => {|| "F. Vto." },;
                           "oWnd"      => ::oDlg,;
                           "oFont"     => oGridFont(),;
                           "lPixels"   => .t.,;
                           "nClrText"  => Rgb( 0, 0, 0 ),;
                           "nClrBack"  => Rgb( 255, 255, 255 ),;
                           "nWidth"    => {|| GridWidth( 1.5, ::oDlg ) },;
                           "nHeight"   => 23,;
                           "lDesign"   => .f. } )

   TGridGet():Build(    {  "nRow"      => nRow,;
                           "nCol"      => {|| GridWidth( 2.5, ::oDlg ) },;
                           "bSetGet"   => {|u| ::SetGetValue( u, "FechaVencimiento" ) },;
                           "oWnd"      => ::oDlg,;
                           "nWidth"    => {|| GridWidth( 2.5, ::oDlg ) },;
                           "nHeight"   => 23,;
                           "lPixels"   => .t.,;
                           "bWhen"     => {|| .f. },;
                           "bValid"    => {|| .t. } } )

Return ( self )

//---------------------------------------------------------------------------//

METHOD defineImporte( nRow ) CLASS ReceiptDocumentSalesViewEdit

   DEFAULT nRow         := 175

   TGridSay():Build(    {  "nRow"      => nRow,;
                           "nCol"      => {|| GridWidth( 0.5, ::oDlg ) },;
                           "bText"     => {|| "Importe" },;
                           "oWnd"      => ::oDlg,;
                           "oFont"     => oGridFont(),;
                           "lPixels"   => .t.,;
                           "nClrText"  => Rgb( 0, 0, 0 ),;
                           "nClrBack"  => Rgb( 255, 255, 255 ),;
                           "nWidth"    => {|| GridWidth( 1.5, ::oDlg ) },;
                           "nHeight"   => 23,;
                           "lDesign"   => .f. } )

   TGridGet():Build(    {  "nRow"      => nRow,;
                           "nCol"      => {|| GridWidth( 2.5, ::oDlg ) },;
                           "bSetGet"   => {|u| ::SetGetValue( u, "TotalDocumento" ) },;
                           "oWnd"      => ::oDlg,;
                           "cPict"     => cPorDiv(),;
                           "nWidth"    => {|| GridWidth( 2.5, ::oDlg ) },;
                           "nHeight"   => 23,;
                           "lPixels"   => .t.,;
                           "lRight"    => .t.,;
                           "bValid"    => {|| .t. } } )

Return ( self )

//---------------------------------------------------------------------------//

METHOD defineImporteCobro( nRow ) CLASS ReceiptDocumentSalesViewEdit

   DEFAULT nRow         := 200

   TGridSay():Build(    {  "nRow"      => nRow,;
                           "nCol"      => {|| GridWidth( 0.5, ::oDlg ) },;
                           "bText"     => {|| "Cobros" },;
                           "oWnd"      => ::oDlg,;
                           "oFont"     => oGridFont(),;
                           "lPixels"   => .t.,;
                           "nClrText"  => Rgb( 0, 0, 0 ),;
                           "nClrBack"  => Rgb( 255, 255, 255 ),;
                           "nWidth"    => {|| GridWidth( 1.5, ::oDlg ) },;
                           "nHeight"   => 23,;
                           "lDesign"   => .f. } )

   TGridGet():Build(    {  "nRow"      => nRow,;
                           "nCol"      => {|| GridWidth( 2.5, ::oDlg ) },;
                           "bSetGet"   => {|u| ::SetGetValue( u, "ImporteCobro" ) },;
                           "oWnd"      => ::oDlg,;
                           "cPict"     => cPorDiv(),;
                           "nWidth"    => {|| GridWidth( 2.5, ::oDlg ) },;
                           "nHeight"   => 23,;
                           "lPixels"   => .t.,;
                           "lRight"    => .t. } )

Return ( self )

//---------------------------------------------------------------------------//

METHOD defineImporteGastos( nRow ) CLASS ReceiptDocumentSalesViewEdit

   DEFAULT nRow         := 225

   TGridSay():Build(    {  "nRow"      => nRow,;
                           "nCol"      => {|| GridWidth( 0.5, ::oDlg ) },;
                           "bText"     => {|| "Gastos" },;
                           "oWnd"      => ::oDlg,;
                           "oFont"     => oGridFont(),;
                           "lPixels"   => .t.,;
                           "nClrText"  => Rgb( 0, 0, 0 ),;
                           "nClrBack"  => Rgb( 255, 255, 255 ),;
                           "nWidth"    => {|| GridWidth( 1.5, ::oDlg ) },;
                           "nHeight"   => 23,;
                           "lDesign"   => .f. } )

   ::oImporteGastos  := TGridGet():Build(    {  "nRow"      => nRow,;
                                                "nCol"      => {|| GridWidth( 2.5, ::oDlg ) },;
                                                "bSetGet"   => {|u| ::SetGetValue( u, "ImporteGastos" ) },;
                                                "oWnd"      => ::oDlg,;
                                                "cPict"     => cPorDiv(),;
                                                "nWidth"    => {|| GridWidth( 2.5, ::oDlg ) },;
                                                "nHeight"   => 23,;
                                                "lPixels"   => .t.,;
                                                "lRight"    => .t.,;
                                                "bValid"    => {|| .t. } } )

Return ( self )

//---------------------------------------------------------------------------//

METHOD defineAgente( nRow ) CLASS ReceiptDocumentSalesViewEdit

   local cSayTextAgente    := cNbrAgent( hGet( ::oSender:hDictionaryMaster, "Agente" ) )

   DEFAULT nRow            := 300


   TGridSay():Build(    {  "nRow"      => nRow,;
                           "nCol"      => {|| GridWidth( 0.5, ::oDlg ) },;
                           "bText"     => {|| "Agente" },;
                           "oWnd"      => ::oDlg,;
                           "oFont"     => oGridFont(),;
                           "lPixels"   => .t.,;
                           "nClrText"  => Rgb( 0, 0, 0 ),;
                           "nClrBack"  => Rgb( 255, 255, 255 ),;
                           "nWidth"    => {|| GridWidth( 1.5, ::oDlg ) },;
                           "nHeight"   => 23,;
                           "lDesign"   => .f. } )

   TGridGet():Build(    {  "nRow"      => nRow,;
                           "nCol"      => {|| GridWidth( 2.5, ::oDlg ) },;
                           "bSetGet"   => {|u| ::SetGetValue( u, "Agente" ) },;
                           "oWnd"      => ::oDlg,;
                           "nWidth"    => {|| GridWidth( 2.5, ::oDlg ) },;
                           "nHeight"   => 23,;
                           "lPixels"   => .t.,;
                           "bWhen"     => {|| .f. },;
                           "bValid"    => {|| .t. } } )
   
   TGridGet():Build(    {  "nRow"      => nRow,;
                           "nCol"      => {|| GridWidth( 5, ::oDlg ) },;
                           "bSetGet"   => {|u| if( PCount() == 0, cSayTextAgente, cSayTextAgente := u ) },;
                           "oWnd"      => ::oDlg,;
                           "lPixels"   => .t.,;
                           "nWidth"    => {|| GridWidth( 5, ::oDlg ) },;
                           "nHeight"   => 23,;
                           "bWhen"     => {|| .f. } } )

Return ( self )

//---------------------------------------------------------------------------//

METHOD defineConcepto( nRow ) CLASS ReceiptDocumentSalesViewEdit

   DEFAULT nRow            := 325


   TGridSay():Build(    {  "nRow"      => nRow,;
                           "nCol"      => {|| GridWidth( 0.5, ::oDlg ) },;
                           "bText"     => {|| "Concepto" },;
                           "oWnd"      => ::oDlg,;
                           "oFont"     => oGridFont(),;
                           "lPixels"   => .t.,;
                           "nClrText"  => Rgb( 0, 0, 0 ),;
                           "nClrBack"  => Rgb( 255, 255, 255 ),;
                           "nWidth"    => {|| GridWidth( 2, ::oDlg ) },;
                           "nHeight"   => 23,;
                           "lDesign"   => .f. } )

   TGridGet():Build(    {  "nRow"      => nRow,;
                           "nCol"      => {|| GridWidth( 2.5, ::oDlg ) },;
                           "bSetGet"   => {|u| ::SetGetValue( u, "Concepto" ) },;
                           "oWnd"      => ::oDlg,;
                           "nWidth"    => {|| GridWidth( 7.5, ::oDlg ) },;
                           "nHeight"   => 23,;
                           "lPixels"   => .t.,;
                           "bWhen"     => {|| .f. },;
                           "bValid"    => {|| .t. } } )

Return ( self )

//---------------------------------------------------------------------------//

METHOD definePagadoPor( nRow ) CLASS ReceiptDocumentSalesViewEdit

   DEFAULT nRow            := 350

   TGridSay():Build(    {  "nRow"      => nRow,;
                           "nCol"      => {|| GridWidth( 0.5, ::oDlg ) },;
                           "bText"     => {|| "Pagado por" },;
                           "oWnd"      => ::oDlg,;
                           "oFont"     => oGridFont(),;
                           "lPixels"   => .t.,;
                           "nClrText"  => Rgb( 0, 0, 0 ),;
                           "nClrBack"  => Rgb( 255, 255, 255 ),;
                           "nWidth"    => {|| GridWidth( 1.5, ::oDlg ) },;
                           "nHeight"   => 23,;
                           "lDesign"   => .f. } )

   TGridGet():Build(    {  "nRow"      => nRow,;
                           "nCol"      => {|| GridWidth( 2.5, ::oDlg ) },;
                           "bSetGet"   => {|u| ::SetGetValue( u, "PagadoPor" ) },;
                           "oWnd"      => ::oDlg,;
                           "nWidth"    => {|| GridWidth( 7.5, ::oDlg ) },;
                           "nHeight"   => 23,;
                           "lPixels"   => .t.,;
                           "bValid"    => {|| .t. } } )

Return ( self )

//---------------------------------------------------------------------------//

METHOD defineEstado( nRow ) CLASS ReceiptDocumentSalesViewEdit

   DEFAULT nRow         := 150

   ::cTextoEstado()

   TGridSay():Build(    {  "nRow"      => nRow,;
                           "nCol"      => {|| GridWidth( 0.5, ::oDlg ) },;
                           "bText"     => {|| "Estado" },;
                           "oWnd"      => ::oDlg,;
                           "oFont"     => oGridFont(),;
                           "lPixels"   => .t.,;
                           "nClrText"  => Rgb( 0, 0, 0 ),;
                           "nClrBack"  => Rgb( 255, 255, 255 ),;
                           "nWidth"    => {|| GridWidth( 1.5, ::oDlg ) },;
                           "nHeight"   => 23,;
                           "lDesign"   => .f. } )

   ::oCbxEstado         := TGridComboBox():Build(  {  "nRow"      => nRow,;
                                                      "nCol"      => {|| GridWidth( 2.5, ::oDlg ) },;
                                                      "bSetGet"   => {|u| if( PCount() == 0, ::cCbxEstado, ::cCbxEstado := u ) },;
                                                      "oWnd"      => ::oDlg,;
                                                      "nWidth"    => {|| GridWidth( 2.5, ::oDlg ) },;
                                                      "nHeight"   => 25,;
                                                      "aItems"    => ::aCbxEstado } )

Return ( self )

//---------------------------------------------------------------------------//

METHOD cTextoEstado() CLASS ReceiptDocumentSalesViewEdit

   if hGet( ::oSender:hDictionaryMaster, "LogicoCobrado" )
      ::cCbxEstado  := "Cobrado"
   else
      ::cCbxEstado  := "Pendiente"
   end if

Return ( nil )

//---------------------------------------------------------------------------//

METHOD defineAceptarCancelar() CLASS ReceiptDocumentSalesViewEdit

   TGridImage():Build(  {  "nTop"      => 5,;
                           "nLeft"     => {|| GridWidth( 7.5, ::oDlg ) },;
                           "nWidth"    => 64,;
                           "nHeight"   => 64,;
                           "cResName"  => "gc_error_64",;
                           "bLClicked" => {|| ::oSender:onViewCancel() },;
                           "oWnd"      => ::oDlg } )

   TGridImage():Build(  {  "nTop"      => 5,;
                           "nLeft"     => {|| GridWidth( 9.0, ::oDlg ) },;
                           "nWidth"    => 64,;
                           "nHeight"   => 64,;
                           "cResName"  => "gc_printer_ok2_64",;
                           "bLClicked" => {|| ::oSender:onViewSave(), ::oSender:setTrueAceptarImprimir() },;
                           "oWnd"      => ::oDlg } )

   TGridImage():Build(  {  "nTop"      => 5,;
                           "nLeft"     => {|| GridWidth( 10.5, ::oDlg ) },;
                           "nWidth"    => 64,;
                           "nHeight"   => 64,;
                           "cResName"  => "gc_ok_64",;
                           "bLClicked" => {|| ::oSender:onViewSave() },;
                           "oWnd"      => ::oDlg } )

Return ( self )

//---------------------------------------------------------------------------//

METHOD validImporteCobro() CLASS ReceiptDocumentSalesViewEdit

   msgalert( ::getValue( "ImporteCobro" ), "ImporteCobro" )
   msgalert( ::getValue( "TotalDocumento" ), "TotalDocumento" )
   msgalert( ::nImporteOriginal, "nImporteOriginal" )

   if ::getValue( "ImporteCobro" ) > ::nImporteOriginal

      apoloMsgStop( "El importe del cobro excede al importe del recibo" )

      Return ( .f. )

   end if 

   if ::getValue( "TotalDocumento" ) < ::getValue( "ImporteCobro" ) 

      apoloMsgStop( "El importe del cobro excede al importe del recibo" )

      Return ( .f. )

   else 

      ::setValue( ::getValue( "TotalDocumento" ), "ImporteCobro" )

   end if 

/*
   if ::getValue( "ImporteCobro" ) <= ::getValue( "TotalDocumento" )

      if ( ::getValue( "ImporteCobro" ) != 0 ) .and. ( ::getValue( "TotalDocumento" ) != ::getValue( "ImporteCobro" ) )
         
         ::setValue( ( ::getValue( "TotalDocumento" ) - ::getValue( "ImporteCobro" ) ), "ImporteGastos" )

         ::oImporteGastos:Refresh()

      end if

      Return ( .t. )

   else

      apoloMsgStop( "El importe del cobro excede al importe del recibo" )

   end if
*/

Return ( .t. )

//---------------------------------------------------------------------------//