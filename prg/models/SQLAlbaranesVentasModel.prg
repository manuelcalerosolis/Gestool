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

RETURN ( ::Super:getSelectSentence( cOrderBy, cOrientation ) )  

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
