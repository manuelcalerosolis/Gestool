#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Hdo.ch"

//---------------------------------------------------------------------------//

CLASS TiposVentasValidator FROM SQLBaseValidator

   METHOD New( oController )
 
END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController )

   ::hValidators  := {  "nombre" => {  "required"     => "El nombre de la venta es un dato requerido",;
                                       "unique"       => "El nombre de la venta ya existe" } } 

   ::hAsserts     := {  "id"     => {  "emptyOrExist" => "El identificador de la venta no existe" },;
                        "nombre" => {  "emptyOrExist" => "El nombre de la venta no existe" } } 

   ::Super:New( oController )

RETURN ( Self )

//---------------------------------------------------------------------------//

