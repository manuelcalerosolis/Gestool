#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS FacturasClientesLineasModel FROM TransaccionesComercialesLineasModel

   METHOD getTableName()                           INLINE ::getEmpresaTableName( "FacCliL" )

   METHOD getExtraWhere()                          INLINE ( "AND nCtlStk < 2" )

   METHOD getFechaFieldName()                      INLINE ( "dFecFac" )
   METHOD getHoraFieldName()                       INLINE ( "tFecFac" )

END CLASS

//---------------------------------------------------------------------------//

