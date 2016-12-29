#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS TGenMailingDatabaseAlbaranesClientes FROM TGenMailingDatabase 

   METHOD New( nView )

   METHOD columnPageDatabase( oDlg )   VIRTUAL

   METHOD getAdjunto()                 INLINE ( mailReportAlbCli( ::cFormatoDocumento ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( nView ) CLASS TGenMailingDatabaseAlbaranesClientes

   ::Create()

   ::Super:New( nView )

   ::setItems( aItmAlbCli() )

   ::setWorkArea( D():AlbaranesClientes( nView ) )

   ::setTypeDocument( "nAlbCli" )

   ::setTypeFormat( "AC" )

   ::setFormatoDocumento( cFirstDoc( "AC", D():Documentos( nView ) ) )

   ::setBmpDatabase( "gc_document_empty_user_48" )

   ::setAsunto( "Envio de nuestro albarán de cliente {Serie del albarán}/{Número del albarán}" )

   ::setBlockRecipients( {|| alltrim( retFld( ( D():AlbaranesClientes( ::nView ) )->cCodCli, D():Clientes( ::nView ), "cMeiInt" ) ) } )

Return ( Self )

//---------------------------------------------------------------------------//
