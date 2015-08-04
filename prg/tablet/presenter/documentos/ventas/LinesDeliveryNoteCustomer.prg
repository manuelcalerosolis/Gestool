#include "FiveWin.Ch"
#include "Factu.ch"

CLASS LinesDeliveryNoteCustomer FROM LinesDocumentsSales  

   DATA oSender
   
   METHOD ResourceDetail( nMode )

   METHOD getSender()               INLINE ( ::oSender )
   METHOD getView()                 INLINE ( ::getSender():nView )

END CLASS

//---------------------------------------------------------------------------//

METHOD ResourceDetail( nMode ) CLASS LinesDeliveryNoteCustomer

   local lResult     := .f.

   ::oViewEditDetail := ViewDetail():New( self )

   if !Empty( ::oViewEditDetail )

      ::oViewEditDetail:SetTextoTipoDocumento( LblTitle( nMode ) + "linea de albarán" )

      lResult        := ::oViewEditDetail:Resource( nMode )

   end if

Return ( lResult )   

//---------------------------------------------------------------------------//
