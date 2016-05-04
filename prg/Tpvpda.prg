#ifndef __PDA__
   #include "FiveWin.Ch"
   #include "WebCtl.ch"
   #include "Report.ch"
   #include "Xbrowse.ch"
#else
   #include "FWCE.ch"
   REQUEST DBFCDX

#endif

#include "Factu.ch" 

#ifndef __PDA__

#define CABECERA                 "1"
#define CUERPO                   "2"
#define PIE                      "3"

#define _MENUITEM_               "01063"

#define NUM_BTN_FAM               7
#define NUM_BTN_ART              19

#define FONT_NAME                "Arial" // "Segoe UI"

/*
Ficheros-----------------------------------------------------------------------
*/

#define _CSERTIK                   1      //   C,     1,     0
#define _CNUMTIK                   2      //   C,     9,     0
#define _CSUFTIK                   3      //   C,     2,     0
#define _CTIPTIK                   4      //   C,     1,     0
#define _CTURTIK                   5      //   C,     6,     0
#define _DFECTIK                   6      //   D,     8,     0
#define _CHORTIK                   7      //   C,     5,     0
#define _CCCJTIK                   8      //   C,     3,     0
#define _CNCJTIK                   9      //   C,     3,     0
#define _CALMTIK                   10     //   C,     3,     0
#define _CCLITIK                   11     //   C,    12,     0
#define _NTARIFA                   12     //   L,     1,     0
#define _CNOMTIK                   13     //   C,    50,     0
#define _CDIRCLI                   14
#define _CPOBCLI                   15
#define _CPRVCLI                   16
#define _NCODPROV                  17
#define _CPOSCLI                   18
#define _CDNICLI                   19
#define _LMODCLI                   20
#define _CFPGTIK                   21     //   C,     2,     0
#define _NCOBTIK                   22     //   N,    13,     3
#define _NCAMTIK                   23     //   N,    13,     3
#define _CDIVTIK                   24     //   C,     3,     0
#define _NVDVTIK                   25     //   N,    10,     3
#define _LCLOTIK                   26     //   L,     1,     0
#define _LSNDDOC                   27     //   L,     1,     0
#define _LPGDTIK                   28     //   L,     1,     0
#define _CRETPOR                   29
#define _CRETMAT                   30
#define _CNUMDOC                   31
#define _CCODAGE                   32     //   C,     3,     0
#define _CCODRUT                   33     //   C,     4,     0
#define _CCODTAR                   34     //   C,     5,     0
#define _CCODOBR                   35     //   C,     3,     0
#define _NCOMAGE                   36     //   N      5,     1
#define _LLIQTIK                   37     //   L      1,     0
#define _CCODPRO                   38     //   C      9,     0, "Codigo de proyecto en contabilidad"} }
#define _LCONTIK                   39     //   L      1,     0
#define _DFECCRE                   40
#define _CTIMCRE                   41
#define _LSELDOC                   42     //   L      1,     0
#define _CVALDOC                   43
#define _CTURVAL                   44
#define _LCNVTIK                   45     //   L      1,     0
#define _CCODDLG                   46     //   C      1,     0
#define _CCODGRP                   47     //   C      1,     0
#define _CCODSALA                  48     //   C      1,     0
#define _CPNTVENTA                 49     //   C      1,     0
#define _LABIERTO                  50     //   L      1,     0
#define _CALIASTIK                 51     //   L      1,     0
#define _NNUMCOM                   52     //   N      3,     0

#define _CSERTIL                   1      //   C      1      0
#define _CNUMTIL                   2      //   C     10      0
#define _CSUFTIL                   3      //   C      2      0
#define _CTIPTIL                   4      //   C      1      0
#define _CCBATIL                   5      //   C     14      0
#define _CNOMTIL                   6      //   C     20      0
#define _NPVPTIL                   7      //   N     13      3
#define _NUNTTIL                   8      //   N     13      3
#define _NUNDKIT                   9      //   N      5      2
#define _NIVATIL                  10      //   C      3      0
#define _CFAMTIL                  11      //   L      1      0
#define _LOFETIL                  12      //   C     20      0
#define _CCOMTIL                  13      //   C     20      0
#define _CNCMTIL                  14      //   C     13      3
#define _NPCMTIL                  15      //   C      5      0
#define _CFCMTIL                  16      //   L      1      0
#define _LFRETIL                  17
#define _NDTOLIN                  18
#define _CCODPR1                  19
#define _CCODPR2                  20
#define _CVALPR1                  21
#define _CVALPR2                  22
#define _NFACCNV                  23
#define _NDTODIV                  24      //   L      1      0
#define _LTIPACC                  25      //   L      1      0
#define _NCTLSTK                  26      //   N      5      1
#define _CALMLIN                  27
#define _NVALIMP                  28
#define _CCODIMP                  29
#define _NCOSDIV                  30
#define _NNUMLIN                  31
#define _LKITART                  32
#define _LKITCHG                  33
#define _LKITPRC                  34
#define _LIMPLIN                  35
#define _NMESGRT                  36
#define _LCONTROL                 37
#define _MNUMSER                  38
#define _CCODFAM                  39
#define _CGRPFAM                  40
#define _NLOTE                    41
#define _CLOTE                    42
#define _NNUMPGO                  43
#define _CSUFPGO                  44
#define _NNUMMED                  45
#define _NMEDUNO                  46
#define _NMEDDOS                  47
#define _NMEDTRE                  48
#define _CCODINV                  49
#define _NFCMCNV                  50
#define _CCODUSR                  51
#define _LIMPCOM                  52
#define _NIMPCOM1                 53
#define _NIMPCOM2                 54

#define _NNUMREC                   4
#define _CCODCAJ                   5
#define _DPGOTIK                   6
#define _CTIMTIK                   7
#define _CFPGPGO                   8
#define _NIMPTIK                   9
#define _NDEVTIK                  10
#define _CPGDPOR                  11
#define _CDIVPGO                  12
#define _NVDVPGO                  13
#define _LCONPGO                  15
#define _CCTAPGO                  15
#define _LCLOPGO                  16
#define _LSNDPGO                  17
#define _CTURPGO                  18
#define _CCTAREC                  19

memvar cDbfTik
memvar cDbfTil
memvar cDbfTip
memvar cDbfCli
memvar cDbfUsr
memvar cPouTik
memvar cPorTik
memvar cUndTik
memvar nDouTik
memvar nDorTik
memvar nTotTik
memvar nTotIvm
memvar nTotVal
memvar aIvaTik
memvar aBasTik
memvar aImpTik
memvar aIvmTik
memvar nTotNet
memvar nTotIva
memvar nTotAlb
memvar nTotFac
memvar nTotPax

memvar cDbfAlbCliT
memvar cDbfAlbCliL
memvar cDbfFacCliT
memvar cDbfFacCliL

static oWndBrw
static oWndBig
static dbfClient
static dbfCajT
static dbfUsr
static dbfFPago
static dbfArticulo
static dbfCodebar
static dbfCount
static dbfTmpL
static dbfTmpP
static dbfTmpV
static dbfTmpA
static dbfTmpE
static dbfOferta
static dbfKit
static dbfTblPro
static dbfFacCliT
static dbfFacCliL
static dbfFacCliP
static dbfAntCliT
static dbfAlbCliT
static dbfAlbCliL
static dbfAlbCliP
static dbfObrasT
static dbfAgent
static dbfTarPreL
static dbfTarPreS
static dbfRuta
static dbfAlm
static dbfDoc

static dbfCliAtp
static dbfCajPorta
static dbfAgeCom
static dbfTblCnv
static dbfEmp

static dbfPedCliT
static dbfPedCliL

static oVisor
static oCajon
static oImpresora
static oBalanza
static oInvitacion

static cNewFilL
static cNewFilP
static cNewFilV
static cNewFilA
static cNewFilE
static oNumTot
static oEurTot
static oTxtTot
static oTxtCom
static oTotCom
static oBmpVis
static nOldPvp
static cPouDiv
static cPorDiv
static nDouDiv
static nDorDiv
static cPicEur
static cPicUnd
static lApartado
static oBandera
static oStock
static oCaptura
static dbfFamilia
static dbfArtDiv
static oMetMsg
static nMetMsg
static oFntTot
static oFntEur
static oFntBrw
static oFntNum
static cFilBmp
static aDim
static oDlgTpv
static aDbfBmp
static oBtnIni
static oBtnFam
static oSayFam
static oBtnArt
static oBtnNum
static oSayArt
static oBtnTik
static oBtnAlb
static oBtnFac
static oBtnApt
static oBtnUp
static oBtnDown

static oCopTik
static lCopTik             := .t.
static nCopTik             := 1

static oRieCli

static oOfficeBar

static aGetTxt
static oGetTxt

static oBrwDet

static oBtnFree
static oSayFree

static oBtnUsuario
static oSayUsuario
static oBtnTarifa
static oBtnEntregar
static oBtnRenombrar
static oBtnPedidos
static oBtnCliente
static oBtnDireccion
static oBtnTelefono

static oSalaVentas

static oTotDiv

static nTotOld

static nSaveMode
static lSave

static oTimerBtn

static cCapCaj
static oNewImp
static oMenu
static nCambioTik          := 0
static nTotalTik           := 0
static lTwoLin             := .f.
static cCodArtAnt          := ""
static cCodFamAnt          := ""
static aRecFam             := {}
static lNowAppendLine      := .f.
static aRecArt             := {}
static cOldCodCli          := ""
static cOldCodArt          := ""
static cOldPrpArt          := ""

static lExternal           := .t.
static nScreenHorzRes      := 0
static nNumBtnFam          := NUM_BTN_FAM
static nNumBtnArt          := NUM_BTN_ART
static aTipDoc             := { "Tiket", "Albarán", "Factura", "Devolución", "Apartado", "Vale" }
static bEditT              := { |aTmp, aGet, dbfTikT, oBrw, cTot, nTot, nMode             | EdtRec( aTmp, aGet, dbfTikT, oBrw, cTot, nTot, nMode ) }
static bEditB              := { |aTmp, aGet, dbfTikT, oBrw, cTot, nTot, nMode, oWnd       | EdtBig( aTmp, aGet, dbfTikT, oBrw, cTot, nTot, nMode, oWnd ) }
static bEditL              := { |aTmp, aGet, dbfTikL, oBrw, bWhen, bValid, nMode, cNumTik | EdtDet( aTmp, aGet, dbfTikL, oBrw, bWhen, bValid, nMode, cNumTik ) }
static bEditP              := { |aTmp, aGet, dbfTikP, oBrw, bWhen, bValid, nMode, aTmpTik | EdtCob( aTmp, aGet, dbfTikP, oBrw, bWhen, bValid, nMode, aTmpTik ) }
static bEditE              := { |aTmp, aGet, dbfTmpE, oBrw, bWhen, bValid, nMode, aTmpTik | EdtEnt( aTmp, aGet, dbfTmpE, oBrw, bWhen, bValid, nMode, aTmpTik ) }

static aButtonsPago

static oUndMedicion

#else

static bEdtPda       := { |aTmp, aGet, dbfTikT, oBrw, bWhen, bValid, nMode             | EdtPda( aTmp, aGet, dbfTikT, oBrw, bWhen, bValid, nMode ) }
static nMesa
static nArticulo

/*
static bDetPda       := { |aTmp, aGet, dbfPedCliL, oBrw, bWhen, bValid, nMode, aTmpPed | DetPda( aTmp, aGet, dbfPedCliL, oBrw, bWhen, bValid, nMode, aTmpPed ) }
static bIncPda       := { |aTmp, aGet, dbfPedCliI, oBrw, bWhen, bValid, nMode, aTmpLin | IncPda( aTmp, aGet, dbfPedCliI, oBrw, bWhen, bValid, nMode, aTmpLin ) }
*/
#endif

static dbfTikT
static dbfTikL
static dbfTikP
static dbfIva
static dbfDiv

static lOpenFiles          := .f.

//---------------------------------------------------------------------------//

#ifndef __PDA__

//---------------------------------------------------------------------------//

STATIC FUNCTION OpenFiles( cPatEmp, lExt, lTactil )

   local oError
   local oBlock
   local cVisor
   local cCajon
   local cBalanza
   local cImpresora


   if lOpenFiles
      MsgStop( 'Imposible abrir ficheros de tickets de clientes' )
      Return ( .f. )
   end if

   DEFAULT cPatEmp      := cPatEmp()
   DEFAULT lExt         := .f.
   DEFAULT lTactil      := .f.

   lExternal            := lExt

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   lOpenFiles           := .t.

   if !lExistTable( cPatEmp + "TikeT.Dbf" )  .or.;
      !lExistTable( cPatEmp + "TikeL.Dbf" )  .or.;
      !lExistTable( cPatEmp + "TikeP.Dbf" )
      mkTpv()
   end if

   USE ( cPatEmp + "TIKET.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIKET", @dbfTikT ) )
   SET ADSINDEX TO ( cPatEmp + "TIKET.CDX" ) ADDITIVE

   USE ( cPatEmp + "TIKEL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIKEL", @dbfTikL ) )
   SET ADSINDEX TO ( cPatEmp + "TIKEL.CDX" ) ADDITIVE

   USE ( cPatEmp + "TIKEP.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIKEP", @dbfTikP ) )
   SET ADSINDEX TO ( cPatEmp + "TIKEP.CDX" ) ADDITIVE

   USE ( cPatCli() + "CLIENT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CLIENT", @dbfClient ) )
   SET ADSINDEX TO ( cPatCli() + "CLIENT.CDX" ) ADDITIVE

   USE ( cPatDat() + "Cajas.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CAJAS", @dbfCajT ) )
   SET ADSINDEX TO ( cPatDat() + "Cajas.Cdx" ) ADDITIVE

   USE ( cPatDat() + "USERS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "USERS", @dbfUsr ) )
   SET ADSINDEX TO ( cPatDat() + "USERS.CDX" ) ADDITIVE

   USE ( cPatArt() + "ARTICULO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ARTICULO", @dbfArticulo ) )
   SET ADSINDEX TO ( cPatArt() + "ARTICULO.CDX" ) ADDITIVE

   USE ( cPatArt() + "ArtCodebar.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CODEBAR", @dbfCodebar ) )
   SET ADSINDEX TO ( cPatArt() + "ArtCodebar.Cdx" ) ADDITIVE

   USE ( cPatArt() + "ARTKIT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ARTTIK", @dbfKit ) )
   SET ADSINDEX TO ( cPatArt() + "ARTKIT.CDX" ) ADDITIVE

   USE ( cPatArt() + "OFERTA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "OFERTA", @dbfOferta ) )
   SET ADSINDEX TO ( cPatArt() + "OFERTA.CDX" ) ADDITIVE

   USE ( cPatGrp() + "FPAGO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FPAGO", @dbfFPago ) )
   ( dbfFPago )->( ordListAdd( cPatGrp() + "FPago.Cdx" ) )

   USE ( cPatArt() + "TBLPRO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TBLPRO", @dbfTblPro ) )
   SET ADSINDEX TO ( cPatArt() + "TBLPRO.CDX" ) ADDITIVE

   USE ( cPatArt() + "FAMILIAS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FAMILIAS", @dbfFamilia ) )
   SET ADSINDEX TO ( cPatArt() + "FAMILIAS.CDX" ) ADDITIVE

   USE ( cPatEmp + "ALBCLIT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALBCLIT", @dbfAlbCliT ) )
   SET ADSINDEX TO ( cPatEmp + "ALBCLIT.CDX" ) ADDITIVE

   USE ( cPatEmp + "ALBCLIL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALBCLIL", @dbfAlbCliL ) )
   SET ADSINDEX TO ( cPatEmp + "ALBCLIL.CDX" ) ADDITIVE

   USE ( cPatEmp + "FACCLIT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACCLIT", @dbfFacCliT ) )
   SET ADSINDEX TO ( cPatEmp + "FACCLIT.CDX" ) ADDITIVE

   USE ( cPatEmp + "FACCLIL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACCLIL", @dbfFacCliL ) )
   SET ADSINDEX TO ( cPatEmp + "FACCLIL.CDX" ) ADDITIVE

   USE ( cPatEmp + "FACCLIP.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACCLIP", @dbfFacCliP ) )
   SET ADSINDEX TO ( cPatEmp + "FACCLIP.CDX" ) ADDITIVE

   USE ( cPatEmp + "AntCliT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "AntCliT", @dbfAntCliT ) )
   SET ADSINDEX TO ( cPatEmp + "AntCliT.CDX" ) ADDITIVE

   USE ( cPatCli() + "ObrasT.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "OBRAST", @dbfObrasT ) )
   SET ADSINDEX TO ( cPatCli() + "ObrasT.Cdx" ) ADDITIVE

   USE ( cPatGrp() + "AGENTES.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "AGENTES", @dbfAgent ) )
   SET ADSINDEX TO ( cPatGrp() + "AGENTES.CDX" ) ADDITIVE

   USE ( cPatCli() + "RUTA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "RUTA", @dbfRuta ) )
   SET ADSINDEX TO ( cPatCli() + "RUTA.CDX" ) ADDITIVE

   USE ( cPatGrp() + "ALMACEN.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALMACEN", @dbfAlm ) )
   SET ADSINDEX TO ( cPatGrp() + "ALMACEN.CDX" ) ADDITIVE

   USE ( cPatArt() + "ARTDIV.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ARTDIV", @dbfArtDiv ) )
   SET ADSINDEX TO ( cPatArt() + "ARTDIV.CDX" ) ADDITIVE

   USE ( cPatArt() + "TARPREL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TARPREL", @dbfTarPreL ) )
   SET ADSINDEX TO ( cPatArt() + "TARPREL.CDX" ) ADDITIVE

   USE ( cPatArt() + "TARPRES.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TARPRES", @dbfTarPreS ) )
   SET ADSINDEX TO ( cPatArt() + "TARPRES.CDX" ) ADDITIVE

   USE ( cPatEmp + "RDOCUMEN.DBF" ) NEW SHARED VIA ( cDriver() ) ALIAS ( cCheckArea( "RDOCUMEN", @dbfDoc ) )
   SET ADSINDEX TO ( cPatEmp + "RDOCUMEN.CDX" ) ADDITIVE
   SET TAG TO "CTIPO"

   USE ( cPatCli() + "CliAtp.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CLIATP", @dbfCliAtp ) )
   SET ADSINDEX TO ( cPatCli() + "CliAtp.Cdx" ) ADDITIVE

   USE ( cPatEmp + "NCOUNT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "NCOUNT", @dbfCount ) )
   SET ADSINDEX TO ( cPatEmp + "NCOUNT.CDX" ) ADDITIVE

   USE ( cPatDat() + "TIVA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIVA", @dbfIva ) )
   SET ADSINDEX TO ( cPatDat() + "TIVA.CDX" ) ADDITIVE

   USE ( cPatDat() + "DIVISAS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "DIVISAS", @dbfDiv ) )
   SET ADSINDEX TO ( cPatDat() + "DIVISAS.CDX" ) ADDITIVE

   USE ( cPatDat() + "CAJPORTA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CAJPORTA", @dbfCajPorta ) )
   SET ADSINDEX TO ( cPatDat() + "CAJPORTA.CDX" ) ADDITIVE

   USE ( cPatGrp() + "AGECOM.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "AGECOM", @dbfAgeCom ) )
   SET ADSINDEX TO ( cPatGrp() + "AGECOM.CDX" ) ADDITIVE

   USE ( cPatDat() + "EMPRESA.DBF" ) NEW SHARED VIA ( cDriver() ) ALIAS ( cCheckArea( "EMPRESA", @dbfEmp ) )
   SET ADSINDEX TO ( cPatDat() + "EMPRESA.CDX" ) ADDITIVE

   USE ( cPatEmp() + "ALBCLIP.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALBCLIP", @dbfAlbCliP ) )
   SET ADSINDEX TO ( cPatEmp() + "ALBCLIP.CDX" ) ADDITIVE

   USE ( cPatDat() + "TBLCNV.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TBLCNV", @dbfTblCnv ) )
   SET ADSINDEX TO ( cPatDat() + "TBLCNV.CDX" ) ADDITIVE

   if !TDataCenter():OpenPedCliT( @dbfPedCliT )
      lOpenFiles        := .f.
   end if 

   USE ( cPatEmp() + "PEDCLIL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PEDCLIL", @dbfPedCliL ) )
   SET ADSINDEX TO ( cPatEmp() + "PEDCLIL.CDX" ) ADDITIVE

   oCaptura             := TCaptura():New( cPatDat() )
   oCaptura:OpenFiles()

   oBandera             := TBandera():New()

   oStock               := TStock():Create( cPatGrp() )
   if !oStock:lOpenFiles()
      lOpenFiles        := .f.
   else
      oStock:cAlbCliT   := dbfAlbCliT
      oStock:cAlbCliL   := dbfAlbCliL
      oStock:cFacCliT   := dbfFacCliT
      oStock:cFacCliL   := dbfFacCliL
      oStock:cTikT      := dbfTikT
      oStock:cTikL      := dbfTikL
      oStock:cKit       := dbfKit
   end if

   oNewImp              := TNewImp():New( cPatEmp )
   if !oNewImp:OpenFiles()
      lOpenFiles        := .f.
   end if

   cVisor               := cVisorEnCaja( oUser():cCaja(), dbfCajT )
   if !Empty( cVisor )
      oVisor            := TVisor():Create( cVisor )
      if !Empty( oVisor )
         oVisor:Wellcome()
      end if
   end if

   cCajon               := cCajonEnCaja( oUser():cCaja(), dbfCajT )
   if !Empty( cCajon )
      oCajon            := TCajon():Create( cCajon )
   end if

   cImpresora           := cImpresoraTicketEnCaja( oUser():cCaja(), dbfCajT )
   if !Empty( cImpresora )
      oImpresora        := TImpresoraTiket():Create( cImpresora )
   end if

   oUndMedicion         := UniMedicion():Create( cPatGrp() )
   if !oUndMedicion:OpenFiles()
      lOpenFiles        := .f.
   end if

   oSalaVentas          := TSalaVenta():New( cPatEmp )
   if !oSalaVentas:OpenFiles()
      lOpenFiles        := .f.
   else
      oSalaVentas:cTikT := dbfTikT
      oSalaVentas:cTikL := dbfTikL
      oSalaVentas:cDiv  := dbfDiv
      oSalaVentas:BuildSala()
   end if

   cBalanza             := cBalanzaEnCaja( oUser():cCaja(), dbfCajT )
   if !Empty( cBalanza )
      oBalanza          := TCommPort():Create( cBalanza )
   end if

   oInvitacion          := TInvitacion():Create( cPatGrp() )
   if !oInvitacion:OpenFiles()
      lOpenFiles        := .f.
   end if

   /*
   Creamos los botones para las formas de pago---------------------------------
   */

    aButtonsPago        := aCreateButtons( dbfFPago )

   /*
   Pictures--------------------------------------------------------------------
   */

   cPouDiv              := cPouDiv( cDivEmp(), dbfDiv )        // Picture de la divisa
   cPorDiv              := cPorDiv( cDivEmp(), dbfDiv )        // Picture de la divisa redondeada
   cPicEur              := cPorDiv( cDivChg(), dbfDiv )        // Picture de la divisa equivalente
   nDouDiv              := nDouDiv( cDivEmp(), dbfDiv )        // .Decimales
   nDorDiv              := nRouDiv( cDivEmp(), dbfDiv )        // Decimales redondeados

   cPicUnd              := MasUnd()

   aDbfBmp              := {  LoadBitmap( GetResources(), "bGreen"   ),;
                              LoadBitmap( GetResources(), "bYelow"   ),;
                              LoadBitmap( GetResources(), "bRed"     ),;
                              LoadBitmap( GetResources(), "bmpLock"  ),;
                              LoadBitmap( GetResources(), "Send16"   ),;
                              LoadBitmap( GetResources(), "Oferta"   ),;
                              LoadBitmap( GetResources(), "bConta"   ),;
                              LoadBitmap( GetResources(), "GrpPrv_16"),;
                              LoadBitmap( GetResources(), "Note_Pinned_16" ),;
                              LoadBitmap( GetResources(), "Sel16" ) }

   public nTotTik       := 0
   public nTotPax       := 0
   public nTotNet       := 0
   public nTotIva       := 0
   public nTotIvm       := 0
   public aBasTik       := { 0, 0, 0 }
   public aImpTik       := { 0, 0, 0 }
   public aIvaTik       := { nil, nil, nil }
   public aIvmTik       := { 0, 0, 0 }

   RECOVER USING oError

      lOpenFiles        := .f.

      msgStop( ErrorMessage( oError ), "Imposible abrir las bases de datos de terminal punto de venta" )

   END SEQUENCE

   ErrorBlock( oBlock )

   if !lOpenFiles
      CloseFiles()
   end if

RETURN ( lOpenFiles )

//----------------------------------------------------------------------------//

STATIC FUNCTION CloseFiles()

   if aDbfBmp != nil
      aEval( aDbfBmp, { | hBmp | DeleteObject( hBmp ) } )
   end if

   CLOSE ( dbfTikT     )
   CLOSE ( dbfTikL     )
   CLOSE ( dbfTikP     )
   CLOSE ( dbfClient   )
   CLOSE ( dbfCajT     )
   CLOSE ( dbfUsr      )
   CLOSE ( dbfFPago    )
	CLOSE ( dbfArticulo )
   CLOSE ( dbfCodebar  )
   CLOSE ( dbfKit      )
   CLOSE ( dbfCount    )
   CLOSE ( dbfIva      )
   CLOSE ( dbfOferta   )
   CLOSE ( dbfDiv      )
   CLOSE ( dbfTblPro   )
   CLOSE ( dbfFamilia  )
   CLOSE ( dbfAlbCliT  )
   CLOSE ( dbfAlbCliL  )
   CLOSE ( dbfFacCliT  )
   CLOSE ( dbfFacCliL  )
   CLOSE ( dbfFacCliP  )
   CLOSE ( dbfAntCliT  )
   CLOSE ( dbfObrasT   )
   CLOSE ( dbfAgent    )
   CLOSE ( dbfTarPreL  )
   CLOSE ( dbfTarPreS  )
   CLOSE ( dbfRuta     )
   CLOSE ( dbfAlm      )
   CLOSE ( dbfArtDiv   )
   CLOSE ( dbfDoc      )
   CLOSE ( dbfCliAtp   )
   CLOSE ( dbfCajPorta )
   CLOSE ( dbfAgeCom   )
   CLOSE ( dbfEmp      )
   CLOSE ( dbfAlbCliP  )
   CLOSE ( dbfTblCnv   )
   CLOSE ( dbfPedCliT  )
   CLOSE ( dbfPedCliL  )

   if !Empty( oCaptura )
      oCaptura:End()
   end if

   if !Empty( oStock )
      oStock:end()
   end if

   if !Empty( oNewImp )
      oNewImp:End()
   end if

   if !Empty( oVisor )
      oVisor:End()
   end if

   if !Empty( oCajon )
      oCajon:End()
   end if

   if !Empty( oImpresora )
      oImpresora:End()
   end if

   if !Empty( oBalanza )
      oBalanza:End()
   end if

   if !Empty( oUndMedicion )
      oUndMedicion:end()
   end if

   if !Empty( oSalaVentas )
      oSalaVentas:End()
   end if

   if !Empty( oInvitacion )
      oInvitacion:End()
   end if

   dbfTikT     := nil
   dbfTikL     := nil
   dbfClient   := nil
   dbfCajT     := nil
   dbfUsr      := nil
   dbfFPago    := nil
   dbfArticulo := nil
   dbfCodebar  := nil
   dbfKit      := nil
   dbfIva      := nil
   dbfCount    := nil
   dbfOferta   := nil
   dbfDiv      := nil
   oBandera    := nil
   dbfTarPreS  := nil
   dbfTarPreL  := nil
   dbfTblPro   := nil
   dbfFamilia  := nil
   dbfAlbCliT  := nil
   dbfAlbCliL  := nil
   dbfFacCliT  := nil
   dbfFacCliL  := nil
   dbfFacCliP  := nil
   dbfObrasT   := nil
   dbfAgent    := nil
   dbfRuta     := nil
   dbfAlm      := nil
   dbfArtDiv   := nil
   dbfDoc      := nil
   dbfCliAtp   := nil
   dbfAgeCom   := nil
   dbfEmp      := nil
   dbfAlbCliP  := nil
   dbfTblCnv   := nil

   oStock      := nil
   oCaptura    := nil
   oNewImp     := nil
   oVisor      := nil
   oCajon      := nil
   oImpresora  := nil
   oSalaVentas := nil
   oInvitacion := nil

   oWndBrw     := nil
   oWndBig     := nil

   lOpenFiles  := .f.

   if lTactilMode()
      PostQuitMessage()
   end if

Return .t.

//----------------------------------------------------------------------------//

FUNCTION FrontTpv( oMenuItem, oWnd, cCodCli, cCodArt, lEntCon )

   local nLevel
   local oBtnEur
   local cTitle
   local oSnd
   local oRpl
   local oFlt
   local lEur           := .f.
   local oPrv
   local oImp
   local oDel
   local oRotor

   DEFAULT  oMenuItem   := _MENUITEM_
   DEFAULT  oWnd        := oWnd()
   DEFAULT  lEntCon     := lEntCon()

   nLevel               := nLevelUsr( oMenuItem )
   if nAnd( nLevel, 1 ) != 0
      msgStop( "Acceso no permitido." )
      return .f.
   end if

   /*
   Cerramos todas las ventanas
   */

   if oWnd != nil
      SysRefresh(); oWnd:CloseAll(); SysRefresh()
   end if

   if !OpenFiles()
      return .f.
   end if

   /*
   Compruebo si hay turnos abiertos
   */

   cTitle      := "T.P.V. - Sesión : " + Trans( cCurSesion(), "######" ) + " - " + dtoc( date() )

   /*
   Anotamos el movimiento para el navegador
   */

   AddMnuNext( "T.P.V.", ProcName() )

   /*
   Limitaciones de cajero y cajas

   if !oUser():lAdministrador()
      ( dbfTikT )->( dbSetFilter( {|| Field->cCcjTik == oUser():cCodigo() .and. Field->cNcjTik == oUser():cCaja() }, "Field->cCcjTik == oUser():cCodigo() .and. Field->cNcjTik == oUser():cCaja()" ) )
   end if
   */

   DEFINE SHELL oWndBrw FROM 0, 0 TO 22, 80 ;
      XBROWSE ;
      TITLE    cTitle ;
      PROMPTS  "Número",;
					"Fecha",;
               "Caja",;
               "Cajero",;
               "Código",;
               "Nombre",;
               "Matrícula",;
               "Sesión" ;
      MRU      "Cashier_user1_16";
      BITMAP   clrTopArchivos ;
      ALIAS    ( dbfTikT );
      APPEND   ( TpvAppRec( oWndBrw:oBrw, bEditT, dbfTikT, oWnd, cCodCli, cCodArt ) );
      DELETE   ( DelTpv( oWndBrw:oBrw, dbfTikT ) );//TpvDelRec( oWndBrw:oBrw ) ) ;
      ZOOM     ( WinZooRec( oWndBrw:oBrw, bEditT, dbfTikT ) );
      EDIT     ( WinEdtRec( oWndBrw:oBrw, bEditT, dbfTikT ) );
      LEVEL    nLevel ;
      OF       oWnd

      oWndBrw:lAutoSeek := .f.

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Cr. Sesión cerrada"
         :bStrData         := {|| "" }
         :bEditValue       := {|| ( dbfTikT )->lCloTik }
         :nWidth           := 20
         :SetCheck( { "Cnt16", "Nil16" } )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Co. Cobrado"
         :bStrData         := {|| "" }
         :bBmpData         := {|| nChkalizer( ( dbfTikT)->cSerTik + ( dbfTikT )->cNumTik + ( dbfTikT )->cSufTik, dbfTikT, dbfTikL, dbfTikP, dbfFacCliT, dbfFacCliL, dbfFacCliP, dbfIva, dbfDiv, if( lEur, cDivChg(), cDivEmp() ) ) }
         :nWidth           := 20
         :AddResource( "Bullet_Square_Green_16" )
         :AddResource( "Bullet_Square_Yellow_16" )
         :AddResource( "Bullet_Square_Red_16" )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Cn. Contabilizado"
         :bStrData         := {|| "" }
         :bEditValue       := {|| ( dbfTikT )->lConTik }
         :nWidth           := 20
         :SetCheck( { "Sel16", "Nil16" } )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Ev. Envio"
         :bStrData         := {|| "" }
         :bEditValue       := {|| ( dbfTikT )->lSndDoc }
         :nWidth           := 20
         :SetCheck( { "Lbl16", "Nil16" } )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Documento"
         :bEditValue       := {|| aTipTik( ( dbfTikT )->cSerTik + ( dbfTikT )->cNumTik + ( dbfTikT )->cSufTik, dbfTikT ) }
         :nWidth           := 60
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Número"
         :cSortOrder       := "nNumTik"
         :bEditValue       := {|| ( dbfTikT )->cSerTik + "/" + lTrim( ( dbfTikT )->cNumTik ) + "/" + ( dbfTikT )->cSufTik }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Delegación"
         :bEditValue       := {|| ( dbfTikT )->cCodDlg }
         :nWidth           := 40
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Sesión"
         :bEditValue       := {|| Trans( ( dbfTikT )->cTurTik, "######" ) }
         :nWidth           := 40
         :lHide            := .t.
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Fecha"
         :cSortOrder       := "dFecTik"
         :bEditValue       := {|| dtoc( ( dbfTikT )->dFecTik ) }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Hora"
         :bEditValue       := {|| ( dbfTikT )->cHorTik }
         :nWidth           := 40
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Caja"
         :bEditValue       := {|| ( dbfTikT )->cNcjTik }
         :nWidth           := 40
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Cajero"
         :bEditValue       := {|| ( dbfTikT )->cCcjTik }
         :nWidth           := 40
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Código"
         :cSortOrder       := "cCodCli"
         :bEditValue       := {|| AllTrim( ( dbfTikT )->cCliTik ) }
         :nWidth           := 70
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Nombre"
         :cSortOrder       := "cNomCli"
         :bEditValue       := {|| AllTrim( ( dbfTikT )->cNomTik ) }
         :nWidth           := 180
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Almacén"
         :bEditValue       := {|| ( dbfTikT )->cAlmTik }
         :nWidth           := 60
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Total"
         :bEditValue       := {|| nTotalizer( ( dbfTikT )->cSerTik + ( dbfTikT )->cNumTik + ( dbfTikT )->cSufTik, dbfTikT, dbfTikL, dbfTikP, dbfAlbCliT, dbfAlbCliL, dbfFacCliT, dbfFacCliL, dbfFacCliP, dbfIva, dbfDiv, if( lEur, cDivChg(), cDivEmp() ), .t. ) }
         :nWidth           := 80
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Cobrado"
         :bEditValue       := {|| nCobalizer( ( dbfTikT )->cSerTik + ( dbfTikT )->cNumTik + ( dbfTikT )->cSufTik, dbfTikT, dbfTikL, dbfTikP, dbfAlbCliT, dbfAlbCliL, dbfFacCliT, dbfFacCliL, dbfFacCliP, dbfIva, dbfDiv, if( lEur, cDivChg(), cDivEmp() ), .t. ) }
         :nWidth           := 80
         :lHide            := .t.
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Vales"
         :bEditValue       := {|| nTotValTik( ( dbfTikT )->cSerTik + ( dbfTikT )->cNumTik + ( dbfTikT )->cSufTik, dbfTikT, dbfTikL, dbfDiv, if( lEur, cDivChg(), cDivEmp() ), .t. ) }
         :nWidth           := 80
         :lHide            := .t.
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Anticipos"
         :bEditValue       := {|| nTotAntFacCli( ( dbfTikT )->cNumDoc, dbfAntCliT, dbfIva, dbfDiv, if( lEur, cDivChg(), cDivEmp() ), .t. ) }
         :nWidth           := 80
         :lHide            := .t.
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Diferencias"
         :bEditValue       := {|| nDifalizer( ( dbfTikT )->cSerTik + ( dbfTikT )->cNumTik + ( dbfTikT )->cSufTik, dbfTikT, dbfTikL, dbfTikP, dbfAlbCliT, dbfAlbCliL, dbfFacCliT, dbfFacCliL, dbfFacCliP, dbfAntCliT, dbfIva, dbfDiv, if( lEur, cDivChg(), cDivEmp() ), .t. ) }
         :nWidth           := 80
         :lHide            := .t.
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Div."
         :bEditValue       := {|| cSimDiv( if( lEur, cDivChg(), ( dbfTikT )->cDivTik ), dbfDiv ) }
         :nWidth           := 30
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Documento"
         :bEditValue       := {|| ( dbfTikT )->cNumDoc }
         :nWidth           := 120
         :lHide            := .t.
      end with

   oWndBrw:CreateXFromCode()

   DEFINE BTNSHELL RESOURCE "BUS" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( oWndBrw:SearchSetFocus() ) ;
      TOOLTIP  "(B)uscar" ;
      BEGIN GROUP ;
      HOTKEY   "B"

   oWndBrw:AddSeaBar()

   DEFINE BTNSHELL RESOURCE "NEW" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( oWndBrw:RecAdd() );
      TOOLTIP  "(A)ñadir";
      HOTKEY   "A";
      BEGIN GROUP ;
      LEVEL    ACC_APPD

   DEFINE BTNSHELL RESOURCE "EDIT" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( oWndBrw:RecEdit() );
      TOOLTIP  "(M)odificar";
      HOTKEY   "M";
      LEVEL    ACC_EDIT

   DEFINE BTNSHELL RESOURCE "ZOOM" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( oWndBrw:RecZoom() );
      TOOLTIP  "(Z)oom";
      HOTKEY   "Z";
      LEVEL    ACC_ZOOM

   DEFINE BTNSHELL oDel RESOURCE "DEL" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( oWndBrw:RecDel() );
      MENU     This:Toggle() ;
      TOOLTIP  "(E)liminar";
      HOTKEY   "E";
      LEVEL    ACC_DELE

      /*DEFINE BTNSHELL RESOURCE "DEL" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( DelSerie( oWndBrw ) );
         TOOLTIP  "Series" ;
         FROM     oDel ;
         CLOSED ;
         LEVEL    ACC_DELE*/

      DEFINE BTNSHELL RESOURCE "DEL" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( LqdVale( oWndBrw ) );
         TOOLTIP  "Liquidar vale" ;
         FROM     oDel ;
         CLOSED ;
         LEVEL    ACC_DELE

   DEFINE BTNSHELL oPrv RESOURCE "IMP" GROUP OF oWndBrw ;
      NOBORDER ;
      ACTION   ( ImpTiket( .f. ) ) ;
      TOOLTIP  "(I)mprimir";
      MESSAGE  "Imprimir tiket" ;
      HOTKEY   "I";
      LEVEL    ACC_IMPR

   DEFINE BTNSHELL RESOURCE "SERIE1" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( DlgPrnTicket( oWndBrw:oBrw ) ) ;
      TOOLTIP  "Imp(r)imir series";
      HOTKEY   "R";
      LEVEL    ACC_IMPR

   DEFINE BTNSHELL oImp RESOURCE "PREV1" GROUP OF oWndBrw ;
      NOBORDER ;
      ACTION   ( ImpTiket( .t. ) ) ;
      TOOLTIP  "(P)revisualizar";
      MESSAGE  "Previsualizar tiket" ;
      HOTKEY   "P";
      LEVEL    ACC_IMPR

   DEFINE BTNSHELL RESOURCE "NEW" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( WinDupRec( oWndBrw:oBrw, bEditT, dbfTikT ) );
      TOOLTIP  "Ti(k)et a factura";
      HOTKEY   "K";
      LEVEL    ACC_APPD

   if oUser():lAdministrador()

      DEFINE BTNSHELL RESOURCE "CHGSTATE" OF oWndBrw GROUP;
         NOBORDER ;
         ACTION   ContTpv( dbfTikT, oWndBrw:oBrw );
         TOOLTIP  "Cambiar esta(d)o" ;
         HOTKEY   "D";
         LEVEL    ACC_EDIT

   end if

   DEFINE BTNSHELL RESOURCE "BMPCONTA" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( DlgCntTicket( dbfTikT, dbfTikL, dbfTikP, dbfClient, dbfArticulo, dbfFPago, dbfDiv, oWndBrw ) );
      TOOLTIP  "Co(n)tabilizar" ;
      HOTKEY   "N";
      LEVEL    ACC_EDIT

   DEFINE BTNSHELL oSnd RESOURCE "SEND" OF oWndBrw ;
      NOBORDER ;
      MENU     This:Toggle() ;
      ACTION   lSnd( oWndBrw, dbfTikT ) ;
      TOOLTIP  "En(v)iar" ;
      HOTKEY   "V";
      LEVEL    ACC_EDIT

      DEFINE BTNSHELL RESOURCE "SEND" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( lSelectAll( oWndBrw, dbfTikT, "lSndDoc", .t., .t., .t. ) );
         TOOLTIP  "Todos" ;
         FROM     oSnd ;
         CLOSED ;
         LEVEL    ACC_EDIT

      DEFINE BTNSHELL RESOURCE "SEND" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( lSelectAll( oWndBrw, dbfTikT, "lSndDoc", .f., .t., .t. ) );
         TOOLTIP  "Ninguno" ;
         FROM     oSnd ;
         CLOSED ;
         LEVEL    ACC_EDIT

      DEFINE BTNSHELL RESOURCE "SEND" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( lSelectAll( oWndBrw, dbfTikT, "lSndDoc", .t., .f., .t. ) );
         TOOLTIP  "Abajo" ;
         FROM     oSnd ;
         CLOSED ;
         LEVEL    ACC_EDIT

   DEFINE BTNSHELL RESOURCE "CHGPRE" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( EdtCobTik( oWndBrw ) );
      TOOLTIP  "(C)obros";
      HOTKEY   "C";
      LEVEL    ACC_APPD

   DEFINE BTNSHELL oBtnEur RESOURCE "BAL_EURO" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( lEur := !lEur, oWndBrw:Refresh() ) ;
      TOOLTIP  "M(o)neda";
      HOTKEY   "O";

   if oUser():lAdministrador()

      DEFINE BTNSHELL oRpl RESOURCE "BMPCHG" GROUP OF oWndBrw ;
         NOBORDER ;
         MENU     This:Toggle() ;
         ACTION   ( TDlgFlt():New( aItmTik(), dbfTikT ):ChgFields(), oWndBrw:Refresh() ) ;
         TOOLTIP  "Cambiar campos" ;
         LEVEL    ACC_EDIT

         DEFINE BTNSHELL RESOURCE "BMPCHG" OF oWndBrw ;
            NOBORDER ;
            ACTION   ( TDlgFlt():New( aColTik(), dbfTikL ):ChgFields(), oWndBrw:Refresh() ) ;
            TOOLTIP  "Lineas" ;
            FROM     oRpl ;
            CLOSED ;
            LEVEL    ACC_EDIT

   end if

   DEFINE BTNSHELL oRotor RESOURCE "ROTOR" GROUP OF oWndBrw ;
      NOBORDER ;
      MENU     This:Toggle() ;
      ACTION   ( oRotor:Expand() ) ;
      TOOLTIP  "Rotor" ;

      DEFINE BTNSHELL RESOURCE "DOCUMENT" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( Tik2AlbFac( ( dbfTikT )->cTipTik, ( dbfTikT )->cNumDoc ) );
         TOOLTIP  "Visualizar documento" ;
         FROM     oRotor ;
         CLOSED ;

      DEFINE BTNSHELL RESOURCE "USER1_" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( EdtCli( ( dbfTikT )->cCliTik ) );
         TOOLTIP  "Modificar cliente" ;
         FROM     oRotor ;
         CLOSED ;

      DEFINE BTNSHELL RESOURCE "INFO" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( InfCliente( ( dbfTikT )->cCliTik ) );
         TOOLTIP  "Informe cliente" ;
         FROM     oRotor ;
         CLOSED ;

      DEFINE BTNSHELL RESOURCE "WORKER" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( EdtObras( ( dbfTikT )->cCliTik, ( dbfTikT )->cCodObr, dbfObrasT ) );
         TOOLTIP  "Modificar obras" ;
         FROM     oRotor ;
         CLOSED ;

      DEFINE BTNSHELL RESOURCE "DOCUMENT_USER1_" OF oWndBrw ;
         ALLOW    EXIT ;
         ACTION   ( lFacturaAlbaran() ) ;
         TOOLTIP  "Generar factura" ;
         FROM     oRotor ;

   DEFINE BTNSHELL RESOURCE "END" GROUP OF oWndBrw ;
      NOBORDER ;
      ACTION   ( oWndBrw:end() ) ;
      TOOLTIP  "(S)alir";
      HOTKEY   "S"

   ACTIVATE SHELL oWndBrw VALID ( CloseFiles() )

   if !Empty( cCodCli ) .or. !Empty( cCodArt ) .or. lEntCon
      oWndBrw:RecAdd()
      cCodCli  := nil
      cCodArt  := nil
   end if

Return .t.

//----------------------------------------------------------------------------//

Static Function TpvAppRec( oWndBrw, bEditT, dbfTikT, oWnd, cCodCli, cCodArt )

   while ( WinAppRec( oWndBrw, bEditT, dbfTikT, cCodCli, cCodArt, oWnd ) )
   end while

   ( dbfTikT )->( dbGoBottom() )

   oWndBrw:Select( 0 )
   oWndBrw:Select( 1 )

Return ( .t. )

//----------------------------------------------------------------------------//

Static Function TpvEdtRec( oWndBrw, bEditT, dbfTikT, oWnd )

   WinEdtRec( oWndBrw, bEditT, dbfTikT, , , oWnd )

   oWndBrw:Select( 0 )
   oWndBrw:Select( 1 )

Return ( .t. )

//----------------------------------------------------------------------------//
//
// Borra tickets
//
FUNCTION DelTpv( oBrw, dbfTikCliT, lMessage )

   DEFAULT lMessage     := .t.

   if ( dbfTikCliT )->lCloTik .and. !oUser():lAdministrador()
      if lMessage
         msgStop( "No se pueden eliminar tickets cerrados." )
      end if
      return .t.
   end if

   WinDelRec( oBrw, dbfTikCliT, TpvDelRec() )

Return ( .t. )

//---------------------------------------------------------------------------//

FUNCTION TpvDelRec()

   local cCodAlm
   local nRecAnt
   local nOrdAnt
   local cCodCli     := ( dbfTikT )->cCliTik
   local cNumTik     := ( dbfTikT )->cSerTik + ( dbfTikT )->cNumTik + ( dbfTikT )->cSufTik
   local cTipDoc     := ( dbfTikT )->cTipTik
   local cNumDoc     := ( dbfTikT )->cNumDoc
   local nTotTik     := nTotTik( cNumTik, dbfTikT, dbfTikL, dbfDiv, nil, nil, .f. )

   /*
   Si el tiket no esta cerrado-------------------------------------------------
   */

   /*if ( dbfTikT )->lCloTik .and. !oUser():lAdministrador()
      if lMessage
         msgStop( "No se pueden eliminar tickets cerrados." )
      end if
      return .t.
   end if*/

   /*
   Eliminar los registros------------------------------------------------------
   */

   //if !lQuestion .or. oUser():lNotConfirmDelete() .or. ApoloMsgNoYes("¿Desea eliminar definitivamente este registro?", "Confirme supersión" )

      //CursorWait()

      //DelRecno( dbfTikT )

      //oStock:TpvCli( cNumTik, ( dbfTikT )->cAlmTik, .t., cTipDoc == SAVVAL .or. cTipDoc == SAVDEV )

      /*
      Eliminamos las lineas----------------------------------------------------
      */

      while ( dbfTikL )->( dbSeek( cNumTik ) )
         if dbLock( dbfTikL )
            ( dbfTikL )->( dbDelete() )
            ( dbfTikL )->( dbUnLock() )
         end if
      end while

      /*
      Borramos los pagos-------------------------------------------------------
      */

      while ( dbfTikP )->( dbSeek( cNumTik ) )
         // AddRiesgo( nTotUCobTik( dbfTikP ), cCodCli, dbfClient )
         if dbLock( dbfTikP )
            ( dbfTikP )->( dbDelete() )
            ( dbfTikP )->( dbUnLock() )
         end if
      end while

      /*
      Eliminamos los vales-----------------------------------------------------
      */

      nRecAnt     := ( dbfTikT )->( Recno() )
      nOrdAnt     := ( dbfTikT )->( OrdSetFocus( "cDocVal" ) )

      if ( dbfTikT )->( dbSeek( cNumTik ) )
         while ( dbfTikT )->cValDoc == cNumTik .and. !( dbfTikT )->( eof() )
            if dbLock( dbfTikT )
               ( dbfTikT )->lLiqTik := .f.
               ( dbfTikT )->lSndDoc := .t.
               ( dbfTikT )->cTurVal := ""
               ( dbfTikT )->cValDoc := ""
               ( dbfTikT )->( dbUnLock() )
            end if
            ( dbfTikT )->( dbSkip() )
         end while
      end if

      /*
      Reposicionamiento--------------------------------------------------------
      */

      ( dbfTikT )->( dbGoTo( nRecAnt ) )
      ( dbfTikT )->( OrdSetFocus( nOrdAnt ) )

      /*
      Borramos el doc. asociados-----------------------------------------------
      */

      if !Empty( cNumDoc )

         /*
         Localizamos el documento segun su tipo
         */

         do case
         case cTipDoc == SAVALB

            if ( dbfAlbCliT )->( dbSeek( cNumDoc ) )

               cCodAlm  := ( dbfAlbCliT )->cCodAlm
               cNumDoc  := ( dbfAlbCliT )->cSerAlb + Str( ( dbfAlbCliT )->nNumAlb ) + ( dbfAlbCliT )->cSufAlb

               /*
               Eliminamos el albaran-------------------------------------------
               */

               //oStock:AlbCli( cNumDoc, cCodAlm, .t., .t., .t. )
               delRecno( dbfAlbCliT )

            end if

         case cTipDoc == SAVFAC

            if ( dbfFacCliT )->( dbSeek( cNumDoc ) )

               cCodAlm  := ( dbfFacCliT )->cCodAlm
               cNumDoc  := ( dbfFacCliT )->cSerie + Str( ( dbfFacCliT )->nNumFac ) + ( dbfFacCliT )->cSufFac

               /*
               Eliminamos la factura
               */

               delRecno( dbfFacCliT )
               //oStock:FacCli( cNumDoc, cCodAlm, .t., .t., nil, .t. )

               /*
               Eliminamos los recibos
               */

               while ( dbfFacCliP )->( dbSeek( cNumDoc ) ) .and. !( dbfFacCliP )->( eof() )

                  if dbLock( dbfFacCliP )
                     ( dbfFacCliP )->( dbDelete() )
                     ( dbfFacCliP )->( dbUnLock() )
                  end if

                  ( dbfFacCliP )->( dbSkip() )
               end do

               /*
               Devolvemos los anticipos a su estado anterior-------------------------
               */

               nOrdAnt     := ( dbfAntCliT )->( OrdSetFocus( "cNumDoc" ) )

               if ( dbfAntCliT )->( dbSeek( cNumDoc ) )
                  while ( dbfAntCliT )->cNumDoc == cNumDoc .and. !( dbfAntCliT )->( eof() )
                     if dbLock( dbfAntCliT )
                        ( dbfAntCliT )->lLiquidada := .f.
                        ( dbfAntCliT )->( dbUnLock() )
                     end if

                     ( dbfAntCliT )->( dbSkip() )
                  end while
               end if

               ( dbfAntCliT )->( OrdSetFocus( nOrdAnt ) )

            end if

         end case

      end if

      //CursorWe()

   //end if

   //oBrw:SetFocus()

RETURN .t.

//----------------------------------------------------------------------------//

STATIC FUNCTION EdtRec( aTmp, aGet, dbfTikT, oBrw, cCodCli, cCodArt, nMode )

   local nOrd
   local oBmpDiv
   local cTitDoc
   local nRieCli           := 0

   aGetTxt                 := Array( 10 )
   oGetTxt                 := Array( 10 )

   lCopTik                 := .t.
   nCopTik                 := nCopiasTicketsEnCaja( oUser():cCaja(), dbfCajT )

   if ( nMode == APPD_MODE .or. nMode == DUPL_MODE ) .and. !lCurSesion()
      MsgStop( "No hay sesiones activas, imposible añadir documentos" )
      return .f.
   end if

   if nMode == APPD_MODE .and. !Empty( cCodCli )
      aTmp[ _CCLITIK ]     := cCodCli
   end if

   if nMode == APPD_MODE
      if !uFieldEmpresa( "lGetFpg" )
         aTmp[ _CFPGTIK ]  := cDefFpg()
      else
         aTmp[ _CFPGTIK ]  := Space( 2 )
      end if
   end if

   if nMode == DUPL_MODE
      cTitDoc              := "Ticket a factura"
   else
      cTitDoc              := LblTitle( nMode ) + aTipDoc[ Max( Val( aTmp[ _CTIPTIK ] ), 1 ) ] + " a clientes"
   end if

   /*
   Tiket ya utilizado----------------------------------------------------------
   */

   if aTmp[ _LCLOTIK ] .and. nMode == EDIT_MODE .and. !oUser():lAdministrador()
      msgStop( 'Solo pueden modificar los tikets cerrados los administradores.' )
      return .f.
   end if

   /*
   Tiket a factura----------------------------------------------------------
   */

   if aTmp[ _CTIPTIK ] != SAVTIK .and. nMode == DUPL_MODE
      msgStop( 'Solo se puede pasar a factura los tickets.' )
      return .f.
   end if

   if aTmp[ _LCNVTIK ] .and. nMode == DUPL_MODE
      MsgStop( 'Este ticket ya ha sido convertido a factura.' )
      return .f.
   end if

   /*
   Comprobamos que la caja este abierta----------------------------------------
   */

   if !lCajaOpen( oUser():cCaja() ) .and. !oUser():lAdministrador()
      msgStop( "Esta caja " + oUser():cCaja() + " esta cerrada." )
      Return .f.
   end if

   /*
   Valores por defecto---------------------------------------------------------
   */

   cCapCaj                 := cCapturaCaja( oUser():cCaja(), dbfCajT )

   /*
   Creamos las fuentes---------------------------------------------------------
   */

   oFntTot                 := TFont():New( FONT_NAME, 14, 54, .f., .t. )
   oFntEur                 := TFont():New( FONT_NAME,  8, 34, .f., .t. )

   /*
   Orden actual----------------------------------------------------------------
   */

   nOrd                 := ( dbfTikT )->( ordSetFocus( 1 ) )

   /*
   Comenzamos las transacciones------------------------------------------------
   */

   if BeginTrans( aTmp, aGet, nMode, .t. )
      Return .f.
   end if

   /*
   Caja de dialogo-------------------------------------------------------------
   */

   DEFINE DIALOG  oDlgTpv RESOURCE "TPVFRONT" TITLE cTitDoc

		/*
		Cliente_________________________________________________________________
		*/

		REDEFINE GET aGet[ _CCLITIK ] VAR aTmp[ _CCLITIK ];
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( loaCli( aGet, aTmp, nMode, oGetTxt[ 9 ] ) );
         PICTURE  "@!" ;
         ID       190 ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwClient( aGet[ _CCLITIK ], aGet[ _CNOMTIK ] ), ::lValid() );
         OF       oDlgTpv

      REDEFINE GET oGetTxt[ 9 ] VAR aGetTxt[ 9 ];
         ID       106 ;
         WHEN     ( .f. );
         OF       oDlgTpv

      REDEFINE GET aGet[ _CNOMTIK ] VAR aTmp[ _CNOMTIK ];
         ID       191 ;
         WHEN     ( nMode != ZOOM_MODE .and. ( !aTmp[ _LMODCLI ] .or. oUser():lAdministrador() ) ) ;
         OF       oDlgTpv

      REDEFINE GET aGet[ _CDNICLI ] VAR aTmp[ _CDNICLI ] ;
         ID       101 ;
         WHEN     ( nMode != ZOOM_MODE .and. ( !aTmp[ _LMODCLI ] .or. oUser():lAdministrador() ) ) ;
         OF       oDlgTpv

      REDEFINE GET aGet[ _CDIRCLI ] VAR aTmp[ _CDIRCLI ] ;
         ID       102 ;
         BITMAP   "Environnment_View_16" ;
         ON HELP  GoogleMaps( aTmp[ _CDIRCLI ], Rtrim( aTmp[ _CPOBCLI ] ) + Space( 1 ) + Rtrim( aTmp[ _CPRVCLI ] ) ) ;
         WHEN     ( nMode != ZOOM_MODE .and. ( !aTmp[ _LMODCLI ] .or. oUser():lAdministrador() ) ) ;
         OF       oDlgTpv

      REDEFINE GET aGet[ _CPOBCLI ] VAR aTmp[ _CPOBCLI ] ;
         ID       104 ;
         WHEN     ( nMode != ZOOM_MODE .and. ( !aTmp[ _LMODCLI ] .or. oUser():lAdministrador() ) ) ;
         OF       oDlgTpv

      REDEFINE GET aGet[ _CPRVCLI ] VAR aTmp[ _CPRVCLI ] ;
         ID       105 ;
         WHEN     ( nMode != ZOOM_MODE .and. ( !aTmp[ _LMODCLI ] .or. oUser():lAdministrador() ) ) ;
         OF       oDlgTpv

      REDEFINE GET aGet[ _CPOSCLI ] VAR aTmp[ _CPOSCLI ] ;
         ID       103 ;
         WHEN     ( nMode != ZOOM_MODE .and. ( !aTmp[ _LMODCLI ] .or. oUser():lAdministrador() ) ) ;
         OF       oDlgTpv

      REDEFINE GET aGet[ _NTARIFA ] VAR aTmp[ _NTARIFA ];
         ID       192 ;
         SPINNER ;
         MIN      1 ;
         MAX      6 ;
         PICTURE  "9" ;
         VALID    ( aTmp[ _NTARIFA ] >= 1 .and. aTmp[ _NTARIFA ] <= 6 ) ;
         WHEN     ( nMode != ZOOM_MODE .and. ( lUsrMaster() .or. oUser():lCambiarPrecio() ) );
         OF       oDlgTpv

      REDEFINE GET oRieCli VAR nRieCli;
         ID       193 ;
         PICTURE  cPorDiv ;
         OF       oDlgTpv

      /*
      Codigo de obra___________________________________________________________
		*/

		REDEFINE GET aGet[_CCODOBR] VAR aTmp[_CCODOBR] ;
         ID       230 ;
         WHEN     ( lObras() .and. nMode != ZOOM_MODE ) ;
         VALID    ( cObras( aGet[ _CCODOBR ], oGetTxt[ 5 ], aTmp[ _CCLITIK ], dbfObrasT ) );
         BITMAP   "LUPA" ;
         ON HELP  ( brwObras( aGet[ _CCODOBR ], oGetTxt[ 5 ], aTmp[ _CCLITIK ], dbfObrasT ) ) ;
         OF       oDlgTpv

      REDEFINE GET oGetTxt[ 5 ] VAR aGetTxt[ 5 ] ;
			WHEN 		.F. ;
         ID       231 ;
         OF       oDlgTpv

      /*
      Codigo de Agente_________________________________________________________
		*/

      REDEFINE GET aGet[ _CCODAGE ] VAR aTmp[ _CCODAGE ] ;
         ID       240 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         VALID    ( cAgentes( aGet[ _CCODAGE ], dbfAgent, oGetTxt[ 6 ], aGet[ _NCOMAGE ], dbfAgeCom ) );
         BITMAP   "LUPA" ;
         ON HELP  ( BrwAgentes( aGet[ _CCODAGE ], oGetTxt[ 6 ] ) );
         OF       oDlgTpv

      REDEFINE GET oGetTxt[ 6 ] VAR aGetTxt[ 6  ] ;
         ID       241 ;
			WHEN 		.F.;
         OF       oDlgTpv

		/*
		Almacen__________________________________________________________________
		*/

		REDEFINE GET aGet[ _CALMTIK ] VAR aTmp[ _CALMTIK ];
			WHEN 		( nMode != ZOOM_MODE ) ;
         VALID    ( cAlmacen( aGet[_CALMTIK], dbfAlm, oGetTxt[ 2 ] ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwAlmacen( aGet[_CALMTIK], oGetTxt[ 2 ] ) ) ;
			ID 		170 ;
         OF       oDlgTpv

      REDEFINE GET oGetTxt[ 2 ] VAR aGetTxt[ 2 ] ;
			ID 		171 ;
			WHEN		.F. ;
         OF       oDlgTpv

      /*
      Formas de Pago___________________________________________________________
		*/

      REDEFINE GET aGet[ _CFPGTIK ] VAR aTmp[ _CFPGTIK ];
         ID       180 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    !Empty( aTmp[ _CFPGTIK ] ) .and. cFpago( aGet[ _CFPGTIK ], dbfFPago, oGetTxt[ 3 ] ) ;
			PICTURE	"@!" ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwFPago( aGet[ _CFPGTIK ], oGetTxt[ 3 ] ) ) ;
         OF       oDlgTpv

      REDEFINE GET oGetTxt[ 3 ] VAR aGetTxt[ 3 ] ;
			ID 		181 ;
			WHEN		.F. ;
         OF       oDlgTpv

      /*
		Cajas____________________________________________________________________
		*/

		REDEFINE GET aGet[ _CNCJTIK ] VAR aTmp[ _CNCJTIK ];
			WHEN 		( nMode != ZOOM_MODE ) ;
         VALID    cCajas( aGet[ _CNCJTIK ], dbfCajT, oGetTxt[ 1 ] ) ;
			ID 		160 ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwCajas( aGet[ _CNCJTIK ], oGetTxt[ 1 ] ) ) ;
         OF       oDlgTpv

      REDEFINE GET oGetTxt[ 1 ] VAR aGetTxt[ 1 ] ;
			ID 		161 ;
			WHEN		.F. ;
         OF       oDlgTpv

      /*
      Codigo de Tarifa_________________________________________________________
		*/

      REDEFINE GET aGet[_CCODTAR] VAR aTmp[_CCODTAR] ;
         ID       220 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         VALID    ( cTarifa( aGet[_CCODTAR], oGetTxt[ 8 ] ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwTarifa( aGet[_CCODTAR], oGetTxt[ 8 ] ) ) ;
         OF       oDlgTpv

      REDEFINE GET oGetTxt[ 8 ] VAR aGetTxt[ 8 ] ;
			WHEN 		.F. ;
         ID       221 ;
         OF       oDlgTpv

      REDEFINE GET aGet[_NCOMAGE] VAR aTmp[_NCOMAGE] ;
			WHEN 		( !Empty( aTmp[_CCODAGE] ) .AND. nMode != ZOOM_MODE ) ;
         SPINNER;
         PICTURE  "@E 99.99" ;
         ID       242 ;
         OF       oDlgTpv

      /*
		Ruta____________________________________________________________________
		*/

      REDEFINE GET aGet[ _CCODRUT ] VAR aTmp[ _CCODRUT ] ;
         ID       250 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         VALID    ( cRuta( aGet[ _CCODRUT ], dbfRuta, oGetTxt[ 7 ]) );
         BITMAP   "LUPA" ;
         ON HELP  ( BrwRuta( aGet[_CCODRUT ], dbfRuta, oGetTxt[ 7 ] ) );
         OF       oDlgTpv

      REDEFINE GET oGetTxt[ 7 ] VAR aGetTxt[ 7 ];
         ID       251 ;
			WHEN 		.F. ;
         OF       oDlgTpv
      /*
		Moneda__________________________________________________________________
		*/

		REDEFINE GET aGet[ _CDIVTIK ] VAR aTmp[ _CDIVTIK ];
         WHEN     ( nMode == APPD_MODE .AND. ( dbfTmpL )->( LastRec() ) == 0 ) ;
         VALID    ( cDivOut( aGet[ _CDIVTIK ], oBmpDiv, aGet[ _NVDVTIK ], @cPouDiv, nil, nil, nil, nil, nil, nil, dbfDiv, oBandera ) );
         ON CHANGE( lRecTotal( aTmp ) );
			PICTURE	"@!";
			ID 		200 ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwDiv( aGet[ _CDIVTIK ], oBmpDiv, aGet[ _NVDVTIK ], dbfDiv, oBandera ) ) ;
         OF       oDlgTpv

		REDEFINE BITMAP oBmpDiv ;
         RESOURCE "BAN_EURO" ;
			ID 		201;
         OF       oDlgTpv

		REDEFINE GET aGet[ _NVDVTIK ] VAR aTmp[ _NVDVTIK ];
         WHEN     ( .f. ) ;
			ID 		205 ;
         PICTURE  "@E 999,999.9999" ;
			COLOR 	CLR_GET ;
         OF       oDlgTpv

      REDEFINE CHECKBOX oCopTik VAR lCopTik ;
         ID       260 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlgTpv

      REDEFINE GET nCopTik;
         ID       261 ;
         PICTURE  "99" ;
         SPINNER ;
         MIN      0;
         MAX      99;
         VALID    ( nCopTik >= 0 .AND. nCopTik < 99 ) ;
         WHEN     ( !lCopTik );
         ON CHANGE( oCopTik:Click( .f. ):Refresh() );
			COLOR 	CLR_GET ;
         OF       oDlgTpv

		/*
		Detalle de Articulos____________________________________________________

      oBrwDet                 := TWBrowse():ReDefine( 210, {|| oCaptura:CreateFields( cCapCaj ) }, oDlgTpv, oCaptura:CreateTitles( cCapCaj ), oCaptura:CreateSizes( cCapCaj ), , , , , , , , , , , , .t., ( dbfTmpL ) )

      oBrwDet:lAdjLastCol     := .t.
      oBrwDet:lAdjBrowse      := .t.
      oBrwDet:aJustify        := oCaptura:CreateJustify( cCapCaj )
      oBrwDet:nFreeze         := len( oBrwDet:aColSizes )
      oBrwDet:nClrText        := {|| if( ( dbfTmpL )->lKitChl, CLR_GRAY, CLR_BLACK ) }
      oBrwDet:bChange         := {|| DisImg( ( dbfTmpL )->cCbaTil ) }

      if nMode != ZOOM_MODE .and. nMode != DUPL_MODE
         oBrwDet:bAdd         := {|| AppDetRec( oBrwDet, bEditL, aTmp, cPorDiv, cPicEur ), aGet[ _CCLITIK ]:SetFocus() }
         oBrwDet:bLDblClick   := {|| WinEdtRec( oBrwDet, bEditL, dbfTmpL, , , aTmp ), lRecTotal( aTmp ), aGet[ _CCLITIK ]:SetFocus() }
         oBrwDet:bEdit        := {|| WinEdtRec( oBrwDet, bEditL, dbfTmpL, , , aTmp ), lRecTotal( aTmp ), aGet[ _CCLITIK ]:SetFocus() }
         oBrwDet:bDel         := {|| DelRecno( dbfTmpL, oBrwDet ), lRecTotal( aTmp ) }
      end if
      */

      oBrwDet                 := IXBrowse():New( oDlgTpv )

      oBrwDet:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwDet:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrwDet:bChange         := {|| DisImg( ( dbfTmpL )->cCbaTil ) }
      oBrwDet:bLDblClick      := {|| WinEdtRec( oBrwDet, bEditL, dbfTmpL, , , aTmp ), lRecTotal( aTmp ), aGet[ _CCLITIK ]:SetFocus() }

      oBrwDet:cAlias          := dbfTmpL

      oBrwDet:nMarqueeStyle   := 6
      oBrwDet:cName           := "TPV.Detalle"

      oBrwDet:CreateFromResource( 210 )

      oCaptura:CreateColumns( cCapCaj, oBrwDet )

      REDEFINE SAY oTxtTot ;
         PROMPT   "Total";
         FONT     oFntEur ;
         COLOR    "G+/N";
			ID 		410 ;
         OF       oDlgTpv

      REDEFINE SAY oNumTot ;
         PROMPT   Trans( 0, cPorDiv );
         FONT     oFntEur ;
         COLOR    "G+/N";
			ID 		420 ;
         OF       oDlgTpv

		/*
      Visor de productos_________________________________________________________________________
      */

      REDEFINE BITMAP oBmpVis ;
         ID       600;
         FILE     cFilBmp ;
         OF       oDlgTpv ;
			ADJUST

      /*
      REDEFINE SAY oDesVis VAR cDesVis;
			FONT		oFntEur ;
			ID 		440 ;
			OF 		oDlg

		REDEFINE SAY oTotVis VAR nTotVis;
			FONT		oFntEur ;
			ID 		450 ;
			OF 		oDlg
		*/

      /*
      Barra de porcentaje______________________________________________________
      */

		/*----------------------------------------------------------------------------//
REDEFINE APOLOMETER oMetMsg VAR nMetMsg ;
			ID 		460 ;
			NOPERCENTAGE ;
         OF       oDlgTpv

      /*
      Botones__________________________________________________________________________
      */

		REDEFINE BUTTON ;
			ID 		532 ;
         OF       oDlgTpv ;
         WHEN     ( nMode != ZOOM_MODE .and. nMode != DUPL_MODE ) ;
         ACTION   ( AppDetRec( oBrwDet, bEditL, aTmp, cPorDiv, cPicEur ), aGet[ _CCLITIK ]:SetFocus() )

		REDEFINE BUTTON ;
			ID 		533 ;
         OF       oDlgTpv ;
         WHEN     ( nMode != ZOOM_MODE .and. nMode != DUPL_MODE ) ;
         ACTION   ( WinEdtRec( oBrwDet, bEditL, dbfTmpL, , , aTmp ), lRecTotal( aTmp ), aGet[ _CCLITIK ]:SetFocus() )

		REDEFINE BUTTON ;
			ID 		534 ;
         OF       oDlgTpv ;
         WHEN     ( nMode != ZOOM_MODE .and. nMode != DUPL_MODE ) ;
         ACTION   ( DelRecno( dbfTmpL, oBrwDet ), lRecTotal( aTmp ) )

      REDEFINE BUTTON oBtnTik ;
			ID 		509 ;
         OF       oDlgTpv ;
         WHEN     ( nMode == APPD_MODE ) .or. ( ( aTmp[ _CTIPTIK ] == SAVTIK .or. aTmp[ _CTIPTIK ] == SAVAPT ) .and. ( nMode == EDIT_MODE ) );
         ACTION   ( NewTiket( aGet, aTmp, nMode, SAVTIK, .f. ) )

      REDEFINE BUTTON oBtnAlb ;
         ID       554 ;
         OF       oDlgTpv ;
         WHEN     ( nMode == APPD_MODE ) .or. ( ( aTmp[ _CTIPTIK ] == SAVALB .or. aTmp[ _CTIPTIK ] == SAVAPT ) .and. ( nMode == EDIT_MODE ) );
         ACTION   ( NewTiket( aGet, aTmp, nMode, SAVALB, .f. ) )

      REDEFINE BUTTON oBtnFac ;
         ID       558 ;
         OF       oDlgTpv ;
         WHEN     ( nMode == APPD_MODE .or. nMode == DUPL_MODE ) .or. ( ( aTmp[ _CTIPTIK ] == SAVFAC .or. aTmp[ _CTIPTIK ] == SAVAPT ) .and. ( nMode == EDIT_MODE ) );
         ACTION   ( NewTiket( aGet, aTmp, nMode, SAVFAC, .f. ) )

      REDEFINE BUTTON oBtnApt ;
			ID 		536 ;
         OF       oDlgTpv ;
         WHEN     ( nMode == APPD_MODE ) .or. ( ( aTmp[ _CTIPTIK ] == SAVAPT ) .and. ( nMode == EDIT_MODE ) );
         ACTION   ( NewTiket( aGet, aTmp, nMode, SAVAPT, .f. ) )

      REDEFINE BUTTON ;
         ID       513 ;
         OF       oDlgTpv ;
         WHEN     ( nMode == APPD_MODE ) .or. ( ( aTmp[ _CTIPTIK ] == SAVDEV .or. aTmp[ _CTIPTIK ] == SAVAPT ) .and. ( nMode == EDIT_MODE ) );
         ACTION   ( NewTiket( aGet, aTmp, nMode, SAVDEV, .f. ) )

      REDEFINE BUTTON ;
         ID       514 ;
         OF       oDlgTpv ;
         WHEN     ( nMode == APPD_MODE ) .or. ( ( aTmp[ _CTIPTIK ] == SAVVAL .or. aTmp[ _CTIPTIK ] == SAVAPT ) .and. ( nMode == EDIT_MODE ) );
         ACTION   ( NewTiket( aGet, aTmp, nMode, SAVVAL, .f. ) )

		REDEFINE BUTTON ;
			ID 		510 ;
         OF       oDlgTpv ;
         ACTION   ( oDlgTpv:end() )

      REDEFINE GET aGet[ _CSERTIK ] VAR aTmp[ _CSERTIK ];
			ID 		100 ;
			COLOR 	CLR_GET ;
         PICTURE  "@!" ;
         SPINNER ;
         ON UP    ( UpSerie( aGet[ _CSERTIK ] ) );
         ON DOWN  ( DwSerie( aGet[ _CSERTIK ] ) );
         WHEN     ( nMode == APPD_MODE );
         VALID    ( aTmp[ _CSERTIK ] >= "A" .AND. aTmp[ _CSERTIK ] <= "Z"  );
         OF       oDlgTpv

         aGet[ _CSERTIK ]:bLostFocus := {|| aTmp[ _CCODPRO ] := cProCnt( aTmp[ _CSERTIK ] ) }

		REDEFINE GET aGet[ _CNUMTIK ] VAR aTmp[ _CNUMTIK ];
			ID 		110 ;
			WHEN		.F. ;
			COLOR 	CLR_GET ;
         OF       oDlgTpv

      REDEFINE GET aGet[ _CSUFTIK ] VAR aTmp[ _CSUFTIK ];
         ID       111 ;
			WHEN		.F. ;
			COLOR 	CLR_GET ;
         OF       oDlgTpv

		REDEFINE GET aTmp[ _DFECTIK ];
			ID 		120 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			SPINNER ;
         OF       oDlgTpv

      REDEFINE GET aGet[ _NCOBTIK ] VAR aTmp[ _NCOBTIK ];
         PICTURE  cPorDiv ;
         WHEN     (.f.);
         ID       140 ;
         OF       oDlgTpv

      REDEFINE GET aGet[ _NCAMTIK ] VAR aTmp[ _NCAMTIK ];
         PICTURE  cPorDiv ;
         WHEN     (.f.);
			ID			150 ;
         OF       oDlgTpv

      REDEFINE GET aGet[ _CCCJTIK ] VAR aTmp[ _CCCJTIK ];
         ID       125 ;
         WHEN     ( .f. ) ;
         VALID    ( SetUsuario( aGet[ _CCCJTIK ], oGetTxt[ 10 ], nil, dbfUsr ) );
         OF       oDlgTpv

      REDEFINE GET oGetTxt[ 10 ] VAR aGetTxt[ 10 ] ;
         ID       130 ;
         WHEN     ( .f. ) ;
         OF       oDlgTpv

   do case
      case nMode == APPD_MODE .and. lRecogerUsuario() .and. !Empty( cCodArt )
         oDlgTpv:Cargo  := {|| if( lGetUsuario( aGet[ _CCCJTIK ], dbfUsr ),;
                                 ( AppDetRec( oBrwDet, bEditL, aTmp, cPorDiv, cPicEur, cCodArt ), aGet[ _CCLITIK ]:SetFocus() ),;
                                 ( oDlgTpv:End() ) ) }

      case nMode == APPD_MODE .and. lRecogerUsuario() .and. lEntCon()
         oDlgTpv:Cargo  := {|| if( lGetUsuario( aGet[ _CCCJTIK ], dbfUsr ),;
                                 ( AppDetRec( oBrwDet, bEditL, aTmp, cPorDiv, cPicEur ), aGet[ _CCLITIK ]:SetFocus() ),;
                                 ( oDlgTpv:End() ) ) }

      case nMode == APPD_MODE .and. lRecogerUsuario() .and. !lEntCon()
         oDlgTpv:Cargo  := {|| if( lGetUsuario( aGet[ _CCCJTIK ], dbfUsr ), ( aGet[ _CCLITIK ]:SetFocus() ), ( oDlgTpv:End() ) ) }

      case nMode == APPD_MODE .and. !lRecogerUsuario() .and. lEntCon()
         oDlgTpv:Cargo  := {|| ( AppDetRec( oBrwDet, bEditL, aTmp, cPorDiv, cPicEur ), aGet[ _CCLITIK ]:SetFocus() ) }

      case nMode == APPD_MODE .and. !lRecogerUsuario() .and. !Empty( cCodArt )
         oDlgTpv:Cargo  := {|| ( AppDetRec( oBrwDet, bEditL, aTmp, cPorDiv, cPicEur, cCodArt ), aGet[ _CCLITIK ]:SetFocus() ) }

      otherwise
         oDlgTpv:Cargo  := {|| lRecTotal( aTmp ), aGet[ _CCLITIK ]:lValid() }

   end case

   oDlgTpv:bStart       := oDlgTpv:Cargo

   /*
   Apertura de la caja de dialogo
   */

   if nMode != ZOOM_MODE
      oDlgTpv:AddFastKey( VK_F2, {|| AppDetRec( oBrwDet, bEditL, aTmp, cPorDiv, cPicEur ), aGet[ _CCLITIK ]:SetFocus() } )
      oDlgTpv:AddFastKey( VK_F3, {|| WinEdtRec( oBrwDet, bEditL, dbfTmpL, , , aTmp ), lRecTotal( aTmp ), aGet[ _CCLITIK ]:SetFocus() } )
      oDlgTpv:AddFastKey( VK_F4, {|| DelRecno( dbfTmpL, oBrwDet ), lRecTotal( aTmp ) } )
      oDlgTpv:AddFastKey( VK_F5, {|| if( ( ( nMode == APPD_MODE ) .or. ( ( aTmp[ _CTIPTIK ] == SAVTIK .or. aTmp[ _CTIPTIK ] == SAVAPT ) .and. ( nMode == EDIT_MODE ) ) ), NewTiket( aGet, aTmp, nMode, SAVTIK, .f. ), ) } )
      oDlgTpv:AddFastKey( VK_F7, {|| if( ( ( nMode == APPD_MODE ) .or. ( ( aTmp[ _CTIPTIK ] == SAVALB .or. aTmp[ _CTIPTIK ] == SAVAPT ) .and. ( nMode == EDIT_MODE ) ) ), NewTiket( aGet, aTmp, nMode, SAVALB, .f. ), ) } )
      oDlgTpv:AddFastKey( VK_F8, {|| if( ( ( nMode == APPD_MODE ) .or. ( ( aTmp[ _CTIPTIK ] == SAVFAC .or. aTmp[ _CTIPTIK ] == SAVAPT ) .and. ( nMode == EDIT_MODE ) ) ), NewTiket( aGet, aTmp, nMode, SAVFAC, .f. ), ) } )
      oDlgTpv:AddFastKey( VK_F9, {|| if( ( ( nMode == APPD_MODE ) .or. ( ( aTmp[ _CTIPTIK ] == SAVVAL .or. aTmp[ _CTIPTIK ] == SAVAPT ) .and. ( nMode == EDIT_MODE ) ) ), NewTiket( aGet, aTmp, nMode, SAVAPT, .f. ), ) } )
      oDlgTpv:AddFastKey( VK_F12,{|| if( oCajon != nil, oCajon:Open(), ) } )
      oDlgTpv:AddFastKey( 65,    {|| if( GetKeyState( VK_CONTROL ), CreateInfoArticulo(), ) } )
   end if

   ACTIVATE DIALOG oDlgTpv ;
         ON INIT  ( EdtRecMenu( aTmp, oDlgTpv ), aGet[ _CCLITIK ]:lValid() ) ;
         VALID    ( ExitNoSave( nMode, dbfTmpL ) ) ;
         CENTER

   oMenu:End()

   oFntTot:End()
   oFntEur:End()
   oBmpDiv:End()

   /*
   Salida sin grabar-----------------------------------------------------------
   */

   KillTrans()

   if Select( dbfTikT ) != 0
      ( dbfTikT )->( ordSetFocus( nOrd ) )
   end if

RETURN ( oDlgTpv:nResult == IDOK )

//--------------------------------------------------------------------------//

FUNCTION nTotUTpv( uTmpL, nDec, nVdv, nPrc )

   local nCalculo    := 0

   DEFAULT uTmpL     := dbfTikL
   DEFAULT nDec      := nDouDiv()
   DEFAULT nVdv      := 1
   DEFAULT nPrc      := 0

   if ValType( uTmpL ) == "C"

      if nPrc == 0 .or. nPrc == 1
         nCalculo    += ( uTmpL )->nPvpTil
      end if

      if nPrc == 0 .or. nPrc == 2
         nCalculo    += ( uTmpL )->nPcmTil     // Precio combinado
      end if

      nCalculo       -= ( uTmpL )->nDtoDiv     // Descuentos unitarios

   else

      if nPrc == 0 .or. nPrc == 1
         nCalculo    += uTmpL:nPvpTil
      end if

      if nPrc == 0 .or. nPrc == 2
         nCalculo    += uTmpL:nPcmTil     // Precio combinado
      end if

      nCalculo       -= uTmpL:nDtoDiv     // Descuentos unitarios

   end if

   if nVdv != 0
      nCalculo       := nCalculo / nVdv
   end if

RETURN ( round( nCalculo, nDec ) )

//--------------------------------------------------------------------------//

Function nBasUTpv( uTmpL, nDec, nVdv, nPrc )

   local nCalculo := 0

   DEFAULT uTmpL  := dbfTikL
   DEFAULT nDec   := nDouDiv()
   DEFAULT nVdv   := 1
   DEFAULT nPrc   := 0

   nCalculo       := nTotUTpv( uTmpL, nDec, nVdv, nPrc )

   do case
      case ValType( uTmpL ) == "C"
         nCalculo -= Round( nCalculo / ( 1 + ( uTmpL )->nIvaTil / 100 ), nDec )

      case ValType( uTmpL ) == "O"
         nCalculo -= Round( nCalculo / ( 1 + uTmpL:nIvaTil / 100 ), nDec )

   end case

	IF nVdv != 0
      nCalculo    := nCalculo / nVdv
	END IF

RETURN ( Round( nCalculo, nDec ) )

//---------------------------------------------------------------------------//

FUNCTION nImpUTpv( uTikT, uTikL, nDec, nVdv, cPouDiv, nPrc )

   local nCalculo

   DEFAULT uTikT     := dbfTikT
   DEFAULT uTikL     := dbfTikL
   DEFAULT nDec      := nDouDiv()
   DEFAULT nVdv      := 1
   DEFAULT nPrc      := 0

   nCalculo          := nTotUTpv( uTikL, nDec, nVdv, nPrc )

   do case
      case Valtype( uTikL ) == "C"

         if ( uTikL )->nDtoLin != 0
            nCalculo -= ( uTikL )->nDtoLin * nCalculo / 100  // Dto porcentual
         end if

         if ( uTikL )->nIvaTil != 0
            nCalculo -= Round( nCalculo / ( 100 / ( uTikL )->nIvaTil + 1 ), nDec )
         end if

         if ( uTikT )->cTipTik == SAVDEV
            nCalculo := - nCalculo
         end if

      case Valtype( uTikL ) == "O"

         if uTikL:nDtoLin != 0
            nCalculo -= uTikL:nDtoLin * nCalculo / 100  // Dto porcentual
         end if

         if uTikL:nIvaTil != 0
            nCalculo -= Round( nCalculo / ( 100 / uTikL:nIvaTil + 1 ), nDec )
         end if

         if uTikT:cTipTik == SAVDEV
            nCalculo := - nCalculo
         end if

   end case

RETURN ( if( cPouDiv != nil, Trans( nCalculo, cPouDiv ), nCalculo ) )

//---------------------------------------------------------------------------//

FUNCTION nDtoUTpv( dbfTmpL, nDec, nVdv )

   local nCalculo

   DEFAULT dbfTmpL   := dbfTikL
   DEFAULT nDec      := nDouDiv()
   DEFAULT nVdv      := 1

   nCalculo          := ( dbfTmpL )->nDtoDiv

   if nVdv != 0
      nCalculo       := nCalculo / nVdv
   end if

RETURN ( round( nCalculo, nDec ) )

//---------------------------------------------------------------------------//

function nTotVTikTpv( uDbf, lCombinado )

   local nTotUnd

   DEFAULT uDbf         := dbfTikL
   DEFAULT lCombinado   := .f.

   do case
      case ValType( uDbf ) == "A"

         if !lCombinado
            nTotUnd  := uDbf[ _NUNTTIL ] * NotCero( uDbf[ _NFACCNV ] )
         else
            nTotUnd  := uDbf[ _NUNTTIL ] * NotCero( uDbf[ _NFCMCNV ] )
         end if

      case ValType( uDbf ) == "C"

         if !lCombinado
            nTotUnd  := ( uDbf )->nUntTil * NotCero( ( uDbf )->nFacCnv )
         else
            nTotUnd  := ( uDbf )->nUntTil * NotCero( ( uDbf )->nFcmCnv )
         end if

      otherwise

         if !lCombinado
            nTotUnd  := uDbf:nUntTil * NotCero( uDbf:nFacCnv )
         else
            nTotUnd  := uDbf:nUntTil * NotCero( uDbf:nFcmCnv )
         end if

   end case

return ( nTotUnd )

//---------------------------------------------------------------------------//

Function nIvaLTpv( cTikT, cTikL, nDec, nRou, nVdv, nPrc )

   local nCalculo    := 0

   DEFAULT cTikT     := dbfTikT
   DEFAULT cTikL     := dbfTikL
   DEFAULT nDec      := nDouDiv()
   DEFAULT nRou      := nRouDiv()
   DEFAULT nVdv      := 1
   DEFAULT nPrc      := 0

   do case
      case ValType( cTikL ) == "C"

         if Empty( nPrc ) .or. nPrc == 1
            nCalculo += nTotLUno( cTikL, nDec, nRou, nVdv )
         end if

         if Empty( nPrc ) .or. nPrc == 2
            nCalculo += nTotLDos( cTikL, nDec, nRou, nVdv )
         end if

         if ( cTikL )->nIvaTil != 0
            nCalculo -= Round( nCalculo / ( 1 + ( cTikL )->nIvaTil / 100 ), nRou )
         end if

      case ValType( cTikL ) == "O"

         if Empty( nPrc ) .or. nPrc == 1
            nCalculo += nTotLUno( cTikL:cAlias, nDec, nRou, nVdv )
         end if

         if Empty( nPrc ) .or. nPrc == 2
            nCalculo += nTotLDos( cTikL:cAlias, nDec, nRou, nVdv )
         end if

         if cTikL:nIvaTil != 0
            nCalculo -= Round( nCalculo / ( 1 + ( cTikL:cAlias )->nIvaTil / 100 ), nRou )
         end if

   end case

   do case
      case Valtype( cTikT ) == "C" .and. ( cTikT )->cTipTik == SAVDEV
         nCalculo    := - nCalculo

      case Valtype( cTikT ) == "O" .and. cTikT:cTipTik == SAVDEV
         nCalculo    := - nCalculo

   end case

   if nVdv != 0
      nCalculo       := nCalculo / nVdv
   end if

RETURN ( Round( nCalculo, nRou ) )

//---------------------------------------------------------------------------//

/*
Devuelve el precio linea
*/

FUNCTION nNetLTpv( dbfTmpL, nDec, nRou, nVdv )

   local nCalculo    := 0

   DEFAULT dbfTmpL   := dbfTikL
   DEFAULT nDec      := nDouDiv()
   DEFAULT nRou      := nRouDiv()
   DEFAULT nVdv      := 1

   nCalculo          := nTotLTpv( dbfTmpL, nDec, nRou, nVdv )

   if ( dbfTmpL )->nIvaTil != 0
      nCalculo       := nCalculo / ( ( ( dbfTmpL )->nIvaTil / 100 ) + 1 )
   end if

RETURN ( Round( nCalculo, nRou ) )

//--------------------------------------------------------------------------//

Static Function EdtCobTik( oWndBrw, lBig )

   local nOrd
   local nRec
   local cSerAlb
   local cNumAlb
   local cSufAlb
   local nDifVale    := 0
   local lGenVale    := .f.
   local aTmp        := dbScatter( dbfTikT )
   local aGet        := Array( ( dbfTikT )->( fCount() ) )
   local cNumTik     := ( dbfTikT )->cSerTik + ( dbfTikT )->cNumTik + ( dbfTikT )->cSufTik
   local cNumDoc     := ( dbfTikT )->cNumDoc
   local nOrdAnt     := ( dbfTikT )->( OrdSetFocus( "cNumTik" ) )

   nCopTik           := nCopiasTicketsEnCaja( oUser():cCaja(), dbfCajT )

   DEFAULT lBig      := .f.

   /*
   Objeto de totales-----------------------------------------------------------
   */

   oTotDiv           := TotalesTPV():Init()

   /*
   Crear la base de datos local para los pagos del ticket----------------------
   */

   cNewFilP          := cGetNewFileName( cPatTmp() + "TikP"  )
   dbCreate( cNewFilP, aSqlStruct( aPgoTik() ), cLocalDriver() )
   dbUseArea( .t., cLocalDriver(), cNewFilP, cCheckArea( "TikP", @dbfTmpP ), .f. )

   /*
   Crear la base de datos local para los vales del ticket----------------------
   */

   cNewFilV          := cGetNewFileName( cPatTmp() + "TikV"  )
   dbCreate( cNewFilV, aSqlStruct( aItmTik() ), cLocalDriver() )
   dbUseArea( .t., cLocalDriver(), cNewFilV, cCheckArea( "TikV", @dbfTmpV ), .f. )

   /*
   Crear la base de datos local para los anticipos de clientes-----------------
   */

   cNewFilA          := cGetNewFileName( cPatTmp() + "TikA"  )
   dbCreate( cNewFilA, aSqlStruct( aItmAntCli() ), cLocalDriver() )
   dbUseArea( .t., cLocalDriver(), cNewFilA, cCheckArea( "TikA", @dbfTmpA ), .f. )

   /*
   Crear la base de datos local para las entregas a cuenta de albaranes--------
   */

   cNewFilE          := cGetNewFileName( cPatTmp() + "TikE"  )
   dbCreate( cNewFilE, aSqlStruct( aItmAlbPgo() ), cLocalDriver() )
   dbUseArea( .t., cLocalDriver(), cNewFilE, cCheckArea( "TikE", @dbfTmpE ), .f. )

   do case
   case ( dbfTikT )->cTipTik == SAVALB // Como albaran

      aTmp[ _NCOBTIK ]  := nTotAlbCli( cNumDoc, dbfAlbCliT, dbfAlbCliL, dbfIva, dbfDiv, nil, nil, .f. )

      /*
      Importamos las entregas a cuenta-----------------------------------------
      */

      nRec           := ( dbfAlbCliP )->( Recno() )
      nOrd           := ( dbfAlbCliP )->( OrdSetFocus( "NNUMALB" ) )

      if ( dbfAlbCliP )->( dbSeek( ( dbfTikT )->cNumDoc ) )
         while ( ( dbfAlbCliP )->cSerAlb + Str( ( dbfAlbCliP )->nNumAlb ) + ( dbfAlbCliP )->cSufAlb ) == cNumDoc .and. !( dbfAlbCliP )->( eof() )
            dbPass( dbfAlbCliP, dbfTmpE, .t. )
            ( dbfAlbCliP )->( dbSkip() )
         end while
      end if
      ( dbfTmpE )->( dbGoTop() )

      ( dbfAlbCliP )->( OrdSetFocus( nOrd ) )
      ( dbfAlbCliP )->( dbGoTo( nRec ) )

   case ( dbfTikT )->cTipTik == SAVFAC // Como factura

      aTmp[ _NCOBTIK ]  := nTotFacCli( cNumDoc, dbfFacCliT, dbfFacCliL, dbfIva, dbfDiv, dbfFacCliP, nil, nil, nil, .f. )

      /*
      Importamos los pagos--------------------------------------------------------
      */

      if ( dbfFacCliP )->( dbSeek( cNumDoc ) )
         while ( dbfFacCliP )->cSerie + Str( ( dbfFacCliP )->nNumFac ) + ( dbfFacCliP )->cSufFac == cNumDoc .and. !( dbfFacCliP )->( eof() )
            if ( dbfFacCliP )->lCobrado
               ( dbfTmpP )->( dbAppend() )
               ( dbfTmpP )->cCodCaj    := ( dbfFacCliP )->cCodCaj
               ( dbfTmpP )->dPgoTik    := ( dbfFacCliP )->dEntrada
               ( dbfTmpP )->nImpTik    := ( dbfFacCliP )->nImporte
               ( dbfTmpP )->cDivPgo    := ( dbfFacCliP )->cDivPgo
               ( dbfTmpP )->nVdvPgo    := ( dbfFacCliP )->nVdvPgo
               ( dbfTmpP )->cPgdPor    := ( dbfFacCliP )->cPgdoPor
               ( dbfTmpP )->cTurPgo    := ( dbfFacCliP )->cTurRec
               ( dbfTmpP )->cCtaRec    := ( dbfFacCliP )->cCtaRec
               ( dbfTmpP )->cFpgPgo    := ( dbfFacCliP )->cCodPgo
            end if
            ( dbfFacCliP )->( dbSkip() )
         end while
      end if

      ( dbfTmpP )->( dbGoTop() )

      /*
      A¤adimos desde el fichero de Anticipos-----------------------------------
      */

      nRec  := ( dbfAntCliT )->( Recno() )
      nOrd  := ( dbfAntCliT )->( OrdSetFocus( "cNumDoc" ) )

      if ( dbfAntCliT )->( dbSeek( cNumDoc ) )
         While ( dbfAntCliT )->cNumDoc == cNumDoc .and. !( dbfAntCliT )->( eof() )
            dbPass( dbfAntCliT, dbfTmpA, .t. )
            ( dbfAntCliT )->( dbSkip() )
         End While
      End If
      ( dbfTmpA )->( dbGoTop() )

      ( dbfAntCliT )->( OrdSetFocus( nOrd ) )
      ( dbfAntCliT )->( dbGoTo( nRec ) )

   otherwise

      aTmp[ _NCOBTIK ]  := nTotTik( cNumTik, dbfTikT, dbfTikL, dbfDiv, nil, nil, .f. )

      /*
      A¤adimos desde el fichero de PAGOS---------------------------------------
      */

      if ( dbfTikP )->( dbSeek( cNumTik ) )
         while ( ( dbfTikP )->cSerTik + ( dbfTikP )->cNumTik + ( dbfTikP )->cSufTik == cNumTik .and. !( dbfTikP )->( eof() ) )
            dbPass( dbfTikP, dbfTmpP, .t. )
            ( dbfTikP )->( dbSkip() )
         end while
      end If

      ( dbfTmpP )->( dbGoTop() )

      /*
      Añadimos desde los vales----------------------------------------------
      */

      nRec     := ( dbfTikT )->( Recno() )
      nOrd     := ( dbfTikT )->( OrdSetFocus( "cDocVal" ) )

      if ( dbfTikT )->( dbSeek( cNumTik ) )
         while ( dbfTikT )->cValDoc == cNumTik .and. !( dbfTikT )->( eof() )
            dbPass( dbfTikT, dbfTmpV, .t. )
            ( dbfTikT )->( dbSkip() )
         end while
      end if

      ( dbfTikT )->( dbGoTo( nRec ) )
      ( dbfTikT )->( OrdSetFocus( nOrd ) )

      ( dbfTmpV )->( dbGoTop() )

   end case

   /*
   Llamada a la caja del cobro-------------------------------------------------
   */

   if lCobro( @aTmp, aGet, aTmp[ _CTIPTIK ], EDIT_MODE, @lGenVale, @nDifVale, lBig )

      /*
      Anotamos los pagos----------------------------------------------------------
      */

      if ( oTotDiv:lValeMayorTotal() )

         if aTmp[ _NCOBTIK ] != 0

            if dbAppe( dbfTmpP )
               ( dbfTmpP )->cCtaRec    := cCtaCob()
               ( dbfTmpP )->cTurPgo    := cCurSesion()
               ( dbfTmpP )->dPgoTik    := GetSysDate()
               ( dbfTmpP )->cTimTik    := SubStr( Time(), 1, 5 )
               ( dbfTmpP )->cCodCaj    := oUser():cCaja()
               ( dbfTmpP )->cFpgPgo    := aTmp[ _CFPGTIK ]
               ( dbfTmpP )->cSerTik    := aTmp[ _CSERTIK ]
               ( dbfTmpP )->cNumTik    := aTmp[ _CNUMTIK ]
               ( dbfTmpP )->cSufTik    := aTmp[ _CSUFTIK ]
               ( dbfTmpP )->nImpTik    := aTmp[ _NCOBTIK ]
               ( dbfTmpP )->cDivPgo    := aTmp[ _CDIVTIK ]
               ( dbfTmpP )->nVdvPgo    := aTmp[ _NVDVTIK ]
               ( dbfTmpP )->nDevTik    := Max( aTmp[ _NCAMTIK ], 0 )
            else
               MsgStop( "No se ha podido añadir el registro de pago" )
            end if

         end if

      end if

      do case
      case ( dbfTikT )->cTipTik == SAVTIK .or. ( dbfTikT )->cTipTik == SAVDEV .or. ( dbfTikT )->cTipTik == SAVAPT // Como tiket

         /*
         Eliminamos los pagos--------------------------------------------------
         */

         while ( dbfTikP )->( dbSeek( cNumTik ) )
            if dbLock( dbfTikP )
               ( dbfTikP )->( dbDelete() )
               ( dbfTikP )->( dbUnLock() )
            end if
         end while

         /*
         Ahora escribimos en el fichero definitivo los pagos-------------------
         */

         ( dbfTmpP )->( dbGoTop() )
         while !( dbfTmpP )->( eof() )
            dbPass( dbfTmpP, dbfTikP, .t. )
            ( dbfTmpP )->( dbSkip() )
         end while

         /*
         Eliminamos los vales ----------------------------------------------------')
         */

         nOrd  := ( dbfTikT )->( OrdSetFocus( "cDocVal" ) )
         nRec  := ( dbfTikT )->( Recno() )

         while ( dbfTikT )->( dbSeek( cNumTik ) ) .and. !( dbfTikT )->( eof() )
            if dbLock( dbfTikT )
               ( dbfTikT )->lLiqTik := .f.
               ( dbfTikT )->lSndDoc := .t.
               ( dbfTikT )->cValDoc := ""
               ( dbfTikT )->cTurVal := ""
               ( dbfTikT )->( dbUnLock() )
            end if
         end while

         ( dbfTikT )->( OrdSetFocus( nOrd ) )
         ( dbfTikT )->( dbGoTo( nRec ) )

         /*
         Anotamos los vales ------------------------------------------------------
         */

         nRec  := ( dbfTikT )->( Recno() )

         ( dbfTmpV )->( dbGoTop() )
         while !( dbfTmpV )->( eof() )
            if ( dbfTikT )->( dbSeek( ( dbfTmpV )->cSerTik + ( dbfTmpV )->cNumTik + ( dbfTmpV )->cSufTik ) )
               if dbLock( dbfTikT )
                  ( dbfTikT )->lLiqTik := .t.
                  ( dbfTikT )->lSndDoc := .t.
                  ( dbfTikT )->cValDoc := cNumTik
                  ( dbfTikT )->cTurVal := cCurSesion()
                  ( dbfTikT )->( dbUnLock() )
               end if
            end if
            ( dbfTmpV )->( dbSkip() )
         end while

         ( dbfTikT )->( dbGoTo( nRec ) )

      case ( dbfTikT )->cTipTik == SAVFAC // Como factura

         while ( dbfFacCliP )->( dbSeek( cNumDoc ) )
            if dbLock( dbfFacCliP )
               ( dbfFacCliP )->( dbDelete() )
               ( dbfFacCliP )->( dbUnLock() )
            end if
         end while

         /*
         Trasbase de nuevos pagos----------------------------------------------
         */

         ( dbfTmpP )->( dbGoTop() )
         while !( dbfTmpP )->( eof() )

            if dbAppe( dbfFacCliP )
               ( dbfFacCliP )->lCobrado   := .t.
               ( dbfFacCliP )->cCodCaj    := oUser():cCaja()
               ( dbfFacCliP )->cSerie     := ( dbfFacCliT )->cSerie
               ( dbfFacCliP )->nNumFac    := ( dbfFacCliT )->nNumFac
               ( dbfFacCliP )->cSufFac    := ( dbfFacCliT )->cSufFac
               ( dbfFacCliP )->cCodCli    := ( dbfFacCliT )->cCodCli
               ( dbfFacCliP )->dPreCob    := ( dbfFacCliT )->dFecFac
               ( dbfFacCliP )->nNumRec    := ( dbfTmpP )->( Recno() )
               ( dbfFacCliP )->dEntrada   := ( dbfTmpP )->dPgoTik
               ( dbfFacCliP )->cDivPgo    := ( dbfTmpP )->cDivPgo
               ( dbfFacCliP )->nVdvPgo    := ( dbfTmpP )->nVdvPgo
               ( dbfFacCliP )->cPgdoPor   := ( dbfTmpP )->cPgdPor
               ( dbfFacCliP )->nImporte   := nTotUCobTik( dbfTmpP )
               ( dbfFacCliP )->( dbUnLock() )
            end if

            ( dbfTmpP )->( dbSkip() )

         end while

         /*
         Quitamos los anticipos anteriores-------------------------------------
         */

         nRec  := ( dbfAntCliT )->( Recno() )
         nOrd  := ( dbfAntCliT )->( OrdSetFocus( "cNumDoc" ) )

         While ( dbfAntCliT )->( dbSeek( cNumDoc ) ) .and. !( dbfAntCliT )->( eof() )
            if dbLock( dbfAntCliT )
               ( dbfAntCliT )->lLiquidada := .f.
               ( dbfAntCliT )->dLiquidada := Ctod("")
               ( dbfAntCliT )->cTurLiq    := ""
               ( dbfAntCliT )->cCajLiq    := ""
               ( dbfAntCliT )->cNumDoc    := ""
               ( dbfAntCliT )->( dbUnLock() )
            end if
         End While

         ( dbfAntCliT )->( OrdSetFocus( nOrd ) )
         ( dbfAntCliT )->( dbGoTo( nRec ) )

         /*
         Ahora escribimos en el fichero definitivo los nuevos anticipos--------
         */

         ( dbfTmpA )->( dbGoTop() )
         While !( dbfTmpA )->( eof() )
            if ( dbfAntCliT )->( dbSeek( ( dbfTmpA )->cSerAnt + Str( ( dbfTmpA )->nNumAnt ) + ( dbfTmpA )->cSufAnt ) )
               if dbLock( dbfAntCliT )
                  ( dbfAntCliT )->lLiquidada := .t.
                  ( dbfAntCliT )->lSndDoc    := .t.
                  ( dbfAntCliT )->cNumDoc    := cNumDoc
                  ( dbfAntCliT )->dLiquidada := GetSysDate()
                  ( dbfAntCliT )->cTurLiq    := cCurSesion()
                  ( dbfAntCliT )->cCajLiq    := oUser():cCaja()
                  ( dbfAntCliT )->( dbUnLock() )
               end if
            end if
            ( dbfTmpA )->( dbSkip() )
         End While

         if dbLock( dbfFacCliT )
            ( dbfFacCliT )->lSndDoc          := .t.
            ( dbfFacCliT )->( dbUnLock() )
         end if

         /*
         Chequeamos el estado de la factura------------------------------------------
         */

         ChkLqdFacCli( nil, dbfFacCliT, dbfFacCliL, dbfFacCliP, dbfAntCliT, dbfIva, dbfDiv )

      case ( dbfTikT )->cTipTik == SAVALB // Como factura

         cSerAlb     := SubStr( cNumDoc, 1, 1 )
         cNumAlb     := Val( SubStr( cNumDoc, 2, 9 ) )
         cSufAlb     := SubStr( cNumDoc, 11, 2 )

         /*
         Rollback de los pagos-------------------------------------------------------
         */

         while ( dbfAlbCliP )->( dbSeek( cSerAlb + Str( cNumAlb ) + cSufAlb ) ) .and. !( dbfAlbCliP )->( eof() )

            if dbLock( dbfAlbCliP )
               ( dbfAlbCliP )->( dbDelete() )
               ( dbfAlbCliP )->( dbUnLock() )
            end if

            ( dbfAlbCliP )->( dbSkip() )

         end while

         /*
         Trasbase de nuevos pagos----------------------------------------------------
         */

         ( dbfTmpE )->( dbGoTop() )

         while !( dbfTmpE )->( eof() )

            ( dbfAlbCliP )->( dbAppend() )

            ( dbfAlbCliP )->cSerAlb    := cSerAlb
            ( dbfAlbCliP )->nNumAlb    := cNumAlb
            ( dbfAlbCliP )->cSufAlb    := cSufAlb
            ( dbfAlbCliP )->nNumRec    := ( dbfTmpE )->nNumRec
            ( dbfAlbCliP )->cCodCaj    := ( dbfTmpE )->cCodCaj
            ( dbfAlbCliP )->cTurRec    := ( dbfTmpE )->cTurRec
            ( dbfAlbCliP )->cCodCli    := ( dbfTmpE )->cCodCli
            ( dbfAlbCliP )->dEntrega   := ( dbfTmpE )->dEntrega
            ( dbfAlbCliP )->nImporte   := ( dbfTmpE )->nImporte
            ( dbfAlbCliP )->cDescrip   := ( dbfTmpE )->cDescrip
            ( dbfAlbCliP )->cPgdoPor   := ( dbfTmpE )->cPgdoPor
            ( dbfAlbCliP )->cDivPgo    := ( dbfTmpE )->cDivPgo
            ( dbfAlbCliP )->nVdvPgo    := ( dbfTmpE )->nVdvPgo
            ( dbfAlbCliP )->cCodAge    := ( dbfTmpE )->cCodAge
            ( dbfAlbCliP )->cCodPgo    := ( dbfTmpE )->cCodPgo
            ( dbfAlbCliP )->lCloPgo    := .f.
            ( dbfAlbCliP )->lPasado    := ( dbfTmpE )->lPasado

            ( dbfAlbCliP )->( dbUnLock() )

            ( dbfTmpE )->( dbSkip() )

         end while

      End Case

      /*
      Apertura de la caja------------------------------------------------------------
		*/

      if ( dbfTikT )->cTipTik != SAVALB
         if( oCajon != nil, oCajon:Open(), )
      end if

      /*
      Guardamos los cambios en la cabercera del tiket--------------------------------
      */

      dbGather( aTmp, dbfTikT )

   end if

   ( dbfTmpP )->( dbCloseArea() )
   ( dbfTmpV )->( dbCloseArea() )
   ( dbfTmpA )->( dbCloseArea() )
   ( dbfTmpE )->( dbCloseArea() )

   dbfErase( cNewFilP )
   dbfErase( cNewFilV )
   dbfErase( cNewFilA )
   dbfErase( cNewFilE )

   ( dbfTikT )->( OrdSetFocus( nOrdAnt ) )

   if !Empty( oWndBrw )
      oWndBrw:oBrw:DrawSelect()
   end if

return nil

//---------------------------------------------------------------------------//

/*
Esta funcion graba el tiket despues de pedir el importe por pantalla
*/

Static Function NewTiket( aGet, aTmp, nMode, nSave, lBig )

   local nRec
   local nOrd
   local aTbl
   local nTotTik
   local cAlmTik
   local cTipTik
   local oError
   local oBlock
   local cNumDoc        := ""
   local nNumTik        := ""
   local nDifVale       := 0
   local lGenVale       := .f.

   DEFAULT nSave        := SAVTIK      // Por defecto salvamos como ticket
   DEFAULT lBig         := .f.
   DEFAULT lCopTik      := .t.

   /*
   Comprobamos la fecha del documento------------------------------------------
   */

   if !lValidaOperacion( aTmp[ _DFECTIK ] )
      Return .f.
   end if

   /*
   Controles para todo tipo de documentos--------------------------------------
   */

   if ( dbfTmpL )->( LastRec() ) == 0
      MsgStop( "No puede almacenar un documento sin lineas." )
      return .f.
   end if

   if !Empty( aGet[ _CCLITIK ] ) .and. !( aGet[ _CCLITIK ]:lValid() )
      aGet[ _CCLITIK ]:SetFocus()
      return .f.
   end if

   if !Empty( aGet[ _CALMTIK ] )

      if Empty( aTmp[ _CALMTIK ] )
         aGet[ _CALMTIK ]:SetFocus()
         MsgInfo( "Almacén no puede estar vacio" )
         return .f.
      end if

      if !( aGet[ _CALMTIK ]:lValid() )
         aGet[ _CALMTIK ]:SetFocus()
         return .f.
      end if

   end if

   if lRecogerAgentes() .and. !Empty( aGet[ _CCODAGE ] ) .and.  Empty( aTmp[ _CCODAGE ] )
      msgStop( "Agente no puede estar vacio." )
      aGet[ _CCODAGE ]:SetFocus()
      return .f.
   end if

   if lRecogerAgentes() .and. !Empty( aGet[ _CCODAGE ] ) .and. !( aGet[ _CCODAGE ]:lValid() )
      aGet[ _CCODAGE ]:SetFocus()
      return .f.
   end if

   /*
   Requisitos especiales segun el tipo de documento----------------------------
   */

   do case
   case nSave == SAVFAC

      /*
      Estos campos no pueden estar vacios--------------------------------------
      */

      if !Empty( aGet[ _CNOMTIK ] ) .and. Empty( aTmp[ _CNOMTIK ] ) .and. !( "GA" $ oWnd():Cargo )
         msgStop( "Nombre de cliente no puede estar vacio." )
         aGet[ _CCLITIK ]:SetFocus()
         return .f.
      end if

      if Empty( aTmp[ _CDIRCLI ] ) .and. !( "GA" $ oWnd():Cargo )
         msgStop( "dirección de cliente no puede estar vacia." )
         return .f.
      end if

      if Empty( aTmp[ _CDNICLI ] ) .and. !( "GA" $ oWnd():Cargo )
         msgStop( "D.N.I. / C.I.F. de cliente no puede estar vacio." )
         return .f.
      end if

      if Empty( aTmp[ _CFPGTIK ] )
         MsgStop( "Debe de introducir una forma de pago", "Imposible archivar como factura" )
         aGet[ _CFPGTIK ]:SetFocus()
         return .f.
      end if

      if !( aGet[ _CFPGTIK ]:lValid() )
         aGet[ _CFPGTIK ]:SetFocus()
         return .f.
      end if

      if lObras() .and. !Empty( aGet[ _CCODOBR ] ) .and. Empty( aTmp[ _CCODOBR ] )
         MsgStop( "Debe de introducir una dirección", "Imposible archivar como factura" )
         aGet[ _CCODOBR ]:SetFocus()
         return .f.
      end if

      if lObras() .and. !Empty( aGet[ _CCODOBR ] ) .and. !( aGet[ _CCODOBR ]:lValid() )
         aGet[ _CCODOBR ]:SetFocus()
         return .f.
      end if

   case nSave == SAVALB

      if Empty( aTmp[ _CCLITIK ] )
         msgStop( "Código de cliente no puede estar vacio." )
         aGet[ _CCLITIK ]:SetFocus()
         return .f.
      end if

      if !Empty( aGet[ _CCLITIK ] ) .and. lCliBlq( aTmp[ _CCLITIK ], dbfClient )
         msgStop( "Cliente bloqueado, no se pueden realizar operaciones de venta" , "Imposible archivar como albarán" )
         aGet[ _CCLITIK ]:SetFocus()
         return .f.
      end if

      if !Empty( aGet[ _CCLITIK ] ) .and. !lCliChg( aTmp[ _CCLITIK ], dbfClient )
         msgStop( "Este cliente no tiene autorización para venta a credito.", "Imposible archivar como albarán" )
         aGet[ _CCLITIK ]:SetFocus()
         return .f.
      end if

      if !Empty( aGet[ _CFPGTIK ] ) .and. Empty( aTmp[ _CFPGTIK ] )
         MsgStop( "Debe de introducir una forma de pago", "Imposible archivar como albarán" )
         aGet[ _CFPGTIK ]:SetFocus()
         return .f.
      end if

      if !Empty( aGet[ _CFPGTIK ] ) .and. !( aGet[ _CFPGTIK ]:lValid() )
         aGet[ _CFPGTIK ]:SetFocus()
         return .f.
      end if

      if lObras() .and. !Empty( aGet[ _CCODOBR ] ) .and. Empty( aTmp[ _CCODOBR ] )
         MsgStop( "Debe de introducir una dirección", "Imposible archivar como albarán" )
         aGet[ _CCODOBR ]:SetFocus()
         return .f.
      end if

      if lObras() .and. !Empty( aGet[ _CCODOBR ] ) .and. !( aGet[ _CCODOBR ]:lValid() )
         aGet[ _CCODOBR ]:SetFocus()
         return .f.
      end if

   end case

   /*
   Serie del ticket------------------------------------------------------------
   */

   if Empty( aTmp[ _CSERTIK ] )
      aTmp[ _CSERTIK ]  := "A"
   end if

   /*
   Turno del ticket------------------------------------------------------------
   */

   if Empty( aTmp[ _CTURTIK ] )
      aTmp[ _CTURTIK ]  := cCurSesion()
   end if

   /*
   Inicalizamos las variables de importe---------------------------------------
   */

   oTotDiv              := TotalesTPV():Init()

   nTotTik              := nTotTik( aTmp[ _CSERTIK ] + aTmp[ _CNUMTIK ] + aTmp[ _CSUFTIK ], dbfTikT, dbfTmpL, dbfDiv, aTmp, nil, .f. )

   aTmp[ _NCAMTIK ]     := 0
   aTmp[ _NCOBTIK ]     := nTotTik

   /*
   Llamada a la funcion del cobro----------------------------------------------
   */

   if lExacto( aTmp ) .or. lCobro( @aTmp, aGet, nSave, nMode, @lGenVale, @nDifVale, lBig )

      /*
      Control de errores-------------------------------------------------------
      */

      oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
      BEGIN SEQUENCE

         oDlgTpv:Disable()

         /*
         Archivamos el tipo de venta que se ha realizado--------------------------
         */

         aTmp[ _CTIPTIK ]     := nSave
         aTmp[ _DFECCRE ]     := Date()
         aTmp[ _CTIMCRE ]     := SubStr( Time(), 1, 5 )
         aTmp[ _LABIERTO]     := .f.

         /*
         Grabamos el tiket--------------------------------------------------------
         */

         do case
         case nMode == APPD_MODE

            /*
            Obtenemos el nuevo numero del Tiket-----------------------------------
            */

            oMetMsg:cText     := 'Obtenemos el nuevo número'
            oMetMsg:Refresh()

            aTmp[ _CNUMTIK ]  := Str( nNewDoc( aTmp[ _CSERTIK ], dbfTikT, "nTikCli", 10, dbfCount ), 10 )
            aTmp[ _CSUFTIK ]  := RetSufEmp()
            nNumTik           := aTmp[ _CSERTIK ] + aTmp[ _CNUMTIK ] + aTmp[ _CSUFTIK ]

            /*
            Fechas y horas de creacon del tiket-----------------------------------
            */

            aTmp[ _CHORTIK ]  := Substr( Time(), 1, 5 )
            aTmp[ _LCLOTIK ]  := .f.

            oMetMsg:cText     := 'Modificando el riesgo'
            oMetMsg:Refresh()

         case nMode == EDIT_MODE

            nNumTik           := aTmp[ _CSERTIK ] + aTmp[ _CNUMTIK ] + aTmp[ _CSUFTIK ]
            cNumDoc           := aTmp[ _CNUMDOC ]

            /*
            Borramos todos los registros anteriores----------------------------------
            */

            //oStock:TpvCli( nNumTik, aTmp[ _CALMTIK ], .t., aTmp[ _CTIPTIK ] == SAVVAL .or. aTmp[ _CTIPTIK ] == SAVDEV )

            oMetMsg:cText     := 'Modificando el riesgo'
            oMetMsg:Refresh()

            /*
            Eliminamos las lineas----------------------------------------------------
            */

            oMetMsg:cText     := 'Eliminando lineas'
            oMetMsg:Refresh()

            while ( dbfTikL )->( dbSeek( nNumTik ) )
               if dbLock( dbfTikL )
                  ( dbfTikL )->( dbDelete() )
                  ( dbfTikL )->( dbUnLock() )
               end if
            end while

            /*
            Eliminamos los pagos-----------------------------------------------------
            */

            oMetMsg:cText     := 'Eliminando pagos'
            oMetMsg:Refresh()

            while ( dbfTikP )->( dbSeek( nNumTik ) )

               // addRiesgo( nTotUCobTik( dbfTikP ), aTmp[ _CCLITIK ], dbfClient )

               if dbLock( dbfTikP )
                  ( dbfTikP )->( dbDelete() )
                  ( dbfTikP )->( dbUnLock() )
               end if

            end while

            /*
            'Eliminamos los vales ----------------------------------------------------')
            */

            oMetMsg:cText     := 'Eliminando vales'
            oMetMsg:Refresh()

            nOrd  := ( dbfTikT )->( OrdSetFocus( "cDocVal" ) )
            nRec  := ( dbfTikT )->( Recno() )

            while ( dbfTikT )->( dbSeek( nNumTik ) ) .and. !( dbfTikT )->( eof() )
               if dbLock( dbfTikT )
                  ( dbfTikT )->lLiqTik       := .f.
                  ( dbfTikT )->lSndDoc       := .t.
                  ( dbfTikT )->cValDoc       := ""
                  ( dbfTikT )->cTurVal       := ""
                  ( dbfTikT )->( dbUnLock() )
               end if
            end while

            ( dbfTikT )->( OrdSetFocus( nOrd ) )
            ( dbfTikT )->( dbGoTo( nRec ) )

            /*
            Quitamos las marcas desde el fichero de Tiket---------------------------------------
            */

            if !Empty( cNumDoc )

            oMetMsg:cText     := 'Eliminando anticipos'
            oMetMsg:Refresh()

            nRec  := ( dbfAntCliT )->( Recno() )
            nOrd  := ( dbfAntCliT )->( OrdSetFocus( "cNumDoc" ) )

            while ( dbfAntCliT )->( dbSeek( cNumDoc ) ) .and. !( dbfAntCliT )->( eof() )
               if dbLock( dbfAntCliT )
                  ( dbfAntCliT )->lLiquidada := .f.
                  ( dbfAntCliT )->dLiquidada := Ctod( "" )
                  ( dbfAntCliT )->cTurLiq    := ""
                  ( dbfAntCliT )->cCajLiq    := ""
                  ( dbfAntCliT )->cNumDoc    := ""
                  ( dbfAntCliT )->( dbUnLock() )
               end if
            end while

            ( dbfAntCliT )->( OrdSetFocus( nOrd ) )
            ( dbfAntCliT )->( dbGoTo( nRec ) )

            end if

         end case

         /*
         Anotamos los pagos-------------------------------------------------------
         */

         oMetMsg:cText                       := 'Anotando los pagos'
         oMetMsg:Refresh()

         if ( oTotDiv:lValeMayorTotal() )

            if ( aTmp[ _NCOBTIK ] != 0 .and. nSave != SAVVAL )

               if dbAppe( dbfTmpP )

                  ( dbfTmpP )->cTurPgo    := cCurSesion()
                  ( dbfTmpP )->dPgoTik    := GetSysDate()
                  ( dbfTmpP )->cTimTik    := SubStr( Time(), 1, 5 )
                  ( dbfTmpP )->cCodCaj    := oUser():cCaja()
                  ( dbfTmpP )->cFpgPgo    := aTmp[ _CFPGTIK ]
                  ( dbfTmpP )->cSerTik    := aTmp[ _CSERTIK ]
                  ( dbfTmpP )->cNumTik    := aTmp[ _CNUMTIK ]
                  ( dbfTmpP )->cSufTik    := aTmp[ _CSUFTIK ]
                  ( dbfTmpP )->nImpTik    := aTmp[ _NCOBTIK ]
                  ( dbfTmpP )->cDivPgo    := aTmp[ _CDIVTIK ]
                  ( dbfTmpP )->nVdvPgo    := aTmp[ _NVDVTIK ]
                  ( dbfTmpP )->nDevTik    := Max( aTmp[ _NCAMTIK ], 0 )
               else
                  MsgStop( "No se ha podido añadir el registro de pago" )
               end if

            end if

         end if

         /*
         Guardamos los cambios para posteriores-----------------------------------
         */

         nCambioTik                       := aTmp[ _NCAMTIK ]

         /*
         Guardamos el tipo como albaranes-----------------------------------------
         */

         do case
            case nMode == DUPL_MODE

               SavTik2Tik( aTmp, aGet, nMode, nSave )
               SavTik2Fac( aTmp, aGet, nMode, nSave, nTotTik )

            case nSave == SAVALB

               SavTik2Alb( aTmp, aGet, nMode, nSave )

            case nSave == SAVFAC

               SavTik2Fac( aTmp, aGet, nMode, nSave, nTotTik )

            otherwise

               /*
               Guardamos el tipo como tiket---------------------------------------
               */

               oMetMsg:cText           := 'Archivando lineas'
               oMetMsg:Refresh()

               nRec                    := ( dbfTmpL )->( Recno() )
               ( dbfTmpL )->( dbGoTop() )
               while !( dbfTmpL )->( eof() )
                  dbPass( dbfTmpL, dbfTikL, .t., aTmp[ _CSERTIK ], aTmp[ _CNUMTIK ], aTmp[ _CSUFTIK ], aTmp[ _CTIPTIK ] )
                  ( dbfTmpL )->( dbSkip() )
               end while
               ( dbfTmpL )->( dbGoTo( nRec ) )

               /*
               Ahora escribimos en el fichero definitivo los pagos-------------------------
               */

               oMetMsg:cText           := 'Archivando pagos'
               oMetMsg:Refresh()

               ( dbfTmpP )->( dbGoTop() )
               while !( dbfTmpP )->( eof() )
                  // DelRiesgo( nTotUCobTik( dbfTmpP ), aTmp[ _CCLITIK ], dbfClient  )
                  dbPass( dbfTmpP, dbfTikP, .t., aTmp[ _CSERTIK ], aTmp[ _CNUMTIK ], aTmp[ _CSUFTIK ] )
                  ( dbfTmpP )->( dbSkip() )
               end while

               /*
               Escribimos definitivamente en el disco--------------------------------------
               */

               oMetMsg:cText           := 'Archivando ticket'
               oMetMsg:Refresh()

               cAlmTik           := aTmp[ _CALMTIK ]
               cTipTik           := aTmp[ _CTIPTIK ]
               cNumDoc           := aTmp[ _CSERTIK ] + aTmp[ _CNUMTIK ] + aTmp[ _CSUFTIK ]

               /*
               No quitar----------------------------------------------------------
               */

               SysRefresh()

               WinGather( aTmp, aGet, dbfTikT, nil, nMode )

         end case

         /*
         Actualizamos el stock-------------------------------------------------------
         */

         oMetMsg:cText                 := 'Actualizando stocks'
         oMetMsg:Refresh()

         //oStock:TpvCli( nNumTik, cAlmTik, .f., cTipTik == SAVVAL .or. cTipTik == SAVDEV )

         /*
         Anotamos los vales ------------------------------------------------------
         */

         oMetMsg:cText                 := 'Archivando vales'
         oMetMsg:Refresh()

         nRec                          := ( dbfTikT )->( Recno() )

         ( dbfTmpV )->( dbGoTop() )
         while !( dbfTmpV )->( eof() )
            if ( dbfTikT )->( dbSeek( ( dbfTmpV )->cSerTik + ( dbfTmpV )->cNumTik + ( dbfTmpV )->cSufTik ) )
               if dbLock( dbfTikT )
                  ( dbfTikT )->lLiqTik := .t.
                  ( dbfTikT )->lSndDoc := .t.
                  ( dbfTikT )->cValDoc := nNumTik
                  ( dbfTikT )->cTurVal := cCurSesion()
                  ( dbfTikT )->( dbUnLock() )
               end if
            end if
            ( dbfTmpV )->( dbSkip() )
         end while

         ( dbfTikT )->( dbGoTo( nRec ) )

         /*
         Ahora escribimos en el fichero definitivo los anticipos------------------
         */

         oMetMsg:cText        := 'Archivando anticipos'
         oMetMsg:Refresh()

         ( dbfTmpA )->( dbGoTop() )
         While !( dbfTmpA )->( eof() )
            if ( dbfAntCliT )->( dbSeek( ( dbfTmpA )->cSerAnt + Str( ( dbfTmpA )->nNumAnt ) + ( dbfTmpA )->cSufAnt ) )
               if dbLock( dbfAntCliT )
                  ( dbfAntCliT )->cNumDoc    := ( dbfFacCliT )->cSerie + Str( ( dbfFacCliT )->nNumFac, 9 ) + ( dbfFacCliT )->cSufFac
                  ( dbfAntCliT )->lLiquidada := .t.
                  ( dbfAntCliT )->dLiquidada := GetSysDate()
                  ( dbfAntCliT )->cTurLiq    := cCurSesion()
                  ( dbfAntCliT )->cCajLiq    := oUser():cCaja()
                  ( dbfAntCliT )->( dbUnLock() )
               end if
            end if
            ( dbfTmpA )->( dbSkip() )
         End While

         /*
         Escribe los datos pendientes---------------------------------------------
         */

         dbCommitAll()

         /*
         Chequeo de los pago------------------------------------------------------
         */

         if ( dbfTikT )->cTipTik == SAVFAC

            if dbLock( dbfFacCliT )
               ( dbfFacCliT )->lSndDoc       := .t.
               ( dbfFacCliT )->( dbUnLock() )
            end if

            /*
            Generar los pagos de las facturas-------------------------------------
            */

            GenPgoFacCli( ( dbfFacCliT )->cSerie + Str( ( dbfFacCliT )->nNumFac ) + ( dbfFacCliT )->cSufFac, dbfFacCliT, dbfFacCliL, dbfFacCliP, dbfAntCliT, dbfClient, dbfFPago, dbfDiv, dbfIva, EDIT_MODE )

            /*
            Estado de la factura--------------------------------------------------
            */

            ChkLqdFacCli( nil, dbfFacCliT, dbfFacCliL, dbfFacCliP, dbfAntCliT, dbfIva, dbfDiv )

         end if

         /*
         Apertura de la caja------------------------------------------------------
         */

         oMetMsg:cText        := 'Abriendo la caja'
         oMetMsg:Refresh()

         if ( dbfTikT )->cTipTik != SAVALB
            if( oCajon != nil, oCajon:Open(), )
         end if

         /*
         Generamos el vale por la diferencia si nos lo piden
         */

         if lGenVale .and. nMode == APPD_MODE

            oMetMsg:cText     := 'Generando vales'
            oMetMsg:Refresh()

            /*
            Obtenemos el nuevo numero del vale------------------------------------
            */

            aTmp              := dbScatter( dbfTikT )
            aTmp[ _CNUMTIK ]  := Str( nNewDoc( aTmp[ _CSERTIK ], dbfTikT, "NTIKCLI", 10, dbfCount ), 10 )
            aTmp[ _CSUFTIK ]  := RetSufEmp()
            aTmp[ _CHORTIK ]  := Substr( Time(), 1, 5 )
            aTmp[ _DFECCRE ]  := Date()
            aTmp[ _CTIMCRE ]  := SubStr( Time(), 1, 5 )
            aTmp[ _CTIPTIK ]  := SAVVAL
            aTmp[ _LCLOTIK ]  := .f.

            dbGather( aTmp, dbfTikT, .t. )

            /*
            Guardamos las lineas del tiket----------------------------------------
            */

            aTbl              := dbBlankRec( dbfTmpL )
            aTbl[ _CSERTIL ]  := aTmp[ _CSERTIK ]
            aTbl[ _CNUMTIL ]  := aTmp[ _CNUMTIK ]
            aTbl[ _CSUFTIL ]  := aTmp[ _CSUFTIK ]
            aTbl[ _CNOMTIL ]  := "Vale por diferencias"
            aTbl[ _NUNTTIL ]  := 1
            aTbl[ _NPVPTIL ]  := nDifVale

            dbGather( aTbl, dbfTikL, .t. )

         end if

         /*
         Imprimimos la comanda----------------------------------------------------
         */

         if lBig
            ImpresionComanda( nNumTik, dbfTikL )
         end if

         /*
         Imprimir el registro-----------------------------------------------------
         */

         if lCopTik // nCopTik != 0   //Comprobamos que hayamos pulsado el botón de aceptar e imprimir
            ImpTiket( .f. )
         end if

         /*
         Modo para el proximo ticket----------------------------------------------
         */

         nSaveMode            := APPD_MODE

         /*
         Cerrando-----------------------------------------------------------------
         */

         oDlgTpv:Enable()

         /*
         Cerrando el control de errores-------------------------------------------
         */

      RECOVER USING oError

         msgStop( "Error en la grabación del ticket" + CRLF + ErrorMessage( oError ) )

      END SEQUENCE

      ErrorBlock( oBlock )

      /*
      Preparados para un nuevo registro----------------------------------------
      */

      if ( lBig ) .or. ( lEntCon() .and. nMode == APPD_MODE )

         oMetMsg:cText     := 'Inicializado entorno'
         oMetMsg:Refresh()

         if BeginTrans( aTmp, aGet, nMode, .t. )
            Return nil
         end if

         /*
         Actualizamos los controles--------------------------------------------
         */

         // aEval( oDlgTpv:aControls, { | oCtrl | oCtrl:Refresh() } )

         /*
         Validamos los controles-----------------------------------------------
         */

         if !Empty( aGet[ _CCLITIK ] )
            aGet[ _CCLITIK ]:lValid()
         end if

         /*
         Informacion del cambio anterior----------------------------------------
         */

         if oTxtTot != nil
            oTxtTot:SetText( "Cambio" )
         end if

         if oNumTot != nil .and. cPorDiv != nil
            oNumTot:SetText( Trans( nCambioTik, cPorDiv ) )
         end if

         /*
         Articulos de inicio---------------------------------------------------
         */

         if !Empty( oBtnIni )
            oBtnIni:Click()
         end if

         /*
         Ejecutamos del nuevo el bStart----------------------------------------
         */

         if ValType( oDlgTpv:Cargo ) == "B"
            Eval( oDlgTpv:Cargo )
         end if

      else

         oDlgTpv:bValid    := {|| .t. }
         oDlgTpv:end( IDOK )

      end if

      /*
      Imprimimos en el visor---------------------------------------------------
      */

      if oVisor != nil
         oVisor:SetBufferLine( { "Total: ",  Trans( nTotTik, cPorDiv ) },     1 )
         oVisor:SetBufferLine( { "Cambio: ", Trans( nCambioTik, cPorDiv ) },  2 )
         oVisor:WriteBufferLine()
      end if

   end if

Return Nil

//---------------------------------------------------------------------------//
//
// Guarda el ticket

Static Function TmpTiket( aTmp, aGet, nMode, lClean )

   local oError
   local oBlock
   local nRecno
   local cNumDoc           := ""
   local nNumTik           := ""

   DEFAULT lClean          := .t.

   /*
   Vemos si tenemos lineas que guardar-----------------------------------------
   */

   if ( dbfTmpL )->( LastRec() ) == 0
      return .t.
   end if

   /*
   Comprobamos la fecha del documento------------------------------------------
   */

   if !lValidaOperacion( aTmp[ _DFECTIK ] )
      Return .f.
   end if

   if !Empty( aGet[ _CCLITIK ] ) .and. !aGet[ _CCLITIK ]:lValid()
      aGet[ _CCLITIK ]:SetFocus()
      return .f.
   end if

   if !Empty( aGet[ _CALMTIK ] )

      if Empty( aTmp[ _CALMTIK ] )
         aGet[ _CALMTIK ]:SetFocus()
         MsgInfo( "Almacén no puede estar vacio" )
         return .f.
      end if

      if !( aGet[ _CALMTIK ]:lValid() )
         aGet[ _CALMTIK ]:SetFocus()
         return .f.
      end if

   end if

   /*
   Comprobamos que si el ticket es un generico y no tiene alias----------------
   */

   if !Empty( oSalaVentas )                        .and.;
      Empty( aTmp[ _CCODSALA ] )                   .and.;
      AllTrim( aTmp[ _CPNTVENTA ] ) == "General"   .and.;
      Empty( aTmp[ _CALIASTIK ] )

      MsgStop( "No puede guardar un ticket genérico sin asignarle un alias." )
      Return .f.
   end if

   /*
   Comprobamos que si el ticket es un para llevar y no tiene cliente-----------
   */

   if !Empty( oSalaVentas )                        .and.;
      Empty( aTmp[ _CCODSALA ] )                   .and.;
      AllTrim( aTmp[ _CPNTVENTA ] ) == "Llevar"    .and.;
      Empty( aTmp[ _CCLITIK ] )

      MsgStop( "No puede guardar un ticket para llevar sin asignarle un cliente." )
      Return .f.
   end if

   /*
   Serie por defecto-----------------------------------------------------------
   */

   if Empty( aTmp[ _CSERTIK ] )
      aTmp[ _CSERTIK ]     := "A"
   end if

   /*
   Turno del ticket------------------------------------------------------------
   */

   if Empty( aTmp[ _CTURTIK ] )
      aTmp[ _CTURTIK ]     := cCurSesion()
   end if

   /*
   Inicalizamos las variables de importe---------------------------------------
   */

   nTotTik                 := nTotTik( aTmp[ _CSERTIK ] + aTmp[ _CNUMTIK ] + aTmp[ _CSUFTIK ], dbfTikT, dbfTmpL, dbfDiv, aTmp, nil, .f. )
   nTotPax                 := nTotTik / NotCero( aTmp[ _NNUMCOM ] )

   aTmp[ _NCAMTIK ]        := 0
   aTmp[ _NCOBTIK ]        := nTotTik

   /*
   Control de errores-------------------------------------------------------
   */

   oBlock                  := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      oDlgTpv:Disable()

      /*
      Archivamos el tipo de venta que se ha realizado--------------------------
      */

      aTmp[ _CTIPTIK ]     := SAVTIK
      aTmp[ _DFECCRE ]     := Date()
      aTmp[ _CTIMCRE ]     := SubStr( Time(), 1, 5 )

		/*
      Grabamos el tiket--------------------------------------------------------
		*/

      do case
      case nMode == APPD_MODE

         /*
         Obtenemos el nuevo numero del Tiket-----------------------------------
         */

         oMetMsg:cText           := 'Obtenemos el nuevo número'
         oMetMsg:Refresh()

         aTmp[ _CNUMTIK ]        := Str( nNewDoc( aTmp[ _CSERTIK ], dbfTikT, "nTikCli", 10, dbfCount ), 10 )
         aTmp[ _CSUFTIK ]        := RetSufEmp()
         nNumTik                 := aTmp[ _CSERTIK ] + aTmp[ _CNUMTIK ] + aTmp[ _CSUFTIK ]

         /*
         Fechas y horas de creacon del tiket-----------------------------------
         */

         aTmp[ _CHORTIK ]        := Substr( Time(), 1, 5 )
         aTmp[ _LCLOTIK ]        := .f.

         if !Empty( oSalaVentas ) .and. IsTrue( oSalaVentas:lPuntosVenta )
            aTmp[ _CCODSALA   ]  := oSalaVentas:cSelectedSala
            aTmp[ _CPNTVENTA  ]  := oSalaVentas:cSelectedPunto
            aTmp[ _NTARIFA    ]  := oSalaVentas:nSelectedPrecio
         end if

      case nMode == EDIT_MODE

         nNumTik           := aTmp[ _CSERTIK ] + aTmp[ _CNUMTIK ] + aTmp[ _CSUFTIK ]
         cNumDoc           := aTmp[ _CNUMDOC ]

         /*
         Nos posicionamos en el registro a guardar-----------------------------
         */

         if !( dbfTikT )->( dbSeek( nNumTik ) )
            oMetMsg:cText  := 'Ticket no encontrado'
            oMetMsg:Refresh()
         end if

         /*
         Borramos todos los registros anteriores----------------------------------
         */

         //oStock:TpvCli( nNumTik, aTmp[ _CALMTIK ], .t., aTmp[ _CTIPTIK ] == SAVVAL .or. aTmp[ _CTIPTIK ] == SAVDEV )

         /*
         Eliminamos las lineas----------------------------------------------------
         */

         oMetMsg:cText     := 'Eliminando lineas'
         oMetMsg:Refresh()

         while dbSeekInOrd( nNumTik, "cNumTil", dbfTikL )
            if dbLock( dbfTikL )
               ( dbfTikL )->( dbDelete() )
               ( dbfTikL )->( dbUnLock() )
            end if
         end while

      end case

      /*
      Guardamos el tipo como tiket---------------------------------------------
      */

      oMetMsg:cText        := 'Archivando lineas'
      oMetMsg:SetTotal( ( dbfTmpL )->( LastRec() ) )

      nRecno               := ( dbfTmpL )->( Recno() )

      ( dbfTmpL )->( dbGoTop() )
      while !( dbfTmpL )->( eof() )
         oMetMsg:Set( ( dbfTmpL )->( Recno() ) )
         dbPass( dbfTmpL, dbfTikL, .t., aTmp[ _CSERTIK ], aTmp[ _CNUMTIK ], aTmp[ _CSUFTIK ] )
         ( dbfTmpL )->( dbSkip() )
      end while

      ( dbfTmpL )->( dbGoTo( nRecno ) )

      oMetMsg:Set( 0 )

      /*
      Escribimos definitivamente en el disco-----------------------------------
      */

      oMetMsg:cText        := 'Archivando ticket'
      oMetMsg:Refresh()

      WinGather( aTmp, aGet, dbfTikT, nil, nMode, nil, lClean )

      /*
      Imprimimos la comanda----------------------------------------------------
      */

      ImpresionComanda( nNumTik, dbfTikL )

      /*
      Actualizamos el stock----------------------------------------------------
      */

      oMetMsg:cText        := 'Actualizando stocks'
      oMetMsg:Refresh()

      //oStock:TpvCli( nNumTik, aTmp[ _CALMTIK ], .f., aTmp[ _CTIPTIK ] == SAVVAL .or. aTmp[ _CTIPTIK ] == SAVDEV )

      /*
      Escribe los datos pendientes---------------------------------------------
      */

      dbCommitAll()

		/*
      Cerrando-----------------------------------------------------------------
		*/

      oDlgTpv:Enable()

   /*
   Cerrando el control de errores----------------------------------------------
   */

   RECOVER USING oError

      msgStop( "Error en la grabación del ticket" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( .t. )

//---------------------------------------------------------------------------//

/*
Caja de dialogo para la impresi¢n de Tickets
*/

Static Function DlgPrnTicket( oBrw )

   local oDlg
   local oSelTik
   local nSelTik     := 1
   local nOrdAnt     := ( dbfTikT )->( OrdSetFocus( 1 ) )
   local nRecAnt     := ( dbfTikT )->( RecNo() )
   local oSerDes
   local cSerDes     := ( dbfTikT )->cSerTik
   local cNumDes     := Val( ( dbfTikT )->cNumTik )
   local cSufDes     := ( dbfTikT )->cSufTik
   local oSerHas
   local cSerHas     := ( dbfTikT )->cSerTik
   local cNumHas     := Val( ( dbfTikT )->cNumTik )
   local cSufHas     := ( dbfTikT )->cSufTik
   local dFecDes     := ( dbfTikT )->dFecTik
   local dFecHas     := ( dbfTikT )->dFecTik
   local lInvOrden   := .f.

   DEFINE DIALOG oDlg RESOURCE "PRNTICKET"

		REDEFINE RADIO oSelTik VAR nSelTik ;
			ID 		101, 102 ;
			ON CHANGE( ( dbfTikT )->( OrdSetFocus( nSelTik ) ) );
			OF 		oDlg

      REDEFINE GET oSerDes VAR cSerDes;
			ID 		110 ;
			WHEN 		( nSelTik == 1 ) ;
         SPINNER ;
         ON UP    ( UpSerie( oSerDes ) );
         ON DOWN  ( DwSerie( oSerDes ) );
         VALID    ( cSerDes >= "A" .AND. cSerDes <= "Z"  );
         OF       oDlg

		REDEFINE GET cNumDes;
			ID 		120 ;
			WHEN 		( nSelTik == 1 ) ;
         PICTURE  "9999999999" ;
         SPINNER ;
			OF 		oDlg

		REDEFINE GET cSufDes;
			ID 		130 ;
			WHEN 		( nSelTik == 1 ) ;
			OF 		oDlg

      REDEFINE GET oSerHas VAR cSerHas;
			ID 		140 ;
         COLOR    CLR_GET ;
         SPINNER ;
         ON UP    ( UpSerie( oSerHas ) );
         ON DOWN  ( DwSerie( oSerHas ) );
         WHEN     ( nSelTik == 1 ) ;
         VALID    ( cSerHas >= "A" .AND. cSerHas <= "Z"  );
         OF       oDlg

		REDEFINE GET cNumHas;
			ID 		150 ;
			WHEN 		( nSelTik == 1 ) ;
         PICTURE  "9999999999" ;
         SPINNER ;
         OF       oDlg

		REDEFINE GET cSufHas;
			ID 		160 ;
			WHEN 		( nSelTik == 1 ) ;
			OF 		oDlg

		REDEFINE GET dFecDes;
			ID 		170 ;
			WHEN 		( nSelTik == 2 ) ;
			OF 		oDlg

		REDEFINE GET dFecHas;
			ID 		180 ;
			WHEN 		( nSelTik == 2 ) ;
			OF 		oDlg

      REDEFINE CHECKBOX lInvOrden ;
         ID       500 ;
         OF       oDlg

      REDEFINE BUTTON ;
			ID 		505 ;
			OF 		oDlg ;
         ACTION   (  PrnSerTik( nSelTik, cSerDes + Str( cNumDes ) + cSufDes, cSerHas + Str( cNumHas ) + cSufHas, dFecDes, dFecHas, oDlg, lInvOrden ),;
                     oDlg:End( IDOK ) )

		REDEFINE BUTTON ;
			ID 		510 ;
			OF 		oDlg ;
         CANCEL ;
         ACTION   ( oDlg:end() )

   oDlg:AddFastKey( VK_F5, {|| PrnSerTik( nSelTik, cSerDes + Str( cNumDes ) + cSufDes, cSerHas + Str( cNumHas ) + cSufHas, dFecDes, dFecHas, oDlg, lInvOrden ), oDlg:End( IDOK ) } )

   oDlg:bStart := { || oSerDes:SetFocus() }

   ACTIVATE DIALOG oDlg CENTER

	( dbfTikT )->( OrdSetFocus( nOrdAnt ) )
	( dbfTikT )->( dbGoTo( nRecAnt ) )

	oBrw:refresh()

RETURN ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

/*
Imprime los tickets desde un punto a otro
*/

Static Function PrnSerTik( nSelTik, cNumDes, cNumHas, dFecDes, dFecHas, oDlg, lInvOrden )

   local oBlock
   local oError
   local nOrdAnt
   local uNumDes
   local uNumHas
   local nRecAnt

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   nRecAnt           := ( dbfTikT )->( RecNo() )

   DEFAULT nSelTik   := 1
   DEFAULT cNumDes   := ( dbfTikT )->cSerTik + ( dbfTikT )->cNumTik + ( dbfTikT )->cSufTik
   DEFAULT cNumHas   := ( dbfTikT )->cSerTik + ( dbfTikT )->cNumTik + ( dbfTikT )->cSufTik

   if nSelTik == 1
      nOrdAnt        := ( dbfTikT )->( OrdSetFocus( "cNumTik" ) )
      uNumDes        := cNumDes
      uNumHas        := cNumHas
   else
      nOrdAnt        := ( dbfTikT )->( OrdSetFocus( "dFecTik" ) )
      uNumDes        := dFecDes
      uNumHas        := dFecHas
   end if

   if !Empty( oDlg )
      oDlg:Disable()
   end if

   if !lInvOrden

      if ( dbfTikT )->( dbSeek( uNumDes, .t. ) )

         while !( dbfTikT )->( eof())                    .AND.;
               ( dbfTikT )->( OrdKeyVal() ) >= uNumDes   .AND.;
               ( dbfTikT )->( OrdKeyVal() ) <= uNumHas

               ImpTiket()

               ( dbfTikT )->( dbSkip() )

         end while

      end if

   else

      if ( dbfTikT )->( dbSeek( uNumHas ) )

         while ( dbfTikT )->( OrdKeyVal() ) >= uNumDes   .and.;
               ( dbfTikT )->( OrdKeyVal() ) <= uNumHas   .and.;
               !( dbfTikT )->( Bof() )

               ImpTiket()

            ( dbfTikT )->( dbSkip( -1 ) )

         end while

      end if

   end if

   if !Empty( oDlg )
      oDlg:Enable()
   end if

   ( dbfTikT )->( dbGoTo( nRecAnt ) )
   ( dbfTikT )->( OrdSetFocus( nOrdAnt ) )

   RECOVER USING oError

   msgStop( "Error al imprimir series de tickets.")

   END SEQUENCE

   ErrorBlock( oBlock )

Return nil

//----------------------------------------------------------------------------//

FUNCTION nTotComTik( cNumTik, dbfTikT, dbfTikL, nDouDiv, nDorDiv )

   local nTotal      := 0
   local nRecno      := ( dbfTikL )->( recNo() )

   if ( dbfTikL )->( dbSeek( cNumTik ) )

      while ( dbfTikL )->cSerTil + ( dbfTikL )->cNumTil + ( dbfTikL )->cSufTil == cNumTik .AND. !( dbfTikL )->( eof() )

         if !( dbfTikL )->lFreTil .or. ( dbfTikT )->cTipTik == SAVDEV

            nTotal   += nTotLTpv( dbfTikL, nDouDiv, nDorDiv ) * ( dbfTikT )->nComAge

         end if

         ( dbftikl )->( dbskip(1) )

      end while

   end if

   ( dbfTikL )->( dbGoTo( nRecno ) )

   /*
   Total en la moneda de documento
   */

   nTotal            := Round( nTotal, nDorDiv )

RETURN ( nTotal )

//----------------------------------------------------------------------------//

FUNCTION aTotTik( cNumTik, dbfTikT, dbfTikL, dbfDiv, aTmp, cDivRet, lPic, lExcCnt )

   nTotTik( cNumTik, dbfTikT, dbfTikL, dbfDiv, aTmp, cDivRet, lPic, lExcCnt )

RETURN ( { nTotNet, nTotIva, nTotTik, nTotIvm, aIvaTik, aBasTik, aImpTik, aIvmTik } )

//----------------------------------------------------------------------------//
/*
Recalcula el total
*/

STATIC FUNCTION lRecTotal( aTmp )

   local nTotal

   nTotal         := nTotTik( aTmp[ _CSERTIK ] + aTmp[ _CNUMTIK ] + aTmp[ _CSUFTIK ], dbfTikT, dbfTmpL, dbfDiv, aTmp, nil, .f. )

   if oNumTot != NIL
      oNumTot:SetText( Trans( nTotal, cPorDiv ) )
   end if

   if oEurTot != NIL
      oEurTot:SetText( Trans( nCnv2Div( nTotal, aTmp[ _CDIVTIK ], cDivChg() ), cPicEur ) )
   end if

   if oTxtTot != NIL
      oTxtTot:SetText( "Total" )
   end if

   if oTxtCom != nil
      oTxtCom:SetText( "Comensales: " + AllTrim( Str( aTmp[ _NNUMCOM ] ) ) )
   end if

   if oTotCom != nil
      oTotCom:SetText( AllTrim( Trans( nTotal / NotCero( aTmp[ _NNUMCOM ] ), cPorDiv ) ) + " pax." )
   end if

RETURN .T.

//----------------------------------------------------------------------------//

Function nTotUCobTik( dbfTikP, nDorDiv, nVdv )

   local nTotCob  := 0

   DEFAULT nVdv   := 1

   do case
      case ValType( dbfTikP ) == "C"
         nTotCob  := ( dbfTikP )->nImpTik - ( dbfTikP )->nDevTik
      case ValType( dbfTikP ) == "O"
         nTotCob  := dbfTikP:nImpTik - dbfTikP:nDevTik
   end case

   if nDorDiv != nil
      nTotCob     := Round( nTotCob, nDorDiv )
   end if

   if nVdv != 0
      nTotCob     := nTotCob / nVdv
   end if

Return ( nTotCob )

//--------------------------------------------------------------------------//
// Devuelve el total de cobrado en un tiket
//

FUNCTION nTotLCobTik( dbfTikP, dbfDiv, cDivRet, lPic )

   local cPorDiv
   local nDorDiv
   local cCodDiv
   local nTotal      := 0

   DEFAULT lPic      := .f.

   do case
      case Valtype( dbfTikP ) == "C"
         cCodDiv     := ( dbfTikP )->cDivPgo
      case Valtype( dbfTikP ) == "O"
         cCodDiv     := dbfTikP:cDivPgo
   end case

   cPorDiv           := cPorDiv( cCodDiv, dbfDiv ) // Picture de la divisa redondeada
   nDorDiv           := nRouDiv( cCodDiv, dbfDiv ) // Decimales de redondeo

   nTotal            := nTotUCobTik( dbfTikP, nDorDiv )

   if cDivRet != nil .and. cCodDiv != cDivRet
      cPorDiv        := cPorDiv( cDivRet, dbfDiv ) // Picture de la divisa redondeada
      nTotal         := nCnv2Div( nTotal, cCodDiv, cDivRet )
   end if



   if lPic
      nTotal         := Trans( nTotal, cPorDiv )
   end if

RETURN ( nTotal )

//--------------------------------------------------------------------------//
// Devuelve el total de cobrado en un tiket
//

FUNCTION nTotCobTik( cNumTik, dbfTikP, dbfDiv, cDivRet, lPic )

   local bCon
   local cPorDiv
   local nDorDiv
   local nTotal      := 0
   local cCodDiv     := ( dbfTikP )->cDivPgo
   local aSta        := aGetStatus( dbfTikP, .t. )

   DEFAULT lPic      := .f.

   IF cNumTik == nil
      bCon           := {|| !( dbfTikP )->( eof() ) }
      ( dbfTikP )->( dbGoTop() )
   ELSE
      bCon           := {|| ( dbfTikP )->cSerTik + ( dbfTikP )->cNumTik + ( dbfTikP )->cSufTik == cNumTik .and. !( dbfTikP )->( eof() ) }
      ( dbfTikP )->( dbSeek( cNumTik ) )
   END IF

   cPorDiv           := cPorDiv( cCodDiv, dbfDiv ) // Picture de la divisa redondeada
   nDorDiv           := nRouDiv( cCodDiv, dbfDiv ) // Decimales de redondeo

   while Eval( bCon )
      nTotal         += nTotUCobTik( dbfTikP, nDorDiv )
      ( dbfTikP )->( dbSkip() )
   end while

   nTotal            := Round( nTotal, nDorDiv )

   SetStatus( dbfTikP, aSta )

   if cDivRet != nil .and. cCodDiv != cDivRet
      cPorDiv        := cPorDiv( cDivRet, dbfDiv ) // Picture de la divisa redondeada
      nTotal         := nCnv2Div( nTotal, cCodDiv, cDivRet )
   end if

RETURN ( if( lPic, Trans( nTotal, cPorDiv ), nTotal ) )

//----------------------------------------------------------------------------//
/*
Total en vales de un tiket
*/

FUNCTION nTotValTik( cNumTik, dbfTikT, dbfTikL, dbfDiv, cDivRet, lPic )

   local cPorDiv
   local nDorDiv
   local nOrdAnt
   local nTotal      := 0
   local cCodDiv     := ( dbfTikT )->cDivTik
   local nRecAnt     := ( dbfTikT )->( Recno() )

   DEFAULT lPic      := .f.

   cPorDiv           := cPorDiv( cCodDiv, dbfDiv ) // Picture de la divisa redondeada
   nDorDiv           := nRouDiv( cCodDiv, dbfDiv ) // Decimales de redondeo

   if cNumTik == nil
      ( dbfTikT )->( dbGoTop() )
      while !( dbfTikT )->( eof() )
         nTotal      += nTotTik( ( dbfTikT )->cSerTik + ( dbfTikT )->cNumTik + ( dbfTikT )->cSufTik, dbfTikT, dbfTikL, dbfDiv, nil, cDivRet, .f. )
         ( dbfTikT )->( dbSkip() )
      end while
   else
      nOrdAnt        := ( dbfTikT )->( OrdSetFocus( "cDocVal" ) )
      if ( dbfTikT )->( dbSeek( cNumTik ) )
         while ( dbfTikT )->cValDoc == cNumTik .and. !( dbfTikT )->( eof() )
            nTotal   += nTotTik( ( dbfTikT )->cSerTik + ( dbfTikT )->cNumTik + ( dbfTikT )->cSufTik, dbfTikT, dbfTikL, dbfDiv, nil, cDivRet, .f. )
            ( dbfTikT )->( dbSkip() )
         end while
      end if
   end if

   /*
   Reposicionamiento-----------------------------------------------------------
   */

   if !Empty( nOrdAnt )
      ( dbfTikT )->( OrdSetFocus( nOrdAnt ) )
   end if

   ( dbfTikT )->( dbGoTo( nRecAnt ) )

   /*
   El total de los vales siempre debe de ser positivo--------------------------
   */

   nTotal            := Abs( Round( nTotal, nDorDiv ) )

   /*
   Otras divisas---------------------------------------------------------------
   */

   if cDivRet != nil .and. cCodDiv != cDivRet
      cPorDiv        := cPorDiv( cDivRet, dbfDiv ) // Picture de la divisa redondeada
      nTotal         := nCnv2Div( nTotal, cCodDiv, cDivRet )
   end if

RETURN ( if( lPic, Trans( nTotal, cPorDiv ), nTotal ) )

//----------------------------------------------------------------------------//

STATIC FUNCTION BeginTrans( aTmp, aGet, nMode, lNewFile )

   local oError
   local oBlock
   local nRecAnt
   local nOrdAnt
   local lErrors        := .f.
   local cNumTik        := aTmp[ _CSERTIK ] + aTmp[ _CNUMTIK ] + aTmp[ _CSUFTIK ]

   DEFAULT lNewFile     := .t.

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   if Empty( aTmp[ _CDIVTIK ] )
      aTmp[ _CDIVTIK ]  := cDivEmp()
   end if

   /*
   Pictures--------------------------------------------------------------------
   */

   cPouDiv              := cPouDiv( aTmp[ _CDIVTIK ], dbfDiv )       // Picture de la divisa
   cPorDiv              := cPorDiv( aTmp[ _CDIVTIK ], dbfDiv )       // Picture de la divisa redondeada
   nDouDiv              := nDouDiv( aTmp[ _CDIVTIK ], dbfDiv )       // Decimales
   nDorDiv              := nRouDiv( aTmp[ _CDIVTIK ], dbfDiv )       // Decimales redondeados
   cPicEur              := cPorDiv( cDivChg(),        dbfDiv )       // Picture de la divisa equivalente

   /*
   Variable para saber si han añadido lineas ----------------------------------
   */

   lNowAppendLine       := .f.

   /*
   Crear la base de datos local para las lineas de detalle---------------------
   */

   if lNewFile

      ( dbfTmpL )->( dbCloseArea() )
      ( dbfTmpP )->( dbCloseArea() )
      ( dbfTmpV )->( dbCloseArea() )
      ( dbfTmpA )->( dbCloseArea() )
      ( dbfTmpE )->( dbCloseArea() )

      if !Empty( cNewFilL )
         dbfErase( cNewFilL )
      end if

      if !Empty( cNewFilP )
         dbfErase( cNewFilP )
      end if

      if !Empty( cNewFilV )
         dbfErase( cNewFilV )
      end if

      if !Empty( cNewFilA )
         dbfErase( cNewFilA )
      end if

      if !Empty( cNewFilE )
         dbfErase( cNewFilE )
      end if

      cNewFilL       := cGetNewFileName( cPatTmp() + "TikL" )
      dbCreate( cNewFilL, aSqlStruct( aColTik() ), cLocalDriver() )
      dbUseArea( .t., cLocalDriver(), cNewFilL, cCheckArea( "TikL", @dbfTmpL ), .f. )
      if !NetErr()
         ( dbfTmpL )->( OrdCondSet( "!Deleted()", {||!Deleted() } ) )
         ( dbfTmpL )->( OrdCreate( cNewFilL, "Recno", "Str( Recno() )", {|| Str( Recno() ) } ) )
      end if

      /*
      Crear la base de datos local para los pagos del ticket-------------------
		*/

      cNewFilP       := cGetNewFileName( cPatTmp() + "TikP" )
      dbCreate( cNewFilP, aSqlStruct( aPgoTik() ), cLocalDriver() )
      dbUseArea( .t., cLocalDriver(), cNewFilP, cCheckArea( "TikP", @dbfTmpP ), .f. )
      if !NetErr()
         ( dbfTmpP )->( OrdCondSet( "!Deleted()", {||!Deleted() } ) )
         ( dbfTmpP )->( OrdCreate( cNewFilP, "Recno", "Str( Recno() )", {|| Str( Recno() ) } ) )
      end if

      /*
      Crear la base de datos local para los vales del ticket-------------------
      */

      cNewFilV       := cGetNewFileName( cPatTmp() + "TikV"  )
      dbCreate( cNewFilV, aSqlStruct( aItmTik() ), cLocalDriver() )
      dbUseArea( .t., cLocalDriver(), cNewFilV, cCheckArea( "TikV", @dbfTmpV ), .f. )
      if !NetErr()
         ( dbfTmpV )->( OrdCondSet( "!Deleted()", {||!Deleted() } ) )
         ( dbfTmpV )->( OrdCreate( cNewFilV, "Recno", "Str( Recno() )", {|| Str( Recno() ) } ) )
      end if

      /*
      Crear la base de datos local para los anticipos del ticket---------------
      */

      cNewFilA       := cGetNewFileName( cPatTmp() + "TikA"  )
      dbCreate( cNewFilA, aSqlStruct( aItmAntCli() ), cLocalDriver() )
      dbUseArea( .t., cLocalDriver(), cNewFilA, cCheckArea( "TikA", @dbfTmpA ), .f. )
      if !NetErr()
         ( dbfTmpA )->( OrdCondSet( "!Deleted()", {||!Deleted() } ) )
         ( dbfTmpA )->( OrdCreate( cNewFilA, "Recno", "Str( Recno() )", {|| Str( Recno() ) } ) )
      end if

      /*
      Crear la base de datos local para las entregas a cuenta de albaranes-----
      */

      cNewFilE       := cGetNewFileName( cPatTmp() + "TikE"  )
      dbCreate( cNewFilE, aSqlStruct( aItmAlbPgo() ), cLocalDriver() )
      dbUseArea( .t., cLocalDriver(), cNewFilE, cCheckArea( "TikE", @dbfTmpE ), .f. )
      if !NetErr()
         ( dbfTmpE )->( OrdCondSet( "!Deleted()", {||!Deleted() } ) )
         ( dbfTmpE )->( OrdCreate( cNewFilE, "Recno", "Str( Recno() )", {|| Str( Recno() ) } ) )
      end if

   else

      ( dbfTmpL )->( __dbZap() )
      ( dbfTmpP )->( __dbZap() )
      ( dbfTmpV )->( __dbZap() )
      ( dbfTmpA )->( __dbZap() )
      ( dbfTmpE )->( __dbZap() )

      ( dbfTmpL )->( dbGoTop() )
      ( dbfTmpP )->( dbGoTop() )
      ( dbfTmpV )->( dbGoTop() )
      ( dbfTmpA )->( dbGoTop() )
      ( dbfTmpE )->( dbGoTop() )

   end if

   do case
   case nMode == APPD_MODE

      lApartado                        := .f.

      /*
      Cargando los valores por defecto-----------------------------------------
		*/

      aTmp[ _CCLITIK    ]              := ""
      aTmp[ _CNOMTIK    ]              := ""
      aTmp[ _CDIRCLI    ]              := ""
      aTmp[ _CPOBCLI    ]              := ""
      aTmp[ _CPRVCLI    ]              := ""
      aTmp[ _CPOSCLI    ]              := ""
      aTmp[ _CDNICLI    ]              := ""

      aTmp[ _LSNDDOC    ]              := .t.
      aTmp[ _LABIERTO   ]              := .t.
      aTmp[ _LPGDTIK    ]              := .f.
      aTmp[ _LCLOTIK    ]              := .f.
      aTmp[ _CTIPTIK    ]              := SAVTIK
      aTmp[ _CTURTIK    ]              := cCurSesion()
      aTmp[ _CSUFTIK    ]              := RetSufEmp()
      aTmp[ _DFECCRE    ]              := Date()
      aTmp[ _CTIMCRE    ]              := SubStr( Time(), 1, 5 )
      aTmp[ _DFECTIK    ]              := GetSysDate()
      aTmp[ _CALIASTIK  ]              := ""
      aTmp[ _CCODSALA   ]              := ""
      aTmp[ _CPNTVENTA  ]              := ""
      aTmp[ _NTARIFA    ]              := 1
      aTmp[ _NNUMCOM    ]              := 0

      /*
      Colocamos los valores de la sala-----------------------------------------
      */

      if !Empty( oSalaVentas ) .and. IsFalse( oSalaVentas:lPuntosVenta )
         aTmp[ _CCODSALA   ]           := oSalaVentas:cSelectedSala
         aTmp[ _CPNTVENTA  ]           := oSalaVentas:cSelectedPunto
         aTmp[ _NTARIFA    ]           := oSalaVentas:nSelectedPrecio
      end if

   case nMode == EDIT_MODE .or. nMode == ZOOM_MODE .or. nMode == DUPL_MODE

      if nMode == DUPL_MODE
         aTmp[ _CTURTIK ]              := cCurSesion()
      end if

      lApartado                        := ( aTmp[ _CTIPTIK ] == SAVAPT .or. aTmp[ _CTIPTIK ] == SAVTIK )

      aTmp[ _LSNDDOC ]                 := .t.


      if ( dbfTikT )->cTipTik == SAVALB

         LoaAlb2Tik()

         /*
         A¤adimos desde el fichero de entregas a cuenta------------------------
         */

         nRecAnt  := ( dbfAlbCliP )->( Recno() )
         nOrdAnt  := ( dbfAlbCliP )->( OrdSetFocus( "NNUMALB" ) )

         if ( dbfAlbCliP )->( dbSeek( ( dbfTikT )->cNumDoc ) )
            while ( ( dbfAlbCliP )->cSerAlb + Str( ( dbfAlbCliP )->nNumAlb ) + ( dbfAlbCliP )->cSufAlb ) == ( dbfTikT )->cNumDoc .and. !( dbfAlbCliP )->( eof() )
               dbPass( dbfAlbCliP, dbfTmpE, .t. )
               ( dbfAlbCliP )->( dbSkip() )
            end while
         end if
         ( dbfTmpE )->( dbGoTop() )

         ( dbfAlbCliP )->( OrdSetFocus( nOrdAnt ) )
         ( dbfAlbCliP )->( dbGoTo( nRecAnt ) )

      elseif ( dbfTikT )->cTipTik == SAVFAC

         if ( dbfFacCliL )->( dbSeek( ( dbfTikT )->cNumDoc ) )
            while ( ( dbfFacCliL )->cSerie + Str( ( dbfFacCliL )->nNumFac ) + ( dbfFacCliL )->cSufFac == ( dbfTikT )->cNumDoc .and. !( dbfFacCliL )->( eof() ) )

               ( dbfTmpL )->( dbAppend() )
               ( dbfTmpL )->cCbaTil    := ( dbfFacCliL )->cRef
               ( dbfTmpL )->cNomTil    := ( dbfFacCliL )->cDetalle
               ( dbfTmpL )->nPvpTil    := ( dbfFacCliL )->nPreUnit // ( ( dbfFacCliL )->NPREUNIT * ( dbfFacCliL )->NIVA / 100 ) + ( dbfFacCliL )->NPREUNIT
               ( dbfTmpL )->nDtoLin    := ( dbfFacCliL )->nDto
               ( dbfTmpL )->nIvaTil    := ( dbfFacCliL )->nIva
               ( dbfTmpL )->cCodPr1    := ( dbfFacCliL )->cCodPr1
               ( dbfTmpL )->cCodPr2    := ( dbfFacCliL )->cCodPr2
               ( dbfTmpL )->cValPr1    := ( dbfFacCliL )->cValPr1
               ( dbfTmpL )->cValPr2    := ( dbfFacCliL )->cValPr2
               ( dbfTmpL )->nFacCnv    := ( dbfFacCliL )->nFacCnv
               ( dbfTmpL )->nDtoDiv    := ( dbfFacCliL )->nDtoDiv
               ( dbfTmpL )->nCtlStk    := ( dbfFacCliL )->nCtlStk
               ( dbfTmpL )->nValImp    := ( dbfFacCliL )->nValImp
               ( dbfTmpL )->cCodImp    := ( dbfFacCliL )->cCodImp
               ( dbfTmpL )->mNumSer    := ( dbfFacCliL )->mNumSer
               ( dbfTmpL )->nUntTil    := nTotNFacCli( dbfFacCliL )
               ( dbfTmpL )->( dbUnLock() )

               ( dbfFacCliL )->( dbSkip() )

            end while
         end if
         ( dbfTmpL )->( dbGoTop() )

         /*
         Importamos los pagos--------------------------------------------------------
         */

         if ( dbfFacCliP )->( dbSeek( ( dbfTikT )->cNumDoc ) )

            while ( dbfFacCliP )->cSerie + Str( ( dbfFacCliP )->nNumFac ) + ( dbfFacCliP )->cSufFac == ( dbfTikT )->cNumDoc .and. !( dbfFacCliP )->( eof() )

               if ( dbfFacCliP )->lCobrado
                  ( dbfTmpP )->( dbAppend() )
                  ( dbfTmpP )->cCodCaj    := ( dbfFacCliP )->cCodCaj
                  ( dbfTmpP )->dPgoTik    := ( dbfFacCliP )->dEntrada
                  ( dbfTmpP )->nImpTik    := ( dbfFacCliP )->nImporte
                  ( dbfTmpP )->cDivPgo    := ( dbfFacCliP )->cDivPgo
                  ( dbfTmpP )->nVdvPgo    := ( dbfFacCliP )->nVdvPgo
                  ( dbfTmpP )->cPgdPor    := ( dbfFacCliP )->cPgdoPor
                  ( dbfTmpP )->cTurPgo    := ( dbfFacCliP )->cTurRec
                  ( dbfTmpP )->cCtaRec    := ( dbfFacCliP )->cCtaRec
                  ( dbfTmpP )->cFpgPgo    := ( dbfFacCliP )->cCodPgo
               end if

               ( dbfFacCliP )->( dbSkip() )

            end while

         end if

         /*
         A¤adimos desde el fichero de Anticipos-----------------------------------
         */

         nRecAnt  := ( dbfAntCliT )->( Recno() )
         nOrdAnt  := ( dbfAntCliT )->( OrdSetFocus( "cNumDoc" ) )

         if ( dbfAntCliT )->( dbSeek( ( dbfTikT )->cNumDoc ) )
            while ( dbfAntCliT )->cNumDoc == ( dbfTikT )->cNumDoc .and. !( dbfAntCliT )->( eof() )
               dbPass( dbfAntCliT, dbfTmpA, .t. )
               ( dbfAntCliT )->( dbSkip() )
            end while
         end if
         ( dbfTmpA )->( dbGoTop() )

         ( dbfAntCliT )->( OrdSetFocus( nOrdAnt ) )
         ( dbfAntCliT )->( dbGoTo( nRecAnt ) )

      else

         /*
         Añadimos desde el fichero de lineas-----------------------------------
         */

         if ( dbfTikL )->( dbSeek( cNumTik ) )
            while ( ( dbfTikL )->cSerTil + ( dbfTikL )->cNumTil + ( dbfTikL )->cSufTil == cNumTik .AND. !( dbfTikL )->( eof() ) )
               dbPass( dbfTikL, dbfTmpL, .t. )
               ( dbfTikL )->( dbSkip() )
            end while
         end if

         ( dbfTmpL )->( dbGoTop() )

         /*
         A¤adimos desde el fichero de PAGOS---------------------------------------
         */

         if ( dbfTikP )->( dbSeek( cNumTik ) )
            while ( ( dbfTikP )->cSerTik + ( dbfTikP )->cNumTik + ( dbfTikP )->cSufTik == cNumTik .AND. !( dbfTikP )->( eof() ) )
               dbPass( dbfTikP, dbfTmpP, .t. )
               ( dbfTikP )->( dbSkip() )
            end while
         end if

         ( dbfTmpP )->( dbGoTop() )

         /*
         Añadimos desde los vales----------------------------------------------
         */

         nRecAnt     := ( dbfTikT )->( Recno() )
         nOrdAnt     := ( dbfTikT )->( OrdSetFocus( "cDocVal" ) )

         if ( dbfTikT )->( dbSeek( cNumTik ) )
            while ( dbfTikT )->cValDoc == cNumTik .and. !( dbfTikT )->( eof() )
               dbPass( dbfTikT, dbfTmpV, .t. )
               ( dbfTikT )->( dbSkip() )
            end while
         end if

         ( dbfTikT )->( dbGoTo( nRecAnt ) )
         ( dbfTikT )->( OrdSetFocus( nOrdAnt ) )

         ( dbfTmpV )->( dbGoTop() )

         /*
         Creamos un ponto de venta---------------------------------------------
         */

         oSalaVentas:SetSalaVta( aTmp, dbfTikT )

      end if

   end case

   /*
   Valores por defecto---------------------------------------------------------
   */

   if Empty( aTmp[ _CCLITIK ] )
      if !Empty( aGet[ _CCLITIK ] )
         aGet[ _CCLITIK ]:cText( cDefCli() )
      else
         aTmp[ _CCLITIK ]  := cDefCli()
      end if
   end if

   if Empty( aTmp[ _CNOMTIK ] )
      if !Empty( aGet[ _CNOMTIK ] )
         aGet[ _CNOMTIK ]:cText( RetFld( cDefCli(), dbfClient, "Titulo" ) )
      else
         aTmp[ _CNOMTIK ] := RetFld( cDefCli(), dbfClient, "Titulo"  )
      end if
   end if

   /*
   Cargamos valores en la OfficeBar para el caso del táctil--------------------
   */

   cTextoOfficeBar( aTmp )

   /*
   Desabilitamos los botones de up y down para el caso del tactil--------------
   */

   if !Empty( oBtnUp ) .and. !Empty( oBtnUp )

      if nMode == APPD_MODE
         oBtnUp:lEnabled   := .f.
         oBtnDown:lEnabled := .f.
      else
         oBtnUp:lEnabled   := .t.
         oBtnDown:lEnabled := .t.
      end if

   end if

   if Empty( aTmp[ _NTARIFA ] )
      if !Empty( aGet[ _NTARIFA ] )
         aGet[ _NTARIFA ]:cText( 1 )
      else
         aTmp[ _NTARIFA ] := 1
      end if
   end if

   if Empty( aTmp[ _CSERTIK ] )
      if !Empty( aGet[ _CSERTIK ] )
         aGet[ _CSERTIK ]:cText( cNewSer( "NTIKCLI", dbfCount ) )
      else
         aTmp[ _CSERTIK ] := cNewSer( "NTIKCLI", dbfCount )
      end if
   end if

   if Empty( aTmp[ _CNCJTIK ] )
      if !Empty( aGet[ _CNCJTIK ] )
         aGet[ _CNCJTIK ]:cText( oUser():cCaja() )
      else
         aTmp[ _CNCJTIK ] := oUser():cCaja()
      end if
   end if

   if Empty( aTmp[ _CALMTIK ] )
      if !Empty( aGet[ _CALMTIK ] )
         aGet[ _CALMTIK ]:cText( oUser():cAlmacen() )
      else
         aTmp[ _CALMTIK ] := oUser():cAlmacen()
      end if
   end if

   if Empty( aTmp[ _CCCJTIK ] )
      if !Empty( aGet[ _CCCJTIK ] )
         aGet[ _CCCJTIK ]:cText( cCurUsr() )
      else
         aTmp[ _CCCJTIK ] := cCurUsr()
      end if
   end if

   if Empty( aTmp[ _CCODPRO ] )
      if !Empty( aGet[ _CCODPRO ] )
         aGet[ _CCODPRO ]:cText( cProCnt() )
      else
         aTmp[ _CCODPRO ] := cProCnt()
      end if
   end if

   if Empty( aTmp[ _CCODDLG ] )
      if !Empty( aGet[ _CCODDLG ] )
         aGet[ _CCODDLG ]:cText( RetFld( cCurUsr(), dbfUsr, "cCodDlg" ) )
      else
         aTmp[ _CCODDLG ] := RetFld( cCurUsr(), dbfUsr, "cCodDlg" )
      end if
   end if

   /*
   Este valor los guaradamos para detectar los posibles cambios----------------
   */

   cOldCodCli           := aTmp[ _CCLITIK ]

   /*
   Etiquetas-------------------------------------------------------------------
   */

   if !Empty( aGetTxt )
      aGetTxt[ 1 ]      := RetFld( aTmp[ _CNCJTIK ], dbfCajT )
      aGetTxt[ 2 ]      := RetFld( aTmp[ _CALMTIK ], dbfAlm )
      aGetTxt[ 3 ]      := RetFld( aTmp[ _CFPGTIK ], dbfFPago )
      aGetTxt[ 5 ]      := RetFld( aTmp[ _CCLITIK ] + aTmp[ _CCODOBR ], dbfObrasT, "cNomObr" )
      aGetTxt[ 6 ]      := RetFld( aTmp[ _CCODAGE ], dbfAgent )
      aGetTxt[ 7 ]      := RetFld( aTmp[ _CCODRUT ], dbfRuta )
      aGetTxt[ 8 ]      := RetFld( aTmp[ _CCODTAR ], dbfTarPreS )
      aGetTxt[ 9 ]      := RetFld( aTmp[ _CCLITIK ], dbfClient,   "Telefono" )
      aGetTxt[ 10]      := RetFld( aTmp[ _CCCJTIK ], dbfUsr,      "cNbrUse" )
   end if

   if oRieCli != nil
      GetRiesgo( aTmp[ _CCLITIK ], dbfClient, oRieCli )
   end if

   /*
   Marca para saber si el tiket se guardo previamente--------------------------
   */

   lSave                := .f.

   /*
   if !Empty( ( dbfUsr )->cImagen )
      oBmpVis:LoadBmp( cFileBmpName( ( dbfUsr )->cImagen ) )
   end if
   */

   /*
   Refrescamos el browse-------------------------------------------------------
   */

   if !Empty( oBrwDet )
      oBrwDet:Refresh()
   end if

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Imposible crear tablas temporales." )

      KillTrans()

      lErrors     := .t.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lErrors )

//---------------------------------------------------------------------------//

STATIC FUNCTION KillTrans( oBrwPgo, oBrwVal )

   if !Empty( dbfTmpL ) .and. ( dbfTmpL )->( Used() )
      ( dbfTmpL )->( dbCloseArea() )
   end if

   if !Empty( dbfTmpP ) .and. ( dbfTmpP )->( Used() )
      ( dbfTmpP )->( dbCloseArea() )
   end if

   if !Empty( dbfTmpV ) .and. ( dbfTmpV )->( Used() )
      ( dbfTmpV )->( dbCloseArea() )
   end if

   if !Empty( dbfTmpA ) .and. ( dbfTmpA )->( Used() )
      ( dbfTmpA )->( dbCloseArea() )
   end if

   if !Empty( dbfTmpE ) .and. ( dbfTmpE )->( Used() )
      ( dbfTmpE )->( dbCloseArea() )
   end if

   dbfErase( cNewFilL )
   dbfErase( cNewFilP )
   dbfErase( cNewFilV )
   dbfErase( cNewFilA )
   dbfErase( cNewFilE )

RETURN .T.

//------------------------------------------------------------------------//

/*
Funcion Auxiliar para A¤adir lineas de detalle
*/

STATIC FUNCTION AppDetRec( oBrw, bEditL, aTmp, cPorDiv, cPicEur, cCodArt )

   SysRefresh()

   /*
   Variable para saber si han añadido lineas ----------------------------------
   */

   lNowAppendLine       := .t.

   while WinAppRec( oBrw, bEditL, dbfTmpL, , cCodArt, aTmp )
      if !Empty( cCodArt )
         cCodArt        := nil
      end if
   end while

RETURN ( lRecTotal( aTmp ) )

//--------------------------------------------------------------------------//
/*
Edita las lineas de detalle
*/

STATIC FUNCTION EdtDet( aTmp, aGet, dbfTmpL, oBrw, bWhen, cCodArt, nMode, aTik )

   local n
   local oCol
   local aPos
   local oDlg
	local oBtn
   local nTop
   local lTwo              := .f.
   local nLeft
   local nWidth
   local nHeight
   local oBtnSer
   local oGetTotal
	local nGetTotal			:= 0
   local lMsgVta           := .f.
   local lNotVta           := .f.
   local cName
   local nCaptura

   /*
   Posiones donde colocar el dialogo y valores por defecto---------------------
   */

   if nMode == APPD_MODE

      oBrw:GoBottom()
      aTmp[ _NUNTTIL ]     := 1
      aTmp[ _NMEDUNO ]     := 0
      aTmp[ _NMEDDOS ]     := 0
      aTmp[ _NMEDTRE ]     := 0
      aTmp[ _CNUMTIL ]     := aTik[ _CNUMTIK ]
      aTmp[ _CALMLIN ]     := aTik[ _CALMTIK ]
      aTmp[ _NNUMLIN ]     := nLastNum( dbfTmpL )
      aTmp[ _NIVATIL ]     := nIva( dbfIva, cDefIva() )

      if ( dbfTmpL )->( eof() )
         nTop              := ( ( oBrw:nRowSel - 1 ) * oBrw:nRowHeight ) + oBrw:HeaderHeight() - 1
      else
         nTop              := ( ( oBrw:nRowSel ) * oBrw:nRowHeight ) + oBrw:HeaderHeight() - 1
      end if

      if !Empty( cCodArt )
         aTmp[ _CCBATIL ]  := cCodArt
      end if

  else

      nTop                 := ( ( oBrw:nRowSel - 1 ) * oBrw:nRowHeight ) + oBrw:HeaderHeight() - 1

   end if

   /*
   Calculamos las posiones-----------------------------------------------------
   */

   nLeft                   := 25

   aPos                    := { nTop, nLeft }
   aPos                    := ClientToScreen( oBrw:hWnd, aPos )

   nTop                    := aPos[ 1 ]
   nLeft                   := aPos[ 2 ]
   nHeight                 := oBrw:nRowHeight + nTop
   nWidth                  := oBrw:BrwWidth() + nLeft - 15

   /*
   Este valor los guaradamos para detectar los posibles cambios----------------
   */

   cOldCodArt              := aTmp[ _CCBATIL ]
   cOldPrpArt              := aTmp[ _CCODPR1 ] + aTmp[ _CCODPR2 ] + aTmp[ _CVALPR1 ] + aTmp[ _CVALPR2 ]

   /*
   Caja de dialogo-------------------------------------------------------------
   */

   DEFINE DIALOG  oDlg ;
      FROM        nTop, nLeft TO nHeight, nWidth ;
      STYLE       nOR( WS_VISIBLE, WS_POPUP, 4 ) ;
      OF          oBrw ;
      PIXEL ;

      for each oCol in oBrw:aCols

      /*
      if oCaptura:oCapCampos:oDbf:Seek( cCapCaj )

         while oCaptura:oCapCampos:oDbf:cCodigo == cCapCaj .and. !oCaptura:oCapCampos:oDbf:eof()

            if oCaptura:oCapCampos:oDbf:lVisible
      */

         cName       := oCol:Cargo[ 1 ]
         nCaptura    := oCol:Cargo[ 2 ]

         do case
            case cName == "Código del artículo"

               @ 0, 0 GET  aGet[ _CCBATIL ] VAR aTmp[ _CCBATIL ] ;
                           NOBORDER ;
                           FONT     oBrw:oFont ;
                           WHEN     ( nMode == APPD_MODE ) ;
                           BITMAP   "LUPA" ;
                           OF       oDlg

               aGet[ _CCBATIL ]:bLostFocus         := {|| LoaArt( aGet, aTmp, oBrw, oGetTotal, aTik, lTwo, nMode, oDlg, @lMsgVta, @lNotVta ) }
               aGet[ _CCBATIL ]:bValid             := {|| lCodigoArticulo( aGet, aTmp, .t. ) }
               aGet[ _CCBATIL ]:bHelp              := {|| BrwArticulo( aGet[ _CCBATIL ], aGet[ _CNOMTIL ] ) }

               do case
               case nCaptura == 1
                  aGet[ _CCBATIL ]:bWhen           := {|| .f. }
               case nCaptura == 2
                  aGet[ _CCBATIL ]:bValid          := {|| lCodigoArticulo( aGet, aTmp, .t. ) .and. !Empty( aTmp[ _CCBATIL ] ) }
               case nCaptura == 3
                  aGet[ _CCBATIL ]:lNeedGetFocus   := .t.
               end if

               aGet[ _CCBATIL ]:Cargo              := "Código del artículo"

            case cName == "Unidades"

               @ 0, 0 GET  aGet[ _NUNTTIL ] VAR aTmp[ _NUNTTIL ] ;
                           NOBORDER ;
                           PICTURE  cPicUnd ;
                           RIGHT ;
                           ON CHANGE( lCalcDeta( aTmp, oGetTotal ) ) ;
                           OF       oDlg

               do case
               case nCaptura == 1
                  aGet[ _NUNTTIL ]:bWhen           := {|| .f. }
               case nCaptura == 2
                  aGet[ _NUNTTIL ]:bValid          := {|| !Empty( aTmp[ _NUNTTIL ] ) }
               case nCaptura == 3
                  aGet[ _NUNTTIL ]:lNeedGetFocus   := .t.
               end if

               aGet[ _NUNTTIL ]:Cargo              := "Unidades"

            case cName == "Medición 1"

               @ 0, 0 GET  aGet[ _NMEDUNO ] VAR aTmp[ _NMEDUNO ] ;
                           NOBORDER ;
                           PICTURE  cPicUnd ;
                           RIGHT ;
                           ON CHANGE( lCalcDeta( aTmp, oGetTotal ) ) ;
                           OF       oDlg

               do case
               case nCaptura == 1
                  aGet[ _NMEDUNO ]:bWhen           := {|| .f. }
               case nCaptura == 2
                  aGet[ _NMEDUNO ]:bValid          := {|| .t. }
               case nCaptura == 3
                  aGet[ _NMEDUNO ]:lNeedGetFocus   := .t.
               end if

               aGet[ _NMEDUNO ]:Cargo              := "Medición 1"

            case cName == "Medición 2"

               @ 0, 0 GET  aGet[ _NMEDDOS ] VAR aTmp[ _NMEDDOS ] ;
                           NOBORDER ;
                           PICTURE  cPicUnd ;
                           RIGHT ;
                           ON CHANGE( lCalcDeta( aTmp, oGetTotal ) ) ;
                           OF       oDlg

               do case
               case nCaptura == 1
                  aGet[ _NMEDDOS ]:bWhen           := {|| .f. }
               case nCaptura == 2
                  aGet[ _NMEDDOS ]:bValid          := {|| .t. }
               case nCaptura == 3
                  aGet[ _NMEDDOS ]:lNeedGetFocus   := .t.
               end if

               aGet[ _NMEDDOS ]:Cargo              := "Medición 2"

            case cName == "Medición 3"

               @ 0, 0 GET  aGet[ _NMEDTRE ] VAR aTmp[ _NMEDTRE ] ;
                           NOBORDER ;
                           PICTURE  cPicUnd ;
                           RIGHT ;
                           ON CHANGE( lCalcDeta( aTmp, oGetTotal ) ) ;
                           OF       oDlg

               do case
               case nCaptura == 1
                  aGet[ _NMEDTRE ]:bWhen           := {|| .f. }
               case nCaptura == 2
                  aGet[ _NMEDTRE ]:bValid          := {|| .t. }
               case nCaptura == 3
                  aGet[ _NMEDTRE ]:lNeedGetFocus   := .t.
               end if

               aGet[ _NMEDTRE ]:Cargo              := "Medición 3"

            case cName == "Propiedad 1"

               @ 0, 0 GET  aGet[ _CVALPR1 ] VAR aTmp[ _CVALPR1 ];
                           NOBORDER ;
                           FONT     oBrw:oFont ;
                           PICTURE  "@!" ;
                           WHEN     ( !Empty( aTmp[_CCODPR1 ] ) .and. lUsePrp1() ) ;
                           BITMAP   "LUPA" ;
                           ON HELP  ( brwPropiedadActual( aGet[_CVALPR1], nil, aTmp[_CCODPR1 ] ) ) ;
                           OF       oDlg

               aGet[ _CVALPR1 ]:bLostFocus         := {|| if(  lPrpAct( aTmp[ _CVALPR1 ], nil, aTmp[ _CCODPR1 ], dbfTblPro ),;
                                                               LoaArt( aGet, aTmp, oBrw, oGetTotal, aTik, lTwo, nMode, oDlg, @lMsgVta, @lNotVta ),;
                                                               .f. ) }

               do case
               case nCaptura == 1
                  aGet[ _CVALPR1 ]:bWhen           := {|| .f. }
               case nCaptura == 2
                  aGet[ _CVALPR1 ]:bWhen           := {|| !Empty( aTmp[ _CCODPR1 ] ) }
               case nCaptura == 3
                  aGet[ _CVALPR1 ]:lNeedGetFocus   := .t.
               end case

            case cName == "Propiedad 2"

               @ 0, 0 GET  aGet[ _CVALPR2 ] VAR aTmp[ _CVALPR2 ];
                           NOBORDER ;
                           FONT     oBrw:oFont ;
                           PICTURE  "@!" ;
                           WHEN     ( !Empty( aTmp[_CCODPR2 ] ) .and. lUsePrp2() ) ;
                           BITMAP   "LUPA" ;
                           ON HELP  ( brwPropiedadActual( aGet[_CVALPR2], nil, aTmp[_CCODPR2 ] ) ) ;
                           OF       oDlg

               aGet[ _CVALPR2 ]:bLostFocus         := {|| if(  lPrpAct( aTmp[ _CVALPR2 ], nil, aTmp[ _CCODPR2 ], dbfTblPro ),;
                                                               LoaArt( aGet, aTmp, oBrw, oGetTotal, aTik, lTwo, nMode, oDlg, @lMsgVta, @lNotVta ),;
                                                               .f. ) }

               do case
               case nCaptura == 1
                  aGet[ _CVALPR2 ]:bWhen           := {|| .f. }
               case nCaptura == 2
                  aGet[ _CVALPR2 ]:bWhen           := {|| !Empty( aTmp[ _CCODPR2 ] ) }
               case nCaptura == 3
                  aGet[ _CVALPR2 ]:lNeedGetFocus   := .t.
               end case

            case cName == "Lote"

               @ 0, 0 GET  aGet[ _CLOTE ] VAR aTmp[ _CLOTE ];
                           NOBORDER ;
                           FONT     oBrw:oFont ;
                           RIGHT ;
                           OF       oDlg

               do case
               case nCaptura == 1
                  aGet[ _CLOTE ]:bWhen           := {|| .f. }
               case nCaptura == 2
                  aGet[ _CLOTE ]:bWhen           := {|| !Empty( aTmp[ _CLOTE ] ) }
               case nCaptura == 3
                  aGet[ _CLOTE ]:lNeedGetFocus   := .t.
               end case

            case cName == "Detalle"

               @ 0, 0 GET  aGet[ _CNOMTIL ] VAR aTmp[ _CNOMTIL ];
                           NOBORDER ;
                           FONT     oBrw:oFont ;
                           WHEN     ( lModDes() ) ;
                           VALID    ( .t. );
                           OF       oDlg

               do case
               case nCaptura == 1
                  aGet[ _CNOMTIL ]:bWhen           := {|| .f. }
               case nCaptura == 2
                  aGet[ _CNOMTIL ]:bWhen           := {|| lModDes() .or. Empty( aTmp[ _CNOMTIL ] ) }
               case nCaptura == 3
                  aGet[ _CNOMTIL ]:lNeedGetFocus   := .t.
               end case

            case cName == "Importe"

               @ 0, 0 GET  aGet[ _NPVPTIL ] VAR aTmp[ _NPVPTIL ];
                           NOBORDER ;
                           FONT     oBrw:oFont ;
                           PICTURE  cPouDiv ;
                           RIGHT ;
                           ON CHANGE( lCalcDeta( aTmp, oGetTotal ) ) ;
                           OF       oDlg

               do case
               case nCaptura == 1
                  aGet[ _NPVPTIL ]:bWhen           := {|| .f. }
               case nCaptura == 2
                  aGet[ _NPVPTIL ]:bWhen           := {|| Empty( aTmp[ _NPVPTIL ] ) }
               case nCaptura == 3
                  aGet[ _NPVPTIL ]:lNeedGetFocus   := .t.
               end if

            case cName == "Descuento lineal"

               @ 0, 0 GET  aGet[ _NDTODIV ] VAR aTmp[ _NDTODIV ];
                           NOBORDER ;
                           FONT     oBrw:oFont ;
                           PICTURE  cPouDiv ;
                           RIGHT ;
                           ON CHANGE( lCalcDeta( aTmp, oGetTotal ) ) ;
                           COLOR    Rgb( 255, 0, 0 ) ;
                           OF       oDlg

               do case
               case nCaptura == 1
                  aGet[ _NDTODIV ]:bWhen           := {|| .f. }
               case nCaptura == 2
                  aGet[ _NDTODIV ]:bWhen           := {|| Empty( aTmp[ _NDTODIV ] ) }
               case nCaptura == 3
                  aGet[ _NDTODIV ]:lNeedGetFocus   := .t.
               end if

            case cName == "Descuento porcentual"

               @ 0, 0 GET  aGet[ _NDTOLIN ] VAR aTmp[ _NDTOLIN ];
                           NOBORDER ;
                           FONT     oBrw:oFont ;
                           PICTURE  "@E 99.99" ;
                           RIGHT ;
                           ON CHANGE( lCalcDeta( aTmp, oGetTotal ) ) ;
                           OF       oDlg

               do case
               case nCaptura == 1
                  aGet[ _NDTOLIN ]:bWhen           := {|| .f. }
               case nCaptura == 2
                  aGet[ _NDTOLIN ]:bWhen           := {|| Empty( aTmp[ _NDTOLIN ] ) }
               case nCaptura == 3
                  aGet[ _NDTOLIN ]:lNeedGetFocus   := .t.
               end if

            case cName == "Total"

               @ 0, 0 GET  oGetTotal VAR nGetTotal;
                           NOBORDER ;
                           FONT     oBrw:oFont ;
                           WHEN     .f. ;
                           PICTURE  cPorDiv ;
                           RIGHT ;
                           OF       oDlg

            case cName == "Número de serie"

               @ 0, 0 BUTTON oBtnSer ;
                           PROMPT   ( "&Series" );
                           FONT     oBrw:oFont ;
                           ACTION   ( aTmp[ _MNUMSER ] := EdtNumSer( aTmp[ _MNUMSER ], aTmp[ _NUNTTIL ], nMode ) ) ;
                           OF       oDlg

         end case

            /*
            end if

            oCaptura:oCapCampos:oDbf:Skip()

         end while

      end if
      */

      next

      // Botones ocultos__________________________________________________________

      @ 0, 0 BUTTON  oBtn ;
                     PROMPT   ( if( nMode == APPD_MODE, "&A", "&M" ) );
                     DEFAULT ;
                     FONT     oBrw:oFont ;
                     WHEN     ( nMode != ZOOM_MODE ) ;
                     ACTION   ( SavLine( aTmp, aGet, dbfTmpL, oBrw, aTik, oGetTotal, lTwo, nMode, oDlg, oBtn, cPorDiv, cPicEur, lMsgVta, lNotVta, cCodArt ) ) ;
                     OF       oDlg

      oDlg:AddFastKey( VK_F11, {|| GetPesoBalanza( aGet, oBtn ) } )

      oDlg:bKeyDown  := { | nKey | EdtDetKeyDown( nKey, aGet, oDlg, oBtn ) }
      oDlg:bStart    := { || SetDlgMode( oDlg, aTmp, aGet, nMode, oBrw, oBtn, nTop, nLeft, nHeight, nWidth ) }

   ACTIVATE DIALOG oDlg

   oBrw:SetFocus()
   oBrw:Refresh()

RETURN ( oDlg:nResult == IDOK )

//-------------------------------------------------------------------------//

static function SetDlgMode( oDlg, aTmp, aGet, nMode, oBrw, oBtn ) // , nTop, nLeft, nHeight, nWidth )

   local n
   local oCtl
   local nRow
   local nCol
   local nWidth
   local nHeight
   local nGWidth  := 25

   // oDlg:Move( nTop, nLeft, nWidth + nHeight, nHeight )

   for n := 1 to len( oDlg:aControls ) - 1

      nRow        := 3 //( ( oBrw:nRowSel - 1 ) * oBrw:nRowHeight ) // + oBrw:HeaderHeight() + 4
      nCol        := oBrw:aCols[ n ]:nDisplayCol - 25
      nWidth      := oBrw:aCols[ n ]:nWidth - 2
      nHeight     := oBrw:nRowHeight - 4

      nGWidth     += oBrw:aCols[ n ]:nWidth - 1

      oDlg:aControls[ n ]:Move( nRow, nCol, nWidth, nHeight, .t. )

   next

   oBtn:Move( nRow, nGWidth, nHeight + 4, nHeight + 4, .t. )

   if Empty( aTmp[ _NPVPTIL ] ) .or. oUser():lAdministrador() .or. oUser():lCambiarPrecio()
      if( !Empty( aGet[ _NPVPTIL ] ), aGet[ _NPVPTIL ]:HardEnable(), )
      if( !Empty( aGet[ _NDTODIV ] ), aGet[ _NDTODIV ]:HardEnable(), )
      if( !Empty( aGet[ _NDTOLIN ] ), aGet[ _NDTOLIN ]:HardEnable(), )
   else
      if( !Empty( aGet[ _NPVPTIL ] ), aGet[ _NPVPTIL ]:HardDisable(), )
      if( !Empty( aGet[ _NDTODIV ] ), aGet[ _NDTODIV ]:HardDisable(), )
      if( !Empty( aGet[ _NDTOLIN ] ), aGet[ _NDTOLIN ]:HardDisable(), )
   end if

   /*
   Control de capturas---------------------------------------------------------
   */

   for each oCtl in oDlg:aControls

      if !Empty( oCtl ) .and. oCtl:ClassName == "TGETHLP"

         if Empty( oCtl:bWhen ) .or. Eval( oCtl:bWhen )

            if oCtl:lNeedGetFocus .and. !oCtl:lGotFocus

               oCtl:SetFocus()

               Return .t.

            end if

         end if

      end if

   next

return .t.

//------------------------------------------------------------------------//
/*
Calcula totales en las lineas de Detalle
*/

STATIC FUNCTION lCalcDeta( aTmp, oTotal )

   local nCalculo := aTmp[ _NPVPTIL ]

   nCalculo       -= aTmp[ _NDTODIV ]
   nCalculo       *= aTmp[ _NUNTTIL ]

	IF aTmp[ _NDTOLIN ] != 0
		nCalculo 	-= nCalculo * aTmp[ _NDTOLIN ] / 100
	END IF

	oTotal:cText( nCalculo )

RETURN .T.

//-------------------------------------------------------------------------//

Static Function EdtDetKeyDown( nKey, aGet, oDlg, oBtn )

   do case
      case nKey == VK_ESCAPE

         oDlg:End()

      case nKey == VK_RETURN

         Eval( oBtn:bAction )

      case nKey == VK_F5

         if !Empty( aGet[ _CCBATIL ]:VarGet() )

            Eval( oBtn:bAction )

         else

            oDlg:End()

            if Eval( oBtnTik:bWhen )
               Eval( oBtnTik:bAction )
            end if

         end if

      case nKey == VK_F7

         if !Empty( aGet[ _CCBATIL ]:VarGet() )

            Eval( oBtn:bAction )

         else

            oDlg:End()

            if Eval( oBtnAlb:bWhen )
               Eval( oBtnAlb:bAction )
            end if

         end if

      case nKey == VK_F8

         if !Empty( aGet[ _CCBATIL ]:VarGet() )

            Eval( oBtn:bAction )

         else

            oDlg:End()

            if Eval( oBtnFac:bWhen )
               Eval( oBtnFac:bAction )
            end if

         end if

      case nKey == VK_F9

         if !Empty( aGet[ _CCBATIL ]:VarGet() )

            Eval( oBtn:bAction )

         else

            oDlg:End()

            if Eval( oBtnApt:bWhen )
               Eval( oBtnApt:bAction )
            end if

         end if

      case nKey == VK_F12

         if( oCajon != nil, oCajon:Open(), )

      case nKey == 65 .and. GetKeyState( VK_CONTROL )

         CreateInfoArticulo()

   end case

Return nil

//-------------------------------------------------------------------------//

/*
Archiva la linea de TPV
*/

STATIC FUNCTION SavLine( aTmp, aGet, dbfTmpL, oBrw, aTik, oGetTotal, lTwo, nMode, oDlg, oBtn, cPorDiv, cPicEur, lMsgVta, lNotVta, cCodArt )

   local n
   local aXbYStr
   local nStockActual
   local aClo           := aClone( aTmp )

   /*
   Esto es para las validaciones-----------------------------------------------
   */

   oBtn:SetFocus()

   /*
   Comprobamos todas las lineas de detalle tengan precio y unidades------------
	*/

   if !Empty( aGet[ _NPVPTIL ] )
      aGet[ _NPVPTIL ]:Refresh()
   end if

   if !Empty( aGet[ _NUNTTIL ] )
      aGet[ _NUNTTIL ]:Refresh()
   end if

   /*
   Control de capturas---------------------------------------------------------
   */

   for n := 1 to len( oDlg:aControls )

      if !Empty( oDlg:aControls[ n ] ) .and. oDlg:aControls[ n ]:ClassName == "TGETHLP"

         if Empty( oDlg:aControls[ n ]:bWhen ) .or. Eval( oDlg:aControls[ n ]:bWhen )

            if oDlg:aControls[ n ]:lNeedGetFocus .and. !oDlg:aControls[ n ]:lGotFocus

               msgWait( "Campo obligatorio", "Info", 0 )

               oDlg:aControls[ n ]:SetFocus()

               Return .f.

            end if

         end if

      end if

   next

   /*
   Control de vacios-----------------------------------------------------------
   */

   if Empty( aTmp[ _NUNTTIL ] )
      aGet[ _NUNTTIL ]:SetFocus()
      return .f.
   end if

   if !lCodigoArticulo( aGet, aTmp, .f. )
      aGet[ _CCBATIL ]:SetFocus()
      return .f.
   end if

   if lTwo .AND. empty( aTmp[_CNCMTIL ] )
      msgWait( "Introduzca artículo combinado", "Stop", 0 )
      aGet[_CNCMTIL ]:setFocus()
      return .f.
   end if

   if !Empty( aTmp[ _CCODPR1 ] ) .and. lUsePrp1() .and. Empty( aTmp[ _CVALPR1 ] ) .and. !Empty( aGet[ _CVALPR1 ] )
      MsgBeepStop( "Propiedad no puede estar vacia" )
      aGet[ _CVALPR1 ]:SetFocus()
      return .f.
   end if

   if !Empty( aTmp[ _CCODPR2 ] ) .and. lUsePrp2() .and. Empty( aTmp[ _CVALPR2 ] ) .and. !Empty( aGet[ _CVALPR2 ] )
      MsgBeepStop( "Propiedad no puede estar vacia" )
      aGet[ _CVALPR2 ]:SetFocus()
      return .f.
   end if

   /*
   Precios vacios--------------------------------------------------------------
   */

   if Empty( aTmp[ _NPVPTIL ] )

      if !lPermitirVentaSinValorar( aTmp[ _CCBATIL ], dbfArticulo, dbfFamilia )

         if lUsrMaster()
            if !ApoloMsgNoYes( "Precio igual a cero, ¿desea continuar con la venta?" )
               aGet[ _NPVPTIL ]:SetFocus()
               return .f.
            end if
         else
            aGet[ _NPVPTIL ]:SetFocus()
            return .f.
         end if

      else

         if !ApoloMsgNoYes( "Precio igual a cero, ¿desea continuar con la venta?" )
            aGet[ _NPVPTIL ]:SetFocus()
            return .f.
         end if

      end if

   end if

   /*
   Decuentos-------------------------------------------------------------------
   */

   if ( aTmp[ _NPVPTIL ] > 0 ) .and. ( aTmp[ _NPVPTIL ] - aTmp[ _NDTODIV ] <= 0 )
      MsgBeepStop( "Descuento lineal mayor o igual que precio unitario" )
      aGet[ _NDTODIV ]:SetFocus()
      return .f.
   end if

   /*
   Stock actual----------------------------------------------------------------
   */

   if lNotVta .or. lMsgVta

      nStockActual   := oStock:nStockActual( aTmp[ _CCBATIL ], aTik[ _CALMTIK ] )
      nStockActual   -= nVentasPrevias( aTmp[ _CCBATIL ], dbfTmpL, nMode )

      if ( nStockActual - aTmp[ _NUNTTIL ] ) < 0

         if lNotVta
            MsgStop( "No hay stock suficiente, tenemos " + Alltrim( Trans( nStockActual, MasUnd() ) ) + " unidad(es) disponible(s) en almacén " + aTik[ _CALMTIK ] + "." )
            return .f.
         end if

         if lMsgVta
            if !ApoloMsgNoYes( "No hay stock suficiente, tenemos " + Alltrim( Trans( nStockActual, MasUnd() ) ) + " unidad(es) disponible(s) en almacén " + aTik[ _CALMTIK ] + ".", "¿Continuar con la venta?" )
               return .f.
            end if
         end if

      end if

   end if

   /*
   Casos especiles para combustibles-------------------------------------------
   */

   lStdChange( aTmp, aGet )

   /*
   Imprimo en el visor el nombre y precio del artículo-------------------------
   */

   if oVisor != nil
      oVisor:SetBufferLine( { aTmp[ _CNOMTIL ], Trans( aTmp[ _NPVPTIL ], cPouDiv ) }, 1 )
   end if

   /*
   Chequeamos las ofertas X * Y------------------------------------------------
   */

   if nMode == APPD_MODE

      aXbYStr        := nXbYAtipica( aTmp[ _CCBATIL ], aTik[ _CCLITIK ], 1, aTmp[ _NUNTTIL ], aTik[ _DFECTIK ], dbfCliAtp )

      if aXbYStr[ 1 ] == 0
         aXbYStr     := nXbYOferta( aTmp[ _CCBATIL ], aTik[ _CCLITIK ], aTik[ _CCODGRP ], 1, aTmp[ _NUNTTIL ], aTik[ _DFECTIK ], dbfOferta )
      end if

      /*
      si tenemos q reagalar unidades-------------------------------------------
      */

      if aXbYStr[ 1 ] != 0 .and. aXbYStr[ 2 ] != 0

         if aXbYStr[ 1 ] == 2

            if aTmp[ _NUNTTIL ] < 0
               aTmp[ _NUNTTIL ] += aXbYStr[ 2 ]
            else
               aTmp[ _NUNTTIL ] -= aXbYStr[ 2 ]
            end if

            aClo              := aClone( aTmp )

            WinGather( aTmp, nil, dbfTmpL, nil, nMode, nil, .f. )

            AppendKit( aClo, aTik )

            if aTmp[ _NUNTTIL ] < 0
               aTmp[ _NUNTTIL ] := -( aXbYStr[ 2 ] )
            else
               aTmp[ _NUNTTIL ] := aXbYStr[ 2 ]
            end if

            aTmp[ _NPVPTIL ]  := 0

            aClo              := aClone( aTmp )

            WinGather( aTmp, aGet, dbfTmpL, nil, nMode )

            AppendKit( aClo, aTik )

         end if

      else

         /*
         Comprobamos que el registro ya exista en la base de datos----------------
         */

         if lIsCode( aTmp, dbfTmpL, oBrw )

            aGet[ _CCBATIL ]:cText( Space( 14 ) )
            aGet[ _CNOMTIL ]:cText( Space( 250 ) )
            aGet[ _NPVPTIL ]:cText( 0 )
            aGet[ _NUNTTIL ]:cText( 0 )

         else

            /*
            Añadimos el registro a la base de datos----------------------------
            */

            WinGather( aTmp, aGet, dbfTmpL, nil, nMode )

            AppendKit( aClo, aTik )

         end if

      end if

   else

      /*
      Modificamos el registro a la base de datos----------------------------------
      */

      WinGather( aTmp, aGet, dbfTmpL, nil, nMode )

   end if

   cOldCodArt           := ""

   oGetTotal:cText( 0 )

   /*
   Calculamos el total del tiket-----------------------------------------------
   */

   lRecTotal( aTik )

   if oVisor != nil
      oVisor:SetBufferLine( { "Total", Trans( nTotTik, cPorDiv ) }, 2 )
      oVisor:WriteBufferLine()
   end if

	/*
   Pos to the end--------------------------------------------------------------
	*/

   oDlg:end( IDOK )

   oBrw:Refresh( .t. )

RETURN ( .t. )

//---------------------------------------------------------------------------//

STATIC FUNCTION lCodigoArticulo( aGet, aTmp, lMessage )

   local cCodArt
   local cValPr1     := ""
   local cValPr2     := ""

   cCodArt           := aGet[ _CCBATIL ]:VarGet()

   DEFAULT lMessage  := .t.

   if Empty( cCodArt )
      if lRetCodArt()
         return .f.
      else
         return .t.
      end if
   end if

   /*
   Primero buscamos por codigos de barra---------------------------------------
   */

   cCodArt           := cSeekCodebar( cCodArt, dbfCodebar, dbfArticulo )

   /*
   Ahora buscamos por el codigo interno----------------------------------------
   */

   if aSeekProp( cCodArt, cValPr1, cValPr2, dbfArticulo, dbfTblPro )
      Return .t.
   end if

   if lMessage
      MsgBeepStop( "Artículo no encontrado", cCodArt )
   end if

Return .f.

//-------------------------------------------------------------------------//
/*
Esta funci¢n recoge los articulos del Escaner y los valida
*/

STATIC FUNCTION LoaArt( aGet, aTmp, oBrw, oGetTotal, aTik, lTwo, nMode, oDlg, lNotVta )

   local nTotal      := 0
   local cCodFam
   local cPrpArt
   local nImpOfe
   local nCosPro
   local nPrePro     := 0
   local cValPr1     := ""
   local cValPr2     := ""
   local cGrpCli     := RetFld( aTik[ _CCLITIK ], dbfClient, "CCODGRP" )

#ifdef __HARBOUR__
   local cCodArt     := aGet[ _CCBATIL ]:cText()
#else
   local cCodArt     := aGet[ _CCBATIL ]:VarGet()
#endif

   if Empty( cCodArt )
      if lRetCodArt()
         //MsgStop( "No se pueden añadir lineas sin codificar" )
         return .f.
      else
         return .t.
      end if
   end if

   /*
   Precio anterior-------------------------------------------------------------
   */

   nOldPvp           := 0

   /*
   Primero buscamos por codigos de barra---------------------------------------
   */

   cCodArt           := cSeekCodebar( cCodArt, dbfCodebar, dbfArticulo )

   /*
   Ahora buscamos por el codigo interno----------------------------------------
   */

   if aSeekProp( @cCodArt, @cValPr1, @cValPr2, dbfArticulo, dbfTblPro )

      if ( dbfArticulo )->lObs
         MsgStop( "Artículo catalogado como obsoleto" )
         return .f.
      end if

      if nMode == APPD_MODE

         aGet[ _CCBATIL ]:cText( cCodArt )

         if !empty( ( dbfArticulo)->cDesTik )
            aGet[ _CNOMTIL ]:cText( ( dbfArticulo )->cDesTik )
         else
            aGet[ _CNOMTIL ]:cText( ( dbfArticulo )->Nombre  )
         end if

         /*
         Familia del artículo--------------------------------------------------
         */

         aTmp[ _CFAMTIL ]                    := ( dbfArticulo )->Familia

         /*
         Tipos de acceso-------------------------------------------------------
         */

         aTmp[ _LTIPACC ]                    := ( dbfArticulo )->lTipAcc

         if !Empty( aGet[ _NPVPTIL ] )
            aGet[ _NPVPTIL ]:lNeedGetFocus   := aTmp[ _LTIPACC ]
         end if

         lNotVta                             := ( dbfArticulo )->lNotVta

         /*
         Tratamientos kits-----------------------------------------------------
         */

         if ( dbfArticulo )->lKitArt
            aTmp[ _LKITART ]     := ( dbfArticulo )->lKitArt                        // Marcamos como padre del kit
            aTmp[ _LIMPLIN ]     := lImprimirCompuesto( ( dbfArticulo )->Codigo, dbfArticulo ) // 1 Todos, 2 Compuesto
            aTmp[ _LKITPRC ]     := lPreciosCompuestos( ( dbfArticulo )->Codigo, dbfArticulo ) // 1 Todos, 2 Compuesto
            if lStockCompuestos( ( dbfArticulo )->Codigo, dbfArticulo )
               aTmp[ _NCTLSTK ]  := ( dbfArticulo )->nCtlStock
            else
               aTmp[ _NCTLSTK ]  := STOCK_NO_CONTROLAR // No controlar Stock
            end if
         else
            aTmp[ _LIMPLIN ]     := .f.
            aTmp[ _NCTLSTK ]     := ( dbfArticulo )->nCtlStock
         end if

         /*
         Buscamos la familia del articulo y anotamos las propiedades
         */

         aTmp[ _CCODPR1 ]        := ( dbfArticulo )->cCodPrp1
         aTmp[ _CCODPR2 ]        := ( dbfArticulo )->cCodPrp2

         if !Empty( aTmp[ _CCODPR1 ] ) .and. !Empty( aGet[ _CVALPR1 ] )

            if !Empty( cValPr1 )
               aGet[ _CVALPR1 ]:cText( cCodPrp( aTmp[ _CCODPR1 ], cValPr1, dbfTblPro ) )
            end if

            if lUsePrp1()
               aGet[ _CVALPR1 ]:Show()
            else
               aGet[ _CVALPR1 ]:Hide()
            end if

         end if

         if !empty( aTmp[ _CCODPR2 ] ) .and. !Empty( aGet[ _CVALPR2 ] )

            if !Empty( cValPr2 )
               aGet[ _CVALPR2 ]:cText( cCodPrp( aTmp[ _CCODPR2 ], cValPr2, dbfTblPro ) )
            end if

            if lUsePrp2()
               aGet[ _CVALPR2 ]:Show()
            else
               aGet[ _CVALPR2 ]:Hide()
            end if
         end if

         /*
         Obtenemos la familia y los codigos de familia
         */

         cCodFam              := ( dbfArticulo )->Familia
         if !Empty( cCodFam )
            aTmp[ _CCODFAM ]  := cCodFam
            aTmp[ _CGRPFAM ]  := cGruFam( cCodFam, dbfFamilia )
         end if

         /*
         Obtenemos el Tipo de impuestos-------------------------------------------------
         */

         aTmp[ _NIVATIL ]     := nIva( dbfIva, ( dbfArticulo )->TipoIva )

         /*
         Recogemos los impuestos especiales---------------------------------------
         */

         if !Empty( ( dbfArticulo )->cCodImp )
            aTmp[ _CCODIMP ]  := ( dbfArticulo )->cCodImp
            aTmp[ _NVALIMP ]  := oNewImp:nValImp( ( dbfArticulo )->cCodImp, .t., aTmp[ _NIVATIL ] )
         end if

         /*
         Recogemos el factor de conversión-------------------------------------
         */

         if ( dbfArticulo )->lFacCnv
            aTmp[ _NFACCNV ]  := ( dbfArticulo )->nFacCnv
         end if

      else

         if ( cOldCodArt != cCodArt )

            aGet[ _CCBATIL ]:cText( cCodArt )

            if !empty( ( dbfArticulo)->cDesTik )
               aGet[ _CNOMTIL ]:cText( ( dbfArticulo )->cDesTik )
            else
               aGet[ _CNOMTIL ]:cText( ( dbfArticulo )->Nombre  )
            end if

            /*
            Familia del artículo
            */

            aTmp[ _CFAMTIL ]        := ( dbfArticulo )->Familia
            aTmp[ _LTIPACC ]        := ( dbfArticulo )->lTipAcc

            lNotVta                 := ( dbfArticulo )->lNotVta

            /*
            Tratamientos kits-----------------------------------------------------
            */

            if ( dbfArticulo )->lKitArt
               aTmp[ _LKITART ]     := ( dbfArticulo )->lKitArt                        // Marcamos como padre del kit
               aTmp[ _LIMPLIN ]     := lImprimirCompuesto( ( dbfArticulo )->Codigo, dbfArticulo ) // 1 Todos, 2 Compuesto
               aTmp[ _LKITPRC ]     := lPreciosCompuestos( ( dbfArticulo )->Codigo, dbfArticulo ) // 1 Todos, 2 Compuesto
               if lStockCompuestos( ( dbfArticulo )->Codigo, dbfArticulo )
                  aTmp[ _NCTLSTK ]  := ( dbfArticulo )->nCtlStock
               else
                  aTmp[ _NCTLSTK ]  := STOCK_NO_CONTROLAR // No controlar Stock
               end if
            else
               aTmp[ _LIMPLIN ]     := .f.
               aTmp[ _NCTLSTK ]     := ( dbfArticulo )->nCtlStock
            end if

            /*
            Buscamos la familia del articulo y anotamos las propiedades
            */

            if dbSeekInOrd( ( dbfArticulo )->Familia, "cCodFam", dbfFamilia )
               aTmp[ _CCODPR1 ]     := ( dbfArticulo )->cCodPrp1
               aTmp[ _CCODPR2 ]     := ( dbfArticulo )->cCodPrp2
            else
               aTmp[ _CCODPR1 ]     := Space( 10 )
               aTmp[ _CCODPR2 ]     := Space( 10 )
            end if

            if !empty( aTmp[ _CCODPR1 ] ) .and. !Empty( aGet[ _CVALPR1 ] )
               if lUsePrp1()
                  aGet[ _CVALPR1 ]:Show()
               else
                  aGet[ _CVALPR1 ]:Hide()
               end if
            end if

            if !empty( aTmp[ _CCODPR2 ] ) .and. !Empty( aGet[ _CVALPR2 ] )
               if lUsePrp2()
                  aGet[ _CVALPR2 ]:Show()
               else
                  aGet[ _CVALPR2 ]:Hide()
               end if
            end if

            /*
            Obtenemos la familia y los codigos de familia----------------------
            */

            cCodFam  := RetFamArt( cCodArt, dbfArticulo )
            if !Empty( cCodFam )
               aTmp[ _CCODFAM ]  := cCodFam
               aTmp[ _CGRPFAM ]  := cGruFam( cCodFam, dbfFamilia )
            end if

            /*
            Obtenemos el Tipo de impuestos-------------------------------------------
            */

            aTmp[ _NIVATIL ]     := nIva( dbfIva, ( dbfArticulo )->TipoIva )

            /*
            Recogemos los impuestos especiales---------------------------------
            */

            if !Empty( ( dbfArticulo )->cCodImp )
               aTmp[ _CCODIMP ]  := ( dbfArticulo )->cCodImp
               aTmp[ _NVALIMP ]  := oNewImp:nValImp( ( dbfArticulo )->cCodImp, .t., aTmp[ _NIVATIL ] )
            end if

         end if

      end if

      /*
      He terminado de meter todo lo que no son precios ahora es cuando meteré los precios con todas las opciones posibles
      */

      cPrpArt                    := aTmp[ _CCODPR1 ] + aTmp[ _CCODPR2 ] + aTmp[ _CVALPR1 ] + aTmp[ _CVALPR2 ]

      if ( cOldCodArt != cCodArt ) .or. ( cPrpArt != cOldPrpArt )

         /*
         Obtenemos el precio del artículo
         */

         if nMode == APPD_MODE
            cCodFam        := RetFamArt( cCodArt, dbfArticulo )
         else
            cCodFam        := aTmp[_CCODFAM]
         end if

         /*
         Cargamos los costos------------------------------------------------
         */

         nCosPro           := nCosPro( cCodArt, aTmp[ _CCODPR1 ], aTmp[ _CVALPR1 ], aTmp[ _CCODPR2 ], aTmp[ _CVALPR2 ], dbfArtDiv )

         //Cargamos los valores por defecto de las unidades de medicion

         if oUndMedicion:oDbf:Seek( ( dbfArticulo )->cUnidad )

            if !Empty( oUndMedicion:oDbf:cTextoDim1 )
               if !Empty( aGet[ ( dbfTikL )->( fieldpos( "nMedUno" ) ) ] )
                  aGet[ ( dbfTikL )->( fieldpos( "nMedUno" ) ) ]:cText( ( dbfArticulo )->nLngArt )
                  aGet[ ( dbfTikL )->( fieldpos( "nMedUno" ) ) ]:Show()
               else
                  aTmp[ ( dbfTikL )->( fieldpos( "nMedUno" ) ) ]  := ( dbfArticulo )->nLngArt
               end if
            else
               if !Empty( aGet[ ( dbfTikL )->( fieldpos( "nMedUno" ) ) ] )
                  aGet[ ( dbfTikL )->( fieldpos( "nMedUno" ) ) ]:cText( 0 )
                  aGet[ ( dbfTikL )->( fieldpos( "nMedUno" ) ) ]:Hide()
               else
                  aTmp[ ( dbfTikL )->( fieldpos( "nMedUno" ) ) ]  := 0
               end if
            end if

            if !Empty( oUndMedicion:oDbf:cTextoDim2 )
               if !Empty( aGet[ ( dbfTikL )->( fieldpos( "nMedDos" ) ) ] )
                  aGet[ ( dbfTikL )->( fieldpos( "nMedDos" ) ) ]:cText( ( dbfArticulo )->nAltArt )
                  aGet[ ( dbfTikL )->( fieldpos( "nMedDos" ) ) ]:Show()
               else
                  aTmp[ ( dbfTikL )->( fieldpos( "nMedDos" ) ) ]  := ( dbfArticulo )->nAltArt
               end if
            else
               if !Empty( aGet[ ( dbfTikL )->( fieldpos( "nMedDos" ) ) ] )
                  aGet[ ( dbfTikL )->( fieldpos( "nMedDos" ) ) ]:cText( 0 )
                  aGet[ ( dbfTikL )->( fieldpos( "nMedDos" ) ) ]:Hide()
               else
                  aTmp[ ( dbfTikL )->( fieldpos( "nMedDos" ) ) ]  := 0
               end if
            end if

            if !Empty( oUndMedicion:oDbf:cTextoDim3 )
               if !Empty( aGet[ ( dbfTikL )->( fieldpos( "nMedTre" ) ) ] )
                  aGet[ ( dbfTikL )->( fieldpos( "nMedTre" ) ) ]:cText( ( dbfArticulo )->nAncArt )
                  aGet[ ( dbfTikL )->( fieldpos( "nMedTre" ) ) ]:Show()
               else
                  aTmp[ ( dbfTikL )->( fieldpos( "nMedTre" ) ) ]  := ( dbfArticulo )->nAncArt
               end if
            else
               if !Empty( aGet[ ( dbfTikL )->( fieldpos( "nMedTre" ) ) ] )
                  aGet[ ( dbfTikL )->( fieldpos( "nMedTre" ) ) ]:cText( 0 )
                  aGet[ ( dbfTikL )->( fieldpos( "nMedTre" ) ) ]:Hide()
               else
                  aTmp[ ( dbfTikL )->( fieldpos( "nMedTre" ) ) ]  := 0
               end if
            end if

         else

            if !Empty( aGet[ ( dbfTikL )->( fieldpos( "nMedUno" ) ) ] )
               aGet[ ( dbfTikL )->( fieldpos( "nMedUno" ) ) ]:cText( 0 )
               aGet[ ( dbfTikL )->( fieldpos( "nMedUno" ) ) ]:Hide()
            else
               aTmp[ ( dbfTikL )->( fieldpos( "nMedUno" ) ) ]  := 0
            end if

            if !Empty( aGet[ ( dbfTikL )->( fieldpos( "nMedDos" ) ) ] )
               aGet[ ( dbfTikL )->( fieldpos( "nMedDos" ) ) ]:cText( 0 )
               aGet[ ( dbfTikL )->( fieldpos( "nMedDos" ) ) ]:Hide()
            else
               aTmp[ ( dbfTikL )->( fieldpos( "nMedDos" ) ) ]  := 0
            end if

            if !Empty( aGet[ ( dbfTikL )->( fieldpos( "nMedTre" ) ) ] )
               aGet[ ( dbfTikL )->( fieldpos( "nMedTre" ) ) ]:cText( 0 )
               aGet[ ( dbfTikL )->( fieldpos( "nMedTre" ) ) ]:Hide()
            else
               aTmp[ ( dbfTikL )->( fieldpos( "nMedTre" ) ) ]  := 0
            end if

         end if

if ( IsMuebles() )

         if nCosPro == 0
            nCosPro        := nCalculoPuntos( ( dbfArticulo )->pCosto, ( dbfArticulo )->nPuntos, ( dbfArticulo )->nDtoPnt, 0 )
         end if

else
         if nCosPro == 0
            nCosPro        := nCosto( nil, dbfArticulo, dbfKit )
         end if

end if

         if aGet[ _NCOSDIV ] != nil
            aGet[ _NCOSDIV ]:cText( nCosPro )
         else
            aTmp[ _NCOSDIV ]  := nCosPro
         end if

         nPrePro           := nPrePro( cCodArt, aTmp[ _CCODPR1 ], aTmp[ _CVALPR1 ], aTmp[ _CCODPR2 ], aTmp[ _CVALPR2 ], aTik[ _NTARIFA ], .t., dbfArtDiv, dbfTarPreL, aTik[_CCODTAR] )

         if nPrePro == 0
            nTotal         := nRetPreArt( aTik[ _NTARIFA ], aTik[ _CDIVTIK ], .t., dbfArticulo, dbfDiv, dbfKit, dbfIva, .t. )
            if nTotal != 0
               nOldPvp     := nTotal
               aGet[ _NPVPTIL ]:cText( nTotal )
               oGetTotal:cText( aTmp[ _NPVPTIL ] * aTmp[ _NUNTTIL ] )
            end if
         else
            aGet[_NPVPTIL]:cText( nPrePro )
         end if

         /*
         Vemos si hay descuentos en las familias-------------------------------
         */

         if !Empty( aGet[ _NDTOLIN ] )
            aGet[ _NDTOLIN ]:cText( nDescuentoFamilia( cCodFam, dbfFamilia ) )
         else
            aTmp[ _NDTOLIN ]     := nDescuentoFamilia( cCodFam, dbfFamilia )
         end if

         /*
         Chequeamos situaciones especiales-------------------------------------
         */

         //--Atipicas de clientes por articulos--//
         do case
         case  lSeekAtpArt( aTik[ _CCLITIK ] + cCodArt, aTmp[ _CCODPR1 ] + aTmp[ _CCODPR2 ], aTmp[ _CVALPR1 ] + aTmp[ _CVALPR2 ], aTik[ _DFECTIK ], dbfCliAtp ) .and. ;
               ( dbfCliAtp )->lAplFac

            nImpOfe     := nImpAtp( aTik[ _NTARIFA ], dbfCliAtp, aGet[ _NPVPTIL ], aTmp[ _NIVATIL ] )
            if nImpOfe  != 0
               aGet[ _NPVPTIL ]:cText( nImpOfe )
            end if

            /*
            Descuentos por tarifas de precios----------------------------------
            */

            nImpOfe     := nDtoAtp( aTik[ _NTARIFA ], dbfCliAtp )
            if nImpOfe  != 0
               if !Empty( aGet[ _NDTOLIN ] )
                  aGet[ _NDTOLIN ]:cText( nImpOfe )
               else
                  aTmp[ _NDTOLIN ]     := nImpOfe
               end if
            end if

            if ( dbfCliAtp )->nDtoDiv != 0
               if !Empty( aGet[ _NDTODIV ] )
                  aGet[ _NDTODIV ]:cText( ( dbfCliAtp )->nDtoDiv )
               else
                  aTmp[ _NDTODIV ]     := ( dbfCliAtp )->nDtoDiv
               end if
            end if

         /*
         Atipicas de clientes por familias-------------------------------------
         */

         case  lSeekAtpFam( aTik[ _CCLITIK ] + cCodFam, aTik[ _DFECTIK ], dbfCliAtp ) .and. ;
               ( dbfCliAtp )->lAplFac

            if ( dbfCliAtp )->nDtoArt != 0
               if !Empty( aGet[ _NDTOLIN ] )
                  aGet[ _NDTOLIN ]:cText( ( dbfCliAtp )->nDtoArt )
               else
                  aTmp[ _NDTOLIN ]     := ( dbfCliAtp )->nDtoArt
               end if
            end if

            if ( dbfCliAtp )->nDtoDiv != 0
               if !Empty( aGet[ _NDTODIV ] )
                  aGet[ _NDTODIV ]:cText( ( dbfCliAtp )->nDtoDiv )
               else
                  aTmp[ _NDTODIV ]     := ( dbfCliAtp )->nDtoDiv
               end if
            end if

         //--Tarifas de precios--//
         case !Empty( aTik[ _CCODTAR ] )

            //--Precio--//
            nImpOfe  := RetPrcTar( cCodArt, aTik[ _CCODTAR ], aTmp[ _CCODPR1 ], aTmp[ _CCODPR2 ], aTmp[ _CVALPR1 ], aTmp[ _CVALPR2 ], dbfTarPreL, aTik[ _NTARIFA ] )
            if nImpOfe  != 0
               aGet[ _NPVPTIL ]:cText( nImpOfe )
            end if

            //--Descuento porcentual--//
            nImpOfe  := RetPctTar( cCodArt, cCodFam, aTik[ _CCODTAR ], aTmp[ _CCODPR1 ], aTmp[ _CCODPR2 ], aTmp[ _CVALPR1 ], aTmp[ _CVALPR2 ], dbfTarPreL )
            if nImpOfe  != 0
               aGet[_NDTOLIN ]:cText( nImpOfe )
            end if

            //--Descuento lineal--//
            nImpOfe  := RetLinTar( cCodArt, cCodFam, aTik[ _CCODTAR ], aTmp[ _CCODPR1 ], aTmp[ _CCODPR2 ], aTmp[ _CVALPR1 ], aTmp[ _CVALPR2 ], dbfTarPreL )
            if nImpOfe != 0
               aGet[ _NDTODIV ]:cText( nImpOfe )
            end if

         end case

         //--Comprobamos si hay una oferta--//

         nTotal      := nImpOferta( cCodArt, aTik[ _CCLITIK ], cGrpCli, aTmp[ _NUNTTIL ], aTik[ _DFECTIK ], dbfOferta, aTik[ _NTARIFA ], .t., aTmp[ _CCODPR1 ], aTmp[ _CCODPR2 ], aTmp[_CVALPR1], aTmp[_CVALPR2] )
         if nTotal   != 0
            aGet[ _NPVPTIL ]:cText( nTotal )
         end if

         //--Descuento promocion--//

         nTotal      := nDtoOferta( cCodArt, aTik[ _CCLITIK ], cGrpCli, aTmp[ _NUNTTIL ], aTik[ _DFECTIK ], dbfOferta, aTmp[ _CCODPR1 ], aTmp[ _CCODPR2 ], aTmp[ _CVALPR1 ], aTmp[ _CVALPR2 ] )
         if nTotal   != 0
            aGet[ _NDTOLIN ]:cText( nTotal )
         end if

         //--Buscamos si existen descuentos lineales en las ofertas--//

         nImpOfe     := nDtoLineal( cCodArt, aTik[ _CCLITIK ], cGrpCli, aTmp[ _NUNTTIL ], aTik[ _DFECTIK ], dbfOferta, aTmp[ _CCODPR1 ], aTmp[ _CCODPR2 ], aTmp[ _CVALPR1 ], aTmp[_CVALPR2] )
         if nImpOfe  != 0
            if !Empty( aGet[ _NDTODIV ] )
               aGet[ _NDTODIV ]:cText( nImpOfe )
            else
               aTmp[ _NDTODIV ]     := nImpOfe
            end if
         end if

      end if

      cOldCodArt  := cCodArt
      cOldPrpArt  := cPrpArt

      if Empty( aTmp[ _NPVPTIL ] ) .or. lUsrMaster() .or. oUser():lCambiarPrecio()
         if( !Empty( aGet[ _NPVPTIL ] ), aGet[ _NPVPTIL ]:HardEnable(), )
         if( !Empty( aGet[ _NDTODIV ] ), aGet[ _NDTODIV ]:HardEnable(), )
         if( !Empty( aGet[ _NDTOLIN ] ), aGet[ _NDTOLIN ]:HardEnable(), )
      else
         if( !Empty( aGet[ _NPVPTIL ] ), aGet[ _NPVPTIL ]:HardDisable(), )
         if( !Empty( aGet[ _NDTODIV ] ), aGet[ _NDTODIV ]:HardDisable(), )
         if( !Empty( aGet[ _NDTOLIN ] ), aGet[ _NDTOLIN ]:HardDisable(), )
      end if

   else

      Return .f.

   end if

Return .t.

//-------------------------------------------------------------------------//

Static Function lExacto( aTmp )

   local lImporteExacto := lImporteExacto()

   if lImporteExacto
      aTmp[ _NCOBTIK ]  -= nTotCobTik( nil, dbfTmpP, dbfDiv, cDivEmp() )
      aTmp[ _NCOBTIK ]  -= nTotValTik( nil, dbfTmpV, dbfTikL, dbfDiv, cDivEmp() )
      aTmp[ _NCOBTIK ]  -= nTotAntFacCli( nil, dbfTmpA, dbfIva, dbfDiv, cDivEmp() )
      aTmp[ _LPGDTIK ]  := .t.
      aTmp[ _CFPGTIK ]  := "00"
   end if

Return ( lImporteExacto )

//-------------------------------------------------------------------------//
/*
Cobra un tiket
*/

STATIC FUNCTION lCobro( aTmp, aGet, nSave, nMode, lGenVale, nDifVale, lBig )

   local n
   local oDlg
   local oBtnTop
   local oBtnDwn
   local oBtnAceptar
   local oBtnAceptarImprimir
   local oBtnCalculator
   local oTitle
   local cTitle            := ""
   local oBrwPgo
   local oBrwVal
   local oGetTxt
   local cGetTxt
   local nClrBak           := RGB( 247, 243, 231 )
   local oFntDlg           := TFont():New( FONT_NAME, 12, 32, .F., .T.,  )
   local aBmpDiv           := Array( 3 )
   local aBtnCob           := Array( 6 )
   local aSay              := Array( 3 )
   local aGetCob           := Array( 5 )
   local lIntClk           := .t.
   local aBtnFormaPago     := Array( 5 )
   local aSayFormaPago     := Array( 5 )

   DEFAULT nSave           := SAVTIK
   DEFAULT nMode           := EDIT_MODE
   DEFAULT lBig            := .f.

   if Empty( oTotDiv )
      oTotDiv              := TotalesTPV():Init()
   end if
   oTotDiv:nTotal          := aTmp[ _NCOBTIK ]

   if Empty( aTmp[ _CCLITIK ] )
      aTmp[ _CCLITIK ]     := cDefCli()
   end if

   if nMode == APPD_MODE
      if !uFieldEmpresa( "lGetFpg" )
         aTmp[ _CFPGTIK ]  := cDefFpg()
      else
         aTmp[ _CFPGTIK ]  := Space( 2 )
      end if
   end if

   cGetTxt                 := cNbrFPago( aTmp[ _CFPGTIK ], dbfFPago )

   /*
   Reposicionamiento de los pagos----------------------------------------------
   */

   if nMode == DUPL_MODE
      ( dbfTmpP )->( __dbZap() )
   end if

   ( dbfTmpP )->( dbGoTop() )

   /*
   Seleccionamos el color del dialogo dependiendo del tipo de archivar---------
   */

   do case
   case nSave == SAVTIK
      nClrBak        := RGB( 153, 204, 255 )
      cTitle         := "Cobrar TIKET"
   case nSave == SAVALB
      nClrBak        := RGB( 102, 204,  51 )
      cTitle         := "Guardar como ALBARAN"
   case nSave == SAVFAC
      nClrBak        := RGB( 255, 204, 102 )
      cTitle         := "Cobrar FACTURA"
   case nSave == SAVDEV
      nClrBak        := RGB( 194, 143, 224 )
      cTitle         := "Devolución TIKET"
   case nSave == SAVVAL
      nClrBak        := RGB( 255, 128, 64 )
      cTitle         := "Vale TIKET"
   case nSave == SAVAPT
      nClrBak        := RGB( 123, 139, 193 )
      cTitle         := "Apartar TIKET"
   end case

   if lBig
      if oUser():lUsrZur()
         DEFINE DIALOG oDlg RESOURCE "BIG_COBRO_LEFT"    TITLE cTitle
      else
         DEFINE DIALOG oDlg RESOURCE "BIG_COBRO_RIGHT"   TITLE cTitle
      end if
   else
      DEFINE DIALOG oDlg RESOURCE "COBROTPV"             TITLE cTitle
   end if

      /*
      Titulo de la caja _______________________________________________________
      */

      REDEFINE SAY oTitle VAR cTitle ;
         ID       100 ;
			FONT 		oFntDlg ;
         COLOR    CLR_BLACK, nClrBak ;
         OF       oDlg

      REDEFINE SAY aSay[ 1 ] ID 910 OF oDlg
      REDEFINE SAY aSay[ 2 ] ID 911 OF oDlg
      REDEFINE SAY aSay[ 3 ] ID 912 OF oDlg

      /*
      Codigo del Cliente_______________________________________________________
      */

      if lBig

      REDEFINE GET aGetCob[ 5 ] VAR aTmp[ _CSERTIK ] ;
         ID       105 ;
         PICTURE  "@!" ;
         FONT     oFntDlg ;
         VALID    ( aTmp[ _CSERTIK ] >= "A" .AND. aTmp[ _CSERTIK ] <= "Z"  );
         OF       oDlg

      REDEFINE BUTTONBMP oBtnTop;
         ID       106 ;
         OF       oDlg ;
         BITMAP   "UP32" ;
         ACTION   ( UpSerie( aGetCob[ 5 ] ) )

      REDEFINE BUTTONBMP oBtnDwn;
         ID       107 ;
         OF       oDlg ;
         BITMAP   "DOWN32" ;
         ACTION   ( DwSerie( aGetCob[ 5 ] ) )

      /*
      Codigo de cliente--------------------------------------------------------
      */

      REDEFINE BUTTONBMP ;
         ID       200 ;
         OF       oDlg ;
         BITMAP   "Keyboard2_32" ;
         ACTION   ( VirtualKey( .f., aGet[ _CCLITIK ] ), cClient( aGet[ _CCLITIK ], dbfClient, aGet[ _CNOMTIK ] ) )

      REDEFINE BUTTONBMP ;
         ID       553 ;
         OF       oDlg ;
         BITMAP   "User1_32" ;
         ACTION   ( BrwCliTactil( aGet[ _CCLITIK ], dbfClient, aGet[ _CNOMTIK ] ), cClient( aGet[ _CCLITIK ], dbfClient, aGet[ _CNOMTIK ] ) )

      REDEFINE GET aGet[ _CCLITIK ] VAR aTmp[ _CCLITIK ];
         ID       110 ;
         FONT     oFntDlg ;
         VALID    ( cClient( aGet[ _CCLITIK ], dbfClient, aGet[ _CNOMTIK ] ), .t. );
         OF       oDlg

      REDEFINE GET aGet[ _CNOMTIK ] VAR aTmp[ _CNOMTIK ];
         ID       111 ;
         FONT     oFntDlg ;
         OF       oDlg

      end if

      /*
      Forma de pago------------------------------------------------------------
      */

      if lBig

      REDEFINE GET aGet[ _CFPGTIK ] VAR aTmp[ _CFPGTIK ] ;
         ID       120 ;
         VALID    cFpago( aGet[ _CFPGTIK ], dbfFPago, oGetTxt ) ;
         FONT     oFntDlg ;
         OF       oDlg

         aGet[ _CFPGTIK ]:bHelp  := {|| BrwPgoTactil( aGet[ _CFPGTIK ], dbfFPago, oGetTxt ) }

      REDEFINE GET oGetTxt VAR cGetTxt ;
         ID       121 ;
         FONT     oFntDlg ;
         OF       oDlg

      else

      REDEFINE GET aGet[ _CFPGTIK ] VAR aTmp[ _CFPGTIK ] ;
         ID       120 ;
         BITMAP   "LUPA" ;
         VALID    cFpago( aGet[ _CFPGTIK ], dbfFPago, oGetTxt ) ;
         FONT     oFntDlg ;
         OF       oDlg

         aGet[ _CFPGTIK ]:bHelp  := {|| BrwFPago( aGet[ _CFPGTIK ], oGetTxt ) }

      REDEFINE GET oGetTxt VAR cGetTxt ;
         ID       121 ;
         FONT     oFntDlg ;
         OF       oDlg

      end if

      /*
      Botones de formas de pago------------------------------------------------
      */

      for n := 1 to len( aButtonsPago )

      REDEFINE BUTTONBMP aButtonsPago[ n ]:oButton ;
         ID       ( 600 + n ) ;
         OF       oDlg ;
         BITMAP   ( aButtonsPago[ n ]:cBigResource )

      REDEFINE SAY aButtonsPago[ n ]:oSay ;
         PROMPT   aButtonsPago[ n ]:cText ;
         ID       ( 650 + n ) ;
         OF       oDlg

      aButtonsPago[ n ]:oButton:bAction   := bButtonsPago( aButtonsPago[ n ]:cCode, aGet[ _CFPGTIK ] )

      next

      /*
      Totales__________________________________________________________________
		*/

      REDEFINE SAY oTotDiv:oTotal ;
         VAR      oTotDiv:nTotal ;
         ID       150 ;
			FONT 		oFntDlg ;
         PICTURE  cPorDiv ;
         OF       oDlg

      REDEFINE SAY oTotDiv:oTotalDivisa ;
         VAR      oTotDiv:nTotalDivisa ;
         ID       151 ;
			FONT 		oFntDlg ;
         PICTURE  cPicEur ;
         OF       oDlg

      REDEFINE BITMAP aBmpDiv[ 2 ] ;
         RESOURCE cFilBmpDiv( cDivChg(), dbfDiv, oBandera ) ;
         ID       174;
         ADJUST ;
         OF       oDlg

      /*
      Total entregado__________________________________________________________
		*/

      REDEFINE SAY oTotDiv:oEntregado ;
         VAR      oTotDiv:nEntregado ;
         ID       160 ;
			FONT 		oFntDlg ;
         PICTURE  cPorDiv ;
         OF       oDlg

      REDEFINE SAY oTotDiv:oEntregadoDivisa ;
         VAR      oTotDiv:nEntregadoDivisa ;
         ID       161 ;
			FONT 		oFntDlg ;
         PICTURE  cPicEur ;
         OF       oDlg

      /*
      Monedas y billetes__________________________________________________________________
		*/

      REDEFINE BUTTONBMP ;
         ID       800 ;
         OF       oDlg ;
         BITMAP   "Img500Euros" ;
         ACTION   ( ClkMoneda( 500, oTotDiv:oCobrado, @lIntClk ), ChkCobro( aTmp ) )

      REDEFINE BUTTONBMP ;
         ID       801 ;
         OF       oDlg ;
         BITMAP   "Img200Euros" ;
         ACTION   ( ClkMoneda( 200, oTotDiv:oCobrado, @lIntClk ), ChkCobro( aTmp ) )

      REDEFINE BUTTONBMP ;
         BITMAP   "Img100EUROS" ;
         ACTION   ( ClkMoneda( 100, oTotDiv:oCobrado, @lIntClk ), ChkCobro( aTmp ) ) ;
         ID       802;
         OF       oDlg

      REDEFINE BUTTONBMP ;
         BITMAP   "Img50EUROS" ;
         ACTION   ( ClkMoneda( 50, oTotDiv:oCobrado, @lIntClk ), ChkCobro( aTmp ) ) ;
         ID       803;
         OF       oDlg

      REDEFINE BUTTONBMP ;
         BITMAP   "Img20EUROS" ;
         ACTION   ( ClkMoneda( 20, oTotDiv:oCobrado, @lIntClk ), ChkCobro( aTmp ) ) ;
         ID       804;
         OF       oDlg

      REDEFINE BUTTONBMP ;
         BITMAP   "Img10EUROS" ;
         ACTION   ( ClkMoneda( 10, oTotDiv:oCobrado, @lIntClk ), ChkCobro( aTmp ) ) ;
         ID       805;
         OF       oDlg

      REDEFINE BUTTONBMP ;
         BITMAP   "Img5EUROS" ;
         ACTION   ( ClkMoneda( 5, oTotDiv:oCobrado, @lIntClk ), ChkCobro( aTmp ) ) ;
         ID       806;
         OF       oDlg

      REDEFINE BUTTONBMP ;
         BITMAP   "Img2EUROS" ;
         ACTION   ( ClkMoneda( 2, oTotDiv:oCobrado, @lIntClk ), ChkCobro( aTmp ) ) ;
         ID       807;
         OF       oDlg

      REDEFINE BUTTONBMP ;
         BITMAP   "Img1EURO" ;
         ACTION   ( ClkMoneda( 1, oTotDiv:oCobrado, @lIntClk ), ChkCobro( aTmp ) ) ;
         ID       808;
         OF       oDlg

      REDEFINE BUTTONBMP ;
         BITMAP   "Img50CENT" ;
         ACTION   ( ClkMoneda( 0.50, oTotDiv:oCobrado, @lIntClk ), ChkCobro( aTmp ) ) ;
         ID       809;
         OF       oDlg

      REDEFINE BUTTONBMP ;
         BITMAP   "Img20CENT" ;
         ACTION   ( ClkMoneda( 0.20, oTotDiv:oCobrado, @lIntClk ), ChkCobro( aTmp ) ) ;
         ID       810;
         OF       oDlg

      REDEFINE BUTTONBMP ;
         BITMAP   "Img10CENT" ;
         ACTION   ( ClkMoneda( 0.10, oTotDiv:oCobrado, @lIntClk ), ChkCobro( aTmp ) ) ;
         ID       811;
         OF       oDlg

      REDEFINE BUTTONBMP ;
         BITMAP   "Img5CENT" ;
         ACTION   ( ClkMoneda( 0.05, oTotDiv:oCobrado, @lIntClk ), ChkCobro( aTmp ) ) ;
         ID       812;
         OF       oDlg

      REDEFINE BUTTONBMP ;
         BITMAP   "Img2CENT" ;
         ACTION   ( ClkMoneda( 0.02, oTotDiv:oCobrado, @lIntClk ), ChkCobro( aTmp ) ) ;
         ID       813;
         OF       oDlg

      REDEFINE BUTTONBMP ;
         BITMAP   "Img1CENT" ;
         ACTION   ( ClkMoneda( 0.01, oTotDiv:oCobrado, @lIntClk ), ChkCobro( aTmp ) ) ;
         ID       814;
         OF       oDlg

      REDEFINE BUTTONBMP ;
         BITMAP   "Img0EUROS" ;
         ACTION   ( ClkMoneda( 0, oTotDiv:oCobrado, .t. ), ChkCobro( aTmp ) ) ;
         ID       815;
         OF       oDlg

      /*
      Cobrado en divisas__________________________________________________________________
      */

      REDEFINE GET oTotDiv:oCobrado ;
         VAR      oTotDiv:nCobrado ;
         ID       170 ;
         FONT     oFntDlg ;
         PICTURE  cPorDiv ;
         VALID    ( ChkCobro( aTmp, oTotDiv ) ) ;
         OF       oDlg

      REDEFINE BUTTONBMP oBtnCalculator ;
         ID       220 ;
         OF       oDlg ;
         BITMAP   "Calculator_32" ;
         ACTION   ( Calculadora( 0, oTotDiv:oCobrado ), ChkCobro( aTmp ) )

      REDEFINE BITMAP aBmpDiv[ 1 ] ;
         RESOURCE cFilBmpDiv( cDivEmp(), dbfDiv, oBandera ) ;
         ID       171;
         ADJUST ;
         OF       oDlg

      /*
      Cambio en divisas del cambio____________________________________________
		*/

      REDEFINE SAY oTotDiv:oCambio ;
         VAR      oTotDiv:nCambio ;
         ID       180 ;
			FONT 		oFntDlg ;
         PICTURE  cPorDiv ;
         OF       oDlg

      REDEFINE SAY oTotDiv:oCambioDivisa ;
         VAR      oTotDiv:nCambioDivisa ;
         ID       182 ;
         FONT     oFntDlg ;
         PICTURE  cPicEur ;
         OF       oDlg

      /*
      Botones__________________________________________________________________
      */

      REDEFINE BUTTON oBtnAceptarImprimir ;
         ID       IDOK ;
         OF       oDlg ;
         ACTION   ( if( lValidaCobro( aGet, @aTmp, @lGenVale, @nDifVale, nSave ), ( lCopTik := .t., oDlg:end( IDOK ) ), ) )

      REDEFINE BUTTON oBtnAceptar;
         ID       552 ;
         OF       oDlg ;
         ACTION   ( if( lValidaCobro( aGet, @aTmp, @lGenVale, @nDifVale, nSave ), ( lCopTik := .f., oDlg:end( IDOK ) ), ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
         OF       oDlg ;
         CANCEL ;
         ACTION   ( oDlg:end() )

      /*
      Pagos
		------------------------------------------------------------------------
		*/

   if !lBig

      if nSave == SAVALB

         /*
         Entregas a cuentas en albaranes de clientes---------------------------
         */

         REDEFINE BUTTON aBtnCob[ 1 ];
            ID       300 ;
            OF       oDlg;
            ACTION   ( WinAppRec( oBrwPgo, bEditE, dbfTmpE, , , aTmp ) )

         REDEFINE BUTTON aBtnCob[ 2 ];
            ID       301 ;
            OF       oDlg;
            ACTION   ( WinEdtRec( oBrwPgo, bEditE, dbfTmpE, , , aTmp ) )

         REDEFINE BUTTON aBtnCob[ 3 ];
            ID       302 ;
            OF       oDlg;
            ACTION   ( if( ( dbfTmpE )->lCloPgo .and. !oUser():lAdministrador(), MsgStop( "Solo pueden eliminar las entregas cerradas los administradores." ), dbDelRec( oBrwPgo, dbfTmpE ) ) )

         REDEFINE BUTTON aBtnCob[ 6 ];
            ID       303 ;
            OF       oDlg;
            ACTION   ( PrnEntAlbCli( .f., dbfTmpE ) )

         oBrwPgo                 := IXBrowse():New( oDlg )

         oBrwPgo:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
         oBrwPgo:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

         oBrwPgo:bLDblClick      := {|| WinEdtRec( oBrwPgo, bEditE, dbfTmpE, , aTmp ) }

         oBrwPgo:cAlias          := dbfTmpE
         oBrwPgo:nMarqueeStyle   := 5
         oBrwPgo:cName           := "Pagos.TPV"

         with object ( oBrwPgo:AddCol() )
            :cHeader          := "Cr. Cerrado"
            :bEditValue       := {|| ( dbfTmpE )->lCloPgo }
            :nWidth           := 20
            :SetCheck( { "Cnt16", "Nil16" } )
         end with

         with object ( oBrwPgo:AddCol() )
            :cHeader          := "Fecha"
            :bEditValue       := {|| Dtoc( ( dbfTmpE )->dEntrega ) }
            :nWidth           := 80
         end with

         with object ( oBrwPgo:AddCol() )
            :cHeader          := "Sesión"
            :bEditValue       := {|| ( dbfTmpE )->cTurRec }
            :nWidth           := 40
            :nDataStrAlign    := 1
            :nHeadStrAlign    := 1
         end with

         with object ( oBrwPgo:AddCol() )
            :cHeader          := "Caja"
            :bEditValue       := {|| ( dbfTmpE )->cCodCaj }
            :nWidth           := 40
         end with

         with object ( oBrwPgo:AddCol() )
            :cHeader          := "Pago"
            :bEditValue       := {|| ( dbfTmpE )->cCodPgo }
            :nWidth           := 40
         end with

         with object ( oBrwPgo:AddCol() )
            :cHeader          := "Descripción"
            :bEditValue       := {|| ( dbfTmpE )->cDescrip }
            :nWidth           := 100
         end with

         with object ( oBrwPgo:AddCol() )
            :cHeader          := "Importe"
            :bEditValue       := {|| nEntAlbCli( dbfTmpE, dbfDiv, cDivEmp(), .t. ) }
            :nWidth           := 80
            :nDataStrAlign    := 1
            :nHeadStrAlign    := 1
         end with

         oBrwPgo:CreateFromResource( 310 )

      else

         REDEFINE BUTTON aBtnCob[ 1 ];
            ID       300 ;
            OF       oDlg;
            ACTION   (  if( !( dbfTmpP )->lCloPgo,;
                        ( WinAppRec( oBrwPgo, bEditP, dbfTmpP, , , aTmp ), CalImpCob( aTmp ) ),;
                        ( MsgStop( "Pago cerrado" ) ) ) )

         REDEFINE BUTTON aBtnCob[ 2 ];
            ID       301 ;
            OF       oDlg;
            ACTION   (  if( !( dbfTmpP )->lCloPgo,;
                        ( WinEdtRec( oBrwPgo, bEditP, dbfTmpP, , , aTmp ), CalImpCob( aTmp ) ),;
                        ( MsgStop( "Pago cerrado" ) ) ) )

         REDEFINE BUTTON aBtnCob[ 3 ];
            ID       302 ;
            OF       oDlg;
            ACTION   (  if( !( dbfTmpP )->lCloPgo,;
                        ( DbDelRec( oBrwPgo, dbfTmpP ), CalImpCob( aTmp ) ),;
                        ( MsgStop( "Pago cerrado" ) ) ) )

         REDEFINE BUTTON aBtnCob[ 6 ];
            ID       303 ;
            OF       oDlg;
            ACTION   ( nil )

         oBrwPgo                 := IXBrowse():New( oDlg )

         oBrwPgo:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
         oBrwPgo:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

         oBrwPgo:bLDblClick      := {|| if( !( dbfTmpP )->lCloPgo, ( WinEdtRec( oBrwPgo, bEditP, dbfTmpP, , , aTmp ), CalImpCob( aTmp ) ), ( MsgStop( "Pago cerrado" ) ) ) }

         oBrwPgo:cAlias          := dbfTmpP
         oBrwPgo:nMarqueeStyle   := 5
         oBrwPgo:cName           := "Pagos.TPV"

         with object ( oBrwPgo:AddCol() )
            :cHeader          := "Cr. Cerrado"
            :bEditValue       := {|| ( dbfTmpP )->lCloPgo }
            :nWidth           := 20
            :SetCheck( { "Cnt16", "Nil16" } )
         end with

         with object ( oBrwPgo:AddCol() )
            :cHeader          := "Fecha"
            :bEditValue       := {|| Dtoc( ( dbfTmpP )->dPgoTik ) }
            :nWidth           := 80
         end with

         with object ( oBrwPgo:AddCol() )
            :cHeader          := "Sesión"
            :bEditValue       := {|| ( dbfTmpP )->cTurPgo }
            :nWidth           := 50
            :nDataStrAlign    := 1
            :nHeadStrAlign    := 1
         end with

         with object ( oBrwPgo:AddCol() )
            :cHeader          := "Caja"
            :bEditValue       := {|| ( dbfTmpP )->cCodCaj }
            :nWidth           := 40
         end with

         with object ( oBrwPgo:AddCol() )
            :cHeader          := "Pago"
            :bEditValue       := {|| ( dbfTmpP )->cFpgPgo }
            :nWidth           := 40
         end with

         with object ( oBrwPgo:AddCol() )
            :cHeader          := "Descripción"
            :bEditValue       := {|| ( dbfTmpP )->cPgdPor }
            :nWidth           := 100
         end with

         with object ( oBrwPgo:AddCol() )
            :cHeader          := "Importe"
            :bEditValue       := {|| ( dbfTmpP )->nImpTik }
            :cEditPicture     := cPorDiv
            :nWidth           := 80
            :nDataStrAlign    := 1
            :nHeadStrAlign    := 1
         end with

         with object ( oBrwPgo:AddCol() )
            :cHeader          := "Devolución"
            :bEditValue       := {|| ( dbfTmpP )->nDevTik }
            :cEditPicture     := cPorDiv
            :nWidth           := 80
            :nDataStrAlign    := 1
            :nHeadStrAlign    := 1
         end with

         oBrwPgo:CreateFromResource( 310 )

         /*
         REDEFINE LISTBOX oBrwPgo ;
            FIELDS ;
                     if( ( dbfTmpP )->lCloPgo, aDbfBmp[ 4 ], "" ),;
                     DtoC( ( dbfTmpP )->dPgoTik ),;
                     ( dbfTmpP )->cFpgPgo,;
                     ( dbfTmpP )->cTurPgo,;
                     ( dbfTmpP )->cPgdPor,;
                     hBmpDiv( ( dbfTmpP )->cDivPgo, dbfDiv, oBandera ),;
                     Trans(   ( dbfTmpP )->nImpTik, cPorDiv ),;
                     Trans(   ( dbfTmpP )->nDevTik, cPorDiv );
            FIELDSIZES ;
                     17,;
                     70,;
                     30,;
                     40,;
                     100,;
                     25,;
                     80,;
                     80 ;
            HEAD ;
                     "C",;
                     "Fecha",;
                     "F.P.",;
                     "Sesión",;
                     "Pagado por",;
                     "Div",;
                     "Importe",;
                     "Devolución" ;
            ALIAS    ( dbfTmpP );
            ID       310 ;
            OF       oDlg

            oBrwPgo:aJustify     := { .f., .f., .f., .t., .f., .f., .t., .t. }
         */

      end if

      do case
      case nSave == SAVTIK

      TGroup():ReDefine( 900, "Vales", oDlg )

      REDEFINE BUTTON aBtnCob[ 4 ];
         ID       320 ;
         OF       oDlg;
         ACTION   ( BrwValTik( dbfTikT, dbfTikL, dbfIva, dbfDiv, dbfTmpV, oBrwVal ), CalImpCob( aTmp ) )

      REDEFINE BUTTON aBtnCob[ 5 ];
         ID       321 ;
         OF       oDlg ;
         ACTION   ( delRecno( dbfTmpV, oBrwVal ), CalImpCob( aTmp ) )

      oBrwVal                 := IXBrowse():New( oDlg )

      oBrwVal:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwVal:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrwVal:cAlias          := dbfTmpV
      oBrwVal:nMarqueeStyle   := 5
      oBrwVal:cName           := "Vales.TPV"

      with object ( oBrwVal:AddCol() )
         :cHeader          := "Número"
         :bEditValue       := {|| ( dbfTmpV )->cSerTik + "/" + lTrim( ( dbfTmpV )->cNumTik ) + "/" + ( dbfTmpV )->cSufTik  }
         :nWidth           := 80
      end with

      with object ( oBrwVal:AddCol() )
         :cHeader          := "Fecha"
         :bEditValue       := {|| Dtoc( ( dbfTmpV )->dFecTik ) }
         :nWidth           := 80
      end with

      with object ( oBrwVal:AddCol() )
         :cHeader          := "Sesión"
         :bEditValue       := {|| ( dbfTmpV )->cTurTik }
         :nWidth           := 50
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      with object ( oBrwVal:AddCol() )
         :cHeader          := "Código"
         :bEditValue       := {|| ( dbfTmpV )->cCliTik }
         :nWidth           := 80
      end with

      with object ( oBrwVal:AddCol() )
         :cHeader          := "Nombre"
         :bEditValue       := {|| ( dbfTmpV )->cNomTik }
         :nWidth           := 180
      end with

      with object ( oBrwVal:AddCol() )
         :cHeader          := "Caja"
         :bEditValue       := {|| ( dbfTmpV )->cCcjTik }
         :nWidth           := 40
      end with

      with object ( oBrwVal:AddCol() )
         :cHeader          := "Almacén"
         :bEditValue       := {|| ( dbfTmpV )->cAlmTik }
         :nWidth           := 40
      end with

      with object ( oBrwVal:AddCol() )
         :cHeader          := "Importe"
         :bEditValue       := {|| nTotalizer( ( dbfTmpV )->cSerTik + ( dbfTmpV )->cNumTik + ( dbfTmpV )->cSufTik, dbfTikT, dbfTikL, dbfTikP, dbfAlbCliT, dbfAlbCliL, dbfFacCliT, dbfFacCliL, dbfFacCliP, dbfIva, dbfDiv, cDivEmp(), .t. ) }
         :nWidth           := 80
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      with object ( oBrwVal:AddCol() )
         :cHeader          := "Div."
         :bEditValue       := {|| cSimDiv( ( dbfTmpV )->cDivTik, dbfDiv )}
         :nWidth           := 20
      end with

      oBrwVal:CreateFromResource( 330 )

      /*
      REDEFINE LISTBOX oBrwVal ;
			FIELDS;
                  ( dbfTmpV )->cSerTik + "/" + lTrim( ( dbfTmpV )->cNumTik ) + "/" + ( dbfTmpV )->cSufTik ,;
                  dtoc( ( dbfTmpV )->dFecTik ),;
                  Rtrim( ( dbfTmpV )->cCliTik ) + Space( 1 ) + ( dbfTmpV )->cNomTik,;
                  hBmpDiv( ( dbfTmpV )->cDivTik, dbfDiv, oBandera ),;
                  nTotalizer( ( dbfTmpV )->cSerTik + ( dbfTmpV )->cNumTik + ( dbfTmpV )->cSufTik, dbfTikT, dbfTikL, dbfTikP, dbfAlbCliT, dbfAlbCliL, dbfFacCliT, dbfFacCliL, dbfFacCliP, dbfIva, dbfDiv, cDivEmp(), .t. ),;
                  ( dbfTmpV )->cTurTik + "/" + ( dbfTmpV )->cSufTik,;
                  ( dbfTmpV )->cHorTik,;
                  ( dbfTmpV )->cNcjTik,;
                  ( dbfTmpV )->cCcjTik,;
                  ( dbfTmpV )->cAlmTik ;
         HEAD;
                  "Num.",;
                  "Fecha",;
                  "Cliente",;
                  "Div.",;
                  "Importe",;
                  "Sesión",;
                  "Hora",;
                  "Caja",;
                  "Cajero",;
                  "Almacén";
         FIELDSIZES;
                  90,;
                  70,;
                  180,;
                  20,;
                  80,;
                  60,;
                  40,;
                  40,;
                  40,;
                  40;
         ID       330 ;
         ALIAS    ( dbfTmpV ) ;
			OF 		oDlg

         oBrwVal:aJustify  := { .f., .f., .f., .f., .t., .f., .f., .f., .f., .f. }
      */

      case nSave == SAVFAC

      TGroup():ReDefine( 900, "Anticipos", oDlg )

      REDEFINE BUTTON aBtnCob[ 4 ];
         ID       320 ;
         OF       oDlg;
         ACTION   ( BrwAntCli( nil, dbfAntCliT, dbfIva, dbfDiv, dbfTmpA, oBrwVal ), CalImpCob( aTmp ) )

      REDEFINE BUTTON aBtnCob[ 5 ];
         ID       321 ;
         OF       oDlg ;
         ACTION   ( delRecno( dbfTmpA, oBrwVal ), CalImpCob( aTmp ) )

      oBrwVal                 := IXBrowse():New( oDlg )

      oBrwVal:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwVal:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrwVal:cAlias          := dbfTmpA
      oBrwVal:nMarqueeStyle   := 5
      oBrwVal:cName           := "Anticipos.TPV"

      with object ( oBrwVal:AddCol() )
         :cHeader          := "Número"
         :bEditValue       := {|| ( dbfTmpA )->cSerAnt + "/" + lTrim( Str( ( dbfTmpA )->nNumAnt ) ) + "/" + ( dbfTmpA )->cSufAnt }
         :nWidth           := 80
      end with

      with object ( oBrwVal:AddCol() )
         :cHeader          := "Fecha"
         :bEditValue       := {|| Dtoc( ( dbfTmpA )->dFecAnt ) }
         :nWidth           := 80
      end with

      with object ( oBrwVal:AddCol() )
         :cHeader          := "Sesión"
         :bEditValue       := {|| ( dbfTmpA )->cTurAnt }
         :nWidth           := 50
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      with object ( oBrwVal:AddCol() )
         :cHeader          := "Código"
         :bEditValue       := {|| ( dbfTmpA )->cCodCli }
         :nWidth           := 80
      end with

      with object ( oBrwVal:AddCol() )
         :cHeader          := "Nombre"
         :bEditValue       := {|| ( dbfTmpA )->cNomCli }
         :nWidth           := 180
      end with

      with object ( oBrwVal:AddCol() )
         :cHeader          := "Caja"
         :bEditValue       := {|| ( dbfTmpA )->cCodCaj }
         :nWidth           := 40
      end with

      with object ( oBrwVal:AddCol() )
         :cHeader          := "Almacén"
         :bEditValue       := {|| ( dbfTmpA )->cCodAlm }
         :nWidth           := 40
      end with

      with object ( oBrwVal:AddCol() )
         :cHeader          := "Importe"
         :bEditValue       := {|| nTotAntCli( dbfTmpA, dbfIva, dbfDiv, nil, cDivEmp(), .t. ) }
         :nWidth           := 80
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      with object ( oBrwVal:AddCol() )
         :cHeader          := "Div."
         :bEditValue       := {|| cSimDiv( ( dbfTmpA )->cDivAnt, dbfDiv ) }
         :nWidth           := 20
      end with

      oBrwVal:CreateFromResource( 330 )

      /*
      REDEFINE LISTBOX oBrwVal ;
			FIELDS;
                  ( dbfTmpA )->cSerAnt + "/" + lTrim( Str( ( dbfTmpA )->nNumAnt ) ) + "/" + ( dbfTmpA )->cSufAnt,;
                  dtoc( ( dbfTmpA )->dFecAnt ),;
                  Rtrim( ( dbfTmpA )->cCodCli ) + Space( 1 ) + ( dbfTmpA )->cNomCli,;
                  hBmpDiv( ( dbfTmpA )->cDivAnt, dbfDiv, oBandera ),;
                  nTotAntCli( dbfTmpA, dbfIva, dbfDiv, nil, cDivEmp(), .t. ),;
                  ( dbfTmpA )->cTurAnt + "/" + ( dbfTmpA )->cSufAnt ;
         HEAD;
                  "Num.",;
                  "Fecha",;
                  "Cliente",;
                  "Div.",;
                  "Importe",;
                  "Sesión" ;
         FIELDSIZES;
                  90,;
                  70,;
                  180,;
                  20,;
                  80,;
                  60 ;
         ID       330 ;
         ALIAS    ( dbfTmpA ) ;
			OF 		oDlg

         oBrwVal:aJustify  := { .f., .f., .f., .f., .t., .f. }
      */

      otherwise

      REDEFINE BUTTON aBtnCob[ 4 ];
         ID       320 ;
         OF       oDlg;
         ACTION   ( nil )

      REDEFINE BUTTON aBtnCob[ 5 ];
         ID       321 ;
         OF       oDlg ;
         ACTION   ( nil )

      REDEFINE LISTBOX oBrwVal ;
         FIELDS   "";
         HEAD     "";
         ID       330 ;
			OF 		oDlg

      end case

   end if

   oDlg:bStart    := {|| StartCobro( aTmp, aGet, aGetCob, aBtnCob, aBmpDiv, aSay, oBtnTop, oBtnDwn, oBrwPgo, oBrwVal, oBtnCalculator, nSave, nMode ) }

   oDlg:AddFastKey( VK_F5, {|| if( lValidaCobro( aGet, @aTmp, @lGenVale, @nDifVale, nSave ), ( lCopTik := .f., oDlg:end( IDOK ) ), ) } )

   ACTIVATE DIALOG oDlg CENTER

   oFntDlg:end()

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

Static Function bButtonsPago( cCodPago, oGetPago )

Return ( {|| oGetPago:cText( cCodPago ), oGetPago:lValid() } )

//---------------------------------------------------------------------------//

Static Function StartCobro( aTmp, aGet, aGetCob, aBtnCob, aBmpDiv, aSay, oBtnTop, oBtnDwn, oBrwPgo, oBrwVal, oBtnCalculator, nSave, nMode )

   local oBtn

   CalImpCob( aTmp )

   ChkCobro( aTmp )

   /*
   Set controles de la ventana de cobros---------------------------------------
   */

   if aGetCob[ 2 ] != nil
      aGetCob[ 2 ]:lValid()
   end if

   if aGetCob[ 3 ] != nil
      aGetCob[ 3 ]:lValid()
   end if

   do case
   case nSave == SAVALB .or. nSave == SAVVAL .or. nSave == SAVDEV .or. nSave == SAVAPT

      oTotDiv:oEntregado:Hide()
      oTotDiv:oEntregadoDivisa:Hide()
      oTotDiv:oCobrado:Hide()
      oTotDiv:oCambio:Hide()
      oTotDiv:oCambioDivisa:Hide()

      if !Empty( aBtnCob[ 4 ] )
         aBtnCob[ 4 ]:Hide()
      end if

      if !Empty( aBtnCob[ 5 ] )
         aBtnCob[ 5 ]:Hide()
      end if

      if !Empty( aBtnCob[ 6 ] )
         if nSave == SAVALB
            aBtnCob[ 6 ]:Show()
         else
            aBtnCob[ 6 ]:Hide()
         end if
      end if

      if !Empty( aBmpDiv[ 3 ] )
         aBmpDiv[ 3 ]:Hide()
      end if

      aSay[ 1 ]:Hide()
      aSay[ 2 ]:Hide()
      aSay[ 3 ]:Hide()

      if aGetCob[ 1 ] != nil
         aGetCob[ 1 ]:SetFocus()
      end if

      if oBrwVal != nil
         oBrwVal:Hide()
      end if

      if !Empty( oBtnCalculator )
         oBtnCalculator:Hide()
      end if

   case nSave == SAVFAC

      if aGetCob[ 1 ] != nil
         aGetCob[ 1 ]:SetFocus()
      end if

      if !Empty( aBtnCob[ 6 ] )
         aBtnCob[ 6 ]:Hide()
      end if

   end case

   /*
   Botones en funcion del mode-------------------------------------------------
   */

   if nMode != APPD_MODE

      if oBtnTop != nil
         oBtnTop:Hide()
      end if

      if oBtnDwn != nil
         oBtnDwn:Hide()
      end if

      if nSave != SAVALB .and. !Empty( aBtnCob[ 6 ] )
         aBtnCob[ 6 ]:Hide()
      end if

   end if

   /*
   Botones de formas de pago---------------------------------------------------
   */

   for each oBtn in aButtonsPago

      if !Empty( oBtn:oButton )
         oBtn:oButton:Show()
      end if

      if !Empty( oBtn:oSay )
         oBtn:oSay:Show()
      end if

   next

   /*
   Valid del codigo de cliente-------------------------------------------------
   */

   if !Empty( aGet[ _CCLITIK ] )
      aGet[ _CCLITIK ]:lValid()
   end if

Return .t.

//---------------------------------------------------------------------------//

Static Function lValidaCobro( aGet, aTmp, lGenVale, nDifVale, nSave )

   local nTotalVale

   /*
   Chequeamos la forma de pago para que no esté vacía--------------------------
   */

   if Empty( aTmp[ _CFPGTIK ] )
      msgStop( "Tiene que seleccionar una forma de pago" )
      aGet[ _CFPGTIK ]:SetFocus()
      Return .f.
   end if

   /*
   Checkea los valores de los cobros-------------------------------------------
   */

   ChkCobro( aTmp )

   /*
   Diferencias-----------------------------------------------------------------
   */

   nTotalVale              := nTotValTik( nil, dbfTmpV, dbfTikL, dbfDiv, cDivEmp() )
   nDifVale                := nTotalVale - oTotDiv:nTotal

   /*
   El tiket ya no esta abierto-------------------------------------------------
   */

   aTmp[ _LABIERTO ]       := .f.

   /*
   Cambio y salvar como factura------------------------------------------------
   */

   if lNegativo( oTotDiv:nCambio ) .and. ( nSave == SAVTIK .or. nSave == SAVFAC )
      if !MsgBeepYesNo( "¿Desea vender a credito al cliente " + CRLF + Rtrim( aTmp[ _CNOMTIK ] ) + "?", "Importe insuficiente" )
         return .f.
      else
         aTmp[ _LPGDTIK ]  := .f.
      end if
   else
      aTmp[ _LPGDTIK ]     := .t.
   end if

   /*
   Vamos a detectar si el importe de los vales es superior al tiket------------
   */

   if nTotalVale > 0 .and. nDifVale > 0
      if MsgBeepYesNo( "¿Desea generar un vale por la diferencia?", "Importe de vale excede el total" )
         lGenVale          := .t.
      end if
   end if

   aTmp[ _NCOBTIK ]        := oTotDiv:nCobrado
   aTmp[ _NCAMTIK ]        := oTotDiv:nCambio

return .t.

//----------------------------------------------------------------------------//

static function SetCobro( aGet, aGetCob, nSave, nMode, aBtnCob, aBmpDiv, aSay, oBtnTop, oBtnDwn, oBrwPgo, oBrwVal, oBtnCalculator )


return nil

//-------------------------------------------------------------------------//

static function CalImpCob( aTmp )

   oTotDiv:nCobrado           := nTotCobTik( nil, dbfTmpP, dbfDiv, cDivEmp() )
   oTotDiv:nVale              := nTotValTik( nil, dbfTmpV, dbfTikL, dbfDiv, cDivEmp() )
   oTotDiv:nAnticipo          := nTotAntFacCli( nil, dbfTmpA, dbfIva, dbfDiv, cDivEmp() )
   oTotDiv:nEntregado         := ( oTotDiv:nCobrado + oTotDiv:nVale + oTotDiv:nAnticipo )
   oTotDiv:nCobrado           := ( oTotDiv:nTotal - oTotDiv:nEntregado )
   oTotDiv:nCambio            := - ( oTotDiv:nTotal - oTotDiv:nEntregado - oTotDiv:nCobrado )

   oTotDiv:nTotalDivisa       := nCnv2Div( oTotDiv:nTotal,     aTmp[ _CDIVTIK ], cDivChg() )
   oTotDiv:nEntregadoDivisa   := nCnv2Div( oTotDiv:nEntregado, aTmp[ _CDIVTIK ], cDivChg() )
   oTotDiv:nCambioDivisa      := nCnv2Div( oTotDiv:nCambio,    aTmp[ _CDIVTIK ], cDivChg() )  // A cobrar menos entregado

   oTotDiv:oTotalDivisa:Refresh()
   oTotDiv:oEntregado:Refresh()
   oTotDiv:oEntregadoDivisa:Refresh()
   oTotDiv:oCobrado:Refresh()
   oTotDiv:oCambio:Refresh()
   oTotDiv:oCambioDivisa:Refresh()

return .t.

//-------------------------------------------------------------------------//

static function ChkCobro( aTmp )

   oTotDiv:nCambio            := - ( oTotDiv:nTotal - oTotDiv:nEntregado - oTotDiv:nCobrado )

   oTotDiv:nCambioDivisa      := nCnv2Div( oTotDiv:nCambio,    aTmp[ _CDIVTIK ], cDivChg() )

   oTotDiv:oCobrado:Refresh()
   oTotDiv:oCambio:Refresh()
   oTotDiv:oCambioDivisa:Refresh()

return .t.

//---------------------------------------------------------------------------//

/*
Colocamos las teclas rapidas

Static Function lCobroKeyDown( nKey, oBtnAceptarImprimir, oBtnAceptar )

   do case
   case nKey == VK_F5
      oBtnAceptarImprimir:Click()
   case nKey == VK_F6
      oBtnAceptar:Click()
   end case

Return Nil
*/

//--------------------------------------------------------------------------//

Static Function BrwValTik( dbfTikT, dbfTikL, dbfIva, dbfDiv, dbfTmpV, oBrwVal )

   local oDlg
	local oBrw
   local nBmp           := LoadBitmap( 0, 32760 )
   local aGet1
	local cGet1
   local oCbxOrd
   local oBtnSelect
   local oBtnUnSelect
   local cCbxOrd        := "Número"
   local nRecAnt        := ( dbfTikT )->( RecNo() )
   local nOrdAnt        := ( dbfTikT )->( OrdSetFocus( "cLiqVal" ) )

   /*
   Seleccionamos los q traiga del temporal-------------------------------------
   */

   ( dbfTmpV )->( dbGoTop() )
   while !( dbfTmpV )->( Eof() )
      if ( dbfTikT )->( dbSeek( ( dbfTmpV )->cSerTik + ( dbfTmpV )->cNumTik + ( dbfTmpV )->cSufTik ) )
         if dbLock( dbfTikT )
            ( dbfTikT )->lSelDoc := .t.
            ( dbfTikT )->( dbUnLock() )
         end if
      end if
      ( dbfTmpV )->( dbSkip() )
   end while

   /*
   Posicinamiento--------------------------------------------------------------
   */

   ( dbfTikT )->( dbGoTop() )

   DEFINE DIALOG oDlg RESOURCE "HelpEntry" TITLE 'Seleccionar vales'

      REDEFINE GET aGet1 ;
         VAR      cGet1;
			ID 		104 ;
			PICTURE	"@!" ;
         ON CHANGE( AutoSeek( nKey, nFlags, Self, oBrw, dbfTikT, .t. ) );
         VALID    ( OrdClearScope( oBrw, dbfTikT ) );
         COLOR    CLR_GET ;
			OF 		oDlg

		REDEFINE COMBOBOX oCbxOrd ;
			VAR 		cCbxOrd ;
			ID 		102 ;
         ITEMS    { "Número" };
         OF       oDlg

      oBrw                    := IXBrowse():New( oDlg )

      oBrw:bClrSel            := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrw:bClrSelFocus       := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrw:cAlias             := dbfTikT
      oBrw:cName              := "Vale detalle"
      oBrw:bLDblClick         := {|| if( dbLock( dbfTikT ), ( ( dbfTikT )->lSelDoc := !( dbfTikT )->lSelDoc, ( dbfTikT )->( dbUnLock() ) ), ), oBrw:DrawSelect() }

      oBrw:nMarqueeStyle      := 5

      oBrw:CreateFromResource( 105 )

      with object ( oBrw:AddCol() )
         :cHeader             := "Se. Seleccionado"
         :bStrData            := {|| "" }
         :bEditValue          := {|| ( dbfTikT )->lSelDoc }
         :nWidth              := 20
         :SetCheck( { "Sel16", "Nil16" } )
      end with

      with object ( oBrw:AddCol() )
         :cHeader             := "Número"
         :bEditValue          := {|| ( dbfTikT )->cSerTik + "/" + AllTrim( ( dbfTikT )->cNumTik ) + "/" + ( dbfTikT )->cSufTik }
         :nWidth              := 70
      end with

      with object ( oBrw:AddCol() )
         :cHeader             := "Fecha"
         :bEditValue          := {|| Dtoc( ( dbfTikT )->dFecTik ) }
         :nWidth              := 70
      end with

      with object ( oBrw:AddCol() )
         :cHeader             := "Código cliente"
         :bEditValue          := {|| Rtrim( ( dbfTikT )->cCliTik ) }
         :nWidth              := 75
      end with

      with object ( oBrw:AddCol() )
         :cHeader             := "Nombre cliente"
         :bEditValue          := {|| AllTrim( ( dbfTikT )->cNomTik ) }
         :nWidth              := 150
      end with

      with object ( oBrw:AddCol() )
         :cHeader             := "Importe "
         :bEditValue          := {|| nTotalizer( ( dbfTikT)->cSerTik + ( dbfTikT )->cNumTik + ( dbfTikT )->cSufTik, dbfTikT, dbfTikL, dbfTikP, dbfAlbCliT, dbfAlbCliL, dbfFacCliT, dbfFacCliL, dbfFacCliP, dbfIva, dbfDiv, cDivEmp(), .t. ) }
         :nWidth              := 85
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
      end with

      with object ( oBrw:AddCol() )
         :cHeader             := "Div."
         :bEditValue          := {|| cSimDiv( ( dbfTikT )->cDivTik, dbfDiv ) }
         :nWidth              := 30
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
      end with

      with object ( oBrw:AddCol() )
         :cHeader             := "Sesión"
         :bEditValue          := {|| ( dbfTikT )->cTurTik + "/" + ( dbfTikT )->cSufTik }
         :nWidth              := 80
         :lHide               := .t.
      end with

      with object ( oBrw:AddCol() )
         :cHeader             := "Hora"
         :bEditValue          := {|| ( dbfTikT )->cHorTik }
         :nWidth              := 80
         :lHide               := .t.
      end with

      with object ( oBrw:AddCol() )
         :cHeader             := "Caja"
         :bEditValue          := {|| ( dbfTikT )->cNcjTik }
         :nWidth              := 80
         :lHide               := .t.
      end with

      with object ( oBrw:AddCol() )
         :cHeader             := "Cajero"
         :bEditValue          := {|| ( dbfTikT )->cCcjTik }
         :nWidth              := 80
         :lHide               := .t.
      end with

      with object ( oBrw:AddCol() )
         :cHeader             := "Almacén"
         :bEditValue          := {|| ( dbfTikT )->cAlmTik }
         :nWidth              := 80
         :lHide               := .t.
      end with

      REDEFINE BUTTON oBtnSelect;
			ID 		500 ;
			OF 		oDlg ;
         ACTION   ( if( dbLock( dbfTikT ), ( ( dbfTikT )->lSelDoc := .t., ( dbfTikT )->( dbUnLock() ) ), ), oBrw:DrawSelect() )

      REDEFINE BUTTON oBtnUnSelect ;
			ID 		501 ;
			OF 		oDlg ;
         ACTION   ( if( dbLock( dbfTikT ), ( ( dbfTikT )->lSelDoc := .f., ( dbfTikT )->( dbUnLock() ) ), ), oBrw:DrawSelect() )

		REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
         ACTION   ( oDlg:end( IDOK ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
         CANCEL ;
         ACTION   ( oDlg:end() )

   oDlg:AddFastKey( VK_F5, {|| oDlg:end( IDOK ) } )
   oDlg:AddFastKey( VK_RETURN, {|| oDlg:end( IDOK ) } )

   ACTIVATE DIALOG oDlg ;
         CENTER ;
         ON INIT  ( SetWindowText( oBtnSelect:hWnd, "&Seleccionar" ), SetWindowText( oBtnUnSelect:hWnd, "&Deseleccionar" ), oBrw:Load() )

   /*
   Guardamos los vales en el array---------------------------------------------
   */

   if oDlg:nResult == IDOK

      ( dbfTmpV )->( __dbZap() )

      ( dbfTikT )->( dbGoTop() )
      while !( dbfTikT )->( Eof() )
         if ( dbfTikT )->lSelDoc
            dbPass( dbfTikT, dbfTmpV, .t. )
            if dbLock( dbfTikT )
               ( dbfTikT )->lSelDoc := .f.
               ( dbfTikT )->( dbUnLock() )
            end if
         end if
         ( dbfTikT )->( dbSkip() )
      end while

      ( dbfTmpV )->( dbGoTop() )

   end if

   if oBrwVal != nil
      oBrwVal:Refresh()
   end if

   /*
   Repos-----------------------------------------------------------------------
   */

   DeleteObject( nBmp )

   ( dbfTikT )->( OrdSetFocus( nOrdAnt ) )
   ( dbfTikT )->( dbGoTo( nRecAnt ) )


RETURN ( oDlg:nResult == IDOK )

//-------------------------------------------------------------------------//
/*
Estudia el cambio de precios
*/

STATIC FUNCTION lStdChange( aTmp, aGet )

   /*
   Detectamos el cambio de precio
   */

   if nOldPvp != aTmp[ _NPVPTIL ]

      /*
      Si le tipo de articulo es de acceso a preciso----------------------------
      */

      if aTmp[ _LTIPACC ] .and. !Empty( nOldPvp )
         aGet[ _NUNTTIL ]:cText( aTmp[ _NPVPTIL ] / nOldPvp )
         aGet[ _NPVPTIL ]:cText( nOldPvp )
      end if

   end if

RETURN .T.

//---------------------------------------------------------------------------//

/*
Comprueba si existen codigos repetidos
*/

STATIC FUNCTION lIsCode( aTmp, dbfTmpL, oBrw )

	local lReturn	:= .f.
   local nRecno   := ( dbfTmpL )->( RecNo() )

   /*
   Si el de tipo kit nos vamos-------------------------------------------------
   */

   if ( dbfKit )->( dbSeek( aTmp[ _CCBATIL ] ) )
      Return ( lReturn )
   end if

   /*
   Buscamos codigos iguales----------------------------------------------------
   */

   ( dbfTmpL )->( dbGoTop() )
   while !( dbfTmpL )->( eof() )

      /*
      Comprobamos que el codigo y el precio sean iguales y que no sean ofertas-
      */

      if ( dbfTmpL )->cCbaTil == aTmp[ _CCBATIL ]                    .and. ;
         ( dbfTmpL )->cComTil == aTmp[ _CCOMTIL ]                    .and. ;
         ( dbfTmpL )->cCodPr1 == aTmp[ _CCODPR1 ]                    .and. ;
         ( dbfTmpL )->cValPr1 == aTmp[ _CVALPR1 ]                    .and. ;
         ( dbfTmpL )->cCodPr2 == aTmp[ _CCODPR2 ]                    .and. ;
         ( dbfTmpL )->cValPr2 == aTmp[ _CVALPR2 ]                    .and. ;
         ( dbfTmpL )->nPvpTil == aTmp[ _NPVPTIL ]                    .and. ;
         Rtrim( ( dbfTmpL )->cNomTil ) == Rtrim( aTmp[ _CNOMTIL ] )

         /*
         Sumamos------------------------------------------------------------
         */

         ( dbfTmpL )->nUntTil += aTmp[ _NUNTTIL ]

         /*
         Tomamos el valor de retorno y saliendo-----------------------------
         */

         lReturn  := .t.

         exit

      end if

      ( dbfTmpL )->( dbSkip() )

   end while

   ( dbfTmpL )->( dbGoTo( nRecno ) )

   if oBrw != nil
      oBrw:Refresh()
   end if

Return ( lReturn )

//-------------------------------------------------------------------------//

STATIC FUNCTION nVentasPrevias( cCodArt, dbfTmpL, nMode )

   local nRecno         := ( dbfTmpL )->( RecNo() )
   local nVentasPrevias := 0

   if nMode == APPD_MODE

      /*
		Buscamos codigos iguales
		*/

      ( dbfTmpL )->( dbGoTop() )
      while !( dbfTmpL )->( eof() )

			/*
         Comprobamos que el codigo y el precio sean iguales y que no sean ofertas
         */

         if ( dbfTmpL )->cCbaTil == cCodArt
            nVentasPrevias += ( dbfTmpL )->nUntTil
         end if

         ( dbfTmpL )->( dbSkip() )

      end while

   end if

   ( dbfTmpL )->( dbGoTo( nRecno ) )

RETURN ( nVentasPrevias )

//-------------------------------------------------------------------------//

/*
Esta funci¢n chequea las ofertas, devuelve .t. si existen ofertas
*/

STATIC FUNCTION lChkOfe( aTmp, aTik, dbfTmpL, oBrw )

	local lOfe		:= .f.
	local dFecTik	:= aTik[ _DFECTIK ]
   local nRecno   := ( dbfTmpL )->( RecNo() )

   ( dbfTmpL )->( dbGoTop() )

   WHILE !( dbfTmpL )->( eof() )

		/*
		Si ya tiene oferta, pasamos
		*/

      IF !( dbfTmpL )->LOFETIL

			/*
			Buscamos ofertas
			*/

         IF lIsOfe( dFecTik, aTmp, dbfTmpL, dbfOferta )

				/*
				Comprobamos que la oferta ya exista en pantalla
				*/

				lOfe := .t.

			END IF

		END IF

      ( dbfTmpL )->( dbSkip() )

	END WHILE

   ( dbfTmpL )->( dbGoTo( nRecno ) )

	oBrw:refresh()

RETURN lOfe

//-------------------------------------------------------------------------//

/*
Devuelve el precio de un producto este de oferta
*/

STATIC FUNCTION lIsOfe( dFecOfe, aTmp, dbfTemp, dbfOferta )

	local lPreOfe	:= .f.
   local cCodArt  := ( dbfTmpL )->cCbaTil
   local nUntArt  := ( dbfTmpL )->nUntTil

	/*
	Primero buscar si existe el articulo en la oferta
	*/

   if ( dbfOferta )->( dbSeek( cCodArt ) )

      while ( dbfOferta )->cArtOfe == cCodArt .and. !( dbfOferta )->( eof() )

			/*
			Comprobamos si esta entre las fechas
			*/

         if ( dFecOfe >= ( dbfOferta )->dIniOfe .OR. empty( ( dbfOferta )->dIniOfe ) ) .AND. ;
            ( dFecOfe <= ( dbfOferta )->dFinOfe .OR. empty( ( dbfOferta )->dFinOfe ) )

				/*
				Comprobamos que no vayamos a vender mas articulos que los del lote
				*/

            if ( dbfOferta )->nMaxOfe == 0                                 .or. ;
               nUntArt + ( dbfOferta )->nUdvOfe > ( dbfOferta )->nMaxOfe

					/*
					Comprobamos el numero de unidades a vender es igual a de la oferta
					o si al dividirlo devuelve un numero de resto 0 tendremos un
					multiplo de la oferta
					*/

               if mod( nUntArt, ( dbfOferta )->nUnvOfe ) == 0

						/*
						Cambiamos las unidades por el numero de unidades a vender
						entre los de la oferta
						Recogemos el precio de la oferta
						*/

                  ( dbfTmpL )->cNomTil  := ( dbfOferta )->CDESOFE
                  ( dbfTmpL )->nUntTil  := nUntArt / ( dbfOferta )->NUNVOFE
                  ( dbfTmpL )->nPvpTil  := ( dbfOferta )->nPreIva1
                  ( dbfTmpL )->lOfeTil  := .t.

                  lPreOfe               := .t.

						EXIT

               end if

            end if

         end if

		( dbfOferta )->( dbSkip() )

      end do

   end if

RETURN lPreOfe

//---------------------------------------------------------------------------//

/*
Comprueba si existen codigos repetidos despues de aplicar ofertas
*/

STATIC FUNCTION lIsOfeYet( dbfTmpL, oBrw )

	local aTmp
	local nRecIni
   local nRecFin  := ( dbfTmpL )->( recno() )

   ( dbfTmpL )->( dbGoTop() )

   while !( dbfTmpL )->( eof() ) .and. ( dbfTmpL )->( lastrec() ) > 1

      nRecIni  := ( dbfTmpL )->( RecNo() )
      aTmp     := dbScatter( dbfTmpL )
      ( dbfTmpL )->( dbSkip(1) )

      while !( dbfTmpL )->( eof() )

         /*
         Comprobamos que el codigo y el precio sean iguales
         */

         IF ( dbfTmpL )->cCbaTil == aTmp[ _CCBATIL ] .and. ;
            ( dbfTmpL )->cNomTil == aTmp[ _CNOMTIL ] .and. ;
            ( dbfTmpL )->nPvpTil == aTmp[ _NPVPTIL ] .and. ;
            ( dbfTmpL )->lFreTil == aTmp[ _LFRETIL ]

            /*
            Suma, Elimina el actual y Escribe en disco
            */

            aTmp[ _NUNTTIL ] += ( dbfTmpL )->NUNTTIL
            delRecno( dbfTmpL, oBrw )
            dbGather( aTmp, dbfTmpL )

         END IF

         ( dbfTmpL )->( dbSkip() )

      END WHILE

      ( dbfTmpL )->( dbGoTo( ++nRecIni ) )

	END WHILE

   ( dbfTmpL )->( dbGoTo( nRecFin ) )

RETURN NIL

//---------------------------------------------------------------------------//

/*
Cambia el picture de la divisa
*/

STATIC FUNCTION ChgDiv( cCodDiv, dbfDiv, oNumTot )

   cPouDiv              := cPouDiv( cCodDiv, dbfDiv )

   if oNumTot != nil
		oNumTot:cPicture	:= cPouDiv
		oNumTot:refresh()
   end if

   if oBrwDet != nil
		oBrwDet:refresh()
   end if

RETURN .T.

//--------------------------------------------------------------------------//

/*
Devuelve la fecha de un tiket
*/

FUNCTION dFecTik( cNumTik, uTikT )

   local dDate    := ctod( "" )

   if ValType( uTikT ) == "C"

      if ( uTikT )->( dbSeek( cNumTik ) )
         dDate    := ( uTikT )->dFecTik
      end if

   else

      if uTikT:Seek( cNumTik )
         dDate    := uTikT:dFecTik
      end if

   end if

RETURN dDate

//--------------------------------------------------------------------------//
/*
STATIC FUNCTION DisVis( PriLin, SecLin, cFilBmp )

   DEFAULT PriLin    := "Gracias por su visita"
   DEFAULT SecLin    := 0
   DEFAULT cFilBmp   := ""

	oDesVis:SetText( PriLin )
   oTotVis:SetText( SecLin )

   cFilBmp           := rtrim( cFilBmp )

   IF file( cFilBmp )
      oBmpVis:LoadBmp( cFilBmp )
   ELSE
      oBmpVis:LoadBmp( bmpEmp )
   END IF

RETURN NIL
*/
//---------------------------------------------------------------------------//

/*
Devuelve el precio de un producto en tikets
*/

function nPreTpv( uTmp, dbfTmpL )

   local nDec
   local nVdv
   local nCalculo := 0

   if valtype( uTmp ) == "A"
      nDec     := nDouDiv( uTmp[ _CDIVTIK ], dbfDiv )
      nVdv     := uTmp[ _NVDVTIK ]
   else
      nDec     := nDouDiv( ( uTmp )->cDivTik, dbfDiv )
      nVdv     := ( uTmp )->nVdvTik
   end if

   if !( dbfTmpL )->lFreTil

      nCalculo := ( dbfTmpL )->nPvpTil                       // Precio
      nCalculo -= ( dbfTmpL )->nDtoDiv                       // Dto Lineal
      nCalculo -= ( dbfTmpL )->nDtoLin * nCalculo / 100      // Dto porcentual
      nCalculo += ( dbfTmpL )->nPcmTil                       // Precio de combinado

      if nVdv != 0
         nCalculo    := Round( nCalculo / nVdv, nDec )
      end if

   end if

RETURN ( nCalculo )

//--------------------------------------------------------------------------//
//
// Devuelve el total de la venta en Facturas de un clientes determinado
//

function nVtaTik( cCodCli, dDesde, dHasta, dbfTikT, dbfTikL, dbfIva, dbfDiv )

   local nCon     := 0
   local aSta     := aGetStatus( dbfTikT )

   /*
   Facturas a Clientes -------------------------------------------------------
   */

   if ( dbfTikT )->( dbSeek( cCodCli ) )

      while ( dbfTikT )->cCliTik = cCodCli .and. !( dbfTikT )->( Eof() )

         if ( dDesde == nil .or. ( dbfTikT )->dFecTik >= dDesde ) .and.;
            ( dHasta == nil .or. ( dbfTikT )->dFecTik <= dHasta )

            if ( dbfTikT )->cTipTik == SAVTIK

               nCon  += nTotTik( ( dbfTikT )->cSerTik + (dbfTikT)->cNumTik + (dbfTikT)->cSufTik, dbfTikT, dbfTikL, dbfDiv, nil, cDivEmp(), .f. )

            elseif ( dbfTikT )->cTipTik == SAVDEV

               nCon  -= nTotTik( ( dbfTikT )->cSerTik + (dbfTikT)->cNumTik + (dbfTikT)->cSufTik, dbfTikT, dbfTikL, dbfDiv, nil, cDivEmp(), .f. )

            end if

         end if

         ( dbfTikT )->( dbSkip() )

         SysRefresh()

      end while

   end if

   SetStatus( dbfTikT, aSta )

return nCon

//----------------------------------------------------------------------------//

function nPdtTik( cCodCli, dDesde, dHasta, dbfTikT, dbfTikL, dbfTikP, dbfIva, dbfDiv )

   local nCon     := 0
   local aSta     := aGetStatus( dbfTikT )

   /*
   Facturas a Clientes -------------------------------------------------------
   */

   if ( dbfTikT )->( dbSeek( cCodCli ) )

      while ( dbfTikT )->cCliTik = cCodCli .and. !( dbfTikT )->( Eof() )

         if !( dbfTikT )->lLiqTik                                 .and.;
            ( dDesde == nil .or. ( dbfTikT )->dFecTik >= dDesde ) .and.;
            ( dHasta == nil .or. ( dbfTikT )->dFecTik <= dHasta )

            if ( dbfTikT )->cTipTik == SAVTIK

               nCon  += nTotTik( ( dbfTikT )->cSerTik + ( dbfTikT )->cNumTik + ( dbfTikT )->cSufTik, dbfTikT, dbfTikL, dbfDiv, nil, cDivEmp(), .f. )
               nCon  -= nTotCobTik( ( dbfTikT )->cSerTik + ( dbfTikT )->cNumTik + ( dbfTikT )->cSufTik, dbfTikP, dbfDiv, cDivEmp() )

            elseif ( dbfTikT )->cTipTik == SAVDEV

               nCon  -= nTotTik( ( dbfTikT )->cSerTik + ( dbfTikT )->cNumTik + ( dbfTikT )->cSufTik, dbfTikT, dbfTikL, dbfDiv, nil, cDivEmp(), .f. )
               nCon  += nTotCobTik( ( dbfTikT )->cSerTik + ( dbfTikT )->cNumTik + ( dbfTikT )->cSufTik, dbfTikP, dbfDiv, cDivEmp() )

            end if

         end if

         ( dbfTikT )->( dbSkip() )

         SysRefresh()

      end while

   end if

   SetStatus( dbfTikT, aSta )

return nCon

//----------------------------------------------------------------------------//
//
// Devuelve el total de cobros en tickets de un clientes determinado
//

function nCobTik( cCodCli, dDesde, dHasta, dbfTikT, dbfTikP, dbfIva, dbfDiv, nYear )

   local nCon     := 0
   local aSta     := aGetStatus( dbfTikT )

   ( dbfTikT )->( OrdSetFocus( "CCLITIK" ) )

   /*
   Facturas a Clientes -------------------------------------------------------
   */

   if ( dbfTikT )->( dbSeek( cCodCli ) )

      while ( dbfTikT )->cCliTik = cCodCli .and. !( dbfTikT )->( Eof() )

         if ( dDesde == nil .or. ( dbfTikT )->dFecTik >= dDesde ) .and.;
            ( dHasta == nil .or. ( dbfTikT )->dFecTik <= dHasta ) .and.;
            ( nYear == nil .or. Year( ( dbfTikT )->dFecTik ) == nYear )

            if ( dbfTikT )->cTipTik == SAVTIK

               nCon  += nTotCobTik( ( dbfTikT )->cSerTik + (dbfTikT)->cNumTik + (dbfTikT)->cSufTik, dbfTikP, dbfDiv, cDivEmp() )

            elseif ( dbfTikT )->cTipTik == SAVDEV

               nCon  -= nTotCobTik( ( dbfTikT )->cSerTik + (dbfTikT)->cNumTik + (dbfTikT)->cSufTik, dbfTikP, dbfDiv, cDivEmp() )

            end if

         end if

         ( dbfTikT )->( dbSkip() )

         SysRefresh()

      end while

   end if

   SetStatus( dbfTikT, aSta )

return nCon

//----------------------------------------------------------------------------//

FUNCTION TactilTpv( oMenuItem, oWnd, lTactil )

   local nLevel
   local oBtnEur
   local cTitle
   local lEur           := .f.

   DEFAULT  oMenuItem   := "01041"
   DEFAULT  oWnd        := oWnd()
   DEFAULT  lTactil     := .f.

   if oWndBig == nil

      nLevel            := nLevelUsr( oMenuItem )
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

      if !OpenFiles( , , .t. )
         return nil
      end if

      /*
      Anotamos el movimiento para el navegador
      */

      AddMnuNext( "T.P.V. Táctil", ProcName() )

      cTitle            := "T.P.V. Táctil - Sesión : " + Trans( cCurSesion(), "######" ) + " - " + dtoc( date() )

      DEFINE SHELL oWndBig FROM 0, 0 TO 22, 80 ;
         XBROWSE ;
         TITLE    cTitle ;
         PROMPTS  "Número",;
                  "Fecha",;
                  "Cajero/a",;
                  "Cliente",;
                  "Matrícula",;
                  "Sesión" ;
         ALIAS    ( dbfTikT );
         APPEND   ( TpvAppRec( oWndBig:oBrw, bEditB, dbfTikT, oWnd ) );
         DELETE   ( DelTpv( oWndBig:oBrw, dbfTikT ) ); //TpvDelRec( oWndBig:oBrw ) ) ;
         EDIT     ( TpvEdtRec( oWndBig:oBrw, bEditB, dbfTikT, oWnd ) );
         LEVEL    nLevel ;
         BIGSTYLE ;
         OF       oWnd

      oWndBig:lAutoSeek    := .f.

      with object ( oWndBig:AddXCol() )
         :cHeader          := "Cr. Cerrado"
         :bStrData         := {|| "" }
         :bEditValue       := {|| ( dbfTikT )->lCloTik }
         :nWidth           := 24
         :SetCheck( { "Cnt16", "Nil16" } )
      end with

      with object ( oWndBig:AddXCol() )
         :cHeader          := "Es. Estado"
         :bStrData         := {|| "" }
         :bBmpData         := {|| if( ( dbfTikT )->lAbierto, 1, if( !( dbfTikT )->lPgdTik, 2, 3 ) ) }
         :nWidth           := 24
         :AddResource( "Bullet_Square_Red_16" )
         :AddResource( "Bullet_Square_Yellow_16" )
         :AddResource( "Bullet_Square_Green_16" )
      end with

      with object ( oWndBig:AddXCol() )
         :cHeader          := "Número"
         :bEditValue       := {|| ( dbfTikT )->cSerTik + "/" + ltrim( ( dbfTikT )->cNumTik ) + "/" + ( dbfTikT )->cSufTik }
         :nWidth           := 80
      end with

      with object ( oWndBig:AddXCol() )
         :cHeader          := "Fecha"
         :bEditValue       := {|| dtoc( ( dbfTikT )->dFecTik ) }
         :nWidth           := 80
      end with

      with object ( oWndBig:AddXCol() )
         :cHeader          := "Sesión"
         :bEditValue       := {|| Trans( ( dbfTikT )->cTurTik, "######" ) }
         :nWidth           := 40
         :lHide            := .t.
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      with object ( oWndBig:AddXCol() )
         :cHeader          := "Hora"
         :bEditValue       := {|| ( dbfTikT )->cHorTik }
         :nWidth           := 40
      end with

      with object ( oWndBig:AddXCol() )
         :cHeader          := "Caja"
         :bEditValue       := {|| ( dbfTikT )->cNcjTik }
         :nWidth           := 40
      end with

      with object ( oWndBig:AddXCol() )
         :cHeader          := "Cajero"
         :bEditValue       := {|| ( dbfTikT )->cCcjTik }
         :nWidth           := 50
      end with

      with object ( oWndBig:AddXCol() )
         :cHeader          := "Sala"
         :bEditValue       := {|| ( dbfTikT )->cCodSala }
         :nWidth           := 40
      end with

      with object ( oWndBig:AddXCol() )
         :cHeader          := "Punto de venta"
         :bEditValue       := {|| ( dbfTikT )->cPntVenta }
         :nWidth           := 80
      end with

      with object ( oWndBig:AddXCol() )
         :cHeader          := "Cliente"
         :bEditValue       := {|| Rtrim( ( dbfTikT )->cCliTik ) + Space( 1 ) + ( dbfTikT )->cNomTik }
         :nWidth           := 160
      end with

      with object ( oWndBig:AddXCol() )
         :cHeader          := "Alias"
         :bEditValue       := {|| ( dbfTikT )->cAliasTik }
         :nWidth           := 80
      end with

      with object ( oWndBig:AddXCol() )
         :cHeader          := "Total"
         :bEditValue       := {|| nTotalizer( ( dbfTikT )->cSerTik + ( dbfTikT )->cNumTik + ( dbfTikT )->cSufTik, dbfTikT, dbfTikL, dbfTikP, dbfAlbCliT, dbfAlbCliL, dbfFacCliT, dbfFacCliL, dbfFacCliP, dbfIva, dbfDiv, if( lEur, cDivChg(), cDivEmp() ), .t. ) }
         :nWidth           := 80
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      with object ( oWndBig:AddXCol() )
         :cHeader          := "Div."
         :bEditValue       := {|| cSimDiv( ( dbfTikT )->cDivTik, dbfDiv ) }
         :nWidth           := 30
      end with

      with object ( oWndBig:AddXCol() )
         :cHeader          := "Cobrado"
         :bEditValue       := {|| nTotCobTik( ( dbfTikT )->cSerTik + ( dbfTikT )->cNumTik + ( dbfTikT )->cSufTik, dbfTikP, dbfDiv, if( lEur, cDivChg(), cDivEmp() ), .t. ) }
         :nWidth           := 80
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      with object ( oWndBig:AddXCol() )
         :cHeader          := "Vale"
         :bEditValue       := {|| nTotValTik( ( dbfTikT )->cSerTik + ( dbfTikT )->cNumTik + ( dbfTikT )->cSufTik, dbfTikT, dbfTikL, dbfDiv, if( lEur, cDivChg(), cDivEmp() ), .t. ) }
         :nWidth           := 80
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      oWndBig:cHtmlHelp    := "Tickets táctil"

      oWndBig:CreateXFromCode()

      if !lTactil
         oWndBig:AddSeaBar()
      end if

      DEFINE BTNSHELL RESOURCE "NEW" OF oWndBig ;
			NOBORDER ;
         ACTION   ( oWndBig:RecAdd(), oWndBig:oBrw:Refresh() );
			TOOLTIP 	"(A)ñadir";
         HOTKEY   "A";
         LEVEL    ACC_APPD

      DEFINE BTNSHELL RESOURCE "EDIT" OF oWndBig ;
			NOBORDER ;
         ACTION   ( oWndBig:RecEdit(), oWndBig:oBrw:Refresh() );
			TOOLTIP 	"(M)odificar";
         HOTKEY   "M";
         LEVEL    ACC_EDIT

      DEFINE BTNSHELL RESOURCE "ZOOM" OF oWndBig ;
			NOBORDER ;
         ACTION   ( WinZooRec( oWndBig:oBrw, bEditB, dbfTikT ) );
			TOOLTIP 	"(Z)oom";
         HOTKEY   "Z";
         LEVEL    ACC_ZOOM

      DEFINE BTNSHELL RESOURCE "DEL" OF oWndBig ;
			NOBORDER ;
         ACTION   ( oWndBig:RecDel(), oWndBig:oBrw:Refresh() );
			TOOLTIP 	"(E)liminar";
         HOTKEY   "E";
         LEVEL    ACC_DELE

      DEFINE BTNSHELL oBtnEur RESOURCE "BAL_EURO" OF oWndBig ;
			NOBORDER ;
         ACTION   ( lEur := !lEur, SetHeadEuro( lEur, oWndBig ), SetHeadEuro( lEur, oWndBig, "Cobrado" ) ) ;
         TOOLTIP  "M(o)neda";
         HOTKEY   "O";
         LEVEL    ACC_ZOOM

      DEFINE BTNSHELL RESOURCE "IMP" GROUP OF oWndBig ;
			NOBORDER ;
         ACTION   ( ImpTiket( .f. ) );
         TOOLTIP  "(I)mprimir" ;
         HOTKEY   "I";
         LEVEL    ACC_IMPR

      DEFINE BTNSHELL RESOURCE "Money2_" OF oWndBig ;
         NOBORDER ;
         ACTION   ( EdtCobTik( oWndBig, .t. ) );
         TOOLTIP  "(C)obros";
         HOTKEY   "C";
         LEVEL    ACC_APPD

if !lTactilMode()

      DEFINE BTNSHELL RESOURCE "User1_" OF oWndBig ;
         NOBORDER ;
         ACTION   ( CuentasClientes( oWndBig:oBrw ) );
         TOOLTIP  "C(t)a. cliente";
         HOTKEY   "T";
         LEVEL    ACC_APPD

endif

      DEFINE BTNSHELL RESOURCE "UP" GROUP OF oWndBig ;
			NOBORDER ;
         ACTION   ( oWndBig:oBrw:GoUp() ) ;
         TOOLTIP  "S(u)bir" ;
         HOTKEY   "U"

      DEFINE BTNSHELL RESOURCE "DOWN" GROUP OF oWndBig ;
			NOBORDER ;
         ACTION   ( oWndBig:oBrw:GoDown() ) ;
         TOOLTIP  "(B)ajar" ;
         HOTKEY   "B"

if !lTactilMode()

      DEFINE BTNSHELL RESOURCE "END" GROUP OF oWndBig ;
			NOBORDER ;
         ACTION   ( oWndBig:end() ) ;
			TOOLTIP 	"(S)alir";
			HOTKEY   "S"
end if

      ACTIVATE SHELL oWndBig VALID ( CloseFiles() )

   else

      oWndBig:setFocus()

   end if

   if lEntCon()
      oWndBig:RecAdd()
   end if

Return Nil

//----------------------------------------------------------------------------//

Function oWndTactil()

Return oWndBrw

//----------------------------------------------------------------------------//

Static Function EdtBig( aTmp, aGet, dbfTikT, oBrw, cTot, nTot, nMode, oWnd )

   local n
   local cOrdFam
   local cTipTik
   local nOrdArt
   local cSayCcj
   local oBtnAcc
   local aGetArt
   local aTmpArt

   nScreenHorzRes       := ScreenHorzRes()

   if !( nScreenHorzRes >= 1024 )
      MsgStop( __GSTROTOR__ + Space( 1 ) + __GSTVERSION__ + "táctil solo permite resoluciones de 1024 o superiores" )
      Return .f.
   end if

   if !lCajaOpen( oUser():cCaja() ) .and. !oUser():lAdministrador()
      msgStop( "Esta caja " + oUser():cCaja() + " esta cerrada." )
      Return .f.
   end if

   if !lFamInTpv( dbfFamilia )
      MsgStop( "No hay familias de artículos seleccionadas para trabajar con el TPV táctil" )
      return .f.
   end if

   if nMode == APPD_MODE .and. !lCurSesion()
      MsgStop( "No hay sesiones activas, imposible añadir documentos" )
      return .f.
   end if

   oBtnAcc              := Array( 9 )
   aGetArt              := Array( ( dbfTikL )->( fCount() ) )
   aTmpArt              := dbBlankRec( dbfTikL )
   aTmpArt[ _NUNTTIL ]  := ""

   /*
   Número de botones-----------------------------------------------------------
   */

   nNumBtnFam        :=  7
   nNumBtnArt        := 19

   /*
   Inicialización--------------------------------------------------------------
   */

   oBtnFam              := Array( nNumBtnFam )
   oSayFam              := Array( nNumBtnFam )
   oBtnArt              := Array( nNumBtnArt )
   oSayArt              := Array( nNumBtnArt )
   oBtnNum              := Array( 16 )

   /*
   Modo especial para las tarifas----------------------------------------------
   */

   nSaveMode            := nMode

   /*
   Comineza la transaccion-----------------------------------------------------
   */

   if BeginTrans( aTmp, aGet, nMode, .t. )
      Return .f.
   end if

   cSayCcj              := Capitalize( RetFld( aTmp[ _CCCJTIK ], dbfUsr ) )

   /*
   Tikect ya utilizado---------------------------------------------------------
   */

   if aTmp[ _LCLOTIK ] .and. nMode == EDIT_MODE
      msgStop( "No se pueden modificar tickets cerrados." )
      Return .f.
   end if

   /*
   Posicionamos en el tag de las familias--------------------------------------
   */

   cOrdFam              := ( dbfFamilia  )->( OrdSetFocus( "nPosTpv" ) )
   nOrdArt              := ( dbfArticulo )->( OrdSetFocus( "nPosTpv" ) )

   oFntBrw              := TFont():New( FONT_NAME, 0, 14, .f., .f. )
   oFntTot              := TFont():New( FONT_NAME, 0, 12, .f., .f. )
   oFntEur              := TFont():New( FONT_NAME, 0, 34, .f., .t. )
   oFntNum              := TFont():New( FONT_NAME, 0, 46, .f., .t. )

   cTipTik              := aTipDoc[ Max( Val( aTmp[ _CTIPTIK ] ), 1 ) ]     // Tipo de tickets

   /*
   Caja de dialogo-------------------------------------------------------------
   */

   if oUser():lUsrZur()
         DEFINE DIALOG  oDlgTpv ;
            RESOURCE    "Big_Tpv_One_Left_1024" ;
            STYLE       nOR( DS_MODALFRAME, WS_POPUP, WS_CAPTION, WS_CLIPCHILDREN )
   else
         DEFINE DIALOG  oDlgTpv ;
            RESOURCE    "Big_Tpv_One_Right_1024" ;
            STYLE       nOR( DS_MODALFRAME, WS_POPUP, WS_CAPTION, WS_CLIPCHILDREN )
   end if

      /*
      Botones de las unidades_________________________________________________
      */

      REDEFINE BUTTON oBtnNum[ 1 ] ;
         ID       101 ;
         OF       oDlgTpv ;
         ACTION   ( KeyChar( "1", aTmpArt, aGetArt ) ) ;
         PROMPT   "1" ;

      oBtnNum[ 1 ]:oFont   := oFntNum

      REDEFINE BUTTON oBtnNum[ 2 ] ;
         ID       102 ;
         OF       oDlgTpv;
         ACTION   ( KeyChar( "2", aTmpArt, aGetArt ) );
         PROMPT   "2" ;

      oBtnNum[ 2 ]:oFont   := oFntNum

      REDEFINE BUTTON oBtnNum[ 3 ] ;
         ID       103 ;
         OF       oDlgTpv;
         ACTION   ( KeyChar( "3", aTmpArt, aGetArt ) );
         PROMPT   "3" ;

      oBtnNum[ 3 ]:oFont   := oFntNum

      REDEFINE BUTTON oBtnNum[ 4 ] ;
         ID       104 ;
         OF       oDlgTpv;
         ACTION   ( KeyChar( "4", aTmpArt, aGetArt ) );
         PROMPT   "4" ;

      oBtnNum[ 4 ]:oFont   := oFntNum

      REDEFINE BUTTON oBtnNum[ 5 ] ;
         ID       105 ;
         OF       oDlgTpv;
         ACTION   ( KeyChar( "5", aTmpArt, aGetArt ) );
         PROMPT   "5" ;

      oBtnNum[ 5 ]:oFont   := oFntNum

      REDEFINE BUTTON oBtnNum[ 6 ] ;
         ID       106 ;
         OF       oDlgTpv;
         ACTION   ( KeyChar( "6", aTmpArt, aGetArt ) );
         PROMPT   "6" ;

      oBtnNum[ 6 ]:oFont   := oFntNum

      REDEFINE BUTTON oBtnNum[ 7 ] ;
         ID       107 ;
         OF       oDlgTpv;
         ACTION   ( KeyChar( "7", aTmpArt, aGetArt ) );
         PROMPT   "7" ;

      oBtnNum[ 7 ]:oFont   := oFntNum

      REDEFINE BUTTON oBtnNum[ 8 ] ;
         ID       108 ;
         OF       oDlgTpv;
         ACTION   ( KeyChar( "8", aTmpArt, aGetArt ) );
         PROMPT   "8" ;

      oBtnNum[ 8 ]:oFont   := oFntNum

      REDEFINE BUTTON oBtnNum[ 9 ] ;
         ID       109 ;
         OF       oDlgTpv;
         ACTION   ( KeyChar( "9", aTmpArt, aGetArt ) );
         PROMPT   "9" ;

      oBtnNum[ 9 ]:oFont   := oFntNum

      REDEFINE BUTTON oBtnNum[ 10 ] ;
         ID       110 ;
         OF       oDlgTpv;
         ACTION   ( KeyChar( "0", aTmpArt, aGetArt ) );
         PROMPT   "0" ;

      oBtnNum[ 10 ]:oFont  := oFntNum

      /*
      Boton de puesta a cero___________________________________________________
      */

      REDEFINE BUTTON oBtnNum[ 11 ] ;
         ID       111 ;
         OF       oDlgTpv;
         ACTION   ( KeyChar( "C", aTmpArt, aGetArt ) );
         PROMPT   "C" ;

      oBtnNum[ 11 ]:oFont  := oFntNum

      /*
      Boton de punto decimal___________________________________________________
      */

      REDEFINE BUTTON oBtnNum[ 12 ] ;
         ID       112 ;
         OF       oDlgTpv;
         ACTION   ( KeyChar( ".", aTmpArt, aGetArt ) );
         PROMPT   "," ;

      oBtnNum[ 12 ]:oFont  := oFntNum

      /*
      Boton de +_______________________________________________________________
      */

      REDEFINE BUTTON oBtnNum[ 13 ] ;
         ID       113 ;
         OF       oDlgTpv;
         ACTION   ( KeyChar( "=", aTmpArt, aGetArt ), oBrwDet:Refresh(), lRecTotal( aTmp ) );
         PROMPT   "=" ;

      oBtnNum[ 13 ]:oFont  := oFntNum

      /*
      Boton de -_______________________________________________________________
      */

      REDEFINE BUTTON oBtnNum[ 14 ] ;
         ID       114 ;
         OF       oDlgTpv;
         ACTION   ( KeyChar( "-", aTmpArt, aGetArt ) );
         PROMPT   "-" ;

      oBtnNum[ 14 ]:oFont  := oFntNum

      /*
      Boton de *_______________________________________________________________
      */

      REDEFINE BUTTON oBtnNum[ 15 ] ;
         ID       115 ;
         OF       oDlgTpv;
         ACTION   ( KeyChar( "*", aTmpArt, aGetArt ), oBrwDet:Refresh(), lRecTotal( aTmp ) );
         PROMPT   "x" ;

      oBtnNum[ 15 ]:oFont  := oFntNum

      /*
      Boton de Con_______________________________________________________________
      */

      REDEFINE BUTTON oBtnNum[ 16 ] ;
         ID       116 ;
         OF       oDlgTpv;
         ACTION   ( lCombinado( ( dbfArticulo )->Codigo, aGetArt, aTmpArt, aTmp ) );
         PROMPT   "Cn" ;

      oBtnNum[ 16 ]:oFont  := oFntNum

      /*
      Familias de botones______________________________________________________
      */

      REDEFINE BUTTONBMP oBtnIni ;
         ID       501 ;
         OF       oDlgTpv;
         WHEN     ( nMode != ZOOM_MODE ) ;
         BITMAP   "Star_Yellow_64" ;
         ACTION   loaIni( .f., .t., aGetArt, aTmpArt, aTmp ) ;

      for n := 1 to nNumBtnFam

      REDEFINE BUTTONBMP oBtnFam[ n ] ;
         ID       ( 201 + n ) ;
         OF       oDlgTpv;
         WHEN     ( nMode != ZOOM_MODE ) ;

      oBtnFam[ n ]:lTransparent  := .f.

      REDEFINE SAY oSayFam[ n ] ;
         PROMPT   "";
         ID       ( 251 + n );
         OF       oDlgTpv

      next

      /*
      Boton de descipcion libre------------------------------------------------
      */

      REDEFINE BUTTONBMP oBtnFree ;
         ID       ( 301 ) ;
         OF       oDlgTpv ;
         BITMAP   "FREE_BULLET_86" ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( addFreeProduct(), lRecTotal( aTmp ) );

      REDEFINE SAY oSayFree ;
         PROMPT   "Libre";
         ID       ( 801 );
         OF       oDlgTpv

      /*
      Articulos de botones______________________________________________________
      */

      for n := 1 to len( oBtnArt )

      REDEFINE BUTTONBMP oBtnArt[ n ] ;
         ID       ( 301 + n ) ;
         OF       oDlgTpv;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   Msginfo( "" ) ;

      oBtnArt[ n ]:lTransparent  := .f.

      REDEFINE SAY oSayArt[ n ] ;
         PROMPT   "";
         ID       ( 801 + n );
         OF       oDlgTpv

      next

		/*
		Detalle de Articulos____________________________________________________
		*/

      oBrwDet                    := IXBrowse():New( oDlgTpv )

      oBrwDet:bClrSel            := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwDet:bClrSelFocus       := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrwDet:cAlias             := dbfTmpL

      oBrwDet:nMarqueeStyle      := 5

      with object ( oBrwDet:AddCol() )
         :cHeader                := "Inv."
         :bStrData               := {|| "" }
         :bEditValue             := {|| !Empty( ( dbfTmpL )->cCodInv ) }
         :nWidth                 := 16
         :SetCheck( { "Sel16", "Nil16" } )
      end with

      with object ( oBrwDet:AddCol() )
         :cHeader                := "Und."
         :bEditValue             := {|| AllTrim( Trans( ( dbfTmpL )->nUntTil, cPicUnd ) ) }
         :nWidth                 := 30
         :nDataStrAlign          := AL_RIGHT
         :nHeadStrAlign          := AL_RIGHT
      end with

      with object ( oBrwDet:AddCol() )
         :cHeader                := "Detalle"
         :bEditValue             := {|| Rtrim( ( dbfTmpL )->cNomTil ) + if( !Empty( ( dbfTmpL )->cNcmTil ), " con " + ( dbfTmpL )->cNcmTil, "" ) }
         :nWidth                 := 150
      end with

      with object ( oBrwDet:AddCol() )
         :cHeader                := "%Dto"
         :bEditValue             := {|| Trans( ( dbfTmpL )->nDtoLin, "@EZ 999.99" ) }
         :nWidth                 := 35
      end with

      with object ( oBrwDet:AddCol() )
         :cHeader                := "Total"
         :bEditValue             := {|| AllTrim( Trans( nTotLTpv( dbfTmpL, nDouDiv, nDorDiv ), cPorDiv ) ) }
         :nWidth                 := 60
         :nDataStrAlign          := AL_RIGHT
         :nHeadStrAlign          := AL_RIGHT
      end with

      oBrwDet:CreateFromResource( 400 )

      oBrwDet:lHScroll           := .f.
      oBrwDet:lVScroll           := .f.
      oBrwDet:lRecordSelector    := .f.

   /*
   Botones para las lineas-----------------------------------------------------
   */

   REDEFINE BUTTONBMP ;
      ID       700;
      OF       oDlgTpv ;
      BITMAP   "Up32" ;
      ACTION   ( oBrwDet:GoUp() ) ;

   REDEFINE BUTTONBMP ;
      ID       710;
      OF       oDlgTpv ;
      BITMAP   "Down32" ;
      ACTION   ( oBrwDet:GoDown() ) ;

   REDEFINE BUTTONBMP ;
      ID       720 ;
      OF       oDlgTpv ;
      WHEN     ( nMode != ZOOM_MODE ) ;
      ACTION   ( DelRecno( dbfTmpL, oBrwDet ), lRecTotal( aTmp ) );
      BITMAP   "Garbage_Empty_32" ;

   REDEFINE BUTTONBMP ;
      ID       730 ;
      OF       oDlgTpv ;
      WHEN     ( nMode != ZOOM_MODE ) ;
      ACTION   ( CrearDescuento( dbfTmpL, oBrwDet ), lRecTotal( aTmp ) );
      BITMAP   "Percent_32" ;

   REDEFINE BUTTONBMP ;
      ID       740 ;
      OF       oDlgTpv ;
      WHEN     ( nMode != ZOOM_MODE ) ;
      ACTION   ( CrearInvitacion( dbfTmpL, oBrwDet ), lRecTotal( aTmp ) );
      BITMAP   "Masks_32" ;

   REDEFINE BUTTONBMP ;
      ID       750 ;
      OF       oDlgTpv ;
      WHEN     ( nMode != ZOOM_MODE ) ;
      ACTION   ( if( oCajon != nil, oCajon:Open(), ) );
      BITMAP   "Diskdrive_32" ;

   /*
   Totales---------------------------------------------------------------------
   */

      oTxtTot     := TSay():ReDefine( 630, {|| "Total" }, oDlgTpv, , "G+/N", , .f., oFntEur )
      oNumTot     := TSay():ReDefine( 620, {|| Trans( nTotTik, cPorDiv ) }, oDlgTpv, , "G+/N", , .f., oFntEur )
      oTxtCom     := TSay():ReDefine( 640, {|| "Comensales: " + AllTrim( Str( aTmp[ _NNUMCOM ] ) ) }, oDlgTpv, , "G+/N", , .f., oFntTot )
      oTotCom     := TSay():ReDefine( 650, {|| AllTrim( Trans( nTotPax, cPorDiv ) ) + " pax." }, oDlgTpv, , "G+/N", , .f., oFntTot )

   /*
   Unidades--------------------------------------------------------------------
   */

      REDEFINE GET aGetArt[ _NUNTTIL ] VAR aTmpArt[ _NUNTTIL ];
         ID       600 ;
         FONT     oFntEur ;
         WHEN     ( nMode != ZOOM_MODE );
         OF       oDlgTpv

   /*
   Barra de porcentaje______________________________________________________
   */

      oMetMsg     := TApoloMeter():ReDefine( 460, { | u | If( pCount() == 0, nMetMsg, nMetMsg := u ) },, oDlgTpv, .f.,,, .t., rgb( 255,255,255 ), , rgb( 128,255,0 ) )

   /*
   Apertura de la caja de dialogo----------------------------------------------
   */

   oDlgTpv:bStart    := {|| StartEdtBig( aTmp, aGet, oDlgTpv, oBrwDet ), cTextoOfficeBar( aTmp ) }

   oDlgTpv:AddFastKey( VK_F12, {|| if( oCajon != nil, oCajon:Open(), ) } )
   oDlgTpv:AddFastKey( 65,     {|| if( GetKeyState( VK_CONTROL ), CreateInfoArticulo(), ) } )

   ACTIVATE DIALOG oDlgTpv ;
      ON INIT        ( LoaFam( .t., .t., aGetArt, aTmpArt, aTmp, nMode ) ) ;
      VALID          ( lValidDlgTpv( aTmp, aGet, nSaveMode ) ) ;
      CENTER

   oFntBrw:End()
   oFntTot:End()
   oFntEur:End()
   oFntNum:End()

   ( dbfFamilia  )->( OrdSetFocus( cOrdFam ) )
   ( dbfArticulo )->( OrdSetFocus( nOrdArt ) )

   /*
   Paramos el timer de recepcion de pedidos------------------------------------
   */

   lStopAvisoPedidos()

   /*
   Destruimos los objetos------------------------------------------------------
   */

   oBtnIni        := nil
   oBtnFam        := nil
   oSayFam        := nil
   oBtnArt        := nil
   oSayArt        := nil
   oBtnNum        := nil

   aTmp           := nil

   oBtnPedidos    := nil

   /*
   Salida sin grabar-----------------------------------------------------------
   */

   KillTrans()

   /*
   Escribe los datos pendientes------------------------------------------------
   */

   dbCommitAll()

Return ( oDlgTpv:nResult == IDOK )

//---------------------------------------------------------------------------//

Static Function lValidDlgTpv( aTmp, aGet, nSaveMode )

   local lValid      := .t.

   if ( dbfTmpL )->( LastRec() ) == 0  .or.;
      ApoloMsgNoYes( "¿Desea guardar el ticket antes de salir?", "Selecciona una opción" )

      lValid         :=  TmpTiket( aTmp, aGet, nSaveMode, .f. )

   end if

Return lValid

//---------------------------------------------------------------------------//

Static Function StartEdtBig( aTmp, aGet, oDlgTpv, oBrwDet )

   local oBoton
   local oGrupo
   local oCarpeta

   oOfficeBar           := TDotNetBar():New( 0, 0, 1020, 100, oDlgTpv, 1 )
   oOfficeBar:nHTabs    := 4

   oDlgTpv:oTop         := oOfficeBar

   oCarpeta             := TCarpeta():New( oOfficeBar, "" )

   oGrupo               := TDotNetGroup():New( oCarpeta, 66, "Salones", .f. )
      oBtnTarifa        := TDotNetButton():New( 60, oGrupo, "Cup_32",                   "General",          1, {|| GetSalaVenta( aTmp, aGet ) }, , , .f., .f., .f. )

   oGrupo               := TDotNetGroup():New( oCarpeta, 306, "Acciones", .f. )
      oBtnRenombrar     := TDotNetButton():New( 60, oGrupo, "Note_Edit_32",             "Alias",            1, {|| RenombrarUbicacion( aTmp, aGet ) }, , {|| ( dbfTmpL )->( LastRec() ) > 0 }, .f., .f., .f. )
      oBoton            := TDotNetButton():New( 60, oGrupo, "Note_Add_32",              "Nuevo ticket",     2, {|| GetNuevaVenta( aTmp, aGet ) }, , , .f., .f., .f. )
      oBoton            := TDotNetButton():New( 60, oGrupo, "Note_Delete_32",           "Pendiente cobro",  3, {|| GetSalaVenta( aTmp, aGet, .t. ) }, , , .f., .f., .f. )
      oBtnEntregar      := TDotNetButton():New( 60, oGrupo, "Printer_32",               "Entregar nota",    4, {|| ClickEntrega( aTmp, aGet, oDlgTpv ) }, , , .f., .f., .f. )
      oBoton            := TDotNetButton():New( 60, oGrupo, "Money2_32",                "Cobrar",           5, {|| NewTiket( aGet, aTmp, nSaveMode, SAVTIK, .t. ) }, , , .f., .f., .f. )

   oGrupo               := TDotNetGroup():New( oCarpeta, 126, "Otros", .f. )
      oBoton            := TDotNetButton():New( 60, oGrupo, "Users1_32",                "Comensales",       1, {|| lNumeroComensales( aTmp ) }, , , .f., .f., .f. )
      oBtnUsuario       := TDotNetButton():New( 60, oGrupo, "Security_Agent_32",        "Cambiar usuario",  2, {|| SelBigUser( aTmp, aGet, dbfUsr ) }, , , .f., .f., .f. )

   oGrupo               := TDotNetGroup():New( oCarpeta, 306, "Pedidos y clientes", .f., , "" )
      oBoton            := TDotNetButton():New( 60, oGrupo, "SndInt32",                 "Pedidos",          1, {|| ProcesaPedidosWeb( aTmp ) }, , , .f., .f., .f. )
      oBtnCliente       := TDotNetButton():New( 240, oGrupo, "User1_16",                "...",              2, {|| lSeleccionaCliente( aTmp ) }, , , .f., .f., .f. )
      oBtnDireccion     := TDotNetButton():New( 240, oGrupo, "Home_16",                 "...",              2, {|| lSeleccionaCliente( aTmp ) }, , , .f., .f., .f. )
      oBtnTelefono      := TDotNetButton():New( 240, oGrupo, "Mobilephone3_16",         "...",              2, {|| lSeleccionaCliente( aTmp ) }, , , .f., .f., .f. )

   oGrupo               := TDotNetGroup():New( oCarpeta, 126, "Tickets", .f. )
      oBtnUp            := TDotNetButton():New( 60, oGrupo, "Arrow_Up_Blue_Save_32",    "Subir",            1, {|| lCambiaTicket( .t., aTmp, aGet ) }, , , .f., .f., .f. )
      oBtnDown          := TDotNetButton():New( 60, oGrupo, "Arrow_Down_Blue_Save_32",  "Bajar",            2, {|| lCambiaTicket( .f., aTmp, aGet ) }, , , .f., .f., .f. )

   oGrupo               := TDotNetGroup():New( oCarpeta, 66, "Salida", .f. )
      oBoton            := TDotNetButton():New( 60, oGrupo, "End32",                    "Salida",           1, {|| oDlgTpv:End() }, , , .f., .f., .f. )

   /*
   Comprobamos desabilitar los botones de up and down
   */

   if nSaveMode == APPD_MODE
      oBtnUp:lEnabled   := .f.
      oBtnDown:lEnabled := .f.
   else
      oBtnUp:lEnabled   := .t.
      oBtnDown:lEnabled := .t.
   end if

   /*
   Llamamos al cargo-----------------------------------------------------------
   */

   CargoEdtBig( aTmp, aGet, oDlgTpv )

   /*
   Ventana maximizada----------------------------------------------------------
   */

   //oDlgTpv:Maximize()

Return ( nil )

//---------------------------------------------------------------------------//

Static Function CargoEdtBig( aTmp, aGet, oDlgTpv )

   /*
   Otras acciones--------------------------------------------------------------
   */

   if nSaveMode == APPD_MODE

      if lRecogerUsuario()
         if !SelBigUser( aTmp, aGet, dbfUsr )
            oDlgTpv:end()
            Return nil
         end if
      else
         SetBigUser( aTmp, aGet )
      end if

      if IsTrue( oSalaVentas:lPuntosVenta )

         SysRefresh()

         if uFieldEmpresa( "lShowSala" )
            GetSalaVenta( aTmp, aGet )
         else
            SetSalaVenta( aTmp, aGet )
         end if

      end if

   else

      SetBigUser( aTmp, aGet )

   end if

   /*
   Boton-----------------------------------------------------------------------
   */

   oSalaVentas:ConfigButton( oBtnTarifa, oBtnRenombrar )

   /*
   Titulo de la ventana--------------------------------------------------------
   */

   cTitleDialog( aTmp )

   /*
   Recalculo-------------------------------------------------------------------
   */

   lRecTotal( aTmp )

Return ( nil )

//---------------------------------------------------------------------------//

Static Function GetSalaVenta( aTmp, aGet, lPuntosLibres )

   local oError
   local oBlock

   DEFAULT lPuntosLibres   := .f.

   oBlock                  := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   /*
   Guarda la venta actual---------------------------------------------------
   */

   if GuardaVenta( aTmp, aGet )

      /*
      Muestra el boton---------------------------------------------------------
      */

      if oSalaVentas:Sala( oBtnTarifa, lPuntosLibres, dbfTikT )

         do case
            case IsFalse( oSalaVentas:lPuntosVenta )

            /*
            Si el punto seleccionado no esta vacio y es distinto del actual y no existen ventas en ese punto
            */

            if !Empty( oSalaVentas:cSelectedSala ) .and. ( aTmp[ _CCODSALA ] != oSalaVentas:cSelectedSala )

               aTmp[ _CCODSALA   ]              := oSalaVentas:cSelectedSala
               aTmp[ _NTARIFA    ]              := oSalaVentas:nSelectedPrecio

               if ( dbfTmpL )->( LastRec() ) != 0

                  Recalcula( aTmp )

                  TmpTiket( aTmp, aGet, nSaveMode, .f. )

               end if

            end if

         case IsTrue( oSalaVentas:lPuntosVenta )

            /*
            Si el punto seleccionado no esta vacio y es distinto del actual y no existen ventas en ese punto
            */

            if !Empty( oSalaVentas:cSelected() )

               if ( aTmp[ _CSERTIK ] + aTmp[ _CNUMTIK ] + aTmp[ _CSUFTIK ] != oSalaVentas:cSelectedTicket() )

                  if !Empty( oSalaVentas:cSelectedTicket() ) .and. ( dbSeekInOrd( oSalaVentas:cSelectedTicket(), "cNumTik", dbfTikT ) )

                     aScatter( dbfTikT, aTmp )
                     if !BeginTrans( aTmp, aGet, EDIT_MODE, .t. )
                        nSaveMode               := EDIT_MODE
                     end if

                  else

                     aScatter( dbfTikT, aTmp )
                     if !BeginTrans( aTmp, aGet, APPD_MODE, .t. )
                        nSaveMode               := APPD_MODE
                     end if

                  end if

               end if

            else

               aScatter( dbfTikT, aTmp )

               if !BeginTrans( aTmp, aGet, APPD_MODE, .t. )
                  nSaveMode                     := APPD_MODE
               end if

            end if

            aTmp[ _CCODSALA   ]                 := oSalaVentas:cSelectedSala
            aTmp[ _CPNTVENTA  ]                 := oSalaVentas:cSelectedPunto
            aTmp[ _NTARIFA    ]                 := oSalaVentas:nSelectedPrecio

         end case

         /*
         Pintamos los botones--------------------------------------------------------
         */

         oSalaVentas:ConfigButton( oBtnTarifa, oBtnRenombrar )

         /*
         Titulo de la ventana--------------------------------------------------------
         */

         cTitleDialog( aTmp )

         /*
         Recalculamos el total-------------------------------------------------
         */

         lRecTotal( aTmp )

      end if

   end if

   RECOVER USING oError

      msgStop( "Error al montar la salas de venta" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( .t. )

//---------------------------------------------------------------------------//

Static Function SetSalaVenta( aTmp, aGet )

   local oError
   local oBlock

   oBlock                  := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   /*
   Guarda la venta actual---------------------------------------------------
   */

   if GuardaVenta( aTmp, aGet )

      /*
      Ponemos el boton generico------------------------------------------------
      */

      oSalaVentas:InitSala()

      /*
      Damos loa valores al tiket actual----------------------------------------
      */

      aTmp[ _CCODSALA   ]  := oSalaVentas:cSelectedSala
      aTmp[ _CPNTVENTA  ]  := oSalaVentas:cSelectedPunto
      aTmp[ _NTARIFA    ]  := oSalaVentas:nSelectedPrecio

      /*
      Pintamos los botones-----------------------------------------------------
      */

      oSalaVentas:ConfigButton( oBtnTarifa, oBtnRenombrar )

      /*
      Titulo de la ventana--------------------------------------------------------
      */

      cTitleDialog( aTmp )

   end if

   RECOVER USING oError

      msgStop( "Error al asignar la salas de venta" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( .t. )

//---------------------------------------------------------------------------//

Static Function GetNuevaVenta( aTmp, aGet )

   /*
   Guarda la venta actual------------------------------------------------------
   */

   if GuardaVenta( aTmp, aGet )

      /*
      Nuevo registro--------------------------------------------------------------
      */

      if !BeginTrans( aTmp, aGet, APPD_MODE, .t. )

         nSaveMode            := APPD_MODE

         /*
         Articulos de inicio------------------------------------------------------
         */

         if !Empty( oBtnIni )
            oBtnIni:Click()
         end if

         /*
         Ejecutamos del nuevo el bStart-------------------------------------------
         */

         if uFieldEmpresa( "lShowSala" )
            GetSalaVenta( aTmp, aGet )
         else
            SetSalaVenta( aTmp, aGet )
         end if

         lRecTotal( aTmp )

      end if

      /*
      Titulo de la ventana--------------------------------------------------------
      */

      cTitleDialog( aTmp )

   end if

Return ( nil )

//---------------------------------------------------------------------------//

Static Function GuardaVenta( aTmp, aGet )

   local lValid   := .t.

   /*
   Vamos a comprobar q hay algo q guardar--------------------------------------
   */

   if ( dbfTmpL )->( LastRec() ) != 0

      lValid      := TmpTiket( aTmp, aGet, nSaveMode, .f. )

      if lValid
         nSaveMode               := EDIT_MODE
      end if

   end if

Return ( lValid )

//---------------------------------------------------------------------------//

Static Function GetTiketPendiente( aTmp, aGet )

   /*
   Guarda la venta actual------------------------------------------------------
   */

   if GuardaVenta( aTmp, aGet )

      /*
      Muestra el botón------------------------------------------------------------
      */

      if oSalaVentas:Tikets( oBtnTarifa, oBtnRenombrar )

         if dbSeekInOrd( oSalaVentas:cSelectedTiket(), "cNumTik", dbfTikT )

            // aTmp                    := dbScatter( dbfTikT )

            aScatter( dbfTikT, aTmp )

            if BeginTrans( aTmp, aGet, EDIT_MODE, .t. )
               Return .f.
            end if

            nSaveMode               := EDIT_MODE

            lRecTotal( aTmp )

         end if

         /*
         Titulo de la ventana--------------------------------------------------------
         */

         cTitleDialog( aTmp )

      end if

   end if

Return ( nil )

//---------------------------------------------------------------------------//

Static Function cTitleDialog( aTmp )

   /*
   Titulo de la ventana--------------------------------------------------------
   */

   oDlgTpv:cTitle             := LblTitle( nSaveMode ) + "tickets a clientes "

   if !Empty( aTmp[ _CNUMTIK ] )
      oDlgTpv:cTitle          += Space( 1 )
      oDlgTpv:cTitle          += "[ Ticket : " + aTmp[ _CSERTIK ] + "/" + Alltrim( aTmp[ _CNUMTIK ] ) + "/" + Alltrim( aTmp[ _CSUFTIK ] ) + "]"
   end if

   if !Empty( oSalaVentas )

      oDlgTpv:cTitle          += Space( 1 )
      oDlgTpv:cTitle          += "[ Precio : " + oSalaVentas:cTextoPrecio() + "]"

      if !Empty( oSalaVentas:cSelectedPunto )


         if !Empty( oSalaVentas:cTextoSala() )
            oDlgTpv:cTitle    += Space( 1 )
            oDlgTpv:cTitle    += "[ Sala : " + oSalaVentas:cTextoSala() + "]"
         end if

         if !Empty( oSalaVentas:GetSelectedTexto() )
            oDlgTpv:cTitle    += Space( 1 )
            oDlgTpv:cTitle    += "[ Punto : " + Alltrim( oSalaVentas:GetSelectedTexto() ) + "]"
         end if

      end if

   end if

   if !Empty( aTmp[ _CALIASTIK ] )
      oDlgTpv:cTitle          += Space( 1 )
      oDlgTpv:cTitle          += "[ Alias : " + Rtrim( aTmp[ _CALIASTIK ] ) + "]"
   end if

   oDlgTpv:Refresh()

Return ( nil )

//---------------------------------------------------------------------------//

Static Function KeyChar( cKey, aTmpArt, aGetArt )

   do case
      case At( cKey, "0123456789" ) > 0
         aTmpArt[ _NUNTTIL ]     += cKey

      case cKey == "." .and. !( At( ".", aTmpArt[ _NUNTTIL ] ) > 0 )
         aTmpArt[ _NUNTTIL ]     += cKey

      case cKey == "-"
         if !( At( "-", aTmpArt[ _NUNTTIL ] ) > 0 )
            aTmpArt[ _NUNTTIL ]  := cKey + aTmpArt[ _NUNTTIL ]
         else
            aTmpArt[ _NUNTTIL ]  := StrTran( aTmpArt[ _NUNTTIL ], "-", "" )
         end if

      case cKey == "C"
         aTmpArt[ _NUNTTIL ]     := ""

      /*
      Multiplicamos por el numero de unidades q nos marquen--------------------
      */

      case cKey == "*"
         if !Empty( aTmpArt[ _NUNTTIL ] )
         if ( dbfTmpL )->( LastRec() ) != 0
            ( dbfTmpL )->nUntTil := Val( aTmpArt[ _NUNTTIL ] )
         end if
         aTmpArt[ _NUNTTIL ]     := ""
         end if

      /*
      Asignamos el nuevo precio------------------------------------------------
      */

      case cKey == "="
         if ( dbfTmpL )->( LastRec() ) != 0
            ( dbfTmpL )->nPvpTil := Val( aTmpArt[ _NUNTTIL ] )
         end if
         aTmpArt[ _NUNTTIL ]     := ""

   end case

   aGetArt[ _NUNTTIL ]:cText( aTmpArt[ _NUNTTIL ] )

return ( nil )

//--------------------------------------------------------------------------//

Static Function loaFam( lAvance, lRepos, aGetArt, aTmpArt, aTmp, nMode )

   local n                 := 1
   local nNumeroFamilias   := 0

   DEFAULT lAvance         := .t.
   DEFAULT lRepos          := .f.

   // Ocultamos los botones----------------------------------------------------

   aEval( oBtnFam, {|o| o:Hide() } )
   aEval( oSayFam, {|o| o:Hide() } )

   // Si estamos en modo zoom no podemos mostrar las familias------------------

   if nMode == ZOOM_MODE
      return nil
   end if

   // Posicionamiento al inicio------------------------------------------------

   if lRepos

      ( dbfFamilia )->( dbGoTop() )

      aRecFam              := {}
      aAdd( aRecFam, ( dbfFamilia )->( Recno() ) )

   end if

   // Retroceso----------------------------------------------------------------

   if ( !lRepos .and. !lAvance )

      aDel( aRecFam, len( aRecFam ), .t. )
      ( dbfFamilia )->( dbGoTo( aRecFam[ len( aRecFam ) ] ) )

   end if

   // Avance-------------------------------------------------------------------

   if ( !lRepos .and. lAvance )

      if ( dbfFamilia )->( Recno() ) != 0 .and. aScan( aRecFam, ( dbfFamilia )->( Recno() ) ) == 0
         aAdd( aRecFam, ( dbfFamilia )->( Recno() ) )
      end if

   end if

   // Nos piden avanzar montamos el boton anterior------------------------------

   if ( !lRepos .and. lAvance ) .or. ( !lRepos .and. !lAvance .and. len( aRecFam ) > 1 )

      oBtnFam[ n ]:ReLoadBitmap( "AnteriorFamilia" )
      oBtnFam[ n ]:Cargo               := .t.
      oBtnFam[ n ]:bAction             := {|| loaFam( .f., .f., aGetArt, aTmpArt, aTmp, nMode ) }
      oBtnFam[ n ]:bRClicked           := nil
      oBtnFam[ n ]:lTransparent        := .t.
      oBtnFam[ n ]:Show()

      oSayFam[ n ]:SetText( "Anterior" )
      oSayFam[ n ]:Show()

      n++

   end if

   // Montamos las familias----------------------------------------------------

   nNumeroFamilias         := nNumeroFamilias()

   while n <= nNumeroFamilias // ( nNumBtnFam - 1 )

      if !( dbfFamilia )->( eof() )

         if File( cFileBmpName( ( dbfFamilia )->cImgBtn ) )
            oBtnFam[ n ]:ReLoadBitmap( cFileBmpName( ( dbfFamilia )->cImgBtn ) )
         else
            oBtnFam[ n ]:HideBitmap()
            /*
            if ( dbfFamilia )->nColBtn != 0
               oBtnFam[ n ]:SetColor( 0, ( dbfFamilia )->nColBtn )
            else
               ? "COLOR_BTNFACE"
               oBtnFam[ n ]:SetColor( 0, GetSysColor( COLOR_BTNFACE ) )
            end if
            */
         end if

         oSayFam[ n ]:Show()
         oSayFam[ n ]:SetText( Rtrim( ( dbfFamilia )->cNomFam ) )

         oBtnFam[ n ]:Show()
         oBtnFam[ n ]:Cargo            := .f.
         oBtnFam[ n ]:bAction          := bLoaPrd( ( dbfFamilia )->cCodFam, aGetArt, aTmpArt, aTmp )
         oBtnFam[ n ]:bRClicked        := bEdtFam( ( dbfFamilia )->cCodFam )
         oBtnFam[ n ]:lTransparent     := .f.

         ( dbfFamilia )->( dbSkip() )

      end if

      n++

   end while

   if lMostrarFamilias()

      oSayFam[ n ]:SetText( "Siguiente" )
      oSayFam[ n ]:Show()

      oBtnFam[ n ]:ReLoadBitmap( "SiguienteFamilia" )
      oBtnFam[ n ]:Cargo               := .t.
      oBtnFam[ n ]:lTransparent        := .t.
      oBtnFam[ n ]:bAction             := {|| loaFam( .t., .f., aGetArt, aTmpArt, aTmp, nMode ) }
      oBtnFam[ n ]:Show()

   end if

   /*
   Buscamos la primera familia de la nueva situación---------------------------
   */

   if lRepos

      if !Empty( oBtnIni:bAction )
         Eval( oBtnIni:bAction, oBtnIni )
      end if

   else

      for n := 1 to len( oBtnFam )

         if !oBtnFam[ n ]:Cargo

            if !Empty( oBtnFam[ n ]:bAction )
               Eval( oBtnFam[ n ]:bAction, oBtnFam[ n ] )
            end if

            exit

         end if

      next

   end if

Return ( nil )

//--------------------------------------------------------------------------//

Static Function loaIni( lAvance, lInit, aGetArt, aTmpArt, aTmp )

   local n           := 1
   local nOrd        := ( dbfArticulo )->( OrdSetFocus( "nPosTcl" ) )

   DEFAULT lAvance   := .t.
   DEFAULT lInit     := .f.

   /*
   Liberamos todos los botones
   */

   if lInit

      ( dbfArticulo )->( dbGoTop() )

      aRecArt        := {}
      aAdd( aRecArt, ( dbfArticulo )->( Recno() ) )

   else

      if !lAvance

         aDel( aRecArt, len( aRecArt ), .t. )
         ( dbfArticulo )->( dbGoTo( aRecArt[ len( aRecArt  ) ] ) )

      else

         aAdd( aRecArt, ( dbfArticulo )->( Recno() ) )

      end if

   end if

   SysRefresh()

   if ( !lInit .and. len( aRecArt ) > 1 )

      oSayArt[ n ]:SetText( "Anterior" )
      oSayArt[ n ]:Show()

      oBtnArt[ n ]:ReLoadBitmap( "AnteriorArticulo" )
      oBtnArt[ n ]:Cargo         := .t.
      oBtnArt[ n ]:bAction       := {|| loaIni( .f., .f., aGetArt, aTmpArt, aTmp ) }
      oBtnArt[ n ]:bRClicked     := nil
      oBtnArt[ n ]:lTransparent  := .t.
      oBtnArt[ n ]:Show()

      n++

   end if

   while n <= nNumBtnArt - 1

      while !( dbfArticulo )->( eof() ) .and. n <= nNumBtnArt - 1

         if ( dbfArticulo )->nPosTcl != 0 .and. ( dbfArticulo )->lIncTcl

            if File( cFileBmpName( ( dbfArticulo )->cImagen ) )
               oBtnArt[ n ]:ReLoadBitmap( cFileBmpName( ( dbfArticulo )->cImagen ) )
            else
               oBtnArt[ n ]:HideBitmap()
            end if

            oBtnArt[ n ]:Show()
            oBtnArt[ n ]:bAction          := bAddPrd( ( dbfArticulo )->Codigo, aGetArt, aTmpArt, aTmp )
            oBtnArt[ n ]:bRClicked        := bEdtPrd( ( dbfArticulo )->Codigo )

            oSayArt[ n ]:SetText( if( !Empty( ( dbfArticulo )->cDesTcl ), Rtrim( ( dbfArticulo )->cDesTcl ), Rtrim( ( dbfArticulo )->Nombre ) ) )
            oSayArt[ n ]:Show()

            n++

         end if

         ( dbfArticulo )->( dbSkip() )

      end while

      if n <= nNumBtnArt - 1
         oSayArt[ n ]:Hide()
         oBtnArt[ n ]:Hide()
         oBtnArt[ n ]:bAction    := nil
         n++
      end if

   end while

   if !( dbfArticulo )->( eof() )

      oBtnArt[ n ]:ReLoadBitmap( "SiguienteArticulo" )
      oBtnArt[ n ]:bAction       := {|| loaIni( .t., .f., aGetArt, aTmpArt, aTmp ) }
      oBtnArt[ n ]:lTransparent  := .t.
      oBtnArt[ n ]:Show()

      oSayArt[ n ]:SetText( "Siguiente" )
      oSayArt[ n ]:Show()

   else

      oBtnArt[ n ]:Hide()
      oBtnArt[ n ]:bAction       := nil

      oSayArt[ n ]:Hide()

   end if

   ( dbfArticulo )->( OrdSetFocus( nOrd ) )

   SysRefresh()

Return ( nil )

//--------------------------------------------------------------------------//

Static Function bLoaPrd( cCodFam, aGetArt, aTmpArt, aTmp )

Return ( {|Self| loaPrd( cCodFam, .t., .t., aGetArt, aTmpArt, aTmp ) } )

//--------------------------------------------------------------------------//
//
// Cargo productos de la familia
//

Static Function loaPrd( cCodFam, lAvance, lInit, aGetArt, aTmpArt, aTmp )

   local n           := 1

   DEFAULT lAvance   := .t.
   DEFAULT lInit     := .f.

   /*
   Liberamos todos los botones-------------------------------------------------
   */

   if lInit

      if dbSeekInOrd( cCodFam, "nPosTpv", dbfArticulo )

         aRecArt     := {}
         aAdd( aRecArt, ( dbfArticulo )->( Recno() ) )

      end if

   else

      if !lAvance

         aDel( aRecArt, len( aRecArt ), .t. )
         ( dbfArticulo )->( dbGoTo( aRecArt[ len( aRecArt  ) ] ) )

      else

         aAdd( aRecArt, ( dbfArticulo )->( Recno() ) )

      end if

   end if

   SysRefresh()

   if ( !lInit .and. len( aRecArt ) > 1 )

      oBtnArt[ n ]:ReLoadBitmap( "AnteriorArticulo" )
      oBtnArt[ n ]:bAction       := {|| loaPrd( cCodFam, .f., .f., aGetArt, aTmpArt, aTmp ) }
      oBtnArt[ n ]:lTransparent  := .t.
      oBtnArt[ n ]:Cargo         := .t.
      oBtnArt[ n ]:bRClicked     := nil

      oBtnArt[ n ]:Show()

      oSayArt[ n ]:SetText( "Anterior" )
      oSayArt[ n ]:Show()

      n++

   end if

   while n <= nNumBtnArt - 1

      if ( dbfArticulo )->Familia == cCodFam .and. !( dbfArticulo )->( eof() )

         if ( dbfArticulo )->lIncTcl

            if File( cFileBmpName( ( dbfArticulo )->cImagen ) )
               oBtnArt[ n ]:ReLoadBitmap( cFileBmpName( ( dbfArticulo )->cImagen ) )
            else
               oBtnArt[ n ]:HideBitmap()
            end if

            oBtnArt[ n ]:Show()
            oBtnArt[ n ]:bAction       := bAddPrd( ( dbfArticulo )->Codigo, aGetArt, aTmpArt, aTmp )
            oBtnArt[ n ]:bRClicked     := bEdtPrd( ( dbfArticulo )->Codigo )

            oSayArt[ n ]:Show()
            oSayArt[ n ]:SetText( if( !Empty( ( dbfArticulo )->cDesTcl ), Rtrim( ( dbfArticulo )->cDesTcl ), Rtrim( ( dbfArticulo )->Nombre ) ) )

            n++

         end if

         ( dbfArticulo )->( dbSkip() )

      else

         oSayArt[ n ]:Hide()

         oBtnArt[ n ]:Hide()
         oBtnArt[ n ]:bAction          := nil

         n++

      end if

   end while

   if ( dbfArticulo )->Familia == cCodFam .and. !( dbfArticulo )->( eof() )

      oBtnArt[ n ]:ReLoadBitmap( "SiguienteArticulo" )
      oBtnArt[ n ]:bAction             := {|| loaPrd( cCodFam, .t., .f., aGetArt, aTmpArt, aTmp ) }
      oBtnArt[ n ]:lTransparent        := .t.
      oBtnArt[ n ]:Show()

      oSayArt[ n ]:SetText( "Siguiente" )
      oSayArt[ n ]:Show()

   else

      oSayArt[ n ]:Hide()

      oBtnArt[ n ]:bAction             := nil
      oBtnArt[ n ]:Hide()

   end if

   SysRefresh()

return ( nil )

//--------------------------------------------------------------------------//

static function bAddPrd( cCodArt, aGetArt, aTmpArt, aTmp )

return ( {|Self| AddPrd( cCodArt, aGetArt, aTmpArt, aTmp ), lRecTotal( aTmp ) } )

//--------------------------------------------------------------------------//

static function bEdtPrd( cCodArt )

return ( {|| EdtArticulo( cCodArt ) } )

//--------------------------------------------------------------------------//

static function bEdtFam( cCodFam )

return ( {|| EdtFamilia( cCodFam ) } )

//--------------------------------------------------------------------------//

static function AddPrd( cCodArt, aGetArt, aTmpArt, aTmp )

   local cCodFam
   local aArtSta                 := aGetStatus( dbfArticulo )
   local aFamSta                 := aGetStatus( dbfFamilia  )

   if Empty( cCodArt )
      return .t.
   end if

   /*
   Primero buscamos por codigos de barra---------------------------------------
   */

   ( dbfArticulo )->( ordSetFocus( "CodeBar" ) )

   if ( dbfArticulo )->( dbSeek( cCodArt ) )
      cCodArt                    := ( dbfArticulo )->Codigo
   end if

   ( dbfArticulo )->( ordSetFocus( "Codigo" ) )

   /*
   Ahora buscamos por el codigo interno----------------------------------------
   */

   if ( dbfArticulo )->( dbSeek( cCodArt ) )

      if !lTwoLin

         aTmpArt[ _CCBATIL ]     := cCodArt

         if !Empty( ( dbfArticulo )->cDesTik )
            aTmpArt[ _CNOMTIL ]  := ( dbfArticulo )->cDesTik
         else
            aTmpArt[ _CNOMTIL ]  := ( dbfArticulo )->Nombre
         end if

         /*
         Nos quedamos con el artículo para los combinados----------------------
         */

         cCodArtAnt              := cCodArt

         /*
         Familia del artículo--------------------------------------------------
         */

         aTmpArt[ _CFAMTIL ]     := ( dbfArticulo )->Familia
         aTmpArt[ _LTIPACC ]     := ( dbfArticulo )->lTipAcc
         aTmpArt[ _NCTLSTK ]     := ( dbfArticulo )->nCtlStock

         /*
         Obtenemos la familia y los codigos de familia-------------------------
         */

         cCodFam                 := ( dbfArticulo )->Familia
         if !Empty( cCodFam )
            aTmpArt[ _CCODFAM ]  := cCodFam
            aTmpArt[ _CGRPFAM ]  := cGruFam( cCodFam, dbfFamilia )

            /*
            Buscamos la familia del articulo y anotamos las propiedades--------
            */

            if dbSeekInOrd( cCodFam, "cCodFam", dbfFamilia )
               aTmpArt[ _CCODPR1 ]  := ( dbfArticulo )->cCodPrp1
               aTmpArt[ _CCODPR2 ]  := ( dbfArticulo )->cCodPrp2
            else
               aTmpArt[ _CCODPR1 ]  := Space( 10 )
               aTmpArt[ _CCODPR2 ]  := Space( 10 )
            end if

         end if

         /*
         Guardamos las impresoras de comandas en las lineas--------------------
         */

         aTmpArt[ _NIMPCOM1 ]    := ( dbfArticulo )->nImpCom1 - 1
         aTmpArt[ _NIMPCOM2 ]    := ( dbfArticulo )->nImpCom2 - 1

         /*
         Obtenemos el Tipo de impuestos
         */

         aTmpArt[ _NIVATIL ]     := nIva( dbfIva, ( dbfArticulo )->TipoIva )
         aTmpArt[ _NPVPTIL ]     := nRetPreArt( oSalaVentas:nSelectedPrecio, cDivEmp(), .t., dbfArticulo, dbfDiv, dbfKit, dbfIva, .t. )

         /*
         Obtenemos el factor de conversion-------------------------------------------
         */

         if ( dbfArticulo )->lFacCnv
            aTmpArt[ _NFACCNV ]     := ( dbfArticulo )->nFacCnv
         end if

         /*
         Obtenemos el numero de unidades---------------------------------------------
         */

         if !Empty( aTmpArt[ _NUNTTIL ] )

            if ValType( aTmpArt[ _NUNTTIL ] ) == "C"
               aTmpArt[ _NUNTTIL ]  := Val( aTmpArt[ _NUNTTIL ] )
            end if

         else

            aTmpArt[ _NUNTTIL ]  := 1

         end if

         aTmpArt[ _CALMLIN ]     := oUser():cAlmacen()

         /*
         Imprimo en el visor el nombre y precio del artículo-------------------
         */

         if oVisor != nil
            oVisor:SetBufferLine( { aTmpArt[ _CNOMTIL ], Trans( aTmpArt[ _NPVPTIL ], cPouDiv ) }, 1 )
         end if

         /*
         Si el articulo no esta en la lista lo agregamos-----------------------
         */

         if !lIsCode( aTmpArt, dbfTmpL, oBrwDet )
            WinGather( aTmpArt, aGetArt, dbfTmpL, oBrwDet, APPD_MODE, nil, .t. )
         end if

      else

         aTmpArt                 := dbScatter( dbfTmpL )
         aTmpArt[ _CCOMTIL ]     := cCodArt

         if !Empty( ( dbfArticulo )->cDesTik )
            aTmpArt[ _CNCMTIL ]  := ( dbfArticulo )->cDesTik
         else
            aTmpArt[ _CNCMTIL ]  := ( dbfArticulo )->Nombre
         end if

         /*
         Factor de conversion
         ----------------------------------------------------------------------
         */

         if ( dbfArticulo )->lFacCnv
            aTmpArt[ _NFCMCNV ]  := ( dbfArticulo )->nFacCnv
         end if

         /*
         Familia del artículo
         */

         aTmpArt[ _CFCMTIL ]     := ( dbfArticulo )->Familia

         /*
         Importe de los productos----------------------------------------------
         */

         aTmpArt[ _NPCMTIL ]     := nRetPreArt( oSalaVentas:nSelectedCombinado, cDivEmp(), .t., dbfArticulo, dbfDiv, dbfKit, dbfIva, uFieldEmpresa( "LBUSIMP" ) )
         aTmpArt[ _NPVPTIL ]     := cRetPreArt( aTmpArt[ _CCBATIL ], oSalaVentas:nSelectedCombinado, cDivEmp(), .t., dbfArticulo, dbfDiv, dbfKit, dbfIva, .t. )

         lTwoLin                 := .f.

         /*
         Imprimo en el visor el nombre y precio del artículo-------------------
         */

         if oVisor != nil
            oVisor:Say( aTmpArt[ _CNOMTIL ], Trans( aTmpArt[ _NPVPTIL ], cPouDiv ) )
         end if

         WinGather( aTmpArt, aGetArt, dbfTmpL, oBrwDet, EDIT_MODE, nil, .t. )

         /*
         si combinamos con una familia volvemos al origen----------------------
         */

         if !Empty( cCodFamAnt )
            loaPrd( cCodFamAnt, .t., .t., aGetArt, aTmpArt, aTmp )
         end if

         /*
         Limpiamos los valores usados para combinar----------------------------
         */

         cCodArtAnt              := ""
         cCodFamAnt              := ""

      end if

      /*
      Cargamos los valores por defecto de nuevo--------------------------------
      */

      aGetArt[ _NUNTTIL ]:cText( "" )
      aTmpArt[ _NPVPTIL ]        := 0

      /*
      Pintamos el buffer-------------------------------------------------------
      */

      if oVisor != nil
         oVisor:SetBufferLine( { "Total", Trans( nTotTik, cPorDiv ) }, 2 )
         oVisor:WriteBufferLine()
      end if

   else

      MsgBeepStop( "Artículo no encontrado" )

   end if

   /*
   Retomamos el estado del la base de datos------------------------------------
   */

   SetStatus( dbfArticulo, aArtSta )
   SetStatus( dbfFamilia,  aFamSta )

return ( nil )

//--------------------------------------------------------------------------//

Static Function EdtCob( aTmp, aGet, dbfTikP, oBrw, bWhen, bValid, nMode, aTmpTik )

	local oDlg
   local oBmpDiv
   local oGetSubCta
   local cGetSubCta
   local cImpDiv
   local oSay
   local cSay           := Num2Text( aTmp[ _NIMPTIK ] )
   local oGetCaj
   local cGetCaj        := RetFld( aTmp[ _CCODCAJ ], dbfCajT, "cNomCaj" )
   local oGetFpg
   local cGetFpg        := RetFld( aTmp[ _CFPGPGO ], dbfFPago )

   if nMode == APPD_MODE
      aTmp[ _CDIVPGO ]  := cDivEmp()
      aTmp[ _NVDVPGO ]  := 1
      aTmp[ _CTURPGO ]  := cCurSesion()
   end if

   cImpDiv              := cPorDiv( aTmp[ _CDIVPGO ], dbfDiv )

   DEFINE DIALOG oDlg RESOURCE "PgoTiket"

      REDEFINE GET aGet[ _CTURPGO ] VAR aTmp[ _CTURPGO ] ;
         ID       90 ;
         WHEN     ( .f. ) ;
			OF 		oDlg

      REDEFINE GET aGet[ _DPGOTIK ] VAR aTmp[ _DPGOTIK ] ;
			ID 		100 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ON HELP  aGet[ _DPGOTIK ]:cText( Calendario( aTmp[ _DPGOTIK ] ) ) ;
         BITMAP   "LUPA" ;
			OF 		oDlg

      REDEFINE GET aGet[ _CPGDPOR ] VAR aTmp[ _CPGDPOR ] ;
         ID       110 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         COLOR    CLR_GET ;
			OF 		oDlg

      /*
      Forma de pago____________________________________________________________
		*/

      REDEFINE GET aGet[ _CFPGPGO ] VAR aTmp[ _CFPGPGO ] ;
         ID       160 ;
         VALID    cFpago( aGet[ _CFPGPGO ], dbfFPago, oGetFpg ) ;
         BITMAP   "LUPA" ;
         OF       oDlg
      aGet[ _CFPGPGO ]:bHelp  := {|| BrwFPago( aGet[ _CFPGPGO ], oGetFpg, .f. ) }

      REDEFINE GET oGetFpg VAR cGetFpg ;
         ID       161 ;
         WHEN     .f.;
         OF       oDlg

      /*
		Cajas____________________________________________________________________
		*/

      REDEFINE GET aGet[ _CCODCAJ ] VAR aTmp[ _CCODCAJ ];
			WHEN 		( nMode != ZOOM_MODE ) ;
         VALID    cCajas( aGet[ _CCODCAJ ], dbfCajT, oGetCaj ) ;
         ID       280 ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwCajas( aGet[ _CCODCAJ ], oGetCaj ) ) ;
         OF       oDlg

      REDEFINE GET oGetCaj VAR cGetCaj ;
         ID       281 ;
         WHEN     .f. ;
         OF       oDlg

      REDEFINE GET aGet[ _CDIVPGO ] VAR aTmp[ _CDIVPGO ];
         VALID    (  cDivOut( aGet[ _CDIVPGO ], oBmpDiv, aGet[ _NVDVPGO ], nil, nil, @cImpDiv, nil, nil, nil, nil, dbfDiv, oBandera ),;
                     aGet[ _NIMPTIK ]:SetPicture( cImpDiv ), .t. );
         PICTURE  "@!";
         ID       120 ;
			COLOR 	CLR_GET ;
         BITMAP   "LUPA" ;
         ON HELP  BrwDiv( aGet[ _CDIVPGO ], oBmpDiv, aGet[ _NVDVPGO ], dbfDiv, oBandera ) ;
         OF       oDlg

		REDEFINE BITMAP oBmpDiv ;
         RESOURCE "BAN_EURO" ;
         ID       121;
         OF       oDlg

      REDEFINE GET aGet[ _NVDVPGO ] VAR aTmp[ _NVDVPGO ];
			WHEN		( .F. ) ;
         ID       122 ;
         PICTURE  "@E 999,999.9999" ;
         COLOR    CLR_GET ;
         OF       oDlg

      REDEFINE GET aGet[ _NIMPTIK ] VAR aTmp[ _NIMPTIK ] ;
         ID       130 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( oSay:SetText( Num2Text( aTmp[ _NIMPTIK ] ) ), .t. ) ;
         COLOR    CLR_GET ;
         PICTURE  ( cPorDiv ) ;
			OF 		oDlg

      REDEFINE SAY oSay VAR cSay ;
         ID       140 ;
         COLOR    CLR_GET ;
         OF       oDlg

      REDEFINE GET aGet[ _CCTAREC ] VAR aTmp[ _CCTAREC ] ;
         ID       150 ;
			COLOR 	CLR_GET ;
         PICTURE  ( Replicate( "X", nLenSubcuentaContaplus() ) ) ;
         WHEN     ( nLenCuentaContaplus() != 0 .AND. nMode != ZOOM_MODE ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwChkSubcuenta( aGet[ _CCTAREC ], oGetSubCta ) ) ;
         VALID    ( MkSubcuenta( aGet[ _CCTAREC ], { aTmp[ _CCTAREC ] }, oGetSubCta ) );
         OF       oDlg

		REDEFINE GET oGetSubCta VAR cGetSubCta ;
         ID       151 ;
			COLOR 	CLR_GET ;
			WHEN 		.F. ;
         OF       oDlg

		REDEFINE BUTTON ;
         ID       IDOK ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( WinGather( aTmp, aGet, dbfTmpP, oBrw, nMode ), oDlg:end( IDOK ) )

      REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
         CANCEL ;
         ACTION   ( oDlg:end() )

      oDlg:AddFastKey( VK_F5, {|| WinGather( aTmp, aGet, dbfTmpP, oBrw, nMode ), oDlg:end( IDOK ) } )

   ACTIVATE DIALOG oDlg ;
         CENTER ;
         ON INIT  ( aGet[ _CDIVPGO ]:lValid(), aGet[ _CCTAREC ]:lValid() )

   oBmpDiv:end()

Return ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

Static Function loaCli( aGet, aTmp, nMode, oTlfCli )

   local lValid      := .f.
   local cNewCodCli  := aGet[ _CCLITIK ]:VarGet()
   local lChgCodCli  := ( Empty( cOldCodCli ) .or. AllTrim( cOldCodCli ) != AllTrim( cNewCodCli ) )

   if Empty( cNewCodCli )
      Return .t.
   end if

   if At( ".", cNewCodCli ) != 0
      cNewCodCli     := PntReplace( aGet[ _CCLITIK ], "0", RetNumCodCliEmp() )
   else
      cNewCodCli     := Rjust( cNewCodCli, "0", RetNumCodCliEmp() )
   end if

   if ( dbfClient )->( dbSeek( cNewCodCli ) )

      if ( dbfClient )->lBlqCli
         msgStop( "Cliente bloqueado, no se pueden realizar operaciones de venta" )
         return .f.
      end if

      /*
      Calculo del reisgo del cliente
      */

      if oRieCli != nil
         GetRiesgo( cNewCodCli, dbfClient, oRieCli )
      end if

      if ( lChgCodCli )
         aTmp[ _LMODCLI ]  := ( dbfClient )->lModDat
      end if

      aGet[ _CCLITIK ]:cText( ( dbfClient )->Cod )

      if !Empty( aGet[ _NTARIFA ]:varGet() ) .or. lChgCodCli
         aGet[ _NTARIFA ]:cText( ( dbfClient )->nTarifa )
      end if

      if ( dbfClient )->nColor != 0
         aGet[ _CNOMTIK ]:SetColor( , ( dbfClient )->nColor )
      end if

      if lChgCodCli .and. ( dbfClient )->nTarifa != 0
         aGet[ _CNOMTIK ]:cText( ( dbfClient )->Titulo  )
      end if

      if Empty( aGet[ _CDIRCLI ]:varGet() ) .or. lChgCodCli
         aGet[ _CDIRCLI ]:cText( ( dbfClient )->Domicilio )
      end if

      if Empty( aGet[ _CPOBCLI ]:varGet() ) .or. lChgCodCli
         aGet[ _CPOBCLI ]:cText( ( dbfClient )->Poblacion )
      end if

      if Empty( aGet[ _CPRVCLI ]:varGet() ) .or. lChgCodCli
         aGet[ _CPRVCLI ]:cText( ( dbfClient )->Provincia )
      end if

      if Empty( aGet[ _CPOSCLI ]:varGet() ) .or. lChgCodCli
         aGet[ _CPOSCLI ]:cText( ( dbfClient )->CodPostal )
      end if

      if Empty( aGet[ _CDNICLI ]:varGet() ) .or. lChgCodCli
         aGet[ _CDNICLI ]:cText( ( dbfClient )->Nif )
      end if

      if oTlfCli != nil
         oTlfCli:SetText( ( dbfClient )->Telefono )
      end if

      if Empty( aTmp[ _CCODGRP ] ) .or. lChgCodCli
         aTmp[ _CCODGRP ]  := ( dbfClient )->cCodGrp
      end if

      /*
      Solo si el ticket es nuevo-----------------------------------------------
      */

      if nMode == APPD_MODE

         if Empty( aTmp[ _CSERTIK ] ) .and. !Empty( ( dbfClient )->Serie ) .and. lChgCodCli
            aGet[ _CSERTIK ]:cText( ( dbfClient )->Serie )
         end if

         if Empty( aGet[ _CALMTIK ]:varGet() ) .and. lChgCodCli .and. !Empty( ( dbfClient )->cCodAlm )
            aGet[ _CALMTIK ]:cText( ( dbfClient )->cCodAlm )
            aGet[ _CALMTIK ]:lValid()
         end if

         if ( Empty( aGet[ _CCODTAR ]:varGet() ) .or. lChgCodCli ) .and. !Empty( ( dbfClient )->cCodTar )
            aGet[ _CCODTAR ]:cText( ( dbfClient )->cCodTar )
            aGet[ _CCODTAR ]:lValid()
         end if

         if ( Empty( aGet[ _CFPGTIK ]:varGet() ) .or. lChgCodCli ) .and. !Empty( ( dbfClient )->CodPago )
            if !uFieldEmpresa( "lGetFpg" )
               aGet[ _CFPGTIK ]:cText( ( dbfClient)->CodPago )
            end if
            aGet[ _CFPGTIK ]:lValid()
         end if

         if ( Empty( aGet[ _CCODAGE ]:varGet() ) .or. lChgCodCli ) .and. !Empty( ( dbfClient )->cAgente )
            aGet[ _CCODAGE ]:cText( (dbfClient)->cAgente )
            aGet[ _CCODAGE ]:lValid()
         end if

         if ( Empty( aGet[ _CCODRUT ]:varGet() ) .or. lChgCodCli ) .and. !Empty( ( dbfClient )->cCodRut )
            aGet[ _CCODRUT ]:cText( ( dbfClient)->cCodRut )
            aGet[ _CCODRUT ]:lValid()
         end if

      end if

      if ( dbfClient )->lMosCom .and. !Empty( ( dbfClient )->mComent ) .and. lChgCodCli
         MsgStop( Trim( ( dbfClient )->mComent ) )
      end if

      if lObras() .and. Empty( aTmp[ _CCODOBR ] ) .and. lChgCodCli
         msgWait( "Introduzca la dirección", "Info", 0 )
         aGet[ _CCODOBR ]:SetFocus()
      end if

      cOldCodCli     := cNewCodCli
      lValid         := .t.

   else

		msgStop( "Cliente no encontrado" )

   end if

Return lValid

//----------------------------------------------------------------------------//

static function TPadl( cExp, n )

return Padl( AllTrim( cExp ), n )

//----------------------------------------------------------------------------//

function SavTik2Alb( aTik, aGet, nMode, nSave )

   local nNewAlbCli
   local cSerTik                 := aTik [ _CSERTIK ]
   local cNumTik                 := aTik [ _CNUMTIK ]
   local cSufTik                 := aTik [ _CSUFTIK ]

   if nMode == APPD_MODE .or. lApartado

      /*
      Nuevo numero del Albaran-------------------------------------------------
      */

      cNumTik                    := nNewDoc( aTik[ _CSERTIK ], dbfAlbCliT, "NALBCLI", , dbfCount )
      cSufTik                    := RetSufEmp()

      ( dbfAlbCliT )->( dbAppend() )

      ( dbfAlbCliT )->cSerAlb    := cSerTik
      ( dbfAlbCliT )->nNumAlb    := cNumTik
      ( dbfAlbCliT )->cSufAlb    := cSufTik
      ( dbfAlbCliT )->dFecCre    := aTik[ _DFECCRE ]
      ( dbfAlbCliT )->cTimCre    := aTik[ _CTIMCRE ]
      ( dbfAlbCliT )->dFecAlb    := aTik[ _DFECTIK ]
      ( dbfAlbCliT )->cCodUsr    := aTik[ _CCCJTIK ]
      ( dbfAlbCliT )->cTurAlb    := cCurSesion()
      ( dbfAlbCliT )->cNumDoc    := cSerTik + Str( cNumTik ) + cSufTik

      ( dbfAlbCliT )->( dbUnLock() )

      /*
      Punteros entre documentos---------------------------------------------------
      */

      aTik[ _CNUMDOC ]           := cSerTik + Str( cNumTik ) + cSufTik

   else

      /*
      Posicionamos en el albaran existente
      */

      cSerTik     := SubStr( aTik[ _CNUMDOC ], 1, 1 )
      cNumTik     := Val( SubStr( aTik[ _CNUMDOC ], 2, 9 ) )
      cSufTik     := SubStr( aTik[ _CNUMDOC ], 11, 2 )

      if !( dbfAlbCliT )->( dbSeek( aTik[ _CNUMDOC ] ) )

         ( dbfAlbCliT )->( dbAppend() )
         ( dbfAlbCliT )->cSerAlb    := cSerTik
         ( dbfAlbCliT )->nNumAlb    := cNumTik
         ( dbfAlbCliT )->cSufAlb    := cSufTik
         ( dbfAlbCliT )->dFecCre    := aTik[ _DFECCRE ]
         ( dbfAlbCliT )->cTimCre    := aTik[ _CTIMCRE ]
         ( dbfAlbCliT )->cTurAlb    := aTik[ _CTURTIK ]
         ( dbfAlbCliT )->( dbUnLock() )

      end if

      /*
      Rollback de los stocks
      */

      //oStock:AlbCli( ( dbfAlbCliT )->cSerAlb + Str( ( dbfAlbCliT )->nNumAlb ) + ( dbfAlbCliT )->cSufAlb, ( dbfAlbCliT )->cCodAlm, .t., .t., .t. )

   end if

   /*
   Cabecera del albaran--------------------------------------------------------
   */

   if dbLock( dbfAlbCliT )

      ( dbfAlbCliT )->LFACTURADO    := .f.
      ( dbfAlbCliT )->LSNDDOC       := .t.
      ( dbfAlbCliT )->lIvaInc       := .t.
      ( dbfAlbCliT )->CCODCLI       := aTik[ _CCLITIK ]
      ( dbfAlbCliT )->CCODALM       := aTik[ _CALMTIK ]
      ( dbfAlbCliT )->cCodCaj       := aTik[ _CNCJTIK ]
      ( dbfAlbCliT )->CNOMCLI       := aTik[ _CNOMTIK ]
      ( dbfAlbCliT )->CCODPAGO      := aTik[ _CFPGTIK ]
      ( dbfAlbCliT )->CDIVALB       := aTik[ _CDIVTIK ]
      ( dbfAlbCliT )->NVDVALB       := aTik[ _NVDVTIK ]
      ( dbfAlbCliT )->CRETMAT       := aTik[ _CRETMAT ]
      ( dbfAlbCliT )->CCODAGE       := aTik[ _CCODAGE ]
      ( dbfAlbCliT )->CCODRUT       := aTik[ _CCODRUT ]
      ( dbfAlbCliT )->CCODTAR       := aTik[ _CCODTAR ]
      ( dbfAlbCliT )->CCODOBR       := aTik[ _CCODOBR ]
      ( dbfAlbCliT )->NPCTCOMAGE    := aTik[ _NCOMAGE ]

      if Empty( ( dbfAlbCliT )->cTurAlb )
         ( dbfAlbCliT )->cTurAlb    := cCurSesion()
      end if

      /*
      Obtenemos los datos del cliente---------------------------------------------
      */

      ( dbfAlbCliT )->cDirCli       := aTik[ _CDIRCLI ]
      ( dbfAlbCliT )->cPobCli       := aTik[ _CPOBCLI ]
      ( dbfAlbCliT )->cPrvCli       := aTik[ _CPRVCLI ]
      ( dbfAlbCliT )->cPosCli       := aTik[ _CPOSCLI ]
      ( dbfAlbCliT )->cDniCli       := aTik[ _CDNICLI ]

      ( dbfAlbCliT )->( dbUnLock() )

   end if

   /*
   Ahora pasamos las lineas de detalle-----------------------------------------
   */

   ( dbfTmpL )->( dbGoTop() )
   while !( dbfTmpL )->( eof() )

      ( dbfAlbCliL )->( dbAppend() )
      ( dbfAlbCliL )->CSERALB    := ( dbfAlbCliT )->CSERALB
      ( dbfAlbCliL )->NNUMALB    := ( dbfAlbCliT )->NNUMALB
      ( dbfAlbCliL )->CSUFALB    := ( dbfAlbCliT )->CSUFALB
      ( dbfAlbCliL )->CREF       := ( dbfTmpL    )->CCBATIL
      ( dbfAlbCliL )->CDETALLE   := ( dbfTmpL    )->CNOMTIL
      ( dbfAlbCliL )->NPREUNIT   := ( dbfTmpL    )->NPVPTIL //Round( ( dbfTmpL )->NPVPTIL / ( 1 + ( ( dbfTmpL )->NIVATIL / 100 ) ), nDouDiv )
      ( dbfAlbCliL )->NDTO       := ( dbfTmpL    )->NDTOLIN
      ( dbfAlbCliL )->NIVA       := ( dbfTmpL    )->NIVATIL
      ( dbfAlbCliL )->NUNICAJA   := ( dbfTmpL    )->NUNTTIL
      ( dbfAlbCliL )->CCODPR1    := ( dbfTmpL    )->CCODPR1
      ( dbfAlbCliL )->CCODPR2    := ( dbfTmpL    )->CCODPR2
      ( dbfAlbCliL )->CVALPR1    := ( dbfTmpL    )->CVALPR1
      ( dbfAlbCliL )->CVALPR2    := ( dbfTmpL    )->CVALPR2
      ( dbfAlbCliL )->NFACCNV    := ( dbfTmpL    )->NFACCNV
      ( dbfAlbCliL )->NDTODIV    := ( dbfTmpL    )->NDTODIV
      ( dbfAlbCliL )->nCtlStk    := ( dbfTmpL    )->nCtlStk
      ( dbfAlbCliL )->nValImp    := ( dbfTmpL    )->nValImp
      ( dbfAlbCliL )->cCodImp    := ( dbfTmpL    )->cCodImp
      ( dbfAlbCliL )->lKitChl    := ( dbfTmpL    )->lKitChl
      ( dbfAlbCliL )->lKitArt    := ( dbfTmpL    )->lKitArt
      ( dbfAlbCliL )->lKitPrc    := ( dbfTmpL    )->lKitPrc
      ( dbfAlbCliL )->mNumSer    := ( dbfTmpL    )->mNumSer
      ( dbfAlbCliL )->lIvaLin    := .t.
      ( dbfAlbCliL )->( dbUnLock() )

      ( dbfTmpL )->( dbSkip() )

   end while

   //oStock:AlbCli( ( dbfAlbCliT )->cSerAlb + Str( ( dbfAlbCliT )->nNumAlb ) + ( dbfAlbCliT )->cSufAlb, ( dbfAlbCliT )->cCodAlm, .f., .f., .t. )

   /*
   Rollback de los pagos-------------------------------------------------------
   */

   while ( dbfAlbCliP )->( dbSeek( ( dbfAlbCliT )->cSerAlb + Str( ( dbfAlbCliT )->nNumAlb ) + ( dbfAlbCliT )->cSufAlb ) ) .and. !( dbfAlbCliP )->( eof() )

      if dbLock( dbfAlbCliP )
         ( dbfAlbCliP )->( dbDelete() )
         ( dbfAlbCliP )->( dbUnLock() )
      end if

      ( dbfAlbCliP )->( dbSkip() )

   end while

   /*
   Trasbase de nuevos pagos----------------------------------------------------
   */

   ( dbfTmpE )->( dbGoTop() )

   while !( dbfTmpE )->( eof() )

      ( dbfAlbCliP )->( dbAppend() )

      ( dbfAlbCliP )->cSerAlb    := cSerTik
      ( dbfAlbCliP )->nNumAlb    := cNumTik
      ( dbfAlbCliP )->cSufAlb    := cSufTik
      ( dbfAlbCliP )->nNumRec    := ( dbfTmpE )->nNumRec
      ( dbfAlbCliP )->cCodCaj    := ( dbfTmpE )->cCodCaj
      ( dbfAlbCliP )->cTurRec    := ( dbfTmpE )->cTurRec
      ( dbfAlbCliP )->cCodCli    := ( dbfTmpE )->cCodCli
      ( dbfAlbCliP )->dEntrega   := ( dbfTmpE )->dEntrega
      ( dbfAlbCliP )->nImporte   := ( dbfTmpE )->nImporte
      ( dbfAlbCliP )->cDescrip   := ( dbfTmpE )->cDescrip
      ( dbfAlbCliP )->cPgdoPor   := ( dbfTmpE )->cPgdoPor
      ( dbfAlbCliP )->cDivPgo    := ( dbfTmpE )->cDivPgo
      ( dbfAlbCliP )->nVdvPgo    := ( dbfTmpE )->nVdvPgo
      ( dbfAlbCliP )->cCodAge    := ( dbfTmpE )->cCodAge
      ( dbfAlbCliP )->cCodPgo    := ( dbfTmpE )->cCodPgo
      ( dbfAlbCliP )->lCloPgo    := .f.
      ( dbfAlbCliP )->lPasado    := ( dbfTmpE )->lPasado

      ( dbfAlbCliP )->( dbUnLock() )

      ( dbfTmpE )->( dbSkip() )

   end while

   /*
   Escribimos definitivamente en el disco--------------------------------------
   */

   WinGather( aTik, aGet, dbfTikT, oBrwDet, nMode, nil, .t. )

return ( nNewAlbCli )

//----------------------------------------------------------------------------//

Function nTotalizer( cNumTik, cTikT, cTikL, cTikP, cAlbCliT, cAlbCliL, cFacCliT, cFacCliL, cFacCliP, cIva, cDiv, cCodDiv, lPic )

   local uTotal

   DEFAULT cTikT        := dbfTikT
   DEFAULT cTikL        := dbfTikL
   DEFAULT cTikP        := dbfTikP
   DEFAULT cAlbCliT     := dbfAlbCliT
   DEFAULT cAlbCliL     := dbfAlbCliL
   DEFAULT cFacCliT     := dbfFacCliT
   DEFAULT cFacCliL     := dbfFacCliL
   DEFAULT cFacCliP     := dbfFacCliP
   DEFAULT cIva         := dbfIva
   DEFAULT cDiv         := dbfDiv
   DEFAULT cNumTik      := ( cTikT )->cSerTik + ( cTikT )->cNumTik + ( cTikT )->cSufTik
   DEFAULT lPic         := .t.

   public nTotAlb       := 0
   public nTotFac       := 0

   uTotal               := if( lPic, "0", 0 )

   do case
      case ( cTikT )->cTipTik == SAVALB // Como albaran

         if ( cAlbCliT )->( dbSeek( ( cTikT )->cNumDoc ) )
            uTotal      := nTotAlbCli( ( cTikT )->cNumDoc, cAlbCliT, cAlbCliL, cIva, cDiv, nil, cCodDiv, lPic )
            nTotAlb     := uTotal
         end if

      case ( cTikT )->cTipTik == SAVFAC // Como factura

         if ( cFacCliT )->( dbSeek( ( cTikT )->cNumDoc ) )
            uTotal      := nTotFacCli( ( cTikT )->cNumDoc, cFacCliT, cFacCliL, cIva, cDiv, cFacCliP, nil, nil, cCodDiv, lPic )
            nTotFac     := uTotal
         end if

      otherwise

         uTotal         := nTotTik( cNumTik, cTikT, cTikL, cDiv, nil, cCodDiv, lPic )

   end case

return ( uTotal )

//----------------------------------------------------------------------------//

Static Function nChkalizer( cNumTik, dbfTikT, dbfTikL, dbfTikP, dbfFacCliT, dbfFacCliL, dbfFacCliP, dbfIva, dbfDiv, cCodDiv )

   local nPgo     := 1
   local aStatus  := aGetStatus( dbfTikT, .t. )
   local nRec     := ( dbfFacCliT )->( RecNo() )
   local nOrdAnt  := ( dbfFacCliT )->( OrdSetFocus( "NNUMFAC" ) )

   If ( dbfTikT )->( dbSeek( cNumTik ) )

      Do Case
      Case ( dbfTikT )->cTipTik == SAVALB // Como albaran

         if RetFld( ( dbfTikT )->cNumDoc, dbfAlbCliT, "lFacturado" )
            nPgo  := 1
         else
            nPgo  := 3
         end if

      Case ( dbfTikT )->cTipTik == SAVFAC // Como factura

         if ( dbfFacCliT )->( dbSeek( ( dbfTikT )->cNumDoc ) )
            nPgo  := nChkPagFacCli( ( dbfTikT )->cNumDoc, dbfFacCliT, dbfFacCliP )
         else
            nPgo  := 3
         end if

      Case ( dbfTikT )->cTipTik == SAVVAL // Como Vale

         nPgo     := if( ( dbfTikT )->lLiqTik, 1, 3 )

      Otherwise

         nPgo     := nChkPagTik( cNumTik, dbfTikT, dbfTikL, dbfTikP, dbfIva, dbfDiv )

      End Case

   End if

   ( dbfFacCliT )->( OrdSetFocus( nOrdAnt ) )
   ( dbfFacCliT )->( dbGoTo( nRec ) )

   SetStatus( dbfTikT, aStatus )

Return ( nPgo )

//----------------------------------------------------------------------------//

Function nCobalizer( cNumTik, dbfTikT, dbfTikL, dbfTikP, dbfAlbCliT, dbfAlbCliL, dbfFacCliT, dbfFacCliL, dbfFacCliP, dbfIva, dbfDiv, cCodDiv, lPic )

   local nPgo     := if( lPic, "", 0 )
   local aStatus  := aGetStatus( dbfTikT, .t. )

   If ( dbfTikT )->( dbSeek( cNumTik ) )

      Do Case
      Case ( dbfTikT )->cTipTik == SAVFAC // Como factura

         nPgo     := nPagFacCli( ( dbfTikT )->cNumDoc, dbfFacCliT, dbfFacCliP, dbfIva, dbfDiv, cCodDiv, .t., lPic )

      Case  ( dbfTikT )->cTipTik == SAVTIK .or.;
            ( dbfTikT )->cTipTik == SAVDEV .or.;
            ( dbfTikT )->cTipTik == SAVAPT .or.;
            ( dbfTikT )->cTipTik == SAVVAL

         nPgo     := nTotCobTik( ( dbfTikT )->cSerTik + ( dbfTikT )->cNumTik + ( dbfTikT )->cSufTik, dbfTikP, dbfDiv, cCodDiv, lPic )

      End Case

   End if

   SetStatus( dbfTikT, aStatus )

Return ( nPgo )

//----------------------------------------------------------------------------//

Function nDifalizer( cNumTik, dbfTikT, dbfTikL, dbfTikP, dbfAlbCliT, dbfAlbCliL, dbfFacCliT, dbfFacCliL, dbfFacCliP, dbfAntCliT, dbfIva, dbfDiv, cCodDiv, lPic )

   local cPorDiv  := cPorDiv( cCodDiv, dbfDiv ) // Picture de la divisa redondeada
   local nTot     := nTotalizer( cNumTik, dbfTikT, dbfTikL, dbfTikP, dbfAlbCliT, dbfAlbCliL, dbfFacCliT, dbfFacCliL, dbfFacCliP, dbfIva, dbfDiv, cCodDiv, .f. )
   nTot           -= nCobalizer( cNumTik, dbfTikT, dbfTikL, dbfTikP, dbfAlbCliT, dbfAlbCliL, dbfFacCliT, dbfFacCliL, dbfFacCliP, dbfIva, dbfDiv, cCodDiv, .f. )
   nTot           -= nTotValTik( cNumTik, dbfTikT, dbfTikL, dbfDiv, cCodDiv, .f. )
   nTot           -= nTotAntFacCli( ( dbfTikT )->cNumDoc, dbfAntCliT, dbfIva, dbfDiv, cCodDiv, .f. )

Return ( if( lPic, Trans( nTot, cPorDiv ), nTot ) )

//---------------------------------------------------------------------------//

static function LoaAlb2Tik()

   if ( dbfAlbCliL )->( DbSeek( ( dbfTikT )->cNumDoc ) )
      while ( ( dbfAlbCliL )->CSERALB + Str( ( dbfAlbCliL )->NNUMALB ) + ( dbfAlbCliL )->CSUFALB == ( dbfTikT )->cNumDoc .and. !( dbfAlbCliL )->( eof() ) )

         ( dbfTmpL )->( dbAppend() )
         ( dbfTmpL )->cCbaTil    := ( dbfAlbCliL )->CREF
         ( dbfTmpL )->cNomTil    := ( dbfAlbCliL )->CDETALLE
         ( dbfTmpL )->nPvpTil    := ( dbfAlbCliL )->NPREUNIT // ( ( dbfAlbCliL )->NPREUNIT * ( dbfAlbCliL )->NIVA / 100 ) + ( dbfAlbCliL )->NPREUNIT
         ( dbfTmpL )->nDtoLin    := ( dbfAlbCliL )->NDTO
         ( dbfTmpL )->nIvaTil    := ( dbfAlbCliL )->NIVA
         ( dbfTmpL )->nUntTil    := If( ( dbfAlbCliL )->NCANENT != 0, ( dbfAlbCliL )->NCANENT, 1 ) * ( dbfAlbCliL )->NUNICAJA
         ( dbfTmpL )->cCodPr1    := ( dbfAlbCliL )->CCODPR1
         ( dbfTmpL )->cCodPr2    := ( dbfAlbCliL )->CCODPR2
         ( dbfTmpL )->cValPr1    := ( dbfAlbCliL )->CVALPR1
         ( dbfTmpL )->cValPr2    := ( dbfAlbCliL )->CVALPR2
         ( dbfTmpL )->nFacCnv    := ( dbfAlbCliL )->NFACCNV
         ( dbfTmpL )->nDtoDiv    := ( dbfAlbCliL )->NDTODIV // * ( dbfAlbCliL )->NIVA / 100 ) + ( dbfAlbCliL )->NDTODIV
         ( dbfTmpL )->nCtlStk    := ( dbfAlbCliL )->nCtlStk
         ( dbfTmpL )->nValImp    := ( dbfAlbCliL )->nValImp
         ( dbfTmpL )->cCodImp    := ( dbfAlbCliL )->cCodImp
         ( dbfTmpL )->mNumSer    := ( dbfAlbCliL )->mNumSer
         ( dbfTmpL )->( dbRUnLock() )

         ( dbfAlbCliL )->( dbSkip() )

      end while
   end if
  ( dbfTmpL )->( dbGoTop() )

return nil

//---------------------------------------------------------------------------//

function SavTik2Fac( aTik, aGet, nMode, nSave, nTotal )

   local nNumRec                 := 0
   local cSerFacCli
   local nNewFacCli
   local cSufFacCli
   local cCliFacCli
   local cNomFacCli
   local cCliTik                 := aTik[ _CCLITIK ]

   if nMode == DUPL_MODE
      aTik[ _CNUMTIK ]           := Str( nNewDoc( aTik[ _CSERTIK ], dbfTikT, "NTIKCLI", 10, dbfCount ), 10 )
      aTik[ _CSUFTIK ]           := RetSufEmp()
      aTik[ _DFECTIK ]           := GetSysDate()
      aTik[ _LSNDDOC ]           := .t.
      aTik[ _LCLOTIK ]           := .f.
   end if

   if nMode == APPD_MODE .or. nMode == DUPL_MODE .or. lApartado

      /*
      Nuevo numero de la Nueva Factura-----------------------------------------
      */

      cSerFacCli                 := aTik[ _CSERTIK ]
      nNewFacCli                 := nNewDoc( aTik [ _CSERTIK ], dbfFacCliT, "NFACCLI", , dbfCount )
      cSufFacCli                 := RetSufEmp()
      cCliFacCli                 := aTik[ _CCLITIK ]
      cNomFacCli                 := aTik[ _CNOMTIK ]

      ( dbfFacCliT )->( dbAppend() )
      ( dbfFacCliT )->cSerie     := cSerFacCli
      ( dbfFacCliT )->nNumFac    := nNewFacCli
      ( dbfFacCliT )->cSufFac    := cSufFacCli
      ( dbfFacCliT )->cTurFac    := cCurSesion()
      ( dbfFacCliT )->dFecCre    := aTik[ _DFECCRE ]
      ( dbfFacCliT )->cTimCre    := aTik[ _CTIMCRE ]
      ( dbfFacCliT )->dFecFac    := aTik[ _DFECTIK ]
      ( dbfFacCliT )->cCodUsr    := aTik[ _CCCJTIK ]
      ( dbfFacCliT )->cNumDoc    := aTik[ _CSERTIK ] + aTik[ _CNUMTIK ] + aTik[ _CSUFTIK ]
      ( dbfFacCliT )->( dbUnLock() )

      /*
      Punteros entre documentos------------------------------------------------
      */

      aTik[ _CNUMDOC ]           := aTik[ _CSERTIK ] + Str( nNewFacCli ) + aTik[ _CSUFTIK ]

   else

      cSerFacCli                 := ( dbfFacCliT )->cSerie
      nNewFacCli                 := ( dbfFacCliT )->nNumFac
      cSufFacCli                 := ( dbfFacCliT )->cSufFac
      cCliFacCli                 := aTik[ _CCLITIK ]
      cNomFacCli                 := aTik[ _CNOMTIK ]

      /*
      Posicionamos en el factura existente-------------------------------------
      */

      if ( dbfFacCliT )->( dbSeek( aTik[ _CNUMDOC ] ) )

         /*
         Rollback de los stocks------------------------------------------------
         */

         /*if dbLock( dbfFacCliT )
            oStock:FacCli( ( dbfFacCliT )->cSerie + Str( ( dbfFacCliT )->nNumFac ) + ( dbfFacCliT )->cSufFac, ( dbfFacCliT )->cCodAlm, .t., .t., .t. )
            ( dbfFacCliT )->( dbUnLock() )
         end if*/

      else

         MsgStop( "No se encuentra documento asociado" )
         return nil

      end if

   end if

   /*
   Bloqueamos para escribir en la factura--------------------------------------
   */

   if dbLock( dbfFacCliT )

      if Empty( ( dbfFacCliT )->dFecFac )
         ( dbfFacCliT )->dFecFac    := aTik[ _DFECTIK ]
      end if

      ( dbfFacCliT )->cCodAlm       := aTik[ _CALMTIK ]
      ( dbfFacCliT )->cCodCaj       := aTik[ _CNCJTIK ]
      ( dbfFacCliT )->cCodCli       := aTik[ _CCLITIK ]
      ( dbfFacCliT )->cNomCli       := aTik[ _CNOMTIK ]
      ( dbfFacCliT )->cDirCli       := aTik[ _CDIRCLI ]
      ( dbfFacCliT )->cPobCli       := aTik[ _CPOBCLI ]
      ( dbfFacCliT )->cPrvCli       := aTik[ _CPRVCLI ]
      ( dbfFacCliT )->cPosCli       := aTik[ _CPOSCLI ]
      ( dbfFacCliT )->cDniCli       := aTik[ _CDNICLI ]
      ( dbfFacCliT )->cCodPago      := aTik[ _CFPGTIK ]
      ( dbfFacCliT )->cDivFac       := aTik[ _CDIVTIK ]
      ( dbfFacCliT )->nVdvFac       := aTik[ _NVDVTIK ]
      ( dbfFacCliT )->cRetMat       := aTik[ _CRETMAT ]
      ( dbfFacCliT )->cCodAge       := aTik[ _CCODAGE ]
      ( dbfFacCliT )->cCodRut       := aTik[ _CCODRUT ]
      ( dbfFacCliT )->cCodTar       := aTik[ _CCODTAR ]
      ( dbfFacCliT )->cCodObr       := aTik[ _CCODOBR ]
      ( dbfFacCliT )->nPctComAge    := aTik[ _NCOMAGE ]
      ( dbfFacCliT )->lSndDoc       := .t.
      ( dbfFacCliT )->lIvaInc       := .t.

      ( dbfFacCliT )->( dbUnLock() )

   end if

   /*
   Ahora pasamos las lineas de detalle-----------------------------------------
   */

   ( dbfTmpL )->( dbGoTop() )
   while !( dbfTmpL )->( eof() )

      ( dbfFacCliL )->( dbAppend() )
      ( dbfFacCliL )->cSerie     := cSerFacCli
      ( dbfFacCliL )->nNumFac    := nNewFacCli
      ( dbfFacCliL )->cSufFac    := cSufFacCli
      ( dbfFacCliL )->cRef       := ( dbfTmpL    )->cCbaTil
      ( dbfFacCliL )->cDetalle   := ( dbfTmpL    )->cNomTil
      ( dbfFacCliL )->nPreUnit   := ( dbfTmpL    )->nPvpTil // Round( ( dbfTmpL )->NPVPTIL / ( 1 + ( ( dbfTmpL )->NIVATIL / 100 ) ), nDouDiv )
      ( dbfFacCliL )->nDto       := ( dbfTmpL    )->nDtoLin
      ( dbfFacCliL )->nIva       := ( dbfTmpL    )->nIvaTil
      ( dbfFacCliL )->nUniCaja   := ( dbfTmpL    )->nUntTil
      ( dbfFacCliL )->cCodPr1    := ( dbfTmpL    )->cCodPr1
      ( dbfFacCliL )->cCodPr2    := ( dbfTmpL    )->cCodPr2
      ( dbfFacCliL )->cValPr1    := ( dbfTmpL    )->cValPr1
      ( dbfFacCliL )->cValPr2    := ( dbfTmpL    )->cValPr2
      ( dbfFacCliL )->nFacCnv    := ( dbfTmpL    )->nFacCnv
      ( dbfFacCliL )->nDtoDiv    := ( dbfTmpL    )->nDtoDiv
      ( dbfFacCliL )->nCtlStk    := ( dbfTmpL    )->nCtlStk
      ( dbfFacCliL )->nValImp    := ( dbfTmpL    )->nValImp
      ( dbfFacCliL )->cCodImp    := ( dbfTmpL    )->cCodImp
      ( dbfFacCliL )->lKitPrc    := ( dbfTmpL    )->lKitPrc
      ( dbfFacCliL )->lKitArt    := ( dbfTmpL    )->lKitArt
      ( dbfFacCliL )->lKitChl    := ( dbfTmpL    )->lKitChl
      ( dbfFacCliL )->mNumSer    := ( dbfTmpL    )->mNumSer
      ( dbfFacCliL )->lIvaLin    := .t.
      ( dbfFacCliL )->( dbUnLock() )

      ( dbfTmpL )->( dbSkip() )

   end while

   //oStock:FacCli( ( dbfFacCliT )->cSerie + Str( ( dbfFacCliT )->nNumFac ) + ( dbfFacCliT )->cSufFac, ( dbfFacCliT )->cCodAlm, .f., .f., .t. )

   /*
   Rollback de los pagos-------------------------------------------------------
   */

   while ( dbfFacCliP )->( dbSeek( ( dbfFacCliT )->cSerie + Str( ( dbfFacCliT )->nNumFac ) + ( dbfFacCliT )->cSufFac ) ) .and. !( dbfFacCliP )->( eof() )

      // addRiesgo( ( dbfFacCliP )->nImporte, cCliTik, dbfClient )

      if dbLock( dbfFacCliP )
         ( dbfFacCliP )->( dbDelete() )
         ( dbfFacCliP )->( dbUnLock() )
      end if

      ( dbfFacCliP )->( dbSkip() )

   end while

   /*
   Trasbase de nuevos pagos----------------------------------------------------
   */

   ( dbfTmpP )->( dbGoTop() )
   while !( dbfTmpP )->( eof() )

      ( dbfFacCliP )->( dbAppend() )

      ( dbfFacCliP )->lCobrado   := .t. // ( RetFld( aTik[ _CFPGTIK ], dbfFPago, "nCobRec" ) == 1 )
      ( dbfFacCliP )->cSerie     := cSerFacCli
      ( dbfFacCliP )->nNumFac    := nNewFacCli
      ( dbfFacCliP )->cSufFac    := cSufFacCli
      ( dbfFacCliP )->nNumRec    := ++nNumRec
      ( dbfFacCliP )->cCodCli    := cCliFacCli
      ( dbfFacCliP )->cNomCli    := cNomFacCli
      ( dbfFacCliP )->cCodCaj    := oUser():cCaja()
      ( dbfFacCliP )->dFecCre    := GetSysDate()
      ( dbfFacCliP )->cHorCre    := SubStr( Time(), 1, 5 )
      ( dbfFacCliP )->dPreCob    := aTik[ _DFECTIK ]
      ( dbfFacCliP )->dFecVto    := aTik[ _DFECTIK ]
      ( dbfFacCliP )->cCodPgo    := aTik[ _CFPGTIK ]
      ( dbfFacCliP )->dEntrada   := ( dbfTmpP )->dPgoTik
      ( dbfFacCliP )->cDivPgo    := ( dbfTmpP )->cDivPgo
      ( dbfFacCliP )->nVdvPgo    := ( dbfTmpP )->nVdvPgo
      ( dbfFacCliP )->cPgdoPor   := ( dbfTmpP )->cPgdPor
      ( dbfFacCliP )->cTurRec    := ( dbfTmpP )->cTurPgo
      ( dbfFacCliP )->cCtaRec    := ( dbfTmpP )->cCtaRec
      ( dbfFacCliP )->nImporte   := nTotUCobTik( dbfTmpP )

      ( dbfFacCliP )->( dbUnLock() )

      ( dbfTmpP )->( dbSkip() )

      // delRiesgo( ( dbfFacCliP )->nImporte, cCliTik, dbfClient )

      nTotal                     -= ( dbfFacCliP )->nImporte

   end while

   /*
   Escribimos definitivamente en el disco--------------------------------------
   */

   WinGather( aTik, aGet, dbfTikT, oBrwDet, nMode, nil, .t. )

return ( nNewFacCli )

//---------------------------------------------------------------------------//

Static Function SavTik2Tik( aTmp, aGet, nMode, nSave )

   local aTbl
   local cNumTik

   /*
   Marca para que no se pueda volver a convertir-------------------------------
   */

   if dbDialogLock( dbfTikT )
      ( dbfTikT )->lCnvTik := .t.
      ( dbfTikT )->lSndDoc := .t.
      ( dbfTikT )->( dbUnLock() )
   end if

   /*
   Vamos a copiar el registro actual-------------------------------------------
   */

   aTbl                    := dbScatter( dbfTikT )
   cNumTik                 := Str( nNewDoc( aTbl[ _CSERTIK ], dbfTikT, "NTIKCLI", 10, dbfCount ), 10 )
   aTbl[ _CTURTIK ]        := cCurSesion()
   aTbl[ _CNUMTIK ]        := cNumTik
   aTbl[ _CSUFTIK ]        := RetSufEmp()
   aTbl[ _CTIPTIK ]        := SAVTIK
   aTbl[ _DFECTIK ]        := GetSysDate()
   aTbl[ _LSNDDOC ]        := .t.
   aTbl[ _LCLOTIK ]        := .f.

   dbGather( aTbl, dbfTikT, .t. )

   /*
   Guardamos las lineas del tiket----------------------------------------------
   */

   ( dbfTmpL )->( dbGoTop() )
   while !( dbfTmpL )->( eof() )
      aTbl                 := dbScatter( dbfTmpL )
      aTbl[ _CNUMTIL ]     := cNumTik
      aTbl[ _CSUFTIL ]     := RetSufEmp()
      aTbl[ _NUNTTIL ]     := - aTbl[ _NUNTTIL ]

      dbGather( aTbl, dbfTikL, .t. )
      ( dbfTmpL )->( dbSkip() )
   end while
   ( dbfTmpL )->( dbGoTop() )

   /*
   Ahora escribimos en el fichero definitivo los pagos-------------------------
   */

   ( dbfTmpP )->( dbGoTop() )
   while !( dbfTmpP )->( eof() )
      aTbl                 := dbScatter( dbfTmpP )
      aTbl[ _CNUMTIK ]     := cNumTik
      aTbl[ _NIMPTIK ]     := - ( aTbl[ _NIMPTIK ] - aTbl[ _NDEVTIK ] )

      dbGather( aTbl, dbfTikP, .t. )
      ( dbfTmpP )->( dbSkip() )
   end while
   ( dbfTmpP )->( dbGoTop() )

Return nil

//---------------------------------------------------------------------------//
/*
Selecciona los tikets para su envio
*/

FUNCTION SndTikCli( lMark, dbfTikT, dbfFacCliT, dbfAlbCliT )

   /*
   Marcamos el tiket
   */

   if dbDialogLock( dbfTikT )
      ( dbfTikT )->lSndDoc := lMark
      ( dbfTikT )->( dbRUnLock() )
   end if

   /*
   Marcamos los documentos asociados
   */

   do case
   case ( dbfTikT )->cTipTik == SAVFAC

      if ( dbfFacCliT )->( dbSeek( ( dbfTikT )->cNumDoc ) )

         if dbDialogLock( dbfFacCliT )
            ( dbfFacCliT )->lSndDoc := lMark
            ( dbfFacCliT )->( dbRUnLock() )
         end if

      end if

   case ( dbfTikT )->cTipTik == SAVALB

      if ( dbfAlbCliT )->( dbSeek( ( dbfTikT )->cNumDoc ) )

         if dbDialogLock( dbfAlbCliT )
            ( dbfAlbCliT )->lSndDoc := lMark
            ( dbfAlbCliT )->( dbRUnLock() )
         end if

      end if

   end case

Return nil

//---------------------------------------------------------------------------//

Static Function nChkPagTik( cNumTik, dbfTikT, dbfTikL, dbfTikP, dbfIva, dbfDiv )

   local nTot
   local nCob
   local nBmp     := 1

   if !( dbfTikT )->lPgdTik

      nTot        := nTotTik( ( dbfTikT )->cSerTik + ( dbfTikT )->cNumTik + ( dbfTikT )->cSufTik, dbfTikT, dbfTikL, dbfDiv, nil, cDivEmp(), .f. )
      nCob        := nTotCobTik( ( dbfTikT )->cSerTik + ( dbfTikT )->cNumTik + ( dbfTikT )->cSufTik, dbfTikP, dbfDiv, cDivEmp(), .f. )
      nCob        += nTotValTik( ( dbfTikT )->cSerTik + ( dbfTikT )->cNumTik + ( dbfTikT )->cSufTik, dbfTikT, dbfTikL, dbfDiv, cDivEmp(), .f. )

      do case
      case !lMayorIgual( nTot, nCob )
         nBmp     := 1
      case ( nCob > 0 )
         nBmp     := 2
      otherwise
         nBmp     := 3
      end case

   end if

return ( nBmp )

//--------------------------------------------------------------------------//

function cTipTik( cNumTik, uTikCliT )

   local cTipTik  := SAVTIK

   if ValType( uTikCliT ) == "C"

      if ( uTikCliT )->( dbSeek( cNumTik ) )
         cTipTik  := ( uTikCliT )->cTipTik
      end if

   else

      if uTikCliT:Seek( cNumTik )
         cTipTik  := uTikCliT:cTipTik
      end if

   end if

return ( cTipTik )

//--------------------------------------------------------------------------//

FUNCTION nImpLTpv( uTikT, uTikL, nDec, nRou, nVdv, cPouDiv, nPrc )

   local nCalculo

   DEFAULT nDec   := 0
   DEFAULT nRou   := 0
   DEFAULT nVdv   := 1
   DEFAULT nPrc   := 0

   nCalculo       := nTotLTpv( uTikL, nDec, nRou, nVdv, nPrc )

   do case
      case Valtype( uTikL ) == "C"
         if ( uTikL )->nIvaTil != 0
         nCalculo -= Round( nCalculo / ( 100 / ( uTikL )->nIvaTil + 1 ), nDec )
         end if
      case Valtype( uTikL ) == "O"
         if uTikL:nIvaTil != 0
         nCalculo -= Round( nCalculo / ( 100 / uTikL:nIvaTil + 1 ), nDec )
         end if
   end case

   do case
      case Valtype( uTikT ) == "C" .and. ( uTikT )->cTipTik == SAVDEV
         nCalculo := - nCalculo
      case Valtype( uTikT ) == "O" .and. uTikT:cTipTik == SAVDEV
         nCalculo := - nCalculo
   end case

RETURN ( if( cPouDiv != NIL, Trans( nCalculo, cPouDiv ), nCalculo ) )

//---------------------------------------------------------------------------//

function nTotDTikCli( cCodArt, dbfTikCliT, dbfTikCliL, cCodAlm )

   local nTotVta  := 0
   local nRecno   := ( dbfTikCliL )->( Recno() )
   local cTipTik  := cTipTik( ( dbfTikCliL )->cSerTil + ( dbfTikCliL )->cNumTil + ( dbfTikCliL )->cSufTil, dbfTikCliT )

   if ( dbfTikCliL )->( dbSeek( cCodArt ) )

      while ( dbfTikCliL )->cCbaTil == cCodArt .and. !( dbfTikCliL )->( eof() )

         if cCodAlm != nil
            if ( dbfTikCliT )->cAlmTik == cCodAlm
               if cTipTik == SAVTIK
                  nTotVta  += ( dbfTikCliL )->nUntTil
               elseif cTipTik == SAVDEV
                  nTotVta  -= ( dbfTikCliL )->nUntTil
               end if
            end if
         else
            if cTipTik == SAVTIK
               nTotVta  += ( dbfTikCliL )->nUntTil
            elseif cTipTik == SAVDEV
               nTotVta  -= ( dbfTikCliL )->nUntTil
            end if
         end if

         ( dbfTikCliL )->( dbSkip() )

      end while

   end if

   ( dbfTikCliL )->( dbGoTo( nRecno ) )

return ( nTotVta )

//---------------------------------------------------------------------------//
//
// Devuelve el total de la venta en albaranes de clientes de un articulo
//

function nTotVTikCli( cCodArt, dbfTikCliT, dbfTikCliL, nDec, nDor )

   local nTotVta  := 0
   local nRecno   := ( dbfTikCliL )->( Recno() )
   local cTipTik  := cTipTik( ( dbfTikCliL )->cSerTil + ( dbfTikCliL )->cNumTil + ( dbfTikCliL )->cSufTil, dbfTikCliT )

   if ( dbfTikCliL )->( dbSeek( cCodArt ) )

      while ( dbfTikCliL )->cCbaTil == cCodArt .and. !( dbfTikCliL )->( eof() )

         if cTipTik == SAVTIK
            nTotVta  += nTotLTpv( dbfTikCliL, nDec, nDor )
         elseif cTipTik == SAVDEV
            nTotVta  -= nTotLTpv( dbfTikCliL, nDec, nDor )
         end if

         ( dbfTikCliL )->( dbSkip() )

      end while

   end if

   ( dbfTikCliL )->( dbGoTo( nRecno ) )

return ( nTotVta )

//---------------------------------------------------------------------------//

Static Function ImpTiket( lPrev, lEntrega )

   local oPrnTik
   local nCopClient  := Max( Retfld( ( dbfTikT )->cCliTik, dbfClient, "CopiasF" ), 1 )

   DEFAULT lPrev     := .f.
   DEFAULT lEntrega  := .f.

   /*
   Obtenemos el numero de copias que vamos a imprimir
   ----------------------------------------------------------------------------
   */

   if lPrev
      nCopTik        := 1
   else
      if lCopTik
         nCopTik     := nCopiasTipoTicket( ( dbfTikT )->cTipTik, lEntrega, dbfCajT )
      end if
   end if

   /*
   Llamamos a la funcion de impresion en cada uno de los casos
   ----------------------------------------------------------------------------
   */

   do case
      case ( dbfTikT )->cTipTik == SAVTIK

         if lEntrega
            nGenTikCli( if( lPrev, IS_SCREEN, IS_PRINTER ), "Imprimiendo tickets", cFormatoEntregaEnCaja( oUser():cCaja(), dbfCajT ), cPrinterEntrega( oUser():cCaja(), dbfCajT ) )
         else
            nGenTikCli( if( lPrev, IS_SCREEN, IS_PRINTER ), "Imprimiendo tickets", cFormatoTicketEnCaja( oUser():cCaja(), dbfCajT ), cPrinterTiket( oUser():cCaja(), dbfCajT ) )
         end if

      case ( dbfTikT )->cTipTik == SAVVAL

         nGenTikCli( if( lPrev, IS_SCREEN, IS_PRINTER ), "Imprimiendo vales", cFormatoValeEnCaja( oUser():cCaja(), dbfCajT ), cPrinterVale( oUser():cCaja(), dbfCajT ) )

      case ( dbfTikT )->cTipTik == SAVDEV

         nGenTikCli( if( lPrev, IS_SCREEN, IS_PRINTER ), "Imprimiendo devoluciones", cFormatoDevolucionEnCaja( oUser():cCaja(), dbfCajT ), cPrinterDevolucion( oUser():cCaja(), dbfCajT ) )

      case ( dbfTikT )->cTipTik == SAVALB

         if lImpAlbaranesEnImpresora( ( dbfTikT )->cNcjTik, dbfCajT )

            if lPrev
               VisAlbCli( ( dbfTikT )->cNumDoc, .f., "Imprimiendo albaranes", cFormatoAlbaranEnCaja( oUser():cCaja(), dbfCajT ), cWindowsPrinterEnCaja( oUser():cCaja(), dbfCajT ) )
            else
               PrnAlbCli( ( dbfTikT )->cNumDoc, .f., "Imprimiendo albaranes", cFormatoAlbaranEnCaja( oUser():cCaja(), dbfCajT ), cWindowsPrinterEnCaja( oUser():cCaja(), dbfCajT ) )
            end if

         else
            nGenTikCli( if( lPrev, IS_SCREEN, IS_PRINTER ), "Imprimiendo albaranes", cFormatoAlbaranEnCaja( oUser():cCaja(), dbfCajT ), cPrinterAlbaran( oUser():cCaja(), dbfCajT ) )
         end if

      case ( dbfTikT )->cTipTik == SAVFAC

         if lImpFacturasEnImpresora( ( dbfTikT )->cNcjTik, dbfCajT )

            if lPrev
               VisFacCli( ( dbfTikT )->cNumDoc, .f., "Imprimiendo facturas", cFormatoFacturaEnCaja( oUser():cCaja(), dbfCajT ), cWindowsPrinterEnCaja( oUser():cCaja(), dbfCajT ) )
            else
               PrnFacCli( ( dbfTikT )->cNumDoc, .f., "Imprimiendo facturas", cFormatoFacturaEnCaja( oUser():cCaja(), dbfCajT ), cWindowsPrinterEnCaja( oUser():cCaja(), dbfCajT ) )
            end if

         else
            nGenTikCli( if( lPrev, IS_SCREEN, IS_PRINTER ), "Imprimiendo facturas", cFormatoFacturaEnCaja( oUser():cCaja(), dbfCajT ), cPrinterfactura( oUser():cCaja(), dbfCajT ) )
         end if

   end case

Return nil

//--------------------------------------------------------------------------//

static function nCopiasTipoTicket( cTipTik, lEntrega, dbfCajT )

   local nCopies  := 1

   do case
      case cTipTik == SAVTIK

        if lEntrega
           nCopies := nCopiasEntregasEnCaja( oUser():cCaja(), dbfCajT )
        else
           nCopies := nCopiasTicketsEnCaja( oUser():cCaja(), dbfCajT )
        end if

      case cTipTik == SAVVAL
         nCopies := nCopiasValesEnCaja( oUser():cCaja(), dbfCajT )

      case cTipTik == SAVDEV
         nCopies := nCopiasDevolucionesEnCaja( oUser():cCaja(), dbfCajT )

      case cTipTik == SAVALB
         nCopies := nCopiasAlbaranesEnCaja( oUser():cCaja(), dbfCajT )

      case cTipTik == SAVFAC
         nCopies := nCopiasFacturasEnCaja( oUser():cCaja(), dbfCajT )

   end case

return nCopies

//--------------------------------------------------------------------------//

static function ClkMoneda( nImporte, oGet, lInit )

   local nVal  := oGet:VarGet()

   if lInit
      nVal     := nImporte
      lInit    := .f.
   else
      nVal     += nImporte
   end if

   oGet:cText( nVal )

return nil

//--------------------------------------------------------------------------//
/*
Edita tikets de clientes desde fuera
*/

Function aTipTik( cNumTik, dbfTikT )

   local nTipTik  := 1
   local aStatus  := aGetStatus( dbfTikT, .t. )

   if ( dbfTikT )->( dbSeek( cNumTik ) )
      nTipTik     := Val( ( dbfTikT )->cTipTik )
   end if

   SetStatus( dbfTikT, aStatus )

return ( aTipDoc[ Max( nTipTik, 1 ) ] )

//----------------------------------------------------------------------------//

static function DisImg( cCodArt )

   local cFilBmp     := RetImg( cCodArt, dbfArticulo )

   cFilBmp           := cFileBmpName( cFilBmp )

   if file( cFilBmp )
      oBmpVis:Show()
      oBmpVis:ReLoad( , cFilBmp )
   else
      oBmpVis:Hide()
   end if

return ( .t. )

//---------------------------------------------------------------------------//

Static Function SelBigUser( aTmp, aGet, dbfUsr )

   if BrwBigUser( dbfUsr )

      SetBigUser( aTmp, aGet )

      Return .t.

   end if

Return .f.

//---------------------------------------------------------------------------//

Static Function SetBigUser( aTmp, aGet )

   aTmp[ _CCCJTIK ]  := oUser():cCodigo()

   if !Empty( oUser():cImagen() )
      oBtnUsuario:cBmp( cFileBmpName( oUser():cImagen() ) )
   else
      oBtnUsuario:cBmp( if( oUser():lAdministrador(), "Security_Agent_32", "Dude4_32" ) )
   end if

   oBtnUsuario:cCaption( Capitalize( oUser():cNombre() ) )

Return .t.

//---------------------------------------------------------------------------//

FUNCTION Tik2AlbFac( nTipTik, cNumDoc )

do case
   case nTipTik == "2"
      EdtAlbCli( cNumDoc )
   case nTipTik == "3"
      EdtFacCli( cNumDoc )
   otherwise
      msginfo( "No hay documento asociado", cNumDoc )
end case

return nil

//---------------------------------------------------------------------------//

STATIC FUNCTION ContTpv( dbfTikT, oBrw )

   local oDlg
   local oSerIni
   local oSerFin
   local nRecno      := ( dbfTikT )->( recno() )
   local nOrdAnt     := ( dbfTikT )->( OrdSetFocus(1) )
   local cSerIni     := ( dbfTikT )->cSerTik
   local cSerFin     := ( dbfTikT )->cSerTik
   local nDocIni     := Val( ( dbfTikT )->cNumTik )
   local nDocFin     := Val( ( dbfTikT )->cNumTik )
   local cSufIni     := ( dbfTikT )->cSufTik
   local cSufFin     := ( dbfTikT )->cSufTik
   local oChk1
   local lChk1       := .t.

   DEFINE DIALOG oDlg RESOURCE "CONTPV"

   REDEFINE GET oSerIni VAR cSerIni ;
      ID       100 ;
      PICTURE  "@!" ;
      SPINNER ;
      ON UP    ( UpSerie( oSerIni ) );
      ON DOWN  ( DwSerie( oSerIni ) );
      VALID    ( cSerIni >= "A" .and. cSerIni <= "Z" );
      UPDATE ;
      OF       oDlg

   REDEFINE GET oSerFin VAR cSerFin ;
      ID       110 ;
      PICTURE  "@!" ;
      SPINNER ;
      ON UP    ( UpSerie( oSerFin ) );
      ON DOWN  ( DwSerie( oSerFin ) );
      VALID    ( cSerFin >= "A" .and. cSerFin <= "Z" );
      UPDATE ;
      OF       oDlg

   REDEFINE GET nDocIni;
      ID       120 ;
		PICTURE 	"999999999" ;
      SPINNER ;
      COLOR    CLR_GET ;
		OF 		oDlg

   REDEFINE GET nDocFin;
      ID       130 ;
		PICTURE 	"999999999" ;
      SPINNER ;
		COLOR 	CLR_GET ;
		OF 		oDlg

   REDEFINE GET cSufIni ;
      ID       140 ;
      PICTURE  "##" ;
      COLOR    CLR_GET ;
		OF 		oDlg

   REDEFINE GET cSufFin ;
      ID       150 ;
      PICTURE  "##" ;
      COLOR    CLR_GET ;
		OF 		oDlg

   REDEFINE CHECKBOX oChk1 VAR lChk1;
      ID       160 ;
      OF       oDlg

   REDEFINE BUTTON ;
      ID       IDOK ;
		OF 		oDlg ;
      ACTION   ( oDlg:end( IDOK ) )

   REDEFINE BUTTON ;
      ID       IDCANCEL ;
		OF 		oDlg ;
      CANCEL ;
      ACTION   ( oDlg:end() )

   oDlg:AddFastKey( VK_F5, {|| oDlg:end( IDOK ) } )
   oDlg:bStart := { || oSerIni:SetFocus() }

	ACTIVATE DIALOG oDlg CENTER

   if oDlg:nResult == IDOK

      ( dbfTikT )->( dbGoTop())
      ( dbfTikT )->( ordSetFocus( 1 ) )

      ( dbfTikT )->( dbSeek( cSerIni + Str( nDocIni, 10 ) + cSufIni, .t. ) )

      while (dbfTikT)->cSerTik + (dbfTikT)->cNumTik + (dbfTikT)->cSufTik <= cSerFin + Str( nDocFin, 10 ) + cSufFin .and. !(dbfTikT)->( eof() )

         if lChk1

            if ( dbfTikT )->( dbRLock() )
               ( dbfTikT )->lConTik := .t.
               ( dbfTikT )->( dbUnlock() )
            end if

         else

            if ( dbfTikT )->( dbRLock() )
               ( dbfTikT )->lConTik := .f.
               ( dbfTikT )->( dbUnlock() )
            end if

         end if

      ( dbfTikT )->( dbSkip() )

      end while

   end if

   ( dbfTikT )->( ordSetFocus( nOrdAnt ) )
   ( dbfTikT )->( dbGoTo( nRecNo ) )

   oBrw:Refresh()

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

Function NameToField( cName )

   local cField   := {|| "" }

   cName          := AllTrim( cName )

   do case
      case cName == "Código del artículo"
         cField   := {|| ( dbfTmpL )->cCbaTil }
      case cName == "Unidades"
         cField   := {|| nTotNTpv( dbfTmpL, cPicUnd ) }
      case cName == "Propiedad 1"
         cField   := {|| If( lUsePrp1(), ( dbfTmpL )->cValPr1, '' ) }
      case cName == "Propiedad 2"
         cField   := {|| If( lUsePrp2(), ( dbfTmpL )->cValPr2, '' ) }
      case cName == "Lote"
         cField   := {|| ( dbfTmpL )->cLote }
      case cName == "Medición 1"
         cField   := {|| Trans( ( dbfTmpL )->nMedUno, MasUnd() ) }
      case cName == "Medición 2"
         cField   := {|| Trans( ( dbfTmpL )->nMedDos, MasUnd() ) }
      case cName == "Medición 3"
         cField   := {|| Trans( ( dbfTmpL )->nMedTre, MasUnd() ) }
      case cName == "Detalle"
         cField   := {|| Rtrim( ( dbfTmpL )->cNomTil ) }
      case cName == "Importe"
         cField   := {|| Trans( ( dbfTmpL )->nPvpTil, cPouDiv ) }
      case cName == "Descuento lineal"
         cField   := {|| Trans( nDtoUTpv( dbfTmpL, nDouDiv ), cPouDiv ) }
      case cName == "Descuento porcentual"
         cField   := {|| Trans( ( dbfTmpL )->nDtoLin, "@E 99.99" ) }
      case cName == "Total"
         cField   := {|| Trans( nTotLTpv( dbfTmpL, nDouDiv, nDorDiv ), cPorDiv ) }
      case cName == "Número de serie"
         cField   := {|| ( dbfTmpL )->mNumSer }
   end case

RETURN ( cField )

//---------------------------------------------------------------------------//

STATIC FUNCTION DelSerie( oWndBrw )

	local oDlg
   local oSerIni
   local oSerFin
   local oTxtDel
   local nTxtDel     := 0
   local nRecno      := ( dbfTikT )->( Recno() )
   local nOrdAnt     := ( dbfTikT )->( OrdSetFocus( 1 ) )
   local oDesde      := TDesdeHasta():Init( ( dbfTikT )->cSerTik, Val( ( dbfTikT )->cNumTik ), ( dbfTikT )->cSufTik, GetSysDate() )
   local lCancel     := .f.
   local oBtnAceptar
   local oBtnCancel

   DEFINE DIALOG oDlg ;
      RESOURCE "DELSERDOC" ;
      TITLE    "Eliminar series de tickets" ;
      OF       oWndBrw

   REDEFINE RADIO oDesde:nRadio ;
      ID       90, 91 ;
      OF       oDlg

   REDEFINE GET oSerIni VAR oDesde:cSerieInicio ;
      ID       100 ;
      PICTURE  "@!" ;
      UPDATE ;
      SPINNER ;
      ON UP    ( UpSerie( oSerIni ) );
      ON DOWN  ( DwSerie( oSerIni ) );
      WHEN     ( oDesde:nRadio == 1 );
      VALID    ( oDesde:cSerieInicio >= "A" .and. oDesde:cSerieInicio <= "Z"  );
      OF       oDlg

   REDEFINE GET oSerFin VAR oDesde:cSerieFin ;
      ID       110 ;
      PICTURE  "@!" ;
      UPDATE ;
      SPINNER ;
      ON UP    ( UpSerie( oSerFin ) );
      ON DOWN  ( DwSerie( oSerFin ) );
      WHEN     ( oDesde:nRadio == 1 );
      VALID    ( oDesde:cSerieFin >= "A" .and. oDesde:cSerieFin <= "Z"  );
      OF       oDlg

   REDEFINE GET oDesde:nNumeroInicio ;
      ID       120 ;
		PICTURE 	"999999999" ;
      SPINNER ;
      WHEN     ( oDesde:nRadio == 1 );
      OF       oDlg

   REDEFINE GET oDesde:nNumeroFin ;
      ID       130 ;
		PICTURE 	"999999999" ;
      SPINNER ;
      WHEN     ( oDesde:nRadio == 1 );
      OF       oDlg

   REDEFINE GET oDesde:cSufijoInicio ;
      ID       140 ;
      PICTURE  "##" ;
      WHEN     ( oDesde:nRadio == 1 );
      OF       oDlg

   REDEFINE GET oDesde:cSufijoFin ;
      ID       150 ;
      PICTURE  "##" ;
      WHEN     ( oDesde:nRadio == 1 );
      OF       oDlg

   REDEFINE GET oDesde:dFechaInicio ;
      ID       170 ;
      SPINNER ;
      WHEN     ( oDesde:nRadio == 2 );
      OF       oDlg

   REDEFINE GET oDesde:dFechaFin ;
      ID       180 ;
      SPINNER ;
      WHEN     ( oDesde:nRadio == 2 );
      OF       oDlg

   REDEFINE BUTTON oBtnAceptar ;
      ID       IDOK ;
		OF 		oDlg ;
      ACTION   ( DelStart( oDesde, oDlg, oBtnAceptar, oBtnCancel, oTxtDel, @lCancel ) )

   REDEFINE BUTTON oBtnCancel ;
      ID       IDCANCEL ;
		OF 		oDlg ;
      CANCEL ;
      ACTION   ( lCancel := .t., oDlg:end() )

 REDEFINE APOLOMETER oTxtDel VAR nTxtDel ;
      ID       160 ;
      NOPERCENTAGE ;
      TOTAL    ( dbfTikT )->( OrdKeyCount() ) ;
      OF       oDlg

   ACTIVATE DIALOG oDlg CENTER VALID ( lCancel )

   ( dbfTikT )->( dbGoTo( nRecNo ) )
   ( dbfTikT )->( ordSetFocus( nOrdAnt ) )

   oWndBrw:SetFocus()
   oWndBrw:Refresh()

RETURN NIL

//--------------------------------------------------------------------------//

STATIC FUNCTION DelStart( oDesde, oDlg, oBtnAceptar, oBtnCancel, oTxtDel, lCancel )

   local nOrd
   local nDeleted       := 0
   local nProcesed      := 0

   oBtnAceptar:Hide()
   oBtnCancel:bAction   := {|| lCancel := .t. }

   if oDesde:nRadio == 1

      nOrd              := ( dbfTikT )->( OrdSetFocus( "nNumTik" ) )

      ( dbfTikT )->( dbSeek( oDesde:cNumeroInicio(), .t. ) )
      while !lCancel .and. !( dbfTikT )->( eof() )

         if ( dbfTikT )->cSerTik >= oDesde:cSerieInicio              .and.;
            ( dbfTikT )->cSerTik <= oDesde:cSerieFin                 .and.;
            ( dbfTikT )->cNumTik >= Str( oDesde:nNumeroInicio, 10 )  .and.;
            ( dbfTikT )->cNumTik <= Str( oDesde:nNumeroFin, 10 )     .and.;
            ( dbfTikT )->cSufTik >= oDesde:cSufijoInicio             .and.;
            ( dbfTikT )->cSufTik <= oDesde:cSufijoFin

            ++nDeleted

            oTxtDel:cText  := "Eliminando : " + ( dbfTikT )->cSerTik + "/" + Alltrim( ( dbfTikT )->cNumTik ) + "/" + ( dbfTikT )->cSufTik

            DelTpv( nil, dbfTikT )

            //TpvDelRec( nil, .f., .f. )

         else

            ( dbfTikT )->( dbSkip() )

         end if

         ++nProcesed

         oTxtDel:Set( nProcesed )

      end do

      ( dbfTikT )->( OrdSetFocus( nOrd ) )

   else

      nOrd                 := ( dbfTikT )->( OrdSetFocus( "dFecTik" ) )

      ( dbfTikT )->( dbSeek( oDesde:dFechaInicio, .t. ) )
      while !lCancel .and. ( dbfTikT )->dFecTik <= oDesde:dFechaFin .and. !( dbfTikT )->( eof() )

         if ( dbfTikT )->dFecTik >= oDesde:dFechaInicio  .and.;
            ( dbfTikT )->dFecTik <= oDesde:dFechaFin

            ++nDeleted

            oTxtDel:cText  := "Eliminando : " + ( dbfTikT )->cSerTik + "/" + Alltrim( ( dbfTikT )->cNumTik ) + "/" + ( dbfTikT )->cSufTik

            DelTpv( nil, dbfTikT )

            //TpvDelRec( nil, .f., .f. )

         else

            ( dbfTikT )->( dbSkip() )

         end if

         ++nProcesed

         oTxtDel:Set( nProcesed )

      end do

      ( dbfTikT )->( OrdSetFocus( nOrd ) )

   end if

   lCancel              := .t.

   oBtnAceptar:Show()

   if lCancel
      msgStop( "Total de registros borrados : " + Str( nDeleted ), "Proceso cancelado" )
   else
      msgInfo( "Total de registros borrados : " + Str( nDeleted ), "Proceso finalizado" )
   end if

RETURN ( oDlg:End() )

//---------------------------------------------------------------------------//

Static Function EdtRecMenu( aTmp, oDlg )

   MENU oMenu

      MENUITEM    "&1. Rotor"

         if !lExternal

         MENU

            MENUITEM    "&1. Modificar cliente";
               MESSAGE  "Modificar la ficha del cliente" ;
               RESOURCE "User1_16" ;
               ACTION   ( if( !Empty( aTmp[ _CCLITIK ] ), EdtCli( aTmp[ _CCLITIK ] ), MsgStop( "Código cliente vacío" ) ) )

            MENUITEM    "&2. Informe de cliente";
               MESSAGE  "Abrir el informe del cliente" ;
               RESOURCE "Info16" ;
               ACTION   ( if( !Empty( aTmp[ _CCLITIK ] ), InfCliente( aTmp[ _CCLITIK ] ), MsgStop( "Código cliente vacío" ) ) );

            MENUITEM    "&3. Modificar dirección";
               MESSAGE  "Modificar ficha de la dirección" ;
               RESOURCE "Worker16" ;
               ACTION   ( if( !Empty( aTmp[ _CCLITIK ] ), EdtObras( aTmp[ _CCLITIK ], aTmp[ _CCODOBR ], dbfObrasT ), MsgStop( "No hay obra asociada para el presupuesto" ) ) )

            SEPARATOR

            MENUITEM    "&4. Modificar de artículo";
               MESSAGE  "Modificar la ficha del articulo" ;
               RESOURCE "Cube_Yellow_16";
               ACTION   ( EdtArticulo( ( dbfTmpL )->cCbaTil ) );

            MENUITEM    "&5. Informe de artículo";
               MESSAGE  "Abrir el informe del articulo" ;
               RESOURCE "Info16";
               ACTION   ( InfArticulo( ( dbfTmpL )->cCbaTil ) );

         ENDMENU

         end if

   ENDMENU

   oDlg:SetMenu( oMenu )

Return ( oMenu )

//---------------------------------------------------------------------------//

STATIC FUNCTION LqdVale( oWndBrw )

   if ( dbfTikT )->cTipTik == SAVVAL

      if !( dbfTikT )->lLiqTik

         if dbLock( dbfTikT )
            ( dbfTikT )->lLiqTik := .t.
            ( dbfTikT )->( dbUnLock() )
         end if

      else

         msgStop( "Este documento ya está liquidado." )

      end if

   else

      msgStop( "Este documento no se almacenó como vale." )

   end if

   oWndBrw:SetFocus()
   oWndBrw:Refresh()

RETURN NIL

//--------------------------------------------------------------------------//

FUNCTION AppTikCli( cCodCli, cCodArt, lOpenBrowse )

   local nLevel         := nLevelUsr( _MENUITEM_ )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) != 0 .or. nAnd( nLevel, ACC_EDIT ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if lOpenBrowse

      if FrontTpv( nil, nil, cCodCli, cCodArt )
         oWndBrw:RecAdd()
      end if

   else

      if OpenFiles( nil, .t. )
         WinAppRec( nil, bEditT, dbfTikT, cCodCli, cCodArt )
         CloseFiles()
      end if

   end if

Return .t.

//---------------------------------------------------------------------------//
/*
Edita tikets de clientes desde fuera
*/

FUNCTION EdtTikCli( nNumTik, lOpenBrowse )

   local nLevel         := nLevelUsr( _MENUITEM_ )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) != 0 .or. nAnd( nLevel, ACC_EDIT ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if lOpenBrowse

      if FrontTpv( , , , , .f. )
         if dbSeekInOrd( nNumTik, "cNumTik", dbfTikT )
            oWndBrw:RecEdit()
         else
            MsgStop( "No se encuentra ticket" )
         end if
      end if

   else

      if OpenFiles( nil, .t. )
         if dbSeekInOrd( nNumTik, "cNumTik", dbfTikT )
            nTotTik()
            WinEdtRec( nil, bEditT, dbfTikT )
         else
            MsgStop( "No se encuentra ticket" )
         end if
         CloseFiles()
      end if

   end if

Return .t.

//--------------------------------------------------------------------------//
/*
Visualiza factura de clientes desde fuera
*/

FUNCTION ZooTikCli( nNumTik, lOpenBrowse  )

   local nLevel         := nLevelUsr( _MENUITEM_ )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) != 0 .or. nAnd( nLevel, ACC_EDIT ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if lOpenBrowse

      if FrontTpv( , , , , .f. )
         if dbSeekInOrd( nNumTik, "cNumTik", dbfTikT )
            oWndBrw:RecZoom()
         else
            MsgStop( "No se encuentra ticket" )
         end if
      end if

   else

      if OpenFiles( nil, .t. )
         if dbSeekInOrd( nNumTik, "cNumTik", dbfTikT )
            nTotTik()
            WinZooRec( nil, bEditT, dbfTikT )
         else
            MsgStop( "No se encuentra ticket" )
         end if
         CloseFiles()
      end if

   end if

RETURN NIL

//--------------------------------------------------------------------------//
/*
Elimina factura de clientes desde fuera
*/

FUNCTION DelTikCli( nNumTik, lOpenBrowse )

   local nLevel         := nLevelUsr( _MENUITEM_ )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) != 0 .or. nAnd( nLevel, ACC_EDIT ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if lOpenBrowse

      if FrontTpv( , , , , .f. )
         if dbSeekInOrd( nNumTik, "cNumTik", dbfTikT )
            //oWndBrw:RecDel()
            DelTpv( oWndBrw:oBrw, dbfTikT )
         else
            MsgStop( "No se encuentra ticket" )
         end if
      end if

   else

      if OpenFiles( nil, .t. )
         if dbSeekInOrd( nNumTik, "cNumTik", dbfTikT )
            nTotTik()
            //TpvDelRec()
            DelTpv( nil, dbfTikT )
         else
            MsgStop( "No se encuentra ticket" )
         end if
         CloseFiles()
      end if

   end if

RETURN NIL

//--------------------------------------------------------------------------//
/*
Imprime Tiktura de clientes desde fuera
*/

FUNCTION PrnTikCli( nNumTik, lOpenBrowse  )

   local nLevel         := nLevelUsr( _MENUITEM_ )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) != 0 .or. nAnd( nLevel, ACC_EDIT ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if lOpenBrowse

      if FrontTpv( , , , , .f. )
         if dbSeekInOrd( nNumTik, "cNumTik", dbfTikT )
            ImpTiket( .f. )
         else
            MsgStop( "No se encuentra ticket" )
         end if
      end if

   else

      if OpenFiles( nil, .t. )
         if dbSeekInOrd( nNumTik, "cNumTik", dbfTikT )
            nTotTik()
            ImpTiket( .f. )
         else
            MsgStop( "No se encuentra ticket" )
         end if
         CloseFiles()
      end if

   end if

RETURN NIL

//--------------------------------------------------------------------------//
/*
Imprime Tiktura de clientes desde fuera
*/

FUNCTION VisTikCli( nNumTik, lOpenBrowse  )

   local nLevel         := nLevelUsr( _MENUITEM_ )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) != 0 .or. nAnd( nLevel, ACC_EDIT ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if lOpenBrowse

      if FrontTpv( , , , , .f. )
         if dbSeekInOrd( nNumTik, "cNumTik", dbfTikT )
            ImpTiket( .t. )
         else
            MsgStop( "No se encuentra ticket" )
         end if
      end if

   else

      if OpenFiles( nil, .t. )
         if dbSeekInOrd( nNumTik, "cNumTik", dbfTikT )
            nTotTik()
            ImpTiket( .t. )
         else
            MsgStop( "No se encuentra ticket" )
         end if
         CloseFiles()
      end if

   end if

RETURN NIL

//---------------------------------------------------------------------------//

Function EdtCobTikCli( nNumTik, lOpenBrowse )

   local nLevel         := nLevelUsr( _MENUITEM_ )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) != 0 .or. nAnd( nLevel, ACC_EDIT ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   Sysrefresh()

   if OpenFiles( nil, .t. )
      if dbSeekInOrd( nNumTik, "cNumTik", dbfTikT )
         EdtCobTik()
      else
         MsgStop( "No se encuentra ticket" )
      end if
      CloseFiles()
   end if

   Sysrefresh()

Return .t.

//--------------------------------------------------------------------------//

static function lFacturaAlbaran()

   if ( dbfTikT )->cTipTik == SAVALB
      if !RetFld( ( dbfTikT )->cNumDoc, dbfAlbCliT, "lFacturado" )
         FactCli( nil, nil, { "Albaran" => ( dbfTikT )->cNumDoc } )
      else
         msgStop( "El albarán ya ha sido facturado" )
      end if
   else
      msgStop( "Sólo se pueden generar facturas desde albaranes" )
   end if

Return ( .t. )

//---------------------------------------------------------------------------//

Static Function Recalcula( aTmp )

   local nRec

   /*
   Recalcula los precios-------------------------------------------------------
   */

   nRec        := ( dbfTmpL )->( Recno() )

   ( dbfTmpL )->( dbGoTop() )
   while !( dbfTmpL )->( eof() )

      if lValLine( dbfTmpL ) .and. !( dbfTmpL )->lFreTil

         if dbSeekInOrd( ( dbfTmpL )->cCbaTil, "CodeBar", dbfArticulo ) .or.;
            dbSeekInOrd( ( dbfTmpL )->cCbaTil, "Codigo", dbfArticulo )

            ( dbfTmpL )->nPvpTil    := nRetPreArt( aTmp[ _NTARIFA ], aTmp[ _CDIVTIK ], .t., dbfArticulo, dbfDiv, dbfKit, dbfIva, .t. )

         end if

      end if

      (  dbfTmpL )->( dbskip() )

   end while

   ( dbfTmpL )->( dbGoTo( nRec ) )

   lRecTotal( aTmp )

   oBrwDet:Refresh()

Return .t.

//---------------------------------------------------------------------------//

Static Function AppendKit( uTmpLin, aTik )

   local cCodArt
   local cSerTil
   local cNumTil
   local cSufTil
   local cAlmLin
   local nUntTil
   local nIvaTil
   local nNumLin

   if ValType( uTmpLin ) == "A"
      cCodArt                       := uTmpLin[ _CCBATIL ]
      cSerTil                       := uTmpLin[ _CSERTIL ]
      cNumTil                       := uTmpLin[ _CNUMTIL ]
      cSufTil                       := uTmpLin[ _CSUFTIL ]
      nNumLin                       := uTmpLin[ _NNUMLIN ]
      cAlmLin                       := uTmpLin[ _CALMLIN ]
      nUntTil                       := uTmpLin[ _NUNTTIL ]
      nIvaTil                       := uTmpLin[ _NIVATIL ]
   else
      cCodArt                       := ( uTmpLin )->cCbaTil
      cSerTil                       := ( uTmpLin )->cSerTil
      cNumTil                       := ( uTmpLin )->cNumTil
      cSufTil                       := ( uTmpLin )->cSufTil
      nNumLin                       := ( uTmpLin )->nNumLin
      cAlmLin                       := ( uTmpLin )->cAlmLin
      nUntTil                       := ( uTmpLin )->nUntTil
      nIvaTil                       := ( uTmpLin )->nIvaTil
   end if

   if  ( dbfKit )->( dbSeek( cCodArt ) )

      while ( dbfKit )->cCodKit == cCodArt .and. !( dbfKit )->( eof() )

         if ( dbfArticulo )->( dbSeek( ( dbfKit )->cRefKit ) )

            ( dbfTmpL )->( dbAppend() )

            ( dbfTmpL )->cSerTil    := cSerTil
            ( dbfTmpL )->cNumTil    := cNumTil
            ( dbfTmpL )->cSufTil    := cSufTil
            ( dbfTmpL )->nNumLin    := nNumLin
            ( dbfTmpL )->cAlmLin    := cAlmLin
            ( dbfTmpL )->nUntTil    := nUntTil * ( dbfKit )->nUndKit

            ( dbfTmpL )->cCbaTil    := ( dbfKit      )->cRefKit
            ( dbfTmpL )->cNomTil    := ( dbfArticulo )->Nombre
            ( dbfTmpL )->cFamTil    := ( dbfArticulo )->Familia
            ( dbfTmpL )->lTipAcc    := ( dbfArticulo )->lTipAccº
            ( dbfTmpL )->nCtlStk    := ( dbfArticulo )->nCtlStock
            ( dbfTmpL )->cCodImp    := ( dbfArticulo )->cCodImp
            ( dbfTmpL )->nMesGrt    := ( dbfarticulo )->nMesGrt

            ( dbfTmpL )->nValImp    := oNewImp:nValImp( ( dbfArticulo )->cCodImp, .t., nIvaTil )
            ( dbfTmpL )->nCosDiv    := nCosto( nil, dbfArticulo, dbfKit )
            ( dbfTmpL )->nPvpTil    := nRetPreArt( aTik[ _NTARIFA ], aTik[ _CDIVTIK ], .t., dbfArticulo, dbfDiv, dbfKit, dbfIva, .t. )

            /*
            Estudio de los tipos de " + cImp() + " si el padre el cero todos cero------
            */

            if !Empty( nIvaTil )
               ( dbfTmpL )->nIvaTil := nIva( dbfIva, ( dbfArticulo )->TipoIva )
            else
               ( dbfTmpL )->nIvaTil := 0
            end if

            /*
            Propiedades de los kits-----------------------------------------
            */

            ( dbfTmpL )->lKitChl    := !lKitAsociado( cCodArt, dbfArticulo )
            ( dbfTmpL )->lImpLin    := lImprimirComponente( cCodArt, dbfArticulo )   // 1 Todos, 2 Compuesto, 3 Componentes
            ( dbfTmpL )->lKitPrc    := lPreciosComponentes( cCodArt, dbfArticulo )   // 1 Todos, 2 Compuesto, 3 Componentes

            if lStockComponentes( cCodArt, dbfArticulo )
               ( dbfTmpL )->nCtlStk := ( dbfArticulo )->nCtlStock
            else
               ( dbfTmpL )->nCtlstk := STOCK_NO_CONTROLAR // No controlar Stock
            end if

            if ( dbfArticulo )->lKitArt
               AppendKit( dbfTmpL, aTik )
            end if

         end if

         ( dbfKit )->( dbSkip() )

      end while

   end if

Return ( nil )

//---------------------------------------------------------------------------//

FUNCTION nTotValLiq( cNumTik, dbfTikT, dbfTikL, dbfDiv, aTmp, cDivRet, lPic, lExcCnt )

   local nRec  := ( dbfTikT )->( Recno() )

   local nTik  := nTotTik( cNumTik, dbfTikT, dbfTikL, dbfDiv, aTmp, cDivRet, lPic, lExcCnt )
   local nVal  := nTotTik( ( dbfTikT )->cValDoc, dbfTikT, dbfTikL, dbfDiv, aTmp, cDivRet, lPic, lExcCnt )

   ( dbfTikT )->( dbGoTo( nRec ) )

Return ( Min( nTik, nVal ) )

//---------------------------------------------------------------------------//

FUNCTION IsTpv( cPath )

   DEFAULT cPath  := cPatEmp()

   if !lExistTable( cPath + "TIKET.DBF" )
      dbCreate( cPath + "TIKET.DBF", aSqlStruct( aItmTik() ), cDriver() )
   end if

   if !lExistTable( cPath + "TIKEL.DBF" )
      dbCreate( cPath + "TIKEL.DBF", aSqlStruct( aColTik() ), cDriver() )
   end if

   if !lExistTable( cPath + "TIKEP.DBF" )
      dbCreate( cPath + "TIKEP.DBF", aSqlStruct( aPgoTik() ), cDriver() )
   end if

   if !lExistTable( cPath + "TIKEC.DBF" )
      dbCreate( cPath + "TIKEC.DBF", aSqlStruct( aPgoCli() ), cDriver() )
   end if

   if !lExistIndex( cPath + "TIKET.Cdx" ) .or. ;
      !lExistIndex( cPath + "TIKEL.Cdx" ) .or. ;
      !lExistIndex( cPath + "TIKEP.Cdx" ) .or. ;
      !lExistTable( cPath + "TIKEC.Cdx" )

      rxTpv( cPath )

   end if

Return ( nil )

//---------------------------------------------------------------------------//

Static Function ClickEntrega( aTmp, aGet, oDlgTpv )

   /*
   Vamos a comprobar q hay algo q guardar--------------------------------------
   */

   if ( dbfTmpL )->( LastRec() ) != 0

      aTmp[ _LABIERTO ] := .f.

      /*
      Guardamos el tiket de manera normal--------------------------------------
      */

      if GuardaVenta( aTmp, aGet )

         /*
         Paramos a la ventana-----------------------------------------------------
         */

         oDlgTpv:Disable()

         /*
         Proceso de impresion-----------------------------------------------------
         */

         ImpTiket( .f., .t. )

         /*
         Ponemos en marcha la ventana---------------------------------------------
         */

         oDlgTpv:Enable()

         /*
         Titulo de la ventana-----------------------------------------------------
         */

         cTitleDialog( aTmp )

      end if

   end if

Return ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS TotalesTPV

   Method Init()

   Method lValeMayorTotal()   Inline   ( ( ::nVale <= ::nTotal ) .or. ( ::nTotal < 0 ) )

   Data  nTotal
   Data  nTotalDivisa
   Data  nEntregado
   Data  nEntregadoDivisa
   Data  nCobrado
   Data  nVale
   Data  nAnticipo
   Data  nCobradoDivisa
   Data  nCambio
   Data  nCambioDivisa

   Data  oTotal
   Data  oTotalDivisa
   Data  oEntregado
   Data  oEntregadoDivisa
   Data  oCobrado
   Data  oCobradoDivisa
   Data  oCambio
   Data  oCambioDivisa

END CLASS

Method Init() CLASS TotalesTPV

   ::nTotal             := 0
   ::nTotalDivisa       := 0
   ::nCobrado           := 0
   ::nVale              := 0
   ::nAnticipo          := 0
   ::nEntregado         := 0
   ::nEntregadoDivisa   := 0
   ::nCobrado           := 0
   ::nCobradoDivisa     := 0
   ::nCambio            := 0
   ::nCambioDivisa      := 0

   ::oTotal             := nil
   ::oTotalDivisa       := nil
   ::oEntregado         := nil
   ::oEntregadoDivisa   := nil
   ::oCobrado           := nil
   ::oCobradoDivisa     := nil
   ::oCambio            := nil
   ::oCambioDivisa      := nil

Return ( Self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS TTiketsClientesSenderReciver FROM TSenderReciverItem

   Method CreateData()

   Method RestoreData()

   Method SendData()

   Method ReciveData()

   Method Process()

END CLASS

//----------------------------------------------------------------------------//

Method CreateData() CLASS TTiketsClientesSenderReciver

   local lSnd        := .f.
   local dbfTikT
   local dbfTikL
   local dbfTikP
   local tmpTikT
   local tmpTikL
   local tmpTikP
   local cFileName   := "TikCli" + StrZero( ::nGetNumberToSend(), 6 ) + "." + RetSufEmp()

   ::oSender:SetText( "Enviando tikets de clientes" )

   USE ( cPatEmp() + "TIKET.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIKET", @dbfTikT ) )
   SET ADSINDEX TO ( cPatEmp() + "TIKET.CDX" ) ADDITIVE
   SET TAG TO "lSndDoc"

   USE ( cPatEmp() + "TIKEL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIKEL", @dbfTikL ) )
   SET ADSINDEX TO ( cPatEmp() + "TIKEL.CDX" ) ADDITIVE

   USE ( cPatEmp() + "TIKEP.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIKEP", @dbfTikP ) )
   SET ADSINDEX TO ( cPatEmp() + "TIKEP.CDX" ) ADDITIVE

   /*
   Creamos todas las bases de datos relacionadas con Articulos
   */

   MkTpv( cPatSnd() )

   USE ( cPatSnd() + "TIKET.DBF" ) NEW VIA ( cDriver() )ALIAS ( cCheckArea( "TIKET", @tmpTikT ) )
   SET ADSINDEX TO ( cPatSnd() + "TIKET.CDX" ) ADDITIVE

   USE ( cPatSnd() + "TIKEL.DBF" ) NEW VIA ( cDriver() )ALIAS ( cCheckArea( "TIKEL", @tmpTikL ) )
   SET ADSINDEX TO ( cPatSnd() + "TIKEL.CDX" ) ADDITIVE

   USE ( cPatSnd() + "TIKEP.DBF" ) NEW VIA ( cDriver() )ALIAS ( cCheckArea( "TIKEP", @tmpTikP ) )
   SET ADSINDEX TO ( cPatSnd() + "TIKEP.CDX" ) ADDITIVE

   if !Empty( ::oSender:oMtr )
      ::oSender:oMtr:nTotal := ( dbfTikT )->( OrdKeyCount() )
   end if

   if ( dbfTikT )->( dbSeek( .t. ) )

      while ( dbfTikT )->lSndDoc .and. !( dbfTikT )->( eof() )

         lSnd  := .t.

         dbPass( dbfTikT, tmpTikT, .t. )
         ::oSender:SetText( ( dbfTikT )->cSerTik + "/" + AllTrim( ( dbfTikT )->cNumTik ) + "/" + AllTrim( ( dbfTikT )->cSufTik ) + "; " + Dtoc( ( dbfTikT )->dFecTik ) + "; " + AllTrim( ( dbfTikT )->cCliTik ) + "; " + ( dbfTikT )->cNomTik )

         /*
         Lineas de detalle
         */

         if ( dbfTikL )->( dbSeek( ( dbfTikT )->cSerTik + ( dbfTikT )->cNumTik + ( dbfTikT )->cSufTik ) )
            while ( dbfTikT )->cSerTik + ( dbfTikT )->cNumTik + ( dbfTikT )->cSufTik == ( dbfTikL )->CSERTIL + ( dbfTikL )->CNUMTIL + ( dbfTikL )->CSUFTIL .AND. !( dbfTikL )->( eof() )
               dbPass( dbfTikL, tmpTikL, .t. )
               ( dbfTikL )->( dbSkip() )
            end do
         end if

         /*
         Lineas de pago
         */

         if ( dbfTikP )->( dbSeek( ( dbfTikT )->cSerTik + ( dbfTikT )->cNumTik + ( dbfTikT )->cSufTik ) )
            while ( dbfTikT )->cSerTik + ( dbfTikT )->cNumTik + ( dbfTikT )->cSufTik == ( dbfTikP )->cSerTik + ( dbfTikP )->cNumTik + ( dbfTikP )->cSufTik .AND. !( dbfTikP )->( eof() )
               dbPass( dbfTikP, tmpTikP, .t. )
               ( dbfTikP )->( dbSkip() )
            end do
         end if

         ( dbfTikT )->( dbSkip() )

         if !Empty( ::oSender:oMtr )
            ::oSender:oMtr:Set( ( dbfTikT )->( OrdKeyNo() ) )
         end if

      end do

   end if

   /*
   Cerrar ficheros temporales--------------------------------------------------
   */

   CLOSE ( tmpTikT )
   CLOSE ( tmpTikL )
   CLOSE ( tmpTikP )
   CLOSE ( dbfTikT )
   CLOSE ( dbfTikL )
   CLOSE ( dbfTikP )

   if lSnd

      ::oSender:SetText( "Comprimiendo tikets de clientes" )

      if ::oSender:lZipData( cFileName )
         ::oSender:SetText( "Ficheros comprimidos" )
      else
         ::oSender:SetText( "ERROR al crear fichero comprimido" )
      end if

   else

      ::oSender:SetText( "No hay registros tikets para enviar" )

   end if

Return ( Self )

//----------------------------------------------------------------------------//

Method RestoreData() CLASS TTiketsClientesSenderReciver

   local dbfTikT

   if ::lSuccesfullSend

      /*
      Retorna el valor anterior---------------------------------------------------
      */

      USE ( cPatEmp() + "TIKET.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIKET", @dbfTikT ) )
      SET ADSINDEX TO ( cPatEmp() + "TIKET.CDX" ) ADDITIVE
      ( dbfTikT )->( OrdSetFocus( "lSndDoc" ) )

      while ( dbfTikT )->( dbSeek( .t. ) ) .and. !( dbfTikT )->( eof() )
         if ( dbfTikT )->( dbRLock() )
            ( dbfTikT )->lSndDoc := .f.
            ( dbfTikT )->( dbRUnlock() )
         end if
      end do

      CLOSE ( dbfTikT )

   end if

Return ( Self )

//----------------------------------------------------------------------------//

Method SendData() CLASS TTiketsClientesSenderReciver

   local cFileName   := "TikCli" + StrZero( ::nGetNumberToSend(), 6 ) + "." + RetSufEmp()

   if file( cPatOut() + cFileName )

      if ::oSender:SendFiles( cPatOut() + cFileName, cFileName )
         ::lSuccesfullSend := .t.
         ::IncNumberToSend()
         ::oSender:SetText( "Fichero enviado " + cFileName )
      else
         ::oSender:SetText( "ERROR al enviar fichero" )
      end if

   end if

Return ( Self )

//----------------------------------------------------------------------------//

Method ReciveData() CLASS TTiketsClientesSenderReciver

   local n
   local aExt        := aRetDlgEmp()

   /*
   Recibirlo de internet
   */

   ::oSender:SetText( "Recibiendo tikets de clientes" )

   for n := 1 to len( aExt )
      ::oSender:GetFiles( "TikCli*." + aExt[ n ], cPatIn() )
   next

   ::oSender:SetText( "Tickets de clientes recibidos" )

Return Self

//----------------------------------------------------------------------------//

Method Process() CLASS TTiketsClientesSenderReciver

   local m
   local oStock
   local tmpTikT
   local tmpTikL
   local tmpTikP
   local dbfDiv
   local dbfTikT
   local dbfTikL
   local dbfTikP
   local dbfClient
   local nTotTik
   local nTotTikOld
   local nTotTikNew
   local oBlock
   local oError
   local aFiles      := Directory( cPatIn() + "TikCli*.*" )

   /*
   Recibirlo de internet
   */

   ::oSender:SetText( "Importando tikets de clientes" )

   for m := 1 TO len( aFiles )

      ::oSender:SetText( "Procesando fichero : " + aFiles[ m, 1 ] )

      oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )

      BEGIN SEQUENCE

      /*
      descomprimimos el fichero------------------------------------------------
      */

      if ::oSender:lUnZipData( cPatIn() + aFiles[ m, 1 ] )

         /*
         Ficheros temporales
         */

         if lExistTable( cPatSnd() + "TIKET.DBF" ) .and.;
            lExistTable( cPatSnd() + "TIKEL.DBF" ) .and.;
            lExistTable( cPatSnd() + "TIKEP.DBF" )

            USE ( cPatEmp() + "TIKET.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIKET", @dbfTikT ) )
            SET ADSINDEX TO ( cPatEmp() + "TIKET.CDX" ) ADDITIVE

            USE ( cPatEmp() + "TIKEL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIKEL", @dbfTikL ) )
            SET ADSINDEX TO ( cPatEmp() + "TIKEL.CDX" ) ADDITIVE

            USE ( cPatEmp() + "TIKEP.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIKEP", @dbfTikP ) )
            SET ADSINDEX TO ( cPatEmp() + "TIKEP.CDX" ) ADDITIVE

            USE ( cPatCli() + "CLIENT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CLIENT", @dbfClient ) )
            SET ADSINDEX TO ( cPatCli() + "CLIENT.CDX" ) ADDITIVE

            USE ( cPatDat() + "DIVISAS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "DIVISAS", @dbfDiv ) )
            SET ADSINDEX TO ( cPatDat() + "DIVISAS.CDX" ) ADDITIVE

            USE ( cPatSnd() + "TIKET.DBF" ) NEW VIA ( cDriver() )READONLY ALIAS ( cCheckArea( "TIKET", @tmpTikT ) )
            SET ADSINDEX TO ( cPatSnd() + "TIKET.CDX" ) ADDITIVE

            USE ( cPatSnd() + "TIKEL.DBF" ) NEW VIA ( cDriver() )READONLY ALIAS ( cCheckArea( "TIKEL", @tmpTikL ) )
            SET ADSINDEX TO ( cPatSnd() + "TIKEL.CDX" ) ADDITIVE

            USE ( cPatSnd() + "TIKEP.DBF" ) NEW VIA ( cDriver() )READONLY ALIAS ( cCheckArea( "TIKEP", @tmpTikP ) )
            SET ADSINDEX TO ( cPatSnd() + "TIKEP.CDX" ) ADDITIVE

            oStock            := TStock():New()
            oStock:cTikT      := dbfTikT
            oStock:cTikL      := dbfTikL

            if !Empty( ::oSender:oMtr )
               ::oSender:oMtr:nTotal := ( tmpTikT )->( lastrec() )
            end if

            while !( tmpTikT )->( eof() )

               if lValidaOperacion( ( tmpTikT )->dFecTik, .f. )

                  /*
                  Si existe el tiket lo reemplazamos------------------------------
                  */

                  if ( dbfTikT )->( dbSeek( ( tmpTikT )->cSerTik + ( tmpTikT )->cNumTik + ( tmpTikT )->cSufTik ) )

                     dbPass( tmpTikT, dbfTikT, .f. )

                     ::oSender:SetText( "Reemplazado : " + ( dbfTikT )->cSerTik + "/" + AllTrim( ( dbfTikT )->cNumTik ) + "/" + AllTrim( ( dbfTikT )->cSufTik ) + "; " + Dtoc( ( dbfTikT )->dFecTik ) + "; " + AllTrim( ( dbfTikT )->cCliTik ) + "; " + ( dbfTikT )->cNomTik )

                     /*
                     Rollback de articulos y stocks-------------------------------
                     */

                     //oStock:TpvCli( ( tmpTikT )->cSerTik + ( tmpTikT )->cNumTik + ( tmpTikT )->cSufTik, ( tmpTikT )->cAlmTik, .t. )

                     nTotTikNew := nTotTik( ( tmpTikT )->cSerTik + ( tmpTikT )->cNumTik + ( tmpTikT )->cSufTik, tmpTikT, tmpTikL, dbfDiv )
                     nTotTikOld := nTotTik( ( dbfTikT )->cSerTik + ( dbfTikT )->cNumTik + ( dbfTikT )->cSufTik, dbfTikT, dbfTikL, dbfDiv )

                     // AddRiesgo( nTotTikNew - nTotTikOld, ( dbfTikT )->cCliTik, dbfClient )

                     /*
                     Eliminamos las lineas----------------------------------------
                     */

                     while ( dbfTikL )->( dbSeek( ( tmpTikT )->cSerTik + ( tmpTikT )->cNumTik + ( tmpTikT )->cSufTik ) )
                        if dbLock( dbfTikL )
                           ( dbfTikL )->( dbDelete() )
                           ( dbfTikL )->( dbUnLock() )
                        end if
                     end while

                     /*
                     Borramos los pagos----------------------------------------------------
                     */

                     while ( dbfTikP )->( dbSeek( ( tmpTikT )->cSerTik + ( tmpTikT )->cNumTik + ( tmpTikT )->cSufTik ) )

                        if dbLock( dbfTikP )
                           ( dbfTikP )->( dbDelete() )
                           ( dbfTikP )->( dbUnLock() )
                        end if
                     end while

                  else

                     dbPass( tmpTikT, dbfTikT, .t. )
                     ::oSender:SetText( "Añadido : " + ( dbfTikT )->cSerTik + "/" + AllTrim( ( dbfTikT )->cNumTik ) + "/" + AllTrim( ( dbfTikT )->cSufTik ) + "; " + Dtoc( ( dbfTikT )->dFecTik ) + "; " + AllTrim( ( dbfTikT )->cCliTik ) + "; " + ( dbfTikT )->cNomTik )

                     nTotTik := nTotTik( ( tmpTikT )->cSerTik + ( tmpTikT )->cNumTik + ( tmpTikT )->cSufTik, tmpTikT, tmpTikL, dbfDiv )

                     // AddRiesgo( nTotTik, ( tmpTikT )->cCliTik, dbfClient )

                  end if

                  /*
                  Ahora vamos a borrar las lineas
                  */

                  while ( dbfTikL )->( dbSeek( ( tmpTikT )->cSerTik + ( tmpTikT )->cNumTik + ( tmpTikT )->cSufTik ) )
                     if ( dbfTikL )->( dbRLock() )
                        ( dbfTikL )->( dbDelete() )
                     end if
                  end while

                  /*
                  Ahora vamos con las lienas de detalle
                  */

                  if ( tmpTikL )->( dbSeek( ( tmpTikT )->cSerTik + ( tmpTikT )->cNumTik + ( tmpTikT )->cSufTik ) )
                     while ( tmpTikT )->cSerTik + ( tmpTikT )->cNumTik + ( tmpTikT )->cSufTik == ( tmpTikL )->cSerTil + ( tmpTikL )->cNumTil + ( tmpTikL )->cSufTil .and. !( tmpTikL )->( eof() )
                        dbPass( tmpTikL, dbfTikL, .t. )
                        ( tmpTikL )->( dbSkip() )
                     end do
                  end if

                  /*
                  Comprobamos si existen pago y los eliminamos
                  */

                  while ( dbfTikP )->( dbSeek( ( tmpTikT )->cSerTik + ( tmpTikT )->cNumTik + ( tmpTikT )->cSufTik ) )
                     // AddRiesgo( nTotUCobTik( dbfTikP ), ( tmpTikT )->cCliTik, dbfClient )
                     if ( dbfTikP )->( dbRLock() )
                        ( dbfTikP )->( dbDelete() )
                     end if
                  end while

                  /*
                  Trasbase de nuevos pagos
                  */

                  if ( tmpTikP )->( dbSeek( ( tmpTikT )->cSerTik + ( tmpTikT )->cNumTik + ( tmpTikT )->cSufTik ) )
                     while ( tmpTikT )->cSerTik + ( tmpTikT )->cNumTik + ( tmpTikT )->cSufTik == ( tmpTikP )->cSerTik + ( tmpTikP )->cNumTik + ( tmpTikP )->cSufTik .and. !( tmpTikP )->( eof() )
                        dbPass( tmpTikP, dbfTikP, .t. )
                        // DelRiesgo( nTotUCobTik( tmpTikP ), ( tmpTikT )->cCliTik, dbfClient )
                        ( tmpTikP )->( dbSkip() )
                     end do
                  end if

                  /*
                  Actualizamos los Stocks
                  */

                  //oStock:TpvCli( ( tmpTikT )->cSerTik + ( tmpTikT )->cNumTik + ( tmpTikT )->cSufTik, ( tmpTikT )->cAlmTik, .f. )

               end if

               ( tmpTikT )->( dbSkip() )

               if !Empty( ::oSender:oMtr )
                  ::oSender:oMtr:Set( ( tmpTikT )->( OrdKeyNo() ) )
               end if

               SysRefresh()

            end do

            if !Empty( ::oSender:oMtr )
               ::oSender:oMtr:nTotal := ( tmpTikT )->( lastrec() )
            end if

            /*
            Finalizando--------------------------------------------------------------
            */

            CLOSE ( dbfTikT   )
            CLOSE ( dbfTikL   )
            CLOSE ( dbfTikP   )
            CLOSE ( dbfClient )
            CLOSE ( dbfDiv    )
            CLOSE ( tmpTikT   )
            CLOSE ( tmpTikL   )
            CLOSE ( tmpTikP   )

            oStock:end()

            fErase( cPatSnd() + "TikeT.Dbf" )
            fErase( cPatSnd() + "TikeL.Dbf" )
            fErase( cPatSnd() + "TikeP.Dbf" )

            ::oSender:AppendFileRecive( aFiles[ m, 1 ] )

         else

            ::oSender:SetText( "Faltan ficheros" )

            if !lExistTable( cPatSnd() + "TikeT.Dbf" )
               ::oSender:SetText( "Falta " + cPatSnd() + "TikeT.Dbf" )
            end if

            if !lExistTable( cPatSnd() + "TikeL.Dbf" )
               ::oSender:SetText( "Falta " + cPatSnd() + "TikeL.Dbf" )
            end if

            if !lExistTable( cPatSnd() + "TikeP.Dbf" )
               ::oSender:SetText( "Falta " + cPatSnd() + "TikeP.Dbf" )
            end if

         end if

      end if

      RECOVER USING oError

         CLOSE ( dbfTikT   )
         CLOSE ( dbfTikL   )
         CLOSE ( dbfTikP   )
         CLOSE ( dbfClient )
         CLOSE ( dbfDiv    )
         CLOSE ( tmpTikT   )
         CLOSE ( tmpTikL   )
         CLOSE ( tmpTikP   )

         ::oSender:SetText( "Error procesando fichero " + aFiles[ m, 1 ] )
         ::oSender:SetText( ErrorMessage( oError ) )

      END SEQUENCE

      ErrorBlock( oBlock )

   next

Return Self

//----------------------------------------------------------------------------//

Static Function GenTikCli( nDevice, cCaption, cCodDoc, cPrinter )

   local oDevice
   local cNumTik

   if ( dbfTikT )->( Lastrec() ) == 0
      return nil
   end if

   cNumTik              := ( dbfTikT )->cSerTik + ( dbfTikT )->cNumTik + ( dbfTikT )->cSufTik

   DEFAULT nDevice      := IS_PRINTER
   DEFAULT cCaption     := "Imprimiendo tickets a clientes"
   DEFAULT cCodDoc      := cFormatoTicketEnCaja( oUser():cCaja(), dbfCajT )
   DEFAULT cPrinter     := cWindowsPrinterEnCaja( oUser():cCaja(), dbfCajT )

   if Empty( cCodDoc )
      cCodDoc           := cFormatoTicketEnCaja( oUser():cCaja(), dbfCajT )
   end if

   if !lExisteDocumento( cCodDoc, dbfDoc )
      return nil
   end if

   /*
   Si el documento es de tipo visual-------------------------------------------
   */

   PrintReportTikCli( nDevice, 1, cPrinter, dbfDoc )

   /*
   Codigo de corte de papel----------------------------------------------------
   */

   cCortePapelEnCaja( oUser():cCaja(), dbfCajT )

Return .f.

//----------------------------------------------------------------------------//

Static Function nGenTikCli( nDevice, cCaption, cCodDoc, cPrinter )

   local nImpYet     := 0

   While nImpYet < nCopTik

      if nImpYet < 1 .or. ApoloMsgNoYes( "¿Desea imprimir el tiket Nº" + Str( nImpYet + 1, 2 ) + "?", "Elija una opción" )

         GenTikCli( nDevice, cCaption, cCodDoc, cPrinter )

      end if

      ++nImpYet

   end do

return nil

//----------------------------------------------------------------------------//

#include "FastRepH.ch"

Static Function DataReport( oFr )

   /*
   Zona de datos------------------------------------------------------------
   */

   oFr:ClearDataSets()

   oFr:SetWorkArea(     "Tickets", ( dbfTikT )->( Select() ), .f., { FR_RB_CURRENT, FR_RB_CURRENT, 0 } )
   oFr:SetFieldAliases( "Tickets", cItemsToReport( aItmTik() ) )

   oFr:SetWorkArea(     "Lineas de tickets", ( dbfTikL )->( Select() ) )
   oFr:SetFieldAliases( "Lineas de tickets", cItemsToReport( aColTik() ) )

   oFr:SetWorkArea(     "Lineas de albaranes", ( dbfAlbCliL )->( Select() ) )
   oFr:SetFieldAliases( "Lineas de albaranes", cItemsToReport( aColAlbCli() ) )

   oFr:SetWorkArea(     "Lineas de facturas", ( dbfFacCliL )->( Select() ) )
   oFr:SetFieldAliases( "Lineas de facturas", cItemsToReport( aColFacCli() ) )

   oFr:SetWorkArea(     "Pagos de tickets", ( dbfTikP )->( Select() ) )
   oFr:SetFieldAliases( "Pagos de tickets", cItemsToReport( aPgoTik() ) )

   oFr:SetWorkArea(     "Empresa", ( dbfEmp )->( Select() ) )
   oFr:SetFieldAliases( "Empresa", cItemsToReport( aItmEmp() ) )

   oFr:SetWorkArea(     "Clientes", ( dbfClient )->( Select() ) )
   oFr:SetFieldAliases( "Clientes", cItemsToReport( aItmCli() ) )

   oFr:SetWorkArea(     "Obras", ( dbfObrasT )->( Select() ) )
   oFr:SetFieldAliases( "Obras",  cItemsToReport( aItmObr() ) )

   oFr:SetWorkArea(     "Almacenes", ( dbfAlm )->( Select() ) )
   oFr:SetFieldAliases( "Almacenes", cItemsToReport( aItmAlm() ) )

   oFr:SetWorkArea(     "Rutas", ( dbfRuta )->( Select() ) )
   oFr:SetFieldAliases( "Rutas", cItemsToReport( aItmRut() ) )

   oFr:SetWorkArea(     "Agentes", ( dbfAgent )->( Select() ) )
   oFr:SetFieldAliases( "Agentes", cItemsToReport( aItmAge() ) )

   oFr:SetWorkArea(     "Formas de pago", ( dbfFpago )->( Select() ) )
   oFr:SetFieldAliases( "Formas de pago", cItemsToReport( aItmFPago() ) )

   oFr:SetWorkArea(     "Usuarios", ( dbfUsr )->( Select() ) )
   oFr:SetFieldAliases( "Usuarios", cItemsToReport( aItmUsuario() ) )

   oFr:SetMasterDetail( "Tickets", "Lineas de tickets",  {|| ( dbfTikT )->cSerTik + ( dbfTikT )->cNumTik + ( dbfTikT )->cSufTik } )
   oFr:SetMasterDetail( "Tickets", "Lineas de albaranes",{|| ( dbfTikT )->cNumDoc } )
   oFr:SetMasterDetail( "Tickets", "Lineas de facturas", {|| ( dbfTikT )->cNumDoc } )
   oFr:SetMasterDetail( "Tickets", "Pagos de tickets",   {|| ( dbfTikT )->cSerTik + ( dbfTikT )->cNumTik + ( dbfTikT )->cSufTik } )
   oFr:SetMasterDetail( "Tickets", "Empresa",            {|| cCodigoEmpresaEnUso() } )
   oFr:SetMasterDetail( "Tickets", "Clientes",           {|| ( dbfTikT )->cCliTik } )
   oFr:SetMasterDetail( "Tickets", "Obras",              {|| ( dbfTikT )->cCliTik + ( dbfTikT )->cCodObr } )
   oFr:SetMasterDetail( "Tickets", "Almacen",            {|| ( dbfTikT )->cAlmTik } )
   oFr:SetMasterDetail( "Tickets", "Rutas",              {|| ( dbfTikT )->cCodRut } )
   oFr:SetMasterDetail( "Tickets", "Agentes",            {|| ( dbfTikT )->cCodAge } )
   oFr:SetMasterDetail( "Tickets", "Formas de pago",     {|| ( dbfTikT )->cFpgTik } )
   oFr:SetMasterDetail( "Tickets", "Usuarios",           {|| ( dbfTikT )->cCcjTik } )

   oFr:SetResyncPair(   "Tickets", "Lineas de tickets" )
   oFr:SetResyncPair(   "Tickets", "Lineas de albaranes" )
   oFr:SetResyncPair(   "Tickets", "Lineas de facturas" )
   oFr:SetResyncPair(   "Tickets", "Pagos de tickets" )
   oFr:SetResyncPair(   "Tickets", "Empresa" )
   oFr:SetResyncPair(   "Tickets", "Clientes" )
   oFr:SetResyncPair(   "Tickets", "Obras" )
   oFr:SetResyncPair(   "Tickets", "Almacenes" )
   oFr:SetResyncPair(   "Tickets", "Rutas" )
   oFr:SetResyncPair(   "Tickets", "Agentes" )
   oFr:SetResyncPair(   "Tickets", "Formas de pago" )
   oFr:SetResyncPair(   "Tickets", "Usuarios" )

Return nil

//---------------------------------------------------------------------------//

Static Function VariableReport( oFr )

   oFr:DeleteCategory(  "Tickets" )
   oFr:DeleteCategory(  "Lineas de tickets" )
   oFr:DeleteCategory(  "Lineas de albaranes" )
   oFr:DeleteCategory(  "Lineas de facturas" )

   /*
   Creación de variables----------------------------------------------------
   */

   oFr:AddVariable(     "Tickets",             "Total ticket",                      "GetHbVar('nTotTik')" )
   oFr:AddVariable(     "Tickets",             "Total neto",                        "GetHbVar('nTotNet')" )
   oFr:AddVariable(     "Tickets",             "Total " + cImp(),                         "GetHbVar('nTotIva')" )
   oFr:AddVariable(     "Tickets",             "Total IVM",                         "GetHbVar('nTotIvm')" )
   oFr:AddVariable(     "Tickets",             "Total albarán",                     "GetHbVar('nTotAlb')" )
   oFr:AddVariable(     "Tickets",             "Total factura",                     "GetHbVar('nTotFac')" )
   oFr:AddVariable(     "Tickets",             "Precio por pax.",                   "GetHbVar('nTotPax')" )
   oFr:AddVariable(     "Tickets",             "Base primer tipo de " + cImp(),           "GetHbArrayVar('aBasTik',1)" )
   oFr:AddVariable(     "Tickets",             "Base segundo tipo de " + cImp(),          "GetHbArrayVar('aBasTik',2)" )
   oFr:AddVariable(     "Tickets",             "Base tercer tipo de " + cImp(),           "GetHbArrayVar('aBasTik',3)" )
   oFr:AddVariable(     "Tickets",             "Porcentaje primer tipo " + cImp(),        "GetHbArrayVar('aIvaTik',1)" )
   oFr:AddVariable(     "Tickets",             "Porcentaje segundo tipo " + cImp(),       "GetHbArrayVar('aIvaTik',2)" )
   oFr:AddVariable(     "Tickets",             "Porcentaje tercer tipo " + cImp(),        "GetHbArrayVar('aIvaTik',3)" )
   oFr:AddVariable(     "Tickets",             "Importe primer tipo " + cImp(),           "GetHbArrayVar('aImpTik',1)" )
   oFr:AddVariable(     "Tickets",             "Importe segundo tipo " + cImp(),          "GetHbArrayVar('aImpTik',2)" )
   oFr:AddVariable(     "Tickets",             "Importe tercer tipo " + cImp(),           "GetHbArrayVar('aImpTik',3)" )
   oFr:AddVariable(     "Tickets",             "Importe primer tipo IVMH",          "GetHbArrayVar('aIvmTik',1)" )
   oFr:AddVariable(     "Tickets",             "Importe segundo tipo IVMH",         "GetHbArrayVar('aIvmTik',2)" )
   oFr:AddVariable(     "Tickets",             "Importe tercer tipo IVMH",          "GetHbArrayVar('aIvmTik',3)" )

   oFr:AddVariable(     "Lineas de tickets",   "Total unidades artículo",                       "CallHbFunc('nTotNTpv')" )
   oFr:AddVariable(     "Lineas de tickets",   "Precio unitario del artículo",                  "CallHbFunc('nTotUTpv')" )
   oFr:AddVariable(     "Lineas de tickets",   "Precio unitario con descuentos",                "CallHbFunc('nNetLTpv')" )
   oFr:AddVariable(     "Lineas de tickets",   "Importe descuento línea del factura",           "CallHbFunc('nDtoUTpv')" )
   oFr:AddVariable(     "Lineas de tickets",   "Total " + cImp() + " línea de factura",                    "CallHbFunc('nIvaLTpv')" )
   oFr:AddVariable(     "Lineas de tickets",   "Total IVMH línea de factura",                   "CallHbFunc('nIvmLTpv')" )
   oFr:AddVariable(     "Lineas de tickets",   "Total línea de factura",                        "CallHbFunc('nTotLTpv')" )

   oFr:AddVariable(     "Lineas de albaranes", "Detalle del artículo del albarán",              "CallHbFunc('cTpvDesAlbCli')"  )
   oFr:AddVariable(     "Lineas de albaranes", "Total unidades artículo del albarán",           "CallHbFunc('nTpvTotNAlbCli')" )
   oFr:AddVariable(     "Lineas de albaranes", "Precio unitario del artículo del albarán",      "CallHbFunc('nTpvTotUAlbCli')" )
   oFr:AddVariable(     "Lineas de albaranes", "Total línea de albarán",                        "CallHbFunc('nTpvTotLAlbCli')" )

   oFr:AddVariable(     "Lineas de facturas",  "Detalle del artículo de la factura",            "CallHbFunc('cTpvDesFacCli')" )
   oFr:AddVariable(     "Lineas de facturas",  "Total unidades artículo de la factura",         "CallHbFunc('nTpvTotNFacCli')" )
   oFr:AddVariable(     "Lineas de facturas",  "Precio unitario del artículo de la factura",    "CallHbFunc('nTpvTotUFacCli')" )
   oFr:AddVariable(     "Lineas de facturas",  "Total línea de factura.",                       "CallHbFunc('nTpvTotLFacCli')" )

Return nil

//---------------------------------------------------------------------------//

Function DesignReportTikCli( oFr, dbfDoc )

   if OpenFiles()

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
         oFr:SetProperty(     "Report.ScriptText", "Text",;
                                                   + ;
                                                   "procedure DetalleOnMasterDetail(Sender: TfrxComponent);"   + Chr(13) + Chr(10) + ;
                                                   "begin"                                                     + Chr(13) + Chr(10) + ;
                                                   "CallHbFunc('nTotalizer');"                                 + Chr(13) + Chr(10) + ;
                                                   "end;"                                                      + Chr(13) + Chr(10) + ;
                                                   "begin"                                                     + Chr(13) + Chr(10) + ;
                                                   "end." )

         oFr:AddPage(         "MainPage" )

         oFr:AddBand(         "CabeceraDocumento", "MainPage", frxPageHeader )
         oFr:SetProperty(     "CabeceraDocumento", "Top", 0 )
         oFr:SetProperty(     "CabeceraDocumento", "Height", 200 )

         oFr:AddBand(         "MasterData",  "MainPage", frxMasterData )
         oFr:SetProperty(     "MasterData",  "Top", 200 )
         oFr:SetProperty(     "MasterData",  "Height", 0 )
         oFr:SetProperty(     "MasterData",  "StartNewPage", .t. )
         oFr:SetObjProperty(  "MasterData",  "DataSet", "Tickets" )

         oFr:AddBand(         "DetalleColumnas",   "MainPage", frxDetailData  )
         oFr:SetProperty(     "DetalleColumnas",   "Top", 230 )
         oFr:SetProperty(     "DetalleColumnas",   "Height", 28 )
         oFr:SetObjProperty(  "DetalleColumnas",   "DataSet", "Lineas de Tickets" )
         oFr:SetProperty(     "DetalleColumnas",   "OnMasterDetail", "DetalleOnMasterDetail" )

         oFr:AddBand(         "PieDocumento",      "MainPage", frxPageFooter )
         oFr:SetProperty(     "PieDocumento",      "Top", 930 )
         oFr:SetProperty(     "PieDocumento",      "Height", 110 )

      end if

      /*
      Zona de variables--------------------------------------------------------
      */

      VariableReport( oFr )

      /*
      Diseño de report---------------------------------------------------------
      */

      oFr:DesignReport()

      /*
      Destruye el diseñador----------------------------------------------------
      */

      oFr:DestroyFr()

      /*
      Cierra ficheros----------------------------------------------------------
      */

      CloseFiles()

   else

      Return .f.

   end if

Return .t.

//---------------------------------------------------------------------------//

Function PrintReportTikCli( nDevice, nCopies, cPrinter, dbfDoc )

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
      Zona de variables--------------------------------------------------------
      */

      VariableReport( oFr )

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
            oFr:DoExport( "PDFExport" )

      end case

   end if

   /*
   Destruye el diseñador-------------------------------------------------------
   */

   oFr:DestroyFr()

Return .t.

//---------------------------------------------------------------------------//
/*
Funciones que llaman a funciones de albaranes y facturas
creadas para que se poder llamarlas desde fuera, ya que
para los formatos no podemos llamarlas con parámetros.
*/

function cTpvDesAlbCli()
return cDesAlbCli( dbfAlbCliL )

//---------------------------------------------------------------------------//

function nTpvTotNAlbCli()
return nTotNAlbCli( dbfAlbCliL )

//---------------------------------------------------------------------------//

function nTpvTotUAlbCli()
return nTotUAlbCli( dbfAlbCliL )

//---------------------------------------------------------------------------//

function nTpvTotLAlbCli()
return nTotLAlbCli( dbfAlbCliL )

//---------------------------------------------------------------------------//

function cTpvDesFacCli()
return cDesFacCli( dbfFacCliL )

//---------------------------------------------------------------------------//

function nTpvTotNFacCli()
return nTotNFacCli( dbfFacCliL )

//---------------------------------------------------------------------------//

function nTpvTotUFacCli()
return nTotUFacCli( dbfFacCliL )

//---------------------------------------------------------------------------//

function nTpvTotLFacCli()
return nTotLFacCli( dbfFacCliL )

//---------------------------------------------------------------------------//

Static Function nNumeroFamilias()

   local nRegistrosMostrar := ( dbfFamilia )->( ordKeyCount() )
   nRegistrosMostrar       -= ( dbfFamilia )->( ordKeyNo() )
   nRegistrosMostrar++

   // Si tenemos ya boton anterior necesitamos un boton mas--------------------

   if len( aRecFam ) > 1
      nRegistrosMostrar++
   end if

   // Si deseamos mostrar mas botones q espacios tenemos lo corregimos---------

   if nRegistrosMostrar > nNumBtnFam
      nRegistrosMostrar    := nNumBtnFam - 1
   end if

Return ( nRegistrosMostrar )

//---------------------------------------------------------------------------//

Static Function lMostrarFamilias()

   local lMostrarFamilias  := .f.
   local nRegistrosMostrar := 0

   if ( dbfFamilia )->( ordKeyNo() ) != 0
      lMostrarFamilias     := ( ( dbfFamilia )->( ordKeyCount() ) - ( dbfFamilia )->( ordKeyNo() ) > 0 )
   end if

Return ( lMostrarFamilias )

//---------------------------------------------------------------------------//

Static Function AddFreeProduct()

   local oDlg
   local oFnt              := TFont():New( FONT_NAME, 12, 32, .f., .t. )
   local oGetDescripcion
   local cGetDescripcion   := Space( 100 )
   local oGetUnidades
   local nGetUnidades      := 1
   local oGetImporte
   local nGetImporte       := 0

   DEFINE DIALOG oDlg RESOURCE "Libre" FONT oFnt

      REDEFINE GET oGetDescripcion ;
         VAR      cGetDescripcion ;
         ID       100 ;
         OF       oDlg

      REDEFINE BUTTONBMP ;
         ID       110 ;
         OF       oDlg ;
         BITMAP   "Keyboard2_32" ;
         ACTION   ( VirtualKey( .f., oGetDescripcion ) )

      REDEFINE GET oGetUnidades ;
         VAR      nGetUnidades ;
         PICTURE  cPicUnd ;
         ID       120 ;
         OF       oDlg

      REDEFINE BUTTONBMP ;
         ID       130 ;
         OF       oDlg ;
         BITMAP   "Calculator_32" ;
         ACTION   ( Calculadora( 0, oGetUnidades ) )

      REDEFINE GET oGetImporte ;
         VAR      nGetImporte ;
         PICTURE  cPorDiv ;
         ID       140 ;
         OF       oDlg

      REDEFINE BUTTONBMP ;
         ID       150 ;
         OF       oDlg ;
         BITMAP   "Calculator_32" ;
         ACTION   ( Calculadora( 0, oGetImporte ) )

      REDEFINE BUTTON ;
         ID       IDOK ;
         OF       oDlg ;
         ACTION   ( lValidAddFreeProduct( oGetDescripcion, oDlg ) )

      REDEFINE BUTTON ;
         ID       IDCANCEL ;
         OF       oDlg ;
         ACTION   ( oDlg:End() )

   ACTIVATE DIALOG oDlg CENTER

   if ( oDlg:nResult == IDOK )

      ( dbfTmpL )->( dbAppend() )
      if !( dbfTmpL )->( NetErr() )
         ( dbfTmpL )->cNomTil := cGetDescripcion
         ( dbfTmpL )->nUntTil := nGetUnidades
         ( dbfTmpL )->nPvpTil := nGetImporte
         ( dbfTmpL )->nIvaTil := nIva( dbfIva, cDefIva() )
         ( dbfTmpL )->cAlmLin := oUser():cAlmacen()
      end if

      if !Empty( oBrwDet )
         oBrwDet:Refresh()
      end if

   end if

   oFnt:End()

Return ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

Static Function lValidAddFreeProduct( oGetDescripcion, oDlg )

   if Empty( oGetDescripcion:VarGet() )
      MsgStop( "Descripción no puede estar vacia" )
      Return .f.
   end if

   oDlg:End( IDOK )

Return .t.

//---------------------------------------------------------------------------//

Static Function RenombrarUbicacion( aTmp, aGet )

   local cNombreUbicacion  := VirtualKey( .f., aTmp[ _CALIASTIK ], "Renombrar ubicación" )

   if !Empty( cNombreUbicacion )

      aTmp[ _CALIASTIK ]   := cNombreUbicacion

      cTitleDialog( aTmp )

   end if

Return .t.

//---------------------------------------------------------------------------//

Static Function EdtEnt( aTmp, aGet, dbfTmpE, oBrw, bWhen, bValid, nMode, aTmpTik )

   local oDlg
   local oBmpDiv
   local cPorDiv

   DEFAULT aTmpTik   := dbScatter( dbfTikT )

   do case
      case nMode == APPD_MODE

         aTmp[ ( dbfTmpE )->( FieldPos( "cTurRec" ) ) ]   := cCurSesion()
         aTmp[ ( dbfTmpE )->( FieldPos( "cCodCaj" ) ) ]   := oUser():cCaja()
         aTmp[ ( dbfTmpE )->( FieldPos( "cCodCli" ) ) ]   := aTmpTik[ _CCLITIK ]
         aTmp[ ( dbfTmpE )->( FieldPos( "cCodAge" ) ) ]   := aTmpTik[ _CCODAGE ]
         aTmp[ ( dbfTmpE )->( FieldPos( "cDivPgo" ) ) ]   := aTmpTik[ _CDIVTIK ]
         aTmp[ ( dbfTmpE )->( FieldPos( "cCodPgo" ) ) ]   := aTmpTik[ _CFPGTIK ]

      case nMode == EDIT_MODE

         if aTmp[ ( dbfTmpE )->( FieldPos( "lCloPgo" ) ) ] .and. !oUser():lAdministrador()
            msgStop( "Solo pueden modificar las entregas cerradas los administradores." )
            return .f.
         end if

   end case

   cPorDiv           := cPorDiv(aTmp[ ( dbfTmpE )->( FieldPos( "cDivPgo" ) ) ], dbfDiv )

   DEFINE DIALOG oDlg RESOURCE "ENTREGAS" TITLE LblTitle( nMode ) + "entrega a cuenta"

      REDEFINE GET aGet[ ( dbfTmpE )->( FieldPos( "nImporte" ) ) ];
         VAR      aTmp[ ( dbfTmpE )->( FieldPos( "nImporte" ) ) ] ;
         ID       160 ;
         PICTURE  ( cPorDiv ) ;
         OF       oDlg

      REDEFINE GET aGet[ ( dbfTmpE )->( FieldPos( "cDivPgo" ) ) ] ;
         VAR      aTmp[ ( dbfTmpE )->( FieldPos( "cDivPgo" ) ) ];
         WHEN     ( .f. ) ;
         VALID    ( cDivOut( aGet[ ( dbfTmpE )->( FieldPos( "cDivPgo" ) ) ], oBmpDiv, aGet[ ( dbfTmpE )->( FieldPos( "nVdvPgo" ) ) ], nil, nil, @cPorDiv, nil, nil, nil, nil, dbfDiv, oBandera ) );
         PICTURE  "@!";
         ID       150 ;
         BITMAP   "LUPA" ;
         ON HELP  BrwDiv( aGet[ ( dbfTmpE )->( FieldPos( "cDivPgo" ) ) ], oBmpDiv, aGet[ ( dbfTmpE )->( FieldPos( "nVdvPgo" ) ) ], dbfDiv, oBandera ) ;
         OF       oDlg

      REDEFINE BITMAP oBmpDiv ;
         RESOURCE "BAN_EURO" ;
         ID       151;
         OF       oDlg

      REDEFINE GET aGet[ ( dbfTmpE )->( FieldPos( "cCodPgo" ) ) ] ;
         VAR      aTmp[ ( dbfTmpE )->( FieldPos( "cCodPgo" ) ) ] ;
         ID       180 ;
         IDTEXT   181 ;
         COLOR    CLR_GET ;
			PICTURE  "@!" ;
         VALID    ( cFPago( aGet[ ( dbfTmpE )->( FieldPos( "cCodPgo" ) ) ], dbfFPago, aGet[ ( dbfTmpE )->( FieldPos( "cCodPgo" ) ) ]:oHelpText ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwFPago( aGet[ ( dbfTmpE )->( FieldPos( "cCodPgo" ) ) ], aGet[ ( dbfTmpE )->( FieldPos( "cCodPgo" ) ) ]:oHelpText ) ) ;
         OF       oDlg

      REDEFINE GET aGet[ ( dbfTmpE )->( FieldPos( "dEntrega" ) ) ] ;
         VAR      aTmp[ ( dbfTmpE )->( FieldPos( "dEntrega" ) ) ] ;
         ID       100 ;
         SPINNER ;
         ON HELP  aGet[ ( dbfTmpE )->( FieldPos( "dEntrega" ) ) ]:cText( Calendario( aTmp[ ( dbfTmpE )->( FieldPos( "dEntrega" ) ) ] ) ) ;
         BITMAP   "LUPA" ;
			OF 		oDlg

      REDEFINE GET aGet[ ( dbfTmpE )->( FieldPos( "cCodCli" ) ) ] ;
         VAR      aTmp[ ( dbfTmpE )->( FieldPos( "cCodCli" ) ) ] ;
         ID       110 ;
         IDTEXT   111 ;
         VALID    ( cClient( aGet[ ( dbfTmpE )->( FieldPos( "cCodCli" ) ) ], dbfClient, aGet[ ( dbfTmpE )->( FieldPos( "cCodCli" ) ) ]:oHelpText ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwClient( aGet[ ( dbfTmpE )->( FieldPos( "cCodCli" ) ) ], aGet[ ( dbfTmpE )->( FieldPos( "cCodCli" ) ) ]:oHelpText ) ) ;
         OF       oDlg

      REDEFINE GET aGet[ ( dbfTmpE )->( FieldPos( "cCodAge" ) ) ];
         VAR      aTmp[ ( dbfTmpE )->( FieldPos( "cCodAge" ) ) ] ;
         ID       120 ;
         IDTEXT   121 ;
         VALID    ( cAgentes( aGet[ ( dbfTmpE )->( FieldPos( "cCodAge" ) ) ], dbfAgent, aGet[ ( dbfTmpE )->( FieldPos( "cCodAge" ) ) ]:oHelpText ) );
         BITMAP   "LUPA" ;
         ON HELP  ( BrwAgentes( aGet[ ( dbfTmpE )->( FieldPos( "cCodAge" ) ) ], aGet[ ( dbfTmpE )->( FieldPos( "cCodAge" ) ) ]:oHelpText ) );
         OF       oDlg

      REDEFINE GET aGet[ ( dbfTmpE )->( FieldPos( "cDescrip" ) ) ] ;
         VAR      aTmp[ ( dbfTmpE )->( FieldPos( "cDescrip" ) ) ] ;
         ID       130 ;
			OF 		oDlg

      REDEFINE GET aGet[ ( dbfTmpE )->( FieldPos( "cPgdoPor" ) ) ];
         VAR      aTmp[ ( dbfTmpE )->( FieldPos( "cPgdoPor" ) ) ] ;
         ID       140 ;
			OF 		oDlg

      REDEFINE GET aGet[ ( dbfTmpE )->( FieldPos( "cCodCaj" ) ) ] ;
         VAR      aTmp[ ( dbfTmpE )->( FieldPos( "cCodCaj" ) ) ];
         ID       170 ;
         IDTEXT   171 ;
         VALID    cCajas( aGet[ ( dbfTmpE )->( FieldPos( "cCodCaj" ) ) ], dbfCajT, aGet[ ( dbfTmpE )->( FieldPos( "cCodCaj" ) ) ]:oHelpText ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwCajas( aGet[ ( dbfTmpE )->( FieldPos( "cCodCaj" ) ) ], aGet[ ( dbfTmpE )->( FieldPos( "cCodCaj" ) ) ]:oHelpText ) ) ;
         OF       oDlg

      REDEFINE BUTTON ;
         ID       IDOK ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( ValidEdtEnt( aTmp, aGet, oBrw, oDlg, nMode, dbfTmpE ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
         CANCEL ;
         ACTION   ( oDlg:End() )

   if nMode != ZOOM_MODE
      oDlg:AddFastKey( VK_F5, {|| ValidEdtEnt( aTmp, aGet, oBrw, oDlg, nMode, dbfTmpE ) } )
   end if

   oDlg:bStart    := {|| StartRec( aGet, aTmp ) }

   ACTIVATE DIALOG oDlg CENTER

   oBandera:End()
   oBmpDiv:End()

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

Static Function ValidEdtEnt( aTmp, aGet, oBrw, oDlg, nMode, dbfTmpE )

   if nMode == APPD_MODE
      aTmp[ ( dbfTmpE )->( FieldPos( "nNumRec" ) ) ]   := ( dbfTmpE )->( RecNo() ) + 1
   end if

   WinGather( aTmp, aGet, dbfTmpE, oBrw, nMode )

   oDlg:End( IDOK )

Return .t.

//---------------------------------------------------------------------------//

static function StartRec( aGet, aTmp )

   aGet[ ( dbfTmpE )->( FieldPos( "nImporte" ) ) ]:SetFocus()

   aGet[ ( dbfTmpE )->( FieldPos( "cCodPgo" ) ) ]:oHelpText:cText( RetFld( aTmp[ ( dbfTmpE )->( FieldPos( "cCodPgo" ) ) ], dbfFPago, "cDesPago" ) )
   aGet[ ( dbfTmpE )->( FieldPos( "cCodCli" ) ) ]:oHelpText:cText( RetFld( aTmp[ ( dbfTmpE )->( FieldPos( "cCodCli" ) ) ], dbfClient, "Titulo" ) )
   aGet[ ( dbfTmpE )->( FieldPos( "cCodCaj" ) ) ]:oHelpText:cText( RetFld( aTmp[ ( dbfTmpE )->( FieldPos( "cCodCaj" ) ) ], dbfCajT, "cNomCaj" ) )
   aGet[ ( dbfTmpE )->( FieldPos( "cCodAge" ) ) ]:oHelpText:cText( cNbrAgent( aTmp[ ( dbfTmpE )->( FieldPos( "cCodAge" ) ) ], dbfAgent ) )

return .t.

//---------------------------------------------------------------------------//

Static Function CrearDescuento( dbfTmpL, oBrwDet )

   local oDlg
   local nRec
   local oBtnUnaLinea
   local oBtnTodasLineas
   local oGetPorcentaje
   local nGetPorcentaje := 10
   local oFnt           := TFont():New( FONT_NAME, 14, 46, .f., .t. )

   DEFINE DIALOG oDlg RESOURCE "DTO_TCT"

      oBtnUnaLinea      := TBtnBmp():ReDefine( 100, "Row_32",,,,,{|| oBtnUnaLinea:GoDown(), oBtnTodasLineas:GoUp() }, oDlg, .f., , .f. )

      oBtnTodasLineas   := TBtnBmp():ReDefine( 110, "Row_All_32",,,,,{|| oBtnUnaLinea:GoUp(), oBtnTodasLineas:GoDown() }, oDlg, .f., , .f. )

      REDEFINE BUTTON ;
         ID       200 ;
         OF       oDlg ;
         ACTION   ( oGetPorcentaje:cText( 10 ) )

      REDEFINE BUTTON ;
         ID       210 ;
         OF       oDlg ;
         ACTION   ( oGetPorcentaje:cText( 20 ) )

      REDEFINE BUTTON ;
         ID       220 ;
         OF       oDlg ;
         ACTION   ( oGetPorcentaje:cText( 30 ) )

      REDEFINE BUTTON ;
         ID       230 ;
         OF       oDlg ;
         ACTION   ( oGetPorcentaje:cText( 40 ) )

      REDEFINE BUTTON ;
         ID       240 ;
         OF       oDlg ;
         ACTION   ( oGetPorcentaje:cText( 50 ) )

      REDEFINE BUTTONBMP ;
         ID       300 ;
         OF       oDlg ;
         BITMAP   "Navigate_Plus_32" ;
         ACTION   ( oGetPorcentaje++ )

      REDEFINE BUTTONBMP ;
         ID       310 ;
         OF       oDlg ;
         BITMAP   "Navigate_Minus_32" ;
         ACTION   ( oGetPorcentaje-- )

      REDEFINE GET oGetPorcentaje ;
         VAR      nGetPorcentaje ;
         ID       320 ;
         FONT     oFnt ;
         SPINNER ;
         MIN      0 ;
         MAX      100 ;
         PICTURE  "@E 999.99";
         OF       oDlg ;

   oDlg:bStart    := {|| oBtnUnaLinea:GoDown() }

   ACTIVATE DIALOG oDlg CENTER

   if oDlg:nResult == IDOK

      if oBtnUnaLinea:lPressed

         ( dbfTmpL )->nDtoLin := nGetPorcentaje

      else

         nRec     := ( dbfTmpL )->( Recno() )

         ( dbfTmpL )->( dbGoTop() )
         while !( dbfTmpL )->( Eof() )
            ( dbfTmpL )->nDtoLin := nGetPorcentaje
            ( dbfTmpL )->( dbSkip() )
         end while

         ( dbfTmpL )->( dbGoTo( nRec ) )

      end if

   end if

   oFnt:end()

   if !Empty( oBrwDet )
      oBrwDet:Refresh()
   end if

Return ( nil )

//---------------------------------------------------------------------------//

Static Function CrearInvitacion( dbfTmpL, oBrwDet )

   local oDlg
   local nRec
   local oBtnUnaLinea
   local oBtnTodasLineas
   local oBtnCancel
   local oImgInv
   local oLstInv

   DEFINE DIALOG oDlg RESOURCE "INV_TCT"

      oBtnTodasLineas   := TBtnBmp():ReDefine( 100, "Row_All_32",,,,,{|| oBtnUnaLinea:GoUp(), oBtnTodasLineas:GoDown() }, oDlg, .f., , .f. )

      oBtnUnaLinea      := TBtnBmp():ReDefine( 110, "Row_32",,,,,{|| oBtnUnaLinea:GoDown(), oBtnTodasLineas:GoUp() }, oDlg, .f., , .f. )

      oImgInv           := TImageList():New( 48, 48 )
      oLstInv           := TListView():Redefine( 120, oDlg )
      oLstInv:nOption   := 0
      oLstInv:bClick    := {| nOpt | EndInvitacion( nOpt, oLstInv, oBtnUnaLinea, dbfTmpL, oInvitacion:oDbf:cAlias, oDlg ) }

      REDEFINE BUTTONBMP oBtnCancel ;
         ID       550 ;
         OF       oDlg ;
         BITMAP   "Delete2_48" ;
         ACTION   ( oDlg:End() )

      oDlg:bStart       := {|| oBtnTodasLineas:GoDown() }

   ACTIVATE DIALOG oDlg ;
    ON INIT     ( InitInvitaciones( oDlg, oImgInv, oLstInv ) ) ;
    CENTER

   if !Empty( oBrwDet )
      oBrwDet:Refresh()
   end if

Return ( nil )

//---------------------------------------------------------------------------//

Static Function EndInvitacion( nOpt, oLstInv, oBtnUnaLinea, dbfTmpL, dbfInv, oDlg )

   local nRec

   if nOpt == 0

      msgStop( "Debe seleccionar una opción válida." )

   else

      if ( dbfInv )->( OrdKeyGoTo( nOpt ) )

         if oBtnUnaLinea:lPressed

            if ( dbfInv )->lPreInv
               ( dbfTmpL )->nPvpTil    := ( dbfInv )->nPreInv
            else
               ( dbfTmpL )->nPvpTil    := 0
            end if

            ( dbfTmpL )->nPcmTil       := 0
            ( dbfTmpL )->cCodInv       := ( dbfInv )->cCodInv

         else

            nRec     := ( dbfTmpL )->( Recno() )

            ( dbfTmpL )->( dbGoTop() )
            while !( dbfTmpL )->( Eof() )

               if ( dbfInv )->lPreInv
                  ( dbfTmpL )->nPvpTil := ( dbfInv )->nPreInv
               else
                  ( dbfTmpL )->nPvpTil := 0
               end if

               ( dbfTmpL )->nPcmTil    := 0
               ( dbfTmpL )->cCodInv    := ( dbfInv )->cCodInv
               ( dbfTmpL )->( dbSkip() )
            end while

            ( dbfTmpL )->( dbGoTo( nRec ) )

         end if

      end if

      oDlg:End( IDOK )

   end if

return ( .t. )

//---------------------------------------------------------------------------//

Function InitInvitaciones( oDlg, oImgInv, oLstInv )

   local nInvi := 0

   if !Empty( oImgInv ) .and. !Empty( oLstInv ) .and. !Empty( oInvitacion )

      oInvitacion:oDbf:GoTop()

      while !oInvitacion:oDbf:Eof()

         oLstInv:SetImageList( oImgInv )

         oImgInv:AddMasked( TBitmap():Define( oInvitacion:cBigResource() ), Rgb( 255, 0, 255 ) )

         oLstInv:InsertItem( nInvi, Capitalize( oInvitacion:oDbf:cNomInv ) )

         oInvitacion:oDbf:Skip()

         nInvi++

      end while

   end if

RETURN ( nil )

//---------------------------------------------------------------------------//

Static Function GetPesoBalanza( aGet, oBtn )

   local nGetFocus   := GetFocus()

   if !Empty( oBalanza )
      aGet[ _NUNTTIL ]:cText( oBalanza:nPeso() )
   end if

   if !Empty( nGetFocus )
      SendMessage( nGetFocus, FM_CLICK, 0, 0 )
   end if

   oBtn:Click()

Return nil

//---------------------------------------------------------------------------//

function lCombinado( cCodArt, aGetArt, aTmpArt, aTmp )

   local nRecArt
   local nRecFam

   lTwoLin              := !lTwoLin

   if lTwoLin

      nRecArt           := ( dbfArticulo )->( Recno() )
      nRecFam           := ( dbfFamilia )->( Recno() )

      if dbSeekInOrd( cCodArtAnt, "Codigo", dbfArticulo )

         if dbSeekInOrd( ( dbfArticulo )->Familia, "cCodFam", dbfFamilia ) .and.;
            !Empty( ( dbfFamilia )->cFamCmb )

            cCodFamAnt  := ( dbfArticulo )->Familia

            loaPrd( ( dbfFamilia )->cFamCmb, .t., .t., aGetArt, aTmpArt, aTmp )

         end if

      end if

      ( dbfArticulo )->( dbGoTo( nRecArt ) )
      ( dbfFamilia )->( dbGoTo( nRecFam ) )

   end if

return .t.

//---------------------------------------------------------------------------//

Function SynTikCli( cPath )

   local oBlock
   local oError

   DEFAULT cPath     := cPatEmp()

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   USE ( cPath + "TIKET.DBF" )         NEW VIA ( cDriver() ) ALIAS ( cCheckArea( "TIKET", @dbfTikT ) )
   SET ADSINDEX TO ( cPath + "TIKET.CDX" ) ADDITIVE

   USE ( cPath + "TIKEL.DBF" )         NEW VIA ( cDriver() ) ALIAS ( cCheckArea( "TIKEL", @dbfTikL ) )
   SET ADSINDEX TO ( cPath + "TIKEL.CDX" ) ADDITIVE

   USE ( cPath + "TIKEP.DBF" )         NEW VIA ( cDriver() ) ALIAS ( cCheckArea( "TIKEP", @dbfTikP ) )
   SET ADSINDEX TO ( cPath + "TIKEP.CDX" ) ADDITIVE

   USE ( cPatArt() + "FAMILIAS.DBF" )  NEW VIA ( cDriver() ) ALIAS ( cCheckArea( "FAMILIAS", @dbfFamilia ) )
   SET ADSINDEX TO ( cPatArt() + "FAMILIAS.CDX" ) ADDITIVE

   USE ( cPatArt() + "ARTICULO.DBF" )  NEW VIA ( cDriver() ) ALIAS ( cCheckArea( "ARTICULO", @dbfArticulo ) )
   SET ADSINDEX TO ( cPatArt() + "ARTICULO.CDX" ) ADDITIVE

   USE ( cPatDat() + "TBLCNV.DBF" ) NEW VIA ( cDriver() ) ALIAS ( cCheckArea( "TBLCNV", @dbfTblCnv ) )
   SET ADSINDEX TO ( cPatDat() + "TBLCNV.CDX" ) ADDITIVE

   while !( dbfTikT )->( eof() )

      if Empty( ( dbfTikT )->cNcjTik )
         ( dbfTikT )->cNcjTik := "000"
      end if
      ( dbfTikT )->( dbSkip() )

   end while

   while !( dbfTikP )->( eof() )

      if Empty( ( dbfTikP )->cCodCaj )
         ( dbfTikP )->cCodCaj := "000"
      end if
      ( dbfTikP )->( dbSkip() )

   end while

   while !( dbfTikL )->( eof() )

      if !( dbfTikT )->( dbSeek( ( dbfTikL )->cSerTil + ( dbfTikL )->cNumTil + ( dbfTikL )->cSufTil ) )

         ( dbfTikL )->( dbDelete() )

      else

         if !Empty( ( dbfTikL )->cCbaTil ) .and. Empty( ( dbfTikL )->cCodFam )
            ( dbfTikL )->cCodFam := RetFamArt( ( dbfTikL )->cCbaTil, dbfArticulo )
         end if

         if !Empty( ( dbfTikL )->cCbaTil ) .and. !Empty( ( dbfTikL )->cCodFam )
            ( dbfTikL )->cGrpFam := cGruFam( ( dbfTikL )->cCodFam, dbfFamilia )
         end if

         if Empty( ( dbfTikL )->cLote ) .and. !Empty( ( dbfTikL )->nLote )
            ( dbfTikL )->cLote   := AllTrim( Str( ( dbfTikL )->nLote ) )
         end if

         if Empty( ( dbfTikL )->cAlmLin ) .or. ( dbfTikL )->cAlmLin != ( dbfTikT )->cAlmTik
            ( dbfTikL )->cAlmLin := ( dbfTikT )->cAlmTik
         end if

         ( dbfTikL )->cTipTil    := ( dbfTikT )->cTipTik

         if ( dbfTikL )->nFacCnv == 0

            if ( dbfArticulo )->( dbSeek( ( dbfTikL )->cCbaTil ) )

               if ( dbfArticulo )->lFacCnv
                  ( dbfTikL )->nFacCnv := ( dbfArticulo )->nFacCnv
               end if

            end if

         end if

      end if

      ( dbfTikL )->( dbSkip() )

      SysRefresh()

   end while

   RECOVER USING oError

      msgStop( "Imposible sincronizar tickets de clientes" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   if !Empty( dbfTikT ) .and. ( dbfTikT )->( Used() )
      ( dbfTikT )->( dbCloseArea() )
   end if

   if !Empty( dbfTikL ) .and. ( dbfTikL )->( Used() )
      ( dbfTikL )->( dbCloseArea() )
   end if

   if !Empty( dbfTikP ) .and. ( dbfTikP )->( Used() )
      ( dbfTikP )->( dbCloseArea() )
   end if

   if !Empty( dbfFamilia ) .and. ( dbfFamilia )->( Used() )
      ( dbfFamilia )->( dbCloseArea() )
   end if

   if !Empty( dbfArticulo ) .and. ( dbfArticulo )->( Used() )
      ( dbfArticulo )->( dbCloseArea() )
   end if

   if !Empty( dbfTblCnv ) .and. ( dbfTblCnv )->( Used() )
      ( dbfTblCnv )->( dbCloseArea() )
   end if

return nil

//---------------------------------------------------------------------------//

Function ImpresionComanda( nNumTik, dbfTikL )

   local nPos
   local aImp        := {}
   local nImpresora  := 0
   local cPrinter    := ""
   local nRecTikL    := ( dbfTikL )->( Recno() )

   if dbSeekInOrd( nNumTik, "CNUMTIL", dbfTikL )

      while ( dbfTikL )->cSerTil + ( dbfTikL )->cNumTil + ( dbfTikL )->cSufTil == nNumTik .and. !( dbfTikL )->( Eof() )

         if !( dbfTikL )->lImpCom

            /*
            Impresora Uno------------------------------------------------------
            */

            if ( dbfTikL )->nImpCom1 >= 1 .and. ( dbfTikL )->nImpCom1 <= 3

               if aScan( aImp, ( dbfTikL )->nImpCom1 ) == 0
                  aAdd( aImp, ( dbfTikL )->nImpCom1 )
               end if

            end if

            /*
            Impresora Dos------------------------------------------------------
            */

            if ( dbfTikL )->nImpCom2 >= 1 .and. ( dbfTikL )->nImpCom2 <= 3

               if aScan( aImp, ( dbfTikL )->nImpCom2 ) == 0
                  aAdd( aImp, ( dbfTikL )->nImpCom2 )
               end if

            end if

         end if

         ( dbfTikL )->( dbSkip() )

      end while

   end if

   /*
   Impimimos la comanda por las impresoras deseadas----------------------------
   */

   for nPos := 1 to len( aImp )

      /*
      Filtramos para que solo entren las comandas no impresas------------------
      */

      ( dbfTikL )->( dbSetFilter( {|| !Field->lImpCom .and. ( Field->nImpCom1 == aImp[ nPos ] .or. Field->nImpCom2 == aImp[ nPos ] ) }, "!lImpCom .and. ( nImpCom1 == aImp[ nPos ] .or. nImpCom2 == aImp[ nPos ] )" ) )

      /*
      Imprimimos la comanda por la impresora correspondiente-------------------
      */

      cPrinter :=    cPrinterComanda( oUser():cCaja(), dbfCajT, aImp[ nPos ] )

      if !Empty( cPrinter )
         GenTikCli( IS_PRINTER, "Imprimiendo comanda", cFormatoComandaEnCaja( oUser():cCaja(), dbfCajT ), cPrinter )
      end if

      /*
      Destruimos el filtro-----------------------------------------------------
      */

      ( dbfTikL )->( dbClearFilter() )

   next

   /*
   Ponemos la marca para saber que el producto está imprimido------------------
   */

   if dbSeekInOrd( nNumTik, "CNUMTIL", dbfTikL )

      while ( dbfTikL )->cSerTil + ( dbfTikL )->cNumTil + ( dbfTikL )->cSufTil == nNumTik .and. !( dbfTikL )->( Eof() )

         if dbLock( dbfTikL )
            ( dbfTikL )->lImpCom    := .t.
            ( dbfTikL )->( dbUnLock() )
         end if

         ( dbfTikL )->( dbSkip() )

      end while

   end if

   ( dbfTikL )->( dbGoTo( nRecTikL ) )

return ( .t. )

//---------------------------------------------------------------------------//

Function lStartAvisoPedidos()

   if !Empty( oBtnPedidos )

      lStopAvisoPedidos()
      oTimerBtn               := TTimer():New( 900, {|| lSelectedButton() }, )
      oTimerBtn:Activate()

   end if

return .t.

//---------------------------------------------------------------------------//

Function lStopAvisoPedidos()

   if !Empty( oTimerBtn )

      oTimerBtn:End()
      oTimerBtn               := nil

   endif

return .t.

//---------------------------------------------------------------------------//

Function lSelectedButton()

   if !Empty( oBtnPedidos )
      oBtnPedidos:lSelected   := !oBtnPedidos:lSelected
      oBtnPedidos:Refresh()
   end if

return .t.

//---------------------------------------------------------------------------//

Function ProcesaPedidosWeb( aTmp )

   local cNumeroPedido

   if ( dbfTmpL )->( LastRec() ) != 0
      msgstop( "Existe una venta en curso, concluya la venta antes de continuar." )
      return nil
   end if

   cNumeroPedido  := MuestraPedidosWeb( oBtnPedidos )

   if !Empty( cNumeroPedido )

      // Traspaso de cabeceras de pedidos a ticket--------------------------------

      if ( dbfPedCLiT )->( dbSeek( cNumeroPedido ) )

         aTmp[ _CCLITIK ]  := ( dbfPedCliT )->cCodCli
         aTmp[ _NTARIFA ]  := ( dbfPedCliT )->nTarifa
         aTmp[ _CNOMTIK ]  := ( dbfPedCliT )->cNomCli
         aTmp[ _CDIRCLI ]  := ( dbfPedCliT )->cDirCli
         aTmp[ _CPOBCLI ]  := ( dbfPedCliT )->cPobCli
         aTmp[ _CPRVCLI ]  := ( dbfPedCliT )->cPrvCli
         aTmp[ _CPOSCLI ]  := ( dbfPedCliT )->cPosCli
         aTmp[ _CDNICLI ]  := ( dbfPedCliT )->cDniCli

      end if

      // Traspaso de lineas de pedidos a ticket--------------------------------

      if ( dbfPedCLiL )->( dbSeek( cNumeroPedido ) )

         while ( dbfPedCLiL )->cSerPed + Str( ( dbfPedCLiL )->nNumPed ) + ( dbfPedCLiL )->cSufPed == cNumeroPedido .and. !( dbfPedCLiL )->( eof() )

            ( dbfTmpL )->( dbAppend() )

            ( dbfTmpL )->cCbaTil    := ( dbfPedCliL )->cRef
            ( dbfTmpL )->cNomTil    := ( dbfPedCliL )->cDetalle
            ( dbfTmpL )->nPvpTil    := ( dbfPedCliL )->nPreDiv
            ( dbfTmpL )->nUntTil    := ( dbfPedCliL )->nCanPed
            ( dbfTmpL )->nUndKit    := ( dbfPedCliL )->nUndKit
            ( dbfTmpL )->nIvaTil    := ( dbfPedCliL )->nIva
            ( dbfTmpL )->cFamTil    := ( dbfPedCliL )->cCodFam
            ( dbfTmpL )->nDtoLin    := ( dbfPedCliL )->nDto
            ( dbfTmpL )->nDtoDiv    := ( dbfPedCliL )->nDtoDiv
            ( dbfTmpL )->cCodPr1    := ( dbfPedCliL )->cCodPr1
            ( dbfTmpL )->cCodPr2    := ( dbfPedCliL )->cCodPr2
            ( dbfTmpL )->cValPr1    := ( dbfPedCliL )->cValPr1
            ( dbfTmpL )->cValPr2    := ( dbfPedCliL )->cValPr2
            ( dbfTmpL )->cAlmLin    := ( dbfPedCliL )->cAlmLin
            ( dbfTmpL )->nValImp    := ( dbfPedCliL )->nValImp
            ( dbfTmpL )->cCodImp    := ( dbfPedCliL )->cCodImp
            ( dbfTmpL )->nNumLin    := ( dbfPedCliL )->nNumLin
            ( dbfTmpL )->lKitArt    := ( dbfPedCliL )->lKitArt
            ( dbfTmpL )->lKitChl    := ( dbfPedCliL )->lKitChl
            ( dbfTmpL )->cCodFam    := ( dbfPedCliL )->cCodFam
            ( dbfTmpL )->cGrpFam    := ( dbfPedCliL )->cGrpFam
            ( dbfTmpL )->nLote      := ( dbfPedCliL )->nLote
            ( dbfTmpL )->nNumMed    := ( dbfPedCliL )->nNumMed
            ( dbfTmpL )->nMedUno    := ( dbfPedCliL )->nMedUno
            ( dbfTmpL )->nMedDos    := ( dbfPedCliL )->nMedDos
            ( dbfTmpL )->nMedTre    := ( dbfPedCliL )->nMedTre

            ( dbfTmpL )->nImpCom1   := Retfld( ( dbfPedCliL )->cRef, dbfArticulo, "nImpCom1" ) - 1
            ( dbfTmpL )->nImpCom2   := Retfld( ( dbfPedCliL )->cRef, dbfArticulo, "nImpCom2" ) - 1

            ( dbfPedCLiL )->( dbSkip() )

         end while

      end if

      oBrwDet:Refresh()

      lRecTotal( aTmp )

   end if

Return nil

//---------------------------------------------------------------------------//

static function cTextoOfficeBar( aTmp )

   local uValor

   if !Empty( oBtnCliente )

      uValor         := AllTrim( RetFld( aTmp[ _CCLITIK ], dbfClient, "Titulo" ) )

      oBtnCliente:cCaption( if( !Empty( uValor ), uValor, "..." ) )

   end if

   if !Empty( oBtnDireccion )

      uValor         := AllTrim( RetFld( aTmp[ _CCLITIK ], dbfClient, "Domicilio" ) )

      oBtnDireccion:cCaption( if( !Empty( uValor ), uValor, "..." ) )

   end if

   if !Empty( oBtnTelefono )

      uValor         := AllTrim( RetFld( aTmp[ _CCLITIK ], dbfClient, "Telefono" ) ) + Space( 1 ) + AllTrim( RetFld( aTmp[ _CCLITIK ], dbfClient, "cMeiInt" ) )

      oBtnTelefono:cCaption( if( !Empty( uValor ), uValor, "..." ) )

   end if

Return nil

//---------------------------------------------------------------------------//

Static Function lSeleccionaCliente( aTmp )

   local cCliente    := BrwCliTactil( nil, nil, nil, .t. )

   aTmp[ _CCLITIK  ] := cCliente

   aTmp[ _CNOMTIK  ] := RetFld( cCliente, dbfClient, "Titulo" )
   aTmp[ _CDIRCLI  ] := RetFld( cCliente, dbfClient, "Domicilio" )
   aTmp[ _CPOBCLI  ] := RetFld( cCliente, dbfClient, "Poblacion" )
   aTmp[ _CPRVCLI  ] := RetFld( cCliente, dbfClient, "Provincia" )
   aTmp[ _CPOSCLI  ] := RetFld( cCliente, dbfClient, "CodPostal" )
   aTmp[ _CDNICLI  ] := RetFld( cCliente, dbfClient, "Nif" )

   cTextoOfficeBar( aTmp )

Return .t.

//---------------------------------------------------------------------------//

static function lNumeroComensales( aTmp )

   aTmp[ _NNUMCOM ]  := nVirtualNumKey( "Users1_32", "Número comensales" )

   lRecTotal( aTmp )

Return .t.

//---------------------------------------------------------------------------//

Static Function lCambiaTicket( lSubir, aTmp, aGet )

   local oError
   local oBlock

   /*
   Comprobamos que no sea ni el primer registro ni el último-------------------
   */

   if lSubir

      if ( dbfTikT )->( OrdKeyno() ) == 1
         MsgStop( "Ya estas en el primer registro" )
         return nil
      end if

   else

      if ( dbfTikT )->( OrdKeyno() ) == ( dbfTikT )->( LastRec() )
         MsgStop( "Ya estas en el último registro" )
         return nil
      end if

   end if

   oBlock                  := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   /*
   Guarda la venta actual------------------------------------------------------
   */

   if GuardaVenta( aTmp, aGet )

      /*
      Subo o bajo un registro--------------------------------------------------
      */

      if lSubir
         ( dbfTikT )->( dbSkip( -1 ) )
      else
         ( dbfTikT )->( dbSkip() )
      end if

      /*
      Abrimos el ticket seleccionado-------------------------------------------
      */

      aScatter( dbfTikT, aTmp )
      if !BeginTrans( aTmp, aGet, EDIT_MODE, .t. )
         nSaveMode                     := EDIT_MODE
      end if

      /*
      Botones de la officebar--------------------------------------------------
      */

      oSalaVentas:ConfigButton( oBtnTarifa, oBtnRenombrar )

      /*
      Titulo de la ventana-----------------------------------------------------
      */

      cTitleDialog( aTmp )

      /*
      Recalculamos el total----------------------------------------------------
      */

      lRecTotal( aTmp )

   end if

   RECOVER USING oError

      msgStop( "Error al cambiar de ticket" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

Return .t.

//---------------------------------------------------------------------------//

#else

FUNCTION pdaticket()

   local oSnd
   local nLevel
   local oBlock
   local oError
   local oDlg
   local oBrwTicket
   local oGetBuscar
   local cGetBuscar     := Space( 100 )
   local oCbxOrden
   local cCbxOrden      := "Número"
   local oSayTit
   local oFont
   local oBtn

  /* DEFAULT  oMenuItem   := _MENUITEM_

   /*
   Obtenemos el nivel de acceso
   */
   /*
   nLevel               := nLevelUsr( oMenuItem )

   if nAnd( nLevel, 1 ) != 0
      msgStop( "Acceso no permitido." )
      return nil
   end if

   */
   if !pdaOpenFiles()
      return nil
   end if

  oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )

  BEGIN SEQUENCE

      DEFINE FONT oFont NAME "Verdana" SIZE 0, -14

      DEFINE DIALOG oDlg RESOURCE "Dlg_info"

      REDEFINE SAY oSayTit ;
         VAR      "Ticket de clientes" ;
         ID       140 ;
         COLOR    "N/W*" ;
         FONT     oFont ;
         OF       oDlg

      REDEFINE BTNBMP oBtn ;
         ID       130 ;
         OF       oDlg ;
         FILE     ( cPatBmp() + "Clipboard_Empty_User1_16.bmp" ) ;
         NOBORDER ;
         ACTION      ( nil )

      oBtn:SetColor( 0, nRGB( 255, 255, 255 )  )

      REDEFINE GET oGetBuscar ;
         VAR      cGetBuscar;
         ID       110 ;
         OF       oDlg

      oGetBuscar:bChange   := {| nKey, nFlags | AutoSeek( nKey, nFlags, oGetBuscar, oBrwTicket, dbfTikT ) }

      REDEFINE COMBOBOX oCbxOrden ;
         VAR      cCbxOrden ;
         ID       120 ;
         ITEMS    {  "Número",;
                     "Cliente",;
                     "Importe" } ;
			OF 		oDlg

      oCbxOrden:bChange    := {|| ( dbfTikT )->( OrdSetFocus( oCbxOrden:nAt ) ), ( dbfTikT )->( dbGoTop() ), dbfTikT:Refresh(), oGetBuscar:SetFocus(), oCbxOrden:Refresh() }


      //msginfo( nTotTik( cNumTik, dbfTikT, dbfTikL, dbfDiv, nil, nil, .f. ) )


      REDEFINE LISTBOX oBrwTicket ;
         FIELDS ;
               ( dbfTikT )->cSerTik + "/" + Alltrim( ( dbfTikT )->cNumTik ) + "/" + ( dbfTikT )->cSufTik + CRLF + Dtoc( ( dbfTikT )->dFecTik ),;
               ( dbfTikT )->cCliTik + CRLF + ( dbfTikT )->cNomTik;
         SIZES ;
               100,;
               180;
         HEADER ;
               "Número" + CRLF + "Fecha",;
               "Cliente";
         ALIAS ( dbfTikT );
         ID    100;
         OF    oDlg

         oBrwTicket:nHeight   := 24

      ACTIVATE DIALOG oDlg ;
         ON INIT ( oDlg:SetMenu( pdaBuildMenu( oDlg, oBrwTicket ) ) )

      pdaCloseFiles()

   RECOVER USING oError

      msgStop( "Imposible abrir pedidos" )

   END SEQUENCE

   ErrorBlock( oBlock )

   oFont:End()

   // Restauramos la ventana---------------------------------------------------

   oWnd():Show()

RETURN NIL

//----------------------------------------------------------------------------//

STATIC FUNCTION pdaBuildMenu( oDlg, oBrwTicket )

   local oMenu

   DEFINE MENU oMenu ;
      RESOURCE 500 ;
      BITMAPS  60 ; // bitmaps resoruces ID
      IMAGES   6     // number of images in the bitmap

      REDEFINE MENUITEM ID 510 OF oMenu ACTION ( WinAppRec( oBrwTicket, bEdtPda, dbfTikT ) )

      REDEFINE MENUITEM ID 520 OF oMenu ACTION ( msginfo("Modificar") )//WinEdtRec( oBrwTicket, bEdtPda, dbfPedCliT, oDlg ) )

      REDEFINE MENUITEM ID 530 OF oMenu ACTION ( msginfo("Eliminar") )//DBDelRec( oBrwTicket, dbfPedCliT ) )

      REDEFINE MENUITEM ID 540 OF oMenu ACTION ( msginfo("Zoom") )//WinZooRec( oBrwTicket, bEdtPda, dbfPedCliT, oDlg ) )

      REDEFINE MENUITEM ID 550 OF oMenu ACTION ( msginfo("Imprimir") )//pdaGenPedCli( oBrwTicket, dbfPedCliT, dbfPedCliL ) )

      REDEFINE MENUITEM ID 560 OF oMenu ACTION ( oDlg:End() )

Return oMenu

//----------------------------------------------------------------------------//

STATIC FUNCTION pdaOpenFiles()

   local oError
   local oBlock

   if lOpenFiles
      MsgStop( 'Imposible abrir ficheros de tiket' )
      Return ( .f. )
   end if

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

      if !lExistTable( cPatEmp() + "TikeT.Dbf" )  .or.;
         !lExistTable( cPatEmp() + "TikeL.Dbf" )  .or.;
         !lExistTable( cPatEmp() + "TikeP.Dbf" )
         mkTpv( cPatEmp() )
      end if

      lOpenFiles        := .t.

      USE ( cPatEmp() + "TIKET.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIKET", @dbfTikT ) )
      SET ADSINDEX TO ( cPatEmp() + "TIKET.CDX" ) ADDITIVE

      USE ( cPatEmp() + "TIKEL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIKEL", @dbfTikL ) )
      SET ADSINDEX TO ( cPatEmp() + "TIKEL.CDX" ) ADDITIVE

      USE ( cPatEmp() + "TIKEP.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIKEP", @dbfTikP ) )
      SET ADSINDEX TO ( cPatEmp() + "TIKEP.CDX" ) ADDITIVE

   RECOVER USING oError

      lOpenFiles        := .f.

      msgStop( "Imposible abrir todas las bases de datos" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   if !lOpenFiles
      pdaCloseFiles()
   end if

RETURN ( lOpenFiles )

//----------------------------------------------------------------------------//

STATIC FUNCTION pdaCloseFiles()

   if( !Empty( dbfTikT ), ( dbfTikT )->( dbCloseArea() ), )
   if( !Empty( dbfTikL ), ( dbfTikL )->( dbCloseArea() ), )
   if( !Empty( dbfTikP ), ( dbfTikP )->( dbCloseArea() ), )

   dbfTikT       := nil
   dbfTikL       := nil
   dbfTikP       := nil

   lOpenFiles    := .f.

RETURN .T.

//---------------------------------------------------------------------------//

Static FUNCTION EdtPda( aTmp, aGet, dbfTikT, oBrw, bWhen, bValid, nMode )

   local oDlg
   local n

   DEFAULT nMesa   := 18

   /*oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE
   */
   DEFINE DIALOG oDlg RESOURCE "TIKET_PDA"

   /*
   Lineas para los salones-----------------------------------------------------
   */

   REDEFINE BTNBMP oBtn ;
         ID       101 ;
         OF       oDlg ;
         FILE     ( cPatBmp() + "truck_blue_24.bmp" ) ;
         NOBORDER ;
         ACTION      ( nil )

   REDEFINE BTNBMP oBtn ;
         ID       102 ;
         OF       oDlg ;
         FILE     ( cPatBmp() + "truck_blue_24.bmp" ) ;
         NOBORDER ;
         ACTION      ( nil )

   REDEFINE BTNBMP oBtn ;
         ID       103 ;
         OF       oDlg ;
         FILE     ( cPatBmp() + "truck_blue_24.bmp" ) ;
         NOBORDER ;
         ACTION      ( nil )

   REDEFINE BTNBMP oBtn ;
         ID       104 ;
         OF       oDlg ;
         FILE     ( cPatBmp() + "truck_blue_24.bmp" ) ;
         NOBORDER ;
         ACTION      ( nil )

   REDEFINE BTNBMP oBtn ;
         ID       105 ;
         OF       oDlg ;
         FILE     ( cPatBmp() + "truck_blue_24.bmp" ) ;
         NOBORDER ;
         ACTION      ( nil )

   REDEFINE BTNBMP oBtn ;
         ID       106 ;
         OF       oDlg ;
         FILE     ( cPatBmp() + "truck_blue_24.bmp" ) ;
         NOBORDER ;
         ACTION      ( nil )


   /*
   Lineas para las mesas-------------------------------------------------------
   */

   for n:=1 to nMesa

   REDEFINE BTNBMP oBtn ;
         ID       200 + n ;
         OF       oDlg ;
         FILE     ( cPatBmp() + "cashier_user1_24.bmp" ) ;
         NOBORDER ;
         ACTION      msginfo( "" )

   next

   ACTIVATE DIALOG oDlg ;
      ON INIT ( pdaMenuEdtRec( oDlg ) )


   /*RECOVER USING oError

      msgStop( "Ocurrió un error en Pedidos" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )
   */
   // Restauramos la ventana---------------------------------------------------

   oWnd():Show()

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

static FUNCTION pdaMenuEdtRec( oDlg )

   local oMenu

   DEFINE MENU oMenu ;
      RESOURCE 100 ;
      BITMAPS  10 ; // bitmaps resoruces ID
      IMAGES   3     // number of images in the bitmap

      REDEFINE MENUITEM ID 110 OF oMenu ACTION ( EdtTiketPda() )

      REDEFINE MENUITEM ID 120 OF oMenu ACTION ( oDlg:End( IDCANCEL ) )

   oDlg:SetMenu( oMenu )


Return oMenu

//---------------------------------------------------------------------------//

Static FUNCTION EdtTiketPda( aTmp, aGet, dbfTikT, oBrw, bWhen, bValid, nMode )

   local oDlg
   local n

   DEFAULT nArticulo   := 10

   /*oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE
   */
   DEFINE DIALOG oDlg RESOURCE "TIKET_PDA_01"

   /*
   Lineas para las familias----------------------------------------------------
   */

   REDEFINE BTNBMP oBtn ;
         ID       101 ;
         OF       oDlg ;
         FILE     ( cPatBmp() + "truck_blue_24.bmp" ) ;
         NOBORDER ;
         ACTION      ( nil )

   REDEFINE BTNBMP oBtn ;
         ID       102 ;
         OF       oDlg ;
         FILE     ( cPatBmp() + "truck_blue_24.bmp" ) ;
         NOBORDER ;
         ACTION      ( nil )

   REDEFINE BTNBMP oBtn ;
         ID       103 ;
         OF       oDlg ;
         FILE     ( cPatBmp() + "truck_blue_24.bmp" ) ;
         NOBORDER ;
         ACTION      ( nil )

   REDEFINE BTNBMP oBtn ;
         ID       104 ;
         OF       oDlg ;
         FILE     ( cPatBmp() + "truck_blue_24.bmp" ) ;
         NOBORDER ;
         ACTION      ( nil )

   REDEFINE BTNBMP oBtn ;
         ID       105 ;
         OF       oDlg ;
         FILE     ( cPatBmp() + "truck_blue_24.bmp" ) ;
         NOBORDER ;
         ACTION      ( nil )


   /*
   Lineas para los articulos---------------------------------------------------
   */

   for n:=1 to nArticulo

   REDEFINE BTNBMP oBtn ;
         ID       200 + n ;
         OF       oDlg ;
         FILE     ( cPatBmp() + "cashier_user1_24.bmp" ) ;
         NOBORDER ;
         ACTION      msginfo( "" )

   next

   ACTIVATE DIALOG oDlg ;
      ON INIT ( pdaMenuEdtRec( oDlg ) )


   /*RECOVER USING oError

      msgStop( "Ocurrió un error en Pedidos" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )
   */
   // Restauramos la ventana---------------------------------------------------

   oWnd():Show()

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

static FUNCTION pdaMenuTiket( oDlg )

   local oMenu

   DEFINE MENU oMenu ;
      RESOURCE 100 ;
      BITMAPS  10 ; // bitmaps resoruces ID
      IMAGES   3     // number of images in the bitmap

      REDEFINE MENUITEM ID 110 OF oMenu ACTION ( msginfo( "Aceptar" ) )

      REDEFINE MENUITEM ID 120 OF oMenu ACTION ( oDlg:End( IDCANCEL ) )

   oDlg:SetMenu( oMenu )


Return oMenu

//---------------------------------------------------------------------------//

#endif

//---------------------------------------------------------------------------//

FUNCTION mkTpv( cPath, lAppend, cPathOld, oMeter )

	local dbfTikT
	local dbfTikL
   local dbfTikP
   local dbfTikC
   local oldTikT
   local oldTikL
   local oldTikP
   local oldTikC

   DEFAULT lAppend   := .f.
   DEFAULT cPath     := cPatEmp()

   if oMeter != nil
		oMeter:cText	:= "Generando Bases"
      SysRefresh()
   end if

   if !lExistTable( cPath + "TIKET.DBF" )
      dbCreate( cPath + "TIKET.DBF", aSqlStruct( aItmTik() ), cDriver() )
   end if

   if !lExistTable( cPath + "TIKEL.DBF" )
      dbCreate( cPath + "TIKEL.DBF", aSqlStruct( aColTik() ), cDriver() )
   end if

   if !lExistTable( cPath + "TIKEP.DBF" )
      dbCreate( cPath + "TIKEP.DBF", aSqlStruct( aPgoTik() ), cDriver() )
   end if

   if !lExistTable( cPath + "TIKEC.DBF" )
      dbCreate( cPath + "TIKEC.DBF", aSqlStruct( aPgoCli() ), cDriver() )
   end if

   rxTpv( cPath, oMeter )

   if lAppend .and. lIsDir( cPathOld )

      dbUseArea( .t., cDriver(), cPath + "Tiket.Dbf", cCheckArea( "TIKET",  @dbfTikT ), .f. )
      ( dbfTikT )->( ordListAdd( cPath + "Tiket.Cdx" ) )
      ( dbfTikT )->( ordSetFocus( "cLiqVal" ) )

      dbUseArea( .t., cDriver(), cPath + "Tikel.Dbf", cCheckArea( "TIKETL", @dbfTikL ), .f. )
      ( dbfTikL )->( ordListAdd( cPath + "Tikel.Cdx" ) )

      dbUseArea( .t., cDriver(), cPath + "Tikep.Dbf", cCheckArea( "TIKETP", @dbfTikP ), .f. )
      ( dbfTikP )->( ordListAdd( cPath + "Tikep.Cdx" ) )

      dbUseArea( .t., cDriver(), cPath + "TikeC.Dbf", cCheckArea( "TiketC", @dbfTikC ), .f. )
      ( dbfTikC )->( ordListAdd( cPath + "TikeC.Cdx" ) )

      dbUseArea( .t., cDriver(), cPathOld + "Tiket.Dbf", cCheckArea( "TIKET",  @oldTikT ), .f. )
      ( oldTikT )->( ordListAdd( cPathOld + "Tiket.Cdx" ) )
      ( oldTikT )->( ordSetFocus( "cLiqVal" ) )

      dbUseArea( .t., cDriver(), cPathOld + "TikeL.Dbf", cCheckArea( "TIKETL", @oldTikL ), .f. )
      ( oldTikL )->( ordListAdd( cPathOld + "TikeL.Cdx" ) )

      dbUseArea( .t., cDriver(), cPathOld + "TikeP.Dbf", cCheckArea( "TIKETP", @oldTikP ), .f. )
      ( oldTikP )->( ordListAdd( cPathOld + "TikeP.Cdx" ) )

      dbUseArea( .t., cDriver(), cPathOld + "TikeC.Dbf", cCheckArea( "TiketC", @oldTikC ), .f. )
      ( oldTikC )->( ordListAdd( cPath + "TikeC.Cdx" ) )

      ( oldTikT )->( dbGoTop() )
      while !( oldTikT )->( eof() )

         dbCopy( oldTikT, dbfTikT, .t. )

         if ( oldTikL )->( dbSeek( ( oldTikT )->cSerTik + ( oldTikT )->cNumTik + ( oldTikT )->cSufTik ) )
            while ( oldTikL )->cSerTil + ( oldTikL )->cNumTil + ( oldTikL )->cSufTil == ( oldTikT )->cSerTik + ( oldTikT )->cNumTik + ( oldTikT )->cSufTik .and. !( oldTikL )->( eof() )
               dbCopy( oldTikL, dbfTikL, .t. )
               ( oldTikL )->( dbSkip() )
            end while
         end if

         if ( oldTikP )->( dbSeek( ( oldTikT )->cSerTik + ( oldTikT )->cNumTik + ( oldTikT )->cSufTik ) )
            while ( oldTikP )->cSerTik + ( oldTikP )->cNumTik + ( oldTikP )->cSufTik == ( oldTikT )->cSerTik + ( oldTikT )->cNumTik + ( oldTikT )->cSufTik .and. !( oldTikP )->( eof() )
               dbCopy( oldTikP, dbfTikP, .t. )
               ( oldTikP )->( dbSkip() )
            end while
         end if

         ( oldTikT )->( dbSkip() )

      end while

      /*
      Pagos de clientes--------------------------------------------------------
      */

      ( oldTikC )->( dbGoTop() )
      while !( oldTikC )->( eof() )
         dbCopy( oldTikC, dbfTikC, .t. )
         ( oldTikC )->( dbSkip() )
      end while

      /*
      Reemplaza la antigua sesion----------------------------------------------
      */

      ( dbfTikT )->( dbEval( {|| ( dbfTikT )->cTurTik := Space( 6 ) },,,,, .f. ) )

      /*
      Cerramos las bases de datos----------------------------------------------
      */

      CLOSE( dbfTikT )
      CLOSE( dbfTikL )
      CLOSE( dbfTikP )
      CLOSE( dbfTikC )

      CLOSE( oldTikT )
      CLOSE( oldTikL )
      CLOSE( oldTikP )
      CLOSE( oldTikC )

   end if

Return nil

//--------------------------------------------------------------------------//

FUNCTION rxTpv( cPath, oMeter )

	local dbfTikT
	local dbfTikL
   local dbfTikP
   local dbfTikC

   DEFAULT cPath  := cPatEmp()

   if !lExistTable( cPath + "TIKET.DBF" )
      dbCreate( cPath + "TIKET.DBF", aSqlStruct( aItmTik() ), cDriver() )
   end if

   if !lExistTable( cPath + "TIKEL.DBF" )
      dbCreate( cPath + "TIKEL.DBF", aSqlStruct( aColTik() ), cDriver() )
   end if

   if !lExistTable( cPath + "TIKEP.DBF" )
      dbCreate( cPath + "TIKEP.DBF", aSqlStruct( aPgoTik() ), cDriver() )
   end if

   if !lExistTable( cPath + "TIKEC.DBF" )
      dbCreate( cPath + "TIKEC.DBF", aSqlStruct( aPgoCli() ), cDriver() )
   end if

   fEraseIndex( cPath + "TikeT.Cdx" )

   fEraseIndex( cPath + "TikeL.Cdx" )

   fEraseIndex( cPath + "TikeP.Cdx" )

   fEraseIndex( cPath + "TikeC.Cdx" )

   dbUseArea( .t., cDriver(), cPath + "TIKET.DBF", cCheckArea( "TIKET", @dbfTikT ), .f. )
   if !( dbfTikT )->( neterr() )
      ( dbfTikT )->( __dbPack() )

      ( dbfTikT )->( ordCondSet( "!Deleted()", {||!Deleted()}  ) )
      ( dbfTikT )->( ordCreate( cPath + "TIKET.CDX", "CNUMTIK", "CSERTIK + CNUMTIK + CSUFTIK", {|| Field->cSerTik + Field->cNumTik + Field->cSufTik } ) )

      ( dbfTikT )->( ordCondSet( "!Deleted()", {||!Deleted()}  ) )
      ( dbfTikT )->( ordCreate( cPath + "TIKET.CDX", "DFECTIK", "DFECTIK", {|| Field->DFECTIK } ) )

      ( dbfTikT )->( ordCondSet( "!Deleted()", {||!Deleted()}  ) )
      ( dbfTikT )->( ordCreate( cPath + "TIKET.CDX", "CNCJTIK", "CCCJTIK", {|| Field->CNCJTIK } ) )

      ( dbfTikT )->( ordCondSet( "!Deleted()", {||!Deleted()}  ) )
      ( dbfTikT )->( ordCreate( cPath + "TIKET.CDX", "CCCJTIK", "CCCJTIK", {|| Field->CCCJTIK } ) )

      ( dbfTikT )->( ordCondSet( "!Deleted()", {||!Deleted()}  ) )
      ( dbfTikT )->( ordCreate( cPath + "TIKET.CDX", "CCLITIK", "CCLITIK", {|| Field->CCLITIK } ) )

      ( dbfTikT )->( ordCondSet( "!Deleted()", {||!Deleted()}  ) )
      ( dbfTikT )->( ordCreate( cPath + "TIKET.CDX", "CNOMTIK", "CNOMTIK", {|| Field->CNOMTIK } ) )

      ( dbfTikT )->( ordCondSet( "!Deleted()", {||!Deleted()}  ) )
      ( dbfTikT )->( ordCreate( cPath + "TIKET.CDX", "CRETMAT", "CRETMAT", {|| Field->CRETMAT } ) )

      ( dbfTikT )->( ordCondSet( "!Deleted() .and. !Empty( cTurTik )", {||!Deleted() .and. !Empty( Field->cTurTik ) }  ) )
      ( dbfTikT )->( ordCreate( cPath + "TIKET.CDX", "CTURTIK", "CTURTIK + CSUFTIK + CNCJTIK", {|| Field->CTURTIK + Field->cSufTik + Field->CNCJTIK } ) )

      ( dbfTikT )->( ordCondSet( "!Deleted()", {||!Deleted() }  ) )
      ( dbfTikT )->( ordCreate( cPath + "TIKET.CDX", "CNUMDOC", "CNUMDOC", {|| Field->CNUMDOC } ) )

      ( dbfTikT )->( ordCondSet( "!Deleted()", {||!Deleted() }  ) )
      ( dbfTikT )->( ordCreate( cPath + "TIKET.CDX", "LSNDDOC", "LSNDDOC", {|| Field->LSNDDOC } ) )

      ( dbfTikT )->( ordCondSet( "!Deleted()", {||!Deleted() }  ) )
      ( dbfTikT )->( ordCreate( cPath + "TIKET.CDX", "cCodUsr", "cCcjTik + Dtos( dFecCre ) + cTimCre", {|| Field->cCcjTik + Dtos( Field->dFecCre ) + Field->cTimCre } ) )

      ( dbfTikT )->( ordCondSet( "!Deleted() .and. cTipTik == '6'", {||!Deleted() .and. Field->cTipTik == '6'}  ) )
      ( dbfTikT )->( ordCreate( cPath + "TIKET.CDX", "CDOCVAL", "cValDoc", {|| Field->cValDoc } ) )

      ( dbfTikT )->( ordCondSet( "!Deleted() .and. cTipTik == '6'", {||!Deleted() .and. Field->cTipTik == '6'}  ) )
      ( dbfTikT )->( ordCreate( cPath + "TIKET.CDX", "CNUMVAL", "cSerTik + cNumTik + cSufTik", {|| Field->cSerTik + Field->cNumTik + Field->cSufTik } ) )

      ( dbfTikT )->( ordCondSet( "!Deleted() .and. cTipTik == '6' .and. !lLiqTik", {||!Deleted() .and. Field->cTipTik == '6' .and. !Field->lLiqTik }  ) )
      ( dbfTikT )->( ordCreate( cPath + "TIKET.CDX", "cLiqVal", "cSerTik + cNumTik + cSufTik", {|| Field->cSerTik + Field->cNumTik + Field->cSufTik } ) )

      ( dbfTikT )->( ordCondSet( "!Deleted() .and. lLiqTik", {|| !Deleted() .and. Field->lLiqTik }  ) )
      ( dbfTikT )->( ordCreate( cPath + "TIKET.CDX", "cTurVal", "cTurVal + cSufTik + cNcjTik", {|| Field->cTurVal + Field->cSufTik + Field->cNcjTik } ) )

      ( dbfTikT )->( ordCondSet( "!Deleted() .and. cTipTik == '1' .and. !lPgdTik .and. !lCloTik", {|| !Deleted() .and. Field->cTipTik == '1' .and. !Field->lPgdTik .and. !Field->lCloTik } ) )
      ( dbfTikT )->( ordCreate( cPath + "TIKET.CDX", "cCodSal", "cCodSala + cPntVenta", {|| Field->cCodSala + Field->cPntVenta } ) )

      ( dbfTikT )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de tikets" )
   end if

   dbUseArea( .t., cDriver(), cPath + "TIKEL.DBF", cCheckArea( "TIKEL", @dbfTikL ), .f. )
   if !( dbfTikL )->( neterr() )
      ( dbfTikL )->( __dbPack() )

      ( dbfTikL )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfTikL )->( ordCreate( cPath + "TIKEL.CDX", "CNUMTIL", "CSERTIL + CNUMTIL + CSUFTIL", {|| Field->CSERTIL + Field->CNUMTIL + Field->CSUFTIL } ) )

      ( dbfTikL )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfTikL )->( ordCreate( cPath + "TIKEL.CDX", "CCBATIL", "CCBATIL", {|| Field->CCBATIL } ) )

      ( dbfTikL )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfTikL )->( ordCreate( cPath + "TIKEL.CDX", "CCOMTIL", "CCOMTIL", {|| Field->CCOMTIL } ) )

      ( dbfTikL )->( ordCondSet("!Deleted() .and. cTipTil != '2' .and. cTipTil != '3'", {||!Deleted() .and. Field->cTipTil != '2' .and. Field->cTipTil != '3' } ) )
      ( dbfTikL )->( ordCreate( cPath + "TIKEL.CDX", "CSTKFAST", "CCBATIL", {|| Field->CCBATIL } ) )

      ( dbfTikL )->( ordCondSet("!Deleted() .and. cTipTil != '2' .and. cTipTil != '3'", {||!Deleted() .and. Field->cTipTil != '2' .and. Field->cTipTil != '3' } ) )
      ( dbfTikL )->( ordCreate( cPath + "TIKEL.CDX", "CSTKCOM", "CCOMTIL", {|| Field->CCOMTIL } ) )

      ( dbfTikL )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de tikets" )
   end if

   dbUseArea( .t., cDriver(), cPath + "TIKEP.DBF", cCheckArea( "TIKEP", @dbfTikP ), .f. )
   if !( dbfTikP )->( neterr() )
      ( dbfTikP )->( __dbPack() )

      ( dbfTikP )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfTikP )->( ordCreate( cPath + "TIKEP.CDX", "CNUMTIK", "CSERTIK + CNUMTIK + CSUFTIK", {|| Field->cSerTik + Field->cNumTik + Field->cSufTik } ) )

      ( dbfTikP )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfTikP )->( ordCreate( cPath + "TIKEP.CDX", "DPGOTIK", "DPGOTIK", {|| Field->DPGOTIK } ) )

      ( dbfTikP )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfTikP )->( ordCreate( cPath + "TIKEP.CDX", "CTURPGO", "cTurPgo + cSufTik + cCodCaj", {|| Field->cTurPgo + Field->cSufTik + Field->cCodCaj } ) )

      ( dbfTikP )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfTikP )->( ordCreate( cPath + "TIKEP.CDX", "cFpgPgo", "cFpgPgo", {|| Field->cFpgPgo } ) )

      ( dbfTikP )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( dbfTikP )->( ordCreate( cPath + "TIKEP.CDX", "NNUMPGO", "Str( nNumPgo ) + cSufPgo", {|| Str( Field->nNumPgo ) + Field->cSufPgo } ) )

      ( dbfTikP )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de tikets" )
   end if

   dbUseArea( .t., cDriver(), cPath + "TIKEC.DBF", cCheckArea( "TIKEC", @dbfTikC ), .f. )
   if !( dbfTikC )->( neterr() )
      ( dbfTikC )->( __dbPack() )

      ( dbfTikC )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( dbfTikC )->( ordCreate( cPath + "TIKEC.CDX", "NNUMPGO", "Str( nNumPgo ) + cSufPgo", {|| Str( Field->nNumPgo ) + Field->cSufPgo } ) )

      ( dbfTikC )->( ordCondSet( "!Deleted()", {|| !Deleted() }  ) )
      ( dbfTikC )->( ordCreate( cPath + "TIKEC.CDX", "cCodCli", "cCodCli", {|| Field->cCodCli } ) )

      ( dbfTikC )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de tikets" )
   end if

RETURN NIL

//---------------------------------------------------------------------------//

function aPgoTik()

   local aPgoTik  := {}

   aAdd( aPgoTik, { "cSerTik",  "C",      1,     0, "Serie del tiket"            } )
   aAdd( aPgoTik, { "cNumTik",  "C",     10,     0, "Número del tiket"           } )
   aAdd( aPgoTik, { "cSufTik",  "C",      2,     0, "Sufijo del tiket"           } )
   aAdd( aPgoTik, { "nNumRec",  "N",      2,     0, "Número de orden del pago"   } )
   aAdd( aPgoTik, { "cCodCaj",  "C",      3,     0, "Código de caja"             } )
   aAdd( aPgoTik, { "dPgoTik",  "D",      8,     0, "Fecha del pago"             } )
   aAdd( aPgoTik, { "cTimTik",  "C",      5,     0, "Hora del pago"              } )
   aAdd( aPgoTik, { "cFpgPgo",  "C",      2,     0, "Forma de pago del recibo"   } )
   aAdd( aPgoTik, { "nImpTik",  "N",     16,     6, "Importe del pago"           } )
   aAdd( aPgoTik, { "nDevTik",  "N",     16,     6, "Importe de la devolución"   } )
   aAdd( aPgoTik, { "cPgdPor",  "C",     50,     0, "Pagado por"                 } )
   aAdd( aPgoTik, { "cDivPgo",  "C",      3,     0, "Divisa de pago"             } )
   aAdd( aPgoTik, { "nVdvPgo",  "N",     16,     6, "Valor de la divisa"         } )
   aAdd( aPgoTik, { "lConPgo",  "L",      1,     0, "Pago contabilizado (S/N)"   } )
   aAdd( aPgoTik, { "cCtaPgo",  "C",     12,     0, "Cuenta de pago"             } )
   aAdd( aPgoTik, { "lCloPgo",  "L",      1,     0, "Pago cerrado (S/N)"         } )
   aAdd( aPgoTik, { "lSndPgo",  "L",      1,     0, "Enviar documento"           } )
   aAdd( aPgoTik, { "cTurPgo",  "C",      6,     0, "Sesión del pago"            } )
   aAdd( aPgoTik, { "cCtaRec",  "C",     12,     0, "Cuenta de contabilidad"     } )
   aAdd( aPgoTik, { "nNumPgo",  "N",      9,     0, "Número pago cliente"        } )
   aAdd( aPgoTik, { "cSufPgo",  "C",      2,     0, "Sufijo pago cliente"        } )

RETURN ( aPgoTik )

//---------------------------------------------------------------------------//

function aPgoCli()

   local aPgoCli  := {}

   aAdd( aPgoCli, { "nNumPgo",  "N",      9,     0, "Pago cliente.Número"                    } )
   aAdd( aPgoCli, { "cSufPgo",  "C",      2,     0, "Pago cliente.Sufijo"                    } )
   aAdd( aPgoCli, { "cCodCaj",  "C",      3,     0, "Pago cliente.Número de caja"            } )
   aAdd( aPgoCli, { "dPgoTik",  "D",      8,     0, "Pago cliente.Fecha del pago"            } )
   aAdd( aPgoCli, { "cFpgPgo",  "C",      2,     0, "Pago cliente.Forma de pago del recibo"  } )
   aAdd( aPgoCli, { "nImpPgo",  "N",     16,     6, "Pago cliente.Importe del pago"          } )
   aAdd( aPgoCli, { "nDevPgo",  "N",     16,     6, "Pago cliente.Importe de la devolución"  } )
   aAdd( aPgoCli, { "nTotPgo",  "N",     16,     6, "Pago cliente.Total importe pago"        } )
   aAdd( aPgoCli, { "cCodCli",  "C",     12,     0, "Pago cliente.Código cliente"            } )
   aAdd( aPgoCli, { "cDivPgo",  "C",      3,     0, "Pago cliente.Divisa de pago"            } )
   aAdd( aPgoCli, { "nVdvPgo",  "N",     16,     6, "Pago cliente.Valor de la divisa"        } )
   aAdd( aPgoCli, { "lCloPgo",  "L",      1,     0, "Pago cliente.Pago cerrado (S/N)"        } )
   aAdd( aPgoCli, { "cCtaRec",  "C",     12,     0, "Pago cliente.Cuenta de contabilidad"    } )
   aAdd( aPgoCli, { "cTurPgo",  "C",      6,     0, "Pago cliente.Sesión"                    } )

RETURN ( aPgoCli )

//---------------------------------------------------------------------------//

function aItmTik()

   local aItmTik  := {}

   aAdd( aItmTik , { "cSerTik",  "C",      1,     0, "Serie del tiket" }                             )
   aAdd( aItmTik , { "cNumTik",  "C",     10,     0, "Número del tiket" }                            )
   aAdd( aItmTik , { "cSufTik",  "C",      2,     0, "Sufijo del tiket" }                            )
   aAdd( aItmTik , { "cTipTik",  "C",      1,     0, "Tipo del documento tiket, albarán o factura" } )
   aAdd( aItmTik , { "cTurTik",  "C",      6,     0, "Sesión del tiket" }                            )
   aAdd( aItmTik , { "dFecTik",  "D",      8,     0, "Fecha del tiket" }                             )
   aAdd( aItmTik , { "cHorTik",  "C",      5,     0, "Hora del tiket" }                              )
   aAdd( aItmTik , { "cCcjTik",  "C",      3,     0, "Código del cajero" }                           )
   aAdd( aItmTik , { "cNcjTik",  "C",      3,     0, "Código de caja" }                              )
   aAdd( aItmTik , { "cAlmTik",  "C",      3,     0, "Código del almacén" }                          )
   aAdd( aItmTik , { "cCliTik",  "C",     12,     0, "Código del cliente" }                          )
   aAdd( aItmTik , { "nTarifa",  "N",      1,     0, "Tarifa de precios" }                           )
   aAdd( aItmTik , { "cNomTik",  "C",     80,     0, "Nombre del cliente" }                          )
   aAdd( aItmTik , { "cDirCli",  "C",    200,     0, "dirección del cliente" }                       )
   aAdd( aItmTik , { "cPobCli",  "C",    200,     0, "Población del cliente" }                       )
   aAdd( aItmTik , { "cPrvCli",  "C",    100,     0, "Provincia del cliente" }                       )
   aAdd( aItmTik , { "nCodProv", "N",      2,     0, "Número de provincia cliente" }                 )
   aAdd( aItmTik , { "cPosCli",  "C",     15,     0, "Código postal del cliente" }                   )
   aAdd( aItmTik , { "cDniCli",  "C",     15,     0, "DNI/Cif del cliente" }                         )
   aAdd( aItmTik , { "lModCli",  "L",      1,     0, "Lógico de modificar datos del cliente" }       )
   aAdd( aItmTik , { "cFpgTik",  "C",      2,     0, "Forma de pago del tiket" }                     )
   aAdd( aItmTik , { "nCobTik",  "N",     16,     6, "Importe cobrado" }                             )
   aAdd( aItmTik , { "nCamTik",  "N",     16,     6, "Devolución" }                                  )
   aAdd( aItmTik , { "cDivTik",  "C",      3,     0, "Código de la divisa" }                         )
   aAdd( aItmTik , { "nVdvTik",  "N",     10,     3, "Valor de la divisa" }                          )
   aAdd( aItmTik , { "lCloTik",  "L",      1,     0, "Lógico de cerrado" }                           )
   aAdd( aItmTik , { "lSndDoc",  "L",      1,     0, "Lógico de enviado" }                           )
   aAdd( aItmTik , { "lPgdTik",  "L",      1,     0, "Lógico de pagado" }                            )
   aAdd( aItmTik , { "cRetPor",  "C",    100,     0, "Retirado por" }                                )
   aAdd( aItmTik , { "cRetMat",  "C",     20,     0, "Matrícula" }                                   )
   aAdd( aItmTik , { "cNumDoc",  "C",     12,     0, "Número del documento" }                        )
   aAdd( aItmTik , { "cCodAge",  "C",      3,     0, "Código del agente" }                           )
   aAdd( aItmTik , { "cCodRut",  "C",      4,     0, "Código de la ruta" }                           )
   aAdd( aItmTik , { "cCodTar",  "C",      5,     0, "Código de la tarifa" }                         )
   aAdd( aItmTik , { "cCodObr",  "C",     10,     0, "Código de la dirección" }                           )
   aAdd( aItmTik , { "nComAge",  "N",      6,     2, "Porcentaje de comisión del agente" }           )
   aAdd( aItmTik , { "lLiqTik",  "L",      1,     0, "Tiket liquidado" }                             )
   aAdd( aItmTik , { "cCodPro",  "C",      9,     0, "Código de proyecto en contabilidad"}           )
   aAdd( aItmTik , { "lConTik",  "L",      1,     0, "Tiket contabilizado" }                         )
   aAdd( aItmTik , { "dFecCre",  "D",      8,     0, "Fecha de creación del documento" }             )
   aAdd( aItmTik , { "cTimCre",  "C",      5,     0, "Hora de creación del documento" }              )
   aAdd( aItmTik , { "lSelDoc",  "L",      1,     0, "" }                                            )
   aAdd( aItmTik , { "cValDoc",  "C",     13,     0, "Número del vale relacionado" }                 )
   aAdd( aItmTik , { "cTurVal",  "C",      6,     0, "Sesión de la liquidación del vale" }            )
   aAdd( aItmTik , { "lCnvTik",  "L",      1,     0, "Lógico para tiket convertido a factura" }      )
   aAdd( aItmTik , { "cCodDlg",  "C",      2,     0, "Código delegación" }                           )
   aAdd( aItmTik , { "cCodGrp",  "C",      4,     0, "Código de grupo de cliente" }                  )
   aAdd( aItmTik , { "cCodSala", "C",      3,     0, "Código de sala" }                              )
   aAdd( aItmTik , { "cPntVenta","C",     30,     0, "Punto de venta" }                              )
   aAdd( aItmTik , { "lAbierto", "L",      1,     0, "Lógico de ticket abierto" }                    )
   aAdd( aItmTik , { "cAliasTik","C",     80,     0, "Alias del tiket" }                             )
   aAdd( aItmTik , { "nNumCom",  "N",      2,     0, "Número de comensales" }                        )

return ( aItmTik )

//---------------------------------------------------------------------------//

function aColTik()

   local aColTik  :={}

   aAdd( aColTik, { "cSerTil",  "C",      1,     0, "Serie del tiket" }                                                        )
   aAdd( aColTik, { "cNumTil",  "C",     10,     0, "Número del tiket" }                                                       )
   aAdd( aColTik, { "cSufTil",  "C",      2,     0, "Sufijo del tiket" }                                                       )
   aAdd( aColTik, { "cTipTil",  "C",      1,     0, "Tipo de documento" }                                                      )
   aAdd( aColTik, { "cCbaTil",  "C",     18,     0, "Código del barras del producto" }                                         )
   aAdd( aColTik, { "cNomTil",  "C",    250,     0, "Nombre del producto" }                                                    )
   aAdd( aColTik, { "nPvpTil",  "N",     16,     6, "Precio de venta del producto" }                                           )
   aAdd( aColTik, { "nUntTil",  "N",     16,     6, "Unidades vendidas del producto" }                                         )
   aAdd( aColTik, { "nUndKit",  "N",     16,     6, "Unidades productos kit" }                                                 )
   aAdd( aColTik, { "nIvaTil",  "N",      5,     2, "Porcentaje de " + cImp() + " del producto" }                                         )
   aAdd( aColTik, { "cFamTil",  "C",      5,     0, "Família la que pertenece el producto" }                                   )
   aAdd( aColTik, { "lOfeTil",  "L",      1,     0, "Oferta ya aplicada" }                                                     )
   aAdd( aColTik, { "cComTil",  "C",     18,     0, "Código de barras de combinado" }                                          )
   aAdd( aColTik, { "cNcmTil",  "C",    100,     0, "Nombre del producto combinado" }                                          )
   aAdd( aColTik, { "nPcmTil",  "N",     16,     6, "Precio de venta del producto combinado" }                                 )
   aAdd( aColTik, { "cFcmTil",  "C",      5,     0, "Familia la que pertenece el producto combinado" }                         )
   aAdd( aColTik, { "lFreTil",  "L",      1,     0, "Lineas sin cargo" }                                                       )
   aAdd( aColTik, { "nDtoLin",  "N",      5,     2, "Descuento en linea",               "'@E 99.9'",         "", "( cDbfCol )" } )
   aAdd( aColTik, { "cCodPr1",  "C",     20,     0, "Código de la primera propiedad",   "",                  "", "( cDbfCol )" } )
   aAdd( aColTik, { "cCodPr2",  "C",     20,     0, "Código de la segunda propiedad",   "",                  "", "( cDbfCol )" } )
   aAdd( aColTik, { "cValPr1",  "C",     20,     0, "Valor de la primera propiedad",    "",                  "", "( cDbfCol )" } )
   aAdd( aColTik, { "cValPr2",  "C",     20,     0, "Valor de la segunda propiedad",    "",                  "", "( cDbfCol )" } )
   aAdd( aColTik, { "nFacCnv",  "N",     16,     6, "Factor de conversión",             "",                  "", "( cDbfCol )" } )
   aAdd( aColTik, { "nDtoDiv",  "N",     16,     6, "Descuento lineal de la compra",    "",                  "", "( cDbfCol )" } )
   aAdd( aColTik, { "lTipAcc",  "L",      1,     0, "",                                 "",                  "", "( cDbfCol )" } )
   aAdd( aColTik, { "nCtlStk",  "N",      1,     0, "",                                 "",                  "", "( cDbfCol )" } )
   aAdd( aColTik, { "cAlmLin",  "C",      3,     0, "Código de almacén en línea",       "",                  "", "( cDbfCol )" } )
   aAdd( aColTik, { "nValImp",  "N",     16,     6, "Importe del impuesto",             "",                  "", "( cDbfCol )" } )
   aAdd( aColTik, { "cCodImp",  "C",      3,     0, "Código de IVMH",                   "",                  "", "( cDbfCol )" } )
   aAdd( aColTik, { "nCosDiv",  "N",     16,     6, "Precio de costo",                  "",                  "", "( cDbfCol )" } )
   aAdd( aColTik, { "nNumLin",  "N",      4,     0, "Número de la línea",               "",                  "", "( cDbfCol )" } )
   aAdd( aColTik, { "lKitArt",  "L",      1,     0, "Línea con escandallo",             "",                  "", "( cDbfCol )" } )
   aAdd( aColTik, { "lKitChl",  "L",      1,     0, "Línea pertenciente a escandallo",  "",                  "", "( cDbfCol )" } )
   aAdd( aColTik, { "lKitPrc",  "L",      1,     0, "",                                 "",                  "", "( cDbfCol )" } )
   aAdd( aColTik, { "lImpLin",  "L",      1,     0, "Imprimir línea",                   "",                  "", "( cDbfCol )" } )
   aAdd( aColTik, { "nMesGrt",  "N",      2,     0, "Meses de garantía",                "'99'",              "", "( cDbfCol )" } )
   aAdd( aColTik, { "lControl", "L",      1,     0, "",                                 "",                  "", "( cDbfCol )" } )
   aAdd( aColTik, { "mNumSer",  "M",     10,     0, "",                                 "",                  "", "( cDbfCol )" } )
   aAdd( aColTik, { "cCodFam",  "C",     16,     0, "Código de familia",                "",                  "", "( cDbfCol )" } )
   aAdd( aColTik, { "cGrpFam",  "C",      3,     0, "Código del grupo de familia",      "",                  "", "( cDbfCol )" } )
   aAdd( aColTik, { "nLote",    "N",      9,     0, "",                                 "@Z 999999999",      "", "( cDbfCol )" } )
   aAdd( aColTik, { "cLote",    "C",     14,     0, "Número de lote",                   "",                  "", "( cDbfCol )" } )
   aAdd( aColTik, { "nNumPgo",  "N",      9,     0, "Número pago cliente",              "",                  "", "( cDbfCol )" } )
   aAdd( aColTik, { "cSufPgo",  "C",      2,     0, "Sufijo pago cliente",              "",                  "", "( cDbfCol )" } )
   aAdd( aColTik, { "nNumMed",  "N",      1,     0, "Número de mediciones",             "MasUnd()",          "", "( cDbfCol )" } )
   aAdd( aColTik, { "nMedUno",  "N",     16,     6, "Primera unidad de medición",       "MasUnd()",          "", "( cDbfCol )" } )
   aAdd( aColTik, { "nMedDos",  "N",     16,     6, "Segunda unidad de medición",       "MasUnd()",          "", "( cDbfCol )" } )
   aAdd( aColTik, { "nMedTre",  "N",     16,     6, "Tercera unidad de medición",       "MasUnd()",          "", "( cDbfCol )" } )
   aAdd( aColTik, { "cCodInv",  "C",      2,     0, "Código invitación",                "",                  "", "( cDbfCol )" } )
   aAdd( aColTik, { "nFcmCnv",  "N",     16,     6, "Factor de conversion para convinados","",               "", "( cDbfCol )" } )
   aAdd( aColTik, { "cCodUsr",  "C",      3,     0, "Código de usuario",                "",                  "", "( cDbfCol )" } )
   aAdd( aColTik, { "lImpCom",  "L",      1,     0, "Lógico para comanda impresa",      "",                  "", "( cDbfCol )" } )
   aAdd( aColTik, { "nImpCom1", "N",      1,     0, "Primera impresora comanda",        "",                  "", "( cDbfCol )" } )
   aAdd( aColTik, { "nImpCom2", "N",      1,     0, "Segunda impresora comanda",        "",                  "", "( cDbfCol )" } )

RETURN ( aColTik )

//---------------------------------------------------------------------------//

FUNCTION nTotTik( cNumTik, cTikT, cTikL, cDiv, aTmp, cDivRet, lPic, lExcCnt )

   local bCond
   local nRecLin
   local nDouDiv
   local cCodDiv
   local nVdvDiv
   local cTipTik
   local nOrdAnt
   local nTotLin     := 0
   local nBasLin     := 0
   local nIvmLin     := 0
   local nNumCom     := 0

   DEFAULT cTikT     := dbfTikT
   DEFAULT cTikL     := dbfTikL
   DEFAULT cDiv      := dbfDiv
   DEFAULT cNumTik   := ( dbfTikT )->cSerTik + ( dbfTikT )->cNumTik + ( dbfTikT )->cSufTik
   DEFAULT lPic      := .f.

   public nTotTik    := 0
   public nTotPax    := 0
   public nTotNet    := 0
   public nTotIva    := 0
   public nTotIvm    := 0
   public aBasTik    := { 0, 0, 0 }
   public aImpTik    := { 0, 0, 0 }
   public aIvaTik    := { nil, nil, nil }
   public aIvmTik    := { 0, 0, 0 }

   nRecLin           := ( cTikL )->( Recno() )

   if aTmp != nil
      cCodDiv        := aTmp[ _CDIVTIK ]
      nVdvDiv        := aTmp[ _NVDVTIK ]
      cTipTik        := aTmp[ _CTIPTIK ]
      nNumCom        := aTmp[ _NNUMCOM ]
      bCond          := {|| !( cTikL )->( eof() ) }
      ( cTikL )->( dbGoTop() )
   else
      cCodDiv        := ( cTikT )->cDivTik
      nVdvDiv        := ( cTikT )->nVdvTik
      cTipTik        := ( cTikT )->cTipTik
      nNumCom        := ( cTikT )->nNumCom
      bCond          := {|| ( cTikL )->cSerTil + ( cTikL )->cNumTil + ( cTikL )->cSufTil == cNumTik .AND. !( cTikL )->( eof() ) }
      nOrdAnt        := ( cTikL )->( OrdSetFocus( "cNumTil" ) )
      ( cTikL )->( dbSeek( cNumTik ) )
   end if

   nDouDiv           := nDouDiv( cCodDiv, cDiv )
   nDorDiv           := nRouDiv( cCodDiv, cDiv ) // Decimales de redondeo
   cPorDiv           := cPorDiv( cCodDiv, cDiv ) // Picture de la divisa redondeada

   while Eval( bCond )

      if lValLine( cTikL ) .and. !( cTikL )->lFreTil

         if ( lExcCnt == nil                                .or.;    // Entran todos
            ( lExcCnt .and. ( cTikL )->nCtlStk != 2 )       .or.;    // Articulos sin contadores
            (!lExcCnt .and. ( cTikL )->nCtlStk == 2 ) )              // Articulos con contadores

            nTotLin     := nTotLTpv( cTikL, nDouDiv, nDorDiv )
            nIvmLin     := nIvmLTpv( cTikL, nDouDiv, nDorDiv )

            if ( cTikL )->nIvaTil != 0
               nBasLin  := nTotLin / ( 1 + ( ( cTikL )->nIvaTil / 100 ) )
            end if

            do case
            case aIvaTik[ 1 ] == nil .or. aIvaTik[ 1 ] == ( cTikL )->nIvaTil

               aIvaTik[ 1 ]   := ( cTikL )->nIvaTil
               aBasTik[ 1 ]   += nBasLin
               aImpTik[ 1 ]   += ( nTotLin - nBasLin )
               aIvmTik[ 1 ]   += nIvmLin

            case aIvaTik[ 2 ] == nil .or. aIvaTik[ 2 ] == ( cTikL )->nIvaTil

               aIvaTik[ 2 ]   := ( cTikL )->nIvaTil
               aBasTik[ 2 ]   += nBasLin
               aImpTik[ 2 ]   += ( nTotLin - nBasLin )
               aIvmTik[ 2 ]   += nIvmLin

            case aIvaTik[ 3 ] == nil .or. aIvaTik[ 3 ] == ( cTikL )->nIvaTil

               aIvaTik[ 3 ]   := ( cTikL )->nIvaTil
               aBasTik[ 3 ]   += nBasLin
               aImpTik[ 3 ]   += ( nTotLin - nBasLin )
               aIvmTik[ 3 ]   += nIvmLin

            end case

            nTotTik           += nTotLin

         end if

      end if

      ( cTikl )->( dbskip() )

   end while


   nTotNet         := aBasTik[ 1 ] + aBasTik[ 2 ] + aBasTik[ 3 ]
   nTotIva         := aImpTik[ 1 ] + aImpTik[ 2 ] + aImpTik[ 3 ]
   nTotIvm         := aIvmTik[ 1 ] + aIvmTik[ 2 ] + aIvmTik[ 3 ]

   /*
   Total en la moneda de documento---------------------------------------------
   */

   nTotPax         := nTotTik / NotCero( nNumCom )
   nTotTik         := Round( nTotTik, nDorDiv )

   /*
   Si nos piden q devolvamos el valor en distinta divisa
   */

   if cDivRet != nil .and. cDivRet != cCodDiv
      nTotNet      := nCnv2Div( nTotNet, cCodDiv, cDivRet )
      nTotIva      := nCnv2Div( nTotIva, cCodDiv, cDivRet )
      nTotIvm      := nCnv2Div( nTotIvm, cCodDiv, cDivRet )
      nTotTik      := nCnv2Div( nTotTik, cCodDiv, cDivRet )
      nTotPax      := nCnv2Div( nTotPax, cCodDiv, cDivRet )
      cPorDiv      := cPorDiv( cDivRet, cDiv ) // Picture de la divisa redondeada
   end if

   /*
   Reposicionamiento-----------------------------------------------------------
   */

   if !Empty( nOrdAnt )
      ( cTikL )->( OrdSetFocus( nOrdAnt ) )
   end if

   ( cTikL )->( dbGoTo( nRecLin ) )

RETURN ( if( lPic, Trans( nTotTik, cPorDiv ), nTotTik ) )

//---------------------------------------------------------------------------//
/*
Devuelve el precio linea
*/

FUNCTION nIvmLTpv( dbfTmpL, nDec, nRou, nVdv )

   local nCalculo    := 0

   DEFAULT dbfTmpL   := dbfTikL
   DEFAULT nDec      := nDouDiv()
   DEFAULT nRou      := nRouDiv()
   DEFAULT nVdv      := 1

   /*
   Siempre q el ticket no sea gratis
   */

   if !( dbfTmpL )->lFreTil
      nCalculo       := ( dbfTmpL )->nValImp                   // Importe del nuevo impuesto
      nCalculo       *= nTotNTpv( dbfTmpL )                    // Unidades
   end if

   if nVdv != 0
      nCalculo       := nCalculo / nVdv
   end if

RETURN ( Round( nCalculo, nRou ) )

//--------------------------------------------------------------------------//

/*
Devuelve el precio linea
*/

FUNCTION nTotLTpv( uTmpL, nDec, nRouDec, nVdv )

   local nCalculo := nTotLUno( uTmpL, nDec, nRouDec, nVdv )
   nCalculo       += nTotLDos( uTmpL, nDec, nRouDec, nVdv )

RETURN ( nCalculo )

//---------------------------------------------------------------------------//

Function nTotLDos( uTmpL, nDec, nRouDec, nVdv )

   local nCalculo    := 0

   DEFAULT uTmpL     := dbfTikL
   DEFAULT nDec      := nDouDiv()
   DEFAULT nRouDec   := nRouDiv()
   DEFAULT nVdv      := 0

   /*
   Siempre q el ticket no sea gratis
   */

   do case
   case ValType( uTmpL ) == "C"

      if !( uTmpL )->lFreTil

         nCalculo    := Round( ( uTmpL )->nPcmTil, nDec )    // Precio
         nCalculo    *= nTotNTpv( uTmpL )                    // Unidades

      end if

   otherwise

      if !uTmpL:lFreTil

         nCalculo    := Round( uTmpL:nPcmTil, nDec )    // Precio
         nCalculo    *= nTotNTpv( uTmpL )                    // Unidades

      end if

   end case

   if nVdv != 0
      nCalculo       := nCalculo / nVdv
   end if

RETURN ( Round( nCalculo, nRouDec ) )

//---------------------------------------------------------------------------//

Function nTotLUno( uTmpL, nDec, nRouDec, nVdv )

   local nCalculo    := 0

   DEFAULT uTmpL     := dbfTikL
   DEFAULT nDec      := nDouDiv()
   DEFAULT nRouDec   := nRouDiv()
   DEFAULT nVdv      := 0

   /*
   Siempre q el ticket no sea gratis
   */

   do case
   case ValType( uTmpL ) == "C"

      if !( uTmpL )->lFreTil

         nCalculo       := Round( ( uTmpL )->nPvpTil, nDec )    // Precio
         nCalculo       -= Round( ( uTmpL )->nDtoDiv, nDec )    // Dto Lineal

         if ( uTmpL )->nDtoLin != 0
            nCalculo    -= ( uTmpL )->nDtoLin * nCalculo / 100  // Dto porcentual
         end if

         nCalculo       *= nTotNTpv( uTmpL )                    // Unidades

      end if

   otherwise

      if !uTmpL:lFreTil

         nCalculo       := Round( uTmpL:nPvpTil, nDec )    // Precio
         nCalculo       -= Round( uTmpL:nDtoDiv, nDec )    // Dto Lineal

         if uTmpL:nDtoLin != 0
            nCalculo    -= uTmpL:nDtoLin * nCalculo / 100  // Dto porcentual
         end if

         nCalculo       *= nTotNTpv( uTmpL )                    // Unidades

      end if

   end case

   if nVdv != 0
      nCalculo          := nCalculo / nVdv
   end if

RETURN ( Round( nCalculo, nRouDec ) )

//---------------------------------------------------------------------------//
/*
Devuelve las unidades de una linea
*/

FUNCTION nTotNTpv( uTmpL, cMasUnd )

   local nTotNTpv

   DEFAULT uTmpL  := dbfTikL

   do case
   case ValType( uTmpL ) == "A"
      nTotNTpv    := uTmpL[ _NUNTTIL ]
      nTotNTpv    *= NotCero( uTmpL[ _NUNDKIT ] )

   case ValType( uTmpL ) == "C"
      nTotNTpv    := ( uTmpL )->nUntTil
      nTotNTpv    *= NotCero( ( uTmpL )->nUndKit )

   otherwise
      nTotnTpv    := uTmpL:nUntTil
      nTotnTpv    *= NotCero( uTmpL:nUndKit )

   end case

RETURN ( if( cMasUnd != nil, Trans( nTotNTpv, cMasUnd ), nTotNTpv ) )