#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Hdo.ch"

//---------------------------------------------------------------------------//

CLASS TiposImpresorasValidator FROM SQLBaseValidator

   METHOD New( oController )
 
END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController )

   ::hValidators  := { "nombre" =>  {  "required"  => "El nombre de la impresora es un dato requerido",;
                                       "unique"    => "El nombre de la impresora ya existe" } } 

   ::Super:New( oController )

RETURN ( Self )

//---------------------------------------------------------------------------//

