#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS SQLBrowseController FROM SQLBaseController

   DATA oBrowseView

   METHOD New()

   METHOD getDialogView()                             INLINE ( ::oDialogView )

   METHOD ActivateNavigatorView()

   METHOD ActivateSelectorView()

   METHOD changeModelOrderAndOrientation( cColumnOrder, cColumnOrientation )

   METHOD addFastKey( uKey, bAction )

   METHOD onKeyChar( nKey )

   // Rowset-------------------------------------------------------------------

   METHOD getRowSet()                                 INLINE ( ::oRowSet )
   METHOD saveRecNo()                                 INLINE ( ::oRowSet:saveRecNo() )
   METHOD setRecNo()                                  INLINE ( ::oRowSet:setRecNo() )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oSenderController )

   ::Super:New()

   ::oBrowseView                                   := SQLBrowseView():New( self )

   ::oRowSet                                          := SQLRowSet():New( self )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD ActivateNavigatorView()

   if empty( ::oBrowseView )
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

   ::oBrowseView:Activate()

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

METHOD changeModelOrderAndOrientation( cColumnOrder, cColumnOrientation )

   ::oRowSet:saveRecno()

   ::oModel:setColumnOrder( cColumnOrder )

   ::oModel:setColumnOrientation( cColumnOrientation )

   ::oRowSet:build( ::oModel:getSelectSentence() )

   ::oRowSet:gotoRecno()

RETURN ( self )

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

   if empty( ::oFilterController )
      RETURN ( Self )    
   end if 

   ::oFilterController:Append()

RETURN ( Self )    
    
//---------------------------------------------------------------------------//

METHOD editFilter()  

   local nId 
   local cFilter 

   if empty( ::oFilterController )
      RETURN ( Self )    
   end if 

   cFilter        := ::oWindowsBar:GetComboFilter()

   if empty( cFilter )
      RETURN ( Self )    
   end if 

   nId            := ::oFilterController:getFilterId( cFilter )

   msgalert( nId, "nId" )

   ::oFilterController:Edit( nId )

   msgalert( "editFilter")

RETURN ( Self )    
    
//---------------------------------------------------------------------------//
    
METHOD deleteFilter()                                

   if empty( ::oFilterController )
      RETURN ( Self )    
   end if 

   msgalert( "deleteFilter")

RETURN ( Self )    
    
//---------------------------------------------------------------------------//

METHOD setFilter()         

   local cFilter  := ::oWindowsBar:GetComboFilter()

   if empty( cFilter )

      ::getModel():clearFilterWhere()
   
      ::hideEditAndDeleteButtonFilter()
   
   else 
   
      ::getModel():setFilterWhere( ::oFilterController:getFilterSentence( cFilter ) )
   
      ::showEditAndDeleteButtonFilter()
   
   end if  

   msgalert( ::getModel():getGeneralSelect(), "cSentence" )

   ::getModel():buildRowSet()

RETURN ( Self )    
    
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

   ::oBrowseView:Refresh()

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
