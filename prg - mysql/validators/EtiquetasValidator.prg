#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Hdo.ch"

//---------------------------------------------------------------------------//

CLASS EtiquetasValidator FROM SQLBaseValidator

   METHOD New( oController )
 
END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController )

   ::hValidators  := {  "nombre" => {  "required"     => "El nombre de la etiqueta es un dato requerido",;
                                       "unique"       => "El nombre de la etiqueta ya existe" } } 

   ::Super:New( oController )

RETURN ( Self )

//---------------------------------------------------------------------------//

