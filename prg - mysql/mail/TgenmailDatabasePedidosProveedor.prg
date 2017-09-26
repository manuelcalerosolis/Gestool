#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS TGenMailingDatabasePedidosProveedor FROM TGenMailingDatabase 

   METHOD New( nView )

   METHOD getAdjunto()                 INLINE ( mailReportPedPrv( ::cFormatoDocumento ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( nView ) CLASS TGenMailingDatabasePedidosProveedor

   ::Create()

   ::Super:New( nView )

   ::setItems( aItmPedPrv() )

   ::setWorkArea( D():PedidosProveedores( nView ) )

   ::setTypeDocument( "nPedPrv" )

   ::setTypeFormat( "PP" )

   ::setFormatoDocumento( cFirstDoc( "PP", D():Documentos( nView ) ) )

   ::setBmpDatabase( "gc_businessman_48" )

   ::setAsunto( "Envio de nuestro pedido número {Serie del pedido}/{Número del pedido}" )

   ::setBlockRecipients( {|| alltrim( retFld( ( D():PedidosProveedores( nView ) )->cCodPrv, D():Proveedores( nView ), "cMeiInt" ) ) } )

Return ( Self )

//---------------------------------------------------------------------------//