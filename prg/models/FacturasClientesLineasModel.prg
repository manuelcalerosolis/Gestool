#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS FacturasClientesLineasModel FROM BaseModel

   METHOD getTableName()                     INLINE ::getEmpresaTableName( "FacCliL" )

   METHOD getTableMovimientos()              INLINE ::getEmpresaTableName( "HisMov")

   METHOD getLineasFacturasAgrupadas( cCodigoArticulo, cCodigoAlmacen, cValorPropiedad1, cValorPropiedad2, cLote )

   METHOD getLineasFacturasAgrupadasUltimaConsolidacion( cCodigoArticulo, cCodigoAlmacen, cValorPropiedad1, cValorPropiedad2, cLote, dConsolidacion )

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



