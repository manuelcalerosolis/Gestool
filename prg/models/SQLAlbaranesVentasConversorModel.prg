#include "FiveWin.Ch"
#include "Factu.ch"

//---------------------------------------------------------------------------//

CLASS SQLAlbaranesVentasConversorModel FROM SQLAlbaranesVentasModel

   METHOD getInitialSelect( cOrderBy, cOrientation ) 

END CLASS

//---------------------------------------------------------------------------//

METHOD getInitialSelect( cOrderBy, cOrientation ) CLASS SQLAlbaranesVentasConversorModel

   local cSql

   TEXT INTO cSql

      %1$s

      WHERE ( %2$s( albaranes_ventas.uuid ) ) = 0

   ENDTEXT

   cSql  := hb_strformat(  cSql,;
                           ::Super:getInitialSelect( cOrderBy, cOrientation ),;
                           Company():getTableName( 'isConvertedToFacturasVentas' ) )

RETURN ( cSql )  

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
