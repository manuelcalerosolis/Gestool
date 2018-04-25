#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Hdo.ch"

//---------------------------------------------------------------------------//

CLASS MovimientosAlmacenLineasRepository FROM SQLBaseRepository

   METHOD getTableName()         INLINE ( SQLMovimientosAlmacenLineasModel():getTableName() ) 

   METHOD getSQLSentenceFechaCaducidad( cCodigoArticulo, cValorPrimeraPropiedad, cValorSegundaPropiedad, cLote )

   METHOD getSQLSentenceArticuloUuid( cCodigoArticulo, uuid )
   
   METHOD getSQLSentenceWhereParentUuid( uuid )

   METHOD getHashArticuloUuid( cCodigoArticulo, uuid ) ;
                                 INLINE ( getSQLDataBase():selectFetchHash( ::getSQLSentenceArticuloUuid( cCodigoArticulo, uuid ) ) )

   METHOD getSerializedColumnsSentenceToLabels()

   METHOD getSQLSentenceToLabels( initialId, finalId )

   METHOD getSQLSentenceIdByUuid( uuid ) 

   METHOD getIdByUuid( nNumber )  INLINE ( getSQLDataBase():getValue( ::getSqlSentenceIdByUuid( nNumber ) ) )

   METHOD getSQLSentenceTotalUnidades()

   METHOD getSQLSentenceFechaHoraConsolidacion()
   METHOD getFechaHoraConsolidacion()
   METHOD getHashFechaHoraConsolidacion()

   METHOD getTotalUnidadesStock( tConsolidacion, cCodigoArticulo, cCodigoAlmacen, cValorPropiedad1, cValorPropiedad2, cLote )

   METHOD getTotalUnidadesEntrada( tConsolidacion, cCodigoArticulo, cCodigoAlmacen, cValorPropiedad1, cValorPropiedad2, cLote ) ; 
                                 INLINE ( ::getTotalUnidades( tConsolidacion, cCodigoArticulo, cCodigoAlmacen, cValorPropiedad1, cValorPropiedad2, cLote, .t. ) )

   METHOD getTotalUnidadesSalida( tConsolidacion, cCodigoArticulo, cCodigoAlmacen, cValorPropiedad1, cValorPropiedad2, cLote ) ;
                                 INLINE ( ::getTotalUnidades( tConsolidacion, cCodigoArticulo, cCodigoAlmacen, cValorPropiedad1, cValorPropiedad2, cLote, .f. ) )

   METHOD getTotalUnidades( tConsolidacion, cCodigoArticulo, cCodigoAlmacen, cValorPropiedad1, cValorPropiedad2, cLote, lEntrada )

   METHOD getSQLSentenceMovimientosAlmacenForReport( oReporting )

   METHOD getRowSetMovimientosAlmacenForReport( oReporting )

   METHOD getRowSetMovimientosForArticulo()

   METHOD getSqlSentenceMovimientosForArticulo()

   METHOD getIdFromBuffer( hBuffer ) ;
                                 INLINE ( getSQLDataBase():selectFetchHash( ::getSQLSentenceIdFromBuffer( hBuffer ) ) )

   METHOD getSQLSentenceIdFromBuffer( hBuffer )

END CLASS

//---------------------------------------------------------------------------//

METHOD getSQLSentenceFechaCaducidad( cCodigoArticulo, cValorPrimeraPropiedad, cValorSegundaPropiedad, cLote )

   local cSql  := "SELECT "                                       
      cSql     +=    "movimientos_almacen_lineas.fecha_caducidad "
      cSql     += "FROM " + ::getTableName() + " "
      cSql     +=    "INNER JOIN movimientos_almacen ON movimientos_almacen_lineas.parent_uuid = movimientos_almacen.uuid " 
      cSql     += "WHERE movimientos_almacen.empresa = " + quoted( cCodEmp() ) + " "                    
      cSql     +=    "AND movimientos_almacen_lineas.codigo_articulo = " + quoted( cCodigoArticulo ) + " " 
      cSql     +=    "AND movimientos_almacen_lineas.fecha_caducidad IS NOT NULL "       

   if !empty(cValorPrimeraPropiedad)
      cSql     +=    "AND movimientos_almacen_lineas.valor_primera_propiedad = " + quoted( cValorPrimeraPropiedad ) + " "   
   end if 

   if !empty(cValorSegundaPropiedad)
      cSql     +=    "AND movimientos_almacen_lineas.valor_segunda_propiedad = " + quoted( cValorSegundaPropiedad ) + " "   
   end if 

   if !empty(cLote)
      cSql     +=    "AND movimientos_almacen_lineas.lote = " + quoted( cLote ) + " "
   end if 

RETURN ( cSql )

//---------------------------------------------------------------------------//

METHOD getSQLSentenceArticuloUuid( cCodigoArticulo, cParentUuid )

   local cSql  := "SELECT * "                                                    + ;
                  "FROM " + ::getTableName() + " "                               + ;
                  "WHERE codigo_articulo = " + quoted( cCodigoArticulo ) + " "   + ;
                     "AND parent_uuid = " + quoted( cParentUuid )

RETURN ( cSql )

//---------------------------------------------------------------------------//

METHOD getSQLSentenceWhereParentUuid( cParentUuid )

   local cSql  := "SELECT * FROM " + ::getTableName()                            + " " +  ;
                     "WHERE parent_uuid = " + quoted( cParentUuid )              + " " +  ;
                     "ORDER BY id"

RETURN ( cSql )

//---------------------------------------------------------------------------//

METHOD getSQLSentenceIdFromBuffer( hBuffer )

   local cSql  := "SELECT id FROM " + ::getTableName()                                                            + " " + ;
                  "WHERE codigo_articulo = "             + quoted( hget( hBuffer, "codigo_articulo" ) )           + " " + ;
                     "AND parent_uuid = "                + quoted( hget( hBuffer, "parent_uuid" ) )               + " " + ;
                     "AND codigo_primera_propiedad = "   + quoted( hget( hBuffer, "codigo_primera_propiedad" ) )  + " " + ;
                     "AND codigo_segunda_propiedad = "   + quoted( hget( hBuffer, "codigo_segunda_propiedad" ) )  + " " + ;
                     "AND valor_primera_propiedad = "    + quoted( hget( hBuffer, "valor_primera_propiedad" ) )   + " " + ;
                     "AND valor_segunda_propiedad = "    + quoted( hget( hBuffer, "valor_segunda_propiedad" ) )   + " " + ;
                     "AND lote = "                       + quoted( hget( hBuffer, "lote" ) )                      + " " + ;
                     "AND precio_articulo = "            + toSqlString( hget( hBuffer, "precio_articulo" ) )      + " " + ;
                     "LIMIT 1"

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
      cSql     +=    SQLMovimientosAlmacenLineasModel():getSQLSubSentenceTotalUnidadesLinea()
   else
      cSql     +=    toSqlString( nFixLabels ) + " AS total_unidades "  
   end if 

   cSql        += "FROM movimientos_almacen_lineas "                                                     + ;
                     "INNER JOIN movimientos_almacen ON movimientos_almacen_lineas.parent_uuid = movimientos_almacen.uuid " + ;
                  "WHERE movimientos_almacen.id IN ( "  

   aeval( aIds, {|nId| cSql += quoted( nId ) + "," } )

   cSql        := chgAtEnd( cSql, " ) ", 1 )

   if !empty( cOrderBy )                  
      cSql     += "ORDER BY " + ( cOrderBy ) 
   end if 

RETURN ( cSql )

//---------------------------------------------------------------------------//

METHOD getSQLSentenceFechaHoraConsolidacion( cCodigoArticulo, cCodigoAlmacen, cCodigoPrimeraPropiedad, cCodigoSegundaPropiedad, cValorPrimeraPropiedad, cValorSegundaPropiedad, cLote, dFechaFinLimite )

   local cSql  := "SELECT "                                                                              + ;
                     "cabecera.fecha_hora "                                                              + ;
                  "FROM movimientos_almacen_lineas lineas "                                              + ;
                     "INNER JOIN movimientos_almacen cabecera ON lineas.parent_uuid = cabecera.uuid "    + ;
                  "WHERE empresa = " + quoted( cCodEmp() ) + " "                                         + ;
                     "AND lineas.codigo_articulo = " + quoted( cCodigoArticulo ) + " "                   + ;
                     "AND cabecera.tipo_movimiento = 4 "                                                 

   if !empty( cCodigoAlmacen )
      cSql     +=    "AND cabecera.almacen_destino = " + quoted( cCodigoAlmacen ) + " "                   
   end if 

   cSql        +=    "AND lineas.codigo_primera_propiedad = " + quoted( cCodigoPrimeraPropiedad ) + " "   
   cSql        +=    "AND lineas.codigo_segunda_propiedad = " + quoted( cCodigoSegundaPropiedad ) + " "   
   cSql        +=    "AND lineas.valor_primera_propiedad = " + quoted( cValorPrimeraPropiedad ) + " "   
   cSql        +=    "AND lineas.valor_segunda_propiedad = " + quoted( cValorSegundaPropiedad ) + " "   
   cSql        +=    "AND lineas.lote = " + quoted( cLote, .t. ) + " "

   if !empty( dFechaFinLimite )
      cSql     +=    "AND cabecera.fecha_hora <= " + toSQLString( dFechaFinLimite ) + " "
   end if

   cSql        += "ORDER BY cabecera.fecha_hora DESC " + ;
                     "LIMIT 1"

RETURN ( cSql )

//---------------------------------------------------------------------------//

METHOD getSQLSentenceIdByUuid( uuid ) 

   local cSql        := "SELECT id "
   cSql              +=    "FROM " + ::getTableName() + " " 
   cSql              +=    "WHERE uuid = " + quoted( uuid ) 

RETURN ( cSql )

//---------------------------------------------------------------------------//

METHOD getFechaHoraConsolidacion( cCodigoArticulo, cCodigoAlmacen, cCodigoPropiedad1, cCodigoPropiedad2, cValorPropiedad1, cValorPropiedad2, cLote, dFechaFinLimite )

   local cSentence

   cSentence   := ::getSqlSentenceFechaHoraConsolidacion( cCodigoArticulo, cCodigoAlmacen, cCodigoPropiedad1, cCodigoPropiedad2, cValorPropiedad1, cValorPropiedad2, cLote, dFechaFinLimite )

RETURN ( ::getDatabase():getValue( cSentence ) )

//---------------------------------------------------------------------------//

METHOD getHashFechaHoraConsolidacion( cCodigoArticulo, cCodigoAlmacen, cCodigoPropiedad1, cCodigoPropiedad2, cValorPropiedad1, cValorPropiedad2, cLote )

   local aBuffer
   local hResult     := {=>}
   local cSentence   := ::getSqlSentenceFechaHoraConsolidacion( cCodigoArticulo, cCodigoAlmacen, cCodigoPropiedad1, cCodigoPropiedad2, cValorPropiedad1, cValorPropiedad2, cLote )

   aBuffer           := ::getDatabase():selectFetchHash( cSentence )

   if hb_isarray( aBuffer ) .and. len( aBuffer ) > 0
      hResult        := { "fecha"      => hb_ttod( hGet( atail( aBuffer ), "fecha_hora" ) ),;
                          "hora"       => substr( hb_tstostr( hGet( atail( aBuffer ), "fecha_hora" ) ), 12, 8 ),;
                          "fecha_hora" => hGet( atail( aBuffer ), "fecha_hora" ) }
   end if

RETURN ( hResult )

//---------------------------------------------------------------------------//

METHOD getTotalUnidadesStock( tConsolidacion, cCodigoArticulo, cCodigoAlmacen, cValorPropiedad1, cValorPropiedad2, cLote )
   
   local nEntrada    := ::getTotalUnidadesEntrada( tConsolidacion, cCodigoArticulo, cCodigoAlmacen, cValorPropiedad1, cValorPropiedad2, cLote )
   local nSalida     := ::getTotalUnidadesSalida( tConsolidacion, cCodigoArticulo, cCodigoAlmacen, cValorPropiedad1, cValorPropiedad2, cLote )

RETURN ( nEntrada - nSalida )

//---------------------------------------------------------------------------//

METHOD getSQLSentenceTotalUnidades( tConsolidacion, cCodigoArticulo, cCodigoAlmacen, cValorPropiedad1, cValorPropiedad2, cLote, lEntrada )

   local cSentence

   cSentence         := "SELECT movimientos_almacen.id, "
   cSentence         +=    "movimientos_almacen.fecha_hora, "
   cSentence         +=    "movimientos_almacen.almacen_destino, "
   cSentence         +=    "movimientos_almacen.almacen_origen, "
   cSentence         +=    "movimientos_almacen_lineas.parent_uuid, "
   cSentence         +=    "movimientos_almacen_lineas.codigo_articulo, "
   cSentence         +=    "movimientos_almacen_lineas.valor_primera_propiedad, "
   cSentence         +=    "movimientos_almacen_lineas.valor_segunda_propiedad, "
   cSentence         +=    "movimientos_almacen_lineas.lote, "
   cSentence         +=    "movimientos_almacen_lineas.cajas_articulo, "
   cSentence         +=    "movimientos_almacen_lineas.unidades_articulo, "
   cSentence         +=    SQLMovimientosAlmacenLineasModel():getSQLSubSentenceSumatorioUnidadesLinea() 
   cSentence         += "FROM movimientos_almacen "

   cSentence         += "INNER JOIN movimientos_almacen_lineas "
   cSentence         +=    "ON movimientos_almacen_lineas.parent_uuid = movimientos_almacen.uuid "

   cSentence         += "WHERE empresa = " + quoted( cCodEmp() ) + " "                                     
   
   if lEntrada
      cSentence      +=    "AND movimientos_almacen.almacen_destino = " + quoted( cCodigoAlmacen ) + " "
   else
      cSentence      +=    "AND movimientos_almacen.almacen_origen = " + quoted( cCodigoAlmacen ) + " "
   end if
   
   if !empty( tConsolidacion )
      cSentence      +=    "AND movimientos_almacen.fecha_hora >= " + quoted( hb_tstostr( tConsolidacion ) ) + " "
   end if

   cSentence         +=    "AND movimientos_almacen_lineas.codigo_articulo = " + quoted( cCodigoArticulo ) + " "
   cSentence         +=    "AND movimientos_almacen_lineas.valor_primera_propiedad = " + quoted( cValorPropiedad1 ) + " "
   cSentence         +=    "AND movimientos_almacen_lineas.valor_segunda_propiedad = " + quoted( cValorPropiedad2 ) + " "
   cSentence         +=    "AND movimientos_almacen_lineas.lote = " + quoted( cLote ) + " "
   cSentence         += "LIMIT 1"

RETURN ( cSentence )

//---------------------------------------------------------------------------//

METHOD getTotalUnidades( tConsolidacion, cCodigoArticulo, cCodigoAlmacen, cValorPropiedad1, cValorPropiedad2, cLote, lEntrada )

   local aBuffer
   local cSentence    
   local nTotal      := 0

   cSentence         := ::getSqlSentenceTotalUnidades( tConsolidacion, cCodigoArticulo, cCodigoAlmacen, cValorPropiedad1, cValorPropiedad2, cLote, lEntrada )

   aBuffer           := ::getDatabase():selectFetchHash( cSentence ) 
   if !hb_isnil( aBuffer )
      nTotal         := hGet( atail( aBuffer ), "totalUnidadesStock" )
   end if

RETURN ( nTotal )

//---------------------------------------------------------------------------//

METHOD getSQLSentenceMovimientosAlmacenForReport( oReporting )

   local cSentence   

   cSentence         := "SELECT movimientos_almacen.id, "
   cSentence         +=    "movimientos_almacen.numero, "
   cSentence         +=    "CAST( movimientos_almacen.fecha_hora AS date ) AS fecha, "
   cSentence         +=    "CAST( movimientos_almacen.fecha_hora AS time ) AS hora, "
   cSentence         +=    SQLMovimientosAlmacenModel():getColumnMovimiento( 'movimientos_almacen' ) 
   cSentence         +=    "movimientos_almacen.almacen_destino, "
   cSentence         +=    "movimientos_almacen.almacen_origen, "
   cSentence         +=    "movimientos_almacen_lineas.uuid AS uuid, "
   cSentence         +=    "movimientos_almacen_lineas.parent_uuid, "
   cSentence         +=    "movimientos_almacen_lineas.codigo_articulo, "
   cSentence         +=    "movimientos_almacen_lineas.codigo_primera_propiedad, "
   cSentence         +=    "movimientos_almacen_lineas.codigo_segunda_propiedad, "
   cSentence         +=    "movimientos_almacen_lineas.valor_primera_propiedad, "
   cSentence         +=    "movimientos_almacen_lineas.valor_segunda_propiedad, "
   cSentence         +=    "movimientos_almacen_lineas.lote, "
   cSentence         +=    "movimientos_almacen_lineas.bultos_articulo, "
   cSentence         +=    "movimientos_almacen_lineas.cajas_articulo, "
   cSentence         +=    "movimientos_almacen_lineas.unidades_articulo, "
   cSentence         +=    SQLMovimientosAlmacenLineasModel():getSQLSubSentenceTotalUnidadesLinea( "movimientos_almacen_lineas", "total_unidades" ) + ", "
   cSentence         +=    "movimientos_almacen_lineas.precio_articulo "
   cSentence         += "FROM movimientos_almacen_lineas "
   cSentence         += "INNER JOIN movimientos_almacen "
   cSentence         +=    "ON movimientos_almacen.uuid = movimientos_almacen_lineas.parent_uuid "
   cSentence         += "WHERE movimientos_almacen.empresa = " + quoted( cCodEmp() ) + " "                                     
   
   if !empty( oReporting )

      cSentence      +=    "AND CAST(movimientos_almacen.fecha_hora AS date) >= " + toSqlString( oReporting:getDesdeFecha() ) + " "
      cSentence      +=    "AND CAST(movimientos_almacen.fecha_hora AS date) <= " + toSqlString( oReporting:getHastaFecha() ) + " "

      cSentence      +=    "AND movimientos_almacen_lineas.codigo_articulo >= " + toSqlString( oReporting:getDesdeArticulo() ) + " "
      cSentence      +=    "AND movimientos_almacen_lineas.codigo_articulo <= " + toSqlString( oReporting:getHastaArticulo() ) + " "
   end if 

RETURN ( cSentence )

//---------------------------------------------------------------------------//

METHOD getRowSetMovimientosAlmacenForReport( oReporting )

   local cSentence   := ::getSqlSentenceMovimientosAlmacenForReport( oReporting )

RETURN ( SQLRowSet():New():Build( cSentence ) ) 

//---------------------------------------------------------------------------//

/*
   Valores permitidos de hParams
   - codigo_articulo ( obligatorio )
   - almacen 
   - codigo_primera_propiedad
   - codigo_segunda_propiedad
   - valor_primera_propiedad
   - valor_segunda_propiedad
   - lote
   - year 
   - empresa
*/

METHOD getSQLSentenceMovimientosForArticulo( hParams ) CLASS MovimientosAlmacenLineasRepository

   local idEmpresa
   local cSentence

   if !hhaskey( hParams, "codigo_articulo" )
      msgStop( "El código de artículo es un parametro obligatorio", "getSQLSentenceMovimientosForArticulo" )
      RETURN ( "" )
   end if 

   if hhaskey( hParams, "empresa" ) .and. !empty( hget( hParams, "empresa" ) )
      idEmpresa      := hget( hParams, "empresa" )
   else 
      idEmpresa      := cCodEmp()
   end if 

   cSentence         := "SELECT "
   cSentence         +=    "movimientos_almacen.id, "
   cSentence         +=    "movimientos_almacen.numero, "
   cSentence         +=    "CAST( movimientos_almacen.fecha_hora AS DATE ) AS fecha, "
   cSentence         +=    "CAST( movimientos_almacen.fecha_hora AS TIME ) AS hora, "
   cSentence         +=    SQLMovimientosAlmacenModel():getColumnMovimiento( 'movimientos_almacen' ) 
   cSentence         +=    "movimientos_almacen.almacen_destino, "
   cSentence         +=    "movimientos_almacen.almacen_origen, "
   cSentence         +=    "movimientos_almacen_lineas.parent_uuid, "
   cSentence         +=    "movimientos_almacen_lineas.codigo_articulo, "
   cSentence         +=    "movimientos_almacen_lineas.codigo_primera_propiedad, "
   cSentence         +=    "movimientos_almacen_lineas.codigo_segunda_propiedad, "
   cSentence         +=    "movimientos_almacen_lineas.valor_primera_propiedad, "
   cSentence         +=    "movimientos_almacen_lineas.valor_segunda_propiedad, "
   cSentence         +=    "movimientos_almacen_lineas.lote, "
   cSentence         +=    "movimientos_almacen_lineas.bultos_articulo, "
   cSentence         +=    "movimientos_almacen_lineas.cajas_articulo, "
   cSentence         +=    "movimientos_almacen_lineas.unidades_articulo, "
   cSentence         +=    SQLMovimientosAlmacenLineasModel():getSQLSubSentenceTotalUnidadesLinea( "movimientos_almacen_lineas", "total_unidades" ) + ", "
   cSentence         +=    "movimientos_almacen_lineas.precio_articulo "
   
   cSentence         += "FROM movimientos_almacen_lineas "
   
   cSentence         += "INNER JOIN movimientos_almacen "
   cSentence         +=    "ON movimientos_almacen.uuid = movimientos_almacen_lineas.parent_uuid "

   cSentence         += "WHERE movimientos_almacen.empresa = " + quoted( idEmpresa ) + " "
   
   cSentence         +=    "AND movimientos_almacen_lineas.codigo_articulo = " + quoted( hget( hParams, "codigo_articulo" ) ) + " "

   if hhaskey( hParams, "year" ) .and. !empty( hget( hParams, "year" ) )
      cSentence      +=    "AND DATE_FORMAT( CAST( movimientos_almacen.fecha_hora AS date ), '%Y' ) = " + Str( hget( hParams, "year" ) ) + " "
   end if
   
   if hhaskey( hParams, "almacen" ) .and. !empty( hget( hParams, "almacen" ) )
      cSentence      +=    "AND ( movimientos_almacen.almacen_destino = " + quoted( hget( hParams, "almacen" ) ) + " OR movimientos_almacen.almacen_origen = " + quoted( hget( hParams, "almacen" ) ) + " ) "
   end if

   if hhaskey( hParams, "codigo_primera_propiedad" )
      cSentence      +=    "AND movimientos_almacen_lineas.codigo_primera_propiedad = " + quoted( hget( hParams, "codigo_primera_propiedad" ) )  + " "
   end if

   if hhaskey( hParams, "codigo_segunda_propiedad" )
      cSentence      +=    "AND movimientos_almacen_lineas.codigo_segunda_propiedad = " + quoted( hget( hParams, "codigo_segunda_propiedad" ) )  + " "
   end if

   if hhaskey( hParams, "valor_primera_propiedad" )
      cSentence      +=    "AND movimientos_almacen_lineas.valor_primera_propiedad = " + quoted( hget( hParams, "valor_primera_propiedad" ) )  + " "
   end if

   if hhaskey( hParams, "valor_segunda_propiedad" )
      cSentence      +=    "AND movimientos_almacen_lineas.valor_segunda_propiedad = " + quoted( hget( hParams, "valor_segunda_propiedad" ) )  + " "
   end if

   if hhaskey( hParams, "lote" )
      cSentence      +=    "AND movimientos_almacen_lineas.lote = " + quoted( hget( hParams, "lote" ) )
   end if

RETURN ( cSentence )

//---------------------------------------------------------------------------//

METHOD getRowSetMovimientosForArticulo( hParams ) CLASS MovimientosAlmacenLineasRepository

   local cSentence   := ::getSqlSentenceMovimientosForArticulo( hParams )

RETURN ( SQLRowSet():New():Build( cSentence ) ) 

//---------------------------------------------------------------------------//
