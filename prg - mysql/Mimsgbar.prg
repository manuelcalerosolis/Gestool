#include "FiveWin.Ch"

//----------------------------------------------------------------------------//

CLASS TMiMsgBar FROM TMsgBar

   DATA  nOldHeight

   METHOD Adjust()

   METHOD AdjTop() INLINE WndAdjTop( ::hWnd )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD Adjust() CLASS TMsgBar

   local rctParent := ::oWnd:GetCliRect()
   local nTop, nBottom

   if ::nOldHeight == nil
      ::nOldHeight := ::nHeight
   end if

   nTop := rctParent:nBottom - ::nOldHeight

   if ::oBottom != Nil
      nTop  := rctParent:nBottom - ::nOldHeight - ::oBottom:nHeight
   endif

   nBottom := nTop + ::nOldHeight + ::oBottom:nHeight

   ::SetCoors( TRect():New( nTop , rctParent:nLeft - 1, nBottom, rctParent:nRight ) )

return nil

//----------------------------------------------------------------------------//