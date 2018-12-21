#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS FacturasClientesRepository FROM SQLBaseRepository

   METHOD getTableName()               INLINE ( SQLFacturasClientesModel():getTableName() ) 

   METHOD getSQLFunctions()            INLINE ( {  ::dropFunctionTotalSummaryWhereUuid(),;
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

   METHOD getSentenceImporteBrutoLineas()

   METHOD getSentenceUnidadesLineas() 
   
   METHOD getSentenceLineas() 

   METHOD getHashSentenceLineas( uuidFacturaCliente )

   METHOD getSentenceTotales()

   METHOD getSentenceRecargoEquivalenciaAsSelect()
   METHOD getSentenceRecargoEquivalenciaAsParam()
   METHOD getSentenceDescuentosAsSelect( uuidFactura ) 

   METHOD getSentenceTotalDocument( uuidFactura )
   METHOD getTotalDocument( uuidFactura )

   METHOD getTotalesDocument( uuidFactura )         
   METHOD getSentenceTotalesDocument( uuidFactura )

   METHOD getTotalesDocumentGroupByIVA( uuidFactura )
   METHOD getSentenceTotalesDocumentGroupByIVA( uuidFactura )

   //Envio de emails-----------------------------------------------------------

   METHOD getClientMailWhereFacturaUuid( uuidFactura ) 

END CLASS

//---------------------------------------------------------------------------//

METHOD getSentenceTotalesDocumentGroupByIVA( uuidFacturaCliente ) CLASS FacturasClientesRepository

RETURN ( ::getSentenceTotalesDocument( uuidFacturaCliente ) + " GROUP BY totales.porcentaje_iva" )

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
         SUM( totales.importe_total ) INTO TotalSummary
      FROM 
         ( %2$s ) AS totales;
      
      RETURN TotalSummary;

   END

   ENDTEXT

   cSql  := hb_strformat(  cSql,;
                           Company():getTableName( 'FacturaClienteTotalSummaryWhereUuid' ),;
                           ::getSentenceTotales() )

RETURN ( alltrim( cSql ) )

//---------------------------------------------------------------------------//

METHOD dropFunctionTotalSummaryWhereUuid() CLASS FacturasClientesRepository  

RETURN ( "DROP FUNCTION IF EXISTS " + Company():getTableName( 'FacturaClienteTotalSummaryWhereUuid' ) + ";" )

//---------------------------------------------------------------------------//

METHOD selectTotalSummaryWhereUuid( uuidFacturaCliente, aplicarRecargo ) CLASS FacturasClientesRepository

RETURN ( getSQLDatabase():Exec( "SELECT " + Company():getTableName( 'FacturaClienteTotalSummaryWhereUuid' ) + "( " + quotedUuid( uuidFacturaCliente ) + ", " + toSqlString( aplicarRecargo ) + " )" ) )

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

RETURN ( alltrim( cSql ) )

//---------------------------------------------------------------------------//

METHOD dropFunctionRecargoEquivalenciaWhereUuid() CLASS FacturasClientesRepository  

RETURN ( "DROP FUNCTION IF EXISTS " + Company():getTableName( 'FacturaClienteRecargoEquivalenciaWhereUuid' ) + ";" )

//---------------------------------------------------------------------------//

METHOD selectRecargoEquivalenciaWhereUuid( uuidFacturaCliente ) CLASS FacturasClientesRepository

RETURN ( getSQLDatabase():Exec( "SELECT " + Company():getTableName( 'FacturaClienteRecargoEquivalenciaWhereUuid' ) + "( " + quotedUuid( uuidFacturaCliente ) + " )" ) )

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

   cSql  := hb_strformat( cSql, SQLFacturasClientesDescuentosModel():getTableName(), if( empty( uuidFacturaCliente ), 'uuid_factura_cliente', quotedUuid( uuidFacturaCliente ) ) )

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

RETURN ( alltrim( cSql ) )

//---------------------------------------------------------------------------//

METHOD dropFunctionDescuentoWhereUuid() CLASS FacturasClientesRepository  

RETURN ( "DROP FUNCTION IF EXISTS " + Company():getTableName( 'FacturaClienteDescuentoWhereUuid' ) + ";" )

//---------------------------------------------------------------------------//

METHOD selectDescuentoWhereUuid( uuidFacturaCliente ) CLASS FacturasClientesRepository

RETURN ( getSQLDatabase():Exec( "SELECT " + Company():getTableName( 'FacturaClienteDescuentoWhereUuid' ) + "( " + quotedUuid( uuidFacturaCliente ) + " )" ) )

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

RETURN ( alltrim( cSql ) )

//---------------------------------------------------------------------------//

METHOD dropFunctionTotalDescuentoWhereUuid() CLASS FacturasClientesRepository  

RETURN ( "DROP FUNCTION IF EXISTS " + Company():getTableName( 'FacturaClienteTotalDescuentoWhereUuid' ) + ";" )

//---------------------------------------------------------------------------//

METHOD selectTotalDescuentoWhereUuid( uuidFacturaCliente, importeBruto ) CLASS FacturasClientesRepository

RETURN ( getSQLDatabase():Exec( "SELECT " + Company():getTableName( 'FacturaClienteTotalDescuentoWhereUuid' ) + "( " + quotedUuid( uuidFacturaCliente ) + ", " + toSqlString( importeBruto ) + " )" ) )

//---------------------------------------------------------------------------//

METHOD getSentenceLineas( uuidFacturaCliente ) CLASS FacturasClientesRepository 

   local cSql

   TEXT INTO cSql

   SELECT 
      ( ROUND( SUM( %2$s ), 2 ) ) AS importe_bruto,
      ( ROUND( SUM( IF( facturas_clientes_lineas.descuento IS NULL, 0, %2$s * facturas_clientes_lineas.descuento / 100 ) ), 2 ) ) AS importe_descuento,
      ( ROUND( SUM( %2$s ), 2 ) - ROUND( SUM( IF( facturas_clientes_lineas.descuento IS NULL, 0, %2$s * facturas_clientes_lineas.descuento / 100 ) ), 2 ) ) AS importe_neto,
      ( %3$s) as total_unidades,
      facturas_clientes_lineas.articulo_nombre,
      facturas_clientes_lineas.iva,
      facturas_clientes_lineas.recargo_equivalencia,
      facturas_clientes_lineas.descuento,
      facturas_clientes_lineas.parent_uuid
   FROM %1$s AS facturas_clientes_lineas 
      WHERE facturas_clientes_lineas.parent_uuid = %4$s
         AND facturas_clientes_lineas.deleted_at = 0 
      GROUP BY facturas_clientes_lineas.iva

   ENDTEXT

   cSql  := hb_strformat(  cSql,;
                           SQLFacturasClientesLineasModel():getTableName(),;
                           ::getSentenceImporteBrutoLineas(),;
                           ::getSentenceUnidadesLineas(),;
                           if( empty( uuidFacturaCliente ), 'uuid_factura_cliente', quotedUuid( uuidFacturaCliente ) ) )

RETURN ( alltrim( cSql ) )

//---------------------------------------------------------------------------//

METHOD getHashSentenceLineas( uuidFacturaCliente ) CLASS FacturasClientesRepository

RETURN ( getSQLDataBase():selectTrimedFetchHash( ::getSentenceLineas( uuidFacturaCliente ) ) )

//---------------------------------------------------------------------------//

METHOD getSentenceImporteBrutoLineas() CLASS FacturasClientesRepository

   local cSql

   TEXT INTO cSql
      %1$s * ( facturas_clientes_lineas.articulo_precio + IFNULL( facturas_clientes_lineas.incremento_precio, 0 ) ) 
   ENDTEXT

   cSql  := hb_strformat(  cSql, ::getSentenceUnidadesLineas() )

RETURN ( alltrim( cSql ) )

//---------------------------------------------------------------------------//

METHOD getSentenceUnidadesLineas() CLASS FacturasClientesRepository

   local cSql

   TEXT INTO cSql
      IFNULL( facturas_clientes_lineas.unidad_medicion_factor, 1 ) * facturas_clientes_lineas.articulo_unidades
   ENDTEXT

RETURN ( alltrim( cSql ) )

//---------------------------------------------------------------------------//

METHOD getSentenceTotales( uuidFacturaCliente ) CLASS FacturasClientesRepository 

   local cSql

   TEXT INTO cSql

   SELECT
      ROUND( lineas.importe_bruto, 2 ) AS importe_bruto,
      ROUND( lineas.importe_bruto, 2 ) - ROUND( lineas.importe_descuento, 2 ) AS importe_bruto_lineas,
      ( @descuento := ( %1$s ) ) AS total_descuentos_pie,
      ( @totalDescuento := IF( @descuento IS NULL, 0, ( lineas.importe_neto * @descuento / 100 ) ) ) AS total_descuento,
      ( @neto := ROUND( lineas.importe_neto - @totalDescuento, 2 ) ) AS importe_neto,
      lineas.iva AS porcentaje_iva, 
      lineas.recargo_equivalencia AS recargo_equivalencia,
      ( @iva := IF( lineas.iva IS NULL, 0, ROUND( @neto * lineas.iva / 100, 2 ) ) ) AS importe_iva,  
      ( @aplicarRecargo := %3$s ) AS aplicar_recargo, 
      ( @recargo := IF( @aplicarRecargo = 0 OR lineas.recargo_equivalencia IS NULL, 0, ROUND( @neto * lineas.recargo_equivalencia / 100, 2 ) ) ) AS importe_recargo,
      ROUND( ( @neto + @iva + @recargo ), 2 ) AS importe_total

   FROM 
      ( %2$s ) AS lineas
   
   GROUP BY lineas.iva

   ENDTEXT

   cSql  := hb_strformat(  cSql,;
                           ::getSentenceDescuentosAsSelect( uuidFacturaCliente ),; 
                           ::getSentenceLineas( uuidFacturaCliente ),;
                           if( empty( uuidFacturaCliente ),;
                              ::getSentenceRecargoEquivalenciaAsParam(),;
                              ::getSentenceRecargoEquivalenciaAsSelect( uuidFacturaCliente ) ) )

RETURN ( alltrim( cSql ) )

//---------------------------------------------------------------------------//

METHOD getSentenceTotalesDocument( uuidFacturaCliente ) CLASS FacturasClientesRepository

   local cSql

   TEXT INTO cSql

   SELECT
      SUM( totales.importe_bruto ) AS total_bruto,
      SUM( totales.importe_bruto_lineas ) AS total_bruto_lineas,
      SUM( totales.total_descuento ) AS total_descuento,
      SUM( totales.importe_neto ) AS total_neto,
      SUM( totales.recargo_equivalencia ) AS recargo_equivalencia,
      SUM( totales.porcentaje_iva ) AS porcentaje_iva,
      SUM( totales.importe_iva ) AS total_iva,
      SUM( totales.importe_recargo ) AS total_recargo,
      SUM( totales.importe_total ) AS total_documento
   FROM ( %1$s ) AS totales

   ENDTEXT

   cSql  := hb_strformat(  cSql,;
                           ::getSentenceTotales( uuidFacturaCliente ),;
                           Company():getTableName( 'FacturaClienteTotalDescuentoWhereUuid' ),;
                           quotedUuid( uuidFacturaCliente ) )

RETURN ( alltrim( cSql ) )

//---------------------------------------------------------------------------//

METHOD getSentenceTotalDocument( uuidFacturaCliente ) CLASS FacturasClientesRepository

   local cSql

   TEXT INTO cSql

   SELECT
      SUM( totales.importe_total ) AS total_documento
   FROM ( %1$s ) AS totales

   ENDTEXT

   cSql  := hb_strformat( cSql, ::getSentenceTotales( uuidFacturaCliente ) )

RETURN ( alltrim( cSql ) )

//---------------------------------------------------------------------------//

METHOD getTotalDocument( uuidFacturaCliente ) CLASS FacturasClientesRepository

   local nTotal   := ::getDatabase():getValue( ::getSentenceTotalDocument( uuidFacturaCliente ) ) 

RETURN ( if( empty( nTotal ), 0, nTotal ) )

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
         ON clientes.codigo = facturas_clientes.tercero_codigo
      
      INNER JOIN %3$s AS direcciones
         ON clientes.uuid = direcciones.parent_uuid AND direcciones.principal = 0

      WHERE facturas_clientes.uuid = %4$s

   ENDTEXT

   cSql  := hb_strformat( cSql, ::getTableName(), SQLTercerosModel():getTableName(), SQLDireccionesModel():getTableName(), quotedUuid( uuidFacturaCliente ) ) 

RETURN ( getSQLDatabase():getValue( cSql, "" ) ) 

//---------------------------------------------------------------------------//

METHOD getSentenceRecargoEquivalenciaAsSelect( uuidFacturaCliente ) CLASS FacturasClientesRepository 

   local cSql  

   TEXT INTO cSql
      ( SELECT( %1$s( %2$s ) ) )
   ENDTEXT

   cSql  := hb_strformat(  cSql,; 
                           Company():getTableName( 'FacturaClienteRecargoEquivalenciaWhereUuid' ),;
                           quotedUuid( uuidFacturaCliente ) )

RETURN ( alltrim( cSql ) )

//---------------------------------------------------------------------------//

METHOD getSentenceDescuentosAsSelect( uuidFacturaCliente ) CLASS FacturasClientesRepository 

   local cSql

   TEXT INTO cSql
      ( SELECT( %1$s( %2$s ) ) )
   ENDTEXT

   cSql  := hb_strformat(  cSql,; 
                           Company():getTableName( 'FacturaClienteDescuentoWhereUuid' ),;
                           quotedUuid( uuidFacturaCliente ) )

RETURN ( alltrim( cSql ) )

//---------------------------------------------------------------------------//

METHOD getSentenceRecargoEquivalenciaAsParam() CLASS FacturasClientesRepository 

   local cSql

   TEXT INTO cSql
      IF( recargo_equivalencia_factura_cliente = 0 OR lineas.recargo_equivalencia IS NULL, 0, ROUND( @neto * lineas.recargo_equivalencia / 100, 2 ) ) 
   ENDTEXT

RETURN ( alltrim( cSql ) )

//---------------------------------------------------------------------------//
