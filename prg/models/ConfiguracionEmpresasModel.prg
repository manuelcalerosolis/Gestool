#include "fivewin.ch"
#include "factu.ch" 
#include "hdo.ch"

//---------------------------------------------------------------------------//

CLASS SQLConfiguracionEmpresasModel FROM SQLBaseModel

   DATA cTableName            INIT "configuracion_empresas"

   METHOD New()

END CLASS

//---------------------------------------------------------------------------//

METHOD New()

	::hColumns						:=	{	"id"			=>	{	"create"		=>	"INTEGER PRIMARY KEY AUTO_INCREMENT"		,;
																		"text"		=>	"Identificador"									,;
																		"header"		=>	"Id"													,;
																		"visible"	=> .f.}													,;
                                    "empresa"   => {  "create"    => "CHAR ( 4 ) NOT NULL"                     ,;
                                                      "text"      => "Empresa"                                 ,;
                                                      "visible"   => .f.}                                      ,;
												"name"		=>	{	"create"		=>	"VARCHAR(50) NOT NULL"							,;
																		"text"		=>	"Nombre de la configuración"					,;
																		"header"		=>	"Nombre"												,;
																		"visible"	=> .t.													,;
																		"width"		=>	200 													,;
																		"type"		=> "C"													,;
																		"len"			=> 50	}													,;
												"value"		=>	{	"create"		=>	"VARCHAR(50) NOT NULL"							,;
																		"text"		=>	"Valor de la configuración"					,;
																		"header"		=>	"Valor"												,;
																		"visible"	=> .t.													,;
																		"width"		=>	200 													,;
																		"type"		=> "C"													,;
																		"len"			=> 50	} }				

   ::Super:New()

RETURN ( Self )

//---------------------------------------------------------------------------//
