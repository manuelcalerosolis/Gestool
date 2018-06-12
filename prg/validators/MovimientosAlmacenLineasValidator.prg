#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Hdo.ch"

//---------------------------------------------------------------------------//

CLASS DocumentosLineasValidator FROM SQLBaseValidator

   METHOD getValidators()

   METHOD isCodeGS128( value )
   METHOD existCodigoArticulo( value )                   

END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators()

   ::hValidators  := {  "articulo_codigo"          => {  "isCodeGS128"           => "",;
                                                         "required"              => "El artículo es un dato requerido",;
                                                         "existCodigoArticulo"   => "El artículo {value}, no existe" },;
                        "articulo_nombre"          => {  "required"              => "El nombre del artículo es un dato requerido" } }

RETURN ( ::hValidators )

//---------------------------------------------------------------------------//

METHOD isCodeGS128( value )

   local hCodeGS128  

   hCodeGS128  := ReadCodeGS128( value )

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

METHOD existCodigoArticulo( value )

   if empty( value )
      RETURN ( .t. )
   end if 

RETURN ( !empty( SQLArticulosModel():getCodigoWhereCodigo( value ) ) )

//---------------------------------------------------------------------------//

