#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS PedidosComprasRepository FROM OperacionesComercialesRepository

   METHOD getTableName()               INLINE ( SQLPedidosComprasModel():getTableName() ) 

   METHOD getLinesTableName()          INLINE ( SQLPedidosComprasLineasModel():getTableName() )

   METHOD getDiscountsTableName()      INLINE ( SQLPedidosComprasDescuentosModel():getTableName() )

   METHOD getPackage( cContext )       INLINE ( SQLPedidosComprasModel():getPackage( cContext ) )

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//