// Trees management for Clipper !!!

#include "FiveWin.Ch"

static aTrees := {}
static nLevel := 0

static hBmpOpen, hBmpClose

//----------------------------------------------------------------------------//
/*
function TreeBegin( cBmpOpen, cBmpClose )

   local oTree := TLinkList():New()

   if ! Empty( cBmpOpen )
      hBmpOpen = LoadBitmap( GetResources(), cBmpOpen )
   endif

   if ! Empty( cBmpClose )
      hBmpClose = LoadBitmap( GetResources(), cBmpClose )
   endif

   AAdd( aTrees, oTree )
   nLevel++

return oTree
*/
//----------------------------------------------------------------------------//

function _TreeItem( cPrompt, cResName1, cResName2, cBmpOpen, cBmpClose, lOpened, nHndName1, nHndName2 )

   local hBmpOpen, hBmpClose

   if ! Empty( cResName1 )
      hBmpOpen  = LoadBitmap( GetResources(), cResName1 )
      hBmpClose = hBmpOpen
   endif

   if ! Empty( cResName2 )
      hBmpClose = LoadBitmap( GetResources(), cResName2 )
   endif

   if ! Empty( cBmpOpen )
      hBmpOpen  = ReadBitmap( 0, cBmpOpen )
      hBmpClose = hBmpOpen
   endif

   if ! Empty( cBmpClose )
      hBmpClose = ReadBitmap( 0, cBmpClose )
   endif

   if ! Empty( nHndName1 )
      hBmpOpen  = nHndName1
      hBmpClose = hBmpOpen
   endif

   if ! Empty( nHndName2 )
      hBmpOpen  = nHndName2
   endif


return ATail( aTrees ):Add( cPrompt, nLevel, hBmpOpen, hBmpClose, lOpened )

//----------------------------------------------------------------------------//
/*
function TreeEnd()

   local oTree := ATail( aTrees )
   local oItem

   if Len( aTrees ) > 1
      ASize( aTrees, Len( aTrees ) - 1 )
      oItem = ATail( aTrees ):oLast
      oItem:oTree = oTree
      if oItem:hBmpOpen == nil
         oItem:hBmpOpen = hBmpOpen
      endif
      if oItem:hBmpClose == nil
         oItem:hBmpClose = hBmpClose
      endif
      oTree:oFirst:oPrev = ATail( aTrees ):oLast
   else
      aTrees = {}
   endif

   nLevel--

return nil
*/
//----------------------------------------------------------------------------//