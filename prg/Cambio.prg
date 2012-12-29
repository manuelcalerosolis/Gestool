
FUNCTION Main( cFile )

	IF ! File( cFile )
		Alert( "No Existe" )
		RETURN NIL
	END IF

	USE (cFile) NEW ALIAS "FICHERO"

	DO WHILE ! FICHERO->(EOF())

		REPLACE FICHERO->CCODCLI WITH RJUST( FICHERO->CCODCLI )
		FICHERO->(DBSKIP())

	END WHILE

	CLOSE FICHERO

RETURN NIL

//--------------------------------------------------------------------------//

/*
Alinea por la derecha una cadena con el caracter pasado como 2§
argumento
*/

FUNCTION RJust( cCadena )

	local cChar := '0'
	local nLen  := Len( cCadena )

RETURN PadL( AllTrim( cCadena ), nLen, cChar )

//--------------------------------------------------------------------------//

