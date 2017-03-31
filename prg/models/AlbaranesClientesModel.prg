#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS AlbaranesClientesModel FROM BaseModel

   METHOD getHeaderTableName()                  INLINE ::getEmpresaTableName( "AlbCliT" )

   METHOD Riesgo( idCliente )

END CLASS

//---------------------------------------------------------------------------//

METHOD Riesgo( idCliente )

   local cSql
   local cStm
   local nRiesgo  := 0

   cSql           := "SELECT SUM( nTotAlb - nTotPag ) AS nRiesgo " + ;
                        "FROM " + ::getHeaderTableName() + " " + ;
                        "WHERE cCodCli = " + quoted( idCliente ) + " AND NOT lFacturado"

   if ::ExecuteSqlStatement( cSql, @cStm )
      nRiesgo     += ( cStm )->nRiesgo
   end if 

Return ( nRiesgo )

//---------------------------------------------------------------------------//
