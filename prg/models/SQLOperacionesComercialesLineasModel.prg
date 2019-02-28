#include "fivewin.ch"
#include "factu.ch" 
#include "hdo.ch"

//---------------------------------------------------------------------------//

CLASS SQLOperacionesComercialesLineasModel FROM SQLOperacionesLineasModel

   METHOD getColumns()

   METHOD getColumnsSelect()

   METHOD getInitialSelect()

   METHOD getHashWhereUuid( uuidOrigen )

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLOperacionesComercialesLineasModel

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

   hset( ::hColumns, "descuento",                  {  "create"    => "FLOAT ( 7, 4 )"                  ,;
                                                      "default"   => {|| 0 } }                        )

   hset( ::hColumns, "combinaciones_uuid",         {  "create"    => "VARCHAR ( 40 )"                  ,;
                                                      "default"   => {|| space( 40 ) } } )

   hset( ::hColumns, "incremento_precio",          {  "create"    => "FLOAT( 19, 6)"                  ,;
                                                      "default"   => {|| 0 } }                        )

   hset( ::hColumns, "iva",                        {  "create"    => "FLOAT ( 7, 4 )"                  ,;
                                                      "default"   => {|| 0 }  }                       )

   hset( ::hColumns, "recargo_equivalencia",       {  "create"    => "FLOAT ( 7, 4 )"                  ,;
                                                      "default"   => {|| 0 }  }                       )

   hset( ::hColumns, "almacen_codigo",             {  "create"    => "VARCHAR ( 20 ) NOT NULL"         ,;
                                                      "default"   => {|| space( 20 ) } }              )

   hset( ::hColumns, "ubicacion_codigo",           {  "create"    => "VARCHAR ( 20 ) NOT NULL"         ,;
                                                      "default"   => {|| space( 20 ) } }              )

   hset( ::hColumns, "agente_codigo",              {  "create"    => "VARCHAR ( 20 ) NOT NULL"         ,;
                                                      "default"   => {|| space( 20 ) } }              )

   hset( ::hColumns, "agente_comision",            {  "create"    => "FLOAT ( 7, 4 )"                  ,;
                                                      "default"   => {|| 0 } }                        )

   ::getDeletedStampColumn()

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

METHOD getColumnsSelect() CLASS SQLOperacionesComercialesLineasModel

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
      ( ROUND( ( %1$s.articulo_unidades * %1$s.unidad_medicion_factor ) * ( articulo_precio + incremento_precio ), 2 ) ) AS total_bruto,
      %1$s.unidad_medicion_codigo AS unidad_medicion_codigo,
      %1$s.descuento AS descuento,
      ( IF( descuento IS NULL OR descuento = 0, 0, ( ROUND( ( %1$s.articulo_unidades * %1$s.unidad_medicion_factor ) * ( articulo_precio + incremento_precio ), 2 ) ) * descuento / 100 ) ) AS importe_descuento,
      ( ( ROUND( ( %1$s.articulo_unidades * %1$s.unidad_medicion_factor ) * ( articulo_precio + incremento_precio ), 2 ) ) - ( IF( descuento IS NULL OR descuento = 0, 0, ( ROUND( ( %1$s.articulo_unidades * %1$s.unidad_medicion_factor ) * ( articulo_precio + incremento_precio ), 2 ) ) * descuento / 100 ) ) ) AS total_precio,
      %1$s.iva AS iva,
      %1$s.recargo_equivalencia AS recargo_equivalencia,
      %1$s.almacen_codigo AS almacen_codigo,
      almacenes.nombre AS almacen_nombre,
      %1$s.ubicacion_codigo AS ubicacion_codigo,
      ubicaciones.nombre AS ubicacion_nombre,
      %1$s.agente_codigo AS agente_codigo,
      %1$s.agente_comision AS agente_comision, 
      agentes.nombre AS agente_nombre, 
      %1$s.combinaciones_uuid AS combinaciones_uuid, 
      TRIM( GROUP_CONCAT( " ", articulos_propiedades_lineas.nombre ORDER BY combinaciones_propiedades.id ) ) AS articulos_propiedades_nombre,
      %1$s.deleted_at AS deleted_at
   ENDTEXT

   cColumns  := hb_strformat( cColumns, ::cTableName )
      
RETURN ( cColumns )

//---------------------------------------------------------------------------//

METHOD getInitialSelect() CLASS SQLOperacionesComercialesLineasModel

   local cSql

   TEXT INTO cSql

      SELECT 
         %8$s
         
      FROM %1$s AS %2$s

      LEFT JOIN %3$s AS almacenes
         ON almacenes.codigo = %2$s.almacen_codigo

      LEFT JOIN %4$s AS agentes
         ON agentes.codigo = %2$s.agente_codigo
  
      LEFT JOIN %5$s AS combinaciones_propiedades
         ON combinaciones_propiedades.parent_uuid = %2$s.combinaciones_uuid

      LEFT JOIN %6$s AS articulos_propiedades_lineas
         ON articulos_propiedades_lineas.uuid = combinaciones_propiedades.propiedad_uuid

      LEFT JOIN %7$s AS ubicaciones
         ON ubicaciones.codigo = %2$s.ubicacion_codigo AND ubicaciones.parent_uuid = almacenes.uuid
       
   ENDTEXT

   cSql  := hb_strformat(  cSql,;
                           ::getTableName(),;
                           ::cTableName,;
                           SQLAlmacenesModel():getTableName(),;
                           SQLAgentesModel():getTableName(),;
                           SQLCombinacionesPropiedadesModel():getTableName(),;
                           SQLPropiedadesLineasModel():getTableName(),;
                           SQLUbicacionesModel():getTableName(),;
                           ::getColumnsSelect() )

RETURN ( cSql )

//---------------------------------------------------------------------------//

METHOD getHashWhereUuid( uuidOrigen ) CLASS SQLOperacionesComercialesLineasModel

   local cSql

   TEXT INTO cSql

      SELECT 
         *  
      FROM %1$s

      WHERE parent_uuid = %2$s AND deleted_at = 0
       
   ENDTEXT

   cSql  := hb_strformat(  cSql, ::getTableName(), quoted( uuidOrigen ) )

RETURN ( ::getDatabase():selectTrimedFetchHash( cSql ) ) 

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//


