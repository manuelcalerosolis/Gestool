#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS AlbaranesClientesModel FROM BaseModel

   METHOD getHeaderTableName()                  INLINE ::getEmpresaTableName( "AlbCliT" )

   METHOD Riesgo( idCliente )
   
   METHOD UltimoDocumento( idCliente )

END CLASS

//---------------------------------------------------------------------------//

METHOD Riesgo( idCliente )

   local cStm
   local cSql  := "SELECT SUM( nTotAlb - nTotPag ) AS nRiesgo " + ;
                     "FROM " + ::getHeaderTableName() + " " + ;
                     "WHERE cCodCli = " + quoted( idCliente ) + " AND NOT lFacturado"

   if ::ExecuteSqlStatement( cSql, @cStm )
      Return( ( cStm )->nRiesgo )
   end if 

Return ( 0 )

//---------------------------------------------------------------------------//

METHOD UltimoDocumento( idCliente )

   local cStm
   local cSql  := "SELECT TOP 1 dFecAlb " + ;
                     "FROM " + ::getHeaderTableName() + " " + ;
                     "WHERE cCodCli = " + quoted( idCliente ) + " ORDER BY dFecAlb DESC"

   if ::ExecuteSqlStatement( cSql, @cStm )
      Return ( ( cStm )->dFecAlb )
   end if 

Return ( ctod( "" ) )

//---------------------------------------------------------------------------//

