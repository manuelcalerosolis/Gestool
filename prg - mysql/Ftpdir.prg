// Testing the FiveWin new Internet Classes

#include "FiveWin.Ch"

//----------------------------------------------------------------------------//

function Main()

   local oInternet := TInternet():New()
   local oFTP      := TFTP():New( "194.224.203.41", oInternet )
   local aFiles

   if ! Empty( oFTP:hFTP )
      aFiles = oFTP:Directory( "plus\test\*.*" )
      AEval( aFiles, { | aFile | MsgInfo( aFile[ 1 ] ) } )
   endif

   oInternet:End()

return nil

//----------------------------------------------------------------------------//