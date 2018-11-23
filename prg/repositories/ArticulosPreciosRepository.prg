#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS ArticulosPreciosRepository FROM SQLBaseRepository

   METHOD getTableName()                  INLINE ( SQLArticulosPreciosModel():getTableName() ) 

   METHOD getSQLFunctions()               INLINE ( {  ::dropFunctionUpdatePrecioBaseWhereUuid(),;
                                                      ::createFunctionUpdatePrecioBaseWhereUuid(),;
                                                      ::dropFunctionUpdatePrecioIvaIncluidoWhereUuid(),;
                                                      ::createFunctionUpdatePrecioIvaIncluidoWhereUuid(),;
                                                      ::dropFunctionUpdatePrecioWhereIdPrecio(),;
                                                      ::createFunctionUpdatePrecioWhereIdPrecio(),;
                                                      ::dropFunctionUpdatePreciosWhereUuidArticulo(),;
                                                      ::createFunctionUpdatePreciosWhereUuidArticulo() } )

   METHOD dropFunctionUpdatePrecioBaseWhereUuid()  

   METHOD createFunctionUpdatePrecioBaseWhereUuid()

   METHOD callUpdatePrecioBaseWhereUuid( uuidPrecioArticulo, precioBase )

   METHOD dropFunctionUpdatePrecioIvaIncluidoWhereUuid()

   METHOD callUpdatePrecioIvaIncluidoWhereUuid( uuidPrecioArticulo, precioIvaIncluido ) 

   METHOD createFunctionUpdatePrecioIvaIncluidoWhereUuid()   

   METHOD dropFunctionUpdatePrecioWhereIdPrecio()
   
   METHOD callUpdatePrecioWhereIdPrecio( idPrecioArticulo )
   
   METHOD createFunctionUpdatePrecioWhereIdPrecio()

   METHOD dropFunctionUpdatePreciosWhereUuidArticulo()

   METHOD callUpdatePreciosWhereUuidArticulo( idPrecio )

   METHOD createFunctionUpdatePreciosWhereUuidArticulo()   

END CLASS

//---------------------------------------------------------------------------//

METHOD dropFunctionUpdatePrecioBaseWhereUuid() CLASS ArticulosPreciosRepository  

RETURN ( "DROP PROCEDURE IF EXISTS " + Company():getTableName( 'UpdatePrecioBaseWhereUuid' ) + ";" )

//---------------------------------------------------------------------------//

METHOD callUpdatePrecioBaseWhereUuid( uuidPrecioArticulo, precioBase ) CLASS ArticulosPreciosRepository

RETURN ( getSQLDatabase():Exec( "CALL " + Company():getTableName( 'UpdatePrecioBaseWhereUuid' ) + "( " + quoted( uuidPrecioArticulo ) + ", " + hb_ntos( precioBase ) + " )" ) )

//---------------------------------------------------------------------------//

METHOD createFunctionUpdatePrecioBaseWhereUuid() CLASS ArticulosPreciosRepository

   local cSQL

   TEXT INTO cSql

   CREATE DEFINER=`root`@`localhost` PROCEDURE %1$s ( IN `uuid_precio_articulo` CHAR(40), IN `precio_base` FLOAT(16,6) ) 
      LANGUAGE SQL 
      NOT DETERMINISTIC 
      CONTAINS SQL 
      SQL SECURITY DEFINER 
      COMMENT '' 
      BEGIN 

      UPDATE %2$s AS articulos_precios 

      INNER JOIN %3$s AS articulos 
         ON articulos.uuid = articulos_precios.articulo_uuid 

      LEFT JOIN %4$s AS tipos_iva 
         ON tipos_iva.codigo = articulos.tipo_iva_codigo 

      SET 
         articulos_precios.precio_base = precio_base, 
         articulos_precios.precio_iva_incluido = ( precio_base * tipos_iva.porcentaje / 100 ) + precio_base, 
         margen = ( articulos_precios.precio_base - articulos.precio_costo ) / precio_costo * 100, 
         margen_real = ( articulos_precios.precio_base - articulos.precio_costo ) / precio_base * 100, 
         manual = 1 

      WHERE articulos_precios.uuid = uuid_precio_articulo; 

      END

   ENDTEXT

   cSql  := hb_strformat(  cSql,;
                           Company():getTableName( 'UpdatePrecioBaseWhereUuid' ),;
                           ::getTableName(),;
                           SQLArticulosModel():getTableName(),;
                           SQLTiposIvaModel():getTableName() )

RETURN ( cSQL )

//---------------------------------------------------------------------------//

METHOD dropFunctionUpdatePrecioIvaIncluidoWhereUuid() CLASS ArticulosPreciosRepository  

RETURN ( "DROP PROCEDURE IF EXISTS " + Company():getTableName( 'UpdatePrecioIvaIncluidoWhereUuid' ) + ";" )

//---------------------------------------------------------------------------//

METHOD callUpdatePrecioIvaIncluidoWhereUuid( uuidPrecioArticulo, precioIvaIncluido ) CLASS ArticulosPreciosRepository

RETURN ( getSQLDatabase():Exec( "CALL " + Company():getTableName( 'UpdatePrecioIvaIncluidoWhereUuid' ) + "( " + quoted( uuidPrecioArticulo ) + ", " + hb_ntos( precioIvaIncluido ) + " )" ) )

//---------------------------------------------------------------------------//

METHOD createFunctionUpdatePrecioIvaIncluidoWhereUuid() CLASS ArticulosPreciosRepository

   local cSql

   TEXT INTO cSql

      CREATE DEFINER=`root`@`localhost` 
         PROCEDURE %1$s 
            (  IN `uuid_precio_articulo` CHAR(40),
               IN `precio_iva_incluido` FLOAT(16,6) ) 
         LANGUAGE SQL 
         NOT DETERMINISTIC 
         CONTAINS SQL 
         SQL SECURITY DEFINER 
         COMMENT '' 
         BEGIN 

         UPDATE %2$s AS articulos_precios 

         INNER JOIN %3$s AS articulos 
            ON articulos.uuid = articulos_precios.articulo_uuid 

         LEFT JOIN %4$s AS tipos_iva 
            ON tipos_iva.codigo = articulos.tipo_iva_codigo 

         SET 
            articulos_precios.precio_iva_incluido = precio_iva_incluido, 
            articulos_precios.precio_base = ( precio_iva_incluido / ( 1 + ( tipos_iva.porcentaje / 100 ) ) ), 
            margen = ( articulos_precios.precio_base - articulos.precio_costo ) / precio_costo * 100, 
            margen_real = ( articulos_precios.precio_base - articulos.precio_costo ) / precio_base * 100, 
            manual = 1 

         WHERE articulos_precios.uuid = uuid_precio_articulo; 

      END

   ENDTEXT

   cSql  := hb_strformat(  cSql,;
                           Company():getTableName( 'UpdatePrecioIvaIncluidoWhereUuid' ),;
                           ::getTableName(),;
                           SQLArticulosModel():getTableName(),;
                           SQLTiposIvaModel():getTableName() )

RETURN ( cSql )

//---------------------------------------------------------------------------//

METHOD dropFunctionUpdatePrecioWhereIdPrecio() CLASS ArticulosPreciosRepository  

RETURN ( "DROP PROCEDURE IF EXISTS " + Company():getTableName( 'UpdatePrecioWhereIdPrecio' ) + ";" )

//---------------------------------------------------------------------------//

METHOD callUpdatePrecioWhereIdPrecio( idPrecio ) CLASS ArticulosPreciosRepository

RETURN ( getSQLDatabase():Exec( "CALL " + Company():getTableName( 'UpdatePrecioWhereIdPrecio' ) + "( " + quoted( idPrecio ) + " )" ) )

//---------------------------------------------------------------------------//

METHOD createFunctionUpdatePrecioWhereIdPrecio() CLASS ArticulosPreciosRepository

   local cSql

   TEXT INTO cSql

      CREATE DEFINER=`root`@`localhost` PROCEDURE %1$s ( IN `id_articulo_precio` INT ) 
         LANGUAGE SQL
         NOT DETERMINISTIC
         CONTAINS SQL
         SQL SECURITY DEFINER
         COMMENT ''

         BEGIN

         DECLARE margen FLOAT;
         DECLARE margen_real FLOAT;
         DECLARE precio_costo FLOAT;
         DECLARE porcentaje_iva FLOAT;
         DECLARE precio_base FLOAT;
         DECLARE precio_iva_incluido FLOAT;

         SELECT 
            articulos_tarifas.margen, 
            IF( articulos_tarifas.parent_uuid = '', articulos.precio_costo, articulos_precios_parent.precio_base ),
            tipos_iva.porcentaje
         INTO 
            margen, 
            precio_costo, 
            porcentaje_iva 

         FROM %2$s AS articulos_precios   

            INNER JOIN %3$s AS articulos_tarifas 
               ON articulos_tarifas.uuid = articulos_precios.tarifa_uuid 

            LEFT JOIN %4$s AS articulos
               ON articulos.uuid = articulos_precios.articulo_uuid 

            LEFT JOIN %5$s AS tipos_iva 
               ON tipos_iva.codigo = articulos.tipo_iva_codigo 

            LEFT JOIN %2$s AS articulos_precios_parent     
               ON articulos_precios_parent.tarifa_uuid = articulos_tarifas.parent_uuid 
               AND articulos_precios_parent.articulo_uuid = articulos_precios.articulo_uuid 

         WHERE 
            ( ( articulos_precios.manual IS NULL OR articulos_precios.manual != 1 ) AND articulos_precios.id = id_articulo_precio ) 
            AND 
            ( articulos_tarifas.activa = 1 
               AND ( articulos_tarifas.valido_desde IS NULL OR articulos_tarifas.valido_desde >= CURDATE() )
               AND ( articulos_tarifas.valido_hasta IS NULL OR articulos_tarifas.valido_hasta <= CURDATE() ) 
            ); 

         SET precio_base         = ( precio_costo * margen / 100 ) + ( precio_costo );
         SET precio_iva_incluido = ( precio_base ) + ( precio_base * IFNULL( porcentaje_iva, 0 ) / 100 );

         IF precio_base > 0 THEN 
            SET margen_real      = ( ( precio_base - precio_costo ) / precio_base * 100 );
         ELSE 
            SET margen_real      = 0;
         END IF;

         UPDATE %2$s AS articulos_precios 
            SET 
               articulos_precios.margen = margen,
               articulos_precios.margen_real = margen_real,
               articulos_precios.precio_base = precio_base,
               articulos_precios.precio_iva_incluido = precio_iva_incluido
         WHERE 
            ( ( articulos_precios.manual IS NULL OR articulos_precios.manual != 1 ) AND articulos_precios.id = id_articulo_precio );

         END

   ENDTEXT

   cSql  := hb_strformat(  cSql,;
                           Company():getTableName( 'UpdatePrecioWhereIdPrecio' ),;
                           ::getTableName(),;
                           SQLArticulosTarifasModel():getTableName(),;
                           SQLArticulosModel():getTableName(),;
                           SQLTiposIvaModel():getTableName() )

RETURN ( cSQL )

//---------------------------------------------------------------------------//

METHOD dropFunctionUpdatePreciosWhereUuidArticulo() CLASS ArticulosPreciosRepository  

RETURN ( "DROP PROCEDURE IF EXISTS " + Company():getTableName( 'UpdatePreciosWhereUuidArticulo' ) + ";" )

//---------------------------------------------------------------------------//

METHOD callUpdatePreciosWhereUuidArticulo( uuidArticulo ) CLASS ArticulosPreciosRepository

RETURN ( getSQLDatabase():Exec( "CALL " + Company():getTableName( 'UpdatePreciosWhereUuidArticulo' ) + "( " + quoted( uuidArticulo ) + " )" ) )

//---------------------------------------------------------------------------//

METHOD createFunctionUpdatePreciosWhereUuidArticulo() CLASS ArticulosPreciosRepository

   local cSql

   TEXT INTO cSql

      CREATE DEFINER = `root`@`localhost` PROCEDURE %1$s ( IN `uuid_articulo_precio` CHAR(40) ) 
      
      LANGUAGE SQL
      NOT DETERMINISTIC
      CONTAINS SQL
      SQL SECURITY DEFINER
      COMMENT ''

      BEGIN

      DECLARE done INT DEFAULT FALSE;
      DECLARE id_articulo_precio INT;

      DECLARE cursor_articulo CURSOR FOR
      SELECT id
         FROM %3$s AS articulos_precios 
         WHERE articulos_precios.articulo_uuid = uuid_articulo_precio   
         ORDER BY articulos_precios.id;

      DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

      OPEN cursor_articulo;

      read_loop: LOOP 
      FETCH cursor_articulo INTO id_articulo_precio;

         IF done THEN
            LEAVE read_loop;
         END IF;

         CALL %2$s( id_articulo_precio );

      END LOOP;

      CLOSE cursor_articulo;

   END

   ENDTEXT

   cSql  := hb_strformat(  cSql,;
                           Company():getTableName( 'UpdatePreciosWhereUuidArticulo' ),;
                           Company():getTableName( 'UpdatePrecioWhereIdPrecio' ),;
                           ::getTableName() )

RETURN ( cSql )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

