#include "FiveWin.ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS StocksModel FROM BaseModel

   METHOD getLineasAgrupadas()

   METHOD getTotalUnidadesStockVentas()

   METHOD closeAreaLineasAgrupadas()   INLINE ( ::closeArea( "ADSLineasAgrupadas" ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD getLineasAgrupadas( cCodigoArticulo, cCodigoAlmacen, cValorPropiedad1, cValorPropiedad2, cLote )

   local cStm  := "ADSLineasAgrupadas"
   local cSql  := MovimientosAlmacenesLineasModel():getSQLSentenceLineasAgrupadas( cCodigoArticulo, cCodigoAlmacen, cValorPropiedad1, cValorPropiedad2, cLote )
   cSql        += "UNION "
   cSql        += AlbaranesClientesLineasModel():getSQLSentenceLineasAlbaranesAgrupadas( cCodigoArticulo, cCodigoAlmacen, cValorPropiedad1, cValorPropiedad2, cLote )
   cSql        += "UNION "
   cSql        += FacturasClientesLineasModel():getSQLSentenceLineasFacturasAgrupadas( cCodigoArticulo, cCodigoAlmacen, cValorPropiedad1, cValorPropiedad2, cLote )

   if ::ExecuteSqlStatement( cSql, @cStm )
      RETURN ( cStm )
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD getTotalUnidadesStockVentas( cCodigoArticulo, dConsolidacion, tConsolidacion, cCodigoAlmacen, cValorPropiedad1, cValorPropiedad2, cLote )

   local cStm  
   local cSql  := "SELECT SUM( totalUnidadesStock ) as [totalUnidadesStock]"
   cSql        += "FROM ( "
   cSql        += AlbaranesClientesLineasModel():getSQLSentenceTotalUnidadesStock( cCodigoArticulo, dConsolidacion, tConsolidacion, cCodigoAlmacen, cValorPropiedad1, cValorPropiedad2, cLote )
   cSql        += "UNION "
   cSql        += FacturasClientesLineasModel():getSQLSentenceTotalUnidadesStock( cCodigoArticulo, dConsolidacion, tConsolidacion, cCodigoAlmacen, cValorPropiedad1, cValorPropiedad2, cLote )
   cSql        += "UNION "
   cSql        += RectificativasClientesLineasModel():getSQLSentenceTotalUnidadesStock( cCodigoArticulo, dConsolidacion, tConsolidacion, cCodigoAlmacen, cValorPropiedad1, cValorPropiedad2, cLote )
   cSql        += " ) StockVentas"

   logwrite( cSql, "cSql" )

   if ::ExecuteSqlStatement( cSql, @cStm )
      RETURN ( (cStm)->totalUnidadesStock )
   end if 

RETURN ( 0 )

//---------------------------------------------------------------------------//
