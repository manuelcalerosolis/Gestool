#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Xbrowse.ch"

CLASS ReindexaView FROM ViewBase

   DATA oMeterSistema
   DATA nMeterSistema
   DATA oMeterEmpresa
   DATA nMeterEmpresa
   DATA oMeterSincronizacion
   DATA nMeterSincronizacion
   DATA oSayInformacion

   METHOD New()

   METHOD insertControls()

   METHOD defineAceptarCancelar()

   METHOD defineMeter

   METHOD getTitleTipoDocumento()   INLINE ( ::getTextoTipoDocumento() )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oSender ) CLASS ReindexaView

   ::oSender               := oSender

   ::nMeterSistema         := 0
   ::nMeterEmpresa         := 0
   ::nMeterSincronizacion  := 0
   
Return ( self )

//---------------------------------------------------------------------------//

METHOD insertControls() CLASS ReindexaView

   ::defineMeter()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD defineMeter() CLASS ReindexaView


   TGridSay():Build(    {  "nRow"      => 55,;
                           "nCol"      => {|| GridWidth( 0.5, ::oDlg ) },;
                           "bText"     => {|| "Ficheros del sistema" },;
                           "oWnd"      => ::oDlg,;
                           "oFont"     => oGridFont(),;
                           "lPixels"   => .t.,;
                           "nClrText"  => Rgb( 0, 0, 0 ),;
                           "nClrBack"  => Rgb( 255, 255, 255 ),;
                           "nWidth"    => {|| GridWidth( 2.5, ::oDlg ) },;
                           "nHeight"   => 23,;
                           "lDesign"   => .f. } )

   ::oMeterSistema         := TGridMeter():Build( {   "nRow"            => 55,;
                                                      "nCol"            => {|| GridWidth( 3.5, ::oDlg ) },;
                                                      "bSetGet"         => {|u| if( PCount() == 0, ::nMeterSistema, ::nMeterSistema := u ) },;
                                                      "oWnd"            => ::oDlg,;
                                                      "nWidth"          => {|| GridWidth( 8.5, ::oDlg ) },;
                                                      "nHeight"         => 20,;
                                                      "lPixel"          => .t.,;
                                                      "lUpdate"         => .t.,;
                                                      "lNoPercentage"   => .t.,;
                                                      "nClrPane"        => rgb( 255,255,255 ),;
                                                      "nClrBar"         => rgb( 128,255,0 ) } )

   TGridSay():Build(    {  "nRow"      => 90,;
                           "nCol"      => {|| GridWidth( 0.5, ::oDlg ) },;
                           "bText"     => {|| "Ficheros de empresa" },;
                           "oWnd"      => ::oDlg,;
                           "oFont"     => oGridFont(),;
                           "lPixels"   => .t.,;
                           "nClrText"  => Rgb( 0, 0, 0 ),;
                           "nClrBack"  => Rgb( 255, 255, 255 ),;
                           "nWidth"    => {|| GridWidth( 2.5, ::oDlg ) },;
                           "nHeight"   => 23,;
                           "lDesign"   => .f. } )

   ::oMeterEmpresa         := TGridMeter():Build( {   "nRow"            => 90,;
                                                      "nCol"            => {|| GridWidth( 3.5, ::oDlg ) },;
                                                      "bSetGet"         => {|u| if( PCount() == 0, ::nMeterEmpresa, ::nMeterEmpresa := u ) },;
                                                      "oWnd"            => ::oDlg,;
                                                      "nWidth"          => {|| GridWidth( 8.5, ::oDlg ) },;
                                                      "nHeight"         => 20,;
                                                      "lPixel"          => .t.,;
                                                      "lUpdate"         => .t.,;
                                                      "lNoPercentage"   => .t.,;
                                                      "nClrPane"        => rgb( 255,255,255 ),;
                                                      "nClrBar"         => rgb( 128,255,0 ) } )

   TGridSay():Build(    {  "nRow"      => 125,;
                           "nCol"      => {|| GridWidth( 0.5, ::oDlg ) },;
                           "bText"     => {|| "Sincronización información" },;
                           "oWnd"      => ::oDlg,;
                           "oFont"     => oGridFont(),;
                           "lPixels"   => .t.,;
                           "nClrText"  => Rgb( 0, 0, 0 ),;
                           "nClrBack"  => Rgb( 255, 255, 255 ),;
                           "nWidth"    => {|| GridWidth( 2.5, ::oDlg ) },;
                           "nHeight"   => 23,;
                           "lDesign"   => .f. } )

   ::oMeterSincronizacion  := TGridMeter():Build( {   "nRow"            => 125,;
                                                      "nCol"            => {|| GridWidth( 3.5, ::oDlg ) },;
                                                      "bSetGet"         => {|u| if( PCount() == 0, ::nMeterSincronizacion, ::nMeterSincronizacion := u ) },;
                                                      "oWnd"            => ::oDlg,;
                                                      "nWidth"          => {|| GridWidth( 8.5, ::oDlg ) },;
                                                      "nHeight"         => 20,;
                                                      "lPixel"          => .t.,;
                                                      "lUpdate"         => .t.,;
                                                      "lNoPercentage"   => .t.,;
                                                      "nClrPane"        => rgb( 255,255,255 ),;
                                                      "nClrBar"         => rgb( 128,255,0 ) } )

   ::oSayInformacion       := TGridSay():Build(    {  "nRow"      => 160,;
                                                      "nCol"      => {|| GridWidth( 0.5, ::oDlg ) },;
                                                      "bText"     => {|| "" },;
                                                      "oWnd"      => ::oDlg,;
                                                      "oFont"     => oGridFont(),;
                                                      "lPixels"   => .t.,;
                                                      "nClrText"  => Rgb( 0, 0, 0 ),;
                                                      "nClrBack"  => Rgb( 255, 255, 255 ),;
                                                      "nWidth"    => {|| GridWidth( 11.5, ::oDlg ) },;
                                                      "nHeight"   => 23,;
                                                      "lDesign"   => .f.,;
                                                      "lCentered" => .t. } )


Return ( Self )

//---------------------------------------------------------------------------//

METHOD defineAceptarCancelar() CLASS ReindexaView
   
   TGridImage():Build(  {  "nTop"      => 5,;
                           "nLeft"     => {|| GridWidth( 9.0, ::oDlg ) },;
                           "nWidth"    => 64,;
                           "nHeight"   => 64,;
                           "cResName"  => "gc_error_64",;
                           "bLClicked" => {|| ::oDlg:End() },;
                           "oWnd"      => ::oDlg } )

   TGridImage():Build(  {  "nTop"      => 5,;
                           "nLeft"     => {|| GridWidth( 10.5, ::oDlg ) },;
                           "nWidth"    => 64,;
                           "nHeight"   => 64,;
                           "cResName"  => "gc_ok_64",;
                           "bLClicked" => {|| ::oSender:runReindexa(), ::oDlg:End() },;
                           "oWnd"      => ::oDlg } )

Return ( self )

//---------------------------------------------------------------------------//