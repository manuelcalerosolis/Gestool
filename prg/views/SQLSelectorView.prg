#include "FiveWin.Ch"
#include "Factu.Ch"

//------------------------------------------------------------------------//

CLASS SQLSelectorView FROM SQLBrowseableView 

   DATA oDialog

   DATA oGetSearch
   DATA cGetSearch         INIT space( 200 )

   METHOD New( oController )

   METHOD Activate()

   METHOD End()

   METHOD Start()

   METHOD getDialog()      INLINE ( ::oDialog )
   METHOD getGetSearch()   INLINE ( ::oGetSearch )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( oController )

   ::oController           := oController

   DEFINE DIALOG ::oDialog RESOURCE "SELECTOR_VIEW"

      REDEFINE GET         ::oGetSearch;
         VAR               ::cGetSearch;
         ID                100 ;
         PICTURE           "@!" ;
         BITMAP            "FIND" ;
         OF                ::oDialog

      ::oMenuTreeView      := MenuTreeView():New( Self )

      ::oSQLBrowseView     := SQLBrowseView():New( Self )

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD Activate()

   ::oMenuTreeView:DialogActivate( 120 )

   ::oSQLBrowseView:Create( dfnSplitterHeight + dfnSplitterWidth, dfnTreeViewWidth + dfnSplitterWidth, ::oMdiChild:nRight - ::oMdiChild:nLeft, ::oMdiChild:nBottom - ::oMdiChild:nTop )

   ::oSQLBrowseView:GenerateColumns()

   ::oSQLBrowseView:CreateFromCode()
   

   ::oDialog:bStart        := {|| ::Start() }

   ACTIVATE DIALOG ::oDialog CENTER

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD End()

   ::oDialog:End()

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD Start()

   ::oMenuTreeView:Default()

   ::oMenuTreeView:AddAutoButtons()

RETURN ( Self )

//----------------------------------------------------------------------------//

