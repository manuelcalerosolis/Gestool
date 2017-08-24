#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS AlbaranesProveedoresLineasModel FROM TransaccionesComercialesLineasModel

   METHOD getTableName()                     INLINE ::getEmpresaTableName( "AlbProvL" )

   METHOD getExtraWhere()                    INLINE ( "AND nCtlStk < 2 AND NOT lFacturado" )

END CLASS

//---------------------------------------------------------------------------//

