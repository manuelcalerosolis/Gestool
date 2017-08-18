#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS MovimientosAlmacenesLineasModel FROM BaseModel

   METHOD getTableName()                     INLINE ::getEmpresaTableName( "HisMov" )

   METHOD getFechaHoraConsolidacion( cCodigoArticulo, cCodigoAlmacen, cValorPropiedad1, cValorPropiedad2, cLote )

   METHOD getTimeStampConsolidacion( cCodigoArticulo, cCodigoAlmacen, cValorPropiedad1, cValorPropiedad2, cLote ) 

   METHOD totalUnidadesEntradas( cCodigoArticulo, dConsolidacion, tConsolidacion, cCodigoAlmacen, cValorPropiedad1, cValorPropiedad2, cLote )

END CLASS

//---------------------------------------------------------------------------//

METHOD getFechaHoraConsolidacion( cCodigoArticulo, cCodigoAlmacen, cValorPropiedad1, cValorPropiedad2, cLote )

   local cStm
   local cSql  := "SELECT TOP 1 dFecMov, cTimMov FROM " + ::getTableName()    + ;
                  "  WHERE nTipMov = 4"                                       + ;
                        " AND cRefMov = " + quoted( cCodigoArticulo )         + ;
                        " AND cAliMov = " + quoted( cCodigoAlmacen )          + ;
                        " AND cValPr1 = " + quoted( cValorPropiedad1 )        + ;
                        " AND cValPr2 = " + quoted( cValorPropiedad2 )        + ;
                        " AND cLote = " + quoted( cLote )                     + ;
                        " ORDER BY dFecMov DESC, cTimMov DESC"

   if ::ExecuteSqlStatement( cSql, @cStm )
      if !empty( ( cStm )->dFecMov ) 
         RETURN ( {"fecha" => ( cStm )->dFecMov, "hora" => ( cStm )->cTimMov } )
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

METHOD totalUnidadesEntradas( cCodigoArticulo, dConsolidacion, tConsolidacion, cCodigoAlmacen, cValorPropiedad1, cValorPropiedad2, cLote )

   local cStm
   local cSql  := "SELECT SUM( IIF( nCajMov = 0, 1, nCajMov ) * nUndMov ) as [totalUnidadesStock] " + ;
                     "FROM " + ::getTableName() + " " + ;
                     "WHERE nTipMov <> 4 " + ;
                     "AND cRefMov = " + quoted( cCodigoArticulo ) + " "
   
   if !empty( dConsolidacion )                     
         cSql  +=    "AND CAST( dFecMov AS SQL_CHAR ) >= " + quoted( dateToSQLString( dConsolidacion ) ) + " "
   end if 

   if !empty( tConsolidacion )                     
         cSql  +=    "AND cTimMov >= " + quoted( tConsolidacion ) + " "
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

   msgalert( cSql, "totalUnidadesEntradas" )
   logwrite( cSql, "totalUnidadesEntradas" )

   if ::ExecuteSqlStatement( cSql, @cStm )
      Return ( ( cStm )->totalUnidadesStock )
   end if 

Return ( 0 )

//---------------------------------------------------------------------------//


