#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS ConsolidacionesAlmacenesRepository FROM SQLBaseRepository

   METHOD getPackage( cContext )       INLINE ( SQLConsolidacionAlmacenModel():getPackage( cContext ) )

   METHOD getSQLFunctions()            INLINE ( {  ::dropFunctionTotalSummaryWhereUuid(),;
                                                   ::createFunctionTotalSummaryWhereUuid() } )

   METHOD createFunctionTotalSummaryWhereUuid()
      METHOD dropFunctionTotalSummaryWhereUuid()
      METHOD selectTotalSummaryWhereUuid( uuidOperacion )

   METHOD getMailWhereOperacionUuid( uuidFactura ) 

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

METHOD createFunctionTotalSummaryWhereUuid() CLASS ConsolidacionesAlmacenesRepository

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
         SUM( ROUND( ( lineas.articulo_unidades * lineas.unidad_medicion_factor ) * ( lineas.articulo_precio + lineas.incremento_precio ), 2 ) ) INTO TotalSummary
      FROM 
         ( %2$s ) AS lineas
      WHERE 
         lineas.parent_uuid = uuid_operacion_comercial AND lineas.deleted_at = 0;
      
      RETURN TotalSummary;

   END

   ENDTEXT

   cSql  := hb_strformat( cSql, Company():getTableName( ::getPackage( 'TotalSummaryWhereUuid' ) ), SQLConsolidacionesAlmacenesLineasModel():getTableName() )

RETURN ( alltrim( cSql ) )

//---------------------------------------------------------------------------//

METHOD dropFunctionTotalSummaryWhereUuid() CLASS ConsolidacionesAlmacenesRepository  

RETURN ( "DROP FUNCTION IF EXISTS " + Company():getTableName( ::getPackage( 'TotalSummaryWhereUuid' ) ) + ";" )

//---------------------------------------------------------------------------//

METHOD selectTotalSummaryWhereUuid( uuidOperacion ) CLASS ConsolidacionesAlmacenesRepository

RETURN ( getSQLDatabase():Exec( "SELECT " + Company():getTableName( ::getPackage( 'TotalSummaryWhereUuid' ) ) + "( " + quotedUuid( uuidOperacion ) + " )" ) )

//---------------------------------------------------------------------------//

