#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS MovimientosAlmacenController FROM SQLBaseController

   DATA oLineasController

   METHOD New()

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

   ::setEvent( 'openingDialog',   {|| ::oLineasController:oModel:buildRowSet() } ) 
   ::setEvent( 'closedDialog',    {|| ::oLineasController:oModel:freeRowSet() } ) 

RETURN ( Self )

//---------------------------------------------------------------------------//

