#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS AlbaranesComprasRepository FROM OperacionesComercialesRepository

   METHOD getTableName()               INLINE ( SQLAlbaranesComprasModel():getTableName() ) 

   METHOD getLinesTableName()          INLINE ( SQLAlbaranesComprasLineasModel():getTableName() )

   METHOD getDiscountsTableName()      INLINE ( SQLAlbaranesComprasDescuentosModel():getTableName() )

   METHOD getPackage( cContext )       INLINE ( SQLAlbaranesComprasModel():getPackage( cContext ) )

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//