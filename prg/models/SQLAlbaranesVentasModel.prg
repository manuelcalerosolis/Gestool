#include "FiveWin.Ch"
#include "Factu.ch"

//---------------------------------------------------------------------------//

CLASS SQLAlbaranesVentasModel FROM SQLOperacionesComercialesModel

   DATA cPackage                       INIT "AlbaranesVentas"

   DATA cTableName                     INIT "albaranes_ventas"

   METHOD getSelectSentence( cOrderBy, cOrientation ) 

END CLASS

//---------------------------------------------------------------------------//

METHOD getSelectSentence( cOrderBy, cOrientation ) CLASS SQLAlbaranesVentasModel

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
