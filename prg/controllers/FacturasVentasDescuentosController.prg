#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS FacturasVentasDescuentosController FROM OperacionesComercialesDescuentosController

   METHOD New() CONSTRUCTOR

   METHOD End()

   //Construcciones tardias----------------------------------------------------

   METHOD getModel()                      INLINE ( if( empty( ::oModel ), ::oModel := SQLFacturasVentasDescuentosModel():New( self ), ), ::oModel )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS FacturasVentasDescuentosController

   ::Super:New( oController )

   ::cTitle                      := "Facturas clientes descuentos"

   ::cName                       := "facturas_clientes_descuentos"

   ::hImage                      := {  "16" => "gc_symbol_percent_16",;
                                       "32" => "gc_symbol_percent_32",;
                                       "48" => "gc_symbol_percent_48" }

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS FacturasVentasDescuentosController

   if !empty( ::oModel )
      ::oModel:End()
   end if 

RETURN ( ::Super:End() )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLFacturasVentasDescuentosModel FROM SQLOperacionesComercialesDescuentosModel

   DATA cTableName               INIT "facturas_ventas_descuentos"

   DATA cOrderBy                 INIT "facturas_ventas_descuentos.id"
   
END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//