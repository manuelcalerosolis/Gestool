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

   METHOD getSQLSentenceWhereParentUuid( uuid )

   METHOD getSerializedColumnsSentenceToLabels()

   METHOD getSQLSentenceToLabels( initialId, finalId )

   METHOD getSQLSentenceFechaHoraConsolidacion( cCodigoArticulo, cCodigoAlmacen, cCodigoPrimeraPropiedad, cCodigoSegundaPropiedad, cValorPrimeraPropiedad, cValorSegundaPropiedad, cLote, dFecha, tHora )

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

   local cSql  := "SELECT * FROM " + ::getTableName() + " "   + ;
                     "WHERE parent_uuid = " + quoted( uuid )

RETURN ( cSql )

//---------------------------------------------------------------------------//

METHOD getSerializedColumnsSentenceToLabels()

   local cSerializedColumns   := "id;"                         + ;
                                 "codigo_articulo;"            + ;
                                 "nombre_articulo;"            + ;
                                 "codigo_primera_propiedad;"   + ;
                                 "codigo_segunda_propiedad;"   + ;
                                 "valor_primera_propiedad;"    + ;
                                 "valor_segunda_propiedad"      

RETURN ( cSerializedColumns )                                 

//---------------------------------------------------------------------------//

METHOD getSQLSentenceToLabels( initialId, finalId, nFixLabels, cOrderBy )

   local cSql  := "SELECT "                                                                              + ;
                     "movimientos_almacen_lineas.id AS id, "                                             + ;
                     "movimientos_almacen_lineas.codigo_articulo AS codigo_articulo, "                   + ;
                     "movimientos_almacen_lineas.nombre_articulo AS nombre_articulo, "                   + ;
                     "movimientos_almacen_lineas.codigo_primera_propiedad AS codigo_primera_propiedad, " + ;
                     "movimientos_almacen_lineas.codigo_segunda_propiedad AS codigo_segunda_propiedad, " + ;     
                     "movimientos_almacen_lineas.valor_primera_propiedad AS valor_primera_propiedad, "   + ;
                     "movimientos_almacen_lineas.valor_segunda_propiedad AS valor_segunda_propiedad, "      

   if empty( nFixLabels )
      cSql     +=    "IF ( movimientos_almacen_lineas.cajas_articulo = 0, 1, movimientos_almacen_lineas.cajas_articulo ) * movimientos_almacen_lineas.unidades_articulo AS total_unidades "  
   else
      cSql     +=    toSqlString( nFixLabels ) + " AS total_unidades "  
   end if 

   cSql        += "FROM movimientos_almacen_lineas "                             + ;
                     "INNER JOIN movimientos_almacen ON movimientos_almacen_lineas.parent_uuid = movimientos_almacen.uuid "   + ;
                  "WHERE movimientos_almacen.id BETWEEN " + toSqlString( initialId ) + " AND " + toSqlString( finalId ) + " "

   if !empty( cOrderBy )                  
      cSql     += "ORDER BY " + ( cOrderBy ) 
   end if 

RETURN ( cSql )

//---------------------------------------------------------------------------//

METHOD getSQLSentenceFechaHoraConsolidacion( cCodigoArticulo, cCodigoAlmacen, cCodigoPrimeraPropiedad, cCodigoSegundaPropiedad, cValorPrimeraPropiedad, cValorSegundaPropiedad, cLote, dFecha, tHora )

   local cSql  := "SELECT "                                                                              + ;
                     "cabecera.fecha_hora "                                                              + ;
                  "FROM movimientos_almacen_lineas lineas "                                              + ;
                     "INNER JOIN movimientos_almacen cabecera ON lineas.parent_uuid = cabecera.uuid "    + ;
                  "WHERE lineas.codigo_articulo = " + quoted( cCodigoArticulo ) + " "                    + ;
                     "AND cabecera.tipo_movimiento = 4 "                                                 

   if !empty(cCodigoAlmacen)
      cSql     +=    "AND cabecera.almacen_destino = " + quoted( cCodigoAlmacen ) + " "                   
   end if 

   if !empty(cCodigoPrimeraPropiedad)
      cSql     +=    "AND lineas.codigo_primera_propiedad = " + quoted( cCodigoPrimeraPropiedad ) + " "   
   end if 

   if !empty(cCodigoSegundaPropiedad)
      cSql     +=    "AND lineas.codigo_segunda_propiedad = " + quoted( cCodigoSegundaPropiedad ) + " "   
   end if 

   if !empty(cValorPrimeraPropiedad)
      cSql     +=    "AND lineas.valor_primera_propiedad = " + quoted( cValorPrimeraPropiedad ) + " "   
   end if 

   if !empty(cValorSegundaPropiedad)
      cSql     +=    "AND lineas.valor_segunda_propiedad = " + quoted( cValorSegundaPropiedad ) + " "   
   end if 

   if !empty(cLote)
      cSql     +=    "AND lineas.lote = " + quoted( cLote ) + " "
   end if 

   cSql        += "ORDER BY cabecera.fecha_hora "                                                        + ;
                     "LIMIT 1"

RETURN ( cSql )

//---------------------------------------------------------------------------//
