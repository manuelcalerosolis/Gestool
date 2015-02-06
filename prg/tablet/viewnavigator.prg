#include "FiveWin.Ch"
#include "Factu.ch" 

CLASS ViewNavigator FROM ViewBase

   DATA oDlg
   DATA oBrowse
   DATA oSender

   DATA aItemsBusqueda
   DATA WorkArea
   
   METHOD New()

   METHOD ResourceViewNavigator()
   
   METHOD BarraBusqueda()
   METHOD SetItemsBusqueda( aItems )   INLINE ( ::aItemsBusqueda := aItems )

   METHOD getComboboxOrden()
   METHOD ChangeComboboxOrden()

   METHOD setBrowseConfigurationName( cName ) ;
                                       INLINE ( if( !empty( ::oViewNavigator ) .and. !empty( ::oViewNavigator:oBrowse ), ::oViewNavigator:oBrowse:cName := cName, ) )

   METHOD setWorkArea( WorkArea )      INLINE ( ::WorkArea := WorkArea )

   METHOD BotonesAcciones()

   METHOD BotonesMovimientoBrowse()

   METHOD BrowseGeneral()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oSender ) CLASS ViewNavigator

   ::oSender   := oSender

Return ( self )

//---------------------------------------------------------------------------//

METHOD ResourceViewNavigator() CLASS ViewNavigator

   ::oDlg                  := TDialog():New( 1, 5, 40, 100, "GESTOOL TABLET",,, .f., ::Style,, rgb( 255, 255, 255 ),,, .F.,, oGridFont(),,,, .f.,, "oDlg" )

   ::TituloBrowse()

   ::BotonSalirBrowse()

   ::BarraBusqueda()

   ::BotonesAcciones()

   ::BotonesMovimientoBrowse()

   ::BrowseGeneral()

   ::oDlg:bResized         := {|| ::DialogResize() }

   ::oDlg:Activate( ,,,.t.,,, {|| ::InitDialog() } )

Return ( self )

//---------------------------------------------------------------------------//

METHOD BotonesAcciones() CLASS ViewNavigator

   TGridImage():Build(  {  "nTop"      => 75,;
                           "nLeft"     => {|| GridWidth( 0.5, ::oDlg ) },;
                           "nWidth"    => 64,;
                           "nHeight"   => 64,;
                           "cResName"  => "flat_add_64",;
                           "bLClicked" => {|| ::oSender:Append() },;
                           "oWnd"      => ::oDlg } )

   TGridImage():Build(  {  "nTop"      => 75,;
                           "nLeft"     => {|| GridWidth( 2, ::oDlg ) },;
                           "nWidth"    => 64,;
                           "nHeight"   => 64,;
                           "cResName"  => "flat_edit_64",;
                           "bLClicked" => {|| ::oSender:Edit() },;
                           "oWnd"      => ::oDlg } )

   TGridImage():Build(  {  "nTop"      => 75,;
                           "nLeft"     => {|| GridWidth( 3.5, ::oDlg ) },;
                           "nWidth"    => 64,;
                           "nHeight"   => 64,;
                           "cResName"  => "flat_minus_64",;
                           "bLClicked" => {|| ::oSender:Delete() },;
                           "oWnd"      => ::oDlg } )

Return ( self )

//---------------------------------------------------------------------------//

METHOD BotonesMovimientoBrowse() CLASS ViewNavigator

   TGridImage():Build(  {  "nTop"      => 75,;
                           "nLeft"     => {|| GridWidth( 7.5, ::oDlg ) },;
                           "nWidth"    => 64,;
                           "nHeight"   => 64,;
                           "cResName"  => "flat_page_up_64",;
                           "bLClicked" => {|| ::oBrowse:PageUp(), ::oBrowse:Select( 0 ), ::oBrowse:Select( 1 ), ::oBrowse:Refresh()  },;
                           "oWnd"      => ::oDlg } )

   TGridImage():Build(  {  "nTop"      => 75,;
                           "nLeft"     => {|| GridWidth( 8.5, ::oDlg ) },;
                           "nWidth"    => 64,;
                           "nHeight"   => 64,;
                           "cResName"  => "flat_up_64",;
                           "bLClicked" => {|| ::oBrowse:GoUp(), ::oBrowse:Select( 0 ), ::oBrowse:Select( 1 ), ::oBrowse:Refresh()  },;
                           "oWnd"      => ::oDlg } )

   TGridImage():Build(  {  "nTop"      => 75,;
                           "nLeft"     => {|| GridWidth( 9.5, ::oDlg ) },;
                           "nWidth"    => 64,;
                           "nHeight"   => 64,;
                           "cResName"  => "flat_down_64",;
                           "bLClicked" => {|| ::oBrowse:GoDown(), ::oBrowse:Select( 0 ), ::oBrowse:Select( 1 ), ::oBrowse:Refresh() },;
                           "oWnd"      => ::oDlg } )

   TGridImage():Build(  {  "nTop"      => 75,;
                           "nLeft"     => {|| GridWidth( 10.5, ::oDlg ) },;
                           "nWidth"    => 64,;
                           "nHeight"   => 64,;
                           "cResName"  => "flat_page_down_64",;
                           "bLClicked" => {|| ::oBrowse:PageDown(), ::oBrowse:Select( 0 ), ::oBrowse:Select( 1 ), ::oBrowse:Refresh() },;
                           "oWnd"      => ::oDlg } )

Return ( self )

//---------------------------------------------------------------------------//

METHOD BarraBusqueda() CLASS ViewNavigator

   local cGetSearch        := Space( 100 )
   local oGetSearch
   local oComboboxOrden
   local cComboboxOrden    := ::getComboboxOrden()

   oGetSearch        := TGridGet():Build(       {  "nRow"      => 45,;
                                                   "nCol"      => {|| GridWidth( 0.5, ::oDlg ) },;
                                                   "bSetGet"   => {|u| if( PCount() == 0, cGetSearch, cGetSearch := u ) },;
                                                   "oWnd"      => ::oDlg,;
                                                   "nWidth"    => {|| GridWidth( 9, ::oDlg ) },;
                                                   "nHeight"   => 25,;
                                                   "bValid"    => {|| OrdClearScope( ::oBrowse, ::WorkArea ) },;
                                                   "bChanged"  => {| nKey, nFlags | AutoSeek( nKey, nFlags, oGetSearch, ::oBrowse, ::WorkArea, .t. ) } } )

   oComboboxOrden    := TGridComboBox():Build(  {  "nRow"      => 45,;
                                                   "nCol"      => {|| GridWidth( 9.5, ::oDlg ) },;
                                                   "bSetGet"   => {|u| if( PCount() == 0, cComboboxOrden, cComboboxOrden := u ) },;
                                                   "oWnd"      => ::oDlg,;
                                                   "nWidth"    => {|| GridWidth( 2, ::oDlg ) },;
                                                   "nHeight"   => 25,;
                                                   "aItems"    => ::aItemsBusqueda,;
                                                   "bChange"   => {|| ::ChangeComboboxOrden( oComboboxOrden, oGetSearch ) } } )

Return ( self )

//---------------------------------------------------------------------------//

METHOD getComboboxOrden() CLASS ViewNavigator

   local cOrden   := ""

   if isArray( ::aItemsBusqueda ) .and. len( ::aItemsBusqueda ) > 1

      cOrden      := ::aItemsBusqueda[1]

   end if

Return ( cOrden )

//---------------------------------------------------------------------------//

METHOD ChangeComboboxOrden( oComboboxOrden, oGetSearch ) CLASS ViewNavigator

   ( ::WorkArea )->( OrdSetFocus( oComboboxOrden:nAt ) )
   
   oGetSearch:SetFocus()

   ::oBrowse:Refresh()

Return ( self )

//---------------------------------------------------------------------------//

METHOD BrowseGeneral() CLASS ViewNavigator

   ::oBrowse                  := TGridIXBrowse():New( ::oDlg )

   ::oBrowse:nTop             := ::oBrowse:EvalRow( 115 )
   ::oBrowse:nLeft            := ::oBrowse:EvalCol( {|| GridWidth( 0.5, ::oDlg ) } )
   ::oBrowse:nWidth           := ::oBrowse:EvalWidth( {|| GridWidth( 11, ::oDlg ) } )
   ::oBrowse:nHeight          := ::oBrowse:EvalHeight( {|| GridHeigth( ::oDlg ) - ::oBrowse:nTop - 10 } )
   ::oBrowse:nMarqueeStyle    := 6

   ::oBrowse:nHeaderHeight    := 48
   ::oBrowse:nFooterHeight    := 48
   ::oBrowse:nRowHeight       := 96
   ::oBrowse:nDataLines       := 2

   ::oBrowse:cAlias           := ::WorkArea

   ::oSender:PropiedadesBrowse()

   ::oBrowse:bLDblClick       := {|| ::oSender:Edit() }

   ::oBrowse:CreateFromCode()

Return ( self )

//---------------------------------------------------------------------------//