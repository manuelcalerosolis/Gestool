//
#include "FiveWin.Ch"
#include "Font.ch"
#include "Folder.ch"
#include "Factu.ch"
#include "Print.ch"
#include "Report.ch"
#include "Factu.ch"

/*
Defines para las lineas de Pago
*/

#define _CSERIE                   1      //   C      1     0
#define _NNUMFAC                  2      //   N      9     0
#define _CSUFFAC                  3      //   C      2     0
#define _pNNUMREC                 4      //   N      2     0
#define _DENTRADA                 5      //   D      8     0
#define _NIMPORTE                 6      //   N     10     0
#define _CDESCRIP                 7      //   C    100     0
#define _DPRECOB                  8      //   C      8     0
#define _CPGDOPOR                 9      //   D     50     0
#define _LCOBRADO                10      //   L      1     0
#define _CDIVPGO                 11      //   C      3     0
#define _NVDVPGO                 12      //
#define _LCONPGO                 13      //   L      1     0

static oWndBrw
static oBrw
static dbfFacPgo
static dbfDivisa
static oBandera
static dbfClient
static dbfFacCliT
static dbfFacCliL
static dbfFPago
static dbfIva
static aPgdBmp
static bEdit      := { |aTmp, aGet, dbfFacPgo, oBrw, bWhen, bValid, nMode, aTmpFac| EdtPag( aTmp, aGet, dbfFacPgo, oBrw, bWhen, bValid, nMode, aTmpFac ) }

//----------------------------------------------------------------------------//

STATIC FUNCTION OpnFil()

   local cPath := cPatEmp()

   IF dbfFacPgo == NIL

      USE ( cPath + "FACCLIP.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACCLIP", @dbfFacPgo ) )
      SET ADSINDEX TO ( cPath + "FACCLIP.CDX" ) ADDITIVE

      USE ( cPatDat() + "DIVISAS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "DIVISAS", @dbfDivisa ) )
      SET ADSINDEX TO ( cPatDat() + "DIVISAS.CDX" ) ADDITIVE

      USE ( cPath + "FACCLIT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACCLIT", @dbfFacCliT ) )
      SET ADSINDEX TO ( cPath + "FACCLIT.CDX" ) ADDITIVE

      USE ( cPath + "FACCLIL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACCLIL", @dbfFacCliL ) )
      SET ADSINDEX TO ( cPath + "FACCLIL.CDX" ) ADDITIVE

      USE ( cPath + "CLIENT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CLIENT", @dbfClient ) )
      SET ADSINDEX TO ( cPath + "CLIENT.CDX" ) ADDITIVE

      USE ( cPatEmp() + "FPAGO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FPAGO", @dbfFPago ) )
      SET ADSINDEX TO ( cPatEmp() + "FPAGO.CDX" ) ADDITIVE

      USE ( cPatDat() + "TIVA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIVA", @dbfIva ) )
      SET ADSINDEX TO ( cPatDat() + "TIVA.CDX" ) ADDITIVE

      oBandera := TBandera():New

      RETURN .T.

	END IF

RETURN .F.

//---------------------------------------------------------------------------//

STATIC FUNCTION CloFil( aPgdBmp )

	dbCommitAll()

   IF oWndBrw != NIL
		oWndBrw:oBrw:lCloseArea()
	ELSE
      ( dbfFacPgo )->( dbCloseArea() )
	END IF

   ( dbfDivisa )->( dbCloseArea() )
   ( dbfClient )->( dbCloseArea() )
   ( dbfFacCliT)->( dbCloseArea() )
   ( dbfFacCliL)->( dbCloseArea() )
   ( dbfFPago  )->( dbCloseArea() )
   ( dbfIva    )->( dbCloseArea() )


   dbfFacPgo   := NIL
   dbfDivisa   := NIL
   oBandera    := NIL
   dbfClient   := NIL
   dbfFacCliT  := NIL
   dbfFacCliL  := NIL
   dbfFPago    := NIL
   oWndBrw     := NIL

   aeval( aPgdBmp, { | hBmp | deleteObject( hBmp ) } )

RETURN .T.

//--------------------------------------------------------------------------//

FUNCTION RecCli( oWnd )

   local aPgdBmp  := {  LoadBitmap( GetResources(), "BGREEN" ),;
                        LoadBitmap( GetResources(), "BRED" ) }

	IF oWndBrw == NIL

      OpnFil()

      DEFINE SHELL oWndBrw FROM 2, 10 TO 18, 70;
         TITL#include "FiveWin.Ch"
#include "Struct.ch"
#include "Factu.ch"

static hRas		:= 0
static lConnect:= .t.

static oSay1
static oSay2
static oSay3
static oSay4
static oSay5
static oSay6
static oSay7

static cSay1
static cSay2
static cSay3
static cSay4
static cSay5
static cSay6
static cSay7

static oMtrOne
static oBtnOk

//-------------------------------------------------------------------------//

FUNCTION Internet( oWnd )

	local oDlg
   local oSay
   local oPro
   local oMtr
   local nMtr
   local oBtnCon
   local oBtnOk
   local cSay     := ""
   local cPro     := ""
   local cTitle   := "Conexión a internet como " + if( rtrim( aIniApp()[CENVUSR] ) == "S", "Servidor", "Cliente" )

	IF oWnd:oWndClient:getActive() != NIL
      msgStop( "Imposible realizar operación", "Existen procesos abiertos" )
		RETURN NIL
	END IF

   DEFINE DIALOG oDlg RESOURCE "INTERNET" TITLE cTitle

      REDEFINE SAY oSay1 PROMPT cSay1 ;
         ID       10 ;
         OF       oDlg

      REDEFINE SAY oSay2 PROMPT cSay2 ;
         ID       20 ;
         OF       oDlg

      REDEFINE SAY oSay3 PROMPT cSay3 ;
         ID       30 ;
         OF       oDlg

      REDEFINE SAY oSay4 PROMPT cSay4 ;
         ID       40 ;
         OF       oDlg

      REDEFINE SAY oSay5 PROMPT cSay5 ;
         ID       50 ;
         OF       oDlg

      REDEFINE SAY oSay6 PROMPT cSay6 ;
         ID       60 ;
         OF       oDlg

      REDEFINE SAY oSay7 PROMPT cSay7 ;
         ID       70 ;
         OF       oDlg

      REDEFINE SAY oSay PROMPT cSay ;
         ID       100 ;
         OF       oDlg

      REDEFINE SAY oPro PROMPT cPro ;
         ID       110 ;
         OF       oDlg

REDEFINE APOLOMETER oMtr ;
         VAR      nMtr ;
         ID       120 ;
         OF       oDlg

      REDEFINE BUTTON oBtnCon ;
         ID       552 ;
         OF       oDlg ;
         ACTION   ( oBtnOk:disable(), ComInt( oWnd ), PutFtp( oDlg, oSay, oPro, oMtr ), EndCom( oWnd ), oBtnOk:enable() )

      REDEFINE BUTTON oBtnOk ;
         ID       IDCANCEL ;
         OF       oDlg ;
         CANCEL ;
         ACTION   ( oDlg:end() )

   ACTIVATE DIALOG oDlg CENTER

RETURN NIL

//----------------------------------------------------------------------------//

/*
Realiza la comunicaci¢n
*/

FUNCTION ComInt( oWnd )

	local lConect	:= .f.
	local cEntry	:= rtrim( aIniApp()[CNOMCON] )
	local cUser		:= rtrim( aIniApp()[CUSRCON] )
	local cPass		:= rtrim( aIniApp()[CPSWCON] )

	IF empty( cEntry )
		msgStop( "No se ha definido conexión." )
	ELSE
      cEntry      := EditEntry( cEntry )
	END IF

   hRas           := Ras_Dial( cEntry, cUser, cPass, .f. )

RETURN ( NIL )

//----------------------------------------------------------------------------//

FUNCTION EndCom( oWnd )

   IF hRas != 0
      Ras_Hangup( hRas )
   END IF

RETURN ( NIL )

//----------------------------------------------------------------------------//

/*
Recoge la documentaci¢n del buz¢n
*/

STATIC FUNCTION PutFtp( oDlg, oSay, oPro, oMtr )

   local lServer  := if( rtrim( aIniApp()[CENVUSR] ) == "S", .t., .f. )
   local ftpSit   := rtrim( aIniApp()[CFTPSIT] )
	local nbrUsr	:= rtrim( aIniApp()[CUSRFTP] )
	local accUsr	:= rtrim( aIniApp()[CPSWFTP] )
   local oInt     := TInternet():New()
   local oFTP     := TFTP():New( ftpSit, oInt, nbrUsr, accUsr )

   msginfo( ftpsit, "FtpSit" )
   msginfo( nbrUsr, "NbrUsr" )
   msginfo( accUsr, "AccUsr" )

   oSay1:SetText( "> Conectando con el sitio " + rtrim( ftpSit ) + "..." )

   if empty( oFTP:hFTP )
      oSay:SetText( "¡Imposible conectar con el sitio FTP!" )
      return nil
   endif

   oSay1:SetText( "Conectado con el sitio " + rtrim( ftpSit ) + "..." )

   /*
   Solo para el cliente--------------------------------------------------------
	*/

   IF lServer

      oSay2:SetText( "> Enviando fichero de artículos" )
      SndArt( oDlg, oMtr, oFtp, oSay, oPro )
      oSay2:SetText( "Fichero de artículos enviados" )
      oSay3:SetText( // FiveWin Class TFTP for Internet FTP management. Based on Windows WinINet.dll

#include "FiveWin.Ch"
#include "Struct.ch"

#define INTERNET_SERVICE_FTP    1
#define FTP_PORT               21

//----------------------------------------------------------------------------//

CLASS TFTP

   DATA   oInternet                  // TInternet container object
   DATA   cSite                      // URL address
   DATA   hFTP                       // handle of the FTP connection
   DATA   cUserName                  // user name to login
   DATA   cPassword                  // password to login

   METHOD New( cFTPSite, oInternet ) CONSTRUCTOR  // generic constructor

   METHOD End()                        // generic destructor

   METHOD DeleteFile( cFileName )    // deletes a remote FTP file

   METHOD Directory( cMask )         // as Clipper Directory() but on a FTP site!

   METHOD DeleteMask( cMask )        // as Clipper Directory() but on a FTP site!

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( cFTPSite, oInternet, cUserName, cPassword ) CLASS TFTP

   ::oInternet = oInternet
   ::cSite     = cFTPSite
   ::cUserName = cUserName
   ::cPassword = cPassword

   msginfo( "hola desde TFTP" )

   if oInternet:hSession != nil
      ::hFTP = InternetConnect( oInternet:hSession, cFTPSite, FTP_PORT,;
                                ::cUserName, ::cPassword,;
                                INTERNET_SERVICE_FTP, 0, 0 )
      AAdd( oInternet:aFTPs, Self )
   endif

   msginfo( "fin de TFTP" )


return nil

//----------------------------------------------------------------------------//

METHOD End() CLASS TFTP

   if ::hFTP != nil
      InternetCloseHandle( ::hFTP )
      ::hFTP = nil
   endif

return nil

//----------------------------------------------------------------------------//

METHOD DeleteFile( cFileName ) CLASS TFTP

return If( ::hFTP != nil, FtpDeleteFile( ::hFTP, cFileName ), .f. )

//----------------------------------------------------------------------------//

METHOD Directory( cMask ) CLASS TFTP

   local hFTPDir, aFiles := {}
   local oWin32FindData, cBuffer

   DEFAULT cMask := "*.*"

   STRUCT oWin32FindData
      MEMBER nFileAttributes  AS DWORD
      MEMBER nCreationTime    AS STRING LEN 8
      MEMBER nLastReadAccess  AS STRING LEN 8
      MEMBER nLastWriteAccess AS STRING LEN 8
      MEMBER nSizeHight       AS DWORD
      MEMBER nSizeLow         AS DWORD
      MEMBER nReserved0       AS DWORD
      MEMBER nReserved1       AS DWORD
      MEMBER cFileName        AS STRING LEN 260
      MEMBER cAltName         AS STRING LEN  14
   ENDSTRUCT

   if ::hFTP != nil
      cBuffer = oWin32FindData:cBuffer
      hFTPDir = FtpFindFirstFile( ::hFTP, cMask, @cBuffer, 0, 0 )
      oWin32FindData:cBuffer = cBuffer
      if ! Empty( oWin32FindData:cFileName )
         AAdd( aFiles, { oWin32FindData:cFileName,;
                         oWin32FindData:nSizeLow } )
         while InternetFindNextFile( hFTPDir, @cBuffer )
            oWin32FindData:cBuffer = cBuffer
            AAdd( aFiles, { oWin32FindData:cFileName,;
                            oWin32FindData:nSizeLow } )
         end
      endif
      InternetCloseHandle( hFTPDir )
   endif

return aFiles

//----------------------------------------------------------------------------//

METHOD DeleteMask( cMask ) CLASS TFTP

   local n
   local aFiles

   DEFAULT cMask := "*.*"

   IF ::hFTP != nil

      aFiles := ::Directory( cMask )

      FOR n = 1 TO len( aFiles )

         FtpDeleteFile( ::hFTP, aFiles[ n, 1 ] )

      NEXT

   END IF

return nil

//----------------------------------------------------------------------------//
                                                                                                                                                                                                                                                                     25      //   N     10     0
#define cFPITCHAND               26      //   N     10     0
#define cFFACENAME               27      //   C     20     0
#define cFCOLOR                  28      //   N     10     0

#define bCODIGO                   1      //   C      3     0
#define bNORDEN                   2      //   N      3     0
#define bCFICHERO                 3      //   C     15     0
#define bNROWTOP                  4      //   N      6     2
#define bNCOLTOP                  5      //   N      6     2
#define bNROWBOTTOM               6      //   N      6     2
#define bNCOLBOTTOM               7      //   N      6     2
#define bLCONDICION               8      //   C     60     0

#define xCODIGO                   1      //   C      3     0
#define xNROWTOP                  2      //   N      6     2
#define xNCOLTOP                  3      //   N      6     2
#define xNROWBOTTOM               4      //   N      6     2
#define xNCOLBOTTOM               5      //   N      6     2
#define xNTYPELINE                6      //   N      3     0
#define xLCONDICION               7      //   C     60     0

static aBase1   := {  {"CTIPO",     "C",	   2,   0 },;
                      {"Codigo",    "C",     3,   0 },;
							 {"NLENPAG",   "N",     6,   2 },;
							 {"NWIDPAG",   "N",     6,   2 },;
							 {"NINICIO",   "N",  	6,   2 },;
							 {"NFIN",    	"N",  	6,   2 },;
							 {"NLEFT",     "N",  	6,   2 },;
							 {"NRIGHT",    "N",  	6,   2 },;
							 {"NTYPELINE", "N",  	1,   0 },;
							 {"CDESCRIP",  "C",   100,   0 },;
							 {"NAJUSTE",   "N",     1,   0 } }

static aBase2   := {  {"Codigo",    "C",     3,   0 },;
							 {"CLITERAL",  "C", 		25,  0 },;
							 {"NLINEA",    "N",  	5,   1 },;
							 {"NCOLUMNA",  "N",  	5,   1 },;
							 {"CFICHERO",  "C", 		50,  0 },;
							 {"CCAMPO",    "C",		100, 0 },;
							 {"CMASCARA",  "C", 		30,  0 },;
							 {"LLITERAL",  "L",  	1,   0 },;
							 {"NAJUSTE",   "N",  	1,   0 },;
							 {"LCONDICION","C", 		60,  0 },;
							 {"NSIZE",     "N",  	6,   2 },;
							 {"FHEIGHT",   "N",     10,  0 },;
							 {"FWIDTH",    "N",     10,  0 },;
							 {"FESCAPE",   "N",     10,  0 },;
							 {"FORIENT",   "N",     10,  0 },;
							 {"FWEIGHT",   "N",     10,  0 },;
							 {"FITALIC",   "L",      1,  0 },;
							 {"FUNDERLINE","L",      1,  0 },;
							 {"FSTRIKEOUT","L",      1,  0 },;
							 {"FCHARSET",  "N",     10,  0 },;
							 {"FOUTPRECIS","N",     10,  0 },;
							 {"FCLIPRECIS","N",     10,  0 },;
							 {"FQUALITY",  "N",     10,  0 },;
							 {"FPITCHAND", "N",     10,  0 },;
							 {"FFACENAME", "C",     20,  0 },;
							 {"FCOLOR",    "N",     10,  0 } }

static aBase3     := {{ "Codigo",    "C",    3,   0 },;
							 { "NORDEN",    "N",    3,   0 },;
							 { "CLITERAL",  "C",   25,   0 },;
							 { "NCOLUMNA",  "N",    5,   1 },;
							 { "CFICHERO",  "C",   50,   0 },;
							 { "CCAMPO",    "C",  100,   0 },;
							 { "CMASCARA",  "C",   20,   0 },;
							 { "NAJUSTE",   "N",    1,   0 },;
							 { "LCONDICION","C",   60,   0 },;
							 { "CTITULO",   "C",   20,   0 },;
							 { "NSIZE",     "N",    3,   0 },;
							 { "LGIRD",     "L",    1,   0 },;
							 { "LSHADOW",   "L",    1,   0 },;
							 { "FHEIGHT",   "N",   10,   0 },;
							 { "FWIDTH",    "N",   10,   0 },;
							 { "FESCAPE",   "N",   10,   0 },;
							 { "FORIENT",   "N",   10,   0 },;
							 { "FWEIGHT",   "N",   10,   0 },;
							 { "FITALIC",   "L",    1,   0 },;
							 { "FUNDERLINE","L",    1,   0 },;
							 { "FSTRIKEOUT","L",    1,   0 },;
							 { "FCHARSET",  "N",   10,   0 },;
							 { "FOUTPRECIS","N",   10,   0 },;
							 { "FCLIPRECIS","N",   10,   0 },;
							 { "FQUALITY",  "N",   10,   0 },;
							 { "FPITCHAND", "N",   10,   0 },;
							 { "FFACENAME", "C",   20,   0 },;
							 { "FCOLOR",    "N",   10,   0 } }

static aBase4     := {{ "Codigo",    "C",    3,   0 },;
							 { "NORDEN",    "N",    3,   0 },;
							 { "CFICHERO",  "C",   50,   0 },;
= 0
	nIva				:= 0
	nReq				:= 0

	DEFAULT cFactura	:= (cAlias)->NNUMFAC

	IF (cAliDeta)->( DbSeek( cFactura, .t. ) )

		WHILE (cAliDeta)->NNUMFAC == cFactura

			IF (cAliDeta)->NIVA == nPctIva

				#ifndef CAMERO
				nImporte	= Round( (cAliDeta)->NPREUNIT * (cAliDeta)->NUNICAJA , 0 )
				#else
				nImporte	= Round( (cAliDeta)->NPREUNIT * (cAliDeta)->NUNICAJA * (cAliDeta)->NCANENT, 0 )
				#endif

				IF (cAliDeta)->NDTO != 0
					nImporte -= Round( nImporte * (cAliDeta)->NDTO / 100, 0 )
				END IF

			END IF

			nBaseI	+= nImporte

		(cAliDeta)->( DbSkip() )

		END DO

		IF (cAlias)->NDTOESP != 0
			nTotDto += Round( nBaseI * (cAlias)->NDTOESP / 100, 0 )
		END IF

		IF (cAlias)->NDPP  != 0
			nTotDto += Round( nBaseI * (cAlias)->NDPP / 100, 0 )
		END IF

		nBaseI	-= nTotDto
		nIva 		:= Round( nBaseI * nPctIva / 100, 0 )

		IF (cAlias)->LRECARGO
			nBaseR	:= nBaseI
			nReq 		:= Round( nBaseR * nPReq( cAliIva, nPctIva ) / 100, 0 )
		END IF

	END IF

RETURN nBaseI

//---------------------------------------------------------------------------//

FUNCTION InfArticulo()

	local oDlg
	local oArticulo, cArticulo
	local oSay, cSay
	local oDesde, dDesde
	local oHasta, dHasta
	local oMeter, nMeter	:= 0
	local aoInfo	:= { { , , }, { , , }, { , , } }
	local anInfo	:= { {0,0,0}, {0,0,0}, {0,0,0} }

	dDesde	:= CtoD( "01/01/" + Str( Year( Date() ) ) )
	dHasta	:= Date()

	/*
	Caja de dialogo
	*/

	DEFINE DIALOG oDlg RESOURCE "INFARTICULO"

	REDEFINE GET oArticulo VAR cArticulo;
		ID 110 ;
		VALID cArticulo( oArticulo, , oSay );
		ON HELP ( BrwArticulo( oArticulo, , oSay ) );
		OF oDlg

	REDEFINE GET oSay VAR cSay ;
		WHEN ( .F. ) ;
		ID 120 ;
		OF oDlg

	REDEFINE GET oDesde VAR dDesde;
		ID 130 ;
		OF oDlg

	REDEFINE GET oHasta VAR dHasta;
		ID 140 ;
		OF oDlg

	REDEFINE GET aoInfo[1,1] VAR anInfo[1,1];
		ID 150;
		PICTURE "@E 999,999,999";
		OF oDlg

	REDEFINE GET aoInfo[1,2] VAR anInfo[1,2];
		ID 160;
		PICTURE "@E 999,999,999";
		OF oDlg

	REDEFINE GET aoInfo[1,3] VAR anInfo[1,3];
		ID 170;
		PICTURE "@E 999,999,999";
		OF oDlg

	REDEFINE GET aoInfo[2,1] VAR anInfo[2,1];
		ID 180;
		PICTURE "@E 999,999,999";
		OF oDlg

	REDEFINE GET aoInfo[2,2] VAR anInfo[2,2];
		ID 190;
		PICTURE "@E 999,999,999";
		OF oDlg

	REDEFINE GET aoInfo[2,3] VAR anInfo[2,3];
		ID 200;
		PICTURE "@E 999,999,999";
		OF oDlg

	REDEFINE GET aoInfo[3,1] VAR anInfo[3,1];
		ID 210;
		PICTURE "@E 999,999,999";
		OF oDlg

	REDEFINE GET aoInfo[3,2] VAR anInfo[3,2];
		ID 220;
		PICTURE "@E 999,999,999";
		OF oDlg

	REDEFINE GET aoInfo[3,3] VAR anInfo[3,3];
		ID 230;
		PICTURE "@E 999,999,999";
		OF oDlg

	/*----------------------------------------------------------------------------//
REDEFINE APOLOMETER oMeter VAR nMeter ;
		PROMPT "Calculando Entradas" ;
		ID 240 ;
		OF oDlg

	REDEFINE BUTTON oBtnOk ;
      ID       IDOK ;
      OF       oDlg ;
      ACTION   ( oBtnOk:disable(),;
					oBtnCancel:disable(),;
					Calcula( cArticulo, dDesde, dHasta, oMeter, aoInfo, anInfo ),;
					oBtnOk:enable(),;
					oBtnCancel:enable() )

	REDEFINE BUTTON oBtnCancel ;
      ID       IDCANCEL ;
      OF       oDlg ;
      ACTION   ( oDlg:end() )

	ACTIVATE DIALOG oDlg CENTER

RETURN NIL

//---------------------------------------------------------------------------//

STATIC FUNCTION Calcula( cArticulo, dDesde, dHasta, oMeter, aoInfo, anInfo )

	local dbfFacPrvT
	local dbfFacPrvL
	local dbfFacCliT
	local dbfFacCliL

	anInfo[1,1] := 0
	anInfo[1,2] := 0
	anInfo[1,3] := 0
	anInfo[2,1] := 0
	anInfo[2,2] := 0
	anInfo[2,3] := 0
	anInfo[3,1] := 0
	anInfo[3,2] := 0
	anInfo[3,3] := 0

	aoInfo[1,1]:refresh()
	aoInfo[1,2]:refresh()
	aoInfo[1,3]:refresh()
	aoInfo[2,1]:refresh()
	aoInfo[2,2]:refresh()
	aoInfo[2,3]:refresh()
	aoInfo[3,1]:refresh()
	aoInfo[3,2]:refresh()
	aoInfo[3,3]:refresh()

   USE ( cPatEmp() + "FACPRVT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACPRVT", @dbfFacPrvT ) )
   SET ADSINDEX TO ( cPatEmp() + "FACPRVT.CDX" ) ADDITIVE

   USE ( cPatEmp() + "FACPRVL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cChe#include "FiveWin.Ch"
#include "Font.ch"
#include "Report.ch"
#include "Factu.ch"

static dbfArticulo
static dbfAgent
static dbfFam
static dbfFacCliT
static dbfFacCliL
static dbfAlbCliT
static dbfAlbCliL
static dbfClient
static dbfTVta

//---------------------------------------------------------------------------//

FUNCTION InfArtFac()

	local oDlg
	local oBntPrev
	local oBtnImpr
	local oBtnCancel
	local oFam1
	local oFam2
	local oFamText1, cFamText1
	local oFamText2, cFamText2
	local oDesde
	local oHasta
	local cFam1
	local cFam2
   local oMtrInf
   local nMtrInf     := 0
   local cTitulo     := Padr( cCodEmp() + " - " + cNbrEmp(), 100 )
   local cSubTitulo  := Padr( "Resumen de facturación por familias", 100 )
	local nMeter		:= 0
	local dDesde		:= CtoD( "01/01/" + Str( Year( Date() ) ) )
	local dHasta		:= Date()
	local lSalto		:= .t.
   local lColCaj     := lUseCaj()
	local lPreMed 		:= .f.
	local lExlArt		:= .f.
	local lExlCero		:= .f.
   local lSerA       := .t.
   local lSerB       := .t.

	/*
	Bases de datos para el informe
	*/

	dbCommitAll()

   USE ( cPatEmp() + "ARTICULO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ARTICULO", @dbfArticulo ) )
   SET ADSINDEX TO ( cPatEmp() + "ARTICULO.CDX" ) ADDITIVE
	SET ORDER TO TAG "CFAMCOD"

   USE ( cPatGrp() + "FAMILIAS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FAMILIAS", @dbfFam ) )
   SET ADSINDEX TO ( cPatGrp() + "FAMILIAS.CDX" ) ADDITIVE

   USE ( cPatEmp() + "FACCLIT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACCLIT", @dbfFacCliT ) )
   SET ADSINDEX TO ( cPatEmp() + "FACCLIT.CDX" ) ADDITIVE

   USE ( cPatEmp() + "FACCLIL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACCLIL", @dbfFacCliL ) )
   SET ADSINDEX TO ( cPatEmp() + "FACCLIL.CDX" ) ADDITIVE
	SET ORDER TO TAG "CREF"

   USE ( cPatDat() + "TVTA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TVTA", @dbfTVta ) )
   SET ADSINDEX TO ( cPatDat() + "TVTA.CDX" ) ADDITIVE

	cFam1	:= dbFirst( dbfFam, 1 )
	cFam2	:= dbLast ( dbfFam, 1 )

	/*
	Caja de dialogo
	*/

	DEFINE DIALOG oDlg RESOURCE "INF_ARTFAC"

	REDEFINE GET oDesde VAR dDesde;
		SPINNER ;
		ID 		100 ;
		OF 		oDlg

	REDEFINE GET oHasta VAR dHasta;
		SPINNER ;
		ID 		110 ;
		OF 		oDlg

	REDEFINE GET oFam1 VAR cFam1;
		ID 		120 ;
		VALID 	cFamilia( oFam1, dbfFam, oFamText1 );
      BITMAP   "LUPA" ;
      ON HELP  BrwFamilia( oFam1, oFamText1 );
		OF 		oDlg

	REDEFINE GET oFamText1 VAR cFamText1 ;
		WHEN 		.F.;
		ID 		130 ;
		OF 		oDlg

	REDEFINE GET oFam2 VAR cFam2;
		ID 		140 ;
		VALID 	cFamilia( oFam2, dbfFam, oFamText2 );
      BITMAP   "LUPA" ;
      ON HELP  BrwFamilia( oFam2, oFamText2 );
		OF 		oDlg

	REDEFINE GET oFamText2 VAR cFamText2 ;
		WHEN 		.F.;
		ID 		150 ;
		OF 		oDlg

	REDEFINE GET cTitulo ;
		ID 		160 ;
		OF 		oDlg

	REDEFINE GET cSubTitulo ;
		ID 		170 ;
		OF 		oDlg

	REDEFINE CHECKBOX lSalto ;
		ID 		180 ;
		OF 		oDlg

	REDEFINE CHECKBOX lColCaj ;
		ID 		181 ;
      WHEN     lUseCaj() ;
		OF 		oDlg

	REDEFINE CHECKBOX lPreMed ;
		ID 		182 ;
		OF 		oDlg

	REDEFINE CHECKBOX lExlArt ;
		ID 		183 ;
		OF 		oDlg

	REDEFINE CHECKBOX lExlCero ;
		ID 		184 ;
		OF 		oDlg

   REDEFINE CHECKBOX lSerA ;
      ID       190 ;
		OF 		oDlg

   REDEFINE CHECKBOX lSerB ;
      ID       191 ;
		OF 		oDlg

REDEFINE APOLOMETER ;
		VAR 		nMtrInf ;
		PROMPT	"Procesando" ;
      ID       400;
		OF 		oDlg ;
      TOTAL    100

	REDEFINE BUTTON oBtnPrev ;
      ID       508;
		OF 		oDlg ;
      ACTION ( oDlg:disable(),;
               GenInfArt( dDesde, dHasta, oMtrInf, cFam1, cFam2, lExlCero, lSerA, lSerB, ),;
               PrnInfArt( dDesde, dHasta, cFam1, cFam2, lSalto, lColCaj, lPreMed, lExlArt, lExlCero, cTitulo, cSubTitulo, 1 ),;
               oDlg:enable() )

	REDEFINE BUTTON oBtnImpr ;
		ID 		505;
		OF 		oDlg ;
      ACTION ( oDlg:disable(),;
               GenInfArt( dDesde, dHasta, oMtrInf, cFam1, cFam2, lExlCero, lSerA, lSerB,  ),;
               PrnInfArt( dDesde, dHasta, cFam1, cFam2, lSalto, lColCaj, lPreMed, lExlArt, lExlCero, cTitulo, cSubTitulo, 2 ),;
               oDlg:enable() )

	REDEFINE BUTTON oBtnCancel ;
      ID       510;
		OF 		oDlg ;
		ACTION ( oDlg:end() )

   ACTIVATE DIALOG oDlg CENTER ON PAINT ( oFam1:lValid(), oFam2:lValid() )

	CLOSE ( dbfFam )
	CLOSE ( dbfArticulo )
	CLOSE ( dbfFacCliT )
	CLOSE ( dbfFacCliL )
   CLOSE ( dbfTVta )

RETURN NIL

//---------------------------------------------------------------------------//

STATIC FUNCTION GenInfArt( dDesde, dHasta, oMtrInf, cFam1, cFam2, lExlCero, lSerA, lSerB )

   local dbfTmp
   local nMet     := 0
   local aDbf     := {  { "CCODART", "C", 18, 0 },;
								{ "CNOMART", "C", 50, 0 },;
								{ "CFAMART", "C",  5, 0 },;
                        { "NNUMCAJ", "N", 16, 6 },;
                        { "NNUMUND", "N", 16, 6 },;
                        { "NIMPART", "N", 16, 6 },;
                        { "NPRDMED", "N", 16, 6 },;
                        { "NIVAART", "N", 16, 6 } }

   dbCreate(   cPatTmp() + "INFMOV.DBF", aDbf, cDriver() )

   dbUseArea(  .t., cDriver(), cPatTmp() + "INFMOV.DBF", cCheckArea( "INFMOV", @dbfTmp ), .f. )
   ordCreate(  cPatTmp() + "INFMOV.CDX", "CFAMART", "CFAMART", {|| CFAMART } )
   ordListAdd( cPatTmp() + "INFMOV.CDX" )

   oMtrInf:Set( ( dbfArticulo )->( recno() ) )
   oMtrInf:SetTotal( ( dbfArticulo )->( lastrec() ) )

	/*
	Nos movemos por la base de datos de los articulos
	*/

	(dbfArticulo)->( dbGoTop() )

	WHILE (dbfArticulo)->( !Eof() )

		IF ( dbfArticulo )->FAMILIA >= cFam1 .AND. ;
			( dbfArticulo )->F