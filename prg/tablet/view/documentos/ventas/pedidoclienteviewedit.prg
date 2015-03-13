#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Xbrowse.ch"

CLASS PedidoClienteViewEdit FROM ViewEdit
  
   METHOD New()

   METHOD insertControls()

   METHOD evalRotor()         INLINE ( ::oSender:evalRotor() )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oSender ) CLASS PedidoClienteViewEdit

   ::oSender   := oSender

Return ( self )

//---------------------------------------------------------------------------//

METHOD insertControls() CLASS PedidoClienteViewEdit

   ::defineSerie()

   ::defineRuta()

   ::defineCliente()

   ::defineDireccion()

   ::defineBrowseLineas()

Return ( self )

//---------------------------------------------------------------------------//