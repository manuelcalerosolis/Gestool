// Win95 Class TTreeView items support ( TTVItem --> TreeViewItem )

#include "FiveWin.Ch"

#define TV_FIRST          4352   // 0x1100
#define TVM_EXPAND        TV_FIRST + 2

#define TVE_COLLAPSE      1
#define TVE_EXPAND        2
#define TVE_TOGGLE        3

#define TVM_ENSUREVISIBLE TV_FIRST + 20
#define TVM_GETITEMSTATE  TV_FIRST + 39

//----------------------------------------------------------------------------//

CLASS TTVItem

   DATA   hItem
   DATA   oTree
   DATA   aItems
   DATA   cPrompt
   DATA   nImage
   DATA   bAction
   DATA   Cargo

   METHOD New( hItem, oTree, bAction ) CONSTRUCTOR

   METHOD Add( cPrompt, nImage, bAction )

   METHOD DeleteBranches()

   METHOD Expand() INLINE ;
      SendMessage( ::oTree:hWnd, TVM_EXPAND, TVE_EXPAND, ::hItem )

   METHOD Colapse() INLINE ;
      SendMessage( ::oTree:hWnd, TVM_EXPAND, TVE_COLLAPSE, ::hItem )

   METHOD Toggle() INLINE ;
      SendMessage( ::oTree:hWnd, TVM_EXPAND, TVE_TOGGLE, ::hItem )

   METHOD MakeVisible() INLINE ;
      SendMessage( ::oTree:hWnd, TVM_ENSUREVISIBLE, 0, ::hItem )

   METHOD SetCheck( lOnOff ) INLINE ::oTree:SetCheck( Self, lOnOff )

   METHOD End() INLINE TVDeleteItem( ::oTree:hWnd, ::hItem )   

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( hItem, oTree, bAction, cPrompt, nImage ) CLASS TTVItem

   ::aItems  = {}
   ::hItem   = hItem
   ::oTree   = oTree
   ::bAction = bAction
   ::cPrompt = cPrompt
   ::nImage  = nImage

return Self

//----------------------------------------------------------------------------//

METHOD Add( cPrompt, nImage, bAction ) CLASS TTVItem

   local oItem := TTVItem():New( TVInsertItem( ::oTree:hWnd, cPrompt,;
                                 ::hItem, nImage ), ::oTree, bAction, cPrompt, nImage )

   AAdd( ::aItems, oItem )

return oItem

//----------------------------------------------------------------------------//

METHOD DeleteBranches() CLASS TTVItem

   Aeval(::aItems, {|o| TVDeleteItem(::oTree:hWnd, o:hItem) } )

   ::aItems  = {}

return nil

//----------------------------------------------------------------------------//