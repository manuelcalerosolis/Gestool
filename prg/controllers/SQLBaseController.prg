#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS SQLBaseController

   CLASSDATA oInstance 

   DATA oSenderController

   DATA ControllerContainer

   DATA oEvents                                       

   DATA oModel

   DATA oDialogView

   DATA oValidator

   DATA oRepository

   DATA lTransactional                                INIT .f.

   DATA lContinuousAppend                             INIT .f.

   DATA nLevel                                        INIT nOr( ACC_APPD, ACC_EDIT, ACC_ZOOM, ACC_DELE, ACC_IMPR )

   DATA nMode                                         AS NUMERIC

   DATA cTitle                                        INIT ""

   DATA cImage                                        INIT ""

   DATA aSelected

   METHOD New()
   METHOD Instance()                                  INLINE ( if( empty( ::oInstance ), ::oInstance := ::New(), ), ::oInstance ) 
   METHOD End()

   // Facades -----------------------------------------------------------------

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

   METHOD endModel()                                  INLINE ( if( !empty( ::oModel ), ::oModel:end(), ) )

   METHOD getSenderController()                       INLINE ( ::oSenderController )    

   METHOD getDialogView()                             INLINE ( ::oDialogView )

   METHOD getRepository()                             INLINE ( ::oRepository )

   METHOD getContainer( cController )                 INLINE ( ::ControllerContainer:get( cController ) )

   METHOD getName()                                   INLINE ( strtran( lower( ::cTitle ), " ", "_" ) )

   METHOD getIdFromRowSet()                           INLINE ( if( !empty( ::getRowSet() ), ( ::getRowSet():fieldGet( ::oModel:cColumnKey ) ), ) )

   METHOD changeModelOrderAndOrientation()
   METHOD getModelHeaderFromColumnOrder()             INLINE ( ::oModel:getHeaderFromColumnOrder() )

   METHOD find( uValue, cColumn )                     INLINE ( ::oModel:find( uValue, cColumn ) )
   METHOD findInRowSet( uValue, cColumn )             
   METHOD findByIdInRowSet( uValue )                  INLINE ( if( !empty( ::getRowSet() ), ::getRowSet():find( uValue, "id", .t. ), ) )

   METHOD startBrowse( oCombobox )
   METHOD restoreBrowseState()

   METHOD getRowSet()

   METHOD Validate( cColumn )                         INLINE ( if( !empty( ::oValidator ), ::oValidator:Validate( cColumn ), ) )
   METHOD Assert( cColumn, uValue )                   INLINE ( if( !empty( ::oValidator ), ::oValidator:Assert( cColumn, uValue ), ) )

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

   // Title -------------------------------------------------------------------

   METHOD setTitle( cTitle )                          INLINE ( ::cTitle := cTitle )
   METHOD getTitle()                                  INLINE ( ::cTitle )

   // Modes--------------------------------------------------------------------

   METHOD setMode( nMode )                            INLINE ( ::nMode := nMode )
   METHOD getMode()                                   INLINE ( ::nMode )

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

   // Transactional system-----------------------------------------------------

   METHOD beginTransactionalMode()                    INLINE ( if( ::lTransactional, getSQLDatabase():BeginTransaction(), ) )
   METHOD commitTransactionalMode()                   INLINE ( if( ::lTransactional, getSQLDatabase():Commit(), ) )
   METHOD rollbackTransactionalMode()                 INLINE ( if( ::lTransactional, getSQLDatabase():Rollback(), ) )

   // Events-------------------------------------------------------------------

   METHOD setEvent( cEvent, bEvent )                  INLINE ( if( !empty( ::oEvents ), ::oEvents:set( cEvent, bEvent ), ) )
   METHOD fireEvent( cEvent )                         INLINE ( if( !empty( ::oEvents ), ::oEvents:fire( cEvent ), ) )

   METHOD setFastReport( oFastReport, cTitle, cSentence, cColumns )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oSenderController )

   ::oSenderController                                := oSenderController

   ::oEvents                                          := Events():New()

   ::ControllerContainer                              := ControllerContainer():New()

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD End()

   ::endModel() 

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

   local nRecno
   local lAppend     := .t.   

   if ::notUserAppend()
      msgStop( "Acceso no permitido." )
      RETURN ( .f. )
   end if 

   if !( ::fireEvent( 'appending' ) )
      RETURN ( .f. )
   end if

   ::setAppendMode()

   while .t.

      ::beginTransactionalMode()

      nRecno         := ::oModel:getRowSetRecno()

      ::oModel:loadBlankBuffer()

      ::fireEvent( 'openingDialog' )     

      if ::oDialogView:Activate()

         ::fireEvent( 'closedDialog' )    

         ::oModel:insertBuffer()

         ::fireEvent( 'appended' ) 

         ::commitTransactionalMode()

         if ::lContinuousAppend
            loop
         else 
            exit
         end if 

      else
         
         lAppend     := .f.

         ::fireEvent( 'cancelAppended' ) 

         ::oModel:setRowSetRecno( nRecno )

         ::rollbackTransactionalMode()

         exit

      end if

   end while

   ::fireEvent( 'exitAppended' ) 

RETURN ( lAppend )

//----------------------------------------------------------------------------//

METHOD Duplicate()

   local nRecno  
   local lDuplicate  := .t. 

   if ::notUserDuplicate()
      msgStop( "Acceso no permitido." )
      RETURN ( .f. )
   end if 

   if !( ::fireEvent( 'duplicating' ) )
      RETURN ( .f. )
   end if

   ::setDuplicateMode()

   ::beginTransactionalMode()

   nRecno            := ::oModel:getRowSetRecno()

   ::oModel:loadDuplicateBuffer()

   ::fireEvent( 'openingDialog' )

   if ::oDialogView:Activate()

      ::fireEvent( 'closedDialog' )    

      ::oModel:insertBuffer()
   
      ::fireEvent( 'duplicated' ) 
   
      ::commitTransactionalMode()

   else 
   
      lDuplicate     := .f.

      ::oModel:setRowSetRecno( nRecno )
   
      ::fireEvent( 'cancelDuplicated' ) 

      ::rollbackTransactionalMode()
   
   end if

   ::fireEvent( 'exitDuplicated' ) 

RETURN ( lDuplicate )

//----------------------------------------------------------------------------//

METHOD Edit() 

   local lEdit    := .t. 

   if ::notUserEdit()
      msgStop( "Acceso no permitido." )
      RETURN ( .f. )
   end if 

   if !( ::fireEvent( 'editing' ) )
      RETURN ( .f. )
   end if

   ::setEditMode()

   ::beginTransactionalMode()

   ::oModel:setIdToFind( ::getIdFromRowSet() )

   ::oModel:loadCurrentBuffer() 

   ::fireEvent( 'openingDialog' )

   if ::oDialogView:Activate()
      
      ::fireEvent( 'closedDialog' )    

      ::oModel:updateBuffer()

      ::fireEvent( 'edited' ) 

      ::commitTransactionalMode()

   else

      lEdit       := .f.

      ::fireEvent( 'cancelEdited' ) 

      ::rollbackTransactionalMode()

   end if 

   ::fireEvent( 'exitEdited' ) 

RETURN ( lEdit )

//----------------------------------------------------------------------------//

METHOD Zoom()

   if ::notUserZoom()
      msgStop( "Acceso no permitido." )
      RETURN ( Self )
   end if 

   if !( ::fireEvent( 'zooming' ) )
      RETURN ( .f. )
   end if

   ::setZoomMode()

   ::oModel:loadCurrentBuffer()

   ::fireEvent( 'openingDialog' )

   ::oDialogView:Activate()

   ::fireEvent( 'closedDialog' )    

   ::fireEvent( 'exitZoomed' ) 

RETURN ( .t. )

//----------------------------------------------------------------------------//

METHOD Delete( aSelected )

   local lDelete
   local nSelected      
   local cNumbersOfDeletes

   if ::notUserDelete()
      msgStop( "Acceso no permitido" )
      RETURN ( .f. )
   end if 

   if !hb_isarray( aSelected )
      msgStop( "No se especificaron los registros a eliminar" )
      RETURN ( .f. )
   end if 

   if !( ::fireEvent( 'deleting' ) )
      RETURN ( .f. )
   end if

   ::aSelected          := aSelected

   lDelete              := .f.

   nSelected            := len( aSelected )

   if nSelected > 1
      cNumbersOfDeletes := alltrim( str( nSelected, 3 ) ) + " registros?"
   else
      cNumbersOfDeletes := "el registro en curso?"
   end if

   ::fireEvent( 'openingConfirmDelete' )

   if oUser():lNotConfirmDelete() .or. msgNoYes( "¿Desea eliminar " + cNumbersOfDeletes, "Confirme eliminación" )
      
      ::fireEvent( 'deletingSelection' ) 

      ::oModel:deleteSelection( aSelected )

      ::fireEvent( 'deletedSelection' ) 

   else 

      ::fireEvent( 'cancelDeleted' ) 
   
   end if 

   ::fireEvent( 'exitDeleted' ) 

RETURN ( lDelete )

//----------------------------------------------------------------------------//

METHOD changeModelOrderAndOrientation( cColumnOrder, cColumnOrientation )

   ::oModel:saveIdToFind()

   ::oModel:setColumnOrder( cColumnOrder )

   ::oModel:setColumnOrientation( cColumnOrientation )

   ::oModel:buildRowSetAndFind()

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD findInRowSet( uValue, cColumn )

   local nRecno   

   if empty( ::getRowSet() )
      RETURN ( .f. )
   end if 

   nRecno         := ::getModel():getRowSetRecno()

   if empty( cColumn )
      cColumn     := ::getModel():getColumnOrder()
   end if 

   if ( ::getRowSet():find( uValue, cColumn, .t. ) == 0 )
      ::getModel():setRowSetRecno( nRecno )
   end if 

RETURN ( .t. )

//----------------------------------------------------------------------------//

METHOD getRowSet()

   if empty( ::oModel:oRowSet )
      ::oModel:buildRowSet()
   end if

Return ( ::oModel:oRowSet )

//---------------------------------------------------------------------------//

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