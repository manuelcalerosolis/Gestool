#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Hdo.ch"

//---------------------------------------------------------------------------//

CLASS TiposImpresorasRepository

   METHOD New()

   METHOD getAll()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oModel )

   DEFAULT oModel    := TiposImpresorasModel():New()

   ::oModel          := oModel

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD getAll() 

   local cSentence               := "SELECT nombre FROM " + ::getModel():cTableName
   local aTiposImpresoras        := ::getModel():selectFetchArray( cSentence )

   if hb_isnil( aTiposImpresoras )
      aTiposImpresoras           := {}
   end if 

   aadd( aTiposImpresoras, "" )

RETURN ( aTiposImpresoras )

//---------------------------------------------------------------------------//





