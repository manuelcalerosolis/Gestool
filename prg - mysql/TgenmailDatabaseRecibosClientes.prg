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

   ::setAsunto( "Env�o de recibo de cliente n�mero {Serie de factura}/{N�mero de factura}/{Sufijo de factura}-{N�mero del recibo}" )

   ::setBlockRecipients( {|| alltrim( retFld( ( D():FacturasClientesCobros( nView ) )->cCodCli, D():Clientes( ::nView ), "cMeiInt" ) ) } )

Return ( Self )

//---------------------------------------------------------------------------//