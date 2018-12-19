#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS ProveedoresController FROM TercerosController

   METHOD New() CONSTRUCTOR

   //Consrucciones tardias-----------------------------------------------------

   METHOD getModel()                   INLINE (  if( empty( ::oModel ), ::oModel := SQLProveedoresModel():New( self ), ), ::oModel )

   METHOD getSelector()                INLINE ( if( empty( ::oGetSelector ), ::oGetSelector := ProveedorGetSelector():New( self ), ), ::oGetSelector )

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

   ::Super:New()

RETURN ( Self )

//---------------------------------------------------------------------------//


