#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS TicketsClientesModel FROM ADSBaseModel

   METHOD getHeaderTableName()                     INLINE ::getEmpresaTableName( "TikeT" )

   METHOD Riesgo( idCliente )

END CLASS

//---------------------------------------------------------------------------//

METHOD Riesgo( idCliente )

   local cSql
   local cStm
   local nRiesgo  := 0

   cSql           := "SELECT SUM( nTotTik - nCobTik ) AS nRiesgo " + ;
                        "FROM " + ::getHeaderTableName() + " " + ;
                        "WHERE cCliTik = " + quoted( idCliente ) + " AND lLiqTik AND ( cTipTik = '1' OR cTipTik = '7' )"

   if ::ExecuteSqlStatement( cSql, @cStm )
      nRiesgo     += ( cStm )->nRiesgo
   end if 

Return ( nRiesgo )

//---------------------------------------------------------------------------//
