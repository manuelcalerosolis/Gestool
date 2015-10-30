#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Xbrowse.ch"

CLASS ViewEdit FROM ViewBase

   DATA nMode
   
   DATA getCodigoCliente
   DATA oNombreCliente

   DATA getCodigoDireccion
   DATA getNombreDireccion
   DATA textNombreDireccion         INIT Space( 200 )

   DATA oCbxRuta
   DATA getRuta

   DATA getSerie

   METHOD New()

   METHOD StartDialog()

   METHOD defineAceptarCancelar()

   METHOD defineSerie()
      METHOD refreshSerie()         INLINE ( ::getSerie:Refresh() )

   METHOD defineRuta()

   METHOD defineCliente()
      METHOD refreshCliente()       INLINE ( ::getCodigoCliente:Refresh(), ::oNombreCliente:Refresh() )

   METHOD defineDireccion()

   METHOD defineBotonesAcciones()

   METHOD defineBrowseLineas()

   METHOD defineBotonesMovimiento()

   METHOD refreshBrowse()           INLINE ( ::oBrowse:MakeTotals(), ::oBrowse:Refresh() )

   METHOD onClickRotor()            VIRTUAL

   METHOD getTitleTipoDocumento()   INLINE ( lblTitle( ::getMode() ) + ::getTextoTipoDocumento() )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oSender ) CLASS ViewEdit

   ::oSender   := oSender

Return ( self )

//---------------------------------------------------------------------------//

METHOD StartDialog() CLASS ViewEdit

   ::getCodigoDireccion:lValid()

   if ::oSender:nMode == APPD_MODE
      ::oSender:loadNextClient( ::nMode )
   else   
      ::RefreshBrowse()
   end if

Return Self

//---------------------------------------------------------------------------//

METHOD defineAceptarCancelar() CLASS ViewEdit

   TGridImage():Build(  {  "nTop"      => 5,;
                           "nLeft"     => {|| GridWidth( 7.5, ::oDlg ) },;
                           "nWidth"    => 64,;
                           "nHeight"   => 64,;
                           "cResName"  => "flat_atom_64",;
                           "bLClicked" => {|| ::oSender:onClickRotor() },;
                           "oWnd"      => ::oDlg } )

   TGridImage():Build(  {  "nTop"      => 5,;
                           "nLeft"     => {|| GridWidth( 9.0, ::oDlg ) },;
                           "nWidth"    => 64,;
                           "nHeight"   => 64,;
                           "cResName"  => "flat_del_64",;
                           "bLClicked" => {|| ::oSender:onViewCancel() },;
                           "oWnd"      => ::oDlg } )

   TGridImage():Build(  {  "nTop"      => 5,;
                           "nLeft"     => {|| GridWidth( 10.5, ::oDlg ) },;
                           "nWidth"    => 64,;
                           "nHeight"   => 64,;
                           "cResName"  => "flat_check_64",;
                           "bLClicked" => {|| ::oSender:onViewSave() },;
                           "oWnd"      => ::oDlg } )

Return ( self )

//---------------------------------------------------------------------------//

METHOD defineSerie() CLASS ViewEdit

   TGridUrllink():Build(            {  "nTop"      => 40,;
                                       "nLeft"     => {|| GridWidth( 0.5, ::oDlg ) },;
                                       "cURL"      => "Serie",;
                                       "oWnd"      => ::oDlg,;
                                       "oFont"     => oGridFont(),;
                                       "lPixel"    => .t.,;
                                       "nClrInit"  => nGridColor(),;
                                       "nClrOver"  => nGridColor(),;
                                       "nClrVisit" => nGridColor(),;
                                       "bAction"   => {|| ::oSender:isChangeSerieTablet() } } )

   ::getSerie  := TGridGet():Build( {  "nRow"      => 40,;
                                       "nCol"      => {|| GridWidth( 2.5, ::oDlg ) },;
                                       "bSetGet"   => {|u| ::SetGetValue( u, "Serie" ) },;
                                       "oWnd"      => ::oDlg,;
                                       "nWidth"    => {|| GridWidth( 2, ::oDlg ) },;
                                       "nHeight"   => 23,;
                                       "cPict"     => "@!",;
                                       "bWhen"     => {|| ::oSender:lNotZoomMode() },;
                                       "lPixels"   => .t. } )

Return ( self )

//---------------------------------------------------------------------------//

METHOD defineRuta() CLASS ViewEdit

   local aCbxRuta       := { "Domingo", "Lunes", "Martes", "Miércoles", "Jueves", "Viernes", "Sábado", "Todos" }
   local cCbxRuta       := aCbxRuta[ Dow( GetSysDate() ) ]
   local cSayTextRuta

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

   ::oCbxRuta     := TGridComboBox():Build(  {  "nRow"      => 67,;
                                                "nCol"      => {|| GridWidth( 2.5, ::oDlg ) },;
                                                "bSetGet"   => {|u| if( PCount() == 0, cCbxRuta, cCbxRuta := u ) },;
                                                "oWnd"      => ::oDlg,;
                                                "nWidth"    => {|| GridWidth( 2, ::oDlg ) },;
                                                "nHeight"   => 25,;
                                                "aItems"    => aCbxRuta,;
                                                "bWhen"     => {|| ::oSender:lNotZoomMode() },;
                                                "bChange"   => {|| ::oSender:ChangeRuta() } } )

   TGridImage():Build(  {  "nTop"      => 63,;
                           "nLeft"     => {|| GridWidth( 4.5, ::oDlg ) },;
                           "nWidth"    => 64,;
                           "nHeight"   => 64,;
                           "cResName"  => "flat_left_64",;
                           "bLClicked" => {|| ::oSender:priorClient() },;
                           "bWhen"     => {|| ::oSender:lNotZoomMode() },;                           
                           "oWnd"      => ::oDlg } )

   TGridImage():Build(  {  "nTop"      => 63,;
                           "nLeft"     => {|| GridWidth( 6, ::oDlg ) },;
                           "nWidth"    => 64,;
                           "nHeight"   => 64,;
                           "cResName"  => "flat_right_64",;
                           "bLClicked" => {|| ::oSender:nextClient() },;
                           "bWhen"     => {|| ::oSender:lNotZoomMode() },;                           
                           "oWnd"      => ::oDlg } )

   ::getRuta      := TGridGet():Build(    {  "nRow"      => 67,;
                                             "nCol"      => {|| GridWidth( 7, ::oDlg ) },;
                                             "bSetGet"   => {|u| if( PCount() == 0, cSayTextRuta, cSayTextRuta := u ) },;
                                             "oWnd"      => ::oDlg,;
                                             "nWidth"    => {|| GridWidth( 4.5, ::oDlg ) },;
                                             "nHeight"   => 23,;
                                             "bWhen"     => {|| .f. },;
                                             "lPixels"   => .t. } )
   

Return ( self )

//---------------------------------------------------------------------------//

METHOD defineCliente() CLASS ViewEdit

   TGridUrllink():Build({  "nTop"      => 95,;
                           "nLeft"     => {|| GridWidth( 0.5, ::oDlg ) },;
                           "cURL"      => "Cliente",;
                           "oWnd"      => ::oDlg,;
                           "oFont"     => oGridFont(),;
                           "lPixel"    => .t.,;
                           "nClrInit"  => nGridColor(),;
                           "nClrOver"  => nGridColor(),;
                           "nClrVisit" => nGridColor(),;
                           "bAction"   => {|| ::oSender:runGridCustomer() } } )

   ::getCodigoCliente   := TGridGet():Build( {  "nRow"      => 95,;
                                                "nCol"      => {|| GridWidth( 2.5, ::oDlg ) },;
                                                "bSetGet"   => {|u| ::SetGetValue( u, "Cliente" ) },;
                                                "oWnd"      => ::oDlg,;
                                                "nWidth"    => {|| GridWidth( 2, ::oDlg ) },;
                                                "nHeight"   => 23,;
                                                "lPixels"   => .t.,;
                                                "bWhen"     => {|| ::oSender:lNotZoomMode() },;                           
                                                "bValid"    => {|| ::oSender:lValidCliente() } } )
   
   ::oNombreCliente     := TGridGet():Build( {  "nRow"      => 95,;
                                                "nCol"      => {|| GridWidth( 4.5, ::oDlg ) },;
                                                "bSetGet"   => {|u| ::SetGetValue( u, "NombreCliente" ) },;
                                                "oWnd"      => ::oDlg,;
                                                "lPixels"   => .t.,;
                                                "nWidth"    => {|| GridWidth( 7, ::oDlg ) },;
                                                "nHeight"   => 23,;
                                                "bWhen"     => {|| ::oSender:lNotZoomMode() } } )

Return ( self )

//---------------------------------------------------------------------------//

METHOD defineDireccion() CLASS ViewEdit

   TGridUrllink():Build(   {  "nTop"      => 120,;
                              "nLeft"     => {|| GridWidth( 0.5, ::oDlg ) },;
                              "cURL"      => "Dirección",;
                              "oWnd"      => ::oDlg,;
                              "oFont"     => oGridFont(),;
                              "lPixel"    => .t.,;
                              "nClrInit"  => nGridColor(),;
                              "nClrOver"  => nGridColor(),;
                              "nClrVisit" => nGridColor(),;
                              "bWhen"     => {|| ::oSender:lNotZoomMode() },;                           
                              "bAction"   => {|| ::oSender:runGridDirections() } } )

   ::getCodigoDireccion := TGridGet():Build( {  "nRow"      => 120,;
                                                "nCol"      => {|| GridWidth( 2.5, ::oDlg ) },;
                                                "bSetGet"   => {|u| ::SetGetValue( u, "Direccion" ) },;
                                                "oWnd"      => ::oDlg,;
                                                "nWidth"    => {|| GridWidth( 2, ::oDlg ) },;
                                                "nHeight"   => 23,;
                                                "lPixels"   => .t.,;
                                                "bWhen"     => {|| ::oSender:lNotZoomMode() },;                           
                                                "bValid"    => {|| ::oSender:lValidDireccion() } } )

   ::getNombreDireccion := TGridGet():Build( {  "nRow"      => 120,;
                                                "nCol"      => {|| GridWidth( 4.5, ::oDlg ) },;
                                                "bSetGet"   => {|u| if( PCount() == 0, ::textNombreDireccion, ::textNombreDireccion := u ) },;
                                                "oWnd"      => ::oDlg,;
                                                "nWidth"    => {|| GridWidth( 7, ::oDlg ) },;
                                                "lPixels"   => .t.,;
                                                "bWhen"     => {|| ::oSender:lNotZoomMode() },;                           
                                                "nHeight"   => 23 } )

Return ( self )

//---------------------------------------------------------------------------//

METHOD defineBotonesAcciones() CLASS ViewEdit

   TGridImage():Build(  {  "nTop"      => 145,;
                           "nLeft"     => {|| GridWidth( 0.5, ::oDlg ) },;
                           "nWidth"    => 64,;
                           "nHeight"   => 64,;
                           "cResName"  => "flat_add_64",;
                           "bLClicked" => {|| ::oSender:appendDetail(), ::RefreshBrowse() },;
                           "bWhen"     => {|| ::oSender:appendButtonMode() },;                           
                           "oWnd"      => ::oDlg } )

   TGridImage():Build(  {  "nTop"      => 145,;
                           "nLeft"     => {|| GridWidth( 2, ::oDlg ) },;
                           "nWidth"    => 64,;
                           "nHeight"   => 64,;
                           "cResName"  => "flat_edit_64",;
                           "bWhen"     => {|| ::oSender:editButtonMode() },;                           
                           "bLClicked" => {|| ::oSender:EditDetail( ::oBrowse:nArrayAt ), ::RefreshBrowse() },;
                           "oWnd"      => ::oDlg } )

   TGridImage():Build(  {  "nTop"      => 145,;
                           "nLeft"     => {|| GridWidth( 3.5, ::oDlg ) },;
                           "nWidth"    => 64,;
                           "nHeight"   => 64,;
                           "cResName"  => "flat_minus_64",;
                           "bWhen"     => {|| ::oSender:deleteButtonMode() },;                           
                           "bLClicked" => {|| ::oSender:DeleteDetail( ::oBrowse:nArrayAt ), ::RefreshBrowse()},;
                           "oWnd"      => ::oDlg } )

Return ( self )

//---------------------------------------------------------------------------//

METHOD defineBotonesMovimiento() CLASS ViewEdit

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

METHOD defineBrowseLineas() CLASS ViewEdit

   ::defineBotonesAcciones()

   ::defineBotonesMovimiento()

   ::oBrowse                  := TGridIXBrowse():New( ::oDlg )

   ::oBrowse:nTop             := ::oBrowse:EvalRow( 180 )
   ::oBrowse:nLeft            := ::oBrowse:EvalCol( {|| GridWidth( 0.5, ::oDlg ) } )
   ::oBrowse:nWidth           := ::oBrowse:EvalWidth( {|| GridWidth( 11, ::oDlg ) } )
   ::oBrowse:nHeight          := ::oBrowse:EvalHeight( {|| GridHeigth( ::oDlg ) - ::oBrowse:nTop - 10 } )
   ::oBrowse:lFooter          := .t.
   ::oBrowse:nMarqueeStyle    := 6

   ::oBrowse:nHeaderHeight    := 48
   ::oBrowse:nFooterHeight    := 48
   ::oBrowse:nRowHeight       := 96
   ::oBrowse:nDataLines       := 2

   ::oBrowse:SetArray( ::oSender:getLines(), , , .f. )

   if ::oSender:lNotZoomMode()
      ::oBrowse:bLDblClick    := {|| ::oSender:EditDetail( ::oBrowse:nArrayAt ), ::refreshBrowse() }
   end if 

   ::oBrowse:CreateFromCode()

Return ( self )

//---------------------------------------------------------------------------//