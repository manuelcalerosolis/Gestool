#include "FiveWin.Ch"
#include "Factu.ch" 

CLASS ViewEdit FROM ViewBase

   DATA oDlg
   DATA oBrowse
   DATA oSender
   DATA WorkArea

   METHOD New()

   METHOD ResourceViewEdit()

   METHOD DefineSerie()

   METHOD DefineRuta()

   METHOD DefineCliente()

   METHOD DefineDireccion()

   METHOD BotonesAcciones()

   METHOD BrowseLineas()

   METHOD BotonesMovimientoBrowse()

   METHOD setWorkArea( WorkArea )      INLINE ( ::WorkArea := WorkArea )

   METHOD SetGetValue( uValue, cName ) INLINE ( if (  Empty( uValue ),;
                                                      hGet( ::oSender:hDictionaryMaster, cName ),;
                                                      hSet( ::oSender:hDictionaryMaster, cName, uValue ) ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oSender ) CLASS ViewEdit

   ::oSender   := oSender

Return ( self )

//---------------------------------------------------------------------------//

METHOD ResourceViewEdit() CLASS ViewEdit

   MsgInfo( ValtoPrg( ::oSender:hDictionaryMaster ) )

   ::oDlg  := TDialog():New( 1, 5, 40, 100, "GESTOOL TABLET",,, .f., ::Style,, rgb( 255, 255, 255 ),,, .F.,, oGridFont(),,,, .f.,, "oDlg" )

   ::TituloBrowse()

   ::BotonAceptarCancelarBrowse()

   ::DefineSerie()

   ::DefineRuta()

   ::DefineCliente()

   ::DefineDireccion()

   ::BotonesAcciones()

   ::BotonesMovimientoBrowse()

   ::BrowseLineas()

   ::oDlg:bResized         := {|| ::DialogResize() }

   ::oDlg:Activate( ,,,.t.,,, {|| ::InitDialog() } )

Return ( self )

//---------------------------------------------------------------------------//

METHOD DefineSerie() CLASS ViewEdit

   local getSerie

   TGridUrllink():Build(            {  "nTop"      => 40,;
                                       "nLeft"     => {|| GridWidth( 0.5, ::oDlg ) },;
                                       "cURL"      => "Serie",;
                                       "oWnd"      => ::oDlg,;
                                       "oFont"     => oGridFont(),;
                                       "lPixel"    => .t.,;
                                       "nClrInit"  => nGridColor(),;
                                       "nClrOver"  => nGridColor(),;
                                       "nClrVisit" => nGridColor(),;
                                       "bAction"   => {|| ::oSender:isChangeSerieTablet( getSerie ) } } )

   getSerie    := TGridGet():Build( {  "nRow"      => 40,;
                                       "nCol"      => {|| GridWidth( 2.5, ::oDlg ) },;
                                       "bSetGet"   => {|u| ::SetGetValue( u, "Serie" ) },;
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

METHOD DefineCliente() CLASS ViewEdit

   local cTextoCliente        := Space( 18 )
   local cTextoNombreCliente  := Space( 200 )

   TGridUrllink():Build({  "nTop"      => 95,;
                           "nLeft"     => {|| GridWidth( 0.5, ::oDlg ) },;
                           "cURL"      => "Cliente",;
                           "oWnd"      => ::oDlg,;
                           "oFont"     => oGridFont(),;
                           "lPixel"    => .t.,;
                           "nClrInit"  => nGridColor(),;
                           "nClrOver"  => nGridColor(),;
                           "nClrVisit" => nGridColor(),;
                           "bAction"   => {|| MsgInfo( "Cambio el cliente" ) } } )     //GridBrwClient( aGet[ _CCODCLI ], aGet[ _CNOMCLI ] ) } } )

   TGridGet():Build( {     "nRow"      => 95,;
                           "nCol"      => {|| GridWidth( 2.5, ::oDlg ) },;
                           "bSetGet"   => {|u| if( PCount() == 0, cTextoCliente, cTextoCliente := u ) },;
                           "oWnd"      => ::oDlg,;
                           "nWidth"    => {|| GridWidth( 2, ::oDlg ) },;
                           "nHeight"   => 23,;
                           "lPixels"   => .t.,;
                           "bValid"    => {|| .t. } } ) //loaCli( aGet, aTmp, nMode, , .f. ) } } )
   
   TGridGet():Build( {     "nRow"      => 95,;
                           "nCol"      => {|| GridWidth( 4.5, ::oDlg ) },;
                           "bSetGet"   => {|u| if( PCount() == 0, cTextoNombreCliente, cTextoNombreCliente := u ) },;
                           "oWnd"      => ::oDlg,;
                           "lPixels"   => .t.,;
                           "nWidth"    => {|| GridWidth( 7, ::oDlg ) },;
                           "nHeight"   => 23 } )

Return ( self )

//---------------------------------------------------------------------------//

METHOD DefineDireccion() CLASS ViewEdit

   local cTextoDireccion        := Space( 18 )
   local cTextoNombreDireccion  := Space( 200 )

   TGridUrllink():Build(   {  "nTop"      => 120,;
                              "nLeft"     => {|| GridWidth( 0.5, ::oDlg ) },;
                              "cURL"      => "Dirección",;
                              "oWnd"      => ::oDlg,;
                              "oFont"     => oGridFont(),;
                              "lPixel"    => .t.,;
                              "nClrInit"  => nGridColor(),;
                              "nClrOver"  => nGridColor(),;
                              "nClrVisit" => nGridColor(),;
                              "bAction"   => {|| MsgInfo( "Introducimos las obras" )  } } ) //GridBrwObras( aGet[ _CCODOBR ], oGetNombreDireccion, aTmp[ _CCODCLI ], dbfObrasT )  } } )

   TGridGet():Build(       {  "nRow"      => 120,;
                              "nCol"      => {|| GridWidth( 2.5, ::oDlg ) },;
                              "bSetGet"   => {|u| if( PCount() == 0, cTextoDireccion, cTextoDireccion := u ) },;
                              "oWnd"      => ::oDlg,;
                              "nWidth"    => {|| GridWidth( 2, ::oDlg ) },;
                              "nHeight"   => 23,;
                              "lPixels"   => .t.,;
                              "bValid"    => {|| .t. } } ) //cObras( aGet[ _CCODOBR ], oGetNombreDireccion, aTmp[ _CCODCLI ], dbfObrasT ) } } )

   TGridGet():Build(       {  "nRow"      => 120,;
                              "nCol"      => {|| GridWidth( 4.5, ::oDlg ) },;
                              "bSetGet"   => {|u| if( PCount() == 0, cTextoNombreDireccion, cTextoNombreDireccion := u ) },;
                              "oWnd"      => ::oDlg,;
                              "nWidth"    => {|| GridWidth( 7, ::oDlg ) },;
                              "lPixels"   => .t.,;
                              "nHeight"   => 23 } )

Return ( self )

//---------------------------------------------------------------------------//

METHOD BotonesAcciones() CLASS ViewEdit

   TGridImage():Build(  {  "nTop"      => 145,;
                           "nLeft"     => {|| GridWidth( 0.5, ::oDlg ) },;
                           "nWidth"    => 64,;
                           "nHeight"   => 64,;
                           "cResName"  => "flat_add_64",;
                           "bLClicked" => {|| Msginfo( "Añado" ) },; //AppDeta( oBrwLin, bEdtDetTablet, aTmp, .f. ) },;
                           "oWnd"      => ::oDlg } )

   TGridImage():Build(  {  "nTop"      => 145,;
                           "nLeft"     => {|| GridWidth( 2, ::oDlg ) },;
                           "nWidth"    => 64,;
                           "nHeight"   => 64,;
                           "cResName"  => "flat_edit_64",;
                           "bLClicked" => {|| Msginfo( "Modifico" ) },; //EdtDeta( oBrwLin, bEdtDetTablet, aTmp, .f., nMode ) },;
                           "oWnd"      => ::oDlg } )

   TGridImage():Build(  {  "nTop"      => 145,;
                           "nLeft"     => {|| GridWidth( 3.5, ::oDlg ) },;
                           "nWidth"    => 64,;
                           "nHeight"   => 64,;
                           "cResName"  => "flat_minus_64",;
                           "bLClicked" => {|| Msginfo( "Elimino" ) },; //WinDelRec( oBrwLin, dbfTmpLin, , , , .t. ) },;
                           "oWnd"      => ::oDlg } )

Return ( self )

//---------------------------------------------------------------------------//

METHOD BotonesMovimientoBrowse() CLASS ViewEdit

   TGridImage():Build(  {  "nTop"      => 145,;
                           "nLeft"     => {|| GridWidth( 7.5, ::oDlg ) },;
                           "nWidth"    => 64,;
                           "nHeight"   => 64,;
                           "cResName"  => "flat_page_up_64",;
                           "bLClicked" => {|| ::oBrowse:PageUp(), ::oBrowse:Select( 0 ), ::oBrowse:Select( 1 ), ::oBrowse:Refresh()  },;
                           "oWnd"      => ::oDlg } )

   TGridImage():Build(  {  "nTop"      => 145,;
                           "nLeft"     => {|| GridWidth( 8.5, ::oDlg ) },;
                           "nWidth"    => 64,;
                           "nHeight"   => 64,;
                           "cResName"  => "flat_up_64",;
                           "bLClicked" => {|| ::oBrowse:GoUp(), ::oBrowse:Select( 0 ), ::oBrowse:Select( 1 ), ::oBrowse:Refresh()  },;
                           "oWnd"      => ::oDlg } )

   TGridImage():Build(  {  "nTop"      => 145,;
                           "nLeft"     => {|| GridWidth( 9.5, ::oDlg ) },;
                           "nWidth"    => 64,;
                           "nHeight"   => 64,;
                           "cResName"  => "flat_down_64",;
                           "bLClicked" => {|| ::oBrowse:GoDown(), ::oBrowse:Select( 0 ), ::oBrowse:Select( 1 ), ::oBrowse:Refresh() },;
                           "oWnd"      => ::oDlg } )

   TGridImage():Build(  {  "nTop"      => 145,;
                           "nLeft"     => {|| GridWidth( 10.5, ::oDlg ) },;
                           "nWidth"    => 64,;
                           "nHeight"   => 64,;
                           "cResName"  => "flat_page_down_64",;
                           "bLClicked" => {|| ::oBrowse:PageDown(), ::oBrowse:Select( 0 ), ::oBrowse:Select( 1 ), ::oBrowse:Refresh() },;
                           "oWnd"      => ::oDlg } )


Return ( self )   

//---------------------------------------------------------------------------//   

METHOD BrowseLineas() CLASS ViewEdit

   ::oBrowse                  := TGridIXBrowse():New( ::oDlg )

   ::oBrowse:nTop             := ::oBrowse:EvalRow( 180 )
   ::oBrowse:nLeft            := ::oBrowse:EvalCol( {|| GridWidth( 0.5, ::oDlg ) } )
   ::oBrowse:nWidth           := ::oBrowse:EvalWidth( {|| GridWidth( 11, ::oDlg ) } )
   ::oBrowse:nHeight          := ::oBrowse:EvalHeight( {|| GridHeigth( ::oDlg ) - ::oBrowse:nTop - 10 } )
   ::oBrowse:nMarqueeStyle    := 6

   ::oBrowse:nHeaderHeight    := 48
   ::oBrowse:nFooterHeight    := 48
   ::oBrowse:nRowHeight       := 96
   ::oBrowse:nDataLines       := 2

   ::oBrowse:SetArray( ::oSender:hDictionaryDetail, , , .f. )

   ::oSender:PropiedadesBrowseDetail()

   ::oBrowse:bLDblClick       := {|| MsgInfo( "DobleClick" ) }

   ::oBrowse:CreateFromCode()

Return ( self )

//---------------------------------------------------------------------------//