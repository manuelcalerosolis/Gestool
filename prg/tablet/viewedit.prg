#include "FiveWin.Ch"
#include "Factu.ch" 

CLASS ViewEdit FROM ViewBase

   DATA oDlg
   DATA oBrowse
   DATA oSender

   METHOD New()

   METHOD ResourceViewEdit()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oSender ) CLASS ViewEdit

   ::oSender   := oSender

Return ( self )

//---------------------------------------------------------------------------//

METHOD ResourceViewEdit() CLASS ViewEdit

   ::oDlg  := TDialog():New( 1, 5, 40, 100, "GESTOOL TABLET",,, .f., ::Style,, rgb( 255, 255, 255 ),,, .F.,, oGridFont(),,,, .f.,, "oDlg" )

   ::TituloBrowse()

   ::BotonAceptarCancelarBrowse()

   ::oDlg:bResized         := {|| ::DialogResize() }

   ::oDlg:Activate( ,,,.t.,,, {|| ::InitDialog() } )

Return ( self )

//---------------------------------------------------------------------------//