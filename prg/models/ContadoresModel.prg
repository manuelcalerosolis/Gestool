#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS ContadoresModel FROM ADSBaseModel

   METHOD getTableName()                     INLINE ::getEmpresaTableName( "nCount" )

   METHOD getFormatoDefecto( cSerie, cTipoDocumento )

   METHOD getFormatoMovimientosAlmacen()     INLINE ( ::getFormatoDefecto( "A", "nMovAlm" ) )

   METHOD getCopiasDefecto( cSerie, cTipoDocumento )

   METHOD getCopiasMovimientosAlmacen()      INLINE ( ::getCopiasDefecto( "A", "nMovAlm" ) )

   METHOD getNumero( cSerie, cTipoDocumento )
   METHOD getNumeroTicket( cSerie )          INLINE ( ::getNumero( cSerie, "NTIKCLI" ) )

   METHOD setNumero( cSerie, cTipoDocumento, nNumero )
   METHOD setNumeroTicket( cSerie, nNumero ) INLINE ( ::setNumero( cSerie, "NTIKCLI", nNumero ) )

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

METHOD getNumero( cSerie, cTipoDocumento )

   local cStm
   local cSql  := "SELECT " + cSerie + " "                              + ;
                     "FROM " + ::getTableName() + " "                   + ;
                     "WHERE Doc = " + quoted( upper( cTipoDocumento ) )

   if ::ExecuteSqlStatement( cSql, @cStm )
      RETURN ( max( ( cStm )->( fieldget( 1 ) ), 1 ) )
   end if 

RETURN ( 1 )

//---------------------------------------------------------------------------//

METHOD setNumero( cSerie, cTipoDocumento, nNumero )

   local cStm
   local cSql  := "UPDATE " + ::getTableName() + " SET "                + ;
                     cSerie + " = " + quoted( nNumero ) + " "           + ;
                     "WHERE Doc = " + quoted( upper( cTipoDocumento ) )

   if ::ExecuteSqlStatement( cSql, @cStm )
      RETURN ( .t. )
   end if 

RETURN ( .f. )

//---------------------------------------------------------------------------//
