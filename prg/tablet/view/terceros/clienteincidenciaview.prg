#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Xbrowse.ch"

CLASS ClienteIncidenciaView FROM ViewBase
  
   METHOD New()

   METHOD insertControls()

   METHOD defineNombre()

   METHOD defineFecha()

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

   ::defineFecha()

Return ( self )

//---------------------------------------------------------------------------//

METHOD defineCombo() CLASS ClienteIncidenciaView

   local oCombo

   oCombo   := TGridComboBox():Build(  {  "nRow"      => 130,;
                                          "nCol"      => {|| GridWidth( 2.5, ::oDlg ) },;
                                          "bSetGet"   => {|u| iif( empty( u ), ::oSender:cNombreIncidencia, ::oSender:cNombreIncidencia := u ) },;
                                          "oWnd"      => ::oDlg,;
                                          "nWidth"    => {|| GridWidth( 9, ::oDlg ) },;
                                          "nHeight"   => 25,;
                                          "aItems"    => D():getTiposIncicencias( ::getView() ) } )

Return ( self )

//---------------------------------------------------------------------------//

METHOD defineNombre() CLASS ClienteIncidenciaView

   TGridUrllink():Build(   {  "nTop"      => 40,;
                              "nLeft"     => {|| GridWidth( 0.5, ::oDlg ) },;
                              "cURL"      => "Incidencia",;
                              "oWnd"      => ::oDlg,;
                              "oFont"     => oGridFont(),;
                              "lPixel"    => .t.,;
                              "nClrInit"  => nGridColor(),;
                              "nClrOver"  => nGridColor(),;
                              "nClrVisit" => nGridColor(),;
                              "bAction"   => {|| msgAlert("getLastNum") } } )

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

   local getFecha

   TGridUrllink():Build(            {  "nTop"      => 100,;
                                       "nLeft"     => {|| GridWidth( 0.5, ::oDlg ) },;
                                       "cURL"      => "Fecha",;
                                       "oWnd"      => ::oDlg,;
                                       "oFont"     => oGridFont(),;
                                       "lPixel"    => .t.,;
                                       "nClrInit"  => nGridColor(),;
                                       "nClrOver"  => nGridColor(),;
                                       "nClrVisit" => nGridColor() } )

   getFecha   := TGridGet():Build( {  "nRow"      => 100,;
                                       "nCol"      => {|| GridWidth( 2.5, ::oDlg ) },;
                                       "bSetGet"   => {|u| ::SetGetValue( u, "Fecha" ) },;
                                       "oWnd"      => ::oDlg,;
                                       "nWidth"    => {|| GridWidth( 2.0, ::oDlg ) },;
                                       "nHeight"   => 25,;
                                       "cPict"     => "@!",;
                                       "lPixels"   => .t. } )

Return ( self )

//---------------------------------------------------------------------------//

METHOD defineIncidencia() CLASS ClienteIncidenciaView

   local getIncidencia

   TGridUrllink():Build(               {  "nTop"      => 70,;
                                          "nLeft"     => {|| GridWidth( 0.5, ::oDlg ) },;
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

