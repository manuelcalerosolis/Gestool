#include "factu.ch"

//---------------------------------------------------------------------------//

Function validControl( oSender, aGet, nView, nMode, aTmpAlb )

   local nBultos
   local nCajasArticulos

   /*if ( nMode != APPD_MODE .and. nMode != DUPL_MODE )
      return .t.
   end if */

   if aTmpAlb[ ( D():AlbaranesClientes( nView ) )->( fieldpos( "cSerAlb" ) ) ] != "A"
      return .t.
   end if 
	
   if ( oSender:cargo == "nBultos" )

      nBultos            := aGet[ ( D():AlbaranesClientesLineas( nView ) )->( fieldpos( "nBultos" ) ) ]:varget()

      nCajasArticulos   := ( D():Articulos( nView ) )->nCajEnt

      if nCajasArticulos != 0
         aGet[ ( D():AlbaranesClientesLineas( nView ) )->( fieldpos( "nCanEnt" ) ) ]:varPut( nBultos * nCajasArticulos )
         aGet[ ( D():AlbaranesClientesLineas( nView ) )->( fieldpos( "nCanEnt" ) ) ]:refresh()
      end if 

   end if 

Return ( .t. )

//---------------------------------------------------------------------------//

