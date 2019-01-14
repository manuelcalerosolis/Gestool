#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS PresupuestosComprasDescuentosController FROM OperacionesComercialesDescuentosController

   METHOD New() CONSTRUCTOR

   METHOD End()  

   //Construcciones tardias----------------------------------------------------

   METHOD getModel()                   INLINE ( if( empty( ::oModel ), ::oModel := SQLPresupuestosComprasDescuentosModel():New( self ), ), ::oModel )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS PresupuestosComprasDescuentosController

   ::Super:New( oController )

   ::cTitle                            := "Presupuestos proveedores descuentos"

   ::cName                             := "presupuestos_proveedores_descuentos"

   ::hImage                            := {  "16" => "gc_symbol_percent_16",;
                                             "32" => "gc_symbol_percent_32",;
                                             "48" => "gc_symbol_percent_48" }

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS PresupuestosComprasDescuentosController

   if !empty( ::oModel )
      ::oModel:End()
   end if 

RETURN ( ::Super:End() )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLPresupuestosComprasDescuentosModel FROM SQLOperacionesComercialesDescuentosModel

   DATA cTableName               INIT "presupuestos_compras_descuentos"

   DATA cOrderBy                 INIT "presupuestos_compras_descuentos.id"
   
END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//