#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Report.ch"

static oDlg
static cFileName
static oProc
static cProvee		:= "       "
static cFamily		:= "     "
static cIva       := " "
static nPct 		:= 0

//---------------------------------------------------------------------------//

FUNCTION ImpDiter()

   local oBlock
   local oError
	local oFileName
	local oProvee
	local oProvName, cProvName
	local oFamily
	local oFamiName, cFamiName
	local oIva, oIvaName, cIvaName
	local nProc
	local cAlias, cAliArtp
	local lEnd := .T.

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   USE ( cPatArt() + "ARTICULO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ARTICULO", @cAlias ) )
   SET ADSINDEX TO ( cPatArt() + "ARTICULO.CDX" ) ADDITIVE

   USE ( cPatArt() + "PROVART.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PROVART", @cAliArtp ) )
   SET ADSINDEX TO ( cPatArt() + "PROVART.CDX" ) ADDITIVE

	DEFINE DIALOG oDlg RESOURCE "DITER"

		REDEFINE GET oFileName VAR cFileName;
			ID 100 ;
			COLOR CLR_GET ;
			OF oDlg

		REDEFINE BUTTON ;
			ID 101 ;
			OF oDlg ;
         ACTION ( oFileName:cText( cGetFile( "*.dbf", "Seleccion de Fichero" ) ) )

		REDEFINE GET nPct;
			ID 102 ;
			COLOR CLR_GET ;
			PICTURE "999";
			OF oDlg

		REDEFINE GET oFamily VAR cFamily ;
			ID 106 ;
			VALID ( cFamilia( oFamily, ,oFamiName ) );
         ON HELP ( BrwFamilia( oFamily, oFamiName ) );
			COLOR CLR_GET ;
			OF oDlg

		REDEFINE GET oFamiName VAR cFamiName ;
			WHEN .F. ;
			ID 107 ;
			COLOR CLR_GET ;
			OF oDlg

		REDEFINE GET oProvee VAR cProvee ;
			ID 103 ;
			VALID ( cProvee( oProvee, ,oProvName ) );
			ON HELP ( BrwProvee( oProvee, ,oProvName ) ) ;
			COLOR CLR_GET ;
			OF oDlg

		REDEFINE GET oProvName VAR cProvName ;
			WHEN .F. ;
			ID 104 ;
			COLOR CLR_GET ;
			OF oDlg

		REDEFINE GET oIva VAR cIva ;
			ID 108 ;
			VALID ( cTiva( oIva, , oIvaName ) );
			ON HELP ( BrwIva( oIva, , oIvaName ) ) ;
			COLOR CLR_GET ;
			OF oDlg

		REDEFINE GET oIvaName VAR cIvaName ;
			WHEN .F. ;
			ID 109 ;
			COLOR CLR_GET ;
			OF oDlg

		/*----------------------------------------------------------------------------//
REDEFINE APOLOMETER oProc VAR nProc TOTAL 100 ;
			ID 105 ;
			OF oDlg

		REDEFINE BUTTON ;
         ID IDOK ;
			OF oDlg ;
			ACTION ( IF( AppExter( cAlias, cAliArtp, @lEnd  ),;
                  ( oDlg:end( IDOK ) ), ) )

		REDEFINE BUTTON ;
			ID IDCANCEL ;
			OF oDlg ;
			ACTION ( oDlg:end() )

	ACTIVATE DIALOG oDlg ;
		CENTER ;
		VALID lEnd

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

	CLOSE ( cAliArtp )
	CLOSE ( cAlias )

RETURN NIL

//---------------------------------------------------------------------------//

STATIC FUNCTION AppExter( cAlias, cAliArtp, lEnd )

   local oBlock
   local oError
	local nOldTag := (cAlias)->(OrdSetFocus( 1 ))

	CursorWait()

	lEnd = .F.

	IF !File ( cFileName )
		MsgStop( "El fichero no existe" )
		RETURN .F.
	END IF

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   USE ( cFileName ) ALIAS "EXTFILE"

	oProc:nTotal = EXTFILE->( LastRec() + 1 )

	WHILE ! EXTFILE->(Eof())

		IF !(cAlias)->( DbSeek( "01" + Rjust( EXTFILE->( FieldGet( 1 ) ), "0", 12 ) ) )
			(cAlias)->( DbAppend() )
		ELSE
         (cAlias)->( dbRLock() )
		END IF

		/*
		Si ya existe el Articulo ten solo modificamos precios y
		sobreescribimos el proveedor por si acaso
		*/

		(cAlias)->CODIGO  = EXTFILE->(FieldGet( 1 ))
		(cAlias)->NOMBRE  = OemToAnsi( EXTFILE->(FieldGet( 2 ) ) )
		(cAlias)->FAMILIA = cFamily
		(cAlias)->PCOSTO  = EXTFILE->(FieldGet( 3 ))
		(cAlias)->BENEF1  = nPct
		(cAlias)->PVENTA1 = ( (cAlias)->PCOSTO * nPct / 100 ) + (cAlias)->PCOSTO
		(cAlias)->PVENTA3 = ( (cAlias)->PCOSTO * nPct / 100 ) + (cAlias)->PCOSTO
		(cAlias)->TIPOIVA = cIva

		(cAliArtp)->( DbAppend() )
		(cAliArtp)->CCODART = EXTFILE->(FieldGet( 1 ))
		(cAliArtp)->CCODPRV = cProvee
		(cAliArtp)->CREFPRV = EXTFILE->(FieldGet( 1 ))

		oProc:Set( EXTFILE->( RecNo() ) )
		sysrefresh()
		cursorwait()

		EXTFILE->( DbSkip() )

	END WHILE

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

	EXTFILE->(DbClosearea())

	(cAlias)->(OrdSetFocus( nOldTag ) )

	lEnd = .T.

RETURN .T.

//---------------------------------------------------------------------------//