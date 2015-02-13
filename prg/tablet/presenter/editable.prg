#include "FiveWin.Ch"
#include "Factu.ch" 

CLASS Editable
 
   DATA oThis
   DATA oDlg
   DATA nView

   DATA cDataTable

   DATA oViewNavigator
   DATA oViewSearchNavigator
   DATA oViewEdit

   DATA cDetailArea
   DATA nPosDetail                        INIT 0
   
   DATA hDictionaryMaster
   DATA hDictionaryDetail
   DATA hDictionaryDetailTemporal

   DATA aDetails                          INIT {}
 
   METHOD Append()
   METHOD Edit()
   METHOD Delete()

   METHOD setDataTable( cDataTable )      INLINE ( ::cDataTable := cDataTable )
   METHOD getDataTable()                  INLINE ( ::cDataTable )

   METHOD getAppendDocumento()            INLINE ( ::hDictionaryMaster := D():getHashRecordDefaultValues( ::getDataTable(), ::nView ) )
   METHOD getEditDocumento()              INLINE ( ::hDictionaryMaster := D():getHashRecord( ::getDataTable(), ::nView ) )
   METHOD deleteDocumento()               INLINE ( D():deleteRecord( ::getDataTable(), ::nView ) )
      METHOD Resource()                   VIRTUAL

   METHOD saveAppendDocumento()           INLINE ( D():appendHashRecord( ::hDictionaryMaster, ::getDataTable(), ::nView ) )
   METHOD saveEditDocumento()             INLINE ( D():editHashRecord( ::hDictionaryMaster, ::getDataTable(), ::nView ) )
      METHOD saveDocumento()        

   METHOD getWorkArea()                   INLINE ( D():Get( ::cDataTable, ::nView ) )

   //

   METHOD addDetail( oDetail )            INLINE ( aAdd( ::aDetails, oDetail ) )

   METHOD setDetailArea( cDetailArea )    INLINE ( ::cDetailArea  := cDetailArea )
   METHOD getDetailArea()                 INLINE ( ::cDetailArea )

   METHOD AppendDetail()
   METHOD EditDetail()
   METHOD DeleteDetail()
   METHOD ResourceDetail()                VIRTUAL
   METHOD GetAppendDetail()               VIRTUAL
   METHOD GetEditDetail()                 VIRTUAL

ENDCLASS

//---------------------------------------------------------------------------//

METHOD Append() CLASS Editable

   local lAppend  := .f.

   ::getAppendDocumento()

   lAppend  := ::Resource( APPD_MODE )

   msgAlert( lAppend, "dentro del metodo Append")

   if lAppend
      lAppend     := ::saveAppendDocumento()
   end if

   msgAlert( lAppend, "Append")

Return ( lAppend )

//---------------------------------------------------------------------------//

METHOD Edit() CLASS Editable

   local lEdit    := .f.

   ::getEditDocumento()

   if ::Resource( EDIT_MODE )
      lEdit       := ::saveEditDocumento()
   end if

Return ( lEdit )

//---------------------------------------------------------------------------//

METHOD Delete() CLASS Editable

   local lDelete  := .f.

   if msgNoYes( "¿Desea eliminar el registro?", "Seleccione")
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

   if Empty( nPos )
      Return nil
   end if

   aDel( ::hDictionaryDetail, nPos, .t. )

   if !Empty( ::oViewEdit:oBrowse )
      ::oViewEdit:oBrowse:Refresh()
   end if

Return ( self )

//---------------------------------------------------------------------------//