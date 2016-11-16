#include "FiveWin.Ch"
#include "Factu.ch"
#include "Xbrowse.ch"

CLASS ReceiptInvoiceCustomer FROM DocumentsSales  
  
   METHOD New()

   /*METHOD getAppendDocumento()

   METHOD getEditDocumento()

   METHOD getLinesDocument( id )
   METHOD getDocumentLine()

   METHOD getLines()                      INLINE ( ::oDocumentLines:getLines() )
   METHOD getLineDetail()                 INLINE ( ::oDocumentLines:getLineDetail( ::nPosDetail ) )

   METHOD getAppendDetail()
   METHOD deleteLinesDocument()

   METHOD printDocument()                 INLINE ( imprimeFacturaCliente( ::getID(), ::cFormatToPrint ), .t. )

   METHOD onPostSaveAppend()              INLINE ( generatePagosFacturaCliente( ::getId(), ::nView ),;
                                                   checkPagosFacturaCliente( ::getId(), ::nView ) )

   METHOD appendButtonMode()              INLINE ( ::lAppendMode() .or. ( ::lEditMode() .and. accessCode():lInvoiceModify ) )
   METHOD editButtonMode()                INLINE ( ::appendButtonMode() )
   METHOD deleteButtonMode()              INLINE ( ::appendButtonMode() )*/

END CLASS

//---------------------------------------------------------------------------//

METHOD New() CLASS ReceiptInvoiceCustomer

   ::super:New( self )

   // Vistas--------------------------------------------------------------------

   ::oViewSearchNavigator:setTitleDocumento( "Recibos de clientes" )  

   ::oViewEdit:setTitleDocumento( "Recibo cliente" )  

   // Tipos--------------------------------------------------------------------

   ::setTypePrintDocuments( "RF" )

   ::setCounterDocuments( "nRecCli" )

   // Areas--------------------------------------------------------------------

   ::setDataTable( "FacCliP" )

   ?"he entrado"

Return ( self )

//---------------------------------------------------------------------------//

/*METHOD GetAppendDocumento() CLASS ReceiptInvoiceCustomer

   ::hDictionaryMaster      := D():getDefaultHashFacturaCliente( ::nView )

Return ( self )

//---------------------------------------------------------------------------//

METHOD getEditDocumento() CLASS ReceiptInvoiceCustomer

   local id                := D():FacturasClientesId( ::nView )

   if Empty( id )
      Return .f.
   end if

   ::hDictionaryMaster     := D():getFacturaCliente( ::nView )

   if empty( ::hDictionaryMaster )
      Return .f.
   end if 

   ::getLinesDocument( id )

Return ( .t. )

//---------------------------------------------------------------------------//
//
// Convierte las lineas del albaran en objetos
//

METHOD getLinesDocument( id ) CLASS ReceiptInvoiceCustomer

   ::oDocumentLines:reset()

   D():getStatusFacturasClientesLineas( ::nView )

   ( D():FacturasClientesLineas( ::nView ) )->( ordSetFocus( 1 ) )

   if ( D():FacturasClientesLineas( ::nView ) )->( dbSeek( id ) )  

      while ( D():FacturasClientesLineasId( ::nView ) == id ) .and. !( D():FacturasClientesLineas( ::nView ) )->( eof() ) 

         ::addDocumentLine()
      
         ( D():FacturasClientesLineas( ::nView ) )->( dbSkip() ) 
      
      end while

   end if 
   
   D():setStatusFacturasClientesLineas( ::nView ) 

RETURN ( self ) 

//---------------------------------------------------------------------------//

METHOD getDocumentLine() CLASS ReceiptInvoiceCustomer

   local hLine    := D():GetFacturaClienteLineasHash( ::nView )

   if empty( hLine )
      Return ( nil )
   end if 

Return ( DictionaryDocumentLine():New( self, hLine ) )

//---------------------------------------------------------------------------//

METHOD getAppendDetail() CLASS ReceiptInvoiceCustomer

   local hLine             := D():GetFacturaClienteLineaDefaultValues( ::nView )

   ::oDocumentLineTemporal := DictionaryDocumentLine():New( self, hLine )

Return ( self )

//---------------------------------------------------------------------------//

METHOD deleteLinesDocument() CLASS ReceiptInvoiceCustomer

   D():getStatusFacturasClientesLineas( ::nView )

   ( D():FacturasClientesLineas( ::nView ) )->( ordSetFocus( 1 ) )

   while ( D():FacturasClientesLineas( ::nView ) )->( dbSeek( ::getID() ) ) 
      ::delDocumentLine()
   end while

   D():setStatusFacturasClientesLineas( ::nView ) 

Return ( Self )

//---------------------------------------------------------------------------//*/

