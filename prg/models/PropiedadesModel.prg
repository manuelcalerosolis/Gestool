#include "fivewin.ch"
#include "factu.ch" 
#include "hdo.ch"

//---------------------------------------------------------------------------//

CLASS PropiedadesModel FROM SQLBaseModel

   DATA cTableName               INIT "propiedades"

   DATA cDbfTableName

   DATA hColumns

   METHOD New()

END CLASS

//---------------------------------------------------------------------------//

METHOD New()

	::cDbfTableName				:=	"Pro"

	::hColumns						:=	{	"id"			=>	{	"create"		=>	"INTEGER PRIMARY KEY AUTO_INCREMENT"		,;
																		"text"		=>	"Identificador"									,;
																		"header"		=>	"Id"													,;
																		"visible"	=> .f.}													,;
												"codigo"		=>	{	"create"		=>	"VARCHAR(20) NOT NULL"							,;
																		"text"		=>	"C�digo de la propiedad"						,;
																		"header"		=>	"C�digo"												,;
																		"visible"	=> .t.													,;
																		"width"		=>	100													,;
																		"field"		=>	"cCodPro"											,;
																		"type" 		=> "C" 													,;
																		"len" 		=> 20	}													,;
												"nombre"		=>	{	"create"		=>	"VHARCHAR(50) NOT NULL"							,;
																		"text"		=>	"Nombre de la propiedad"						,;
																		"field"		=>	"cDesPro"											,;
																		"header"		=>	"Nombre"												,;
																		"visible"	=> .t.													,;
																		"width"		=>	200 													,;
																		"type"		=> "C"													,;
																		"len"			=> 50	}													,;
												"is_color"	=>	{	"create"		=>	"INT(1) NOT NULL"									,;
																		"text"		=>	"L�gico tipo color"								,;
																		"field"		=>	"lColor"												,;
																		"header"		=>	"Es un color"										,;
																		"visible"	=> .f.													,;
																		"width"		=>	40														,;
																		"type"		=> "L"}													,;
												"empresa"	=>	{  "create"    => "CHAR ( 4 ) NOT NULL"	              		,;
                                                      "text"      => "Empresa"											,;
																		"visible"	=> .f.}													}

   ::Super:New()

RETURN ( Self )

//---------------------------------------------------------------------------//