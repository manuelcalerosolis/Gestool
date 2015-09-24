#include "FiveWin.Ch"
#include "Factu.ch"

CLASS LinesOrderCustomer FROM LinesDocumentsSales  

   METHOD onPreSaveAppendDetail()                           INLINE ( msgAlert( "onPreSaveAppendDetail LinesOrderCustomer" ), .t. )

   METHOD ResourceDetail( nMode )

END CLASS

//---------------------------------------------------------------------------//

METHOD ResourceDetail( nMode ) CLASS LinesOrderCustomer

   local lResult     := .f.

   ::oViewEditDetail := ViewDetail():New( self )

   if !Empty( ::oViewEditDetail )

      ::oViewEditDetail:setTitle( LblTitle( nMode ) + "linea de pedido" )

      lResult        := ::oViewEditDetail:Resource( nMode )

   end if

Return ( lResult )   

//---------------------------------------------------------------------------//
