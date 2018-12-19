#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS FacturasClientesLineasController FROM OperacionesComercialesLineasController

   METHOD New() CONSTRUCTOR

   METHOD End()

   METHOD stampArticuloUnidadMedicion( uValue )

   METHOD stampArticuloUnidadMedicionFactor()   

   //Contrucciones tardias---------------------------------------------------//

   METHOD getModel()                   INLINE ( iif( empty( ::oModel ), ::oModel := SQLFacturasClientesLineasModel():New( self ), ), ::oModel )


END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController )

   ::Super:New( oController )

   ::cTitle                            := "Facturas clientes l�neas"

   ::cName                             := "lineas_facturas_clientes" 

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End()

   if !empty( ::oModel )
      ::oModel():End()
   end if 

RETURN ( ::Super:End() )

//---------------------------------------------------------------------------//

METHOD stampArticuloUnidadMedicion( uValue )

   ::updateField( 'unidad_medicion_codigo', uValue )

   ::stampArticuloUnidadMedicionFactor()

RETURN ( ::oController:calculateTotals() )

//----------------------------------------------------------------------------//

METHOD stampArticuloUnidadMedicionFactor()
      
   local nFactor  := UnidadesMedicionGruposLineasRepository():getFactorWhereUnidadMedicion( ::getRowSet():fieldGet( 'articulo_codigo' ), ::getRowSet():fieldGet( 'unidad_medicion_codigo' ) ) 

   if nFactor > 0
      ::updateField( 'unidad_medicion_factor', nFactor )
      ::stampArticuloDescuento()
   end if 

RETURN ( nil )

//----------------------------------------------------------------------------//





