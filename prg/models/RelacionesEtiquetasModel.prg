#include "fivewin.ch"
#include "factu.ch" 
#include "hdo.ch"

//---------------------------------------------------------------------------//

CLASS RelacionesEtiquetasModel FROM SQLBaseEmpresasModel

   DATA cTableName                        INIT "relaciones_etiquetas"

   DATA hColumns

   METHOD New()

END CLASS

//---------------------------------------------------------------------------//

METHOD New()

   ::hColumns                   	:= {  "id"              	=> {  "create"    => "INTEGER PRIMARY KEY AUTOINCREMENT"       						,;
                                                                  "text"		=> "Identificador"}                           						,;                        					
                                       "id_empresa"         => {  "create"    => "CHAR ( 4 )"                                 					,;
                                                                  "text"      => "Empresa a la que pertenece el documento y etiquetas"}     	,;
                                       "tabla_documento"		=> {  "create"    => "VARCHAR (50) NOT NULL"                      					,;
                                                                  "text"      => "Nombre de la tabla donde está el id_documento"}            ,;
                                       "id_documento"			=>	{	"create"		=>	"VARCHAR( 18 ) NOT NULL"												,;
                                    										"text"		=>	"Identificador de un documento"}										,;
                                    	"etiquetas"				=> {	"create"		=>	"VARCHAR ( 250 )"															,;
                                    										"text"		=>	"Conjunto de etiquetas"}												}

   ::Super:New()

RETURN ( Self )

//---------------------------------------------------------------------------//