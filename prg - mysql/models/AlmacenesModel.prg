#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS AlmacenesModel FROM BaseModel

   METHOD getHeaderTableName()                  INLINE ::getEmpresaTableName( "Almacen" )

   METHOD exist()

   METHOD getNombre()

END CLASS

//---------------------------------------------------------------------------//

METHOD exist( cCodigoAlmacen )

   local cStm
   local cSql  := "SELECT cNomAlm " + ;
                     "FROM " + ::getHeaderTableName() + " "             + ;
                     "WHERE cCodAlm = " + quoted( cCodigoAlmacen ) 

   if ::ExecuteSqlStatement( cSql, @cStm )
      RETURN ( ( cStm )->( lastrec() ) > 0 )
   end if 

RETURN ( .f. )

//---------------------------------------------------------------------------//

METHOD getNombre( cCodigoAlmacen )

   local cStm
   local cSql  := "SELECT cNomAlm " + ;
                     "FROM " + ::getHeaderTableName() + " "             + ;
                     "WHERE cCodAlm = " + quoted( cCodigoAlmacen ) 

   if ::ExecuteSqlStatement( cSql, @cStm )
      RETURN ( ( cStm )->cNomAlm )
   end if 

RETURN ( "" )

//---------------------------------------------------------------------------//

