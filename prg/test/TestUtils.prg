//-- copyright
// hbunit is a unit-testing framework for the Harbour language.
//
// Copyright (C) 2014 Enderson maia <endersonmaia _at_ gmail _dot_ com>
//
// This program is free software; you can redistribute it and/or
// modify it under the terms of the GNU General Public License
// as published by the Free Software Foundation; either version 2
// of the License, or (at your option) any later version.
//
// See COPYRIGHT for more details.
//++

#include "hbunit.ch"

//---------------------------------------------------------------------------//

FUNCTION testWaitSeconds( nSecs )

   local n

   for n := 1 to nSecs
      waitSeconds( 1 )
      sysRefresh()
   next

RETURN ( nil )

//---------------------------------------------------------------------------//

FUNCTION testGetControl( nId, oDialog )

   local nPos

   if empty( oDialog ) 
      RETURN ( nil )
   end if 
   
   nPos              := ascan( oDialog:aControls, { | o | o:nId == nId } ) 
   if nPos == 0
      RETURN ( nil )
   end if 

RETURN ( oDialog:aControls[ nPos ] )

//---------------------------------------------------------------------------//
