#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS MovimientosAlmacenesLineasModel FROM ADSBaseModel

   METHOD getTableName()                     INLINE ::getEmpresaTableName( "HisMov" )

   METHOD getFechaHoraConsolidacion()

   METHOD getTimeStampConsolidacion() 

   METHOD totalUnidadesEntradas()

   METHOD totalUnidadesSalidas()

   METHOD getSQLSentenceLineasAgrupadas()

   METHOD getSQLSentenceTotalUnidadesEntradasStock()

   METHOD getSQLSentenceTotalUnidadesSalidasStock()

END CLASS

//---------------------------------------------------------------------------//

METHOD getFechaHoraConsolidacion( cCodigoArticulo, cCodigoAlmacen, cValorPropiedad1, cValorPropiedad2, cLote )

   local cStm
   local cSql  := "SELECT TOP 1 dFecMov, cTimMov FROM " + ::getTableName()    + ;
                  "  WHERE nTipMov = 4"                                       + ;
                        " AND cRefMov = " + quoted( cCodigoArticulo )         + ;
                        " AND cAliMov = " + quoted( cCodigoAlmacen )          

   if !empty( cValorPropiedad1 )                        
         cSql  +=       " AND cValPr1 = " + quoted( cValorPropiedad1 )        
   end if 

   if !empty( cValorPropiedad1 )                        
         cSql  +=       " AND cValPr2 = " + quoted( cValorPropiedad2 )        
   end if 

   if !empty( cLote )                        
         cSql  +=       " AND cLote = " + quoted( cLote )        
   end if 

   cSql        +=       " ORDER BY dFecMov DESC, cTimMov DESC"

   if ::ExecuteSqlStatement( cSql, @cStm )
      if !empty( ( cStm )->dFecMov ) 
         RETURN ( { "fecha" => ( cStm )->dFecMov, "hora" => ( cStm )->cTimMov } )
      end if 
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD getTimeStampConsolidacion( cCodigoArticulo, cCodigoAlmacen, cValorPropiedad1, cValorPropiedad2, cLote ) 

   local hFechaHora  := ::getTimeStampConsolidacion( cCodigoArticulo, cCodigoAlmacen, cValorPropiedad1, cValorPropiedad2, cLote )

   if !empty( hFechaHora )
      RETURN ( dtos( hget( hFechaHora, "fecha" ) ) + hget( hFechaHora, "hora" ) )
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD getSQLSentenceTotalUnidadesEntradasStock( cCodigoArticulo, dConsolidacion, tConsolidacion, cCodigoAlmacen, cValorPropiedad1, cValorPropiedad2, cLote )

   local cSql  := "SELECT SUM( IIF( nCajMov = 0, 1, nCajMov ) * nUndMov ) as [totalUnidadesStock] " + ;
                     "FROM " + ::getTableName() + " " + ;
                     "WHERE cRefMov = " + quoted( cCodigoArticulo ) + " " // WHERE nTipMov <> 4 
   
   if !empty( dConsolidacion ) 
      if !empty( tConsolidacion )                    
         cSql  +=    "AND CAST( dFecMov AS SQL_CHAR ) + cTimMov >= " + quoted( dateToSQLString( dConsolidacion ) + tConsolidacion ) + " "
      else 
         cSql  +=    "AND CAST( dFecMov AS SQL_CHAR ) >= " + quoted( dateToSQLString( dConsolidacion ) ) + " "
      end if 
   end if 

   if !empty( cCodigoAlmacen )                     
         cSql  +=    "AND cAliMov = " + quoted( cCodigoAlmacen ) + " "
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

METHOD totalUnidadesEntradas( cCodigoArticulo, dConsolidacion, tConsolidacion, cCodigoAlmacen, cValorPropiedad1, cValorPropiedad2, cLote )

   local cStm
   local cSql  := ::getSQLSentenceTotalUnidadesEntradasStock( cCodigoArticulo, dConsolidacion, tConsolidacion, cCodigoAlmacen, cValorPropiedad1, cValorPropiedad2, cLote )

   if ::ExecuteSqlStatement( cSql, @cStm )
      Return ( ( cStm )->totalUnidadesStock )
   end if 

Return ( 0 )

//---------------------------------------------------------------------------//

METHOD getSQLSentenceTotalUnidadesSalidasStock( cCodigoArticulo, dConsolidacion, tConsolidacion, cCodigoAlmacen, cValorPropiedad1, cValorPropiedad2, cLote )

   local cSql  := "SELECT SUM( IIF( nCajMov = 0, 1, nCajMov ) * nUndMov ) as [totalUnidadesStock] " + ;
                     "FROM " + ::getTableName() + " " + ;
                     "WHERE cRefMov = " + quoted( cCodigoArticulo ) + " " // nTipMov <> 4 
   
   if !empty( dConsolidacion ) 
      if !empty( tConsolidacion )                    
         cSql  +=    "AND CAST( dFecMov AS SQL_CHAR ) + cTimMov >= " + quoted( dateToSQLString( dConsolidacion ) + tConsolidacion ) + " "
      else 
         cSql  +=    "AND CAST( dFecMov AS SQL_CHAR ) >= " + quoted( dateToSQLString( dConsolidacion ) ) + " "
      end if 
   end if 

   if !empty( cCodigoAlmacen )                     
         cSql  +=    "AND cAloMov = " + quoted( cCodigoAlmacen ) + " "
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

Return ( cSql )

//---------------------------------------------------------------------------//

METHOD totalUnidadesSalidas( cCodigoArticulo, dConsolidacion, tConsolidacion, cCodigoAlmacen, cValorPropiedad1, cValorPropiedad2, cLote )

   local cStm
   local cSql  := ::getSQLSentenceTotalUnidadesSalidasStock( cCodigoArticulo, dConsolidacion, tConsolidacion, cCodigoAlmacen, cValorPropiedad1, cValorPropiedad2, cLote )

   if ::ExecuteSqlStatement( cSql, @cStm )
      Return ( ( cStm )->totalUnidadesStock )
   end if 

Return ( 0 )

//---------------------------------------------------------------------------//

METHOD getSQLSentenceLineasAgrupadas( cCodigoArticulo, cCodigoAlmacen, cValorPropiedad1, cValorPropiedad2, cLote )

   local cSql  := "SELECT "                                                + ;
                     "cRefMov as cCodigoArticulo, "                        + ;
                     "cAliMov as cCodigoAlmacen, "                         + ;
                     "cValPr1 as cValorPropiedad1, "                       + ;
                     "cValPr2 as cValorPropiedad2, "                       + ;
                     "cLote as cLote "                                     + ;
                  "FROM " + ::getTableName() + " "                         + ;
                  "WHERE cRefMov = " + quoted( cCodigoArticulo ) + " "     + ;
                     "AND cAliMov = " + quoted( cCodigoAlmacen ) + " "     + ;
                     "GROUP BY cRefMov, cAliMov, cValPr1, cValPr2, cLote "

Return ( cSql )

//---------------------------------------------------------------------------//

