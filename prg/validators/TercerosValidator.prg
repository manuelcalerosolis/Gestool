#include "FiveWin.Ch"
#include "Factu.ch" 

CLASS TercerosValidator FROM SQLBaseValidator

   METHOD getValidators()
 
END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS TercerosValidator

   ::hValidators  := {  "codigo" =>          {  "required"           => "El código es un dato requerido"  ,;
                                                "unique"             => "EL código introducido ya existe" } ,; 
                        "nombre" =>          {  "required"           => "El nombre es un dato requerido" }  }

RETURN ( ::hValidators )

//---------------------------------------------------------------------------//