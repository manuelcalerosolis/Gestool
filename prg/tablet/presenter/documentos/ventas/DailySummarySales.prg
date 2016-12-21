#include "FiveWin.Ch"
#include "Factu.ch"

CLASS DailySummarySales FROM DocumentsSales

   DATA oDailySummarySales

   DATA cAgente

   METHOD New()

   METHOD runNavigator()

   METHOD CalculatePedido()

   METHOD CalculateAlbaran()

   METHOD CalculateFactura()

   METHOD CalculateTotal()

   METHOD CalculateGeneral()

   METHOD onPreRunNavigator()    INLINE ( .t. )

END CLASS

//---------------------------------------------------------------------------//

METHOD New() CLASS DailySummarySales

   ::cAgente               := GetPvProfString( "Tablet", "Agente", "", cIniAplication() )

   if !::OpenFiles()
      Return ( self )
   end if 

   ::oDailySummarySales    := DailySummarySalesView():New( self )
   ::oDailySummarySales:setTitleDocumento( "Resumen de ventas diario" )

Return( self )

//---------------------------------------------------------------------------//

METHOD runNavigator() CLASS DailySummarySales

   if !empty( ::oDailySummarySales )
      ::oDailySummarySales:Resource()
   end if

Return( self )

//---------------------------------------------------------------------------//

METHOD CalculatePedido() CLASS DailySummarySales

   ::oDailySummarySales:nPedido                 := 0
   ::oDailySummarySales:nPedidoTotal            := 0

   D():getStatusPedidosClientes( ::nView )

   ( D():PedidosClientes( ::nView ) )->( ordSetFocus( "DFECPED" ) )

   while !( D():PedidosClientes( ::nView ) )->( eof() )

      if ( ( D():PedidosClientes( ::nView ) )->dFecPed >= ::oDailySummarySales:dFecIni .and. ( D():PedidosClientes( ::nView ) )->dFecPed <= ::oDailySummarySales:dFecFin ) .and.;
         ( Empty( ::cAgente ) .or. ( D():PedidosClientes( ::nView ) )->cCodAge == ::cAgente )

         ::oDailySummarySales:nPedido           += 1 

         ::oDailySummarySales:nPedidoTotal      += ( D():PedidosClientes( ::nView ) )->nTotPed

      end if
   
      ( D():PedidosClientes( ::nView ) )->( dbSkip() ) 
   
   end while

   D():setStatusPedidosClientes( ::nView )

Return( self )

//---------------------------------------------------------------------------//

METHOD CalculateAlbaran() CLASS DailySummarySales

   ::oDailySummarySales:nAlbaran                := 0
   ::oDailySummarySales:nAlbaranTotal           := 0

   D():getStatusAlbaranesClientes( ::nView )

   ( D():AlbaranesClientes( ::nView ) )->( ordSetFocus( "DFECALB" ) )

   while !( D():AlbaranesClientes( ::nView ) )->( eof() )

      if ( ( D():AlbaranesClientes( ::nView ) )->dFecAlb >= ::oDailySummarySales:dFecIni .and. ( D():AlbaranesClientes( ::nView ) )->dFecAlb <= ::oDailySummarySales:dFecFin ) .and.;
         ( Empty( ::cAgente ) .or. ( D():AlbaranesClientes( ::nView ) )->cCodAge == ::cAgente )

         ::oDailySummarySales:nAlbaran           += 1 

         ::oDailySummarySales:nAlbaranTotal      += ( D():AlbaranesClientes( ::nView ) )->nTotAlb

      end if
   
      ( D():AlbaranesClientes( ::nView ) )->( dbSkip() ) 
   
   end while

   D():setStatusAlbaranesClientes( ::nView )

Return( self )

//---------------------------------------------------------------------------//

METHOD CalculateFactura() CLASS DailySummarySales

   ::oDailySummarySales:nFactura                := 0
   ::oDailySummarySales:nFacturaTotal           := 0

   D():getStatusFacturasClientes( ::nView )

   ( D():FacturasClientes( ::nView ) )->( ordSetFocus( "DFECFAC" ) )

   while !( D():FacturasClientes( ::nView ) )->( eof() )

      if ( ( D():FacturasClientes( ::nView ) )->dFecFac >= ::oDailySummarySales:dFecIni .and. ( D():FacturasClientes( ::nView ) )->dFecFac <= ::oDailySummarySales:dFecFin ) .and.;
         ( Empty( ::cAgente ) .or. ( D():FacturasClientes( ::nView ) )->cCodAge == ::cAgente )

         ::oDailySummarySales:nFactura           += 1 

         ::oDailySummarySales:nFacturaTotal      += ( D():FacturasClientes( ::nView ) )->nTotFac

      end if
   
      ( D():FacturasClientes( ::nView ) )->( dbSkip() ) 
   
   end while

   D():setStatusFacturasClientes( ::nView )

Return( self )

//---------------------------------------------------------------------------//

METHOD CalculateTotal() CLASS DailySummarySales

   ::oDailySummarySales:nTotal        := 0

   ::oDailySummarySales:nTotal        += ::oDailySummarySales:nPedidoTotal
   ::oDailySummarySales:nTotal        += ::oDailySummarySales:nAlbaranTotal
   ::oDailySummarySales:nTotal        += ::oDailySummarySales:nFacturaTotal

   ::oDailySummarySales:oPedido:Refresh()
   ::oDailySummarySales:oAlbaran:Refresh()
   ::oDailySummarySales:oFactura:Refresh()

   ::oDailySummarySales:oPedidoTotal:Refresh()
   ::oDailySummarySales:oAlbaranTotal:Refresh()
   ::oDailySummarySales:oFacturaTotal:Refresh()
   ::oDailySummarySales:oTotal:Refresh()

Return( self )

//---------------------------------------------------------------------------//

METHOD CalculateGeneral() CLASS DailySummarySales

   ::CalculatePedido()
   ::CalculateAlbaran()
   ::CalculateFactura()
   ::CalculateTotal()

Return ( Self )

//---------------------------------------------------------------------------//