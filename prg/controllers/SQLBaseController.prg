#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS SQLBaseController

   CLASSDATA oInstance 

   DATA oSenderController

   DATA oExportableController                            

   DATA oEvents                                       

   DATA oModel

   DATA oRowSet

   DATA oDialogView

   DATA oValidator

   DATA oRepository

   DATA oBrowseView

   DATA lTransactional                                INIT .f.

   DATA lContinuousAppend                             INIT .f.

   DATA nLevel                                        INIT nOr( ACC_APPD, ACC_EDIT, ACC_ZOOM, ACC_DELE, ACC_IMPR )

   DATA nMode                                         AS NUMERIC

   DATA cTitle                                        INIT ""

   DATA cName                                         INIT ""

   DATA hImage                                        INIT {=>}

   DATA aSelected

   DATA aDocuments                                    INIT {}

   DATA cDirectory                     

   METHOD New()
   METHOD Instance()                                  INLINE ( if( empty( ::oInstance ), ::oInstance := ::New(), ), ::oInstance ) 
   METHOD End()

   METHOD setDirectory( cDirectory )                  INLINE ( ::cDirectory := cDirectory )
   METHOD getDirectory()                              INLINE ( ::cDirectory )

   METHOD setName( cName )                            INLINE ( ::cName := cName )
   METHOD getName()                                   INLINE ( ::cName )

   METHOD getSenderController()                       INLINE ( ::oSenderController ) 

   // Modelo -----------------------------------------------------------------

   METHOD getModel()                                  INLINE ( ::oModel )
   METHOD getModelColumnKey()                         INLINE ( if( !empty( ::oModel ), ::oModel:cColumnKey, ) )
   METHOD getModelTableName()                         INLINE ( if( !empty( ::oModel ), ::oModel:cTableName, ) )
   METHOD getModelColumns()                           INLINE ( if( !empty( ::oModel ) .and. !empty( ::oModel:hColumns ), ( ::oModel:hColumns ), ) )
   METHOD getModelExtraColumns()                      INLINE ( if( !empty( ::oModel ) .and. !empty( ::oModel:hExtraColumns ), ( ::oModel:hExtraColumns ), ) )
   
   METHOD getModelBuffer( cColumn )                   INLINE ( if( !empty( ::oModel ), ::oModel:getBuffer( cColumn ), ) )
   METHOD setModelBuffer( cColumn, uValue )           INLINE ( if( !empty( ::oModel ), ::oModel:setBuffer( cColumn, uValue ), ) )
   METHOD setModelBufferPadr( cColumn, uValue )       INLINE ( if( !empty( ::oModel ), ::oModel:setBufferPadr( cColumn, uValue ), ) )

   METHOD getModelBufferColumnKey()                   INLINE ( ::getModelBuffer( ( ::oModel:cColumnKey ) ) )
   METHOD getModelSelectValue( cSentence )            INLINE ( if( !empty( ::oModel ), ::oModel:SelectValue( cSentence ), ) )

   METHOD findInModel()

   METHOD changeModelOrderAndOrientation()            
   METHOD getModelHeaderFromColumnOrder()             INLINE ( ::oModel:getHeaderFromColumnOrder() )

   METHOD getId()                                     INLINE ( if(   !empty( ::oModel ) .and. !empty( ::oModel:hBuffer ),;
                                                                     hget( ::oModel:hBuffer, "id" ),;
                                                                     nil ) )
                  
   METHOD getUuid()                                   INLINE ( if(   !empty( ::oModel ) .and. !empty( ::oModel:hBuffer ),;
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
   METHOD refreshRowSetAndFind( nId )                 INLINE ( iif(  !empty( ::oRowSet ), ::oRowSet:refreshAndFind( nId ), ) )

   METHOD getIdFromRecno( aSelected )                 INLINE ( iif(  !empty( ::oRowSet ), ::oRowSet:IdFromRecno( aSelected ), {} ) )
   METHOD getUuidFromRecno( aSelected )               INLINE ( iif(  !empty( ::oRowSet ), ::oRowSet:UuidFromRecno( aSelected ), {} ) )

   METHOD getIdFromRowSet()                           INLINE ( iif(  !empty( ::getRowSet() ),;
                                                                     ::getRowSet():fieldGet( ::oModel:cColumnKey ), nil ) )

   METHOD findInRowSet( uValue, cColumn )             
   METHOD findByIdInRowSet( uValue )                  INLINE ( iif(  !empty( ::getRowSet() ), ::getRowSet():find( uValue, "id", .t. ), ) )

   // Dialogo------------------------------------------------------------------

   METHOD getDialogView()                             INLINE ( ::oDialogView )
   METHOD DialogViewActivate()                     

   // Repositorio--------------------------------------------------------------

   METHOD getRepository()                             INLINE ( ::oRepository )

   // Validator----------------------------------------------------------------

   METHOD Validate( cColumn, uValue )                 INLINE ( iif( !empty( ::oValidator ), ::oValidator:Validate( cColumn, uValue ), ) )
   METHOD Assert( cColumn, uValue )                   INLINE ( iif( !empty( ::oValidator ), ::oValidator:Assert( cColumn, uValue ), ) )

   // Browse------------------------------------------------------------------

   METHOD getBrowseView()                             INLINE ( ::oBrowseView )
   METHOD getBrowse()                                 INLINE ( ::oBrowseView:getBrowse() )

   METHOD startBrowse( oCombobox )
   METHOD restoreBrowseState()

   // Access -----------------------------------------------------------------

   METHOD isUserAccess()                              INLINE ( nAnd( ::nLevel, ACC_ACCE ) == 0 )
   METHOD notUserAccess()                             INLINE ( !::isUserAccess() )
   METHOD isUserAppend()                              INLINE ( nAnd( ::nLevel, ACC_APPD ) != 0 )
   METHOD notUserAppend()                             INLINE ( !::isUserAppend() )
   METHOD isUserDuplicate()                           INLINE ( nAnd( ::nLevel, ACC_APPD ) != 0 )
   METHOD notUserDuplicate()                          INLINE ( !::isUserDuplicate() )
   METHOD isUserEdit()                                INLINE ( nAnd( ::nLevel, ACC_EDIT ) != 0 )
   METHOD notUserEdit()                               INLINE ( !::isUserEdit() )
   METHOD isUserDelete()                              INLINE ( nAnd( ::nLevel, ACC_DELE ) != 0 )
   METHOD notUserDelete()                             INLINE ( !::isUserDelete() )
   METHOD isUserZoom()                                INLINE ( nAnd( ::nLevel, ACC_ZOOM ) != 0 )
   METHOD notUserZoom()                               INLINE ( !::isUserZoom() )

   // Image--------------------------------------------------------------------

   METHOD getImage( cResolution )                     INLINE ( if( hhaskey( ::hImage, cResolution ), hget( ::hImage, cResolution ), "" ) )

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

   METHOD Duplicate()
      METHOD setDuplicateMode()                       INLINE ( ::setMode( __duplicate_mode__ ) )
      METHOD isDuplicateMode()                        INLINE ( ::nMode == __duplicate_mode__ )

   METHOD Edit()
      METHOD setEditMode()                            INLINE ( ::setMode( __edit_mode__ ) )
      METHOD isEditMode()                             INLINE ( ::nMode == __edit_mode__ )
      METHOD isNotEditMode()                          INLINE ( ::nMode != __edit_mode__ )

   METHOD Zoom()
      METHOD setZoomMode()                            INLINE ( ::setMode( __zoom_mode__ ) )
      METHOD isZoomMode()                             INLINE ( ::nMode == __zoom_mode__ )
      METHOD isNotZoomMode()                          INLINE ( ::nMode != __zoom_mode__ )

   METHOD Delete()
      METHOD priorRecnoToDelete( aSelectedRecno )

   // Transactional system-----------------------------------------------------

   METHOD beginTransactionalMode()                    INLINE ( if( ::lTransactional, getSQLDatabase():BeginTransaction(), ) )
   METHOD commitTransactionalMode()                   INLINE ( if( ::lTransactional, getSQLDatabase():Commit(), ) )
   METHOD rollbackTransactionalMode()                 INLINE ( if( ::lTransactional, getSQLDatabase():Rollback(), ) )

   // Events-------------------------------------------------------------------

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

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oSenderController )

   ::oSenderController                                := oSenderController

   ::oEvents                                          := Events():New()

   ::oRowSet                                          := SQLRowSet():New( self )

   ::oExportableController                            := ExportableController():New( self )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD End()

   if !empty( ::oEvents )
      ::oEvents:End()
   end if 

   if !empty( ::oRowSet )
      ::oRowSet:End()
   end if 

   ::oEvents   := nil

   ::oRowSet   := nil
   
RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD startBrowse( oCombobox )

   local oColumn

   if empty( ::oDialogView:getoBrowse() )
      RETURN ( Self )
   end if 

   if (!empty( oCombobox ) )
      oCombobox:SetItems( ::oDialogView:getoBrowse():getColumnHeaders() )
   endif

   ::restoreBrowseState()

   oColumn        := ::oDialogView:getoBrowse():getColumnOrder( ::oModel:cColumnOrder )
   if empty( oColumn )
      RETURN ( Self )
   end if 
   
   if (!empty( oCombobox ) )
      oCombobox:set( oColumn:cHeader )
   endif

   ::oDialogView:getoBrowse():selectColumnOrder( oColumn, ::oModel:cOrientation )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD restoreBrowseState()

   if empty( ::oDialogView:getoBrowse() )
      RETURN ( Self )
   end if 

   if empty( ::oDialogView:getBrowseState() )
      RETURN ( Self )
   end if 

   ::oDialogView:getoBrowse():restoreState( ::oDialogView:getBrowseState() )

RETURN ( Self )

//----------------------------------------------------------------------------//

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
            ::refreshRowSetAndFind( nId )
         end if 

         ::fireEvent( 'appended' ) 

         if ::lContinuousAppend
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
         ::refreshRowSetAndFind( nId )
      end if 
      
      ::fireEvent( 'duplicated' ) 

   else 
   
      lDuplicate     := .f.

      ::restoreRowSetRecno()
   
      ::fireEvent( 'cancelDuplicated' ) 

      ::rollbackTransactionalMode()
   
   end if

   ::fireEvent( 'exitDuplicated' ) 

RETURN ( lDuplicate )

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

      ::refreshRowSet()

      ::fireEvent( 'edited' ) 

   else

      lEdit       := .f.

      ::fireEvent( 'cancelEdited' ) 

      ::rollbackTransactionalMode()

   end if 

   ::fireEvent( 'exitEdited' ) 

RETURN ( lEdit )

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

   ::oDialogView:Activate()

   ::fireEvent( 'closedDialog' )    

   ::fireEvent( 'zoomed' ) 

   ::fireEvent( 'exitZoomed' ) 

RETURN ( .t. )

//----------------------------------------------------------------------------//

METHOD DialogViewActivate()

   local uResult           := ::oDialogView:Activate()

   if hb_islogical( uResult )
      RETURN ( uResult )
   end if 

   if hb_isnumeric( uResult ) .and. ( uResult == IDOK )
      ::lContinuousAppend  := .f.
      RETURN ( .t. )
   end if 

   if hb_isnumeric( uResult ) .and. ( uResult == IDOKANDNEW )
      ::lContinuousAppend  := .t.
      RETURN ( .t. )
   end if 

RETURN ( .f. )

//----------------------------------------------------------------------------//

METHOD Delete( aSelectedRecno )

   local lDelete        := .f.
   local cNumbersOfDeletes

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

   if isFalse( ::fireEvent( 'deleting' ) )
      RETURN ( .f. )
   end if

   if len( aSelectedRecno ) > 1
      cNumbersOfDeletes := alltrim( str( len( aSelectedRecno ), 3 ) ) + " registros?"
   else
      cNumbersOfDeletes := "el registro en curso?"
   end if

   ::fireEvent( 'openingConfirmDelete' )

   if oUser():lNotConfirmDelete() .or. msgNoYes( "¿Desea eliminar " + cNumbersOfDeletes, "Confirme eliminación" )
      
      ::fireEvent( 'deletingSelection' ) 

      ::oModel:deleteSelection( ::getIdFromRecno( aSelectedRecno ), ::getUuidFromRecno( aSelectedRecno ) )

      ::fireEvent( 'deletedSelection' ) 

      ::gotoRowSetRecno( ::priorRecnoToDelete( aSelectedRecno ) )

      ::refreshRowSet()

      lDelete           := .t.

   else 

      ::fireEvent( 'cancelDeleted' ) 
   
   end if 

   ::fireEvent( 'exitDeleted' ) 

RETURN ( lDelete )

//----------------------------------------------------------------------------//

METHOD priorRecnoToDelete( aSelectedRecno )

   aSelectedRecno       := asort( aSelectedRecno, , , {|x,y| x > y } )

RETURN ( atail( aSelectedRecno ) - 1 )

//----------------------------------------------------------------------------//

METHOD changeModelOrderAndOrientation( cColumnOrder, cColumnOrientation )

   local nId   := ::oRowSet:fieldGet( ::getModelColumnKey() )

   ::oModel:setFind( "" )

   ::oModel:setColumnOrder( cColumnOrder )

   ::oModel:setColumnOrientation( cColumnOrientation )

   ::oRowSet:build( ::oModel:getSelectSentence() )

   ::oRowSet:find( nId )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD findInModel( uValue )

   ::oModel:setFind( uValue )

   ::oRowSet:build( ::oModel:getSelectSentence() )

RETURN ( ::oRowSet:RecCount() )

//---------------------------------------------------------------------------//

METHOD findInRowSet( uValue, cColumn )

   if empty( ::oRowSet )
      RETURN ( .f. )
   end if 

RETURN ( ::oRowSet:find( uValue, cColumn ) )

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

