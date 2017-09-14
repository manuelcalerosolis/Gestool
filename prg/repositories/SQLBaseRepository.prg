#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Hdo.ch"

//---------------------------------------------------------------------------//

CLASS SQLBaseRepository

   DATA oController

   METHOD New()

   METHOD getController()        INLINE ( ::oController )

   METHOD getModel()             INLINE ( ::getController():getModel() )
   METHOD getModelTableName()    INLINE ( ::getController():getModelTableName()  )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController )

   ::oController                 := oController

Return ( Self )

//---------------------------------------------------------------------------//

