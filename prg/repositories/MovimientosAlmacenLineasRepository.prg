#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Hdo.ch"

//---------------------------------------------------------------------------//

CLASS MovimientosAlmacenLineasRepository FROM SQLBaseRepository

   METHOD getTableName()         INLINE ( if( !empty( ::getController() ), ::getModelTableName(), SQLMovimientosAlmacenLineasModel():getTableName() ) )

   METHOD getSQLSentenceFechaCaducidad( cCodigoArticulo, cValorPrimeraPropiedad, cValorSegundaPropiedad, cLote )

END CLASS

//---------------------------------------------------------------------------//

METHOD getSQLSentenceFechaCaducidad( cCodigoArticulo, cValorPrimeraPropiedad, cValorSegundaPropiedad, cLote )

   local cSql  := "SELECT "                                                      + ;
                     "codigo_articulo, "                                         + ;
                     "valor_primera_propiedad, "                                 + ;
                     "valor_segunda_propiedad, "                                 + ;                     
                     "lote, "                                                    + ;
                     "fecha_caducidad "                                          + ;
                  "FROM " + ::getTableName() + " "                               + ;
                  "WHERE codigo_articulo = " + quoted( cCodigoArticulo ) + " "   + ;
                     "AND fecha_caducidad IS NOT NULL "       

   if !empty(cValorPrimeraPropiedad)
      cSql     +=    "AND valor_primera_propiedad = " + quoted( cValorPrimeraPropiedad ) + " "   
   end if 

   if !empty(cValorSegundaPropiedad)
      cSql     +=    "AND valor_segunda_propiedad = " + quoted( cValorSegundaPropiedad ) + " "   
   end if 

   if !empty(cLote)
      cSql     +=    "AND lote = " + quoted( cLote ) + " "
   end if 

RETURN ( cSql )

//---------------------------------------------------------------------------//