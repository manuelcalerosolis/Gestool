#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS SQLBaseController

   DATA oSenderController

   DATA oExportableController                            

   DATA oEvents                                       

   DATA oModel

   DATA oRowSet

   DATA oDialogView

   DATA uDialogResult

   DATA oValidator

   DATA oRepository

   DATA lTransactional                                INIT .f.

   DATA lInsertable                                   INIT .f.

   DATA nLevel                                        INIT __permission_full__ 

   DATA nMode                                         AS NUMERIC

   DATA cTitle                                        INIT ""

   DATA cName                                         INIT ""

   DATA hImage                                        INIT {=>}

   DATA aSelected

   DATA aDocuments                                    INIT {}

   DATA cDirectory 

   METHOD New()
   METHOD End()

   METHOD setDirectory( cDirectory )                  INLINE ( ::cDirectory := cDirectory )
   METHOD getDirectory()                              INLINE ( ::cDirectory )

   METHOD setName( cName )                            INLINE ( ::cName := cName )
   METHOD getName()                                   INLINE ( ::cName )

   METHOD getSenderController()                       INLINE ( ::oSenderController ) 
   METHOD getSenderControllerParentUuid()             INLINE ( iif( !empty( ::oSenderController ), ::oSenderController:getUuid(), space( 40 ) ) ) 

   // Modelo -----------------------------------------------------------------

   METHOD getModel()                                  INLINE ( ::oModel )
   METHOD getModelColumnKey()                         INLINE ( iif( !empty( ::oModel ), ::oModel:cColumnKey, ) )
   METHOD getModelTableName()                         INLINE ( iif( !empty( ::oModel ), ::oModel:getTableName(), ) )
   METHOD getModelColumns()                           INLINE ( iif( !empty( ::oModel ) .and. !empty( ::oModel:hColumns ), ( ::oModel:hColumns ), ) )
   METHOD getModelExtraColumns()                      INLINE ( iif( !empty( ::oModel ) .and. !empty( ::oModel:hExtraColumns ), ( ::oModel:hExtraColumns ), ) )
   
   METHOD getModelBuffer( cColumn )                   INLINE ( iif( !empty( ::oModel ), ::oModel:getBuffer( cColumn ), ) )
   METHOD setModelBuffer( cColumn, uValue )           INLINE ( iif( !empty( ::oModel ), ::oModel:setBuffer( cColumn, uValue ), ) )
   METHOD setModelBufferPadr( cColumn, uValue )       INLINE ( iif( !empty( ::oModel ), ::oModel:setBufferPadr( cColumn, uValue ), ) )

   METHOD getModelBufferColumnKey()                   INLINE ( ::getModelBuffer( ( ::oModel:cColumnKey ) ) )
   METHOD getModelgetValue( cSentence )               INLINE ( iif( !empty( ::oModel ), ::oModel:getValue( cSentence ), ) )

   METHOD findInModel()

   METHOD changeModelOrderAndOrientation()            
   METHOD getModelHeaderFromColumnOrder()             INLINE ( ::oModel:getHeaderFromColumnOrder() )

   METHOD getId()                                     INLINE ( iif(  !empty( ::oModel ) .and. !empty( ::oModel:hBuffer ),;
                                                                     hget( ::oModel:hBuffer, "id" ),;
                                                                     nil ) )
                  
   METHOD getUuid()                                   INLINE ( iif(  !empty( ::oModel ) .and. !empty( ::oModel:hBuffer ),;
                                                                     hget( ::oModel:hBuffer, "uuid" ),;
                                                                     nil ) )

   // Rowset-------------------------------------------------------------------

   METHOD getRowSet()                                 INLINE ( ::oRowSet )
   METHOD saveRowSetRecno()                           INLINE ( iif(  !empty( ::oRowSet ), ::oRowSet:saveRecno(), ) )
   METHOD restoreRowSetRecno()                        INLINE ( iif(  !empty( ::oRowSet ), ::oRowSet:restoreRecno(), ) )
   METHOD gotoRowSetRecno( nRecno )                   INLINE ( iif(  !empty( ::oRowSet ) .and. hb_isnumeric( nRecno ),;
                                                                     ::oRowSet:gotoRecno( nRecno ), ) )
   METHOD findRowSet( nId )                           INLINE ( iif(  !empty( ::oRowSet ), ::oRowSet:find( nId ), ) )
   METHOD refreshRowSet()                             INLINE ( iif(  !empty( ::oRowSet ), ::oRowSet:refresh(), ) )
   METHOD refreshRowSetAndGoTop()                     INLINE ( iif(  !empty( ::oRowSet ), ::oRowSet:refreshAndGoTop(), ) )
   METHOD refreshRowSetAndFindId( nId )               INLINE ( iif(  !empty( ::oRowSet ), ::oRowSet:refreshAndFindId( nId ), ) )
   METHOD goDownRowSet()                              INLINE ( iif(  !empty( ::oRowSet ), ::oRowSet:goDown(), ) )
   METHOD goUpRowSet()                                INLINE ( iif(  !empty( ::oRowSet ), ::oRowSet:goUp(), ) )

   METHOD getIdFromRecno( aSelected )                 INLINE ( iif(  !empty( ::oRowSet ), ::oRowSet:IdFromRecno( aSelected ), {} ) )
   METHOD getUuidFromRecno( aSelected )               INLINE ( iif(  !empty( ::oRowSet ), ::oRowSet:UuidFromRecno( aSelected ), {} ) )

   METHOD getIdFromRowSet()                           INLINE ( iif(  !empty( ::getRowSet() ),;
                                                                     ::getRowSet():fieldGet( ::oModel:cColumnKey ), nil ) )

   METHOD isRowSetSystemRegister()                          
   METHOD isNotRowSetSystemRegister()                       INLINE ( !( ::isRowSetSystemRegister() ) )

   METHOD findInRowSet( uValue, cColumn )             
   METHOD findByIdInRowSet( uValue )                  INLINE ( iif(  !empty( ::getRowSet() ), ::getRowSet():find( uValue, "id", .t. ), ) )

   // Dialogo------------------------------------------------------------------

   METHOD getDialogView()                             INLINE ( ::oDialogView )
   METHOD DialogViewActivate()  
   METHOD DialogViewEnd()                   

   METHOD isContinuousAppend()                        INLINE ( hb_isnumeric( ::uDialogResult ) .and. ::uDialogResult == IDOKANDNEW )

   // Repositorio--------------------------------------------------------------

   METHOD getRepository()                             INLINE ( ::oRepository )

   // Validator----------------------------------------------------------------

   METHOD getValidator()                              INLINE ( ::oValidator )

   METHOD Validate( cColumn, uValue )                 INLINE ( ::getValidator():Validate( cColumn, uValue ) )
   METHOD Assert( cColumn, uValue )                   INLINE ( ::getValidator():Assert( cColumn, uValue ) )

   // Access -----------------------------------------------------------------

   METHOD isUserAccess()                              INLINE ( nAnd( ::nLevel, __permission_access__ ) != 0 )
   METHOD notUserAccess()                             INLINE ( !::isUserAccess() )
   METHOD isUserAppend()                              INLINE ( nAnd( ::nLevel, __permission_append__ ) != 0 )
   METHOD notUserAppend()                             INLINE ( !::isUserAppend() )
   METHOD isUserDuplicate()                           INLINE ( nAnd( ::nLevel, __permission_append__ ) != 0 )
   METHOD notUserDuplicate()                          INLINE ( !::isUserDuplicate() )
   METHOD isUserEdit()                                INLINE ( nAnd( ::nLevel, __permission_edit__ ) != 0 )
   METHOD notUserEdit()                               INLINE ( !::isUserEdit() )
   METHOD isUserDelete()                              INLINE ( nAnd( ::nLevel, __permission_delete__ ) != 0 )
   METHOD notUserDelete()                             INLINE ( !::isUserDelete() )
   METHOD isUserZoom()                                INLINE ( nAnd( ::nLevel, __permission_zoom__ ) != 0 )
   METHOD notUserZoom()                               INLINE ( !::isUserZoom() )

   // Image--------------------------------------------------------------------

   METHOD getImage( cResolution )                     INLINE ( iif( hhaskey( ::hImage, cResolution ), hget( ::hImage, cResolution ), "" ) )

   // Title -------------------------------------------------------------------

   METHOD setTitle( cTitle )                          INLINE ( ::cTitle := cTitle )
   METHOD getTitle()                                  INLINE ( ::cTitle )

   // Modes--------------------------------------------------------------------

   METHOD setMode( nMode )                            INLINE ( ::nMode := nMode )
   METHOD getMode()                                   INLINE ( ::nMode )

   // Actions------------------------------------------------------------------

   METHOD Append()
      METHOD setAppendMode()                          INLINE ( ::setMode( __append_mode__ ) )
      METHOD isAppendMode()                           INLINE ( ::nMode == __append_mode__ )
      METHOD isNotAppendMode()                        INLINE ( ::nMode != __append_mode__ )

   METHOD Insert()

   METHOD Duplicate()
      METHOD setDuplicateMode()                       INLINE ( ::setMode( __duplicate_mode__ ) )
      METHOD isDuplicateMode()                        INLINE ( ::nMode == __duplicate_mode__ )

   METHOD isAppendOrDuplicateMode()                   INLINE ( ::isAppendMode() .or. ::isDuplicateMode() )

   METHOD Edit()
   METHOD EditReturn()
      METHOD setEditMode()                            INLINE ( ::setMode( __edit_mode__ ) )
      METHOD isEditMode()                             INLINE ( ::nMode == __edit_mode__ )
      METHOD isNotEditMode()                          INLINE ( ::nMode != __edit_mode__ )

   METHOD Zoom()
      METHOD setZoomMode()                            INLINE ( ::setMode( __zoom_mode__ ) )
      METHOD isZoomMode()                             INLINE ( ::nMode == __zoom_mode__ )
      METHOD isNotZoomMode()                          INLINE ( ::nMode != __zoom_mode__ )

   METHOD Delete()
      METHOD priorRecnoToDelete( aSelectedRecno )

   METHOD dialgOkAndGoTo()                            INLINE ( ::uDialogResult == IDOKANDGOTO )
   METHOD dialgOkAndDown()                            INLINE ( ::uDialogResult == IDOKANDDOWN )
   METHOD dialgOkAndUp()                              INLINE ( ::uDialogResult == IDOKANDUP )

   METHOD postEdit( nId ) 

   // Transactional system-----------------------------------------------------

   METHOD beginTransactionalMode()                    INLINE ( if( ::lTransactional, getSQLDatabase():BeginTransaction(), ) )
   METHOD commitTransactionalMode()                   INLINE ( if( ::lTransactional, getSQLDatabase():Commit(), ) )
   METHOD rollbackTransactionalMode()                 INLINE ( if( ::lTransactional, getSQLDatabase():Rollback(), ) )

   // Events-------------------------------------------------------------------

   METHOD setEvents( aEvents, bEvent )                
   METHOD setEvent( cEvent, bEvent )                  INLINE ( if( !empty( ::oEvents ), ::oEvents:set( cEvent, bEvent ), ) )
   METHOD fireEvent( cEvent )                         INLINE ( if( !empty( ::oEvents ), ::oEvents:fire( cEvent ), ) )

   METHOD onKeyChar()                                 VIRTUAL

   // Deprecated---------------------------------------------------------------

   METHOD setFastReport( oFastReport, cTitle, cSentence, cColumns )

   // Directorio para documentos y etiquetas-----------------------------------

   METHOD setDirectory( cDirectory )                  INLINE ( ::cDirectory := cDirectory )
   METHOD getDirectory()                              INLINE ( ::cDirectory )

   METHOD loadDocuments()

   // Fachadas para q responda ExportableController----------------------------

   METHOD load()                                      INLINE ( ::oExportableController:load() )
   METHOD save()                                      INLINE ( ::oExportableController:save() )

   METHOD setSelectSend( lSelect )                    INLINE ( ::oExportableController:setSelectSend( lSelect ) )
   METHOD getSelectSend()                             INLINE ( ::oExportableController:getSelectSend() )

   METHOD setSelectRecive( lSelect )                  INLINE ( ::oExportableController:setSelectRecive( lSelect ) )
   METHOD getSelectRecive()                           INLINE ( ::oExportableController:getSelectRecive() )

   METHOD createData()                                INLINE ( ::buildNotSentJson(), ::zipNotSentJson() )
   METHOD restoreData( oInternet )                    INLINE ( ::setSentFromFetch() )
   
   METHOD sendData( oInternet )                       INLINE ( ::oExportableController:isSendData( oInternet ) )

   // Validador para las columnas editables del browseview---------------------

   METHOD validColumnBrowse( uValue, nKey, oModel, cFieldName )

   // Filters------------------------------------------------------------------

   METHOD buildFilter( cExpresion )
   METHOD buildInFilter( cField, cValue )             INLINE ( ::buildFilter( iif( !empty( cField ) .and. !empty( cValue ), cField + " IN (" + toSqlString( cValue ) + ")", "" ) ) )
   METHOD buildNotInFilter( cField, cValue )          INLINE ( ::buildFilter( iif( !empty( cField ) .and. !empty( cValue ), cField + " NOT IN (" + toSqlString( cValue ) + ")", "" ) ) )
   METHOD buildBiggerFilter( cField, cValue )         INLINE ( ::buildFilter( iif( !empty( cField ) .and. !empty( cValue ), cField + " > " + toSqlString( cValue ), "" ) ) )
   METHOD buildSmallerFilter( cField, cValue )        INLINE ( ::buildFilter( iif( !empty( cField ) .and. !empty( cValue ), cField + " < " + toSqlString( cValue ), "" ) ) )
   METHOD buildStartLikeFilter( cField, cValue )      INLINE ( ::buildFilter( iif( !empty( cField ) .and. !empty( cValue ), cField + " LIKE " + toSqlString( alltrim( cstr( cValue ) ) + "%" ), "" ) ) )
   METHOD buildEndLikeFilter( cField, cValue )        INLINE ( ::buildFilter( iif( !empty( cField ) .and. !empty( cValue ), cField + " LIKE " + toSqlString( "%" + alltrim( cstr( cValue ) ) ), "" ) ) )
   METHOD buildLikeFilter( cField, cValue )           INLINE ( ::buildFilter( iif( !empty( cField ) .and. !empty( cValue ), cField + " LIKE " + toSqlString( "%" + alltrim( cstr( cValue ) ) + "%" ), "" ) ) )

   METHOD clearFilter()

   METHOD reBuildRowSet()   

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oSenderController )

   ::oSenderController                                := oSenderController

   ::oEvents                                          := Events():New()

   ::oRowSet                                          := SQLRowSet():New( self )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD End()

   if !empty( ::oEvents )
      ::oEvents:End()
   end if 

   if !empty( ::oRowSet )
      ::oRowSet:End()
   end if

   ::oEvents                  := nil
   
   ::oRowSet                  := nil

   hb_gcall( .t. )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD Append()

   local nId
   local uResult
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

      ::beginTransactionalMode()

      ::saveRowSetRecno()

      ::oModel:loadBlankBuffer()

      ::fireEvent( 'openingDialog' )     

      if ::DialogViewActivate()

         ::fireEvent( 'closedDialog' )    

         nId         := ::oModel:insertBuffer()    
         
         ::commitTransactionalMode()

         if !empty( nId )
            ::refreshRowSetAndFindId( nId )
         else 
            ::refreshRowSet()
         end if 

         ::refreshBrowseView()

         ::fireEvent( 'appended' ) 

         if ::isContinuousAppend()
            loop
         else 
            exit
         end if 

      else
         
         lAppend     := .f.

         ::fireEvent( 'cancelAppended' ) 

         ::restoreRowSetRecno()

         ::rollbackTransactionalMode()

         exit

      end if

   end while

   ::fireEvent( 'exitAppended' ) 

RETURN ( lAppend )

//----------------------------------------------------------------------------//

METHOD Insert()

   local nId
   local uResult
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

      ::beginTransactionalMode()

      ::saveRowSetRecno()

      nId            := ::oModel:insertBlankBuffer()

      ::fireEvent( 'openingDialog' )     

      if ::DialogViewActivate()

         ::fireEvent( 'closedDialog' )    

         ::oModel:updateBuffer()    
         
         ::commitTransactionalMode()

         if !empty( nId )
            ::refreshRowSetAndFindId( nId )
         else 
            ::refreshRowSet()
         end if 

         ::refreshBrowseView()

         ::fireEvent( 'appended' ) 

         if ::isContinuousAppend()
            loop
         else 
            exit
         end if 

      else
         
         lAppend     := .f.

         ::fireEvent( 'cancelAppended' ) 

         ::restoreRowSetRecno()

         ::rollbackTransactionalMode()

         exit

      end if

   end while

   ::fireEvent( 'exitAppended' ) 

RETURN ( lAppend )

//----------------------------------------------------------------------------//

METHOD Duplicate( nId )

   local lDuplicate  := .t. 

   if empty( nId )
      nId            := ::getIdFromRowSet()
   end if 

   if empty( nId )
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

   ::oModel:loadDuplicateBuffer( nId )

   ::fireEvent( 'openingDialog' )

   if ::DialogViewActivate()

      ::fireEvent( 'closedDialog' )    

      nId            := ::oModel:insertBuffer()

      ::commitTransactionalMode()
      
      if !empty( nId )
         ::refreshRowSetAndFindId( nId )
      end if 
      
      ::fireEvent( 'duplicated' ) 

      ::refreshBrowseView()

   else 
   
      lDuplicate     := .f.

      ::restoreRowSetRecno()
   
      ::fireEvent( 'cancelDuplicated' ) 

      ::rollbackTransactionalMode()
   
   end if

   ::fireEvent( 'exitDuplicated' ) 

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

   if ::notUserEdit()
      msgStop( "Acceso no permitido." )
      RETURN ( .f. )
   end if 

   if isFalse( ::fireEvent( 'editing' ) )
      RETURN ( .f. )
   end if

   ::setEditMode()

   ::beginTransactionalMode()

   ::oModel:loadCurrentBuffer( nId )

   ::fireEvent( 'openingDialog' )

   if ::DialogViewActivate()
      
      ::fireEvent( 'closedDialog' )  

      ::oModel:updateBuffer()

      ::commitTransactionalMode()

      ::refreshRowSetAndFindId( nId )

      ::refreshBrowseView()

      ::fireEvent( 'edited' ) 

   else

      lEdit       := .f.

      ::fireEvent( 'cancelEdited' ) 

      ::rollbackTransactionalMode()

   end if 

   ::fireEvent( 'exitEdited' ) 

   ::postEdit()

RETURN ( lEdit )

//----------------------------------------------------------------------------//

METHOD postEdit() 

   do case
      case ::dialgOkAndGoTo()

         if ::refreshRowSetAndFindId( ::getDialogView():idGoTo )
            ::Edit()
         else 
            msgStop( "El identificador " + alltrim( str( ::getDialogView():idGoTo ) ) + " no puede ser localizado" )
         end if 

      case ::dialgOkAndDown()

         ::goDownRowSet()
      
         ::Edit()

      case ::dialgOkAndUp()

         ::goUpRowSet()
      
         ::Edit()
         
   end case 

RETURN ( self )

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

   ::oModel:loadCurrentBuffer( nId )

   ::fireEvent( 'openingDialog' )

   ::DialogViewActivate()   

   ::fireEvent( 'closedDialog' )    

   ::fireEvent( 'zoomed' ) 

   ::fireEvent( 'exitZoomed' ) 

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

METHOD Delete( aSelectedRecno )

   local lDelete        := .f.
   local cNumbersOfDeletes

   msgalert( "Delete" )

   if ::notUserDelete()
      msgStop( "Acceso no permitido" )
      RETURN ( .f. )
   end if 

   if !hb_isarray( aSelectedRecno )
      msgalert( "!hb_isarray( aSelectedRecno )")
      RETURN ( .f. )
   end if 

   if len( aSelectedRecno ) == 0
      msgalert( "len( aSelectedRecno ) == 0" )
      RETURN ( .f. )
   end if 

   if len( aSelectedRecno ) == 1 .and. atail( aSelectedRecno ) == 0
      msgalert( "len( aSelectedRecno ) == 1 .and. atail( aSelectedRecno ) == 0" )
      RETURN ( .f. )
   end if 

   if isFalse( ::fireEvent( 'deleting' ) )
   msgalert( 'deleting' )
      RETURN ( .f. )
   end if

   if len( aSelectedRecno ) > 1
      cNumbersOfDeletes := alltrim( str( len( aSelectedRecno ), 3 ) ) + " registros?"
   else
      cNumbersOfDeletes := "el registro en curso?"
   end if

   ::fireEvent( 'openingConfirmDelete' )

   if SQLAjustableModel():getRolNoConfirmacionEliminacion( Auth():rolUuid() ) .or. msgNoYes( "¿Desea eliminar " + cNumbersOfDeletes, "Confirme eliminación" )
      
      ::fireEvent( 'deletingSelection' ) 

      ::oModel:deleteSelection( ::getIdFromRecno( aSelectedRecno ), ::getUuidFromRecno( aSelectedRecno ) )

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

METHOD priorRecnoToDelete( aSelectedRecno )

   aSelectedRecno       := asort( aSelectedRecno, , , {|x,y| x > y } )

   if ( atail( aSelectedRecno ) > 1 )
      RETURN ( atail( aSelectedRecno ) - 1 )
   end if

RETURN ( atail( aSelectedRecno ) )

//----------------------------------------------------------------------------//

METHOD changeModelOrderAndOrientation( cOrderBy, cOrientation )

   local nId           

   if empty( ::oRowSet )
      RETURN ( self )
   end if 

   nId                  := ::oRowSet:fieldGet( ::getModelColumnKey() )

   ::oModel:setFind( "" )

   ::oRowSet:buildPad( ::oModel:getSelectSentence( cOrderBy, cOrientation ) )

   ::oRowSet:findId( nId )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD findInModel( uValue )

   ::oModel:setFind( uValue )

   ::oRowSet:buildPad( ::oModel:getSelectSentence() )

RETURN ( ::oRowSet:RecCount() )

//---------------------------------------------------------------------------//

METHOD findInRowSet( uValue, cColumn )

   if empty( ::oRowSet )
      RETURN ( .f. )
   end if 

RETURN ( ::oRowSet:findString( uValue, cColumn ) )

//----------------------------------------------------------------------------//

METHOD isRowSetSystemRegister()

   if empty( ::oRowSet )
      RETURN ( .t. )
   end if 

RETURN ( ::oRowSet:fieldGet( 'sistema' ) == 1 )

//----------------------------------------------------------------------------//

METHOD setEvents( aEvents, bEvent )

RETURN ( aeval( aEvents, {|cEvent| ::setEvent( cEvent, bEvent ) } ) )

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
                                 {|nField| msginfo( nField ), oRowSet:fieldGet( nField ) } )
                                 //  )      
    
RETURN ( Self )    
    
//---------------------------------------------------------------------------//

METHOD loadDocuments()

   local aFiles   := directory( ::getDirectory() + "*.fr3" )
   
   ::aDocuments   := {}

   if empty( aFiles )
      RETURN ( ::aDocuments )
   end if 

   aeval( aFiles, {|aFile| aadd( ::aDocuments, aFile[ 1 ] ) } )

RETURN ( ::aDocuments )

//---------------------------------------------------------------------------//

METHOD validColumnBrowse( oCol, uValue, nKey, oModel, cFieldName )
   
   local cCodigo        := ""

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
      msgStop( "valor no encontrado." )
      RETURN .t.
   end if

   ::oModel:updateFieldWhereId( ::getRowSet():fieldGet( 'id' ), cFieldName, cCodigo )

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

   nId               := ::oRowSet:fieldGet( ::getModelColumnKey() )
   
   ::oRowSet:build( ::getModel():getSelectSentence() )

   ::oRowSet:findString( nId )
      
   ::getBrowseView():Refresh()

RETURN ( nil )

//---------------------------------------------------------------------------//
