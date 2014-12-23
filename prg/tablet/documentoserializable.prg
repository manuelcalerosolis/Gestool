#include "FiveWin.Ch"

CLASS DocumentoSerializable FROM Documento

   METHOD SerieDocumento()

END CLASS

//---------------------------------------------------------------------------//

METHOD SerieDocumento() CLASS Documento

   MsgAlert( "Metemos el serie" )

Return ( self )

//---------------------------------------------------------------------------//