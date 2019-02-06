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

   DATA lMultiSelect                            INIT ( .f. )

   METHOD New( oController ) CONSTRUCTOR
   METHOD End()

   METHOD Activate( bInitActivate )
      METHOD ActivateMoved()                    INLINE ( ::Activate( .f. ) )
      METHOD initActivate()                     INLINE ( iif( hb_isblock( ::bInitActivate ), eval( ::bInitActivate, Self ), ) )

   METHOD isActive()                            INLINE ( ::oDialog != nil )

   METHOD Select()

   METHOD MonoSelect()

   METHOD MultiSelect()

   METHOD setMultiSelect( lMultiSelect )        INLINE ( ::lMultiSelect := lMultiSelect )
   METHOD getMultiSelect()                      INLINE ( ::lMultiSelect )

   METHOD Start()

   METHOD getGetSearch()                        INLINE ( ::oGetSearch )
   METHOD getWindow()                           INLINE ( ::oDialog )

   METHOD getSelectedBuffer()                   INLINE ( if( ::getMultiSelect(), ::aSelectedBuffer, ::hSelectedBuffer ) )

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

RETURN ( ::Super:End() )

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

   if ::getMultiSelect()
      
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

   local nId
   local aIds
   
   ::aSelectedBuffer    := {}

   aIds                 := ::getBrowseView():getRowSet():IdFromRecno( ::getBrowseView():oBrowse:aSelected )

   for each nId in aIds
      aAdd( ::aSelectedBuffer, ::getModel():loadCurrentBuffer( nId ) )
   next

RETURN ( ::oDialog:End( IDOK ) )

//----------------------------------------------------------------------------//

METHOD Start()

   ::hSelectedBuffer    := nil      

   ::oMenuTreeView:Default()

   ::oMenuTreeView:addSelectorButtons()

   ::oController:restoreState()

   ::oGetSearch:setFocus()

RETURN ( Self )

//----------------------------------------------------------------------------//

