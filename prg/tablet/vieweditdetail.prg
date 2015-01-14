#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Xbrowse.ch"

CLASS ViewDetail FROM ViewBase

   DATA oDlg
   DATA nMode
   DATA oSender
   
   METHOD New()

   METHOD ResourceViewEditDetail()

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

   ::oDlg:Activate( ,,,.t.,,, {|| ::InitDialog() } )

Return ( self )

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
                           "bLClicked" => {|| ::oSender:GuardaLinea(), ::oDlg:End() },;
                           "oWnd"      => ::oDlg } )

Return ( self )

//---------------------------------------------------------------------------//

METHOD defineArticulo() CLASS ViewDetail

   /*TGridUrllink():Build({  "nTop"      => 40,;
                           "nLeft"     => {|| GridWidth( 0.5, ::oDlg ) },;
                           "cURL"      => "Artículo",;
                           "oWnd"      => ::oDlg,;
                           "oFont"     => oGridFont(),;
                           "lPixel"    => .t.,;
                           "nClrInit"  => nGridColor(),;
                           "nClrOver"  => nGridColor(),;
                           "nClrVisit" => nGridColor(),;
                           "bAction"   => {|| Msginfo( "Browse de artículos" ) } } ) //GridBrwArticulo( aGet[ _CREF ], aGet[ _CDETALLE ] ) } } )

   TGridGet():Build( {     "nRow"      => 40,;
                           "nCol"      => {|| GridWidth( 2.5, oDlg ) },;
                           "bSetGet"   => {|u| if( PCount() == 0, aTmp[ _CREF ], aTmp[ _CREF ] := u ) },;
                           "oWnd"      => ::oDlg,;
                           "nWidth"    => {|| GridWidth( 3, ::oDlg ) },;
                           "nHeight"   => 23,;
                           "lPixels"   => .t.,;
                           "bValid"    => {|| .t. } } ) //LoaArt( aTmp[ _CREF ], aGet, aTmp, aTmpFac,,,,,,, nMode, , oSayLote ), lCalcDeta( aTmp, aTmpFac ) } } )
   
   TGridGet():Build( {     "nRow"      => 40,;
                           "nCol"      => {|| GridWidth( 5.5, ::oDlg ) },;
                           "bSetGet"   => {|u| if( PCount() == 0, aTmp[ _CDETALLE ], aTmp[ _CDETALLE ] := u ) },;
                           "oWnd"      => ::oDlg,;
                           "lPixels"   => .t.,;
                           "nWidth"    => {|| GridWidth( 6, ::oDlg ) },;
                           "nHeight"   => 23 } )*/

Return ( self )

//---------------------------------------------------------------------------//

METHOD defineLote() CLASS ViewDetail

Return ( self )

//---------------------------------------------------------------------------//

METHOD defineCajas() CLASS ViewDetail

Return ( self )

//---------------------------------------------------------------------------//

METHOD defineUnidades() CLASS ViewDetail

Return ( self )

//---------------------------------------------------------------------------//

METHOD definePrecio() CLASS ViewDetail

Return ( self )

//---------------------------------------------------------------------------//

METHOD defineDescuentoPorcentual() CLASS ViewDetail

Return ( self )

//---------------------------------------------------------------------------//

METHOD defineDescuentoLineal() CLASS ViewDetail

Return ( self )

//---------------------------------------------------------------------------//

METHOD defineTotal() CLASS ViewDetail

Return ( self )

//---------------------------------------------------------------------------//