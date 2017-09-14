#include "FiveWin.Ch"
#include "Font.ch"
#include "Report.ch"
#include "Factu.ch" 

#define _CTIPDOC                  1      //   C      2     0
#define _CFLDDOC                  2      //   C    100     0
#define _CAREDOC                  3      //   C     50     0
#define _CDESDOC                  4      //   C    254     0
#define _CMASDOC                  5      //   C     50     0
#define _CCONDOC                  6      //   C    100     0

static oWndBrw
static bEdit := { | aTemp, aoGet, dbfWDocFld, oBrw, bWhen, bValid, nMode | EdtRec( aTemp, aoGet, dbfWDocFld, oBrw, bWhen, bValid, nMode ) }
static aBase := { {"CTIPDOC",    "C",   2, 0, "" },;
                  {"CLFDDOC",    "C", 100, 0, "" },;
                  {"CAREDOC",    "C",  50, 0, "" },;
                  {"CDESDOC",    "C", 250, 0, "" },;
                  {"CMASDOC",    "C",  50, 0, "" },;
                  {"CCONDOC",    "C", 100, 0, "" }}

//----------------------------------------------------------------------------//

FUNCTION wDocFld( oWnd )

   local oBlock
   local oError
   local dbfWdocFld

	IF oWndBrw == NIL

      oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
      BEGIN SEQUENCE

      USE ( cPatDat() + "WDOCFLD.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "WDOCFLD", @dbfWDocFld ) )
      SET ADSINDEX TO ( cPatDat() + "WDOCFLD.CDX" ) ADDITIVE

      DEFINE SHELL oWndBrw FROM 2, 10 TO 18, 70 ;
         TITLE    "TITULO" ;
         FIELDS   (dbfWDocFld)->CTIPDOC,;
                  (dbfWDocFld)->CFLDDOC,;
                  (dbfWDocFld)->CAREDOC,;
                  (dbfWDocFld)->CDESDOC,;
                  (dbfWDocFld)->CMASDOC,;
                  (dbfWDocFld)->CCONDOC;
         HEAD     "CAMPO1",;
                  "CAMPO2",;
                  "CAMPO3",;
                  "CAMPO4",;
                  "CAMPO5",;
                  "CAMPO6";
         FIELDSIZES ;
                  20,;
                  100,;
                  80,;
                  140,;
                  140,;
                  80 ;
         PROMPT   "Tipo";
         ALIAS    ( dbfWDocFld ) ;
         APPEND   WinInsRec( oWndBrw:oBrw, bEdit, dbfWDocFld ) ; // WinAppRec( oWndBrw:oBrw, bEdit, dbfWDocFld )
         EDIT     WinEdtRec( oWndBrw:oBrw, bEdit, dbfWDocFld ) ;
         DELETE   DBDelRec( oWndBrw:oBrw, dbfWdocFld ) ;
         DUPLICAT WinDupRec( oWndBrw:oBrw, bEdit, dbfWdocFld ) ;
			OF 		oWnd

         //oWndBrw:oBrw:aJustify   = { .F., .F., .T., .T., .F. }

		DEFINE BTNSHELL RESOURCE "NEW" OF oWndBrw ;
			NOBORDER ;
         ACTION   ( oWndBrw:RecAdd() );
         ON DROP  ( oWndBrw:RecDup() );
         TOOLTIP  "(A)ñadir";
         HOTKEY   "A"

		DEFINE BTNSHELL RESOURCE "DUP" OF oWndBrw ;
			NOBORDER ;
			ACTION 	( oWndBrw:RecDup() );
			TOOLTIP 	"(D)uplicar";
			HOTKEY 	"D"

		DEFINE BTNSHELL RESOURCE "EDIT" OF oWndBrw ;
			NOBORDER ;
         ACTION   ( oWndBrw:RecEdit() );
         TOOLTIP  "(M)odificar";
         HOTKEY   "M"

		DEFINE BTNSHELL RESOURCE "ZOOM" OF oWndBrw ;
			NOBORDER ;
         ACTION   ( WinZooRec( oWndBrw:oBrw, bEdit, dbfWDocFld ) );
         TOOLTIP  "(Z)oom";
         HOTKEY   "Z"

		DEFINE BTNSHELL RESOURCE "DEL" OF oWndBrw ;
			NOBORDER ;
         ACTION   ( oWndBrw:RecDel() );
         TOOLTIP  "(E)liminar";
         HOTKEY   "E"

		DEFINE BTNSHELL RESOURCE "BUS" OF oWndBrw ;
			NOBORDER ;
         ACTION   ( oWndBrw:Search() ) ;
         TOOLTIP  "(B)uscar";
         HOTKEY   "B"

      DEFINE BTNSHELL RESOURCE "" OF oWndBrw ;
			NOBORDER ;
         ACTION   ( dbSwapUp( dbfWDocFld, oWndBrw:oBrw ) ) ;
         TOOLTIP  "A(r)riba";
         HOTKEY   "R"

      DEFINE BTNSHELL RESOURCE "" OF oWndBrw ;
			NOBORDER ;
         ACTION   ( dbSwapDown( dbfWDocFld, oWndBrw:oBrw ) ) ;
         TOOLTIP  "Aba(j)o";
         HOTKEY   "J"

      DEFINE BTNSHELL RESOURCE "END" GROUP OF oWndBrw ;
			NOBORDER ;
         ACTION   ( oWndBrw:End() ) ;
         TOOLTIP  "(S)alir";
         HOTKEY   "S"

		ACTIVATE WINDOW oWndBrw ;
         VALID    ( oWndBrw:oBrw:lCloseArea(), oWndBrw := NIL, .t. )

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

	ELSE

		oWndBrw:SetFocus()

	END IF

RETURN NIL

//----------------------------------------------------------------------------//

STATIC FUNCTION EdtRec( aTemp, aoGet, dbfWDocFld, oBrw, bWhen, bValid, nMode )

	local oDlg
	local oGet
	local cGet

   DEFINE DIALOG oDlg RESOURCE "WDocFld" TITLE LblTitle( nMode )

      REDEFINE GET aoGet[ _CTIPDOC ] VAR aTemp[ _CTIPDOC ];
			ID 		110 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         COLOR    CLR_GET ;
			OF 		oDlg

      REDEFINE GET aTemp[_CFLDDOC] ;
			ID 		120 ;
			COLOR 	CLR_GET ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			OF 		oDlg

      REDEFINE GET aTemp[_CAREDOC] ;
			ID 		130 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
			COLOR 	CLR_GET ;
			OF 		oDlg

      REDEFINE GET aTemp[_CDESDOC] ;
			ID 		140 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
			COLOR 	CLR_GET ;
			OF 		oDlg

      REDEFINE GET aTemp[_CMASDOC] ;
			ID 		150 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         COLOR    CLR_GET ;
			OF 		oDlg

      REDEFINE GET aTemp[_CCONDOC];
			ID 		160 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
			COLOR 	CLR_GET ;
			OF 		oDlg

		REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( WinGather( aTemp, aoGet, dbfWDocFld, oBrw, nMode ), oDlg:end( IDOK ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
			ACTION 	( oDlg:end() )

   ACTIVATE DIALOG oDlg CENTER

RETURN ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

STATIC FUNCTION WinInsRec( oBrw, bEdit, dbfWDocFld )

   local n
   local nRecMov
   local nRecNew
   local nRecAnt := ( dbfWDocFld )->( recno() )

   ( dbfWDocFld )->( dbAppend() )

   nRecNew := ( dbfWDocFld )->( recno() )
   nRecMov := nRecNew - nRecAnt

   FOR n := 1 TO nRecMov

      dbSwapUp( dbfWDocFld )

   NEXT

   oBrw:refresh()
   WinEdtRec( oBrw, bEdit, dbfWDocFld )

RETURN .t.

//--------------------------------------------------------------------------//