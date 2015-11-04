#include "FiveWin.Ch"
#include "Factu.ch"
#include "Xbrowse.ch"

CLASS InvoiceCustomer FROM DocumentsSales  
  
   METHOD New()

   METHOD getAppendDocumento()

   METHOD getEditDocumento()

   METHOD getLinesDocument( id )
   METHOD getDocumentLine()

   METHOD getLines()                      INLINE ( ::oDocumentLines:getLines() )
   METHOD getLineDetail()                 INLINE ( ::oDocumentLines:getLineDetail( ::nPosDetail ) )

   METHOD getAppendDetail()
   METHOD deleteLinesDocument()

   METHOD printDocument()

   METHOD onPostSaveAppend()              INLINE ( generatePagosFacturaCliente( ::getId(), ::nView ),;
                                                   checkPagosFacturaCliente( ::getId(), ::nView ) )

   METHOD appendButtonMode()              INLINE ( ::lAppendMode() .or. ( ::lEditMode() .and. accessCode():lInvoiceModify ) )
   METHOD editButtonMode()                INLINE ( ::appendButtonMode() )
   METHOD deleteButtonMode()              INLINE ( ::appendButtonMode() )

END CLASS

//---------------------------------------------------------------------------//

METHOD New() CLASS InvoiceCustomer

   ::super:New( self )

   ::lAlowEdit          := accessCode():lInvoiceModify

   // Vistas--------------------------------------------------------------------

   ::oViewSearchNavigator:setTitleDocumento( "Facturas de clientes" )  

   ::oViewEdit:setTitleDocumento( "Factura cliente" )  

   ::oViewEditResumen:setTitleDocumento( "Resumen factura" )

   // Tipos--------------------------------------------------------------------

   ::setTypePrintDocuments( "FC" )

   ::setCounterDocuments( "nFacCli" )

   // Areas--------------------------------------------------------------------

   ::setDataTable( "FacCliT" )
   ::setDataTableLine( "FacCliL" )

Return ( self )

//---------------------------------------------------------------------------//

METHOD GetAppendDocumento() CLASS InvoiceCustomer

   ::hDictionaryMaster      := D():getDefaultHashFacturaCliente( ::nView )

Return ( self )

//---------------------------------------------------------------------------//

METHOD getEditDocumento() CLASS InvoiceCustomer

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

METHOD getAppendDetail() CLASS InvoiceCustomer

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