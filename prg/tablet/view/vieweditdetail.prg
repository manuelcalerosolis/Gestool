#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Xbrowse.ch"

#define __rowDistance__                      25

//---------------------------------------------------------------------------//

CLASS ViewDetail FROM ViewBase

   DATA oDlg
   DATA nMode
   DATA oSender

   DATA oGetArticulo
   DATA ogetDescriptionArticle
   
   DATA oGetLote
   DATA oSayLote

   DATA oGetCajas
   DATA oGetUnidades
   DATA oGetPrecio
   DATA oGetDescuento
   DATA oGetDescuentoLineal
   DATA oSayAlmacen
   DATA oGetAlmacen
   DATA oGetNombreAlmacen
   DATA textNombreAlmacen

   DATA oTotalLinea
  
   METHOD New()

   METHOD Resource()
   METHOD getSenderDocument()                INLINE   ( ::oSender:getSender() )

   METHOD setGetValue( uValue, cFieldName )  INLINE   ( if( isNil( uValue ), ::getValue( cFieldName ), ::setValue( uValue, cFieldName ) ) )
      METHOD getValue( cFieldName )          INLINE   ( hGet( ::getSenderDocument():oDocumentLineTemporal:hDictionary, cFieldName ) )
      METHOD setValue( uValue, cFieldName )  INLINE   ( hSet( ::getSenderDocument():oDocumentLineTemporal:hDictionary, cFieldName, uValue ) ) 

   METHOD getChangePrecio()                  INLINE   ( ::Super:getChangePrecio() .or. ::getValue( "PrecioVenta" ) == 0 )

   METHOD defineAceptarCancelar()
   METHOD defineArticulo()
   METHOD defineLote()
   METHOD defineCajas()
   METHOD defineUnidades()
   METHOD definePrecio()
   METHOD defineDescuentoPorcentual()
   METHOD defineDescuentoLineal()
   METHOD defineTotal()
   METHOD defineAlmacen()

   METHOD showLote()                         INLINE ( ::oGetLote:Show(), ::oSayLote:Show() )
   METHOD hideLote()                         INLINE ( ::oGetLote:Hide(), ::oSayLote:Hide() )
   METHOD refreshLote()                      INLINE ( ::oGetLote:Refresh() )

   METHOD refreshGetArticulo()               INLINE ( ::oGetArticulo:Refresh() )
   METHOD refreshGetDescripcion()            INLINE ( ::ogetDescriptionArticle:Refresh() )
   METHOD refreshGetLote()                   INLINE ( ::oGetLote:Refresh() )
   METHOD refreshGetCajas()                  INLINE ( ::oGetCajas:Refresh() )
   METHOD refreshGetUnidades()               INLINE ( ::oGetUnidades:Refresh() )
   METHOD refreshGetPrecio()                 INLINE ( ::oGetPrecio:Refresh() )
   METHOD refreshGetDescuento()              INLINE ( ::oGetDescuento:Refresh() )
   METHOD refreshGetDescuentoLineal()        INLINE ( ::oGetDescuentoLineal:Refresh() )
   METHOD refreshGetAlmacen()                INLINE ( ::oGetAlmacen:Refresh() )

   METHOD RefreshDialog()
      METHOD startDialog()

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

   ::defineAlmacen()

   ::defineAceptarCancelar()

   ::oDlg:bResized         := {|| ::resizeDialog() }

   ::oDlg:bStart           := {|| ::startDialog() }

   ::oDlg:Activate( ,,,.t.,,, {|| ::initDialog() } )

   ::oSender:resetOldCodigoArticulo()

Return ( ::oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

METHOD startDialog() CLASS ViewDetail

   ::hideLote()

   ::oGetArticulo:SetFocus()

   ::oSender:StartResourceDetail()

Return( Self )

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

   TGridUrllink():Build(                           {  "nTop"      => ::getRow(),;
                                                      "nLeft"     => {|| GridWidth( 0.5, ::oDlg ) },;
                                                      "cURL"      => "Art�culo",;
                                                      "oWnd"      => ::oDlg,;
                                                      "oFont"     => oGridFont(),;
                                                      "lPixel"    => .t.,;
                                                      "nClrInit"  => nGridColor(),;
                                                      "nClrOver"  => nGridColor(),;
                                                      "nClrVisit" => nGridColor(),;
                                                      "bAction"   => {|| ::oSender:runGridProduct() } } )

   ::oGetArticulo             := TGridGet():Build( {  "nRow"      => ::getRow(),;
                                                      "nCol"      => {|| GridWidth( 2.5, ::oDlg ) },;
                                                      "bSetGet"   => {|u| ::SetGetValue( u, "Articulo" ) },;
                                                      "oWnd"      => ::oDlg,;
                                                      "nWidth"    => {|| GridWidth( 3, ::oDlg ) },;
                                                      "nHeight"   => 23,;
                                                      "lPixels"   => .t.,;
                                                      "bValid"    => {|| ::oSender:CargaArticulo() } } )
   
   ::ogetDescriptionArticle  := TGridGet():Build( {  "nRow"      => ::getRow(),;
                                                      "nCol"      => {|| GridWidth( 5.5, ::oDlg ) },;
                                                      "bSetGet"   => {|u| ::SetGetValue( u, "DescripcionArticulo" ) },;
                                                      "oWnd"      => ::oDlg,;
                                                      "lPixels"   => .t.,;
                                                      "nWidth"    => {|| GridWidth( 6, ::oDlg ) },;
                                                      "nHeight"   => 23 } )

   ::nextRow()

Return ( self )

//---------------------------------------------------------------------------//

METHOD defineLote() CLASS ViewDetail

   ::oSayLote                 := TGridSay():Build( {  "nRow"      => ::getRow(),;
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

   ::oGetLote                 := TGridGet():Build( {  "nRow"      => ::getRow(),;
                                                      "nCol"      => {|| GridWidth( 2.5, ::oDlg ) },;
                                                      "bSetGet"   => {|u| ::SetGetValue( u, "Lote" ) },;
                                                      "oWnd"      => ::oDlg,;
                                                      "nWidth"    => {|| GridWidth( 3, ::oDlg ) },;
                                                      "nHeight"   => 23,;
                                                      "lPixels"   => .t. } )

   ::nextRow()

Return ( self )

//---------------------------------------------------------------------------//

METHOD defineCajas() CLASS ViewDetail

   TGridSay():Build(                      {  "nRow"      => ::getRow(),;
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

   ::oGetCajas    :=    TGridGet():Build( {  "nRow"      => ::getRow(),;
                                             "nCol"      => {|| GridWidth( 2.5, ::oDlg ) },;
                                             "bSetGet"   => {|u| ::SetGetValue( u, "Cajas" ) },;
                                             "oWnd"      => ::oDlg,;
                                             "lPixels"   => .t.,;
                                             "nWidth"    => {|| GridWidth( 3, ::oDlg ) },;
                                             "cPict"     => MasUnd(),;
                                             "lRight"    => .t.,;
                                             "nHeight"   => 23,;
                                             "bValid"    => {|| ::oSender:recalcularTotal() } } )

   ::nextRow()

Return ( self )

//---------------------------------------------------------------------------//

METHOD defineUnidades() CLASS ViewDetail

   TGridSay():Build(                   {  "nRow"      => ::getRow(),;
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

   ::oGetUnidades := TGridGet():Build( {  "nRow"      => ::getRow(),;
                                          "nCol"      => {|| GridWidth( 2.5, ::oDlg ) },;
                                          "bSetGet"   => {|u| ::SetGetValue( u, "Unidades" ) },;
                                          "oWnd"      => ::oDlg,;
                                          "lPixels"   => .t.,;
                                          "nWidth"    => {|| GridWidth( 3, ::oDlg ) },;
                                          "cPict"     => MasUnd(),;
                                          "lRight"    => .t.,;
                                          "nHeight"   => 23,;
                                          "bWhen"     => {|| accessCode():lUnitsModify },;
                                          "bValid"    => {|| ::oSender:recalcularTotal() } } )

   ::nextRow()

Return ( self )

//---------------------------------------------------------------------------//

METHOD definePrecio() CLASS ViewDetail

   TGridSay():Build(                   {  "nRow"      => ::getRow(),;
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
               
   ::oGetPrecio   := TGridGet():Build( {  "nRow"      => ::getRow(),;
                                          "nCol"      => {|| GridWidth( 2.5, ::oDlg ) },;
                                          "bSetGet"   => {|u| ::SetGetValue( u, "PrecioVenta" ) },;
                                          "oWnd"      => ::oDlg,;
                                          "lPixels"   => .t.,;
                                          "nWidth"    => {|| GridWidth( 3, ::oDlg ) },;
                                          "cPict"     => cPouDiv( hGet( ::getSenderDocument():hDictionaryMaster, "Divisa" ), D():Divisas( ::oSender:getView( ) ) ),;
                                          "lRight"    => .t.,;
                                          "nHeight"   => 23,;
                                          "bWhen"     => {|| ::getChangePrecio() },;
                                          "bValid"    => {|| ::oSender:recalcularTotal() } } )  

   ::nextRow()

Return ( self )

//---------------------------------------------------------------------------//

METHOD defineDescuentoPorcentual() CLASS ViewDetail

   TGridSay():Build(                      {  "nRow"      => ::getRow(),;
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

   ::oGetDescuento   := TGridGet():Build( {  "nRow"      => ::getRow(),;
                                             "nCol"      => {|| GridWidth( 2.5, ::oDlg ) },;
                                             "bSetGet"   => {|u| ::SetGetValue( u, "DescuentoPorcentual" ) },;
                                             "oWnd"      => ::oDlg,;
                                             "lPixels"   => .t.,;
                                             "nWidth"    => {|| GridWidth( 3, ::oDlg ) },;
                                             "cPict"     => "@E 999.99",;
                                             "lRight"    => .t.,;
                                             "nHeight"   => 23,;
                                             "bWhen"     => {|| ::getChangePrecio() },;
                                             "bValid"    => {|| ::oSender:recalcularTotal() } } )

   ::nextRow()

Return ( self )

//---------------------------------------------------------------------------//

METHOD defineDescuentoLineal() CLASS ViewDetail

   TGridSay():Build(                            {  "nRow"      => ::getRow(),;
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

   ::oGetDescuentoLineal   := TGridGet():Build( {  "nRow"      => ::getRow(),;
                                                   "nCol"      => {|| GridWidth( 2.5, ::oDlg ) },;
                                                   "bSetGet"   => {|u| ::SetGetValue( u, "DescuentoLineal" ) },;
                                                   "oWnd"      => ::oDlg,;
                                                   "lPixels"   => .t.,;
                                                   "nWidth"    => {|| GridWidth( 3, ::oDlg ) },;
                                                   "cPict"     => cPouDiv( hGet( ::getSenderDocument():hDictionaryMaster, "Divisa" ), D():Divisas( ::oSender:getView() ) ),;
                                                   "lRight"    => .t.,;
                                                   "nHeight"   => 23,;
                                                   "bWhen"     => {|| ::getChangePrecio() },;
                                                   "bValid"    => {|| ::oSender:recalcularTotal() } } )

   ::nextRow()

Return ( self )

//---------------------------------------------------------------------------//

METHOD defineTotal() CLASS ViewDetail

   local nTotal   := 0

   TGridSay():Build(                   {  "nRow"      => ::getRow(),;
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

   ::oTotalLinea  := TGridGet():Build( {  "nRow"      => ::getRow(),;
                                          "nCol"      => {|| GridWidth( 2.5, ::oDlg ) },;
                                          "bSetGet"   => {|u| if( PCount() == 0, nTotal, nTotal := u ) },;
                                          "oWnd"      => ::oDlg,;
                                          "lPixels"   => .t.,;
                                          "nWidth"    => {|| GridWidth( 3, ::oDlg ) },;
                                          "cPict"     => cPouDiv( hGet( ::getSenderDocument():hDictionaryMaster, "Divisa" ), D():Divisas( ::oSender:getView() ) ),;
                                          "lRight"    => .t.,;
                                          "nHeight"   => 23,;
                                          "bWhen"     => {|| .f. } } )

   ::nextRow()

Return ( self )

//---------------------------------------------------------------------------//

METHOD defineAlmacen() CLASS ViewDetail

   TGridUrllink():Build(                           {  "nTop"      => ::getRow(),;
                                                      "nLeft"     => {|| GridWidth( 0.5, ::oDlg ) },;
                                                      "cURL"      => "Almac�n",;
                                                      "oWnd"      => ::oDlg,;
                                                      "oFont"     => oGridFont(),;
                                                      "lPixel"    => .t.,;
                                                      "nClrInit"  => nGridColor(),;
                                                      "nClrOver"  => nGridColor(),;
                                                      "nClrVisit" => nGridColor(),;
                                                      "bAction"   => {|| ::oSender:runGridStore() } } )

   ::oGetAlmacen              := TGridGet():Build( {  "nRow"      => ::getRow(),;
                                                      "nCol"      => {|| GridWidth( 2.5, ::oDlg ) },;
                                                      "bSetGet"   => {|u| ::SetGetValue( u, "Almacen" ) },;
                                                      "oWnd"      => ::oDlg,;
                                                      "nWidth"    => {|| GridWidth( 3, ::oDlg ) },;
                                                      "nHeight"   => 23,;
                                                      "lPixels"   => .t.,;
                                                      "bValid"    => {|| ::oSender:CargaAlmacen() } } )

   ::oGetNombreAlmacen        := TGridGet():Build( {  "nRow"      => ::getRow(),;
                                                      "nCol"      => {|| GridWidth( 5.5, ::oDlg ) },;
                                                      "bSetGet"   => {|u| if( PCount() == 0, ::textNombreAlmacen, ::textNombreAlmacen := u ) },;
                                                      "oWnd"      => ::oDlg,;
                                                      "nWidth"    => {|| GridWidth( 6, ::oDlg ) },;
                                                      "lPixels"   => .t.,;
                                                      "bWhen"     => {|| .f. },;                           
                                                      "nHeight"   => 23 } )

   ::nextRow()

Return ( self )

//---------------------------------------------------------------------------//


METHOD RefreshDialog() CLASS ViewDetail

   ::refreshGetArticulo()
   ::refreshGetDescripcion()
   ::refreshGetLote()
   ::refreshGetCajas()
   ::refreshGetUnidades()
   ::refreshGetPrecio()
   ::refreshGetDescuento()
   ::refreshGetDescuentoLineal()
   ::refreshGetAlmacen()

Return ( Self )

//---------------------------------------------------------------------------//

