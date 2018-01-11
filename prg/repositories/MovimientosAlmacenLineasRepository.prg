#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Hdo.ch"

//---------------------------------------------------------------------------//

CLASS MovimientosAlmacenLineasRepository FROM SQLBaseRepository

   METHOD getTableName()         INLINE ( SQLMovimientosAlmacenLineasModel():getTableName() ) 

   METHOD getSQLSentenceFechaCaducidad( cCodigoArticulo, cValorPrimeraPropiedad, cValorSegundaPropiedad, cLote )

   METHOD getSQLSentenceArticuloUuid( cCodigoArticulo, uuid )

   METHOD getHashArticuloUuid( cCodigoArticulo, uuid ) ;
                                 INLINE ( getSQLDataBase():selectFetchHash( ::getSQLSentenceArticuloUuid( cCodigoArticulo, uuid ) ) )

   METHOD getSQLSentenceWhereParentUuid( uuid )

   METHOD getSerializedColumnsSentenceToLabels()

   METHOD getSQLSentenceToLabels( initialId, finalId )

   METHOD getSQLSentenceFechaHoraConsolidacion( cCodigoArticulo, cCodigoAlmacen, cCodigoPrimeraPropiedad, cCodigoSegundaPropiedad, cValorPrimeraPropiedad, cValorSegundaPropiedad, cLote, dFecha, tHora )

   METHOD getSqlSentenceIdByUuid( uuid ) 

   METHOD getIdByUuid( nNumber )  INLINE ( getSQLDataBase():selectValue( ::getSqlSentenceIdByUuid( nNumber ) ) )

   METHOD getFechaHoraConsolidacion( cCodigoArticulo, cCodigoAlmacen, cValorPropiedad1, cValorPropiedad2, cLote )

   METHOD getTotalUnidadesStock( tConsolidacion, cCodigoArticulo, cCodigoAlmacen, cValorPropiedad1, cValorPropiedad2, cLote )

   METHOD getTotalUnidadesEntrada( tConsolidacion, cCodigoArticulo, cCodigoAlmacen, cValorPropiedad1, cValorPropiedad2, cLote ) ; 
      INLINE ( ::getTotalUnidades( tConsolidacion, cCodigoArticulo, cCodigoAlmacen, cValorPropiedad1, cValorPropiedad2, cLote, .t. ) )

   METHOD getTotalUnidadesSalida( tConsolidacion, cCodigoArticulo, cCodigoAlmacen, cValorPropiedad1, cValorPropiedad2, cLote ) ;
      INLINE ( ::getTotalUnidades( tConsolidacion, cCodigoArticulo, cCodigoAlmacen, cValorPropiedad1, cValorPropiedad2, cLote, .f. ) )

   METHOD getTotalUnidades( tConsolidacion, cCodigoArticulo, cCodigoAlmacen, cValorPropiedad1, cValorPropiedad2, cLote, lEntrada )

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

METHOD getSQLSentenceArticuloUuid( cCodigoArticulo, uuid )

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

METHOD getSQLSentenceToLabels( aIds, nFixLabels, cOrderBy )

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
                  "WHERE movimientos_almacen.id IN ( "  

   aEval( aIds, {|nId| cSql += quoted( nId ) + "," } )

   cSql        := chgAtEnd( cSql, " ) ", 1 )

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

METHOD getSqlSentenceIdByUuid( uuid ) 

   local cSql  := "SELECT id FROM " + ::getTableName() + " " 

   cSql        +=    "WHERE uuid = " + quoted( uuid ) 

RETURN ( cSql )

//---------------------------------------------------------------------------//

METHOD getFechaHoraConsolidacion( cCodigoArticulo, cCodigoAlmacen, cValorPropiedad1, cValorPropiedad2, cLote )

   local aBuffer
   local hResult     := { => }
   local cSql        := "SELECT   movimientos_almacen.id, "
         cSql        +=                   "movimientos_almacen.fecha_hora, "
         cSql        +=                   "movimientos_almacen.almacen_destino, "
         cSql        +=                   "movimientos_almacen.tipo_movimiento, "
         cSql        +=                   "movimientos_almacen_lineas.parent_uuid, "
         cSql        +=                   "movimientos_almacen_lineas.codigo_articulo, "
         cSql        +=                   "movimientos_almacen_lineas.valor_primera_propiedad, "
         cSql        +=                   "movimientos_almacen_lineas.valor_segunda_propiedad, "
         cSql        +=                   "movimientos_almacen_lineas.lote "
         cSql        +=          "FROM     movimientos_almacen "
         cSql        +=          "INNER JOIN movimientos_almacen_lineas "
         cSql        +=                   "ON movimientos_almacen_lineas.parent_uuid = movimientos_almacen.uuid " 
         cSql        +=          "WHERE    movimientos_almacen.almacen_destino = " + quoted( cCodigoAlmacen ) + " AND "
         cSql        +=                   "movimientos_almacen.tipo_movimiento = '4' AND "
         cSql        +=                   "movimientos_almacen_lineas.codigo_articulo = " + quoted( cCodigoArticulo ) + " AND "
         cSql        +=                   "movimientos_almacen_lineas.valor_primera_propiedad = " + quoted( cValorPropiedad1 ) + " AND "
         cSql        +=                   "movimientos_almacen_lineas.valor_segunda_propiedad = " + quoted( cValorPropiedad2 ) + " AND "
         cSql        +=                   "movimientos_almacen_lineas.lote = " + quoted( cLote ) + " "
         cSql        +=          "ORDER BY movimientos_almacen.fecha_hora DESC "
         cSql        +=          "LIMIT 1"

   aBuffer           := ::getDatabase():selectFetchHash( cSql )

   if hb_isArray( aBuffer ) .and. len( aBuffer ) > 0

      hResult        := { "fecha" => hb_TtoD( hGet( aBuffer[1], "fecha_hora" ) ),;
                          "hora" => SubStr( hb_TSToStr( hGet( aBuffer[1], "fecha_hora" ) ), 12, 8 ),;
                          "fecha_hora" => hGet( aBuffer[1], "fecha_hora" ) }

   end if

RETURN ( hResult )

//---------------------------------------------------------------------------//

METHOD getTotalUnidadesStock( tConsolidacion, cCodigoArticulo, cCodigoAlmacen, cValorPropiedad1, cValorPropiedad2, cLote )
   
   local nEntrada    := ::getTotalUnidadesEntrada( tConsolidacion, cCodigoArticulo, cCodigoAlmacen, cValorPropiedad1, cValorPropiedad2, cLote )
   local nSalida     := ::getTotalUnidadesSalida( tConsolidacion, cCodigoArticulo, cCodigoAlmacen, cValorPropiedad1, cValorPropiedad2, cLote )

RETURN ( nEntrada - nSalida )

//---------------------------------------------------------------------------//

METHOD getTotalUnidades( tConsolidacion, cCodigoArticulo, cCodigoAlmacen, cValorPropiedad1, cValorPropiedad2, cLote, lEntrada )

   local nTotal      := 0
   local aBuffer
   local cSentence

   cSentence         := "SELECT   movimientos_almacen.id, "
   cSentence         +=          "movimientos_almacen.fecha_hora, "
   cSentence         +=          "movimientos_almacen.almacen_destino, "
   cSentence         +=          "movimientos_almacen.almacen_origen, "
   cSentence         +=          "movimientos_almacen_lineas.parent_uuid, "
   cSentence         +=          "movimientos_almacen_lineas.codigo_articulo, "
   cSentence         +=          "movimientos_almacen_lineas.valor_primera_propiedad, "
   cSentence         +=          "movimientos_almacen_lineas.valor_segunda_propiedad, "
   cSentence         +=          "movimientos_almacen_lineas.lote, "
   cSentence         +=          "movimientos_almacen_lineas.cajas_articulo, "
   cSentence         +=          "movimientos_almacen_lineas.unidades_articulo, "
   cSentence         +=          "SUM( IF( movimientos_almacen_lineas.cajas_articulo = 0, 1, movimientos_almacen_lineas.cajas_articulo ) * movimientos_almacen_lineas.unidades_articulo ) as totalUnidadesStock "
   cSentence         += "FROM    movimientos_almacen "
   cSentence         += "INNER JOIN movimientos_almacen_lineas "
   cSentence         += "ON      movimientos_almacen_lineas.parent_uuid = movimientos_almacen.uuid "
   
   if lEntrada
      cSentence      += "WHERE   movimientos_almacen.almacen_destino = " + quoted( cCodigoAlmacen ) + " AND "
   else
      cSentence      += "WHERE   movimientos_almacen.almacen_origen = " + quoted( cCodigoAlmacen ) + " AND "
   end if
   
   if !Empty( tConsolidacion )
      cSentence      +=         "movimientos_almacen.fecha_hora >= " + quoted( hb_TSToStr( tConsolidacion ) ) + " AND "
   end if

   cSentence         +=         "movimientos_almacen_lineas.codigo_articulo = " + quoted( cCodigoArticulo ) + " AND "
   cSentence         +=         "movimientos_almacen_lineas.valor_primera_propiedad = " + quoted( cValorPropiedad1 ) + " AND "
   cSentence         +=         "movimientos_almacen_lineas.valor_segunda_propiedad = " + quoted( cValorPropiedad2 ) + " AND "
   cSentence         +=         "movimientos_almacen_lineas.lote = " + quoted( cLote ) + " "
   cSentence         += "LIMIT 1"

   aBuffer           := ::getDatabase():selectFetchHash( cSentence )

   if !hb_isnil( aBuffer )
      nTotal         := hGet( aBuffer[1], "totalUnidadesStock" )
   end if

RETURN ( nTotal )

//---------------------------------------------------------------------------//