#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS FacturasVentasSimplificadasRepository FROM OperacionesComercialesRepository

   METHOD getTableName()               INLINE ( SQLFacturasVentasSimplificadasModel():getTableName() ) 

   METHOD getLinesTableName()          INLINE ( SQLFacturasVentasSimplificadasLineasModel():getTableName() )

   METHOD getDiscountsTableName()      INLINE ( SQLFacturasVentasSimplificadasDescuentosModel():getTableName() )

   METHOD getPackage( cContext )       INLINE ( SQLFacturasVentasSimplificadasModel():getPackage( cContext ) )

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
  
