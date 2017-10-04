#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS RectificativasProveedoresLineasModel FROM TransaccionesComercialesLineasModel

   METHOD getTableName()                           INLINE ::getEmpresaTableName( "RctPrvL" )

   METHOD getExtraWhere()                          INLINE ( "AND nCtlStk < 2" )

   METHOD getFechaFieldName()                      INLINE ( "dFecFac" )
   METHOD getHoraFieldName()                       INLINE ( "tFecFac" )

END CLASS

//---------------------------------------------------------------------------//

