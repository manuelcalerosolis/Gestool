#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS FacturasComprasRepository FROM OperacionesComercialesRepository

   METHOD getTableName()               INLINE ( SQLFacturasComprasModel():getTableName() ) 

   METHOD getLinesTableName()          INLINE ( SQLFacturasComprasLineasModel():getTableName() )

   METHOD getDiscountsTableName()      INLINE ( SQLFacturasComprasDescuentosModel():getTableName() )

   METHOD getPackage( cContext )       INLINE ( SQLFacturasComprasModel():getPackage( cContext ) )

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//