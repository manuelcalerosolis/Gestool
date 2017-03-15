#include "factu.ch"

//---------------------------------------------------------------------------//

Function validControl( oSender, aGet, nView, nMode )

   if ( nMode != APPD_MODE )
      return .f.
   end if 
	
   if ( oSender:cargo == "nUniCaja" )

      msgalert( "soy nUniCaja" )

      aGet[ ( D():PedidosProveedoresLineas( nView ) )->( fieldpos( "nPreDiv" ) ) ]:varPut( 9999 )
      aGet[ ( D():PedidosProveedoresLineas( nView ) )->( fieldpos( "nPreDiv" ) ) ]:refresh()

   end if 

Return ( .t. )

//---------------------------------------------------------------------------//

