#include "FiveWin.Ch"

CLASS DocumentoSerializable FROM Documento

   METHOD SerieDocumento()

END CLASS

//---------------------------------------------------------------------------//

METHOD SerieDocumento() CLASS DocumentoSerializable

   MsgAlert( "Metemos el serie" )

Return ( self )

//---------------------------------------------------------------------------//