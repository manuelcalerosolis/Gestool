#include "fivewin.ch"
#include "factu.ch" 
#include "hdo.ch"

//---------------------------------------------------------------------------//

CLASS SQLConfiguracionEmpresasModel FROM SQLBaseModel

   DATA cTableName            INIT "configuracion_empresas"

   METHOD getColumns()

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns()

	::hColumns						:=	{	"id"			=>	{	"create"		=>	"INTEGER PRIMARY KEY AUTO_INCREMENT"		},;													
                                    "empresa"   => {  "create"    => "CHAR ( 4 ) NOT NULL"                     },;                                      
												"name"		=>	{	"create"		=>	"VARCHAR( 50 ) NOT NULL"						},;													
												"value"		=>	{	"create"		=>	"VARCHAR( 50 ) NOT NULL"						} }				

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//
