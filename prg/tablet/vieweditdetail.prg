#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Xbrowse.ch"

CLASS ViewDetail FROM ViewBase

   DATA oDlg
   DATA nMode
   DATA oSender

   DATA oGetArticulo
   DATA oGetDescripcionArticulo

   DATA oTotalLinea
   
   METHOD New()

   METHOD ResourceViewEditDetail()

   METHOD SetGetValue( uValue, cName ) INLINE ( if (  Empty( uValue ),;
                                                      hGet( ::oSender:hDictionaryDetailTemporal, cName ),;
                                                      hSet( ::oSender:hDictionaryDetailTemporal, cName, uValue ) ) )

   METHOD BotonAceptarCancelarBrowse()

   METHOD defineArticulo()

   METHOD defineLote()

   METHOD defineCajas()

   METHOD defineUnidades()

   METHOD definePrecio()

   METHOD defineDescuentoPorcentual()

   METHOD defineDescuentoLineal()

   METHOD defineTotal()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oSender ) CLASS ViewDetail

   ::oSender   := oSender

Return ( self )

//---------------------------------------------------------------------------//

METHOD ResourceViewEditDetail( nMode ) CLASS ViewDetail

   ::nMode  := nMode

   ::oDlg   := TDialog():New( 1, 5, 40, 100, "GESTOOL TABLET",,, .f., ::Style,, rgb( 255, 255, 255 ),,, .F.,, oGridFont(),,,, .f.,, "oDlg" )

   ::TituloBrowse()

   ::defineArticulo()

   ::defineLote()

   ::defineCajas()

   ::defineUnidades()

   ::definePrecio()

   ::defineDescuentoPorcentual()

   ::defineDescuentoLineal()

   ::defineTotal()

   ::BotonAceptarCancelarBrowse()

   ::oDlg:bResized         := {|| ::DialogResize() }

   ::oDlg:bStart           := {|| ::oSender:RecalculaLinea( ::oTotalLinea ) }

   ::oDlg:Activate( ,,,.t.,,, {|| ::InitDialog() } )

Return ( ::oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

METHOD BotonAceptarCancelarBrowse() CLASS ViewDetail


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
                                                      "bValid"    => {|| .t. } } ) //LoaArt( aTmp[ _CREF ], aGet, aTmp, aTmpFac,,,,,,, nMode, , oSayLote ), lCalcDeta( aTmp, aTmpFac ) } } )
   
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

   TGridSay():Build(    {  "nRow"      => 65,;
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

   TGridGet():Build( {     "nRow"      => 65,;
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

   TGridGet():Build( {     "nRow"      => 90,;
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

   TGridGet():Build( {     "nRow"      => 115,;
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

   TGridGet():Build( {     "nRow"      => 140,;
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

   TGridGet():Build( {  "nRow"      => 165,;
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

   TGridGet():Build( {  "nRow"      => 190,;
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