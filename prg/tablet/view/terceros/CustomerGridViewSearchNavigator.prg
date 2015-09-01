#include "FiveWin.Ch"
#include "Factu.ch" 

CLASS CustomerGridViewSearchNavigator FROM CustomerViewSearchNavigator

   METHOD setTextoTipoDocumento()      INLINE ( ::cTextoTipoDocumento := "Búsqueda de clientes" ) 

   METHOD Resource()

END CLASS

//---------------------------------------------------------------------------//

METHOD Resource() CLASS CustomerGridViewSearchNavigator

   ::oDlg                     := TDialog():New( 1, 5, 40, 100, "GESTOOL TABLET",,, .f., ::Style,, rgb( 255, 255, 255 ),,, .F.,, oGridFont(),,,, .f.,, "oDlg" )

   ::defineTitulo()

   ::defineAceptarCancelar()

   ::defineBarraBusqueda()

   ::botonesAcciones()

   ::botonesMovimientoBrowse()

   ::browseGeneral()

   ::oDlg:bResized         := {|| ::resizeDialog() }

   ::oDlg:Activate( ,,,.t.,,, {|| ::InitDialog() } )

Return ( Self )

//---------------------------------------------------------------------------//