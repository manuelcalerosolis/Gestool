#include "FiveWin.Ch"
#include "Factu.ch" 

CLASS Editable
 
   DATA oDlg

   DATA nView

   DATA oStock

   DATA nMode
   DATA nModeDetail

   DATA lChangePrecio                           INIT .t.

   DATA lAlowEdit                               INIT .t.                                      

   DATA cDataTable
   DATA cDataTableLine

   DATA cSentenceTable

   DATA cDataArray

   DATA oViewNavigator
   DATA oViewSearchNavigator
   DATA oViewEdit
   DATA oCliente
   DATA oViewEditDetail

   DATA cDetailArea
   DATA nPosDetail                              INIT 0
   
   DATA hDictionaryMaster
   DATA oDocumentLineTemporal

   DATA aDetails                                INIT {}
 
   DATA cFormatToPrint

   DATA nOrdenAnterior

   METHOD setView( nView )                      INLINE ( ::nView := nView )

   METHOD Append()
      METHOD onPreSaveAppend()                  INLINE ( .t. )
      METHOD saveAppend()
      METHOD onPostSaveAppend()                 INLINE ( .t. )

   METHOD Edit()
      METHOD onPreSaveEdit()                    VIRTUAL
      METHOD saveEdit()
      METHOD onPostSaveEdit()                   INLINE ( .t. )

   METHOD Zoom()
      
   METHOD Delete()

   METHOD lAppendMode()                         INLINE ( ::nMode == APPD_MODE )
   METHOD setAppendMode()                       INLINE ( ::nMode := APPD_MODE )

   METHOD lEditMode()                           INLINE ( ::nMode == EDIT_MODE )
   METHOD setEditMode()                         INLINE ( ::nMode := EDIT_MODE )

   METHOD lZoomMode()                           INLINE ( ::nMode == ZOOM_MODE )
   METHOD lNotZoomMode()                        INLINE ( ::nMode != ZOOM_MODE )
   METHOD setZoomMode()                         INLINE ( ::nMode := ZOOM_MODE )

   METHOD TextMode()                            INLINE ( lblTitle( ::nMode ) )

   METHOD setDataTable( cDataTable )            INLINE ( ::cDataTable := cDataTable )
   METHOD getDataTable()                        INLINE ( ::cDataTable )

   METHOD setSentenceTable( cSentenceTable )    INLINE ( ::cSentenceTable := cSentenceTable )
   METHOD getSentenceTable()                    INLINE ( if( !Empty( ::cSentenceTable ), ::cSentenceTable, "SELECT * FROM " + cPatEmp() + ::getDataTable() ) )

   METHOD setDataArray( cDataArray )            INLINE ( ::cDataArray := cDataArray )
   METHOD getDataArray()                        INLINE ( ::cDataArray )

   METHOD setDataTableLine( cDataTableLine )    INLINE ( ::cDataTableLine := cDataTableLine )
   METHOD getDataTableLine()                    INLINE ( ::cDataTableLine )
   METHOD getWorkAreaLine()                     INLINE ( D():Get( ::cDataTableLine, ::nView ) )

   METHOD onPostGetDocumento()                  INLINE ( .t. )
   METHOD onPreEnd()                            VIRTUAL

   METHOD getAppendDocumento()                  INLINE ( ::hDictionaryMaster := D():getHashRecordDefaultValues( ::getDataTable(), ::nView ) )
      METHOD onPreAppendDocumento()             INLINE ( ::nOrdenAnterior     := ( ::getDataTable() )->( OrdSetFocus() ), .t. )

   METHOD getEditDocumento()
      METHOD onPreEditDocumento()               INLINE ( ::nOrdenAnterior     := ( ::getDataTable() )->( OrdSetFocus() ), .t. )

   METHOD deleteDocumento()                     INLINE ( D():deleteRecord( ::getDataTable(), ::nView ) )
   
      METHOD Resource()                         INLINE ( msgStop( "Resource method must be redefined" ) )
      METHOD initDialog()                       VIRTUAL

   METHOD saveAppendDocumento()                 INLINE ( D():appendHashRecord( ::hDictionaryMaster, ::getDataTable(), ::nView ) )
   METHOD saveEditDocumento()                   INLINE ( D():editHashRecord( ::hDictionaryMaster, ::getDataTable(), ::nView ) )
      METHOD saveDocumento()        

   //METHOD getWorkArea()                         INLINE ( D():Get( ::cDataTable, ::nView ) )
   METHOD getWorkArea()                         INLINE ( D():getSQL( ::cDataTable, ::getSentenceTable(), ::nView ) )

   METHOD addDetail( oDetail )                  INLINE ( aAdd( ::aDetails, oDetail ) )

   METHOD setDetailArea( cDetailArea )          INLINE ( ::cDetailArea  := cDetailArea )
   METHOD getDetailArea()                       INLINE ( ::cDetailArea )

   METHOD appendDetail()
      METHOD onPreSaveAppendDetail()            INLINE ( .t. )
      METHOD onPreSaveEditDetail()              INLINE ( .t. )

      METHOD appendButtonMode()                 INLINE ( ::lNotZoomMode() )
      METHOD editButtonMode()                   INLINE ( ::lNotZoomMode() )
      METHOD deleteButtonMode()                 INLINE ( ::lNotZoomMode() )

   METHOD editDetail()
   METHOD deleteDetail()
   METHOD resourceDetail()                      VIRTUAL
   METHOD getAppendDetail()                     VIRTUAL
   METHOD getEditDetail()                       VIRTUAL

   METHOD lAppendModeDetail()                   INLINE ( ::nModeDetail == APPD_MODE )
   METHOD lEditModeDetail()                     INLINE ( ::nModeDetail == EDIT_MODE )
   METHOD lZoomModeDetail()                     INLINE ( ::nModeDetail == ZOOM_MODE )

   METHOD setFormatToPrint( cFormat )           INLINE ( ::cFormatToPrint := cFormat )
   METHOD resetFormatToPrint( cFormat )         INLINE ( ::cFormatToPrint := "" )

   METHOD onPreSaveEdit()                       INLINE ( .t. )

ENDCLASS

//---------------------------------------------------------------------------//

METHOD Append() CLASS Editable

   local lAppend  := .f.

   if !::onPreAppendDocumento()
      Return ( lAppend )
   end if 

   ::nMode        := APPD_MODE

   ::getAppendDocumento()

   ::onPostGetDocumento()

   if ::Resource()
      lAppend     := ::saveAppend()
   end if

   ::onPreEnd()

Return ( lAppend )

//---------------------------------------------------------------------------//

METHOD saveAppend() CLASS Editable

   local lSave    := .f.

   if !::onPreSaveAppend()
      Return .f.
   end if 

   lSave          := ::saveAppendDocumento()

   if lSave 
      ::onPostSaveAppend()
   end if 

Return ( lSave )

//---------------------------------------------------------------------------//

METHOD Edit() CLASS Editable

   local lEdit    := .f.

   if !::onPreEditDocumento()
      Return ( lEdit )
   end if 

   ::nMode        := EDIT_MODE

   if ::getEditDocumento()

      ::onPostGetDocumento()

      if ::Resource()
         lEdit    := ::saveEdit()
      end if

      ::onPreEnd()

   end if

Return ( lEdit )

//---------------------------------------------------------------------------//

METHOD saveEdit() CLASS Editable

   local lEdit    := .f.

   if !::onPreSaveEdit()
      Return .f.
   end if 

   lEdit          := ::saveEditDocumento()

   if lEdit 
      ::onPostSaveEdit()
   end if 

Return ( lEdit )

//---------------------------------------------------------------------------//

METHOD Zoom() CLASS Editable

   if !::onPreEditDocumento()
      Return ( .f. )
   end if 

   ::nMode        := ZOOM_MODE

   if ::getEditDocumento()

      ::onPostGetDocumento()

      ::Resource()

      ::onPreEnd()

   end if

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD Delete() CLASS Editable

   local lDelete  := .f.

   if !oUser():lMaster()
      apoloMsgStop( "Solo el usuario administrador puede eliminar registros", "Atención" )
      Return ( lDelete )
   end if 

   if apoloMsgNoYes( "¿Desea eliminar el registro?", "Seleccione", .t. )
      lDelete     := ::deleteDocumento()
   end if 

Return ( lDelete )

//---------------------------------------------------------------------------//

METHOD getEditDocumento() CLASS Editable

   ::hDictionaryMaster := D():getHashRecord( ::getDataTable(), ::nView )

   if empty( ::hDictionaryMaster )
      Return .f.
   end if 

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD SaveDocumento() CLASS Editable

   ApoloMsgStop( "savedocumento" )

Return ( self )   

//---------------------------------------------------------------------------//

METHOD AppendDetail() CLASS Editable

   ::nModeDetail     := APPD_MODE

   ::getAppendDetail()

   if ::ResourceDetail( APPD_MODE )

      if ::onPreSaveAppendDetail()
         ::saveAppendDetail()
         ::onPostSaveAppendDetail()
      end if 

      if lEntCon()
         ::AppendDetail()
      end if 

   endif
  
Return ( self )

//---------------------------------------------------------------------------//

METHOD EditDetail( nPos ) CLASS Editable

   if Empty( nPos )
      Return nil
   end if

   ::nPosDetail      := nPos

   ::nModeDetail     := EDIT_MODE

   ::getEditDetail()

   if ::ResourceDetail( EDIT_MODE )

      if ::onPreSaveEditDetail()
         ::saveEditDetail()
      end if 

   end if   

Return ( self )

//---------------------------------------------------------------------------//

METHOD DeleteDetail( nPos ) CLASS Editable

   Local cTxt  := "¿Desea eliminar el registro en curso?"

   if Empty( nPos )
      Return nil
   end if

   if apoloMsgNoYes( cTxt, "Confirme supresión")   
      aDel( ::oDocumentLines:aLines, nPos, .t. )
   endif

   if !Empty( ::oViewEdit:oBrowse )
      ::oViewEdit:oBrowse:Refresh()
   end if

Return ( self )

//---------------------------------------------------------------------------//

