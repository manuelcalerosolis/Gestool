#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS RecibosClientesModel FROM ADSBaseModel

   METHOD getTableName()                     INLINE ::getEmpresaTableName( "FacCliP" )

   METHOD Riesgo( idCliente )

END CLASS

//---------------------------------------------------------------------------//

METHOD Riesgo( idCliente )

   local cSql
   local cStm
   local nRiesgo  := 0

   cSql           := "SELECT SUM( nImporte ) AS nRiesgo " + ;
                        "FROM " + ::getTableName() + " " + ;
                        "WHERE cCodCli = " + quoted( idCliente ) + " AND NOT lCobrado AND NOT lPasado"

   if ::ExecuteSqlStatement( cSql, @cStm )
      nRiesgo     += ( cStm )->nRiesgo
   end if 

Return ( nRiesgo )

//---------------------------------------------------------------------------//
