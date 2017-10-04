/*
Definici¢n de la base de datos de lineas de detalle
*/

#define _dCSERIE                  1      //   C      1     0
#define _dNNUMFAC                 2      //   N      9     0
#define _CREF                     3      //   C     18     0
#define _CDETALLE                 4      //   C     35     0
#define _NPREUNIT                 5      //   N     13     3
#define _NDTO                     6      //   N      5     1
#define _CODIVA                   7      //   C      1     0
#define _NCANENT                  8      //   N     13     3
#define _LCONTROL                 9      //   L      1     0
#define _CUNIDAD                 10      //   C      2     0
#define _NUNICAJA                11      //   N      6     2

/*
Defines para las lineas de Pago
*/

#define _pCSERIE                  1      //   C      1     0
#define _pNNUMFAC                 2      //   N      9     0
#define _DENTRADA                 3      //   D      8     0
#define _NIMPORTE                 4      //   N     10     0
#define _CDESCRIP                 5      //   C     20     0

//---------------------------------------------------------------------------//

FUNCTION Traspaso()

	USE "FACCLIL" NEW ALIAS "LINEAS"

	WHILE ! LINEAS->(EOF())

			LINEAS->NIVA		:= nIva( LINEAS->CREF )

		LINEAS->(DbSkip())

	END DO

   dbCloseAll()

RETURN NIL

//---------------------------------------------------------------------------//

FUNCTION nIva( cCodArt )

	local cTemp     := 0

   USE ARTICULO NEW VIA ( cDriver() ) SHARED ALIAS "ARTICULO"
   SET ADSINDEX TO ARTICULO ADDITIVE

   USE TIVA NEW VIA ( cDriver() ) SHARED ALIAS "TIVA"
   SET ADSINDEX TO TIVA ADDITIVE

	IF ARTICULO->( dBSeek( cCodArt ) )

		IF TIVA->( DbSeek( ARTICULO->TIPOIVA ) )
			cTemp = TIVA->TPIVA
		END IF

	ELSE
		?? "NO ENCUENTRO ARTICULO " + cCodArt
		WAIT

	END IF

	CLOSE TIVA
	CLOSE ARTICULO


RETURN cTemp

//---------------------------------------------------------------------------//

init procedure RddInit()

	REQUEST DBFCDX
	REQUEST DBFNTX

return

//----------------------------------------------------------------------------//