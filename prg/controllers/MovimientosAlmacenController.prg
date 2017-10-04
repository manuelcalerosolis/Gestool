#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS MovimientosAlmacenController FROM SQLBaseController

   DATA oLineasController

   METHOD New()

   METHOD setGeneralSelectToMovimientosAlmacenLineasModel()
   
   METHOD freeRowSetMovimientosAlmacenLineasModel()   INLINE ( ::oLineasController:oModel:freeRowSet() )

   METHOD initAppendMode()                            INLINE ( ::setGeneralSelectToMovimientosAlmacenLineasModel() )     
   METHOD initDuplicateMode()                         INLINE ( ::setGeneralSelectToMovimientosAlmacenLineasModel() )     
   METHOD initEditMode()                              INLINE ( ::setGeneralSelectToMovimientosAlmacenLineasModel() )     
   METHOD initZoomMode()                              INLINE ( ::setGeneralSelectToMovimientosAlmacenLineasModel() )     

   METHOD endAppendMode()                             INLINE ( ::freeRowSetMovimientosAlmacenLineasModel() )     
   METHOD endDuplicateMode()                          INLINE ( ::freeRowSetMovimientosAlmacenLineasModel() )     
   METHOD endEditMode()                               INLINE ( ::freeRowSetMovimientosAlmacenLineasModel() )     
   METHOD endZoomMode()                               INLINE ( ::freeRowSetMovimientosAlmacenLineasModel() )     

END CLASS

//---------------------------------------------------------------------------//

METHOD New()

   ::cTitle                := "Movimientos de almacen"

   ::cImage                := "gc_document_attachment_16"

   ::nLevel                := nLevelUsr( "01050" )

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

   ::oLineasController:oModel:cGeneralSelect := "SELECT * FROM " + ::oLineasController:oModel:getTableName() + ;
                                                   " WHERE parent_uuid = " + quoted( uuid )

RETURN ( Self )

//---------------------------------------------------------------------------//


//---------------------------------------------------------------------------//




