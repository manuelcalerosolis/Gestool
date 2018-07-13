#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS SQLBrowseController FROM SQLBaseController

   DATA oBrowseView

   METHOD New()

   METHOD Activate()

   METHOD onChangeCombo( oColumn )

   METHOD Delete()

   METHOD isBrowseColumnEdit()
   
   METHOD startBrowse( oCombobox )

   METHOD restoreBrowseState()

   // Vistas manege -----------------------------------------------------------

   METHOD restoreState()
   METHOD saveState()

   METHOD getBrowseViewType()                         INLINE ( ::oBrowseView:getViewType() )

   METHOD setIdView( cType, cName, nId )              INLINE ( iif( !empty( ::oBrowseView ), ::oBrowseView:setIdView( cType, cName, nId ), ) )
   
   METHOD getIdView( cType, cName )                   INLINE ( iif( !empty( ::oBrowseView ), ::oBrowseView:getIdView( cType, cName ), ) )

   METHOD setColumnOrderView( cType, cName, cColumnOrder ) ;
                                                      INLINE ( iif( !empty( ::oBrowseView ), ::oBrowseView:setColumnOrderView( cType, cName, cColumnOrder ), ) )
   METHOD getColumnOrderView( cType, cName )          INLINE ( iif( !empty( ::oBrowseView ), ::oBrowseView:getColumnOrderView( cType, cName ), ) )

   METHOD setColumnOrientationView( cType, cName, cColumnOrientation ) ;
                                                      INLINE ( iif( !empty( ::oBrowseView ), ::oBrowseView:setColumnOrientationView( cType, cName, cColumnOrientation ), ) )
   
   METHOD getColumnOrientationView( cType, cName )    INLINE ( iif( !empty( ::oBrowseView ), ::oBrowseView:getColumnOrientationView( cType, cName ), ) )

   METHOD setStateView( cType, cName, cState )        INLINE ( iif( !empty( ::oBrowseView ), ::oBrowseView:setStateView( cType, cName, cState ), ) )
   
   METHOD getStateView( cType, cName )                INLINE ( iif( !empty( ::oBrowseView ), ::oBrowseView:getStateView( cType, cName ), ) )

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
      ::oBrowseView:findId( nId )
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

METHOD isBrowseColumnEdit()

   local oSelectedColumn   

   if !empty( ::oBrowseView ) 

      oSelectedColumn   := ::oBrowseView:getSelectedCol()
   
      if !empty( oSelectedColumn )
         RETURN ( oSelectedColumn:nEditType != 0 )
      end if 
   
   end if 

RETURN ( .f. )   

//---------------------------------------------------------------------------//

METHOD startBrowse( oCombobox )

   local oColumn

   if empty( ::oDialogView:getoBrowse() )
      RETURN ( Self )
   end if 

   if (!empty( oCombobox ) )
      oCombobox:SetItems( ::oDialogView:getoBrowse():getColumnHeaders() )
   endif

   ::restoreBrowseState()

   oColumn        := ::oDialogView:getoBrowse():getColumnOrder( ::oModel:cColumnOrder )
   if empty( oColumn )
      RETURN ( Self )
   end if 
   
   if (!empty( oCombobox ) )
      oCombobox:set( oColumn:cHeader )
   endif

   ::oDialogView:getoBrowse():selectColumnOrder( oColumn, ::oModel:cOrientation )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD restoreBrowseState()

   if empty( ::oDialogView:getoBrowse() )
      RETURN ( Self )
   end if 

   if empty( ::oDialogView:getBrowseState() )
      RETURN ( Self )
   end if 

   ::oDialogView:getoBrowse():restoreState( ::oDialogView:getBrowseState() )

RETURN ( Self )

//----------------------------------------------------------------------------//

