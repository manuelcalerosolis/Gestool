#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Hdo.ch"

//---------------------------------------------------------------------------//

CLASS StocksRepository FROM SQLBaseRepository

   METHOD getSQLFunctions()            INLINE ( {  ::dropFunctionStockWhereCodigo(),;
                                                   ::createFunctionStockWhereCodigo(),;
                                                   ::dropFunctionStockWhereCodigoAlmacen(),;
                                                   ::createFunctionStockWhereCodigoAlmacen(),;
                                                   ::dropFunctionStockWhereCodigoAlmacenUbicacion(),;
                                                   ::createFunctionStockWhereCodigoAlmacenUbicacion(),;
                                                   ::dropFunctionStockWhereCodigoAlmacenLote(),;
                                                   ::createFunctionStockWhereCodigoAlmacenLote(),;
                                                   ::dropFunctionStockWhereCodigoAlmacenCombinaciones(),;
                                                   ::createFunctionStockWhereCodigoAlmacenCombinaciones() } )

   METHOD dropFunctionStockWhereCodigo() ;
                                       INLINE ( "DROP FUNCTION IF EXISTS " + Company():getTableName( 'StockWhereCodigo' ) + ";" )

   METHOD createFunctionStockWhereCodigo()

   METHOD selectStockWhereCodigo( cCodigoArticulo )

   METHOD dropFunctionStockWhereCodigoAlmacen() ;
                                       INLINE ( "DROP FUNCTION IF EXISTS " + Company():getTableName( 'StockWhereCodigoAlmacen' ) + ";" )

   METHOD createFunctionStockWhereCodigoAlmacen()

   METHOD selectStockWhereCodigoAlmacen( cCodigoArticulo, cCodigoAlmacen )

   METHOD dropFunctionStockWhereCodigoAlmacenUbicacion() ;
                                       INLINE ( "DROP FUNCTION IF EXISTS " + Company():getTableName( 'StockWhereCodigoAlmacenUbicacion' ) + ";" )

   METHOD createFunctionStockWhereCodigoAlmacenUbicacion() 

   METHOD selectStockWhereCodigoAlmacenUbicacion( cCodigoArticulo, cCodigoAlmacen, cCodigoUbicacion )

   METHOD dropFunctionStockWhereCodigoAlmacenLote() ;
                                       INLINE ( "DROP FUNCTION IF EXISTS " + Company():getTableName( 'StockWhereCodigoAlmacenUbicacionLote' ) + ";" )

   METHOD createFunctionStockWhereCodigoAlmacenLote() 

   METHOD selectStockWhereCodigoAlmacenLote( cCodigoArticulo, cCodigoAlmacen, cCodigoUbicacion, cLote )

   METHOD dropFunctionStockWhereCodigoAlmacenCombinaciones() ;
                                       INLINE ( "DROP FUNCTION IF EXISTS " + Company():getTableName( 'StockWhereCodigoAlmacenUbicacionLoteCombinaciones' ) + ";" )

   METHOD createFunctionStockWhereCodigoAlmacenCombinaciones() 

   METHOD selectStockWhereCodigoAlmacenCombinaciones( cCodigoArticulo, cCodigoAlmacen, cCodigoUbicacion, cLote, uuidCombinaciones )

   METHOD sqlAlbaranesComprasLineas()

   METHOD sqlAlbaranesComprasLineasAlmacen( cParam1, cParam2, cParam3 ) ;
                                       INLINE ( ::sqlAlbaranesComprasLineas( "albaranes_compras.almacen_codigo = almacen_codigo", cParam1, cParam2, cParam3 ) ) 

   METHOD sqlAlbaranesComprasLineasUbicacion( cParam1, cParam2 ) ;
                                       INLINE ( ::sqlAlbaranesComprasLineasAlmacen( "albaranes_compras_lineas.ubicacion_codigo = ubicacion_codigo", cParam1, cParam2 ) ) 

   METHOD sqlAlbaranesComprasLineasLote( cParam1 ) ;
                                       INLINE ( ::sqlAlbaranesComprasLineasUbicacion( "albaranes_compras_lineas.lote = lote", cParam1 ) ) 

   METHOD sqlAlbaranesComprasLineasCombinaciones() ;
                                       INLINE ( ::sqlAlbaranesComprasLineasLote( "albaranes_compras_lineas.combinaciones_uuid = combinaciones_uuid" ) )

   METHOD sqlAlbaranesVentasLineas()

   METHOD sqlAlbaranesVentasLineasAlmacen( cParam1, cParam2, cParam3 ) ;
                                       INLINE ( ::sqlAlbaranesVentasLineas( "albaranes_ventas.almacen_codigo = almacen_codigo", cParam1, cParam2, cParam3 ) ) 

   METHOD sqlAlbaranesVentasLineasUbicacion( cParam1, cParam2 ) ;
                                       INLINE ( ::sqlAlbaranesVentasLineasAlmacen( "albaranes_ventas_lineas.ubicacion_codigo = ubicacion_codigo", cParam1, cParam2 ) ) 

   METHOD sqlAlbaranesVentasLineasLote( cParam1 ) ;
                                       INLINE ( ::sqlAlbaranesVentasLineasUbicacion( "albaranes_ventas_lineas.lote = lote", cParam1 ) ) 

   METHOD sqlAlbaranesVentasLineasCombinaciones() ;
                                       INLINE ( ::sqlAlbaranesVentasLineasLote( "albaranes_ventas_lineas.combinaciones_uuid = combinaciones_uuid" ) )

   METHOD sqlConsolidacionesAlmacenesLineas(...)

   METHOD sqlConsolidacionesAlmacenesLineasAlmacen( cParam1, cParam2, cParam3 ) ;
                                       INLINE ( ::sqlConsolidacionesAlmacenesLineas( "consolidaciones_almacenes.almacen_codigo = almacen_codigo", cParam1, cParam2, cParam3 ) ) 

   METHOD sqlConsolidacionesAlmacenesLineasUbicacion( cParam1, cParam2 ) ;
                                       INLINE ( ::sqlConsolidacionesAlmacenesLineasAlmacen( "consolidaciones_almacenes_lineas.ubicacion_codigo = ubicacion_codigo", cParam1, cParam2 ) ) 

   METHOD sqlConsolidacionesAlmacenesLineasLote( cParam1 ) ;
                                       INLINE ( ::sqlConsolidacionesAlmacenesLineasUbicacion( "consolidaciones_almacenes_lineas.lote = lote", cParam1 ) ) 

   METHOD sqlConsolidacionesAlmacenesLineasCombinaciones() ;
                                       INLINE ( ::sqlConsolidacionesAlmacenesLineasLote( "consolidaciones_almacenes_lineas.combinaciones_uuid = combinaciones_uuid" ) )

   METHOD sqlMovimientosOrigenAlmacenesLineas(...)

   METHOD sqlMovimientosOrigenAlmacenesLineasAlmacen( cParam1, cParam2, cParam3 ) ;
                                       INLINE ( ::sqlMovimientosOrigenAlmacenesLineas( "movimientos_almacenes.almacen_origen_codigo = almacen_codigo", cParam1, cParam2, cParam3 ) ) 

   METHOD sqlMovimientosOrigenAlmacenesLineasUbicacion( cParam1, cParam2 ) ;
                                       INLINE ( ::sqlMovimientosOrigenAlmacenesLineasAlmacen( "movimientos_almacenes_lineas.ubicacion_origen_codigo = ubicacion_codigo", cParam1, cParam2 ) ) 

   METHOD sqlMovimientosOrigenAlmacenesLineasLote( cParam1 ) ;
                                       INLINE ( ::sqlMovimientosOrigenAlmacenesLineasUbicacion( "movimientos_almacenes_lineas.lote = lote", cParam1 ) ) 

   METHOD sqlMovimientosOrigenAlmacenesLineasCombinaciones() ;
                                       INLINE ( ::sqlMovimientosOrigenAlmacenesLineasLote( "movimientos_almacenes_lineas.combinaciones_uuid = combinaciones_uuid" ) )

   METHOD sqlMovimientosDestinoAlmacenesLineas(...)

   METHOD sqlMovimientosDestinoAlmacenesLineasAlmacen( cParam1, cParam2, cParam3 ) ;
                                       INLINE ( ::sqlMovimientosDestinoAlmacenesLineas( "movimientos_almacenes.almacen_destino_codigo = almacen_codigo", cParam1, cParam2, cParam3 ) ) 

   METHOD sqlMovimientosDestinoAlmacenesLineasUbicacion( cParam1, cParam2 ) ;
                                       INLINE ( ::sqlMovimientosDestinoAlmacenesLineasAlmacen( "movimientos_almacenes_lineas.ubicacion_destino_codigo = ubicacion_codigo", cParam1, cParam2 ) ) 

   METHOD sqlMovimientosDestinoAlmacenesLineasLote( cParam1 ) ;
                                       INLINE ( ::sqlMovimientosDestinoAlmacenesLineasUbicacion( "movimientos_almacenes_lineas.lote = lote", cParam1 ) ) 

   METHOD sqlMovimientosDestinoAlmacenesLineasCombinaciones() ;
                                       INLINE ( ::sqlMovimientosDestinoAlmacenesLineasLote( "movimientos_almacenes_lineas.combinaciones_uuid = combinaciones_uuid" ) )

   METHOD sqlJoinConsolidacionesAlmacenesLineas(...)

   METHOD sqlJoinConsolidacionesAlmacenesLineasAlmacen( cParam1, cParam2, cParam3 ) ;
                                       INLINE ( ::sqlJoinConsolidacionesAlmacenesLineas( "movimientos_almacenes.almacen_origen_codigo = almacen_codigo", cParam1, cParam2, cParam3 ) ) 

   METHOD sqlJoinConsolidacionesAlmacenesLineasUbicacion( cParam1, cParam2 ) ;
                                       INLINE ( ::sqlJoinConsolidacionesAlmacenesLineasAlmacen( "movimientos_almacenes_lineas.ubicacion_origen_codigo = ubicacion_codigo", cParam1, cParam2 ) ) 

   METHOD sqlJoinConsolidacionesAlmacenesLineasLote( cParam1 ) ;
                                       INLINE ( ::sqlJoinConsolidacionesAlmacenesLineasUbicacion( "movimientos_almacenes_lineas.lote = lote", cParam1 ) ) 

   METHOD sqlJoinConsolidacionesAlmacenesLineasCombinaciones() ;
                                       INLINE ( ::sqlJoinConsolidacionesAlmacenesLineasLote( "movimientos_almacenes_lineas.combinaciones_uuid = combinaciones_uuid" ) )

   METHOD sqlOnMovimientosUnion()

   METHOD sqlSelectMovimientosUnion()

   METHOD sqlWhereMovimientosUnion()

END CLASS

//---------------------------------------------------------------------------//

METHOD sqlAlbaranesComprasLineas(...) CLASS StocksRepository

   local cSql  

   TEXT INTO cSql
      SELECT
         ( IFNULL( albaranes_compras_lineas.unidad_medicion_factor, 1 ) * albaranes_compras_lineas.articulo_unidades ) AS total_unidades,
         albaranes_compras_lineas.articulo_codigo AS articulo_codigo,
         albaranes_compras.almacen_codigo AS almacen_codigo,
         albaranes_compras_lineas.ubicacion_codigo AS ubicacion_codigo,
         albaranes_compras_lineas.lote AS lote,
         albaranes_compras_lineas.combinaciones_uuid AS combinaciones_uuid,
         albaranes_compras.fecha_valor_stock AS fecha_valor_stock
      
      FROM %2$s AS albaranes_compras_lineas 

         INNER JOIN %1$s AS albaranes_compras
            ON albaranes_compras.uuid = albaranes_compras_lineas.parent_uuid      

      WHERE albaranes_compras_lineas.articulo_codigo = articulo_codigo AND 
            albaranes_compras_lineas.deleted_at = 0 
   ENDTEXT

   cSql     := hb_strformat( cSql, SQLAlbaranesComprasModel():getTableName(), SQLAlbaranesComprasLineasModel():getTableName() )

   cSql     := alltrim( cSql )

   aeval( hb_aparams(), {|cParam| if( !empty( cParam ), cSql += " AND " + cParam, ) } )

RETURN ( cSql )

//---------------------------------------------------------------------------//

METHOD sqlAlbaranesVentasLineas(...) CLASS StocksRepository

   local cSql  

   TEXT INTO cSql
      SELECT
         ( ( IFNULL( albaranes_ventas_lineas.unidad_medicion_factor, 1 ) * albaranes_ventas_lineas.articulo_unidades ) * -1 ) AS total_unidades,
         albaranes_ventas_lineas.articulo_codigo AS articulo_codigo,
         albaranes_ventas.almacen_codigo AS almacen_codigo,
         albaranes_ventas_lineas.ubicacion_codigo AS ubicacion_codigo,
         albaranes_ventas_lineas.lote AS lote,
         albaranes_ventas_lineas.combinaciones_uuid AS combinaciones_uuid,
         albaranes_ventas.fecha_valor_stock AS fecha_valor_stock
      
      FROM %2$s AS albaranes_ventas_lineas 

         INNER JOIN %1$s AS albaranes_ventas
            ON albaranes_ventas.uuid = albaranes_ventas_lineas.parent_uuid      

      WHERE albaranes_ventas_lineas.articulo_codigo = articulo_codigo AND 
            albaranes_ventas_lineas.deleted_at = 0 
   ENDTEXT

   cSql     := hb_strformat( cSql, SQLAlbaranesVentasModel():getTableName(), SQLAlbaranesVentasLineasModel():getTableName() )

   cSql     := alltrim( cSql )

   aeval( hb_aparams(), {|cParam| if( !empty( cParam ), cSql += " AND " + cParam, ) } )

RETURN ( cSql )

//---------------------------------------------------------------------------//

METHOD sqlConsolidacionesAlmacenesLineas(...) CLASS StocksRepository

   local cSql  

   TEXT INTO cSql

      SELECT
         ( IFNULL( consolidaciones_almacenes_lineas.unidad_medicion_factor, 1 ) * consolidaciones_almacenes_lineas.articulo_unidades ) AS total_unidades ,
         consolidaciones_almacenes_lineas.articulo_codigo AS articulo_codigo,
         consolidaciones_almacenes.almacen_codigo AS almacen_codigo,
         consolidaciones_almacenes_lineas.ubicacion_codigo AS ubicacion_codigo,
         consolidaciones_almacenes_lineas.lote AS lote,
         consolidaciones_almacenes_lineas.combinaciones_uuid AS combinaciones_uuid,
         consolidaciones_almacenes.fecha_valor_stock AS fecha_valor_stock
      
      FROM %2$s AS consolidaciones_almacenes_lineas 

         INNER JOIN %1$s AS consolidaciones_almacenes
            ON consolidaciones_almacenes.uuid = consolidaciones_almacenes_lineas.parent_uuid      

      WHERE consolidaciones_almacenes_lineas.articulo_codigo = articulo_codigo AND 
            consolidaciones_almacenes_lineas.deleted_at = 0 

   ENDTEXT

   cSql     := hb_strformat( cSql, SQLConsolidacionesAlmacenesModel():getTableName(), SQLConsolidacionesAlmacenesLineasModel():getTableName() )

   cSql     := alltrim( cSql )

   aeval( hb_aparams(), {|cParam| if( !empty( cParam ), cSql += " AND " + cParam, ) } )

RETURN ( cSql )

//---------------------------------------------------------------------------//

METHOD sqlMovimientosOrigenAlmacenesLineas(...) CLASS StocksRepository

   local cSql  

   TEXT INTO cSql
      SELECT
         ( IFNULL( movimientos_almacenes_lineas.unidad_medicion_factor, 1 ) * movimientos_almacenes_lineas.articulo_unidades * -1 ) AS total_unidades,
         movimientos_almacenes_lineas.articulo_codigo AS articulo_codigo,
         movimientos_almacenes.almacen_origen_codigo AS almacen_codigo,
         movimientos_almacenes_lineas.ubicacion_origen_codigo AS ubicacion_codigo,
         movimientos_almacenes_lineas.lote AS lote,
         movimientos_almacenes_lineas.combinaciones_uuid AS combinaciones_uuid,
         movimientos_almacenes.fecha_valor_stock AS fecha_valor_stock
      
      FROM %2$s AS movimientos_almacenes_lineas 

         INNER JOIN %1$s AS movimientos_almacenes
            ON movimientos_almacenes.uuid = movimientos_almacenes_lineas.parent_uuid      

      WHERE movimientos_almacenes_lineas.articulo_codigo = articulo_codigo AND 
            movimientos_almacenes_lineas.deleted_at = 0  
   ENDTEXT

   cSql     := hb_strformat( cSql, SQLMovimientosAlmacenesModel():getTableName(), SQLMovimientosAlmacenesLineasModel():getTableName() )

   cSql     := alltrim( cSql )

   aeval( hb_aparams(), {|cParam| if( !empty( cParam ), cSql += " AND " + cParam, ) } )

RETURN ( cSql )

//---------------------------------------------------------------------------//

METHOD sqlMovimientosDestinoAlmacenesLineas(...) CLASS StocksRepository

   local cSql  

   TEXT INTO cSql
      SELECT
         ( IFNULL( movimientos_almacenes_lineas.unidad_medicion_factor, 1 ) * movimientos_almacenes_lineas.articulo_unidades * -1 ) AS total_unidades,
         movimientos_almacenes_lineas.articulo_codigo AS articulo_codigo,
         movimientos_almacenes.almacen_destino_codigo AS almacen_codigo,
         movimientos_almacenes_lineas.ubicacion_destino_codigo AS ubicacion_codigo,
         movimientos_almacenes_lineas.lote AS lote,
         movimientos_almacenes_lineas.combinaciones_uuid AS combinaciones_uuid,
         movimientos_almacenes.fecha_valor_stock AS fecha_valor_stock
      
      FROM %2$s AS movimientos_almacenes_lineas 

         INNER JOIN %1$s AS movimientos_almacenes
            ON movimientos_almacenes.uuid = movimientos_almacenes_lineas.parent_uuid      

      WHERE movimientos_almacenes_lineas.articulo_codigo = articulo_codigo AND 
            movimientos_almacenes_lineas.deleted_at = 0  
   ENDTEXT

   cSql     := hb_strformat( cSql, SQLMovimientosAlmacenesModel():getTableName(), SQLMovimientosAlmacenesLineasModel():getTableName() )

   cSql     := alltrim( cSql )

   aeval( hb_aparams(), {|cParam| if( !empty( cParam ), cSql += " AND " + cParam, ) } )

RETURN ( cSql )

//---------------------------------------------------------------------------//

METHOD sqlJoinConsolidacionesAlmacenesLineas(...) CLASS StocksRepository

   local cSql  
   local cGroup  

   TEXT INTO cSql
      SELECT 
         consolidaciones_almacenes_lineas.articulo_codigo AS articulo_codigo, 
         consolidaciones_almacenes_lineas.ubicacion_codigo AS ubicacion_codigo,
         consolidaciones_almacenes_lineas.lote AS lote,
         consolidaciones_almacenes_lineas.combinaciones_uuid AS combinaciones_uuid,
         IFNULL( consolidaciones_almacenes_lineas.unidad_medicion_factor, 1 ) * consolidaciones_almacenes_lineas.articulo_unidades AS total_unidades, 
         consolidaciones_almacenes.almacen_codigo,
         consolidaciones_almacenes.fecha_valor_stock AS fecha_valor_stock

      FROM %2$s AS consolidaciones_almacenes_lineas 

      INNER JOIN %1$s AS consolidaciones_almacenes
         ON consolidaciones_almacenes.uuid = consolidaciones_almacenes_lineas.parent_uuid      

      WHERE consolidaciones_almacenes_lineas.articulo_codigo = articulo_codigo AND 
            consolidaciones_almacenes_lineas.deleted_at = 0  
   ENDTEXT

   cSql     := hb_strformat( cSql, SQLConsolidacionesAlmacenesModel():getTableName(), SQLConsolidacionesAlmacenesLineasModel():getTableName() )

   cSql     := alltrim( cSql )

   aeval( hb_aparams(), {|cParam| if( !empty( cParam ), cSql += " AND " + cParam, ) } )

   TEXT INTO cGroup
      GROUP BY consolidaciones_almacenes_lineas.articulo_codigo,
               consolidaciones_almacenes.almacen_codigo, 
               consolidaciones_almacenes_lineas.ubicacion_codigo, 
               consolidaciones_almacenes_lineas.lote, 
               consolidaciones_almacenes_lineas.combinaciones_uuid

      ORDER BY consolidaciones_almacenes.fecha_valor_stock
      
      LIMIT 1
   ENDTEXT

   cSql     += " " + alltrim( cGroup )

RETURN ( cSql )

//---------------------------------------------------------------------------//

METHOD sqlOnMovimientosUnion() CLASS StocksRepository

   local cSql  

   TEXT INTO cSql
      ON movimientos_union.articulo_codigo = consolidaciones_almacenes.articulo_codigo AND
         movimientos_union.almacen_codigo = consolidaciones_almacenes.almacen_codigo AND
         movimientos_union.ubicacion_codigo = consolidaciones_almacenes.ubicacion_codigo AND
         movimientos_union.lote = consolidaciones_almacenes.lote AND 
         movimientos_union.combinaciones_uuid = consolidaciones_almacenes.combinaciones_uuid  
   ENDTEXT

RETURN ( alltrim( cSql ) )

//---------------------------------------------------------------------------//

METHOD sqlSelectMovimientosUnion() CLASS StocksRepository

   local cSql  

   TEXT INTO cSql
      movimientos_union.total_unidades ,
      movimientos_union.articulo_codigo,
      movimientos_union.almacen_codigo,
      movimientos_union.ubicacion_codigo,
      movimientos_union.lote,
      movimientos_union.combinaciones_uuid,
      movimientos_union.fecha_valor_stock
   ENDTEXT

RETURN ( alltrim( cSql ) )

//---------------------------------------------------------------------------//

METHOD sqlWhereMovimientosUnion() CLASS StocksRepository

   local cSql  

   TEXT INTO cSql
      movimientos_union.fecha_valor_stock >= consolidaciones_almacenes.fecha_valor_stock OR 
      consolidaciones_almacenes.fecha_valor_stock IS NULL
   ENDTEXT

RETURN ( alltrim( cSql ) )

//---------------------------------------------------------------------------//

METHOD createFunctionStockWhereCodigo() CLASS StocksRepository

   local cSql  

   TEXT INTO cSql

   CREATE DEFINER=`root`@`localhost` 
   FUNCTION %1$s ( `articulo_codigo` CHAR( 20 ) )
   RETURNS DECIMAL( 19, 6 )
   LANGUAGE SQL
   NOT DETERMINISTIC
   CONTAINS SQL
   SQL SECURITY DEFINER
   COMMENT ''

   BEGIN

   DECLARE TotalStock DECIMAL( 19, 6 );

   SELECT 
      SUM( stocks.total_unidades ) INTO TotalStock
   FROM
      (
         SELECT 
            %2$s
         FROM
         (
            %3$s
               UNION 
            %4$s
               UNION 
            %5$s
               UNION
            %6$s 
               UNION
            %7$s
         ) 
         AS movimientos_union

         LEFT JOIN 
            (
               %8$s
            ) 
            AS consolidaciones_almacenes

            %9$s

         WHERE
            %10$s
      )
      AS stocks;    

   RETURN TotalStock;

   END

   ENDTEXT

   cSql  := hb_strformat(  cSql,;
                           Company():getTableName( 'StockWhereCodigo' ),;
                           ::sqlSelectMovimientosUnion(),;
                           ::sqlAlbaranesComprasLineas(),;
                           ::sqlConsolidacionesAlmacenesLineas(),;
                           ::sqlMovimientosOrigenAlmacenesLineas(),;
                           ::sqlMovimientosDestinoAlmacenesLineas(),;
                           ::sqlAlbaranesVentasLineas(),;
                           ::sqlJoinConsolidacionesAlmacenesLineas(),;
                           ::sqlOnMovimientosUnion(),;
                           ::sqlWhereMovimientosUnion() )

   logwrite( cSql )

RETURN ( alltrim( cSql ) )

//---------------------------------------------------------------------------//

METHOD selectStockWhereCodigo( cCodigoArticulo ) CLASS StocksRepository

RETURN ( getSQLDatabase():getValue( "SELECT " + Company():getTableName( "StockWhereCodigo" ) + "( " + quoted( cCodigoArticulo ) + " )", 0 ) )

//---------------------------------------------------------------------------//

METHOD createFunctionStockWhereCodigoAlmacen() CLASS StocksRepository

   local cSql  

   TEXT INTO cSql

   CREATE DEFINER=`root`@`localhost` 
   FUNCTION %1$s ( `articulo_codigo` CHAR( 20 ), `almacen_codigo` CHAR( 20 ) )
   RETURNS DECIMAL( 19, 6 )
   LANGUAGE SQL
   NOT DETERMINISTIC
   CONTAINS SQL
   SQL SECURITY DEFINER
   COMMENT ''

   BEGIN

   DECLARE TotalStock DECIMAL( 19, 6 );

   SELECT 
      SUM( stocks.total_unidades ) INTO TotalStock
   FROM
      (
         SELECT 
            %2$s
         FROM
         (
            %3$s
               UNION 
            %4$s
               UNION 
            %5$s
               UNION
            %6$s 
               UNION
            %7$s
         ) 
         AS movimientos_union

         LEFT JOIN 
            (
               %8$s
            ) 
            AS consolidaciones_almacenes

            %9$s

         WHERE
            %10$s
      )
      AS stocks;    

   RETURN TotalStock;

   END

   ENDTEXT

   cSql  := hb_strformat(  cSql,;
                           Company():getTableName( 'StockWhereCodigoAlmacen' ),;
                           ::sqlSelectMovimientosUnion(),;
                           ::sqlAlbaranesComprasLineasAlmacen(),;
                           ::sqlConsolidacionesAlmacenesLineasAlmacen(),;
                           ::sqlMovimientosOrigenAlmacenesLineasAlmacen (),;
                           ::sqlMovimientosDestinoAlmacenesLineasAlmacen(),;
                           ::sqlAlbaranesVentasLineasAlmacen(),;
                           ::sqlJoinConsolidacionesAlmacenesLineasAlmacen(),;
                           ::sqlOnMovimientosUnion(),;
                           ::sqlWhereMovimientosUnion() )

RETURN ( alltrim( cSql ) )

//---------------------------------------------------------------------------//

METHOD selectStockWhereCodigoAlmacen( cCodigoArticulo, cCodigoAlmacen ) CLASS StocksRepository

RETURN ( getSQLDatabase():getValue( "SELECT " + Company():getTableName( "StockWhereCodigoAlmacen" ) + "( " + quoted( cCodigoArticulo ) + ", " + quoted( cCodigoAlmacen ) + " )", 0 ) )

//---------------------------------------------------------------------------//

METHOD createFunctionStockWhereCodigoAlmacenUbicacion() CLASS StocksRepository

   local cSql  

   TEXT INTO cSql

   CREATE DEFINER=`root`@`localhost` 
   FUNCTION %1$s ( `articulo_codigo` CHAR( 20 ), `almacen_codigo` CHAR( 20 ), `ubicacion_codigo` CHAR( 20 ) )
   RETURNS DECIMAL( 19, 6 )
   LANGUAGE SQL
   NOT DETERMINISTIC
   CONTAINS SQL
   SQL SECURITY DEFINER
   COMMENT ''

   BEGIN

   DECLARE TotalStock DECIMAL( 19, 6 );

   SELECT 
      SUM( stocks.total_unidades ) INTO TotalStock

   FROM
      (

         SELECT 
            movimientos_union.total_unidades ,
            movimientos_union.articulo_codigo,
            movimientos_union.almacen_codigo,
            movimientos_union.ubicacion_codigo,
            movimientos_union.lote,
            movimientos_union.combinaciones_uuid,
            movimientos_union.fecha_valor_stock

         FROM
         (

            %6$s

            UNION 

            SELECT
               ( IFNULL( consolidaciones_almacenes_lineas.unidad_medicion_factor, 1 ) * consolidaciones_almacenes_lineas.articulo_unidades ) AS total_unidades ,
               consolidaciones_almacenes_lineas.articulo_codigo AS articulo_codigo,
               consolidaciones_almacenes.almacen_codigo AS almacen_codigo,
               consolidaciones_almacenes_lineas.ubicacion_codigo AS ubicacion_codigo,
               consolidaciones_almacenes_lineas.lote AS lote,
               consolidaciones_almacenes_lineas.combinaciones_uuid AS combinaciones_uuid,
               consolidaciones_almacenes.fecha_valor_stock AS fecha_valor_stock
            
            FROM %3$s AS consolidaciones_almacenes_lineas 

               INNER JOIN %2$s AS consolidaciones_almacenes
                  ON consolidaciones_almacenes.uuid = consolidaciones_almacenes_lineas.parent_uuid      

            WHERE consolidaciones_almacenes_lineas.articulo_codigo = articulo_codigo AND 
                  consolidaciones_almacenes.almacen_codigo = almacen_codigo AND 
                  consolidaciones_almacenes_lineas.ubicacion_codigo = ubicacion_codigo AND 
                  consolidaciones_almacenes_lineas.deleted_at = 0 

            UNION 

            SELECT
               ( IFNULL( movimientos_almacenes_lineas.unidad_medicion_factor, 1 ) * movimientos_almacenes_lineas.articulo_unidades * -1 ) AS total_unidades ,
               movimientos_almacenes_lineas.articulo_codigo AS articulo_codigo,
               movimientos_almacenes.almacen_origen_codigo AS almacen_codigo,
               movimientos_almacenes_lineas.ubicacion_origen_codigo AS ubicacion_codigo,
               movimientos_almacenes_lineas.lote AS lote,
               movimientos_almacenes_lineas.combinaciones_uuid AS combinaciones_uuid,
               movimientos_almacenes.fecha_valor_stock AS fecha_valor_stock
            
            FROM %5$s AS movimientos_almacenes_lineas 

               INNER JOIN %4$s AS movimientos_almacenes
                  ON movimientos_almacenes.uuid = movimientos_almacenes_lineas.parent_uuid      

            WHERE movimientos_almacenes_lineas.articulo_codigo = articulo_codigo AND 
                  movimientos_almacenes.almacen_origen_codigo = almacen_codigo AND 
                  movimientos_almacenes_lineas.ubicacion_origen_codigo = ubicacion_codigo AND 
                  movimientos_almacenes_lineas.deleted_at = 0  

            UNION

            SELECT
               ( IFNULL( movimientos_almacenes_lineas.unidad_medicion_factor, 1 ) * movimientos_almacenes_lineas.articulo_unidades ) AS total_unidades,
               movimientos_almacenes_lineas.articulo_codigo AS articulo_codigo,
               movimientos_almacenes.almacen_destino_codigo AS almacen_codigo,
               movimientos_almacenes_lineas.ubicacion_destino_codigo AS ubicacion_codigo,
               movimientos_almacenes_lineas.lote AS lote,
               movimientos_almacenes_lineas.combinaciones_uuid AS combinaciones_uuid,
               movimientos_almacenes.fecha_valor_stock AS fecha_valor_stock
            
            FROM %5$s AS movimientos_almacenes_lineas 

            INNER JOIN %4$s AS movimientos_almacenes
               ON movimientos_almacenes.uuid = movimientos_almacenes_lineas.parent_uuid  

            WHERE movimientos_almacenes_lineas.articulo_codigo = articulo_codigo AND 
                  movimientos_almacenes.almacen_destino_codigo = almacen_codigo AND 
                  movimientos_almacenes_lineas.ubicacion_destino_codigo = ubicacion_codigo AND 
                  movimientos_almacenes_lineas.deleted_at = 0    

            UNION

            %7$s

         ) 
         AS movimientos_union

            LEFT JOIN 
               (
                  SELECT 
                     consolidaciones_almacenes_lineas.articulo_codigo AS articulo_codigo, 
                     consolidaciones_almacenes.almacen_codigo,
                     consolidaciones_almacenes_lineas.ubicacion_codigo AS ubicacion_codigo,
                     consolidaciones_almacenes_lineas.lote AS lote,
                     consolidaciones_almacenes_lineas.combinaciones_uuid AS combinaciones_uuid,
                     IFNULL( consolidaciones_almacenes_lineas.unidad_medicion_factor, 1 ) * consolidaciones_almacenes_lineas.articulo_unidades AS total_unidades, 
                     consolidaciones_almacenes.fecha_valor_stock AS fecha_valor_stock

                  FROM %3$s AS consolidaciones_almacenes_lineas 

                  INNER JOIN %2$s AS consolidaciones_almacenes
                     ON consolidaciones_almacenes.uuid = consolidaciones_almacenes_lineas.parent_uuid      

                  WHERE consolidaciones_almacenes_lineas.articulo_codigo = articulo_codigo AND 
                        consolidaciones_almacenes.almacen_codigo = almacen_codigo AND
                        consolidaciones_almacenes_lineas.ubicacion_codigo = ubicacion_codigo AND 
                        consolidaciones_almacenes_lineas.deleted_at = 0  

                  GROUP BY consolidaciones_almacenes_lineas.articulo_codigo, consolidaciones_almacenes.almacen_codigo, consolidaciones_almacenes_lineas.ubicacion_codigo, consolidaciones_almacenes_lineas.lote, consolidaciones_almacenes_lineas.combinaciones_uuid

                  ORDER BY consolidaciones_almacenes.fecha_valor_stock
                  
                  LIMIT 1
               ) 
               AS consolidaciones_almacenes

               ON movimientos_union.articulo_codigo = consolidaciones_almacenes.articulo_codigo AND
                  movimientos_union.almacen_codigo = consolidaciones_almacenes.almacen_codigo AND
                  movimientos_union.ubicacion_codigo = consolidaciones_almacenes.ubicacion_codigo AND
                  movimientos_union.lote = consolidaciones_almacenes.lote AND 
                  movimientos_union.combinaciones_uuid = consolidaciones_almacenes.combinaciones_uuid  

            WHERE

               movimientos_union.fecha_valor_stock >= consolidaciones_almacenes.fecha_valor_stock OR 
               consolidaciones_almacenes.fecha_valor_stock IS NULL
      )
      AS stocks;    

      RETURN TotalStock;

   END

   ENDTEXT

   cSql  := hb_strformat(  cSql,;
                           Company():getTableName( 'StockWhereCodigoAlmacenUbicacion' ),;
                           SQLConsolidacionesAlmacenesModel():getTableName(),;
                           SQLConsolidacionesAlmacenesLineasModel():getTableName(),;
                           SQLMovimientosAlmacenesModel():getTableName(),;
                           SQLMovimientosAlmacenesLineasModel():getTableName(),;
                           ::sqlAlbaranesComprasLineasUbicacion(),;
                           ::sqlAlbaranesVentasLineasUbicacion() )

RETURN ( alltrim( cSql ) )

//---------------------------------------------------------------------------//

METHOD selectStockWhereCodigoAlmacenUbicacion( cCodigoArticulo, cCodigoAlmacen, cCodigoUbicacion ) CLASS StocksRepository

RETURN ( getSQLDatabase():getValue( "SELECT " + Company():getTableName( "StockWhereCodigoAlmacenUbicacion" ) + "( " + quoted( cCodigoArticulo ) + ", " + quoted( cCodigoAlmacen ) + ", " + quoted( cCodigoUbicacion ) + " )", 0 ) )

//---------------------------------------------------------------------------//

METHOD createFunctionStockWhereCodigoAlmacenLote() CLASS StocksRepository

   local cSql  

   TEXT INTO cSql

   CREATE DEFINER=`root`@`localhost` 
   FUNCTION %1$s ( `articulo_codigo` CHAR( 20 ), `almacen_codigo` CHAR( 20 ), `ubicacion_codigo` CHAR( 20 ), `lote` CHAR( 20 ) )
   RETURNS DECIMAL( 19, 6 )
   LANGUAGE SQL
   NOT DETERMINISTIC
   CONTAINS SQL
   SQL SECURITY DEFINER
   COMMENT ''

   BEGIN

   DECLARE TotalStock DECIMAL( 19, 6 );

   SELECT 
      SUM( stocks.total_unidades ) INTO TotalStock

   FROM
      (

         SELECT 
            movimientos_union.total_unidades ,
            movimientos_union.articulo_codigo,
            movimientos_union.almacen_codigo,
            movimientos_union.ubicacion_codigo,
            movimientos_union.lote,
            movimientos_union.combinaciones_uuid,
            movimientos_union.fecha_valor_stock

         FROM
         (

            %6$s

            UNION 

            SELECT
               ( IFNULL( consolidaciones_almacenes_lineas.unidad_medicion_factor, 1 ) * consolidaciones_almacenes_lineas.articulo_unidades ) AS total_unidades ,
               consolidaciones_almacenes_lineas.articulo_codigo AS articulo_codigo,
               consolidaciones_almacenes.almacen_codigo AS almacen_codigo,
               consolidaciones_almacenes_lineas.ubicacion_codigo AS ubicacion_codigo,
               consolidaciones_almacenes_lineas.lote AS lote,
               consolidaciones_almacenes_lineas.combinaciones_uuid AS combinaciones_uuid,
               consolidaciones_almacenes.fecha_valor_stock AS fecha_valor_stock
            
            FROM %3$s AS consolidaciones_almacenes_lineas 

               INNER JOIN %2$s AS consolidaciones_almacenes
                  ON consolidaciones_almacenes.uuid = consolidaciones_almacenes_lineas.parent_uuid      

            WHERE consolidaciones_almacenes_lineas.articulo_codigo = articulo_codigo AND 
                  consolidaciones_almacenes.almacen_codigo = almacen_codigo AND 
                  consolidaciones_almacenes_lineas.ubicacion_codigo = ubicacion_codigo AND 
                  consolidaciones_almacenes_lineas.lote = lote AND 
                  consolidaciones_almacenes_lineas.deleted_at = 0 

            UNION 

            SELECT
               ( IFNULL( movimientos_almacenes_lineas.unidad_medicion_factor, 1 ) * movimientos_almacenes_lineas.articulo_unidades * -1 ) AS total_unidades ,
               movimientos_almacenes_lineas.articulo_codigo AS articulo_codigo,
               movimientos_almacenes.almacen_origen_codigo AS almacen_codigo,
               movimientos_almacenes_lineas.ubicacion_origen_codigo AS ubicacion_codigo,
               movimientos_almacenes_lineas.lote AS lote,
               movimientos_almacenes_lineas.combinaciones_uuid AS combinaciones_uuid,
               movimientos_almacenes.fecha_valor_stock AS fecha_valor_stock
            
            FROM %5$s AS movimientos_almacenes_lineas 

               INNER JOIN %4$s AS movimientos_almacenes
                  ON movimientos_almacenes.uuid = movimientos_almacenes_lineas.parent_uuid      

            WHERE movimientos_almacenes_lineas.articulo_codigo = articulo_codigo AND 
                  movimientos_almacenes.almacen_origen_codigo = almacen_codigo AND 
                  movimientos_almacenes_lineas.ubicacion_origen_codigo = ubicacion_codigo AND 
                  movimientos_almacenes_lineas.lote = lote AND 
                  movimientos_almacenes_lineas.deleted_at = 0  

            UNION

            SELECT
               ( IFNULL( movimientos_almacenes_lineas.unidad_medicion_factor, 1 ) * movimientos_almacenes_lineas.articulo_unidades ) AS total_unidades,
               movimientos_almacenes_lineas.articulo_codigo AS articulo_codigo,
               movimientos_almacenes.almacen_destino_codigo AS almacen_codigo,
               movimientos_almacenes_lineas.ubicacion_destino_codigo AS ubicacion_codigo,
               movimientos_almacenes_lineas.lote AS lote,
               movimientos_almacenes_lineas.combinaciones_uuid AS combinaciones_uuid,
               movimientos_almacenes.fecha_valor_stock AS fecha_valor_stock
            
            FROM %5$s AS movimientos_almacenes_lineas 

            INNER JOIN %4$s AS movimientos_almacenes
               ON movimientos_almacenes.uuid = movimientos_almacenes_lineas.parent_uuid  

            WHERE movimientos_almacenes_lineas.articulo_codigo = articulo_codigo AND 
                  movimientos_almacenes.almacen_destino_codigo = almacen_codigo AND 
                  movimientos_almacenes_lineas.ubicacion_destino_codigo = ubicacion_codigo AND 
                  movimientos_almacenes_lineas.lote = lote AND 
                  movimientos_almacenes_lineas.deleted_at = 0    

            UNION 

            %7$s

         ) 
         AS movimientos_union

            LEFT JOIN 
               (
                  SELECT 
                     consolidaciones_almacenes_lineas.articulo_codigo AS articulo_codigo, 
                     consolidaciones_almacenes.almacen_codigo,
                     consolidaciones_almacenes_lineas.ubicacion_codigo AS ubicacion_codigo,
                     consolidaciones_almacenes_lineas.lote AS lote,
                     consolidaciones_almacenes_lineas.combinaciones_uuid AS combinaciones_uuid,
                     IFNULL( consolidaciones_almacenes_lineas.unidad_medicion_factor, 1 ) * consolidaciones_almacenes_lineas.articulo_unidades AS total_unidades, 
                     consolidaciones_almacenes.fecha_valor_stock AS fecha_valor_stock

                  FROM %3$s AS consolidaciones_almacenes_lineas 

                  INNER JOIN %2$s AS consolidaciones_almacenes
                     ON consolidaciones_almacenes.uuid = consolidaciones_almacenes_lineas.parent_uuid      

                  WHERE consolidaciones_almacenes_lineas.articulo_codigo = articulo_codigo AND 
                        consolidaciones_almacenes.almacen_codigo = almacen_codigo AND
                        consolidaciones_almacenes_lineas.ubicacion_codigo = ubicacion_codigo AND 
                        consolidaciones_almacenes_lineas.lote = lote AND 
                        consolidaciones_almacenes_lineas.deleted_at = 0  

                  GROUP BY consolidaciones_almacenes_lineas.articulo_codigo, consolidaciones_almacenes.almacen_codigo, consolidaciones_almacenes_lineas.ubicacion_codigo, consolidaciones_almacenes_lineas.lote, consolidaciones_almacenes_lineas.combinaciones_uuid

                  ORDER BY consolidaciones_almacenes.fecha_valor_stock
                  
                  LIMIT 1
               ) 
               AS consolidaciones_almacenes

               ON movimientos_union.articulo_codigo = consolidaciones_almacenes.articulo_codigo AND
                  movimientos_union.almacen_codigo = consolidaciones_almacenes.almacen_codigo AND
                  movimientos_union.ubicacion_codigo = consolidaciones_almacenes.ubicacion_codigo AND
                  movimientos_union.lote = consolidaciones_almacenes.lote AND 
                  movimientos_union.combinaciones_uuid = consolidaciones_almacenes.combinaciones_uuid  

            WHERE

               movimientos_union.fecha_valor_stock >= consolidaciones_almacenes.fecha_valor_stock OR 
               consolidaciones_almacenes.fecha_valor_stock IS NULL
      )
      AS stocks;    

      RETURN TotalStock;

   END

   ENDTEXT

   cSql  := hb_strformat(  cSql,;
                           Company():getTableName( 'StockWhereCodigoAlmacenUbicacionLote' ),;
                           SQLConsolidacionesAlmacenesModel():getTableName(),;
                           SQLConsolidacionesAlmacenesLineasModel():getTableName(),;
                           SQLMovimientosAlmacenesModel():getTableName(),;
                           SQLMovimientosAlmacenesLineasModel():getTableName(),;
                           ::sqlAlbaranesComprasLineasLote(),;
                           ::sqlAlbaranesVentasLineasLote() )

RETURN ( alltrim( cSql ) )

//---------------------------------------------------------------------------//

METHOD selectStockWhereCodigoAlmacenLote( cCodigoArticulo, cCodigoAlmacen, cCodigoUbicacion, cLote, uuidCombinaciones ) CLASS StocksRepository

RETURN ( getSQLDatabase():getValue( "SELECT " + Company():getTableName( "StockWhereCodigoAlmacenUbicacionLote" ) + "( " + quoted( cCodigoArticulo ) + ", " + quoted( cCodigoAlmacen ) + ", " + quoted( cCodigoUbicacion ) + ", " + quoted( cLote ) + " )", 0 ) )

//---------------------------------------------------------------------------//

METHOD createFunctionStockWhereCodigoAlmacenCombinaciones() CLASS StocksRepository

   local cSql  

   TEXT INTO cSql

   CREATE DEFINER=`root`@`localhost` 
   FUNCTION %1$s ( `articulo_codigo` CHAR( 20 ), `almacen_codigo` CHAR( 20 ), `ubicacion_codigo` CHAR( 20 ), `lote` CHAR( 20 ), `combinaciones_uuid` CHAR( 40 ) )
   RETURNS DECIMAL( 19, 6 )
   LANGUAGE SQL
   NOT DETERMINISTIC
   CONTAINS SQL
   SQL SECURITY DEFINER
   COMMENT ''

   BEGIN

   DECLARE TotalStock DECIMAL( 19, 6 );

   SELECT 
      SUM( stocks.total_unidades ) INTO TotalStock

   FROM
      (

         SELECT 
            movimientos_union.total_unidades ,
            movimientos_union.articulo_codigo,
            movimientos_union.almacen_codigo,
            movimientos_union.ubicacion_codigo,
            movimientos_union.lote,
            movimientos_union.combinaciones_uuid,
            movimientos_union.fecha_valor_stock

         FROM
         (

            %6$s

            UNION 

            SELECT
               ( IFNULL( consolidaciones_almacenes_lineas.unidad_medicion_factor, 1 ) * consolidaciones_almacenes_lineas.articulo_unidades ) AS total_unidades ,
               consolidaciones_almacenes_lineas.articulo_codigo AS articulo_codigo,
               consolidaciones_almacenes.almacen_codigo AS almacen_codigo,
               consolidaciones_almacenes_lineas.ubicacion_codigo AS ubicacion_codigo,
               consolidaciones_almacenes_lineas.lote AS lote,
               consolidaciones_almacenes_lineas.combinaciones_uuid AS combinaciones_uuid,
               consolidaciones_almacenes.fecha_valor_stock AS fecha_valor_stock
            
            FROM %3$s AS consolidaciones_almacenes_lineas 

               INNER JOIN %2$s AS consolidaciones_almacenes
                  ON consolidaciones_almacenes.uuid = consolidaciones_almacenes_lineas.parent_uuid      

            WHERE consolidaciones_almacenes_lineas.articulo_codigo = articulo_codigo AND 
                  consolidaciones_almacenes.almacen_codigo = almacen_codigo AND 
                  consolidaciones_almacenes_lineas.ubicacion_codigo = ubicacion_codigo AND 
                  consolidaciones_almacenes_lineas.lote = lote AND 
                  consolidaciones_almacenes_lineas.combinaciones_uuid = combinaciones_uuid AND 
                  consolidaciones_almacenes_lineas.deleted_at = 0 

            UNION 

            SELECT
               ( IFNULL( movimientos_almacenes_lineas.unidad_medicion_factor, 1 ) * movimientos_almacenes_lineas.articulo_unidades * -1 ) AS total_unidades ,
               movimientos_almacenes_lineas.articulo_codigo AS articulo_codigo,
               movimientos_almacenes.almacen_origen_codigo AS almacen_codigo,
               movimientos_almacenes_lineas.ubicacion_origen_codigo AS ubicacion_codigo,
               movimientos_almacenes_lineas.lote AS lote,
               movimientos_almacenes_lineas.combinaciones_uuid AS combinaciones_uuid,
               movimientos_almacenes.fecha_valor_stock AS fecha_valor_stock
            
            FROM %5$s AS movimientos_almacenes_lineas 

               INNER JOIN %4$s AS movimientos_almacenes
                  ON movimientos_almacenes.uuid = movimientos_almacenes_lineas.parent_uuid      

            WHERE movimientos_almacenes_lineas.articulo_codigo = articulo_codigo AND 
                  movimientos_almacenes.almacen_origen_codigo = almacen_codigo AND 
                  movimientos_almacenes_lineas.ubicacion_origen_codigo = ubicacion_codigo AND 
                  movimientos_almacenes_lineas.lote = lote AND 
                  movimientos_almacenes_lineas.combinaciones_uuid = combinaciones_uuid AND 
                  movimientos_almacenes_lineas.deleted_at = 0  

            UNION

            SELECT
               ( IFNULL( movimientos_almacenes_lineas.unidad_medicion_factor, 1 ) * movimientos_almacenes_lineas.articulo_unidades ) AS total_unidades,
               movimientos_almacenes_lineas.articulo_codigo AS articulo_codigo,
               movimientos_almacenes.almacen_destino_codigo AS almacen_codigo,
               movimientos_almacenes_lineas.ubicacion_destino_codigo AS ubicacion_codigo,
               movimientos_almacenes_lineas.lote AS lote,
               movimientos_almacenes_lineas.combinaciones_uuid AS combinaciones_uuid,
               movimientos_almacenes.fecha_valor_stock AS fecha_valor_stock
            
            FROM %5$s AS movimientos_almacenes_lineas 

            INNER JOIN %4$s AS movimientos_almacenes
               ON movimientos_almacenes.uuid = movimientos_almacenes_lineas.parent_uuid  

            WHERE movimientos_almacenes_lineas.articulo_codigo = articulo_codigo AND 
                  movimientos_almacenes.almacen_destino_codigo = almacen_codigo AND 
                  movimientos_almacenes_lineas.ubicacion_destino_codigo = ubicacion_codigo AND 
                  movimientos_almacenes_lineas.lote = lote AND 
                  movimientos_almacenes_lineas.combinaciones_uuid = combinaciones_uuid AND 
                  movimientos_almacenes_lineas.deleted_at = 0    

            UNION 

            %7$s

         ) 
         AS movimientos_union

            LEFT JOIN 
               (
                  SELECT 
                     consolidaciones_almacenes_lineas.articulo_codigo AS articulo_codigo, 
                     consolidaciones_almacenes.almacen_codigo,
                     consolidaciones_almacenes_lineas.ubicacion_codigo AS ubicacion_codigo,
                     consolidaciones_almacenes_lineas.lote AS lote,
                     consolidaciones_almacenes_lineas.combinaciones_uuid AS combinaciones_uuid,
                     IFNULL( consolidaciones_almacenes_lineas.unidad_medicion_factor, 1 ) * consolidaciones_almacenes_lineas.articulo_unidades AS total_unidades, 
                     consolidaciones_almacenes.fecha_valor_stock AS fecha_valor_stock

                  FROM %3$s AS consolidaciones_almacenes_lineas 

                  INNER JOIN %2$s AS consolidaciones_almacenes
                     ON consolidaciones_almacenes.uuid = consolidaciones_almacenes_lineas.parent_uuid      

                  WHERE consolidaciones_almacenes_lineas.articulo_codigo = articulo_codigo AND 
                        consolidaciones_almacenes.almacen_codigo = almacen_codigo AND
                        consolidaciones_almacenes_lineas.ubicacion_codigo = ubicacion_codigo AND 
                        consolidaciones_almacenes_lineas.lote = lote AND 
                        consolidaciones_almacenes_lineas.combinaciones_uuid = combinaciones_uuid AND 
                        consolidaciones_almacenes_lineas.deleted_at = 0  

                  GROUP BY consolidaciones_almacenes_lineas.articulo_codigo, consolidaciones_almacenes.almacen_codigo, consolidaciones_almacenes_lineas.ubicacion_codigo, consolidaciones_almacenes_lineas.lote, consolidaciones_almacenes_lineas.combinaciones_uuid

                  ORDER BY consolidaciones_almacenes.fecha_valor_stock
                  
                  LIMIT 1
               ) 
               AS consolidaciones_almacenes

               ON movimientos_union.articulo_codigo = consolidaciones_almacenes.articulo_codigo AND
                  movimientos_union.almacen_codigo = consolidaciones_almacenes.almacen_codigo AND
                  movimientos_union.ubicacion_codigo = consolidaciones_almacenes.ubicacion_codigo AND
                  movimientos_union.lote = consolidaciones_almacenes.lote AND 
                  movimientos_union.combinaciones_uuid = consolidaciones_almacenes.combinaciones_uuid  

            WHERE

               movimientos_union.fecha_valor_stock >= consolidaciones_almacenes.fecha_valor_stock OR 
               consolidaciones_almacenes.fecha_valor_stock IS NULL
      )
      AS stocks;    

      RETURN TotalStock;

   END

   ENDTEXT

   cSql  := hb_strformat(  cSql,;
                           Company():getTableName( 'StockWhereCodigoAlmacenUbicacionLoteCombinaciones' ),;
                           SQLConsolidacionesAlmacenesModel():getTableName(),;
                           SQLConsolidacionesAlmacenesLineasModel():getTableName(),;
                           SQLMovimientosAlmacenesModel():getTableName(),;
                           SQLMovimientosAlmacenesLineasModel():getTableName(),;
                           ::sqlAlbaranesComprasLineasCombinaciones(),;
                           ::sqlAlbaranesVentasLineasCombinaciones() )

RETURN ( alltrim( cSql ) )

//---------------------------------------------------------------------------//

METHOD selectStockWhereCodigoAlmacenCombinaciones( cCodigoArticulo, cCodigoAlmacen, cCodigoUbicacion, cLote, uuidCombinaciones ) CLASS StocksRepository

RETURN ( getSQLDatabase():getValue( "SELECT " + Company():getTableName( "StockWhereCodigoAlmacenUbicacionLoteCombinaciones" ) + "( " + quoted( cCodigoArticulo ) + ", " + quoted( cCodigoAlmacen ) + ", " + quoted( cCodigoUbicacion ) + ", " + quoted( cLote ) + ", " + quotedUuid( uuidCombinaciones ) + " )", 0 ) )

//---------------------------------------------------------------------------//

#ifdef __TEST__

CLASS TestStocksRepository FROM TestOperacionesComercialesController

   DATA oTestArticulosController             

   DATA oTestConsolidacionAlmacenController  

   DATA oTestAlbaranesComprasController 

   DATA oTestAlbaranesVentasController 

   DATA oTestMovimientoAlmacenController     

   DATA aCategories                    INIT { "all", "stocks" }

   METHOD beforeClass()
   
   METHOD afterClass()
   
   METHOD Before() 

   METHOD test_calculo_stock_con_lote()
/*
   METHOD test_calculo_stock_con_caracteristicas() 
*/
END CLASS

//---------------------------------------------------------------------------//

METHOD Before() CLASS TestStocksRepository

   SQLConsolidacionesAlmacenesModel():truncateTable()

   SQLConsolidacionesAlmacenesLineasModel():truncateTable()

   SQLMovimientosAlmacenesModel():truncateTable()

   SQLMovimientosAlmacenesLineasModel():truncateTable()

   SQLAlbaranesComprasModel():truncateTable()

   SQLAlbaranesComprasLineasModel():truncateTable()
   
   SQLAlbaranesComprasDescuentosModel():truncateTable()

   SQLAlbaranesVentasModel():truncateTable()

   SQLAlbaranesVentasLineasModel():truncateTable()
   
   SQLAlbaranesVentasDescuentosModel():truncateTable()

RETURN ( ::Super:Before() )

//---------------------------------------------------------------------------//

METHOD beforeClass() CLASS TestStocksRepository
   
   Company():setDefaultUsarUbicaciones( .t. )

   ::oTestArticulosController             := TestArticulosController():New()

   ::oTestConsolidacionAlmacenController  := TestConsolidacionAlmacenController():New()

   ::oTestAlbaranesComprasController      := TestAlbaranesComprasController():New()
   
   ::oTestAlbaranesVentasController       := TestAlbaranesVentasController():New()

   ::oTestMovimientoAlmacenController     := TestMovimientoAlmacenController():New()    

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD afterClass() CLASS TestStocksRepository

   ::oTestArticulosController:End()
   
   ::oTestConsolidacionAlmacenController:End()

   ::oTestAlbaranesComprasController:End()

   ::oTestAlbaranesVentasController:End()

   ::oTestMovimientoAlmacenController:End()    

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_calculo_stock_con_lote() CLASS TestStocksRepository

   local nStock

   ::oTestConsolidacionAlmacenController:test_dialogo_articulo_con_lote()

   nStock   := StocksRepository():selectStockWhereCodigoAlmacenLote( '2', '0', '0', '1234' )

   ::Assert():equals( 1, nStock, "test comprobación de stocks por almacén en consolidacion" )

   ::oTestAlbaranesComprasController:test_dialogo_con_articulo_lote()

   nStock   := StocksRepository():selectStockWhereCodigoAlmacenLote( '2', '0', '0', '1234' )

   ::Assert():equals( 2, nStock, "test comprobación de stocks por almacén en albaranes de compras" )

   ::oTestMovimientoAlmacenController:test_dialogo_con_lote_dos_ubicacion()    

   nStock   := StocksRepository():selectStockWhereCodigoAlmacenLote( '2', '0', '0', '1234' )
   
   ::Assert():equals( 1, nStock, "test comprobación de stocks por almacén en movimientos de almacen" )

   ::oTestAlbaranesVentasController:test_dialogo_con_articulo_lote() 

   nStock   := StocksRepository():selectStockWhereCodigoAlmacenLote( '2', '0', '0', '1234' )
   
   ::Assert():equals( 0, nStock, "test comprobación de stocks por almacén en albaranes de ventas" )

RETURN ( nil )

//---------------------------------------------------------------------------//

/*
METHOD test_calculo_stock_con_caracteristicas() CLASS TestStocksRepository

   local nStock

   ::oTestArticulosController:test_dialog_append_con_caracteristicas()

   ::oTestConsolidacionAlmacenController:test_dialogo_articulo_con_lote()

   nStock   := StocksRepository():selectStockWhereCodigoAlmacenLote( '2', '0', '0', '1234' )

RETURN ( nil )
*/

//---------------------------------------------------------------------------//

