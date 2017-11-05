#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Hdo.ch"

//---------------------------------------------------------------------------//

CLASS TiposImpresorasValidator FROM SQLBaseValidator

   METHOD getValidators()
 
END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators()

   ::hValidators  := { "nombre" =>  {  "required"  => "El nombre de la impresora es un dato requerido",;
                                       "unique"    => "El nombre de la impresora ya existe" } } 

RETURN ( ::hValidators )

//---------------------------------------------------------------------------//

