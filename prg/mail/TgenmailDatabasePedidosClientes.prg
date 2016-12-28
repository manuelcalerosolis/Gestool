#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS TGenMailingDatabasePedidosClientes FROM TGenMailingDatabase 

   METHOD New( nView )

   METHOD getAdjunto()                 INLINE ( mailReportPedCli( ::cFormatoDocumento ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( nView ) CLASS TGenMailingDatabasePedidosClientes

   ::Create()

   ::Super:New( nView )

   ::setItems( aItmPedCli() )

   ::setWorkArea( D():PedidosClientes( nView ) )

   ::setTypeDocument( "nPedCli" )

   ::setTypeFormat( "PC" )

   ::setFormatoDocumento( cFirstDoc( "PC", D():Documentos( nView ) ) )

   ::setBmpDatabase( "gc_clipboard_empty_user_48" )

   ::setAsunto( "Envio de nuestro pedido número {Serie del pedido}/{Número del pedido}" )

   ::setBlockRecipients( {|| alltrim( retFld( ( D():PedidosClientes( ::nView ) )->cCodCli, D():Clientes( ::nView ), "cMeiInt" ) ) } )

Return ( Self )

//---------------------------------------------------------------------------//
