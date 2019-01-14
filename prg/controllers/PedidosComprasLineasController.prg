#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS PedidosComprasLineasController FROM OperacionesComercialesLineasController

   METHOD New() CONSTRUCTOR

   METHOD End()

   //Contrucciones tardias---------------------------------------------------//

   METHOD getModel()                   INLINE ( iif( empty( ::oModel ), ::oModel := SQLPedidosComprasLineasModel():New( self ), ), ::oModel )


END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS PedidosComprasLineasController

   ::Super:New( oController )

   ::cTitle                            := "Facturas compra líneas"

   ::cName                             := "lineas_facturas_compra" 

RETURN ( Self ) 

//---------------------------------------------------------------------------//

METHOD End() CLASS PedidosComprasLineasController

   if !empty( ::oModel )
      ::oModel():End()
   end if 

RETURN ( ::Super:End() )

//---------------------------------------------------------------------------//




