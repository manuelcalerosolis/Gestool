#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS Events

   DATA hEvents                                       
 
   METHOD New()
   METHOD End()

   METHOD Set( cEvent, bEvent )     INLINE ( hset( ::hEvents, lower( cEvent ), bEvent ) )

   METHOD Fire( cEvent )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oSenderController )

   ::hEvents                        := {=>}

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD End()

   ::hEvents                        := nil

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD Fire( cEvent )

   local lEvent   := .t.

   cEvent         := lower( cEvent )

   if !hhaskey( ::hEvents, cEvent )
      RETURN ( lEvent )
   end if 

   if !hb_isblock( hget( ::hEvents, cEvent ) )
      RETURN ( lEvent )
   end if 

   lEvent         := eval( hget( ::hEvents, cEvent ) )
   if hb_islogical( lEvent ) .and. !lEvent
      RETURN ( .f. )
   end if

RETURN ( lEvent )

//---------------------------------------------------------------------------//
