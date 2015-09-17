#include "FiveWin.Ch"
#include "Factu.ch"

CLASS LinesInvoiceCustomer FROM LinesDocumentsSales  

   //METHOD ResourceDetail( nMode )

END CLASS

//---------------------------------------------------------------------------//
/*
METHOD ResourceDetail( nMode ) CLASS LinesInvoiceCustomer

   local lResult        := .f.

   ::oViewEditDetail    := ViewDetail():New( self )

   msgAlert( ::oSender:nModeDetail, "::oSender:nModeDetail" )

   if !Empty( ::oViewEditDetail )

      ::oViewEditDetail:setTitle( LblTitle( ::oSender:nModeDetail ) + "linea de factura" )

      lResult           := ::oViewEditDetail:Resource( nMode )

   end if

Return ( lResult )   
*/
//---------------------------------------------------------------------------//
