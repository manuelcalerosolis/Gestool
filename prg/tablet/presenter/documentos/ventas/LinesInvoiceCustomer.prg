#include "FiveWin.Ch"
#include "Factu.ch"

CLASS LinesInvoiceCustomer FROM LinesDocumentsSales  

   METHOD ResourceDetail( nMode )

END CLASS

//---------------------------------------------------------------------------//

METHOD ResourceDetail( nMode ) CLASS LinesInvoiceCustomer

   local lResult        := .f.

   ::oViewEditDetail    := ViewDetail():New( self )

   if !Empty( ::oViewEditDetail )

      ::oViewEditDetail:SetTextoTipoDocumento( LblTitle( nMode ) + "linea de factura" )

      lResult           := ::oViewEditDetail:Resource( nMode )

   end if

Return ( lResult )   

//---------------------------------------------------------------------------//
