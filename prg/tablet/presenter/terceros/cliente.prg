#include "FiveWin.Ch"
#include "Factu.ch" 

CLASS Cliente FROM Ventas

   DATA oClienteIncidencia

   DATA oViewIncidencia

   METHOD New()

   METHOD setEnviroment()        INLINE ( ::setDataTable( "Client" ) ) 
   
   METHOD showIncidencia()       INLINE ( ::oClienteIncidencia:showNavigator() )

   METHOD Resource()             INLINE ( ::oViewEdit:Resource() )   

ENDCLASS

//---------------------------------------------------------------------------//

METHOD New() CLASS Cliente

   if ::OpenFiles()

      ::oViewNavigator        := ClienteViewSearchNavigator():New( self )

      ::oViewEdit             := ClienteView():New( self )

      ::oClienteIncidencia    := ClienteIncidencia():New( self )

      ::setEnviroment()

      ::oViewNavigator:showView()

      ::CloseFiles()

   end if   

Return ( self )

//---------------------------------------------------------------------------//




