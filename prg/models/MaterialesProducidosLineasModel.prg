#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS MaterialesProducidosLineasModel FROM TransaccionesComercialesLineasModel

   METHOD getTableName()                     INLINE ::getEmpresaTableName( "ProLin" )

   METHOD getExtraWhere()                    INLINE ( "" )
   METHOD getFechaFieldName()                INLINE ( "dFecOrd" )
   METHOD getHoraFieldName()                 INLINE ( "cHorIni" )
   METHOD getArticuloFieldName()             INLINE ( "cCodArt" )
   METHOD setAlmacenFieldName()              INLINE ( ::cAlmacenFieldName  := "cAlmOrd" )
   METHOD getCajasFieldName()                INLINE ( "nCajOrd" )
   METHOD getUnidadesFieldName()             INLINE ( "nUndOrd" )

   METHOD getSQLSentenceLineasAgrupadas( cCodigoArticulo, cCodigoAlmacen, cValorPropiedad1, cValorPropiedad2, cLote )

   METHOD getLineasAgrupadas( cCodigoArticulo, cCodigoAlmacen, cValorPropiedad1, cValorPropiedad2, cLote )

   METHOD getLineasAgrupadasUltimaConsolidacion( cCodigoArticulo, cCodigoAlmacen, cValorPropiedad1, cValorPropiedad2, cLote, dConsolidacion )

   METHOD getSQLSentenceTotalUnidadesStock( cCodigoArticulo, cCodigoAlmacen, cValorPropiedad1, cValorPropiedad2, cLote )

   METHOD totalUnidadesStock( cCodigoArticulo, dConsolidacion, tConsolidacion, cCodigoAlmacen, cValorPropiedad1, cValorPropiedad2, cLote )

   METHOD getSQLSentenceFechaCaducidad( cCodigoArticulo, cValorPrimeraPropiedad, cValorSegundaPropiedad, cLote )

END CLASS

//---------------------------------------------------------------------------//

METHOD getSQLSentenceLineasAgrupadas( cCodigoArticulo, cCodigoAlmacen, cValorPropiedad1, cValorPropiedad2, cLote )

   local cSql  := "SELECT "                                                + ;
                     "cCodArt as cCodigoArticulo, "                        + ;
                     "cAlmOrd as cCodigoAlmacen, "                         + ;
                     "cValPr1 as cValorPropiedad1, "                       + ;
                     "cValPr2 as cValorPropiedad2, "                       + ;
                     "cLote as cLote "                                     + ;
                  "FROM " + ::getTableName() + " "                         + ;
                  "WHERE cCodArt = " + quoted( cCodigoArticulo ) + " "     + ;
                     "AND cAlmOrd = " + quoted( cCodigoAlmacen ) + " "     + ;
                     "GROUP BY cCodArt, cAlmOrd, cValPr1, cValPr2, cLote "

Return ( cSql )

//---------------------------------------------------------------------------//

METHOD getLineasAgrupadas( cCodigoArticulo, cCodigoAlmacen, cValorPropiedad1, cValorPropiedad2, cLote )

   local cStm  := "ADSLineasAgrupadas"
   local cSql  := ::getSQLSentenceLineasAgrupadas( cCodigoArticulo, cCodigoAlmacen, cValorPropiedad1, cValorPropiedad2, cLote )

   if ::ExecuteSqlStatement( cSql, @cStm )
      RETURN ( cStm )
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD getLineasAgrupadasUltimaConsolidacion( cCodigoArticulo, cCodigoAlmacen, cValorPropiedad1, cValorPropiedad2, cLote, hConsolidacion )

   local cStm  
   local cSql  := "SELECT nCanEnt "                                     + ;
                  "  FROM " + ::getTableName()                          + ;
                  "  WHERE cCodArt = " + quoted( cCodigoArticulo )      + ;
                        " AND cAlmOrd = " + quoted( cCodigoAlmacen )    + ;
                        " AND cValPr1 = " + quoted( cValorPropiedad1 )  + ;
                        " AND cValPr2 = " + quoted( cValorPropiedad2 )  + ;
                        " AND cLote = " + quoted( cLote )                              

   if !empty(hConsolidacion)
      cSql     +=       " AND dFecOrd >= " + quoted( hget( hConsolidacion, "fecha" ) )
      cSql     +=       " AND cHorIni >= " + quoted( hget( hConsolidacion, "hora" ) )
   end if 

   if ::ExecuteSqlStatement( cSql, @cStm )
      RETURN ( cStm )
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD getSQLSentenceTotalUnidadesStock( cCodigoArticulo, dConsolidacion, tConsolidacion, cCodigoAlmacen, cValorPropiedad1, cValorPropiedad2, cLote )

   local cSql  := "SELECT SUM( IIF( nCajOrd = 0, 1, nCajOrd ) * nUndOrd ) as [totalUnidadesStock] , " + quoted( ::getTableName() ) + " AS Document " + ;
                     "FROM " + ::getTableName() + " "                                                 + ;
                     "WHERE cCodArt = " + quoted( cCodigoArticulo ) + " "
   
   if !empty( dConsolidacion )                     
      if !empty( tConsolidacion )                     
         cSql  +=    "AND CAST( dFecOrd AS SQL_CHAR ) + cHorIni >= " + quoted( dateToSQLString( dConsolidacion ) + tConsolidacion ) + " "
      else
         cSql  +=    "AND CAST( dFecOrd AS SQL_CHAR ) >= " + quoted( dateToSQLString( dConsolidacion ) ) + " "
      end if 
   end if 

   if !empty( cCodigoAlmacen )                     
         cSql  +=    "AND cAlmOrd = " + quoted( cCodigoAlmacen ) + " "
   end if 

   if !empty( cValorPropiedad1 )                     
         cSql  +=    "AND cValPr1 = " + quoted( cValorPropiedad1 ) + " "
   end if 

   if !empty( cValorPropiedad2 )                     
         cSql  +=    "AND cValPr2 = " + quoted( cValorPropiedad2 ) + " "
   end if 

   if !empty( cLote )                     
         cSql  +=    "AND cLote = " + quoted( cLote ) + " "
   end if 

RETURN ( cSql )

//---------------------------------------------------------------------------//

METHOD totalUnidadesStock( cCodigoArticulo, dConsolidacion, tConsolidacion, cCodigoAlmacen, cValorPropiedad1, cValorPropiedad2, cLote )

   local cStm
   local cSql  := ::getSQLSentenceTotalUnidadesStock( cCodigoArticulo, dConsolidacion, tConsolidacion, cCodigoAlmacen, cValorPropiedad1, cValorPropiedad2, cLote )

   if ::ExecuteSqlStatement( cSql, @cStm )
      RETURN ( ( cStm )->totalUnidadesStock )
   end if 

RETURN ( 0 )

//---------------------------------------------------------------------------//

METHOD getSQLSentenceFechaCaducidad( cCodigoArticulo, cValorPrimeraPropiedad, cValorSegundaPropiedad, cLote )

   local cSql  := "SELECT "                                                      + ;
                     "cCodArt as cCodigoArticulo, "                              + ;
                     "cValPr1 as cValorPrimeraPropiedad, "                       + ;
                     "cValPr2 as cValorSegundaPropiedad, "                       + ;
                     "cLote as cLote, "                                          + ;
                     "dFecOrd as dFechaDocumento, "                              + ;
                     "dFecCad as dFechaCaducidad "                               + ;
                  "FROM " + ::getTableName() + " "                               + ;
                  "WHERE cCodArt = " + quoted( cCodigoArticulo ) + " "           + ;
                     "AND dFecCad IS NOT NULL "       

   if !empty(cValorPrimeraPropiedad)
      cSql     +=    "AND cValPr1 = " + quoted( cValorPrimeraPropiedad ) + " "   
   end if 

   if !empty(cValorSegundaPropiedad)
      cSql     +=    "AND cValPr2 = " + quoted( cValorSegundaPropiedad ) + " "   
   end if 

   if !empty(cLote)
      cSql     +=    "AND cLote = " + quoted( cLote ) + " "
   end if 

RETURN ( cSql )

//---------------------------------------------------------------------------//



