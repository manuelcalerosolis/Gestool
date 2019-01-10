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

   ::hValidators  := {  "articulo_codigo"    => {  "required"              => "El art�culo es un dato requerido",;
                                                   "existCodigoArticulo"   => "El art�culo {value}, no existe" },;
                        "articulo_nombre"    => {  "required"              => "El nombre del art�culo es un dato requerido" } }

RETURN ( ::hValidators )

//---------------------------------------------------------------------------//

METHOD existCodigoArticulo( value ) CLASS OperacionesLineasValidator

   if empty( value )
      RETURN ( .t. )
   end if 

RETURN ( !empty( SQLArticulosModel():getCodigoWhereCodigo( value ) ) )

//---------------------------------------------------------------------------//
 

