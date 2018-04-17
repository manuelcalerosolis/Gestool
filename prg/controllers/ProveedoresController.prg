#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS ProveedoresController FROM TercerosController

   METHOD New()

END CLASS

//---------------------------------------------------------------------------//

METHOD New() CLASS ProveedoresController

   ::Super:New()

   ::cTitle                      := "Proveedores"

   ::cName                       := "proveedores"

   ::hImage                      := {  "16" => "gc_businessman_16",;
                                       "32" => "gc_businessman_32",;
                                       "48" => "gc_businessman_48" }

   ::oModel                      := SQLProveedoresModel():New( self )

RETURN ( Self )

//---------------------------------------------------------------------------//