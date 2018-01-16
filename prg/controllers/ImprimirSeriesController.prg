#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS ImprimirSeriesController FROM SQLBaseController

   METHOD New()

   METHOD Activate()

   METHOD Print()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController )

   ::Super:New( oController )

   ::oDialogView           := ImprimirSeriesView():New( self )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Activate()

   ::oDialogView:Activate()
   
RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Print() 

   msgalert( "Print") 

RETURN ( Self )

//----------------------------------------------------------------------------//

