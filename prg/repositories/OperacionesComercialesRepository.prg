#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS OperacionesComercialesRepository FROM SQLBaseRepository

   METHOD getTableName()               VIRTUAL

   METHOD getPackage( cContext )       VIRTUAL

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
      METHOD selectTotalSummaryWhereUuid( uuidFacturaProveedor, aplicarRecargo )

   METHOD createFunctionRecargoEquivalenciaWhereUuid() 
      METHOD dropFunctionRecargoEquivalenciaWhereUuid()   
      METHOD selectRecargoEquivalenciaWhereUuid( uuidFacturaProveedor ) 

   METHOD createFunctionDescuentoWhereUuid() 
      METHOD dropFunctionDescuentoWhereUuid()   
      METHOD selectDescuentoWhereUuid( uuidFacturaProveedor ) 

   METHOD createFunctionTotalDescuentoWhereUuid()
      METHOD dropFunctionTotalDescuentoWhereUuid()
      METHOD selectTotalDescuentoWhereUuid( uuidFacturaProveedor, importeBruto )
   
   METHOD getSentenceDescuento() 

   METHOD getSentenceImporteBrutoLineas()

   METHOD getSentenceUnidadesLineas() 
   
   METHOD getSentenceLineas() 

   METHOD getHashSentenceLineas( uuidFacturaProveedor )

   METHOD getSentenceTotales()

   METHOD getSentenceRecargoEquivalenciaAsSelect()
   METHOD getSentenceRecargoAsParam()
   METHOD getSentenceDescuentosAsSelect( uuidFactura ) 

   METHOD getTotalDocument( uuidFacturaProveedor )
   METHOD getSentenceTotalDocument( uuidFactura )

   METHOD getTotalesDocument( uuidFactura )         
   METHOD getSentenceTotalesDocument( uuidFactura )

   METHOD getTotalesDocumentGroupByIVA( uuidFactura )
   METHOD getSentenceTotalesDocumentGroupByIVA( uuidFactura )

   //Envio de emails-----------------------------------------------------------

   METHOD getClientMailWhereFacturaUuid( uuidFactura ) 

END CLASS

//---------------------------------------------------------------------------//

METHOD getSentenceTotalesDocumentGroupByIVA( uuidFacturaProveedor ) CLASS OperacionesComercialesRepository

RETURN ( ::getSentenceTotalesDocument( uuidFacturaProveedor ) + " GROUP BY totales.porcentaje_iva" )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

METHOD createFunctionTotalSummaryWhereUuid() CLASS OperacionesComercialesRepository

   local cSql

   TEXT INTO cSql

   CREATE DEFINER=`root`@`localhost` 
   FUNCTION %1$s ( `uuid_factura_proveedor` CHAR( 40 ), `recargo_equivalencia_factura_proveedor` TINYINT( 1 ) )
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
                           Company():getTableName( ::getPackage( 'TotalSummaryWhereUuid' ) ),;
                           ::getSentenceTotales() )

RETURN ( alltrim( cSql ) )

//---------------------------------------------------------------------------//

METHOD dropFunctionTotalSummaryWhereUuid() CLASS OperacionesComercialesRepository  

RETURN ( "DROP FUNCTION IF EXISTS " + Company():getTableName( ::getPackage( 'TotalSummaryWhereUuid' ) ) + ";" )

//---------------------------------------------------------------------------//

METHOD selectTotalSummaryWhereUuid( uuidFacturaProveedor, aplicarRecargo ) CLASS OperacionesComercialesRepository

RETURN ( getSQLDatabase():Exec( "SELECT " + Company():getTableName( ::getPackage( 'TotalSummaryWhereUuid' ) ) + "( " + quotedUuid( uuidFacturaProveedor ) + ", " + toSqlString( aplicarRecargo ) + " )" ) )

//---------------------------------------------------------------------------//

METHOD createFunctionRecargoEquivalenciaWhereUuid() CLASS OperacionesComercialesRepository

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
                           Company():getTableName( ::getPackage( 'RecargoEquivalenciaWhereUuid' ) ),;
                           ::getTableName() )

RETURN ( alltrim( cSql ) )

//---------------------------------------------------------------------------//

METHOD dropFunctionRecargoEquivalenciaWhereUuid() CLASS OperacionesComercialesRepository  

RETURN ( "DROP FUNCTION IF EXISTS " + Company():getTableName( ::getPackage( 'RecargoEquivalenciaWhereUuid' ) ) + ";" )

//---------------------------------------------------------------------------//

METHOD selectRecargoEquivalenciaWhereUuid( uuidFacturaProveedor ) CLASS OperacionesComercialesRepository

RETURN ( getSQLDatabase():Exec( "SELECT " + Company():getTableName( ::getPackage( 'RecargoEquivalenciaWhereUuid' ) ) + "( " + quotedUuid( uuidFacturaProveedor ) + " )" ) )

//---------------------------------------------------------------------------//

METHOD getSentenceDescuento( uuidFacturaProveedor ) CLASS OperacionesComercialesRepository 

   local cSql

   TEXT INTO cSql

   SELECT 
      SUM( facturas_proveedores_descuentos.descuento ) 
   FROM %1$s AS facturas_proveedores_descuentos 
      WHERE facturas_proveedores_descuentos.parent_uuid = %2$s 
         AND facturas_proveedores_descuentos.deleted_at = 0 

   ENDTEXT

   cSql  := hb_strformat( cSql, SQLFacturasComprasDescuentosModel():getTableName(), if( empty( uuidFacturaProveedor ), 'uuid_factura_proveedor', quotedUuid( uuidFacturaProveedor ) ) )

RETURN ( alltrim( cSql ) )

//---------------------------------------------------------------------------//

METHOD createFunctionDescuentoWhereUuid() CLASS OperacionesComercialesRepository

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
      SUM( facturas_proveedores_descuentos.descuento ) INTO Descuentos
   FROM %2$s AS facturas_proveedores_descuentos 
      WHERE facturas_proveedores_descuentos.parent_uuid = uuid_factura_proveedor 
         AND facturas_proveedores_descuentos.deleted_at = 0 ;

   RETURN Descuentos;

   END

   ENDTEXT

   cSql  := hb_strformat(  cSql,;
                           Company():getTableName( ::getPackage( 'DescuentoWhereUuid' ) ),;
                           SQLFacturasComprasDescuentosModel():getTableName() )

RETURN ( alltrim( cSql ) )

//---------------------------------------------------------------------------//

METHOD dropFunctionDescuentoWhereUuid() CLASS OperacionesComercialesRepository  

RETURN ( "DROP FUNCTION IF EXISTS " + Company():getTableName( ::getPackage( 'DescuentoWhereUuid' ) ) + ";" )

//---------------------------------------------------------------------------//

METHOD selectDescuentoWhereUuid( uuidFacturaProveedor ) CLASS OperacionesComercialesRepository

RETURN ( getSQLDatabase():Exec( "SELECT " + Company():getTableName( ::getPackage( 'DescuentoWhereUuid' ) ) + "( " + quotedUuid( uuidFacturaProveedor ) + " )" ) )

//---------------------------------------------------------------------------//

METHOD createFunctionTotalDescuentoWhereUuid() CLASS OperacionesComercialesRepository

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
      SUM( ROUND( facturas_proveedores_descuentos.descuento * importe_bruto / 100, 2 ) ) INTO totalDescuento
   FROM %2$s AS facturas_proveedores_descuentos 
      WHERE facturas_proveedores_descuentos.parent_uuid = uuid_factura_proveedor 
         AND facturas_proveedores_descuentos.deleted_at = 0; 

   RETURN totalDescuento;

   END

   ENDTEXT

   cSql  := hb_strformat(  cSql,;
                           Company():getTableName( ::getPackage( 'TotalDescuentoWhereUuid' ) ),;
                           SQLFacturasComprasDescuentosModel():getTableName() )

RETURN ( alltrim( cSql ) )

//---------------------------------------------------------------------------//

METHOD dropFunctionTotalDescuentoWhereUuid() CLASS OperacionesComercialesRepository  

RETURN ( "DROP FUNCTION IF EXISTS " + Company():getTableName( ::getPackage( 'TotalDescuentoWhereUuid' ) ) + ";" )

//---------------------------------------------------------------------------//

METHOD selectTotalDescuentoWhereUuid( uuidFacturaProveedor, importeBruto ) CLASS OperacionesComercialesRepository

RETURN ( getSQLDatabase():Exec( "SELECT " + Company():getTableName( ::getPackage( 'TotalDescuentoWhereUuid' ) ) + "( " + quotedUuid( uuidFacturaProveedor ) + ", " + toSqlString( importeBruto ) + " )" ) )

//---------------------------------------------------------------------------//

METHOD getSentenceLineas( uuidFacturaProveedor ) CLASS OperacionesComercialesRepository 

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
                           SQLFacturasComprasLineasModel():getTableName(),;
                           ::getSentenceImporteBrutoLineas(),;
                           ::getSentenceUnidadesLineas(),;
                           if( empty( uuidFacturaProveedor ), 'uuid_factura_proveedor', quotedUuid( uuidFacturaProveedor ) ) )

RETURN ( alltrim( cSql ) )

//---------------------------------------------------------------------------//

METHOD getHashSentenceLineas( uuidFacturaProveedor ) CLASS OperacionesComercialesRepository

RETURN ( getSQLDataBase():selectTrimedFetchHash( ::getSentenceLineas( uuidFacturaProveedor ) ) )

//---------------------------------------------------------------------------//

METHOD getSentenceImporteBrutoLineas() CLASS OperacionesComercialesRepository

   local cSql

   TEXT INTO cSql
      %1$s * ( facturas_proveedores_lineas.articulo_precio + IFNULL( facturas_proveedores_lineas.incremento_precio, 0 ) ) 
   ENDTEXT

   cSql  := hb_strformat(  cSql, ::getSentenceUnidadesLineas() )

RETURN ( alltrim( cSql ) )

//---------------------------------------------------------------------------//

METHOD getSentenceUnidadesLineas() CLASS OperacionesComercialesRepository

   local cSql

   TEXT INTO cSql
      IFNULL( facturas_proveedores_lineas.unidad_medicion_factor, 1 ) * facturas_proveedores_lineas.articulo_unidades
   ENDTEXT

RETURN ( alltrim( cSql ) )

//---------------------------------------------------------------------------//

METHOD getSentenceTotales( uuidFacturaProveedor ) CLASS OperacionesComercialesRepository 

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
                           ::getSentenceDescuentosAsSelect( uuidFacturaProveedor ),; 
                           ::getSentenceLineas( uuidFacturaProveedor ),;
                           if( empty( uuidFacturaProveedor ),;
                              ::getSentenceRecargoAsParam(),;
                              ::getSentenceRecargoEquivalenciaAsSelect( uuidFacturaProveedor ) ) )

RETURN ( alltrim( cSql ) )

//---------------------------------------------------------------------------//

METHOD getSentenceTotalesDocument( uuidFacturaProveedor ) CLASS OperacionesComercialesRepository

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
                           ::getSentenceTotales( uuidFacturaProveedor ),;
                           Company():getTableName( ::getPackage( 'TotalDescuentoWhereUuid' ) ),;
                           quotedUuid( uuidFacturaProveedor ) )

RETURN ( alltrim( cSql ) )

//---------------------------------------------------------------------------//

METHOD getSentenceTotalDocument( uuidFacturaProveedor ) CLASS OperacionesComercialesRepository

   local cSql

   TEXT INTO cSql

   SELECT
      SUM( totales.importe_total ) AS total_documento
   FROM ( %1$s ) AS totales

   ENDTEXT

   cSql  := hb_strformat( cSql, ::getSentenceTotales( uuidFacturaProveedor ) )

RETURN ( alltrim( cSql ) )

//---------------------------------------------------------------------------//

METHOD getTotalesDocument( uuidFacturaProveedor ) CLASS OperacionesComercialesRepository

   local aTotal   := ::getDatabase():selectFetchHash( ::getSentenceTotalesDocument( uuidFacturaProveedor ) ) 

RETURN ( if( hb_isarray( aTotal ), atail( aTotal ), nil ) )

//---------------------------------------------------------------------------//

METHOD getTotalDocument( uuidFacturaProveedor ) CLASS OperacionesComercialesRepository

   local nTotal   := ::getDatabase():getValue( ::getSentenceTotalDocument( uuidFacturaProveedor ) ) 

RETURN ( if( empty( nTotal ), 0, nTotal ) )

//---------------------------------------------------------------------------//

METHOD getTotalesDocumentGroupByIVA( uuidFacturaProveedor ) CLASS OperacionesComercialesRepository

   local aTotal   := ::getDatabase():selectFetchHash( ::getSentenceTotalesDocumentGroupByIVA( uuidFacturaProveedor ) ) 

RETURN ( if( hb_isarray( aTotal ), aTotal, nil ) )

//---------------------------------------------------------------------------//

METHOD getClientMailWhereFacturaUuid( uuidFacturaProveedor ) CLASS OperacionesComercialesRepository

   local cSQL

   TEXT INTO cSql

      SELECT direcciones.email
         FROM %1$s AS facturas_proveedores

      INNER JOIN %2$s AS proveedores
         ON proveedores.codigo = facturas_proveedores.tercero_codigo
      
      INNER JOIN %3$s AS direcciones
         ON proveedores.uuid = direcciones.parent_uuid AND direcciones.principal = 0

      WHERE facturas_proveedores.uuid = %4$s

   ENDTEXT

   cSql  := hb_strformat( cSql, ::getTableName(), SQLTercerosModel():getTableName(), SQLDireccionesModel():getTableName(), quotedUuid( uuidFacturaProveedor ) ) 

RETURN ( getSQLDatabase():getValue( cSql, "" ) ) 

//---------------------------------------------------------------------------//

METHOD getSentenceRecargoEquivalenciaAsSelect( uuidFacturaProveedor ) CLASS OperacionesComercialesRepository 

   local cSql  

   TEXT INTO cSql
      ( SELECT( %1$s( %2$s ) ) )
   ENDTEXT

   cSql  := hb_strformat(  cSql,; 
                           Company():getTableName( ::getPackage( 'RecargoEquivalenciaWhereUuid' ) ),;
                           quotedUuid( uuidFacturaProveedor ) )

RETURN ( alltrim( cSql ) )

//---------------------------------------------------------------------------//

METHOD getSentenceDescuentosAsSelect( uuidFacturaProveedor ) CLASS OperacionesComercialesRepository 

   local cSql

   TEXT INTO cSql
      ( SELECT( %1$s( %2$s ) ) )
   ENDTEXT

   cSql  := hb_strformat(  cSql,; 
                           Company():getTableName( ::getPackage( 'DescuentoWhereUuid' ) ),;
                           quotedUuid( uuidFacturaProveedor ) )

RETURN ( alltrim( cSql ) )

//---------------------------------------------------------------------------//

METHOD getSentenceRecargoAsParam() CLASS OperacionesComercialesRepository 

   local cSql

   TEXT INTO cSql
      IF( recargo_equivalencia_factura_proveedor = 0 OR lineas.recargo_equivalencia IS NULL, 0, ROUND( @neto * lineas.recargo_equivalencia / 100, 2 ) ) 
   ENDTEXT

RETURN ( alltrim( cSql ) )

//---------------------------------------------------------------------------//
