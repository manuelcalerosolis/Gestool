#include "FiveWin.Ch"
#include "Factu.ch" 

CLASS ViewBase

   DATA oDlg
   DATA oBrowse

   DATA oSender

   DATA nMode

   DATA WorkArea

   DATA Style                          INIT ( nOR( DS_MODALFRAME, WS_POPUP, WS_CAPTION, WS_SYSMENU, WS_MINIMIZEBOX, WS_MAXIMIZEBOX ) )

   METHOD New()

   METHOD TituloBrowse()

   METHOD defineAceptarCancelar()
   METHOD BotonSalirBrowse()

   METHOD DialogResize()
   METHOD InitDialog()

   METHOD setWorkArea( WorkArea )      INLINE ( ::WorkArea := WorkArea )
   METHOD getWorkArea( WorkArea )      INLINE ( ::WorkArea )

   METHOD setGetValue( uValue, cName ) INLINE ( if (  Empty( uValue ),;
                                                      hGet( ::oSender:hDictionaryMaster, cName ),;
                                                      hSet( ::oSender:hDictionaryMaster, cName, uValue ) ) )


END CLASS

//---------------------------------------------------------------------------//

METHOD New() CLASS ViewBase

Return ( self )

//---------------------------------------------------------------------------//

METHOD TituloBrowse() CLASS ViewBase 

   TGridSay():Build(    {  "nRow"      => 0,;
                           "nCol"      => {|| GridWidth( 0.5, ::oDlg ) },;
                           "bText"     => {|| ::cTextoTipoDocumento },;
                           "oWnd"      => ::oDlg,;
                           "oFont"     => oGridFontBold(),;
                           "lPixels"   => .t.,;
                           "nClrText"  => Rgb( 0, 0, 0 ),;
                           "nClrBack"  => Rgb( 255, 255, 255 ),;
                           "nWidth"    => {|| GridWidth( 7, ::oDlg ) },;
                           "nHeight"   => 32,;
                           "lDesign"   => .f. } )

Return ( self )

//---------------------------------------------------------------------------//

METHOD BotonSalirBrowse() CLASS ViewBase

   TGridImage():Build(  {  "nTop"      => 5,;
                           "nLeft"     => {|| GridWidth( 10.5, ::oDlg ) },;
                           "nWidth"    => 64,;
                           "nHeight"   => 64,;
                           "cResName"  => "flat_end_64",;
                           "bLClicked" => {|| ::oDlg:End() },;
                           "oWnd"      => ::oDlg } )

Return ( self )

//---------------------------------------------------------------------------//

METHOD defineAceptarCancelar() CLASS ViewBase

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

METHOD DialogResize() CLASS ViewBase

   GridResize( ::oDlg )

Return ( self )

//---------------------------------------------------------------------------//

METHOD InitDialog() CLASS ViewBase

   GridMaximize( ::oDlg )

Return ( self )

//---------------------------------------------------------------------------//