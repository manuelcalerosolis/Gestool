#include "fivewin.ch"
#include "factu.ch" 
#include "hdo.ch"

//---------------------------------------------------------------------------//

CLASS TiposIncidenciasModel FROM SQLBaseModel

   DATA cTableName

   DATA cDbfTableName

   DATA hColumns

   METHOD New()

END CLASS

//---------------------------------------------------------------------------//

METHOD New()

   ::cTableName                  := "tipos_incidencias"

   ::cDbfTableName				 	:= "TIPINCI"

   ::hColumns                   	:= {  "id"                 => {  "create"    => "INTEGER PRIMARY KEY AUTOINCREMENT"  ,;
                                                                  "text"		=> "Identificador"                      ,;
   															                  "dbfField" 	=> "" }                                 ,;
                                       "nombre_incidencia"  => {  "create"    => "VARCHAR (50) NOT NULL"              ,;
                                                                  "text"      => "Nombre de la incidencia"            ,;
                                                                  "dbfField"  => "CNOMINCI"}                          }

   ::Super:New()

RETURN ( Self )

//---------------------------------------------------------------------------//
