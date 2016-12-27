#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS TGenMailingDatabasePresupuestosClientes FROM TGenMailingDatabase 

   METHOD New( nView )

   METHOD getAdjunto()                 INLINE ( mailReportPreCli( ::cFormatoDocumento ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( nView ) CLASS TGenMailingDatabasePresupuestosClientes

   ::Create()

   ::Super:New( nView )

   ::setItems( aItmPreCli() )

   ::setWorkArea( D():PresupuestosClientes( nView ) )

   ::setTypeDocument( "nPreCli" )

   ::setTypeFormat( "RC" )

   ::setFormatoDocumento( cFirstDoc( "RC", D():Documentos( nView ) ) )

   ::setBmpDatabase( "gc_notebook_user_48" )

   ::setAsunto( "Envio de nuestro presupuesto número {Serie del pedido}/{Número del pedido}" )

   ::setBlockRecipients( {|| alltrim( retFld( ( D():PresupuestosClientes( ::nView ) )->cCodCli, D():Clientes( ::nView ), "cMeiInt" ) ) } )

Return ( Self )

//---------------------------------------------------------------------------//
