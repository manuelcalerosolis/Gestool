#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Xbrowse.ch"

CLASS DailySummarySalesView FROM ViewBase

   DATA oFecIni
   DATA dFecIni               INIT GetSysDate()
   DATA oFecFin
   DATA dFecFin               INIT GetSysDate()
   DATA oPedido
   DATA oPedidoTotal
   DATA nPedido               INIT 0
   DATA nPedidoTotal          INIT 0
   DATA oAlbaran
   DATA oAlbaranTotal
   DATA nAlbaran              INIT 0
   DATA nAlbaranTotal         INIT 0
   DATA oFactura
   DATA oFacturaTotal
   DATA nFactura              INIT 0
   DATA nFacturaTotal         INIT 0
   DATA oTotal
   DATA nTotal                INIT 0

   DATA oCbxRango
   DATA aCbxRango             INIT {}
   DATA cCbxRango             INIT "Hoy"

   METHOD New()

   METHOD insertControls()

   METHOD defineAceptarCancelar()

   METHOD defineFechas()

   METHOD defineCabecera()

   METHOD definePedidos()

   METHOD defineAlbaranes()
   
   METHOD defineFacturas()

   METHOD defineTotal()

   METHOD cargaPeriodo()

   METHOD changePeriodo()

   METHOD getTitleTipoDocumento()   INLINE ( ::getTextoTipoDocumento() )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oSender ) CLASS DailySummarySalesView

   ::oSender   := oSender

Return ( self )

//---------------------------------------------------------------------------//

METHOD insertControls() CLASS DailySummarySalesView

   ::cargaPeriodo()

   ::defineFechas()

   ::defineCabecera()

   ::definePedidos()

   ::defineAlbaranes()

   ::defineFacturas()

   ::defineTotal()

   ::oSender:CalculateGeneral()

Return( Self )

//---------------------------------------------------------------------------//

METHOD defineAceptarCancelar() CLASS DailySummarySalesView
   
   TGridImage():Build(  {  "nTop"      => 5,;
                           "nLeft"     => {|| GridWidth( 10.5, ::oDlg ) },;
                           "nWidth"    => 64,;
                           "nHeight"   => 64,;
                           "cResName"  => "gc_ok_64",;
                           "bLClicked" => {|| ::oDlg:End() },;
                           "oWnd"      => ::oDlg } )

Return ( self )

//---------------------------------------------------------------------------//

METHOD defineFechas() CLASS DailySummarySalesView

   ::oCbxRango    := TGridComboBox():Build(  {  "nRow"      => 50,;
                                                "nCol"      => {|| GridWidth( 0.5, ::oDlg ) },;
                                                "bSetGet"   => {|u| if( PCount() == 0, ::cCbxRango, ::cCbxRango := u ) },;
                                                "oWnd"      => ::oDlg,;
                                                "nWidth"    => {|| GridWidth( 3.5, ::oDlg ) },;
                                                "nHeight"   => 25,;
                                                "aItems"    => ::aCbxRango,;
                                                "bChange"   => {|| ::changePeriodo(), ::oSender:CalculateGeneral() } } )

   ::oFecIni      := TGridGet():Build( {        "nRow"      => 50,;
                                                "nCol"      => {|| GridWidth( 5, ::oDlg ) },;
                                                "bSetGet"   => {|u| if( PCount() == 0, ::dFecIni, ::dFecIni := u ) },;
                                                "oWnd"      => ::oDlg,;
                                                "lPixels"   => .t.,;
                                                "nWidth"    => {|| GridWidth( 2.5, ::oDlg ) },;
                                                "nHeight"   => 23,;
                                                "bValid"    => {|| ::oSender:CalculateGeneral(), .t. },;
                                                "lRight"    => .t. } ) 

   ::oFecFin      := TGridGet():Build( {        "nRow"      => 50,;
                                                "nCol"      => {|| GridWidth( 8, ::oDlg ) },;
                                                "bSetGet"   => {|u| if( PCount() == 0, ::dFecFin, ::dFecFin := u ) },;
                                                "oWnd"      => ::oDlg,;
                                                "lPixels"   => .t.,;
                                                "nWidth"    => {|| GridWidth( 2.5, ::oDlg ) },;
                                                "nHeight"   => 23,;
                                                "bValid"    => {|| ::oSender:CalculateGeneral(), .t. },;
                                                "lRight"    => .t. } )

Return ( Self )

//---------------------------------------------------------------------------//

METHOD defineCabecera() CLASS DailySummarySalesView

   
   TGridSay():Build( {  "nRow"      => 87,;
                        "nCol"      => {|| GridWidth( 5, ::oDlg ) },;
                        "bText"     => {|| "Documentos" },;
                        "oWnd"      => ::oDlg,;
                        "oFont"     => oGridFontBold(),;
                        "lPixels"   => .t.,;
                        "nClrText"  => Rgb( 0, 0, 0 ),;
                        "nClrBack"  => Rgb( 255, 255, 255 ),;
                        "nWidth"    => {|| GridWidth( 3, ::oDlg ) },;
                        "nHeight"   => 23,;
                        "lDesign"   => .f. } )


   TGridSay():Build( {  "nRow"      => 87,;
                        "nCol"      => {|| GridWidth( 8, ::oDlg ) },;
                        "bText"     => {|| "Total" },;
                        "oWnd"      => ::oDlg,;
                        "oFont"     => oGridFontBold(),;
                        "lPixels"   => .t.,;
                        "nClrText"  => Rgb( 0, 0, 0 ),;
                        "nClrBack"  => Rgb( 255, 255, 255 ),;
                        "nWidth"    => {|| GridWidth( 1.5, ::oDlg ) },;
                        "nHeight"   => 23,;
                        "lDesign"   => .f. } )

   
Return ( self )

//---------------------------------------------------------------------------//

METHOD definePedidos() CLASS DailySummarySalesView

   //::oSender:CalculatePedido()

   TGridSay():Build( {  "nRow"      => 120,;
                        "nCol"      => {|| GridWidth( 0.5, ::oDlg ) },;
                        "bText"     => {|| "Pedidos de clientes: " },;
                        "oWnd"      => ::oDlg,;
                        "oFont"     => oGridFont(),;
                        "lPixels"   => .t.,;
                        "nClrText"  => Rgb( 0, 0, 0 ),;
                        "nClrBack"  => Rgb( 255, 255, 255 ),;
                        "nWidth"    => {|| GridWidth( 2, ::oDlg ) },;
                        "nHeight"   => 23,;
                        "lDesign"   => .f. } )

   ::oPedido         := TGridGet():Build( {  "nRow"      => 120,;
                                             "nCol"      => {|| GridWidth( 5, ::oDlg ) },;
                                             "bSetGet"   => {|u| if( PCount() == 0, ::nPedido, ::nPedido := u ) },;
                                             "oWnd"      => ::oDlg,;
                                             "lPixels"   => .t.,;
                                             "nWidth"    => {|| GridWidth( 2.5, ::oDlg ) },;
                                             "nHeight"   => 23,;
                                             "lRight"    => .t.,;
                                             "bWhen"     => {|| .f. } } )

   ::oPedidoTotal    := TGridGet():Build( {  "nRow"      => 120,;
                                             "nCol"      => {|| GridWidth( 8, ::oDlg ) },;
                                             "bSetGet"   => {|u| if( PCount() == 0, ::nPedidoTotal, ::nPedidoTotal := u ) },;
                                             "oWnd"      => ::oDlg,;
                                             "lPixels"   => .t.,;
                                             "cPict"     => cPorDiv(),;
                                             "nWidth"    => {|| GridWidth( 2.5, ::oDlg ) },; 
                                             "nHeight"   => 23,;
                                             "lRight"    => .t.,;
                                             "bWhen"     => {|| .f. } } )


Return( Self )

//---------------------------------------------------------------------------//

METHOD defineAlbaranes() CLASS DailySummarySalesView

   //::oSender:CalculateAlbaran()

   TGridSay():Build( {  "nRow"      => 148,;
                        "nCol"      => {|| GridWidth( 0.5, ::oDlg ) },;
                        "bText"     => {|| "Albaranes de clientes: " },;
                        "oWnd"      => ::oDlg,;
                        "oFont"     => oGridFont(),;
                        "lPixels"   => .t.,;
                        "nClrText"  => Rgb( 0, 0, 0 ),;
                        "nClrBack"  => Rgb( 255, 255, 255 ),;
                        "nWidth"    => {|| GridWidth( 2, ::oDlg ) },;
                        "nHeight"   => 23,;
                        "lDesign"   => .f. } )

   ::oAlbaran        := TGridGet():Build( {  "nRow"      => 148,;
                                             "nCol"      => {|| GridWidth( 5, ::oDlg ) },;
                                             "bSetGet"   => {|u| if( PCount() == 0, ::nAlbaran, ::nAlbaran := u ) },;
                                             "oWnd"      => ::oDlg,;
                                             "lPixels"   => .t.,;
                                             "nWidth"    => {|| GridWidth( 2.5, ::oDlg ) },;
                                             "nHeight"   => 23,;
                                             "lRight"    => .t.,;
                                             "bWhen"     => {|| .f. } } )

   ::oAlbaranTotal   := TGridGet():Build( {  "nRow"      => 148,;
                                             "nCol"      => {|| GridWidth( 8, ::oDlg ) },;
                                             "bSetGet"   => {|u| if( PCount() == 0, ::nAlbaranTotal, ::nAlbaranTotal := u ) },;
                                             "oWnd"      => ::oDlg,;
                                             "lPixels"   => .t.,;
                                             "cPict"     => cPorDiv(),;
                                             "nWidth"    => {|| GridWidth( 2.5, ::oDlg ) },;
                                             "nHeight"   => 23,;
                                             "lRight"    => .t.,;
                                             "bWhen"     => {|| .f. } } )


Return( Self )

//---------------------------------------------------------------------------//

METHOD defineFacturas() CLASS DailySummarySalesView

   //::oSender:CalculateFactura()

   TGridSay():Build( {  "nRow"      => 176,;
                        "nCol"      => {|| GridWidth( 0.5, ::oDlg ) },;
                        "bText"     => {|| "Facturas de clientes: " },;
                        "oWnd"      => ::oDlg,;
                        "oFont"     => oGridFont(),;
                        "lPixels"   => .t.,;
                        "nClrText"  => Rgb( 0, 0, 0 ),;
                        "nClrBack"  => Rgb( 255, 255, 255 ),;
                        "nWidth"    => {|| GridWidth( 2, ::oDlg ) },;
                        "nHeight"   => 23,;
                        "lDesign"   => .f. } )

   ::oFactura           := TGridGet():Build( {  "nRow"      => 176,;
                                                "nCol"      => {|| GridWidth( 5, ::oDlg ) },;
                                                "bSetGet"   => {|u| if( PCount() == 0, ::nFactura, ::nFactura := u ) },;
                                                "oWnd"      => ::oDlg,;
                                                "lPixels"   => .t.,;
                                                "nWidth"    => {|| GridWidth( 2.5, ::oDlg ) },;
                                                "nHeight"   => 23,;
                                                "lRight"    => .t.,;
                                                "bWhen"     => {|| .f. } } )

   ::oFacturaTotal      := TGridGet():Build( {  "nRow"      => 176,;
                                                "nCol"      => {|| GridWidth( 8, ::oDlg ) },;
                                                "bSetGet"   => {|u| if( PCount() == 0, ::nFacturaTotal, ::nFacturaTotal := u ) },;
                                                "oWnd"      => ::oDlg,;
                                                "lPixels"   => .t.,;
                                                "cPict"     => cPorDiv(),;
                                                "nWidth"    => {|| GridWidth( 2.5, ::oDlg ) },;
                                                "nHeight"   => 23,;
                                                "lRight"    => .t.,;
                                                "bWhen"     => {|| .f. } } )


Return( Self )

//---------------------------------------------------------------------------//

METHOD defineTotal() CLASS DailySummarySalesView

   //::oSender:CalculateTotal()

   TGridSay():Build(    {  "nRow"      => 204,;
                           "nCol"      => {|| GridWidth( 0.5, ::oDlg ) },;
                           "bText"     => {|| "Totales: " },;
                           "oWnd"      => ::oDlg,;
                           "oFont"     => oGridFontBold(),;
                           "lPixels"   => .t.,;
                           "nClrText"  => Rgb( 0, 0, 0 ),;
                           "nClrBack"  => Rgb( 255, 255, 255 ),;
                           "nWidth"    => {|| GridWidth( 2, ::oDlg ) },;
                           "nHeight"   => 23,;
                           "lDesign"   => .f. } )

   ::oTotal       := TGridGet():Build(   {   "nRow"      => 204,;
                                             "nCol"      => {|| GridWidth( 8, ::oDlg ) },;
                                             "bSetGet"   => {|u| if( PCount() == 0, ::nTotal, ::nTotal := u ) },;
                                             "oWnd"      => ::oDlg,;
                                             "oFont"     => oGridFontBold(),;
                                             "lPixels"   => .t.,;
                                             "cPict"     => cPorDiv(),;
                                             "nWidth"    => {|| GridWidth( 2.5, ::oDlg ) },;
                                             "nHeight"   => 23,;
                                             "lRight"    => .t.,;
                                             "bWhen"     => {|| .f. } } )

Return( Self )

//---------------------------------------------------------------------------//

METHOD cargaPeriodo() CLASS DailySummarySalesView 

   ::aCbxRango                 := {}

   aAdd( ::aCbxRango, "Hoy" )
   aAdd( ::aCbxRango, "Ayer" )
   aAdd( ::aCbxRango, "Mes en curso" )
   aAdd( ::aCbxRango, "Mes anterior" )
   aAdd( ::aCbxRango, "Primer trimestre" )
   aAdd( ::aCbxRango, "Segundo trimestre" )
   aAdd( ::aCbxRango, "Tercer trimestre" )
   aAdd( ::aCbxRango, "Cuatro trimestre" )
   aAdd( ::aCbxRango, "Doce últimos meses" )
   aAdd( ::aCbxRango, "Año en curso" )
   aAdd( ::aCbxRango, "Año anterior" )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD changePeriodo() CLASS DailySummarySalesView

   do case
      case ::cCbxRango == "Hoy"

         ::oFecIni:cText( GetSysDate() )
         ::oFecFin:cText( GetSysDate() )

      case ::cCbxRango == "Ayer"

         ::oFecIni:cText( GetSysDate() -1 )
         ::oFecFin:cText( GetSysDate() -1 )

      case ::cCbxRango == "Mes en curso"

         ::oFecIni:cText( CtoD( "01/" + Str( Month( GetSysDate() ) ) + "/" + Str( Year( GetSysDate() ) ) ) )
         ::oFecFin:cText( GetSysDate() )

      case ::cCbxRango == "Mes anterior"

         ::oFecIni:cText( BoM( addMonth( GetSysDate(), - 1 ) ) )
         ::oFecFin:cText( EoM( addMonth( GetSysDate(), - 1 ) ) )

      case ::cCbxRango == "Primer trimestre"

         ::oFecIni:cText( CtoD( "01/01/" + Str( Year( GetSysDate() ) ) ) )
         ::oFecFin:cText( CtoD( "31/03/" + Str( Year( GetSysDate() ) ) ) )

      case ::cCbxRango == "Segundo trimestre"

         ::oFecIni:cText( CtoD( "01/04/" + Str( Year( GetSysDate() ) ) ) )
         ::oFecFin:cText( CtoD( "30/06/" + Str( Year( GetSysDate() ) ) ) )

      case ::cCbxRango == "Tercer trimestre"

         ::oFecIni:cText( CtoD( "01/07/" + Str( Year( GetSysDate() ) ) ) )
         ::oFecFin:cText( CtoD( "30/09/" + Str( Year( GetSysDate() ) ) ) )

      case ::cCbxRango == "Cuatro trimestre"

         ::oFecIni:cText( CtoD( "01/10/" + Str( Year( GetSysDate() ) ) ) )
         ::oFecFin:cText( CtoD( "31/12/" + Str( Year( GetSysDate() ) ) ) )

      case ::cCbxRango == "Doce últimos meses"

         ::oFecIni:cText( BoY( GetSysDate() ) )
         ::oFecFin:cText( EoY( GetSysDate() ) )

      case ::cCbxRango == "Año en curso"

         ::oFecIni:cText( CtoD( "01/01/" + Str( Year( GetSysDate() ) ) ) )
         ::oFecFin:cText( CtoD( "31/12/" + Str( Year( GetSysDate() ) ) ) )

      case ::cCbxRango == "Año anterior"

         ::oFecIni:cText( CtoD( "01/01/" + Str( Year( GetSysDate() ) - 1 ) ) )
         ::oFecFin:cText( CtoD( "31/12/" + Str( Year( GetSysDate() ) - 1 ) ) )

   end case

RETURN ( .t. )

//---------------------------------------------------------------------------//