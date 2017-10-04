#include "FiveWin.Ch"
#include "Ini.ch"
#include "Folder.ch"
#include "Factu.ch" 

static aTmpEmp
static aIniApp
static aIniEmp
static aIniTpv
static cDefAlm
static cDefCjr
static cDecCaj
static cAlias
static dbfDiv
static oBandera

//----------------------------------------------------------------------------//

FUNCTION Configura()

   local n
   local oDlg
	local oFld
	local oBtn
   local oDefAlm
   local oDfeFpg
   local oRutaConta
   local cEmpA
   local oEmpA
   local cEmpB
   local oEmpB
   local cCtaCliente
   local oCtaCliente
   local cCtaProvee
   local oCtaProvee
   local cCtaVntCliente
   local oCtaVntCliente
	local cSubCtaPorte, oSubCtaPorte
	local cCtaAbonoCli, oCtaAbonoCli
	local cCtaVtaContado, oCtaVtaContado
	local oCtaAbnPrv, cCtaAbnPrv
	local cSubCtaCliCon, oSubCtaCliCon
   local oGetSer
   local oGetCja, oGetTxtCaja, cGetTxtCaja
	local oGetCjr, oGetTxtCjr, cGetTxtCjr
	local oGetCli, oGetTxtCli, cGetTxtCli
	local oGetFpg, oGetTxtFpg, cGetTxtFpg
   local oGetDiv
   local lExit       := .F.
	local cRutaConta	:= Padr( aIniEmp[RUTACONTA], 100 )
	local cPathDatos 	:= Padr( aIniApp[PATHDATOS], 100 )
   local oColUno
   local oColDos
   local cColUno
   local cColDos
   local aGet        := Array(8)
   local oSay        := Array(3)
   local cSay        := Array(3)
   local oGet

   /*
   Nuevos contadores
   */

   IF !File( cPatEmp() + "NCOUNT.DBF" )
      mkCount()
	END IF

   /*
   Divisas
   */

   USE ( cPatDat() + "DIVISAS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "DIVISAS", @dbfDiv ) )
   SET ADSINDEX TO ( cPatDat() + "DIVISAS.CDX" ) ADDITIVE

   oBandera := TBandera():New

	DEFINE DIALOG oDlg RESOURCE "CONFIG"

	REDEFINE FOLDER oFld ;
		ID 		400 ;
		OF 		oDlg ;
      PROMPT   "A&plicación",;
               "&Empresa",;
               "Co&ntaplus",;
               "T.P.&V.",;
               "&Mascaras";
      DIALOGS  "CONFIG_1",;
               "CONFIG_2",;
               "CONFIG_4",;
               "CONFIG_5",;
               "CONFIG_6"

	/*
	Creamos la primera Caja de Dialogo
	--------------------------------------------------------------------------
	*/

	REDEFINE CHECKBOX aIniApp[USECAJAS] ;
		ID 		110;
		OF 		oFld:aDialogs[1]

	REDEFINE CHECKBOX aIniApp[CALCAJAS] ;
		WHEN		aIniApp[USECAJAS] ;
		ID 		120;
		OF 		oFld:aDialogs[1]

	REDEFINE CHECKBOX aIniApp[ENTCONT] ;
		ID 		130;
		OF 		oFld:aDialogs[1]

	REDEFINE CHECKBOX aIniApp[MODDESC] ;
		ID 		140;
		OF 		oFld:aDialogs[1]

	REDEFINE CHECKBOX aIniApp[MODIVA] ;
		ID 		150;
		OF 		oFld:aDialogs[1]

	REDEFINE CHECKBOX aIniApp[TIPMOV] ;
		ID 		155;
		OF 		oFld:aDialogs[1]

   /*
	REDEFINE GET cPathDatos ;
		ID 		160;
      VALID    ( If ( !Empty( cPathDatos ) .AND. File( cPathDatos + "EMPRESA.DBF" ), .T., ( MsgStop( "Directorio no valido" ), .F. ) ) );
		OF 		oFld:aDialogs[1]
   */

   REDEFINE CHECKBOX aIniApp[LNUMOBRA] ;
      ID       180;
		OF 		oFld:aDialogs[1]

   REDEFINE GET aIniApp[CTXTOBRA] ;
      ID       185;
      WHEN     aIniApp[LNUMOBRA] ;
		OF 		oFld:aDialogs[1]

	REDEFINE CHECKBOX aIniApp[LNUALBARAN] ;
		ID 		190;
		OF 		oFld:aDialogs[1]

	REDEFINE GET aIniApp[CTXTNUALB] ;
		ID 		195;
		WHEN		aIniApp[LNUALBARAN] ;
		OF 		oFld:aDialogs[1]

	REDEFINE CHECKBOX aIniApp[LSUALBARAN] ;
		ID 		200;
		OF 		oFld:aDialogs[1]

	REDEFINE GET aIniApp[CTXTSUALB] ;
		ID 		205;
		WHEN		aIniApp[LSUALBARAN] ;
		OF 		oFld:aDialogs[1]

   REDEFINE CHECKBOX aIniApp[LAUTCOS] ;
      ID       215;
		OF 		oFld:aDialogs[1]

	/*
	Creamos la Segunda Caja de Dialogo
	--------------------------------------------------------------------------
	*/

   REDEFINE GET oDefAlm VAR aIniEmp[DEFAULTALM] ;
		ID 		100;
      PICTURE  "@!" ;
      VALID    ( cAlmacen( oDefAlm, , oSay[1] ) );
      BITMAP   "LUPA" ;
      ON HELP  ( BrwAlmacen( oDefAlm, oSay[1] ) );
		OF 		oFld:aDialogs[2]

   REDEFINE GET oSay[1] VAR cSay[1] ;
		WHEN 		.F. ;
		ID 		101 ;
		COLOR 	CLR_GET ;
		OF 		oFld:aDialogs[2]

   REDEFINE GET oDefFpg VAR aIniEmp[DEFAULTFPG] ;
      ID       110;
      PICTURE  "@!" ;
      VALID    ( cFPago( oDefFpg, , oSay[3] ) ) ;
      BITMAP   "LUPA" ;
      ON HELP  ( BrwFPago( oDefFpg, oSay[3] ) );
		OF 		oFld:aDialogs[2]

   REDEFINE GET oSay[3] VAR cSay[3] ;
		WHEN 		.F. ;
      ID       111 ;
		COLOR 	CLR_GET ;
		OF 		oFld:aDialogs[2]

   REDEFINE CHECKBOX aIniEmp[LUSEPROP] ;
      ID       120;
      OF       oFld:aDialogs[2]

   REDEFINE RADIO aIniEmp[NUSEPROP] ;
      WHEN     ( aIniEmp[LUSEPROP] ) ;
      ID       121, 122 ;
      OF       oFld:aDialogs[2]

   REDEFINE GET aIniEmp[NCOPPEDPRV];
      ID       130;
      PICTURE  "99";
      SPINNER ;
		OF 		oFld:aDialogs[2]

   REDEFINE GET aIniEmp[NCOPALBPRV];
      ID       140;
      PICTURE  "99";
      SPINNER ;
		OF 		oFld:aDialogs[2]

   REDEFINE GET aIniEmp[NCOPFACPRV];
      ID       150;
      PICTURE  "99";
      SPINNER ;
		OF 		oFld:aDialogs[2]

   REDEFINE GET aIniEmp[NCOPDEPAGE];
      ID       160;
      PICTURE  "99";
      SPINNER ;
		OF 		oFld:aDialogs[2]

   REDEFINE GET aIniEmp[NCOPEXTAGE];
      ID       170;
      PICTURE  "99";
      SPINNER ;
		OF 		oFld:aDialogs[2]

   REDEFINE GET aIniEmp[NCOPPRECLI];
      ID       180;
      PICTURE  "99";
      SPINNER ;
		OF 		oFld:aDialogs[2]

   REDEFINE GET aIniEmp[NCOPPEDCLI];
      ID       190;
      PICTURE  "99";
      SPINNER ;
		OF 		oFld:aDialogs[2]

   REDEFINE GET aIniEmp[NCOPALBCLI];
      ID       200;
      PICTURE  "99";
      SPINNER ;
		OF 		oFld:aDialogs[2]

   REDEFINE GET aIniEmp[NCOPFACCLI];
      ID       210;
      PICTURE  "99";
      SPINNER ;
		OF 		oFld:aDialogs[2]

   REDEFINE GET aIniEmp[NCOPTIKCLI];
      ID       220;
      PICTURE  "99";
      SPINNER ;
		OF 		oFld:aDialogs[2]

   /*
	Creamos la Cuarta Caja de Dialogo
	---------------------------------------------------------------------------
	*/

	REDEFINE GET oRutaConta VAR cRutaConta ;
		ID 		100;
		PICTURE 	"@!" ;
		COLOR 	CLR_GET ;
      VALID    ( ChkRuta( cRutaConta, .t. ), .t. ) ;
      BITMAP   "FOLDER" ;
      ON HELP  ( oRutaConta:cText( Rtrim( cGetDir32( "Seleccione directorio contaplus" ) ) ) ) ;
      OF       oFld:aDialogs[3]

   REDEFINE GET aGet[ 1 ] VAR aIniEmp[ CODEMPA ] ;
		ID 		110;
		PICTURE 	"@!" ;
      WHEN     ChkRuta( cRutaConta ) ;
      VALID    ( ChkEmpresaContaplus( AllTrim( cRutaConta ), aIniEmp[ CODEMPA ], oEmpA ), .t. ) ;
		COLOR 	CLR_GET ;
      OF       oFld:aDialogs[3]

   REDEFINE GET oEmpA VAR cEmpA ;
		ID 		120 ;
		WHEN 		.F. ;
		PICTURE 	"@!" ;
		COLOR 	CLR_GET ;
      OF       oFld:aDialogs[3]

   REDEFINE GET aGet[2] VAR aIniEmp[ CODEMPB ] ;
      ID       130;
		PICTURE 	"@!" ;
      WHEN     ChkRuta( cRutaConta ) ;
      VALID    ( ChkEmpresaContaplus( AllTrim( cRutaConta ), aIniEmp[ CODEMPB ], oEmpB ), .t. ) ;
		COLOR 	CLR_GET ;
      OF       oFld:aDialogs[3]

   REDEFINE GET oEmpB VAR cEmpB ;
      ID       140 ;
		WHEN 		.F. ;
		PICTURE 	"@!" ;
		COLOR 	CLR_GET ;
      OF       oFld:aDialogs[3]

   REDEFINE GET aGet[3] VAR aIniEmp[CTACLIENTE] ;
		ID 		160;
		PICTURE 	"999" ;
      WHEN     ChkRuta( cRutaConta );
      BITMAP   "LUPA" ;
      VALID    ( ChkCta( aIniEmp[CTACLIENTE], oCtaCliente, .T., AllTrim( cRutaConta ), aIniEmp[CODEMPA] ) ) ;
      ON HELP  ( BrwChkCta( aGet[3], oCtaCliente, cRutaConta, aIniEmp[CODEMPA] ) ) ;
      COLOR    CLR_GET ;
      OF       oFld:aDialogs[3]

	REDEFINE GET oCtaCliente VAR cCtaCliente ;
		ID 		170 ;
		PICTURE 	"@!" ;
		WHEN 		.F. ;
		COLOR 	CLR_GET ;
      OF       oFld:aDialogs[3]

   REDEFINE GET aGet[4] VAR aIniEmp[CTAPROVEE] ;
		ID 		180;
		PICTURE 	"999" ;
      WHEN     ChkRuta( cRutaConta );
      VALID    ( ChkCta( aIniEmp[CTAPROVEE], oCtaProvee, .T., AllTrim( cRutaConta ), aIniEmp[CODEMPA] ) );
      ON HELP  ( BrwChkCta( aGet[4], oCtaProvee, cRutaConta, aIniEmp[CODEMPA] ) ) ;
      BITMAP   "LUPA" ;
      COLOR    CLR_GET ;
      OF       oFld:aDialogs[3]

	REDEFINE GET oCtaProvee VAR cCtaProvee ;
		ID 		190;
		PICTURE 	"@!" ;
		WHEN 		.F. ;
		COLOR 	CLR_GET ;
      OF       oFld:aDialogs[3]

   REDEFINE GET aGet[5] VAR aIniEmp[CTAVENTACLI] ;
		ID 		200;
		PICTURE 	"999" ;
      WHEN     ChkRuta( cRutaConta );
      VALID    ( ChkCta( aIniEmp[CTAVENTACLI], oCtaVntCliente, .T., AllTrim( cRutaConta ), aIniEmp[CODEMPA] ) );
      ON HELP  ( BrwChkCta( aGet[5], oCtaVntCliente ) ) ;
      BITMAP   "LUPA" ;
      COLOR    CLR_GET ;
      OF       oFld:aDialogs[3]

	REDEFINE GET oCtaVntCliente VAR cCtaVntCliente ;
		ID 		210;
		PICTURE 	"@!" ;
		WHEN 		.F. ;
		COLOR 	CLR_GET ;
      OF       oFld:aDialogs[3]

   REDEFINE GET aGet[6] VAR aIniEmp[CTAABONOCLI] ;
		ID 		220;
		PICTURE 	"999" ;
      WHEN     ChkRuta( cRutaConta );
      VALID    ( ChkCta( aIniEmp[CTAABONOCLI], oCtaAbonoCli, .T., AllTrim( cRutaConta ), aIniEmp[CODEMPA] ) );
      ON HELP  ( BrwChkCta( aGet[6], oCtaAbonoCli ) ) ;
      BITMAP   "LUPA" ;
      COLOR    CLR_GET ;
      OF       oFld:aDialogs[3]

	REDEFINE GET oCtaAbonoCli VAR cCtaAbonoCli ;
		ID 		230;
		PICTURE 	"@!" ;
		WHEN 		.F. ;
		COLOR 	CLR_GET ;
      OF       oFld:aDialogs[3]

   REDEFINE GET aGet[7] VAR aIniEmp[CTAVTACONTADO] ;
		ID 		240;
		PICTURE 	"999" ;
      WHEN     ChkRuta( cRutaConta );
      VALID    ( ChkCta( aIniEmp[CTAVTACONTADO], oCtaVtaContado, .T., AllTrim( cRutaConta ), aIniEmp[CODEMPA] ) );
      ON HELP  ( BrwChkCta( aGet[7], oCtaVtaContado ) ) ;
      BITMAP   "LUPA" ;
      COLOR    CLR_GET ;
      OF       oFld:aDialogs[3]

	REDEFINE GET oCtaVtaContado VAR cCtaVtaContado ;
		ID 		250;
		PICTURE 	"@!" ;
		WHEN 		.F. ;
		COLOR 	CLR_GET ;
      OF       oFld:aDialogs[3]

   REDEFINE GET aGet[8] VAR aIniEmp[CTAABNPROVEEDOR] ;
		ID 		245;
		PICTURE 	"999" ;
      WHEN     ChkRuta( cRutaConta );
      VALID    ( ChkCta( aIniEmp[CTAABNPROVEEDOR], oCtaAbnPrv, .T., AllTrim( cRutaConta ), aIniEmp[CODEMPA] ) );
      ON HELP  ( BrwChkCta( aGet[8], oCtaAbnPrv ) ) ;
      BITMAP   "LUPA" ;
      COLOR    CLR_GET ;
      OF       oFld:aDialogs[3]

	REDEFINE GET oCtaAbnPrv VAR cCtaAbnPrv ;
		ID 		246;
		PICTURE 	"@!" ;
		WHEN 		.F. ;
		COLOR 	CLR_GET ;
      OF       oFld:aDialogs[3]

	/*
	Creamos la Quinta Caja de Dialogo
	---------------------------------------------------------------------------
	*/

   REDEFINE GET oGetSer VAR aIniEmp[DEFSERIE];
      ID       100;
      PICTURE  "@!" ;
      UPDATE ;
      SPINNER ;
      ON UP    ( UpSerie( oGetSer ) );
      ON DOWN  ( DwSerie( oGetSer ) );
      VALID    ( aIniEmp[DEFSERIE] >= "A" .AND. aIniEmp[DEFSERIE] <= "Z"  );
      OF       oFld:aDialogs[4]

	REDEFINE GET oGetCja VAR aIniEmp[DEFCAJA];
		ID 		110;
		PICTURE 	"999" ;
		COLOR 	CLR_GET ;
		VALID		( cCajas( oGetCja, , oGetTxtCaja ) ) ;
      BITMAP   "LUPA" ;
      ON HELP  ( BrwCajas( oGetCja, nil, oGetTxtCaja ) ) ;
      OF       oFld:aDialogs[4]

	REDEFINE GET oGetTxtCaja VAR cGetTxtCaja ;
		ID 		111;
		WHEN 		.F. ;
		COLOR 	CLR_GET ;
      OF       oFld:aDialogs[4]

	REDEFINE GET oGetCjr VAR aIniEmp[DEFCAJERO];
		ID 		120;
		PICTURE 	"999" ;
		COLOR 	CLR_GET ;
      BITMAP   "LUPA" ;
      OF       oFld:aDialogs[4]

	REDEFINE GET oGetTxtCjr VAR cGetTxtCjr ;
		ID 		121;
		WHEN 		.F. ;
		COLOR 	CLR_GET ;
      OF       oFld:aDialogs[4]

   REDEFINE GET oGetCli VAR aIniEmp[DEFCLIENT];
		ID 		130;
		COLOR 	CLR_GET ;
		VALID		( cClient( oGetCli, , oGetTxtCli ) ) ;
      BITMAP   "LUPA" ;
      ON HELP  ( BrwClient( oGetCli, oGetTxtCli ) ) ;
      OF       oFld:aDialogs[4]

	REDEFINE GET oGetTxtCli VAR cGetTxtCli ;
		ID 		131;
		WHEN 		.F. ;
		COLOR 	CLR_GET ;
      OF       oFld:aDialogs[4]

	REDEFINE GET oGetFpg VAR aIniEmp[DEFFPAGO];
		ID 		140;
		COLOR 	CLR_GET ;
		VALID		( cFPago( oGetFpg, , oGetTxtFpg ) ) ;
      BITMAP   "LUPA" ;
      ON HELP  ( BrwFPago( oGetFpg, oGetTxtFpg ) ) ;
      OF       oFld:aDialogs[4]

	REDEFINE GET oGetTxtFpg VAR cGetTxtFpg ;
		ID 		141;
		WHEN 		.F. ;
		COLOR 	CLR_GET ;
      OF       oFld:aDialogs[4]

	REDEFINE CHECKBOX aIniApp[APPNEW] ;
      ID       151;
      OF       oFld:aDialogs[4]

	REDEFINE CHECKBOX aIniApp[APPMOD] ;
      ID       152;
      OF       oFld:aDialogs[4]

  REDEFINE CHECKBOX aIniApp[SELFAM] ;
      ID       153;
      OF       oFld:aDialogs[4]

   REDEFINE CHECKBOX aIniApp[AVISOCERO] ;
      ID       159;
      OF       oFld:aDialogs[4]

   REDEFINE CHECKBOX aIniApp[AVISOCAMBIO] ;
      ID       161;
      OF       oFld:aDialogs[4]

   REDEFINE CHECKBOX aIniApp[GETMATRICULA] ;
      ID       162;
      OF       oFld:aDialogs[4]

	REDEFINE GET aIniApp[CTITTIKTPV] ;
      ID       160;
      MEMO ;
      COLOR    CLR_GET ;
      OF       oFld:aDialogs[4]

	REDEFINE GET aIniApp[CPIETIKTPV] ;
      ID       180;
      MEMO ;
		COLOR 	CLR_GET ;
      OF       oFld:aDialogs[4]

	REDEFINE BUTTON ;
      ID       200 ;
      OF       oFld:aDialogs[4];
      ACTION   ( TImpresoraTiket():New():lEdtConfig() )

   REDEFINE BUTTON ;
      ID       210 ;
      OF       oFld:aDialogs[4];
      ACTION   ( TVisor():New():lEdtConfig() )

	REDEFINE BUTTON ;
      ID       220 ;
      OF       oFld:aDialogs[4];
		ACTION	( CnfCajTpv( aIniApp ) )

	/*
	Creamos la Sexta Caja de Dialogo
	---------------------------------------------------------------------------
	*/

   REDEFINE CHECKBOX aIniApp[NEWASP] ;
      ID       90;
      OF       oFld:aDialogs[5]

	REDEFINE GET aIniEmp[DGTUND] ;
		ID 		100 ;
		COLOR 	CLR_GET ;
		PICTURE	"99" ;
		SPINNER	MIN 1 MAX 12 ;
		VALID		( aIniEmp[DGTUND] >= 1 .AND. aIniEmp[DGTUND] <= 12 ) ;
      OF       oFld:aDialogs[5]

	REDEFINE GET aIniEmp[DECUND] ;
      ID       110;
		COLOR 	CLR_GET ;
		PICTURE	"99" ;
		SPINNER	MIN 0 MAX 4 ;
		VALID		( aIniEmp[DECUND] >= 0 .AND. aIniEmp[DECUND] <= 4 ) ;
      OF       oFld:aDialogs[5]

   REDEFINE CHECKBOX aIniEmp[SELCOL] ;
      ID       120;
      OF       oFld:aDialogs[5]

   REDEFINE GET aIniEmp[REDUNO] ;
      ID       130;
		COLOR 	CLR_GET ;
      PICTURE  "999" ;
      SPINNER  MIN 0 MAX 255 ;
      WHEN     ( aIniEmp[SELCOL] ) ;
      VALID    ( aIniEmp[REDUNO] >= 0 .AND. aIniEmp[REDUNO] <= 255 ) ;
      ON CHANGE( oColUno:SetColor( , nColUno() ), oColUno:Refresh() ) ;
      OF       oFld:aDialogs[5]

   REDEFINE GET aIniEmp[GREENUNO] ;
      ID       140;
		COLOR 	CLR_GET ;
      PICTURE  "999" ;
      SPINNER  MIN 0 MAX 255 ;
      WHEN     ( aIniEmp[SELCOL] ) ;
      VALID    ( aIniEmp[GREENUNO] >= 0 .AND. aIniEmp[GREENUNO] <= 255 ) ;
      ON CHANGE( oColUno:SetColor( , nColUno() ), oColUno:Refresh() ) ;
      OF       oFld:aDialogs[5]

   REDEFINE GET aIniEmp[BLUEUNO] ;
      ID       150 ;
		COLOR 	CLR_GET ;
      PICTURE  "999" ;
      SPINNER  MIN 0 MAX 255 ;
      WHEN     ( aIniEmp[SELCOL] ) ;
      VALID    ( aIniEmp[BLUEUNO] >= 0 .AND. aIniEmp[BLUEUNO] <= 255 ) ;
      ON CHANGE( oColUno:SetColor( , nColUno() ), oColUno:Refresh() ) ;
      OF       oFld:aDialogs[5]

   REDEFINE GET aIniEmp[REDDOS] ;
      ID       160;
		COLOR 	CLR_GET ;
      PICTURE  "999" ;
      SPINNER  MIN 0 MAX 255 ;
      WHEN     ( aIniEmp[SELCOL] ) ;
      VALID    ( aIniEmp[REDDOS] >= 0 .AND. aIniEmp[REDDOS] <= 255 ) ;
      ON CHANGE( oColDos:SetColor( , nColDos() ), oColDos:Refresh() ) ;
      OF       oFld:aDialogs[5]

   REDEFINE GET aIniEmp[GREENDOS] ;
      ID       170;
		COLOR 	CLR_GET ;
      PICTURE  "999" ;
      SPINNER  MIN 0 MAX 255 ;
      WHEN     ( aIniEmp[SELCOL] ) ;
      VALID    ( aIniEmp[GREENDOS] >= 0 .AND. aIniEmp[GREENDOS] <= 255 ) ;
      ON CHANGE( oColDos:SetColor( , nColDos() ), oColDos:Refresh() ) ;
      OF       oFld:aDialogs[5]

   REDEFINE GET aIniEmp[BLUEDOS] ;
      ID       180;
		COLOR 	CLR_GET ;
      PICTURE  "999" ;
      SPINNER  MIN 0 MAX 255 ;
      WHEN     ( aIniEmp[SELCOL] ) ;
      VALID    ( aIniEmp[BLUEDOS] >= 0 .AND. aIniEmp[BLUEDOS] <= 255 ) ;
      ON CHANGE( oColDos:SetColor( , nColDos() ), oColDos:Refresh() ) ;
      OF       oFld:aDialogs[5]

   REDEFINE GET oColUno VAR cColUno ;
      ID       190;
      COLOR    Rgb( 0, 0, 0 ), nColUno() ;
      OF       oFld:aDialogs[5]

   REDEFINE GET oColDos VAR cColDos ;
      ID       200;
      COLOR    Rgb( 0, 0, 0 ), nColDos() ;
      OF       oFld:aDialogs[5]

   /*
	Botones____________________________________________________________________
	*/

	REDEFINE BUTTON ;
		ID 		550;
		OF 		oDlg ;
		ACTION 	( 	aIniEmp[RUTACONTA] := AllTrim( cRutaConta ),;
						aIniApp[PATHDATOS] := AllTrim( cPathDatos ),;
                  lExit := .T.,;
						cWriteIni(),;
                  oDlg:end( IDOK ) )

	ACTIVATE DIALOG oDlg ;
		ON PAINT ( 	oDefAlm:lValid(),;
                  oDefFpg:lValid(),;
                  oGetFpg:lValid(),;
						oGetCli:lValid(),;
						oGetCja:lValid(),;
						oGetCjr:lValid(),;
                  aEval( aGet, {|oGet| oGet:lValid() } );
					) ;
		CENTERED	;
		VALID lExit

   ( cAlias    )->( dbCloseArea() )
   ( dbfDiv    )->( dbCloseArea() )

   cAlias   := nil
   dbfDiv   := nil
   oBandera := nil

	aIniEmp[RUTACONTA]	:= AllTrim( cRutaConta )
	aIniApp[PATHDATOS] 	:= AllTrim( cPathDatos )

RETURN NIL

//--------------------------------------------------------------------------//
/*
Codigos de escape para el caj¢n del TPV
*/

STATIC FUNCTION CnfCajTpv( aIniApp )

	local oDlg
   local aOldApp  := aClone( aIniApp )

	DEFINE DIALOG oDlg RESOURCE "CNF_CAJ_TPV"

  REDEFINE COMBOBOX aIniApp[CPRTCAJTPV];
      ITEMS    { "", "LPT1", "LPT2", "LPT3", "LPT4", "COM1", "COM2", "COM3", "COM4", "COM5", "COM6", "COM7", "COM8", "COM9" } ;
		ID 		100;
		OF 		oDlg

  REDEFINE GET aIniApp[CCAJOPNTPV];
    ID    110;
		COLOR 	CLR_GET ;
		OF 		oDlg

	REDEFINE BUTTON ;
      ID       IDOK ;
		OF 		oDlg ;
      ACTION   ( oDlg:end( IDOK ) )

	REDEFINE BUTTON ;
      ID       IDCANCEL ;
		OF 		oDlg ;
		ACTION 	( aIniApp := aOldApp, oDlg:end() )

   ACTIVATE DIALOG oDlg CENTER

RETURN NIL

//--------------------------------------------------------------------------//

/*
Escribe en el INI los valores recogidos de la caja de dialogo
*/

STATIC FUNCTION cWriteIni( cEmpresa )

	local cIniApp
	local cIniEmp

	IF cEmpresa == NIL
      cEmpresa := cCodEmp()
	END IF

   cIniApp  := cIniAplication()
   cIniEmp  := cPatEmp() + cEmpresa + ".Ini"

	/*
	Escribimos en el fichero ini de la Aplicaci¢n
	*/

	WritePProString("main", 	"Caja", 							cLogicToText( aIniApp[USECAJAS] ), cIniApp )
	WritePProString("main", 	"Calculo Cajas", 				cLogicToText( aIniApp[CALCAJAS] ), cIniApp )
	WritePProString("main", 	"Entradas Continuas", 		cLogicToText( aIniApp[ENTCONT] ), cIniApp )
	WritePProString("main", 	"Modificar Descripciones", cLogicToText( aIniApp[MODDESC] ), cIniApp )
   WritePProString("main",    "Obras en Factura",        cLogicToText( aIniApp[LNUMOBRA] ), cIniApp )
   WritePProString("main",    "Obras Texto",             aIniApp[CTXTOBRA], cIniApp )
   WritePProString("main",    "Su Albaran en Factura",   cLogicToText( aIniApp[LSUALBARAN] ), cIniApp )
   WritePProString("main",    "Su Albaran Texto",        aIniApp[CTXTNUALB], cIniApp )
   WritePProString("main",    "Nuestro Albaran en Factura", cLogicToText( aIniApp[LNUALBARAN] ), cIniApp )
   WritePProString("main",    "Nuestro Albaran Texto",   aIniApp[CTXTSUALB], cIniApp )
   WritePProString("main",    "Costo Automatico",        cLogicToText( aIniApp[LAUTCOS] ), cIniApp )
	WritePProString("main", 	"Multiples Mov.", 			cLogicToText( aIniApp[TIPMOV] ), cIniApp )
   WritePProString("main",    "Ultima Empresa",          aIniApp[LASTEMPRESA], cIniApp )
   WritePProString("main",    "Modificar " + cImp(),           cLogicToText( aIniApp[MODIVA] ), cIniApp )
	WritePProString("path", 	"datos", 						aIniApp[PATHDATOS], cIniApp )
   WritePProString("tpv",     "Titulo Tiket",            StrTran( aIniApp[CTITTIKTPV], CRLF, ";" ), cIniApp )
   WritePProString("tpv",     "Pie Tiket",               StrTran( aIniApp[CPIETIKTPV], CRLF, ";" ), cIniApp )
   WritePProString("tpv",     "Tiket Nuevo",             cLogicToText( aIniApp[APPNEW] ), cIniApp )
	WritePProString("tpv", 		"Tiket Modificado",			cLogicToText( aIniApp[APPMOD] ), cIniApp )
   WritePProString("tpv",     "Seleccionar Familia",     cLogicToText( aIniApp[SELFAM] ), cIniApp )
   WritePProString("tpv",     "Aviso importe cero",      cLogicToText( aIniApp[AVISOCERO] ), cIniApp )
   WritePProString("tpv",     "Aviso cambio precio",     cLogicToText( aIniApp[AVISOCAMBIO] ), cIniApp )
   WritePProString("tpv",     "Recoger matricula",       cLogicToText( aIniApp[GETMATRICULA] ), cIniApp )
   WritePProString("tpv",     "Número Tiket",            cValToChar( aIniApp[NPRNTIK] ), cIniApp )
   WritePProString("cajtpv",  "puerto",                  aIniApp[CPRTCAJTPV], cIniApp )
   WritePProString("cajtpv",  "open",                    aIniApp[CCAJOPNTPV], cIniApp )
   WritePProString("main",    "Nuevo aspecto",           cLogicToText( aIniApp[NEWASP] ),  cIniApp )

	/*
	Escribimos en el fichero ini de la Empresa
	---------------------------------------------------------------------------
	*/

	WritePProString("default", 	"Almacen", 				aIniEmp[DEFAULTALM], cIniEmp )
   WritePProString("default",    "Forma pago",        aIniEmp[DEFAULTFPG], cIniEmp )
   WritePProString("default",    "Recibos",           cLogicToText( aIniEmp[LRECPGD] ), cIniEmp )
	WritePProString("contaplus", 	"Ruta Contaplus", 	aIniEmp[RUTACONTA], cIniEmp )
   WritePProString("contaplus",  "Codigo Empresa",    aIniEmp[CODEMPA], cIniEmp )
   WritePProString("contaplus",  "Codigo Empresa B",  aIniEmp[CODEMPB], cIniEmp )
	WritePProString("contaplus", 	"Serie A", 				If ( aIniEmp[LSERIEA], "ON", "OFF" ), cIniEmp )
	WritePProString("contaplus", 	"Serie B", 				If ( aIniEmp[LSERIEB], "ON", "OFF" ), cIniEmp )
	WritePProString("contaplus", 	"Abono", 				If ( aIniEmp[LABONO], "ON", "OFF" ), cIniEmp )
	WritePProString("contaplus", 	"Cta Cliente", 		aIniEmp[CTACLIENTE], cIniEmp )
	WritePProString("contaplus", 	"Cta Proveedor", 		aIniEmp[CTAPROVEE], cIniEmp )
	WritePProString("contaplus", 	"Cta Vta Cli", 		aIniEmp[CTAVENTACLI], cIniEmp )
	WritePProString("contaplus", 	"Cta Abn Cli", 		aIniEmp[CTAABONOCLI], cIniEmp )
	WritePProString("contaplus", 	"Cta Vta Con", 		aIniEmp[CTAVTACONTADO], cIniEmp )
	WritePProString("contaplus", 	"Cta Abn Prv", 		aIniEmp[CTAABNPROVEEDOR], cIniEmp )
	WritePProString("contaplus", 	"Sub Cta Porte", 		aIniEmp[SUBCTAPORTE], cIniEmp )
	WritePProString("contaplus", 	"Sub Cta CliCon", 	aIniEmp[SUBCTACLICON], cIniEmp )
   WritePProString("path",       "Empresa",           rtrim( aIniEmp[PATHEMPRESA] ), cIniEmp )
   WritePProString("propiedades","Usar propiedades",  cValToChar( aIniEmp[LUSEPROP] ), cIniEmp )
   WritePProString("propiedades","Número propiedades",cValToChar( aIniEmp[NUSEPROP] ), cIniEmp )

   WritePProString("copias",     "Pedido proveedor",  cValToChar( aIniEmp[NCOPPEDPRV] ), cIniEmp )
   WritePProString("copias",     "Albaran proveedor", cValToChar( aIniEmp[NCOPALBPRV] ), cIniEmp )
   WritePProString("copias",     "Factura proveedor", cValToChar( aIniEmp[NCOPFACPRV] ), cIniEmp )
   WritePProString("copias",     "Deposito agente",   cValToChar( aIniEmp[NCOPDEPAGE] ), cIniEmp )
   WritePProString("copias",     "Existencia agente", cValToChar( aIniEmp[NCOPEXTAGE] ), cIniEmp )
   WritePProString("copias",     "Presupuesto cliente",cValToChar(aIniEmp[NCOPPRECLI] ), cIniEmp )
   WritePProString("copias",     "Pedido cliente",    cValToChar( aIniEmp[NCOPPEDCLI] ), cIniEmp )
   WritePProString("copias",     "Albaran cliente",   cValToChar( aIniEmp[NCOPALBCLI] ), cIniEmp )
   WritePProString("copias",     "Factura cliente",   cValToChar( aIniEmp[NCOPFACCLI] ), cIniEmp )
   WritePProString("copias",     "Tickets cliente",    cValToChar( aIniEmp[NCOPTIKCLI] ), cIniEmp )

   WritePProString("tpv",        "Serie",             aIniEmp[DEFSERIE],  cIniEmp )
   WritePProString("tpv",        "Caja",              aIniEmp[DEFCAJA],   cIniEmp )
	WritePProString("tpv", 			"Cajero", 				aIniEmp[DEFCAJERO], cIniEmp )
	WritePProString("tpv", 			"Cliente", 				aIniEmp[DEFCLIENT], cIniEmp )
   WritePProString("tpv",        "Forma Pago",        aIniEmp[DEFFPAGO],  cIniEmp )
   WritePProString("mascaras",   "Digitos Unidades",  cValToChar( aIniEmp[DGTUND] ),   cIniEmp )
   WritePProString("mascaras",   "Decimales Unidades",cValToChar( aIniEmp[DECUND] ),   cIniEmp )
   WritePProString("browse",     "Color",             cLogicToText( aIniEmp[SELCOL] ), cIniEmp )
   WritePProString("browse",     "Rojo 1",            cValToChar( aIniEmp[REDUNO] ),   cIniEmp )
   WritePProString("browse",     "Verde 1",           cValToChar( aIniEmp[GREENUNO] ), cIniEmp )
   WritePProString("browse",     "Azul 1",            cValToChar( aIniEmp[BLUEUNO] ),  cIniEmp )
   WritePProString("browse",     "Rojo 2",            cValToChar( aIniEmp[REDDOS] ),   cIniEmp )
   WritePProString("browse",     "Verde 2",           cValToChar( aIniEmp[GREENDOS] ), cIniEmp )
   WritePProString("browse",     "Azul 2",            cValToChar( aIniEmp[BLUEDOS] ),  cIniEmp )
   WritePProString("tpv",        "Número de Turno",   cValToChar( aIniEmp[NUMTUR] ),   cIniEmp )
   WritePProString("contador",   "Número de Remesa",  cValToChar( aIniEmp[NUMREM] ),   cIniEmp )

RETURN NIL

//--------------------------------------------------------------------------//

FUNCTION LoadIni( oWnd, cEmpresa )

	local oIniEmp
	local oIniApp
	local	cIniEmp
	local cIniApp
   local dbfDiv

	/*
	Fichero Ini de la Aplicaci¢n
	---------------------------------------------------------------------------
	*/

	aIniApp 	:= Array( _NUMINIAPP )
   cIniApp  := cIniAplication()

   aIniApp[PATHDATOS]      := "DATOS"

	INI oIniApp FILE cIniApp

      GET aIniApp[LASBAK]     SECTION "main" ENTRY "Backup" OF oIniApp DEFAULT Ctod( "" )

      GET aIniApp[USECAJAS]   SECTION "main" ENTRY "Caja"   OF oIniApp DEFAULT "ON"

		GET aIniApp[CALCAJAS] SECTION "main" ;
         ENTRY    "Calculo Cajas" ;
         OF       oIniApp ;
         DEFAULT  "ON"

		GET aIniApp[ENTCONT] SECTION "main" ;
         ENTRY    "Entradas Continuas" ;
         OF       oIniApp ;
         DEFAULT  "ON"

		GET aIniApp[MODDESC] SECTION "main" ;
         ENTRY    "Modificar Descripciones" ;
         OF       oIniApp ;
         DEFAULT  "ON"

		GET aIniApp[LSUALBARAN] SECTION "main" ;
         ENTRY    "Su Albaran en Factura" ;
         OF       oIniApp ;
         DEFAULT  "ON"

      GET aIniApp[LNUMOBRA] SECTION "main" ENTRY "Obras en Factura" OF oIniApp DEFAULT  "ON"
      GET aIniApp[CTXTOBRA] SECTION "main" ENTRY "Obras Texto"      OF oIniApp DEFAULT  "Obras"

		GET aIniApp[LNUALBARAN] SECTION "main" ;
         ENTRY    "Nuestro Albaran en Factura" ;
         OF       oIniApp ;
         DEFAULT  "ON"

		GET aIniApp[CTXTNUALB] SECTION "main" ;
         ENTRY    "Nuestro Albaran Texto" ;
         OF       oIniApp ;
         DEFAULT  "Nuestro Albaran"

		GET aIniApp[CTXTSUALB] SECTION "main" ;
         ENTRY    "Su Albaran Texto" ;
         OF       oIniApp ;
         DEFAULT  "Su Albaran"

		GET aIniApp[TIPMOV] SECTION "main" ;
         ENTRY    "Multiples Mov." ;
         OF       oIniApp ;
         DEFAULT  "ON"

      GET aIniApp[LAUTCOS] SECTION "main" ;
         ENTRY    "Costo Automatico" ;
         OF       oIniApp ;
         DEFAULT  "ON"

		GET aIniApp[LASTEMPRESA] SECTION "main" ;
         ENTRY    "Ultima Empresa" ;
         OF       oIniApp ;
         DEFAULT  "01"

		GET aIniApp[MODIVA] SECTION "main" ;
         ENTRY    "Modificar " + cImp() ;
			OF 		oIniApp ;
			DEFAULT 	"ON"

      GET aIniApp[NEWASP] SECTION "main" ;
         ENTRY    "Nuevo aspecto" ;
         OF       oIniApp ;
         DEFAULT  "OFF"

      GET aIniApp[PATHDATOS] SECTION "path" ;
         ENTRY    "datos" ;
         OF       oIniApp ;
         DEFAULT  "DATOS"

		GET aIniApp[CTITTIKTPV] SECTION "tpv" ;
			ENTRY 	"Titulo Tiket" ;
			OF 		oIniApp ;
			DEFAULT 	Space( 100 )

		GET aIniApp[CPIETIKTPV] SECTION "tpv" ;
			ENTRY 	"Pie Tiket" ;
			OF 		oIniApp ;
			DEFAULT 	Space( 100 )

      GET aIniApp[APPNEW] SECTION "tpv" ;
			ENTRY 	"Tiket Nuevo" ;
			OF 		oIniApp ;
			DEFAULT 	"ON"

		GET aIniApp[APPMOD] SECTION "tpv" ;
			ENTRY 	"Tiket Modificado" ;
			OF 		oIniApp ;
			DEFAULT 	"ON"

      GET aIniApp[SELFAM] SECTION "tpv" ;
         ENTRY    "Seleccionar Familia" ;
			OF 		oIniApp ;
			DEFAULT 	"ON"

      GET aIniApp[AVISOCERO] SECTION "tpv" ;
         ENTRY    "Aviso importe cero" ;
			OF 		oIniApp ;
			DEFAULT 	"ON"

      GET aIniApp[AVISOCAMBIO] SECTION "tpv" ;
         ENTRY    "Aviso cambio precio" ;
			OF 		oIniApp ;
			DEFAULT 	"ON"

      GET aIniApp[GETMATRICULA] SECTION "tpv" ;
         ENTRY    "Recoger matricula" ;
			OF 		oIniApp ;
			DEFAULT 	"ON"

      GET aIniApp[NPRNTIK] SECTION "tpv" ;
         ENTRY    "Numero Tiket" ;
			OF 		oIniApp ;
         DEFAULT  "1"

      GET aIniApp[CPRTCAJTPV] SECTION "cajtpv" ;
			ENTRY 	"puerto" ;
			OF 		oIniApp ;
         DEFAULT  ""

		GET aIniApp[CCAJOPNTPV] SECTION "cajtpv" ;
			ENTRY 	"open" ;
			OF 		oIniApp ;
			DEFAULT 	""

	ENDINI

   aIniApp[USECAJAS]    := lTextToLogic( aIniApp[USECAJAS] )
	aIniApp[CALCAJAS]		:= lTextToLogic( aIniApp[CALCAJAS] )
	aIniApp[ENTCONT]		:= lTextToLogic( aIniApp[ENTCONT] )
	aIniApp[MODDESC]		:= lTextToLogic( aIniApp[MODDESC] )
	aIniApp[TIPMOV]		:= lTextToLogic( aIniApp[TIPMOV] )
	aIniApp[LSUALBARAN] 	:= lTextToLogic( aIniApp[LSUALBARAN] )
   aIniApp[LNUMOBRA]    := lTextToLogic( aIniApp[LNUMOBRA] )
   aIniApp[LNUALBARAN]  := lTextToLogic( aIniApp[LNUALBARAN] )
   aIniApp[LAUTCOS]     := lTextToLogic( aIniApp[LAUTCOS] )
   aIniApp[CTXTOBRA]    := Padr( aIniApp[CTXTOBRA], 25 )
   aIniApp[CTXTNUALB]   := Padr( aIniApp[CTXTNUALB], 25 )
	aIniApp[CTXTSUALB] 	:= Padr( aIniApp[CTXTSUALB], 25 )
   aIniApp[CCAJOPNTPV]  := Padr( aIniApp[CCAJOPNTPV], 50 )
   aIniApp[APPNEW]      := lTextToLogic( aIniApp[APPNEW] )
	aIniApp[APPMOD]		:= lTextToLogic( aIniApp[APPMOD] )
   aIniApp[SELFAM]      := lTextToLogic( aIniApp[SELFAM] )
   aIniApp[AVISOCERO]   := lTextToLogic( aIniApp[AVISOCERO] )
   aIniApp[AVISOCAMBIO] := lTextToLogic( aIniApp[AVISOCAMBIO] )
   aIniApp[GETMATRICULA]:= lTextToLogic( aIniApp[GETMATRICULA] )
   aIniApp[NPRNTIK]     := Val( aIniApp[NPRNTIK] )
   aIniApp[CTITTIKTPV]  := StrTran( Padr( aIniApp[CTITTIKTPV], 256 ), ";", CRLF )
   aIniApp[CPIETIKTPV]  := StrTran( Padr( aIniApp[CPIETIKTPV], 256 ), ";", CRLF )
   aIniApp[MODIVA]      := lTextToLogic( aIniApp[MODIVA] )
   aIniApp[NEWASP]      := lTextToLogic( aIniApp[NEWASP] )

RETURN NIL

//----------------------------------------------------------------------------//

FUNCTION aIni() ; RETURN aIniEmp

//----------------------------------------------------------------------------//

FUNCTION aIniApp() ; RETURN aIniApp


STATIC FUNCTION cLogicToText( lLogic )

	DEFAULT lLogic := .T.

   if ValType( lLogic ) != "L"
      lLogic      := .f.
   end if

RETURN ( If ( lLogic, "ON", "OFF" ) )

//----------------------------------------------------------------------------//

STATIC FUNCTION lTextToLogic( cText )

	DEFAULT cText := "ON"

RETURN ( If ( cText == "ON", .T., .F. ) )

//----------------------------------------------------------------------------//

FUNCTION DefPic() ; RETURN ( aIniEmp[DEFPIC] )

//---------------------------------------------------------------------------//


FUNCTION GetLstBackup() ; RETURN ( aIniApp()[LASBAK] )

//---------------------------------------------------------------------------//

FUNCTION SetLstBackup( dDate )

   DEFAULT dDate  := Date()

   WritePProString( "main", "Backup", Dtoc( dDate ), cIniAplication() )

RETURN ( dDate )

//---------------------------------------------------------------------------//

//---------------------------------------------------------------------------//

function LoadIniEmp( cEmpresa, dbfEmpresa, oWnd )

   /*
	Fichero Ini de la Empresa
	---------------------------------------------------------------------------
	*/

   cEmpresa             := if( empty( cEmpresa ), aIniApp[LASTEMPRESA], cEmpresa )

	aIniEmp 					:= Array( _NUMINIEMP )
	cIniEmp					:= FullCurDir() + "EMP" + cEmpresa + "\EMP" + cEmpresa + ".INI"

   cPatEmp( FullCurDir() + "EMP" + cEmpresa )

   oWnd:cTitle( "GST+ 4.00 para Windows : " + cEmpresa + " - " + cNbrEmp( cEmpresa ) )

	INI oIniEmp FILE cIniEmp

		GET aIniEmp[RUTACONTA] 	SECTION "contaplus" ;
			ENTRY 	"Ruta Contaplus" ;
			OF 		oIniEmp ;
         DEFAULT  Space( 100 )

      GET aIniEmp[CODEMPA] SECTION "contaplus" ;
         ENTRY    "Codigo Empresa" ;
         OF       oIniEmp ;
         DEFAULT  "01"

      GET aIniEmp[CODEMPB] SECTION "contaplus" ;
         ENTRY    "Codigo Empresa B" ;
         OF       oIniEmp ;
         DEFAULT  "01"

		GET aIniEmp[LSERIEA] SECTION "contaplus" ;
         ENTRY    "Serie A" ;
         OF       oIniEmp ;
         DEFAULT  "ON"

		GET aIniEmp[LSERIEB] SECTION "contaplus" ;
         ENTRY    "Serie B" ;
         OF       oIniEmp ;
         DEFAULT  "ON"

		GET aIniEmp[LABONO] SECTION "contaplus" ;
         ENTRY    "Abono" ;
         OF       oIniEmp ;
         DEFAULT  "ON"

		GET aIniEmp[CTACLIENTE]	SECTION "contaplus" ;
         ENTRY    "Cta Cliente" ;
         OF       oIniEmp ;
         DEFAULT  "430"

		GET aIniEmp[CTAPROVEE] SECTION "contaplus" ;
         ENTRY    "Cta Proveedor" ;
         OF       oIniEmp ;
         DEFAULT  "400"

		GET aIniEmp[CTAVENTACLI] SECTION "contaplus" ;
         ENTRY    "Cta Vta Cli" ;
         OF       oIniEmp ;
         DEFAULT  "700"

		GET aIniEmp[CTAABONOCLI]	SECTION "contaplus" ;
         ENTRY    "Cta Abn Cli" ;
         OF       oIniEmp ;
         DEFAULT  "708"

		GET aIniEmp[CTAVTACONTADO]	SECTION "contaplus" ;
         ENTRY    "Cta Vta Con" ;
         OF       oIniEmp ;
         DEFAULT  "701"

		GET aIniEmp[CTAABNPROVEEDOR]	SECTION "contaplus" ;
         ENTRY    "Cta Abn Prv" ;
         OF       oIniEmp ;
         DEFAULT  "608"

		GET aIniEmp[SUBCTAPORTE] SECTION "contaplus" ;
         ENTRY    "Sub Cta Porte"  ;
         OF       oIniEmp ;
         DEFAULT  "4370000"

		GET aIniEmp[SUBCTACLICON] SECTION "contaplus" ;
         ENTRY    "Sub Cta CliCon" ;
         OF       oIniEmp ;
         DEFAULT  "4320000"

      GET aIniEmp[LUSEPROP] SECTION "propiedades" ;
         ENTRY    "Usar propiedades" ;
         OF       oIniEmp ;
         DEFAULT  .f.

      GET aIniEmp[NUSEPROP] SECTION "propiedades" ;
         ENTRY    "Numero propiedades" ;
         OF       oIniEmp ;
         DEFAULT  0

      GET aIniEmp[NCOPPEDPRV] SECTION "copias" ENTRY "Pedido proveedores"  OF oIniEmp DEFAULT  1
      GET aIniEmp[NCOPALBPRV] SECTION "copias" ENTRY "Albaran proveedor"   OF oIniEmp DEFAULT  1
      GET aIniEmp[NCOPFACPRV] SECTION "copias" ENTRY "Factura proveedor"   OF oIniEmp DEFAULT  1
      GET aIniEmp[NCOPDEPAGE] SECTION "copias" ENTRY "Deposito agente"     OF oIniEmp DEFAULT  1
      GET aIniEmp[NCOPEXTAGE] SECTION "copias" ENTRY "Existencia agente"   OF oIniEmp DEFAULT  1
      GET aIniEmp[NCOPPRECLI] SECTION "copias" ENTRY "Presupuesto cliente" OF oIniEmp DEFAULT  1
      GET aIniEmp[NCOPPEDCLI] SECTION "copias" ENTRY "Pedido cliente"      OF oIniEmp DEFAULT  1
      GET aIniEmp[NCOPALBCLI] SECTION "copias" ENTRY "Albaran cliente"     OF oIniEmp DEFAULT  1
      GET aIniEmp[NCOPFACCLI] SECTION "copias" ENTRY "Factura cliente"     OF oIniEmp DEFAULT  1
      GET aIniEmp[NCOPTIKCLI] SECTION "copias" ENTRY "Tickets cliente"     OF oIniEmp DEFAULT  1

      GET aIniEmp[DEFAULTALM] SECTION "default" ;
         ENTRY    "Almacen" ;
         OF       oIniEmp ;
         DEFAULT  "001"

      GET aIniEmp[DEFAULTFPG] SECTION "default" ;
         ENTRY    "Forma pago" ;
         OF       oIniEmp ;
         DEFAULT  "CO"

      GET aIniEmp[LRECPGD] SECTION "default" ;
         ENTRY    "Pagos" ;
         OF       oIniEmp ;
         DEFAULT  "ON"

      GET aIniEmp[DEFSERIE] SECTION "tpv" ;
         ENTRY    "Serie" ;
         OF       oIniEmp ;
         DEFAULT  "A"

		GET aIniEmp[DEFCAJA] SECTION "tpv" ;
         ENTRY    "Caja" ;
         OF       oIniEmp ;
         DEFAULT  "   "

		GET aIniEmp[DEFCAJERO] SECTION "tpv" ;
         ENTRY    "Cajero" ;
         OF       oIniEmp ;
         DEFAULT  "   "

		GET aIniEmp[DEFCLIENT] SECTION "tpv" ;
         ENTRY    "Cliente" ;
         OF       oIniEmp ;
         DEFAULT  Space( RetNumCodCliEmp() )

		GET aIniEmp[DEFFPAGO] SECTION "tpv" ;
         ENTRY    "Forma Pago" ;
         OF       oIniEmp ;
         DEFAULT  "  "

		GET aIniEmp[DGTUND] SECTION "mascaras" ;
         ENTRY    "Digitos Unidades" ;
         OF       oIniEmp ;
         DEFAULT  "8"

		GET aIniEmp[DECUND] SECTION "mascaras" ;
         ENTRY    "Decimales Unidades" ;
         OF       oIniEmp ;
         DEFAULT  "3"

      GET aIniEmp[SELCOL] SECTION "browse" ;
         ENTRY    "Color" ;
         OF       oIniEmp ;
         DEFAULT  "ON"

      GET aIniEmp[REDUNO] SECTION "browse" ;
         ENTRY    "Rojo 1" ;
         OF       oIniEmp ;
         DEFAULT  "247"

      GET aIniEmp[GREENUNO] SECTION "browse" ;
         ENTRY    "Verde 1" ;
         OF       oIniEmp ;
         DEFAULT  "243"

      GET aIniEmp[BLUEUNO] SECTION "browse" ;
         ENTRY    "Azul 1" ;
         OF       oIniEmp ;
         DEFAULT  "231"

      GET aIniEmp[REDDOS] SECTION "browse" ;
         ENTRY    "Rojo 2" ;
         OF       oIniEmp ;
         DEFAULT  "222"

      GET aIniEmp[GREENDOS] SECTION "browse" ;
         ENTRY    "Verde 2" ;
         OF       oIniEmp ;
         DEFAULT  "223"

      GET aIniEmp[BLUEDOS] SECTION "browse" ;
         ENTRY    "Azul 2" ;
         OF       oIniEmp ;
         DEFAULT  "189"

      GET aIniEmp[NUMTUR] SECTION "tpv" ;
         ENTRY    "Numero de Turno" ;
         OF       oIniEmp ;
         DEFAULT  1

      GET aIniEmp[NUMREM] SECTION "contador" ;
         ENTRY    "Numero de Remesa" ;
         OF       oIniEmp ;
         DEFAULT  1

	ENDINI

	aIniEmp[LSERIEA] 		:= lTextToLogic( aIniEmp[LSERIEA] )
	aIniEmp[LSERIEB] 		:= lTextToLogic( aIniEmp[LSERIEB] )
	aIniEmp[LABONO] 		:= lTextToLogic( aIniEmp[LABONO] )
	aIniEmp[DEFCAJA]		:= Padr( aIniEmp[DEFCAJA], 3 )
	aIniEmp[DEFCAJERO]	:= Padr( aIniEmp[DEFCAJERO], 3 )
	aIniEmp[DEFCLIENT]	:= Padr( aIniEmp[DEFCLIENT], RetNumCodCliEmp() )
	aIniEmp[DEFFPAGO]		:= Padr( aIniEmp[DEFFPAGO], 2 )
   aIniEmp[DGTUND]      := Val( aIniEmp[DGTUND] )
	aIniEmp[DECUND] 		:= Val( aIniEmp[DECUND] )
   aIniEmp[LRECPGD]     := lTextToLogic( aIniEmp[LRECPGD] )
   aIniEmp[SELCOL]      := lTextToLogic( aIniEmp[SELCOL] )
   aIniEmp[REDUNO]      := Val( aIniEmp[REDUNO] )
   aIniEmp[GREENUNO]    := Val( aIniEmp[GREENUNO] )
   aIniEmp[BLUEUNO]     := Val( aIniEmp[BLUEUNO] )
   aIniEmp[REDDOS]      := Val( aIniEmp[REDDOS] )
   aIniEmp[GREENDOS]    := Val( aIniEmp[GREENDOS] )
   aIniEmp[BLUEDOS]     := Val( aIniEmp[BLUEDOS] )
   aIniEmp[NUMTUR]      := if( aIniEmp[NUMTUR] <= 0, 1, aIniEmp[NUMTUR] )

   if Valtype( aIniEmp[NUMREM] ) != "N"
      aIniEmp[NUMREM]   := 0
   end if
   aIniEmp[NUMREM]      := if( aIniEmp[NUMREM] <= 0, 1, aIniEmp[NUMREM] )

return nil

//---------------------------------------------------------------------------//