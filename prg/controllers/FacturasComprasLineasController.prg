#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS FacturasComprasLineasController FROM OperacionesComercialesLineasController

   METHOD New() CONSTRUCTOR

   METHOD End()

   //Contrucciones tardias---------------------------------------------------//

   METHOD getModel()                   INLINE ( iif( empty( ::oModel ), ::oModel := SQLFacturasComprasLineasModel():New( self ), ), ::oModel )


END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS FacturasComprasLineasController

   ::Super:New( oController )

   ::cTitle                            := "Facturas compra líneas"

   ::cName                             := "lineas_facturas_compra" 

RETURN ( Self ) 

//---------------------------------------------------------------------------//

METHOD End() CLASS FacturasComprasLineasController

   if !empty( ::oModel )
      ::oModel():End()
   end if 

RETURN ( ::Super:End() )

//---------------------------------------------------------------------------//




