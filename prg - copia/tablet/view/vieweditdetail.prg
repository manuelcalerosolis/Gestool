#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Xbrowse.ch"

CLASS ViewDetail FROM ViewBase

   DATA oDlg
   DATA nMode
   DATA oSender

   DATA oGetArticulo
   DATA oGetDescripcionArticulo
   
   DATA oGetLote
   DATA oSayLote

   DATA oGetCajas
   DATA oGetUnidades
   DATA oGetPrecio
   DATA oGetDescuento
   DATA oGetDescuentoLineal

   DATA oTotalLinea
   
   METHOD New()

   METHOD Resource()

   METHOD SetGetValue( uValue, cName ) INLINE ( if (  Empty( uValue ),;
                                                      hGet( ::oSender:hDictionaryDetailTemporal, cName ),;
                                                      hSet( ::oSender:hDictionaryDetailTemporal, cName, uValue ) ) )

   METHOD defineAceptarCancelar()

   METHOD defineArticulo()

   METHOD defineLote()

   METHOD defineCajas()

   METHOD defineUnidades()

   METHOD definePrecio()

   METHOD defineDescuentoPorcentual()

   METHOD defineDescuentoLineal()

   METHOD defineTotal()

   METHOD ShowLote()    INLINE ( ::oGetLote:Show(), ::oSayLote:Show() )
   METHOD HideLote()    INLINE ( ::oGetLote:Hide(), ::oSayLote:Hide() )
   METHOD RefreshLote() INLINE ( ::oGetLote:Refresh() )

   METHOD RefreshGetArticulo()         INLINE ( ::oGetArticulo:Refresh() )
   METHOD RefreshGetDescripcion()      INLINE ( ::oGetDescripcionArticulo:Refresh() )
   METHOD RefreshGetLote()             INLINE ( ::oGetLote:Refresh() )
   METHOD RefreshGetCajas()            INLINE ( ::oGetCajas:Refresh() )
   METHOD RefreshGetUnidades()         INLINE ( ::oGetUnidades:Refresh() )
   METHOD RefreshGetPrecio()           INLINE ( ::oGetPrecio:Refresh() )
   METHOD RefreshGetDescuento()        INLINE ( ::oGetDescuento:Refresh() )
   METHOD RefreshGetDescuentoLineal()  INLINE ( ::oGetDescuentoLineal:Refresh() )

   METHOD RefreshDialog()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oSender ) CLASS ViewDetail

   ::oSender   := oSender

Return ( self )

//---------------------------------------------------------------------------//

METHOD Resource( nMode ) CLASS ViewDetail

   ::nMode  := nMode

   ::oDlg   := TDialog():New( 1, 5, 40, 100, "GESTOOL TABLET",,, .f., ::Style,, rgb( 255, 255, 255 ),,, .F.,, oGridFont(),,,, .f.,, "oDlg" )

   ::defineTitulo()

   ::defineArticulo()

   ::defineLote()

   ::defineCajas()

   ::defineUnidades()

   ::definePrecio()

   ::defineDescuentoPorcentual()

   ::defineDescuentoLineal()

   ::defineTotal()

   ::defineAceptarCancelar()

   ::oDlg:bResized         := {|| ::resizeDialog() }

   ::oDlg:bStart           := {|| ::HideLote(), ::oSender:StartResourceDetail() }

   ::oDlg:Activate( ,,,.t.,,, {|| ::InitDialog() } )

Return ( ::oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

METHOD defineAceptarCancelar() CLASS ViewDetail


   TGridImage():Build(  {  "nTop"      => 5,;
                           "nLeft"     => {|| GridWidth( 9.0, ::oDlg ) },;
                           "nWidth"    => 64,;
                           "nHeight"   => 64,;
                           "cResName"  => "flat_del_64",;
                           "bLClicked" => {|| ::oDlg:End() },;
                           "oWnd"      => ::oDlg } )

   TGridImage():Build(  {  "nTop"      => 5,;
                           "nLeft"     => {|| GridWidth( 10.5, ::oDlg ) },;
                           "nWidth"    => 64,;
                           "nHeight"   => 64,;
                           "cResName"  => "flat_check_64",;
                           "bLClicked" => {|| ::oDlg:End( IDOK ) },;
                           "oWnd"      => ::oDlg } )

Return ( self )

//---------------------------------------------------------------------------//

METHOD defineArticulo() CLASS ViewDetail

   TGridUrllink():Build({  "nTop"      => 40,;
                           "nLeft"     => {|| GridWidth( 0.5, ::oDlg ) },;
                           "cURL"      => "Artículo",;
                           "oWnd"      => ::oDlg,;
                           "oFont"     => oGridFont(),;
                           "lPixel"    => .t.,;
                           "nClrInit"  => nGridColor(),;
                           "nClrOver"  => nGridColor(),;
                           "nClrVisit" => nGridColor(),;
                           "bAction"   => {|| GridBrwArticulo( ::oGetArticulo, ::oGetDescripcionArticulo ) } } )

   ::oGetArticulo             := TGridGet():Build( {  "nRow"      => 40,;
                                                      "nCol"      => {|| GridWidth( 2.5, ::oDlg ) },;
                                                      "bSetGet"   => {|u| ::SetGetValue( u, "Articulo" ) },;
                                                      "oWnd"      => ::oDlg,;
                                                      "nWidth"    => {|| GridWidth( 3, ::oDlg ) },;
                                                      "nHeight"   => 23,;
                                                      "lPixels"   => .t.,;
                                                      "bValid"    => {|| ::oSender:CargaArticulo(), ::oSender:RecalculaLinea( ::oTotalLinea ) } } )
   
   ::oGetDescripcionArticulo  := TGridGet():Build( {  "nRow"      => 40,;
                                                      "nCol"      => {|| GridWidth( 5.5, ::oDlg ) },;
                                                      "bSetGet"   => {|u| ::SetGetValue( u, "DescripcionArticulo" ) },;
                                                      "oWnd"      => ::oDlg,;
                                                      "lPixels"   => .t.,;
                                                      "nWidth"    => {|| GridWidth( 6, ::oDlg ) },;
                                                      "nHeight"   => 23 } )

Return ( self )

//---------------------------------------------------------------------------//

METHOD defineLote() CLASS ViewDetail

   ::oSayLote                 := TGridSay():Build( {  "nRow"      => 65,;
                                                      "nCol"      => {|| GridWidth( 0.5, ::oDlg ) },;
                                                      "bText"     => {|| "Lote" },;
                                                      "oWnd"      => ::oDlg,;
                                                      "oFont"     => oGridFont(),;
                                                      "lPixels"   => .t.,;
                                                      "nClrText"  => Rgb( 0, 0, 0 ),;
                                                      "nClrBack"  => Rgb( 255, 255, 255 ),;
                                                      "nWidth"    => {|| GridWidth( 2, ::oDlg ) },;
                                                      "nHeight"   => 23,;
                                                      "lDesign"   => .f. } )

   ::oGetLote                 := TGridGet():Build( {  "nRow"      => 65,;
                                                      "nCol"      => {|| GridWidth( 2.5, ::oDlg ) },;
                                                      "bSetGet"   => {|u| ::SetGetValue( u, "Lote" ) },;
                                                      "oWnd"      => ::oDlg,;
                                                      "nWidth"    => {|| GridWidth( 3, ::oDlg ) },;
                                                      "nHeight"   => 23,;
                                                      "lPixels"   => .t. } )

Return ( self )

//---------------------------------------------------------------------------//

METHOD defineCajas() CLASS ViewDetail

   TGridSay():Build(    {  "nRow"      => 90,;
                           "nCol"      => {|| GridWidth( 0.5, ::oDlg ) },;
                           "bText"     => {|| "Cajas" },;
                           "oWnd"      => ::oDlg,;
                           "oFont"     => oGridFont(),;
                           "lPixels"   => .t.,;
                           "nClrText"  => Rgb( 0, 0, 0 ),;
                           "nClrBack"  => Rgb( 255, 255, 255 ),;
                           "nWidth"    => {|| GridWidth( 2, ::oDlg ) },;
                           "nHeight"   => 23,;
                           "lDesign"   => .f. } )

   ::oGetCajas    :=    TGridGet():Build( {  "nRow"      => 90,;
                                             "nCol"      => {|| GridWidth( 2.5, ::oDlg ) },;
                                             "bSetGet"   => {|u| ::SetGetValue( u, "Cajas" ) },;
                                             "oWnd"      => ::oDlg,;
                                             "lPixels"   => .t.,;
                                             "nWidth"    => {|| GridWidth( 3, ::oDlg ) },;
                                             "cPict"     => MasUnd(),;
                                             "lRight"    => .t.,;
                                             "nHeight"   => 23,;
                                             "bValid"    => {|| ::oSender:RecalculaLinea( ::oTotalLinea ) } } )

Return ( self )

//---------------------------------------------------------------------------//

METHOD defineUnidades() CLASS ViewDetail

   TGridSay():Build(    {  "nRow"      => 115,;
                           "nCol"      => {|| GridWidth( 0.5, ::oDlg ) },;
                           "bText"     => {|| "Unidades" },;
                           "oWnd"      => ::oDlg,;
                           "oFont"     => oGridFont(),;
                           "lPixels"   => .t.,;
                           "nClrText"  => Rgb( 0, 0, 0 ),;
                           "nClrBack"  => Rgb( 255, 255, 255 ),;
                           "nWidth"    => {|| GridWidth( 2, ::oDlg ) },;
                           "nHeight"   => 23,;
                           "lDesign"   => .f. } )

   ::oGetUnidades := TGridGet():Build( {  "nRow"      => 115,;
                                          "nCol"      => {|| GridWidth( 2.5, ::oDlg ) },;
                                          "bSetGet"   => {|u| ::SetGetValue( u, "Unidades" ) },;
                                          "oWnd"      => ::oDlg,;
                                          "lPixels"   => .t.,;
                                          "nWidth"    => {|| GridWidth( 3, ::oDlg ) },;
                                          "cPict"     => MasUnd(),;
                                          "lRight"    => .t.,;
                                          "nHeight"   => 23,;
                                          "bValid"    => {|| ::oSender:RecalculaLinea( ::oTotalLinea ) } } )

Return ( self )

//---------------------------------------------------------------------------//

METHOD definePrecio() CLASS ViewDetail

   TGridSay():Build(    {  "nRow"      => 140,;
                           "nCol"      => {|| GridWidth( 0.5, ::oDlg ) },;
                           "bText"     => {|| "Precio" },;
                           "oWnd"      => ::oDlg,;
                           "oFont"     => oGridFont(),;
                           "lPixels"   => .t.,;
                           "nClrText"  => Rgb( 0, 0, 0 ),;
                           "nClrBack"  => Rgb( 255, 255, 255 ),;
                           "nWidth"    => {|| GridWidth( 2, ::oDlg ) },;
                           "nHeight"   => 23,;
                           "lDesign"   => .f. } )

   ::oGetPrecio   := TGridGet():Build( {  "nRow"      => 140,;
                                          "nCol"      => {|| GridWidth( 2.5, ::oDlg ) },;
                                          "bSetGet"   => {|u| ::SetGetValue( u, "PrecioVenta" ) },;
                                          "oWnd"      => ::oDlg,;
                                          "lPixels"   => .t.,;
                                          "nWidth"    => {|| GridWidth( 3, ::oDlg ) },;
                                          "cPict"     => cPouDiv( hGet( ::oSender:hDictionaryMaster, "Divisa" ), D():Divisas( ::oSender:nView ) ),;
                                          "lRight"    => .t.,;
                                          "nHeight"   => 23,;
                                          "bValid"    => {|| ::oSender:RecalculaLinea( ::oTotalLinea ) } } )

Return ( self )

//---------------------------------------------------------------------------//

METHOD defineDescuentoPorcentual() CLASS ViewDetail

   TGridSay():Build( {  "nRow"      => 165,;
                        "nCol"      => {|| GridWidth( 0.5, ::oDlg ) },;
                        "bText"     => {|| "% Dto" },;
                        "oWnd"      => ::oDlg,;
                        "oFont"     => oGridFont(),;
                        "lPixels"   => .t.,;
                        "nClrText"  => Rgb( 0, 0, 0 ),;
                        "nClrBack"  => Rgb( 255, 255, 255 ),;
                        "nWidth"    => {|| GridWidth( 2, ::oDlg ) },;
                        "nHeight"   => 23,;
                        "lDesign"   => .f. } )

   ::oGetDescuento   := TGridGet():Build( {  "nRow"      => 165,;
                                             "nCol"      => {|| GridWidth( 2.5, ::oDlg ) },;
                                             "bSetGet"   => {|u| ::SetGetValue( u, "DescuentoPorcentual" ) },;
                                             "oWnd"      => ::oDlg,;
                                             "lPixels"   => .t.,;
                                             "nWidth"    => {|| GridWidth( 3, ::oDlg ) },;
                                             "cPict"     => "@E 999.99",;
                                             "lRight"    => .t.,;
                                             "nHeight"   => 23,;
                                             "bValid"    => {|| ::oSender:RecalculaLinea( ::oTotalLinea ) } } )

Return ( self )

//---------------------------------------------------------------------------//

METHOD defineDescuentoLineal() CLASS ViewDetail

   TGridSay():Build( {  "nRow"      => 190,;
                        "nCol"      => {|| GridWidth( 0.5, ::oDlg ) },;
                        "bText"     => {|| "Dto. lineal" },;
                        "oWnd"      => ::oDlg,;
                        "oFont"     => oGridFont(),;
                        "lPixels"   => .t.,;
                        "nClrText"  => Rgb( 0, 0, 0 ),;
                        "nClrBack"  => Rgb( 255, 255, 255 ),;
                        "nWidth"    => {|| GridWidth( 2, ::oDlg ) },;
                        "nHeight"   => 23,;
                        "lDesign"   => .f. } )

   ::oGetDescuentoLineal   := TGridGet():Build( {  "nRow"      => 190,;
                                                   "nCol"      => {|| GridWidth( 2.5, ::oDlg ) },;
                                                   "bSetGet"   => {|u| ::SetGetValue( u, "DescuentoLineal" ) },;
                                                   "oWnd"      => ::oDlg,;
                                                   "lPixels"   => .t.,;
                                                   "nWidth"    => {|| GridWidth( 3, ::oDlg ) },;
                                                   "cPict"     => cPouDiv( hGet( ::oSender:hDictionaryMaster, "Divisa" ), D():Divisas( ::oSender:nView ) ),;
                                                   "lRight"    => .t.,;
                                                   "nHeight"   => 23,;
                                                   "bValid"    => {|| ::oSender:RecalculaLinea( ::oTotalLinea ) } } )

Return ( self )

//---------------------------------------------------------------------------//

METHOD defineTotal() CLASS ViewDetail

   local nTotal   := 0

   TGridSay():Build( {  "nRow"      => 230,;
                        "nCol"      => {|| GridWidth( 0.5, ::oDlg ) },;
                        "bText"     => {|| "Total" },;
                        "oWnd"      => ::oDlg,;
                        "oFont"     => oGridFontBold(),;
                        "lPixels"   => .t.,;
                        "nClrText"  => Rgb( 0, 0, 0 ),;
                        "nClrBack"  => Rgb( 255, 255, 255 ),;
                        "nWidth"    => {|| GridWidth( 2, ::oDlg ) },;
                        "nHeight"   => 23,;
                        "lDesign"   => .f. } )

   ::oTotalLinea  := TGridGet():Build( {  "nRow"      => 230,;
                                          "nCol"      => {|| GridWidth( 2.5, ::oDlg ) },;
                                          "bSetGet"   => {|u| if( PCount() == 0, nTotal, nTotal := u ) },;
                                          "oWnd"      => ::oDlg,;
                                          "lPixels"   => .t.,;
                                          "nWidth"    => {|| GridWidth( 3, ::oDlg ) },;
                                          "cPict"     => cPouDiv( hGet( ::oSender:hDictionaryMaster, "Divisa" ), D():Divisas( ::oSender:nView ) ),;
                                          "lRight"    => .t.,;
                                          "nHeight"   => 23,;
                                          "bWhen"     => {|| .f. } } )

Return ( self )

//---------------------------------------------------------------------------//

METHOD RefreshDialog() CLASS ViewDetail

   ::RefreshGetArticulo()
   ::RefreshGetDescripcion()
   ::RefreshGetLote()
   ::RefreshGetCajas()
   ::RefreshGetUnidades()
   ::RefreshGetPrecio()
   ::RefreshGetDescuento()
   ::RefreshGetDescuentoLineal()

Return ( Self )

//---------------------------------------------------------------------------//