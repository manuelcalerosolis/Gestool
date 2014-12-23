
#include "FiveWin.Ch"

CLASS Ventas FROM DocumentoSerializable

   METHOD ClienteDocumento()

END CLASS

//---------------------------------------------------------------------------//

METHOD ClienteDocumento() CLASS Ventas

   MsgAlert( "Metemos el cliente" )

Return ( self )

//---------------------------------------------------------------------------//