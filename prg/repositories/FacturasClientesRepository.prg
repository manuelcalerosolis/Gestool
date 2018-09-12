#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS FacturasClientesRepository FROM SQLBaseRepository

   METHOD getTableName()                  INLINE ( SQLFacturasClientesModel():getTableName() ) 

   METHOD getSQLFunctions()               INLINE ( {  ::dropProcedureTotales(),;
                                                      ::createProcedureTotales() } )

   METHOD dropProcedureTotales()  

   METHOD createProcedureTotales()

   METHOD callTotals( uuidFactura )

END CLASS

//---------------------------------------------------------------------------//

METHOD dropProcedureTotales() CLASS FacturasClientesRepository 

RETURN ( "DROP PROCEDURE IF EXISTS " + Company():getTableName( 'FacturasClientesTotales' ) + ";" )

//---------------------------------------------------------------------------//

METHOD callTotals( uuidFactura ) CLASS FacturasClientesRepository

   local hTotals  

   getSQLDatabase():Exec( "CALL " + Company():getTableName( 'FacturasClientesTotales' ) + "( '" + uuidFactura + "', @totalBruto, @totalDescuento, @totalIva, @totalImporte )" ) 
   
   hTotals           := getSQLDatabase():selectFetchHash( "SELECT @totalBruto AS totalBruto, @totalDescuento AS totalDescuento, @totalIva AS totalIva, @totalImporte AS totalImporte" ) 

RETURN ( atail( hTotals ) )

//---------------------------------------------------------------------------//

METHOD createProcedureTotales( uuidFactura ) CLASS FacturasClientesRepository

   local cSQL

   TEXT INTO cSql

   CREATE DEFINER=`root`@`localhost` PROCEDURE %1$s ( IN uuidFactura CHAR( 40 ), OUT totalBruto DECIMAL( 19, 6 ), OUT totalDescuento DECIMAL( 19, 6 ), OUT totalIva DECIMAL( 19,6 ), OUT totalImporte DECIMAL( 19,6 ) )
      LANGUAGE SQL 
      NOT DETERMINISTIC 
      CONTAINS SQL 
      SQL SECURITY DEFINER 
      COMMENT '' 
      BEGIN 

      DECLARE importeBruto          DECIMAL( 19, 6 );
      DECLARE importeDescuento      DECIMAL( 19, 6 );
      DECLARE importeFactura        DECIMAL( 19, 6 );
      DECLARE porcentajeDescuento   DECIMAL( 7, 4 );
      DECLARE ivaTotal              DECIMAL( 19,6 );

      SET importeBruto        =  (  SELECT 
                                       SUM( IFNULL( facturas_clientes_lineas.unidad_medicion_factor, 1 ) * facturas_clientes_lineas.articulo_unidades * facturas_clientes_lineas.articulo_precio )
                                       FROM %2$s AS facturas_clientes_lineas 
                                       WHERE facturas_clientes_lineas.parent_uuid = uuidFactura );

      SET porcentajeDescuento =  (  SELECT SUM(facturas_clientes_descuentos.descuento)
                                    FROM %3$s AS facturas_clientes_descuentos
                                    WHERE facturas_clientes_descuentos.parent_uuid = uuidFactura );

      SET ivaTotal            =  (  SELECT 
                                       SUM( IFNULL( facturas_clientes_lineas.unidad_medicion_factor, 1 ) * facturas_clientes_lineas.articulo_unidades * facturas_clientes_lineas.articulo_precio * facturas_clientes_lineas.iva /100)
                                       FROM %2$s AS facturas_clientes_lineas 
                                       WHERE facturas_clientes_lineas.parent_uuid = uuidFactura ); 

      SET importeDescuento   = ( importeBruto * porcentajeDescuento / 100 ); 

      SET importeFactura     = importeBruto + ivaTotal; 

      IF importeDescuento IS NOT NULL THEN 
         SET importeFactura  = importeBruto - importeDescuento + ivaTotal; 
      END IF;

      SELECT importeBruto           INTO totalBruto;
      SELECT importeDescuento       INTO totalDescuento;
      SELECT ivaTotal               INTO totalIva;
      SELECT importeFactura         INTO totalImporte;

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


