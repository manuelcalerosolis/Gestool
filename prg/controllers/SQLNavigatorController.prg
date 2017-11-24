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

   DATA oRowSet
 
   METHOD New()

   METHOD getDialogView()                             INLINE ( ::oDialogView )

   METHOD ActivateNavigatorView()

   METHOD ActivateSelectorView()

   METHOD changeModelOrderAndOrientation( cColumnOrder, cColumnOrientation )

   METHOD setFastReport( oFastReport, cTitle, cSentence, cColumns )    

   METHOD addFastKey( uKey, bAction )

   METHOD onKeyChar( nKey )

   METHOD appendFilter()                              

   METHOD editFilter()                                

   METHOD deleteFilter()                                

   METHOD getFilters()                                INLINE ( if( !empty( ::oFilterController ), ::oFilterController:getFilters(), ) ) 

   METHOD setFilter()                                                                                                       

   METHOD getModelColumnsForBrowse()                  INLINE ( ::getModel():getColumnsForBrowse() )

   METHOD getModelHeadersForBrowse()                  INLINE ( ::getModel():getHeadersForBrowse() )

   // Rowset-------------------------------------------------------------------

   METHOD getRowSet()                                 INLINE ( ::oRowSet )

   // Aplication windows bar---------------------------------------------------

   METHOD EnableWindowsBar()

   METHOD DisableWindowsBar()

   METHOD hideEditAndDeleteButtonFilter()

   METHOD showEditAndDeleteButtonFilter()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oSenderController )

   ::oSenderController                                := oSenderController

   ::oEvents                                          := Events():New()

   ::ControllerContainer                              := ControllerContainer():New()

   ::oNavigatorView                                   := SQLNavigatorView():New( self )

   ::oSelectorView                                    := SQLSelectorView():New( self )

   ::oFilterController                                := SQLFiltrosController():New( self ) 

   ::oRowSet                                          := SQLRowSet():New( self )

   ::oWindowsBar                                      := oWndBar()

   if !empty( ::oModel )
      ::oFilterController:setTableName( ::oModel:cTableName )
   end if 

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

   ::oModel:buildRowSet()

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

   ::oWindowsBar:enableComboBox( ::getModelHeadersForBrowse() )

   ::oWindowsBar:setCombo( ::getModelHeaderFromColumnOrder() )

   ::oWindowsBar:enableComboFilter( ::getFilters() )

   ::oWindowsBar:setComboFilterChange( {|| ::setFilter() } )

   ::oWindowsBar:showAddButtonFilter()

   ::oWindowsBar:setActionAddButtonFilter( {|| ::appendFilter() } )

   ::oWindowsBar:setActionEditButtonFilter( {|| ::editFilter() } )

   ::oWindowsBar:setActionDeleteButtonFilter( {|| ::deleteFilter() } )

   ::oNavigatorView:getBrowse():selectColumnOrderByHeader( ::getModelHeaderFromColumnOrder() )

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
