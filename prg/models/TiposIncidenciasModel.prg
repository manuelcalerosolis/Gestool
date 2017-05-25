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

END CLASS

//---------------------------------------------------------------------------//

METHOD New()

   ::cDbfTableName				 	:= "TipInci"

   ::hColumns                   	:= {  "id"                 => {  "create"    => "INTEGER PRIMARY KEY AUTOINCREMENT"          ,;
                                                                  "text"		=> "Identificador"                              ,;
   															                  "dbfField" 	=> "" }                                         ,;
                                       "codigo"             => {  "create"    => "VARCHAR( 3 )"                               ,;
                                                                  "text"      => "C?igo de identificaci? en DBF"            ,; 
                                                                  "dbfField"  => "cCodInci"}                                  ,;  
                                       "nombre"             => {  "create"    => "VARCHAR (50)"                      ,;
                                                                  "text"      => "Nombre de la incidencia"                    ,;
                                                                  "dbfField"  => "cNomInci"}                                  ,;
                                       "empresa"            => {  "create"    => "CHAR ( 4 )"                                 ,;
                                                                  "text"      => "Empresa a la que pertenece la etiqueta"     ,;
                                                                  "dbfField"  => "" }                                         }

   ::Super:New()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD arrayTiposIncidencias()

   local cSentence   := "SELECT nombre FROM " + ::cTableName

RETURN ( ::selectFetchArray( cSentence ) )

//---------------------------------------------------------------------------//


