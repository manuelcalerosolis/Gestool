#include "FiveWin.Ch"
#include "Factu.ch" 

CLASS Reporting FROM Editable

   METHOD New()

   METHOD Resource()                   INLINE ( ::oViewNavigator:Resource() )   

ENDCLASS

//---------------------------------------------------------------------------//

METHOD New() CLASS Reporting

   ::oViewNavigator                       := ViewReporting():New( self )
   ::oViewNavigator:setTitleDocumento( "Galería de Informes" )

Return ( self )

//---------------------------------------------------------------------------//