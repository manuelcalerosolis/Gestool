#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS FacturasClientesModel FROM ADSBaseModel

   METHOD getHeaderTableName()                  INLINE ::getEmpresaTableName( "FacCliT" )

   METHOD UltimoDocumento( cCodigoCliente )

   METHOD defaultSufijo()

END CLASS

//---------------------------------------------------------------------------//

METHOD UltimoDocumento( cCodigoCliente )

   local cStm
   local cSql  := "SELECT TOP 1 dFecFac " + ;
                     "FROM " + ::getHeaderTableName() + " " + ;
                     "WHERE cCodCli = " + quoted( cCodigoCliente ) + " ORDER BY dFecFac DESC"

   if ::ExecuteSqlStatement( cSql, @cStm )
      RETURN ( ( cStm )->dFecFac )
   end if 

RETURN ( ctod( "" ) )

//---------------------------------------------------------------------------//

METHOD defaultSufijo()

   local cStm
   local cSql  := "UPDATE " + ::getHeaderTableName() + ;
                     " SET cSufFac = '00'" + ;
                     " WHERE cSufFac = ''"

RETURN ( ::ExecuteSqlStatement( cSql, @cStm ) )

//---------------------------------------------------------------------------//

