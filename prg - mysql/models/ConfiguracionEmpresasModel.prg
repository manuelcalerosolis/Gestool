#include "fivewin.ch"
#include "factu.ch" 
#include "hdo.ch"

//---------------------------------------------------------------------------//

CLASS ConfiguracionEmpresasModel FROM SQLBaseModel

   DATA cTableName                     INIT "configuracion_empresas"

   DATA hColumns

   METHOD New()

   METHOD getValue()
   METHOD getChar( name, default )     INLINE ( ::getValue( name, default ) )
   METHOD getLogic( name, default )    
   METHOD getVal( name, default )      INLINE ( val( ::getValue( name, default ) ) )

   METHOD setValue()

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

METHOD getValue( name, default )

   local aSelect                 
   local cSentence               

   cSentence   := "SELECT value FROM " + ::cTableName + ;
                     " WHERE empresa = " + toSQLString( cCodEmp() ) + " AND name = " + toSQLString( name )
   aSelect     := ::selectFetchHash( cSentence )

   if !empty( aSelect )
      RETURN ( hget( atail( aSelect ), "value" ) )
   end if 

RETURN ( default )

//---------------------------------------------------------------------------//

METHOD getLogic( name, default )

   local cValue

   if !hb_islogical( default )
      default  := .f.
   end if 

   cValue      := ::getValue( name )

   if !empty( cValue )
      RETURN ( ".T." $ upper( cValue ) )
   end if 

RETURN ( default )

//---------------------------------------------------------------------------//

METHOD setValue( name, value )

   local cSelect
   local cSentence

   value       := cValToStr( value )

   cSelect     := "( SELECT id FROM " + ::cTableName + " "  + ;
                     " WHERE empresa = " + toSQLString( cCodEmp() ) + " AND name = " + toSQLString( name ) + " )"

   cSentence   := "REPLACE INTO " + ::cTableName            + ;
                  " ( id ,"                                 + ;          
                     "empresa, "                            + ;
                     "name, "                               + ;
                     "value ) "                             + ;
                  "VALUES"                                  + ;
                  " ( " + cSelect + ", "                    + ;
                     toSQLString( cCodEmp() ) + ", "        + ;
                     toSQLString( name ) + ", "             + ;
                     toSQLString( cValToStr( value ) ) + " )"

   ::Query( cSentence )

RETURN ( Self )

//---------------------------------------------------------------------------//

