#include "FiveWin.Ch"
#include "Factu.ch" 

CLASS Editable
 
   DATA oDlg

   DATA nView

   DATA nMode

   DATA cDataTable
   DATA cDataTableLine
   DATA cDataTableLineID

   DATA oViewNavigator
   DATA oViewSearchNavigator
   DATA oViewEdit

   DATA cDetailArea
   DATA nPosDetail                              INIT 0
   
   DATA hDictionaryMaster
   DATA hDictionaryDetail
   DATA oDocumentLineTemporal

   DATA aDetails                                INIT {}
 
   METHOD Append()
   METHOD saveAppend()
   METHOD Edit()
   METHOD saveEdit()
   METHOD Delete()

   METHOD setDataTable( cDataTable )            INLINE ( ::cDataTable := cDataTable )
   METHOD getDataTable()                        INLINE ( ::cDataTable )

   METHOD setDataTableLine( cDataTableLine )    INLINE ( ::cDataTableLine := cDataTableLine )
   METHOD getDataTableLine()                    INLINE ( ::cDataTableLine )

   METHOD setDataTableLineID( cDataTableLineID )  INLINE ( ::cDataTableLineID := cDataTableLineID )
   METHOD getDataTableLineID()                    INLINE ( ::cDataTableLineID )

   METHOD onPostGetDocumento()                  INLINE ( .t. )
   METHOD onPreSaveAppendDocumento()            VIRTUAL
   METHOD onPostSaveAppendDocumento()           INLINE ( .t. )

   METHOD onPreSaveEditDocumento()              VIRTUAL
   METHOD onPostSaveEditDocumento()             INLINE ( .t. )

   METHOD getAppendDocumento()                  INLINE ( ::hDictionaryMaster := D():getHashRecordDefaultValues( ::getDataTable(), ::nView ) )
   METHOD getEditDocumento()                    INLINE ( ::hDictionaryMaster := D():getHashRecord( ::getDataTable(), ::nView ) )
   METHOD deleteDocumento()                     INLINE ( D():deleteRecord( ::getDataTable(), ::nView ) )
      METHOD Resource()                         INLINE ( msgStop( "Resource method must be redefined" ) )

   METHOD saveAppendDocumento()                 INLINE ( D():appendHashRecord( ::hDictionaryMaster, ::getDataTable(), ::nView ) )
   METHOD saveEditDocumento()                   INLINE ( D():editHashRecord( ::hDictionaryMaster, ::getDataTable(), ::nView ) )
      METHOD saveDocumento()        

   METHOD getWorkArea()                         INLINE ( D():Get( ::cDataTable, ::nView ) )

   METHOD addDetail( oDetail )                  INLINE ( aAdd( ::aDetails, oDetail ) )

   METHOD setDetailArea( cDetailArea )          INLINE ( ::cDetailArea  := cDetailArea )
   METHOD getDetailArea()                       INLINE ( ::cDetailArea )

   METHOD lAppendMode()                         INLINE ( ::nMode == APPD_MODE )
   METHOD lEditMode()                           INLINE ( ::nMode == EDIT_MODE )
   METHOD lZoomMode()                           INLINE ( ::nMode == ZOOM_MODE )

   METHOD AppendDetail()
   METHOD EditDetail()
   METHOD DeleteDetail()
   METHOD ResourceDetail()                      VIRTUAL
   METHOD GetAppendDetail()                     VIRTUAL
   METHOD GetEditDetail()                       VIRTUAL

ENDCLASS

//---------------------------------------------------------------------------//

METHOD Append() CLASS Editable

   local lAppend  := .f.

   ::nMode        := APPD_MODE

   ::getAppendDocumento()

   ::onPostGetDocumento()

   if ::Resource()
      lAppend     := ::saveAppend()
   end if

   ::oDocumentLines:reset()

Return ( lAppend )

//---------------------------------------------------------------------------//

METHOD saveAppend() CLASS Editable

   local lSave    := .f.

   if !::onPreSaveAppendDocumento()
      Return .f.
   end if 

   lSave          := ::saveAppendDocumento()

   if lSave 
      ::onPostSaveAppendDocumento()
   end if 

Return ( lSave )

//---------------------------------------------------------------------------//

METHOD Edit() CLASS Editable

   local lEdit    := .f.

   ::nMode        := EDIT_MODE

   ::getEditDocumento()

   ::onPostGetDocumento()

   if ::Resource()
      lEdit       := ::saveEdit()
   end if

   ::oDocumentLines:reset()

Return ( lEdit )

//---------------------------------------------------------------------------//

METHOD saveEdit() CLASS Editable

   local lEdit    := .f.

   if !::onPreSaveEditDocumento()
      Return .f.
   end if 

   lEdit          := ::saveEditDocumento()

   if lEdit 
      ::onPostSaveEditDocumento()
   end if 

Return ( lEdit )

//---------------------------------------------------------------------------//

METHOD Delete() CLASS Editable

   local lDelete  := .f.

   if !oUser():lMaster()
      apoloMsgStop( "Solo el usuario administrador puede eliminar registros", "Atención" )
      Return ( lDelete )
   end if 

   if ApoloMsgNoYes( "¿Desea eliminar el registro?", "Seleccione", .t. )
      lDelete     := ::deleteDocumento()
   end if 

Return ( lDelete )

//---------------------------------------------------------------------------//

METHOD SaveDocumento() CLASS Editable

   ApoloMsgStop( "savedocumento" )

Return ( self )   

//---------------------------------------------------------------------------//

METHOD AppendDetail() CLASS Editable

   ::GetAppendDetail()

   if ::ResourceDetail( APPD_MODE )
      ::AppendGuardaLinea()
   end if   
  
Return ( self )

//---------------------------------------------------------------------------//

METHOD EditDetail( nPos ) CLASS Editable

   if Empty( nPos )
      Return nil
   end if

   ::nPosDetail   := nPos

   ::GetEditDetail()

   if ::ResourceDetail( EDIT_MODE )
      ::EditGuardaLinea()
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