#include "FiveWin.Ch"

//---------------------------------------------------------------------------//

CLASS SQLFiltrosValidator FROM SQLBaseValidator

   METHOD getValidators()
 
END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators()

   ::hValidators  := { "nombre" =>  {  "required"  => "El nombre del filtro es un dato requerido",;
                                       "unique"    => "El nombre del filtro ya existe" },;
                        "filtro" => {  "required"  => "La sentencia es un dato requerido" } } 

RETURN ( ::hValidators )

//---------------------------------------------------------------------------//

