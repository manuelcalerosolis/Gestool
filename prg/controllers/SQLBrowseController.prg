#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS SQLBrowseGestoolController FROM SQLBrowseController

   METHOD getConfiguracionVistasController()          INLINE ( ::oConfiguracionVistasController := SQLConfiguracionVistasGestoolController():New( self ) )

END CLASS 

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLBrowseController FROM SQLBaseController

   DATA oBrowseView

   DATA oConfiguracionVistasController

   METHOD New()

   METHOD End()

   METHOD getConfiguracionVistasController()          INLINE ( ::oConfiguracionVistasController := SQLConfiguracionVistasController():New( self ) )

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

   METHOD setId( cType, cName, nId )                  INLINE ( ::oConfiguracionVistasController:setId( cType, cName, nId ) )
   
   METHOD getId( cType, cName )                       INLINE ( ::oConfiguracionVistasController:getId( cType, cName ) )

   METHOD setColumnOrder( cType, cName, cColumnOrder ) ;
                                                      INLINE ( ::oConfiguracionVistasController:setColumnOrder( cType, cName, cColumnOrder ) )
   
   METHOD getColumnOrder( cType, cName )              INLINE ( ::oConfiguracionVistasController:getColumnOrder( cType, cName ) )

   METHOD setColumnOrientation( cType, cName, cColumnOrientation ) ;
                                                      INLINE ( ::oConfiguracionVistasController:setColumnOrientation( cType, cName, cColumnOrientation ) )
   
   METHOD getColumnOrientation( cType, cName )        INLINE ( ::oConfiguracionVistasController:getColumnOrientation( cType, cName ) ) 

   METHOD setState( cType, cName, cState )            INLINE ( ::oConfiguracionVistasController:setState( cType, cName, cState ) )
   
   METHOD getState( cType, cName )                    INLINE ( ::oConfiguracionVistasController:getState( cType, cName ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oSenderController )

   ::Super:New( oSenderController )

   ::getConfiguracionVistasController()

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD End()

   CursorWait()

   ::oConfiguracionVistasController:End()

   Self                                      := nil

   CursorWE()

RETURN ( nil )

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

   local cState               := ::getState( ::getBrowseViewType(), ::getName() ) 

   if !empty( cState )
      ::oBrowseView:setState( cState )
   end if 

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD saveState()

   CursorWait()

   ::setState( ::getBrowseViewType(), ::getName(), ::oBrowseView:getState() ) 

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

