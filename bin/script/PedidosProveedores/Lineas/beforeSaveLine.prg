#include "factu.ch"

// Campo Extra de lineas de pedidos de proveedor 
// 

//---------------------------------------------------------------------------//

Function beforeSaveLine( aTmp, aGet, nView, nMode, aTmpPed )

   local uValor

   if aTmpPed[ ( D():PedidosProveedores( nView ) )->( fieldpos( "cSerPed" ) ) ] != "B"
      return .t.
   end if

   MsgInfo( "Entramos en el Script" )
   
Return ( .t. )

//---------------------------------------------------------------------------//