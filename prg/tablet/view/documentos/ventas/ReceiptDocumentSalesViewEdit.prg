#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Xbrowse.ch"

CLASS ReceiptDocumentSalesViewEdit FROM ViewEdit  
  
   METHOD New()

   METHOD insertControls()

   METHOD StartDialog()                  INLINE ( Self )

   METHOD defineFechaExpedicion( nRow )
   METHOD defineFechaVencimiento( nRow )

   METHOD defineImporte( nRow )   

   METHOD defineCliente( nRow )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oSender ) CLASS ReceiptDocumentSalesViewEdit

   ::oSender   := oSender

Return ( self )

//---------------------------------------------------------------------------//

METHOD insertControls() CLASS ReceiptDocumentSalesViewEdit

   ::defineFechaExpedicion()
   ::defineFechaVencimiento()

   ::defineImporte()

   ::defineCliente()

Return ( self )

//---------------------------------------------------------------------------//

METHOD defineCliente( nRow ) CLASS ReceiptDocumentSalesViewEdit

   DEFAULT nRow         := 150

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

   ::getCodigoCliente   := TGridGet():Build( {  "nRow"      => nRow,;
                                                "nCol"      => {|| GridWidth( 2.5, ::oDlg ) },;
                                                "bSetGet"   => {|u| ::SetGetValue( u, "Cliente" ) },;
                                                "oWnd"      => ::oDlg,;
                                                "nWidth"    => {|| GridWidth( 2.5, ::oDlg ) },;
                                                "nHeight"   => 23,;
                                                "lPixels"   => .t.,;
                                                "bWhen"     => {|| .f. },;
                                                "bValid"    => {|| .t. } } )
   
   ::oNombreCliente     := TGridGet():Build( {  "nRow"      => nRow,;
                                                "nCol"      => {|| GridWidth( 5, ::oDlg ) },;
                                                "bSetGet"   => {|u| ::SetGetValue( u, "NombreCliente" ) },;
                                                "oWnd"      => ::oDlg,;
                                                "lPixels"   => .t.,;
                                                "nWidth"    => {|| GridWidth( 5, ::oDlg ) },;
                                                "nHeight"   => 23,;
                                                "bWhen"     => {|| .f. } } )

Return ( self )

//---------------------------------------------------------------------------//

METHOD defineFechaExpedicion( nRow ) CLASS ReceiptDocumentSalesViewEdit

   DEFAULT nRow         := 75

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

   DEFAULT nRow         := 100

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

   DEFAULT nRow         := 125

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
                           "bWhen"     => {|| .f. },;
                           "bValid"    => {|| .t. } } )

Return ( self )

//---------------------------------------------------------------------------//