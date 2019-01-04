#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS FacturasVentasLineasController FROM OperacionesComercialesLineasController

   METHOD New() CONSTRUCTOR

   METHOD End()


   //Contrucciones tardias---------------------------------------------------//

   METHOD getModel()                   INLINE ( iif( empty( ::oModel ), ::oModel := SQLFacturasVentasLineasModel():New( self ), ), ::oModel )


END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController )

   ::Super:New( oController )

   ::cTitle                            := "Facturas ventas líneas"

   ::cName                             := "lineas_facturas_ventas" 

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End()

   if !empty( ::oModel )
      ::oModel():End()
   end if 

RETURN ( ::Super:End() )

//---------------------------------------------------------------------------//

