#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Hdo.ch"

//---------------------------------------------------------------------------//

CLASS OperacionesComercialesLineasValidator FROM SQLBaseValidator

   METHOD getValidators()

   METHOD isCodeGS128( value )
   METHOD existArticulo( value )                   

   METHOD existOrEmptyPrimeraPropiedad( value )    INLINE ( ::existPropiedad( value, "codigo_primera_propiedad" ) )
   METHOD existOrEmptySegundaPropiedad( value )    INLINE ( ::existPropiedad( value, "codigo_segunda_propiedad" ) )

   METHOD existUnidadMedicion( value )

   METHOD getDialogView()                          INLINE ( ::getController():getController():getDialogView() )
 
END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators()

   ::hValidators  := {  "articulo_codigo"          => {  "isCodeGS128"           => "",;
                                                         "existArticulo"         => "El artículo {value}, no existe" },;
                        "articulo_nombre"          => {  "required"              => "El nombre del artículo es un dato requerido" },;
                        "unidad_medicion_codigo"   => {  "existUnidadMedicion"   => "La unidad de medición no existe" } }

RETURN ( ::hValidators )

//---------------------------------------------------------------------------//

METHOD isCodeGS128( value )

   local hCodeGS128  := ReadCodeGS128( value )

   if empty( hCodeGS128 )
      RETURN ( .t. )
   end if 

   if hhaskey( hCodeGS128, "01" )
      ::setValue( hCodeGS128[ "01" ][ "Codigo" ] )
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

METHOD existArticulo( value )

   if empty( value )
      RETURN ( .t. )
   end if 

   if SQLArticulosModel():isWhereCodigo( value )
      RETURN ( .t. )
   end if 

RETURN ( .f. )

//---------------------------------------------------------------------------//

METHOD existUnidadMedicion( value )

   local cId
   local aValores

   if empty( value )
      RETURN ( .t. )
   end if

   aValores          := UnidadesMedicionGruposLineasRepository():getCodigos( ::oController:getRowSet():fieldGet( 'articulo_codigo' ) )

   if ascan( aValores, alltrim( value ) ) != 0
      RETURN ( .t. )
   end if

RETURN ( .f. )

//---------------------------------------------------------------------------//