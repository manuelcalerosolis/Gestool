#include "fivewin.ch"
#include "factu.ch" 
#include "hdo.ch"

//---------------------------------------------------------------------------//

CLASS PropiedadesLineasModel FROM SQLBaseLineasModel

   DATA cTableName               INIT "propiedades_lineas"

   DATA cDbfTableName

   DATA hColumns

   METHOD New()

   METHOD updateOrden( Operation, newPosition )

   METHOD largeUpdateOrden( Operation, Conditions )

   METHOD reOrder()

END CLASS

//---------------------------------------------------------------------------//

METHOD New()

	::cDbfTableName					:=	"Pro"

	::hColumns							:=	{	"id"					=>	{	"create"		=>	"INTEGER PRIMARY KEY AUTOINCREMENT"			,;
																					"text"		=>	"Identificador"									,;
																					"header"		=> "Id"													,;
																					"visible"	=>	.f.}													,;
													"codigo"				=>	{	"create"		=>	"VARCHAR(40) NOT NULL"							,;
																					"text"		=>	"Código de la linea de propiedad"			,;
																					"header"		=>	"Código"												,;
																					"visible"	=>	.t.													,;
																					"width"		=>	200													,;
																					"field"		=>	"cCodTbl"											,;
																					"type"		=>	"C"													,;
																					"len"			=>	40 }													,;
													"nombre"				=>	{	"create"		=>	"VARCHAR(30) NOT NULL"							,;
																					"text"		=>	"Nombre de la linea de propiedad"			,;
																					"header"		=>	"Nombre"												,;
																					"visible"	=>	.t.													,;
																					"width"		=>	150													,;
																					"field"		=>	"cDesTbl"											,;
																					"type"		=>	"C"													,;
																					"len"			=>	60 }													,;
													"orden"				=>	{	"create"		=>	"INT NOT NULL"										,;
																					"text"		=>	"Número de orden para códigos de barras"	,;
																					"header"		=>	"Orden"												,;
																					"visible"	=>	.t.													,;
																					"width"		=>	50														,;
																					"field"		=>	"nOrdTbl"											,;
																					"type"		=>	"N"													,;
																					"len"			=>	5 }													,;
													"codigo_barras"	=>	{	"create"		=>	"VARCHAR(4)"										,;
																					"text"		=>	"Código de barras"								,;
																					"header"		=>	"Código de barras"								,;
																					"visible"	=>	.t.													,;
																					"width"		=>	20														,;
																					"field"		=>	"nBarTbl"											,;
																					"type"		=>	"C"													,;
																					"len"			=>	4 }													,;
													"color"				=>	{	"create"		=>	"INT(9)"												,;
																					"text"		=>	"Código de color"									,;
																					"header"		=>	"Color"												,;
																					"visible"	=>	.t.													,;
																					"width"		=>	50														,;
																					"field"		=>	"nColor"												,;
																					"type"		=>	"N"													,;
																					"len"			=>	9 }													,;
													"id_cabecera"		=>	{	"create"		=>	"INTEGER"											,;
																					"text"		=>	"Identificador de la cabecera"				,;
																					"header"		=>	"Id"													,;
																					"visible"	=> .f. }													}


		::cForeignColumn		:= "id_cabecera"

		::Super:New()

		::cConstraints		   := "FOREIGN KEY (id_cabecera) REFERENCES propiedades(id) ON DELETE CASCADE" 

Return ( Self )

//---------------------------------------------------------------------------//

METHOD updateOrden( Operation, newPosition )

   local SentenceForOthers
   local SentenceForMyPosition

	SentenceForOthers       := "UPDATE " + ::cTableName + " SET orden = " + Operation + " WHERE orden = " + toSQLString( newPosition )
   SentenceForMyPosition   := "UPDATE " + ::cTableName + " SET orden = " + toSQLString( newPosition ) + " WHERE id = " + toSQLString( ::oRowSet():fieldget( "id" ) )

   getSQLDatabase():Query( SentenceForOthers )
   getSQLDatabase():Query( SentenceForMyPosition )

   ::buildRowSetWithRecno()

   RETURN ( self )

//---------------------------------------------------------------------------//

METHOD largeUpdateOrden( Operation, Conditions )

   local SentenceForOthers

	SentenceForOthers       := "UPDATE " + ::cTableName + " SET orden = " + Operation + " WHERE orden " + Conditions

   getSQLDatabase():Query( SentenceForOthers )

   RETURN ( self )

//---------------------------------------------------------------------------//

METHOD reOrder()

	local cSQLUpdate
	local cSentence	 := "select * from " + ::cTableName + " where id_cabecera = " + toSQLString( ::idForeignKey ) + " order by orden"

	::buildRowSet( cSentence )

	while !::oRowSet:eof()

		cSQLUpdate := "UPDATE " + ::cTableName + " SET orden = " + toSQLString( ::oRowSet:recno() ) + " WHERE id = " + toSQLString( ::oRowSet():fieldget( "id" ) )

		getSQLDatabase():Query( cSQLUpdate )

		::oRowSet:skip(1)
		
	END while

	::buildRowSetWithRecno()

Return ( Self )

//---------------------------------------------------------------------------//
