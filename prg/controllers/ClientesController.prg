#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS ClientesController FROM TercerosController

   METHOD New()

   METHOD End()

   METHOD validColumnAgentesBrowse( uValue, nKey )             INLINE ( ::validColumnBrowse( uValue, nKey, ::getAgentesController():oModel, "agente_uuid" ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oSenderController ) CLASS ClientesController

   ::cTitle                         := "Clientes"

   ::cMessage                       := "Cliente"

   ::cName                          := "clientes_sql"

   ::isClient                       := .t.

   ::hImage                         := {  "16" => "gc_user_16",;
                                          "32" => "gc_user_32",;
                                          "48" => "gc_user2_48" }

   ::oModel                         := SQLClientesModel():New( self )

   ::Super:New( oSenderController )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS ClientesController

RETURN ( nil )


