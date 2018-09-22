#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS FacturasClientesRepository FROM SQLBaseRepository

   METHOD getTableName()                  INLINE ( SQLFacturasClientesModel():getTableName() ) 

   METHOD getSentenceTotals( uuidFactura ) 

   METHOD getSentenceTotal( uuidFactura )

   METHOD getTotals( uuidFactura )        INLINE ( ::getDatabase():selectFetchHash( ::getSentenceTotals( uuidFactura ) ) )

   METHOD getTotal( uuidFactura )         

   METHOD getSQLFunctions()               INLINE ( {  ::dropProcedureTotales(),;
                                                      ::createProcedureTotales() } )

   METHOD dropProcedureTotales()  

   METHOD createProcedureTotales()

   METHOD callTotals( uuidFactura )

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
                           WHERE facturas_clientes_descuentos.parent_uuid = %4$s ) ) AS totalDescuentosPie,

      ( @totalDescuento := IF( @descuento IS NULL, 0, ROUND( ( ( lineas.importeBruto - lineas.descuentoTotalLinea ) * @descuento / 100 ) ) ) + lineas.descuentoTotalLinea ) as totalDescuento,

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
            ( @importeLinea := ( IFNULL( facturas_clientes_lineas.unidad_medicion_factor, 1 ) * facturas_clientes_lineas.articulo_unidades * facturas_clientes_lineas.articulo_precio ) ) ), 2 ) AS importeBruto,
        ROUND( SUM( 
            @descuentoLinea := IF( facturas_clientes_lineas.descuento IS NULL, 0, ( IFNULL( facturas_clientes_lineas.unidad_medicion_factor, 1 ) * facturas_clientes_lineas.articulo_unidades * facturas_clientes_lineas.articulo_precio ) ) *  IFNULL(facturas_clientes_lineas.descuento,0) / 100 ) ,2 ) AS descuentoTotalLinea ,
            facturas_clientes_lineas.iva,
            facturas_clientes_lineas.recargo_equivalencia,
            facturas_clientes_lineas.descuento,
            facturas_clientes_lineas.parent_uuid
         FROM %2$s AS facturas_clientes_lineas 
            WHERE facturas_clientes_lineas.parent_uuid = %4$s 
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

   logwrite( cSql )

RETURN ( cSql )

//---------------------------------------------------------------------------//

METHOD getTotal( uuidFactura )

   local aTotal   := ::getDatabase():selectFetchHash( ::getSentenceTotal( uuidFactura ) ) 

RETURN ( if( !empty( aTotal ), atail( aTotal ), nil ) )

//---------------------------------------------------------------------------//

METHOD dropProcedureTotales() CLASS FacturasClientesRepository 

RETURN ( "DROP PROCEDURE IF EXISTS " + Company():getTableName( 'FacturasClientesTotales' ) + ";" )

//---------------------------------------------------------------------------//

METHOD callTotals( uuidFactura ) CLASS FacturasClientesRepository

   local hTotals  

   getSQLDatabase():Exec( "CALL " + Company():getTableName( 'FacturasClientesTotales' ) + "( '" + uuidFactura + "', @totalBruto, @totalDescuento, @totalIva, @totalImporte, @totalBase )" ) 
   
   hTotals           := getSQLDatabase():selectFetchHash( "SELECT @totalBruto AS totalBruto, @totalDescuento AS totalDescuento, @totalIva AS totalIva, @totalImporte AS totalImporte, @totalBase AS totalBase" ) 

RETURN ( atail( hTotals ) )

//---------------------------------------------------------------------------//

METHOD createProcedureTotales( uuidFactura ) CLASS FacturasClientesRepository

local cSQL

   TEXT INTO cSql

   CREATE DEFINER=`root`@`localhost` PROCEDURE %1$s ( IN uuidFactura CHAR( 40 ), OUT totalBruto DECIMAL( 19, 6 ), OUT totalDescuento DECIMAL( 19, 6 ), OUT totalIva DECIMAL( 19,6 ), OUT totalImporte DECIMAL( 19,6 ), OUT totalBase DECIMAL( 19,6 ) )
      LANGUAGE SQL 
      NOT DETERMINISTIC 
      CONTAINS SQL 
      SQL SECURITY DEFINER 
      COMMENT '' 
      BEGIN 

      DECLARE importeBruto          DECIMAL( 19, 6 );
      DECLARE descuentoLineas       DECIMAL( 19, 6 );
      DECLARE importeDescuento      DECIMAL( 19, 6 );
      DECLARE importeFactura        DECIMAL( 19, 6 );
      DECLARE porcentajeDescuento   DECIMAL( 7, 4 );
      DECLARE ivaTotal              DECIMAL( 19, 6 );
      DECLARE base                  DECIMAL( 19, 6 );
      DECLARE recargo               TINYINT( 1 );
      DECLARE importeRecargo        DECIMAL( 19, 6 );
      
      /*sacamos el importe total de las lineas*/

      SET importeBruto        =  (  SELECT 
                                       SUM( IFNULL( facturas_clientes_lineas.unidad_medicion_factor, 1 ) 
                                          * facturas_clientes_lineas.articulo_unidades 
                                          * facturas_clientes_lineas.articulo_precio )
                                       FROM %2$s AS facturas_clientes_lineas 
                                       WHERE facturas_clientes_lineas.parent_uuid = uuidFactura );

/*sacamos el descuento que tiene cada linea si lo tuviera*/      
      SET descuentoLineas     = ( SELECT 
                                    SUM( (IFNULL( facturas_clientes_lineas.unidad_medicion_factor, 1 ) 
                                       * facturas_clientes_lineas.articulo_unidades 
                                       * facturas_clientes_lineas.articulo_precio 
                                       * ( IFNULL( facturas_clientes_lineas.descuento, 0 ) ) / 100 ) ) 
                                 FROM %2$s AS facturas_clientes_lineas 
                                 WHERE facturas_clientes_lineas.parent_uuid = uuidFactura);
   /*sacamos el porcentaje total de descuentos de la cabecera de la factura*/

      SET porcentajeDescuento =  (  SELECT SUM(facturas_clientes_descuentos.descuento)
                                    FROM %3$s AS facturas_clientes_descuentos
                                    WHERE facturas_clientes_descuentos.parent_uuid = uuidFactura );

/*calculamos la base*/
      SET base                =  (  SELECT SUM(descuentoLinea.pdescuento - descuentoLinea.pdescuento * IFNULL( porcentajeDescuento, 0) / 100)
                                    FROM(
                                          SELECT 
                                             SUM( IFNULL( facturas_clientes_lineas.unidad_medicion_factor, 1 ) 
                                                * facturas_clientes_lineas.articulo_unidades 
                                                * facturas_clientes_lineas.articulo_precio )
                                             - SUM( (IFNULL( facturas_clientes_lineas.unidad_medicion_factor, 1 )  
                                                * facturas_clientes_lineas.articulo_unidades 
                                                * facturas_clientes_lineas.articulo_precio 
                                                * (IFNULL( facturas_clientes_lineas.descuento, 0 ) ) /100)) as pdescuento
                                             FROM %2$s AS facturas_clientes_lineas
                                             WHERE facturas_clientes_lineas.parent_uuid =uuidFactura
                                             GROUP BY id) descuentoLinea);

      SET importeDescuento    =  ( importeBruto - base );

/*Calculamos el iva por cada linea, ya que pueden contener impuestos diferentes*/

      SET ivaTotal            =  ( SELECT SUM(descuenTototalLinea.lineasiniva * descuenTototalLinea.iva /100) AS ivatotal
                                    FROM(
                                       SELECT (descuentoLinea.pdescuento - descuentoLinea.pdescuento * IFNULL(porcentajeDescuento,0) / 100) as lineasiniva,
                                                descuentoLinea.iva   
                                       FROM(
                                          SELECT 
                                              IFNULL( facturas_clientes_lineas.unidad_medicion_factor, 1 ) 
                                                * facturas_clientes_lineas.articulo_unidades 
                                                * facturas_clientes_lineas.articulo_precio 
                                             - (IFNULL( facturas_clientes_lineas.unidad_medicion_factor, 1 )  
                                                * facturas_clientes_lineas.articulo_unidades 
                                                * facturas_clientes_lineas.articulo_precio 
                                                * (IFNULL( facturas_clientes_lineas.descuento, 0 ) ) /100) as pdescuento, 
                                                facturas_clientes_lineas.iva
                                             FROM %2$s AS facturas_clientes_lineas
                                             WHERE facturas_clientes_lineas.parent_uuid = uuidFactura
                                             GROUP BY id,iva) descuentoLinea) as descuenTototalLinea );
/*comprobamos si existe recargo*/
      SET recargo =                 (  SELECT recargo_equivalencia 
                                       FROM %4$s AS facturas_clientes
                                       WHERE facturas_clientes.uuid= uuidFactura );

/*calculamos el rescargo si existe el recargo*/
IF recargo = 1 THEN
      SET importeRecargo =          ( SELECT SUM(descuenTototalLinea.lineasiniva * descuenTototalLinea.recargo_equivalencia /100) AS recargoTotal
                                       FROM(
                                          SELECT (descuentoLinea.pdescuento -descuentoLinea.pdescuento * IFNULL( porcentajeDescuento, 0) / 100) as lineasiniva,
                                                   descuentoLinea.recargo_equivalencia   
                                          FROM(
                                             SELECT 
                                                IFNULL( facturas_clientes_lineas.unidad_medicion_factor, 1 ) 
                                                   * facturas_clientes_lineas.articulo_unidades 
                                                   * facturas_clientes_lineas.articulo_precio 
                                                - (IFNULL( facturas_clientes_lineas.unidad_medicion_factor, 1 )  
                                                   * facturas_clientes_lineas.articulo_unidades 
                                                   * facturas_clientes_lineas.articulo_precio 
                                                   * (IFNULL( facturas_clientes_lineas.descuento, 0 ) ) /100) as pdescuento, 
                                                facturas_clientes_lineas.recargo_equivalencia
                                             FROM facturas_clientes_lineas AS facturas_clientes_lineas
                                             WHERE facturas_clientes_lineas.parent_uuid = uuidFactura
                                             GROUP BY id,iva) descuentoLinea) as descuenTototalLinea  );
      END IF;                             

/*calculamos el importe total de la factura, restando los descuentos y sumando el iva*/
      SET importeFactura     = base + ivaTotal; 

      IF importeRecargo IS NOT NULL THEN 
         SET importeFactura  = base + ivaTotal + importeRecargo; 
      END IF;

      SELECT importeBruto           INTO totalBruto;
      SELECT importeDescuento       INTO totalDescuento;
      SELECT ivaTotal               INTO totalIva;
      SELECT importeFactura         INTO totalImporte;
      SELECT base                   INTO totalBase;

      END

   ENDTEXT

   cSql  := hb_strformat(  cSql,;
                           Company():getTableName( 'FacturasClientesTotales' ),;
                           SQLFacturasClientesLineasModel():getTableName(),;
                           SQLFacturasClientesDescuentosModel():getTableName(),;
                           SQLFacturasClientesModel():getTableName() )

RETURN ( cSQL )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//


