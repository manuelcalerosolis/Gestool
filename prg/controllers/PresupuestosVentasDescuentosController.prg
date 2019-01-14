#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS PresupuestosVentasDescuentosController FROM OperacionesComercialesDescuentosController

   METHOD New() CONSTRUCTOR

   METHOD End()

   METHOD getModel()                   INLINE ( if( empty( ::oModel ), ::oModel := SQLPresupuestosVentasDescuentosModel():New( self ), ), ::oModel )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS PresupuestosVentasDescuentosController

   ::Super:New( oController )

   ::cTitle                            := "Facturas ventas descuentos"

   ::cName                             := "facturas_ventas_descuentos"

   ::hImage                            := {  "16" => "gc_symbol_percent_16",;
                                             "32" => "gc_symbol_percent_32",;
                                             "48" => "gc_symbol_percent_48" }

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS PresupuestosVentasDescuentosController

   if !empty( ::oModel )
      ::oModel:End()
   end if 

RETURN ( ::Super:End() )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLPresupuestosVentasDescuentosModel FROM SQLOperacionesComercialesDescuentosModel

   DATA cTableName                     INIT "presupuestos_ventas_descuentos"

   DATA cOrderBy                       INIT "presupuestos_ventas_descuentos.id"
   
END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//