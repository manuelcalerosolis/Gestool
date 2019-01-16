#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS AlbaranesComprasLineasController FROM OperacionesComercialesLineasController

   METHOD New() CONSTRUCTOR

   METHOD End()

   //Contrucciones tardias---------------------------------------------------//

   METHOD getModel()                   INLINE ( iif( empty( ::oModel ), ::oModel := SQLAlbaranesComprasLineasModel():New( self ), ), ::oModel )


END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS AlbaranesComprasLineasController

   ::Super:New( oController )

   ::cTitle                            := "Albaranes compra líneas"

   ::cName                             := "lineas_albaranes_compra" 

RETURN ( Self ) 

//---------------------------------------------------------------------------//

METHOD End() CLASS AlbaranesComprasLineasController

   if !empty( ::oModel )
      ::oModel():End()
   end if 

RETURN ( ::Super:End() )

//---------------------------------------------------------------------------//




