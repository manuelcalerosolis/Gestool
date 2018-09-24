#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Hdo.ch"

//---------------------------------------------------------------------------//

CLASS SQLBaseRepository

   DATA oController

   METHOD New()
   METHOD End()                                 

   METHOD getController()                       INLINE ( ::oController )

   METHOD getDatabase()                         INLINE ( getSQLDatabase() )

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

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD getAll() 

   local cSQL     := "SELECT * FROM " + ::getTableName()
   local hResult  := ::getDatabase():selectFetchHash( cSQL )

RETURN ( hResult )

//---------------------------------------------------------------------------//

