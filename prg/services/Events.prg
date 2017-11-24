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

   if empty( ::hEvents )
      RETURN ( .t. )
   end if 

   cEvent         := lower( cEvent )

   if !hhaskey( ::hEvents, cEvent )
      RETURN ( .t. )
   end if 

   if !hb_isblock( hget( ::hEvents, cEvent ) )
      RETURN ( .t. )
   end if 

   lEvent         := eval( hget( ::hEvents, cEvent ) )
   if hb_islogical( lEvent ) .and. !lEvent
      RETURN ( .f. )
   end if

RETURN ( lEvent )

//---------------------------------------------------------------------------//
