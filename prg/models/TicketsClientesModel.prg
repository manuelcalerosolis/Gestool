#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS TicketsClientesModel FROM ADSBaseModel

   METHOD getTableName()                     INLINE ::getEmpresaTableName( "TikeT" )

   METHOD Riesgo( idCliente )

   METHOD existId() 
   METHOD existUuid()

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

RETURN ( nRiesgo )

//---------------------------------------------------------------------------//

METHOD existId( cSerie, nNumero, cSufijo )

   local cStm
   local cSql  := "SELECT TOP 1 cNumTik"                                   + " " + ;
                     "FROM " + ::getTableName()                            + " " + ;
                  "WHERE cSerTik + LTRIM( cNumTik ) + cSufTik = " + quoted( cSerie + alltrim( str( nNumero ) ) + cSufijo )

   if ::ExecuteSqlStatement( cSql, @cStm )
      RETURN ( !empty( ( cStm )->( fieldget( 1 ) ) ) )
   end if 

RETURN ( .f. )

//---------------------------------------------------------------------------//

METHOD existUuid( uuid )

   local cStm
   local cSql  := "SELECT TOP 1 cNumTik"                                   + " " + ;
                     "FROM " + ::getTableName()                            + " " + ;
                  "WHERE uuid = " + quoted( uuid )

   if ::ExecuteSqlStatement( cSql, @cStm )
      RETURN ( !empty( ( cStm )->( fieldget( 1 ) ) ) )
   end if 

RETURN ( .f. )

//---------------------------------------------------------------------------//
