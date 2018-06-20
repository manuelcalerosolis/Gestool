#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Hdo.ch"

//---------------------------------------------------------------------------//

CLASS FacturasClientesLineasValidator FROM SQLBaseValidator

   METHOD getValidators()

   METHOD isCodeGS128( value )
   METHOD existArticulo( value )                   

   METHOD existPropiedad( value, propiedad )
   METHOD existOrEmptyPrimeraPropiedad( value )    INLINE ( ::existPropiedad( value, "codigo_primera_propiedad" ) )
   METHOD existOrEmptySegundaPropiedad( value )    INLINE ( ::existPropiedad( value, "codigo_segunda_propiedad" ) )

   METHOD existUnidadMedicion( value )
 
END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators()

   ::hValidators  := {  "codigo_articulo"          => {  "isCodeGS128"           => "",;
                                                         "required"              => "El artículo es un dato requerido",;
                                                         "existArticulo"         => "El artículo {value}, no existe" },;
                        "nombre_articulo"          => {  "required"              => "El nombre del artículo es un dato requerido" },;
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

METHOD existArticulo( value )

   local cId

   if empty( value )
      RETURN ( .t. )
   end if 

   if ArticulosModel():exist( value )
      RETURN ( .t. )
   end if 

   cId                     := ArticulosCodigosBarraModel():getCodigo( value )

   if !empty( cId )
      ::oController:setModelBufferPadr( "codigo_articulo", cId )
      ::oController:oDialogView:oGetCodigoArticulo:Refresh()
      RETURN ( .t. )
   end if 

RETURN ( .f. )

//---------------------------------------------------------------------------//

METHOD existUnidadMedicion( value )

   local cId

   MsgInfo( "Entro en existUnidadMedicion", value )

   if empty( value )
      RETURN ( .t. )
   end if 

   //***************************POR AQUI PARA VIENDOLO**********************//

   if ArticulosModel():exist( value )
      RETURN ( .t. )
   end if 
   
RETURN ( .f. )

//---------------------------------------------------------------------------//