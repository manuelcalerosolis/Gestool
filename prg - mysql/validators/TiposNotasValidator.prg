#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Hdo.ch"

//---------------------------------------------------------------------------//

CLASS TiposNotasValidator FROM SQLBaseValidator

   METHOD New( oController )
 
END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController )

   ::hValidators  := {  "nombre" => {  "required"     => "El nombre de la nota es un dato requerido",;
                                       "unique"       => "El nombre de la nota ya existe" } } 

   ::hAsserts     := {  "id"     => {  "emptyOrExist" => "El identificador de la nota no existe" },;
                        "nombre" => {  "emptyOrExist" => "El nombre de la nota no existe" } } 

   ::Super:New( oController )

RETURN ( Self )

//---------------------------------------------------------------------------//

