#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS FacturasVentasSimplificadasLineasController FROM OperacionesComercialesLineasController

   METHOD New() CONSTRUCTOR

   METHOD End()

   //Contrucciones tardias---------------------------------------------------//

   METHOD getModel()                   INLINE ( iif( empty( ::oModel ), ::oModel := SQLFacturasVentasSimplificadasLineasModel():New( self ), ), ::oModel )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS FacturasVentasSimplificadasLineasController

   ::Super:New( oController )

   ::cTitle                            := "Facturas simplificadas ventas líneas"

   ::cName                             := "lineas_facturas_ventas_simplificadas" 

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS FacturasVentasSimplificadasLineasController

   if !empty( ::oModel )
      ::oModel():End()
   end if 

RETURN ( ::Super:End() )

//---------------------------------------------------------------------------//

