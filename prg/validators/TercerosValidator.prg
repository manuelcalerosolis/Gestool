#include "FiveWin.Ch"
#include "Factu.ch" 

CLASS TercerosValidator FROM SQLBaseValidator

   METHOD getValidators()
 
END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS TercerosValidator

   ::hValidators  := {  "codigo" =>          {  "required"           => "El c�digo es un dato requerido"  ,;
                                                "unique"             => "EL c�digo introducido ya existe" } ,; 
                        "nombre" =>          {  "required"           => "El nombre es un dato requerido" }  }

RETURN ( ::hValidators )

//---------------------------------------------------------------------------//