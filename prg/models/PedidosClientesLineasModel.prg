#include "fivewin.ch"
#include "factu.ch" 
#include "hdo.ch"

//---------------------------------------------------------------------------//

CLASS PedidosClientesLineasModel FROM SQLBaseEmpresasModel

   METHOD TranslateCodigoTiposVentaToId( cTable )

   METHOD TranslateSATClientesLineasCodigoTiposVentaToId()           INLINE ( ::TranslateCodigoTiposVentaToId( "SatCliL" ) )

   METHOD TranslatePresupuestoClientesLineasCodigoTiposVentaToId()   INLINE ( ::TranslateCodigoTiposVentaToId( "PreCliL" ) )

   METHOD TranslatePedidosClientesLineasCodigoTiposVentaToId()       INLINE ( ::TranslateCodigoTiposVentaToId( "PedCliL" ) )

   METHOD TranslateAlbaranesClientesLineasCodigoTiposVentaToId()     INLINE ( ::TranslateCodigoTiposVentaToId( "AlbCliL" ) )

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
