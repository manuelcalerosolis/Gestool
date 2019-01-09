#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS FacturasComprasRectificativasRepository FROM OperacionesComercialesRepository

   METHOD getTableName()               INLINE ( SQLFacturasComprasRectificativasModel():getTableName() ) 

   METHOD getLinesTableName()          INLINE ( SQLFacturasComprasRectificativasLineasModel():getTableName() )

   METHOD getDiscountsTableName()      INLINE ( SQLFacturasComprasRectificativasDescuentosModel():getTableName() )

   METHOD getPackage( cContext )       INLINE ( SQLFacturasComprasRectificativasModel():getPackage( cContext ) )

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
  
