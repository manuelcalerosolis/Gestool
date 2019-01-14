#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS PresupuestosComprasRepository FROM OperacionesComercialesRepository

   METHOD getTableName()               INLINE ( SQLPresupuestosComprasModel():getTableName() ) 

   METHOD getLinesTableName()          INLINE ( SQLPresupuestosComprasLineasModel():getTableName() )

   METHOD getDiscountsTableName()      INLINE ( SQLPresupuestosComprasDescuentosModel():getTableName() )

   METHOD getPackage( cContext )       INLINE ( SQLPresupuestosComprasModel():getPackage( cContext ) )

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//