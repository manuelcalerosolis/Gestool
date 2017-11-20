#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Hdo.ch"

//---------------------------------------------------------------------------//

CLASS MovimientosAlmacenLineasValidator FROM SQLBaseValidator

   METHOD getValidators()

   METHOD isCodeGS128( value )
   METHOD existArticulo( value )                   INLINE ( empty( value ) .or. ArticulosModel():exist( value ) )

   METHOD existPropiedad( value, propiedad )
   METHOD existOrEmptyPrimeraPropiedad( value )    INLINE ( ::existPropiedad( value, "codigo_primera_propiedad" ) )
   METHOD existOrEmptySegundaPropiedad( value )    INLINE ( ::existPropiedad( value, "codigo_segunda_propiedad" ) )
 
END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators()

   ::hValidators  := {  "codigo_articulo"          => {  "required"              => "El art�culo es un dato requerido",;
                                                         "isCodeGS128"           => "",;
                                                         "existArticulo"         => "El art�culo {value}, no existe" },;
                        "nombre_articulo"          => {  "required"              => "El nombre del art�culo es un dato requerido" },;
                        "valor_primera_propiedad"  => {  "existOrEmptyPrimeraPropiedad" => "La primera propiedad no existe" },;
                        "valor_segunda_propiedad"  => {  "existOrEmptySegundaPropiedad" => "La segunda propiedad no existe" } }

RETURN ( ::hValidators )

//---------------------------------------------------------------------------//

METHOD isCodeGS128( value )

   local hCodeGS128

   hCodeGS128  := ReadCodeGS128( value )

   if empty( hCodeGS128 )
      RETURN ( .t. )
   end if 

   if hhaskey( hCodeGS128, "01" )
      ::oController:setModelBufferPadr( "codigo_articulo", hCodeGS128[ "01" ][ "Codigo" ] )
      ::oController:oDialogView:oGetCodigoArticulo:Refresh()
   end if 

   if hhaskey( hCodeGS128, "10" )
      ::oController:setModelBufferPadr( "lote", hCodeGS128[ "10" ][ "Codigo" ] )
      ::oController:oDialogView:oGetLote:Refresh()
   end if 

   if hhaskey( hCodeGS128, "15" )
      ::oController:setModelBuffer( "fecha_caducidad", hCodeGS128[ "15" ][ "Codigo" ] )
      ::oController:oDialogView:oGetCaducidad:Refresh()
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

