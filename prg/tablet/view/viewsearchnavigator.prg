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
   
   METHOD defineBarraBusqueda()

   METHOD getComboboxOrden()
      METHOD changeComboboxOrden()

   METHOD setSelectorMode()            INLINE ( ::lSelectorMode  := .t. )

   METHOD isEndOk()                    INLINE ( ::oDlg:nResult == IDOK )

   METHOD validBarraBusqueda()         INLINE ( OrdClearScope( ::oBrowse, ::getWorkArea() ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oSender ) CLASS ViewSearchNavigator

   ::oSender   := oSender

   ::bDblClickBrowseGeneral      := {|| ::oSender:Edit(), ::refreshBrowse() }

   ::setTextoTipoDocumento()

   ::setItemsBusqueda()

Return ( self )

//---------------------------------------------------------------------------//

METHOD Resource() CLASS ViewSearchNavigator

   ::oDlg                  := TDialog():New( 1, 5, 40, 100, "GESTOOL TABLET",,, .f., ::Style,, rgb( 255, 255, 255 ),,, .F.,, oGridFont(),,,, .f.,, "oDlg" )

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

   ::oDlg:bResized         := {|| ::resizeDialog() }

   ::oDlg:Activate( ,,,.t.,,, {|| ::initDialog() } )

Return ( self )

//---------------------------------------------------------------------------//

METHOD initDialog()

   ::Super:initDialog()

   ::changeComboboxOrden()

Return ( self )

//---------------------------------------------------------------------------//

METHOD defineBarraBusqueda() CLASS ViewSearchNavigator

   local cGetSearch
   local cComboboxOrden

   cGetSearch        := Space( 100 )
   cComboboxOrden    := ::getComboboxOrden()

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
                                                   "bChange"   => {|| ::ChangeComboboxOrden() } } )

Return ( self )

//---------------------------------------------------------------------------//

METHOD getComboboxOrden() CLASS ViewSearchNavigator

   local cOrden   := ""

   if isHash( ::hashItemsSearch ) .and. len( ::hashItemsSearch ) > 1
      cOrden      := hgetkeyat( ::hashItemsSearch, 1 )
   end if

Return ( cOrden )

//---------------------------------------------------------------------------//

METHOD changeComboboxOrden() CLASS ViewSearchNavigator

   local textComboboxSearch   := ::comboboxSearch:varGet() 

   if !empty(textComboboxSearch)
      ( ::getWorkArea() )->( ordsetfocus( ::hashItemsSearch[ textComboboxSearch ] ) )
   end if 

   ::getSearch:SetFocus()

   ::oBrowse:Refresh()

Return ( self )

//---------------------------------------------------------------------------//