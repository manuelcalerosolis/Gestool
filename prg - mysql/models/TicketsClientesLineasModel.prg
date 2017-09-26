#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS TicketsClientesLineasModel FROM BaseModel

   METHOD getTableName()                     INLINE ::getEmpresaTableName( "TikeL" )

   METHOD getSQLSentenceLineasAgrupadas( cCodigoArticulo, cCodigoAlmacen, cValorPropiedad1, cValorPropiedad2, cLote )

   METHOD getLineasAgrupadas( cCodigoArticulo, cCodigoAlmacen, cValorPropiedad1, cValorPropiedad2, cLote )

   METHOD getLineasAgrupadasUltimaConsolidacion( cCodigoArticulo, cCodigoAlmacen, cValorPropiedad1, cValorPropiedad2, cLote, dConsolidacion )

   METHOD getSQLSentenceTotalUnidadesStock( cCodigoArticulo, cCodigoAlmacen, cValorPropiedad1, cValorPropiedad2, cLote )

   METHOD totalUnidadesStock( cCodigoArticulo, dConsolidacion, tConsolidacion, cCodigoAlmacen, cValorPropiedad1, cValorPropiedad2, cLote )

END CLASS

//---------------------------------------------------------------------------//

METHOD getSQLSentenceLineasAgrupadas( cCodigoArticulo, cCodigoAlmacen, cValorPropiedad1, cValorPropiedad2, cLote )

   local cSql  := "SELECT "                                                + ;
                     "cCbaTil as cCodigoArticulo, "                        + ;
                     "cAlmLin as cCodigoAlmacen, "                         + ;
                     "cValPr1 as cValorPropiedad1, "                       + ;
                     "cValPr2 as cValorPropiedad2, "                       + ;
                     "cLote as cLote "                                     + ;
                  "FROM " + ::getTableName() + " "                         + ;
                  "WHERE nCtlStk < 2 "                                     + ;
                     "AND cCbaTil = " + quoted( cCodigoArticulo ) + " "    + ;
                     "AND cAlmLin = " + quoted( cCodigoAlmacen ) + " "     + ;
                     "GROUP BY cCbaTil, cAlmLin, cValPr1, cValPr2, cLote "

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
                  "  WHERE nCtlStk < 2"                                 + ;
                        " AND cCbaTil = " + quoted( cCodigoArticulo )   + ;
                        " AND cAlmLin = " + quoted( cCodigoAlmacen )    + ;
                        " AND cValPr1 = " + quoted( cValorPropiedad1 )  + ;
                        " AND cValPr2 = " + quoted( cValorPropiedad2 )  + ;
                        " AND cLote = " + quoted( cLote )                              

   if !empty(hConsolidacion)
      cSql     +=       " AND dFecFac >= " + quoted( hget( hConsolidacion, "fecha" ) )
      cSql     +=       " AND tFecFac >= " + quoted( hget( hConsolidacion, "hora" ) )
   end if 

   if ::ExecuteSqlStatement( cSql, @cStm )
      RETURN ( cStm )
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD getSQLSentenceTotalUnidadesStock( cCodigoArticulo, dConsolidacion, tConsolidacion, cCodigoAlmacen, cValorPropiedad1, cValorPropiedad2, cLote )

   local cSql  := "SELECT SUM( nUntTil ) as [totalUnidadesStock] "         + ;
                     "FROM " + ::getTableName() + " "                      + ;
                     "WHERE cCbaTil = " + quoted( cCodigoArticulo ) + " "
   
   if !empty( dConsolidacion )                     
         cSql  +=    "AND CAST( dFecTik AS SQL_CHAR ) >= " + quoted( dateToSQLString( dConsolidacion ) ) + " "
   end if 

   if !empty( tConsolidacion )                     
         cSql  +=    "AND tFecTik >= " + quoted( tConsolidacion ) + " "
   end if 

   if !empty( cCodigoAlmacen )                     
         cSql  +=    "AND cAlmLin = " + quoted( cCodigoAlmacen ) + " "
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
