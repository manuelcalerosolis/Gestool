#include "FiveWin.Ch"
#include "Factu.ch"

//---------------------------------------------------------------------------//

CLASS SQLFacturasVentasModel FROM SQLOperacionesComercialesModel

   DATA cPackage                       INIT "FacturasVentas"

   DATA cTableName                     INIT "facturas_ventas"

   METHOD getInitialWhereDocumentos( cWhere )

   METHOD getInitialLimitCero()

   METHOD countFacturas()

END CLASS

//---------------------------------------------------------------------------//

METHOD getInitialWhereDocumentos( cWhere ) CLASS SQLFacturasVentasModel

   local cSql

   TEXT INTO cSql

   SELECT
      %6$s

   FROM %2$s AS %1$s

      LEFT JOIN %3$s AS terceros
         ON %1$s.tercero_codigo = terceros.codigo AND terceros.deleted_at = 0

      LEFT JOIN %4$s AS direcciones
         ON terceros.uuid = direcciones.parent_uuid AND direcciones.codigo = 0

      LEFT JOIN %5$s AS tarifas
         ON %1$s.tarifa_codigo = tarifas.codigo

   ENDTEXT

   cSql     := hb_strformat(  cSql,;
                              ::cTableName,;
                              ::getTableName(),;
                              SQLTercerosModel():getTableName(),;
                              SQLDireccionesModel():getTableName(),;
                              SQLArticulosTarifasModel():getTableName(),;
                              ::getColumnsSelect() )

   if !empty( cWhere )
      cSql  +=  "WHERE "+ ::cTableName + ".uuid " + cWhere
   end if 

RETURN ( cSql )

//---------------------------------------------------------------------------//

METHOD getInitialLimitCero() CLASS SQLFacturasVentasModel

   local cSql

   cSql  := ::getInitialWhereDocumentos()   


RETURN ( cSql )

//---------------------------------------------------------------------------//

METHOD countFacturas() CLASS SQLFacturasVentasModel

   local cSql

   TEXT INTO cSql

      SELECT 
         COUNT(*)  
      FROM %1$s
       
   ENDTEXT

   cSql  := hb_strformat(  cSql, ::getTableName() )

RETURN ( getSQLDatabase():getValue( cSql, 0 ) )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
