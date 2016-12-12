#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Xbrowse.ch"

CLASS CustomerSalesViewSearchNavigator FROM DocumentSalesViewSearchNavigator

   DATA oSayFilter

   METHOD getDataTable()                  INLINE ( "FacCliT" )
   METHOD getWorkArea()                   INLINE ( D():FacturasClientes( ::getView() ) )

   METHOD botonesAcciones()

   METHOD getTitleDocumento()             INLINE ( "Facturas cliente" )

   METHOD ChangeFilter()

END CLASS

//---------------------------------------------------------------------------//

METHOD botonesAcciones()   CLASS CustomerSalesViewSearchNavigator


   TGridImage():Build(  {  "nTop"      => 75,;
                           "nLeft"     => {|| GridWidth( 0.5, ::oDlg ) },;
                           "nWidth"    => 64,;
                           "nHeight"   => 64,;
                           "cResName"  => "gc_safe_into_64",;
                           "bLClicked" => {|| MsgInfo( "Meto la entrega a cuenta" ) },;
                           "oWnd"      => ::oDlg } )

   TGridImage():Build(  {  "nTop"      => 75,;
                           "nLeft"     => {|| GridWidth( 1.5, ::oDlg ) },;
                           "nWidth"    => 64,;
                           "nHeight"   => 64,;
                           "cResName"  => "gc_funnel_64",;
                           "bLClicked" => {|| ::ChangeFilter() },;
                           "oWnd"      => ::oDlg } )

   ::oSayFilter  := TGridSay():Build(  {  "nRow"      => 75,;
                                          "nCol"      => {|| GridWidth( 3, ::oDlg ) },;
                                          "bText"     => {|| "" },;
                                          "oWnd"      => ::oDlg,;
                                          "oFont"     => oGridFont(),;
                                          "lPixels"   => .t.,;
                                          "nClrText"  => Rgb( 0, 0, 0 ),;
                                          "nClrBack"  => Rgb( 255, 255, 255 ),;
                                          "nWidth"    => {|| GridWidth( 3, ::oDlg ) },;
                                          "nHeight"   => 23,;
                                          "lDesign"   => .f. } )

   ::oDlg:bStart     := {|| ::ChangeFilter() }

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD ChangeFilter() CLASS CustomerSalesViewSearchNavigator

   local cText    := ""

   do case
      case ::oSayFilter:cCaption == ""
         cText    := "Pendientes"

      case ::oSayFilter:cCaption == "Cobradas"
         cText    := "Todas"

      case ::oSayFilter:cCaption == "Pendientes"
         cText    := "Cobradas"

      case ::oSayFilter:cCaption == "Todas"
         cText    := "Pendientes"

   end case

   ::oSayFilter:VarPut( cText )
   ::oSayFilter:Refresh()   

   ::oSender:FilterSalesCustomerTable( ::oSayFilter:cCaption )

Return ( .t. )

//---------------------------------------------------------------------------//