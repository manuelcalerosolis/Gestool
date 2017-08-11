#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS MovimientosAlmacenesLineasModel FROM BaseModel

   METHOD getTableName()                     INLINE ::getEmpresaTableName( "HisMov" )

   METHOD getFechaHoraConsolidacion( cCodigoArticulo, cCodigoAlmacen, cValorPropiedad1, cValorPropiedad2, cLote )

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
         RETURN ( dtos( ( cStm )->dFecMov ) + ( cStm )->cTimMov )
      end if 
   end if 

Return ( nil )

//---------------------------------------------------------------------------//
