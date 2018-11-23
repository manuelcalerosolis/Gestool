#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS FacturasClientesRepository FROM SQLBaseRepository

   METHOD getTableName()                  INLINE ( SQLFacturasClientesModel():getTableName() ) 

   METHOD getSQLFunctions()               INLINE ( {  ::dropFunctionTotalWhereUuid(),;
                                                      ::createFunctionTotalWhereUuid(),;
                                                      ::dropFunctionSummaryTotalWhereUuid(),;
                                                      ::createFunctionSummaryTotalWhereUuid(),;
                                                      ::createTriggerDeleted() } )

   METHOD createFunctionTotalWhereUuid()
      METHOD dropFunctionTotalWhereUuid()
      METHOD callTotalWhereUuid( uuidFacturaCliente )
   
   METHOD createFunctionSummaryTotalWhereUuid()
      METHOD dropFunctionSummaryTotalWhereUuid()
      METHOD callSummaryTotalWhereUuid( uuidFacturaCliente )
   
   METHOD createTriggerDeleted()

   METHOD getSentenceTotals( uuidFactura ) 

   METHOD getSentenceTotal( uuidFactura )

   METHOD getSentenceTotalDocument( uuidFactura )

   METHOD getTotal( uuidFactura )         
   METHOD getTotals( uuidFactura )        INLINE ( ::getDatabase():selectFetchHash( ::getSentenceTotals( uuidFactura ) ) )

   //Envio de emails-----------------------------------------------------------

   METHOD getClientMailWhereFacturaUuid( uuidFactura ) 

END CLASS

//---------------------------------------------------------------------------//

METHOD getSentenceTotals( uuidFactura ) CLASS FacturasClientesRepository

   local cSql

   TEXT INTO cSql

   SELECT
      ROUND( lineas.importeBruto, 2 ) AS importeBruto,

      ( @descuento   := (  SELECT 
                           SUM( facturas_clientes_descuentos.descuento ) 
                           FROM %3$s AS facturas_clientes_descuentos 
                           WHERE facturas_clientes_descuentos.parent_uuid = %4$s 
                              AND facturas_clientes_descuentos.deleted_at = 0 ) ) AS totalDescuentosPie,

      ( @totalDescuento := IF( @descuento IS NULL, 0, ROUND( ( ( lineas.importeBruto - lineas.descuentoTotalLinea ) * @descuento / 100 ) ) ) + lineas.descuentoTotalLinea ) AS totalDescuento,

      ( @aplicarRecargo := (  SELECT recargo_equivalencia
                              FROM %1$s AS facturas_clientes 
                              WHERE facturas_clientes.uuid = %4$s ) ) AS aplicarRecargo,

      ( @neto := ROUND( lineas.importeBruto - @totalDescuento, 2 ) ) AS importeNeto,
      
      lineas.iva AS porcentajeIVA, 

      lineas.recargo_equivalencia AS recargoEquivalencia,

      ( @iva := IF( lineas.iva IS NULL, 0, ROUND( @neto * lineas.iva / 100, 2 ) ) ) AS importeIVA,  

      ( @recargo := IF( @aplicarRecargo = 0 OR lineas.recargo_equivalencia IS NULL, 0, ROUND( @neto * lineas.recargo_equivalencia / 100, 2 ) ) ) AS importeRecargo,

      ROUND( ( @neto + @iva + @recargo ), 2 ) AS importeTotal
      
   FROM 
      (
      SELECT 
        ROUND( SUM(  
            ( @importeLinea := ( IFNULL( facturas_clientes_lineas.unidad_medicion_factor, 1 ) * facturas_clientes_lineas.articulo_unidades * ( facturas_clientes_lineas.articulo_precio + IFNULL( facturas_clientes_lineas.incremento_precio, 0 ) ) ) ) ), 2 ) 
                        AS importeBruto,
        ROUND( SUM( 
            @descuentoLinea := IF( facturas_clientes_lineas.descuento IS NULL, 0, ( IFNULL( facturas_clientes_lineas.unidad_medicion_factor, 1 ) * facturas_clientes_lineas.articulo_unidades * facturas_clientes_lineas.articulo_precio ) ) *  IFNULL(facturas_clientes_lineas.descuento,0) / 100 ) ,2 ) AS descuentoTotalLinea,
            facturas_clientes_lineas.iva,
            facturas_clientes_lineas.recargo_equivalencia,
            facturas_clientes_lineas.descuento,
            facturas_clientes_lineas.parent_uuid
         FROM %2$s AS facturas_clientes_lineas 
            WHERE facturas_clientes_lineas.parent_uuid = %4$s
               AND facturas_clientes_lineas.deleted_at = 0 
            GROUP BY facturas_clientes_lineas.iva
      ) lineas

   ENDTEXT

   cSql  := hb_strformat( cSql, ::getTableName(), SQLFacturasClientesLineasModel():getTableName(), SQLFacturasClientesDescuentosModel():getTableName(), quoted( uuidFactura ) )

RETURN ( cSql ) 

//---------------------------------------------------------------------------//

METHOD getSentenceTotal( uuidFactura ) CLASS FacturasClientesRepository

   local cSql

   TEXT INTO cSql

   SELECT
      SUM( totales.importeBruto ) AS totalBruto,
      SUM( totales.importeNeto ) AS totalNeto,
      SUM( totales.importeIVA ) AS totalIVA,
      SUM( totales.importeRecargo ) AS totalRecargo,
      SUM( totales.totalDescuento ) AS totalDescuento,
      SUM( totales.importeTotal ) AS totalDocumento

      FROM ( %1$s ) totales

   ENDTEXT

   cSql  := hb_strformat( cSql, ::getSentenceTotals( uuidFactura ) )

RETURN ( cSql )

//---------------------------------------------------------------------------//

METHOD getSentenceTotalDocument( uuidFactura ) CLASS FacturasClientesRepository

   local cSql

   TEXT INTO cSql

   SELECT
      SUM( totales.importeTotal ) AS totalDocumento

      FROM ( %1$s ) totales

   ENDTEXT

   cSql  := hb_strformat( cSql, ::getSentenceTotals( uuidFactura ) )

RETURN ( cSql )

//---------------------------------------------------------------------------//

METHOD getTotal( uuidFactura )

   local aTotal   := ::getDatabase():selectFetchHash( ::getSentenceTotal( uuidFactura ) ) 

RETURN ( if( !empty( aTotal ), atail( aTotal ), nil ) )

//---------------------------------------------------------------------------//

METHOD getClientMailWhereFacturaUuid( uuidFactura ) CLASS FacturasClientesRepository

   local cSQL

   TEXT INTO cSql

      SELECT direcciones.email

         FROM %1$s AS facturas_clientes

         INNER JOIN %2$s AS clientes
            ON clientes.codigo = facturas_clientes.cliente_codigo
         
         INNER JOIN %3$s AS direcciones
            ON clientes.uuid = direcciones.parent_uuid AND direcciones.principal = 0

         WHERE facturas_clientes.uuid = %4$s

      ENDTEXT

   cSql  := hb_strformat( cSql, ::getTableName(), SQLClientesModel():getTableName(), SQLDireccionesModel():getTableName(), quoted(uuidFactura) ) 

RETURN ( getSQLDatabase():getValue( cSql, "" ) ) 

//---------------------------------------------------------------------------//

METHOD createTriggerDeleted() CLASS FacturasClientesRepository

   local cSQL

   TEXT INTO cSql
      CREATE OR REPLACE TRIGGER %1$s
      AFTER UPDATE ON %2$s
      FOR EACH ROW 
      BEGIN
         UPDATE %3$s SET deleted_at = new.deleted_at
            WHERE %3$s.parent_uuid = new.uuid;
         
         UPDATE %4$s SET deleted_at = new.deleted_at
            WHERE %4$s.parent_uuid = new.uuid;

         UPDATE %5$s SET deleted_at = new.deleted_at
            WHERE %5$s.parent_uuid = new.uuid;

         UPDATE %6$s SET deleted_at = new.deleted_at
            WHERE %6$s.parent_uuid = new.uuid;

         UPDATE %7$s SET deleted_at = new.deleted_at
            WHERE %7$s.parent_uuid = new.uuid;
      END;
   ENDTEXT

   cSql  := hb_strformat( cSql,  Company():getTableName( 'FacturaClienteDeleted' ),;
                                 ::getTableName(),;
                                 SQLRecibosModel():getTableName(),;
                                 SQLFacturasClientesLineasModel():getTableName(),;
                                 SQLIncidenciasModel():getTableName(),;
                                 SQLFacturasClientesDescuentosModel():getTableName(),;
                                 SQLDireccionTipoDocumentoModel():getTableName() ) 

RETURN ( cSql )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

METHOD createFunctionTotalWhereUuid() CLASS FacturasClientesRepository

   local cSql

   TEXT INTO cSql

      CREATE DEFINER=`root`@`localhost` PROCEDURE %1$s ( IN `uuid_factura_cliente` CHAR(40) ) 

      LANGUAGE SQL 
      NOT DETERMINISTIC 
      CONTAINS SQL 
      SQL SECURITY DEFINER 
      COMMENT '' 
   
      BEGIN 

      SELECT
         ROUND( lineas.importeBruto, 2 ) AS importeBruto,

         ( @descuento   := (  SELECT 
                                 SUM( facturas_clientes_descuentos.descuento ) 
                                    FROM %4$s AS facturas_clientes_descuentos 
                                    WHERE facturas_clientes_descuentos.parent_uuid = uuid_factura_cliente 
                                       AND facturas_clientes_descuentos.deleted_at = 0 ) ) AS totalDescuentosPie,

         ( @totalDescuento := IF( @descuento IS NULL, 0, ROUND( ( ( lineas.importeBruto - lineas.descuentoTotalLinea ) * @descuento / 100 ) ) ) + lineas.descuentoTotalLinea ) AS totalDescuento,

         ( @aplicarRecargo := (  SELECT recargo_equivalencia
                                    FROM %2$s AS facturas_clientes 
                                    WHERE facturas_clientes.uuid = uuid_factura_cliente ) ) AS aplicarRecargo,

         ( @neto := ROUND( lineas.importeBruto - @totalDescuento, 2 ) ) AS importeNeto,
         
         lineas.iva AS porcentajeIVA, 

         lineas.recargo_equivalencia AS recargoEquivalencia,

         ( @iva := IF( lineas.iva IS NULL, 0, ROUND( @neto * lineas.iva / 100, 2 ) ) ) AS importeIVA,  

         ( @recargo := IF( @aplicarRecargo = 0 OR lineas.recargo_equivalencia IS NULL, 0, ROUND( @neto * lineas.recargo_equivalencia / 100, 2 ) ) ) AS importeRecargo,

         ROUND( ( @neto + @iva + @recargo ), 2 ) AS importeTotal
         
      FROM 
         (
         SELECT 
           ROUND( SUM(  
               ( @importeLinea := ( IFNULL( facturas_clientes_lineas.unidad_medicion_factor, 1 ) * facturas_clientes_lineas.articulo_unidades * ( facturas_clientes_lineas.articulo_precio + IFNULL( facturas_clientes_lineas.incremento_precio, 0 ) ) ) ) ), 2 ) AS importeBruto,
           ROUND( SUM( 
               @descuentoLinea := IF( facturas_clientes_lineas.descuento IS NULL, 0, ( IFNULL( facturas_clientes_lineas.unidad_medicion_factor, 1 ) * facturas_clientes_lineas.articulo_unidades * facturas_clientes_lineas.articulo_precio ) ) *  IFNULL(facturas_clientes_lineas.descuento,0) / 100 ) ,2 ) AS descuentoTotalLinea,
               facturas_clientes_lineas.iva,
               facturas_clientes_lineas.recargo_equivalencia,
               facturas_clientes_lineas.descuento,
               facturas_clientes_lineas.parent_uuid
            FROM %3$s AS facturas_clientes_lineas 
               WHERE facturas_clientes_lineas.parent_uuid = uuid_factura_cliente
                  AND facturas_clientes_lineas.deleted_at = 0 
               GROUP BY facturas_clientes_lineas.iva
         ) lineas;
      
      END 

   ENDTEXT

   cSql  := hb_strformat(  cSql,;
                           Company():getTableName( 'FacturaClienteTotalWhereUuid' ),;
                           ::getTableName(),;
                           SQLFacturasClientesLineasModel():getTableName(),;
                           SQLFacturasClientesDescuentosModel():getTableName() )

RETURN ( cSql )

//---------------------------------------------------------------------------//

METHOD dropFunctionTotalWhereUuid() CLASS FacturasClientesRepository  

RETURN ( "DROP PROCEDURE IF EXISTS " + Company():getTableName( 'FacturaClienteTotalWhereUuid' ) + ";" )

//---------------------------------------------------------------------------//

METHOD callTotalWhereUuid( uuidFacturaCliente ) CLASS FacturasClientesRepository

RETURN ( getSQLDatabase():Exec( "CALL " + Company():getTableName( 'FacturaClienteTotalWhereUuid' ) + "( " + quoted( uuidFacturaCliente ) + " )" ) )

//---------------------------------------------------------------------------//

METHOD createFunctionSummaryTotalWhereUuid( uuidFactura ) CLASS FacturasClientesRepository

   local cSql

   TEXT INTO cSql

      CREATE DEFINER=`root`@`localhost` PROCEDURE %1$s ( IN `uuid_factura_cliente` CHAR(40) ) 
      LANGUAGE SQL 
      NOT DETERMINISTIC 
      CONTAINS SQL 
      SQL SECURITY DEFINER 
      COMMENT '' 
   
      BEGIN 

      SELECT
         SUM( totales.importeBruto ) AS totalBruto,
         SUM( totales.importeNeto ) AS totalNeto,
         SUM( totales.importeIVA ) AS totalIVA,
         SUM( totales.importeRecargo ) AS totalRecargo,
         SUM( totales.totalDescuento ) AS totalDescuento,
         SUM( totales.importeTotal ) AS totalDocumento

      FROM 
         ( 
         SELECT
            ROUND( lineas.importeBruto, 2 ) AS importeBruto,

            ( @descuento   := (  SELECT 
                                    SUM( facturas_clientes_descuentos.descuento ) 
                                       FROM %4$s AS facturas_clientes_descuentos 
                                       WHERE facturas_clientes_descuentos.parent_uuid = uuid_factura_cliente 
                                          AND facturas_clientes_descuentos.deleted_at = 0 ) ) AS totalDescuentosPie,

            ( @totalDescuento := IF( @descuento IS NULL, 0, ROUND( ( ( lineas.importeBruto - lineas.descuentoTotalLinea ) * @descuento / 100 ) ) ) + lineas.descuentoTotalLinea ) AS totalDescuento,

            ( @aplicarRecargo := (  SELECT recargo_equivalencia
                                       FROM %2$s AS facturas_clientes 
                                       WHERE facturas_clientes.uuid = uuid_factura_cliente ) ) AS aplicarRecargo,

            ( @neto := ROUND( lineas.importeBruto - @totalDescuento, 2 ) ) AS importeNeto,
            
            lineas.iva AS porcentajeIVA, 

            lineas.recargo_equivalencia AS recargoEquivalencia,

            ( @iva := IF( lineas.iva IS NULL, 0, ROUND( @neto * lineas.iva / 100, 2 ) ) ) AS importeIVA,  

            ( @recargo := IF( @aplicarRecargo = 0 OR lineas.recargo_equivalencia IS NULL, 0, ROUND( @neto * lineas.recargo_equivalencia / 100, 2 ) ) ) AS importeRecargo,

            ROUND( ( @neto + @iva + @recargo ), 2 ) AS importeTotal
            
         FROM 
            (
            SELECT 
              ROUND( SUM(  
                  ( @importeLinea := ( IFNULL( facturas_clientes_lineas.unidad_medicion_factor, 1 ) * facturas_clientes_lineas.articulo_unidades * ( facturas_clientes_lineas.articulo_precio + IFNULL( facturas_clientes_lineas.incremento_precio, 0 ) ) ) ) ), 2 ) AS importeBruto,
              ROUND( SUM( 
                  @descuentoLinea := IF( facturas_clientes_lineas.descuento IS NULL, 0, ( IFNULL( facturas_clientes_lineas.unidad_medicion_factor, 1 ) * facturas_clientes_lineas.articulo_unidades * facturas_clientes_lineas.articulo_precio ) ) *  IFNULL(facturas_clientes_lineas.descuento,0) / 100 ) ,2 ) AS descuentoTotalLinea,
                  facturas_clientes_lineas.iva,
                  facturas_clientes_lineas.recargo_equivalencia,
                  facturas_clientes_lineas.descuento,
                  facturas_clientes_lineas.parent_uuid
               FROM %3$s AS facturas_clientes_lineas 
                  WHERE facturas_clientes_lineas.parent_uuid = uuid_factura_cliente
                     AND facturas_clientes_lineas.deleted_at = 0 
                  GROUP BY facturas_clientes_lineas.iva
            ) lineas

         ) AS totales;
      
      END 

   ENDTEXT

   cSql  := hb_strformat(  cSql,;
                           Company():getTableName( 'FacturaClienteSummaryTotalWhereUuid' ),;
                           ::getTableName(),;
                           SQLFacturasClientesLineasModel():getTableName(),;
                           SQLFacturasClientesDescuentosModel():getTableName() )

RETURN ( cSql )

//---------------------------------------------------------------------------//

METHOD dropFunctionSummaryTotalWhereUuid() CLASS FacturasClientesRepository  

RETURN ( "DROP PROCEDURE IF EXISTS " + Company():getTableName( 'FacturaClienteSummaryTotalWhereUuid' ) + ";" )

//---------------------------------------------------------------------------//

METHOD callSummaryTotalWhereUuid( uuidFacturaCliente ) CLASS FacturasClientesRepository

RETURN ( getSQLDatabase():Exec( "CALL " + Company():getTableName( 'FacturaClienteSummaryTotalWhereUuid' ) + "( " + quoted( uuidFacturaCliente ) + " )" ) )

//---------------------------------------------------------------------------//

