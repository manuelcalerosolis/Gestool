#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS RectificativasClientesLineasModel   FROM TransaccionesComercialesLineasModel

   METHOD getTableName()                  INLINE ::getEmpresaTableName( "FacRecL" )

   METHOD getExtraWhere()                 INLINE ( "AND nCtlStk < 2" )

   METHOD getFechaFieldName()             INLINE ( "dFecFac" )
   METHOD getHoraFieldName()              INLINE ( "tFecFac" )

END CLASS

//---------------------------------------------------------------------------//

