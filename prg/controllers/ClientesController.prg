#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS ClientesController FROM TercerosController

   METHOD New() CONSTRUCTOR

   METHOD End()

   METHOD validColumnAgentesBrowse( uValue, nKey ) ;
                                       INLINE ( ::validColumnBrowse( uValue, nKey, ::getAgentesController():oModel, "agente_uuid" ) )

   METHOD getModel()                   INLINE ( iif( empty( ::oModel ), ::oModel := SQLTercerosModel():New( self ), ), ::oModel )

   METHOD getSelector()                INLINE ( if( empty( ::oGetSelector ), ::oGetSelector := TerceroGetSelector():New( self ), ), ::oGetSelector )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS ClientesController

   ::cTitle                            := "Clientes"

   ::cMessage                          := "Cliente"

   ::cName                             := "clientes_sql"

   ::isClient                          := .t.

   ::hImage                            := {  "16" => "gc_user_16",;
                                             "32" => "gc_user_32",;
                                             "48" => "gc_user2_48" }

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS ClientesController

   if !empty( ::oModel )
      ::oModel:End()
   end if 

RETURN ( ::Super:End() )

//---------------------------------------------------------------------------//

