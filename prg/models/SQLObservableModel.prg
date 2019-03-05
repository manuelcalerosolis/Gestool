#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Hdo.ch"
#include "HdoCommon.ch"

//---------------------------------------------------------------------------//

CLASS SQLObservableModel FROM SQLCompanyModel

   DATA hInitialBuffer

   DATA hFinalBuffer

   METHOD insertBuffer( hBuffer, lIgnore )

   METHOD updateInsertedBuffer( hBuffer, nId )

   METHOD getBufferChanged()

END CLASS

//---------------------------------------------------------------------------//

METHOD insertBuffer( hBuffer, lIgnore )

   local nId         := ::Super():insertBuffer( hBuffer, lIgnore )

   ::hInitialBuffer  := hClone( ::hBuffer )

RETURN ( nId )

//---------------------------------------------------------------------------//

METHOD updateInsertedBuffer( hBuffer, nId )

   ::Super():updateInsertedBuffer( hBuffer, nId )

   ::hFinalBuffer    := hClone( ::hBuffer )
   
RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD getBufferChanged()

   local aChanges    := {}

   heval( ::hInitialBuffer,;
      {|k,v| if( v != hget( ::hFinalBuffer, k ),;
         aadd( aChanges, { k => { "old" => v, "new" => hget( ::hFinalBuffer, k ) } } ), ) } )

   msgalert( hb_valtoexp( aChanges ) )

RETURN ( aChanges )

//---------------------------------------------------------------------------//

