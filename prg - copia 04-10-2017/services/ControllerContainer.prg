#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Ads.ch"

//---------------------------------------------------------------------------//

CLASS ControllerContainer 

	DATA  hControllers                                 INIT {=>}

   METHOD New()

   METHOD add( cController, oController )             INLINE ( hset( ::hControllers, cController, oController ) )
   METHOD get( cController )                          INLINE ( hget( ::hControllers, cController ) )
   METHOD getControllers()                            INLINE ( ::hControllers )

END CLASS

//---------------------------------------------------------------------------//

METHOD New()

   ::hControllers                                     := {=>}

RETURN ( Self )

//---------------------------------------------------------------------------//