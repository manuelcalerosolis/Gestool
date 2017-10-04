#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS TGenMailingDatabaseAlbaranesProveedor FROM TGenMailingDatabase 

   METHOD New( nView )

   METHOD getAdjunto()                 INLINE ( mailReportAlbPrv( ::cFormatoDocumento ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( nView ) CLASS TGenMailingDatabaseAlbaranesProveedor

   ::Create()

   ::Super:New( nView )

   ::setItems( aItmAlbPrv() )

   ::setWorkArea( D():AlbaranesProveedores( nView ) )

   ::setTypeDocument( "nAlbPrv" )

   ::setTypeFormat( "AP" )

   ::setFormatoDocumento( cFirstDoc( "AP", D():Documentos( nView ) ) )

   ::setBmpDatabase( "gc_mail_earth_48" )

   ::setAsunto( "Envio de nuestro albarán {Serie del albarán}/{Número del albarán}" )

   ::setBlockRecipients( {|| alltrim( retFld( ( D():AlbaranesProveedores( nView ) )->cCodPrv, D():Proveedores( nView ), "cMeiInt" ) ) } )

Return ( Self )

//---------------------------------------------------------------------------//
