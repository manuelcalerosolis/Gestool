#include "FiveWin.Ch"
#include "Factu.ch" 

CLASS Editable
 
   DATA oThis
   DATA oDlg
   DATA nView
   DATA cWorkArea
   DATA cDetailArea
 
   METHOD Append()
   METHOD Edit()
   METHOD Delete()

   METHOD GetDocumento()
   METHOD Resource()                      VIRTUAL
   METHOD SaveDocumento()

   METHOD setWorkArea( cWorkArea )        INLINE ( ::cWorkArea  := cWorkArea )
   METHOD getWorkArea()                   INLINE ( ::cWorkArea )

   METHOD setDetailArea( cDetailArea )    INLINE ( ::cDetailArea  := cDetailArea )
   METHOD getDetailArea()                 INLINE ( ::cDetailArea )

ENDCLASS

//---------------------------------------------------------------------------//

METHOD Append() CLASS Editable

   msgInfo( "añadimos" )

   ::GetDocumento()

   if ::Resource()
      ::SaveDocumento()
   end if

Return ( self )

//---------------------------------------------------------------------------//

METHOD Edit() CLASS Editable

   msgInfo( "modificamos" )

   ::GetDocumento()

   if ::Resource()
      ::SaveDocumento()
   end if

Return ( self )

//---------------------------------------------------------------------------//

METHOD Delete() CLASS Editable

   msgInfo( "eliminamos" )

Return ( self )

//---------------------------------------------------------------------------//

METHOD GetDocumento() CLASS Editable

   msgInfo( "getdocumento" )

Return ( self )

//---------------------------------------------------------------------------//

METHOD SaveDocumento() CLASS Editable

   msgInfo( "savedocumento" )

Return ( self )   

//---------------------------------------------------------------------------//