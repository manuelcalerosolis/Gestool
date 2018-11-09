#include "FiveWin.Ch" 
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS Events

   DATA hEvents                                       
 
   METHOD   New() CONSTRUCTOR

   METHOD   End()

   METHOD   Set( cEvent, bEvent )
   METHOD   SetEvent( cEvent, bEvent )    INLINE ( ::Set( cEvent, bEvent ) )

   METHOD   Fire( cEvent )
   METHOD   FireEvent( cEvent )           INLINE ( ::Fire( cEvent ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD New()

   ::hEvents                        := {=>}

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD End()

   ::hEvents                        := nil

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD Set( cEvent, bEvent )

   cEvent   := lower( cEvent )

   if hhaskey( ::hEvents, cEvent )
      aadd( hget( ::hEvents, cEvent ), bEvent )
   else
      hset( ::hEvents, cEvent, { bEvent } )
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD Fire( cEvent, uOther )

   local bEvent
   local lEvent   := .t.

   if empty( ::hEvents )
      RETURN ( .t. )
   end if 

   cEvent         := lower( cEvent )

   if !hhaskey( ::hEvents, cEvent )
      RETURN ( .t. )
   end if 

   if !hb_isarray( hget( ::hEvents, cEvent ) )
      RETURN ( .t. )
   end if 

   for each bEvent in hget( ::hEvents, cEvent )
      
      lEvent      := eval( bEvent, uOther )

      if hb_islogical( lEvent ) .and. !lEvent
         RETURN ( .f. )
      end if

   next 

RETURN ( lEvent )

//---------------------------------------------------------------------------//
