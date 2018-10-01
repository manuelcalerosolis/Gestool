#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS ProveedoresController FROM TercerosController

   METHOD New() CONSTRUCTOR

END CLASS

//---------------------------------------------------------------------------//

METHOD New() CLASS ProveedoresController

   ::cTitle                      := "Proveedores"

   ::cMessage                    := "Proveedor"

   ::cName                       := "proveedores"

   ::isClient                    := .f.

   ::hImage                      := {  "16" => "gc_businessman_16",;
                                       "32" => "gc_businessman_32",;
                                       "48" => "gc_businessman_48" }

   ::oModel                      := SQLProveedoresModel():New( self )

   ::Super:New()

RETURN ( Self )

//---------------------------------------------------------------------------//


