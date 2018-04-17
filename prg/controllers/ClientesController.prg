#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS ClientesController FROM TercerosController

   METHOD New()

END CLASS

//---------------------------------------------------------------------------//

METHOD New() CLASS ClientesController

   ::Super:New()

   ::cTitle                      := "Clientes"

   ::cName                       := "clientes"

   ::hImage                      := {  "16" => "gc_user_16",;
                                       "32" => "gc_user_32",;
                                       "48" => "gc_user2_48" }

   ::oModel                      := SQLClientesModel():New( self )

RETURN ( Self )

//---------------------------------------------------------------------------//