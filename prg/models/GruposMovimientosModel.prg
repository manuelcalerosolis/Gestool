#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS GruposMovimientosModel FROM BaseModel

   METHOD getHeaderTableName()                  INLINE ::getDatosTableName( "TMov" )

   METHOD exist()

   METHOD getNombre()

END CLASS

//---------------------------------------------------------------------------//

METHOD exist( cCodigoGrupo )

   local cStm
   local cSql  := "SELECT cDesMov " + ;
                     "FROM " + ::getHeaderTableName() + " "             + ;
                     "WHERE cCodMov = " + quoted( cCodigoGrupo ) 

   if ::ExecuteSqlStatement( cSql, @cStm )
      RETURN ( ( cStm )->( lastrec() ) > 0 )
   end if 

RETURN ( .f. )

//---------------------------------------------------------------------------//

METHOD getNombre( cCodigoGrupo )

   local cStm
   local cSql  := "SELECT cDesMov " + ;
                     "FROM " + ::getHeaderTableName() + " "             + ;
                     "WHERE cCodMov = " + quoted( cCodigoGrupo ) 

   if ::ExecuteSqlStatement( cSql, @cStm )
      RETURN ( ( cStm )->cDesMov )
   end if 

RETURN ( "" )

//---------------------------------------------------------------------------//

