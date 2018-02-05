#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS UsuariosModel FROM ADSBaseModel

   METHOD getTableName()            INLINE ::getDatosTableName( "Users" )

   METHOD getNombre( idUsuario )    INLINE ( ::getField( "cNbrUse", "cCodUse", idUsuario ) )

   METHOD UpdateEmpresaEnUso( cCodigoUsuario, cCodigoEmpresa ) 

   METHOD getUsuariosToJson()

END CLASS

//---------------------------------------------------------------------------//

METHOD UpdateEmpresaEnUso( cCodigoUsuario, cCodigoEmpresa ) 

   local cStm
   local cSql  := "UPDATE " + ::getTableName() + " "                    + ;
                     "SET cEmpUse = " + quoted( cCodigoEmpresa ) + " "  + ;
                     "WHERE cCodUse = " + quoted( cCodigoUsuario )

RETURN ( ::ExecuteSqlStatement( cSql, @cStm ) )

//------------------------------------------------------------------------//

METHOD getUsuariosToJson( cArea )

   local cSql  := "SELECT cCodUse, cNbrUse "                            + ;
                     "FROM " + ::getTableName() 

RETURN ( ::ExecuteSqlStatement( cSql, @cArea ) )

//---------------------------------------------------------------------------//


