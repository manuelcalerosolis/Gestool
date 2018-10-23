#include "FiveWin.Ch"
#include "Factu.Ch"

//------------------------------------------------------------------------//

CLASS SQLSelectorView FROM SQLBrowseableView 

   DATA oDialog

   DATA oGetSearch
   DATA cGetSearch                              INIT space( 200 )

   DATA bInitActivate

   DATA hSelectedBuffer

   DATA aSelectedBuffer

   DATA lMultiselect                            INIT ( .f. )

   METHOD New( oController )
   METHOD End()

   METHOD Activate( bInitActivate )
      METHOD ActivateMoved()                    INLINE ( ::Activate( .f. ) )
      METHOD initActivate()                     INLINE ( iif( hb_isblock( ::bInitActivate ), eval( ::bInitActivate, Self ), ) )

   METHOD isActive()                            INLINE ( ::oDialog != nil )

   METHOD Select()

   METHOD MonoSelect()

   METHOD MultiSelect()

   METHOD setLogicMultiselect( lMultiselect )   INLINE ( ::lMultiselect := lMultiselect )

   METHOD Start()

   METHOD getGetSearch()                        INLINE ( ::oGetSearch )
   METHOD getWindow()                           INLINE ( ::oDialog )

   METHOD getSelectedBuffer()                   INLINE ( if( ::lMultiselect, ::aSelectedBuffer, ::hSelectedBuffer ) )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( oController )

   ::Super:New( oController )

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD End()

   if !empty( ::oDialog )
      ::oDialog:End()
   end if 
   
   ::Super:End()

   ::oDialog               := nil

   self                    := nil

RETURN ( nil )

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

      // Menu------------------------------------------------------------------

      ::getMenuTreeView():ActivateDialog( ::oDialog, 120 )

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

METHOD Select()

   ::hSelectedBuffer       := {=>}

   ::aSelectedBuffer       := {}

   if ::lMultiselect
      
      ::MultiSelect()

   else

      ::MonoSelect()

   end if

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD MonoSelect()

   local nId            := ::getBrowseView():getRowSet():fieldGet( 'id' )

   if !empty( nId )
      ::hSelectedBuffer := ::getModel():loadCurrentBuffer( nId )
   end if 

   ::oDialog:End( IDOK )

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD MultiSelect()

   local aIds
   local nId
   
   ::aSelectedBuffer       := {}

   aIds        := ::getBrowseView():getRowSet():IdFromRecno( ::getBrowseView():oBrowse:aSelected )

   for each nId in aIds
      aAdd( ::aSelectedBuffer, ::getModel():loadCurrentBuffer( nId ) )
   next

   ::oDialog:End( IDOK )

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD Start()

   ::hSelectedBuffer    := nil      

   ::oMenuTreeView:Default()

   ::oMenuTreeView:AddSelectorButtons()

   ::oController:restoreState()

   ::oGetSearch:setFocus()

RETURN ( Self )

//----------------------------------------------------------------------------//

