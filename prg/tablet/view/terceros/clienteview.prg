#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Xbrowse.ch"

CLASS ClienteView FROM ViewBase
  
   METHOD New()

   METHOD getTextoTipoDocumento()      INLINE ( LblTitle( ::getMode() ) + "cliente" ) 

   METHOD insertControls()

   METHOD defineCodigo()

   METHOD defineNombre()

   METHOD defineNIF()

   METHOD defineDomicilio()

   METHOD definePoblacion()

   METHOD defineCodigoPostal()

   METHOD defineProvincia()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oSender ) CLASS ClienteView

   ::oSender               := oSender

Return ( self )

//---------------------------------------------------------------------------//

METHOD insertControls() CLASS ClienteView

   ::defineCodigo()

   ::defineNombre()

   ::defineNIF()

   ::defineDomicilio()

   ::definePoblacion()

   ::defineCodigoPostal()

   ::defineProvincia()

Return ( self )

//---------------------------------------------------------------------------//

METHOD defineCodigo() CLASS ClienteView

   TGridSay():Build( {  "nRow"      => 40,;
                        "nCol"      => {|| GridWidth( 0.5, ::oDlg ) },;
                        "bText"     => {|| "Código" },;
                        "oWnd"      => ::oDlg,;
                        "oFont"     => oGridFont(),;
                        "lPixels"   => .t.,;
                        "nClrText"  => Rgb( 0, 0, 0 ),;
                        "nClrBack"  => Rgb( 255, 255, 255 ),;
                        "nWidth"    => {|| GridWidth( 1, ::oDlg ) },;
                        "nHeight"   => 23,;
                        "lDesign"   => .f. } )

   TGridGet():Build( {  "nRow"      => 40,;
                        "nCol"      => {|| GridWidth( 2.5, ::oDlg ) },;
                        "bSetGet"   => {|u| ::SetGetValue( u, "Codigo" ) },;
                        "oWnd"      => ::oDlg,;
                        "nWidth"    => {|| GridWidth( 2, ::oDlg ) },;
                        "bWhen"     => {|| ::getMode() == APPD_MODE .or. ::getMode() == DUPL_MODE },;
                        "nHeight"   => 23,;
                        "cPict"     => "@!",;
                        "lPixels"   => .t. } )

Return ( self )

//---------------------------------------------------------------------------//

METHOD defineNIF() CLASS ClienteView

   TGridSay():Build( {  "nRow"      => 70,;
                        "nCol"      => {|| GridWidth( 0.5, ::oDlg ) },;
                        "bText"     => {|| "NIF" },;
                        "oWnd"      => ::oDlg,;
                        "oFont"     => oGridFont(),;
                        "lPixels"   => .t.,;
                        "nClrText"  => Rgb( 0, 0, 0 ),;
                        "nClrBack"  => Rgb( 255, 255, 255 ),;
                        "nWidth"    => {|| GridWidth( 1, ::oDlg ) },;
                        "nHeight"   => 23,;
                        "lDesign"   => .f. } )

   TGridGet():Build( {  "nRow"      => 70,;
                        "nCol"      => {|| GridWidth( 2.5, ::oDlg ) },;
                        "bSetGet"   => {|u| ::SetGetValue( u, "NIF" ) },;
                        "oWnd"      => ::oDlg,;
                        "nWidth"    => {|| GridWidth( 9.0, ::oDlg ) },;
                        "nHeight"   => 23,;
                        "cPict"     => "@!",;
                        "lPixels"   => .t. } )

Return ( self )

//---------------------------------------------------------------------------//

METHOD defineNombre() CLASS ClienteView

   TGridSay():Build( {  "nRow"      => 100,;
                        "nCol"      => {|| GridWidth( 0.5, ::oDlg ) },;
                        "bText"     => {|| "Nombre" },;
                        "oWnd"      => ::oDlg,;
                        "oFont"     => oGridFont(),;
                        "lPixels"   => .t.,;
                        "nClrText"  => Rgb( 0, 0, 0 ),;
                        "nClrBack"  => Rgb( 255, 255, 255 ),;
                        "nWidth"    => {|| GridWidth( 1, ::oDlg ) },;
                        "nHeight"   => 23,;
                        "lDesign"   => .f. } )

   TGridGet():Build( {  "nRow"      => 100,;
                        "nCol"      => {|| GridWidth( 2.5, ::oDlg ) },;
                        "bSetGet"   => {|u| ::SetGetValue( u, "Nombre" ) },;
                        "oWnd"      => ::oDlg,;
                        "nWidth"    => {|| GridWidth( 9.0, ::oDlg ) },;
                        "nHeight"   => 23,;
                        "cPict"     => "@!",;
                        "lPixels"   => .t. } )

Return ( self )

//---------------------------------------------------------------------------//

METHOD defineDomicilio() CLASS ClienteView

   TGridSay():Build( {  "nRow"      => 130,;
                        "nCol"      => {|| GridWidth( 0.5, ::oDlg ) },;
                        "bText"     => {|| "Domicilio" },;
                        "oWnd"      => ::oDlg,;
                        "oFont"     => oGridFont(),;
                        "lPixels"   => .t.,;
                        "nClrText"  => Rgb( 0, 0, 0 ),;
                        "nClrBack"  => Rgb( 255, 255, 255 ),;
                        "nWidth"    => {|| GridWidth( 1, ::oDlg ) },;
                        "nHeight"   => 23,;
                        "lDesign"   => .f. } )

   TGridGet():Build( {  "nRow"      => 130,;
                        "nCol"      => {|| GridWidth( 2.5, ::oDlg ) },;
                        "bSetGet"   => {|u| ::SetGetValue( u, "Domicilio" ) },;
                        "oWnd"      => ::oDlg,;
                        "nWidth"    => {|| GridWidth( 9, ::oDlg ) },;
                        "nHeight"   => 23,;
                        "cPict"     => "@!",;
                        "lPixels"   => .t. } )

Return ( self )

//---------------------------------------------------------------------------//

METHOD defineCodigoPostal() CLASS ClienteView

   TGridSay():Build( {  "nRow"      => 160,;
                        "nCol"      => {|| GridWidth( 0.5, ::oDlg ) },;
                        "bText"     => {|| "Código postal" },;
                        "oWnd"      => ::oDlg,;
                        "oFont"     => oGridFont(),;
                        "lPixels"   => .t.,;
                        "nClrText"  => Rgb( 0, 0, 0 ),;
                        "nClrBack"  => Rgb( 255, 255, 255 ),;
                        "nWidth"    => {|| GridWidth( 1, ::oDlg ) },;
                        "nHeight"   => 23,;
                        "lDesign"   => .f. } )

   TGridGet():Build( {  "nRow"      => 160,;
                        "nCol"      => {|| GridWidth( 2.5, ::oDlg ) },;
                        "bSetGet"   => {|u| ::SetGetValue( u, "CodigoPostal" ) },;
                        "oWnd"      => ::oDlg,;
                        "nWidth"    => {|| GridWidth( 9, ::oDlg ) },;
                        "nHeight"   => 23,;
                        "cPict"     => "@!",;
                        "lPixels"   => .t. } )

Return ( self )

//---------------------------------------------------------------------------//

METHOD definePoblacion() CLASS ClienteView

   TGridSay():Build( {  "nRow"      => 190,;
                        "nCol"      => {|| GridWidth( 0.5, ::oDlg ) },;
                        "bText"     => {|| "Población" },;
                        "oWnd"      => ::oDlg,;
                        "oFont"     => oGridFont(),;
                        "lPixels"   => .t.,;
                        "nClrText"  => Rgb( 0, 0, 0 ),;
                        "nClrBack"  => Rgb( 255, 255, 255 ),;
                        "nWidth"    => {|| GridWidth( 1, ::oDlg ) },;
                        "nHeight"   => 23,;
                        "lDesign"   => .f. } )

   TGridGet():Build( {  "nRow"      => 190,;
                        "nCol"      => {|| GridWidth( 2.5, ::oDlg ) },;
                        "bSetGet"   => {|u| ::SetGetValue( u, "Poblacion" ) },;
                        "oWnd"      => ::oDlg,;
                        "nWidth"    => {|| GridWidth( 9, ::oDlg ) },;
                        "nHeight"   => 23,;
                        "cPict"     => "@!",;
                        "lPixels"   => .t. } )

Return ( self )

//---------------------------------------------------------------------------//

METHOD defineProvincia() CLASS ClienteView

   TGridSay():Build( {  "nRow"      => 210,;
                        "nCol"      => {|| GridWidth( 0.5, ::oDlg ) },;
                        "bText"     => {|| "Provincia" },;
                        "oWnd"      => ::oDlg,;
                        "oFont"     => oGridFont(),;
                        "lPixels"   => .t.,;
                        "nClrText"  => Rgb( 0, 0, 0 ),;
                        "nClrBack"  => Rgb( 255, 255, 255 ),;
                        "nWidth"    => {|| GridWidth( 1, ::oDlg ) },;
                        "nHeight"   => 23,;
                        "lDesign"   => .f. } )

   TGridGet():Build( {  "nRow"      => 210,;
                        "nCol"      => {|| GridWidth( 2.5, ::oDlg ) },;
                        "bSetGet"   => {|u| ::SetGetValue( u, "Provincia" ) },;
                        "oWnd"      => ::oDlg,;
                        "nWidth"    => {|| GridWidth( 9, ::oDlg ) },;
                        "nHeight"   => 23,;
                        "cPict"     => "@!",;
                        "lPixels"   => .t. } )

Return ( self )

//---------------------------------------------------------------------------//
