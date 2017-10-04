#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS TGenMailingDatabaseFacturaProveedor FROM TGenMailingDatabase 

   METHOD New( nView )

   METHOD getAdjunto()                 INLINE ( mailReportFacPrv( ::cFormatoDocumento ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( nView ) CLASS TGenMailingDatabaseFacturaProveedor

   ::Create()

   ::Super:New( nView )

   ::setItems( aItmFacPrv() )

   ::setWorkArea( D():FacturasProveedores( nView ) )

   ::setTypeDocument( "nFacPrv" )

   ::setTypeFormat( "FP" )

   ::setFormatoDocumento( cFirstDoc( "FP", D():Documentos( nView ) ) )

   ::setBmpDatabase( "gc_businessman_48" )

   ::setAsunto( "Envio de nuestra factura {Serie de factura}/{Número de factura}" )

   ::setBlockRecipients( {|| alltrim( retFld( ( D():FacturasProveedores( nView ) )->cCodPrv, D():Proveedores( nView ), "cMeiInt" ) ) } )

Return ( Self )

//---------------------------------------------------------------------------//
