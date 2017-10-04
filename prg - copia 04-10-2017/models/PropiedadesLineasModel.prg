#include "fivewin.ch"
#include "factu.ch" 
#include "hdo.ch"

//---------------------------------------------------------------------------//

CLASS PropiedadesLineasModel FROM SQLBaseLineasModel

   DATA cTableName                     INIT "propiedades_lineas"

   DATA cDbfTableName

   DATA hColumns

   METHOD New()

   METHOD updateOrden( Operation, newPosition )

   METHOD largeUpdateOrden( Operation, Conditions )

   METHOD reOrder()

   METHOD getImportSentence( cPath )

   METHOD makeSpecialImportDbfSQL()	   INLINE ( ::makeImportDbfSQL( cPatEmp() ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD New()

	::cDbfTableName					:=	"TBLPRO"

	::hColumns							:=	{	"id"					=>	{	"create"		=>	"INTEGER PRIMARY KEY AUTO_INCREMENT"		,;
																					"text"		=>	"Identificador"									,;
																					"header"		=> "Id"													,;
																					"visible"	=>	.f.}													,;
													"codigo"				=>	{	"create"		=>	"VARCHAR(40) NOT NULL"							,;
																					"text"		=>	"Código de la linea de propiedad"			,;
																					"header"		=>	"Código"												,;
																					"visible"	=>	.t.													,;
																					"width"		=>	100													,;
																					"field"		=>	"cCodTbl"											,;
																					"type"		=>	"C"													,;
																					"len"			=>	40 }													,;
													"nombre"				=>	{	"create"		=>	"VARCHAR(30) NOT NULL"							,;
																					"text"		=>	"Nombre de la linea de propiedad"			,;
																					"header"		=>	"Nombre"												,;
																					"visible"	=>	.t.													,;
																					"width"		=>	100													,;
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
																					"width"		=>	100													,;
																					"field"		=>	"nBarTbl"											,;
																					"type"		=>	"C"													,;
																					"len"			=>	4 }													,;
													"color"				=>	{	"create"		=>	"INT(9)"												,;
																					"text"		=>	"Código de color"									,;
																					"header"		=>	"Color"												,;
																					"visible"	=>	.f.													,;
																					"width"		=>	50														,;
																					"field"		=>	"nColor"												,;
																					"type"		=>	"N"													,;
																					"len"			=>	9 }													,;
													"id_cabecera"		=>	{	"create"		=>	"INTEGER"											,;
																					"text"		=>	"Identificador de la cabecera"				,;
																					"header"		=>	"Id"													,;
																					"field"		=>	"cCodPro"											,;
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

   ::buildRowSetAndFind()

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
	local cSentence	 := "SELECT * FROM " + ::cTableName + " WHERE id_cabecera = " + toSQLString( ::idForeignKey ) + " ORDER by orden"

	::buildRowSet( cSentence )

	while !::oRowSet:eof()

		cSQLUpdate      := "UPDATE " + ::cTableName + " SET orden = " + toSQLString( ::oRowSet:recno() ) + " WHERE id = " + toSQLString( ::oRowSet():fieldget( "id" ) )

		getSQLDatabase():Query( cSQLUpdate )

		::oRowSet:skip(1)
		
	END while

	::buildRowSetAndFind()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD getImportSentence( cPath )
   
   local dbf
   local cValues     := ""
   local cInsert     := ""

   dbUseArea( .t., cLocalDriver(), cPath + "\" + ::getDbfTableName(), cCheckArea( "dbf", @dbf ), .f. )
   if ( dbf )->( neterr() )
      Return ( cInsert )
   end if

   cInsert           := "INSERT INTO " + ::cTableName + " ( "
   hEval( ::hColumns, {| k | if ( k != ::cColumnKey, cInsert += k + ", ", ) } )
   cInsert           := ChgAtEnd( cInsert, ' ) VALUES ', 2 )


   ( dbf )->( dbgotop() )
   while ( dbf )->( !eof() )

      cValues        += "( "

            hEval( ::hColumns, {| k, hash | if ( k != ::cColumnKey,;
                                                if ( k == "id_cabecera",;
                                                      cValues += " ( SELECT id FROM propiedades WHERE codigo = " + toSQLString( ( dbf )->( fieldget( fieldpos( hget( hash, "field" ) ) ) ) ) + " )" + ", ",;
                                                      cValues += toSQLString( ( dbf )->( fieldget( fieldpos( hget( hash, "field" ) ) ) ) ) + ", "), ) } )

      
      cValues        := chgAtEnd( cValues, ' ), ', 2 )

      ( dbf )->( dbskip() )
   end while

   ( dbf )->( dbclosearea() )

   if empty( cValues )
      Return ( nil )
   end if 

   cValues           := chgAtEnd( cValues, '', 2 )

   cInsert           += cValues

Return ( cInsert )

//---------------------------------------------------------------------------//
