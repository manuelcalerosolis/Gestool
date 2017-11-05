#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Hdo.ch"

//---------------------------------------------------------------------------//

CLASS EtiquetasValidator FROM SQLBaseValidator

   METHOD getValidators()  
 
END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators()

   ::hValidators  := {  "nombre" => {  "required"     => "El nombre de la etiqueta es un dato requerido",;
                                       "unique"       => "El nombre de la etiqueta ya existe" } } 

RETURN ( ::hValidators )

//---------------------------------------------------------------------------//

