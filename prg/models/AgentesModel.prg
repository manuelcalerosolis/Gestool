#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS AgentesModel FROM ADSBaseModel

   METHOD getTableName()                     INLINE ::getEmpresaTableName( "Agentes" )

   METHOD exist( cCodigoAgente )

   METHOD getNombre( cCodigoAgente )

END CLASS

//---------------------------------------------------------------------------//

METHOD exist( cCodigoAgente )

   local cStm
   local cSql  := "SELECT cCodAge "                               + ;
                     "FROM " + ::getTableName() + " "             + ;
                     "WHERE cCodAge = " + quoted( cCodigoAgente ) 

   if ::ExecuteSqlStatement( cSql, @cStm )
      RETURN ( ( cStm )->( lastrec() ) > 0 )
   end if 

RETURN ( .f. )

//---------------------------------------------------------------------------//

METHOD getNombre( cCodigoAgente )

   local cStm
   local cSql  := "SELECT cApeAge, cNbrAge "                      + ;
                     "FROM " + ::getTableName() + " "             + ;
                     "WHERE cCodAge = " + quoted( cCodigoAgente ) 

   if ::ExecuteSqlStatement( cSql, @cStm )
      RETURN ( alltrim( ( cStm )->cApeAge ) + ", " + alltrim( ( cStm )->cNbrAge ) )
   end if 

RETURN ( "" )

//---------------------------------------------------------------------------//

