#include "FiveWin.Ch"

CLASS Documento FROM Editable

   METHOD NumeroDocumento()
   METHOD FechaDocumento()
   METHOD CajaDocumento()

END CLASS

//---------------------------------------------------------------------------//

METHOD NumeroDocumento() CLASS Documento

   MsgAlert( "Metemos el número" )

Return ( self )

//---------------------------------------------------------------------------//

METHOD FechaDocumento() CLASS Documento

   MsgAlert( "Metemos el fecha" )

Return ( self )

//---------------------------------------------------------------------------//

METHOD CajaDocumento() CLASS Documento

   MsgAlert( "Metemos el caja" )

Return ( self )

//---------------------------------------------------------------------------//