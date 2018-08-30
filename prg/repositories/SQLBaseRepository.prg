#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Hdo.ch"

//---------------------------------------------------------------------------//

CLASS SQLBaseRepository

   DATA oDatabase

   DATA oController

   METHOD New()
   METHOD End()                                 

   METHOD getController()                       INLINE ( ::oController )

   METHOD setDatabase( oDb )                    INLINE ( ::oDatabase := oDb )
   METHOD getDatabase()                         INLINE ( if( empty( ::oDatabase ), getSQLDatabase(), ::oDatabase ) )

   METHOD getModel()                            INLINE ( ::getController():getModel() )
   METHOD getModelTableName()                   INLINE ( ::getController():getModelTableName()  )
   
   METHOD getAll()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController )

   ::oController                                := oController

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End()

   ::oController                                := nil

   ::oDatabase                                  := nil

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD getAll() 

   local cSQL     := "SELECT * FROM " + ::getTableName()
   local hResult  := ::getDatabase():selectFetchHash( cSQL )

RETURN ( hResult )

//---------------------------------------------------------------------------//

