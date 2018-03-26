#include "FiveWin.Ch"
#include "Report.ch"
#include "Factu.ch" 

#define _CCODPLT                   1      //   C      3     0
#define _CDESPLT                   2      //   C     50     0

#define _dCCODPLT                  1      //   C      3     0
#define _CFAMPLT                   2      //   C      5     0

static oWndBrw
static oInf
static dbfPltCliT
static dbfPltCliL
static dbfFamilia
static dbfTmp
static cNewFile
static oGetTotal
static bEdit1 := { |aTemp, aoGet, dbfPltCliT, oBrw, bWhen, bValid, nMode, xOthers | EdtRec( aTemp, aoGet, dbfPltCliT, oBrw, bWhen, bValid, nMode, xOthers ) }
static bEdit2 := { |aTemp, aoGet, dbfPltCliL, oBrw, bWhen, bValid, nMode, nPreCli | EdtDet( aTemp, aoGet, dbfPltCliL, oBrw, bWhen, bValid, nMode, nPreCli ) }

static aPltCliT :={{"CCODPLT" ,"C",    3,  0, "Codigo de la plantilla" },;
                  { "CDESPLT" ,"C",   50,  0, "Descripción de la plantilla" }}

static aPltCliL :={{"CCODPLT" ,"C",    3,  0, "Codigo de la plantilla" },;
                  { "CFAMPLT" ,"C",    5,  0, "Codigo de la familia" } }

//----------------------------------------------------------------------------//

FUNCTION PltCli( oWnd )

	IF oWndBrw == NIL

   USE ( cPatEmp() + "PLTCLIT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PLTCLIT", @dbfPltCliT ) )
   SET ADSINDEX TO ( cPatEmp() + "PLTCLIT.CDX" ) ADDITIVE

   USE ( cPatEmp() + "PLTCLIL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PLTCLIL", @dbfPltCliL ) )
   SET ADSINDEX TO ( cPatEmp() + "PLTCLIL.CDX" ) ADDITIVE

   USE ( cPatEmp() + "FAMILIAS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FAMILIAS", @dbfFamilia ) )
   SET ADSINDEX TO ( cPatEmp() + "FAMILIAS.CDX" ) ADDITIVE

   DEFINE SHELL oWndBrw FROM 2, 10 TO 18, 70;
		TITLE 	"Plantillas de Presupuestos" ;
		FIELDS 	(dbfPltCliT)->CCODPLT, ;
					(dbfPltCliT)->CDESPLT ;
      HEAD     "Codigo",;
					"Plantilla";
      PROMPT   "Codigo",;
					"Nombre";
		ALIAS 	( dbfPltCliT ) ;
		APPEND	( WinAppRec( oWndBrw:oBrw, bEdit1, dbfPltCliT, , {|oGet| NotValid(oGet, dbfPltCliT, .T., "0") }, dbfPltCliT ) );
		DUPLICAT ( WinDupRec( oWndBrw:oBrw, bEdit1, dbfPltCliT, , {|oGet| NotValid(oGet, dbfPltCliT, .T., "0") }, dbfPltCliT ) );
		EDIT 		( WinEdtRec( oWndBrw:oBrw, bEdit1, dbfPltCliT, , , dbfPltCliL ) ) ;
		DELETE   ( DBDelRec(  oWndBrw:oBrw, dbfPltCliT, {|| DelDetalle( (dbfPltCliT)->CCODPLT ) } ) ) ;
		OF 		oWnd

		DEFINE BTNSHELL RESOURCE "NEW" OF oWndBrw ;
			NOBORDER ;
			ACTION 	( oWndBrw:RecAdd() );
			ON DROP	( oWndBrw:RecDup() );
			TOOLTIP 	"(A)ñadir";
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
			ACTION  	( WinZooRec( oWndBrw:oBrw, bEdit1, dbfPltCliT ) );
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

      DEFINE BTNSHELL RESOURCE "END" GROUP OF oWndBrw ;
			NOBORDER ;
			ACTION 	( oWndBrw:End() ) ;
			TOOLTIP 	"(S)alir";
			HOTKEY 	"S"

		ACTIVATE WINDOW oWndBrw ;
			VALID ( End() )

	ELSE

		oWndBrw:SetFocus()

	END IF

RETURN NIL

//----------------------------------------------------------------------------//

STATIC FUNCTION End()

	( dbfFamilia )->( dbCloseArea() )
	( dbfPltCliL )->( dbCloseArea() )
	oWndBrw:oBrw:lCloseArea()

	dbfFamilia	:= NIL
	dbfPltCliT	:= NIL
	oWndBrw 		:= NIL

RETURN .T.

//----------------------------------------------------------------------------//

STATIC FUNCTION EdtRec( aTemp, aoGet, dbfPltCliT, oBrw, bWhen, bValid, nMode )

	local oDlg
	local oGet
	local oBrw2
	local oFont
	local oSay1, cSay1
	local oSay2, cSay2
	local oSay3, cSay3

	BeginTrans( aTemp )

	oFont := TFont():New( "Ms Sans Serif", 6, 12, .F. )

	DEFINE DIALOG oDlg RESOURCE "PLTCLI" TITLE LblTitle( nMode ) + " Plantillas de Presupuestos"

		REDEFINE GET oGet VAR aTemp[_CCODPLT];
			ID 		100 ;
			WHEN 		( EVAL( bWhen, oGet ) ) ;
			VALID 	( EVAL( bValid, oGet ) ) ;
			COLOR 	CLR_SHOW ;
			OF 		oDlg

		REDEFINE GET aoGet[_CDESPLT] VAR aTemp[_CDESPLT];
			ID 		110 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			COLOR 	CLR_GET ;
			OF 		oDlg

		REDEFINE LISTBOX oBrw2 ;
			FIELDS ;
				(dbfTmp)->CFAMPLT,;
				retFamilia( (dbfTmp)->CFAMPLT, dbfFamilia );
			HEAD ;
            "Codigo",;
				"Fmilia";
			ALIAS ( dbfTmp );
			ID 200 ;
			OF oDlg ;
			FONT oFont

			IF nMode	!= ZOOM_MODE
				oBrw2:bLDblClick 	= {|| EdtDeta( oBrw2, bEdit2, aTemp ) }
				oBrw2:bAdd 			= {|| AppDeta( oBrw2, bEdit2, aTemp ) }
				oBrw2:bEdit			= {|| EdtDeta( oBrw2, bEdit2, aTemp ) }
				oBrw2:bDel 			= {|| DelDeta( oBrw2, aTemp ) }
			END IF

		REDEFINE BUTTON ;
			ID 		500 ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			ACTION 	( AppDeta(oBrw2, bEdit2, aTemp) )

		REDEFINE BUTTON ;
			ID 		501 ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			ACTION 	( EdtDeta(oBrw2, bEdit2, aTemp ) )

		REDEFINE BUTTON ;
			ID 		502 ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			ACTION 	( DelDeta( oBrw2, aTemp ) )

		REDEFINE BUTTON ;
			ID 		524 ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			ACTION 	( DbSwapUp( dbfTmp, oBrw2 ) )

		REDEFINE BUTTON ;
			ID 		525 ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			ACTION 	( DbSwapDown( dbfTmp, oBrw2 ) )

		REDEFINE BUTTON ;
			ID 		511 ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			ACTION 	( EndTrans( aTemp, nMode, oBrw2 ),;
						WinGather( aTemp, , dbfPltCliT, oBrw, nMode ),;
						oDlg:end() )

		REDEFINE BUTTON ;
			ID 		510 ;
			OF 		oDlg ;
			ACTION 	( KillTrans( aTemp ),;
						oDlg:end() )

	ACTIVATE DIALOG oDlg	ON PAINT EvalGet( aoGet, nMode ) CENTER

RETURN ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

/*
Funcion Auxiliar para A¤adir lineas de detalle a un pedido
*/

STATIC FUNCTION AppDeta(oBrw2, bEdit2, aTemp)

RETURN WinAppRec( oBrw2, bEdit2, dbfTmp, , , aTemp[_CCODPLT] )

//--------------------------------------------------------------------------//

/*
Funcion Auxiliar para la Edici¢n de Lineas de Detalle en un pedido
*/

STATIC FUNCTION EdtDeta( oBrw2, bEdit2, aTemp )

RETURN WinEdtRec( oBrw2, bEdit2, dbfTmp )

//--------------------------------------------------------------------------//

/*
Funcion Auxiliar para borrar las Lineas de Detalle en un pedido
*/

STATIC FUNCTION DelDeta(oBrw2, aTemp )

RETURN DBDelRec( oBrw2, dbfTmp )

//--------------------------------------------------------------------------//

/*
Edita las lineas de Detalle
*/

STATIC FUNCTION EdtDet( aTemp, aoGet, dbfPltCliL, oBrw, bWhen, bValid, nMode, nPltCli )

	local oDlg2
	local oGet
	local cGet

	IF nMode 	== APPD_MODE
		aTemp[_dCCODPLT] := nPltCli
	END CASE

	DEFINE DIALOG oDlg2 RESOURCE "LPLTCLI" TITLE LblTitle( nMode ) + "Lineas a Pedidos de Clientes"

		REDEFINE GET aoGet[_CFAMPLT] VAR aTemp[_CFAMPLT];
			ID 		100 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			VALID 	( cFamilia( aoGet[_CFAMPLT], dbfFamilia, oGet ) ) ;
         ON HELP  ( BrwFamilia( aoGet[_CFAMPLT], oGet ) ) ;
			COLOR 	CLR_GET ;
			OF 		oDlg2

		REDEFINE GET oGet VAR cGet;
			ID 		110 ;
			WHEN 		( .F. ) ;
			COLOR 	CLR_SHOW ;
			OF 		oDlg2

      REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg2 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			ACTION 	( SaveDeta( aTemp, aoGet, oDlg2, oBrw, nMode ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg2 ;
			ACTION 	( oDlg2:end() )

	ACTIVATE DIALOG oDlg2 CENTER

RETURN ( oDlg2:nResult == IDOK )

//--------------------------------------------------------------------------//

STATIC FUNCTION SaveDeta( aTemp, aoGet, oDlg2, oBrw, nMode )

	WinGather( aTemp, aoGet, dbfTmp, oBrw, nMode )

	IF nMode == APPD_MODE .AND. aIni()[ENTCONT]
		aoGet[_CREF]:VarPut( Space( 5 ) )
		aoGet[_CREF]:SetFocus()
	ELSE
      oDlg2:end( IDOK )
	END IF

RETURN NIL

//--------------------------------------------------------------------------//

FUNCTION NewPltCli( oGet )

	local dbfCount
	local nPltCli

	WHILE .T.
      USE ( cPatEmp() + "COUNT.DBF" ) NEW VIA ( cDriver() )ALIAS ( cCheckArea( "COUNT", @dbfCount ) )
		IF !netErr()
			EXIT
		END IF
	END WHILE

	nPltCli	:= ( dbfCount )->NPLTCLI
	( dbfCount )->NPLTCLI++

	CLOSE ( dbfCount )

RETURN ( nPltCli )

//---------------------------------------------------------------------------//

/*
Borra todas las lineas de detalle de un pedido
*/

STATIC FUNCTION DelDetalle( cCodPlt )

	local oDlg
	local nWidth
	local cTitle 	:= "Espere por favor..."
	local cCaption := "Borrando lineas de detalle"

	DEFINE DIALOG oDlg ;
		FROM 0,0 TO 4, Max( Len( cCaption ), Len( cTitle ) ) + 4 ;
		TITLE cTitle ;
		STYLE DS_MODALFRAME

	nWidth 			:= oDlg:nRight - oDlg:nLeft
	oDlg:cMsg   	:= cCaption

	ACTIVATE DIALOG oDlg ;
		CENTER ;
		NOWAIT ;
		ON PAINT oDlg:Say( 1, 0, xPadC( oDlg:cMsg, nWidth ) )

	IF (dbfPltCliL)->(DbSeek( cCodPlt ) )

		DO WHILE ( (dbfPltCliL)->CCODPLT == cCodPlt ) .AND. !(dbfPltCli)->(Eof())

         if dbLock( dbfPltCliL )
            ( dbfPltCliL )->( DbDelete() )
         end if
         ( dbfPltCliL )->( DbSkip() )

		END WHILE

	END IF

	oDlg:End()
	SysRefresh()

RETURN NIL

//------------------------------------------------------------------------//

STATIC FUNCTION BeginTrans( aTemp )

	local aField
   local cDbf     := "TCliL"
	local nPltCli	:= aTemp[_CCODPLT]

   cNewFile       := cGetNewFileName( cPatTmp() + cDbf )

	/*
	Primero Crear la base de datos local
	*/

   dbCreate( cNewFile, aPltCliL, cDriver() )
   dbUseArea( .t., cDriver(), cNewFile, cCheckArea( cDbf, @dbfTmp ), .f. )
   ( dbfTmp )->( OrdCondSet( "!Deleted()", {||!Deleted() } ) )
   ( dbfTmp )->( OrdCreate( cNewFile, "Recno", "Str( Recno() )", {|| Str( Recno() ) } ) )

	/*
	A¤adimos desde el fichero de lineas
	*/

	IF ( dbfPltCliL )->(DbSeek( nPltCli ) )

		DO WHILE ( ( dbfPltCliL )->CCODPLT == nPltCli .AND. !( dbfPltCliL )->( Eof() ) )

			( dbfTmp )->( dbAppend() )
         dbPass( dbfPltCliL, dbfTmp )
			( dbfPltCliL )->( DbSkip() )

		END WHILE

	END IF

	( dbfTmp )->( dbGoTop() )

RETURN NIL

//-----------------------------------------------------------------------//

STATIC FUNCTION EndTrans( aTemp, nMode, oBrw )

	local oDlg
	local nWidth
	local oMeter
	local nMeter
	local aTabla
	local cPltCli	:= aTemp[_CCODPLT]
	local cCaption := "Actualizando Fichero de Trabajo"

	/*
	Primero hacer el RollBack
	*/

	DEFINE DIALOG oDlg RESOURCE "WAIT"

		REDEFINE SAY ;
			PROMPT cCaption ;
			ID 120 ;
			OF oDlg

		/*----------------------------------------------------------------------------//
REDEFINE APOLOMETER oMeter VAR nMeter ;
			PROMPT "ACTUALIZANDO" ;
			ID 150 ;
			OF oDlg

	ACTIVATE DIALOG oDlg CENTER NOWAIT

	/*
	Roll Back
	*/

	IF (dbfPltCliL)->( DbSeek( cPltCli ) )

		DO WHILE ( (dbfPltCliL)->CCODPLT == cPltCli )

         if dbLock( dbfPltCliL )
            ( dbfPltCliL )->( dbDelete() )
         end if
         ( dbfPltCliL )->( DbSkip() )

		END WHILE

	END IF

	/*
	Ahora escribimos en el fichero definitivo
	*/

	oMeter:nTotal	:= ( dbfTmp )->( LastRec() + 1 )
	( dbfTmp )->( DbGoTop() )

   DO WHILE !( dbfTmp )->( eof() )

		( dbfPltCliL )->( dbAppend() )
		DBGather( DBScatter( dbfTmp ), dbfPltCliL )
		( dbfTmp )->( dbSkip() )

		oMeter:set( ++nMeter )
		sysrefresh()

	END WHILE

	/*
	Borramos los ficheros
	*/

	oBrw:lCloseArea()
   dbfErase( cNewFile )

   /*
   Escribe los datos pendientes------------------------------------------------
   */

   dbCommitAll()

	oDlg:End()

RETURN .T.

//------------------------------------------------------------------------//

STATIC FUNCTION KillTrans()

	/*
	Borramos los ficheros
	*/

	( dbfTmp )->( dbCloseArea() )
   dbfErase( cNewFile )

RETURN .T.

//------------------------------------------------------------------------//

FUNCTION BrwPltCli( oGet, oGet2 )

	local oDlg
	local oBrw
	local oGet1
   local nOrd     := GetBrwOpt( "BrwPltCli" )
	local cGet1
	local oCbxOrd
   local aCbxOrd  := { "Codigo", "Nombre" }
   local cCbxOrd
	local cAreaAnt := Alias()
	local lClose	:= .F.
	local oFont		:= TFont():New( "Ms Sans Serif", 6, 12, .F. )

   nOrd           := Min( Max( nOrd, 1 ), len( aCbxOrd ) )
   cCbxOrd        := aCbxOrd[ nOrd ]

   USE ( cPatEmp() + "PLTCLIT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PLTCLIT", @dbfPltCliT ) )
   SET ADSINDEX TO ( cPatEmp() + "PLTCLIT.CDX" ) ADDITIVE

   USE ( cPatEmp() + "PLTCLIL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PLTCLIL", @dbfPltCliL ) )
   SET ADSINDEX TO ( cPatEmp() + "PLTCLIL.CDX" ) ADDITIVE

	(dbfPltCliT)->(OrdSetFocus(2))
	(dbfPltCliT)->(DbGoTop())

	DEFINE DIALOG oDlg RESOURCE "HELPENTRY"

		REDEFINE GET oGet1 VAR cGet1;
			ID 		104 ;
			ON CHANGE( AutoSeek( nKey, nFlags, Self, oBrw, dbfAgent ) );
         VALID    ( OrdClearScope( oBrw, dbfAgent ) );
         BITMAP   "FIND" ;
         OF       oDlg

		REDEFINE COMBOBOX oCbxOrd ;
			VAR 		cCbxOrd ;
			ID 		102 ;
         ITEMS    aCbxOrd ;
			ON CHANGE( (dbfPltCliT)->( OrdSetFocus( oCbxOrd:nAt ) ), oBrw:refresh(), oGet1:SetFocus() ) ;
			OF oDlg

		REDEFINE LISTBOX oBrw ;
			FIELDS ;
                  (dbfPltCliT)->CCODPLT,;
                  (dbfPltCliT)->CDESPLT ;
			HEAD ;
                  "Código",;
                  "Plantilla" ;
         ID       105 ;
         ALIAS    (dbfPltCliT) ;
         FONT     oFont ;
         OF       oDlg

      oBrw:bLDblClick  := {|| oDlg:end( IDOK ) }
      oBrw:bKeyDown     := {|nKey, nFalg| if( nKey == VK_RETURN, oDlg:end( IDOK ), ) }

		REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
         ACTION   ( oDlg:end(IDOK) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
         CANCEL ;
         ACTION   ( oDlg:end() )

		REDEFINE BUTTON ;
			ID 		500 ;
			OF 		oDlg ;
			ACTION 	( WinAppRec( oBrw, bEdit1, dbfPltCliT, , {|oGet| NotValid( oGet, dbfPltCliT, .T., "0") } ) )

		REDEFINE BUTTON ;
			ID 		501 ;
			OF 		oDlg ;
			ACTION 	( WinEdtRec( oBrw, bEdit1, dbfPltCliT ) )

	ACTIVATE DIALOG oDlg

   If oDlg:nResult == IDOK

		oGet:varPut( (dbfPltCliT)->CCODPLT )
		oGet:refresh()

		If ValType( oGet2 ) == "O"
			oGet2:varPut( (dbfPltCliT)->CDESPLT )
			oGet2:refresh()
		End if

	End if

   DestroyFastFilter( dbfPltCliT )

   SetBrwOpt( "BrwPltCli", ( dbfPltCliT )->( OrdNumber() ) )

	(dbfPltCliT)->(dbCloseArea())
	(dbfPltCliL)->(dbCloseArea())

	IF cAreaAnt != ""
		Select( cAreaAnt )
	END IF

	oGet:setFocus()
	oFont:end()

RETURN oDlg:nResult == IDOK

//---------------------------------------------------------------------------//

FUNCTION cPltCli( oGet, oGet2 )

	local xValor
	local cAreaAnt := Alias()
	local lClose 	:= .F.
	local lValid	:= .F.

	IF Empty( oGet:varGet() )
		RETURN .T.
	ELSE
		xValor 	:= RJustObj( oGet, "0" )
	END IF

   USE ( cPatEmp() + "PLTCLIT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PLTCLIT", @dbfPltCliT ) )
   SET ADSINDEX TO ( cPatEmp() + "PLTCLIT.CDX" ) ADDITIVE

   USE ( cPatEmp() + "PLTCLIT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PLTCLIT", @dbfPltCliT ) )
   SET ADSINDEX TO ( cPatEmp() + "PLTCLIT.CDX" ) ADDITIVE

	IF (dbfPltCliT)->( DbSeek( xValor ) )

		oGet:varPut( (dbfPltCliT)->CCODPLT )
		oGet:refresh()

		IF ValType( oGet2 ) == "O"
			oGet2:varPut( (dbfPltCliT)->CDESPLT )
			oGet2:refresh()
		END IF

		lValid	:= .T.

	ELSE

		msgStop( "Plantilla no encontrada" )

	END IF

	CLOSE (dbfPltCliT)
	CLOSE (dbfPltCliL)

	IF cAreaAnt != ""
		SELECT( cAreaAnt )
	END IF

RETURN lValid

//---------------------------------------------------------------------------//

FUNCTION mkPltCli( cPath, lAppend, cPathOld, oMeter )

	local dbfPltCliT

	IF oMeter != NIL
		oMeter:cText	:= "Generando Bases"
		sysrefresh()
	END IF

   dbCreate( cPath + "PLTCLIT.DBF", aPltCliT, cDriver() )
   dbCreate( cPath + "PLTCLIL.DBF", aPltCliL, cDriver() )

	IF lAppend .and. lIsDir( cPathOld )

      dbUseArea( .t., cDriver(), cPath + "PLTCLIT.DBF", cCheckArea( "PLTCLIT", @dbfPltCliT ), .f. )
      ( dbfPltCliT )->( __dbApp( cPathOld + "PLTCLIT.DBF" ) )
		( dbfPltCliT )->( dbCloseArea() )

      dbUseArea( .t., cDriver(), cPath + "PLTCLIL.DBF", cCheckArea( "PLTCLIL", @dbfPltCliT ), .f. )
      ( dbfPltCliT )->( __dbApp( cPathOld + "PLTCLIL.DBF" ) )
		( dbfPltCliT )->( dbCloseArea() )

	END IF

	rxPltCli( cPath, oMeter )

RETURN NIL

//---------------------------------------------------------------------------//

FUNCTION rxPltCli( cPath, oMeter )

	local dbfPltCliT
	local nEvery

   DEFAULT cPath  := cPatEmp()

   IF !File( cPath + "PLTCLIT.DBF" )
      dbCreate( cPath + "PLTCLIT.DBF", aPltCliT, cDriver() )
	END IF

   IF !File( cPath + "PLTCLIL.DBF" )
      dbCreate( cPath + "PLTCLIL.DBF", aPltCliL, cDriver())
	END IF

   fErase( cPath + "PLTCLIT.CDX" )
   fErase( cPath + "PLTCLIL.CDX" )

   dbUseArea( .t., cDriver(), cPath + "PLTCLIT.DBF", cCheckArea( "PLTCLIT", @dbfPltCliT ), .f. )

   IF oMeter != NIL
      oMeter:nTotal := ( dbfPltCliT )->( LastRec() ) + 1
      nEvery        := Int( oMeter:nTotal / 10 )
      oMeter:cText  := "1 Plt. Cliente"
      ordCondSet("!Deleted()", {||!Deleted()},,, {|| oMeter:Set( ( dbfPltCliT )->( RecNo() ) ), sysrefresh() }, nEvery, ( dbfPltCliT )->( RecNo() ), )
   ELSE
      ordCondSet("!Deleted()", {||!Deleted()}  )
   END IF

   ordCreate( cPath + "PLTCLIT.CDX", "CCODPLT", "CCODPLT", {|| CCODPLT } )

   IF oMeter != NIL
      oMeter:cText  := "2 Plt. Cliente"
      ordCondSet("!Deleted()", {||!Deleted()},,, {|| oMeter:Set( ( dbfPltCliT )->( RecNo() ) ), sysrefresh() }, nEvery, ( dbfPltCliT )->( RecNo() ), )
   ELSE
      ordCondSet("!Deleted()", {||!Deleted()}  )
   END IF

   ordCreate( cPath + "PLTCLIT.CDX", "CDESPLT", "CDESPLT", {|| CDESPLT } )

	( dbfPltCliT )->( dbCloseArea() )

   dbUseArea( .t., cDriver(), cPath + "PLTCLIL.DBF", cCheckArea( "PLTCLIL", @dbfPltCliT ), .f. )

   IF oMeter != NIL
      oMeter:nTotal := ( dbfPltCliT )->( LastRec() ) + 1
      nEvery        := Int( oMeter:nTotal / 10 )
      oMeter:cText  := "3 Plt. Cliente"
      ordCondSet("!Deleted()", {||!Deleted()},,, {|| oMeter:Set( ( dbfPltCliT )->( RecNo() ) ), sysrefresh() }, nEvery, ( dbfPltCliT )->( RecNo() ), )
   ELSE
      ordCondSet("!Deleted()", {||!Deleted()}  )
   END IF

   ordCreate( cPath + "PLTCLIL.CDX", "CCODPLT", "CCODPLT", {|| CCODPLT } )

	( dbfPltCliT )->( dbCloseArea() )

RETURN NIL

//--------------------------------------------------------------------------//