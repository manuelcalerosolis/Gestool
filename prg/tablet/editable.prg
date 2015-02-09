#include "FiveWin.Ch"
#include "Factu.ch" 

CLASS Editable
 
   DATA oThis
   DATA oDlg
   DATA nView
   DATA cWorkArea

   DATA oViewNavigator
   DATA oViewEdit

   DATA cDetailArea
   DATA nPosDetail                        INIT 0
   DATA Style                             INIT ( nOR( DS_MODALFRAME, WS_POPUP, WS_CAPTION, WS_SYSMENU, WS_MINIMIZEBOX, WS_MAXIMIZEBOX ) )
   
   DATA hDictionaryMaster
   DATA hDictionaryDetail
   DATA hDictionaryDetailTemporal
 
   METHOD Append()
   METHOD Edit()
   METHOD Delete()

   METHOD getAppendDocumento()            VIRTUAL
   METHOD getEditDocumento()              VIRTUAL
      METHOD Resource()                   VIRTUAL

   METHOD setAppendDocumento()            INLINE ( msgalert( hb_valtoexp( ::hDictionaryMaster ) ) )           
   METHOD setEditDocumento()              INLINE ( msgalert( hb_valtoexp( ::hDictionaryMaster ) ) )
      METHOD saveDocumento()        

   METHOD setWorkArea( cWorkArea )        INLINE ( ::cWorkArea  := cWorkArea )
   METHOD getWorkArea()                   INLINE ( ::cWorkArea )

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

   ::getAppendDocumento()

   if ::Resource( APPD_MODE )
      ::setAppendDocumento()
   end if

Return ( self )

//---------------------------------------------------------------------------//

METHOD Edit() CLASS Editable

   ::getEditDocumento()

   if ::Resource( EDIT_MODE )
      ::setEditDocumento()
   end if

Return ( self )

//---------------------------------------------------------------------------//

METHOD Delete() CLASS Editable

   ApoloMsgStop( "eliminamos" )

Return ( self )

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