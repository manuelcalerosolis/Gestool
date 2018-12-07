#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS FacturasClientesRepository FROM SQLBaseRepository

   METHOD getTableName()                  INLINE ( SQLFacturasClientesModel():getTableName() ) 

   METHOD getSQLFunctions()               INLINE ( {  ::dropFunctionTotalSummaryWhereUuid(),;
                                                      ::createFunctionTotalSummaryWhereUuid(),;
                                                      ::dropFunctionRecargoEquivalenciaWhereUuid(),;
                                                      ::createFunctionRecargoEquivalenciaWhereUuid(),;
                                                      ::dropFunctionDescuentoWhereUuid(),;
                                                      ::createFunctionDescuentoWhereUuid(),;
                                                      ::dropFunctionTotalDescuentoWhereUuid(),;
                                                      ::createFunctionTotalDescuentoWhereUuid() } )

   METHOD createFunctionTotalSummaryWhereUuid()
      METHOD dropFunctionTotalSummaryWhereUuid()
      METHOD selectTotalSummaryWhereUuid( uuidFacturaCliente, aplicarRecargo )

   METHOD createFunctionRecargoEquivalenciaWhereUuid() 
      METHOD dropFunctionRecargoEquivalenciaWhereUuid()   
      METHOD selectRecargoEquivalenciaWhereUuid( uuidFacturaCliente ) 

   METHOD createFunctionDescuentoWhereUuid() 
      METHOD dropFunctionDescuentoWhereUuid()   
      METHOD selectDescuentoWhereUuid( uuidFacturaCliente ) 

   METHOD createFunctionTotalDescuentoWhereUuid()
      METHOD dropFunctionTotalDescuentoWhereUuid()
      METHOD selectTotalDescuentoWhereUuid( uuidFacturaCliente, importeBruto )
   
   METHOD getSentenceDescuento() 
   
   METHOD getSentenceLineas() 

   METHOD getSentenceTotales()

   METHOD getSentenceRecargoEquivalenciaAsSelect()
   METHOD getSentenceRecargoEquivalenciaAsParam()
   METHOD getSentenceDescuentosAsSelect( uuidFactura ) 

   METHOD getSentenceTotalDocument( uuidFactura )

   METHOD getTotalesDocument( uuidFactura )         
   METHOD getSentenceTotalesDocument( uuidFactura )

   METHOD getTotalesDocumentGroupByIVA( uuidFactura )
   METHOD getSentenceTotalesDocumentGroupByIVA( uuidFactura )

   //Envio de emails-----------------------------------------------------------

   METHOD getClientMailWhereFacturaUuid( uuidFactura ) 

END CLASS

//---------------------------------------------------------------------------//

METHOD getSentenceTotalesDocumentGroupByIVA( uuidFacturaCliente ) CLASS FacturasClientesRepository

RETURN ( ::getSentenceTotalesDocument( uuidFacturaCliente ) + " GROUP BY totales.porcentajeIVA" )

//---------------------------------------------------------------------------//

METHOD getSentenceTotalesDocument( uuidFacturaCliente ) CLASS FacturasClientesRepository

   local cSql

   TEXT INTO cSql

   SELECT
      SUM( totales.importeBruto ) AS totalBruto,
      ( SELECT %2$s( uuidFacturaCliente, totalBruto ) ) AS totalDescuento,
      SUM( totales.importeNeto ) AS totalNeto,
      SUM( totales.porcentajeIVA ) AS porcentajeIVA,
      SUM( totales.recargoEquivalencia ) AS recargoEquivalencia,
      SUM( totales.importeIVA ) AS totalIVA,
      SUM( totales.importeRecargo ) AS totalRecargo,
      SUM( totales.importeTotal ) AS totalDocumento
   FROM ( %1$s ) AS totales

   ENDTEXT

   cSql  := hb_strformat(  cSql,;
                           ::getSentenceTotales( uuidFacturaCliente ),;
                           Company():getTableName( 'FacturaClienteTotalDescuentoWhereUuid' )  )

   logwrite( cSql )

RETURN ( cSql )

//---------------------------------------------------------------------------//

METHOD getSentenceTotalDocument( uuidFacturaCliente ) CLASS FacturasClientesRepository

   local cSql

   TEXT INTO cSql

   SELECT
      SUM( totales.importeTotal ) AS totalDocumento
   FROM ( %1$s ) AS totales

   ENDTEXT

   cSql  := hb_strformat( cSql, ::getSentenceTotales( uuidFacturaCliente ) )

RETURN ( cSql )

//---------------------------------------------------------------------------//

METHOD getTotalesDocument( uuidFacturaCliente ) CLASS FacturasClientesRepository

   local aTotal   := ::getDatabase():selectFetchHash( ::getSentenceTotalesDocument( uuidFacturaCliente ) ) 

RETURN ( if( hb_isarray( aTotal ), atail( aTotal ), nil ) )

//---------------------------------------------------------------------------//

METHOD getTotalesDocumentGroupByIVA( uuidFacturaCliente ) CLASS FacturasClientesRepository

   local aTotal   := ::getDatabase():selectFetchHash( ::getSentenceTotalesDocumentGroupByIVA( uuidFacturaCliente ) ) 

RETURN ( if( hb_isarray( aTotal ), aTotal, nil ) )

//---------------------------------------------------------------------------//

METHOD getClientMailWhereFacturaUuid( uuidFacturaCliente ) CLASS FacturasClientesRepository

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

   cSql  := hb_strformat( cSql, ::getTableName(), SQLClientesModel():getTableName(), SQLDireccionesModel():getTableName(), quoted( uuidFacturaCliente ) ) 

RETURN ( getSQLDatabase():getValue( cSql, "" ) ) 

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

METHOD createFunctionTotalSummaryWhereUuid() CLASS FacturasClientesRepository

   local cSql

   TEXT INTO cSql

   CREATE DEFINER=`root`@`localhost` 
   FUNCTION %1$s ( `uuid_factura_cliente` CHAR( 40 ), `recargo_equivalencia_factura_cliente` TINYINT( 1 ) )
   RETURNS DECIMAL( 19, 6 )
   LANGUAGE SQL
   NOT DETERMINISTIC
   CONTAINS SQL
   SQL SECURITY DEFINER
   COMMENT ''

   BEGIN

      DECLARE TotalSummary DECIMAL( 19, 6 );

      SELECT
         SUM( totales.importeTotal ) INTO TotalSummary
      FROM 
         ( %2$s ) AS totales;
      
      RETURN TotalSummary;

   END

   ENDTEXT

   cSql  := hb_strformat(  cSql,;
                           Company():getTableName( 'FacturaClienteTotalSummaryWhereUuid' ),;
                           ::getSentenceTotales() )

RETURN ( cSql )

//---------------------------------------------------------------------------//

METHOD dropFunctionTotalSummaryWhereUuid() CLASS FacturasClientesRepository  

RETURN ( "DROP FUNCTION IF EXISTS " + Company():getTableName( 'FacturaClienteTotalSummaryWhereUuid' ) + ";" )

//---------------------------------------------------------------------------//

METHOD selectTotalSummaryWhereUuid( uuidFacturaCliente, aplicarRecargo ) CLASS FacturasClientesRepository

RETURN ( getSQLDatabase():Exec( "SELECT " + Company():getTableName( 'FacturaClienteTotalSummaryWhereUuid' ) + "( " + quoted( uuidFacturaCliente ) + ", " + toSqlString( aplicarRecargo ) + " )" ) )

//---------------------------------------------------------------------------//

METHOD createFunctionRecargoEquivalenciaWhereUuid() CLASS FacturasClientesRepository

   local cSql

   TEXT INTO cSql

   CREATE DEFINER=`root`@`localhost` 
   FUNCTION %1$s ( `uuid_factura_cliente` CHAR( 40 ) )
   RETURNS TINYINT( 1 )
   LANGUAGE SQL
   NOT DETERMINISTIC
   CONTAINS SQL
   SQL SECURITY DEFINER
   COMMENT ''

   BEGIN

   DECLARE RecargoEquivalencia TINYINT( 1 );

   SELECT 
      facturas_clientes.recargo_equivalencia INTO RecargoEquivalencia
   FROM %2$s AS facturas_clientes 
      WHERE facturas_clientes.uuid = uuid_factura_cliente;

   RETURN RecargoEquivalencia;

   END

   ENDTEXT

   cSql  := hb_strformat(  cSql,;
                           Company():getTableName( 'FacturaClienteRecargoEquivalenciaWhereUuid' ),;
                           ::getTableName() )

RETURN ( cSql )

//---------------------------------------------------------------------------//

METHOD dropFunctionRecargoEquivalenciaWhereUuid() CLASS FacturasClientesRepository  

RETURN ( "DROP FUNCTION IF EXISTS " + Company():getTableName( 'FacturaClienteRecargoEquivalenciaWhereUuid' ) + ";" )

//---------------------------------------------------------------------------//

METHOD selectRecargoEquivalenciaWhereUuid( uuidFacturaCliente ) CLASS FacturasClientesRepository

RETURN ( getSQLDatabase():Exec( "SELECT " + Company():getTableName( 'FacturaClienteRecargoEquivalenciaWhereUuid' ) + "( " + quoted( uuidFacturaCliente ) + " )" ) )

//---------------------------------------------------------------------------//

METHOD getSentenceDescuento( uuidFacturaCliente ) CLASS FacturasClientesRepository 

   local cSql

   TEXT INTO cSql

   SELECT 
      SUM( facturas_clientes_descuentos.descuento ) 
   FROM %1$s AS facturas_clientes_descuentos 
      WHERE facturas_clientes_descuentos.parent_uuid = %2$s 
         AND facturas_clientes_descuentos.deleted_at = 0 

   ENDTEXT

   cSql  := hb_strformat( cSql, SQLFacturasClientesDescuentosModel():getTableName(), if( empty( uuidFacturaCliente ), 'uuid_factura_cliente', quoted( uuidFacturaCliente ) ) )

RETURN ( alltrim( cSql ) )

//---------------------------------------------------------------------------//

METHOD createFunctionDescuentoWhereUuid() CLASS FacturasClientesRepository

   local cSql

   TEXT INTO cSql

   CREATE DEFINER=`root`@`localhost` 
   FUNCTION %1$s ( `uuid_factura_cliente` CHAR( 40 ) )
   RETURNS FLOAT( 19, 6 )
   LANGUAGE SQL
   NOT DETERMINISTIC
   CONTAINS SQL
   SQL SECURITY DEFINER
   COMMENT ''

   BEGIN

   DECLARE Descuentos FLOAT( 19, 6 );

   SELECT 
      SUM( facturas_clientes_descuentos.descuento ) INTO Descuentos
   FROM %2$s AS facturas_clientes_descuentos 
      WHERE facturas_clientes_descuentos.parent_uuid = uuid_factura_cliente 
         AND facturas_clientes_descuentos.deleted_at = 0 ;

   RETURN Descuentos;

   END

   ENDTEXT

   cSql  := hb_strformat(  cSql,;
                           Company():getTableName( 'FacturaClienteDescuentoWhereUuid' ),;
                           SQLFacturasClientesDescuentosModel():getTableName() )

RETURN ( cSql )

//---------------------------------------------------------------------------//

METHOD dropFunctionDescuentoWhereUuid() CLASS FacturasClientesRepository  

RETURN ( "DROP FUNCTION IF EXISTS " + Company():getTableName( 'FacturaClienteDescuentoWhereUuid' ) + ";" )

//---------------------------------------------------------------------------//

METHOD selectDescuentoWhereUuid( uuidFacturaCliente ) CLASS FacturasClientesRepository

RETURN ( getSQLDatabase():Exec( "SELECT " + Company():getTableName( 'FacturaClienteDescuentoWhereUuid' ) + "( " + quoted( uuidFacturaCliente ) + " )" ) )

//---------------------------------------------------------------------------//

METHOD createFunctionTotalDescuentoWhereUuid() CLASS FacturasClientesRepository

   local cSql

   TEXT INTO cSql

   CREATE DEFINER=`root`@`localhost` 
   FUNCTION %1$s ( `uuid_factura_cliente` CHAR( 40 ), `importe_bruto` DECIMAL( 19, 6 ) )
   RETURNS DECIMAL( 19, 6 )
   LANGUAGE SQL
   NOT DETERMINISTIC
   CONTAINS SQL
   SQL SECURITY DEFINER
   COMMENT ''

   BEGIN

   DECLARE totalDescuento DECIMAL( 19, 6 );

   SELECT 
      SUM( ROUND( facturas_clientes_descuentos.descuento * importe_bruto / 100, 2 ) ) INTO totalDescuento
   FROM %2$s AS facturas_clientes_descuentos 
      WHERE facturas_clientes_descuentos.parent_uuid = uuid_factura_cliente 
         AND facturas_clientes_descuentos.deleted_at = 0; 

   RETURN totalDescuento;

   END

   ENDTEXT

   cSql  := hb_strformat(  cSql,;
                           Company():getTableName( 'FacturaClienteTotalDescuentoWhereUuid' ),;
                           SQLFacturasClientesDescuentosModel():getTableName() )

RETURN ( cSql )

//---------------------------------------------------------------------------//

METHOD dropFunctionTotalDescuentoWhereUuid() CLASS FacturasClientesRepository  

RETURN ( "DROP FUNCTION IF EXISTS " + Company():getTableName( 'FacturaClienteTotalDescuentoWhereUuid' ) + ";" )

//---------------------------------------------------------------------------//

METHOD selectTotalDescuentoWhereUuid( uuidFacturaCliente, importeBruto ) CLASS FacturasClientesRepository

RETURN ( getSQLDatabase():Exec( "SELECT " + Company():getTableName( 'FacturaClienteTotalDescuentoWhereUuid' ) + "( " + quoted( uuidFacturaCliente ) + ", " + toSqlString( importeBruto ) + " )" ) )

//---------------------------------------------------------------------------//

METHOD getSentenceLineas( uuidFacturaCliente ) CLASS FacturasClientesRepository 

   local cSql

   TEXT INTO cSql

   SELECT 
      ROUND( SUM( ( @importeLinea := ( IFNULL( facturas_clientes_lineas.unidad_medicion_factor, 1 ) * facturas_clientes_lineas.articulo_unidades * ( facturas_clientes_lineas.articulo_precio + IFNULL( facturas_clientes_lineas.incremento_precio, 0 ) ) ) ) ), 2 ) AS importeBruto,
      ROUND( SUM( @descuentoLinea := IF( facturas_clientes_lineas.descuento IS NULL, 0, ( IFNULL( facturas_clientes_lineas.unidad_medicion_factor, 1 ) * facturas_clientes_lineas.articulo_unidades * facturas_clientes_lineas.articulo_precio ) ) *  IFNULL(facturas_clientes_lineas.descuento,0) / 100 ) ,2 ) AS descuentoTotalLinea,
      facturas_clientes_lineas.iva,
      facturas_clientes_lineas.recargo_equivalencia,
      facturas_clientes_lineas.descuento,
      facturas_clientes_lineas.parent_uuid
   FROM %1$s AS facturas_clientes_lineas 
      WHERE facturas_clientes_lineas.parent_uuid = %2$s
         AND facturas_clientes_lineas.deleted_at = 0 
      GROUP BY facturas_clientes_lineas.iva

   ENDTEXT

   cSql  := hb_strformat( cSql, SQLFacturasClientesLineasModel():getTableName(), if( empty( uuidFacturaCliente ), 'uuid_factura_cliente', quoted( uuidFacturaCliente ) ) )

RETURN ( alltrim( cSql ) )

//---------------------------------------------------------------------------//

METHOD getSentenceTotales( uuidFacturaCliente ) CLASS FacturasClientesRepository 

   local cSql

   TEXT INTO cSql

   SELECT
      ROUND( lineas.importeBruto, 2 ) AS importeBruto,
      ( @descuento := ( %1$s ) ) AS totalDescuentosPie,
      ( @totalDescuento := IF( @descuento IS NULL, 0, ROUND( ( ( lineas.importeBruto - lineas.descuentoTotalLinea ) * @descuento / 100 ) ) ) + lineas.descuentoTotalLinea ) AS totalDescuento,
      ( @neto := ROUND( lineas.importeBruto - @totalDescuento, 2 ) ) AS importeNeto,
      lineas.iva AS porcentajeIVA, 
      lineas.recargo_equivalencia AS recargoEquivalencia,
      ( @iva := IF( lineas.iva IS NULL, 0, ROUND( @neto * lineas.iva / 100, 2 ) ) ) AS importeIVA,  
      ( @aplicarRecargo := %3$s ) AS aplicarRecargo, 
      ( @recargo := IF( @aplicarRecargo = 0 OR lineas.recargo_equivalencia IS NULL, 0, ROUND( @neto * lineas.recargo_equivalencia / 100, 2 ) ) ) AS importeRecargo,
      ROUND( ( @neto + @iva + @recargo ), 2 ) AS importeTotal
   
   FROM 
      ( %2$s ) AS lineas
   
   GROUP BY lineas.iva

   ENDTEXT

   cSql  := hb_strformat(  cSql,;
                           ::getSentenceDescuentosAsSelect( uuidFacturaCliente ),; // ::getSentenceDescuento( uuidFacturaCliente ),;
                           ::getSentenceLineas( uuidFacturaCliente ),;
                           if( empty( uuidFacturaCliente ),;
                              ::getSentenceRecargoEquivalenciaAsParam(),;
                              ::getSentenceRecargoEquivalenciaAsSelect( uuidFacturaCliente ) ) )

RETURN ( alltrim( cSql ) )

//---------------------------------------------------------------------------//

METHOD getSentenceRecargoEquivalenciaAsSelect( uuidFacturaCliente ) CLASS FacturasClientesRepository 

   local cSql  

   TEXT INTO cSql
      ( SELECT( %1$s( %2$s ) ) )
   ENDTEXT

   cSql  := hb_strformat(  cSql,; 
                           Company():getTableName( 'FacturaClienteRecargoEquivalenciaWhereUuid' ),;
                           quoted( uuidFacturaCliente ) )

RETURN ( alltrim( cSql ) )

//---------------------------------------------------------------------------//

METHOD getSentenceDescuentosAsSelect( uuidFacturaCliente ) CLASS FacturasClientesRepository 

   local cSql

   TEXT INTO cSql
      ( SELECT( %1$s( %2$s ) ) )
   ENDTEXT

   cSql  := hb_strformat(  cSql,; 
                           Company():getTableName( 'FacturaClienteDescuentoWhereUuid' ),;
                           quoted( uuidFacturaCliente ) )

RETURN ( alltrim( cSql ) )

//---------------------------------------------------------------------------//

METHOD getSentenceRecargoEquivalenciaAsParam() CLASS FacturasClientesRepository 

   local cSql

   TEXT INTO cSql
      IF( recargo_equivalencia_factura_cliente = 0 OR lineas.recargo_equivalencia IS NULL, 0, ROUND( @neto * lineas.recargo_equivalencia / 100, 2 ) ) 
   ENDTEXT

RETURN ( alltrim( cSql ) )

//---------------------------------------------------------------------------//
