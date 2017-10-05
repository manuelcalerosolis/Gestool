#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS MovimientosAlmacenController FROM SQLBaseController

   DATA oLineasController

   METHOD New()

   METHOD setGeneralSelectToMovimientosAlmacenLineasModel()
   
   METHOD freeRowSetMovimientosAlmacenLineasModel()   INLINE ( ::oLineasController:oModel:freeRowSet() )

END CLASS

//---------------------------------------------------------------------------//

METHOD New()

   ::cTitle                := "Movimientos de almacen"

   ::cImage                := "gc_document_attachment_16"

   ::nLevel                := nLevelUsr( "01050" )

   ::lTransactional        := .t.

   ::oModel                := SQLMovimientosAlmacenModel():New( self )

   ::oDialogView           := MovimientosAlmacenView():New( self )

   ::oValidator            := MovimientosAlmacenValidator():New( self )

   ::oLineasController     := MovimientosAlmacenLineasController():New( self )

   ::Super:New()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD setGeneralSelectToMovimientosAlmacenLineasModel()

   local uuid              := hget( ::oModel:hBuffer, "uuid" )

   if empty( uuid )
      RETURN ( Self )
   end if 

   ::oLineasController:oModel:setGeneralWhere( "parent_uuid = " + quoted( uuid ) )

RETURN ( Self )

//---------------------------------------------------------------------------//




