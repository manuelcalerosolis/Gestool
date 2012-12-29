#include "FiveWin.Ch"
#include "Font.ch"
#include "Report.ch"
#include "Factu.ch"

static dbfFacCliT
static dbfFacCliL
static dbfClient
static dbfIva
static dbfPago
static dbfAgente
static dbfRuta

STATIC FUNCTION nTotal( cFactura )

	local nIva
	local nTotalArt
	local nTotalDtoArt:= 0
	local nTotalIva 	:= 0
	local nTotalImp   := 0
	local nTotalFac 	:= 0
	local nTotalDto 	:= 0
	local nTotalNet 	:= 0
	local nRecno    	:= (dbfFacCliL)->(RECNO())

	DEFAULT cFactura	:= (dbfFacCliT)->CSERIE + Str( (dbfFacCliT)->NNUMFAC )

	IF cFactura != NIL

		IF (dbfFacCliL)->(DbSeek( cFactura, .t. ) )

			WHILE ( (dbfFacCliL)->CSERIE + Str( (dbfFacCliL)->NNUMFAC ) = cFactura )

				nTotalArt    = nTotLFacCli( dbfFacCliL )
				nTotalDtoArt = 0
				nTotalImp    = 0

				IF (dbfFacCliL)->NDTO != 0
					nTotalArt  -= Round( nTotalArt * (dbfFacCliL)->NDTO / 100 , 0)
				END IF

				nTotalNet += nTotalArt

				/*
				Descuentos
				*/

				IF (dbfFacCliT)->NDTOESP != 0
					nTotalDtoArt += Round( nTotalArt * (dbfFacCliT)->NDTOESP / 100, 0 )
				END IF

				IF (dbfFacCliT)->NDPP  != 0
					nTotalDtoArt += Round( nTotalArt * (dbfFacCliT)->NDPP / 100, 0 )
				END IF

				nTotalArt -= nTotalDtoArt

				nTotalIva += Round( nTotalArt * nIva( dbfIva, (dbfFacCliL)->NIVA ) / 100, 0 )
				nTotalImp += Round( nTotalArt * nIva( dbfIva, (dbfFacCliL)->NIVA ) / 100, 0 )

				IF (dbfFacCliT)->LRECARGO
					nTotalImp += Round( nTotalArt * nPReq( dbfIva, (dbfFacCliL)->NIVA ) / 100, 0 )
				END IF

				nTotalArt += nTotalImp

				(dbfFacCliL)->(DBSKIP())

				nTotalFac += nTotalArt

			END WHILE

		END IF

		(dbfFacCliL)->(DBGOTO(nRecno))

		nTotalFac += (dbfFacCliT)->NPORTES

	END IF

RETURN ( nTotalFac )

//--------------------------------------------------------------------------//

STATIC FUNCTION nTotPagado( cFactura )

	local nTotalPagado	:= 0
	local nRecno			:= (dbfPago)->(RecNo())

	DEFAULT cFactura		:= (dbfFacCliT)->CSERIE + Str( (dbfFacCliT)->NNUMFAC )

	IF (dbfPago)->( DbSeek( cFactura, .t. ) )

		WHILE ( (dbfPago)->CSERIE + Str((dbfPago)->NNUMFAC ) = cFactura )

			nTotalPagado += (dbfPago)->NIMPORTE
			(dbfPago)->(DbSkip())

		END WHILE

	END IF

	(dbfPago)->( DbGoTo( nRecNo ) )

RETURN nTotalPagado

//---------------------------------------------------------------------------//

FUNCTION InfArticulo()

	local oDlg
	local oArticulo, cArticulo
	local oSay, cSay
	local oDesde, dDesde
	local oHasta, dHasta
	local oMeter, nMeter	:= 0
	local aoInfo	:= { { , , }, { , , }, { , , } }
	local anInfo	:= { {0,0,0}, {0,0,0}, {0,0,0} }

	dDesde	:= CtoD( "01/01/" + Str( Year( Date() ) ) )
	dHasta	:= Date()

	/*
	Caja de dialogo
	*/

	DEFINE DIALOG oDlg RESOURCE "INFARTICULO"

	REDEFINE GET oArticulo VAR cArticulo;
		ID 110 ;
		VALID cArticulo( oArticulo, , oSay );
		ON HELP ( BrwArticulo( oArticulo, , oSay ) );
		OF oDlg

   REDEFINE GET oSay VAR cSay ;
		WHEN ( .F. ) ;
		ID 120 ;
		OF oDlg

	REDEFINE GET oDesde VAR dDesde;
		ID 130 ;
		OF oDlg

	REDEFINE GET oHasta VAR dHasta;
		ID 140 ;
		OF oDlg

	REDEFINE GET aoInfo[1,1] VAR anInfo[1,1];
		ID 150;
		PICTURE "@E 999,999,999";
		OF oDlg

	REDEFINE GET aoInfo[1,2] VAR anInfo[1,2];
		ID 160;
		PICTURE "@E 999,999,999";
		OF oDlg

	REDEFINE GET aoInfo[1,3] VAR anInfo[1,3];
		ID 170;
		PICTURE "@E 999,999,999";
		OF oDlg

	REDEFINE GET aoInfo[2,1] VAR anInfo[2,1];
		ID 180;
		PICTURE "@E 999,999,999";
		OF oDlg

	REDEFINE GET aoInfo[2,2] VAR anInfo[2,2];
		ID 190;
		PICTURE "@E 999,999,999";
		OF oDlg

	REDEFINE GET aoInfo[2,3] VAR anInfo[2,3];
		ID 200;
		PICTURE "@E 999,999,999";
		OF oDlg

	REDEFINE GET aoInfo[3,1] VAR anInfo[3,1];
		ID 210;
		PICTURE "@E 999,999,999";
		OF oDlg

	REDEFINE GET aoInfo[3,2] VAR anInfo[3,2];
		ID 220;
		PICTURE "@E 999,999,999";
		OF oDlg

	REDEFINE GET aoInfo[3,3] VAR anInfo[3,3];
		ID 230;
		PICTURE "@E 999,999,999";
		OF oDlg

	REDEFINE METER oMeter VAR nMeter ;
		PROMPT "Calculando Entradas" ;
		ID 240 ;
		OF oDlg

	REDEFINE BUTTON oBtnOk ;
      ID       IDOK;
      OF       oDlg ;
      ACTION   ( oBtnOk:disable(),;
					oBtnCancel:disable(),;
					Calcula( cArticulo, dDesde, dHasta, oMeter, aoInfo, anInfo ),;
					oBtnOk:enable(),;
					oBtnCancel:enable() )

	REDEFINE BUTTON oBtnCancel ;
      ID       CANCEL ;
      OF       oDlg ;
      ACTION   ( oDlg:end() )

	ACTIVATE DIALOG oDlg CENTER

RETURN NIL

//---------------------------------------------------------------------------//

STATIC FUNCTION Calcula( cArticulo, dDesde, dHasta, oMeter, aoInfo, anInfo )

	local dbfFacPrvT
	local dbfFacPrvL
	local dbfFacCliT
	local dbfFacCliL

	anInfo[1,1] := 0
	anInfo[1,2] := 0
	anInfo[1,3] := 0
	anInfo[2,1] := 0
	anInfo[2,2] := 0
	anInfo[2,3] := 0
	anInfo[3,1] := 0
	anInfo[3,2] := 0
	anInfo[3,3] := 0

	aoInfo[1,1]:refresh()
	aoInfo[1,2]:refresh()
	aoInfo[1,3]:refresh()
	aoInfo[2,1]:refresh()
	aoInfo[2,2]:refresh()
	aoInfo[2,3]:refresh()
	aoInfo[3,1]:refresh()
	aoInfo[3,2]:refresh()
	aoInfo[3,3]:refresh()

   USE ( cPatEmp() + "FACPRVT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACPRVT", @dbfFacPrvT ) )
   SET ADSINDEX TO ( cPatEmp() + "FACPRVT.CDX" ) ADDITIVE

   USE ( cPatEmp() + "FACPRVL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACPRVL", @dbfFacPrvL ) )
   SET ADSINDEX TO ( cPatEmp() + "FACPRVL.CDX" ) ADDITIVE

	oMeter:nTotal 	:= ( dbfFacPrvT )->( LastRec() ) + 1
	oMeter:cText	:= "Procesando Entradas"
	sysrefresh()

	WHILE !( dbfFacPrvT )->( Eof() )
		IF ( dbfFacPrvT )->DFECFAC >= dDesde .AND. ( dbfFacPrvT )->DFECFAC <= dHasta
			IF ( dbfFacPrvL )->( dbSeek( ( dbfFacPrvT )->NNUMFAC ) )
				WHILE ( dbfFacPrvL )->NNUMFAC == ( dbfFacPrvT )->NNUMFAC
					IF ( dbfFacPrvL )->CREF = cArticulo
						anInfo[1,1] += ( dbfFacPrvL )->NCANENT
						anInfo[1,2] += ( dbfFacPrvL )->NUNICAJA * ( dbfFacPrvL )->NCANENT
						anInfo[1,3] += ( dbfFacPrvL )->NUNICAJA * ( dbfFacPrvL )->NCANENT * ( dbfFacPrvL )->NPREUNIT
					END IF
					( dbfFacPrvL )->( dbSkip() )
				END WHILE
			END IF
		END IF
		( dbfFacPrvT )->( dbSkip() )
		oMeter:set( ( dbfFacPrvT )->( RecNo() ) )
		sysrefresh()

	END WHILE

	CLOSE ( dbfFacPrvT )
	CLOSE ( dbfFacPrvL )

	aoInfo[1,1]:refresh()
	aoInfo[1,2]:refresh()
	aoInfo[1,3]:refresh()

   USE ( cPatEmp() + "FACCLIT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACPRVT", @dbfFacCliT ) )
   SET ADSINDEX TO ( cPatEmp() + "FACCLIT.CDX" ) ADDITIVE

   USE ( cPatEmp() + "FACCLIL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACPRVL", @dbfFacCliL ) )
   SET ADSINDEX TO ( cPatEmp() + "FACCLIL.CDX" ) ADDITIVE

	oMeter:nTotal 	:= ( dbfFacPrvT )->( LastRec() ) + 1
	oMeter:cText	:= "Procesando Salidas"
	sysrefresh()

	WHILE !( dbfFacCliT )->( Eof() )
		IF ( dbfFacCliT )->DFECFAC >= dDesde .AND. ( dbfFacCliT )->DFECFAC <= dHasta
			IF ( dbfFacCliL )->( dbSeek( ( dbfFacCliT )->CSERIE + Str( ( dbfFacCliT )->NNUMFAC ) ) )
				WHILE ( dbfFacCliL )->CSERIE + Str( ( dbfFacCliL )->NNUMFAC ) == ( dbfFacCliT )->CSERIE + Str( ( dbfFacCliT )->NNUMFAC )
					IF ( dbfFacCliL )->CREF = cArticulo
						anInfo[2,1] += ( dbfFacCliL )->NCANENT
						anInfo[2,2] += ( dbfFacCliL )->NUNICAJA * ( dbfFacCliL )->NCANENT
						anInfo[2,3] += ( dbfFacCliL )->NUNICAJA * ( dbfFacCliL )->NCANENT * ( dbfFacCliL )->NPREUNIT
					END IF
					( dbfFacCliL )->( dbSkip() )
				END WHILE
			END IF
		END IF
		( dbfFacCliT )->( dbSkip() )
		oMeter:set( ( dbfFacCliT )->( RecNo() ) )
		sysrefresh()

	END WHILE

	CLOSE ( dbfFacCliT )
	CLOSE ( dbfFacCliL )

	oMeter:nTotal	:= 0
	oMeter:cText	:= "Fin de Proceso"
	sysrefresh()

	aoInfo[2,1]:refresh()
	aoInfo[2,2]:refresh()
	aoInfo[2,3]:refresh()

	anInfo[3,1] := anInfo[1,1] - anInfo[2,1]
	anInfo[3,2] := anInfo[1,2] - anInfo[2,2]
	anInfo[3,3] := anInfo[2,3] - anInfo[1,3]

	aoInfo[3,1]:refresh()
	aoInfo[3,2]:refresh()
	aoInfo[3,3]:refresh()

RETURN NIL

//---------------------------------------------------------------------------//

FUNCTION RelArticulo()

	local dbfArticulo
	local oReport
	local oFont1, oFont2
	local xDesde, xHasta
	local nDevice	:= 1
	local cTexto 	:= Space(100)
   local aIndices := { "Codigo", "NOMBRE" }

   USE ( cPatArt() + "ARTICULO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ARTICULO", @dbfArticulo ) )
   SET ADSINDEX TO ( cPatArt() + "ARTICULO.CDX" ) ADDITIVE

	/*
	Llamada a la funcion que activa la caja de dialogo
	*/

	IF SetReport( dbfArticulo, "ARTICULO", aIndices, @xDesde, @xHasta, @cTexto, @nDevice )

		(dbfArticulo)->(DbSeek( xDesde ))

		/*
		Tipos de Letras
		*/

      DEFINE FONT oFont1 NAME "Arial" SIZE 0,-14 BOLD
      DEFINE FONT oFont2 NAME "Arial" SIZE 0,-14

		IF nDevice == 1

			REPORT oReport ;
				TITLE  "Listado de Artículos", "",	RTRIM(cTexto) ;
				FONT   oFont1, oFont2 ;
				HEADER "Fecha: " + dtoc(date()) RIGHT ;
				FOOTER OemtoAnsi("P gina : ")+str(oReport:nPage,3) CENTERED;
				CAPTION "Listado de Artículos";
				PREVIEW

		ELSE

			REPORT oReport ;
				TITLE  "Listado de Artículos", "",	RTRIM(cTexto) ;
				FONT   oFont1, oFont2 ;
				HEADER "Fecha: " + dtoc(date()) RIGHT ;
				FOOTER OemtoAnsi("P gina : ")+str(oReport:nPage,3) CENTERED;
				CAPTION "Listado de Artículos";
            TO PRINTER

		END IF

         COLUMN TITLE "Codigo" ;
				DATA (dbfArticulo)->CODIGO ;
				SIZE 12 ;
				FONT 2

			COLUMN TITLE "Descripción" ;
				DATA (dbfArticulo)->NOMBRE ;
				SIZE 38 ;
				FONT 2

		END REPORT

		IF oReport:lCreated
			oReport:Margin(0, RPT_RIGHT, RPT_CMETERS)
			oReport:bSkip	:= {|| (dbfArticulo)->(DbSkip( 1 )) }
		END IF

		ACTIVATE REPORT oReport;
			FOR (dbfArticulo)->(&(OrdKey())) >= xDesde .AND. (dbfArticulo)->(&(OrdKey())) <= xHasta ;
			WHILE !(dbfArticulo)->(Eof())

		oFont1:end()
		oFont2:end()

	END IF

	CLOSE ( dbfArticulo )

RETURN NIL

//--------------------------------------------------------------------------//

FUNCTION CalCostos()

	local oDlg
	local oMeter
	local dbfFacPrvT
	local dbfFacPrvL
	local dbfArticulo
	local nVal := 0

   USE ( cPatArt() + "ARTICULO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ARTICULO", @dbfArticulo ) )
   SET ADSINDEX TO ( cPatArt() + "ARTICULO.CDX" ) ADDITIVE

   USE ( cPatEmp() + "FACPRVT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACPRVT", @dbfFacPrvT ) )
   SET ADSINDEX TO ( cPatEmp() + "FACPRVT.CDX" ) ADDITIVE

   USE ( cPatEmp() + "FACPRVL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACPRVL", @dbfFacPrvL ) )
   SET ADSINDEX TO ( cPatEmp() + "FACPRVL.CDX" ) ADDITIVE

	oMeter:nTotal 	:= ( dbfFacPrvL )->( LastRec() ) + 1
	oMeter:cText	:= "Recalculo precios costos"
	sysrefresh()

	WHILE !( dbfFacPrvL )->( Eof() )
		( dbfFacPrvL )->( dbSkip() )
		oMeter:set( ( dbfFacPrvL )->( RecNo() ) )
		sysrefresh()
	END WHILE

	CLOSE ( dbfFacPrvT )
	CLOSE ( dbfFacPrvL )
	CLOSE ( dbfArticulo )

	oDlg:end()

RETURN NIL

//---------------------------------------------------------------------------//

Function InfDesCli()

	local oInf
	local oDlg
	local oGet1, oGet2, oGet3, oGet4
	local dDesde, dHasta, cCliDesde, cCliHasta
	local cNomCliDesde, cNomCliHasta
	local oFont1, oFont2, oFont3
	local nTipoFactura	:= 3

	dbCommitAll()

   USE ( cPatEmp() + "FACCLIT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACCLIT", @dbfFacCliT ) )
   SET ADSINDEX TO ( cPatEmp() + "FACCLIT.CDX" ) ADDITIVE

   USE ( cPatEmp() + "FACCLIL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACCLIL", @dbfFacCliL ) )
   SET ADSINDEX TO ( cPatEmp() + "FACCLIL.CDX" ) ADDITIVE

   USE ( cPatDat() + "TIVA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIVA", @dbfIva ) )
   SET ADSINDEX TO ( cPatDat() + "TIVA.CDX" ) ADDITIVE

	dDesde	:= CtoD( "01/01/" + Str( Year( Date() ) ) )
	dHasta	:= Date()

	DEFINE DIALOG oDlg RESOURCE "INFDESCLI"

	REDEFINE GET oGet1 VAR dDesde;
		ID 		110 ;
		OF 		oDlg

	REDEFINE GET oGet2 VAR dHasta;
		ID 		120 ;
		OF 		oDlg

	REDEFINE GET oGet3 VAR cCliDesde;
		ID 		130 ;
		VALID 	cClient( oGet3, dbfClient, oGet4 );
		ON HELP 	BrwClient( oGet3, oGet4 );
		OF 		oDlg

	REDEFINE BUTTON ;
		ID 		700 ;
		OF 		oDlg ;
		ACTION	( BrwClient( oGet3, oGet4 ) )

	REDEFINE GET oGet4 VAR cNomCliDesde;
		ID 		140 ;
		WHEN 		.F. ;
		OF 		oDlg

	REDEFINE GET oGet5 VAR cCliHasta;
		ID 		150 ;
		VALID 	cClient( oGet5, dbfClient, oGet6 );
		ON HELP 	BrwClient( oGet5, oGet6 );
		OF 		oDlg

	REDEFINE GET oGet6 VAR cNomCliHasta;
		ID 160 ;
		WHEN .F. ;
		OF oDlg

	REDEFINE RADIO nTipoFactura ;
		ID 170, 180, 190 ;
		OF oDlg

	REDEFINE BUTTON ;
		ID 508;
		OF oDlg ;
		ACTION ( InfDesCli( IS_SCREEN, oDlg, dDesde, dHasta, cCliHasta, cCliDesde, nTipoFactura ) )

	REDEFINE BUTTON ;
		ID 505;
		OF oDlg ;
		ACTION ( InfDesCli( IS_PRINTER, oDlg, dDesde, dHasta, cCliHasta, cCliDesde, nTipoFactura ) )

	REDEFINE BUTTON ;
		ID 510;
		OF oDlg ;
		ACTION ( oDlg:end() )

	ACTIVATE DIALOG oDlg CENTER

RETURN NIL

//---------------------------------------------------------------------------//