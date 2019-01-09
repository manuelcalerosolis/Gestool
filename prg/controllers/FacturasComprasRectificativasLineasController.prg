#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS FacturasComprasRectificativasLineasController FROM OperacionesComercialesLineasController

   METHOD New() CONSTRUCTOR

   METHOD End()


   //Contrucciones tardias---------------------------------------------------//

   METHOD getModel()                   INLINE ( iif( empty( ::oModel ), ::oModel := SQLFacturasComprasRectificativasLineasModel():New( self ), ), ::oModel )


END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS FacturasComprasRectificativasLineasController

   ::Super:New( oController )

   ::cTitle                            := "Facturas rectificativa compras líneas"

   ::cName                             := "lineas_facturas_compras_rectificativas" 

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS FacturasComprasRectificativasLineasController

   if !empty( ::oModel )
      ::oModel():End()
   end if 

RETURN ( ::Super:End() )

//---------------------------------------------------------------------------//

