#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS FacturasVentasRectificativasRepository FROM OperacionesComercialesRepository

   METHOD getTableName()               INLINE ( SQLFacturasVentasRectificativasModel():getTableName() ) 

   METHOD getLinesTableName()          INLINE ( SQLFacturasVentasRectificativasLineasModel():getTableName() )

   METHOD getDiscountsTableName()      INLINE ( SQLFacturasVentasRectificativasDescuentosModel():getTableName() )

   METHOD getPackage( cContext )       INLINE ( SQLFacturasVentasRectificativasModel():getPackage( cContext ) )

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
  
