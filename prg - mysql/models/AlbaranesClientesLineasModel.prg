#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS AlbaranesClientesLineasModel FROM TransaccionesComercialesLineasModel

   METHOD getTableName()                           INLINE ::getEmpresaTableName( "AlbCliL" )

   METHOD getExtraWhere()                          INLINE ( "AND nCtlStk < 2 AND NOT lFacturado" )

   METHOD getFechaFieldName()                      INLINE ( "dFecAlb" )
   METHOD getHoraFieldName()                       INLINE ( "tFecAlb" )

END CLASS

//---------------------------------------------------------------------------//

