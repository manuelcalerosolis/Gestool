#include "FiveWin.Ch"
#include "Factu.ch" 

CLASS Documento FROM Editable

   DATA Style           INIT ( nOR( DS_MODALFRAME, WS_POPUP, WS_CAPTION, WS_SYSMENU, WS_MINIMIZEBOX, WS_MAXIMIZEBOX ) )
   DATA oBrowse
   
   METHOD New()

   METHOD ResourceBrowse()
   METHOD DialogResize()
   METHOD InitDialog()

   METHOD TituloBrowse()
   METHOD cTextoTipoDocumento()  VIRTUAL

   METHOD BotonSalirBrowse()

   METHOD BarraBusqueda()
   METHOD aItemsBusqueda()       VIRTUAL
   METHOD getComboboxOrden()
   METHOD ChangeComboboxOrden()

   METHOD BotonesAcciones()

   METHOD BotonesMovimientoBrowse()

   METHOD BrowseGeneral()
   METHOD PropiedadesBrowse()    VIRTUAL

END CLASS

//---------------------------------------------------------------------------//

METHOD New()

   ::oThis  := self

Return ( self )

//---------------------------------------------------------------------------//

METHOD ResourceBrowse() CLASS Documento

   ::oDlg  := TDialog():New( 1, 5, 40, 100, "GESTOOL TABLET",,, .f., ::Style,, rgb( 255, 255, 255 ),,, .F.,, oGridFont(),,,, .f.,, "oDlg" )

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

METHOD DialogResize() CLASS Documento

   GridResize( ::oDlg )

Return ( self )

//---------------------------------------------------------------------------//

METHOD InitDialog() CLASS Documento

   GridMaximize( ::oDlg )

Return ( self )

//---------------------------------------------------------------------------//

METHOD TituloBrowse() CLASS Documento 

   TGridSay():Build(    {  "nRow"      => 0,;
                           "nCol"      => {|| GridWidth( 0.5, ::oDlg ) },;
                           "bText"     => {|| ::cTextoTipoDocumento() },;
                           "oWnd"      => ::oDlg,;
                           "oFont"     => oGridFontBold(),;
                           "lPixels"   => .t.,;
                           "nClrText"  => Rgb( 0, 0, 0 ),;
                           "nClrBack"  => Rgb( 255, 255, 255 ),;
                           "nWidth"    => {|| GridWidth( 8, ::oDlg ) },;
                           "nHeight"   => 32,;
                           "lDesign"   => .f. } )

Return ( self )

//---------------------------------------------------------------------------//

METHOD BotonSalirBrowse() CLASS Documento

   TGridImage():Build(  {  "nTop"      => 5,;
                           "nLeft"     => {|| GridWidth( 10.5, ::oDlg ) },;
                           "nWidth"    => 64,;
                           "nHeight"   => 64,;
                           "cResName"  => "flat_end_64",;
                           "bLClicked" => {|| ::oDlg:End() },;
                           "oWnd"      => ::oDlg } )

Return ( self )

//---------------------------------------------------------------------------//

METHOD BotonesAcciones() CLASS Documento

   TGridImage():Build(  {  "nTop"      => 75,;
                           "nLeft"     => {|| GridWidth( 0.5, ::oDlg ) },;
                           "nWidth"    => 64,;
                           "nHeight"   => 64,;
                           "cResName"  => "flat_add_64",;
                           "bLClicked" => {|| ::Append() },;
                           "oWnd"      => ::oDlg } )

   TGridImage():Build(  {  "nTop"      => 75,;
                           "nLeft"     => {|| GridWidth( 2, ::oDlg ) },;
                           "nWidth"    => 64,;
                           "nHeight"   => 64,;
                           "cResName"  => "flat_edit_64",;
                           "bLClicked" => {|| ::Edit() },;
                           "oWnd"      => ::oDlg } )

   TGridImage():Build(  {  "nTop"      => 75,;
                           "nLeft"     => {|| GridWidth( 3.5, ::oDlg ) },;
                           "nWidth"    => 64,;
                           "nHeight"   => 64,;
                           "cResName"  => "flat_minus_64",;
                           "bLClicked" => {|| ::Delete() },;
                           "oWnd"      => ::oDlg } )

Return ( self )

//---------------------------------------------------------------------------//

METHOD BotonesMovimientoBrowse() CLASS Documento

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

METHOD BarraBusqueda() CLASS Documento

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
                                                   "bValid"    => {|| OrdClearScope( ::oBrowse, ::getWorkArea() ) },;
                                                   "bChanged"  => {| nKey, nFlags | AutoSeek( nKey, nFlags, oGetSearch, ::oBrowse, ::getWorkArea(), .t. ) } } )

   oComboboxOrden    := TGridComboBox():Build(  {  "nRow"      => 45,;
                                                   "nCol"      => {|| GridWidth( 9.5, ::oDlg ) },;
                                                   "bSetGet"   => {|u| if( PCount() == 0, cComboboxOrden, cComboboxOrden := u ) },;
                                                   "oWnd"      => ::oDlg,;
                                                   "nWidth"    => {|| GridWidth( 2, ::oDlg ) },;
                                                   "nHeight"   => 25,;
                                                   "aItems"    => ::aItemsBusqueda(),;
                                                   "bChange"   => {|| ::ChangeComboboxOrden( oComboboxOrden, oGetSearch ) } } )

Return ( self )

//---------------------------------------------------------------------------//

METHOD getComboboxOrden() CLASS Documento

   local cOrden   := ""

   if isArray( ::aItemsBusqueda() ) .and. len( ::aItemsBusqueda() ) > 1

      cOrden      := ::aItemsBusqueda()[1]

   end if

Return ( cOrden )

//---------------------------------------------------------------------------//

METHOD ChangeComboboxOrden( oComboboxOrden, oGetSearch ) CLASS Documento

   ( ::getWorkArea )->( OrdSetFocus( oComboboxOrden:nAt ) )
   
   oGetSearch:SetFocus()

   ::oBrowse:Refresh()

Return ( self )

//---------------------------------------------------------------------------//

METHOD BrowseGeneral() CLASS Documento

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

   ::oBrowse:cAlias           := ::getWorkArea()

   ::PropiedadesBrowse()

   ::oBrowse:CreateFromCode()

Return ( self )

//---------------------------------------------------------------------------//