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

#ifdef __TEST__

   METHOD test_create_factura( uuid )

   METHOD test_create_factura_con_recargo_de_eqivalencia( uuid )

   METHOD test_create_factura_con_varios_plazos()

   METHOD test_get_uuid_factura_con_varios_plazos()   

#endif

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLOperacionesComercialesModel

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

   hset( ::hColumns, "fecha",                         {  "create"    => "DATE"                                 ,;
                                                         "default"   => {|| date() } }                         )

   hset( ::hColumns, "fecha_valor_stock",             {  "create"    => "DATETIME DEFAULT CURRENT_TIMESTAMP"   ,;
                                                         "default"   => {|| hb_datetime() } }                  )

   hset( ::hColumns, "tercero_codigo",                {  "create"    => "VARCHAR( 20 )"                        ,;
                                                         "default"   => {|| space( 20 ) } }                    )

   hset( ::hColumns, "recargo_equivalencia",          {  "create"    => "TINYINT( 1 )"                         ,;
                                                         "default"   => {|| 0 } }                              )

   hset( ::hColumns, "direccion_principal_uuid",      {  "create"    => "VARCHAR( 40 )"                        ,;
                                                         "default"   => {|| space( 40 ) } }                    )

   hset( ::hColumns, "metodo_pago_codigo",             {  "create"   => "VARCHAR( 20 )"                        ,;
                                                         "default"   => {|| space( 20 ) } }                    )

   hset( ::hColumns, "almacen_codigo",                {  "create"    => "VARCHAR( 20 )"                        ,;
                                                         "default"   => {|| Store():getCodigo() } }            )

   hset( ::hColumns, "agente_codigo",                 {  "create"    => "VARCHAR( 20 )"                        ,;
                                                         "default"   => {|| space( 20 ) } }                    )

   hset( ::hColumns, "ruta_codigo",                   {  "create"    => "VARCHAR( 20 )"                        ,;
                                                         "default"   => {|| space( 20 ) } }                    )

   hset( ::hColumns, "transportista_codigo",          {  "create"    => "VARCHAR( 20 )"                        ,;
                                                         "default"   => {|| space( 20 ) } }                    )

   hset( ::hColumns, "tarifa_codigo",                 {  "create"    => "VARCHAR( 20 )"                        ,;
                                                         "default"   => {|| space( 20 ) } }                    )

   ::getTimeStampColumns() 

   ::getClosedColumns()

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

METHOD getColumnsSelect() CLASS SQLOperacionesComercialesModel

   local cColumns

   TEXT INTO cColumns
      %1$s.id AS id,
      %1$s.uuid AS uuid,
      CONCAT( %1$s.serie, '-', %1$s.numero ) AS numero,
      %1$s.fecha AS fecha,
      %1$s.delegacion_uuid AS delegacion_uuid,
      %1$s.sesion_uuid AS sesion_uuid,
      %1$s.recargo_equivalencia AS recargo_equivalencia,
      %1$s.tercero_codigo AS tercero_codigo,
      %1$s.created_at AS created_at,
      %1$s.updated_at AS updated_at,
      terceros.nombre AS tercero_nombre,
      terceros.dni AS cliente_dni,
      direcciones.direccion AS direccion_direccion,
      direcciones.poblacion AS direccion_poblacion,
      direcciones.codigo_provincia AS direccion_codigo_provincia,
      direcciones.provincia AS direccion_provincia,
      direcciones.codigo_postal AS direccion_codigo_postal,
      direcciones.telefono AS direccion_telefono,
      direcciones.movil AS direccion_movil,
      direcciones.email AS direccion_email,
      tarifas.codigo AS tarifa_codigo,
      tarifas.nombre AS tarifa_nombre,
      ( %2$s( %1$s.uuid ) ) AS total
   ENDTEXT

   cColumns := hb_strformat( cColumns, ::cTableName, Company():getTableName( ::getPackage( 'TotalSummaryWhereUuid' ) ) ) 

RETURN ( cColumns )

//---------------------------------------------------------------------------//

METHOD getInitialSelect() CLASS SQLOperacionesComercialesModel

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

   cSql  := hb_strformat(  cSql,;
                           ::cTableName,;
                           ::getTableName(),;
                           SQLTercerosModel():getTableName(),;
                           SQLDireccionesModel():getTableName(),;
                           SQLArticulosTarifasModel():getTableName(),;
                           ::getColumnsSelect() )

   logwrite( cSql )

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

RETURN ( alltrim( ::getDatabase():getValue( cSql ) ) )

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

RETURN ( ::getDatabase():getValue( cSql, 0 ) + 1 )

//---------------------------------------------------------------------------//

METHOD getFieldWhereSerieAndNumero( cSerieAndNumero ) CLASS SQLOperacionesComercialesModel

local cSql

   TEXT INTO cSql

   SELECT 
     terceros.nombre AS tercero

   FROM %1$s AS operacion_comercial

   INNER JOIN %2$s AS terceros
      ON terceros.codigo = operacion_comercial.tercero_codigo
   
   WHERE CONCAT(operacion_comercial.serie, "-", operacion_comercial.numero) = %3$s

   ENDTEXT

   cSql  := hb_strformat(  cSql,;
                           ::getTableName(),;
                           SQLTercerosModel():getTableName(),;
                           quoted( cSerieAndNumero ) )


RETURN ( getSQLDatabase():getValue( cSql ) )

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

#endif

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
