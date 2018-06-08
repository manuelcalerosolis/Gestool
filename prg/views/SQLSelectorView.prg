#include "FiveWin.Ch"
#include "Factu.Ch"

//------------------------------------------------------------------------//

CLASS SQLSelectorView FROM SQLBrowseableView 

   DATA oDialog

   DATA oGetSearch
   DATA cGetSearch                        INIT space( 200 )

   DATA oComboBoxOrder
   DATA cComboBoxOrder

   DATA bInitActivate

   DATA hSelectedBuffer

   METHOD End()

   METHOD Activate( bInitActivate )
      METHOD ActivateMoved()              INLINE ( ::Activate( .f. ) )
      METHOD initActivate()               INLINE ( iif( hb_isblock( ::bInitActivate ), eval( ::bInitActivate, Self ), ) )

   METHOD isActive()                      INLINE ( ::oDialog != nil )

   METHOD Select()

   METHOD Start()

   METHOD getGetSearch()                  INLINE ( ::oGetSearch )
   METHOD getComboBoxOrder()              INLINE ( ::oComboBoxOrder )
   METHOD getWindow()                     INLINE ( ::oDialog )

   METHOD getSelectedBuffer()             INLINE ( ::hSelectedBuffer )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD Activate( lCenter )

   DEFAULT lCenter         := .t.

   DEFINE DIALOG           ::oDialog ;
      RESOURCE             "SELECTOR_VIEW" ;
      TITLE                ::oController:getTitle()

      REDEFINE GET         ::oGetSearch ;
         VAR               ::cGetSearch ; 
         ID                100 ;
         PICTURE           "@!" ;
         BITMAP            "FIND" ;
         OF                ::oDialog

      REDEFINE COMBOBOX    ::oComboBoxOrder ;
         VAR               ::cComboBoxOrder ;
         ID                110 ;
         OF                ::oDialog

      ::oComboBoxOrder:bChange      := {|| ::onChangeCombo() } 

      // Menu------------------------------------------------------------------

      ::oMenuTreeView:ActivateDialog( ::oDialog, 120 )

      // Browse-----------------------------------------------------------------

      ::getBrowseView():ActivateDialog( ::oDialog, 130 )

      ::getBrowseView():setLDblClick( {|| ::Select() } ) 

      // Eventos---------------------------------------------------------------

      ::oDialog:bStart              := {|| ::Start() }

      ::getGetSearch():bChange      := {|| ::onChangeSearch() } 

   ::oDialog:Activate( , , , lCenter, , .t., {|| ::initActivate() } )

   ::oController:saveState()

RETURN ( ::getSelectedBuffer() )

//----------------------------------------------------------------------------//

METHOD End()

   if !empty( ::oDialog )
      ::oDialog:End()
   end if 

   ::oDialog            := nil

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD Select()

   ::hSelectedBuffer    := ::getModel():loadCurrentBuffer( ::getBrowseView():getRowSet():fieldGet( 'id' ) )

   ::oDialog:End( IDOK )

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD Start()

   ::hSelectedBuffer    := nil      

   ::oMenuTreeView:Default()

   ::oMenuTreeView:AddSelectorButtons()

   ::oComboBoxOrder:SetItems( ::getBrowseView():getColumnsHeaders() )

   ::oComboBoxOrder:Set( ::getBrowseView():getColumnOrderHeader() )

   ::oController:restoreState()

   ::oGetSearch:setFocus()

RETURN ( Self )

//----------------------------------------------------------------------------//

