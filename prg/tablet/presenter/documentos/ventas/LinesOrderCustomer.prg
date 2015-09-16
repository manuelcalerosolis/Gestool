#include "FiveWin.Ch"
#include "Factu.ch"

CLASS LinesOrderCustomer FROM LinesDocumentsSales  

   METHOD ResourceDetail( nMode )

   METHOD getSender()     INLINE ( ::oSender )
   METHOD getView()       INLINE ( ::getSender():nView )

END CLASS

//---------------------------------------------------------------------------//

METHOD ResourceDetail( nMode ) CLASS LinesOrderCustomer

   local lResult     := .f.

   ::oViewEditDetail := ViewDetail():New( self )

   if !Empty( ::oViewEditDetail )

      ::oViewEditDetail:SetTextoTipoDocumento( LblTitle( nMode ) + "linea de pedido" )

      lResult        := ::oViewEditDetail:Resource( nMode )

   end if

Return ( lResult )   

//---------------------------------------------------------------------------//
