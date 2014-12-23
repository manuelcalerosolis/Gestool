
#include "FiveWin.Ch"

CLASS PedidoCliente FROM DocumentoSerializable

   METHOD Resource()
 
END CLASS

//---------------------------------------------------------------------------//

METHOD Resource() CLASS PedidoCliente

   MsgAlert( "Metemos el cliente" )

Return ( self )

//---------------------------------------------------------------------------//