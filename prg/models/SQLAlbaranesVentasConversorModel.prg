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

      WHERE ( %3$s( albaranes_ventas.uuid, "facturas_ventas" ) ) = 0

   ENDTEXT

   cSql  := hb_strformat(  cSql,;
                           ::Super:getInitialSelect( cOrderBy, cOrientation ),;
                           SQLConversorDocumentosModel():getTableName(),;
                           Company():getTableName( ::getPackage( 'IsConvertedWhereUuidAnDestino' ) ) )
RETURN ( cSql )  

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
