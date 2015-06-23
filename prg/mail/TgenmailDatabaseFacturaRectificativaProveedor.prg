#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS TGenMailingDatabaseFacturaRectificativaProveedor FROM TGenMailingDatabase 

   METHOD New( nView )

   METHOD getAdjunto()                 INLINE ( mailReportRctPrv( ::cFormatoDocumento ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( nView ) CLASS TGenMailingDatabaseFacturaRectificativaProveedor

   ::Create()

   ::Super:New( nView )

   ::setItems( aItmRctPrv() )

   ::setWorkArea( D():FacturasRectificativasProveedores( nView ) )

   ::setTypeDocument( "nFacRec" )

   ::setTypeFormat( "TP" )

   ::setFormatoDocumento( cFirstDoc( "TP", D():Documentos( nView ) ) )

   ::setBmpDatabase( "Factura_cliente_48_alpha" )

   ::setAsunto( "Envio de nuestra factura {Serie de factura}/{Número de factura}" )

   ::setBlockRecipients( {|| alltrim( retFld( ( D():FacturasRectificativasProveedores( nView ) )->cCodPrv, D():Proveedores( nView ), "cMeiInt" ) ) } )

Return ( Self )

//---------------------------------------------------------------------------//
