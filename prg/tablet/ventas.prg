
#include "FiveWin.Ch"

CLASS Ventas FROM DocumentoSerializable

   METHOD ClienteDocumento()

END CLASS

//---------------------------------------------------------------------------//

METHOD ClienteDocumento() CLASS Documento

   MsgAlert( "Metemos el cliente" )

Return ( self )

//---------------------------------------------------------------------------//