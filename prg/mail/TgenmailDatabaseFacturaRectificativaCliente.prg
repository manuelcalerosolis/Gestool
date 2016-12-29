#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS TGenMailingDatabaseFacturaRectificativaCliente FROM TGenMailingDatabase 

   METHOD New( nView )

   METHOD getAdjunto()                 INLINE ( mailReportFacRec( ::cFormatoDocumento ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( nView ) CLASS TGenMailingDatabaseFacturaRectificativaCliente

   ::Create()

   ::Super:New( nView )

   ::setItems( aItmFacRec() )

   ::setWorkArea( D():FacturasRectificativas( nView ) )

   ::setTypeDocument( "nFacRec" )

   ::setTypeFormat( "FR" )

   ::setFormatoDocumento( cFirstDoc( "FR", D():Documentos( nView ) ) )

   ::setBmpDatabase( "gc_document_text_user2_48" )

   ::setAsunto( "Envio de nuestra factura {Serie de la factura}/{Número de la factura}" )

   ::setBlockRecipients( {|| alltrim( retFld( ( D():FacturasRectificativas( nView ) )->cCodCli, D():Clientes( nView ), "cMeiInt" ) ) } )

Return ( Self )

//---------------------------------------------------------------------------//
