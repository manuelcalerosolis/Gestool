#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS SQLNavigatorController FROM SQLBaseController

   DATA oSelectorView

   DATA oNavigatorView

   DATA oDialogModalView

   DATA oFilterController 

   DATA oViewController

   DATA lDocuments                                    INIT .f.

   DATA lOthers                                       INIT .f.

   DATA lLabels                                       INIT .f.

   DATA lConfig                                       INIT .f.

   DATA lEnableWindowsBar                             INIT .f.

   DATA hFastKey                                      INIT {=>}

   DATA oWindowsBar

   METHOD New()
   METHOD End()

   METHOD setName( cName )                            INLINE ( ::Super:setName( cName ), if( !empty( ::oFilterController ), ::oFilterController:setTableToFilter( cName ), ) ) 

   METHOD Delete( aSelected )                         INLINE ( ::Super:Delete( aSelected ) )

   METHOD buildRowSetSentence() 
   METHOD buildRowSetSentenceNavigator()              INLINE ( ::buildRowSetSentence( 'navigator' ) )

   METHOD activateNavigatorView()

   METHOD activateDialogView()

   METHOD activateSelectorView()
   METHOD activateSelectorViewNoCenter()              INLINE ( ::ActivateSelectorView( .f. ) )

   METHOD closeAllWindows()                           INLINE ( if( !empty( oWnd() ), ( SysRefresh(), oWnd():CloseAll(), SysRefresh() ), ) )

   METHOD setFastReport( oFastReport, cTitle, cSentence, cColumns )    

   METHOD addFastKey( uKey, bAction )

   METHOD onKeyChar( nKey )

   METHOD reBuildRowSet()

   METHOD getComboBoxOrder()                          

   METHOD onChangeCombo( oColumn )

   METHOD getNavigatorView()                          INLINE ( ::oNavigatorView )

   // Aplication windows bar---------------------------------------------------

   METHOD EnableWindowsBar()

   METHOD DisableWindowsBar()

   METHOD onChangeSearch()                            INLINE ( if( !empty( ::oNavigatorView ), ::oNavigatorView:onChangeSearch(), ) )

   METHOD hideEditAndDeleteButtonFilter()

   METHOD showEditAndDeleteButtonFilter()

   METHOD getIds()                                    INLINE ( ::oBrowseView:getRowSet():idFromRecno( ::oBrowseView:oBrowse:aSelected ) )
   METHOD getBrowseViewType()                         INLINE ( ::oBrowseView:getViewType() )

   // Filters manege-----------------------------------------------------------

   METHOD appendFilter()
   METHOD editFilter()
   METHOD deleteFilter()                                

   METHOD getFilters()                                INLINE ( iif( !empty( ::oFilterController ), ::oFilterController:getFilters(), ) ) 
   METHOD setFilter()                                                                                                       
   METHOD clearFilter() 

   METHOD buildFilter( cExpresion )
   METHOD buildInFilter( cField, cValue )             INLINE ( ::buildFilter( iif( !empty( cField ) .and. !empty( cValue ), cField + " IN (" + toSqlString( cValue ) + ")", "" ) ) )
   METHOD buildNotInFilter( cField, cValue )          INLINE ( ::buildFilter( iif( !empty( cField ) .and. !empty( cValue ), cField + " NOT IN (" + toSqlString( cValue ) + ")", "" ) ) )
   METHOD buildBiggerFilter( cField, cValue )         INLINE ( ::buildFilter( iif( !empty( cField ) .and. !empty( cValue ), cField + " > " + toSqlString( cValue ), "" ) ) )
   METHOD buildSmallerFilter( cField, cValue )        INLINE ( ::buildFilter( iif( !empty( cField ) .and. !empty( cValue ), cField + " < " + toSqlString( cValue ), "" ) ) )
   METHOD buildStartLikeFilter( cField, cValue )      INLINE ( ::buildFilter( iif( !empty( cField ) .and. !empty( cValue ), cField + " LIKE " + toSqlString( alltrim( cstr( cValue ) ) + "%" ), "" ) ) )
   METHOD buildEndLikeFilter( cField, cValue )        INLINE ( ::buildFilter( iif( !empty( cField ) .and. !empty( cValue ), cField + " LIKE " + toSqlString( "%" + alltrim( cstr( cValue ) ) ), "" ) ) )
   METHOD buildLikeFilter( cField, cValue )           INLINE ( ::buildFilter( iif( !empty( cField ) .and. !empty( cValue ), cField + " LIKE " + toSqlString( "%" + alltrim( cstr( cValue ) ) + "%" ), "" ) ) )

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

   // Vistas manege -----------------------------------------------------------

   METHOD restoreState()
   METHOD saveState()

   METHOD setIdView( cType, cName, nId )              INLINE ( iif( !empty( ::oViewController ), ::oViewController:setId( cType, cName, nId ), ) )
   METHOD getIdView( cType, cName )                   INLINE ( iif( !empty( ::oViewController ), ::oViewController:getId( cType, cName ), ) )

   METHOD setColumnOrderView( cType, cName, cColumnOrder ) ;
                                                      INLINE ( iif( !empty( ::oViewController ), ::oViewController:setColumnOrder( cType, cName, cColumnOrder ), ) )
   METHOD getColumnOrderView( cType, cName )          INLINE ( iif( !empty( ::oViewController ), ::oViewController:getColumnOrder( cType, cName ), ) )

   METHOD setColumnOrientationView( cType, cName, cColumnOrientation ) ;
                                                      INLINE ( iif( !empty( ::oViewController ), ::oViewController:setColumnOrientation( cType, cName, cColumnOrientation ), ) )
   METHOD getColumnOrientationView( cType, cName )    INLINE ( iif( !empty( ::oViewController ), ::oViewController:getColumnOrientation( cType, cName ), ) )

   METHOD setStateView( cType, cName, cState )        INLINE ( msgalert( ::oViewController:className(), "SQLNavigatorController INLINE" ), iif( !empty( ::oViewController ), ::oViewController:setState( cType, cName, cState ), ) )
   METHOD getStateView( cType, cName )                INLINE ( iif( !empty( ::oViewController ), ::oViewController:getState( cType, cName ), ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oSenderController )

   ::Super:New( oSenderController )

   ::oNavigatorView                                   := SQLNavigatorView():New( self )

   ::oSelectorView                                    := SQLSelectorView():New( self )

   ::oDialogModalView                                 := SQLDialogView():New( self )

   ::oViewController                                  := SQLConfiguracionVistasController():New( self )

   ::oFilterController                                := SQLFiltrosController():New( self ) 

   ::oWindowsBar                                      := oWndBar()

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD End()

   cursorWait()

   if ::lEnableWindowsBar
      ::DisableWindowsBar()
   end if

   if !empty( ::oSelectorView )
      ::oSelectorView:End()
   end if 

   if !empty( ::oViewController )
      ::oViewController:End() 
   end if 

   if !empty( ::oFilterController )
      ::oFilterController:End() 
   end if 

   ::Super():End()

   Self                       := nil

   cursorWE()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD buildRowSetSentence( cType )

   local cColumnOrder         := ::getColumnOrderView( cType, ::getName() )
   local cColumnOrientation   := ::getColumnOrientationView( cType, ::getName() )

   ::oRowSet:build( ::getModel():getSelectSentence( cColumnOrder, cColumnOrientation ) )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD activateNavigatorView()

   if empty( ::oNavigatorView )
      RETURN ( Self )
   end if 

   if ::notUserAccess()
      msgStop( "Acceso no permitido." )
      RETURN ( Self )
   end if

   cursorWait()

   ::closeAllWindows()

   ::buildRowSetSentenceNavigator()   

   if !empty( ::oRowSet:get() )

      ::oNavigatorView:Activate()

      ::EnableWindowsBar()

   endif 

   cursorWE()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD activateSelectorView( lCenter )

   DEFAULT lCenter   := .t.

   if empty( ::oSelectorView )
      RETURN ( nil )
   end if 

   if ::notUserAccess()
      msgStop( "Acceso no permitido." )
      RETURN ( nil )
   end if

   ::buildRowSetSentence()   

   if empty( ::oRowSet:get() )
      RETURN ( nil )
   end if

RETURN ( ::oSelectorView:Activate( lCenter ) )

//---------------------------------------------------------------------------//

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

   msgalert( "saveState SQLNavigatorController")

   ::setIdView( ::getBrowseViewType(), ::getName(), ::getRowSet:fieldget( "id" ) )

   ::setColumnOrderView( ::getBrowseViewType(), ::getName(), ::oBrowseView:getColumnSortOrder() )

   ::setColumnOrientationView( ::getBrowseViewType(), ::getName(), ::oBrowseView:getColumnSortOrientation() )

   ::setStateView( ::getBrowseViewType(), ::getName(), ::oBrowseView:getSaveState() ) 

   CursorWE()

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD activateDialogView()

   if empty( ::oDialogModalView )
      RETURN ( nil )
   end if 

   if ::notUserAccess()
      msgStop( "Acceso no permitido." )
      RETURN ( nil )
   end if

   ::buildRowSetSentence()   

   if empty( ::oRowSet:get() )
      RETURN ( nil )
   end if

RETURN ( ::oDialogModalView:Activate() )

//---------------------------------------------------------------------------//

METHOD addFastKey( uKey, bAction )

   if hb_ischar( uKey )
      hset( ::hFastKey, asc( upper( uKey ) ), bAction )
      hset( ::hFastKey, asc( lower( uKey ) ), bAction )
   end if

   if hb_isnumeric( uKey )
      hset( ::hFastKey, uKey, bAction )
   end if 

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD onKeyChar( nKey )

RETURN ( heval( ::hFastKey, {|k,v| if( k == nKey, eval( v ), ) } ) ) 
   
//----------------------------------------------------------------------------//

METHOD setFastReport( oFastReport, cTitle, cSentence, cColumns )    
     
   local oRowSet      
     
   if empty( oFastReport )     
      RETURN ( Self )    
   end if    
    
   DEFAULT cColumns  := ::getModel():getSerializeColumns()       
    
   oRowSet           := ::getModel():newRowSet( cSentence )      
    
   if empty( oRowSet )      
      RETURN ( Self )    
   end if       
    
   oFastReport:setUserDataSet(   cTitle,;     
                                 cColumns,;      
                                 {|| oRowSet:gotop()  },;    
                                 {|| oRowSet:skip(1)  },;    
                                 {|| oRowSet:skip(-1) },;    
                                 {|| oRowSet:eof()    },;
                                 {|nField| msgalert( nField ), oRowSet:fieldGet( nField ) } )
    
RETURN ( Self )    
    
//---------------------------------------------------------------------------//

METHOD appendFilter()                                

   if empty( ::oFilterController )
      RETURN ( Self )  
   end if 

RETURN ( ::oFilterController:Append() )    
    
//---------------------------------------------------------------------------//

METHOD editFilter()                                

   local cFilter  := ::oWindowsBar:GetComboFilter()

   if empty( cFilter )
      RETURN ( Self )  
   end if 

   if empty( ::oFilterController )
      RETURN ( Self )  
   end if 

RETURN ( ::oFilterController:EditByText( cFilter ) )    
    
//---------------------------------------------------------------------------//
    
METHOD deleteFilter()                                

   local nId 
   local cFilter  := ::oWindowsBar:GetComboFilter()

   if empty( cFilter )
      RETURN ( Self )  
   end if 

   if empty( ::oFilterController )
      RETURN ( Self )  
   end if 

   nId            := ::oFilterController:oModel:getId( cFilter )

   if empty( nId )
      RETURN ( Self )    
   end if 
      
   if SQLAjustableModel():getRolNoConfirmacionEliminacion( Auth():rolUuid() ) .or. msgNoYes( "¿Desea eliminar el registro en curso?", "Confirme eliminación" )
      ::oWindowsBar:setComboFilterItem( "" )
      ::oWindowsBar:evalComboFilterChange()
      ::oFilterController:oModel:deleteById( { nId } )
   end if 

RETURN ( Self )    
    
//---------------------------------------------------------------------------//

METHOD setFilter( cFilterName )         

   local cFilterSentence

   DEFAULT cFilterName     := ::oWindowsBar:getComboFilter()

   if empty( cFilterName )

      ::getModel():clearFilterWhere()
   
      ::hideEditAndDeleteButtonFilter()
   
   else 

      if !empty( ::oFilterController )

         cFilterSentence      := ::oFilterController:getFilterSentence( cFilterName )

         ::getModel():setFilterWhere( cFilterSentence )
      
         ::showEditAndDeleteButtonFilter()

      end if 
   
   end if  

   ::reBuildRowSet()

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD buildFilter( cFilter )

   ::getModel():insertFilterWhere( cFilter )

   if !empty( ::oFilterController )
      ::oFilterController:setComboFilterItem( ::getModel():getFilterWhere() )   
   end if 

   ::reBuildRowSet()
   
RETURN ( self )

//---------------------------------------------------------------------------//

METHOD clearFilter()

   ::getModel():clearFilterWhere()

   if !empty( ::oFilterController )
      ::oFilterController:setComboFilterItem( ::getModel():getFilterWhere() )   
   end if 

   ::reBuildRowSet()
   
RETURN ( self )

//---------------------------------------------------------------------------//

METHOD buildCustomFilter( cField, cValue, cOperator )

   if empty( ::oFilterController )
      RETURN ( .f. )
   end if 

   ::oFilterController:oCustomView:setText( "'" + cField + "' " + cOperator )
   ::oFilterController:oCustomView:setValue( cValue )

   if !( ::oFilterController:oCustomView:Activate() )
      RETURN ( .f. )
   end if 

   cValue            := alltrim( ::oFilterController:oCustomView:getValue() )

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD reBuildRowSet()

   local nId

   nId               := ::oRowSet:fieldGet( ::getModelColumnKey() )
   
   ::oRowSet:build( ::getModel():getSelectSentence() )

   ::oRowSet:findString( nId )
      
   ::getBrowse():Refresh()

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD EnableWindowsBar()

   if empty( ::oWindowsBar )
      RETURN ( Self )
   end if 

   ::oWindowsBar:enableGet()

   ::oWindowsBar:enableComboBox( ::oBrowseView:getColumnsHeaders() )

   ::oWindowsBar:setComboBoxChange( {|| ::onChangeCombo() } )

   ::oWindowsBar:setComboBoxItem( ::oBrowseView:getColumnHeaderByOrder( ::getModel():getOrderBy() ) )

   ::oWindowsBar:enableComboFilter( ::getFilters() )

   ::oWindowsBar:showAddButtonFilter()

   ::oWindowsBar:setComboFilterChange( {|| ::setFilter() } )

   ::oWindowsBar:setActionAddButtonFilter( {|| ::appendFilter() } )

   ::oWindowsBar:setActionEditButtonFilter( {|| ::editFilter() } )

   ::oWindowsBar:setActionDeleteButtonFilter( {|| ::deleteFilter() } )

   ::oWindowsBar:setGetChange( {|| ::onChangeSearch() } )

   ::oNavigatorView:Refresh()

   ::lEnableWindowsBar  := .t.

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD DisableWindowsBar()

   if empty( ::oWindowsBar )
      RETURN ( Self )
   end if 

   ::oWindowsBar:disableGet()

   ::oWindowsBar:disableComboBox()

   ::oWindowsBar:disableComboFilter()

   ::oWindowsBar:hideAddButtonFilter()

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD hideEditAndDeleteButtonFilter()

   ::oWindowsBar:HideCleanButtonFilter()

   ::oWindowsBar:HideEditButtonFilter()

   ::oWindowsBar:HideDeleteButtonFilter()

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD showEditAndDeleteButtonFilter()

   ::oWindowsBar:ShowCleanButtonFilter()

   ::oWindowsBar:ShowEditButtonFilter()

   ::oWindowsBar:ShowDeleteButtonFilter()

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD onChangeCombo( oColumn )

   local oComboBox   := ::getComboBoxOrder()

   if empty( oComboBox )
      RETURN ( Self )
   end if 

   if empty( ::getBrowse() )
      RETURN ( Self )
   end if 

   if empty( oColumn )
      oColumn        := ::getBrowse():getColumnByHeader( oComboBox:VarGet() )
   end if 

   if empty( oColumn )
      RETURN ( Self )
   end if 

   oComboBox:Set( oColumn:cHeader )

   ::getBrowse():changeColumnOrder( oColumn )

   ::changeModelOrderAndOrientation( oColumn:cSortOrder, oColumn:cOrder )

   ::getBrowse():refreshCurrent()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD getComboBoxOrder()

   if !empty( ::oSelectorView ) .and. ::oSelectorView:isActive()
      RETURN ( ::oSelectorView:getComboBoxOrder() )
   end if 

   if !empty( ::oDialogModalView ) .and. ::oDialogModalView:isActive()
      RETURN ( ::oDialogModalView:getComboBoxOrder() )
   end if 

RETURN ( ::oWindowsBar:oComboBox() ) 

//---------------------------------------------------------------------------//
   