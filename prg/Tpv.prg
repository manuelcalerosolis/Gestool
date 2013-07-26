#include "FiveWin.Ch" 
#include "WebCtl.ch"
#include "Report.ch"
#include "Xbrowse.ch"
#include "FastRepH.ch"

#include "Factu.ch"
#include "DbInfo.ch"

#define CABECERA                 "1"
#define CUERPO                   "2"
#define PIE                      "3"

#define _MENUITEM_               "01063"

#define NUM_BTN_FAM               7
#define NUM_BTN_ART              19

#define FONT_NAME                "Segoe UI" // "Arial" //

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
#define _CALBTIK                   53     //   C     12,     0
#define _CPEDTIK                   54     //   C     12,     0
#define _CPRETIK                   55     //   C     12,     0
#define _CDTOESP                   56
#define _NDTOESP                   57
#define _CDPP                      58
#define _NDPP                      59
#define _NPCTPRM                   60
#define _CTIKVAL                   61     //   C     13,     0
#define _CTLFCLI                   62     //   C     20,     0
#define _LFRETIK                   63
#define _NTOTNET                   64
#define _NTOTIVA                   65
#define _NTOTTIK                   66
#define _LLIQDEV                   67
#define _NUBITIK                   68
#define _NREGIVA                   69

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
#define _NIMPCOM                  53
#define _NIMPCOM1                 54
#define _NIMPCOM2                 55
#define _CCOMENT                  56
#define _CNOMCMD                  57      //   C     20      0
#define _LINPROMO                 58
#define _LARTSERV                 59
#define _CCODTIMP                 60
#define _NORTIMP                  61
#define _CUNIDAD                  62
#define _LDEV                     63
#define _CNUMDEV                  64
#define _NUNDANT                  65
#define _LANULADO                 66
#define _LLINOFE                  67
#define _CIMPCOM1                 68
#define _CIMPCOM2                 69
#define __DFECTIK                 70
#define _NCOSTIL                  71
#define _CTXTINV                  72

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

#define _LCOMANDA                 4
#define _LIMP                     5
#define _DFTIKIMP                 8
#define _CHTIKIMP                 9

#ifndef __PDA__

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
memvar nTotPrm
memvar nTotIvm
memvar aIvaTik
memvar aBrtTik
memvar aBasTik
memvar aImpTik
memvar aIvmTik
memvar nTotBrt
memvar nTotNet
memvar nTotIva
memvar nTotAlb
memvar nTotFac
memvar nTotPax
memvar cCtaCli

memvar nTotDtoEsp
memvar nTotDpp

memvar cDbfAlbCliT
memvar cDbfAlbCliL
memvar cDbfFacCliT
memvar cDbfFacCliL

memvar nTotCos
memvar nTotRnt
memvar nTotPctRnt

static oFr

static nLevel
static oWndBrw
static oWndBig
static dbfClient
static dbfUsr
static dbfCodebar
static dbfCajT
static dbfCajL
static dbfTmpP
static dbfTmpV
static dbfTmpA
static dbfTmpE
static dbfTmpC
static dbfTmpN
static dbfOferta
static dbfTblPro
static dbfFacCliT
static dbfFacCliL
static dbfFacCliS
static dbfFacCliP
static dbfAntCliT
static dbfAlbCliT
static dbfAlbCliL
static dbfAlbCliS
static dbfAlbCliP
static dbfObrasT
static dbfAgent
static dbfTarPreL
static dbfTarPreS
static dbfRuta
static dbfAlm
static dbfDoc
static dbfFlt
static dbfCliAtp
static dbfCajPorta
static dbfAgeCom
static dbfEmp
static dbfArtDiv
static dbfHisMov
static dbfHisMovS
static dbfCategoria
static dbfTemporada

static dbfPedCliT
static dbfPedCliL
static dbfPedCliP

static dbfPreCliT
static dbfPreCliL

static dbfTImp

static oVisor
static oImpresora
static oBalanza
static oInvitacion

static cNewFilP
static cNewFilV
static cNewFilA
static cNewFilE
static cNewFilC
static cNewFilS
static cNewFilN
static oBmpVis
static nOldPvp
static lApartado

static oBandera
static oStock
static oCaptura
static oFideliza

static oMetMsg
static nMetMsg
static oFntTot
static oFntEur
static oFntBrw
static oFntNum
static cFilBmp
static aDim
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
static oBtnVal
static oBtnDev
static oBtnOld
static oBtnUp
static oBtnDown
static oGrupoSerie
static oBtnUpSerie
static oBtnDownSerie
static oBtnAdd
static oBtnEdt
static oBtnDel
static oDlgDet
static oBtnTipoVta

static oCopTik
static lCopTik             := .t.
static nCopTik             := 1
static lRegalo             := .f.

static lMaximized          := .f.

static oTotEsp
static oTotDpp

static oGetRnt
static oSayGetRnt

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

static oTotDiv

static nTotOld

static nSaveMode
static lSave

static oTimerBtn
static oTimer

static cCapCaj
static oNewImp
static oMenu
static nCambioTik          := 0
static nTotalTik           := 0
static cCodArtAnt          := ""
static cCodFamAnt          := ""
static aRecFam             := {}
static lNowAppendLine      := .f.
static aRecArt             := {}
static cOldCodCli          := ""
static cOldCodArt          := ""
static cOldPrpArt          := ""
static oTComandas
static aImpComanda         := {}
static oTipArt
static oFabricante

static lExternal           := .t.
static nNumBtnFam          := NUM_BTN_FAM
static nNumBtnArt          := NUM_BTN_ART
static aTipDoc             := { "Tiket", "Albarán", "Factura", "Devolución", "Apartado", "Vale", "Pda", "Cheque regalo" }
static bEditT              := { |aTmp, aGet, dbfTikT, oBrw, cTot, nTot, nMode, aNumDoc    | EdtRec( aTmp, aGet, dbfTikT, oBrw, cTot, nTot, nMode, aNumDoc ) }
static bEditL              := { |aTmp, aGet, dbfTikL, oBrw, bWhen, bValid, nMode, cNumTik | EdtDet( aTmp, aGet, dbfTikL, oBrw, bWhen, bValid, nMode, cNumTik ) }
static bEditP              := { |aTmp, aGet, dbfTikP, oBrw, bWhen, bValid, nMode, aTmpTik | EdtCob( aTmp, aGet, dbfTikP, oBrw, bWhen, bValid, nMode, aTmpTik ) }
static bEditE              := { |aTmp, aGet, dbfTmpE, oBrw, bWhen, bValid, nMode, aTmpTik | EdtEnt( aTmp, aGet, dbfTmpE, oBrw, bWhen, bValid, nMode, aTmpTik ) }

static oUndMedicion

// #else

static bEdtPdaL            := { |aTmp, aGet, dbfTikL, oBrw, bWhen, bValid, nMode | EdtPdaL( aTmp, aGet, dbfTikL, oBrw, bWhen, bValid, nMode ) }
static nMesa
static nArticulo
static oSayVta
static oSayFPago
static oNumCambio
static cSayVta             :="Sala venta"
static oNumEnt
static cNumEnt             := "0"
static lFilterFav          := .f.
static oSayTik
static nEntCli
static nNumTik
static nZona
static nCurSe
static oCbxSalon
static cZona
static cAlmCtr
static dbfConfig
static nCambioCli

#endif

static dbfTikT
static dbfTikL
static dbfTikP
static dbfTikM
static dbfTikS
static dbfIva
static dbfDiv
static dbfFamilia
static dbfArticulo
static dbfTmpL
static dbfTmpS
static dbfKit
static dbfTblCnv
static dbfCount
static dbfImp
static dbfComentariosT
static dbfComentariosL
static dbfAlbPrvT
static dbfAlbPrvL
static dbfAlbPrvS
static dbfFacPrvT
static dbfFacPrvL
static dbfFacPrvS
static dbfRctPrvT
static dbfRctPrvL
static dbfRctPrvS
static dbfFacRecT
static dbfFacRecL
static dbfFacRecS

static cNewFilL

static lOpenFiles          := .f.

static cPouDiv
static cPorDiv
static nDouDiv
static nDorDiv
static cPicEur
static cPicUnd

static oTxtTot
static oNumTot
static oTotPdaFam
static oTxtCom
static oTotCom
static oEurTot

static oDlgTpv

static dbfFPago

static aButtonsPago
static aButtonsMoney       := Array( 16 )

static lStopEntCont        := .f.
static lStopEntContLine    := .f.

static lShowBrwLin         := .f.
static lShowBrwFam         := .f.

static lSaveNewTik         := .f.
static lTwoLin             := .f.

static nScreenHorzRes
static nScreenVertRes

//---------------------------------------------------------------------------//

#ifndef __PDA__

//----------------------------------------------------------------------------//

STATIC FUNCTION OpenFiles( cPatEmp, lExt, lTactil )

   local oError
   local oBlock
   local cVisor
   local cCajon
   local cFiltro
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

      DisableAcceso()

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

      USE ( cPatEmp + "TIKEM.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIKEM", @dbfTikM ) )
      SET ADSINDEX TO ( cPatEmp + "TIKEM.CDX" ) ADDITIVE

      USE ( cPatEmp + "TIKES.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIKES", @dbfTikS ) )
      SET ADSINDEX TO ( cPatEmp + "TIKES.CDX" ) ADDITIVE

      USE ( cPatCli() + "CLIENT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CLIENT", @dbfClient ) )
      SET ADSINDEX TO ( cPatCli() + "CLIENT.CDX" ) ADDITIVE

      USE ( cPatDat() + "Cajas.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CAJAS", @dbfCajT ) )
      SET ADSINDEX TO ( cPatDat() + "Cajas.Cdx" ) ADDITIVE

      USE ( cPatDat() + "CajasL.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CAJASL", @dbfCajL ) )
      SET ADSINDEX TO ( cPatDat() + "CajasL.Cdx" ) ADDITIVE

      USE ( cPatDat() + "USERS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "USERS", @dbfUsr ) )
      SET ADSINDEX TO ( cPatDat() + "USERS.CDX" ) ADDITIVE

      USE ( cPatArt() + "ARTICULO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ARTICULO", @dbfArticulo ) )
      SET ADSINDEX TO ( cPatArt() + "ARTICULO.CDX" ) ADDITIVE

      USE ( cPatArt() + "ArtCodebar.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CODEBAR", @dbfCodebar ) )
      SET ADSINDEX TO ( cPatArt() + "ArtCodebar.Cdx" ) ADDITIVE

      USE ( cPatArt() + "ARTKIT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ARTTIK", @dbfKit ) )
      SET ADSINDEX TO ( cPatArt() + "ARTKIT.CDX" ) ADDITIVE

      USE ( cPatGrp() + "OFERTA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "OFERTA", @dbfOferta ) )
      SET ADSINDEX TO ( cPatGrp() + "OFERTA.CDX" ) ADDITIVE

      USE ( cPatGrp() + "FPAGO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FPAGO", @dbfFPago ) )
      SET ADSINDEX TO ( cPatGrp() + "FPago.Cdx" ) ADDITIVE

      USE ( cPatGrp() + "TBLPRO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TBLPRO", @dbfTblPro ) )
      SET ADSINDEX TO ( cPatGrp() + "TBLPRO.CDX" ) ADDITIVE

      USE ( cPatGrp() + "FAMILIAS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FAMILIAS", @dbfFamilia ) )
      SET ADSINDEX TO ( cPatGrp() + "FAMILIAS.CDX" ) ADDITIVE

      USE ( cPatEmp + "ALBCLIT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALBCLIT", @dbfAlbCliT ) )
      SET ADSINDEX TO ( cPatEmp + "ALBCLIT.CDX" ) ADDITIVE

      USE ( cPatEmp + "ALBCLIL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALBCLIL", @dbfAlbCliL ) )
      SET ADSINDEX TO ( cPatEmp + "ALBCLIL.CDX" ) ADDITIVE

      USE ( cPatEmp + "ALBCLIS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALBCLIS", @dbfAlbClis ) )
      SET ADSINDEX TO ( cPatEmp + "ALBCLIS.CDX" ) ADDITIVE

      USE ( cPatEmp() + "ALBCLIP.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALBCLIP", @dbfAlbCliP ) )
      SET ADSINDEX TO ( cPatEmp() + "ALBCLIP.CDX" ) ADDITIVE

      USE ( cPatEmp + "FACCLIT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACCLIT", @dbfFacCliT ) )
      SET ADSINDEX TO ( cPatEmp + "FACCLIT.CDX" ) ADDITIVE

      USE ( cPatEmp + "FACCLIL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACCLIL", @dbfFacCliL ) )
      SET ADSINDEX TO ( cPatEmp + "FACCLIL.CDX" ) ADDITIVE

      USE ( cPatEmp + "FACCLIS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACCLIS", @dbfFacCliS ) )
      SET ADSINDEX TO ( cPatEmp + "FACCLIS.CDX" ) ADDITIVE

      USE ( cPatEmp + "FACCLIP.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACCLIP", @dbfFacCliP ) )
      SET ADSINDEX TO ( cPatEmp + "FACCLIP.CDX" ) ADDITIVE

      USE ( cPatEmp + "AntCliT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "AntCliT", @dbfAntCliT ) )
      SET ADSINDEX TO ( cPatEmp + "AntCliT.CDX" ) ADDITIVE

      USE ( cPatCli() + "ObrasT.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "OBRAST", @dbfObrasT ) )
      SET ADSINDEX TO ( cPatCli() + "ObrasT.Cdx" ) ADDITIVE

      USE ( cPatCli() + "AGENTES.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "AGENTES", @dbfAgent ) )
      SET ADSINDEX TO ( cPatCli() + "AGENTES.CDX" ) ADDITIVE

      USE ( cPatGrp() + "RUTA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "RUTA", @dbfRuta ) )
      SET ADSINDEX TO ( cPatGrp() + "RUTA.CDX" ) ADDITIVE

      USE ( cPatAlm() + "ALMACEN.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALMACEN", @dbfAlm ) )
      SET ADSINDEX TO ( cPatAlm() + "ALMACEN.CDX" ) ADDITIVE

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

      USE ( cPatDat() + "CNFFLT.DBF" ) NEW SHARED VIA ( cDriver() ) ALIAS ( cCheckArea( "CNFFLT", @dbfFlt ) )
      SET ADSINDEX TO ( cPatDat() + "CNFFLT.CDX" ) ADDITIVE

      USE ( cPatGrp() + "AGECOM.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "AGECOM", @dbfAgeCom ) )
      SET ADSINDEX TO ( cPatGrp() + "AGECOM.CDX" ) ADDITIVE

      USE ( cPatDat() + "EMPRESA.DBF" ) NEW SHARED VIA ( cDriver() ) ALIAS ( cCheckArea( "EMPRESA", @dbfEmp ) )
      SET ADSINDEX TO ( cPatDat() + "EMPRESA.CDX" ) ADDITIVE

      USE ( cPatDat() + "TBLCNV.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TBLCNV", @dbfTblCnv ) )
      SET ADSINDEX TO ( cPatDat() + "TBLCNV.CDX" ) ADDITIVE

      USE ( cPatEmp() + "PEDCLIL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PEDCLIL", @dbfPedCliL ) )
      SET ADSINDEX TO ( cPatEmp() + "PEDCLIL.CDX" ) ADDITIVE

      USE ( cPatEmp() + "PEDCLIP.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PEDCLIP", @dbfPedCliP ) )
      SET ADSINDEX TO ( cPatEmp() + "PEDCLIP.CDX" ) ADDITIVE

      if !TDataCenter():OpenPreCliT( @dbfPreCliT ) 
         lOpenFiles     := .f.
      end if 

      USE ( cPatEmp() + "PRECLIL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PRECLIL", @dbfPreCliL ) )
      SET ADSINDEX TO ( cPatEmp() + "PRECLIL.CDX" ) ADDITIVE

      USE ( cPatEmp() + "FACRECT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACRECT", @dbfFacRecT ) )
      SET ADSINDEX TO ( cPatEmp() + "FACRECT.CDX" ) ADDITIVE

      USE ( cPatEmp() + "FACRECL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACRECL", @dbfFacRecL ) )
      SET ADSINDEX TO ( cPatEmp() + "FACRECL.CDX" ) ADDITIVE

      USE ( cPatEmp() + "FACRECS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACRECS", @dbfFacRecS ) )
      SET ADSINDEX TO ( cPatEmp() + "FACRECS.CDX" ) ADDITIVE

      USE ( cPatEmp() + "ALBPROVT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALBPROVT", @dbfAlbPrvT ) )
      SET ADSINDEX TO ( cPatEmp() + "ALBPROVT.CDX" ) ADDITIVE

      USE ( cPatEmp() + "ALBPROVL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALBPROVL", @dbfAlbPrvL ) )
      SET ADSINDEX TO ( cPatEmp() + "ALBPROVL.CDX" ) ADDITIVE

      USE ( cPatEmp() + "AlbPrvS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "AlbPrvS", @dbfAlbPrvS ) )
      SET ADSINDEX TO ( cPatEmp() + "AlbPrvS.CDX" ) ADDITIVE

      USE ( cPatEmp() + "FACPRVT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACPRVT", @dbfFacPrvT ) )
      SET ADSINDEX TO ( cPatEmp() + "FACPRVT.CDX" ) ADDITIVE

      USE ( cPatEmp() + "FACPRVL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACPRVL", @dbfFacPrvL ) )
      SET ADSINDEX TO ( cPatEmp() + "FACPRVL.CDX" ) ADDITIVE

      USE ( cPatEmp() + "FACPRVS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACPRVS", @dbfFacPrvS ) )
      SET ADSINDEX TO ( cPatEmp() + "FACPRVS.CDX" ) ADDITIVE

      USE ( cPatEmp() + "RctPrvT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "RctPrvT", @dbfRctPrvT ) )
      SET ADSINDEX TO ( cPatEmp() + "RctPrvT.CDX" ) ADDITIVE

      USE ( cPatEmp() + "RctPrvL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "RctPrvL", @dbfRctPrvL ) )
      SET ADSINDEX TO ( cPatEmp() + "RctPrvL.CDX" ) ADDITIVE

      USE ( cPatEmp() + "RctPrvS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "RctPrvS", @dbfRctPrvS ) )
      SET ADSINDEX TO ( cPatEmp() + "RctPrvS.CDX" ) ADDITIVE

      USE ( cPatEmp() + "HISMOV.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "HISMOV", @dbfHisMov ) )
      SET ADSINDEX TO ( cPatEmp() + "HISMOV.CDX" ) ADDITIVE

      USE ( cPatEmp() + "MOVSER.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "MOVSER", @dbfHisMovS ) )
      SET ADSINDEX TO ( cPatEmp() + "MOVSER.CDX" ) ADDITIVE

      USE ( cPatArt() + "CATEGORIAS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CATEGORIA", @dbfCategoria ) )
      SET ADSINDEX TO ( cPatArt() + "CATEGORIAS.CDX" ) ADDITIVE

      USE ( cPatArt() + "COMENTARIOST.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "COMENTT", @dbfComentariosT ) )
      SET ADSINDEX TO ( cPatArt() + "COMENTARIOST.CDX" ) ADDITIVE

      USE ( cPatArt() + "COMENTARIOSL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "COMENTL", @dbfComentariosL ) )
      SET ADSINDEX TO ( cPatArt() + "COMENTARIOSL.CDX" ) ADDITIVE
      SET TAG TO "CCODDES"

      USE ( cPatDat() + "TIPIMP.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIPIMP", @dbfTImp ) )
      SET ADSINDEX TO ( cPatDat() + "TIPIMP.CDX" ) ADDITIVE

      USE ( cPatArt() + "Temporadas.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "Temporada", @dbfTemporada ) )
      SET ADSINDEX TO ( cPatArt() + "Temporadas.Cdx" ) ADDITIVE

      if !TDataCenter():OpenPedCliT( @dbfPedCliT )
         lOpenFiles        := .f.
      end if 

      oCaptura             := TCaptura():New( cPatDat() )
      oCaptura:OpenFiles()

      oTComandas           := TComandas():Create( cPatArt() )
      oTComandas:OpenFiles()

      oBandera             := TBandera():New()

      oStock               := TStock():Create( cPatGrp() )
      if !oStock:lOpenFiles()
         lOpenFiles        := .f.
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

      cImpresora           := cImpresoraTicketEnCaja( oUser():cCaja(), dbfCajT )
      if !Empty( cImpresora )
         oImpresora        := TImpresoraTiket():Create( cImpresora )
      end if

      oUndMedicion         := UniMedicion():Create( cPatGrp() )
      if !oUndMedicion:OpenFiles()
         lOpenFiles        := .f.
      end if

      cBalanza             := cBalanzaEnCaja( oUser():cCaja(), dbfCajT )
      if !Empty( cBalanza )
         oBalanza          := TCommPort():Create( cBalanza )
      end if

      oInvitacion          := TInvitacion():Create( cPatGrp() )
      if !oInvitacion:OpenFiles()
         lOpenFiles        := .f.
      end if

      oFideliza            := TFideliza():CreateInit( cPatArt() )
      if !oFideliza:OpenFiles()
         lOpenFiles        := .f.
      end if

      oTipArt              := TTipArt():Create( cPatArt() )
      if !oTipArt:OpenFiles()
         lOpenFiles        := .f.
      end if

      oFabricante          := TFabricantes():Create( cPatArt() )
      if !oFabricante:OpenFiles()
         lOpenFiles        := .f.
      end if

      /*
      Creamos los botones para las formas de pago---------------------------------
      */

      aButtonsPago         := aCreateButtons( dbfFPago )

      /*
      Pictures--------------------------------------------------------------------
      */

      cPouDiv              := cPouDiv( cDivEmp(), dbfDiv )        // Picture de la divisa
      cPorDiv              := cPorDiv( cDivEmp(), dbfDiv )        // Picture de la divisa redondeada
      cPicEur              := cPorDiv( cDivChg(), dbfDiv )        // Picture de la divisa equivalente
      nDouDiv              := nDouDiv( cDivEmp(), dbfDiv )        // .Decimales
      nDorDiv              := nRouDiv( cDivEmp(), dbfDiv )        // Decimales redondeados

      cPicUnd              := MasUnd()

      public nTotTik       := 0
      public nTotPrm       := 0
      public nTotPax       := 0
      public nTotDtoEsp    := 0
      public nTotDpp       := 0
      public nTotBrt       := 0
      public nTotNet       := 0
      public nTotIva       := 0
      public nTotIvm       := 0
      public aBrtTik       := { 0, 0, 0 }
      public aBasTik       := { 0, 0, 0 }
      public aImpTik       := { 0, 0, 0 }
      public aIvaTik       := { nil, nil, nil }
      public aIvmTik       := { 0, 0, 0 }
      public nTotCos       := 0
      public nTotRnt       := 0
      public nTotPctRnt    := 0

      nScreenHorzRes       := GetSysMetrics( 0 )
      nScreenVertRes       := GetSysMetrics( 1 )

      /*
      Limitaciones de cajero y cajas--------------------------------------------------------
      */

      if lAIS() .and. !oUser():lAdministrador()
      
         cFiltro           := "Field->cSufTik == '" + oUser():cDelegacion() + "' .and. Field->cNcjTik == '" + oUser():cCaja() + "'"
         if oUser():lFiltroVentas()         
            cFiltro        += " .and. Field->cCcjTik == '" + oUser():cCodigo() + "'"
         end if 

         ( dbfTikT )->( AdsSetAOF( cFiltro ) )
      end if

      EnableAcceso()

   RECOVER USING oError

      lOpenFiles           := .f.

      EnableAcceso()

      msgStop( ErrorMessage( oError ), "Imposible abrir las bases de datos de terminal punto de venta" )

   END SEQUENCE

   ErrorBlock( oBlock )

   if !lOpenFiles
      CloseFiles()
   end if

RETURN ( lOpenFiles )

//----------------------------------------------------------------------------//

STATIC FUNCTION CloseFiles()

   DisableAcceso()

   DestroyFastFilter( dbfTikT, .t., .t. )

   CLOSE ( dbfTikT     )
   CLOSE ( dbfTikL     )
   CLOSE ( dbfTikP     )
   CLOSE ( dbfTikM     )
   CLOSE ( dbfTikS     )
   CLOSE ( dbfClient   )
   CLOSE ( dbfCajT     )
   CLOSE ( dbfCajL     )
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
   CLOSE ( dbfCategoria)
   CLOSE ( dbfTemporada)

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
   CLOSE ( dbfFlt      )
   CLOSE ( dbfAgeCom   )
   CLOSE ( dbfEmp      )
   CLOSE ( dbfAlbCliP  )
   CLOSE ( dbfTblCnv   )

   CLOSE ( dbfPreCliT  )
   CLOSE ( dbfPreCliL  )
   CLOSE ( dbfPedCliT  )
   CLOSE ( dbfPedCliL  )
   CLOSE ( dbfPedCliP  )
   CLOSE ( dbfAlbCliT  )
   CLOSE ( dbfAlbCliL  )
   CLOSE ( dbfAlbCliS  )

   CLOSE ( dbfFacCliT  )
   CLOSE ( dbfFacCliL  )
   CLOSE ( dbfFacCliS  )
   CLOSE ( dbfFacCliP  )

   CLOSE ( dbfFacRecT  )
   CLOSE ( dbfFacRecL  )
   CLOSE ( dbfFacRecS  )

   CLOSE ( dbfAntCliT  )

   CLOSE ( dbfAlbPrvT  )
   CLOSE ( dbfAlbPrvL  )
   CLOSE ( dbfAlbPrvS  )

   CLOSE ( dbfFacPrvT  )
   CLOSE ( dbfFacPrvL  )
   CLOSE ( dbfFacPrvS  )

   CLOSE ( dbfRctPrvT  )
   CLOSE ( dbfRctPrvL  )
   CLOSE ( dbfRctPrvS  )

   CLOSE ( dbfHisMov   )
   CLOSE ( dbfHisMovS  )

   CLOSE ( dbfComentariosT )
   CLOSE ( dbfComentariosL )

   CLOSE ( dbfTImp     )

   if !Empty( oCaptura )
      oCaptura:End()
   end if

   if !Empty( oTComandas )
      oTComandas:End()
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

   if !Empty( oImpresora )
      oImpresora:End()
   end if

   if !Empty( oBalanza )
      oBalanza:End()
   end if

   if !Empty( oUndMedicion )
      oUndMedicion:end()
   end if

   if !Empty( oInvitacion )
      oInvitacion:End()
   end if

   if !Empty( oFideliza )
      oFideliza:End()
   end if

   if !Empty( oTipArt )
      oTipArt:End()
   end if

   if !Empty( oFabricante )
      oFabricante:End()
   end if

   dbfTikT           := nil
   dbfTikL           := nil
   dbfTikM           := nil
   dbfTikS           := nil
   dbfClient         := nil
   dbfCajT           := nil
   dbfCajL           := nil
   dbfUsr            := nil
   dbfFPago          := nil
   dbfArticulo       := nil
   dbfCodebar        := nil
   dbfKit            := nil
   dbfIva            := nil
   dbfCount          := nil
   dbfOferta         := nil
   dbfDiv            := nil
   oBandera          := nil
   dbfTarPreS        := nil
   dbfTarPreL        := nil
   dbfTblPro         := nil
   dbfFamilia        := nil
   dbfAlbCliT        := nil
   dbfAlbCliL        := nil
   dbfFacCliT        := nil
   dbfFacCliL        := nil
   dbfFacCliS        := nil
   dbfFacCliP        := nil
   dbfObrasT         := nil
   dbfAgent          := nil
   dbfRuta           := nil
   dbfAlm            := nil
   dbfArtDiv         := nil
   dbfDoc            := nil
   dbfCliAtp         := nil
   dbfFlt            := nil
   dbfAgeCom         := nil
   dbfEmp            := nil
   dbfAlbCliP        := nil
   dbfTblCnv         := nil
   dbfTImp           := nil

   dbfPreCliT        := nil
   dbfPreCliL        := nil
   dbfPedCliT        := nil
   dbfPedCliL        := nil
   dbfPedCliP        := nil
   dbfFacRecT        := nil
   dbfFacRecL        := nil

   dbfAlbPrvT        := nil
   dbfAlbPrvL        := nil
   dbfAlbPrvS        := nil
   dbfFacPrvT        := nil
   dbfFacPrvL        := nil
   dbfRctPrvT        := nil
   dbfRctPrvL        := nil

   dbfHisMov         := nil
   dbfHisMovS        := nil

   oStock            := nil
   oCaptura          := nil
   oTComandas        := nil
   oNewImp           := nil
   oVisor            := nil
   oImpresora        := nil
   oInvitacion       := nil
   oTipArt           := nil
   oFabricante       := nil

   oFideliza         := nil

   oWndBrw           := nil
   oWndBig           := nil

   oOfficeBar        := nil

   dbfComentariosT   := nil
   dbfComentariosL   := nil

   if !Empty( oFr )
      oFr:DestroyFr()
      oFr            := nil 
   end if

   lOpenFiles        := .f.

   EnableAcceso()

   if lTactilMode() .or. lTpvMode()
      PostQuitMessage()
   end if

Return .t.

//----------------------------------------------------------------------------//

FUNCTION FrontTpv( oMenuItem, oWnd, cCodCli, cCodArt, lEntCon, lExtTpv, aNumDoc )

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
   DEFAULT  lExtTpv     := .f.
   DEFAULT  aNumDoc     := { "", "", "" }

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

   DisableAcceso()

   /*
   Creacion del objeto report--------------------------------------------------
   */

   oFr                  := frReportManager():New()
   oFr:LoadLangRes(     "Spanish.Xml" )

   oFr:SetEventHandler( "Designer", "OnSaveReport", {|| oFr:SaveToBlob( ( dbfDoc )->( Select() ), "mReport" ) } )

   /*
   Zona de datos---------------------------------------------------------------
   */

   DataReport( oFr )

   /*
   Compruebo si hay turnos abiertos--------------------------------------------
   */

   cTitle      := "T.P.V. - Sesión: " + Alltrim( Trans( cCurSesion(), "######" ) ) + " - " + dtoc( date() )

   /*
   Anotamos el movimiento para el navegador------------------------------------
   */

   AddMnuNext( "T.P.V.", ProcName() )

   DEFINE SHELL oWndBrw FROM 0, 0 TO 22, 80 ;
      XBROWSE ;
      TITLE    cTitle ;
      PROMPTS  "Número",;
					"Fecha",;
               "Caja",;
               "Cajero",;
               "Código",;
               "Nombre",;
               "Sesión" ;
      MRU      "Cashier_user1_16";
      BITMAP   clrTopTPV ;
      ALIAS    ( dbfTikT );
      APPEND   ( TpvAppRec( oWndBrw:oBrw, bEditT, dbfTikT, oWnd, cCodCli, cCodArt, aNumDoc ) );
      DELETE   ( WinDelRec( oWndBrw:oBrw, dbfTikT, {|| TpvDelRec() } ) );
      ZOOM     ( WinZooRec( oWndBrw:oBrw, bEditT, dbfTikT ) );
      EDIT     ( WinEdtRec( oWndBrw:oBrw, bEditT, dbfTikT ) );
      LEVEL    nLevel ;
      OF       oWnd

      oWndBrw:lAutoSeek     := .f.
      oWndBrw:lFechado      := .t.

	  oWndBrw:SetYearComboBoxChange( {|| YearComboBoxChange() } )

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Sesión cerrada"
         :nHeadBmpNo       := 3
         :bStrData         := {|| "" }
         :bEditValue       := {|| ( dbfTikT )->lCloTik }
         :nWidth           := 20
         :SetCheck( { "Sel16", "Nil16" } )
         :AddResource( "Zoom16" )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Cobrado"
         :nHeadBmpNo       := 4
         :bStrData         := {|| "" }
         :bBmpData         := {|| nChkalizer( ( dbfTikT)->cSerTik + ( dbfTikT )->cNumTik + ( dbfTikT )->cSufTik, dbfTikT, dbfTikL, dbfTikP, dbfFacCliT, dbfFacCliL, dbfFacCliP, dbfIva, dbfDiv, if( lEur, cDivChg(), cDivEmp() ) ) }
         :nWidth           := 20
         :AddResource( "Bullet_Square_Green_16" )
         :AddResource( "Bullet_Square_Yellow_16" )
         :AddResource( "Bullet_Square_Red_16" )
         :AddResource( "ChgPre16" )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Contabilizado"
         :nHeadBmpNo       := 3
         :bStrData         := {|| "" }
         :bEditValue       := {|| ( dbfTikT )->lConTik }
         :nWidth           := 20
         :SetCheck( { "Sel16", "Nil16" } )
         :AddResource( "BmpConta16" )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Envio"
         :nHeadBmpNo       := 3
         :bStrData         := {|| "" }
         :bEditValue       := {|| ( dbfTikT )->lSndDoc }
         :nWidth           := 20
         :SetCheck( { "Sel16", "Nil16" } )
         :AddResource( "Lbl16" )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Documento"
         :bEditValue       := {|| aTipTik() }
         :nWidth           := 60
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Número"
         :cSortOrder       := "cNumTik"
         :bEditValue       := {|| ( dbfTikT )->cSerTik + "/" + lTrim( ( dbfTikT )->cNumTik ) }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Delegación"
         :bEditValue       := {|| ( dbfTikT )->cSufTik } // ( dbfTikT )->cCodDlg }
         :nWidth           := 40
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Sesión"
         :cSortOrder       := "cTurTik"
         :bEditValue       := {|| Trans( ( dbfTikT )->cTurTik, "######" ) }
         :nWidth           := 40
         :lHide            := .t.
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
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
         :cSortOrder       := "cNcjTik"
         :bEditValue       := {|| ( dbfTikT )->cNcjTik }
         :nWidth           := 40
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Cajero"
         :cSortOrder       := "cCcjTik"
         :bEditValue       := {|| ( dbfTikT )->cCcjTik }
         :nWidth           := 40
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Código"
         :cSortOrder       := "cCliTik"
         :bEditValue       := {|| AllTrim( ( dbfTikT )->cCliTik ) }
         :nWidth           := 70
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Nombre"
         :cSortOrder       := "cNomTik"
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
         :cHeader          := "Base"
         :bEditValue       := {|| ( dbfTikT )->nTotNet }
         :cEditPicture     := cPorDiv( ( dbfTikT )->cDivTik, dbfDiv )
         :nWidth           := 80
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := cImp()
         :bEditValue       := {|| ( dbfTikT )->nTotIva }
         :cEditPicture     := cPorDiv( ( dbfTikT )->cDivTik, dbfDiv )
         :nWidth           := 80
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Total"
         :bEditValue       := {|| ( dbfTikT )->nTotTik }
         :cEditPicture     := cPorDiv( ( dbfTikT )->cDivTik, dbfDiv )
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

if !lExtTpv

      DEFINE BTNSHELL RESOURCE "DEL" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( LqdVale( oWndBrw ) );
         TOOLTIP  "Liquidar vale" ;
         FROM     oDel ;
         CLOSED ;
         LEVEL    ACC_DELE

end if

   DEFINE BTNSHELL oPrv RESOURCE "IMP" GROUP OF oWndBrw ;
      NOBORDER ;
      ACTION   ( ImpTiket( .f., .f., .t. ) ) ;
      TOOLTIP  "(I)mprimir";
      MESSAGE  "Imprimir tiket" ;
      HOTKEY   "I";
      LEVEL    ACC_IMPR

if lExtTpv

   DEFINE BTNSHELL RESOURCE "UP" GROUP OF oWndBrw ;
      NOBORDER ;
      ACTION   ( oWndBrw:oBrw:GoUp(), oWndBrw:oBrw:Select(0), oWndBrw:oBrw:Select(1), oWndBrw:oBrw:Refresh() ) ;
      TOOLTIP  "S(u)bir" ;
      HOTKEY   "U"

   DEFINE BTNSHELL RESOURCE "DOWN" GROUP OF oWndBrw ;
      NOBORDER ;
      ACTION   ( oWndBrw:oBrw:GoDown(), oWndBrw:oBrw:Select(0), oWndBrw:oBrw:Select(1), oWndBrw:oBrw:Refresh() ) ;
      TOOLTIP  "(B)ajar" ;
      HOTKEY   "B"

else

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

   DEFINE BTNSHELL RESOURCE "BMPCONTA" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( DlgCntTicket( dbfTikT, dbfTikL, dbfTikP, dbfClient, dbfArticulo, dbfFPago, dbfDiv, oWndBrw ) );
      TOOLTIP  "Co(n)tabilizar" ;
      HOTKEY   "N";
      LEVEL    ACC_EDIT

   if oUser():lAdministrador()

      DEFINE BTNSHELL RESOURCE "CHGSTATE" OF oWndBrw GROUP;
         NOBORDER ;
         ACTION   ContTpv( dbfTikT, oWndBrw:oBrw );
         TOOLTIP  "Cambiar esta(d)o" ;
         HOTKEY   "D";
         LEVEL    ACC_EDIT

   end if

   DEFINE BTNSHELL oSnd RESOURCE "LBL" OF oWndBrw ;
      NOBORDER ;
      MENU     This:Toggle() ;
      ACTION   lSnd( oWndBrw, dbfTikT ) ;
      TOOLTIP  "En(v)iar" ;
      HOTKEY   "V";
      LEVEL    ACC_EDIT

      DEFINE BTNSHELL RESOURCE "LBL" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( lSelectAll( oWndBrw, dbfTikT, "lSndDoc", .t., .t., .t. ) );
         TOOLTIP  "Todos" ;
         FROM     oSnd ;
         CLOSED ;
         LEVEL    ACC_EDIT

      DEFINE BTNSHELL RESOURCE "LBL" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( lSelectAll( oWndBrw, dbfTikT, "lSndDoc", .f., .t., .t. ) );
         TOOLTIP  "Ninguno" ;
         FROM     oSnd ;
         CLOSED ;
         LEVEL    ACC_EDIT

      DEFINE BTNSHELL RESOURCE "LBL" OF oWndBrw ;
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

   DEFINE BTNSHELL RESOURCE "INFO" GROUP OF oWndBrw ;
      NOBORDER ;
      ACTION   ( TTrazaDocumento():Activate( TIK_CLI, ( dbfTikT )->cSerTik + ( dbfTikT )->cNumTik + ( dbfTikT )->cSufTik ) ) ;
      TOOLTIP  "I(n)forme documento" ;
      HOTKEY   "N" ;
      LEVEL    ACC_EDIT

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
      ACTION   ( oWndBrw:End() ) ;
      TOOLTIP  "(S)alir";
      HOTKEY   "S"

end if

   if !oUser():lFiltroVentas()
      oWndBrw:oActiveFilter:aTField       := aItmTik()
      oWndBrw:oActiveFilter:cDbfFilter    := dbfFlt
      oWndBrw:oActiveFilter:cTipFilter    := TIK_CLI
   end if

   ACTIVATE SHELL oWndBrw VALID ( CloseFiles() )

   EnableAcceso()

   if !Empty( cCodCli ) .or. !Empty( cCodArt ) .or. lEntCon .or. !Empty( aNumDoc )

      if !Empty( oWndBrw )
         oWndBrw:RecAdd()
      end if

      cCodCli  := nil
      cCodArt  := nil
      aNumDoc  := { "", "", "" }

   end if

Return .t.

//----------------------------------------------------------------------------//

Static Function TpvAppRec( oWndBrw, bEditT, dbfTikT, oWnd, cCodCli, cCodArt, aNumDoc )

   while ( WinAppRec( oWndBrw, bEditT, dbfTikT, cCodCli, cCodArt, aNumDoc ) )

      if lStopEntCont

         Return ( .t. )

      end if

   end while

   // ( dbfTikT )->( dbGoBottom() )

   oWndBrw:Select( 0 )
   oWndBrw:Select( 1 )

Return ( .t. )

//---------------------------------------------------------------------------//

Static Function ImpTiket( lPrev, lEntrega, lImpMenu, dbfImp, oDatos )

   local oPrnTik
   local nCopClient
   local nNumTik

   DEFAULT lPrev        := .f.
   DEFAULT lEntrega     := .f.
   DEFAULT lImpMenu     := .f.

   if Empty( oDatos )
      oDatos            := TFormatosImpresion():Load( dbfCajT )
   end if

   nCopClient           := Max( Retfld( ( dbfTikT )->cCliTik, dbfClient, "CopiasF" ), 1 )

   /*
   Obtenemos el numero de copias que vamos a imprimir
   ----------------------------------------------------------------------------
   */

   if lPrev

      nCopTik           := 1

   else

      if lCopTik

         nCopTik        := nCopiasTipoTicket( ( dbfTikT )->cTipTik, lEntrega, dbfCajT )

         if lImpMenu .and. nCopTik == 0
            nCopTik     := 1
         end if

      end if

   end if

   /*
   Llamamos a la funcion de impresion en cada uno de los casos
   ----------------------------------------------------------------------------
   */

   do case
      case ( dbfTikT )->cTipTik == SAVTIK

         do case
            case ( lRegalo )

               nGenTikCli( if( lPrev, IS_SCREEN, IS_PRINTER ), "Imprimiendo tickets", oDatos:cFormatoRegalo, oDatos:cPrinterRegalo )

               lRegalo  := .f.

            case ( lEntrega )

               nGenTikCli( if( lPrev, IS_SCREEN, IS_PRINTER ), "Imprimiendo tickets", oDatos:cFormatoEntrega, oDatos:cPrinterEntrega )

            otherwise

               nGenTikCli( if( lPrev, IS_SCREEN, IS_PRINTER ), "Imprimiendo tickets", oDatos:cFormatoTiket, oDatos:cPrinterTik )

         end case

      case ( dbfTikT )->cTipTik == SAVVAL

         if ( dbfTikT )->lFreTik

            nGenTikCli( if( lPrev, IS_SCREEN, IS_PRINTER ), "Imprimiendo cheques regalo", oDatos:cFmtTikChk, oDatos:cPrinterTikChk )

         else

            nGenTikCli( if( lPrev, IS_SCREEN, IS_PRINTER ), "Imprimiendo vales", oDatos:cFmtVal, oDatos:cPrinterTikChk )

         end if

      case ( dbfTikT )->cTipTik == SAVDEV

         nGenTikCli( if( lPrev, IS_SCREEN, IS_PRINTER ), "Imprimiendo devoluciones", oDatos:cFmtTikDev, oDatos:cPrinterDev )

      case ( dbfTikT )->cTipTik == SAVALB

         if lImpAlbaranesEnImpresora( ( dbfTikT )->cNcjTik, dbfCajT )

            if lPrev
               VisAlbCli( ( dbfTikT )->cNumDoc, .f., "Imprimiendo albaranes", oDatos:cFmtAlbCaj, oDatos:cPrinterAlbCaj )
            else
               PrnAlbCli( ( dbfTikT )->cNumDoc, .f., "Imprimiendo albaranes", oDatos:cFmtAlbCaj, oDatos:cPrinterAlbCaj )
            end if

         else
            nGenTikCli( if( lPrev, IS_SCREEN, IS_PRINTER ), "Imprimiendo albaranes", oDatos:cFmtAlb, oDatos:cPrinterAlb )
         end if

      case ( dbfTikT )->cTipTik == SAVFAC

         if lImpFacturasEnImpresora( ( dbfTikT )->cNcjTik, dbfCajT )

            if lPrev
               VisFacCli( ( dbfTikT )->cNumDoc, .f., "Imprimiendo facturas", oDatos:cFmtFacCaj, oDatos:cPrinterFacCaj )
            else
               PrnFacCli( ( dbfTikT )->cNumDoc, .f., "Imprimiendo facturas", oDatos:cFmtFacCaj, oDatos:cPrinterFacCaj )
            end if

         else
            nGenTikCli( if( lPrev, IS_SCREEN, IS_PRINTER ), "Imprimiendo facturas", oDatos:cFmtFac, oDatos:cPrinterFac )
         end if

      case ( dbfTikT )->cTipTik == SAVPDA

         if lEntrega
            nGenTikCli( if( lPrev, IS_SCREEN, IS_PRINTER ), "Imprimiendo tickets", oDatos:cFmtEntCaj, oDatos:cPrinterEntCaj )
         else
            nGenTikCli( if( lPrev, IS_SCREEN, IS_PRINTER ), "Imprimiendo tickets", oDatos:cFormatoTiket, oDatos:cPrinterTik )
         end if

      case ( dbfTikT )->cTipTik == SAVAPT

         nGenTikCli( if( lPrev, IS_SCREEN, IS_PRINTER ), "Imprimiendo apartados", oDatos:cFmtApt, oDatos:cPrinterApt )

   end case

   /*
   Cambio el estado a imprimido para que el ticket no se vuelva a imprimir-----
   */

   if !Empty( dbfImp )

      nNumTik  := ( dbfImp )->cSerTik + ( dbfImp )->cNumTik + ( dbfImp )->cSufTik

      if dbSeekInOrd( nNumTik, "cComanda", dbfImp )

         if dbLock( dbfImp )
            ( dbfImp )->lImp        := .t.
            ( dbfImp )->dFTikImp    := GetSysDate()
            ( dbfImp )->cHTikImp    := Substr( Time(), 1, 5 )
            ( dbfImp )->( dbUnLock() )
         end if

      end if

   end if

   if !Empty( oWndBrw )
      oWndBrw:Refresh()
   end if

Return nil

//----------------------------------------------------------------------------//

Static Function TpvEdtRec( oWndBrw, bEdit, dbfTikT, oWnd )

   pdaLockSemaphore( dbfTikT )

   WinEdtRec( oWndBrw, bEdit, dbfTikT, , , oWnd )

   pdaUnLockSemaphore( dbfTikT )

   oWndBrw:Select( 0 )
   oWndBrw:Select( 1 )

Return ( .t. )

//----------------------------------------------------------------------------//
//
// Borra tickets
//

FUNCTION TpvDelRec()

   local nOrdAlb
   local nRecAnt
   local nOrdAnt
   local cTipDoc        := ( dbfTikT )->cTipTik
   local cNumDoc        := ( dbfTikT )->cNumDoc
   local cNumTik        := ( dbfTikT )->cSerTik + ( dbfTikT )->cNumTik + ( dbfTikT )->cSufTik

   CursorWait()

   /*
   Cambiamos el estado del albarán del que proviene----------------------------
   */

   if !Empty( ( dbfTikT )->cAlbTik )

      if dbSeekInOrd( ( dbfTikT )->cAlbTik, "nNumAlb", dbfAlbCliT )

         if dbLock( dbfAlbCliT )
            ( dbfAlbCliT )->lFacturado    := .f.
            ( dbfAlbCliT )->cNumTik       := Space(13)
            ( dbfAlbCliT )->( dbUnLock() )
         end if

      end if

      nOrdAlb  := ( dbfAlbCliL )->( OrdSetFocus( "nNumAlb" ) )

      if ( dbfAlbCliL )->( dbSeek( ( dbfTikT )->cAlbTik ) )

         while ( dbfAlbCliL )->cSerAlb + Str( ( dbfAlbCliL )->nNumAlb ) + ( dbfAlbCliL )->cSufAlb == ( dbfTikT )->cAlbTik .and. !( dbfAlbCliL )->( Eof() )

            if dbLock( dbfAlbCliL )
               ( dbfAlbCliL )->lFacturado    := .f.
               ( dbfAlbCliL )->( dbUnLock() )
            end if

            ( dbfAlbCliL )->( dbSkip() )

         end while

      end if

      ( dbfAlbCliL )->( OrdSetFocus( nOrdAlb ) )

   end if

   /*
   Cambiamos el estado del pedido del que proviene----------------------------
   */

   if !Empty( ( dbfTikT )->cPedTik )

      if dbSeekInOrd( ( dbfTikT )->cPedTik, "nNumPed", dbfPedCliT )

         if dbLock( dbfPedCliT )
            ( dbfPedCliT )->nEstado       := 1
            ( dbfPedCliT )->cNumTik       := Space(13)
            ( dbfPedCliT )->( dbUnLock() )
         end if

      end if

      if dbSeekInOrd( ( dbfTikT )->cPedTik, "nNumPed", dbfPedCliP )

         while ( dbfPedCliP )->cSerPed + Str( ( dbfPedCliP )->nNumPed ) + ( dbfPedCliP )->cSufPed == ( dbfTikT )->cPedTik .and. !( dbfPedCliP )->( eof() )

            if dbLock( dbfPedCliP )
               ( dbfPedCliP )->lPasado    := .f.
               ( dbfPedCliT )->( dbUnLock() )
            end if

            ( dbfPedCliP )->( dbSkip() )

         end while

      end if

   end if

   /*
   Cambiamos el estado del presupuestos del que proviene----------------------------
   */

   if !Empty( ( dbfTikT )->cPreTik )

      if dbSeekInOrd( ( dbfTikT )->cPreTik, "nNumPre", dbfPreCliT )

         if dbLock( dbfPreCliT )
            ( dbfPreCliT )->lEstado       := .f.
            ( dbfPreCliT )->cNumTik       := Space(13)
            ( dbfPreCliT )->( dbUnLock() )
         end if

      end if

   end if

   /*
   Eliminamos las lineas----------------------------------------------------
   */

   while ( dbfTikL )->( dbSeek( cNumTik ) )
      dbDel( dbfTikL )
   end while

   /*
   Borramos los pagos-------------------------------------------------------
   */

   while ( dbfTikP )->( dbSeek( cNumTik ) )
      dbDel( dbfTikP )
   end while

   /*
   Eliminamos los vales-----------------------------------------------------
   */

   nRecAnt                       := ( dbfTikT )->( Recno() )
   nOrdAnt                       := ( dbfTikT )->( OrdSetFocus( "cDocVal" ) )

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

         while dbSeekInOrd( cNumDoc, "nNumAlb", dbfAlbCliT )
            dbDel( dbfAlbCliT )
         end if

         while dbSeekInOrd( cNumDoc, "nNumAlb", dbfAlbCliL )
            dbDel( dbfAlbCliL )
         end if

      case cTipDoc == SAVFAC

         while dbSeekInOrd( cNumDoc, "nNumFac", dbfFacCliT )
            dbDel( dbfFacCliT )
         end if

         while dbSeekInOrd( cNumDoc, "nNumFac", dbfFacCliL )
            dbDel( dbfFacCliL )
         end if

         while dbSeekInOrd( cNumDoc, "nNumFac", dbfFacCliP )
            dbDel( dbfFacCliP )
         end if

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

      end case

   end if

   CursorWE()

Return ( .t. )

//----------------------------------------------------------------------------//

STATIC FUNCTION EdtRec( aTmp, aGet, dbfTikT, oBrw, cCodCli, cCodArt, nMode, aNumDoc )

   local nOrd
   local oBmpDiv
   local cTitDoc
   local nRieCli           := 0
   local cResource         := "TPVFRONT_1024x768"
   local nScreenVertRes    := GetSysMetrics( 1 )

   aGetTxt                 := Array( 10 )
   oGetTxt                 := Array( 10 )

   if ( nMode == EDIT_MODE ) .and. ( ( aTmp[ _CTIPTIK ] == SAVDEV ) .or. ( aTmp[ _CTIPTIK ] == SAVVAL ) )
      MsgStop( "No se pueden modificar vales, devoluciones o cheques regalos." )
      return .f.
   end if

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

   /*
   Tarifa de venta del ticket--------------------------------------------------
   */

   if Empty( aTmp[ _NTARIFA ] )
      aTmp[ _NTARIFA ]     := Max( uFieldEmpresa( "nPreVta" ), 1 )
   end if

   /*
   De ticket a factura---------------------------------------------------------
   */

   if nMode == DUPL_MODE
      cTitDoc              := "Ticket a factura"
   else
      cTitDoc              := LblTitle( nMode ) + aTipTik( aTmp ) + " a clientes"
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

   if !lCajaOpen( oUser():cCaja() ) .and. !oUser():lMaster()
      msgStop( "Esta caja " + oUser():cCaja() + " esta cerrada." )
      Return .f.
   end if

   /*
   Valores por defecto---------------------------------------------------------
   */

   cCapCaj                 := cCapturaCaja( oUser():cCaja(), dbfCajT )

   if Empty( aTmp[ _CTLFCLI ] )
      aTmp[ _CTLFCLI ]     := RetFld( aTmp[ _CCLITIK ], dbfClient, "Telefono" )
   end if

   nRieCli                 := oStock:nRiesgo( aTmp[ _CCLITIK ] )

   /*
   Creamos las fuentes---------------------------------------------------------
   */

   oFntEur                 := TFont():New( FONT_NAME, 0, 48, .f., .t. )

   /*
   Orden actual----------------------------------------------------------------
   */

   nOrd                    := ( dbfTikT )->( ordSetFocus( 1 ) )

   /*
   Comenzamos las transacciones------------------------------------------------
   */

   if BeginTrans( aTmp, aGet, nMode, .t. )
      Return .f.
   end if

   nCopTik                 := nCopiasTicketsEnCaja( oUser():cCaja(), dbfCajT )
   lCopTik                 := .t.

   /*
   Caja de dialogo-------------------------------------------------------------
   */

   do case
      case nScreenVertRes == 600
         cResource         := "TPVFRONT"
         lMaximized        := .f.

      case nScreenVertRes == 768
         cResource         := "TPVFRONT_1024x768"
         lMaximized        := .f.

      case nScreenVertRes == 1024
         cResource         := "TPVFRONT_1280x1024"
         lMaximized        := .f.

   end case

   DEFINE DIALOG oDlgTpv RESOURCE cResource TITLE cTitDoc

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

      /*REDEFINE GET oGetTxt[ 9 ] VAR aGetTxt[ 9 ];
         ID       106 ;
         WHEN     ( .f. );
         OF       oDlgTpv */

     REDEFINE GET aGet[ _CTLFCLI ] VAR aTmp[ _CTLFCLI ] ;
         ID       106 ;
         WHEN     ( nMode != ZOOM_MODE .and. ( !aTmp[ _LMODCLI ] .or. oUser():lAdministrador() ) ) ;
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
         WHEN     ( nMode != ZOOM_MODE ) ;
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

      REDEFINE GET aGet[ _NCOMAGE ] VAR aTmp[ _NCOMAGE ] ;
         WHEN     ( !Empty( aTmp[ _CCODAGE ] ) .AND. nMode != ZOOM_MODE ) ;
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
         WHEN     ( nMode == APPD_MODE .AND. ( dbfTmpL )->( ordKeyCount() ) == 0 ) ;
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
      */

      oBrwDet                 := IXBrowse():New( oDlgTpv )

      oBrwDet:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwDet:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrwDet:bChange         := {|| DisImg( ( dbfTmpL )->cCbaTil ) }

      if ( nMode != ZOOM_MODE ) // .and. nAnd( nLevel, ACC_EDIT ) != 0
         oBrwDet:bLDblClick   := {|| WinEdtRec( oBrwDet, bEditL, dbfTmpL, , , aTmp ), lRecTotal( aTmp ), aGet[ _CCLITIK ]:SetFocus() }
      end if

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
      Descuentos________________________________________________________________
      */

      REDEFINE GET aGet[ _CDTOESP ] VAR aTmp[ _CDTOESP ] ;
         ID       710 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlgTpv

      REDEFINE GET aGet[ _NDTOESP ] VAR aTmp[ _NDTOESP ] ;
         ID       711 ;
         PICTURE  "@ER 999.99%" ;
         VALID    ( lRecTotal( aTmp ) );
         SPINNER;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlgTpv

      REDEFINE GET oTotEsp VAR nTotDtoEsp ;
         ID       712 ;
         PICTURE  "@ER 999.99 €" ;
         WHEN     ( .f. ) ;
         OF       oDlgTpv

      REDEFINE GET aGet[ _CDPP ] VAR aTmp[ _CDPP ] ;
         ID       720 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlgTpv

		REDEFINE GET aGet[ _NDPP ] VAR aTmp[ _NDPP ];
         ID       721 ;
         PICTURE  "@ER 999.99%" ;
         VALID    ( lRecTotal( aTmp ) );
         SPINNER;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlgTpv

      REDEFINE GET oTotDpp VAR nTotDpp ;
         ID       722 ;
         PICTURE  "@ER 999.99 €" ;
         WHEN     ( .f. ) ;
         OF       oDlgTpv

		/*
      Visor de productos_______________________________________________________
      */

      REDEFINE BITMAP oBmpVis ;
         ID       600;
         FILE     cFilBmp ;
         OF       oDlgTpv ;
			ADJUST

      /*
      Rentabilidad del ticket--------------------------------------------------
      */

      REDEFINE SAY oSayGetRnt ;
         ID       800 ;
         OF       oDlgTpv

      REDEFINE GET oGetRnt VAR nTotRnt ;
         ID       408 ;
         OF       oDlgTpv

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

		REDEFINE METER oMetMsg VAR nMetMsg ;
			ID 		460 ;
			NOPERCENTAGE ;
         OF       oDlgTpv

      oMetMsg:nClrText   := rgb( 128,255,0 )
      oMetMsg:nClrBar    := rgb( 128,255,0 )
      oMetMsg:nClrBText  := rgb( 128,255,0 )

      REDEFINE GET aGet[ _CSERTIK ] ;
         VAR      aTmp[ _CSERTIK ];
			ID 		100 ;
         PICTURE  "@!" ;
         SPINNER ;
         ON UP    ( UpSerie( aGet[ _CSERTIK ] ) );
         ON DOWN  ( DwSerie( aGet[ _CSERTIK ] ) );
         WHEN     ( nMode == APPD_MODE .or. nMode == DUPL_MODE );
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

   oDlgTpv:bStart       := {|| StartEdtRec( aTmp, aGet, nMode, oDlgTpv, oBrw, oBrwDet, aNumDoc, cCodArt ) }

   /*
   Apertura de la caja de dialogo
   */

   if nMode != ZOOM_MODE
      oDlgTpv:AddFastKey( VK_F2, {|| AppDetRec( oBrwDet, bEditL, aTmp, cPorDiv, cPicEur ), aGet[ _CCLITIK ]:SetFocus() } )
      oDlgTpv:AddFastKey( VK_F3, {|| WinEdtRec( oBrwDet, bEditL, dbfTmpL, , , aTmp ), lRecTotal( aTmp ), aGet[ _CCLITIK ]:SetFocus() } )
      oDlgTpv:AddFastKey( VK_F4, {|| WinDelRec( oBrwDet, dbfTmpL, nil, nil, .t. ), lRecTotal( aTmp ) } )
      oDlgTpv:AddFastKey( VK_F5, {|| if( ( ( nMode == APPD_MODE ) .or. ( ( aTmp[ _CTIPTIK ] == SAVTIK .or. aTmp[ _CTIPTIK ] == SAVAPT ) .and. ( nMode == EDIT_MODE ) ) ), NewTiket( aGet, aTmp, nMode, SAVTIK, .f., oBrw, oBrwDet ), ) } )
      oDlgTpv:AddFastKey( VK_F7, {|| if( ( ( nMode == APPD_MODE ) .or. ( ( aTmp[ _CTIPTIK ] == SAVALB .or. aTmp[ _CTIPTIK ] == SAVAPT ) .and. ( nMode == EDIT_MODE ) ) ), NewTiket( aGet, aTmp, nMode, SAVALB, .f., oBrw, oBrwDet ), ) } )
      oDlgTpv:AddFastKey( VK_F8, {|| if( ( ( nMode == APPD_MODE ) .or. ( ( aTmp[ _CTIPTIK ] == SAVFAC .or. aTmp[ _CTIPTIK ] == SAVAPT ) .and. ( nMode == EDIT_MODE ) ) ), NewTiket( aGet, aTmp, nMode, SAVFAC, .f., oBrw, oBrwDet ), ) } )
      oDlgTpv:AddFastKey( VK_F9, {|| if( ( ( nMode == APPD_MODE ) .or. ( ( aTmp[ _CTIPTIK ] == SAVVAL .or. aTmp[ _CTIPTIK ] == SAVAPT ) .and. ( nMode == EDIT_MODE ) ) ), GuardaApartado( aGet, aTmp, @nMode, SAVAPT, .f., oBrw, oBrwDet, oDlgTpv ), ) } )
      oDlgTpv:AddFastKey( 65,    {|| if( GetKeyState( VK_CONTROL ), CreateInfoArticulo(), ) } )
   end if

   ACTIVATE DIALOG oDlgTpv ;
         VALID    ( ExitNoSave( nMode, dbfTmpL ) ) ;
         CENTER

   /*
   Limpiamos el Usuario que hemos guardado-------------------------------------
   */

   cDelUsrTik()

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

Static Function StartEdtRec( aTmp, aGet, nMode, oDlgTpv, oBrw, oBrwDet, aNumDoc, cCodArt )

   local oBoton
   local oGrupo
   local oCarpeta

   if Empty( oOfficeBar )

      oOfficeBar              := TDotNetBar():New( 0, 0, 2020, 115, oDlgTpv, 1 )
      oOfficeBar:lPaintAll    := .f.
      oOfficeBar:lDisenio     := .f.

      oOfficeBar:SetStyle( 1 )

      oDlgTpv:oTop      := oOfficeBar

      oCarpeta          := TCarpeta():New( oOfficeBar, "T.P.V." )

      oGrupo            := TDotNetGroup():New( oCarpeta, 186, "Lineas", .f. )
         oBtnAdd        := TDotNetButton():New( 60, oGrupo, "New32",                    "Añadir [F2]",         1, {|| AppDetRec( oBrwDet, bEditL, aTmp, cPorDiv, cPicEur ), aGet[ _CCLITIK ]:SetFocus() }, , , .f., .f., .f. )
         oBtnEdt        := TDotNetButton():New( 60, oGrupo, "Edit32",                   "Modificar [F3]",      2, {|| WinEdtRec( oBrwDet, bEditL, dbfTmpL, , , aTmp ), lRecTotal( aTmp ), aGet[ _CCLITIK ]:SetFocus() }, , , .f., .f., .f. )
         oBtnDel        := TDotNetButton():New( 60, oGrupo, "Del32",                    "Eliminar [F4]",       3, {|| WinDelRec( oBrwDet, dbfTmpL, nil, nil, .t. ), lRecTotal( aTmp ) }, , {|| nMode != ZOOM_MODE }, .f., .f., .f. )

      oGrupo            := TDotNetGroup():New( oCarpeta, 436, "Cobros", .f. )
         oBtnTik        := TDotNetButton():New( 60, oGrupo, "Money2_32",                "Cobrar [F5]",         1, {|| NewTiket( aGet, aTmp, nMode, SAVTIK, .f., oBrw, oBrwDet ) }, , {|| nMode != ZOOM_MODE }, .f., .f., .f. )
         oBtnAlb        := TDotNetButton():New( 60, oGrupo, "Document_plain_user1_32",  "Albarán [F7]",        2, {|| NewTiket( aGet, aTmp, nMode, SAVALB, .f., oBrw, oBrwDet ) }, , {|| nMode != ZOOM_MODE }, .f., .f., .f. )
         oBtnFac        := TDotNetButton():New( 70, oGrupo, "Document_user1_32",        "Factura [F8]",        3, {|| NewTiket( aGet, aTmp, nMode, SAVFAC, .f., oBrw, oBrwDet ) }, , {|| nMode != ZOOM_MODE }, .f., .f., .f. )
         oBtnApt        := TDotNetButton():New( 60, oGrupo, "Cashier_Stop_32",          "Apartar [F9]",        4, {|| GuardaApartado( aGet, aTmp, @nMode, SAVAPT, .f., oBrw, oBrwDet, oDlgTpv ) }, , {|| nMode != ZOOM_MODE }, .f., .f., .f. )
         oBtnVal        := TDotNetButton():New( 60, oGrupo, "Cashier_Money2_32",        "Cheque regalo",       5, {|| NewTiket( aGet, aTmp, nMode, SAVRGL, .f., oBrw, oBrwDet ) }, , {|| nMode != ZOOM_MODE }, .f., .f., .f. )
         oBtnDev        := TDotNetButton():New( 60, oGrupo, "Cashier_Delete_32",        "Devolución",          6, {|| if( uFieldEmpresa( "lNumTik" ), AsistenteDevolucionTiket( aTmp, aGet, nMode, .t. ), NewTiket( aGet, aTmp, nMode, SAVDEV, .f., oBrw, oBrwDet ) ) }, , {|| nMode == APPD_MODE }, .f., .f., .f. )
         oBtnOld        := TDotNetButton():New( 60, oGrupo, "Cashier_Scroll_32",        "Vale",                7, {|| if( uFieldEmpresa( "lNumTik" ), AsistenteDevolucionTiket( aTmp, aGet, nMode, .f. ), NewTiket( aGet, aTmp, nMode, SAVVAL, .f., oBrw, oBrwDet ) ) }, , {|| nMode != ZOOM_MODE }, .f., .f., .f. )

      oGrupo            := TDotNetGroup():New( oCarpeta, 66, "Tickets", .f. )
         oBtnUp         := TDotNetButton():New( 60, oGrupo, "Arrow_Up_Blue_Save_32",    "",                    1, , , {|| nMode != ZOOM_MODE }, .f., .f., .f. ) //lCambiaTicket( .t., aTmp, aGet, nMode ), if( !Empty( oBrw ), ( oBrw:Select( 0 ), oBrw:Select( 1 ), oBrw:Refresh() ), )
         oBtnDown       := TDotNetButton():New( 60, oGrupo, "Arrow_Down_Blue_Save_32",  "",                    1, , , {|| nMode != ZOOM_MODE }, .f., .f., .f. ) //lCambiaTicket( .f., aTmp, aGet, nMode ), if( !Empty( oBrw ), ( oBrw:Select( 0 ), oBrw:Select( 1 ), oBrw:Refresh() ), )

      oGrupo            := TDotNetGroup():New( oCarpeta, 66, "Salida", .f. )
         oBoton         := TDotNetButton():New( 60, oGrupo, "End32",                    "Salida",              1, {|| oDlgTpv:End() }, , , .f., .f., .f. )

      oCarpeta          := TCarpeta():New( oOfficeBar, "Rotor" )

      oGrupo            := TDotNetGroup():New( oCarpeta, 306, "Cobros", .f. )
         oBoton         := TDotNetButton():New( 60, oGrupo, "User1_32",                 "Modificar cliente",   1, {|| if( !Empty( aTmp[ _CCLITIK ] ), EdtCli( aTmp[ _CCLITIK ] ), MsgStop( "Código cliente vacío" ) ) }, , , .f., .f., .f. )
         oBoton         := TDotNetButton():New( 60, oGrupo, "Info_32",                  "Informe cliente",     2, {|| if( !Empty( aTmp[ _CCLITIK ] ), InfCliente( aTmp[ _CCLITIK ] ), MsgStop( "Código cliente vacío" ) ) }, , , .f., .f., .f. )
         oBoton         := TDotNetButton():New( 60, oGrupo, "Worker_32",                "Modificar obras",     3, {|| if( !Empty( aTmp[ _CCLITIK ] ), EdtObras( aTmp[ _CCLITIK ], aTmp[ _CCODOBR ], dbfObrasT ), MsgStop( "No hay obra asociada para el presupuesto" ) ) }, , , .f., .f., .f. )
         oBoton         := TDotNetButton():New( 60, oGrupo, "Cube_Yellow_32",           "Modificar artículo",  4, {|| EdtArticulo( ( dbfTmpL )->cCbaTil ) }, , , .f., .f., .f. )
         oBoton         := TDotNetButton():New( 60, oGrupo, "Info_32",                  "Informe artículo",    5, {|| InfArticulo( ( dbfTmpL )->cCbaTil ) }, , , .f., .f., .f. )

      SetButtonEdtRec( nMode, aTmp )

   end if

   if nMode == DUPL_MODE

      oBtnAdd:lEnabled  := .f.
      oBtnEdt:lEnabled  := .f.
      oBtnDel:lEnabled  := .f.

      oBtnTik:lEnabled  := .f.
      oBtnAlb:lEnabled  := .f.
      oBtnFac:lEnabled  := .t.
      oBtnApt:lEnabled  := .f.
      oBtnVal:lEnabled  := .f.
      oBtnDev:lEnabled  := .f.
      oBtnOld:lEnabled  := .f.

      oBtnUp:lEnabled   := .f.
      oBtnDown:lEnabled := .f.

   end if

   if aNumDoc != nil

      do case
         case !Empty( aNumDoc[ 1 ] )

            cPreCli( aTmp, aGet, @aNumDoc[ 1 ], oBrwDet )

            oBtnAdd:lEnabled  := .f.
            oBtnEdt:lEnabled  := .f.
            oBtnDel:lEnabled  := .f.

            oBtnAlb:lEnabled  := .f.
            oBtnFac:lEnabled  := .f.
            oBtnApt:lEnabled  := .f.
            oBtnVal:lEnabled  := .f.
            oBtnDev:lEnabled  := .f.
            oBtnOld:lEnabled  := .f.

            oBtnUp:lEnabled   := .f.
            oBtnDown:lEnabled := .f.

         case !Empty( aNumDoc[ 2 ] )

            cPedCli( aTmp, aGet, @aNumDoc[ 2 ], oBrwDet )

            oBtnAdd:lEnabled  := .f.
            oBtnEdt:lEnabled  := .f.
            oBtnDel:lEnabled  := .f.

            oBtnAlb:lEnabled  := .f.
            oBtnFac:lEnabled  := .f.
            oBtnApt:lEnabled  := .f.
            oBtnVal:lEnabled  := .f.
            oBtnDev:lEnabled  := .f.
            oBtnOld:lEnabled  := .f.

            oBtnUp:lEnabled   := .f.
            oBtnDown:lEnabled := .f.

         case !Empty( aNumDoc[ 3 ] )

            cAlbCli( aTmp, aGet, @aNumDoc[ 3 ], oBrwDet )

            oBtnAdd:lEnabled  := .f.
            oBtnEdt:lEnabled  := .f.
            oBtnDel:lEnabled  := .f.

            oBtnAlb:lEnabled  := .f.
            oBtnFac:lEnabled  := .f.
            oBtnApt:lEnabled  := .f.
            oBtnVal:lEnabled  := .f.
            oBtnDev:lEnabled  := .f.
            oBtnOld:lEnabled  := .f.

            oBtnUp:lEnabled   := .f.
            oBtnDown:lEnabled := .f.

      end case

   end if

   /*
   Ocultamos el bitmap para la imagen de los productos-------------------------
   */

   if !Empty( oBmpVis )
      oBmpVis:Hide()
   end if

   if oGetRnt != nil .and. oUser():lNotRentabilidad()
      oGetRnt:Hide()
   end if

   if oSayGetRnt != nil .and. oUser():lNotRentabilidad()
      oSayGetRnt:Hide()
   end if

   /*
   Limpiamos las memvar de la rentabilidad-------------------------------------
   */

   nTotCos                    := 0
   nTotRnt                    := 0
   nTotPctRnt                 := 0

   lRecTotal( aTmp, .f. )

   /*
   Comportamiento inicial------------------------------------------------------
   */

   if !Empty( oDlgTpv )

      aEval( oDlgTpv:aControls, { | oCtrl | oCtrl:Disable() } )

      if IsTrue( lMaximized )
         oDlgTpv:Maximize()
      end if

   end if

   do case
      case nMode == APPD_MODE .and. lRecogerUsuario() .and. !Empty( cCodArt )

         if lGetUsuario( aGet[ _CCCJTIK ], dbfUsr )

            cUsrTik( aGet[ _CCCJTIK ]:VarGet() )

            aGet[ _CCLITIK ]:lValid()

            if !Empty( oDlgTpv )
               aEval( oDlgTpv:aControls, { | oCtrl | oCtrl:Enable() } )
            end if

            AppDetRec( oBrwDet, bEditL, aTmp, cPorDiv, cPicEur, cCodArt )

            aGet[ _CCLITIK ]:SetFocus()

         else

            if !Empty( oDlgTpv )
               aEval( oDlgTpv:aControls, { | oCtrl | oCtrl:Enable() } )
            end if

            oDlgTpv:End()

         end if

      case nMode == APPD_MODE .and. lRecogerUsuario() .and. lEntCon()

         if lGetUsuario( aGet[ _CCCJTIK ], dbfUsr )

            cUsrTik( aGet[ _CCCJTIK ]:VarGet() )

            aGet[ _CCLITIK ]:lValid()

            if !Empty( oDlgTpv )
               aEval( oDlgTpv:aControls, { | oCtrl | oCtrl:Enable() } )
            end if

            AppDetRec( oBrwDet, bEditL, aTmp, cPorDiv, cPicEur, cCodArt )

            aGet[ _CCLITIK ]:SetFocus()

         else

            if !Empty( oDlgTpv )
               aEval( oDlgTpv:aControls, { | oCtrl | oCtrl:Enable() } )
            end if

            oDlgTpv:End()

         end if

      case nMode == APPD_MODE .and. lRecogerUsuario() .and. !lEntCon()

         if lGetUsuario( aGet[ _CCCJTIK ], dbfUsr )

            cUsrTik( aGet[ _CCCJTIK ]:VarGet() )

            aGet[ _CCLITIK ]:lValid()

            if !Empty( oDlgTpv )
               aEval( oDlgTpv:aControls, { | oCtrl | oCtrl:Enable() } )
            end if

            aGet[ _CCLITIK ]:SetFocus()

         else

            if !Empty( oDlgTpv )
               aEval( oDlgTpv:aControls, { | oCtrl | oCtrl:Enable() } )
            end if

            oDlgTpv:End()

         end if

      case nMode == APPD_MODE .and. !lRecogerUsuario() .and. lEntCon()

         aGet[ _CCLITIK ]:lValid()

         if !Empty( oDlgTpv )
            aEval( oDlgTpv:aControls, { | oCtrl | oCtrl:Enable() } )
         end if

         AppDetRec( oBrwDet, bEditL, aTmp, cPorDiv, cPicEur, cCodArt )

         aGet[ _CCLITIK ]:SetFocus()

      case nMode == APPD_MODE .and. !lRecogerUsuario() .and. !Empty( cCodArt )

         aGet[ _CCLITIK ]:lValid()

         if !Empty( oDlgTpv )
            aEval( oDlgTpv:aControls, { | oCtrl | oCtrl:Enable() } )
         end if

         AppDetRec( oBrwDet, bEditL, aTmp, cPorDiv, cPicEur, cCodArt )

         aGet[ _CCLITIK ]:SetFocus()

      otherwise

         aGet[ _CCLITIK ]:lValid()

         if !Empty( oDlgTpv )
            aEval( oDlgTpv:aControls, { | oCtrl | oCtrl:Enable() } )
         end if

         lRecTotal( aTmp )

         oBrwDet:SetFocus()

   end case

Return ( nil )

//---------------------------------------------------------------------------//

Static Function StateButtons( lState )

   DEFAULT lState    := .f.

   oBtnAdd:lEnabled  := lState
   oBtnEdt:lEnabled  := lState
   oBtnDel:lEnabled  := lState

   oBtnTik:lEnabled  := lState
   oBtnAlb:lEnabled  := lState
   oBtnFac:lEnabled  := lState
   oBtnApt:lEnabled  := lState
   oBtnVal:lEnabled  := lState
   oBtnDev:lEnabled  := lState
   oBtnOld:lEnabled  := lState

   oBtnAdd:Refresh()
   oBtnEdt:Refresh()
   oBtnDel:Refresh()

   oBtnTik:Refresh()
   oBtnAlb:Refresh()
   oBtnFac:Refresh()
   oBtnApt:Refresh()
   oBtnVal:Refresh()
   oBtnDev:Refresh()
   oBtnOld:Refresh()

return ( nil )

//---------------------------------------------------------------------------//

Static Function SetButtonEdtRec( nMode, aTmp )

   oBtnAdd:lEnabled  := ( nMode != ZOOM_MODE )
   oBtnEdt:lEnabled  := ( nMode != ZOOM_MODE )
   oBtnDel:lEnabled  := ( nMode != ZOOM_MODE )

   oBtnTik:lEnabled  := ( nMode == APPD_MODE ) .or. ( ( aTmp[ _CTIPTIK ] == SAVTIK .or. aTmp[ _CTIPTIK ] == SAVAPT ) .and. ( nMode == EDIT_MODE ) )
   oBtnAlb:lEnabled  := ( nMode == APPD_MODE ) .or. ( ( aTmp[ _CTIPTIK ] == SAVALB .or. aTmp[ _CTIPTIK ] == SAVAPT ) .and. ( nMode == EDIT_MODE ) )
   oBtnFac:lEnabled  := ( nMode == APPD_MODE ) .or. ( ( aTmp[ _CTIPTIK ] == SAVFAC .or. aTmp[ _CTIPTIK ] == SAVAPT ) .and. ( nMode == EDIT_MODE ) )
   oBtnApt:lEnabled  := ( nMode == APPD_MODE ) .or. ( ( aTmp[ _CTIPTIK ] == SAVVAL .or. aTmp[ _CTIPTIK ] == SAVAPT ) .and. ( nMode == EDIT_MODE ) )
   oBtnVal:lEnabled  := ( nMode == APPD_MODE ) .or. ( ( aTmp[ _CTIPTIK ] == SAVVAL .or. aTmp[ _CTIPTIK ] == SAVAPT ) .and. ( nMode == EDIT_MODE ) )
   oBtnDev:lEnabled  := ( nMode == APPD_MODE ) .or. ( ( aTmp[ _CTIPTIK ] == SAVVAL .or. aTmp[ _CTIPTIK ] == SAVDEV .or. aTmp[ _CTIPTIK ] == SAVAPT ) .and. ( nMode == EDIT_MODE ) )
   oBtnOld:lEnabled  := ( nMode == APPD_MODE ) .or. ( ( aTmp[ _CTIPTIK ] == SAVVAL .or. aTmp[ _CTIPTIK ] == SAVVAL .or. aTmp[ _CTIPTIK ] == SAVVAL ) .and. ( nMode == EDIT_MODE ) )

Return ( nil )

//---------------------------------------------------------------------------//

Static Function cAlbCli( aTmp, aGet, cNumAlb, oBrwLin )

   local nRecCab
   local nRecLin
   local nOrdCab
   local nOrdLin

   nRecCab     		:= ( dbfAlbCliT )->( Recno() )
   nRecLin     		:= ( dbfAlbCliL )->( Recno() )
   nOrdCab     		:= ( dbfAlbCliT )->( OrdSetFocus( "NNUMALB" ) )
   nOrdLin     		:= ( dbfAlbCliL )->( OrdSetFocus( "NNUMALB" ) )

   /*
   Pasamos las cabeceras-------------------------------------------------------
   */

   if ( dbfAlbCliT )->( dbSeek( cNumAlb ) )

      cOldCodCli     := ( dbfAlbCliT )->cCodCli

      aGet[ _CCCJTIK ]:cText( ( dbfAlbCliT )->cCodUsr )
      aGet[ _CNCJTIK ]:cText( ( dbfAlbCliT )->cCodCaj )
      aGet[ _CALMTIK ]:cText( ( dbfAlbCliT )->cCodAlm )
      aGet[ _NTARIFA ]:cText( ( dbfAlbCliT )->nTarifa )
      aGet[ _CCLITIK ]:cText( ( dbfAlbCliT )->cCodCli )
      aGet[ _CNOMTIK ]:cText( ( dbfAlbCliT )->cNomCli )
      aGet[ _CDIRCLI ]:cText( ( dbfAlbCliT )->cDirCli )
      aGet[ _CTLFCLI ]:cText( ( dbfAlbCliT )->cTlfCli )
      aGet[ _CPOBCLI ]:cText( ( dbfAlbCliT )->cPobCli )
      aGet[ _CPRVCLI ]:cText( ( dbfAlbCliT )->cPrvCli )
      aGet[ _CPOSCLI ]:cText( ( dbfAlbCliT )->cPosCli )
      aGet[ _CDNICLI ]:cText( ( dbfAlbCliT )->cDniCli )
      aGet[ _CFPGTIK ]:cText( ( dbfAlbCliT )->cCodPago )
      aGet[ _CDIVTIK ]:cText( ( dbfAlbCliT )->cDivAlb )
      aGet[ _CCODAGE ]:cText( ( dbfAlbCliT )->cCodAge )
      aGet[ _NCOMAGE ]:cText( ( dbfAlbCliT )->nPctComAge )
      aGet[ _CCODRUT ]:cText( ( dbfAlbCliT )->cCodRut )
      aGet[ _CCODTAR ]:cText( ( dbfAlbCliT )->cCodTar )
      aGet[ _CCODOBR ]:cText( ( dbfAlbCliT )->cCodObr )

      aTmp[ _LMODCLI ]  := .t.
      aTmp[ _CALBTIK ]  := cNumAlb

      aTmp[ _CCODDLG ]  := ( dbfAlbCliT )->cCodDlg
      aTmp[ _CCODGRP ]  := ( dbfAlbCliT )->cCodGrp
      aTmp[ _NVDVTIK ]  := ( dbfAlbCliT )->nVdvAlb

      if ( dbfAlbCliL )->( dbSeek( cNumAlb ) )

         while ( dbfAlbCliL )->cSerAlb + Str( ( dbfAlbCliL )->nNumAlb ) + ( dbfAlbCliL )->cSufAlb == cNumAlb .and. !( dbfAlbCliL )->( Eof() )

            ( dbfTmpL )->( dbAppend() )

            ( dbfTmpL )->cCbaTil    := ( dbfAlbCliL )->cRef
            ( dbfTmpL )->cNomTil    := ( dbfAlbCliL )->cDetalle
            if ( dbfAlbCliT )->lIvaInc
               ( dbfTmpL )->nPvpTil := ( dbfAlbCliL )->nPreUnit
            else
               ( dbfTmpL )->nPvpTil := ( dbfAlbCliL )->nPreUnit + ( ( ( dbfAlbCliL )->nPreUnit * ( dbfAlbCliL )->nIva ) / 100 )
            end if
            ( dbfTmpL )->nUntTil    := ( dbfAlbCliL )->nUniCaja
            ( dbfTmpL )->nUndKit    := ( dbfAlbCliL )->nUndKit
            ( dbfTmpL )->nIvaTil    := ( dbfAlbCliL )->nIva
            ( dbfTmpL )->cFamTil    := ( dbfAlbCliL )->cCodFam
            ( dbfTmpL )->nDtoLin    := ( dbfAlbCliL )->nDto
            ( dbfTmpL )->cCodPr1    := ( dbfAlbCliL )->cCodPr1
            ( dbfTmpL )->cCodPr2    := ( dbfAlbCliL )->cCodPr2
            ( dbfTmpL )->cValPr1    := ( dbfAlbCliL )->cValPr1
            ( dbfTmpL )->cValPr2    := ( dbfAlbCliL )->cValPr2
            ( dbfTmpL )->nFacCnv    := ( dbfAlbCliL )->nFacCnv
            ( dbfTmpL )->nDtoDiv    := ( dbfAlbCliL )->nDtoDiv
            ( dbfTmpL )->nCtlStk    := ( dbfAlbCliL )->nCtlStk
            ( dbfTmpL )->cAlmLin    := ( dbfAlbCliL )->cAlmLin
            ( dbfTmpL )->nValImp    := ( dbfAlbCliL )->nValImp
            ( dbfTmpL )->cCodImp    := ( dbfAlbCliL )->cCodImp
            ( dbfTmpL )->nCosDiv    := ( dbfAlbCliL )->nCosDiv
            ( dbfTmpL )->lKitArt    := ( dbfAlbCliL )->lKitArt
            ( dbfTmpL )->lKitChl    := ( dbfAlbCliL )->lKitChl
            ( dbfTmpL )->lKitPrc    := ( dbfAlbCliL )->lKitPrc
            ( dbfTmpL )->lImpLin    := ( dbfAlbCliL )->lImpLin
            ( dbfTmpL )->lControl   := ( dbfAlbCliL )->lControl
            ( dbfTmpL )->mNumSer    := ( dbfAlbCliL )->mNumSer
            ( dbfTmpL )->cCodFam    := ( dbfAlbCliL )->cCodFam
            ( dbfTmpL )->cGrpFam    := ( dbfAlbCliL )->cGrpFam
            ( dbfTmpL )->nLote      := ( dbfAlbCliL )->nLote
            ( dbfTmpL )->cLote      := ( dbfAlbCliL )->cLote
            ( dbfTmpL )->cCodUsr    := ( dbfAlbCliT )->cCodUsr
            ( dbfTmpL )->nNumLin    := nLastNum( dbfTmpL )

            ( dbfTmpL )->( dbUnLock() )

            ( dbfAlbCliL )->( dbSkip() )

         end while

      end if

   end if

   /*
   Refrescamos el browse y los totales
   */

   lRecTotal( aTmp )

   ( dbfTmpL )->( dbGoTop() )

   oBrwLin:Refresh()

   /*
   Volvemos al orden y al numero de registro que teniamos----------------------
   */

   ( dbfAlbCliT )->( OrdSetFocus( nOrdCab ) )
   ( dbfAlbCliL )->( OrdSetFocus( nOrdLin ) )
   ( dbfAlbCliT )->( dbGoTo( nRecCab ) )
   ( dbfAlbCliL )->( dbGoTo( nRecLin ) )

   cNumAlb            := ""
   lStopEntContLine   := .t.

return .t.

//---------------------------------------------------------------------------//

static function cPedCli( aTmp, aGet, cNumPed, oBrwLin )

   local nRecCab
   local nRecLin
   local nOrdCab
   local nOrdLin

   nRecCab           := ( dbfPedCliT )->( Recno() )
   nRecLin           := ( dbfPedCliL )->( Recno() )
   nOrdCab           := ( dbfPedCliT )->( OrdSetFocus( "NNUMPED" ) )
   nOrdLin           := ( dbfPedCliL )->( OrdSetFocus( "NNUMPED" ) )

   /*
   Pasamos las cabeceras-------------------------------------------------------
   */

   if ( dbfPedCliT )->( dbSeek( cNumPed ) )

      cOldCodCli     := ( dbfPedCliT )->cCodCli

      aGet[ _CCCJTIK ]:cText( ( dbfPedCliT )->cCodUsr )
      aGet[ _CNCJTIK ]:cText( ( dbfPedCliT )->cCodCaj )
      aGet[ _CALMTIK ]:cText( ( dbfPedCliT )->cCodAlm )
      aGet[ _NTARIFA ]:cText( ( dbfPedCliT )->nTarifa )
      aGet[ _CCLITIK ]:cText( ( dbfPedCliT )->cCodCli )
      aGet[ _CNOMTIK ]:cText( ( dbfPedCliT )->cNomCli )
      aGet[ _CDIRCLI ]:cText( ( dbfPedCliT )->cDirCli )
      aGet[ _CTLFCLI ]:cText( ( dbfPedCliT )->cTlfCli )
      aGet[ _CPOBCLI ]:cText( ( dbfPedCliT )->cPobCli )
      aGet[ _CPRVCLI ]:cText( ( dbfPedCliT )->cPrvCli )
      aGet[ _CPOSCLI ]:cText( ( dbfPedCliT )->cPosCli )
      aGet[ _CDNICLI ]:cText( ( dbfPedCliT )->cDniCli )
      aGet[ _CFPGTIK ]:cText( ( dbfPedCliT )->cCodPgo )
      aGet[ _CCODAGE ]:cText( ( dbfPedCliT )->cCodAge )
      aGet[ _NCOMAGE ]:cText( ( dbfPedCliT )->nPctComAge )
      aGet[ _CCODRUT ]:cText( ( dbfPedCliT )->cCodRut )
      aGet[ _CCODTAR ]:cText( ( dbfPedCliT )->cCodTar )
      aGet[ _CCODOBR ]:cText( ( dbfPedCliT )->cCodObr )

      aTmp[ _LMODCLI ]  := .t.
      aTmp[ _CPEDTIK ]  := cNumPed

      aTmp[ _CCODDLG ]  := ( dbfPedCliT )->cCodDlg
      aTmp[ _CCODGRP ]  := ( dbfPedCliT )->cCodGrp
      aTmp[ _CDIVTIK ]  := ( dbfPedCliT )->cDivPed
      aTmp[ _NVDVTIK ]  := ( dbfPedCliT )->nVdvPed

      if ( dbfPedCliL )->( dbSeek( cNumPed ) )

         while ( dbfPedCliL )->cSerPed + Str( ( dbfPedCliL )->nNumPed ) + ( dbfPedCliL )->cSufPed == cNumPed .and. !( dbfPedCliL )->( Eof() )

            ( dbfTmpL )->( dbAppend() )

            ( dbfTmpL )->cCbaTil    := ( dbfPedCliL )->cRef
            ( dbfTmpL )->cNomTil    := ( dbfPedCliL )->cDetalle
            if ( dbfPedCliT )->lIvaInc
               ( dbfTmpL )->nPvpTil := ( dbfPedCliL )->nPreDiv
            else
               ( dbfTmpL )->nPvpTil := ( dbfPedCliL )->nPreDiv + ( ( ( dbfPedCliL )->nPreDiv * ( dbfPedCliL )->nIva ) / 100 )
            end if
            ( dbfTmpL )->nUntTil    := ( dbfPedCliL )->nUniCaja
            ( dbfTmpL )->nUndKit    := ( dbfPedCliL )->nUndKit
            ( dbfTmpL )->nIvaTil    := ( dbfPedCliL )->nIva
            ( dbfTmpL )->cFamTil    := ( dbfPedCliL )->cCodFam
            ( dbfTmpL )->nDtoLin    := ( dbfPedCliL )->nDto
            ( dbfTmpL )->cCodPr1    := ( dbfPedCliL )->cCodPr1
            ( dbfTmpL )->cCodPr2    := ( dbfPedCliL )->cCodPr2
            ( dbfTmpL )->cValPr1    := ( dbfPedCliL )->cValPr1
            ( dbfTmpL )->cValPr2    := ( dbfPedCliL )->cValPr2
            ( dbfTmpL )->nFacCnv    := ( dbfPedCliL )->nFacCnv
            ( dbfTmpL )->nDtoDiv    := ( dbfPedCliL )->nDtoDiv
            ( dbfTmpL )->nCtlStk    := ( dbfPedCliL )->nCtlStk
            ( dbfTmpL )->cAlmLin    := ( dbfPedCliL )->cAlmLin
            ( dbfTmpL )->nValImp    := ( dbfPedCliL )->nValImp
            ( dbfTmpL )->cCodImp    := ( dbfPedCliL )->cCodImp
            ( dbfTmpL )->nCosDiv    := ( dbfPedCliL )->nCosDiv
            ( dbfTmpL )->lKitArt    := ( dbfPedCliL )->lKitArt
            ( dbfTmpL )->lKitChl    := ( dbfPedCliL )->lKitChl
            ( dbfTmpL )->lKitPrc    := ( dbfPedCliL )->lKitPrc
            ( dbfTmpL )->lImpLin    := ( dbfPedCliL )->lImpLin
            ( dbfTmpL )->lControl   := ( dbfPedCliL )->lControl
            ( dbfTmpL )->mNumSer    := ( dbfPedCliL )->mNumSer
            ( dbfTmpL )->cCodFam    := ( dbfPedCliL )->cCodFam
            ( dbfTmpL )->cGrpFam    := ( dbfPedCliL )->cGrpFam
            ( dbfTmpL )->nLote      := ( dbfPedCliL )->nLote
            ( dbfTmpL )->cLote      := ( dbfPedCliL )->cLote
            ( dbfTmpL )->cCodUsr    := ( dbfPedCliT )->cCodUsr
            ( dbfTmpL )->nNumLin    := nLastNum( dbfTmpL )

            ( dbfTmpL )->( dbUnLock() )

            ( dbfPedCliL )->( dbSkip() )

         end while

      end if

      /*
      Pasamos los pagos--------------------------------------------------------
      */

      if ( dbfPedCliP )->( dbSeek( cNumPed ) )

         while ( dbfPedCliP )->cSerPed + Str( ( dbfPedCliP )->nNumPed ) + ( dbfPedCliP )->cSufPed == cNumPed .and. !( dbfPedCliP )->( Eof() )

            if !( dbfPedCliP )->lPasado

               ( dbfTmpP )->( dbAppend() )

               ( dbfTmpP )->cCodCaj    := ( dbfPedCliP )->cCodCaj
               ( dbfTmpP )->dPgoTik    := ( dbfPedCliP )->dEntrega
               ( dbfTmpP )->nImpTik    := ( dbfPedCliP )->nImporte
               ( dbfTmpP )->cDivPgo    := ( dbfPedCliP )->cDivPgo
               ( dbfTmpP )->nVdvPgo    := ( dbfPedCliP )->nVdvPgo
               ( dbfTmpP )->cFpgPgo    := ( dbfPedCliP )->cCodPgo
               ( dbfTmpP )->cTurPgo    := ( dbfPedCliP )->cTurRec

               ( dbfTmpP )->( dbUnLock() )

            end if

            ( dbfPedCliP )->( dbSkip() )

         end while

      end if

   end if

   /*
   Refrescamos el browse y los totales
   */

   lRecTotal( aTmp )

   ( dbfTmpL )->( dbGoTop() )

   oBrwLin:Refresh()

   /*
   Volvemos al orden y al numero de registro que teniamos----------------------
   */

   ( dbfPedCliT )->( OrdSetFocus( nOrdCab ) )
   ( dbfPedCliL )->( OrdSetFocus( nOrdLin ) )
   ( dbfPedCliT )->( dbGoTo( nRecCab ) )
   ( dbfPedCliL )->( dbGoTo( nRecLin ) )

   cNumPed            := ""
   lStopEntContLine   := .t.

return .t.

//---------------------------------------------------------------------------//

static function cPreCli( aTmp, aGet, cNumPre, oBrwLin )

   local nRecCab
   local nRecLin
   local nOrdCab
   local nOrdLin

   nRecCab           := ( dbfPreCliT )->( Recno() )
   nRecLin           := ( dbfPreCliL )->( Recno() )
   nOrdCab           := ( dbfPreCliT )->( OrdSetFocus( "NNUMPRE" ) )
   nOrdLin           := ( dbfPreCliL )->( OrdSetFocus( "NNUMPRE" ) )

   /*
   Pasamos las cabeceras-------------------------------------------------------
   */

   if ( dbfPreCliT )->( dbSeek( cNumPre ) )

      cOldCodCli        := ( dbfPreCliT )->cCodCli

      aGet[ _CCCJTIK ]:cText( ( dbfPreCliT )->cCodUsr )
      aGet[ _CNCJTIK ]:cText( ( dbfPreCliT )->cCodCaj )
      aGet[ _CALMTIK ]:cText( ( dbfPreCliT )->cCodAlm )
      aGet[ _NTARIFA ]:cText( ( dbfPreCliT )->nTarifa )
      aGet[ _CCLITIK ]:cText( ( dbfPreCliT )->cCodCli )
      aGet[ _CNOMTIK ]:cText( ( dbfPreCliT )->cNomCli )
      aGet[ _CDIRCLI ]:cText( ( dbfPreCliT )->cDirCli )
      aGet[ _CPOBCLI ]:cText( ( dbfPreCliT )->cPobCli )
      aGet[ _CTLFCLI ]:cText( ( dbfPreCliT )->cTlfCli )
      aGet[ _CPRVCLI ]:cText( ( dbfPreCliT )->cPrvCli )
      aGet[ _CPOSCLI ]:cText( ( dbfPreCliT )->cPosCli )
      aGet[ _CDNICLI ]:cText( ( dbfPreCliT )->cDniCli )
      aGet[ _CFPGTIK ]:cText( ( dbfPreCliT )->cCodPgo )
      aGet[ _CDIVTIK ]:cText( ( dbfPreCliT )->cDivPre )
      if !Empty ( aGet[ _NVDVTIK ] )
         aGet[ _NVDVTIK ]:cText( ( dbfPreCliT )->nVdvPre )
      end if
      aGet[ _CCODAGE ]:cText( ( dbfPreCliT )->cCodAge )
      aGet[ _NCOMAGE ]:cText( ( dbfPreCliT )->nPctComAge )
      aGet[ _CCODRUT ]:cText( ( dbfPreCliT )->cCodRut )
      aGet[ _CCODTAR ]:cText( ( dbfPreCliT )->cCodTar )
      aGet[ _CCODOBR ]:cText( ( dbfPreCliT )->cCodObr )
      aTmp[ _LMODCLI ]  := .t.
      aTmp[ _CPRETIK ]  := cNumPre
      aTmp[ _CCODDLG ]  := ( dbfPreCliT )->cCodDlg
      aTmp[ _CCODGRP ]  := ( dbfPreCliT )->cCodGrp

      if ( dbfPreCliL )->( dbSeek( cNumPre ) )

         while ( dbfPreCliL )->cSerPre + Str( ( dbfPreCliL )->nNumPre ) + ( dbfPreCliL )->cSufPre == cNumPre .and. !( dbfPreCliL )->( Eof() )

            ( dbfTmpL )->( dbAppend() )

            ( dbfTmpL )->cCbaTil    := ( dbfPreCliL )->cRef
            ( dbfTmpL )->cNomTil    := ( dbfPreCliL )->cDetalle
            if ( dbfAlbCliT )->lIvaInc
               ( dbfTmpL )->nPvpTil := ( dbfPreCliL )->nPreDiv
            else
               ( dbfTmpL )->nPvpTil := ( dbfPreCliL )->nPreDiv + ( ( ( dbfPreCliL )->nPreDiv * ( dbfPreCliL )->nIva ) / 100 )
            end if
            ( dbfTmpL )->nUntTil    := ( dbfPreCliL )->nUniCaja
            ( dbfTmpL )->nUndKit    := ( dbfPreCliL )->nUndKit
            ( dbfTmpL )->nIvaTil    := ( dbfPreCliL )->nIva
            ( dbfTmpL )->cFamTil    := ( dbfPreCliL )->cCodFam
            ( dbfTmpL )->nDtoLin    := ( dbfPreCliL )->nDto
            ( dbfTmpL )->cCodPr1    := ( dbfPreCliL )->cCodPr1
            ( dbfTmpL )->cCodPr2    := ( dbfPreCliL )->cCodPr2
            ( dbfTmpL )->cValPr1    := ( dbfPreCliL )->cValPr1
            ( dbfTmpL )->cValPr2    := ( dbfPreCliL )->cValPr2
            ( dbfTmpL )->nFacCnv    := ( dbfPreCliL )->nFacCnv
            ( dbfTmpL )->nDtoDiv    := ( dbfPreCliL )->nDtoDiv
            ( dbfTmpL )->nCtlStk    := ( dbfPreCliL )->nCtlStk
            ( dbfTmpL )->cAlmLin    := ( dbfPreCliL )->cAlmLin
            ( dbfTmpL )->nValImp    := ( dbfPreCliL )->nValImp
            ( dbfTmpL )->cCodImp    := ( dbfPreCliL )->cCodImp
            ( dbfTmpL )->nCosDiv    := ( dbfPreCliL )->nCosDiv
            ( dbfTmpL )->lKitArt    := ( dbfPreCliL )->lKitArt
            ( dbfTmpL )->lKitChl    := ( dbfPreCliL )->lKitChl
            ( dbfTmpL )->lKitPrc    := ( dbfPreCliL )->lKitPrc
            ( dbfTmpL )->lImpLin    := ( dbfPreCliL )->lImpLin
            ( dbfTmpL )->lControl   := ( dbfPreCliL )->lControl
            ( dbfTmpL )->mNumSer    := ( dbfPreCliL )->mNumSer
            ( dbfTmpL )->cCodFam    := ( dbfPreCliL )->cCodFam
            ( dbfTmpL )->cGrpFam    := ( dbfPreCliL )->cGrpFam
            ( dbfTmpL )->nLote      := ( dbfPreCliL )->nLote
            ( dbfTmpL )->cLote      := ( dbfPreCliL )->cLote
            ( dbfTmpL )->cCodUsr    := ( dbfPreCliT )->cCodUsr
            ( dbfTmpL )->nNumLin    := nLastNum( dbfTmpL )

            ( dbfTmpL )->( dbUnLock() )

            ( dbfPreCliL )->( dbSkip() )

         end while

      end if

   end if

   /*
   Refrescamos el browse y los totales
   */

   lRecTotal( aTmp )

   ( dbfTmpL )->( dbGoTop() )

   oBrwLin:Refresh()

   /*
   Volvemos al orden y al numero de registro que teniamos----------------------
   */

   ( dbfPreCliT )->( OrdSetFocus( nOrdCab ) )
   ( dbfPreCliL )->( OrdSetFocus( nOrdLin ) )
   ( dbfPreCliT )->( dbGoTo( nRecCab ) )
   ( dbfPreCliL )->( dbGoTo( nRecLin ) )

   cNumPre            := ""
   lStopEntContLine   := .t.

return .t.

//---------------------------------------------------------------------------//

Static function GuardaApartado( aGet, aTmp, nMode, nSave, lBig, oBrw, oBrwDet, oDlgTpv )

   local oError
   local oBlock
   local cSelApartado   := ""
   local nRec
   local nOrdAnt

   if ( dbfTmpL )->( OrdKeyCount() ) == 0

      lSaveNewTik       := .f.

      cSelApartado      := BrwApartados()

      nRec              := ( dbfTikT )->( Recno() )
      nOrdAnt           := ( dbfTikT )->( OrdSetFocus( "CNUMTIK" ) )

      if !Empty( cSelApartado )                 .and.;
         ( dbfTikT )->( dbSeek( cSelApartado ) )

         /*oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
         BEGIN SEQUENCE*/

         /*
         Abrimos el ticket seleccionado-------------------------------------------
         */

         aScatter( dbfTikT, aTmp )

         BeginTrans( aTmp, aGet, EDIT_MODE, .f. )

         aEval( oDlgTpv:aControls, { | oCtrl | oCtrl:Refresh() } )

         nSaveMode            := EDIT_MODE
         nMode                := EDIT_MODE
         lSaveNewTik          := .f.

         /*
         Titulo de la ventana-----------------------------------------------------
         */

         cTitleDialog( aTmp )
         
         /*
         Botones de la ventana de tpv---------------------------------------------
         */

         SetButtonEdtRec( nSaveMode, aTmp )

         /*
         Recalculamos el total----------------------------------------------------
         */

         lRecTotal( aTmp )

         /*
         Cargamos y refrescamos datos del cliente------------------------------
         */

         cOldCodCli           := ""

         if !Empty( aGet[ _CCLITIK ] )
            aGet[ _CCLITIK ]:SetFocus()
            aGet[ _CCLITIK ]:lValid()
         end if

         /*RECOVER USING oError
   
         msgStop( ErrorMessage( oError ), "Error al cambiar de ticket" )
   
         END SEQUENCE
   
         ErrorBlock( oBlock )*/

      end if 

      ( dbfTikT )->( OrdSetFocus( nOrdAnt ) )
      ( dbfTikT )->( dbGoTo( nRec ) )

   else

      NewTiket( aGet, aTmp, nMode, nSave, lBig, oBrw, oBrwDet )

   end if

Return .t.

//---------------------------------------------------------------------------//

static function BrwApartados()

   local oDlg
   local oBrw
   local oGet1
   local cGet1
   local nOrd                    := GetBrwOpt( "BrwTikCli" )
   local oCbxOrd
   local cCbxOrd
   local aCbxOrd                 := { "Número", "Fecha", "Código cliente", "Nombre cliente" }
   local nRecAnt                 := ( dbfTikT )->( RecNo() )
   local cApartadoSeleccionado   := ""

   nOrd                          := Min( Max( nOrd, 1 ), len( aCbxOrd ) )
   cCbxOrd                       := aCbxOrd[ nOrd ]

   nOrd                          := ( dbfTikT )->( OrdSetFocus( nOrd ) )

   /*
   Posicinamiento--------------------------------------------------------------
   */

   ( dbfTikT )->( dbSetFilter( {|| Field->cTipTik == "5" .and. Field->cCcjTik == oUser():cCodigo() .and. Field->cNcjTik == oUser():cCaja() }, "Field->cTipTik == '5' .and. Field->cCcjTik == oUser():cCodigo() .and. Field->cNcjTik == oUser():cCaja()" ) )

   ( dbfTikT )->( dbGoTop() )

   if ( dbfTikT )->( Eof() )

      MsgStop( "No existen apartados para seleccionar." )

   else

      DEFINE DIALOG oDlg RESOURCE "HelpEntry" TITLE 'Seleccionar apartado'

         REDEFINE GET oGet1 VAR cGet1;
            ID       104 ;
            ON CHANGE AutoSeek( nKey, nFlags, Self, oBrw, dbfTikT );
            BITMAP   "FIND" ;
            OF       oDlg

         REDEFINE COMBOBOX oCbxOrd ;
            VAR      cCbxOrd ;
            ID       102 ;
            ITEMS    aCbxOrd ;
            ON CHANGE( ( dbfTikT )->( OrdSetFocus( oCbxOrd:nAt ) ), oBrw:Refresh(), oGet1:SetFocus() );
            OF       oDlg

         oBrw                    := IXBrowse():New( oDlg )

         oBrw:bClrSel            := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
         oBrw:bClrSelFocus       := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

         oBrw:cAlias             := dbfTikT
         oBrw:cName              := "Ticket cliente"
         oBrw:bLDblClick         := {|| oDlg:End( IDOK ) }

         oBrw:nMarqueeStyle      := 5

         with object ( oBrw:AddCol() )
            :cHeader             := "Número"
            :cSortOrder          := "cNumTik"
            :bEditValue          := {|| ( dbfTikT )->cSerTik + "/" + AllTrim( ( dbfTikT )->cNumTik ) + "/" + ( dbfTikT )->cSufTik }
            :nWidth              := 70
            :bLClickHeader       := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
         end with

         with object ( oBrw:AddCol() )
            :cHeader             := "Fecha"
            :cSortOrder          := "dFecTik"
            :bEditValue          := {|| dtoc( ( dbfTikT )->dFecTik ) }
            :nWidth              := 80
            :bLClickHeader       := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
         end with

         with object ( oBrw:AddCol() )
            :cHeader             := "Hora"
            :bEditValue          := {|| ( dbfTikT )->cHorTik }
            :nWidth              := 80
         end with

         with object ( oBrw:AddCol() )
            :cHeader             := "Sesión"
            :bEditValue          := {|| ( dbfTikT )->cTurTik + "/" + ( dbfTikT )->cSufTik }
            :nWidth              := 80
            :lHide               := .t.
         end with

         with object ( oBrw:AddCol() )
            :cHeader             := "Código cliente"
            :bEditValue          := {|| Rtrim( ( dbfTikT )->cCliTik ) }
            :cSortOrder          := "cCliTik"
            :nWidth              := 100
            :bLClickHeader       := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
         end with

         with object ( oBrw:AddCol() )
            :cHeader             := "Nombre cliente"
            :bEditValue          := {|| AllTrim( ( dbfTikT )->cNomTik ) }
            :cSortOrder          := "cNomTik"
            :nWidth              := 350
            :bLClickHeader       := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
         end with

         with object ( oBrw:AddCol() )
            :cHeader             := "Importe "
            :bEditValue          := {|| nTotalizer( ( dbfTikT)->cSerTik + ( dbfTikT )->cNumTik + ( dbfTikT )->cSufTik, dbfTikT, dbfTikL, dbfTikP, dbfAlbCliT, dbfAlbCliL, dbfFacCliT, dbfFacCliL, dbfFacCliP, dbfIva, dbfDiv, cDivEmp(), .t. ) }
            :nWidth              := 85
            :nDataStrAlign       := 1
            :nHeadStrAlign       := 1
         end with

         oBrw:CreateFromResource( 105 )

         REDEFINE BUTTON ;
            ID       500 ;
            OF       oDlg ;
            WHEN     ( .f. );
            ACTION   ( nil )

         REDEFINE BUTTON ;
            ID       501 ;
            OF       oDlg ;
            WHEN     ( .f. );
            ACTION   ( nil )

         REDEFINE BUTTON ;
            ID       IDOK ;
            OF       oDlg ;
            ACTION   ( oDlg:end( IDOK ) )

         REDEFINE BUTTON ;
            ID       IDCANCEL ;
            OF       oDlg ;
            CANCEL ;
            ACTION   ( oDlg:end() )

      oDlg:bStart                := {|| oBrw:Load() }

      oDlg:AddFastKey( VK_F5,    {|| oDlg:end( IDOK ) } )
      oDlg:AddFastKey( VK_RETURN,{|| oDlg:end( IDOK ) } )

      ACTIVATE DIALOG oDlg CENTER

      /*
      Guardamos los vales en el array---------------------------------------------
      */

      if oDlg:nResult == IDOK
         cApartadoSeleccionado   := ( dbfTikT )->cSerTik + ( dbfTikT )->cNumTik + ( dbfTikT )->cSufTik
      end if

      SetBrwOpt( "BrwTikCli", ( dbfTikT )->( OrdNumber() ) )

   end if   

   ( dbfTikT )->( OrdSetFocus( nOrd ) )
   ( dbfTikT )->( dbClearFilter() )
   ( dbfTikT )->( dbGoTo( nRecAnt ) )

RETURN ( cApartadoSeleccionado )

//---------------------------------------------------------------------------//

/*
Esta funcion graba el tiket despues de pedir el importe por pantalla
*/

Static Function NewTiket( aGet, aTmp, nMode, nSave, lBig, oBrw, oBrwDet )

   local nRec
   local nOrd
   local aTbl
   local nTotTik
   local cAlmTik
   local cTipTik
   local oError
   local oBlock
   local nOrdAlb
   local cNumDoc           := ""
   local nNumTik           := ""
   local cAlbTik           := aTmp[ _CALBTIK ]
   local cPedTik           := aTmp[ _CPEDTIK ]
   local cPreTik           := aTmp[ _CPRETIK ]
   local nValeDiferencia   := 0
   local nValePromocion    := 0
   local lValePromocion    := .f.
   local lValeDiferencia   := .f.

   DEFAULT nSave           := SAVTIK      // Por defecto salvamos como ticket
   DEFAULT lBig            := .f.

   if lSaveNewTik
      Return .t.
   else
      lSaveNewTik          := .t.
   end if

   /*
   Comprobamos la fecha del documento------------------------------------------
   */

   if !lValidaOperacion( aTmp[ _DFECTIK ] )
      lSaveNewTik          := .f.
      Return .f.
   end if

   /*
   Ticket regalo---------------------------------------------------------------
   */

   if ( nSave == SAVRGL )
      aTmp[ _LFRETIK ]     := .t.
      nSave                := SAVVAL
   else
      aTmp[ _LFRETIK ]     := .f.
   end if

   /*
   Matamos el dialogo----------------------------------------------------------
   */

   if !Empty( oDlgDet )
      oDlgDet:nResult      := IDCANCEL
   end if

   /*
   Controles para todo tipo de documentos--------------------------------------
   */

   if ( dbfTmpL )->( OrdKeyCount() ) == 0
      MsgStop( "No puede almacenar un documento sin lineas." )
      lSaveNewTik          := .f.
      return .f.
   end if

   if !Empty( aGet[ _CCLITIK ] ) .and. !( aGet[ _CCLITIK ]:lValid() )
      aGet[ _CCLITIK ]:SetFocus()
      lSaveNewTik          := .f.
      return .f.
   end if

   if !Empty( aGet[ _CALMTIK ] )

      if Empty( aTmp[ _CALMTIK ] )
         aGet[ _CALMTIK ]:SetFocus()
         MsgInfo( "Almacén no puede estar vacio" )
         lSaveNewTik       := .f.
         return .f.
      end if

      if !( aGet[ _CALMTIK ]:lValid() )
         aGet[ _CALMTIK ]:SetFocus()
         lSaveNewTik       := .f.
         return .f.
      end if

   end if

   if !Empty( aGet[ _CCCJTIK ] ) .and. Empty( aTmp[ _CCCJTIK ] )
      aGet[ _CCCJTIK ]:cText( cCurUsr() )
   end if

   if lRecogerAgentes() .and. !Empty( aGet[ _CCODAGE ] ) .and.  Empty( aTmp[ _CCODAGE ] )
      msgStop( "Agente no puede estar vacio." )
      aGet[ _CCODAGE ]:SetFocus()
      lSaveNewTik         := .f.
      return .f.
   end if

   if lRecogerAgentes() .and. !Empty( aGet[ _CCODAGE ] ) .and. !( aGet[ _CCODAGE ]:lValid() )
      aGet[ _CCODAGE ]:SetFocus()
      lSaveNewTik         := .f.
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
         lSaveNewTik         := .f.
         return .f.
      end if

      if Empty( aTmp[ _CDIRCLI ] ) .and. !( "GA" $ oWnd():Cargo )
         msgStop( "Domicilio de cliente no puede estar vacio." )
         lSaveNewTik         := .f.
         return .f.
      end if

      if Empty( aTmp[ _CDNICLI ] ) .and. !( "GA" $ oWnd():Cargo )
         msgStop( "D.N.I. / C.I.F. de cliente no puede estar vacio." )
         lSaveNewTik         := .f.
         return .f.
      end if

      if !lBig

         if Empty( aTmp[ _CFPGTIK ] )
            MsgStop( "Debe de introducir una forma de pago", "Imposible archivar como factura" )
            aGet[ _CFPGTIK ]:SetFocus()
            lSaveNewTik         := .f.
            return .f.
         end if

         if !( aGet[ _CFPGTIK ]:lValid() )
            aGet[ _CFPGTIK ]:SetFocus()
            lSaveNewTik         := .f.
            return .f.
         end if

         if lObras() .and. !Empty( aGet[ _CCODOBR ] ) .and. Empty( aTmp[ _CCODOBR ] )
            MsgStop( "Debe de introducir una obra", "Imposible archivar como factura" )
            aGet[ _CCODOBR ]:SetFocus()
            lSaveNewTik         := .f.
            return .f.
         end if

         if lObras() .and. !Empty( aGet[ _CCODOBR ] ) .and. !( aGet[ _CCODOBR ]:lValid() )
            aGet[ _CCODOBR ]:SetFocus()
            lSaveNewTik         := .f.
            return .f.
         end if

      end if

   case nSave == SAVALB

      if Empty( aTmp[ _CCLITIK ] )
         msgStop( "Código de cliente no puede estar vacio." )
         aGet[ _CCLITIK ]:SetFocus()
         lSaveNewTik         := .f.
         return .f.
      end if

      if !Empty( aGet[ _CCLITIK ] ) .and. lCliBlq( aTmp[ _CCLITIK ], dbfClient )
         msgStop( "Cliente bloqueado, no se pueden realizar operaciones de venta" , "Imposible archivar como albarán" )
         aGet[ _CCLITIK ]:SetFocus()
         lSaveNewTik         := .f.
         return .f.
      end if

      if !Empty( aGet[ _CCLITIK ] ) .and. !lCliChg( aTmp[ _CCLITIK ], dbfClient )
         msgStop( "Este cliente no tiene autorización para venta a credito.", "Imposible archivar como albarán" )
         aGet[ _CCLITIK ]:SetFocus()
         lSaveNewTik         := .f.
         return .f.
      end if

      if !lBig

         if !Empty( aGet[ _CFPGTIK ] ) .and. Empty( aTmp[ _CFPGTIK ] )
            MsgStop( "Debe de introducir una forma de pago", "Imposible archivar como albarán" )
            aGet[ _CFPGTIK ]:SetFocus()
            lSaveNewTik         := .f.
            return .f.
         end if

         if !Empty( aGet[ _CFPGTIK ] ) .and. !( aGet[ _CFPGTIK ]:lValid() )
            aGet[ _CFPGTIK ]:SetFocus()
            lSaveNewTik         := .f.
            return .f.
         end if

         if lObras() .and. !Empty( aGet[ _CCODOBR ] ) .and. Empty( aTmp[ _CCODOBR ] )
            MsgStop( "Debe de introducir una obra", "Imposible archivar como albarán" )
            aGet[ _CCODOBR ]:SetFocus()
            lSaveNewTik         := .f.
            return .f.
         end if

         if lObras() .and. !Empty( aGet[ _CCODOBR ] ) .and. !( aGet[ _CCODOBR ]:lValid() )
            aGet[ _CCODOBR ]:SetFocus()
            lSaveNewTik         := .f.
            return .f.
         end if

      end if

   end case

   /*
   Inicio de Fidelity----------------------------------------------------------
   */

   if ( nSave != SAVDEV ) .and. ( nSave != SAVVAL ) .and. ( lFidelity( aGet, aTmp, nMode ) )
      lSaveNewTik       := .f.
      return .f.
   end if

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
   Usuario del ticket----------------------------------------------------------
   */

   if Empty( aTmp[ _CCCJTIK ] )
      aTmp[ _CCCJTIK ]  := cCurUsr()
   end if

   /*
   Caja del ticket-------------------------------------------------------------
   */

   if Empty( aTmp[ _CNCJTIK ] )
      aTmp[ _CNCJTIK ]  := oUser():cCaja()
   end if

   /*
   Tarifa de venta del ticket--------------------------------------------------
   */

   if Empty( aTmp[ _NTARIFA ] )
      aTmp[ _NTARIFA ]  := Max( uFieldEmpresa( "nPreVta" ), 1 )
   end if

   /*
   Inicalizamos las variables de importe---------------------------------------
   */

   oTotDiv              := TotalesTPV():Init()

   nTotTik              := nTotTik( aTmp[ _CSERTIK ] + aTmp[ _CNUMTIK ] + aTmp[ _CSUFTIK ], dbfTikT, dbfTmpL, dbfDiv, aTmp, nil, .f. )

   aTmp[ _NCAMTIK ]     := 0
   aTmp[ _NCOBTIK ]     := nTotTik

   /*
   Capturanmos el porcentaje de promoción--------------------------------------
   */

   aTmp[ _NPCTPRM ]     := oFideliza:nPorcentajePrograma( nTotPrm )

   /*
   Vemos si cumple las condiciones para la promoción---------------------------
   */

   lValePromocion       := ( !Retfld( aTmp[ _CCLITIK ], dbfClient, "lExcFid" ) .and. ( aTmp[ _NPCTPRM ] != 0 ) )
   if lValePromocion
      nValePromocion    := nTotPrm * aTmp[ _NPCTPRM ] / 100
   end if

   /*
   Llamada a la funcion del cobro----------------------------------------------
   */

   if lExacto( aTmp ) .or. lCobro( @aTmp, aGet, @nSave, nMode, @lValeDiferencia, @nValeDiferencia, lBig, oDlgTpv )

      /*
      Justo antes de guardar volvemos a comprobar que existan lineas-----------
      */

      if ( dbfTmpL )->( OrdKeyCount() ) == 0
         MsgStop( "No puede almacenar un documento sin lineas." )
         lSaveNewTik         := .f.
         return .f.
      end if

      /*
      Control de errores-------------------------------------------------------
      */

      CursorWait()

      oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
      BEGIN SEQUENCE

         oDlgTpv:Disable()

         BeginTransaction()

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

            if !Empty( oMetMsg )
               oMetMsg:cText     := 'Obtenemos el nuevo número'
               oMetMsg:Refresh()
            end if

            aTmp[ _CNUMTIK ]  := Str( nNewDoc( aTmp[ _CSERTIK ], dbfTikT, "nTikCli", 10, dbfCount ), 10 )
            aTmp[ _CSUFTIK ]  := RetSufEmp()
            nNumTik           := aTmp[ _CSERTIK ] + aTmp[ _CNUMTIK ] + aTmp[ _CSUFTIK ]

            /*
            Fechas y horas de creacon del tiket--------------------------------
            */

            aTmp[ _CHORTIK ]  := Substr( Time(), 1, 5 )
            aTmp[ _LCLOTIK ]  := .f.

         case nMode == EDIT_MODE

            nNumTik           := aTmp[ _CSERTIK ] + aTmp[ _CNUMTIK ] + aTmp[ _CSUFTIK ]
            cNumDoc           := aTmp[ _CNUMDOC ]

            /*
            Eliminamos las lineas----------------------------------------------
            */

            if !Empty( oMetMsg )
               oMetMsg:cText     := 'Eliminando lineas'
               oMetMsg:Refresh()
            end if

            while ( dbfTikL )->( dbSeek( nNumTik ) )
               if dbLock( dbfTikL )
                  ( dbfTikL )->( dbDelete() )
                  ( dbfTikL )->( dbUnLock() )
               end if
            end while

            /*
            Eliminamos los pagos-----------------------------------------------
            */

            if !Empty( oMetMsg )
               oMetMsg:cText     := 'Eliminando pagos'
               oMetMsg:Refresh()
            end if

            while ( dbfTikP )->( dbSeek( nNumTik ) )

               if dbLock( dbfTikP )
                  ( dbfTikP )->( dbDelete() )
                  ( dbfTikP )->( dbUnLock() )
               end if

            end while

            /*
            Eliminamos los vales ----------------------------------------------
            */

            if !Empty( oMetMsg )
               oMetMsg:cText     := 'Eliminando vales'
               oMetMsg:Refresh()
            end if

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
            Quitamos las marcas desde el fichero de Tiket----------------------
            */

            if !Empty( oMetMsg )
               oMetMsg:cText     := 'Eliminando anticipos'
               oMetMsg:Refresh()
            end if

            if !Empty( cNumDoc )

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

         if !Empty( oMetMsg )
            oMetMsg:cText        := 'Anotando los pagos'
            oMetMsg:Refresh()
         end if

         if ( oTotDiv:lValeMayorTotal() )

            if ( aTmp[ _NCOBTIK ] != 0 .and. nSave != SAVAPT )

               if dbAppe( dbfTmpP )
                  ( dbfTmpP )->cTurPgo    := cCurSesion()
                  ( dbfTmpP )->dPgoTik    := GetSysDate()
                  ( dbfTmpP )->cTimTik    := SubStr( Time(), 1, 5 )
                  ( dbfTmpP )->cCodCaj    := oUser():cCaja()
                  ( dbfTmpP )->cFpgPgo    := aTmp[ _CFPGTIK ]
                  ( dbfTmpP )->cSerTik    := aTmp[ _CSERTIK ]
                  ( dbfTmpP )->cNumTik    := if( ValType( aTmp[ _CNUMTIK ] ) != "C", Str( aTmp[ _CNUMTIK ], 10 ), aTmp[ _CNUMTIK ] )
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

         nCambioTik           := aTmp[ _NCAMTIK ]

         /*
         Antes de guardar, si venimos de un albarán, cambiamos el estado al albarán
         */

         if !Empty( aTmp[ _CALBTIK ] )

            if !Empty( oMetMsg )
               oMetMsg:cText     := 'Estado albarán'
               oMetMsg:Refresh()
            end if

            if dbSeekInOrd( aTmp[ _CALBTIK ], "nNumAlb", dbfAlbCliT )

               if dbLock( dbfAlbCliT )
                  ( dbfAlbCliT )->lFacturado    := .t.
                  ( dbfAlbCliT )->cNumTik       := aTmp[ _CSERTIK ] + aTmp[ _CNUMTIK ] + aTmp[ _CSUFTIK ]
                  ( dbfAlbCliT )->( dbUnLock() )
               end if

            end if

            nOrdAlb           := ( dbfAlbCliL )->( OrdSetFocus( "nNumAlb" ) )

            if ( dbfAlbCliL )->( dbSeek( aTmp[ _CALBTIK ] ) )

               while ( dbfAlbCliL )->cSerAlb + Str( ( dbfAlbCliL )->nNumAlb ) + ( dbfAlbCliL )->cSufAlb == aTmp[ _CALBTIK ] .and. !( dbfAlbCliL )->( Eof() )

                  if dbLock( dbfAlbCliL )
                     ( dbfAlbCliL )->lFacturado := .t.
                     ( dbfAlbCliL )->( dbUnLock() )
                  end if

                  ( dbfAlbCliL )->( dbSkip() )

               end while

            end if

            ( dbfAlbCliL )->( OrdSetFocus( nOrdAlb ) )

         end if

         /*
         Antes de guardar, si venimos de un pedido, cambiamos el estado al pedido
         */

         if !Empty( aTmp[ _CPEDTIK ] )

            if !Empty( oMetMsg )
               oMetMsg:cText     := 'Estado pedido'
               oMetMsg:Refresh()
            end if

            if dbSeekInOrd( aTmp[ _CPEDTIK ], "nNumPed", dbfPedCliT )

               if dbLock( dbfPedCliT )
                  ( dbfPedCliT )->nEstado       := 3
                  ( dbfPedCliT )->cNumTik       := aTmp[ _CSERTIK ] + aTmp[ _CNUMTIK ] + aTmp[ _CSUFTIK ]
                  ( dbfPedCliT )->( dbUnLock() )
               end if

            end if

         end if

         /*
         Antes de guardar, si venimos de un presupuesto, cambiamos el estado al presupuesto
         */

         if !Empty( aTmp[ _CPRETIK ] )

            if !Empty( oMetMsg )
               oMetMsg:cText     := 'Estado presupuesto'
               oMetMsg:Refresh()
            end if

            if dbSeekInOrd( aTmp[ _CPRETIK ], "nNumPre", dbfPreCliT )

               if dbLock( dbfPreCliT )
                  ( dbfPreCliT )->lEstado       := .t.
                  ( dbfPreCliT )->cNumTik       := aTmp[ _CSERTIK ] + aTmp[ _CNUMTIK ] + aTmp[ _CSUFTIK ]
                  ( dbfPreCliT )->( dbUnLock() )
               end if

            end if

         end if

         /*
         Guardamos el tipo como albaranes-----------------------------------------
         */

         do case
            case nMode == DUPL_MODE

               SavTik2Neg( aTmp, aGet, nMode, nSave )
               SavTik2Fac( aTmp, aGet, nMode, nSave, nTotTik )

            case nSave == SAVALB

               SavTik2Alb( aTmp, aGet, nMode, nSave )

            case nSave == SAVFAC

               SavTik2Fac( aTmp, aGet, nMode, nSave, nTotTik )

            otherwise

               SavTik2Tik( aTmp, aGet, nMode, nSave )

         end case

         /*
         Actualizamos el stock-------------------------------------------------------
         */

         if !Empty( oMetMsg )
            oMetMsg:cText              := 'Actualizando stocks'
            oMetMsg:Refresh()
         end if

         //oStock:TpvCli( nNumTik, aTmp[ _CALMTIK ], .f., aTmp[ _CTIPTIK ] == SAVVAL .or. aTmp[ _CTIPTIK ] == SAVDEV )

         /*
         Anotamos los vales ------------------------------------------------------
         */

         if !Empty( oMetMsg )
            oMetMsg:cText              := 'Archivando vales'
            oMetMsg:Refresh()
         end if

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

         if !Empty( oMetMsg )
            oMetMsg:cText                    := 'Archivando anticipos'
            oMetMsg:Refresh()
         end if

         ( dbfTmpA )->( dbGoTop() )
         while !( dbfTmpA )->( eof() )
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
         end While

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
            Estado de la factura-----------------------------------------------
            */

            ChkLqdFacCli( nil, dbfFacCliT, dbfFacCliL, dbfFacCliP, dbfAntCliT, dbfIva, dbfDiv )

         end if

         /*
         Apertura de la caja---------------------------------------------------
         */

         if !Empty( oMetMsg )
            oMetMsg:cText        := 'Abriendo la caja'
            oMetMsg:Refresh()
         end if

         if ( dbfTikT )->cTipTik != SAVALB
            oUser():OpenCajon()
         end if

         /*
         Imprimir el registro--------------------------------------------------
         */

         if lCopTik .and. nSave != SAVAPT // .and. nCopTik != 0  //Comprobamos que hayamos pulsado el botón de aceptar e imprimir
            ImpTiket( .f. )
         end if

         /*
         Generamos el vale por la diferencia si nos lo piden-------------------
         */

         if lValeDiferencia //.and. nMode == APPD_MODE

            if ( nSave != SAVVAL ) .or. ( nSave != SAVDEV  )

               if !Empty( oMetMsg )
                  oMetMsg:cText     := 'Generando vales'
                  oMetMsg:Refresh()
               end if

               /*
               Obtenemos el nuevo numero del vale---------------------------------
               */

               aTmp              := dbScatter( dbfTikT )

               aTmp[ _DFECTIK ]  := dFecMaxVale( aTmp[ _CSERTIK ] + aTmp[ _CNUMTIK ] + aTmp[ _CSUFTIK ], dbfTikT  )
               aTmp[ _CNUMTIK ]  := Str( nNewDoc( aTmp[ _CSERTIK ], dbfTikT, "nTikCli", 10, dbfCount ), 10 )
               aTmp[ _CSUFTIK ]  := RetSufEmp()
               aTmp[ _CHORTIK ]  := Substr( Time(), 1, 5 )
               aTmp[ _DFECCRE ]  := Date()
               aTmp[ _CTIMCRE ]  := SubStr( Time(), 1, 5 )
               aTmp[ _CTIPTIK ]  := SAVVAL
               aTmp[ _LCLOTIK ]  := .f.
               aTmp[ _NTOTNET ]  := nValeDiferencia
               aTmp[ _NTOTIVA ]  := 0
               aTmp[ _NTOTTIK ]  := nValeDiferencia

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
               aTbl[ _NNUMLIN ]  := 1
               aTbl[ _NPVPTIL ]  := nValeDiferencia

               dbGather( aTbl, dbfTikL, .t. )

               if lCopTik
                  ImpTiket( .f. )
               end if

            end if

         end if

         /*
         Generamos el vale por promoción si nos lo piden--------------------
         */

         if ( lValePromocion ) .and. ( nValePromocion > 0 ) .and. ( nMode == APPD_MODE ) .and. ( nSave != SAVVAL )

            if !Empty( oMetMsg )
               oMetMsg:cText     := 'Generando vales'
               oMetMsg:Refresh()
            end if

            /*
            Obtenemos el nuevo numero del vale------------------------------
            */

            aTmp                 := dbScatter( dbfTikT )

            aTmp[ _CNUMTIK ]     := Str( nNewDoc( aTmp[ _CSERTIK ], dbfTikT, "nTikCli", 10, dbfCount ), 10 )
            aTmp[ _CSUFTIK ]     := RetSufEmp()
            aTmp[ _CHORTIK ]     := Substr( Time(), 1, 5 )
            aTmp[ _DFECCRE ]     := Date()
            aTmp[ _CTIMCRE ]     := SubStr( Time(), 1, 5 )
            aTmp[ _CTIPTIK ]     := SAVVAL
            aTmp[ _CTIKVAL ]     := nNumTik
            aTmp[ _LCLOTIK ]     := .f.

            if ( nSave == SAVDEV )
               aTmp[ _NTOTNET ]  := - nValePromocion
               aTmp[ _NTOTTIK ]  := - nValePromocion
            else
               aTmp[ _NTOTNET ]  := nValePromocion
               aTmp[ _NTOTTIK ]  := nValePromocion
            endif

            dbGather( aTmp, dbfTikT, .t. )

            /*
            Guardamos las lineas del tiket----------------------------------------
            */

            aTbl                 := dbBlankRec( dbfTmpL )

            aTbl[ _CSERTIL ]     := aTmp[ _CSERTIK ]
            aTbl[ _CNUMTIL ]     := aTmp[ _CNUMTIK ]
            aTbl[ _CSUFTIL ]     := aTmp[ _CSUFTIK ]
            aTbl[ _CTIPTIK ]     := SAVVAL
            aTbl[ _NUNTTIL ]     := 1
            aTbl[ _NNUMLIN ]     := 1
            aTbl[ _CNOMTIL ]     := "Vale por promoción"

            if ( nSave == SAVDEV )
               aTbl[ _NPVPTIL ]  := - nValePromocion
            else
               aTbl[ _NPVPTIL ]  := nValePromocion
            endif

            dbGather( aTbl, dbfTikL, .t. )

            if lCopTik // .and. nCopTik != 0  //Comprobamos que hayamos pulsado el botón de aceptar e imprimir
               ImpTiket( .f. )
            end if

         end if

         /*
         Modo para el proximo ticket----------------------------------------------
         */

         nSaveMode                  := APPD_MODE

         /*
         Cerrando-----------------------------------------------------------------
         */

         CommitTransaction()

         oDlgTpv:Enable()
         oDlgTpv:AEvalWhen()

         /*
         Cerrando el control de errores-------------------------------------------
         */

      RECOVER USING oError

         RollBackTransaction()

         msgStop( "Error en la grabación del ticket" + CRLF + ErrorMessage( oError ) )

      END SEQUENCE

      ErrorBlock( oBlock )

      CursorWE()

      /*
      Preparados para un nuevo registro----------------------------------------
      */

      if ( lBig ) .or. ( lEntCon() .and. ( nMode == APPD_MODE ) .and. ( Empty( cAlbTik ) .and. Empty( cPedTik ) .and. Empty( cPreTik ) ) )

         if !Empty( oMetMsg )
            oMetMsg:cText  := 'Inicializado entorno'
            oMetMsg:Refresh()
         end if

         if BeginTrans( aTmp, aGet, nMode, .t. )
            lSaveNewTik    := .f.
            Return nil
         end if

         /*
         Validamos los controles-----------------------------------------------
         */

         if !Empty( aGet[ _CCLITIK ] )
            aGet[ _CCLITIK ]:lValid()
         end if

         /*
         Tarifa de venta del ticket--------------------------------------------
         */

         if Empty( aTmp[ _NTARIFA ] )
            aTmp[ _NTARIFA ]  := Max( uFieldEmpresa( "nPreVta" ), 1 )
         end if

         if Empty( aTmp[ _NTARIFA ] ) .and. !Empty( RetFld( cDefCli(), dbfClient, "nTarifa" ) )
            aTmp[ _NTARIFA ]  := RetFld( cDefCli(), dbfClient, "nTarifa" )
         end if

         /*
         Articulos de inicio---------------------------------------------------
         */

         if !Empty( oBtnIni )
            oBtnIni:Click()
         end if

         /*
         Informacion del cambio anterior----------------------------------------
         */

         if oTxtTot != nil
            oTxtTot:SetText( "Cambio" )
         end if

         if ( oNumTot != nil .and. cPorDiv != nil )
            oNumTot:SetText( Trans( nCambioTik, cPorDiv ) )
         end if

         /*
         Ejecutamos del nuevo el bStart----------------------------------------
         */

         StartEdtRec( aTmp, aGet, nMode, oDlgTpv, oBrw, oBrwDet )

      else

         oDlgTpv:bValid    := {|| .t. }

         lSaveNewTik       := .f.

         oDlgTpv:end( IDOK )

      end if

      lStopEntCont         := !( Empty( cAlbTik ) .and. Empty( cPedTik ) .and. Empty( cPreTik ) )

      /*
      Imprimimos en el visor---------------------------------------------------
      */

      if oVisor != nil
         oVisor:SetBufferLine( { "Total: ",  Trans( nTotTik, cPorDiv ) },     1 )
         oVisor:SetBufferLine( { "Cambio: ", Trans( nCambioTik, cPorDiv ) },  2 )
         oVisor:WriteBufferLine()
      end if

   end if

   if lSaveNewTik
      lSaveNewTik          := .f.
   end if

Return Nil

//---------------------------------------------------------------------------//

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
         nCalculo := Round( nCalculo / ( 1 + ( uTmpL )->nIvaTil / 100 ), nDec )

      case ValType( uTmpL ) == "O"
         nCalculo := Round( nCalculo / ( 1 + uTmpL:nIvaTil / 100 ), nDec )

   end case

   if nVdv != 0
      nCalculo    := nCalculo / nVdv
   end if

Return ( Round( nCalculo, nDec ) )

//---------------------------------------------------------------------------//

Function nImpUTpv( uTikT, uTikL, nDec, nVdv, cPouDiv, nPrc )

   local nCalculo
   local nDtoEsp     := 0
   local nDtoPP      := 0

   DEFAULT uTikT     := dbfTikT
   DEFAULT uTikL     := dbfTikL
   DEFAULT nDec      := nDouDiv()
   DEFAULT nVdv      := 1
   DEFAULT nPrc      := 0

   nCalculo          := nTotUTpv( uTikL, nDec, nVdv, nPrc )

   do case
      case IsChar( uTikL )

         if ( uTikL )->nDtoLin != 0
            nCalculo -= ( uTikL )->nDtoLin * nCalculo / 100  // Dto porcentual
         end if

         if ( uTikL )->nIvaTil != 0
            nCalculo -= Round( nCalculo / ( 100 / ( uTikL )->nIvaTil + 1 ), nDec )
         end if

      case IsObject( uTikL )

         if uTikL:nDtoLin != 0
            nCalculo -= uTikL:nDtoLin * nCalculo / 100  // Dto porcentual
         end if

         if uTikL:nIvaTil != 0
            nCalculo -= Round( nCalculo / ( 100 / uTikL:nIvaTil + 1 ), nDec )
         end if

   end case

   // Decuentos de la cabecera-------------------------------------------------

   do case
      case IsChar( uTikT )

         if ( uTikT )->cTipTik == SAVDEV
            nCalculo := - nCalculo
         end if

         nDtoEsp     := Round( nCalculo * ( uTikT )->nDtoEsp / 100, nDec )

         nDtoPp      := Round( nCalculo * ( uTikT )->nDpp / 100, nDec )

         nCalculo    -= nDtoEsp
         nCalculo    -= nDtoPp

      case IsObject( uTikT )

         if uTikT:cTipTik == SAVDEV
            nCalculo := - nCalculo
         end if

         nDtoEsp     := Round( nCalculo * uTikT:nDtoEsp / 100, nDec )

         nDtoPp      := Round( nCalculo * uTikT:nDpp / 100, nDec )

         nCalculo    -= nDtoEsp
         nCalculo    -= nDtoPp

   end case

Return ( if( cPouDiv != nil, Trans( nCalculo, cPouDiv ), nCalculo ) )

//---------------------------------------------------------------------------//

FUNCTION nImpLTpv( uTikT, uTikL, nDec, nRou, nVdv, cPouDiv, nPrc )

   local nCalculo
   local nDtoEsp     := 0
   local nDtoPp      := 0

   DEFAULT nDec      := 0
   DEFAULT nRou      := 0
   DEFAULT nVdv      := 1
   DEFAULT nPrc      := 0

   nCalculo          := nTotLTpv( uTikL, nDec, nRou, nVdv, nPrc )

   do case
      case IsChar( uTikL )

         if ( uTikL )->nIvaTil != 0
            nCalculo -= Round( nCalculo / ( 100 / ( uTikL )->nIvaTil + 1 ), nDec )
         end if

      case IsObject( uTikL )

         if uTikL:nIvaTil != 0
            nCalculo -= Round( nCalculo / ( 100 / uTikL:nIvaTil + 1 ), nDec )
         end if

   end case

   // Decuentos de la cabecera-------------------------------------------------

   do case
      case IsChar( uTikT )

         if ( uTikT )->cTipTik == SAVDEV
            nCalculo := - nCalculo
         end if

         nDtoEsp     := Round( nCalculo * ( uTikT )->nDtoEsp / 100, nDec )
         nDtoPp      := Round( nCalculo * ( uTikT )->nDpp / 100, nDec )

         nCalculo    -= nDtoEsp
         nCalculo    -= nDtoPp

      case IsObject( uTikT )

         if uTikT:cTipTik == SAVDEV
            nCalculo := - nCalculo
         end if

         nDtoEsp     := Round( nCalculo * uTikT:nDtoEsp / 100, nDec )
         nDtoPp      := Round( nCalculo * uTikT:nDpp / 100, nDec )

         nCalculo    -= nDtoEsp
         nCalculo    -= nDtoPp

   end case

RETURN ( if( cPouDiv != nil, Trans( nCalculo, cPouDiv ), nCalculo ) )

//---------------------------------------------------------------------------//

FUNCTION nBasLTpv( uTikL, nDec, nRou, nVdv, cPouDiv, nPrc )

   local nCalculo

   DEFAULT nDec      := nDouDiv()
   DEFAULT nRou      := nRouDiv()
   DEFAULT nVdv      := 1
   DEFAULT nPrc      := 0

   nCalculo          := nTotLTpv( uTikL, nDec, nRou, nVdv, nPrc )

   do case
      case IsChar( uTikL )

         if ( uTikL )->nIvaTil != 0
            nCalculo := Round( nCalculo / ( 1 + ( ( uTikL )->nIvaTil / 100 ) ), nDec )
         end if

      case IsObject( uTikL )

         if uTikL:nIvaTil != 0
            nCalculo := Round( nCalculo / ( 1 + ( uTikL:nIvaTil / 100 ) ), nDec )
         end if

   end case

RETURN ( if( cPouDiv != nil, Trans( nCalculo, cPouDiv ), nCalculo ) )

//---------------------------------------------------------------------------//

Function nBrtLTpv( uTikT, uTikL, nDec, nVdv, cPouDiv, nPrc )

   local nCalculo

   DEFAULT uTikT     := dbfTikT
   DEFAULT uTikL     := dbfTikL
   DEFAULT nDec      := nDouDiv()
   DEFAULT nVdv      := 1
   DEFAULT nPrc      := 0

   nCalculo          := nTotUTpv( uTikL, nDec, nVdv, nPrc )
   nCalculo          *= nTotNTpv( uTikL )

Return ( if( cPouDiv != nil, Trans( nCalculo, cPouDiv ), nCalculo ) )

//---------------------------------------------------------------------------//

Function nDtoUTpv( dbfTmpL, nDec, nVdv )

   local nCalculo

   DEFAULT dbfTmpL   := dbfTikL
   DEFAULT nDec      := nDouDiv()
   DEFAULT nVdv      := 1

   nCalculo          := ( dbfTmpL )->nDtoDiv

   if nVdv != 0
      nCalculo       := nCalculo / nVdv
   end if

Return ( round( nCalculo, nDec ) )

//---------------------------------------------------------------------------//

Function nTotNTikTpv( uDbf )

   local nTotUnd

   DEFAULT uDbf   := dbfTikL

   do case
      case ValType( uDbf ) == "A"

         nTotUnd  := uDbf[ _NUNTTIL ]

      case ValType( uDbf ) == "C"

         nTotUnd  := ( uDbf )->nUntTil

      otherwise

         nTotUnd  := uDbf:nUntTil

   end case

Return ( nTotUnd )

//---------------------------------------------------------------------------//

Function nTotVTikTpv( uDbf, lCombinado )

   local nTotUnd

   DEFAULT uDbf         := dbfTikL
   DEFAULT lCombinado   := .f.

   do case
      case ValType( uDbf ) == "A"

         if !lCombinado
            nTotUnd     := uDbf[ _NUNTTIL ] * NotCero( uDbf[ _NFACCNV ] )
         else
            nTotUnd     := uDbf[ _NUNTTIL ] * NotCero( uDbf[ _NFCMCNV ] )
         end if

      case ValType( uDbf ) == "C"

         if !lCombinado
            nTotUnd     := ( uDbf )->nUntTil * NotCero( ( uDbf )->nFacCnv )
         else
            nTotUnd     := ( uDbf )->nUntTil * NotCero( ( uDbf )->nFcmCnv )
         end if

      otherwise

         if !lCombinado
            nTotUnd     := uDbf:nUntTil * NotCero( uDbf:nFacCnv )
         else
            nTotUnd     := uDbf:nUntTil * NotCero( uDbf:nFcmCnv )
         end if

   end case

Return ( nTotUnd )

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

         if ( cTikL )->nIvaTil != 0

            if Empty( nPrc ) .or. nPrc == 1
               nCalculo += nTotLUno( cTikL, nDec, nRou, nVdv )
            end if

            if Empty( nPrc ) .or. nPrc == 2
               nCalculo += nTotLDos( cTikL, nDec, nRou, nVdv )
            end if

            nCalculo    -= Round( nCalculo / ( 1 + ( cTikL )->nIvaTil / 100 ), nDec )

         end if

      case ValType( cTikL ) == "O"

         if cTikL:nIvaTil != 0

            if Empty( nPrc ) .or. nPrc == 1
               nCalculo += nTotLUno( cTikL:cAlias, nDec, nRou, nVdv )
            end if

            if Empty( nPrc ) .or. nPrc == 2
               nCalculo += nTotLDos( cTikL:cAlias, nDec, nRou, nVdv )
            end if

            nCalculo    -= Round( nCalculo / ( 1 + ( cTikL:cAlias )->nIvaTil / 100 ), nDec )

         end if

   end case

   do case
      case Valtype( cTikT ) == "C" .and. ( cTikT )->cTipTik == SAVDEV
         nCalculo       := - nCalculo

      case Valtype( cTikT ) == "O" .and. cTikT:cTipTik == SAVDEV
         nCalculo       := - nCalculo

   end case

   if nCalculo != 0 .and. nVdv != 0
      nCalculo          := nCalculo / nVdv
   end if

Return ( Round( nCalculo, nRou ) )

//---------------------------------------------------------------------------//

/*
Devuelve el precio linea
*/

Function nNetLTpv( dbfTmpL, nDec, nRou, nVdv )

   local nCalculo    := 0

   DEFAULT dbfTmpL   := dbfTikL
   DEFAULT nDec      := nDouDiv()
   DEFAULT nRou      := nRouDiv()
   DEFAULT nVdv      := 1

   nCalculo          := nTotLTpv( dbfTmpL, nDec, nRou, nVdv )

   if ( dbfTmpL )->nIvaTil != 0
      nCalculo       := nCalculo / ( ( ( dbfTmpL )->nIvaTil / 100 ) + 1 )
   end if

Return ( Round( nCalculo, nRou ) )

//---------------------------------------------------------------------------//

Static Function EdtCobTik( oWndBrw, lBig )

   local nOrd
   local nRec
   local aTmp
   local aGet
   local oBlock
   local oError
   local cSerAlb
   local cNumAlb
   local cSufAlb
   local cNumTik
   local cNumDoc
   local cCodCli
   local nOrdAnt
   local nDifVale    := 0
   local lGenVale    := .f.

   DEFAULT lBig      := .f.

   if ( ( dbfTikT )->cTipTik == SAVAPT )
      msgStop( "No se pueden realizar cobros sobre tickets apartados.")
      return nil      
   end if 

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   aTmp              := dbScatter( dbfTikT )
   aGet              := Array( ( dbfTikT )->( fCount() ) )
   cNumTik           := ( dbfTikT )->cSerTik + ( dbfTikT )->cNumTik + ( dbfTikT )->cSufTik
   cCodCli           := ( dbfTikT )->cCliTik
   cNumDoc           := ( dbfTikT )->cNumDoc
   nOrdAnt           := ( dbfTikT )->( OrdSetFocus( "cNumTik" ) )

   nCopTik           := nCopiasTicketsEnCaja( oUser():cCaja(), dbfCajT )

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

      nRec              := ( dbfAlbCliP )->( Recno() )
      nOrd              := ( dbfAlbCliP )->( OrdSetFocus( "NNUMALB" ) )

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
         while ( dbfAntCliT )->cNumDoc == cNumDoc .and. !( dbfAntCliT )->( eof() )
            dbPass( dbfAntCliT, dbfTmpA, .t. )
            ( dbfAntCliT )->( dbSkip() )
         end while
      end if
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

         cSerAlb     := SubStr( cNumDoc, 1, 1 )
         cNumAlb     := Val( SubStr( cNumDoc, 2, 9 ) )
         cSufAlb     := SubStr( cNumDoc, 11, 2 )

         while ( dbfFacCliP )->( dbSeek( cNumDoc ) ) .and. !( dbfFacCliP )->( eof() )
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
               ( dbfFacCliP )->cSerie     := cSerAlb
               ( dbfFacCliP )->nNumFac    := cNumAlb
               ( dbfFacCliP )->cSufFac    := cSufAlb
               ( dbfFacCliP )->lCobrado   := .t.
               ( dbfFacCliP )->cCodCaj    := oUser():cCaja()
               ( dbfFacCliP )->cCodCli    := cCodCli
               ( dbfFacCliP )->dPreCob    := GetSysDate()
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
         while !( dbfTmpA )->( eof() )
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

         end while

         if dbLock( dbfFacCliT )
            ( dbfFacCliT )->lSndDoc          := .t.
            ( dbfFacCliT )->( dbUnLock() )
         end if

         /*
         Chequeamos el estado de la factura------------------------------------------
         */

         ChkLqdFacCli( nil, dbfFacCliT, dbfFacCliL, dbfFacCliP, dbfAntCliT, dbfIva, dbfDiv )

      case ( dbfTikT )->cTipTik == SAVALB // Como albaran

         cSerAlb     := SubStr( cNumDoc, 1, 1 )
         cNumAlb     := Val( SubStr( cNumDoc, 2, 9 ) )
         cSufAlb     := SubStr( cNumDoc, 11, 2 )

         /*
         Rollback de los pagos-------------------------------------------------------
         */

         while ( dbfAlbCliP )->( dbSeek( cNumDoc ) ) .and. !( dbfAlbCliP )->( eof() )
            if dbLock( dbfAlbCliP )
               ( dbfAlbCliP )->( dbDelete() )
               ( dbfAlbCliP )->( dbUnLock() )
            end if
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
            ( dbfAlbCliP )->lPasado    := ( dbfTmpE )->lPasado
            ( dbfAlbCliP )->lCloPgo    := .f.

            ( dbfAlbCliP )->( dbUnLock() )

            ( dbfTmpE )->( dbSkip() )

         end while

      End Case

      /*
      Apertura de la caja------------------------------------------------------------
		*/

      if ( dbfTikT )->cTipTik != SAVALB
         oUser():OpenCajon()
      end if

      /*
      Guardamos los cambios en la cabercera del tiket--------------------------------
      */

      dbGather( aTmp, dbfTikT )

   end if

   ( dbfTikT )->( OrdSetFocus( nOrdAnt ) )

   RECOVER USING oError

      msgStop( "Imposible realizar pagos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

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

   dbfErase( cNewFilP )
   dbfErase( cNewFilV )
   dbfErase( cNewFilA )
   dbfErase( cNewFilE )

   if !Empty( oWndBrw )
      oWndBrw:oBrw:DrawSelect()
   end if

return nil

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//
// Guarda el ticket

Static Function TmpTiket( aTmp, aGet, nMode, lClean, lImprimirComanda, lLiberarMesa )

   local oError
   local oBlock
   local nRecno
   local cNumDoc           		:= ""
   local nNumTik           	  	:= ""
   local nOrdAlb

   DEFAULT lClean          		:= .t.
   DEFAULT lImprimirComanda	  	:= .t.
   DEFAULT lLiberarMesa          := .f.

   /*
   Vemos si tenemos lineas que guardar-----------------------------------------
   */

   if ( dbfTmpL )->( ordKeyCount() ) == 0 .and. !lLiberarMesa
      return .t.
   end if

   /*
   Comprobamos la fecha del documento------------------------------------------
   */

   if !lValidaOperacion( aTmp[ _DFECTIK ] )
      return .f.
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
   Parar timer de impresión pda------------------------------------------------
   */

   StopAutoImp()

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

   if Empty( aTmp[ _CTIPTIK ] )
      aTmp[ _CTIPTIK ]     := SAVTIK
   end if

   if Empty( aTmp[ _DFECCRE ] )
      aTmp[ _DFECCRE ]     := Date()
   end if

   if Empty( aTmp[ _CTIMCRE ] )
      aTmp[ _CTIMCRE ]     := SubStr( Time(), 1, 5 )
   end if

   /*
   Inicializamos las variables de importe---------------------------------------
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

		/*
      Grabamos el tiket--------------------------------------------------------
		*/

      do case
      case nMode == APPD_MODE

         /*
         Obtenemos el nuevo numero del Tiket-----------------------------------
         */

         if !Empty( oMetMsg )
            oMetMsg:cText           := 'Obtenemos el nuevo número'
            oMetMsg:Refresh()
         end if

         aTmp[ _CNUMTIK ]           := Str( nNewDoc( aTmp[ _CSERTIK ], dbfTikT, "nTikCli", 10, dbfCount ), 10 )
         aTmp[ _CSUFTIK ]           := RetSufEmp()
         nNumTik                    := aTmp[ _CSERTIK ] + aTmp[ _CNUMTIK ] + aTmp[ _CSUFTIK ]

         /*
         Fechas y horas de creacon del tiket-----------------------------------
         */

         aTmp[ _CHORTIK ]           := Substr( Time(), 1, 5 )
         aTmp[ _LCLOTIK ]           := .f.

      case nMode == EDIT_MODE

         nNumTik                    := aTmp[ _CSERTIK ] + aTmp[ _CNUMTIK ] + aTmp[ _CSUFTIK ]
         cNumDoc                    := aTmp[ _CNUMDOC ]

         /*
         Nos posicionamos en el registro a guardar-----------------------------
         */

         if !( dbfTikT )->( dbSeek( nNumTik ) )
            if !Empty( oMetMsg )
               oMetMsg:cText  := 'Ticket no encontrado'
               oMetMsg:Refresh()
            end if
         end if

         /*
         Eliminamos las lineas----------------------------------------------------
         */

         if !Empty( oMetMsg )
            oMetMsg:cText     := 'Eliminando lineas'
            oMetMsg:Refresh()
         end if

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

      if !Empty( oMetMsg )
         oMetMsg:cText        := 'Archivando lineas'
         oMetMsg:SetTotal( ( dbfTmpL )->( ordKeyCount() ) )
      end if

      nRecno               := ( dbfTmpL )->( Recno() )

      ( dbfTmpL )->( dbGoTop() )
      while !( dbfTmpL )->( eof() )

         if !Empty( oMetMsg )
            oMetMsg:Set( ( dbfTmpL )->( Recno() ) )
         end if

         dbPass( dbfTmpL, dbfTikL, .t., aTmp[ _CSERTIK ], aTmp[ _CNUMTIK ], aTmp[ _CSUFTIK ] )

         ( dbfTmpL )->( dbSkip() )

      end while

      ( dbfTmpL )->( dbGoTo( nRecno ) )

      /*
      Escribimos definitivamente en el disco-----------------------------------
      */

      if !Empty( oMetMsg )
         oMetMsg:Set( 0 )
         oMetMsg:cText        := 'Archivando ticket'
         oMetMsg:Refresh()
      end if

      WinGather( aTmp, aGet, dbfTikT, nil, nMode, nil, lClean )

      /*
      Escribe los datos pendientes---------------------------------------------
      */

      dbCommitAll()

		/*
      Cerrando-----------------------------------------------------------------
		*/

      oDlgTpv:Enable()
      oDlgTpv:aEvalWhen()

   /*
   Cerrando el control de errores----------------------------------------------
   */

   RECOVER USING oError

      msgStop( "Error en la grabación del ticket" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   /*
   Reactivamos de nuevo el timer para las impresiónes de pda-------------------
   */

   StartAutoImp()

Return ( .t. )

//---------------------------------------------------------------------------//

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

   local oDatos      := TFormatosImpresion():Load( dbfCajT )

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
         WHEN     ( nSelTik == 1 ) ;
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
         WHEN     ( nSelTik == 1 ) ;
			OF 		oDlg

		REDEFINE GET dFecDes;
			ID 		170 ;
			WHEN 		( nSelTik == 2 ) ;
			OF 		oDlg

		REDEFINE GET dFecHas;
			ID 		180 ;
			WHEN 		( nSelTik == 2 ) ;
			OF 		oDlg

      /*
      Formato e impresora para tiket
      */

      REDEFINE GET oDatos:oFormatoTiket VAR oDatos:cFormatoTiket ;
         ID       251 ;
         VALID    ( cDocumento( oDatos:oFormatoTiket, oDatos:oSayFmtTik, dbfDoc ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwDocumento( oDatos:oFormatoTiket, oDatos:oSayFmtTik, "TK" ) ) ;
         OF       oDlg

      REDEFINE GET oDatos:oSayFmtTik VAR oDatos:cSayFmtTik ;
         ID       252 ;
         WHEN     ( .f. );
         OF       oDlg

      REDEFINE GET oDatos:oPrinterTik VAR oDatos:cPrinterTik;
         WHEN     ( .f. ) ;
         ID       253 ;
         OF       oDlg

      TBtnBmp():ReDefine( 254, "Printer_preferences_16",,,,,{|| PrinterPreferences( oDatos:oPrinterTik ) }, oDlg, .f., , .f.,  )

      TBtnBmp():ReDefine( 255, "Printer_pencil_16",,,,,{|| EdtDocumento( oDatos:cFormatoTiket ) }, oDlg, .f., , .f.,  )

      /*
      Formato e impresora para el vale
      */

      REDEFINE GET oDatos:oFmtVal VAR oDatos:cFmtVal ;
         ID       261 ;
         VALID    ( cDocumento( oDatos:oFmtVal, oDatos:oSayFmtVal, dbfDoc ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwDocumento( oDatos:oFmtVal, oDatos:oSayFmtVal, "TK" ) ) ;
         OF       oDlg

      REDEFINE GET oDatos:oSayFmtVal VAR oDatos:cSayFmtVal ;
         ID       262 ;
         WHEN     ( .f. );
         OF       oDlg

      REDEFINE GET oDatos:oPrinterVal VAR oDatos:cPrinterVal;
         WHEN     ( .f. ) ;
         ID       263 ;
         OF       oDlg

      TBtnBmp():ReDefine( 264, "Printer_preferences_16",,,,,{|| PrinterPreferences( oDatos:oPrinterVal ) }, oDlg, .f., , .f.,  )

      TBtnBmp():ReDefine( 265, "Printer_pencil_16",,,,,{|| EdtDocumento( oDatos:cFmtVal ) }, oDlg, .f., , .f.,  )

      /*
      Formato e impresora para albaranes
      */

      REDEFINE GET oDatos:oFmtAlb VAR oDatos:cFmtAlb ;
         ID       191 ;
         VALID    ( cDocumento( oDatos:oFmtAlb, oDatos:oSayFmtAlb, dbfDoc ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwDocumento( oDatos:oFmtAlb, oDatos:oSayFmtAlb, "TK" ) ) ;
         OF       oDlg

      REDEFINE GET oDatos:oSayFmtAlb VAR oDatos:cSayFmtAlb ;
         ID       192 ;
         WHEN     ( .f. );
         OF       oDlg

      REDEFINE GET oDatos:oPrinterAlb VAR oDatos:cPrinterAlb;
         WHEN     ( .f. ) ;
         ID       193 ;
         OF       oDlg

      TBtnBmp():ReDefine( 194, "Printer_preferences_16",,,,,{|| PrinterPreferences( oDatos:oPrinterAlb ) }, oDlg, .f., , .f.,  )

      TBtnBmp():ReDefine( 195, "Printer_pencil_16",,,,,{|| EdtDocumento( oDatos:cFmtAlb ) }, oDlg, .f., , .f.,  )

      /*
      Formato e impresora para facturas
      */

      REDEFINE GET oDatos:oFmtFac VAR oDatos:cFmtFac ;
         ID       201 ;
         VALID    ( cDocumento( oDatos:oFmtFac, oDatos:oSayFmtFac, dbfDoc ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwDocumento( oDatos:oFmtAlb, oDatos:oSayFmtFac, "TK" ) ) ;
         OF       oDlg

      REDEFINE GET oDatos:oSayFmtFac VAR oDatos:cSayFmtFac ;
         ID       202 ;
         WHEN     ( .f. );
         OF       oDlg

      REDEFINE GET oDatos:oPrinterFac VAR oDatos:cPrinterFac;
         WHEN     ( .f. ) ;
         ID       203 ;
         OF       oDlg

      TBtnBmp():ReDefine( 204, "Printer_preferences_16",,,,,{|| PrinterPreferences( oDatos:oPrinterFac ) }, oDlg, .f., , .f.,  )

      TBtnBmp():ReDefine( 205, "Printer_pencil_16",,,,,{|| EdtDocumento( oDatos:cFmtFac ) }, oDlg, .f., , .f.,  )


      REDEFINE CHECKBOX lInvOrden ;
         ID       500 ;
         OF       oDlg

      REDEFINE BUTTON ;
			ID 		505 ;
			OF 		oDlg ;
         ACTION   (  PrnSerTik( nSelTik, cSerDes + Str( cNumDes ) + cSufDes, cSerHas + Str( cNumHas ) + cSufHas, dFecDes, dFecHas, oDlg, lInvOrden, oDatos ),;
                     oDlg:End( IDOK ) )

		REDEFINE BUTTON ;
			ID 		510 ;
			OF 		oDlg ;
         CANCEL ;
         ACTION   ( oDlg:end() )

   oDlg:AddFastKey( VK_F5, {|| PrnSerTik( nSelTik, cSerDes + Str( cNumDes ) + cSufDes, cSerHas + Str( cNumHas ) + cSufHas, dFecDes, dFecHas, oDlg, lInvOrden, oDatos ), oDlg:End( IDOK ) } )

   oDlg:bStart := { || oSerDes:SetFocus() }

   ACTIVATE DIALOG oDlg CENTER

	( dbfTikT )->( OrdSetFocus( nOrdAnt ) )
	( dbfTikT )->( dbGoTo( nRecAnt ) )

	oBrw:refresh()

Return ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

/*
Imprime los tickets desde un punto a otro
*/

Static Function PrnSerTik( nSelTik, cNumDes, cNumHas, dFecDes, dFecHas, oDlg, lInvOrden, oDatos )

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

            ImpTiket( , , .t., , oDatos )

            ( dbfTikT )->( dbSkip() )

         end while

      end if

   else

      if ( dbfTikT )->( dbSeek( uNumHas ) )

         while ( dbfTikT )->( OrdKeyVal() ) >= uNumDes   .and.;
               ( dbfTikT )->( OrdKeyVal() ) <= uNumHas   .and.;
               !( dbfTikT )->( Bof() )

            ImpTiket( , , .t., , oDatos )

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
   local nRecno      := ( dbfTikL )->( RecNo() )

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

Return ( nTotal )

//----------------------------------------------------------------------------//

Function aTotTik( cNumTik, dbfTikT, dbfTikL, dbfDiv, aTmp, cDivRet, lPic, lExcCnt )

   nTotTik( cNumTik, dbfTikT, dbfTikL, dbfDiv, aTmp, cDivRet, lPic, lExcCnt )

Return ( { nTotNet, nTotIva, nTotTik, nTotIvm, aIvaTik, aBasTik, aImpTik, aIvmTik } )

//---------------------------------------------------------------------------//

Static Function bButtonsPago( cCodPago, oGetPago )

Return ( {|| oGetPago:cText( cCodPago ), oGetPago:lValid() } )

Static Function bButtonsGrad( oButton )

   oButton:bClrGrad  := { | lInvert |  If( lInvert .or. oButton:lBtnDown, ;
                                       { { 1/3, nRGB( 255, 253, 222 ), nRGB( 255, 231, 151 ) }, ;
                                       { 2/3, nRGB( 255, 215,  84 ), nRGB( 255, 233, 162 ) }  ;
                                       }, ;
                                       { { 1/2, nRGB( 219, 230, 244 ), nRGB( 207-50, 221-25, 255 ) }, ;
                                       { 1/2, nRGB( 201-50, 217-25, 255 ), nRGB( 231, 242, 255 ) }  ;
                                       } ) }

Return ( nil )

//--------------------------------------------------------------------------//
// Devuelve el total de cobrado en un tiket
//

Function nTotLCobTik( dbfTikP, dbfDiv, cDivRet, lPic )

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
      nTotal         := nCnv2Div( nTotal, cCodDiv, cDivRet, dbfDiv )
   end if



   if lPic
      nTotal         := Trans( nTotal, cPorDiv )
   end if

Return ( nTotal )

//----------------------------------------------------------------------------//
/*
Total en vales de un ticket para impresion
*/

Function nImpValTik( cNumTik, cTikT, cTikL, cDiv, cDivRet )

   local cPorDiv
   local nDorDiv
   local nOrdAnt
   local cCodDiv
   local nRecAnt
   local nLinAnt
   local nTotTik      := 0

   DEFAULT cTikT     := dbfTikT
   DEFAULT cDiv      := dbfDiv
   DEFAULT cNumTik   := ( cTikT )->cSerTik + ( cTikT )->cNumTik + ( cTikT )->cSufTik

   USE ( cPatEmp() + "TIKEL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIKEL", @cTikL ) )
   SET ADSINDEX TO ( cPatEmp() + "TIKEL.CDX" ) ADDITIVE

   cCodDiv           := ( cTikT )->cDivTik
   nRecAnt           := ( cTikT )->( Recno() )
   cPorDiv           := cPorDiv( cCodDiv, cDiv ) // Picture de la divisa redondeada
   nDorDiv           := nRouDiv( cCodDiv, cDiv ) // Decimales de redondeo

   nOrdAnt           := ( cTikT )->( OrdSetFocus( "cTikVal" ) )

   if ( cTikT )->( dbSeek( cNumTik ) )

      while ( cTikT )->cTikVal == cNumTik .and. !( cTikT )->( eof() )

         nTotTik     += nTotTik( ( cTikT )->cSerTik + ( cTikT )->cNumTik + ( cTikT )->cSufTik, cTikT, cTikL, cDiv, nil, cDivRet, .f. )

         ( cTikT )->( dbSkip() )

      end while

   end if

   ( cTikT )->( OrdSetFocus( nOrdAnt ) )

   /*
   Reposicionamiento-----------------------------------------------------------
   */

   ( cTikT )->( dbGoTo( nRecAnt ) )
   ( cTikT )->( OrdSetFocus( nOrdAnt ) )

   ( cTikL )->( dbCloseArea() )

   /*
   El total de los vales siempre debe de ser positivo--------------------------
   */

   nTotTik            := Abs( Round( nTotTik, nDorDiv ) )

   /*
   Otras divisas---------------------------------------------------------------
   */

   if cDivRet != nil .and. cCodDiv != cDivRet
      cPorDiv        := cPorDiv( cDivRet, cDiv ) // Picture de la divisa redondeada
      nTotTik        := nCnv2Div( nTotTik, cCodDiv, cDivRet, cDiv )
   end if

Return ( nTotTik )

//----------------------------------------------------------------------------//

/*
Total acumulado en vales
*/

Function nImpValCli( cCliTik, cTikT, cTikL, cDiv, cDivRet )

   local cPorDiv
   local nDorDiv
   local nOrdAnt
   local cCodDiv
   local nRecAnt
   local nLinAnt
   local nTotTik      := 0

   DEFAULT cTikT     := dbfTikT
   DEFAULT cDiv      := dbfDiv
   DEFAULT cCliTik   := ( cTikT )->cCliTik

   USE ( cPatEmp() + "TIKEL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIKEL", @cTikL ) )
   SET ADSINDEX TO ( cPatEmp() + "TIKEL.CDX" ) ADDITIVE

   cCodDiv           := ( cTikT )->cDivTik
   nRecAnt           := ( cTikT )->( Recno() )
   cPorDiv           := cPorDiv( cCodDiv, cDiv ) // Picture de la divisa redondeada
   nDorDiv           := nRouDiv( cCodDiv, cDiv ) // Decimales de redondeo

   nOrdAnt           := ( cTikT )->( OrdSetFocus( "cCliVal" ) )
   if ( cTikT )->( dbSeek( cCliTik ) )

      while ( cTikT )->cCliTik == cCliTik .and. !( cTikT )->( eof() )

         nTotTik     += nTotTik( ( cTikT )->cSerTik + ( cTikT )->cNumTik + ( cTikT )->cSufTik, cTikT, cTikL, cDiv, nil, cDivRet, .f. )

         ( cTikT )->( dbSkip() )

      end while

   end if

   ( cTikT )->( OrdSetFocus( nOrdAnt ) )

   /*
   Reposicionamiento-----------------------------------------------------------
   */

   ( cTikT )->( dbGoTo( nRecAnt ) )
   ( cTikT )->( OrdSetFocus( nOrdAnt ) )

   ( cTikL )->( dbCloseArea() )

   /*
   El total de los vales siempre debe de ser positivo--------------------------
   */

   nTotTik            := Abs( Round( nTotTik, nDorDiv ) )

   /*
   Otras divisas---------------------------------------------------------------
   */

   if cDivRet != nil .and. cCodDiv != cDivRet
      cPorDiv        := cPorDiv( cDivRet, cDiv ) // Picture de la divisa redondeada
      nTotTik        := nCnv2Div( nTotTik, cCodDiv, cDivRet, cDiv )
   end if

Return ( nTotTik )

//----------------------------------------------------------------------------//

/*
Total vales de un ticket
*/

Function nTotValTik( cNumTik, cTikT, cTikL, cDiv, cDivRet, lPic )

   local cPorDiv
   local nDorDiv
   local nOrdAnt
   local cCodDiv
   local nRecAnt
   local nTotal      := 0

   DEFAULT cTikT     := dbfTikT
   DEFAULT cTikL     := dbfTikL
   DEFAULT cDiv      := dbfDiv
   DEFAULT lPic      := .f.
   DEFAULT cNumTik   := ( cTikT )->cSerTik + ( cTikT )->cNumTik + ( cTikT )->cSufTik

   cPorDiv           := cPorDiv( cCodDiv, cDiv ) // Picture de la divisa redondeada
   nDorDiv           := nRouDiv( cCodDiv, cDiv ) // Decimales de redondeo

   cCodDiv           := ( cTikT )->cDivTik

   nRecAnt           := ( cTikT )->( Recno() )
   nOrdAnt           := ( cTikT )->( OrdSetFocus( "cDocVal" ) )

   if ( cTikT )->( dbSeek( cNumTik ) )

      while ( cTikT )->cValDoc == cNumTik .and. !( cTikT )->( eof() )

         nTotal      += nTotTik( ( cTikT )->cSerTik + ( cTikT )->cNumTik + ( cTikT )->cSufTik )

         ( cTikT )->( dbSkip() )

      end while

   end if

   ( cTikT )->( OrdSetFocus( nOrdAnt ) )
   ( cTikT )->( dbGoTo( nRecAnt ) )

   /*
   El total de los vales siempre debe de ser positivo--------------------------
   */

   nTotal            := Abs( Round( nTotal, nDorDiv ) )

   /*
   Otras divisas---------------------------------------------------------------
   */

   if cDivRet != nil .and. cCodDiv != cDivRet
      cPorDiv        := cPorDiv( cDivRet, cDiv ) // Picture de la divisa redondeada
      nTotal         := nCnv2Div( nTotal, cCodDiv, cDivRet, cDiv )
   end if

Return ( if( lPic, Trans( nTotal, cPorDiv ), nTotal ) )

//---------------------------------------------------------------------------//

/*
Total vales de un ticket para informes
*/

Function nTotValTikInfo( cNumTik, cTikT, cDiv, cDivRet, lPic )

   local cPorDiv
   local nDorDiv
   local nOrdAnt
   local cCodDiv
   local nRecAnt
   local nTotal      := 0
   local dbfTmpTikL

   DEFAULT cTikT     := dbfTikT
   DEFAULT cDiv      := dbfDiv
   DEFAULT lPic      := .f.
   DEFAULT cNumTik   := ( cTikT )->cSerTik + ( cTikT )->cNumTik + ( cTikT )->cSufTik

   /*
   Abrimos la tabla de las lineas porque el informe las va a tener con un scope
   */

   USE ( cPatEmp() + "TIKEL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIKEL", @dbfTmpTikL ) )
   SET ADSINDEX TO ( cPatEmp() + "TIKEL.CDX" ) ADDITIVE
   ( dbfTmpTikL )->( OrdSetFocus( "cNumTil" ) )

   cPorDiv           := cPorDiv( cCodDiv, cDiv ) // Picture de la divisa redondeada
   nDorDiv           := nRouDiv( cCodDiv, cDiv ) // Decimales de redondeo

   cCodDiv           := ( cTikT )->cDivTik

   nRecAnt           := ( cTikT )->( Recno() )
   nOrdAnt           := ( cTikT )->( OrdSetFocus( "cDocVal" ) )

   if ( cTikT )->( dbSeek( cNumTik ) )

      while ( cTikT )->cValDoc == cNumTik .and. !( cTikT )->( eof() )

         nTotal      += nTotTik( ( cTikT )->cSerTik + ( cTikT )->cNumTik + ( cTikT )->cSufTik, cTikT, dbfTmpTikL )

         ( cTikT )->( dbSkip() )

      end while

   end if

   ( cTikT )->( OrdSetFocus( nOrdAnt ) )
   ( cTikT )->( dbGoTo( nRecAnt ) )

   /*
   El total de los vales siempre debe de ser positivo--------------------------
   */

   nTotal            := Abs( Round( nTotal, nDorDiv ) )

   /*
   Otras divisas---------------------------------------------------------------
   */

   if cDivRet != nil .and. cCodDiv != cDivRet
      cPorDiv        := cPorDiv( cDivRet, cDiv ) // Picture de la divisa redondeada
      nTotal         := nCnv2Div( nTotal, cCodDiv, cDivRet, cDiv )
   end if

   /*
   Cerramos la tabla de lineas-------------------------------------------------
   */

   CLOSE ( dbfTmpTikL )

   dbfTmpTikL           := nil

Return ( if( lPic, Trans( nTotal, cPorDiv ), nTotal ) )

//----------------------------------------------------------------------------//

Function nTmpValTik( cTikT, cTikL, cDiv, cDivRet, lPic )

   local cPorDiv
   local nDorDiv
   local nOrdAnt
   local nTotal      := 0
   local cCodDiv     := ( cTikT )->cDivTik
   local nRecAnt     := ( cTikT )->( Recno() )

   DEFAULT cTikT     := dbfTikT
   DEFAULT cTikL     := dbfTikL
   DEFAULT cDiv      := dbfDiv
   DEFAULT lPic      := .f.

   cPorDiv           := cPorDiv( cCodDiv, cDiv ) // Picture de la divisa redondeada
   nDorDiv           := nRouDiv( cCodDiv, cDiv ) // Decimales de redondeo

   ( cTikT )->( dbGoTop() )
   while !( cTikT )->( eof() )
      nTotal      += nTotTik( ( cTikT )->cSerTik + ( cTikT )->cNumTik + ( cTikT )->cSufTik, cTikT, cTikL, cDiv, nil, cDivRet, .f. )
      ( cTikT )->( dbSkip() )
   end while

   /*
   Reposicionamiento-----------------------------------------------------------
   */

   ( cTikT )->( dbGoTo( nRecAnt ) )

   /*
   El total de los vales siempre debe de ser positivo--------------------------
   */

   nTotal            := Abs( Round( nTotal, nDorDiv ) )

   /*
   Otras divisas---------------------------------------------------------------
   */

   if cDivRet != nil .and. cCodDiv != cDivRet
      cPorDiv        := cPorDiv( cDivRet, cDiv ) // Picture de la divisa redondeada
      nTotal         := nCnv2Div( nTotal, cCodDiv, cDivRet, cDiv )
   end if

Return ( if( lPic, Trans( nTotal, cPorDiv ), nTotal ) )

//----------------------------------------------------------------------------//


Static function BeginTrans( aTmp, aGet, nMode, lNewFile )

   local oError
   local oBlock
   local nRecAnt
   local nOrdAnt
   local lErrors        := .f.
   local cNumTik        := aTmp[ _CSERTIK ] + aTmp[ _CNUMTIK ] + aTmp[ _CSUFTIK ]
   local cSerCli

   DEFAULT lNewFile     := .t.

   CursorWait()

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

      ( dbfTmpL   )->( dbCloseArea() )
      ( dbfTmpP   )->( dbCloseArea() )
      ( dbfTmpV   )->( dbCloseArea() )
      ( dbfTmpA   )->( dbCloseArea() )
      ( dbfTmpE   )->( dbCloseArea() )
      ( dbfTmpC   )->( dbCloseArea() )
      ( dbfTmpS   )->( dbCloseArea() )
      ( dbfTmpN   )->( dbCloseArea() )

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

      if !Empty( cNewFilC )
         dbfErase( cNewFilC )
      end if

      if !Empty( cNewFilS )
         dbfErase( cNewFilS )
      end if

      if !Empty( cNewFilN )
         dbfErase( cNewFilN )
      end if

      /*
      Crear la base de datos local para las lineas del ticket------------------
		*/

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

      /*
      Crear la base de datos local para las lineas de comandas-----------------
      */

      cNewFilC       := cGetNewFileName( cPatTmp() + "TikC" )
      dbCreate( cNewFilC, aSqlStruct( aColTik() ), cLocalDriver() )
      dbUseArea( .t., cLocalDriver(), cNewFilC, cCheckArea( "TikC", @dbfTmpC ), .f. )
      if !NetErr()
         ( dbfTmpC )->( OrdCondSet( "!Deleted()", {||!Deleted() } ) )
         ( dbfTmpC )->( OrdCreate( cNewFilC, "CNUMTIL", "CSERTIL + CNUMTIL + CSUFTIL", {|| Field->cSerTil + Field->cNumTil + Field->cSufTil } ) )
      end if

      /*
      Crear la base de datos local para los numeros de serie-------------------
      */

      cNewFilS       := cGetNewFileName( cPatTmp() + "TikS" )
      dbCreate( cNewFilS, aSqlStruct( aSerTik() ), cLocalDriver() )
      dbUseArea( .t., cLocalDriver(), cNewFilS, cCheckArea( "TikS", @dbfTmpS ), .f. )
      if !NetErr()
         ( dbfTmpS )->( OrdCondSet( "!Deleted()", {||!Deleted() } ) )
         ( dbfTmpS )->( OrdCreate( cNewFilS, "nNumLin", "Str( nNumLin, 4 ) + cCbaTil", {|| Str( Field->nNumLin, 4 ) + Field->cCbaTil } ) )
      end if

      /*
      Crear la base de datos local para las lineas de anulaciones--------------
      */

      cNewFilN       := cGetNewFileName( cPatTmp() + "TikAnu" )
      dbCreate( cNewFilN, aSqlStruct( aColTik() ), cLocalDriver() )
      dbUseArea( .t., cLocalDriver(), cNewFilN, cCheckArea( "TikAnu", @dbfTmpN ), .f. )
      if !NetErr()
         ( dbfTmpN )->( OrdCondSet( "!Deleted()", {||!Deleted() } ) )
         ( dbfTmpN )->( OrdCreate( cNewFilN, "cNumTil", "cSerTil + nNumTil + cSufTil", {|| Field->cSerTil + Field->cNumTil + Field->cSufTil } ) )
      end if

   else

      ( dbfTmpL   )->( __dbZap() )
      ( dbfTmpP   )->( __dbZap() )
      ( dbfTmpV   )->( __dbZap() )
      ( dbfTmpA   )->( __dbZap() )
      ( dbfTmpE   )->( __dbZap() )
      ( dbfTmpC   )->( __dbZap() )
      ( dbfTmpS   )->( __dbZap() )
      ( dbfTmpN   )->( __dbZap() )

      ( dbfTmpL   )->( dbGoTop() )
      ( dbfTmpP   )->( dbGoTop() )
      ( dbfTmpV   )->( dbGoTop() )
      ( dbfTmpA   )->( dbGoTop() )
      ( dbfTmpE   )->( dbGoTop() )
      ( dbfTmpC   )->( dbGoTop() )
      ( dbfTmpS   )->( dbGoTop() )
      ( dbfTmpN   )->( dbGoTop() )

   end if

   do case
   case nMode == APPD_MODE

      lApartado                        := .f.

      /*
      Cargando los valores por defecto-----------------------------------------
		*/

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
      aTmp[ _CCLITIK    ]              := cDefCli()
      aTmp[ _CNOMTIK    ]              := RetFld( cDefCli(), dbfClient, "Titulo" )
      aTmp[ _CDIRCLI    ]              := RetFld( cDefCli(), dbfClient, "Domicilio" )
      aTmp[ _CPOBCLI    ]              := RetFld( cDefCli(), dbfClient, "Poblacion" )
      aTmp[ _CPRVCLI    ]              := RetFld( cDefCli(), dbfClient, "Provincia" )
      aTmp[ _CPOSCLI    ]              := RetFld( cDefCli(), dbfClient, "CodPostal" )
      aTmp[ _CDNICLI    ]              := RetFld( cDefCli(), dbfClient, "Nif" )
      aTmp[ _NREGIVA    ]              := RetFld( cDefCli(), dbfClient, "nRegIva" )
      aTmp[ _NUNDANT    ]              := 0

      if !Empty( RetFld( cDefCli(), dbfClient, "nTarifa" ) )
         if !Empty( aGet[ _NTARIFA ] )
            aGet[ _NTARIFA ]:cText( RetFld( cDefCli(), dbfClient, "nTarifa" ) )
         else
            aTmp[ _NTARIFA ]           := RetFld( cDefCli(), dbfClient, "nTarifa" )
         end if
      else
         aTmp[ _NTARIFA    ]           := Max( uFieldEmpresa( "nPreVta" ), 1 )
      end if

      if !Empty( aGet[ _CCLITIK ] )
         aGet[ _CCLITIK ]:cText( cDefCli() )
      end if

      if !Empty( aGet[ _CNOMTIK ] )
         aGet[ _CNOMTIK ]:cText( RetFld( cDefCli(), dbfClient, "Titulo" ) )
      end if

      /*
      Serie del documento------------------------------------------------------
      */

      cSerCli                 := RetFld( cDefCli(), dbfClient, "Serie" )

      if !Empty( aGet[ _CSERTIK ] )
         if Empty( cSerCli )
            aGet[ _CSERTIK ]:cText( cNewSer( "nTikCli", dbfCount ) )
         else
            aGet[ _CSERTIK ]:cText( cSerCli )
         end if
      else
         if Empty( cSerCli )
            aTmp[ _CSERTIK ]  := cNewSer( "nTikCli", dbfCount )
         else
            aTmp[ _CSERTIK ]  := cSerCli
         end if
      end if

      if !Empty( oGrupoSerie )
         oGrupoSerie:cPrompt  := "Serie: " + aTmp[ _CSERTIK ]
      end if

      if !Empty( aGet[ _CNCJTIK ] )
         aGet[ _CNCJTIK ]:cText( oUser():cCaja() )
      else
         aTmp[ _CNCJTIK ]     := oUser():cCaja()
      end if

      if !Empty( aGet[ _CFPGTIK ] )
         aGet[ _CFPGTIK ]:cText( cDefFpg() )
      else
         aTmp[ _CFPGTIK ]     := cDefFpg()
      end if

      if !Empty( aGet[ _CALMTIK ] )
         aGet[ _CALMTIK ]:cText( oUser():cAlmacen() )
      else
         aTmp[ _CALMTIK ]     := oUser():cAlmacen()
      end if

      if !Empty( aGet[ _CCCJTIK ] )
         aGet[ _CCCJTIK ]:cText( cCurUsr() )
      else
         aTmp[ _CCCJTIK ]     := cCurUsr()
      end if

      if !Empty( aGet[ _CCODPRO ] )
         aGet[ _CCODPRO ]:cText( cProCnt() )
      else
         aTmp[ _CCODPRO ]     := cProCnt()
      end if

      if !Empty( aGet[ _CCODDLG ] )
         aGet[ _CCODDLG ]:cText( RetFld( cCurUsr(), dbfUsr, "cCodDlg" ) )
      else
         aTmp[ _CCODDLG ]     := RetFld( cCurUsr(), dbfUsr, "cCodDlg" )
      end if

      aTmp[ _NNUMCOM    ]     := 0

      if !Empty( aGet[ _CDTOESP ] )
         aGet[ _CDTOESP ]:cText( Padr( "General", 50 ) )
      else
         aTmp[ _CDTOESP ]     := Padr( "General", 50 )
      end if

      if !Empty( aGet[ _NDTOESP ] )
         aGet[ _NDTOESP ]:cText( 0 )
      else
         aTmp[ _NDTOESP ]     := 0
      end if

      if !Empty( aGet[ _CDPP ] )
         aGet[ _CDPP    ]:cText( Padr( "Pronto pago", 50 ) )
      else
         aTmp[ _CDPP    ]     := Padr( "Pronto pago", 50 )
      end if

      if !Empty( aGet[ _NDPP ] )
         aGet[ _NDPP    ]:cText( 0 )
      else
         aTmp[ _NDPP    ]     := 0
      end if

      if !Empty( oTotEsp )
         oTotEsp:cText( 0 )
      end if

      if !Empty( oTotDpp )
         oTotDpp:cText( 0 )
      end if

      /*
      Colocamos los valores de la sala-----------------------------------------
      */

      if !Empty( oBtnTipoVta )
         oBtnTipoVta:cPrompt           := "Ticket"
         oBtnTipoVta:cxBmp             := "Cashier_user1_32"
      end if

   case nMode == EDIT_MODE .or. nMode == ZOOM_MODE .or. nMode == DUPL_MODE

      if nMode == DUPL_MODE

         /*
         Serie del documento------------------------------------------------------
         */

         cSerCli                       := RetFld( cDefCli(), dbfClient, "Serie" )

         if !Empty( aGet[ _CSERTIK ] )
            if Empty( cSerCli )
               aGet[ _CSERTIK ]:cText( cNewSer( "nFacCli", dbfCount ) )
            else
               aGet[ _CSERTIK ]:cText( cSerCli )
            end if
         else
            if Empty( cSerCli )
               aTmp[ _CSERTIK ]        := cNewSer( "nFacCli", dbfCount )
            else
               aTmp[ _CSERTIK ]        := cSerCli
            end if
         end if

         aTmp[ _CNUMTIK ]              := 0
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

               if dbLock( dbfTikL )
                  ( dbfTikL )->nUndAnt    := ( dbfTikL )->nUntTil
                  ( dbfTikL )->( dbUnLock() )
               end if

               dbPass( dbfTikL, dbfTmpL, .t. )
               ( dbfTikL )->( dbSkip() )
            end while

         end if

         ( dbfTmpL )->( dbGoTop() )

         /*
         A¤adimos desde el fichero de PAGOS---------------------------------------
         */

         if ( dbfTikP )->( dbSeek( cNumTik ) )
            while ( ( dbfTikP )->cSerTik + ( dbfTikP )->cNumTik + ( dbfTikP )->cSufTik == cNumTik .and. !( dbfTikP )->( eof() ) )
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

      end if

   end case

   /*
   Desabilitamos los botones de up y down para el caso del tactil--------------
   */

   if !Empty( oBtnUp ) .and. !Empty( oBtnDown )
      oBtnUp:lEnabled   := ( nMode == EDIT_MODE .or. nMode == ZOOM_MODE )
      oBtnDown:lEnabled := ( nMode == EDIT_MODE .or. nMode == ZOOM_MODE )
   end if

   /*
   Cargamos valores en la OfficeBar para el caso del táctil--------------------
   */

   cTextoOfficeBar( aTmp )

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

   CursorWE()

Return ( lErrors )

//---------------------------------------------------------------------------//

Static Function KillTrans( oBrwPgo, oBrwVal )

   CursorWait()

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

   if !Empty( dbfTmpC ) .and. ( dbfTmpC )->( Used() )
      ( dbfTmpC )->( dbCloseArea() )
   end if

   if !Empty( dbfTmpS ) .and. ( dbfTmpS )->( Used() )
      ( dbfTmpS )->( dbCloseArea() )
   end if

   if !Empty( dbfTmpN ) .and. ( dbfTmpN )->( Used() )
      ( dbfTmpN )->( dbCloseArea() )
   end if

   dbfErase( cNewFilL )
   dbfErase( cNewFilP )
   dbfErase( cNewFilV )
   dbfErase( cNewFilA )
   dbfErase( cNewFilE )
   dbfErase( cNewFilC )
   dbfErase( cNewFilS )
   dbfErase( cNewFilN )

   oOfficeBar  := nil

   dbfTmpL     := nil
   dbfTmpP     := nil
   dbfTmpV     := nil
   dbfTmpA     := nil
   dbfTmpE     := nil
   dbfTmpC     := nil
   dbfTmpS     := nil
   dbfTmpN     := nil

   CursorWE()

Return .T.

//---------------------------------------------------------------------------//

Static Function ClickOnBrowse( nRow, aTmp, aGet, oBrwDet )

   local nBrwHeight

   nBrwHeight        := oBrwDet:HeaderHeight() + ( oBrwDet:nRowHeight * oBrwDet:nDataRows )

   if !( nRow < nBrwHeight )

      AppDetRec( oBrwDet, bEditL, aTmp, cPorDiv, cPicEur )

      aGet[ _CCLITIK ]:SetFocus()

   end if

Return ( .t. )

//---------------------------------------------------------------------------//

#else

Static Function BeginTrans( aTmp, aGet, nMode )

   local oError
   local oBlock
   local nRecAnt
   local nOrdAnt
   local lErrors        := .f.
   local cNumTik        := ""

   if nMode != APPD_MODE
      cNumTik           := aTmp[ _CSERTIK ] + aTmp[ _CNUMTIK ] + aTmp[ _CSUFTIK ]
   end if

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   /*
   Crear la base de datos local para las lineas de detalle---------------------
   */

   ( dbfTmpL )->( dbCloseArea() )

   if !Empty( cNewFilL )
      dbfErase( cNewFilL )
   end if

   cNewFilL       := cGetNewFileName( cPatTmp() + "TikL" )
   dbCreate( cNewFilL, aSqlStruct( aColTik() ), cLocalDriver() )
   dbUseArea( .t., cLocalDriver(), cNewFilL, cCheckArea( "TikL", @dbfTmpL ), .f. )
   if !NetErr()
      ( dbfTmpL )->( OrdCondSet( "!Deleted()", {||!Deleted() } ) )
      ( dbfTmpL )->( OrdCreate( cNewFilL, "Recno", "Str( Recno() )", {|| Str( Recno() ) } ) )
   end if

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

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Imposible crear tablas temporales." )

      KillTrans()

      lErrors     := .t.

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( lErrors )

//---------------------------------------------------------------------------//

Static Function KillTrans()

   if !Empty( dbfTmpL ) .and. ( dbfTmpL )->( Used() )
      ( dbfTmpL )->( dbCloseArea() )
   end if

   dbfErase( cNewFilL )

Return .T.

//---------------------------------------------------------------------------//

#endif

//---------------------------------------------------------------------------//

#ifndef __PDA__

/*
Funcion Auxiliar para A¤adir lineas de detalle
*/

STATIC FUNCTION AppDetRec( oBrw, bEditL, aTmp, cPorDiv, cPicEur, cCodArt )

   SysRefresh()

   if lStopEntContLine
      lStopEntContLine  := .f.
      return ( lRecTotal( aTmp ) )
   end if

   if Empty( aTmp[ _NTARIFA ] )
      aTmp[ _NTARIFA ]  := Max( uFieldEmpresa( "nPreVta" ), 1 )
   end if

   /*
   Variable para saber si han añadido lineas ----------------------------------
   */

   lNowAppendLine       := .t.

   while WinAppRec( oBrw, bEditL, dbfTmpL, , cCodArt, aTmp )

      sysrefresh()

      if !Empty( cCodArt )
         cCodArt        := nil
      end if

      sysrefresh()

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
	local oBtn
   local lTwo              := .f.
   local nTop
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
   local oCodBarras
   local cCodBarras        := Space( 18 )


   /*
   Posiones donde colocar el dialogo y valores por defecto---------------------
   */

   if nMode == APPD_MODE

      if !Empty( oBrw )
         oBrw:GoBottom()
      end if

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

   if Empty( cCodArt )
      cOldCodArt           := aTmp[ _CCBATIL ]
   end if
   cOldPrpArt              := aTmp[ _CCODPR1 ] + aTmp[ _CCODPR2 ] + aTmp[ _CVALPR1 ] + aTmp[ _CVALPR2 ]

   /*
   Caja de dialogo-------------------------------------------------------------
   */

   DEFINE DIALOG  oDlgDet ;
      FROM        nTop, nLeft TO nHeight, nWidth ;
      STYLE       nOR( WS_VISIBLE, WS_POPUP, 4 ) ;
      OF          oBrw ;
      PIXEL ;

      for each oCol in oBrw:aCols

         cName       := oCol:Cargo[ 1 ]
         nCaptura    := oCol:Cargo[ 2 ]

         do case
            case cName == "Código del artículo"

               @ 0, 0 GET  aGet[ _CCBATIL ] VAR aTmp[ _CCBATIL ] ;
                           NOBORDER ;
                           FONT     oBrw:oFont ;
                           WHEN     ( nMode == APPD_MODE ) ;
                           BITMAP   "LUPA" ;
                           PICTURE  "@!" ;
                           OF       oDlgDet

               aGet[ _CCBATIL ]:bLostFocus         := {|| LoaArt( aGet, aTmp, oBrw, oGetTotal, aTik, lTwo, nMode, oDlgDet, @lMsgVta, @lNotVta ) }
               aGet[ _CCBATIL ]:bHelp              := {|| SetLostFocusOff(), BrwArticulo( aGet[ _CCBATIL ], aGet[ _CNOMTIL ] ), SetLostFocusOn() }
               aGet[ _CCBATIL ]:bValid             := {|| lCodigoArticulo( aGet, aTmp, .t. ) }

               do case
               case nCaptura == 1
                  aGet[ _CCBATIL ]:bWhen           := {|| .f. }
               case nCaptura == 2
                  aGet[ _CCBATIL ]:bValid          := {|| lCodigoArticulo( aGet, aTmp, .t. ) }
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
                           OF       oDlgDet

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
                           OF       oDlgDet

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
                           OF       oDlgDet

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
                           OF       oDlgDet

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
                           WHEN     ( !Empty( aTmp[ _CCODPR1 ] ) ) ;
                           VALID    ( if( lPrpAct( aTmp[ _CVALPR1 ], nil, aTmp[ _CCODPR1 ], dbfTblPro ),;
                                          LoaArt( aGet, aTmp, oBrw, oGetTotal, aTik, lTwo, nMode, oDlgDet, @lMsgVta, @lNotVta ),;
                                          .f. ) );
                           BITMAP   "LUPA" ;
                           OF       oDlgDet

               aGet[ _CVALPR1 ]:bHelp              := {|| SetLostFocusOff(), brwPrpAct( aGet[ _CVALPR1 ], nil, aTmp[ _CCODPR1 ] ), SetLostFocusOn() }

               do case
               case nCaptura == 1
                  aGet[ _CVALPR1 ]:bWhen           := {|| .f. }
               case nCaptura == 2
                  aGet[ _CVALPR1 ]:bWhen           := {|| .t. } //!Empty( aTmp[ _CCODPR1 ] ) }
               case nCaptura == 3
                  aGet[ _CVALPR1 ]:lNeedGetFocus   := .t.
               end case

            case cName == "Propiedad 2"

               @ 0, 0 GET  aGet[ _CVALPR2 ] VAR aTmp[ _CVALPR2 ];
                           NOBORDER ;
                           FONT     oBrw:oFont ;
                           PICTURE  "@!" ;
                           WHEN     ( !Empty( aTmp[ _CCODPR2 ] ) ) ;
                           VALID    ( if( lPrpAct( aTmp[ _CVALPR2 ], nil, aTmp[ _CCODPR2 ], dbfTblPro ),;
                                          LoaArt( aGet, aTmp, oBrw, oGetTotal, aTik, lTwo, nMode, oDlgDet, @lMsgVta, @lNotVta ),;
                                          .f. ) );
                           BITMAP   "LUPA" ;
                           OF       oDlgDet

               aGet[ _CVALPR2 ]:bHelp              := {|| SetLostFocusOff(), brwPrpAct( aGet[ _CVALPR2 ], nil, aTmp[ _CCODPR2 ] ), SetLostFocusOn() }

               do case
               case nCaptura == 1
                  aGet[ _CVALPR2 ]:bWhen           := {|| .f. }
               case nCaptura == 2
                  aGet[ _CVALPR2 ]:bWhen           := {|| .t. } // !Empty( aTmp[ _CCODPR2 ] ) }
               case nCaptura == 3
                  aGet[ _CVALPR2 ]:lNeedGetFocus   := .t.
               end case

            case cName == "Lote"

               @ 0, 0 GET  aGet[ _CLOTE ] VAR aTmp[ _CLOTE ];
                           NOBORDER ;
                           FONT     oBrw:oFont ;
                           RIGHT ;
                           OF       oDlgDet

               do case
               case nCaptura == 1
                  aGet[ _CLOTE ]:bWhen           := {|| .f. }
               case nCaptura == 2
                  aGet[ _CLOTE ]:bWhen           := {|| !Empty( aTmp[ _CLOTE ] ) }
               case nCaptura == 3
                  aGet[ _CLOTE ]:lNeedGetFocus   := .t.
               end case

            case cName == "Detalle"

               @ 0, 0 GET  aGet[ _CNOMTIL ] VAR aTmp[ _CNOMTIL ] ;
                           NOBORDER ;
                           FONT     oBrw:oFont ;
                           WHEN     ( lModDes() ) ;
                           VALID    ( .t. );
                           OF       oDlgDet

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
                           OF       oDlgDet

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
                           OF       oDlgDet

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
                           PICTURE  "@E 999.99" ;
                           RIGHT ;
                           ON CHANGE( lCalcDeta( aTmp, oGetTotal ) ) ;
                           OF       oDlgDet

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
                           OF       oDlgDet

            case cName == "Número de serie"

               @ 0, 0 BUTTON oBtnSer ;
                           PROMPT   ( "&Series" );
                           FONT     oBrw:oFont ;
                           ACTION   ( SetLostFocusOff(), EditarNumeroSerie( aTmp, oStock, nMode ),SetLostFocusOn() ) ;
                           OF       oDlgDet

            case cName == "Promoción"

               @ 0, 0 BITMAP aGet[ _LINPROMO ] ;
                           RESOURCE "Star_Blue_16";
                           NOBORDER ;
                           SIZE     16, 16 ;
                           OF       oDlgDet

               aGet[ _LINPROMO ]:lTransparent   := .t.

            case cName == "Oferta"

               @ 0, 0 BITMAP aGet[ _LLINOFE ] ;
                           RESOURCE "Star_Red_16";
                           NOBORDER ;
                           SIZE     16, 16 ;
                           OF       oDlgDet

               aGet[ _LLINOFE ]:lTransparent   := .t.

            case cName == "Número de línea"

               @ 0, 0 GET  aGet[ _NNUMLIN ] VAR aTmp[ _NNUMLIN ];
                           NOBORDER ;
                           WHEN     .f. ;
                           FONT     oBrw:oFont ;
                           PICTURE  "9999" ;
                           RIGHT ;
                           OF       oDlgDet

            case cName == "Código de barras"

               @ 0, 0 GET  oCodBarras VAR cCodBarras ;
                           NOBORDER ;
                           FONT     oBrw:oFont ;
                           WHEN     ( .f. ) ;
                           PICTURE  "@!" ;
                           OF       oDlgDet

         end case

      next

      // Botones ocultos__________________________________________________________

      @ 0, 0 BUTTON  oBtn ;
                     PROMPT   ( if( nMode == APPD_MODE, "&A", "&M" ) );
                     FONT     oBrw:oFont ;
                     WHEN     ( nMode != ZOOM_MODE ) ;
                     ACTION   ( SavLine( aTmp, aGet, dbfTmpL, oBrw, aTik, oGetTotal, lTwo, nMode, oBtn, cPorDiv, cPicEur, lMsgVta, lNotVta, cCodArt, oStock ) ) ;
                     OF       oDlgDet

      oDlgDet:AddFastKey( VK_F11, {|| GetPesoBalanza( aGet, oBtn ) } )

      oDlgDet:bKeyDown        := { | nKey | EdtDetKeyDown( nKey, aGet, oDlgDet, oBtn ) }
      oDlgDet:bStart          := { || if( !Empty( cCodArt ), ( Eval( aGet[ _CCBATIL ]:bLostFocus ), aGet[ _CCBATIL ]:lValid() ), ), SetDlgMode( oDlgDet, aTmp, aGet, nMode, oBrw, oBtn, nTop, nLeft, nHeight, nWidth ) }

      oDlgDet:bLostFocus      := { || DlgLostFocus( nMode, aTmp ) }

      SetLostFocusOn()

   oDlgDet:Activate( , , , .f., , .t. )

   oBrw:SetFocus()
   oBrw:Refresh()

RETURN ( oDlgDet:nResult == IDOK )

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

   if !Empty( aGet[ _LINPROMO ] )

      if aTmp[ _LINPROMO ]
         aGet[ _LINPROMO ]:Show()
      else
         aGet[ _LINPROMO ]:Hide()
      end if

   end if

   if !Empty( aGet[ _LLINOFE ] )

      if aTmp[ _LLINOFE ]
         aGet[ _LLINOFE ]:Show()
      else
         aGet[ _LLINOFE ]:Hide()
      end if

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

Static Function lCalcDeta( aTmp, oTotal, lTotal )

   local nCalculo

   DEFAULT lTotal := .f.

   nCalculo       := aTmp[ _NPVPTIL ]
   nCalculo       *= aTmp[ _NUNTTIL ]

	IF aTmp[ _NDTOLIN ] != 0
		nCalculo 	-= nCalculo * aTmp[ _NDTOLIN ] / 100
	END IF

   nCalculo       -= aTmp[ _NDTODIV ]

   if !Empty( oTotal )
      oTotal:cText( nCalculo )
   end if

Return if( !lTotal, .t., nCalculo )

//-------------------------------------------------------------------------//

Static Function EdtDetKeyDown( nKey, aGet, oDlg, oBtn )

   do case
      case nKey == VK_ESCAPE

         oDlg:End()

      case nKey == VK_RETURN

         oBtn:Click()

      case nKey == VK_F5

         if !Empty( aGet[ _CCBATIL ]:VarGet() )

            Eval( oBtn:bAction )

         else

            oDlg:End()

            if !Empty( oBtnTik:bWhen ) .and. Eval( oBtnTik:bWhen )
               Eval( oBtnTik:bAction )
            end if

         end if

      case nKey == VK_F7

         if !Empty( aGet[ _CCBATIL ]:VarGet() )

            Eval( oBtn:bAction )

         else

            oDlg:End()

            if !Empty( oBtnAlb:bWhen ) .and. Eval( oBtnAlb:bWhen )
               Eval( oBtnAlb:bAction )
            end if

         end if

      case nKey == VK_F8

         if !Empty( aGet[ _CCBATIL ]:VarGet() )

            Eval( oBtn:bAction )

         else

            oDlg:End()

            if !Empty( oBtnFac:bWhen ) .and. Eval( oBtnFac:bWhen )
               Eval( oBtnFac:bAction )
            end if

         end if

      case nKey == VK_F9

         if !Empty( aGet[ _CCBATIL ]:VarGet() )

            Eval( oBtn:bAction )

         else

            oDlg:End()

            if !Empty( oBtnApt:bWhen ) .and. Eval( oBtnApt:bWhen )
               Eval( oBtnApt:bAction )
            end if

         end if

      case nKey == 65 .and. GetKeyState( VK_CONTROL )

         SetLostFocusOff()
         CreateInfoArticulo()
         SetLostFocusOn()

   end case

Return nil

//-------------------------------------------------------------------------//

/*
Archiva la linea de TPV
*/

STATIC FUNCTION SavLine( aTmp, aGet, dbfTmpL, oBrw, aTik, oGetTotal, lTwo, nMode, oBtn, cPorDiv, cPicEur, lMsgVta, lNotVta, cCodArt, oStock )

   local lOk
   local oCtl
   local aClo
   local aXbYStr
   local nStockActual

   aClo                 := aClone( aTmp )

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

   for each oCtl in oDlgDet:aControls

      if !Empty( oCtl ) .and. oCtl:ClassName == "TGETHLP"

         if Empty( oCtl:bWhen ) .or. Eval( oCtl:bWhen )

            if oCtl:lNeedGetFocus .and. !oCtl:lGotFocus

               SetLostFocusOff()
               msgWait( "Campo obligatorio", "Info", 0 )
               SetLostFocusOn()

               oCtl:SetFocus()

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

   /*
   Comprobamos si tiene que introducir números de serie------------------------
   */

   if ( nMode == APPD_MODE ) .and. RetFld( aTmp[ _CCBATIL ], dbfArticulo, "lNumSer" ) .and. !( dbfTmpS )->( dbSeek( Str( aTmp[ _NNUMLIN ], 4 ) + aTmp[ _CCBATIL ] ) )

      SetLostFocusOff()
      MsgStop( "Tiene que introducir números de serie para este artículo." )
      SetLostFocusOn()

      SetLostFocusOff()
      EditarNumeroSerie( aTmp, oStock, nMode )
      SetLostFocusOn()

      Return .f.

   end if

   if lTwo .and. empty( aTmp[_CNCMTIL ] )

      SetLostFocusOff()
      msgWait( "Introduzca artículo combinado", "Stop", 0 )
      SetLostFocusOn()

      aGet[ _CNCMTIL ]:setFocus()

      return .f.

   end if

   if !Empty( aTmp[ _CCODPR1 ] ) .and. Empty( aTmp[ _CVALPR1 ] ) .and. !Empty( aGet[ _CVALPR1 ] )

      SetLostFocusOff()
      MsgBeepStop( "Primera propiedad no puede estar vacia", "Aviso del sistema" )
      SetLostFocusOn()

      aGet[ _CVALPR1 ]:SetFocus()

      return .f.

   end if

   if !Empty( aTmp[ _CCODPR2 ] ) .and. Empty( aTmp[ _CVALPR2 ] ) .and. !Empty( aGet[ _CVALPR2 ] )

      SetLostFocusOff()
      MsgBeepStop( "Segunda propiedad no puede estar vacia", "Aviso del sistema" )
      SetLostFocusOn()

      aGet[ _CVALPR2 ]:SetFocus()

      return .f.

   end if

   /*
   Precios vacios--------------------------------------------------------------
   */

   if Empty( aTmp[ _NPVPTIL ] )

      if !lPermitirVentaSinValorar( aTmp[ _CCBATIL ], dbfArticulo, dbfFamilia )

         if lUsrMaster()

            SetLostFocusOff()
            lOk   := ApoloMsgNoYes( "Precio igual a cero, ¿desea continuar con la venta?" )
            SetLostFocusOn()

            if !lOk
               aGet[ _NPVPTIL ]:SetFocus()
               return .f.
            end if

         else

            aGet[ _NPVPTIL ]:SetFocus()
            return .f.

         end if

      else

         SetLostFocusOff()
         lOk   := ApoloMsgNoYes( "Precio igual a cero, ¿desea continuar con la venta?" )
         SetLostFocusOn()

         if !lOk
            aGet[ _NPVPTIL ]:SetFocus()
            return .f.
         end if

      end if

   end if

   /*
   Decuentos-------------------------------------------------------------------
   */

   if ( aTmp[ _NPVPTIL ] > 0 ) .and. ( aTmp[ _NPVPTIL ] - aTmp[ _NDTODIV ] <= 0 )

      SetLostFocusOff()
      MsgBeepStop( "Descuento lineal mayor o igual que precio unitario" )
      SetLostFocusOn()

      aGet[ _NDTODIV ]:SetFocus()

      return .f.

   end if

   /*
   Stock actual----------------------------------------------------------------
   */

   if lNotVta .or. lMsgVta

      nStockActual   := oStock:nStockAlmacen( aTmp[ _CCBATIL ], aTik[ _CALMTIK ], aTmp[ _CVALPR1 ], aTmp[ _CVALPR2 ], aTmp[ _CLOTE ] )

      nStockActual   -= nVentasPrevias( aTmp[ _CCBATIL ], dbfTmpL, nMode )

      if ( nStockActual - aTmp[ _NUNTTIL ] ) < 0

         if lNotVta

            SetLostFocusOff()
            MsgStop( "No hay stock suficiente, tenemos " + Alltrim( Trans( nStockActual, MasUnd() ) ) + " unidad(es) disponible(s) en almacén " + aTik[ _CALMTIK ] + "." )
            SetLostFocusOn()

            return .f.

         end if

         if lMsgVta

            SetLostFocusOff()
            lOk   := ApoloMsgNoYes( "No hay stock suficiente, tenemos " + Alltrim( Trans( nStockActual, MasUnd() ) ) + " unidad(es) disponible(s) en almacén " + aTik[ _CALMTIK ] + ".", "¿Continuar con la venta?" )
            SetLostFocusOn()

            if !lOk
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

         /*
         Chequeamos las ofertas por artículos X  *  Y--------------------------
         */

         if !aTmp[ _LLINOFE ]

            aXbyStr              := nXbYOferta( aTmp[ _CCBATIL ], aTik[ _CCLITIK ], aTik[ _CCODGRP ], 1, aTmp[ _NUNTTIL ], aTik[ _DFECTIK ], dbfOferta, 1 )

            if aXbYStr[ 1 ] != 0
               aTmp[ _LLINOFE ]  := .t.
            end if

         end if

         /*
         Chequeamos las ofertas por familia X  *  Y----------------------------
         */

         if !aTmp[ _LLINOFE ]

            aXbyStr              := nXbYOferta( RetFld( aTmp[ _CCBATIL ], dbfArticulo, "FAMILIA", "CODIGO" ), aTik[ _CCLITIK ], aTik[ _CCODGRP ], 1, aTmp[ _NUNTTIL ], aTik[ _DFECTIK ], dbfOferta, 2 )

            if aXbYStr[ 1 ] != 0
               aTmp[ _LLINOFE ]  := .t.
            end if

         end if

         /*
         Chequeamos las ofertas por tipo de artículos X  *  Y------------------
         */

         if !aTmp[ _LLINOFE ]

            aXbyStr              := nXbYOferta( RetFld( aTmp[ _CCBATIL ], dbfArticulo, "CCODTIP", "CODIGO" ), aTik[ _CCLITIK ], aTik[ _CCODGRP ], 1, aTmp[ _NUNTTIL ], aTik[ _DFECTIK ], dbfOferta, 3 )

            if aXbYStr[ 1 ] != 0
               aTmp[ _LLINOFE ]  := .t.
            end if

         end if

         /*
         Chequeamos las ofertas por categoria X  *  Y--------------------------
         */

         if !aTmp[ _LLINOFE ]

            aXbyStr              := nXbYOferta( RetFld( aTmp[ _CCBATIL ], dbfArticulo, "CCODCATE", "CODIGO" ), aTik[ _CCLITIK ], aTik[ _CCODGRP ], 1, aTmp[ _NUNTTIL ], aTik[ _DFECTIK ], dbfOferta, 4 )

            if aXbYStr[ 1 ] != 0
               aTmp[ _LLINOFE ]  := .t.
            end if

         end if

         /*
         Chequeamos las ofertas por temporada X  *  Y--------------------------
         */

         if !aTmp[ _LLINOFE ]

            aXbyStr              := nXbYOferta( RetFld( aTmp[ _CCBATIL ], dbfArticulo, "CCODTEMP", "CODIGO" ), aTik[ _CCLITIK ], aTik[ _CCODGRP ], 1, aTmp[ _NUNTTIL ], aTik[ _DFECTIK ], dbfOferta, 5 )

            if aXbYStr[ 1 ] != 0
               aTmp[ _LLINOFE ]  := .t.
            end if

         end if

         /*
         Chequeamos las ofertas por fabricante X  *  Y-------------------------
         */

         if !aTmp[ _LLINOFE ]

            aXbyStr              := nXbYOferta( RetFld( aTmp[ _CCBATIL ], dbfArticulo, "CCODFAB", "CODIGO" ), aTik[ _CCLITIK ], aTik[ _CCODGRP ], 1, aTmp[ _NUNTTIL ], aTik[ _DFECTIK ], dbfOferta, 6 )

            if aXbYStr[ 1 ] != 0
               aTmp[ _LLINOFE ]  := .t.
            end if

         end if

      end if

      /*
      si tenemos q reagalar unidades-------------------------------------------
      */

      if aXbYStr[ 1 ] != 0 .and. aXbYStr[ 2 ] != 0

         if aXbYStr[ 1 ] == 2

            if aTmp[ _NUNTTIL ] < 0
               aTmp[ _NUNTTIL ]  += aXbYStr[ 2 ]
            else
               aTmp[ _NUNTTIL ]  -= aXbYStr[ 2 ]
            end if

            aClo                 := aClone( aTmp )

            WinGather( aTmp, nil, dbfTmpL, nil, nMode, nil, .f. )

            AppendKit( aClo, aTik )

            if aTmp[ _NUNTTIL ] < 0
               aTmp[ _NUNTTIL ]  := -( aXbYStr[ 2 ] )
            else
               aTmp[ _NUNTTIL ]  := aXbYStr[ 2 ]
            end if

            aTmp[ _NPVPTIL ]     := 0

            aClo                 := aClone( aTmp )

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

   if !Empty( oDlgDet )
      SetLostFocusOff()
      oDlgDet:End( IDOK )
      SetLostFocusOn()
   end if

   /*
   Refresh de tickets----------------------------------------------------------
	*/

   oBrw:Refresh( .t. )

RETURN ( .t. )

//---------------------------------------------------------------------------//

STATIC FUNCTION lCodigoArticulo( aGet, aTmp, lMessage, oDlg )

   local lCodArt        := .t.
   local cValPr1        := Space(10)
   local cValPr2        := Space(10)
   local cCodArt        := aGet[ _CCBATIL ]:VarGet()

   DEFAULT lMessage     := .t.

   if Empty( cCodArt )
      return ( !lRetCodArt() )
   end if

   /*
   Primero buscamos por codigos de barra---------------------------------------
   */

   cCodArt              := cSeekCodebar( cCodArt, dbfCodebar, dbfArticulo )

   /*
   Ahora buscamos por el codigo interno----------------------------------------
   */

   if !aSeekProp( cCodArt, cValPr1, cValPr2, dbfArticulo, dbfTblPro )

      if lMessage

         SetLostFocusOff()
         MsgBeepStop( "Artículo con código " + Rtrim( cCodArt ) + " no encontrado" )
         SetLostFocusOn()

      end if

      lCodArt           := .f.

	else

      aGet[ _CCBATIL ]:cText( cCodArt )

      lCodArt           := .t.

	end if

Return ( lCodArt )

//-------------------------------------------------------------------------//
/*
Esta funci¢n recoge los articulos del Escaner y los valida
*/

STATIC FUNCTION LoaArt( aGet, aTmp, oBrw, oGetTotal, aTik, lTwo, nMode, oDlg, lNotVta )

   local lOk         := .t.
   local nTotal      := 0
   local cCodFam
   local cPrpArt
   local nImpOfe
   local nCosPro
   local nPrePro     := 0
   local cValPr1     := ""
   local cValPr2     := ""
   local cGrpCli     := RetFld( aTik[ _CCLITIK ], dbfClient, "CCODGRP" )
   local cCodArt     := aGet[ _CCBATIL ]:cText()
   local nNumDto     := 0
   local nDtoLin     := 0

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

         /*
         Rellenamos el nombre del articulo-------------------------------------
         */

         if Empty( aTmp[ _CNOMTIL ] )

            if !Empty( ( dbfArticulo)->cDesTik )
               aGet[ _CNOMTIL ]:cText( ( dbfArticulo )->cDesTik )
            else
               aGet[ _CNOMTIL ]:cText( ( dbfArticulo )->Nombre  )
            end if

         end if

         /*
         Texto para la comanda-------------------------------------------------
         */

         if ( dbfArticulo )->lMosCom .and. !Empty( ( dbfArticulo )->mComent )
            MsgStop( Trim( ( dbfArticulo )->mComent ) )
         end if

         /*
         Texto para la comanda-------------------------------------------------
         */

         if !Empty( ( dbfArticulo )->cDesCmd )
            aTmp[ _CNOMCMD ]                 := ( dbfArticulo )->cDesCmd
         else
            aTmp[ _CNOMCMD ]                 := aTmp[ _CNOMTIL ]
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

         end if

         if !empty( aTmp[ _CCODPR2 ] ) .and. !Empty( aGet[ _CVALPR2 ] )

            if !Empty( cValPr2 )
               aGet[ _CVALPR2 ]:cText( cCodPrp( aTmp[ _CCODPR2 ], cValPr2, dbfTblPro ) )
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

         if aTik[ _NREGIVA ] <= 1
            aTmp[ _NIVATIL ]  := nIva( dbfIva, ( dbfArticulo )->TipoIva )
         end if

         /*
         Recogemos los impuestos especiales---------------------------------------
         */

         if !Empty( ( dbfArticulo )->cCodImp )
            aTmp[ _CCODIMP ]  := ( dbfArticulo )->cCodImp
            if aTik[ _NREGIVA ] <= 1
               aTmp[ _NVALIMP ]  := oNewImp:nValImp( ( dbfArticulo )->cCodImp, .t., aTmp[ _NIVATIL ] )
            end if
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

            if aTik[ _NREGIVA ] <= 1
               aTmp[ _NIVATIL ]  := nIva( dbfIva, ( dbfArticulo )->TipoIva )
            end if

            /*
            Recogemos los impuestos especiales---------------------------------
            */

            if !Empty( ( dbfArticulo )->cCodImp )
               aTmp[ _CCODIMP ]     := ( dbfArticulo )->cCodImp
               if aTik[ _NREGIVA ] <= 1
                  aTmp[ _NVALIMP ]  := oNewImp:nValImp( ( dbfArticulo )->cCodImp, .t., aTmp[ _NIVATIL ] )
               end if
            end if

         end if

      end if

      /*
      He terminado de meter todo lo que no son precios ahora es cuando meteré los precios con todas las opciones posibles
      */

      cPrpArt              := aTmp[ _CCODPR1 ] + aTmp[ _CCODPR2 ] + aTmp[ _CVALPR1 ] + aTmp[ _CVALPR2 ]

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

         aTmp[ ( dbfTikL )->( FieldPos( "cUnidad" ) ) ]           := ( dbfArticulo )->cUnidad

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

         nCosPro              := nCosto( nil, dbfArticulo, dbfKit )

         if aGet[ _NCOSDIV ] != nil
            aGet[ _NCOSDIV ]:cText( nCosPro )
         else
            aTmp[ _NCOSDIV ]  := nCosPro
         end if

         nPrePro              := nPrePro( cCodArt, aTmp[ _CCODPR1 ], aTmp[ _CVALPR1 ], aTmp[ _CCODPR2 ], aTmp[ _CVALPR2 ], aTik[ _NTARIFA ], if( aTik[ _NREGIVA ] <= 1, .t., .f. ), dbfArtDiv, dbfTarPreL, aTik[_CCODTAR] )

         if nPrePro == 0

            nTotal            := nRetPreArt( aTik[ _NTARIFA ], aTik[ _CDIVTIK ], if( aTik[ _NREGIVA ] <= 1, .t., .f. ), dbfArticulo, dbfDiv, dbfKit, dbfIva, .t. )

            if nTotal != 0
               nOldPvp        := nTotal
               aGet[ _NPVPTIL ]:cText( nTotal )
               oGetTotal:cText( aTmp[ _NPVPTIL ] * aTmp[ _NUNTTIL ] )
            end if

         else

            aGet[ _NPVPTIL ]:cText( nPrePro )

         end if

         /*
         Descuento de artículo----------------------------------------------
         */

         nNumDto              := RetFld( aTik[ _CCLITIK ], dbfClient, "nDtoArt" )

         if nNumDto != 0

            do case
               case nNumDto == 1
                  nDtoLin     := ( dbfArticulo )->nDtoArt1

               case nNumDto == 2
                  nDtoLin     := ( dbfArticulo )->nDtoArt2

               case nNumDto == 3
                  nDtoLin     := ( dbfArticulo )->nDtoArt3

               case nNumDto == 4
                  nDtoLin     := ( dbfArticulo )->nDtoArt4

               case nNumDto == 5
                  nDtoLin     := ( dbfArticulo )->nDtoArt5

               case nNumDto == 6
                  nDtoLin     := ( dbfArticulo )->nDtoArt6

            end case

            if nDtoLin != 0

               if !Empty( aGet[ _NDTOLIN ] )
                  aGet[ _NDTOLIN ]:cText( nDtoLin )
               end if

            end if

         end if

         /*
         Vemos si hay descuentos en las familias-------------------------------
         */

         if nDtoLin == 0
            if !Empty( aGet[ _NDTOLIN ] )
               aGet[ _NDTOLIN ]:cText( nDescuentoFamilia( cCodFam, dbfFamilia ) )
            else
               aTmp[ _NDTOLIN ]  := nDescuentoFamilia( cCodFam, dbfFamilia )
            end if
         end if

         /*
         Comprobamos si hay promociones por fidelizacion-----------------------------
         */

         aTmp[ _LINPROMO ]    := oFideliza:InPrograma( aTmp[ _CCBATIL ], aTik[ _DFECTIK ], dbfArticulo )

         if !Empty( aGet[ _LINPROMO ] )
            if aTmp[ _LINPROMO ]
               aGet[ _LINPROMO ]:Show()
            else
               aGet[ _LINPROMO ]:Hide()
            end if
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
            /*COMENTADO PARA QUE LA ATIPICA SEA LA QUE MANDE*/ 
            //if nImpOfe  != 0
               if !Empty( aGet[ _NDTOLIN ] )
                  aGet[ _NDTOLIN ]:cText( nImpOfe )
               else
                  aTmp[ _NDTOLIN ]     := nImpOfe
               end if
            //end if

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

         case  lSeekAtpFam( aTik[ _CCLITIK ] + cCodFam, aTik[ _DFECTIK ], dbfCliAtp ) .and. ( dbfCliAtp )->lAplFac

            /*COMENTADO PARA QUE LA ATIPICA SEA LA QUE MANDE*/ 
            //if ( dbfCliAtp )->nDtoArt != 0
               if !Empty( aGet[ _NDTOLIN ] )
                  aGet[ _NDTOLIN ]:cText( ( dbfCliAtp )->nDtoArt )
               else
                  aTmp[ _NDTOLIN ]     := ( dbfCliAtp )->nDtoArt
               end if
            //end if

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

            nImpOfe     := RetPrcTar( cCodArt, aTik[ _CCODTAR ], aTmp[ _CCODPR1 ], aTmp[ _CCODPR2 ], aTmp[ _CVALPR1 ], aTmp[ _CVALPR2 ], dbfTarPreL, aTik[ _NTARIFA ] )
            if nImpOfe  != 0
               aGet[ _NPVPTIL ]:cText( nImpOfe + ( ( nImpOfe * aTmp[ _NIVATIL ] ) / 100 ) )
            end if

            //--Descuento porcentual--//

            nImpOfe     := RetPctTar( cCodArt, cCodFam, aTik[ _CCODTAR ], aTmp[ _CCODPR1 ], aTmp[ _CCODPR2 ], aTmp[ _CVALPR1 ], aTmp[ _CVALPR2 ], dbfTarPreL )
            if nImpOfe  != 0
               aGet[_NDTOLIN ]:cText( nImpOfe )
            end if

            //--Descuento lineal--//

            nImpOfe     := RetLinTar( cCodArt, cCodFam, aTik[ _CCODTAR ], aTmp[ _CCODPR1 ], aTmp[ _CCODPR2 ], aTmp[ _CVALPR1 ], aTmp[ _CVALPR2 ], dbfTarPreL )
            if nImpOfe  != 0
               aGet[ _NDTODIV ]:cText( nImpOfe )
            end if

         end case

      end if

      /*
      Buscamos si hay ofertas-----------------------------------------------
      */

      lBuscaOferta( cCodArt, aGet, aTmp, aTik, dbfOferta, dbfArticulo, dbfDiv, dbfKit, dbfIva  )

      /*
      Cargamos los valores para los cambios---------------------------------
      */

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
      aTmp[ _NCOBTIK ]  -= nTmpValTik( dbfTmpV, dbfTikL, dbfDiv, cDivEmp() )
      aTmp[ _NCOBTIK ]  -= nTotAntFacCli( nil, dbfTmpA, dbfIva, dbfDiv, cDivEmp() )
   end if

Return ( lImporteExacto )

//-------------------------------------------------------------------------//

Static Function ClickButtonsPago( oBtnPago, aGet )

   aEval( aButtonsPago, {|o| o:oButton:lBtnDown := .f., o:oButton:Refresh() } )

   oBtnPago:lBtnDown := .t.

   aGet[ _CFPGTIK ]:cText( oBtnPago:Cargo )
   aGet[ _CFPGTIK ]:lValid()

Return ( nil ) // {|| , oBtnPago:oButton:lBtnDown := .t.,  } )

//-------------------------------------------------------------------------//

Static Function ClickButtonsMode( aTmp )

   do case
      case aTmp[ _CTIPTIK ] == SAVTIK

         aTmp[ _CTIPTIK ]        := SAVFAC
         oBtnTipoVta:cPrompt     := "Factura"
         oBtnTipoVta:cxBmp       := "Document_user1_32"

      case aTmp[ _CTIPTIK ] == SAVFAC

            aTmp[ _CTIPTIK ]     := SAVTIK
            oBtnTipoVta:cPrompt  := "Ticket"
            oBtnTipoVta:cxBmp    := "Cashier_user1_32"

      case aTmp[ _CTIPTIK ] == SAVALB

         aTmp[ _CTIPTIK ]        := SAVTIK
         oBtnTipoVta:cPrompt     := "Ticket"
         oBtnTipoVta:cxBmp       := "Cashier_user1_32"

   end case

Return ( nil )

//-------------------------------------------------------------------------//

/*
Cobra un tiket
*/

STATIC FUNCTION lCobro( aTmp, aGet, nSave, nMode, lGenVale, nDifVale, lBig, oDlgTpv )

   local n
   local oDlg
   local oBtnTop
   local oBtnDwn
   local oBtnAceptar
   local oBtnInsertarCobro
   local oBtnAceptarImprimir
   local oBtnAceptarRegalo
   local oBtnCancelar
   local oBtnCalculator
   local oBrwPgo
   local oBrwVal
   local oGetTxt
   local cGetTxt
   local oFntDlg           
   local aBtnCob           := Array( 8 )
   local aSay              := Array( 3 )
   local aGetCob           := Array( 5 )
   local lIntClk           := .t.
   local aBtnFormaPago     := Array( 5 )
   local aSayFormaPago     := Array( 5 )
   local oBmpTitulo
   local oSayTitulo
   local cImageTitle
   local cTextTitle        := ""
   local lWhen
   local nScreenVertRes    := GetSysMetrics( 1 )
   local cResource         := "COBROTPV_1024x768"

   DEFAULT nSave           := SAVTIK
   DEFAULT nMode           := EDIT_MODE
   DEFAULT lBig            := .f.

   if ( nSave == SAVAPT )
      Return ( .t. )
   end if 

   lWhen                   := ( nSave != SAVDEV .and. nSave != SAVVAL ) .or. ( nMode == APPD_MODE )

   /*
   Desabilitamos la caja de detras---------------------------------------------
   */

   if !Empty( oDlgTpv )
      aEval( oDlgTpv:aControls, { | oCtrl | oCtrl:Disable() } )
   end if

   oFntDlg                 := TFont():New( FONT_NAME, 12, 32, .F., .T.,  )

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
         cImageTitle := "Cashier_businessman2_48_alpha"
         cTextTitle  := "El documento actual se cobrará y guardará como un ticket de cliente."
      case nSave == SAVALB
         cImageTitle := "Document_plain_businessman2_48_alpha"
         cTextTitle  := "El documento actual se guardará como un albaran de cliente."
      case nSave == SAVFAC
         cImageTitle := "Document_businessman2_48_alpha"
         cTextTitle  := "El documento actual se guardará como una factura de cliente."
      case nSave == SAVDEV
         cImageTitle := "Cashier_delete_48_alpha"
         cTextTitle  := "El documento actual se guardará como una devolución a cliente."
      case nSave == SAVVAL .and. !aTmp[ _LFRETIK ]
         cImageTitle := "Cashier_delete_48_alpha"
         cTextTitle  := "El documento actual se guardará como un vale a cliente."
      case nSave == SAVVAL .and. aTmp[ _LFRETIK ]
         cImageTitle := "Cashier_box_new_48_alpha"
         cTextTitle  := "El documento actual se guardará como un cheque regalo."
      case nSave == SAVAPT
         cImageTitle := "Cashier_delete_48_alpha"
         cTextTitle  := "El documento actual se guardará como un apartado."
   end case

   /*
   Dialogo q montaremos en funcion de la resolucion de pantalla----------------
   */

   do case
      case nScreenVertRes == 600
         cResource   := "COBROTPV_800x600"
      case nScreenVertRes == 768
         cResource   := "COBROTPV_1024x768"
      case nScreenVertRes == 1024
         cResource   := "COBROTPV_1280x1024"
   end case

   /*
   Definicion del dialogo------------------------------------------------------
   */

   DEFINE DIALOG oDlg RESOURCE cResource TITLE cTextTitle

      /*
      Banner del título-----------------------------------------------------------
      */

      REDEFINE BITMAP oBmpTitulo RESOURCE ( cImageTitle )   ID 500 OF oDlg

      REDEFINE SAY oSayTitulo PROMPT ( cTextTitle )         ID 510 OF oDlg

      REDEFINE SAY aSay[ 1 ] ID 910 OF oDlg
      REDEFINE SAY aSay[ 2 ] ID 911 OF oDlg
      REDEFINE SAY aSay[ 3 ] ID 912 OF oDlg

      /*
      Forma de pago---------------------------------------------------------------
      */

      REDEFINE GET aGet[ _CFPGTIK ] VAR aTmp[ _CFPGTIK ] ;
         ID       120 ;
         WHEN     ( lWhen ) ;
         VALID    cFpago( aGet[ _CFPGTIK ], dbfFPago, oGetTxt ) ;
         FONT     oFntDlg ;
         OF       oDlg

         aGet[ _CFPGTIK ]:bHelp  := {|| BrwPgoTactil( aGet[ _CFPGTIK ], dbfFPago, oGetTxt ) }

      REDEFINE GET oGetTxt VAR cGetTxt ;
         ID       121 ;
         FONT     oFntDlg ;
         OF       oDlg

      /*
      Botones de formas de pago------------------------------------------------
      */

      for n := 1 to len( aButtonsPago )

         aButtonsPago[ n ]:oButton        := ApoloBtnBmp():Redefine( ( 600 + n ), aButtonsPago[ n ]:cBigResource, , , , , {|o| ClickButtonsPago( o, aGet ) }, oDlg, , , .f., .f., aButtonsPago[ n ]:cText, , , , .t., "TOP", .t., , , .f., )
         aButtonsPago[ n ]:oButton:Cargo  := aButtonsPago[ n ]:cCode
         aButtonsPago[ n ]:oButton:bWhen  := {|| ( lWhen ) }

         if aButtonsPago[ n ]:oButton:Cargo == aTmp[ _CFPGTIK ]
            aButtonsPago[ n ]:oButton:lBtnDown := .t.
         end if

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

      /*
      Total entregado__________________________________________________________
		*/

      REDEFINE SAY oTotDiv:oEntregado ;
         VAR      oTotDiv:nEntregado ;
         ID       160 ;
			FONT 		oFntDlg ;
         PICTURE  cPorDiv ;
         OF       oDlg

      /*
      Monedas y billetes__________________________________________________________________
		*/

      REDEFINE BUTTONBMP aButtonsMoney[ 1 ];
         ID       800 ;
         OF       oDlg ;
         WHEN     ( lWhen ) ;
         BITMAP   "Img500Euros" ;
         ACTION   ( ClkMoneda( 500, oTotDiv:oCobrado, @lIntClk ), ChkCobro( aTmp ) )

      REDEFINE BUTTONBMP aButtonsMoney[ 2 ];
         ID       801 ;
         OF       oDlg ;
         WHEN     ( lWhen ) ;
         BITMAP   "Img200Euros" ;
         ACTION   ( ClkMoneda( 200, oTotDiv:oCobrado, @lIntClk ), ChkCobro( aTmp ) )

      REDEFINE BUTTONBMP aButtonsMoney[ 3 ];
         BITMAP   "Img100EUROS" ;
         WHEN     ( lWhen ) ;
         ACTION   ( ClkMoneda( 100, oTotDiv:oCobrado, @lIntClk ), ChkCobro( aTmp ) ) ;
         ID       802;
         OF       oDlg

      REDEFINE BUTTONBMP aButtonsMoney[ 4 ];
         BITMAP   "Img50EUROS" ;
         WHEN     ( lWhen ) ;
         ACTION   ( ClkMoneda( 50, oTotDiv:oCobrado, @lIntClk ), ChkCobro( aTmp ) ) ;
         ID       803;
         OF       oDlg

      REDEFINE BUTTONBMP aButtonsMoney[ 5 ];
         BITMAP   "Img20EUROS" ;
         WHEN     ( lWhen ) ;
         ACTION   ( ClkMoneda( 20, oTotDiv:oCobrado, @lIntClk ), ChkCobro( aTmp ) ) ;
         ID       804;
         OF       oDlg

      REDEFINE BUTTONBMP aButtonsMoney[ 6 ];
         BITMAP   "Img10EUROS" ;
         WHEN     ( lWhen ) ;
         ACTION   ( ClkMoneda( 10, oTotDiv:oCobrado, @lIntClk ), ChkCobro( aTmp ) ) ;
         ID       805;
         OF       oDlg

      REDEFINE BUTTONBMP aButtonsMoney[ 7 ];
         BITMAP   "Img5EUROS" ;
         WHEN     ( lWhen ) ;
         ACTION   ( ClkMoneda( 5, oTotDiv:oCobrado, @lIntClk ), ChkCobro( aTmp ) ) ;
         ID       806;
         OF       oDlg

      REDEFINE BUTTONBMP aButtonsMoney[ 8 ];
         BITMAP   "Img2EUROS" ;
         WHEN     ( lWhen ) ;
         ACTION   ( ClkMoneda( 2, oTotDiv:oCobrado, @lIntClk ), ChkCobro( aTmp ) ) ;
         ID       807;
         OF       oDlg

      REDEFINE BUTTONBMP aButtonsMoney[ 9 ];
         BITMAP   "Img1EURO" ;
         WHEN     ( lWhen ) ;
         ACTION   ( ClkMoneda( 1, oTotDiv:oCobrado, @lIntClk ), ChkCobro( aTmp ) ) ;
         ID       808;
         OF       oDlg

      REDEFINE BUTTONBMP aButtonsMoney[ 10 ];
         BITMAP   "Img50CENT" ;
         WHEN     ( lWhen ) ;
         ACTION   ( ClkMoneda( 0.50, oTotDiv:oCobrado, @lIntClk ), ChkCobro( aTmp ) ) ;
         ID       809;
         OF       oDlg

      REDEFINE BUTTONBMP aButtonsMoney[ 11 ];
         BITMAP   "Img20CENT" ;
         WHEN     ( lWhen ) ;
         ACTION   ( ClkMoneda( 0.20, oTotDiv:oCobrado, @lIntClk ), ChkCobro( aTmp ) ) ;
         ID       810;
         OF       oDlg

      REDEFINE BUTTONBMP aButtonsMoney[ 12 ];
         BITMAP   "Img10CENT" ;
         WHEN     ( lWhen ) ;
         ACTION   ( ClkMoneda( 0.10, oTotDiv:oCobrado, @lIntClk ), ChkCobro( aTmp ) ) ;
         ID       811;
         OF       oDlg

      REDEFINE BUTTONBMP aButtonsMoney[ 13];
         BITMAP   "Img5CENT" ;
         WHEN     ( lWhen ) ;
         ACTION   ( ClkMoneda( 0.05, oTotDiv:oCobrado, @lIntClk ), ChkCobro( aTmp ) ) ;
         ID       812;
         OF       oDlg

      REDEFINE BUTTONBMP aButtonsMoney[ 14 ];
         BITMAP   "Img2CENT" ;
         WHEN     ( lWhen ) ;
         ACTION   ( ClkMoneda( 0.02, oTotDiv:oCobrado, @lIntClk ), ChkCobro( aTmp ) ) ;
         ID       813;
         OF       oDlg

      REDEFINE BUTTONBMP aButtonsMoney[ 15 ];
         BITMAP   "Img1CENT" ;
         WHEN     ( lWhen ) ;
         ACTION   ( ClkMoneda( 0.01, oTotDiv:oCobrado, @lIntClk ), ChkCobro( aTmp ) ) ;
         ID       814;
         OF       oDlg

      REDEFINE BUTTONBMP aButtonsMoney[ 16 ];
         BITMAP   "Img0EUROS" ;
         WHEN     ( lWhen ) ;
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
         WHEN     ( lWhen ) ;
         VALID    ( ChkCobro( aTmp, oTotDiv ) ) ;
         OF       oDlg

      REDEFINE BUTTONBMP oBtnCalculator ;
         ID       220 ;
         OF       oDlg ;
         WHEN     ( lWhen ) ;
         BITMAP   "Calculator_32" ;
         ACTION   ( Calculadora( 0, oTotDiv:oCobrado ), ChkCobro( aTmp ) )

      /*
      Cambio en divisas del cambio____________________________________________
		*/

      REDEFINE SAY oTotDiv:oCambio ;
         VAR      oTotDiv:nCambio ;
         ID       180 ;
			FONT 		oFntDlg ;
         PICTURE  cPorDiv ;
         OF       oDlg

      /*
      Botones__________________________________________________________________
      */

      oBtnInsertarCobro    := ApoloBtnBmp():Redefine( 554, "Money2_Add2_32", , , , ,            {|| lAddCobro( @aTmp, oTotDiv, oBrwPgo ) }, oDlg, , {|| lWhen }, .f., .f., "Añadir cobro combinado", , , , .t., "TOP", .t., , , .f. )
      oBtnAceptarRegalo    := ApoloBtnBmp():Redefine( 553, "Package_New_Disk_Green_32", , , , , {|| if( lValidaCobro( aGet, @aTmp, @lGenVale, @nDifVale, nSave, oDlg ), ( lCopTik := .t., lRegalo := .t., oDlg:end( IDOK ) ), ) }, oDlg, , {|| lWhen }, .f., .f., "Aceptar y ticket regalo", , , , .t., "TOP", .t., , , .f. )
      oBtnAceptarImprimir  := ApoloBtnBmp():Redefine( IDOK, "Printer2_Disk_Green_32", , , , ,   {|| if( lValidaCobro( aGet, @aTmp, @lGenVale, @nDifVale, nSave, oDlg ), ( lCopTik := .t., oDlg:end( IDOK ) ), ) }, oDlg, , {|| lWhen }, .f., .f., "Aceptar e imprimir [F6]", ,,, .t., "TOP", .t., , , .f. )
      oBtnAceptar          := ApoloBtnBmp():Redefine( 552, "Check2_32", , , , ,                 {|| if( lValidaCobro( aGet, @aTmp, @lGenVale, @nDifVale, nSave, oDlg ), ( lCopTik := .f., oDlg:end( IDOK ) ), ) }, oDlg, , {|| lWhen }, .f., .f., "Aceptar sin imprimir [F5]", ,,, .t., "TOP", .t., , , .f. )
      oBtnCancelar         := ApoloBtnBmp():Redefine( IDCANCEL, "Del32", , , , ,                {|| oDlg:end() }, oDlg, , , .f., .f., "Cancelar", , , , .t., "TOP", .t., , , .f. )

      /*
      Pagos
		------------------------------------------------------------------------
		*/

      if nSave == SAVALB

         /*
         Entregas a cuentas en albaranes de clientes---------------------------
         */

         REDEFINE BUTTON aBtnCob[ 1 ];
            ID       300 ;
            OF       oDlg;
            WHEN     ( lWhen ) ;
            ACTION   ( WinAppRec( oBrwPgo, bEditE, dbfTmpE, , , aTmp ) )

         REDEFINE BUTTON aBtnCob[ 2 ];
            ID       301 ;
            OF       oDlg;
            WHEN     ( lWhen ) ;
            ACTION   ( WinEdtRec( oBrwPgo, bEditE, dbfTmpE, , , aTmp ) )

         REDEFINE BUTTON aBtnCob[ 3 ];
            ID       302 ;
            OF       oDlg;
            WHEN     ( lWhen ) ;
            ACTION   ( if( ( dbfTmpE )->lCloPgo .and. !oUser():lAdministrador(), MsgStop( "Solo pueden eliminar las entregas cerradas los administradores." ), dbDelRec( oBrwPgo, dbfTmpE ) ) )

         REDEFINE BUTTON aBtnCob[ 6 ];
            ID       303 ;
            OF       oDlg;
            WHEN     ( lWhen ) ;
            ACTION   ( PrnEntAlbCli( ( dbfTmpE )->cSerAlb + Str( ( dbfTmpE )->nNumAlb ) + ( dbfTmpE )->cSufAlb + Str( ( dbfTmpE )->nNumRec ), .f., dbfTmpE ) )

         oBrwPgo                 := IXBrowse():New( oDlg )

         oBrwPgo:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
         oBrwPgo:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

         if ( lWhen )
            oBrwPgo:bLDblClick   := {|| WinEdtRec( oBrwPgo, bEditE, dbfTmpE, , aTmp ) }
         end if

         oBrwPgo:cAlias          := dbfTmpE
         oBrwPgo:nMarqueeStyle   := 5
         oBrwPgo:cName           := "Pagos.TPV"

         with object ( oBrwPgo:AddCol() )
            :cHeader          := "Cerrado"
            :nHeadBmpNo       := 3
            :bEditValue       := {|| ( dbfTmpE )->lCloPgo }
            :nWidth           := 20
            :SetCheck( { "Sel16", "Nil16" } )
            :AddResource( "Zoom16" )
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
            :bEditValue       := {|| ( dbfTmpE )->cCodPgo + Space( 1 ) + RetFld( ( dbfTmpE )->cCodPgo, dbfFPago ) }
            :nWidth           := 140
         end with

         with object ( oBrwPgo:AddCol() )
            :cHeader          := "Descripción"
            :bEditValue       := {|| ( dbfTmpE )->cDescrip }
            :lHide            := .t.
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
            WHEN     ( lWhen ) ;
            ACTION   (  if( !( dbfTmpP )->lCloPgo,;
                        ( WinAppRec( oBrwPgo, bEditP, dbfTmpP, , , aTmp ), CalImpCob( aTmp ) ),;
                        ( MsgStop( "Pago cerrado" ) ) ) )

         REDEFINE BUTTON aBtnCob[ 2 ];
            ID       301 ;
            OF       oDlg;
            WHEN     ( lWhen ) ;
            ACTION   (  if( !( dbfTmpP )->lCloPgo,;
                        ( WinEdtRec( oBrwPgo, bEditP, dbfTmpP, , , aTmp ), CalImpCob( aTmp ) ),;
                        ( MsgStop( "Pago cerrado" ) ) ) )

         REDEFINE BUTTON aBtnCob[ 3 ];
            ID       302 ;
            OF       oDlg;
            WHEN     ( lWhen ) ;
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

         if ( lWhen )
            oBrwPgo:bLDblClick   := {|| if( !( dbfTmpP )->lCloPgo, ( WinEdtRec( oBrwPgo, bEditP, dbfTmpP, , , aTmp ), CalImpCob( aTmp ) ), ( MsgStop( "Pago cerrado" ) ) ) }
         end if

         oBrwPgo:cAlias          := dbfTmpP
         oBrwPgo:nMarqueeStyle   := 5
         oBrwPgo:cName           := "Pagos.TPV"

         with object ( oBrwPgo:AddCol() )
            :cHeader          := "Cerrado"
            :nHeadBmpNo       := 3
            :bEditValue       := {|| ( dbfTmpP )->lCloPgo }
            :nWidth           := 20
            :SetCheck( { "Sel16", "Nil16" } )
            :AddResource( "Zoom16" )
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
            :bEditValue       := {|| ( dbfTmpP )->cFpgPgo + Space( 1 ) + RetFld( ( dbfTmpP )->cFpgPgo, dbfFPago ) }
            :nWidth           := 140
         end with

         with object ( oBrwPgo:AddCol() )
            :cHeader          := "Descripción"
            :lHide            := .t.
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

      end if

      do case
      case nSave == SAVTIK

      TGroup():ReDefine( 900, "Vales", oDlg )

      REDEFINE BUTTON aBtnCob[ 4 ];
         ID       320 ;
         OF       oDlg;
         WHEN     ( lWhen ) ;
         ACTION   ( BrwVale( dbfTikT, dbfTikL, dbfIva, dbfDiv, dbfTmpV, oBrwVal, .f., aTmp ), CalImpCob( aTmp ) )

      REDEFINE BUTTON aBtnCob[ 5 ];
         ID       321 ;
         OF       oDlg ;
         WHEN     ( lWhen ) ;
         ACTION   ( WinDelRec( oBrwVal, dbfTmpV, nil, nil, .t. ), CalImpCob( aTmp ) )

      REDEFINE BUTTON aBtnCob[ 7 ];
         ID       322 ;
         OF       oDlg ;
         WHEN     ( lWhen ) ;
         ACTION   ( GetVale( oBrwVal, aTmp ), CalImpCob( aTmp ) )

      REDEFINE BUTTON aBtnCob[ 8 ];
         ID       323 ;
         OF       oDlg ;
         WHEN     ( lWhen ) ;
         ACTION   ( BrwVale( dbfTikT, dbfTikL, dbfIva, dbfDiv, dbfTmpV, oBrwVal, .t., aTmp ), CalImpCob( aTmp ) )

      oBrwVal                 := IXBrowse():New( oDlg )

      oBrwVal:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwVal:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrwVal:cAlias          := dbfTmpV
      oBrwVal:nMarqueeStyle   := 6
      oBrwVal:cName           := "Vales.TPV"

      with object ( oBrwVal:AddCol() )
         :cHeader          := "Número"
         :bEditValue       := {|| ( dbfTmpV )->cSerTik + "/" + lTrim( ( dbfTmpV )->cNumTik ) + "/" + ( dbfTmpV )->cSufTik  }
         :nWidth           := 60
      end with

      with object ( oBrwVal:AddCol() )
         :cHeader          := "Fecha"
         :bEditValue       := {|| Dtoc( ( dbfTmpV )->dFecTik ) }
         :nWidth           := 70
      end with

      with object ( oBrwVal:AddCol() )
         :cHeader          := "Sesión"
         :bEditValue       := {|| ( dbfTmpV )->cTurTik }
         :nWidth           := 50
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
         :lHide            := .t.
      end with

      with object ( oBrwVal:AddCol() )
         :cHeader          := "Código"
         :bEditValue       := {|| ( dbfTmpV )->cCliTik }
         :nWidth           := 60
      end with

      with object ( oBrwVal:AddCol() )
         :cHeader          := "Nombre"
         :bEditValue       := {|| ( dbfTmpV )->cNomTik }
         :nWidth           := 140
      end with

      with object ( oBrwVal:AddCol() )
         :cHeader          := "Caja"
         :bEditValue       := {|| ( dbfTmpV )->cCcjTik }
         :nWidth           := 40
         :lHide            := .t.
      end with

      with object ( oBrwVal:AddCol() )
         :cHeader          := "Almacén"
         :bEditValue       := {|| ( dbfTmpV )->cAlmTik }
         :nWidth           := 40
         :lHide            := .t.
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

      case nSave == SAVFAC

      TGroup():ReDefine( 900, "Anticipos", oDlg )

      REDEFINE BUTTON aBtnCob[ 4 ];
         ID       320 ;
         OF       oDlg;
         WHEN     ( lWhen ) ;
         ACTION   ( BrwAntCli( nil, dbfAntCliT, dbfIva, dbfDiv, dbfTmpA, oBrwVal ), CalImpCob( aTmp ) )

      REDEFINE BUTTON aBtnCob[ 5 ];
         ID       321 ;
         OF       oDlg ;
         WHEN     ( lWhen ) ;
         ACTION   ( WinDelRec( oBrwVal, dbfTmpA, nil, nil, .t. ), CalImpCob( aTmp ) )

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

      otherwise

      REDEFINE BUTTON aBtnCob[ 4 ];
         ID       320 ;
         OF       oDlg;
         WHEN     ( lWhen ) ;
         ACTION   ( nil )

      REDEFINE BUTTON aBtnCob[ 5 ];
         ID       321 ;
         OF       oDlg ;
         WHEN     ( lWhen ) ;
         ACTION   ( nil )

      REDEFINE BUTTON aBtnCob[ 7 ];
         ID       322 ;
         OF       oDlg ;
         WHEN     ( lWhen ) ;
         ACTION   ( nil )

      REDEFINE BUTTON aBtnCob[ 8 ];
         ID       323 ;
         OF       oDlg ;
         WHEN     ( lWhen ) ;
         ACTION   ( nil )

      REDEFINE LISTBOX oBrwVal ;
         FIELDS   "";
         HEAD     "";
         ID       330 ;
			OF 		oDlg

      end case

      oDlg:bStart    := {|| StartCobro( aTmp, aGet, aSay, aGetCob, oBrwPgo, oBrwVal, aBtnCob, oBtnTop, oBtnDwn, oBtnInsertarCobro, oBtnAceptarRegalo, oBtnCalculator, nSave, nMode, lBig ) }

      oDlg:AddFastKey( VK_F5, {|| if( !Empty( oBtnAceptar ), oBtnAceptar:Click(), ) } )
      oDlg:AddFastKey( VK_F6, {|| if( !Empty( oBtnAceptarImprimir ), oBtnAceptarImprimir:Click(), ) } )

   ACTIVATE DIALOG oDlg CENTER

   /*
   Habilitamos los controles---------------------------------------------------
   */

   if !Empty( oDlgTpv )
      aEval( oDlgTpv:aControls, { | oCtrl | oCtrl:Enable() } )
   end if

   oFntDlg:end()

   if oBmpTitulo != nil
      oBmpTitulo:end()
   end if

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

Static Function StartCobro( aTmp, aGet, aSay, aGetCob, oBrwPgo, oBrwVal, aBtnCob, oBtnTop, oBtnDwn, oBtnInsertarCobro, oBtnAceptarRegalo, oBtnCalculator, nSave, nMode, lBig )

   CalImpCob( aTmp )

   ChkCobro( aTmp )

   /*
   Botones de formas de pago---------------------------------------------------
   */

   aEval( aButtonsPago, {|oBtn| if( !Empty( oBtn:oButton ), oBtn:oButton:Show(), ), if( !Empty( oBtn:oSay ), oBtn:oSay:Show(), ) } )

   /*
   Set controles de la ventana de cobros---------------------------------------
   */

   if aGetCob[ 2 ] != nil
      aGetCob[ 2 ]:lValid()
   end if

   if aGetCob[ 3 ] != nil
      aGetCob[ 3 ]:lValid()
   end if

   if !lBig

      do case
      case ( nSave == SAVVAL .and. aTmp[ _LFRETIK ] )  // Cheque regalo

         if !Empty( oBrwVal )
            oBrwVal:Hide()
         end if

         if !Empty( aBtnCob[ 4 ] )
            aBtnCob[ 4 ]:Hide()
         end if

         if !Empty( aBtnCob[ 5 ] )
            aBtnCob[ 5 ]:Hide()
         end if

         if !Empty( aBtnCob[ 6 ] )
            aBtnCob[ 6 ]:Hide()
         end if

         if !Empty( aBtnCob[ 7 ] )
            aBtnCob[ 7 ]:Hide()
         end if

         if !Empty( aBtnCob[ 8 ] )
            aBtnCob[ 8 ]:Hide()
         end if

      case ( nSave == SAVVAL .and. !aTmp[ _LFRETIK ] ) // Vale

         aEval( aButtonsPago, {|o| o:oButton:Hide() } )
         aEval( aButtonsMoney, {|o| o:Hide() } )

         if !Empty( oBtnInsertarCobro )
            oBtnInsertarCobro:Hide()
         end if 

         if !Empty( oBtnAceptarRegalo )
            oBtnAceptarRegalo:Hide()
         endif

         oTotDiv:oEntregado:Hide()
         oTotDiv:oCobrado:Hide()
         oTotDiv:oCambio:Hide()

         if ( !Empty( aBtnCob[ 1 ] ), aBtnCob[ 1 ]:Hide(), )
         if ( !Empty( aBtnCob[ 2 ] ), aBtnCob[ 2 ]:Hide(), )
         if ( !Empty( aBtnCob[ 3 ] ), aBtnCob[ 3 ]:Hide(), )
         if ( !Empty( aBtnCob[ 4 ] ), aBtnCob[ 4 ]:Hide(), )
         if ( !Empty( aBtnCob[ 5 ] ), aBtnCob[ 5 ]:Hide(), )
         if ( !Empty( aBtnCob[ 6 ] ), aBtnCob[ 6 ]:Hide(), )
         if ( !Empty( aBtnCob[ 7 ] ), aBtnCob[ 7 ]:Hide(), )
         if ( !Empty( aBtnCob[ 8 ] ), aBtnCob[ 8 ]:Hide(), )

         aSay[ 1 ]:Hide()
         aSay[ 2 ]:Hide()
         aSay[ 3 ]:Hide()

         if !Empty( aGetCob[ 1 ] )
            aGetCob[ 1 ]:SetFocus()
         end if

         if !Empty( oBrwVal )
            oBrwVal:Hide()
         end if

         if !Empty( oBrwPgo )
            oBrwPgo:Hide()
         end if

         if !Empty( oBtnCalculator )
            oBtnCalculator:Hide()
         end if

      case ( nSave == SAVALB ) .or. ( nSave == SAVDEV ) .or. ( nSave == SAVAPT )

         oTotDiv:oEntregado:Hide()
         oTotDiv:oCobrado:Hide()
         oTotDiv:oCambio:Hide()

         if !Empty( aBtnCob[ 4 ] )
            aBtnCob[ 4 ]:Hide()
         end if

         if !Empty( aBtnCob[ 5 ] )
            aBtnCob[ 5 ]:Hide()
         end if

         if ( nSave == SAVALB )
            if !Empty( aBtnCob[ 6 ] )
               aBtnCob[ 6 ]:Show()
            else
               aBtnCob[ 6 ]:Hide()
            end if
         end if

         if !Empty( aBtnCob[ 7 ] )
            aBtnCob[ 7 ]:Hide()
         end if

         if !Empty( aBtnCob[ 8 ] )
            aBtnCob[ 8 ]:Hide()
         end if

         aSay[ 1 ]:Hide()
         aSay[ 2 ]:Hide()
         aSay[ 3 ]:Hide()

         if !Empty( aGetCob[ 1 ] )
            aGetCob[ 1 ]:SetFocus()
         end if

         if !Empty( oBrwVal )
            oBrwVal:Hide()
         end if

         if !Empty( oBtnCalculator )
            oBtnCalculator:Hide()
         end if

      case nSave == SAVFAC

         if !Empty( aGetCob[ 1 ] )
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

   end if

   if !lBig

      /*
      Valid del codigo de cliente-------------------------------------------------
      */

      if !Empty( aGet[ _CCLITIK ] )
         aGet[ _CCLITIK ]:lValid()
      end if

   end if

Return .t.

//---------------------------------------------------------------------------//

Static Function lValidaCobro( aGet, aTmp, lGenVale, nDifVale, nSave, oDlg )

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
   Desabilitamos los controles para los más rápidos----------------------------
   */

   aEval( oDlg:aControls, {|o| o:Disable() } )

   /*
   Checkea los valores de los cobros-------------------------------------------
   */

   ChkCobro( aTmp )

   /*
   Diferencias-----------------------------------------------------------------
   */

   nTotalVale              := nTmpValTik( dbfTmpV, dbfTikL, dbfDiv, cDivEmp() )
   nDifVale                := nTotalVale - oTotDiv:nTotal

   /*
   El tiket ya no esta abierto-------------------------------------------------
   */

   aTmp[ _LABIERTO ]       := .f.

   /*
   Cambio y salvar como factura------------------------------------------------
   */

   if lNegativo( oTotDiv:nCambio ) .and. ( nSave == SAVTIK .or. nSave == SAVFAC .or. ( nSave == SAVVAL .and. aTmp[ _LFRETIK ] ) )

      if !MsgBeepYesNo( "¿Desea vender a credito al cliente " + CRLF + Alltrim( aTmp[ _CNOMTIK ] ) + "?", "Importe insuficiente" )

         aEval( oDlg:aControls, {|o| o:Enable() } )

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

   /*
   Habilitamos de nuevo los controles para los más rápidos---------------------
   */

   aEval( oDlg:aControls, {|o| o:Enable() } )

return .t.

//----------------------------------------------------------------------------//

static function CalImpCob( aTmp )

   oTotDiv:nCobrado        := nTotCobTik( nil, dbfTmpP, dbfDiv, cDivEmp() )
   oTotDiv:nVale           := nTmpValTik( dbfTmpV, dbfTikL, dbfDiv, cDivEmp() )
   oTotDiv:nAnticipo       := nTotAntFacCli( nil, dbfTmpA, dbfIva, dbfDiv, cDivEmp() )
   oTotDiv:nEntregado      := ( oTotDiv:nCobrado + oTotDiv:nVale + oTotDiv:nAnticipo )
   oTotDiv:nCobrado        := ( oTotDiv:nTotal - oTotDiv:nEntregado )
   oTotDiv:nCambio         := - ( oTotDiv:nTotal - oTotDiv:nEntregado - oTotDiv:nCobrado )

   if !Empty( oTotDiv:oEntregado )
      oTotDiv:oEntregado:Refresh()
   end if

   if !Empty( oTotDiv:oCobrado )
      oTotDiv:oCobrado:Refresh()
   end if

   if !Empty( oTotDiv:oCambio )
      oTotDiv:oCambio:Refresh()
   end if

return .t.

//-------------------------------------------------------------------------//

static function ChkCobro( aTmp )

   oTotDiv:nCambio            := - ( oTotDiv:nTotal - oTotDiv:nEntregado - oTotDiv:nCobrado )

   if !Empty( oTotDiv:oCobrado )
      oTotDiv:oCobrado:Refresh()
   end if

   if !Empty( oTotDiv:oCambio )
      oTotDiv:oCambio:Refresh()
   end if

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

Static Function BrwVale( dbfTikT, dbfTikL, dbfIva, dbfDiv, dbfTmpV, oBrwVal, lCliente, aTmp )

   local oDlg
	local oBrw
   local aGet1
	local cGet1
   local dbfVal
   local lError         := .f.
   local oError
   local oBlock
   local cNewFil
   local oCbxOrd
   local oBtnSelect
   local oBtnUnSelect
   local cCbxOrd        := "Número"
   local aCbxOrd        := { 'Número', 'Código cliente', 'Nombre cliente' }
   local cCodCliente    := aTmp[ _CCLITIK ]
   local cText          := ""
   local nRecAnt        := ( dbfTikT )->( RecNo() )
   local nOrdAnt        := ( dbfTikT )->( OrdSetFocus( "cCliVal" ) )

   DEFAULT lCliente     := .f.

   /*
   Creamos un temporal para trabajar con el temporal---------------------------
   */

   cNewFil              := cGetNewFileName( cPatTmp() + "TikT" )

   dbCreate( cNewFil, aSqlStruct( aItmTik() ), cLocalDriver() )

   dbUseArea( .t., cLocalDriver(), cNewFil, cCheckArea( "TikT", @dbfVal ), .f. )
   if !NetErr()
      ( dbfVal )->( OrdCondSet( "!Deleted()", {||!Deleted() } ) )
      ( dbfVal )->( OrdCreate( cNewFil, "cNumTik", "cSerTik + cNumTik + cSufTik", {|| Field->cSerTik + Field->cNumTik + Field->cSufTik } ) )

      ( dbfVal )->( OrdCondSet( "!Deleted()", {||!Deleted() } ) )
      ( dbfVal )->( OrdCreate( cNewFil, "cCliTik", "cCliTik", {|| Field->cCliTik } ) )

      ( dbfVal )->( OrdCondSet( "!Deleted()", {||!Deleted() } ) )
      ( dbfVal )->( OrdCreate( cNewFil, "cNomTik", "cNomTik", {|| Field->cNomTik } ) )
   end if

   /*
   Pasamos los datos a la temporal---------------------------------------------
   */

   ( dbfTikT )->( dbGoTop() )

   if !lCliente

      while !( dbfTikT )->( eof() )
         dbPass( dbfTikT, dbfVal, .t. )
         ( dbfTikT )->( dbSkip() )
      end while

   else

      if ( dbfTikT )->( dbSeek( cCodCliente ) )
         while ( dbfTikT )->cCliTik == cCodCliente .and. !( dbfTikT )->( eof() )
            dbPass( dbfTikT, dbfVal, .t. )
            ( dbfTikT )->( dbSkip() )
         end while
      end if

   end if

   /*
   Seleccionamos los q traiga del temporal-------------------------------------
   */

   ( dbfVal  )->( ordSetFocus( "cNumTik" ) )
   ( dbfTmpV )->( dbGoTop() )

   while !( dbfTmpV )->( eof() )
      if ( dbfVal )->( dbSeek( ( dbfTmpV )->cSerTik + ( dbfTmpV )->cNumTik + ( dbfTmpV )->cSufTik ) )
        ( dbfVal )->lSelDoc   := .t.
      end if
      ( dbfTmpV )->( dbSkip() )
   end while

   ( dbfVal  )->( ordSetFocus( "cNumTik" ) )
   ( dbfVal  )->( dbGoTop() )

   /*
   Posicinamiento--------------------------------------------------------------
   */

   DEFINE DIALOG oDlg RESOURCE "HelpEntry" TITLE 'Seleccionar vales'

      REDEFINE GET aGet1 ;
         VAR      cGet1;
			ID 		104 ;
			PICTURE	"@!" ;
         ON CHANGE( AutoSeek( nKey, nFlags, Self, oBrw, dbfVal, .t. ) );
         VALID    ( OrdClearScope( oBrw, dbfVal ) );
         BITMAP   "FIND" ;
         OF       oDlg

		REDEFINE COMBOBOX oCbxOrd ;
			VAR 		cCbxOrd ;
			ID 		102 ;
         ITEMS    aCbxOrd ;
         ON CHANGE( CambiarOrd( oBrw, oCbxOrd, dbfVal ) );
         OF       oDlg

      oBrw                    := IXBrowse():New( oDlg )

      oBrw:bClrSel            := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrw:bClrSelFocus       := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrw:cAlias             := dbfVal
      oBrw:cName              := "Vale detalle"
      oBrw:bLDblClick         := {|| if( dbLock( dbfVal ), ( ( dbfVal )->lSelDoc := !( dbfVal )->lSelDoc, ( dbfVal )->( dbUnLock() ) ), ), oBrw:DrawSelect() }

      oBrw:nMarqueeStyle      := 5

      with object ( oBrw:AddCol() )
         :cHeader             := "Se. Seleccionado"
         :bStrData            := {|| "" }
         :bEditValue          := {|| ( dbfVal )->lSelDoc }
         :nWidth              := 20
         :SetCheck( { "Sel16", "Nil16" } )
      end with

      with object ( oBrw:AddCol() )
         :cHeader             := "Número"
         :cSortOrder          := "cLiqVal"
         :bEditValue          := {|| ( dbfVal )->cSerTik + "/" + AllTrim( ( dbfVal )->cNumTik ) + "/" + ( dbfVal )->cSufTik }
         :nWidth              := 70
         :bLClickHeader       := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader             := "Fecha"
         :bEditValue          := {|| Dtoc( ( dbfVal )->dFecTik ) }
         :nWidth              := 70
      end with

      with object ( oBrw:AddCol() )
         :cHeader             := "Código cliente"
         :bEditValue          := {|| Rtrim( ( dbfVal )->cCliTik ) }
         :cSortOrder          := "cCliVal"
         :nWidth              := 75
         :bLClickHeader       := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader             := "Nombre cliente"
         :bEditValue          := {|| AllTrim( ( dbfVal )->cNomTik ) }
         :cSortOrder          := "cNomVal"
         :nWidth              := 150
         :bLClickHeader       := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader             := "Importe "
         :bEditValue          := {|| nTotalizer( ( dbfVal )->cSerTik + ( dbfVal )->cNumTik + ( dbfVal )->cSufTik, dbfVal, dbfTikL, dbfTikP, dbfAlbCliT, dbfAlbCliL, dbfFacCliT, dbfFacCliL, dbfFacCliP, dbfIva, dbfDiv, cDivEmp(), .t. ) }
         :nWidth              := 85
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
      end with

      with object ( oBrw:AddCol() )
         :cHeader             := "Div."
         :bEditValue          := {|| cSimDiv( ( dbfVal )->cDivTik, dbfDiv ) }
         :nWidth              := 30
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
      end with

      with object ( oBrw:AddCol() )
         :cHeader             := "Sesión"
         :bEditValue          := {|| ( dbfVal )->cTurTik + "/" + ( dbfVal )->cSufTik }
         :nWidth              := 80
         :lHide               := .t.
      end with

      with object ( oBrw:AddCol() )
         :cHeader             := "Hora"
         :bEditValue          := {|| ( dbfVal )->cHorTik }
         :nWidth              := 80
         :lHide               := .t.
      end with

      with object ( oBrw:AddCol() )
         :cHeader             := "Caja"
         :bEditValue          := {|| ( dbfVal )->cNcjTik }
         :nWidth              := 80
         :lHide               := .t.
      end with

      with object ( oBrw:AddCol() )
         :cHeader             := "Cajero"
         :bEditValue          := {|| ( dbfVal )->cCcjTik }
         :nWidth              := 80
         :lHide               := .t.
      end with

      with object ( oBrw:AddCol() )
         :cHeader             := "Almacén"
         :bEditValue          := {|| ( dbfVal )->cAlmTik }
         :nWidth              := 80
         :lHide               := .t.
      end with

      oBrw:CreateFromResource( 105 )

      REDEFINE BUTTON oBtnSelect;
			ID 		500 ;
			OF 		oDlg ;
         ACTION   ( ( dbfVal )->lSelDoc := .t., oBrw:DrawSelect() )

      REDEFINE BUTTON oBtnUnSelect ;
			ID 		501 ;
			OF 		oDlg ;
         ACTION   ( ( dbfVal )->lSelDoc := .f., oBrw:DrawSelect() )

		REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
         ACTION   ( oDlg:end( IDOK ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
         CANCEL ;
         ACTION   ( oDlg:end() )

   oDlg:AddFastKey( VK_F5,       {|| oDlg:end( IDOK ) } )
   oDlg:AddFastKey( VK_RETURN,   {|| oDlg:end( IDOK ) } )

   ACTIVATE DIALOG oDlg ;
         CENTER ;
         ON INIT  ( SetWindowText( oBtnSelect:hWnd, "&Seleccionar" ), SetWindowText( oBtnUnSelect:hWnd, "&Deseleccionar" ), oBrw:Load() )

   /*
   Guardamos los vales en el array---------------------------------------------
   */

   if oDlg:nResult == IDOK

      ( dbfTmpV )->( __dbZap() )

      ( dbfVal )->( dbGoTop() )
      while !( dbfVal )->( Eof() )

         if ( dbfVal )->lSelDoc

            if ( dbfVal )->dFecTik + uFieldEmpresa( "nDiaVale" ) > GetSysDate()
               lError   := .t.
               cText    += Space( 6 ) + "El vale " + ( dbfVal )->cSerTik + "/" +  AllTrim( ( dbfVal )->cNumTik ) + " no ha alcanzado la fecha para su liqidación." + CRLF
            end if

            if ( dbfVal )->cCliTik != cCodCliente
               lError   := .t.
               cText    += Space( 6 ) + "El vale " + ( dbfVal )->cSerTik + "/" +  AllTrim( ( dbfVal )->cNumTik ) + " no pertenece al mismo cliente que el ticket." + CRLF
            endif

            if !lError
               dbPass( dbfVal, dbfTmpV, .t. )
            end if

         end if

         ( dbfVal )->( dbSkip() )

      end while

      ( dbfVal )->( dbGoTop() )

      if !Empty( cText )
         MsgStop( "Atención : " +  CRLF + cText )
      end if

   end if

   /*
   Repos-----------------------------------------------------------------------
   */

   if !Empty( cNewFil ) .and. ( cNewFil )->( Used() )
      ( cNewFil )->( dbCloseArea() )
   end if

   ( dbfTikT )->( OrdSetFocus( nOrdAnt ) )
   ( dbfTikT )->( dbGoTo( nRecAnt ) )

   dbfErase( cNewFil )

   if oBrwVal != nil
      oBrwVal:Refresh()
   end if

RETURN ( oDlg:nResult == IDOK )

//-------------------------------------------------------------------------//

STATIC FUNCTION CambiarOrd( oBrw, oCbx, dbfTikT )

   local nOrd  := oCbx:nAt

   do case
      case ( nOrd == 1 )
         ( dbfTikT )->( OrdSetFocus( "cLiqVal" ) )

      case ( nOrd == 2 )
         ( dbfTikT )->( OrdSetFocus( "cCliVal" ) )

      case ( nOrd == 3 )
         ( dbfTikT )->( OrdSetFocus( "cNomVal" ) )

   end case

   oBrw:GoTop()

Return nil

//---------------------------------------------------------------------------//

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

      if ( dbfTmpL )->cCbaTil == Padr( aTmp[ _CCBATIL ], 18 )        .and. ;
         ( dbfTmpL )->cComTil == aTmp[ _CCOMTIL ]                    .and. ;
         ( dbfTmpL )->cCodPr1 == aTmp[ _CCODPR1 ]                    .and. ;
         ( dbfTmpL )->cValPr1 == aTmp[ _CVALPR1 ]                    .and. ;
         ( dbfTmpL )->cCodPr2 == aTmp[ _CCODPR2 ]                    .and. ;
         ( dbfTmpL )->cValPr2 == aTmp[ _CVALPR2 ]                    .and. ;
         ( dbfTmpL )->nPvpTil == aTmp[ _NPVPTIL ]                    .and. ;
         ( dbfTmpL )->nDtoLin == aTmp[ _NDTOLIN ]                    .and. ;
         ( dbfTmpL )->cLote == aTmp[ _CLOTE ]                        .and. ;
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

   local nRecno            := ( dbfTmpL )->( RecNo() )
   local nVentasPrevias    := 0

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

   while !( dbfTmpL )->( eof() ) .and. ( dbfTmpL )->( ordKeyCount() ) > 1

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

//-------------------------------------------------------------------------//

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

function nVtaTik( cCodCli, dDesde, dHasta, dbfTikT, dbfTikL, dbfIva, dbfDiv, nYear )

   local nCon     := 0
   local aSta     := aGetStatus( dbfTikT )

   /*
   Facturas a Clientes -------------------------------------------------------
   */

   if ( dbfTikT )->( dbSeek( cCodCli ) )

      while ( dbfTikT )->cCliTik = cCodCli .and. !( dbfTikT )->( Eof() )

         if ( dDesde == nil .or. ( dbfTikT )->dFecTik >= dDesde ) .and.;
            ( dHasta == nil .or. ( dbfTikT )->dFecTik <= dHasta ) .and.;
            ( nYear == nil .or. Year( ( dbfTikT )->dFecTik ) == nYear )

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

Function nValTik( cCodCli, dDesde, dHasta, dbfTikT, dbfTikL, dbfDiv, nYear )

   local nCon     := 0
   local aSta     := aGetStatus( dbfTikT )

   ( dbfTikT )->( OrdSetFocus( "cCliVal" ) )

   if ( dbfTikT )->( dbSeek( cCodCli ) )

      while ( dbfTikT )->cCliTik == cCodCli .and. !( dbfTikT )->( eof() )

         if ( dDesde == nil .or. ( dbfTikT )->dFecTik >= dDesde ) .and.;
            ( dHasta == nil .or. ( dbfTikT )->dFecTik <= dHasta ) .and.;
            ( nYear == nil .or. Year( ( dbfTikT )->dFecTik ) == nYear )

            nCon  += nTotTik( ( dbfTikT )->cSerTik + ( dbfTikT )->cNumTik + ( dbfTikT )->cSufTik, dbfTikT, dbfTikL, dbfDiv, , , .f. )

         end if

         ( dbfTikT )->( dbSkip() )

      end while

   end if

   SetStatus( dbfTikT, aSta )

return nCon

//----------------------------------------------------------------------------//

Function oWndTactil()

Return oWndBrw

//----------------------------------------------------------------------------//

Static Function lValidDlgTpv( aTmp, aGet, nSaveMode )

   local lValid   := .t.

   if ( dbfTmpL )->( ordKeyCount() ) != 0 .and. ApoloMsgNoYes( "¿Desea guardar el ticket antes de salir?", "Selecciona una opción", .t. )
      lValid      :=  TmpTiket( aTmp, aGet, nSaveMode, .f. )
   end if

Return lValid

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

   oDlgTpv:Refresh()

Return ( nil )

//---------------------------------------------------------------------------//

Static Function EdtCob( aTmp, aGet, dbfTikP, oBrw, bWhen, bValid, nMode, aTmpTik )

	local oDlg
   local oSay
   local cSay
   local oBmpDiv
   local cImpDiv
   local oGetCaj
   local cGetCaj
   local oGetFpg
   local cGetFpg
   local oGetSubCta
   local cGetSubCta

   if nMode == APPD_MODE
      aTmp[ _NVDVPGO ]  := 1
      aTmp[ _CDIVPGO ]  := cDivEmp()
      aTmp[ _CFPGPGO ]  := cDefFpg()
      aTmp[ _CTURPGO ]  := cCurSesion()
      aTmp[ _CCODCAJ ]  := oUser():cCaja()
   end if

   cImpDiv              := cPorDiv( aTmp[ _CDIVPGO ], dbfDiv )
   cGetCaj              := RetFld( aTmp[ _CCODCAJ ], dbfCajT, "cNomCaj" )
   cGetFpg              := RetFld( aTmp[ _CFPGPGO ], dbfFPago )
   cSay                 := Num2Text( aTmp[ _NIMPTIK ] )

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
         ON HELP  ( BrwChkSubCta( aGet[ _CCTAREC ], oGetSubCta ) ) ;
         VALID    ( MkSubCta( aGet[ _CCTAREC ], { aTmp[ _CCTAREC ] }, oGetSubCta ) );
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

Static Function loaCli( aGet, aTmp, nMode, oTelefonoClient, oMailClient )

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

      if ( lChgCodCli )
         aTmp[ _LMODCLI ]  := ( dbfClient )->lModDat
      end if

      aGet[ _CCLITIK ]:cText( ( dbfClient )->Cod )

      if Empty( aGet[ _NTARIFA ]:varGet() ) .or. lChgCodCli
         aGet[ _NTARIFA ]:cText( ( dbfClient )->nTarifa )
      end if

      if ( dbfClient )->nColor != 0
         aGet[ _CNOMTIK ]:SetColor( , ( dbfClient )->nColor )
      end if

      if lChgCodCli
         aGet[ _CNOMTIK ]:cText( ( dbfClient )->Titulo  )
      end if

      if Empty( aGet[ _CDIRCLI ]:varGet() ) .or. lChgCodCli
         aGet[ _CDIRCLI ]:cText( ( dbfClient )->Domicilio )
      end if

      if Empty( aGet[ _CPOBCLI ]:varGet() ) .or. lChgCodCli
         aGet[ _CPOBCLI ]:cText( ( dbfClient )->Poblacion )
      end if

      if Empty( aGet[ _CTLFCLI ]:varGet() ) .or. lChgCodCli
         aGet[ _CTLFCLI ]:cText( ( dbfClient )->Telefono )
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

      if Empty( aTmp[ _CCODGRP ] ) .or. lChgCodCli
         aTmp[ _CCODGRP ]  := ( dbfClient )->cCodGrp
      end if

      /*
      Cargamos la obra por defecto-------------------------------------
      */

      if ( lChgCodCli ) .and. !Empty( aGet[ _CCODOBR ] )

         if dbSeekInOrd( cNewCodCli, "lDefObr", dbfObrasT )
            aGet[ _CCODOBR ]:cText( ( dbfObrasT )->cCodObr )
         else
            aGet[ _CCODOBR ]:cText( Space( 10 ) )
         end if

         aGet[ _CCODOBR ]:lValid()

      end if


      if oTelefonoClient != nil
         oTelefonoClient:SetText( ( dbfClient )->Telefono )
      end if

      if oMailClient != nil
         oMailClient:SetText( ( dbfClient )->cMeiInt )
      end if

      /*
      Descuentos desde la ficha de cliente----------------------------------
      */

      if lChgCodCli

         if !Empty( aGet[ _CDTOESP ] )
            aGet[ _CDTOESP ]:cText( ( dbfClient )->cDtoEsp )
         else
            aTmp[ _CDTOESP ]  := ( dbfClient )->cDtoEsp
         end if

         if !Empty( aGet[ _NDTOESP ] )
            aGet[ _NDTOESP ]:cText( ( dbfClient )->nDtoEsp )
         else
            aTmp[ _NDTOESP ]  := ( dbfClient )->nDtoEsp
         end if

         if !Empty( aGet[ _CDPP    ] )
            aGet[ _CDPP    ]:cText( ( dbfClient )->cDpp )
         else
            aTmp[ _CDPP    ]  := ( dbfClient )->cDpp
         end if

         if !Empty( aGet[ _NDPP    ] )
            aGet[ _NDPP    ]:cText( ( dbfClient )->nDpp )
         else
            aTmp[ _NDPP    ]  := ( dbfClient )->nDpp
         end if

      end if

      /*
      Solo si el ticket es nuevo-----------------------------------------------
      */

      if nMode == APPD_MODE

         if !Empty( ( dbfClient )->Serie ) .and. lChgCodCli
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
               aGet[ _CFPGTIK ]:cText( ( dbfClient )->CodPago )
            end if
            aGet[ _CFPGTIK ]:lValid()
         end if

         if ( Empty( aGet[ _CCODAGE ]:varGet() ) .or. lChgCodCli ) .and. !Empty( ( dbfClient )->cAgente )
            aGet[ _CCODAGE ]:cText( ( dbfClient )->cAgente )
            aGet[ _CCODAGE ]:lValid()
         end if

         if ( Empty( aGet[ _CCODRUT ]:varGet() ) .or. lChgCodCli ) .and. !Empty( ( dbfClient )->cCodRut )
            aGet[ _CCODRUT ]:cText( ( dbfClient )->cCodRut )
            aGet[ _CCODRUT ]:lValid()
         end if

         aTmp[ _NREGIVA ]  := ( dbfClient )->nRegIva

      end if

      if ( dbfClient )->lMosCom .and. !Empty( ( dbfClient )->mComent ) .and. lChgCodCli
         MsgStop( Trim( ( dbfClient )->mComent ) )
      end if

      if !Empty( oRieCli ) .and. lChgCodCli
         oStock:SetRiesgo( cNewCodCli, oRieCli, ( dbfClient )->Riesgo )
      end if

      if lObras() .and. Empty( aTmp[ _CCODOBR ] ) .and. lChgCodCli
         msgWait( "Introduzca la obra", "Info", 0 )
         aGet[ _CCODOBR ]:SetFocus()
      end if

      cOldCodCli     := cNewCodCli
      lValid         := .t.

   else

		msgStop( "Cliente no encontrado" )

   end if

   /*
   Recalculamos el ticket por si el nuevo cliente tiene descuentos-------------
   */

   if lChgCodCli
      lRecTotal( aTmp )
   end if

Return lValid

//----------------------------------------------------------------------------//

Static Function TPadl( cExp, n )

Return Padl( AllTrim( cExp ), n )

//----------------------------------------------------------------------------//

Function SavTik2Alb( aTik, aGet, nMode, nSave )

   local aTotal
   local cSerTik                 := aTik [ _CSERTIK ]
   local cNumTik                 := aTik [ _CNUMTIK ]
   local cSufTik                 := aTik [ _CSUFTIK ]
   local nNewAlbCli
   local nOrdAnt

   if nMode == APPD_MODE .or. lApartado

      /*
      Nuevo numero del Albaran-------------------------------------------------
      */

      cNumTik                    := nNewDoc( aTik[ _CSERTIK ], dbfAlbCliT, "nAlbCli", , dbfCount )
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
      ( dbfAlbCliT )->cDtoEsp    := aTik[ _CDTOESP ]
      ( dbfAlbCliT )->nDtoEsp    := aTik[ _NDTOESP ]
      ( dbfAlbCliT )->cDpp       := aTik[ _CDPP ]
      ( dbfAlbCliT )->nDpp       := aTik[ _NDPP ]

      ( dbfAlbCliT )->( dbUnLock() )

      /*
      Punteros entre documentos---------------------------------------------------
      */

      aTik[ _CNUMDOC ]           := cSerTik + Str( cNumTik, 9 ) + cSufTik

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
      Eliminamos las lineas antiguas del albarán-------------------------------
      */

      nOrdAnt  := ( dbfAlbCliL )->( OrdSetFocus( "NNUMALB" ) )

      while ( dbfAlbCliL )->( dbSeek( aTik[ _CNUMDOC ] ) ) .and. !( dbfAlbCliL )->( eof() )
         if dbLock( dbfAlbCliL )
            ( dbfAlbCliL )->( dbDelete() )
            ( dbfAlbCliL )->( dbUnLock() )
         end if
      end while

      ( dbfAlbCliL )->( OrdSetFocus( nOrdAnt ) )

   end if

   /*
   Cabecera del albaran--------------------------------------------------------
   */

   if dbLock( dbfAlbCliT )

      ( dbfAlbCliT )->lFacturado    := .f.
      ( dbfAlbCliT )->lSndDoc       := .t.
      ( dbfAlbCliT )->lIvaInc       := .t.
      ( dbfAlbCliT )->cCodCli       := aTik[ _CCLITIK ]
      ( dbfAlbCliT )->cCodAlm       := aTik[ _CALMTIK ]
      ( dbfAlbCliT )->cCodCaj       := aTik[ _CNCJTIK ]
      ( dbfAlbCliT )->cNomCli       := aTik[ _CNOMTIK ]
      ( dbfAlbCliT )->cCodPago      := aTik[ _CFPGTIK ]
      ( dbfAlbCliT )->cDivAlb       := aTik[ _CDIVTIK ]
      ( dbfAlbCliT )->nVdvAlb       := aTik[ _NVDVTIK ]
      ( dbfAlbCliT )->cRetMat       := aTik[ _CRETMAT ]
      ( dbfAlbCliT )->cCodAge       := aTik[ _CCODAGE ]
      ( dbfAlbCliT )->cCodRut       := aTik[ _CCODRUT ]
      ( dbfAlbCliT )->cCodTar       := aTik[ _CCODTAR ]
      ( dbfAlbCliT )->cCodObr       := aTik[ _CCODOBR ]
      ( dbfAlbCliT )->nPctComAge    := aTik[ _NCOMAGE ]
      ( dbfAlbCliT )->cDtoEsp       := aTik[ _CDTOESP ]
      ( dbfAlbCliT )->nDtoEsp       := aTik[ _NDTOESP ]
      ( dbfAlbCliT )->cDpp          := aTik[ _CDPP ]
      ( dbfAlbCliT )->nDpp          := aTik[ _NDPP ]

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
      ( dbfAlbCliL )->dFecAlb    := ( dbfAlbCliT )->dFecAlb
      ( dbfAlbCliL )->cAlmLin    := aTik[ _CALMTIK ]
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
   Rellenamos los campos de los totales----------------------------------------
   */

   aTotal            := aTotAlbCli( aTik[ _CNUMDOC ], dbfAlbCliT, dbfAlbCliL, dbfIva, dbfDiv )

   aTik[ _NTOTNET ]  := aTotal[1]
   aTik[ _NTOTIVA ]  := aTotal[2]
   aTik[ _NTOTTIK ]  := aTotal[4]

   if dbLock( dbfAlbCliT )
      ( dbfAlbCliT )->nTotNet    := aTotal[1]
      ( dbfAlbCliT )->nTotIva    := aTotal[2]
      ( dbfAlbCliT )->nTotReq    := aTotal[3]
      ( dbfAlbCliT )->nTotAlb    := aTotal[4]
      ( dbfAlbCliT )->( dbUnLock() )
   end if

   /*
   Escribimos definitivamente en el disco--------------------------------------
   */

   WinGather( aTik, aGet, dbfTikT, oBrwDet, nMode, nil, .t. )

return ( nNewAlbCli )

//----------------------------------------------------------------------------//

Function nTotalizer( cNumTik, cTikT, cTikL, cTikP, cAlbCliT, cAlbCliL, cFacCliT, cFacCliL, cFacCliP, cIva, cDiv, cCodDiv, lPic )

   local uTotal         := 0
   local aTotal         := {}

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
   DEFAULT lPic         := .t.

   if Empty( cTikT ) .or. Empty( cTikL )
      Return ( uTotal )
   end if

   if Empty( cNumTik )
      cNumTik           := ( cTikT )->cSerTik + ( cTikT )->cNumTik + ( cTikT )->cSufTik
   end if

   public nTotAlb       := 0
   public nTotFac       := 0
   public aBrtTik       := { 0, 0, 0 }
   public aBasTik       := { 0, 0, 0 }
   public aImpTik       := { 0, 0, 0 }
   public aIvaTik       := { nil, nil, nil }
   public aIvmTik       := { 0, 0, 0 }
   public cCtaCli       := cClientCuenta( ( cTikT )->cCliTik )

   uTotal               := if( lPic, "0", 0 )

   do case
      case ( cTikT )->cTipTik == SAVALB // Como albaran

         if ( cAlbCliT )->( dbSeek( ( cTikT )->cNumDoc ) )

            aTotal      := aTotAlbCli( ( cTikT )->cNumDoc, cAlbCliT, cAlbCliL, cIva, cDiv )

            uTotal      := aTotal[ 4 ]
            nTotAlb     := uTotal

            aBrtTik     := { aTotal[ 8 ][ 1, 1 ], aTotal[ 8 ][ 2, 1 ], aTotal[ 8 ][ 3, 1 ] }
            aBasTik     := { aTotal[ 8 ][ 1, 2 ], aTotal[ 8 ][ 2, 2 ], aTotal[ 8 ][ 3, 2 ] }
            aImpTik     := { aTotal[ 8 ][ 1, 8 ], aTotal[ 8 ][ 2, 8 ], aTotal[ 8 ][ 3, 8 ] }
            aIvaTik     := { aTotal[ 8 ][ 1, 3 ], aTotal[ 8 ][ 2, 3 ], aTotal[ 8 ][ 3, 3 ] }
            aIvmTik     := { aTotal[ 8 ][ 1, 6 ], aTotal[ 8 ][ 2, 6 ], aTotal[ 8 ][ 3, 6 ] }

         end if

      case ( cTikT )->cTipTik == SAVFAC // Como factura

         if ( cFacCliT )->( dbSeek( ( cTikT )->cNumDoc ) )

            aTotal      := aTotFacCli( ( cTikT )->cNumDoc, cFacCliT, cFacCliL, cIva, cDiv, cFacCliP )

            uTotal      := aTotal[ 4 ]
            nTotFac     := uTotal

            aBrtTik     := { aTotal[ 8 ][ 1, 1 ], aTotal[ 8 ][ 2, 1 ], aTotal[ 8 ][ 3, 1 ] }
            aBasTik     := { aTotal[ 8 ][ 1, 2 ], aTotal[ 8 ][ 2, 2 ], aTotal[ 8 ][ 3, 2 ] }
            aImpTik     := { aTotal[ 8 ][ 1, 8 ], aTotal[ 8 ][ 2, 8 ], aTotal[ 8 ][ 3, 8 ] }
            aIvaTik     := { aTotal[ 8 ][ 1, 3 ], aTotal[ 8 ][ 2, 3 ], aTotal[ 8 ][ 3, 3 ] }
            aIvmTik     := { aTotal[ 8 ][ 1, 6 ], aTotal[ 8 ][ 2, 6 ], aTotal[ 8 ][ 3, 6 ] }

         end if

      otherwise

         uTotal         := nTotTik( cNumTik, cTikT, cTikL, cDiv, nil, cCodDiv, lPic )

         // nTotVal        := nTotValTik( cNumTik, cTikT, cTikL, cDiv, cCodDiv )

   end case

return ( uTotal )

//----------------------------------------------------------------------------//

Static Function nChkalizer( cNumTik, dbfTikT, dbfTikL, dbfTikP, dbfFacCliT, dbfFacCliL, dbfFacCliP, dbfIva, dbfDiv, cCodDiv )

   local nPgo     := 1
   local aStatus  := aGetStatus( dbfTikT, .t. )
   local nRec     := ( dbfFacCliT )->( RecNo() )
   local nOrdAnt  := ( dbfFacCliT )->( OrdSetFocus( "nNumFac" ) )

   if ( dbfTikT )->( dbSeek( cNumTik ) )

      do case
      case ( dbfTikT )->cTipTik == SAVALB // Como albaran

         if RetFld( ( dbfTikT )->cNumDoc, dbfAlbCliT, "lFacturado" )
            nPgo  := 1
         else
            nPgo  := 3
         end if

      case ( dbfTikT )->cTipTik == SAVFAC // Como factura

         if ( dbfFacCliT )->( dbSeek( ( dbfTikT )->cNumDoc ) )
            nPgo  := nChkPagFacCli( ( dbfTikT )->cNumDoc, dbfFacCliT, dbfFacCliP )
         else
            nPgo  := 3
         end if

      case ( dbfTikT )->cTipTik == SAVVAL // Como Vale

         nPgo     := if( ( dbfTikT )->lLiqTik, 1, 3 )

      otherwise

         nPgo     := nChkPagTik( cNumTik, dbfTikT, dbfTikL, dbfTikP, dbfIva, dbfDiv )

      end case

   end if

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

   local aTotal
   local nNumRec                 := 0
   local cCliTik                 := aTik[ _CCLITIK ]
   local cSerFacCli
   local nNewFacCli
   local cSufFacCli
   local cCliFacCli
   local cNomFacCli
   local dFecFacCli
   local nOrdAnt
   local cCodFam                 := ""

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
      dFecFacCli                 := aTik[ _DFECTIK ]

      ( dbfFacCliT )->( dbAppend() )
      ( dbfFacCliT )->cSerie     := cSerFacCli
      ( dbfFacCliT )->nNumFac    := nNewFacCli
      ( dbfFacCliT )->cSufFac    := cSufFacCli
      ( dbfFacCliT )->dFecFac    := dFecFacCli
      ( dbfFacCliT )->cTurFac    := cCurSesion()
      ( dbfFacCliT )->dFecCre    := aTik[ _DFECCRE ]
      ( dbfFacCliT )->cTimCre    := aTik[ _CTIMCRE ]
      ( dbfFacCliT )->cCodUsr    := aTik[ _CCCJTIK ]
      ( dbfFacCliT )->cNumDoc    := aTik[ _CSERTIK ] + aTik[ _CNUMTIK ] + aTik[ _CSUFTIK ]
      ( dbfFacCliT )->cDtoEsp    := aTik[ _CDTOESP ]
      ( dbfFacCliT )->nDtoEsp    := aTik[ _NDTOESP ]
      ( dbfFacCliT )->cDpp       := aTik[ _CDPP ]
      ( dbfFacCliT )->nDpp       := aTik[ _NDPP ]

      ( dbfFacCliT )->( dbUnLock() )

      /*
      Punteros entre documentos------------------------------------------------
      */

      aTik[ _CNUMDOC ]           := cSerFacCli + Str( nNewFacCli, 9 ) + cSufFacCli

   else

      cCliFacCli                 := aTik[ _CCLITIK ]
      cNomFacCli                 := aTik[ _CNOMTIK ]
      dFecFacCli                 := aTik[ _DFECTIK ]

      /*
      Posicionamos en el factura existente-------------------------------------
      */

      if ( dbfFacCliT )->( dbSeek( aTik[ _CNUMDOC ] ) )

         cSerFacCli              := ( dbfFacCliT )->cSerie
         nNewFacCli              := ( dbfFacCliT )->nNumFac
         cSufFacCli              := ( dbfFacCliT )->cSufFac

         /*
         Rollback de los stocks------------------------------------------------
         */

         /*if dbLock( dbfFacCliT )
            oStock:FacCli( ( dbfFacCliT )->cSerie + Str( ( dbfFacCliT )->nNumFac ) + ( dbfFacCliT )->cSufFac, ( dbfFacCliT )->cCodAlm, .t., .t., .t. )
            ( dbfFacCliT )->( dbUnLock() )
         end if*/


         /*
         Eliminamos las lineas antiguas del albarán-------------------------------
         */

         nOrdAnt  := ( dbfFacCliL )->( OrdSetFocus( "NNUMFAC" ) )

         while ( dbfFacCliL )->( dbSeek( aTik[ _CNUMDOC ] ) ) .and. !( dbfFacCliL )->( eof() )
            if dbLock( dbfFacCliL )
               ( dbfFacCliL )->( dbDelete() )
               ( dbfFacCliL )->( dbUnLock() )
            end if
         end while

         ( dbfFacCliL )->( OrdSetFocus( nOrdAnt ) )

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
      ( dbfFacCliT )->cDtoEsp       := aTik[ _CDTOESP ]
      ( dbfFacCliT )->nDtoEsp       := aTik[ _NDTOESP ]
      ( dbfFacCliT )->cDpp          := aTik[ _CDPP ]
      ( dbfFacCliT )->nDpp          := aTik[ _NDPP ]

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
      ( dbfFacCliL )->dFecFac    := dFecFacCli
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
      ( dbfFacCliL )->cAlmLin    := aTik[ _CALMTIK ]
      ( dbfFacCliL )->lIvaLin    := .t.
      cCodFam                    := RetFamArt( ( dbfTmpL )->cCbaTil, dbfArticulo )
      ( dbfFacCliL )->cCodFam    := cCodFam
      ( dbfFacCliL )->cGrpFam    := cGruFam( cCodFam, dbfFamilia )

      ( dbfFacCliL )->( dbUnLock() )

      ( dbfTmpL )->( dbSkip() )

   end while

   /*
   Rollback de los pagos-------------------------------------------------------
   */

   while ( dbfFacCliP )->( dbSeek( ( dbfFacCliT )->cSerie + Str( ( dbfFacCliT )->nNumFac ) + ( dbfFacCliT )->cSufFac ) ) .and. !( dbfFacCliP )->( eof() )

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
   Guardamos los valores para los totales--------------------------------------
   */

   aTotal                        := aTotFacCli( aTik[ _CNUMDOC ], dbfFacCliT, dbfFacCliL, dbfIva, dbfDiv, dbfFacCliP, dbfAntCliT )

   aTik[ _NTOTNET ]              := aTotal[1]
   aTik[ _NTOTIVA ]              := aTotal[2]
   aTik[ _NTOTTIK ]              := aTotal[4]

   if dbLock( dbfFacCliT )
      ( dbfFacCliT )->nTotNet    := aTotal[1]
      ( dbfFacCliT )->nTotIva    := aTotal[2]
      ( dbfFacCliT )->nTotReq    := aTotal[3]
      ( dbfFacCliT )->nTotFac    := aTotal[4]
      ( dbfFacCliT )->( dbUnLock() )
   end if

   /*
   Escribimos definitivamente en el disco--------------------------------------
   */

   WinGather( aTik, aGet, dbfTikT, oBrwDet, nMode, nil, .t. )

return ( nNewFacCli )

//---------------------------------------------------------------------------//

Static Function SavTik2Neg( aTmp, aGet, nMode, nSave )

   local aTbl
   local cNumTik
   local cSerTik

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
   cSerTik                 := aTbl[ _CSERTIK ]
   cNumTik                 := Str( nNewDoc( aTbl[ _CSERTIK ], dbfTikT, "nTikCli", 10, dbfCount ), 10 )
   aTbl[ _CTURTIK ]        := cCurSesion()
   aTbl[ _CNUMTIK ]        := cNumTik
   aTbl[ _CSUFTIK ]        := RetSufEmp()
   aTbl[ _CTIPTIK ]        := SAVTIK
   aTbl[ _DFECTIK ]        := GetSysDate()
   aTbl[ _LSNDDOC ]        := .t.
   aTbl[ _LCLOTIK ]        := .f.
   aTbl[ _NTOTNET ]        := - aTbl[ _NTOTNET ]
   aTbl[ _NTOTIVA ]        := - aTbl[ _NTOTIVA ]
   aTbl[ _NTOTTIK ]        := - aTbl[ _NTOTTIK ]

   dbGather( aTbl, dbfTikT, .t. )

   /*
   Guardamos las lineas del tiket----------------------------------------------
   */

   ( dbfTmpL )->( dbGoTop() )
   while !( dbfTmpL )->( eof() )

      aTbl                 := dbScatter( dbfTmpL )
      aTbl[ _CSERTIL ]     := cSerTik
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
      aTbl[ _CSERTIK ]     := cSerTik
      aTbl[ _CNUMTIK ]     := cNumTik
      aTbl[ _CSUFTIK ]     := RetSufEmp()
      aTbl[ _NIMPTIK ]     := - ( aTbl[ _NIMPTIK ] - aTbl[ _NDEVTIK ] )

      dbGather( aTbl, dbfTikP, .t. )

      ( dbfTmpP )->( dbSkip() )

   end while

   ( dbfTmpP )->( dbGoTop() )

Return nil

//---------------------------------------------------------------------------//

Static Function SavTik2Tik( aTmp, aGet, nMode, nSave, nNumDev )

   local nRec
   local aTotal

   /*
   Guardamos el tipo como tiket---------------------------------------
   */

   if !Empty( oMetMsg )
      oMetMsg:cText        := 'Archivando lineas'
      oMetMsg:Refresh()
   end if

   nRec                    := ( dbfTmpL )->( Recno() )

   ( dbfTmpL )->( dbGoTop() )
   while !( dbfTmpL )->( eof() )

      if ( dbfTmpL )->dFecTik != aTmp[ _DFECTIK ]
         ( dbfTmpL )->dFecTik := aTmp[ _DFECTIK ]
      end if

      dbPass( dbfTmpL, dbfTikL, .t., aTmp[ _CSERTIK ], aTmp[ _CNUMTIK ], aTmp[ _CSUFTIK ], aTmp[ _CTIPTIK ] )

      ( dbfTmpL )->( dbSkip() )

   end while
   ( dbfTmpL )->( dbGoTo( nRec ) )

   /*
   Ahora escribimos en el fichero definitivo los pagos-------------------------
   */
   if !Empty( oMetMsg )
      oMetMsg:cText           := 'Archivando pagos'
      oMetMsg:Refresh()
   end if

   ( dbfTmpP )->( dbGoTop() )
   while !( dbfTmpP )->( eof() )
      dbPass( dbfTmpP, dbfTikP, .t., aTmp[ _CSERTIK ], aTmp[ _CNUMTIK ], aTmp[ _CSUFTIK ] )
      ( dbfTmpP )->( dbSkip() )
   end while

   /*
   Guardamos las series--------------------------------------------------------
   */

   if !Empty( oMetMsg )
      oMetMsg:cText           := 'Archivando series'
      oMetMsg:Refresh()
   end if

   nRec                    := ( dbfTmpS )->( Recno() )
   ( dbfTmpS )->( dbGoTop() )
   while !( dbfTmpS )->( eof() )
      dbPass( dbfTmpS, dbfTikS, .t., aTmp[ _CSERTIK ], aTmp[ _CNUMTIK ], aTmp[ _CSUFTIK ], aTmp[ _CTIPTIK ], aTmp[ _DFECTIK ] )
      ( dbfTmpS )->( dbSkip() )
   end while
   ( dbfTmpS )->( dbGoTo( nRec ) )

   /*
   Escribimos definitivamente en el disco--------------------------------------
   */

   if !Empty( oMetMsg )
      oMetMsg:cText  := 'Archivando ticket'
      oMetMsg:Refresh()
   end if

   /*
   No quitar-------------------------------------------------------------------
   */

   SysRefresh()

   /*
   Calculo de cobros totales---------------------------------------------------
   */

   aTotal            := nTotCobTik( aTmp[ _CSERTIK ] + aTmp[ _CNUMTIK ] + aTmp[ _CSUFTIK ], dbfTikP, dbfDiv )
   aTotal            += nTotValTik( aTmp[ _CSERTIK ] + aTmp[ _CNUMTIK ] + aTmp[ _CSUFTIK ], dbfTikT, dbfTikL, dbfDiv )

   aTmp[ _NCOBTIK ]  := aTotal

   /*
   Rellenamos los campos de totales--------------------------------------------
   */

   aTotal            := aTotTik( aTmp[ _CSERTIK ] + aTmp[ _CNUMTIK ] + aTmp[ _CSUFTIK ], dbfTikT, dbfTmpL, dbfDiv, aTmp, nil, .f. )

   aTmp[ _NTOTNET ]  := aTotal[1]
   aTmp[ _NTOTIVA ]  := aTotal[2]
   aTmp[ _NTOTTIK ]  := aTotal[3]

   /*
   Guardamos el registro definitivamente---------------------------------------
   */

   WinGather( aTmp, nil, dbfTikT, nil, nMode )

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

      nTot        := ( dbfTikT )->nTotTik
      nCob        := ( dbfTikT )->nCobTik 

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

//--------------------------------------------------------------------------//

static function nCopiasTipoTicket( cTipTik, lEntrega, dbfCajT )

   local nCopies  := 1

   do case
      case cTipTik == SAVTIK

        do case
            case ( lRegalo == .t. )
               nCopies := nCopiasTicketsRegaloEnCaja( oUser():cCaja(), dbfCajT )

            case ( lEntrega == .t. )
               nCopies := nCopiasEntregasEnCaja( oUser():cCaja(), dbfCajT )

            otherwise
               nCopies := nCopiasTicketsEnCaja( oUser():cCaja(), dbfCajT )

         end case

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

Function aTipTik( uTikT )

   local nTipTik

   DEFAULT uTikT        := dbfTikT

   do case
      case Valtype( uTikT ) == "C"

         if ( uTikT )->lFreTik
            nTipTik     := Len( aTipDoc )
         else
            nTipTik     := Val( ( uTikT )->cTipTik )
            nTipTik     := Min( Max( nTipTik, 1 ), ( Len( aTipDoc ) - 1 ) )
         end if

      case Valtype( uTikT ) == "A"

         if uTikT[ _LFRETIK ]
            nTipTik     := Len( aTipDoc )
         else
            nTipTik     := Val( uTikT[ _CTIPTIK ] )
            nTipTik     := Min( Max( nTipTik, 1 ), ( Len( aTipDoc ) - 1 ) )
         end if

      case Valtype( uTikT ) == "O"

         if uTikT:lFreTik
            nTipTik     := Len( aTipDoc )
         else
            nTipTik     := Val( uTikT:cTipTik )
            nTipTik     := Min( Max( nTipTik, 1 ), ( Len( aTipDoc ) - 1 ) )
         end if

   end case

Return ( aTipDoc[ nTipTik ] )

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
         cField   := {|| ( dbfTmpL )->cValPr1 }
      case cName == "Propiedad 2"
         cField   := {|| ( dbfTmpL )->cValPr2 }
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
         cField   := {|| Trans( ( dbfTmpL )->nDtoLin, "@E 999.99" ) }
      case cName == "Total"
         cField   := {|| Trans( nTotLTpv( dbfTmpL, nDouDiv, nDorDiv ), cPorDiv ) }
      case cName == "Número de serie"
         cField   := {|| ( dbfTmpL )->mNumSer }
      case cName == "Promoción"
         cField   := {|| ( dbfTmpL )->lInPromo }
      case cName == "Oferta"
         cField   := {|| ( dbfTmpL )->lLinOfe }
      case cName == "Número de línea"
         cField   := {|| Trans( ( dbfTmpL )->nNumLin, "9999" ) }
      case cName == "Código de barras"
         cField   := {|| cCodigoBarrasDefecto( ( dbfTmpL )->cCbaTil, dbfCodeBar ) }
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

   REDEFINE METER oTxtDel VAR nTxtDel ;
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

            WinDelRec( , dbfTikT, {|| TpvDelRec() } )

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

            WinDelRec( , dbfTikT, {|| TpvDelRec() } )

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

//--------------------------------------------------------------------------//

FUNCTION InitTikCli( nNumTik )

   local nLevel         := nLevelUsr( _MENUITEM_ )

   if nAnd( nLevel, 1 ) != 0 .or. nAnd( nLevel, ACC_EDIT ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if dbSeekInOrd( nNumTik, "cNumTik", dbfTikT )
      nTotTik()
      WinEdtRec( nil, bEditT, dbfTikT )
   else
      MsgStop( "No se encuentra ticket" )
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
            WinDelRec( oWndBrw, dbfTikT, {|| TpvDelRec() } )
         else
            MsgStop( "No se encuentra ticket" )
         end if
      end if

   else

      if OpenFiles( nil, .t. )
         if dbSeekInOrd( nNumTik, "cNumTik", dbfTikT )
            nTotTik()
            WinDelRec( oWndBrw, dbfTikT, {|| TpvDelRec() } )
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

   cCodArt                          := Alltrim( cCodArt )

   if ( dbfKit )->( dbSeek( cCodArt ) )

      while Alltrim( ( dbfKit )->cCodKit ) == ( cCodArt ) .and. !( dbfKit )->( eof() )

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
            ( dbfTmpL )->lTipAcc    := ( dbfArticulo )->lTipAcc
            ( dbfTmpL )->nCtlStk    := ( dbfArticulo )->nCtlStock
            ( dbfTmpL )->cCodImp    := ( dbfArticulo )->cCodImp
            ( dbfTmpL )->nMesGrt    := ( dbfArticulo )->nMesGrt

            if ( dbfArticulo )->lFacCnv
               ( dbfTmpL )->nFacCnv := ( dbfArticulo )->nFacCnv
            end if

            ( dbfTmpL )->nValImp    := oNewImp:nValImp( ( dbfArticulo )->cCodImp, .t., nIvaTil )
            ( dbfTmpL )->nCosDiv    := nCosto( nil, dbfArticulo, dbfKit )

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

            if ( dbfTmpL )->lKitPrc
               ( dbfTmpL )->nPvpTil := nRetPreArt( aTik[ _NTARIFA ], aTik[ _CDIVTIK ], .t., dbfArticulo, dbfDiv, dbfKit, dbfIva, .t. )
            end if

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
      !lExistIndex( cPath + "TIKEC.Cdx" )

      rxTpv( cPath )

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
   Data  nEntregado
   Data  nCobrado
   Data  nVale
   Data  nAnticipo
   Data  nCobradoDivisa
   Data  nCambio

   Data  oTotal
   Data  oEntregado
   Data  oCobrado
   Data  oCobradoDivisa
   Data  oCambio

END CLASS

Method Init() CLASS TotalesTPV

   ::nTotal             := 0
   ::nCobrado           := 0
   ::nVale              := 0
   ::nAnticipo          := 0
   ::nEntregado         := 0
   ::nCobrado           := 0
   ::nCobradoDivisa     := 0
   ::nCambio            := 0

   ::oTotal             := nil
   ::oEntregado         := nil
   ::oCobrado           := nil
   ::oCobradoDivisa     := nil
   ::oCambio            := nil

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

      if ftpSndFile( cPatOut() + cFileName, cFileName, 2000, ::oSender )
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
      ftpGetFiles( "TikCli*." + aExt[ n ], cPatIn(), 2000, ::oSender )
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

      /*oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )

      BEGIN SEQUENCE*/

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
               ::oSender:oMtr:nTotal := ( tmpTikT )->( ordKeyCount() )
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

                     //nTotTikNew := nTotTik( ( tmpTikT )->cSerTik + ( tmpTikT )->cNumTik + ( tmpTikT )->cSufTik, tmpTikT, tmpTikL, dbfDiv )
                     //nTotTikOld := nTotTik( ( dbfTikT )->cSerTik + ( dbfTikT )->cNumTik + ( dbfTikT )->cSufTik, dbfTikT, dbfTikL, dbfDiv )

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
                        ( tmpTikP )->( dbSkip() )
                     end do
                  end if

               end if

               ( tmpTikT )->( dbSkip() )

               if !Empty( ::oSender:oMtr )
                  ::oSender:oMtr:Set( ( tmpTikT )->( OrdKeyNo() ) )
               end if

               SysRefresh()

            end do

            if !Empty( ::oSender:oMtr )
               ::oSender:oMtr:nTotal := ( tmpTikT )->( ordKeyCount() )
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

      /*RECOVER USING oError

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

      ErrorBlock( oBlock )*/

   next

Return Self

//----------------------------------------------------------------------------//

Static Function GenTikCli( nDevice, cCaption, cCodDoc, cPrinter )

   local oDevice

   if ( dbfTikT )->( ordKeyCount() ) == 0
      return nil
   end if

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

   PrintReportTikCli( nDevice, 1, cPrinter )

   /*
   Codigo de corte de papel----------------------------------------------------
   */

   cCortePapelEnCaja( oUser():cCaja(), dbfCajT, dbfCajL )

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

Static Function DataReport( oFr )

   /*
   Zona de datos------------------------------------------------------------
   */

   oFr:ClearDataSets()

   oFr:SetWorkArea(     "Tickets", ( dbfTikT )->( Select() ) )
   oFr:SetFieldAliases( "Tickets", cItemsToReport( aItmTik() ) )

   oFr:SetWorkArea(     "Lineas de tickets", ( dbfTikL )->( Select() ) )
   oFr:SetFieldAliases( "Lineas de tickets", cItemsToReport( aColTik() ) )

   oFr:SetWorkArea(     "Lineas de comandas", ( dbfTikL )->( Select() ) )
   oFr:SetFieldAliases( "Lineas de comandas", cItemsToReport( aColTik() ) )

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
   oFr:SetFieldAliases( "Usuarios", cItemsToReport( aItmUsr() ) )

   oFr:SetWorkArea(     "Artículos", ( dbfArticulo )->( Select() ) )
   oFr:SetFieldAliases( "Artículos", cItemsToReport( aItmArt() ) )

   oFr:SetWorkArea(     "Familias", ( dbfFamilia )->( Select() ) )
   oFr:SetFieldAliases( "Familias", cItemsToReport( aItmFam() ) )

   oFr:SetWorkArea(     "Orden comanda", oTComandas:oDbf:nArea )
   oFr:SetFieldAliases( "Orden comanda", cObjectsToReport( oTComandas:oDbf ) )

   oFr:SetWorkArea(     "Unidades de medición",  oUndMedicion:Select() )
   oFr:SetFieldAliases( "Unidades de medición",  cObjectsToReport( oUndMedicion:oDbf ) )

   oFr:SetWorkArea(     "Categorías", ( dbfCategoria )->( Select() ) )
   oFr:SetFieldAliases( "Categorías", cItemsToReport( aItmCategoria() ) )

   oFr:SetWorkArea(     "Tipos de artículos",  oTipArt:Select() )
   oFr:SetFieldAliases( "Tipos de artículos",  cObjectsToReport( oTipArt:oDbf ) )

   oFr:SetWorkArea(     "Fabricantes",  oFabricante:Select() )
   oFr:SetFieldAliases( "Fabricantes",  cObjectsToReport( oFabricante:oDbf ) )

   oFr:SetWorkArea(     "Temporadas", ( dbfTemporada )->( Select() ) )
   oFr:SetFieldAliases( "Temporadas", cItemsToReport( aItmTemporada() ) )

Return nil 

//------------------------------------------------------------------------//

Static Function BuildRelationReport( oFr )

   oFr:SetWorkArea(     "Tickets", ( dbfTikT )->( Select() ), .f., { FR_RB_CURRENT, FR_RB_CURRENT, 0 } )

   oFr:SetMasterDetail( "Tickets", "Lineas de tickets",              {|| ( dbfTikT )->cSerTik + ( dbfTikT )->cNumTik + ( dbfTikT )->cSufTik } )
   oFr:SetMasterDetail( "Tickets", "Lineas de comandas",             {|| ( dbfTikT )->cSerTik + ( dbfTikT )->cNumTik + ( dbfTikT )->cSufTik } )
   oFr:SetMasterDetail( "Tickets", "Lineas de albaranes",            {|| ( dbfTikT )->cNumDoc } )
   oFr:SetMasterDetail( "Tickets", "Lineas de facturas",             {|| ( dbfTikT )->cNumDoc } )
   oFr:SetMasterDetail( "Tickets", "Pagos de tickets",               {|| ( dbfTikT )->cSerTik + ( dbfTikT )->cNumTik + ( dbfTikT )->cSufTik } )
   oFr:SetMasterDetail( "Tickets", "Empresa",                        {|| cCodigoEmpresaEnUso() } )
   oFr:SetMasterDetail( "Tickets", "Clientes",                       {|| ( dbfTikT )->cCliTik } )
   oFr:SetMasterDetail( "Tickets", "Obras",                          {|| ( dbfTikT )->cCliTik + ( dbfTikT )->cCodObr } )
   oFr:SetMasterDetail( "Tickets", "Almacen",                        {|| ( dbfTikT )->cAlmTik } )
   oFr:SetMasterDetail( "Tickets", "Rutas",                          {|| ( dbfTikT )->cCodRut } )
   oFr:SetMasterDetail( "Tickets", "Agentes",                        {|| ( dbfTikT )->cCodAge } )
   oFr:SetMasterDetail( "Tickets", "Usuarios",                       {|| ( dbfTikT )->cCcjTik } )
   oFr:SetMasterDetail( "Tickets", "SalaVenta",                      {|| ( dbfTikT )->cCodSala } )

   oFr:SetMasterDetail( "Lineas de tickets", "Artículos",            {|| ( dbfTikL )->cCbaTil } )
   oFr:SetMasterDetail( "Lineas de tickets", "Familia",              {|| ( dbfTikL )->cFamTil } )
   oFr:SetMasterDetail( "Lineas de tickets", "Orden comanda",        {|| ( dbfTikL )->cCodTImp } )
   oFr:SetMasterDetail( "Lineas de tickets", "Unidades de medición", {|| ( dbfTikL )->cUnidad } )
   oFr:SetMasterDetail( "Lineas de tickets", "Categorías",           {|| RetFld( ( dbfTikL )->cCbaTil, dbfArticulo, "cCodCate" ) } )
   oFr:SetMasterDetail( "Lineas de tickets", "Tipos de artículos",   {|| RetFld( ( dbfTikL )->cCbaTil, dbfArticulo, "cCodTip" ) } )
   oFr:SetMasterDetail( "Lineas de tickets", "Fabricantes",          {|| RetFld( ( dbfTikL )->cCbaTil, dbfArticulo, "cCodFab" ) } )
   oFr:SetMasterDetail( "Lineas de tickets", "Temporadas",           {|| RetFld( ( dbfTikL )->cCbaTil, dbfArticulo, "cCodTemp" ) } )

   oFr:SetMasterDetail( "Pagos de tickets",  "Formas de pago",       {|| ( dbfTikP )->cFpgPgo } )

   //------------------------------------------------------------------------//

   oFr:SetResyncPair(   "Tickets", "Lineas de tickets" )
   oFr:SetResyncPair(   "Tickets", "Lineas de comandas" )
   oFr:SetResyncPair(   "Tickets", "Lineas de albaranes" )
   oFr:SetResyncPair(   "Tickets", "Lineas de facturas" )
   oFr:SetResyncPair(   "Tickets", "Empresa" )
   oFr:SetResyncPair(   "Tickets", "Clientes" )
   oFr:SetResyncPair(   "Tickets", "Obras" )
   oFr:SetResyncPair(   "Tickets", "Almacenes" )
   oFr:SetResyncPair(   "Tickets", "Rutas" )
   oFr:SetResyncPair(   "Tickets", "Agentes" )
   oFr:SetResyncPair(   "Tickets", "Formas de pago" )
   oFr:SetResyncPair(   "Tickets", "Usuarios" )
   oFr:SetResyncPair(   "Tickets", "SalaVenta" )

   oFr:SetResyncPair(   "Lineas de tickets", "Artículos" )
   oFr:SetResyncPair(   "Lineas de tickets", "Familias" )
   oFr:SetResyncPair(   "Lineas de tickets", "Orden comanda" )
   oFr:SetResyncPair(   "Lineas de tickets", "Unidades de medición" )
   oFr:SetResyncPair(   "Lineas de tickets", "Categorías" )
   oFr:SetResyncPair(   "Lineas de tickets", "Tipos de artículos" )
   oFr:SetResyncPair(   "Lineas de tickets", "Fabricantes" )
   oFr:SetResyncPair(   "Lineas de tickets", "Temporadas" )

   oFr:SetResyncPair(   "Pagos de tickets", "Formas de pago" )

Return nil

//---------------------------------------------------------------------------//

Static Function ClearRelationReport( oFr )

   oFr:ClearMasterDetail( "Lineas de tickets" )
   oFr:ClearMasterDetail( "Lineas de comandas" )
   oFr:ClearMasterDetail( "Lineas de albaranes" )
   oFr:ClearMasterDetail( "Lineas de facturas" )
   oFr:ClearMasterDetail( "Pagos de tickets" )
   oFr:ClearMasterDetail( "Empresa" )
   oFr:ClearMasterDetail( "Clientes" )
   oFr:ClearMasterDetail( "Obras" )
   oFr:ClearMasterDetail( "Almacen" )
   oFr:ClearMasterDetail( "Rutas" )
   oFr:ClearMasterDetail( "Agentes" )
   oFr:ClearMasterDetail( "Usuarios" )
   oFr:ClearMasterDetail( "SalaVenta" )

   oFr:ClearMasterDetail( "Artículos" )
   oFr:ClearMasterDetail( "Familia" )
   oFr:ClearMasterDetail( "Orden comanda" )
   oFr:ClearMasterDetail( "Unidades de medición" )
   oFr:ClearMasterDetail( "Categorías" )
   oFr:ClearMasterDetail( "Tipos de artículos" )
   oFr:ClearMasterDetail( "Fabricantes" )
   oFr:ClearMasterDetail( "Temporadas" )

   oFr:ClearMasterDetail( "Formas de pago" )

   //------------------------------------------------------------------------//

   oFr:ClearResyncPair(   "Tickets", "Lineas de tickets" )
   oFr:ClearResyncPair(   "Tickets", "Lineas de comandas" )
   oFr:ClearResyncPair(   "Tickets", "Lineas de albaranes" )
   oFr:ClearResyncPair(   "Tickets", "Lineas de facturas" )
   oFr:ClearResyncPair(   "Tickets", "Empresa" )
   oFr:ClearResyncPair(   "Tickets", "Clientes" )
   oFr:ClearResyncPair(   "Tickets", "Obras" )
   oFr:ClearResyncPair(   "Tickets", "Almacenes" )
   oFr:ClearResyncPair(   "Tickets", "Rutas" )
   oFr:ClearResyncPair(   "Tickets", "Agentes" )
   oFr:ClearResyncPair(   "Tickets", "Formas de pago" )
   oFr:ClearResyncPair(   "Tickets", "Usuarios" )
   oFr:ClearResyncPair(   "Tickets", "SalaVenta" )

   oFr:ClearResyncPair(   "Lineas de tickets", "Artículos" )
   oFr:ClearResyncPair(   "Lineas de tickets", "Familias" )
   oFr:ClearResyncPair(   "Lineas de tickets", "Orden comanda" )
   oFr:ClearResyncPair(   "Lineas de tickets", "Unidades de medición" )
   oFr:ClearResyncPair(   "Lineas de tickets", "Categorías" )
   oFr:ClearResyncPair(   "Lineas de tickets", "Tipos de artículos" )
   oFr:ClearResyncPair(   "Lineas de tickets", "Fabricantes" )
   oFr:ClearResyncPair(   "Lineas de tickets", "Temporadas" )

   oFr:ClearResyncPair(   "Pagos de tickets", "Formas de pago" )

Return nil

//---------------------------------------------------------------------------//

Static Function VariableReport( oFr )

   /*
   Creación de variables----------------------------------------------------
   */

   oFr:AddVariable(     "Tickets",             "Total ticket",                            "GetHbVar('nTotTik')" )
   oFr:AddVariable(     "Tickets",             "Total bruto",                             "GetHbVar('nTotBrt')" )
   oFr:AddVariable(     "Tickets",             "Total neto",                              "GetHbVar('nTotNet')" )
   oFr:AddVariable(     "Tickets",             "Total " + cImp(),                         "GetHbVar('nTotIva')" )
   oFr:AddVariable(     "Tickets",             "Total IVM",                               "GetHbVar('nTotIvm')" )
   oFr:AddVariable(     "Tickets",             "Total albarán",                           "GetHbVar('nTotAlb')" )
   oFr:AddVariable(     "Tickets",             "Total factura",                           "GetHbVar('nTotFac')" )
   oFr:AddVariable(     "Tickets",             "Precio por pax.",                         "GetHbVar('nTotPax')" )
   oFr:AddVariable(     "Tickets",             "Total descuento general",                 "GetHbVar('nTotDtoEsp')" )
   oFr:AddVariable(     "Tickets",             "Total descuento pronto pago",             "GetHbVar('nTotDpp')" )
   oFr:AddVariable(     "Tickets",             "Cuenta por defecto del cliente",          "GetHbVar('cCtaCli')" )

   oFr:AddVariable(     "Tickets",             "Bruto primer tipo de " + cImp(),          "GetHbArrayVar('aBrtTik',1)" )
   oFr:AddVariable(     "Tickets",             "Bruto segundo tipo de " + cImp(),         "GetHbArrayVar('aBrtTik',2)" )
   oFr:AddVariable(     "Tickets",             "Bruto tercer tipo de " + cImp(),          "GetHbArrayVar('aBrtTik',3)" )
   oFr:AddVariable(     "Tickets",             "Base primer tipo de " + cImp(),           "GetHbArrayVar('aBasTik',1)" )
   oFr:AddVariable(     "Tickets",             "Base segundo tipo de " + cImp(),          "GetHbArrayVar('aBasTik',2)" )
   oFr:AddVariable(     "Tickets",             "Base tercer tipo de " + cImp(),           "GetHbArrayVar('aBasTik',3)" )
   oFr:AddVariable(     "Tickets",             "Porcentaje primer tipo " + cImp(),        "GetHbArrayVar('aIvaTik',1)" )
   oFr:AddVariable(     "Tickets",             "Porcentaje segundo tipo " + cImp(),       "GetHbArrayVar('aIvaTik',2)" )
   oFr:AddVariable(     "Tickets",             "Porcentaje tercer tipo " + cImp(),        "GetHbArrayVar('aIvaTik',3)" )
   oFr:AddVariable(     "Tickets",             "Importe primer tipo " + cImp(),           "GetHbArrayVar('aImpTik',1)" )
   oFr:AddVariable(     "Tickets",             "Importe segundo tipo " + cImp(),          "GetHbArrayVar('aImpTik',2)" )
   oFr:AddVariable(     "Tickets",             "Importe tercer tipo " + cImp(),           "GetHbArrayVar('aImpTik',3)" )
   oFr:AddVariable(     "Tickets",             "Importe primer tipo IVMH",                "GetHbArrayVar('aIvmTik',1)" )
   oFr:AddVariable(     "Tickets",             "Importe segundo tipo IVMH",               "GetHbArrayVar('aIvmTik',2)" )
   oFr:AddVariable(     "Tickets",             "Importe tercer tipo IVMH",                "GetHbArrayVar('aIvmTik',3)" )

   oFr:AddVariable(     "Tickets",             "Total vale en compra",                    "CallHbFunc('nImpValTik')" )
   oFr:AddVariable(     "Tickets",             "Total vales acumulados cliente",          "CallHbFunc('nImpValCli')" )
   oFr:AddVariable(     "Tickets",             "Total entregas a cuenta",                 "CallHbFunc('nTotalEntregado')" )
   oFr:AddVariable(     "Tickets",             "Total vales liquidados en compra",        "CallHbFunc('nTotValTikInfo')" )

   oFr:AddVariable(     "Tickets",             "Ubicación del ticket",                    "CallHbFunc( 'oTpvTactil', [ 'cTxtUbicacion()' ] )" )

   oFr:AddVariable(     "Lineas de tickets",   "Total unidades artículo",                       "CallHbFunc('nTotNTpv')" )
   oFr:AddVariable(     "Lineas de tickets",   "Precio unitario del artículo",                  "CallHbFunc('nTotUTpv')" )
   oFr:AddVariable(     "Lineas de tickets",   "Precio unitario con descuentos",                "CallHbFunc('nNetLTpv')" )
   oFr:AddVariable(     "Lineas de tickets",   "Importe descuento línea del factura",           "CallHbFunc('nDtoUTpv')" )
   oFr:AddVariable(     "Lineas de tickets",   "Total " + cImp() + " línea de factura",         "CallHbFunc('nIvaLTpv')" )
   oFr:AddVariable(     "Lineas de tickets",   "Total IVMH línea de factura",                   "CallHbFunc('nIvmLTpv')" )
   oFr:AddVariable(     "Lineas de tickets",   "Total línea de factura",                        "CallHbFunc('nTotLTpv')" )

   oFr:AddVariable(     "Lineas de comandas",  "Total unidades en comanda",                     "CallHbFunc( 'oTpvTactil', [ 'nUnidadesLineaComanda()' ] )" )
   oFr:AddVariable(     "Lineas de comandas",  "Total unidades impresas en comanda",            "CallHbFunc( 'oTpvTactil', [ 'nUnidadesImpresasComanda()' ] )" )
   oFr:AddVariable(     "Lineas de comandas",  "Detalle del artículo en comanda",               "CallHbFunc( 'oTpvTactil', [ 'cDescripcionComanda()' ] )" )

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

   local lCloseFiles := !lOpenFiles

   if lOpenFiles .or. OpenFiles()

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

         oFr:AddBand(         "CabeceraColumnas",  "MainPage", frxMasterData )
         oFr:SetProperty(     "CabeceraColumnas",  "Top", 200 )
         oFr:SetProperty(     "CabeceraColumnas",  "Height", 0 )
         oFr:SetProperty(     "CabeceraColumnas",  "StartNewPage", .t. )
         oFr:SetObjProperty(  "CabeceraColumnas",  "DataSet", "Tickets" )

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

      BuildRelationReport( oFr )

      /*
      Diseño de report---------------------------------------------------------
      */

      oFr:DesignReport()

      /*
      Destruye el diseñador----------------------------------------------------
      */

      ClearRelationReport( oFr )

      oFr:DestroyFr()

      /*
      Cierra ficheros----------------------------------------------------------
      */

      if lCloseFiles
         CloseFiles()
      end if

   else

      return .f.

   end if

Return .t.

//---------------------------------------------------------------------------//

Function PrintReportTikCli( nDevice, nCopies, cPrinter )

   DEFAULT nDevice      := IS_SCREEN
   DEFAULT nCopies      := 1
   DEFAULT cPrinter     := PrnGetName()

   SysRefresh()

   /*
   Creamos las relaciones------------------------------------------------------
   */

   BuildRelationReport( oFr )

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

            oFr:SetProperty(  "PDFExport", "EmbeddedFonts",    .t. )
            oFr:SetProperty(  "PDFExport", "PrintOptimized",   .t. )
            oFr:SetProperty(  "PDFExport", "Outline",          .t. )
            oFr:DoExport(     "PDFExport" )

      end case

   end if

   /*
   Destruye el diseñador-------------------------------------------------------
   */

   ClearRelationReport( oFr )

Return .t.

//---------------------------------------------------------------------------//
/*
Funciones que llaman a funciones de albaranes y facturas
creadas para que se puedan llamar desde fuera, ya que
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

function cTpvDesCmd( cTikL )

   local cReturn     := ""

   DEFAULT cTikL     := dbfTikL

   if !Empty( ( cTikL )->cNomCmd )
      cReturn        := Rtrim( ( cTikL )->cNomCmd )
   else
      cReturn        := Rtrim( ( cTikL )->cNomTil )
   end if

RETURN ( cReturn )

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
   local oGetImpresora
   local cGetImpresora     := Space( 254 )

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

      REDEFINE GET oGetImpresora ;
         VAR      cGetImpresora ;
         ID       160 ;
         OF       oDlg

      REDEFINE BUTTONBMP ;
         ID       170 ;
         OF       oDlg ;
         BITMAP   "Lupa_32" ;
         ACTION   ( BrwTipoImpresora( oGetImpresora, .t. ) )

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
         ( dbfTmpL )->cNomTil    := cGetDescripcion
         ( dbfTmpL )->nUntTil    := nGetUnidades
         ( dbfTmpL )->nPvpTil    := nGetImporte
         ( dbfTmpL )->nIvaTil    := nIva( dbfIva, cDefIva() )
         ( dbfTmpL )->cAlmLin    := oUser():cAlmacen()
         ( dbfTmpL )->cImpCom1   := cGetImpresora
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

   local cNombreUbicacion  := VirtualKey( .f., aTmp[ _CALIASTIK ], "Asignar alias" )

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

      oBtnTodasLineas   := ApoloBtnBmp():ReDefine( 100, "Row_All_32",,,,,{|| oBtnUnaLinea:GoUp(), oBtnTodasLineas:GoDown() }, oDlg, .f., , .f. )

      oBtnUnaLinea      := ApoloBtnBmp():ReDefine( 110, "Row_32",,,,,{|| oBtnUnaLinea:GoDown(), oBtnTodasLineas:GoUp() }, oDlg, .f., , .f. )

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

Function SynTikCli( cPath )

   local oBlock
   local oError
   local aTotTik
   local aTotAlb
   local aTotFac

   DEFAULT cPath     := cPatEmp()

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   USE ( cPath + "TIKET.DBF" )         NEW VIA ( cDriver() ) ALIAS ( cCheckArea( "TIKET", @dbfTikT ) ) EXCLUSIVE
   SET ADSINDEX TO ( cPath + "TIKET.CDX" ) ADDITIVE

   USE ( cPath + "TIKEL.DBF" )         NEW VIA ( cDriver() ) ALIAS ( cCheckArea( "TIKEL", @dbfTikL ) ) EXCLUSIVE
   SET ADSINDEX TO ( cPath + "TIKEL.CDX" ) ADDITIVE

   USE ( cPath + "TIKEP.DBF" )         NEW VIA ( cDriver() ) ALIAS ( cCheckArea( "TIKEP", @dbfTikP ) ) EXCLUSIVE
   SET ADSINDEX TO ( cPath + "TIKEP.CDX" ) ADDITIVE

   USE ( cPath + "TIKES.DBF" )         NEW VIA ( cDriver() ) ALIAS ( cCheckArea( "TIKES", @dbfTikS ) ) EXCLUSIVE
   SET ADSINDEX TO ( cPath + "TIKES.CDX" ) ADDITIVE

   USE ( cPatGrp() + "FAMILIAS.DBF" )  NEW VIA ( cDriver() ) ALIAS ( cCheckArea( "FAMILIAS", @dbfFamilia ) ) EXCLUSIVE
   SET ADSINDEX TO ( cPatGrp() + "FAMILIAS.CDX" ) ADDITIVE

   USE ( cPatArt() + "ARTICULO.DBF" )  NEW VIA ( cDriver() ) ALIAS ( cCheckArea( "ARTICULO", @dbfArticulo ) ) EXCLUSIVE
   SET ADSINDEX TO ( cPatArt() + "ARTICULO.CDX" ) ADDITIVE

   USE ( cPatDat() + "TBLCNV.DBF" )    NEW VIA ( cDriver() ) ALIAS ( cCheckArea( "TBLCNV", @dbfTblCnv ) ) EXCLUSIVE
   SET ADSINDEX TO ( cPatDat() + "TBLCNV.CDX" ) ADDITIVE

   USE ( cPatEmp() + "FACCLIT.DBF" )   NEW VIA ( cDriver() ) ALIAS ( cCheckArea( "FACCLIT", @dbfFacCliT ) ) EXCLUSIVE
   SET ADSINDEX TO ( cPatEmp() + "FACCLIT.CDX" ) ADDITIVE

   USE ( cPatEmp() + "FACCLIL.DBF" )   NEW VIA ( cDriver() ) ALIAS ( cCheckArea( "FACCLIL", @dbfFacCliL ) ) EXCLUSIVE
   SET ADSINDEX TO ( cPatEmp() + "FACCLIL.CDX" ) ADDITIVE

   USE ( cPatEmp() + "FACCLIP.DBF" )   NEW VIA ( cDriver() ) ALIAS ( cCheckArea( "FACCLIP", @dbfFacCliP ) ) EXCLUSIVE
   SET ADSINDEX TO ( cPatEmp() + "FACCLIP.CDX" ) ADDITIVE

   USE ( cPatEmp() + "AntCliT.DBF" )   NEW VIA ( cDriver() ) ALIAS ( cCheckArea( "AntCliT", @dbfAntCliT ) ) SHARED
   SET ADSINDEX TO ( cPatEmp() + "AntCliT.CDX" ) ADDITIVE

   USE ( cPatEmp() + "ALBCLIT.DBF" )   NEW VIA ( cDriver() ) ALIAS ( cCheckArea( "ALBCLIT", @dbfAlbCliT ) ) EXCLUSIVE
   SET ADSINDEX TO ( cPatEmp() + "ALBCLIT.CDX" ) ADDITIVE

   USE ( cPatEmp() + "ALBCLIL.DBF" )   NEW VIA ( cDriver() ) ALIAS ( cCheckArea( "ALBCLIL", @dbfAlbCliL ) ) EXCLUSIVE
   SET ADSINDEX TO ( cPatEmp() + "ALBCLIL.CDX" ) ADDITIVE

   USE ( cPatDat() + "DIVISAS.DBF" )   NEW VIA ( cDriver() ) ALIAS ( cCheckArea( "DIVISAS", @dbfDiv ) ) SHARED
   SET ADSINDEX TO ( cPatDat() + "DIVISAS.CDX" ) ADDITIVE

   USE ( cPatDat() + "TIVA.DBF" )      NEW VIA ( cDriver() ) ALIAS ( cCheckArea( "TIVA", @dbfIva ) ) SHARED
   SET ADSINDEX TO ( cPatDat() + "TIVA.CDX" ) ADDITIVE

   /*
   Cabeceras-------------------------------------------------------------------
   */

   ( dbfTikT )->( OrdSetFocus( 0 ) )
   ( dbfTikT )->( dbGoTop() )

   while !( dbfTikT )->( eof() )

      if Empty( ( dbfTikT )->cSufTik )
         ( dbfTikT )->cSufTik := "00"
      end if

      if !Empty( ( dbfTikT )->cNumDoc ) .and. Len( AllTrim( ( dbfTikT )->cNumDoc ) ) != 12
         ( dbfTikT )->cNumDoc := AllTrim( ( dbfTikT )->cNumDoc ) + "00"
      end if

      if !Empty( ( dbfTikT )->cAlbTik ) .and. Len( AllTrim( ( dbfTikT )->cAlbTik ) ) != 12
         ( dbfTikT )->cAlbTik := AllTrim( ( dbfTikT )->cAlbTik ) + "00"
      end if

      if !Empty( ( dbfTikT )->cPedTik ) .and. Len( AllTrim( ( dbfTikT )->cPedTik ) ) != 12
         ( dbfTikT )->cPedTik := AllTrim( ( dbfTikT )->cPedTik ) + "00"
      end if

      if !Empty( ( dbfTikT )->cPreTik ) .and. Len( AllTrim( ( dbfTikT )->cPreTik ) ) != 12
         ( dbfTikT )->cPreTik := AllTrim( ( dbfTikT )->cPreTik ) + "00"
      end if

      if !Empty( ( dbfTikT )->cTikVal ) .and. Len( AllTrim( ( dbfTikT )->cTikVal ) ) != 13
         ( dbfTikT )->cTikVal := AllTrim( ( dbfTikT )->cTikVal ) + "00"
      end if

      if Empty( ( dbfTikT )->cNcjTik )
         ( dbfTikT )->cNcjTik := "000"
      end if

      ( dbfTikT )->( dbSkip() )

      SysRefresh()

   end while

   ( dbfTikT )->( OrdSetFocus( 1 ) )

   /*
   Pagos-------------------------------------------------------------------
   */

   ( dbfTikP )->( OrdSetFocus( 0 ) )
   ( dbfTikP )->( dbGoTop() )

   while !( dbfTikP )->( eof() )

      if Empty( ( dbfTikP )->cSufTik )
         ( dbfTikP )->cSufTik := "00"
      end if

      if Empty( ( dbfTikP )->cCodCaj )
         ( dbfTikP )->cCodCaj := oUser():cCaja()
      end if

      ( dbfTikP )->( dbSkip() )

      SysRefresh()

   end while

   ( dbfTikT )->( OrdSetFocus( 1 ) )

   /*
   Lineas-------------------------------------------------------------------
   */

   ( dbfTikL )->( OrdSetFocus( 0 ) )
   ( dbfTikL )->( dbGoTop() )

   while !( dbfTikL )->( eof() )

      if Empty( ( dbfTikL )->cSufTil )
         ( dbfTikL )->cSufTil := "00"
      end if

      if !Empty( ( dbfTikL )->cNumDev ) .and. Len( AllTrim( ( dbfTikL )->cNumDev ) ) != 13
         ( dbfTikL )->cNumDev := AllTrim( ( dbfTikL )->cNumDev ) + "00"
      end if

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
         ( dbfTikL )->cAlmLin := RetFld( ( dbfTikL )->cSerTil + ( dbfTikL )->cNumTil + ( dbfTikL )->cSufTil, dbfTikT, "cAlmTik" )
      end if

      if ( dbfTikL )->cTipTil != RetFld( ( dbfTikL )->cSerTil + ( dbfTikL )->cNumTil + ( dbfTikL )->cSufTil, dbfTikT, "cTipTik" )
         ( dbfTikL )->cTipTil := RetFld( ( dbfTikL )->cSerTil + ( dbfTikL )->cNumTil + ( dbfTikL )->cSufTil, dbfTikT, "cTipTik" )
      end if

      if ( dbfTikL )->dFecTik != RetFld( ( dbfTikL )->cSerTil + ( dbfTikL )->cNumTil + ( dbfTikL )->cSufTil, dbfTikT, "dFecTik" )
         ( dbfTikL )->dFecTik := RetFld( ( dbfTikL )->cSerTil + ( dbfTikL )->cNumTil + ( dbfTikL )->cSufTil, dbfTikT, "dFecTik" )
      end if

      ( dbfTikL )->( dbSkip() )

      SysRefresh()

   end while

   ( dbfTikL )->( OrdSetFocus( 1 ) )

   // Series ------------------------------------------------------------------

   ( dbfTikS )->( OrdSetFocus( 0 ) )
   ( dbfTikS )->( dbGoTop() )

   while !( dbfTikS )->( eof() )

      if Empty( ( dbfTikS )->cSufTik )
         ( dbfTikS )->cSufTik := "00"
      end if

      if ( dbfTikS )->dFecTik != RetFld( ( dbfTikS )->cSerTik + ( dbfTikS )->cNumTik + ( dbfTikS )->cSufTik, dbfTikT, "dFecTik" )
         ( dbfTikS )->dFecTik := RetFld( ( dbfTikS )->cSerTik + ( dbfTikS )->cNumTik + ( dbfTikS )->cSufTik, dbfTikT, "dFecTik" )
      end if

      ( dbfTikS )->( dbSkip() )

      SysRefresh()

   end while

   ( dbfTikS )->( OrdSetFocus( 1 ) )

   /*
   Repasamos los totales para que tengas valores---------------------------
   */

   ( dbfTikT )->( dbGoTop() )

   while !( dbfTikT )->( eof() )

      do case
         case ( dbfTikT )->cTipTik == SAVALB

            if dbSeekInOrd( ( dbfTikT )->cNumDoc, "nNumAlb", dbfAlbCliT )

               aTotAlb  := aTotAlbCli( ( dbfAlbCliT )->cSerAlb + Str( ( dbfAlbCliT )->nNumAlb ) + ( dbfAlbCliT )->cSufAlb, dbfAlbCliT, dbfAlbCliL, dbfIva, dbfDiv, ( dbfAlbCliT )->cDivAlb )

               if ( ( dbfTikT )->nTotNet != aTotAlb[1] .or. ( dbfTikT )->nTotIva != aTotAlb[2] .or. ( dbfTikT )->nTotTik != aTotAlb[4] )

                  ( dbfTikT )->nTotNet := aTotAlb[1]
                  ( dbfTikT )->nTotIva := aTotAlb[2]
                  ( dbfTikT )->nTotTik := aTotAlb[4]

               end if

            end if

         case ( dbfTikT )->cTipTik == SAVFAC

            if dbSeekInOrd( ( dbfTikT )->cNumDoc, "nNumFac", dbfFacCliT )

               aTotFac  := aTotFacCli( ( dbfFacCliT )->cSerie + Str( ( dbfFacCliT )->nNumFac ) + ( dbfFacCliT )->cSufFac, dbfFacCliT, dbfFacCliL, dbfIva, dbfDiv, dbfFacCliP, dbfAntCliT, ( dbfFacCliT )->cDivFac )

               if ( dbfTikT )->nTotNet != aTotFac[1] .or. ( dbfTikT )->nTotIva != aTotFac[2] .or. ( dbfTikT )->nTotTik != aTotFac[4]

                  ( dbfTikT )->nTotNet := aTotFac[1]
                  ( dbfTikT )->nTotIva := aTotFac[2]
                  ( dbfTikT )->nTotTik := aTotFac[4]

               end if

            end if

         otherwise

            aTotTik     := aTotTik( ( dbfTikT )->cSerTik + ( dbfTikT )->cNumTik + ( dbfTikT )->cSufTik, dbfTikT, dbfTikL, dbfDiv, , ( dbfTikT )->cDivTik )

            if ( dbfTikT )->nTotNet != aTotTik[1] .or. ( dbfTikT )->nTotIva != aTotTik[2] .or. ( dbfTikT )->nTotTik != aTotTik[3]

               ( dbfTikT )->nTotNet    := aTotTik[1]
               ( dbfTikT )->nTotIva    := aTotTik[2]
               ( dbfTikT )->nTotTik    := aTotTik[3]

            end if

            aTotTik     := nTotCobTik( ( dbfTikT )->cSerTik + ( dbfTikT )->cNumTik + ( dbfTikT )->cSufTik, dbfTikP, dbfDiv )
            aTotTik     += nTotValTik( ( dbfTikT )->cSerTik + ( dbfTikT )->cNumTik + ( dbfTikT )->cSufTik, dbfTikT, dbfTikL, dbfDiv )

            if ( dbfTikT )->nCobTik != aTotTik
               ( dbfTikT )->nCobTik    := aTotTik
            end if

      end case

      ( dbfTikT )->( dbSkip() )

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

   if !Empty( dbfTikS ) .and. ( dbfTikS )->( Used() )
      ( dbfTikS )->( dbCloseArea() )
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

   if !Empty( dbfDiv ) .and. ( dbfDiv )->( Used() )
      ( dbfDiv )->( dbCloseArea() )
   end if

   if !Empty( dbfFacCliT ) .and. ( dbfFacCliT )->( Used() )
      ( dbfFacCliT )->( dbCloseArea() )
   end if

   if !Empty( dbfFacCliL ) .and. ( dbfFacCliL )->( Used() )
      ( dbfFacCliL )->( dbCloseArea() )
   end if

   if !Empty( dbfFacCliP ) .and. ( dbfFacCliP )->( Used() )
      ( dbfFacCliP )->( dbCloseArea() )
   end if

   if !Empty( dbfAntCliT ) .and. ( dbfAntCliT )->( Used() )
      ( dbfAntCliT )->( dbCloseArea() )
   end if

   if !Empty( dbfIva ) .and. ( dbfIva )->( Used() )
      ( dbfIva )->( dbCloseArea() )
   end if

   if !Empty( dbfAlbCliT ) .and. ( dbfAlbCliT )->( Used() )
      ( dbfAlbCliT )->( dbCloseArea() )
   end if

   if !Empty( dbfAlbCliL ) .and. ( dbfAlbCliL )->( Used() )
      ( dbfAlbCliL )->( dbCloseArea() )
   end if

return nil

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

   if ( dbfTmpL )->( ordKeyCount() ) != 0
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

            ( dbfTmpL )->cImpCom1   := Retfld( ( dbfPedCliL )->cRef, dbfArticulo, "cTipImp1" )
            ( dbfTmpL )->cImpCom2   := Retfld( ( dbfPedCliL )->cRef, dbfArticulo, "cTipImp2" )

            ( dbfPedCLiL )->( dbSkip() )

         end while

      end if

      oBrwDet:Refresh()

      lRecTotal( aTmp )

   end if

Return nil

//---------------------------------------------------------------------------//

Function ComentariosTPV( aGet, aTmp, dbfTmpL, cDefCom )

   local oError
   local oBlock
   local oGetComentario
   local cGetComentario
   local oCbxOrd
   local cNumPed
   local obrwComentarios
   local obrwLineasComentarios
   local oDlgComentarios
   local dbfComentariosT
   local dbfComentariosL
   local oFntDlg

   if ( dbfTmpL )->( ordKeyCount() ) == 0
      MsgStop( "No puede añadir un comentario." )
      return .f.
   end if

   oFntDlg              := TFont():New( FONT_NAME, 12, 32, .F., .T.,  )

   cGetComentario       := ( dbfTmpL )->cComent

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      USE ( cPatEmp() + "COMENTARIOST.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "COMENT", @dbfComentariosT ) )
      SET ADSINDEX TO ( cPatEmp() + "COMENTARIOST.CDX" ) ADDITIVE
      ( dbfComentariosT )->( OrdSetFocus( "cCodigo" ) )

      USE ( cPatEmp() + "COMENTARIOSL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "COMENL", @dbfComentariosL ) )
      SET ADSINDEX TO ( cPatEmp() + "COMENTARIOSL.CDX" ) ADDITIVE
      ( dbfComentariosL )->( OrdSetFocus( "cCodDes" ) )

      DEFINE DIALOG oDlgComentarios RESOURCE "COMENTARIOS_TPV"

      REDEFINE GET oGetComentario VAR cGetComentario ;
         ID       150;
         FONT     oFntDlg ;
         OF       oDlgComentarios

      REDEFINE BUTTONBMP ;
         ID       160 ;
         OF       oDlgComentarios ;
         BITMAP   "Keyboard2_32" ;
         ACTION   ( VirtualKey( .f., oGetComentario ) )

      REDEFINE BUTTONBMP ;
         ID       170 ;
         OF       oDlgComentarios ;
         BITMAP   "Up32" ;
         ACTION   ( obrwComentarios:Select( 0 ), oBrwComentarios:GoUp(), obrwComentarios:Select( 1 ) )

      REDEFINE BUTTONBMP ;
         ID       171 ;
         OF       oDlgComentarios ;
         BITMAP   "Down32" ;
         ACTION   ( obrwComentarios:Select( 0 ), oBrwComentarios:GoDown(), obrwComentarios:Select( 1 ) )

      REDEFINE BUTTONBMP ;
         ID       180 ;
         OF       oDlgComentarios ;
         BITMAP   "arrow_up_blue" ;
         ACTION   ( oBrwLineasComentarios:Select( 0 ), oBrwLineasComentarios:GoUp(), oBrwLineasComentarios:Select( 1 ) )

      REDEFINE BUTTONBMP ;
         ID       181 ;
         OF       oDlgComentarios ;
         BITMAP   "arrow_down_blue" ;
         ACTION   (oBrwLineasComentarios:Select( 0 ), oBrwLineasComentarios:GoDown(), oBrwLineasComentarios:Select( 1 ) )

      REDEFINE BUTTONBMP ;
         ID       IDOK ;
         OF       oDlgComentarios ;
         ACTION   ( EndComentario( oDlgComentarios, dbfTmpL, oGetComentario ) )

      REDEFINE BUTTONBMP ;
         ID       IDCANCEL ;
         OF       oDlgComentarios ;
         ACTION   ( oDlgComentarios:End() )

      oBrwComentarios                  := IXBrowse():New( oDlgComentarios )

      obrwComentarios:bClrSel          := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      obrwComentarios:bClrSelFocus     := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      obrwComentarios:cAlias           := dbfComentariosT
      obrwComentarios:nMarqueeStyle    := 6
      obrwComentarios:cName            := "Comentarios de artículos"
      obrwComentarios:nRowHeight       := 40
      oBrwComentarios:lHeader          := .f.
      oBrwComentarios:lHScroll         := .f.

      obrwComentarios:CreateFromResource( 100 )

      obrwComentarios:bChange         := {|| ChangeComentarios( dbfComentariosT, dbfComentariosL, oBrwLineasComentarios ) }

      with object ( oBrwComentarios:AddCol() )
         :cSortOrder       := "cCodigo"
         :bEditValue       := {|| ( dbfComentariosT )->cDescri }
      end with

      oBrwLineasComentarios                  := IXBrowse():New( oDlgComentarios )

      oBrwLineasComentarios:bClrSel          := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwLineasComentarios:bClrSelFocus     := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrwLineasComentarios:cAlias           := dbfComentariosL
      oBrwLineasComentarios:nMarqueeStyle    := 6
      oBrwLineasComentarios:cName            := "Lineas comentarios de artículos"
      oBrwLineasComentarios:nRowHeight       := 40
      oBrwLineasComentarios:lHeader          := .f.
      oBrwLineasComentarios:lHScroll         := .f.

      oBrwLineasComentarios:CreateFromResource( 110 )

      with object ( oBrwLineasComentarios:AddCol() )
         :bEditValue          := {|| ( dbfComentariosL )->cDescri }
      end with

      oBrwLineasComentarios:bLClicked := {|| ChangeLineasComentarios( oGetComentario, dbfComentariosL ) }

      oDlgComentarios:bStart          := {|| SeleccionarDefecto( cDefCom, dbfComentariosT, dbfComentariosL, oBrwLineasComentarios, oBrwComentarios ) }

      ACTIVATE DIALOG oDlgComentarios CENTER

   RECOVER USING oError

      msgStop( 'Imposible abrir ficheros de comentarios de artículos' + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   CLOSE ( dbfComentariosT )
   CLOSE ( dbfComentariosL )

Return ( nil )

//---------------------------------------------------------------------------//

static function SeleccionarDefecto( cDefCom, dbfComentariosT, dbfComentariosL, oBrwLineasComentarios, oBrwComentarios )

   if !Empty( cDefCom )

      if ( dbfComentariosT )->( dbSeek( cDefCom ) )

         oBrwComentarios:Select( 0 )
         oBrwComentarios:Select( 1 )
         ChangeComentarios( dbfComentariosT, dbfComentariosL, oBrwLineasComentarios )

      end if

   end if

return .t.

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

   local cCliente       := BrwCliTactil( nil, nil, nil, .t. )

   aTmp[ _CCLITIK  ]    := cCliente

   aTmp[ _CNOMTIK  ]    := RetFld( cCliente, dbfClient, "Titulo" )
   aTmp[ _CDIRCLI  ]    := RetFld( cCliente, dbfClient, "Domicilio" )
   aTmp[ _CPOBCLI  ]    := RetFld( cCliente, dbfClient, "Poblacion" )
   aTmp[ _CPRVCLI  ]    := RetFld( cCliente, dbfClient, "Provincia" )
   aTmp[ _CPOSCLI  ]    := RetFld( cCliente, dbfClient, "CodPostal" )
   aTmp[ _CDNICLI  ]    := RetFld( cCliente, dbfClient, "Nif" )
   aTmp[ _NTARIFA  ]    := Max( RetFld( cCliente, dbfClient, "nTarifa" ), 1 )

   cTextoOfficeBar( aTmp )

Return .t.

//---------------------------------------------------------------------------//

static function lNumeroComensales( aTmp )

   aTmp[ _NNUMCOM ]     := nVirtualNumKey( "Users1_32", "Número comensales" )

   lRecTotal( aTmp )

Return .t.

//---------------------------------------------------------------------------//

Static Function lCambiaTicket( lSubir, aTmp, aGet, nMode )

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

      if ( dbfTikT )->( OrdKeyno() ) == ( dbfTikT )->( OrdKeyCount() )
         MsgStop( "Ya estas en el último registro" )
         return nil
      end if

   end if

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   nSaveMode            := EDIT_MODE

   /*
   Subo o bajo un registro-----------------------------------------------------
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

   BeginTrans( aTmp, aGet, nMode, .f. )

   /*
   Titulo de la ventana-----------------------------------------------------
   */

   cTitleDialog( aTmp )

   /*
   Botones de la ventana de tpv---------------------------------------------
   */

   SetButtonEdtRec( nSaveMode, aTmp )

   /*
   Recalculamos el total----------------------------------------------------
   */

   lRecTotal( aTmp )

   /*
   Cargamos y refrescamos datos del cliente------------------------------
   */

   cOldCodCli        := ""

   if !Empty( aGet[ _CCLITIK ] )
      aGet[ _CCLITIK ]:SetFocus()
      aGet[ _CCLITIK ]:lValid()
   end if

   RECOVER USING oError

   msgStop( ErrorMessage( oError ), "Error al cambiar de ticket" )

   END SEQUENCE

   ErrorBlock( oBlock )

Return .t.

//---------------------------------------------------------------------------//

Static Function lCambiaSerie( aTmp, lSubir, oGrupoSerie )

   if lSubir
      aTmp[ _CSERTIK ]        := cUpSerie( aTmp[ _CSERTIK ] )
      oGrupoSerie:cPrompt     := "Serie: " + aTmp[ _CSERTIK ]
   else
      aTmp[ _CSERTIK ]        := cDwSerie( aTmp[ _CSERTIK ] )
      oGrupoSerie:cPrompt     := "Serie: " + aTmp[ _CSERTIK ]
   end if

Return .t.

//---------------------------------------------------------------------------//

Function ImprimirTiketPda()

Return nil 

//---------------------------------------------------------------------------//

Function SetAutoImp()

   local nSecondTime

   if Empty( oTimer )

      nSecondTime    := uFieldEmpresa( "nTiempoImp", 0 )

      if nSecondTime != 0
         oTimer      := TTimer():New( nSecondTime * 1000, {|| ImprimirTiketPda() } )
         oTimer:Activate()
      end if

   end if

Return nil

//---------------------------------------------------------------------------//

Function KillAutoImp()

   if !Empty( oTimer )
      oTimer:End()
   end if

   oTimer         := nil

Return( nil )

//---------------------------------------------------------------------------//

Function StartAutoImp()

   if !Empty( oTimer )
      oTimer:Activate()
   end if

Return( nil )

//---------------------------------------------------------------------------//

Function StopAutoImp()

   if !Empty( oTimer )
      oTimer:DeActivate()
   end if

Return( nil )

//---------------------------------------------------------------------------//

Function pdaAbrirTablas()

   local oError
   local oBlock
   local cPcName     := AllTrim( cNombrePC() ) + "Emp" + Alltrim( cCodigoEmpresa() ) + "\"
   local lOpenFile   := .t.

   cPatPc( cPcName )

   oBlock                  := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      dbUseArea( .t., cDriver(), cPatPc() + "TIKET.Dbf", cCheckArea( "TIKET", @dbfTikT ), .t. )
      ( dbfTikT )->( ordListAdd( cPatPc() + "TIKET.Cdx" ) )

      dbUseArea( .t., cDriver(), cPatPc() + "TIKEL.Dbf", cCheckArea( "TIKEL", @dbfTikL ), .t. )
      ( dbfTikL )->( ordListAdd( cPatPc() + "TIKEL.Cdx" ) )

      dbUseArea( .t., cDriver(), cPatPc() + "TIKEP.Dbf", cCheckArea( "TIKEP", @dbfTikP ), .t. )
      ( dbfTikP )->( ordListAdd( cPatPc() + "TIKEP.Cdx" ) )

      dbUseArea( .t., cDriver(), cPatPc() + "NCOUNT.Dbf", cCheckArea( "DBFCOUNT", @dbfCount ), .t. )
      ( dbfCount )->( ordListAdd( cPatPc() + "NCOUNT.Cdx" ) )

      dbUseArea( .t., cDriver(), cPatPc() + "TIKETIMP.Dbf", cCheckArea( "TIKETIMP", @dbfImp ), .t. )
      ( dbfImp )->( ordListAdd( cPatPc() + "TIKETIMP.Cdx" ) )

      dbUseArea( .t., cDriver(), cPatPc() + "COMENTARIOST.Dbf", cCheckArea( "COMENT", @dbfComentariosT ), .t. )
      ( dbfComentariosT )->( ordListAdd( cPatPc() + "COMENTARIOST.Cdx" ) )

      dbUseArea( .t., cDriver(), cPatPc() + "COMENTARIOSL.Dbf", cCheckArea( "COMENL", @dbfComentariosL ), .t. )
      ( dbfComentariosL )->( ordListAdd( cPatPc() + "COMENTARIOSL.Cdx" ) )
      ( dbfComentariosL )->( OrdSetFocus( "cCodDes" ) )

   RECOVER USING oError

      lOpenFile   := .f.

      pdaCerrarTablas()

      msgStop( "Error de conexión con pc." + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

Return lOpenFile

//---------------------------------------------------------------------------//

Function pdaCerrarTablas()

   if( !Empty( dbfTikT         ), ( dbfTikT           )->( dbCloseArea() ), )
   if( !Empty( dbfTikL         ), ( dbfTikL           )->( dbCloseArea() ), )
   if( !Empty( dbfTikP         ), ( dbfTikP           )->( dbCloseArea() ), )
   if( !Empty( dbfDiv          ), ( dbfDiv            )->( dbCloseArea() ), )
   if( !Empty( dbfKit          ), ( dbfKit            )->( dbCloseArea() ), )
   if( !Empty( dbfImp          ), ( dbfImp            )->( dbCloseArea() ), )
   if( !Empty( dbfComentariosT ), ( dbfComentariosT   )->( dbCloseArea() ), )
   if( !Empty( dbfComentariosL ), ( dbfComentariosL   )->( dbCloseArea() ), )

   dbfTikT           := nil
   dbfTikL           := nil
   dbfTikP           := nil
   dbfDiv            := nil
   dbfKit            := nil
   dbfImp            := nil
   dbfComentariosT   := nil
   dbfComentariosL   := nil

Return Nil



//---------------------------------------------------------------------------//

Static Function pdaOpenFiles()

   local oError
   local oBlock
   local cPcName     := AllTrim( cNombrePC() ) + "Emp" + Alltrim( cCodigoEmpresa() ) + "\"
   local cPatEmp     := cPatEmp()

   if pdaAbrirTablas()

      oBlock                  := ErrorBlock( {| oError | ApoloBreak( oError ) } )
      BEGIN SEQUENCE

         lOpenFiles           := .t.

         USE ( cPatGrp() + "FAMILIAS.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FAMILIAS", @dbfFamilia ) )
         SET ADSINDEX TO ( cPatGrp() + "FAMILIAS.Cdx" ) ADDITIVE

         USE ( cPatArt() + "ARTICULO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ARTICULO", @dbfArticulo ) )
         SET ADSINDEX TO ( cPatArt() + "ARTICULO.CDX" ) ADDITIVE

         USE ( cPatGrp() + "FPAGO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FPAGO", @dbfFPago ) )
         ( dbfFPago )->( ordListAdd( cPatGrp() + "FPago.Cdx" ) )

         USE ( cPatDat() + "TBLCNV.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TBLCNV", @dbfTblCnv ) )
         SET ADSINDEX TO ( cPatDat() + "TBLCNV.CDX" ) ADDITIVE

         USE ( cPatEmp + "NCOUNT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "NCOUNT", @dbfCount ) )
         SET ADSINDEX TO ( cPatEmp + "NCOUNT.CDX" ) ADDITIVE

         USE ( cPatGrp() + "CONFIG.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CONFIG", @dbfConfig ) )
         SET ADSINDEX TO ( cPatGrp() + "CONFIG.CDX" ) ADDITIVE

         // LLenamos los pictures de la divisa

         cPouDiv              := cPouDiv( cDivEmp(), dbfDiv )        // Picture de la divisa
         cPorDiv              := cPorDiv( cDivEmp(), dbfDiv )        // Picture de la divisa redondeada
         cPicEur              := cPorDiv( cDivChg(), dbfDiv )        // Picture de la divisa equivalente
         nDouDiv              := nDouDiv( cDivEmp(), dbfDiv )        // .Decimales
         nDorDiv              := nRouDiv( cDivEmp(), dbfDiv )        // Decimales redondeados

         cPicUnd              := MasUnd()

      RECOVER USING oError

         lOpenFiles           := .f.

         msgStop( "Error al conectar con el pc " + CRLF + ErrorMessage( oError ) )

      END SEQUENCE

      ErrorBlock( oBlock )

      pdaCerrarTablas()

      if !lOpenFiles
         pdaCloseFiles()
      end if

      else

         msginfo("Error de conexion con el pc, Reintente")

      end if

RETURN ( lOpenFiles )

//----------------------------------------------------------------------------//

Static Function pdaCloseFiles()

   if( !Empty( dbfFamilia        ), ( dbfFamilia         )->( dbCloseArea() ), )
   if( !Empty( dbfArticulo       ), ( dbfArticulo        )->( dbCloseArea() ), )
   if( !Empty( dbfTblCnv         ), ( dbfTblCnv          )->( dbCloseArea() ), )
   if( !Empty( dbfCount          ), ( dbfCount           )->( dbCloseArea() ), )
   if( !Empty( dbfFPago          ), ( dbfFPago           )->( dbCloseArea() ), )
   if( !Empty( dbfConfig         ), ( dbfConfig          )->( dbCloseArea() ), )

   dbfFamilia        := nil
   dbfArticulo       := nil
   dbfTblCnv         := nil
   dbfCount          := nil
   dbfFPago          := nil
   dbfConfig         := nil

   lOpenFiles        := .f.

Return .T.

//---------------------------------------------------------------------------//

Static Function EdtPda( cNumTik, nMode )

   local aTmp
   local aGet
   local oBrwLin
   local oBrwFamilia
   local oBrwArt
   local oBtnSalon
   local oBtnSuma
   local oBtnResta
   local oBtnShow
   local oFont
   local oError
   local oBlock
   local nOrdArt
   local nOrdFam
   local aDbfBmp           := {  LoadBitmap( GetResources(), "Sel16" ) }
   local oTitArt
   local oTitPrc
   local oSayTit

   /*
   Cargamos los campos de la tabal en el array---------------------------------
   */

   do case
      case nMode == APPD_MODE
         aTmp              := dbBlankRec( dbfTikT )

      case nMode == EDIT_MODE
         if dbDialogLock( dbfTikT )
            aTmp           := dbScatter( dbfTikT )
         else
            return .f.
         end if

   end case

   if lOpenFiles

      aGet                 := Array( ( dbfTikT )->( fCount() ) )

      if BeginTrans( aTmp, aGet, nMode )
         lOpenFiles        := .f.
      end if

   end if

   nOrdFam                 := ( dbfFamilia  )->( OrdSetFocus( "nPosTpv" ) )
   nOrdArt                 := ( dbfArticulo )->( OrdSetFocus( "nPosTpv" ) )

   oBlock                  := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   oFont                   := TFont():New( "MS Sans Serif",   7, 8, .f., .t. )

   lShowBrwLin             := .f.
   lShowBrwFam             := .f.

   if !uFieldEmpresa( "lMixFam" )
      DEFINE DIALOG oDlgTpv RESOURCE "TIKET_PDA_02"
   else
      DEFINE DIALOG oDlgTpv RESOURCE "TIKET_PDA_01"
   end if

   oBtnSalon               := TBtnBmp():ReDefine( 203, "pda_write_16",,,,,{|| PdaShowBrwLin( oBtnSalon, oNumTot, oBrwLin, oBrwFamilia, oBrwArt, !lShowBrwLin, oTitArt, oTitPrc, oSayTit ), lRecTotal( aTmp ) }, oDlgTpv, .f., , .f., , , , , , .f.  )

   REDEFINE SAY oSayTit UPDATE;
      PROMPT   "" ;
      FONT     oFont ;
      ID       204 ;
      OF       oDlgTpv

   REDEFINE SAY oNumTot ;
      PROMPT   Trans( 0, cPorDiv );
      FONT     oFont ;
      ID       210 ;
      OF       oDlgTpv

   REDEFINE SAY oTitArt ;
      PROMPT   "" ;
      ID       205 ;
      OF       oDlgTpv

   REDEFINE SAY oTitPrc ;
      PROMPT   "" ;
      ID       206 ;
      OF       oDlgTpv

   /*
   Browse de las lineas--------------------------------------------------------
   */

   oBrwLin                 := IXBrowse():New( oDlgTpv )
   oBrwLin:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
   oBrwLin:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }
   oBrwLin:cAlias          := dbfTmpL
   oBrwLin:cName           := "Lineas.PDA"
   oBrwLin:nMarqueeStyle   := 5
   oBrwLin:lRecordSelector := .f.
   oBrwLin:lHScroll        := .f.
   oBrwLin:CreateFromResource( 100 )
   oBrwLin:bLDblClick      := {|| ArticuloServido( oBrwLin, dbfTmpL ) }

   with object ( oBrwLin:AddCol() )
      :cHeader             := "S."
      :bStrData            := {|| "" }
      :bBmpData            := {|| if( ( dbfTmpL )->lArtServ, 2, 1 ) }
      :nWidth              := 20
      :AddResource( "Bullet_Square_Red_16" )
      :AddResource( "Bullet_Square_Green_16" )
   end with

   with object ( oBrwLin:AddCol() )
      :cHeader             := "Und."
      :bEditValue          := {|| ( dbfTmpL )->nUntTil }
      :cEditPicture        := MasUnd()
      :nWidth              := 30
      :nDataStrAlign       := 1
      :nHeadStrAlign       := 1
   end with

   with object ( oBrwLin:AddCol() )
      :cHeader             := "Descripción"
      :bEditValue          := {|| if( Empty( ( dbfTmpL )->cComent ), Upper( Rtrim( ( dbfTmpL )->cNomTil ) ),"[*] " + Upper( Rtrim( ( dbfTmpL )->cNomTil ) ) ) }
      :nWidth              := 110
   end with

   with object ( oBrwLin:AddCol() )
      :cHeader             := "Total"
      :bEditValue          := {|| nTotLTpv( dbfTmpL, nDouDiv, nDorDiv ) }
      :cEditPicture        := cPorDiv
      :nWidth              := 50
      :nDataStrAlign       := 1
      :nHeadStrAlign       := 1
   end with

   /*
   Browse de familias----------------------------------------------------------
   */

   if uFieldEmpresa( "lMixFam" )

      oBrwFamilia                 := IXBrowse():New( oDlgTpv )

      oBrwFamilia:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwFamilia:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrwFamilia:cAlias          := dbfFamilia
      oBrwFamilia:cName           := "Familias.PDA"

      oBrwFamilia:lHScroll        := .f.
      oBrwFamilia:lRecordSelector := .f.

      oBrwFamilia:nMarqueeStyle   := 5
      oBrwFamilia:CreateFromResource( 110 )

      oBrwFamilia:bChange         := {|| ChangeFamilias( ( dbfFamilia )->cCodFam, oBrwArt ) }
      oBrwFamilia:bLClicked       := {|| ChangeFamilias( ( dbfFamilia )->cCodFam, oBrwArt ) }

      with object ( oBrwFamilia:AddCol() )
         :cHeader                      := "Familias"
         :bEditValue                   := {|| Upper( ( dbfFamilia )->cNomFam ) }
         :nWidth                       := 220
      end with

   end if

   /*
   Browse de articulos---------------------------------------------------------
   */

   oBrwArt                 := IXBrowse():New( oDlgTpv )

   oBrwArt:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
   oBrwArt:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

   oBrwArt:cAlias          := dbfArticulo
   oBrwArt:cName           := "LinArticu.PDA"

   oBrwArt:lHScroll        := .f.
   oBrwArt:lRecordSelector := .f.

   oBrwArt:nMarqueeStyle   := 5
   oBrwArt:CreateFromResource( 120 )

   with object ( oBrwArt:AddCol() )
      :cHeader                      := "Artículos"
      :bEditValue                   := {|| Upper( ( dbfArticulo )->Nombre ) }
      :nWidth                       := 220
   end with

   oBrwArt:bLDblClick      := {|| WinAppRec( oBrwLin, bEdtPdaL, dbfTmpL, aTmp, .f. ) , ComprobarFamilia( dbfTmpL, oFont, oBrwLin, cNumTik, oTitArt, oTitPrc ) }

   /*
   Barra de botones------------------------------------------------------------
   */

   if !uFieldEmpresa( "lMixFam" )
      TBtnBmp():ReDefine( 690, "ARROW_LEFT_GREEN_16",,,,,{|| pdaBtnFamilias( aTmp, aGet, nMode, oBrwArt, oDlgTpv ) }, oDlgTpv, .f., , .f., , , , , , .f.  )
   end if

   TBtnBmp():ReDefine( 610, "LIBRE_16",,,,,{|| PdaBtnLibre( aTmp, oBrwLin, oFont ) }, oDlgTpv, .f., , .f., , , , , , .f.  )
   TBtnBmp():ReDefine( 620, "STAR_YELLOW_16",,,,,{|| PdaShowBrwLin( oBtnSalon, oNumTot, oBrwLin, oBrwFamilia, oBrwArt, .f., oTitArt, oTitPrc, oSayTit ), LoadFavoritos( oBrwArt ), lRecTotal( aTmp ) }, oDlgTpv, .f., , .f., , , , , , .f.  )
   TBtnBmp():ReDefine( 630, "NAVIGATE_PLUS_16_2",,,,,{|| if( lShowBrwLin, SumaUnidad( aTmp, oBrwLin ), ( WinAppRec( oBrwLin, bEdtPdaL, dbfTmpL, aTmp, .f. ) , ComprobarFamilia( dbfTmpL, oFont, oBrwLin, cNumTik, oTitArt, oTitPrc ) ) ) }, oDlgTpv, .f., , .f., , , , , , .f.  )
   TBtnBmp():ReDefine( 640, "NAVIGATE_MINUS_16_2",,,,,{|| if( lShowBrwLin, RestaUnidad( aTmp, oBrwLin ), ) }, oDlgTpv, .f., , .f., , , , , , .f. )
   TBtnBmp():ReDefine( 650, "MESSAGE_16",,,,,{|| pdaComentario( oFont, dbfTmpL ) }, oDlgTpv, .f., , .f., , , , , , .f.  )
   TBtnBmp():ReDefine( 660, "IMP16",,,,,{|| if( PdaNewTiket( aTmp, aGet, nMode, .f., .t. ), oDlgTpv:End( IDOK ), ) }, oDlgTpv, .f., , .f., , , , , , .f.  )
   TBtnBmp():ReDefine( 670, "MONEY2_16",,,,,{|| if( PdaNewTiket( aTmp, aGet, nMode, .f., , .t. ), oDlgTpv:End( IDOK ), ) }, oDlgTpv, .f., , .f., , , , , , .f.  )
   TBtnBmp():ReDefine( 680, "END16",,,,,{|| EndEdtPda( aTmp, aGet, nMode, oDlgTpv ) }, oDlgTpv, .f., , .f., , , , , , .f.  )

   oDlgTpv:bStart          := {|| if( !uFieldEmpresa( "lMixFam" ), pdaBtnFamilias( aTmp, aGet, nMode, oBrwArt, oDlgTpv ), ), PdaShowBrwLin( oBtnSalon, oNumTot, oBrwLin, oBrwFamilia, oBrwArt, .f., oTitArt, oTitPrc, oSayTit ), lRecTotal( aTmp ) }

   ACTIVATE DIALOG oDlgTpv;
      ON INIT ( pdaMenuEdtRec( aTmp, aGet, nMode, oFont, dbfTmpL, oBrwLin, oNumTot, oBrwArt, cNumTik, oTitArt, oTitPrc ), if( uFieldEmpresa( "lMixFam" ), oBrwFamilia:GoTop(), ), LoadFavoritos( oBrwArt ) )

   /*
   Matamos las tablas temporales-----------------------------------------------
   */

   KillTrans()

   /*
   Desbloqueamos el registro---------------------------------------------------
   */

   if nMode == EDIT_MODE
      dbSafeUnLock( dbfTikT )
   end if

   oFont:End()

   ( dbfFamilia  )->( OrdSetFocus( nOrdFam ) )
   ( dbfArticulo )->( OrdSetFocus( nOrdArt ) )

   RECOVER USING oError

      msgStop( "Error al montar ventana de tiket" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

return ( oDlgTpv:nResult == IDOK )

//---------------------------------------------------------------------------//

static function EndEdtPda( aTmp, aGet, nMode, oDlgTpv )

   if ( dbfTmpL )->( ordKeyCount() ) != 0

      if PdaNewTiket( aTmp, aGet, nMode, .t. )

         oDlgTpv:End()

      end if

   else

       oDlgTpv:End()

   end if

return .t.

//---------------------------------------------------------------------------//

static function PdaShowBrwLin( oBtnSalon, oNumTot, oBrwLin, oBrwFamilia, oBrwArticulo, lShow, oTitArt, oTitPrc, oSayTit )

   if lShow
      oBrwLin:Show()
      if !Empty( oBrwFamilia )
         oBrwFamilia:Hide()
      end if
      oBrwArticulo:Hide()
      oTitArt:Hide()
      oTitPrc:Hide()
      oSayTit:SetColor( nRGB( 0, 75, 255 ), nRGB( 236, 233, 216 )  )
      oNumTot:SetColor( nRGB( 0, 75, 255 ), nRGB( 236, 233, 216 )  )
      lShowBrwLin          := .t.
   else
      oBrwLin:Hide()
      if !Empty( oBrwFamilia )
         oBrwFamilia:Show()
      end if
      oBrwArticulo:Show()
      oTitArt:Show()
      oTitPrc:Show()
      oSayTit:SetColor( nRGB( 0, 0, 0 ), nRGB( 236, 233, 216 )  )
      oNumTot:SetColor( nRGB( 0, 0, 0 ), nRGB( 236, 233, 216 )  )
      lShowBrwLin          := .f.
   end if

   oBtnSalon:Refresh()
   oNumTot:Refresh()
   oSayTit:Refresh()
   oBrwArticulo:SetFocus()

return .t.

//---------------------------------------------------------------------------//

Static Function SumaUnidad( aTmp, oBrwLin )

   ( dbfTmpL )->lImpCom    := .f.

   ( dbfTmpL )->nUntTil++

   lRecTotal( aTmp )

   oBrwLin:Refresh()

Return nil

//---------------------------------------------------------------------------//

Static Function RestaUnidad( aTmp, oBrwLin )

   if !( dbfTmpL )->lArtServ

      if ( dbfTmpL )->nUntTil == 1

         if ApoloMsgNoYes( "¿ Desea eliminar el artículo seleccionado ?", "Elija una opción" )
            ( dbfTmpL )->nUntTil--
            ( dbfTmpL )->lAnulado   := .t.
         end if
      else
         ( dbfTmpL )->nUntTil--
         ( dbfTmpL )->lAnulado      := .t.
      end if

      /*if ( dbfTmpL )->nUntTil == 0
         ( dbfTmpL )->( dbdelete() )
         oBrwLin:GoTop()
      end if*/

      lRecTotal( aTmp )

   end if

   oBrwLin:Refresh()

Return nil

//---------------------------------------------------------------------------//

Static Function pdaMenuEdtRec( aTmp, aGet, nMode, oFntTit, dbfTmpL, oBrwLin, oNumTot, oBrwArticulo, cNumTik, oTitArt, oTitPrc )

   local oMenu

   /*
   DEFINE MENU oMenu ;
      RESOURCE 600 ;
      BITMAPS  140 ;    // bitmap resources ID
      IMAGES   15       // number of images in the bitmap

      REDEFINE MENUITEM;
               ID       610;
               OF       oMenu;
               ACTION   ( if( PdaNewTiket( aTmp, aGet, nMode ), oDlgTpv:End( IDOK ), ) )


      REDEFINE MENUITEM;
               ID       620;
               OF       oMenu;
               ACTION   ( LoadFavoritos( oBrwArticulo ) ) // ACTION   ( pdaCombinado( oBrwFamilia, oBrwArticulo ) )

      REDEFINE MENUITEM;
               ID       630;
               OF       oMenu;
               ACTION   ( if( !lShowBrwLin, ( WinAppRec( oBrwLin, bEdtPdaL, dbfTmpL, aTmp, .f. ) , ComprobarFamilia( dbfTmpL, oFntTit, oBrwLin, cNumTik, oTitArt, oTitPrc ) ), ) )

      REDEFINE MENUITEM;
               ID       640;
               OF       oMenu;
               ACTION   ( if( !lShowBrwLin, WinAppRec( oBrwLin, bEdtPdaL, dbfTmpL, aTmp, .t. ), ) )

      REDEFINE MENUITEM;
               ID       650;
               OF       oMenu;
               ACTION   ( pdaComentario( oFntTit, dbfTmpL ) )

      REDEFINE MENUITEM;
               ID       660;
               OF       oMenu;
               ACTION   ( if( PdaNewTiket( aTmp, aGet, nMode, .f., .t. ), oDlgTpv:End( IDOK ), ) )

      REDEFINE MENUITEM;
               ID       670;
               OF       oMenu;
               ACTION   ( if( PdaNewTiket( aTmp, aGet, nMode, .f.,, .t. ), oDlgTpv:End( IDOK ), ) )

      REDEFINE MENUITEM ;
               ID       680 ;
               OF       oMenu ;
               ACTION   ( oDlgTpv:End() )

   oDlgTpv:SetMenu( oMenu )
   */

Return oMenu

//---------------------------------------------------------------------------//

function pdaCombinado( oBrwFamilia ) // cCodArt, aGetArt, aTmpArt, aTmp )

   local nRecArt
   local nRecFam

   lTwoLin              := !lTwoLin

   if lTwoLin

      nRecArt           := ( dbfArticulo )->( Recno() )
      nRecFam           := ( dbfFamilia )->( Recno() )

      if dbSeekInOrd( cCodArtAnt, "Codigo", dbfArticulo )

         if dbSeekInOrd( ( dbfArticulo )->Familia, "cCodFam", dbfFamilia ) .and. !Empty( ( dbfFamilia )->cFamCmb )

            cCodFamAnt  := ( dbfArticulo )->Familia

            msginfo( "combinar con " + ( dbfFamilia )->cFamCmb )

         end if

      end if

      ( dbfArticulo )->( dbGoTo( nRecArt ) )
      ( dbfFamilia )->( dbGoTo( nRecFam ) )

   end if

return .t.

//---------------------------------------------------------------------------//
/*
Funcion para lanzar la ventana de comentarios si la familia selecionada esta marcada para ello
*/

static Function ComprobarFamilia( dbfTmpL, oFntTit, oBrwLin, cNumTik, oTitArt, oTitPrc )

   oBrwLin:GoBottom()

   if RetFld( ( dbfTmpL )->cCodFam, dbfFamilia, "lMostrar" )

      pdaComentario( oFntTit, dbfTmpL, RetFld( ( dbfTmpL )->cCodFam, dbfFamilia, "cComFam" ) )

   end if

   /*
   Informamos del último artículo vendido--------------------------------------
   */

   if !Empty( oTitArt )
      oTitArt:SetText( if( Empty( ( dbfTmpL )->cComent ), Upper( Rtrim( ( dbfTmpL )->cNomTil ) ),"[*] " + Upper( Rtrim( ( dbfTmpL )->cNomTil ) ) ) )
   end if

   if !Empty( oTitPrc )
      oTitPrc:SetText( AllTrim( Trans( nTotLTpv( dbfTmpL, nDouDiv, nDorDiv ), cPorDiv ) ) )
   end if

Return nil

//---------------------------------------------------------------------------//
/*
   Función para poner un comentario a un articulo
*/
//---------------------------------------------------------------------------//

Static Function pdaComentario( oFntTit, dbfTmpL, cDefCom )

   local oDlg
   local oBrwComentariosT
   local oBrwComentariosL
   local oGetComentario
   local cGetComentario

   if ( dbfTmpL )->( ordKeyCount() ) == 0
      MsgStop( "No puede añadir un comentario." )
      return .f.
   end if

   cGetComentario       := ( dbfTmpL )->cComent

   DEFINE DIALOG oDlg RESOURCE "COMENTARIOSTS"

      REDEFINE GET oGetComentario VAR cGetComentario;
         ID       300 ;
         Font     oFntTit ;
         OF       oDlg

      oBrwComentariosT                 := IXBrowse():New( oDlg )

      oBrwComentariosT:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwComentariosT:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrwComentariosT:cAlias          := dbfComentariosT
      oBrwComentariosT:cName           := "ComentaT.PDA"

      oBrwComentariosT:lHScroll        := .f.
      oBrwComentariosT:lRecordSelector := .f.

      oBrwComentariosT:nMarqueeStyle   := 5
      oBrwComentariosT:CreateFromResource( 100 )

      oBrwComentariosT:bChange         := {|| ChangeComentarios( , , oBrwComentariosL ) }

      with object ( oBrwComentariosT:AddCol() )
         :cHeader                      := "Tipos de comentarios"
         :bEditValue                   := {|| Upper( ( dbfComentariosT )->cDescri ) }
         :nWidth                       := 220
      end with

      oBrwComentariosL                 := IXBrowse():New( oDlg )

      oBrwComentariosL:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwComentariosL:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrwComentariosL:cAlias          := dbfComentariosL
      oBrwComentariosL:cName           := "ComentaL.PDA"
      oBrwComentariosL:lHScroll        := .f.
      oBrwComentariosL:lRecordSelector := .f.

      oBrwComentariosL:nMarqueeStyle   := 5
      oBrwComentariosL:CreateFromResource( 110 )

      oBrwComentariosL:bLDblClick      := {|| ChangeLineasComentarios( oGetComentario ) }

      with object ( oBrwComentariosL:AddCol() )
         :cHeader                      := "Comentarios"
         :bEditValue                   := {|| Upper( ( dbfComentariosL )->cDescri ) }
         :nWidth                       := 220
      end with

      TBtnBmp():ReDefine( 500, "check2_16_2",,,,,{|| EndComentario( oDlg, dbfTmpL, oGetComentario ) }, oDlg, .f., , .f., , , , , , .f.  )
      TBtnBmp():ReDefine( 550, "END16",,,,,{|| oDlg:End( IDCANCEL ) }, oDlg, .f., , .f., , , , , , .f.  )

      oDlg:bStart                      := {|| SeleccionarDefecto( cDefCom, dbfComentariosT, dbfComentariosL, oBrwComentariosL, oBrwComentariosT ) }

   ACTIVATE DIALOG oDlg

Return .t.

//---------------------------------------------------------------------------//

Static Function pdaBtnFamilias( aTmp, aGet, nMode, oBrwArticulo, oDlgTpv )

   local oDlg
   local n                          := 1
   local nOrdAnt                    := ( dbfFamilia )->( OrdSetFocus( "nPosTpv" ) )
   local aBtnFam
   local oBtnAnterior
   local oBtnSiguiente
   local oBrwFamilia
   local oSayMesa
   local oBtnShow
   local oBrwLin
   local oFont                      := TFont():New( "MS Sans Serif",   7, 8, .f., .t. )
   local oBtnChange
   local oSayTitle
   local oBtnMenos
   local oBtnMas

   if uFieldEmpresa( "lBtnFam" )

      aBtnFam                       := Array( 9 )

      DEFINE DIALOG oDlg RESOURCE "BTNFAMILIAS"

      oBtnChange                    := TBtnBmp():ReDefine( 203, "pda_write_16",,,,,{|| PdaShowBrwFam( oBrwFamilia, oBrwLin, oBrwArticulo, !lShowBrwFam, aBtnFam, oBtnAnterior, oBtnSiguiente, oDlg, oSayTitle, oBtnMenos, oBtnMas ), lRecTotal( aTmp ) }, oDlg, .f., , .f., , , , , , .f.  )

      REDEFINE SAY oSayTitle ;
         PROMPT   "" ;
         FONT     oFont ;
         ID       204 ;
         OF       oDlg

      REDEFINE SAY oTotPdaFam ;
         PROMPT   Trans( 0, cPorDiv );
         FONT     oFont ;
         ID       210 ;
         OF       oDlg

      /*
      Browse de las lineas--------------------------------------------------------
      */

      oBrwLin                 := IXBrowse():New( oDlg )
      oBrwLin:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwLin:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }
      oBrwLin:cAlias          := dbfTmpL
      oBrwLin:cName           := "Lineas2.PDA"
      oBrwLin:nMarqueeStyle   := 5
      oBrwLin:lRecordSelector := .f.
      oBrwLin:lHScroll        := .f.
      oBrwLin:CreateFromResource( 150 )

      with object ( oBrwLin:AddCol() )
         :cHeader             := "Und."
         :bEditValue          := {|| ( dbfTmpL )->nUntTil }
         :cEditPicture        := MasUnd()
         :nWidth              := 30
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader             := "Descripción"
         :bEditValue          := {|| if( Empty( ( dbfTmpL )->cComent ), Upper( Rtrim( ( dbfTmpL )->cNomTil ) ),"[*] " + Upper( Rtrim( ( dbfTmpL )->cNomTil ) ) ) }
         :nWidth              := 130
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader             := "Total"
         :bEditValue          := {|| nTotLTpv( dbfTmpL, nDouDiv, nDorDiv ) }
         :cEditPicture        := cPorDiv
         :nWidth              := 50
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
      end with

      for n := 1 to len( aBtnFam )
         aBtnFam[ n ]              := TBtnBmp():ReDefine( 100 + n, ,,,,,{|| oDlg:End() }, oDlg, .f., , .f., , "Boton " + AllTrim( Str( n ) ), , , , .f., "CENTER" )
         aBtnFam[ n ]:SetColor( Rgb( 0, 0, 0 ), Rgb( 255, 255, 255 ) )
      next

      oBtnAnterior   := TBtnBmp():ReDefine( 110, "ARROW_LEFT_GREEN_16",,,,,{|| PdaloaFam( .f., .f., aBtnFam, oBtnAnterior, oBtnSiguiente, oBrwArticulo, oDlg ) }, oDlg, .f., , .f., , , , , , .f.  )

      oBtnSiguiente  := TBtnBmp():ReDefine( 120, "ARROW_RIGHT_GREEN_16",,,,,{|| PdaloaFam( .t., .f., aBtnFam, oBtnAnterior, oBtnSiguiente, oBrwArticulo, oDlg ) }, oDlg, .f., , .f., , , , , , .f.  )

      oBtnMenos      := TBtnBmp():ReDefine( 630, "NAVIGATE_PLUS_16_2",,,,,{|| SumaUnidad( aTmp, oBrwLin ) }, oDlg, .f., , .f., , , , , , .f.  )

      oBtnMas        := TBtnBmp():ReDefine( 640, "NAVIGATE_MINUS_16_2",,,,,{|| RestaUnidad( aTmp, oBrwLin ) }, oDlg, .f., , .f., , , , , , .f. )

      TBtnBmp():ReDefine( 660, "IMP16",,,,,{|| if( PdaNewTiket( aTmp, aGet, nMode, .f., .t. ), ( oDlg:End(), oDlgTpv:End( IDOK ) ), ) }, oDlg, .f., , .f., , , , , , .f.  )

      TBtnBmp():ReDefine( 130, "MONEY2_16",,,,,{|| if( PdaNewTiket( aTmp, aGet, nMode, .f., , .t. ), ( oDlg:End(), oDlgTpv:End( IDOK ) ), ) }, oDlg, .f., , .f., , , , , , .f.  )

      TBtnBmp():ReDefine( 500, "END16",,,,,{|| oDlg:End(), EndEdtPda( aTmp, aGet, nMode, oDlgTpv ) }, oDlg, .f., , .f., , , , , , .f.  )

      oDlg:bStart := {|| PdaShowBrwFam( oBrwFamilia, oBrwLin, oBrwArticulo, .f., aBtnFam, oBtnAnterior, oBtnSiguiente, oDlg, oSayTitle, oBtnMenos, oBtnMas ), lRecTotal( aTmp ) }

      ACTIVATE DIALOG oDlg ;
         ON INIT PdaloaFam( .t., .t., aBtnFam, oBtnAnterior, oBtnSiguiente, oBrwArticulo, oDlg )

   else

      DEFINE DIALOG oDlg RESOURCE "BRWFAMILIAS"

         oBtnChange               := TBtnBmp():ReDefine( 203, "pda_write_16",,,,,{|| PdaShowBrwFam( oBrwFamilia, oBrwLin, oBrwArticulo, !lShowBrwFam, aBtnFam, oBtnAnterior, oBtnSiguiente, oDlg, oSayTitle, oBtnMenos, oBtnMas ), lRecTotal( aTmp ) }, oDlg, .f., , .f., , , , , , .f.  )

         REDEFINE SAY oSayTitle ;
            PROMPT   "" ;
            FONT     oFont ;
            ID       204 ;
            OF       oDlg

         REDEFINE SAY oTotPdaFam ;
            PROMPT   Trans( 0, cPorDiv );
            FONT     oFont ;
            ID       210 ;
            OF       oDlg

         /*
         Browse de las lineas--------------------------------------------------------
         */

         oBrwLin                 := IXBrowse():New( oDlg )
         oBrwLin:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
         oBrwLin:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }
         oBrwLin:cAlias          := dbfTmpL
         oBrwLin:cName           := "Lineas2.PDA"
         oBrwLin:nMarqueeStyle   := 5
         oBrwLin:lRecordSelector := .f.
         oBrwLin:lHScroll        := .f.
         oBrwLin:CreateFromResource( 150 )

         with object ( oBrwLin:AddCol() )
            :cHeader             := "Und."
            :bEditValue          := {|| ( dbfTmpL )->nUntTil }
            :cEditPicture        := MasUnd()
            :nWidth              := 30
            :nDataStrAlign       := 1
            :nHeadStrAlign       := 1
         end with

         with object ( oBrwLin:AddCol() )
            :cHeader             := "Descripción"
            :bEditValue          := {|| if( Empty( ( dbfTmpL )->cComent ), Upper( Rtrim( ( dbfTmpL )->cNomTil ) ),"[*] " + Upper( Rtrim( ( dbfTmpL )->cNomTil ) ) ) }
            :nWidth              := 130
         end with

         with object ( oBrwLin:AddCol() )
            :cHeader             := "Total"
            :bEditValue          := {|| nTotLTpv( dbfTmpL, nDouDiv, nDorDiv ) }
            :cEditPicture        := cPorDiv
            :nWidth              := 50
            :nDataStrAlign       := 1
            :nHeadStrAlign       := 1
         end with

         /*
         Browse de familias----------------------------------------------------
         */

         oBrwFamilia                 := IXBrowse():New( oDlg )

         oBrwFamilia:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
         oBrwFamilia:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

         oBrwFamilia:cAlias          := dbfFamilia
         oBrwFamilia:cName           := "Familias.PDA"

         oBrwFamilia:lHScroll        := .f.
         oBrwFamilia:lRecordSelector := .f.
         oBrwFamilia:bLDblClick      := {|| ChangeFamilias( ( dbfFamilia )->cCodFam, oBrwArticulo ), oDlg:End() }

         oBrwFamilia:nMarqueeStyle   := 5
         oBrwFamilia:CreateFromResource( 100 )

         with object ( oBrwFamilia:AddCol() )
            :cHeader                      := "Familias"
            :bEditValue                   := {|| Upper( ( dbfFamilia )->cNomFam ) }
            :nWidth                       := 220
         end with

         oBtnMenos      := TBtnBmp():ReDefine( 630, "NAVIGATE_PLUS_16_2",,,,,{|| SumaUnidad( aTmp, oBrwLin ) }, oDlg, .f., , .f., , , , , , .f.  )

         oBtnMas        := TBtnBmp():ReDefine( 640, "NAVIGATE_MINUS_16_2",,,,,{|| RestaUnidad( aTmp, oBrwLin ) }, oDlg, .f., , .f., , , , , , .f. )

         TBtnBmp():ReDefine( 660, "IMP16",,,,,{|| if( PdaNewTiket( aTmp, aGet, nMode, .f., .t. ), ( oDlg:End(), oDlgTpv:End( IDOK ) ), ) }, oDlg, .f., , .f., , , , , , .f.  )

         TBtnBmp():ReDefine( 130, "MONEY2_16",,,,,{|| if( PdaNewTiket( aTmp, aGet, nMode, .f., , .t. ), ( oDlg:End(), oDlgTpv:End( IDOK ) ), ) }, oDlg, .f., , .f., , , , , , .f.  )

         TBtnBmp():ReDefine( 500, "END16",,,,,{|| oDlg:End(), EndEdtPda( aTmp, aGet, nMode, oDlgTpv ) }, oDlg, .f., , .f., , , , , , .f.  )

         oDlg:bStart := {|| oBrwFamilia:GoTop(), PdaShowBrwFam( oBrwFamilia, oBrwLin, oBrwArticulo, .f., aBtnFam, oBtnAnterior, oBtnSiguiente, oDlg, oSayTitle, oBtnMenos, oBtnMas ), lRecTotal( aTmp ) }

      ACTIVATE DIALOG oDlg

   end if

   oFont:End()

   ( dbfFamilia )->( OrdSetFocus( nOrdAnt ) )

Return .t.

//---------------------------------------------------------------------------//

static function PdaShowBrwFam( oBrwFamilia, oBrwLin, oBrwArticulo, lShow, aBtnFam, oBtnAnterior, oBtnSiguiente, oDlg, oSayTitle, oBtnMenos, oBtnMas )

   if lShow
      oBrwLin:Show()
      if uFieldEmpresa( "lBtnFam" )
         aEval( aBtnFam, {|o| o:Hide() } )
         oBtnAnterior:Disable()
         oBtnSiguiente:Disable()
      else
         oBrwFamilia:Hide()
      end if
      oBtnMenos:Show()
      oBtnMas:Show()
      oSayTitle:SetColor( nRGB( 0, 75, 255 ), nRGB( 236, 233, 216 )  )
      oTotPdaFam:SetColor( nRGB( 0, 75, 255 ), nRGB( 236, 233, 216 )  )
      lShowBrwFam    := .t.
   else
      oBrwLin:Hide()
      if uFieldEmpresa( "lBtnFam" )
         aEval( aBtnFam, {|o| o:Show() } )
         PdaloaFam( .t., .t., aBtnFam, oBtnAnterior, oBtnSiguiente, oBrwArticulo, oDlg )
      else
         oBrwFamilia:Show()
      end if
      oBtnMenos:Hide()
      oBtnMas:Hide()
      oSayTitle:SetColor( nRGB( 0, 0, 0 ), nRGB( 236, 233, 216 )  )
      oTotPdaFam:SetColor( nRGB( 0, 0, 0 ), nRGB( 236, 233, 216 )  )
      lShowBrwFam    := .f.
   end if

   if !Empty( oBrwLin )
      oBrwLin:Refresh()
   end if

   if !Empty( oSayTitle )
      oSayTitle:Refresh()
   end if

   if !Empty( oTotPdaFam )
      oTotPdaFam:Refresh()
   end if

   if !Empty( oBrwFamilia )
      oBrwFamilia:SetFocus()
   end if

return .t.

//---------------------------------------------------------------------------//

Static Function PdaloaFam( lAvance, lRepos, aBtnFam, oBtnAnterior, oBtnSiguiente, oBrwArticulo, oDlg )

   local n                 := 1

   DEFAULT lAvance         := .t.
   DEFAULT lRepos          := .f.

   // Ocultamos los botones----------------------------------------------------

   aEval( aBtnFam, {|o| o:Hide() } )

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
      oBtnAnterior:Enable()
   else
      oBtnAnterior:Disable()
   end if

   // Montamos las familias----------------------------------------------------

   while n <= 9

      if !( dbfFamilia )->( eof() )

         aBtnFam[ n ]:Show()
         aBtnFam[ n ]:Cargo            := ( dbfFamilia )->cCodFam
         aBtnFam[ n ]:bAction          := {| o | ChangeFamilias( o:Cargo, oBrwArticulo ), oDlg:End() }
         aBtnFam[ n ]:cCaption         := Capitalize( ( dbfFamilia )->cNomFam )

         ( dbfFamilia )->( dbSkip() )

      end if

      n++

   end while

   if lMostrarFamilias()
      oBtnSiguiente:Enable()
   else
      oBtnSiguiente:Disable()
   end if

Return ( nil )

//---------------------------------------------------------------------------//
/*
   Funcion para crear el articulo libre
*/
//---------------------------------------------------------------------------//

Static Function PdaBtnLibre( aTmp, oBrwLin, oFntTit )

   local oDlg
   local oSayTit
   local oGetNombre
   local cGetNombre     := Space( 100 )
   local oGetUnidades
   local nGetUnidades   := 1
   local oGetPrecio
   local nGetPrecio     := 0
   local oGetTotal
   local nGetTotal      := 0
   local oBtn
   local oSayTot
   local oFont
   local oImpComanda
   local cImpComanda

   aImpComanda          := aTiposImpresoras( dbfTImp )
   cImpComanda          := Padr( "No imprimir", 254 )

   DEFINE DIALOG oDlg RESOURCE "ARTICULO_LIBRE"

   REDEFINE SAY oSayTit ;
      ID       130 ;
      FONT     oFntTit ;
      OF       oDlg

   oBtn                 := TBtnBmp():ReDefine( 140, "libre_16",,,,,, oDlg, .f., , .f., , , , , , .f.  )

   REDEFINE GET oGetNombre VAR cGetNombre ;
      ID       100 ;
      OF       oDlg

   REDEFINE GET oGetUnidades VAR nGetUnidades ;
      ID       110 ;
      PICTURE  "99" ;
      SPINNER;
      OF       oDlg

   oGetUnidades:bChange       := {|| pdaCalculartotal( oGetUnidades, oGetPrecio, oSayTot ) }

   REDEFINE GET oGetPrecio VAR nGetPrecio ;
      ID       120 ;
      PICTURE  "@E 999999.99" ;
      SPINNER ;
      OF       oDlg

   oGetPrecio:bChange         := {|| pdaCalculartotal( oGetUnidades, oGetPrecio, oSayTot ) }

   REDEFINE SAY oSayTot ;
      ID       150 ;
      PICTURE  cPorDiv ;
      FONT     oFont ;
      OF       oDlg

   REDEFINE COMBOBOX oImpComanda VAR cImpComanda ;
      ITEMS       aImpComanda ;
      ID          151 ;
      OF          oDlg

   TBtnBmp():ReDefine( 500, "check2_16_2",,,,,{|| GuardarBtnLibre( oDlg, oGetNombre, oGetUnidades, oGetPrecio, oBrwLin, aTmp, cImpComanda  ) }, oDlg, .f., , .f., , , , , , .f.  )
   TBtnBmp():ReDefine( 550, "END16",,,,,{|| oDlg:End() }, oDlg, .f., , .f., , , , , , .f.  )

   ACTIVATE DIALOG oDlg ;
      ON INIT ( pdaCalculartotal( oGetUnidades, oGetPrecio, oSayTot ) )

Return nil

//---------------------------------------------------------------------------//

Static Function GuardarBtnLibre( oDlg, oGetNombre, oGetUnidades, oGetPrecio, oBrwLin, aTmp, cImpComanda )

   local cNombre     := oGetNombre:VarGet()
   local nUnidades   := oGetUnidades:VarGet()
   local nPrecio     := oGetPrecio:VarGet()

   if !Empty( cNombre )

      ( dbfTmpL )->( dbAppend() )

      if !( dbfTmpL )->( NetErr() )
         ( dbfTmpL )->cNomTil := cNombre
         ( dbfTmpL )->nUntTil := nUnidades
         ( dbfTmpL )->nPvpTil := nPrecio
         ( dbfTmpL )->nIvaTil    := nIva( dbfIva, cDefIva() )
         ( dbfTmpL )->cAlmLin    := oUser():cAlmacen()
         ( dbfTmpL )->cImpCom1   := cImpComanda
      end if

      lRecTotal( aTmp )

      oBrwLin:Refresh()

      oDlg:End( IDOK )

   else

      msginfo("No puede almacenar un articulo sin nombre")

   end if

Return nil

//---------------------------------------------------------------------------//

static function pdaCalcularTotal( oGetUnidades, oGetPrecio, oSayTot )

   local nUnidades   := oGetUnidades:VarGet()
   local nPrecio     := oGetPrecio:VarGet()
   local nTotal      := nUnidades * nPrecio

   oSayTot:SetText( nTotal )

Return nil

//---------------------------------------------------------------------------//
/*
   Funcion que guarda la zona de trabajo por defecto
*/
//---------------------------------------------------------------------------//

function pdaZona()

   local oDlg
   local oCbxSalon
   local cCbxSalon   := "1"
   local aCbxSalon   := {}
   local sSala

   DEFINE DIALOG oDlg RESOURCE "ZONATS"

   REDEFINE COMBOBOX oCbxSalon ;
      VAR      cCbxSalon ;
      ID       120 ;
      ITEMS    aCbxSalon ;
      OF       oDlg

   TBtnBmp():ReDefine( 500, "check2_16_2",,,,,{|| cPdaZona( aCbxSalon[ oCbxSalon:nAt ] ), oDlg:End( IDOK ) }, oDlg, .f., , .f., , , , , , .f.  )
   TBtnBmp():ReDefine( 550, "END16",,,,,{|| oDlg:End( IDCANCEL ) }, oDlg, .f., , .f., , , , , , .f.  )

   ACTIVATE DIALOG oDlg

Return Nil

//---------------------------------------------------------------------------//

function cPdaZona( cNombre )

   if Empty( cZona )
      cZona    := cNombre
   end if

Return cZona

//---------------------------------------------------------------------------//
/*
Funcion que guarda la sesión que tenemos abierta
*/
//---------------------------------------------------------------------------//

Function pdaSesion()

Return Nil

//---------------------------------------------------------------------------//
/*
Esta funcion graba el tiket
*/
//---------------------------------------------------------------------------//

Static Function pdaNewTiket( aTmp, aGet, nMode, lEmpty, lNota, lCobrar )

Return .t.

//---------------------------------------------------------------------------//

static function pdaLiberarCero( cSerie, cNumero, cSufijo )

Return .t.

//---------------------------------------------------------------------------//

Static Function PdaNotaTiket( aTmp, aGet, nMode, nNumTik )

Return .t.

//---------------------------------------------------------------------------//

Static Function PdaCobrarTiket( aTmp, aGet, nMode )

Return nil

//---------------------------------------------------------------------------//

Static Function pdaStarCobro( aButtonsPago )

Return nil

//---------------------------------------------------------------------------//

Static Function pdaImpresionTicket( nNumTik )

Return .t.

//---------------------------------------------------------------------------//

Static Function pdaCobro( aTmp, aGet, nMode )

return .t.

//---------------------------------------------------------------------------//

Static Function ChangeFamilias( cCodFam, oBrwArticulo )

   ( dbfArticulo )->( OrdSetFocus( "CFAMNOM" ) )
   ( dbfArticulo )->( OrdScope( 0, cCodFam ) )
   ( dbfArticulo )->( OrdScope( 1, cCodFam ) )
   ( dbfArticulo )->( dbGoTop() )

   if !Empty( oBrwArticulo )
      oBrwArticulo:GoTop()
      oBrwArticulo:Refresh()
   end if

RETURN ( nil )

//---------------------------------------------------------------------------//

Static Function LoadFavoritos( oBrwArticulo )

   ( dbfArticulo )->( OrdSetFocus( "nPosTcl" ) )
   ( dbfArticulo )->( dbGoTop() )

   oBrwArticulo:Refresh()

RETURN ( nil )

//---------------------------------------------------------------------------//

Static Function cTitleSalaVenta( oSayVta, oSayTit )

Return ( nil )

//---------------------------------------------------------------------------//

Static Function bpdaButtonsPago( cCode, cText, aTmp )

Return ( {|| aTmp[ _CFPGTIK ] := cCode, oSayFPago:SetText( AllTrim( cText ) ) } )

//---------------------------------------------------------------------------//

Static Function cImageBtn( cCode )

   local cBtnImagen

   do case
      case cCode == "00"
         cBtnImagen  := "money2_16"
      case cCode == "01"
         cBtnImagen  := "Creditcards_16"
      case cCode == "02"
         cBtnImagen  := "moneybag_16"
      case cCode == "03"
         cBtnImagen  := "percent_16"
      case cCode == "04"
         cBtnImagen  := "shoppingbasket_16"
   end case

Return cBtnImagen

//---------------------------------------------------------------------------//

Static Function pdaEntregando( nValor, aTmp )

   local nCambio
   local nTotal

   if nValor == "C"
      cNumEnt     := "0"
      nCambio     := 0
   else

      cNumEnt     += nValor

      nTotal      := nTotTik( aTmp[ _CSERTIK ] + aTmp[ _CNUMTIK ] + aTmp[ _CSUFTIK ], dbfTikT, dbfTmpL, dbfDiv, aTmp, nil, .f. )

      nCambio     := Val( cNumEnt ) + nEntCli  - nTotal

   end if

   oNumEnt:SetText( Trans( Val( cNumEnt ), cPorDiv ) )
   oNumCambio:SetText( Trans( nCambio, cPorDiv ) )

   nCambioCli     := nCambio

Return nil

//---------------------------------------------------------------------------//

static function EdtPdaL( aTmp, aGet, dbfTmpL, oBrw, aTmpHead, lNegative, nMode )

   DEFAULT lNegative := .f.

   /*
   Metemos los valores de la linea, ya que estamos posicionados
   */

   aTmp[ _CTIPTIL ]     := aTmpHead[ _CTIPTIK ]
   aTmp[ _CALMLIN ]     := aTmpHead[ _CALMTIK ]
   aTmp[ _CCODUSR  ]    := aTmpHead[ _CCCJTIK ]

   aTmp[ _CCBATIL ]     := ( dbfArticulo )->Codigo
   aTmp[ _CNOMTIL ]     := ( dbfArticulo )->Nombre

   if !Empty( ( dbfArticulo )->cDesCmd )
      aTmp[ _CNOMCMD ]  := ( dbfArticulo )->cDesCmd
   else
      aTmp[ _CNOMCMD ]  := ( dbfArticulo )->Nombre
   end if

   aTmp[ _NPVPTIL ]     := nRetPreArt( aTmpHead[ _NTARIFA ], aTmpHead[ _CDIVTIK ], .t., dbfArticulo, dbfDiv, dbfKit, dbfIva )
   if lNegative
      aTmp[ _NUNTTIL ]  := -1
   else
      aTmp[ _NUNTTIL ]  := 1
   end if

   aTmp[ _NUNDKIT ]     := 0
   aTmp[ _NIVATIL ]     := nIva( dbfIva, ( dbfArticulo )->TipoIva )
   aTmp[ _LOFETIL ]     := .f.
   aTmp[ _CCODPR1 ]     := Space( 10 )
   aTmp[ _CCODPR2 ]     := Space( 10 )
   aTmp[ _CVALPR1 ]     := Space( 10 )
   aTmp[ _CVALPR2 ]     := Space( 10 )

   if ( dbfArticulo )->lFacCnv
      aTmp[ _NFACCNV ]  := ( dbfArticulo )->nFacCnv
   end if

   aTmp[ _NCTLSTK ]     := ( dbfArticulo )->nCtlStock
   aTmp[ _NCOSDIV ]     := ( dbfArticulo )->pCosto
   aTmp[ _NNUMLIN ]     := 1     //Tenemos que hacer un autoincremental
   aTmp[ _LKITART ]     := .f.
   aTmp[ _LKITCHG ]     := .f.
   aTmp[ _LKITPRC ]     := .f.
   aTmp[ _LIMPLIN ]     := .f.
   aTmp[ _NMESGRT ]     := ( dbfArticulo )->nMesGrt
   aTmp[ _LCONTROL]     := .f.
   aTmp[ _CCODFAM ]     := ( dbfArticulo )->Familia
   aTmp[ _CGRPFAM ]     := RetFld( ( dbfArticulo )->Familia, dbfFamilia, "CCODGRP" )

   if ( dbfArticulo )->lLote
      aTmp[ _CLOTE ]    := ( dbfArticulo )->cLote
   end if

   aTmp[ _LIMPCOM ]     := .f.

   aTmp[ _CIMPCOM1 ] := ( dbfArticulo )->cTipImp1
   aTmp[ _CIMPCOM2 ] := ( dbfArticulo )->cTipImp2

   /*
   Guardamos el registro en la tabla temporal----------------------------------
   */

   WinGather( aTmp, , dbfTmpL, , nMode )

   lRecTotal( aTmpHead )

return nil

//---------------------------------------------------------------------------//

#endif

//---------------------------------------------------------------------------//

FUNCTION mkTpv( cPath, lAppend, cPathOld, oMeter )

	local dbfTikT
	local dbfTikL
   local dbfTikP
   local dbfTikC
   local dbfImp
   local dbfMesas
   local oldTikT
   local oldTikL
   local oldTikP
   local oldTikC
   local oldImp
   local oldMesas

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

   if !lExistTable( cPath + "TIKES.DBF" )
      dbCreate( cPath + "TIKES.DBF", aSqlStruct( aSerTik() ), cDriver() )
   end if

   if !lExistTable( cPath + "TIKEM.DBF" )
      dbCreate( cPath + "TIKEM.DBF", aSqlStruct( aMesTik() ), cDriver() )
   end if

   if !lExistTable( cPath + "TIKETIMP.DBF" )
      dbCreate( cPath + "TIKETIMP.DBF", aSqlStruct( aImpTik() ), cDriver() )
   end if

   rxTpv( cPath, oMeter )

   if lAppend .and. lIsDir( cPathOld )

      dbUseArea( .t., cDriver(), cPath + "TikeT.Dbf", cCheckArea( "TIKET",  @dbfTikT ), .f. )
      ( dbfTikT )->( ordListAdd( cPath + "TikeT.Cdx" ) )
      ( dbfTikT )->( ordSetFocus( "cLiqVal" ) )

      dbUseArea( .t., cDriver(), cPath + "TikeL.Dbf", cCheckArea( "TIKETL", @dbfTikL ), .f. )
      ( dbfTikL )->( ordListAdd( cPath + "TikeL.Cdx" ) )

      dbUseArea( .t., cDriver(), cPath + "TikeP.Dbf", cCheckArea( "TIKETP", @dbfTikP ), .f. )
      ( dbfTikP )->( ordListAdd( cPath + "TikeP.Cdx" ) )

      dbUseArea( .t., cDriver(), cPath + "TikeC.Dbf", cCheckArea( "TiketC", @dbfTikC ), .f. )
      ( dbfTikC )->( ordListAdd( cPath + "TikeC.Cdx" ) )

      dbUseArea( .t., cDriver(), cPath + "TikeM.Dbf", cCheckArea( "TiketM", @dbfMesas ), .f. )
      ( dbfMesas )->( ordListAdd( cPath + "TikeM.Cdx" ) )

      dbUseArea( .t., cDriver(), cPathOld + "TikeT.Dbf", cCheckArea( "TIKET",  @oldTikT ), .f. )
      ( oldTikT )->( ordListAdd( cPathOld + "TikeT.Cdx" ) )
      ( oldTikT )->( ordSetFocus( "cLiqVal" ) )

      dbUseArea( .t., cDriver(), cPathOld + "TikeL.Dbf", cCheckArea( "TIKETL", @oldTikL ), .f. )
      ( oldTikL )->( ordListAdd( cPathOld + "TikeL.Cdx" ) )

      dbUseArea( .t., cDriver(), cPathOld + "TikeP.Dbf", cCheckArea( "TIKETP", @oldTikP ), .f. )
      ( oldTikP )->( ordListAdd( cPathOld + "TikeP.Cdx" ) )

      dbUseArea( .t., cDriver(), cPathOld + "TikeC.Dbf", cCheckArea( "TiketC", @oldTikC ), .f. )
      ( oldTikC )->( ordListAdd( cPathOld + "TikeC.Cdx" ) )

      dbUseArea( .t., cDriver(), cPathOld + "TikeM.Dbf", cCheckArea( "TikeM", @oldMesas ), .f. )
      ( oldMesas )->( ordListAdd( cPathOld + "TikeM.Cdx" ) )

      dbUseArea( .t., cDriver(), cPathOld + "TiketImp.Dbf", cCheckArea( "TiketImp", @oldImp ), .f. )
      ( oldImp )->( ordListAdd( cPath + "TiketImp.Cdx" ) )

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
      Mesas bloqueadas---------------------------------------------------------
      */

      ( oldMesas )->( dbGoTop() )
      while !( oldMesas )->( eof() )
         dbCopy( oldMesas, dbfMesas, .t. )
         ( oldMesas )->( dbSkip() )
      end while

      /*
      Reemplaza la antigua sesion----------------------------------------------
      */

      ( dbfTikT )->( dbEval( {|| ( dbfTikT )->cTurTik := Space( 6 ) },,,,, .f. ) )

      /*
      Cerramos las bases de datos----------------------------------------------
      */

      CLOSE( dbfTikT  )
      CLOSE( dbfTikL  )
      CLOSE( dbfTikP  )
      CLOSE( dbfTikC  )
      CLOSE( dbfImp   )
      CLOSE( dbfMesas )

      CLOSE( oldTikT  )
      CLOSE( oldTikL  )
      CLOSE( oldTikP  )
      CLOSE( oldTikC  )
      CLOSE( oldImp   )
      CLOSE( oldMesas )

   end if

Return nil

//--------------------------------------------------------------------------//

FUNCTION rxTpv( cPath, oMeter )

	local dbfTikT
	local dbfTikL
   local dbfTikP
   local dbfTikC
   local dbfTikM
   local dbfTikS
   local dbfImp

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

   if !lExistTable( cPath + "TIKEM.DBF" )
      dbCreate( cPath + "TIKEM.DBF", aSqlStruct( aMesTik() ), cDriver() )
   end if

   if !lExistTable( cPath + "TIKES.DBF" )
      dbCreate( cPath + "TIKES.DBF", aSqlStruct( aSerTik() ), cDriver() )
   end if

   if !lExistTable( cPath + "TIKETIMP.DBF" )
      dbCreate( cPath + "TIKETIMP.DBF", aSqlStruct( aImpTik() ), cDriver() )
   end if

   fEraseIndex( cPath + "TikeT.Cdx" )

   fEraseIndex( cPath + "TikeL.Cdx" )

   fEraseIndex( cPath + "TikeP.Cdx" )

   fEraseIndex( cPath + "TikeC.Cdx" )

   fEraseIndex( cPath + "TikeM.Cdx" )

   fEraseIndex( cPath + "TikeS.Cdx" )

   fEraseIndex( cPath + "TiketImp.Cdx" )

   /*
   Apertura de ficheros--------------------------------------------------------
   */

   dbUseArea( .t., cDriver(), cPath + "TIKET.DBF", cCheckArea( "TIKET", @dbfTikT ), .f. )

   if !( dbfTikT )->( neterr() )
      ( dbfTikT )->( __dbPack() )

      ( dbfTikT )->( ordCondSet( "!Deleted()", {||!Deleted()}  ) )
      ( dbfTikT )->( ordCreate( cPath + "TIKET.CDX", "CNUMTIK", "CSERTIK + CNUMTIK + CSUFTIK", {|| Field->cSerTik + Field->cNumTik + Field->cSufTik } ) )

      ( dbfTikT )->( ordCondSet( "!Deleted()", {||!Deleted()}  ) )
      ( dbfTikT )->( ordCreate( cPath + "TIKET.CDX", "DFECTIK", "DFECTIK", {|| Field->DFECTIK } ) )

      ( dbfTikT )->( ordCondSet( "!Deleted()", {||!Deleted()}  ) )
      ( dbfTikT )->( ordCreate( cPath + "TIKET.CDX", "CCLITIK", "CCLITIK", {|| Field->CCLITIK } ) )

      ( dbfTikT )->( ordCondSet( "!Deleted()", {||!Deleted()}  ) )
      ( dbfTikT )->( ordCreate( cPath + "TIKET.CDX", "CNOMTIK", "CNOMTIK", {|| Field->CNOMTIK } ) )

      ( dbfTikT )->( ordCondSet( "!Deleted()", {||!Deleted()}  ) )
      ( dbfTikT )->( ordCreate( cPath + "TIKET.CDX", "CNCJTIK", "CCCJTIK", {|| Field->CNCJTIK } ) )

      ( dbfTikT )->( ordCondSet( "!Deleted()", {||!Deleted()}  ) )
      ( dbfTikT )->( ordCreate( cPath + "TIKET.CDX", "CCCJTIK", "CCCJTIK", {|| Field->CCCJTIK } ) )

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

      ( dbfTikT )->( ordCondSet( "!Deleted() .and. cTipTik == '6'", {||!Deleted() .and. Field->cTipTik == '6' }  ) )
      ( dbfTikT )->( ordCreate( cPath + "TIKET.CDX", "cDocVal", "cValDoc", {|| Field->cValDoc } ) )

      ( dbfTikT )->( ordCondSet( "!Deleted() .and. cTipTik == '6'", {||!Deleted() .and. Field->cTipTik == '6' }  ) )
      ( dbfTikT )->( ordCreate( cPath + "TIKET.CDX", "cNumVal", "cSerTik + cNumTik + cSufTik", {|| Field->cSerTik + Field->cNumTik + Field->cSufTik } ) )

      ( dbfTikT )->( ordCondSet( "!Deleted() .and. cTipTik == '6' .and. !lLiqTik", {||!Deleted() .and. Field->cTipTik == '6' .and. !Field->lLiqTik }  ) )
      ( dbfTikT )->( ordCreate( cPath + "TIKET.CDX", "cLiqVal", "cSerTik + cNumTik + cSufTik", {|| Field->cSerTik + Field->cNumTik + Field->cSufTik } ) )

      ( dbfTikT )->( ordCondSet( "!Deleted() .and. lLiqTik", {|| !Deleted() .and. Field->lLiqTik }  ) )
      ( dbfTikT )->( ordCreate( cPath + "TIKET.CDX", "cTurVal", "cTurVal + cSufTik + cNcjTik", {|| Field->cTurVal + Field->cSufTik + Field->cNcjTik } ) )

      ( dbfTikT )->( ordCondSet( "!Deleted() .and. ( cTipTik == '1' .or. cTipTik == '7' ) .and. !lPgdTik .and. !lCloTik", {|| !Deleted() .and. Field->cTipTik == '1' .and. !Field->lPgdTik .and. !Field->lCloTik } ) )
      ( dbfTikT )->( ordCreate( cPath + "TIKET.CDX", "cCodSal", "cCodSala + cPntVenta", {|| Field->cCodSala + Field->cPntVenta } ) )

      ( dbfTikT )->( ordCondSet( "!Deleted().and. cTipTik == '6' .and. !lLiqTik", {|| !Deleted() .and. Field->cTipTik == '6' .and. !Field->lLiqTik }  ) )
      ( dbfTikT )->( ordCreate( cPath + "TIKET.CDX", "cCliVal", "cCliTik", {|| Field->cCliTik } ) )

      ( dbfTikT )->( ordCondSet( "!Deleted().and. cTipTik == '6' .and. !lLiqTik", {|| !Deleted() .and. Field->cTipTik == '6' .and. !Field->lLiqTik }  ) )
      ( dbfTikT )->( ordCreate( cPath + "TIKET.CDX", "cNomVal", "cNomTik", {|| Field->cNomTik } ) )

      ( dbfTikT )->( ordCondSet( "!Deleted() .and. cTipTik == '6' .and. !lLiqTik", {|| !Deleted() .and. Field->cTipTik == '6' .and. !Field->lLiqTik }  ) )
      ( dbfTikT )->( ordCreate( cPath + "TIKET.CDX", "cTikVal", "cTikVal", {|| Field->cTikVal } ) )

      ( dbfTikT )->( ordCondSet( "!Deleted() .and. !Field->lLiqTik .and. ( cTipTik == '1' .or. cTipTik == '7' )", {||!Deleted() .and. !Field->lLiqTik .and. ( Field->cTipTik == '1' .or. Field->cTipTik == '7' ) }  ) )
      ( dbfTikT )->( ordCreate( cPath + "TIKET.CDX", "lCliTik", "cCliTik", {|| Field->cCliTik } ) )

      ( dbfTikT )->( ordCondSet( "!Deleted()", {|| !Deleted() }  ) )
      ( dbfTikT )->( ordCreate( cPath + "TIKET.CDX", "cValTik", "cTikVal", {|| Field->cTikVal } ) )

      ( dbfTikT )->( ordCondSet( "!Deleted() .and. !lCloTik", {|| !Deleted() .and. !Field->lCloTik } ) )
      ( dbfTikT )->( ordCreate( cPath + "TikeT.Cdx", "lCloTik", "cSerTik + cNumTik + cSufTik", {|| Field->cSerTik + Field->cNumTik + Field->cSufTik } ) )

      ( dbfTikT )->( ordCondSet( "!Deleted() .and. lAbierto", {|| !Deleted() .and. Field->lAbierto } ) )
      ( dbfTikT )->( ordCreate( cPath + "TikeT.Cdx", "nUbiTik", "Str( nUbiTik )", {|| Str( Field->nUbiTik ) } ) )

      ( dbfTikT )->( ordCondSet( "!Deleted() .and. !lCloTik .and. !lPgdTik", {|| !Deleted() .and. !Field->lCloTik .and. !Field->lPgdTik } ) )
      ( dbfTikT )->( ordCreate( cPath + "TikeT.Cdx", "lCloUbiTik", "Str( nUbiTik ) + cSerTik + cNumTik + cSufTik", {|| Str( Field->nUbiTik ) + Field->cSerTik + Field->cNumTik + Field->cSufTik } ) )

      ( dbfTikT )->( ordCondSet( "!Deleted()", {||!Deleted()}  ) )
      ( dbfTikT )->( ordCreate( cPath + "TikeT.Cdx", "iNumTik", "'12' + CSERTIK + CNUMTIK + CSUFTIK", {|| '12' + Field->cSerTik + Field->cNumTik + Field->cSufTik } ) )

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

      ( dbfTikL )->( ordCondSet("!Deleted() .and. cTipTil == '6' ", {||!Deleted()  .and. Field->cTipTil == '6' } ) )
      ( dbfTikL )->( ordCreate( cPath + "TIKEL.CDX", "cTikVal", "CSERTIL + CNUMTIL + CSUFTIL", {|| Field->CSERTIL + Field->CNUMTIL + Field->CSUFTIL } ) )

      ( dbfTikL )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( dbfTikL )->( ordCreate( cPath + "TIKEL.CDX", "nOrTImp", "nOrTImp", {|| Field->nOrTImp } ) )

      ( dbfTikL )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfTikL )->( ordCreate( cPath + "TIKEL.CDX", "CNUMCBA", "CSERTIL + CNUMTIL + CSUFTIL + CCBATIL", {|| Field->CSERTIL + Field->CNUMTIL + Field->CSUFTIL + Field->CCBATIL } ) )

      ( dbfTikL )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfTikL )->( ordCreate( cPath + "TikeL.Cdx", "cNumDev", "cNumDev + Str( nNumLin )", {|| Field->cNumDev + Str( Field->nNumLin ) } ) )

      ( dbfTikL )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfTikL )->( ordCreate( cPath + "TikeL.Cdx", "cDevTik", "cNumDev", {|| Field->cNumDev } ) )

      ( dbfTikL )->( ordCondSet( "!Deleted()", {||!Deleted()}  ) )
      ( dbfTikL )->( ordCreate( cPath + "TikeL.Cdx", "iNumTik", "'12' + cSerTil + cNumTil + cSufTil", {|| '12' + Field->cSerTil + Field->cNumTil + Field->cSufTil } ) )

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

      ( dbfTikP )->( ordCondSet( "!Deleted()", {||!Deleted()}  ) )
      ( dbfTikP )->( ordCreate( cPath + "TikeP.Cdx", "iNumTik", "'12' + cSerTik + cNumTik + cSufTik", {|| '12' + Field->cSerTik + Field->cNumTik + Field->cSufTik } ) )

      ( dbfTikP )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de tikets" )
   end if

   dbUseArea( .t., cDriver(), cPath + "TIKEC.DBF", cCheckArea( "TIKEC", @dbfTikC ), .f. )
   if !( dbfTikC )->( neterr() )

      ( dbfTikC )->( __dbPack() )

      ( dbfTikC )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( dbfTikC )->( ordCreate( cPath + "TIKEC.CDX", "nNumPgo", "Str( nNumPgo ) + cSufPgo", {|| Str( Field->nNumPgo ) + Field->cSufPgo } ) )

      ( dbfTikC )->( ordCondSet( "!Deleted()", {|| !Deleted() }  ) )
      ( dbfTikC )->( ordCreate( cPath + "TIKEC.CDX", "cCodCli", "cCodCli", {|| Field->cCodCli } ) )

      ( dbfTikC )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de tikets" )
   end if

  dbUseArea( .t., cDriver(), cPath + "TIKETIMP.DBF", cCheckArea( "TIKETIMP", @dbfImp ), .f. )
   if !( dbfImp )->( neterr() )
      ( dbfImp )->( __dbPack() )

      ( dbfImp )->( ordCondSet( "!Deleted()", {||!Deleted() } ) )
      ( dbfImp )->( ordCreate( cPath + "TIKETIMP.CDX", "CNUMTIL", "CSERTIK + CNUMTIK + CSUFTIK", {|| Field->CSERTIK + Field->CNUMTIK + Field->CSUFTIK } ) )

      ( dbfImp )->( ordCondSet( "!Deleted() .AND. !LIMP ", {||!Deleted() .AND. !Field->LIMP } ) )
      ( dbfImp )->( ordCreate( cPath + "TIKETIMP.CDX", "CIMPTIK", "CSERTIK + CNUMTIK + CSUFTIK", {|| Field->CSERTIK + Field->CNUMTIK + Field->CSUFTIK } ) )

      ( dbfImp )->( ordCondSet( "!Deleted() .AND. !LIMP .AND. !LCOMANDA", {||!Deleted() .AND. !Field->LIMP .AND. !Field->LCOMANDA } ) )
      ( dbfImp )->( ordCreate( cPath + "TIKETIMP.CDX", "CCOMANDA", "CSERTIK + CNUMTIK + CSUFTIK", {|| Field->CSERTIK + Field->CNUMTIK + Field->CSUFTIK } ) )

      ( dbfImp )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de Impresion" )
   end if

   dbUseArea( .t., cDriver(), cPath + "TikeM.DBF", cCheckArea( "TIKEM", @dbfTikM ), .f. )
   if !( dbfTikM )->( neterr() )
      ( dbfTikM )->( __dbPack() )

      ( dbfTikM )->( ordCondSet( "!Deleted()", {||!Deleted() } ) )
      ( dbfTikM )->( ordCreate( cPath + "TikeM.CDX", "cMesa", "cCodSala + cPntVenta", {|| Field->cCodSala + Field->cPntVenta } ) )

      ( dbfTikM )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de mesas libres" )
   end if

   dbUseArea( .t., cDriver(), cPath + "TikeS.Dbf", cCheckArea( "TikeS", @dbfTikS ), .f. )
   if !( dbfTikS )->( neterr() )
      ( dbfTikS )->( __dbPack() )

      ( dbfTikS )->( ordCondSet( "!Deleted()", {||!Deleted()}  ) )
      ( dbfTikS )->( ordCreate( cPath + "TikeS.Cdx", "nNumTik", "cSerTik + cNumTik + cSufTik + Str( nNumLin )", {|| Field->cSerTik + Field->cNumTik + Field->cSufTik + Str( Field->nNumLin ) } ) )

      ( dbfTikS )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( dbfTikS )->( ordCreate( cPath + "TikeS.Cdx", "cRefSer", "cCbaTil + cAlmLin + cNumSer", {|| Field->cCbaTil + Field->cAlmLin + Field->cNumSer } ) )

      ( dbfTikS )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( dbfTikS )->( ordCreate( cPath + "TikeS.Cdx", "cNumSer", "cNumSer", {|| Field->cNumSer } ) )

      ( dbfTikS )->( ordCondSet( "!Deleted()", {||!Deleted()}  ) )
      ( dbfTikS )->( ordCreate( cPath + "TikeS.Cdx", "iNumTik", "'12' + cSerTik + cNumTik + cSufTik", {|| '12' + Field->cSerTik + Field->cNumTik + Field->cSufTik } ) )

      ( dbfTikS )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de numeros de series" )
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

function aMesTik()

   local aMesTik  := {}

   aAdd( aMesTik , { "cCodSala", "C",      3,     0, "Código de sala" }            )
   aAdd( aMesTik , { "cPntVenta","C",     30,     0, "Punto de venta" }            )

RETURN ( aMesTik )

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

   aAdd( aItmTik, { "cSerTik",  "C",      1,     0, "Serie del tiket" }                                       )
   aAdd( aItmTik, { "cNumTik",  "C",     10,     0, "Número del tiket" }                                      )
   aAdd( aItmTik, { "cSufTik",  "C",      2,     0, "Sufijo del tiket" }                                      )
   aAdd( aItmTik, { "cTipTik",  "C",      1,     0, "Tipo del documento" }                                    )
   aAdd( aItmTik, { "cTurTik",  "C",      6,     0, "Sesión del tiket" }                                      )
   aAdd( aItmTik, { "dFecTik",  "D",      8,     0, "Fecha del tiket" }                                       )
   aAdd( aItmTik, { "cHorTik",  "C",      5,     0, "Hora del tiket" }                                        )
   aAdd( aItmTik, { "cCcjTik",  "C",      3,     0, "Código del cajero" }                                     )
   aAdd( aItmTik, { "cNcjTik",  "C",      3,     0, "Código de caja" }                                        )
   aAdd( aItmTik, { "cAlmTik",  "C",      3,     0, "Código del almacén" }                                    )
   aAdd( aItmTik, { "cCliTik",  "C",     12,     0, "Código del cliente" }                                    )
   aAdd( aItmTik, { "nTarifa",  "N",      1,     0, "Tarifa de precios" }                                     )
   aAdd( aItmTik, { "cNomTik",  "C",     80,     0, "Nombre del cliente" }                                    )
   aAdd( aItmTik, { "cDirCli",  "C",    100,     0, "Domicilio del cliente" }                                 )
   aAdd( aItmTik, { "cPobCli",  "C",     35,     0, "Población del cliente" }                                 )
   aAdd( aItmTik, { "cPrvCli",  "C",     20,     0, "Provincia del cliente" }                                 )
   aAdd( aItmTik, { "nCodProv", "N",      2,     0, "Número de provincia cliente" }                           )
   aAdd( aItmTik, { "cPosCli",  "C",     15,     0, "Código postal del cliente" }                             )
   aAdd( aItmTik, { "cDniCli",  "C",     30,     0, "DNI/Cif del cliente" }                                   )
   aAdd( aItmTik, { "lModCli",  "L",      1,     0, "Lógico de modificar datos del cliente" }                 )
   aAdd( aItmTik, { "cFpgTik",  "C",      2,     0, "Forma de pago del tiket" }                               )
   aAdd( aItmTik, { "nCobTik",  "N",     16,     6, "Importe cobrado" }                                       )
   aAdd( aItmTik, { "nCamTik",  "N",     16,     6, "Devolución" }                                            )
   aAdd( aItmTik, { "cDivTik",  "C",      3,     0, "Código de la divisa" }                                   )
   aAdd( aItmTik, { "nVdvTik",  "N",     10,     3, "Valor de la divisa" }                                    )
   aAdd( aItmTik, { "lCloTik",  "L",      1,     0, "Lógico de cerrado" }                                     )
   aAdd( aItmTik, { "lSndDoc",  "L",      1,     0, "Lógico de enviado" }                                     )
   aAdd( aItmTik, { "lPgdTik",  "L",      1,     0, "Lógico de pagado" }                                      )
   aAdd( aItmTik, { "cRetPor",  "C",    100,     0, "Retirado por" }                                          )
   aAdd( aItmTik, { "cRetMat",  "C",     20,     0, "Matrícula" }                                             )
   aAdd( aItmTik, { "cNumDoc",  "C",     12,     0, "Número del documento" }                                  )
   aAdd( aItmTik, { "cCodAge",  "C",      3,     0, "Código del agente" }                                     )
   aAdd( aItmTik, { "cCodRut",  "C",      4,     0, "Código de la ruta" }                                     )
   aAdd( aItmTik, { "cCodTar",  "C",      5,     0, "Código de la tarifa" }                                   )
   aAdd( aItmTik, { "cCodObr",  "C",     10,     0, "Código de la obra" }                                     )
   aAdd( aItmTik, { "nComAge",  "N",      6,     2, "Porcentaje de comisión del agente" }                     )
   aAdd( aItmTik, { "lLiqTik",  "L",      1,     0, "Tiket liquidado" }                                       )
   aAdd( aItmTik, { "cCodPro",  "C",      9,     0, "Código de proyecto en contabilidad"}                     )
   aAdd( aItmTik, { "lConTik",  "L",      1,     0, "Tiket contabilizado" }                                   )
   aAdd( aItmTik, { "dFecCre",  "D",      8,     0, "Fecha de creación del documento" }                       )
   aAdd( aItmTik, { "cTimCre",  "C",      5,     0, "Hora de creación del documento" }                        )
   aAdd( aItmTik, { "lSelDoc",  "L",      1,     0, "" }                                                      )
   aAdd( aItmTik, { "cValDoc",  "C",     13,     0, "Número del vale relacionado" }                           )
   aAdd( aItmTik, { "cTurVal",  "C",      6,     0, "Sesión de la liquidación del vale" }                     )
   aAdd( aItmTik, { "lCnvTik",  "L",      1,     0, "Lógico para tiket convertido a factura" }                )
   aAdd( aItmTik, { "cCodDlg",  "C",      2,     0, "Código delegación" }                                     )
   aAdd( aItmTik, { "cCodGrp",  "C",      4,     0, "Código de grupo de cliente" }                            )
   aAdd( aItmTik, { "cCodSala", "C",      3,     0, "Código de sala" }                                        )
   aAdd( aItmTik, { "cPntVenta","C",     30,     0, "Punto de venta" }                                        )
   aAdd( aItmTik, { "lAbierto", "L",      1,     0, "Lógico de ticket abierto" }                              )
   aAdd( aItmTik, { "cAliasTik","C",     80,     0, "Alias del tiket" }                                       )
   aAdd( aItmTik, { "nNumCom",  "N",      2,     0, "Número de comensales" }                                  )
   aAdd( aItmTik, { "cAlbTik",  "C",     12,     0, "Número del albarán del que proviene" }                   )
   aAdd( aItmTik, { "cPedTik",  "C",     12,     0, "Número del pedido del que proviene" }                    )
   aAdd( aItmTik, { "cPreTik",  "C",     12,     0, "Número del presupuesto del que proviene" }               )
   aAdd( aItmTik, { "cDtoEsp",  "C",     50,     0, "Descripción de porcentaje de descuento especial" }       )
   aAdd( aItmTik, { "nDtoEsp",  "N",      6,     2, "Porcentaje de descuento especial" }                      )
   aAdd( aItmTik, { "cDpp",     "C",     50,     0, "Descripción de porcentaje de descuento por pronto pago" })
   aAdd( aItmTik, { "nDpp",     "N",      6,     2, "Porcentaje de descuento por pronto pago" }               )
   aAdd( aItmTik, { "nPctPrm",  "N",      6,     2, "Porcentaje de promoción por fidelización" }              )
   aAdd( aItmTik, { "cTikVal",  "C",     13,     0, "Numero del tiket de quien se genero el vale" }           )
   aAdd( aItmTik, { "cTlfCli",  "C",     20,     0, "Teléfono del cliente" }                                  )
   aAdd( aItmTik, { "lFreTik",  "L",      1,     0, "Ticket regalo" }                                         )
   aAdd( aItmTik, { "nTotNet",  "N",     16,     6, "Total neto" }                                            )
   aAdd( aItmTik, { "nTotIva",  "N",     16,     6, "Total " + cImp() }                                       )
   aAdd( aItmTik, { "nTotTik",  "N",     16,     6, "Total ticket" }                                          )
   aAdd( aItmTik, { "lLiqDev",  "L",      1,     0, "Liquidado por devolución" }                              )
   aAdd( aItmTik, { "nUbiTik",  "N",      1,     0, "Tipo de ubicación" }                                     )
   aAdd( aItmTik, { "nRegIva",  "N",      1,     0, "Régimen de " + cImp() }                                  )

return ( aItmTik )

//---------------------------------------------------------------------------//

function aColTik()

   local aColTik  :={}

   aAdd( aColTik, { "cSerTil",  "C",      1,     0, "Serie del tiket",                    "",                  "", "( cDbfCol )" } )
   aAdd( aColTik, { "cNumTil",  "C",     10,     0, "Número del tiket",                   "",                  "", "( cDbfCol )" } )
   aAdd( aColTik, { "cSufTil",  "C",      2,     0, "Sufijo del tiket",                   "",                  "", "( cDbfCol )" } )
   aAdd( aColTik, { "cTipTil",  "C",      1,     0, "Tipo de documento",                  "",                  "", "( cDbfCol )" } )
   aAdd( aColTik, { "cCbaTil",  "C",     18,     0, "Código del barras del producto",     "",                  "", "( cDbfCol )" } )
   aAdd( aColTik, { "cNomTil",  "C",    250,     0, "Nombre del producto",                "",                  "", "( cDbfCol )" } )
   aAdd( aColTik, { "nPvpTil",  "N",     16,     6, "Precio de venta del producto",       "",                  "", "( cDbfCol )" } )
   aAdd( aColTik, { "nUntTil",  "N",     16,     6, "Unidades vendidas del producto",     "",                  "", "( cDbfCol )" } )
   aAdd( aColTik, { "nUndKit",  "N",     16,     6, "Unidades productos kit",             "",                  "", "( cDbfCol )" } )
   aAdd( aColTik, { "nIvaTil",  "N",      5,     2, "Porcentaje de " + cImp() + " del producto",     "",       "", "( cDbfCol )" } )
   aAdd( aColTik, { "cFamTil",  "C",      5,     0, "Família la que pertenece el producto", "",                "", "( cDbfCol )" } )
   aAdd( aColTik, { "lOfeTil",  "L",      1,     0, "Oferta ya aplicada",                 "",                  "", "( cDbfCol )" } )
   aAdd( aColTik, { "cComTil",  "C",     18,     0, "Código de barras de combinado",      "",                  "", "( cDbfCol )" } )
   aAdd( aColTik, { "cNcmTil",  "C",    100,     0, "Nombre del producto combinado",      "",                  "", "( cDbfCol )" } )
   aAdd( aColTik, { "nPcmTil",  "N",     16,     6, "Precio de venta del producto combinado", "",              "", "( cDbfCol )" } )
   aAdd( aColTik, { "cFcmTil",  "C",      5,     0, "Familia la que pertenece el producto combinado", "",      "", "( cDbfCol )" } )
   aAdd( aColTik, { "lFreTil",  "L",      1,     0, "Lineas sin cargo",                   "",                  "", "( cDbfCol )" } )
   aAdd( aColTik, { "nDtoLin",  "N",      6,     2, "Descuento en linea",                 "'@E 999.9'",        "", "( cDbfCol )" } )
   aAdd( aColTik, { "cCodPr1",  "C",     10,     0, "Código de la primera propiedad",     "",                  "", "( cDbfCol )" } )
   aAdd( aColTik, { "cCodPr2",  "C",     10,     0, "Código de la segunda propiedad",     "",                  "", "( cDbfCol )" } )
   aAdd( aColTik, { "cValPr1",  "C",     10,     0, "Valor de la primera propiedad",      "",                  "", "( cDbfCol )" } )
   aAdd( aColTik, { "cValPr2",  "C",     10,     0, "Valor de la segunda propiedad",      "",                  "", "( cDbfCol )" } )
   aAdd( aColTik, { "nFacCnv",  "N",     16,     6, "Factor de conversión",               "",                  "", "( cDbfCol )" } )
   aAdd( aColTik, { "nDtoDiv",  "N",     16,     6, "Descuento lineal de la compra",      "",                  "", "( cDbfCol )" } )
   aAdd( aColTik, { "lTipAcc",  "L",      1,     0, "",                                   "",                  "", "( cDbfCol )" } )
   aAdd( aColTik, { "nCtlStk",  "N",      1,     0, "",                                   "",                  "", "( cDbfCol )" } )
   aAdd( aColTik, { "cAlmLin",  "C",      3,     0, "Código de almacén en línea",         "",                  "", "( cDbfCol )" } )
   aAdd( aColTik, { "nValImp",  "N",     16,     6, "Importe del impuesto",               "",                  "", "( cDbfCol )" } )
   aAdd( aColTik, { "cCodImp",  "C",      3,     0, "Código de IVMH",                     "",                  "", "( cDbfCol )" } )
   aAdd( aColTik, { "nCosDiv",  "N",     16,     6, "Precio de costo",                    "",                  "", "( cDbfCol )" } )
   aAdd( aColTik, { "nNumLin",  "N",      4,     0, "Número de la línea",                 "",                  "", "( cDbfCol )" } )
   aAdd( aColTik, { "lKitArt",  "L",      1,     0, "Línea con escandallo",               "",                  "", "( cDbfCol )" } )
   aAdd( aColTik, { "lKitChl",  "L",      1,     0, "Línea pertenciente a escandallo",    "",                  "", "( cDbfCol )" } )
   aAdd( aColTik, { "lKitPrc",  "L",      1,     0, "",                                   "",                  "", "( cDbfCol )" } )
   aAdd( aColTik, { "lImpLin",  "L",      1,     0, "Imprimir línea",                     "",                  "", "( cDbfCol )" } )
   aAdd( aColTik, { "nMesGrt",  "N",      2,     0, "Meses de garantía",                  "'99'",              "", "( cDbfCol )" } )
   aAdd( aColTik, { "lControl", "L",      1,     0, "",                                   "",                  "", "( cDbfCol )" } )
   aAdd( aColTik, { "mNumSer",  "M",     10,     0, "",                                   "",                  "", "( cDbfCol )" } )
   aAdd( aColTik, { "cCodFam",  "C",     16,     0, "Código de familia",                  "",                  "", "( cDbfCol )" } )
   aAdd( aColTik, { "cGrpFam",  "C",      3,     0, "Código del grupo de familia",        "",                  "", "( cDbfCol )" } )
   aAdd( aColTik, { "nLote",    "N",      9,     0, "",                                   "@Z 999999999",      "", "( cDbfCol )" } )
   aAdd( aColTik, { "cLote",    "C",     12,     0, "Número de lote",                     "",                  "", "( cDbfCol )" } )
   aAdd( aColTik, { "nNumPgo",  "N",      9,     0, "Número pago cliente",                "",                  "", "( cDbfCol )" } )
   aAdd( aColTik, { "cSufPgo",  "C",      2,     0, "Sufijo pago cliente",                "",                  "", "( cDbfCol )" } )
   aAdd( aColTik, { "nNumMed",  "N",      1,     0, "Número de mediciones",               "MasUnd()",          "", "( cDbfCol )" } )
   aAdd( aColTik, { "nMedUno",  "N",     16,     6, "Primera unidad de medición",         "MasUnd()",          "", "( cDbfCol )" } )
   aAdd( aColTik, { "nMedDos",  "N",     16,     6, "Segunda unidad de medición",         "MasUnd()",          "", "( cDbfCol )" } )
   aAdd( aColTik, { "nMedTre",  "N",     16,     6, "Tercera unidad de medición",         "MasUnd()",          "", "( cDbfCol )" } )
   aAdd( aColTik, { "cCodInv",  "C",      2,     0, "Código invitación",                  "",                  "", "( cDbfCol )" } )
   aAdd( aColTik, { "nFcmCnv",  "N",     16,     6, "Factor de conversion para combinados","",                 "", "( cDbfCol )" } )
   aAdd( aColTik, { "cCodUsr",  "C",      3,     0, "Código de usuario",                  "",                  "", "( cDbfCol )" } )
   aAdd( aColTik, { "lImpCom",  "L",      1,     0, "Lógico para comanda impresa",        "",                  "", "( cDbfCol )" } )
   aAdd( aColTik, { "nImpCom",  "N",      3,     0, "Numero de unidades impresas",        "",                  "", "( cDbfCol )" } )
   aAdd( aColTik, { "nImpCom1", "N",      1,     0, "Primera impresora comanda",          "",                  "", "( cDbfCol )" } )
   aAdd( aColTik, { "nImpCom2", "N",      1,     0, "Segunda impresora comanda",          "",                  "", "( cDbfCol )" } )
   aAdd( aColTik, { "cComent",  "C",    250,     0, "Comentario para el artículo",        "",                  "", "( cDbfCol )" } )
   aAdd( aColTik, { "cNomCmd",  "M",     10,     0, "Comentario para la comanda",         "",                  "", "( cDbfCol )" } )
   aAdd( aColTik, { "lInPromo", "L",      1,     0, "Lógico para linea en promoción",     "",                  "", "( cDbfCol )" } )
   aAdd( aColTik, { "lArtServ", "L",      1,     0, "Lógico para artículo servido",       "",                  "", "( cDbfCol )" } )
   aAdd( aColTik, { "cCodTImp", "C",      3,     0, "Codigo de tipo de comanda",          "",                  "", "( cDbfCol )" } )
   aAdd( aColTik, { "nOrTImp",  "N",      1,     0, "Orden de impresión tipo de comanda", "",                  "", "( cDbfCol )" } )
   aAdd( aColTik, { "cUnidad",  "C",      2,     0, "Unidades de venta",                  "" ,                 "", "( cDbfCol )" } )
   aAdd( aColTik, { "lDev",     "L",      1,     0, "Lógico para artículo devuelto",      "",                  "", "( cDbfCol )" } )
   aAdd( aColTik, { "cNumDev",  "C",     13,     0, "Número de devolución o vale",        "",                  "", "( cDbfCol )" } )
   aAdd( aColTik, { "nUndAnt",  "N",     16,     6, "Unidades anteriores",                "",                  "", "( cDbfCol )" } )
   aAdd( aColTik, { "lAnulado", "L",      1,     0, "Lógico línea anulada",               "",                  "", "( cDbfCol )" } )
   aAdd( aColTik, { "lLinOfe",  "L",      1,     0, "Línea con oferta",                   "",                  "", "( cDbfCol )" } )
   aAdd( aColTik, { "cImpCom1", "C",     50,     0, "Primer tipo impresora comanda",      "",                  "", "( cDbfCol )" } )
   aAdd( aColTik, { "cImpCom2", "C",     50,     0, "Segundo tipo impresora comanda",     "",                  "", "( cDbfCol )" } )
   aAdd( aColTik, { "dFecTik",  "D",      8,     0, "Fecha del tiket",                    "",                  "", "( cDbfCol )" } )
   aAdd( aColTik, { "nCosTil",  "N",     16,     6, "Precio de costo de combinado",       "",                  "", "( cDbfCol )" } )
   aAdd( aColTik, { "cTxtInv",  "C",     30,     0, "Texto invitación",                   "",                  "", "( cDbfCol )" } )
   aAdd( aColTik, { "cOrdOrd",  "C",      2,     0, "Código de orden de comanda",         "",                  "", "( cDbfCol )" } )
   aAdd( aColTik, { "cNomOrd",  "C",     30,     0, "Orden de comanda",                   "",                  "", "( cDbfCol )" } )
   aAdd( aColTik, { "lDelTil",  "L",      1,     0, "Línea borrada",                      "",                  "", "( cDbfCol )" } )

Return ( aColTik )

//---------------------------------------------------------------------------//

function aImpTik()

   local aImpTik  := {}

   aAdd( aImpTik, { "cSerTik",  "C",      1,    0, "Serie del tiket"                        } )
   aAdd( aImpTik, { "cNumTik",  "C",     10,    0, "Número del tiket"                       } )
   aAdd( aImpTik, { "cSufTik",  "C",      2,    0, "Sufijo del tiket"                       } )
   aAdd( aImpTik, { "lComanda", "L",      1,    0, "Lógio de comanda"                       } )
   aAdd( aImpTik, { "lImp",     "L",      1,    0, "Lógico de imprimido"                    } )
   aAdd( aImpTik, { "dFecTik",  "D",      8,    0, "Fecha mandado a impresion"              } )
   aAdd( aImpTik, { "cHorTik",  "C",      5,    0, "Hora mandado a impresion"               } )
   aAdd( aImpTik, { "dFTikImp", "D",      8,    0, "Fecha de impresion"                     } )
   aAdd( aImpTik, { "cHTikImp", "C",      5,    0, "Hora de impresion"                      } )

RETURN ( aImpTik )

//---------------------------------------------------------------------------//

function aSerTik()

   local aColTik  := {}

   aAdd( aColTik,  { "cSerTik", "C",      1,    0, "",                                 "",                  "", "( cDbfCol )" } )
   aAdd( aColTik,  { "cNumTik", "C",     10,    0, "",                                 "",                  "", "( cDbfCol )" } )
   aAdd( aColTik,  { "cSufTik", "C",      2,    0, "",                                 "",                  "", "( cDbfCol )" } )
   aAdd( aColTik,  { "cTipTil", "C",      1,    0, "Tipo de ticket",                   "",                  "", "( cDbfCol )" } )
   aAdd( aColTik,  { "dFecTik", "D",      8,    0, "Fecha de ticket",                  "",                  "", "( cDbfCol )" } )
   aAdd( aColTik,  { "nNumLin", "N",      4,    0, "Número de la línea",               "'9999'",            "", "( cDbfCol )" } )
   aAdd( aColTik,  { "cCbaTil", "C",     18,    0, "Referencia del artículo",          "",                  "", "( cDbfCol )" } )
   aAdd( aColTik,  { "cAlmLin", "C",      3,    0, "Almacen del artículo",             "",                  "", "( cDbfCol )" } )
   aAdd( aColTik,  { "lUndNeg", "L",      1,    0, "Lógico de valor absoluto",         "",                  "", "( cDbfCol )" } )
   aAdd( aColTik,  { "cNumSer", "C",     30,    0, "Número de serie",                  "",                  "", "( cDbfCol )" } )

return ( aColTik )

//---------------------------------------------------------------------------//

#ifndef __PDA__

FUNCTION nTotTik( cNumTik, cTikT, cTikL, cDiv, aTmp, cDivRet, lPic, lExcCnt )

   local bCond
   local nRecLin
   local nDouDiv
   local cCodDiv
   local nVdvDiv
   local cTipTik
   local nOrdAnt
   local nTotLin        := 0
   local nBasLin        := 0
   local nBrtLin        := 0
   local nIvmLin        := 0
   local nNumCom        := 0
   local nDtoEsp        := 0
   local nDpp           := 0
   local nDescuentoEsp  := 0
   local nDescuentoPp   := 0

   DEFAULT cTikT        := dbfTikT
   DEFAULT cTikL        := dbfTikL
   DEFAULT cDiv         := dbfDiv
   DEFAULT cNumTik      := ( dbfTikT )->cSerTik + ( dbfTikT )->cNumTik + ( dbfTikT )->cSufTik
   DEFAULT lPic         := .f.

   public nTotTik       := 0
   public nTotPrm       := 0
   public nTotPax       := 0
   public nTotDtoEsp    := 0
   public nTotDpp       := 0
   public nTotNet       := 0
   public nTotBrt       := 0
   public nTotIva       := 0
   public nTotIvm       := 0
   public aBrtTik       := { 0, 0, 0 }
   public aBasTik       := { 0, 0, 0 }
   public aImpTik       := { 0, 0, 0 }
   public aIvaTik       := { nil, nil, nil }
   public aIvmTik       := { 0, 0, 0 }
   public nTotCos       := 0
   public nTotRnt       := 0
   public nTotPctRnt    := 0

   nRecLin              := ( cTikL )->( Recno() )

   if aTmp != nil
      cCodDiv           := aTmp[ _CDIVTIK ]
      nVdvDiv           := aTmp[ _NVDVTIK ]
      cTipTik           := aTmp[ _CTIPTIK ]
      nNumCom           := aTmp[ _NNUMCOM ]
      nDtoEsp           := aTmp[ _NDTOESP ]
      nDpp              := aTmp[ _NDPP    ]
      bCond             := {|| !( cTikL )->( eof() ) }
      ( cTikL )->( dbGoTop() )
   else
      cCodDiv           := ( cTikT )->cDivTik
      nVdvDiv           := ( cTikT )->nVdvTik
      cTipTik           := ( cTikT )->cTipTik
      nNumCom           := ( cTikT )->nNumCom
      nDtoEsp           := ( cTikT )->nDtoEsp
      nDpp              := ( cTikT )->nDpp
      bCond             := {|| ( cTikL )->cSerTil + ( cTikL )->cNumTil + ( cTikL )->cSufTil == cNumTik .and. !( cTikL )->( eof() ) }
      nOrdAnt           := ( cTikL )->( OrdSetFocus( "cNumTil" ) )
      ( cTikL )->( dbSeek( cNumTik ) )
   end if

   nDouDiv              := nDouDiv( cCodDiv, cDiv )
   nDorDiv              := nRouDiv( cCodDiv, cDiv ) // Decimales de redondeo
   cPorDiv              := cPorDiv( cCodDiv, cDiv ) // Picture de la divisa redondeada

   while Eval( bCond )

      if lValLine( cTikL ) .and. !( cTikL )->lFreTil .and. !( cTikL )->lDelTil

         if ( lExcCnt == nil                                .or.;    // Entran todos
            ( lExcCnt .and. ( cTikL )->nCtlStk != 2 )       .or.;    // Articulos sin contadores
            (!lExcCnt .and. ( cTikL )->nCtlStk == 2 ) )              // Articulos con contadores

            nTotLin           := nTotLTpv( cTikL, nDouDiv, nDorDiv )

            if nDtoEsp != 0
               nDescuentoEsp  := ( nTotLin * nDtoEsp ) / 100
            else
               nDescuentoEsp  := 0
            end if

            if nDpp != 0
               nDescuentoPp   := ( nTotLin * nDpp ) / 100
            else
               nDescuentoPp   := 0
            end if

            nBasLin           := nTotLin - nDescuentoEsp - nDescuentoPp
            nIvmLin           := nIvmLTpv( cTikL, nDouDiv, nDorDiv )

            if ( cTikL )->nIvaTil != 0
               nBasLin        := nTotLin / ( 1 + ( ( cTikL )->nIvaTil / 100 ) )
            else
               nBasLin        := nTotLin
            end if

            do case
            case aIvaTik[ 1 ] == nil .or. aIvaTik[ 1 ] == ( cTikL )->nIvaTil

               aIvaTik[ 1 ]   := ( cTikL )->nIvaTil
               aBrtTik[ 1 ]   += nTotLin
               aBasTik[ 1 ]   += nBasLin
               aImpTik[ 1 ]   += ( nTotLin - nBasLin )
               aIvmTik[ 1 ]   += nIvmLin

            case aIvaTik[ 2 ] == nil .or. aIvaTik[ 2 ] == ( cTikL )->nIvaTil

               aIvaTik[ 2 ]   := ( cTikL )->nIvaTil
               aBrtTik[ 2 ]   += nTotLin
               aBasTik[ 2 ]   += nBasLin
               aImpTik[ 2 ]   += ( nTotLin - nBasLin )
               aIvmTik[ 2 ]   += nIvmLin

            case aIvaTik[ 3 ] == nil .or. aIvaTik[ 3 ] == ( cTikL )->nIvaTil

               aIvaTik[ 3 ]   := ( cTikL )->nIvaTil
               aBrtTik[ 3 ]   += nTotLin
               aBasTik[ 3 ]   += nBasLin
               aImpTik[ 3 ]   += ( nTotLin - nBasLin )
               aIvmTik[ 3 ]   += nIvmLin

            end case

            nTotTik           += nTotLin
            nTotDtoEsp        += nDescuentoEsp
            nTotDpp           += nDescuentoPp

            nTotCos           += ( cTikL )->nCosDiv

            if ( cTikL )->lInPromo
               nTotPrm        += nTotLin - nDescuentoEsp - nDescuentoPp
            end if

         end if

      end if

      ( cTikL )->( dbskip() )

   end while

   nTotBrt           := aBrtTik[ 1 ] + aBrtTik[ 2 ] + aBrtTik[ 3 ]
   nTotNet           := aBasTik[ 1 ] + aBasTik[ 2 ] + aBasTik[ 3 ]
   nTotIva           := aImpTik[ 1 ] + aImpTik[ 2 ] + aImpTik[ 3 ]
   nTotIvm           := aIvmTik[ 1 ] + aIvmTik[ 2 ] + aIvmTik[ 3 ]

   /*
   Quitamos los descuentos al total--------------------------------------------
   */

   nTotTik           -= nTotDtoEsp
   nTotTik           -= nTotDpp

   /*
   Total por persona-----------------------------------------------------------
   */

   nTotPax           := nTotTik / NotCero( nNumCom )

   /*
   Total rentabilidad----------------------------------------------------------
   */

   nTotRnt           := Round( nTotNet - nTotCos, nDorDiv )

   nTotPctRnt        := nRentabilidad( nTotNet, 0, nTotCos )

   /*
   Total con redondeo----------------------------------------------------------
   */

   nTotTik           := Round( nTotTik, nDorDiv )

   /*
   Si nos piden q devolvamos el valor en distinta divisa
   */

   /*
   if cDivRet != nil .and. cDivRet != cCodDiv
      nTotNet      := nCnv2Div( nTotNet, cCodDiv, cDivRet, cDiv )
      nTotIva      := nCnv2Div( nTotIva, cCodDiv, cDivRet, cDiv )
      nTotIvm      := nCnv2Div( nTotIvm, cCodDiv, cDivRet, cDiv )
      nTotTik      := nCnv2Div( nTotTik, cCodDiv, cDivRet, cDiv )
      nTotPax      := nCnv2Div( nTotPax, cCodDiv, cDivRet, cDiv )
      cPorDiv      := cPorDiv( cDivRet, cDiv ) // Picture de la divisa redondeada
   end if
   */

   /*
   Reposicionamiento-----------------------------------------------------------
   */

   if !Empty( nOrdAnt )
      ( cTikL )->( OrdSetFocus( nOrdAnt ) )
   end if

   ( cTikL )->( dbGoTo( nRecLin ) )

RETURN ( if( lPic, Trans( nTotTik, cPorDiv ), nTotTik ) )

#else

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

   /*
   if cDivRet != nil .and. cDivRet != cCodDiv
      nTotNet      := nCnv2Div( nTotNet, cCodDiv, cDivRet, cDiv )
      nTotIva      := nCnv2Div( nTotIva, cCodDiv, cDivRet, cDiv )
      nTotIvm      := nCnv2Div( nTotIvm, cCodDiv, cDivRet, cDiv )
      nTotTik      := nCnv2Div( nTotTik, cCodDiv, cDivRet, cDiv )
      nTotPax      := nCnv2Div( nTotPax, cCodDiv, cDivRet, cDiv )
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

#endif

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

         if ( uTmpL )->nDtoLin != 0
            nCalculo    -= ( uTmpL )->nDtoLin * nCalculo / 100  // Dto porcentual
         end if

         nCalculo       *= nTotNTpv( uTmpL )                    // Unidades

         nCalculo       -= Round( ( uTmpL )->nDtoDiv, nDec )    // Dto Lineal

      end if

   otherwise

      if !uTmpL:lFreTil

         nCalculo       := Round( uTmpL:nPvpTil, nDec )    // Precio

         if uTmpL:nDtoLin != 0
            nCalculo    -= uTmpL:nDtoLin * nCalculo / 100  // Dto porcentual
         end if

         nCalculo       *= nTotNTpv( uTmpL )               // Unidades

         nCalculo       -= Round( uTmpL:nDtoDiv, nDec )    // Dto Lineal

      end if

   end case

   if nVdv != 0
      nCalculo          := nCalculo / nVdv
   end if

RETURN ( Round( nCalculo, nRouDec ) )

//---------------------------------------------------------------------------//

Function nDtoLTpv( uTmpL, nDec, nRouDec, nVdv )

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

      if !( uTmpL )->lFreTil .and. ( uTmpL )->nDtoLin != 0

         nCalculo       := Round( ( uTmpL )->nPvpTil, nDec )    // Precio

         nCalculo       *= nTotNTpv( uTmpL )                    // Unidades

         nCalculo       := ( uTmpL )->nDtoLin * nCalculo / 100  // Dto porcentual

      end if

   otherwise

      if !uTmpL:lFreTil .and. uTmpL:nDtoLin != 0

         nCalculo       := Round( uTmpL:nPvpTil, nDec )        // Precio

         nCalculo       *= nTotNTpv( uTmpL )                   // Unidades

         nCalculo       := uTmpL:nDtoLin * nCalculo / 100      // Dto porcentual

      end if

   end case

   if nVdv != 0
      nCalculo          := nCalculo / nVdv
   end if

RETURN ( Round( nCalculo, nRouDec ) )

//---------------------------------------------------------------------------//

Function nCosLTpv( uTmpL, nDec, nRouDec, nVdv, nPrc )

   local nCalculo    := 0

   DEFAULT uTmpL     := dbfTikL
   DEFAULT nDec      := nDouDiv()
   DEFAULT nRouDec   := nRouDiv()
   DEFAULT nVdv      := 0
   DEFAULT nPrc      := 0

   /*
   Siempre q el ticket no sea gratis
   */

   do case
   case IsChar( uTmpL )

      if nPrc == 0 .or. nPrc == 1
         nCalculo    += Round( ( uTmpL )->nCosDiv, nDec )   // Costo
      end if

      if nPrc == 0 .or. nPrc == 2
         nCalculo    += Round( ( uTmpL )->nCosTil, nDec )   // Costo
      end if

   case IsObject( uTmpL )

      if nPrc == 0 .or. nPrc == 1
         nCalculo    += Round( uTmpL:nCosDiv, nDec )        // Costo
      end if

      if nPrc == 0 .or. nPrc == 2
         nCalculo    += Round( uTmpL:nCosTil, nDec )        // Costo
      end if

   end case

   nCalculo          *= nTotNTpv( uTmpL )                   // Unidades

   if nVdv != 0
      nCalculo       := nCalculo / nVdv
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

//---------------------------------------------------------------------------//
/*
Devuelve las unidades de una linea en las comandas
*/

FUNCTION nTotNComandas()

   local nTotNTpv    := 0

   if !Empty( dbfTmpC )
      nTotNTpv       := ( dbfTmpC )->nUntTil
      nTotNTpv       *= NotCero( ( dbfTmpC )->nUndKit )
      RETURN ( nTotNTpv )
   end if

   if !Empty( dbfTikL )
      nTotNTpv       := ( dbfTikL )->nUntTil
      nTotNTpv       *= NotCero( ( dbfTikL )->nUndKit )
   end if

RETURN ( nTotNTpv )

//----------------------------------------------------------------------------//
/*
Recalcula el total
*/

STATIC FUNCTION lRecTotal( aTmp, lRefreshTotal )

   local nTotal

   DEFAULT lRefreshTotal   := .t.

   nTotal                  := nTotTik( aTmp[ _CSERTIK ] + aTmp[ _CNUMTIK ] + aTmp[ _CSUFTIK ], dbfTikT, dbfTmpL, dbfDiv, aTmp, nil, .f. )

   if oTotEsp != nil
      oTotEsp:Refresh()
   end if

   if oTotDpp != nil
      oTotDpp:Refresh()
   end if

   if lRefreshTotal

      if oNumTot != NIL
         oNumTot:SetText( Trans( nTotal, cPorDiv ) )
      end if

   end if

   if oTotPdaFam != NIL
      oTotPdaFam:SetText( Trans( nTotal, cPorDiv ) )
   end if

   if oEurTot != NIL
      oEurTot:SetText( Trans( nCnv2Div( nTotal, aTmp[ _CDIVTIK ], cDivChg(), dbfDiv ), cPicEur ) )
   end if

   if lRefreshTotal

      if oTxtTot != NIL
         oTxtTot:SetText( "Total" )
      end if

   end if

   if oTxtCom != nil
      oTxtCom:SetText( "Comensales: " + AllTrim( Str( aTmp[ _NNUMCOM ] ) ) )
   end if

   if oTotCom != nil
      oTotCom:SetText( AllTrim( Trans( nTotal / NotCero( aTmp[ _NNUMCOM ] ), cPorDiv ) ) + " pax." )
   end if

   if oGetRnt != nil
      oGetRnt:SetText( AllTrim( Trans( nTotRnt, cPorDiv ) + Space( 1 ) + "€ : " + AllTrim( Trans( nTotPctRnt, "999.99" ) ) + "%" ) )
   end if

RETURN .T.

//--------------------------------------------------------------------------//
// Devuelve el total de cobrado en un tiket
//

Function nTotCobTik( cNumTik, dbfTikP, dbfDiv, cDivRet, lPic )

   local bCon
   local cPorDiv
   local nDorDiv
   local nTotal      := 0
   local cCodDiv     := ( dbfTikP )->cDivPgo
   local aSta        := aGetStatus( dbfTikP, .t. )

   DEFAULT lPic      := .f.

   if cNumTik == nil
      bCon           := {|| !( dbfTikP )->( eof() ) }
      ( dbfTikP )->( dbGoTop() )
   else
      bCon           := {|| ( dbfTikP )->cSerTik + ( dbfTikP )->cNumTik + ( dbfTikP )->cSufTik == cNumTik .and. !( dbfTikP )->( eof() ) }
      ( dbfTikP )->( dbSeek( cNumTik ) )
   end if

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
      nTotal         := nCnv2Div( nTotal, cCodDiv, cDivRet, dbfDiv )
   end if

Return ( if( lPic, Trans( nTotal, cPorDiv ), nTotal ) )

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

//----------------------------------------------------------------------------//

Static Function ChangeComentarios( cComentariosT, cComentariosL, oBrwLineasComentarios )

   DEFAULT cComentariosT     := dbfComentariosT
   DEFAULT cComentariosL     := dbfComentariosL

   /*
   Creamos un OrdSCope por arriba y por abajo----------------------------------
   */

   ( cComentariosL )->( OrdScope( 0, ( cComentariosT )->cCodigo ) )
   ( cComentariosL )->( OrdScope( 1, ( cComentariosT )->cCodigo ) )

   /*
   Refrescos en pantalla-------------------------------------------------------
   */

   oBrwLineasComentarios:GoTop()
   oBrwLineasComentarios:Select( 0 )
   oBrwLineasComentarios:Select( 1 )
   oBrwLineasComentarios:Refresh( .t. )

return nil

//---------------------------------------------------------------------------//

Static Function ChangeLineasComentarios( oGetComentario, cComentariosL )

   local cText := AllTrim( oGetComentario:VarGet() )

   DEFAULT cComentariosL     := dbfComentariosL

   if Empty( cText )
      cText := AllTrim( ( cComentariosL )->cDescri )
   else
      cText += ", " + AllTrim( ( cComentariosL )->cDescri )
   end if

   oGetComentario:cText( Padr( cText, 250 ) )

Return ( nil )

//----------------------------------------------------------------------------//

Static Function EndComentario( oDlg, dbfTmpL, oGetComentario )

   local cText             := oGetComentario:VarGet()

   if dbLock( dbfTmpL )
      ( dbfTmpL )->cComent := AllTrim( cText )
      ( dbfTmpL )->( dbUnLock() )
   end if

   oDlg:End( IDOK )

return ( nil )

//---------------------------------------------------------------------------//

Static Function YearComboBoxChange()

    if oWndBrw:oWndBar:lAllYearComboBox()
      DestroyFastFilter( dbfTikT )
      CreateUserFilter( "", dbfTikT, .f., , , "all" )
	 else
		DestroyFastFilter( dbfTikT )
      CreateUserFilter( "Year( Field->dFecTik ) == " + oWndBrw:oWndBar:cYearComboBox(), dbfTikT, .f., , , "Year( Field->dFecTik ) == " + oWndBrw:oWndBar:cYearComboBox() )
	 end if

	 ( dbfTikT )->( dbGoTop() )

	 oWndBrw:Refresh()

Return nil

//---------------------------------------------------------------------------//

FUNCTION cUpSerie( cSer )

   local nAsc
   local cChr

   if Empty( cSer ) .or. cSer < "A"
      cSer     := "A"
      nAsc     := Asc( cSer )
   else
      nAsc     := Asc( cSer ) + 1
   end if

   cChr        := Chr( nAsc )

   if cChr > "Z"
      cChr     := "Z"
   end if

return cChr

//---------------------------------------------------------------------------//

FUNCTION cDwSerie( cSer )

   local nAsc
   local cChr
   local cSerie

   nAsc        := Asc( cSer ) - 1
   cChr        := Chr( nAsc )

   if cChr < "A"
      cChr     := "A"
   end if

return cChr

//---------------------------------------------------------------------------//

Static Function SetLostFocusOn()

   oDlgDet:Cargo           := .t.

Return ( .t. )

//----------------------------------------------------------------------------//

Static Function SetLostFocusOff()

   oDlgDet:Cargo           := .f.

Return ( .t. )

//---------------------------------------------------------------------------//

Static Function DlgLostFocus( nMode, aTmp )

   if IsLogic( oDlgDet:Cargo ) .and. ( oDlgDet:Cargo )

      if ( nMode != APPD_MODE ) .or. ( Empty( aTmp[ _CCBATIL ] ) .and. Empty( aTmp[ _CNOMTIL ] ) )

         oDlgDet:End()

      end if

   end if

Return ( .t. )

//---------------------------------------------------------------------------//

#ifndef __PDA__

Static Function lFidelity( aGet, aTmp, nMode )

   local oDlg

   if !uFieldEmpresa( "lFidelity" )
      return .f.
   end if

   if nMode != APPD_MODE
      return .f.
   end if

   if !Empty( aTmp[ _CCLITIK ] ) .and. ( aTmp[ _CCLITIK ] != cDefCli() )
      return .f.
   end if

   oDlg  := TDialog():New( , , , , , "Fidelity" )

      TBitmap():ReDefine( 700, "FidelizacionClientes", , oDlg )

      ApoloBtnBmp():Redefine( 500, "Id_Card_32", , , , , {|| oDlg:end( IDOK ), if( !Empty( aGet[ _CCLITIK ] ), aGet[ _CCLITIK ]:SetFocus(), ) }, oDlg, , , .f., .f., "Si. [ F5 ]", ,,, .t., "TOP", .t., , , .f., )

      ApoloBtnBmp():Redefine( 510, "Id_Card_Delete_32", , , , , {|| oDlg:end( IDOK ), appCli( .f. ) }, oDlg, , , .f., .f., "No, pero deseo tenerla. [ F6 ]", ,,, .t., "TOP", .t., , , .f., )

      ApoloBtnBmp():Redefine( IDCANCEL, "Del32", , , , , {|| oDlg:end() }, oDlg, , , .f., .f., "Gracias, en otra ocasión. [ ESC ]", ,,, .t., "TOP", .t., , , .f., )

      oDlg:AddFastKey( VK_F5, {|| oDlg:end( IDOK ), aGet[ _CCLITIK ]:SetFocus()} )
      oDlg:AddFastKey( VK_F6, {|| oDlg:end( IDOK ), appCli( .f. ) } )

   oDlg:Activate( , , , .t. )

Return ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

Static Function GetVale( oBrwVal, aTmp )

   local oDlg
   local oGet
   local lError   := .f.
   local cGet     := Space( 13 )
   local cCodCli  := aTmp[ _CCLITIK ]
   local nRecAnt  := ( dbfTikT )->( RecNo() )
   local nOrdAnt  := ( dbfTikT )->( OrdSetFocus( "cLiqVal" ) )
   local cTyp     := ( dbfTikT )->( dbOrderInfo( DBOI_KEYTYPE ) )
   local nRec     := ( dbfTmpV )->( RecNo() )

   DEFINE DIALOG oDlg RESOURCE "GetVale"

      REDEFINE GET oGet ;
         VAR      cGet ;
         ID       110 ;
         OF       oDlg

      REDEFINE BUTTON ;
         ID       ( IDOK ) ;
         OF       oDlg ;
         ACTION   oDlg:end( IDOK )

   ACTIVATE DIALOG oDlg CENTER

   if oDlg:nResult == IDOK

      if lBigSeek( nil, Upper( cGet ), dbfTikT )

         /*
         Comprobamos q no este incluida en la tabla de vales-------------------
         */

         ( dbfTmpV )->( __dbLocate( {|| ( dbfTikT )->cSerTik + ( dbfTikT )->cNumTik + ( dbfTikT )->cSufTik == ( dbfTmpV )->cSerTik + ( dbfTmpV )->cNumTik + ( dbfTmpV )->cSufTik } ) )

         if !( dbfTmpV )->( Found() )

            if ( dbfTikT )->dFecTik + uFieldEmpresa( "nDiaVale" ) > GetSysDate()
               lError   := .t.
               MsgStop( "El vale introducido no han alcanzado la fecha para su liquidación." )
            end if

            if ( dbfTikT )->cCliTik != cCodCli
               lError   := .t.
               MsgStop( "El vale introducido pertenece a otro cliente." )
            end if

            if !lError

               dbPass( dbfTikT, dbfTmpV, .t. )

               if dbLock( dbfTikT )
                  ( dbfTikT )->lSelDoc := .f.
                  ( dbfTikT )->( dbUnLock() )
               end if

            end if

         else

            MsgStop( "Vale ya incorporado." )

         end if

      else

         MsgStop( "Vale no encontrado." )

      end if

   end if

   /*
   Repos-----------------------------------------------------------------------
   */

   ( dbfTikT )->( OrdSetFocus( nOrdAnt ) )
   ( dbfTikT )->( dbGoTo( nRecAnt ) )

   ( dbfTmpV )->( dbGoTo( nRec ) )

   /*
   Refresh---------------------------------------------------------------------
   */

   if oBrwVal != nil
      oBrwVal:Refresh()
   end if

Return .f.

//---------------------------------------------------------------------------//

Function EINFTDIAACTUACIONES()

Return nil

//---------------------------------------------------------------------------//

Static Function AsistenteDevolucionTiket( aTmp, aGet, nMode, lDevolucion )

   local o
   local oDlg
   local oBmp
   local dbfTmp
   local oBrwDev
   local oNumero
   local cNumero
   local cNewFil
   local nTotSel

   nTotSel        := 0
   cNewFilL       := cGetNewFileName( cPatTmp() + "TikL" )

   dbCreate( cNewFilL, aSqlStruct( aColTik() ), cLocalDriver() )

   dbUseArea( .t., cLocalDriver(), cNewFilL, cCheckArea( "TikL", @dbfTmp ), .f. )
   if !NetErr()
      ( dbfTmp )->( OrdCondSet( "!Deleted()", {||!Deleted() } ) )
      ( dbfTmp )->( OrdCreate( cNewFilL, "Recno", "Str( Recno() )", {|| Str( Recno() ) } ) )
   end if

   DEFINE DIALOG oDlg RESOURCE "ASSVALEDEVOLUCION"

      REDEFINE BITMAP oBmp ;
         ID          500 ;
         RESOURCE    "Cashier_delete_48_alpha" ;
         TRANSPARENT ;
         OF          oDlg

      REDEFINE GET oNumero VAR cNumero ;
         ID          100 ;
         PICTURE     "@!" ;
         BITMAP      "LUPA" ;
         VALID       ( ValidaDevolucionTiket( oNumero, oBrwDev, aTmp, aGet, oDlg, dbfTmp ) ) ;
         ON HELP     ( BrwTikCli( oNumero ) ) ;
         OF          oDlg ;

      /*
		Detalle de Articulos____________________________________________________
		*/

      oBrwDev                    := TXBrowse():New( oDlg )

      oBrwDev:lFooter            := .t.
      oBrwDev:bClrStd            := {|| if( ( dbfTmp )->nUntTil > 0, { CLR_BLACK, GetSysColor( COLOR_WINDOW ) }, { CLR_GRAY, GetSysColor( COLOR_WINDOW ) } ) }
      oBrwDev:bClrSel            := {|| if( ( dbfTmp )->nUntTil > 0, { CLR_BLACK, Rgb( 229, 229, 229 ) }, { CLR_GRAY, Rgb( 229, 229, 229 ) } ) }
      oBrwDev:bClrSelFocus       := {|| if( ( dbfTmp )->nUntTil > 0, { CLR_BLACK, Rgb( 167, 205, 240 ) }, { CLR_GRAY, Rgb( 167, 205, 240 ) } ) }
      oBrwDev:Cargo              := {}
      oBrwDev:nMarqueeStyle      := 5

      oBrwDev:cAlias             := dbfTmp

      with object ( oBrwDev:AddCol() )
         :cHeader                := ""
         :bEditValue             := {|| aScan( oBrwDev:Cargo, Eval( oBrwDev:bBookMark ) ) > 0 }
         :nWidth                 := 20
         :SetCheck( { "Sel16", "Nil16" }, {|| SelectLinea( @nTotSel, dbfTmp, oBrwDev ) } )
      end with

      with object ( oBrwDev:AddCol() )
         :cHeader                := "Código"
         :bEditValue             := {|| ( dbfTmp )->cCbaTil }
         :nWidth                 := 60
      end with

      with object ( oBrwDev:AddCol() )
         :cHeader                := "Und."
         :bEditValue             := {|| ( dbfTmp )->nUntTil }
         :cEditPicture           := cPicUnd
         :nWidth                 := 40
         :nEditType              := 1
         :nDataStrAlign          := AL_RIGHT
         :nHeadStrAlign          := AL_RIGHT
         :bOnPostEdit            := {|o,x| if( x <= ( dbfTmp )->nUntTil .and. x > 0, ( dbfTmp )->nUntTil := x, ) }
      end with

      with object ( oBrwDev:AddCol() )
         :cHeader                := "Prp. 1"
         :bEditValue             := {|| ( dbfTmp )->cValPr1 }
         :nWidth                 := 35
      end with

      with object ( oBrwDev:AddCol() )
         :cHeader                := "Prp. 2"
         :bEditValue             := {|| ( dbfTmp )->cValPr2 }
         :nWidth                 := 35
      end with

      with object ( oBrwDev:AddCol() )
         :cHeader                := "Lote"
         :bEditValue             := {|| ( dbfTmp )->cLote }
         :nWidth                 := 40
      end with

      with object ( oBrwDev:AddCol() )
         :cHeader                := "Detalle"
         :bEditValue             := {|| Rtrim( ( dbfTmp )->cNomTil ) }
         :nWidth                 := 180
      end with

      with object ( oBrwDev:AddCol() )
         :cHeader                := "Total"
         :bEditValue             := {|| Trans( nTotLTpv( dbfTmp, nDouDiv, nDorDiv ), cPorDiv ) }
         :nWidth                 := 80
         :bFooter                := {|| Trans( nTotSel, cPorDiv ) }
         :nDataStrAlign          := AL_RIGHT
         :nHeadStrAlign          := AL_RIGHT
         :nFootStrAlign          := AL_RIGHT
      end with

      with object ( oBrwDev:AddCol() )
         :cHeader                := "Dto. lineal"
         :bEditValue             := {|| Trans( nDtoUTpv( dbfTmpL, nDouDiv ), cPouDiv ) }
         :nWidth                 := 60
         :nDataStrAlign          := AL_RIGHT
         :nHeadStrAlign          := AL_RIGHT
      end with

      with object ( oBrwDev:AddCol() )
         :cHeader                := "%Dto"
         :bEditValue             := {|| Trans( ( dbfTmp )->nDtoLin, "@EZ 999.99" ) }
         :nWidth                 := 35
         :nDataStrAlign          := AL_RIGHT
         :nHeadStrAlign          := AL_RIGHT
      end with

      oBrwDev:CreateFromResource( 110 )

      oBrwDev:lHScroll           := .t.
      oBrwDev:lVScroll           := .t.
      oBrwDev:lRecordSelector    := .t.
      oBrwDev:bLDblClick         := {|| SelectLinea( @nTotSel, dbfTmp, oBrwDev ) }

      REDEFINE BUTTON ;
         ID       120 ;
			OF 		oDlg ;
         ACTION   ( SelectLinea( @nTotSel, dbfTmp, oBrwDev ) )

      /*
      Botones de formas de pago------------------------------------------------
      */

      if lDevolucion

         for each o in ( aButtonsPago )
            o:oButton         := ApoloBtnBmp():Redefine( ( 600 + hb_EnumIndex() ), o:cBigResource, , , , , {|o| FinalizaDevolucionTicket( o, aTmp, aGet, dbfTmp, oNumero, oBrwDev, oDlg ) }, oDlg, , , .f., .f., "Devolución " + Rtrim( o:cText ), , , , .t., "TOP", .t., , , .f. )
            o:oButton:Cargo   := o:cCode
         next

         oDlg:bStart          := {|| aEval( aButtonsPago, {|o| if( !Empty( o:oButton:Cargo ), o:oButton:Show(), ) } ) }

      else

         o                    := ApoloBtnBmp():Redefine( IDOK, "Document_delete_32", , , , , {|| FinalizaDevolucionTicket( , aTmp, aGet, dbfTmp, oNumero, oBrwDev, oDlg ) }, oDlg, , , .f., .f., "Emitir vale", , , , .t., "TOP", .t., , , .f. )

         oDlg:bStart          := {|| o:Show() }

      end if

      ApoloBtnBmp():Redefine( IDCANCEL, "Del32", , , , , {|| oDlg:end() }, oDlg, , , .f., .f., "Cancelar", , , , .t., "TOP", .t., , , .f. )

   ACTIVATE DIALOG oDlg CENTER

   oBmp:End()

   if !Empty( dbfTmp ) .and. ( dbfTmp )->( Used() )
      ( dbfTmp )->( dbCloseArea() )
   end if

   dbfErase( cNewFil )

   dbfTmp         := nil

Return ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

Static Function SelectLinea( nTotSel, dbfTmp, oBrwDev )

   local nScan
   local uBook

   if ( dbfTmp )->nUntTil > 0

      uBook       := Eval( oBrwDev:bBookMark )

      nScan       := aScan( oBrwDev:Cargo, uBook )
      if nScan == 0

         nTotSel  += nTotLTpv( dbfTmp, nDouDiv, nDorDiv )

         aAdd( oBrwDev:Cargo, uBook )

      else

         nTotSel  -= nTotLTpv( dbfTmp, nDouDiv, nDorDiv )

         aDel( oBrwDev:Cargo, nScan, .t. )

      end if

      oBrwDev:Refresh()

   else

      cInformeDevolucionTpv( dbfTmp )

   end if

Return nil

//---------------------------------------------------------------------------//

Static Function ValidaDevolucionTiket( oNumero, oBrwDev, aTmp, aGet, oDlg, dbfTmp )

   local lErr
   local nRecAnt
   local nOrdAnt
   local nRecLin
   local nOrdLin
   local cNumero

   cNumero        := oNumero:VarGet()

   if Empty( cNumero )
      Return .t.
   end if

   oDlg:Disable()

   lErr           := .f.
   nRecAnt        := ( dbfTikT )->( RecNo() )
   nOrdAnt        := ( dbfTikT )->( OrdSetFocus( "cNumTik" ) )

   if !lBigSeek( nil, Upper( cNumero ), dbfTikT )

      lErr        := .t.

   else

      if ( dbfTikT )->cTipTik != "1"

         lErr     := .t.

      else

         oNumero:cText( ( dbfTikT )->cSerTik + ( dbfTikT )->cNumTik + ( dbfTikT )->cSufTik )

         /*
         Los datos del cliente lo asignamos---------------------------------------
         */

         aTmp[ _CCLITIK ]     := ( dbfTikT )->cCliTik
         aTmp[ _CNOMTIK ]     := ( dbfTikT )->cNomTik
         aTmp[ _CDNICLI ]     := ( dbfTikT )->cDniCli
         aTmp[ _CDIRCLI ]     := ( dbfTikT )->cDirCli
         aTmp[ _CPOBCLI ]     := ( dbfTikT )->cPobCli
         aTmp[ _CPRVCLI ]     := ( dbfTikT )->cPrvCli
         aTmp[ _CPOSCLI ]     := ( dbfTikT )->cPosCli

         /*
         Vamos a comprobar q tenga lineas, si es asi tenemos q ver si el codigo del articulo esta en el tiket
         */

         if ( dbfTikL )->( dbSeek( ( dbfTikT )->cSerTik + ( dbfTikT )->cNumTik + ( dbfTikT )->cSufTik ) )

            while ( ( dbfTikL )->cSerTil + ( dbfTikL )->cNumTil + ( dbfTikL )->cSufTil == ( dbfTikT )->cSerTik + ( dbfTikT )->cNumTik + ( dbfTikT )->cSufTik .and. !( dbfTikL )->( eof() ) )

               dbPass( dbfTikL, dbfTmp, .t. )

               /*
               Unidades q ya hemos devuelto------------------------------------
               */

               ( dbfTmp )->nUntTil  -= nDevNTpv( ( dbfTikT )->cSerTik + ( dbfTikT )->cNumTik + ( dbfTikT )->cSufTik, dbfTikL )

               /*
               Guardamos la referencia al ticket del q venimos-----------------
               */

               ( dbfTmp )->cNumDev  := ( dbfTikT )->cSerTik + ( dbfTikT )->cNumTik + ( dbfTikT )->cSufTik

               /*
               Saltamos al siguiente registro----------------------------------
               */

               ( dbfTikL )->( dbSkip() )

            end while

         end if

         if !Empty( oBrwDev )
            oBrwDev:Refresh()
            oBrwDev:GoTop()
         end if

      end if

   end if

   ( dbfTikT )->( OrdScope( 0, nil ) )
   ( dbfTikT )->( OrdScope( 1, nil ) )
   ( dbfTikT )->( OrdSetFocus( nOrdAnt ) )
   ( dbfTikT )->( dbGoTo( nRecAnt ) )

   oDlg:Enable()

   if !lErr
      oNumero:Disable()
   end if

Return ( .t. )

//---------------------------------------------------------------------------//

Static Function FinalizaDevolucionTicket( oBtn, aTmp, aGet, dbfTmp, oNumero, oBrwDev, oDlg )

   local nRec
   local nOrd
   local aTotalTicket
   local nTotalTicket
   local cSerieTicket
   local nNumeroTicket
   local cSufijoTicket
   local cNumeroTicket
   local nTotalDevolucion        := 0
   local nTotTicketOriginal      := 0
   local nTotTicketResultado     := 0
   local nPorcentajeFidelizacion := 0
   local nValePromocion          := 0
   local lValePromocion          := .f.
   local aBlankT                 := {}
   local aBlankL                 := {}

   if len( oBrwDev:Cargo ) == 0

      MsgStop( "Debe seleccionar al menos una línea" )

   else

      CursorWait()

      oDlg:Disable()

      cNumeroTicket        := Alltrim( oNumero:VarGet() )
      nTotalTicket         := 0
      cSerieTicket         := aTmp[ _CSERTIK ]
      nNumeroTicket        := Str( nNewDoc( aTmp[ _CSERTIK ], dbfTikT, "nTikCli", 10, dbfCount ), 10 )
      cSufijoTicket        := RetSufEmp()

      /*
      Valores por defecto------------------------------------------------------
      */

      aTmp[ _CDIVTIK ]     := cDivEmp()
      aTmp[ _NVDVTIK ]     := nValDiv( cDivEmp(), dbfDiv )
      aTmp[ _CTURTIK ]     := cCurSesion()
      aTmp[ _CCCJTIK ]     := cCurUsr()
      aTmp[ _CNCJTIK ]     := oUser():cCaja()
      aTmp[ _NTARIFA ]     := Max( uFieldEmpresa( "nPreVta" ), 1 )
      aTmp[ _DFECCRE ]     := Date()
      aTmp[ _CTIMCRE ]     := SubStr( Time(), 1, 5 )
      aTmp[ _CHORTIK ]     := Substr( Time(), 1, 5 )
      aTmp[ _LABIERTO]     := .f.
      aTmp[ _LCLOTIK ]     := .f.
      aTmp[ _LPGDTIK ]     := .t.

      /*
      Archivamos el tipo de venta que se ha realizado--------------------------
      */

      if !Empty( oBtn )
         aTmp[ _CTIPTIK ]  := SAVDEV
      else
         aTmp[ _CTIPTIK ]  := SAVVAL
      end if

      /*
      Obtenemos el nuevo numero del Tiket--------------------------------------
      */

      aTmp[ _CSERTIK ]     := cSerieTicket
      aTmp[ _CNUMTIK ]     := nNumeroTicket
      aTmp[ _CSUFTIK ]     := cSufijoTicket

      /*
      Añade las líneas seleccionadas-------------------------------------------
      */

      for each nRec in ( oBrwDev:Cargo )

         ( dbfTmp )->( dbGoTo( nRec ) )

         dbPass( dbfTmp, dbfTikL, .t., cSerieTicket, nNumeroTicket, cSufijoTicket, SAVDEV )

         nTotalTicket      += nTotLTpv( dbfTmp, nDouDiv, nDorDiv )

      next

      /*
      Salvamos a disco el array de las cabeceras-------------------------------
      */

      WinGather( aTmp, nil, dbfTikT, nil, APPD_MODE, nil, .f. )

      /*
      Pagos del ticket---------------------------------------------------------
      */

      if !Empty( oBtn ) .and. dbAppe( dbfTikP )
         ( dbfTikP )->cSerTik    := cSerieTicket
         ( dbfTikP )->cNumTik    := nNumeroTicket
         ( dbfTikP )->cSufTik    := cSufijoTicket
         ( dbfTikP )->nImpTik    := nTotalTicket
         ( dbfTikP )->cTurPgo    := cCurSesion()
         ( dbfTikP )->dPgoTik    := GetSysDate()
         ( dbfTikP )->cTimTik    := SubStr( Time(), 1, 5 )
         ( dbfTikP )->cCodCaj    := oUser():cCaja()
         ( dbfTikP )->cFpgPgo    := oBtn:Cargo
         ( dbfTikP )->cDivPgo    := cDivEmp()
         ( dbfTikP )->nVdvPgo    := nValDiv( cDivEmp(), dbfDiv )
      end if

      /*
      Resto el total de vale cuando realizo una devolución---------------------
      */

      nRec                       := ( dbfTikT )->( RecNo() )

      if dbSeekInOrd( cNumeroTicket, "cTikVal", dbfTikT )

         if dbLock( dbfTikT )
            ( dbfTikT )->lLiqTik := .t.
            ( dbfTikT )->lLiqDev := .t.

            ( dbfTikT )->( dbUnLock() )
         endif

      end if

      /*
      Calculamos el total del vale o devolucion--------------------------------
      */

      nOrd                       := ( dbfTikT )->( OrdSetFocus( "cNumTik" ) )

      if ( dbfTikT )->( dbSeek( cSerieTicket + nNumeroTicket + cSufijoTicket ) )

         aTotalTicket            := aTotTik( cSerieTicket + nNumeroTicket + cSufijoTicket, dbfTikT, dbfTikL, dbfDiv, nil, nil, .f. )

         if dbLock( dbfTikT )

            ( dbfTikT )->nTotNet := aTotalTicket[ 1 ]
            ( dbfTikT )->nTotIva := aTotalTicket[ 2 ]
            ( dbfTikT )->nTotTik := aTotalTicket[ 3 ]

            ( dbfTikT )->( dbUnLock() )

         endif

      end if

      ( dbfTikT )->( OrdSetFocus( nOrd ) )
      ( dbfTikT )->( dbGoTo( nRec ) )

      /*
      Abrir la caja -----------------------------------------------------------
      */

      oUser():OpenCajon()

      /*
      Imprimir el registro-----------------------------------------------------
      */

      ImpTiket( .f. )

      /*
      Tomamos el total de devoluciones de un ticket----------------------------
      */

      nTotalDevolucion  := nTotalDevoluciones( Padr( cNumeroTicket, 13 ), dbfTikT, dbfTikL )

      /*
      Tomamos los valores para generar el vale regalo--------------------------
      */

      if dbSeekInOrd( cNumeroTicket, "cNumTik", dbfTikT ) .and.;
         dbSeekInOrd( cNumeroTicket, "cNumTil", dbfTikL )

         nTotTicketOriginal      := nTotTik()
         nTotTicketResultado     := nTotTicketOriginal - nTotalDevolucion

         /*
         Capturanmos el porcentaje de promoción--------------------------------
         */

         nPorcentajeFidelizacion := oFideliza:nPorcentajePrograma( nTotTicketResultado  )

         /*
         Vemos si cumple las condiciones para la promoción---------------------
         */

         lValePromocion          := ( !Retfld( ( dbfTikT )->cCliTik, dbfClient, "lExcFid" ) .and. ( nPorcentajeFidelizacion != 0 ) )
         if lValePromocion
            nValePromocion       := nTotTicketResultado * nPorcentajeFidelizacion / 100
         end if

      end if

      /*
      Generamos el vale regalo-------------------------------------------------
      */

      if ( lValePromocion ) .and. ( nValePromocion > 0 )

         if !Empty( oMetMsg )
            oMetMsg:cText        := 'Generando vales'
            oMetMsg:Refresh()
         end if

         /*
         Obtenemos el nuevo numero del vale------------------------------------
         */

         aBlankT                 := dbScatter( dbfTikT )

         aBlankT[ _CNUMTIK ]     := Str( nNewDoc( aTmp[ _CSERTIK ], dbfTikT, "nTikCli", 10, dbfCount ), 10 )
         aBlankT[ _CSUFTIK ]     := RetSufEmp()
         aBlankT[ _CHORTIK ]     := Substr( Time(), 1, 5 )
         aBlankT[ _DFECCRE ]     := Date()
         aBlankT[ _CTIMCRE ]     := SubStr( Time(), 1, 5 )
         aBlankT[ _CTIPTIK ]     := SAVVAL
         aBlankT[ _CTIKVAL ]     := cNumeroTicket
         aBlankT[ _LCLOTIK ]     := .f.
         aBlankT[ _NTOTNET ]     := nValePromocion
         aBlankT[ _NTOTTIK ]     := nValePromocion

         dbGather( aBlankT, dbfTikT, .t. )

         /*
         Guardamos las lineas del tiket----------------------------------------
         */

         aBlankL                 := dbBlankRec( dbfTmpL )

         aBlankL[ _CSERTIL ]     := aBlankT[ _CSERTIK ]
         aBlankL[ _CNUMTIL ]     := aBlankT[ _CNUMTIK ]
         aBlankL[ _CSUFTIL ]     := aBlankT[ _CSUFTIK ]
         aBlankL[ _CTIPTIK ]     := SAVVAL
         aBlankL[ _NUNTTIL ]     := 1
         aBlankL[ _NNUMLIN ]     := 1
         aBlankL[ _CNOMTIL ]     := "Vale por promoción"
         aBlankL[ _NPVPTIL ]     := nValePromocion

         dbGather( aBlankL, dbfTikL, .t. )

         ImpTiket( .f. )

      end if

      /*
      Recuperamos el cursor y cerramos la ventana------------------------------
      */

      oDlg:Enable()

      CursorWE()

      oDlg:End( IDOK )

   end if

Return ( .t. )

//---------------------------------------------------------------------------//

static function nTotalDevoluciones( cNumeroTicket, cTikT, cTikL )

   local i
   local nRecT          := ( cTikT )->( Recno() )
   local nRecL          := ( cTikL )->( Recno() )
   local nOrdT          := ( cTikT )->( OrdSetFocus( "cNumTik" ) )
   local nOrdL          := ( cTikL )->( OrdSetFocus( "cDevTik" ) )
   local cValAnt        := ""
   local aDevoluciones  := {}
   local nTotal         := 0

   if ( cTikL )->( dbSeek( cNumeroTicket ) )

      while ( cTikL )->cNumDev == cNumeroTicket .and. !( cTikL )->( Eof() )

         if aScan( aDevoluciones, ( cTikL )->cSerTil + ( cTikL )->cNumTil + ( cTikL )->cSufTil ) == 0
            aAdd( aDevoluciones, ( cTikL )->cSerTil + ( cTikL )->cNumTil + ( cTikL )->cSufTil )
         end if

         ( cTikL )->( dbSkip() )

      end while

   end if

   if Len( aDevoluciones ) != 0

      for i := 1 to Len( aDevoluciones )

         if ( cTikT )->( dbSeek( aDevoluciones[i] ) )
            nTotal      += nTotTik()
         end if

      next

   end if

   ( cTikT )->( OrdSetFocus( nOrdT ) )
   ( cTikL )->( OrdSetFocus( nOrdL ) )
   ( cTikT )->( dbGoTo( nRecT ) )
   ( cTikL )->( dbGoTo( nRecT ) )

return ( nTotal )

//---------------------------------------------------------------------------//

Static Function nDevNTpv( cNumero, dbfTikL )

   local nRec
   local nOrd
   local nDev
   local cNum

   nDev           := 0
   nRec           := ( dbfTikL )->( Recno() )
   nOrd           := ( dbfTikL )->( OrdSetFocus( "cNumDev" ) )
   cNum           := Str( ( dbfTikL )->nNumLin )

   if ( dbfTikL )->( dbSeek( cNumero + cNum ) )
      while ( dbfTikL )->cNumDev == cNumero .and. Str( ( dbfTikL )->nNumLin ) == cNum .and. !( dbfTikL )->( eof() )
         nDev     += nTotNTpv( dbfTikL )
         ( dbfTikL )->( dbSkip() )
      end while
   end if

   ( dbfTikL )->( dbGoto( nRec ) )
   ( dbfTikL )->( OrdSetFocus( nOrd ) )

Return ( nDev )

//---------------------------------------------------------------------------//

Static Function cInformeDevolucionTpv( dbfTmp )

   local cNum
   local nRec
   local nOrd
   local aInf
   local oBrw
   local oDlg
   local oBmp

   if Empty( ( dbfTmp )->cSerTil )
      Return ( nil )
   end if

   cNum           := ""
   nRec           := ( dbfTikL )->( Recno() )
   nOrd           := ( dbfTikL )->( OrdSetFocus( "cNumDev" ) )
   aInf           := {}

   if ( dbfTikL )->( dbSeek( ( dbfTmp )->cSerTil + ( dbfTmp )->cNumTil + ( dbfTmp )->cSufTil + Str( ( dbfTmp )->nNumLin ) ) )
      aAdd( aInf, { "Número",       ( dbfTikL )->cSerTil + "/" + Alltrim( ( dbfTikL )->cNumTil ) + "/" + Alltrim( ( dbfTikL )->cSufTil ) } )
      aAdd( aInf, { "Fecha",        Dtoc( RetFld( ( dbfTikL )->cSerTil + ( dbfTikL )->cNumTil + ( dbfTikL )->cSufTil, dbfTikT,   "dFecTik" ) ) } )
      aAdd( aInf, { "Hora",         RetFld( ( dbfTikL )->cSerTil + ( dbfTikL )->cNumTil + ( dbfTikL )->cSufTil, dbfTikT,         "cHorTik" ) } )
      aAdd( aInf, { "Usuario",      RetFld( ( dbfTikL )->cSerTil + ( dbfTikL )->cNumTil + ( dbfTikL )->cSufTil, dbfTikT,         "cCcjTik" ) } )
      aAdd( aInf, { "Caja",         RetFld( ( dbfTikL )->cSerTil + ( dbfTikL )->cNumTil + ( dbfTikL )->cSufTil, dbfTikT,         "cNcjTik" ) } )
      aAdd( aInf, { "Almacen",      RetFld( ( dbfTikL )->cSerTil + ( dbfTikL )->cNumTil + ( dbfTikL )->cSufTil, dbfTikT,         "cAlmTik" ) } )
      aAdd( aInf, { "Sesión",       Alltrim( RetFld( ( dbfTikL )->cSerTil + ( dbfTikL )->cNumTil + ( dbfTikL )->cSufTil, dbfTikT,"cTurTik" ) ) } )
      aAdd( aInf, { "Cliente",      RetFld( ( dbfTikL )->cSerTil + ( dbfTikL )->cNumTil + ( dbfTikL )->cSufTil, dbfTikT,         "cNomTik" ) } )
      aAdd( aInf, { "Dirección",    RetFld( ( dbfTikL )->cSerTil + ( dbfTikL )->cNumTil + ( dbfTikL )->cSufTil, dbfTikT,         "cDirCli" ) } )
      aAdd( aInf, { "Cod. postal",  RetFld( ( dbfTikL )->cSerTil + ( dbfTikL )->cNumTil + ( dbfTikL )->cSufTil, dbfTikT,         "cPosCli" ) } )
      aAdd( aInf, { "Población",    RetFld( ( dbfTikL )->cSerTil + ( dbfTikL )->cNumTil + ( dbfTikL )->cSufTil, dbfTikT,         "cPobCli" ) } )
      aAdd( aInf, { "Provincia",    RetFld( ( dbfTikL )->cSerTil + ( dbfTikL )->cNumTil + ( dbfTikL )->cSufTil, dbfTikT,         "cPrvCli" ) } )
      aAdd( aInf, { "Teléfono",     RetFld( ( dbfTikL )->cSerTil + ( dbfTikL )->cNumTil + ( dbfTikL )->cSufTil, dbfTikT,         "cTlfCli" ) } )
      aAdd( aInf, { "Unidades",     AllTrim( nTotNTpv( dbfTikL, cPicUnd ) ) } )
      aAdd( aInf, { "Importe",      AllTrim( Trans( nTotLTpv( dbfTikL, nDouDiv, nDorDiv ), cPorDiv ) ) } )
   end if

   ( dbfTikL )->( dbGoto( nRec ) )
   ( dbfTikL )->( OrdSetFocus( nOrd ) )

   if !Empty( aInf )

      DEFINE DIALOG oDlg RESOURCE "TICKETINFO"

      REDEFINE BITMAP oBmp ;
         ID          500 ;
         RESOURCE    "Cashier_delete_48_alpha" ;
         TRANSPARENT ;
         OF          oDlg

      oBrw                       := TXBrowse():New( oDlg )

      oBrw:bClrSel               := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrw:bClrSelFocus          := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrw:SetArray( aInf, , , .f. )

      oBrw:nMarqueeStyle         := 5
      oBrw:lRecordSelector       := .f.
      oBrw:lHScroll              := .f.

      oBrw:CreateFromResource( 100 )

      with object ( oBrw:AddCol() )
         :cHeader                := "Info"
         :bStrData               := {|| aInf[ oBrw:nArrayAt, 1 ] }
         :nWidth                 := 80
      end with

      with object ( oBrw:AddCol() )
         :cHeader                := "Valor"
         :bStrData               := {|| aInf[ oBrw:nArrayAt, 2 ] }
         :nWidth                 := 300
      end with

      REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
         ACTION   ( oDlg:End() )

      ACTIVATE DIALOG oDlg CENTER

      oBmp:End()

   else

      MsgStop( "No se ha podido recopilar información." )

   end if

Return ( nil )

//---------------------------------------------------------------------------//


Static Function dFecMaxVale( cNumTik, cTikT  )

   local dFecMaxVale    := Ctod( "" )
   local nRec
   local nOrdAnt

   DEFAULT cTikT        := dbfTikT

   /*
   Guardamos los la posición y el orden de la tabla----------------------------
   */

   nRec                 := ( cTikT )->( Recno() )
   nOrdAnt              := ( cTikT )->( OrdSetFocus( "CDOCVAL" ) )

   if ( cTikT )->( dbSeek( cNumTik ) )

      while ( cTikT )->cValDoc == cNumTik .and. !( cTikT )->( Eof() )

         if ( cTikT )->dFecTik > dFecMaxVale
            dFecMaxVale := ( cTikT )->dFecTik
         end if

      ( cTikT )->( dbSkip() )

      end while

   end if

   /*
   Dejamos la tabla en la posicion que nos la encontramos----------------------
   */

   ( cTikT )->( OrdSetFocus( nOrdAnt ) )
   ( cTikT )->( dbGoTo( nRec ) )

   if Empty( DtoC( dFecMaxVale ) )
      dFecMaxVale       := Date()
   end if

return ( dFecMaxVale )

//---------------------------------------------------------------------------//

Static Function BrwTikCli( oGet )

   local oDlg
	local oBrw
   local oGet1
	local cGet1
   local nOrd           := GetBrwOpt( "BrwTikCli" )
   local oCbxOrd
   local cCbxOrd
   local aCbxOrd        := { "Número", "Fecha", "Código cliente", "Nombre cliente" }
   local nRecAnt        := ( dbfTikT )->( RecNo() )
   local nOrdAnt        := ( dbfTikT )->( OrdSetFocus( "cNumTik" ) )
   local cText          := ""

   nOrd                 := Min( Max( nOrd, 1 ), len( aCbxOrd ) )
   cCbxOrd              := aCbxOrd[ nOrd ]

   nOrd                 := ( dbfTikT )->( OrdSetFocus( nOrd ) )

   /*
   Posicinamiento--------------------------------------------------------------
   */

   ( dbfTikT )->( dbSetFilter( {|| Field->cTipTik == "1" }, "Field->cTipTik == '1'" ) )
   ( dbfTikT )->( dbGoTop() )

   DEFINE DIALOG oDlg RESOURCE "HelpEntry" TITLE 'Seleccionar tickets'

      REDEFINE GET oGet1 VAR cGet1;
			ID 		104 ;
         ON CHANGE AutoSeek( nKey, nFlags, Self, oBrw, dbfTikT );
         BITMAP   "FIND" ;
         OF       oDlg

		REDEFINE COMBOBOX oCbxOrd ;
			VAR 		cCbxOrd ;
			ID 		102 ;
         ITEMS    aCbxOrd ;
         ON CHANGE( ( dbfTikT )->( OrdSetFocus( oCbxOrd:nAt ) ), oBrw:Refresh(), oGet1:SetFocus() );
         OF       oDlg

      oBrw                    := IXBrowse():New( oDlg )

      oBrw:bClrSel            := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrw:bClrSelFocus       := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrw:cAlias             := dbfTikT
      oBrw:cName              := "Ticket cliente"
      oBrw:bLDblClick         := {|| oDlg:End( IDOK ) }

      oBrw:nMarqueeStyle      := 5

      with object ( oBrw:AddCol() )
         :cHeader             := "Número"
         :cSortOrder          := "cNumTik"
         :bEditValue          := {|| ( dbfTikT )->cSerTik + "/" + AllTrim( ( dbfTikT )->cNumTik ) + "/" + ( dbfTikT )->cSufTik }
         :nWidth              := 70
         :bLClickHeader       := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader             := "Fecha"
         :cSortOrder          := "dFecTik"
         :bEditValue          := {|| Dtoc( ( dbfTikT )->dFecTik ) }
         :nWidth              := 70
         :bLClickHeader       := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader             := "Código cliente"
         :bEditValue          := {|| Rtrim( ( dbfTikT )->cCliTik ) }
         :cSortOrder          := "cCliTik"
         :nWidth              := 75
         :bLClickHeader       := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader             := "Nombre cliente"
         :bEditValue          := {|| AllTrim( ( dbfTikT )->cNomTik ) }
         :cSortOrder          := "cNomTik"
         :nWidth              := 150
         :bLClickHeader       := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
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

      oBrw:CreateFromResource( 105 )

		REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
         ACTION   ( oDlg:end( IDOK ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
         CANCEL ;
         ACTION   ( oDlg:end() )

   oDlg:bStart                := {|| oBrw:Load() }

   oDlg:AddFastKey( VK_F5,    {|| oDlg:end( IDOK ) } )
   oDlg:AddFastKey( VK_RETURN,{|| oDlg:end( IDOK ) } )

   ACTIVATE DIALOG oDlg CENTER

   /*
   Guardamos los vales en el array---------------------------------------------
   */

   if oDlg:nResult == IDOK

      if !Empty( oGet )
         oGet:cText( ( dbfTikT )->cSerTik + ( dbfTikT )->cNumTik + ( dbfTikT )->cSufTik )
      end if

   end if

   SetBrwOpt( "BrwTikCli", ( dbfTikT )->( OrdNumber() ) )

   ( dbfTikT )->( OrdSetFocus( nOrd ) )

   ( dbfTikT )->( dbClearFilter() )

   CursorWE()

   oGet:SetFocus()

   /*
   Repos-----------------------------------------------------------------------
   */

   ( dbfTikT )->( OrdSetFocus( nOrdAnt ) )
   ( dbfTikT )->( dbGoTo( nRecAnt ) )

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

Function nTotalEntregado( cNumDoc, cTikT, cAlbCliP, cDiv )

   DEFAULT cTikT     := dbfTikT
   DEFAULT cDiv      := dbfDiv
   DEFAULT cAlbCliP  := dbfAlbCliP
   DEFAULT cNumDoc   := ( cTikT )->cNumDoc

Return nPagAlbCli( cNumDoc, cAlbCliP, cDiv )

#endif

//---------------------------------------------------------------------------//

Function ArticuloServido( oBrwLin, dbfTmpL )

   if ( dbfTmpL )->lArtServ

      ( dbfTmpL )->lArtServ := .f.
   else

      ( dbfTmpL )->lArtServ := .t.

   end if

   oBrwLin:Refresh()

Return nil

//---------------------------------------------------------------------------//

#ifndef __PDA__

CLASS TFormatosImpresion

   DATA  cCodCaj

   DATA  oFormatoTiket
   DATA  cFormatoTiket

   DATA  oSayFmtTik
   DATA  cSayFmtTik

   DATA  oPrinterTik
   DATA  cPrinterTik
   DATA  nCopiasTik

   DATA  oFmtVal
   DATA  cFmtVal
   DATA  oSayFmtVal
   DATA  cSayFmtVal
   DATA  oPrinterVal
   DATA  cPrinterVal

   DATA  oFmtAlb
   DATA  cFmtAlb
   DATA  oSayFmtAlb
   DATA  cSayFmtAlb
   DATA  oPrinterAlb
   DATA  cPrinterAlb
   DATA  nCopiasAlb

   DATA  oFmtFac
   DATA  cFmtFac
   DATA  oSayFmtFac
   DATA  cSayFmtFac
   DATA  oPrinterFac
   DATA  cPrinterFac
   DATA  nCopiasFac

   DATA  cFormatoRegalo
   DATA  cPrinterRegalo
   DATA  nCopiasRegalo

   DATA  cFmtTikChk
   DATA  cPrinterTikChk

   DATA  cFormatoEntrega
   DATA  cPrinterEntrega
   DATA  nCopiasEntrega

   DATA  cFmtTikDev
   DATA  cPrinterDev

   DATA  cFmtAlbCaj
   DATA  cPrinterAlbCaj

   DATA  cFmtFacCaj
   DATA  cPrinterFacCaj

   DATA  cFmtEntCaj
   DATA  cPrinterEntCaj

   DATA  cFmtApt
   DATA  cPrinterApt

   METHOD Load( dbfCajT )

END CLASS

//---------------------------------------------------------------------------//

METHOD Load( dbfCajT )

   ::cCodCaj         := oUser():cCaja()

   ::cFormatoTiket   := cFormatoTicketEnCaja(   ::cCodCaj, dbfCajT )
   ::cFmtVal         := cFormatoValeEnCaja(     ::cCodCaj, dbfCajT )
   ::cFmtAlb         := cFormatoAlbaranEnCaja(  ::cCodCaj, dbfCajT )
   ::cFmtFac         := cFormatoFacturaEnCaja(  ::cCodCaj, dbfCajT )

   ::cSayFmtTik      := cNombreDoc( ::cFormatoTiket )
   ::cSayFmtVal      := cNombreDoc( ::cFmtVal )
   ::cSayFmtAlb      := cNombreDoc( ::cFmtAlb )
   ::cSayFmtFac      := cNombreDoc( ::cFmtFac )

   ::cPrinterTik     := cPrinterTiket(    ::cCodCaj, dbfCajT )
   ::cPrinterVal     := cPrinterVale(     ::cCodCaj, dbfCajT )
   ::cPrinterAlb     := cPrinterAlbaran(  ::cCodCaj, dbfCajT )
   ::cPrinterFac     := cPrinterFactura(  ::cCodCaj, dbfCajT )

   ::cFormatoRegalo  := cFormatoTicketRegaloEnCaja(   ::cCodCaj, dbfCajT )
   ::cPrinterRegalo  := cPrinterRegalo(               ::cCodCaj, dbfCajT )

   ::cFmtTikChk      := cFormatoChequeRegaloEnCaja(   ::cCodCaj, dbfCajT )
   ::cPrinterTikChk  := cPrinterChequeRegalo(         ::cCodCaj, dbfCajT )

   ::cFormatoEntrega := cFormatoEntregaEnCaja(     ::cCodCaj, dbfCajT )
   ::cPrinterEntrega := cPrinterEntrega(           ::cCodCaj, dbfCajT )
   ::cFmtTikDev      := cFormatoDevolucionEnCaja(  ::cCodCaj, dbfCajT )
   ::cPrinterDev     := cPrinterDevolucion(        ::cCodCaj, dbfCajT )
   ::cFmtAlbCaj      := cFormatoAlbaranEnCaja(     ::cCodCaj, dbfCajT )
   ::cPrinterAlbCaj  := cWindowsPrinterEnCaja(     ::cCodCaj, dbfCajT )

   ::cFmtFacCaj      := cFormatoFacturaEnCaja(  ::cCodCaj, dbfCajT )
   ::cPrinterFacCaj  := cWindowsPrinterEnCaja(  ::cCodCaj, dbfCajT )

   ::cFmtEntCaj      := cFormatoEntregaEnCaja(  ::cCodCaj, dbfCajT )
   ::cPrinterEntCaj  := cPrinterEntrega(        ::cCodCaj, dbfCajT )

   ::cFmtApt         := cFormatoApartadosEnCaja(   ::cCodCaj, dbfCajT )
   ::cPrinterApt     := cPrinterApartados(         ::cCodCaj, dbfCajT )

   ::nCopiasTik      := nCopiasTicketsEnCaja( ::cCodCaj, dbfCajT )
   ::nCopiasAlb      := nCopiasAlbaranesEnCaja( ::cCodCaj, dbfCajT )
   ::nCopiasFac      := nCopiasFacturasEnCaja( ::cCodCaj, dbfCajT )
   ::nCopiasEntrega  := nCopiasEntregasEnCaja( ::cCodCaj, dbfCajT )
   ::nCopiasRegalo   := nCopiasTicketsRegaloEnCaja( ::cCodCaj, dbfCajT )    
   
return self

//---------------------------------------------------------------------------//

#endif

Function ImpresionAnulaciones( cNumTik )

   local cPrinter          := ""
   local cFormato          := ""
   local aImp              := {}
   local nPos
   local lCreateTemporal   := .f.
   local cWav              := ""

   CursorWait()

   if Empty( dbfTmpN )

      cNewFilN             := cGetNewFileName( cPatTmp() + "TikAnu" )

      dbCreate( cNewFilN, aSqlStruct( aColTik() ), cLocalDriver() )
      dbUseArea( .t., cLocalDriver(), cNewFilN, cCheckArea( "TikAnu", @dbfTmpN ), .f. )
      if !NetErr()
         ( dbfTmpN )->( OrdCondSet( "!Deleted()", {||!Deleted() } ) )
         ( dbfTmpN )->( OrdCreate( cNewFilN, "cNumTil", "cSerTil + cNumTil + cSufTil", {|| Field->cSerTil + Field->cNumTil + Field->cSufTil } ) )
      end if

      lCreateTemporal      := .t.

   else

      ( dbfTmpN )->( __dbZap() )

   end if

   if dbSeekInOrd( cNumTik, "cNumTiL", dbfTikL )

      while ( dbfTikL )->cSerTil + ( dbfTikL )->cNumTil + ( dbfTikL )->cSufTil == cNumTik .and. !( dbfTikL )->( Eof() )

         if ( dbfTikL )->lAnulado

            dbPass( dbfTikL, dbfTmpN, .t. )

            /*
            Limpiamos la marca-------------------------------------------------
            */

            if dbLock( dbfTikL )
               ( dbfTikL )->lAnulado    := .f.
               ( dbfTikL )->( dbUnLock() )
            end if

            /*
            Impresora una------------------------------------------------------
            */

            if !Empty( ( dbfTikL )->cImpCom1 ) .and. AllTrim( ( dbfTikL )->cImpCom1 )  != "No imprimir"

               if aScan( aImp, ( dbfTikL )->cImpCom1 ) == 0
                  aAdd( aImp, ( dbfTikL )->cImpCom1 )
               end if

            end if

            /*
            Impresora Dos------------------------------------------------------
            */

            if !Empty( ( dbfTikL )->cImpCom2 ) .and. AllTrim( ( dbfTikL )->cImpCom2 ) != "No imprimir"

               if aScan( aImp, ( dbfTikL )->cImpCom2 ) == 0
                  aAdd( aImp, ( dbfTikL )->cImpCom2 )
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

      ( dbfTmpN )->( dbSetFilter( {|| ( Field->cImpCom1 == aImp[ nPos ] .or. Field->cImpCom2 == aImp[ nPos ] ) }, "( Field->cImpCom1 == aImp[ nPos ] .or. Field->cImpCom2 == aImp[ nPos ] )" ) )

      /*
      Imprimimos la comanda por la impresora correspondiente-------------------
      */

      if dbSeekInOrd( cNumTik, "cNumTik", dbfTikT )

         cPrinter := cNombreImpresoraComanda( oUser():cCaja(), aImp[ nPos ], dbfCajL )
         cFormato := cFormatoAnulacionEnCaja( oUser():cCaja(), aImp[ nPos ], dbfCajT, dbfCajL )

         if !Empty( cPrinter )
            GenTikCli( IS_PRINTER, "Imprimiendo anulacion", cFormato, AllTrim( cPrinter ), .f., .t., aImp[ nPos ] )
         end if

      end if

      /*
      Destruimos el filtro-----------------------------------------------------
      */

      ( dbfTmpN )->( dbClearFilter() )

      /*
      Reproducimos el archivo Wav----------------------------------------------
      */

      cWav        := AllTrim( cWavImpresoraComanda( oUser():cCaja(), aImp[ nPos ], dbfCajL ) )

      if !Empty( cWav ) .and. File( cWav )

         SndPlaySound( cWav )

      end if

   next

   /*
   Matamos la temporal---------------------------------------------------------
   */

   if lCreateTemporal

      if !Empty( dbfTmpN ) .and. ( dbfTmpN )->( Used() )
         ( dbfTmpN )->( dbCloseArea() )
      end if

      dbfErase( cNewFilN )

      dbfTmpN  := nil

   end if

   CursorWE()

return ( .t. )

//---------------------------------------------------------------------------//

static function lBuscaOferta( cCodArt, aGet, aTmp, aTmpTik, dbfOferta, dbfArticulo, dbfDiv, dbfKit, dbfIva  )

   local sOfeArt
   local nTotalLinea    := 0


   if ( dbfArticulo )->Codigo == cCodArt .or. ( dbfArticulo )->( dbSeek( cCodArt ) )

      /*
      Buscamos si existen ofertas por artículo----------------------------
      */

      nTotalLinea := lCalcDeta( aTmp, nil, .t. )

      sOfeArt     := sOfertaArticulo( Padr( cCodArt, 18 ), aTmpTik[ _CCLITIK ], aTmpTik[ _CCODGRP ], aTmp[ _NUNTTIL ], aTmpTik[ _DFECTIK ], dbfOferta, aTmpTik[ _NTARIFA ], .t., aTmp[_CCODPR1], aTmp[_CCODPR2], aTmp[_CVALPR1], aTmp[_CVALPR2], aTmp[ _CDIVTIK ], dbfArticulo, dbfDiv, dbfKit, dbfIva, 1, nTotalLinea )

      if !Empty( sOfeArt ) 

         if ( sOfeArt:nPrecio != 0 )
            aGet[ _NPVPTIL ]:cText( sOfeArt:nPrecio )
         end if

         if ( sOfeArt:nDtoPorcentual != 0 )
            aGet[ _NDTOLIN ]:cText( sOfeArt:nDtoPorcentual )
         end if

         if ( sOfeArt:nDtoLineal != 0)
            aGet[ _NDTODIV ]:cText( sOfeArt:nDtoLineal )
         end if

         aTmp[ _LLINOFE  ] := .t.

         if !Empty( aGet[ _LLINOFE ] )
            aGet[ _LLINOFE ]:Show()
         end if

      end if

      if !aTmp[ _LLINOFE ]

         /*
         Buscamos si existen ofertas por familia----------------------------
         */

         sOfeArt     := sOfertaFamilia( ( dbfArticulo )->Familia, aTmpTik[ _CCLITIK ], aTmpTik[ _CCODGRP ], aTmpTik[ _DFECTIK ], dbfOferta, aTmpTik[ _NTARIFA ], dbfArticulo, aTmp[ _NUNTTIL ], 1, nTotalLinea )

         if !Empty( sOfeArt ) 
            
            if ( sOfeArt:nDtoPorcentual != 0 )
               aGet[ _NDTOLIN ]:cText( sOfeArt:nDtoPorcentual )
            end if 
            
            if ( sOfeArt:nDtoLineal != 0 )
               aGet[ _NDTODIV ]:cText( sOfeArt:nDtoLineal )
            end if 
            
            aTmp[ _LLINOFE ]  := .t.
            
            if !Empty( aGet[ _LLINOFE ] )
               aGet[ _LLINOFE ]:Show()
            end if     

         end if

      end if

      if !aTmp[ _LLINOFE ]

         /*
         Buscamos si existen ofertas por tipos de articulos--------------
         */

         sOfeArt     := sOfertaTipoArticulo( ( dbfArticulo )->cCodTip, aTmpTik[ _CCLITIK ], aTmpTik[ _CCODGRP ], aTmpTik[ _DFECTIK ], dbfOferta, aTmpTik[ _NTARIFA ], dbfArticulo, aTmp[ _NUNTTIL ], 1, nTotalLinea )

         if !Empty( sOfeArt ) 
            
            if ( sOfeArt:nDtoPorcentual != 0 )
               aGet[ _NDTOLIN ]:cText( sOfeArt:nDtoPorcentual )
            end if 
            
            if ( sOfeArt:nDtoLineal != 0 )
               aGet[ _NDTODIV ]:cText( sOfeArt:nDtoLineal )
            end if 
            
            aTmp[ _LLINOFE ]  := .t.
            
            if !Empty( aGet[ _LLINOFE ] )
               aGet[ _LLINOFE ]:Show()
            end if     

         end if

      end if

      if !aTmp[ _LLINOFE ]

         /*
         Buscamos si existen ofertas por tipos de articulos--------------
         */

         sOfeArt     := sOfertaCategoria( ( dbfArticulo )->cCodCate, aTmpTik[ _CCLITIK ], aTmpTik[ _CCODGRP ], aTmpTik[ _DFECTIK ], dbfOferta, aTmpTik[ _NTARIFA ], dbfArticulo, aTmp[ _NUNTTIL ], 1, nTotalLinea )

         if !Empty( sOfeArt ) 
            
            if ( sOfeArt:nDtoPorcentual != 0 )
               aGet[ _NDTOLIN ]:cText( sOfeArt:nDtoPorcentual )
            end if 
            
            if ( sOfeArt:nDtoLineal != 0 )
               aGet[ _NDTODIV ]:cText( sOfeArt:nDtoLineal )
            end if 
            
            aTmp[ _LLINOFE ]  := .t.
            
            if !Empty( aGet[ _LLINOFE ] )
               aGet[ _LLINOFE ]:Show()
            end if     

         end if

      end if

      if !aTmp[ _LLINOFE ]

         /*
         Buscamos si existen ofertas por temporadas----------------------
         */

         sOfeArt     := sOfertaTemporada( ( dbfArticulo )->cCodTemp, aTmpTik[ _CCLITIK ], aTmpTik[ _CCODGRP ], aTmpTik[ _DFECTIK ], dbfOferta, aTmpTik[ _NTARIFA ], dbfArticulo, aTmp[ _NUNTTIL ], 1, nTotalLinea )

         if !Empty( sOfeArt ) 
            
            if ( sOfeArt:nDtoPorcentual != 0 )
               aGet[ _NDTOLIN ]:cText( sOfeArt:nDtoPorcentual )
            end if 
            
            if ( sOfeArt:nDtoLineal != 0 )
               aGet[ _NDTODIV ]:cText( sOfeArt:nDtoLineal )
            end if 
            
            aTmp[ _LLINOFE ]  := .t.
            
            if !Empty( aGet[ _LLINOFE ] )
               aGet[ _LLINOFE ]:Show()
            end if     

         end if

      end if

      if !aTmp[ _LLINOFE ]

         /*
         Buscamos si existen ofertas por fabricantes---------------------------
         */

         sOfeArt     := sOfertaFabricante( ( dbfArticulo )->cCodFab, aTmpTik[ _CCLITIK ], aTmpTik[ _CCODGRP ], aTmpTik[ _DFECTIK ], dbfOferta, aTmpTik[ _NTARIFA ], dbfArticulo, aTmp[ _NUNTTIL ], 1, nTotalLinea )

         if !Empty( sOfeArt ) 
            
            if ( sOfeArt:nDtoPorcentual != 0 )
               aGet[ _NDTOLIN ]:cText( sOfeArt:nDtoPorcentual )
            end if 
            
            if ( sOfeArt:nDtoLineal != 0 )
               aGet[ _NDTODIV ]:cText( sOfeArt:nDtoLineal )
            end if 
            
            aTmp[ _LLINOFE ]  := .t.
            
            if !Empty( aGet[ _LLINOFE ] )
               aGet[ _LLINOFE ]:Show()
            end if     

         end if

      end if

   end if

return .t.

//--------------------------------------------------------------------------//

Function lLockMesa( cSala, cPunto, cTikM )

   local lClose      := .f.
   local lReturn     := .f.

   DEFAULT cTikM     := dbfTikM
   DEFAULT cSala     := ""
   DEFAULT cPunto    := ""

   if Empty( cTikM )

      USE ( cPatEmp() + "TIKEM.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIKEM", @cTikM ) )
      SET ADSINDEX TO ( cPatEmp() + "TIKEM.CDX" ) ADDITIVE

      lClose         := .t.

   end if

   if !( cTikM )->( dbSeek( cSala + cPunto ) )

      ( cTikM )->( dbAppend() )
      ( cTikM )->cCodSala   := cSala
      ( cTikM )->cPntVenta  := cPunto
      ( cTikM )->( dbUnLock() )

   end if

   /*
   Bloqueo el registro---------------------------------------------------------
   */

   if !dbDialogLock( cTikM )
      lReturn        := .t.
   end if

   /*
   Cierro la tabla si la he abierto--------------------------------------------
   */

   if lClose
      CLOSE( cTikM )
   end if

return lReturn

//---------------------------------------------------------------------------//

function lFreeMesa( cSala, cPunto, cTikM )

   local lClose      := .f.

   DEFAULT  cTikM    := dbfTikM
   DEFAULT  cSala    := ""
   DEFAULT  cPunto   := ""

   if Empty( cTikM )

      USE ( cPatEmp() + "TIKEM.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIKEM", @cTikM ) )
      SET ADSINDEX TO ( cPatEmp() + "TIKEM.CDX" ) ADDITIVE

      lClose         := .t.

   end if

   if ( cTikM )->( dbSeek( cSala + cPunto ) )

      /*
      Liberamos el registro-------------------------------------------------------
      */

      dbSafeUnLock( cTikM )

      /*
      Borramos el registro--------------------------------------------------------
      */

      if dbLock( cTikM )
         ( cTikM )->( dbDelete() )
         ( cTikM )->( dbUnLock() )
      end if

   end if

   /*
   Cerramos la tabla si la hemos abierto---------------------------------------
   */

   if lClose
      CLOSE( cTikM )
   end if

return .f.

//---------------------------------------------------------------------------//

Static Function EditarNumeroSerie( aTmp, oStock, nMode )

   local oNumerosSeries

   with object ( TNumerosSerie() )

      :lTicket          := .t.

      :nMode            := nMode

      :cCodArt          := aTmp[ _CCBATIL ]
      :cCodAlm          := aTmp[ _CALMLIN ]
      :nNumLin          := aTmp[ _NNUMLIN ]

      :nTotalUnidades   := nTotNTpv( aTmp )

      :oStock           := oStock

      :uTmpSer          := dbfTmpS

      :Resource()

   end with

Return ( nil )

//--------------------------------------------------------------------------//

Static Function lAddCobro( aTmp, oTotDiv, oBrwPgo )

   CursorWait()

   if aTmp[ _NCOBTIK ] != 0

      if dbAppe( dbfTmpP )
         ( dbfTmpP )->cCtaRec    := cCtaCob()
         ( dbfTmpP )->cTurPgo    := cCurSesion()
         ( dbfTmpP )->dPgoTik    := GetSysDate()
         ( dbfTmpP )->cTimTik    := SubStr( Time(), 1, 5 )
         ( dbfTmpP )->cCodCaj    := oUser():cCaja()
         ( dbfTmpP )->nImpTik    := oTotDiv:nCobrado
         ( dbfTmpP )->cFpgPgo    := aTmp[ _CFPGTIK ]
         ( dbfTmpP )->cSerTik    := aTmp[ _CSERTIK ]
         ( dbfTmpP )->cNumTik    := aTmp[ _CNUMTIK ]
         ( dbfTmpP )->cSufTik    := aTmp[ _CSUFTIK ]
         ( dbfTmpP )->cDivPgo    := aTmp[ _CDIVTIK ]
         ( dbfTmpP )->nVdvPgo    := aTmp[ _NVDVTIK ]
         ( dbfTmpP )->nDevTik    := Max( aTmp[ _NCAMTIK ], 0 )
      else
         MsgStop( "No se ha podido añadir el registro de pago" )
      end if

   end if

   CalImpCob( aTmp )

   oBrwPgo:Refresh()

   CursorWE()

Return ( nil )

//----------------------------------------------------------------------------//

FUNCTION sTotTikCli( cNumTik, cTikT, cTikL, cDiv, cDivRet )

   local sTotal

   nTotTik( cNumTik, cTikT, cTikL, cDiv, nil, cDivRet )   

   sTotal                                 := sTotal()

   sTotal:nTotalBruto                     := nTotBrt
   sTotal:nTotalNeto                      := nTotNet
   sTotal:nTotalIva                       := nTotIva
   sTotal:nTotalDocumento                 := nTotTik
   sTotal:nTotalCosto                     := nTotCos
   sTotal:nTotalImpuestoHidrocarburos     := nTotIvm
   sTotal:nTotalRentabilidad              := nTotRnt

   sTotal:nTotalDescuentoProntoPago       := nTotDpp

   sTotal:aTotalIva                       := aImpTik

Return ( sTotal )

//--------------------------------------------------------------------------//
