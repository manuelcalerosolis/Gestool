#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Xbrowse.ch"

CLASS ViewReporting FROM ViewBase

   DATA oDlg
   DATA oSender
   DATA hInformes

   DATA oBtnInformesArticulos
   DATA oBtnInformesClientes

   DATA oBrowse

   METHOD New()

   METHOD Resource()

   METHOD defineBotonSalir()

   METHOD defineBotonesGenerales()
   
   METHOD defineBrowseReporting()

   METHOD defineBotonesMovimiento()

   METHOD changeTypeReporting( cType )

   METHOD loadHashReport()

   METHOD loadHashReportArticulo()

   METHOD loadHashReportCliente()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oSender ) CLASS ViewReporting

   ::oSender      := oSender

   ::hInformes    := {=>}

Return ( self )

//---------------------------------------------------------------------------//

METHOD Resource() CLASS ViewReporting

   ::loadHashReport()

   ::resetRow()

   ::oDlg                  := TDialog():New( 1, 5, 40, 100, "GESTOOL TABLET",,, .f., ::Style,, rgb( 255, 255, 255 ),,, .F.,, oGridFont(),,,, .f.,, "oDlg" )

   ::defineTitulo()

   ::defineBotonSalir()

   ::defineBotonesGenerales()

   ::defineBotonesMovimiento()

   ::defineBrowseReporting()

   ::oDlg:bResized         := {|| ::resizeDialog() }

   ::oDlg:Activate( ,,,.t.,,, {|| ::InitDialog() } )

Return ( ::oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//
                  
METHOD defineBotonSalir() CLASS ViewReporting

   TGridImage():Build(  {  "nTop"      => 5,;
                           "nLeft"     => {|| GridWidth( 7.5, ::oDlg ) },;
                           "nWidth"    => 64,;
                           "nHeight"   => 64,;
                           "cResName"  => "gc_monitor_64",;
                           "bLClicked" => {|| ::oSender:ExecuteReporting( ::hInformes[ ::oBrowse:nArrayAt ], IS_SCREEN ) },;
                           "oWnd"      => ::oDlg } )

   TGridImage():Build(  {  "nTop"      => 5,;
                           "nLeft"     => {|| GridWidth( 9, ::oDlg ) },;
                           "nWidth"    => 64,;
                           "nHeight"   => 64,;
                           "cResName"  => "gc_printer_64",;
                           "bLClicked" => {|| ::oSender:ExecuteReporting( ::hInformes[ ::oBrowse:nArrayAt ], IS_PRINTER ) },;
                           "oWnd"      => ::oDlg } )

   TGridImage():Build(  {  "nTop"      => 5,;
                           "nLeft"     => {|| GridWidth( 10.5, ::oDlg ) },;
                           "nWidth"    => 64,;
                           "nHeight"   => 64,;
                           "cResName"  => "gc_door_open_64",;
                           "bLClicked" => {|| ::oDlg:End() },;
                           "oWnd"      => ::oDlg } )

Return ( self )

//---------------------------------------------------------------------------//

METHOD defineBotonesGenerales() CLASS ViewReporting

   ::oBtnInformesArticulos := TGridImage():Build(  {  "nTop"      => 45,;
                                                      "nLeft"     => {|| GridWidth( 0.5, ::oDlg ) },;
                                                      "nWidth"    => 64,;
                                                      "nHeight"   => 64,;
                                                      "cResName"  => "gc_object_cube_cabinet_open_64",;
                                                      "bLClicked" => {|| ::changeTypeReporting( ART_TBL ), ::loadHashReport() },;
                                                      "oWnd"      => ::oDlg } )

   ::oBtnInformesClientes  := TGridImage():Build(  {  "nTop"      => 45,;
                                                      "nLeft"     => {|| GridWidth( 2, ::oDlg ) },;
                                                      "nWidth"    => 64,;
                                                      "nHeight"   => 64,;
                                                      "cResName"  => "gc_user_cabinet_open_64",;
                                                      "bLClicked" => {|| ::changeTypeReporting( CLI_TBL ), ::loadHashReport() },;
                                                      "oWnd"      => ::oDlg } )

Return ( self )

//---------------------------------------------------------------------------//

METHOD defineBrowseReporting() CLASS ViewReporting

   ::oBrowse                  := TGridIXBrowse():New( ::oDlg )

   ::oBrowse:nTop             := ::oBrowse:EvalRow( 85 )
   ::oBrowse:nLeft            := ::oBrowse:EvalCol( {|| GridWidth( 0.5, ::oDlg ) } )
   ::oBrowse:nWidth           := ::oBrowse:EvalWidth( {|| GridWidth( 11, ::oDlg ) } )
   ::oBrowse:nHeight          := ::oBrowse:EvalHeight( {|| GridHeigth( ::oDlg ) - ::oBrowse:nTop - 10 } )
   ::oBrowse:nMarqueeStyle    := 6

   with object ( ::oBrowse:AddCol() )
      :cHeader                := "Informe"
      :bStrData               := {|| hGet( ::hInformes[ ::oBrowse:nArrayAt ], "cReportName" ) }
      :nWidth                 := 800
   end with

   ::oBrowse:bLDblClick       := {|| ::oSender:ExecuteReporting( ::hInformes[ ::oBrowse:nArrayAt ] ) }

   ::oBrowse:nHeaderHeight    := 48
   ::oBrowse:nFooterHeight    := 48
   ::oBrowse:nRowHeight       := 96
   ::oBrowse:nDataLines       := 2

   ::oBrowse:SetArray( ::hInformes, , , .f. )

   ::oBrowse:CreateFromCode()

Return ( self )

//---------------------------------------------------------------------------//

METHOD defineBotonesMovimiento() CLASS ViewReporting

   TGridImage():Build(  {  "nTop"      => 45,;
                           "nLeft"     => {|| GridWidth( 7.5, ::oDlg ) },;
                           "nWidth"    => 64,;
                           "nHeight"   => 64,;
                           "cResName"  => "gc_navigate_up2_64",;
                           "bLClicked" => {|| ::oBrowse:PageUp(), ::oBrowse:Select( 0 ), ::oBrowse:Select( 1 ), ::oBrowse:Refresh()  },;
                           "oWnd"      => ::oDlg } )

   TGridImage():Build(  {  "nTop"      => 45,;
                           "nLeft"     => {|| GridWidth( 8.5, ::oDlg ) },;
                           "nWidth"    => 64,;
                           "nHeight"   => 64,;
                           "cResName"  => "gc_navigate_up_64",;
                           "bLClicked" => {|| ::oBrowse:GoUp(), ::oBrowse:Select( 0 ), ::oBrowse:Select( 1 ), ::oBrowse:Refresh()  },;
                           "oWnd"      => ::oDlg } )

   TGridImage():Build(  {  "nTop"      => 45,;
                           "nLeft"     => {|| GridWidth( 9.5, ::oDlg ) },;
                           "nWidth"    => 64,;
                           "nHeight"   => 64,;
                           "cResName"  => "gc_navigate_down_64",;
                           "bLClicked" => {|| ::oBrowse:GoDown(), ::oBrowse:Select( 0 ), ::oBrowse:Select( 1 ), ::oBrowse:Refresh() },;
                           "oWnd"      => ::oDlg } )

   TGridImage():Build(  {  "nTop"      => 45,;
                           "nLeft"     => {|| GridWidth( 10.5, ::oDlg ) },;
                           "nWidth"    => 64,;
                           "nHeight"   => 64,;
                           "cResName"  => "gc_navigate_down2_64",;
                           "bLClicked" => {|| ::oBrowse:PageDown(), ::oBrowse:Select( 0 ), ::oBrowse:Select( 1 ), ::oBrowse:Refresh() },;
                           "oWnd"      => ::oDlg } )

Return ( self ) 

//---------------------------------------------------------------------------//

METHOD changeTypeReporting( cType ) CLASS ViewReporting

   ::oSender:cReportType      := cType

   if ::oSender:cReportType == ART_TBL
      ::oSayTitle:VarPut( "Galería de informes: Artículos" )
      ::oSayTitle:Refresh()
   end if

   if ::oSender:cReportType == CLI_TBL
      ::oSayTitle:VarPut( "Galería de informes: Clientes" )
      ::oSayTitle:Refresh()
   end if

Return ( self ) 

//---------------------------------------------------------------------------//

METHOD loadHashReport() CLASS ViewReporting

   if ::oSender:cReportType == ART_TBL
      ::loadHashReportArticulo()
   end if

   if ::oSender:cReportType == CLI_TBL
      ::loadHashReportCliente()
   end if

   if !Empty( ::oBrowse )
      ::oBrowse:SetArray( ::hInformes, , , .f. )
      ::oBrowse:Select( 0 )
      ::oBrowse:Select( 1 )
      ::oBrowse:Refresh()
   end if

Return ( self ) 

//---------------------------------------------------------------------------//

METHOD loadHashReportArticulo() CLASS ViewReporting

   ::hInformes    := {  {  "cReportType" => "Stocks",;
                           "cReportDirectory" => cPatReporting() + "Articulos\Existencias\Stocks",;
                           "cReportName" => "Stocks artículos tablet",;
                           "cReportFile" => cPatReporting() + "Articulos\Existencias\Stocks\Stocks artículos tablet.fr3" } }

Return ( self ) 

//---------------------------------------------------------------------------//

METHOD loadHashReportCliente() CLASS ViewReporting

   ::hInformes    := {  {  "cReportType" => "Recibos cobro",;
                           "cReportDirectory" => cPatReporting() + "Clientes\Ventas\RecibosCobro",;
                           "cReportName" => "Diario recibos tablet",;
                           "cReportFile" => cPatReporting() + "Clientes\Ventas\RecibosCobro\Diario recibos tablet.fr3" },;
                        {  "cReportType" => "Facturas de clientes",;
                           "cReportDirectory" => cPatReporting() + "Clientes\Ventas\Facturas de clientes",;
                           "cReportName" => "Diario facturas tablet",;
                           "cReportFile" => cPatReporting() + "Clientes\Ventas\Facturas de clientes\Diario facturas tablet.fr3" },;
                        {  "cReportType" => "Ventas",;
                           "cReportDirectory" => cPatReporting() + "Clientes\Ventas\Ventas",;
                           "cReportName" => "Diario ventas tablet",;
                           "cReportFile" => cPatReporting() + "Clientes\Ventas\Ventas\Diario ventas tablet.fr3" } }

Return ( self ) 

//---------------------------------------------------------------------------//