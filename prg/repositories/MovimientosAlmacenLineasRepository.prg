#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Hdo.ch"

//---------------------------------------------------------------------------//

CLASS MovimientosAlmacenLineasRepository FROM SQLBaseRepository

   METHOD getTableName()         INLINE ( SQLMovimientosAlmacenLineasModel():getTableName() ) 

   METHOD getSQLSentenceFechaCaducidad( cCodigoArticulo, cValorPrimeraPropiedad, cValorSegundaPropiedad, cLote )

   METHOD getSQLSentenceArticuloUuid( cCodigoArticulo, Uuid )

   METHOD getHashArticuloUuid( cCodigoArticulo, Uuid ) ;
                                 INLINE ( getSQLDataBase():selectFetchHash( ::getSQLSentenceArticuloUuid( cCodigoArticulo, Uuid ) ) )

   METHOD getSqlSentenceWhereParentUuid( uuid )

   METHOD getSQLSentenceToLabels( initialId, finalId )

END CLASS

//---------------------------------------------------------------------------//

METHOD getSQLSentenceFechaCaducidad( cCodigoArticulo, cValorPrimeraPropiedad, cValorSegundaPropiedad, cLote )

   local cSql  := "SELECT "                                                      + ;
                     "fecha_caducidad "                                          + ;
                  "FROM " + ::getTableName() + " "                               + ;
                  "WHERE codigo_articulo = " + quoted( cCodigoArticulo ) + " "   + ;
                     "AND fecha_caducidad IS NOT NULL "       

   if !empty(cValorPrimeraPropiedad)
      cSql     +=    "AND valor_primera_propiedad = " + quoted( cValorPrimeraPropiedad ) + " "   
   end if 

   if !empty(cValorSegundaPropiedad)
      cSql     +=    "AND valor_segunda_propiedad = " + quoted( cValorSegundaPropiedad ) + " "   
   end if 

   if !empty(cLote)
      cSql     +=    "AND lote = " + quoted( cLote ) + " "
   end if 

RETURN ( cSql )

//---------------------------------------------------------------------------//

METHOD getSQLSentenceArticuloUuid( cCodigoArticulo, Uuid )

   local cSql  := "SELECT * "                                                    + ;
                  "FROM " + ::getTableName() + " "                               + ;
                  "WHERE codigo_articulo = " + quoted( cCodigoArticulo ) + " "   + ;
                     "AND parent_uuid = " + quoted( uuid )

RETURN ( cSql )

//---------------------------------------------------------------------------//

METHOD getSqlSentenceWhereParentUuid( uuid )

   local cSql  := "SELECT * FROM " + ::getTableName() + " "                      + ;
                     "WHERE parent_uuid = " + quoted( uuid )

RETURN ( cSql )

//---------------------------------------------------------------------------//

METHOD getSQLSentenceToLabels( initialId, finalId, nFixLabels, cOrderBy )

   local cSql  := "SELECT "                                                      + ;
                     "TRUE AS selected, "                                        + ;
                     "movimientos_almacen_lineas.id, "                           + ;
                     "movimientos_almacen_lineas.codigo_articulo, "              + ;
                     "movimientos_almacen_lineas.nombre_articulo, "              + ;
                     "movimientos_almacen_lineas.valor_primera_propiedad, "      + ;
                     "movimientos_almacen_lineas.valor_segunda_propiedad, "      

   if empty( nFixLabels )
      cSql     +=    "IF ( movimientos_almacen_lineas.cajas_articulo = 0, 1, movimientos_almacen_lineas.cajas_articulo ) * movimientos_almacen_lineas.unidades_articulo AS total_unidades "  
   else
      cSql     +=    toSqlString( nFixLabels ) + " AS total_unidades "  
   end if 

   cSql        += "FROM movimientos_almacen_lineas "                             + ;
                     "INNER JOIN movimientos_almacen ON movimientos_almacen_lineas.parent_uuid = movimientos_almacen.uuid "   + ;
                  "WHERE movimientos_almacen.id BETWEEN " + toSqlString( initialId ) + " AND " + toSqlString( finalId )

   if !empty( cOrderBy )                  
      cSql     += "ORDER BY " + quoted( cOrderBy ) 
   end if 

   msgalert( cSql, "cSql" )

RETURN ( cSql )

//---------------------------------------------------------------------------//
