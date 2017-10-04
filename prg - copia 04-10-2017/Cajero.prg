#include "FiveWin.Ch"
#include "Font.ch"
#include "Report.ch"
#include "Factu.ch" 

#define _CCODCAJ                 1      //   C      3     0
#define _CNOMCAJ                 2      //   C     30     0
#define _CNIFCAJ                 3      //   C     15     0
#define _CDOMCAJ                 4      //   C     35     0
#define _CPOBCAJ						5      //   C     25     0
#define _CPRVCAJ						6      //   C     20     0
#define _CCDPCAJ						7      //   C      7     0
#define _CTELCAJ						8      //   C     12     0
#define _CFAXCAJ						9      //   C     12     0

static oWndBrw
static nLevel
static dbfCajero
static bEdit := { |aTemp, aoGet, dbfCajero, oBrw, bWhen, bValid, nMode | EdtRec( aTemp, aoGet, dbfCajero, oBrw, bWhen, bValid, nMode ) }
static aBase := { { "CCODCAJ",	"C",	3,	 0 },;
						{ "CNOMCAJ",	"C", 30,  0 },;
						{ "CNIFCAJ",	"C", 15,  0 },;
						{ "CDOMCAJ",	"C", 35,  0 },;
                  { "CPOBCAJ",   "C", 30,  0 },;
						{ "CPRVCAJ",	"C", 20,  0 },;
						{ "CCDPCAJ",	"C",  7,  0 },;
						{ "CTELCAJ",	"C", 12,  0 },;
						{ "CFAXCAJ",	"C", 12,  0 } }

//----------------------------------------------------------------------------//

STATIC FUNCTION OpenFiles()

   local oBlock
   local oError
   local lOpen    := .t.

   oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      IF !File( cPatEmp() + "CAJERO.DBF" )
         mkCajero()
      END IF

      USE ( cPatEmp() + "CAJERO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CAJERO", @dbfCajero ) )
      SET ADSINDEX TO ( cPatEmp() + "CAJERO.CDX" ) ADDITIVE

   RECOVER USING oError

      lOpen       := .f.

      MsgStop( "Imposible abrir toda la base de datos" + CRLF + ErrorMessage( oError ))

   END SEQUENCE

   ErrorBlock( oBlock )

   if !lOpen
      CloseFiles()
   end if

RETURN( lOpen )

//----------------------------------------------------------------------------//

STATIC FUNCTION CloseFiles()

   CLOSE ( dbfCajero )

   dbfCajero      := nil

   if oWndBrw != nil
      oWndBrw     := nil
   end if

RETURN .T.

//----------------------------------------------------------------------------//

FUNCTION Cajero( oMenuItem, oWnd )

   DEFAULT  oMenuItem   := "01018"
   DEFAULT  oWnd        := oWnd()

	IF oWndBrw == NIL

      /*
      Obtenemos el nivel de acceso
      */

      if nLevel == nil
         nLevel := nLevelUsr( oMenuItem )
      end if

      if nAnd( nLevel, 1 ) != 0
         msgStop( "Acceso no permitido." )
         return nil
      end if

      /*
      Cerramos todas las ventanas
      */

      if oWnd != nil
         SysRefresh(); oWnd:CloseAll(); SysRefresh()
      end if

      /*
      Apertura de ficheros
      */

      IF !OpenFiles()
         RETURN NIL
      END IF

      /*
      Anotamos el movimiento para el navegador
      */

      AddMnuNext( "Cajeros", ProcName() )

      DEFINE SHELL oWndBrw FROM 2, 10 TO 18, 70 ;
			TITLE 	"Cajeros" ;
			FIELDS 	(dbfCajero)->CCODCAJ,;
						(dbfCajero)->CNOMCAJ,;
						(dbfCajero)->CNIFCAJ;
         HEAD     "Código",;
						"Nombre",;
						"N.I.F.";
         JUSTIFY  .F., .F., .F. ;
         PROMPT   "Código",;
						"Nombre" ;
			ALIAS		( dbfCajero ) ;
         APPEND   WinAppRec( oWndBrw:oBrw, bEdit, dbfCajero, ,  ) ;
			EDIT	   WinEdtRec( oWndBrw:oBrw, bEdit, dbfCajero ) ;
			DELETE   DBDelRec(  oWndBrw:oBrw, dbfCajero ) ;
			DUPLICAT WinDupRec( oWndBrw:oBrw, bEdit, dbfCajero, , {|oGet| NotValid( oGet, dbfCajero, .T., "0" ) } ) ;
         MRU      "CCODCAJ + Space( 1 ) + CNOMCAJ" ;
         LEVEL    nLevel ;
         OF       oWnd

      DEFINE BTNSHELL RESOURCE "BUS" OF oWndBrw ;
			NOBORDER ;
         ACTION   ( oWndBrw:SearchSetFocus() ) ;
			TOOLTIP 	"(B)uscar" ;
         HOTKEY   "B"

         oWndBrw:AddSeaBar()

      DEFINE BTNSHELL RESOURCE "NEW" OF oWndBrw ;
			NOBORDER ;
         ACTION   ( oWndBrw:RecAdd() );
         ON DROP  ( oWndBrw:RecDup() );
         TOOLTIP  "(A)ñadir";
         BEGIN GROUP;
         HOTKEY   "A";
         LEVEL    ACC_APPD

		DEFINE BTNSHELL RESOURCE "DUP" OF oWndBrw ;
			NOBORDER ;
			ACTION 	( oWndBrw:RecDup() );
			TOOLTIP 	"(D)uplicar";
         MRU ;
         HOTKEY   "D";
         LEVEL    ACC_APPD

		DEFINE BTNSHELL RESOURCE "EDIT" OF oWndBrw ;
			NOBORDER ;
         ACTION   ( oWndBrw:RecEdit() );
         TOOLTIP  "(M)odificar";
         MRU ;
         HOTKEY   "M";
         LEVEL    ACC_EDIT

		DEFINE BTNSHELL RESOURCE "ZOOM" OF oWndBrw ;
			NOBORDER ;
         ACTION   ( WinZooRec( oWndBrw:oBrw, bEdit, dbfCajero ) );
         TOOLTIP  "(Z)oom";
         MRU ;
         HOTKEY   "Z";
         LEVEL    ACC_ZOOM

		DEFINE BTNSHELL RESOURCE "DEL" OF oWndBrw ;
			NOBORDER ;
         ACTION   ( oWndBrw:RecDel() );
         TOOLTIP  "(E)liminar";
         MRU ;
         HOTKEY   "E";
         LEVEL    ACC_DELE

      DEFINE BTNSHELL RESOURCE "IMP" OF oWndBrw ;
			NOBORDER ;
         ACTION   ( GenReport( dbfCajero ) ) ;
         TOOLTIP  "(L)istado";
         HOTKEY   "L";
         LEVEL    ACC_ZOOM

      DEFINE BTNSHELL RESOURCE "END" GROUP OF oWndBrw ;
			NOBORDER ;
         ACTION   ( oWndBrw:End() ) ;
         TOOLTIP  "(S)alir";
         HOTKEY   "S"

		ACTIVATE WINDOW oWndBrw ;
			VALID ( oWndBrw:oBrw:lCloseArea(), oWndBrw := NIL, .t. )

	ELSE

		oWndBrw:SetFocus()

	END IF

RETURN NIL

//----------------------------------------------------------------------------//

STATIC FUNCTION EdtRec( aTemp, aoGet, dbfCajero, oBrw, bWhen, bValid, nMode )

	local oDlg
	local oGet

	DEFINE DIALOG oDlg RESOURCE "CAJERO" TITLE LblTitle( nMode ) + "Cajero/as"

		REDEFINE GET oGet VAR aTemp[_CCODCAJ];
			ID 		110 ;
         WHEN     ( nMode == APPD_MODE ) ;
         VALID    ( NotValid( oGet, dbfCajero, .t., "0" ) ) ;
			COLOR 	CLR_GET ;
			OF 		oDlg

		REDEFINE GET aTemp[_CNOMCAJ] ;
			ID 		120 ;
         PICTURE  "@!" ;
			COLOR 	CLR_GET ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			OF 		oDlg

		REDEFINE GET aTemp[_CNIFCAJ] ;
			ID 		130 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			COLOR 	CLR_GET ;
			OF 		oDlg

		REDEFINE GET aTemp[_CDOMCAJ] ;
			ID 		140 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			COLOR 	CLR_GET ;
			OF 		oDlg

		REDEFINE GET aTemp[_CPOBCAJ] ;
			ID 		150 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			COLOR 	CLR_GET ;
			OF 		oDlg

      REDEFINE GET aTemp[_CCDPCAJ] ;
         ID       160 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			COLOR 	CLR_GET ;
			OF 		oDlg

		REDEFINE GET aTemp[_CPRVCAJ] ;
         ID       170 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			COLOR 	CLR_GET ;
			OF 		oDlg

      REDEFINE GET aTemp[_CTELCAJ] ;
			ID 		180 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         PICTURE  "999999999999";
			COLOR 	CLR_GET ;
			OF 		oDlg

		REDEFINE GET aTemp[_CFAXCAJ] ;
			ID 		190 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         PICTURE  "999999999999";
			COLOR 	CLR_GET ;
			OF 		oDlg

		REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( WinGather( aTemp, aoGet, dbfCajero, oBrw, nMode ), oDlg:end( IDOK ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
         CANCEL ;
			ACTION 	( oDlg:end() )

   ACTIVATE DIALOG oDlg ON PAINT ( EvalGet( aoGet, nMode ) ) CENTER

RETURN ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

STATIC FUNCTION GenReport( dbfCajero )

	local oReport
	local oFont1
	local oFont2
	local nDevice		:= 1
	local nRecno 		:= ( dbfCajero )->( RecNo() )
   local cTitulo     := Padr( cCodEmp() + " - " + cNbrEmp(), 50 )
   local cSubTitulo  := Padr( "Listado de cajeros", 50 )

	/*
	Llamada a la funcion que activa la caja de dialogo
	*/

	IF SetRep( @cTitulo, @cSubTitulo, @nDevice )

		(dbfCajero)->(dbGoTop())

      DEFINE FONT oFont1 NAME "Courier New" SIZE 0,-10 BOLD
      DEFINE FONT oFont2 NAME "Courier New" SIZE 0,-10

		IF nDevice == 1

			REPORT oReport ;
				TITLE  	Rtrim( cTitulo ),;
							Rtrim( cSubTitulo ) ;
				FONT   	oFont1, oFont2 ;
				HEADER 	"Fecha: " + dtoc(date()) RIGHT ;
            FOOTER   "Página : " + str( oReport:nPage, 3 ) CENTERED;
            CAPTION  "Listado de Cajeros";
				PREVIEW

		ELSE

			REPORT oReport ;
				TITLE  	Rtrim( cTitulo ),;
							Rtrim( cSubTitulo ) ;
				FONT   	oFont1, oFont2 ;
				HEADER 	"Fecha: " + dtoc(date()) RIGHT ;
            FOOTER   "Página : "  + str( oReport:nPage, 3 ) CENTERED;
            CAPTION  "Listado de Cajeros";
            TO PRINTER

		END IF

         COLUMN TITLE   "Codigo" ;
            DATA        (dbfCajero)->CCODCAJ ;
            FONT        2

         COLUMN TITLE   "Nombre" ;
            DATA        (dbfCajero)->CNOMCAJ ;
            FONT        2

         COLUMN TITLE   "N.I.F." ;
            DATA        (dbfCajero)->CNIFCAJ ;
            FONT        2

         COLUMN TITLE   "Domicilio" ,;
                        "Población" ;
            DATA        (dbfCajero)->CDOMCAJ ,;
                        (dbfCajero)->CPOBCAJ ;
				FONT 2


         COLUMN TITLE   "Cod. Postal",;
                        "Provincia" ;
            DATA        (dbfCajero)->CCDPCAJ ,;
                        (dbfCajero)->CPRVCAJ ;
				FONT 2

         COLUMN TITLE   "Teléfono" ,;
                        "Fax" ;
            DATA        (dbfCajero)->CTELCAJ ,;
                        (dbfCajero)->CFAXCAJ ;
				FONT 2

		END REPORT

      IF !Empty( oReport ) .and. oReport:lCreated
			oReport:Margin(0, RPT_RIGHT, RPT_CMETERS)
			oReport:bSkip	:= {|| (dbfCajero)->(DbSkip()) }
		END IF

		ACTIVATE REPORT oReport WHILE !( dbfCajero )->( Eof() )

		oFont1:end()
		oFont2:end()
      oReport:End()

	END IF

	(dbfCajero)->( dbGoTo( nRecno ) )

RETURN NIL

//--------------------------------------------------------------------------//

FUNCTION cCajero( oGet, dbfCajero, oGet2 )


   local oBlock
   local oError
	local cAreaAnt := Alias()
	local lClose 	:= .F.
	local lValid	:= .F.
	local xValor 	:= oGet:varGet()

	IF Empty( xValor )
		IF oGet2 != NIL
			oGet2:cText( "" )
		END IF
		RETURN .T.
	END IF

      oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
      BEGIN SEQUENCE

	IF dbfCajero == NIL

      USE ( cPatEmp() + "CAJERO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CAJERO", @dbfCajero ) )
      SET ADSINDEX TO ( cPatEmp() + "CAJERO.CDX" ) ADDITIVE
		lClose	:= .T.

	END IF

	IF (dbfCajero)->( DbSeek( xValor ) )

		oGet:cText( (dbfCajero)->CCODCAJ )

		IF oGet2 != NIL
			oGet2:cText( (dbfCajero)->CNOMCAJ )
		END IF

		lValid	:= .T.

	ELSE

      msgStop( "Codigo de Cajero/a no encontrado" )

	END IF

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

	IF lClose
		CLOSE ( dbfCajero )
	END IF

	IF cAreaAnt != ""
		SELECT( cAreaAnt )
	END IF

RETURN lValid

//---------------------------------------------------------------------------//

FUNCTION BrwCajero( oGet, dbfCajero, oGet2, lBigStyle )


   local oBlock
   local oError
	local oDlg
	local oGet1
	local cGet1
	local oBrw
   local nOrd        := GetBrwOpt( "BrwCajero" )
	local oCbxOrd
   local aCbxOrd     := { "Código", "Nombre" }
   local cCbxOrd
   local lClose      := .f.

   nOrd              := Min( Max( nOrd, 1 ), len( aCbxOrd ) )
   cCbxOrd           := aCbxOrd[ nOrd ]

   DEFAULT lBigStyle := .f.

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   if Empty( dbfCajero )
      USE ( cPatEmp() + "CAJERO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CAJERO", @dbfCajero ) )
      SET ADSINDEX TO ( cPatEmp() + "CAJERO.CDX" ) ADDITIVE
      lClose         := .t.
   end if

   ( dbfCajero )->( dbGoTop() )

   DEFINE DIALOG oDlg RESOURCE "HELPENTRY" TITLE "Seleccionar cajero"

		REDEFINE GET oGet1 VAR cGet1;
			ID 		104 ;
			ON CHANGE(AutoSeek( nKey, nFlags, Self, oBrw, dbfCajero ) );
         VALID    ( OrdClearScope( oBrw, dbfCajero ) );
         BITMAP   "FIND" ;
         OF       oDlg

		REDEFINE COMBOBOX oCbxOrd ;
			VAR 		cCbxOrd ;
			ID 		102 ;
         ITEMS    aCbxOrd ;
			ON CHANGE( ( dbfCajero )->( OrdSetFocus( oCbxOrd:nAt ) ),;
							oBrw:refresh(),;
							oGet1:SetFocus() ) ;
			OF 		oDlg

		REDEFINE LISTBOX oBrw ;
			FIELDS ;
                  (dbfCajero)->CCODCAJ,;
                  (dbfCajero)->CNOMCAJ ;
			HEADER;
                  "Codigo",;
                  "Nombre" ;
         SIZES ;
                  30,;
                  200;
         ALIAS    (dbfCajero) ;
         ON DBLCLICK ( oDlg:end( IDOK ) );
         ID       105 ;
         OF       oDlg

      if lBigStyle
         oBrw:nHeaderHeight := 36
         oBrw:nFooterHeight := 36
         oBrw:nLineHeight   := 36
      end if

		REDEFINE BUTTON ;
         ID    IDOK ;
			OF 	oDlg ;
         ACTION( oDlg:end(IDOK) )

		REDEFINE BUTTON ;
         ID    IDCANCEL ;
			OF 	oDlg ;
         CANCEL ;
         ACTION( oDlg:end() )

		REDEFINE BUTTON ;
			ID 	500 ;
			OF 	oDlg ;
			ACTION( WinAppRec( oBrw, bEdit, dbfCajero, , {|oGet| NotValid(oGet, dbfCajero) } ) );

		REDEFINE BUTTON ;
			ID 	501 ;
			OF 	oDlg ;
			ACTION( WinEdtRec( oBrw, bEdit, dbfCajero ) )

   ACTIVATE DIALOG oDlg CENTER

   If oDlg:nResult == IDOK

		oGet:cText( (dbfCajero)->CCODCAJ )
		oGet:lValid()

		If ValType( oGet2 ) == "O"
			oGet2:cText( (dbfCajero)->CNOMCAJ )
		End if

	End if

	oGet:setFocus()

   DestroyFastFilter( dbfCajero )

   SetBrwOpt( "BrwCajero", ( dbfCajero )->( OrdNumber() ) )

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

	IF lClose
		Close( dbfCajero )
	END IF

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

FUNCTION mkCajero( cPath, lAppend, cPathOld, oMeter )

   DEFAULT cPath     := cPatEmp()
	DEFAULT lAppend	:= .f.

   dbCreate( cPath + "CAJERO.DBF", aBase, cDriver() )
	rxCajero( cPath, oMeter )

   if lAppend .and. lIsDir( cPathOld )
      AppDbf( cPathOld, cPath, "CAJERO" )
   end if

RETURN NIL

//--------------------------------------------------------------------------//

FUNCTION rxCajero( cPath, oMeter )

   local oBlock
   local oError
	local dbfCajero

   DEFAULT cPath  := cPatDat()

   IF !File( cPath + "CAJERO.DBF" )
      dbCreate( cPath + "CAJERO.DBF", aBase, cDriver() )
	END IF

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   dbUseArea( .t., cDriver(), cPath + "CAJERO.DBF", cCheckArea( "CAJERO", @dbfCajero ), .f. )

	IF oMeter != NIL
		oMeter:nTotal := ( dbfCajero )->( LastRec() ) + 1
      oMeter:cText  := "1 Cajero/as"
      ordCondSet("!Deleted()", {||!Deleted()},,, {|| oMeter:Set( ( dbfCajero )->( RecNo() ) ), sysrefresh() }, 1, ( dbfCajero )->( RecNo() ), )
   ELSE
      ordCondSet("!Deleted()", {||!Deleted()}  )
   END IF

   ordCreate( cPath + "CAJERO.CDX", "CCODCAJ", "Field->CCODCAJ", {|| Field->CCODCAJ }, )

	IF oMeter != NIL
      oMeter:cText  := "2 Cajero/as"
		ordCondSet(,,,, {|| oMeter:Set( ( dbfCajero )->( RecNo() ) ), sysrefresh() }, 1, ( dbfCajero )->( RecNo() ), )
      ordCondSet("!Deleted()", {||!Deleted()},,, {|| oMeter:Set( ( dbfCajero )->( RecNo() ) ), sysrefresh() }, 1, ( dbfCajero )->( RecNo() ), )
   ELSE
      ordCondSet("!Deleted()", {||!Deleted()}  )
   END IF

   ordCreate( cPath + "CAJERO.CDX", "CNOMCAJ", "Field->CNOMCAJ", {|| Field->CNOMCAJ } )

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

	( dbfCajero )->( dbCloseArea() )

RETURN NIL

//--------------------------------------------------------------------------//

FUNCTION RetCajero( cCodCaj, dbfCajero )

   local oBlock
   local oError
   local cCajero     := ""
	local lClose		:= .F.

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   IF dbfCajero == NIL
      USE ( cPatEmp() + "CAJERO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CAJERO", @dbfCajero ) )
      SET ADSINDEX TO ( cPatEmp() + "CAJERO.CDX" ) ADDITIVE
		lClose	:= .T.
	END IF

   IF ( dbfCajero )->( DbSeek( cCodCaj ) )
      cCajero := ( dbfCajero )->CNOMCAJ
	END IF

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

	IF lClose
      CLOSE ( dbfCajero )
	END IF

RETURN rtrim( cCajero )

//--------------------------------------------------------------------------//