#include "FiveWin.Ch"

//----------------------------------------------------------------------------//

CLASS TItemAccesos

   DATA  aAccesos
   DATA  cPrompt
   DATA  cMessage
   DATA  bAction
   DATA  cId
   DATA  bWhen
   DATA  cBmp

   METHOD New( hItem, oTree, Cargo ) CONSTRUCTOR

   METHOD Add( cPrompt, nImage, Cargo )

   METHOD DeleteBranches()

   METHOD Expand() INLINE ;
      SendMessage( ::oTree:hWnd, TVM_EXPAND, TVE_EXPAND, ::hItem )

   METHOD Colapse() INLINE ;
      SendMessage( ::oTree:hWnd, TVM_EXPAND, TVE_COLLAPSE, ::hItem )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( hItem, oTree, Cargo, cPrompt, nImage ) CLASS TTVItem

   ::aItems  = {}
   ::hItem   = hItem
   ::oTree   = oTree
   ::Cargo   = Cargo
   ::cPrompt = cPrompt
   ::nImage  = nImage

return Self

//----------------------------------------------------------------------------//

METHOD Add( cPrompt, nImage, Cargo ) CLASS TTVItem

   local oItem := TTVItem():New( TVInsertItem( ::oTree:hWnd, cPrompt,;
                                 ::hItem, nImage ), ::oTree, Cargo, cPrompt, nImage )

   AAdd( ::aItems, oItem )

return oItem

//----------------------------------------------------------------------------//

METHOD DeleteBranches() CLASS TTVItem

   Aeval(::aItems, {|o| TVDeleteItem(::oTree:hWnd, o:hItem) } )

   ::aItems  = {}

return nil