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

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController )

   ::oController                 := oController

Return ( Self )

//---------------------------------------------------------------------------//

