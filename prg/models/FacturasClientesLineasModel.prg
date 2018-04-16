#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS FacturasClientesLineasModel FROM TransaccionesComercialesLineasModel

   METHOD getTableName()                           INLINE ::getEmpresaTableName( "FacCliL" )

   METHOD getExtraWhere()                          INLINE ( "AND nCtlStk < 2" )

   METHOD getFechaFieldName()                      INLINE ( "dFecFac" )
   METHOD getHoraFieldName()                       INLINE ( "tFecFac" )

   METHOD deleteWherId( cSerie, nNumero, cDelegacion )

END CLASS

//---------------------------------------------------------------------------//

METHOD deleteWherId( cSerie, nNumero, cDelegacion )

   local cSentence

   cSentence         := "DELETE FROM " + ::getTableName() + " " + ;
                           "WHERE cSerie = '" + cSerie + "' AND nNumFac = " + alltrim( nNumero ) + " AND cSufFac = '" + cDelegacion + "'" 
   
   ADSBaseModel():ExecuteSqlStatement( cSentence )

RETURN ( Self )

//---------------------------------------------------------------------------//



