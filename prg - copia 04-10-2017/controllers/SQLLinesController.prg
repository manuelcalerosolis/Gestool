#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Ads.ch"

//---------------------------------------------------------------------------//

CLASS SQLLinesController FROM SQLBaseController

	DATA  hControllers                                 INIT {=>}

END CLASS

//---------------------------------------------------------------------------//

METHOD New()

   ::hControllers    := {=>}

   ::Super:New()

RETURN ( Self )

//---------------------------------------------------------------------------//