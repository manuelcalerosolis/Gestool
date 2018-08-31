#include "FiveWin.Ch"
#include "Factu.ch" 

//----------------------------------------------------------------------------//

CLASS SQLNavigatorGestoolController FROM SQLNavigatorController

   METHOD getConfiguracionVistasController()          INLINE ( ::oConfiguracionVistasController := SQLConfiguracionVistasGestoolController():New( self ) )

END CLASS

//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//

CLASS SQLNavigatorController FROM SQLBrowseController

   DATA oSelectorView

   DATA oNavigatorView

   DATA oDialogModalView

   DATA oFilterController 

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
   METHOD endNavigatorView()

   METHOD activateDialogView()

   METHOD activateSelectorView()
   METHOD activateSelectorViewNoCenter()              INLINE ( ::ActivateSelectorView( .f. ) )

   METHOD closeAllWindows()                           INLINE ( if( !empty( oWnd() ), ( SysRefresh(), oWnd():CloseAll(), SysRefresh() ), ) )

   METHOD saveState()

   METHOD setFastReport( oFastReport, cTitle, cSentence, cColumns )    

   METHOD addFastKey( uKey, bAction )

   METHOD onKeyChar( nKey )

   METHOD getComboBoxOrder()                          

   METHOD onChangeCombo( oColumn )

   METHOD getNavigatorView()                          INLINE ( ::oNavigatorView )

   // Aplication windows bar---------------------------------------------------

   METHOD EnableWindowsBar()

   METHOD DisableWindowsBar()

   METHOD onChangeSearch()                            INLINE ( if( !empty( ::oNavigatorView ), ::oNavigatorView:onChangeSearch(), ) )

   METHOD hideEditAndDeleteButtonFilter()

   METHOD showEditAndDeleteButtonFilter()

   METHOD getIds()                                    INLINE ( ::getRowSet():idFromRecno( ::oBrowseView:oBrowse:aSelected ) )

   // Filters manege-----------------------------------------------------------

   METHOD appendFilter()
   METHOD editFilter()
   METHOD deleteFilter()                                

   METHOD getFilters()                                INLINE ( iif( !empty( ::oFilterController ), ::oFilterController:getFilters(), ) ) 
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

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oSenderController )

   ::Super:New( oSenderController )

   ::oNavigatorView                                   := SQLNavigatorView():New( self )

   ::oSelectorView                                    := SQLSelectorView():New( self )

   ::oDialogModalView                                 := SQLDialogView():New( self )

   ::oFilterController                                := SQLFiltrosController():New( self ) 

   ::oWindowsBar                                      := oWndBar()

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD End()

   cursorWait()

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

   ::Super():End()

   ::oNavigatorView           := nil

   ::oSelectorView            := nil

   ::oDialogModalView         := nil

   ::oFilterController        := nil

   ::oWindowsBar              := nil

   self                       := nil

   cursorWE()

RETURN ( nil )

//---------------------------------------------------------------------------//
 
METHOD buildRowSetSentence( cType )

   local cColumnOrder         
   local cColumnOrientation   

   if !empty( ::oBrowseView )

      cColumnOrder            := ::oBrowseView:getColumnOrderView( cType, ::getName() )
      
      cColumnOrientation      := ::oBrowseView:getColumnOrientationView( cType, ::getName() )

   end if 

   ::oRowSet:Build( ::getModel():getSelectSentence( cColumnOrder, cColumnOrientation ) )

RETURN ( nil )

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

METHOD saveState()

   CursorWait()

   ::setId( ::getBrowseViewType(), ::getName(), ::getRowSet:fieldget( "id" ) )

   ::setColumnOrder( ::getBrowseViewType(), ::getName(), ::oBrowseView:getColumnSortOrder() )

   ::setColumnOrientation( ::getBrowseViewType(), ::getName(), ::oBrowseView:getColumnSortOrientation() )

   ::setState( ::getBrowseViewType(), ::getName(), ::oBrowseView:getState() ) 

   CursorWE()

RETURN ( nil )

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

RETURN ( nil )

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
    
RETURN ( nil )    
    
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
      RETURN ( nil )  
   end if 

   if empty( ::oFilterController )
      RETURN ( nil )  
   end if 

   nId            := ::oFilterController:oModel:getId( cFilter )

   if empty( nId )
      RETURN ( nil )    
   end if 
      
   if SQLAjustableModel():getRolNoConfirmacionEliminacion( Auth():rolUuid() ) .or. msgNoYes( "¿Desea eliminar el registro en curso?", "Confirme eliminación" )
      ::oWindowsBar:setComboFilterItem( "" )
      ::oWindowsBar:evalComboFilterChange()
      ::oFilterController:oModel:deleteById( { nId } )
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

      if !empty( ::oFilterController )

         cFilterSentence      := ::oFilterController:getFilterSentence( cFilterName )

         ::getModel():setFilterWhere( cFilterSentence )
      
         ::showEditAndDeleteButtonFilter()

      end if 
   
   end if  

   ::reBuildRowSet()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD buildFilter( cFilter )

   ::getModel():insertFilterWhere( cFilter )

   if !empty( ::oFilterController )

      ::oFilterController:setComboFilterItem( ::getModel():getFilterWhere() )   

      ::oFilterController:showCleanButtonFilter()   

   end if 

   ::reBuildRowSet()
   
RETURN ( nil )

//----------------------------------------------------------------------------//

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

//----------------------------------------------------------------------------//

METHOD clearFilter()

   ::getModel():clearFilterWhere()

   if !empty( ::oFilterController )
      ::oFilterController:setComboFilterItem( ::getModel():getFilterWhere() )   
   end if 

   ::reBuildRowSet()
   
RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD EnableWindowsBar()

   if empty( ::oWindowsBar )
      RETURN ( nil )
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

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD DisableWindowsBar()

   if empty( ::oWindowsBar )
      RETURN ( nil )
   end if 

   ::oWindowsBar:disableGet()

   ::oWindowsBar:disableComboBox()

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

   local oComboBox   := ::getComboBoxOrder()

   if empty( oComboBox )
      RETURN ( nil )
   end if 

   if empty( ::getBrowseView() )
      RETURN ( nil )
   end if 

   if empty( oColumn )
      oColumn        := ::getBrowseView():getColumnByHeader( oComboBox:VarGet() )
   end if 

   if empty( oColumn )
      RETURN ( nil )
   end if 

   oComboBox:Set( oColumn:cHeader )

   ::getBrowseView():changeColumnOrder( oColumn )

   ::changeModelOrderAndOrientation( oColumn:cSortOrder, oColumn:cOrder )

   ::getBrowseView():refreshCurrent()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD getComboBoxOrder()

   if !empty( ::oSelectorView ) .and. ::oSelectorView:isActive()
      RETURN ( ::oSelectorView:getComboBoxOrder() )
   end if 

   if !empty( ::oDialogModalView ) .and. ::oDialogModalView:isActive()
      RETURN ( ::oDialogModalView:getComboBoxOrder() )
   end if 

   if !empty( ::oWindowsBar )
      RETURN ( ::oWindowsBar:oComboBox() ) 
   end if 

RETURN ( nil ) 

//---------------------------------------------------------------------------//
   