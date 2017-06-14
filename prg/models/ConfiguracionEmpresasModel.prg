#include "fivewin.ch"
#include "factu.ch" 
#include "hdo.ch"

//---------------------------------------------------------------------------//

CLASS ConfiguracionEmpresasModel FROM SQLBaseModel

   DATA cTableName               INIT "configuracion_empresas"

   DATA hColumns

   METHOD New()

   METHOD getValue()

   METHOD setValue()

END CLASS

//---------------------------------------------------------------------------//

METHOD New()

	::hColumns						:=	{	"id"			=>	{	"create"		=>	"INTEGER PRIMARY KEY AUTOINCREMENT"			,;
																		"text"		=>	"Identificador"									,;
																		"header"		=>	"Id"													,;
																		"visible"	=> .f.}													,;
                                    "empresa"   => {  "create"    => "CHAR ( 4 ) NOT NULL"                     ,;
                                                      "text"      => "Empresa"                                 ,;
                                                      "visible"   => .f.}                                      ,;
												"name"		=>	{	"create"		=>	"VHARCHAR(50) NOT NULL"							,;
																		"text"		=>	"Nombre de la configuración"					,;
																		"header"		=>	"Nombre"												,;
																		"visible"	=> .t.													,;
																		"width"		=>	200 													,;
																		"type"		=> "C"													,;
																		"len"			=> 50	}													,;
												"value"		=>	{	"create"		=>	"VHARCHAR(50) NOT NULL"							,;
																		"text"		=>	"Valor de la configuración"					,;
																		"header"		=>	"Valor"												,;
																		"visible"	=> .t.													,;
																		"width"		=>	200 													,;
																		"type"		=> "C"													,;
																		"len"			=> 50	}													,;
												"type"	  =>	{	"create"		=>	"VHARCHAR(1) NOT NULL"                    ,;
																		"text"		=>	"Tipo de la configuración"						,;
																		"header"		=>	"Tipo"                                    ,;
																		"visible"	=> .f.													,;
																		"width"		=>	40														,;
																		"type"		=> "L" } }				

   ::Super:New()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD getValue( name, default )

   local cSentence               := "SELECT value FROM " + ::cTableName + ;
                                       " WHERE empresa = " + toSQLString( cCodEmp() ) + " AND name = " + toSQLString( name )
   local aSelect                 := ::selectFetchHash( cSentence )

   if !empty( aSelect )
      RETURN ( hget( atail( aSelect ), "value" ) )
   end if 

RETURN ( default )

//---------------------------------------------------------------------------//

METHOD setValue( name, value, type )

   local cSelect
   local cSentence

   cSelect     := "( SELECT id FROM " + ::cTableName + " "  + ;
                     " WHERE empresa = " + toSQLString( cCodEmp() ) + " AND name = " + toSQLString( name ) + " )"

   cSentence   := "REPLACE INTO " + ::cTableName            + ;
                  " ( id ,"                                 + ;          
                     "empresa, "                            + ;
                     "name, "                               + ;
                     "value, "                              + ;
                     "type ) "                              + ;
                  "VALUES"                                  + ;
                  " ( " + cSelect + ", "                    + ;
                     toSQLString( cCodEmp() ) + ", "        + ;
                     toSQLString( name ) + ", "             + ;
                     toSQLString( value ) + ", "            + ;
                     toSQLString( type ) + " )"

   msgalert( cSentence )

   ::Query( cSentence )

RETURN ( Self )

//---------------------------------------------------------------------------//

