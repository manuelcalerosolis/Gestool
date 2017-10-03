#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS MovimientosAlmacenLineasController FROM SQLBaseController

   METHOD   New()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController )

   ::cTitle                := "Movimientos de almacen lineas"

   ::cImage                := "gc_document_attachment_16"

   ::nLevel                := nLevelUsr( "01050" )

   ::oModel                := SQLMovimientosAlmacenLineasModel():New( self )

   // ::oDialogView           := MovimientosAlmacenLineasView():New( self )

   // ::oValidator            := MovimientosAlmacenLineasValidator():New( self )

   ::Super:New( oController )

RETURN ( Self )

//---------------------------------------------------------------------------//




