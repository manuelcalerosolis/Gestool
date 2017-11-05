#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Hdo.ch"

//---------------------------------------------------------------------------//

CLASS TiposNotasValidator FROM SQLBaseValidator

   METHOD getValidators()

   METHOD getAsserts()
 
END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators()

   ::hValidators  := {  "nombre" => {  "required"     => "El nombre de la nota es un dato requerido",;
                                       "unique"       => "El nombre de la nota ya existe" } } 

RETURN ( ::hValidators )

//---------------------------------------------------------------------------//

METHOD getAsserts()

   ::hAsserts     := {  "id"     => {  "emptyOrExist" => "El identificador de la nota no existe" },;
                        "nombre" => {  "emptyOrExist" => "El nombre de la nota no existe" } } 

RETURN ( ::hAsserts )

//---------------------------------------------------------------------------//

