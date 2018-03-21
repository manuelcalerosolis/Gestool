#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Hdo.ch"

//---------------------------------------------------------------------------//

CLASS SQLBaseRepository

   DATA oDatabase

   DATA oController

   METHOD New()
   METHOD End()                  VIRTUAL

   METHOD getController()        INLINE ( ::oController )

   METHOD setDatabase( oDb )     INLINE ( ::oDatabase := oDb )
   METHOD getDatabase()          INLINE ( if( empty( ::oDatabase ), getSQLDatabase(), ::oDatabase ) )

   METHOD getModel()             INLINE ( ::getController():getModel() )
   METHOD getModelTableName()    INLINE ( ::getController():getModelTableName()  )
   
   METHOD getAll()
   
   METHOD getColumnWhereId()
   METHOD getColumnWhereUuid( uuid, cColumn ) 

   METHOD getNombres( cColumn )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController )

   ::oController                 := oController

Return ( Self )

//---------------------------------------------------------------------------//

METHOD getAll() 

   local cSQL                    := "SELECT * FROM " + ::getTableName()
   local hResult                 := ::getDatabase():selectFetchHash( cSQL )

RETURN ( hResult )

//---------------------------------------------------------------------------//

METHOD getColumnWhereId( id, cColumn ) 

   local cSQL               

   DEFAULT cColumn               := "nombre"

   cSQL                          := "SELECT " + cColumn + " FROM " + ::getTableName()  + space( 1 ) + ;
                                       "WHERE id = " + quoted( id )                    + space( 1 ) + ;
                                       "LIMIT 1"

RETURN ( ::getDatabase():getValue( cSQL ) )

//---------------------------------------------------------------------------//

METHOD getColumnWhereUuid( uuid, cColumn ) 

   local cSQL               

   DEFAULT cColumn               := "nombre"

   cSQL                          := "SELECT " + cColumn + " FROM " + ::getTableName()  + space( 1 ) + ;
                                       "WHERE uuid = " + quoted( uuid )                + space( 1 ) + ;
                                       "LIMIT 1"

RETURN ( ::getDatabase():getValue( cSQL ) )

//---------------------------------------------------------------------------//

METHOD getNombres( cColumn ) 

   local cSQL                    
   
   DEFAULT cColumn               := "nombre"
   
   cSQL                          := "SELECT " + cColumn + "  FROM " + ::getTableName()

RETURN ( ::getDatabase():selectFetchArrayOneColumn( cSQL ) )

//---------------------------------------------------------------------------//
