#include "FiveWin.Ch"
#include "Factu.ch" 
 
CLASS DocumentSerialize FROM Editable

   METHOD SerieDocumento()
 
END CLASS

//---------------------------------------------------------------------------//

METHOD SerieDocumento() CLASS DocumentSerialize

   ApoloMsgStop( "Metemos el serie" )

Return ( self )

//---------------------------------------------------------------------------//