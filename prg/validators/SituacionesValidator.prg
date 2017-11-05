#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Hdo.ch"

//---------------------------------------------------------------------------//

CLASS SituacionesValidator FROM SQLBaseValidator

   METHOD getValidartors()
 
END CLASS

//---------------------------------------------------------------------------//

METHOD getValidartors()

   ::hValidators  := {  "nombre" => {  "required"     => "El nombre de la situaci�n es un dato requerido",;
                                       "unique"       => "El nombre de la situaci�n ya existe" } } 

RETURN ( ::hValidators )

//---------------------------------------------------------------------------//

