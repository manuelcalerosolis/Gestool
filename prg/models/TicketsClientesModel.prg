#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS TicketsClientesModel FROM ADSBaseModel

   METHOD getTableName()                     INLINE ::getEmpresaTableName( "TikeT" )

   METHOD Riesgo( idCliente )

   METHOD createFromHash( hTicket )

END CLASS

//---------------------------------------------------------------------------//

METHOD Riesgo( idCliente )

   local cSql
   local cStm
   local nRiesgo  := 0

   cSql           := "SELECT SUM( nTotTik - nCobTik ) AS nRiesgo " + ;
                        "FROM " + ::getTableName() + " " + ;
                        "WHERE cCliTik = " + quoted( idCliente ) + " AND lLiqTik AND ( cTipTik = '1' OR cTipTik = '7' )"

   if ::ExecuteSqlStatement( cSql, @cStm )
      nRiesgo     += ( cStm )->nRiesgo
   end if 

Return ( nRiesgo )

//---------------------------------------------------------------------------//

METHOD createFromHash( hTicket )

   local cSql
   local cStm

   cSql        := ::getInsertStatement( hTicket )

   RETURN ( msgalert( cSql, "cSql" ) )

   if ::ExecuteSqlStatement( cSql, @cStm )
      msgalert( "ok" )
   end if 

RETURN ( Self )

//---------------------------------------------------------------------------//
