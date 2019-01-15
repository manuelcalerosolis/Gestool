#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS FacturasSimplificadasVentasRepository FROM OperacionesComercialesRepository

   METHOD getTableName()               INLINE ( SQLFacturasSimplificadasVentasModel():getTableName() ) 

   METHOD getLinesTableName()          INLINE ( SQLFacturasSimplificadasVentasLineasModel():getTableName() )

   METHOD getDiscountsTableName()      INLINE ( SQLFacturasSimplificadasVentasDescuentosModel():getTableName() )

   METHOD getPackage( cContext )       INLINE ( SQLFacturasSimplificadasVentasModel():getPackage( cContext ) )

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
  
