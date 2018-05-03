#include "FiveWin.Ch"
#include "Factu.ch" 

CLASS ClientesValidator FROM SQLCompanyValidator

   METHOD getValidators()
 
END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS ClientesValidator

   ::hValidators  := {  "codigo" =>          {  "required"           => "El código del cliente es un dato requerido"  } ,;  
                        "nombre" =>          {  "required"           => "El nombre del cliente es un dato requerido" }  }

RETURN ( ::hValidators )

//---------------------------------------------------------------------------//