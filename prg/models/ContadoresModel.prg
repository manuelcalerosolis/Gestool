#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS ContadoresModel FROM ADSBaseModel

   METHOD getTableName()                     INLINE ::getEmpresaTableName( "nCount" )

   METHOD getFormatoDefecto( cSerie, cTipoDocumento )

   METHOD getFormatoMovimientosAlmacen()     INLINE ( ::getFormatoDefecto( "A", "nMovAlm" ) )

   METHOD getCopiasDefecto( cSerie, cTipoDocumento )

   METHOD getCopiasMovimientosAlmacen()      INLINE ( ::getCopiasDefecto( "A", "nMovAlm" ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD getFormatoDefecto( cSerie, cTipoDocumento )

   local cStm
   local cSql  := "SELECT Doc" + cSerie + " "                           + ;
                     "FROM " + ::getTableName() + " "                   + ;
                     "WHERE Doc = " + quoted( upper( cTipoDocumento ) )

   if ::ExecuteSqlStatement( cSql, @cStm )
      RETURN ( ( cStm )->( fieldget( 1 ) ) )
   end if 

RETURN ( "" )

//---------------------------------------------------------------------------//

METHOD getCopiasDefecto( cSerie, cTipoDocumento )

   local cStm
   local cSql  := "SELECT Copias" + cSerie + " "                        + ;
                     "FROM " + ::getTableName() + " "                   + ;
                     "WHERE Doc = " + quoted( upper( cTipoDocumento ) )

   if ::ExecuteSqlStatement( cSql, @cStm )
      RETURN ( max( ( cStm )->( fieldget( 1 ) ), 1 ) )
   end if 

RETURN ( 1 )

//---------------------------------------------------------------------------//
