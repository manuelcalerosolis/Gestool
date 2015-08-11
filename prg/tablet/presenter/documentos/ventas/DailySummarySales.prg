#include "FiveWin.Ch"
#include "Factu.ch"

CLASS DailySummarySales FROM DocumentsSales

   DATA oDailySummarySales

   METHOD New()

   METHOD runNavigator()

   METHOD CalculatePedido()

   METHOD CalculateAlbaran()

   METHOD CalculateFactura()

   METHOD CalculateTotal()

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

METHOD New() CLASS DailySummarySales

   if !::OpenFiles()
      Return ( self )
   end if 

   ::oDailySummarySales    := DailySummarySalesView():New( self )
   ::oDailySummarySales:setTextoTipoDocumento( "Resumen de ventas diario" )

Return( self )

//---------------------------------------------------------------------------//

METHOD runNavigator() CLASS DailySummarySales

   if !empty( ::oDailySummarySales )
      ::oDailySummarySales:Resource()
   end if

   ::CloseFiles()

Return( self )

//---------------------------------------------------------------------------//

METHOD CalculatePedido() CLASS DailySummarySales

   ::oDailySummarySales:oPedido                 := 0
   ::oDailySummarySales:oPedidoTotal            := 0

   D():getStatusPedidosClientes( ::nView )

   ( D():PedidosClientes( ::nView ) )->( ordSetFocus( "DFECPED" ) )

   while ( D():PedidosClientes( ::nView ) )->dFecPed == getSysDate() .and. !( D():PedidosClientes( ::nView ) )->( eof() )

         ::oDailySummarySales:oPedido           += 1 

         ::oDailySummarySales:oPedidoTotal      += ( D():PedidosClientes( ::nView ) )->nTotped
      
         ( D():PedidosClientes( ::nView ) )->( dbSkip() ) 
      
   end while

   D():setStatusPedidosClientes( ::nView )

Return( self )

//---------------------------------------------------------------------------//

METHOD CalculateAlbaran() CLASS DailySummarySales

   ::oDailySummarySales:oAlbaran                := 0
   ::oDailySummarySales:oAlbaranTotal           := 0

Return( self )

//---------------------------------------------------------------------------//

METHOD CalculateFactura() CLASS DailySummarySales

   ::oDailySummarySales:oFactura                := 0
   ::oDailySummarySales:oFacturaTotal           := 0

    D():getStatusFacturasClientes( ::nView )

   ( D():FacturasClientes( ::nView ) )->( ordSetFocus( "DFECFAC" ) )

   if ( D():FacturasClientes( ::nView ) )->( dbSeek( getSysDate() ) )

      while ( D():FacturasClientes( ::nView ) )->dFecFac == getSysDate() .and. !( D():FacturasClientes( ::nView ) )->( eof() )

         ::oDailySummarySales:oFactura           += 1 

         ::oDailySummarySales:oFacturaTotal      += ( D():FacturasClientes( ::nView ) )->nTotFac
      
         ( D():FacturasClientes( ::nView ) )->( dbSkip() ) 
      
      end while

   end if

   D():setStatusFacturasClientes( ::nView )

Return( self )

//---------------------------------------------------------------------------//

METHOD CalculateTotal() CLASS DailySummarySales

   ::oDailySummarySales:oTotal        := 0

   ::oDailySummarySales:oTotal        += ::oDailySummarySales:oPedidoTotal
   ::oDailySummarySales:oTotal        += ::oDailySummarySales:oAlbaranTotal
   ::oDailySummarySales:oTotal        += ::oDailySummarySales:oFacturaTotal

Return( self )

//---------------------------------------------------------------------------//