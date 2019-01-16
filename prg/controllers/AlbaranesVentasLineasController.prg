#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS AlbaranesVentasLineasController FROM OperacionesComercialesLineasController

   METHOD New() CONSTRUCTOR

   METHOD End()

   //Contrucciones tardias---------------------------------------------------//

   METHOD getModel()                   INLINE ( iif( empty( ::oModel ), ::oModel := SQLAlbaranesVentasLineasModel():New( self ), ), ::oModel )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController )

   ::Super:New( oController )

   ::cTitle                            := "Facturas ventas l�neas"

   ::cName                             := "lineas_facturas_ventas" 

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End()

   if !empty( ::oModel )
      ::oModel():End()
   end if 

RETURN ( ::Super:End() )

//---------------------------------------------------------------------------//

