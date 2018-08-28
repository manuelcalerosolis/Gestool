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

   METHOD setComboColumn( oColumn )

   METHOD Delete()

   METHOD isBrowseColumnEdit()
   
   METHOD startBrowse( oCombobox )

   METHOD restoreBrowseState()

   // Vistas manege -----------------------------------------------------------

   METHOD restoreState()

   METHOD saveState()

   METHOD getBrowseViewType()                         INLINE ( ::oBrowseView:getViewType() )

   METHOD getBrowseViewName()                         INLINE ( ::oBrowseView:getName() )

   METHOD getBrowseViewState()                        INLINE ( ::oBrowseView:getState() )
   
   METHOD refreshBrowseView()                         INLINE ( ::oBrowseView:Refresh() )

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

   METHOD buildRowSet() 

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

   ::oBrowseView:ActivateDialog( oDialog, nId )

   ::fireEvent( 'activated' )     

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD buildRowSet() 

   if !empty( ::oModel )
      ::oRowSet:buildPad( ::oModel:getSelectSentence() )
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD onChangeCombo( oColumn )

   ::setComboColumn( oColumn )

   ::changeModelOrderAndOrientation( oColumn:cSortOrder, oColumn:cOrder )

   ::oBrowseView:getBrowse():changeColumnOrder( oColumn )

   ::oBrowseView:getBrowse():refreshCurrent()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD setComboColumn( oColumn )

   if !( __objhasmethod( self, "getComboBoxOrder" ) )
      RETURN ( nil )
   end if 

   if  empty( ::getComboBoxOrder() )
      RETURN ( nil )
   end if 

   ::getComboBoxOrder():Set( oColumn:cHeader )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD Delete()

RETURN ( ::Super:Delete( ::oBrowseView:getBrowseSelected() ) )

//----------------------------------------------------------------------------//

METHOD restoreState()

   local cState               := ::getState( ::getBrowseViewType(), ::getBrowseViewName() ) 

   if !empty( cState )
      ::oBrowseView:setState( cState )
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD saveState()

   CursorWait()

   ::setState( ::getBrowseViewType(), ::getBrowseViewName(), ::getBrowseViewState() ) 

   CursorWE()

RETURN ( nil )

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
      RETURN ( nil )
   end if 

   if ( !empty( oCombobox ) )
      oCombobox:SetItems( ::oDialogView:getoBrowse():getColumnHeaders() )
   endif

   ::restoreBrowseState()

   oColumn        := ::oDialogView:getoBrowse():getColumnOrder( ::oModel:cColumnOrder )
   if empty( oColumn )
      RETURN ( nil )
   end if 
   
   if ( !empty( oCombobox ) )
      oCombobox:set( oColumn:cHeader )
   endif

   ::oDialogView:getoBrowse():selectColumnOrder( oColumn, ::oModel:cOrientation )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD restoreBrowseState()

   if empty( ::oDialogView:getoBrowse() )
      RETURN ( nil )
   end if 

   if empty( ::oDialogView:getBrowseState() )
      RETURN ( nil )
   end if 

   ::oDialogView:getoBrowse():restoreState( ::oDialogView:getBrowseState() )

RETURN ( nil )

//----------------------------------------------------------------------------//

