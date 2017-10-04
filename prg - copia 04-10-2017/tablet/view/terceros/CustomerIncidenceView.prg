#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Xbrowse.ch"

CLASS CustomerIncidenceView FROM ViewBase
  
   METHOD New()

   METHOD insertControls()

   METHOD defineNombre()

   METHOD defineFecha()

   METHOD defineHora()

   METHOD defineIncidencia()

   METHOD defineCombo()

   // METHOD getTextoTipoDocumento()      INLINE ( lblTitle( ::getMode() ) + "incidencia" )    

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oSender ) CLASS CustomerIncidenceView

   ::oSender               := oSender

Return ( self )

//---------------------------------------------------------------------------//

METHOD insertControls( nMode ) CLASS CustomerIncidenceView

   ::defineNombre()

   ::defineCombo()

   ::defineFecha()

   ::defineHora()

Return ( self )

//---------------------------------------------------------------------------//

METHOD defineCombo() CLASS CustomerIncidenceView

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

METHOD defineNombre() CLASS CustomerIncidenceView

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

METHOD defineFecha() CLASS CustomerIncidenceView

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

   TGridGet():Build(    {  "nRow"      => 100,;
                           "nCol"      => {|| GridWidth( 2.5, ::oDlg ) },;
                           "bSetGet"   => {|u| ::SetGetValue( u, "Fecha" ) },;
                           "oWnd"      => ::oDlg,;
                           "nWidth"    => {|| GridWidth( 4.0, ::oDlg ) },;
                           "nHeight"   => 25,;
                           "lPixels"   => .t. } )

Return ( self )

//---------------------------------------------------------------------------//

METHOD defineHora() CLASS CustomerIncidenceView

   TGridGet():Build( {  "nRow"      => 100,;
                        "nCol"      => {|| GridWidth( 7, ::oDlg ) },;
                        "bSetGet"   => {|u| ::SetGetValue( u, "Hora" ) },;
                        "bValid"    => {|| iif( !validTime( hGet( ::oSender:hDictionaryMaster, "Hora" ) ),;
                                                ::setErrorValidator( "El formato de la hora no es correcto" ),;
                                                .t. ) },;
                        "oWnd"      => ::oDlg,;
                        "nWidth"    => {|| GridWidth( 4.0, ::oDlg ) },;
                        "cPict"     => "@R 99:99:99" ,;
                        "nHeight"   => 25,;
                        "lPixels"   => .t. } )

Return ( self )

//---------------------------------------------------------------------------//

METHOD defineIncidencia() CLASS CustomerIncidenceView

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

