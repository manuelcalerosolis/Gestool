#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS FacturasProveedoresRepository FROM SQLBaseRepository

METHOD getTableName()               INLINE ( SQLFacturasProveedoresModel():getTableName() )

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

   METHOD getTotalesDocument( uuidFactura )         
   METHOD getSentenceTotalesDocument( uuidFactura )

   METHOD getTotalesDocumentGroupByIVA( uuidFactura )
   METHOD getSentenceTotalesDocumentGroupByIVA( uuidFactura )

   //Envio de emails-----------------------------------------------------------

   METHOD getClientMailWhereFacturaUuid( uuidFactura ) 

END CLASS

//---------------------------------------------------------------------------//

METHOD getSentenceTotalesDocumentGroupByIVA( uuidFacturaCliente ) CLASS FacturasProveedoresRepository

RETURN ( ::getSentenceTotalesDocument( uuidFacturaCliente ) + " GROUP BY totales.porcentaje_iva" )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

METHOD createFunctionTotalSummaryWhereUuid() CLASS FacturasProveedoresRepository

   local cSql

   TEXT INTO cSql

   CREATE DEFINER=`root`@`localhost` 
   FUNCTION %1$s ( `uuid_factura_proveedor` CHAR( 40 ), `recargo_equivalencia_factura_cliente` TINYINT( 1 ) )
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
                           Company():getTableName( 'FacturaProveedorTotalSummaryWhereUuid' ),;
                           ::getSentenceTotales() )

RETURN ( alltrim( cSql ) )

//---------------------------------------------------------------------------//

METHOD dropFunctionTotalSummaryWhereUuid() CLASS FacturasProveedoresRepository  

RETURN ( "DROP FUNCTION IF EXISTS " + Company():getTableName( 'FacturaProveedorTotalSummaryWhereUuid' ) + ";" )

//---------------------------------------------------------------------------//

METHOD selectTotalSummaryWhereUuid( uuidFacturaCliente, aplicarRecargo ) CLASS FacturasProveedoresRepository

RETURN ( getSQLDatabase():Exec( "SELECT " + Company():getTableName( 'FacturaProveedorTotalSummaryWhereUuid' ) + "( " + quotedUuid( uuidFacturaCliente ) + ", " + toSqlString( aplicarRecargo ) + " )" ) )

//---------------------------------------------------------------------------//

METHOD createFunctionRecargoEquivalenciaWhereUuid() CLASS FacturasProveedoresRepository

   local cSql

   TEXT INTO cSql

   CREATE DEFINER=`root`@`localhost` 
   FUNCTION %1$s ( `uuid_factura_proveedor` CHAR( 40 ) )
   RETURNS TINYINT( 1 )
   LANGUAGE SQL
   NOT DETERMINISTIC
   CONTAINS SQL
   SQL SECURITY DEFINER
   COMMENT ''

   BEGIN

   DECLARE RecargoEquivalencia TINYINT( 1 );

   SELECT 
      facturas_proveedores.recargo_equivalencia INTO RecargoEquivalencia
   FROM %2$s AS facturas_proveedores 
      WHERE facturas_proveedores.uuid = uuid_factura_proveedor;

   RETURN RecargoEquivalencia;

   END

   ENDTEXT

   cSql  := hb_strformat(  cSql,;
                           Company():getTableName( 'FacturaProveedorRecargoEquivalenciaWhereUuid' ),;
                           ::getTableName() )

RETURN ( alltrim( cSql ) )

//---------------------------------------------------------------------------//

METHOD dropFunctionRecargoEquivalenciaWhereUuid() CLASS FacturasProveedoresRepository  

RETURN ( "DROP FUNCTION IF EXISTS " + Company():getTableName( 'FacturaProveedorRecargoEquivalenciaWhereUuid' ) + ";" )

//---------------------------------------------------------------------------//

METHOD selectRecargoEquivalenciaWhereUuid( uuidFacturaCliente ) CLASS FacturasProveedoresRepository

RETURN ( getSQLDatabase():Exec( "SELECT " + Company():getTableName( 'FacturaProveedorRecargoEquivalenciaWhereUuid' ) + "( " + quotedUuid( uuidFacturaCliente ) + " )" ) )

//---------------------------------------------------------------------------//

METHOD getSentenceDescuento( uuidFacturaCliente ) CLASS FacturasProveedoresRepository 

   local cSql

   TEXT INTO cSql

   SELECT 
      SUM( facturas_clientes_descuentos.descuento ) 
   FROM %1$s AS facturas_clientes_descuentos 
      WHERE facturas_clientes_descuentos.parent_uuid = %2$s 
         AND facturas_clientes_descuentos.deleted_at = 0 

   ENDTEXT

   cSql  := hb_strformat( cSql, SQLFacturasClientesDescuentosModel():getTableName(), if( empty( uuidFacturaCliente ), 'uuid_factura_proveedor', quotedUuid( uuidFacturaCliente ) ) )

RETURN ( alltrim( cSql ) )

//---------------------------------------------------------------------------//

METHOD createFunctionDescuentoWhereUuid() CLASS FacturasProveedoresRepository

   local cSql

   TEXT INTO cSql

   CREATE DEFINER=`root`@`localhost` 
   FUNCTION %1$s ( `uuid_factura_proveedor` CHAR( 40 ) )
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
      WHERE facturas_clientes_descuentos.parent_uuid = uuid_factura_proveedor 
         AND facturas_clientes_descuentos.deleted_at = 0 ;

   RETURN Descuentos;

   END

   ENDTEXT

   cSql  := hb_strformat(  cSql,;
                           Company():getTableName( 'FacturaProveedorDescuentoWhereUuid' ),;
                           SQLFacturasClientesDescuentosModel():getTableName() )

RETURN ( alltrim( cSql ) )

//---------------------------------------------------------------------------//

METHOD dropFunctionDescuentoWhereUuid() CLASS FacturasProveedoresRepository  

RETURN ( "DROP FUNCTION IF EXISTS " + Company():getTableName( 'FacturaProveedorDescuentoWhereUuid' ) + ";" )

//---------------------------------------------------------------------------//

METHOD selectDescuentoWhereUuid( uuidFacturaCliente ) CLASS FacturasProveedoresRepository

RETURN ( getSQLDatabase():Exec( "SELECT " + Company():getTableName( 'FacturaProveedorDescuentoWhereUuid' ) + "( " + quotedUuid( uuidFacturaCliente ) + " )" ) )

//---------------------------------------------------------------------------//

METHOD createFunctionTotalDescuentoWhereUuid() CLASS FacturasProveedoresRepository

   local cSql

   TEXT INTO cSql

   CREATE DEFINER=`root`@`localhost` 
   FUNCTION %1$s ( `uuid_factura_proveedor` CHAR( 40 ), `importe_bruto` DECIMAL( 19, 6 ) )
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
      WHERE facturas_clientes_descuentos.parent_uuid = uuid_factura_proveedor 
         AND facturas_clientes_descuentos.deleted_at = 0; 

   RETURN totalDescuento;

   END

   ENDTEXT

   cSql  := hb_strformat(  cSql,;
                           Company():getTableName( 'FacturaProveedorTotalDescuentoWhereUuid' ),;
                           SQLFacturasClientesDescuentosModel():getTableName() )

RETURN ( alltrim( cSql ) )

//---------------------------------------------------------------------------//

METHOD dropFunctionTotalDescuentoWhereUuid() CLASS FacturasProveedoresRepository  

RETURN ( "DROP FUNCTION IF EXISTS " + Company():getTableName( 'FacturaProveedorTotalDescuentoWhereUuid' ) + ";" )

//---------------------------------------------------------------------------//

METHOD selectTotalDescuentoWhereUuid( uuidFacturaCliente, importeBruto ) CLASS FacturasProveedoresRepository

RETURN ( getSQLDatabase():Exec( "SELECT " + Company():getTableName( 'FacturaProveedorTotalDescuentoWhereUuid' ) + "( " + quotedUuid( uuidFacturaCliente ) + ", " + toSqlString( importeBruto ) + " )" ) )

//---------------------------------------------------------------------------//

METHOD getSentenceLineas( uuidFacturaCliente ) CLASS FacturasProveedoresRepository 

   local cSql

   TEXT INTO cSql

   SELECT 
      ( ROUND( SUM( %2$s ), 2 ) ) AS importe_bruto,
      ( ROUND( SUM( IF( facturas_proveedores_lineas.descuento IS NULL, 0, %2$s * facturas_proveedores_lineas.descuento / 100 ) ), 2 ) ) AS importe_descuento,
      ( ROUND( SUM( %2$s ), 2 ) - ROUND( SUM( IF( facturas_proveedores_lineas.descuento IS NULL, 0, %2$s * facturas_proveedores_lineas.descuento / 100 ) ), 2 ) ) AS importe_neto,
      ( %3$s) as total_unidades,
      facturas_proveedores_lineas.articulo_nombre,
      facturas_proveedores_lineas.iva,
      facturas_proveedores_lineas.recargo_equivalencia,
      facturas_proveedores_lineas.descuento,
      facturas_proveedores_lineas.parent_uuid
   FROM %1$s AS facturas_proveedores_lineas 
      WHERE facturas_proveedores_lineas.parent_uuid = %4$s
         AND facturas_proveedores_lineas.deleted_at = 0 
      GROUP BY facturas_proveedores_lineas.iva

   ENDTEXT

   cSql  := hb_strformat(  cSql,;
                           SQLFacturasProveedoresLineasModel():getTableName(),;
                           ::getSentenceImporteBrutoLineas(),;
                           ::getSentenceUnidadesLineas(),;
                           if( empty( uuidFacturaCliente ), 'uuid_factura_proveedor', quotedUuid( uuidFacturaCliente ) ) )

RETURN ( alltrim( cSql ) )

//---------------------------------------------------------------------------//

METHOD getHashSentenceLineas( uuidFacturaCliente ) CLASS FacturasProveedoresRepository

RETURN ( getSQLDataBase():selectTrimedFetchHash( ::getSentenceLineas( uuidFacturaCliente ) ) )

//---------------------------------------------------------------------------//

METHOD getSentenceImporteBrutoLineas() CLASS FacturasProveedoresRepository

   local cSql

   TEXT INTO cSql
      %1$s * ( facturas_proveedores_lineas.articulo_precio + IFNULL( facturas_proveedores_lineas.incremento_precio, 0 ) ) 
   ENDTEXT

   cSql  := hb_strformat(  cSql, ::getSentenceUnidadesLineas() )

RETURN ( alltrim( cSql ) )

//---------------------------------------------------------------------------//

METHOD getSentenceUnidadesLineas() CLASS FacturasProveedoresRepository

   local cSql

   TEXT INTO cSql
      IFNULL( facturas_proveedores_lineas.unidad_medicion_factor, 1 ) * facturas_proveedores_lineas.articulo_unidades
   ENDTEXT

RETURN ( alltrim( cSql ) )

//---------------------------------------------------------------------------//

METHOD getSentenceTotales( uuidFacturaCliente ) CLASS FacturasProveedoresRepository 

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

METHOD getSentenceTotalesDocument( uuidFacturaCliente ) CLASS FacturasProveedoresRepository

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
                           Company():getTableName( 'FacturaProveedorTotalDescuentoWhereUuid' ),;
                           quotedUuid( uuidFacturaCliente ) )

RETURN ( alltrim( cSql ) )

//---------------------------------------------------------------------------//

METHOD getSentenceTotalDocument( uuidFacturaCliente ) CLASS FacturasProveedoresRepository

   local cSql

   TEXT INTO cSql

   SELECT
      SUM( totales.importe_total ) AS total_documento
   FROM ( %1$s ) AS totales

   ENDTEXT

   cSql  := hb_strformat( cSql, ::getSentenceTotales( uuidFacturaCliente ) )

RETURN ( alltrim( cSql ) )

//---------------------------------------------------------------------------//

METHOD getTotalesDocument( uuidFacturaCliente ) CLASS FacturasProveedoresRepository

   local aTotal   := ::getDatabase():selectFetchHash( ::getSentenceTotalesDocument( uuidFacturaCliente ) ) 

RETURN ( if( hb_isarray( aTotal ), atail( aTotal ), nil ) )

//---------------------------------------------------------------------------//

METHOD getTotalesDocumentGroupByIVA( uuidFacturaCliente ) CLASS FacturasProveedoresRepository

   local aTotal   := ::getDatabase():selectFetchHash( ::getSentenceTotalesDocumentGroupByIVA( uuidFacturaCliente ) ) 

RETURN ( if( hb_isarray( aTotal ), aTotal, nil ) )

//---------------------------------------------------------------------------//

METHOD getClientMailWhereFacturaUuid( uuidFacturaCliente ) CLASS FacturasProveedoresRepository

   local cSQL

   TEXT INTO cSql

      SELECT direcciones.email
         FROM %1$s AS facturas_proveedores

      INNER JOIN %2$s AS clientes
         ON clientes.codigo = facturas_proveedores.tercero_codigo
      
      INNER JOIN %3$s AS direcciones
         ON clientes.uuid = direcciones.parent_uuid AND direcciones.principal = 0

      WHERE facturas_proveedores.uuid = %4$s

   ENDTEXT

   cSql  := hb_strformat( cSql, ::getTableName(), SQLClientesModel():getTableName(), SQLDireccionesModel():getTableName(), quotedUuid( uuidFacturaCliente ) ) 

RETURN ( getSQLDatabase():getValue( cSql, "" ) ) 

//---------------------------------------------------------------------------//

METHOD getSentenceRecargoEquivalenciaAsSelect( uuidFacturaCliente ) CLASS FacturasProveedoresRepository 

   local cSql  

   TEXT INTO cSql
      ( SELECT( %1$s( %2$s ) ) )
   ENDTEXT

   cSql  := hb_strformat(  cSql,; 
                           Company():getTableName( 'FacturaProveedorRecargoEquivalenciaWhereUuid' ),;
                           quotedUuid( uuidFacturaCliente ) )

RETURN ( alltrim( cSql ) )

//---------------------------------------------------------------------------//

METHOD getSentenceDescuentosAsSelect( uuidFacturaCliente ) CLASS FacturasProveedoresRepository 

   local cSql

   TEXT INTO cSql
      ( SELECT( %1$s( %2$s ) ) )
   ENDTEXT

   cSql  := hb_strformat(  cSql,; 
                           Company():getTableName( 'FacturaProveedorDescuentoWhereUuid' ),;
                           quotedUuid( uuidFacturaCliente ) )

RETURN ( alltrim( cSql ) )

//---------------------------------------------------------------------------//

METHOD getSentenceRecargoEquivalenciaAsParam() CLASS FacturasProveedoresRepository 

   local cSql

   TEXT INTO cSql
      IF( recargo_equivalencia_factura_cliente = 0 OR lineas.recargo_equivalencia IS NULL, 0, ROUND( @neto * lineas.recargo_equivalencia / 100, 2 ) ) 
   ENDTEXT

RETURN ( alltrim( cSql ) )

//---------------------------------------------------------------------------//
