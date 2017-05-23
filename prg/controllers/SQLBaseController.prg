#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Ads.ch"

//---------------------------------------------------------------------------//

CLASS SQLBaseController

   DATA     oModel

   DATA     oView

	DATA     nLevel

   DATA     idUserMap      

   DATA     nMode                                     AS NUMERIC

   DATA     bOnPreAppend
   DATA     bOnPostAppend

   CLASSDATA   oInstance 
 
   METHOD   New()

   METHOD   Instance()                                INLINE ( if( empty( ::oInstance ), ::oInstance := ::New(), ), ::oInstance ) 

   METHOD   destroySQLModel()                         INLINE ( if( !empty(::oModel), ::oModel:end(), ) )

	METHOD   ActivateShell()
	METHOD   ActivateBrowse()

   METHOD   isUserAccess()                            INLINE ( nAnd( ::nLevel, ACC_ACCE ) == 0 )
   METHOD   notUserAccess()                           INLINE ( !::isUserAccess() )
   METHOD   isUserAppend()                            INLINE ( nAnd( ::nLevel, ACC_APPD ) != 0 )
   METHOD   notUserAppend()                           INLINE ( !::isUserAppend() )
   METHOD   isUserDuplicate()                         INLINE ( nAnd( ::nLevel, ACC_APPD ) != 0 )
   METHOD   notUserDuplicate()                        INLINE ( !::isUserDuplicate() )
   METHOD   isUserEdit()                              INLINE ( nAnd( ::nLevel, ACC_EDIT ) != 0 )
   METHOD   notUserEdit()                             INLINE ( !::isUserEdit() )
   METHOD   isUserDelete()                            INLINE ( nAnd( ::nLevel, ACC_DELE ) != 0 )
   METHOD   notUserDelete()                           INLINE ( !::isUserDelete() )
   METHOD   isUserZoom()                              INLINE ( nAnd( ::nLevel, ACC_ZOOM ) != 0 )
   METHOD   notUserZoom()                             INLINE ( !::isUserZoom() )

   METHOD   setMode( nMode )                          INLINE ( ::nMode := nMode )
   METHOD   getMode()                                 INLINE ( ::nMode )

	METHOD   Append( oBrowse )
      METHOD setAppendMode()                          INLINE ( ::setMode( __append_mode__ ) )
      METHOD isAppendMode()                           INLINE ( ::nMode == __append_mode__ )

   METHOD   Duplicate( oBrowse )
      METHOD setDuplicateMode()                       INLINE ( ::nMode := __duplicate_mode__ )
      METHOD isDuplicateMode()                        INLINE ( ::nMode == __duplicate_mode__ )

   METHOD   Edit( oBrowse )
      METHOD preEdit()                                VIRTUAL
      METHOD postEdit()                               VIRTUAL
      METHOD setEditMode()                            INLINE ( ::nMode := __edit_mode__ )
      METHOD isEditMode()                             INLINE ( ::nMode == __edit_mode__ )

   METHOD   Zoom( oBrowse )
      METHOD setZoomMode()                            INLINE ( ::nMode := __zoom_mode__ )
      METHOD isZoomMode()                             INLINE ( ::nMode == __zoom_mode__ )

   METHOD   Delete( oBrowse )

   METHOD   clickOnHeader( oColumn, oBrowse, oCombobox )

	METHOD   getHistory( cWnd )
   METHOD      getHistoryShell()                      
   METHOD      getHistoryBrowse()                     INLINE ( ::getHistory( "_browse" ) )
              
   METHOD   saveHistory( cHistory, oBrowse )

   METHOD   find( oFind )

   METHOD   isValidGet( oGet )
   METHOD 	assignBrowse( oGet, aSelectedItems )

	METHOD 	startBrowse( oCombobox, oBrowse )
	METHOD 	restoreBrowseState( oBrowse )

   METHOD   loadBuffer( id )
   METHOD   loadBlankBuffer()
   METHOD   loadCurrentBuffer()

   METHOD 	getRowSet()

END CLASS

//---------------------------------------------------------------------------//

METHOD New()

	::nLevel                                           := nLevelUsr( ::idUserMap )

   ::oModel                                           := ::buildSQLModel( self )

   ::oView                                            := ::buildSQLView( self )

RETURN ( self )

//---------------------------------------------------------------------------//


METHOD ActivateShell()

   if ::notUserAccess()
      msgStop( "Acceso no permitido." )
      RETURN ( Self )
   end if

   if oWnd() != nil
      SysRefresh(); oWnd():CloseAll(); SysRefresh()
   end if

   ::getHistoryShell()

   ::oModel:buildRowSetWithRecno()

   ::oView:buildSQLShell()

   ::startBrowse( ::oView:oShell:getCombobox(), ::oView:oShell:getBrowse() )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD ActivateBrowse( aSelectedItems )

   local uReturn

   ::getHistoryBrowse()

   ::oModel:buildRowSetWithRecno()

   if ::oView:buildSQLBrowse( aSelectedItems )
      uReturn     := ::getFieldFromBrowse() 
   end if

   ::destroySQLModel()

RETURN ( uReturn )

//---------------------------------------------------------------------------//

METHOD startBrowse( oCombobox, oBrowse )

   local oColumn

   if empty( oBrowse )
      RETURN ( Self )
   end if 

   oCombobox:SetItems( oBrowse:getColumnHeaders() )

   ::restoreBrowseState( oBrowse )

   oColumn        := oBrowse:getColumnOrder( ::oModel:cColumnOrder )
   if empty( oColumn )
      RETURN ( Self )
   end if 
   
   oCombobox:set( oColumn:cHeader )

   oBrowse:selectColumnOrder( oColumn, ::oModel:cOrientation )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD restoreBrowseState( oBrowse )

   if empty(oBrowse)
      RETURN ( Self )
   end if 

   if empty( ::oView:getBrowseState() )
      RETURN ( Self )
   end if 

   oBrowse:restoreState( ::oView:getBrowseState() )

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD AssignBrowse( oGet, aSelectedItems )

   local uReturn

   if empty( oGet )
      RETURN ( uReturn )
   end if

   ::oModel:setIdForRecno( oGet:varGet() )

   uReturn           := ::ActivateBrowse( aSelectedItems )   

   if !empty(uReturn)
      oGet:cText( uReturn )
   end if 

RETURN ( uReturn )

//--------------------------------------------------------------------------//

METHOD getHistory( cWnd )

   local hFetch      := HistoricosUsuariosModel():New():getHistory( ::oModel:cTableName + cWnd )

   if empty(hFetch)
   	 RETURN ( nil )
   endif

   if hhaskey( hFetch, "cBrowseState" )
      ::oView:setBrowseState( hFetch[ "cBrowseState" ] )
   endif
   
RETURN ( hFetch )

//----------------------------------------------------------------------------//

METHOD getHistoryShell()

   local hFetch   := ::getHistory( "_shell" )

   if empty(hFetch)
   	 RETURN ( nil )
   endif

   if hhaskey( hFetch, "cColumnOrder" )
      ::oModel:setColumnOrder( hFetch[ "cColumnOrder" ] )
   end if 

   if hhaskey( hFetch, "cOrientation" )
      ::oModel:setOrientation( hFetch[ "cOrientation" ] )
   end if 

   if hhaskey( hFetch, "nIdForRecno" ) 
      ::oModel:setIdForRecno( hFetch[ "nIdForRecno" ] )
   end if
   
RETURN ( self )

//----------------------------------------------------------------------------//

METHOD saveHistory( cWnd, oBrowse )

   local cBrowseState   := "null"

   if !empty( oBrowse ) 
      cBrowseState      := quoted( oBrowse:saveState() )
   end if

   HistoricosUsuariosModel():New():saveHistory( ::oModel:cTableName + cWnd, cBrowseState, ::oModel:cColumnOrder, ::oModel:cOrientation, ::oModel:getKeyFieldOfRecno() ) 

Return ( .t. )

//----------------------------------------------------------------------------//

METHOD clickOnHeader( oColumn, oBrowse, oCombobox )

   oBrowse:selectColumnOrder( oColumn )

   if !empty( oCombobox )
      oCombobox:set( oColumn:cHeader )
   end if

   ::oModel:setIdForRecno( ::oModel:getKeyFieldOfRecno() )

   ::oModel:setColumnOrder( oColumn:cSortOrder )

   ::oModel:setOrientation( oColumn:cOrder )

   ::oModel:buildRowSetWithRecno()

   oBrowse:refreshCurrent()

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD Append( oBrowse )

   local nRecno   
   local lTrigger

   if ::notUserAppend()
      msgStop( "Acceso no permitido." )
      RETURN ( .f. )
   end if 

   ::setAppendMode()

   if ::bOnPreAppend != nil
      lTrigger    := eval( ::bOnPreAppend )
      if Valtype( lTrigger ) == "L" .and. !lTrigger
         RETURN ( .f. )
      end if
   end if

   nRecno         := ::oModel:getRowSetRecno()

   ::loadBlankBuffer()

   if ::oView:Dialog()

      ::oModel:insertBuffer()

      if ::bOnPostAppend != nil
         lTrigger    := eval( ::bOnPostAppend,  )
         if Valtype( lTrigger ) == "L" .and. !lTrigger
            RETURN ( .f. )
         end if
      end if

   else 
      
      ::oModel:setRowSetRecno( nRecno ) 

      RETURN ( .f. )

   end if

   if !empty( oBrowse )
      oBrowse:refreshCurrent()
      oBrowse:setFocus()
   end if 

RETURN ( .t. )

//----------------------------------------------------------------------------//

METHOD Duplicate( oBrowse )

   local nRecno   

   if ::notUserDuplicate()
      msgStop( "Acceso no permitido." )
      RETURN ( Self )
   end if 

   ::setDuplicateMode()

   nRecno         := ::oModel:getRowSetRecno()

   ::loadCurrentBuffer()

   if ::oView:Dialog( ::oModel )
      ::oModel:insertBuffer()
   else 
      ::oModel:setRowSetRecno( nRecno ) 
   end if

   if !empty( oBrowse )
      oBrowse:refreshCurrent()
      oBrowse:setFocus()
   end if

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD Edit( oBrowse )  

   if ::notUserEdit()
      msgStop( "Acceso no permitido." )
      RETURN ( Self )
   end if 

   ::setEditMode()

   ::preEdit()

   ::oModel:setIdForRecno( ::oModel:getKeyFieldOfRecno() )

   ::loadCurrentBuffer()

   if ::oView:Dialog( ::oModel )
      
      ::oModel:updateCurrentBuffer()

      ::postEdit()

   end if 

   if !empty( oBrowse )
      oBrowse:refreshCurrent()
      oBrowse:setFocus()
   end if 

RETURN ( .t. )

//----------------------------------------------------------------------------//

METHOD Zoom( oBrowse )

   if ::notUserZoom()
      msgStop( "Acceso no permitido." )
      RETURN ( Self )
   end if 

   ::setZoomMode()

   ::loadCurrentBuffer()

   ::oView:Dialog( ::oModel )

   if !empty( oBrowse )
      oBrowse:setFocus()
   end if 

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD Delete( oBrowse )

   local nSelected      
   local cNumbersOfDeletes

   if ::notUserDelete()
      msgStop( "Acceso no permitido." )
      RETURN ( Self )
   end if 

   if empty( oBrowse )
      msgStop( "Faltan parametros." )
      RETURN ( Self )
   end if 

   nSelected            := len( oBrowse:aSelected )

   if nSelected > 1
      cNumbersOfDeletes := alltrim( str( nSelected, 3 ) ) + " registros?"
   else
      cNumbersOfDeletes := "el registro en curso?"
   end if

   if oUser():lNotConfirmDelete() .or. msgNoYes( "¿Desea eliminar " + cNumbersOfDeletes, "Confirme eliminación" )
      ::oModel:deleteSelection( oBrowse:aSelected )
   end if 

   oBrowse:refreshCurrent()
   oBrowse:setFocus()

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD find( oFind )

	local lFind
	local xValueToSearch

	xValueToSearch    := oFind:oGet:Buffer()
	xValueToSearch    := alltrim( upper( cvaltochar( xValueToSearch ) ) )
	xValueToSearch    := strtran( xValueToSearch, chr( 8 ), "" )
	lFind             := ::oModel:find( xValueToSearch )

RETURN ( lFind )

//----------------------------------------------------------------------------//

METHOD loadBlankBuffer()

   if empty( ::oModel:oRowSet )
      Return ( .f. )
   end if 

Return ( ::loadBuffer( 0 ) )

//---------------------------------------------------------------------------//

METHOD loadCurrentBuffer()                

   local aColumnNames := hb_hkeys( ::oModel:hColumns )

   if empty( ::oModel:oRowSet )
      Return ( .f. )
   end if 

   ::oModel:hBuffer  := {=>}

   aeval( aColumnNames, {| k | hset( ::oModel:hBuffer, k, ::oModel:oRowSet:fieldget( k ) ) } )

Return ( ::oModel:hBuffer )   

//---------------------------------------------------------------------------//

METHOD loadBuffer( id )

   local aColumnNames := hb_hkeys( ::oModel:hColumns )

   ::oModel:hBuffer  := {=>}

   ::oModel:oRowSet:goto( id )

   aeval( aColumnNames, {| k | hset( ::oModel:hBuffer, k, ::oModel:oRowSet:fieldget( k ) ) } )

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD getRowSet()

   if empty( ::oModel:oRowSet )
      ::oModel:buildRowSet()
   end if

Return ( ::oModel:oRowSet )

//---------------------------------------------------------------------------//

METHOD isValidGet( oGet )

   local uValue
   local uReturn     := .t.

   msgalert( "estoy en el valid del get" )

   if empty( oGet )
      RETURN ( uReturn )
   end if 

   uValue            := oGet:varGet()

   msgalert( uValue, "uValue" )

   msgalert( hb_valtoexp( ::oModel ), "este es el modelo" )

   if !( ::oModel:exist( uValue ) )
      RETURN .f.
   end if 

   msgalert( !empty( oGet:oHelpText ), "oHelpText")

   if !empty( oGet:oHelpText )
      oGet:oHelpText:cText( ::oModel:getNameFromId( uValue ) )
   end if 

RETURN ( uReturn )

//--------------------------------------------------------------------------//
