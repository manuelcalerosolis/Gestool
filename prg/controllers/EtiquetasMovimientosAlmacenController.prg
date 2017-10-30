#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS EtiquetasMovimientosAlmacenController FROM SQLBaseController

   METHOD New( oController )

   METHOD Activate()    INLINE ( ::oDialogView:Activate() )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController )

   ::cTitle             := "Etiquetas movimientos almacen lineas"

   ::oDialogView        := EtiquetasMovimientosAlmacenView():New( self )

   ::Super:New( oController )

RETURN ( Self )

//---------------------------------------------------------------------------//

