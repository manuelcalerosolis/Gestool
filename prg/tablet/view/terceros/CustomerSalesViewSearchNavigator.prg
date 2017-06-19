#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Xbrowse.ch"

CLASS CustomerSalesViewSearchNavigator FROM DocumentSalesViewSearchNavigator

   DATA oSayFilter

   METHOD getDataTable()                  INLINE ( "FacCliT" )
   METHOD getWorkArea()                   INLINE ( D():FacturasClientes( ::getView() ) )

   METHOD botonesAcciones()

   METHOD getTitleDocumento()             INLINE ( "Facturas cliente" )

   METHOD ChangeFilter()

   METHOD Resource()

   METHOD setColumns()

END CLASS

//---------------------------------------------------------------------------//

METHOD botonesAcciones()   CLASS CustomerSalesViewSearchNavigator


   TGridImage():Build(  {  "nTop"      => 75,;
                           "nLeft"     => {|| GridWidth( 0.5, ::oDlg ) },;
                           "nWidth"    => 64,;
                           "nHeight"   => 64,;
                           "cResName"  => "gc_safe_into_64",;
                           "bLClicked" => {|| LiquidateReceipt():New( ::oSender:nView, ::oSender:cIdCliente ):Play(), ::oSender:RefreshBrowseCustomerSales( ::oSayFilter:cCaption ) },;  
                           "oWnd"      => ::oDlg } )

   TGridImage():Build(  {  "nTop"      => 75,;
                           "nLeft"     => {|| GridWidth( 1.5, ::oDlg ) },;
                           "nWidth"    => 64,;
                           "nHeight"   => 64,;
                           "cResName"  => "gc_money2_64",;
                           "bLClicked" => {|| ::oSender:liqInvoice( ::getField( "Serie" ) + str( ::getField( "Numero" ) ) + ::getField( "Sufijo" ) ), ::oSender:RefreshBrowseCustomerSales( ::oSayFilter:cCaption ) },;
                           "oWnd"      => ::oDlg } )

   TGridImage():Build(  {  "nTop"      => 75,;
                           "nLeft"     => {|| GridWidth( 2.5, ::oDlg ) },;
                           "nWidth"    => 64,;
                           "nHeight"   => 64,;
                           "cResName"  => "gc_funnel_64",;
                           "bLClicked" => {|| ::ChangeFilter() },;
                           "oWnd"      => ::oDlg } )

   ::oSayFilter  := TGridSay():Build(  {  "nRow"      => 75,;
                                          "nCol"      => {|| GridWidth( 3.5, ::oDlg ) },;
                                          "bText"     => {|| "" },;
                                          "oWnd"      => ::oDlg,;
                                          "oFont"     => oGridFont(),;
                                          "lPixels"   => .t.,;
                                          "nClrText"  => Rgb( 0, 0, 0 ),;
                                          "nClrBack"  => Rgb( 255, 255, 255 ),;
                                          "nWidth"    => {|| GridWidth( 3, ::oDlg ) },;
                                          "nHeight"   => 23,;
                                          "lDesign"   => .f. } )

   ::oDlg:bStart     := {|| ::ChangeFilter() }

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD ChangeFilter() CLASS CustomerSalesViewSearchNavigator

   local cText    := ""

   do case
      case ::oSayFilter:cCaption == ""
         cText    := "Pendientes"

      case ::oSayFilter:cCaption == "Cobradas"
         cText    := "Todas"

      case ::oSayFilter:cCaption == "Pendientes"
         cText    := "Cobradas"

      case ::oSayFilter:cCaption == "Todas"
         cText    := "Pendientes"

   end case

   ::oSayFilter:VarPut( cText )
   ::oSayFilter:Refresh()   

   ::oSender:FilterSalesCustomerTable( ::oSayFilter:cCaption )

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD Resource() CLASS CustomerSalesViewSearchNavigator

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
   
   ::oBrowse:bLDblClick       := {|| ::oSender:visualizaFactura( ::getField( "Serie" ) + str( ::getField( "Numero" ) ) + ::getField( "Sufijo" ) ) }

   ::oDlg:bResized            := {|| ::resizeDialog() }

   ::oDlg:Activate( , , , .t., , , {|| ::initDialog() } )

   ::endDialog()

Return ( self )

//---------------------------------------------------------------------------//

METHOD setColumns() CLASS CustomerSalesViewSearchNavigator

   ::setBrowseConfigurationName( "grid_ventasclientes" )

   with object ( ::addColumn() )
      :cHeader           := "Id"
      :bEditValue        := {|| ::getField( "Serie" ) + "/" + alltrim( str( ::getField( "Numero" ) ) ) + CRLF + dtoc( ::getField( "Fecha" ) ) }
      :nWidth            := 165
   end with

   with object ( ::addColumn() )
      :cHeader           := "Cliente"
      :bEditValue        := {|| alltrim( ::getField( "Cliente" ) ) + CRLF + alltrim( ::getField( "NombreCliente" ) ) }
      :nWidth            := 310
   end with

   with object ( ::addColumn() )
      :cHeader           := "Agente"
      :bEditValue        := {|| ::getField( "Agente" ) }
      :nWidth            := 100
      :lHide             := .t.
   end with

   with object ( ::addColumn() )
      :cHeader           := "Base"
      :bEditValue        := {|| ::getField( "TotalNeto" ) }
      :cEditPicture      := cPorDiv()
      :nWidth            := 100
      :nDataStrAlign     := 1
      :nHeadStrAlign     := 1
      :lHide             := .t.
   end with

   with object ( ::addColumn() )
      :cHeader           := cImp()
      :bEditValue        := {|| ::getField( "TotalImpuesto" ) }
      :cEditPicture      := cPorDiv()
      :nWidth            := 100
      :nDataStrAlign     := 1
      :nHeadStrAlign     := 1
      :lHide             := .t.
   end with

   with object ( ::addColumn() )
      :cHeader           := "R.E."
      :bEditValue        := {|| ::getField( "TotalRecargo" ) }
      :cEditPicture      := cPorDiv()
      :nWidth            := 100
      :nDataStrAlign     := 1
      :nHeadStrAlign     := 1
      :lHide             := .t.
   end with

   with object ( ::addColumn() )
      :cHeader           := "Tot/Pdt."
      :bEditValue        := {|| Trans( ::getField( "TotalDocumento" ), cPorDiv() ) + CRLF + Trans( nTotPdtFacCli( ::getField( "Serie" ) + str( ::getField( "Numero" ) ) + ::getField( "Sufijo" ), D():FacturasClientes( ::oSender:nView ), D():FacturasClientesLineas( ::oSender:nView ), D():TiposIva( ::oSender:nView ), D():Divisas( ::oSender:nView ), D():FacturasClientesCobros( ::oSender:nView ), D():AnticiposClientes( ::oSender:nView ) ), cPorDiv() ) }
      :nWidth            := 155
      :nDataStrAlign     := 1
      :nHeadStrAlign     := 1
   end with

Return ( self )

//---------------------------------------------------------------------------//