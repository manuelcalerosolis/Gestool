#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Xbrowse.ch"

CLASS InvoiceDocumentSalesViewEdit FROM DocumentSalesViewEdit  

   METHOD defineAceptarCancelar()
  
END CLASS

//---------------------------------------------------------------------------//

METHOD defineAceptarCancelar() CLASS InvoiceDocumentSalesViewEdit

   if ::getMode() == EDIT_MODE

      TGridImage():Build(  {  "nTop"      => 5,;
                              "nLeft"     => {|| GridWidth( 7.5, ::oDlg ) },;
                              "nWidth"    => 64,;
                              "nHeight"   => 64,;
                              "cResName"  => "gc_briefcase2_user_64",;
                              "bLClicked" => {|| ReceiptInvoiceCustomer():New( ::oSender ):play() },;
                              "oWnd"      => ::oDlg } )

   end if

   ::buttonCancel    :=    TGridImage():Build(  {  "nTop"      => 5,;
                                                   "nLeft"     => {|| GridWidth( 9.0, ::oDlg ) },;
                                                   "nWidth"    => 64,;
                                                   "nHeight"   => 64,;
                                                   "cResName"  => "gc_error_64",;
                                                   "bLClicked" => {|| ::cancelView() },;
                                                   "oWnd"      => ::oDlg } )

   ::buttonOk        :=    TGridImage():Build(  {  "nTop"      => 5,;
                                                   "nLeft"     => {|| GridWidth( 10.5, ::oDlg ) },;
                                                   "nWidth"    => 64,;
                                                   "nHeight"   => 64,;
                                                   "cResName"  => "gc_ok_64",;
                                                   "bLClicked" => {|| ::oSender:onViewSave() },;
                                                   "oWnd"      => ::oDlg } )

Return ( self )

//---------------------------------------------------------------------------//