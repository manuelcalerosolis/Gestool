#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Report.ch"
#include "SixNsx.ch"
#include "MachSix.ch"

//---------------------------------------------------------------------------//

static oDlg
static cFileName
static oProc
static cProvee
static cFamily
static cIva
static nPct := 0

FUNCTION ImpData( cAlias, oBrw )

	local oFileName
	local oProvee
	local oProvName, cProvName
	local oFamily
	local oFamiName, cFamiName
	local oIva, oIvaName, cIvaName
	local nProc
	local lEnd := .T.

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
			VALID ( hFamilia( oFamily, ,oFamiName ) );
			COLOR CLR_GET ;
			OF oDlg

		REDEFINE GET oFamiName VAR cFamiName ;
			WHEN .F. ;
			ID 107 ;
			COLOR CLR_GET ;
			OF oDlg

		REDEFINE GET oProvee VAR cProvee ;
			ID 103 ;
			VALID ( hProvee( oProvee, ,oProvName ) );
			COLOR CLR_GET ;
			OF oDlg

		REDEFINE GET oProvName VAR cProvName ;
			WHEN .F. ;
			ID 104 ;
			COLOR CLR_GET ;
			OF oDlg

		REDEFINE GET oIva VAR cIva ;
			ID 108 ;
			VALID ( hTiva( oIva, ,oIvaName ) );
			COLOR CLR_GET ;
			OF oDlg

		REDEFINE GET oIvaName VAR cIvaName ;
			WHEN .F. ;
			ID 109 ;
			COLOR CLR_GET ;
			OF oDlg

        REDEFINE APOLOMETER oProc VAR nProc TOTAL 100 ;
			ID 105 ;
			OF oDlg

		REDEFINE BUTTON ;
         ID IDOK ;
			OF oDlg ;
			ACTION ( IF( AppExter( cAlias, @lEnd  ),;
                  ( oDlg:end( IDOK ) ), ) )

		REDEFINE BUTTON ;
			ID IDCANCEL ;
			OF oDlg ;
			ACTION ( oDlg:end() )

	ACTIVATE DIALOG oDlg CENTER VALID lEnd

RETURN NIL

//---------------------------------------------------------------------------//

STATIC FUNCTION AppExter( cAlias, lEnd )

	local nOldTag := (cAlias)->(ORDSETFOCUS( 1 ))

	CursorWait()

	lEnd = .F.

	IF !File ( cFileName )
		MsgStop( "El fichero no existe", "!! Aviso del Sistema нн" )
		RETURN .F.
	END IF

   USE ( cFileName ) ALIAS "EXTFILE"

	oProc:nTotal = EXTFILE->( LastRec() + 1 )

	WHILE ! EXTFILE->(Eof())

		IF !(cAlias)->( DbSeek( EXTFILE->( FieldGet( 1 ) ) ) )

			(cAlias)->( DbAppend() )

			(cAlias)->CODIGO  = "00" + Rjust( EXTFILE->(FieldGet( 1 )), "0", 12 )

		ELSE

         (cAlias)->( dbRLock() )

		END IF

		/*
		Si ya existe el Articulo ten solo modificamos precios y
		sobreescribimos el proveedor por si acaso
		*/

		(cAlias)->NOMBRE  = EXTFILE->(FieldGet( 2 ) )
		(cAlias)->FAMILIA = cFamily
		(cAlias)->CODPROV = cProvee
		(cAlias)->REFPROV = EXTFILE->(FieldGet( 1 ))
		(cAlias)->PCOSTO  = Val( EXTFILE->(FieldGet( 4 )) )
		(cAlias)->BENEF   = nPct
		(cAlias)->PVENTA1 = ( (cAlias)->PCOSTO * nPct / 100 ) + (cAlias)->PCOSTO
		(cAlias)->TIPOIVA = cIva

		oProc:Set( EXTFILE->( RecNo() ) )
		sysrefresh()
		cursorwait()

		EXTFILE->( DbSkip() )

	END WHILE

   EXTFILE->(DbClosearea())

	(cAlias)->(OrdSetFocus( nOldTag ) )

	lEnd = .T.

RETURN .T.

//---------------------------------------------------------------------------//