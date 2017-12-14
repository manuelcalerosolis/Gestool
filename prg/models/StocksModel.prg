#include "FiveWin.ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS StocksModel FROM ADSBaseModel

   DATA cGroupByStatement               INIT ""

   METHOD getLineasAgrupadas()

   METHOD getTotalUnidadesStockSalidas()

   METHOD getTotalUnidadesStockEntradas()

   METHOD closeAreaLineasAgrupadas()      INLINE ( ::closeArea( "ADSLineasAgrupadas" ) )

   METHOD getFechaCaducidad()

   METHOD getFechaCaducidadADS()

   METHOD getFechaCaducidadSQL()

   METHOD getSqlAdsStockArticulo( cCodigoArticulo, dFechaInicio, dFechaFin )

   METHOD getSqlAdsStockLote( cCodigoArticulo, dFechaInicio, dFechaFin )

   METHOD getSqlAdsStock( cCodigoArticulo, dFechaInicio, dFechaFin )
   
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
      RETURN ( ( cStm )->totalUnidadesStock )
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
      RETURN ( ( cStm )->totalUnidadesStock )
   end if 

RETURN ( 0 )

//---------------------------------------------------------------------------//

METHOD getFechaCaducidad( cCodigoArticulo, cValorPrimeraPropiedad, cValorSegundaPropiedad, cLote )

   local dFechaCaducidadADS   := ::getFechaCaducidadADS( cCodigoArticulo, cValorPrimeraPropiedad, cValorSegundaPropiedad, cLote )
   local dFechaCaducidadSQL   := ::getFechaCaducidadSQL( cCodigoArticulo, cValorPrimeraPropiedad, cValorSegundaPropiedad, cLote )

RETURN ( max( dFechaCaducidadADS, dFechaCaducidadSQL ) )

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

   local cSql     := MovimientosAlmacenLineasRepository():getSQLSentenceFechaCaducidad( cCodigoArticulo, cValorPrimeraPropiedad, cValorSegundaPropiedad, cLote )
   local uValue   := getSQLDatabase():selectValue( cSql )

   if !empty( uValue ) .and. hb_isdate( uValue )
      RETURN ( uValue )
   end if 

RETURN ( ctod( "" ) )

//---------------------------------------------------------------------------//

METHOD getSqlAdsStockArticulo( cCodigoArticulo, dFechaInicio, dFechaFin )

   ::cGroupByStatement   := "Articulo, Almacen"

Return ( ::getSqlAdsStock( cCodigoArticulo, dFechaInicio, dFechaFin ) )

//---------------------------------------------------------------------------//

METHOD getSqlAdsStockLote( cCodigoArticulo, dFechaInicio, dFechaFin )

   ::cGroupByStatement   := "Articulo, Lote, Almacen"

RETURN ( ::getSqlAdsStock( cCodigoArticulo, dFechaInicio, dFechaFin ) )

//---------------------------------------------------------------------------//

METHOD getSqlAdsStock( cCodigoArticulo, dFechaInicio, dFechaFin )

   local cStm  
   local cSql  := "SELECT SUM( totalUnidadesStock ) as [totalUnidadesStock], "
   cSql        += "SUM( totalCajasStock ) as [totalCajasStock], "
   cSql        += "SUM( totalBultosStock ) as [totalBultosStock] "
   cSql        += if( !Empty( ::cGroupByStatement ), ", ", "" ) + ::cGroupByStatement + " "
   cSql        += "FROM ( "
   cSql        += AlbaranesProveedoresLineasModel():getSQLAdsStockEntrada( cCodigoArticulo, dFechaInicio, dFechaFin ) + " "
   cSql        += "UNION "
   cSql        += FacturasProveedoresLineasModel():getSQLAdsStockEntrada( cCodigoArticulo, dFechaInicio, dFechaFin ) + " "
   cSql        += "UNION "
   cSql        += RectificativasProveedoresLineasModel():getSQLAdsStockEntrada( cCodigoArticulo, dFechaInicio, dFechaFin ) + " "
   cSql        += "UNION "
   cSql        += AlbaranesClientesLineasModel():getSQLAdsStockSalida( cCodigoArticulo, dFechaInicio, dFechaFin ) + " "
   cSql        += "UNION "
   cSql        += FacturasClientesLineasModel():getSQLAdsStockSalida( cCodigoArticulo, dFechaInicio, dFechaFin ) + " "
   cSql        += "UNION "
   cSql        += RectificativasClientesLineasModel():getSQLAdsStockSalida( cCodigoArticulo, dFechaInicio, dFechaFin ) + " "
   cSql        += "UNION "
   cSql        += TicketsClientesLineasModel():getSQLAdsStockSalida( cCodigoArticulo, dFechaInicio, dFechaFin ) + " "
   cSql        += "UNION "
   cSql        += MaterialesProducidosLineasModel():getSQLAdsStockEntrada( cCodigoArticulo, dFechaInicio, dFechaFin ) + " "
   cSql        += "UNION "
   cSql        += MaterialesConsumidosLineasModel():getSQLAdsStockSalida( cCodigoArticulo, dFechaInicio, dFechaFin ) + " "
   cSql        += "UNION "
   cSql        += MovimientosAlmacenesLineasModel():getSentenceStockEntrada( cCodigoArticulo, dFechaInicio, dFechaFin ) + " "
   cSql        += "UNION "
   cSql        += MovimientosAlmacenesLineasModel():getSentenceStockSalida( cCodigoArticulo, dFechaInicio, dFechaFin )
   cSql        += " ) StockEntradas "
   if !Empty( ::cGroupByStatement )
      cSql     += "GROUP BY " + ::cGroupByStatement
   end if

   LogWrite( cSql )

   if ::ExecuteSqlStatement( cSql, @cStm )
      Return ( cStm )
   end if

RETURN ( 0 )

//---------------------------------------------------------------------------//