#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS TGenMailingDatabaseRecibosClientes FROM TGenMailingDatabase 

   METHOD New( nView )

   METHOD getAdjunto()                 INLINE ( mailReportRecCli( ::cFormatoDocumento ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( nView ) CLASS TGenMailingDatabaseRecibosClientes

   ::Create()

   ::Super:New( nView )

   ::setItems( aItmRecCli() )

   ::setWorkArea( D():FacturasClientesCobros( nView ) )

   ::setTypeDocument( "nRecCli" )

   ::setTypeFormat( "RF" )

   ::setFormatoDocumento( cFirstDoc( "RF", D():Documentos( nView ) ) )

   ::setBmpDatabase( "gc_money2_48" )

   ::setAsunto( "Envío de recibo de cliente número {Serie de factura}/{Número de factura}/{Sufijo de factura}-{Número del recibo}" )

   ::setBlockRecipients( {|| alltrim( retFld( ( D():FacturasClientesCobros( nView ) )->cCodCli, D():Clientes( ::nView ), "cMeiInt" ) ) } )

Return ( Self )

//---------------------------------------------------------------------------//