/*
Definici¢n de la base de datos de lineas de detalle
*/

#define _CODIGO                   1      //   C     10     0
#define _NOMBRE                   2      //   C     50     0
#define _PCOSTO                   3      //   N     13     3
#define _BENEF                    4      //   N      5     1
#define _PVENTA1                  5      //   N     13     3
#define _PVENTA2                  6      //   N     13     3
#define _PVENTA3                  7      //   N     13     3
#define _NACTUAL                  8      //   N     13     3
#define _NUNICAJA                 9      //   N      6     2
#define _CUNIDAD                 10      //   C      2     0
#define _NMINIMO                 11      //   N     13     3
#define _LASTIN                  12      //   D      8     0
#define _LASTOUT                 13      //   D      8     0
#define _TIPOIVA                 14      //   C      1     0
#define _FAMILIA                 15      //   C      5     0
#define _CGRPVENT                 16      //   C      9     0

//---------------------------------------------------------------------------//

FUNCTION Main()

	local cAlias
	local cIva

   USE "DATOS\ARTICULO" NEW VIA ( cDriver() )ALIAS ( cCheckArea( "ARTICULO", @cAlias ) )

	?? "Buscando"

	WHILE !(cAlias)->(EOF())

		?? Chr(2)

		cIva						:= Str( Int( nIva( cIva, (cAlias)->TIPOIVA ) ) )
		(cAlias)->CGRPVENT	:= RJust( cIva, "0", 4 )

		(cAlias)->(DbSkip())

	END DO

	dbCloseAll()

RETURN NIL

//---------------------------------------------------------------------------//

init procedure RddInit()

	REQUEST DBFCDX
	REQUEST DBFNTX

return

//----------------------------------------------------------------------------//

FUNCTION nIva( cAliIva, cCodIva )

	local cTemp     := 0

   USE "DATOS\TIVA" NEW VIA ( cDriver() ) SHARED ALIAS "TIVA"
   SET ADSINDEX TO DATOS\TIVA ADDITIVE
	TIVA->( OrdSetFocus( "TIPO" ) )

	IF TIVA->( DbSeek( cCodIva ) )
		cTemp = TIVA->TPIVA
	END IF

	CLOSE TIVA

RETURN cTemp

//---------------------------------------------------------------------------//

FUNCTION RJust( cCadena, cChar, nLen )

	IF cChar == nil
		cChar := ' '
	END IF
	IF nLen == nil
		nLen  := Len( cCadena )
	END IF

	IF ValType( cCadena ) == "N"
		cCadena := Str( Int( cCadena ) )
	END IF

RETURN PadL( AllTrim( cCadena ), nLen, cChar )

//--------------------------------------------------------------------------//

FUNCTION cCheckArea( cDbfName, cAlias )

	local n := 2

	cAlias  := cDbfName

	while Select( cAlias ) != 0
		cAlias := cDbfName + AllTrim( Str( n++ ) )
	end

RETURN cAlias

//--------------------------------------------------------------------------//