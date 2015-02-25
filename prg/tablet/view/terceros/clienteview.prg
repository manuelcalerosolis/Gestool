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

Return ( self )

//---------------------------------------------------------------------------//

METHOD defineCodigo() CLASS ClienteView

   local getCodigo

   TGridUrllink():Build(            {  "nTop"      => 40,;
                                       "nLeft"     => {|| GridWidth( 0.5, ::oDlg ) },;
                                       "cURL"      => "Código",;
                                       "oWnd"      => ::oDlg,;
                                       "oFont"     => oGridFont(),;
                                       "lPixel"    => .t.,;
                                       "nClrInit"  => nGridColor(),;
                                       "nClrOver"  => nGridColor(),;
                                       "nClrVisit" => nGridColor(),;
                                       "bAction"   => {|| msgAlert("getLastNum") } } )

   getCodigo   := TGridGet():Build( {  "nRow"      => 40,;
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

   local getNIF

   TGridUrllink():Build(            {  "nTop"      => 70,;
                                       "nLeft"     => {|| GridWidth( 0.5, ::oDlg ) },;
                                       "cURL"      => "NIF",;
                                       "oWnd"      => ::oDlg,;
                                       "oFont"     => oGridFont(),;
                                       "lPixel"    => .t.,;
                                       "nClrInit"  => nGridColor(),;
                                       "nClrOver"  => nGridColor(),;
                                       "nClrVisit" => nGridColor() } )

   getNIF      := TGridGet():Build( {  "nRow"      => 70,;
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

   local getNombre

   TGridUrllink():Build(            {  "nTop"      => 100,;
                                       "nLeft"     => {|| GridWidth( 0.5, ::oDlg ) },;
                                       "cURL"      => "Nombre",;
                                       "oWnd"      => ::oDlg,;
                                       "oFont"     => oGridFont(),;
                                       "lPixel"    => .t.,;
                                       "nClrInit"  => nGridColor(),;
                                       "nClrOver"  => nGridColor(),;
                                       "nClrVisit" => nGridColor() } )

   getNombre   := TGridGet():Build( {  "nRow"      => 100,;
                                       "nCol"      => {|| GridWidth( 2.5, ::oDlg ) },;
                                       "bSetGet"   => {|u| ::SetGetValue( u, "Nombre" ) },;
                                       "oWnd"      => ::oDlg,;
                                       "nWidth"    => {|| GridWidth( 9.0, ::oDlg ) },;
                                       "nHeight"   => 23,;
                                       "cPict"     => "@!",;
                                       "lPixels"   => .t. } )

Return ( self )

//---------------------------------------------------------------------------//

