#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS MaterialesConsumidosLineasModel FROM MaterialesProducidosLineasModel

   METHOD getTableName()                     INLINE ::getEmpresaTableName( "ProMat" )

   METHOD getExtraWhere()                    INLINE ( "" )
   METHOD getFechaFieldName()                INLINE ( "dFecOrd" )
   METHOD getHoraFieldName()                 INLINE ( "cHorIni" )
   METHOD getArticuloFieldName()             INLINE ( "cCodArt" )
   METHOD setAlmacenFieldName()              INLINE ( ::cAlmacenFieldName  := "cAlmOrd" )
   METHOD getCajasFieldName()                INLINE ( "nCajOrd" )
   METHOD getUnidadesFieldName()             INLINE ( "nUndOrd" )

END CLASS

//---------------------------------------------------------------------------//

