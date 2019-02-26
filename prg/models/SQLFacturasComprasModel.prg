#include "FiveWin.Ch"
#include "Factu.ch"

//---------------------------------------------------------------------------//

CLASS SQLFacturasComprasModel FROM SQLOperacionesComercialesModel

   DATA cPackage                       INIT "FacturasCompras"

   DATA cTableName                     INIT "facturas_compras"

   METHOD getInitialWhereDocumentos( cWhere )

   METHOD countFacturas()

END CLASS

//---------------------------------------------------------------------------//

METHOD getInitialWhereDocumentos( cWhere ) CLASS SQLFacturasComprasModel

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

      WHERE %1$s.uuid %7$s

   ENDTEXT

   cSql  := hb_strformat(  cSql,;
                           ::cTableName,;
                           ::getTableName(),;
                           SQLTercerosModel():getTableName(),;
                           SQLDireccionesModel():getTableName(),;
                           SQLArticulosTarifasModel():getTableName(),;
                           ::getColumnsSelect(),;
                           cWhere )

RETURN ( cSql )

//---------------------------------------------------------------------------//

METHOD countFacturas() CLASS SQLFacturasComprasModel

   local cSql

   TEXT INTO cSql

      SELECT 
         COUNT(*)  
      FROM %1$s
       
   ENDTEXT

   cSql  := hb_strformat(  cSql, ::getTableName() )

RETURN ( ::getDatabase():getValue( cSql, 0 ) )

//---------------------------------------------------------------------------//

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
