#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Hdo.ch"

//---------------------------------------------------------------------------//

CLASS OperacionesLineasValidator FROM SQLBaseValidator

   METHOD getValidators()

   METHOD existCodigoArticulo( value )                   

END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS OperacionesLineasValidator

   ::hValidators  := {  "articulo_codigo"    => {  "required"              => "El artículo es un dato requerido",;
                                                   "existCodigoArticulo"   => "El artículo {value}, no existe" },;
                        "articulo_nombre"    => {  "required"              => "El nombre del artículo es un dato requerido" } }

RETURN ( ::hValidators )

//---------------------------------------------------------------------------//

METHOD existCodigoArticulo( value ) CLASS OperacionesLineasValidator

   if empty( value )
      RETURN ( .t. )
   end if 

RETURN ( !empty( SQLArticulosModel():getCodigoWhereCodigo( value ) ) )

//---------------------------------------------------------------------------//
 

