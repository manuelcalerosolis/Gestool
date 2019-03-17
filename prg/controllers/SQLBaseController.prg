#include "FiveWin.Ch"
#include "Factu.ch"

//---------------------------------------------------------------------------//

CLASS SQLBaseController

   DATA oController

   DATA nId

   DATA oEvents

   DATA oModel

   DATA oRange

   DATA oRowSet

   DATA oDialogView

   DATA uDialogResult

   DATA oValidator

   DATA oRepository

   DATA lTransactional                 INIT .f.

   DATA lInsertable                    INIT .f.

   DATA lMultiDelete                   INIT .t.

   DATA lCanceled                      INIT .f.

   DATA nLevel                         INIT __permission_full__

   DATA nMode                          AS NUMERIC

   DATA cTitle                         INIT ""

   DATA cName                          INIT ""

   DATA hImage                         INIT {=>}

   DATA aSelected

   DATA bPostAction

   DATA oHistoryController

   METHOD New() CONSTRUCTOR
   METHOD End()

   METHOD setName( cName )             INLINE ( ::cName := cName )
   METHOD getName()                    INLINE ( ::cName )

   METHOD getController()              INLINE ( ::oController )
   METHOD getSuperController()         INLINE ( iif( !empty( ::getController() ), ::getController():getController(), nil ) )
   METHOD getControllerParentUuid()    INLINE ( iif( !empty( ::oController ), ::oController:getUuid(), space( 40 ) ) )

   // Modelo -----------------------------------------------------------------

   METHOD getModel()                   VIRTUAL
   METHOD setModel( oModel )           INLINE ( ::oModel := oModel )

   METHOD getModelColumnKey()          INLINE ( iif( !empty( ::getModel() ), ::getModel():cColumnKey, ) )
   METHOD getModelTableName()          INLINE ( iif( !empty( ::getModel() ), ::getModel():getTableName(), ) )
   METHOD getModelColumns()            INLINE ( iif( !empty( ::getModel() ) .and. !empty( ::getModel():hColumns ), ( ::getModel():hColumns ), ) )
   METHOD getModelExtraColumns()       INLINE ( iif( !empty( ::getModel() ) .and. !empty( ::getModel():hExtraColumns ), ( ::getModel():hExtraColumns ), ) )

   METHOD isEmptyModelBuffer()         INLINE ( empty( ::getModel() ) .or. empty( ::getModel():hBuffer ) )

   METHOD getModelBuffer( cColumn )    INLINE ( iif( !empty( ::getModel() ), ::getModel():getBuffer( cColumn ), ) )
   METHOD setModelBuffer( cColumn, uValue ) ;
                                       INLINE ( iif( !empty( ::getModel() ), ::getModel():setBuffer( cColumn, uValue ), ) )
   METHOD setModelBufferPadr( cColumn, uValue ) ;
                                       INLINE ( iif( !empty( ::getModel() ), ::getModel():setBufferPadr( cColumn, uValue ), ) )

   METHOD getModelBufferColumnKey()    INLINE ( ::getModelBuffer( ( ::getModel():cColumnKey ) ) )
   METHOD getModelgetValue( cSentence ) ;
                                       INLINE ( iif( !empty( ::getModel() ), ::getModel():getValue( cSentence ), ) )

   METHOD findInModel()

   METHOD changeModelOrderAndOrientation()
   METHOD getModelHeaderFromColumnOrder() ;
                                       INLINE ( ::getModel():getHeaderFromColumnOrder() )

   METHOD getId()                      INLINE ( iif( !empty( ::getModel() ), ::getModel():getId(), nil ) )
   METHOD getUuid()                    INLINE ( iif( !empty( ::getModel() ), ::getModel():getUuid(), nil ) )

   // Rowset-------------------------------------------------------------------

   METHOD saveRowSetRecno()            INLINE ( ::getRowSet():saveRecno() )
   METHOD restoreRowSetRecno()         INLINE ( ::getRowSet():restoreRecno() )
   METHOD gotoRowSetRecno( nRecno )    INLINE ( iif( hb_isnumeric( nRecno ), ::getRowSet():gotoRecno( nRecno ), ) )
   METHOD findRowSet( nId )            INLINE ( ::getRowSet():find( nId ) )
   METHOD refreshRowSet()              INLINE ( ::getRowSet():refresh() )
   METHOD refreshRowSetAndGoTop()      INLINE ( ::getRowSet():refreshAndGoTop() )
   METHOD refreshRowSetAndFindId()     INLINE ( iif( empty( ::nId ), ::refreshRowSet(), ::getRowSet():refreshAndFindId( ::nId ) ) )
   METHOD goDownRowSet()               INLINE ( ::getRowSet():goDown() )
   METHOD goUpRowSet()                 INLINE ( ::getRowSet():goUp() )

   METHOD getIdFromRecno( aSelected )  INLINE ( ::getRowSet():IdFromRecno( aSelected ) )
   METHOD getUuidFromRecno( aSelected ) ;
                                       INLINE ( ::getRowSet():UuidFromRecno( aSelected ) )

   METHOD getIdFromRowSet()            INLINE ( if( empty( ::getRowset() ), nil, ::getRowSet():fieldGet( ::getModel():cColumnKey ) ) )
   METHOD getFieldFromRowSet( cField ) INLINE ( if( empty( ::getRowset() ), nil, ::getRowSet():fieldGet( cField ) ) )
   METHOD getUuidFromRowSet()          INLINE ( ::getFieldFromRowSet( "uuid" ) )

   METHOD isRowSetSystemRegister()
   METHOD isNotRowSetSystemRegister()  INLINE ( !( ::isRowSetSystemRegister() ) )

   METHOD setMultiDelete( lMultiDelete ) ;
                                       INLINE ( ::lMultiDelete := lMultiDelete )
   METHOD isMultiDelete()              INLINE ( ::lMultiDelete )

   METHOD findInRowSet( uValue, cColumn )
   METHOD findByIdInRowSet( uValue )   INLINE ( ::getRowSet():find( uValue, "id", .t. ) )

   METHOD refreshBrowseView()          VIRTUAL

   // Dialogo------------------------------------------------------------------

   METHOD getDialogView()              INLINE ( ::oDialogView )
      METHOD dialogViewActivate()
      METHOD dialogViewEnd()
      METHOD dialogViewDestroy()

   METHOD isContinuousAppend()         INLINE ( hb_isnumeric( ::uDialogResult ) .and. ::uDialogResult == IDOKANDNEW )

   // Repositorio--------------------------------------------------------------

   METHOD getRepository()              INLINE ( ::oRepository )

   // Validator----------------------------------------------------------------

   METHOD getValidator()               INLINE ( ::oValidator )

   METHOD Validate( cColumn, uValue )  INLINE ( ::getValidator():Validate( cColumn, uValue ) )
   METHOD notValidate( cColumn, uValue ) ;
                                       INLINE ( !( ::getValidator():Validate( cColumn, uValue ) ) )

   METHOD Assert( cColumn, uValue )    INLINE ( ::getValidator():Assert( cColumn, uValue ) )

   // Access -----------------------------------------------------------------

   METHOD isUserAccess()               INLINE ( nAnd( ::nLevel, __permission_access__ ) != 0 )
   METHOD notUserAccess()              INLINE ( !::isUserAccess() )
   METHOD isUserAppend()               INLINE ( nAnd( ::nLevel, __permission_append__ ) != 0 )
   METHOD notUserAppend()              INLINE ( !::isUserAppend() )
   METHOD isUserDuplicate()            INLINE ( nAnd( ::nLevel, __permission_append__ ) != 0 )
   METHOD notUserDuplicate()           INLINE ( !::isUserDuplicate() )
   METHOD isUserEdit()                 INLINE ( nAnd( ::nLevel, __permission_edit__ ) != 0 )
   METHOD notUserEdit()                INLINE ( !::isUserEdit() )
   METHOD isUserDelete()               INLINE ( nAnd( ::nLevel, __permission_delete__ ) != 0 )
   METHOD notUserDelete()              INLINE ( !::isUserDelete() )
   METHOD isUserZoom()                 INLINE ( nAnd( ::nLevel, __permission_zoom__ ) != 0 )
   METHOD notUserZoom()                INLINE ( !::isUserZoom() )

   // Image--------------------------------------------------------------------

   METHOD getImage( cResolution )      INLINE ( iif( hhaskey( ::hImage, cResolution ), hget( ::hImage, cResolution ), "" ) )

   // Title -------------------------------------------------------------------

   METHOD setTitle( cTitle )           INLINE ( ::cTitle := cTitle )
   METHOD getTitle()                   INLINE ( ::cTitle )

   // Modes--------------------------------------------------------------------

   METHOD setMode( nMode )             INLINE ( ::nMode := nMode )
   METHOD getMode()                    INLINE ( ::nMode )

   // Actions------------------------------------------------------------------

   METHOD Append()
      METHOD setAppendMode()           INLINE ( ::setMode( __append_mode__ ) )
      METHOD isAppendMode()            INLINE ( ::nMode == __append_mode__ )
      METHOD isNotAppendMode()         INLINE ( ::nMode != __append_mode__ )

   METHOD Insert()

   METHOD insertOrUpdateBuffer()

   METHOD Duplicate()
      METHOD setDuplicateMode()        INLINE ( ::setMode( __duplicate_mode__ ) )
      METHOD isDuplicateMode()         INLINE ( ::nMode == __duplicate_mode__ )

   METHOD isAppendOrDuplicateMode()    INLINE ( ::isAppendMode() .or. ::isDuplicateMode() )
   METHOD isNotAppendOrDuplicateMode() INLINE ( !( ::isAppendOrDuplicateMode() ) )

   METHOD Edit()
   METHOD EditReturn()
      METHOD setEditMode()             INLINE ( ::setMode( __edit_mode__ ) )
      METHOD isEditMode()              INLINE ( ::nMode == __edit_mode__ )
      METHOD isNotEditMode()           INLINE ( ::nMode != __edit_mode__ )
      METHOD prepareDocument           VIRTUAL

   METHOD Zoom( nId )
   METHOD ZoomUuid( uuid )             INLINE ( ::Zoom( ::getModel():getIdWhereUuid( uuid ) ) )

      METHOD setZoomMode()             INLINE ( ::setMode( __zoom_mode__ ) )
      METHOD isZoomMode()              INLINE ( ::nMode == __zoom_mode__ )
      METHOD isNotZoomMode()           INLINE ( ::nMode != __zoom_mode__ )

   METHOD Delete( aSelectedRecno )
   METHOD Cancel( aSelectedRecno )
      METHOD allowDeleteOrCancel( aSelectedRecno )
      METHOD priorRecnoToDelete( aSelectedRecno )

   METHOD dialgOkAndGoTo()             INLINE ( ::uDialogResult == IDOKANDGOTO )
   METHOD dialgOkAndDown()             INLINE ( ::uDialogResult == IDOKANDDOWN )
   METHOD dialgOkAndUp()               INLINE ( ::uDialogResult == IDOKANDUP )

   METHOD setPostAction( bPostAction ) INLINE ( ::bPostAction := bPostAction )
   METHOD runPostAction()

   METHOD isDeleted( nId )             INLINE ( ::getModel():isDeletedAtColumn() .and. ::getModel:isDeleted( nId ) )
   METHOD isNotDeleted()               INLINE ( !::isDeleted() )

   // Historicos---------------------------------------------------------------
   
   METHOD updateHistory()              INLINE ( ::createHistory( hget( OPERATION_TEXT, IS_UPDATED ) ) )

   METHOD insertHistory()              INLINE ( ::createHistory( hget( OPERATION_TEXT, IS_INSERTED ) ) )

   METHOD canceledHistory()           INLINE ( ::getHistoryController():getModel():insertCanceled() )

   METHOD createHistory( cOperation )  INLINE ( ::getHistoryController():insertHistory( ::getModel():getBufferChanged(), cOperation ) )


   // Transactional system-----------------------------------------------------

   METHOD beginTransactionalMode()     INLINE ( iif( ::lTransactional, getSQLDatabase():BeginTransaction(), ) )
   METHOD commitTransactionalMode()    INLINE ( iif( ::lTransactional, getSQLDatabase():Commit(), ) )
   METHOD rollbackTransactionalMode()  INLINE ( iif( ::lTransactional, getSQLDatabase():Rollback(), ) )

   // Events-------------------------------------------------------------------

   METHOD setEvents( aEvents, bEvent )
   METHOD setEvent( cEvent, bEvent )   INLINE ( ::getEvents():set( cEvent, bEvent ) )
   METHOD fireEvent( cEvent, uValue )  INLINE ( ::getEvents():fire( cEvent, uValue ) )

   METHOD onKeyChar()                  VIRTUAL

   METHOD prepareDialogView()          VIRTUAL

   // Incidencias--------------------------------------------------------------

   METHOD insertIncidence()            VIRTUAL

   // Directorio para documentos y etiquetas-----------------------------------

   METHOD setDirectory( cDirectory )   INLINE ( ::cDirectory := cDirectory )
   METHOD getDirectory()               INLINE ( ::cDirectory )

   // Validador para las columnas editables del browseview---------------------

   METHOD validColumnBrowse( uValue, nKey, oModel, cFieldName )

   // Filters------------------------------------------------------------------

   METHOD buildFilter( cExpresion )
   METHOD buildInFilter( cField, cValue ) ;
                                       INLINE ( ::buildFilter( iif( !empty( cField ) .and. !empty( cValue ), cField + " IN (" + toSqlString( cValue ) + ")", "" ) ) )
   METHOD buildNotInFilter( cField, cValue ) ;
                                       INLINE ( ::buildFilter( iif( !empty( cField ) .and. !empty( cValue ), cField + " NOT IN (" + toSqlString( cValue ) + ")", "" ) ) )
   METHOD buildBiggerFilter( cField, cValue ) ;
                                       INLINE ( ::buildFilter( iif( !empty( cField ) .and. !empty( cValue ), cField + " > " + toSqlString( cValue ), "" ) ) )
   METHOD buildSmallerFilter( cField, cValue ) ;
                                       INLINE ( ::buildFilter( iif( !empty( cField ) .and. !empty( cValue ), cField + " < " + toSqlString( cValue ), "" ) ) )
   METHOD buildStartLikeFilter( cField, cValue ) ;
                                       INLINE ( ::buildFilter( iif( !empty( cField ) .and. !empty( cValue ), cField + " LIKE " + toSqlString( alltrim( cstr( cValue ) ) + "%" ), "" ) ) )
   METHOD buildEndLikeFilter( cField, cValue ) ;
                                       INLINE ( ::buildFilter( iif( !empty( cField ) .and. !empty( cValue ), cField + " LIKE " + toSqlString( "%" + alltrim( cstr( cValue ) ) ), "" ) ) )
   METHOD buildLikeFilter( cField, cValue ) ;
                                       INLINE ( ::buildFilter( iif( !empty( cField ) .and. !empty( cValue ), cField + " LIKE " + toSqlString( "%" + alltrim( cstr( cValue ) ) + "%" ), "" ) ) )

   METHOD clearFilter()

   METHOD reBuildRowSet()

   METHOD getRowSet()                  INLINE ( iif( empty( ::oRowSet ), ::oRowSet := SQLRowSet():New( self ), ), ::oRowSet )

   METHOD getEvents()                  INLINE ( iif( empty( ::oEvents ), ::oEvents := Events():New(), ), ::oEvents )

   METHOD getHistoryController()       INLINE ( iif( empty( ::oHistoryController ), ::oHistoryController := HistoryController():New( self ), ), ::oHistoryController )

   //Autocommit------------------------------------------------------------------//

   METHOD setAutoCommitToTrue()        INLINE ( getSQLDatabase():setAutoCommitToTrue() )

   METHOD setAutoCommitToFalse()       INLINE ( getSQLDatabase():setAutoCommitToFalse() )

   METHOD commitData()                 INLINE ( getSQLDatabase():commitData() )

   METHOD rollbackData()               INLINE ( getSQLDatabase():rollbackData() )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController )

   ::oController                       := oController

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD End()

   if !empty( ::oEvents )
      ::oEvents:End()
   end if

   if !empty( ::oRowSet )
      ::oRowSet:End()
   end if

RETURN ( hb_gcall( .t. ) )

//---------------------------------------------------------------------------//

METHOD insertOrUpdateBuffer()

   if !empty( ::nId )
      ::nId          := ::getModel():insertBuffer()
   else
      ::getModel():updateBuffer()
   end if

RETURN ( ::nId )

//---------------------------------------------------------------------------//

METHOD Append()

   local lAppend     := .t.

   if ::notUserAppend()
      msgStop( "Acceso no permitido." )
      RETURN ( .f. )
   end if

   if isFalse( ::fireEvent( 'appending' ) )
      RETURN ( .f. )
   end if

   ::setAppendMode()

   while .t.

      ::nId          := 0

      ::beginTransactionalMode()

      ::saveRowSetRecno()

      ::getModel():loadBlankBuffer()

      ::fireEvent( 'openingDialog' )

      ::prepareDialogView()

      if ::dialogViewActivate()

         ::fireEvent( 'closedDialog' )

         ::getModel():insertBuffer()

         // ::insertIncidence()

         ::commitTransactionalMode()

         ::refreshRowSetAndFindId()

         if !empty( ::getBrowseView() )
            ::refreshBrowseView()
         end if

         ::fireEvent( 'appended' )

         if ::isContinuousAppend()
            loop
         else
            exit
         end if

      else

         ::rollbackTransactionalMode()

         lAppend     := .f.

         ::fireEvent( 'cancelAppended' )

         ::restoreRowSetRecno()

         exit

      end if

   end while

   ::fireEvent( 'exitAppended' )

   ::fireEvent( 'endDialog' )

   ::runPostAction()

RETURN ( lAppend )

//----------------------------------------------------------------------------//

METHOD Insert()

   local lInsert     := .t.

   if ::notUserAppend()
      msgStop( "Acceso no permitido." )
      RETURN ( .f. )
   end if

   if isFalse( ::fireEvent( 'inserting' ) )
      RETURN ( .f. )
   end if

   ::setAppendMode()

   while .t.

      ::nId          := 0

      ::saveRowSetRecno()

      ::beginTransactionalMode()

      ::nId          := ::getModel():insertBlankBuffer()

      ::fireEvent( 'openingDialog' )

      if ::dialogViewActivate()

         ::fireEvent( 'closedDialog' )

         ::getModel():updateInsertedBuffer( nil, ::nId )

         ::commitTransactionalMode()

         ::fireEvent( 'inserted' )

         ::insertHistory()

         ::refreshRowSetAndFindId()

         ::refreshBrowseView()

         if ::isContinuousAppend()
            loop
         else
            exit
         end if

      else

         lInsert     := .f.

         ::fireEvent( 'cancelInserted' )

         ::rollbackTransactionalMode()

         // ::getModel():hardDeleteById( ::nId )

         ::restoreRowSetRecno()

         exit

      end if

   end while

   ::fireEvent( 'exitInserted' )

   ::fireEvent( 'endDialog' )

   ::runPostAction()

RETURN ( lInsert )

//----------------------------------------------------------------------------//

METHOD Duplicate( nId )

   local lDuplicate  := .t.

   ::nId             := nId

   if empty( ::nId )
      ::nId          := ::getIdFromRowSet()
   end if

   if empty( ::nId )
      RETURN ( .f. )
   end if

   if !empty( ::getRowSet():fieldGet( "deleted_at" ) )
      RETURN ( .f. )
   end if

   if ::notUserDuplicate()
      msgStop( "Acceso no permitido." )
      RETURN ( .f. )
   end if

   if isFalse( ::fireEvent( 'duplicating' ) )
      RETURN ( .f. )
   end if

   ::setDuplicateMode()

   ::beginTransactionalMode()

   ::saveRowSetRecno()

   ::nId             := ::getModel():insertDuplicateBuffer( ::nId )

   ::fireEvent( 'openingDialog' )

   if ::DialogViewActivate()

      ::fireEvent( 'closedDialog' )

      ::getModel():updateInsertedBuffer( nil, ::nId )

      ::commitTransactionalMode()

      ::refreshRowSetAndFindId()

      ::fireEvent( 'duplicated' )

      ::insertHistory()

      ::refreshBrowseView()

   else

      lDuplicate     := .f.

      ::restoreRowSetRecno()

      ::fireEvent( 'cancelDuplicated' )

      ::rollbackTransactionalMode()

   end if

   ::fireEvent( 'exitDuplicated' )

   ::fireEvent( 'endDialog' )

   ::runPostAction()

RETURN ( lDuplicate )

//----------------------------------------------------------------------------//

METHOD EditReturn( nId )

   if ::isBrowseColumnEdit()
      RETURN ( .f. )
   end if

RETURN ( ::Edit( nId ) )

//----------------------------------------------------------------------------//

METHOD Edit( nId )

   local lEdit    := .t.

   if empty( nId )
      nId         := ::getIdFromRowSet()
   end if

   if empty( nId )
      RETURN ( .f. )
   end if

   if ::isDeleted( nId )
      msgStop( "No se puede editar un registro eliminado" )
      RETURN ( .f. )
   end if

   if ::notUserEdit()
      msgStop( "Acceso no permitido." )
      RETURN ( .f. )
   end if

   if isFalse( ::fireEvent( 'editing', nId ) )
      RETURN ( .f. )
   end if

   ::setEditMode()

   ::beginTransactionalMode()

   ::getModel():loadCurrentBuffer( nId )

   ::fireEvent( 'openingDialog' )

   if ::DialogViewActivate()

      ::fireEvent( 'closedDialog' )

      ::getModel():updateBuffer()

      ::commitTransactionalMode()

      ::refreshRowSetAndFindId()

      ::refreshBrowseView()

      ::fireEvent( 'edited' )

      ::updateHistory()

   else

      lEdit       := .f.

      ::fireEvent( 'cancelEdited' )

      ::rollbackTransactionalMode()

   end if

   ::fireEvent( 'exitEdited' )

   ::fireEvent( 'endDialog' )

   ::runPostAction()

RETURN ( lEdit )

//----------------------------------------------------------------------------//

METHOD runPostAction()

   if hb_isblock( ::bPostAction )
      eval( ::bPostAction, self )
   end case

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD Zoom( nId )

   if empty( nId )
      nId         := ::getIdFromRowSet()
   end if

   if empty( nId )
      RETURN ( .f. )
   end if

   if ::notUserZoom()
      msgStop( "Acceso no permitido." )
      RETURN ( Self )
   end if

   if isFalse( ::fireEvent( 'zooming' ) )
      RETURN ( .f. )
   end if

   ::setZoomMode()

   ::getModel():loadCurrentBuffer( nId )

   ::fireEvent( 'openingDialog' )

   ::DialogViewActivate()

   ::fireEvent( 'closedDialog' )

   ::fireEvent( 'zoomed' )

   ::fireEvent( 'exitZoomed' )

   ::fireEvent( 'endDialog' )

RETURN ( .t. )

//----------------------------------------------------------------------------//

METHOD DialogViewActivate( oDialogView )

   DEFAULT oDialogView     := ::getDialogView()

   if empty( oDialogView )
      RETURN ( .f. )
   end if

   oDialogView:Activating()

   ::uDialogResult         := oDialogView:Activate()

   oDialogView:Activated()

   if hb_islogical( ::uDialogResult )
      RETURN ( ::uDialogResult )
   end if

   if hb_isnumeric( ::uDialogResult ) .and. ( ::uDialogResult != IDCANCEL )
      RETURN ( .t. )
   end if

RETURN ( .f. )

//----------------------------------------------------------------------------//

METHOD DialogViewEnd( oDialogView )

   DEFAULT oDialogView     := ::getDialogView()

   if !empty( oDialogView )
      oDialogView:EndActivate()
   end if

RETURN ( .f. )

//----------------------------------------------------------------------------//

METHOD DialogViewDestroy()

   ::oDialogView           := nil

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD Delete( aSelectedRecno )

   local lDelete        := .f.
   local cNumbers

   if !( ::allowDeleteOrCancel( aSelectedRecno ) )
      RETURN ( .f. )
   end if

   if isFalse( ::fireEvent( 'deleting' ) )
      RETURN ( .f. )
   end if

   if len( aSelectedRecno ) > 1
      cNumbers := alltrim( str( len( aSelectedRecno ), 3 ) ) + " registros?"
   else
      cNumbers := "el registro en curso?"
   end if

   ::fireEvent( 'openingConfirmDelete' )

   if SQLAjustableGestoolModel():getRolNoConfirmacionEliminacion( Auth():rolUuid() ) .or. msgNoYes( "�Desea eliminar " + cNumbers, "Confirme eliminaci�n" )

      ::fireEvent( 'deletingSelection' )

      ::getModel():deleteSelection( ::getIdFromRecno( aSelectedRecno ), ::getUuidFromRecno( aSelectedRecno ) )

      ::fireEvent( 'deletedSelection' )

      ::gotoRowSetRecno( ::priorRecnoToDelete( aSelectedRecno ) )

      ::refreshRowSet()

      ::refreshBrowseView()

      lDelete           := .t.

   else

      ::fireEvent( 'cancelDeleted' )

   end if

   ::fireEvent( 'exitDeleted' )

RETURN ( lDelete )

//----------------------------------------------------------------------------//

METHOD Cancel( aSelectedRecno )

   local lCancel        := .f.
   local cNumbers

   if !( ::allowDeleteOrCancel( aSelectedRecno ) )
      RETURN ( .f. )
   end if

   if isFalse( ::fireEvent( 'deleting' ) )
      RETURN ( .f. )
   end if

   if len( aSelectedRecno ) > 1
      cNumbers := alltrim( str( len( aSelectedRecno ), 3 ) ) + " registros?"
   else
      cNumbers := "el registro en curso?"
   end if

   ::fireEvent( 'openingConfirmCancel' )

   if SQLAjustableGestoolModel():getRolNoConfirmacionEliminacion( Auth():rolUuid() ) .or. msgNoYes( "�Desea cancelar " + cNumbers, "Confirme eliminaci�n" )

      ::fireEvent( 'cancelingSelection' )

      ::canceledHistory()

      ::getModel():cancelSelection( ::getIdFromRecno( aSelectedRecno ), ::getUuidFromRecno( aSelectedRecno ) )

      ::fireEvent( 'canceledSelection' )

      ::gotoRowSetRecno( ::priorRecnoToDelete( aSelectedRecno ) )

      ::refreshRowSet()

      ::refreshBrowseView()

      lCancel           := .t.

   else

      ::fireEvent( 'cancelCanceled' )

   end if

   ::fireEvent( 'exitCanceled' )

RETURN ( lCancel )

//----------------------------------------------------------------------------//

METHOD allowDeleteOrCancel( aSelectedRecno )

   if ::notUserDelete()
      msgStop( "Acceso no permitido" )
      RETURN ( .f. )
   end if

   if !hb_isarray( aSelectedRecno )
      RETURN ( .f. )
   end if

   if len( aSelectedRecno ) == 0
      RETURN ( .f. )
   end if

   if len( aSelectedRecno ) == 1 .and. atail( aSelectedRecno ) == 0
      RETURN ( .f. )
   end if

   if ( !::isMultiDelete() .and. len( aSelectedRecno ) > 1 )
      msgStop( "Borrado multiple no permitido" )
      RETURN ( .f. )
   end if

RETURN ( .t. )

//----------------------------------------------------------------------------//

METHOD priorRecnoToDelete( aSelectedRecno )

   aSelectedRecno       := asort( aSelectedRecno, , , {|x,y| x > y } )

   if ( atail( aSelectedRecno ) > 1 )
      RETURN ( atail( aSelectedRecno ) - 1 )
   end if

RETURN ( atail( aSelectedRecno ) )

//----------------------------------------------------------------------------//

METHOD changeModelOrderAndOrientation( cOrderBy, cOrientation )

   local nId

   if empty( ::getRowSet() )
      RETURN ( nil )
   end if

   nId                  := ::getRowSet():fieldGet( ::getModelColumnKey() )

   ::getModel():setFind( "" )

   ::getRowSet():buildPad( ::getModel():getSelectSentence( cOrderBy, cOrientation ) )

   ::getRowSet():findId( nId )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD findInModel( uValue, aColumns )

   ::getModel():setFind( uValue, aColumns )

   ::getRowSet():buildPad( ::getModel():getSelectSentence() )

RETURN ( ::getRowSet():RecCount() )

//---------------------------------------------------------------------------//

METHOD findInRowSet( uValue, cColumn )

   if empty( ::getRowSet() )
      RETURN ( .f. )
   end if

RETURN ( ::getRowSet():findString( uValue, cColumn ) )

//----------------------------------------------------------------------------//

METHOD isRowSetSystemRegister()

   if empty( ::getRowSet() )
      RETURN ( .f. )
   end if

RETURN ( isTrue( ::getRowSet():fieldGet( 'sistema' ) ) )

//----------------------------------------------------------------------------//

METHOD setEvents( aEvents, bEvent )

RETURN ( aeval( aEvents, {|cEvent| ::setEvent( cEvent, bEvent ) } ) )

//----------------------------------------------------------------------------//

METHOD validColumnBrowse( oCol, uValue, nKey, oModel, cFieldName )

   local cCodigo

   if !hb_isnumeric( nKey ) .or. ( nKey == VK_ESCAPE ) .or. hb_isnil( uValue )
      RETURN ( .t. )
   end if

   if hb_ishash( uValue )
      cCodigo          := hGet( uValue, "codigo" )
   end if

   if hb_ischar( uValue )
      cCodigo          := oModel:getCodigoWhereCodigo( alltrim( uValue ) )
   end if

   if empty( cCodigo )
      msgStop( "Valor no encontrado." )
      RETURN .t.
   end if

   ::getModel():updateFieldWhereId( ::getRowSet():fieldGet( 'id' ), cFieldName, cCodigo )

   ::RefreshRowSet()

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD buildFilter( cFilter )

   ::getModel():insertFilterWhere( cFilter )

   ::reBuildRowSet()

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD clearFilter()

   ::getModel():clearFilterWhere()

   ::reBuildRowSet()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD reBuildRowSet()

   local nId

   nId               := ::getRowSet():fieldGet( ::getModelColumnKey() )

   ::getRowSet():build( ::getModel():getSelectSentence() )

   ::getRowSet():findString( nId )

   ::getBrowseView():Refresh()

RETURN ( nil )

//---------------------------------------------------------------------------//

