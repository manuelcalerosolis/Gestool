#include "fivewin.ch"
#include "factu.ch" 
#include "hdo.ch"

//---------------------------------------------------------------------------//

CLASS SQLMovimientosAlmacenesLineasModel FROM SQLOperacionesLineasModel

   DATA cTableName                     INIT  "movimientos_almacenes_lineas"

   DATA cGroupBy                       INIT  "movimientos_almacenes_lineas.id" 

   METHOD getColumns() 

   METHOD getColumnsSelect()

   METHOD getInitialSelect()

#ifdef __TEST__

#endif

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLMovimientosAlmacenesLineasModel

   hset( ::hColumns, "id",                         {  "create"    => "INTEGER AUTO_INCREMENT"         ,;
                                                      "default"   => {|| 0 } }                        )

   hset( ::hColumns, "uuid",                       {  "create"    => "VARCHAR ( 40 ) NOT NULL UNIQUE"    ,;
                                                      "default"   => {|| win_uuidcreatestring() } }   )

   hset( ::hColumns, "parent_uuid",                {  "create"    => "VARCHAR ( 40 ) NOT NULL"           ,;
                                                      "default"   => {|| ::getControllerParentUuid() } } )

   hset( ::hColumns, "articulo_codigo",            {  "create"    => "VARCHAR ( 20 ) NOT NULL"         ,;
                                                      "default"   => {|| space( 20 ) } }              )

   hset( ::hColumns, "articulo_nombre",            {  "create"    => "VARCHAR ( 250 ) NOT NULL"          ,;
                                                      "default"   => {|| space(250) } }               )

   hset( ::hColumns, "fecha_caducidad",            {  "create"    => "DATE"                           ,;
                                                      "default"   => {|| ctod('') } }                 )

   hset( ::hColumns, "lote",                       {  "create"    => "VARCHAR ( 40 )"                  ,;
                                                      "default"   => {|| space( 40 ) } }              )

   hset( ::hColumns, "articulo_unidades",          {  "create"    => "DECIMAL ( 19, 6 )"                  ,;
                                                      "default"   => {|| 1 } }                        )

   hset( ::hColumns, "articulo_precio",            {  "create"    => "DECIMAL ( 19, 6 )"               ,;
                                                      "default"   => {|| 0 } }                        )

   hset( ::hColumns, "unidad_medicion_codigo",     {  "create"    => "VARCHAR ( 20 )"                  ,;
                                                      "default"   => {|| space( 20 ) } }              )

   hset( ::hColumns, "unidad_medicion_factor",     {  "create"    => "DECIMAL ( 19, 6 )"               ,;
                                                      "default"   => {|| 1 } }                        )

   hset( ::hColumns, "combinaciones_uuid",         {  "create"    => "VARCHAR ( 40 )"                  ,;
                                                      "default"   => {|| space( 40 ) } }              )

   hset( ::hColumns, "incremento_precio",          {  "create"    => "FLOAT( 19, 6)"                  ,;
                                                      "default"   => {|| 0 } }                        )

   hset( ::hColumns, "ubicacion_origen_codigo",    {  "create"    => "VARCHAR ( 20 ) NOT NULL"         ,;
                                                      "default"   => {|| space( 20 ) } }              )

   hset( ::hColumns, "ubicacion_destino_codigo",   {  "create"    => "VARCHAR ( 20 ) NOT NULL"         ,;
                                                      "default"   => {|| space( 20 ) } }              )

   ::getDeletedStampColumn()

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

METHOD getColumnsSelect() CLASS SQLMovimientosAlmacenesLineasModel

   local cColumns

   TEXT INTO cColumns
      %1$s.id AS id,
      %1$s.uuid AS uuid,
      %1$s.parent_uuid AS parent_uuid,
      %1$s.articulo_codigo AS articulo_codigo,
      %1$s.articulo_nombre AS articulo_nombre,
      %1$s.fecha_caducidad AS fecha_caducidad,
      %1$s.lote AS lote,
      %1$s.articulo_unidades AS articulo_unidades,
      %1$s.unidad_medicion_factor AS unidad_medicion_factor,
      ( %1$s.articulo_unidades * %1$s.unidad_medicion_factor ) AS total_unidades,
      %1$s.articulo_precio AS articulo_precio,
      %1$s.incremento_precio AS incremento_precio,
      ( ROUND( ( %1$s.articulo_unidades * %1$s.unidad_medicion_factor ) * ( %1$s.articulo_precio + %1$s.incremento_precio ), 2 ) ) AS total_precio,
      %1$s.unidad_medicion_codigo AS unidad_medicion_codigo,
      %1$s.ubicacion_origen_codigo AS ubicacion_origen_codigo,
      ubicaciones_origen.nombre AS ubicacion_origen_nombre,
      %1$s.ubicacion_destino_codigo AS ubicacion_destino_codigo,
      ubicaciones_destino.nombre AS ubicacion_destino_nombre,
      TRIM( GROUP_CONCAT( " ", articulos_propiedades_lineas.nombre ORDER BY combinaciones_propiedades.id ) ) AS articulos_propiedades_nombre,
      %1$s.deleted_at AS deleted_at
   ENDTEXT

   cColumns  := hb_strformat( cColumns, ::cTableName )
      
RETURN ( cColumns )

//---------------------------------------------------------------------------//

METHOD getInitialSelect() CLASS SQLMovimientosAlmacenesLineasModel

   local cSql

   TEXT INTO cSql

   SELECT 
      %3$s
         
      FROM %2$s AS %1$s

      LEFT JOIN %7$s AS movimientos_almacenes
         ON movimientos_almacenes.uuid = %1$s.parent_uuid

      LEFT JOIN %8$s AS almacenes_origen
         ON almacenes_origen.codigo = movimientos_almacenes.almacen_origen_codigo

      LEFT JOIN %8$s AS almacenes_destino
         ON almacenes_destino.codigo = movimientos_almacenes.almacen_destino_codigo

      LEFT JOIN %4$s AS combinaciones_propiedades
         ON combinaciones_propiedades.parent_uuid = %1$s.combinaciones_uuid

      LEFT JOIN %5$s AS articulos_propiedades_lineas
         ON articulos_propiedades_lineas.uuid = combinaciones_propiedades.propiedad_uuid

      LEFT JOIN %6$s AS ubicaciones_origen
         ON ubicaciones_origen.codigo = %1$s.ubicacion_origen_codigo AND ubicaciones_origen.parent_uuid = almacenes_origen.uuid
      
      LEFT JOIN %6$s AS ubicaciones_destino
         ON ubicaciones_destino.codigo = %1$s.ubicacion_destino_codigo AND ubicaciones_destino.parent_uuid = almacenes_destino.uuid
       
   ENDTEXT

   cSql  := hb_strformat( cSql, ::cTableName, ::getTableName(), ::getColumnsSelect(), SQLCombinacionesPropiedadesModel():getTableName(), SQLPropiedadesLineasModel():getTableName(), SQLUbicacionesModel():getTableName(), SQLMovimientosAlmacenesModel():getTableName(), SQLAlmacenesModel():getTableName() )

RETURN ( cSql )

//---------------------------------------------------------------------------//

#ifdef __TEST__

#endif
