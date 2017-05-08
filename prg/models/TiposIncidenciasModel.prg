#include "fivewin.ch"
#include "factu.ch" 
#include "hdo.ch"

//---------------------------------------------------------------------------//

CLASS TiposIncidenciasModel FROM SQLBaseModel

   DATA cTableName

   DATA cDbfTableName

   DATA hColumns

   METHOD New()

   METHOD existTiposIncidencias( cValue )

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

METHOD existTiposIncidencias( cValue )

   local cSentence               := "SELECT nombre_incidencia FROM " + ::cTableName + " WHERE nombre_incidencia = " + quoted( cValue )
   local aSelect                 := ::selectFetchArray( cSentence )

RETURN ( !empty( aSelect ) )

//---------------------------------------------------------------------------//
