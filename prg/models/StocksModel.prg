#include "FiveWin.ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS StocksModel FROM ADSBaseModel

   METHOD getLineasAgrupadas()

   METHOD getTotalUnidadesStockSalidas()

   METHOD getTotalUnidadesStockEntradas()

   METHOD closeAreaLineasAgrupadas()      INLINE ( ::closeArea( "ADSLineasAgrupadas" ) )

   METHOD getFechaCaducidad()

   METHOD getFechaCaducidadADS()

   METHOD getFechaCaducidadSQL()

END CLASS

//---------------------------------------------------------------------------//

METHOD getLineasAgrupadas( cCodigoArticulo, cCodigoAlmacen, cValorPropiedad1, cValorPropiedad2, cLote )

   local cStm  := "ADSLineasAgrupadas"
   local cSql  := MovimientosAlmacenesLineasModel():getSQLSentenceLineasAgrupadas( cCodigoArticulo, cCodigoAlmacen, cValorPropiedad1, cValorPropiedad2, cLote )
   cSql        += "UNION "
   cSql        += AlbaranesClientesLineasModel():getSQLSentenceLineasAgrupadas( cCodigoArticulo, cCodigoAlmacen, cValorPropiedad1, cValorPropiedad2, cLote )
   cSql        += "UNION "
   cSql        += FacturasClientesLineasModel():getSQLSentenceLineasAgrupadas( cCodigoArticulo, cCodigoAlmacen, cValorPropiedad1, cValorPropiedad2, cLote )
   cSql        += "UNION "
   cSql        += TicketsClientesLineasModel():getSQLSentenceLineasAgrupadas( cCodigoArticulo, cCodigoAlmacen, cValorPropiedad1, cValorPropiedad2, cLote )
   cSql        += "UNION "
   cSql        += MaterialesConsumidosLineasModel():getSQLSentenceLineasAgrupadas( cCodigoArticulo, cCodigoAlmacen, cValorPropiedad1, cValorPropiedad2, cLote )
   cSql        += "UNION "
   cSql        += MaterialesProducidosLineasModel():getSQLSentenceLineasAgrupadas( cCodigoArticulo, cCodigoAlmacen, cValorPropiedad1, cValorPropiedad2, cLote )
   cSql        += "UNION "
   cSql        += AlbaranesProveedoresLineasModel():getSQLSentenceLineasAgrupadas( cCodigoArticulo, cCodigoAlmacen, cValorPropiedad1, cValorPropiedad2, cLote )
   cSql        += "UNION "
   cSql        += FacturasProveedoresLineasModel():getSQLSentenceLineasAgrupadas( cCodigoArticulo, cCodigoAlmacen, cValorPropiedad1, cValorPropiedad2, cLote )

   if ::ExecuteSqlStatement( cSql, @cStm )
      RETURN ( cStm )
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD getTotalUnidadesStockSalidas( cCodigoArticulo, dConsolidacion, tConsolidacion, cCodigoAlmacen, cValorPropiedad1, cValorPropiedad2, cLote )

   local cStm  
   local cSql  := "SELECT SUM( totalUnidadesStock ) as [totalUnidadesStock]"
   cSql        += "FROM ( "
   cSql        += MovimientosAlmacenesLineasModel():getSQLSentenceTotalUnidadesSalidasStock( cCodigoArticulo, dConsolidacion, tConsolidacion, cCodigoAlmacen, cValorPropiedad1, cValorPropiedad2, cLote )
   cSql        += "UNION "
   cSql        += AlbaranesClientesLineasModel():getSQLSentenceTotalUnidadesStock( cCodigoArticulo, dConsolidacion, tConsolidacion, cCodigoAlmacen, cValorPropiedad1, cValorPropiedad2, cLote )
   cSql        += "UNION "
   cSql        += FacturasClientesLineasModel():getSQLSentenceTotalUnidadesStock( cCodigoArticulo, dConsolidacion, tConsolidacion, cCodigoAlmacen, cValorPropiedad1, cValorPropiedad2, cLote )
   cSql        += "UNION "
   cSql        += RectificativasClientesLineasModel():getSQLSentenceTotalUnidadesStock( cCodigoArticulo, dConsolidacion, tConsolidacion, cCodigoAlmacen, cValorPropiedad1, cValorPropiedad2, cLote )
   cSql        += "UNION "
   cSql        += TicketsClientesLineasModel():getSQLSentenceTotalUnidadesStock( cCodigoArticulo, dConsolidacion, tConsolidacion, cCodigoAlmacen, cValorPropiedad1, cValorPropiedad2, cLote )
   cSql        += "UNION "
   cSql        += MaterialesConsumidosLineasModel():getSQLSentenceTotalUnidadesStock( cCodigoArticulo, dConsolidacion, tConsolidacion, cCodigoAlmacen, cValorPropiedad1, cValorPropiedad2, cLote )
   cSql        += " ) StockSalidas"

   if ::ExecuteSqlStatement( cSql, @cStm )
      RETURN ( (cStm)->totalUnidadesStock )
   end if 

RETURN ( 0 )

//---------------------------------------------------------------------------//

METHOD getTotalUnidadesStockEntradas( cCodigoArticulo, dConsolidacion, tConsolidacion, cCodigoAlmacen, cValorPropiedad1, cValorPropiedad2, cLote )

   local cStm  
   local cSql  := "SELECT SUM( totalUnidadesStock ) as [totalUnidadesStock]"
   cSql        += "FROM ( "
   cSql        += MovimientosAlmacenesLineasModel():getSQLSentenceTotalUnidadesEntradasStock( cCodigoArticulo, dConsolidacion, tConsolidacion, cCodigoAlmacen, cValorPropiedad1, cValorPropiedad2, cLote )
   cSql        += "UNION "
   cSql        += MaterialesProducidosLineasModel():getSQLSentenceTotalUnidadesStock( cCodigoArticulo, dConsolidacion, tConsolidacion, cCodigoAlmacen, cValorPropiedad1, cValorPropiedad2, cLote )
   cSql        += "UNION "
   cSql        += AlbaranesProveedoresLineasModel():getSQLSentenceTotalUnidadesStock( cCodigoArticulo, dConsolidacion, tConsolidacion, cCodigoAlmacen, cValorPropiedad1, cValorPropiedad2, cLote )
   cSql        += "UNION "
   cSql        += FacturasProveedoresLineasModel():getSQLSentenceTotalUnidadesStock( cCodigoArticulo, dConsolidacion, tConsolidacion, cCodigoAlmacen, cValorPropiedad1, cValorPropiedad2, cLote )
   cSql        += "UNION "
   cSql        += RectificativasProveedoresLineasModel():getSQLSentenceTotalUnidadesStock( cCodigoArticulo, dConsolidacion, tConsolidacion, cCodigoAlmacen, cValorPropiedad1, cValorPropiedad2, cLote )
   cSql        += " ) StockEntradas"

   if ::ExecuteSqlStatement( cSql, @cStm )
      RETURN ( (cStm)->totalUnidadesStock )
   end if 

RETURN ( 0 )

//---------------------------------------------------------------------------//

METHOD getFechaCaducidad( cCodigoArticulo, cValorPrimeraPropiedad, cValorSegundaPropiedad, cLote )

   local dFechaCaducidadADS   := ::getFechaCaducidadADS( cCodigoArticulo, cValorPrimeraPropiedad, cValorSegundaPropiedad, cLote )
   local dFechaCaducidadSQL   := ::getFechaCaducidadSQL( cCodigoArticulo, cValorPrimeraPropiedad, cValorSegundaPropiedad, cLote )

   msgalert( dFechaCaducidadADS, "dFechaCaducidadADS" )
   msgalert( dFechaCaducidadSQL, "dFechaCaducidadSQL" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD getFechaCaducidadADS( cCodigoArticulo, cValorPrimeraPropiedad, cValorSegundaPropiedad, cLote )

   local cStm  
   local cSql  := "SELECT TOP 1 dFechaDocumento, dFechaCaducidad "
   cSql        += "FROM ( "
   cSql        += AlbaranesProveedoresLineasModel():getSQLSentenceFechaCaducidad( cCodigoArticulo, cValorPrimeraPropiedad, cValorSegundaPropiedad, cLote )
   cSql        += "UNION "
   cSql        += FacturasProveedoresLineasModel():getSQLSentenceFechaCaducidad( cCodigoArticulo, cValorPrimeraPropiedad, cValorSegundaPropiedad, cLote )
   cSql        += "UNION "
   cSql        += MaterialesProducidosLineasModel():getSQLSentenceFechaCaducidad( cCodigoArticulo, cValorPrimeraPropiedad, cValorSegundaPropiedad, cLote )
   cSql        += ") FechaCaducidad "
   cSql        += "ORDER BY dFechaDocumento DESC"

   if ::ExecuteSqlStatement( cSql, @cStm )
      RETURN ( ( cStm )->dFechaCaducidad )
   end if 

RETURN ( ctod( "" ) )

//---------------------------------------------------------------------------//

METHOD getFechaCaducidadSQL( cCodigoArticulo, cValorPrimeraPropiedad, cValorSegundaPropiedad, cLote )

   local cSql  := MovimientosAlmacenLineasRepository():getSQLSentenceFechaCaducidad( cCodigoArticulo, cValorPrimeraPropiedad, cValorSegundaPropiedad, cLote )

   logwrite( cSql )

RETURN ( ctod( "" ) )

//---------------------------------------------------------------------------//


