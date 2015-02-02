#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS TGenMailingDatabaseSATClientes FROM TGenMailingDatabase 

   METHOD New( nView )

   METHOD getAdjunto()                 INLINE ( mailReportSATCli( ::cFormatoDocumento ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( nView ) CLASS TGenMailingDatabaseSATClientes

   ::Create()

   ::Super:New( nView )

   ::setItems( aItmPreCli() )

   ::setWorkArea( D():SATClientes( nView ) )

   ::setTypeDocument( "nSatCli" )

   ::setTypeFormat( "SC" )

   ::setFormatoDocumento( cFirstDoc( "SC", D():Documentos( nView ) ) )

   ::setBmpDatabase( "S.A.T._cliente_48_alpha" )

   ::setAsunto( "Envio de nuestro presupuesto número {Serie de S.A.T.}/{Número de S.A.T.}" )

   ::setBlockRecipients( {|| alltrim( retFld( ( D():SatClientes( ::nView ) )->cCodCli, D():Clientes( ::nView ), "cMeiInt" ) ) } )

Return ( Self )

//---------------------------------------------------------------------------//
