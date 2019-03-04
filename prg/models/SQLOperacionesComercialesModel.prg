#include "FiveWin.Ch"
#include "Factu.ch"

//---------------------------------------------------------------------------//

CLASS SQLOperacionesComercialesModel FROM SQLCompanyModel

   METHOD getColumns()

   METHOD getColumnsSelect()
   
   METHOD getTercerosCodigo()          VIRTUAL

   METHOD getInitialSelect()

   METHOD getNumeroWhereUuid( uuid )

   METHOD maxNumberWhereSerie( cSerie )

   METHOD totalPaid( uuidFactura )

   METHOD getFieldWhereSerieAndNumero( cSerieAndNumero )

   METHOD deleteWhereUuid( Uuid )

   METHOD getHashWhereUuidAndOrder( cWhere )

#ifdef __TEST__

   METHOD test_create_factura( uuid )

   METHOD test_create_factura_con_recargo_de_eqivalencia( uuid )

   METHOD test_create_factura_con_varios_plazos()

   METHOD test_get_uuid_factura_con_varios_plazos()

   METHOD test_create_albaran_compras_con_tercero( cCodigoTercero ) 

#endif

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLOperacionesComercialesModel

   hset( ::hColumns, "id",                            {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"        ,;
                                                         "text"      => "Identificador"                        ,;
                                                         "default"   => {|| 0 } }                              )

   hset( ::hColumns, "uuid",                          {  "create"    => "VARCHAR ( 40 ) NOT NULL UNIQUE"       ,;
                                                         "default"   => {|| win_uuidcreatestring() } }         )

   hset( ::hColumns, "delegacion_uuid",               {  "create"    => "VARCHAR ( 40 )"                       ,;
                                                         "default"   => {|| Delegation():Uuid() } }            )

   hset( ::hColumns, "sesion_uuid",                   {  "create"    => "VARCHAR ( 40 )"                       ,;
                                                         "default"   => {|| Session():Uuid() } }               )

   hset( ::hColumns, "serie",                         {  "create"    => "VARCHAR ( 20 )"                       ,;
                                                         "text"      => "Serie"                                ,;
                                                         "default"   => {|| space( 20 ) } }                    )

   hset( ::hColumns, "numero",                        {  "create"    => "INT UNSIGNED"                         ,;
                                                         "text"      => "Número"                               ,;
                                                         "default"   => {|| 0 } }                              )

   hset( ::hColumns, "fecha",                         {  "create"    => "DATE"                                 ,;
                                                         "text"      => "Fecha"                                ,;
                                                         "default"   => {|| date() } }                         )

   hset( ::hColumns, "fecha_valor_stock",             {  "create"    => "DATETIME DEFAULT CURRENT_TIMESTAMP"   ,;
                                                         "text"      => "Fecha valor stock"                    ,;
                                                         "default"   => {|| hb_datetime() } }                  )

   hset( ::hColumns, "tercero_codigo",                {  "create"    => "VARCHAR ( 20 )"                       ,;
                                                         "text"      => "Código de tercero"                    ,;
                                                         "default"   => {|| space( 20 ) } }                    )

   hset( ::hColumns, "recargo_equivalencia",          {  "create"    => "TINYINT ( 1 )"                        ,;
                                                         "text"      => "Recargo de equivalencia"              ,;
                                                         "default"   => {|| 0 } }                              )

   hset( ::hColumns, "direccion_principal_uuid",      {  "create"    => "VARCHAR ( 40 )"                       ,;
                                                         "default"   => {|| space( 40 ) } }                    )

   hset( ::hColumns, "metodo_pago_codigo",            {  "create"    => "VARCHAR ( 20 )"                       ,;
                                                         "text"      => "Recargo de equivalencia"              ,;
                                                         "default"   => {|| space( 20 ) } }                    )

   hset( ::hColumns, "almacen_codigo",                {  "create"    => "VARCHAR ( 20 )"                       ,;
                                                         "text"      => "Código de almacén"                    ,;
                                                         "default"   => {|| Store():getCodigo() } }            )

   hset( ::hColumns, "agente_codigo",                 {  "create"    => "VARCHAR ( 20 )"                       ,;
                                                         "text"      => "Código de agente"                     ,;
                                                         "default"   => {|| space( 20 ) } }                    )

   hset( ::hColumns, "ruta_codigo",                   {  "create"    => "VARCHAR ( 20 )"                       ,;
                                                         "text"      => "Código de la ruta"                    ,;
                                                         "default"   => {|| space( 20 ) } }                    )

   hset( ::hColumns, "transportista_codigo",          {  "create"    => "VARCHAR ( 20 )"                       ,;
                                                         "text"      => "Código del transportista"             ,;
                                                         "default"   => {|| space( 20 ) } }                    )

   hset( ::hColumns, "tarifa_codigo",                 {  "create"    => "VARCHAR ( 20 )"                       ,;
                                                         "text"      => "Código de la tarifa"                  ,;
                                                         "default"   => {|| space( 20 ) } }                    )

   ::getTimeStampColumns() 

   ::getClosedColumns()

   ::getCanceledColumns()

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

METHOD getColumnsSelect() CLASS SQLOperacionesComercialesModel

   local cColumns

   TEXT INTO cColumns
      %1$s.id AS id,
      %1$s.uuid AS uuid,
      CONCAT( %1$s.serie, '-', %1$s.numero ) AS numero,
      %1$s.fecha AS fecha,
      %1$s.fecha_valor_stock AS fecha_valor_stock,
      %1$s.delegacion_uuid AS delegacion_uuid,
      %1$s.sesion_uuid AS sesion_uuid,
      %1$s.recargo_equivalencia AS recargo_equivalencia,
      %1$s.tercero_codigo AS tercero_codigo,
      %1$s.agente_codigo AS agente_codigo,
      %1$s.created_at AS created_at,
      %1$s.updated_at AS updated_at,
      %1$s.canceled_at AS canceled_at,
      %3$s.nombre AS tercero_nombre,
      %3$s.dni AS cliente_dni,
      %4$s.direccion AS direccion_direccion,
      %4$s.poblacion AS direccion_poblacion,
      %4$s.codigo_provincia AS direccion_codigo_provincia,
      %4$s.provincia AS direccion_provincia,
      %4$s.codigo_postal AS direccion_codigo_postal,
      %4$s.telefono AS direccion_telefono,
      %4$s.movil AS direccion_movil,
      %4$s.email AS direccion_email,
      %5$s.codigo AS tarifa_codigo,
      %5$s.nombre AS tarifa_nombre,
      ( %2$s( %1$s.uuid ) ) AS total
   ENDTEXT

   cColumns := hb_strformat( cColumns,;
                             ::cTableName ,;
                             Company():getTableName( ::getPackage( 'TotalSummaryWhereUuid' ) ) ,;
                             SQLTercerosModel():cTableName ,;
                             SQLDireccionesModel():cTableName ,;
                             SQLArticulosTarifasModel():cTableName ) 

RETURN ( cColumns )

//---------------------------------------------------------------------------//

METHOD getInitialSelect() CLASS SQLOperacionesComercialesModel

   local cSql

   TEXT INTO cSql

   SELECT
      %11$s

   FROM %1$s AS %2$s

      /* Terceros------------------------------------------------------------*/

      LEFT JOIN %3$s AS %4$s
         ON %1$s.tercero_codigo = %4$s.codigo AND %4$s.deleted_at = 0

      /* Direcciones---------------------------------------------------------*/

      LEFT JOIN %5$s AS %6$s
         ON %4$s.uuid = %6$s.parent_uuid AND %6$s.codigo = 0

      /* Tarifas de articulos------------------------------------------------*/

      LEFT JOIN %7$s AS %8$s
         ON %1$s.tarifa_codigo = %8$s.codigo

      /* Grupos de terceros--------------------------------------------------*/

      LEFT JOIN %9$s AS %10$s
         ON %4$s.tercero_grupo_codigo = %10$s.codigo AND %10$s.deleted_at = 0

   ENDTEXT

   cSql  := hb_strformat(  cSql,;
                           ::getTableName(),;
                           ::getTable(),;
                           SQLTercerosModel():getTableName(),;
                           SQLTercerosModel():getTable(),;
                           SQLDireccionesModel():getTableName(),;
                           SQLDireccionesModel():getTable(),;
                           SQLArticulosTarifasModel():getTableName(),;
                           SQLArticulosTarifasModel():getTable(),;
                           SQLTercerosGruposModel():getTableName(),;
                           SQLTercerosGruposModel():getTable(),;
                           ::getColumnsSelect() )
RETURN ( cSql )

//---------------------------------------------------------------------------//

METHOD getNumeroWhereUuid( uuid ) CLASS SQLOperacionesComercialesModel

   local cSql

   TEXT INTO cSql

   SELECT
      CONCAT( serie, '-', numero ) AS numero

      FROM %1$s

      WHERE uuid = %2$s

   ENDTEXT

   cSql  := hb_strformat( cSql, ::getTableName(), quoted( uuid ) )

RETURN ( alltrim( getSQLDatabase():getValue( cSql ) ) )

//---------------------------------------------------------------------------//

METHOD totalPaid( uuidFactura ) CLASS SQLOperacionesComercialesModel

   local cSql

   TEXT INTO cSql

   SELECT 
      SUM( pagos.importe ) AS total_pagado

      FROM %2$s AS %1$s

      INNER JOIN %3$s AS recibos
         ON  %1$s.uuid = recibos.parent_uuid

      INNER JOIN %4$s AS pagos_recibos
         ON pagos_recibos.recibo_uuid = recibos.uuid

      INNER JOIN %5$s AS pagos
         ON pagos_recibos.pago_uuid = pagos.uuid

      WHERE  %1$s.uuid = %6$s

      GROUP BY  %1$s.uuid

   ENDTEXT

   cSql  := hb_strformat(  cSql,;
                           ::cTableName,;
                           ::getTableName(),;
                           SQLRecibosModel():getTableName(),;
                           SQLRecibosPagosModel():getTableName(),;
                           SQLPagosModel():getTableName(),;
                           quoted( uuidFactura ) )

RETURN ( getSQLDatabase():getValue( cSql, 0 ) )

//---------------------------------------------------------------------------//

METHOD maxNumberWhereSerie( cSerie ) CLASS SQLOperacionesComercialesModel

   local cSql

   cSql        := "SELECT MAX( numero ) FROM " + ::getTableName() + " "
   cSql        +=    "WHERE serie = " + quoted( cSerie )

RETURN ( getSQLDatabase():getValue( cSql, 0 ) + 1 )

//---------------------------------------------------------------------------//

METHOD getFieldWhereSerieAndNumero( cSerieAndNumero ) CLASS SQLOperacionesComercialesModel

local cSql

   TEXT INTO cSql

   SELECT 
     terceros.nombre AS tercero

   FROM %1$s AS operacion_comercial

   INNER JOIN %2$s AS terceros
      ON terceros.codigo = operacion_comercial.tercero_codigo
   
   WHERE CONCAT( operacion_comercial.serie, "-", operacion_comercial.numero ) = %3$s

   ENDTEXT

   cSql  := hb_strformat(  cSql,;
                           ::getTableName(),;
                           SQLTercerosModel():getTableName(),;
                           quoted( cSerieAndNumero ) )


RETURN ( getSQLDatabase():getValue( cSql ) )

//---------------------------------------------------------------------------//

METHOD deleteWhereUuid( Uuid ) CLASS SQLOperacionesComercialesModel

   local cSql

   TEXT INTO cSql

   DELETE FROM %1$s WHERE uuid= %2$s

   ENDTEXT

   cSql  := hb_strformat(  cSql, ::getTableName(), quoted( Uuid ) )

RETURN ( getSQLDatabase():Exec( cSql ) )

//---------------------------------------------------------------------------//

METHOD getHashWhereUuidAndOrder( cWhere ) CLASS SQLOperacionesComercialesModel
   
   local cSql

   TEXT INTO cSql

      SELECT *  
         
         FROM %1$s

         WHERE uuid %2$s

         ORDER BY tercero_codigo, ruta_codigo, metodo_pago_codigo, tarifa_codigo, recargo_equivalencia, serie
       
   ENDTEXT

   cSql  := hb_strformat(  cSql, ::getTableName(), cWhere )

RETURN ( getSQLDatabase():selectFetchHash( cSQL ) )

//---------------------------------------------------------------------------//

#ifdef __TEST__

METHOD test_create_factura( uuid ) CLASS SQLOperacionesComercialesModel

   local hBuffer  := ::loadBlankBuffer()

   hset( hBuffer, "serie", "TEST" )
   hset( hBuffer, "numero", 1 )
   hset( hBuffer, "uuid", uuid )
   hset( hBuffer, "tercero_codigo", "0" )
   hset( hBuffer, "metodo_pago_codigo", "0" )
   hset( hBuffer, "almacen_codigo", "0" )
   hset( hBuffer, "tarifa_codigo", "0" )

RETURN ( ::insertBuffer( hBuffer ) )

//---------------------------------------------------------------------------//

METHOD test_create_factura_con_recargo_de_eqivalencia( uuid ) CLASS SQLOperacionesComercialesModel

   local hBuffer  := ::loadBlankBuffer()

   hset( hBuffer, "serie", "TEST" )
   hset( hBuffer, "numero", 1 )
   hset( hBuffer, "uuid", uuid )
   hset( hBuffer, "tercero_codigo", "0" )
   hset( hBuffer, "metodo_pago_codigo", "0" )
   hset( hBuffer, "almacen_codigo", "0" )
   hset( hBuffer, "recargo_equivalencia", 1 )
   hset( hBuffer, "tarifa_codigo", "0" )

RETURN ( ::insertBuffer( hBuffer ) )

//---------------------------------------------------------------------------//

METHOD test_create_factura_con_varios_plazos() CLASS SQLOperacionesComercialesModel

   local hBuffer  := ::loadBlankBuffer()

   hset( hBuffer, "serie", "TEST" )
   hset( hBuffer, "numero", 1 )
   hset( hBuffer, "tercero_codigo", "0" )
   hset( hBuffer, "metodo_pago_codigo", "1" )
   hset( hBuffer, "almacen_codigo", "0" )
   hset( hBuffer, "tarifa_codigo", "0" )

RETURN ( ::insertBuffer( hBuffer ) )

//---------------------------------------------------------------------------//

METHOD test_get_uuid_factura_con_varios_plazos() CLASS SQLOperacionesComercialesModel

RETURN ( ::getFieldWhere( "uuid", { "serie" => "TEST", "numero" => 1 } ) )

//---------------------------------------------------------------------------//

METHOD test_create_albaran_compras_con_tercero( cCodigoTercero ) CLASS SQLOperacionesComercialesModel

   local hBuffer  := ::loadBlankBuffer()

   hset( hBuffer, "serie", "TEST" )
   hset( hBuffer, "tercero_codigo", quoted( cCodigoTercero ) )
   hset( hBuffer, "metodo_pago_codigo", "1" )
   hset( hBuffer, "almacen_codigo", "0" )
   hset( hBuffer, "tarifa_codigo", "0" )

   ::insertBuffer()

RETURN ( ::insertBuffer() )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
