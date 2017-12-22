#include "FiveWin.Ch"
#include "Factu.ch" 

//------------------------------------------------------------------//

CLASS TiposArticulosModel FROM ADSBaseModel

   METHOD getTableName()                     INLINE ::getEmpresaTableName( "Tipart" )

   METHOD exist()

END CLASS

//---------------------------------------------------------------------------//

METHOD exist( cCodigoTipoArticulo )

   local cStm  
   local cSql  := "SELECT cNomTip "                                     + ;
                     "FROM " + ::getTableName() + " "                   + ;
                     "WHERE cCodTip = " + quoted( cCodigoTipoArticulo ) 

   if ::ExecuteSqlStatement( cSql, @cStm )
      RETURN ( ( cStm )->( lastrec() ) > 0 )
   end if 

RETURN ( .f. )

//---------------------------------------------------------------------------//

