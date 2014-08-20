#include "HbClass.ch"
#include "Fivewin.ch"

//----------------------------------------------------------------------------//

CLASS TApoloMeter FROM TMeter

   DATA nCurrent    INIT 0

   METHOD AutoInc() INLINE ;
      ::nCurrent++,;
      if( ( ::nTotal < 100 ) .or. ( Mod( ::nCurrent, Int( ::nTotal / 100 ) ) == 0 ), ::Set( ::nCurrent ), nil )

   METHOD SetTotal( nTotal ) INLINE ;
      ::nTotal      := nTotal ,;
      ::nCurrent    := 0 ,;
      ::Refresh()

ENDCLASS

//----------------------------------------------------------------------------//
