// Estructura del fichero de asientos diarios

#define _ASIEN                    1     //   N      6     0
#define _FECHA                    2     //   D      8     0
#define _SUBCTA                   3     //   C     12     0
#define _CONTRA                   4     //   C     12     0
#define _PTADEBE                  5     //   N     12     0
#define _CONCEPTO                 6     //   C     25     0
#define _PTAHABER                 7     //   N     12     0
#define _FACTURA                  8     //   N      7     0
#define _BASEIMPO                 9     //   N     11     0
#define _IVA                     10     //   N      5     2
#define _RECEQUIV                11     //   N      5     2
#define _DOCUMENTO               12     //   C      6     0
#define _DEPARTA                 13     //   C      3     0
#define _CLAVE                   14     //   C      6     0
#define _ESTADO                  15     //   C      1     0
#define _NCASADO                 16     //   N      6     0
#define _TCASADO                 17     //   N      1     0

STATIC cDiario
STATIC cCuenta
STATIC cSubCuenta

REQUEST DBFNTX

//----------------------------------------------------------------------------//

FUNCTION Main()

	local nDiario
	local nRecNoIni
	local nRecNoEnd
	local nPos
	local lRecargo	:= .F.
	local aCambio	:= { 	{ "4770016", "4771600", "4771604" },;
								{ "4770007", "4770700", "4770701" },;
								{ "4770004", "4770400", "4770405" } }

	local aReq		:= {	{ "4750010", "4750001" },;
								{ "4750040", "4750004" },;
								{ "4750005", "4750004" } }
	local cRuta		:= "C:\CONTA7"
	local cCodEmp	:= "02"

	IF FILE( cRuta + "\EMP" + cCodEmp + "\DIARIO" + cCodEmp + ".DBF" )
		ALERT( cRuta + "\EMP" + cCodEmp + "\DIARIO" + cCodEmp + ".DBF" )
	END IF

	USE ( cRuta + "\EMP" + cCodEmp + "\DIARIO" + cCodEmp + ".DBF" );
		NEW;
		VIA "DBFNTX";
		ALIAS ( cCheckArea( "DIARIO", @cDiario ) )

	nDiario			:= (cDiario)->ASIEN

	WHILE !(cDiario)->(Eof()) .and. (cDiario)->ASIEN == nDiario

		nRecNoIni   := (cDiario)->(RecNo())

		WHILE (cDiario)->ASIEN == nDiario
			IF SubStr( (cDiario)->SUBCTA, 1, 3 ) == "475"
				?? ( "Encontrado Recargo : " + (cDiario)->SUBCTA )
				lRecargo := .T.
			END IF

			(cDiario)->(dbSkip())

		END WHILE

		(cDiario)->( DbGoTo( nRecNoIni ) )

		WHILE (cDiario)->ASIEN == nDiario

			nPos	:= aScan( aCambio, {| aVal | aVal[1] == Rtrim( (cDiario)->SUBCTA ) } )

			IF nPos != 0
				IF lRecargo
					(cDiario)->SUBCTA	:= aCambio[nPos,3]
				ELSE
					(cDiario)->SUBCTA	:= aCambio[nPos,2]
				END IF

            ?? ( "Encontrado " + cImp() + " : " + (cDiario)->SUBCTA )

			END IF

			nPos	:= aScan( aReq, {|aVal| aVal[1] == RTrim( (cDiario)->SUBCTA ) } )

			IF nPos != 0
				(cDiario)->SUBCTA	:= aReq[nPos,2]
				?? ( "Encontrado R.E.: " + (cDiario)->SUBCTA )

			END IF

			(cDiario)->(DbSkip())

		END WHILE

		lRecargo	:= .F.
		nDiario	:= (cDiario)->ASIEN

	END WHILE

	CLOSE (cDiario)

	Alert( "Terminado" )

RETURN NIL

//----------------------------------------------------------------------------//

FUNCTION cCheckArea( cDbfName, cAlias )

	local n := 2

	cAlias  := cDbfName

	while Select( cAlias ) != 0
		cAlias := cDbfName + AllTrim( Str( n++ ) )
	end

RETURN cAlias

//---------------------------------------------------------------------------//