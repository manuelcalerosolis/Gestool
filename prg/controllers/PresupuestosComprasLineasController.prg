#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS PresupuestosComprasLineasController FROM OperacionesComercialesLineasController

   METHOD New() CONSTRUCTOR

   METHOD End()

   //Contrucciones tardias---------------------------------------------------//

   METHOD getModel()                   INLINE ( iif( empty( ::oModel ), ::oModel := SQLPresupuestosComprasLineasModel():New( self ), ), ::oModel )


END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS PresupuestosComprasLineasController

   ::Super:New( oController )

   ::cTitle                            := "Presupuestos compra líneas"

   ::cName                             := "lineas_presupuestos_compra" 

RETURN ( Self ) 

//---------------------------------------------------------------------------//

METHOD End() CLASS PresupuestosComprasLineasController

   if !empty( ::oModel )
      ::oModel():End()
   end if 

RETURN ( ::Super:End() )

//---------------------------------------------------------------------------//




