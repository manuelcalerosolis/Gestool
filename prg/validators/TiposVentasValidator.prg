#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS TiposVentasValidator FROM SQLBaseValidator

   METHOD getValidators()

   METHOD getAsserts()
 
END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators()

   ::hValidators  := {  "nombre" => {  "required"     => "El nombre de la venta es un dato requerido",;
                                       "unique"       => "El nombre de la venta ya existe" } } 

RETURN ( ::hValidators )

//---------------------------------------------------------------------------//

METHOD getAsserts()

   ::hAsserts     := {  "id"     => {  "emptyOrExist" => "El identificador de la venta no existe" },;
                        "nombre" => {  "emptyOrExist" => "El nombre de la venta no existe" } } 

RETURN ( ::hAsserts )

//---------------------------------------------------------------------------//
