#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS FacturasVentasRepository FROM OperacionesComercialesRepository

   METHOD getTableName()               INLINE ( SQLFacturasVentasModel():getTableName() ) 

   METHOD getLinesTableName()          INLINE ( SQLFacturasVentasLineasModel():getTableName() )

   METHOD getDiscountsTableName()      INLINE ( SQLFacturasVentasDescuentosModel():getTableName() )

   METHOD getPackage( cContext )       INLINE ( SQLFacturasVentasModel():getPackage( cContext ) )

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
  
