#include "FiveWin.Ch"
#include "Factu.ch" 
 
CLASS DocumentoSerializable FROM Editable

   METHOD SerieDocumento()
 
END CLASS

//---------------------------------------------------------------------------//

METHOD SerieDocumento() CLASS DocumentoSerializable

   ApoloMsgStop( "Metemos el serie" )

Return ( self )

//---------------------------------------------------------------------------//