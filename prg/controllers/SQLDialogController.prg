#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS SQLDialogController FROM SQLNavigatorController

   DATA oDialogModalView

   DATA oFilterController 

   DATA oVistaModel

   DATA lDocuments                                    INIT .f.

   DATA lOthers                                       INIT .f.

   DATA lLabels                                       INIT .f.

   DATA lConfig                                       INIT .f.

   DATA hFastKey                                      INIT {=>}

   DATA oWindowsBar

   METHOD New()
   METHOD End()

   METHOD Delete( aSelected )                         INLINE ( ::Super:Delete( aSelected ) )

   METHOD buildRowSetSentence() 

   METHOD activateNavigatorView()

   METHOD activateDialogView()

   METHOD activateSelectorView()
   METHOD activateSelectorViewNoCenter()              INLINE ( ::ActivateSelectorView( .f. ) )

   METHOD closeAllWindows()                           INLINE ( iif( !empty( oWnd() ), ( SysRefresh(), oWnd():CloseAll(), SysRefresh() ), ) )

   METHOD setFastReport( oFastReport, cTitle, cSentence, cColumns )    

   METHOD addFastKey( uKey, bAction )

   METHOD onKeyChar( nKey )

   METHOD reBuildRowSet()

   METHOD getComboBoxOrder()                          INLINE ( iif( !empty( ::oSelectorView ) .and. ::oSelectorView:isActive(),;
                                                                     ::oSelectorView:getComboBoxOrder(),;
                                                                     ::oWindowsBar:oComboBox() ) )

   METHOD onChangeCombo( oColumn )

   METHOD setComboColumn( oColumn )   

   METHOD getNavigatorView()                          INLINE ( ::oNavigatorView )

   // Aplication windows bar---------------------------------------------------

   METHOD EnableWindowsBar()

   METHOD DisableWindowsBar()

   METHOD onChangeSearch()                            INLINE ( iif( !empty( ::oNavigatorView ), ::oNavigatorView:onChangeSearch(), ) )

   METHOD hideEditAndDeleteButtonFilter()

   METHOD showEditAndDeleteButtonFilter()

   METHOD getIds()                                    INLINE ( ::oBrowseView:getRowSet():idFromRecno( ::oBrowseView:oBrowse:aSelected ) )

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

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController )

   ::Super:New( oController )

   ::oSelectorView                                    := SQLSelectorView():New( self )

   ::oDialogModalView                                 := SQLDialogView():New( self )

   ::oFilterController                                := SQLFiltrosController():New( self ) 

   ::oVistaModel                                      := SQLConfiguracionVistasModel():New( self )

   ::oWindowsBar                                      := oWndBar()

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD End()

   ::DisableWindowsBar()

   if !empty( ::oSelectorView )
      ::oSelectorView:End()
      ::oSelectorView         := nil
   end if 

   if !empty( ::oFilterController )
      ::oFilterController:End() 
      ::oFilterController     := nil
   end if 

   if !empty( ::oVistaModel )
      ::oVistaModel:End()
      ::oVistaModel           := nil
   end if 

   ::Super():End()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD buildRowSetSentence()

   local cColumnOrder
   local cColumnOrientation 

   cColumnOrder               := ::oVistaModel:getColumnOrderNavigator( ::getName() )

   cColumnOrientation         := ::oVistaModel:getColumnOrientationNavigator( ::getName() )   

   ::getRowSet():build( ::getModel():getSelectSentence( cColumnOrder, cColumnOrientation ) )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD activateNavigatorView()

   if empty( ::oNavigatorView )
      RETURN ( nil )
   end if 

   if ::notUserAccess()
      msgStop( "Acceso no permitido." )
      RETURN ( nil )
   end if

   cursorWait()

   ::closeAllWindows()

   ::buildRowSetSentence()   

   if !empty( ::getRowSet():get() )

      ::oNavigatorView:Activate()
      
      ::EnableWindowsBar()

   endif 

   cursorWE()

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

   if empty( ::getRowSet():get() )
      RETURN ( nil )
   end if

RETURN ( ::oSelectorView:Activate( lCenter ) )

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

   if empty( ::getRowSet():get() )
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
      RETURN ( nil )  
   end if 

   if empty( ::oFilterController )
      RETURN ( nil )  
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

      cFilterSentence      := ::oFilterController:getFilterSentence( cFilterName )

      ::getModel():setFilterWhere( cFilterSentence )
   
      ::showEditAndDeleteButtonFilter()
   
   end if  

   ::reBuildRowSet()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD buildFilter( cFilter )

   ::getModel():insertFilterWhere( cFilter )

   ::oFilterController:setComboFilterItem( ::getModel():getFilterWhere() )   

   ::reBuildRowSet()
   
RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD clearFilter()

   ::getModel():clearFilterWhere()

   ::oFilterController:setComboFilterItem( ::getModel():getFilterWhere() )   

   ::reBuildRowSet()
   
RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD buildCustomFilter( cField, cValue, cOperator )

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

   nId               := ::getRowSet():fieldGet( ::getModelColumnKey() )
   
   ::getRowSet():build( ::getModel():getSelectSentence() )

   ::getRowSet():findString( nId )
      
   ::getBrowse():Refresh()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD EnableWindowsBar()

   if empty( ::oWindowsBar )
      RETURN ( nil )
   end if 

   ::oWindowsBar:enableGet()

   ::oWindowsBar:enableComboFilter( ::getFilters() )

   ::oWindowsBar:showAddButtonFilter()

   ::oWindowsBar:setComboFilterChange( {|| ::setFilter() } )

   ::oWindowsBar:setActionAddButtonFilter( {|| ::appendFilter() } )

   ::oWindowsBar:setActionEditButtonFilter( {|| ::editFilter() } )

   ::oWindowsBar:setActionDeleteButtonFilter( {|| ::deleteFilter() } )

   ::oWindowsBar:setGetChange( {|| ::onChangeSearch() } )

   ::oNavigatorView:Refresh()

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

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD showEditAndDeleteButtonFilter()

   ::oWindowsBar:ShowCleanButtonFilter()

   ::oWindowsBar:ShowEditButtonFilter()

   ::oWindowsBar:ShowDeleteButtonFilter()

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD onChangeCombo( oColumn )

   ::setComboColumn( oColumn )

   ::changeModelOrderAndOrientation( oColumn:cSortOrder, oColumn:cOrder )

   ::getBrowse():changeColumnOrder( oColumn )

   ::getBrowse():refreshCurrent()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD setComboColumn( oColumn )

   if empty( ::getComboBoxOrder() )
      RETURN ( Self )
   end if 

   if empty( ::getBrowse() )
      RETURN ( Self )
   end if 

   ::getComboBoxOrder():Set( oColumn:cHeader )

RETURN ( nil )

//---------------------------------------------------------------------------//

   