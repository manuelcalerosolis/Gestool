#include "fivewin.ch"
#include "factu.ch" 

//---------------------------------------------------------------------------//

CLASS SQLConsolidacionesAlmacenesModel FROM SQLCompanyModel

   DATA cPackage                       INIT "ConsolidacionesAlmacenes"

   DATA cTableName                     INIT  "consolidaciones_almacenes"

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

METHOD getColumns() CLASS SQLConsolidacionesAlmacenesModel

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

   hset( ::hColumns, "almacen_codigo",                {  "create"    => "VARCHAR( 20 )"                        ,;
                                                         "default"   => {|| space( 20 ) } }                    )

   hset( ::hColumns, "comentario",                    {  "create"    => "VARCHAR( 200 )"                       ,;
                                                         "default"   => {|| space( 200 ) } }                   )

   ::getTimeStampColumns()

   ::getClosedColumns()

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

METHOD getInitialSelect() CLASS SQLConsolidacionesAlmacenesModel

   local cSql

   TEXT INTO cSql

   SELECT
      consolidaciones_almacenes.id AS id,
      consolidaciones_almacenes.uuid AS uuid,
      CONCAT( consolidaciones_almacenes.serie, '-', consolidaciones_almacenes.numero ) AS numero,
      consolidaciones_almacenes.fecha_valor_stock AS fecha_valor_stock,
      consolidaciones_almacenes.comentario AS comentario,
      consolidaciones_almacenes.almacen_codigo AS almacen_codigo,
      almacenes.nombre AS almacen_nombre

   FROM %1$s AS consolidaciones_almacenes

      LEFT JOIN %2$s almacenes
         ON consolidaciones_almacenes.almacen_codigo = almacenes.codigo AND almacenes.deleted_at = 0

   ENDTEXT

   cSql  := hb_strformat( cSql, ::getTableName(), SQLAlmacenesModel():getTableName() )

RETURN ( cSql )

//---------------------------------------------------------------------------//

METHOD getNumeroWhereUuid( uuid ) CLASS SQLConsolidacionesAlmacenesModel

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

METHOD test_create( uuid ) CLASS SQLConsolidacionesAlmacenesModel

   local hBuffer  := ::loadBlankBuffer()

   hset( hBuffer, "serie", "TEST" )
   hset( hBuffer, "numero", 1 )
   hset( hBuffer, "almacen_codigo", "0" )
   hset( hBuffer, "comentario", "Test consolidacion" )

RETURN ( ::insertBuffer( hBuffer ) )

//---------------------------------------------------------------------------//

#endif

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
