#include "FiveWin.Ch"
#include "Factu.ch" 

CLASS Editable
 
   DATA oThis
   DATA oDlg
   DATA nView
   DATA cArea
 
   METHOD Append()   Virtual
   METHOD Edit()     Virtual
   METHOD Zoom()     Virtual
   METHOD Delete()   Virtual 

   METHOD setWorkArea( cArea )    INLINE ( ::cArea  := cArea )
   METHOD getWorkArea()           INLINE ( ::cArea )

ENDCLASS