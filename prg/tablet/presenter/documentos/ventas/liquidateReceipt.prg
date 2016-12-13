#include "FiveWin.Ch"
#include "Factu.ch"

CLASS LiquidateReceipt FROM DocumentsSales

   DATA oLiquidateReceipt
   DATA idCliente

   METHOD New()

   METHOD play()

   METHOD runNavigator()

   METHOD onPreRunNavigator()    INLINE ( .t. )

   METHOD nTotalPendiente()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( nView, idCliente ) CLASS LiquidateReceipt

   ::nView                 := nView
   ::idCliente             := idCliente

   ::oLiquidateReceipt     := LiquidateReceiptView():New( self )
   ::oLiquidateReceipt:setTitleDocumento( "Liquidación de recibos" )

Return( self )

//---------------------------------------------------------------------------//

METHOD play() CLASS LiquidateReceipt

   if ::onPreRunNavigator()
      ::runNavigator()
   end if

return ( self )

//---------------------------------------------------------------------------//

METHOD runNavigator() CLASS LiquidateReceipt

   if !empty( ::oLiquidateReceipt )
      ::oLiquidateReceipt:Resource()
   end if

Return( self )

//---------------------------------------------------------------------------//

METHOD nTotalPendiente() CLASS LiquidateReceipt

   local nPendiente := 50

   MsgInfo( ::idCliente, "Cliente" )

Return ( nPendiente )

//---------------------------------------------------------------------------//