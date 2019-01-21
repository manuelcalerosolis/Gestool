#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Hdo.ch"

//---------------------------------------------------------------------------//

CLASS StocksRepository FROM SQLBaseRepository

   METHOD getSQLFunctions()            INLINE ( {  ::dropFunctionStockWhereCodigo(),;
                                                   ::createFunctionStockWhereCodigo() } )

   METHOD dropFunctionStockWhereCodigo() ;
                                       INLINE ( "DROP FUNCTION IF EXISTS " + Company():getTableName( 'StockWhereCodigo' ) + ";" )

   METHOD createFunctionStockWhereCodigo()

END CLASS

//---------------------------------------------------------------------------//

METHOD createFunctionStockWhereCodigo() CLASS StocksRepository

   local cSql

   TEXT INTO cSql

   CREATE DEFINER=`root`@`localhost` 
   FUNCTION %1$s ( `articulo_codigo` CHAR( 40 ) )
   RETURNS DECIMAL( 19, 6 )
   LANGUAGE SQL
   NOT DETERMINISTIC
   CONTAINS SQL
   SQL SECURITY DEFINER
   COMMENT ''

   BEGIN

      DECLARE TotalStock DECIMAL( 19, 6 );

   SELECT
       + IFNULL( movimientos_almacenes_lineas.unidad_medicion_factor, 1 ) * movimientos_almacenes_lineas.articulo_unidades AS total_unidades, 

   FROM %7$s AS movimientos_almacenes_lineas 

      INNER JOIN %6$s AS movimientos_almacenes
         ON movimientos_almacenes.UUID = movimientos_almacenes_lineas.parent_uuid      

      INNER JOIN 
         (
            SELECT 
               consolidaciones_almacenes_lineas.articulo_codigo AS articulo_codigo, 
               almacenes.almacen_codigo AS almacen_codigo,
               consolidaciones_almacenes_lineas.ubicacion_codigo AS ubicacion_codigo,
               consolidaciones_almacenes_lineas.lote AS lote,
               consolidaciones_almacenes_lineas.combinaciones_uuid AS combinaciones_uuid,
               IFNULL( consolidaciones_almacenes_lineas.unidad_medicion_factor, 1 ) * consolidaciones_almacenes_lineas.articulo_unidades AS total_unidades, 
               consolidaciones_almacenes.fecha_valor_stock AS fecha_valor_stock

            FROM %2$s AS consolidaciones_almacenes_lineas 

            INNER JOIN %3$s AS consolidaciones_almacenes
               ON consolidaciones_almacenes.UUID = consolidaciones_almacenes_lineas.parent_uuid      

            INNER JOIN %4$s AS almacenes
               ON almacenes.codigo = consolidaciones_almacenes.almacen_codigo
               
            GROUP BY consolidaciones_almacenes_lineas.articulo_codigo, almacenes.codigo, consolidaciones_almacenes_lineas.ubicacion_codigo, consolidaciones_almacenes_lineas.lote, consolidaciones_almacenes_lineas.combinaciones_uuid

            ORDER BY consolidaciones_almacenes.fecha_valor_stock
            
            LIMIT 1;
         ) 
            AS consolidaciones_almacenes
         ON movimientos_almacenes_lineas.articulo_codigo = consolidaciones_almacenes.articulo_codigo  AND
            (  movimientos_almacenes.almacen_origen = consolidaciones_almacenes.almacen_codigo OR 
               movimientos_almacenes.almacen_destino = consolidaciones_almacenes.almacen_codigo ) AND
            (  movimientos_almacenes_lineas.ubicacion_origen_codigo = consolidaciones_almacenes.ubicacion_codigo OR 
               movimientos_almacenes_lineas.ubicacion_destino_codigo = consolidaciones_almacenes.ubicacion_codigo ) AND
            movimientos_almacenes_lineas.lote = consolidaciones_almacenes.lote AND 
            movimientos_almacenes_lineas.combinaciones_uuid = consolidaciones_almacenes.combinaciones_uuid  

      WHERE

         movimientos_almacenes.fecha_valor_stock > consolidaciones_almacenes.fecha_valor_stock OR consolidaciones_almacenes.fecha_valor_stock IS NULL
       
      RETURN TotalStock;

   END

   ENDTEXT

   cSql  := hb_strformat( cSql, Company():getTableName( 'StockWhereCodigo' ), SQLConsolidacionesAlmacenesLineasModel():getTableName(), SQLConsolidacionesAlmacenesModel():getTableName(), SQLAlmacenesModel():getTableName() )

RETURN ( alltrim( cSql ) )

//---------------------------------------------------------------------------//
/*
   SELECT 
      movimientos_almacenes.almacen_origen_codigo, 
      movimientos_almacenes_lineas.articulo_unidades * movimientos_almacenes_lineas.unidad_medicion_factor * -1
         
      FROM gestool_0001.movimientos_almacenes_lineas

      INNER JOIN gestool_0001.movimientos_almacenes AS movimientos_almacenes
         ON movimientos_almacenes.UUID = movimientos_almacenes_lineas.parent_uuid      

   GROUP BY movimientos_almacenes_lineas.articulo_codigo, almacenes.codigo, movimientos_almacenes_lineas.ubicacion_codigo, movimientos_almacenes_lineas.lote, movimientos_almacenes_lineas.combinaciones_uuid

   ORDER BY movimientos_almacenes.fecha_valor_stock
   
   UNION 
   
   SELECT 
      movimientos_almacenes.almacen_destino_codigo, 
      movimientos_almacenes_lineas.articulo_unidades * movimientos_almacenes_lineas.unidad_medicion_factor 
         
      FROM gestool_0001.movimientos_almacenes_lineas

      INNER JOIN gestool_0001.movimientos_almacenes AS movimientos_almacenes
         ON movimientos_almacenes.UUID = movimientos_almacenes_lineas.parent_uuid      

   GROUP BY movimientos_almacenes_lineas.articulo_codigo, almacenes.codigo, movimientos_almacenes_lineas.ubicacion_codigo, movimientos_almacenes_lineas.lote, movimientos_almacenes_lineas.combinaciones_uuid

   ORDER BY movimientos_almacenes.fecha_valor_stock
*/