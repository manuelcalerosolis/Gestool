#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS FacturasClientesRepository FROM SQLBaseRepository

   METHOD getTableName()                  INLINE ( SQLFacturasClientesModel():getTableName() ) 

   METHOD getSentenceTotals( uuidFactura ) 

   METHOD getTotals( uuidFactura )        INLINE ( ::getDatabase():selectFetchHash( ::getSentenceTotals( uuidFactura ) ) )

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
      lineas.importeBruto AS importeBruto,
      ( @descuento := ( SELECT 
         SUM( facturas_clientes_descuentos.descuento ) 
         FROM %3$s 
         WHERE facturas_clientes_descuentos.parent_uuid = %4$s ) ) AS totalDescuentos,
      ( @neto := lineas.importeBruto - IF( @descuento IS NULL, 0, ( lineas.importeBruto * @descuento / 100 ) ) ) AS importeNeto,
      lineas.iva AS porcentajeIVA, 
      ( @recargo := IF( lineas.recargo_equivalencia IS NULL, 0, @neto * lineas.recargo_equivalencia / 100) ) AS importeRecargo,
      ( @iva := IF( lineas.iva IS NULL, 0, @neto * lineas.iva / 100 + @recargo) ) AS importeIVA,  
      ( @neto + @iva) AS importeTotal
      
   FROM 
   (
   SELECT 
      SUM(  
         @importeLinea := ( IFNULL( facturas_clientes_lineas.unidad_medicion_factor, 1 ) * facturas_clientes_lineas.articulo_unidades * facturas_clientes_lineas.articulo_precio ) - IF( facturas_clientes_lineas.descuento IS NULL, 0, @importeLinea * facturas_clientes_lineas.descuento / 100 ) ) AS importeBruto,
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

   logwrite( cSql )

RETURN ( cSql )

//---------------------------------------------------------------------------//

METHOD dropProcedureTotales() CLASS FacturasClientesRepository 

RETURN ( "DROP PROCEDURE IF EXISTS " + Company():getTableName( 'FacturasClientesTotales' ) + ";" )

//---------------------------------------------------------------------------//

METHOD callTotals( uuidFactura ) CLASS FacturasClientesRepository

   local hTotals  

   getSQLDatabase():Exec( "CALL " + Company():getTableName( 'FacturasClientesTotales' ) + "( '" + uuidFactura + "', @totalBruto, @totalDescuento, @totalIva, @totalImporte, @totalBase )" ) 
   
   hTotals           := getSQLDatabase():selectFetchHash( "SELECT @totalBruto AS totalBruto, @totalDescuento AS totalDescuento, @totalIva AS totalIva, @totalImporte AS totalImporte, @totalBase AS totalBase" ) 

   msgalert( hb_valtoexp(atail( hTotals )) )

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
      DECLARE importeBeforeIva      DECIMAL( 19, 6 );
      DECLARE base                  DECIMAL( 19, 6 );
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
                                       * (IFNULL( facturas_clientes_lineas.descuento, 0 ) ) /100)) 
                                 FROM facturas_clientes_lineas AS facturas_clientes_lineas 
                                 WHERE facturas_clientes_lineas.parent_uuid = uuidFactura);
   /*sacamos el porcentaje total de descuentos de la cabecera de la factura*/

      SET porcentajeDescuento =  (  SELECT SUM(facturas_clientes_descuentos.descuento)
                                    FROM %3$s AS facturas_clientes_descuentos
                                    WHERE facturas_clientes_descuentos.parent_uuid = uuidFactura );

/*sacamos el importe menos el descuento de cada linea, para sacar el iva y los decuentos de la cabecera*/
      SET importeBeforeIva    = ( importeBruto - descuentoLineas ); 
/*calculamos el importe del descuento de la cabecera*/
      SET importeDescuento    = ( importeBeforeIva  * porcentajeDescuento / 100 + descuentoLineas);
/*calculamos la base*/
      SET base                = ( importeBeforeIva - importeDescuento );
/*Calculamos el iva por cada linea, ya que pueden contener impuestos diferentes*/

      SET ivaTotal            =( SELECT SUM(preciosiniva * precio.iva /100)
                                 FROM(
                                    SELECT SUM(IFNULL( facturas_clientes_lineas.unidad_medicion_factor, 1 ) 
                                             * facturas_clientes_lineas.articulo_unidades 
                                             * facturas_clientes_lineas.articulo_precio ) 
                                          - SUM( (IFNULL( facturas_clientes_lineas.unidad_medicion_factor, 1 )  
                                             * facturas_clientes_lineas.articulo_unidades 
                                             * facturas_clientes_lineas.articulo_precio 
                                             * (IFNULL( facturas_clientes_lineas.descuento, 0 ) ) /100)) as preciosiniva,
                                          facturas_clientes_lineas.iva
                                    FROM gestool_00vg.facturas_clientes_lineas
                                    WHERE facturas_clientes_lineas.parent_uuid= uuidFactura
                                    GROUP BY iva) precio ); 

/*calculamos el importe total de la factura, restando los descuentos y sumando el iva*/
      SET importeFactura     = importeBeforeIva + ivaTotal; 

      IF importeDescuento IS NOT NULL THEN 
         SET importeFactura  = importeBeforeIva - importeDescuento + ivaTotal; 
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
                           SQLFacturasClientesDescuentosModel():getTableName() )

RETURN ( cSQL )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//


