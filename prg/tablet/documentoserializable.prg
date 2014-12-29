#include "FiveWin.Ch"
#include "Factu.ch" 
 
CLASS DocumentoSerializable FROM Editable

   METHOD SerieDocumento()
 
END CLASS

//---------------------------------------------------------------------------//

METHOD SerieDocumento() CLASS DocumentoSerializable

   MsgAlert( "Metemos el serie" )

Return ( self )

//---------------------------------------------------------------------------//