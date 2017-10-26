#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS DocumentosModel FROM ADSBaseModel

   METHOD getTableName()                  INLINE ::getEmpresaTableName( "Rdocumen" ) 

   METHOD getWhereTipo()
   METHOD getWhereMovimientosAlmacen()    INLINE ( ::getWhereTipo( "RM" ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD getWhereTipo( cTipo )

   local cStm
   local cSql  := "SELECT * "                               + ;
                     "FROM " + ::getTableName() + " "       + ;
                     "WHERE cTipo = " + quoted( cTipo ) 

   if ::ExecuteSqlStatement( cSql, @cStm )
      RETURN ( ( cStm ) )
   end if 

RETURN ( cStm )

//---------------------------------------------------------------------------//

