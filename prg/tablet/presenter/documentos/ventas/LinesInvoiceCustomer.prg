#include "FiveWin.Ch"
#include "Factu.ch"

CLASS LinesInvoiceCustomer FROM LinesDocumentsSales  

   DATA oSender
   
   METHOD ResourceDetail( nMode )

   METHOD getSender()               INLINE ( ::oSender )
   METHOD getView()                 INLINE ( ::getSender():nView )

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

METHOD ResourceDetail( nMode ) CLASS LinesInvoiceCustomer

   local lResult     := .f.

   ::oViewEditDetail := ViewDetail():New( self )

   if !Empty( ::oViewEditDetail )

      ::oViewEditDetail:SetTextoTipoDocumento( LblTitle( nMode ) + "linea de factura" )

      lResult        := ::oViewEditDetail:Resource( nMode )

   end if

Return ( lResult )   

//---------------------------------------------------------------------------//
