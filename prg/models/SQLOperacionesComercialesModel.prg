#include "FiveWin.Ch"
#include "Factu.ch"

//---------------------------------------------------------------------------//

CLASS SQLOperacionesComercialesModel FROM SQLCompanyModel

   DATA cConstraints                   INIT "PRIMARY KEY ( numero, serie )"

   METHOD getColumns()

   METHOD getColumnsSelect()    

   METHOD getInitialSelect()

   METHOD getTercerosModel()              VIRTUAL

   METHOD getNumeroWhereUuid( uuid )

   METHOD totalPaid( uuidFactura )

   METHOD testCreateFactura( uuid )

   METHOD testCreateFacturaConRecargoDeEqivalencia( uuid )

   METHOD testCreateFacturaConPlazos( uuid )

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

   hset( ::hColumns, "cliente_codigo",                {  "create"    => "VARCHAR( 20 )"                        ,;
                                                         "default"   => {|| space( 20 ) } }                    )

   hset( ::hColumns, "recargo_equivalencia",          {  "create"    => "TINYINT( 1 )"                         ,;
                                                         "default"   => {|| 0 } }                              )

   hset( ::hColumns, "direccion_principal_uuid",      {  "create"    => "VARCHAR( 40 )"                        ,;
                                                         "default"   => {|| space( 40 ) } }                    )

   hset( ::hColumns, "metodo_pago_codigo",             {  "create"   => "VARCHAR( 20 )"                        ,;
                                                         "default"   => {|| space( 20 ) } }                    )

   hset( ::hColumns, "almacen_codigo",                {  "create"    => "VARCHAR( 20 )"                        ,;
                                                         "default"   => {|| space( 20 ) } }                    )

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
      facturas.id AS id,
      facturas.uuid AS uuid,
      CONCAT( facturas.serie, '-', facturas.numero ) AS numero,
      facturas.fecha AS fecha,
      facturas.delegacion_uuid AS delegacion_uuid,
      facturas.sesion_uuid AS sesion_uuid,
      facturas.recargo_equivalencia AS recargo_equivalencia,
      facturas.cliente_codigo AS cliente_codigo,
      facturas.created_at AS created_at,
      facturas.updated_at AS updated_at,
      clientes.nombre AS cliente_nombre,
      clientes.dni AS cliente_dni,
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
      ( %1$s( facturas.uuid, facturas.recargo_equivalencia ) ) AS total
   ENDTEXT

   cColumns    := hb_strformat( cColumns, Company():getTableName( 'FacturaClienteTotalSummaryWhereUuid' ) )

RETURN ( cColumns )

//---------------------------------------------------------------------------//

METHOD getInitialSelect() CLASS SQLOperacionesComercialesModel

   local cSql

   TEXT INTO cSql

   SELECT
      %5$s

   FROM %1$s AS facturas

      LEFT JOIN %2$s clientes
         ON facturas.cliente_codigo = clientes.codigo AND clientes.deleted_at = 0

      LEFT JOIN %3$s direcciones
         ON clientes.uuid = direcciones.parent_uuid AND direcciones.codigo = 0

      LEFT JOIN %4$s tarifas
         ON facturas.tarifa_codigo = tarifas.codigo

   ENDTEXT

   cSql  := hb_strformat(  cSql,;
                           ::getTableName(),;
                           ::getTercerosModel():getTableName(),;
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

   SELECT SUM( pagos.importe ) AS total_pagado

      FROM %1$s AS facturas_clientes

      INNER JOIN %2$s AS recibos
         ON facturas_clientes.uuid = recibos.parent_uuid

      INNER JOIN %3$s AS pagos_recibos
         ON pagos_recibos.recibo_uuid = recibos.uuid

      INNER JOIN %4$s AS pagos
         ON pagos_recibos.pago_uuid = pagos.uuid

      WHERE facturas_clientes.uuid = %5$s

      GROUP BY facturas_clientes.uuid
   ENDTEXT

   cSql  := hb_strformat(  cSql,;
                           ::getTableName(),;
                           SQLRecibosModel():getTableName(),;
                           SQLRecibosPagosModel():getTableName(),;
                           SQLPagosModel():getTableName(),;
                           quoted( uuidFactura ) )

RETURN ( getSQLDatabase():getValue( cSql, 0 ) )

//---------------------------------------------------------------------------//

METHOD testCreateFactura( uuid ) CLASS SQLOperacionesComercialesModel

   local hBuffer  := ::loadBlankBuffer()

   hset( hBuffer, "serie", "TEST" )
   hset( hBuffer, "numero", 1 )
   hset( hBuffer, "uuid", uuid )
   hset( hBuffer, "cliente_codigo", "0" )
   hset( hBuffer, "metodo_pago_codigo", "0" )
   hset( hBuffer, "almacen_codigo", "0" )
   hset( hBuffer, "tarifa_codigo", "0" )

RETURN ( ::insertBuffer( hBuffer ) ) 

//---------------------------------------------------------------------------//

METHOD testCreateFacturaConRecargoDeEqivalencia( uuid ) CLASS SQLOperacionesComercialesModel

   local hBuffer  := ::loadBlankBuffer()

   hset( hBuffer, "serie", "TEST" )
   hset( hBuffer, "numero", 1 )
   hset( hBuffer, "uuid", uuid )
   hset( hBuffer, "cliente_codigo", "0" )
   hset( hBuffer, "metodo_pago_codigo", "0" )
   hset( hBuffer, "almacen_codigo", "0" )
   hset( hBuffer, "recargo_equivalencia", 1 )
   hset( hBuffer, "tarifa_codigo", "0" )

RETURN ( ::insertBuffer( hBuffer ) )

//---------------------------------------------------------------------------//

METHOD testCreateFacturaConPlazos( uuid ) CLASS SQLOperacionesComercialesModel

   local hBuffer  := ::loadBlankBuffer()

   hset( hBuffer, "serie", "TEST" )
   hset( hBuffer, "numero", 1 )
   hset( hBuffer, "uuid", uuid )
   hset( hBuffer, "cliente_codigo", "0" )
   hset( hBuffer, "metodo_pago_codigo", "1" )
   hset( hBuffer, "almacen_codigo", "0" )
   hset( hBuffer, "tarifa_codigo", "0" )

RETURN ( ::insertBuffer( hBuffer ) )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
