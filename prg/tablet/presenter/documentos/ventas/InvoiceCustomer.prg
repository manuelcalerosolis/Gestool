#include "FiveWin.Ch"
#include "Factu.ch"
#include "Xbrowse.ch"

CLASS InvoiceCustomer FROM DocumentsSales  

   DATA oLinesDeliveryNoteCustomer
   DATA CodigoAgente                      INIT AccessCode():cAgente

   METHOD New()

   METHOD resourceDetail( nMode )         INLINE ( ::oLinesDeliveryNoteCustomer:ResourceDetail( nMode ) )

   METHOD getAppendDocumento()
   METHOD getEditDocumento()

   METHOD getLinesDocument( id )
   METHOD getDocumentLine()

   METHOD getLines()                      INLINE ( ::oDocumentLines:getLines() )
   METHOD getLineDetail()                 INLINE ( ::oDocumentLines:getLineDetail( ::nPosDetail ) )

   METHOD getAppendDetail()
   METHOD deleteLinesDocument()

   METHOD printDocument()

END CLASS

//---------------------------------------------------------------------------//

METHOD New() CLASS InvoiceCustomer

   ::super:New( self )

   ::setTextSummaryDocument( "Resumen factura" )
   ::setTypePrintDocuments( "FC" )
   ::setCounterDocuments( "nFacCli" )

   ::oViewSearchNavigator:setTextoTipoDocumento( "Facturas de clientes" )  

   ::oViewEdit:setTextoTipoDocumento( "Factura" )  

   ::oLinesDeliveryNoteCustomer           := LinesInvoiceCustomer():New( self )
 
   // Areas

   ::setDataTable( "FacCliT" )
   ::setDataTableLine( "FacCliL" )

   ( ::getWorkArea() )->( ordSetFocus( "dFecDes" ) )
   ( ::getWorkArea() )->( dbgotop() ) 

Return ( self )

//---------------------------------------------------------------------------//

METHOD GetAppendDocumento() CLASS InvoiceCustomer

   ::hDictionaryMaster      := D():getDefaultHashFacturaCliente( ::nView )

Return ( self )

//---------------------------------------------------------------------------//

METHOD GetEditDocumento() CLASS InvoiceCustomer

   local id                := D():FacturasClientesId( ::nView )

   if Empty( id )
      Return .f.
   end if

   ::hDictionaryMaster     := D():getFacturaCliente( ::nView )

   ::getLinesDocument( id )

Return ( .t. )

//---------------------------------------------------------------------------//
//
// Convierte las lineas del albaran en objetos
//

METHOD getLinesDocument( id ) CLASS InvoiceCustomer

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

METHOD getDocumentLine() CLASS InvoiceCustomer

   local hLine    := D():GetFacturaClienteLineasHash( ::nView )

   if empty( hLine )
      Return ( nil )
   end if 

Return ( DocumentLine():New( hLine, self ) )

//---------------------------------------------------------------------------//

METHOD GetAppendDetail() CLASS InvoiceCustomer

   local hLine             := D():GetFacturaClienteLineaBlank( ::nView )

   ::oDocumentLineTemporal := DocumentLine():New( hLine, self )

Return ( self )

//---------------------------------------------------------------------------//

METHOD deleteLinesDocument() CLASS InvoiceCustomer

   D():getStatusFacturasClientesLineas( ::nView )

   ( D():FacturasClientesLineas( ::nView ) )->( ordSetFocus( 1 ) )

   while ( D():FacturasClientesLineas( ::nView ) )->( dbSeek( ::getID() ) ) 
      ::delDocumentLine()
   end while

   D():setStatusFacturasClientesLineas( ::nView ) 

Return ( Self )

//---------------------------------------------------------------------------//

METHOD printDocument() CLASS InvoiceCustomer

   imprimeFacturaCliente( ::getID(), ::cFormatToPrint )

Return ( .t. )

//---------------------------------------------------------------------------//