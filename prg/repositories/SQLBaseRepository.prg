#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Hdo.ch"

//---------------------------------------------------------------------------//

CLASS SQLBaseRepository

   DATA oDatabase

   DATA oController

   METHOD New()

   METHOD getController()        INLINE ( ::oController )

   METHOD setDatabase( oDb )     INLINE ( ::oDatabase := oDb )
   METHOD getDatabase()          INLINE ( if( empty( ::oDatabase ), getSQLDatabase(), ::oDatabase ) )

   METHOD getModel()             INLINE ( ::getController():getModel() )
   METHOD getModelTableName()    INLINE ( ::getController():getModelTableName()  )
   
   METHOD getAll()
   METHOD getColumnWhereId()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController )

   ::oController                 := oController

Return ( Self )

//---------------------------------------------------------------------------//

METHOD getAll() 

   local cSentence               := "SELECT * FROM " + ::getTableName()
   local hResult                 := ::getDatabase():selectFetchHash( cSentence )

RETURN ( hResult )

//---------------------------------------------------------------------------//

METHOD getColumnWhereId( id, cColumn ) 

   local cSentence               
   local hResult

   default cColumn               := "nombre"

   cSentence                     := "SELECT " + cColumn + " FROM " + ::getTableName()  + space( 1 ) + ;
                                       "WHERE id = " + quoted( id )                    + space( 1 ) + ;
                                       "LIMIT 1"
   hResult                       := ::getDatabase():selectFetchHash( cSentence )

   if !empty( hResult )
      RETURN ( hget( atail( hResult ), cColumn ) )
   end if 

RETURN ( "" )

//---------------------------------------------------------------------------//
