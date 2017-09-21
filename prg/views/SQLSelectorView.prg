#include "FiveWin.Ch"
#include "Factu.Ch"

//------------------------------------------------------------------------//

CLASS SQLSelectorView FROM SQLBrowseableView 

   DATA oDialog

   DATA oGetSearch
   DATA cGetSearch                        INIT space( 200 )

   DATA oComboBoxOrder
   DATA cComboBoxOrder

   METHOD New( oController )

   METHOD Activate()

   METHOD End()

   METHOD Start()

   METHOD getGetSearch()                  INLINE ( ::oGetSearch )
   METHOD getComboBoxOrder()              INLINE ( ::oComboBoxOrder )
   METHOD getWindow()                     INLINE ( ::oDialog )

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

      REDEFINE COMBOBOX    ::oComboBoxOrder ;
         VAR               ::cComboBoxOrder ;
         ID                110 ;
         ITEMS             ::getModelHeadersForBrowse() ;
         OF                ::oDialog

      ::oMenuTreeView      := MenuTreeView():New( Self )

      ::oSQLBrowseView     := SQLBrowseView():New( Self )

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD Activate()

   ::oMenuTreeView:ActivateDialog( 120 )

   ::oSQLBrowseView:ActivateDialog( 130 )

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

   ::oMenuTreeView:AddSelectorButtons()

RETURN ( Self )

//----------------------------------------------------------------------------//

