#include "FiveWin.Ch"
#include "Factu.ch" 

CLASS TercerosValidator FROM SQLBaseValidator

   METHOD getValidators()
 
END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS TercerosValidator

   ::hValidators  := {  "codigo" =>          {  "required"           => "El código del cliente es un dato requerido"  ,;
                                                "unique"             => "EL código introducido ya existe" } ,; 
                        "nombre" =>          {  "required"           => "El nombre del cliente es un dato requerido" }  }

RETURN ( ::hValidators )

//---------------------------------------------------------------------------//