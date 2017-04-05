#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS FacturasClientesModel FROM BaseModel

   METHOD getHeaderTableName()                  INLINE ::getEmpresaTableName( "FacCliT" )

   METHOD UltimoDocumento( idCliente )

END CLASS

//---------------------------------------------------------------------------//

METHOD UltimoDocumento( idCliente )

   local cStm
   local cSql  := "SELECT TOP 1 dFecFac " + ;
                     "FROM " + ::getHeaderTableName() + " " + ;
                     "WHERE cCodCli = " + quoted( idCliente ) + " ORDER BY dFecFac DESC"

   if ::ExecuteSqlStatement( cSql, @cStm )
      Return ( ( cStm )->dFecFac )
   end if 

Return ( ctod( "" ) )

//---------------------------------------------------------------------------//

