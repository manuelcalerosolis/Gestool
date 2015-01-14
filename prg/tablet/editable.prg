#include "FiveWin.Ch"
#include "Factu.ch" 

CLASS Editable
 
   DATA oThis
   DATA oDlg
   DATA nView
   DATA cWorkArea
   DATA cDetailArea
   DATA Style           INIT ( nOR( DS_MODALFRAME, WS_POPUP, WS_CAPTION, WS_SYSMENU, WS_MINIMIZEBOX, WS_MAXIMIZEBOX ) )
   DATA hDictionaryMaster
   DATA hDictionaryDetail
 
   METHOD Append()
   METHOD Edit()
   METHOD Delete()

   METHOD GetAppendDocumento()            VIRTUAL
   METHOD GetEditDocumento()              VIRTUAL
   METHOD Resource()                      VIRTUAL
   METHOD SaveDocumento()

   METHOD setWorkArea( cWorkArea )        INLINE ( ::cWorkArea  := cWorkArea )
   METHOD getWorkArea()                   INLINE ( ::cWorkArea )

   METHOD setDetailArea( cDetailArea )    INLINE ( ::cDetailArea  := cDetailArea )
   METHOD getDetailArea()                 INLINE ( ::cDetailArea )

   METHOD AppendDetail()
   METHOD EditDetail()
   METHOD DeleteDetail()
   METHOD ResourceDetail()                VIRTUAL

ENDCLASS

//---------------------------------------------------------------------------//

METHOD Append() CLASS Editable

   ::GetAppendDocumento()

   if ::Resource( APPD_MODE )
      ::SaveDocumento()
   end if

Return ( self )

//---------------------------------------------------------------------------//

METHOD Edit() CLASS Editable

   ::GetEditDocumento()

   if ::Resource( EDIT_MODE )
      ::SaveDocumento()
   end if

Return ( self )

//---------------------------------------------------------------------------//

METHOD Delete() CLASS Editable

   msgInfo( "eliminamos" )

Return ( self )

//---------------------------------------------------------------------------//

METHOD SaveDocumento() CLASS Editable

   msgInfo( "savedocumento" )

Return ( self )   

//---------------------------------------------------------------------------//

METHOD AppendDetail() CLASS Editable

   ::ResourceDetail( APPD_MODE )
  
Return ( self )

//---------------------------------------------------------------------------//

METHOD EditDetail() CLASS Editable

   ::ResourceDetail( EDIT_MODE )

Return ( self )

//---------------------------------------------------------------------------//

METHOD DeleteDetail() CLASS Editable

   MsgInfo( "Elimino una linea" )

Return ( self )

//---------------------------------------------------------------------------//