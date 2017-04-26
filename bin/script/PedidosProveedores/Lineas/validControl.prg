#include "factu.ch"

//---------------------------------------------------------------------------//

Function validControl( oSender, aGet, nView, nMode, aTmpPed )

   local nCajas
   local nCajasArticulos
   local nKilosArticulos

   /*if ( nMode != APPD_MODE .and. nMode != DUPL_MODE )
      return .t.
   end if */

   if aTmpPed[ ( D():PedidosProveedores( nView ) )->( fieldpos( "cSerPed" ) ) ] != "A"
      return .t.
   end if 
	
   if ( oSender:cargo == "nCanPed" )

      nCajas            := aGet[ ( D():PedidosProveedoresLineas( nView ) )->( fieldpos( "nCanPed" ) ) ]:varget()

      nCajasArticulos   := ( D():Articulos( nView ) )->nCajEnt
      nKilosArticulos   := ( D():Articulos( nView ) )->nPesoKg

      if nCajasArticulos != 0
         aGet[ ( D():PedidosProveedoresLineas( nView ) )->( fieldpos( "nBultos" ) ) ]:varPut( nCajas / nCajasArticulos )
         aGet[ ( D():PedidosProveedoresLineas( nView ) )->( fieldpos( "nBultos" ) ) ]:refresh()
      end if 

      if nKilosArticulos != 0
         aGet[ ( D():PedidosProveedoresLineas( nView ) )->( fieldpos( "nUniCaja" ) ) ]:varPut( nCajas * nKilosArticulos )
         aGet[ ( D():PedidosProveedoresLineas( nView ) )->( fieldpos( "nUniCaja" ) ) ]:refresh()
      end if 

   end if 

Return ( .t. )

//---------------------------------------------------------------------------//

