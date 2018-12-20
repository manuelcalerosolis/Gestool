#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS FacturasProveedoresLineasController FROM OperacionesComercialesLineasController

   METHOD New() CONSTRUCTOR

   METHOD End()

   //Contrucciones tardias---------------------------------------------------//

   METHOD getModel()                   INLINE ( iif( empty( ::oModel ), ::oModel := SQLFacturasProveedoresLineasModel():New( self ), ), ::oModel )


END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS FacturasProveedoresLineasController

   ::Super:New( oController )

   ::cTitle                            := "Facturas proveedores líneas"

   ::cName                             := "lineas_facturas_proveedores" 

RETURN ( Self ) 

//---------------------------------------------------------------------------//

METHOD End() CLASS FacturasProveedoresLineasController

   if !empty( ::oModel )
      ::oModel():End()
   end if 

RETURN ( ::Super:End() )

//---------------------------------------------------------------------------//




