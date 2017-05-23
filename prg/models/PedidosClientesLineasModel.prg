#include "fivewin.ch"
#include "factu.ch" 
#include "hdo.ch"

//---------------------------------------------------------------------------//

CLASS PedidosClientesLineasModel FROM SQLBaseEmpresasModel

   METHOD TranslateCodigoTiposVentaToId( cTable )

   METHOD TranslatePresupuestoClientesLineasCodigoTiposVentaToId()   INLINE ( ::TranslateCodigoTiposVentaToId( "PreCliL" ) )

   METHOD TranslateSATClientesLineasCodigoTiposVentaToId()           INLINE ( ::TranslateCodigoTiposVentaToId( "SatCliL" ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD TranslateCodigoTiposVentaToId( cTable )

   local cSentenceDBF
   local hIdTipoVenta
   local aIdTiposVentas    := TiposVentasModel():arrayTiposVentas()

   for each hIdTipoVenta in aIdTiposVentas

      cSentenceDBF         := "UPDATE EMP" + cCodEmp() + cTable + " "                              + ;
                                 "SET id_tipo_v = " + toSqlString( hIdTipoVenta[ "id" ] ) + ", "   + ;
                                    "cTipMov = '' "                                                + ;
                                 "WHERE cTipMov = " + toSqlString( hIdTipoVenta[ "codigo" ] )
      
      BaseModel():ExecuteSqlStatement( cSentenceDBF )

   next 

RETURN ( Self )

//---------------------------------------------------------------------------//
