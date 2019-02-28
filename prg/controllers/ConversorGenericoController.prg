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

   METHOD countDocumentoWhereUuidOigen( uuidOrigen )

   METHOD getDestinoController()       INLINE ( ::oController:oDestinoController )

   METHOD countDocumentos()

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLConversorDocumentosModel

   hset( ::hColumns, "id",                         {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"              ,;                          
                                                      "default"   => {|| 0 } }                                    )

   hset( ::hColumns, "uuid",                       {  "create"    => "VARCHAR ( 40 ) NOT NULL UNIQUE"              ,;                                  
                                                      "default"   => {|| win_uuidcreatestring() } }               )

   hset( ::hColumns, "documento_origen_tabla",     {  "create"    => "VARCHAR ( 200 )"                              ,;
                                                      "default"   => {|| space( 200 ) } }                          )

   hset( ::hColumns, "documento_origen_uuid",      {  "create"    => "VARCHAR ( 40 )"                              ,;
                                                      "default"   => {|| space( 40 ) } }                          )

   hset( ::hColumns, "documento_destino_tabla",    {  "create"    => "VARCHAR ( 200 )"                              ,;
                                                      "default"   => {|| space( 200 ) } }                          )

   hset( ::hColumns, "documento_destino_uuid",     {  "create"    => "VARCHAR ( 40 )"                              ,;
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

 METHOD countDocumentoWhereUuidOigen( uuidOrigen )

 local cSql

   TEXT INTO cSql

      SELECT COUNT( uuid )
         FROM %1$s
         WHERE documento_origen_uuid = %2$s

   ENDTEXT

   cSql  := hb_strformat( cSql, ::getTableName(), quoted( uuidOrigen ) )
  
RETURN ( getSQLDatabase():getValue( cSql, 0 ) )

//---------------------------------------------------------------------------//

METHOD countDocumentos() CLASS SQLConversorDocumentosModel

local cSql

   TEXT INTO cSql

      SELECT COUNT( * )
         FROM %1$s

   ENDTEXT

   cSql  := hb_strformat( cSql, ::getTableName() )
  
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


