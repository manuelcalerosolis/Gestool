#include "FiveWin.Ch"
#include "Factu.ch" 

//------------------------------------------------------------------//

CLASS FamiliasModel FROM ADSBaseModel

   METHOD getTableName()                     INLINE ::getEmpresaTableName( "Familias" )

   METHOD exist()

END CLASS

//---------------------------------------------------------------------------//

METHOD exist( cCodigoFamilia )

   local cStm  
   local cSql  := "SELECT cNomFam "                                     + ;
                     "FROM " + ::getTableName() + " "                   + ;
                     "WHERE cCodFam = " + quoted( cCodigoFamilia ) 

   if ::ExecuteSqlStatement( cSql, @cStm )
      RETURN ( ( cStm )->( lastrec() ) > 0 )
   end if 

RETURN ( .f. )

//---------------------------------------------------------------------------//

