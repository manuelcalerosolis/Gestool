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
   local cValue
   local nCounter := 1
   local cRelationNew
   local cRelationOld
   local cText

   for each cValue in ::hInitialBuffer
  
      if cValue != hget( ::hFinalBuffer, hGetKeyAt(::hInitialBuffer, nCounter ) )

         cRelationNew := ""
         cRelationOld := ""
         cText     := ""

         if hHasKey( hget( ::hColumns, hGetKeyAt( ::hInitialBuffer, nCounter ) ), "relation" )
            
            cRelationNew := eval( hget( hget( ::hColumns, hGetKeyAt( ::hInitialBuffer, nCounter ) ), "relation" ), hget( ::hFinalBuffer, hGetKeyAt(::hInitialBuffer, nCounter ) ) )

            cRelationOld := eval( hget( hget( ::hColumns, hGetKeyAt( ::hInitialBuffer, nCounter ) ), "relation" ), hget( ::hInitialBuffer, hGetKeyAt(::hInitialBuffer, nCounter ) ) )

         end if

         if hHasKey( hget( ::hColumns, hGetKeyAt( ::hInitialBuffer, nCounter ) ), "text" )
            
            cText := hget( hget( ::hColumns, hGetKeyAt( ::hInitialBuffer, nCounter ) ), "text" )

         end if

         aadd( aChanges, { hGetKeyAt(::hInitialBuffer, nCounter ) =>{ "old" => cValue, "new" => hget( ::hFinalBuffer, hGetKeyAt(::hInitialBuffer, nCounter ) ),"relation_old" => cRelationOld, "relation_new" => cRelationNew, "text" => cText } } )

      end if

      nCounter++
   
   next
   

RETURN ( aChanges )

//---------------------------------------------------------------------------//

