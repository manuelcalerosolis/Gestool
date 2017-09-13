#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Hdo.ch"

//---------------------------------------------------------------------------//

CLASS SQLBaseRepository

   DATA oModel

   METHOD New()

   METHOD getModel()    INLINE ( ::oModel )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oModel )

   ::oModel       := oModel

Return ( Self )

//---------------------------------------------------------------------------//

