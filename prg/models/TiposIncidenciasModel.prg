#include "fivewin.ch"
#include "factu.ch" 
#include "hdo.ch"

//---------------------------------------------------------------------------//

CLASS TiposIncidenciasModel FROM SQLBaseEmpresasModel

   DATA cTableName                        INIT "tipos_incidencias"

   DATA cDbfTableName

   DATA hColumns

   METHOD New()

   METHOD arrayTiposIncidencias()

   METHOD existTiposIncidencias( cValue )


END CLASS

//---------------------------------------------------------------------------//

METHOD New()

   ::cTableName                  := "tipos_incidencias"

   ::cDbfTableName				 	:= "TIPINCI"

   ::hColumns                   	:= {  "id"                 => {  "create"    => "INTEGER PRIMARY KEY AUTOINCREMENT"          ,;
                                                                  "text"		=> "Identificador"                              ,;
   															                  "dbfField" 	=> "" }                                         ,;
                                       "nombre_incidencia"  => {  "create"    => "VARCHAR (50) NOT NULL"                      ,;
                                                                  "text"      => "Nombre de la incidencia"                    ,;
                                                                  "dbfField"  => "CNOMINCI"}                                  ,;
                                       "empresa"            => {  "create"    => "CHAR ( 4 )"                                 ,;
                                                                  "text"      => "Empresa a la que pertenece la etiqueta"     ,;
                                                                  "dbfField"  => "" }                                         }

   ::Super:New()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD arrayTiposIncidencias()

   local cSentence               := "SELECT nombre_incidencia FROM " + ::cTableName
   local aSelect                 := ::selectFetchArray( cSentence ) 

RETURN ( aSelect )

//---------------------------------------------------------------------------//

METHOD existTiposIncidencias( cValue )

   local cSentence               := "SELECT nombre_incidencia FROM " + ::cTableName + " WHERE nombre_incidencia = " + quoted( cValue )
   local aSelect                 := ::selectFetchArray( cSentence )

RETURN ( !empty( aSelect ) )

//---------------------------------------------------------------------------//
