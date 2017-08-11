#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS FacturasClientesLineasModel FROM BaseModel

   METHOD getTableName()                     INLINE ::getEmpresaTableName( "FacCliL" )

   METHOD getLineasFacturasAgrupadas( cCodigoArticulo, cCodigoAlmacen, cValorPropiedad1, cValorPropiedad2, cLote )

END CLASS

//---------------------------------------------------------------------------//

METHOD getLineasFacturasAgrupadas( cCodigoArticulo, cCodigoAlmacen, cValorPropiedad1, cValorPropiedad2, cLote )

   local cStm
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



