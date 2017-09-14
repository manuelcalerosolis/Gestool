#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS FacturasProveedoresLineasModel FROM TransaccionesComercialesLineasModel

   METHOD getTableName()                           INLINE ::getEmpresaTableName( "FacPrvL" )

   METHOD getExtraWhere()                          INLINE ( "AND nCtlStk < 2" )

   METHOD getFechaFieldName()                      INLINE ( "dFecFac" )
   METHOD getHoraFieldName()                       INLINE ( "tFecFac" )

END CLASS

//---------------------------------------------------------------------------//

