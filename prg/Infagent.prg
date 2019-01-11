#include "FiveWin.Ch"
#include "Font.ch"
#include "Report.ch"
#include "Factu.ch" 

static dbfFacCliT
static dbfClient
static dbfAgente
static dbfFacPago
static dbfAlbCliT
static dbfAlbCliL
static dbfTVta
static dbfDiv
static dbfIva

//---------------------------------------------------------------------------//

FUNCTION InfLqdAgn()

   local oBlock
   local oError
	local oDlg
	local oBtnImpr
	local oBtnCancel
	local oAgeDesde
	local oAgeHasta
	local oDesde
	local oHasta
	local oGetDesde
	local oGetHasta
   local cGetDesde
   local cGetHasta
	local lSerieA		:= .T.
	local lSerieB		:= .T.
	local nTipCalculo	:= 1
	local cAgeDesde	:= "000"
	local cAgeHasta	:= "000"
	local dDesde		:= CtoD( "01/" + Str( Month( Date() ), 2 ) + "/" + Str( Year( Date() ) ) )
	local dHasta		:= Date()
   local oBtnPrev

	/*
	Bases de datos para el informe
	*/

	dbCommitAll()

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   TDataCenter():OpenFacCliT( @dbfFacCliT )

   USE ( cPatEmp() + "FACCLIP.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACCLIP", @dbfFacPago ) )
   SET ADSINDEX TO ( cPatEmp() + "FACCLIP.CDX" ) ADDITIVE

   USE ( cPatCli() + "AGENTES.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "AGENTES", @dbfAgente ) )
   SET ADSINDEX TO ( cPatCli() + "AGENTES.CDX" ) ADDITIVE

   USE ( cPatDat() + "DIVISAS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "DIVISAS", @dbfDiv ) )
   SET ADSINDEX TO ( cPatDat() + "DIVISAS.CDX" ) ADDITIVE

   USE ( cPatDat() + "TIVA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIVA", @dbfIva ) )
      SET ADSINDEX TO ( cPatDat() + "TIVA.CDX" ) ADDITIVE

	/*
	Obtenemos los valores del primer y ultimo codigo
	*/

	cAgeDesde	:= dbFirst( dbfAgente, 1 )
	cAgeHasta	:= dbLast(  dbfAgente, 1 )

	/*
	Caja de dialogo
	*/

	DEFINE DIALOG oDlg RESOURCE "INF_LQDAGENTES"

	REDEFINE GET oDesde VAR dDesde;
		ID 		110 ;
		OF 		oDlg

	REDEFINE GET oHasta VAR dHasta;
		ID 		120 ;
		OF 		oDlg

	REDEFINE GET oAgeDesde VAR cAgeDesde ;
		VALID 	( cAgentes( oAgeDesde, dbfAgente, oGetDesde ) );
      BITMAP   "LUPA" ;
      ON HELP  ( BrwAgentes( oAgeDesde, oGetDesde ) );
		ID 		130 ;
		OF 		oDlg

   REDEFINE GET oGetDesde VAR cGetDesde;
		WHEN 		.F. ;
		ID 		131 ;
		OF 		oDlg

	REDEFINE GET oAgeHasta VAR cAgeHasta ;
		VALID 	( cAgentes( oAgeHasta, dbfAgente, oGetHasta ) );
      BITMAP   "LUPA" ;
      ON HELP  ( BrwAgentes( oAgeHasta, oGetHasta ) );
		ID 		140 ;
		OF 		oDlg

   REDEFINE GET oGetHasta VAR cGetHasta;
		WHEN 		.F. ;
		ID 		141 ;
		OF 		oDlg

	REDEFINE CHECKBOX lSerieA ;
		ID 		150 ;
		OF 		oDlg

	REDEFINE CHECKBOX lSerieB ;
		ID 		151 ;
		OF 		oDlg

	REDEFINE RADIO nTipCalculo ;
		ID 		160, 161 ;
		OF 		oDlg

	REDEFINE BUTTON oBtnPrev ;
		ID 		508;
		OF 		oDlg ;
      ACTION ( oDlg:disable(),;
					GenLqdAge( cAgeDesde, cAgeHasta, dDesde, dHasta, lSerieA, lSerieB, 1 ),;
               oDlg:enable() )

	REDEFINE BUTTON oBtnImpr ;
		ID 		505;
		OF 		oDlg ;
      ACTION ( oDlg:disable(),;
					GenLqdAge( cAgeDesde, cAgeHasta, dDesde, dHasta, lSerieA, lSerieB, 2 ),;
               oDlg:enable() )

	REDEFINE BUTTON oBtnCancel ;
		ID 		510;
		OF 		oDlg ;
		ACTION ( oDlg:end() )

	ACTIVATE DIALOG oDlg CENTER ON PAINT ( oAgeDesde:lValid(), oAgeHasta:lValid() )

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

	CLOSE ( dbfFacCliT )
	CLOSE ( dbfFacPago )
	CLOSE ( dbfAgente  )

RETURN NIL

//---------------------------------------------------------------------------//

STATIC FUNCTION GenLqdAge( cAgeDesde, cAgeHasta, dDesde, dHasta, lSerieA, lSerieB, nDevice )

	local oFont1
	local oFont2
   local oReport

	( dbfAgente )->( dbSeek( cAgeDesde ) )

	/*
	Tipos de Letras
	*/

	DEFINE FONT oFont1 NAME "Courier New" SIZE 0,-12 BOLD
   DEFINE FONT oFont2 NAME "Courier New" SIZE 0,-10

	IF nDevice == 1

		REPORT oReport ;
         TITLE    "Informe de liquidación de agentes", "" ;
			FONT   	oFont1, oFont2 ;
			HEADER	"Fecha Informe : " + dToC( date() ) ,;
						"Periodo Fecha : " + dToC( dDesde ) + " - " + dToC( dHasta ) RIGHT ;
         FOOTER   "Página : " + str( oReport:nPage, 3 ) CENTERED;
         CAPTION  "Liquidación de agentes";
			PREVIEW

	ELSE

		REPORT oReport ;
         TITLE    "Informe de liquidación de agentes", "" ;
			FONT   	oFont1, oFont2 ;
			HEADER	"Fecha Informe : " + dToC( date() ) ,;
						"Periodo Fecha : " + dToC( dDesde ) + " - " + dToC( dHasta ) RIGHT ;
         FOOTER   "Página : " + str( oReport:nPage, 3 ) CENTERED;
         CAPTION  "Liquidación de agentes";
         TO PRINTER

	END IF

   COLUMN TITLE "Codigo" ;
			DATA (dbfAgente)->CCODAGE ;
			SIZE 10 ;
			FONT 2

	COLUMN TITLE "Nombre" ;
			DATA RTrim( (dbfAgente)->CAPEAGE ) + ", " + RTrim( (dbfAgente)->CNBRAGE ) ;
         SIZE 40 ;
			FONT 2

	COLUMN TITLE "Importe" ;
			DATA nTotAgente( (dbfAgente)->CCODAGE, dDesde, dHasta, lSerieA, lSerieB ) ;
			PICTURE "@E 999,999,999" ;
			SIZE 10 ;
			FONT 2

	END REPORT

   IF !Empty( oReport ) .and.  oReport:lCreated
		oReport:Margin( 0, RPT_RIGHT, RPT_CMETERS )
		oReport:bSkip	:= {|| (dbfAgente)->(DbSkip( 1 )) }
	END IF

	ACTIVATE REPORT oReport;
		FOR (dbfAgente)->CCODAGE >= cAgeDesde .AND. (dbfAgente)->CCODAGE <= cAgeHasta ;
		WHILE !(dbfAgente)->(Eof())

	oFont1:end()
	oFont2:end()

RETURN NIL

//---------------------------------------------------------------------------//

STATIC FUNCTION nTotAgente( cCodAge, dFechaIni, dFechaFin, lSerieA, lSerieB, nCobrado )

	local nTotal 		:= 0
	local nOrdAnt		:= ( dbfFacCliT )->( OrdSetFocus( "CCODAGE" ) )

	DEFAULT nCobrado 	:= 1
	DEFAULT lSerieA 	:= .T.
	DEFAULT lSerieB 	:= .T.

	IF ( dbfFacCliT )->( dbSeek( cCodAge ) )

		WHILE ( dbfFacCliT )->( !Eof() ) .AND. ( dbfFacCliT )->DFECFAC <= dFechaFin

			IF ( dbfFacCliT )->CCODAGE == cCodAge .AND. ;
				( ( dbfFacCliT )->CSERIE == "A" .AND. lSerieA ) .OR. ;
				( ( dbfFacCliT )->CSERIE == "B" .AND. lSerieB )

				/*
				Buscamos si hay pagos en la factura
				*/

				IF ( dbfFacPago )->( dbSeek( ( dbfFacCliT )->CSERIE + Str( ( dbfFacCliT )->NNUMFAC ) ) )

					WHILE ( dbfFacPago )->( ! Eof() ) .AND. ( ( dbfFacCliT )->CSERIE + Str( ( dbfFacCliT )->NNUMFAC ) == ( dbfFacPago )->CSERIE + Str( ( dbfFacPago )->NNUMFAC ) )

						IF ( dbfFacPago )->DENTRADA >= dFechaIni .AND. ( dbfFacPago )->DENTRADA <= dFechaFin
							nTotal += ( dbfFacPago )->NIMPORTE
						END IF

						( dbfFacPago )->( dbSkip() )

					END WHILE

				END IF

			END IF

			( dbfFacCliT )->( dbSkip() )

		END WHILE

	END IF

	( dbfFacCliT )->( OrdSetFocus( nOrdAnt ) )

RETURN ( nTotal )

//--------------------------------------------------------------------------//

FUNCTION InfLqdDetAgn()

   local oBlock
   local oError
	local oDlg
	local oBtnImpr
	local oBtnCancel
	local oAgeDesde
	local oAgeHasta
	local oDesde
	local oHasta
	local oGetDesde
	local oGetHasta
   local cGetDesde
   local cGetHasta
   local oGet1
   local cGet1
   local oGet2
   local cGet2       := "TODOS"
	local lRes			:= .f.
   local lTvta       := .f.
	local cAgeDesde	:= "00000"
	local cAgeHasta	:= "00000"
	local dDesde		:= CtoD( "01/" + Str( Month( Date() ), 2 ) + "/" + Str( Year( Date() ) ) )
	local dHasta		:= Date()
   local oBtnPrev

	/*
	Bases de datos para el informe
	*/

	dbCommitAll()

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   USE ( cPatEmp() + "ALBCLIT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACCLIT", @dbfAlbCliT ) )
   SET ADSINDEX TO ( cPatEmp() + "ALBCLIT.CDX" ) ADDITIVE
	SET TAG TO "CCODAGE"

   USE ( cPatEmp() + "ALBCLIL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACCLIL", @dbfAlbCliL ) )
   SET ADSINDEX TO ( cPatEmp() + "ALBCLIL.CDX" ) ADDITIVE

   USE ( cPatCli() + "CLIENT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CLIENT", @dbfClient ) )
   SET ADSINDEX TO ( cPatCli() + "CLIENT.CDX" ) ADDITIVE

   USE ( cPatCli() + "AGENTES.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "AGENTES", @dbfAgente ) )
   SET ADSINDEX TO ( cPatCli() + "AGENTES.CDX" ) ADDITIVE

   USE ( cPatDat() + "TVTA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TVTA", @dbfTVta ) )
   SET ADSINDEX TO ( cPatDat() + "TVTA.CDX" ) ADDITIVE

	/*

	Obtenemos los valores del primer y ultimo codigo
	*/

	cAgeDesde	:= dbFirst( dbfAgente, 1 )
	cAgeHasta	:= dbLast(  dbfAgente, 1 )

	/*
	Caja de dialogo
	*/

   DEFINE DIALOG oDlg RESOURCE "INF_LQDAGE" TITLE "Liquidación de agentes sobre albaranes"

	REDEFINE GET oDesde VAR dDesde;
		ID 		110 ;
		OF 		oDlg

	REDEFINE GET oHasta VAR dHasta;
		ID 		120 ;
		OF 		oDlg

	REDEFINE GET oAgeDesde VAR cAgeDesde ;
		VALID 	( cAgentes( oAgeDesde, dbfAgente, oGetDesde ) );
      BITMAP   "LUPA" ;
      ON HELP  ( BrwAgentes( oAgeDesde, oGetDesde ) );
		ID 		130 ;
		OF 		oDlg

   REDEFINE GET oGetDesde VAR cGetDesde;
		WHEN 		.F. ;
		ID 		131 ;
		OF 		oDlg

	REDEFINE GET oAgeHasta VAR cAgeHasta ;
		VALID 	( cAgentes( oAgeHasta, dbfAgente, oGetHasta ) );
      BITMAP   "LUPA" ;
      ON HELP  ( BrwAgentes( oAgeHasta, oGetHasta ) );
		ID 		140 ;
		OF 		oDlg

   REDEFINE GET oGetHasta VAR cGetHasta;
		WHEN 		.F. ;
		ID 		141 ;
		OF 		oDlg

	REDEFINE CHECKBOX lRes ;
		ID 		150 ;
		OF 		oDlg

   REDEFINE CHECKBOX lTvta ;
      ID       151 ;
		OF 		oDlg

   REDEFINE GET oGet1 VAR cGet1 ;
      WHEN     ( lTvta ) ;
      VALID    ( cTVta( oGet1, dbfTVta, oGet2 ) ) ;
      BITMAP   "LUPA" ;
      ON HELP  ( BrwTVta( oGet1, dbfTVta, oGet2 ) ) ;
      ID       160 ;
      OF       oDlg

   REDEFINE GET oGet2 VAR cGet2 ;
      ID       161 ;
      WHEN     ( .F. ) ;
      COLOR    CLR_GET ;
      OF       oDlg

	REDEFINE BUTTON oBtnPrev ;
		ID 		508;
		OF 		oDlg ;
      ACTION ( oDlg:disable(),;
               MakLqdDetAge( cAgeDesde, cAgeHasta, dDesde, dHasta, lRes, lTvta, cGet1, 1 ),;
               oDlg:enable() )

	REDEFINE BUTTON oBtnImpr ;
		ID 		505;
		OF 		oDlg ;
      ACTION ( oDlg:disable(),;
               MakLqdDetAge( cAgeDesde, cAgeHasta, dDesde, dHasta, lRes, lTvta, cGet1, 2 ),;
               oDlg:enable() )

	REDEFINE BUTTON oBtnCancel ;
		ID 		510;
		OF 		oDlg ;
		ACTION ( oDlg:end() )

	ACTIVATE DIALOG oDlg CENTER ON PAINT ( oAgeDesde:lValid(), oAgeHasta:lValid() )

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

	CLOSE ( dbfAlbCliT )
	CLOSE ( dbfAlbCliL )
	CLOSE ( dbfClient  )
	CLOSE ( dbfAgente  )
   CLOSE ( dbfTVta    )

RETURN NIL

//---------------------------------------------------------------------------//
/*
Elaboraci¢n de base de datos temporal para la confecci¢n de listados
*/

STATIC FUNCTION MakLqdDetAge( cAgeDesde, cAgeHasta, dDesde, dHasta, lRes, lTvta, cCod, nDevice )


	local dbfTmp
   local nUndCaj
   local nUndArt
   local nComAge
   local nBasCom
   local nTotCom
   local nComUnd  := 1
   local nComImp  := 1
   local aDbf     := {  { "CCODAGE", "C",  3, 0 },;
                        { "CCODCLI", "C", 12, 0 },;
								{ "CNOMCLI", "C", 50, 0 },;
								{ "CCODALB", "C", 12, 0 },;
                        { "CCSUALB", "C", 12, 0 },;
								{ "DFECALB", "D",  8, 0 },;
                        { "NUNDCAJ", "N", 16, 6 },;
                        { "NUNDART", "N", 16, 6 },;
                        { "CREFART", "C", 18, 0 },;
                        { "CCODMOV", "C",  2, 0 },;
                        { "CDESART", "C", 50, 0 },;
								{ "NBASCOM", "N", 13, 0 },;
								{ "NCOMAGE", "N",  4, 1 },;
								{ "NTOTCOM", "N", 13, 0 } }

   CursorWait()

   dbCreate( cPatTmp() + "INFAGE.DBF", aDbf, cDriver() )
   dbUseArea( .t., cDriver(), cPatTmp() + "INFAGE.DBF", cCheckArea( "INFAGE", @dbfTmp ), .f. )

	IF !lRes
      ordCreate(  cPatTmp() + "INFAGE.CDX", "DFECALB", "Field->DFECALB", {|| Field->DFECALB } )
	ELSE
      ordCreate(  cPatTmp() + "INFAGE.CDX", "CCODAGE + CREFART", "Field->CCODAGE + Field->CREFART", {|| Field->CCODAGE + Field->CREFART } )
	END IF

   ordListAdd( cPatTmp() + "INFAGE.CDX" )

   (dbfAlbCliT)->( dbSeek( cAgeDesde ) )

   WHILE (dbfAlbCliT)->CCODAGE >= cAgeDesde .AND.;
			(dbfAlbCliT)->CCODAGE <= cAgeHasta .AND.;
         (dbfAlbCliT)->(!eof())

			IF (dbfAlbCliT)->DFECALB >= dDesde .AND.;
				(dbfAlbCliT)->DFECALB <= dHasta

				/*
				Posicionamos en las lineas de detalle
				*/

            (dbfAlbCliL)->( dbSeek( (dbfAlbCliT)->CSERALB + Str( (dbfAlbCliT)->NNUMALB ) + (dbfAlbCliT)->CSUFALB ) )

               WHILE (dbfAlbCliT)->CSERALB + Str( (dbfAlbCliT)->NNUMALB ) + (dbfAlbCliT)->CSUFALB == (dbfAlbCliL)->CSERALB + Str( (dbfAlbCliL)->NNUMALB ) + (dbfAlbCliT)->CSUFALB .AND.;
                     (dbfAlbCliL)->( !eof() )

                     IF lTvta
                        nComUnd  := nVtaUnd( ( dbfAlbCliL )->CTIPMOV, dbfTVta )
                        nComImp  := nVtaImp( ( dbfAlbCliL )->CTIPMOV, dbfTVta )
                        nUndCaj  := abs( ( dbfAlbCliL )->NCANENT ) * nComUnd
                        nUndArt  := abs( nUnitEnt( dbfAlbCliL ) ) * nComUnd
                        nComAge  := abs( ( dbfAlbCliL )->NCOMAGE ) * nComImp
                        nBasCom  := aTotAlbCli( ( dbfAlbCliT )->CSERALB + Str( ( dbfAlbCliT )->NNUMALB ) + ( dbfAlbCliT )->CSUFALB, dbfAlbCliT, dbfAlbCliL, dbfIva, dbfDiv, cDivEmp(),.t. ) * nComImp
                        nTotCom  := ( nBasCom * ( dbfAlbCliL )->NCOMAGE / 100 ) * nComImp
                     ELSE
                        nUndCaj  := ( dbfAlbCliL )->NCANENT
                        nUndArt  := nUnitEnt( dbfAlbCliL )
                        nComAge  := ( dbfAlbCliL )->NCOMAGE
                        nBasCom  := aTotAlbCli( ( dbfAlbCliT )->CSERALB + Str( ( dbfAlbCliT )->NNUMALB ) + ( dbfAlbCliT )->CSUFALB, dbfAlbCliT, dbfAlbCliL, dbfIva, dbfDiv, cDivEmp(),.t. ) * nComImp
                        nTotCom  := ( nBasCom * ( dbfAlbCliL )->NCOMAGE / 100 ) * nComImp
                     END IF

                     IF ( lTvta .AND. ( ( dbfAlbCliL )->CTIPMOV == cCod .OR. empty( cCod ) ) ) .OR. ;
                        !lTvta

                        IF !lRes

                           ( dbfTmp )->( dbAppend() )
                           ( dbfTmp )->CCODAGE := ( dbfAlbCliT )->CCODAGE
                           ( dbfTmp )->CCODCLI := ( dbfAlbCliT )->CCODCLI
                           ( dbfTmp )->CNOMCLI := ( dbfAlbCliT )->CNOMCLI
                           ( dbfTmp )->CCODALB := ( dbfAlbCliT )->CSERALB + Str( (dbfAlbCliT)->NNUMALB ) + (dbfAlbCliT)->CSUFALB
                           ( dbfTmp )->CCSUALB := ( dbfAlbCliT )->CCODSUALB
                           ( dbfTmp )->DFECALB := ( dbfAlbCliT )->DFECALB
                           ( dbfTmp )->NUNDCAJ := nUndCaj
                           ( dbfTmp )->NUNDART := nUndArt
                           ( dbfTmp )->CREFART := ( dbfAlbCliL )->CREF
                           ( dbfTmp )->CDESART := ( dbfAlbCliL )->CDETALLE
                           ( dbfTmp )->CCODMOV := ( dbfAlbCliL )->CTIPMOV        //NUEVO
                           ( dbfTmp )->NBASCOM := nBasCom
                           ( dbfTmp )->NCOMAGE := nComAge
                           ( dbfTmp )->NTOTCOM := nTotCom

                        ELSE

                           IF ( dbfTmp )->( dbSeek( ( dbfAlbCliT )->CCODAGE + ( dbfAlbCliL )->CREF ) )

                              ( dbfTmp )->NUNDCAJ += nUndCaj
                              ( dbfTmp )->NUNDART += nUndArt
                              ( dbfTmp )->NBASCOM += nBasCom
                              ( dbfTmp )->NTOTCOM += nTotCom

                           ELSE

                              ( dbfTmp )->( dbAppend() )
                              ( dbfTmp )->CCODAGE := ( dbfAlbCliT )->CCODAGE
                              ( dbfTmp )->CCODCLI := ( dbfAlbCliT )->CCODCLI
                              ( dbfTmp )->CNOMCLI := ( dbfAlbCliT )->CNOMCLI
                              ( dbfTmp )->CCODALB := ( dbfAlbCliT )->CSERALB + Str( ( dbfAlbCliT )->NNUMALB ) + ( dbfAlbCliT )->CSUFALB
                              ( dbfTmp )->CCSUALB := ( dbfAlbCliT )->CCODSUALB
                              ( dbfTmp )->DFECALB := ( dbfAlbCliT )->DFECALB
                              ( dbfTmp )->CREFART := ( dbfAlbCliL )->CREF
                              ( dbfTmp )->CDESART := ( dbfAlbCliL )->CDETALLE
                              ( dbfTmp )->NUNDCAJ := nUndCaj
                              ( dbfTmp )->NUNDART := nUndArt
                              ( dbfTmp )->CCODMOV := ( dbfAlbCliL )->CTIPMOV        //NUEVO
                              ( dbfTmp )->NBASCOM := nBasCom
                              ( dbfTmp )->NTOTCOM := nTotCom

                           END IF

                        END IF

                     END IF

                  ( dbfAlbCliL )->( dbSkip() )

               END DO

			END IF

         ( dbfAlbCliT )->( dbSkip() )

	END DO

   CursorWe()

	/*
	Lanzamos la ejecici¢n del listado si estamos dentro de las condiciones solicitadas
	*/

	IF ( dbfTmp )->( recCount() ) > 0
      GenLqdDetAge( dbfTmp, dDesde, dHasta, lRes, lTvta, nDevice )
	ELSE
		MsgStop( "No existen registros en las condiciones pedidas" )
	END IF

	( dbfTmp )->( dbCloseArea() )
   ferase( cPatTmp() + "INFAGE.DBF" )

RETURN NIL

//---------------------------------------------------------------------------//

STATIC FUNCTION GenLqdDetAge( dbfTmp, dDesde, dHasta, lRes, lTvta, nDevice )

	local oFont1
	local oFont2
	local oReport

	( dbfTmp )->( dbGoTop() )

	/*
	Tipos de Letras
	*/

	DEFINE FONT oFont1 NAME "Courier New" SIZE 0,-12 BOLD
   DEFINE FONT oFont2 NAME "Arial" SIZE 0,-8

	IF nDevice == 1

		REPORT oReport ;
         TITLE    "Informe de comisiones de agentes por albaranes",;
                  if( lTvta, "Aplicando tipo de venta", "" ) ;
			FONT   	oFont1, oFont2 ;
			HEADER	"Fecha Informe : " + dToC( date() ) ,;
						"Periodo Fecha : " + dToC( dDesde ) + " - " + dToC( dHasta ) RIGHT ;
         FOOTER   "Página : " + str( oReport:nPage, 3 ) CENTERED;
			CAPTION 	"Liquidación de Agentes";
			PREVIEW

	ELSE

		REPORT oReport ;
         TITLE    "Informe de comisiones de agentes por albaranes", ;
                  if( lTvta, "Aplicando tipo de venta", "" ) ;
			FONT   	oFont1, oFont2 ;
			HEADER	"Fecha Informe : " + dToC( date() ) ,;
						"Periodo Fecha : " + dToC( dDesde ) + " - " + dToC( dHasta ) RIGHT ;
         FOOTER   "Página : " + str( oReport:nPage, 3 ) CENTERED;
			CAPTION 	"Liquidación de Agentes";
         TO PRINTER

	END IF

	IF !lRes

	COLUMN TITLE "Cliente" ;
			DATA (dbfTmp)->CCODCLI ;
			SIZE 8 ;
			FONT 2

	COLUMN TITLE "Nombre" ;
			DATA (dbfTmp)->CNOMCLI ;
			SIZE 26 ;
			FONT 2

   COLUMN TITLE "Albaran" ;
			DATA (dbfTmp)->CCODALB ;
			SIZE 10 ;
			FONT 2

/*
	COLUMN TITLE "Su Alb." ;
         DATA (dbfTmp)->CCSUALB ;
			SIZE 10 ;
			FONT 2
*/

	COLUMN TITLE "Fecha" ;
			DATA (dbfTmp)->DFECALB ;
			SIZE 6 ;
			FONT 2

	END IF

   if lUseCaj()

	COLUMN TITLE "Cajas" ;
			DATA ( dbfTmp )->NUNDCAJ;
         PICTURE PicOut();
			SIZE 6 ;
			TOTAL ;
			FONT 2

   end if

	COLUMN TITLE "Uds." ;
			DATA (dbfTmp)->NUNDART;
         PICTURE MasUnd();
			SIZE 6 ;
			TOTAL ;
			FONT 2

   IF !lRes


/*
   COLUMN TITLE  "Venta";
         DATA retTVta( dbfTVta, (dbfTmp)->CCODMOV ) ;
         FONT 2 ;
         SIZE 10
 */

   END IF

	COLUMN TITLE "Articulo" ;
			DATA (dbfTmp)->CDESART ;
			SIZE 40 ;
			FONT 2

	COLUMN TITLE "Base Com" ;
			DATA (dbfTmp)->NBASCOM ;
         PICTURE PicOut();
			SIZE 8 ;
			TOTAL ;
			FONT 2

	IF !lRes

	COLUMN TITLE "%Com" ;
			DATA (dbfTmp)->NCOMAGE ;
			PICTURE "@E 99.99";
			SIZE 4 ;
			FONT 2

	COLUMN TITLE "Comis." ;
			DATA (dbfTmp)->NTOTCOM ;
         PICTURE PicOut();
			SIZE 8 ;
			TOTAL ;
			FONT 2

	ELSE

	COLUMN TITLE "Comis." ;
			DATA (dbfTmp)->NTOTCOM ;
         PICTURE PicOut();
			SIZE 8 ;
			TOTAL ;
			FONT 2

	END IF

	GROUP ON (dbfTmp)->CCODAGE;
         HEADER   "Codigo : " + oReport:aGroups[1]:cValue + "-" + ;
						retNbrAge( oReport:aGroups[1]:cValue, dbfAgente );
			FOOTER 	if( lRes, "", ( "Total de Movimientos (" + ltrim( str( oReport:aGroups[1]:nCounter ) ) + ")" ) ) ;
			FONT 2

	END REPORT

	IF oReport:lCreated
      msgWait( , , .01 )
		oReport:Margin( 0, RPT_RIGHT, RPT_CMETERS )
		oReport:Margin( 0, RPT_LEFT, RPT_CMETERS )
      oReport:bSkip     := {|| ( dbfTmp )->( dbSkip( 1 ) ) }
	END IF

   ACTIVATE REPORT oReport ;
      ON STARTGROUP oReport:NewLine() ;
      WHILE !( dbfTmp )->( eof() )

	oFont1:end()
	oFont2:end()

RETURN NIL

//---------------------------------------------------------------------------//