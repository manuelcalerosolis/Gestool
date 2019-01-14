#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS PresupuestosVentasRepository FROM OperacionesComercialesRepository

   METHOD getTableName()               INLINE ( SQLPresupuestosVentasModel():getTableName() ) 

   METHOD getLinesTableName()          INLINE ( SQLPresupuestosVentasLineasModel():getTableName() )

   METHOD getDiscountsTableName()      INLINE ( SQLPresupuestosVentasDescuentosModel():getTableName() )

   METHOD getPackage( cContext )       INLINE ( SQLPresupuestosVentasModel():getPackage( cContext ) )

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
  
