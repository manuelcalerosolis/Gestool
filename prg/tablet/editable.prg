#include "FiveWin.Ch"
#include "Factu.ch" 

CLASS Editable
 
   DATA oThis
   DATA oDlg
   DATA nView
   DATA cWorkArea
   DATA cDetailArea
   DATA Style           INIT ( nOR( DS_MODALFRAME, WS_POPUP, WS_CAPTION, WS_SYSMENU, WS_MINIMIZEBOX, WS_MAXIMIZEBOX ) )
 
   METHOD Append()
   METHOD Edit()
   METHOD Delete()

   METHOD GetAppendDocumento()
   METHOD GetEditDocumento()
   METHOD Resource()                      VIRTUAL
   METHOD SaveDocumento()

   METHOD setWorkArea( cWorkArea )        INLINE ( ::cWorkArea  := cWorkArea )
   METHOD getWorkArea()                   INLINE ( ::cWorkArea )

   METHOD setDetailArea( cDetailArea )    INLINE ( ::cDetailArea  := cDetailArea )
   METHOD getDetailArea()                 INLINE ( ::cDetailArea )

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

METHOD GetAppendDocumento() CLASS Editable

   msgInfo( "getAppendDocumento" )

   ?::getWorkArea()
   ?::getDetailArea()

Return ( self )

//---------------------------------------------------------------------------//

METHOD GetEditDocumento() CLASS Editable

   msgInfo( "getEditDocumento" )

   ?::getWorkArea()
   ?::getDetailArea()

Return ( self )

//---------------------------------------------------------------------------//

METHOD SaveDocumento() CLASS Editable

   msgInfo( "savedocumento" )

Return ( self )   

//---------------------------------------------------------------------------//