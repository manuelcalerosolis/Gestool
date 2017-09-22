#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Hdo.ch"

//---------------------------------------------------------------------------//

CLASS TiposVentasValidator FROM SQLBaseValidator

   METHOD New( oController )
 
END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController )

   ::hValidators  := {  "codigo" => {  "required"  => "El c�digo de la venta es un dato requerido",;
                                       "unique"    => "El c�digo de la venta ya existe" },;
                        "nombre" => {  "required"  => "El nombre de la venta es un dato requerido",;
                                       "unique"    => "El nombre de la venta ya existe" } } 

   ::Super:New( oController )

RETURN ( Self )

//---------------------------------------------------------------------------//

