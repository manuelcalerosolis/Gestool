#include "FiveWin.Ch"
#include "Factu.ch"

//---------------------------------------------------------------------------//

CLASS SQLAlbaranesVentasConversorModel FROM SQLAlbaranesVentasModel

   METHOD getSelectSentence( cOrderBy, cOrientation ) 

END CLASS

//---------------------------------------------------------------------------//

METHOD getSelectSentence( cOrderBy, cOrientation ) CLASS SQLAlbaranesVentasConversorModel

   local cSql

   cSql        := ::Super:getSelectSentence( cOrderBy, cOrientation ) 

   msgalert( cSql, "cSql" )

   logwrite( cSql )

RETURN ( cSql )  

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
