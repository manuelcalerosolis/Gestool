#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS PedidosVentasRepository FROM OperacionesComercialesRepository

   METHOD getTableName()               INLINE ( SQLPedidosVentasModel():getTableName() ) 

   METHOD getLinesTableName()          INLINE ( SQLPedidosVentasLineasModel():getTableName() )

   METHOD getDiscountsTableName()      INLINE ( SQLPedidosVentasDescuentosModel():getTableName() )

   METHOD getPackage( cContext )       INLINE ( SQLPedidosVentasModel():getPackage( cContext ) )

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
  
