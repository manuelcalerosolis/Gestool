#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Report.ch"

#define _NUMERO                    1      //   C     10     0
#define _FECHA                     2      //   D      8     0
#define _CODCLI                    3      //   C     10     0
#define _OBSERVA                   4      //   C     50     0

static oWndBrw
static lProced := .F.
static bEdit   := { |aTemp, aoGet, cAlias, oBrw, bWhen, bValid, nMode | EdtRec( aTemp, aoGet, cAlias, oBrw, bWhen, bValid, nMode ) }

//----------------------------------------------------------------------------//

FUNCTION Ot( oWnd )

	local oBar
	local oBrw
	local oBtnAdd
	local oIcon
	local oCursor
	local oFont
	local oTabs
	local cAlias
	local aIndexes := { "1 Codigo", "2 Fecha", "3 Cliente" }

	IF oWndBrw == NIL

   USE ( cPatDat() + "OT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "OT", @cAlias ) )
   SET ADSINDEX TO ( cPatDat() + "OT.CDX" ) ADDITIVE

   DEFINE FONT oFont NAME "Arial" SIZE 6, 15 BOLD

	DEFINE CURSOR oCursor RESOURCE "CATCH"

	DEFINE ICON oIcon RESOURCE "BROWSE"

	DEFINE WINDOW oWndBrw FROM 0, 0 TO 18, 60 ;
		TITLE "Ordenes de Trabajo" ;
		ICON oIcon ;
		MDICHILD ;
		OF oWnd

		DEFINE BUTTONBAR oBar SIZE 34, 34 3D OF oWndBrw

		DEFINE BUTTON oBtnAdd RESOURCE "PBMPADD1" OF oBar ;
			ACTION ( WinAppRec( oBrw, bEdit, cAlias, {|oGet| NewReg( oGet, cAlias ) }, {|oGet| NotValid(oGet, cAlias) } ) );
			ON DROP( WinDupRec( oBrw, bEdit, cAlias ) );
			TOOLTIP OemToAnsi( "A¤adir" )

		DEFINE BUTTON RESOURCE "PBMPMOD1" OF oBar ;
			ACTION  ( WinEdtRec( oBrw, bEdit, cAlias ) );
			ON DROP ( WinEdtRec( oBrw, bEdit, cAlias ) );
			TOOLTIP "Editar"

		DEFINE BUTTON RESOURCE "PBMPZOO1" OF oBar ;
			ACTION  ( WinZooRec( oBrw, bEdit, cAlias ) );
			ON DROP ( WinZooRec( oBrw, bEdit, cAlias ) );
			TOOLTIP "Zoom"

		DEFINE BUTTON RESOURCE "PBMPDEL1" OF oBar ;
			ACTION ( DBDelRec( oBrw, cAlias ) );
			ON DROP ( DBDelRec( oBrw, cAlias ) );
			TOOLTIP "Borrar"

		DEFINE BUTTON RESOURCE "PBMPFIN1", "PBMPFIN2" OF oBar ;
			ACTION ( Searching( cAlias, aIndexes, oBrw ) ) ;
			TOOLTIP "Buscar"

		DEFINE BUTTON RESOURCE "PBMPIMP1", "PBMPIMP2" OF oBar ;
			ACTION ( GenReport( cAlias, aIndexes ) ) ;
			TOOLTIP "Listado"

		DEFINE BUTTON RESOURCE "PBMPEND1", "PBMPEND2"  GROUP OF oBar ;
			ACTION ( oWndBrw:End() ) ;
			TOOLTIP "Salir"

		oWndBrw:oClient	= TPanel():New()

		@ 2, 0 LISTBOX oBrw ;
			FIELDS Trans( (cAlias)->NUMERO, "@R ########/##" ),;
				DTOC( (cAlias)->FECHA ),;
				(cAlias)->CODCLI + SPACE(2) + RetClient( (cAlias)->CODCLI );
         HEAD "Número",;
				"Fecha",;
				"Cliente";
			ALIAS cAlias ;
			ON DBLCLICK ( WinEdtRec( oBrw, bEdit, cAlias ) ) ;
			OF oWndBrw:oClient ;
			SIZE 700, 800 ;
			FONT oFont

			oWndBrw:oClient:oLeft	= oBrw
			oBrw:oDragCursor 			= oCursor

			oBrw:bAdd := {|| WinAppRec( oBrw, bEdit, cAlias, {|oGet| NewReg( oGet, cAlias ) } , {|oGet| NotValid(oGet, cAlias ) } ) }
			oBrw:bEdit:= {|| WinEdtRec( oBrw, bEdit, cAlias ) }
			oBrw:bDel := {|| DBDelRec( oBrw, cAlias ) }

		@ 4,0 TABS oTabs;
			PROMPTS "&Codigo", "&Fecha", "&Cliente";
			OF oWndBrw:oClient ;
			ACTION (cAlias)->( OrdSetFocus( oTabs:nOption ), oBrw:refresh() )

		oWndBrw:oClient:oBottom = oTabs
		oWndBrw:SetControl( oBrw )

		ACTIVATE WINDOW oWndBrw VALID ( oWndBrw := NIL, oBrw:lCloseArea() )

	ELSE

		oWndBrw:setFocus()

	END IF

RETURN NIL

//----------------------------------------------------------------------------//

STATIC FUNCTION EdtRec( aTemp, aoGet, cAlias, oBrw, bWhen, bValid, nMode )

	local oDlg
	local oGet
	local cName
	local cTitle

	DO CASE
	CASE nMode 	== APPD_MODE
		cTitle	:= "Añadiendo Grupos de Contabilidad"
	CASE nMode 	== EDIT_MODE
		cTitle	:= "Modificando Grupos de Contabilidad"
	CASE nMode	== ZOOM_MODE
		cTitle	:= "Visualizando Grupos de Contabilidad"
	END CASE

	DEFINE DIALOG oDlg RESOURCE "ORDTRA" TITLE cTitle

		/*
		Redefinici¢n de la primera caja de Dialogo
		*/

		REDEFINE GET aoGet[_NUMERO] VAR aTemp[_NUMERO];
			ID 100 ;
			WHEN ( EVAL( bWhen, aoGet[_NUMERO] ) ) ;
			VALID ( EVAL( bValid, aoGet[_NUMERO] ) ) ;
			PICTURE "@R ########/##" ;
			COLOR CLR_GET ;
			OF oDlg

		REDEFINE GET aTemp[ _FECHA ] ;
			ID 101 ;
			WHEN ( nMode != ZOOM_MODE ) ;
			COLOR CLR_GET ;
			OF oDlg

		REDEFINE GET aoGet[ _CODCLI ] VAR aTemp[ _CODCLI ] ;
			ID 102 ;
			COLOR CLR_GET ;
			WHEN ( nMode != ZOOM_MODE ) ;
			VALID cClient( aoGet[ _CODCLI ], , oGet );
			OF oDlg

		REDEFINE GET oGet VAR cName ;
			ID 103 ;
			PICTURE "@!" ;
			COLOR CLR_GET ;
			WHEN ( nMode != ZOOM_MODE ) ;
			OF oDlg

		REDEFINE GET aTemp[ _OBSERVA ] ;
			ID 104 ;
			PICTURE "@!" ;
			COLOR CLR_GET ;
			WHEN ( nMode != ZOOM_MODE ) ;
			OF oDlg

		REDEFINE BUTTON ;
         ID IDOK ;
			OF oDlg ;
			WHEN ( nMode != ZOOM_MODE ) ;
         ACTION ( WinGather( aTemp, aoGet, cAlias, oBrw, nMode ), oDlg:end( IDOK ) )

		REDEFINE BUTTON ;
         ID IDCANCEL ;
			OF oDlg ;
			ACTION ( oDlg:end() )

	ACTIVATE DIALOG oDlg	CENTER

RETURN ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

STATIC FUNCTION GenReport( cAlias, aIndices )

	local oReport
	local oFont1, oFont2
	local xDesde, xHasta
	local nRecno := (cAlias)->(RecNo())
	local cTag   := (cAlias)->(OrdSetFocus())
	local cTexto := Space(100)
	local nDevice:= 1

	/*
	Llamada a la funcion que activa la caja de dialogo
	*/

	IF SetReport( cAlias, "OT", aIndices, @xDesde, @xHasta, @cTexto, @nDevice )

		(cAlias)->( DbSeek( xDesde ) )

		/*
		Tipos de Letras
		*/

      DEFINE FONT oFont1 NAME "Courier New" SIZE 0,-10 BOLD
      DEFINE FONT oFont2 NAME "Arial" SIZE 0,-8

		IF nDevice == 1

			REPORT oReport ;
				TITLE  "Listado de Ordenes de Trabajo", aIni()[EMPRESA],	RTRIM(cTexto) ;
				FONT   oFont1, oFont2 ;
				HEADER "Fecha: " + Dtoc( Date() ) RIGHT ;
				FOOTER OemtoAnsi( "P gina : " ) + Str( oReport:nPage, 3 ) CENTERED;
				PREVIEW

		ELSE

			REPORT oReport ;
				TITLE  "Listado de Ordenes de Trabajo", aIni()[EMPRESA],	RTRIM(cTexto) ;
				FONT   oFont1, oFont2 ;
				HEADER "Fecha: " + Dtoc( Date() ) RIGHT ;
				FOOTER OemtoAnsi( "P gina : " ) + Str( oReport:nPage, 3 ) CENTERED

		END IF

         COLUMN TITLE "Número" ;
				DATA (cAlias)->NUMERO ;
				FONT 2

			COLUMN TITLE "Fecha" ;
				DATA (cAlias)->FECHA ;
				FONT 2

			COLUMN TITLE "Cliente" ;
				DATA (cAlias)->CODCLI + SPACE(2) + cClient( (cAlias)->CODCLI );
				FONT 2

		END REPORT

      IF !Empty( oReport ) .and.  oReport:lCreated
			oReport:Margin(0, RPT_RIGHT, RPT_CMETERS)
			oReport:bSkip := {|| (cAlias)->(DbSkip()) }
		END IF

		ACTIVATE REPORT oReport ;
			FOR (cAlias)->(&(OrdKey())) >= xDesde .AND. (cAlias)->(&(OrdKey())) <= xHasta ;
			WHILE !(cAlias)->(Eof())

		oFont1:end()
		oFont2:end()

	END IF

	(cAlias)->(DbGoto( nRecno ) )
	(cAlias)->(OrdSetFocus( cTag ) )

RETURN NIL

//--------------------------------------------------------------------------//

FUNCTION BrwOt( oGet, cAlias, oGet2 )

	local oDlg
	local oBrw
	local oGet1, cGet1
	local nOrdAnt
	local cAreaAnt := Alias()
	local nRadio	:= 2
	local lClose	:= .F.

	IF cAlias == NIL

      USE ( cPatDat() + "OT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "OT", @cAlias ) )
      SET ADSINDEX TO ( cPatDat() + "OT.CDX" ) ADDITIVE
		lClose	:= .T.

	END IF

	nOrdAnt	:= (cAlias)->(OrdSetFocus(2))
	(cAlias)->(DbGoTop())

	DEFINE DIALOG oDlg;
		RESOURCE "HELPENTRY"

		REDEFINE GET oGet1 VAR cGet1;
         ID       104 ;
         ON       CHANGE AutoSeek(nKey, nFlags, Self, oBrw ) ;
         BITMAP   "FIND" ;
         OF       oDlg

		REDEFINE RADIO nRadio ;
			ID 102, 103 ;
			ON CHANGE ( (cAlias)->(OrdSetFocus(nRadio)), oBrw:refresh() ) ;
			OF oDlg

		REDEFINE LISTBOX oBrw ;
			FIELDS (cAlias)->NUMERO,;
				(cAlias)->FECHA,;
				(cAlias)->CODCLI + Space(1) + RetClient( (cAlias)->CODCLI );
         HEAD "Número",;
				"Fechas",;
				"Clientes" ;
			ID 105 ;
			OF oDlg

		REDEFINE BUTTON ;
			ID 1 ;
			OF oDlg ;
         ACTION ( oDlg:end(IDOK) )

		REDEFINE BUTTON ;
			ID 2 ;
			OF oDlg ;
			ACTION ( oDlg:end() )

		REDEFINE BUTTON ;
			ID 110 ;
			OF oDlg ;
			ACTION ( WinAppRec( oBrw, bEdit, cAlias, , {|oGet| NotValid(oGet, cAlias, .T., "0") } ) )

		REDEFINE BUTTON ;
			ID 120 ;
			OF oDlg ;
			ACTION ( WinEdtRec( oBrw, bEdit, cAlias ) )

	ACTIVATE DIALOG oDlg

   If oDlg:nResult == IDOK

		oGet:varPut( (cAlias)->NUMERO )
		oGet:refresh()

		If oGet2 != NIL
			oGet2:varPut( (cAlias)->CODCLI )
			oGet2:refresh()
		End if

	End if

	IF lClose
		(cAlias)->(dbCloseArea())
	ELSE
		(cAlias)->(OrdSetFocus(nOrdAnt))
	END IF

	IF cAreaAnt != ""
		SELECT( cAreaAnt )
	END IF

	oGet:setFocus()

RETURN oDlg:nResult == IDOK

//---------------------------------------------------------------------------//

FUNCTION cOt( oGet, cAlias, oGet2 )

	local cAreaAnt := Alias()
	local lClose 	:= .F.
	local lValid	:= .F.
	local xValor	:= oGet:varGet()

	IF Empty( xValor )
		RETURN .T.
	END IF

	IF cAlias == NIL

      USE ( cPatDat() + "OT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "OT", @cAlias ) )
      SET ADSINDEX TO ( cPatDat() + "OT.CDX" ) ADDITIVE
		lClose	:= .T.

	END IF

	If (cAlias)->( DbSeek( xValor ) )

		oGet:varPut( (cAlias)->NUMERO )
		oGet:refresh()

		If oGet2 != NIL
			oGet2:varPut( (cAlias)->CODCLI )
			oGet2:refresh()
		End if

		lValid	:= .T.

	Else

		msgStop( "Orden de Trabajo no encontrada", "Aviso del Sistema" )

	End if

	If lClose
		CLOSE (cAlias)
	End if

	If cAreaAnt != ""
		SELECT( cAreaAnt )
	End if

RETURN lValid

//---------------------------------------------------------------------------//

STATIC FUNCTION NewReg( oGet, cAlias )

	local cAliCount

   USE ( cPatDat() + "COUNT.DBF" ) NEW VIA ( cDriver() )ALIAS ( cCheckArea( "COUNT", @cAliCount ) )

	oGet:VarPut( (cAliCount)->NORDTRB )
	oGet:refresh()

	CLOSE ( cAliCount )

	oGet:bWhen = { || .F. }

RETURN .T.

//--------------------------------------------------------------------------//

STATIC FUNCTION ChkCode( cClave )

	local cCode

	cCode := RJust( SubStr( cClave, 1, 8 ), "0", 8 )
	cCode += Substr( Str( Year(Date()) ), 4, 2 )

RETURN ( cCode )

//--------------------------------------------------------------------------//