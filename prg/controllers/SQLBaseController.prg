#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Ads.ch"

//---------------------------------------------------------------------------//

CLASS SQLBaseController

   CLASSDATA   oInstance 

   DATA     ControllerContainer

   DATA     oModel

   DATA     oView

   DATA     nLevel

   DATA     idUserMap      

   DATA     nMode                                     AS NUMERIC

   DATA     bOnPreAppend
   DATA     bOnPostAppend

   DATA     cTitle                                    INIT ""
 
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

	METHOD   Append()
      METHOD initAppendMode()                         VIRTUAL
      METHOD endAppendModePreInsert()                 VIRTUAL
      METHOD endAppendModePosInsert()                 VIRTUAL
      METHOD cancelAppendMode()                       VIRTUAL
      METHOD setAppendMode()                          INLINE ( ::setMode( __append_mode__ ) )
      METHOD isAppendMode()                           INLINE ( ::nMode == __append_mode__ )

   METHOD   Duplicate()
      METHOD initDuplicateMode()                      VIRTUAL
      METHOD endDuplicateModePreInsert()              VIRTUAL
      METHOD endDuplicateModePosInsert()              VIRTUAL
      METHOD cancelDuplicateMode()                    VIRTUAL
      METHOD setDuplicateMode()                       INLINE ( ::nMode := __duplicate_mode__ )
      METHOD isDuplicateMode()                        INLINE ( ::nMode == __duplicate_mode__ )

   METHOD   Edit()
      METHOD initEditMode()                           VIRTUAL
      METHOD endEditModePreUpdate()                   VIRTUAL
      METHOD endEditModePosUpdate()                   VIRTUAL
      METHOD cancelEditMode()                         VIRTUAL
      METHOD setEditMode()                            INLINE ( ::nMode := __edit_mode__ )
      METHOD isEditMode()                             INLINE ( ::nMode == __edit_mode__ )

   METHOD   Zoom()
      METHOD setZoomMode()                            INLINE ( ::nMode := __zoom_mode__ )
      METHOD isZoomMode()                             INLINE ( ::nMode == __zoom_mode__ )
      METHOD initZoomMode()                           VIRTUAL

   METHOD   Delete()
      METHOD initDeleteMode()                         VIRTUAL
      METHOD endDeleteModePreDelete()                 VIRTUAL
      METHOD endDeleteModePosDelete()                 VIRTUAL

   METHOD   getIdfromRowset()                         INLINE   ( if( !empty( ::oModel:oRowSet ), ( ::oModel:oRowSet:fieldGet( ::oModel:cColumnKey ) ), ) )

   METHOD   clickOnHeader( oColumn, oCombobox )

	METHOD   getHistory( cWnd )
   METHOD      getHistoryShell()                      
   METHOD      getHistoryBrowse()                     INLINE ( ::getHistory( "_browse" ) )
              
   METHOD   saveHistory( cHistory )
      METHOD   saveHistoryBrowse()                    INLINE ( ::saveHistory( "_browse" ) )

   METHOD   findGet( oFind )
   METHOD   find( uValue )                            INLINE ( ::oModel:find( uValue ) )

   METHOD   findByIdInRowSet( uValue )                INLINE ( if( !empty( ::getRowSet() ), ::getRowset():find( uValue, "id", .t. ), ) )

   METHOD   isValidGet( oGet )
   METHOD   isValidCodigo( oGet )

   METHOD   getIdFromCodigo( codigo )                 INLINE ( if( !empty( ::oModel ), ::oModel:getIdFromCodigo( codigo ), ) )

   METHOD 	assignBrowse( oGet, aSelectedItems )
	METHOD 	startBrowse( oCombobox )
	METHOD 	restoreBrowseState()

   METHOD 	getRowSet()

   METHOD   setFastReport( oFastReport, cSentence, cColumns )

   METHOD generateColumnsForBrowse( oCombobox )
   METHOD   createColumnsForBrowse( oCombobox )
   METHOD   addColumnsForBrowse( oCombobox )          VIRTUAL

   METHOD getController( cController )                INLINE ( ::ControllerContainer:get( cController ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD New()

   ::ControllerContainer                              := ControllerContainer():New()

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

   ::startBrowse( ::oView:oShell:getCombobox() )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD ActivateBrowse( aSelectedItems )

   local uReturn

   ::getHistoryBrowse()

   ::oModel:buildRowSetWithRecno()

   if ::oView:buildSQLBrowse( ::cTitle, aSelectedItems )
      uReturn     := ::getFieldFromBrowse()
   end if

   ::destroySQLModel()

RETURN ( uReturn )

//---------------------------------------------------------------------------//

METHOD startBrowse( oCombobox )

   local oColumn

   if empty( ::oView:getoBrowse() )
      RETURN ( Self )
   end if 

   if (!empty( oCombobox ) )
   oCombobox:SetItems( ::oView:getoBrowse():getColumnHeaders() )
   endif

   ::restoreBrowseState()

   oColumn        := ::oView:getoBrowse():getColumnOrder( ::oModel:cColumnOrder )
   if empty( oColumn )
      RETURN ( Self )
   end if 
   
   if (!empty( oCombobox ) )
      oCombobox:set( oColumn:cHeader )
   endif

   ::oView:getoBrowse():selectColumnOrder( oColumn, ::oModel:cOrientation )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD restoreBrowseState()

   if empty(::oView:getoBrowse())
      RETURN ( Self )
   end if 

   if empty( ::oView:getBrowseState() )
      RETURN ( Self )
   end if 

   ::oView:getoBrowse():restoreState( ::oView:getBrowseState() )

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD AssignBrowse( oGet, aSelectedItems )

   local uReturn

   if empty( oGet )
      RETURN ( uReturn )
   end if

   ::oModel:setIdForRecno( oGet:varGet() )

   uReturn           := ::ActivateBrowse( ::cTitle, aSelectedItems )   

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

METHOD saveHistory( cWnd )

   local cBrowseState   := "null"

   if !empty( ::oView:getoBrowse() ) 
      cBrowseState      := quoted( ::oView:getoBrowse():saveState() )
   end if

   HistoricosUsuariosModel():New():saveHistory( ::oModel:cTableName + cWnd, cBrowseState, ::oModel:cColumnOrder, ::oModel:cOrientation, ::getIdfromRowset() ) 

Return ( .t. )

//----------------------------------------------------------------------------//

METHOD clickOnHeader( oColumn, oCombobox )

   ::oView:getoBrowse():selectColumnOrder( oColumn )

   if !empty( oCombobox )
      oCombobox:set( oColumn:cHeader )
   end if

   ::oModel:setIdForRecno( ::getIdfromRowset() )

   ::oModel:setColumnOrder( oColumn:cSortOrder )

   ::oModel:setOrientation( oColumn:cOrder )

   ::oModel:buildRowSetWithRecno()

   ::oView:getoBrowse():refreshCurrent()

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD Append()

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
   
   ::initAppendMode()

   if ::oView:Dialog()

      ::endAppendModePreInsert()

      ::oModel:insertBuffer()

      ::endAppendModePosInsert()

      if ::bOnPostAppend != nil
         lTrigger    := eval( ::bOnPostAppend  )
         if Valtype( lTrigger ) == "L" .and. !lTrigger
            RETURN ( .f. )
         end if
      end if

   else
      ::cancelAppendMode()
      ::oModel:setRowSetRecno( nRecno )
      RETURN ( .f. )
   end if

   if !empty( ::oView:getoBrowse() )
      ::oView:getoBrowse():refreshCurrent()
      ::oView:getoBrowse():setFocus()
   end if

RETURN ( .t. )

//----------------------------------------------------------------------------//

METHOD Duplicate()

   local nRecno   

   if ::notUserDuplicate()
      msgStop( "Acceso no permitido." )
      RETURN ( Self )
   end if 

   ::setDuplicateMode()

   nRecno         := ::oModel:getRowSetRecno()

   ::oModel:loadCurrentBuffer()

   ::initDuplicateMode()

   if ::oView:Dialog()
      ::endDuplicateModePreInsert()
      ::oModel:insertBuffer()
      ::endDuplicateModePosInsert()
   else 
      ::oModel:setRowSetRecno( nRecno )
      ::cancelDuplicateMode()
   end if

   if !empty( ::oView:getoBrowse() )
      ::oView:getoBrowse():refreshCurrent()
      ::oView:getoBrowse():setFocus()
   end if

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD Edit()  

   if ::notUserEdit()
      msgStop( "Acceso no permitido." )
      RETURN ( Self )
   end if 

   ::setEditMode()

   ::oModel:setIdForRecno( ::getIdfromRowset() )

   ::oModel:loadCurrentBuffer() 

   ::initEditMode()

   if ::oView:Dialog()
      
      ::endEditModePreUpdate()

      ::oModel:updateCurrentBuffer()

      ::endEditModePosUpdate()
   else
   ::cancelEditMode()
   end if 

   if !empty( ::oView:getoBrowse() )
      ::oView:getoBrowse():refreshCurrent()
      ::oView:getoBrowse():setFocus()
   end if 

RETURN ( .t. )

//----------------------------------------------------------------------------//

METHOD Zoom()

   if ::notUserZoom()
      msgStop( "Acceso no permitido." )
      RETURN ( Self )
   end if 

   ::setZoomMode()

   ::oModel:loadCurrentBuffer()

   ::initZoomMode()

   ::oView:Dialog()

   if !empty( ::oView:getoBrowse() )
      ::oView:getoBrowse():setFocus()
   end if 

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD Delete()


   local nSelected      
   local cNumbersOfDeletes

   if ::notUserDelete()
      msgStop( "Acceso no permitido." )
      RETURN ( Self )
   end if 

   if empty( ::oView:getoBrowse() )
      msgStop( "Faltan parametros." )
      RETURN ( Self )
   end if 

      ::initDeleteMode()

   nSelected            := len( ::oView:getoBrowse():aSelected )

   if nSelected > 1
      cNumbersOfDeletes := alltrim( str( nSelected, 3 ) ) + " registros?"
   else
      cNumbersOfDeletes := "el registro en curso?"
   end if

   if oUser():lNotConfirmDelete() .or. msgNoYes( "¿Desea eliminar " + cNumbersOfDeletes, "Confirme eliminación" )
      ::endDeleteModePreDelete()
      ::oModel:deleteSelection( ::oView:getoBrowse():aSelected )
      ::endDeleteModePosDelete()
   end if 

   ::oView:getoBrowse():refreshCurrent()
   ::oView:getoBrowse():setFocus()

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

   if !::oModel:existId( uValue )
   	msgStop( "El identificador introducido no existe", ::getTitle() )
   	oGet:setFocus()
      RETURN .f.
   end if 

   if !empty( oGet:oHelpText )
      oGet:oHelpText:cText( ::oModel:getNameFromId( uValue ) )
   end if

RETURN ( .t. )

//--------------------------------------------------------------------------//

METHOD isValidCodigo( oGet )

   local uValue

   if empty( oGet )
      RETURN ( .t. )
   end if 

   uValue            := oGet:varGet()

   if empty( uValue )
      RETURN ( .t. )
   end if 

   if !::oModel:existCodigo( uValue )
      msgStop( "El código introducido no existe", ::getTitle() )
      oGet:setFocus()
      RETURN ( .f. )
   end if 

   if !empty( oGet:oHelpText )
      oGet:oHelpText:cText( ::oModel:getNameFromCodigo( uValue ) )
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

METHOD generateColumnsForBrowse( oCombobox )

   local hColumnstoBrowse := ::oModel:hColumns

   if !empty( ::oModel:hExtraColumns )
      hColumnstoBrowse := hb_HCopy( hColumnstoBrowse, ::oModel:hExtraColumns)
   end if

   hEval( hColumnstoBrowse, { | k, h | if ( h[ "visible" ] , ::createColumnsForBrowse( oCombobox, k, h), ) } )

RETURN ( self )

//---------------------------------------------------------------------------//


METHOD createColumnsForBrowse( oCombobox, k, h )

   if ( hhaskey( h, "special" ) )

      
   
   else

      with object ( ::oView:getoBrowse():AddCol() )
         :cHeader             := h[ "header" ]
         :cSortOrder          := k
         :bEditValue          := {|| ::getRowSet():fieldGet( k ) }
         :nWidth              := h[ "width" ]
         :bLClickHeader       := {| nMRow, nMCol, nFlags, oCol | ::clickOnHeader( oCol, oCombobox ) }
      end with
   
   endif

RETURN ( self )

//---------------------------------------------------------------------------//
