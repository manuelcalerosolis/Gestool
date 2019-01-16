#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS FacturasSimplificadasVentasDescuentosController FROM OperacionesComercialesDescuentosController

   METHOD New() CONSTRUCTOR

   METHOD End()

   METHOD getModel()                   INLINE ( if( empty( ::oModel ), ::oModel := SQLFacturasSimplificadasVentasDescuentosModel():New( self ), ), ::oModel )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS FacturasSimplificadasVentasDescuentosController

   ::Super:New( oController )

   ::cTitle                            := "Facturas simplificadas ventas descuentos"

   ::cName                             := "facturas_simplificadas_ventas_descuentos"

   ::hImage                            := {  "16" => "gc_symbol_percent_16",;
                                             "32" => "gc_symbol_percent_32",;
                                             "48" => "gc_symbol_percent_48" }

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS FacturasSimplificadasVentasDescuentosController

   if !empty( ::oModel )
      ::oModel:End()
   end if 

RETURN ( ::Super:End() )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLFacturasSimplificadasVentasDescuentosModel FROM SQLOperacionesComercialesDescuentosModel

   DATA cTableName                     INIT "facturas_simplificadas_ventas_descuentos"

   DATA cOrderBy                       INIT "facturas_simplificadas_ventas_descuentos.id"
   
END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//