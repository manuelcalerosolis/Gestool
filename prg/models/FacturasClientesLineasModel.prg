#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS FacturasClientesLineasModel FROM BaseModel

   METHOD getTableName()                     INLINE ::getEmpresaTableName( "FacCliL" )

   METHOD getTableMovimientos()              INLINE ::getEmpresaTableName( "HisMov")

   METHOD getLineasFacturasAgrupadas( cCodigoArticulo, cCodigoAlmacen, cValorPropiedad1, cValorPropiedad2, cLote )

   METHOD getLineasFacturasAgrupadasUltimaConsolidacion( cCodigoArticulo, cCodigoAlmacen, cValorPropiedad1, cValorPropiedad2, cLote, dConsolidacion )

   METHOD totalUnidadesStock( cCodigoArticulo, dConsolidacion, tConsolidacion, cCodigoAlmacen, cValorPropiedad1, cValorPropiedad2, cLote )

END CLASS

//---------------------------------------------------------------------------//

METHOD getLineasFacturasAgrupadas( cCodigoArticulo, cCodigoAlmacen, cValorPropiedad1, cValorPropiedad2, cLote )

   local cStm  := "ADSLineasFacturas"
   local cSql  := "SELECT cRef, cAlmLin, cValPr1, cValPr2, cLote FROM " + ::getTableName()   + ;
                  "  WHERE nCtlStk < 2"                                                      + ;
                        " AND cRef = " + quoted( cCodigoArticulo )                           + ;
                        " AND cAlmLin = " + quoted( cCodigoAlmacen )                         + ;
                        " GROUP BY cRef, cAlmLin, cValPr1, cValPr2, cLote"

   if ::ExecuteSqlStatement( cSql, @cStm )
      RETURN ( cStm )
   end if 

Return ( nil )

//---------------------------------------------------------------------------//

METHOD getLineasFacturasAgrupadasUltimaConsolidacion( cCodigoArticulo, cCodigoAlmacen, cValorPropiedad1, cValorPropiedad2, cLote, hConsolidacion )

   local cStm  
   local cSql  := "SELECT nCanEnt "                                                    + ;
                  "  FROM " + ::getTableName()                                         + ;
                  "  WHERE nCtlStk < 2"                                                + ;
                        " AND cRef = " + quoted( cCodigoArticulo )                     + ;
                        " AND cAlmLin = " + quoted( cCodigoAlmacen )                   + ;
                        " AND cValPr1 = " + quoted( cValorPropiedad1 )                 + ;
                        " AND cValPr2 = " + quoted( cValorPropiedad2 )                 + ;
                        " AND cLote = " + quoted( cLote )                              

   if !empty(hConsolidacion)
      cSql     +=       " AND dFecFac >= " + quoted( hget( hConsolidacion, "fecha" ) )
      cSql     +=       " AND tFecFac >= " + quoted( hget( hConsolidacion, "hora" ) )
   end if 

   msgalert( cSql, "getLineasFacturasAgrupadasUltimaConsolidacion" )       
   logwrite( cSql )                 

   if ::ExecuteSqlStatement( cSql, @cStm )
      RETURN ( cStm )
   end if 

Return ( nil )

//---------------------------------------------------------------------------//

METHOD totalUnidadesStock( cCodigoArticulo, dConsolidacion, tConsolidacion, cCodigoAlmacen, cValorPropiedad1, cValorPropiedad2, cLote )

   local cStm
   local cSql  := "SELECT SUM( IIF( nCanEnt = 0, 1, nCanEnt ) * nUniCaja ) as [totalUnidadesStock] " + ;
                     "FROM " + ::getTableName() + " " + ;
                     "WHERE cRef = " + quoted( cCodigoArticulo ) + " "
   
   if !empty( dConsolidacion )                     
         cSql  +=    "AND CAST( dFecFac AS SQL_CHAR ) >= " + quoted( dateToSQLString( dConsolidacion ) ) + " "
   end if 

   if !empty( tConsolidacion )                     
         cSql  +=    "AND tFecFac >= " + quoted( tConsolidacion ) + " "
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

   msgalert( cSql, "cSql" )

   if ::ExecuteSqlStatement( cSql, @cStm )
      Return ( ( cStm )->totalUnidadesStock )
   end if 

Return ( 0 )

//---------------------------------------------------------------------------//
/*

select  as [totalUnidades], cRef, cAlmLin , ( dfecfac ), tFecFac   
   from emp016afacclil 
   where cRef = '9' and CAST( dfecfac AS SQL_CHAR ) >= '2017-01-20' and tfecfac > '072515' // and cAlmLin = '000'
   group by cRef, cAlmLin, dfecfac, tfecfac, cAlmLin

*/


