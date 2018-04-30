#include "FiveWin.Ch"
#include "Factu.ch" 

CLASS ClientesValidator FROM SQLBaseValidator

   METHOD getValidators()
 
END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS ClientesValidator

   ::hValidators  := {  "codigo" =>          {  "required"           => "El código del cliente es un dato requerido" ,;
                                                "onlyAlphanumeric"   => "EL código no puede contener caracteres especiales" } ,;  
                        "nombre" =>          {  "required"           => "El nombre del cliente es un dato requerido" }  }

RETURN ( ::hValidators )

//---------------------------------------------------------------------------//