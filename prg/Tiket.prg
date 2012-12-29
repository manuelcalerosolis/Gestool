#include "fivedos.ch"
#include "FontDef.h"
#include "Eval.ch"
#include "CtlAlign.ch"
#include "Colores.ch"

//--------------------------------------------------------------------------//

/*
Base de datos de Vendedores
*/

#define _NTIKET                    1      //   C     10     0
#define _DFECHA                    2      //   D      8     0
#define _CHORA                     3      //   C      5     0
#define _CVENDOR                   4      //   C      3     0
#define _CCLIENT                   5      //   C      7     0

static oDbf
static oDbfDetalle

//--------------------------------------------------------------------------//

Function HisTiket( oDbfVendor )

   local oBlock
   local oError
	local oLbx
	local oDlg
	local dbfTiket

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

	USE DATABASE oDbf FILE "Tikett" SHARED INDEX "Tikett.ntx"

	USE DATABASE oDbfDetalle FILE "Tiketl" SHARED INDEX "Tiketl.ntx"

	DEFINE DIALOG oDlg AT 4, 22 SIZE 56, 16 TITLE "Historico de Tikets"

	@  2, 2 LISTBOX oLbx ;
			FIELDS ;
				Trans( Tikett->nTiket, "9999999999" ),;
				Tikett->dFecha,;
				Tikett->cHora,;
				Tikett->cVendor,;
				Trans( nTotal( Tikett->nTiket, oDbfDetalle ), "@E 999,999" );
			HEADERS ;
				"N§ Tiket" ,;
				"Fecha" ,;
				"Hora" ,;
				"Caja" ,;
				"Total" ;
			FIELDSIZES ;
				11 ,;
				09 ,;
				06 ,;
				04 ,;
				08 ;
			SIZE 48, 08 ;
			ALIAS oDbf ;
			ON DBLCLICK EdtTiket( oLbx, oDbf, EDIT_MODE ) ;
			OF oDlg

	@ 12, 02 BUTTON " &Visualizar " ;
			ACTION EdtTiket( oLbx, oDbf, EDIT_MODE ) ;
			OF oDlg

	@ 12, 16 BUTTON " &Buscar " OF oDlg ACTION SeekTiket( oLbx, oDbf )

	@ 12, 26 BUTTON " &Salir  " OF oDlg ACTION oDlg:End()

	ACTIVATE DIALOG oDlg CENTERED	;
			ON INIT putHotKey( .f. ) ;
			VALID putHotKey( .t. ) ;
			ON PAINT oDlg:Box3d( 1, 1, 10, 50, nStrColor("gr+/bg" ) )

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

	oDbf:Close()
	oDbfDetalle:Close()

Return nil

//--------------------------------------------------------------------------//

Static Function EdtTiket( oLbx, oDbf, nMode )

	local oDlg
	local cTitle
	local oLbx2
	local nTiket
	local dbfDetalle

	oDbf:setBuffer(.t.)
	oDbf:Load()

	nTiket     := oDbf:nTiket
	dbfDetalle := oDbfDetalle:cAlias

	DEFINE DIALOG oDlg AT 2, 2 SIZE 76, 19 TITLE "Visualizando Tiket"

	@ 1, 2 GET oDbf:nTiket PROMPT "&Tiket  : " ;
				WHEN .F. ;
				OF oDlg

	@ 2, 2 GET oDbf:dFecha PROMPT "&Fecha  : " ;
				WHEN .F. ;
				OF oDlg

	@ 3, 2 GET oDbf:cHora  PROMPT "&Hora   : " ;
				WHEN .F. ;
				OF oDlg

	@ 4, 2 GET oDbf:cVendor PROMPT "&Cajera : ";
				WHEN .F. ;
				OF oDlg

	@ 5, 1 LISTBOX oLbx2 ;
				FIELDS ;
					Trans( (dbfDetalle)->Unidades, "@E 99,999" ) ,;
					(dbfDetalle)->CodeBase ,;
					(dbfDetalle)->Nombre ,;
					Trans( (dbfDetalle)->PVenta, "@E 9,999,999" ) ,;
					Trans( (dbfDetalle)->PVenta * (dbfDetalle)->Unidades, "@E 99,999,999" ) ;
				HEADERS ;
					"Unds.",;
               "Código",;
					"Descripci¢n",;
					"Precio",;
					"Importe";
				FIELDSIZES ;
					06 ,;
					15 ,;
					22 ,;
					09 ,;
					10 ;
				SIZE 72, 12 ;
				ALIAS oDbfDetalle ;
				FOR nTiket ;
				OF oDlg

	ACTIVATE WINDOW oDlg

	oDbf:SetBuffer( .f. )

Return nil

//---------------------------------------------------------------------------//

Static Function SeekTiket( oLbx, oDbf )

	local nRecNo := oDbf:RecNo()
	local cCode  := Space( 4 )

	if lMsgGet( "Tiket a buscar", "&Codigo:", @cCode )
		if oDbf:Seek( Upper( Trim( cCode ) ) )
			oLbx:Refresh()
		else
			alert( "No Found" )
			oDbf:Goto( nRecNo )
		endif
	endif

Return nil

//---------------------------------------------------------------------------//

static function DelTiket( oLbx, oDbf )

    local nKey := oDbf:KeyNum()

    if ApoloMsgNoYes( "¨ Desea borrar Registro ?;" + AllTrim( oDbf:Nombre ), "Borrar Registro" )
		  oDbf:RecLock()
		  oDbf:Delete()
		  oDbf:KeyGoto( nKey )
		  oLbx:Refresh()
	 endif

return nil

//---------------------------------------------------------------------------//

Static Function nTotal( nTiket, oDbfDetalle )

	local nTotal := 0
	local cAlias := oDbfDetalle:cAlias
	local nRecno := oDbfDetalle:RecNo()

	(cAlias)->( dbSeek( nTiket ) )

	while ! (cAlias)->(eof())
		nTotal += (cAlias)->PVenta * (cAlias)->Unidades
		(cAlias)->(dbSkip(1))
	end while

	(cAlias)->(dbGoTo( nRecno ) )

Return ( nTotal )

//----------------------------------------------------------------------------//