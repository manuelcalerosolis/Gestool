/*
 * Proyecto: HDO_GENERAL
 * Fichero: ej15.prg
 * Descripción: Ejemplo de la clase RowSet
 * Autor: Manu Exposito
 * Fecha: 20/01/2018
 */

//------------------------------------------------------------------------------

#include "hdo.ch"
#include "inkey.ch"

//------------------------------------------------------------------------------

#define SQLITE
//#define MYSQL

#ifdef SQLITE
	REQUEST RDLSQLITE
	#define _DBMS	"sqlite"
	#define _DB 	"hdodemo.db"
	#define _CONN
#else
	#ifdef MYSQL
		REQUEST RDLMYSQL
		#define _DBMS	"mysql"
		#define _DB		"hdodemo"
		#define _CONN 	"127.0.0.1", "root", "root"
	#endif
#endif

//------------------------------------------------------------------------------
// Definiciones locales

#define _ARRAY_

#ifdef _ARRAY_
	#define _HASH_
#endif

#define STMT_SEL "SELECT * FROM test WHERE idreg BETWEEN ? AND ?;"

//------------------------------------------------------------------------------
// Procedimiento principal

procedure main()

    local oDb, oSelect, oCur, oBrw, s, bOrder, xOrder, x,y
    local nRegIni := 1
    local nRegFin := 1000000000

////////////////////////////////////////////////////////////////////////////////
// Esto no tiene efectos si no se usa el sistema embebido                     //
////////////////////////////////////////////////////////////////////////////////
#ifdef MYSQL                                                                  //
	local aOptions := { "HDO_DEMO", "--defaults-file=./my.cnf" }              //
	local aGroup := { "server", "client" }                                    //
//----------------------------------------------------------------------------//
	initMySQLEmdSys( aOptions, aGroup, "client" )                             //
#endif                                                                        //
////////////////////////////////////////////////////////////////////////////////

	cls
	
	@ 00, 00 SAY "Cargando..."
	
	oDb := THDO():new( _DBMS )

    if oDb:connect( _DB, _CONN )
        oSelect := oDb:prepare( STMT_SEL )

		oSelect:bindParam( 1, @nRegIni, HDO_TYPE_INTEGER )
		oSelect:bindParam( 2, @nRegFin, HDO_TYPE_INTEGER )
		s := Seconds()

#ifdef _ARRAY_
		oSelect:execute()
	#ifdef _HASH_
		oCur := THashList():new( oSelect:fetchAllHash() )
	#else		
		oCur := TMemList():new( oSelect:fetchAllArray(), oSelect:listColNames() )
		// Se podria hacer esto tambien:
		// oCur := TMemList():new()
		// oCur:setSource( oSelect:fetchAllArray(), oSelect:listColNames() )
	#endif		
#else		
		// Hace un ::execute() automaticamente
        oCur := oSelect:fetchRowSet()
#endif		
        msg( Seconds() - s, "Cargado en:" )
		
		@ 00, 00 SAY "Uso de la clase " + oCur:className() + ": Source con " + ;
			LTrim( Str( oCur:fieldCount() ) ) + " columnas y " + ;
			LTrim( Str( oCur:recCount() ) ) + " registros" COLOR "R+/N+"
		
		// Ejemplo de edicion:
		oCur:goTo( 1 )
		oCur:fieldPut( 2, "Esto                 " )
		oCur:fieldPut( 3, "es                   " )
		oCur:fieldPut( 4, "una                  " )
		oCur:fieldPut( 5, "prueba               " )

		oCur:next()
		oCur:fieldPut( 12, "Esto es una prueba " + Str( Seconds( ) ) )
		oCur:next()
		oCur:fieldPut( 12, "Esto es una prueba " + Str( Seconds( ) ) )
		
#ifdef _ARRAY_
		// Ejemplo de ordenacion
		//----------------------
	#ifdef _HASH_	
		// Por la columna "last" y ascendente "<"
		xOrder := "last"
	#else
		// Por la columna 3 y ascendente "<"
		xOrder := 3
	#endif				
		bOrder := { | x, y | x[ xOrder ] < y[ xOrder ] }
		oCur:sort( bOrder ) 	
#endif		
		oBrw := miBrwCursor( oCur, 1 )
		
		ejemploDeBusqueda( oCur )
		
		msg( oCur:find( "Bruce", 1 ), "Con un error o no lo encuentra" )  // Este debe devolver 0, los tipos no coinciden
		msg( oCur:find( "Bruce", 3 ), "Por posicion" )
		msg( oCur:find( "Bruce", "last" ), "Por nombre" )
		
        oCur:free()
        oSelect:free()
    endif

    oDb:disconnect()

    muestra( "---->[ FIN ]<----" )

return

//------------------------------------------------------------------------------
// Ejemplo de busqueda

static procedure ejemploDeBusqueda( oCur )

    local s, n
	local nCol := 1, xVal
	local getList := {}

	cls

	@ 02, 02 SAY "Introduce la columna por la que buscar...:" GET nCol PICTURE "@K 99"
	READ

	xVal := oCur:fieldGet( nCol )
	@ 03, 02 SAY "Valor que quiere buscar..................:" GET xVal PICTURE "@K"
	READ

	cls
		
	? "Tipo:", oCur:fieldType( nCol ), "decimales:", oCur:fieldDec( nCol )
	
	n := 0 // Reutilizo variable

	if ( s := oCur:find( xVal, nCol, .t. ) ) > 0
		? Replicate( "-", MaxCol() )
		? "Hallado el valor [", oCur:fieldGet( nCol ), "] de la columna:", oCur:fieldName( nCol )
		? Replicate( "-", MaxCol() )
		
		while s > 0
			?  ++n, "RecNo:", oCur:recNo(), "->", oCur:fieldGet( nCol )
			s := oCur:findNext()  // Busca siguiente
		end

		? Replicate( "-", MaxCol() )
		? "Hay", AllTrim( Str( n ) ), "ocurrencias de", xVal, "en la columna", AllTrim( Str( nCol ) )
		? Replicate( "-", MaxCol() )
	else
		? xVal, "no encontrado..."
	endif

	espera( 30 )

return

//------------------------------------------------------------------------------
