#include "FiveWin.Ch"
#include "Factu.ch"
#include "Xbrowse.ch"

CLASS ReceiptInvoiceCustomer FROM DocumentsSales  
  
   METHOD New()

   METHOD getEditDocumento()

   METHOD onPreEnd()                      INLINE ( .t. )

   METHOD onViewSave()

   METHOD onPreSaveEdit()                 INLINE ( .t. )

   METHOD deleteLinesDocument()           INLINE ( .t. )

   METHOD assignLinesDocument()           INLINE ( .t. )

   METHOD setLinesDocument()              INLINE ( .t. )

END CLASS

//---------------------------------------------------------------------------//

METHOD New() CLASS ReceiptInvoiceCustomer

   ::super:oSender        := self

   if !::openFiles()
      return ( self )
   end if 

   ::oViewSearchNavigator  := ReceiptDocumentSalesViewSearchNavigator():New( self )
   ::oViewSearchNavigator:setTitleDocumento( "Recibos de clientes" )  

   ::oViewEdit             := ReceiptDocumentSalesViewEdit():New( self )
   ::oViewEdit:setTitleDocumento( "Recibo cliente" )  

   ::setTypePrintDocuments( "RF" )

   ::setCounterDocuments( "NRECCLI" )

   // Areas--------------------------------------------------------------------

   ::setDataTable( "FacCliP" )

Return ( self )

//---------------------------------------------------------------------------//

METHOD getEditDocumento() CLASS ReceiptInvoiceCustomer

   local id                := D():FacturasClientesCobrosId( ::nView )

   if Empty( id )
      Return .f.
   end if

   ::hDictionaryMaster     := D():getFacturaClienteCobros( ::nView )

   if empty( ::hDictionaryMaster )
      Return .f.
   end if 

Return ( .t. )

//----------------------------------------------------------------------------//

METHOD onViewSave() CLASS ReceiptInvoiceCustomer

   ::oViewEdit:oDlg:end( IDOK )

Return ( self )

//---------------------------------------------------------------------------//