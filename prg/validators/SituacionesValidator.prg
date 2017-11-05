#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Hdo.ch"

//---------------------------------------------------------------------------//

CLASS SituacionesValidator FROM SQLBaseValidator

   METHOD getValidartors()
 
END CLASS

//---------------------------------------------------------------------------//

METHOD getValidartors()

   ::hValidators  := {  "nombre" => {  "required"     => "El nombre de la situación es un dato requerido",;
                                       "unique"       => "El nombre de la situación ya existe" } } 

RETURN ( ::hValidators )

//---------------------------------------------------------------------------//

