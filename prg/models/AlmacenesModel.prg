#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS AlmacenesModel FROM ADSBaseModel

   METHOD getTableName()                  INLINE ::getEmpresaTableName( "Almacen" )

   METHOD exist()

   METHOD getNombre( idAlamcen )          INLINE ( ::getField( "cNomAlm", "cCodAlm", idAlamcen ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD exist( cCodigoAlmacen )

   local cStm
   local cSql  := "SELECT cNomAlm "                               + ;
                     "FROM " + ::getTableName() + " "             + ;
                     "WHERE cCodAlm = " + quoted( cCodigoAlmacen ) 

   if ::ExecuteSqlStatement( cSql, @cStm )
      RETURN ( ( cStm )->( lastrec() ) > 0 )
   end if 

RETURN ( .f. )

//---------------------------------------------------------------------------//
