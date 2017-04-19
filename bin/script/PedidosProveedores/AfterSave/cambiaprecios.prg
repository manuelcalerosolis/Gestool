#include "FiveWin.Ch"
#include "Factu.Ch"

//---------------------------------------------------------------------------//

function updatePrecios( nView, cSerie, nNumero, cSufijo, nMode )

   local cArea    := "LineasPedidosProveedor"
   local nRecAnt  := ( D():PedidosProveedoresLineas( nView ) )->( Recno() )
   local nOrdAnt  := ( D():PedidosProveedoresLineas( nView ) )->( OrdSetFocus( "cPedRef" ) )
   local aTotPed

   //if nMode != APPD_MODE
      //Return nil
   //end if

   PedidosProveedoresModel():selectLineasById( cSerie, nNumero, cSufijo, @cArea )

   ( cArea )->( dbGoTop() )

   while !( cArea )->( Eof() )

      if ( D():PedidosProveedoresLineas( nView ) )->( dbSeek( ( cArea )->cRef + ( cArea )->cCodPr1 + ( cArea )->cCodPr2 + ( cArea )->cValPr1 + ( cArea )->cValPr2 + ( cArea )->cLote ) )

         while ( cArea )->cRef + ( cArea )->cCodPr1 + ( cArea )->cCodPr2 + ( cArea )->cValPr1 + ( cArea )->cValPr2 + ( cArea )->cLote == ( D():PedidosProveedoresLineas( nView ) )->cRef + ( D():PedidosProveedoresLineas( nView ) )->cCodPr1 + ( D():PedidosProveedoresLineas( nView ) )->cCodPr2 + ( D():PedidosProveedoresLineas( nView ) )->cValPr1 + ( D():PedidosProveedoresLineas( nView ) )->cValPr2 + ( D():PedidosProveedoresLineas( nView ) )->cLote .and.;
               !( D():PedidosProveedoresLineas( nView ) )->( Eof() )

            if ( D():PedidosProveedores( nView ) )->( dbSeek( ( D():PedidosProveedoresLineas( nView ) )->cSerPed + Str( ( D():PedidosProveedoresLineas( nView ) )->nNumPed ) + ( D():PedidosProveedoresLineas( nView ) )->cSufPed ) ) .and.;
               ( D():PedidosProveedores( nView ) )->cSerPed + Str( ( D():PedidosProveedores( nView ) )->nNumPed ) + ( D():PedidosProveedores( nView ) )->cSufPed != cSerie + Str( nNumero ) + cSufijo .and.;
               ( D():PedidosProveedores( nView ) )->nEstado != 3

               if dbLock( D():PedidosProveedoresLineas( nView ) )
                  ( D():PedidosProveedoresLineas( nView ) )->nPreDiv := ( cArea )->nPreDiv
                  ( D():PedidosProveedoresLineas( nView ) )->( dbUnlock() )
               end if

               aTotPed  := aTotPedPrv( ( D():PedidosProveedoresLineas( nView ) )->cSerPed + Str( ( D():PedidosProveedoresLineas( nView ) )->nNumPed ) + ( D():PedidosProveedoresLineas( nView ) )->cSufPed, D():PedidosProveedores( nView ), D():PedidosProveedoresLineas( nView ), D():TiposIva( nView ), D():Divisas( nView ) )

               if dbLock( D():PedidosProveedores( nView ) )
                  ( D():PedidosProveedores( nView ) )->nTotNet := aTotPed[1]
                  ( D():PedidosProveedores( nView ) )->nTotIva := aTotPed[2]
                  ( D():PedidosProveedores( nView ) )->nTotReq := aTotPed[3]
                  ( D():PedidosProveedores( nView ) )->nTotPed := aTotPed[4]
                  ( D():PedidosProveedores( nView ) )->( dbUnlock() )
               end if   

            end if

            ( D():PedidosProveedoresLineas( nView ) )->( dbSkip() )

         end while

      end if

      ( cArea )->( dbSkip() )

   end while

   ( D():PedidosProveedoresLineas( nView ) )->( OrdSetFocus( nOrdAnt ) )
   ( D():PedidosProveedoresLineas( nView ) )->( dbGoTo( nRecAnt ) )

return nil

//---------------------------------------------------------------------------//