#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS AlbaranesVentasRepository FROM OperacionesComercialesRepository

   METHOD getTableName()               INLINE ( SQLAlbaranesVentasModel():getTableName() ) 

   METHOD getLinesTableName()          INLINE ( SQLAlbaranesVentasLineasModel():getTableName() )

   METHOD getDiscountsTableName()      INLINE ( SQLAlbaranesVentasDescuentosModel():getTableName() )

   METHOD getPackage( cContext )       INLINE ( SQLAlbaranesVentasModel():getPackage( cContext ) )

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
  
