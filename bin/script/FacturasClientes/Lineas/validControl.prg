#include "factu.ch"

//---------------------------------------------------------------------------//

Function validControl( oSender, aGet, nView, nMode, aTmpFac )

   local nBultos
   local nCajasArticulos

   /*if ( nMode != APPD_MODE .and. nMode != DUPL_MODE )
      return .t.
   end if */

   if aTmpFac[ ( D():FacturasClientes( nView ) )->( fieldpos( "cSerie" ) ) ] != "A"
      return .t.
   end if 
	
   if ( oSender:cargo == "nBultos" )

      nBultos            := aGet[ ( D():FacturasClientesLineas( nView ) )->( fieldpos( "nBultos" ) ) ]:varget()

      nCajasArticulos   := ( D():Articulos( nView ) )->nCajEnt

      if nCajasArticulos != 0
         aGet[ ( D():FacturasClientesLineas( nView ) )->( fieldpos( "nCanEnt" ) ) ]:varPut( nBultos * nCajasArticulos )
         aGet[ ( D():FacturasClientesLineas( nView ) )->( fieldpos( "nCanEnt" ) ) ]:refresh()
      end if 

   end if 

Return ( .t. )

//---------------------------------------------------------------------------//

