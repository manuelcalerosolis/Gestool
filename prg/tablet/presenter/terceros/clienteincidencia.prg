#include "FiveWin.Ch"
#include "Factu.ch" 

CLASS ClienteIncidencia FROM Editable

   DATA oSender

   METHOD New( oSender )

   METHOD setEnviroment()        INLINE ( ::setDataTable( "CliInc" ) ) 
   
   METHOD showNavigator()        INLINE ( ::oViewNavigator:browseGeneral( ::oSender:oViewEdit:oDlg ) ) 
   
   METHOD Resource()

ENDCLASS

//---------------------------------------------------------------------------//

METHOD New( oSender ) CLASS ClienteIncidencia

   ::oSender               := oSender

   ::oViewNavigator        := ClienteIncidenciaViewNavigator():New( self )

   ::setEnviroment()

return ( self )

//---------------------------------------------------------------------------//

METHOD Resource( nMode ) CLASS ClienteIncidencia

   msgAlert( "Resource not defined yet!")

Return ( .t. )   

//---------------------------------------------------------------------------//


