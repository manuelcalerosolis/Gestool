#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Folder.ch"
#include "Report.ch"
#include "Label.ch"

//----------------------------------------------------------------------//

FUNCTION InfEncPre( dbfArticulo )

	local oDlg
	local oRadio
	local oSayDesde
	local cSayDesde
	local oSayHasta
	local cSayHasta
	local oFamiDesde
	local oFamiHasta
	local cFamiDesde	:= DBFirst( dbfFami, 1 )
	local cFamiHasta	:= DBLast(  dbfFami, 1 )
	local lPVD			:= .t.
	local lPVP			:= .t.
	local lIVA			:= .t.
	local lPreCero		:= .t.
	local nDevice 		:= 1
	local nRadio		:= 1
	local cTitulo		:= Space( 100 )
	local cSubTitulo	:= Padr( "Listado de Articulos", 100 )
	local nRecno  		:= (dbfArticulo)->(RecNo())
	local cTag    		:= (dbfArticulo)->(OrdSetFocus())

	/*
	Llamada a la funcion que activa la caja de dialogo
	*/

	DEFINE DIALOG oDlg RESOURCE "REP_ARTICULO"

	REDEFINE RADIO oRadio VAR nRadio ;
		ID 		101, 102 ;
		OF 		oDlg

	REDEFINE GET oFamiDesde VAR cFamiDesde ;
		ID 		110 ;
		VALID 	( cFamilia( oFamiDesde, dbfFami, oSayDesde ) );
		COLOR 	CLR_GET ;
		OF 		oDlg

	REDEFINE GET oSayDesde VAR cSayDesde ;
		WHEN 		.F.;
		ID 		120 ;
		COLOR 	CLR_GET ;
		OF 		oDlg

	REDEFINE GET oFamiHasta VAR cFamiHasta ;
		ID 		130 ;
		VALID 	( cFamilia( oFamiHasta, dbfFami, oSayHasta ) );
		COLOR 	CLR_GET ;
		OF 		oDlg

	REDEFINE GET oSayHasta VAR cSayHasta ;
		WHEN 		.F.;
		ID 		140 ;
		COLOR 	CLR_GET ;
		OF 		oDlg

	REDEFINE CHECKBOX lPVD ;
		ID 		150 ;
		OF 		oDlg

	REDEFINE CHECKBOX lPVP ;
		ID 		151 ;
		OF 		oDlg

	REDEFINE CHECKBOX lIVA ;
		ID 		152 ;
		OF 		oDlg

	REDEFINE CHECKBOX lPreCero ;
		ID 		160 ;
		OF 		oDlg

	REDEFINE GET cTitulo ;
		ID 		170 ;
		OF 		oDlg

	REDEFINE GET cSubTitulo ;
		ID 		180 ;
		OF 		oDlg

	REDEFINE BUTTON ;
		ID 		508;
		OF 		oDlg ;
		ACTION 	( PrnReport( nRadio, cFamiDesde, cFamiHasta, lPVD, lPVP, lIVA,;
									lPreCero, cTitulo, cSubTitulo, 1 ) )

	REDEFINE BUTTON ;
		ID 		505;
		OF 		oDlg ;
		ACTION 	( PrnReport( nRadio, cFamiDesde, cFamiHasta, lPVD, lPVP, lIVA,;
									lPreCero, cTitulo, cSubTitulo, 2 ) )

	REDEFINE BUTTON ;
		ID 		510;
		OF 		oDlg ;
		ACTION 	( oDlg:end() )

	ACTIVATE DIALOG oDlg CENTER ;
		ON PAINT ( oFamiDesde:lValid(), oFamiHasta:lValid() )

	( dbfArticulo )->( dbGoto( nRecno ) )
	( dbfArticulo )->( OrdSetFocus( cTag ) )

RETURN ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

STATIC FUNCTION PrnReport( nRadio, cFamiDesde, cFamiHasta, lPVD, lPVP, lIVA,;
									lPreCero, cTitulo, cSubTitulo, nDevice )

	local nRecNo  := ( dbfArticulo )->( RecNo() )
	local cOrdAnt := ( dbfArticulo )->( OrdSetFocus() )


	/*
	Cambiamos los indices
	*/

	IF nRadio == 1
		( dbfArticulo )->( OrdSetFocus( "CFAMCOD" ) )
	ELSE
		( dbfArticulo )->( OrdSetFocus( "CFAMNOM" ) )
	END IF

	/*
	Posicionamos en el primer registro
	*/

	( dbfArticulo )->( DbSeek( cFamiDesde ) )

	/*
	Tipos de Letras
	*/

   DEFINE FONT oFont1 NAME "Arial" SIZE 0,-12 BOLD
   DEFINE FONT oFont2 NAME "Arial" SIZE 0,-12

		IF nDevice == 1

			REPORT oReport ;
				TITLE  	Rtrim( cTitulo ),;
							Rtrim( cSubTitulo ) ;
				FONT   	oFont1, oFont2 ;
				HEADER 	"Fecha: " + dtoc(date()) RIGHT ;
				FOOTER 	OemtoAnsi( "P gina : " ) + str( oReport:nPage, 3 ) CENTERED;
				CAPTION 	"Listado de Artículos";
				PREVIEW

		ELSE

			REPORT oReport ;
				TITLE  	Rtrim( cTitulo ),;
							Rtrim( cSubTitulo ) ;
				FONT   	oFont1, oFont2 ;
				HEADER 	"Fecha: " + dtoc(date()) RIGHT ;
				FOOTER 	OemtoAnsi("P gina : ")+str(oReport:nPage,3) CENTERED;
				CAPTION 	"Listado de Artículos";
				TO PRINTER

		END IF

         COLUMN TITLE "Codigo" ;
				DATA RTRIM( (dbfArticulo)->CODIGO ) + STR( (dbfArticulo)->PCOSTO );
				SIZE 14 ;
				FONT 2

			COLUMN TITLE "Descripción" ;
				DATA (dbfArticulo)->NOMBRE ;
				SIZE 40 ;
				FONT 2

			/*
			COLUMN TITLE "Peso/Vol." ;
				DATA Trans( (dbfArticulo)->NPESOKG, "@E 999,99" ) + Space(1) + (dbfArticulo)->CUNIDAD ;
				SIZE 8 ;
				FONT 2
			*/

		IF lPVD
			COLUMN TITLE "P.V.D." ;
				DATA (dbfArticulo)->PVENTA1 ;
				PICTURE "@E 99,999,999";
				SIZE 8 ;
				FONT 2
		END IF

		IF lPVP
			COLUMN TITLE "P.V.P." ;
				DATA (dbfArticulo)->PVENTA3 ;
				PICTURE "@E 99,999,999";
				SIZE 8 ;
				FONT 2
		END IF

		IF lIVA
         COLUMN TITLE cImp() ;
				DATA nIva( dbfIva, (dbfArticulo)->TIPOIVA ) ;
				FONT 2;
				SIZE 6
		END IF

		GROUP ON ( dbfArticulo )->FAMILIA ;
			HEADER "Familia : " + oReport:aGroups[1]:cValue + "-" + ;
						retFamilia( oReport:aGroups[1]:cValue, dbfFami ) ;
			FOOTER "";
			FONT 2

		END REPORT

		IF oReport:lCreated
			oReport:Margin(0, RPT_RIGHT, RPT_CMETERS)
			oReport:bSkip	:= {|| (dbfArticulo)->(DbSkip( 1 )) }
		ELSE
			msginfo( "Imposible crear el listado" )
		END IF

		ACTIVATE REPORT oReport ;
			FOR 	( dbfArticulo )->( &( OrdKey() ) ) >= cFamiDesde .AND. ;
					( dbfArticulo )->( &( OrdKey() ) ) <= cFamiHasta .AND. ;
					If( lPreCero, ( dbfArticulo )->PVENTA1 != 0, .T. ) ;
			WHILE !( dbfArticulo )->( Eof() )

	oFont1:end()
	oFont2:end()

	( dbfArticulo )->( OrdSetFocus( cOrdAnt ) )
	( dbfArticulo )->( DbGoto( nRecno ) )

RETURN NIL

//--------------------------------------------------------------------------//