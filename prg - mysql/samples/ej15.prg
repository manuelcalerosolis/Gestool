/*
 * Proyecto: HDO_GENERAL
 * Fichero: ej15.prg
 * Descripción: Ejemplo de la clase RowSet
 * Autor: Manu Exposito
 * Fecha: 15/01/2017
 */

#include "hdo.ch"
#include "InKey.ch"

//------------------------------------------------------------------------------
// Definiciones locales

//#define _ARRAY_

#ifdef _ARRAY_
//	#define _HASH_
#endif

#define DB_NAME  "demo.db"
#define STMT_SEL "SELECT * FROM test WHERE idreg BETWEEN ? AND ?;"

//------------------------------------------------------------------------------
// Procedimiento principal

procedure main15()

    local oDb, oSelect, oRS, oBrw, s, x
    local nRegIni := 0
    local nRegFin := 100000000

	cls
	
	@ 00, 00 SAY "Cargando..."
	
    oDb := THDO():new( "sqlite" )

    oDb:setAttribute( ATTR_ERRMODE, .t. )

    if oDb:connect( DB_NAME )
        oSelect := oDb:prepare( STMT_SEL )
		
        oSelect:bindParam( 1, @nRegIni )
        oSelect:bindParam( 2, @nRegFin )
		
		s := Seconds()
		
#ifdef _ARRAY_
		oSelect:execute()
	#ifdef _HASH_
		oRS := THashCursor():new( oSelect:fetchAllHash() )
	#else		
		oRS := TMemCursor():new( oSelect:fetchAllArray(), oSelect:listColNames( AS_ARRAY ) )
	#endif		
#else		
		// Hace un ::execute() automaticamente
        oRS := oSelect:fetchRowSet()
#endif		
		s := Seconds() - s
		
		@ 00, 00 SAY "Fin de la carga de los " + LTrim( Str( oRS:recCount() ) ) + " registros..."
        msg( s, "Cargado en:" )
		
///////////////////////////////////////////////////////////////////////////////////
// Demo de refresh
/**/
s := Seconds()
oRS:refresh()
s := Seconds() - s
		
@ 00, 00 SAY "Fin de la re-carga de los " + LTrim( Str( oRS:recCount() ) ) + " registros..."
msg( s, "Cargado en:" )
/**/
///////////////////////////////////////////////////////////////////////////////////		
		
		@ 00, 00 SAY "-> Uso de objetos de la clase " + oRS:className() + " - con " + ;
			LTrim( str( oRS:RecCount() ) ) + " registros tratados" COLOR "R+/N+"
			
		oBrw := miBrwCursor( oRS, 1 )

		ejemploDeBusqueda( oRS )
		
        oRS:free()

        oSelect:free()
		
    endif

    oDb:disconnect()

    muestra( "---->[ FIN ]<----" )

return

//------------------------------------------------------------------------------
// Ejemplo de busqueda

static procedure ejemploDeBusqueda( oRS )

    local s, n
	local nCol := 1, xVal
	local getList := {}

	cls

	@ 02, 02 SAY "Introduce la columna por la que buscar...:" GET nCol PICTURE "@K 99"
	READ

	xVal := oRS:fieldGet( nCol )
	@ 03, 02 SAY "Valor que quiere buscar..................:" GET xVal PICTURE "@K"
	READ
	
	n := 0 // Reutilizo variable
			
	if ( s := oRS:find( xVal, nCol, .t. ) ) > 0
		while s > 0
			n++
			? "Hallado el valor:", oRS:fieldName( nCol ), oRS:fieldGet( nCol ), "en el recno:", oRS:recNo()
			s := oRS:findNext( xVal, nCol )  // Busca siguiente
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
