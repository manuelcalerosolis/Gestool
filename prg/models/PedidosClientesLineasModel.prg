#include "fivewin.ch"
#include "factu.ch" 
#include "hdo.ch"

//---------------------------------------------------------------------------//

CLASS PedidosClientesLineasModel FROM SQLBaseModel

   METHOD TranslateCodigoTiposVentaToId( cTable )

   METHOD TranslateSATClientesLineasCodigoTiposVentaToId()              INLINE ( ::TranslateCodigoTiposVentaToId( "SatCliL" ) )

   METHOD TranslatePresupuestoClientesLineasCodigoTiposVentaToId()      INLINE ( ::TranslateCodigoTiposVentaToId( "PreCliL" ) )

   METHOD TranslatePedidosClientesLineasCodigoTiposVentaToId()          INLINE ( ::TranslateCodigoTiposVentaToId( "PedCliL" ) )

   METHOD TranslateAlbaranesClientesLineasCodigoTiposVentaToId()        INLINE ( ::TranslateCodigoTiposVentaToId( "AlbCliL" ) )

   METHOD TranslateFacturasClientesLineasCodigoTiposVentaToId()         INLINE ( ::TranslateCodigoTiposVentaToId( "FacCliL" ) )

   METHOD TranslateFacturasRectificativasLineasCodigoTiposVentaToId()   INLINE ( ::TranslateCodigoTiposVentaToId( "FacRecL" ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD TranslateCodigoTiposVentaToId( cTable )

   local cSentenceDBF
   local hIdTipoVenta
   local aIdTiposVentas    := TiposVentasModel():arrayTiposVentas()

   if empty(aIdTiposVentas)
      RETURN ( Self )
   end if 

   for each hIdTipoVenta in aIdTiposVentas

      cSentenceDBF         := "UPDATE EMP" + cCodEmp() + cTable + " "                              + ;
                                 "SET id_tipo_v = " + toSqlString( hIdTipoVenta[ "id" ] ) + ", "   + ;
                                    "cTipMov = '' "                                                + ;
                                 "WHERE cTipMov = " + toSqlString( hIdTipoVenta[ "codigo" ] )
      
      BaseModel():ExecuteSqlStatement( cSentenceDBF )

   next 

RETURN ( Self )

//---------------------------------------------------------------------------//
