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

      INNER JOIN %2$s AS %3$s
         ON %4$s.uuid <> %3$s.documento_origen_uuid

   ENDTEXT

   cSql  := hb_strformat(  cSql,;
                           ::Super:getInitialSelect( cOrderBy, cOrientation ),;
                           SQLConversorDocumentosModel():getTableName(),;
                           SQLConversorDocumentosModel():cTableName,;
                           SQLAlbaranesVentasModel():cTableName,;
                            )

   msgalert( cSql, "cSql albaranes ventas conversor" )

   logwrite( cSql )

RETURN ( cSql )  

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
