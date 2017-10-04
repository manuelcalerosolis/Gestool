#include "FiveWin.Ch"
#include "Factu.ch" 

CLASS StockViewNavigator FROM ViewSearchNavigator

   DATA cArticulo
   DATA cAlmacen

   METHOD Resource()

   METHOD setItemsBusqueda()           INLINE ( ::hashItemsSearch := { "Nombre" => "Nombre", "Código" => "Codigo" } )

   METHOD setColumns()

   METHOD botonesAcciones()            INLINE ( self )

   METHOD initDialog()

   METHOD validDialog()

   METHOD setSubTitle( cCodArt, cCodAlm )

   METHOD defineSubTitulo()

END CLASS

//---------------------------------------------------------------------------//

METHOD Resource() CLASS StockViewNavigator

   ::oDlg                     := TDialog():New( 1, 5, 40, 100, "GESTOOL TABLET",,, .f., ::Style,, rgb( 255, 255, 255 ),,, .F.,, oGridFont(),,,, .f.,, "oDlg" )

   ::defineTitulo()

   if ::lSelectorMode
      ::defineAceptarCancelar()
   else
      ::defineSalir()
   end if

   ::botonesMovimientoBrowse()

   ::defineSubTitulo()

   ::browseArray()

   ::oDlg:bResized            := {|| ::resizeDialog() }

   ::oDlg:Activate( , , ,.t., {|| ::validDialog() },, {|| ::initDialog() } )

   ::endDialog()

Return ( self )

//---------------------------------------------------------------------------//

METHOD initDialog() CLASS StockViewNavigator

   GridMaximize( ::oDlg )

   ::refreshBrowse()

Return ( self )

//---------------------------------------------------------------------------//

METHOD validDialog() CLASS StockViewNavigator

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD setColumns() CLASS StockViewNavigator

   ::setBrowseConfigurationName( "grid_stock" )

   with object ( ::oBrowse:AddCol() )
      :cHeader          := "Lote"
      :nWidth           := 175
      :bStrData         := {|| if( !Empty( ::oBrowse:aArrayData ), ::oBrowse:aArrayData[ ::oBrowse:nArrayAt ]:cLote, "" ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cHeader          := "Unidades"
      :nWidth           := 175
      :bEditValue       := {|| if( !Empty( ::oBrowse:aArrayData ), ::oBrowse:aArrayData[ ::oBrowse:nArrayAt ]:nUnidades, 0 ) }
      :cEditPicture     := MasUnd()
      :nDataStrAlign    := AL_RIGHT
      :nHeadStrAlign    := AL_RIGHT
   end with

Return ( self )

//---------------------------------------------------------------------------//

METHOD setSubTitle( cCodArt, cCodAlm ) CLASS StockViewNavigator

   ::cArticulo := AllTrim( cCodArt ) + "-" + Capitalize( RetFld( cCodArt, D():Articulos( ::oSender:nView ) ) )
   ::cAlmacen  := AllTrim( cCodAlm ) + "-" + Capitalize( RetFld( cCodAlm, D():Almacen( ::oSender:nView ) ) )

Return ( self )

//---------------------------------------------------------------------------//

METHOD defineSubTitulo() CLASS StockViewNavigator

   TGridSay():Build(    {  "nRow"      => 45,;
                           "nCol"      => {|| GridWidth( 0.5, ::oDlg ) },;
                           "bText"     => {|| ::cArticulo },;
                           "oWnd"      => ::oDlg,;
                           "oFont"     => oGridFont(),;
                           "lPixels"   => .t.,;
                           "nClrText"  => Rgb( 0, 0, 0 ),;
                           "nClrBack"  => Rgb( 255, 255, 255 ),;
                           "nWidth"    => {|| GridWidth( 6, ::oDlg ) },;
                           "nHeight"   => 42,;
                           "lDesign"   => .f. } )

   TGridSay():Build(    {  "nRow"      => 75,;
                           "nCol"      => {|| GridWidth( 0.5, ::oDlg ) },;
                           "bText"     => {|| ::cAlmacen },;
                           "oWnd"      => ::oDlg,;
                           "oFont"     => oGridFont(),;
                           "lPixels"   => .t.,;
                           "nClrText"  => Rgb( 0, 0, 0 ),;
                           "nClrBack"  => Rgb( 255, 255, 255 ),;
                           "nWidth"    => {|| GridWidth( 6, ::oDlg ) },;
                           "nHeight"   => 42,;
                           "lDesign"   => .f. } )

Return ( self )

//---------------------------------------------------------------------------//