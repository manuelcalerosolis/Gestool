#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "Report.ch"

#define _CCODEMP                   1      //   C      4     0
#define _CNBREMP                   2      //   C     40     0
#define _CCODSEC                   3      //   C      3     0
#define _NCOSTEHORA                4      //   N      7     0

static oWndBrw
static dbfPersonal
static bEdit := { |aTemp, aoGet, dbfPersonal, oBrw, bWhen, bValid, nMode | EdtRec( aTemp, aoGet, dbfPersonal, oBrw, bWhen, bValid, nMode ) }
static aBase := { {"CCODEMP",		"C", 4, 0, "" },;
						{"CNBREMP",		"C",40, 0, "" },;
						{"CCODSEC",		"C", 3, 0, "" },;
						{"NCOSTEHORA",	"N", 7, 0, "" } }

//----------------------------------------------------------------------------//

FUNCTION Personal( oWnd )

   local oBlock
   local oError
	IF oWndBrw == NIL

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   USE ( cPatEmp() + "PERSONAL" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PERSONAL", @dbfPersonal ) )
   SET ADSINDEX TO ( cPatEmp() + "PERSONAL" ) ADDITIVE

   DEFINE SHELL oWndBrw FROM 2, 10 TO 18, 70;
		TITLE 	"Personal" ;
		FIELDS	(dbfPersonal)->CCODEMP,;
					(dbfPersonal)->CNBREMP,;
					(dbfPersonal)->CCODSEC,;
					Trans( (dbfPersonal)->NCOSTEHORA, "@E 9,999,999" );
      HEAD     "Codigo",;
					"Nombre",;
					"Secci¢n",;
					"Coste Hora";
      PROMPT   "Codigo",;
					"Nombre";
		ALIAS		( dbfPersonal ) ;
		APPEND	( WinAppRec( oWndBrw:oBrw, bEdit, dbfPersonal, , {|oGet| NotValid( oGet, dbfPersonal, .T., "0" ) } ) );
		DUPLICAT ( WinDupRec( oWndBrw:oBrw, bEdit, dbfPersonal, , {|oGet| NotValid( oGet, dbfPersonal, .T., "0" ) } ) );
		EDIT 		( WinEdtRec( oWndBrw:oBrw, bEdit, dbfPersonal ) ) ;
		DELETE   ( DBDelRec(  oWndBrw:oBrw, dbfPersonal ) ) ;
		OF 		oWnd

		DEFINE BTNSHELL RESOURCE "NEW" OF oWndBrw ;
			NOBORDER ;
			ACTION 	( oWndBrw:RecAdd() );
			ON DROP	( oWndBrw:RecDup() );
			TOOLTIP "(A)ñadir";
			HOTKEY 	"A"

		DEFINE BTNSHELL RESOURCE "DUP" OF oWndBrw ;
			NOBORDER ;
			ACTION 	( oWndBrw:RecDup() );
			TOOLTIP 	"(D)uplicar";
			HOTKEY 	"D"

		DEFINE BTNSHELL RESOURCE "EDIT" OF oWndBrw ;
			NOBORDER ;
			ACTION  	( oWndBrw:RecEdit() );
			TOOLTIP 	"(M)odificar";
			HOTKEY 	"M"

		DEFINE BTNSHELL RESOURCE "ZOOM" OF oWndBrw ;
			NOBORDER ;
			ACTION  	( WinZooRec( oWndBrw:oBrw, bEdit, dbfPersonal ) );
			TOOLTIP 	"(Z)oom";
			HOTKEY 	"Z"

		DEFINE BTNSHELL RESOURCE "DEL" OF oWndBrw ;
			NOBORDER ;
			ACTION 	( oWndBrw:RecDel() );
			TOOLTIP 	"(E)liminar";
			HOTKEY 	"E"

		DEFINE BTNSHELL RESOURCE "BUS" OF oWndBrw ;
			NOBORDER ;
			ACTION 	( oWndBrw:Search() ) ;
			TOOLTIP 	"(B)uscar";
			HOTKEY 	"B"

		DEFINE BTNSHELL RESOURCE "IMP" OF oWndBrw ;
			NOBORDER ;
			ACTION ( GenReport() ) ;
			TOOLTIP "(L)istado" ;
			HOTKEY 	"L"

      DEFINE BTNSHELL RESOURCE "END" GROUP OF oWndBrw ;
			NOBORDER ;
			ACTION ( oWndBrw:End() ) ;
			TOOLTIP "(S)alir" ;
			HOTKEY 	"S"

		ACTIVATE WINDOW oWndBrw ;
			VALID ( oWndBrw:oBrw:lCloseArea(), oWndBrw := NIL, .t. )

	ELSE

		oWndBrw:SetFocus()

	END IF

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN NIL

//----------------------------------------------------------------------------//

STATIC FUNCTION EdtRec( aTemp, aoGet, dbfPersonal, oBrw, bWhen, bValid, nMode )

	local oDlg
	local oGet
	local oSay, cSay

	DEFINE DIALOG oDlg RESOURCE "PERSONAL" TITLE LblTitle( nMode ) + " Personal"

		REDEFINE GET oGet VAR aTemp[_CCODEMP];
			ID 	110 ;
			WHEN 	( nMode == APPD_MODE ) ;
			VALID ( EVAL( bValid, oGet ) ) ;
			COLOR CLR_GET ;
			OF		oDlg

		REDEFINE GET aTemp[_CNBREMP] ;
			ID 	120 ;
			COLOR CLR_GET ;
			WHEN 	( nMode != ZOOM_MODE ) ;
			OF 	oDlg

		REDEFINE GET aoGet[_CCODSEC] VAR aTemp[_CCODSEC] ;
			ID 	130 ;
			WHEN 	( nMode != ZOOM_MODE ) ;
			VALID cSeccion( aoGet[_CCODSEC], nil, oSay ) ;
			ON HELP BrwSeccion( aoGet[_CCODSEC], nil , oSay ) ;
			COLOR CLR_GET ;
			OF 	oDlg

      REDEFINE GET oSay VAR cSay ;
			ID 	131 ;
			WHEN 	( .F. ) ;
			COLOR CLR_GET ;
			OF 	oDlg

		REDEFINE GET aTemp[_NCOSTEHORA] ;
			ID 	140 ;
			PICTURE "@E 9,999,999";
			WHEN 	( nMode != ZOOM_MODE ) ;
			COLOR CLR_GET ;
			OF		oDlg

		REDEFINE BUTTON ;
         ID    IDOK ;
			OF 	oDlg ;
			WHEN 	( nMode != ZOOM_MODE ) ;
         ACTION ( WinGather( aTemp, aoGet, dbfPersonal, oBrw, nMode ), oDlg:end( IDOK ) )

		REDEFINE BUTTON ;
         ID    IDCANCEL ;
			OF 	oDlg ;
			ACTION ( oDlg:end() )

	ACTIVATE DIALOG oDlg CENTER

RETURN ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

STATIC FUNCTION GenReport()

	local oReport
	local oFont1
	local oFont2
	local nDevice		:= 1
	local nRecno 		:= (dbfPersonal)->(RECNO())
   local cTitulo     := Padr( cCodEmp() + " - " + cNbrEmp(), 100 )
	local cSubTitulo	:= Padr( "Listado de Personal", 100 )

	/*
	Llamada a la funcion que activa la caja de dialogo
	*/

	IF SetRep( @cTitulo, @cSubTitulo, @nDevice )

		(dbfPersonal)->(dbGoTop())

		/*
		Tipos de Letras
		*/

      DEFINE FONT oFont1 NAME "Courier New" SIZE 0,-10 BOLD
      DEFINE FONT oFont2 NAME "Courier New" SIZE 0,-10

		IF nDevice == 1

			REPORT oReport ;
				TITLE  	Rtrim( cTitulo ),;
							Rtrim( cSubTitulo ) ;
				FONT   	oFont1, oFont2 ;
				HEADER 	"Fecha: " + dtoc(date()) RIGHT ;
				FOOTER 	OemtoAnsi("P gina : ")+str(oReport:nPage,3) CENTERED;
				CAPTION 	"Listado Personal";
				PREVIEW

		ELSE

			REPORT oReport ;
				TITLE  	Rtrim( cTitulo ),;
							Rtrim( cSubTitulo ) ;
				FONT   	oFont1, oFont2 ;
				HEADER 	"Fecha: " + dtoc(date()) RIGHT ;
				FOOTER 	OemtoAnsi("P gina : ")+str(oReport:nPage,3) CENTERED;
				CAPTION 	"Listado Personal";
            TO PRINTER

		END IF

         COLUMN TITLE "Codigo" ;
				DATA (dbfPersonal)->CCODEMP ;
				FONT 2

			COLUMN TITLE "Nombre" ;
				DATA (dbfPersonal)->CNBREMP ;
				FONT 2

			COLUMN TITLE "Secci¢n" ;
				DATA (dbfPersonal)->CCODSEC ;
				FONT 2

			COLUMN TITLE "Coste Hora" ;
				PICTURE "@E 9,999,999";
				DATA (dbfPersonal)->NCOSTEHORA ;
				FONT 2

		END REPORT

      IF !Empty( oReport ) .and. oReport:lCreated
			oReport:Margin(0, RPT_RIGHT, RPT_CMETERS)
			oReport:bSkip	:= {|| (dbfPersonal)->(DbSkip()) }
		END IF

		ACTIVATE REPORT oReport WHILE !(dbfPersonal)->(Eof())

		oFont1:end()
		oFont2:end()

	END IF

	(dbfPersonal)->(dbGoto( nRecno ) )

RETURN NIL

//--------------------------------------------------------------------------//

FUNCTION cPersonal( oGet, dbfPersonal, oGet2 )

   local oBlock
   local oError
	local cAreaAnt := Alias()
	local lClose 	:= .F.
	local lValid	:= .F.
	local xValor 	:= oGet:varGet()

	IF Empty( xValor )
		RETURN .T.
	END IF

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

	If dbfPersonal == NIL

      USE ( cPatEmp() + "PERSONAL" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PERSONAL", @dbfPersonal ) )
      SET ADSINDEX TO ( cPatEmp() + "PERSONAL" ) ADDITIVE
		lClose	:= .T.

	End if

	If (dbfPersonal)->( DbSeek( xValor ) )

		oGet:varPut( (dbfPersonal)->CCODEMP )
		oGet:refresh()

		If oGet2 != NIL
			oGet2:varPut( (dbfPersonal)->CNBREMP )
			oGet2:refresh()
		End if

		lValid	:= .T.

	Else

		msgStop( "Personal no encontrado" )

	End if

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

	If lClose
		CLOSE (dbfPersonal)
	End if

	If cAreaAnt != ""
		SELECT( cAreaAnt )
	End if

RETURN lValid

//---------------------------------------------------------------------------//

FUNCTION BrwPersonal( oGet, dbfPersonal, oGet2 )

   local oBlock
   local oError
	local oDlg, oGet1, cGet1
	local oBrw
	local lClose   := .F.
	local nRadio 	:= 2

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

	If dbfPersonal == NIL

      USE ( cPatEmp() + "PERSONAL" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PERSONAL", @dbfPersonal ) )
      SET ADSINDEX TO ( cPatEmp() + "PERSONAL" ) ADDITIVE
		lClose	:= .T.

	End if

	(dbfPersonal)->(DbGoTop())

   DEFINE DIALOG oDlg RESOURCE "HELPENTRY" TITLE "Personal"

		REDEFINE GET oGet1 VAR cGet1;
         ID       104 ;
         ON CHANGE( AutoSeek( nKey, nFlags, Self, oBrw, dbfPersonal ) );
         VALID    ( OrdClearScope( oBrw, dbfPersonal ) );
         BITMAP   "FIND" ;
         OF       oDlg

		REDEFINE RADIO nRadio ;
         ID       102, 103 ;
         ON CHANGE( ( dbfPersonal )->( ordSetFocus( nRadio, "PERSONAL") ), oBrw:refresh() ) ;
         OF       oDlg

		REDEFINE LISTBOX oBrw ;
			FIELDS ;
               (dbfPersonal)->CCODEMP ,;
               (dbfPersonal)->CNBREMP ;
			HEADER;
               "Código",;
               "Nombre" ;
			ALIAS dbfPersonal ;
         ID    105 ;
         OF    oDlg

		REDEFINE BUTTON ;
         ID       IDOK ;
         OF       oDlg ;
         ACTION   ( oDlg:end(IDOK) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
         OF       oDlg ;
         ACTION   ( oDlg:end() )

		REDEFINE BUTTON ;
         ID       500 ;
         OF       oDlg ;
         ACTION   ( WinAppRec( oBrw, bEdit, dbfPersonal ) );

		REDEFINE BUTTON ;
         ID       501 ;
         OF       oDlg ;
         ACTION   ( WinEdtRec( oBrw, bEdit, dbfPersonal ) )

   ACTIVATE DIALOG oDlg CENTER

   If oDlg:nResult == IDOK

		oGet:varPut( (dbfPersonal)->CCODEMP )
		oGet:refresh()
		oGet:lValid()

		If ValType( oGet2 ) == "O"
			oGet2:varPut( (dbfPersonal)->CNBREMP )
			oGet2:refresh()
		End if

	End if

	oGet:setFocus()

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

	IF lClose
		CLOSE ( dbfPersonal )
	END IF

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

FUNCTION mkPersonal( cPath, oMeter )

	local dbfPersonal

   dbCreate( cPath + "PERSONAL.DBF", aBase, cDriver() )

	rxPersonal( cPath, oMeter )

RETURN NIL

//--------------------------------------------------------------------------//

FUNCTION rxPersonal( cPath, oMeter )

	local dbfPersonal

   DEFAULT cPath := cPatEmp()

   IF !File( cPath + "PERSONAL.DBF" )
      dbCreate( cPath + "PERSONAL.DBF", aBase, cDriver() )
	END IF

   dbUseArea( .t., cDriver(), cPath + "PERSONAL.DBF", cCheckArea( "PERSONAL", @dbfPersonal ), .f. )
   if !( dbfPersonal )->( neterr() )
      ( dbfPersonal )->( __dbPack() )

      ( dbfPersonal )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfPersonal )->( ordCreate( cPath + "PERSONAL.CDX", "CCODEMP", "CCODEMP", {|| CCODEMP }, ) )

      ( dbfPersonal )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfPersonal )->( ordCreate( cPath + "PERSONAL.CDX", "CNBREMP", "CNBREMP", {|| CNBREMP } ) )

      ( dbfPersonal )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de personal" )
   end if

RETURN NIL

//--------------------------------------------------------------------------//