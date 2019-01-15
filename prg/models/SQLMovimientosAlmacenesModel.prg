#include "fivewin.ch"
#include "factu.ch" 

//---------------------------------------------------------------------------//

CLASS SQLMovimientosAlmacenesModel FROM SQLCompanyModel

   DATA cPackage                       INIT  "MovimientosAlmacenes"

   DATA cTableName                     INIT  "movimientos_almacenes"

   METHOD getColumns()

   METHOD getColumnsSelect()           VIRTUAL
   
   METHOD getTercerosCodigo()          VIRTUAL

   METHOD getInitialSelect()

   METHOD getNumeroWhereUuid( uuid )

#ifdef __TEST__

   METHOD test_create( uuid )

#endif

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLMovimientosAlmacenesModel

   hset( ::hColumns, "id",                            {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"        ,;
                                                         "default"   => {|| 0 } }                              )

   hset( ::hColumns, "uuid",                          {  "create"    => "VARCHAR( 40 ) NOT NULL UNIQUE"        ,;
                                                         "default"   => {|| win_uuidcreatestring() } }         )

   hset( ::hColumns, "delegacion_uuid",               {  "create"    => "VARCHAR( 40 )"                        ,;
                                                         "default"   => {|| Delegation():Uuid() } }            )

   hset( ::hColumns, "sesion_uuid",                   {  "create"    => "VARCHAR( 40 )"                        ,;
                                                         "default"   => {|| Session():Uuid() } }               )

   hset( ::hColumns, "serie",                         {  "create"    => "VARCHAR( 20 )"                        ,;
                                                         "default"   => {|| space( 20 ) } }                    )

   hset( ::hColumns, "numero",                        {  "create"    => "INT UNSIGNED"                         ,;
                                                         "default"   => {|| 0 } }                              )

   hset( ::hColumns, "fecha_valor_stock",             {  "create"    => "DATETIME DEFAULT CURRENT_TIMESTAMP"   ,;
                                                         "default"   => {|| hb_datetime() } }                  )

   hset( ::hColumns, "almacen_origen_codigo",         {  "create"    => "VARCHAR( 20 )"                        ,;
                                                         "default"   => {|| space( 20 ) } }                    )

   hset( ::hColumns, "almacen_destino_codigo",        {  "create"    => "VARCHAR( 20 )"                        ,;
                                                         "default"   => {|| space( 20 ) } }                    )

   hset( ::hColumns, "comentario",                    {  "create"    => "VARCHAR( 200 )"                       ,;
                                                         "default"   => {|| space( 200 ) } }                   )

   ::getTimeStampColumns()

   ::getClosedColumns()

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

METHOD getInitialSelect() CLASS SQLMovimientosAlmacenesModel

   local cSql

   TEXT INTO cSql

   SELECT
      movimientos_almacenes.id AS id,
      movimientos_almacenes.uuid AS uuid,
      CONCAT( movimientos_almacenes.serie, '-', movimientos_almacenes.numero ) AS numero,
      movimientos_almacenes.fecha_valor_stock AS fecha_valor_stock,
      movimientos_almacenes.comentario AS comentario,
      movimientos_almacenes.almacen_origen_codigo AS almacen_origen_codigo,
      almacenes_origen.nombre AS almacen_origen_nombre,
      movimientos_almacenes.almacen_destino_codigo AS almacen_destino_codigo,
      almacenes_destino.nombre AS almacen_destino_nombre,
      ( %3$s( movimientos_almacenes.uuid ) ) AS total

   FROM %1$s AS movimientos_almacenes

      LEFT JOIN %2$s AS almacenes_origen
         ON movimientos_almacenes.almacen_origen_codigo = almacenes_origen.codigo AND almacenes_origen.deleted_at = 0

      LEFT JOIN %2$s AS almacenes_destino
         ON movimientos_almacenes.almacen_destino_codigo = almacenes_destino.codigo AND almacenes_destino.deleted_at = 0

   ENDTEXT

   cSql  := hb_strformat( cSql, ::getTableName(), SQLAlmacenesModel():getTableName(), Company():getTableName( ::getPackage( 'TotalSummaryWhereUuid' ) ) )

RETURN ( cSql )

//---------------------------------------------------------------------------//

METHOD getNumeroWhereUuid( uuid ) CLASS SQLMovimientosAlmacenesModel

   local cSql

   TEXT INTO cSql

   SELECT
      CONCAT( serie, '-', numero ) AS numero

      FROM %1$s

      WHERE uuid = %2$s

   ENDTEXT

   cSql  := hb_strformat( cSql, ::getTableName(), quoted( uuid ) )

RETURN ( alltrim( ::getDatabase():getValue( cSql ) ) )

//---------------------------------------------------------------------------//

#ifdef __TEST__

METHOD test_create( uuid ) CLASS SQLMovimientosAlmacenesModel

   local hBuffer  := ::loadBlankBuffer()

   hset( hBuffer, "serie", "TEST" )
   hset( hBuffer, "numero", 1 )
   hset( hBuffer, "almacen_origen_codigo", "0" )
   hset( hBuffer, "almacen_destino_codigo", "1" )
   hset( hBuffer, "comentario", "Test consolidacion" )

RETURN ( ::insertBuffer( hBuffer ) )

//---------------------------------------------------------------------------//

#endif

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
