#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS SQLBrowseController FROM SQLBaseController

   DATA oBrowseView

   METHOD New()

   METHOD Activate()

   METHOD onChangeCombo( oColumn )

   METHOD Delete()

   // Vistas manege -----------------------------------------------------------

   METHOD restoreState()
   METHOD saveState()

   METHOD getBrowseViewType()                         INLINE ( ::oBrowseView:getViewType() )

   METHOD setIdView( cType, cName, nId )              INLINE ( iif( !empty( ::oBrowseView ), ::oBrowseView:setId( cType, cName, nId ), ) )
   METHOD getIdView( cType, cName )                   INLINE ( iif( !empty( ::oBrowseView ), ::oBrowseView:getId( cType, cName ), ) )

   METHOD setColumnOrderView( cType, cName, cColumnOrder ) ;
                                                      INLINE ( iif( !empty( ::oBrowseView ), ::oBrowseView:setColumnOrder( cType, cName, cColumnOrder ), ) )
   METHOD getColumnOrderView( cType, cName )          INLINE ( iif( !empty( ::oBrowseView ), ::oBrowseView:getColumnOrder( cType, cName ), ) )

   METHOD setColumnOrientationView( cType, cName, cColumnOrientation ) ;
                                                      INLINE ( iif( !empty( ::oBrowseView ), ::oBrowseView:setColumnOrientation( cType, cName, cColumnOrientation ), ) )
   METHOD getColumnOrientationView( cType, cName )    INLINE ( iif( !empty( ::oBrowseView ), ::oBrowseView:getColumnOrientation( cType, cName ), ) )

   METHOD setStateView( cType, cName, cState )        INLINE ( iif( !empty( ::oBrowseView ), ::oBrowseView:setState( cType, cName, cState ), ) )
   METHOD getStateView( cType, cName )                INLINE ( iif( !empty( ::oBrowseView ), ::oBrowseView:getState( cType, cName ), ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oSenderController )

   ::Super:New( oSenderController )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD Activate( nId, oDialog )

   if empty( ::oBrowseView )
      RETURN ( Self )
   end if 

   ::fireEvent( 'activating' )     

   ::oRowSet:buildPad( ::oModel:getSelectSentence() )

   ::fireEvent( 'activated' )     

   ::oBrowseView:ActivateDialog( oDialog, nId )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD onChangeCombo( oColumn )

   ::changeModelOrderAndOrientation( oColumn:cSortOrder, oColumn:cOrder )

   ::oBrowseView:getBrowse():changeColumnOrder( oColumn )

   ::oBrowseView:getBrowse():refreshCurrent()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Delete()

RETURN ( ::Super:Delete( ::oBrowseView:getBrowseSelected() ) )

//----------------------------------------------------------------------------//

METHOD restoreState()

   local nId                  := ::getIdView( ::getBrowseViewType(), ::getName() )
   local cColumnOrder         := ::getColumnOrderView( ::getBrowseViewType(), ::getName() )
   local cColumnOrientation   := ::getColumnOrientationView( ::getBrowseViewType(), ::getName() )
   local cState               := ::getStateView( ::getBrowseViewType(), ::getName() ) 

   if empty( cColumnOrder )
      ::oBrowseView:setFirstColumnOrder()
   else
      ::oBrowseView:setColumnOrder( cColumnOrder, cColumnOrientation )
   end if 

   if !empty( cState )
      ::oBrowseView:setSaveState( cState )
   end if 

   if !empty( nId )
      ::oBrowseView:setId( nId )
   end if 

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD saveState()

   CursorWait()

   ::setIdView( ::getBrowseViewType(), ::getName(), ::getRowSet:fieldget( "id" ) )

   ::setColumnOrderView( ::getBrowseViewType(), ::getName(), ::oBrowseView:getColumnSortOrder() )

   ::setColumnOrientationView( ::getBrowseViewType(), ::getName(), ::oBrowseView:getColumnSortOrientation() )

   ::setStateView( ::getBrowseViewType(), ::getName(), ::oBrowseView:getSaveState() ) 

   CursorWE()

RETURN ( self )

//---------------------------------------------------------------------------//

