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

   DATA     cTitle                                    INIT ""

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

   METHOD   setTitle( cTitle )                        INLINE ( ::cTitle := cTitle )
   METHOD   getTitle()                                INLINE ( ::cTitle )

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

   METHOD   findGet( oFind )
   METHOD   find( uValue )                            INLINE ( msgalert( uValue, "find" ), ::oModel:find( uValue ) )

   METHOD   findByIdInRowSet( uValue )                INLINE ( if( !empty( ::getRowSet() ), ::getRowset():find( uValue, "id", .t. ), ) )

   METHOD   isValidGet( oGet )
   METHOD 	assignBrowse( oGet, aSelectedItems )
   METHOD   showBrowseInDialog( id )

	METHOD 	startBrowse( oCombobox, oBrowse )
	METHOD 	restoreBrowseState( oBrowse )

   METHOD 	getRowSet()

   METHOD   setFastReport( oFastReport, cSentence, cColumns )

   METHOD   createColumnsForBrowse( oBrowse, oCombobox )

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

   if ::oView:buildSQLBrowse( ::oModel:cWndTitle, aSelectedItems )
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

   uReturn           := ::ActivateBrowse( ::oModel:cWndTitle, aSelectedItems )   

   if !empty(uReturn)
      oGet:cText( uReturn )
   end if 

RETURN ( uReturn )

//--------------------------------------------------------------------------//

METHOD showBrowseInDialog( idResource, idOfHeader )

   local oBrowse

   ::oModel:find( idOfHeader )

   oBrowse           := ::oView:buildSQLNuclearBrowse( idResource )  

RETURN ( oBrowse )

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

   ::oModel:loadBlankBuffer()

   if ::oView:Dialog()
      ::oModel:insertBuffer()
      if ::bOnPostAppend != nil
         lTrigger    := eval( ::bOnPostAppend  )
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

   ::oModel:loadCurrentBuffer()

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

   ::oModel:loadCurrentBuffer()

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

   ::oModel:loadCurrentBuffer()

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

METHOD findGet( oFind )

	local uValue

   if empty( oFind )
      RETURN ( .f. )
   end if 

	uValue        := oFind:oGet:Buffer()
	uValue        := alltrim( upper( cvaltochar( uValue ) ) )
	uValue        := strtran( uValue, chr( 8 ), "" )

RETURN ( ::find( uValue ) )

//---------------------------------------------------------------------------//

METHOD getRowSet()

   if empty( ::oModel:oRowSet )
      ::oModel:buildRowSet()
   end if

Return ( ::oModel:oRowSet )

//---------------------------------------------------------------------------//

METHOD isValidGet( oGet )

   local uValue

   if empty( oGet )
      RETURN ( .t. )
   end if 

   uValue            := oGet:varGet()

   if !::oModel:exist( uValue )
   	msgStop( "El valor introducido no existe", ::getTitle() )
   	oGet:setFocus()
      RETURN .f.
   end if 

   if !empty( oGet:oHelpText )
      oGet:oHelpText:cText( ::oModel:getNameFromId( uValue ) )
   end if

RETURN ( .t. )

//--------------------------------------------------------------------------//

METHOD setFastReport( oFastReport, cSentence, cColumns )

   default cColumns  := ::oModel:serializeColumns() 

   if empty( oFastReport )
      RETURN ( Self )
   end if

   ::oModel:buildRowSet( cSentence )

   if empty( ::oModel:oRowSet )
      RETURN ( Self )
   end if 

   oFastReport:SetUserDataSet(   ::getTitle(),;
                                 cColumns,;
                                 {|| ::oModel:oRowSet:gotop()  },;
                                 {|| ::oModel:oRowSet:skip(1)  },;
                                 {|| ::oModel:oRowSet:skip(-1) },;
                                 {|| ::oModel:oRowSet:eof()    },;
                                 {|nField| ::oModel:oRowSet:fieldGet( nField ) } )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD createColumnsForBrowse( oBrowse, oCombobox )

   local hValues
   local cKey

   for each hValues in ::oModel:hColumns

      cKey := hValues:__enumkey()

      if ( hValues["visible"] )

         with object ( oBrowse:AddCol() )
            :cHeader             := hValues[ "cHeader" ]
            :cSortOrder          := cKey
            :bEditValue          := {|| ::oController:getRowSet():fieldGet( cKey ) }
            :nWidth              := hValues[ "nWidth" ]
            :bLClickHeader       := {| nMRow, nMCol, nFlags, oCol | ::oController:clickOnHeader( oCol, oBrowse, oCombobox ) }
         end with
          
      endif

   next

RETURN ( self )

//---------------------------------------------------------------------------//
