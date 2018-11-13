#include "FiveWin.Ch"
#include "Factu.ch" 

//----------------------------------------------------------------------------//

CLASS SQLNavigatorGestoolController FROM SQLNavigatorController

   METHOD getConfiguracionVistasController()          INLINE ( if( empty( ::oConfiguracionVistasController ), ::oConfiguracionVistasController := SQLConfiguracionVistasGestoolController():New( self ), ), ::oConfiguracionVistasController )

END CLASS

//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//

CLASS SQLNavigatorController FROM SQLBrowseController

   DATA oReport

   DATA oSelectorView

   DATA oNavigatorView

   DATA oDialogModalView

   DATA oFilterController 

   DATA oConfiguracionesModel

   DATA lOthers                                       INIT .f.

   DATA lLabels                                       INIT .f.

   DATA lConfig                                       INIT .f.

   DATA lDocuments                                    INIT .f.

   DATA lMail                                         INIT .f.

   DATA lEnableWindowsBar                             INIT .f.

   DATA hFastKey                                      INIT {=>}

   DATA oWindowsBar

   METHOD New() CONSTRUCTOR

   METHOD End()

   METHOD Delete( aSelected )                         INLINE ( ::Super:Delete( aSelected ) )

   METHOD buildRowSetSentence() 

   METHOD buildRowSetSentenceNavigator()              INLINE ( ::buildRowSetSentence( 'navigator' ) )

   METHOD activateNavigatorView()
   METHOD endNavigatorView()

   METHOD activateDialogView()

   METHOD activateSelectorView()
   METHOD activateSelectorViewNoCenter()              INLINE ( ::ActivateSelectorView( .f. ) )

   METHOD closeAllWindows()                           INLINE ( if( !empty( oWnd() ), ( SysRefresh(), oWnd():CloseAll(), SysRefresh() ), ) )

   METHOD saveState()

   METHOD addFastKey( uKey, bAction )

   METHOD onKeyChar( nKey )

   METHOD getComboBoxOrder()                          

   METHOD onChangeCombo( oColumn )

   // Aplication windows bar---------------------------------------------------

   METHOD EnableWindowsBar()

   METHOD DisableWindowsBar()

   METHOD onChangeSearch()                            INLINE ( ::getNavigatorView():onChangeSearch() )

   METHOD hideEditAndDeleteButtonFilter()

   METHOD showEditAndDeleteButtonFilter()

   METHOD getIds()                                    INLINE ( ::getRowSet():idFromRecno( ::getBrowseView():oBrowse:aSelected ) )
   METHOD getUuids()                                  INLINE ( ::getRowSet():uuidFromRecno( ::getBrowseView():oBrowse:aSelected ) )
   METHOD getIdentifiers()                            INLINE ( ::getRowSet():identifiersFromRecno( ::getBrowseView():oBrowse:aSelected ) )

   // Filters manege-----------------------------------------------------------

   METHOD appendFilter()
   METHOD editFilter()
   METHOD deleteFilter()                                

   METHOD getFilters()                                INLINE ( ::getFilterController():getFilters() ) 
   METHOD setFilter()                                                                                                       
   METHOD clearFilter() 

   METHOD buildFilter()

   METHOD buildCustomFilter( cField, cValue, cOperator )

   METHOD buildCustomInFilter( cField, cValue )       INLINE ( iif(  ::buildCustomFilter( cField, @cValue, "IN (...)" ),;
                                                                     ::buildInFilter( cField, cValue ), ) )
   
   METHOD buildCustomNotInFilter( cField, cValue )    INLINE ( iif(  ::buildCustomFilter( cField, @cValue, "NOT IN (...)" ),;
                                                                     ::buildNotInFilter( cField, cValue ), ) )
   
   METHOD buildCustomBiggerFilter( cField, cValue )   INLINE ( iif(  ::buildCustomFilter( cField, @cValue, "> (...)" ),;
                                                                     ::buildBiggerFilter( cField, cValue ), ) )
   
   METHOD buildCustomSmallerFilter( cField, cValue )  INLINE ( iif(  ::buildCustomFilter( cField, @cValue, "< (...)" ),;
                                                                     ::buildSmallerFilter( cField, cValue ), ) )
   
   METHOD buildCustomLikeFilter( cField, cValue )     INLINE ( iif(  ::buildCustomFilter( cField, @cValue, "LIKE (...)" ),;
                                                                     ::buildLikeFilter( cField, cValue ), ) )

   METHOD getNavigatorView()                          INLINE ( iif( empty( ::oNavigatorView ), ::oNavigatorView := SQLNavigatorView():New( self ), ), ::oNavigatorView )

   METHOD getSelectorView()                           INLINE ( iif( empty( ::oSelectorView ), ::oSelectorView := SQLSelectorView():New( self ), ), ::oSelectorView )

   METHOD getDialogModalView()                        INLINE ( iif( empty( ::oDialogModalView ), ::oDialogModalView := SQLDialogView():New( self ), ), ::oDialogModalView )

   METHOD getFilterController()                       INLINE ( iif( empty( ::oFilterController ), ::oFilterController := SQLFiltrosController():New( self ), ), ::oFilterController ) 

   METHOD setShowDeleted()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController )

   ::Super:New( oController )

   ::oWindowsBar                                      := oWndBar()

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD End()

   if !empty( ::oNavigatorView )
      ::oNavigatorView:End()
   end if 

   if !empty( ::oSelectorView )
      ::oSelectorView:End()
   end if 

   if !empty( ::oDialogModalView )
      ::oDialogModalView:End()
   end if 

   if !empty( ::oFilterController )
      ::oFilterController:End() 
   end if 

RETURN ( ::Super():End() )

//---------------------------------------------------------------------------//
 
METHOD buildRowSetSentence( cType )

   local cColumnOrder         
   local cColumnOrientation   

   if !empty( ::getBrowseView() )

      cColumnOrder            := ::getBrowseView():getColumnOrderView( cType, ::getName() )
      
      cColumnOrientation      := ::getBrowseView():getColumnOrientationView( cType, ::getName() )

   end if 

   ::getRowSet():Build( ::getModel():getSelectSentence( cColumnOrder, cColumnOrientation ) )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD activateNavigatorView()

   if ::notUserAccess()
      msgStop( "Acceso no permitido." )
      RETURN ( nil )
   end if

   cursorWait()

   ::closeAllWindows()

   ::buildRowSetSentenceNavigator()   

   if !empty( ::getRowSet():get() )

      ::getNavigatorView():Activate()

      ::EnableWindowsBar()

   endif 

   cursorWE()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD endNavigatorView()

   if ::lEnableWindowsBar
      ::DisableWindowsBar()
   end if

   ::End()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD activateSelectorView( lCenter )

   DEFAULT lCenter   := .t.

   if ::notUserAccess()
      msgStop( "Acceso no permitido." )
      RETURN ( nil )
   end if

   ::buildRowSetSentence()   

   if empty( ::getRowSet():get() )
      RETURN ( nil )
   end if

RETURN ( ::getSelectorView():Activate( lCenter ) )

//---------------------------------------------------------------------------//

METHOD saveState()

   CursorWait()

   ::setId( ::getBrowseViewType(), ::getName(), ::getRowSet:fieldget( "id" ) )

   ::setColumnOrder( ::getBrowseViewType(), ::getName(), ::getBrowseView():getColumnSortOrder() )

   ::setColumnOrientation( ::getBrowseViewType(), ::getName(), ::getBrowseView():getColumnSortOrientation() )

   ::setState( ::getBrowseViewType(), ::getName(), ::getBrowseView():getState() ) 

   CursorWE()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD activateDialogView()

   if empty( ::getDialogModalView() )
      RETURN ( .f. )
   end if 

   if ::notUserAccess()
      msgStop( "Acceso no permitido." )
      RETURN ( .f. )
   end if

   if isFalse( ::fireEvent( 'activatingDialogView' ) )
      RETURN ( .f. )
   end if

   ::buildRowSetSentence() 

   if empty( ::getRowSet():get() )
      RETURN ( .f. )
   end if
   
RETURN ( ::getDialogModalView():Activate() )

//---------------------------------------------------------------------------//

METHOD addFastKey( uKey, bAction )

   if hb_ischar( uKey )
      hset( ::hFastKey, asc( upper( uKey ) ), bAction )
      hset( ::hFastKey, asc( lower( uKey ) ), bAction )
   end if

   if hb_isnumeric( uKey )
      hset( ::hFastKey, uKey, bAction )
   end if 

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD onKeyChar( nKey )

RETURN ( heval( ::hFastKey, {|k,v| if( k == nKey, eval( v ), ) } ) ) 
   
//----------------------------------------------------------------------------//

METHOD appendFilter()                                

RETURN ( ::getFilterController():Append() )    
    
//---------------------------------------------------------------------------//

METHOD editFilter()                                

   local cFilter  := ::oWindowsBar:GetComboFilter()

   if empty( cFilter )
      RETURN ( nil )  
   end if 

RETURN ( ::getFilterController():EditByText( cFilter ) )    
    
//---------------------------------------------------------------------------//
    
METHOD deleteFilter()                                

   local nId 
   local cFilter  := ::oWindowsBar:GetComboFilter()

   if empty( cFilter )
      RETURN ( nil )  
   end if 

   nId            := ::getFilterController():oModel:getId( cFilter )

   if empty( nId )
      RETURN ( nil )    
   end if 
      
   if SQLAjustableModel():getRolNoConfirmacionEliminacion( Auth():rolUuid() ) .or. msgNoYes( "¿Desea eliminar el registro en curso?", "Confirme eliminación" )
      ::oWindowsBar:setComboFilterItem( "" )
      ::oWindowsBar:evalComboFilterChange()
      ::getFilterController():oModel:deleteById( { nId } )
   end if 

RETURN ( nil )    
    
//---------------------------------------------------------------------------//

METHOD setFilter( cFilterName )         

   local cFilterSentence

   DEFAULT cFilterName     := ::oWindowsBar:getComboFilter()

   if empty( cFilterName )

      ::getModel():clearFilterWhere()
   
      ::hideEditAndDeleteButtonFilter()
   
   else 

      cFilterSentence      := ::getFilterController():getFilterSentence( cFilterName )

      ::getModel():setFilterWhere( cFilterSentence )
   
      ::showEditAndDeleteButtonFilter()

   end if  

   ::reBuildRowSet()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD buildFilter( cFilter )

   ::getModel():insertFilterWhere( cFilter )

   ::getFilterController():setComboFilterItem( ::getModel():getFilterWhere() )   

   ::getFilterController():showCleanButtonFilter()   

   ::reBuildRowSet()
   
RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD buildCustomFilter( cField, cValue, cOperator )

   ::getFilterController():oCustomView:setText( "'" + cField + "' " + cOperator )

   ::getFilterController():oCustomView:setValue( cValue )

   if !( ::getFilterController():oCustomView:Activate() )
      RETURN ( .f. )
   end if 

   cValue            := alltrim( ::getFilterController():oCustomView:getValue() )

RETURN ( .t. )

//----------------------------------------------------------------------------//

METHOD clearFilter()

   ::getModel():clearFilterWhere()

   ::getFilterController():setComboFilterItem( ::getModel():getFilterWhere() )   

   ::reBuildRowSet()
   
RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD EnableWindowsBar()

   local oColumn

   if empty( ::oWindowsBar )
      RETURN ( nil )
   end if 

   ::oWindowsBar:enableGet()

   ::oWindowsBar:setGetChange( {|| ::onChangeSearch() } )

   oColumn              := ::getBrowseView():getColumnBySortOrder( ::getModel():getOrderBy() )

   if !empty( oColumn )
      ::getBrowseView():selectColumnOrder( oColumn, ::getModel():getOrientation() )
   end if 

   ::oWindowsBar:enableComboFilter( ::getFilters() )

   ::oWindowsBar:showAddButtonFilter()

   ::oWindowsBar:setComboFilterChange( {|| ::setFilter() } )

   ::oWindowsBar:setActionAddButtonFilter( {|| ::appendFilter() } )

   ::oWindowsBar:setActionEditButtonFilter( {|| ::editFilter() } )

   ::oWindowsBar:setActionDeleteButtonFilter( {|| ::deleteFilter() } )

   ::getNavigatorView():Refresh()

   ::lEnableWindowsBar  := .t.

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD DisableWindowsBar()

   if empty( ::oWindowsBar )
      RETURN ( nil )
   end if 

   ::oWindowsBar:disableGet()

   ::oWindowsBar:disableComboFilter()

   ::oWindowsBar:hideAddButtonFilter()

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD hideEditAndDeleteButtonFilter()

   ::oWindowsBar:HideCleanButtonFilter()

   ::oWindowsBar:HideEditButtonFilter()

   ::oWindowsBar:HideDeleteButtonFilter()

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD showEditAndDeleteButtonFilter()

   ::oWindowsBar:ShowCleanButtonFilter()

   ::oWindowsBar:ShowEditButtonFilter()

   ::oWindowsBar:ShowDeleteButtonFilter()

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD onChangeCombo( oColumn )

   if empty( oColumn )
      RETURN ( nil )
   end if 

   if empty( ::getBrowseView() )
      RETURN ( nil )
   end if 

   ::getBrowseView():changeColumnOrder( oColumn )

   ::changeModelOrderAndOrientation( oColumn:cSortOrder, oColumn:cOrder )

   ::getBrowseView():refreshCurrent()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD getComboBoxOrder()

   if ::getSelectorView():isActive()
      RETURN ( ::getSelectorView():getComboBoxOrder() )
   end if 

   if ::getDialogModalView():isActive()
      RETURN ( ::getDialogModalView():getComboBoxOrder() )
   end if 

   if !empty( ::oWindowsBar )
      RETURN ( ::oWindowsBar:oComboBox() ) 
   end if 

RETURN ( nil ) 

//---------------------------------------------------------------------------//

METHOD setShowDeleted()

   ::getModel():changeShowDeleted()

   ::getNavigatorView();
      :getMenuTreeView();
         :setButtonShowDeleteText( if( ::getModel():isShowDeleted(), "Ocultar eliminados", "Mostrar eliminados" ) )
   
RETURN ( ::reBuildRowSet() )

//----------------------------------------------------------------------------//   