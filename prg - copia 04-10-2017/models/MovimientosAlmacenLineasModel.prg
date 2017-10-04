#include "fivewin.ch"
#include "factu.ch" 

//---------------------------------------------------------------------------//

CLASS MovimientosAlmacenLineasModel FROM ADSBaseModel

   METHOD getTableName()                     INLINE ::getEmpresaTableName( "HisMov" )

   METHOD updateGUID()

END CLASS

//---------------------------------------------------------------------------//

METHOD updateGUID()

   local cStm
   local cSql  := "UPDATE " + ::getHeaderTableName() + ;
                     " SET cGuid = " + quoted( win_uuidcreatestring() ) + ;
                     " WHERE cGuid = ''"

Return ( ::ExecuteSqlStatement( cSql, @cStm ) )

//---------------------------------------------------------------------------//
