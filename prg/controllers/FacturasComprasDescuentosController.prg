#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS FacturasComprasDescuentosController FROM OperacionesComercialesDescuentosController

   METHOD New() CONSTRUCTOR

   METHOD End()  

   //Construcciones tardias----------------------------------------------------

   METHOD getModel()                   INLINE ( if( empty( ::oModel ), ::oModel := SQLFacturasComprasDescuentosModel():New( self ), ), ::oModel )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS FacturasComprasDescuentosController

   ::Super:New( oController )

   ::cTitle                            := "Facturas proveedores descuentos"

   ::cName                             := "facturas_proveedores_descuentos"

   ::hImage                            := {  "16" => "gc_symbol_percent_16",;
                                             "32" => "gc_symbol_percent_32",;
                                             "48" => "gc_symbol_percent_48" }

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS FacturasComprasDescuentosController

   if !empty( ::oModel )
      ::oModel:End()
   end if 

RETURN ( ::Super:End() )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLFacturasComprasDescuentosModel FROM SQLOperacionesComercialesDescuentosModel

   DATA cTableName               INIT "facturas_compras_descuentos"

   DATA cOrderBy                 INIT "facturas_compras_descuentos.id"
   
END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//