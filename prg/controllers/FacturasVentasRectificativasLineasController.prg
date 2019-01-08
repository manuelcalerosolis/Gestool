#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS FacturasVentasRectificativasLineasController FROM OperacionesComercialesLineasController

   METHOD New() CONSTRUCTOR

   METHOD End()


   //Contrucciones tardias---------------------------------------------------//

   METHOD getModel()                   INLINE ( iif( empty( ::oModel ), ::oModel := SQLFacturasVentasRectificativasLineasModel():New( self ), ), ::oModel )


END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS FacturasVentasRectificativasLineasController

   ::Super:New( oController )

   ::cTitle                            := "Facturas rectificativa ventas líneas"

   ::cName                             := "lineas_facturas_ventas_rectificativas" 

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS FacturasVentasRectificativasLineasController

   if !empty( ::oModel )
      ::oModel():End()
   end if 

RETURN ( ::Super:End() )

//---------------------------------------------------------------------------//

