#include "FiveWin.Ch"
#include "Factu.ch" 

CLASS ViewEdit FROM ViewBase

   DATA oDlg
   DATA oBrowse
   DATA oSender

   METHOD New()

   METHOD ResourceViewEdit()

   METHOD DefineSerie()

   METHOD DefineRuta()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oSender ) CLASS ViewEdit

   ::oSender   := oSender

Return ( self )

//---------------------------------------------------------------------------//

METHOD ResourceViewEdit() CLASS ViewEdit

   ::oDlg  := TDialog():New( 1, 5, 40, 100, "GESTOOL TABLET",,, .f., ::Style,, rgb( 255, 255, 255 ),,, .F.,, oGridFont(),,,, .f.,, "oDlg" )

   ::TituloBrowse()

   ::BotonAceptarCancelarBrowse()

   ::DefineSerie()

   ::DefineRuta()

   ::oDlg:bResized         := {|| ::DialogResize() }

   ::oDlg:Activate( ,,,.t.,,, {|| ::InitDialog() } )

Return ( self )

//---------------------------------------------------------------------------//

METHOD DefineSerie() CLASS ViewEdit

   local getSerie
   local cSerDoc     := "A"

   TGridUrllink():Build(            {  "nTop"      => 40,;
                                       "nLeft"     => {|| GridWidth( 0.5, ::oDlg ) },;
                                       "cURL"      => "Serie",;
                                       "oWnd"      => ::oDlg,;
                                       "oFont"     => oGridFont(),;
                                       "lPixel"    => .t.,;
                                       "nClrInit"  => nGridColor(),;
                                       "nClrOver"  => nGridColor(),;
                                       "nClrVisit" => nGridColor(),;
                                       "bAction"   => {|| msgInfo( "Serieee" ) } } ) //isChangeSerieTablet( lSndDoc, getSerie ) } } )

   getSerie    := TGridGet():Build( {  "nRow"      => 40,;
                                       "nCol"      => {|| GridWidth( 2.5, ::oDlg ) },;
                                       "bSetGet"   => {|u| if( PCount() == 0, cSerDoc, cSerDoc := u ) },;
                                       "oWnd"      => ::oDlg,;
                                       "nWidth"    => {|| GridWidth( 2, ::oDlg ) },;
                                       "nHeight"   => 23,;
                                       "cPict"     => "@!",;
                                       "lPixels"   => .t. } )

Return ( self )

//---------------------------------------------------------------------------//

METHOD DefineRuta() CLASS ViewEdit


   local oCbxRuta
   local cCbxRuta       := "Lunes"
   local aCbxRuta       := { "Lunes", "Martes" }
   local cSayTextRuta   := "1/1"

   TGridSay():Build(    {  "nRow"      => 67,;
                           "nCol"      => {|| GridWidth( 0.5, ::oDlg ) },;
                           "bText"     => {|| "Ruta" },;
                           "oWnd"      => ::oDlg,;
                           "oFont"     => oGridFont(),;
                           "lPixels"   => .t.,;
                           "nClrText"  => Rgb( 0, 0, 0 ),;
                           "nClrBack"  => Rgb( 255, 255, 255 ),;
                           "nWidth"    => {|| GridWidth( 1, ::oDlg ) },;
                           "nHeight"   => 23,;
                           "lDesign"   => .f. } )

   oCbxRuta    := TGridComboBox():Build(  {  "nRow"      => 67,;
                                             "nCol"      => {|| GridWidth( 2.5, ::oDlg ) },;
                                             "bSetGet"   => {|u| if( PCount() == 0, cCbxRuta, cCbxRuta := u ) },;
                                             "oWnd"      => ::oDlg,;
                                             "nWidth"    => {|| GridWidth( 2, ::oDlg ) },;
                                             "nHeight"   => 25,;
                                             "aItems"    => aCbxRuta,;
                                             "bChange"   => {|| Msginfo( "Cambiamos la ruta" ) } } )  //CambioRutaTablet( aGet, oCbxRuta, oSayTextRuta ) } } )

   TGridImage():Build(  {  "nTop"      => 63,;
                           "nLeft"     => {|| GridWidth( 4.5, ::oDlg ) },;
                           "nWidth"    => 64,;
                           "nHeight"   => 64,;
                           "cResName"  => "flat_left_64",;
                           "bLClicked" => {|| Msginfo( "Cambiamos cliente" ) },; //NextClient( aGet, oCbxRuta, .t., oSayTextRuta ) },;
                           "oWnd"      => ::oDlg } )

   TGridImage():Build(  {  "nTop"      => 63,;
                           "nLeft"     => {|| GridWidth( 6, ::oDlg ) },;
                           "nWidth"    => 64,;
                           "nHeight"   => 64,;
                           "cResName"  => "flat_right_64",;
                           "bLClicked" => {|| Msginfo( "Cambiamos cliente" ) },; //NextClient( aGet, oCbxRuta, .f., oSayTextRuta ) },;
                           "oWnd"      => ::oDlg } )

   TGridGet():Build(    {  "nRow"      => 67,;
                           "nCol"      => {|| GridWidth( 7, ::oDlg ) },;
                           "bSetGet"   => {|u| if( PCount() == 0, cSayTextRuta, cSayTextRuta := u ) },;
                           "oWnd"      => ::oDlg,;
                           "nWidth"    => {|| GridWidth( 4.5, ::oDlg ) },;
                           "nHeight"   => 23,;
                           "bWhen"     => {|| .f. },;
                           "lPixels"   => .t. } )
   

Return ( self )

//---------------------------------------------------------------------------//