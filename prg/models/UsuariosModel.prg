#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS UsuariosModel FROM ADSBaseModel

   METHOD getTableName()                        INLINE ::getDatosTableName( "Users" )

   METHOD UpdateEmpresaEnUso( cCodigoUsuario, cCodigoEmpresa ) 

END CLASS

//---------------------------------------------------------------------------//

METHOD UpdateEmpresaEnUso( cCodigoUsuario, cCodigoEmpresa ) 

   local cStm
   local cSql  := "UPDATE " + ::getTableName() + " " +                  ;
                  "SET cEmpUse = " + quoted( cCodigoEmpresa ) + " " +   ;
                  "WHERE cCodUse = " + quoted( cCodigoUsuario )

RETURN ( ::ExecuteSqlStatement( cSql, @cStm ) )

//------------------------------------------------------------------------//
