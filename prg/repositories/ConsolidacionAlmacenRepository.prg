#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS ConsolidacionAlmacenRepository FROM SQLBaseRepository

   METHOD getTableName()               INLINE ( SQLConsolidacionesAlmacenesModel():getTableName() ) 

   METHOD getPackage( cContext )       INLINE ( SQLConsolidacionesAlmacenesModel():getPackage( cContext ) )

   METHOD getSQLFunctions()            INLINE ( {} )

   METHOD getMailWhereOperacionUuid( uuidOperacionComercial )

END CLASS

//---------------------------------------------------------------------------//

METHOD getMailWhereOperacionUuid( uuidOperacionComercial ) CLASS ConsolidacionAlmacenRepository

   local cSQL

   TEXT INTO cSql

   SELECT direcciones.email

      FROM %1$s AS consolidacion_almacen

      INNER JOIN %2$s AS almacenes
         ON almacenes.codigo = consolidacion_almacen.almacen_codigo
      
      INNER JOIN %3$s AS direcciones
         ON almacenes.uuid = direcciones.parent_uuid AND direcciones.codigo = 0

      WHERE consolidacion_almacen.uuid = %4$s

   ENDTEXT

   cSql  := hb_strformat( cSql, ::getTableName(), SQLAlmacenesModel():getTableName(), SQLDireccionesModel():getTableName(), quotedUuid( uuidOperacionComercial ) ) 

RETURN ( getSQLDatabase():getValue( cSql, "" ) ) 

//---------------------------------------------------------------------------//


