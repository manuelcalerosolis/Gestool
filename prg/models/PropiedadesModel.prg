#include "fivewin.ch"
#include "factu.ch" 
#include "hdo.ch"

//---------------------------------------------------------------------------//

CLASS PropiedadesModel FROM SQLBaseEmpresasModel

   DATA cTableName               INIT "propiedades"

   DATA cDbfTableName

   DATA hColumns

   METHOD New()

END CLASS

//---------------------------------------------------------------------------//

METHOD New()

	::cDbfTableName					:=	"Pro"

	::cWndTitle                   := "Propiedades"

	::hColumns						:=	{	"id"			=>	{	"create"		=>	"INTEGER PRIMARY KEY AUTOINCREMENT"			,;
																		"text"		=>	"Identificador"									,;
																		"dbfField"	=>	""														,;
																		"cHeader"	=>	"Id"													,;
																		"visible"	=> .f.													,;
																		"nWidth"		=>	40}													,;
												"codigo"		=>	{	"create"		=>	"VARCHAR(20) NOT NULL"							,;
																		"text"		=>	"Código de la propiedad"						,;
																		"dbfField"	=>	"cCodPro"											,;
																		"cHeader"	=>	"Código"												,;
																		"visible"	=> .t.													,;
																		"nWidth"		=>	100}													,;
												"nombre"		=>	{	"create"		=>	"VHARCHAR(50) NOT NULL"							,;
																		"text"		=>	"Nombre de la propiedad"						,;
																		"dbfField"	=>	"cDesPro"											,;
																		"cHeader"	=>	"Nombre"												,;
																		"visible"	=> .t.													,;
																		"nWidth"		=>	200}													,;
												"is_color"	=>	{	"create"		=>	"INT(1) NOT NULL"									,;
																		"text"		=>	"Lógico tipo color"								,;
																		"dbfField"	=>	"lColor"												,;
																		"cHeader"	=>	"Es un color"										,;
																		"visible"	=> .f.													,;
																		"nWidth"		=>	40}													,;
												"empresa"	=>	{  "create"    => "CHAR ( 4 ) NOT NULL"	              		,;
                                                      "text"      => "Empresa a la que pertenece la etiqueta"	,;
                                                   	"dbfField"	=>	""														}}

   ::Super:New()

RETURN ( Self )

//---------------------------------------------------------------------------//