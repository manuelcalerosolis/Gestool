#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Hdo.ch"

//---------------------------------------------------------------------------//

CLASS TiposImpresorasValidator

   METHOD Validate( oGet, cColumn )
  
END CLASS

//---------------------------------------------------------------------------//

METHOD Validate( oGet, cColumn )

   msgalert( ::oController:oModel:hBuffer[ cColumn ], "validate" )

RETURN ( .t. )

