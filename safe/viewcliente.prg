#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Xbrowse.ch"

CLASS ViewCliente FROM ViewBase
  
   DATA oGetCliente
   DATA oNombreCliente

   METHOD New()

   METHOD ResourceViewEdit()

   METHOD StartResourceViewEdit()

   METHOD defineCodigo()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oSender ) CLASS ViewCliente

   ::oSender   := oSender

Return ( self )

//---------------------------------------------------------------------------//

METHOD ResourceViewEdit( nMode ) CLASS ViewCliente

   ::nMode  := nMode

   ::oDlg   := TDialog():New( 1, 5, 40, 100, "GESTOOL TABLET",,, .f., ::Style,, rgb( 255, 255, 255 ),,, .F.,, oGridFont(),,,, .f.,, "oDlg" )

   ::TituloBrowse()

   ::defineAceptarCancelar()

   ::defineCodigo()

   ::oDlg:bResized         := {|| ::DialogResize() }

   ::oDlg:bStart           := {|| ::StartResourceViewEdit() }

   ::oDlg:Activate( ,,,.t.,,, {|| ::InitDialog() } )

Return ( self )

//---------------------------------------------------------------------------//

METHOD StartResourceViewEdit() CLASS ViewCliente

Return ( self )

//---------------------------------------------------------------------------//

METHOD defineCodigo() CLASS ViewCliente

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
                                       "nHeight"   => 23,;
                                       "cPict"     => "@!",;
                                       "lPixels"   => .t. } )

Return ( self )

//---------------------------------------------------------------------------//


