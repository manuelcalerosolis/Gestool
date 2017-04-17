#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS ArticulosModel FROM BaseModel

   METHOD getHeaderTableName()                  INLINE ::getEmpresaTableName( "Articulo" )
   METHOD getPropiedadesLineasName()            INLINE ::getEmpresaTableName( "TblPro" )

   METHOD getValoresPropiedades( cCodPro )

END CLASS

//---------------------------------------------------------------------------//

METHOD getValoresPropiedades( cCodPro, cArea ) CLASS ArticulosModel

   local cSql  := "SELECT cDesTbl FROM " + ::getPropiedadesLineasName() + " WHERE cCodPro = " + quoted( cCodPro )

   MsgInfo( cSql )

Return ( ::ExecuteSqlStatement( cSql, @cArea ) )

//---------------------------------------------------------------------------//