#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Xbrowse.ch"

CLASS PedidoClienteViewEdit FROM ViewBase
  
   METHOD New()

   METHOD insertControls()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oSender ) CLASS PedidoClienteViewEdit

   ::oSender   := oSender

Return ( self )

//---------------------------------------------------------------------------//

METHOD insertControls( nMode ) CLASS PedidoClienteViewEdit

   //::defineCodigo()

   //::defineNombre()

   ?"Inserto los controles"

Return ( self )

//---------------------------------------------------------------------------//