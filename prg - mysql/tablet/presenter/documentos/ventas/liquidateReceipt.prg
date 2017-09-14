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

   METHOD ProcessLiquidateReceipt( nEntregado )

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

   local nRec           := ( D():FacturasClientesCobros( ::nView ) )->( Recno() )
   local nOrdAnt        := ( D():FacturasClientesCobros( ::nView ) )->( OrdSetFocus( "lCodCli" ) )
   local nPendiente     := 0

   if ( D():FacturasClientesCobros( ::nView ) )->( dbSeek( ::idCliente ) )

      while ( D():FacturasClientesCobros( ::nView ) )->cCodCli == ::idCliente .and.;
         !( D():FacturasClientesCobros( ::nView ) )->( Eof() ) 

         if !( D():FacturasClientesCobros( ::nView ) )->lDevuelto
            nPendiente  +=  ( D():FacturasClientesCobros( ::nView ) )->nImporte
         end if

         ( D():FacturasClientesCobros( ::nView ) )->( dbskip() )

      end while

   end if

   ( D():FacturasClientesCobros( ::nView ) )->( OrdSetFocus( nOrdAnt ) )
   ( D():FacturasClientesCobros( ::nView ) )->( dbGoTo( nRec ) )

Return ( nPendiente )

//---------------------------------------------------------------------------//

METHOD ProcessLiquidateReceipt( nEntregado ) CLASS LiquidateReceipt

   local nRec        := ( D():FacturasClientesCobros( ::nView ) )->( Recno() )
   local nOrdAnt     := ( D():FacturasClientesCobros( ::nView ) )->( OrdSetFocus( "lCodCli" ) )
   local nRecFac     := ( D():FacturasClientes( ::nView ) )->( Recno() )
   local nOrdFac     := ( D():FacturasClientes( ::nView ) )->( OrdSetFocus( "nNumFac" ) )
   local nPendiente  := 0

   if ( D():FacturasClientesCobros( ::nView ) )->( dbSeek( ::idCliente ) )

      while ( D():FacturasClientesCobros( ::nView ) )->cCodCli == ::idCliente .and.;
         !( D():FacturasClientesCobros( ::nView ) )->( Eof() ) .and.;
         ( nEntregado > 0 )

         if !( D():FacturasClientesCobros( ::nView ) )->lDevuelto

            if ( D():FacturasClientesCobros( ::nView ) )->nImporte <= nEntregado

               if dbLock( D():FacturasClientesCobros( ::nView ) )
                  ( D():FacturasClientesCobros( ::nView ) )->lCobrado   := .t.
                  ( D():FacturasClientesCobros( ::nView ) )->dEntrada   := Date()
                  ( D():FacturasClientesCobros( ::nView ) )->( dbUnLock() )
               end if
               
               nEntregado -= ( D():FacturasClientesCobros( ::nView ) )->nImporte

            else

               LiquidaRecibo( nEntregado, D():FacturasClientesCobros( ::nView ), D():FacturasClientes( ::nView ) )               

               nEntregado := 0

            end if

            if ( D():FacturasClientes( ::nView ) )->( dbSeek( ( D():FacturasClientesCobros( ::nView ) )->cSerie + Str( ( D():FacturasClientesCobros( ::nView ) )->nNumFac ) + ( D():FacturasClientesCobros( ::nView ) )->cSufFac ) )
               
               ChkLqdFacCli( , D():FacturasClientes( ::nView ), D():FacturasClientesLineas( ::nView ), D():FacturasClientesCobros( ::nView ), D():AnticiposClientes( ::nView ), D():TiposIva( ::nView ), D():Divisas( ::nView ) )
               
               if dbLock( D():FacturasClientes( ::nView ) )
                  ( D():FacturasClientes( ::nView ) )->nTotPdt   := ( D():FacturasClientes( ::nView ) )->nTotFac - nPagFacCli( ( D():FacturasClientesCobros( ::nView ) )->cSerie + Str( ( D():FacturasClientesCobros( ::nView ) )->nNumFac ) + ( D():FacturasClientesCobros( ::nView ) )->cSufFac, D():FacturasClientes( ::nView ), D():FacturasClientesCobros( ::nView ), D():TiposIva( ::nView ), D():Divisas( ::nView ) )
                  ( D():FacturasClientes( ::nView ) )->( dbUnLock() )
               end if

            end if

         end if

         ( D():FacturasClientesCobros( ::nView ) )->( dbskip() )

      end while

   end if

   ( D():FacturasClientes( ::nView ) )->( OrdSetFocus( nOrdFac ) )
   ( D():FacturasClientes( ::nView ) )->( dbGoTo( nRecFac ) )
   ( D():FacturasClientesCobros( ::nView ) )->( OrdSetFocus( nOrdAnt ) )
   ( D():FacturasClientesCobros( ::nView ) )->( dbGoTo( nRec ) )

Return ( self )

//---------------------------------------------------------------------------//