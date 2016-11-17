#include "FiveWin.Ch"
#include "Factu.ch"
#include "Xbrowse.ch"

CLASS ReceiptInvoiceCustomer FROM DocumentsSales  
  
   METHOD New()

   METHOD getAppendDocumento()

   METHOD getEditDocumento()

   /*METHOD getLinesDocument( id )
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

   METHOD onPreRunNavigator

END CLASS

//---------------------------------------------------------------------------//

METHOD New() CLASS ReceiptInvoiceCustomer

   ::super:oSender        := self

   if !::openFiles()
      return ( self )
   end if 

   ::oViewSearchNavigator  := ReceiptDocumentSalesViewSearchNavigator():New( self )
   ::oViewSearchNavigator:setTitleDocumento( "Recibos de clientes" )  

   ::oViewEdit             := DocumentSalesViewEdit():New( self )
   ::oViewEdit:setTitleDocumento( "Recibo cliente" )  

   ::oViewEditResumen      := ViewEditResumen():New( self )
   ::oViewEditResumen:setTitleDocumento( "Resumen recibo" )

   //::oCliente              := Customer():init( self )  

   //::oProduct              := Product():init( self )

   //::oStore                := Store():init( self )

   //::oPayment              := Payment():init( self )

   //::oDirections           := Directions():init( self )

   //::oDocumentLines        := DocumentLines():New( self )

   //::oLinesDocumentsSales  := LinesDocumentsSales():New( self )

   //::oTotalDocument        := TotalDocument():New( self )

   // Tipos--------------------------------------------------------------------

   ::setTypePrintDocuments( "RF" )

   ::setCounterDocuments( "NRECCLI" )

   // Areas--------------------------------------------------------------------

   ::setDataTable( "FacCliP" )

Return ( self )

//---------------------------------------------------------------------------//

METHOD GetAppendDocumento() CLASS ReceiptInvoiceCustomer

   //::hDictionaryMaster      := D():getDefaultHashFacturaCliente( ::nView )

   MsgInfo( "Append" )

Return ( self )

//---------------------------------------------------------------------------//

METHOD getEditDocumento() CLASS ReceiptInvoiceCustomer

   MsgInfo( "Edit" )

   /*local id                := D():FacturasClientesId( ::nView )

   if Empty( id )
      Return .f.
   end if

   ::hDictionaryMaster     := D():getFacturaCliente( ::nView )

   if empty( ::hDictionaryMaster )
      Return .f.
   end if 

   ::getLinesDocument( id )*/

Return ( .t. )

//----------------------------------------------------------------------------//

METHOD onPreRunNavigator() CLASS ReceiptInvoiceCustomer

   if empty( ::getWorkArea() )
      Return .t.
   end if 

   MsgInfo( ::getWorkArea(), "GetWorkArea" )
   MsgInfo( ( ::getWorkArea() )->( ordsetfocus() ), "OrdSetFocus" )

Return ( .t. )

//---------------------------------------------------------------------------//
//
// Convierte las lineas del albaran en objetos
//

/*METHOD getLinesDocument( id ) CLASS ReceiptInvoiceCustomer

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

Return ( Self )*/

//---------------------------------------------------------------------------//