#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS AlbaranesProveedoresLineasModel FROM TransaccionesComercialesLineasModel

   METHOD getTableName()                     INLINE ::getEmpresaTableName( "AlbProvL" )

   METHOD getExtraWhere()                    INLINE ( "AND nCtlStk < 2 AND NOT lFacturado " )

   METHOD getSQLSentenceFechaCaducidad()

END CLASS

//---------------------------------------------------------------------------//

METHOD getSQLSentenceFechaCaducidad( cCodigoArticulo, cValorPrimeraPropiedad, cValorSegundaPropiedad, cLote )

   local cSql  := "SELECT "                                                      + ;
                     "cRef as cCodigoArticulo, "                                 + ;
                     "cValPr1 as cValorPrimeraPropiedad, "                       + ;
                     "cValPr2 as cValorSegundaPropiedad, "                       + ;
                     "cLote as cLote, "                                          + ;
                     "dFecAlb as dFechaDocumento, "                              + ;
                     "dFecCad as dFechaCaducidad "                               + ;
                  "FROM " + ::getTableName() + " "                               + ;
                  "WHERE cRef = " + quoted( cCodigoArticulo ) + " "              + ;
                     "AND dFecCad IS NOT NULL "       

   cSql        +=    ::getExtraWhere()                                

   if !empty(cValorPrimeraPropiedad)
      cSql     +=    "AND cValPr1 = " + quoted( cValorPrimeraPropiedad ) + " "   
   end if 

   if !empty(cValorSegundaPropiedad)
      cSql     +=    "AND cValPr2 = " + quoted( cValorSegundaPropiedad ) + " "   
   end if 

   if !empty(cLote)
      cSql     +=    "AND cLote = " + quoted( cLote ) + " "
   end if 

RETURN ( cSql )

//---------------------------------------------------------------------------//



