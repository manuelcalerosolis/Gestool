#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Xbrowse.ch"

CLASS ClienteIncidenciaView FROM ViewBase
  
   METHOD New()

   METHOD insertControls()

   METHOD defineNombre()

   METHOD defineFecha()

   METHOD defineFechaHora()

   METHOD defineIncidencia()

   METHOD defineCombo()

   METHOD getTextoTipoDocumento()      INLINE ( lblTitle( ::getMode() ) + "incidencia" )    

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oSender ) CLASS ClienteIncidenciaView

   ::oSender               := oSender

Return ( self )

//---------------------------------------------------------------------------//

METHOD insertControls( nMode ) CLASS ClienteIncidenciaView

   ::defineNombre()

   ::defineCombo()

   ::defineFechaHora()

Return ( self )

//---------------------------------------------------------------------------//

METHOD defineCombo() CLASS ClienteIncidenciaView

   TGridSay():Build( {  "nRow"      => 130,;
                        "nCol"      => {|| GridWidth( ::columnLabel, ::oDlg ) },;
                        "bText"     => {|| "Tipo" },;
                        "oWnd"      => ::oDlg,;
                        "oFont"     => oGridFont(),;
                        "lPixels"   => .t.,;
                        "nClrText"  => Rgb( 0, 0, 0 ),;
                        "nClrBack"  => Rgb( 255, 255, 255 ),;
                        "nWidth"    => {|| GridWidth( ::widthLabel, ::oDlg ) },;
                        "nHeight"   => 23 } )

   TGridComboBox():Build(  {  "nRow"      => 130,;
                              "nCol"      => {|| GridWidth( 2.5, ::oDlg ) },;
                              "bSetGet"   => {|u| iif( empty( u ), ::oSender:cNombreIncidencia, ::oSender:cNombreIncidencia := u ) },;
                              "oWnd"      => ::oDlg,;
                              "nWidth"    => {|| GridWidth( 9, ::oDlg ) },;
                              "nHeight"   => 25,;
                              "aItems"    => D():getTiposIncicencias( ::getView() ) } )

Return ( self )

//---------------------------------------------------------------------------//

METHOD defineNombre() CLASS ClienteIncidenciaView

   TGridSay():Build( {  "nRow"      => 40,;
                        "nCol"      => {|| GridWidth( ::columnLabel, ::oDlg ) },;
                        "bText"     => {|| "Incidencia" },;
                        "oWnd"      => ::oDlg,;
                        "oFont"     => oGridFont(),;
                        "lPixels"   => .t.,;
                        "nClrText"  => Rgb( 0, 0, 0 ),;
                        "nClrBack"  => Rgb( 255, 255, 255 ),;
                        "nWidth"    => {|| GridWidth( ::widthLabel, ::oDlg ) },;
                        "nHeight"   => 23 } )

   TGridMultiGet():Build(  {  "nRow"      => 40,;
                              "nCol"      => {|| GridWidth( 2.5, ::oDlg ) },;
                              "bSetGet"   => {|u| ::SetGetValue( u, "Nombre" ) },;
                              "oWnd"      => ::oDlg,;
                              "nWidth"    => {|| GridWidth( 9, ::oDlg ) },;
                              "nHeight"   => 50,;
                              "cPict"     => "@!",;
                              "lPixels"   => .t. } )

Return ( self )

//---------------------------------------------------------------------------//

METHOD defineFecha() CLASS ClienteIncidenciaView

   TGridUrllink():Build(   {  "nTop"      => 100,;
                              "nCol"      => {|| GridWidth( ::columnLabel, ::oDlg ) },;
                              "cURL"      => "Fecha",;
                              "oWnd"      => ::oDlg,;
                              "oFont"     => oGridFont(),;
                              "lPixel"    => .t.,;
                              "nClrInit"  => nGridColor(),;
                              "nClrOver"  => nGridColor(),;
                              "nClrVisit" => nGridColor() } )

   TGridGet():Build(    {  "nRow"      => 100,;
                           "nCol"      => {|| GridWidth( 2.5, ::oDlg ) },;
                           "bSetGet"   => {|u| ::SetGetValue( u, "Fecha" ) },;
                           "oWnd"      => ::oDlg,;
                           "nWidth"    => {|| GridWidth( 2.0, ::oDlg ) },;
                           "nHeight"   => 25,;
                           "lPixels"   => .t. } )

Return ( self )

//---------------------------------------------------------------------------//

METHOD defineFechaHora() CLASS ClienteIncidenciaView

   TGridSay():Build( {  "nRow"      => 100,;
                        "nCol"      => {|| GridWidth( ::columnLabel, ::oDlg ) },;
                        "bText"     => {|| "Fecha" },;
                        "oWnd"      => ::oDlg,;
                        "oFont"     => oGridFont(),;
                        "lPixels"   => .t.,;
                        "nClrText"  => Rgb( 0, 0, 0 ),;
                        "nClrBack"  => Rgb( 255, 255, 255 ),;
                        "nWidth"    => {|| GridWidth( ::widthLabel, ::oDlg ) },;
                        "nHeight"   => 23 } )

   TGridGet():Build( {  "nRow"      => 100,;
                        "nCol"      => {|| GridWidth( 2.5, ::oDlg ) },;
                        "bSetGet"   => {|u| ::SetGetValue( u, "FechaHora" ) },;
                        "bWhen"     => {|| .f. },;
                        "oWnd"      => ::oDlg,;
                        "nWidth"    => {|| GridWidth( 3.0, ::oDlg ) },;
                        "nHeight"   => 25,;
                        "lPixels"   => .t. } )

Return ( self )

//---------------------------------------------------------------------------//

METHOD defineIncidencia() CLASS ClienteIncidenciaView

   local getIncidencia

   TGridUrllink():Build(               {  "nTop"      => 70,;
                                          "nCol"      => {|| GridWidth( ::columnLabel, ::oDlg ) },;
                                          "cURL"      => "Nombre",;
                                          "oWnd"      => ::oDlg,;
                                          "oFont"     => oGridFont(),;
                                          "lPixel"    => .t.,;
                                          "nClrInit"  => nGridColor(),;
                                          "nClrOver"  => nGridColor(),;
                                          "nClrVisit" => nGridColor() } )

   getIncidencia  := TGridGet():Build( {  "nRow"      => 70,;
                                          "nCol"      => {|| GridWidth( 2.5, ::oDlg ) },;
                                          "bSetGet"   => {|u| ::SetGetValue( u, "Nombre" ) },;
                                          "oWnd"      => ::oDlg,;
                                          "nWidth"    => {|| GridWidth( 9.0, ::oDlg ) },;
                                          "nHeight"   => 23,;
                                          "cPict"     => "@!",;
                                          "lPixels"   => .t. } )

Return ( self )

//---------------------------------------------------------------------------//

