#include "FiveWin.Ch"
#include "Factu.ch" 

CLASS ClientesValidator FROM SQLBaseValidator

   METHOD getValidators()
 
END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS ClientesValidator

   ::hValidators  := {  "codigo" =>          {  "required"           => "El código del cliente es un dato requerido"  ,;
                                                "unique"             => "EL código introducido ya existe" } ,; 
                        "nombre" =>          {  "required"           => "El nombre del cliente es un dato requerido" }  }

RETURN ( ::hValidators )

//---------------------------------------------------------------------------//