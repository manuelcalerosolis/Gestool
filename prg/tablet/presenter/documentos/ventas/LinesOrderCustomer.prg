#include "FiveWin.Ch"
#include "Factu.ch"

CLASS LinesOrderCustomer FROM LinesDocumentsSales  

   DATA oSender
   
   METHOD ResourceDetail( nMode )

   METHOD getOrderCustomer()     INLINE ( ::oSender )
   METHOD getView()              INLINE ( ::getOrderCustomer():nView )

END CLASS

//---------------------------------------------------------------------------//
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
