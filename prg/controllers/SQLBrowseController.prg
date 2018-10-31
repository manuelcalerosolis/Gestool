#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS SQLBrowseGestoolController FROM SQLBrowseController

   METHOD getConfiguracionVistasController()          INLINE ( if( empty( ::oConfiguracionVistasController ), ::oConfiguracionVistasController := SQLConfiguracionVistasGestoolController():New( self ), ), ::oConfiguracionVistasController )

END CLASS 

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLBrowseController FROM SQLApplicationController

   DATA oView

   DATA oBrowseView

   DATA oConfiguracionVistasController

   DATA uuidOlderParent

   METHOD New() CONSTRUCTOR

   METHOD End()

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

   METHOD getBrowseView()                             INLINE ( ::oBrowseView )
   
   METHOD getBrowseViewType()                         INLINE ( ::getBrowseView():getViewType() )

   METHOD getBrowseViewName()                         INLINE ( ::getBrowseView():getName() )

   METHOD getBrowseViewState()                        INLINE ( ::getBrowseView():getState() )
   
   METHOD refreshBrowseView()                         INLINE ( ::getBrowseView():selectCurrent(), ::getBrowseView():Refresh() )

   METHOD setFocusBrowseView()                        INLINE ( ::getBrowseView():setFocus() )

   METHOD setId( cType, cName, nId )                  INLINE ( ::getConfiguracionVistasController():setId( cType, cName, nId ) )
   
   METHOD getId( cType, cName )                       INLINE ( ::getConfiguracionVistasController():getId( cType, cName ) )

   METHOD setColumnOrder( cType, cName, cColumnOrder ) ;
                                                      INLINE ( ::getConfiguracionVistasController():setColumnOrder( cType, cName, cColumnOrder ) )
   
   METHOD getColumnOrder( cType, cName )              INLINE ( ::getConfiguracionVistasController():getColumnOrder( cType, cName ) )

   METHOD setColumnOrientation( cType, cName, cColumnOrientation ) ;
                                                      INLINE ( ::getConfiguracionVistasController():setColumnOrientation( cType, cName, cColumnOrientation ) )
   
   METHOD getColumnOrientation( cType, cName )        INLINE ( ::getConfiguracionVistasController():getColumnOrientation( cType, cName ) ) 

   METHOD setState( cType, cName, cState )            INLINE ( ::getConfiguracionVistasController():setState( cType, cName, cState ) )
   
   METHOD getState( cType, cName )                    INLINE ( ::getConfiguracionVistasController():getState( cType, cName ) )

   METHOD buildRowSetSentence() 

   METHOD appendLineal() 

   METHOD setView( oView )                            INLINE ( ::oView := oView )
   METHOD getView()                                   INLINE ( if( empty( ::oView ), ::oDialogView, ::oView ) )

   METHOD setShowDeleted()

    // Duplicates----------------------------------------------------------------

   METHOD setUuidOlderParent( uuidParent )            INLINE ( ::uuidOlderParent := uuidParent )

   METHOD getUuidOlderParent()                        INLINE ( ::uuidOlderParent )

   METHOD duplicateOthers( uuidEntidad )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController, oView )

   ::Super:New( oController )

   ::setView( oView )

   ::getConfiguracionVistasController()

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD End()

   if !empty( ::oConfiguracionVistasController )
      ::oConfiguracionVistasController:End()
   end if 

   ::Super:End()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD Activate( nId, oDialog )

   if empty( ::getBrowseView() )
      RETURN ( nil )
   end if 

   ::buildRowSetSentence()

   ::fireEvent( 'activating' )     

   ::getBrowseView():ActivateDialog( oDialog, nId )

   ::fireEvent( 'activated' )     

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD buildRowSetSentence() 

   if !empty( ::getModel() )
      ::getRowSet():buildPad( ::getModel():getSelectSentence() )
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD onChangeCombo( oColumn )

   ::changeModelOrderAndOrientation( oColumn:cSortOrder, oColumn:cOrder )

   ::getBrowseView():getBrowse():changeColumnOrder( oColumn )

   ::getBrowseView():getBrowse():refreshCurrent()

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

RETURN ( ::Super:Delete( ::getBrowseView():getBrowseSelected() ) )

//----------------------------------------------------------------------------//

METHOD restoreState()

   local cState               := ::getState( ::getBrowseViewType(), ::getBrowseViewName() ) 

   if !empty( cState )
      ::getBrowseView():setState( cState )
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD saveState()

   ::setState( ::getBrowseViewType(), ::getBrowseViewName(), ::getBrowseViewState() ) 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD isBrowseColumnEdit()

   local oSelectedColumn   

   if empty( ::getBrowseView() ) 
      RETURN ( .f. ) 
   end if   

   oSelectedColumn   := ::getBrowseView():getSelectedCol()

   if !empty( oSelectedColumn )
      RETURN ( oSelectedColumn:nEditType != 0 )
   end if 
   
RETURN ( .f. )   

//---------------------------------------------------------------------------//

METHOD startBrowse( oCombobox )

   local oColumn

   if empty( ::getDialogView():getoBrowse() )
      RETURN ( nil )
   end if 

   if ( !empty( oCombobox ) )
      oCombobox:SetItems( ::getDialogView():getoBrowse():getColumnHeaders() )
   endif

   ::restoreBrowseState()

   oColumn        := ::getDialogView():getoBrowse():getColumnOrder( ::getModel():cColumnOrder )
   if empty( oColumn )
      RETURN ( nil )
   end if 
   
   if ( !empty( oCombobox ) )
      oCombobox:set( oColumn:cHeader )
   endif

   ::getDialogView():getoBrowse():selectColumnOrder( oColumn, ::getModel():cOrientation )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD restoreBrowseState()

   if empty( ::getDialogView():getoBrowse() )
      RETURN ( nil )
   end if 

   if empty( ::getDialogView():getBrowseState() )
      RETURN ( nil )
   end if 

   ::getDialogView():getoBrowse():restoreState( ::getDialogView():getBrowseState() )

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD AppendLineal() CLASS SQLBrowseController

   local nId
   local lAppend     := .t.   

   if ::notUserAppend()
      msgStop( "Acceso no permitido." )
      RETURN ( .f. )
   end if 

   if isFalse( ::fireEvent( 'appending' ) )
      RETURN ( .f. )
   end if

   ::setAppendMode()

   ::saveRowSetRecno()

   nId               := ::getModel():insertBlankBuffer()

   if !empty( nId )

      ::fireEvent( 'appended' ) 

      ::refreshRowSetAndFindId( nId )

   else 
      
      lAppend        := .f.

      ::refreshRowSet()

   end if 

   ::refreshBrowseView()

   ::fireEvent( 'exitAppended' ) 

   if lAppend
      ::setFocusBrowseView()
   end if 

RETURN ( lAppend )

//----------------------------------------------------------------------------//
METHOD setShowDeleted()

   ::getModel():setShowDeleted( ::getModel():isShowDeleted() )
   
RETURN ( ::reBuildRowSet() )

//----------------------------------------------------------------------------//

METHOD duplicateOthers( uuidEntidad )

   local hOthers
   local aOthers 

   aOthers         := ::getModel():getHashOthersWhereParentUuid( ::getUuidOlderParent() )
   
   if empty( aOthers )
      RETURN ( nil )
   end if 

   for each hOthers in aOthers

      hset( hOthers, "id",          0 )

      hset( hOthers, "uuid",        win_uuidcreatestring() )
      
      hset( hOthers, "parent_uuid", uuidEntidad )
      
      hset( hOthers, "deleted_at",  hb_datetime( nil, nil, nil, nil, nil, nil, nil ) )

      ::getModel():insertBuffer( hOthers )

   next 

RETURN ( nil )

//---------------------------------------------------------------------------//