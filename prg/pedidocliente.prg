
#include "FiveWin.Ch"

CLASS PedidoCliente FROM DocumentoSerializable 

   METHOD Resource()
 
END CLASS

//---------------------------------------------------------------------------//

METHOD Resource() CLASS PedidoCliente

   MsgAlert( "Resource de pedidos de clientes" )

Return ( self )

//---------------------------------------------------------------------------//