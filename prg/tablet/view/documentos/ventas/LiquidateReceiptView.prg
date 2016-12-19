#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Xbrowse.ch"

CLASS LiquidateReceiptView FROM ViewBase

   DATA nEntrega
   DATA nPendiente
   DATA nDiferencia
   DATA oEntrega

   DATA oDiferencia

   METHOD New()

   METHOD insertControls()

   METHOD defineAceptarCancelar()

   METHOD getTitleTipoDocumento()   INLINE ( ::getTextoTipoDocumento() )

   METHOD CalDiferencia()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oSender ) CLASS LiquidateReceiptView

   ::oSender      := oSender

   ::nEntrega     := 0
   ::nPendiente   := ::oSender:nTotalPendiente()
   ::nDiferencia  := ::oSender:nTotalPendiente()

Return ( self )

//---------------------------------------------------------------------------//

METHOD insertControls() CLASS LiquidateReceiptView

   TGridSay():Build( {  "nRow"      => 50,;
                        "nCol"      => {|| GridWidth( 0.5, ::oDlg ) },;
                        "bText"     => {|| "Total pendiente" },;
                        "oWnd"      => ::oDlg,;
                        "oFont"     => oGridFontBold(),;
                        "lPixels"   => .t.,;
                        "nClrText"  => Rgb( 0, 0, 0 ),;
                        "nClrBack"  => Rgb( 255, 255, 255 ),;
                        "nWidth"    => {|| GridWidth( 2, ::oDlg ) },;
                        "nHeight"   => 23,;
                        "lDesign"   => .f. } )

   TGridGet():Build( {  "nRow"      => 50,;
                        "nCol"      => {|| GridWidth( 3, ::oDlg ) },;
                        "bSetGet"   => {|u| if( PCount() == 0, ::nPendiente, ::nPendiente := u ) },;
                        "oWnd"      => ::oDlg,;
                        "lPixels"   => .t.,;
                        "nWidth"    => {|| GridWidth( 3, ::oDlg ) },;
                        "cPict"     => MasUnd(),;
                        "lRight"    => .t.,;
                        "bWhen"     => {|| .f. },;
                        "nHeight"   => 23 } )

   TGridSay():Build( {  "nRow"      => 80,;
                        "nCol"      => {|| GridWidth( 0.5, ::oDlg ) },;
                        "bText"     => {|| "Entrega" },;
                        "oWnd"      => ::oDlg,;
                        "oFont"     => oGridFontBold(),;
                        "lPixels"   => .t.,;
                        "nClrText"  => Rgb( 0, 0, 0 ),;
                        "nClrBack"  => Rgb( 255, 255, 255 ),;
                        "nWidth"    => {|| GridWidth( 2, ::oDlg ) },;
                        "nHeight"   => 23,;
                        "lDesign"   => .f. } )

   ::oEntrega  := TGridGet():Build( {  "nRow"      => 80,;
                                       "nCol"      => {|| GridWidth( 3, ::oDlg ) },;
                                       "bSetGet"   => {|u| if( PCount() == 0, ::nEntrega, ::nEntrega := u ) },;
                                       "oWnd"      => ::oDlg,;
                                       "nWidth"    => {|| GridWidth( 3, ::oDlg ) },;
                                       "nHeight"   => 23,;
                                       "lRight"    => .t.,;
                                       "cPict"     => MasUnd(),;
                                       "lPixels"   => .t.,;
                                       "bValid"    => {|| ::CalDiferencia() } } )

   TGridSay():Build( {  "nRow"      => 110,;
                        "nCol"      => {|| GridWidth( 0.5, ::oDlg ) },;
                        "bText"     => {|| "Diferencia" },;
                        "oWnd"      => ::oDlg,;
                        "oFont"     => oGridFontBold(),;
                        "lPixels"   => .t.,;
                        "nClrText"  => Rgb( 0, 0, 0 ),;
                        "nClrBack"  => Rgb( 255, 255, 255 ),;
                        "nWidth"    => {|| GridWidth( 2, ::oDlg ) },;
                        "nHeight"   => 23,;
                        "lDesign"   => .f. } )

   ::oDiferencia    := TGridGet():Build( {   "nRow"      => 110,;
                                             "nCol"      => {|| GridWidth( 3, ::oDlg ) },;
                                             "bSetGet"   => {|u| if( PCount() == 0, ::nDiferencia, ::nDiferencia := u ) },;
                                             "oWnd"      => ::oDlg,;
                                             "lPixels"   => .t.,;
                                             "nWidth"    => {|| GridWidth( 3, ::oDlg ) },;
                                             "cPict"     => MasUnd(),;
                                             "lRight"    => .t.,;
                                             "nHeight"   => 23 } )
   
Return( Self )

//---------------------------------------------------------------------------//

METHOD defineAceptarCancelar() CLASS LiquidateReceiptView
   
   ::buttonCancel    :=    TGridImage():Build(  {  "nTop"      => 5,;
                                                   "nLeft"     => {|| GridWidth( 9.0, ::oDlg ) },;
                                                   "nWidth"    => 64,;
                                                   "nHeight"   => 64,;
                                                   "cResName"  => "gc_error_64",;
                                                   "bLClicked" => {|| ::cancelView() },;
                                                   "oWnd"      => ::oDlg } )

   ::buttonOk        :=    TGridImage():Build(  {  "nTop"      => 5,;
                                                   "nLeft"     => {|| GridWidth( 10.5, ::oDlg ) },;
                                                   "nWidth"    => 64,;
                                                   "nHeight"   => 64,;
                                                   "cResName"  => "gc_ok_64",;
                                                   "bLClicked" => {|| ::oEntrega:lValid(), ::oSender:ProcessLiquidateReceipt( ::nEntrega ), ::endView() },;
                                                   "oWnd"      => ::oDlg } )

Return ( self )

//---------------------------------------------------------------------------//

METHOD CalDiferencia() CLASS LiquidateReceiptView

   ::nDiferencia     := ::nPendiente - ::nEntrega
   
   if !Empty( ::oDiferencia )
      ::oDiferencia:Refresh()
   end if

Return ( .t. )

//---------------------------------------------------------------------------//