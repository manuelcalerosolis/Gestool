#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS SQLNavigatorController FROM SQLBaseController

   DATA oSelectorView

   DATA oNavigatorView

   DATA oFilterController 

   DATA lDocuments                                    INIT .f.

   DATA lLabels                                       INIT .f.

   DATA hDocuments

   DATA hFastKey                                      INIT {=>}

   DATA oWindowsBar

   METHOD New()

   METHOD ActivateNavigatorView()

   METHOD ActivateSelectorView()

   METHOD setFastReport( oFastReport, cTitle, cSentence, cColumns )    

   METHOD addFastKey( uKey, bAction )

   METHOD onKeyChar( nKey )

   METHOD appendFilter()                              

   METHOD editFilter()                                

   METHOD deleteFilter()                                

   METHOD getFilters()                                INLINE ( if( !empty( ::oFilterController ), ::oFilterController:getFilters(), ) ) 

   METHOD setFilter()                                                                                                       

   METHOD getComboBoxOrder()                          INLINE ( ::oWindowsBar:oComboBox() )

   METHOD onChangeCombo( oColumn )

   // Aplication windows bar---------------------------------------------------

   METHOD EnableWindowsBar()

   METHOD DisableWindowsBar()

   METHOD hideEditAndDeleteButtonFilter()

   METHOD showEditAndDeleteButtonFilter()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oSenderController )

   ::Super:New( oSenderController )

   ::oNavigatorView                                   := SQLNavigatorView():New( self )

   ::oSelectorView                                    := SQLSelectorView():New( self )

   ::oFilterController                                := SQLFiltrosController():New( self ) 

   ::oWindowsBar                                      := oWndBar()

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD ActivateNavigatorView()

   if empty( ::oNavigatorView )
      RETURN ( Self )
   end if 

   if ::notUserAccess()
      msgStop( "Acceso no permitido." )
      RETURN ( Self )
   end if

   if oWnd() != nil
      SysRefresh(); oWnd():CloseAll(); SysRefresh()
   end if

   ::oRowSet:build( ::oModel:getSelectSentence() )

   ::oNavigatorView:Activate()

   ::EnableWindowsBar()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD ActivateSelectorView()

   if empty( ::oSelectorView )
      RETURN ( nil )
   end if 

   if ::notUserAccess()
      msgStop( "Acceso no permitido." )
      RETURN ( nil )
   end if

   ::oRowSet:build( ::oModel:getSelectSentence() )

RETURN ( ::oSelectorView:Activate() )

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
    
   DEFAULT cColumns  := ::oModel:getSerializeColumns()       
    
   oRowSet           := ::oModel:newRowSet( cSentence )      
    
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

   ::oFilterController:Append()

RETURN ( Self )    
    
//---------------------------------------------------------------------------//

METHOD editFilter()  

   local nId 
   local cFilter  := ::oWindowsBar:GetComboFilter()

   if empty( cFilter )
      RETURN ( Self )    
   end if 

   nId            := ::oFilterController:getFilterId( cFilter )

   if !empty( nId )
      ::oFilterController:Edit( nId )
   end if 

RETURN ( Self )    
    
//---------------------------------------------------------------------------//
    
METHOD deleteFilter()                                

   local nId 
   local cFilter  := ::oWindowsBar:GetComboFilter()

   if empty( cFilter )
      RETURN ( Self )    
   end if 

   nId            := ::oFilterController:getFilterId( cFilter )

   if !empty( nId )
      ::oFilterController:Delete( nId )
   end if 

   msgalert( "deleteFilter")

RETURN ( Self )    
    
//---------------------------------------------------------------------------//

METHOD setFilter()         

   local nId      
   local cFilter  := ::oWindowsBar:GetComboFilter()

   if empty( cFilter )

      ::getModel():clearFilterWhere()
   
      ::hideEditAndDeleteButtonFilter()
   
   else 
   
      ::getModel():setFilterWhere( ::oFilterController:getFilterSentence( cFilter ) )
   
      ::showEditAndDeleteButtonFilter()
   
   end if  

   nId            := ::oRowSet:fieldGet( ::getModelColumnKey() )
   
   ::oRowSet:build( ::oModel:getSelectSentence() )

   ::oRowSet:find( nId )
      
   ::getBrowse():Refresh()

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD EnableWindowsBar()

   if empty( ::oWindowsBar )
      RETURN ( Self )
   end if 

   ::oWindowsBar:enableGet()

   ::oWindowsBar:enableComboBox( ::oBrowseView:getColumnsHeaders() )

   // ::oBrowseView:selectColumnOrder( ::oBrowseView:getFirstColumnHeader() )

   ::oWindowsBar:enableComboFilter( ::getFilters() )

   ::oWindowsBar:showAddButtonFilter()

   ::oWindowsBar:setComboFilterChange( {|| ::setFilter() } )

   ::oWindowsBar:setActionAddButtonFilter( {|| ::appendFilter() } )

   ::oWindowsBar:setActionEditButtonFilter( {|| ::editFilter() } )

   ::oWindowsBar:setActionDeleteButtonFilter( {|| ::deleteFilter() } )

   ::oNavigatorView:Refresh()

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

   if empty( oColumn )
      oColumn        := ::getBrowse():getColumnByHeader( oComboBox:VarGet() )
   end if 

   if empty( oColumn )
      RETURN ( Self )
   end if 

   oComboBox:set( oColumn:cHeader )

   ::changeModelOrderAndOrientation( oColumn:cSortOrder, oColumn:cOrder )

   ::getBrowse():selectColumnOrder( oColumn )

   ::getBrowse():refreshCurrent()

RETURN ( Self )

//---------------------------------------------------------------------------//
