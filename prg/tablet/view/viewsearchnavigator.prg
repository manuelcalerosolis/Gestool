#include "FiveWin.Ch"
#include "Factu.ch" 

CLASS ViewSearchNavigator FROM ViewNavigator

   DATA lSelectorMode                  INIT .f.

   DATA getSearch
   DATA comboboxSearch

   DATA hashItemsSearch
   DATA aOrderBusqueda

   METHOD New( oSender )

   METHOD setItemsBusqueda()           VIRTUAL

   METHOD Resource()
      METHOD initDialog()
      METHOD validDialog()
   
   METHOD defineBarraBusqueda()

   METHOD getComboboxOrden()           INLINE ( if( !empty( ::comboboxSearch ), ::comboboxSearch:varGet(), "" ) )
   METHOD setComboboxOrden( cOrden )   INLINE ( if( !empty( ::comboboxSearch ), ( ::comboboxSearch:set( cOrden ), ::changeComboboxOrden() ), ) )

   METHOD getInitialComboboxOrden()
      METHOD changeComboboxOrden()

   METHOD changeComboboxSearch()       INLINE ( ::changeComboboxOrden(), ::getSearch:setFocus(), ::refreshBrowse() )

   METHOD restoreStatusComboboxSearch()
   METHOD saveStatusComboboxSearch()   INLINE ( setGridOrder( ::getBrowseConfigurationName(), ::getComboboxOrden() ) )

   METHOD setSelectorMode()            INLINE ( ::lSelectorMode  := .t. )

   METHOD isEndOk()                    INLINE ( ::oDlg:nResult == IDOK )

   METHOD validBarraBusqueda()         INLINE ( ordClearScope( ::oBrowse, ::getWorkArea() ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oSender ) CLASS ViewSearchNavigator

   ::oSender                  := oSender

   ::setDblClickBrowseGeneral( {|| if( ::oSender:lAlowEdit, ::oSender:Edit(), ::oSender:Zoom() ), ::refreshBrowse() } )

   ::setItemsBusqueda()

Return ( self )

//---------------------------------------------------------------------------//

METHOD Resource() CLASS ViewSearchNavigator

   ::oDlg                     := TDialog():New( 1, 5, 40, 100, "GESTOOL TABLET",,, .f., ::Style,, rgb( 255, 255, 255 ),,, .F.,, oGridFont(),,,, .f.,, "oDlg" )

   ::defineTitulo()

   if ::lSelectorMode
      ::defineAceptarCancelar()
   else
      ::defineSalir()
   end if

   ::defineBarraBusqueda()

   ::botonesAcciones()

   ::botonesMovimientoBrowse()

   ::browseGeneral()

   ::oDlg:bResized            := {|| ::resizeDialog() }

   ::oDlg:Activate( , , ,.t., {|| ::validDialog() },, {|| ::initDialog() } )

   ::endDialog()

Return ( self )

//---------------------------------------------------------------------------//

METHOD initDialog() CLASS ViewSearchNavigator

   ::Super:initDialog()

   ::oSender:initDialog()

   ::restoreStatusComboboxSearch()

   ::refreshBrowse()

Return ( self )

//---------------------------------------------------------------------------//

METHOD validDialog() CLASS ViewSearchNavigator

   ::saveStatusComboboxSearch()

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD defineBarraBusqueda() CLASS ViewSearchNavigator

   local cGetSearch
   local cComboboxOrden

   cGetSearch        := Space( 100 )
   cComboboxOrden    := ::getInitialComboboxOrden()

   ::getSearch       := TGridGet():Build(       {  "nRow"      => 45,;
                                                   "nCol"      => {|| GridWidth( 0.5, ::oDlg ) },;
                                                   "bSetGet"   => {|u| if( PCount() == 0, cGetSearch, cGetSearch := u ) },;
                                                   "oWnd"      => ::oDlg,;
                                                   "nWidth"    => {|| GridWidth( 9, ::oDlg ) },;
                                                   "nHeight"   => 25,;
                                                   "bValid"    => {|| ::validBarraBusqueda() },;
                                                   "bChanged"  => {| nKey, nFlags | AutoSeek( nKey, nFlags, ::getSearch, ::oBrowse, ::getWorkArea(), .t. ) } } )

   ::comboboxSearch  := TGridComboBox():Build(  {  "nRow"      => 45,;
                                                   "nCol"      => {|| GridWidth( 9.5, ::oDlg ) },;
                                                   "bSetGet"   => {|u| if( PCount() == 0, cComboboxOrden, cComboboxOrden := u ) },;
                                                   "oWnd"      => ::oDlg,;
                                                   "nWidth"    => {|| GridWidth( 2, ::oDlg ) },;
                                                   "nHeight"   => 25,;
                                                   "aItems"    => hGetKeys( ::hashItemsSearch ),;
                                                   "bChange"   => {|| ::changeComboboxSearch() } } )

Return ( self )

//---------------------------------------------------------------------------//

METHOD getInitialComboboxOrden() CLASS ViewSearchNavigator

   local cOrden   := ""

   if isHash( ::hashItemsSearch ) .and. len( ::hashItemsSearch ) > 1
      cOrden      := hgetkeyat( ::hashItemsSearch, 1 )
   end if

Return ( cOrden )

//---------------------------------------------------------------------------//

METHOD changeComboboxOrden() CLASS ViewSearchNavigator

   local textComboboxSearch   :=  ::getComboboxOrden()

   if !empty( textComboboxSearch )
      ( ::getWorkArea() )->( ordsetfocus( ::hashItemsSearch[ textComboboxSearch ] ) )
   end if 

Return ( self )

//---------------------------------------------------------------------------//

METHOD restoreStatusComboboxSearch()

   local gridOrder            := getGridOrder( ::getBrowseConfigurationName() )

   if !empty( gridOrder )
      ::setComboboxOrden( gridOrder ) 
   else 
      ::changeComboboxOrden()
   end if 

   ( ::getWorkArea() )->( dbgotop() )

Return ( self )

//---------------------------------------------------------------------------//

