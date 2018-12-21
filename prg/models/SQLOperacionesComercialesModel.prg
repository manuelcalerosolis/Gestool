#include "FiveWin.Ch"
#include "Factu.ch"

//---------------------------------------------------------------------------//

CLASS SQLOperacionesComercialesModel FROM SQLCompanyModel

   DATA cConstraints                   // INIT "PRIMARY KEY ( numero, serie )"

   METHOD getColumns()

   METHOD getColumnsSelect()           VIRTUAL
   
   METHOD getTercerosCodigo()          VIRTUAL

   METHOD getInitialSelect()

   METHOD getTercerosModel()           VIRTUAL

   METHOD getNumeroWhereUuid( uuid )

   METHOD maxNumberWhereSerie( cSerie )

#ifdef __TEST__

   METHOD totalPaid( uuidFactura )

   METHOD testCreateFactura( uuid )

   METHOD testCreateFacturaConRecargoDeEqivalencia( uuid )

   METHOD testCreateFacturaConVariosPlazos( uuid )

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

METHOD getInitialSelect() CLASS SQLOperacionesComercialesModel

   local cSql

   TEXT INTO cSql

   SELECT
      %5$s

   FROM %1$s AS operaciones_comerciales

      LEFT JOIN %2$s terceros
         ON operaciones_comerciales.tercero_codigo = terceros.codigo AND terceros.deleted_at = 0

      LEFT JOIN %3$s direcciones
         ON terceros.uuid = direcciones.parent_uuid AND direcciones.codigo = 0

      LEFT JOIN %4$s tarifas
         ON operaciones_comerciales.tarifa_codigo = tarifas.codigo

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

METHOD maxNumberWhereSerie( cSerie ) CLASS SQLOperacionesComercialesModel

   local cSql

   cSql        := "SELECT MAX( numero ) FROM " + ::getTableName() + " "
   cSql        +=    "WHERE serie = " + quoted( cSerie )

RETURN ( ::getDatabase():getValue( cSql, 0 ) + 1 )

//---------------------------------------------------------------------------//

#ifdef __TEST__

METHOD testCreateFactura( uuid ) CLASS SQLOperacionesComercialesModel

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

METHOD testCreateFacturaConRecargoDeEqivalencia( uuid ) CLASS SQLOperacionesComercialesModel

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

METHOD testCreateFacturaConVariosPlazos( uuid ) CLASS SQLOperacionesComercialesModel

   local hBuffer  := ::loadBlankBuffer()

   hset( hBuffer, "serie", "TEST" )
   hset( hBuffer, "numero", 1 )
   hset( hBuffer, "uuid", uuid )
   hset( hBuffer, "tercero_codigo", "0" )
   hset( hBuffer, "metodo_pago_codigo", "1" )
   hset( hBuffer, "almacen_codigo", "0" )
   hset( hBuffer, "tarifa_codigo", "0" )

RETURN ( ::insertBuffer( hBuffer ) )

#endif

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
