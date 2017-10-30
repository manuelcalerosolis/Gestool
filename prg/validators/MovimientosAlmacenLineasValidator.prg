#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Hdo.ch"

//---------------------------------------------------------------------------//

CLASS MovimientosAlmacenLineasValidator FROM SQLBaseValidator

   METHOD New( oController )

   METHOD isCodeGS128( value )
   METHOD existArticulo( value )                   INLINE ( empty( value ) .or. ArticulosModel():exist( value ) )

   METHOD existPropiedad( value, propiedad )
   METHOD existOrEmptyPrimeraPropiedad( value )    INLINE ( ::existPropiedad( value, "codigo_primera_propiedad" ) )
   METHOD existOrEmptySegundaPropiedad( value )    INLINE ( ::existPropiedad( value, "codigo_segunda_propiedad" ) )
 
END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController )

   ::hValidators  := {  "codigo_articulo"          => {  "required"              => "El artículo es un dato requerido",;
                                                         "isCodeGS128"           => "",;
                                                         "existArticulo"         => "El artículo {value} no existe" },;
                        "nombre_articulo"          => {  "required"              => "El nombre del artículo es un dato requerido" },;
                        "valor_primera_propiedad"  => {  "existOrEmptyPrimeraPropiedad" => "La primera propiedad no existe" },;
                        "valor_segunda_propiedad"  => {  "existOrEmptySegundaPropiedad" => "La segunda propiedad no existe" } }

   ::Super:New( oController )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD isCodeGS128( value )

   local hCodeGS128  := ReadCodeGS128( value )

   logwrite( "value" )
   logwrite( value )
   
   if empty( hCodeGS128 )
      RETURN ( .t. )
   end if 

   logwrite( "hCodeGS128" )
   logwrite( hb_valtoexp( hCodeGS128 ) )

   if hhaskey( hCodeGS128, "01" )
      ::oController:setModelBuffer( "codigo_articulo", hCodeGS128[ "01" ][ "Codigo" ] )
      msgalert( ::oController:getModelBuffer( "codigo_articulo" ), "getModelBuffer codigo_articulo" )
   end if 

   if hhaskey( hCodeGS128, "10" )
      ::oController:setModelBuffer( "lote", hCodeGS128[ "10" ][ "Codigo" ] )

      msgalert( hCodeGS128[ "10" ][ "Codigo" ], "10" )

   end if 

   if hhaskey( hCodeGS128, "17" )
      ::oController:setModelBuffer( "fecha_caducidad", hCodeGS128[ "17" ][ "Codigo" ] )
   end if 

RETURN ( .t. )

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

