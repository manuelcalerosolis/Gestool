#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS FacturasVentasRectificativasRepository FROM OperacionesComercialesRepository

   METHOD getTableName()               INLINE ( SQLFacturasVentasRectificativasModel():getTableName() ) 

   METHOD getLinesTableName()          INLINE ( SQLFacturasVentasLineasModel():getTableName() )

   METHOD getDiscountsTableName()      INLINE ( SQLFacturasVentasDescuentosModel():getTableName() )

   METHOD getPackage( cContext )       INLINE ( SQLFacturasVentasRectificativasModel():getPackage( cContext ) )

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
  
