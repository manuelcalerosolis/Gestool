#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Hdo.ch"

//---------------------------------------------------------------------------//

CLASS MovimientosAlmacenLineasValidator FROM SQLBaseValidator

   METHOD New( oController )

   METHOD existArticulo( value )                   INLINE ( ArticulosModel():exist( value ) )

   METHOD existPropiedad( value, propiedad )
   METHOD existOrEmptyPrimeraPropiedad( value )    INLINE ( ::existPropiedad( value, "codigo_primera_propiedad" ) )
   METHOD existOrEmptySegundaPropiedad( value )    INLINE ( ::existPropiedad( value, "codigo_segunda_propiedad" ) )
 
END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController )

   ::hValidators  := {  "codigo_articulo"          => {  "existArticulo"         => "El artículo no existe",;
                                                         "required"              => "El artículo es un dato requerido" },;
                        "nombre_articulo"          => {  "required"              => "El nombre del artículo es un dato requerido" },;
                        "valor_primera_propiedad"  => {  "existOrEmptyPrimeraPropiedad" => "La primera propiedad no existe" },;
                        "valor_segunda_propiedad"  => {  "existOrEmptySegundaPropiedad" => "La segunda propiedad no existe" } }

   ::Super:New( oController )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD existPropiedad( value, propiedad )

   if empty( value )
      RETURN ( .t. )
   end if

   if empty( ::oController )
      RETURN ( .t. )
   end if

   if empty( ::oController:getModelBuffer( propiedad ) )
      RETURN ( .t. )
   end if

RETURN ( PropiedadesLineasModel():exist( ::oController:getModelBuffer( propiedad ), value ) )

//---------------------------------------------------------------------------//

