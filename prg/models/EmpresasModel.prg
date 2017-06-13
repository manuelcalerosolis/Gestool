#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS EmpresasModel FROM BaseModel

   METHOD getDelegacionTableName()           INLINE ::getDatosTableName( "Delega" )

   METHOD getEmpresaTableName()              INLINE ::getDatosTableName( "Empresa" )

   METHOD UpdateEmpresaCodigoEmpresa()

   METHOD UpdateDelegacionCodigoEmpresa()
   
END CLASS

//---------------------------------------------------------------------------//

METHOD UpdateEmpresaCodigoEmpresa()

   local cStm
   local cSql  := "UPDATE " + ::getEmpresaTableName() + " " + ;
                  "SET CodEmp = CONCAT( '00', TRIM( CodEmp ) ) WHERE ( LENGTH( CodEmp ) < 4 )"

Return ( ::ExecuteSqlStatement( cSql, @cStm ) )

//---------------------------------------------------------------------------//

METHOD UpdateDelegacionCodigoEmpresa()

   local cStm
   local cSql  := "UPDATE " + ::getDelegacionTableName() + " " + ;
                  "SET cCodEmp = CONCAT( '00', TRIM( cCodEmp ) ) WHERE ( LENGTH( cCodEmp ) < 4 )"

Return ( ::ExecuteSqlStatement( cSql, @cStm ) )

//---------------------------------------------------------------------------//


