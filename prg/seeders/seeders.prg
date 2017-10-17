#include "fivewin.ch"
#include "factu.ch" 
#include "hdo.ch"

//---------------------------------------------------------------------------//

CLASS Seeders

   DATA oSqlDatabase
   DATA cSentencia

   METHOD New()

   METHOD SeederSituaciones()
   METHOD getStatementSituaciones( dbfSitua )  INLINE   ( "INSERT INTO situaciones ( nombre ) VALUES ( " + quoted( ( dbfSitua )->cSitua ) + " )" )

END CLASS

//---------------------------------------------------------------------------//

METHOD New() CLASS Seeders

   ::oSqlDatabase   :=  getSQLDatabase()

   ::SeederSituaciones()

Return ( self )

//---------------------------------------------------------------------------//

METHOD SeederSituaciones() CLASS Seeders

   local cPath       := cPatDat( .t. )
   local dbfSitua

   if ( file( cPath + "Situa.old" ) )
      Return ( self )
   end if

   if !( file( cPath + "Situa.Dbf" ) )
      msgStop( "El fichero " + cPath + "\Situa.Dbf no se ha localizado", "Atención" )  
      Return ( self )
   end if 

   USE ( cPath + "SITUA.Dbf" ) NEW VIA ( 'DBFCDX' ) SHARED ALIAS ( cCheckArea( "SITUA", @dbfSitua ) )

   while !( dbfSitua )->( eof() )

      getSQLDatabase():Exec( ::getStatementSituaciones( dbfSitua ) )

      ( dbfSitua )->( dbSkip() )

   end while

   if dbfSitua != nil
      ( dbfSitua )->( dbCloseArea() )
   end if

   frename( cPath + "Situa.dbf", cPath + "Situa.old" )
   
RETURN ( Self )

//---------------------------------------------------------------------------//

/*TDataCenter():ExecuteSqlStatement( 'SELECT * FROM datosSitua', "resultado" )

( "resultado" )->( dbGoTop() )

while !( "resultado" )->( eof() )

   //getSQLDatabase():Exec( cImportSentence )

   MsgInfo( ( "resultado" )->cSitua )

   ( "resultado" )->( dbSkip() )

end while*/