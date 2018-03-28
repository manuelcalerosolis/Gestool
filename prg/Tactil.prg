#include "FiveWin.Ch"
#include "Menu.ch"
#include "Font.ch"
#include "Inkey.ch"
#include "Factu.ch" 
#include "Button.ch"

#define CABECERA                 "1"
#define CUERPO                   "2"
#define PIE                      "3"

#define _CCLITIK                   1     //   C,    12,     0
#define _CNOMTIK                   2     //   C,    50,     0
#define _CFPGTIK                   3     //   C,     2,     0
#define _CDIVTIK                   4     //   C,     3,     0

memvar cDbfTikT
memvar cDbfPgo
memvar cDbfTikP
memvar cDbfCli
memvar cPouTik
memvar cPorTik
memvar nDouTik
memvar nDorTik
memvar cUndTik

static oBmp
static oMenu
static lOpenFiles    := .f.
static lExternal     := .t.
static dbfTikCliT
static dbfTikCliL
static dbfTikCliC
static dbfClient
static dbfFPago
static dbfTikCliP
static dbfAlbCliT
static dbfAlbCliL
static dbfFacCliT
static dbfFacCliL
static dbfFacCliP
static dbfAntCliT
static dbfIva
static dbfCajT
static dbfCount
static cNewFilT
static dbfTmpTik
static dbfDiv
static dbfEmp
static dbfDoc
static cPouDiv
static cPorDiv
static cPicEur
static nDouDiv
static nDorDiv
static aTipDoc       := {  "Tiket", "Albarán", "Factura", "Devolución", "Apartado", "Vale" }
static aTotal        := { 0, 0, 0 } //1.- importe  2.- cobrado  3.- pendiente
static cPgoInUse     := ""

//---------------------------------------------------------------------------//
//
// Entra en el programa después de las comprobaciones de usuarios
//

FUNCTION CuentasClientes( oWnd )

   local oDlg
   local oBrw
   local oFntDlg        := TFont():New( "Arial", 12, 32, .f., .t. )
   local oFntBrw        := TFont():New( "Arial",  0, 14, .f., .f. )
   local oFntEur        := TFont():New( "Arial",  8, 34, .f., .t. )
   local oBtnPagos
   local oCodcli
   local cCodcli
   local oNomcli
   local cNomCli
   local oCodFpago
   local cCodFpago
   local oGetTxt
   local cGetTxt
   local oSayEnt
   local oEntCli
   local nEntCli        := 0
   local oPdtCli
   local nPdtCli        := 0
   local oSayPdt
   local oCmbCli
   local nCmbCli        := nEntCli - nPdtCli
   local oSayCmb

   DEFAULT oWnd         := oWnd()

   if !lOpenFiles()
      return .f.
   end if

   cCodFpago            := cDefFpg()
   cGetTxt              := RetFld( cCodFpago, dbfFPago )

   DEFINE DIALOG oDlg RESOURCE "CUENTAS_CLIENTES" TITLE "Cuentas de clientes"

   /*
   Codigo de cliente--------------------------------------------------------
   */

   REDEFINE BUTTONBMP ;
      ID       200 ;
      OF       oDlg ;
      BITMAP   "gc_keyboard_32" ;
      ACTION   ( oCodCli:cText( VirtualKey( .f. ) ), cClient( oCodCli, dbfClient, oNomCli ), lLoadClientes( oCodCli:VarGet(), dbfTikCliT, oBrw, oPdtCli, oCmbCli ) )

   REDEFINE BUTTONBMP ;
      ID       100 ;
      OF       oDlg ;
      BITMAP   "gc_user_32" ;
      ACTION   ( BrwCliTactil( oCodCli, dbfClient, oNomcli ), cClient( oCodCli, dbfClient, oNomCli ), lLoadClientes( oCodCli:VarGet(), dbfTikCliT, oBrw, oPdtCli, oCmbCli ) )

   REDEFINE GET oCodcli VAR cCodcli;
      ID       101 ;
      FONT     oFntDlg ;
      OF       oDlg;
      VALID    ( cClient( oCodCli, dbfClient, oNomCli ), lLoadClientes( oCodCli:VarGet(), dbfTikCliT, oBrw, oPdtCli, oCmbCli ) )

   REDEFINE GET oNomCli VAR cNomCli;
      ID       102 ;
      FONT     oFntDlg ;
      OF       oDlg

   /*
   Forma de pago------------------------------------------------------------
   */

   REDEFINE BUTTONBMP ;
      ID       210 ;
      OF       oDlg ;
      BITMAP   "gc_keyboard_32" ;
      ACTION   ( oCodFPago:cText( VirtualKey( .f. ) ), cFpago( oCodFPago, dbfFPago, oGetTxt ) )

   REDEFINE BUTTONBMP ;
      ID       110 ;
      OF       oDlg ;
      BITMAP   "gc_money2_32" ;
      ACTION   ( BrwPgoTactil( oCodFPago, dbfFPago, oGetTxt ), cFpago( oCodFPago, dbfFPago, oGetTxt ) )

   REDEFINE GET oCodFPago VAR cCodFPago ;
      ID       111 ;
      FONT     oFntDlg ;
      OF       oDlg;
      VALID    ( cFpago( oCodFPago, dbfFPago, oGetTxt ) ) ;

   oCodFpago:bHelp  := {|| BrwFPago( oCodFPago, oGetTxt, .t. ) }

   REDEFINE GET oGetTxt VAR cGetTxt ;
      ID       112 ;
      FONT     oFntDlg ;
      OF       oDlg

   /*
   Browse y botones de subir y bajar----------------------------------------
   */

   oBrw                 := IXBrowse():New( oDlg )

   oBrw:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
   oBrw:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

   oBrw:lFooter         := .t.
   oBrw:lHScroll        := .f.
   oBrw:cAlias          := dbfTmpTik
   oBrw:nMarqueeStyle   := 5
   oBrw:CreateFromResource( 120 )

   with object ( oBrw:AddCol() )
      :cHeader          := "Doc."
      :bEditValue       := {|| aTipDoc[ Max( Val( ( dbfTmpTik )->cTipTik ), 1 ) ] }
      :nWidth           := 60
   end with

   with object ( oBrw:AddCol() )
      :cHeader          := "Número"
      :bEditValue       := {|| ( dbfTmpTik )->cSerTik + "/" + lTrim( ( dbfTmpTik )->cNumTik ) + "/" + ( dbfTmpTik )->cSufTik }
      :nWidth           := 85
   end with

   with object ( oBrw:AddCol() )
      :cHeader          := "Fecha"
      :bEditValue       := {|| dtoc( ( dbfTmpTik )->dFecTik ) }
      :nWidth           := 65
   end with

   with object ( oBrw:AddCol() )
      :cHeader          := "Caja"
      :bEditValue       := {|| ( dbfTmpTik )->cNcjTik }
      :nWidth           := 35
   end with

   with object ( oBrw:AddCol() )
      :cHeader          := "Cajero"
      :bEditValue       := {|| ( dbfTmpTik )->cCcjTik }
      :nWidth           := 40
   end with

   with object ( oBrw:AddCol() )
      :cHeader          := "Importe"
      :bFooter          := {|| aTotal[1] }
      :bEditValue       := {|| nTotTik( ( dbfTmpTik )->cSerTik + ( dbfTmpTik )->cNumTik + ( dbfTmpTik )->cSufTik, dbfTikCliT, dbfTikCliL, dbfDiv, nil, cDivEmp(), .t. ) }
      :nWidth           := 65
      :nDataStrAlign    := 1
      :nHeadStrAlign    := 1
      :nFootStrAlign    := 1
   end with

   with object ( oBrw:AddCol() )
      :cHeader          := "Cobrado"
      :bFooter          := {|| aTotal[2] }
      :bEditValue       := {|| nTotCobTik( ( dbfTmpTik )->cSerTik + ( dbfTmpTik )->cNumTik + ( dbfTmpTik )->cSufTik, dbfTikCliP, dbfDiv, cDivEmp(), .t. ) }
      :nWidth           := 65
      :nDataStrAlign    := 1
      :nHeadStrAlign    := 1
      :nFootStrAlign    := 1
   end with

   with object ( oBrw:AddCol() )
      :cHeader          := "Pendiente"
      :bFooter          := {|| aTotal[3] }
      :bEditValue       := {|| Trans( nPendienteTicket( ( dbfTmpTik )->cSerTik + ( dbfTmpTik )->cNumTik + ( dbfTmpTik )->cSufTik ), cPouDiv ) }
      :nWidth           := 65
      :nDataStrAlign    := 1
      :nHeadStrAlign    := 1
      :nFootStrAlign    := 1
   end with

   REDEFINE BUTTONBMP ;
      ID       130;
      OF       oDlg ;
      BITMAP   "UP32" ;
      ACTION   ( oBrw:GoUp() ) ;

   REDEFINE BUTTONBMP ;
      ID       140;
      OF       oDlg ;
      BITMAP   "DOWN32" ;
      ACTION   ( oBrw:GoDown() )

   /*
   Pendiente-------------------------------------------------------------------
   */

   REDEFINE GET oPdtCli VAR nPdtCli;
      ID       160 ;
      WHEN     .f. ;
      FONT     oFntDlg ;
      PICTURE  cPorDiv ;
      OF       oDlg

   REDEFINE SAY oSayPdt VAR "Pendiente";
      ID       161 ;
      FONT     oFntDlg ;
      OF       oDlg;

   /*
   Entregas--------------------------------------------------------------------
   */

   REDEFINE BUTTONBMP ;
      ID       220 ;
      OF       oDlg ;
      BITMAP   "gc_calculator_32" ;
      ACTION   ( Calculadora( 0, oEntCli ), oCmbCli:cText( nEntCli - nPdtCli ) )

   REDEFINE BUTTONBMP oBtnPagos ;
      ID       230 ;
      OF       oDlg ;
      BITMAP   "gc_money2_32" ;
      ACTION   ( PagosTikets( oCodCli ) )

   REDEFINE GET oEntCli VAR nEntCli;
      ID       150 ;
      FONT     oFntDlg ;
      PICTURE  cPorDiv ;
      VALID    ( oCmbCli:cText( nEntCli - nPdtCli ), .t. );
      OF       oDlg

   REDEFINE SAY oSayEnt VAR "Entrega";
      ID       151 ;
      FONT     oFntDlg ;
      OF       oDlg;

   /*
   Cambio----------------------------------------------------------------------
   */

   REDEFINE GET oCmbCli VAR nCmbCli;
      ID       170 ;
      WHEN     .f. ;
      FONT     oFntDlg ;
      PICTURE  cPorDiv ;
      OF       oDlg

   REDEFINE SAY oSayCmb VAR "Cambio";
      ID       171 ;
      FONT     oFntDlg ;
      OF       oDlg;

   /*
   Monedas y billetes----------------------------------------------------------
   */

   REDEFINE BITMAP ;
      RESOURCE "Img500EUROS" ;
      ON CLICK ( ClkMoneda( 500, oEntCli, .f. ), oCmbCli:cText( nEntCli - nPdtCli ) ) ;
      ID       800;
      OF       oDlg

   REDEFINE BITMAP ;
      RESOURCE "Img200EUROS" ;
      ON CLICK ( ClkMoneda( 200, oEntCli, .f. ), oCmbCli:cText( nEntCli - nPdtCli ) ) ;
      ID       801;
      OF       oDlg

   REDEFINE BITMAP ;
      RESOURCE "Img100EUROS" ;
      ON CLICK ( ClkMoneda( 100, oEntCli, .f. ), oCmbCli:cText( nEntCli - nPdtCli ) ) ;
      ID       802;
      OF       oDlg

   REDEFINE BITMAP ;
      RESOURCE "Img50EUROS" ;
      ON CLICK ( ClkMoneda( 50, oEntCli, .f. ), oCmbCli:cText( nEntCli - nPdtCli ) ) ;
      ID       803;
      OF       oDlg

   REDEFINE BITMAP ;
      RESOURCE "Img20EUROS" ;
      ON CLICK ( ClkMoneda( 20, oEntCli, .f. ), oCmbCli:cText( nEntCli - nPdtCli ) ) ;
      ID       804;
      OF       oDlg

   REDEFINE BITMAP ;
      RESOURCE "Img10EUROS" ;
      ON CLICK ( ClkMoneda( 10, oEntCli, .f. ), oCmbCli:cText( nEntCli - nPdtCli ) ) ;
      ID       805;
      OF       oDlg

   REDEFINE BITMAP ;
      RESOURCE "Img5EUROS" ;
      ON CLICK ( ClkMoneda( 5, oEntCli, .f. ), oCmbCli:cText( nEntCli - nPdtCli ) ) ;
      ID       806;
      OF       oDlg

   REDEFINE BITMAP ;
      RESOURCE "Img2EUROS" ;
      ON CLICK ( ClkMoneda( 2, oEntCli, .f. ), oCmbCli:cText( nEntCli - nPdtCli ) ) ;
      ID       807;
      OF       oDlg

   REDEFINE BITMAP ;
      RESOURCE "Img1EURO" ;
      ON CLICK ( ClkMoneda( 1, oEntCli, .f. ), oCmbCli:cText( nEntCli - nPdtCli ) ) ;
      ID       808;
      OF       oDlg

   REDEFINE BITMAP ;
      RESOURCE "Img50CENT" ;
      ON CLICK ( ClkMoneda( 0.50, oEntCli, .f. ), oCmbCli:cText( nEntCli - nPdtCli ) ) ;
      ID       809;
      OF       oDlg

   REDEFINE BITMAP ;
      RESOURCE "Img20CENT" ;
      ON CLICK ( ClkMoneda( 0.20, oEntCli, .f. ), oCmbCli:cText( nEntCli - nPdtCli ) ) ;
      ID       810;
      OF       oDlg

   REDEFINE BITMAP ;
      RESOURCE "Img10CENT" ;
      ON CLICK ( ClkMoneda( 0.10, oEntCli, .f. ), oCmbCli:cText( nEntCli - nPdtCli ) ) ;
      ID       811;
      OF       oDlg

   REDEFINE BITMAP ;
      RESOURCE "Img5CENT" ;
      ON CLICK ( ClkMoneda( 0.05, oEntCli, .f. ), oCmbCli:cText( nEntCli - nPdtCli ) ) ;
      ID       812;
      OF       oDlg

   REDEFINE BITMAP ;
      RESOURCE "Img2CENT" ;
      ON CLICK ( ClkMoneda( 0.02, oEntCli, .f. ), oCmbCli:cText( nEntCli - nPdtCli ) ) ;
      ID       813;
      OF       oDlg

   REDEFINE BITMAP ;
      RESOURCE "Img1CENT" ;
      ON CLICK ( ClkMoneda( 0.01, oEntCli, .f. ), oCmbCli:cText( nEntCli - nPdtCli ) ) ;
      ID       814;
      OF       oDlg

   REDEFINE BITMAP ;
      RESOURCE "Img0EUROS" ;
      ON CLICK ( ClkMoneda( 0, oEntCli, .t. ), oCmbCli:cText( nEntCli - nPdtCli ) ) ;
      ID       815;
      OF       oDlg

   /*
   Botones del generales-------------------------------------------------------
   */

   REDEFINE BUTTON ;
      ID       550 ;
      OF       oDlg ;
      WHEN     ( ( dbfTmpTik )->( LastRec() ) != 0 ) ;
      ACTION   ( lFinalizar( oCodCli, oEntCli, oCmbCli, oCodFPago, oDlg, .t. ), oWnd:Refresh() )

   REDEFINE BUTTON ;
      ID       600 ;
      OF       oDlg ;
      WHEN     ( ( dbfTmpTik )->( LastRec() ) != 0 ) ;
      ACTION   ( lFinalizar( oCodCli, oEntCli, oCmbCli, oCodFPago, oDlg, .f. ), oWnd:Refresh() )

   REDEFINE BUTTON ;
      ID       650 ;
      OF       oDlg ;
      ACTION   ( oDlg:end() )

   oDlg:AddFastKey( VK_F5, {|| oDlg:end( IDOK ) } )

   ACTIVATE DIALOG oDlg CENTER

   aTotal        := { 0, 0, 0 }
   oFntDlg:End()
   oFntEur:End()
   oFntBrw:End()

   Closefiles()

Return ( oDlg:nResult == IDOK  )

//---------------------------------------------------------------------------//

STATIC FUNCTION lOpenFiles( cPatEmp, lExt )

   local oError
   local oBlock

   if lOpenFiles
      MsgStop( 'Imposible abrir ficheros de tickets de clientes' )
      Return ( .f. )
   end if

   DEFAULT cPatEmp      := cPatEmp()
   DEFAULT lExt         := .f.

   lExternal            := lExt

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      USE ( cPatEmp() + "CLIENT.DBF" )      NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CLIENT", @dbfClient ) )
      SET ADSINDEX TO ( cPatEmp() + "CLIENT.CDX" ) ADDITIVE

      USE ( cPatEmp() + "FPAGO.DBF" )       NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FPAGO", @dbfFPago ) )
      SET ADSINDEX TO ( cPatEmp() + "FPAGO.CDX" ) ADDITIVE

      USE ( cPatEmp + "TIKET.DBF" )       NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIKET", @dbfTikCliT ) )
      SET ADSINDEX TO ( cPatEmp + "TIKET.CDX" ) ADDITIVE

      USE ( cPatEmp + "TIKEL.DBF" )       NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIKEL", @dbfTikCliL ) )
      SET ADSINDEX TO ( cPatEmp + "TIKEL.CDX" ) ADDITIVE

      USE ( cPatEmp + "TIKEP.DBF" )       NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIKEP", @dbfTikCliP ) )
      SET ADSINDEX TO ( cPatEmp + "TIKEP.CDX" ) ADDITIVE

      USE ( cPatEmp + "TIKEC.DBF" )       NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIKEC", @dbfTikCliC ) )
      SET ADSINDEX TO ( cPatEmp + "TIKEC.CDX" ) ADDITIVE

      USE ( cPatEmp + "ALBCLIT.DBF" )     NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALBCLIT", @dbfAlbCliT ) )
      SET ADSINDEX TO ( cPatEmp + "ALBCLIT.CDX" ) ADDITIVE

      USE ( cPatEmp + "ALBCLIL.DBF" )     NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALBCLIL", @dbfAlbCliL ) )
      SET ADSINDEX TO ( cPatEmp + "ALBCLIL.CDX" ) ADDITIVE

      USE ( cPatEmp + "FACCLIT.DBF" )     NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACCLIT", @dbfFacCliT ) )
      SET ADSINDEX TO ( cPatEmp + "FACCLIT.CDX" ) ADDITIVE

      USE ( cPatEmp + "FACCLIL.DBF" )     NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACCLIL", @dbfFacCliL ) )
      SET ADSINDEX TO ( cPatEmp + "FACCLIL.CDX" ) ADDITIVE

      USE ( cPatEmp + "FACCLIP.DBF" )     NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACCLIP", @dbfFacCliP ) )
      SET ADSINDEX TO ( cPatEmp + "FACCLIP.CDX" ) ADDITIVE

      USE ( cPatDat() + "DIVISAS.DBF" )   NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "DIVISAS", @dbfDiv ) )
      SET ADSINDEX TO ( cPatDat() + "DIVISAS.CDX" ) ADDITIVE

      USE ( cPatDat() + "TIVA.DBF" )      NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIVA", @dbfIva ) )
      SET ADSINDEX TO ( cPatDat() + "TIVA.CDX" ) ADDITIVE

      USE ( cPatEmp + "ANTCLIT.DBF" )     NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ANTCLIT", @dbfAntCliT ) )
      SET ADSINDEX TO ( cPatEmp + "ANTCLIT.CDX" ) ADDITIVE

      USE ( cPatDat() + "CAJAS.DBF" )     NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CAJAS", @dbfCajT ) )
      SET ADSINDEX TO ( cPatDat() + "CAJAS.CDX" ) ADDITIVE

      USE ( cPatEmp() + "NCOUNT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "NCOUNT", @dbfCount ) )
      SET ADSINDEX TO ( cPatEmp() + "NCOUNT.CDX" ) ADDITIVE

      USE ( cPatDat() + "EMPRESA.DBF" )     NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "EMPRESA", @dbfEmp ) )
      SET ADSINDEX TO ( cPatDat() + "EMPRESA.CDX" ) ADDITIVE

      USE ( cPatEmp + "RDOCUMEN.DBF" ) NEW SHARED VIA ( cDriver() ) ALIAS ( cCheckArea( "RDOCUMEN", @dbfDoc ) )
      SET ADSINDEX TO ( cPatEmp + "RDOCUMEN.CDX" ) ADDITIVE
      SET TAG TO "CTIPO"

      /*
      Pictures--------------------------------------------------------------------
      */

      cPouDiv           := cPouDiv( cDivEmp(), dbfDiv )        // Picture de la divisa
      cPorDiv           := cPorDiv( cDivEmp(), dbfDiv )        // Picture de la divisa redondeada
      cPicEur           := cPorDiv( cDivChg(), dbfDiv )        // Picture de la divisa equivalente
      nDouDiv           := nDouDiv( cDivEmp(), dbfDiv )        // Decimales
      nDorDiv           := nRouDiv( cDivEmp(), dbfDiv )        // Decimales redondeados

      /*
      Creación de la tabla temporal de tikets-------------------------------------
      */

      cNewFilT          := cGetNewFileName( cPatTmp() + "TikT" )
      dbCreate( cNewFilT, aItmTik(), cDriver() )
      dbUseArea( .t., cDriver(), cNewFilT, cCheckArea( "TikT", @dbfTmpTik ), .f. )

      lOpenFiles        := .t.

   RECOVER USING oError

      lOpenFiles        := .f.

      msgStop( "Imposible todas las bases de datos" + CRLF + ErrorMessage( oError ) + CRLF )
      CloseFiles()

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpenFiles )

//---------------------------------------------------------------------------//

STATIC FUNCTION CloseFiles()

   CLOSE ( dbfTikCliT )
   CLOSE ( dbfTikCliL )
   CLOSE ( dbfClient  )
   CLOSE ( dbfFPago   )
   CLOSE ( dbfDiv     )
   CLOSE ( dbfTikCliP )
   CLOSE ( dbfTikCliC )
   CLOSE ( dbfAlbCliT )
   CLOSE ( dbfAlbCliL )
   CLOSE ( dbfFacCliT )
   CLOSE ( dbfFacCliL )
   CLOSE ( dbfFacCliP )
   CLOSE ( dbfIva     )
   CLOSE ( dbfAntCliT )
   CLOSE ( dbfTmpTik  )
   CLOSE ( dbfCajT    )
   CLOSE ( dbfCount   )
   CLOSE ( dbfEmp     )
   CLOSE ( dbfDoc     )

   dbfTikCliT     := nil
   dbfTikCliL     := nil
   dbfTikCliC     := nil
   dbfClient      := nil
   dbfFPago       := nil
   dbfDiv         := nil
   dbfTikCliP     := nil
   dbfAlbCliT     := nil
   dbfAlbCliL     := nil
   dbfFacCliT     := nil
   dbfFacCliL     := nil
   dbfFacCliP     := nil
   dbfIva         := nil
   dbfAntCliT     := nil
   dbfTmpTik      := nil
   dbfCajT        := nil
   dbfCount       := nil
   dbfEmp         := nil
   dbfDoc         := nil

   lOpenFiles     := .f.

   /*
   Borramos la tabla temporal de tickets---------------------------------------
   */

   dbfErase( cNewFilT )

RETURN .T.

//----------------------------------------------------------------------------//

Static function ClkMoneda( nImporte, oGet, lInit )

   local nVal  := oGet:VarGet()

   if lInit
      nVal     := nImporte
   else
      nVal     += nImporte
   end if

   oGet:cText( nVal )

Return nil

//--------------------------------------------------------------------------//
/*Esta función rellena la tabla de tickets de clientes*/

STATIC FUNCTION lLoadClientes( cCodCli, dbfTikCliT, oBrw, oPdtCli, oCmbCli )

   local nRec           := ( dbfTikCliT )->( Recno() )

   ( dbfTmpTik  )->( __dbZap() )
   ( dbfTikCliT )->( dbGoTop() )

   while !( dbfTikCliT )->( Eof() )

      if ( dbfTikCliT )->cCliTik == cCodCli .and. !( dbfTikCliT )->lPgdTik

         dbPass( dbfTikCliT, dbfTmpTik, .t. )

      end if

      ( dbfTikCliT )->( dbSkip() )

   end while

   nTotales( oPdtCli )
   //oBrw:aFooters        := { "", "", "", "", "", Trans( aTotal[ 1 ], cPorDiv ), Trans( aTotal[ 2 ], cPorDiv ), Trans( aTotal[ 3 ], cPorDiv ) }
   oCmbCli:Refresh()

   ( dbfTikCliT )->( dbGoTo( nRec ) )
   ( dbfTmpTik )->( dbGoTop() )
   oBrw:Refresh()

Return( .t. )

//---------------------------------------------------------------------------//

Static Function nTotales( oPdtCli )

   local nRec     := ( dbfTmpTik )->( Recno() )

   aTotal         := { 0, 0, 0 }

   ( dbfTmpTik )->( dbGoTop() )

   while !( dbfTmpTik )->( Eof() )

      aTotal[1]   += nTotTik( ( dbfTmpTik )->cSerTik + ( dbfTmpTik )->cNumTik + ( dbfTmpTik )->cSufTik, dbfTikCliT, dbfTikCliL, dbfDiv )
      aTotal[2]   += nTotCobTik( ( dbfTmpTik )->cSerTik + ( dbfTmpTik )->cNumTik + ( dbfTmpTik )->cSufTik, dbfTikCliP, dbfDiv )
      aTotal[3]   += nPendienteTicket( ( dbfTmpTik )->cSerTik + ( dbfTmpTik )->cNumTik + ( dbfTmpTik )->cSufTik )

      ( dbfTmpTik )->( dbSkip() )

   end while

   if oPdtCli != nil
      oPdtCli:SetText( aTotal[3] )
   end if

   ( dbfTmpTik )->( dbGoTo( nRec ) )

Return .t.

//---------------------------------------------------------------------------//
/*
Proceso de cobros de los tikets
*/

Static Function lFinalizar( oCodCli, oEntrega, oCambio, oCodFPago, oDlg, lPrint )

   local nNumPgo     := 0
   local nPendiente  := 0
   local nEntrega    := oEntrega:VarGet()
   local nCambio     := oCambio:VarGet()
   local cCodPgo     := oCodFPago:VarGet()
   local cCodCli     := oCodCli:VarGet()

   DEFAULT lPrint    := .f.

   if Empty( cCodCli )
      MsgStop( "Tiene que seleccionar un cliente para ver las cuentas pendientes" )
      oCodCli:SetFocus()
   end if

   if ( dbfTmpTik )->( Eof() ) .and. !Empty( oCodCli:VarGet() )
      MsgStop( "No existen cuentas pendientes para este cliente" )
      oCodCli:SetFocus()
      return .f.
   end if

   if !Empty( cCodCli ) .and. nEntrega <= 0
      MsgStop( "Entrega introducida no válida" )
      oEntrega:SetFocus()
      return .f.
   end if

   oMsgProgress()
   oMsgProgress():SetRange( 0, ( dbfTmpTik )->( LastRec() ) )

   oDlg:Disable()

   /*
   Creamos el meta pago--------------------------------------------------------
   */

   nNumPgo                    := nNewDoc( nil, dbfTikCliC, "NCOBCLI", nil, dbfCount )

   /*
   nCurPgo()

   while ( dbfTikCliC )->( dbSeek( nNumPgo ) ) .or. Empty( nNumPgo )
      nNumPgo                 := NewPgo()
   end while

   NewPgo()
   */

   cPgoInUse                  := Padl( Str( nNumPgo ), 9 ) + RetSufEmp()

   if dbAppe( dbfTikCliC )

      ( dbfTikCliC )->nNumPgo := nNumPgo
      ( dbfTikCliC )->cSufPgo := RetSufEmp()
      ( dbfTikCliC )->cCodCaj := Application():CodigoCaja()
      ( dbfTikCliC )->dPgoTik := GetSysDate()
      ( dbfTikCliC )->cFpgPgo := cCodPgo
      ( dbfTikCliC )->nImpPgo := nEntrega
      ( dbfTikCliC )->nDevPgo := nCambio
      ( dbfTikCliC )->nTotPgo := nEntrega - nCambio
      ( dbfTikCliC )->cCodCli := cCodCli
      ( dbfTikCliC )->cDivPgo := cDivEmp()
      ( dbfTikCliC )->nVdvPgo := nValDiv( cDivEmp(), dbfDiv )
      ( dbfTikCliC )->cCtaRec := cCtaCob()
      ( dbfTikCliC )->cTurPgo := cCurSesion()

      ( dbfTikCliC )->( dbUnLock() )

   else

      MsgStop( "No se ha podido añadir el registro de pago" )

   end if

   /*
   Repartimos las entregas-----------------------------------------------------
   */

   while nEntrega > 0 .and. !( dbfTmpTik )->( Eof() )

      nPendiente  := nPendienteTicket( ( dbfTmpTik )->cSerTik + ( dbfTmpTik )->cNumTik + ( dbfTmpTik )->cSufTik )

      do case
         case nEntrega >= nPendiente

            /*
            Creamos un pago con lo pentiente-----------------------------------
            */

            if dbAppe( dbfTikCliP )

               ( dbfTikCliP )->cCtaRec    := cCtaCob()
               ( dbfTikCliP )->cTurPgo    := cCurSesion()
               ( dbfTikCliP )->dPgoTik    := GetSysDate()
               ( dbfTikCliP )->cCodCaj    := Application():CodigoCaja()
               ( dbfTikCliP )->cFpgPgo    := cCodPgo
               ( dbfTikCliP )->cSerTik    := ( dbfTmpTik )->cSerTik
               ( dbfTikCliP )->cNumTik    := ( dbfTmpTik )->cNumTik
               ( dbfTikCliP )->cSufTik    := ( dbfTmpTik )->cSufTik
               ( dbfTikCliP )->nNumRec    := 0
               ( dbfTikCliP )->nImpTik    := nPendiente
               ( dbfTikCliP )->cDivPgo    := ( dbfTmpTik )->cDivTik
               ( dbfTikCliP )->nVdvPgo    := ( dbfTmpTik )->nVdvTik
               ( dbfTikCliP )->nDevTik    := 0
               ( dbfTikCliP )->lCloPgo    := .f.
               ( dbfTikCliP )->lSndPgo    := .t.
               ( dbfTikCliP )->nNumPgo    := nNumPgo
               ( dbfTikCliP )->cSufPgo    := RetSufEmp()

            else

               MsgStop( "No se ha podido añadir el registro de pago" )

            end if

            /*
            Marcamos el tiket como pagado--------------------------------------
            */

            if ( dbfTikCliT )->( dbSeek( ( dbfTmpTik )->cSerTik + ( dbfTmpTik )->cNumTik + ( dbfTmpTik )->cSufTik ) )

               if dbLock( dbfTikCliT )
                  ( dbfTikCliT )->nCobTik    := nPendiente
                  ( dbfTikCliT )->lPgdTik    := .t.
                  ( dbfTikCliT )->lSndDoc    := .t.
                  ( dbfTikCliT )->lLiqTik    := .t.
                  ( dbfTikCliT )->( dbUnLock() )
               end if

            end if

         case nEntrega < nPendiente .and. nEntrega > 0

            /*
            creamos un pago con lo que nos queda
            */

            if dbAppe( dbfTikCliP )

               ( dbfTikCliP )->cCtaRec    := cCtaCob()
               ( dbfTikCliP )->cTurPgo    := cCurSesion()
               ( dbfTikCliP )->dPgoTik    := GetSysDate()
               ( dbfTikCliP )->cCodCaj    := Application():CodigoCaja()
               ( dbfTikCliP )->cFpgPgo    := cCodPgo
               ( dbfTikCliP )->cSerTik    := ( dbfTmpTik )->cSerTik
               ( dbfTikCliP )->cNumTik    := ( dbfTmpTik )->cNumTik
               ( dbfTikCliP )->cSufTik    := ( dbfTmpTik )->cSufTik
               ( dbfTikCliP )->nNumRec    := 0
               ( dbfTikCliP )->nImpTik    := nEntrega
               ( dbfTikCliP )->cDivPgo    := ( dbfTmpTik )->cDivTik
               ( dbfTikCliP )->nVdvPgo    := ( dbfTmpTik )->nVdvTik
               ( dbfTikCliP )->nDevTik    := 0
               ( dbfTikCliP )->lCloPgo    := .f.
               ( dbfTikCliP )->lSndPgo    := .t.
               ( dbfTikCliP )->nNumPgo    := nNumPgo
               ( dbfTikCliP )->cSufPgo    := RetSufEmp()

            else

               MsgStop( "No se ha podido añadir el registro de pago" )

            end if

      end case

      nEntrega    -= nPendiente

      ( dbfTmpTik )->( dbSkip() )

      oMsgProgress():Deltapos(1)

   end while

   EndProgress()

   if !Empty( cCodCli ) .and. lPrint
      PrintPagoCliente( .f. )
   end if

   cPgoInUse := ""

   oDlg:Enable()
   oDlg:end( IDOK )

Return .t.

//---------------------------------------------------------------------------//

Static Function PagosTikets( oCodCli )

   local oDlg
   local oBrw
   local nRec     := ( dbfTikCliC )->( RecNo() )
   local nOrdAnt  := ( dbfTikCliC )->( OrdSetFocus( "CCODCLI" ) )
   local cCliente := oCodCli:VarGet()

   if Empty( cCliente )
      MsgStop( "Tiene que seleccionar un cliente" )
      oCodCli:SetFocus()
      Return .f.
   end if

   ( dbfTikCliC )->( OrdScope( 0, cCliente ) )
   ( dbfTikCliC )->( OrdScope( 1, cCliente ) )

   DEFINE DIALOG oDlg RESOURCE "PAGOS_CLIENTES" TITLE "Pagos de: " + AllTrim( cCliente ) + " - " + RetFld( cCliente, dbfClient )

   /*
   Browse y botones de subir y bajar----------------------------------------
   */

   oBrw                 := IXBrowse():New( oDlg )

   oBrw:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
   oBrw:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

   oBrw:lHScroll        := .f.
   oBrw:cAlias          := dbfTikCliC
   oBrw:nMarqueeStyle   := 5
   oBrw:CreateFromResource( 100 )

   with object ( oBrw:AddCol() )
      :cHeader          := "Número"
      :bEditValue       := {|| AllTrim( Str( ( dbfTikCliC )->nNumPgo ) ) + "/" + ( dbfTikCliC )->cSufPgo }
      :nWidth           := 80
   end with

   with object ( oBrw:AddCol() )
      :cHeader          := "Cliente"
      :bEditValue       := {|| AllTrim( ( dbfTikCliC )->cCodCli ) + " - " + RetFld( ( dbfTikCliC )->cCodCli, dbfClient ) }
      :nWidth           := 300
   end with

   with object ( oBrw:AddCol() )
      :cHeader          := "Fecha"
      :bEditValue       := {|| Dtoc( ( dbfTikCliC )->dPgoTik ) }
      :nWidth           := 65
   end with

   with object ( oBrw:AddCol() )
      :cHeader          := "Importe"
      :bEditValue       := {|| Trans( ( dbfTikCliC )->nImpPgo - ( dbfTikCliC )->nDevPgo, cPorDiv ) }
      :nWidth           := 50
      :nDataStrAlign    := 1
      :nHeadStrAlign    := 1
   end with

   REDEFINE BUTTONBMP ;
      ID       110;
      OF       oDlg ;
      BITMAP   "UP32" ;
      ACTION   ( oBrw:GoUp() )

   REDEFINE BUTTONBMP ;
      ID       120;
      OF       oDlg ;
      BITMAP   "DOWN32" ;
      ACTION   ( oBrw:GoDown() )

   REDEFINE BUTTONBMP ;
      ID       150 ;
      OF       oDlg ;
      BITMAP   "gc_monitor_32" ;
      ACTION   ( PrintPagoCliente( .t. ) )

   REDEFINE BUTTONBMP ;
      ID       130 ;
      OF       oDlg ;
      BITMAP   "gc_printer2_32" ;
      ACTION   ( PrintPagoCliente( .f. ) )

   REDEFINE BUTTONBMP ;
      ID       140 ;
      OF       oDlg ;
      BITMAP   "gc_door_open2_32" ;
      ACTION   ( oDlg:end() )

   ACTIVATE DIALOG oDlg CENTER

   ( dbfTikCliC )->( OrdScope( 0, nil ) )
   ( dbfTikCliC )->( OrdScope( 1, nil ) )
   ( dbfTikCliC )->( OrdSetFocus( nOrdAnt ) )
   ( dbfTikCliC )->( dbGoTo( nRec ) )

Return .t.

//---------------------------------------------------------------------------//

STATIC FUNCTION PrintPagoCliente( lPrev, cCodDoc, cPrinter, nCopies )

   local nImpYet     := 0
   local nRec        := ( dbfTikCliC )->( Recno() )
   local nOrdAnt     := ( dbfTikCliC )->( OrdSetFocus( "NNUMPGO" ) )
   local nRecPagos   := ( dbfTikCliP )->( Recno() )
   local nOrdPagos   := ( dbfTikCliP )->( OrdSetFocus( "NNUMPGO" ) )

   DEFAULT lPrev     := .f.
   DEFAULT cCodDoc   := cFormatoPagoEnCaja( ( dbfTikCliC )->cCodCaj, dbfCajT )
   DEFAULT cPrinter  := cPrinterMetaPago( Application():CodigoCaja(), dbfCajT )
   DEFAULT nCopies   := nCopiasMetaPagosEnCaja( Application():CodigoCaja(), dbfCajT )

   if !Empty( cPgoInUse )
      ( dbfTikCLiC )->( dbGoTop() )
      ( dbfTikCliC )->( dbSeek( cPgoInUse ) )
   end if

   if !lExisteDocumento( cCodDoc, dbfDoc )
      return nil
   end if

   if lPrev

      PrintReportPgoCli( IS_SCREEN , 1, cPrinter, dbfDoc )

   else

      While nImpYet < nCopies

         if nImpYet < 1 .or. ApoloMsgNoYes( "¿Desea imprimir el tiket Nº" + Str( nImpYet + 1, 2 ) + "?", "Elija una opción" )

            PrintReportPgoCli( IS_PRINTER , 1, cPrinter, dbfDoc )

         end if

         ++nImpYet

      end do

   end if

   ( dbfTikCLiC )->( OrdSetFocus( nOrdAnt ) )
   ( dbfTikCliP )->( OrdSetFocus( nOrdPagos ) )
   ( dbfTikCliC )->( dbGoTo( nRec ) )
   ( dbfTikCliP )->( dbGoto( nRecPagos ) )

RETURN nil

//---------------------------------------------------------------------------//

#include "FastRepH.ch"

Static Function DataReport( oFr )

   /*
   Zona de datos------------------------------------------------------------
   */

   oFr:ClearDataSets()

   oFr:SetWorkArea(     "Pago cliente", ( dbfTikCliC )->( Select() ), .f., { FR_RB_CURRENT, FR_RB_CURRENT, 0 } )
   oFr:SetFieldAliases( "Pago cliente", cItemsToReport( aPgoCli() ) )

   oFr:SetWorkArea(     "Pagos tickets", ( dbfTikCliP )->( Select() ) )
   oFr:SetFieldAliases( "Pagos tickets", cItemsToReport( aPgoTik() ) )

   oFr:SetWorkArea(     "Empresa", ( dbfEmp )->( Select() ) )
   oFr:SetFieldAliases( "Empresa", cItemsToReport( aItmEmp() ) )

   oFr:SetWorkArea(     "Clientes", ( dbfClient )->( Select() ) )
   oFr:SetFieldAliases( "Clientes", cItemsToReport( aItmCli() ) )

   oFr:SetWorkArea(     "Formas de pago", ( dbfFpago )->( Select() ) )
   oFr:SetFieldAliases( "Formas de pago", cItemsToReport( aItmFPago() ) )

   oFr:SetMasterDetail( "Pago cliente", "Pagos tickets",      {|| Str( ( dbfTikCliC )->nNumPgo ) + ( dbfTikCliC )->cSufPgo } )
   oFr:SetMasterDetail( "Pago cliente", "Empresa",            {|| cCodigoEmpresaEnUso() } )
   oFr:SetMasterDetail( "Pago cliente", "Clientes",           {|| ( dbfTikCliC )->cCodCli } )
   oFr:SetMasterDetail( "Pago cliente", "Formas de pago",     {|| ( dbfTikCliC )->cFpgPgo } )

   oFr:SetResyncPair(   "Pago cliente", "Pagos tickets" )
   oFr:SetResyncPair(   "Pago cliente", "Empresa" )
   oFr:SetResyncPair(   "Pago cliente", "Clientes" )
   oFr:SetResyncPair(   "Pago cliente", "Formas de pago" )

Return nil

//---------------------------------------------------------------------------//

Function DesignReportPgoCli( oFr, dbfDoc )

   local nRec
   local nOrdAnt

   if lOpenFiles()

      /*
      Posicionamos la tabla de pagos de clientes
      -------------------------------------------------------------------------
      */

      nRec     := ( dbfTikCliP )->( Recno() )
      nOrdAnt  := ( dbfTikCliP )->( OrdSetFocus( "NNUMPGO" ) )

      /*
      Zona de datos------------------------------------------------------------
      */

      DataReport( oFr )

      /*
      Paginas y bandas---------------------------------------------------------
      */

      if !Empty( ( dbfDoc )->mReport )

         oFr:LoadFromBlob( ( dbfDoc )->( Select() ), "mReport")

      else

         oFr:SetProperty(     "Report",            "ScriptLanguage", "PascalScript" )

         oFr:AddPage(         "MainPage" )

         oFr:AddBand(         "CabeceraDocumento", "MainPage", frxPageHeader )
         oFr:SetProperty(     "CabeceraDocumento", "Top", 0 )
         oFr:SetProperty(     "CabeceraDocumento", "Height", 200 )

         oFr:AddBand(         "MasterData",  "MainPage", frxMasterData )
         oFr:SetProperty(     "MasterData",  "Top", 200 )
         oFr:SetProperty(     "MasterData",  "Height", 0 )
         oFr:SetProperty(     "MasterData",  "StartNewPage", .t. )
         oFr:SetObjProperty(  "MasterData",  "DataSet", "Pago cliente" )

         oFr:AddBand(         "DetalleColumnas",   "MainPage", frxDetailData  )
         oFr:SetProperty(     "DetalleColumnas",   "Top", 230 )
         oFr:SetProperty(     "DetalleColumnas",   "Height", 28 )
         oFr:SetObjProperty(  "DetalleColumnas",   "DataSet", "Pagos tickets" )
         oFr:SetProperty(     "DetalleColumnas",   "OnMasterDetail", "DetalleOnMasterDetail" )

         oFr:AddBand(         "PieDocumento",      "MainPage", frxPageFooter )
         oFr:SetProperty(     "PieDocumento",      "Top", 930 )
         oFr:SetProperty(     "PieDocumento",      "Height", 110 )

      end if

      /*
      Diseño de report---------------------------------------------------------
      */

      oFr:DesignReport()

      /*
      Destruye el diseñador----------------------------------------------------
      */

      oFr:DestroyFr()

      /*
      Dejamos las tablas donde estaban-----------------------------------------
      */

      ( dbfTikCliP )->( OrdSetFocus( nOrdAnt ) )
      ( dbfTikCliP )->( dbGoTo( nRec ) )

      /*
      Cierra ficheros----------------------------------------------------------
      */

      CloseFiles()

   else

      Return .f.

   end if

Return .t.

//---------------------------------------------------------------------------//

Function PrintReportPgoCli( nDevice, nCopies, cPrinter, dbfDoc )

   local oFr

   DEFAULT nDevice      := IS_SCREEN
   DEFAULT nCopies      := 1
   DEFAULT cPrinter     := PrnGetName()

   SysRefresh()

   oFr                  := frReportManager():New()

   oFr:LoadLangRes(     "Spanish.Xml" )

   oFr:SetIcon( 1 )

   oFr:SetTitle(        "Diseñador de documentos" )

   /*
   Manejador de eventos--------------------------------------------------------
   */

   oFr:SetEventHandler( "Designer", "OnSaveReport", {|| oFr:SaveToBlob( ( dbfDoc )->( Select() ), "mReport" ) } )

   /*
   Zona de datos------------------------------------------------------------
   */

   DataReport( oFr )

   /*
   Cargar el informe-----------------------------------------------------------
   */

   if !Empty( ( dbfDoc )->mReport )

      oFr:LoadFromBlob( ( dbfDoc )->( Select() ), "mReport")

      /*
      Preparar el report-------------------------------------------------------
      */

      oFr:PrepareReport()

      /*
      Imprimir el informe------------------------------------------------------
      */

      do case
         case nDevice == IS_SCREEN
            oFr:ShowPreparedReport()

         case nDevice == IS_PRINTER
            oFr:PrintOptions:SetPrinter( cPrinter )
            oFr:PrintOptions:SetCopies( nCopies )
            oFr:PrintOptions:SetShowDialog( .f. )
            oFr:Print()

         case nDevice == IS_PDF
            oFr:SetProperty(  "PDFExport", "EmbeddedFonts",    .t. )
            oFr:SetProperty(  "PDFExport", "PrintOptimized",   .t. )
            oFr:SetProperty(  "PDFExport", "Outline",          .t. )
            oFr:DoExport(     "PDFExport" )

      end case

   end if

   /*
   Destruye el diseñador-------------------------------------------------------
   */

   oFr:DestroyFr()

Return .t.

//---------------------------------------------------------------------------//

static function nPendienteTicket( cNumTik )

   local nPendiente  := 0

   nPendiente += nTotTik( ( dbfTmpTik )->cSerTik + ( dbfTmpTik )->cNumTik + ( dbfTmpTik )->cSufTik, dbfTikCliT, dbfTikCliL, dbfDiv, nil )
   nPendiente -= nTotCobTik( ( dbfTmpTik )->cSerTik + ( dbfTmpTik )->cNumTik + ( dbfTmpTik )->cSufTik, dbfTikCliP, dbfDiv )

return ( nPendiente )

//---------------------------------------------------------------------------//