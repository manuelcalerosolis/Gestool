#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Xbrowse.ch"

CLASS PedidoClienteViewEdit FROM ViewEdit
  
   METHOD New()

   METHOD insertControls()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oSender ) CLASS PedidoClienteViewEdit

   ::oSender   := oSender

Return ( self )

//---------------------------------------------------------------------------//

METHOD insertControls( nMode ) CLASS PedidoClienteViewEdit

   ::DefineSerie()

   ::DefineRuta()

   ::DefineCliente()

   ::DefineDireccion()

   msginfo( "Hay que meter la vista con las lineas del pedido" )

   

Return ( self )

//---------------------------------------------------------------------------//