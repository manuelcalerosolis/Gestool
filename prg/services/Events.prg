#include "FiveWin.Ch" 
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS Events

   DATA hEvents                                       
 
   METHOD   New() CONSTRUCTOR

   METHOD   End()

   METHOD   Set( cEvent, bEvent )
   METHOD   Add( cEvent, bEvent )
   
   METHOD   setEvent( cEvent, bEvent ) INLINE ( ::Set( cEvent, bEvent ) )
   METHOD   setEvents( aEvents, bEvent )

   METHOD   Fire( cEvent )
   METHOD   fireEvent( cEvent )        INLINE ( ::Fire( cEvent ) )

   METHOD   eventsToString()           INLINE ( hb_valtoexp( ::hEvents ) )

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

   hset( ::hEvents, lower( cEvent ), { bEvent } )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD Add( cEvent, bEvent )

   if hhaskey( ::hEvents, lower( cEvent ) )
      aadd( hget( ::hEvents, lower( cEvent ) ), bEvent )
      RETURN ( nil )
   end if 

RETURN ( ::Set( cEvent, bEvent ) )

//---------------------------------------------------------------------------//

METHOD setEvents( aEvents, bEvent )

RETURN ( aeval( aEvents, {|cEvent| ::setEvent( cEvent, bEvent ) } ) )

//----------------------------------------------------------------------------//

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

      msgalert( cEvent, "evento lanzado")
      
      lEvent      := eval( bEvent, uOther )

      if hb_islogical( lEvent ) .and. !lEvent
         RETURN ( .f. )
      end if

   next 

RETURN ( lEvent )

//---------------------------------------------------------------------------//
