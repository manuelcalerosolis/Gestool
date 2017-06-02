#include "factu.ch"

//---------------------------------------------------------------------------//

Function validControl( oSender, aGet, nView, nMode, aTmpFac )

   local nCajas
   local nCajasArticulos
   local nKilosArticulos

   /*if ( nMode != APPD_MODE .and. nMode != DUPL_MODE )
      return .t.
   end if */

   if aTmpFac[ ( D():FacturasClientes( nView ) )->( fieldpos( "cSerie" ) ) ] != "A"
      return .t.
   end if 
	
   if ( oSender:cargo == "nCanEnt" )

      nCajas            := aGet[ ( D():FacturasClientesLineas( nView ) )->( fieldpos( "nCanEnt" ) ) ]:varget()

      nCajasArticulos   := ( D():Articulos( nView ) )->nCajEnt
      nKilosArticulos   := ( D():Articulos( nView ) )->nPesoKg

      if nCajasArticulos != 0
         aGet[ ( D():FacturasClientesLineas( nView ) )->( fieldpos( "nBultos" ) ) ]:varPut( nCajas / nCajasArticulos )
         aGet[ ( D():FacturasClientesLineas( nView ) )->( fieldpos( "nBultos" ) ) ]:refresh()
      end if 

      if nKilosArticulos != 0
         aGet[ ( D():FacturasClientesLineas( nView ) )->( fieldpos( "nUniCaja" ) ) ]:varPut( nCajas * nKilosArticulos )
         aGet[ ( D():FacturasClientesLineas( nView ) )->( fieldpos( "nUniCaja" ) ) ]:refresh()
      end if 

   end if 

Return ( .t. )

//---------------------------------------------------------------------------//

