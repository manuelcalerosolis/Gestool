#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS OperacionesComercialesRepository FROM SQLBaseRepository

   METHOD getTableName()               VIRTUAL

   METHOD getPackage( cContext )       VIRTUAL

   METHOD getLinesTableName()          VIRTUAL

   METHOD getDiscountsTableName()      VIRTUAL

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
      METHOD selectTotalSummaryWhereUuid( uuidOperacionComercial )

   METHOD createFunctionRecargoEquivalenciaWhereUuid() 
      METHOD dropFunctionRecargoEquivalenciaWhereUuid()   
      METHOD selectRecargoEquivalenciaWhereUuid( uuidOperacionComercial ) 

   METHOD createFunctionDescuentoWhereUuid() 
      METHOD dropFunctionDescuentoWhereUuid()   
      METHOD selectDescuentoWhereUuid( uuidOperacionComercial ) 

   METHOD createFunctionTotalDescuentoWhereUuid()
      METHOD dropFunctionTotalDescuentoWhereUuid()
      METHOD selectTotalDescuentoWhereUuid( uuidOperacionComercial, importeBruto )
   
   METHOD getSentenceDescuento() 

   METHOD getSentenceImporteBrutoLineas()

   METHOD getSentenceUnidadesLineas() 
   
   METHOD getSentenceLineas() 

   METHOD getHashSentenceLineas( uuidOperacionComercial )

   METHOD getSentenceTotales()

   METHOD getSentenceRecargoEquivalenciaAsSelect()
   METHOD getSentenceDescuentosAsSelect( uuidFactura ) 

   METHOD getTotalDocument( uuidOperacionComercial )
   METHOD getSentenceTotalDocument( uuidFactura )

   METHOD getTotalesDocument( uuidFactura )         
   METHOD getSentenceTotalesDocument( uuidFactura )

   METHOD getTotalesDocumentGroupByIVA( uuidFactura )
   METHOD getSentenceTotalesDocumentGroupByIVA( uuidFactura )

   //Envio de emails-----------------------------------------------------------

   METHOD getMailWhereOperacionUuid( uuidFactura ) 

END CLASS

//---------------------------------------------------------------------------//

METHOD getSentenceTotalesDocumentGroupByIVA( uuidOperacionComercial ) CLASS OperacionesComercialesRepository

RETURN ( ::getSentenceTotalesDocument( uuidOperacionComercial ) + " GROUP BY totales.iva" )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

METHOD createFunctionTotalSummaryWhereUuid() CLASS OperacionesComercialesRepository

   local cSql

   TEXT INTO cSql

   CREATE DEFINER=`root`@`localhost` 
   FUNCTION %1$s ( `uuid_operacion_comercial` CHAR( 40 ) )
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

   cSql  := hb_strformat( cSql, Company():getTableName( ::getPackage( 'TotalSummaryWhereUuid' ) ), ::getSentenceTotales() )


RETURN ( alltrim( cSql ) )

//---------------------------------------------------------------------------//

METHOD dropFunctionTotalSummaryWhereUuid() CLASS OperacionesComercialesRepository  

RETURN ( "DROP FUNCTION IF EXISTS " + Company():getTableName( ::getPackage( 'TotalSummaryWhereUuid' ) ) + ";" )

//---------------------------------------------------------------------------//

METHOD selectTotalSummaryWhereUuid( uuidOperacionComercial ) CLASS OperacionesComercialesRepository

RETURN ( getSQLDatabase():Query( "SELECT " + Company():getTableName( ::getPackage( 'TotalSummaryWhereUuid' ) ) + "( " + notEscapedQuoted( uuidOperacionComercial ) + " )" ) )

//---------------------------------------------------------------------------//

METHOD createFunctionRecargoEquivalenciaWhereUuid() CLASS OperacionesComercialesRepository

   local cSql

   TEXT INTO cSql

   CREATE DEFINER=`root`@`localhost` 
   FUNCTION %1$s ( `uuid_operacion_comercial` CHAR( 40 ) )
   RETURNS TINYINT( 1 )
   LANGUAGE SQL
   NOT DETERMINISTIC
   CONTAINS SQL
   SQL SECURITY DEFINER
   COMMENT ''

   BEGIN

   DECLARE RecargoEquivalencia TINYINT( 1 );

   SELECT 
      operaciones_comerciales.recargo_equivalencia INTO RecargoEquivalencia

   FROM %2$s AS operaciones_comerciales 
      WHERE operaciones_comerciales.uuid = uuid_operacion_comercial;

   RETURN RecargoEquivalencia;

   END

   ENDTEXT

   cSql  := hb_strformat( cSql, Company():getTableName( ::getPackage( 'RecargoEquivalenciaWhereUuid' ) ), ::getTableName() )

RETURN ( alltrim( cSql ) )

//---------------------------------------------------------------------------//

METHOD dropFunctionRecargoEquivalenciaWhereUuid() CLASS OperacionesComercialesRepository  

RETURN ( "DROP FUNCTION IF EXISTS " + Company():getTableName( ::getPackage( 'RecargoEquivalenciaWhereUuid' ) ) + ";" )

//---------------------------------------------------------------------------//

METHOD selectRecargoEquivalenciaWhereUuid( uuidOperacionComercial ) CLASS OperacionesComercialesRepository

RETURN ( getSQLDatabase():Exec( "SELECT " + Company():getTableName( ::getPackage( 'RecargoEquivalenciaWhereUuid' ) ) + "( " + notEscapedQuoted( uuidOperacionComercial ) + " )" ) )

//---------------------------------------------------------------------------//

METHOD getSentenceDescuento( uuidOperacionComercial ) CLASS OperacionesComercialesRepository 

   local cSql

   TEXT INTO cSql

   SELECT 
      SUM( operaciones_comerciales_descuentos.descuento ) 

   FROM %1$s AS operaciones_comerciales_descuentos 
      WHERE operaciones_comerciales_descuentos.parent_uuid = %2$s 
         AND operaciones_comerciales_descuentos.deleted_at = 0 

   ENDTEXT

   cSql  := hb_strformat( cSql, ::getDiscountsTableName(), if( empty( uuidOperacionComercial ), 'uuid_operacion_comercial', notEscapedQuoted( uuidOperacionComercial ) ) )

RETURN ( alltrim( cSql ) )

//---------------------------------------------------------------------------//

METHOD createFunctionDescuentoWhereUuid() CLASS OperacionesComercialesRepository

   local cSql

   TEXT INTO cSql

   CREATE DEFINER=`root`@`localhost` 
   FUNCTION %1$s ( `uuid_operacion_comercial` CHAR( 40 ) )
   RETURNS FLOAT( 19, 6 )
   LANGUAGE SQL
   NOT DETERMINISTIC
   CONTAINS SQL
   SQL SECURITY DEFINER
   COMMENT ''

   BEGIN

   DECLARE Descuentos FLOAT( 19, 6 );

   SELECT 
      SUM( operaciones_comerciales_descuentos.descuento ) INTO Descuentos
      
   FROM %2$s AS operaciones_comerciales_descuentos 
      WHERE operaciones_comerciales_descuentos.parent_uuid = uuid_operacion_comercial 
         AND operaciones_comerciales_descuentos.deleted_at = 0 ;

   RETURN Descuentos;

   END

   ENDTEXT

   cSql  := hb_strformat( cSql, Company():getTableName( ::getPackage( 'DescuentoWhereUuid' ) ), ::getDiscountsTableName() )

RETURN ( alltrim( cSql ) )

//---------------------------------------------------------------------------//

METHOD dropFunctionDescuentoWhereUuid() CLASS OperacionesComercialesRepository  

RETURN ( "DROP FUNCTION IF EXISTS " + Company():getTableName( ::getPackage( 'DescuentoWhereUuid' ) ) + ";" )

//---------------------------------------------------------------------------//

METHOD selectDescuentoWhereUuid( uuidOperacionComercial ) CLASS OperacionesComercialesRepository

RETURN ( getSQLDatabase():Exec( "SELECT " + Company():getTableName( ::getPackage( 'DescuentoWhereUuid' ) ) + "( " + notEscapedQuoted( uuidOperacionComercial ) + " )" ) )

//---------------------------------------------------------------------------//

METHOD createFunctionTotalDescuentoWhereUuid() CLASS OperacionesComercialesRepository

   local cSql

   TEXT INTO cSql

   CREATE DEFINER=`root`@`localhost` 
   FUNCTION %1$s ( `uuid_operacion_comercial` CHAR( 40 ), `importe_bruto` DECIMAL( 19, 6 ) )
   RETURNS DECIMAL( 19, 6 )
   LANGUAGE SQL
   NOT DETERMINISTIC
   CONTAINS SQL
   SQL SECURITY DEFINER
   COMMENT ''

   BEGIN

   DECLARE totalDescuento DECIMAL( 19, 6 );

   SELECT 
      SUM( ROUND( operaciones_comerciales_descuentos.descuento * importe_bruto / 100, 2 ) ) INTO totalDescuento
   FROM %2$s AS operaciones_comerciales_descuentos 
      WHERE operaciones_comerciales_descuentos.parent_uuid = uuid_operacion_comercial 
         AND operaciones_comerciales_descuentos.deleted_at = 0; 

   RETURN totalDescuento;

   END

   ENDTEXT

   cSql  := hb_strformat( cSql, Company():getTableName( ::getPackage( 'TotalDescuentoWhereUuid' ) ), ::getDiscountsTableName() )

RETURN ( alltrim( cSql ) )

//---------------------------------------------------------------------------//

METHOD dropFunctionTotalDescuentoWhereUuid() CLASS OperacionesComercialesRepository  

RETURN ( "DROP FUNCTION IF EXISTS " + Company():getTableName( ::getPackage( 'TotalDescuentoWhereUuid' ) ) + ";" )

//---------------------------------------------------------------------------//

METHOD selectTotalDescuentoWhereUuid( uuidOperacionComercial, importeBruto ) CLASS OperacionesComercialesRepository

RETURN ( getSQLDatabase():Exec( "SELECT " + Company():getTableName( ::getPackage( 'TotalDescuentoWhereUuid' ) ) + "( " + notEscapedQuoted( uuidOperacionComercial ) + ", " + toSqlString( importeBruto ) + " )" ) )

//---------------------------------------------------------------------------//

METHOD getSentenceLineas( uuidOperacionComercial ) CLASS OperacionesComercialesRepository 

   local cSql

   TEXT INTO cSql

   SELECT 
      ( ROUND( SUM( %2$s ), 2 ) ) AS importe_bruto,
      ( ROUND( SUM( IF( operaciones_comerciales_lineas.descuento IS NULL, 0, %2$s * operaciones_comerciales_lineas.descuento / 100 ) ), 2 ) ) AS importe_descuento,
      ( ROUND( SUM( %2$s ), 2 ) - ROUND( SUM( IF( operaciones_comerciales_lineas.descuento IS NULL, 0, %2$s * operaciones_comerciales_lineas.descuento / 100 ) ), 2 ) ) AS importe_neto,
      ( %3$s) as total_unidades,
      operaciones_comerciales_lineas.articulo_nombre,
      operaciones_comerciales_lineas.iva,
      operaciones_comerciales_lineas.recargo_equivalencia,
      operaciones_comerciales_lineas.descuento,
      operaciones_comerciales_lineas.parent_uuid

   FROM %1$s AS operaciones_comerciales_lineas

      WHERE operaciones_comerciales_lineas.parent_uuid = %4$s
         AND operaciones_comerciales_lineas.deleted_at = 0 

      GROUP BY operaciones_comerciales_lineas.iva

   ENDTEXT

   cSql  := hb_strformat(  cSql,;
                           ::getLinesTableName(),;
                           ::getSentenceImporteBrutoLineas(),;
                           ::getSentenceUnidadesLineas(),;
                           if( empty( uuidOperacionComercial ),;
                              'uuid_operacion_comercial',;
                              notEscapedQuoted( uuidOperacionComercial ) ) )

RETURN ( alltrim( cSql ) )

//---------------------------------------------------------------------------//

METHOD getHashSentenceLineas( uuidOperacionComercial ) CLASS OperacionesComercialesRepository

RETURN ( getSQLDataBase():selectTrimedFetchHash( ::getSentenceLineas( uuidOperacionComercial ) ) )

//---------------------------------------------------------------------------//

METHOD getSentenceImporteBrutoLineas() CLASS OperacionesComercialesRepository

   local cSql

   TEXT INTO cSql
      %1$s * ( operaciones_comerciales_lineas.articulo_precio + IFNULL( operaciones_comerciales_lineas.incremento_precio, 0 ) ) 
   ENDTEXT

   cSql  := hb_strformat( cSql, ::getSentenceUnidadesLineas() )

RETURN ( alltrim( cSql ) )

//---------------------------------------------------------------------------//

METHOD getSentenceUnidadesLineas() CLASS OperacionesComercialesRepository

   local cSql

   TEXT INTO cSql
      IFNULL( operaciones_comerciales_lineas.unidad_medicion_factor, 1 ) * operaciones_comerciales_lineas.articulo_unidades
   ENDTEXT

RETURN ( alltrim( cSql ) )

//---------------------------------------------------------------------------//

METHOD getSentenceTotales( uuidOperacionComercial ) CLASS OperacionesComercialesRepository 

   local cSql

   TEXT INTO cSql

   SELECT
      totales.importe_bruto AS importe_bruto,
      totales.importe_base AS importe_base,
      totales.total_descuento AS total_descuento,
      totales.importe_neto AS importe_neto,
      totales.iva AS iva, 
      totales.recargo_equivalencia AS recargo_equivalencia,
      totales.importe_iva AS importe_iva,
      totales.importe_recargo AS importe_recargo,
      totales.importe_neto + totales.importe_iva + totales.importe_recargo AS importe_total

   FROM (
      SELECT 
         lineas.importe_bruto AS importe_bruto,
         ROUND( lineas.importe_bruto, 2 ) - ROUND( lineas.importe_descuento, 2 ) AS importe_base,
         lineas.total_descuento AS total_descuento,
         lineas.iva AS iva, 
         lineas.recargo_equivalencia AS recargo_equivalencia,
         ( ROUND( lineas.importe_neto - lineas.total_descuento, 2 ) ) AS importe_neto,
         ( IF( lineas.iva IS NULL, 0, ROUND( ROUND( lineas.importe_neto - lineas.total_descuento, 2 ) * lineas.iva / 100, 2 ) ) ) AS importe_iva,  
         ( IF( lineas.aplicar_recargo = 0 OR lineas.recargo_equivalencia IS NULL, 0, ROUND( ROUND( lineas.importe_neto - lineas.total_descuento, 2 ) * lineas.recargo_equivalencia / 100, 2 ) ) ) AS importe_recargo

      FROM (
         SELECT
            ROUND( operaciones_comerciales_lineas.importe_bruto, 2 ) AS importe_bruto,
            ROUND( operaciones_comerciales_lineas.importe_descuento, 2 ) AS importe_descuento,
            operaciones_comerciales_lineas.importe_neto AS importe_neto,
            operaciones_comerciales_lineas.iva AS iva, 
            operaciones_comerciales_lineas.recargo_equivalencia AS recargo_equivalencia,
            ( IF( ( %1$s ) IS NULL, 0, ( operaciones_comerciales_lineas.importe_neto * ( %1$s ) / 100 ) ) ) AS total_descuento,
            ( %3$s ) AS aplicar_recargo 

         FROM 
            ( %2$s ) AS operaciones_comerciales_lineas
         
         GROUP BY operaciones_comerciales_lineas.iva

      ) AS lineas

   ) AS totales

   ENDTEXT

   cSql  := hb_strformat(  cSql,;
                           ::getSentenceDescuentosAsSelect( uuidOperacionComercial ),; 
                           ::getSentenceLineas( uuidOperacionComercial ),;
                           ::getSentenceRecargoEquivalenciaAsSelect( uuidOperacionComercial ) )

RETURN ( alltrim( cSql ) )

//---------------------------------------------------------------------------//

METHOD getSentenceTotalesDocument( uuidOperacionComercial ) CLASS OperacionesComercialesRepository

   local cSql

   TEXT INTO cSql

   SELECT
      SUM( totales.importe_bruto ) AS total_bruto,
      SUM( totales.importe_base ) AS importe_base,
      SUM( totales.total_descuento ) AS total_descuento,
      SUM( totales.importe_neto ) AS total_neto,
      SUM( totales.recargo_equivalencia ) AS recargo_equivalencia,
      SUM( totales.iva ) AS iva,
      SUM( totales.importe_iva ) AS total_iva,
      SUM( totales.importe_recargo ) AS total_recargo,
      SUM( totales.importe_total ) AS total_documento
   FROM ( %1$s ) AS totales

   ENDTEXT

   cSql  := hb_strformat( cSql, ::getSentenceTotales( uuidOperacionComercial ) )

RETURN ( alltrim( cSql ) )

//---------------------------------------------------------------------------//

METHOD getSentenceTotalDocument( uuidOperacionComercial ) CLASS OperacionesComercialesRepository

   local cSql

   TEXT INTO cSql

   SELECT
      SUM( totales.importe_total ) AS total_documento
   FROM ( %1$s ) AS totales

   ENDTEXT

   cSql  := hb_strformat( cSql, ::getSentenceTotales( uuidOperacionComercial ) )

RETURN ( alltrim( cSql ) )

//---------------------------------------------------------------------------//

METHOD getTotalesDocument( uuidOperacionComercial ) CLASS OperacionesComercialesRepository

   local aTotal   := ::getDatabase():selectFetchHash( ::getSentenceTotalesDocument( uuidOperacionComercial ) ) 

RETURN ( if( hb_isarray( aTotal ), atail( aTotal ), nil ) )

//---------------------------------------------------------------------------//

METHOD getTotalDocument( uuidOperacionComercial ) CLASS OperacionesComercialesRepository

   local nTotal   := ::getDatabase():getValue( ::getSentenceTotalDocument( uuidOperacionComercial ) ) 

RETURN ( if( empty( nTotal ), 0, nTotal ) )

//---------------------------------------------------------------------------//

METHOD getTotalesDocumentGroupByIVA( uuidOperacionComercial ) CLASS OperacionesComercialesRepository

   local aTotal   := ::getDatabase():selectFetchHash( ::getSentenceTotalesDocumentGroupByIVA( uuidOperacionComercial ) ) 

RETURN ( if( hb_isarray( aTotal ), aTotal, nil ) )

//---------------------------------------------------------------------------//

METHOD getMailWhereOperacionUuid( uuidOperacionComercial ) CLASS OperacionesComercialesRepository

   local cSQL

   TEXT INTO cSql

      SELECT direcciones.email
         FROM %1$s AS operaciones_comerciales

      INNER JOIN %2$s AS terceros
         ON terceros.codigo = operaciones_comerciales.tercero_codigo
      
      INNER JOIN %3$s AS direcciones
         ON terceros.uuid = direcciones.parent_uuid AND direcciones.codigo = 0

      WHERE operaciones_comerciales.uuid = %4$s

   ENDTEXT

   cSql  := hb_strformat( cSql, ::getTableName(), SQLTercerosModel():getTableName(), SQLDireccionesModel():getTableName(), notEscapedQuoted( uuidOperacionComercial ) ) 

RETURN ( getSQLDatabase():getValue( cSql, "" ) ) 

//---------------------------------------------------------------------------//

METHOD getSentenceRecargoEquivalenciaAsSelect( uuidOperacionComercial ) CLASS OperacionesComercialesRepository 

   local cSql  

   TEXT INTO cSql
      ( SELECT( %1$s( %2$s ) ) )
   ENDTEXT

   cSql  := hb_strformat( cSql, Company():getTableName( ::getPackage( 'RecargoEquivalenciaWhereUuid' ) ), if( empty( uuidOperacionComercial ), 'uuid_operacion_comercial', notEscapedQuoted( uuidOperacionComercial ) ) )

RETURN ( alltrim( cSql ) )

//---------------------------------------------------------------------------//

METHOD getSentenceDescuentosAsSelect( uuidOperacionComercial ) CLASS OperacionesComercialesRepository 

   local cSql

   TEXT INTO cSql
      ( SELECT( %1$s( %2$s ) ) )
   ENDTEXT

   cSql  := hb_strformat( cSql, Company():getTableName( ::getPackage( 'DescuentoWhereUuid' ) ), if( empty( uuidOperacionComercial ), 'uuid_operacion_comercial', notEscapedQuoted( uuidOperacionComercial ) ) )

RETURN ( alltrim( cSql ) )

//---------------------------------------------------------------------------//

