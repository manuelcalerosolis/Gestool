#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS TransaccionesComercialesLineasModel FROM ADSBaseModel

   METHOD getTableName()                                                VIRTUAL

   METHOD getExtraWhere()                                               INLINE ( "AND nCtlStk < 2" )

   METHOD getFechaFieldName()                                           VIRTUAL
   METHOD getHoraFieldName()                                            VIRTUAL

   METHOD getArticuloFieldName()                                        INLINE ( "cRef" )
   METHOD getAlmacenFieldName()                                         INLINE ( "cAlmLin" )
   METHOD getCajasStatement()
   METHOD getCajasFieldName()                                           INLINE ( "nCanEnt" )
   METHOD getUnidadesFieldName()                                        INLINE ( "nUniCaja" )

   METHOD getLineasAgrupadas()
   
   METHOD getSQLSentenceLineasAgrupadas()

   METHOD getLineasAgrupadasUltimaConsolidacion()

   METHOD getSQLSentenceTotalUnidadesStock()
   
   METHOD totalUnidadesStock()

   METHOD TranslateCodigoTiposVentaToId( cTable )

   METHOD TranslateSATClientesLineasCodigoTiposVentaToId()              INLINE ( ::TranslateCodigoTiposVentaToId( "SatCliL" ) )

   METHOD TranslatePresupuestoClientesLineasCodigoTiposVentaToId()      INLINE ( ::TranslateCodigoTiposVentaToId( "PreCliL" ) )

   METHOD TranslatePedidosClientesLineasCodigoTiposVentaToId()          INLINE ( ::TranslateCodigoTiposVentaToId( "PedCliL" ) )

   METHOD TranslateAlbaranesClientesLineasCodigoTiposVentaToId()        INLINE ( ::TranslateCodigoTiposVentaToId( "AlbCliL" ) )

   METHOD TranslateFacturasClientesLineasCodigoTiposVentaToId()         INLINE ( ::TranslateCodigoTiposVentaToId( "FacCliL" ) )

   METHOD TranslateFacturasRectificativasLineasCodigoTiposVentaToId()   INLINE ( ::TranslateCodigoTiposVentaToId( "FacRecL" ) )

   METHOD getSQLAdsStock( cCodigoArticulo, lSalida )

   METHOD getSQLAdsStockSalida( cCodigoArticulo )                       INLINE ( ::getSQLAdsStock( cCodigoArticulo, .t. ) )
   
   METHOD getSQLAdsStockEntrada( cCodigoArticulo )                      INLINE ( ::getSQLAdsStock( cCodigoArticulo, .f. ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD getSQLSentenceLineasAgrupadas( cCodigoArticulo, cCodigoAlmacen, cValorPropiedad1, cValorPropiedad2, cLote )

   local cSql  := "SELECT "                                                + ;
                     "cRef as cCodigoArticulo, "                           + ;
                     "cAlmLin as cCodigoAlmacen, "                         + ;
                     "cValPr1 as cValorPropiedad1, "                       + ;
                     "cValPr2 as cValorPropiedad2, "                       + ;
                     "cLote as cLote "                                     + ;
                  "FROM " + ::getTableName() + " "                         + ;
                  "WHERE cRef = " + quoted( cCodigoArticulo ) + " "        + ;
                     "AND cAlmLin = " + quoted( cCodigoAlmacen ) + " "     

   cSql        +=    ::getExtraWhere() + " "

   cSql        +=    "GROUP BY cRef, cAlmLin, cValPr1, cValPr2, cLote "

Return ( cSql )

//---------------------------------------------------------------------------//

METHOD getLineasAgrupadas( cCodigoArticulo, cCodigoAlmacen, cValorPropiedad1, cValorPropiedad2, cLote )

   local cStm  := "ADSLineasAgrupadas"
   local cSql  := ::getSQLSentenceLineasAgrupadas( cCodigoArticulo, cCodigoAlmacen, cValorPropiedad1, cValorPropiedad2, cLote )

   if ::ExecuteSqlStatement( cSql, @cStm )
      RETURN ( cStm )
   end if 

Return ( nil )

//---------------------------------------------------------------------------//

METHOD getLineasAgrupadasUltimaConsolidacion( cCodigoArticulo, cCodigoAlmacen, cValorPropiedad1, cValorPropiedad2, cLote, hConsolidacion )

   local cStm  
   local cSql  := "SELECT nCanEnt "                                           + ;
                     "FROM " + ::getTableName() + " "                         + ;
                     "WHERE cRef = " + quoted( cCodigoArticulo ) + " "        + ;
                        "AND cAlmLin = " + quoted( cCodigoAlmacen ) + " "     + ;
                        "AND cValPr1 = " + quoted( cValorPropiedad1 ) + " "   + ;
                        "AND cValPr2 = " + quoted( cValorPropiedad2 ) + " "   + ;
                        "AND cLote = " + quoted( cLote )                               

   cSql        +=       ::getExtraWhere() + " "

   if !empty(hConsolidacion)
      cSql     +=       "AND " + ::getFechaFieldName() + " >= " + quoted( hget( hConsolidacion, "fecha" ) ) + " "
      cSql     +=       "AND " + ::getHoraFieldName() + " >= " + quoted( hget( hConsolidacion, "hora" ) ) + " " 
   end if 

   if ::ExecuteSqlStatement( cSql, @cStm )
      RETURN ( cStm )
   end if 

Return ( nil )

//---------------------------------------------------------------------------//

METHOD getSQLSentenceTotalUnidadesStock( cCodigoArticulo, dConsolidacion, tConsolidacion, cCodigoAlmacen, cValorPropiedad1, cValorPropiedad2, cLote )

   local cSql  := "SELECT SUM( IIF( nCanEnt = 0, 1, nCanEnt ) * nUniCaja ) as [totalUnidadesStock], " + quoted( ::getTableName() ) + " AS Document " + ;
                     "FROM " + ::getTableName() + " " + ;
                     "WHERE cRef = " + quoted( cCodigoArticulo ) + " "
   
   if !empty( dConsolidacion )                     
      if !empty( tConsolidacion )                     
         cSql  +=    "AND CAST( " + ::getFechaFieldName() + " AS SQL_CHAR ) + " + ::getHoraFieldName() + " >= " + quoted( dateToSQLString( dConsolidacion ) + tConsolidacion ) + " "
      else 
         cSql  +=    "AND CAST( " + ::getFechaFieldName() + " AS SQL_CHAR ) >= " + quoted( dateToSQLString( dConsolidacion ) ) + " "
      end if 
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

   cSql        +=    ::getExtraWhere() + " "

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

METHOD TranslateCodigoTiposVentaToId( cTable )

   local cSentence
   local hIdTipoVenta
   local aIdTiposVentas    := TiposVentasRepository():getAll()

   if empty( aIdTiposVentas )
      RETURN ( Self )
   end if 

   for each hIdTipoVenta in aIdTiposVentas

      cSentence            := "UPDATE " + ::getEmpresaTableName( cTable )                       + space( 1 ) + ;
                                 "SET id_tipo_v = " + toSqlString( hIdTipoVenta[ "id" ] ) + "," + space( 1 ) + ;
                                    "cTipMov = ''"                                              + space( 1 ) + ;
                                 "WHERE cTipMov = " + toSqlString( hIdTipoVenta[ "codigo" ] )
      
      ADSBaseModel():ExecuteSqlStatement( cSentence )

   next 

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD getCajasStatement()

   if Empty( ::getCajasFieldName() )
      Return "1"
   end if

RETURN ( "IIF( " + ::getCajasFieldName() + " = 0, 1, " + ::getCajasFieldName() + " )" )

//---------------------------------------------------------------------------//

METHOD getSQLAdsStock( cCodigoArticulo, lSalida )

   local cStm
   local cSql        := ""

   DEFAULT lSalida   := .f.

   cSql              := "SELECT "
   cSql              += "( SUM( " + ::getCajasStatement() + " * " + ::getUnidadesFieldName() + " ) " + if( lSalida, "* - 1", "" ) + " ) as [totalUnidadesStock], "
   cSql              += quoted( ::getTableName() ) + " AS Document, "
   cSql              += ::getArticuloFieldName() + " AS Articulo, "
   cSql              += "cLote AS Lote, "
   cSql              += ::getAlmacenFieldName() + " AS Almacen  "
   cSql              += "FROM " + ::getTableName() + " TablaLineas "
   cSql              += "WHERE " + ::getArticuloFieldName() + " = " + quoted( cCodigoArticulo ) + " " 
   cSql              += ::getExtraWhere() + " "
   cSql              += "AND CAST( " + ::getFechaFieldName() + " AS SQL_CHAR ) + " + ::getHoraFieldName() + " >= " 
   cSql              += "COALESCE( "
   cSql              += "( SELECT TOP 1 CAST( HisMov.dFecMov AS SQL_CHAR ) + HisMov.cTimMov "
   cSql              += "FROM " + ::getEmpresaTableName( "HisMov" ) + " HisMov "
   cSql              += "WHERE HisMov.nTipMov = 4 "
   cSql              += "AND HisMov.cRefMov = TablaLineas." + ::getArticuloFieldName() + " "
   cSql              += "AND HisMov.cAliMov = TablaLineas." + ::getAlmacenFieldName() + " "
   cSql              += "AND HisMov.cLote = TablaLineas.cLote "
   cSql              += "ORDER BY HisMov.dFecMov DESC, HisMov.cTimMov DESC ), "
   cSql              += "'' ) "
   cSql              += "GROUP BY Articulo, Lote, Almacen"

   MsgInfo( ::getTableName(), "::getTableName()" )

   if ::ExecuteSqlStatement( cSql, @cStm )
      browse( cStm )
   end if

RETURN ( cSql )

//---------------------------------------------------------------------------//