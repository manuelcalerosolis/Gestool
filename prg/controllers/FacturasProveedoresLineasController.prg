#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS FacturasProveedoresLineasController FROM OperacionesComercialesLineasController

   METHOD New() CONSTRUCTOR

   METHOD End()

   METHOD stampArticuloUnidadMedicion( uValue )

   METHOD stampArticuloUnidadMedicionFactor()   

   //Contrucciones tardias---------------------------------------------------//

   METHOD getModel()                   INLINE ( iif( empty( ::oModel ), ::oModel := SQLFacturasProveedoresLineasModel():New( self ), ), ::oModel )


END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController )

   ::Super:New( oController )

   ::cTitle                            := "Facturas proveedores líneas"

   ::cName                             := "lineas_facturas_proveedores" 

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

/*METHOD stampArticuloUnidadMedicionFactor()
      
   local nFactor  := UnidadesMedicionGruposLineasRepository():getFactorWhereUnidadMedicion( ::getRowSet():fieldGet( 'articulo_codigo' ), ::getRowSet():fieldGet( 'unidad_medicion_codigo' ) ) 

   if nFactor > 0
      ::updateField( 'unidad_medicion_factor', nFactor )
      ::stampArticuloDescuento()
   end if 

RETURN ( nil )*/

//----------------------------------------------------------------------------//





