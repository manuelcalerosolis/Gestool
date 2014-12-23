#include "FiveWin.Ch"

CLASS Documento FROM Editable

   METHOD NumeroDocumento()
   METHOD FechaDocumento()
   METHOD AlmacenDocumento()

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

METHOD AlmacenDocumento() CLASS Documento

   MsgAlert( "Metemos el Almacén" )

Return ( self )   

//---------------------------------------------------------------------------//