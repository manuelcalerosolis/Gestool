//
#include "FiveWin.Ch"
#include "Font.ch"
#include "Report.ch"
#include "Factu.ch"

#define _NBRUTIVA1					aIva[ 1, 1 ]
#define _NBASEIVA1					aIva[ 1, 2 ]
#define _NPCTIVA1						aIva[ 1, 3 ]
#define _NPCTREQ1						aIva[ 1, 4 ]
#define _NBRUTIVA2					aIva[ 2, 1 ]
#define _NBASEIVA2					aIva[ 2, 2 ]
#define _NPCTIVA2						aIva[ 2, 3 ]
#define _NPCTREQ2						aIva[ 2, 4 ]
#define _NBRUTIVA3					aIva[ 3, 1 ]
#define _NBASEIVA3					aIva[ 3, 2 ]
#define _NPCTIVA3						aIva[ 3, 3 ]
#define _NPCTREQ3						aIva[ 3, 4 ]


static dbfFacCliT
static dbfFacCliL
static dbfFacPago
static dbfAbnCliT
static dbfAbnCliL
static dbfClient
static dbfIva

static nTotImport := 0
static nTotPagado := 0
static nImporte	:= 0

static nTotalNet	:= 0
static nTotalIva	:= 0
static nTotalReq  := 0
static nTotalFac  := 0

static cCodCli
static lSalida 	:= .f.

//---------------------------------------------------------------------------//

FUNCTION InfResFact()

	local oDlg
	local oBntPrev
	local oBtnImpr
	local oBtnCancel
	local oCliDesde
	local oCliHasta
	local cCliDesde
	local cCliHasta
	local oNomCliDesde
	local oNomCliHasta
	local cNomCliDesde
	local cNomCliHasta
	local lSerieA		:= .T.
	local lSerieB		:= .T.
	local lAbonos		:= .T.
	local nYear			:= Year( Date() )
   local cTitulo     := Padr( cCodEmp() + " - " + cNbrEmp(), 100 )
	local cSubTitulo	:= Padr( "Diario de Facturación", 100 )

	/*
	Bases de datos para el informe
	*/

	dbCommitAll()

   USE ( cPatEmp() + "FACCLIT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACCLIT", @dbfFacCliT ) )
   SET ADSINDEX TO ( cPatEmp() + "FACCLIT.CDX" ) ADDITIVE

   USE ( cPatEmp() + "FACCLIL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACCLIL", @dbfFacCliL ) )
   SET ADSINDEX TO ( cPatEmp() + "FACCLIL.CDX" ) ADDITIVE

   USE ( cPatEmp() + "FACCLIP.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACCLIP", @dbfFacPago ) )
   SET ADSINDEX TO ( cPatEmp() + "FACCLIP.CDX" ) ADDITIVE

   USE ( cPatCli() + "CLIENT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CLIENT", @dbfClient ) )
   SET ADSINDEX TO ( cPatCli() + "CLIENT.CDX" ) ADDITIVE

   USE ( cPatDat() + "TIVA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIVA", @dbfIva ) )
   SET ADSINDEX TO ( cPatDat() + "TIVA.CDX" ) ADDITIVE

	/*
	Obtenemos los valores del primer y ultimo codigo
	*/

	cCliDesde	:= dbFirst( dbfClient, 1 )
	cCliHasta	:= dbLast(  dbfClient, 1 )

	/*
	Caja de dialogo
	*/

	DEFINE DIALOG oDlg RESOURCE "INFRESFACT"

	REDEFINE GET nYear;
		ID 		100 ;
		SPINNER ;
		PICTURE 	"9999" ;
		COLOR 	CLR_GET ;
		OF 		oDlg

	REDEFINE GET oCliDesde VAR cCliDesde;
		ID 		110 ;
		COLOR 	CLR_GET ;
		VALID 	( cClient( oCliDesde, dbfClient, oNomCliDesde ) ) ;
      BITMAP   "LUPA" ;
      ON HELP  ( BrwClient( oCliDesde, oNomCliDesde ) ) ;
		OF 		oDlg

	REDEFINE GET oNomCliDesde VAR cNomCliDesde ;
		WHEN 		.F. ;
		COLOR 	CLR_GET ;
		ID 		111 ;
		OF 		oDlg

	REDEFINE GET oCliHasta VAR cCliHasta;
		ID 		120 ;
		COLOR 	CLR_GET ;
		VALID 	( cClient( oCliHasta, dbfClient, oNomCliHasta ) ) ;
      BITMAP   "LUPA" ;
		ON HELP 	( BrwClient( oCliHasta, oNomCliHasta ) ) ;
		OF 		oDlg

	REDEFINE GET oNomCliHasta VAR cNomCliHasta ;
		WHEN 		.F. ;
		COLOR 	CLR_GET ;
		ID 		121 ;
		OF 		oDlg

	REDEFINE GET nImporte;
		ID 		130 ;
		PICTURE  "@E 999,999,999,999" ;
		COLOR 	CLR_GET ;
		OF 		oDlg

	REDEFINE CHECKBOX lSerieA ;
		ID 		140 ;
		OF 		oDlg

	REDEFINE CHECKBOX lSerieB ;
		ID 		141 ;
		OF 		oDlg

	REDEFINE CHECKBOX lAbonos ;
		ID 		142 ;
		OF 		oDlg

	REDEFINE GET cTitulo ;
		ID 		170 ;
		OF 		oDlg

	REDEFINE GET cSubTitulo ;
		ID 		180 ;
		OF 		oDlg

	REDEFINE BUTTON oBtnPrev ;
		ID 		508 ;
		OF 		oDlg ;
      ACTION ( oDlg:disable(),;
					GenResFact( nYear, cCliDesde, cCliHasta, nImporte, lSerieA, lSerieB, lAbonos, 1, cTitulo, cSubTitulo ),;
               oDlg:enable() )

	REDEFINE BUTTON oBtnImpr ;
      ID       IDOK ;
		OF 		oDlg ;
      ACTION ( oDlg:disable(),;
					GenResFact( nYear, cCliDesde, cCliHasta, nImporte, lSerieA, lSerieB, lAbonos, 2, cTitulo, cSubTitulo ),;
               oDlg:enable() )

	REDEFINE BUTTON oBtnCancel ;
      ID       IDCANCEL ;
		OF 		oDlg ;
		ACTION 	( oDlg:end() )

   ACTIVATE DIALOG oDlg CENTER ON PAINT ( oCliDesde:lValid(), oCliHasta:lValid() )

	CLOSE ( dbfFacCliT )
	CLOSE ( dbfFacCliL )
	CLOSE ( dbfFacPago )
	CLOSE ( dbfClient )
	CLOSE ( dbfIva )

RETURN NIL

//---------------------------------------------------------------------------//

STATIC FUNCTION GenResFact( nYear, cCliDesde, cCliHasta, nImporte, lSerieA, lSerieB, lAbonos, nDevice, cTitulo, cSubTitulo )

	local oFont1
	local oFont2

   DEFINE FONT oFont1 NAME "Arial" SIZE 0,-12 BOLD
   DEFINE FONT oFont2 NAME "Arial" SIZE 0,-12

	( dbfClient )->( dbSeek( cCliDesde ) )

	IF nDevice == 1

		REPORT oReport ;
			TITLE 	Rtrim( cTitulo ), Rtrim( cSubTitulo ), "" ;
			FONT   	oFont1, oFont2 ;
         HEADER   "Año : "  + Str( nYear ) RIGHT ;
			FOOTER 	OemtoAnsi( "P gina : ") + str( oReport:nPage, 3 ) CENTERED;
			CAPTION 	"Facturación de Clientes";
			PREVIEW

	ELSE

		REPORT oReport ;
			TITLE 	Rtrim( cTitulo ), Rtrim( cSubTitulo ), "" ;
			FONT   	oFont1, oFont2 ;
			HEADER 	OemToAnsi( "A¤o : " ) + Str( nYear ) RIGHT ;
			FOOTER 	OemtoAnsi( "P gina : ") + str( oReport:nPage, 3 ) CENTERED;
			CAPTION 	"Facturación de Clientes";
         TO PRINTER

	END IF

   COLUMN TITLE "Codigo", "C.I.F." ;
			DATA (dbfClient)->COD, (dbfClient)->NIF ;
			SIZE 10 ;
			FONT 2

	COLUMN TITLE "Nombre", OemToAnsi( "Poblaci¢n - C.Postal" ) ;
			DATA (dbfClient)->TITULO, Rtrim( (dbfClient)->POBLACION ) + " - " + (dbfClient)->CODPOSTAL  ;
			SIZE 30 ;
			FONT 2

	COLUMN TITLE "Importe" ;
			DATA nTotImport ;
			PICTURE "@E 99,999,999,999" ;
			SIZE 10 ;
			TOTAL ;
			FONT 2

	COLUMN TITLE "Pagado" ;
			DATA nTotPagado ;
			PICTURE "@E 99,999,999,999" ;
			SIZE 10 ;
			TOTAL ;
			FONT 2

	END REPORT

   IF !Empty( oReport ) .and.  oReport:lCreated
		oReport:Margin( 0, RPT_RIGHT, RPT_CMETERS )
		oReport:bSkip	:= {|| (dbfClient)->(DbSkip( 1 ) ) }
	END IF

	ACTIVATE REPORT oReport;
		FOR 	lTotFactCli( (dbfClient)->COD, nYear, lSerieA, lSerieB, lAbonos ) ;
		WHILE (dbfClient)->COD >= cCliDesde .AND. (dbfClient)->COD <= cCliHasta .AND. !( dbfClient )->( Eof() )

	oFont1:end()
	oFont2:end()

RETURN NIL

//---------------------------------------------------------------------------//

STATIC FUNCTION lTotFactCli( cCodCli, nYear, lSerieA, lSerieB, lAbonos )

	local lReturn		:= .t.
	local nOrdAnt		:= ( dbfFacCliT )->( OrdSetFocus( "CCODCLI" ) )

	nTotImport 			:= 0
	nTotPagado 			:= 0

	DEFAULT lSerieA 	:= .T.
	DEFAULT lSerieB 	:= .T.
	DEFAULT lAbonos 	:= .T.

	/*
	Calculo de Facturas
	-------------------------------------------------------------------------
	*/

	IF ( dbfFacCliT )->( dbSeek( cCodCli ) )

		WHILE ( dbfFacCliT )->( !Eof() ) .AND. Year( ( dbfFacCliT )->DFECFAC ) == nYear

			IF ( dbfFacCliT )->CCODCLI == cCodCli .AND. ;
				( ( dbfFacCliT )->CSERIE == "A" .AND. lSerieA .OR. ( dbfFacCliT )->CSERIE == "B" .AND. lSerieB )

				nTotImport += nTotFacCli( ( dbfFacCliT )->CSERIE + Str( ( dbfFacCliT )->NNUMFAC ), dbfFacCliT, dbfFacCliL, dbfIva )
            nTotPagado += nPagFacCli( ( dbfFacCliT )->CSERIE + Str( ( dbfFacCliT )->NNUMFAC ), dbfFacCliT, dbfFacPago, dbfIva )

			END IF

			( dbfFacCliT )->( dbSkip() )

		END WHILE

	END IF

	( dbfFacCliT )->( OrdSetFocus( nOrdAnt ) )

	/*
	Calculo de Abonos
	-------------------------------------------------------------------------

	IF lAbonos

		IF ( dbfAbnCliT )->( dbSeek( cCodCli ) )

			WHILE ( dbfAbnCliT )->( !Eof() ) .AND. Year( ( dbfAbnCliT )->DFECFAC ) == nYear

				nTotImport -= nTotAbnCli( dbfAbnCliT, dbfAbnCliL, dbfIva, ( dbfAbnCliT )->NNUMFAC )
				( dbfAbnCliT )->( dbSkip() )

			END WHILE

		END IF

	END IF

	( dbfAbnCliT )->( OrdSetFocus( nAbnOrdAnt ) )
   */

	IF !( nTotImport > nImporte )
		lReturn 	:= .f.
	END IF

RETURN ( lReturn )

//------------------------------------------------------------------------//