#include "FiveWin.Ch"
#include "Factu.ch" 

CLASS ReceiptDocumentSalesViewSearchNavigator FROM ViewSearchNavigator

   DATA buttonPrint

   DATA comboboxFilter
   DATA cComboboxFilter                   INIT "Pendientes delegación"
   DATA aComboboxFilter                   INIT { "Todos delegación", "Pendientes delegación", "Cobrados delegación", "Todos", "Pendientes", "Cobrados" }

   METHOD getDataTable()                  INLINE ( ::oSender:getDataTable() )

   METHOD getView()                       INLINE ( ::oSender:nView )

   METHOD setItemsBusqueda()              INLINE ( ::hashItemsSearch := { "Fecha" => "dFecDes", "Número" => 1, "Código" => "cCodCli", "Nombre" => "cNomCli", "Importe" => "nImporte" } )   

   METHOD setColumns()

   METHOD getField( cField )              INLINE ( D():getFieldDictionary( cField, ::getDataTable(), ::getView() ) )

   METHOD BotonesAcciones()

   METHOD ChangeFilter()

   METHOD defineBarraBusqueda()

   METHOD validBarraBusqueda()            INLINE ( .t. )   

   METHOD defineSalir()

END CLASS

//---------------------------------------------------------------------------//

METHOD setColumns() CLASS ReceiptDocumentSalesViewSearchNavigator

   ::setBrowseConfigurationName( "grid_recibos" )

   ::oBrowse:bClrSel         := {|| { if( !::getField( "LogicoCobrado" ), Rgb( 255, 0, 0 ), CLR_BLACK ), Rgb( 229, 229, 229 ) } }
   ::oBrowse:bClrSelFocus    := {|| { if( !::getField( "LogicoCobrado" ), Rgb( 255, 0, 0 ), CLR_BLACK ), Rgb( 167, 205, 240 ) } }
   ::oBrowse:bClrStd         := {|| { if( !::getField( "LogicoCobrado" ), Rgb( 255, 0, 0 ), CLR_BLACK ), GetSysColor( COLOR_WINDOW ) } }

   with object ( ::addColumn() )
      :cHeader           := "Id"
      :bEditValue        := {|| ::getField( "Serie" ) + "/" + alltrim( str( ::getField( "Numero" ) ) ) + "-" + alltrim( str( ::getField( "NumeroRecibo" ) ) ) }
      :nWidth            := 150
   end with

   with object ( ::addColumn() )
      :cHeader           := "Exp./Vto."
      :bEditValue        := {|| dtoc( ::getField( "FechaExpedicion" ) ) + CRLF + dtoc( ::getField( "FechaVencimiento" ) ) }
      :nWidth            := 160
   end with

   with object ( ::addColumn() )
      :cHeader           := "Cliente"
      :bEditValue        := {|| alltrim( ::getField( "Cliente" ) ) + CRLF + alltrim( ::getField( "NombreCliente" ) ) }
      :nWidth            := 200
   end with

   with object ( ::addColumn() )
      :cHeader           := "Importe"
      :bEditValue        := {|| ::getField( "TotalDocumento" ) }
      :cEditPicture      := cPorDiv()
      :nWidth            := 155
      :nDataStrAlign     := 1
      :nHeadStrAlign     := 1
   end with

Return ( self )

//---------------------------------------------------------------------------//

METHOD BotonesAcciones() CLASS ReceiptDocumentSalesViewSearchNavigator

   if ::oSender:lAlowEdit

      TGridImage():Build(  {  "nTop"      => 75,;
                              "nLeft"     => {|| GridWidth( 0.5, ::oDlg ) },;
                              "nWidth"    => 64,;
                              "nHeight"   => 64,;
                              "cResName"  => "gc_pencil_64",;
                              "bLClicked" => {|| ::oSender:Edit() },;
                              "oWnd"      => ::oDlg } )

      
      if ::oSender:lShowFilterCobrado

         ::comboboxFilter     := TGridComboBox():Build(  {  "nRow"      => 75,;
                                                            "nCol"      => {|| GridWidth( 1.5, ::oDlg ) },;
                                                            "bSetGet"   => {|u| if( PCount() == 0, ::cComboboxFilter, ::cComboboxFilter := u ) },;
                                                            "oWnd"      => ::oDlg,;
                                                            "nWidth"    => {|| GridWidth( 4.5, ::oDlg ) },;
                                                            "nHeight"   => 25,;
                                                            "aItems"    => ::aComboboxFilter,;
                                                            "bChange"   => {|| ::ChangeFilter() } } )

      end if

   end if 

   ::oDlg:bStart     := {|| ::ChangeFilter() }

Return ( self )

//---------------------------------------------------------------------------//

METHOD ChangeFilter() CLASS ReceiptDocumentSalesViewSearchNavigator

   local cText    := ""

   if ::oSender:lShowFilterCobrado

      ::oSender:FilterTable( ::cComboboxFilter )

   end if


Return ( .t. )

//---------------------------------------------------------------------------//

METHOD defineSalir() CLASS ReceiptDocumentSalesViewSearchNavigator

   ::buttonPrint     :=    TGridImage():Build(  {  "nTop"      => 5,;
                                                   "nLeft"     => {|| GridWidth( 9, ::oDlg ) },;
                                                   "nWidth"    => 64,;
                                                   "nHeight"   => 64,;
                                                   "cResName"  => "gc_printer_64",;
                                                   "bLClicked" => {|| ::oSender:printReceipt() },;
                                                   "oWnd"      => ::oDlg } )

   ::buttonEnd       :=    TGridImage():Build(  {  "nTop"      => 5,;
                                                   "nLeft"     => {|| GridWidth( 10.5, ::oDlg ) },;
                                                   "nWidth"    => 64,;
                                                   "nHeight"   => 64,;
                                                   "cResName"  => "gc_door_open_64",;
                                                   "bLClicked" => {|| ::oDlg:End() },;
                                                   "oWnd"      => ::oDlg } )

Return ( self )

//---------------------------------------------------------------------------//

METHOD defineBarraBusqueda() CLASS ReceiptDocumentSalesViewSearchNavigator

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
                                                   "bChanged"  => {| nKey, nFlags | AutoSeek( nKey, nFlags, ::getSearch, ::oBrowse, ::getWorkArea(), .t., , .f. ) } } )

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

