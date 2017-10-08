#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS DivisasModel FROM ADSBaseModel

   METHOD getTableName()                  INLINE ::getDatosTableName( "Divisas" ) 

   METHOD exist()

   METHOD getNombre()

END CLASS

//---------------------------------------------------------------------------//

METHOD exist( cCodigoDivisa )

   local cStm
   local cSql  := "SELECT cCodDiv "                               + ;
                     "FROM " + ::getTableName() + " "             + ;
                     "WHERE cCodDiv = " + quoted( cCodigoDivisa ) 

   if ::ExecuteSqlStatement( cSql, @cStm )
      RETURN ( ( cStm )->( lastrec() ) > 0 )
   end if 

RETURN ( .f. )

//---------------------------------------------------------------------------//

METHOD getNombre( cCodigoDivisa )

   local cStm
   local cSql  := "SELECT cNomDiv "                               + ;
                     "FROM " + ::getTableName() + " "             + ;
                     "WHERE cCodDiv = " + quoted( cCodigoDivisa ) 

   if ::ExecuteSqlStatement( cSql, @cStm )
      RETURN ( ( cStm )->cNomDiv )
   end if 

RETURN ( "" )

//---------------------------------------------------------------------------//

