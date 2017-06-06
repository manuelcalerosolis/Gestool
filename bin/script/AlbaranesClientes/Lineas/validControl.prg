#include "factu.ch"

//---------------------------------------------------------------------------//

Function validControl( oSender, aGet, nView, nMode, aTmpAlb )

   local nCajas
   local nCajasArticulos
   local nKilosArticulos

   /*if ( nMode != APPD_MODE .and. nMode != DUPL_MODE )
      return .t.
   end if */

   if aTmpAlb[ ( D():AlbaranesClientes( nView ) )->( fieldpos( "cSerAlb" ) ) ] != "A"
      return .t.
   end if 
	
   if ( oSender:cargo == "nCanEnt" )

      nCajas            := aGet[ ( D():AlbaranesClientesLineas( nView ) )->( fieldpos( "nCanEnt" ) ) ]:varget()

      nCajasArticulos   := ( D():Articulos( nView ) )->nCajEnt
      nKilosArticulos   := ( D():Articulos( nView ) )->nPesoKg

      if nCajasArticulos != 0
         aGet[ ( D():AlbaranesClientesLineas( nView ) )->( fieldpos( "nBultos" ) ) ]:varPut( nCajas / nCajasArticulos )
         aGet[ ( D():AlbaranesClientesLineas( nView ) )->( fieldpos( "nBultos" ) ) ]:refresh()
      end if 

      if nKilosArticulos != 0
         aGet[ ( D():AlbaranesClientesLineas( nView ) )->( fieldpos( "nUniCaja" ) ) ]:varPut( nCajas * nKilosArticulos )
         aGet[ ( D():AlbaranesClientesLineas( nView ) )->( fieldpos( "nUniCaja" ) ) ]:refresh()
      end if 

   end if 

Return ( .t. )

//---------------------------------------------------------------------------//

