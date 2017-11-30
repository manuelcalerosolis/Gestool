#include "FiveWin.Ch"
#include "Factu.Ch"

//------------------------------------------------------------------------//

CLASS SQLSelectorView FROM SQLBrowseableView 

   DATA oDialog

   DATA oGetSearch
   DATA cGetSearch                        INIT space( 200 )

   DATA oComboBoxOrder
   DATA cComboBoxOrder

   DATA hSelectedBuffer

   METHOD New( oController )
   METHOD End()

   METHOD Activate()

   METHOD Select()

   METHOD Start()

   METHOD getGetSearch()                  INLINE ( ::oGetSearch )
   METHOD getComboBoxOrder()              INLINE ( ::oComboBoxOrder )
   METHOD getWindow()                     INLINE ( ::oDialog )

   METHOD getSelectedBuffer()             INLINE ( ::hSelectedBuffer )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( oController )

   ::oController           := oController

   ::oMenuTreeView         := MenuTreeView():New( Self )

   ::oBrowseView           := SQLBrowseView():New( Self )

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD Activate()

   DEFINE DIALOG ::oDialog RESOURCE "SELECTOR_VIEW" TITLE ( ::oController:getTitle() )

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

      // Menu------------------------------------------------------------------

      ::oMenuTreeView:ActivateDialog( 120 )

      // Browse-----------------------------------------------------------------

      ::oBrowseView:Activate( 130 )

      ::oBrowseView:setLDblClick( {|| ::Select() } ) 

      // Eventos---------------------------------------------------------------

      ::oDialog:bStart              := {|| ::Start() }

      ::getComboBoxOrder():bChange  := {|| ::onChangeCombo() } 

      ::getGetSearch():bChange      := {|| ::onChangeSearch() } 

   ACTIVATE DIALOG ::oDialog CENTER

RETURN ( ::getSelectedBuffer() )

//----------------------------------------------------------------------------//

METHOD End()

   ::hSelectedBuffer    := nil      

   ::oDialog:End()

   if !empty( ::oMenuTreeView )
      ::oMenuTreeView:End()
   end if 

   if !empty( ::oSQLBrowseView )
      ::oSQLBrowseView:End()
   end if 

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD Select()

   ::hSelectedBuffer    := ::getModel():loadCurrentBuffer()

   ::oDialog:end( IDOK )

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD Start()

   ::oMenuTreeView:Default()

   ::oMenuTreeView:AddSelectorButtons()

   ::getComboBoxOrder():Set( ::getModelHeaderFromColumnOrder() )

   ::getBrowse():selectColumnOrderByHeader( ::getModelHeaderFromColumnOrder() )

RETURN ( Self )

//----------------------------------------------------------------------------//

