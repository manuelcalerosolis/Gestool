#include "fivewin.ch"
#include "factu.ch" 
#include "hdo.ch"

//---------------------------------------------------------------------------//

CLASS EstadosSatModel FROM SQLBaseModel

	DATA	cTableName					INIT "Estados_SAT"

	DATA	cDbfTableName				INIT "EstadoSat"

	DATA 	hColumns						INIT { 	"id" 				=> {	"create"		=>	"INTEGER PRIMARY KEY AUTOINCREMENT"	,;
																					"text"		=>	"Identificador"							,;
																					"dbfField"	=> "" }											,;
														"cod_estado"	=>	{	"create"		=>	"VARCHAR(3) UNIQUE NOT NULL"			,;
																					"text"		=>	"Código del estado"						,;
																					"dbfField" 	=>	"cCodigo" }									,;
														"nombre"			=>	{	"create"		=>	"VARCHAR(50)"								,;
																					"text"		=>	"Nombre del estado"						,;
																					"dbfField" 	=> "cNombre" }									,;
														"tipo"			=>	{	"create"		=> "VARCHAR(30)"								,;
																					"text"		=> "Tipo del estado"							,;
																					"dbfField" 	=> "cTipo" }									,;
														"disponible"	=>	{	"create"		=> "INT NOT NULL"								,;
																					"text"		=> "Disponible"								,;
																					"dbfField" 	=> "nDisp" } }

	METHOD New()

   METHOD arrayEstadosSAT()

   METHOD existTiposImpresoras( cValue )

END CLASS

//---------------------------------------------------------------------------//

METHOD New()

	::cTableName							:= "Estados_SAT"

	::cDbfTableName						:= "EstadoSat"

	::hColumns								:= { 	"id" 				=> {	"create"		=>	"INTEGER PRIMARY KEY AUTOINCREMENT"	,;
																					"text"		=>	"Identificador"							,;
																					"dbfField"	=> "" }											,;
														"cod_estado"	=>	{	"create"		=>	"VARCHAR(3) UNIQUE NOT NULL"			,;
																					"text"		=>	"Código del estado"						,;
																					"dbfField" 	=>	"cCodigo" }									,;
														"nombre"			=>	{	"create"		=>	"VARCHAR(50)"								,;
																					"text"		=>	"Nombre del estado"						,;
																					"dbfField" 	=> "cNombre" }									,;
														"tipo"			=>	{	"create"		=> "VARCHAR(30)"								,;
																					"text"		=> "Tipo del estado"							,;
																					"dbfField" 	=> "cTipo" }									,;
														"disponible"	=>	{	"create"		=> "INT NOT NULL"								,;
																					"text"		=> "Disponible"								,;
																					"dbfField" 	=> "nDisp" } }

::Super:New()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD arrayEstadosSAT()

	local aResult                 := {}
   local cSentence               := "SELECT nombre FROM " + ::cTableName
   local aSelect                 := ::selectFetchArray( cSentence ) 

   if !empty( aSelect )
      aeval( aSelect, {|a| aadd( aResult, a[ 1 ] ) } )
   end if 

RETURN ( aResult )

//---------------------------------------------------------------------------//

METHOD existTiposImpresoras( cValue )

   local cSentence               := "SELECT cod_estado, nombre, tipo, disponible FROM " + ::cTableName + " WHERE nombre = " + quoted( cValue )
   local aSelect                 := ::selectFetchArray( cSentence )

RETURN ( !empty( aSelect ) )

//---------------------------------------------------------------------------//
