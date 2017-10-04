/*

   This program tests the RAS phonebook entry edit/create function and
   the RAS_Dial() functions


   If you pass a Entry to EditEntry() that doesn't exist it will create it
   and return the name you gave it.  If it exists it will edit it and also
   return the name.

   The RAS_Dial() function has to pass the cEntry,cUsername,cPassword the
   logical is whether you want the dialer to exit if it fails or to retry
   until the user presses cancel.  I use this for server modes.


*/

#include "FiveWin.Ch"

Function Main(cEntry)

local hRas := 0

SET RESOURCES TO "RAS32.DLL"

cEntry := EditEntry(cEntry)

hRas := RAS_Dial(cEntry,'','',.f.)

? 'Connected'

Ras_hangup(hRas)

SET RESOURCES TO

Return NIL