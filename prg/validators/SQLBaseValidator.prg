#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Hdo.ch"

//---------------------------------------------------------------------------//

CLASS SQLBaseValidator

   DATA oController

   DATA hValidators
  
   METHOD New()
   METHOD End()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController )

   ::oController     := oController

Return ( Self )

//---------------------------------------------------------------------------//

METHOD End()
   
RETURN ( nil )

//---------------------------------------------------------------------------//

