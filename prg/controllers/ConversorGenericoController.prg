#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS ConversorGenericoController FROM SQLBrowseController

   DATA oDestinoController

   DATA uuidDocumentoOrigen

   DATA uuidDocumentoDestino

   DATA idDocumentoDestino

   DATA oController

   DATA oModel

   METHOD New() CONSTRUCTOR

   METHOD End()

   METHOD getDestinoController()       INLINE ( ::oController:oDestinoController )

   METHOD getOrigenController()        INLINE ( ::oController:oOrigenController )

   METHOD getSelected()                INLINE ( ::oController:aSelected )

   METHOD Convert()                    VIRTUAL

   METHOD Edit( nId )

   METHOD convertDocument()            VIRTUAL

   //Contrucciones tarias------------------------------------------------------

   METHOD getRepository()              INLINE ( if( empty( ::oRepository ), ::oRepository := ConversorDocumentosRepository():New( self ), ), ::oRepository ) 

   METHOD getModel()                   INLINE ( if( empty( ::oModel ), ::oModel := SQLConversorDocumentosModel():New( self ), ), ::oModel ) 

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS ConversorGenericoController 

   ::oController                       := oController

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS ConversorGenericoController

   if !empty( ::oModel )
      ::oModel:End()
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD Edit( nId ) CLASS ConversorGenericoController

   if empty( nId )
      nId   := ::getIdFromRowSet()
   end if

RETURN ( ::getDestinoController():Edit( nId ) )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLConversorDocumentosModel FROM SQLCompanyModel

   DATA cTableName                     INIT "documentos_conversion"

   METHOD getColumns()

   METHOD insertRelationDocument( uuidOrigin, cTableOrigin, uuidDestination, cTableDestination )

   METHOD deleteWhereDestinoUuid( Uuid )

   METHOD countDocumentoWhereUuidOigenAndTableDestino( uuidOrigen, TableDestino )

   METHOD getDestinoController()       INLINE ( ::oController:oDestinoController )

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLConversorDocumentosModel

   hset( ::hColumns, "id",                         {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"              ,;                          
                                                      "default"   => {|| 0 } }                                    )

   hset( ::hColumns, "uuid",                       {  "create"    => "VARCHAR( 40 ) NOT NULL UNIQUE"              ,;                                  
                                                      "default"   => {|| win_uuidcreatestring() } }               )

   hset( ::hColumns, "documento_origen_tabla",     {  "create"    => "VARCHAR( 200 )"                              ,;
                                                      "default"   => {|| space( 200 ) } }                          )

   hset( ::hColumns, "documento_origen_uuid",      {  "create"    => "VARCHAR( 40 )"                              ,;
                                                      "default"   => {|| space( 40 ) } }                          )

   hset( ::hColumns, "documento_destino_tabla",    {  "create"    => "VARCHAR( 200 )"                              ,;
                                                      "default"   => {|| space( 200 ) } }                          )

   hset( ::hColumns, "documento_destino_uuid",     {  "create"    => "VARCHAR( 40 )"                              ,;
                                                      "default"   => {|| space( 40 ) } }                          )

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

METHOD insertRelationDocument( uuidOrigin, cTableOrigin, uuidDestination, cTableDestination ) CLASS SQLConversorDocumentosModel

   local cSql

   TEXT INTO cSql

      INSERT  INTO %1$s
         ( uuid, documento_origen_tabla, documento_origen_uuid, documento_destino_tabla, documento_destino_uuid ) 
      VALUES
         ( UUID(), %2$s, %3$s,%4$s , %5$s )
      
   ENDTEXT

   cSql  := hb_strformat( cSql, ::getTableName(), quoted( cTableOrigin ), quoted( uuidOrigin ), quoted( cTableDestination ), quoted( uuidDestination ) )
                                 
RETURN ( getSQLDatabase():Exec ( cSql ) )

//---------------------------------------------------------------------------//

METHOD deleteWhereDestinoUuid( Uuid ) CLASS SQLConversorDocumentosModel

   local cSql

   TEXT INTO cSql

      DELETE FROM %1$s
         WHERE documento_destino_uuid= %2$s

   ENDTEXT

   cSql  := hb_strformat( cSql, ::getTableName(), quoted( Uuid ) )
   
RETURN ( getSQLDatabase():Exec( cSql ) )

//---------------------------------------------------------------------------//

METHOD countDocumentoWhereUuidOigenAndTableDestino( uuidOrigen, TableDestino ) CLASS SQLConversorDocumentosModel
 
   local cSql

   TEXT INTO cSql

      SELECT COUNT( uuid )
         FROM %1$s
         WHERE documento_origen_uuid = %2$s AND documento_destino_tabla = %3$s

   ENDTEXT

   cSql  := hb_strformat( cSql, ::getTableName(), quoted( uuidOrigen ), quoted( TableDestino ) )
  
RETURN ( getSQLDatabase():getValue( cSql, 0 ) )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

 CLASS ConversorDocumentosRepository FROM SQLBaseRepository

   DATA cTableName                     INIT "documentos_conversion"

   DATA cPackage                       INIT "ConversorAlbaranesVentas"

   METHOD getPackage( cContext )       INLINE ( SQLAlbaranesVentasModel():getPackage( cContext ) )

   METHOD getTableName()               INLINE ( SQLConversorDocumentosModel():getTableName() ) 

   //Funciones para documentos de ventas--------------------------------------

   METHOD createIsConvertedToPedidosVentas()
      METHOD dropIsConvertedToPedidosVentas()
      METHOD isConvertedToPedidosVentas( uuidDocumento )

   METHOD createIsConvertedToAlbaranesVentas()
      METHOD dropIsConvertedToAlbaranesVentas()
      METHOD isConvertedToAlbaranesVentas( uuidDocumento )

   METHOD createIsConvertedToFacturasVentas()
      METHOD dropIsConvertedToFacturasVentas()
      METHOD isConvertedToFacturasVentas( uuidDocumento ) 

   METHOD createIsConvertedToVentasRectificativas()
      METHOD dropIsConvertedToVentasRectificativas()
      METHOD isConvertedToVentasRectificativas( uuidDocumento )

   METHOD createIsConvertedToVentasSimplificadas()
      METHOD dropIsConvertedToVentasSimplificadas()
      METHOD isConvertedToVentasSimplificadas( uuidDocumento )


   //Funciones para documentos de compras---------------------------------------

   METHOD createIsConvertedToPedidosCompras()
      METHOD dropIsConvertedToPedidosCompras()
      METHOD isConvertedToPedidosCompras( uuidDocumento )

   METHOD createIsConvertedToAlbaranesCompras()
      METHOD dropIsConvertedToAlbaranesCompras()
      METHOD isConvertedToAlbaranesCompras( uuidDocumento )

   METHOD createIsConvertedToFacturasCompras()
      METHOD dropIsConvertedToFacturasCompras()
      METHOD isConvertedToFacturasCompras( uuidDocumento )

       METHOD createIsConvertedToComprasRectificativas()
      METHOD dropIsConvertedToComprasRectificativas()
      METHOD isConvertedToComprasRectificativas( uuidDocumento )

   METHOD getSQLFunctions()            INLINE ( {  ::dropIsConvertedToPedidosVentas(),;
                                                   ::createIsConvertedToPedidosVentas(),;
                                                   ::dropIsConvertedToAlbaranesVentas(),;
                                                   ::createIsConvertedToAlbaranesVentas(),;
                                                   ::dropIsConvertedToFacturasVentas(),;
                                                   ::createIsConvertedToFacturasVentas(),;
                                                   ::dropIsConvertedToVentasRectificativas(),;
                                                   ::createIsConvertedToVentasRectificativas(),;
                                                   ::dropIsConvertedToVentasSimplificadas(),;
                                                   ::createIsConvertedToVentasSimplificadas(),;
                                                   ::dropIsConvertedToPedidosCompras(),;
                                                   ::createIsConvertedToPedidosCompras(),;
                                                   ::dropIsConvertedToAlbaranesCompras(),;
                                                   ::createIsConvertedToAlbaranesCompras(),;
                                                   ::dropIsConvertedToFacturasCompras(),;
                                                   ::createIsConvertedToFacturasCompras(),;
                                                   ::dropIsConvertedToComprasRectificativas(),;
                                                   ::createIsConvertedToComprasRectificativas() } )

END CLASS 

//---------------------------------------------------------------------------//

METHOD createIsConvertedToPedidosVentas() CLASS ConversorDocumentosRepository

   local cSql

   TEXT INTO cSql

   CREATE DEFINER=`root`@`localhost` 
   FUNCTION %5$s ( `uuid_documento` CHAR( 40 ) )
   RETURNS INT( 1 )
   LANGUAGE SQL
   NOT DETERMINISTIC
   CONTAINS SQL
   SQL SECURITY DEFINER
   COMMENT ''

   BEGIN

      DECLARE converted INT( 1 );

      SELECT
         COUNT(*) INTO converted
      FROM 
         %1$s AS %2$s

      INNER JOIN %3$s AS %4$s
         ON %1$s.documento_origen_uuid = %4s.uuid AND %4$s.canceled_at = 0 

      WHERE %2$s.documento_origen_uuid = uuid_documento AND %2$s.documento_destino_tabla = '%4$s';
      
      RETURN converted; 

   END

   ENDTEXT

   cSql  := hb_strformat( cSql,;
                          ::getTableName(),;
                          ::cTableName,;
                          SQLPedidosVentasModel():getTableName(),;
                          SQLPedidosVentasModel():cTableName,;
                          Company():getTableName( 'isConvertedToPedidosVentas' ) )

RETURN ( alltrim( cSql ) )

//---------------------------------------------------------------------------//

METHOD dropIsConvertedToPedidosVentas() CLASS ConversorDocumentosRepository  

RETURN ( "DROP FUNCTION IF EXISTS " + Company():getTableName( 'isConvertedToPedidosVentas' ) + " ;" )
 
//---------------------------------------------------------------------------//

METHOD isConvertedToPedidosVentas( uuidDocumento ) CLASS ConversorDocumentosRepository

RETURN ( getSQLDatabase():Query( "SELECT " + Company():getTableName( 'isConvertedToPedidosVentas' ) + "( " + notEscapedQuoted( uuidDocumento ) + " )" ) )

//---------------------------------------------------------------------------//

METHOD createIsConvertedToAlbaranesVentas() CLASS ConversorDocumentosRepository

   local cSql

   TEXT INTO cSql

   CREATE DEFINER=`root`@`localhost` 
   FUNCTION %5$s ( `uuid_documento` CHAR( 40 ) )
   RETURNS INT( 1 )
   LANGUAGE SQL
   NOT DETERMINISTIC
   CONTAINS SQL
   SQL SECURITY DEFINER
   COMMENT ''

   BEGIN

      DECLARE converted INT( 1 );

      SELECT
         COUNT(*) INTO converted
      FROM 
         %1$s AS %2$s

      INNER JOIN %3$s AS %4$s
         ON %1$s.documento_origen_uuid = %4s.uuid AND %4$s.canceled_at = 0 

      WHERE %2$s.documento_origen_uuid = uuid_documento AND %2$s.documento_destino_tabla = '%4$s';
      
      RETURN converted; 

   END

   ENDTEXT

   cSql  := hb_strformat( cSql,;
                          ::getTableName(),;
                          ::cTableName,;
                          SQLAlbaranesVentasModel():getTableName(),;
                          SQLAlbaranesVentasModel():cTableName,;
                          Company():getTableName( 'isConvertedToAlbaranesVentas' ) )

RETURN ( alltrim( cSql ) )

//---------------------------------------------------------------------------//

METHOD dropIsConvertedToAlbaranesVentas() CLASS ConversorDocumentosRepository  

RETURN ( "DROP FUNCTION IF EXISTS " + Company():getTableName( 'isConvertedToAlbaranesVentas' ) + " ;" )
 
//---------------------------------------------------------------------------//

METHOD isConvertedToAlbaranesVentas( uuidDocumento ) CLASS ConversorDocumentosRepository

RETURN ( getSQLDatabase():Query( "SELECT " + Company():getTableName( 'isConvertedToAlbaranesVentas' ) + "( " + notEscapedQuoted( uuidDocumento ) + " )" ) )

//---------------------------------------------------------------------------//

METHOD createIsConvertedToFacturasVentas() CLASS ConversorDocumentosRepository

   local cSql

   TEXT INTO cSql

   CREATE DEFINER=`root`@`localhost` 
   FUNCTION %5$s ( `uuid_documento` CHAR( 40 ) )
   RETURNS INT( 1 )
   LANGUAGE SQL
   NOT DETERMINISTIC
   CONTAINS SQL
   SQL SECURITY DEFINER
   COMMENT ''

   BEGIN

      DECLARE converted INT( 1 );

      SELECT
         COUNT(*) INTO converted
      FROM 
         %1$s AS %2$s

      INNER JOIN %3$s AS %4$s
         ON %1$s.documento_origen_uuid = %4s.uuid AND %4$s.canceled_at = 0 

      WHERE %2$s.documento_origen_uuid = uuid_documento AND %2$s.documento_destino_tabla = '%4$s';
      
      RETURN converted; 

   END

   ENDTEXT

   cSql  := hb_strformat( cSql,;
                          ::getTableName(),;
                          ::cTableName,;
                          SQLFacturasVentasModel():getTableName(),;
                          SQLFacturasVentasModel():cTableName,;
                          Company():getTableName( 'isConvertedToFacturasVentas' ) )

RETURN ( alltrim( cSql ) )

//---------------------------------------------------------------------------//

METHOD dropIsConvertedToFacturasVentas() CLASS ConversorDocumentosRepository  

RETURN ( "DROP FUNCTION IF EXISTS " + Company():getTableName( 'isConvertedToFacturasVentas' ) + " ;" )
 
//---------------------------------------------------------------------------//

METHOD isConvertedToFacturasVentas( uuidDocumento ) CLASS ConversorDocumentosRepository

RETURN ( getSQLDatabase():Query( "SELECT " + Company():getTableName( 'isConvertedToFacturasVentas' ) + "( " + notEscapedQuoted( uuidDocumento ) + " )" ) )

//---------------------------------------------------------------------------//

METHOD createIsConvertedToVentasRectificativas() CLASS ConversorDocumentosRepository

   local cSql

   TEXT INTO cSql

   CREATE DEFINER=`root`@`localhost` 
   FUNCTION %5$s ( `uuid_documento` CHAR( 40 ) )
   RETURNS INT( 1 )
   LANGUAGE SQL
   NOT DETERMINISTIC
   CONTAINS SQL
   SQL SECURITY DEFINER
   COMMENT ''

   BEGIN

      DECLARE converted INT( 1 );

      SELECT
         COUNT(*) INTO converted
      FROM 
         %1$s AS %2$s

      INNER JOIN %3$s AS %4$s
         ON %1$s.documento_origen_uuid = %4s.uuid AND %4$s.canceled_at = 0 

      WHERE %2$s.documento_origen_uuid = uuid_documento AND %2$s.documento_destino_tabla = '%4$s';
      
      RETURN converted; 

   END

   ENDTEXT

   cSql  := hb_strformat( cSql,;
                          ::getTableName(),;
                          ::cTableName,;
                          SQLFacturasVentasRectificativasModel():getTableName(),;
                          SQLFacturasVentasRectificativasModel():cTableName,;
                          Company():getTableName( 'isConvertedToVentasRectificativas' ) )

RETURN ( alltrim( cSql ) )

//---------------------------------------------------------------------------//

METHOD dropIsConvertedToVentasRectificativas() CLASS ConversorDocumentosRepository  

RETURN ( "DROP FUNCTION IF EXISTS " + Company():getTableName( 'isConvertedToVentasRectificativas' ) + " ;" )
 
//---------------------------------------------------------------------------//

METHOD isConvertedToVentasRectificativas( uuidDocumento ) CLASS ConversorDocumentosRepository

RETURN ( getSQLDatabase():Query( "SELECT " + Company():getTableName( 'isConvertedToVentasRectificativas' ) + "( " + notEscapedQuoted( uuidDocumento ) + " )" ) )

//---------------------------------------------------------------------------//

METHOD createIsConvertedToVentasSimplificadas() CLASS ConversorDocumentosRepository

   local cSql

   TEXT INTO cSql

   CREATE DEFINER=`root`@`localhost` 
   FUNCTION %5$s ( `uuid_documento` CHAR( 40 ) )
   RETURNS INT( 1 )
   LANGUAGE SQL
   NOT DETERMINISTIC
   CONTAINS SQL
   SQL SECURITY DEFINER
   COMMENT ''

   BEGIN

      DECLARE converted INT( 1 );

      SELECT
         COUNT(*) INTO converted
      FROM 
         %1$s AS %2$s

      INNER JOIN %3$s AS %4$s
         ON %1$s.documento_origen_uuid = %4s.uuid AND %4$s.canceled_at = 0 

      WHERE %2$s.documento_origen_uuid = uuid_documento AND %2$s.documento_destino_tabla = '%4$s';
      
      RETURN converted; 

   END

   ENDTEXT

   cSql  := hb_strformat( cSql,;
                          ::getTableName(),;
                          ::cTableName,;
                          SQLFacturasventasSimplificadasModel():getTableName(),;
                          SQLFacturasventasSimplificadasModel():cTableName,;
                          Company():getTableName( 'isConvertedToVentasSimplificadas' ) )

RETURN ( alltrim( cSql ) )

//---------------------------------------------------------------------------//

METHOD dropIsConvertedToVentasSimplificadas() CLASS ConversorDocumentosRepository  

RETURN ( "DROP FUNCTION IF EXISTS " + Company():getTableName( 'isConvertedToVentasSimplificadas' ) + " ;" )
 
//---------------------------------------------------------------------------//

METHOD isConvertedToVentasSimplificadas( uuidDocumento ) CLASS ConversorDocumentosRepository

RETURN ( getSQLDatabase():Query( "SELECT " + Company():getTableName( 'isConvertedToVentasSimplificadas' ) + "( " + notEscapedQuoted( uuidDocumento ) + " )" ) )

//---------------------------------------------------------------------------//

METHOD createIsConvertedToPedidosCompras() CLASS ConversorDocumentosRepository

   local cSql

   TEXT INTO cSql

   CREATE DEFINER=`root`@`localhost` 
   FUNCTION %5$s ( `uuid_documento` CHAR( 40 ) )
   RETURNS INT( 1 )
   LANGUAGE SQL
   NOT DETERMINISTIC
   CONTAINS SQL
   SQL SECURITY DEFINER
   COMMENT ''

   BEGIN

      DECLARE converted INT( 1 );

      SELECT
         COUNT(*) INTO converted
      FROM 
         %1$s AS %2$s

      INNER JOIN %3$s AS %4$s
         ON %1$s.documento_origen_uuid = %4s.uuid AND %4$s.canceled_at = 0 

      WHERE %2$s.documento_origen_uuid = uuid_documento AND %2$s.documento_destino_tabla = '%4$s';
      
      RETURN converted; 

   END

   ENDTEXT

   cSql  := hb_strformat( cSql,;
                          ::getTableName(),;
                          ::cTableName,;
                          SQLPedidosComprasModel():getTableName(),;
                          SQLPedidosComprasModel():cTableName,;
                          Company():getTableName( 'isConvertedToPedidosCompras' ) )

RETURN ( alltrim( cSql ) )

//---------------------------------------------------------------------------//

METHOD dropIsConvertedToPedidosCompras() CLASS ConversorDocumentosRepository  

RETURN ( "DROP FUNCTION IF EXISTS " + Company():getTableName( 'isConvertedToPedidosCompras' ) + " ;" )
 
//---------------------------------------------------------------------------//

METHOD isConvertedToPedidosCompras( uuidDocumento ) CLASS ConversorDocumentosRepository

RETURN ( getSQLDatabase():Query( "SELECT " + Company():getTableName( 'isConvertedToPedidosCompras' ) + "( " + notEscapedQuoted( uuidDocumento ) + " )" ) )

//---------------------------------------------------------------------------//


METHOD createIsConvertedToAlbaranesCompras() CLASS ConversorDocumentosRepository

   local cSql

   TEXT INTO cSql

   CREATE DEFINER=`root`@`localhost` 
   FUNCTION %5$s ( `uuid_documento` CHAR( 40 ) )
   RETURNS INT( 1 )
   LANGUAGE SQL
   NOT DETERMINISTIC
   CONTAINS SQL
   SQL SECURITY DEFINER
   COMMENT ''

   BEGIN

      DECLARE converted INT( 1 );

      SELECT
         COUNT(*) INTO converted
      FROM 
         %1$s AS %2$s

      INNER JOIN %3$s AS %4$s
         ON %1$s.documento_origen_uuid = %4s.uuid AND %4$s.canceled_at = 0 

      WHERE %2$s.documento_origen_uuid = uuid_documento AND %2$s.documento_destino_tabla = '%4$s';
      
      RETURN converted; 

   END

   ENDTEXT

   cSql  := hb_strformat( cSql,;
                          ::getTableName(),;
                          ::cTableName,;
                          SQLAlbaranesComprasModel():getTableName(),;
                          SQLAlbaranesComprasModel():cTableName,;
                          Company():getTableName( 'isConvertedToAlbaranesCompras' ) )

RETURN ( alltrim( cSql ) )

//---------------------------------------------------------------------------//

METHOD dropIsConvertedToAlbaranesCompras() CLASS ConversorDocumentosRepository  

RETURN ( "DROP FUNCTION IF EXISTS " + Company():getTableName( 'isConvertedToAlbaranesCompras' ) + " ;" )
 
//---------------------------------------------------------------------------//

METHOD isConvertedToAlbaranesCompras( uuidDocumento ) CLASS ConversorDocumentosRepository

RETURN ( getSQLDatabase():Query( "SELECT " + Company():getTableName( 'isConvertedToAlbaranesCompras' ) + "( " + notEscapedQuoted( uuidDocumento ) + " )" ) )

//---------------------------------------------------------------------------//


METHOD createIsConvertedToFacturasCompras() CLASS ConversorDocumentosRepository

   local cSql

   TEXT INTO cSql

   CREATE DEFINER=`root`@`localhost` 
   FUNCTION %5$s ( `uuid_documento` CHAR( 40 ) )
   RETURNS INT( 1 )
   LANGUAGE SQL
   NOT DETERMINISTIC
   CONTAINS SQL
   SQL SECURITY DEFINER
   COMMENT ''

   BEGIN

      DECLARE converted INT( 1 );

      SELECT
         COUNT(*) INTO converted
      FROM 
         %1$s AS %2$s

      INNER JOIN %3$s AS %4$s
         ON %1$s.documento_origen_uuid = %4s.uuid AND %4$s.canceled_at = 0 

      WHERE %2$s.documento_origen_uuid = uuid_documento AND %2$s.documento_destino_tabla = '%4$s';
      
      RETURN converted; 

   END

   ENDTEXT

   cSql  := hb_strformat( cSql,;
                          ::getTableName(),;
                          ::cTableName,;
                          SQLFacturasComprasModel():getTableName(),;
                          SQLFacturasComprasModel():cTableName,;
                          Company():getTableName( 'isConvertedToFacturasCompras' ) )

RETURN ( alltrim( cSql ) )

//---------------------------------------------------------------------------//

METHOD dropIsConvertedToFacturasCompras() CLASS ConversorDocumentosRepository  

RETURN ( "DROP FUNCTION IF EXISTS " + Company():getTableName( 'isConvertedToFacturasCompras' ) + " ;" )
 
//---------------------------------------------------------------------------//

METHOD isConvertedToFacturasCompras( uuidDocumento ) CLASS ConversorDocumentosRepository

RETURN ( getSQLDatabase():Query( "SELECT " + Company():getTableName( 'isConvertedToFacturasCompras' ) + "( " + notEscapedQuoted( uuidDocumento ) + " )" ) )

//---------------------------------------------------------------------------//


METHOD createIsConvertedToComprasRectificativas() CLASS ConversorDocumentosRepository

   local cSql

   TEXT INTO cSql

   CREATE DEFINER=`root`@`localhost` 
   FUNCTION %5$s ( `uuid_documento` CHAR( 40 ) )
   RETURNS INT( 1 )
   LANGUAGE SQL
   NOT DETERMINISTIC
   CONTAINS SQL
   SQL SECURITY DEFINER
   COMMENT ''

   BEGIN

      DECLARE converted INT( 1 );

      SELECT
         COUNT(*) INTO converted
      FROM 
         %1$s AS %2$s

      INNER JOIN %3$s AS %4$s
         ON %1$s.documento_origen_uuid = %4s.uuid AND %4$s.canceled_at = 0 

      WHERE %2$s.documento_origen_uuid = uuid_documento AND %2$s.documento_destino_tabla = '%4$s';
      
      RETURN converted; 

   END

   ENDTEXT

   cSql  := hb_strformat( cSql,;
                          ::getTableName(),;
                          ::cTableName,;
                          SQLFacturasComprasRectificativasModel():getTableName(),;
                          SQLFacturasComprasRectificativasModel():cTableName,;
                          Company():getTableName( 'isConvertedToComprasRectificativas' ) )

RETURN ( alltrim( cSql ) )

//---------------------------------------------------------------------------//

METHOD dropIsConvertedToComprasRectificativas() CLASS ConversorDocumentosRepository  

RETURN ( "DROP FUNCTION IF EXISTS " + Company():getTableName( 'isConvertedToComprasRectificativas' ) + " ;" )
 
//---------------------------------------------------------------------------//

METHOD isConvertedToComprasRectificativas( uuidDocumento ) CLASS ConversorDocumentosRepository

RETURN ( getSQLDatabase():Query( "SELECT " + Company():getTableName( 'isConvertedToComprasRectificativas' ) + "( " + notEscapedQuoted( uuidDocumento ) + " )" ) )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

#ifdef __TEST__

CLASS TestConversorDocumentosController FROM TestCase

   DATA aSelected                      INIT {}

   DATA oController

   DATA aCategories                    INIT { "all", "conversor_documento" }

   DATA oAlbaranesComprasController

   METHOD getAlbaranesComprasController();
                                       INLINE ( if( empty( ::oAlbaranesComprasController ), ::oAlbaranesComprasController := AlbaranesComprasController():New( self ), ), ::oAlbaranesComprasController )

   METHOD beforeClass() 

   METHOD afterClass()

   METHOD Before() 

   METHOD create_albaran()

   METHOD close_resumen_view()

   METHOD test_create_distinto_tercero()

   METHOD test_create_distinta_ruta()

   METHOD test_create_distinto_metodo_pago() 

   METHOD test_create_distinta_tarifa()

   METHOD test_create_distinto_recargo()

   METHOD test_create_distinta_serie()

   METHOD test_create_con_a_descuento()

   METHOD test_create_con_b_descuento()

   METHOD test_create_iguales_y_distinto()

   METHOD test_create_iguales()

END CLASS

//---------------------------------------------------------------------------//

METHOD beforeClass() CLASS TestConversorDocumentosController

   ::oController  := ConversorDocumentosController():New( ::getAlbaranesComprasController() )  

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD afterClass() CLASS TestConversorDocumentosController

   ::oController:End()

   if !empty( ::oAlbaranesComprasController )
      ::oAlbaranesComprasController:End()
   end if

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD Before() CLASS TestConversorDocumentosController

   SQLTercerosModel():truncateTable()

   SQLDireccionesModel():truncateTable()

   SQLAlmacenesModel():truncateTable()
      SQLUbicacionesModel():truncateTable()

   SQLMetodoPagoModel():truncateTable()

   SQLArticulosModel():truncateTable()
   
   SQLAlbaranesComprasModel():truncateTable()
      SQLAlbaranesComprasLineasModel():truncateTable()
      SQLAlbaranesComprasDescuentosModel():truncateTable()

   SQLFacturasComprasModel():truncateTable()
      SQLFacturasComprasLineasModel():truncateTable()
      SQLFacturasComprasDescuentosModel():truncateTable()

   SQLConversorDocumentosModel():truncateTable()
   SQLRecibosModel():truncateTable()

   SQLArticulosTarifasModel():truncateTable()

   SQLAgentesModel():truncateTable()

   SQLTiposIvaModel():truncateTable()
   SQLUbicacionesModel():truncateTable()
   SQLArticulosTarifasModel():truncateTable()
   SQLRutasModel():truncateTable()

   SQLConversorDocumentosModel():truncateTable()

   SQLMetodoPagoModel():test_create_con_plazos_con_hash() 
   SQLMetodoPagoModel():test_create_con_plazos_con_hash( {  "codigo"          => "1",;
                                                            "numero_plazos"   => 5  } ) 

   SQLTiposIvaModel():test_create_iva_al_21()

   SQLAlmacenesModel():test_create_almacen_principal()

   SQLUbicacionesModel():test_create_trhee_with_parent( SQLAlmacenesModel():test_get_uuid_almacen_principal() )

   SQLRutasModel():test_create_ruta_principal()
   SQLRutasModel():test_create_ruta_alternativa()

   SQLArticulosModel():test_create_precio_con_descuentos()

   SQLArticulosTarifasModel():test_create_tarifa_base()
   SQLArticulosTarifasModel():test_create_tarifa_mayorista()

   SQLAgentesModel():test_create_agente_principal()

   SQLTercerosModel():test_create_proveedor_con_plazos( 0 )
   SQLTercerosModel():test_create_proveedor_con_plazos( 1 )

   ::aSelected                      := {}

   ::oController:hProcesedAlbaran   := {}

   ::oController:lDescuento         := .f.

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD create_albaran( hAlbaran )

   local hLinea         := {}

   SQLAlbaranesComprasModel():create_albaran_compras( hAlbaran )

   hLinea               := { "parent_uuid"   => SQLAlbaranesComprasModel():test_get_uuid_albaran_compras( hget( hAlbaran,"serie" ), hget( hAlbaran, "numero" ) ) }

   SQLAlbaranesComprasLineasModel():create_linea_albaran_compras( hLinea )
  
   aadd( ::aSelected, SQLAlbaranesComprasModel():test_get_uuid_albaran_compras( hget( hAlbaran, "serie" ), hget( hAlbaran, "numero" ) ) )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD close_resumen_view()

   ::oController:getResumenView():setEvent( 'painted',;
         {| self | ;
            testWaitSeconds( 1 ),;
            self:getControl( IDCANCEL ):Click() } )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_create_distinto_tercero() CLASS TestConversorDocumentosController

   ::create_albaran( {  "serie"  => "A",;
                        "numero" =>  3 } )

   ::create_albaran( {  "tercero_codigo"  => "1" ,;
                        "numero"          =>  4,;
                        "serie"           => "A"  } )
   
   ::close_resumen_view()
   
   ::oController:runConvertAlbaran( ::aSelected )

   ::Assert():equals( 2, SQLFacturasComprasModel():countFacturas(), "Genera dos facturas con distintos terceros" )
   ::Assert():equals( 6, SQLRecibosModel():countRecibos(), "Genera 6 recibos a traves de 2 albaranes con distintos terceros" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_create_distinta_ruta() CLASS TestConversorDocumentosController

   ::create_albaran( {  "serie"        => "A",;
                        "numero"       =>  3 } )

   ::create_albaran( {  "ruta_codigo"  => "1" ,;
                        "numero"       =>  4  ,;
                        "serie"        => "A" } )
   
   ::close_resumen_view()
   
   ::oController:runConvertAlbaran( ::aSelected )

   ::Assert():equals( 2, SQLFacturasComprasModel():countFacturas(), "genera dos facturas con distintas rutas" )
   ::Assert():equals( 6, SQLRecibosModel():countRecibos(), "Genera 6 recibos a traves de 2 albaranes con distintas rutas" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_create_distinto_metodo_pago() CLASS TestConversorDocumentosController

   ::create_albaran( {  "serie"                 => "A",;
                        "numero"                =>  3 } )

   ::create_albaran( {  "metodo_pago_codigo"    => "1" ,;
                        "numero"                =>  4  ,;
                        "serie"                 => "A" } )
   ::close_resumen_view()
   
   ::oController:runConvertAlbaran( ::aSelected )

   ::Assert():equals( 2, SQLFacturasComprasModel():countFacturas(), "genera facturas con distintos metodos de pago" )
   ::Assert():equals( 8, SQLRecibosModel():countRecibos(), "Genera 8 recibos a traves de 2 albaranes con distintos metodos de pago" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_create_distinta_tarifa() CLASS TestConversorDocumentosController

   ::create_albaran( {  "serie"           => "A",;
                        "numero"          =>  3 } )

   ::create_albaran( {  "tarifa_codigo"   => "1" ,;
                        "numero"          =>  4  ,;
                        "serie"           => "A" } )
   ::close_resumen_view()
   
   ::oController:runConvertAlbaran( ::aSelected )

   ::Assert():equals( 2, SQLFacturasComprasModel():countFacturas(), "creacion de facturas con dos tarifas diferentes" )
   ::Assert():equals( 6, SQLRecibosModel():countRecibos(), "Genera 6 recibos a traves de 2 albaranes con dos tarifas diferentes" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_create_distinto_recargo() CLASS TestConversorDocumentosController

   ::create_albaran( {  "serie"                    => "A",;
                        "numero"                   =>  3 } )

   ::create_albaran( {  "recargo_equivalencia"     =>  1  ,;
                        "numero"                   =>  4  ,;
                        "serie"                    => "A" } )

   ::close_resumen_view()
   
   ::oController:runConvertAlbaran( ::aSelected )

   ::Assert():equals( 2, SQLFacturasComprasModel():countFacturas(), "genera facturas con distintos recargos de equivalencia" )
   ::Assert():equals( 6, SQLRecibosModel():countRecibos(), "Genera 6 recibos a traves de 2 albaranes con distintos recargos de equivalencia" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_create_distinta_serie() CLASS TestConversorDocumentosController

   ::create_albaran( {  "serie"     => "A",;
                        "numero"    =>  3 } )

   ::create_albaran( {   "serie"    => "B",;
                         "numero"   =>  5 } )

   ::close_resumen_view()
  
   ::oController:runConvertAlbaran( ::aSelected )

   ::Assert():equals( 2, SQLFacturasComprasModel():countFacturas(), "genera factras con distintas series" )
   ::Assert():equals( 6, SQLRecibosModel():countRecibos(), "Genera 6 recibos a traves de 2 albaranes con distintas series" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_create_con_a_descuento() CLASS TestConversorDocumentosController

   ::create_albaran( {  "serie"        => "A",;
                        "numero"       =>  3 } )

   SQLAlbaranesComprasDescuentosModel():test_create_descuento( { "parent_uuid" => SQLAlbaranesComprasModel():test_get_uuid_albaran_compras( "A", 3 ) } )

   ::create_albaran( {  "numero"       =>  4 ,;
                        "serie"        => "A" } )

   ::close_resumen_view()
  
   ::oController:runConvertAlbaran( ::aSelected )

   ::Assert():equals( 2, SQLFacturasComprasModel():countFacturas(), "genera 2 facturas con descuento en el primero" )
   ::Assert():equals( 6, SQLRecibosModel():countRecibos(), "Genera 6 recibos a traves de 2 albaranes con descuento en el primero" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_create_con_b_descuento() CLASS TestConversorDocumentosController

   ::create_albaran( {  "serie"        => "A",;
                        "numero"       =>  3 } )


   ::create_albaran( {  "numero"       =>  4 ,;
                        "serie"        => "A" } )

   SQLAlbaranesComprasDescuentosModel():test_create_descuento( { "parent_uuid" => SQLAlbaranesComprasModel():test_get_uuid_albaran_compras( "A", 4 ) } )

   ::close_resumen_view()
  
   ::oController:runConvertAlbaran( ::aSelected )

   ::Assert():equals( 2, SQLFacturasComprasModel():countFacturas(), "genera 2 facturas con descuentos en el segundo" )
   ::Assert():equals( 6, SQLRecibosModel():countRecibos(), "Genera 6 recibos a traves de 2 albaranes con descuento en el segundo" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_create_iguales_y_distinto() CLASS TestConversorDocumentosController

   ::create_albaran( {  "serie"           => "A",;
                        "numero"          =>  3 } )

   ::create_albaran( {  "tercero_codigo"  => "1" ,;
                        "numero"          =>  4  ,;
                        "serie"           => "A" } )

   ::create_albaran( {  "serie"           => "A",;
                        "numero"          =>  5 } )

   ::close_resumen_view()
   
   ::oController:runConvertAlbaran( ::aSelected )

   ::Assert():equals( 2, SQLFacturasComprasModel():countFacturas(), "genera 2 facturas a traves de 3 albaranes" )
   ::Assert():equals( 6, SQLRecibosModel():countRecibos(), "Genera 6 recibos a traves de 3 albaranes" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_create_iguales() CLASS TestConversorDocumentosController

   ::create_albaran( {  "serie"           => "A",;
                        "numero"          =>  3 } )

   ::create_albaran( {  "serie"           => "A",;
                        "numero"          =>  4 } )

   ::close_resumen_view()
   
   ::oController:runConvertAlbaran( ::aSelected )

   ::Assert():equals( 1, SQLFacturasComprasModel():countFacturas(), "genera 1 factura a traves de 2 albaranes iguales" )
   ::Assert():equals( 3, SQLRecibosModel():countRecibos(), "Genera 3 recibos a traves de 2 albaranes iguales" )

RETURN ( nil )

//---------------------------------------------------------------------------//

#endif

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

