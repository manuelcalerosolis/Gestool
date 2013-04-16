#ifndef __PDA__
   #include "FiveWin.Ch"
   #include "Folder.ch"
   #include "Report.ch"
   #include "Menu.ch"
   #include "Xbrowse.ch"
#else
   #include "FWCE.ch"
REQUEST DBFCDX
#endif

#include "Factu.ch"

#define CLR_BAR                   14197607
#define _MENUITEM_                "01057"

#define IGIC_DESG                  1
#define IGIC_INCL                  2

/*
Definición de la base de datos de albaranes a CLIENTES
*/

#define _CSERALB                  1
#define _NNUMALB                  2
#define _CSUFALB                  3
#define _CTURALB                  4
#define _DFECALB                  5
#define _CCODCLI                  6
#define _CCODALM                  7
#define _CCODCAJ                  8
#define _CNOMCLI                  9
#define _CDIRCLI                  10
#define _CPOBCLI                  11
#define _CPRVCLI                  12
#define _CPOSCLI                  13
#define _CDNICLI                  14
#define _LMODCLI                  15
#define _LFACTURADO               16
#define _LENTREGADO               17
#define _DFECENT                  18
#define _CCODSUALB                19
#define _CCONDENT                 20
#define _MCOMENT                  21
#define _MOBSERV                  22
#define _CCODPAGO                 23
#define _NBULTOS                  24
#define _NPORTES                  25
#define _CCODAGE                  26
#define _CCODOBR                  27
#define _CCODTAR                  28
#define _CCODRUT                  29
#define _CNUMPED                  30
#define _CNUMPRE                  31
#define _CNUMSAT                  32
#define _NTIPOALB                 33
#define _CNUMFAC                  34
#define _LMAYOR                   35
#define _NTARIFA                  36
#define _CDTOESP                  37
#define _NDTOESP                  38
#define _CDPP                     39
#define _NDPP                     40
#define _CDTOUNO                  41
#define _NDTOUNO                  42
#define _CDTODOS                  43
#define _NDTODOS                  44
#define _NDTOCNT                  45
#define _NDTORAP                  46
#define _NDTOPUB                  47
#define _NDTOPGO                  48
#define _NDTOPTF                  49
#define _LRECARGO                 50
#define _NPCTCOMAGE               51
#define _LSNDDOC                  52
#define _CDIVALB                  53
#define _NVDVALB                  54
#define _CRETPOR                  55
#define _CRETMAT                  56
#define _CNUMDOC                  57
#define _CSUPED                   58
#define _LIVAINC                  59
#define _NREGIVA                  60
#define _LGENLQD                  61
#define _NNUMORD                  62
#define _CSUFORD                  63
#define _DFECORD                  64
#define _NIVAMAN                  65
#define _NMANOBR                  66
#define _CCODTRN                  67
#define _NKGSTRN                  68
#define _LCLOALB                  69
#define _CCODUSR                  70
#define _DFECCRE                  71
#define _CTIMCRE                  72
#define _DFECENV                  73
#define _CCODGRP                  74
#define _LIMPRIMIDO               75
#define _DFECIMP                  76
#define _CHORIMP                  77
#define _CCODDLG                  78
#define _NDTOATP                  79
#define _NSBRATP                  80
#define _NMONTAJE                 81
#define _DFECENTR                 82
#define _DFECSAL                  83
#define _LALQUILER                84
#define _CMANOBR                  85
#define _LORDCAR                  86
#define _CNUMTIK                  87
#define _CTLFCLI                  88
#define _NTOTNET                  89
#define _NTOTIVA                  90
#define _NTOTREQ                  91
#define _NTOTALB                  92
#define _NTOTPAG                  93
#define _LOPERPV                  94
#define _CBANCO                   95
#define _CENTBNC                  96
#define _CSUCBNC                  97
#define _CDIGBNC                  98
#define _CCTABNC                  99

/*
Definici¢n de la base de datos de lineas de detalle
*/

#define _dCSERALB                 1
#define _dNNUMALB                 2
#define _dCSUFALB                 3
#define _CREF                     4
#define _CDETALLE                 5
#define _NSATUNIT                 6
#define _NPNTVER                  7
#define _NIMPTRN                  8
#define _NDTO                     9
#define _NDTOPRM                  10
#define _NIVA                     11
#define _NCANENT                  12
#define _NCANFAC                  13
#define _LCONTROL                 14
#define _NPESOKG                  15
#define _CPESOKG                  16
#define _CUNIDAD                  17
#define _NCOMAGE                  18
#define _NUNICAJA                 19
#define _NUNDKIT                  20
#define _DFECHA                   21
#define _CTIPMOV                  22
#define _MLNGDES                  23
#define _LTOTLIN                  24
#define _LIMPLIN                  25
#define _LNEWLIN                  26
#define _dCNUMPED                 27
#define _CCODPR1                  28
#define _CCODPR2                  29
#define _CVALPR1                  30
#define _CVALPR2                  31
#define _NFACCNV                  32
#define _NDTODIV                  33
#define _NNUMLIN                  34      //   N      4     0
#define _NCTLSTK                  35      //   N      1     0
#define _NCOSDIV                  36      //   N     13     3
#define _NPVSATC                  37      //   N     13     3
#define _CALMLIN                  38      //   C     3      0
#define _LIVALIN                  39
#define _NVALIMP                  40      //   N    16      6
#define _CCODIMP                  41      //   C     3      0
#define _LLOTE                    42      //   L     1      0
#define _NLOTE                    43      //   N     4      0
#define _CLOTE                    44
#define _DFECCAD                  45
#define _LKITART                  46      //   L     4      0
#define _LKITCHL                  47      //   L     4      0
#define _LKITPRC                  48      //   L     4      0
#define _NMESGRT                  49      //   N     2      0
#define _LMSGVTA                  50
#define _LNOTVTA                  51
#define _MNUMSER                  52
#define _CCODTIP                  53      //   C     3      0
#define _CCODFAM                  54      //   C     8      0
#define _CGRPFAM                  55      //   C     3      0
#define _NREQ                     56      //   N    16      6
#define _MOBSLIN                  57      //   M    10      0
#define _CCODPRV                  58      //   C    12      0
#define _CNOMPRV                  59      //   C    30      0
#define _CIMAGEN                  60      //   C    30      0
#define _NPUNTOS                  61
#define _NVALPNT                  62
#define _NDTOPNT                  63
#define _NINCPNT                  64
#define _CREFPRV                  65
#define _NVOLUMEN                 66
#define _CVOLUMEN                 67
#define __DFECENT                 68
#define __DFECSAL                 69
#define _NSATALQ                  70
#define __LALQUILER               71
#define _NNUMMED                  72
#define _NMEDUNO                  73
#define _NMEDDOS                  74
#define _NMEDTRE                  75
#define _NTARLIN                  76      //   L      1     0
#define _CCODUBI1                 77
#define _CCODUBI2                 78
#define _CCODUBI3                 79
#define _CVALUBI1                 80
#define _CVALUBI2                 81
#define _CVALUBI3                 82
#define _CNOMUBI1                 83
#define _CNOMUBI2                 84
#define _CNOMUBI3                 85
#define _LIMPFRA                  86
#define _CCODFRA                  87
#define _CTXTFRA                  88
#define _DESCRIP                  89
#define _dLFACTURADO              90      //   L      1     0
#define _LLINOFE                  91      //   L      1     0
#define _LVOLIMP                  92
#define __DFECALB                 93

/*
Definici¢n de Array para IGIC
*/

#define _NBRTIVA1                aTotIva[ 1, 1 ]
#define _NBASIVA1                aTotIva[ 1, 2 ]
#define _NPCTIVA1                aTotIva[ 1, 3 ]
#define _NPCTREQ1                aTotIva[ 1, 4 ]
#define _NPNTVER1                aTotIva[ 1, 5 ]
#define _NIVMIVA1                aTotIva[ 1, 6 ]
#define _NTRNIVA1                aTotIva[ 1, 7 ]
#define _NIMPIVA1                aTotIva[ 1, 8 ]
#define _NIMSATQ1                aTotIva[ 1, 9 ]
#define _NBRTIVA2                aTotIva[ 2, 1 ]
#define _NBASIVA2                aTotIva[ 2, 2 ]
#define _NPCTIVA2                aTotIva[ 2, 3 ]
#define _NPCTREQ2                aTotIva[ 2, 4 ]
#define _NPNTVER2                aTotIva[ 2, 5 ]
#define _NIVMIVA2                aTotIva[ 2, 6 ]
#define _NTRNIVA2                aTotIva[ 2, 7 ]
#define _NIMPIVA2                aTotIva[ 2, 8 ]
#define _NIMSATQ2                aTotIva[ 2, 9 ]
#define _NBRTIVA3                aTotIva[ 3, 1 ]
#define _NBASIVA3                aTotIva[ 3, 2 ]
#define _NPCTIVA3                aTotIva[ 3, 3 ]
#define _NPCTREQ3                aTotIva[ 3, 4 ]
#define _NPNTVER3                aTotIva[ 3, 5 ]
#define _NIVMIVA3                aTotIva[ 3, 6 ]
#define _NTRNIVA3                aTotIva[ 3, 7 ]
#define _NIMPIVA3                aTotIva[ 3, 8 ]
#define _NIMSATQ3                aTotIva[ 3, 9 ]

memvar cDbf
memvar cDbfCol
memvar cDbfPag
memvar cCliente
memvar cDbfCli
memvar cIva
memvar cDbfIva
memvar cDbfDiv
memvar cDbfUsr
memvar cFPago
memvar cDbfPgo
memvar cAgent
memvar cDbfAge
memvar cTvta
memvar cObras
memvar cDbfObr
memvar cTarPreL
memvar cTarPreS
memvar cDbfRut
memvar cDbfTrn
memvar cDbfPro
memvar cDbfDlg
memvar cDbfTblPro
memvar cDbfAnt
memvar aTotIva
memvar cCtaCli
memvar nTotBrt
memvar nTotDto
memvar nTotDpp
memvar nTotUno
memvar nTotDos
memvar nTotNet
memvar nTotIva
memvar nTotIvm
memvar aTotIvm
memvar nTotReq
memvar nTotImp
memvar nTotAlb
memvar nTotPag
memvar nTotEur
memvar nTotPnt
memvar nTotPes
memvar nTotCos
memvar nTotAge
memvar nTotTrn
memvar nTotRnt
memvar nTotDif
memvar nTotAtp
memvar nPctRnt
memvar aIvaUno
memvar aIvaDos
memvar aIvaTre
memvar aIvmUno
memvar aIvmDos
memvar aIvmTre
memvar nVdvDivAlb
memvar cPicUndAlb
memvar cPouDivAlb
memvar cPorDivAlb
memvar cPpvDivAlb
memvar cPouEurAlb
memvar nDouDivAlb
memvar nRouDivAlb
memvar nTotArt
memvar nTotCaj
memvar cPorDivEnt
memvar cDbfEnt
memvar nTotPage
memvar oStk
memvar nTotalDto

memvar lEnd
memvar nRow
memvar oInf
memvar nPagina
memvar oReport

/*
Definici¢n de Array para objetos IGIC
*/

static oWndBrw
static oBrwIva
static dbfUsr
static dbfAlbCliT
static dbfAlbCliL
static dbfAlbCliI
static dbfAlbCliD
static dbfAlbCliP
static dbfAlbCliS
static dbfProSer
static dbfMatSer
static dbfAlbPrvL
static dbfAlbPrvS
static dbfTmpLin
static dbfTmpInc
static dbfTmpDoc
static dbfTmpPgo
static dbfTmpSer
static dbfAntCliT
static dbfDelega
static dbfCount
static cTmpLin
static cTmpInc
static cTmpDoc
static cTmpPgo
static cTmpSer
static dbfInci
static dbfRuta
static dbfIva
static dbfClient
static dbfCliInc
static dbfCliBnc
static dbfArtPrv
static dbfAlm
static dbfFPago
static dbfAgent
static dbfTarPreL
static dbfTarPreS
static dbfPedCliT
static dbfPedCliL
static dbfPedCliR
static dbfPedCliP
static dbfPedCliI
static dbfPedCliD
static dbfPreCliT
static dbfPreCliL
static dbfPreCliI
static dbfPreCliD
static dbfSatCliT
static dbfSatCliL
static dbfSatCliI
static dbfSatCliD
static dbfSatCliS
static dbfFacCliT
static dbfFacCliL
static dbfFacCliS
static dbfFacCliP
static dbfFacRecT
static dbfFacRecL
static dbfFacRecS
static dbfPedPrvL
static dbfTikT
static dbfTikL
static dbfTikS
static dbfArticulo
static dbfCodebar
static dbfPromoT
static dbfPromoL
static dbfPromoC
static dbfCliAtp
static dbfTVta
static dbfTblPro
static dbfPro
static dbfCajT
static dbfFacPrvL
static dbfFacPrvS
static dbfRctPrvL
static dbfRctPrvS
static dbfProLin
static dbfProMat
static dbfHisMov
static dbfHisMovS
static dbfEmp
static oFont
static oMenu
static oStock
static oGrpCli
static oTrans
static oNewImp
static oUndMedicion
static dbfDiv
static oBandera
static dbfKit
static dbfDoc
static dbfFlt
static dbfTblCnv
static dbfOferta
static dbfObrasT
static dbfFamilia
static dbfArtDiv
static dbfUbicaL
static dbfAgeCom
static oGetTotal
static oGetIvm
static oGetRnt
static oGetMasDiv
static cGetMasDiv       := ""
static oGetNet
static oGetIva
static oGetReq
static oGetAge
static oComisionLinea
static nComisionLinea   := 0
static oGetTrn
static oGetPnt
static cPouDiv
static cPorDiv
static cPpvDiv
static cPouEur
static cPicUnd
static nVdvDiv
static nDouDiv
static nRouDiv
static nDorDiv
static nDpvDiv

static oTipArt
static oGrpFam
static oFraPub

static oBtnPre
static oBtnSat
static oBtnPed
static oBtnAgruparPedido
static oBtnAgruparSAT

static aNumPed          := {}
static aNumSat          := {}
static oGetAlb
static oGetEnt
static oGetPdt
static oGetPes
static oGetDif
static nTotOld
static nNumCaj          := 0
static cOldCodCli       := ""
static cOldCodArt       := ""
static cOldPrpArt       := ""
static cOldUndMed       := ""
static lOpenFiles       := .f.
static lExternal        := .f.
static aTipAlb          := { "Venta", "Alquiler" }
static oTipAlb
static cFiltroUsuario   := ""
static oTotAlbLin

static aPedidos         := {}
static aSats            := {}

#ifndef __PDA__

static bEdtRec          := { | aTmp, aGet, dbfAlbCliT, oBrw, bWhen, bValid, nMode, aNumDoc | EdtRec( aTmp, aGet, dbfAlbCliT, oBrw, bWhen, bValid, nMode, aNumDoc ) }
static bEdtDet          := { | aTmp, aGet, dbfAlbCliL, oBrw, bWhen, bValid, nMode, aTmpAlb | EdtDet( aTmp, aGet, dbfAlbCliL, oBrw, bWhen, bValid, nMode, aTmpAlb ) }
static bEdtInc          := { | aTmp, aGet, dbfAlbCliI, oBrw, bWhen, bValid, nMode, aTmpLin | EdtInc( aTmp, aGet, dbfAlbCliI, oBrw, bWhen, bValid, nMode, aTmpLin ) }
static bEdtDoc          := { | aTmp, aGet, dbfAlbCliD, oBrw, bWhen, bValid, nMode, aTmpLin | EdtDoc( aTmp, aGet, dbfAlbCliD, oBrw, bWhen, bValid, nMode, aTmpLin ) }
static bEdtPgo          := { | aTmp, aGet, dbfAlbCliP, oBrw, bWhen, bValid, nMode, aTmpAlb | EdtEnt( aTmp, aGet, dbfAlbCliP, oBrw, bWhen, bValid, nMode, aTmpAlb ) }

#else

static bEdtPda          := { | aTmp, aGet, dbfAlbCliT, oBrw, bWhen, bValid, nMode          | EdtPda( aTmp, aGet, dbfAlbCliT, oBrw, bWhen, bValid, nMode ) }
static bDetPda          := { | aTmp, aGet, dbfAlbCliL, oBrw, bWhen, bValid, nMode, aTmpAlb | DetPda( aTmp, aGet, dbfAlbCliL, oBrw, bWhen, bValid, nMode, aTmpAlb ) }
static bIncPda          := { | aTmp, aGet, dbfAlbCliI, oBrw, bWhen, bValid, nMode, aTmpLin | IncPda( aTmp, aGet, dbfAlbCliI, oBrw, bWhen, bValid, nMode, aTmpLin ) }

#endif

#ifndef __PDA__

//--------------------------------------------------------------------------//
//Funciones para el programa
//--------------------------------------------------------------------------//

STATIC FUNCTION OpenFiles()

   local oError
   local oBlock

   if lOpenFiles
      MsgStop( 'Imposible abrir ficheros de albaranes de clientes' )
      Return ( .f. )
   end if

   oBlock               := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      // DisableAcceso()

      lOpenFiles        := .t.

      USE ( cPatEmp() + "ALBCLIL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALBCLIL", @dbfAlbCliL ) )
      SET ADSINDEX TO ( cPatEmp() + "ALBCLIL.CDX" ) ADDITIVE

      USE ( cPatEmp() + "ALBCLII.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALBCLII", @dbfAlbCliI ) )
      SET ADSINDEX TO ( cPatEmp() + "ALBCLII.CDX" ) ADDITIVE

      USE ( cPatEmp() + "ALBCLID.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALBCLID", @dbfAlbCliD ) )
      SET ADSINDEX TO ( cPatEmp() + "ALBCLID.CDX" ) ADDITIVE

      USE ( cPatEmp() + "ALBCLIP.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALBCLIP", @dbfAlbCliP ) )
      SET ADSINDEX TO ( cPatEmp() + "ALBCLIP.CDX" ) ADDITIVE

      USE ( cPatEmp() + "ALBCLIS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALBCLIS", @dbfAlbCliS ) )
      SET ADSINDEX TO ( cPatEmp() + "ALBCLIS.CDX" ) ADDITIVE

      USE ( cPatEmp() + "PreCliT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PreCliT", @dbfPreCliT ) )
      SET ADSINDEX TO ( cPatEmp() + "PreCliT.CDX" ) ADDITIVE

      USE ( cPatEmp() + "PreCliL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PreCliT", @dbfPreCliL ) )
      SET ADSINDEX TO ( cPatEmp() + "PreCliL.CDX" ) ADDITIVE

      USE ( cPatEmp() + "PreCliI.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PreCliI", @dbfPreCliI ) )
      SET ADSINDEX TO ( cPatEmp() + "PreCliI.CDX" ) ADDITIVE

      USE ( cPatEmp() + "PreCliD.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PreCliD", @dbfPreCliD ) )
      SET ADSINDEX TO ( cPatEmp() + "PreCliD.CDX" ) ADDITIVE

      if !TDataCenter():OpenSatCliT( @dbfSatCliT )
   lOpenFiles        := .f.
end if
      SET ADSINDEX TO ( cPatEmp() + "SatCliT.CDX" ) ADDITIVE

      USE ( cPatEmp() + "SatCliL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "SatCliL", @dbfSatCliL ) )
      SET ADSINDEX TO ( cPatEmp() + "SatCliL.CDX" ) ADDITIVE

      USE ( cPatEmp() + "SatCliI.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "SatCliI", @dbfSatCliI ) )
      SET ADSINDEX TO ( cPatEmp() + "SatCliI.CDX" ) ADDITIVE

      USE ( cPatEmp() + "SatCliD.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "SatCliD", @dbfSatCliD ) )
      SET ADSINDEX TO ( cPatEmp() + "SatCliD.CDX" ) ADDITIVE

      USE ( cPatEmp() + "SatCliS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "SatCliS", @dbfSatCliS ) )
      SET ADSINDEX TO ( cPatEmp() + "SatCliS.CDX" ) ADDITIVE

      USE ( cPatEmp() + "PEDCLIT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PEDCLIT", @dbfPedCliT ) )
      SET ADSINDEX TO ( cPatEmp() + "PEDCLIT.CDX" ) ADDITIVE

      USE ( cPatEmp() + "PEDCLIL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PEDCLIL", @dbfPedCliL ) )
      SET ADSINDEX TO ( cPatEmp() + "PEDCLIL.CDX" ) ADDITIVE

      USE ( cPatEmp() + "PEDCLIR.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PEDCLIR", @dbfPedCliR ) )
      SET ADSINDEX TO ( cPatEmp() + "PEDCLIR.CDX" ) ADDITIVE

      USE ( cPatEmp() + "PEDCLIP.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PEDCLIP", @dbfPedCliP ) )
      SET ADSINDEX TO ( cPatEmp() + "PEDCLIP.CDX" ) ADDITIVE

      USE ( cPatEmp() + "PEDCLII.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PEDCLII", @dbfPedCliI ) )
      SET ADSINDEX TO ( cPatEmp() + "PEDCLII.CDX" ) ADDITIVE

      USE ( cPatEmp() + "PEDCLID.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PEDCLID", @dbfPedCliD ) )
      SET ADSINDEX TO ( cPatEmp() + "PEDCLID.CDX" ) ADDITIVE

      USE ( cPatEmp() + "TIKET.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIKET", @dbfTikT ) )
      SET ADSINDEX TO ( cPatEmp() + "TIKET.CDX" ) ADDITIVE
      SET TAG TO "cNumDoc"

      USE ( cPatEmp() + "TIKEL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIKEL", @dbfTikL ) )
      SET ADSINDEX TO ( cPatEmp() + "TIKEL.CDX" ) ADDITIVE

      USE ( cPatEmp() + "TIKES.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIKES", @dbfTikS ) )
      SET ADSINDEX TO ( cPatEmp() + "TIKES.CDX" ) ADDITIVE

      USE ( cPatCli() + "CLIENT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CLIENT", @dbfClient ) )
      SET ADSINDEX TO ( cPatCli() + "CLIENT.CDX" ) ADDITIVE

      USE ( cPatCli() + "CliInc.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CliInc", @dbfCliInc ) )
      SET ADSINDEX TO ( cPatCli() + "CliInc.Cdx" ) ADDITIVE

      USE ( cPatCli() + "CliBnc.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CLIBNC", @dbfCliBnc ) )
      SET ADSINDEX TO ( cPatCli() + "CliBnc.Cdx" ) ADDITIVE

      USE ( cPatArt() + "PROVART.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PROVART", @dbfArtPrv ) )
      SET ADSINDEX TO ( cPatArt() + "PROVART.CDX" ) ADDITIVE

      USE ( cPatDat() + "TIVA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIVA", @dbfIva ) )
      SET ADSINDEX TO ( cPatDat() + "TIVA.CDX" ) ADDITIVE

      USE ( cPatGrp() + "FPAGO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FPAGO", @dbfFPago ) )
      SET ADSINDEX TO ( cPatGrp() + "FPAGO.CDX" ) ADDITIVE

      USE ( cPatCli() + "CliAtp.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CLIATP", @dbfCliAtp ) )
      SET ADSINDEX TO ( cPatCli() + "CliAtp.Cdx" ) ADDITIVE

      USE ( cPatCli() + "AGENTES.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "AGENTES", @dbfAgent ) )
      SET ADSINDEX TO ( cPatCli() + "AGENTES.CDX" ) ADDITIVE

      USE ( cPatArt() + "TarPreL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TarPreL", @dbfTarPreL ) )
      SET ADSINDEX TO ( cPatArt() + "TarPreL.CDX" ) ADDITIVE

      USE ( cPatArt() + "TarPreS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TarPreS", @dbfTarPreS ) )
      SET ADSINDEX TO ( cPatArt() + "TarPreS.CDX" ) ADDITIVE

      USE ( cPatArt() + "PROMOT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PROMOT", @dbfPromoT ) )
      SET ADSINDEX TO ( cPatArt() + "PROMOT.CDX" ) ADDITIVE

      USE ( cPatArt() + "PROMOL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PROMOL", @dbfPromoL ) )
      SET ADSINDEX TO ( cPatArt() + "PROMOL.CDX" ) ADDITIVE

      USE ( cPatArt() + "PROMOC.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PROMOC", @dbfPromoC ) )
      SET ADSINDEX TO ( cPatArt() + "PROMOC.CDX" ) ADDITIVE

      USE ( cPatArt() + "ARTICULO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ARTICULO", @dbfArticulo ) )
      SET ADSINDEX TO ( cPatArt() + "ARTICULO.CDX" ) ADDITIVE

      USE ( cPatArt() + "ArtCodebar.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CODEBAR", @dbfCodebar ) )
      SET ADSINDEX TO ( cPatArt() + "ArtCodebar.Cdx" ) ADDITIVE

      USE ( cPatArt() + "FAMILIAS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FAMILIAS", @dbfFamilia ) )
      SET ADSINDEX TO ( cPatArt() + "FAMILIAS.CDX" ) ADDITIVE

      USE ( cPatArt() + "ARTKIT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ARTTIK", @dbfKit ) )
      SET ADSINDEX TO ( cPatArt() + "ARTKIT.CDX" ) ADDITIVE

      USE ( cPatDat() + "TVTA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TVTA", @dbfTVta ) )
      SET ADSINDEX TO ( cPatDat() + "TVTA.CDX" ) ADDITIVE

      USE ( cPatDat() + "DIVISAS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "DIVISAS", @dbfDiv ) )
      SET ADSINDEX TO ( cPatDat() + "DIVISAS.CDX" ) ADDITIVE

      USE ( cPatDat() + "CNFFLT.DBF" ) NEW SHARED VIA ( cDriver() )ALIAS ( cCheckArea( "CNFFLT", @dbfFlt ) )
      SET ADSINDEX TO ( cPatDat() + "CNFFLT.CDX" ) ADDITIVE

      USE ( cPatEmp() + "RDOCUMEN.DBF" ) NEW SHARED VIA ( cDriver() )ALIAS ( cCheckArea( "RDOCUMEN", @dbfDoc ) )
      SET ADSINDEX TO ( cPatEmp() + "RDOCUMEN.CDX" ) ADDITIVE
      SET TAG TO "CTIPO"

      USE ( cPatDat() + "TBLCNV.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TBLCNV", @dbfTblCnv ) )
      SET ADSINDEX TO ( cPatDat() + "TBLCNV.CDX" ) ADDITIVE

      USE ( cPatArt() + "OFERTA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "OFERTA", @dbfOferta ) )
      SET ADSINDEX TO ( cPatArt() + "OFERTA.CDX" ) ADDITIVE

      USE ( cPatCli() + "ObrasT.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "OBRAST", @dbfObrasT ) )
      SET ADSINDEX TO ( cPatCli() + "ObrasT.Cdx" ) ADDITIVE

      USE ( cPatArt() + "PRO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PRO", @dbfPro ) )
      SET ADSINDEX TO ( cPatArt() + "PRO.CDX" ) ADDITIVE

      USE ( cPatArt() + "TBLPRO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TBLPRO", @dbfTblPro ) )
      SET ADSINDEX TO ( cPatArt() + "TBLPRO.CDX" ) ADDITIVE

      USE ( cPatCli() + "RUTA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "RUTA", @dbfRuta ) )
      SET ADSINDEX TO ( cPatCli() + "RUTA.CDX" ) ADDITIVE

      USE ( cPatArt() + "ARTDIV.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ARTDIV", @dbfArtDiv ) )
      SET ADSINDEX TO ( cPatArt() + "ARTDIV.CDX" ) ADDITIVE

      USE ( cPatDat() + "Cajas.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CAJAS", @dbfCajT ) )
      SET ADSINDEX TO ( cPatDat() + "Cajas.Cdx" ) ADDITIVE

      USE ( cPatAlm() + "Almacen.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALMACEN", @dbfAlm ) )
      SET ADSINDEX TO ( cPatAlm() + "Almacen.Cdx" ) ADDITIVE

      USE ( cPatDat() + "USERS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "USERS", @dbfUsr ) )
      SET ADSINDEX TO ( cPatDat() + "USERS.CDX" ) ADDITIVE

      USE ( cPatEmp() + "TIPINCI.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIPINCI", @dbfInci ) )
      SET ADSINDEX TO ( cPatEmp() + "TIPINCI.CDX" ) ADDITIVE

      USE ( cPatEmp() + "AntCliT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "AntCliT", @dbfAntCliT ) )
      SET ADSINDEX TO ( cPatEmp() + "AntCliT.CDX" ) ADDITIVE

      USE ( cPatDat() + "DELEGA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "DELEGA", @dbfDelega ) )
      SET ADSINDEX TO ( cPatDat() + "DELEGA.CDX" ) ADDITIVE

      USE ( cPatEmp() + "NCOUNT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "NCOUNT", @dbfCount ) )
      SET ADSINDEX TO ( cPatEmp() + "NCOUNT.CDX" ) ADDITIVE

      USE ( cPatAlm() + "UBICAL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "UBICAL", @dbfUbicaL ) )
      SET ADSINDEX TO ( cPatAlm() + "UBICAL.CDX" ) ADDITIVE

      USE ( cPatGrp() + "AGECOM.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "AGECOM", @dbfAgeCom ) )
      SET ADSINDEX TO ( cPatGrp() + "AGECOM.CDX" ) ADDITIVE

      USE ( cPatEmp() + "FACCLIL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACCLIL", @dbfFacCliL ) )
      SET ADSINDEX TO ( cPatEmp() + "FACCLIL.CDX" ) ADDITIVE

      USE ( cPatEmp() + "FACCLIS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACCLIS", @dbfFacCliS ) )
      SET ADSINDEX TO ( cPatEmp() + "FACCLIS.CDX" ) ADDITIVE

      USE ( cPatEmp() + "FACRECT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACRECT", @dbfFacRecT ) )
      SET ADSINDEX TO ( cPatEmp() + "FACRECT.CDX" ) ADDITIVE

      USE ( cPatEmp() + "FACRECL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACRECL", @dbfFacRecL ) )
      SET ADSINDEX TO ( cPatEmp() + "FACRECL.CDX" ) ADDITIVE

      USE ( cPatEmp() + "FACRECS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACRECS", @dbfFacRecS ) )
      SET ADSINDEX TO ( cPatEmp() + "FACRECS.CDX" ) ADDITIVE

      USE ( cPatDat() + "Empresa.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "Empresa", @dbfEmp ) )
      SET ADSINDEX TO ( cPatDat() + "Empresa.CDX" ) ADDITIVE

      USE ( cPatEmp() + "ALBPROVL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALBPROVL", @dbfAlbPrvL ) )
      SET ADSINDEX TO ( cPatEmp() + "ALBPROVL.CDX" ) ADDITIVE
      SET TAG TO "cStkFast"

      USE ( cPatEmp() + "ALBPRVS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALBPRVS", @dbfAlbPrvS ) )
      SET ADSINDEX TO ( cPatEmp() + "ALBPRVS.CDX" ) ADDITIVE

      USE ( cPatEmp() + "FACPRVL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACPRVL", @dbfFacPrvL ) )
      SET ADSINDEX TO ( cPatEmp() + "FACPRVL.CDX" ) ADDITIVE
      SET TAG TO "cRef"

      USE ( cPatEmp() + "FACPRVS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACPRVS", @dbfFacPrvS ) )
      SET ADSINDEX TO ( cPatEmp() + "FACPRVS.CDX" ) ADDITIVE

      USE ( cPatEmp() + "RctPrvL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "RctPrvL", @dbfRctPrvL ) )
      SET ADSINDEX TO ( cPatEmp() + "RctPrvL.CDX" ) ADDITIVE
      SET TAG TO "cRef"

      USE ( cPatEmp() + "RctPrvS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "RctPrvS", @dbfRctPrvS ) )
      SET ADSINDEX TO ( cPatEmp() + "RctPrvS.CDX" ) ADDITIVE

      USE ( cPatEmp() + "PROLIN.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PROLIN", @dbfProLin ) )
      SET ADSINDEX TO ( cPatEmp() + "PROLIN.CDX" ) ADDITIVE
      SET TAG TO "cCodArt"

      USE ( cPatEmp() + "PROMAT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PROMAT", @dbfProMat ) )
      SET ADSINDEX TO ( cPatEmp() + "PROMAT.CDX" ) ADDITIVE
      SET TAG TO "cCodArt"

      USE ( cPatEmp() + "HISMOV.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "HISMOV", @dbfHisMov ) )
      SET ADSINDEX TO ( cPatEmp() + "HISMOV.CDX" ) ADDITIVE
      SET TAG TO "cRefMov"

      USE ( cPatEmp() + "MOVSER.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "MOVSER", @dbfHisMovS ) )
      SET ADSINDEX TO ( cPatEmp() + "MOVSER.CDX" ) ADDITIVE

      USE ( cPatEmp() + "PEDPROVL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PedPrvL", @dbfPedPrvL ) )
      SET ADSINDEX TO ( cPatEmp() + "PEDPROVL.CDX" ) ADDITIVE
      SET TAG TO "cRef"

      USE ( cPatEmp() + "PROSER.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PROSER", @dbfProSer ) )
      SET ADSINDEX TO ( cPatEmp() + "PROSER.CDX" ) ADDITIVE

      USE ( cPatEmp() + "MATSER.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "MATSER", @dbfMatSer ) )
      SET ADSINDEX TO ( cPatEmp() + "MATSER.CDX" ) ADDITIVE

      if !TDataCenter():OpenAlbCliT( @dbfAlbCliT )
         lOpenFiles     := .f.
      end if

      if !TDataCenter():OpenFacCliT( @dbfFacCliT )
         lOpenFiles     := .f.
      end if

      if !TDataCenter():OpenFacCliP( @dbfFacCliP )
         lOpenFiles     := .f.
      end if

      oBandera             := TBandera():New()

      oStock               := TStock():Create( cPatGrp() )
      if !oStock:lOpenFiles()
         lOpenFiles        := .f.
      end if

      oGrpCli           := TGrpCli():Create( cPatCli() )
      if !oGrpCli:OpenFiles()
         lOpenFiles     := .f.
      end if

      oNewImp           := TNewImp():Create( cPatEmp() )
      if !oNewImp:OpenFiles()
         lOpenFiles     := .f.
      end if

      oTrans            := TTrans():Create( cPatCli() )
      if !oTrans:OpenFiles()
         lOpenFiles     := .f.
      end if

      oTipArt           := TTipArt():Create( cPatArt() )
      if !oTipArt:OpenFiles()
         lOpenFiles     := .f.
      end if

      oGrpFam           := TGrpFam():Create( cPatArt() )
      if !oGrpFam:OpenFiles()
         lOpenFiles     := .f.
      end if

      oUndMedicion      := UniMedicion():Create( cPatGrp() )
      if !oUndMedicion:OpenFiles()
         lOpenFiles     := .f.
      end if

      oFraPub           := TFrasesPublicitarias():Create( cPatArt() )
      if !oFraPub:OpenFiles()
         lOpenFiles     := .f.
      end if

      /*
      Declaración de variables públicas----------------------------------------
      */

      public nTotBrt    := 0
      public nTotAlb    := 0
      public nTotDto    := 0
      public nTotDPP    := 0
      public nTotNet    := 0
      public nTotIva    := 0
      public nTotIvm    := 0
      public nTotAge    := 0
      public nTotReq    := 0
      public nTotPnt    := 0
      public nTotUno    := 0
      public nTotDos    := 0
      public nTotCos    := 0
      public nTotPes    := 0
      public nTotDif    := 0
      public nTotAtp    := 0
      public nTotTrn    := 0
      public nPctRnt    := 0
      public nTotRnt    := 0

      public aTotIva    := { { 0,0,nil,0,0,0,0,0,0 }, { 0,0,nil,0,0,0,0,0,0 }, { 0,0,nil,0,0,0,0,0,0 } }
      public aIvaUno    := aTotIva[ 1 ]
      public aIvaDos    := aTotIva[ 2 ]
      public aIvaTre    := aTotIva[ 3 ]

      public aTotIvm    := { { 0,nil,0 }, { 0,nil,0 }, { 0,nil,0 }, }
      public aIvmUno    := aTotIvm[ 1 ]
      public aIvmDos    := aTotIvm[ 2 ]
      public aIvmTre    := aTotIvm[ 3 ]

      public nTotPag    := 0

      public nTotArt    := 0
      public nTotCaj    := 0

      /*
      Limitaciones de cajero y cajas--------------------------------------------------------
      */

      if lAIS() .and. !oUser():lAdministrador()
      
         cFiltroUsuario    := "Field->cSufAlb == '" + oUser():cDelegacion() + "' .and. Field->cCodCaj == '" + oUser():cCaja() + "'"
         if oUser():lFiltroVentas()         
            cFiltroUsuario += " .and. Field->cCodUsr == '" + oUser():cCodigo() + "'"
         end if 

         ( dbfAlbCliT )->( AdsSetAOF( cFiltroUsuario ) )

      end if

   RECOVER USING oError

      lOpenFiles        := .f.

      msgStop( "Imposible abrir todas las bases de datos" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   if !lOpenFiles
      CloseFiles()
   end if

Return ( lOpenFiles )

//--------------------------------------------------------------------------//

STATIC FUNCTION CloseFiles()

   DisableAcceso()

   DestroyFastFilter( dbfAlbCliT, .t., .t. )

   if !Empty( oFont )
      oFont:end()
   end if

   if !Empty( dbfAlbCliT )
      ( dbfAlbCliT )->( dbCloseArea() )
   end if

   if !Empty( dbfClient )
      ( dbfClient    )->( dbCloseArea() )
   end if
   if !Empty( dbfIva )
      ( dbfIva       )->( dbCloseArea() )
   end if
   if !Empty( dbfFPago )
      ( dbfFPago     )->( dbCloseArea() )
   end if
   if !Empty( dbfAlbCliL )
      ( dbfAlbCliL   )->( dbCloseArea() )
   end if
   if !Empty( dbfAlbCliI )
      ( dbfAlbCliI   )->( dbCloseArea() )
   end if
   if !Empty( dbfAlbCliD )
      ( dbfAlbCliD   )->( dbCloseArea() )
   end if
   if !Empty( dbfAlbCliP )
      ( dbfAlbCliP   )->( dbCloseArea() )
   end if
   if !Empty( dbfAlbCliS )
      ( dbfAlbCliS   )->( dbCloseArea() )
   end if
   if !Empty( dbfTikT )
      ( dbfTikT      )->( dbCloseArea() )
   end if
   if !Empty( dbfPreCliT )
      ( dbfPreCliT )->( dbCloseArea() )
   end if
   if !Empty( dbfPreCliL )
      ( dbfPreCliL )->( dbCloseArea() )
   end if
   if !Empty( dbfPreCliI )
      ( dbfPreCliI )->( dbCloseArea() )
   end if
   if !Empty( dbfPreCliD )
      ( dbfPreCliD )->( dbCloseArea() )
   end if
   if !Empty( dbfSatCliT )
      ( dbfSatCliT )->( dbCloseArea() )
   end if
   if !Empty( dbfSatCliL )
      ( dbfSatCliL )->( dbCloseArea() )
   end if
   if !Empty( dbfSatCliI )
      ( dbfSatCliI )->( dbCloseArea() )
   end if
   if !Empty( dbfSatCliD )
      ( dbfSatCliD )->( dbCloseArea() )
   end if

   if !Empty( dbfSatCliS )
      ( dbfSatCliS )->( dbCloseArea() )
   end if

   if !Empty( dbfPedCliT )
      ( dbfPedCliT   )->( dbCloseArea() )
   end if
   if !Empty( dbfPedCliL )
      ( dbfPedCliL   )->( dbCloseArea() )
   end if
   if !Empty( dbfPedCliR )
      ( dbfPedCliR   )->( dbCloseArea() )
   end if
   if !Empty( dbfPedCliP )
      ( dbfPedCliP   )->( dbCloseArea() )
   end if
   if !Empty( dbfPedCliI )
      ( dbfPedCliI   )->( dbCloseArea() )
   end if
   if !Empty( dbfPedCliD )
      ( dbfPedCliD   )->( dbCloseArea() )
   end if
   if !Empty( dbfAgent )
      ( dbfAgent     )->( dbCloseArea() )
   end if
   if !Empty( dbfTarPreL )
      ( dbfTarPreL   )->( dbCloseArea() )
   end if
   if !Empty( dbfTarPreS )
      ( dbfTarPreS   )->( dbCloseArea() )
   end if
   if !Empty( dbfPromoT )
      ( dbfPromoT    )->( dbCloseArea() )
   end if
   if !Empty( dbfPromoL )
      ( dbfPromoL    )->( dbCloseArea() )
   end if
   if !Empty( dbfPromoC )
      ( dbfPromoC    )->( dbCloseArea() )
   end if
   if !Empty( dbfArticulo )
      ( dbfArticulo  )->( dbCloseArea() )
   end if
   if !Empty( dbfCodebar )
      ( dbfCodebar   )->( dbCloseArea() )
   end if
   if !Empty( dbfFamilia )
      ( dbfFamilia   )->( dbCloseArea() )
   end if
   if !Empty( dbfKit )
      ( dbfKit       )->( dbCloseArea() )
   end if
   if !Empty( dbfFlt )
      ( dbfFlt       )->( dbCloseArea() )
   end if
   if !Empty( dbfAlm )
      ( dbfAlm       )->( dbCloseArea() )
   end if
   if !Empty( dbfCliAtp )
      ( dbfCliAtp    )->( dbCloseArea() )
   end if
   if !Empty( dbfTVta )
      ( dbfTVta      )->( dbCloseArea() )
   end if
   if !Empty( dbfDiv )
      ( dbfDiv       )->( dbCloseArea() )
   end if
   if !Empty( dbfDoc )
      ( dbfDoc       )->( dbCloseArea() )
   end if
   if !Empty( dbfTblCnv )
      ( dbfTblCnv    )->( dbCloseArea() )
   end if
   if !Empty( dbfOferta )
      ( dbfOferta    )->( dbCloseArea() )
   end if
   if !Empty( dbfObrasT )
      ( dbfObrasT    )->( dbCloseArea() )
   end if
   if !Empty( dbfPro )
      ( dbfPro       )->( dbCloseArea() )
   end if
   if !Empty( dbfTblPro )
      ( dbfTblPro    )->( dbCloseArea() )
   end if
   if !Empty( dbfRuta )
      ( dbfRuta      )->( dbCloseArea() )
   end if
   if !Empty( dbfArtDiv )
      ( dbfArtDiv    )->( dbCloseArea() )
   end if
   if !Empty( dbfCajT )
      ( dbfCajT )->( dbCloseArea() )
   end if
   if !Empty( dbfUsr )
      ( dbfUsr )->( dbCloseArea() )
   end if
   if dbfInci != nil
      ( dbfInci )->( dbCloseArea() )
   end if
   if dbfArtPrv != nil
      ( dbfArtPrv )->( dbCloseArea() )
   end if
   if dbfAntCliT != nil
      ( dbfAntCliT )->( dbCloseArea() )
   end if
   if dbfDelega != nil
      ( dbfDelega )->( dbCloseArea() )
   end if
   if dbfCount != nil
      ( dbfCount )->( dbCloseArea() )
   end if
   if dbfUbicaL != nil
      ( dbfUbicaL )->( dbCloseArea() )
   end if
   if dbfAgeCom != nil
      ( dbfAgeCom )->( dbCloseArea() )
   end if
   if dbfFacCliT != nil
      ( dbfFacCliT )->( dbCloseArea() )
   end if
   if dbfFacCliL != nil
      ( dbfFacCliL )->( dbCloseArea() )
   end if
   if dbfFacCliS != nil
      ( dbfFacCliS )->( dbCloseArea() )
   end if
   if dbfFacCliP != nil
      ( dbfFacCliP )->( dbCloseArea() )
   end if
   if dbfFacRecT != nil
      ( dbfFacRecT )->( dbCloseArea() )
   end if
   if dbfFacRecL != nil
      ( dbfFacRecL )->( dbCloseArea() )
   end if
   if dbfFacRecS != nil
      ( dbfFacRecS )->( dbCloseArea() )
   end if
   if dbfTikT != nil
      ( dbfTikT )->( dbCloseArea() )
   end if
   if dbfTikL != nil
      ( dbfTikL )->( dbCloseArea() )
   end if
   if dbfTikS != nil
      ( dbfTikS )->( dbCloseArea() )
   end if
   if dbfEmp != nil
      ( dbfEmp )->( dbCloseArea() )
   end if
   if dbfProLin != nil
      ( dbfProLin )->( dbCloseArea() )
   end if
   if dbfProMat != nil
      ( dbfProMat )->( dbCloseArea() )
   end if
   if dbfProSer != nil
      ( dbfProSer )->( dbCloseArea() )
   end if
   if dbfMatSer != nil
      ( dbfMatSer )->( dbCloseArea() )
   end if
   if dbfHisMov != nil
      ( dbfHisMov )->( dbCloseArea() )
   end if
   if dbfHisMovS != nil
      ( dbfHisMovS )->( dbCloseArea() )
   end if
   if dbfAlbPrvL != nil
      ( dbfAlbPrvL )->( dbCloseArea() )
   end if
   if dbfAlbPrvS != nil
      ( dbfAlbPrvS )->( dbCloseArea() )
   end if
   if dbfFacPrvL != nil
      ( dbfFacPrvL )->( dbCloseArea() )
   end if
   if dbfFacPrvS != nil
      ( dbfFacPrvS )->( dbCloseArea() )
   end if
   if dbfRctPrvL != nil
      ( dbfRctPrvL )->( dbCloseArea() )
   end if
   if dbfRctPrvS != nil
      ( dbfRctPrvS )->( dbCloseArea() )
   end if
   if dbfCliInc != nil
      ( dbfCliInc )->( dbCloseArea() )
   end if
   if dbfPedPrvL != nil
      ( dbfPedPrvL )->( dbCloseArea() )
   end if
   if !Empty( dbfCliBnc  )
      ( dbfCliBnc  )->( dbCloseArea() )
   end if

   if !Empty( oStock )
      oStock:end()
   end if
   if !Empty( oGrpCli )
      oGrpCli:end()
   end if
   if !Empty( oNewImp )
      oNewImp:end()
   end if
   if !Empty( oTrans )
      oTrans:end()
   end if
   if !Empty( oTipArt )
      oTipArt:end()
   end if
   if !Empty( oGrpFam )
      oGrpFam:end()
   end if
   if !Empty( oUndMedicion )
      oUndMedicion:end()
   end if
   if !Empty( oFraPub )
      oFraPub:end()
   end if

   dbfClient      := nil
   dbfIva         := nil
   dbfAlbCliL     := nil
   dbfAlbCliT     := nil
   dbfAlbCliI     := nil
   dbfAlbCliD     := nil
   dbfAlbCliP     := nil
   dbfAlbCliS     := nil
   dbfPedCliT     := nil
   dbfPedCliL     := nil
   dbfPedCliR     := nil
   dbfPedCliP     := nil
   dbfPedCliI     := nil
   dbfPedCliD     := nil
   dbfTikT        := nil
   dbfFPago       := nil
   dbfAgent       := nil
   dbfAlm         := nil
   dbfTarPreL     := nil
   dbfTarPreS     := nil
   dbfPromoT      := nil
   dbfPromoL      := nil
   dbfPromoC      := nil
   dbfArticulo    := nil
   dbfCodebar     := nil
   dbfFamilia     := nil
   dbfKit         := nil
   dbfCliAtp      := nil
   dbfTVta        := nil
   dbfDiv         := nil
   oBandera       := nil
   dbfDoc         := nil
   dbfTblCnv      := nil
   dbfOferta      := nil
   dbfObrasT      := nil
   dbfPro         := nil
   dbfFlt         := nil
   dbfTblPro      := nil
   dbfRuta        := nil
   dbfArtDiv      := nil
   dbfCajT        := nil
   dbfUsr         := nil
   dbfInci        := nil
   dbfArtPrv      := nil
   dbfAntCliT     := nil
   dbfDelega      := nil
   dbfCount       := nil
   dbfUbicaL      := nil
   dbfAgeCom      := nil
   dbfFacCliT     := nil
   dbfFacCliL     := nil
   dbfFacCliS     := nil
   dbfFacRecT     := nil
   dbfFacRecL     := nil
   dbfTikT        := nil
   dbfTikL        := nil
   dbfTikS        := nil
   dbfEmp         := nil
   dbfProLin      := nil
   dbfProMat      := nil
   dbfHisMov      := nil
   dbfHisMovS     := nil
   dbfAlbPrvL     := nil
   dbfCliInc      := nil
   dbfPedPrvL     := nil
   dbfCliBnc      := nil

   oStock         := nil
   oGrpCli        := nil
   oNewImp        := nil
   oTrans         := nil
   oTipArt        := nil
   oGrpFam        := nil
   oUndMedicion   := nil
   oFraPub        := nil

   lOpenFiles     := .f.

   oWndBrw        := nil

   EnableAcceso()

Return .t.

//--------------------------------------------------------------------------//

STATIC FUNCTION GenAlbCli( nDevice, cCaption, cCodDoc, cPrinter, nCopies )

   local oDevice
   local cAlbaran

   if ( dbfAlbCliT )->( Lastrec() ) == 0
      Return nil
   end if

   cAlbaran             := ( dbfAlbCliT )->cSerAlb + Str( ( dbfAlbCliT )->nNumAlb ) + ( dbfAlbCliT )->cSufAlb

   DEFAULT nDevice      := IS_PRINTER
   DEFAULT cCaption     := "Imprimiendo albaranes a clientes"
   DEFAULT cCodDoc      := cFormatoDocumento( ( dbfAlbCliT )->cSerAlb, "nAlbCli", dbfCount )
   DEFAULT nCopies      := if( nCopiasDocumento( ( dbfAlbCliT )->cSerAlb, "nAlbCli", dbfCount ) == 0, Max( Retfld( ( dbfAlbCliT )->cCodCli, dbfClient, "CopiasF" ), 1 ), nCopiasDocumento( ( dbfAlbCliT )->cSerAlb, "nAlbCli", dbfCount ) )

   if Empty( cCodDoc )
      cCodDoc           := cFirstDoc( "AC", dbfDoc )
   end if

   if !lExisteDocumento( cCodDoc, dbfDoc )
      return nil
   end if

   /*
   Si el documento es de tipo visual-------------------------------------------
   */

   if lVisualDocumento( cCodDoc, dbfDoc )

      PrintReportAlbCli( nDevice, nCopies, cPrinter, dbfDoc )

   else

      /*
      Recalculamos el albaran
      */

      nTotAlbCli( cAlbaran, dbfAlbCliT, dbfAlbCliL, dbfIva, dbfDiv )
      nPagAlbCli( cAlbaran, dbfAlbCliP, dbfDiv )

      /*
      Buscamos el primer registro
      */

      ( dbfAlbCliL )->( dbSeek( cAlbaran ) )
      ( dbfAlbCliP )->( dbSeek( cAlbaran ) )

      /*
      Posicionamos en ficheros auxiliares
      */

      ( dbfClient)->( dbSeek( ( dbfAlbCliT )->cCodCli ) )
      ( dbfAgent )->( dbSeek( ( dbfAlbCliT )->cCodAge ) )
      ( dbfFPago )->( dbSeek( ( dbfAlbCliT )->cCodPago) )
      ( dbfObrasT)->( dbSeek( ( dbfAlbCliT )->cCodCli + ( dbfAlbCliT )->cCodObr ) )
      ( dbfDelega)->( dbSeek( ( dbfAlbCliT )->cCodDlg ) )

      oTrans:oDbf:Seek( ( dbfAlbCliT )->cCodTrn )

      private oInf
      private cDbf         := dbfAlbCliT
      private cDbfCol      := dbfAlbCliL
      private cDbfPag      := dbfAlbCliP
      private cCliente     := dbfClient
      private cDbfCli      := dbfClient
      private cDbfDiv      := dbfDiv
      private cIva         := dbfIva
      private cDbfIva      := dbfIva
      private cFPago       := dbfFPago
      private cDbfPgo      := dbfFPago
      private cAgent       := dbfAgent
      private cDbfAge      := dbfAgent
      private cTvta        := dbfTvta
      private cObras       := dbfObrasT
      private cDbfObr      := dbfObrasT
      private cTarPreL     := dbfTarPreL
      private cTarPreS     := dbfTarPreS
      private cDbfRut      := dbfRuta
      private cDbfUsr      := dbfUsr
      private cDbfAnt      := dbfAntCliT
      private cDbfDlg      := dbfDelega
      private cDbfTrn      := oTrans:GetAlias()
      private cDbfPro      := dbfPro
      private cDbfTblPro   := dbfTblPro

      private nTotPage     := nTotLAlbCli( dbfAlbCliL )
      private nVdvDivAlb   := nVdvDiv
      private cPicUndAlb   := cPicUnd
      private cPouDivAlb   := cPouDiv
      private cPorDivAlb   := cPorDiv
      private cPpvDivAlb   := cPpvDiv
      private cPouEurAlb   := cPouEur
      private nDouDivAlb   := nDouDiv
      private nRouDivAlb   := nRouDiv

      private nTotCaj      := nNumCaj

      private oStk         := oStock

      /*
      Creamos el informe con la impresora seleccionada para ese informe-----------
      */

      if !Empty( cPrinter ) // .and. lPrinter
         oDevice           := TPrinter():New( cCaption, .f., .t., cPrinter )
         REPORT oInf CAPTION cCaption TO DEVICE oDevice
      else
         REPORT oInf CAPTION cCaption PREVIEW
      end if

      if !Empty( oInf ) .and. oInf:lCreated

         oInf:lAutoland    := .f.
         oInf:lFinish      := .f.
         oInf:lNoCancel    := .t.
         oInf:bSkip        := {|| AlbCliReportSkipper( dbfAlbCliL ) }

         oInf:oDevice:lPrvModal  := .t.

         do case
            case nDevice == IS_PRINTER

               oInf:oDevice:SetCopies( nCopies )

               oInf:bPreview  := {| oDevice | PrintPreview( oDevice ) }

            case nDevice == IS_PDF

               oInf:bPreview  := {| oDevice | PrintPdf( oDevice ) }

         end case

         SetMargin( cCodDoc, oInf )
         PrintColum( cCodDoc, oInf )

      else

         MsgStop( "No se ha podido crear el documento " + cCodDoc )

      end if

      END REPORT

      if !Empty( oInf )

         private oReport   := oInf

         ACTIVATE REPORT oInf ;
            WHILE       ( ( dbfAlbCliL )->cSerAlb + Str( ( dbfAlbCliL )->nNumAlb ) + ( dbfAlbCliL )->cSufAlb == cAlbaran .and. !( dbfAlbCliL )->( Eof() ) ) ;
            FOR         ( !( dbfAlbCliL )->lImpLin ) ;
            ON ENDPAGE  ( ePage( oInf, cCodDoc ) )

            if nDevice == IS_PRINTER
               oInf:oDevice:end()
            end if

      end if

      oInf                 := nil

   end if

   /*
   Funcion para marcar el documento como imprimido-----------------------------
   */

   lChgImpDoc( dbfAlbCliT )

Return nil

//----------------------------------------------------------------------------//

Static Function AlbCliReportSkipper( dbfAlbCliL )

   ( dbfAlbCliL )->( dbSkip() )

   nTotPage              += nTotLAlbCli( dbfAlbCliL )

Return nil

//----------------------------------------------------------------------------//

STATIC FUNCTION EPage( oInf, cCodDoc )

	private nPagina		:= oInf:nPage
	private lEnd			:= oInf:lFinish
   private nRow         := oInf:nRow

   PrintItems( cCodDoc, oInf )

RETURN NIL

//--------------------------------------------------------------------------//

FUNCTION AlbCli( oMenuItem, oWnd, cCodCli, cCodArt, aNumDoc )

   local oRpl
   local oSnd
   local oPrv
   local oImp
   local oDel
   local oPdf
   local oMail
   local oDup
   local oBtnEur
   local nLevel
   local oRotor
   local lEuro          := .f.

   DEFAULT  oMenuItem   := _MENUITEM_
   DEFAULT  oWnd        := oWnd()
   DEFAULT  cCodCli     := ""
   DEFAULT  cCodArt     := ""
   DEFAULT  aNumDoc     := Array( 2 )

   nLevel               := nLevelUsr( oMenuItem )
   if nAnd( nLevel, 1 ) != 0
      msgStop( "Acceso no permitido." )
      return .f.
   end if

   if IsChar( aNumDoc )
      aNumDoc           := { aNumDoc, nil }
   end if 

   /*
   Cerramos todas las ventanas
   */

   if oWnd != nil
      oWnd:CloseAll()
   end if

   if !OpenFiles()
      return .f.
   end if

   DisableAcceso()

   DEFINE SHELL oWndBrw FROM 0, 0 TO 22, 80 ;
      XBROWSE ;
      TITLE    "Albaranes de clientes" ;
      PROMPT   "Número",;
               "Fecha",;
               "Código",;
               "Nombre",;
               "Obra",;
               "Agente",;
               "Su albarán",;
               "Facturado";
      MRU      "Document_plain_user1_16";
      BITMAP   clrTopArchivos ;
      ALIAS    ( dbfAlbCliT );
      APPEND   ( WinAppRec( oWndBrw:oBrw, bEdtRec, dbfAlbCliT, cCodCli, cCodArt, aNumDoc ) );
      DUPLICAT ( WinDupRec( oWndBrw:oBrw, bEdtRec, dbfAlbCliT, cCodCli, cCodArt, aNumDoc ) );
      EDIT     ( WinEdtRec( oWndBrw:oBrw, bEdtRec, dbfAlbCliT, cCodCli, cCodArt, aNumDoc ) );
      ZOOM     ( WinZooRec( oWndBrw:oBrw, bEdtRec, dbfAlbCliT ) );
      DELETE   ( WinDelRec( oWndBrw:oBrw, dbfAlbCliT, {|| QuiAlbCli() } ) ) ;
      LEVEL    nLevel ;
      OF       oWnd

      oWndBrw:lFechado     := .t.

	  oWndBrw:SetYearComboBoxChange( {|| YearComboBoxChange() } )

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Sesión cerrada"
         :nHeadBmpNo       := 3
         :bStrData         := {|| "" }
         :bEditValue       := {|| ( dbfAlbCliT )->lCloAlb }
         :nWidth           := 20
         :SetCheck( { "Sel16", "Nil16" } )
         :AddResource( "Zoom16" )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Facturado"
         :nHeadBmpNo       := 3
         :cSortOrder       := "lFacturado"
         :bStrData         := {|| "" }
         :bEditValue       := {|| ( dbfAlbCliT )->lFacturado }
         :nWidth           := 20
         :SetCheck( { "Bullet_Square_Green_16", "Bullet_Square_Red_16" } )
         :AddResource( "trafficlight_on_16" )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Envio"
         :nHeadBmpNo       := 3
         :bStrData         := {|| "" }
         :bEditValue       := {|| ( dbfAlbCliT )->lSndDoc }
         :nWidth           := 20
         :SetCheck( { "Sel16", "Nil16" } )
         :AddResource( "Lbl16" )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Entregado"
         :nHeadBmpNo       := 3
         :bStrData         := {|| "" }
         :bEditValue       := {|| ( dbfAlbCliT )->lEntregado }
         :nWidth           := 20
         :SetCheck( { "Sel16", "Nil16" } )
         :AddResource( "hand_paper_16" )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Incidencia"
         :nHeadBmpNo       := 4
         :bStrData         := {|| "" }
         :bBmpData         := {|| nEstadoIncidencia( ( dbfAlbCliT )->cSerAlb + Str( ( dbfAlbCliT )->nNumAlb ) + ( dbfAlbCliT )->cSufAlb ) }
         :nWidth           := 20
         :lHide            := .t.
         :AddResource( "Bullet_Square_Red_16" )
         :AddResource( "Bullet_Square_Yellow_16" )
         :AddResource( "Bullet_Square_Green_16" )
         :AddResource( "informacion_16" )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Impreso"
         :nHeadBmpNo       := 3
         :bStrData         := {|| "" }
         :bEditValue       := {|| ( dbfAlbCliT )->lImprimido }
         :nWidth           := 20
         :lHide            := .t.
         :SetCheck( { "Sel16", "Nil16" } )
         :AddResource( "IMP16" )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Tipo"
         :bEditValue       := {|| aTipAlb[ if( ( dbfAlbCliT )->lAlquiler, 2, 1 ) ] }
         :nWidth           := 50
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Número"
         :cSortOrder       := "nNumAlb"
         :bEditValue       := {|| ( dbfAlbCliT )->cSerAlb + "/" + Alltrim( Str( ( dbfAlbCliT )->nNumAlb ) ) }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Delegación"
         :bEditValue       := {|| ( dbfAlbCliT )->cSufAlb }
         :nWidth           := 40
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Sesión"
         :bEditValue       := {|| Trans( ( dbfAlbCliT )->cTurAlb, "######" ) }
         :nWidth           := 40
         :lHide            := .t.
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Fecha"
         :cSortOrder       := "dFecAlb"
         :bEditValue       := {|| Dtoc( ( dbfAlbCliT )->dFecAlb ) }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Caja"
         :bEditValue       := {|| ( dbfAlbCliT )->cCodCaj }
         :nWidth           := 40
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Usuario"
         :bEditValue       := {|| ( dbfAlbCliT )->cCodUsr }
         :nWidth           := 40
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Código"
         :cSortOrder       := "cCodCli"
         :bEditValue       := {|| AllTrim( ( dbfAlbCliT )->cCodCli ) }
         :nWidth           := 70
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Nombre"
         :cSortOrder       := "cNomCli"
         :bEditValue       := {|| ( dbfAlbCliT )->cNomCli }
         :nWidth           := 180
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Su albarán"
         :cSortOrder       := "cCodSuAlb"
         :bEditValue       := {|| ( dbfAlbCliT )->cCodSuAlb }
         :nWidth           := 40
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Agente"
         :cSortOrder       := "cCodAge"
         :bEditValue       := {|| ( dbfAlbCliT )->cCodAge }
         :nWidth           := 50
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Ruta"
         :bEditValue       := {|| ( dbfAlbCliT )->cCodRut }
         :nWidth           := 40
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Almacén"
         :bEditValue       := {|| ( dbfAlbCliT )->cCodAlm }
         :nWidth           := 60
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Obra"
         :cSortOrder       := "cObra"
         :bEditValue       := {|| ( dbfAlbCliT )->cCodObr }
         :nWidth           := 40
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Su pedido"
         :cSortOrder       := "cSuPed"
         :bEditValue       := {|| ( dbfAlbCliT )->cSuPed }
         :nWidth           := 60
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
         :lHide            := .t.
      end with


      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Base"
         :bEditValue       := {|| ( dbfAlbCliT )->nTotNet }
         :cEditPicture     := cPorDiv( ( dbfAlbCliT )->cDivAlb, dbfDiv )
         :nWidth           := 80
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := cImp()
         :bEditValue       := {|| ( dbfAlbCliT )->nTotIva }
         :cEditPicture     := cPorDiv( ( dbfAlbCliT )->cDivAlb, dbfDiv )
         :nWidth           := 80
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "R.E."
         :bEditValue       := {|| ( dbfAlbCliT )->nTotReq }
         :cEditPicture     := cPorDiv( ( dbfAlbCliT )->cDivAlb, dbfDiv )
         :nWidth           := 80
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Total"
         :bEditValue       := {|| ( dbfAlbCliT )->nTotAlb }
         :cEditPicture     := cPorDiv( ( dbfAlbCliT )->cDivAlb, dbfDiv )
         :nWidth           := 80
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Div."
         :bEditValue       := {|| cSimDiv( if( lEuro, cDivChg(), ( dbfAlbCliT )->cDivAlb ), dbfDiv ) }
         :nWidth           := 30
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with


      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Entregado"
         :bEditValue       := {|| ( dbfAlbCliT )->nTotPag }
         :cEditPicture     := cPorDiv( ( dbfAlbCliT )->cDivAlb, dbfDiv )
         :nWidth           := 80
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Total und."
         :bEditValue       := {|| nTotalUnd( ( dbfAlbCliT )->cSerAlb + Str( ( dbfAlbCliT )->nNumAlb ) + ( dbfAlbCliT )->cSufAlb, dbfAlbCliL, MasUnd() ) }
         :nWidth           := 95
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
         :lHide            := .t.
      end with

      oWndBrw:CreateXFromCode()

   DEFINE BTNSHELL RESOURCE "BUS" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( oWndBrw:SearchSetFocus() ) ;
      TOOLTIP  "(B)uscar";
      HOTKEY   "B"

   oWndBrw:AddSeaBar()

   DEFINE BTNSHELL RESOURCE "NEW" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( oWndBrw:RecAdd() );
      ON DROP  ( oWndBrw:RecDup() );
      TOOLTIP  "(A)ñadir";
      HOTKEY   "A";
      BEGIN GROUP ;
      LEVEL    ACC_APPD

   DEFINE BTNSHELL oDup RESOURCE "DUP" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( oWndBrw:RecDup() );
      MENU     This:Toggle() ;
      TOOLTIP  "(D)uplicar";
      HOTKEY   "D";
      LEVEL    ACC_APPD

#ifdef __HARBOUR__

      DEFINE BTNSHELL RESOURCE "Dup" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( DupSerie( oWndBrw ) );
         TOOLTIP  "Series" ;
         FROM     oDup ;
         CLOSED ;
         LEVEL    ACC_APPD

#endif

   DEFINE BTNSHELL RESOURCE "EDIT" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( oWndBrw:RecEdit() );
      TOOLTIP  "(M)odificar";
      HOTKEY   "M" ;
      MRU;
      LEVEL    ACC_EDIT

   DEFINE BTNSHELL RESOURCE "ZOOM" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( oWndBrw:RecZoom() );
      TOOLTIP  "(Z)oom";
      HOTKEY   "Z" ;
      MRU;
      LEVEL    ACC_ZOOM

   DEFINE BTNSHELL oDel RESOURCE "DEL" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( WinDelRec( oWndBrw:oBrw, dbfAlbCliT, {|| QuiAlbCli() } ) );
      TOOLTIP  "(E)liminar";
      HOTKEY   "E";
      LEVEL    ACC_DELE

      /*DEFINE BTNSHELL RESOURCE "DEL" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( AlbRecDel( .t., .f. ) );
         TOOLTIP  "Solo cabecera" ;
         FROM     oDel ;
         CLOSED ;
         LEVEL    ACC_DELE

      DEFINE BTNSHELL RESOURCE "DEL" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( AlbRecDel( .f., .t. ) );
         TOOLTIP  "Solo detalle" ;
         FROM     oDel ;
         CLOSED ;
         LEVEL    ACC_DELE*/

      DEFINE BTNSHELL RESOURCE "DEL" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( DelSerie( oWndBrw ) );
         TOOLTIP  "Series" ;
         FROM     oDel ;
         CLOSED ;
         LEVEL    ACC_DELE

   DEFINE BTNSHELL oImp RESOURCE "IMP" GROUP OF oWndBrw ;
      NOBORDER ;
      MENU     This:Toggle() ;
      ACTION   ( GenAlbCli( IS_PRINTER ), oWndBrw:Refresh() ) ;
      TOOLTIP  "(I)mprimir";
      HOTKEY   "I";
      LEVEL    ACC_IMPR

      lGenAlbCli( oWndBrw:oBrw, oImp, IS_PRINTER ) ;

   DEFINE BTNSHELL RESOURCE "SERIE1" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( PrnSerie(), oWndBrw:Refresh() ) ;
      TOOLTIP  "Imp(r)imir series";
      HOTKEY   "R";
      LEVEL    ACC_IMPR

   DEFINE BTNSHELL oPrv RESOURCE "Prev1" OF oWndBrw ;
      NOBORDER ;
      MENU     This:Toggle() ;
      ACTION   ( GenAlbCli( IS_SCREEN ), oWndBrw:Refresh() ) ;
      TOOLTIP  "(P)revisualizar";
      HOTKEY   "P";
      LEVEL    ACC_IMPR

      lGenAlbCli( oWndBrw:oBrw, oPrv, IS_SCREEN ) ;

   DEFINE BTNSHELL oPdf RESOURCE "DOCLOCK" OF oWndBrw ;
      NOBORDER ;
      MENU     This:Toggle() ;
      ACTION   ( GenAlbCli( IS_PDF ) ) ;
      TOOLTIP  "Pd(f)";
      HOTKEY   "F";
      LEVEL    ACC_IMPR

      lGenAlbCli( oWndBrw:oBrw, oPdf, IS_PDF ) ;

   DEFINE BTNSHELL oMail RESOURCE "Mail" OF oWndBrw ;
      NOBORDER ;
      MENU     This:Toggle() ;
      ACTION   ( GenAlbCli( IS_MAIL ) ) ;
      TOOLTIP  "Correo electrónico";
      LEVEL    ACC_IMPR

      lGenAlbCli( oWndBrw:oBrw, oMail, IS_MAIL ) ;

   DEFINE BTNSHELL RESOURCE "Money2_" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( If( !( dbfAlbCliT )->lFacturado, WinAppRec( oWndBrw:oBrw, bEdtPgo, dbfAlbCliP ), MsgStop( "El albarán ya fue facturado." ) ) );
      TOOLTIP  "Entregas a (c)uenta" ;
      HOTKEY   "C";
      LEVEL    ACC_APPD

   if oUser():lAdministrador()

      DEFINE BTNSHELL RESOURCE "GENFAC" GROUP OF oWndBrw ;
         NOBORDER ;
         ACTION   ( GenFCli( oWndBrw:oBrw, dbfAlbCliT, dbfAlbCliL, dbfAlbCliP, dbfAlbCliS, dbfClient, dbfCliAtp, dbfIva, dbfDiv, dbfFPago, dbfUsr, dbfCount, oGrpCli, oStock ) );
         TOOLTIP  "(G)enerar facturas";
         HOTKEY   "G";
         LEVEL    ACC_APPD

      DEFINE BTNSHELL RESOURCE "CHGSTATE" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( if( ApoloMsgNoYes(  "¿ Está seguro de cambiar el estado del documento ?", "Elija una opción" ), SetFacturadoAlbaranCliente( !( dbfAlbCliT )->lFacturado, oWndBrw:oBrw ), ) ) ;
         TOOLTIP  "Cambiar Es(t)ado" ;
         HOTKEY   "T";
         LEVEL    ACC_EDIT

   end if

   DEFINE BTNSHELL RESOURCE "Sel" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( SelSend( oWndBrw:oBrw ) ) ;
      TOOLTIP  "Entregad(o)" ;
      HOTKEY   "O";
      LEVEL    ACC_APPD

   DEFINE BTNSHELL oSnd RESOURCE "LBL" GROUP OF oWndBrw ;
      NOBORDER ;
      MENU     This:Toggle() ;
      TOOLTIP  "En(v)iar" ;
      MESSAGE  "Seleccionar albaranes para ser enviados" ;
      ACTION   lSnd( oWndBrw, dbfAlbCliT ) ;
      HOTKEY   "V";
      LEVEL    ACC_EDIT

      DEFINE BTNSHELL RESOURCE "LBL" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( lSelectAll( oWndBrw, dbfAlbCliT, "lSndDoc", .t., .t., .t. ) );
         TOOLTIP  "Todos" ;
         FROM     oSnd ;
         CLOSED ;
         LEVEL    ACC_EDIT

      DEFINE BTNSHELL RESOURCE "LBL" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( lSelectAll( oWndBrw, dbfAlbCliT, "lSndDoc", .f., .t., .t. ) );
         TOOLTIP  "Ninguno" ;
         FROM     oSnd ;
         CLOSED ;
         LEVEL    ACC_EDIT

      DEFINE BTNSHELL RESOURCE "LBL" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( lSelectAll( oWndBrw, dbfAlbCliT, "lSndDoc", .t., .f., .t. ) );
         TOOLTIP  "Abajo" ;
         FROM     oSnd ;
         CLOSED ;
         LEVEL    ACC_EDIT

   DEFINE BTNSHELL oBtnEur RESOURCE "BAL_EURO" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( lEuro := !lEuro, oWndBrw:Refresh() ) ;
      TOOLTIP  "M(o)neda";
      HOTKEY   "O"

   if oUser():lAdministrador()

      DEFINE BTNSHELL oRpl RESOURCE "BMPCHG" GROUP OF oWndBrw ;
         NOBORDER ;
         MENU     This:Toggle() ;
         ACTION   ( TDlgFlt():New( aItmAlbCli(), dbfAlbCliT ):ChgFields(), oWndBrw:Refresh() ) ;
         TOOLTIP  "Cambiar campos" ;
         LEVEL    ACC_EDIT

         DEFINE BTNSHELL RESOURCE "BMPCHG" OF oWndBrw ;
            ACTION   ( TDlgFlt():New( aColAlbCli(), dbfAlbCliL ):ChgFields(), oWndBrw:Refresh() ) ;
            TOOLTIP  "Líneas" ;
            FROM     oRpl ;
            CLOSED ;
            LEVEL    ACC_EDIT

    end if

   DEFINE BTNSHELL RESOURCE "INFO" GROUP OF oWndBrw ;
      ACTION   ( TTrazaDocumento():Activate( ALB_CLI, ( dbfAlbCliT )->cSerAlb + Str( ( dbfAlbCliT )->nNumAlb ) + ( dbfAlbCliT )->cSufAlb ) ) ;
      TOOLTIP  "I(n)forme documento" ;
      HOTKEY   "N" ;
      LEVEL    ACC_EDIT

   DEFINE BTNSHELL oRotor RESOURCE "ROTOR" GROUP OF oWndBrw ;
      NOBORDER ;
      ACTION   ( oRotor:Expand() ) ;
      TOOLTIP  "Rotor" ;

      DEFINE BTNSHELL RESOURCE "USER1_" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( EdtCli( ( dbfAlbCliT )->cCodCli ) );
         TOOLTIP  "Modificar cliente" ;
         FROM     oRotor ;

      DEFINE BTNSHELL RESOURCE "INFO" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( InfCliente( ( dbfAlbCliT )->cCodCli ) );
         TOOLTIP  "Informe de cliente" ;
         FROM     oRotor ;

      DEFINE BTNSHELL RESOURCE "WORKER" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( EdtObras( ( dbfAlbCliT )->cCodCli, ( dbfAlbCliT )->cCodObr, dbfObrasT ) );
         TOOLTIP  "Modificar obra" ;
         FROM     oRotor ;

      DEFINE BTNSHELL RESOURCE "CLIPBOARD_EMPTY_USER1_" OF oWndBrw ;
         ACTION   ( if( !Empty( ( dbfAlbCliT )->cNumPed ), ZooPedCli( ( dbfAlbCliT )->cNumPed ), MsgStop( "El albarán no procede de un pedido" ) ) );
         TOOLTIP  "Visualizar pedido" ;
         FROM     oRotor ;

      DEFINE BTNSHELL RESOURCE "DOCUMENT_USER1_" OF oWndBrw ;
         ALLOW    EXIT ;
         ACTION   ( if( !( dbfAlbCliT )->lFacturado, FactCli( nil, nil, nil, nil, nil, { nil, nil, ( dbfAlbCliT )->cSerAlb + Str( ( dbfAlbCliT )->nNumAlb ) + ( dbfAlbCliT )->cSufAlb, nil } ), MsgStop( "Albarán facturado" ) ) );
         TOOLTIP  "Generar factura" ;
         FROM     oRotor ;

      DEFINE BTNSHELL RESOURCE "DOCUMENT_USER1_" OF oWndBrw ;
         ACTION   ( if( !Empty( ( dbfAlbCliT )->cNumFac ), EdtFacCli( ( dbfAlbCliT )->cNumFac ), msgStop( "No hay factura asociada" ) ) );
         TOOLTIP  "Modificar factura" ;
         FROM     oRotor ;

      DEFINE BTNSHELL RESOURCE "DOCUMENT_MONEY2_" OF oWndBrw ;
         ALLOW    EXIT ;
         ACTION   ( FacAntCli( nil, nil, ( dbfAlbCliT )->cCodCli ) );
         TOOLTIP  "Generar anticipo" ;
         FROM     oRotor ;

      DEFINE BTNSHELL RESOURCE "Note_" OF oWndBrw ;
         ALLOW    EXIT ;
         ACTION   ( AlbCliNotas() );
         TOOLTIP  "Generar nota de agenda" ;
         FROM     oRotor ;

      DEFINE BTNSHELL RESOURCE "CASHIER_USER1_" OF oWndBrw ;
         ALLOW    EXIT ;
         ACTION   ( if( !( dbfAlbCliT )->lFacturado .and. Empty( ( dbfAlbCliT )->cNumTik ), FrontTpv( nil, nil, nil, nil, .f., .f., { nil, nil, ( dbfAlbCliT )->cSerAlb + Str( ( dbfAlbCliT )->nNumAlb ) + ( dbfAlbCliT )->cSufAlb } ), MsgStop( "Albarán facturado o convertido a ticket" ) ) );
         TOOLTIP  "Convertir a ticket" ;
         FROM     oRotor ;

   DEFINE BTNSHELL RESOURCE "END" GROUP OF oWndBrw;
      NOBORDER ;
      ACTION   ( oWndBrw:End() ) ;
      TOOLTIP  "(S)alir" ;
      HOTKEY   "S"

      /*
      Datos para el filtro-----------------------------------------------------
      */

   if !oUser():lFiltroVentas()
      oWndBrw:oActiveFilter:aTField       := aItmAlbCli()
      oWndBrw:oActiveFilter:cDbfFilter    := dbfFlt
      oWndBrw:oActiveFilter:cTipFilter    := ALB_CLI
   end if

   ACTIVATE WINDOW oWndBrw VALID ( CloseFiles() )

   EnableAcceso()

   if !Empty( cCodCli ) .or. !Empty( cCodArt ) .or. !Empty( aNumDoc[ 1 ] ) .or. !Empty( aNumDoc[ 2 ] )

      if !Empty( oWndBrw )
         oWndBrw:RecAdd()
      end if

      cCodCli  := nil
      cCodArt  := nil
      aNumDoc  := Array( 2 )

   end if

Return .t.

//---------------------------------------------------------------------------//

STATIC FUNCTION EdtRec( aTmp, aGet, dbfAlbCliT, oBrw, cCodCli, cCodArt, nMode, aNumDoc )

	local oDlg
   local oBrwLin
   local oBrwInc
   local oBrwDoc
	local oFld
   local oBtnKit
   local nOrd
   local cEstAlb
   local oSay        := Array( 11 )
   local cSay        := Array( 11 )
   local oSayLabels  := Array( 10 )
   local oBmpDiv
   local oBmpEmp
   local oRieCli
   local nRieCli
   local oTlfCli
   local cTlfCli
   local oBrwPgo
   local lWhen       := if( oUser():lAdministrador(), nMode != ZOOM_MODE, if( nMode == EDIT_MODE, !aTmp[ _LCLOALB ], nMode != ZOOM_MODE ) )
   local oSayGetRnt
   local cTipAlb
   local oSayDias
   local oSayTxtDias
   local oBmpGeneral

   DEFAULT cCodCli   := ""
   DEFAULT cCodArt   := ""

   do case
      case IsNil( aNumDoc )
         aNumDoc     := Array( 5 )
      case IsArray( aNumDoc )
         ASize( aNumDoc, 5 )
   end if

   /*
   Este valor los guaradamos para detectar los posibles cambios----------------
   */

   cOldCodCli                 := aTmp[ _CCODCLI ]

   do case
      case nMode == APPD_MODE

         if !lCurSesion()
            MsgStop( "No hay sesiones activas, imposible añadir documentos" )
            Return .f.
         end if

         if !lCajaOpen( oUser():cCaja() ) .and. !oUser():lAdministrador()
            msgStop( "Esta caja " + oUser():cCaja() + " esta cerrada." )
            Return .f.
         end if

         aTmp[ _CTURALB   ]   := cCurSesion()
         aTmp[ _CCODALM   ]   := oUser():cAlmacen()
         aTmp[ _CDIVALB   ]   := cDivEmp()
         aTmp[ _CCODPAGO  ]   := cDefFpg()
         aTmp[ _CCODCAJ   ]   := oUser():cCaja()
         aTmp[ _CCODUSR   ]   := cCurUsr()
         aTmp[ _NVDVALB   ]   := nChgDiv( aTmp[ _CDIVALB ], dbfDiv )
         aTmp[ _LFACTURADO]   := .f.
         aTmp[ _LSNDDOC   ]   := .t.
         aTmp[ _CSUFALB   ]   := RetSufEmp()
         aTmp[ _CSERALB   ]   := cNewSer( "NALBCLI", dbfCount )
         aTmp[ _DFECENV   ]   := Ctod( "" )
         aTmp[ _DFECIMP   ]   := Ctod( "" )
         aTmp[ _CCODDLG   ]   := oUser():cDelegacion()
         aTmp[ _LIVAINC   ]   := uFieldEmpresa( "lIvaInc" )
         aTmp[ _NIVAMAN   ]   := nIva( dbfIva, cDefIva() )
         aTmp[ _CMANOBR   ]   := Padr( "Gastos", 250 )

      case nMode == DUPL_MODE

         if !lCurSesion()
            MsgStop( "No hay sesiones activas, imposible añadir documentos" )
            Return .f.
         end if

         if !lCajaOpen( oUser():cCaja() ) .and. !oUser():lAdministrador()
            msgStop( "Esta caja " + oUser():cCaja() + " esta cerrada." )
            Return .f.
         end if

         aTmp[ _DFECALB   ]   := GetSysDate()
         aTmp[ _CTURALB   ]   := cCurSesion()
         aTmp[ _CCODCAJ   ]   := oUser():cCaja()
         aTmp[ _LFACTURADO]   := .f.
         aTmp[ _LSNDDOC   ]   := .t.
         aTmp[ _CNUMPED   ]   := ""
         aTmp[ _LCLOALB   ]   := .f.

      case nMode == EDIT_MODE

         if aTmp[ _LCLOALB ] .and. !oUser():lAdministrador()
            MsgStop( "El albarán está cerrado." )
            Return .f.
         end if

         if aTmp[ _LFACTURADO ]
            MsgStop( "El albarán ya fue facturado." )
            return .t.
         end if

   end case

   if Empty( aTmp[ _CSERALB ] )
      aTmp[ _CSERALB ]        := cDefSer()
   end if

   if Empty( aTmp[ _NTARIFA ] )
      aTmp[ _NTARIFA ]        := Max( uFieldEmpresa( "nPreVta" ), 1 )
   end if

   if Empty( aTmp[ _CDTOESP ] )
      aTmp[ _CDTOESP ]        := Padr( "General", 50 )
   end if

   if Empty( aTmp[ _CDPP ] )
      aTmp[ _CDPP ]           := Padr( "Pronto pago", 50 )
   end if

   /*
   tipo de presupuesto---------------------------------------------------------
   */

   cTipAlb                    := aTipAlb[ if( aTmp[ _LALQUILER ], 2, 1  ) ]

   /*
   Comineza la transaccion-----------------------------------------------------
   */

   if BeginTrans( aTmp, nMode )
      Return .f.
   end if

   /*
   Mostramos datos de clientes-------------------------------------------------
   */

   nRieCli                    := oStock:nRiesgo( aTmp[ _CCODCLI ] )

   if Empty( aTmp[ _CTLFCLI ] )
      aTmp[ _CTLFCLI ]        := RetFld( aTmp[ _CCODCLI ], dbfClient, "Telefono" )
   end if

   nOrd                       := ( dbfAlbCliT )->( ordSetFocus( "nNumAlb" ) )

   oFont                      := TFont():New( "Arial", 8, 26, .f., .t. )

   cPicUnd                    := MasUnd()                            // Picture de las unidades
   cPouDiv                    := cPouDiv( aTmp[ _CDIVALB ], dbfDiv ) // Picture de la divisa
   cPorDiv                    := cPorDiv( aTmp[ _CDIVALB ], dbfDiv ) // Picture de la divisa redondeada
   cPpvDiv                    := cPpvDiv( aTmp[ _CDIVALB ], dbfDiv ) // Picture del punto verde
   nDouDiv                    := nDouDiv( aTmp[ _CDIVALB ], dbfDiv ) // Numero de decimales de la divisa
   nDorDiv                    := nRouDiv( aTmp[ _CDIVALB ], dbfDiv ) // Numero de decimales de la divisa
   nDpvDiv                    := nDpvDiv( aTmp[ _CDIVALB ], dbfDiv ) // Decimales de redondeo del punto verde

   if aTmp[ _LFACTURADO ]
      cEstAlb                 := "Facturado"
   else
      cEstAlb                 := "Pendiente"
   end if

   /*
   Etiquetas-------------------------------------------------------------------
   */

   cSay[ 2 ]                  := RetFld( aTmp[ _CCODALM ], dbfAlm )
   cSay[ 3 ]                  := RetFld( aTmp[ _CCODPAGO], dbfFPago )
   cSay[ 4 ]                  := RetFld( aTmp[ _CCODAGE ], dbfAgent )
   cSay[ 5 ]                  := RetFld( aTmp[ _CCODTAR ], dbfTarPreS )
   cSay[ 6 ]                  := RetFld( aTmp[ _CCODCLI ] + aTmp[ _CCODOBR ], dbfObrasT, "cNomObr" )
   cSay[ 7 ]                  := RetFld( aTmp[ _CCODRUT ], dbfRuta )
   cSay[ 8 ]                  := oTrans:cNombre( aTmp[ _CCODTRN ] )
   cSay[ 9 ]                  := RetFld( aTmp[ _CCODCAJ ], dbfCajT )
   cSay[ 10]                  := RetFld( aTmp[ _CCODUSR ], dbfUsr, "cNbrUse" )
   cSay[ 11]                  := RetFld( cCodEmp() + aTmp[ _CCODDLG ], dbfDelega, "cNomDlg" )

   /*
   Inicializamos el valor de la tarifa por si cambian--------------------------
   */

   InitTarifaCabecera( aTmp[ _NTARIFA ] )

   /*
   Comienza el dialogo---------------------------------------------------------
   */

   DEFINE DIALOG oDlg RESOURCE "PEDCLI" TITLE LblTitle( nMode ) + "albaranes a clientes"

      REDEFINE FOLDER oFld ID 200 OF oDlg ;
         PROMPT   "Albará&n", "Da&tos",   "&Incidencias", "D&ocumentos" ;
         DIALOGS  "ALBCLI_1", "ALBCLI_2", "PEDCLI_3",     "PEDCLI_4"

      /*
      Codigo de Cliente________________________________________________________
      */

      REDEFINE BITMAP oBmpGeneral ;
        ID       990 ;
        RESOURCE "albaran_cliente_48_alpha" ;
        TRANSPARENT ;
        OF       oFld:aDialogs[1]

      REDEFINE BITMAP oBmpGeneral ;
        ID       990 ;
        RESOURCE "folder2_red_alpha_48" ;
        TRANSPARENT ;
        OF       oFld:aDialogs[2]

      REDEFINE BITMAP oBmpGeneral ;
        ID       990 ;
        RESOURCE "information_48_alpha" ;
        TRANSPARENT ;
        OF       oFld:aDialogs[3]

      REDEFINE BITMAP oBmpGeneral ;
        ID       990 ;
        RESOURCE "address_book2_alpha_48" ;
        TRANSPARENT ;
        OF       oFld:aDialogs[4]

      REDEFINE GET aGet[ _CCODCLI ] VAR aTmp[ _CCODCLI ] ;
         ID       170 ;
			COLOR 	CLR_GET ;
         WHEN     ( lWhen ) ;
         VALID    ( LoaCli( aGet, aTmp, nMode, oRieCli ), RecalculaTotal( aTmp ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwClient( aGet[_CCODCLI], aGet[_CNOMCLI] ) );
			OF 		oFld:aDialogs[1]

      REDEFINE GET aGet[_CNOMCLI] VAR aTmp[_CNOMCLI] ;
         ID       171 ;
         WHEN     ( lWhen .and. ( !aTmp[ _LMODCLI ] .or. oUser():lAdministrador() ) ) ;
         COLOR    CLR_GET ;
			OF 		oFld:aDialogs[1]

      REDEFINE GET aGet[_CDNICLI] VAR aTmp[_CDNICLI] ;
         ID       101 ;
			COLOR 	CLR_GET ;
         WHEN     ( lWhen .and. ( !aTmp[ _LMODCLI ] .or. oUser():lAdministrador() ) ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CDIRCLI ] VAR aTmp[ _CDIRCLI ] ;
         ID       102 ;
         BITMAP   "Environnment_View_16" ;
         ON HELP  GoogleMaps( aTmp[ _CDIRCLI ], Rtrim( aTmp[ _CPOBCLI ] ) + Space( 1 ) + Rtrim( aTmp[ _CPRVCLI ] ) ) ;
         WHEN     ( lWhen .and. ( !aTmp[ _LMODCLI ] .or. oUser():lAdministrador() ) ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CPOBCLI ] VAR aTmp[ _CPOBCLI ] ;
         ID       103 ;
			COLOR 	CLR_GET ;
         WHEN     ( lWhen .and. ( !aTmp[ _LMODCLI ] .or. oUser():lAdministrador() ) ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CPRVCLI ] VAR aTmp[ _CPRVCLI ] ;
         ID       104 ;
			COLOR 	CLR_GET ;
         WHEN     ( lWhen .and. ( !aTmp[ _LMODCLI ] .or. oUser():lAdministrador() ) ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CPOSCLI ] VAR aTmp[ _CPOSCLI ] ;
         ID       107 ;
			COLOR 	CLR_GET ;
         WHEN     ( lWhen .and. ( !aTmp[ _LMODCLI ] .or. oUser():lAdministrador() ) ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _NTARIFA ] VAR aTmp[ _NTARIFA ];
         ID       172 ;
         SPINNER ;
         MIN      1 ;
         MAX      6 ;
         PICTURE  "9" ;
         VALID    ( ChangeTarifaCabecera( aTmp[ _NTARIFA ], dbfTmpLin, oBrwLin ) ) ;
         WHEN     ( nMode != ZOOM_MODE .and. ( lUsrMaster() .or. oUser():lCambiarPrecio() ) );
         OF       oFld:aDialogs[1]

      REDEFINE GET oRieCli VAR nRieCli;
         ID       173 ;
         WHEN     ( nMode != ZOOM_MODE );
         PICTURE  cPorDiv ;
			OF 		oFld:aDialogs[1]

      REDEFINE GET aGet[ _CTLFCLI ] VAR aTmp[ _CTLFCLI ] ;
         ID       106 ;
         WHEN     ( lWhen .and. ( !aTmp[ _LMODCLI ] .or. oUser():lAdministrador() ) ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CCODUSR ] VAR aTmp[ _CCODUSR ];
         ID       125 ;
         WHEN     ( .f. ) ;
         VALID    ( SetUsuario( aGet[ _CCODUSR ], oSay[ 10 ], nil, dbfUsr ) );
         OF       oFld:aDialogs[2]

      REDEFINE GET oSay[ 10 ] VAR cSay[ 10 ] ;
         ID       126 ;
         WHEN     ( .f. ) ;
         OF       oFld:aDialogs[2]

      /*
      Codigo de Tarifa_______________________________________________________________
      */

      REDEFINE GET aGet[ _CCODTAR ] VAR aTmp[ _CCODTAR ] ;
			ID 		180 ;
         WHEN     ( lWhen .and. oUser():lAdministrador() ) ;
         VALID    ( cTarifa( aGet[ _CCODTAR ], oSay[ 5 ] ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwTarifa( aGet[ _CCODTAR ], oSay[ 5 ] ) ) ;
			COLOR 	CLR_GET ;
			OF 		oFld:aDialogs[1]

      REDEFINE GET oSay[ 5 ] VAR cSay[ 5 ] ;
			WHEN 		.F. ;
			ID 		181 ;
			OF 		oFld:aDialogs[1]

      /*
      Codigo de Obra_________________________________________________________________
      */

      REDEFINE GET aGet[ _CCODOBR ] VAR aTmp[ _CCODOBR ] ;
			ID 		190 ;
         WHEN     ( lWhen ) ;
         VALID    ( cObras( aGet[ _CCODOBR ], oSay[ 6 ], aTmp[ _CCODCLI ], dbfObrasT ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwObras( aGet[ _CCODOBR ], oSay[ 6 ], aTmp[ _CCODCLI ], dbfObrasT ) ) ;
			OF 		oFld:aDialogs[1]

      REDEFINE GET oSay[ 6 ] VAR cSay[ 6 ] ;
			WHEN 		.F. ;
			ID 		191 ;
			OF 		oFld:aDialogs[1]

      /*
      Codigo de Almacen______________________________________________________________
      */

      REDEFINE GET aGet[ _CCODALM ] VAR aTmp[ _CCODALM ] ;
         ID       200 ;
         WHEN     ( lWhen ) ;
         VALID    ( cAlmacen( aGet[ _CCODALM ], , oSay[ 2 ] ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwAlmacen( aGet[ _CCODALM ], oSay[ 2 ] ) ) ;
			OF 		oFld:aDialogs[1]

      REDEFINE GET oSay[ 2 ] VAR cSay[ 2 ] ;
         ID       201 ;
         WHEN     ( lWhen ) ;
         BITMAP   "Bot" ;
         ON HELP  ( ExpAlmacen( aTmp[ _CCODALM ], dbfTmpLin, oBrwLin ) ) ;
			OF 		oFld:aDialogs[1]

      /*
      Formas de pago___________________________________________________________________
      */

      REDEFINE GET aGet[ _CCODPAGO ] VAR aTmp[ _CCODPAGO ] ;
         ID       210 ;
         WHEN     ( lWhen .and. oUser():lAdministrador() ) ;
			PICTURE  "@!" ;
         VALID    ( cFPago( aGet[ _CCODPAGO ], dbfFPago, oSay[ 3 ] ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwFPago( aGet[ _CCODPAGO ], oSay[ 3 ] ) ) ;
			OF 		oFld:aDialogs[1]

      REDEFINE GET oSay[ 3 ] VAR cSay[ 3 ] ;
         ID       211 ;
			WHEN 		.F. ;
			OF 		oFld:aDialogs[1]

      /*
      Banco del cliente--------------------------------------------------------
      */

      REDEFINE GET aGet[ _CBANCO ] VAR aTmp[ _CBANCO ];
         ID       410 ;
         WHEN     ( lWhen );
         BITMAP   "LUPA" ;
         ON HELP  ( BrwBncCli( aGet[ _CBANCO ], aGet[ _CENTBNC ], aGet[ _CSUCBNC ], aGet[ _CDIGBNC ], aGet[ _CCTABNC ], aTmp[ _CCODCLI ] ) );
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CENTBNC ] VAR aTmp[ _CENTBNC ];
         ID       420 ;
         WHEN     ( lWhen );
         VALID    ( lCalcDC( aTmp[ _CENTBNC ], aTmp[ _CSUCBNC ], aTmp[ _CDIGBNC ], aTmp[ _CCTABNC ], aGet[ _CDIGBNC ] ) ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CSUCBNC ] VAR aTmp[ _CSUCBNC ];
         ID       421 ;
         WHEN     ( lWhen );
         VALID    ( lCalcDC( aTmp[ _CENTBNC ], aTmp[ _CSUCBNC ], aTmp[ _CDIGBNC ], aTmp[ _CCTABNC], aGet[ _CDIGBNC ] ) ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CDIGBNC ] VAR aTmp[ _CDIGBNC ];
         ID       422 ;
         WHEN     ( lWhen );
         VALID    ( lCalcDC( aTmp[ _CENTBNC ], aTmp[ _CSUCBNC ], aTmp[ _CDIGBNC ], aTmp[ _CCTABNC ], aGet[ _CDIGBNC ] ) ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CCTABNC ] VAR aTmp[ _CCTABNC ];
         ID       423 ;
         WHEN     ( lWhen );
         PICTURE  "9999999999" ;
         VALID    ( lCalcDC( aTmp[ _CENTBNC ], aTmp[ _CSUCBNC ], aTmp[ _CDIGBNC ], aTmp[ _CCTABNC ], aGet[ _CDIGBNC ] ) ) ;
         OF       oFld:aDialogs[1]

      /*
      Codigo de Agente_______________________________________________________________
      */

      REDEFINE GET aGet[ _CCODAGE ] VAR aTmp[ _CCODAGE ] ;
         ID       220 ;
         WHEN     ( lWhen ) ;
         VALID    ( cAgentes( aGet[_CCODAGE], dbfAgent, oSay[ 4 ], aGet[ _NPCTCOMAGE ], dbfAgeCom ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwAgentes( aGet[_CCODAGE], oSay[ 4 ] ) ) ;
			COLOR 	CLR_GET ;
			OF 		oFld:aDialogs[1]

      REDEFINE GET oSay[ 4 ] VAR cSay[ 4 ] ;
         ID       221 ;
         WHEN     ( !Empty( aTmp[ _CCODAGE ] ) .AND. lWhen ) ;
         BITMAP   "Bot" ;
         ON HELP  ( ExpAgente( aTmp[ _CCODAGE ], aTmp[ _NPCTCOMAGE ], dbfTmpLin, oBrwLin ), RecalculaTotal( aTmp ) ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _NPCTCOMAGE ] VAR aTmp[ _NPCTCOMAGE ] ;
         WHEN     ( !Empty( aTmp[ _CCODAGE ] ) .AND. lWhen ) ;
         PICTURE  "@E 999.99" ;
         SPINNER;
         ID       222 ;
			OF 		oFld:aDialogs[1]

      REDEFINE GET oGetAge VAR nTotAge ;
         ID       223 ;
         WHEN     ( .f. );
			OF 		oFld:aDialogs[1]

      /*
		Ruta____________________________________________________________________
		*/

		REDEFINE GET aGet[ _CCODRUT ] VAR aTmp[ _CCODRUT ] ;
         ID       225 ;
         WHEN     ( lWhen ) ;
         VALID    ( cRuta( aGet[ _CCODRUT ], dbfRuta, oSay[ 7 ] ) );
         BITMAP   "LUPA" ;
         ON HELP  ( BrwRuta( aGet[ _CCODRUT ], dbfRuta, oSay[ 7 ] ) );
         OF       oFld:aDialogs[1]

      REDEFINE GET oSay[ 7 ] VAR cSay[ 7 ] ;
         ID       226 ;
			WHEN 		.F. ;
         OF       oFld:aDialogs[1]

      REDEFINE GET oSay[ 9 ] VAR cSay[ 9 ] ;
         ID       166 ;
         WHEN     .f. ;
         OF       oFld:aDialogs[2]

      /*
      Codigo de Divisas______________________________________________________________
      */

      REDEFINE GET aGet[ _CDIVALB ] VAR aTmp[ _CDIVALB ];
         WHEN     ( nMode == APPD_MODE .AND. ( dbfTmpLin )->( LastRec() ) == 0 ) ;
         VALID    ( cDivOut( aGet[ _CDIVALB ], oBmpDiv, aTmp[ _NVDVALB ], @cPouDiv, @nDouDiv, @cPorDiv, @nDorDiv, @cPpvDiv, @nDpvDiv, oGetMasDiv, dbfDiv, oBandera ) );
         PICTURE  "@!";
         ID       230 ;
         BITMAP   "LUPA" ;
         ON HELP  BrwDiv( aGet[ _CDIVALB ], oBmpDiv, aTmp[ _NVDVALB ], dbfDiv, oBandera ) ;
			OF 		oFld:aDialogs[1]

		REDEFINE BITMAP oBmpDiv ;
         RESOURCE ( cBmpDiv( aTmp[ _CDIVALB ], dbfDiv ) ) ;
         ID       231;
			OF 		oFld:aDialogs[1]

      /*
      REDEFINE GET aGet[ _NVDVALB ] VAR aTmp[ _NVDVALB ];
			WHEN		( .F. ) ;
         ID       232 ;
         VALID    ( aTmp[ _NVDVALB ] > 0 ) ;
			PICTURE	"@E 999,999.9999" ;
			COLOR 	CLR_GET ;
			OF 		oFld:aDialogs[1]

      Bitmap________________________________________________________________
		*/

      REDEFINE BITMAP oBmpEmp ;
         FILE     "Bmp\ImgAlbCli.bmp" ;
         ID       500 ;
         OF       oDlg

      /*
      Detalle------------------------------------------------------------------
      */

      oBrwLin                 := IXBrowse():New( oFld:aDialogs[1] )

      oBrwLin:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwLin:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrwLin:cAlias          := dbfTmpLin

      oBrwLin:nMarqueeStyle   := 6
      oBrwLin:cName           := "Albaran de cliente.Detalle"

      oBrwLin:CreateFromResource( 240 )

      with object ( oBrwLin:AddCol() )
         :cHeader             := "Oferta"
         :bStrData            := {|| "" }
         :bEditValue          := {|| ( dbfTmpLin )->lLinOfe }
         :nWidth              := 60
         :SetCheck( { "Star_Red_16", "Nil16" } )
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader             := "Número"
         :bEditValue          := {|| ( dbfTmpLin )->nNumLin }
         :cEditPicture        := "9999"
         :nWidth              := 65
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader             := "Código"
         :bEditValue          := {|| ( dbfTmpLin )->cRef }
         :nWidth              := 70
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader             := "C. Barras"
         :bEditValue          := {|| cCodigoBarrasDefecto( ( dbfTmpLin )->cRef, dbfCodeBar ) }
         :nWidth              := 100
         :lHide               := .t.
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader             := "Descripción"
         :bEditValue          := {|| Descrip( dbfTmpLin ) }
         :nWidth              := 260
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader             := "Código proveedor"
         :bEditValue          := {|| AllTrim( ( dbfTmpLin )->cCodPrv ) }
         :nWidth              := 50
         :lHide               := !( IsMuebles() )
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader             := "Nombre proveedor"
         :bEditValue          := {|| AllTrim( ( dbfTmpLin )->cNomPrv ) }
         :nWidth              := 150
         :lHide               := !( IsMuebles() )
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader             := "Referencia proveedor"
         :bEditValue          := {|| AllTrim( ( dbfTmpLin )->cRefPrv ) }
         :nWidth              := 50
         :lHide               := !( IsMuebles() )
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader             := "Prop. 1"
         :bEditValue          := {|| ( dbfTmpLin )->cValPr1 }
         :nWidth              := 40
         :lHide               := .t.
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader             := "Prop. 2"
         :bEditValue          := {|| ( dbfTmpLin )->cValPr2 }
         :nWidth              := 40
         :lHide               := .t.
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader             := "Lote"
         :bEditValue          := {|| ( dbfTmpLin )->cLote }
         :nWidth              := 60
         :lHide               := .t.
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader             := "Caducidad"
         :bEditValue          := {|| Dtoc( ( dbfTmpLin )->dFecCad ) }
         :nWidth              := 60
         :lHide               := .t.
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader             := cNombreCajas()
         :bEditValue          := {|| ( dbfTmpLin )->nCanEnt }
         :cEditPicture        := MasUnd()
         :nWidth              := 60
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
         :lHide               := .t.
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader             := cNombreUnidades()
         :bEditValue          := {|| nTotNAlbCli( dbfTmpLin ) }
         :cEditPicture        := cPicUnd
         :nWidth              := 60
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader             := "UM. Unidad de medición"
         :bEditValue          := {|| ( dbfTmpLin )->cUnidad }
         :nWidth              := 25
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader             := "Alm."
         :bEditValue          := {|| ( dbfTmpLin )->cAlmLin }
         :nWidth              := 35
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader             := "Precio"
         :bEditValue          := {|| nTotUAlbCli( dbfTmpLin, nDouDiv ) }
         :cEditPicture        := cPouDiv
         :nWidth              := 80
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader             := "% Dto."
         :bEditValue          := {|| ( dbfTmpLin )->nDto }
         :cEditPicture        := "@E 999.99"
         :nWidth              := 60
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader             := "Dto. Lin."
         :bEditValue          := {|| nDtoUAlbCli( dbfTmpLin, nDouDiv ) }
         :cEditPicture        := cPouDiv
         :nWidth              := 50
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
         :lHide               := .t.
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader             := "% Prm."
         :bEditValue          := {|| ( dbfTmpLin )->nDtoPrm }
         :cEditPicture        := "@E 999.99"
         :nWidth              := 40
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
         :lHide               := .t.
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader             := "% Age"
         :bEditValue          := {|| ( dbfTmpLin )->nComAge }
         :cEditPicture        := "@E 999.99"
         :nWidth              := 40
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
         :lHide               := .t.
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader             := "% " + cImp()
         :bEditValue          := {|| ( dbfTmpLin )->nIva }
         :cEditPicture        := "@E 999.99"
         :nWidth              := 50
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader             := "Portes"
         :bEditValue          := {|| nTrnUAlbCli( dbfTmpLin, nRouDiv ) }
         :cEditPicture        := cPouDiv
         :nWidth              := 70
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
         :lHide               := .t.
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader             := "P. verde"
         :bEditValue          := {|| nPntUAlbCli( dbfTmpLin, nDpvDiv ) }
         :cEditPicture        := cPpvDiv
         :nWidth              := 70
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
         :lHide               := .t.
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader             := "Total"
         :bEditValue          := {|| nTotLAlbCli( dbfTmpLin, nDouDiv, nRouDiv, nil, .t., aTmp[ _LOPERPV ], .t. ) }
         :cEditPicture        := cPorDiv
         :nWidth              := 102
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
      end with

      if nMode != ZOOM_MODE
         oBrwLin:bLDblClick   := {|| EdtDeta( oBrwLin, bEdtDet, aTmp ) }
      end if

		/*
		Cajas para el desglose
		*/

      REDEFINE GET aGet[ _CDTOESP ] VAR aTmp[ _CDTOESP ] ;
         ID       249 ;
         WHEN     ( lWhen ) ;
			OF 		oFld:aDialogs[1]

      REDEFINE GET aGet[ _NDTOESP ] VAR aTmp[ _NDTOESP ] ;
         ID       250 ;
         PICTURE  "@E 999.99" ;
         SPINNER ;
         VALID    ( RecalculaTotal( aTmp ) ) ;
         ON CHANGE( RecalculaTotal( aTmp ) ) ;
         WHEN     ( lWhen ) ;
			OF 		oFld:aDialogs[1]

      REDEFINE BUTTON oSayLabels[ 2 ] ;
         ID       248 ;
         OF       oFld:aDialogs[ 1 ] ;
         WHEN     ( lWhen ) ;
         ACTION   ( aGet[ _NDTOESP ]:cText( Val( GetPvProfString( "Descuentos", "Descuento especial", 0, cPatEmp() + "Empresa.Ini" ) ) ), RecalculaTotal( aTmp ) )

      REDEFINE GET aGet[ _CDPP ] VAR aTmp[ _CDPP ] ;
         ID       259 ;
         WHEN     ( lWhen ) ;
			OF 		oFld:aDialogs[1]

		REDEFINE GET aGet[ _NDPP ] VAR aTmp[ _NDPP ];
         ID       260 ;
         PICTURE  "@E 999.99" ;
         SPINNER ;
         VALID    ( RecalculaTotal( aTmp ) ) ;
         ON CHANGE( RecalculaTotal( aTmp ) ) ;
         WHEN     ( lWhen ) ;
			OF 		oFld:aDialogs[1]

      REDEFINE BUTTON oSayLabels[ 3 ] ;
         ID       258 ;
         OF       oFld:aDialogs[ 1 ] ;
         WHEN     ( lWhen ) ;
         ACTION   ( aGet[ _NDPP ]:cText( Val( GetPvProfString( "Descuentos", "Descuento pronto pago", 0, cPatEmp() + "Empresa.Ini" ) ) ), RecalculaTotal( aTmp ) )

		REDEFINE GET aGet[ _CDTOUNO ] VAR aTmp[ _CDTOUNO ] ;
         ID       270 ;
         WHEN     ( lWhen ) ;
			OF 		oFld:aDialogs[1]

		REDEFINE GET aGet[ _NDTOUNO ] VAR aTmp[ _NDTOUNO ];
         ID       280 ;
         PICTURE  "@E 999.99" ;
         SPINNER ;
         VALID    ( RecalculaTotal( aTmp ) ) ;
         ON CHANGE( RecalculaTotal( aTmp ) ) ;
         WHEN     ( lWhen ) ;
			OF 		oFld:aDialogs[1]

      REDEFINE BUTTON oSayLabels[ 4 ] ;
         ID       268 ;
         OF       oFld:aDialogs[ 1 ] ;
         WHEN     ( lWhen ) ;
         ACTION   ( aGet[ _NDTOUNO ]:cText( Val( GetPvProfString( "Descuentos", "Descuento uno", 0, cPatEmp() + "Empresa.Ini" ) ) ), RecalculaTotal( aTmp ) )

      REDEFINE GET aGet[ _CDTODOS ] VAR aTmp[ _CDTODOS ] ;
         ID       290 ;
         WHEN     ( lWhen ) ;
			OF 		oFld:aDialogs[1]

      REDEFINE GET aGet[ _NDTODOS ] VAR aTmp[ _NDTODOS ];
         ID       300 ;
         PICTURE  "@E 999.99" ;
         SPINNER ;
         VALID    ( RecalculaTotal( aTmp ) ) ;
         ON CHANGE( RecalculaTotal( aTmp ) ) ;
         WHEN     ( lWhen ) ;
			OF 		oFld:aDialogs[1]

      REDEFINE BUTTON oSayLabels[ 5 ] ;
         ID       288 ;
         OF       oFld:aDialogs[ 1 ] ;
         WHEN     ( lWhen ) ;
         ACTION   ( aGet[ _NDTODOS ]:cText( Val( GetPvProfString( "Descuentos", "Descuento dos", 0, cPatEmp() + "Empresa.Ini" ) ) ), RecalculaTotal( aTmp ) )

      if IsMuebles()

         REDEFINE GET aGet[_NMONTAJE] VAR aTmp[_NMONTAJE];
            ID       750 ;
            WHEN     ( lWhen ) ;
            PICTURE  "@E 999.99" ;
            SPINNER;
            COLOR    CLR_GET ;
            OF       oFld:aDialogs[1]

      end if

      /*
      Desglose del IGIC---------------------------------------------------------
      */

      oBrwIva                        := TXBrowse():New( oFld:aDialogs[ 1 ] )

      oBrwIva:bClrSel                := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwIva:bClrSelFocus           := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrwIva:SetArray( aTotIva, , , .f. )

      oBrwIva:nMarqueeStyle          := 5
      oBrwIva:lRecordSelector        := .f.
      oBrwIva:lHScroll               := .f.

      oBrwIva:CreateFromResource( 310 )

      with object ( oBrwIva:AddCol() )
         :cHeader          := "Base"
         :bStrData         := {|| if( aTotIva[ oBrwIva:nArrayAt, 3 ] != nil, Trans( aTotIva[ oBrwIva:nArrayAt, 2 ], cPorDiv ), "" ) }
         :nWidth           := 96
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      with object ( oBrwIva:AddCol() )
         :cHeader          := "%" + cImp()
         :bStrData         := {|| if( !IsNil( aTotIva[ oBrwIva:nArrayAt, 3 ] ), aTotIva[ oBrwIva:nArrayAt, 3 ], "" ) }
         :bEditValue       := {|| aTotIva[ oBrwIva:nArrayAt, 3 ] }
         :nWidth           := 55
         :cEditPicture     := "@E 999.99"
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
         :nFootStrAlign    := 1
         :nEditType        := 1
         :bEditWhen        := {|| !IsNil( aTotIva[ oBrwIva:nArrayAt, 3 ] ) }
         :bOnPostEdit      := {|o,x| EdtIva( o, x, aTotIva[ oBrwIva:nArrayAt, 3 ], dbfTmpLin, dbfIva, oBrwLin ), RecalculaTotal( aTmp ) }
      end with

      with object ( oBrwIva:AddCol() )
         :cHeader          := cImp()
         :bStrData         := {|| if( aTotIva[ oBrwIva:nArrayAt, 3 ] != nil, Trans( aTotIva[ oBrwIva:nArrayAt, 8 ], cPorDiv ), "" ) }
         :nWidth           := 58
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      with object ( oBrwIva:AddCol() )
         :cHeader          := "% R.E."
         :bStrData         := {|| if( aTotIva[ oBrwIva:nArrayAt, 3 ] != nil .and. aTmp[ _LRECARGO ], Trans( aTotIva[ oBrwIva:nArrayAt, 4 ], "@E 99.9"), "" ) }
         :nWidth           := 54
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      with object ( oBrwIva:AddCol() )
         :cHeader          := "R.E."
         :bStrData         := {|| if( aTotIva[ oBrwIva:nArrayAt, 3 ] != nil .and. aTmp[ _LRECARGO ], Trans( aTotIva[ oBrwIva:nArrayAt, 9 ], cPorDiv ), "" ) }
         :nWidth           := 54
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

		/*
		Cajas de Totales
		------------------------------------------------------------------------
		*/

      REDEFINE GET aGet[ _CMANOBR ] VAR aTmp[ _CMANOBR ] ;
         ID       411 ;
			COLOR 	CLR_GET ;
         WHEN     ( lWhen ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _NIVAMAN ] VAR aTmp[ _NIVAMAN ] ;
         ID       412 ;
         WHEN     ( lWhen ) ;
         PICTURE  "@E 99.99" ;
         VALID    ( lTiva( dbfIva, aTmp[ _NIVAMAN ] ) .and. RecalculaTotal( aTmp ) );
         ON CHANGE( RecalculaTotal( aTmp ) );
         BITMAP   "LUPA" ;
         ON HELP  ( BrwIva( aGet[ _NIVAMAN ], dbfIva, , .t. ) );
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _NMANOBR ] VAR aTmp[ _NMANOBR ] ;
         ID       400 ;
         PICTURE  cPorDiv ;
         WHEN     ( lWhen ) ;
         VALID    ( RecalculaTotal( aTmp ) ) ;
         OF       oFld:aDialogs[1]

      REDEFINE SAY oGetNet VAR nTotNet ;
         ID       401 ;
			OF 		oFld:aDialogs[1]

      REDEFINE SAY oGetTrn VAR nTotTrn ;
         ID       402 ;
         OF       oFld:aDialogs[1]

      REDEFINE SAY oSayGetRnt ID 709 OF oFld:aDialogs[1]

      REDEFINE GET oGetRnt VAR nTotRnt ;
         ID       408 ;
         OF       oFld:aDialogs[1]

      REDEFINE SAY oGetIvm VAR nTotIvm;
         ID       403 ;
			OF 		oFld:aDialogs[1]

      REDEFINE CHECKBOX aGet[ _LOPERPV ] ;
         VAR      aTmp[ _LOPERPV  ] ;
         ID       409 ;
         WHEN     ( lWhen ) ;
         ON CHANGE( RecalculaTotal( aTmp ), oBrwLin:Refresh() );
			OF 		oFld:aDialogs[1]

      REDEFINE SAY oGetPnt VAR nTotPnt;
         ID       404 ;
         OF       oFld:aDialogs[1]

      REDEFINE SAY oGetIva VAR nTotIva ;
         ID       405 ;
			OF 		oFld:aDialogs[1]

      REDEFINE CHECKBOX aGet[ _LRECARGO ] ;
         VAR      aTmp[ _LRECARGO ] ;
         ID       406 ;
         WHEN     ( lWhen ) ;
         ON CHANGE( RecalculaTotal( aTmp ) );
			OF 		oFld:aDialogs[1]

      REDEFINE SAY oGetReq VAR nTotReq ;
         ID       407 ;
			OF 		oFld:aDialogs[1]

      REDEFINE SAY oGetTotal VAR nTotAlb;
         ID       360 ;
			FONT 		oFont ;
			OF 		oFld:aDialogs[1]

      /*
		Botones de la caja de dialogo___________________________________________
		*/

      REDEFINE BUTTON ;
			ID 		515 ;
			OF 		oFld:aDialogs[1] ;
         WHEN     ( lWhen ) ;
         ACTION   ( AppDeta( oBrwLin, bEdtDet, aTmp, .t., nMode ) )

		REDEFINE BUTTON ;
			ID 		500 ;
			OF 		oFld:aDialogs[1] ;
         WHEN     ( lWhen ) ;
         ACTION   ( AppDeta( oBrwLin, bEdtDet, aTmp, .f., nMode ) )

		REDEFINE BUTTON ;
			ID 		501 ;
			OF 		oFld:aDialogs[1] ;
         WHEN     ( lWhen ) ;
         ACTION   ( EdtDeta( oBrwLin, bEdtDet, aTmp, .f., nMode ) )

		REDEFINE BUTTON ;
			ID 		502 ;
			OF 		oFld:aDialogs[1] ;
         WHEN     ( lWhen ) ;
         ACTION   ( WinDelRec( oBrwLin, dbfTmpLin, {|| delDeta() }, {|| RecalculaTotal( aTmp ) } ) )

		REDEFINE BUTTON ;
			ID 		503 ;
			OF 		oFld:aDialogs[1] ;
         ACTION   ( WinZooRec( oBrwLin, bEdtDet, dbfTmpLin, .f., nMode, aTmp ) )

		REDEFINE BUTTON ;
			ID 		524 ;
			OF 		oFld:aDialogs[1] ;
         WHEN     ( lWhen ) ;
         ACTION   ( DbSwapUp( dbfTmpLin, oBrwLin ) )

		REDEFINE BUTTON ;
			ID 		525 ;
			OF 		oFld:aDialogs[1] ;
         WHEN     ( lWhen ) ;
         ACTION   ( DbSwapDown( dbfTmpLin, oBrwLin ) )

      REDEFINE BUTTON oBtnKit;
         ID       526 ;
			OF 		oFld:aDialogs[1] ;
         ACTION   ( ShowKit( dbfAlbCliT, dbfTmpLin, oBtnKit, oBrwLin, .t. ) )

      REDEFINE GET aGet[ _CSERALB ] VAR aTmp[ _CSERALB ] ;
         ID       100 ;
         SPINNER ;
         ON UP    ( UpSerie( aGet[ _CSERALB ] ) );
         ON DOWN  ( DwSerie( aGet[ _CSERALB ] ) );
         PICTURE  "@!" ;
			COLOR 	CLR_GET ;
         WHEN     ( nMode == APPD_MODE .OR. nMode == DUPL_MODE );
         VALID    ( aTmp[ _CSERALB ] >= "A" .AND. aTmp[ _CSERALB ] <= "Z"  );
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _NNUMALB ] VAR aTmp[ _NNUMALB ] ;
         ID       110 ;
			PICTURE 	"999999999" ;
			WHEN  	( .F. ) ;
			OF 		oFld:aDialogs[1]

      REDEFINE GET aGet[_CSUFALB] VAR aTmp[_CSUFALB] ;
         ID       120 ;
         PICTURE  "@!" ;
			WHEN  	( .F. ) ;
			OF 		oFld:aDialogs[1]

		REDEFINE GET aGet[_DFECALB] VAR aTmp[_DFECALB];
         ID       130 ;
			SPINNER ;
         WHEN     ( lWhen ) ;
			COLOR 	CLR_GET ;
			OF 		oFld:aDialogs[1]

      REDEFINE COMBOBOX oTipAlb VAR cTipAlb ;
         ID       217 ;
         WHEN     ( ( dbfTmpLin )->( LastRec() ) == 0 ) ;
         ON CHANGE(SetDialog( aGet, oSayDias, oSayTxtDias, oSayGetRnt, oGetRnt ) );
         ITEMS    aTipAlb ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _DFECSAL ] VAR aTmp[ _DFECSAL ];
         ID       111 ;
         IDSAY    112 ;
			SPINNER;
			WHEN 		( nMode != ZOOM_MODE ) ;
			COLOR 	CLR_GET ;
         ON CHANGE( oSayDias:Refresh() );
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _DFECENTR ] VAR aTmp[ _DFECENTR ];
         ID       113 ;
         IDSAY    114 ;
			SPINNER;
			WHEN 		( nMode != ZOOM_MODE ) ;
         COLOR    CLR_GET ;
         ON CHANGE( oSayDias:Refresh() );
         OF       oFld:aDialogs[1]

      REDEFINE SAY oSayDias ;
         VAR      ( aTmp[ _DFECENTR ] - aTmp[ _DFECSAL ] );
         ID       115 ;
         PICTURE  "9999" ;
         OF       oFld:aDialogs[1]

      REDEFINE SAY oSayTxtDias ;
         ID       116 ;
         OF       oFld:aDialogs[1]

		REDEFINE GET aGet[ _CCODSUALB ] VAR aTmp[ _CCODSUALB ];
         ID       140 ;
         IDSAY    141 ;
         WHEN     ( lWhen ) ;
			OF 		oFld:aDialogs[1]

      REDEFINE BTNBMP oBtnPre ;
         ID       601 ;
         OF       oFld:aDialogs[1] ;
         RESOURCE "Notebook_user1_16" ;
         NOBORDER ;
         TOOLTIP  "Importar presupuesto" ;
         ACTION   ( BrwPreCli( aGet[ _CNUMPRE ], dbfPreCliT, dbfPreCliL, dbfIva, dbfDiv, dbfFPago, aGet[ _LIVAINC ] ) )

      REDEFINE BTNBMP oBtnSat ;
         ID       602 ;
         OF       oFld:aDialogs[1] ;
         RESOURCE "Power-drill_user1_16" ;
         NOBORDER ;
         TOOLTIP  "Importar SAT" ;
         ACTION   ( BrwSatCli( aGet[ _CNUMSAT ], dbfSatCliT, dbfSatCliL, dbfIva, dbfDiv, dbfFPago, aGet[ _LIVAINC ] ) )

      REDEFINE BTNBMP oBtnPed ;
         ID       603 ;
         OF       oFld:aDialogs[1] ;
         RESOURCE "Clipboard_empty_user1_16" ;
         NOBORDER ;
         TOOLTIP  "Importar pedido" ;
         ACTION   ( BrwPedCli( aGet[ _CNUMPED ], dbfPedCliT, dbfPedCliL, dbfIva, dbfDiv, dbfFPago, aGet[ _LIVAINC ] ) )

      REDEFINE BUTTON oBtnAgruparPedido;
         ID       512 ;
         OF       oFld:aDialogs[1] ;
         WHEN     ( nMode == APPD_MODE .and. Empty( aTmp[ _CNUMPED ] ) ) ;
         ACTION   ( GrpPed( aGet, aTmp, oBrwLin  ) )

      REDEFINE BUTTON oBtnAgruparSat;
         ID       513 ;
         OF       oFld:aDialogs[1] ;
         WHEN     ( nMode == APPD_MODE .and. Empty( aTmp[ _CNUMSAT ] ) ) ;
         ACTION   ( GrpSat( aGet, aTmp, oBrwLin  ) )

      REDEFINE GET aGet[ _CNUMPED ] VAR aTmp[ _CNUMPED ] ;
         ID       150 ;
         PICTURE  "@R #/#########/##" ;
         VALID    ( cPedCli( aGet, aTmp, oBrwLin, oBrwPgo, nMode ), RecalculaTotal( aTmp ), SetDialog( aGet, oSayDias, oSayTxtDias, oSayGetRnt, oGetRnt ) );
         WHEN     ( nMode == APPD_MODE ) ;
         ON HELP  ( BrwPedCli( aGet[ _CNUMPED ], dbfPedCliT, dbfPedCliL, dbfIva, dbfDiv, dbfFPago, aGet[ _LIVAINC ] ),;
                    RecalculaTotal( aTmp ) ) ;
         BITMAP   "LUPA" ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CNUMPRE ] VAR aTmp[ _CNUMPRE ] ;
         ID       151 ;
         WHEN     ( .f. ) ;
         VALID    ( cPreCli( aGet, aTmp, oBrwLin, nMode ), RecalculaTotal( aTmp ), SetDialog( aGet, oSayDias, oSayTxtDias, oSayGetRnt, oGetRnt ) ) ;
         PICTURE  "@R #/#########/##" ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CNUMSAT ] VAR aTmp[ _CNUMSAT ] ;
         ID       152 ;
         WHEN     ( .f. ) ;
         VALID    ( cSatCli( aGet, aTmp, oBrwLin, nMode ), RecalculaTotal( aTmp ), SetDialog( aGet, oSayDias, oSayTxtDias, oSayGetRnt, oGetRnt ) ) ;
         PICTURE  "@R #/#########/##" ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _LFACTURADO ] VAR cEstAlb;
         WHEN     .f. ;
         ID       160 ;
			OF 		oFld:aDialogs[1]

      REDEFINE CHECKBOX aGet[ _LIVAINC ] VAR aTmp[ _LIVAINC ] ;
         ID       165 ;
         WHEN     ( lWhen .and. ( dbfTmpLin )->( LastRec() ) == 0 ) ;
         OF       oFld:aDialogs[1]

      /*
      REDEFINE CHECKBOX aTmp[ _LENTREGADO ] ;
         ID       166 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]
      */

      /*
      Segunda caja de dialogo
      */

      /*
      Transportistas-----------------------------------------------------------
      */

      REDEFINE GET aGet[ _CCODTRN ] VAR aTmp[ _CCODTRN ] ;
         ID       235 ;
         WHEN     ( lWhen ) ;
         VALID    ( LoadTrans( aTmp, aGet[ _CCODTRN ], aGet[ _NKGSTRN ], oSay[ 8 ] ) );
         BITMAP   "LUPA" ;
         ON HELP  ( oTrans:Buscar( aGet[ _CCODTRN ] ), .t. );
         OF       oFld:aDialogs[2]

      REDEFINE GET oSay[ 8 ] VAR cSay[ 8 ] ;
         ID       236 ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ _NKGSTRN ] VAR aTmp[ _NKGSTRN ] ;
         ID       237 ;
         WHEN     ( .f. ) ;
         PICTURE  ( MasUnd() ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ _NBULTOS ] VAR aTmp[ _NBULTOS ];
         ID       128 ;
			SPINNER;
         PICTURE  "999" ;
         WHEN     ( lWhen ) ;
			COLOR 	CLR_GET ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ _CSUPED ] VAR aTmp[ _CSUPED ];
         ID       129 ;
         WHEN     ( lWhen ) ;
         OF       oFld:aDialogs[2]

      /*
		Cajas____________________________________________________________________
		*/

      REDEFINE GET aGet[ _CCODCAJ ] VAR aTmp[ _CCODCAJ ];
         WHEN     ( lWhen ) ;
         VALID    cCajas( aGet[ _CCODCAJ ], dbfCajT, oSay[ 9 ] ) ;
         ID       165 ;
			COLOR 	CLR_GET ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwCajas( aGet[ _CCODCAJ ], oSay[ 9 ] ) ) ;
         OF       oFld:aDialogs[2]

      /*
      Retirado por________________________________________________________________
		*/

      REDEFINE GET aGet[_CRETPOR] VAR aTmp[_CRETPOR] ;
         ID       160 ;
			COLOR 	CLR_GET ;
         WHEN     ( lWhen ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[_CRETMAT] VAR aTmp[_CRETMAT] ;
         ID       170 ;
			COLOR 	CLR_GET ;
         WHEN     ( lWhen ) ;
         OF       oFld:aDialogs[2]

      /*
      Fecha entregado
      */

      REDEFINE CHECKBOX aGet[_LENTREGADO] VAR aTmp[_LENTREGADO] ;
         ID       200 ;
         ON CHANGE( ValCheck( aGet, aTmp ) ) ;
         WHEN     ( lWhen ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[_DFECENV] VAR aTmp[_DFECENV] ;
         ID       127 ;
         SPINNER ;
         WHEN     ( lWhen ) ;
         OF       oFld:aDialogs[2]

      /*
		Comentarios_____________________________________________________________
		*/

		REDEFINE GET aGet[_CCONDENT] VAR aTmp[_CCONDENT] ;
			ID 		230 ;
         WHEN     ( lWhen ) ;
			OF 		oFld:aDialogs[2]

      REDEFINE GET aGet[_MOBSERV] VAR aTmp[_MOBSERV] MEMO ;
         ID       240 ;
         WHEN     ( lWhen ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[_MCOMENT] VAR aTmp[_MCOMENT] MEMO ;
         ID       250 ;
         WHEN     ( lWhen ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[_CCODDLG] VAR aTmp[_CCODDLG] ;
         ID       300 ;
         WHEN     ( .f. ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET oSay[ 11 ] VAR cSay[ 11 ] ;
         ID       301 ;
         WHEN     ( .f. ) ;
         OF       oFld:aDialogs[2]

      /*Impresión ( informa de si está imprimido o no y de cuando se imprimió )*/

      REDEFINE CHECKBOX aGet[ _LIMPRIMIDO ] VAR aTmp[ _LIMPRIMIDO ] ;
         ID       120 ;
         WHEN     ( lWhen .and. lUsrMaster() ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ _DFECIMP ] VAR aTmp[ _DFECIMP ] ;
         ID       121 ;
         WHEN     ( lWhen .and. lUsrMaster() ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ _CHORIMP ] VAR aTmp[ _CHORIMP ] ;
         ID       122 ;
         WHEN     ( lWhen .and. lUsrMaster() ) ;
         OF       oFld:aDialogs[2]

      REDEFINE SAY oGetMasDiv VAR cGetMasDiv;
         ID       488 ;
			FONT 		oFont ;
			OF 		oFld:aDialogs[1]

      /*
      Pagos
      -------------------------------------------------------------------------
      */

      oBrwPgo                 := IXBrowse():New( oFld:aDialogs[2] )

      oBrwPgo:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwPgo:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrwPgo:cAlias          := dbfTmpPgo
      oBrwPgo:cName           := "Albaran de cliente.Pagos"

      oBrwPgo:nMarqueeStyle   := 6
      oBrwPgo:lHScroll        := .f.

      oBrwPgo:CreateFromResource( 310 )

      with object ( oBrwPgo:AddCol() )
         :cHeader             := "Sesión cerrada"
         :bStrData            := {|| "" }
         :bEditValue          := {|| ( dbfTmpPgo )->lCloPgo }
         :nWidth              := 20
         :SetCheck( { "Cnt16", "Nil16" } )
      end with

      with object ( oBrwPgo:AddCol() )
         :cHeader             := "Fecha"
         :bEditValue          := {|| Dtoc( ( dbfTmpPgo )->dEntrega ) }
         :nWidth              := 80
      end with

      with object ( oBrwPgo:AddCol() )
         :cHeader             := "Sesión"
         :bEditValue          := {|| ( dbfTmpPgo )->cTurRec }
         :nWidth              := 60
         :lHide               := .t.
      end with

      with object ( oBrwPgo:AddCol() )
         :cHeader             := "Caja"
         :bEditValue          := {|| ( dbfTmpPgo )->cCodCaj }
         :nWidth              := 50
      end with

      with object ( oBrwPgo:AddCol() )
         :cHeader             := "Agente"
         :bEditValue          := {|| ( dbfTmpPgo )->cCodAge }
         :nWidth              := 60
      end with

      with object ( oBrwPgo:AddCol() )
         :cHeader             := "Concepto"
         :bEditValue          := {|| ( dbfTmpPgo )->cDescrip }
         :nWidth              := 155
      end with

      with object ( oBrwPgo:AddCol() )
         :cHeader             := "Importe"
         :bEditValue          := {|| nEntAlbCli( dbfTmpPgo, dbfDiv, cDivEmp(), .t. ) }
         :nWidth              := 80
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
      end with

      with object ( oBrwPgo:AddCol() )
         :cHeader             := "Forma pago"
         :bEditValue          := {|| ( dbfTmpPgo )->cCodPgo }
         :nWidth              := 120
         :lHide               := .t.
      end with

      if nMode == EDIT_MODE
         oBrwPgo:bLDblClick   := {|| WinEdtRec( oBrwPgo, bEdtPgo, dbfTmpPgo, nil, nil, aTmp ), RecalculaTotal( aTmp ) }
      end if

      REDEFINE BUTTON ;
         ID       501 ;
         OF       oFld:aDialogs[2] ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( WinAppRec( oBrwPgo, bEdtPgo, dbfTmpPgo, nil, nil, aTmp ), RecalculaTotal( aTmp ) )

      REDEFINE BUTTON ;
         ID       502 ;
         OF       oFld:aDialogs[2] ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( WinEdtRec( oBrwPgo, bEdtPgo, dbfTmpPgo, nil, nil, aTmp ), RecalculaTotal( aTmp ) )

      REDEFINE BUTTON ;
         ID       503 ;
         OF       oFld:aDialogs[2] ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( if( ( dbfTmpPgo )->lCloPgo .and. !oUser():lAdministrador(), MsgStop( "Solo pueden eliminar las entregas cerradas los administradores." ), ( WinDelRec( oBrwPgo, dbfTmpPgo ), RecalculaTotal( aTmp ) ) ) )

      REDEFINE BUTTON ;
         ID       600 ;
         OF       oFld:aDialogs[2] ;
         WHEN     ( nMode == EDIT_MODE ) ;
         ACTION   ( PrnEntregas( .f., dbfTmpPgo ) )

      REDEFINE BUTTON ;
         ID       610 ;
         OF       oFld:aDialogs[2] ;
         WHEN     ( nMode == EDIT_MODE ) ;
         ACTION   ( PrnEntregas( .t., dbfTmpPgo ) )

      /*
      Pagado y pendiente en facturas
      ------------------------------------------------------------------------
      */

      REDEFINE SAY oGetAlb VAR nTotAlb ;
         ID       320 ;
         OF       oFld:aDialogs[2]

      REDEFINE SAY oGetEnt VAR 0 ;
         ID       330 ;
         OF       oFld:aDialogs[2]

      REDEFINE SAY oGetPdt VAR 0 ;
         ID       340 ;
         OF       oFld:aDialogs[2]

      REDEFINE GET oGetPes VAR nTotPes ;
         ID       570 ;
         WHEN     ( .f. ) ;
         PICTURE  ( MasUnd() ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET oGetDif VAR nTotDif ;
         ID       580 ;
         WHEN     ( .f. ) ;
         PICTURE  ( MasUnd() ) ;
         OF       oFld:aDialogs[2]

      /*
		Detalle________________________________________________________________
		*/

      oBrwInc                 := IXBrowse():New( oFld:aDialogs[ 3 ] )

      oBrwInc:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwInc:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrwInc:cAlias          := dbfTmpInc

      oBrwInc:nMarqueeStyle   := 6
      oBrwInc:cName           := "Albaran de cliente.Incidencias"

         with object ( oBrwInc:AddCol() )
            :cHeader          := "Resuelta"
            :bStrData         := {|| "" }
            :bEditValue       := {|| ( dbfTmpInc )->lListo }
            :nWidth           := 65
            :SetCheck( { "Sel16", "Cnt16" } )
         end with

         with object ( oBrwInc:AddCol() )
            :cHeader          := "Código"
            :bEditValue       := {|| ( dbfTmpInc )->cCodTip }
            :nWidth           := 80
         end with

         with object ( oBrwInc:AddCol() )
            :cHeader          := "Incidencia"
            :bEditValue       := {|| cNomInci( ( dbfTmpInc )->cCodTip, dbfInci ) }
            :nWidth           := 230
         end with

         with object ( oBrwInc:AddCol() )
            :cHeader          := "Fecha"
            :bEditValue       := {|| Dtoc( ( dbfTmpInc )->dFecInc ) }
            :nWidth           := 90
         end with

         with object ( oBrwInc:AddCol() )
            :cHeader          := "Descripción"
            :bEditValue       := {|| ( dbfTmpInc )->mDesInc }
            :nWidth           := 480
         end with

         if nMode != ZOOM_MODE
            oBrwInc:bLDblClick   := {|| WinEdtRec( oBrwInc, bEdtInc, dbfTmpInc, nil, nil, aTmp ) }
         else
            oBrwInc:bLDblClick   := {|| WinZooRec( oBrwInc, bEdtDet, aTmp ) }
         end if

         oBrwInc:CreateFromResource( 210 )

      REDEFINE BUTTON ;
         ID       500 ;
         OF       oFld:aDialogs[ 3 ] ;
         WHEN     ( lWhen ) ;
         ACTION   ( WinAppRec( oBrwInc, bEdtInc, dbfTmpInc, nil, nil, aTmp ) )

      REDEFINE BUTTON ;
         ID       501 ;
         OF       oFld:aDialogs[ 3 ] ;
         WHEN     ( lWhen ) ;
         ACTION   ( WinEdtRec( oBrwInc, bEdtInc, dbfTmpInc, nil, nil, aTmp ) )

		REDEFINE BUTTON ;
			ID 		502 ;
         OF       oFld:aDialogs[ 3 ] ;
         WHEN     ( lWhen ) ;
         ACTION   ( WinDelRec( oBrwInc, dbfTmpInc ) )

		REDEFINE BUTTON ;
			ID 		503 ;
         OF       oFld:aDialogs[ 3 ] ;
         ACTION   ( WinZooRec( oBrwInc, bEdtInc, dbfTmpInc ) )

      //Caja de documentos

      oBrwDoc                 := TXBrowse():New( oFld:aDialogs[ 4 ] )

      oBrwDoc:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwDoc:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrwDoc:cAlias          := dbfTmpDoc

      oBrwDoc:nMarqueeStyle   := 6
      oBrwDoc:nRowHeight      := 40
      oBrwDoc:nDataLines      := 2

      with object ( oBrwDoc:AddCol() )
         :cHeader          := "Documento"
         :bEditValue       := {|| Rtrim( ( dbfTmpDoc )->cNombre ) + CRLF + Space( 5 ) + Rtrim( ( dbfTmpDoc )->cRuta ) }
         :nWidth           := 860
      end with

      if nMode != ZOOM_MODE
         oBrwDoc:bLDblClick   := {|| ShellExecute( oDlg:hWnd, "open", Rtrim( ( dbfTmpDoc )->cRuta ) ) }
      end if

      oBrwDoc:CreateFromResource( 210 )

      REDEFINE BUTTON ;
         ID       500 ;
         OF       oFld:aDialogs[ 4 ] ;
         WHEN     ( lWhen ) ;
         ACTION   ( WinAppRec( oBrwDoc, bEdtDoc, dbfTmpDoc, nil, nil, aTmp ) )

      REDEFINE BUTTON ;
         ID       501 ;
         OF       oFld:aDialogs[ 4 ] ;
         WHEN     ( lWhen ) ;
         ACTION   ( WinEdtRec( oBrwDoc, bEdtDoc, dbfTmpDoc, nil, nil, aTmp ) )

		REDEFINE BUTTON ;
			ID 		502 ;
         OF       oFld:aDialogs[ 4 ] ;
         WHEN     ( lWhen ) ;
         ACTION   ( WinDelRec( oBrwDoc, dbfTmpDoc ) )

		REDEFINE BUTTON ;
			ID 		503 ;
         OF       oFld:aDialogs[ 4 ] ;
         ACTION   ( WinZooRec( oBrwDoc, bEdtDoc, dbfTmpDoc ) )

      REDEFINE BUTTON ;
         ID       504 ;
         OF       oFld:aDialogs[ 4 ] ;
         ACTION   ( ShellExecute( oDlg:hWnd, "open", rTrim( ( dbfTmpDoc )->cRuta ) ) )

      /*
		Botones comunes a la caja de dialogo____________________________________
		*/

      REDEFINE BUTTON ;
         ID       3 ;
         OF       oDlg ;
         WHEN     ( lWhen ) ;
         ACTION   ( RecAlbCli( aTmp, oDlg ), oBrwLin:Refresh(), RecalculaTotal( aTmp ) )

      REDEFINE BUTTON ;
         ID       4 ;
			OF 		oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( if( EndTrans( aTmp, aGet, oBrw, oBrwInc, nMode, oDlg ), GenAlbCli( IS_PRINTER ), ) )

		REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( EndTrans( aTmp, aGet, oBrw, oBrwInc, nMode, oDlg ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
         CANCEL ;
         ACTION   ( If( ExitNoSave( nMode, dbfTmpLin ), oDlg:end(), ) )

      REDEFINE GROUP oSayLabels[ 1 ] ID 700 OF oFld:aDialogs[ 1 ] TRANSPARENT
      REDEFINE SAY   oSayLabels[ 6 ] ID 708 OF oFld:aDialogs[ 1 ]
      REDEFINE SAY   oSayLabels[ 7 ] ID 710 OF oFld:aDialogs[ 1 ]
      REDEFINE SAY   oSayLabels[ 8 ] ID 711 OF oFld:aDialogs[ 1 ]
      REDEFINE SAY   oSayLabels[ 9 ] ID 712 OF oFld:aDialogs[ 1 ]

   if nMode != ZOOM_MODE

      oFld:aDialogs[1]:AddFastKey( VK_F2, {|| AppDeta( oBrwLin, bEdtDet, aTmp, .f., nMode ) } )
      oFld:aDialogs[1]:AddFastKey( VK_F3, {|| EdtDeta( oBrwLin, bEdtDet, aTmp, .f., nMode ) } )
      oFld:aDialogs[1]:AddFastKey( VK_F4, {|| WinDelRec( oBrwLin, dbfTmpLin, {|| delDeta() }, {|| RecalculaTotal( aTmp ) } ) } )

      oFld:aDialogs[2]:AddFastKey( VK_F2, {|| WinAppRec( oBrwPgo, bEdtPgo, dbfTmpPgo, nil, nil, aTmp ), RecalculaTotal( aTmp ) } )
      oFld:aDialogs[2]:AddFastKey( VK_F3, {|| WinEdtRec( oBrwPgo, bEdtPgo, dbfTmpPgo, nil, nil, aTmp ), RecalculaTotal( aTmp ) } )
      oFld:aDialogs[2]:AddFastKey( VK_F4, {|| if( ( dbfTmpPgo )->lCloPgo .and. !oUser():lAdministrador(), MsgStop( "Solo pueden eliminar las entregas cerradas los administradores." ), ( WinDelRec( oBrwPgo, dbfTmpPgo ), RecalculaTotal( aTmp ) ) ) } )

      oFld:aDialogs[3]:AddFastKey( VK_F2, {|| WinAppRec( oBrwInc, bEdtInc, dbfTmpInc, nil, nil, aTmp ) } )
      oFld:aDialogs[3]:AddFastKey( VK_F3, {|| WinEdtRec( oBrwInc, bEdtInc, dbfTmpInc, nil, nil, aTmp ) } )
      oFld:aDialogs[3]:AddFastKey( VK_F4, {|| WinDelRec( oBrwInc, dbfTmpInc ) } )

      oFld:aDialogs[4]:AddFastKey( VK_F2, {|| WinAppRec( oBrwDoc, bEdtDoc, dbfTmpDoc, nil, nil, aTmp ) } )
      oFld:aDialogs[4]:AddFastKey( VK_F3, {|| WinEdtRec( oBrwDoc, bEdtDoc, dbfTmpDoc, nil, nil, aTmp ) } )
      oFld:aDialogs[4]:AddFastKey( VK_F4, {|| WinDelRec( oBrwDoc, dbfTmpDoc ) } )

      oDlg:AddFastKey( VK_F6,             {|| if( EndTrans( aTmp, aGet, oBrw, oBrwInc, nMode, oDlg ), GenAlbCli( IS_PRINTER ), ) } )
      oDlg:AddFastKey( VK_F5,             {|| EndTrans( aTmp, aGet, oBrw, oBrwInc, nMode, oDlg ) } )
      oDlg:AddFastKey( 65,                {|| if( GetKeyState( VK_CONTROL ), CreateInfoArticulo(), ) } )

   end if

   oDlg:AddFastKey ( VK_F1, {|| ChmHelp( "Albaranes2" ) } )

   do case
      case nMode == APPD_MODE .and. lRecogerUsuario() .and. Empty( cCodArt )
         oDlg:bStart := {|| if( lGetUsuario( aGet[ _CCODUSR ], dbfUsr ), , oDlg:End() ) }
      case nMode == APPD_MODE .and. lRecogerUsuario() .and. !Empty( cCodArt )
         oDlg:bStart := {|| if( lGetUsuario( aGet[ _CCODUSR ], dbfUsr ), AppDeta( oBrwLin, bEdtDet, aTmp, nil, nMode, cCodArt ), oDlg:End() ) }
      case nMode == APPD_MODE .and. !lRecogerUsuario() .and. !Empty( cCodArt )
         oDlg:bStart := {|| AppDeta( oBrwLin, bEdtDet, aTmp, nil, nMode, cCodArt ) }
      otherwise
         oDlg:bStart := {|| ShowKit( dbfAlbCliT, dbfTmpLin, oBtnKit, oBrwLin, .f., dbfTmpInc, cCodCli, dbfClient, oRieCli, oGetRnt, aGet, oSayGetRnt ) }
   end case

   ACTIVATE DIALOG   oDlg ;
      ON INIT        (  InitEdtRec( aTmp, aGet, oDlg, oSayDias, oSayTxtDias, oSayGetRnt, oGetRnt, oBrwLin, oBrwInc, oBrwPgo, aNumDoc ) );
      ON PAINT       (  RecalculaTotal( aTmp ) );
      CENTER

   oMenu:end()

   oFont:end()

   oBmpEmp:end()
   oBmpDiv:end()
   oBmpGeneral:end()

   oBrwLin:CloseData()
   oBrwPgo:CloseData()
   oBrwInc:CloseData()

   ( dbfAlbCliT )->( ordSetFocus( nOrd ) )

   KillTrans()

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

Static Function InitEdtRec( aTmp, aGet, oDlg, oSayDias, oSayTxtDias, oSayGetRnt, oGetRnt, oBrwLin, oBrwInc, oBrwPgo, aNumDoc )

   EdtRecMenu( aGet, aTmp, oBrwLin, oDlg )
                        
   SetDialog( aGet, oSayDias, oSayTxtDias, oSayGetRnt, oGetRnt )

   oBrwLin:Load()
   oBrwInc:Load()
   oBrwPgo:Load()

   if IsArray( aNumDoc ) .and. !Empty( aNumDoc[ 1 ] )
      aGet[ _CNUMPED ]:cText( aNumDoc[ 1 ] )
      aGet[ _CNUMPED ]:lValid()
   end if

   if IsArray( aNumDoc ) .and. !Empty( aNumDoc[ 2 ] )
      aGet[ _CNUMSAT ]:cText( aNumDoc[ 2 ] )
      aGet[ _CNUMSAT ]:lValid()
   end if

RETURN ( nil )

//---------------------------------------------------------------------------//



Static Function EdtRecMenu( aGet, aTmp, oBrw, oDlg )

   MENU oMenu

      MENUITEM    "&1. Rotor"

         MENU

            MENUITEM    "&1. Visualizar pedido";
               MESSAGE  "Visualiza el pedido del que proviene" ;
               RESOURCE "Clipboard_Empty_User1_16" ;
               ACTION   ( if( !Empty( aTmp[ _CNUMPED ] ), ZooPedCli( aTmp[ _CNUMPED ] ), MsgStop( "El albarán no procede de un pedido" ) ) )

            SEPARATOR

            MENUITEM    "&2. Generar anticipo";
               MESSAGE  "Genera factura de anticipo" ;
               RESOURCE "Document_Money2_16" ;
               ACTION   ( if( !Empty( aTmp[ _CCODCLI ] ),;
                              CreateAntCli( aTmp[ _CCODCLI ] ),;
                              msgStop("Debe seleccionar un cliente para hacer una factura de anticipo" ) ) )

            SEPARATOR

            MENUITEM    "&3. Modificar cliente";
               MESSAGE  "Modifica la ficha del cliente" ;
               RESOURCE "User1_16" ;
               ACTION   ( if( !Empty( aTmp[ _CCODCLI ] ), EdtCli( aTmp[ _CCODCLI ] ), MsgStop( "Código de cliente vacío" ) ) );

            MENUITEM    "&4. Informe de cliente";
               MESSAGE  "Informe de cliente" ;
               RESOURCE "Info16" ;
               ACTION   ( if( !Empty( aTmp[ _CCODCLI ] ), InfCliente( aTmp[ _CCODCLI ] ), MsgStop( "Código de cliente vacío" ) ) );

            MENUITEM    "&5. Modificar obra";
               MESSAGE  "Modifica ficha de la obra" ;
               RESOURCE "Worker16" ;
               ACTION   ( if( !Empty( aTmp[ _CCODOBR ] ), EdtObras( aTmp[ _CCODCLI ], aTmp[ _CCODOBR ], dbfObrasT ), MsgStop( "Código de obra vacío" ) ) );

            SEPARATOR

            MENUITEM    "&6. Informe del documento";
               MESSAGE  "Informe del documento" ;
               RESOURCE "Info16" ;
               ACTION   ( TTrazaDocumento():Activate( ALB_CLI, aTmp[ _CSERALB ] + Str( aTmp[ _NNUMALB ] ) + aTmp[ _CSUFALB ] ) );

         ENDMENU

   ENDMENU

   oDlg:SetMenu( oMenu )

Return ( oMenu )

//---------------------------------------------------------------------------//

static function ValCheck( aGet, aTmp )

   if aTmp[ _LENTREGADO ]
      aGet[ _DFECENV ]:cText( GetSysDate() )
   else
      aGet[ _DFECENV ]:cText( Ctod( "" ) )
   end if

return .t.

//---------------------------------------------------------------------------//

/*
Edita las lineas de Detalle
*/

STATIC FUNCTION EdtDet( aTmp, aGet, dbfAlbCliL, oBrw, lTotLin, cCodArtEnt, nMode, aTmpAlb )

	local oDlg
   local oFld
   local oBtn
	local oGet2
	local cGet2
   local oGet3
   local cGet3
   local oTotal
   local nTotal        := 0
   local oSayPr1
   local oSayPr2
   local cSayPr1       := ""
   local cSayPr2       := ""
   local oSayVp1
   local oSayVp2
   local cSayVp1       := ""
   local cSayVp2       := ""
   local bmpImage
   local oSayAlm
   local cSayAlm
   local oStkAct
   local nStkAct        := 0
   local oBtnSer
   local oSayGrp
   local cSayGrp        := ""
   local oSayFam
   local cSayFam        := ""
   local cCodArt        := Padr( aTmp[ _CREF ], 32 )
   local oRentLin
   local cRentLin       := ""
   local cCodDiv        := aTmpAlb[ _CDIVALB ]
   local oSayDias

   do case
   case nMode == APPD_MODE

      aTmp[_dCSERALB]   := aTmpAlb[_CSERALB]
      aTmp[_dNNUMALB]   := aTmpAlb[_NNUMALB]
      aTmp[_NCANENT ]   := 1
      aTmp[_NUNICAJA]   := 1
      aTmp[_DFECHA  ]   := GetSysDate()
      aTmp[_CTIPMOV ]   := cDefVta()
      aTmp[_LTOTLIN ]   := lTotLin
      aTmp[_LNEWLIN ]   := .t.
      aTmp[_CALMLIN ]   := aTmpAlb[ _CCODALM ]
      aTmp[_LIVALIN ]   := aTmpAlb[ _LIVAINC ]
      aTmp[_dCNUMPED]   := aTmpAlb[ _CNUMPED ]
      aTmp[_NTARLIN ]   := aTmpAlb[ _NTARIFA ]
      aTmp[_LIMPFRA ]   := .t.

      if !Empty( cCodArtEnt )
         cCodArt           := cCodArtEnt
      end if

      aTmp[ __DFECSAL ]    := aTmpAlb[ _DFECSAL ]
      aTmp[ __DFECENT ]    := aTmpAlb[ _DFECENTR ]

      if !Empty( oTipAlb ) .and. oTipAlb:nAt == 2
         aTmp[ __LALQUILER ] := .t.
      else
         aTmp[ __LALQUILER ]:= .f.
      end if

   case nMode == EDIT_MODE

      lTotLin           := aTmp[ _LTOTLIN ]

   end case

   /*
   Este valor los guaradamos para detectar los posibles cambios----------------
   */

   cOldCodArt           := aTmp[ _CREF ]
   cOldPrpArt           := aTmp[ _CCODPR1 ] + aTmp[ _CCODPR2 ] + aTmp[ _CVALPR1 ] + aTmp[ _CVALPR2 ]
   cOldUndMed           := aTmp[ _CUNIDAD ]

   cSayGrp              := RetFld( aTmp[ _CGRPFAM ], oGrpFam:GetAlias() )
   cSayFam              := RetFld( aTmp[ _CCODFAM ], dbfFamilia )

   /*
   Caja de dialogo-------------------------------------------------------------
   */

   DEFINE DIALOG oDlg RESOURCE "LFACCLI" TITLE LblTitle( nMode ) + "líneas a albaranes de clientes"

      if aTmp[ __LALQUILER ]

      REDEFINE FOLDER oFld ;
         ID       400 ;
         OF       oDlg ;
         PROMPT   "&General",    "Da&tos",    "&Observaciones" ;
         DIALOGS  "LPEDCLI_8",   "LALBCLI_2", "LFACCLI_3"

      else

      REDEFINE FOLDER oFld ;
         ID       400 ;
         OF       oDlg ;
         PROMPT   "&General",    "Da&tos",    "&Observaciones" ;
         DIALOGS  "LPEDCLI_1",   "LALBCLI_2", "LFACCLI_3"

      end if

      REDEFINE GET aGet[ _CREF ] VAR cCodArt;
			ID 		100 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         BITMAP   "LUPA" ;
         OF       oFld:aDialogs[1]

      aGet[ _CREF ]:bValid       := {|| LoaArt( cCodArt, aTmp, aGet, aTmpAlb, oStkAct, oSayPr1, oSayPr2, oSayVp1, oSayVp2, bmpImage, nMode ) }
      aGet[ _CREF ]:bHelp        := {|| BrwArticulo( aGet[ _CREF ], aGet[ _CDETALLE ], .f., .t., oBtn, aGet[ _CLOTE ], aTmp[ _CCODPR1 ], aTmp[ _CCODPR2 ], aGet[ _CVALPR1 ], aGet[ _CVALPR2 ], aGet[ _DFECCAD ] ) }
      aGet[ _CREF ]:bLostFocus   := {|| lCalcDeta( aTmp, aTmpAlb, nDouDiv, oTotal, oRentLin, cCodDiv ) }

      REDEFINE GET aGet[ _CDETALLE ] VAR aTmp[ _CDETALLE ] ;
         ID       110 ;
         WHEN     ( ( lModDes() .or. Empty( aTmp[ _CDETALLE ] ) ) .AND. nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[ 1 ]

      REDEFINE GET aGet[ _MLNGDES ] VAR aTmp[ _MLNGDES ] ;
			MEMO ;
			ID 		111 ;
         WHEN     ( ( lModDes() .or. Empty( aTmp[ _MLNGDES ] ) ) .AND. nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

      /*
      Lotes
      -------------------------------------------------------------------------
      */

      REDEFINE GET aGet[ _CLOTE ] VAR aTmp[ _CLOTE ];
         ID       112 ;
         IDSAY    113 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

         aGet[ _CLOTE ]:bValid   := {|| lValidLote( aTmp, aGet, oStkAct ) }

      if !aTmp[ __LALQUILER ]

      REDEFINE GET aGet[ _DFECCAD ] VAR aTmp[ _DFECCAD ];
         ID       340 ;
         IDSAY    341 ;
			SPINNER ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

      end if

      /*
      Propiedades
      -------------------------------------------------------------------------
      */

      if !aTmp[ __LALQUILER ]

      REDEFINE GET aGet[ _CVALPR1 ] VAR aTmp[_CVALPR1];
         ID       270 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
			COLOR 	CLR_GET ;
         BITMAP   "LUPA" ;
         VALID    ( if( lPrpAct( aTmp[ _CVALPR1 ], oSayVp1, aTmp[ _CCODPR1 ], dbfTblPro ),;
                        LoaArt( cCodArt, aTmp, aGet, aTmpAlb, oStkAct, oSayPr1, oSayPr2, oSayVp1, oSayVp2, bmpImage, nMode, .f. ),;
                        .f. ) );
         ON HELP  ( brwPrpAct( aGet[_CVALPR1], oSayVp1, aTmp[_CCODPR1 ] ) ) ;
         OF       oFld:aDialogs[1]

         aGet[ _CVALPR1 ]:bChange      := {|| aGet[ _CVALPR1 ]:Assign(), if( !uFieldEmpresa( "lNStkAct" ), oStock:nPutStockActual( aTmp[ _CREF ], aTmp[ _CALMLIN ], aTmp[ _CVALPR1 ], aTmp[ _CVALPR2 ], aTmp[ _CLOTE ], aTmp[ _LKITART ], aTmp[ _NCTLSTK ], oStkAct ), .t. ) }
         aGet[ _CVALPR1 ]:bLostFocus   := {|| lCalcDeta( aTmp, aTmpAlb, nDouDiv, oTotal, oRentLin, cCodDiv ) }

      REDEFINE SAY oSayPr1 VAR cSayPr1;
         ID       271 ;
         OF       oFld:aDialogs[1]

      REDEFINE GET oSayVp1 VAR cSayVp1;
         ID       272 ;
         WHEN     .f. ;
         COLOR    CLR_GET ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[_CVALPR2] VAR aTmp[_CVALPR2];
         ID       280 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
			COLOR 	CLR_GET ;
         BITMAP   "LUPA" ;
         VALID    ( if( lPrpAct( aTmp[ _CVALPR2 ], oSayVp2, aTmp[ _CCODPR2 ], dbfTblPro ),;
                        LoaArt( cCodArt, aTmp, aGet, aTmpAlb, oStkAct, oSayPr1, oSayPr2, oSayVp1, oSayVp2, bmpImage, nMode, .f. ),;
                        .f. ) );
         ON HELP  ( brwPrpAct( aGet[_CVALPR2], oSayVp2, aTmp[_CCODPR2 ] ) ) ;
         OF       oFld:aDialogs[1]

         aGet[ _CVALPR2 ]:bChange      := {|| aGet[ _CVALPR2 ]:Assign(), if( !uFieldEmpresa( "lNStkAct" ), oStock:nPutStockActual( aTmp[ _CREF ], aTmp[ _CALMLIN ], aTmp[ _CVALPR1 ], aTmp[ _CVALPR2 ], aTmp[ _CLOTE ], aTmp[ _LKITART ], aTmp[ _NCTLSTK ], oStkAct ), .t. ) }
         aGet[ _CVALPR2 ]:bLostFocus   := {|| lCalcDeta( aTmp, aTmpAlb, nDouDiv, oTotal, oRentLin, cCodDiv ) }

      REDEFINE SAY oSayPr2 VAR cSayPr2;
         ID       281 ;
         OF       oFld:aDialogs[1]

      REDEFINE GET oSayVp2 VAR cSayVp2;
         ID       282 ;
         WHEN     .f. ;
         COLOR    CLR_GET ;
         OF       oFld:aDialogs[1]

      end if

      /*
      fin de propiedades
      -------------------------------------------------------------------------
      */

      REDEFINE GET aGet[ _NIVA ] VAR aTmp[ _NIVA ] ;
			ID 		120 ;
         PICTURE  "@E 99.99" ;
         WHEN     ( !aTmp[ _LCONTROL ] .AND. lModIva() .and. nMode != ZOOM_MODE ) ;
         VALID    ( lTiva( dbfIva, aTmp[ _NIVA ], @aTmp[ _NREQ ] ) );
         ON CHANGE( lCalcDeta( aTmp, aTmpAlb, nDouDiv, oTotal, oRentLin, cCodDiv ) );
         BITMAP   "LUPA" ;
         ON HELP  ( BrwIva( aGet[ _NIVA ], dbfIva, , .t. ) ) ;
         OF       oFld:aDialogs[1]

      if aTmp[ __LALQUILER ]

      REDEFINE GET aGet[ __DFECSAL ] VAR aTmp[ __DFECSAL ];
         ID       420 ;
			SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( lCalcDeta( aTmp, aTmpAlb, nDouDiv, oTotal, oRentLin, cCodDiv ) );
         ON CHANGE( lCalcDeta( aTmp, aTmpAlb, nDouDiv, oTotal, oRentLin, cCodDiv ), oSayDias:Refresh() );
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ __DFECENT ] VAR aTmp[ __DFECENT ];
         ID       430 ;
			SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( lCalcDeta( aTmp, aTmpAlb, nDouDiv, oTotal, oRentLin, cCodDiv ) );
         ON CHANGE( lCalcDeta( aTmp, aTmpAlb, nDouDiv, oTotal, oRentLin, cCodDiv ), oSayDias:Refresh() );
         OF       oFld:aDialogs[1]

      REDEFINE SAY oSayDias ;
         VAR      ( aTmp[ __DFECENT ] - aTmp[ __DFECSAL ] );
         PICTURE  "9999";
         ID       440;
         OF       oFld:aDialogs[1]

      else

      REDEFINE GET aGet[ _NVALIMP ] VAR aTmp[ _NVALIMP ] ;
         ID       125 ;
         IDSAY    126 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  cPouDiv ;
         COLOR    CLR_GET ;
         ON CHANGE( lCalcDeta( aTmp, aTmpAlb, nDouDiv, oTotal, oRentLin, cCodDiv ) );
         ON HELP  ( oNewImp:nBrwImp( aGet[ _NVALIMP ] ) );
         OF       oFld:aDialogs[1]

      end if

		REDEFINE GET aGet[_NCANENT] VAR aTmp[_NCANENT];
			ID 		130;
			SPINNER ;
         WHEN     ( !aTmp[_LCONTROL] .AND. lUseCaj() .AND. nMode != ZOOM_MODE ) ;
			PICTURE 	cPicUnd ;
         ON CHANGE( lCalcDeta( aTmp, aTmpAlb, nDouDiv, oTotal, oRentLin, cCodDiv ), LoaArt( cCodArt, aTmp, aGet, aTmpAlb, oStkAct, oSayPr1, oSayPr2, oSayVp1, oSayVp2, bmpImage, nMode, .f. ) );
         VALID    ( lCalcDeta( aTmp, aTmpAlb, nDouDiv, oTotal, oRentLin, cCodDiv ), LoaArt( cCodArt, aTmp, aGet, aTmpAlb, oStkAct, oSayPr1, oSayPr2, oSayVp1, oSayVp2, bmpImage, nMode, .f. ) );
         OF       oFld:aDialogs[1] ;
         IDSAY    131

		REDEFINE GET aGet[_NUNICAJA] VAR aTmp[_NUNICAJA] ;
			ID 		140;
			SPINNER ;
         WHEN     ( !aTmp[_LCONTROL] .AND. nMode != ZOOM_MODE ) ;
         ON CHANGE( lCalcDeta( aTmp, aTmpAlb, nDouDiv, oTotal, oRentLin, cCodDiv ), LoaArt( cCodArt, aTmp, aGet, aTmpAlb, oStkAct, oSayPr1, oSayPr2, oSayVp1, oSayVp2, bmpImage, nMode, .f. ) );
         VALID    ( lCalcDeta( aTmp, aTmpAlb, nDouDiv, oTotal, oRentLin, cCodDiv ), LoaArt( cCodArt, aTmp, aGet, aTmpAlb, oStkAct, oSayPr1, oSayPr2, oSayVp1, oSayVp2, bmpImage, nMode, .f. ) );
			PICTURE 	cPicUnd ;
         OF       oFld:aDialogs[1] ;
         IDSAY    141

      REDEFINE GET aGet[ _NFACCNV ] VAR aTmp[ _NFACCNV ] ;
         ID       295 ;
         WHEN     ( !aTmp[_LCONTROL] .AND. nMode != ZOOM_MODE ) ;
         PICTURE  "@E 999,999.999999";
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _NSATUNIT ] VAR aTmp[ _NSATUNIT ];
         ID       150 ;
         SPINNER ;
         WHEN     ( !aTmp[_LCONTROL] .AND. nMode != ZOOM_MODE .AND. !lTotLin) ;
         ON CHANGE( lCalcDeta( aTmp, aTmpAlb, nDouDiv, oTotal, oRentLin, cCodDiv ) );
         VALID    ( lCalcDeta( aTmp, aTmpAlb, nDouDiv, oTotal, oRentLin, cCodDiv ) );
         PICTURE  cPouDiv;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _NTARLIN ] VAR aTmp[ _NTARLIN ];
         ID       156 ;
         SPINNER ;
         MIN      1 ;
         MAX      6 ;
         PICTURE  "9" ;
         VALID    ( aTmp[ _NTARLIN ] >= 1 .AND. aTmp[ _NTARLIN ] <= 6 );
         WHEN     ( nMode != ZOOM_MODE .and. ( lUsrMaster() .or. oUser():lCambiarPrecio() ) );
         ON CHANGE( ChangeTarifa( aTmp, aGet, aTmpAlb ), lCalcDeta( aTmp, aTmpAlb, nDouDiv, oTotal, oRentLin, cCodDiv ) );
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CUNIDAD ] VAR aTmp[ _CUNIDAD ] ;
         ID       170 ;
         IDTEXT   171 ;
         BITMAP   "LUPA" ;
         VALID    ( oUndMedicion:Existe( aGet[ _CUNIDAD ], aGet[ _CUNIDAD ]:oHelpText, "cNombre" ), ValidaMedicion( aTmp, aGet ) );
         ON HELP  ( oUndMedicion:Buscar( aGet[ _CUNIDAD ] ), ValidaMedicion( aTmp, aGet ) ) ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

      // Campos de las descripciones de la unidad de medición

      REDEFINE GET aGet[ ( dbfAlbCliL )->( fieldpos( "nMedUno" ) ) ] ;
         VAR      aTmp[ ( dbfAlbCliL )->( fieldpos( "nMedUno" ) ) ] ;
         ID       520 ;
         IDSAY    521 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ON CHANGE( lCalcDeta( aTmp, aTmpAlb, nDouDiv, oTotal, oRentLin, cCodDiv ) );
         PICTURE  MasUnd() ;
         OF       oFld:aDialogs[1]

         aGet[ ( dbfAlbCliL )->( fieldpos( "nMedUno" ) ) ]:oSay:SetColor( CLR_BLUE )


      REDEFINE GET aGet[ ( dbfAlbCliL )->( fieldpos( "nMedDos" ) ) ] ;
         VAR      aTmp[ ( dbfAlbCliL )->( fieldpos( "nMedDos" ) ) ] ;
         ID       530 ;
         IDSAY    531 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ON CHANGE( lCalcDeta( aTmp, aTmpAlb, nDouDiv, oTotal, oRentLin, cCodDiv ) );
         PICTURE  MasUnd() ;
         OF       oFld:aDialogs[1]

         aGet[ ( dbfAlbCliL )->( fieldpos( "nMedDos" ) ) ]:oSay:SetColor( CLR_BLUE )


      REDEFINE GET aGet[ ( dbfAlbCliL )->( fieldpos( "nMedTre" ) ) ] ;
         VAR      aTmp[ ( dbfAlbCliL )->( fieldpos( "nMedTre" ) ) ] ;
         ID       540 ;
         IDSAY    541 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ON CHANGE( lCalcDeta( aTmp, aTmpAlb, nDouDiv, oTotal, oRentLin, cCodDiv ) );
         PICTURE  MasUnd() ;
         OF       oFld:aDialogs[1]

         aGet[ ( dbfAlbCliL )->( fieldpos( "nMedTre" ) ) ]:oSay:SetColor( CLR_BLUE )

      if aTmp[ __LALQUILER ]

         REDEFINE GET aGet[ _NSATALQ ] VAR aTmp[ _NSATALQ ] ;
            ID       250 ;
            SPINNER ;
            WHEN     ( nMode != ZOOM_MODE .and. !lTotLin ) ;
            ON CHANGE( lCalcDeta( aTmp, aTmpAlb, nDouDiv, oTotal, oRentLin, cCodDiv ) );
            VALID    ( lCalcDeta( aTmp, aTmpAlb, nDouDiv, oTotal, oRentLin, cCodDiv ) );
            COLOR    CLR_GET ;
            PICTURE  cPouDiv ;
            OF       oFld:aDialogs[1]

      end if

      REDEFINE GET aGet[ _NIMPTRN ] VAR aTmp[ _NIMPTRN ] ;
         ID       350 ;
         IDSAY    351 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE .AND. !lTotLin ) ;
         ON CHANGE( lCalcDeta( aTmp, aTmpAlb, nDouDiv, oTotal, oRentLin, cCodDiv ) );
         VALID    ( lCalcDeta( aTmp, aTmpAlb, nDouDiv, oTotal, oRentLin, cCodDiv ) );
         PICTURE  cPouDiv ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _NPNTVER ] VAR aTmp[ _NPNTVER ] ;
         ID       151 ;
         IDSAY    152 ;
         SPINNER ;
         PICTURE  cPpvDiv ;
         WHEN     ( !aTmp[_LCONTROL] .AND. nMode != ZOOM_MODE .AND. !lTotLin) ;
         VALID    ( lCalcDeta( aTmp, aTmpAlb, nDouDiv, oTotal, oRentLin, cCodDiv ) );
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _NPESOKG ] VAR aTmp[ _NPESOKG ] ;
         ID       160 ;
         WHEN     ( !aTmp[_LCONTROL] .AND. nMode != ZOOM_MODE .AND. !lTotLin) ;
         PICTURE  "@E 999,999.999999";
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CPESOKG ] VAR aTmp[ _CPESOKG ] ;
         ID       175 ;
         WHEN     ( !aTmp[_LCONTROL] .AND. nMode != ZOOM_MODE .AND. !lTotLin ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _NVOLUMEN ] VAR aTmp[ _NVOLUMEN ] ;
         ID       400 ;
         WHEN     ( !aTmp[_LCONTROL] .AND. nMode != ZOOM_MODE .AND. !lTotLin) ;
         PICTURE  "@E 999,999.999999";
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CVOLUMEN ] VAR aTmp[ _CVOLUMEN ] ;
         ID       410;
         WHEN     ( !aTmp[_LCONTROL] .AND. nMode != ZOOM_MODE .AND. !lTotLin ) ;
			COLOR 	CLR_GET ;
         OF       oFld:aDialogs[1]

		REDEFINE GET aGet[_NDTO] VAR aTmp[_NDTO] ;
         ID       180 ;
			SPINNER ;
         WHEN     ( !aTmp[_LCONTROL] .AND. nMode != ZOOM_MODE .AND. !lTotLin ) ;
			COLOR 	CLR_GET ;
         PICTURE  "@E 999.99";
         ON CHANGE( lCalcDeta( aTmp, aTmpAlb, nDouDiv, oTotal, oRentLin, cCodDiv ) );
         OF       oFld:aDialogs[1]

		REDEFINE GET aGet[_NDTOPRM] VAR aTmp[_NDTOPRM] ;
         ID       190 ;
			SPINNER ;
         WHEN     ( !aTmp[_LCONTROL] .AND. nMode != ZOOM_MODE .AND. !lTotLin ) ;
			COLOR 	CLR_GET ;
         PICTURE  "@E 999.99";
         ON CHANGE( lCalcDeta( aTmp, aTmpAlb, nDouDiv, oTotal, oRentLin, cCodDiv ) );
         OF       oFld:aDialogs[1]

		REDEFINE GET aGet[_NCOMAGE] VAR aTmp[_NCOMAGE] ;
         ID       200 ;
			SPINNER ;
         WHEN     ( !aTmp[_LCONTROL] .AND. nMode != ZOOM_MODE .AND. !lTotLin ) ;
			COLOR 	CLR_GET ;
         PICTURE  "@E 999.99";
         OF       oFld:aDialogs[1]

      if !aTmp[ __LALQUILER ]

      REDEFINE GET oComisionLinea VAR nComisionLinea ;
         ID       201 ;
         WHEN     ( .f. ) ;
         PICTURE  cPorDiv ;
         OF       oFld:aDialogs[ 1 ]

      end if

      REDEFINE GET aGet[_NDTODIV] VAR aTmp[_NDTODIV] ;
         ID       260 ;
         IDSAY    261 ;
			SPINNER ;
         MIN      0 ;
         COLOR    Rgb( 255, 0, 0 ) ;
         ON CHANGE( lCalcDeta( aTmp, aTmpAlb, nDouDiv, oTotal, oRentLin, cCodDiv ) );
         VALID    ( !aTmp[_LCONTROL] .AND. aTmp[_NDTODIV] >= 0 ) ;
         WHEN     ( nMode != ZOOM_MODE .AND. !lTotLin ) ;
         PICTURE  cPouDiv ;
         OF       oFld:aDialogs[1]

      /*
      Tipo de moviminto
      -------------------------------------------------------------------------
      */

      REDEFINE GET aGet[ _CTIPMOV ] VAR aTmp[ _CTIPMOV ] ;
         WHEN     ( !aTmp[ _LCONTROL ] .AND. nMode != ZOOM_MODE .AND. !lTotLin ) ;
         VALID    ( cTVta( aGet[ _CTIPMOV ], dbfTVta, oGet2 ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwTVta( aGet[ _CTIPMOV ], dbfTVta, oGet2 ) ) ;
         ID       290 ;
         OF       oFld:aDialogs[1] ;
         IDSAY    292

		REDEFINE GET oGet2 VAR cGet2 ;
         ID       291 ;
			WHEN 		( .F. ) ;
			COLOR 	CLR_GET ;
         OF       oFld:aDialogs[1]

      /*
      Tipo de articulo---------------------------------------------------------
      */

      REDEFINE GET aGet[ _CCODTIP ] VAR aTmp[ _CCODTIP ] ;
         WHEN     ( nMode != ZOOM_MODE .and. nMode != MULT_MODE .and. !lTotLin ) ;
         VALID    ( oTipArt:lValid( aGet[ _CCODTIP ], oGet3 ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( oTipArt:Buscar( aGet[ _CCODTIP ] ) ) ;
         ID       205 ;
         OF       oFld:aDialogs[1]

      REDEFINE GET oGet3 VAR cGet3 ;
         ID       206 ;
			WHEN 		( .F. ) ;
			COLOR 	CLR_GET ;
         OF       oFld:aDialogs[1]

      /*
      Codigo de almacen--------------------------------------------------------
      */

      REDEFINE GET aGet[ _CALMLIN ] VAR aTmp[ _CALMLIN ] ;
         ID       300 ;
         WHEN     ( !aTmp[ _LCONTROL ] .AND. nMode != ZOOM_MODE ) ;
         VALID    ( cNomUbica( aTmp, aGet, dbfAlm ), cAlmacen( aGet[ _CALMLIN ], , oSayAlm ), if( !uFieldEmpresa( "lNStkAct" ), oStock:lPutStockActual( aTmp[ _CREF ], aTmp[ _CALMLIN ], aTmp[ _CVALPR1 ], aTmp[ _CVALPR2 ], aTmp[ _CLOTE ], aTmp[ _LKITART ], aTmp[ _NCTLSTK ], oStkAct ), .t. ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwAlmacen( aGet[ _CALMLIN ], oSayAlm ) ) ;
			COLOR 	CLR_GET ;
         OF       oFld:aDialogs[1]

      REDEFINE GET oSayAlm VAR cSayAlm ;
         WHEN     .f. ;
         ID       301 ;
         OF       oFld:aDialogs[1]

      REDEFINE SAY aGet[_CCODUBI1] VAR aTmp[_CCODUBI1];
         ID       612 ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[_CVALUBI1] VAR aTmp[_CVALUBI1] ;
         ID       610 ;
         BITMAP   "LUPA" ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ON HELP  ( BrwUbiLin( aGet[_CVALUBI1], aGet[_CNOMUBI1], aTmp[_CCODUBI1], dbfUbicaL ) ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[_CNOMUBI1] VAR aTmp[_CNOMUBI1];
         WHEN     .F. ;
         ID       611 ;
         OF       oFld:aDialogs[1]

      REDEFINE SAY aGet[_CCODUBI2] VAR aTmp[_CCODUBI2];
         ID       622 ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[_CVALUBI2] VAR aTmp[_CVALUBI2] ;
         ID       620 ;
         BITMAP   "LUPA" ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ON HELP  ( BrwUbiLin( aGet[_CVALUBI2], aGet[_CNOMUBI2], aTmp[_CCODUBI2], dbfUbicaL ) ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[_CNOMUBI2] VAR aTmp[_CNOMUBI2];
         WHEN     .F. ;
         ID       621 ;
         OF       oFld:aDialogs[1]

      REDEFINE SAY aGet[_CCODUBI3] VAR aTmp[_CCODUBI3];
         ID       632 ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[_CVALUBI3] VAR aTmp[_CVALUBI3] ;
         ID       630 ;
         BITMAP   "LUPA" ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ON HELP  ( BrwUbiLin( aGet[_CVALUBI3], aGet[_CNOMUBI3], aTmp[_CCODUBI3], dbfUbicaL ) ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[_CNOMUBI3] VAR aTmp[_CNOMUBI3];
         WHEN     .F. ;
         ID       631 ;
         OF       oFld:aDialogs[1]

      REDEFINE GET oStkAct VAR nStkAct ;
         ID       310 ;
         WHEN     .f. ;
         PICTURE  cPicUnd ;
         OF       oFld:aDialogs[1]

		REDEFINE GET oTotal VAR nTotal ;
         ID       220 ;
         PICTURE  cPorDiv ;
         WHEN     .f. ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[_NCOSDIV] VAR aTmp[_NCOSDIV] ;
         ID       320 ;
         IDSAY    321 ;
         WHEN     ( oUser():lAdministrador() .and. nMode != ZOOM_MODE );
         PICTURE  cPouDiv ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[_NMESGRT] VAR aTmp[_NMESGRT] ;
         ID       330 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  "99" ;
         OF       oFld:aDialogs[1]

      /*
      Segunda caja de dialogo -------------------------------------------------
      */

      REDEFINE GET aGet[ _NNUMLIN ] VAR aTmp[ _NNUMLIN ] ;
         ID       100 ;
         SPINNER ;
         WHEN     ( .f. ) ; // !aTmp[ _LCONTROL ] .AND. nMode == APPD_MODE ) ;
         PICTURE  "9999" ;
         OF       oFld:aDialogs[2]

      REDEFINE CHECKBOX aGet[_LIMPLIN] VAR aTmp[_LIMPLIN] ;
         ID       110 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[_DFECHA] VAR aTmp[_DFECHA] ;
         ID       120 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[2]

      REDEFINE CHECKBOX aGet[_LCONTROL] VAR aTmp[_LCONTROL]  ;
         ID       130 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[_NPVSATC] VAR aTmp[_NPVSATC] ;
         ID       140 ;
			COLOR 	CLR_GET ;
         WHEN     ( .f. ) ;
         PICTURE  cPouDiv ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ _CIMAGEN ] ;
         VAR      aTmp[ _CIMAGEN ] ;
         BITMAP   "LUPA" ;
         ON HELP  ( GetBmp( aGet[ _CIMAGEN ], bmpImage ) ) ;
         ON CHANGE( ChgBmp( aGet[ _CIMAGEN ], bmpImage ) ) ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ID       220 ;
         OF       oFld:aDialogs[ 2 ]

      /*
      Definición de familias y grupos de familias------------------------------
      */

      REDEFINE GET aGet[ _CGRPFAM ] VAR aTmp[ _CGRPFAM ] ;
         ID       ( 150 );
         WHEN     ( nMode != ZOOM_MODE );
         BITMAP   "LUPA" ;
         VALID    ( oSayGrp:cText( RetFld( aTmp[ _CGRPFAM  ], oGrpFam:GetAlias() ) ), .t. ) ;
         ON HELP  ( oGrpFam:Buscar( aGet[ _CGRPFAM ] ) ) ;
         OF       oFld:aDialogs[ 2 ]

      REDEFINE GET oSayGrp VAR cSayGrp ;
         ID       ( 151 );
         WHEN     .f.;
         OF       oFld:aDialogs[ 2 ]

      /*
      Definición de frases publicitarias---------------------------------------
      */

      REDEFINE GET aGet[ _CCODFAM ] VAR aTmp[ _CCODFAM ] ;
			ID 		160 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         BITMAP   "LUPA" ;
         VALID    ( oSayFam:cText( RetFld( aTmp[ _CCODFAM  ], dbfFamilia ) ), .t. );
         ON HELP  ( BrwFamilia( aGet[ _CCODFAM ], oSayFam ) );
         OF       oFld:aDialogs[2]

      REDEFINE GET oSayFam VAR cSayFam ;
			WHEN 		( .F. );
			ID 		161 ;
         OF       oFld:aDialogs[2]

      REDEFINE CHECKBOX aGet[ _LIMPFRA ] VAR aTmp[ _LIMPFRA ]  ;
         ID       310 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[ 2 ]

      REDEFINE GET aGet[ _CCODFRA ] VAR aTmp[ _CCODFRA ] ;
         ID       320 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         BITMAP   "LUPA" ;
         OF       oFld:aDialogs[ 2 ]

         aGet[ _CCODFRA ]:bValid := {|| oFraPub:lValid( aGet[ _CCODFRA ], aGet[ _CTXTFRA ] ) }
         aGet[ _CCODFRA ]:bHelp  := {|| oFraPub:Buscar( aGet[ _CCODFRA ] ) }

      REDEFINE GET aGet[ _CTXTFRA ] VAR aTmp[ _CTXTFRA ] ;
         ID       321 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[ 2 ]

      REDEFINE GET oRentLin VAR cRentLin ;
         ID       300 ;
         IDSAY    301 ;
         OF       oFld:aDialogs[2]

      REDEFINE CHECKBOX aGet[ _LKITCHL ] VAR aTmp[ _LKITCHL ]  ;
         ID       330 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[ 2 ]

      REDEFINE CHECKBOX aGet[ _LKITPRC ] VAR aTmp[ _LKITPRC ]  ;
         ID       340 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[ 2 ]

      REDEFINE RADIO aGet[ _NCTLSTK ] VAR aTmp[ _NCTLSTK ] ;
         ID       350, 351, 352 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[ 2 ]

      REDEFINE GET aGet[ _MOBSLIN ] VAR aTmp[ _MOBSLIN ] ;
         MEMO ;
         ID       100 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[ 3 ]

      REDEFINE GET aGet[ _DESCRIP ] VAR aTmp[ _DESCRIP ] ;
         MEMO ;
         ID       110 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[ 3 ]

      REDEFINE BITMAP bmpImage ;
         ID       220 ;
         FILE     ( cFileBitmap( cPatImg(), aTmp[ _CIMAGEN ] ) );
         ON RIGHT CLICK ( bmpImage:lStretch := !bmpImage:lStretch, bmpImage:Refresh() );
         OF       oDlg

         bmpImage:SetColor( , GetSysColor( 15 ) )

      REDEFINE BUTTON oBtn ;
         ID       IDOK ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   SaveDeta( aTmp, aTmpAlb, oFld, aGet, oBrw, bmpImage, oDlg, nMode, oSayPr1, oSayPr2, oSayVp1, oSayVp2, oGet2, oStkAct, nStkAct, oTotal, cCodArt, oBtn, oBtnSer )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
         CANCEL ;
			ACTION 	( oDlg:end() )

      REDEFINE BUTTON ;
         ID       9 ;
			OF 		oDlg ;
         ACTION   ( ChmHelp( "Añadir_v" ) )

      REDEFINE BUTTON oBtnSer;
         ID       552 ;
			OF 		oDlg ;
         ACTION   ( EditarNumeroSerie( aTmp, oStock, nMode ) )

   if nMode != ZOOM_MODE
      oDlg:AddFastKey( VK_F5, {|| SaveDeta( aTmp, aTmpAlb, oFld, aGet, oBrw, bmpImage, oDlg, nMode, oSayPr1, oSayPr2, oSayVp1, oSayVp2, oGet2, oStkAct, nStkAct, oTotal, cCodArt, oBtn, oBtnSer ) } )
   end if

   oDlg:AddFastKey( VK_F6, {|| oBtnSer:Click() } )

   oDlg:bStart    := {||   SetDlgMode( aTmp, aGet, oFld, nMode, oSayPr1, oSayPr2, oSayVp1, oSayVp2, oStkAct, oGet2, oTotal, aTmpAlb, oRentLin ),;
                           if( !Empty( cCodArtEnt ), aGet[ _CREF ]:lValid(), ),;
                           aGet[ _CUNIDAD ]:lValid(),;
                           lCalcDeta( aTmp, aTmpAlb, nDouDiv, oTotal, oRentLin, cCodDiv ) }

   ACTIVATE DIALOG oDlg  ;
      ON INIT     ( EdtDetMenu( aGet[ _CREF ], oDlg ) );
      CENTER

   EndDetMenu()

RETURN ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

Static Function EdtInc( aTmp, aGet, dbfAlbCliI, oBrw, bWhen, bValid, nMode, aTmpAlb )

   local oDlg
   local oNomInci
   local cNomInci       := RetFld( aTmp[ ( dbfTmpInc )->( FieldPos( "cCodTip" ) ) ], dbfInci )
   local oTitulo
   local cTitulo        := LblTitle( nMode ) + " incidencia"


   if nMode == APPD_MODE
      aTmp[ _CSERALB  ] := aTmpAlb[ _CSERALB ]
      aTmp[ _NNUMALB  ] := aTmpAlb[ _NNUMALB ]
      aTmp[ _CSUFALB  ] := aTmpAlb[ _CSUFALB ]

      if IsMuebles()
         aTmp[ ( dbfTmpInc )->( FieldPos( "lAviso" ) ) ]  := .t.
      end if
   end if

   if ( "PDA" $ cParamsMain() )
      DEFINE DIALOG oDlg RESOURCE "ALBCLI_INC_PDA"
   else
      DEFINE DIALOG oDlg RESOURCE "INCIDENCIA" TITLE LblTitle( nMode ) + "incidencias de albaranes a clientes"
   end if

      REDEFINE GET aGet[ ( dbfTmpInc )->( FieldPos( "cCodTip" ) ) ];
         VAR      aTmp[ ( dbfTmpInc )->( FieldPos( "cCodTip" ) ) ];
         ID       120 ;
         WHEN     ( nMode != ZOOM_MODE );
         VALID    ( cTipInci( aGet[ ( dbfTmpInc )->( FieldPos( "cCodTip" ) ) ], dbfInci, oNomInci ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwIncidencia( dbfInci, aGet[ ( dbfTmpInc )->( FieldPos( "cCodTip" ) ) ], oNomInci ) ) ;
         OF       oDlg

      REDEFINE GET oNomInci VAR cNomInci;
         ID       130 ;
         WHEN     .f. ;
         OF       oDlg

      REDEFINE GET aTmp[ ( dbfTmpInc )->( FieldPos( "dFecInc" ) ) ] ;
         ID       100 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE CHECKBOX aTmp[ ( dbfTmpInc )->( FieldPos( "lAviso" ) ) ] ;
         ID       150 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET aTmp[ ( dbfTmpInc )->( FieldPos( "mDesInc" ) ) ] ;
         MEMO ;
         ID       110 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE CHECKBOX aTmp[ ( dbfTmpInc )->( FieldPos( "lListo" ) ) ] ;
         ID       140 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         OF       oDlg

      if ( "PDA" $ cParamsMain() )

         REDEFINE SAY oTitulo VAR cTitulo;
               ID       1000 ;
               OF       oDlg

      end if

      REDEFINE BUTTON ;
         ID       IDOK ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( WinGather( aTmp, nil, dbfTmpInc, oBrw, nMode ), oDlg:end( IDOK ) )

      REDEFINE BUTTON ;
         ID       IDCANCEL ;
         OF       oDlg ;
         CANCEL ;
         ACTION   ( oDlg:end() )

   if nMode != ZOOM_MODE
      oDlg:AddFastKey( VK_F5, {|| WinGather( aTmp, nil, dbfTmpInc, oBrw, nMode ), oDlg:end( IDOK ) } )
   end if

   ACTIVATE DIALOG oDlg CENTER

Return ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

Static Function EdtDoc( aTmp, aGet, dbfAlbCliD, oBrw, bWhen, bValid, nMode, aTmpLin )

   local oDlg
   local oRuta
   local oNombre
   local oObservacion

   DEFINE DIALOG oDlg RESOURCE "DOCUMENTOS" TITLE LblTitle( nMode ) + "documento de albaranes de clientes"

      REDEFINE GET oNombre VAR aTmp[ ( dbfTmpDoc )->( FieldPos( "cNombre" ) ) ] ;
         ID       120 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET oRuta VAR aTmp[ ( dbfTmpDoc )->( FieldPos( "cRuta" ) ) ] ;
         ID       100 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         BITMAP   "FOLDER" ;
         ON HELP  ( oRuta:cText( cGetFile( 'Doc ( *.* ) | *.*', 'Seleccione el nombre del fichero' ) ) ) ;
         OF       oDlg

      REDEFINE GET oObservacion VAR aTmp[ ( dbfTmpDoc )->( FieldPos( "mObsDoc" ) ) ] ;
         MEMO ;
         ID       110 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE BUTTON ;
         ID       IDOK ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( WinGather( aTmp, nil, dbfTmpDoc, oBrw, nMode ), oDlg:end( IDOK ) )

      REDEFINE BUTTON ;
         ID       IDCANCEL ;
         OF       oDlg ;
         CANCEL ;
         ACTION   ( oDlg:end() )

      if nMode != ZOOM_MODE
         oDlg:AddFastKey( VK_F5, {|| WinGather( aTmp, nil, dbfTmpDoc, oBrw, nMode ), oDlg:end( IDOK ) } )
      end if

   ACTIVATE DIALOG oDlg CENTER

Return ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

STATIC FUNCTION PrnSerie()

	local oDlg
   local oFmtDoc
   local cFmtDoc     := cFormatoDocumento( ( dbfAlbCliT )->cSerAlb, "nAlbCli", dbfCount )
   local oSayFmt
   local cSayFmt
   local oSerIni
   local oSerFin
   local nRecno      := (dbfAlbCliT)->( Recno() )
   local nOrdAnt     := (dbfAlbCliT)->( OrdSetFocus( 1 ) )
   local cSerIni     := (dbfAlbCliT)->cSerAlb
   local cSerFin     := (dbfAlbCliT)->cSerAlb
   local nDocIni     := (dbfAlbCliT)->nNumAlb
   local nDocFin     := (dbfAlbCliT)->nNumAlb
   local cSufIni     := (dbfAlbCliT)->cSufAlb
   local cSufFin     := (dbfAlbCliT)->cSufAlb
   local oPrinter
   local cPrinter    := PrnGetName()
   local lCopiasPre  := .t.
   local lInvOrden   := .f.
   local oNumCop
   local nNumCop     := if( nCopiasDocumento( ( dbfAlbCliT )->cSerAlb, "nAlbCli", dbfCount ) == 0, Max( Retfld( ( dbfAlbCliT )->cCodCli, dbfClient, "CopiasF" ), 1 ), nCopiasDocumento( ( dbfAlbCliT )->cSerAlb, "nAlbCli", dbfCount ) )

   if Empty( cFmtDoc )
      cFmtDoc        := cSelPrimerDoc( "AC" )
   end if

   cSayFmt           := cNombreDoc( cFmtDoc )

   DEFINE DIALOG oDlg RESOURCE "IMPSERDOC" TITLE "Imprimir series de albaranes"

   REDEFINE GET oSerIni VAR cSerIni ;
      ID       100 ;
      PICTURE  "@!" ;
      UPDATE ;
      SPINNER ;
      ON UP    ( UpSerie( oSerIni ) );
      ON DOWN  ( DwSerie( oSerIni ) );
      VALID    ( cSerIni >= "A" .AND. cSerIni <= "Z"  );
      OF       oDlg

   REDEFINE GET oSerFin VAR cSerFin ;
      ID       110 ;
      PICTURE  "@!" ;
      UPDATE ;
      SPINNER ;
      ON UP    ( UpSerie( oSerFin ) );
      ON DOWN  ( DwSerie( oSerFin ) );
      VALID    ( cSerFin >= "A" .AND. cSerFin <= "Z"  );
      OF       oDlg

   REDEFINE GET nDocIni;
      ID       120 ;
		PICTURE 	"999999999" ;
      SPINNER ;
      OF       oDlg

   REDEFINE GET nDocFin;
      ID       130 ;
		PICTURE 	"999999999" ;
      SPINNER ;
      OF       oDlg

   REDEFINE GET cSufIni ;
      ID       140 ;
      PICTURE  "##" ;
      OF       oDlg

   REDEFINE GET cSufFin ;
      ID       150 ;
      PICTURE  "##" ;
      OF       oDlg

   REDEFINE CHECKBOX lInvOrden ;
      ID       500 ;
      OF       oDlg

   REDEFINE CHECKBOX lCopiasPre ;
      ID       170 ;
      OF       oDlg

   REDEFINE GET oNumCop VAR nNumCop;
      ID       180 ;
      WHEN     !lCopiasPre ;
      VALID    nNumCop > 0 ;
		PICTURE 	"999999999" ;
      SPINNER ;
      MIN      1 ;
      MAX      99999 ;
      OF       oDlg

   REDEFINE GET oFmtDoc VAR cFmtDoc ;
      ID       90 ;
      COLOR    CLR_GET ;
      VALID    ( cDocumento( oFmtDoc, oSayFmt, dbfDoc ) ) ;
      BITMAP   "LUPA" ;
      ON HELP  ( BrwDocumento( oFmtDoc, oSayFmt, "AC" ) ) ;
      OF       oDlg

   REDEFINE GET oSayFmt VAR cSayFmt ;
      ID       91 ;
      WHEN     ( .f. );
      COLOR    CLR_GET ;
      OF       oDlg

   TBtnBmp():ReDefine( 92, "Printer_pencil_16",,,,,{|| EdtDocumento( cFmtDoc ) }, oDlg, .f., , .f.,  )

   REDEFINE GET oPrinter VAR cPrinter;
      WHEN     ( .f. ) ;
      ID       160 ;
      OF       oDlg

   TBtnBmp():ReDefine( 161, "Printer_preferences_16",,,,,{|| PrinterPreferences( oPrinter ) }, oDlg, .f., , .f.,  )

   REDEFINE BUTTON ;
      ID       IDOK ;
		OF 		oDlg ;
      ACTION   (  StartPrint( SubStr( cFmtDoc, 1, 3 ), cSerIni + Str( nDocIni, 9 ) + cSufIni, cSerFin + Str( nDocFin, 9 ) + cSufFin, oDlg, cPrinter, lCopiasPre, nNumCop, lInvOrden ),;
                  oDlg:end( IDOK ) )

   REDEFINE BUTTON ;
      ID       IDCANCEL ;
		OF 		oDlg ;
      ACTION   ( oDlg:end() )

   oDlg:bStart := { || oSerIni:SetFocus() }

   oDlg:AddFastKey( VK_F5, {|| StartPrint( SubStr( cFmtDoc, 1, 3 ), cSerIni + Str( nDocIni, 9 ) + cSufIni, cSerFin + Str( nDocFin, 9 ) + cSufFin, oDlg, cPrinter, lCopiasPre, nNumCop, lInvOrden ), oDlg:end( IDOK ) } )

   ACTIVATE DIALOG oDlg CENTER

   ( dbfAlbCliT )->( dbGoTo( nRecNo ) )
   ( dbfAlbCliT )->( ordSetFocus( nOrdAnt ) )

	oWndBrw:oBrw:refresh()

RETURN NIL

//--------------------------------------------------------------------------//

STATIC FUNCTION StartPrint( cFmtDoc, cDocIni, cDocFin, oDlg, cPrinter, lCopiasPre, nNumCop, lInvOrden )

   local nCopyClient

   oDlg:disable()

   if !lInvOrden

      ( dbfAlbCliT )->( DbSeek( cDocIni, .t. ) )

      while ( dbfAlbCliT )->cSerAlb + Str( ( dbfAlbCliT )->nNumAlb ) + ( dbfAlbCliT )->cSufAlb >= cDocIni .AND. ;
            ( dbfAlbCliT )->cSerAlb + Str( ( dbfAlbCliT )->nNumAlb ) + ( dbfAlbCliT )->cSufAlb <= cDocFin

            lChgImpDoc( dbfAlbCliT )

         if lCopiasPre

            nCopyClient := if( nCopiasDocumento( ( dbfAlbCliT )->cSerAlb, "nAlbCli", dbfCount ) == 0, Max( Retfld( ( dbfAlbCliT )->cCodCli, dbfClient, "CopiasF" ), 1 ), nCopiasDocumento( ( dbfAlbCliT )->cSerAlb, "nAlbCli", dbfCount ) )

            GenAlbCli( IS_PRINTER, "Imprimiendo documento : " + (dbfAlbCliT)->cSerAlb + Str( (dbfAlbCliT)->nNumAlb ) + (dbfAlbCliT)->cSufAlb, cFmtDoc, cPrinter, nCopyClient )

         else

            GenAlbCli( IS_PRINTER, "Imprimiendo documento : " + (dbfAlbCliT)->cSerAlb + Str( (dbfAlbCliT)->nNumAlb ) + (dbfAlbCliT)->cSufAlb, cFmtDoc, cPrinter, nNumCop )

         end if

         ( dbfAlbCliT )->( DbSkip( 1 ) )

      end do

   else

   ( dbfAlbCliT )->( DbSeek( cDocFin ) )

      while ( dbfAlbCliT )->cSerAlb + Str( ( dbfAlbCliT )->nNumAlb ) + ( dbfAlbCliT )->cSufAlb >= cDocIni .and.;
            ( dbfAlbCliT )->cSerAlb + Str( ( dbfAlbCliT )->nNumAlb ) + ( dbfAlbCliT )->cSufAlb <= cDocFin .and.;
            !( dbfAlbCliT )->( Bof() )

            lChgImpDoc( dbfAlbCliT )

         if lCopiasPre

            nCopyClient := if( nCopiasDocumento( ( dbfAlbCliT )->cSerAlb, "nAlbCli", dbfCount ) == 0, Max( Retfld( ( dbfAlbCliT )->cCodCli, dbfClient, "CopiasF" ), 1 ), nCopiasDocumento( ( dbfAlbCliT )->cSerAlb, "nAlbCli", dbfCount ) )

            GenAlbCli( IS_PRINTER, "Imprimiendo documento : " + ( dbfAlbCliT )->cSerAlb + Str( ( dbfAlbCliT )->nNumAlb ) + ( dbfAlbCliT )->cSufAlb, cFmtDoc, cPrinter, nCopyClient )

         else

            GenAlbCli( IS_PRINTER, "Imprimiendo documento : " + ( dbfAlbCliT )->cSerAlb + Str( ( dbfAlbCliT )->nNumAlb ) + ( dbfAlbCliT )->cSufAlb, cFmtDoc, cPrinter, nNumCop )

         end if

         ( dbfAlbCliT )->( DbSkip( -1 ) )

      end while

   end if

   oDlg:enable()

RETURN NIL

//--------------------------------------------------------------------------//
/*
Total de unidades en un albaran
*/

static function nTotalUnd( nAlbaran, dbfAlbCliL, cPicUnd )

   local nTotUnd  := 0
   local nRecNum  := ( dbfAlbCliL )->( RecNo() )

   if ( dbfAlbCliL )->( DbSeek( nAlbaran ) )
      while  ( dbfAlbCliL )->CSERALB + Str( ( dbfAlbCliL )->NNUMALB ) + ( dbfAlbCliL )->CSUFALB == nAlbaran .and. ( dbfAlbCliL )->( !eof() )
         nTotUnd  += nTotNAlbCli( dbfAlbCliL )
         ( dbfAlbCliL )->( dbSkip() )
      end do
   end if

   ( dbfAlbCliL )->( dbGoTo( nRecNum ) )

RETURN ( Trans( nTotUnd, cPicUnd ) )

//--------------------------------------------------------------------------//

Function aTotAlbCli( cAlbaran, dbfMaster, dbfLine, dbfIva, dbfDiv, cDivRet, lExcCnt )

   nTotAlbCli( cAlbaran, dbfMaster, dbfLine, dbfIva, dbfDiv, nil, cDivRet, .f., lExcCnt )

Return ( { nTotNet, nTotIva, nTotReq, nTotAlb, nTotPnt, nTotTrn, nTotAge, aTotIva, nTotCos, nTotIvm, nTotRnt, nTotDto, nTotDpp, nTotUno, nTotDos, nTotBrt } )

//--------------------------------------------------------------------------//

Function sTotAlbCli( cAlbaran, dbfMaster, dbfLine, dbfIva, dbfDiv, cDivRet, lExcCnt )

   local sTotal

   nTotAlbCli( cAlbaran, dbfMaster, dbfLine, dbfIva, dbfDiv, nil, cDivRet, .f., lExcCnt )

   sTotal                                 := sTotal()
   sTotal:nTotalBruto                     := nTotBrt
   sTotal:nTotalNeto                      := nTotNet
   sTotal:nTotalIva                       := nTotIva
   sTotal:aTotalIva                       := aTotIva
   sTotal:nTotalRecargoEquivalencia       := nTotReq
   sTotal:nTotalDocumento                 := nTotAlb
   sTotal:nTotalPuntoVerde                := nTotPnt
   sTotal:nTotalTransporte                := nTotTrn
   sTotal:nTotalAgente                    := nTotAge
   sTotal:nTotalCosto                     := nTotCos
   sTotal:nTotalImpuestoHidrocarburos     := nTotIvm
   sTotal:nTotalRentabilidad              := nTotRnt
   sTotal:nTotalDescuentoGeneral          := nTotDto
   sTotal:nTotalDescuentoProntoPago       := nTotDpp
   sTotal:nTotalDescuentoUno              := nTotUno
   sTotal:nTotalDescuentoDos              := nTotDos

Return ( sTotal )

//--------------------------------------------------------------------------//

Static Function QuiAlbCli()

   local nOrdLin
   local nOrdPgo
   local nOrdInc
   local nOrdDoc
   local cNumPed
   local cNumSat
   local aNumPed

   if ( dbfAlbCliT )->lCloAlb .and. !oUser():lAdministrador()
      msgStop( "Solo pueden eliminar albarares cerrados los administradores." )
      Return .f.
   end if

   CursorWait()

   aNumPed        := {}
   cNumPed        := ( dbfAlbCliT )->cNumPed
   cNumSat        := ( dbfAlbCliT )->cNumSat
   nOrdLin        := ( dbfAlbCliL )->( OrdSetFocus( "nNumAlb" ) )
   nOrdPgo        := ( dbfAlbCliP )->( OrdSetFocus( "nNumAlb" ) )
   nOrdInc        := ( dbfAlbCliI )->( OrdSetFocus( "nNumAlb" ) )
   nOrdDoc        := ( dbfAlbCliD )->( OrdSetFocus( "nNumAlb" ) )

   /*
   Eliminamos las entregas-----------------------------------------------------
   */

   while ( dbfAlbCliP )->( dbSeek( ( dbfAlbCliT )->cSerAlb + Str( ( dbfAlbCliT )->nNumAlb ) + ( dbfAlbCliT )->cSufAlb ) ) .and. !( dbfAlbCliP )->( eof() )

      if ( dbfPedCliP )->( dbSeek( ( dbfAlbCliP )->cNumRec ) )
         if dbLock( dbfPedCliP )
            ( dbfPedCliP )->lPasado := .f.
            ( dbfPedCliP )->( dbUnLock() )
         end if
      end if

      if dbDialogLock( dbfAlbCliP )
         ( dbfAlbCliP )->( dbDelete() )
         ( dbfAlbCliP )->( dbUnLock() )
      end if

      ( dbfAlbCliP )->( dbSkip() )

   end do

   /*
   Detalle---------------------------------------------------------------------
   */

   while ( dbfAlbCliL )->( dbSeek( ( dbfAlbCliT )->cSerAlb + Str( ( dbfAlbCliT )->nNumAlb ) + ( dbfAlbCliT  )->cSufAlb ) ) .and. !( dbfAlbCliL )->( eof() )
      
      if aScan( aNumPed, ( dbfAlbCliL )->cNumPed ) == 0
         aAdd( aNumPed, ( dbfAlbCliL )->cNumPed )
      end if      

      if dbLock( dbfAlbCliL )
         ( dbfAlbCliL )->( dbDelete() )
         ( dbfAlbCliL )->( dbUnLock() )
      end if

   end while

   /*
   Incidencias-----------------------------------------------------------------
   */

   while ( dbfAlbCliI )->( dbSeek( ( dbfAlbCliT )->cSerAlb + Str( ( dbfAlbCliT )->nNumAlb ) + ( dbfAlbCliT  )->cSufAlb ) ) .and. !( dbfAlbCliI )->( eof() )
      if dbLock( dbfAlbCliI )
         ( dbfAlbCliI )->( dbDelete() )
         ( dbfAlbCliI )->( dbUnLock() )
      end if
   end while

   /*
   Documentos------------------------------------------------------------------
   */

   while ( dbfAlbCliD )->( dbSeek( ( dbfAlbCliT )->cSerAlb + Str( ( dbfAlbCliT )->nNumAlb ) + ( dbfAlbCliT  )->cSufAlb ) ) .and. !( dbfAlbCliD )->( eof() )
      if dbLock( dbfAlbCliD )
         ( dbfAlbCliD )->( dbDelete() )
         ( dbfAlbCliD )->( dbUnLock() )
      end if
   end while

   /*
   Series----------------------------------------------------------------------
   */

   while ( dbfAlbCliS )->( dbSeek( ( dbfAlbCliT )->cSerAlb + Str( ( dbfAlbCliT )->nNumAlb ) + ( dbfAlbCliT  )->cSufAlb ) ) .and. !( dbfAlbCliS )->( eof() )
      if dbLock( dbfAlbCliS )
         ( dbfAlbCliS )->( dbDelete() )
         ( dbfAlbCliS )->( dbUnLock() )
      end if
   end while

   /*
   Estado del pedido si tiramos de uno-----------------------------------------
   */

   if !Empty( cNumPed )
      oStock:SetEstadoPedCli( cNumPed, .t., ( dbfAlbCliT )->cSerAlb + Str( ( dbfAlbCliT )->nNumAlb ) + ( dbfAlbCliT  )->cSufAlb )
   end if

   /*
   Estado de los pedidos cuando es agrupando-----------------------------------
   */

   for each cNumPed in aNumPed
      oStock:SetEstadoPedCli( cNumPed )
   next   

   /*
   Estado del Sat si tiramos de uno-----------------------------------------
   */

   if !Empty( cNumSat )
      oStock:SetEstadoSatCli( cNumSat, .t., ( dbfAlbCliT )->cSerAlb + Str( ( dbfAlbCliT )->nNumAlb ) + ( dbfAlbCliT  )->cSufAlb )
   end if

   /*
   Estado de los sat cuando es agrupando-----------------------------------
   */

   while dbSeekInOrd( ( dbfAlbCliT )->cSerAlb + Str( ( dbfAlbCliT )->nNumAlb ) + ( dbfAlbCliT  )->cSufAlb, "cNumAlb", dbfSatCliT ) .and. !( dbfSatCliT )->( Eof() )

      if dbLock( dbfSatCliT )
         ( dbfSatCliT )->cNumAlb    := ""
         ( dbfSatCliT )->lEstado    := .f.
         ( dbfSatCliT )->( dbUnLock() )
      end if

   end while

   /*
   Cerramos las tablas---------------------------------------------------------
   */

   ( dbfAlbCliL )->( OrdSetFocus( nOrdLin ) )
   ( dbfAlbCliP )->( OrdSetFocus( nOrdPgo ) )
   ( dbfAlbCliI )->( OrdSetFocus( nOrdInc ) )
   ( dbfAlbCliD )->( OrdSetFocus( nOrdDoc ) )

   CursorWE()

Return .t.

//--------------------------------------------------------------------------//

FUNCTION BrwAlbCli( oGet, oIva )

	local oDlg
	local oBrw
   local oGet1
   local cGet1
   local lIva     := oIva:VarGet()
   local oCbxOrd
   local cCbxOrd
   local nOrd
   local aCbxOrd

   if !OpenFiles()
      Return .f.
   end if

   aCbxOrd        := { "N. albarán", "Fecha", "Cliente", "Nombre", "Su albarán" }
   nOrd           := GetBrwOpt( "BrwAlbCli" )
   nOrd           := Min( Max( nOrd, 1 ), len( aCbxOrd ) )
   cCbxOrd        := aCbxOrd[ nOrd ]

   ( dbfAlbCliT )->( dbSetFilter( {|| !Field->lFacturado .and. Field->lIvaInc == lIva }, "!lFacturado .and. lIvaInc == lIva" ) )
   ( dbfAlbCliT )->( dbGoTop() )

   DEFINE DIALOG oDlg RESOURCE "HELPENTRY" TITLE if( lIva, "Albaranes de clientes con " + cImp() + " incluido", "Albaranes de clientes con " + cImp() + " desglosado" )

		REDEFINE GET oGet1 VAR cGet1;
			ID 		104 ;
         ON CHANGE( AutoSeek( nKey, nFlags, Self, oBrw, dbfAlbCliT, .t., nil, .t. ) );
         VALID    ( OrdClearScope( oBrw, dbfAlbCliT ) );
         BITMAP   "FIND" ;
         OF       oDlg

		REDEFINE COMBOBOX oCbxOrd ;
			VAR 		cCbxOrd ;
			ID 		102 ;
         ITEMS    aCbxOrd ;
         ON CHANGE( ( dbfAlbCliT )->( OrdSetFocus( oCbxOrd:nAt ) ), oBrw:refresh(), oGet1:SetFocus() ) ;
			OF 		oDlg

      oBrw                 := IXBrowse():New( oDlg )

      oBrw:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrw:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrw:cAlias          := dbfAlbCliT
      oBrw:nMarqueeStyle   := 5
      oBrw:cName           := "Albaran de cliente.Browse"

      oBrw:bLDblClick      := {|| oDlg:end( IDOK ) }

      oBrw:CreateFromResource( 105 )

      with object ( oBrw:AddCol() )
         :cHeader          := "Tipo"
         :bEditValue       := {|| aTipAlb[ if( ( dbfAlbCliT )->lAlquiler, 2, 1  ) ] }
         :nWidth           := 50
         :lHide            := .t.
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Número"
         :cSortOrder       := "nNumAlb"
         :bEditValue       := {|| ( dbfAlbCliT )->cSerAlb + "/" + Alltrim( Str( ( dbfAlbCliT )->nNumAlb ) ) + "/" + ( dbfAlbCliT )->cSufAlb }
         :nWidth           := 60
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Fecha"
         :cSortOrder       := "dFecAlb"
         :bEditValue       := {|| dtoc( ( dbfAlbCliT )->dFecAlb ) }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Cliente"
         :cSortOrder       := "cCodCli"
         :bEditValue       := {|| AllTrim( ( dbfAlbCliT )->cCodCli ) }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Nombre"
         :cSortOrder       := "cNomCli"
         :bEditValue       := {|| AllTrim( ( dbfAlbCliT )->cNomCli ) }
         :nWidth           := 200
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Importe"
         :bEditValue       := {|| nTotAlbCli( ( dbfAlbCliT )->cSerAlb + Str( ( dbfAlbCliT )->nNumAlb ) + ( dbfAlbCliT )->cSufAlb, dbfAlbCliT, dbfAlbCliL, dbfIva, dbfDiv, nil, cDivEmp(), .t. )  }
         :nWidth           := 80
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

		REDEFINE BUTTON ;
			ID 		500 ;
			OF 		oDlg ;
         ACTION   ( WinAppRec( oBrw, bEdtRec, dbfAlbCliT ) )

		REDEFINE BUTTON ;
			ID 		501 ;
			OF 		oDlg ;
         ACTION   ( WinEdtRec( oBrw, bEdtRec, dbfAlbCliT ) )

		REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
         ACTION   ( oDlg:end( IDOK ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
			ACTION 	( oDlg:end() )

      oDlg:AddFastKey( VK_F5, {|| oDlg:end( IDOK ) } )

      oDlg:bStart    := {|| oBrw:Refresh( .t. ) }

   ACTIVATE DIALOG oDlg ;
   ON INIT ( oBrw:Load() ) ;
   CENTER

   DestroyFastFilter( dbfAlbCliT )

   SetBrwOpt( "BrwAlbCli", ( dbfAlbCliT )->( OrdNumber() ) )

   ( dbfAlbCliT )->( dbClearFilter() )

   if oDlg:nResult == IDOK
      oGet:cText( ( dbfAlbCliT )->cSerAlb + Str( ( dbfAlbCliT )->nNumAlb ) + ( dbfAlbCliT )->cSufAlb )
      oGet:lValid()
   end if

   CloseFiles()

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

//
// Importa pedidos de clientes
//

STATIC FUNCTION cPedCli( aGet, aTmp, oBrwLin, oBrwPgo, nMode )

   local nDiv
   local cDesAlb
   local nTotRet
   local cPedido  := aGet[ _CNUMPED ]:VarGet()
   local lValid   := .f.

   if nMode != APPD_MODE .or. Empty( cPedido )
      Return .t.
   end if

   if ( dbfPedCliT )->( dbSeek( cPedido ) )

      CursorWait()

      if ( dbfPedCliT )->nEstado == 3

         MsgStop( "Pedido recibido" )
         lValid   := .f.

      else

         aGet[ _CSERALB ]:cText( (dbfPedCliT)->cSerPed )
         aGet[ _CNUMPED ]:bWhen := {|| .f. }

         aGet[ _CCODCLI ]:cText( (dbfPedCliT)->CCODCLI )
         aGet[ _CCODCLI ]:lValid()
         aGet[ _CCODCLI ]:Disable()

         aGet[ _CNOMCLI ]:cText( (dbfPedCliT)->CNOMCLI )
         aGet[ _CDIRCLI ]:cText( (dbfPedCliT)->CDIRCLI )
         aGet[ _CPOBCLI ]:cText( (dbfPedCliT)->CPOBCLI )
         aGet[ _CPRVCLI ]:cText( (dbfPedCliT)->CPRVCLI )
         aGet[ _CPOSCLI ]:cText( (dbfPedCliT)->CPOSCLI )
         aGet[ _CDNICLI ]:cText( (dbfPedCliT)->CDNICLI )
         aGet[ _CCODALM ]:cText( (dbfPedCliT)->CCODALM )
         aGet[ _CTLFCLI ]:cText( (dbfPedCliT)->CTLFCLI )
         aGet[ _CCODALM ]:lValid()

         aGet[ _CCODCAJ ]:cText( (dbfPedCliT)->cCodCaj )
         aGet[ _CCODCAJ ]:lValid()

         aGet[ _CCODPAGO]:cText( (dbfPedCliT)->CCODPGO )
         aGet[ _CCODPAGO]:lValid()

         aGet[ _CCODAGE ]:cText( (dbfPedCliT)->CCODAGE )
         aGet[ _CCODAGE ]:lValid()

         aGet[ _NPCTCOMAGE ]:cText( ( dbfPedCliT )->nPctComAge )

         aGet[ _CCODTAR ]:cText( (dbfPedCliT)->CCODTAR )
         aGet[ _CCODTAR ]:lValid()

         aGet[ _CCODOBR ]:cText( (dbfPedCliT)->CCODOBR )
         aGet[ _CCODOBR ]:lValid()

         aGet[ _NTARIFA ]:cText( ( dbfPedCliT )->nTarifa )

         aGet[ _CCODTRN ]:cText( ( dbfPedCliT )->cCodTrn )
         aGet[ _CCODTRN ]:lValid()

         aGet[ _LIVAINC ]:Click( ( dbfPedCliT )->lIvaInc )
         aGet[ _LRECARGO]:Click( ( dbfPedCliT )->lRecargo )
         aGet[ _LOPERPV ]:Click( ( dbfPedCliT )->lOperPv )

         /*
         Pasamos los comentarios-----------------------------------------------
         */

         aGet[ _CCONDENT ]:cText( ( dbfPedCliT )->cCondEnt )
         aGet[ _MCOMENT  ]:cText( ( dbfPedCliT )->mComent )
         aGet[ _MOBSERV  ]:cText( ( dbfPedCliT )->mObserv )

         /*
         Pasamos todos los Descuentos------------------------------------------
			*/

         aGet[_CDTOESP]:cText( ( dbfPedCliT )->cDtoEsp )
         aGet[_NDTOESP]:cText( ( dbfPedCliT )->nDtoEsp )
         aGet[_CDPP   ]:cText( ( dbfPedCliT )->cDpp    )
         aGet[_NDPP   ]:cText( ( dbfPedCliT )->nDpp    )
         aGet[_CDTOUNO]:cText( ( dbfPedCLiT )->cDtoUno )
         aGet[_NDTOUNO]:cText( ( dbfPedCLiT )->nDtoUno )
         aGet[_CDTODOS]:cText( ( dbfPedCLiT )->cDtoDos )
         aGet[_NDTODOS]:cText( ( dbfPedCLiT )->nDtoDos )
         aGet[_CMANOBR]:cText( ( dbfPedCliT )->cManObr )
         aGet[_NIVAMAN]:cText( ( dbfPedCliT )->nIvaMan )
         aGet[_NMANOBR]:cText( ( dbfPedCliT )->nManObr )
         aGet[_NBULTOS]:cText( ( dbfPedCliT )->nBultos )

         aTmp[_CSUPED ]                := ( dbfPedCliT )->cSuPed

         /*
         Código de grupo
         */

         aTmp[_CCODGRP]                := ( dbfPedCliT )->cCodGrp
         aTmp[_LMODCLI]                := ( dbfPedCliT )->lModCli
         aTmp[_LOPERPV]                := ( dbfPedCliT )->lOperPv

         /*
         Datos de alquileres---------------------------------------------------
         */

         aTmp[ _LALQUILER ]            := ( dbfPedCliT )->lAlquiler
         aTmp[ _DFECENTR  ]            := ( dbfPedCliT )->dFecEntr
         aTmp[ _DFECSAL   ]            := ( dbfPedCliT )->dFecSal

         if !Empty( oTipAlb )
            if ( dbfPedCliT )->lAlquiler
               oTipAlb:Select( 2 )
            else
               oTipAlb:Select( 1 )
            end if
         end if

			/*
         Si encuentra las lineas-----------------------------------------------
			*/

         if ( dbfPedCliL )->( dbSeek( cPedido ) )

            if lNumPed()
               ( dbfTmpLin )->( dbAppend() )
               cDesAlb                 := Rtrim( cNumPed() ) + Space( 1 ) + ( dbfPedCliT )->cSerPed + "/" + AllTrim( Str( ( dbfPedCliT )->NNUMPED ) ) + "/" + ( dbfPedCliT )->CSUFPED
               cDesAlb                 += " - Fecha " + Dtoc( (dbfPedCliT)->dFecPed )
               (dbfTmpLin)->cDetalle   := cDesAlb
               (dbfTmpLin)->lControl   := .t.
            end if

            while ( ( dbfPedCliL )->cSerPed + Str( ( dbfPedCliL )->nNumPed ) + ( dbfPedCliL )->cSufPed == cPedido )

               nTotRet                 := ( dbfPedCliL )->nUniCaja
               nTotRet                 -= nUnidadesRecibidasAlbCli( cPedido, ( dbfPedCliL )->cRef, ( dbfPedCliL )->cCodPr1, ( dbfPedCliL )->cCodPr2, ( dbfPedCliL )->cRefPrv, ( dbfPedCliL )->cDetalle, dbfAlbCliL )
               nTotRet                 -= nUnidadesRecibidasFacCli( cPedido, ( dbfPedCliL )->cRef, ( dbfPedCliL )->cCodPr1, ( dbfPedCliL )->cCodPr2, dbfFacCliL )

               //if ( nTotNPedCli( dbfPedCliL ) == 0 .or. nTotRet > 0 ) para meter lineas en negativo

                  (dbfTmpLin)->( dbAppend() )

                  (dbfTmpLin)->nNumAlb    := 0
                  (dbfTmpLin)->nNumLin    := (dbfPedCliL)->nNumLin
                  (dbfTmpLin)->cRef       := (dbfPedCliL)->cRef
                  (dbfTmpLin)->cDetalle   := (dbfPedCliL)->cDetalle
                  (dbfTmpLin)->mLngDes    := (dbfPedCliL)->mLngDes
                  (dbfTmpLin)->mNumSer    := (dbfPedCliL)->mNumSer
                  (dbfTmpLin)->nPreUnit   := (dbfPedCliL)->nPreDiv
                  (dbfTmpLin)->nPntVer    := (dbfPedCliL)->nPntVer
                  (dbfTmpLin)->nImpTrn    := (dbfPedCliL)->nImpTrn
                  (dbfTmpLin)->nUndKit    := (dbfPedCliL)->nUndKit
                  (dbfTmpLin)->nPesoKg    := (dbfPedCliL)->nPesoKg
                  (dbfTmpLin)->cPesoKg    := (dbfPedCliL)->cPesoKg
                  (dbfTmpLin)->cUnidad    := (dbfPedCliL)->cUnidad
                  (dbfTmpLin)->nVolumen   := (dbfPedCliL)->nVolumen
                  (dbfTmpLin)->cVolumen   := (dbfPedCliL)->cVolumen
                  (dbfTmpLin)->nIva       := (dbfPedCliL)->nIva
                  (dbfTmpLin)->nReq       := (dbfPedCliL)->nReq
                  (dbfTmpLin)->cUnidad    := (dbfPedCliL)->cUnidad
                  (dbfTmpLin)->nDto       := (dbfPedCliL)->nDto
                  (dbfTmpLin)->nDtoPrm    := (dbfPedCliL)->nDtoPrm
                  (dbfTmpLin)->nComAge    := (dbfPedCliL)->nComAge
                  (dbfTmpLin)->lTotLin    := (dbfPedCliL)->lTotLin
                  (dbfTmpLin)->nDtoDiv    := (dbfPedCliL)->nDtoDiv
                  (dbfTmpLin)->nCtlStk    := (dbfPedCliL)->nCtlStk
                  (dbfTmpLin)->nCosDiv    := (dbfPedCliL)->nCosDiv
                  (dbfTmpLin)->nPvpRec    := (dbfPedCliL)->nPvpRec
                  (dbfTmpLin)->cTipMov    := (dbfPedCliL)->cTipMov
                  (dbfTmpLin)->cAlmLin    := (dbfPedCliL)->cAlmLin
                  (dbfTmpLin)->lIvaLin    := (dbfPedCliL)->lIvaLin
                  (dbfTmpLin)->cCodImp    := (dbfPedCLiL)->cCodImp
                  (dbfTmpLin)->nValImp    := (dbfPedCliL)->nValImp
                  (dbfTmpLin)->nMesGrt    := (dbfPedCliL)->nMesGrt
                  (dbfTmpLin)->lLote      := (dbfPedCliL)->lLote
                  (dbfTmpLin)->nLote      := (dbfPedCliL)->nLote
                  (dbfTmpLin)->cLote      := (dbfPedCliL)->cLote
                  (dbfTmpLin)->lKitArt    := (dbfPedCliL)->lKitArt
                  (dbfTmpLin)->lKitChl    := (dbfPedCliL)->lKitChl
                  (dbfTmpLin)->lKitPrc    := (dbfPedCliL)->lKitPrc
                  (dbfTmpLin)->lMsgVta    := (dbfPedCliL)->lMsgVta
                  (dbfTmpLin)->lNotVta    := (dbfPedCliL)->lNotVta
                  (dbfTmpLin)->cCodPr1    := (dbfPedCliL)->cCodPr1
                  (dbfTmpLin)->cCodPr2    := (dbfPedCliL)->cCodPr2
                  (dbfTmpLin)->cValPr1    := (dbfPedCliL)->cValPr1
                  (dbfTmpLin)->cValPr2    := (dbfPedCliL)->cValPr2
                  (dbfTmpLin)->lImpLin    := (dbfPedCliL)->lImpLin
                  (dbfTmpLin)->cCodTip    := (dbfPedCliL)->cCodTip
                  (dbfTmpLin)->mObsLin    := (dbfPedCliL)->mObsLin
                  (dbfTmpLin)->Descrip    := (dbfPedCliL)->Descrip
                  (dbfTmpLin)->cCodPrv    := (dbfPedCliL)->cCodPrv
                  (dbfTmpLin)->cNomPrv    := (dbfPedCliL)->cNomPrv
                  (dbfTmpLin)->cImagen    := (dbfPedCliL)->cImagen
                  (dbfTmpLin)->cCodFam    := (dbfPedCliL)->cCodFam
                  (dbfTmpLin)->cGrpFam    := (dbfPedCliL)->cGrpFam
                  (dbfTmpLin)->cRefPrv    := (dbfPedCliL)->cRefPrv
                  (dbfTmpLin)->dFecEnt    := (dbfPedCliL)->dFecEnt
                  (dbfTmpLin)->dFecSal    := (dbfPedCliL)->dFecSal
                  (dbfTmpLin)->nPreAlq    := (dbfPedCliL)->nPreAlq
                  (dbfTmpLin)->lAlquiler  := (dbfPedCliL)->lAlquiler
                  (dbfTmpLin)->nNumMed    := (dbfPedCliL)->nNumMed
                  (dbfTmpLin)->nMedUno    := (dbfPedCliL)->nMedUno
                  (dbfTmpLin)->nMedDos    := (dbfPedCliL)->nMedDos
                  (dbfTmpLin)->nMedTre    := (dbfPedCliL)->nMedTre
                  (dbfTmpLin)->nPuntos    := (dbfPedCliL)->nPuntos
                  (dbfTmpLin)->nValPnt    := (dbfPedCliL)->nValPnt
                  (dbfTmpLin)->nDtoPnt    := (dbfPedCliL)->nDtoPnt
                  (dbfTmpLin)->nIncPnt    := (dbfPedCliL)->nIncPnt
                  (dbfTmpLin)->cNumPed    := cPedido
                  (dbfTmpLin)->lControl   := (dbfPedCliL)->lControl
                  (dbfTmpLin)->lLinOfe    := (dbfPedCliL)->lLinOfe

                  /*
                  Pasamos las ubicaciones de la mercancía
                  */

                  if dbSeekInOrd( cPedido + ( dbfPedCliL )->cRef + ( dbfPedCliL )->cValPr1 + ( dbfPedCliL )->cValPr2 + ( dbfPedCliL )->cLote + ( dbfPedCliL )->cDetalle, "cPCliDet", dbfAlbPrvL )

                     ( dbfTmpLin )->cCodUbi1 := ( dbfAlbPrvL )->cCodUbi1
                     ( dbfTmpLin )->cCodUbi2 := ( dbfAlbPrvL )->cCodUbi2
                     ( dbfTmpLin )->cCodUbi3 := ( dbfAlbPrvL )->cCodUbi3
                     ( dbfTmpLin )->cValUbi1 := ( dbfAlbPrvL )->cValUbi1
                     ( dbfTmpLin )->cValUbi2 := ( dbfAlbPrvL )->cValUbi2
                     ( dbfTmpLin )->cValUbi3 := ( dbfAlbPrvL )->cValUbi3
                     ( dbfTmpLin )->cNomUbi1 := ( dbfAlbPrvL )->cNomUbi1
                     ( dbfTmpLin )->cNomUbi2 := ( dbfAlbPrvL )->cNomUbi2
                     ( dbfTmpLin )->cNomUbi3 := ( dbfAlbPrvL )->cNomUbi3

                  end if

                  if !( dbfPedCliL )->lKitArt

                     /*
                     Comprobamos si hay calculos por cajas
                     */

                     if lCalCaj()

                        nDiv                       := DecimalMod( nTotRet, ( dbfPedCliL )->nCanPed )
                        if nDiv == 0 .and. ( dbfPedCliL )->nCanPed != 0
                           ( dbfTmpLin )->nCanEnt  := ( dbfPedCliL )->nCanPed
                           ( dbfTmpLin )->nUniCaja := nTotRet // / ( dbfPedCliL )->nCanPed
                        else
                           ( dbfTmpLin )->nCanEnt  := ( dbfPedCliL )->nCanPed
                           ( dbfTmpLin )->nUniCaja := nTotRet
                        end if

                     else

                        ( dbfTmpLin )->nUniCaja    := nTotRet

                     end if

                  else

                     ( dbfTmpLin )->nCanEnt  := ( dbfPedCliL )->nCanPed
                     ( dbfTmpLin )->nUniCaja := ( dbfPedCliL )->nUniCaja

                  end if

               //end if

               ( dbfPedCliL )->( dbSkip( 1 ) )

            end while

            ( dbfTmpLin )->( dbGoTop() )

            /*
            Pasamos los pagos a cuenta-----------------------------------------
            */

            if ( dbfPedCliP )->( dbSeek( cPedido ) )

               while ( dbfPedCliP )->cSerPed + Str( ( dbfPedCliP )->nNumPed ) + ( dbfPedCliP )->cSufPed == cPedido .and. !( dbfPedCliP )->( Eof() )

                  if !( dbfPedCliP )->lPasado

                     ( dbfTmpPgo )->( dbAppend() )

                     ( dbfTmpPgo )->nNumRec  := ( dbfTmpPgo )->( Recno() )
                     ( dbfTmpPgo )->cCodCaj  := ( dbfPedCliP )->cCodCaj
                     ( dbfTmpPgo )->cTurRec  := ( dbfPedCliP )->cTurRec
                     ( dbfTmpPgo )->cCodCli  := ( dbfPedCliP )->cCodCli
                     ( dbfTmpPgo )->dEntrega := ( dbfPedCliP )->dEntrega
                     ( dbfTmpPgo )->nImporte := ( dbfPedCliP )->nImporte
                     ( dbfTmpPgo )->cDescrip := ( dbfPedCliP )->cDesCrip
                     ( dbfTmpPgo )->cPgdoPor := ( dbfPedCliP )->cPgdoPor
                     ( dbfTmpPgo )->cDocPgo  := ( dbfPedCliP )->cDocPgo
                     ( dbfTmpPgo )->cDivPgo  := ( dbfPedCliP )->cDivPgo
                     ( dbfTmpPgo )->nVdvPgo  := ( dbfPedCliP )->nVdvPgo
                     ( dbfTmpPgo )->cCodAge  := ( dbfPedCliP )->cCodAge
                     ( dbfTmpPgo )->cCodPgo  := ( dbfPedCliP )->cCodPgo
                     ( dbfTmpPgo )->cBncEmp  := ( dbfPedCliP )->cBncEmp
                     ( dbfTmpPgo )->cBncCli  := ( dbfPedCliP )->cBncCli
                     ( dbfTmpPgo )->cEntEmp  := ( dbfPedCliP )->cEntEmp
                     ( dbfTmpPgo )->cSucEmp  := ( dbfPedCliP )->cSucEmp
                     ( dbfTmpPgo )->cDigEmp  := ( dbfPedCliP )->cDigEmp
                     ( dbfTmpPgo )->cCtaEmp  := ( dbfPedCliP )->cCtaEmp
                     ( dbfTmpPgo )->cEntCli  := ( dbfPedCliP )->cEntCli
                     ( dbfTmpPgo )->cSucCli  := ( dbfPedCliP )->cSucCli
                     ( dbfTmpPgo )->cDigCli  := ( dbfPedCliP )->cDigCli
                     ( dbfTmpPgo )->cCtaCli  := ( dbfPedCliP )->cCtaCli
                     ( dbfTmpPgo )->lCloPgo  := .f.
                     ( dbfTmpPgo )->cNumRec  := ( dbfPedCliP )->cSerPed + Str( ( dbfPedCliP )->nNumPed ) + ( dbfPedCliP )->cSufPed + Str( ( dbfPedCliP )->nNumRec )

                  end if

                  ( dbfPedCliP )->( dbSkip() )

               end while

            end if

            ( dbfPedCliP )->( dbGoTop() )

            /*
            Pasamos las incidencias de los pedidos-----------------------------
            */

            if ( dbfPedCliI )->( dbSeek( cPedido ) )

               while ( dbfPedCliI )->cSerPed + Str( ( dbfPedCliI )->nNumPed ) + ( dbfPedCliI )->cSufPed == cPedido .and. !( dbfPedCliI )->( Eof() )
                  dbPass( dbfPedCliI, dbfTmpInc, .t. )
                  ( dbfPedCliI )->( dbSkip() )
               end while

            end if

            ( dbfPedCliI )->( dbGoTop() )

            /*
            Pasamos los documentos de los pedidos------------------------------
            */

            if ( dbfPedCliD )->( dbSeek( cPedido ) )

               while ( dbfPedCliD )->cSerPed + Str( ( dbfPedCliD )->nNumPed ) + ( dbfPedCliD )->cSufPed == cPedido .and. !( dbfPedCliD )->( Eof() )
                  dbPass( dbfPedCliD, dbfTmpDoc, .t. )
                  ( dbfPedCliD )->( dbSkip() )
               end while

            end if

            ( dbfPedCliD )->( dbGoTop() )

            /*
            Refresh------------------------------------------------------------
            */

            oBrwLin:Refresh()
            oBrwPgo:Refresh()

            oBrwLin:SetFocus()

         end if

         lValid   := .t.

      end if

      aGet[ _CNUMPED ]:Disable()

      CursorWE()

   else

		MsgStop( "Pedido no existe" )

   end if

RETURN lValid

//---------------------------------------------------------------------------//

FUNCTION nNetUAlbCli( uTmp, nDec, nVdv, lIva )

   local nCalculo

   DEFAULT nDec      := 0
   DEFAULT nVdv      := 1
   DEFAULT lIva      := .f.

   nCalculo          := nTotUAlbCli( uTmp, nDec, nVdv )

   if ( dbfAlbCliL )->nIva != 0
      do case
         case !lIva .and. ( dbfAlbCliL )->lIvaLin
            nCalculo -= Round( nCalculo / ( 100 / ( dbfAlbCliL )->nIva + 1 ), nDec )
         case lIva .and. !( dbfAlbCliL )->lIvaLin
            nCalculo += Round( nCalculo * ( dbfAlbCliL )->nIva / 100, nDec )
      end case
   end if

RETURN ( Round( nCalculo, nDec ) )

//---------------------------------------------------------------------------//

FUNCTION nBrtLAlbCli( uTmpCab, uTmpLin, nDec, nRec, nVdv, cPorDiv )

   local nCalculo    := 0

   DEFAULT nDec      := 2
   DEFAULT nVdv      := 1

   nCalculo          := nImpUAlbCli( uTmpCab, uTmpLin, nDec, nVdv, cPorDiv )
   nCalculo          *= nTotNAlbCli( uTmpLin )

   nCalculo          := Round( nCalculo / nVdv, nRec )

Return ( if( cPorDiv != nil, Trans( nCalculo, cPorDiv ), nCalculo ) )

//---------------------------------------------------------------------------//

/*
Devuelve el valor del IGIC de un artículo
*/
/*
FUNCTION nIvaUAlbCli( dbfTmpLin, nDec, nVdv )

   local nCalculo

   DEFAULT nDec   := 0
   DEFAULT nVdv   := 1

   nCalculo       := nTotUAlbCli( dbfTmpLin, nDec, nVdv )

   if !( dbfTmpLin )->lIvaLin
      nCalculo    := nCalculo * ( dbfTmpLin )->nIva / 100
   else
      nCalculo    -= nCalculo / ( 1 + ( dbfTmpLin )->nIva / 100 )
   end if

   if nVdv != 0
      nCalculo    := nCalculo / nVdv
   end if

RETURN ( Round( nCalculo, nDec ) )
  */
//---------------------------------------------------------------------------//
/*
Devuelve el precio unitario IGIC incluido
*/

FUNCTION nIncUAlbCli( dbfTmpLin, nDec, nVdv )

   local nCalculo

   DEFAULT nDec   := 0
   DEFAULT nVdv   := 1

   nCalculo       := nTotUAlbCli( dbfTmpLin, nDec, nVdv )

   if !( dbfTmpLin )->lIvaLin
      nCalculo    += nCalculo * ( dbfTmpLin )->nIva / 100
   end if

	IF nVdv != 0
      nCalculo    := nCalculo / nVdv
	END IF

RETURN ( Round( nCalculo, nDec ) )

//---------------------------------------------------------------------------//

FUNCTION cDesAlbCli( cAlbCliL, cAlbCliS )

   DEFAULT cAlbCliL  := dbfAlbCliL
   DEFAULT cAlbCliS  := dbfAlbCliS

RETURN ( Descrip( cAlbCliL, cAlbCliS ) )

//---------------------------------------------------------------------------//

Function cFraAlbCli( cAlbCliL )

   local cTxtFra     := ""

   DEFAULT cAlbCliL  := dbfAlbCliL

   if ( cAlbCliL )->lImpFra
      cTxtFra        := ( cAlbCliL )->cTxtFra
   end if

Return ( cTxtFra )

//---------------------------------------------------------------------------//
/*
Devuelve el precio del articulo una vez realizados los descuentos en linea
*/

FUNCTION nTotPAlbCli( dbfLin, nDec, nVdv, lDto, cPouDiv )

	local nCalculo

   DEFAULT dbfLin    := dbfAlbCliL
   DEFAULT nDec      := 0
   DEFAULT nVdv      := 1
   DEFAULT lDto      := .t.

   if ( dbfLin )->lTotLin

      nCalculo       := nTotUAlbCli( dbfLin, nDec, nVdv )

   else

      /*
      Tomamos los valores redondeados
      */

      nCalculo       := nTotUAlbCli( dbfLin, nDec, nVdv )

      nCalculo       -= Round( ( dbfLin )->nDtoDiv , nDec )

      /*
      Descuentos---------------------------------------------------------------
      */

      IF lDto

         IF ( dbfLin )->NDTO != 0
            nCalculo -= nCalculo * ( dbfLin )->NDTO / 100
         END IF

         IF ( dbfLin )->NDTOPRM != 0
            nCalculo -= nCalculo * ( dbfLin )->NDTOPRM / 100
         END IF

      END IF

      nCalculo       := Round( nCalculo, nDec )

   end if

RETURN ( if( cPouDiv != NIL, trans( nCalculo, cPouDiv ), nCalculo ) )

//---------------------------------------------------------------------------//

/*
Devuelve el total de una linea con IGIC incluido
*/

FUNCTION nIncLAlbCli( dbfLin, nDec, nRouDec, nVdv, lDto, lPntVer, lImpTrn, cPouDiv )

   local nCalculo := nTotLAlbCli( dbfLin, nDec, nRouDec, nVdv, lDto, lPntVer, lImpTrn, cPouDiv )

   if !( dbfLin )->lIvaLin
      nCalculo    += nCalculo * ( dbfLin )->nIva / 100
   end if

RETURN ( if( cPouDiv != NIL, Trans( nCalculo, cPouDiv ), nCalculo ) )

//---------------------------------------------------------------------------//

FUNCTION nIvaLAlbCli( dbfLin, nDec, nRou, nVdv, lDto, lPntVer, lImpTrn, cPouDiv )

   local nCalculo := nTotLAlbCli( dbfLin, nDec, nRou, nVdv, lDto, lPntVer, lImpTrn, cPouDiv )

   if !( dbfLin )->lIvaLin
      nCalculo    := nCalculo * ( dbfLin )->nIva / 100
   else
      nCalculo    -= nCalculo / ( 1 + ( dbfLin )->nIva / 100 )
   end if

   nCalculo       := Round( nCalculo, nRou )

RETURN ( if( cPouDiv != nil, Trans( nCalculo, cPouDiv ), nCalculo ) )

//---------------------------------------------------------------------------//
//
// Devuelve el neto de una linea una vez quitados los Dtos.
//

FUNCTION nNetLAlbCli( cAlbCliT, cAlbCliL, nDec, nRou, nVdv, lIva, lDto, lImpTrn, lPntVer, cPouDiv )

   local nCalculo

   DEFAULT cAlbCliT  := dbfAlbCliT
   DEFAULT cAlbCliL  := dbfAlbCliL
   DEFAULT nDec      := nDouDiv()
   DEFAULT nRou      := nRouDiv()
   DEFAULT nVdv      := 1
   DEFAULT lIva      := .t.
   DEFAULT lDto      := .t.
   DEFAULT lPntVer   := .t.
   DEFAULT lImpTrn   := .t.

   nCalculo          := nTotLAlbCli( cAlbCliL, nDec, nRou, nVdv, lDto, lImpTrn, lPntVer )

   if ( cAlbCliL )->nIva != 0
      do case
         case !lIva .and. ( cAlbCliT )->lIvaInc
            nCalculo -= Round( nCalculo / ( 100 / ( cAlbCliL )->nIva  + 1 ), nRou )
         case lIva .and. !( cAlbCliT )->lIvaInc
            nCalculo += nCalculo * ( cAlbCliL )->nIva / 100
      end case
   end if

RETURN ( if( cPouDiv != nil, Trans( nCalculo, cPouDiv ), nCalculo ) )

//---------------------------------------------------------------------------//

FUNCTION nDtoAtpAlbCli( uAlbCliT, dbfAlbCliL, nDec, nRou, nVdv, lImpTrn, lPntVer )

   local nCalculo
   local nDtoAtp  := 0

   DEFAULT nDec   := 0
   DEFAULT nRou   := 0
   DEFAULT nVdv   := 1
   DEFAULT lPntVer:= .f.
   DEFAULT lImpTrn:= .f.

   nCalculo       := nTotLAlbCli( dbfAlbCliL, nDec, nRou, nVdv, .t., lImpTrn, lPntVer )

   if ( uAlbCliT )->nSbrAtp <= 1 .and. ( uAlbCliT )->nDtoAtp != 0
      nDtoAtp     += Round( nCalculo * ( uAlbCliT )->nDtoAtp / 100, nRou )
   end if

   nCalculo       -= Round( nCalculo * ( uAlbCliT )->nDtoEsp / 100, nRou )

   if ( uAlbCliT )->nSbrAtp == 2 .and. ( uAlbCliT )->nDtoAtp != 0
      nDtoAtp     += Round( nCalculo * ( uAlbCliT )->nDtoAtp / 100, nRou )
   end if

   nCalculo       -= Round( nCalculo * ( uAlbCliT )->nDpp    / 100, nRou )

   if ( uAlbCliT )->nSbrAtp == 3 .and. ( uAlbCliT )->nDtoAtp != 0
      nDtoAtp     += Round( nCalculo * ( uAlbCliT )->nDtoAtp / 100, nRou )
   end if

   nCalculo       -= Round( nCalculo * ( uAlbCliT )->nDtoUno / 100, nRou )

   if ( uAlbCliT )->nSbrAtp == 4 .and. ( uAlbCliT )->nDtoAtp != 0
      nDtoAtp     += Round( nCalculo * ( uAlbCliT )->nDtoAtp / 100, nRou )
   end if

   nCalculo       -= Round( nCalculo * ( uAlbCliT )->nDtoDos / 100, nRou )

   if ( uAlbCliT )->nSbrAtp == 5 .and. ( uAlbCliT )->nDtoAtp != 0
      nDtoAtp     += Round( nCalculo * ( uAlbCliT )->nDtoAtp / 100, nRou )
   end if

RETURN ( nDtoAtp )

//---------------------------------------------------------------------------//

/*
Funciones auxiliares para comunicarnos desde fuera del PRG
*/

FUNCTION Ped2AlbCli( cNumPed, dbfAlbCliT )

   local oBlock
   local oError
   local nOrdAnt
   local cNumAlb

   oBlock         := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      nOrdAnt     := ( dbfAlbCliT )->( OrdSetFocus( "cNumPed" ) )

      if ( dbfAlbCliT )->( dbSeek( cNumPed ) )
         cNumAlb  := ( dbfAlbCliT )->cSerAlb + Str( ( dbfAlbCliT )->nNumAlb ) + ( dbfAlbCliT )->cSufAlb
      end if

      if !Empty( cNumAlb )
         EdtAlbCli( cNumAlb )
      else
         msgStop( "No hay albarán asociado" )
      end if

      ( dbfAlbCliT )->( OrdSetFocus( nOrdAnt ) )

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos de albaranes" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE
   
   ErrorBlock( oBlock )


RETURN NIL

//---------------------------------------------------------------------------//

/*
Devuelve en numero de articulos en una linea de detalle
*/

/*STATIC FUNCTION nTotLNumArt( dbfDetalle )

	local nCalculo := 0

   if lCalCaj() .AND. (dbfDetalle)->NCANENT != 0 .AND. (dbfDetalle)->NSATUNIT != 0
		nCalculo := (dbfDetalle)->NCANENT
   end if

RETURN ( nCalculo )*/

//---------------------------------------------------------------------------//

STATIC FUNCTION SelSend( oBrw )

   local oDlg
   local oFecEnv
   local dFecEnv  := GetSysDate()

   if dbDialogLock( dbfAlbCliT )

      if ( dbfAlbCliT )->lEntregado

         if lUsrMaster()

            ( dbfAlbCliT )->lEntregado := !( dbfAlbCliT )->lEntregado
            ( dbfAlbCliT )->dFecEnv    := Ctod( "" )

         else

            MsgStop( "Sin autorizacion para cambio de entrega" )

         end if

      else

         DEFINE DIALOG oDlg RESOURCE "ENVIADO" TITLE "Fecha entrega"

            REDEFINE GET oFecEnv VAR dFecEnv ;
               ID       100 ;
               SPINNER ;
               BITMAP   "LUPA" ;
               COLOR    CLR_GET ;
               OF       oDlg

            REDEFINE BUTTON ;
               ID       501 ;
               OF       oDlg ;
               ACTION   (  ( dbfAlbCliT )->lEntregado := !( dbfAlbCliT )->lEntregado ,;
                           ( dbfAlbCliT )->dFecEnv    := dFecEnv ,;
                           ( dbfAlbCliT )->lSndDoc    := .t. ,;
                           oDlg:end() )

            REDEFINE BUTTON ;
               ID       502 ;
               OF       oDlg ;
               ACTION   ( oDlg:end() )

         oDlg:AddFastKey( VK_F5, {|| ( dbfAlbCliT )->lEntregado := !( dbfAlbCliT )->lEntregado , ( dbfAlbCliT )->dFecEnv    := dFecEnv , ( dbfAlbCliT )->lSndDoc    := .t. , oDlg:end() } )
         oDlg:bStart := { || oFecEnv:SetFocus() }

         ACTIVATE DIALOG oDlg CENTER

      end if

   ( dbfAlbCliT )->( dbUnLock() )

   end if

   oBrw:Refresh()
   oBrw:SetFocus()

RETURN NIL

//-------------------------------------------------------------------------//
/*
Function CleanAlbCli()

   local dbfAlbCliT


   //Retorna el valor anterior


   if !TDataCenter():OpenAlbCliT( @dbfAlbCliT )
   lOpenFiles     := .f.
end if

   SET ADSINDEX TO ( cPatEmp() + "ALBCLIT.CDX" ) ADDITIVE

   ( dbfAlbCliT )->( dbGoTop() )

   while ( dbfAlbCliT )->( !eof() )

      if ( dbfAlbCliT )->lSndDoc
         if dbLock( dbfAlbCliT )
            ( dbfAlbCliT )->lSndDoc := .f.
            ( dbfAlbCliT )->( dbRUnlock() )
         end if
      end if

      ( dbfAlbCliT )->( dbSkip() )

   end do

   CLOSE ( dbfAlbCliT )

Return nil
  */
//---------------------------------------------------------------------------//
/*
Devuelve la fecha de un albaran de cliente
*/

FUNCTION dFecAlbCli( cAlbCli, uAlbCliT )

   local dFecAlb  := CtoD( "" )

   if ValType( uAlbCliT ) == "C"

      if dbSeekInOrd( cAlbCli, "nNumAlb", uAlbCliT )
         dFecAlb  := ( uAlbCliT )->dFecAlb
      end if

   else

      if uAlbCliT:SeekInOrd( cAlbCli, "nNumAlb" )
         dFecAlb  := uAlbCliT:dFecAlb
      end if

   end if

RETURN ( dFecAlb )

//---------------------------------------------------------------------------//

FUNCTION cCliAlbCli( cAlbCli, uAlbCliT )

   local cCodCli  := ""

   do case
      case ValType( uAlbCliT ) == "C"
         if (uAlbCliT)->( dbSeek( cAlbCli ) )
            cCodCli     := (uAlbCliT)->CCODCLI
         end if
      case ValType( uAlbCliT ) == "O"
         if uAlbCliT:Seek( cAlbCli )
            cCodCli     := uAlbCliT:cCodCli
         end if
   end case

RETURN ( cCodCli )

//----------------------------------------------------------------------------//

FUNCTION cNbrAlbCli( cAlbCli, uAlbCliT )

   local cCodCli  := ""

   do case
      case ValType( uAlbCliT ) == "C"
         if (uAlbCliT)->( dbSeek( cAlbCli ) )
            cCodCli     := ( uAlbCliT )->cNomCli
         end if
      case ValType( uAlbCliT ) == "O"
         if uAlbCliT:Seek( cAlbCli )
            cCodCli     := uAlbCliT:cNomCli
         end if
   end case

RETURN ( cCodCli )

//----------------------------------------------------------------------------//

/*
Funcion que nos permite a¤adir a los albaranes pedidos ye existentes
*/

STATIC FUNCTION GrpPed( aGet, aTmp, oBrw )

	local oDlg
   local nDiv
   local nItem       := 1
   local cCodAge
   local oBrwLin
   local nOrdAnt
   local nNumLin
   local lCodAge     := .f.
   local nOffSet     := 0
   local cDesAlb     := ""
   local cCodCli     := aGet[ _CCODCLI ]:varGet()
   local nTotPed
   local nTotRec
   local nTotPdt
   local lAlquiler   := .f.
   local cCliente    := RTrim( aTmp[ _CNOMCLI ] )
   local cObra       := if( Empty( aTmp[ _CCODOBR ] ), "Todas", Rtrim( aTmp[ _CCODOBR ] ) )  
   local cIva        := cImp() + Space( 1 ) + if( aTmp[ _LIVAINC ], "Incluido", "Desglosado" )

   aPedidos          := {}

   if Empty( cCodCli )
      msgStop( "Es necesario codificar un cliente", "Agrupar pedidos" )
      return .t.
   end if

   if !Empty( aGet[ _CNUMPED ]:VarGet() )
      msgStop( "Ya ha importado un pedido", "Agrupar pedidos" )
      return .t.
   end if

   if !Empty( oTipAlb ) .and. oTipAlb:nAt == 2
      lAlquiler      := .t.
   end if

   /*
	Seleccion de Registros
	--------------------------------------------------------------------------
	*/

   nOrdAnt           := ( dbfPedCliT )->( ordSetFocus( "cCodCli" ) )

   if ( dbfPedCliT )->( dbSeek( cCodCli ) )

      while ( dbfPedCliT )->cCodCli == cCodCli .AND. ( dbfPedCliT )->( !eof() )

         if ( dbfPedCliT )->lAlquiler == lAlquiler                                              .and.;
            ( dbfPedCliT )->nEstado != 3                                                        .and.;
            ( dbfPedCliT )->lIvaInc == aTmp[ _LIVAINC ]                                         .and.;
            if( Empty( aTmp[ _CCODOBR ] ), .t., ( dbfPedCliT )->cCodObr == aTmp[ _CCODOBR ] )   .and.;
            aScan( aNumPed, ( dbfPedCliT )->cSerPed + Str( ( dbfPedCliT )->nNumPed ) + ( dbfPedCliT )->cSufPed ) == 0

            aAdd( aPedidos,    {  .f. ,;
                                 ( if( ( dbfPedCliT )->nEstado == 1, 3, ( dbfPedCliT )->nEstado ) ),;
                                 ( dbfPedCliT )->cSerPed + Str( ( dbfPedCliT )->nNumPed ) + ( dbfPedCliT )->cSufPed,;
                                 ( dbfPedCliT )->dFecPed ,;
                                 ( dbfPedCliT )->cCodCli ,;
                                 ( dbfPedCliT )->cNomCli ,;
                                 ( dbfPedCliT )->cCodObr ,;
                                 RetObras( ( dbfPedCliT )->cCodCli, ( dbfPedCliT )->cCodObr, dbfObrasT ),;
                                 ( dbfPedCliT )->cCodAge  } )

         endif

         ( dbfPedCliT )->( dbSkip( 1 ) )

      end while

   end if

   ( dbfPedCliT )->( ordSetFocus( nOrdAnt ) )

   /*
	Puede que no hay albaranes que facturar-------------------------------------
	*/

   if Len( aPedidos ) == 0
      msgStop( "No existen pedidos pendientes de albaranar de este cliente" )
      return .t.
   end if

   /*
   Caja de Dialogo
   ----------------------------------------------------------------------------
   */

   DEFINE DIALOG  oDlg ;
      RESOURCE    "SET_ALBARAN" ;
      TITLE       "Agrupando pedidos"

      REDEFINE SAY PROMPT cCliente ;
         ID       501 ;
         OF       oDlg

      REDEFINE SAY PROMPT cObra ;
         ID       502 ;
         OF       oDlg

      REDEFINE SAY PROMPT cIva ;
         ID       503 ;
         OF       oDlg

      oBrwLin                       := TXBrowse():New( oDlg )

      oBrwLin:bClrSel               := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwLin:bClrSelFocus          := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrwLin:SetArray( aPedidos, , , .f. )
      oBrwLin:lHscroll              := .f.

      oBrwLin:nMarqueeStyle         := 5
      oBrwLin:lRecordSelector       := .f.

      oBrwLin:CreateFromResource( 130 )

      oBrwLin:bLDblClick            := {|| aPedidos[ oBrwLin:nArrayAt, 1 ] := !aPedidos[ oBrwLin:nArrayAt, 1 ], oBrwLin:refresh() }

      with object ( oBrwLin:AddCol() )
         :cHeader          := "Seleccionado"
         :bStrData         := {|| "" }
         :bEditValue       := {|| aPedidos[ oBrwLin:nArrayAt, 1 ] }
         :nWidth           := 20
         :SetCheck( { "Sel16", "Nil16" } )
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader          := "Estado"
         :bStrData         := {|| "" }
         :bEditValue       := {|| ( aPedidos[ oBrwLin:nArrayAt, 2 ] == 2 ) }
         :nWidth           := 20
         :SetCheck( { "Bullet_Square_Yellow_16", "Bullet_Square_Red_16" } )
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader          := "Número"
         :bEditValue       := {|| aPedidos[ oBrwLin:nArrayAt, 3 ] }
         :cEditPicture     := "@R #/999999999/##"
         :nWidth           := 80
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader          := "Fecha"
         :bEditValue       := {|| Dtoc( aPedidos[ oBrwLin:nArrayAt, 4 ] ) }
         :nWidth           := 80
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader          := "Cliente"
         :bEditValue       := {|| Rtrim( aPedidos[ oBrwLin:nArrayAt, 5 ] ) + Space(1) + aPedidos[ oBrwLin:nArrayAt, 6 ] }
         :nWidth           := 250
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader          := "Obra"
         :bEditValue       := {|| Rtrim( aPedidos[ oBrwLin:nArrayAt, 7 ] ) + Space(1) + aPedidos[ oBrwLin:nArrayAt, 8 ] }
         :nWidth           := 220
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader          := "Agente"
         :bEditValue       := {|| aPedidos[ oBrwLin:nArrayAt, 9 ] }
         :lHide            := .t.
         :nWidth           := 60
      end with

      REDEFINE BUTTON ;
         ID       514 ;
         OF       oDlg ;
         ACTION   (  aPedidos[ oBrwLin:nArrayAt, 1 ] := !aPedidos[ oBrwLin:nArrayAt, 1 ],;
                     oBrwLin:refresh(),;
                     oBrwLin:setFocus() )

      REDEFINE BUTTON ;
         ID       516 ;
         OF       oDlg ;
         ACTION   (  aEval( aPedidos, { |aItem| aItem[1] := .t. } ),;
                     oBrwLin:refresh(),;
                     oBrwLin:setFocus() )

      REDEFINE BUTTON ;
         ID       517 ;
         OF       oDlg ;
         ACTION   (  aEval( aPedidos, { |aItem| aItem[1] := .f. } ),;
                     oBrwLin:Refresh(),;
                     oBrwLin:SetFocus() )

      REDEFINE BUTTON ;
         ID       IDOK ;
         OF       oDlg ;
         ACTION   ( oDlg:end( IDOK ) )

      REDEFINE BUTTON ;
         ID       IDCANCEL ;
         OF       oDlg ;
         ACTION   ( oDlg:end() )

   ACTIVATE DIALOG oDlg CENTER

   if oDlg:nResult != IDOK
      aPedidos  := {}
   end if

   /*
   Llamada a la funcion que busca el Albaran-----------------------------------
   */

   if oDlg:nResult == IDOK .AND. Len( aPedidos ) >= 1

      CursorWait()

      HideImportacion()

      /*
      A¤adimos los albaranes seleccionado para despues-------------------------
      */

      for nItem := 1 to Len( aPedidos )

         if ( aPedidos[ nItem, 1 ] )

            aAdd( aNumPed, aPedidos[ nItem, 3 ] )

            if Empty( cCodAge )
               cCodAge  := aPedidos[ nItem, 9 ]
            end if

            if cCodAge != aPedidos[ nItem, 9 ]
               lCodAge  := .t.
            end if

         end if

      next

      if lCodAge
         MsgInfo( "Existen conflictos de agentes" )
      end if

      for nItem := 1 to Len( aPedidos )

         /*
         Cabeceras de albaranes a facturas-------------------------------------
         */

         if !lCodAge .and. cCodAge != nil
            aGet[ _CCODAGE ]:cText( cCodAge )
            aGet[ _CCODAGE ]:lValid()
         end if

         if ( dbfPedCliT )->( dbSeek( aPedidos[ nItem, 3 ] ) ) .AND. aPedidos[ nItem, 1 ]

            if ( dbfPedCliT )->lRecargo
               aTmp[ _LRECARGO ] := .t.
               aGet[ _LRECARGO ]:Refresh()
            end if

            if ( dbfPedCliT )->lOperPv
               aTmp[ _LOPERPV ] := .t.
               aGet[ _LOPERPV ]:Refresh()
            end if

         end if

         /*
         Detalle de albaranes a facturas---------------------------------------
         */

         if ( dbfPedCliL )->( dbSeek( aPedidos[ nItem, 3] ) ) .AND. aPedidos[ nItem, 1]

            /*
            Cabeceras de pedidos-----------------------------------------------
            */

            nNumLin                    := nil

            if lNumPed()
               (dbfTmpLin)->( dbAppend() )
               cDesAlb                 := Rtrim( cNumPed() )
               cDesAlb                 += " Pedido Nº " + Alltrim( Trans( aPedidos[ nItem, 3 ], "@R #/999999999/##" ) )
               cDesAlb                 += " - Fecha " + Dtoc( aPedidos[ nItem, 4] )
               (dbfTmpLin)->mLngDes    := cDesAlb
               (dbfTmpLin)->lControl   := .t.
               (dbfTmpLin)->nNumLin    := ++nOffSet
            end if

            /*
            Mientras estemos en el mismo pedido--------------------------------
            */

            while ( dbfPedCliL )->cSerPed + Str( ( dbfPedCliL )->nNumPed ) + ( dbfPedCliL )->cSufPed == aPedidos[ nItem, 3]

               if aPedidos[ nItem, 2 ] == 2

                  nTotPed              := nTotNPedCli( dbfPedCliL )
                  nTotRec              := nUnidadesRecibidasAlbCli( aPedidos[ nItem, 3 ], ( dbfPedCliL )->cRef, ( dbfPedCliL )->cCodPr1, ( dbfPedCliL )->cCodPr2, ( dbfPedCliL )->cRefPrv, ( dbfPedCliL )->cDetalle, dbfAlbCliL )
                  nTotPdt              := nTotPed - nTotRec

                  if nTotPdt > 0

                     if nNumLin != (dbfPedCliL)->nNumLin
                        ++nOffSet
                        nNumLin        := (dbfPedCliL)->nNumLin
                     end if

                     ( dbfTmpLin )->( dbAppend() )

                     ( dbfTmpLin )->cNumPed  := aPedidos[ nItem, 3]

                     (dbfTmpLin)->nNumAlb    := 0
                     (dbfTmpLin)->nNumLin    := nOffSet
                     (dbfTmpLin)->cRef       := (dbfPedCliL)->cRef
                     (dbfTmpLin)->cDetalle   := (dbfPedCliL)->cDetalle
                     (dbfTmpLin)->mLngDes    := (dbfPedCliL)->mLngDes
                     (dbfTmpLin)->nPreUnit   := (dbfPedCliL)->nPreDiv
                     (dbfTmpLin)->cUnidad    := (dbfPedCliL)->cUnidad
                     (dbfTmpLin)->nPesoKg    := (dbfPedCliL)->nPesoKg
                     (dbfTmpLin)->cPesoKg    := (dbfPedCliL)->cPesoKg
                     (dbfTmpLin)->nVolumen   := (dbfPedCliL)->nVolumen
                     (dbfTmpLin)->cVolumen   := (dbfPedCliL)->cVolumen
                     (dbfTmpLin)->lIvaLin    := (dbfPedCliL)->lIvaLin
                     (dbfTmpLin)->nIva       := (dbfPedClil)->nIva
                     (dbfTmpLin)->nReq       := (dbfPedClil)->nReq
                     (dbfTmpLin)->nDto       := (dbfPedClil)->nDto
                     (dbfTmpLin)->nPntVer    := (dbfPedCliL)->nPntVer
                     (dbfTmpLin)->nImpTrn    := (dbfPedCliL)->nImpTrn
                     (dbfTmpLin)->nDtoPrm    := (dbfPedCliL)->nDtoPrm
                     (dbfTmpLin)->nComAge    := (dbfPedCliL)->nComAge
                     (dbfTmpLin)->dFecHa     := (dbfPedCliL)->dFecha
                     (dbfTmpLin)->cTipMov    := (dbfPedCliL)->cTipMov
                     (dbfTmpLin)->nDtoDiv    := (dbfPedCliL)->nDtoDiv
                     (dbfTmpLin)->nUndKit    := (dbfPedCliL)->nUndKit
                     (dbfTmpLin)->lKitArt    := (dbfPedCliL)->lKitArt
                     (dbfTmpLin)->lKitChl    := (dbfPedCliL)->lKitChl
                     (dbfTmpLin)->lKitPrc    := (dbfPedCliL)->lKitPrc
                     (dbfTmpLin)->cCodPr1    := (dbfPedCliL)->cCodPr1
                     (dbfTmpLin)->cCodPr2    := (dbfPedCliL)->cCodPr2
                     (dbfTmpLin)->cValPr1    := (dbfPedCliL)->cValPr1
                     (dbfTmpLin)->cValPr2    := (dbfPedCliL)->cValPr2
                     (dbfTmpLin)->nCosDiv    := (dbfPedCliL)->nCosDiv
                     (dbfTmpLin)->nMesGrt    := (dbfPedCliL)->nMesGrt
                     (dbfTmpLin)->lMsgVta    := (dbfPedCliL)->lMsgVta
                     (dbfTmpLin)->lNotVta    := (dbfPedCliL)->lNotVta
                     (dbfTmpLin)->lLote      := (dbfPedCliL)->lLote
                     (dbfTmpLin)->nLote      := (dbfPedCliL)->nLote
                     (dbfTmpLin)->cLote      := (dbfPedCliL)->cLote
                     (dbfTmpLin)->mObsLin    := (dbfPedCliL)->mObsLin
                     (dbfTmpLin)->Descrip    := (dbfPedCliL)->Descrip
                     (dbfTmpLin)->cCodPrv    := (dbfPedCliL)->cCodPrv
                     (dbfTmpLin)->cNomPrv    := (dbfPedCliL)->cNomPrv
                     (dbfTmpLin)->cCodFam    := (dbfPedCliL)->cCodFam
                     (dbfTmpLin)->cGrpFam    := (dbfPedCliL)->cGrpFam
                     (dbfTmpLin)->cAlmLin    := (dbfPedCliL)->cAlmLin
                     (dbfTmpLin)->cRefPrv    := (dbfPedCliL)->cRefPrv
                     (dbfTmpLin)->dFecEnt    := (dbfPedCliL)->dFecEnt
                     (dbfTmpLin)->dFecSal    := (dbfPedCliL)->dFecSal
                     (dbfTmpLin)->lAlquiler  := (dbfPedCliL)->lAlquiler
                     (dbfTmpLin)->nPreAlq    := (dbfPedCliL)->nPreAlq
                     (dbfTmpLin)->nPuntos    := (dbfPedCliL)->nPuntos
                     (dbfTmpLin)->nValPnt    := (dbfPedCliL)->nValPnt
                     (dbfTmpLin)->nDtoPnt    := (dbfPedCliL)->nDtoPnt
                     (dbfTmpLin)->nIncPnt    := (dbfPedCliL)->nIncPnt
                     (dbfTmpLin)->lImpLin    := (dbfPedCliL)->lImpLin
                     (dbfTmpLin)->lLinOfe    := (dbfPedCliL)->lLinOfe

                     if lCalCaj()
                        if nTotRec != 0
                           nDiv                       := DecimalMod( nTotPdt, ( dbfPedCliL )->nCanPed )
                           if nDiv == 0 .and. ( dbfPedCliL )->nCanPed != 0
                              ( dbfTmpLin )->nCanEnt  := ( dbfPedCliL )->nCanPed
                              ( dbfTmpLin )->nUniCaja := nTotPdt / ( dbfPedCliL )->nCanPed
                           else
                              ( dbfTmpLin )->nCanEnt  := 0
                              ( dbfTmpLin )->nUniCaja := nTotPdt
                           end if
                        else
                           ( dbfTmpLin )->nCanEnt     := ( dbfPedCliL )->nCanPed
                           ( dbfTmpLin )->nUniCaja    := ( dbfPedCliL )->nUniCaja
                        end if
                     else
                        ( dbfTmpLin )->nUniCaja       := nTotPdt
                     end if

                  end if

               else

                  if nNumLin != (dbfPedCliL)->nNumLin
                     ++nOffSet
                     nNumLin                 := (dbfPedCliL)->nNumLin
                  end if

                  ( dbfTmpLin )->( dbAppend() )

                  ( dbfTmpLin )->cNumPed     := aPedidos[ nItem, 3]
                  ( dbfTmpLin )->nNumAlb     := 0 
                  ( dbfTmpLin )->nNumLin     := nOffSet
                  ( dbfTmpLin )->cRef        := ( dbfPedCliL )->cRef
                  ( dbfTmpLin )->cDetalle    := ( dbfPedCliL )->cDetalle
                  ( dbfTmpLin )->mLngDes     := ( dbfPedCliL )->mLngDes
                  ( dbfTmpLin )->nPreUnit    := ( dbfPedCliL )->nPreDiv
                  ( dbfTmpLin )->cUnidad     := ( dbfPedCliL )->cUnidad
                  ( dbfTmpLin )->nPesoKg     := ( dbfPedCliL )->nPesoKg
                  ( dbfTmpLin )->cPesoKg     := ( dbfPedCliL )->cPesoKg
                  ( dbfTmpLin )->nVolumen    := ( dbfPedCliL )->nVolumen
                  ( dbfTmpLin )->cVolumen    := ( dbfPedCliL )->cVolumen
                  ( dbfTmpLin )->nIva        := ( dbfpedclil )->nIva
                  ( dbfTmpLin )->nReq        := ( dbfpedclil )->nReq
                  ( dbfTmpLin )->nDto        := ( dbfpedclil )->nDto
                  ( dbfTmpLin )->nPntVer     := ( dbfPedCliL )->nPntVer
                  ( dbfTmpLin )->nImpTrn     := ( dbfPedCliL )->nImpTrn
                  ( dbfTmpLin )->nDtoPrm     := ( dbfPedCliL )->nDtoPrm
                  ( dbfTmpLin )->nComAge     := ( dbfPedCliL )->nComAge
                  ( dbfTmpLin )->dFecHa      := ( dbfPedCliL )->dFecha
                  ( dbfTmpLin )->cTipMov     := ( dbfPedCliL )->cTipMov
                  ( dbfTmpLin )->nDtoDiv     := ( dbfPedCliL )->nDtoDiv
                  ( dbfTmpLin )->nUniCaja    := ( dbfPedCliL )->nUniCaja - ( dbfPedCliL )->nUniEnt
                  ( dbfTmpLin )->nCanEnt     := ( dbfPedCliL )->nCanPed  - ( dbfPedCliL )->nCanEnt
                  ( dbfTmpLin )->nUndKit     := ( dbfPedCliL )->nUndKit
                  ( dbfTmpLin )->lKitArt     := ( dbfPedCliL )->lKitArt
                  ( dbfTmpLin )->lKitChl     := ( dbfPedCliL )->lKitChl
                  ( dbfTmpLin )->lKitPrc     := ( dbfPedCliL )->lKitPrc
                  ( dbfTmpLin )->cCodPr1     := ( dbfPedCliL )->cCodPr1
                  ( dbfTmpLin )->cCodPr2     := ( dbfPedCliL )->cCodPr2
                  ( dbfTmpLin )->cValPr1     := ( dbfPedCliL )->cValPr1
                  ( dbfTmpLin )->cValPr2     := ( dbfPedCliL )->cValPr2
                  ( dbfTmpLin )->nCosDiv     := ( dbfPedCliL )->nCosDiv
                  ( dbfTmpLin )->nMesGrt     := ( dbfPedCliL )->nMesGrt
                  ( dbfTmpLin )->lMsgVta     := ( dbfPedCliL )->lMsgVta
                  ( dbfTmpLin )->lNotVta     := ( dbfPedCliL )->lNotVta
                  ( dbfTmpLin )->lLote       := ( dbfPedCliL )->lLote
                  ( dbfTmpLin )->nLote       := ( dbfPedCliL )->nLote
                  ( dbfTmpLin )->cLote       := ( dbfPedCliL )->cLote
                  ( dbfTmpLin )->mObsLin     := ( dbfPedCliL )->mObsLin
                  ( dbfTmpLin )->Descrip     := ( dbfPedCliL )->Descrip
                  ( dbfTmpLin )->cCodPrv     := ( dbfPedCliL )->cCodPrv
                  ( dbfTmpLin )->cNomPrv     := ( dbfPedCliL )->cNomPrv
                  ( dbfTmpLin )->cCodFam     := ( dbfPedCliL )->cCodFam
                  ( dbfTmpLin )->cGrpFam     := ( dbfPedCliL )->cGrpFam
                  ( dbfTmpLin )->cAlmLin     := ( dbfPedCliL )->cAlmLin
                  ( dbfTmpLin )->cRefPrv     := ( dbfPedCliL )->cRefPrv
                  ( dbfTmpLin )->dFecEnt     := ( dbfPedCliL )->dFecEnt
                  ( dbfTmpLin )->dFecSal     := ( dbfPedCliL )->dFecSal
                  ( dbfTmpLin )->lAlquiler   := ( dbfPedCliL )->lAlquiler
                  ( dbfTmpLin )->nPreAlq     := ( dbfPedCliL )->nPreAlq
                  ( dbfTmpLin )->cUnidad     := ( dbfPedCliL )->cUnidad
                  ( dbfTmpLin )->nNumMed     := ( dbfPedCliL )->nNumMed
                  ( dbfTmpLin )->nMedUno     := ( dbfPedCliL )->nMedUno
                  ( dbfTmpLin )->nMedDos     := ( dbfPedCliL )->nMedDos
                  ( dbfTmpLin )->nMedTre     := ( dbfPedCliL )->nMedTre
                  ( dbfTmpLin )->nPuntos     := ( dbfPedCliL )->nPuntos
                  ( dbfTmpLin )->nValPnt     := ( dbfPedCliL )->nValPnt
                  ( dbfTmpLin )->nDtoPnt     := ( dbfPedCliL )->nDtoPnt
                  ( dbfTmpLin )->nIncPnt     := ( dbfPedCliL )->nIncPnt
                  ( dbfTmpLin )->lLinOfe     := ( dbfPedCliL )->lLinOfe

               end if

               ( dbfPedCliL )->( dbSkip( 1 ) )

            end while

            ( dbfTmpLin )->( dbGoTop() )

            /*
            Pasamos las entregas a cuenta--------------------------------------
            */

            if ( dbfPedCliP )->( dbSeek( aPedidos[ nItem, 3 ] ) ) .AND. aPedidos[ nItem, 1 ]

               while ( dbfPedCliP )->cSerPed + Str( ( dbfPedCliP )->nNumPed ) + ( dbfPedCliP )->cSufPed == aPedidos[ nItem, 3 ] .and. !( dbfPedCliP )->( Eof() )

                  if !( dbfPedCliP )->lPasado

                     ( dbfTmpPgo )->( dbAppend() )

                     ( dbfTmpPgo )->nNumRec  := ( dbfTmpPgo )->( Recno() )
                     ( dbfTmpPgo )->cCodCaj  := ( dbfPedCliP )->cCodCaj
                     ( dbfTmpPgo )->cTurRec  := ( dbfPedCliP )->cTurRec
                     ( dbfTmpPgo )->cCodCli  := ( dbfPedCliP )->cCodCli
                     ( dbfTmpPgo )->dEntrega := ( dbfPedCliP )->dEntrega
                     ( dbfTmpPgo )->nImporte := ( dbfPedCliP )->nImporte
                     ( dbfTmpPgo )->cDescrip := ( dbfPedCliP )->cDesCrip
                     ( dbfTmpPgo )->cPgdoPor := ( dbfPedCliP )->cPgdoPor
                     ( dbfTmpPgo )->cDocPgo  := ( dbfPedCliP )->cDocPgo
                     ( dbfTmpPgo )->cDivPgo  := ( dbfPedCliP )->cDivPgo
                     ( dbfTmpPgo )->nVdvPgo  := ( dbfPedCliP )->nVdvPgo
                     ( dbfTmpPgo )->cCodAge  := ( dbfPedCliP )->cCodAge
                     ( dbfTmpPgo )->cCodPgo  := ( dbfPedCliP )->cCodPgo
                     ( dbfTmpPgo )->lCloPgo  := .f.

                  end if

                  if dbLock( dbfPedCliP )
                     ( dbfPedCliP )->lPasado := .t.
                     ( dbfPedCliP )->( dbUnLock() )
                  end if

                  ( dbfPedCliP )->( dbSkip() )

               end while

            end if

            ( dbfTmpPgo )->( dbGoTop() )

            oBrw:Refresh()

         end if

      next

      /*
      No dejamos importar pedidos directos-------------------------------------
      */

      aGet[ _CNUMPED ]:bWhen           := {|| .f. }
      aGet[ _CNUMPED ]:Disable()

      /*
      Recalculo de totales-----------------------------------------------------
      */

      RecalculaTotal( aTmp )

      CursorWE()

   end if

return .t.

//---------------------------------------------------------------------------//

function lGenAlbCli( oBrw, oBtn, nDevice )

   local bAction

   DEFAULT nDevice   := IS_PRINTER

   if Empty( oBtn )
      return nil
   end if

   IF !( dbfDoc )->( dbSeek( "AC" ) )

      DEFINE BTNSHELL RESOURCE "DOCUMENT" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( msgStop( "No hay documentos predefinidos" ) );
         TOOLTIP  "No hay documentos" ;
         FROM     oBtn ;
         CLOSED ;
         LEVEL    ACC_EDIT

   ELSE

      WHILE ( dbfDoc )->CTIPO == "AC" .AND. !( dbfDoc )->( eof() )

         bAction  := bGenAlbCli( nDevice, "Imprimiendo albaranes de clientes", ( dbfDoc )->CODIGO )

         oWndBrw:NewAt( "Document", , , bAction, Rtrim( ( dbfDoc )->cDescrip ) , , , , , oBtn )

         ( dbfDoc )->( dbSkip() )

      END DO

   END IF

   SysRefresh()

return nil

//---------------------------------------------------------------------------//
//
// Devuelve el total de la venta en albaranes de clientes de un articulo
//

/*function nTotVAlbCli( cCodArt, dbfAlbCliL, nDouDiv, nDorDiv )

   local nTotVta  := 0
   local nRecno   := ( dbfAlbCliL )->( Recno() )

   if ( dbfAlbCliL )->( dbSeek( cCodArt ) )

      while ( dbfAlbCliL )->cRef == cCodArt .and. !( dbfAlbCliL )->( eof() )

         if !( dbfAlbCliL )->lTotLin
            nTotVta += nTotLAlbCli( dbfAlbCliL, nDouDiv, nDorDiv )
         end if

         ( dbfAlbCliL )->( dbSkip() )

      end while

   end if

   ( dbfAlbCliL )->( dbGoTo( nRecno ) )

return ( nTotVta )*/

//---------------------------------------------------------------------------//
//
// Devuelve el total de la compra en albaranes de clientes de un articulo
//

function nTotDAlbCli( cCodArt, dbfAlbCliL, dbfAlbCliT, cCodAlm )

   local lFacAlb        := .f.
   local nTotVta        := 0
   local nRecno         := ( dbfAlbCliL )->( Recno() )

   if ( dbfAlbCliL )->( dbSeek( cCodArt ) )

      while ( dbfAlbCliL )->cRef == cCodArt .and. !( dbfAlbCliL )->( eof() )

         if dbfAlbCliT != nil
            lFacAlb     := lFacAlbCli( ( dbfAlbCliL )->CSERALB + Str( ( dbfAlbCliL )->NNUMALB ) + ( dbfAlbCliL )->CSUFALB, dbfAlbCliT )
         end if

         if !( dbfAlbCliL )->lTotLin .and. !lFacAlb
            if cCodAlm != nil
               if cCodAlm == ( dbfAlbCliL )->cAlmLin
                  nTotVta  += nTotNAlbPrv( dbfAlbCliL ) * NotCero( ( dbfAlbCliL )->nFacCnv )
               end if
            else
               nTotVta     += nTotNAlbCli( dbfAlbCliL ) * NotCero( ( dbfAlbCliL )->nFacCnv )
            end if
         end if

         ( dbfAlbCliL )->( dbSkip() )

      end while

   end if

   ( dbfAlbCliL )->( dbGoTo( nRecno ) )

return ( nTotVta )

//---------------------------------------------------------------------------//

//
// Devuelve el precio de compra real de un articulo una vez aplicados los descuentos
//
/*
FUNCTION nPreAlbCli( dbfAlbCliL, uTmp, nDec, lIva )

   local cDivAlb
   local nDtoEsp
   local nDtoPp
   local nDtoUno
   local nDtoDos
   local nCalculo := ( dbfAlbCliL )->NSATUNIT

   DEFAULT lIva   := .t.

   if valtype( uTmp ) == "A"
      cDivAlb     := uTmp[ _CDIVALB ]
      nDtoEsp     := uTmp[ _NDTOESP ]
      nDtoPp      := uTmp[ _NDPP    ]
      nDtoUno     := uTmp[ _NDTOUNO ]
      nDtoDos     := uTmp[ _NDTODOS ]
   else
      cDivAlb     := (uTmp)->CDIVALB
      nDtoEsp     := (uTmp)->NDTOESP
      nDtoPp      := (uTmp)->NDPP
      nDtoUno     := (uTmp)->NDTOUNO
      nDtoDos     := (uTmp)->NDTODOS
   end if

   DEFAULT nDec   := nDouDiv( cDivAlb, dbfDiv )

   nCalculo       -= (dbfAlbCliL)->nDtoDiv

   IF (dbfAlbCliL)->NDTO != 0
      nCalculo    -= nCalculo * (dbfAlbCliL)->NDTO / 100
	END IF

   IF (dbfAlbCliL)->NDTOPRM != 0
      nCalculo    -= nCalculo * (dbfAlbCliL)->NDTOPRM / 100
	END IF

   IF nDtoEsp != 0
      nCalculo    -= nCalculo * nDtoEsp / 100
   END IF

   IF nDtoPp != 0
      nCalculo    -= nCalculo * nDtoPp / 100
   END IF

   IF nDtoUno != 0
      nCalculo    -= nCalculo * nDtoUno / 100
   END IF

   IF nDtoDos != 0
      nCalculo    -= nCalculo * nDtoDos / 100
   END IF

   IF lIva
      nCalculo    += Round( nCalculo * ( dbfAlbCliL )->nIva / 100, nDec )
   END IF

RETURN ( round( nCalculo, nDec ) )
  */
//----------------------------------------------------------------------------//

static function bGenAlbCli( nDevice, cTitle, cCodDoc )

   local bGen
   local nDev  := by( nDevice )
   local cTit  := by( cTitle  )
   local cCod  := by( cCodDoc )

   if nDev == IS_PRINTER
      bGen     := {|| GenAlbCli( nDev, cTit, cCod ) }
   else
      bGen     := {|| GenAlbCli( nDev, cTit, cCod ) }
   end if

return ( bGen )

//---------------------------------------------------------------------------//
//
// Devuelve el total de la venta en albaranes de un clientes determinado
//


function nVtaAlbCli( cCodCli, dDesde, dHasta, dbfAlbCliT, dbfAlbCliL, dbfIva, dbfDiv, lNotFac, nYear )

   local nCon        := 0
   local nRec        := ( dbfAlbCliT )->( Recno() )

   DEFAULT lNotFac   := .f.

   /*
   Albaranes a Clientes -------------------------------------------------------
   */

   if ( dbfAlbCliT )->( dbSeek( cCodCli ) )

      while ( dbfAlbCliT )->cCodCli == cCodCli .and. !( dbfAlbCliT )->( Eof() )

         if ( dDesde == nil .or. ( dbfAlbCliT )->dFecAlb >= dDesde )    .and.;
            ( dHasta == nil .or. ( dbfAlbCliT )->dFecAlb <= dHasta )    .and.;
            ( if( lNotFac, !( dbfAlbCliT )->lFacturado, .t. ) )         .and.;
            ( nYear == nil .or. Year( ( dbfAlbCliT )->dFecAlb ) == nYear )

            nCon  += nTotAlbCli( ( dbfAlbCliT )->CSERALB + Str( ( dbfAlbCliT )->NNUMALB ) + ( dbfAlbCliT )->CSUFALB, dbfAlbCliT, dbfAlbCliL, dbfIva, dbfDiv, nil, cDivEmp(), .f. )

         end if

         ( dbfAlbCliT )->( dbSkip() )

         SysRefresh()

      end while

   end if

   ( dbfAlbCliT )->( dbGoTo( nRec ) )

return nCon

//---------------------------------------------------------------------------//

/*
NOMBRE FICHERO      : TALBAxxx.PSI   (xxx = Agente)
DESCRIPCION         : CABECERAS  ALBARAN
TIPO DE FICHERO     : SECUENCIAL SIN SEPARADOR DE CAMPOS
NUM. DE CAMPOS      : 20
LONG. DEL REGISTRO  : 143

N§ PO  LC  Descripci¢n       Observaciones
1  1   7   CODIGO CLIENTE
2  8   10  NUM. NOTA         aaa/nnnnnn    (agente/numeronota)
3  18  1   TIPO NOTA         (1)
4  19  2   COD. PROVEEDOR    diferente de espacios si es venta indirecta
5  21  8   BASE IMPONIBLE 1
6  29  8   BASE IMPONIBLE 2
7  37  8   BASE IMPONIBLE 3
8  45  8   IGIC TIPO 1
9  53  8   IGIC TIPO 2
10 61  8   IGIC TIPO 3
11 69  8   R.E. TIPO 1
12 77  8   R.E. TIPO 2
13 85  8   R.E. TIPO 3
14 93  5   DESC. CONCERTADO  Descuento que figura en la ficha del cliente
15 98  5   DESC. PRONTO PAGO Descuento opcional al final de factura
16 103 8   IMPORTE PVERDE    Cargo por impuesto punto verde
17 111 8   IMPORTE NOTA      Importe total del documento (incluye pverde)
18 119 8   IMPORTE COBRADO   (2)
19 127 10  FECHA             DD/MM/AAAA
20 137 5   HORA              HH:MM
21 142 2   FINAL REGISTRO    CR LF


  (1) Tipos de nota: 1- Factura Contado     2- Factura Credito
                     3- Albaran Contado     4- Albaran Credito
                     5- Adicional Contado   6- Adicional Credito
                     7- Indirecto Contado   8- Indirecto Credit
o

  (2) S¢lo s
er  igual a ImporteNota si se trata de contado-met lico.
      Si es credito o contado-tal¢n ira con 0.

 Ej: "000032100   20000       0       0    3200       0       0       0
             0       0 0.00 0.00       0   23300   2330012/03/199618:15"
     (Factura de contado n§ 10900 emitida al cliente 321 por el vendedor 4
      el d¡a 12 de Marzo de 1996, por un importe de 23200, sin descuentos,
      ni punto verde, a las 6 y cuarto de la tarde. El tipo de IGIC fue el 1)


NOMBRE FICHERO      : EALBAxxx.PSI   (xxx = Agente)
DESCRIPCION         : LINEAS DE  ALBARAN
TIPO DE FICHERO     : SECUENCIAL SIN SEPARADOR DE CAMPOS
NUM. DE CAMPOS      : 13
LONG. DEL REGISTRO  : 70

N§ PO  LC  Descripci¢n       Observaciones
1  1   7   CODIGO CLIENTE
2  8   10  NUM. NOTA         aaa/nnnnnn   (agente/numeronota)
3  18  1   TIPO NOTA         (1)
4  19  13  COD. ARTICULO
5  32  7   SATCIO            Precio de venta sin descuentos
6  39  5   DESC.             Descuento por unidad en euros o ptas
7  44  5   DESC. PORCENTUAL  Descuento por unidad en %
8  49  4   UNID. VALORA. 1   cajas
9  53  7   UNID. VALORA  2   kilos/unidades
10 60  1   TIPO LINEA        (2)
11 61  1   tipo IGIC          1, 2 ¢ 3
12 62  1   EUROS S/N         Indica si se hizo en euros o en pts (3)
13 63  7   PVERDE            Cargo unitario por Punto Verde
14 70  2   FINAL REGISTRO    CR LF  ( chr$(13) y chr$(10) )

  (1) Tipos de nota:  1- Factura Contado     2- Factura Credito
                      3- Albaran Contado     4- Albaran Credito
                      5- Adicional Contado   6- Adicional Credito
                      7- Indirecto Contado   8- Indirecto Credito

  (2) Tipos de linea: 0- Venta      1- Devoluci¢n      2- Defectuoso
                      3- Caducado   4- Abono  7- Regalo mercancia Automat.

  (3) Si el cliente est  en euros, los campos precio y desc. vendran en
      euros, y si estaba en ptas, vendr n en ptas.
*/

FUNCTION EdmAlbCli( cCodRut, cPathTo, oStru, aSucces )

   local n           := 0
   local cSerie
   local cFilEdm
   local oFilEdm
   local dFecAlb
   local cCodCli
   local nNumAlb
   local cNumDoc
   local nCajEnt     := 0
   local cTipDoc
   local aHeadLine   := {}
   local aLotes      := {}

   DEFAULT cCodRut   := "001"
   DEFAULT cPathTo   := "C:\INTERS~1\"

   /*
   Obtenemos la fecha del albaran----------------------------------------------
   */

   cCodRut           := SubStr( cCodRut, -3 )

   cFilEdm           := cPathTo + "TALBA" + cCodRut + ".PSI"

   if !file( cFilEdm )
      msgWait( "No existe el fichero " + cFilEdm, "Atención", 1 )
      return nil
   end if

   oFilEdm           := TTxtFile():New( cFilEdm )

   /*
   Abrimos las bases de datos--------------------------------------------------
   */

   while ! oFilEdm:lEoF()
      aAdd( aHeadLine, { SubStr( oFilEdm:cLine, 8, 10 ), Ctod( SubStr( oFilEdm:cLine, 127, 10 ) ) } )
      oFilEdm:Skip()
   end while

   oFilEdm:Close()

   /*
   Nuevo fichero con los lotes-------------------------------------------------
   */

   cFilEdm           := cPathTo + "LALBA" + cCodRut + ".PSI"

   if !file( cFilEdm )

      msgWait( "No existe el fichero " + cFilEdm, "Atención", 1 )

   else

      oFilEdm           := TTxtFile():New( cFilEdm )

      /*
      Abrimos las bases de datos--------------------------------------------------
      */

      while ! oFilEdm:lEoF()

         cTipDoc        := SubStr( oFilEdm:cLine, 18,  1 )

         if ( cTipDoc == "3" .or. cTipDoc == "4" )
            aAdd( aLotes, { SubStr( oFilEdm:cLine, 8, 10 ),;                // Num. nota
                            LTrim( SubStr( oFilEdm:cLine, 19, 13 ) ),;      // Código del artículo
                            RTrim( SubStr( oFilEdm:cLine, 43, 21 ) ) } )    // Num. lote
         end if

         oFilEdm:Skip()

      end while

   oFilEdm:Close()

   end if

   /*
   ----------------------------------------------------------------------------
   */

   cFilEdm           := cPathTo + "EALBA" + cCodRut + ".PSI"

   /*
   Creamos el fichero destino--------------------------------------------------
   */

   if !file( cFilEdm )
      msgStop( cFilEdm, "No existe" )
      return nil
   end if

   oFilEdm           := TTxtFile():New( cFilEdm )

   /*
   Abrimos las bases de datos--------------------------------------------------
   */

   OpenFiles()

   oStru:oMetDos:cText   := "Alb. Clientes"
   oStru:oMetDos:SetTotal( oFilEdm:nTLines )

   /*
   Mientras no estemos en el final del archivo
   */

   while !oFilEdm:lEoF()
      /*
      Tomamos el codigo del cliente
      */

      cCodCli        := SubStr( oFilEdm:cLine,  1,  7 )
      cNumDoc        := SubStr( oFilEdm:cLine,  8, 10 )
      cTipDoc        := SubStr( oFilEdm:cLine, 18,  1 )

      if ( cTipDoc == "3" .or. cTipDoc == "4" )

         if dbSeekInOrd( cCodCli, "Cod", dbfClient )

            nNumAlb                          := Val( StrTran( cNumDoc, "/", "" ) )

            if Empty( ( dbfClient )->Serie )
               cSerie                        := "A"
            else
               cSerie                        := ( dbfClient )->Serie
            end if

            if !( dbfAlbCliT )->( dbSeek( cSerie + Str( nNumAlb, 9 ) + RetSufEmp() ) )

               n  := aScan( aHeadLine, {|a| a[1] == cNumDoc } )
               if n != 0
                  dFecAlb                    := aHeadLine[n,2]

                  ( dbfAlbCliT )->( dbAppend() )
                  ( dbfAlbCliT )->cSerAlb    := cSerie
                  ( dbfAlbCliT )->nNumAlb    := nNumAlb
                  ( dbfAlbCliT )->cSufAlb    := RetSufEmp()
                  ( dbfAlbCliT )->dFecAlb    := dFecAlb
                  ( dbfAlbCliT )->cCodAlm    := oUser():cAlmacen()
                  ( dbfAlbCliT )->cDivAlb    := cDivEmp()
                  ( dbfAlbCliT )->nVdvAlb    := nChgDiv( ( dbfAlbCliT )->cDivAlb, dbfDiv )
                  ( dbfAlbCliT )->lFacturado := .f.
                  ( dbfAlbCliT )->cCodCli    := ( dbfClient )->Cod
                  ( dbfAlbCliT )->cNomCli    := ( dbfClient )->Titulo
                  ( dbfAlbCliT )->cDirCli    := ( dbfClient )->Domicilio
                  ( dbfAlbCliT )->cPobCli    := ( dbfClient )->Poblacion
                  ( dbfAlbCliT )->cPrvCli    := ( dbfClient )->Provincia
                  ( dbfAlbCliT )->cPosCli    := ( dbfClient )->CodPostal
                  ( dbfAlbCliT )->cDniCli    := ( dbfClient )->Nif
                  ( dbfAlbCliT )->cCodTar    := ( dbfClient )->cCodTar
                  ( dbfAlbCliT )->cCodPago   := ( dbfClient )->CodPago
                  ( dbfAlbCliT )->cCodAge    := ( dbfClient )->cAgente
                  ( dbfAlbCliT )->cCodRut    := ( dbfClient )->cCodRut
                  ( dbfAlbCliT )->nTarifa    := ( dbfClient )->nTarifa
                  ( dbfAlbCliT )->lRecargo   := ( dbfClient )->lReq
                  ( dbfAlbCliT )->lOperPv    := ( dbfClient )->lPntVer
                  ( dbfAlbCliT )->cDtoEsp    := ( dbfClient )->cDtoEsp
                  ( dbfAlbCliT )->cDpp       := ( dbfClient )->cDpp
                  ( dbfAlbCliT )->nDtoEsp    := ( dbfClient )->nDtoEsp
                  ( dbfAlbCliT )->nDpp       := ( dbfClient )->nDpp
                  ( dbfAlbCliT )->nDtoUno    := ( dbfClient )->nDtoCnt
                  ( dbfAlbCliT )->cDtoUno    := ( dbfClient )->cDtoUno
                  ( dbfAlbCliT )->nDtoDos    := ( dbfClient )->nDtoRap
                  ( dbfAlbCliT )->cDtoDos    := ( dbfClient )->cDtoDos
                  ( dbfAlbCliT )->( dbUnLock() )

                  aAdd( aSucces, { .t., "Nuevo albarán de clientes " + ( dbfAlbCliT )->cSerAlb + "/" + AllTrim( Str( ( dbfAlbCliT )->nNumAlb ) ) + "/" + ( dbfAlbCliT )->cSufAlb } )

                  /*
                  Mientras estemos en el mismo albarán pasamos las lineas------
                  */

                  while cNumDoc == SubStr( oFilEdm:cLine,  8, 10 ) .and. ! oFilEdm:lEoF()

                     if cTipDoc == "3" .or. cTipDoc == "4"

                        if ( dbfAlbCliT )->( dbSeek( cSerie + Str( nNumAlb, 9 ) + RetSufEmp() ) )

                           ( dbfAlbCliL )->( dbAppend() )
                           ( dbfAlbCliL )->cSerAlb       := ( dbfAlbCliT )->cSerAlb
                           ( dbfAlbCliL )->nNumAlb       := ( dbfAlbCliT )->nNumAlb
                           ( dbfAlbCliL )->cSufAlb       := ( dbfAlbCliT )->cSufAlb
                           ( dbfAlbCliL )->cRef          := Ltrim( SubStr( oFilEdm:cLine, 19, 13 ) )
                           ( dbfAlbCliL )->cDetalle      := RetFld( ( dbfAlbCliL )->cRef, dbfArticulo )
                           ( dbfAlbCliL )->nPreUnit      := Val( SubStr( oFilEdm:cLine, 32,  7 ) )
                           ( dbfAlbClil )->nDtoDiv       := Val( SubStr( oFilEdm:cLine, 39,  5 ) )
                           ( dbfAlbClil )->nDto          := Val( SubStr( oFilEdm:cLine, 44,  5 ) )
                           ( dbfAlbClil )->nIva          := nIvaCodTer( SubStr( oFilEdm:cLine, 61, 1 ), dbfIva )
                           ( dbfAlbClil )->nPntVer       := Val( SubStr( oFilEdm:cLine, 63, 7 ) )
                           ( dbfAlbCliL )->nCanEnt       := 1
                           ( dbfAlbCliL )->nUniCaja      := Val( SubStr( oFilEdm:cLine, 53,  7 ) )

                           /*
                           Buscamos en el array l numero de lote---------------
                           */

                           if ( n  := aScan( aLotes, {|a| a[1] == cNumDoc .and. a[2] == Ltrim( SubStr( oFilEdm:cLine, 19, 13 ) ) } ) ) != 0
                              ( dbfAlbCliL )->lLote      := .t.
                              ( dbfAlbCliL )->cLote      := aLotes[ n, 3 ]
                           end if

                           ( dbfAlbCliL )->( dbUnLock() )

                        end if

                     end if

                     oFilEdm:Skip()

                  end do

               else

                  aAdd( aSucces, { .f., "Líneas de albarán huerfanas, cliente " + cCodCli + " documento : " + cNumDoc } )
                  oFilEdm:Skip()

               end if

            else

               aAdd( aSucces, { .f., "Albarán de clientes ya existe " + ( dbfAlbCliT )->cSerAlb + "/" + AllTrim( Str( ( dbfAlbCliT )->nNumAlb ) ) + "/" + ( dbfAlbCliT )->cSufAlb } )
               oFilEdm:Skip()

            end if

         else

            aAdd( aSucces, { .f., "No existe cliente " + cCodCli + " de albarán " + AllTrim( cNumDoc ) } )
            oFilEdm:Skip()

         end if

      else

         oFilEdm:Skip()

      end if

      oStru:oMetDos:Set( oFilEdm:nLine )

   end do

   oStru:oMetDos:SetTotal( oFilEdm:nTLines )

   CloseFiles()

   oFilEdm:Close()

RETURN ( aSucces )

//---------------------------------------------------------------------------//


//-----------------------------------------------------------------------------//

Function aDocAlbCli( lEntregas )

   local aDoc        := {}

   DEFAULT lEntregas := .f.

   /*
   Itmes-----------------------------------------------------------------------
   */

   aAdd( aDoc, { "Empresa",         "EM" } )
   aAdd( aDoc, { "Albaran",         "AC" } )

   if lEntregas
      aAdd( aDoc, { "Entregas a cuenta",  "EA" } )
   end if

   aAdd( aDoc, { "Cliente",         "CL" } )
   aAdd( aDoc, { "Almacen",         "AL" } )
   aAdd( aDoc, { "Obras",           "OB" } )
   aAdd( aDoc, { "Rutas",           "RT" } )
   aAdd( aDoc, { "Agentes",         "AG" } )
   aAdd( aDoc, { "Divisas",         "DV" } )
   aAdd( aDoc, { "Formas de pago",  "PG" } )
   aAdd( aDoc, { "Transportistas",  "TR" } )

RETURN ( aDoc )

//---------------------------------------------------------------------------//

Function aCalAlbCli()

   local aCalAlbCli  := {}

   aAdd( aCalAlbCli, { "nTotArt",                                                   "N", 16,  6, "Total artículos",             "cPicUndAlb",  "" } )
   aAdd( aCalAlbCli, { "nTotCaj",                                                   "N", 16,  6, "Total cajas",                 "cPicUndAlb",  "" } )
   aAdd( aCalAlbCli, { "aTotIva[1,1]",                                              "N", 16,  6, "Bruto primer tipo de " + cImp(),    "cPorDivAlb",  "aTotIva[1,1] != 0" } )
   aAdd( aCalAlbCli, { "aTotIva[2,1]",                                              "N", 16,  6, "Bruto segundo tipo de " + cImp(),   "cPorDivAlb",  "aTotIva[2,1] != 0" } )
   aAdd( aCalAlbCli, { "aTotIva[3,1]",                                              "N", 16,  6, "Bruto tercer tipo de " + cImp(),    "cPorDivAlb",  "aTotIva[3,1] != 0" } )
   aAdd( aCalAlbCli, { "aTotIva[1,2]",                                              "N", 16,  6, "Base primer tipo de " + cImp(),     "cPorDivAlb",  "aTotIva[1,2] != 0" } )
   aAdd( aCalAlbCli, { "aTotIva[2,2]",                                              "N", 16,  6, "Base segundo tipo de " + cImp(),    "cPorDivAlb",  "aTotIva[2,2] != 0" } )
   aAdd( aCalAlbCli, { "aTotIva[3,2]",                                              "N", 16,  6, "Base tercer tipo de " + cImp(),     "cPorDivAlb",  "aTotIva[3,2] != 0" } )
   aAdd( aCalAlbCli, { "aTotIva[1,3]",                                              "N",  5,  2, "Porcentaje primer tipo " + cImp(),  "'@R 99.99%'", "aTotIva[1,3] != 0" } )
   aAdd( aCalAlbCli, { "aTotIva[2,3]",                                              "N",  5,  2, "Porcentaje segundo tipo " + cImp(), "'@R 99.99%'", "aTotIva[2,3] != 0" } )
   aAdd( aCalAlbCli, { "aTotIva[3,3]",                                              "N",  5,  2, "Porcentaje tercer tipo " + cImp(),  "'@R 99.99%'", "aTotIva[3,3] != 0" } )
   aAdd( aCalAlbCli, { "aTotIva[1,4]",                                              "N",  5,  2, "Porcentaje primer tipo RE",   "'@R 99.99%'", "aTotIva[1,4] != 0" } )
   aAdd( aCalAlbCli, { "aTotIva[2,4]",                                              "N",  5,  2, "Porcentaje segundo tipo RE",  "'@R 99.99%'", "aTotIva[2,4] != 0" } )
   aAdd( aCalAlbCli, { "aTotIva[3,4]",                                              "N",  5,  2, "Porcentaje tercer tipo RE",   "'@R 99.99%'", "aTotIva[3,4] != 0" } )
   aAdd( aCalAlbCli, { "round( aTotIva[1,2] * aTotIva[1,3] / 100, nDouDivAlb )",    "N", 16,  6, "Importe primer tipo " + cImp(),     "cPorDivAlb",  "aTotIva[1,2] != 0" } )
   aAdd( aCalAlbCli, { "round( aTotIva[2,2] * aTotIva[2,3] / 100, nDouDivAlb )",    "N", 16,  6, "Importe segundo tipo " + cImp(),    "cPorDivAlb",  "aTotIva[2,2] != 0" } )
   aAdd( aCalAlbCli, { "round( aTotIva[3,2] * aTotIva[3,3] / 100, nDouDivAlb )",    "N", 16,  6, "Importe tercer tipo " + cImp(),     "cPorDivAlb",  "aTotIva[3,2] != 0" } )
   aAdd( aCalAlbCli, { "round( aTotIva[1,2] * aTotIva[1,4] / 100, nDouDivAlb )",    "N", 16,  6, "Importe primer RE",           "cPorDivAlb",  "aTotIva[1,2] != 0" } )
   aAdd( aCalAlbCli, { "round( aTotIva[2,2] * aTotIva[2,4] / 100, nDouDivAlb )",    "N", 16,  6, "Importe segundo RE",          "cPorDivAlb",  "aTotIva[2,2] != 0" } )
   aAdd( aCalAlbCli, { "round( aTotIva[3,2] * aTotIva[3,4] / 100, nDouDivAlb )",    "N", 16,  6, "Importe tercer RE",           "cPorDivAlb",  "aTotIva[3,2] != 0" } )
   aAdd( aCalAlbCli, { "nTotBrt",                                                   "N", 16,  6, "Total bruto",                 "cPorDivAlb",  "lEnd" }              )
   aAdd( aCalAlbCli, { "nTotDto",                                                   "N", 16,  6, "Total descuento",             "cPorDivAlb",  "lEnd" }              )
   aAdd( aCalAlbCli, { "nTotDpp",                                                   "N", 16,  6, "Total descuento pronto pago", "cPorDivAlb",  "lEnd" }              )
   aAdd( aCalAlbCli, { "nTotUno",                                                   "N", 16,  6, "Total primer descuento personalizable",  "cPorDivAlb",  "lEnd" }   )
   aAdd( aCalAlbCli, { "nTotDos",                                                   "N", 16,  6, "Total segundo descuento personalizable", "cPorDivAlb",  "lEnd" }   )
   aAdd( aCalAlbCli, { "nTotNet",                                                   "N", 16,  6, "Total neto",                  "cPorDivAlb",  "lEnd" }              )
   aAdd( aCalAlbCli, { "nTotIva",                                                   "N", 16,  6, "Total " + cImp(),                   "cPorDivAlb",  "lEnd" }              )
   aAdd( aCalAlbCli, { "nTotIvm",                                                   "N", 16,  6, "Total IVMH",                  "cPorDivAlb",  "lEnd" }              )
   aAdd( aCalAlbCli, { "nTotReq",                                                   "N", 16,  6, "Total RE",                    "cPorDivAlb",  "lEnd" }              )
   aAdd( aCalAlbCli, { "nTotAlb",                                                   "N", 16,  6, "Total albarán",               "cPorDivAlb",  "lEnd" }              )
   aAdd( aCalAlbCli, { "nTotPage",                                                  "N", 16,  6, "Total página",                "cPorDivAlb",  "!lEnd"}              )
   aAdd( aCalAlbCli, { "nTotPes",                                                   "N", 16,  6, "Total peso",                  "'@E 99,999.99'","lEnd" }            )
   aAdd( aCalAlbCli, { "nTotCos",                                                   "N", 16,  6, "Total costo",                 "cPorDivAlb",  "lEnd" }            )
   aAdd( aCalAlbCli, { "nImpEuros( nTotAlb, (cDbf)->cDivAlb, cDbfDiv )",            "N", 16,  6, "Total albarán (Euros)",       "",            "lEnd" }              )
   aAdd( aCalAlbCli, { "nImpPesetas( nTotAlb, (cDbf)->cDivAlb, cDbfDiv )",          "N", 16,  6, "Total albarán (Pesetas)",     "",            "lEnd" }              )
   aAdd( aCalAlbCli, { "nPagina",                                                   "N",  2,  0, "Número de página",            "'99'",        "" }                  )
   aAdd( aCalAlbCli, { "lEnd",                                                      "L",  1,  0, "Fin del documento",           "",            "" }                  )

Return ( aCalAlbCli )

//---------------------------------------------------------------------------//

Function aCocAlbCli()

   local aCocAlbCli  := {}

   aAdd( aCocAlbCli, { "( Descrip( cDbfCol ) )",                                                   "C", 100,0, "Detalle del artículo",           "",            "Descripción", "" } )
   aAdd( aCocAlbCli, { "( nTotNAlbCli( cDbfCol ) )",                                               "N", 16, 6, "Total unidades",                 "cPicUndAlb",  "Unds.",       "" } )
   aAdd( aCocAlbCli, { "( nTotUAlbCli( cDbfCol, nDouDivAlb, nVdvDivAlb ) )",                       "N", 16, 6, "Precio unitario",                "cPouDivAlb",  "Precio",      "" } )
   aAdd( aCocAlbCli, { "( nNetUAlbCli( cDbfCol, nDouDivAlb, nVdvDivAlb, .f. ) )",                  "N", 16, 6, "Precio unitario sin " + cImp(),     "cPouDivAlb",  "Precio",      "" } )
   aAdd( aCocAlbCli, { "( nTotPAlbCli( cDbfCol, nVdvDivAlb ) )",                                   "N", 16, 6, "Precio unitario con descuentos", "cPouDivAlb",  "Precio",      "" } )
   aAdd( aCocAlbCli, { "( nPesLAlbCli( cDbfCol ) )",                                               "N", 16, 6, "Total peso por línea",           "'@E 999,999.99'","Peso",     "" } )
   aAdd( aCocAlbCli, { "( nTotLAlbCli( cDbfCol, nDouDivAlb, nRouDivAlb, nVdvDivAlb ) )",           "N", 16, 6, "Total linea de albarán",         "cPorDivAlb",  "Total",       "" } )
   aAdd( aCocAlbCli, { "( nNetLAlbCli( cDbf, cDbfCol, nDouDivAlb, nRouDivAlb, nVdvDivAlb, .f. ) )","N", 16, 6, "Total linea sin " + cImp(),         "cPorDivAlb",  "Total",       "" } )
   aAdd( aCocAlbCli, { "cFrasePublicitaria( cDbfCol )",                                            "C", 50, 0, "Texto de frase publicitaria",    "",            "Publicidad",  "" } )

Return ( aCocAlbCli )

//---------------------------------------------------------------------------//

function aSerAlbCli()

   local aColAlbCli  := {}

   aAdd( aColAlbCli,  { "cSerAlb",     "C",  1,   0, "",                                 "",                  "", "( cDbfCol )" } )
   aAdd( aColAlbCli,  { "nNumAlb",     "N",  9,   0, "",                                 "",                  "", "( cDbfCol )" } )
   aAdd( aColAlbCli,  { "cSufAlb",     "C",  2,   0, "",                                 "",                  "", "( cDbfCol )" } )
   aAdd( aColAlbCli,  { "dFecAlb",     "D",  8,   0, "",                                 "",                  "", "( cDbfCol )" } )
   aAdd( aColAlbCli,  { "nNumLin",     "N",  4,   0, "Número de la línea",               "'9999'",            "", "( cDbfCol )" } )
   aAdd( aColAlbCli,  { "lFacturado",  "L",  1,   0, "Lógico de facturado",              "",                  "", "( cDbfCol )" } )
   aAdd( aColAlbCli,  { "lUndNeg",     "L",  1,   0, "Lógico de unidades en negativo",   "",                  "", "( cDbfCol )" } )
   aAdd( aColAlbCli,  { "cRef",        "C", 18,   0, "Referencia del artículo",          "",                  "", "( cDbfCol )" } )
   aAdd( aColAlbCli,  { "cAlmLin",     "C",  3,   0, "Almacen del artículo",             "",                  "", "( cDbfCol )" } )
   aAdd( aColAlbCli,  { "cNumSer",     "C", 30,   0, "Número de serie",                  "",                  "", "( cDbfCol )" } )

return ( aColAlbCli )

//---------------------------------------------------------------------------//

Static Function RecAlbCli( aTmpAlb, oDlg )

	local nDtoAge
   local nRecno
   local cCodFam
   local nImpAtp  := 0
   local nImpOfe  := 0

   if !ApoloMsgNoYes( "¡Atención!,"                                      + CRLF + ;
                  "todos los precios se recalcularán en función de"  + CRLF + ;
                  "los valores en las bases de datos.",;
                  "¿ Desea proceder ?" )
      return nil
   end if

   oDlg:aEvalWhen()

   ( dbfArticulo )->( ordSetFocus( "Codigo" ) )

   nRecno         := ( dbfTmpLin )->( RecNo() )

   ( dbfTmpLin )->( dbGotop() )
   while !( dbfTmpLin )->( eof() )

      /*
      Ahora buscamos por el codigo interno
      */

      if ( dbfArticulo )->( dbSeek( ( dbfTmpLin )->cRef ) )

         if aTmpAlb[ _NREGIVA ] <= 1
            ( dbfTmpLin )->nIva     := nIva( dbfIva, ( dbfArticulo )->TipoIva )
            ( dbfTmpLin )->nReq     := nReq( dbfIva, ( dbfArticulo )->TipoIva )
         end if

         /*
         Ahora recogemos el impuesto especial si lo hay
         */

         if !Empty( ( dbfArticulo )->cCodImp )
            ( dbfTmpLin )->cCodImp  := ( dbfArticulo )->cCodImp
            ( dbfTmpLin )->nValImp  := oNewImp:nValImp( ( dbfArticulo )->cCodImp, aTmpAlb[ _LIVAINC ], ( dbfTmpLin )->nIva )
         end if

         /*
         Tomamos los precios de la base de datos de articulos---------------------
         */

         ( dbfTmpLin )->nPreUnit    := nRetPreArt( ( dbfTmpLin )->nTarLin, aTmpAlb[ _CDIVALB ], aTmpAlb[ _LIVAINC ], dbfArticulo, dbfDiv, dbfKit, dbfIva )

         /*
         Linea por contadores-----------------------------------------------------
         */

         ( dbfTmpLin )->nCtlStk     := ( dbfArticulo )->nCtlStock
         ( dbfTmpLin )->nPvpRec     := ( dbfArticulo )->PvpRec
         ( dbfTmpLin )->nCosDiv     := nCosto( nil, dbfArticulo, dbfKit )

         /*
         Punto verde--------------------------------------------------------------
         */

         ( dbfTmpLin )->nPntVer     := ( dbfArticulo )->nPntVer1

         /*
         Chequeamos situaciones especiales y comprobamos las fechas
         */

         do case
         case lSeekAtpArt( aTmpAlb[ _CCODCLI ] + ( dbfTmpLin )->cRef, ( dbfTmpLin )->cCodPr1 + ( dbfTmpLin )->cCodPr2, ( dbfTmpLin )->cValPr1 + ( dbfTmpLin )->cValPr2, aTmpAlb[ _DFECALB ], dbfCliAtp ) .and. ;
               ( dbfCliAtp )->lAplAlb

               nImpAtp              := nImpAtp( ( dbfTmpLin )->nTarLin, dbfCliAtp )
               if nImpAtp != 0
                  ( dbfTmpLin )->nPreUnit := nImpAtp
               end if

               nImpAtp              := nDtoAtp( ( dbfTmpLin )->nTarLin, dbfCliAtp )
               if nImpAtp != 0
                  ( dbfTmpLin )->nDto     := nImpAtp
               end if

               if ( dbfCliAtp )->nDprArt != 0
                  ( dbfTmpLin )->nDtoPrm  := ( dbfCliAtp )->nDprArt
               end if

               if ( dbfCliAtp )->nComAge != 0
                  ( dbfTmpLin )->nComAge  := ( dbfCliAtp )->nComAge
               end if

         /*
         Precios en tarifas----------------------------------------------------
         */

         case !Empty( aTmpAlb[ _CCODTAR ] )

            cCodFam  := RetFamArt( ( dbfTmpLin )->cRef, dbfArticulo )

            nImpOfe  := RetPrcTar( ( dbfTmpLin )->cRef, aTmpAlb[ _CCODTAR ], ( dbfTmpLin )->cCodPr1, ( dbfTmpLin )->cCodPr2, ( dbfTmpLin )->cValPr1, ( dbfTmpLin )->cValPr2, dbfTarPreL, ( dbfTmpLin )->nTarLin )
            if nImpOfe != 0
               ( dbfTmpLin )->nPreUnit := nImpOfe
            end if

            nImpOfe  := RetPctTar( ( dbfTmpLin )->cRef, cCodFam, aTmpAlb[ _CCODTAR ], ( dbfTmpLin )->cCodPr1, ( dbfTmpLin )->cCodPr2, ( dbfTmpLin )->cValPr1, ( dbfTmpLin )->cValPr2, dbfTarPreL )
            if nImpOfe != 0
               ( dbfTmpLin )->nDto     := nImpOfe
            end if

            nImpOfe  := RetComTar( ( dbfTmpLin )->cRef, cCodFam, aTmpAlb[ _CCODTAR ], ( dbfTmpLin )->cCodPr1, ( dbfTmpLin )->cCodPr2, ( dbfTmpLin )->cValPr1, ( dbfTmpLin )->cValPr2, aTmpAlb[ _CCODAGE ], dbfTarPreL, dbfTarPreS )

            if nImpOfe != 0
               ( dbfTmpLin )->nComAge  := nImpOfe
            end if

            /*
            Descuento de promoci¢n, esta funci¢n comprueba si existe y si es
            asi devuelve el descunto de la promoci¢n.
            */

            nImpOfe     := RetDtoPrm( ( dbfTmpLin )->cRef, cCodFam, aTmpAlb[ _CCODTAR ], ( dbfTmpLin )->cCodPr1, ( dbfTmpLin )->cCodPr2, ( dbfTmpLin )->cValPr1, ( dbfTmpLin )->cValPr2, aTmpAlb[ _DFECALB ], dbfTarPreL )
            if nImpOfe  != 0
               ( dbfTmpLin )->nDtoPrm  := nImpOfe
            end if

            /*
            Obtenemos el descuento de Agente
            */

            nDtoAge     := RetDtoAge( ( dbfTmpLin )->cRef, cCodFam, aTmpAlb[ _CCODTAR ], ( dbfTmpLin )->cCodPr1, ( dbfTmpLin )->cCodPr2, ( dbfTmpLin )->cValPr1, ( dbfTmpLin )->cValPr2, aTmpAlb[ _DFECALB ], aTmpAlb[ _CCODAGE ], dbfTarPreL, dbfTarPreS )

            if nDtoAge  != 0
               ( dbfTmpLin )->nComAge  := nDtoAge
            end if

         end case

         /*
         Buscamos si existen ofertas para este articulo y le cambiamos el precio
         */

         nImpOfe     := nImpOferta( ( dbfTmpLin )->cRef, aTmpAlb[ _CCODCLI ], aTmpAlb[ _CCODGRP ], ( dbfTmpLin )->nUniCaja, aTmpAlb[ _DFECALB ], dbfOferta, ( dbfTmpLin )->nTarLin, nil, ( dbfTmpLin )->cCodPr1, ( dbfTmpLin )->cCodPr2, ( dbfTmpLin )->cValPr1, ( dbfTmpLin )->cValPr2 )
         if nImpOfe  != 0
            ( dbfTmpLin )->nPreUnit := nCnv2Div( nImpOfe, cDivEmp(), aTmpAlb[ _CDIVALB ], dbfDiv )
         end if

         /*
         Buscamos si existen descuentos en las ofertas
         */

         nImpOfe     := nDtoOferta( ( dbfTmpLin )->cRef, aTmpAlb[ _CCODCLI ], aTmpAlb[ _CCODGRP ], ( dbfTmpLin )->nUniCaja, aTmpAlb[ _DFECALB ], dbfOferta, ( dbfTmpLin )->cCodPr1, ( dbfTmpLin )->cCodPr2, ( dbfTmpLin )->cValPr1, ( dbfTmpLin )->cValPr2 )
         if nImpOfe  != 0
            ( dbfTmpLin )->nDtoPrm  := nImpOfe
         end if

      end if

      ( dbfTmpLin )->( dbSkip() )

   end while

   ( dbfTmpLin )->( dbGoTo( nRecno ) )

return nil

//--------------------------------------------------------------------------//

function SynAlbCli( cPath )

   local oError
   local oBlock
   local aTotAlb
   local cCodImp
   local cNumSer
   local aNumSer
   local cNumPed
   local aNumPed     := {}

   DEFAULT cPath     := cPatEmp()

   oBlock            := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   dbUseArea( .t., cDriver(), cPath + "ALBCLIT.DBF", cCheckArea( "ALBCLIT", @dbfAlbCliT ), .f. )
   if !lAIS(); ordListAdd( cPath + "ALBCLIT.CDX" ); else ; ordSetFocus( 1 ) ; end

   dbUseArea( .t., cDriver(), cPath + "ALBCLIL.DBF", cCheckArea( "ALBCLIL", @dbfAlbCliL ), .f. )
   if !lAIS(); ordListAdd( cPath + "ALBCLIL.CDX" ); else ; ordSetFocus( 1 ) ; end

   dbUseArea( .t., cDriver(), cPath + "ALBCLIS.DBF", cCheckArea( "ALBCLIS", @dbfAlbCliS ), .f. )
   if !lAIS(); ordListAdd( cPath + "ALBCLIS.CDX" ); else ; ordSetFocus( 1 ) ; end

   dbUseArea( .t., cDriver(), cPath + "ALBCLII.DBF", cCheckArea( "ALBCLII", @dbfAlbCliI ), .f. )
   if !lAIS(); ordListAdd( cPath + "ALBCLII.CDX" ); else ; ordSetFocus( 1 ) ; end

   dbUseArea( .t., cDriver(), cPath + "ALBCLIP.DBF", cCheckArea( "ALBCLIP", @dbfAlbCliP ), .f. )
   if !lAIS(); ordListAdd( cPath + "ALBCLIP.CDX" ); else ; ordSetFocus( 1 ) ; end

   dbUseArea( .t., cDriver(), cPatArt() + "FAMILIAS.DBF", cCheckArea( "FAMILIAS", @dbfFamilia ), .f. )
   if !lAIS(); ordListAdd( cPatArt() + "FAMILIAS.CDX" ); else ; ordSetFocus( 1 ) ; end

   dbUseArea( .t., cDriver(), cPatArt() + "ARTICULO.DBF", cCheckArea( "ARTICULO", @dbfArticulo ), .f. )
   if !lAIS(); ordListAdd( cPatArt() + "ARTICULO.CDX" ); else ; ordSetFocus( 1 ) ; end

   dbUseArea( .t., cDriver(), cPatCli() + "CLIENT.DBF", cCheckArea( "CLIENT", @dbfClient ), .f. )
   if !lAIS(); ordListAdd( cPatCli() + "CLIENT.CDX" ); else ; ordSetFocus( 1 ) ; end

   dbUseArea( .t., cDriver(), cPatDat() + "TIVA.DBF", cCheckArea( "TIVA", @dbfIva ), .t. )
   if !lAIS(); ordListAdd( cPatDat() + "TIVA.CDX" ); else ; ordSetFocus( 1 ) ; end

   dbUseArea( .t., cDriver(), cPatDat() + "DIVISAS.DBF", cCheckArea( "DIVISAS", @dbfDiv ), .t. )
   if !lAIS(); ordListAdd( cPatDat() + "DIVISAS.CDX" ); else ; ordSetFocus( 1 ) ; end

   dbUseArea( .t., cDriver(), cPath + "PEDCLIT.DBF", cCheckArea( "PEDCLIT", @dbfPedCliT ), .f. )
   if !lAIS(); ordListAdd( cPath + "PEDCLIT.CDX" ); else ; ordSetFocus( 1 ) ; end

   dbUseArea( .t., cDriver(), cPath + "PEDCLIL.DBF", cCheckArea( "PEDCLIL", @dbfPedCliL ), .f. )
   if !lAIS(); ordListAdd( cPath + "PEDCLIL.CDX" ); else ; ordSetFocus( 1 ) ; end

   dbUseArea( .t., cDriver(), cPath + "FACCLIL.DBF", cCheckArea( "FACCLIL", @dbfFacCliL ), .f. )
   if !lAIS(); ordListAdd( cPath + "FACCLIL.CDX" ); else ; ordSetFocus( 1 ) ; end

   oNewImp              := TNewImp():Create( cPatEmp() )
   if !oNewImp:OpenFiles()
      lOpenFiles     := .f.
   end if

   while !( dbfAlbCliT )->( eof() )

      if Empty( ( dbfAlbCliT )->cSufAlb )
         ( dbfAlbCliT )->cSufAlb := "00"
      end if

      if Empty( ( dbfAlbCliT )->cCodCaj )
         ( dbfAlbCliT )->cCodCaj := "000"
      end if

      if Empty( ( dbfAlbCliT )->cCodGrp )
         ( dbfAlbCliT )->cCodGrp := RetGrpCli( ( dbfAlbCliT )->cCodCli, dbfClient )
      end if

      if Empty( ( dbfAlbCliT )->cNomCli ) .and. !Empty ( ( dbfAlbCliT )->cCodCli )
         ( dbfAlbCliT )->cNomCli    := RetFld( ( dbfAlbCliT )->cCodCli, dbfClient, "Titulo" )
      end if

      /*
      Rellenamos los campos de totales-----------------------------------------
      */

      if ( dbfAlbCliT )->nTotAlb == 0 .and. dbLock( dbfAlbCliT )

         aTotAlb                 := aTotAlbCli( ( dbfAlbCliT )->cSerAlb + Str( ( dbfAlbCliT )->nNumAlb ) + ( dbfAlbCliT )->cSufAlb, dbfAlbCliT, dbfAlbCliL, dbfIva, dbfDiv, ( dbfAlbCliT )->cDivAlb )

         ( dbfAlbCliT )->nTotNet := aTotAlb[1]
         ( dbfAlbCliT )->nTotIva := aTotAlb[2]
         ( dbfAlbCliT )->nTotReq := aTotAlb[3]
         ( dbfAlbCliT )->nTotAlb := aTotAlb[4]

         ( dbfAlbCliT )->( dbUnLock() )

      end if

      /*
      Rellenamos los campos de totales-----------------------------------------
      */

      if ( dbfAlbCliT )->nTotPag == 0 .and. dbLock( dbfAlbCliT )
         ( dbfAlbCliT )->nTotPag := nPagAlbCli( ( dbfAlbCliT )->cSerAlb + Str( ( dbfAlbCliT )->nNumAlb ) + ( dbfAlbCliT )->cSufAlb, dbfAlbCliP, dbfDiv )
         ( dbfAlbCliT )->( dbUnLock() )
      end if

      /*
      Si el albarán está creado desde un pedido le revisamos el estado---------
      */

      aAdd( aNumPed, ( dbfAlbCliT )->cNumPed )

      ( dbfAlbCliT )->( dbSkip() )

   end while

   while !( dbfAlbCliL )->( eof() )

      if Empty( ( dbfAlbCliL )->cSufAlb )
         ( dbfAlbCliL )->cSufAlb    := "00"
      end if

      if Empty( ( dbfAlbCliL )->cLote ) .and. !Empty( ( dbfAlbCliL )->nLote )
         ( dbfAlbCliL )->cLote      := AllTrim( Str( ( dbfAlbCliL )->nLote ) )
      end if

      if Empty( ( dbfAlbCliL )->nValImp )
         cCodImp                    := RetFld( ( dbfAlbCliL )->CREF, dbfArticulo, "cCodImp" )
         if !Empty( cCodImp )
            ( dbfAlbCliL )->nValImp := oNewImp:nValImp( cCodImp )
         end if
      end if

      if Empty( ( dbfAlbCliL )->nVolumen )
         ( dbfAlbCliL )->nVolumen   := RetFld( ( dbfAlbCliL )->CREF, dbfArticulo, "nVolumen" )
      end if

      if ( dbfAlbCliL )->lIvaLin != RetFld( ( dbfAlbCliL )->cSerAlb + Str( ( dbfAlbCliL )->nNumAlb ) + ( dbfAlbCliL )->cSufAlb, dbfAlbCliT, "lIvaInc" )
         ( dbfAlbCliL )->lIvaLin    := RetFld( ( dbfAlbCliL )->cSerAlb + Str( ( dbfAlbCliL )->nNumAlb ) + ( dbfAlbCliL )->cSufAlb, dbfAlbCliT, "lIvaInc" )
      end if

      if !Empty( ( dbfAlbCliL )->cRef ) .and. Empty( ( dbfAlbCliL )->cCodFam )
         ( dbfAlbCliL )->cCodFam    := RetFamArt( ( dbfAlbCliL )->cRef, dbfArticulo )
      end if

      if !Empty( ( dbfAlbCliL )->cRef ) .and. !Empty( ( dbfAlbCliL )->cCodFam )
         ( dbfAlbCliL )->cGrpFam    := cGruFam( ( dbfAlbCliL )->cCodFam, dbfFamilia )
      end if

      if Empty( ( dbfAlbCliL )->nReq )
         ( dbfAlbCliL )->nReq       := nPReq( dbfIva, ( dbfAlbCliL )->nIva )
      end if

      if ( dbfAlbCliL )->lFacturado != RetFld( ( dbfAlbCliL )->cSerAlb + Str( ( dbfAlbCliL )->nNumAlb ) + ( dbfAlbCliL )->cSufAlb, dbfAlbCliT, "lFacturado" )
         ( dbfAlbCliL )->lFacturado := RetFld( ( dbfAlbCliL )->cSerAlb + Str( ( dbfAlbCliL )->nNumAlb ) + ( dbfAlbCliL )->cSufAlb, dbfAlbCliT, "lFacturado" )
      end if

      if ( dbfAlbCliL )->dFecAlb != RetFld( ( dbfAlbCliL )->cSerAlb + Str( ( dbfAlbCliL )->nNumAlb ) + ( dbfAlbCliL )->cSufAlb, dbfAlbCliT, "dFecAlb" )
         ( dbfAlbCliL )->dFecAlb    := RetFld( ( dbfAlbCliL )->cSerAlb + Str( ( dbfAlbCliL )->nNumAlb ) + ( dbfAlbCliL )->cSufAlb, dbfAlbCliT, "dFecAlb" )
      end if

      if !Empty( ( dbfAlbCliL )->mNumSer )
         aNumSer                       := hb_aTokens( ( dbfAlbCliL )->mNumSer, "," )
         for each cNumSer in aNumSer
            ( dbfAlbCliS )->( dbAppend() )
            ( dbfAlbCliS )->cSerAlb    := ( dbfAlbCliL )->cSerAlb
            ( dbfAlbCliS )->nNumAlb    := ( dbfAlbCliL )->nNumAlb
            ( dbfAlbCliS )->cSufAlb    := ( dbfAlbCliL )->cSufAlb
            ( dbfAlbCliS )->cRef       := ( dbfAlbCliL )->cRef
            ( dbfAlbCliS )->cAlmLin    := ( dbfAlbCliL )->cAlmLin
            ( dbfAlbCliS )->nNumLin    := ( dbfAlbCliL )->nNumLin
            ( dbfAlbCliS )->lFacturado := ( dbfAlbCliL )->lFacturado
            ( dbfAlbCliS )->cNumSer    := cNumSer
         next
         ( dbfAlbCliL )->mNumSer       := ""
      end if

      ( dbfAlbCliL )->( dbSkip() )

      SysRefresh()

   end while

   while !( dbfAlbCliI )->( eof() )

      if Empty( ( dbfAlbCliI )->cSufAlb )
         ( dbfAlbCliI )->cSufAlb    := "00"
      end if

      ( dbfAlbCliI )->( dbSkip() )

      SysRefresh()

   end while

   // Series ---------------------------------------------------------------

   while !( dbfAlbCliS )->( eof() )

      if Empty( ( dbfAlbCliS )->cSufAlb )
         ( dbfAlbCliS )->cSufAlb    := "00"
      end if

      if ( dbfAlbCliS )->dFecAlb != RetFld( ( dbfAlbCliL )->cSerAlb + Str( ( dbfAlbCliL )->nNumAlb ) + ( dbfAlbCliL )->cSufAlb, dbfAlbCliT, "dFecAlb" )
         ( dbfAlbCliS )->dFecAlb    := RetFld( ( dbfAlbCliL )->cSerAlb + Str( ( dbfAlbCliL )->nNumAlb ) + ( dbfAlbCliL )->cSufAlb, dbfAlbCliT, "dFecAlb" )
      end if

      ( dbfAlbCliS )->( dbSkip() )

      SysRefresh()

   end while

   RECOVER USING oError

      msgStop( "Imposible sincronizar albaranes de clientes" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   if !Empty( dbfAlbCliT ) .and. ( dbfAlbCliT )->( Used() )
      ( dbfAlbCliT )->( dbCloseArea() )
   end if

   if !Empty( dbfAlbCliL ) .and. ( dbfAlbCliL )->( Used() )
      ( dbfAlbCliL )->( dbCloseArea() )
   end if

   if !Empty( dbfAlbCliS ) .and. ( dbfAlbCliS )->( Used() )
      ( dbfAlbCliS )->( dbCloseArea() )
   end if

   if !Empty( dbfAlbCliI ) .and. ( dbfAlbCliI )->( Used() )
      ( dbfAlbCliI )->( dbCloseArea() )
   end if

   if !Empty( dbfAlbCliP ) .and. ( dbfAlbCliP )->( Used() )
      ( dbfAlbCliP )->( dbCloseArea() )
   end if

   if !Empty( dbfArticulo ) .and. ( dbfArticulo )->( Used() )
      ( dbfArticulo )->( dbCloseArea() )
   end if

   if !Empty( dbfFamilia ) .and. ( dbfFamilia )->( Used() )
      ( dbfFamilia )->( dbCloseArea() )
   end if

   if !Empty( dbfClient ) .and. ( dbfClient )->( Used() )
      ( dbfClient )->( dbCloseArea() )
   end if

   if !Empty( dbfIva ) .and. ( dbfIva )->( Used() )
      ( dbfIva )->( dbCloseArea() )
   end if

   if !Empty( dbfDiv ) .and. ( dbfDiv )->( Used() )
      ( dbfDiv )->( dbCloseArea() )
   end if

   if !Empty( dbfPedCliT ) .and. ( dbfPedCliT )->( Used() )
      ( dbfPedCliT )->( dbCloseArea() )
   end if

   if !Empty( dbfPedCliL ) .and. ( dbfPedCliL )->( Used() )
      ( dbfPedCliL )->( dbCloseArea() )
   end if

   if !Empty( dbfFacCliL ) .and. ( dbfFacCliL )->( Used() )
      ( dbfFacCliL )->( dbCloseArea() )
   end if

   if !Empty( oNewImp )
      oNewImp:end()
   end if

   oNewImp     := nil

   /*
   Estado de los pedidos-------------------------------------------------------
   */

   oStock               := TStock():Create()
   if oStock:lOpenFiles()

      for each cNumPed in aNumPed
         oStock:SetEstadoPedCli( cNumPed )
      end if

   end if
       
   if !Empty( oStock )
      oStock:end()
   end if

   oStock      := nil

return nil

//------------------------------------------------------------------------//

Function lGetUsuario( oGetUsuario, dbfUsr )

   local oDlg
   local oCodigoUsuario
   local cCodigoUsuario := Space( 3 )
   local oNombreUsuario
   local cNombreUsuario := ""

   if !lRecogerUsuario()
      Return .t.
   end if

   DEFINE DIALOG oDlg RESOURCE "GetUsuario"

      REDEFINE GET oCodigoUsuario ;
         VAR      cCodigoUsuario ;
         ID       100 ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwUser( oCodigoUsuario, dbfUsr ) ) ;
         VALID    ( SetUsuario( oCodigoUsuario, oNombreUsuario, oDlg, dbfUsr ) ) ;
         OF       oDlg

      REDEFINE GET oNombreUsuario ;
         VAR      cNombreUsuario ;
         ID       110 ;
         WHEN     ( .f. ) ;
         OF       oDlg

      REDEFINE BUTTON ;
         ID       IDOK ;
         OF       oDlg ;
         ACTION   ( if( oCodigoUsuario:lValid(), oDlg:end( IDOK ), ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
         OF       oDlg ;
         CANCEL ;
         ACTION   ( oDlg:end() )

      oDlg:bStart       := { || oCodigoUsuario:SetFocus(), oCodigoUsuario:SelectAll() }
      oDlg:bKeyDown     := { | nKey | if( nKey == 65 .and. GetKeyState( VK_CONTROL ), CreateInfoArticulo(), 0 ) }

   ACTIVATE DIALOG oDlg CENTER

   if oDlg:nResult == IDOK

      oCodigoUsuario:cText( cCodigoUsuario )
      oCodigoUsuario:lValid()

      if !Empty( oGetUsuario )
         oGetUsuario:cText( cCodigoUsuario )
         oGetUsuario:lValid()
      end if

   end if

Return ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

Function SetUsuario( oCodUsr, oSay, oDlg, dbfUsr )

   local lSetUsr  := .t.
   local cCodUsr  := oCodUsr:VarGet()

   if ( dbfUsr )->( dbSeek( cCodUsr ) )
      oSay:cText( Rtrim( ( dbfUsr )->cNbrUse ) )
      if !Empty( oDlg )
         oDlg:End( IDOK )
      end if
   else
      oCodUsr:cText( Space( 3 ) )
      lSetUsr     := .f.
   end if

Return ( lSetUsr )

//---------------------------------------------------------------------------//

Static Function EdtEnt( aTmp, aGet, dbfTmpPgo, oBrw, bWhen, bValid, nMode, aTmpAlb )

   local oDlg
   local oFld
   local oBmp
   local oFpago
   local cFpago
   local oBmpDiv
   local oGetCli
   local cGetCli
   local oGetAge
   local cGetAge
   local oGetCaj
   local cGetCaj
   local cPorDiv
   local oBmpBancos

   DEFAULT aTmpAlb   := dbScatter( dbfAlbCliT )

   do case
      case nMode == APPD_MODE

         aTmp[ ( dbfTmpPgo )->( FieldPos( "cTurRec" ) ) ]      := cCurSesion()
         aTmp[ ( dbfTmpPgo )->( FieldPos( "cCodCaj" ) ) ]      := oUser():cCaja()

         aTmp[ ( dbfTmpPgo )->( FieldPos( "cSerAlb" ) ) ]      := aTmpAlb[ _CSERALB ]
         aTmp[ ( dbfTmpPgo )->( FieldPos( "nNumAlb" ) ) ]      := aTmpAlb[ _NNUMALB ]
         aTmp[ ( dbfTmpPgo )->( FieldPos( "cSufAlb" ) ) ]      := aTmpAlb[ _CSUFALB ]
         aTmp[ ( dbfTmpPgo )->( FieldPos( "cCodCli" ) ) ]      := aTmpAlb[ _CCODCLI ]
         aTmp[ ( dbfTmpPgo )->( FieldPos( "cCodAge" ) ) ]      := aTmpAlb[ _CCODAGE ]
         aTmp[ ( dbfTmpPgo )->( FieldPos( "cDivPgo" ) ) ]      := aTmpAlb[ _CDIVALB ]
         aTmp[ ( dbfTmpPgo )->( FieldPos( "cCodPgo" ) ) ]      := aTmpAlb[ _CCODPAGO]

         if dbSeekInOrd( aTmpAlb[ _CCODPAGO ], "cCodPago", dbfFPago ) .and. ( dbfFPago )->lUtlBnc

            aTmp[ ( dbfTmpPgo )->( FieldPos( "cBncEmp" ) ) ]   := ( dbfFPago )->cBanco
            aTmp[ ( dbfTmpPgo )->( FieldPos( "cEntEmp" ) ) ]   := ( dbfFPago )->cEntBnc
            aTmp[ ( dbfTmpPgo )->( FieldPos( "cSucEmp" ) ) ]   := ( dbfFPago )->cSucBnc
            aTmp[ ( dbfTmpPgo )->( FieldPos( "cDigEmp" ) ) ]   := ( dbfFPago )->cDigBnc
            aTmp[ ( dbfTmpPgo )->( FieldPos( "cCtaEmp" ) ) ]   := ( dbfFPago )->cCtaBnc

            aTmp[ ( dbfTmpPgo )->( FieldPos( "cBncCli" ) ) ]   := aTmpAlb[ _CBANCO  ]
            aTmp[ ( dbfTmpPgo )->( FieldPos( "cEntCli" ) ) ]   := aTmpAlb[ _CENTBNC ]
            aTmp[ ( dbfTmpPgo )->( FieldPos( "cSucCli" ) ) ]   := aTmpAlb[ _CSUCBNC ]
            aTmp[ ( dbfTmpPgo )->( FieldPos( "cDigCli" ) ) ]   := aTmpAlb[ _CDIGBNC ]
            aTmp[ ( dbfTmpPgo )->( FieldPos( "cCtaCli" ) ) ]   := aTmpAlb[ _CCTABNC ]

         end if

      case nMode == EDIT_MODE

         if aTmp[ ( dbfTmpPgo )->( FieldPos( "lCloPgo" ) ) ] .and. !oUser():lAdministrador()
            msgStop( "Solo pueden modificar las entregas cerradas los administradores." )
            return .f.
         end if

   end case

   cGetCli           := RetFld( aTmp[ ( dbfTmpPgo )->( FieldPos( "cCodCli" ) ) ], dbfClient, "Titulo" )
   cGetAge           := cNbrAgent( aTmp[ ( dbfTmpPgo )->( FieldPos( "cCodAge" ) ) ], dbfAgent )
   cGetCaj           := RetFld( aTmp[ ( dbfTmpPgo )->( FieldPos( "cCodCaj" ) ) ], dbfCajT, "cNomCaj" )
   cPorDiv           := cPorDiv(aTmp[ ( dbfTmpPgo )->( FieldPos( "cDivPgo" ) ) ], dbfDiv )
   cFPago            := RetFld( aTmp[ ( dbfTmpPgo )->( FieldPos( "cCodPgo" ) ) ], dbfFPago )

   DEFINE DIALOG  oDlg ;
         RESOURCE "Recibos" ;
         TITLE    LblTitle( nMode ) + "Entregas a cuenta"

      REDEFINE FOLDER oFld ;
         ID       500;
         OF       oDlg ;
         PROMPT   "&General",;
                  "Bancos";
         DIALOGS  "Entregas_1",;
                  "Recibos_4"

      REDEFINE BITMAP oBmp ;
         ID       500 ;
         RESOURCE "Money_Alpha_48" ;
         TRANSPARENT ;
         OF       oFld:aDialogs[ 1 ]

      //Importe

      REDEFINE GET aGet[ ( dbfTmpPgo )->( FieldPos( "nImporte" ) ) ];
         VAR      aTmp[ ( dbfTmpPgo )->( FieldPos( "nImporte" ) ) ] ;
         ID       160 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  ( cPorDiv ) ;
         OF       oFld:aDialogs[ 1 ]

      // Divisa

      REDEFINE GET aGet[ ( dbfTmpPgo )->( FieldPos( "cDivPgo" ) ) ] ;
         VAR      aTmp[ ( dbfTmpPgo )->( FieldPos( "cDivPgo" ) ) ];
         WHEN     ( .f. ) ;
         VALID    ( cDivOut( aGet[ ( dbfTmpPgo )->( FieldPos( "cDivPgo" ) ) ], oBmpDiv, aGet[ ( dbfTmpPgo )->( FieldPos( "nVdvPgo" ) ) ], nil, nil, @cPorDiv, nil, nil, nil, nil, dbfDiv, oBandera ) );
         PICTURE  "@!";
         ID       150 ;
         BITMAP   "LUPA" ;
         ON HELP  BrwDiv( aGet[ ( dbfTmpPgo )->( FieldPos( "cDivPgo" ) ) ], oBmpDiv, aGet[ ( dbfTmpPgo )->( FieldPos( "nVdvPgo" ) ) ], dbfDiv, oBandera ) ;
         OF       oFld:aDialogs[ 1 ]

      REDEFINE BITMAP oBmpDiv ;
         RESOURCE "BAN_EURO" ;
         ID       151;
         OF       oFld:aDialogs[ 1 ]

      // Forma de pago---------------------------------------------------------

      REDEFINE GET aGet[ ( dbfTmpPgo )->( FieldPos( "cCodPgo" ) ) ] VAR aTmp[ ( dbfTmpPgo )->( FieldPos( "cCodPgo" ) ) ] ;
         ID       180 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
			PICTURE  "@!" ;
         VALID    ( cFPago( aGet[ ( dbfTmpPgo )->( FieldPos( "cCodPgo" ) ) ], dbfFPago, oFpago ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwFPago( aGet[ ( dbfTmpPgo )->( FieldPos( "cCodPgo" ) ) ], oFpago ) ) ;
         OF       oFld:aDialogs[ 1 ]

      REDEFINE GET oFpago VAR cFpago ;
         ID       181 ;
			WHEN 		.F. ;
         OF       oFld:aDialogs[ 1 ]

      //Fecha

      REDEFINE GET aGet[ ( dbfTmpPgo )->( FieldPos( "dEntrega" ) ) ] ;
         VAR      aTmp[ ( dbfTmpPgo )->( FieldPos( "dEntrega" ) ) ] ;
         ID       100 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ON HELP  aGet[ ( dbfTmpPgo )->( FieldPos( "dEntrega" ) ) ]:cText( Calendario( aTmp[ ( dbfTmpPgo )->( FieldPos( "dEntrega" ) ) ] ) ) ;
         BITMAP   "LUPA" ;
         OF       oFld:aDialogs[ 1 ]

      REDEFINE GET aGet[ ( dbfTmpPgo )->( FieldPos( "cTurRec" ) ) ] VAR aTmp[ ( dbfTmpPgo )->( FieldPos( "cTurRec" ) ) ] ;
         ID       335 ;
         PICTURE  "999999" ;
         WHEN     ( nMode != ZOOM_MODE .and. lUsrMaster() ) ;
         OF       oFld:aDialogs[ 1 ]

      //Cliente

      REDEFINE GET aGet[ ( dbfTmpPgo )->( FieldPos( "cCodCli" ) ) ] ;
         VAR      aTmp[ ( dbfTmpPgo )->( FieldPos( "cCodCli" ) ) ] ;
         ID       110 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( cClient( aGet[ ( dbfTmpPgo )->( FieldPos( "cCodCli" ) ) ], dbfClient, oGetCli ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwClient( aGet[ ( dbfTmpPgo )->( FieldPos( "cCodCli" ) ) ], oGetCli ) ) ;
         OF       oFld:aDialogs[ 1 ]

      REDEFINE GET oGetCli VAR cGetCli ;
         ID       111 ;
         WHEN     .f.;
         OF       oFld:aDialogs[ 1 ]

      //Agente

      REDEFINE GET aGet[ ( dbfTmpPgo )->( FieldPos( "cCodAge" ) ) ];
         VAR      aTmp[ ( dbfTmpPgo )->( FieldPos( "cCodAge" ) ) ] ;
         ID       120 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         VALID    ( cAgentes( aGet[ ( dbfTmpPgo )->( FieldPos( "cCodAge" ) ) ], dbfAgent, oGetAge ) );
         BITMAP   "LUPA" ;
         ON HELP  ( BrwAgentes( aGet[ ( dbfTmpPgo )->( FieldPos( "cCodAge" ) ) ], oGetAge ) );
         OF       oFld:aDialogs[ 1 ]

      REDEFINE GET oGetAge VAR cGetAge ;
         ID       121 ;
         WHEN     .f.;
         OF       oFld:aDialogs[ 1 ]

      //Descripción

      REDEFINE GET aGet[ ( dbfTmpPgo )->( FieldPos( "cDescrip" ) ) ] ;
         VAR      aTmp[ ( dbfTmpPgo )->( FieldPos( "cDescrip" ) ) ] ;
         ID       130 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[ 1 ]

      //Pagado por

      REDEFINE GET aGet[ ( dbfTmpPgo )->( FieldPos( "cPgdoPor" ) ) ];
         VAR      aTmp[ ( dbfTmpPgo )->( FieldPos( "cPgdoPor" ) ) ] ;
         ID       140 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[ 1 ]

      //Cajas

      REDEFINE GET aGet[ ( dbfTmpPgo )->( FieldPos( "cCodCaj" ) ) ] ;
         VAR      aTmp[ ( dbfTmpPgo )->( FieldPos( "cCodCaj" ) ) ];
			WHEN 		( nMode != ZOOM_MODE ) ;
         VALID    cCajas( aGet[ ( dbfTmpPgo )->( FieldPos( "cCodCaj" ) ) ], dbfCajT, oGetCaj ) ;
         ID       170 ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwCajas( aGet[ ( dbfTmpPgo )->( FieldPos( "cCodCaj" ) ) ], oGetCaj ) ) ;
         OF       oFld:aDialogs[ 1 ]

      REDEFINE GET oGetCaj VAR cGetCaj ;
         ID       171 ;
         WHEN     .f. ;
         OF       oFld:aDialogs[ 1 ]

      /*
      Pestaña de bancos--------------------------------------------------------
      */

      REDEFINE BITMAP oBmpBancos ;
         ID       500 ;
         RESOURCE "office_building_48_alpha" ;
         TRANSPARENT ;
         OF       oFld:aDialogs[ 2 ]

      REDEFINE GET aGet[ ( dbfTmpPgo )->( FieldPos( "CBNCEMP" ) ) ] VAR aTmp[ ( dbfTmpPgo )->( FieldPos( "CBNCEMP" ) ) ];
         ID       100 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwBncEmp( aGet[ ( dbfTmpPgo )->( FieldPos( "CBNCEMP" ) ) ], aGet[ ( dbfTmpPgo )->( FieldPos( "CENTEMP" ) ) ], aGet[ ( dbfTmpPgo )->( FieldPos( "CSUCEMP" ) ) ], aGet[ ( dbfTmpPgo )->( FieldPos( "CDIGEMP" ) ) ], aGet[ ( dbfTmpPgo )->( FieldPos( "CCTAEMP" ) ) ] ) );
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ ( dbfTmpPgo )->( FieldPos( "CENTEMP" ) ) ] VAR aTmp[ ( dbfTmpPgo )->( FieldPos( "CENTEMP" ) ) ];
         ID       110 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( lCalcDC( aTmp[ ( dbfTmpPgo )->( FieldPos( "CENTEMP" ) ) ], aTmp[ ( dbfTmpPgo )->( FieldPos( "CSUCEMP" ) ) ], aTmp[ ( dbfTmpPgo )->( FieldPos( "CDIGEMP" ) ) ], aTmp[ ( dbfTmpPgo )->( FieldPos( "CCTAEMP" ) ) ], aGet[ ( dbfTmpPgo )->( FieldPos( "CDIGEMP" ) ) ] ) ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ ( dbfTmpPgo )->( FieldPos( "CSUCEMP" ) ) ] VAR aTmp[ ( dbfTmpPgo )->( FieldPos( "CSUCEMP" ) ) ];
         ID       120 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( lCalcDC( aTmp[ ( dbfTmpPgo )->( FieldPos( "CENTEMP" ) ) ], aTmp[ ( dbfTmpPgo )->( FieldPos( "CSUCEMP" ) ) ], aTmp[ ( dbfTmpPgo )->( FieldPos( "CDIGEMP" ) ) ], aTmp[ ( dbfTmpPgo )->( FieldPos( "CCTAEMP" ) ) ], aGet[ ( dbfTmpPgo )->( FieldPos( "CDIGEMP" ) ) ] ) ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ ( dbfTmpPgo )->( FieldPos( "CDIGEMP" ) ) ] VAR aTmp[ ( dbfTmpPgo )->( FieldPos( "CDIGEMP" ) ) ];
         ID       130 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( lCalcDC( aTmp[ ( dbfTmpPgo )->( FieldPos( "CENTEMP" ) ) ], aTmp[ ( dbfTmpPgo )->( FieldPos( "CSUCEMP" ) ) ], aTmp[ ( dbfTmpPgo )->( FieldPos( "CDIGEMP" ) ) ], aTmp[ ( dbfTmpPgo )->( FieldPos( "CCTAEMP" ) ) ], aGet[ ( dbfTmpPgo )->( FieldPos( "CDIGEMP" ) ) ] ) ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ ( dbfTmpPgo )->( FieldPos( "CCTAEMP" ) ) ] VAR aTmp[ ( dbfTmpPgo )->( FieldPos( "CCTAEMP" ) ) ];
         ID       140 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( lCalcDC( aTmp[ ( dbfTmpPgo )->( FieldPos( "CENTEMP" ) ) ], aTmp[ ( dbfTmpPgo )->( FieldPos( "CSUCEMP" ) ) ], aTmp[ ( dbfTmpPgo )->( FieldPos( "CDIGEMP" ) ) ], aTmp[ ( dbfTmpPgo )->( FieldPos( "CCTAEMP" ) ) ], aGet[ ( dbfTmpPgo )->( FieldPos( "CDIGEMP" ) ) ] ) ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ ( dbfTmpPgo )->( FieldPos( "CBNCCLI" ) ) ] VAR aTmp[ ( dbfTmpPgo )->( FieldPos( "CBNCCLI" ) ) ];
         ID       200 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwBncCli( aGet[ ( dbfTmpPgo )->( FieldPos( "CBNCCLI" ) ) ], aGet[ ( dbfTmpPgo )->( FieldPos( "CENTCLI" ) ) ], aGet[ ( dbfTmpPgo )->( FieldPos( "CSUCCLI" ) ) ], aGet[ ( dbfTmpPgo )->( FieldPos( "CDIGCLI" ) ) ], aGet[ ( dbfTmpPgo )->( FieldPos( "CCTACLI" ) ) ], aTmp[ ( dbfTmpPgo )->( FieldPos( "CCODCLI" ) ) ] ) );
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ ( dbfTmpPgo )->( FieldPos( "CENTCLI" ) ) ] VAR aTmp[ ( dbfTmpPgo )->( FieldPos( "CENTCLI" ) ) ];
         ID       210 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( lCalcDC( aTmp[ ( dbfTmpPgo )->( FieldPos( "CENTCLI" ) ) ], aTmp[ ( dbfTmpPgo )->( FieldPos( "CSUCCLI" ) ) ], aTmp[ ( dbfTmpPgo )->( FieldPos( "CDIGCLI" ) ) ], aTmp[ ( dbfTmpPgo )->( FieldPos( "CCTACLI" ) ) ], aGet[ ( dbfTmpPgo )->( FieldPos( "CDIGCLI" ) ) ] ) ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ ( dbfTmpPgo )->( FieldPos( "CSUCCLI" ) ) ] VAR aTmp[ ( dbfTmpPgo )->( FieldPos( "CSUCCLI" ) ) ];
         ID       220 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( lCalcDC( aTmp[ ( dbfTmpPgo )->( FieldPos( "CENTCLI" ) ) ], aTmp[ ( dbfTmpPgo )->( FieldPos( "CSUCCLI" ) ) ], aTmp[ ( dbfTmpPgo )->( FieldPos( "CDIGCLI" ) ) ], aTmp[ ( dbfTmpPgo )->( FieldPos( "CCTACLI" ) ) ], aGet[ ( dbfTmpPgo )->( FieldPos( "CDIGCLI" ) ) ] ) ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ ( dbfTmpPgo )->( FieldPos( "CDIGCLI" ) ) ] VAR aTmp[ ( dbfTmpPgo )->( FieldPos( "CDIGCLI" ) ) ];
         ID       230 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( lCalcDC( aTmp[ ( dbfTmpPgo )->( FieldPos( "CENTCLI" ) ) ], aTmp[ ( dbfTmpPgo )->( FieldPos( "CSUCCLI" ) ) ], aTmp[ ( dbfTmpPgo )->( FieldPos( "CDIGCLI" ) ) ], aTmp[ ( dbfTmpPgo )->( FieldPos( "CCTACLI" ) ) ], aGet[ ( dbfTmpPgo )->( FieldPos( "CDIGCLI" ) ) ] ) ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ ( dbfTmpPgo )->( FieldPos( "CCTACLI" ) ) ] VAR aTmp[ ( dbfTmpPgo )->( FieldPos( "CCTACLI" ) ) ];
         ID       240 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( lCalcDC( aTmp[ ( dbfTmpPgo )->( FieldPos( "CENTCLI" ) ) ], aTmp[ ( dbfTmpPgo )->( FieldPos( "CSUCCLI" ) ) ], aTmp[ ( dbfTmpPgo )->( FieldPos( "CDIGCLI" ) ) ], aTmp[ ( dbfTmpPgo )->( FieldPos( "CCTACLI" ) ) ], aGet[ ( dbfTmpPgo )->( FieldPos( "CDIGCLI" ) ) ] ) ) ;
         OF       oFld:aDialogs[2]

      //Botones

      REDEFINE BUTTON ;
         ID       IDOK ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( ValidEdtEnt( aTmp, aGet, oBrw, oDlg, nMode, dbfTmpPgo ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
         CANCEL ;
         ACTION   ( oDlg:End() )

   oDlg:bStart    := {|| aGet[ ( dbfTmpPgo )->( FieldPos( "nImporte" ) ) ]:SetFocus() }

   if nMode != ZOOM_MODE
      oDlg:AddFastKey( VK_F5, {|| ValidEdtEnt( aTmp, aGet, oBrw, oDlg, nMode, dbfTmpPgo ) } )
   end if

   ACTIVATE DIALOG oDlg CENTER;
      ON INIT ( CreateMenuEntrega( aTmp, oDlg ) )

   if !Empty( oMenu )
      oMenu:End()
   end if

   if !Empty( oBmpDiv )
      oBmpDiv:End()
   end if

   if !Empty( oBmp )
      oBmp:End()
   end if

   if !Empty( oBmpBancos )
      oBmpBancos:End()
   end if

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

Static Function ValidEdtEnt( aTmp, aGet, oBrw, oDlg, nMode, dbfTmpPgo )

   if nMode == APPD_MODE
      aTmp[ ( dbfTmpPgo )->( FieldPos( "nNumRec" ) ) ]   := ( dbfTmpPgo )->( LastRec() ) + 1
   end if

   WinGather( aTmp, aGet, dbfTmpPgo, oBrw, nMode )

   oDlg:End( IDOK )

Return .t.

//---------------------------------------------------------------------------//

Static Function CreateMenuEntrega( aTmp, oDlg )

   MENU oMenu

      MENUITEM    "&1. Rotor"

         MENU

            MENUITEM    "&2. Modificar cliente";
               MESSAGE  "Modifica la ficha del cliente" ;
               RESOURCE "User1_16" ;
               ACTION   ( if( !Empty( aTmp[ ( dbfTmpPgo )->( FieldPos( "cCodCli" ) ) ] ), EdtCli( aTmp[ ( dbfTmpPgo )->( FieldPos( "cCodCli" ) ) ] ), MsgStop( "Código de cliente vacío" ) ) )

            MENUITEM    "&3. Informe de cliente";
               MESSAGE  "Informe de cliente" ;
               RESOURCE "Info16" ;
               ACTION   ( if( !Empty( aTmp[ ( dbfTmpPgo )->( FieldPos( "cCodCli" ) ) ] ), InfCliente( aTmp[ ( dbfTmpPgo )->( FieldPos( "cCodCli" ) ) ] ), MsgStop( "Código de cliente vacío" ) ) );

         ENDMENU

   ENDMENU

   oDlg:SetMenu( oMenu )

RETURN ( oMenu )

//--------------------------------------------------------------------------//

CLASS TAlbaranesClientesSenderReciver FROM TSenderReciverItem

   Method CreateData()

   Method RestoreData()

   Method SendData()

   Method ReciveData()

   Method Process()

END CLASS

//----------------------------------------------------------------------------//

Method CreateData()

   local oBlock
   local oError
   local lSnd        := .f.
   local nOrd
   local dbfAlbCliT
   local dbfAlbCliL
   local dbfAlbCliI
   local tmpAlbCliT
   local tmpAlbCliL
   local tmpAlbCliI
   local cFileName

   if ::oSender:lServer
      cFileName      := "AlbCli" + StrZero( ::nGetNumberToSend(), 6 ) + ".All"
   else
      cFileName      := "AlbCli" + StrZero( ::nGetNumberToSend(), 6 ) + "." + RetSufEmp()
   end if

   ::oSender:SetText( "Enviando albaranes de clientes" )

   oBlock            := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   USE ( cPatEmp() + "AlbCLIT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "AlbCLIT", @dbfAlbCliT ) )
   SET ADSINDEX TO ( cPatEmp() + "AlbCLIT.CDX" ) ADDITIVE

   USE ( cPatEmp() + "AlbCLIL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "AlbCLIL", @dbfAlbCliL ) )
   SET ADSINDEX TO ( cPatEmp() + "AlbCLIL.CDX" ) ADDITIVE

   USE ( cPatEmp() + "AlbCliI.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "AlbCliI", @dbfAlbCliI ) )
   SET ADSINDEX TO ( cPatEmp() + "AlbCliI.CDX" ) ADDITIVE

   /*
   Creamos todas las bases de datos relacionadas con Articulos
   */

   rxAlbCli( cPatSnd() )

   USE ( cPatSnd() + "AlbCliT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "AlbCliT", @tmpAlbCliT ) )
   SET ADSINDEX TO ( cPatSnd() + "AlbCliT.CDX" ) ADDITIVE

   USE ( cPatSnd() + "AlbCliL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "AlbCliL", @tmpAlbCliL ) )
   SET ADSINDEX TO ( cPatSnd() + "AlbCliL.CDX" ) ADDITIVE

   USE ( cPatSnd() + "AlbCliI.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "AlbCliI", @tmpAlbCliI ) )
   SET ADSINDEX TO ( cPatSnd() + "AlbCliI.CDX" ) ADDITIVE

   if !Empty( ::oSender:oMtr )
      ::oSender:oMtr:nTotal := ( dbfAlbCliT )->( LastRec() )
   end if

   nOrd  := ( dbfAlbCliT )->( OrdSetFocus( "lSndDoc" ) )

   if ( dbfAlbCliT )->( dbSeek( .t. ) )

      while !( dbfAlbCliT )->( eof() )

         if ( lEnviarEntregados() .and. ( dbfAlbCliT )->lEntregado ) .or. !lEnviarEntregados()

            lSnd  := .t.

            dbPass( dbfAlbCliT, tmpAlbCliT, .t. )
            ::oSender:SetText( ( dbfAlbCliT )->cSerAlb + "/" + AllTrim( Str( ( dbfAlbCliT )->nNumAlb ) ) + "/" + AllTrim( ( dbfAlbCliT )->cSufAlb ) + "; " + Dtoc( ( dbfAlbCliT )->dFecAlb ) + "; " + AllTrim( ( dbfAlbCliT )->cCodCli ) + "; " + ( dbfAlbCliT )->cNomCli )

            if ( dbfAlbCliL )->( dbSeek( ( dbfAlbCliT )->CSERAlb + Str( ( dbfAlbCliT )->NNUMAlb ) + ( dbfAlbCliT )->CSUFAlb ) )
               while ( ( dbfAlbCliL )->cSerAlb + Str( ( dbfAlbCliL )->NNUMAlb ) + ( dbfAlbCliL )->CSUFAlb ) == ( ( dbfAlbCliT )->CSERAlb + Str( ( dbfAlbCliT )->NNUMAlb ) + ( dbfAlbCliT )->CSUFAlb ) .AND. !( dbfAlbCliL )->( eof() )
                  dbPass( dbfAlbCliL, tmpAlbCliL, .t. )
                  ( dbfAlbCliL )->( dbSkip() )
               end do
            end if

            if ( dbfAlbCliI )->( dbSeek( ( dbfAlbCliT )->cSerAlb + Str( ( dbfAlbCliT )->nNumAlb ) + ( dbfAlbCliT )->cSufAlb ) )
               while ( ( dbfAlbCliI )->cSerAlb + Str( ( dbfAlbCliI )->nNumAlb ) + ( dbfAlbCliI )->cSufAlb ) == ( ( dbfAlbCliT )->cSerAlb + Str( ( dbfAlbCliT )->nNumAlb ) + ( dbfAlbCliT )->cSufAlb ) .AND. !( dbfAlbCliI )->( eof() )
                  dbPass( dbfAlbCliI, tmpAlbCliI, .t. )
                  ( dbfAlbCliI )->( dbSkip() )
               end do
            end if

         end if

         SysRefresh()

         ( dbfAlbCliT )->( dbSkip() )

         if !Empty( ::oSender:oMtr )
            ::oSender:oMtr:Set( ( dbfAlbCliT )->( OrdKeyNo() ) )
         end if

      end do

   end if

   ( dbfAlbCliT )->( OrdSetFocus( nOrd ) )

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos de albaranes" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE
   ErrorBlock( oBlock )

   CLOSE ( dbfAlbCliT )
   CLOSE ( dbfAlbCliL )
   CLOSE ( dbfAlbCliI )
   CLOSE ( tmpAlbCliT )
   CLOSE ( tmpAlbCliL )
   CLOSE ( tmpAlbCliI )

   if lSnd

      ::oSender:SetText( "Comprimiendo albaranes de clientes" )

      if ::oSender:lZipData( cFileName )
         ::oSender:SetText( "Ficheros comprimidos" )
      else
         ::oSender:SetText( "ERROR al crear fichero comprimido" )
      end if

   else

      ::oSender:SetText( "No hay albaranes de clientes para enviar" )

   end if

Return ( Self )

//----------------------------------------------------------------------------//

Method RestoreData()

   local oBlock
   local oError
   local dbfAlbCliT

   /*
   Retorna el valor anterior
   */

   if ::lSuccesfullSend

      oBlock         := ErrorBlock( { | oError | ApoloBreak( oError ) } )
      BEGIN SEQUENCE

         USE ( cPatEmp() + "AlbCLIT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "AlbCLIT", @dbfAlbCliT ) )
         SET ADSINDEX TO ( cPatEmp() + "AlbCliT.Cdx" ) ADDITIVE

         ( dbfAlbCliT )->( OrdSetFocus( "lSndDoc" ) )

         while ( dbfAlbCliT )->( dbSeek( .t. ) ) .and. !( dbfAlbCliT )->( eof() )
            if dbLock( dbfAlbCliT )
               ( dbfAlbCliT )->lSndDoc := .f.
               ( dbfAlbCliT )->( dbRUnlock() )
            end if
         end do

      RECOVER USING oError

         msgStop( "Imposible abrir todas las bases de datos de albaranes" + CRLF + ErrorMessage( oError ) )

      END SEQUENCE
      ErrorBlock( oBlock )

      CLOSE ( dbfAlbCliT )

   end if

Return ( Self )

//---------------------------------------------------------------------------//

Method SendData()

   local cFileName

   if ::oSender:lServer
      cFileName         := "AlbCli" + StrZero( ::nGetNumberToSend(), 6 ) + ".All"
   else
      cFileName         := "AlbCli" + StrZero( ::nGetNumberToSend(), 6 ) + "." + RetSufEmp()
   end if

   /*
   Enviarlos a internet--------------------------------------------------------
   */

   if File( cPatOut() + cFileName )

      if ftpSndFile( cPatOut() + cFileName, cFileName, 2000, ::oSender )
         ::IncNumberToSend()
         ::lSuccesfullSend := .t.
         ::oSender:SetText( "Fichero enviado " + cFileName )
      else
         ::oSender:SetText( "ERROR al enviar fichero" )
      end if

   end if

Return ( Self )

//---------------------------------------------------------------------------//

Method ReciveData()

   local n
   local aExt

   if ::oSender:lServer
      aExt        := aRetDlgEmp()
   else
      aExt        := { "All" }
   end if

   /*
   Recibirlo de internet
   */

   ::oSender:SetText( "Recibiendo albaranes de clientes" )

   for n := 1 to len( aExt )
      ftpGetFiles( "AlbCli*." + aExt[ n ], cPatIn(), 2000, ::oSender )
   next

   ::oSender:SetText( "Albaranes de clientes recibidos" )

Return Self

//----------------------------------------------------------------------------//

Method Process()

   local m
   local dbfAlbCliT
   local dbfAlbCliL
   local dbfAlbCliI
   local tmpAlbCliT
   local tmpAlbCliL
   local tmpAlbCliI
   local oBlock
   local oError
   local aFiles      := Directory( cPatIn() + "AlbCli*.*" )
   local lClient     := ::oSender:lServer

   for m := 1 to len( aFiles )

      ::oSender:SetText( "Procesando fichero : " + aFiles[ m, 1 ] )

      oBlock         := ErrorBlock( { | oError | ApoloBreak( oError ) } )
      BEGIN SEQUENCE

         if ::oSender:lUnZipData( cPatIn() + aFiles[ m, 1 ] )

            /*
            Ficheros temporales
            */

            if lExistTable( cPatSnd() + "AlbCliT.DBF" )   .and.;
               lExistTable( cPatSnd() + "AlbCliL.DBF" )   .and.;
               lExistTable( cPatSnd() + "AlbCliI.DBF" )

               USE ( cPatSnd() + "AlbCliT.DBF" ) NEW VIA ( cDriver() )READONLY ALIAS ( cCheckArea( "AlbCliT", @tmpAlbCliT ) )
               SET ADSINDEX TO ( cPatSnd() + "AlbCliT.CDX" ) ADDITIVE

               USE ( cPatSnd() + "AlbCliL.DBF" ) NEW VIA ( cDriver() )READONLY ALIAS ( cCheckArea( "AlbCliL", @tmpAlbCliL ) )
               SET ADSINDEX TO ( cPatSnd() + "AlbCliL.CDX" ) ADDITIVE

               USE ( cPatSnd() + "AlbCliI.DBF" ) NEW VIA ( cDriver() )READONLY ALIAS ( cCheckArea( "AlbCliI", @tmpAlbCliI ) )
               SET ADSINDEX TO ( cPatSnd() + "AlbCliI.CDX" ) ADDITIVE

               USE ( cPatEmp() + "AlbCliT.DBF" ) NEW VIA ( cDriver() )READONLY ALIAS ( cCheckArea( "AlbCliT", @dbfAlbCliT ) )
               SET ADSINDEX TO ( cPatEmp() + "AlbCliT.CDX" ) ADDITIVE

               USE ( cPatEmp() + "AlbCliL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "AlbCliL", @dbfAlbCliL ) )
               SET ADSINDEX TO ( cPatEmp() + "AlbCliL.CDX" ) ADDITIVE

               USE ( cPatEmp() + "AlbCliI.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "AlbCliI", @dbfAlbCliI ) )
               SET ADSINDEX TO ( cPatEmp() + "AlbCliI.CDX" ) ADDITIVE

               while ( tmpAlbCliT )->( !eof() )

                  if lValidaOperacion( ( tmpAlbCliT )->dFecAlb, .f. ) .and. ;
                     !( dbfAlbCliT )->( dbSeek( ( tmpAlbCliT )->cSerAlb + Str( ( tmpAlbCliT )->nNumAlb ) + ( tmpAlbCliT )->cSufAlb ) )

                     dbPass( tmpAlbCliT, dbfAlbCliT, .t. )

                     if lClient .and. dbLock( dbfAlbCliT )
                        ( dbfAlbCliT )->lSndDoc := .f.
                        ( dbfAlbCliT )->( dbUnLock() )
                     end if

                     ::oSender:SetText( "Añadido     : " + ( tmpAlbCliT )->cSerAlb + "/" + AllTrim( Str( ( tmpAlbCliT )->nNumAlb ) ) + "/" + AllTrim( ( tmpAlbCliT )->cSufAlb ) + "; " + Dtoc( ( tmpAlbCliT )->dFecAlb ) + "; " + AllTrim( ( tmpAlbCliT )->cCodCli ) + "; " + ( tmpAlbCliT )->cNomCli )

                     if ( tmpAlbCliL )->( dbSeek( ( tmpAlbCliT )->cSerAlb + Str( ( tmpAlbCliT )->nNumAlb ) + ( tmpAlbCliT )->cSufAlb ) )
                        while ( tmpAlbCliL )->cSerAlb + Str( ( tmpAlbCliL )->nNumAlb ) + ( tmpAlbCliL )->cSufAlb == ( tmpAlbCliT )->cSerAlb + Str( ( tmpAlbCliT )->nNumAlb ) + ( tmpAlbCliT )->cSufAlb .and. !( tmpAlbCliL )->( eof() )
                           dbPass( tmpAlbCliL, dbfAlbCliL, .t. )
                           ( tmpAlbCliL )->( dbSkip() )
                        end do
                     end if

                     if ( tmpAlbCliI )->( dbSeek( ( tmpAlbCliT )->cSerAlb + Str( ( tmpAlbCliT )->nNumAlb ) + ( tmpAlbCliT )->cSufAlb ) )
                        while ( tmpAlbCliI )->cSerAlb + Str( ( tmpAlbCliI )->nNumAlb ) + ( tmpAlbCliI )->cSufAlb == ( tmpAlbCliT )->cSerAlb + Str( ( tmpAlbCliT )->nNumAlb ) + ( tmpAlbCliT )->cSufAlb .and. !( tmpAlbCliI )->( eof() )
                           dbPass( tmpAlbCliI, dbfAlbCliI, .t. )
                           ( tmpAlbCliI )->( dbSkip() )
                        end do
                     end if

                  else

                     ::oSender:SetText( "Desestimado : " + ( tmpAlbCliT )->cSerAlb + "/" + AllTrim( Str( ( tmpAlbCliT )->nNumAlb ) ) + "/" + AllTrim( ( tmpAlbCliT )->cSufAlb ) + "; " + Dtoc( ( tmpAlbCliT )->dFecAlb ) + "; " + AllTrim( ( tmpAlbCliT )->cCodCli ) + "; " + ( tmpAlbCliT )->cNomCli )

                  end if

                  SysRefresh()

                  ( tmpAlbCliT )->( dbSkip() )

               end do

               CLOSE ( dbfAlbCliT )
               CLOSE ( dbfAlbCliL )
               CLOSE ( dbfAlbCliI )
               CLOSE ( tmpAlbCliT )
               CLOSE ( tmpAlbCliL )
               CLOSE ( tmpAlbCliI )

               ::oSender:AppendFileRecive( aFiles[ m, 1 ] )

            else

               ::oSender:SetText( "Faltan ficheros" )

               if !file( cPatSnd() + "AlbCliT.Dbf" )
                  ::oSender:SetText( "Falta" + cPatSnd() + "AlbCliT.Dbf" )
               end if

               if !file( cPatSnd() + "AlbCliL.Dbf" )
                  ::oSender:SetText( "Falta" + cPatSnd() + "AlbCliL.Dbf" )
               end if

               if !file( cPatSnd() + "AlbCliI.Dbf" )
                  ::oSender:SetText( "Falta" + cPatSnd() + "AlbCliI.Dbf" )
               end if

            end if

            fErase( cPatSnd() + "AlbCliT.DBF" )
            fErase( cPatSnd() + "AlbCliL.DBF" )
            fErase( cPatSnd() + "AlbCliI.DBF" )

         else

            ::oSender:SetText( "Error al descomprimir los ficheros" )

         end if

      RECOVER USING oError

         CLOSE ( dbfAlbCliT )
         CLOSE ( dbfAlbCliL )
         CLOSE ( dbfAlbCliI )
         CLOSE ( tmpAlbCliT )
         CLOSE ( tmpAlbCliL )
         CLOSE ( tmpAlbCliI )

         ::oSender:SetText( "Error procesando fichero " + aFiles[ m, 1 ] )
         ::oSender:SetText( ErrorMessage( oError ) )

      END SEQUENCE
      ErrorBlock( oBlock )

   next

Return Self

//----------------------------------------------------------------------------//
/*
Static Function LoopDeta( oBrw, bEdt, aTmp, cNumAlb )

   while !( dbfTmpLin )->( eof() )

      EdtDeta( oBrw, bEdt, aTmp, , cNumAlb )

      ( dbfTmpLin )->( dbSkip() )

   end while

return nil
 */

//---------------------------------------------------------------------------//

STATIC FUNCTION DelSerie( oWndBrw )

	local oDlg
   local oSerIni
   local oSerFin
   local oTxtDel
   local nTxtDel     := 0
   local nRecno      := ( dbfAlbCliT )->( Recno() )
   local nOrdAnt     := ( dbfAlbCliT )->( OrdSetFocus( 1 ) )
   local oDesde      := TDesdeHasta():Init( ( dbfAlbCliT )->cSerAlb, ( dbfAlbCliT )->nNumAlb, ( dbfAlbCliT )->cSufAlb, GetSysDate() )
   local lCancel     := .f.
   local oBtnAceptar
   local oBtnCancel

   DEFINE DIALOG oDlg ;
      RESOURCE "DelSerDoc" ;
      TITLE    "Eliminar series de albaranes" ;
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
      TOTAL    ( dbfAlbCliT )->( OrdKeyCount() ) ;
      OF       oDlg

   ACTIVATE DIALOG oDlg CENTER VALID ( lCancel )

   ( dbfAlbCliT )->( dbGoTo( nRecNo ) )
   ( dbfAlbCliT )->( ordSetFocus( nOrdAnt ) )

   oWndBrw:SetFocus()
   oWndBrw:Refresh()

RETURN NIL

//--------------------------------------------------------------------------//

STATIC FUNCTION DelStart( oDesde, oDlg, oBtnAceptar, oBtnCancel, oTxtDel, lCancel )

   local nOrd
   local nDeleted          := 0
   local nProcesed         := 0

   oBtnAceptar:Hide()
   oBtnCancel:bAction      := {|| lCancel := .t. }

   if oDesde:nRadio == 1

      nOrd                 := ( dbfAlbCliT )->( OrdSetFocus( "nNumAlb" ) )

      ( dbfAlbCliT )->( dbSeek( oDesde:cNumeroInicio(), .t. ) )
      while !lCancel .and. ( dbfAlbCliT )->( !eof() )

         if ( dbfAlbCliT )->cSerAlb >= oDesde:cSerieInicio  .and.;
            ( dbfAlbCliT )->cSerAlb <= oDesde:cSerieFin     .and.;
            ( dbfAlbCliT )->nNumAlb >= oDesde:nNumeroInicio .and.;
            ( dbfAlbCliT )->nNumAlb <= oDesde:nNumeroFin    .and.;
            ( dbfAlbCliT )->cSufAlb >= oDesde:cSufijoInicio .and.;
            ( dbfAlbCliT )->cSufAlb <= oDesde:cSufijoFin

            ++nDeleted

            oTxtDel:cText  := "Eliminando : " + ( dbfAlbCliT )->cSerAlb + "/" + Alltrim( Str( ( dbfAlbCliT )->nNumAlb ) ) + "/" + ( dbfAlbCliT )->cSufAlb

            //AlbRecDel( .t., .t., .f., .f. )

            WinDelRec( nil, dbfAlbCliT, {|| QuiAlbCli() } )

         else

            ( dbfAlbCliT )->( dbSkip() )

         end if

         ++nProcesed

         oTxtDel:Set( ( dbfAlbCliT )->( OrdKeyNo() ) )

      end do

      ( dbfAlbCliT )->( OrdSetFocus( nOrd ) )

   else

      nOrd                 := ( dbfAlbCliT )->( OrdSetFocus( "dFecAlb" ) )

      ( dbfAlbCliT )->( dbSeek( oDesde:dFechaInicio, .t. ) )
      while !lCancel .and. ( dbfAlbCliT )->( !eof() )

         if ( dbfAlbCliT )->dFecAlb >= oDesde:dFechaInicio  .and.;
            ( dbfAlbCliT )->dFecAlb <= oDesde:dFechaFin

            ++nDeleted

            oTxtDel:cText  := "Eliminando : " + ( dbfAlbCliT )->cSerAlb + "/" + Alltrim( Str( ( dbfAlbCliT )->nNumAlb ) ) + "/" + ( dbfAlbCliT )->cSufAlb

            //AlbRecDel( .t., .t., .f., .f. )

            WinDelRec( nil, dbfAlbCliT, {|| QuiAlbCli() } )

         else

            ( dbfAlbCliT )->( dbSkip() )

         end if

         ++nProcesed

         oTxtDel:Set( ( dbfAlbCliT )->( OrdKeyNo() ) )

      end do

      ( dbfAlbCliT )->( OrdSetFocus( nOrd ) )

   end if

   lCancel                 := .t.

   oBtnAceptar:Show()

   if lCancel
      msgStop( "Total de registros borrados : " + Str( nDeleted ), "Proceso cancelado" )
   else
      msgInfo( "Total de registros borrados : " + Str( nDeleted ), "Proceso finalizado" )
   end if

RETURN ( oDlg:End() )

//---------------------------------------------------------------------------//

 Static Function nEstadoIncidencia( cNumAlb )

   local nEstado  := 0
   local aBmp     := ""
   local nOrdAnt  := ( dbfAlbCliI )->( OrdSetFocus( "nNumAlb" ) )

   if ( dbfAlbCliI )->( dbSeek( cNumAlb ) )

      while ( dbfAlbCliI )->cSerAlb + Str( ( dbfAlbCliI )->nNumAlb ) + ( dbfAlbCliI )->cSufAlb == cNumAlb .and. !( dbfAlbCliI )->( Eof() )

         if ( dbfAlbCliI )->lListo
            do case
               case nEstado == 0 .or. nEstado == 3
                    nEstado := 3
               case nEstado == 1
                    nEstado := 2
            end case
         else
            do case
               case nEstado == 0
                    nEstado := 1
               case nEstado == 3
                    nEstado := 2
            end case
         end if

         ( dbfAlbCliI )->( dbSkip() )

      end while

   end if

   ( dbfAlbCliI )->( OrdSetFocus( nOrdAnt ) )

Return ( nEstado )

//---------------------------------------------------------------------------//
//NOTA: Esta funcion se utiliza para el estado de generado de pedidos de clientes
//

function nEstadoGenerado( cNumPed, dbfPedCliL, dbfPedPrvL )

   local nEstado := 0
   local nOrdAnt

   if IsMuebles()
      nOrdAnt := ( dbfPedPrvL )->( OrdSetFocus( "CPEDCLIREFDET" ) )
   else
      nOrdAnt := ( dbfPedPrvL )->( OrdSetFocus( "CPEDCLIREF" ) )
   end if

   ( dbfPedCliL )->( dbSeek( cNumPed ) )

   while ( dbfPedCliL )->cSerPed + Str( ( dbfPedCliL )->nNumPed ) + ( dbfPedCliL )->cSufPed == cNumPed .and. !( dbfPedCliL )->( Eof() )

      if IsMuebles()

         if ( dbfPedPrvL )->( dbSeek( cNumPed + ( dbfPedCliL )->cRef + ( dbfPedCliL )->cRefPrv + ( dbfPedCliL )->cDetalle ) )

            do case
               case nEstado == 0 .or. nEstado == 3
                  nEstado := 3
               case nEstado == 1
                  nEstado := 2
            end case
         else
            do case
               case nEstado == 0
                  nEstado := 1
               case nEstado == 3
                  nEstado := 2
            end case
         end if

      else

         if( dbfPedPrvL )->( dbSeek( cNumPed + ( dbfPedCliL )->cRef ) )
            do case
               case nEstado == 0 .or. nEstado == 3
                  nEstado := 3
               case nEstado == 1
                  nEstado := 2
            end case
         else
            do case
               case nEstado == 0
                  nEstado := 1
               case nEstado == 3
                  nEstado := 2
            end case
         end if

      end if

   ( dbfPedCliL )->( dbSkip() )

   end while

   ( dbfPedPrvL )->( OrdSetFocus( nOrdAnt ) )

return ( Max( nEstado, 1 ) )

//---------------------------------------------------------------------------//

Function AppAlbCli( cCodCli, cCodArt, lOpenBrowse )

   local nLevel         := nLevelUsr( _MENUITEM_ )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) != 0 .or. nAnd( nLevel, ACC_APPD ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if lOpenBrowse

      if AlbCli( nil, nil, cCodCli, cCodArt )
         oWndBrw:RecAdd()
      end if

   else

      if OpenFiles( nil, .t. )
         nTotAlbCli()
         WinAppRec( nil, bEdtRec, dbfAlbCliT, cCodCli, cCodArt )
         CloseFiles()
      end if

   end if

RETURN .t.

//---------------------------------------------------------------------------//

Function EdtAlbCli( cNumAlb, lOpenBrowse )

   local nLevel         := nLevelUsr( _MENUITEM_ )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) != 0 .or. nAnd( nLevel, ACC_EDIT ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if lOpenBrowse

      if AlbCli()
         if dbSeekInOrd( cNumAlb, "nNumAlb", dbfAlbCliT )
            oWndBrw:RecEdit()
         else
            MsgStop( "No se encuentra albaran" )
         end if
      end if

   else

      if OpenFiles( nil, .t. )

         if dbSeekInOrd( cNumAlb, "nNumAlb", dbfAlbCliT )
            nTotAlbCli()
            WinEdtRec( nil, bEdtRec, dbfAlbCliT )
         end if

         CloseFiles()

      end if

   end if

Return .t.

//----------------------------------------------------------------------------//

FUNCTION ZooAlbCli( cNumAlb, lOpenBrowse )

   local nLevel         := nLevelUsr( _MENUITEM_ )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) != 0 .or. nAnd( nLevel, ACC_ZOOM ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if lOpenBrowse

      if AlbCli()
         if dbSeekInOrd( cNumAlb, "nNumAlb", dbfAlbCliT )
            oWndBrw:RecZoom()
         else
            MsgStop( "No se encuentra albaran" )
         end if
      end if

   else

      if OpenFiles( nil, .t. )

         if dbSeekInOrd( cNumAlb, "nNumAlb", dbfAlbCliT )
            nTotAlbCli()
            WinZooRec( nil, bEdtRec, dbfAlbCliT )
         end if

         CloseFiles()

      end if

   end if

Return .t.

//----------------------------------------------------------------------------//

FUNCTION DelAlbCli( cNumAlb, lOpenBrowse )

   local nLevel         := nLevelUsr( _MENUITEM_ )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) != 0 .or. nAnd( nLevel, ACC_DELE ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if lOpenBrowse

      if AlbCli()
         if dbSeekInOrd( cNumAlb, "nNumAlb", dbfAlbCliT )
            WinDelRec( nil, dbfAlbCliT, {|| QuiAlbCli() } )
         else
            MsgStop( "No se encuentra albaran" )
         end if
      end if

   else

      if OpenFiles( nil, .t. )

         if dbSeekInOrd( cNumAlb, "nNumAlb", dbfAlbCliT )
            nTotAlbCli()
            WinDelRec( nil, dbfAlbCliT, {|| QuiAlbCli() } )
         end if

         CloseFiles()

      end if

   end if

Return .t.

//----------------------------------------------------------------------------//

FUNCTION PrnAlbCli( cNumAlb, lOpenBrowse, cCaption, cFormato, cPrinter )

   local nLevel         := nLevelUsr( _MENUITEM_ )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) != 0 .or. nAnd( nLevel, ACC_IMPR ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if lOpenBrowse

      if AlbCli()
         if dbSeekInOrd( cNumAlb, "nNumAlb", dbfAlbCliT )
            GenAlbCli( IS_PRINTER, cCaption, cFormato, cPrinter )
         else
            MsgStop( "No se encuentra albaran" )
         end if
      end if

   else

      if OpenFiles( nil, .t. )

         if dbSeekInOrd( cNumAlb, "nNumAlb", dbfAlbCliT )
            nTotAlbCli()
            GenAlbCli( IS_PRINTER, cCaption, cFormato, cPrinter )
         end if

         CloseFiles()

      end if

   end if

Return .t.

//---------------------------------------------------------------------------//

FUNCTION VisAlbCli( cNumAlb, lOpenBrowse, cCaption, cFormato, cPrinter )

   local nLevel         := nLevelUsr( _MENUITEM_ )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) != 0 .or. nAnd( nLevel, ACC_IMPR ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if lOpenBrowse

      if AlbCli()
         if dbSeekInOrd( cNumAlb, "nNumAlb", dbfAlbCliT )
            GenAlbCli( IS_SCREEN, cCaption, cFormato, cPrinter )
         else
            MsgStop( "No se encuentra albaran" )
         end if
      end if

   else

      if OpenFiles( nil, .t. )

         if dbSeekInOrd( cNumAlb, "nNumAlb", dbfAlbCliT )
            nTotAlbCli()
            GenAlbCli( IS_SCREEN, cCaption, cFormato, cPrinter )
         end if

         CloseFiles()

      end if

   end if

Return .t.

//---------------------------------------------------------------------------//

Static Function DesgPnt( cCodArt, aTmp, nTarifa, oPreDiv, oCosDiv, nMode )

   local oDlg
   local oPuntos
   local oValorPunto
   local oDtoPnt
   local oIncPnt
   local oImporte
   local nPuntos     := 0
   local nValorPunto := 0
   local nDtoPnt     := 0
   local nIncPnt     := 0

   /*comprobamos que no esté vacío el artículo*/

   if Empty( cCodArt )
      MsgInfo( "Debe seleccinar un artículo", "Código vacío" )
      return .f.
   end if

   /*Cargamos valores por defecto*/

   nPuntos           := aTmp[ _NPUNTOS ]
   nValorPunto       := aTmp[ _NVALPNT ]
   nDtoPnt           := aTmp[ _NDTOPNT ]
   nIncPnt           := aTmp[ _NINCPNT ]

   DEFINE DIALOG oDlg RESOURCE "DESGPUNTOS" TITLE "Desglose de puntos"

   REDEFINE GET oPuntos VAR nPuntos ;
      ID       200 ;
      SPINNER ;
      ON CHANGE( oImporte:Refresh() ) ;
      WHEN     ( nMode != ZOOM_MODE ) ;
      PICTURE  cPouDiv ;
      OF       oDlg

   REDEFINE GET oValorPunto VAR nValorPunto ;
      ID       210 ;
      SPINNER ;
      ON CHANGE( oImporte:Refresh() ) ;
      WHEN     ( nMode != ZOOM_MODE ) ;
      PICTURE  cPouDiv ;
      OF       oDlg

   REDEFINE GET oDtoPnt VAR nDtoPnt ;
      ID       220 ;
      SPINNER ;
      MIN      0 ;
      MAX      100 ;
      ON CHANGE( oImporte:Refresh() ) ;
      WHEN     ( nMode != ZOOM_MODE ) ;
      PICTURE  "999.99" ;
      OF       oDlg

   REDEFINE GET oIncPnt VAR nIncPnt ;
      ID       230 ;
      SPINNER ;
      MIN      0 ;
      MAX      100 ;
      ON CHANGE( oImporte:Refresh() ) ;
      WHEN     ( nMode != ZOOM_MODE ) ;
      PICTURE  "999.99" ;
      OF       oDlg

   REDEFINE SAY oImporte PROMPT nCalculoPuntos( nPuntos, nValorPunto, nDtoPnt, nIncPnt ) ;
      ID       240 ;
      PICTURE  cPouDiv ;
      COLOR    CLR_GET ;
      OF       oDlg

   REDEFINE BUTTON ;
      ID       500 ;
      OF       oDlg ;
      WHEN     ( nMode != ZOOM_MODE ) ;
      ACTION   ( EndDesgPnt( cCodArt, nTarifa, oPreDiv, oImporte, dbfArticulo, nDouDiv ), oDlg:end( IDOK ) )

   REDEFINE BUTTON ;
      ID       550 ;
      OF       oDlg ;
      ACTION   ( oDlg:end() )

   if nMode != ZOOM_MODE
      oDlg:AddFastKey( VK_F5, {|| EndDesgPnt( cCodArt, nTarifa, oPreDiv, oImporte, dbfArticulo, nDouDiv ), oDlg:end( IDOK ) } )
   end if

   ACTIVATE DIALOG oDlg CENTER

   if oDlg:nResult == IDOK

      aTmp[ _NPUNTOS ]     := nPuntos
      aTmp[ _NVALPNT ]     := nValorPunto
      aTmp[ _NDTOPNT ]     := nDtoPnt
      aTmp[ _NINCPNT ]     := nIncPnt
      oCosDiv:cText( oImporte:VarGet() )
      oCosDiv:Refresh()

   end if

Return ( .t. )

//---------------------------------------------------------------------------//

Static Function AlbCliNotas()

   local cObserv  := ""
   local aData    := {}

   aAdd( aData, "Albaran " + ( dbfAlbCliT )->cSerAlb + "/" + AllTrim( Str( ( dbfAlbCliT )->nNumAlb ) ) + "/" + Alltrim( ( dbfAlbCliT )->cSufAlb ) + " de " + Rtrim( ( dbfAlbCliT )->cNomCli ) )
   aAdd( aData, ALB_CLI )
   aAdd( aData, ( dbfAlbCliT )->cCodCli )
   aAdd( aData, ( dbfAlbCliT )->cNomCli )
   aAdd( aData, ( dbfAlbCliT )->cSerAlb + Str( ( dbfAlbCliT )->nNumAlb ) + ( dbfAlbCliT )->cSufAlb )

   if ( dbfClient )->( dbSeek( ( dbfAlbCliT )->cCodCli ) )

      if !Empty( ( dbfClient )->cPerCto )
         cObserv  += Rtrim( ( dbfClient )->cPerCto ) + Space( 1 )
      end if

      if !Empty( ( dbfClient )->Telefono )
         cObserv  += "Télefono : " + Rtrim( ( dbfClient )->Telefono ) + Space( 1 )
      end if

      if !Empty( ( dbfClient )->Movil )
         cObserv  += "Móvil : " + Rtrim( ( dbfClient )->Movil ) + Space( 1 )
      end if

      if !Empty( ( dbfClient )->Fax )
         cObserv  += "Fax : " + Rtrim( ( dbfClient )->Fax ) + Space( 1 )
      end if

   end if

   aAdd( aData, cObserv )

   GenerarNotas( aData )

Return ( nil )

//---------------------------------------------------------------------------//
/*Esta funcion se usa para lanzar el diálogo para imprimir o visualizar las entregas a cuenta*/

STATIC FUNCTION PrnEntregas( lPrint, cAlbCliP, lTicket )

	local oDlg
   local oFmtEnt
   local cFmtEnt
   local oSayEnt
   local cSayEnt
   local cPrinter
   local oPrinter
   local nCopPrn
   local oCopPrn

   DEFAULT lPrint    := .t.
   DEFAULT lTicket   := .f.

   if lTicket
      cFmtEnt        := cFormatoEntregasCuentaEnCaja( oUser():cCaja(), dbfCajT )
      cPrinter       := cPrinterEntregasCuenta( oUser():cCaja(), dbfCajT )
      nCopPrn        := nCopiasEntregasCuentaEnCaja( oUser():cCaja(), dbfCajT )
   else
      cFmtEnt        := cFormatoDocumento( nil, "NENTALB", dbfCount )
      cPrinter       := PrnGetName()
      nCopPrn        := nCopiasDocumento( nil, "NENTALB", dbfCount )
   end if

   cSayEnt           := cNombreDoc( cFmtEnt )

   DEFINE DIALOG oDlg RESOURCE "IMPSERENT"

   REDEFINE GET oFmtEnt VAR cFmtEnt ;
      ID       100 ;
      COLOR    CLR_GET ;
      VALID    ( cDocumento( oFmtEnt, oSayEnt, dbfDoc ) ) ;
      BITMAP   "LUPA" ;
      ON HELP  ( BrwDocumento( oFmtEnt, oSayEnt, "EA" ) ) ;
      OF       oDlg

   REDEFINE GET oSayEnt VAR cSayEnt ;
      ID       101 ;
      WHEN     ( .f. );
      COLOR    CLR_GET ;
      OF       oDlg

   REDEFINE GET oPrinter VAR cPrinter ;
      WHEN     ( .f. ) ;
      ID       110 ;
      OF       oDlg

   TBtnBmp():ReDefine( 111, "Printer_preferences_16",,,,,{|| PrinterPreferences( oPrinter ) }, oDlg, .f., , .f.,  )

   REDEFINE GET oCopPrn VAR nCopPrn;
      ID       120 ;
      VALID    nCopPrn > 0 ;
		PICTURE 	"999999999" ;
      SPINNER ;
      MIN      1 ;
      MAX      99999 ;
      OF       oDlg

   REDEFINE BUTTON ;
      ID       500 ;
		OF 		oDlg ;
      ACTION   ( GenPrnEntregas( lPrint, cFmtEnt, cPrinter, if( lPrint, nCopPrn, 1 ), cAlbCliP, lTicket ), oDlg:End( IDOK ) )

   REDEFINE BUTTON ;
      ID       550 ;
		OF 		oDlg ;
      CANCEL ;
      ACTION   ( oDlg:end() )

   oDlg:bStart := {|| if( !lPrint, oCopPrn:Disable(), oCopPrn:Enable() ) }

   ACTIVATE DIALOG oDlg CENTER

return nil

//---------------------------------------------------------------------------//
/*
Esta funcion se utiliza para terminar de imprimir las entregas a cuenta
*/

Static Function GenPrnEntregas( lPrint, cFmtEnt, cPrinter, nCopies, cAlbCliP, lTicket )

   local n              := 1
   local oRpt
   local oDevice
   local cCaption       := 'Imprimiendo entrega a cuenta'
   local nRecno         := ( cAlbCliP )->( Recno() )

   DEFAULT lPrint       := .t.
   DEFAULT nCopies      := 1
   DEFAULT lTicket      := .f.

   if Empty( cFmtEnt )
      MsgStop( "Es necesario elegir un formato" )
      return nil
   end if

   if !lExisteDocumento( cFmtEnt, dbfDoc )
      return nil
   end if

   if lVisualDocumento( cFmtEnt, dbfDoc )

      PrintReportEntAlbCli( if( lPrint, IS_PRINTER, IS_SCREEN ), nCopies, cPrinter, dbfDoc, cAlbCliP, lTicket )

   else

      private cDbf         := dbfAlbCliT
      private cDbfEnt      := cAlbCliP
      private cCliente     := dbfClient
      private cDbfCli      := dbfClient
      private cFPago       := dbfFPago
      private cDbfPgo      := dbfFPago
      private cDbfAge      := dbfAgent
      private cDbfDiv      := dbfDiv
      private cPorDivEnt   := cPorDiv( ( cAlbCliP )->cDivPgo, dbfDiv )

      while n <= nCopies

         if !Empty( cPrinter )
            oDevice           := TPrinter():New( cCaption, .f., .t., cPrinter )
            REPORT oRpt CAPTION cCaption TO DEVICE oDevice
         else
            REPORT oRpt CAPTION cCaption PREVIEW
         end if

         if !Empty( oRpt ) .and. oRpt:lCreated
            oRpt:lFinish      := .f.
            oRpt:lAutoland    := .t.
            oRpt:lNoCancel    := .t.
            oRpt:bSkip        := {|| .t. }

            if lPrint
               oRpt:bPreview  := {| oDevice | PrintPreview( oDevice ) }
            else
            end if
         end if

         SetMargin( cFmtEnt, oRpt )
         PrintColum( cFmtEnt, oRpt )

         END REPORT

         if !Empty( oRpt )

            private nPagina   := oRpt:nPage
            private lEnd      := oRpt:lFinish

            ACTIVATE REPORT oRpt ;
               WHILE       ( .f. ) ;
               ON ENDPAGE  ( PrintItems( cFmtEnt, oRpt ) )

            if lPrint
               oRpt:oDevice:end()
            end if

         end if

         ( cAlbCliP )->( dbGoTo( nRecno ) )

         oRpt              := nil

         n++

      end while

   end if

Return nil

//---------------------------------------------------------------------------//

FUNCTION PrnEntAlb( cNumEnt, lPrint, dbfAlbCliP )

   local nLevel         := nLevelUsr( _MENUITEM_ )

   if nAnd( nLevel, 1 ) != 0 .or. nAnd( nLevel, ACC_IMPR ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if OpenFiles( nil, .t. )

      if dbSeekInOrd( cNumEnt, "nNumAlb", dbfAlbCliP )
         PrnEntregas( lPrint, dbfAlbCliP )
      end if

      CloseFiles()

   end if

Return .t.

//---------------------------------------------------------------------------//

#ifdef __HARBOUR__

/*Static Function EditMenu( nLevel, oBrw, oDlg )

   MENU oMenu

      MENUITEM    "Albaranes"

      MENUITEM    "&1. Edición"

         MENU

            MENUITEM    "&1. Añadir";
               ACTION   ( if( nAnd( nLevel, ACC_APPD ) != 0, WinAppRec( oBrw, bEdtPda, dbfAlbCliT ),  MsgStop( "Acceso no permitido" ) ) );

            MENUITEM    "&2. Modificar";
               ACTION   ( if( nAnd( nLevel, ACC_EDIT ) != 0, WinEdtRec( oBrw, bEdtPda, dbfAlbCliT ),  MsgStop( "Acceso no permitido" ) ) );

            MENUITEM    "&3. Eliminar";
               ACTION   ( if( nAnd( nLevel, ACC_DELE ) != 0, ( AlbRecDel(), oBrw:Refresh() ),         MsgStop( "Acceso no permitido" ) ) );

            MENUITEM    "&4. Zoom";
               ACTION   ( if( nAnd( nLevel, ACC_ZOOM ) != 0, WinZooRec( oBrw, bEdtPda, dbfAlbCliT ),  MsgStop( "Acceso no permitido" ) ) );

            MENUITEM    "&5. Generar nota";
               ACTION   ( if( nAnd( nLevel, ACC_ZOOM ) != 0, AlbCliNotas(),                           MsgStop( "Acceso no permitido" ) ) );

         ENDMENU

      MENUITEM    "&S. Salir";
         MESSAGE  "Salir de la ventana actual" ;
         RESOURCE "End" ;
         ACTION   ( oDlg:End() );

   ENDMENU

   oDlg:SetMenu( oMenu )

Return ( oMenu )*/

//---------------------------------------------------------------------------//

STATIC FUNCTION DupSerie( oWndBrw )

   local oDlg
   local oSerIni
   local oSerFin
   local oTxtDup
   local nTxtDup     := 0
   local nRecno      := ( dbfAlbCliT )->( Recno() )
   local nOrdAnt     := ( dbfAlbCliT )->( OrdSetFocus( 1 ) )
   local oDesde      := TDesdeHasta():Init( ( dbfAlbCliT )->cSerAlb, ( dbfAlbCliT )->nNumAlb, ( dbfAlbCliT )->cSufAlb, GetSysDate() )
   local lCancel     := .f.
   local oBtnAceptar
   local oBtnCancel
   local oFecDoc
   local cFecDoc     := GetSysDate()

   DEFINE DIALOG oDlg ;
      RESOURCE "DUPSERDOC" ;
      TITLE    "Duplicar series de albaranes" ;
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

   REDEFINE GET oFecDoc VAR cFecDoc ;
      ID       200 ;
      SPINNER ;
      OF       oDlg

   REDEFINE BUTTON oBtnAceptar ;
      ID       IDOK ;
		OF 		oDlg ;
      ACTION   ( DupStart( oDesde, oDlg, oBtnAceptar, oBtnCancel, oTxtDup, @lCancel, cFecDoc ) )

   REDEFINE BUTTON oBtnCancel ;
      ID       IDCANCEL ;
		OF 		oDlg ;
      CANCEL ;
      ACTION   ( lCancel := .t., oDlg:end() )

   REDEFINE METER oTxtDup VAR nTxtDup ;
      ID       160 ;
      NOPERCENTAGE ;
      TOTAL    ( dbfAlbCliT )->( OrdKeyCount() ) ;
      OF       oDlg

      oDlg:AddFastKey( VK_F5, {|| DupStart( oDesde, oDlg, oBtnAceptar, oBtnCancel, oTxtDup, @lCancel, cFecDoc ) } )

   ACTIVATE DIALOG oDlg CENTER VALID ( lCancel )

   ( dbfAlbCliT )->( dbGoTo( nRecNo ) )
   ( dbfAlbCliT )->( ordSetFocus( nOrdAnt ) )

   oWndBrw:SetFocus()
   oWndBrw:Refresh()

RETURN NIL

//--------------------------------------------------------------------------//

STATIC FUNCTION DupStart( oDesde, oDlg, oBtnAceptar, oBtnCancel, oTxtDup, lCancel, cFecDoc )

   local nOrd
   local nDuplicados    := 0
   local nProcesed      := 0

   oBtnAceptar:Hide()
   oBtnCancel:bAction   := {|| lCancel := .t. }

   if oDesde:nRadio == 1

      nOrd              := ( dbfAlbCliT )->( OrdSetFocus( "nNumAlb" ) )

      ( dbfAlbCliT )->( dbSeek( oDesde:cNumeroInicio(), .t. ) )

      while !lCancel .and. ( dbfAlbCliT )->( !eof() )

         if ( dbfAlbCliT )->cSerAlb >= oDesde:cSerieInicio  .and.;
            ( dbfAlbCliT )->cSerAlb <= oDesde:cSerieFin     .and.;
            ( dbfAlbCliT )->nNumAlb >= oDesde:nNumeroInicio .and.;
            ( dbfAlbCliT )->nNumAlb <= oDesde:nNumeroFin    .and.;
            ( dbfAlbCliT )->cSufAlb >= oDesde:cSufijoInicio .and.;
            ( dbfAlbCliT )->cSufAlb <= oDesde:cSufijoFin

            ++nDuplicados

            oTxtDup:cText  := "Duplicando : " + ( dbfAlbCliT )->cSerAlb + "/" + Alltrim( Str( ( dbfAlbCliT )->nNumAlb ) ) + "/" + ( dbfAlbCliT )->cSufAlb

            DupAlbaran( cFecDoc )

         end if

         ( dbfAlbCliT )->( dbSkip() )

         ++nProcesed

         oTxtDup:Set( nProcesed )

      end do

      ( dbfAlbCliT )->( OrdSetFocus( nOrd ) )

   else

      nOrd              := ( dbfAlbCliT )->( OrdSetFocus( "dFecAlb" ) )

      ( dbfAlbCliT )->( dbSeek( oDesde:dFechaInicio, .t. ) )

      while !lCancel .and. ( dbfAlbCliT )->( !eof() )

         if ( dbfAlbCliT )->dFecAlb >= oDesde:dFechaInicio  .and.;
            ( dbfAlbCliT )->dFecAlb <= oDesde:dFechaFin

            ++nDuplicados

            oTxtDup:cText  := "Duplicando : " + ( dbfAlbCliT )->cSerAlb + "/" + Alltrim( Str( ( dbfAlbCliT )->nNumAlb ) ) + "/" + ( dbfAlbCliT )->cSufAlb

            DupAlbaran( cFecDoc )

         end if

         ( dbfAlbCliT )->( dbSkip() )

         ++nProcesed

         oTxtDup:Set( nProcesed )

      end do

      ( dbfAlbCliT )->( OrdSetFocus( nOrd ) )

   end if

   lCancel              := .t.

   oBtnAceptar:Show()

   if lCancel
      msgStop( "Total de registros duplicados : " + Str( nDuplicados ), "Proceso cancelado" )
   else
      msgInfo( "Total de registros duplicados : " + Str( nDuplicados ), "Proceso finalizado" )
   end if

RETURN ( oDlg:End() )

//---------------------------------------------------------------------------//

STATIC FUNCTION AlbRecDup( cDbf, xField1, xField2, xField3, lCab, cFecDoc )

   local nRec           := ( cDbf )->( Recno() )
   local aTabla         := {}
   local nOrdAnt

   DEFAULT lCab         := .f.

   aTabla               := DBScatter( cDbf )
   aTabla[ _CSERALB ]   := xField1
   aTabla[ _NNUMALB ]   := xField2
   aTabla[ _CSUFALB ]   := xField3

   if lCab

      aTabla[ _CTURALB     ]  := cCurSesion()
      if !Empty( cFecDoc )
         aTabla[ _DFECALB  ]  := cFecDoc
      end if
      aTabla[ _CCODCAJ     ]  := oUser():cCaja()
      aTabla[ _LENTREGADO  ]  = .f.
      aTabla[ _DFECENT     ]  := Ctod("")
      aTabla[ _CNUMPED     ]  := Space( 12 )
      aTabla[ _CNUMFAC     ]  := Space( 12 )
      aTabla[ _LSNDDOC     ]  := .t.
      aTabla[ _LCLOALB     ]  := .f.
      aTabla[ _DFECENV     ]  := GetSysDate()
      aTabla[ _CCODUSR     ]  := cCurUsr()
      aTabla[ _DFECCRE     ]  := GetSysDate()
      aTabla[ _CTIMCRE     ]  := Time()
      aTabla[ _LIMPRIMIDO  ]  := .f.
      aTabla[ _DFECIMP     ]  := Ctod("")
      aTabla[ _CHORIMP     ]  := Space( 5 )
      aTabla[ _CCODDLG     ]  := oUser():cDelegacion()
      aTabla[ _LFACTURADO  ]  := .f.

      nOrdAnt                 := ( cDbf )->( OrdSetFocus( "NNUMALB" ) )

   end if

   if dbDialogLock( cDbf, .t. )
      aEval( aTabla, { | uTmp, n | ( cDbf )->( fieldPut( n, uTmp ) ) } )
      ( cDbf )->( dbUnLock() )
   end if

   if lCab
      ( cDbf )->( OrdSetFocus( nOrdAnt ) )
   end if

   ( cDbf )->( dbGoTo( nRec ) )

RETURN ( .t. )

//---------------------------------------------------------------------------//

STATIC FUNCTION DupAlbaran( cFecDoc )

   local nNewNumAlb  := 0

   //Recogemos el nuevo numero de factura--------------------------------------

   nNewNumAlb        := nNewDoc( ( dbfAlbCliT )->cSerAlb, dbfAlbCliT, "NALBCLI", , dbfCount )

   //Duplicamos las cabeceras--------------------------------------------------

   AlbRecDup( dbfAlbCliT, ( dbfAlbCliT )->cSerAlb, nNewNumAlb, ( dbfAlbCliT )->cSufAlb, .t., cFecDoc )

   //Duplicamos las lineas del documento---------------------------------------

   if ( dbfAlbCliL )->( dbSeek( ( dbfAlbCliT )->cSerAlb + Str( ( dbfAlbCliT )->nNumAlb ) + ( dbfAlbCliT )->cSufAlb ) )

      while ( dbfAlbCliT )->cSerAlb + Str( ( dbfAlbCliT )->nNumAlb ) + ( dbfAlbCliT )->cSufAlb == ( dbfAlbCliL )->cSerAlb + Str( ( dbfAlbCliL )->nNumAlb ) + ( dbfAlbCliL )->cSufAlb .and. ;
            !( dbfAlbCliL )->( Eof() )

         AlbRecDup( dbfAlbCliL, ( dbfAlbCliT )->cSerAlb, nNewNumAlb, ( dbfAlbCliT )->cSufAlb, .f. )

         ( dbfAlbCliL )->( dbSkip() )

      end while

   end if

   //Duplicamos los documentos-------------------------------------------------

   if ( dbfAlbCliD )->( dbSeek( ( dbfAlbCliT )->cSerAlb + Str( ( dbfAlbCliT )->nNumAlb ) + ( dbfAlbCliT )->cSufAlb ) )

      while ( dbfAlbCliT )->cSerAlb + Str( ( dbfAlbCliT )->nNumAlb ) + ( dbfAlbCliT )->cSufAlb == ( dbfAlbCliD )->cSerAlb + Str( ( dbfAlbCliD )->nNumAlb ) + ( dbfAlbCliD )->cSufAlb .and. ;
            !( dbfAlbCliD )->( Eof() )

         AlbRecDup( dbfAlbCliD, ( dbfAlbCliT )->cSerAlb, nNewNumAlb, ( dbfAlbCliT )->cSufAlb, .f. )

         ( dbfAlbCliD )->( dbSkip() )

      end while

   end if

RETURN ( .t. )
//---------------------------------------------------------------------------//

#endif

STATIC FUNCTION SetDialog( aGet, oSayDias, oSayTxtDias, oSayGetRnt, oGetRnt )

   if !Empty( oTipAlb )

      if oTipAlb:nAt == 2
         aGet[ _DFECENTR  ]:Show()
         aGet[ _DFECSAL   ]:Show()
         aGet[ _CCODSUALB ]:Hide()
         oSayDias:Show()
         oSayTxtDias:Show()
      else
         aGet[ _DFECENTR  ]:Hide()
         aGet[ _DFECSAL   ]:Hide()
         aGet[ _CCODSUALB ]:Show()
         oSayDias:Hide()
         oSayTxtDias:Hide()
      end if

      aGet[ _DFECSAL   ]:Refresh()
      aGet[ _DFECENTR  ]:Refresh()
      aGet[ _CCODSUALB ]:Refresh()
      oSayDias:Refresh()
      oSayTxtDias:Refresh()

   end if

   if !lAccArticulo() .or. oUser():lNotRentabilidad()

      if !Empty( oSayGetRnt )
         oSayGetRnt:Hide()
      end if

      if !Empty( oGetRnt )
         oGetRnt:Hide()
      end if

   end if

Return .t.

//---------------------------------------------------------------------------//

Static Function LoadTrans( aTmp, oGetCod, oGetKgs, oSayTrn )

   local uValor   := oGetCod:VarGet()

   if Empty( uValor )

      oSayTrn:cText( "" )
      oGetKgs:cText( 0 )

   else

      if oTrans:oDbf:SeekInOrd( uValor, "cCodTrn" )
         oGetCod:cText( uValor )
         oSayTrn:cText( oTrans:oDbf:cNomTrn )
         oGetKgs:cText( oTrans:oDbf:nKgsTrn )
      else
         msgStop( "Código de transportista no encontrado." )
         Return .f.
      end if

   end if

   RecalculaTotal( aTmp )

Return .t.

//---------------------------------------------------------------------------//

Function nPesAlbCli( cAlbaran, dbfAlbCliL, lPicture )

   local nOrd           := ( dbfAlbCliL )->( OrdSetFocus( "nNumAlb" ) )
   local nTotPes        := 0

   DEFAULT lPicture     := .f.

   if ( dbfAlbCliL )->( dbSeek( cAlbaran ) )

      while ( dbfAlbCliL )->cSerAlb + Str( ( dbfAlbCliL )->nNumAlb ) + ( dbfAlbCliL )->cSufAlb == cAlbaran .and. ( dbfAlbCliL )->( !eof() )

         if lValLine( dbfAlbCliL )

            nTotPes     += nPesLAlbCli( dbfAlbCliL )

         end if

         ( dbfAlbCliL )->( dbSkip() )

      end while

   end if

   ( dbfAlbCliL )->( OrdSetFocus( nOrd ) )

Return ( if( lPicture, Trans( nTotPes, MasUnd() ), nTotPes ) )

//--------------------------------------------------------------------------//

STATIC FUNCTION ValidaMedicion( aTmp, aGet )

   local cNewUndMed  := aGet[ _CUNIDAD ]:VarGet

   /*
   Cargamos el codigo de las unidades---------------------------------
   */

   if ( Empty( cOldUndMed ) .or. cOldUndMed != cNewUndMed )

      if oUndMedicion:oDbf:Seek( aTmp[ _CUNIDAD ] )

         if oUndMedicion:oDbf:nDimension >= 1 .and. !Empty( oUndMedicion:oDbf:cTextoDim1 )
            if !Empty( aGet[ ( dbfAlbCliL )->( fieldpos( "nMedUno" ) ) ] )
               aGet[ ( dbfAlbCliL )->( fieldpos( "nMedUno" ) ) ]:oSay:SetText( oUndMedicion:oDbf:cTextoDim1 )
               aGet[ ( dbfAlbCliL )->( fieldpos( "nMedUno" ) ) ]:cText( ( dbfArticulo )->nLngArt )
               aGet[ ( dbfAlbCliL )->( fieldpos( "nMedUno" ) ) ]:Show()
            else
               aTmp[ ( dbfAlbCliL )->( fieldpos( "nMedUno" ) ) ]  := ( dbfArticulo )->nLngArt
            end if
         else
            if !Empty( aGet[ ( dbfAlbCliL )->( fieldpos( "nMedUno" ) ) ] )
               aGet[ ( dbfAlbCliL )->( fieldpos( "nMedUno" ) ) ]:cText( 0 )
               aGet[ ( dbfAlbCliL )->( fieldpos( "nMedUno" ) ) ]:Hide()
            else
               aTmp[ ( dbfAlbCliL )->( fieldpos( "nMedUno" ) ) ]  := 0
            end if
         end if

         if oUndMedicion:oDbf:nDimension >= 2 .and. !Empty( oUndMedicion:oDbf:cTextoDim2 )
            if !Empty( aGet[ ( dbfAlbCliL )->( fieldpos( "nMedDos" ) ) ] )
               aGet[ ( dbfAlbCliL )->( fieldpos( "nMedDos" ) ) ]:oSay:SetText( oUndMedicion:oDbf:cTextoDim2 )
               aGet[ ( dbfAlbCliL )->( fieldpos( "nMedDos" ) ) ]:cText( ( dbfArticulo )->nAltArt )
               aGet[ ( dbfAlbCliL )->( fieldpos( "nMedDos" ) ) ]:Show()
            else
               aTmp[ ( dbfAlbCliL )->( fieldpos( "nMedDos" ) ) ]  := ( dbfArticulo )->nAltArt
            end if

         else
            if !Empty( aGet[ ( dbfAlbCliL )->( fieldpos( "nMedDos" ) ) ] )
               aGet[ ( dbfAlbCliL )->( fieldpos( "nMedDos" ) ) ]:cText( 0 )
               aGet[ ( dbfAlbCliL )->( fieldpos( "nMedDos" ) ) ]:Hide()
            else
                 aTmp[ ( dbfAlbCliL )->( fieldpos( "nMedDos" ) ) ]  := 0
            end if
         end if

         if oUndMedicion:oDbf:nDimension >= 3 .and. !Empty( oUndMedicion:oDbf:cTextoDim3 )
            if !Empty( aGet[ ( dbfAlbCliL )->( fieldpos( "nMedTre" ) ) ] )
               aGet[ ( dbfAlbCliL )->( fieldpos( "nMedTre" ) ) ]:oSay:SetText( oUndMedicion:oDbf:cTextoDim3 )
               aGet[ ( dbfAlbCliL )->( fieldpos( "nMedTre" ) ) ]:cText( ( dbfArticulo )->nAncArt )
               aGet[ ( dbfAlbCliL )->( fieldpos( "nMedTre" ) ) ]:Show()
            else
               aTmp[ ( dbfAlbCliL )->( fieldpos( "nMedTre" ) ) ]  := ( dbfArticulo )->nAncArt
            end if
         else
            if !Empty( aGet[ ( dbfAlbCliL )->( fieldpos( "nMedTre" ) ) ] )
               aGet[ ( dbfAlbCliL )->( fieldpos( "nMedTre" ) ) ]:cText( 0 )
               aGet[ ( dbfAlbCliL )->( fieldpos( "nMedTre" ) ) ]:Hide()
            else
               aTmp[ ( dbfAlbCliL )->( fieldpos( "nMedTre" ) ) ]  := 0
            end if
         end if

      else

         if !Empty( aGet[ ( dbfAlbCliL )->( fieldpos( "nMedUno" ) ) ] )
            aGet[ ( dbfAlbCliL )->( fieldpos( "nMedUno" ) ) ]:Hide()
            aGet[ ( dbfAlbCliL )->( fieldpos( "nMedUno" ) ) ]:cText( 0 )
         end if

         if !Empty( aGet[ ( dbfAlbCliL )->( fieldpos( "nMedDos" ) ) ] )
            aGet[ ( dbfAlbCliL )->( fieldpos( "nMedDos" ) ) ]:Hide()
            aGet[ ( dbfAlbCliL )->( fieldpos( "nMedDos" ) ) ]:cText( 0 )
         end if

         if !Empty( aGet[ ( dbfAlbCliL )->( fieldpos( "nMedTre" ) ) ] )
            aGet[ ( dbfAlbCliL )->( fieldpos( "nMedTre" ) ) ]:Hide()
            aGet[ ( dbfAlbCliL )->( fieldpos( "nMedTre" ) ) ]:cText( 0 )
         end if

      end if

      cOldUndMed := cNewUndMed

   end if

RETURN .t.

//---------------------------------------------------------------------------//

Static Function ChangeTarifa( aTmp, aGet, aTmpAlb )

    local nPrePro  := 0

   if !aTmp[ __LALQUILER ]

      nPrePro     := nPrePro( aTmp[ _CREF ], aTmp[ _CCODPR1 ], aTmp[ _CVALPR1 ], aTmp[ _CCODPR2 ], aTmp[ _CVALPR2 ], aTmp[ _NTARLIN ], aTmpAlb[ _LIVAINC ], dbfArtDiv, aTmpAlb[ _CCODTAR ] )

      if nPrePro == 0
         nPrePro  := nRetPreArt( aTmp[ _NTARLIN ], aTmpAlb[ _CDIVALB ], aTmpAlb[ _LIVAINC ], dbfArticulo, dbfDiv, dbfKit, dbfIva )
      end if

      if nPrePro != 0
         aGet[ _NSATUNIT ]:cText( nPrePro )
      end if

   else

      aGet[ _NSATUNIT ]:cText( 0 )
      aGet[ _NSATALQ  ]:cText( nPreAlq( aTmp[ _CREF ], aTmp[ _NTARLIN ], aTmpAlb[ _LIVAINC ], dbfArticulo ) )

   end if

return .t.

//---------------------------------------------------------------------------//

static Function cNomUbica( aTmp, aGet, dbfAlm )

   aTmp[_CCODUBI1]      := cGetUbica( aTmp[_CALMLIN], dbfAlm, 1 )
   aTmp[_CCODUBI2]      := cGetUbica( aTmp[_CALMLIN], dbfAlm, 2 )
   aTmp[_CCODUBI3]      := cGetUbica( aTmp[_CALMLIN], dbfAlm, 3 )

   if Empty( aTmp[_CCODUBI1] )
      aGet[_CCODUBI1]:Hide()
      aGet[_CVALUBI1]:Hide()
      aGet[_CNOMUBI1]:Hide()
   else
      aGet[_CCODUBI1]:Show()
      aGet[_CVALUBI1]:Show()
      aGet[_CNOMUBI1]:Show()
   end if

   if Empty( aTmp[_CCODUBI2] )
      aGet[_CCODUBI2]:Hide()
      aGet[_CVALUBI2]:Hide()
      aGet[_CNOMUBI2]:Hide()
   else
      aGet[_CCODUBI2]:Show()
      aGet[_CVALUBI2]:Show()
      aGet[_CNOMUBI2]:Show()
   end if

   if Empty( aTmp[_CCODUBI3] )
      aGet[_CCODUBI3]:Hide()
      aGet[_CVALUBI3]:Hide()
      aGet[_CNOMUBI3]:Hide()
   else
      aGet[_CCODUBI3]:Show()
      aGet[_CVALUBI3]:Show()
      aGet[_CNOMUBI3]:Show()
   end if

   aGet[_CCODUBI1]:Refresh()
   aGet[_CVALUBI1]:Refresh()
   aGet[_CNOMUBI1]:Refresh()
   aGet[_CCODUBI2]:Refresh()
   aGet[_CVALUBI2]:Refresh()
   aGet[_CNOMUBI3]:Refresh()
   aGet[_CCODUBI3]:Refresh()
   aGet[_CVALUBI3]:Refresh()
   aGet[_CNOMUBI3]:Refresh()

return .t.

//---------------------------------------------------------------------------//

#include "FastRepH.ch"

Static Function DataReport( oFr )

   /*
   Zona de datos------------------------------------------------------------
   */

   oFr:ClearDataSets()

   oFr:SetWorkArea(     "Albaranes", ( dbfAlbCliT )->( Select() ), .f., { FR_RB_CURRENT, FR_RB_CURRENT, 0 } )
   oFr:SetFieldAliases( "Albaranes", cItemsToReport( aItmAlbCli() ) )

   oFr:SetWorkArea(     "Lineas de albaranes", ( dbfAlbCliL )->( Select() ) )
   oFr:SetFieldAliases( "Lineas de albaranes", cItemsToReport( aColAlbCli() ) )

   oFr:SetWorkArea(     "Series de lineas de albaranes", ( dbfAlbCliS )->( Select() ) )
   oFr:SetFieldAliases( "Series de lineas de albaranes", cItemsToReport( aSerAlbCli() ) )

   oFr:SetWorkArea(     "Incidencias de albaranes", ( dbfAlbCliI )->( Select() ) )
   oFr:SetFieldAliases( "Incidencias de albaranes", cItemsToReport( aIncAlbCli() ) )

   oFr:SetWorkArea(     "Documentos de albaranes", ( dbfAlbCliD )->( Select() ) )
   oFr:SetFieldAliases( "Documentos de albaranes", cItemsToReport( aAlbCliDoc() ) )

   oFr:SetWorkArea(     "Entregas de albaranes", ( dbfAlbCliP )->( Select() ) )
   oFr:SetFieldAliases( "Entregas de albaranes", cItemsToReport( aItmAlbPgo() ) )

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

   oFr:SetWorkArea(     "Transportistas", oTrans:Select() )
   oFr:SetFieldAliases( "Transportistas", cObjectsToReport( oTrans:oDbf ) )

   oFr:SetWorkArea(     "Artículos", ( dbfArticulo )->( Select() ) )
   oFr:SetFieldAliases( "Artículos", cItemsToReport( aItmArt() ) )

   oFr:SetWorkArea(     "Tipo de venta", ( dbfTVta )->( Select() ) )
   oFr:SetFieldAliases( "Tipo de venta", cItemsToReport( aItmTVta() ) )

   oFr:SetWorkArea(     "Usuarios", ( dbfUsr )->( Select() ) )
   oFr:SetFieldAliases( "Usuarios", cItemsToReport( aItmUsr() ) )

   oFr:SetWorkArea(     "Ofertas", ( dbfOferta )->( Select() ) )
   oFr:SetFieldAliases( "Ofertas", cItemsToReport( aItmOfe() ) )

   oFr:SetWorkArea(     "Unidades de medición",  oUndMedicion:Select() )
   oFr:SetFieldAliases( "Unidades de medición",  cObjectsToReport( oUndMedicion:oDbf ) )

   oFr:SetMasterDetail( "Albaranes", "Lineas de albaranes",             {|| ( dbfAlbCliT )->cSerAlb + Str( ( dbfAlbCliT )->nNumAlb ) + ( dbfAlbCliT )->cSufAlb } )
   oFr:SetMasterDetail( "Albaranes", "Series de ineas de albaranes",    {|| ( dbfAlbCliT )->cSerAlb + Str( ( dbfAlbCliT )->nNumAlb ) + ( dbfAlbCliT )->cSufAlb } )
   oFr:SetMasterDetail( "Albaranes", "Incidencias de albaranes",        {|| ( dbfAlbCliT )->cSerAlb + Str( ( dbfAlbCliT )->nNumAlb ) + ( dbfAlbCliT )->cSufAlb } )
   oFr:SetMasterDetail( "Albaranes", "Documentos de albaranes",         {|| ( dbfAlbCliT )->cSerAlb + Str( ( dbfAlbCliT )->nNumAlb ) + ( dbfAlbCliT )->cSufAlb } )
   oFr:SetMasterDetail( "Albaranes", "Entregas de albaranes",           {|| ( dbfAlbCliT )->cSerAlb + Str( ( dbfAlbCliT )->nNumAlb ) + ( dbfAlbCliT )->cSufAlb } )
   oFr:SetMasterDetail( "Albaranes", "Clientes",                        {|| ( dbfAlbCliT )->cCodCli } )
   oFr:SetMasterDetail( "Albaranes", "Obras",                           {|| ( dbfAlbCliT )->cCodCli + ( dbfAlbCliT )->cCodObr } )
   oFr:SetMasterDetail( "Albaranes", "Almacen",                         {|| ( dbfAlbCliT )->cCodAlm } )
   oFr:SetMasterDetail( "Albaranes", "Rutas",                           {|| ( dbfAlbCliT )->cCodRut } )
   oFr:SetMasterDetail( "Albaranes", "Agentes",                         {|| ( dbfAlbCliT )->cCodAge } )
   oFr:SetMasterDetail( "Albaranes", "Formas de pago",                  {|| ( dbfAlbCliT )->cCodPago} )
   oFr:SetMasterDetail( "Albaranes", "Transportistas",                  {|| ( dbfAlbCliT )->cCodTrn } )
   oFr:SetMasterDetail( "Albaranes", "Empresa",                         {|| cCodigoEmpresaEnUso() } )
   oFr:SetMasterDetail( "Albaranes", "Usuarios",                        {|| ( dbfAlbCliT )->cCodUsr } )

   oFr:SetMasterDetail( "Lineas de albaranes", "Artículos",             {|| ( dbfAlbCliL )->cRef } )
   oFr:SetMasterDetail( "Lineas de albaranes", "Tipo de venta",         {|| ( dbfAlbCliL )->cTipMov } )
   oFr:SetMasterDetail( "Lineas de albaranes", "Ofertas",               {|| ( dbfAlbCliL )->cRef } )
   oFr:SetMasterDetail( "Lineas de albaranes", "Unidades de medición",  {|| ( dbfAlbCliL )->cUnidad } )

   oFr:SetResyncPair(   "Albaranes", "Lineas de albaranes" )
   oFr:SetResyncPair(   "Albaranes", "Series de lineas de albaranes" )
   oFr:SetResyncPair(   "Albaranes", "Incidencias de albaranes" )
   oFr:SetResyncPair(   "Albaranes", "Documentos de albaranes" )
   oFr:SetResyncPair(   "Albaranes", "Entregas de albaranes" )
   oFr:SetResyncPair(   "Albaranes", "Empresa" )
   oFr:SetResyncPair(   "Albaranes", "Clientes" )
   oFr:SetResyncPair(   "Albaranes", "Obras" )
   oFr:SetResyncPair(   "Albaranes", "Almacenes" )
   oFr:SetResyncPair(   "Albaranes", "Rutas" )
   oFr:SetResyncPair(   "Albaranes", "Agentes" )
   oFr:SetResyncPair(   "Albaranes", "Formas de pago" )
   oFr:SetResyncPair(   "Albaranes", "Transportistas" )
   oFr:SetResyncPair(   "Albaranes", "Usuarios" )

   oFr:SetResyncPair(   "Lineas de albaranes", "Artículos" )
   oFr:SetResyncPair(   "Lineas de albaranes", "Tipo de venta" )
   oFr:SetResyncPair(   "Lineas de albaranes", "Ofertas" )
   oFr:SetResyncPair(   "Lineas de albaranes", "Unidades de medición" )

Return nil

//---------------------------------------------------------------------------//

Static Function VariableReport( oFr )

   oFr:DeleteCategory(  "Albaranes" )
   oFr:DeleteCategory(  "Lineas de albaranes" )

   /*
   Creación de variables----------------------------------------------------
   */

   oFr:AddVariable(     "Albaranes",             "Total bruto",                         "GetHbVar('nTotBrt')" )
   oFr:AddVariable(     "Albaranes",             "Total albaran",                       "GetHbVar('nTotAlb')" )
   oFr:AddVariable(     "Albaranes",             "Total descuento",                     "GetHbVar('nTotDto')" )
   oFr:AddVariable(     "Albaranes",             "Total descuento pronto pago",         "GetHbVar('nTotDpp')" )
   oFr:AddVariable(     "Albaranes",             "Total bruto",                         "GetHbVar('nTotBrt')" )
   oFr:AddVariable(     "Albaranes",             "Total descuento",                     "GetHbVar('nTotDto')" )
   oFr:AddVariable(     "Albaranes",             "Total descuento pronto pago",         "GetHbVar('nTotDpp')" )
   oFr:AddVariable(     "Albaranes",             "Total descuentos",                    "GetHbVar('nTotalDto')" )
   oFr:AddVariable(     "Albaranes",             "Total neto",                          "GetHbVar('nTotNet')" )
   oFr:AddVariable(     "Albaranes",             "Total primer descuento definible",    "GetHbVar('nTotUno')" )
   oFr:AddVariable(     "Albaranes",             "Total segundo descuento definible",   "GetHbVar('nTotDos')" )
   oFr:AddVariable(     "Albaranes",             "Total " + cImp(),                     "GetHbVar('nTotIva')" )
   oFr:AddVariable(     "Albaranes",             "Total RE",                            "GetHbVar('nTotReq')" )
   oFr:AddVariable(     "Albaranes",             "Total entregado a cuenta",            "GetHbVar('nTotPag')" )
   oFr:AddVariable(     "Albaranes",             "Total retención",                     "GetHbVar('nTotRet')" )
   oFr:AddVariable(     "Albaranes",             "Total peso",                          "GetHbVar('nTotPes')" )
   oFr:AddVariable(     "Albaranes",             "Total costo",                         "GetHbVar('nTotCos')" )
   oFr:AddVariable(     "Albaranes",             "Total artículos",                     "GetHbVar('nTotArt')" )
   oFr:AddVariable(     "Albaranes",             "Total cajas",                         "GetHbVar('nTotCaj')" )
   oFr:AddVariable(     "Albaranes",             "Total punto verde",                   "GetHbVar('nTotPnt')" )
   oFr:AddVariable(     "Albaranes",             "Cuenta por defecto del cliente",      "GetHbVar('cCtaCli')" )

   oFr:AddVariable(     "Albaranes",             "Bruto primer tipo de " + cImp(),     "GetHbArrayVar('aIvaUno',1)" )
   oFr:AddVariable(     "Albaranes",             "Bruto segundo tipo de " + cImp(),    "GetHbArrayVar('aIvaDos',1)" )
   oFr:AddVariable(     "Albaranes",             "Bruto tercer tipo de " + cImp(),     "GetHbArrayVar('aIvaTre',1)" )
   oFr:AddVariable(     "Albaranes",             "Base primer tipo de " + cImp(),      "GetHbArrayVar('aIvaUno',2)" )
   oFr:AddVariable(     "Albaranes",             "Base segundo tipo de " + cImp(),     "GetHbArrayVar('aIvaDos',2)" )
   oFr:AddVariable(     "Albaranes",             "Base tercer tipo de " + cImp(),      "GetHbArrayVar('aIvaTre',2)" )
   oFr:AddVariable(     "Albaranes",             "Porcentaje primer tipo " + cImp(),   "GetHbArrayVar('aIvaUno',3)" )
   oFr:AddVariable(     "Albaranes",             "Porcentaje segundo tipo " + cImp(),  "GetHbArrayVar('aIvaDos',3)" )
   oFr:AddVariable(     "Albaranes",             "Porcentaje tercer tipo " + cImp(),   "GetHbArrayVar('aIvaTre',3)" )
   oFr:AddVariable(     "Albaranes",             "Porcentaje primer tipo RE",          "GetHbArrayVar('aIvaUno',4)" )
   oFr:AddVariable(     "Albaranes",             "Porcentaje segundo tipo RE",         "GetHbArrayVar('aIvaDos',4)" )
   oFr:AddVariable(     "Albaranes",             "Porcentaje tercer tipo RE",          "GetHbArrayVar('aIvaTre',4)" )
   oFr:AddVariable(     "Albaranes",             "Importe primer tipo " + cImp(),      "GetHbArrayVar('aIvaUno',8)" )
   oFr:AddVariable(     "Albaranes",             "Importe segundo tipo " + cImp(),     "GetHbArrayVar('aIvaDos',8)" )
   oFr:AddVariable(     "Albaranes",             "Importe tercer tipo " + cImp(),      "GetHbArrayVar('aIvaTre',8)" )
   oFr:AddVariable(     "Albaranes",             "Importe primer RE",                  "GetHbArrayVar('aIvaUno',9)" )
   oFr:AddVariable(     "Albaranes",             "Importe segundo RE",                 "GetHbArrayVar('aIvaDos',9)" )
   oFr:AddVariable(     "Albaranes",             "Importe tercer RE",                  "GetHbArrayVar('aIvaTre',9)" )

   oFr:AddVariable(     "Albaranes",             "Total unidades primer tipo de impuestos especiales",            "GetHbArrayVar('aIvmUno',1 )" )
   oFr:AddVariable(     "Albaranes",             "Total unidades segundo tipo de impuestos especiales",           "GetHbArrayVar('aIvmDos',1 )" )
   oFr:AddVariable(     "Albaranes",             "Total unidades tercer tipo de impuestos especiales",            "GetHbArrayVar('aIvmTre',1 )" )
   oFr:AddVariable(     "Albaranes",             "Importe del primer tipo de impuestos especiales",               "GetHbArrayVar('aIvmUno',2 )" )
   oFr:AddVariable(     "Albaranes",             "Importe del segundo tipo de impuestos especiales",              "GetHbArrayVar('aIvmDos',2 )" )
   oFr:AddVariable(     "Albaranes",             "Importe del tercer tipo de impuestos especiales",               "GetHbArrayVar('aIvmTre',2 )" )
   oFr:AddVariable(     "Albaranes",             "Total importe primer tipo de impuestos especiales",             "GetHbArrayVar('aIvmUno',3 )" )
   oFr:AddVariable(     "Albaranes",             "Total importe segundo tipo de impuestos especiales",            "GetHbArrayVar('aIvmDos',3 )" )
   oFr:AddVariable(     "Albaranes",             "Total importe tercer tipo de impuestos especiales",             "GetHbArrayVar('aIvmTre',3 )" )

   /*
   oFr:AddVariable(     "Albaranes",             "Fecha del primer vencimiento",        "GetHbArrayVar('aDatVto',1)" )
   oFr:AddVariable(     "Albaranes",             "Fecha del segundo vencimiento",       "GetHbArrayVar('aDatVto',2)" )
   oFr:AddVariable(     "Albaranes",             "Fecha del tercer vencimiento",        "GetHbArrayVar('aDatVto',3)" )
   oFr:AddVariable(     "Albaranes",             "Fecha del cuarto vencimiento",        "GetHbArrayVar('aDatVto',4)" )
   oFr:AddVariable(     "Albaranes",             "Fecha del quinto vencimiento",        "GetHbArrayVar('aDatVto',5)" )
   oFr:AddVariable(     "Albaranes",             "Importe del primer vencimiento",      "GetHbArrayVar('aImpVto',1)" )
   oFr:AddVariable(     "Albaranes",             "Importe del segundo vencimiento",     "GetHbArrayVar('aImpVto',2)" )
   oFr:AddVariable(     "Albaranes",             "Importe del tercero vencimiento",     "GetHbArrayVar('aImpVto',3)" )
   oFr:AddVariable(     "Albaranes",             "Importe del cuarto vencimiento",      "GetHbArrayVar('aImpVto',4)" )
   oFr:AddVariable(     "Albaranes",             "Importe del quinto vencimiento",      "GetHbArrayVar('aImpVto',5)" )
   */
   
   oFr:AddVariable(     "Lineas de albaranes",   "Detalle del artículo",                "CallHbFunc('cDesAlbCli')"  )
   oFr:AddVariable(     "Lineas de albaranes",   "Total unidades artículo",             "CallHbFunc('nTotNAlbCli')" )
   oFr:AddVariable(     "Lineas de albaranes",   "Precio unitario del artículo",        "CallHbFunc('nTotUAlbCli')" )
   oFr:AddVariable(     "Lineas de albaranes",   "Total línea de albaran",              "CallHbFunc('nTotLAlbCli')" )
   oFr:AddVariable(     "Lineas de albaranes",   "Total peso por línea",                "CallHbFunc('nPesLAlbCli')" )
   oFr:AddVariable(     "Lineas de albaranes",   "Total línea sin " + cImp(),           "CallHbFunc('nNetLAlbCli')" )
   oFr:AddVariable(     "Lineas de albaranes",   "Frase publicitaria en línea",         "CallHbFunc('cFraAlbCli')" )

   oFr:AddVariable(     "Lineas de albaranes",   "Fecha en juliano 6 meses",            "CallHbFunc('dJulianoAlbCli')" )
   oFr:AddVariable(     "Lineas de albaranes",   "Fecha en juliano 8 meses",            "CallHbFunc('dJulianoAlbAnio')" )

Return nil

//---------------------------------------------------------------------------//

Function DesignReportAlbCli( oFr, dbfDoc )

   local lOpen    := .f.
   local lFlag    := .f.

   /*
   Tratamiento para no hacer dos veces el openfiles al editar el documento en imprimir series
   */

   if lOpenFiles
      lFlag       := .t.
   else
      if Openfiles()
         lFlag    := .t.
         lOpen    := .t.
      else
         lFlag    := .f.
      end if
   end if

   if lFlag

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
                                                   "   CallHbFunc('nTotAlbCli');"                              + Chr(13) + Chr(10) + ;
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
         oFr:SetObjProperty(  "CabeceraColumnas",  "DataSet", "Albaranes" )

         oFr:AddBand(         "DetalleColumnas",   "MainPage", frxDetailData  )
         oFr:SetProperty(     "DetalleColumnas",   "Top", 230 )
         oFr:SetProperty(     "DetalleColumnas",   "Height", 28 )
         oFr:SetObjProperty(  "DetalleColumnas",   "DataSet", "Lineas de albaranes" )
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

      if lOpen
         CloseFiles()
      end if

   else

      Return .f.

   end if

Return .t.

//---------------------------------------------------------------------------//

Function PrintReportAlbCli( nDevice, nCopies, cPrinter, dbfDoc )

   local oFr
   local cFilePdf       := cPatTmp() + "AlbaranesCliente" + StrTran( ( dbfAlbCliT )->cSerAlb + Str( ( dbfAlbCliT )->nNumAlb ) + ( dbfAlbCliT )->cSufAlb, " ", "" ) + ".Pdf"

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

            oFr:SetProperty(  "PDFExport", "ShowDialog",       .f. )
            oFr:SetProperty(  "PDFExport", "DefaultPath",      cPatTmp() )
            oFr:SetProperty(  "PDFExport", "FileName",         cFilePdf )
            oFr:SetProperty(  "PDFExport", "EmbeddedFonts",    .t. )
            oFr:SetProperty(  "PDFExport", "PrintOptimized",   .t. )
            oFr:SetProperty(  "PDFExport", "Outline",          .t. )
            oFr:SetProperty(  "PDFExport", "OpenAfterExport",  .t. )
            oFr:DoExport(     "PDFExport" )

         case nDevice == IS_MAIL

            oFr:SetProperty(  "PDFExport", "ShowDialog",       .f. )
            oFr:SetProperty(  "PDFExport", "DefaultPath",      cPatTmp() )
            oFr:SetProperty(  "PDFExport", "FileName",         cFilePdf )
            oFr:SetProperty(  "PDFExport", "EmbeddedFonts",    .t. )
            oFr:SetProperty(  "PDFExport", "PrintOptimized",   .t. )
            oFr:SetProperty(  "PDFExport", "Outline",          .t. )
            oFr:SetProperty(  "PDFExport", "OpenAfterExport",  .f. )
            oFr:DoExport(     "PDFExport" )

            if file( cFilePdf )

               with object ( TGenMailing():New() )

                  :SetTypeDocument( "nAlbCli" )
                  :SetDe(           uFieldEmpresa( "cNombre" ) )
                  :SetCopia(        uFieldEmpresa( "cCcpMai" ) )
                  :SetAdjunto(      cFilePdf )
                  :SetPara(         RetFld( ( dbfAlbCliT )->cCodCli, dbfClient, "cMeiInt" ) )
                  :SetAsunto(       "Envio de albaran de cliente número " + ( dbfAlbCliT )->cSerAlb + "/" + Alltrim( Str( ( dbfAlbCliT )->nNumAlb ) ) )
                  :SetMensaje(      "Adjunto le remito nuestro albaran de cliente " + ( dbfAlbCliT )->cSerAlb + "/" + Alltrim( Str( ( dbfAlbCliT )->nNumAlb ) ) + Space( 1 ) )
                  :SetMensaje(      "de fecha " + Dtoc( ( dbfAlbCliT )->dFecAlb ) + Space( 1 ) )
                  :SetMensaje(      CRLF )
                  :SetMensaje(      CRLF )
                  :SetMensaje(      "Reciba un cordial saludo." )

                  :GeneralResource( dbfAlbCliT, aItmAlbCli() )

               end with

            end if

      end case

   end if

   /*
   Destruye el diseñador-------------------------------------------------------
   */

   oFr:DestroyFr()

Return .t.

//---------------------------------------------------------------------------//

Static Function DataReportEntAlbCli( oFr, cAlbCliP, lTicket )

   DEFAULT lTicket      := .f.

   /*
   Zona de datos------------------------------------------------------------
   */

   oFr:ClearDataSets()

   if !Empty( cAlbCliP )
      oFr:SetWorkArea(  "Entrega", ( cAlbCliP )->( Select() ), .f., { FR_RB_CURRENT, FR_RB_CURRENT, 0 } )
   else
      oFr:SetWorkArea(  "Entrega", ( dbfAlbCliP )->( Select() ), .f., { FR_RB_CURRENT, FR_RB_CURRENT, 0 } )
   end if
   oFr:SetFieldAliases( "Entrega", cItemsToReport( aItmAlbPgo() ) )

   if lTicket
   oFr:SetWorkArea(     "Albarán de cliente", ( dbfAlbCliT )->( Select() ) )
   oFr:SetFieldAliases( "Albarán de cliente", cItemsToReport( aItmAlbCli() ) )
   else
   oFr:SetWorkArea(     "Albarán de cliente", ( dbfAlbCliT )->( Select() ), .f., { FR_RB_CURRENT, FR_RB_CURRENT, 0 } )
   oFr:SetFieldAliases( "Albarán de cliente", cItemsToReport( aItmAlbCli() ) )
   end if

   oFr:SetWorkArea(     "Empresa", ( dbfEmp )->( Select() ) )
   oFr:SetFieldAliases( "Empresa", cItemsToReport( aItmEmp() ) )

   oFr:SetWorkArea(     "Clientes", ( dbfClient )->( Select() ) )
   oFr:SetFieldAliases( "Clientes", cItemsToReport( aItmCli() ) )

   oFr:SetWorkArea(     "Formas de pago", ( dbfFpago )->( Select() ) )
   oFr:SetFieldAliases( "Formas de pago", cItemsToReport( aItmFPago() ) )

   if lTicket
      if !Empty( cAlbCliP )
         oFr:SetMasterDetail( "Entrega", "Albarán de cliente",       {|| ( cAlbCliP )->cSerAlb + Str( ( cAlbCliP )->nNumAlb ) + ( cAlbCliP )->cSufAlb } )
      else
         oFr:SetMasterDetail( "Entrega", "Albarán de cliente",       {|| ( dbfAlbCliP )->cSerAlb + Str( ( dbfAlbCliP )->nNumAlb ) + ( dbfAlbCliP )->cSufAlb } )
      end if
   end if

   if !Empty( cAlbCliP )
   oFr:SetMasterDetail( "Entrega", "Clientes",                 {|| ( cAlbCliP )->cCodCli } )
   oFr:SetMasterDetail( "Entrega", "Formas de pago",           {|| ( cAlbCliP )->cCodPgo } )
   else
   oFr:SetMasterDetail( "Entrega", "Clientes",                 {|| ( dbfAlbCliP )->cCodCli } )
   oFr:SetMasterDetail( "Entrega", "Formas de pago",           {|| ( dbfAlbCliP )->cCodPgo } )
   end if

   oFr:SetMasterDetail( "Entrega", "Empresa",                  {|| cCodigoEmpresaEnUso() } )

   oFr:SetResyncPair(   "Entrega", "Empresa" )
   oFr:SetResyncPair(   "Entrega", "Clientes" )
   oFr:SetResyncPair(   "Entrega", "Formas de pago" )

Return nil

//---------------------------------------------------------------------------//

Static Function VariableReportEntAlbCli( oFr )

   /*
   Creación de variables----------------------------------------------------
   */

   oFr:AddVariable( "Albarán de cliente",    "Total bruto",                         "GetHbVar('nTotBrt')" )
   oFr:AddVariable( "Albarán de cliente",    "Total albaran",                       "GetHbVar('nTotAlb')" )
   oFr:AddVariable( "Albarán de cliente",    "Total descuento",                     "GetHbVar('nTotDto')" )
   oFr:AddVariable( "Albarán de cliente",    "Total descuento pronto pago",         "GetHbVar('nTotDpp')" )
   oFr:AddVariable( "Albarán de cliente",    "Total bruto",                         "GetHbVar('nTotBrt')" )
   oFr:AddVariable( "Albarán de cliente",    "Total descuento",                     "GetHbVar('nTotDto')" )
   oFr:AddVariable( "Albarán de cliente",    "Total descuento pronto pago",         "GetHbVar('nTotDpp')" )
   oFr:AddVariable( "Albarán de cliente",    "Total neto",                          "GetHbVar('nTotNet')" )
   oFr:AddVariable( "Albarán de cliente",    "Total primer descuento definible",    "GetHbVar('nTotUno')" )
   oFr:AddVariable( "Albarán de cliente",    "Total segundo descuento definible",   "GetHbVar('nTotDos')" )
   oFr:AddVariable( "Albarán de cliente",    "Total " + cImp(),                     "GetHbVar('nTotIva')" )
   oFr:AddVariable( "Albarán de cliente",    "Total RE",                            "GetHbVar('nTotReq')" )
   oFr:AddVariable( "Albarán de cliente",    "Total entregado a cuenta",            "GetHbVar('nTotPag')" )
   oFr:AddVariable( "Albarán de cliente",    "Total retención",                     "GetHbVar('nTotRet')" )
   oFr:AddVariable( "Albarán de cliente",    "Total peso",                          "GetHbVar('nTotPes')" )
   oFr:AddVariable( "Albarán de cliente",    "Total costo",                         "GetHbVar('nTotCos')" )
   oFr:AddVariable( "Albarán de cliente",    "Total anticipado",                    "GetHbVar('nTotAnt')" )
   oFr:AddVariable( "Albarán de cliente",    "Total artículos",                     "GetHbVar('nTotArt')" )
   oFr:AddVariable( "Albarán de cliente",    "Total cajas",                         "GetHbVar('nTotCaj')" )
   oFr:AddVariable( "Albarán de cliente",    "Bruto primer tipo de " + cImp(),      "GetHbArrayVar('aIvaUno',1)" )
   oFr:AddVariable( "Albarán de cliente",    "Bruto segundo tipo de " + cImp(),     "GetHbArrayVar('aIvaDos',1)" )
   oFr:AddVariable( "Albarán de cliente",    "Bruto tercer tipo de " + cImp(),      "GetHbArrayVar('aIvaTre',1)" )
   oFr:AddVariable( "Albarán de cliente",    "Base primer tipo de " + cImp(),       "GetHbArrayVar('aIvaUno',2)" )
   oFr:AddVariable( "Albarán de cliente",    "Base segundo tipo de " + cImp(),      "GetHbArrayVar('aIvaDos',2)" )
   oFr:AddVariable( "Albarán de cliente",    "Base tercer tipo de " + cImp(),       "GetHbArrayVar('aIvaTre',2)" )
   oFr:AddVariable( "Albarán de cliente",    "Porcentaje primer tipo " + cImp(),    "GetHbArrayVar('aIvaUno',3)" )
   oFr:AddVariable( "Albarán de cliente",    "Porcentaje segundo tipo " + cImp(),   "GetHbArrayVar('aIvaDos',3)" )
   oFr:AddVariable( "Albarán de cliente",    "Porcentaje tercer tipo " + cImp(),    "GetHbArrayVar('aIvaTre',3)" )
   oFr:AddVariable( "Albarán de cliente",    "Porcentaje primer tipo RE",           "GetHbArrayVar('aIvaUno',4)" )
   oFr:AddVariable( "Albarán de cliente",    "Porcentaje segundo tipo RE",          "GetHbArrayVar('aIvaDos',4)" )
   oFr:AddVariable( "Albarán de cliente",    "Porcentaje tercer tipo RE",           "GetHbArrayVar('aIvaTre',4)" )
   oFr:AddVariable( "Albarán de cliente",    "Importe primer tipo " + cImp(),       "GetHbArrayVar('aIvaUno',8)" )
   oFr:AddVariable( "Albarán de cliente",    "Importe segundo tipo " + cImp(),      "GetHbArrayVar('aIvaDos',8)" )
   oFr:AddVariable( "Albarán de cliente",    "Importe tercer tipo " + cImp(),       "GetHbArrayVar('aIvaTre',8)" )
   oFr:AddVariable( "Albarán de cliente",    "Importe primer RE",                   "GetHbArrayVar('aIvaUno',9)" )
   oFr:AddVariable( "Albarán de cliente",    "Importe segundo RE",                  "GetHbArrayVar('aIvaDos',9)" )
   oFr:AddVariable( "Albarán de cliente",    "Importe tercer RE",                   "GetHbArrayVar('aIvaTre',9)" )
   oFr:AddVariable( "Albarán de cliente",    "Fecha del primer vencimiento",        "GetHbArrayVar('aDatVto',1)" )
   oFr:AddVariable( "Albarán de cliente",    "Fecha del segundo vencimiento",       "GetHbArrayVar('aDatVto',2)" )
   oFr:AddVariable( "Albarán de cliente",    "Fecha del tercer vencimiento",        "GetHbArrayVar('aDatVto',3)" )
   oFr:AddVariable( "Albarán de cliente",    "Fecha del cuarto vencimiento",        "GetHbArrayVar('aDatVto',4)" )
   oFr:AddVariable( "Albarán de cliente",    "Fecha del quinto vencimiento",        "GetHbArrayVar('aDatVto',5)" )
   oFr:AddVariable( "Albarán de cliente",    "Importe del primer vencimiento",      "GetHbArrayVar('aImpVto',1)" )
   oFr:AddVariable( "Albarán de cliente",    "Importe del segundo vencimiento",     "GetHbArrayVar('aImpVto',2)" )
   oFr:AddVariable( "Albarán de cliente",    "Importe del tercero vencimiento",     "GetHbArrayVar('aImpVto',3)" )
   oFr:AddVariable( "Albarán de cliente",    "Importe del cuarto vencimiento",      "GetHbArrayVar('aImpVto',4)" )
   oFr:AddVariable( "Albarán de cliente",    "Importe del quinto vencimiento",      "GetHbArrayVar('aImpVto',5)" )

Return nil

//---------------------------------------------------------------------------//

Function DesignReportEntAlbCli( oFr, dbfDoc )

   if OpenFiles()

      /*
      Zona de datos------------------------------------------------------------
      */

      DataReportEntAlbCli( oFr )

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
                                                   "CallHbFunc('nTotAlbCli');"                                 + Chr(13) + Chr(10) + ;
                                                   "end;"                                                      + Chr(13) + Chr(10) + ;
                                                   "begin"                                                     + Chr(13) + Chr(10) + ;
                                                   "end." )

         oFr:AddPage(         "MainPage" )

         oFr:SetProperty(     "MainPage",          "OnBeforePrint", "DetalleOnMasterDetail" )

         oFr:AddBand(         "CuerpoDocumento",   "MainPage", frxPageHeader )
         oFr:SetProperty(     "CuerpoDocumento",   "Top", 0 )
         oFr:SetProperty(     "CuerpoDocumento",   "Height", 300 )

         oFr:AddBand(         "CabeceraColumnas",  "MainPage", frxMasterData )
         oFr:SetProperty(     "CabeceraColumnas",  "Top", 300 )
         oFr:SetProperty(     "CabeceraColumnas",  "Height", 0 )
         oFr:SetProperty(     "CabeceraColumnas",  "StartNewPage", .t. )
         oFr:SetObjProperty(  "CabeceraColumnas",  "DataSet", "Entrega" )

      end if

      /*
      Zona de variables--------------------------------------------------------
      */

      VariableReportEntAlbCli( oFr )

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

Function PrintReportEntAlbCli( nDevice, nCopies, cPrinter, dbfDoc, cAlbCliP, lTicket )

   local oFr
   local nRecAlbCliT    := ( dbfAlbCliT )->( Recno() )

   DEFAULT nDevice      := IS_SCREEN
   DEFAULT nCopies      := 1
   DEFAULT cPrinter     := PrnGetName()
   DEFAULT lTicket      := .f.

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

   DataReportEntAlbCli( oFr, cAlbCliP, lTicket )

   /*
   Cargar el informe-----------------------------------------------------------
   */

   if !Empty( ( dbfDoc )->mReport )

      oFr:LoadFromBlob( ( dbfDoc )->( Select() ), "mReport")

      /*
      Zona de variables--------------------------------------------------------
      */

      VariableReportEntAlbCli( oFr )

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

   ( dbfAlbCliT )->( dbGoTo( nRecAlbCliT ) )

Return .t.

//---------------------------------------------------------------------------//

FUNCTION PrnEntAlbCli( cNumDoc, lPrint, dbfTmpEnt )

   local nLevel         := nLevelUsr( _MENUITEM_ )

   if nAnd( nLevel, 1 ) != 0 .or. nAnd( nLevel, ACC_IMPR ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if OpenFiles( nil, .t. )

      if ( dbfTmpEnt )->( Used() )
         ( dbfTmpEnt )->( dbSetFilter( {|| Field->cSerAlb + Str( Field->nNumAlb ) + Field->cSufAlb + Str( Field->nNumRec ) == cNumDoc }, "cSerAlb + Str( nNumAlb ) + cSufAlb + Str( nNumRec ) == cNumDoc" ) )
         ( dbfTmpEnt )->( dbGoTop() )
      end if

      PrnEntregas( lPrint, dbfTmpEnt, .t. )

      ( dbfTmpEnt )->( DbClearFilter() )

      CloseFiles()

   end if

Return .t.

#else

//---------------------------------------------------------------------------//
//Funciones de PDA
//---------------------------------------------------------------------------//

STATIC FUNCTION pdaOpenFiles( lExt )

   local oError
   local oBlock

   if lOpenFiles
      MsgStop( 'Imposible abrir ficheros de albaranes de clientes' )
      Return ( .f. )
   end if

   oBlock               := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      lOpenFiles        := .t.

      USE ( cPatEmp() + "ALBCLIT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALBCLIT", @dbfAlbCliT ) )
      SET ADSINDEX TO ( cPatEmp() + "ALBCLIT.CDX" ) ADDITIVE

      USE ( cPatEmp() + "ALBCLIL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALBCLIL", @dbfAlbCliL ) )
      SET ADSINDEX TO ( cPatEmp() + "ALBCLIL.CDX" ) ADDITIVE

      USE ( cPatEmp() + "ALBCLII.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALBCLII", @dbfAlbCliI ) )
      SET ADSINDEX TO ( cPatEmp() + "ALBCLII.CDX" ) ADDITIVE

      USE ( cPatEmp() + "ALBCLID.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALBCLID", @dbfAlbCliD ) )
      SET ADSINDEX TO ( cPatEmp() + "ALBCLID.CDX" ) ADDITIVE

      USE ( cPatEmp() + "ALBCLIP.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALBCLIP", @dbfAlbCliP ) )
      SET ADSINDEX TO ( cPatEmp() + "ALBCLIP.CDX" ) ADDITIVE

      USE ( cPatCli() + "CLIENT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CLIENT", @dbfClient ) )
      SET ADSINDEX TO ( cPatCli() + "CLIENT.CDX" ) ADDITIVE

      USE ( cPatDat() + "TIVA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIVA", @dbfIva ) )
      SET ADSINDEX TO ( cPatDat() + "TIVA.CDX" ) ADDITIVE

      USE ( cPatGrp() + "FPAGO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FPAGO", @dbfFPago ) )
      SET ADSINDEX TO ( cPatGrp() + "FPAGO.CDX" ) ADDITIVE

      USE ( cPatEmp() + "TIPINCI.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIPINCI", @dbfInci ) )
      SET ADSINDEX TO ( cPatEmp() + "TIPINCI.CDX" ) ADDITIVE

      USE ( cPatCli() + "CliAtp.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CLIATP", @dbfCliAtp ) )
      SET ADSINDEX TO ( cPatCli() + "CliAtp.Cdx" ) ADDITIVE

      USE ( cPatCli() + "AGENTES.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "AGENTES", @dbfAgent ) )
      SET ADSINDEX TO ( cPatCli() + "AGENTES.CDX" ) ADDITIVE

      USE ( cPatCli() + "ObrasT.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "OBRAST", @dbfObrasT ) )
      SET ADSINDEX TO ( cPatCli() + "ObrasT.Cdx" ) ADDITIVE

      USE ( cPatArt() + "ARTICULO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ARTICULO", @dbfArticulo ) )
      SET ADSINDEX TO ( cPatArt() + "ARTICULO.CDX" ) ADDITIVE

      USE ( cPatArt() + "ArtCodebar.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CODEBAR", @dbfCodebar ) )
      SET ADSINDEX TO ( cPatGrp() + "ArtCodebar.Cdx" ) ADDITIVE

      USE ( cPatArt() + "FAMILIAS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FAMILIAS", @dbfFamilia ) )
      SET ADSINDEX TO ( cPatArt() + "FAMILIAS.CDX" ) ADDITIVE

      USE ( cPatArt() + "ARTKIT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ARTTIK", @dbfKit ) )
      SET ADSINDEX TO ( cPatArt() + "ARTKIT.CDX" ) ADDITIVE

      USE ( cPatArt() + "ArtDiv.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ARTDIV", @dbfArtDiv ) )
      SET ADSINDEX TO ( cPatArt() + "ArtDiv.Cdx" ) ADDITIVE

      USE ( cPatDat() + "DIVISAS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "DIVISAS", @dbfDiv ) )
      SET ADSINDEX TO ( cPatDat() + "DIVISAS.CDX" ) ADDITIVE

      USE ( cPatArt() + "OFERTA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "OFERTA", @dbfOferta ) )
      SET ADSINDEX TO ( cPatArt() + "OFERTA.CDX" ) ADDITIVE

      USE ( cPatCli() + "RUTA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "RUTA", @dbfRuta ) )
      SET ADSINDEX TO ( cPatCli() + "RUTA.CDX" ) ADDITIVE

      USE ( cPatAlm() + "Almacen.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALMACEN", @dbfAlm ) )
      SET ADSINDEX TO ( cPatAlm() + "Almacen.Cdx" ) ADDITIVE

      USE ( cPatDat() + "USERS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "USERS", @dbfUsr ) )
      SET ADSINDEX TO ( cPatDat() + "USERS.CDX" ) ADDITIVE

      USE ( cPatEmp() + "NCOUNT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "NCOUNT", @dbfCount ) )
      SET ADSINDEX TO ( cPatEmp() + "NCOUNT.CDX" ) ADDITIVE

      USE ( cPatArt() + "PROVART.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PROVART", @dbfArtPrv ) )
      SET ADSINDEX TO ( cPatArt() + "PROVART.CDX" ) ADDITIVE

      oTrans            := TTrans():Create( cPatCli() )
      if !oTrans:OpenFiles()
         lOpenFiles     := .f.
      end if

      oUndMedicion      := UniMedicion():Create( cPatGrp() )
      if !oUndMedicion:OpenFiles()
         lOpenFiles     := .f.
      end if

   RECOVER USING oError

      lOpenFiles        := .f.

      msgStop( "Imposible abrir todas las bases de datos" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   if !lOpenFiles
      pdaCloseFiles()
   end if

Return ( lOpenFiles )

//--------------------------------------------------------------------------//

STATIC FUNCTION pdaCloseFiles()

   if !Empty( oFont )
      oFont:end()
   end if

   if oWndBrw     != nil
		oWndBrw:oBrw:lCloseArea()
      oWndBrw     := nil
   else
      if !Empty( dbfAlbCliT )
         ( dbfAlbCliT )->( dbCloseArea() )
      end if
   end if
   if !Empty( dbfClient )
      ( dbfClient    )->( dbCloseArea() )
   end if
   if !Empty( dbfIva )
      ( dbfIva       )->( dbCloseArea() )
   end if
   if !Empty( dbfFPago )
      ( dbfFPago     )->( dbCloseArea() )
   end if
   if !Empty( dbfAlbCliL )
      ( dbfAlbCliL   )->( dbCloseArea() )
   end if
   if !Empty( dbfAlbCliI )
      ( dbfAlbCliI   )->( dbCloseArea() )
   end if
   if !Empty( dbfAlbCliD )
      ( dbfAlbCliD   )->( dbCloseArea() )
   end if
   if !Empty( dbfAlbCliP )
      ( dbfAlbCliP   )->( dbCloseArea() )
   end if
   if !Empty( dbfAgent )
      ( dbfAgent     )->( dbCloseArea() )
   end if
   if !Empty( dbfArtPrv )
      ( dbfArtPrv     )->( dbCloseArea() )
   end if
   if !Empty( dbfArtDiv )
      ( dbfArtDiv     )->( dbCloseArea() )
   end if
   if !Empty( dbfArticulo )
      ( dbfArticulo  )->( dbCloseArea() )
   end if
   if !Empty( dbfCodebar )
      ( dbfCodebar   )->( dbCloseArea() )
   end if
   if !Empty( dbfFamilia )
      ( dbfFamilia   )->( dbCloseArea() )
   end if
   if !Empty( dbfKit )
      ( dbfKit       )->( dbCloseArea() )
   end if
   if !Empty( dbfAlm )
      ( dbfAlm       )->( dbCloseArea() )
   end if
   if !Empty( dbfCliAtp )
      ( dbfCliAtp    )->( dbCloseArea() )
   end if
   if !Empty( dbfDiv )
      ( dbfDiv       )->( dbCloseArea() )
   end if
   if !Empty( dbfOferta )
      ( dbfOferta    )->( dbCloseArea() )
   end if
   if !Empty( dbfObrasT )
      ( dbfObrasT    )->( dbCloseArea() )
   end if
   if !Empty( dbfRuta )
      ( dbfRuta      )->( dbCloseArea() )
   end if
   if !Empty( dbfUsr )
      ( dbfUsr )->( dbCloseArea() )
   end if
   if dbfInci != nil
      ( dbfInci )->( dbCloseArea() )
   end if
   if dbfCount != nil
      ( dbfCount )->( dbCloseArea() )
   end if

   if !Empty( oTrans )
      oTrans:end()
   end if
   if !Empty( oUndMedicion )
      oUndMedicion:end()
   end if

   dbfClient      := nil
   dbfIva         := nil
   dbfAlbCliL     := nil
   dbfAlbCliT     := nil
   dbfAlbCliI     := nil
   dbfAlbCliD     := nil
   dbfAlbCliP     := nil
   dbfPedCliT     := nil
   dbfPedCliL     := nil
   dbfPedCliR     := nil
   dbfPedCliP     := nil
   dbfPedCliI     := nil
   dbfPedCliD     := nil
   dbfTikT        := nil
   dbfFPago       := nil
   dbfAgent       := nil
   dbfAlm         := nil
   dbfTarPreL     := nil
   dbfTarPreS     := nil
   dbfPromoT      := nil
   dbfPromoL      := nil
   dbfPromoC      := nil
   dbfArticulo    := nil
   dbfCodebar     := nil
   dbfFamilia     := nil
   dbfKit         := nil
   dbfCliAtp      := nil
   dbfTVta        := nil
   dbfDiv         := nil
   oBandera       := nil
   dbfDoc         := nil
   dbfTblCnv      := nil
   dbfOferta      := nil
   dbfObrasT      := nil
   dbfPro         := nil
   dbfFlt         := nil
   dbfTblPro      := nil
   dbfRuta        := nil
   dbfArtDiv      := nil
   dbfCajT        := nil
   dbfUsr         := nil
   dbfInci        := nil
   dbfArtPrv      := nil
   dbfAntCliT     := nil
   dbfDelega      := nil
   dbfCount       := nil
   dbfUbicaL      := nil
   dbfAgeCom      := nil
   dbfFacCliT     := nil
   dbfFacRecT     := nil
   dbfFacRecL     := nil
   dbfTikT        := nil
   dbfEmp         := nil

   oStock         := nil
   oGrpCli        := nil
   oNewImp        := nil
   oTrans         := nil
   oTipArt        := nil
   oGrpFam        := nil
   oUndMedicion   := nil
   oFraPub        := nil

   lOpenFiles     := .f.

   oWndBrw        := nil

Return .t.

//--------------------------------------------------------------------------//

Function pdaAlbCli( oMenuItem )

   local oDlg
   local oBrw
   local nLevel
   local oGetBuscar
   local cGetBuscar     := Space( 100 )
   local oCbxOrden
   local cCbxOrden      := "Número"
   local oSayTit
   local oFont
   local oBtn

   nLevel               := nLevelUsr( _MENUITEM_ )

   if nAnd( nLevel, 1 ) != 0
      msgStop( "Acceso no permitido." )
      return .f.
   end if

   /*
   Abrimos los ficheros--------------------------------------------------------
   */

   if !pdaOpenFiles()
      return .f.
   end if

   /*
   Creamos el Shell------------------------------------------------------------
   */

      DEFINE FONT oFont NAME "Verdana" SIZE 0, -14

      DEFINE DIALOG oDlg RESOURCE "Dlg_info"

      REDEFINE SAY oSayTit ;
         VAR      "Albaranes" ;
         ID       140 ;
         COLOR    "N/W*" ;
         FONT     oFont ;
         OF       oDlg

      REDEFINE BTNBMP oBtn ;
         ID       130 ;
         OF       oDlg ;
         FILE     ( cPatBmp() + "document_plain_user1_16.bmp" ) ;
         NOBORDER ;
         ACTION      ( nil )

      oBtn:SetColor( 0, nRGB( 255, 255, 255 )  )

      REDEFINE GET oGetBuscar ;
         VAR      cGetBuscar;
         ID       110 ;
         BITMAP   "FIND" ;
         OF       oDlg

      oGetBuscar:bChange   := {| nKey, nFlags | AutoSeek( nKey, nFlags, oGetBuscar, oBrw, dbfAlbCliT ) }

      REDEFINE COMBOBOX oCbxOrden ;
         VAR      cCbxOrden ;
         ID       120 ;
         ITEMS    { "Número", "Fecha", "Código", "Nombre" } ;
			OF 		oDlg

      oCbxOrden:bChange    := {|| ( dbfAlbCliT )->( OrdSetFocus( oCbxOrden:nAt ) ), ( dbfAlbCliT )->( dbGoTop() ), oBrw:Refresh(), oGetBuscar:SetFocus(), oCbxOrden:Refresh() }

      REDEFINE IBROWSE oBrw;
         FIELDS   (dbfAlbCliT)->cSerAlb + "/" + AllTrim( Str( ( dbfAlbCliT )->nNumAlb ) ) + "/" + ( dbfAlbCliT )->cSufAlb + CRLF + Dtoc( (dbfAlbCliT)->dFecAlb ) ,;
                  (dbfAlbCliT)->cNomCli,;
                  nTotAlbCli( ( dbfAlbCliT )->cSerAlb + Str( ( dbfAlbCliT )->nNumAlb ) + ( dbfAlbCliT )->cSufAlb, dbfAlbCliT, dbfAlbCliL, dbfIva, dbfDiv, nil, cDivEmp(), .t. );
         HEAD     "Número" + CRLF + "Fecha",;
                  "Cliente",;
                  "Importe ";
         FIELDSIZES ;
                  100,;
                  180,;
                  40;
         JUSTIFY  .f.,;
                  .f.,;
                  .t. ;
         ALIAS    ( dbfAlbCliT ) ;
         ID       100 ;
         OF       oDlg

   ACTIVATE DIALOG oDlg ;
      ON INIT ( oDlg:SetMenu( pdaBuildMenu( oDlg, oBrw ) ) )

   pdaCloseFiles()

   oFont:End()

   // Restauramos la ventana---------------------------------------------------

   oWnd():Show()

RETURN ( nil )

//---------------------------------------------------------------------------//

static function pdaBuildMenu( oDlg, oBrw )

   local oMenu

   DEFINE MENU oMenu ;
      RESOURCE 500 ;
      BITMAPS  60 ; // bitmaps resoruces ID
      IMAGES   6     // number of images in the bitmap

      REDEFINE MENUITEM ID 510 OF oMenu ACTION ( WinAppRec( oBrw, bEdtPda, dbfAlbCliT ) )

      REDEFINE MENUITEM ID 520 OF oMenu ACTION ( WinEdtRec( oBrw, bEdtPda, dbfAlbCliT, oDlg ) )

      REDEFINE MENUITEM ID 530 OF oMenu ACTION ( WinDelRec( oBrw, dbfAlbCliT, {|| QuiAlbPda() } ) )

      REDEFINE MENUITEM ID 540 OF oMenu ACTION ( WinZooRec( oBrw, bEdtPda, dbfAlbCliT, oDlg ) )

      REDEFINE MENUITEM ID 550 OF oMenu ACTION ( pdaGenAlbCli( oBrw, dbfAlbCliT, dbfAlbCliL ) )

      REDEFINE MENUITEM ID 560 OF oMenu ACTION ( oDlg:End() )

Return oMenu

//---------------------------------------------------------------------------//

Static Function pdaGenAlbCli( oBrw, dbfAlbCliT, dbfAlbCliL )

   local cTextToPrint   := ""
   local cCodAlbCli     := ( dbfAlbCliT )->cSerAlb + Str( ( dbfAlbCliT )->nNumAlb ) + ( dbfAlbCliT )->cSufAlb
   local oError
   local oBlock

   oBlock               := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   /*
   Cargamos los valores iniciales con nTotAlbCli-------------------------------
   */

   nTotAlbCli( cCodAlbCli, dbfAlbCliT, dbfAlbCliL )

   /*
   Cabecera del documento------------------------------------------------------
   */

   cTextToPrint         += CRLF + CRLF

   cTextToPrint         += "Albaran    : " + ( dbfAlbCliT )->cSerAlb + "/" + Alltrim( Str( ( dbfAlbCliT )->nNumAlb ) ) + "-" + ( dbfAlbCliT )->cSufAlb + CRLF

   cTextToPrint         += "Fecha      : " + Dtoc( ( dbfAlbCliT )->dFecAlb ) + CRLF

   cTextToPrint         += "Cliente    : " + AllTrim( ( dbfAlbCliT )->cCodCli ) + " - " + RTrim( ( dbfAlbCliT )->cNomCli ) + CRLF

   cTextToPrint         += "Establec.  : " + Padr( RetFld( ( dbfAlbCliT )->cCodCli, dbfClient, "NbrEst" ), 46 ) + CRLF

   cTextToPrint         += "N.I.F.     : " + ( dbfAlbCliT )->cDniCli + CRLF

   cTextToPrint         += "Direccion  : " + RTrim( ( dbfAlbCliT )->cDirCli ) + CRLF

   cTextToPrint         += "CP y Pobl. : " + RTrim( ( dbfAlbCliT )->cPosCli ) + Space( 1 ) + RTrim( ( dbfAlbCliT )->cPobCli ) + CRLF

   cTextToPrint         += "Provincia  : " + RTrim( ( dbfAlbCliT )->cPrvCli ) + CRLF

   cTextToPrint         += Replicate( "_" , 60 ) + CRLF

   /*
   Lineas del documento--------------------------------------------------------
   */
                        //           1         2         3         4         5         6
                        //  123456789012345678901234567890123456789012345678901234567890
   cTextToPrint         += "Codigo Descripcion                     Und.  Precio    Total" + CRLF
   cTextToPrint         += "------ ------------------------------ ----- ------- --------" + CRLF

   if ( dbfAlbCliL )->( dbSeek( cCodAlbCli ) )

      while ( dbfAlbCliL )->cSerAlb + Str( ( dbfAlbCliL )->nNumAlb ) + ( dbfAlbCliL )->cSufAlb == cCodAlbCli .and. !( dbfAlbCliL )->( eof() )

          cTextToPrint  += SubStr( ( dbfAlbCliL )->cRef, 1, 6 )                                         + Space( 1 )
          cTextToPrint  += SubStr( ( dbfAlbCliL )->cDetalle, 1, 30 )                                    + Space( 1 )
          cTextToPrint  += Right( Trans( nTotNAlbCli( dbfAlbCliL ), MasUnd() ), 5 )                     + Space( 1 )
          cTextToPrint  += Right( Trans( nTotUAlbCli( dbfAlbCliL, nDouDiv ), cPouDiv ), 7 )             + Space( 1 )
          cTextToPrint  += Right( Trans( nTotLAlbCli( dbfAlbCliL, nDouDiv, nRouDiv ), cPorDiv ), 8 )    + CRLF

          if ( dbfAlbCliL )->lLote
             cTextToPrint  += "       Lote: " + Padr( ( dbfAlbCliL )->cLote, 47 )                       + CRLF
          end if

          ( dbfAlbCliL )->( dbSkip() )

      end while

   end if

   /*
   Pie del documento-----------------------------------------------------------
   */

   cTextToPrint         += Replicate( "_" , 60 ) + CRLF

                        //           1         2         3         4         5         6
                        //  123456789012345678901234567890123456789012345678901234567890
   cTextToPrint         += "   Base IGIC%   Importe RE%    Importe   Base   " + Right( Str( nTotNet ), 12 ) + CRLF
   cTextToPrint         += "------- ---- --------- ---- ---------   IGIC " + Right( Str( nTotIva ), 12 ) + CRLF

   cTextToPrint         += Right( Trans( aIvaUno[ 2 ], cPorDiv )  , 7 ) + Space(1)
   cTextToPrint         += Right( Trans( aIvaUno[ 3 ], "@E 99.9" ), 4 ) + Space(1)
   cTextToPrint         += Right( Trans( aIvaUno[ 8 ], cPorDiv )  , 9 ) + Space(1)
   cTextToPrint         += Right( Trans( aIvaUno[ 4 ], "@E 99.9" ), 4 ) + Space(1)
   cTextToPrint         += Right( Trans( aIvaUno[ 9 ], cPorDiv )  , 9 ) + Space(3)
   cTextToPrint         += "R.E.   " + Right( Str( nTotReq ), 12 )

   if aIvaDos[ 3 ] != nil

      cTextToPrint      += Right( Trans( aIvaDos[ 2 ], cPorDiv )  , 9 ) + Space(1)
      cTextToPrint      += Right( Trans( aIvaDos[ 3 ], "@E 99.9" ), 4 ) + Space(1)
      cTextToPrint      += Right( Trans( aIvaDos[ 8 ], cPorDiv )  , 9 ) + Space(1)
      cTextToPrint      += Right( Trans( aIvaUno[ 4 ], "@E 99.9" ), 4 ) + Space(1)
      cTextToPrint      += Right( Trans( aIvaUno[ 9 ], cPorDiv )  , 9 ) + Space(3)
      cTextToPrint      += "-------------------"

   else
                        //           1         2         3         4         5         6
                        //  123456789012345678901234567890123456789012345678901234567890
      cTextToPrint      += "                                         -------------------"

   end if

   if aIvaTre[ 3 ] != nil

      cTextToPrint      += Right( Trans( aIvaTre[ 2 ], cPorDiv )  , 9 ) + Space(1)
      cTextToPrint      += Right( Trans( aIvaTre[ 3 ], "@E 99.9" ), 4 ) + Space(1)
      cTextToPrint      += Right( Trans( aIvaTre[ 8 ], cPorDiv )  , 9 ) + Space(1)
      cTextToPrint      += Right( Trans( aIvaUno[ 4 ], "@E 99.9" ), 4 ) + Space(1)
      cTextToPrint      += Right( Trans( aIvaUno[ 9 ], cPorDiv )  , 9 ) + Space(3)
      cTextToPrint       += "TOTAL  " + Right( Str( nTotAlb ) , 12 ) + CRLF

   else
                        //           1         2         3         4         5         6
                        //  123456789012345678901234567890123456789012345678901234567890
      cTextToPrint      += "                                         TOTAL  " + Right( Str( nTotAlb ) , 12 ) + CRLF

   end if

   cTextToPrint         += Replicate( "_" , 60 ) + CRLF

   msginfo( "Compruebe si la impresora está en línea y si tiene papel suficiente" )
   SendText( cTextToPrint )

   RECOVER

      msgStop( "Ocurrió un error a la hora de imprimir albaranes" )

   END SEQUENCE

   ErrorBlock( oBlock )

return .t.

//---------------------------------------------------------------------------//

STATIC FUNCTION EdtPda( aTmp, aGet, dbfAlbCliT, oBrw, cCodCli, cCodArt, nMode )

   local aBtn        := Array( 8 )
   local oDlg
   local oFld
   local nOrd
   local oBrwLin
   local oBrwInc
   local cNbrObr
   local oNbrObr
   local oSayPgo
   local cSayPgo
   local oSayAge
   local cSayAge
   local cRuta
   local oRuta
   local nRieCli
   local oRieCli
   local nTotAlbCli
   local oTitulo
   local cTitulo        := LblTitle( nMode ) + " albarán de cliente"
   local oTlfCli
   local cTlfCli
   local cEstAlb
   local nTotAlbLin     := 0
   local oSayTit

   /*
   Este valor los guaradamos para detectar los posibles cambios
   */

   cOldCodCli           := aTmp[ _CCODCLI ]

  do case
   case nMode == APPD_MODE

         aTmp[ _CSUFALB   ]   := RetSufEmp()
         aTmp[ _CCODALM   ]   := cDefAlm()
         aTmp[ _CDIVALB   ]   := cDivEmp()
         aTmp[ _CCODPAGO  ]   := cDefFpg()
         aTmp[ _CCODCAJ   ]   := oUser():cCaja()
         aTmp[ _CCODUSR   ]   := cCurUsr()
         aTmp[ _NVDVALB   ]   := nChgDiv( aTmp[ _CDIVALB ], dbfDiv )
         aTmp[ _LFACTURADO]   := .f.
         aTmp[ _LSNDDOC   ]   := .t.
         aTmp[ _CSUFALB   ]   := cSufPda()
         aTmp[ _CSERALB   ]   := cNewSer( "NALBCLI", dbfCount )
         aTmp[ _DFECENV   ]   := Ctod( "" )
         aTmp[ _DFECIMP   ]   := Ctod( "" )
         aTmp[ _CCODDLG   ]   := oUser():cDelegacion()
         aTmp[ _LIVAINC   ]   := uFieldEmpresa( "lIvaInc", .f. )
         aTmp[ _CMANOBR   ]   := Padr( "Gastos", 250 )
         aTmp[ _CCODAGE ]     := cCodAge()
         aTmp[ _CCODTRN ]     := Padr( cCodTra(), 9 )

         if !Empty( cCodCli )
            aTmp[ _CCODCLI ]  := cCodCli
         end if

      case nMode == EDIT_MODE

         if aTmp[ _LFACTURADO ]
            MsgStop( "El albarán ya fue facturado" )
            return .t.
         end if

   end case

   if Empty( aTmp[ _CSERALB ] )
      aTmp[ _CSERALB ]  := "A"
   end if

   if Empty( aTmp[ _NTARIFA ] )
      aTmp[ _NTARIFA ]  := 1
   end if

   aTmp[ _CCODAGE ]     := cCodAge()

   if Empty( aTmp[ _CDTOESP ] )
      aTmp[ _CDTOESP ]  := Padr( "General", 50 )
   end if

   if Empty( aTmp[ _CDPP ] )
      aTmp[ _CDPP ]     := Padr( "Pronto pago", 50 )
   end if

   /*
   Comineza la transaccion-----------------------------------------------------
   */

   if BeginTrans( aTmp, nMode )
      Return .f.
   end if

   if nMode != APPD_MODE

        if aTmp[ _LFACTURADO ]
          cEstAlb       := "Facturado"
       else
          cEstAlb       := "Pendiente"
       end if

   end if

   /*
   Necestamos el orden el la primera clave
   */

   nOrd                 := ( dbfAlbCliT )->( ordSetFocus( 1 ) )

   cPicUnd              := MasUnd()
   cPouDiv              := cPouDiv( aTmp[ _CDIVALB ], dbfDiv ) // Picture de la divisa
   cPorDiv              := cPorDiv( aTmp[ _CDIVALB ], dbfDiv ) // Picture de la divisa
   nDouDiv              := nDouDiv( aTmp[ _CDIVALB ], dbfDiv )
   nRouDiv              := nRouDiv( aTmp[ _CDIVALB ], dbfDiv )


   oFont                := TFont():New( "Arial", 8, 26, .f., .t. )

   /*
   Etiquetas-------------------------------------------------------------------
   */

   cNbrObr              := RetFld( aTmp[ _CCODCLI ] + aTmp[ _CCODOBR ], dbfObrasT, "cNomObr" )
   cSayPgo              := RetFld( aTmp[ _CCODPAGO ], dbfFPago, "CDESPAGO")
   cRuta                := RetFld( aTmp[ _CCODRUT ], dbfRuta,  "CDESRUT")
   cSayAge              := cNbrAgent( aTmp[ _CCODAGE ], dbfAgent )

   DEFINE DIALOG oDlg RESOURCE "PEDCLI_PDA_4"

   REDEFINE FOLDER oFld ;
      ID          200 ;
      OF          oDlg ;
      PROMPT      "Albaranes",       "Líneas",         "Incidencias",    "Totales" ;
      DIALOGS     "ALBCLI_PDA_1",   "ALBCLI_PDA_2",   "ALBCLI_PDA_4",   "ALBCLI_PDA_3"

      REDEFINE GET aGet[ _CSERALB ] ;
         VAR      aTmp[ _CSERALB ] ;
         ID       100 ;
         PICTURE  "@!" ;
         WHEN     ( nMode == APPD_MODE .OR. nMode == DUPL_MODE );
         VALID    ( aTmp[ _CSERALB ] >= "A" .AND. aTmp[ _CSERALB ] <= "Z"  );
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _NNUMALB ] VAR aTmp[ _NNUMALB ];
         ID       101 ;
			PICTURE 	"999999999" ;
			WHEN 		.F. ;
			OF 		oFld:aDialogs[1]

      REDEFINE GET aGet[ _CSUFALB ] VAR aTmp[ _CSUFALB ];
         ID       102 ;
			WHEN 		.F. ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _LFACTURADO ] VAR cEstAlb;
         ID       111 ;
         WHEN     .f. ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _DFECALB ] VAR aTmp[ _DFECALB ];
         ID       110 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _NTARIFA ] VAR aTmp[ _NTARIFA ] ;
         ID       132 ;
         PICTURE  "9" ;
         VALID    ( aTmp[ _NTARIFA ] >= 1 .AND. aTmp[ _NTARIFA ] <= 6 );
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CCODCLI ] VAR aTmp[ _CCODCLI ] ;
         ID       120 ;
         PICTURE  RetPicCodCliEmp() ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         VALID    ( LoaCli( aGet, aTmp, nMode, oRieCli, oTlfCli ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( pdaBrwClient( aGet[ _CCODCLI ] , aGet[ _CNOMCLI ] ) ) ;
			OF 		oFld:aDialogs[1]

      REDEFINE GET aGet[ _CNOMCLI ] VAR aTmp[ _CNOMCLI ] ;
         ID       121 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
			OF 		oFld:aDialogs[1]

      REDEFINE GET aGet[ _CDIRCLI ] VAR aTmp[ _CDIRCLI ] ;
         ID       130 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CPOSCLI ] VAR aTmp[ _CPOSCLI ] ;
         ID       140 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CPOBCLI ] VAR aTmp[ _CPOBCLI ] ;
         ID       141 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET oTlfCli VAR cTlfCli ;
         ID       150 ;
         WHEN     ( .f. );
         OF       oFld:aDialogs[1]

      REDEFINE GET oRieCli VAR nRieCli ;
         ID       151 ;
         PICTURE  "@E 999999.99" ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CCODOBR ] VAR aTmp[ _CCODOBR ] ;
         ID       160 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         VALID    ( cObras( aGet[ _CCODOBR ], oNbrObr, aTmp[ _CCODCLI ], dbfObrasT ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( pdaBrwObras( aGet[ _CCODOBR ], oNbrObr, aTmp[ _CCODCLI ], dbfObrasT ) ) ;
			OF 		oFld:aDialogs[1]


      REDEFINE GET oNbrObr VAR cNbrObr ;
         WHEN     .f. ;
         ID       161 ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CCODRUT ] VAR aTmp[ _CCODRUT ] ;
          ID       170 ;
          WHEN     (nMode != ZOOM_MODE) ;
          VALID    (cRuta( aGet[ _CCODRUT ], dbfRuta, oRuta ) ) ;
          BITMAP   "LUPA" ;
          ON HELP  ( pdaBrwRuta( aGet[ _CCODRUT ], dbfRuta, oRuta ) ) ;
          OF       oFld:aDialogs[1]

      REDEFINE GET oRuta VAR cRuta ;
          ID       171 ;
          WHEN     .f. ;
          OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CRETPOR ] VAR aTmp[ _CRETPOR ] ;
         ID       180 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CRETMAT ] VAR aTmp[ _CRETMAT ] ;
         ID       181 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[_CCODAGE] ;
         VAR      aTmp[_CCODAGE] ;
         ID       185 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         VALID    ( cAgentes( aGet[_CCODAGE], dbfAgent, oSayAge, aGet[_NPCTCOMAGE] ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( pdaBrwAgentes( aGet[_CCODAGE], dbfAgent, oSayAge ) ) ;
			OF 		oFld:aDialogs[1]

      REDEFINE GET oSayAge VAR cSayAge ;
			WHEN 		.F. ;
         ID       186 ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CCODPAGO ] VAR aTmp[ _CCODPAGO ] ;
         ID       190 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( cFpago( aGet[ _CCODPAGO ], dbfFPago, oSayPgo ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( pdaBrwFPago( aGet[ _CCODPAGO ], dbfFPago, oSayPgo ) ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET oSayPgo VAR cSayPgo  ;
          ID       191 ;
          WHEN     .f. ;
          OF       oFld:aDialogs[1]

      /*
      Detalle________________________________________________________________
      */

      REDEFINE IBROWSE oBrwLin ;
			FIELDS ;
                  ( dbfTmpLin )->CREF + CRLF + If( Empty( ( dbfTmpLin )->CREF ), ( dbfTmpLin )->MLNGDES, ( dbfTmpLin )->CDETALLE ),;
                  If( !( dbfTmpLin )->lTotLin .and. !( dbfTmpLin )->lControl, Trans( nTotNAlbCli( dbfTmpLin ), cPicUnd ), "" ) + CRLF + If( !( dbfTmpLin )->lTotLin .and. !( dbfTmpLin )->lControl, Trans( (dbfTmpLin)->NIVA,      "@E 99.9" ), "" ),;
                  If( !( dbfTmpLin )->lTotLin, Trans( nTotUAlbCli( dbfTmpLin, nDouDiv ), cPouDiv ), "" );
         FIELDSIZES ;
                  100,;
                  60,;
                  50 ;
         HEAD ;
                  "Código" + CRLF + "Detalle",;
                  cNombreUnidades() + CRLF + "%IVA",;
                  "Precio" ;
         JUSTIFY  .f.,;
                  .t.,;
                  .t. ;
         ALIAS    ( dbfTmpLin );
         ID       200 ;
         OF       oFld:aDialogs[2]

         oBrwLin:cWndName       := "Albaran de cliente.Detalle.PDA"

         oBrwLin:LoadData()

      REDEFINE BTNBMP aBtn[1];
         ID       100 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[ 2 ] ;
         RESOURCE "New16" ;
         NOBORDER ;
         TOOLTIP  "Añadir línea" ;
         ACTION   ( AppDeta( oBrwLin, bDetPda, aTmp ) )

         aBtn[1]:SetColor( 0, nRGB( 255, 255, 255 )  )

      REDEFINE BTNBMP aBtn[ 2 ];
         ID       110 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[ 2 ] ;
         RESOURCE "Edit16" ;
         NOBORDER ;
         TOOLTIP  "Editar línea" ;
         ACTION   ( EdtDeta( oBrwLin, bDetPda, aTmp ) )

         aBtn[2]:SetColor( 0, nRGB( 255, 255, 255 )  )

      REDEFINE BTNBMP aBtn[ 3 ];
         ID       120 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[ 2 ] ;
         RESOURCE "Del16" ;
         NOBORDER ;
         TOOLTIP  "Eliminar línea" ;
         ACTION   ( WinDelRec( oBrwLin, dbfTmp, {|| delDeta() }, {|| RecalculaTotal( aTmp ) } ) )

         aBtn[ 3 ]:SetColor( 0, nRGB( 255, 255, 255 )  )

      REDEFINE BTNBMP aBtn[ 4 ];
         ID       130 ;
         OF       oFld:aDialogs[ 2 ] ;
         RESOURCE "Zoom16" ;
         NOBORDER ;
         TOOLTIP  "Zoom línea" ;
         ACTION   ( WinZooRec( oBrwLin, bDetPda, dbfTmpLin ) )

         aBtn[ 4 ]:SetColor( 0, nRGB( 255, 255, 255 )  )

      REDEFINE SAY oTotAlbLin VAR nTotAlbLin;
         ID       450 ;
         FONT     oFont ;
         OF       oFld:aDialogs[2]

         oTotAlbLin:SetColor( 0, nRGB( 255, 255, 255 )  )

      REDEFINE SAY oSayTit VAR "Total";
         ID       451 ;
         FONT     oFont ;
         OF       oFld:aDialogs[2]

         oSayTit:SetColor( 0, nRGB( 255, 255, 255 )  )

      /*
		Detalle________________________________________________________________
      */

      /*
      Caja de diálogo de incidencias-------------------------------------------
      */

      REDEFINE IBROWSE oBrwInc ;
			FIELDS ;
                  ( dbfTmpInc )->cCodTip + CRLF + cNomInci( ( dbfTmpInc )->cCodTip, dbfInci ) ,;
                  Dtoc( ( dbfTmpInc )->dFecInc ) + CRLF + ( dbfTmpInc )->mDesInc ;
			FIELDSIZES ;
                  60,;
                  400;
         HEAD ;
                  "Código" + CRLF + "Tipo de incidencia" ,;
                  "Fecha" + CRLF + "Incidencia" ;
         JUSTIFY ;
                  .f.,;
                  .f. ;
         ALIAS    ( dbfTmpInc );
         ID       200 ;
         OF       oFld:aDialogs[3]

         oBrwInc:cWndName        := "Albaran de cliente.Incidencia.PDA"
         oBrwInc:LoadData()

      REDEFINE BTNBMP aBtn[5];
         ID       100 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[3] ;
         RESOURCE "New16" ;
         NOBORDER ;
         TOOLTIP  "Añadir incidencia" ;
         ACTION   ( WinAppRec( oBrwInc, bIncPda, dbfTmpInc, nil, nil, aTmp ) )

       aBtn[5]:SetColor( 0, nRGB( 255, 255, 255 )  )

      REDEFINE BTNBMP aBtn[6];
         ID       110 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[3] ;
         RESOURCE "Edit16" ;
         NOBORDER ;
         TOOLTIP  "Editar incidencia" ;
         ACTION   ( WinEdtRec( oBrwInc, bIncPda, dbfTmpInc, nil, nil, aTmp ) )

       aBtn[6]:SetColor( 0, nRGB( 255, 255, 255 )  )

      REDEFINE BTNBMP aBtn[7];
         ID       120 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[3] ;
         RESOURCE "Del16" ;
         NOBORDER ;
         TOOLTIP  "Eliminar incidencia" ;
         ACTION   ( DbDelRec( oBrwInc, dbfTmpInc, nil, nil, .t. ) )

       aBtn[7]:SetColor( 0, nRGB( 255, 255, 255 )  )

      REDEFINE BTNBMP aBtn[8];
         ID       130 ;
         OF       oFld:aDialogs[3] ;
         RESOURCE "Zoom16" ;
         NOBORDER ;
         TOOLTIP  "Zoom incidencia" ;
         ACTION   ( WinZooRec( oBrwInc, bIncPda, dbfTmpInc ) )

       aBtn[8]:SetColor( 0, nRGB( 255, 255, 255 )  )

      /*
		Descuentos______________________________________________________________
      */

      REDEFINE GET aGet[ _CDTOESP ] VAR aTmp[ _CDTOESP ] ;
         ID       100 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[4]

      REDEFINE GET aGet[ _NDTOESP ] VAR aTmp[ _NDTOESP ] ;
         ID       101 ;
			PICTURE 	"@E 99.99" ;
         SPINNER ;
         VALID    ( RecalculaTotal( aTmp ) ) ;
         ON CHANGE( RecalculaTotal( aTmp ) ) ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[4]

      REDEFINE GET aGet[ _CDPP ] VAR aTmp[ _CDPP ] ;
         ID       110 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[4]

		REDEFINE GET aGet[ _NDPP ] VAR aTmp[ _NDPP ];
         ID       111 ;
			PICTURE 	"@E 99.99" ;
         SPINNER ;
         VALID    ( RecalculaTotal( aTmp ) ) ;
         ON CHANGE( RecalculaTotal( aTmp ) ) ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[4]

		REDEFINE GET aGet[ _CDTOUNO ] VAR aTmp[ _CDTOUNO ] ;
         ID       120 ;
			PICTURE 	"@!" ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[4]

		REDEFINE GET aGet[ _NDTOUNO ] VAR aTmp[ _NDTOUNO ];
         ID       121 ;
			PICTURE 	"@E 99.99" ;
         SPINNER ;
         VALID    ( RecalculaTotal( aTmp ) ) ;
         ON CHANGE( RecalculaTotal( aTmp ) ) ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[4]

      REDEFINE GET aGet[ _CDTODOS ] VAR aTmp[ _CDTODOS ] ;
         ID       130 ;
			PICTURE 	"@!" ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[4]

      REDEFINE GET aGet[ _NDTODOS ] VAR aTmp[ _NDTODOS ];
         ID       131 ;
			PICTURE 	"@E 99.99" ;
         SPINNER ;
         VALID    ( RecalculaTotal( aTmp ) ) ;
         ON CHANGE( RecalculaTotal( aTmp ) ) ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[4]

      /*
      Margen
      */

      REDEFINE GET oGetRnt VAR nTotRnt;
         ID       140 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[4]

      /*
		Cajas de Totales
		------------------------------------------------------------------------
      */

      REDEFINE GET aGet[ _CMANOBR ] VAR aTmp[ _CMANOBR ] ;
         ID       151 ;
			COLOR 	CLR_GET ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[4]

      REDEFINE GET aGet[ _NMANOBR ] VAR aTmp[ _NMANOBR ] ;
         ID       150 ;
         PICTURE  cPorDiv ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( RecalculaTotal( aTmp ) ) ;
         ON CHANGE( RecalculaTotal( aTmp ) ) ;
         OF       oFld:aDialogs[4]

      REDEFINE CHECKBOX aGet[ _LRECARGO ] VAR aTmp[ _LRECARGO ] ;
         ID       160 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ON CHANGE( RecalculaTotal( aTmp ) ) ;
         OF       oFld:aDialogs[4]

      REDEFINE CHECKBOX aGet[ _LSNDDOC ] VAR aTmp[ _LSNDDOC ] ;
         ID       170 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[4]

      REDEFINE SAY oGetNet VAR nTotNet ;
         ID       400 ;
         OF       oFld:aDialogs[4]

      oGetNet:SetColor( 0, nRGB( 255, 255, 255 )  )

      REDEFINE SAY oGetIva VAR nTotIva ;
         ID       420 ;
         OF       oFld:aDialogs[4]

      oGetIva:SetColor( 0, nRGB( 255, 255, 255 )  )

      REDEFINE SAY oGetReq VAR nTotReq ;
         ID       440 ;
         OF       oFld:aDialogs[4]

      oGetReq:SetColor( 0, nRGB( 255, 255, 255 )  )

      REDEFINE SAY oGetTotal VAR nTotAlb ;
         ID       450 ;
         FONT     oFont ;
         OF       oFld:aDialogs[4]

      oGetTotal:SetColor( 0, nRGB( 255, 255, 255 )  )

#ifndef __PDA__
      REDEFINE SAY oTitulo VAR cTitulo;
         ID       100 ;
         OF       oDlg
#endif

		/*
		Botones comunes a la caja de dialogo____________________________________
      */

      oDlg:bStart := {|| aGet[ _CSERALB ]:SetFocus(), aGet[ _CCODCLI ]:lValid(), if( !Empty( cCodCli ) .and. nMode == APPD_MODE, ( oFld:SetOption(2), AppDeta( oBrwLin, bDetPda, aTmp ) ), ) }

      oDlg:Cargo  := {|| EndTrans( aTmp, aGet, oBrwLin, oBrwInc, nMode, oDlg ), oDlg:end( IDOK ) }

   ACTIVATE DIALOG oDlg ;
      ON INIT ( RecalculaTotal( aTmp ), pdaMenuEdtRec( oBrwLin, oBrwInc, oDlg ) )

   ( dbfAlbCliT )->( ordSetFocus( nOrd ) )

   oBrwLin:CloseData()

   KillTrans( oBrwLin )

   // Restauramos la ventana---------------------------------------------------

   oWnd():Show()

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

static function pdaMenuEdtRec( oBrwLin, oBrwInc, oDlg )

   local oMenu

   DEFINE MENU oMenu ;
      RESOURCE 100 ;
      BITMAPS  10 ; // bitmaps resoruces ID
      IMAGES   3     // number of images in the bitmap

      REDEFINE MENUITEM ID 110 OF oMenu ACTION ( Eval( oDlg:Cargo ) )

      REDEFINE MENUITEM ID 120 OF oMenu ACTION ( oDlg:End( IDCANCEL ) )

   oDlg:SetMenu( oMenu )

   /*oBrwLin:GoTop()

   oBrwInc:GoTop()*/

Return oMenu

//---------------------------------------------------------------------------//

Static Function DetPda( aTmp, aGet, dbfAlbCliL, oBrw, lTotLin, cCodArtEnt, nMode, aTmpAlb )

   local oDlg
   local oBtn
	local oTotal
   local nTotPedCli
   local cCodArt     := Padr( aTmp[ _CREF ], 32 )
   local oLinea
   local cLinea      := LblTitle( nMode ) + "línea de albaran"
   local oSayPr1
   local oSayPr2
   local cSayPr1     := ""
   local cSayPr2     := ""
   local oSayVp1
   local oSayVp2
   local cSayVp1     := ""
   local cSayVp2     := ""

   DEFAULT lTotLin   := .f.

   SysRefresh()

   do case
   case nMode == APPD_MODE

      aTmp[ _CSERALB  ] := aTmpAlb[ _CSERALB ]
      aTmp[ _NNUMALB  ] := aTmpAlb[ _NNUMALB ]
      aTmp[ _CSUFALB  ] := aTmpAlb[ _CSUFALB ]
      aTmp[ _NUNICAJA ] := 1
      aTmp[ _CTIPMOV  ] := cDefVta()
      aTmp[ _LTOTLIN  ] := lTotLin
      aTmp[ _NCANENT  ] := 1
      aTmp[ _LIVALIN  ] := aTmpAlb[ _LIVAINC ]
      aTmp[ _CALMLIN  ] := cDefAlm()

      if !Empty( cCodArtEnt )
         cCodArt        := Padr( cCodArtEnt, 32 )
      end if

   case nMode == EDIT_MODE

      lTotLin           := aTmp[ _LTOTLIN ]

   end case

   /*
   Este valor los guaradamos para detectar los posibles cambios----------------
   */

   cOldCodArt           := aTmp[ _CREF ]
   cOldPrpArt           := aTmp[ _CCODPR1 ] + aTmp[ _CCODPR2 ] + aTmp[ _CVALPR1 ] + aTmp[ _CVALPR2 ]

   DEFINE DIALOG oDlg RESOURCE "ALBCLI_LIN_PDA_1"

      REDEFINE GET aGet[ _CREF ] VAR cCodArt;
         ID       100 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         BITMAP   "LUPA" ;
         VALID    ( LoaArt( cCodArt, aTmp, aGet, aTmpAlb, , oSayPr1, oSayPr2, oSayVp1, oSayVp2, , nMode ) ) ;
         ON HELP  ( BrwArticulo( aGet[ _CREF ], aGet[ _CDETALLE ] ) ) ;
         OF       oDlg

      REDEFINE GET aGet[ _CDETALLE ] VAR aTmp[ _CDETALLE ] ;
         ID       110 ;
         WHEN     ( lModDes() .AND. nMode != ZOOM_MODE );
         OF       oDlg

      REDEFINE GET aGet[ _MLNGDES ] VAR aTmp[ _MLNGDES ] ;
         MEMO ;
         ID       111 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      /*
      Lotes
      -------------------------------------------------------------------------
      */

      REDEFINE GET aGet[ _CLOTE ] VAR aTmp[ _CLOTE ];
         ID       112 ;
         IDSAY    113 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

       /*
      Propiedades
      -------------------------------------------------------------------------
      */

      REDEFINE GET aGet[ _CVALPR1 ] VAR aTmp[_CVALPR1];
         ID       241 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         BITMAP   "LUPA" ;
         VALID    ( if( lPrpAct( aTmp[ _CVALPR1 ], oSayVp1, aTmp[ _CCODPR1 ], dbfTblPro ),;
                        LoaArt( cCodArt, aTmp, aGet, aTmpAlb, oStkAct, oSayPr1, oSayPr2, oSayVp1, oSayVp2, bmpImage, nMode, .f. ),;
                        .f. ) );
         ON HELP  ( brwPrpAct( aGet[_CVALPR1], oSayVp1, aTmp[_CCODPR1 ] ) ) ;
         OF       oDlg

         aGet[ _CVALPR1 ]:bChange   := {|| aGet[ _CVALPR1 ]:Assign(), if( !uFieldEmpresa( "lNStkAct" ), oStock:nPutStockActual( aTmp[ _CREF ], aTmp[ _CALMLIN ], aTmp[ _CVALPR1 ], aTmp[ _CVALPR2 ], aTmp[ _CLOTE ], aTmp[ _LKITART ], aTmp[ _NCTLSTK ] ), .t. ) }

      REDEFINE SAY oSayPr1 VAR cSayPr1;
         ID       240 ;
         OF       oDlg

      REDEFINE GET oSayVp1 VAR cSayVp1;
         ID       242 ;
         WHEN     .f. ;
         OF       oDlg

      REDEFINE GET aGet[_CVALPR2] VAR aTmp[_CVALPR2];
         ID       251 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         BITMAP   "LUPA" ;
         VALID    ( if( lPrpAct( aTmp[ _CVALPR2 ], oSayVp2, aTmp[ _CCODPR2 ], dbfTblPro ),;
                        LoaArt( cCodArt, aTmp, aGet, aTmpAlb, oStkAct, oSayPr1, oSayPr2, oSayVp1, oSayVp2, bmpImage, nMode, .f. ),;
                        .f. ) );
         ON HELP  ( brwPrpAct( aGet[_CVALPR2], oSayVp2, aTmp[_CCODPR2 ] ) ) ;
         OF       oDlg

         aGet[ _CVALPR2 ]:bChange   := {|| aGet[ _CVALPR2 ]:Assign(), if( !uFieldEmpresa( "lNStkAct" ), oStock:nPutStockActual( aTmp[ _CREF ], aTmp[ _CALMLIN ], aTmp[ _CVALPR1 ], aTmp[ _CVALPR2 ], aTmp[ _CLOTE ], aTmp[ _LKITART ], aTmp[ _NCTLSTK ] ), .t. ) }

      REDEFINE SAY oSayPr2 VAR cSayPr2;
         ID       250 ;
         OF       oDlg

      REDEFINE GET oSayVp2 VAR cSayVp2;
         ID       252 ;
         WHEN     .f. ;
         OF       oDlg

      /*
      fin de propiedades
      -------------------------------------------------------------------------
      */

      REDEFINE GET aGet[ _NIVA ] VAR aTmp[ _NIVA ] ;
         ID       120 ;
         WHEN     ( lModIva() .AND. nMode != ZOOM_MODE .AND. !lTotLin ) ;
         PICTURE  "@E 99.99" ;
         VALID    ( lTiva( dbfIva, aTmp[ _NIVA ], @aTmp[ _NREQ ] ) );
         BITMAP   "LUPA" ;
         ON HELP  ( pdaBrwTipoIva( aGet[ _NIVA ], dbfIva ) ) ;
         OF       oDlg

      REDEFINE GET aGet[ _NCANENT ] VAR aTmp[ _NCANENT ];
         ID       130 ;
         WHEN     ( lUseCaj() .AND. nMode != ZOOM_MODE .AND. !lTotLin ) ;
         ON CHANGE( lCalcDeta( aTmp, aTmpAlb, nDouDiv, oTotal ) );
         VALID    ( lCalcDeta( aTmp, aTmpAlb, nDouDiv, oTotal ) );
         PICTURE  cPicUnd ;
         OF       oDlg ;
         IDSAY    131

         aGet[ _NCANENT ]:oSay:SetColor( 0, nRGB( 255, 255, 255 )  )

      REDEFINE GET aGet[ _NUNICAJA ] VAR aTmp[ _NUNICAJA ];
         ID       140 ;
         WHEN     ( nMode != ZOOM_MODE .AND. !lTotLin ) ;
         ON CHANGE( lCalcDeta( aTmp, aTmpAlb, nDouDiv, oTotal ) );
         VALID    ( lCalcDeta( aTmp, aTmpAlb, nDouDiv, oTotal ) );
         PICTURE  cPicUnd ;
         OF       oDlg ;
         IDSAY    141

         aGet[ _NUNICAJA ]:oSay:SetColor( 0, nRGB( 255, 255, 255 )  )

      REDEFINE GET aGet[ _NSATUNIT ] VAR aTmp[ _NSATUNIT ] ;
         ID       150 ;
         WHEN     ( nMode != ZOOM_MODE .and. !lTotLin ) ;
         ON CHANGE( lCalcDeta( aTmp, aTmpAlb, nDouDiv, oTotal ) );
         VALID    ( lCalcDeta( aTmp, aTmpAlb, nDouDiv, oTotal ) );
         PICTURE  cPouDiv ;
         OF       oDlg

      REDEFINE GET aGet[ _NIMPTRN ] VAR aTmp[ _NIMPTRN ] ;
         ID      160 ;
         WHEN     ( nMode != ZOOM_MODE .AND. !lTotLin ) ;
         ON CHANGE( lCalcDeta( aTmp, aTmpAlb, nDouDiv, oTotal ) );
         VALID    ( lCalcDeta( aTmp, aTmpAlb, nDouDiv, oTotal ) );
         PICTURE  cPouDiv ;
         OF       oDlg

      REDEFINE GET aGet[ _NDTO ] VAR aTmp[ _NDTO ] ;
         ID       170 ;
         ON CHANGE( lCalcDeta( aTmp, aTmpAlb, nDouDiv, oTotal ) );
         WHEN     ( nMode != ZOOM_MODE .and. !lTotLin ) ;
         VALID    ( lCalcDeta( aTmp, aTmpAlb, nDouDiv, oTotal ) );
         PICTURE  "@E 99.99" ;
         OF       oDlg

      REDEFINE GET aGet[ _NDTOPRM ] VAR aTmp[ _NDTOPRM ] ;
         ID       180 ;
         ON CHANGE( lCalcDeta( aTmp, aTmpAlb, nDouDiv, oTotal ) );
         WHEN     ( nMode != ZOOM_MODE .and. !lTotLin ) ;
         VALID    ( lCalcDeta( aTmp, aTmpAlb, nDouDiv, oTotal ) );
         PICTURE  "@E 99.99";
         OF       oDlg

      REDEFINE GET aGet[ _NCOMAGE ] VAR aTmp[ _NCOMAGE ] ;
         ID       190 ;
         WHEN     ( nMode != ZOOM_MODE .AND. !lTotLin ) ;
         PICTURE  "@E 99.99" ;
         OF       oDlg

      /*
      Codigo de almacen--------------------------------------------------------
      */

      REDEFINE GET aGet[ _CALMLIN ] VAR aTmp[ _CALMLIN ] ;
         ID       200 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         VALID    ( cAlmacen( aGet[ _CALMLIN ] ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwAlmacen( aGet[ _CALMLIN ] ) ) ;
         OF       oDlg

      REDEFINE GET oTotal VAR nTotPedCli ;
         ID       210 ;
         WHEN     .F. ;
         PICTURE  cPorDiv ;
         OF       oDlg

      REDEFINE SAY oLinea VAR cLinea;
         ID       230 ;
         OF       oDlg

         oLinea:SetColor( 0, nRGB( 255, 255, 255 )  )
      /*
      Botones generales--------------------------------------------------------
      */
#ifndef __PDA__
      REDEFINE BUTTON oBtn;
         ID       IDOK ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( SaveDeta( aTmp, aTmpAlb, , aGet, oBrw, , oDlg, nMode, oSayPr1, oSayPr2, oSayVp1, oSayVp2, , , , oTotal, cCodArt, oBtn ) )

      REDEFINE BUTTON ;
         ID       IDCANCEL ;
         OF       oDlg ;
         CANCEL ;
         ACTION   ( oDlg:end() )
#endif

      oDlg:bStart := {|| SetDlgMode( aTmp, aGet, , nMode, oSayPr1, oSayPr2, oSayVp1, oSayVp2, , , oTotal, aTmpAlb ) }

#ifndef __PDA__

        if nMode != ZOOM_MODE
         oDlg:AddFastKey( VK_F5, {|| SaveDeta( aTmp, aTmpAlb, aGet, oDlg, oBrw, , nMode, , , , , , , oTotal, , cCodArt, oBtn ) } )
      end if

   ACTIVATE DIALOG oDlg CENTER ON PAINT ( lCalcDeta( aTmp, aTmpAlb, nDouDiv, oTotal ) )

#else

   oDlg:Cargo  := {|| SaveDeta( aTmp, aTmpAlb, , aGet, oBrw, , oDlg, nMode,         oSayPr1, oSayPr2, oSayVp1, oSayVp2, , , 0, oTotal, cCodArt, oBtn ) }

   ACTIVATE DIALOG oDlg ;
      ON INIT ( pdaMenuEditarLinea( oDlg, oBrw ) )

   // Restauramos la ventana---------------------------------------------------

   oWnd():Show()

#endif

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

static function pdaMenuEditarLinea( oDlg )

   local oMenu

   DEFINE MENU oMenu ;
      RESOURCE 100 ;
      BITMAPS  10 ; // bitmaps resoruces ID
      IMAGES   3     // number of images in the bitmap

      REDEFINE MENUITEM ID 110 OF oMenu ACTION ( Eval( oDlg:Cargo ) )

      REDEFINE MENUITEM ID 120 OF oMenu ACTION ( oDlg:End( IDCANCEL ) )

   oDlg:SetMenu( oMenu )

Return oMenu

//---------------------------------------------------------------------------//

Static Function IncPda( aTmp, aGet, dbfAlbCliI, oBrw, bWhen, bValid, nMode, aTmpAlb )

   local oDlg
   local oNomInci
   local cNomInci       := RetFld( aTmp[ ( dbfTmpInc )->( FieldPos( "cCodTip" ) ) ], dbfInci )
   local oTitulo
   local cTitulo        := LblTitle( nMode ) + " incidencia"


   if nMode == APPD_MODE
      aTmp[ _CSERALB  ] := aTmpAlb[ _CSERALB ]
      aTmp[ _NNUMALB  ] := aTmpAlb[ _NNUMALB ]
      aTmp[ _CSUFALB  ] := aTmpAlb[ _CSUFALB ]

      if IsMuebles()
         aTmp[ ( dbfTmpInc )->( FieldPos( "lAviso" ) ) ]  := .t.
      end if
   end if

   #ifndef __PDA__
      DEFINE DIALOG oDlg RESOURCE "INCIDENCIA" TITLE LblTitle( nMode ) + "incidencias de albaranes a clientes"
   #else
      DEFINE DIALOG oDlg RESOURCE "ALBCLI_INC_PDA_1"
   #endif

      REDEFINE GET aGet[ ( dbfTmpInc )->( FieldPos( "cCodTip" ) ) ];
         VAR      aTmp[ ( dbfTmpInc )->( FieldPos( "cCodTip" ) ) ];
         ID       120 ;
         WHEN     ( nMode != ZOOM_MODE );
         VALID    ( cTipInci( aGet[ ( dbfTmpInc )->( FieldPos( "cCodTip" ) ) ], dbfInci, oNomInci ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwIncidencia( dbfInci, aGet[ ( dbfTmpInc )->( FieldPos( "cCodTip" ) ) ], oNomInci ) ) ;
         OF       oDlg

      REDEFINE GET oNomInci VAR cNomInci;
         ID       130 ;
         WHEN     .f. ;
         OF       oDlg

      REDEFINE GET aTmp[ ( dbfTmpInc )->( FieldPos( "dFecInc" ) ) ] ;
         ID       100 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE CHECKBOX aTmp[ ( dbfTmpInc )->( FieldPos( "lAviso" ) ) ] ;
         ID       150 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET aTmp[ ( dbfTmpInc )->( FieldPos( "mDesInc" ) ) ] ;
         MEMO ;
         ID       110 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE CHECKBOX aTmp[ ( dbfTmpInc )->( FieldPos( "lListo" ) ) ] ;
         ID       140 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE SAY oTitulo VAR cTitulo;
         ID       1000 ;
         OF       oDlg

         oTitulo:SetColor( 0, nRGB( 255, 255, 255 )  )

#ifndef __PDA__

      if ( "PDA" $ cParamsMain() )

         REDEFINE SAY oTitulo VAR cTitulo;
               ID       1000 ;
               OF       oDlg

      end if

      REDEFINE BUTTON ;
         ID       IDOK ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( WinGather( aTmp, nil, dbfTmpInc, oBrw, nMode ), oDlg:end( IDOK ) )

      REDEFINE BUTTON ;
         ID       IDCANCEL ;
         OF       oDlg ;
         CANCEL ;
         ACTION   ( oDlg:end() )

   if nMode != ZOOM_MODE
      oDlg:AddFastKey( VK_F5, {|| WinGather( aTmp, nil, dbfTmpInc, oBrw, nMode ), oDlg:end( IDOK ) } )
   end if

   ACTIVATE DIALOG oDlg CENTER

#else

   oDlg:Cargo  := {|| WinGather( aTmp, nil, dbfTmpInc, oBrw, nMode ), oDlg:end( IDOK ) }

   ACTIVATE DIALOG oDlg ;
      ON INIT ( pdaMenuEditarIncidencia( oDlg ) )

#endif

Return ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

static function pdaMenuEditarIncidencia( oDlg , oBrw )

   local oMenu

   DEFINE MENU oMenu ;
      RESOURCE 100 ;
      BITMAPS  10 ; // bitmaps resoruces ID
      IMAGES   3     // number of images in the bitmap

      REDEFINE MENUITEM ID 110 OF oMenu ACTION ( Eval( oDlg:Cargo ) )

      REDEFINE MENUITEM ID 120 OF oMenu ACTION ( oDlg:End( IDCANCEL ) )

   oDlg:SetMenu( oMenu )

Return oMenu

//---------------------------------------------------------------------------//

Function pdaAppAlbCli( cCodCli, cCodArt, lOpenBrowse )

   local nLevel         := nLevelUsr( _MENUITEM_ )

   DEFAULT lOpenBrowse  := .f.

   if Empty( cCodCli )
      msgStop( "No se ha seleccionado ningún cliente." )
      return .f.
   end if

   if nAnd( nLevel, 1 ) != 0 .or. nAnd( nLevel, ACC_APPD ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if lOpenBrowse

      if pdaAlbCli( nil, nil, cCodCli, cCodArt )
         oWndBrw:RecAdd()
      end if

   else

      if pdaOpenFiles( nil, .t. )
         nTotAlbCli()
         WinAppRec( nil, bEdtPda, dbfAlbCliT, cCodCli, cCodArt )
         pdaCloseFiles()
      end if

   end if

RETURN .t.

//---------------------------------------------------------------------------//

#endif

//---------------------------------------------------------------------------//

CLASS pdaAlbCliSenderReciver

   Method CreateData()

END CLASS

//----------------------------------------------------------------------------//

Method CreateData( oPgrActual, oSayStatus, cPatPreVenta ) CLASS pdaAlbCliSenderReciver

   local pdaAlbCliT
   local pdaAlbCliL
   local pdaAlbCliI
   local pdaAlbCliP
   local pdaAlbCliD
   local dbfAlbCliT
   local dbfAlbCliL
   local dbfAlbCliI
   local dbfAlbCliP
   local dbfAlbCliD
   local lExist         := .f.
   local cFileName
   local cNumAlbCliT
   local cPatPc      := if( Empty( cPatPreVenta ), cPatPc(), cPatPreVenta )

   //Cabeceras de las tablas

   USE ( cPatPc + "AlbCliT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "AlbCliT", @dbfAlbCliT ) )
   SET ADSINDEX TO ( cPatPc + "AlbCliT.CDX" ) ADDITIVE
   ( dbfAlbCliT )->( OrdSetFocus( "lSndDoc" ) )

   USE ( cPatPc + "AlbCliL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "AlbCliL", @dbfAlbCliL ) )
   SET ADSINDEX TO ( cPatPc + "AlbCliL.CDX" ) ADDITIVE

   USE ( cPatPc + "AlbCliI.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "AlbCliI", @dbfAlbCliI ) )
   SET ADSINDEX TO ( cPatPc + "AlbCliI.CDX" ) ADDITIVE

   USE ( cPatPc + "AlbCliP.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "AlbCliP", @dbfAlbCliP ) )
   SET ADSINDEX TO ( cPatPc + "AlbCliP.CDX" ) ADDITIVE

   USE ( cPatPc + "AlbCliD.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "AlbCliD", @dbfAlbCliD ) )
   SET ADSINDEX TO ( cPatPc + "AlbCliD.Cdx" ) ADDITIVE

   dbUseArea( .t., cDriver(), cPatEmp() + "AlbCliT.Dbf", cCheckArea( "AlbCliT", @pdaAlbCliT ), .t. )
   ( pdaAlbCliT )->( ordListAdd( cPatEmp() + "AlbCliT.Cdx" ) )

   dbUseArea( .t., cDriver(), cPatEmp() + "AlbCliL.Dbf", cCheckArea( "AlbCliL", @pdaAlbCliL ), .t. )
   ( pdaAlbCliL )->( ordListAdd( cPatEmp() + "AlbCliL.Cdx" ) )

   dbUseArea( .t., cDriver(), cPatEmp() + "AlbCliI.Dbf", cCheckArea( "AlbCliI", @pdaAlbCliI ), .t. )
   ( pdaAlbCliI )->( ordListAdd( cPatEmp() + "AlbCliI.Cdx" ) )

   dbUseArea( .t., cDriver(), cPatEmp() + "AlbCliP.Dbf", cCheckArea( "AlbCliP", @pdaAlbCliP ), .t. )
   ( pdaAlbCliP )->( ordListAdd( cPatEmp() + "AlbCliP.Cdx" ) )

   dbUseArea( .t., cDriver(), cPatEmp() + "AlbCliD.Dbf", cCheckArea( "AlbCliD", @pdaAlbCliD ), .t. )
   ( pdaAlbCliD )->( ordListAdd( cPatEmp() + "AlbCliD.Cdx" ) )

   if !Empty( oPgrActual )
      oPgrActual:SetRange( 0, ( pdaAlbCliT )->( OrdKeyCount() ) )
   end if

   ( pdaAlbCliT )->( dbGoTop() )
   while !( pdaAlbCliT )->( eof() )

      if ( pdaAlbCliT )->lSndDoc

         cNumAlbCliT    := ( pdaAlbCliT )->cSeralb + Str( ( pdaAlbCliT )->nNumalb ) + ( pdaAlbCliT )->cSufalb

         if !( dbfAlbCliT )->( dbSeek( cNumAlbCliT ) )

            dbPass( pdaAlbCliT, dbfAlbCliT, .t. )

            /*
            Lineas de albaranes--------------------------------------------------
            */

            if ( pdaAlbCliL )->( dbSeek( cNumAlbCliT ) )
               while ( pdaAlbCliL )->cSeralb + Str( ( pdaAlbCliL )->nNumalb ) + ( pdaAlbCliL )->cSufalb == cNumAlbCliT .and. !( pdaAlbCliL )->( eof() )
                  dbPass( pdaAlbCliL, dbfAlbCliL, .t. )
                  ( pdaAlbCliL )->( dbSkip() )
               end while
            end if

            /*
            Incidencias de albaranes---------------------------------------------
            */

            if ( pdaAlbCliI )->( dbSeek( cNumAlbCliT ) )
               while ( pdaAlbCliI )->cSeralb + Str( ( pdaAlbCliI )->nNumalb ) + ( pdaAlbCliI )->cSufalb == cNumAlbCliT .AND. !( pdaAlbCliI )->( eof() )
                  dbPass( pdaAlbCliI, dbfAlbCliI, .t. )
                  ( pdaAlbCliI )->( dbSkip() )
               end while
            end if

            /*
            Pagos de albaranes---------------------------------------------------
            */

            if ( pdaAlbCliP )->( dbSeek( cNumAlbCliT ) )
               while ( pdaAlbCliP )->cSeralb + Str( ( pdaAlbCliP )->nNumalb ) + ( pdaAlbCliP )->cSufalb == cNumAlbCliT .AND. !( pdaAlbCliP )->( eof() )
                  dbPass( pdaAlbCliP, dbfAlbCliP, .t. )
                  ( pdaAlbCliP )->( dbSkip() )
               end while
            end if

            /*
            Documentos de albaranes----------------------------------------------
            */

            if ( pdaAlbCliD )->( dbSeek( cNumAlbCliT ) )
               while ( pdaAlbCliD )->cSeralb + Str( ( pdaAlbCliD )->nNumalb ) + ( pdaAlbCliD )->cSufalb == cNumAlbCliT .AND. !( pdaAlbCliD )->( eof() )
                  dbPass( pdaAlbCliD, dbfAlbCliD, .t. )
                  ( pdaAlbCliD )->( dbSkip() )
               end while
            end if

             if dbLock( pdaAlbCliT )
               ( pdaAlbCliT )->lSndDoc  := .f.
               ( pdaAlbCliT )->( dbUnLock() )
            end if

         end if

      end if

      ( pdaAlbCliT )->( dbSkip() )

      if !Empty( oSayStatus )
         oSayStatus:SetText( "Sincronizando albaranes " + Alltrim( Str( ( pdaAlbCliT )->( OrdKeyNo() ) ) ) + " de " + Alltrim( Str( ( pdaAlbCliT )->( OrdKeyCount() ) ) ) )
      end if

      SysRefresh()

      if !Empty( oPgrActual )
         oPgrActual:SetPos( ( pdaAlbCliT )->( OrdKeyNo() ) )
      end if

      SysRefresh()

   end while

   CLOSE ( pdaAlbCliT )
   CLOSE ( pdaAlbCliL )
   CLOSE ( pdaAlbCliI )
   CLOSE ( pdaAlbCliP )
   CLOSE ( pdaAlbCliD )
   CLOSE ( dbfAlbCliT )
   CLOSE ( dbfAlbCliL )
   CLOSE ( dbfAlbCliI )
   CLOSE ( dbfAlbCliP )
   CLOSE ( dbfAlbCliD )

Return ( Self )

//---------------------------------------------------------------------------//

//---------------------------------------------------------------------------//
//Funciones comunes para el programa y pda
//---------------------------------------------------------------------------//

//
// Devuelve el numero de unidades reservadas en albaranes a clientes
//

function nUnidadesRecibidasAlbCli( cNumPed, cCodArt, cCodPr1, cCodPr2, cRefPrv, cDetalle, dbfAlbCliL )

   local nTot        := 0
   local aStaLin     := aGetStatus( dbfAlbCliL, .f. )

   DEFAULT cCodPr1   := Space( 10 )
   DEFAULT cCodPr2   := Space( 10 )
   DEFAULT cRefPrv   := Space( 18 )
   DEFAULT cDetalle  := Space( 250 )

   if ( IsMuebles() )

      ( dbfAlbCliL )->( OrdSetFocus( "cNumPedDet" ) )

      if ( dbfAlbCliL )->( dbSeek( cNumPed + cCodArt + cCodPr1 + cCodPr2 + cRefPrv + cDetalle ) )
         while ( dbfAlbCliL )->cNumPed + ( dbfAlbCliL )->cRef + ( dbfAlbCliL )->cCodPr1 + ( dbfAlbCliL )->cCodPr2 + ( dbfAlbCliL )->cRefPrv + ( dbfAlbCliL )->cDetalle == cNumPed + cCodArt + cCodPr1 + cCodPr2 + cRefPrv + cDetalle .and. !( dbfAlbCliL )->( eof() )
            nTot     += nTotNAlbCli( dbfAlbCliL )
            ( dbfAlbCliL )->( dbSkip() )
         end while
      end if

   else

      ( dbfAlbCliL )->( OrdSetFocus( "cNumPedRef" ) )

      if ( dbfAlbCliL )->( dbSeek( cNumPed + cCodArt + cCodPr1 + cCodPr2 ) )
         while ( dbfAlbCliL )->cNumPed + ( dbfAlbCliL )->cRef + ( dbfAlbCliL )->cCodPr1 + ( dbfAlbCliL )->cCodPr2 == cNumPed + cCodArt + cCodPr1 + cCodPr2 .and. !( dbfAlbCliL )->( eof() )
            nTot     += nTotNAlbCli( dbfAlbCliL )
            ( dbfAlbCliL )->( dbSkip() )
         end while
      end if

   end if

   SetStatus( dbfAlbCliL, aStaLin )

return ( nTot )

//---------------------------------------------------------------------------//

function nTotNAlbCli( uDbf )

   local nTotUnd

   DEFAULT uDbf   := dbfAlbCliL

   do case
      case ValType( uDbf ) == "A"

         if uDbf[ __LALQUILER ]

            nTotUnd  := NotCaja( uDbf[ _NCANENT ] )
            nTotUnd  *= uDbf[ _NUNICAJA ]
            nTotUnd  *= NotCero( uDbf[ _NUNDKIT ] )
            nTotUnd  *= NotCero( uDbf[ __DFECENT ] - uDbf[ __DFECSAL ] )
            nTotUnd  *= NotCero( uDbf[ _NMEDUNO ] )
            nTotUnd  *= NotCero( uDbf[ _NMEDDOS ] )
            nTotUnd  *= NotCero( uDbf[ _NMEDTRE ] )


         else

            nTotUnd  := NotCaja( uDbf[ _NCANENT ] )
            nTotUnd  *= uDbf[ _NUNICAJA ]
            nTotUnd  *= NotCero( uDbf[ _NUNDKIT ] )
            nTotUnd  *= NotCero( uDbf[ _NMEDUNO ] )
            nTotUnd  *= NotCero( uDbf[ _NMEDDOS ] )
            nTotUnd  *= NotCero( uDbf[ _NMEDTRE ] )


         end if

      case ValType( uDbf ) == "C"

         if ( uDbf )->lAlquiler

            nTotUnd  := NotCaja( ( uDbf )->nCanEnt )
            nTotUnd  *= ( uDbf )->nUniCaja
            nTotUnd  *= NotCero( ( uDbf )->nUndKit )
            nTotUnd  *= NotCero( ( uDbf )->dFecEnt - ( uDbf )->dFecSal )
            nTotUnd  *= NotCero( ( uDbf )->nMedUno )
            nTotUnd  *= NotCero( ( uDbf )->nMedDos )
            nTotUnd  *= NotCero( ( uDbf )->nMedTre )

         else

            nTotUnd  := NotCaja( ( uDbf )->nCanEnt )
            nTotUnd  *= ( uDbf )->nUniCaja
            nTotUnd  *= NotCero( ( uDbf )->nUndKit )
            nTotUnd  *= NotCero( ( uDbf )->nMedUno )
            nTotUnd  *= NotCero( ( uDbf )->nMedDos )
            nTotUnd  *= NotCero( ( uDbf )->nMedTre )

         end if


      otherwise

         if uDbf:lAlquiler

            nTotUnd  := NotCaja( uDbf:nCanEnt )
            nTotUnd  *= uDbf:nUniCaja
            nTotUnd  *= NotCero( uDbf:nUndKit )
            nTotUnd  *= NotCero( uDbf:dFecEnt - uDbf:dFecSal )
            nTotUnd  *= NotCero( uDbf:nMedUno )
            nTotUnd  *= NotCero( uDbf:nMedDos )
            nTotUnd  *= NotCero( uDbf:nMedTre )


         else

            nTotUnd  := NotCaja( uDbf:nCanEnt )
            NtotUnd  *= uDbf:nUniCaja
            nTotUnd  *= NotCero( uDbf:nUndKit )
            nTotUnd  *= NotCero( uDbf:nMedUno )
            nTotUnd  *= NotCero( uDbf:nMedDos )
            nTotUnd  *= NotCero( uDbf:nMedTre )

         end if

   end case

return ( nTotUnd )

//---------------------------------------------------------------------------//

function nTotVAlbCli( uDbf )

   local nTotUnd

   DEFAULT uDbf   := dbfAlbCliL

   do case
      case ValType( uDbf ) == "A"

         nTotUnd  := nTotNAlbCli( uDbf ) * NotCero( uDbf[ _NFACCNV ] )

      case ValType( uDbf ) == "C"

         nTotUnd  := nTotNAlbCli( uDbf ) * NotCero( ( uDbf )->nFacCnv )

      otherwise

         nTotUnd  := nTotNAlbCli( uDbf ) * NotCero( uDbf:nFacCnv )

   end case

return ( nTotUnd )

//---------------------------------------------------------------------------//

FUNCTION nTotLAlbCli( cAlbCliL, nDec, nRou, nVdv, lDto, lPntVer, lImpTrn, cPouDiv )

	local nCalculo

   DEFAULT cAlbCliL  := dbfAlbCliL
   DEFAULT nDec      := nDouDiv()
   DEFAULT nRou      := nRouDiv()
   DEFAULT nVdv      := 1
   DEFAULT lDto      := .t.
   DEFAULT lPntVer   := .t.
   DEFAULT lImpTrn   := .t.

   if ( cAlbCliL )->lTotLin

      nCalculo       := nTotUAlbCli( cAlbCliL, nDec, nVdv )

   else

      /*
      Tomamos los valores redondeados
      */

      nCalculo       := nTotUAlbCli( cAlbCliL, nDec, nVdv )
      nCalculo       -= Round( ( cAlbCliL )->nDtoDiv , nDec )

      /*
      Descuentos---------------------------------------------------------------
      */

      if lDto

         if ( cAlbCliL )->nDto != 0
            nCalculo -= nCalculo * ( cAlbCliL )->nDto / 100
         end if

         if ( cAlbCliL )->nDtoPrm != 0
            nCalculo -= nCalculo * ( cAlbCliL )->nDtoPrm / 100
         end if

      end if

      /*
      Unidades-----------------------------------------------------------------
      */

      nCalculo       *= nTotNAlbCli( cAlbCliL )

      /*
      Punto Verde--------------------------------------------------------------
      */

      if lPntVer
         nCalculo    += nPntLAlbCli( cAlbCliL, nDec, nVdv )
      end if


      if nRou != nil
         nCalculo    := Round( nCalculo, nRou )
      end if

      /*
      Transporte
      */

      if lImpTrn .and. ( cAlbCliL )->nImpTrn != 0
         nCalculo    += ( cAlbCliL )->nImpTrn * nTotNAlbCli( cAlbCliL )
      end if

   end if

RETURN ( if( cPouDiv != nil, Trans( nCalculo, cPouDiv ), nCalculo ) )

//---------------------------------------------------------------------------//

//
// Precio del punto verde por linea
//

FUNCTION nPntLAlbCli( dbfLin, nDec, nVdv )

   local nPntVer

   DEFAULT dbfLin    := dbfAlbCliL
   DEFAULT nDec      := 0
   DEFAULT nVdv      := 1

   /*
   Punto Verde
   */

   nPntVer           := ( dbfLin )->nPntVer * nTotNAlbCli( dbfLin )

RETURN ( Round( nPntVer, nDec ) )

//---------------------------------------------------------------------------//

//
// Precio unitario
//

FUNCTION nTotUAlbCli( uTmpLin, nDec, nVdv )

   local nCalculo    := 0

   DEFAULT uTmpLin   := dbfAlbCliL
   DEFAULT nDec      := nDouDiv()
   DEFAULT nVdv      := 1

   do case
      case IsChar( uTmpLin )

         if ( uTmpLin )->lAlquiler
            nCalculo    := ( uTmpLin )->nPreAlq
         else
            nCalculo    := ( uTmpLin )->nPreUnit
         end if

      case IsObject( uTmpLin )

         if uTmpLin:lAlquiler
            nCalculo    := uTmpLin:nPreAlq
         else
            nCalculo    := uTmpLin:nPreUnit
         end if

      case IsArray( uTmpLin )

         if uTmpLin[ __LALQUILER ]
            nCalculo    := uTmpLin[ _NSATALQ ]
         else
            nCalculo    := uTmpLin[ _NSATUNIT ]
         end if

   end case

   if nVdv != 0
      nCalculo          := nCalculo / nVdv
   end if

RETURN ( Round( nCalculo, nDec ) )

//---------------------------------------------------------------------------//
//
// Valor del punto verde
//

Function nPntUAlbCli( dbfTmpLin, nDec, nVdv )

   local nCalculo := ( dbfTmpLin )->nPntVer

   DEFAULT nDec   := 0
   DEFAULT nVdv   := 1

	IF nVdv != 0
      nCalculo    := ( dbfTmpLin )->nPntVer / nVdv
	END IF

Return ( Round( nCalculo, nDec ) )

//---------------------------------------------------------------------------//

FUNCTION IsAlbCli( cPath )

   DEFAULT cPath  := cPatEmp()

   if !lExistTable( cPath + "AlbCliT.Dbf" )
      dbCreate( cPath + "AlbCliT.Dbf", aSqlStruct( aItmAlbCli() ), cDriver() )
   end if

   if !lExistTable( cPath + "AlbCliL.Dbf" )
      dbCreate( cPath + "AlbCliL.Dbf", aSqlStruct( aColAlbCli() ), cDriver() )
   end if

   if !lExistTable( cPath + "AlbCliP.Dbf" )
      dbCreate( cPath + "AlbCliP.Dbf", aSqlStruct( aItmAlbPgo() ), cDriver() )
   end if

   if !lExistTable( cPath + "AlbCliI.Dbf" )
      dbCreate( cPath + "AlbCliI.Dbf", aSqlStruct( aIncAlbCli() ), cDriver() )
   end if

   if !lExistTable( cPath + "AlbCliD.Dbf" )
      dbCreate( cPath + "AlbCliD.Dbf", aSqlStruct( aAlbCliDoc() ), cDriver() )
   end if

   if !lExistIndex( cPath + "AlbCliT.Cdx" ) .or. ;
      !lExistIndex( cPath + "AlbCliL.Cdx" ) .or. ;
      !lExistIndex( cPath + "AlbCliP.Cdx" ) .or. ;
      !lExistIndex( cPath + "AlbCliI.Cdx" ) .or. ;
      !lExistTable( cPath + "AlbCliD.Cdx" )

      rxAlbCli( cPath )

   end if

Return ( .t. )

//---------------------------------------------------------------------------//

FUNCTION mkAlbCli( cPath, lAppend, cPathOld, oMeter, bFor )

   local oBlock
   local oError
	local dbfAlbCliT
   local dbfAlbCliL
   local dbfAlbCliI
   local dbfAlbCliD
   local dbfAlbCliP
   local oldAlbCliT
   local oldAlbCliL
   local oldAlbCliI
   local oldAlbCliD
   local oldAlbCliP

   DEFAULT bFor      := {|| .t. }

   if oMeter != nil
		oMeter:cText	:= "Generando Bases"
		sysrefresh()
   end if

   CreateFiles( cPath )

   rxAlbCli( cPath, oMeter )

   if lAppend .and. lIsDir( cPathOld )

      oBlock         := ErrorBlock( { | oError | ApoloBreak( oError ) } )
      BEGIN SEQUENCE

      dbUseArea( .t., cDriver(), cPath + "ALBCLIT.DBF", cCheckArea( "ALBCLIT", @dbfAlbCliT ), .f. )
      ( dbfAlbCliT )->( ordListAdd( cPath + "ALBCLIT.CDX" ) )

      dbUseArea( .t., cDriver(), cPath + "ALBCLIL.DBF", cCheckArea( "ALBCLIL", @dbfAlbCliL ), .f. )
      ( dbfAlbCliL )->( ordListAdd( cPath + "ALBCLIL.CDX" ) )

      dbUseArea( .t., cDriver(), cPath + "AlbCliI.Dbf", cCheckArea( "AlbCliI", @dbfAlbCliI ), .f. )
      ( dbfAlbCliI )->( ordListAdd( cPath + "AlbCliI.Cdx"  ) )

      dbUseArea( .t., cDriver(), cPath + "AlbCliD.Dbf", cCheckArea( "AlbCliD", @dbfAlbCliD ), .f. )
      ( dbfAlbCliD )->( ordListAdd( cPath + "AlbCliD.Cdx"  ) )

      dbUseArea( .t., cDriver(), cPath + "AlbCliP.Dbf", cCheckArea( "AlbCliP", @dbfAlbCliP ), .f. )
      ( dbfAlbCliP )->( ordListAdd( cPath + "AlbCliP.Cdx"  ) )

      dbUseArea( .t., cDriver(), cPathOld + "AlbCLIT.DBF", cCheckArea( "AlbCLIT", @oldAlbCliT ), .f. )
      ( oldAlbCliT )->( ordListAdd( cPathOld + "AlbCLIT.CDX"  ) )

      dbUseArea( .t., cDriver(), cPathOld + "AlbCLIL.DBF", cCheckArea( "AlbCLIL", @oldAlbCliL ), .f. )
      ( oldAlbCliL )->( ordListAdd( cPathOld + "AlbCLIL.CDX"  ) )

      dbUseArea( .t., cDriver(), cPathOld + "AlbCliI.Dbf", cCheckArea( "AlbCliI", @oldAlbCliI ), .f. )
      ( oldAlbCliI )->( ordListAdd( cPathOld + "AlbCliI.Cdx"  ) )

      dbUseArea( .t., cDriver(), cPathOld + "AlbCliD.Dbf", cCheckArea( "AlbCliD", @oldAlbCliD ), .f. )
      ( oldAlbCliD )->( ordListAdd( cPathOld + "AlbCliD.Cdx"  ) )

      dbUseArea( .t., cDriver(), cPathOld + "AlbCliP.Dbf", cCheckArea( "AlbCliP", @oldAlbCliP ), .f. )
      ( oldAlbCliP )->( ordListAdd( cPathOld + "AlbCliP.Cdx"  ) )

      while !( oldAlbCliT )->( eof() )

         if eval( bFor, oldAlbCliT )
            dbCopy( oldAlbCliT, dbfAlbCliT, .t. )

            if ( oldAlbCliL )->( dbSeek( (oldAlbCliT)->CSERALB + Str( (oldAlbCliT)->NNUMALB ) + (oldAlbCliT)->CSUFALB ) )
               while ( oldAlbCliL )->CSERALB + Str( ( oldAlbCliL )->NNUMALB ) + ( oldAlbCliL )->CSUFALB == (oldAlbCliT)->CSERALB + Str( (dbfAlbCliT)->NNUMALB ) + (dbfAlbCliT)->CSUFALB .and. !(oldAlbCliL)->( eof() )
                  dbCopy( oldAlbCliL, dbfAlbCliL, .t. )
                  ( oldAlbCliL )->( dbSkip() )
               end while
            end if

            if ( oldAlbCliI )->( dbSeek( (oldAlbCliT)->CSERALB + Str( (oldAlbCliT)->NNUMALB ) + (oldAlbCliT)->CSUFALB ) )
               while ( oldAlbCliI )->CSERALB + Str( ( oldAlbCliI )->NNUMALB ) + ( oldAlbCliI )->CSUFALB == ( oldAlbCliT )->CSERALB + Str( ( dbfAlbCliT )->NNUMALB ) + ( dbfAlbCliT )->CSUFALB .and. !( oldAlbCliI )->( eof() )
                  dbCopy( oldAlbCliI, dbfAlbCliI, .t. )
                  ( oldAlbCliI )->( dbSkip() )
               end while
            end if

            if ( oldAlbCliD )->( dbSeek( (oldAlbCliT)->CSERALB + Str( (oldAlbCliT)->NNUMALB ) + (oldAlbCliT)->CSUFALB ) )
               while ( oldAlbCliD )->CSERALB + Str( ( oldAlbCliD )->NNUMALB ) + ( oldAlbCliD )->CSUFALB == ( oldAlbCliT )->CSERALB + Str( ( dbfAlbCliT )->NNUMALB ) + ( dbfAlbCliT )->CSUFALB .and. !( oldAlbCliI )->( eof() )
                  dbCopy( oldAlbCliD, dbfAlbCliD, .t. )
                  ( oldAlbCliD )->( dbSkip() )
               end while
            end if

            if ( oldAlbCliP )->( dbSeek( ( oldAlbCliT )->CSERALB + Str( ( oldAlbCliT )->NNUMALB ) + ( oldAlbCliT )->CSUFALB ) )
               while ( oldAlbCliP )->CSERALB + Str( ( oldAlbCliP )->NNUMALB ) + ( oldAlbCliP )->CSUFALB == ( oldAlbCliT )->CSERALB + Str( ( dbfAlbCliT )->NNUMALB ) + ( dbfAlbCliT )->CSUFALB .and. !( oldAlbCliI )->( eof() )
                  dbCopy( oldAlbCliP, dbfAlbCliP, .t. )
                  ( oldAlbCliP )->( dbSkip() )
               end while
            end if

         end if

         ( oldAlbCliT )->( dbSkip() )

      end while

      /*
      Reemplaza la antigua sesion----------------------------------------------
      */

      ( dbfAlbCliT )->( dbEval( {|| ( dbfAlbCliT )->cTurAlb := Space( 6 ) },,,,, .f. ) )


      ( dbfAlbCliT )->( dbCloseArea() )
      ( dbfAlbCliL )->( dbCloseArea() )
      ( dbfAlbCliI )->( dbCloseArea() )
      ( dbfAlbCliD )->( dbCloseArea() )
      ( dbfAlbCliP )->( dbCloseArea() )

      ( oldAlbCliT )->( dbCloseArea() )
      ( oldAlbCliL )->( dbCloseArea() )
      ( oldAlbCliI )->( dbCloseArea() )
      ( oldAlbCliD )->( dbCloseArea() )
      ( oldAlbCliP )->( dbCloseArea() )

      RECOVER USING oError

         msgStop( "Imposible abrir todas las bases de datos de albaranes de clientes" + CRLF + ErrorMessage( oError ) )

      END SEQUENCE
      ErrorBlock( oBlock )

   end if

RETURN .t.

//---------------------------------------------------------------------------//

FUNCTION rxAlbCli( cPath, oMeter )

	local dbfAlbCliT

   DEFAULT cPath  := cPatEmp()

   if !lExistTable( cPath + "ALBCLIT.DBF" )   .OR. ;
      !lExistTable( cPath + "ALBCLIL.DBF" )   .OR. ;
      !lExistTable( cPath + "ALBCLII.DBF" )   .OR. ;
      !lExistTable( cPath + "ALBCLID.DBF" )   .OR. ;
      !lExistTable( cPath + "ALBCLIP.DBF" )   .OR. ;
      !lExistTable( cPath + "ALBCLIS.DBF" )

      CreateFiles( cPath )

   end if

   fEraseIndex( cPath + "ALBCLIT.CDX" )
   fEraseIndex( cPath + "ALBCLIL.CDX" )
   fEraseIndex( cPath + "ALBCLII.CDX" )
   fEraseIndex( cPath + "ALBCLID.CDX" )
   fEraseIndex( cPath + "ALBCLIP.CDX" )
   fEraseIndex( cPath + "ALBCLIS.CDX" )

   dbUseArea( .t., cDriver(), cPath + "ALBCLIT.DBF", cCheckArea( "ALBCLIT", @dbfAlbCliT ), .f. )

   if !( dbfAlbCliT )->( neterr() )
      ( dbfAlbCliT )->( __dbPack() )

      ( dbfAlbCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() }  ) )
      ( dbfAlbCliT )->( ordCreate( cPath + "ALBCLIT.CDX", "NNUMALB", "CSERALB + Str(NNUMALB) + CSUFALB", {|| Field->CSERALB + Str( Field->NNUMALB ) + Field->CSUFALB } ) )

      ( dbfAlbCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() }  ) )
      ( dbfAlbCliT )->( ordCreate( cPath + "ALBCLIT.CDX", "DFECALB", "DFECALB", {|| Field->DFECALB } ) )

      ( dbfAlbCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() }  ) )
      ( dbfAlbCliT )->( ordCreate( cPath + "ALBCLIT.CDX", "CCODCLI", "CCODCLI", {|| Field->CCODCLI } ) )

      ( dbfAlbCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() }  ) )
      ( dbfAlbCliT )->( ordCreate( cPath + "ALBCLIT.CDX", "CNOMCLI", "Upper( CNOMCLI )", {|| Upper( Field->CNOMCLI ) } ) )

      ( dbfAlbCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() }  ) )
      ( dbfAlbCliT )->( ordCreate( cPath + "ALBCLIT.CDX", "cObra", "cCodObr + Dtos( dFecAlb )", {|| Field->cCodObr + Dtos( Field->dFecAlb ) } ) )

      ( dbfAlbCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() }  ) )
      ( dbfAlbCliT )->( ordCreate( cPath + "ALBCLIT.CDX", "cCodAge", "cCodAge + Dtos( dFecAlb )", {|| Field->cCodAge + Dtos( Field->dFecAlb ) } ) )

      ( dbfAlbCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() }  ) )
      ( dbfAlbCliT )->( ordCreate( cPath + "ALBCLIT.CDX", "CCODSUALB", "CCODSUALB", {|| Field->CCODSUALB } ) )

      ( dbfAlbCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() }  ) )
      ( dbfAlbCliT )->( ordCreate( cPath + "ALBCLIT.CDX", "LFACTURADO", "LFACTURADO", {|| Field->LFACTURADO } ) )

      ( dbfAlbCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() }  ) )
      ( dbfAlbCliT )->( ordCreate( cPath + "ALBCLIT.CDX", "cNumFac", "CNUMFAC", {|| Field->CNUMFAC }, ) )

      ( dbfAlbCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() }  ) )
      ( dbfAlbCliT )->( ordCreate( cPath + "ALBCLIT.CDX", "CTURALB", "CTURALB + CSUFALB + CCODCAJ", {|| Field->CTURALB + Field->CSUFALB + Field->CCODCAJ } ) )

      ( dbfAlbCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() }  ) )
      ( dbfAlbCliT )->( ordCreate( cPath + "ALBCLIT.CDX", "NNUMORD", "Str( nNumOrd ) + cSufOrd", {|| Str( Field->nNumOrd ) + Field->cSufOrd } ) )

      ( dbfAlbCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() }  ) )
      ( dbfAlbCliT )->( ordCreate( cPath + "ALBCLIT.CDX", "CCODTRN", "CCODTRN", {|| Field->CCODTRN } ) )

      ( dbfAlbCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() }  ) )
      ( dbfAlbCliT )->( ordCreate( cPath + "ALBCLIT.CDX", "CCODOBR", "CCODCLI + CCODOBR", {|| Field->CCODCLI + Field->CCODOBR } ) )

      ( dbfAlbCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() }  ) )
      ( dbfAlbCliT )->( ordCreate( cPath + "ALBCLIT.CDX", "CNUMPED", "CNUMPED", {|| Field->CNUMPED } ) )

      ( dbfAlbCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() }  ))
      ( dbfAlbCliT )->( ordCreate( cPath + "ALBCLIT.CDX", "lSndDoc", "lSndDoc", {|| Field->lSndDoc } ) )

      ( dbfAlbCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() }  ) )
      ( dbfAlbCliT )->( ordCreate( cPath + "AlbCliT.Cdx", "cCodUsr", "Field->cCodUsr + Dtos( Field->dFecCre ) + Field->cTimCre", {|| Field->cCodUsr + Dtos( Field->dFecCre ) + Field->cTimCre } ) )

      ( dbfAlbCliT )->( ordCondSet( "!Deleted() .and. !lFacturado", {|| !Deleted() .and. !Field->lFacturado }  ) )
      ( dbfAlbCliT )->( ordCreate( cPath + "AlbCliT.Cdx", "lCodCli", "Field->cCodCli", {|| Field->cCodCli } ) )

      ( dbfAlbCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( dbfAlbCliT )->( ordCreate( cPath + "AlbCliT.CDX", "cSuPed", "cSuPed", {|| Field->cSuPed } ) )

      ( dbfAlbCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( dbfAlbCliT )->( ordCreate( cPath + "AlbCliT.Cdx", "iNumAlb", "'10' + cSerAlb + Str( nNumAlb ) + Space( 1 ) + cSufAlb", {|| '10' + Field->cSerAlb + Str( Field->nNumAlb ) + Space( 1 ) + Field->cSufAlb } ) )

      ( dbfAlbCliT )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de albaranes de clientes" )
   end if

   dbUseArea( .t., cDriver(), cPath + "ALBCLIL.DBF", cCheckArea( "ALBCLIL", @dbfAlbCliT ), .f. )

   if !( dbfAlbCliT )->( neterr() )
      ( dbfAlbCliT )->( __dbPack() )

      ( dbfAlbCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( dbfAlbCliT )->( ordCreate( cPath + "ALBCLIL.CDX", "NNUMALB", "CSERALB + STR( NNUMALB ) + CSUFALB", {|| Field->CSERALB + STR( Field->NNUMALB ) + Field->CSUFALB } ) )

      ( dbfAlbCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( dbfAlbCliT )->( ordCreate( cPath + "ALBCLIL.CDX", "cRef", "cRef + cCodPr1 + cCodPr2 + cSerAlb + Str( nNumAlb ) + cSufAlb", {|| Field->cRef + Field->cCodPr1 + Field->cCodPr2 + Field->cSerAlb + Str( Field->nNumAlb ) + Field->cSufAlb } ) )

      ( dbfAlbCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( dbfAlbCliT )->( ordCreate( cPath + "ALBCLIL.CDX", "Lote", "cLote" , {|| Field->cLote } ) )

      ( dbfAlbCliT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfAlbCliT )->( ordCreate( cPath + "AlbCLIL.CDX", "cRefLote", "cRef + cLote", {|| Field->cRef + Field->cLote } ) )

      ( dbfAlbCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( dbfAlbCliT )->( ordCreate( cPath + "ALBCLIL.CDX", "cNumPed", "cNumPed", {|| Field->cNumPed } ) )

      ( dbfAlbCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( dbfAlbCliT )->( ordCreate( cPath + "ALBCLIL.CDX", "cNumPedRef", "cNumPed + cRef + cCodPr1 + cCodPr2", {|| Field->cNumPed + Field->cRef + Field->cCodPr1 + Field->cCodPr2 } ) )

      ( dbfAlbCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( dbfAlbCliT )->( ordCreate( cPath + "ALBCLIL.CDX", "cNumPedDet", "cNumPed + cRef + cCodPr1 + cCodPr2 + cRefPrv", {|| Field->cNumPed + Field->cRef + Field->cCodPr1 + Field->cCodPr2 + Field->cRefPrv } ) ) // + cDetalle

      ( dbfAlbCliT )->( ordCondSet("!Deleted()", {|| !Deleted() } ) )
      ( dbfAlbCliT )->( ordCreate( cPath + "ALBCLIL.CDX", "cNumRef", "cSerAlb + Str( nNumAlb ) + cSufAlb + cRef", {|| Field->cSerAlb + Str( Field->nNumAlb ) + Field->cSufAlb + Field->cRef } ) )

      ( dbfAlbCliT )->( ordCondSet("!lFacturado .and. !Deleted()", {|| !Field->lFacturado .and. !Deleted() } ) )
      ( dbfAlbCliT )->( ordCreate( cPath + "ALBCLIL.CDX", "cStkFast", "cRef", {|| Field->cRef } ) )

      ( dbfAlbCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( dbfAlbCliT )->( ordCreate( cPath + "ALBCLIL.CDX", "cPedRef", "cNumPed + cRef", {|| Field->cNumPed + Field->cRef } ) )

      ( dbfAlbCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( dbfAlbCliT )->( ordCreate( cPath + "AlbCliL.Cdx", "iNumAlb", "'10' + cSerAlb + Str( nNumAlb ) + Space( 1 ) + cSufAlb", {|| '10' + Field->cSerAlb + Str( Field->nNumAlb ) + Space( 1 ) + Field->cSufAlb } ) )

      ( dbfAlbCliT )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de albaranes de clientes" )
   end if

   // Pagos de albaranes

   dbUseArea( .t., cDriver(), cPath + "ALBCLIP.DBF", cCheckArea( "ALBCLIP", @dbfAlbCliT ), .f. )

   if !( dbfAlbCliT )->( neterr() )
      ( dbfAlbCliT )->( __dbPack() )

      ( dbfAlbCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( dbfAlbCliT )->( ordCreate( cPath + "ALBCLIP.CDX", "NNUMALB", "CSERALB + STR( NNUMALB ) + CSUFALB + STR( NNUMREC )", {|| Field->CSERALB + STR( Field->NNUMALB ) + Field->CSUFALB + STR( Field->NNUMREC ) } ) )

      ( dbfAlbCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( dbfAlbCliT )->( ordCreate( cPath + "ALBCLIP.CDX", "CTURREC", "cTurRec + cSufAlb + cCodCaj", {|| Field->cTurRec + Field->cSufAlb + Field->cCodCaj } ) )

      ( dbfAlbCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( dbfAlbCliT )->( ordCreate( cPath + "ALBCLIP.CDX", "CCODCLI", "cCodCli", {|| Field->cCodCli } ) )

      ( dbfAlbCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( dbfAlbCliT )->( ordCreate( cPath + "AlbCliP.CDX", "DENTREGA", "dEntrega", {|| Field->dEntrega } ) )

      ( dbfAlbCliT )->( ordCondSet("!Deleted() .and. !Field->lPasado", {|| !Deleted() .and. !Field->lPasado } ) )
      ( dbfAlbCliT )->( ordCreate( cPath + "AlbCliP.Cdx", "lCtaBnc", "Field->cEntEmp + Field->cSucEmp + Field->cDigEmp + Field->cCtaEmp", {|| Field->cEntEmp + Field->cSucEmp + Field->cDigEmp + Field->cCtaEmp } ) )

      ( dbfAlbCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( dbfAlbCliT )->( ordCreate( cPath + "AlbCliP.Cdx", "iNumAlb", "'10' + cSerAlb + Str( nNumAlb ) + Space( 1 ) + cSufAlb", {|| '10' + Field->cSerAlb + Str( Field->nNumAlb ) + Space( 1 ) + Field->cSufAlb } ) )

      ( dbfAlbCliT )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de albaranes de clientes" )
   end if

   dbUseArea( .t., cDriver(), cPath + "AlbCliI.DBF", cCheckArea( "AlbCliI", @dbfAlbCliT ), .f. )

   if !( dbfAlbCliT )->( neterr() )
      ( dbfAlbCliT )->( __dbPack() )

      ( dbfAlbCliT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfAlbCliT )->( ordCreate( cPath + "AlbCliI.CDX", "NNUMALB", "CSERALB + STR( NNUMALB ) + CSUFALB", {|| Field->CSERALB + STR( Field->NNUMALB ) + Field->CSUFALB } ) )

      ( dbfAlbCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( dbfAlbCliT )->( ordCreate( cPath + "AlbCliI.Cdx", "iNumAlb", "'10' + cSerAlb + Str( nNumAlb ) + Space( 1 ) + cSufAlb", {|| '10' + Field->cSerAlb + Str( Field->nNumAlb ) + Space( 1 ) + Field->cSufAlb } ) )

      ( dbfAlbCliT )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de albaranes de clientes" )
   end if

   dbUseArea( .t., cDriver(), cPath + "AlbCliD.DBF", cCheckArea( "AlbCliD", @dbfAlbCliT ), .f. )

   if !( dbfAlbCliT )->( neterr() )
      ( dbfAlbCliT )->( __dbPack() )

      ( dbfAlbCliT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfAlbCliT )->( ordCreate( cPath + "AlbCliD.CDX", "NNUMALB", "CSERALB + STR( NNUMALB ) + CSUFALB", {|| Field->CSERALB + STR( Field->NNUMALB ) + Field->CSUFALB } ) )

      ( dbfAlbCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( dbfAlbCliT )->( ordCreate( cPath + "AlbCliD.Cdx", "iNumAlb", "'10' + cSerAlb + Str( nNumAlb ) + Space( 1 ) + cSufAlb", {|| '10' + Field->cSerAlb + Str( Field->nNumAlb ) + Space( 1 ) + Field->cSufAlb } ) )

      ( dbfAlbCliT )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de albaranes de clientes" )
   end if

   dbUseArea( .t., cDriver(), cPath + "AlbCliS.Dbf", cCheckArea( "AlbCliS", @dbfAlbCliT ), .f. )

   if !( dbfAlbCliT )->( neterr() )
      ( dbfAlbCliT )->( __dbPack() )

      ( dbfAlbCliT )->( ordCondSet( "!Deleted()", {||!Deleted()}  ) )
      ( dbfAlbCliT )->( ordCreate( cPath + "AlbCliS.CDX", "nNumAlb", "cSerAlb + Str( nNumAlb ) + cSufAlb + Str( nNumLin )", {|| Field->cSerAlb + Str( Field->nNumAlb ) + Field->cSufAlb + Str( Field->nNumLin ) } ) )

      ( dbfAlbCliT )->( ordCondSet( "!lFacturado .and. !Deleted()", {|| !Field->lFacturado .and. !Deleted() } ) )
      ( dbfAlbCliT )->( ordCreate( cPath + "AlbCliS.CDX", "cRefSer", "cRef + cAlmLin + cNumSer", {|| Field->cRef + Field->cAlmLin + Field->cNumSer } ) )

      ( dbfAlbCliT )->( ordCondSet( "!lFacturado .and. !Deleted()", {|| !Field->lFacturado .and. !Deleted() } ) )
      ( dbfAlbCliT )->( ordCreate( cPath + "AlbCliS.CDX", "cNumSer", "cNumSer", {|| Field->cNumSer } ) )

      ( dbfAlbCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( dbfAlbCliT )->( ordCreate( cPath + "AlbCliS.Cdx", "iNumAlb", "'10' + cSerAlb + Str( nNumAlb ) + Space( 1 ) + cSufAlb", {|| '10' + Field->cSerAlb + Str( Field->nNumAlb ) + Space( 1 ) + Field->cSufAlb } ) )

      ( dbfAlbCliT )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de numeros de series de albaranes de clientes" )
   end if

RETURN NIL

//--------------------------------------------------------------------------//

STATIC FUNCTION CreateFiles( cPath )

   if !lExistTable( cPath + "AlbCliT.Dbf" )
      dbCreate( cPath + "AlbCliT.Dbf", aSqlStruct( aItmAlbCli() ), cDriver() )
   end if

   if !lExistTable( cPath + "AlbCliL.Dbf" )
      dbCreate( cPath + "AlbCliL.Dbf", aSqlStruct( aColAlbCli() ), cDriver() )
   end if

   if !lExistTable( cPath + "AlbCliP.Dbf" )
      dbCreate( cPath + "AlbCliP.Dbf", aSqlStruct( aItmAlbPgo() ), cDriver() )
   end if

   if !lExistTable( cPath + "AlbCliI.Dbf" )
      dbCreate( cPath + "AlbCliI.Dbf", aSqlStruct( aIncAlbCli() ), cDriver() )
   end if

   if !lExistTable( cPath + "AlbCliD.Dbf" )
      dbCreate( cPath + "AlbCliD.Dbf", aSqlStruct( aAlbCliDoc() ), cDriver() )
   end if

   if !lExistTable( cPath + "AlbCliS.Dbf" )
      dbCreate( cPath + "AlbCliS.Dbf", aSqlStruct( aSerAlbCli() ), cDriver() )
   end if

RETURN NIL

//--------------------------------------------------------------------//

function aAlbCliDoc()

   local aAlbCliDoc  := {}

   aAdd( aAlbCliDoc, { "cSerAlb", "C",    1,  0, "Serie de albarán" ,                "",                   "", "( cDbfCol )" } )
   aAdd( aAlbCliDoc, { "nNumAlb", "N",    9,  0, "Número de albarán" ,               "'999999999'",        "", "( cDbfCol )" } )
   aAdd( aAlbCliDoc, { "cSufAlb", "C",    2,  0, "Sufijo de albarán" ,               "",                   "", "( cDbfCol )" } )
   aAdd( aAlbCliDoc, { "cNombre", "C",  250,  0, "Nombre del documento" ,            "",                   "", "( cDbfCol )" } )
   aAdd( aAlbCliDoc, { "cRuta",   "C",  250,  0, "Ruta del documento" ,              "",                   "", "( cDbfCol )" } )
   aAdd( aAlbCliDoc, { "mObsDoc", "M",   10,  0, "Observaciones del documento" ,     "",                   "", "( cDbfCol )" } )

return ( aAlbCliDoc )

//---------------------------------------------------------------------------//

function aIncAlbCli()

   local aIncAlbCli  := {}

   aAdd( aIncAlbCli, { "cSerAlb", "C",    1,  0, "Serie de albarán" ,                "",                   "", "( cDbfCol )" } )
   aAdd( aIncAlbCli, { "nNumAlb", "N",    9,  0, "Número de albarán" ,               "'999999999'",        "", "( cDbfCol )" } )
   aAdd( aIncAlbCli, { "cSufAlb", "C",    2,  0, "Sufijo de albarán" ,               "",                   "", "( cDbfCol )" } )
   aAdd( aIncAlbCli, { "cCodTip", "C",    3,  0, "Tipo de incidencia" ,              "",                   "", "( cDbfCol )" } )
   aAdd( aIncAlbCli, { "dFecInc", "D",    8,  0, "Fecha de la incidencia" ,          "",                   "", "( cDbfCol )" } )
   aAdd( aIncAlbCli, { "mDesInc", "M",   10,  0, "Descripción de la incidencia" ,    "",                   "", "( cDbfCol )" } )
   aAdd( aIncAlbCli, { "lListo",  "L",    1,  0, "Lógico de listo" ,                 "",                   "", "( cDbfCol )" } )
   aAdd( aIncAlbCli, { "lAviso",  "L",    1,  0, "Lógico de aviso" ,                 "",                   "", "( cDbfCol )" } )

return ( aIncAlbCli )

//---------------------------------------------------------------------------//

function aItmAlbPgo()

   local aBasRecCli  := {}

   aAdd( aBasRecCli, {"cSerAlb"     ,"C",  1, 0, "Serie de albarán" ,                  "",                  "", "( cDbfEnt )" } )
   aAdd( aBasRecCli, {"nNumAlb"     ,"N",  9, 0, "Número de albarán" ,                 "'999999999'",       "", "( cDbfEnt )" } )
   aAdd( aBasRecCli, {"cSufAlb"     ,"C",  2, 0, "Sufijo de albarán" ,                 "",                  "", "( cDbfEnt )" } )
   aAdd( aBasRecCli, {"nNumRec"     ,"N",  2, 0, "Número del recibo",                  "",                  "", "( cDbfEnt )" } )
   aAdd( aBasRecCli, {"cCodCaj"     ,"C",  3, 0, "Código de caja",                     "",                  "", "( cDbfEnt )" } )
   aAdd( aBasRecCli, {"cTurRec"     ,"C",  6, 0, "Sesión del recibo",                  "######",            "", "( cDbfEnt )" } )
   aAdd( aBasRecCli, {"cCodCli"     ,"C", 12, 0, "Código de cliente",                  "",                  "", "( cDbfEnt )" } )
   aAdd( aBasRecCli, {"dEntrega"    ,"D",  8, 0, "Fecha de cobro",                     "",                  "", "( cDbfEnt )" } )
   aAdd( aBasRecCli, {"nImporte"    ,"N", 16, 6, "Importe",                            "cPorDivEnt",        "", "( cDbfEnt )" } )
   aAdd( aBasRecCli, {"cDescrip"    ,"C",100, 0, "Concepto del pago",                  "",                  "", "( cDbfEnt )" } )
   aAdd( aBasRecCli, {"cPgdoPor"    ,"C", 50, 0, "Pagado por",                         "",                  "", "( cDbfEnt )" } )
   aAdd( aBasRecCli, {"cDocPgo"     ,"C", 50, 0, "Documento de pago",                  "",                  "", "( cDbfEnt )" } )
   aAdd( aBasRecCli, {"cDivPgo"     ,"C",  3, 0, "Código de la divisa",                "",                  "", "( cDbfEnt )" } )
   aAdd( aBasRecCli, {"nVdvPgo"     ,"N", 10, 6, "Cambio de la divisa",                "",                  "", "( cDbfEnt )" } )
   aAdd( aBasRecCli, {"cCodAge"     ,"C",  3, 0, "Código del agente",                  "",                  "", "( cDbfEnt )" } )
   aAdd( aBasRecCli, {"cCodPgo"     ,"C",  2, 0, "Código de la forma de pago",         "",                  "", "( cDbfEnt )" } )
   aAdd( aBasRecCli, {"lCloPgo"     ,"L",  1, 0, "Logico de turno cerrado",            "",                  "", "( cDbfEnt )" } )
   aAdd( aBasRecCli, {"cNumAnt"     ,"C", 14, 0, "Número del anticipo en el pedido",   "",                  "", "( cDbfEnt )" } )
   aAdd( aBasRecCli, {"cNumRec"     ,"C", 14, 0, "Número del pedido al que pertenece", "",                  "", "( cDbfEnt )" } )
   aAdd( aBasRecCli, {"lPasado"     ,"L",  1, 0, "Lógico de pasado",                   "",                  "", "( cDbfEnt )" } )
   aAdd( aBasRecCli, {"cBncEmp"     ,"C", 50, 0, "Banco de la empresa para el recibo" ,"",                  "", "( cDbfEnt )", nil } )
   aAdd( aBasRecCli, {"cBncCli"     ,"C", 50, 0, "Banco del cliente para el recibo" ,"",                    "", "( cDbfEnt )", nil } )
   aAdd( aBasRecCli, {"cEntEmp"     ,"C",  4, 0, "Entidad de la cuenta de la empresa",  "",                 "", "( cDbfEnt )", nil } )
   aAdd( aBasRecCli, {"cSucEmp"     ,"C",  4, 0, "Sucursal de la cuenta de la empresa",  "",                "", "( cDbfEnt )", nil } )
   aAdd( aBasRecCli, {"cDigEmp"     ,"C",  2, 0, "Dígito de control de la cuenta de la empresa", "",        "", "( cDbfEnt )", nil } )
   aAdd( aBasRecCli, {"cCtaEmp"     ,"C", 10, 0, "Cuenta bancaria de la empresa",  "",                      "", "( cDbfEnt )", nil } )
   aAdd( aBasRecCli, {"cEntCli"     ,"C",  4, 0, "Entidad de la cuenta del cliente",  "",                   "", "( cDbfEnt )", nil } )
   aAdd( aBasRecCli, {"cSucCli"     ,"C",  4, 0, "Sucursal de la cuenta del cliente",  "",                  "", "( cDbfEnt )", nil } )
   aAdd( aBasRecCli, {"cDigCli"     ,"C",  2, 0, "Dígito de control de la cuenta del cliente", "",          "", "( cDbfEnt )", nil } )
   aAdd( aBasRecCli, {"cCtaCli"     ,"C", 10, 0, "Cuenta bancaria del cliente",  "",                        "", "( cDbfEnt )", nil } )


return ( aBasRecCli )

//---------------------------------------------------------------------------//

Function aColAlbCli()

   local aColAlbCli  := {}

   aAdd( aColAlbCli, { "cSerAlb",   "C",  1, 0, "Serie del albarán" ,            "",                  "", "( cDbfCol )" } )
   aAdd( aColAlbCli, { "nNumAlb",   "N",  9, 0, "Número del albarán" ,           "'999999999'",       "", "( cDbfCol )" } )
   aAdd( aColAlbCli, { "cSufAlb",   "C",  2, 0, "Sufijo del albarán" ,           "",                  "", "( cDbfCol )" } )
   aAdd( aColAlbCli, { "cRef",      "C", 18, 0, "Referencia de artículo" ,       "",                  "", "( cDbfCol )" } )
   aAdd( aColAlbCli, { "cDetalle",  "C",250, 0, "Detalle de artículo" ,          "",                  "", "( cDbfCol )" } )
   aAdd( aColAlbCli, { "nPreUnit",  "N", 16, 6, "Precio artículo" ,              "cPouDivAlb",        "", "( cDbfCol )" } )
   aAdd( aColAlbCli, { "nPntVer",   "N", 16, 6, "Importe punto verde" ,          "cPpvDivAlb",        "", "( cDbfCol )" } )
   aAdd( aColAlbCli, { "nImpTrn",   "N", 16, 6, "Importe del porte" ,            "cPouDivAlb",        "", "( cDbfCol )" } )
   aAdd( aColAlbCli, { "nDto",      "N",  6, 2, "Descuento de artículo" ,        "'@E 999.9'",        "", "( cDbfCol )" } )
   aAdd( aColAlbCli, { "nDtoPrm",   "N",  6, 2, "Descuento de promoción" ,       "'@E 999.9'",        "", "( cDbfCol )" } )
   aAdd( aColAlbCli, { "nIva",      "N",  4, 1, cImp() + " del artículo" ,             "'@E 99'",           "", "( cDbfCol )" } )
   aAdd( aColAlbCli, { "nCanEnt",   "N", 16, 6, cNombreCajas(),                  "MasUnd()",          "", "( cDbfCol )" } )
   aAdd( aColAlbCli, { "nCanFac",   "N", 16, 6, "Cantidad facturada" ,           "MasUnd()",          "", "( cDbfCol )" } )
   aAdd( aColAlbCli, { "lControl",  "L",  1, 0, "Control reservado" ,            "",                  "", "( cDbfCol )" } )
   aAdd( aColAlbCli, { "nPesoKg",   "N", 16, 6, "Peso del producto" ,            "'@E 9,999.99'",     "", "( cDbfCol )" } )
   aAdd( aColAlbCli, { "cPesoKg",   "C",  2, 0, "Unidad de peso del producto" ,  "",                  "", "( cDbfCol )" } )
   aAdd( aColAlbCli, { "cUnidad",   "C",  2, 0, "Unidad de venta" ,              "",                  "", "( cDbfCol )" } )
   aAdd( aColAlbCli, { "nComAge",   "N",  6, 2, "Comisión del agente" ,          "'@E 999.9'",        "", "( cDbfCol )" } )
   aAdd( aColAlbCli, { "nUniCaja",  "N", 16, 6, cNombreUnidades(),               "MasUnd()",          "", "( cDbfCol )" } )
   aAdd( aColAlbCli, { "nUndKit",   "N", 16, 6, "Unidades del producto kit",     "MasUnd()",          "", "( cDbfCol )" } )
   aAdd( aColAlbCli, { "dFecha",    "D",  8, 0, "Fecha de linea" ,               "",                  "", "( cDbfCol )" } )
   aAdd( aColAlbCli, { "cTipMov",   "C",  2, 0, "Tipo de movimiento" ,           "",                  "", "( cDbfCol )" } )
   aAdd( aColAlbCli, { "mLngDes",   "M", 10, 0, "Descripción larga" ,            "",                  "", "( cDbfCol )" } )
   aAdd( aColAlbCli, { "lTotLin",   "L",  1, 0, "Línea de total" ,               "",                  "", "( cDbfCol )" } )
   aAdd( aColAlbCli, { "lImpLin",   "L",  1, 0, "Línea no imprimible" ,          "",                  "", "( cDbfCol )" } )
   aAdd( aColAlbCli, { "lNewLin",   "L",  1, 0, "" ,                             "",                  "", "( cDbfCol )" } )
   aAdd( aColAlbCli, { "cNumPed"   ,"C", 12, 0, "Número del pedido" ,            "",                  "", "( cDbfCol )" } )
   aAdd( aColAlbCli, { "cCodPr1",   "C", 10, 0, "Código de primera propiedad",   "",                  "", "( cDbfCol )" } )
   aAdd( aColAlbCli, { "cCodPr2",   "C", 10, 0, "Código de segunda propiedad",   "",                  "", "( cDbfCol )" } )
   aAdd( aColAlbCli, { "cValPr1",   "C", 10, 0, "Valor de primera propiedad",    "",                  "", "( cDbfCol )" } )
   aAdd( aColAlbCli, { "cValPr2",   "C", 10, 0, "Valor de segunda propiedad",    "",                  "", "( cDbfCol )" } )
   aAdd( aColAlbCli, { "nFacCnv",   "N", 16, 6, "",                              "",                  "", "( cDbfCol )" } )
   aAdd( aColAlbCli, { "nDtoDiv",   "N", 16, 6, "Descuento en línea",            "cPouDivAlb",        "", "( cDbfCol )" } )
   aAdd( aColAlbCli, { "nNumLin",   "N",  4, 0, "Número de la línea",            "'9999'",            "", "( cDbfCol )" } )
   aAdd( aColAlbCli, { "nCtlStk",   "N",  1, 0, "Tipo de stock de la linea",     "9",                 "", "( cDbfCol )" } )
   aAdd( aColAlbCli, { "nCosDiv",   "N", 16, 6, "Precio de costo",               "cPouDivAlb",        "", "( cDbfCol )" } )
   aAdd( aColAlbCli, { "nPvpRec",   "N", 16, 6, "Precio de venta recomendado",   "cPouDivAlb",        "", "( cDbfCol )" } )
   aAdd( aColAlbCli, { "cAlmLin",   "C",  3, 0, "Código del almacen",            "",                  "", "( cDbfCol )" } )
   aAdd( aColAlbCli, { "lIvaLin",   "L",  1, 0, cImp() + " incluido",            "",                  "", "( cDbfCol )" } )
   aAdd( aColAlbCli, { "nValImp",   "N", 16, 6, "Importe de impuesto",           "",                  "", "( cDbfCol )" } )
   aAdd( aColAlbCli, { "cCodImp",   "C",  3, 0, "Código del IVMH",               "",                  "", "( cDbfCol )" } )
   aAdd( aColAlbCli, { "lLote",     "L",  1, 0, "",                              "",                  "", "( cDbfCol )" } )
   aAdd( aColAlbCli, { "nLote",     "N",  9, 0, "",                              "'999999999'",       "", "( cDbfCol )" } )
   aAdd( aColAlbCli, { "cLote",     "C", 12, 0, "Número de lote",                "",                  "", "( cDbfCol )" } )
   aAdd( aColAlbCli, { "dFecCad",   "D",  8, 0, "Fecha de caducidad",            "",                  "", "( cDbfCol )" } )
   aAdd( aColAlbCli, { "lKitArt",   "L",  1, 0, "Línea con escandallo",          "",                  "", "( cDbfCol )" } )
   aAdd( aColAlbCli, { "lKitChl",   "L",  1, 0, "Línea pertenciente a escandallo", "",                "", "( cDbfCol )" } )
   aAdd( aColAlbCli, { "lKitPrc",   "L",  1, 0, "",                              "",                  "", "( cDbfCol )" } )
   aAdd( aColAlbCli, { "nMesGrt",   "N",  2, 0, "Meses de garantía",             "'99'",              "", "( cDbfCol )" } )
   aAdd( aColAlbCli, { "lMsgVta",   "L",  1, 0, "Avisar venta sin stocks",       "",                  "", "( cDbfCol )" } )
   aAdd( aColAlbCli, { "lNotVta",   "L",  1, 0, "No permitir venta sin stocks",  "",                  "", "( cDbfCol )" } )
   aAdd( aColAlbCli, { "mNumSer",   "M", 10, 0, "" ,                             "",                  "", "( cDbfCol )" } )
   aAdd( aColAlbCli, { "cCodTip",   "C",  3, 0, "Código del tipo de artículo",   "",                  "", "( cDbfCol )" } )
   aAdd( aColAlbCli, { "cCodFam",   "C", 16, 0, "Código de familia",             "",                  "", "( cDbfCol )" } )
   aAdd( aColAlbCli, { "cGrpFam",   "C",  3, 0, "Código del grupo de familia",   "",                  "", "( cDbfCol )" } )
   aAdd( aColAlbCli, { "nReq",      "N", 16, 6, "Recargo de equivalencia",       "",                  "", "( cDbfCol )" } )
   aAdd( aColAlbCli, { "mObsLin",   "M", 10, 0, "Observación de línea",          "",                  "", "( cDbfCol )" } )
   aAdd( aColAlbCli, { "cCodPrv",   "C", 12, 0, "Código del proveedor",          "",                  "", "( cDbfCol )" } )
   aAdd( aColAlbCli, { "cNomPrv",   "C", 30, 0, "Nombre del proveedor",          "",                  "", "( cDbfCol )" } )
   aAdd( aColAlbCli, { "cImagen",   "C",250, 0, "Fichero de imagen" ,            "",                  "", "( cDbfCol )", .t. } )
   aAdd( aColAlbCli, { "nPuntos",   "N", 15, 6, "Puntos del artículo",           "",                  "", "( cDbfCol )" } )
   aAdd( aColAlbCli, { "nValPnt",   "N", 16, 6, "Valor del punto",               "",                  "", "( cDbfCol )" } )
   aAdd( aColAlbCli, { "nDtoPnt",   "N",  5, 2, "Descuento puntos",              "",                  "", "( cDbfCol )" } )
   aAdd( aColAlbCli, { "nIncPnt",   "N",  5, 2, "Incremento porcentual",         "",                  "", "( cDbfCol )" } )
   aAdd( aColAlbCli, { "cRefPrv",   "C", 18, 0, "Referencia proveedor",          "",                  "", "( cDbfCol )" } )
   aAdd( aColAlbCli, { "nVolumen",  "N", 16, 6, "Volumen del producto" ,         "'@E 9,999.99'",     "", "( cDbfCol )" } )
   aAdd( aColAlbCli, { "cVolumen",  "C",  2, 0, "Unidad del volumen" ,           "",                  "", "( cDbfCol )" } )
   aAdd( aColAlbCli, { "dFecEnt" ,  "D",  8, 0, "Fecha de entrada del alquiler", "",                  "", "( cDbfCol )" } )
   aAdd( aColAlbCli, { "dFecSal" ,  "D",  8, 0, "Fecha de salida del alquiler",  "",                  "", "( cDbfCol )" } )
   aAdd( aColAlbCli, { "nPreAlq" ,  "N", 16, 6, "Precio de alquiler",            "",                  "", "( cDbfCol )" } )
   aAdd( aColAlbCli, { "lAlquiler", "L",  1, 0, "Lógico de alquiler",            "",                  "", "( cDbfCol )" } )
   aAdd( aColAlbCli, { "nNumMed",   "N",  1, 0, "Número de mediciones",          "MasUnd()",          "", "( cDbfCol )" } )
   aAdd( aColAlbCli, { "nMedUno",   "N", 16, 6, "Primera unidad de medición",    "MasUnd()",          "", "( cDbfCol )" } )
   aAdd( aColAlbCli, { "nMedDos",   "N", 16, 6, "Segunda unidad de medición",    "MasUnd()",          "", "( cDbfCol )" } )
   aAdd( aColAlbCli, { "nMedTre",   "N", 16, 6, "Tercera unidad de medición",    "MasUnd()",          "", "( cDbfCol )" } )
   aAdd( aColAlbCli, { "nTarLin",   "N", 16, 6, "Tarifa de precio aplicada",     "MasUnd()",          "", "( cDbfCol )" } )
   aAdd( aColAlbCli, { "cCodUbi1",  "C",  5, 0, "",                              "",                  "", "( cDbfCol )" } )
   aAdd( aColAlbCli, { "cCodUbi2",  "C",  5, 0, "",                              "",                  "", "( cDbfCol )" } )
   aAdd( aColAlbCli, { "cCodUbi3",  "C",  5, 0, "",                              "",                  "", "( cDbfCol )" } )
   aAdd( aColAlbCli, { "cValUbi1",  "C",  5, 0, "",                              "",                  "", "( cDbfCol )" } )
   aAdd( aColAlbCli, { "cValUbi2",  "C",  5, 0, "",                              "",                  "", "( cDbfCol )" } )
   aAdd( aColAlbCli, { "cValUbi3",  "C",  5, 0, "",                              "",                  "", "( cDbfCol )" } )
   aAdd( aColAlbCli, { "cNomUbi1",  "C", 30, 0, "",                              "",                  "", "( cDbfCol )" } )
   aAdd( aColAlbCli, { "cNomUbi2",  "C", 30, 0, "",                              "",                  "", "( cDbfCol )" } )
   aAdd( aColAlbCli, { "cNomUbi3",  "C", 30, 0, "",                              "",                  "", "( cDbfCol )" } )
   aAdd( aColAlbCli, { "lImpFra",   "L",  1, 0, "Lógico de imprimir frase publicitaria", "",          "", "( cDbfCol )" } )
   aAdd( aColAlbCli, { "cCodFra",   "C",  3, 0, "Código de frase publicitaria",  "",                  "", "( cDbfCol )" } )
   aAdd( aColAlbCli, { "cTxtFra",   "C",250, 0, "",                              "",                  "", "( cDbfCol )" } )
   aAdd( aColAlbCli, { "Descrip",   "M", 10, 0, "Observación de línea",          "",                  "", "( cDbfCol )" } )
   aAdd( aColAlbCli, { "lFacturado","L",  1, 0, "Lógico de facturado",           "",                  "", "( cDbfCol )" } )
   aAdd( aColAlbCli, { "lLinOfe"  , "L",  1, 0, "Línea con oferta",              "",                  "", "( cDbfCol )" } )
   aAdd( aColAlbCli, { "lVolImp",   "L",  1, 0, "Lógico aplicar volumen con IpusEsp",  "",            "", "( cDbfCol )" } )
   aAdd( aColAlbCli, { "dFecAlb",   "D",  8, 0, "Fecha de albaran",              "",                  "", "( cDbfCol )" } )
   aAdd( aColAlbCli, { "cNumSat"   ,"C", 12, 0, "Número del SAT" ,               "",                  "", "( cDbfCol )" } )

Return ( aColAlbCli )

//---------------------------------------------------------------------------//

Function aItmAlbCli()

   local aItmAlbCli := {}

   aAdd( aItmAlbCli, { "CSERALB"   ,"C",  1, 0, "Serie del albarán" ,                                    "",                   "", "( cDbf )"} )
   aAdd( aItmAlbCli, { "NNUMALB"   ,"N",  9, 0, "Número del albarán" ,                                   "'999999999'",        "", "( cDbf )"} )
   aAdd( aItmAlbCli, { "CSUFALB"   ,"C",  2, 0, "Sufijo del albarán" ,                                   "",                   "", "( cDbf )"} )
   aAdd( aItmAlbCli, { "CTURALB"   ,"C",  6, 0, "Sesión del albarán",                                    "",                   "", "( cDbf )"} )
   aAdd( aItmAlbCli, { "DFECALB"   ,"D",  8, 0, "Fecha del albarán" ,                                    "",                   "", "( cDbf )"} )
   aAdd( aItmAlbCli, { "CCODCLI"   ,"C", 12, 0, "Código del cliente" ,                                   "'@!'",               "", "( cDbf )"} )
   aAdd( aItmAlbCli, { "CCODALM"   ,"C",  3, 0, "Código de almacén" ,                                    "'@!'",               "", "( cDbf )"} )
   aAdd( aItmAlbCli, { "CCODCAJ"   ,"C",  3, 0, "Código de caja" ,                                       "'@!'",               "", "( cDbf )"} )
   aAdd( aItmAlbCli, { "CNOMCLI"   ,"C", 80, 0, "Nombre del cliente" ,                                   "'@!'",               "", "( cDbf )"} )
   aAdd( aItmAlbCli, { "CDIRCLI"   ,"C",100, 0, "Domicilio del cliente" ,                                "'@!'",               "", "( cDbf )"} )
   aAdd( aItmAlbCli, { "CPOBCLI"   ,"C", 35, 0, "Población del cliente" ,                                "'@!'",               "", "( cDbf )"} )
   aAdd( aItmAlbCli, { "CPRVCLI"   ,"C", 20, 0, "Provincia del cliente" ,                                "'@!'",               "", "( cDbf )"} )
   aAdd( aItmAlbCli, { "CPOSCLI"   ,"C", 15, 0, "Código postal del cliente" ,                            "'@!'",               "", "( cDbf )"} )
   aAdd( aItmAlbCli, { "CDNICLI"   ,"C", 30, 0, "DNI/CIF del cliente" ,                                  "'@!'",               "", "( cDbf )"} )
   aAdd( aItmAlbCli, { "LMODCLI"   ,"L",  1, 0, "Lógico de modificar datos del cliente" ,                "",                   "", "( cDbf )"} )
   aAdd( aItmAlbCli, { "LFACTURADO","L",  1, 0, "Lógico de facturado" ,                                  "",                   "", "( cDbf )"} )
   aAdd( aItmAlbCli, { "lEntregado","L",  1, 0, "Lógico albarán enviado" ,                               "",                   "", "( cDbf )"} )
   aAdd( aItmAlbCli, { "DFECENT"   ,"D",  8, 0, "Fecha de entrada del albarán" ,                         "",                   "", "( cDbf )"} )
   aAdd( aItmAlbCli, { "CCODSUALB" ,"C", 25, 0, "Referencia a su albarán" ,                              "",                   "", "( cDbf )"} )
   aAdd( aItmAlbCli, { "CCONDENT"  ,"C",100, 0, "Condición de entrada" ,                                 "",                   "", "( cDbf )"} )
   aAdd( aItmAlbCli, { "MCOMENT"   ,"M", 10, 0, "Cometarios del albarán" ,                               "",                   "", "( cDbf )"} )
   aAdd( aItmAlbCli, { "MOBSERV"   ,"M", 10, 0, "Observaciones" ,                                        "",                   "", "( cDbf )"} )
   aAdd( aItmAlbCli, { "CCODPAGO"  ,"C",  2, 0, "Código de la forma de pago" ,                           "'@!'",               "", "( cDbf )"} )
   aAdd( aItmAlbCli, { "NBULTOS"   ,"N",  3, 0, "Número de bultos" ,                                     "'999'",              "", "( cDbf )"} )
   aAdd( aItmAlbCli, { "NPORTES"   ,"N", 16, 6, "Importe de los portes" ,                                "cPouDivAlb",         "", "( cDbf )"} )
   aAdd( aItmAlbCli, { "CCODAGE"   ,"C",  3, 0, "Código del agente" ,                                    "'@!'",               "", "( cDbf )"} )
   aAdd( aItmAlbCli, { "CCODOBR"   ,"C", 10, 0, "Código de obra" ,                                       "'@!'",               "", "( cDbf )"} )
   aAdd( aItmAlbCli, { "CCODTAR"   ,"C",  5, 0, "Código de tarifa" ,                                     "'@!'",               "", "( cDbf )"} )
   aAdd( aItmAlbCli, { "CCODRUT"   ,"C",  4, 0, "Código de ruta" ,                                       "'@!'",               "", "( cDbf )"} )
   aAdd( aItmAlbCli, { "CNUMPED"   ,"C", 12, 0, "Número del pedido" ,                                    "",                   "", "( cDbf )"} )
   aAdd( aItmAlbCli, { "cNumPre"   ,"C", 12, 0, "Número del presupuesto" ,                               "",                   "", "( cDbf )"} )
   aAdd( aItmAlbCli, { "cNumSat"   ,"C", 12, 0, "Número del SAT" ,                                       "",                   "", "( cDbf )" } )
   aAdd( aItmAlbCli, { "NTIPOALB"  ,"N",  1, 0, "Tipo de albarán" ,                                      "",                   "", "( cDbf )"} )
   aAdd( aItmAlbCli, { "CNUMFAC"   ,"C", 12, 0, "Número del documento facturado" ,                       "",                   "", "( cDbf )"} )
   aAdd( aItmAlbCli, { "LMAYOR"    ,"L",  1, 0, "" ,                                                     "",                   "", "( cDbf )"} )
   aAdd( aItmAlbCli, { "NTARIFA"   ,"N",  1, 0, "Tarifa de precio aplicada" ,                            "",                   "", "( cDbf )"} )
   aAdd( aItmAlbCli, { "CDTOESP"   ,"C", 50, 0, "Descripción porcentaje de descuento",                   "",                   "", "( cDbf )"} )
   aAdd( aItmAlbCli, { "NDTOESP"   ,"N",  6, 2, "Porcentaje de descuento",                               "'@EZ 999.99'",       "", "( cDbf )"} )
   aAdd( aItmAlbCli, { "CDPP"      ,"C", 50, 0, "Descripción pct. de dto. por pronto pago",              "",                   "", "( cDbf )"} )
   aAdd( aItmAlbCli, { "NDPP"      ,"N",  6, 2, "Porcentaje de dto. por pronto pago",                    "'@EZ 999.99'",       "", "( cDbf )"} )
   aAdd( aItmAlbCli, { "CDTOUNO"   ,"C", 25, 0, "Descripción del primer descuento personalizado",        "",                   "", "( cDbf )"} )
   aAdd( aItmAlbCli, { "NDTOUNO"   ,"N",  4, 1, "Porcentaje del primer descuento pers.",                 "'@EZ 999.99'",       "", "( cDbf )"} )
   aAdd( aItmAlbCli, { "CDTODOS"   ,"C", 25, 0, "Descripción del segundo descuento pers.",               "",                   "", "( cDbf )"} )
   aAdd( aItmAlbCli, { "NDTODOS"   ,"N",  4, 1, "Descripción del segundo descuento pers.",               "'@EZ 999.99'",       "", "( cDbf )"} )
   aAdd( aItmAlbCli, { "NDTOCNT"   ,"N",  6, 2, "Pct. de dto. por pago contado",                         "'@EZ 999.99'",       "", "( cDbf )"} )
   aAdd( aItmAlbCli, { "NDTORAP"   ,"N",  6, 2, "Pct. de dto. por rappel",                               "'@EZ 999.99'",       "", "( cDbf )"} )
   aAdd( aItmAlbCli, { "NDTOPUB"   ,"N",  6, 2, "Pct. de dto. por publicidad",                           "'@EZ 999.99'",       "", "( cDbf )"} )
   aAdd( aItmAlbCli, { "NDTOPGO"   ,"N",  6, 2, "Pct. de dto. por pago centralizado",                    "'@EZ 999.99'",       "", "( cDbf )"} )
   aAdd( aItmAlbCli, { "NDTOPTF"   ,"N",  7, 2, ""                                 ,                     "",                   "", "( cDbf )"} )
   aAdd( aItmAlbCli, { "LRECARGO"  ,"L",  1, 0, "Lógico recargo de equivalencia",                        "",                   "", "( cDbf )"} )
   aAdd( aItmAlbCli, { "NPCTCOMAGE","N",  6, 2, "Pct. de comisión del agente",                           "",                   "", "( cDbf )"} )
   aAdd( aItmAlbCli, { "LSNDDOC"   ,"L",  1, 0, "Lógico de documento a enviar",                          "",                   "", "( cDbf )"} )
   aAdd( aItmAlbCli, { "CDIVALB"   ,"C",  3, 0, "Código de divisa",                                      "",                   "", "( cDbf )"} )
   aAdd( aItmAlbCli, { "NVDVALB"   ,"N", 10, 4, "Valor del cambio de la divisa",                         "'@EZ 999,999.9999'", "", "( cDbf )"} )
   aAdd( aItmAlbCli, { "CRETPOR"   ,"C",100, 0, "Retirado por" ,                                         "",                   "", "( cDbf )"} )
   aAdd( aItmAlbCli, { "CRETMAT"   ,"C", 20, 0, "Matrícula" ,                                            "",                   "", "( cDbf )"} )
   aAdd( aItmAlbCli, { "CNUMDOC"   ,"C", 12, 0, "",                                                      "",                   "", "( cDbf )"} )
   aAdd( aItmAlbCli, { "CSUPED"    ,"C", 50, 0, "Su pedido",                                             "",                   "", "( cDbf )"} )
   aAdd( aItmAlbCli, { "LIVAINC"   ,"L",  1, 0, cImp() + " incluido",                                          "",                   "", "( cDbf )"} )
   aAdd( aItmAlbCli, { "NREGIVA"   ,"N",  1, 0, "Regimen de " + cImp(),                                     "",                   "", "( cDbf )"} )
   aAdd( aItmAlbCli, { "LGENLQD"   ,"L",  1, 0, "Generado por liquidación",                              "",                   "", "( cDbf )"} )
   aAdd( aItmAlbCli, { "NNUMORD"   ,"N",  9, 0, "Número de la orden de carga" ,                          "'999999999'",        "", "( cDbf )"} )
   aAdd( aItmAlbCli, { "CSUFORD"   ,"C",  2, 0, "Sufijo de la orden de carga" ,                          "",                   "", "( cDbf )"} )
   aAdd( aItmAlbCli, { "DFECORD"   ,"D",  8, 0, "Fecha de la orden de carga" ,                           "",                   "", "( cDbf )"} )
   aAdd( aItmAlbCli, { "NIVAMAN"   ,"N",  6, 2, "Porcentaje de " + cImp() + " del gasto" ,                       "'@EZ 999,99'",       "", "( cDbf )"} )
   aAdd( aItmAlbCli, { "NMANOBR"   ,"N", 16, 6, "Gastos" ,                                               "cPorDivAlb",         "", "( cDbf )"} )
   aAdd( aItmAlbCli, { "cCodTrn"   ,"C",  9, 0, "Código del transportista" ,                             "",                   "", "( cDbf )"} )
   aAdd( aItmAlbCli, { "nKgsTrn"   ,"N", 16, 6, "TARA del transportista" ,                               "",                   "", "( cDbf )"} )
   aAdd( aItmAlbCli, { "lCloAlb"   ,"L",  1, 0, "" ,                                                     "",                   "", "( cDbf )"} )
   aAdd( aItmAlbCli, { "cCodUsr"   ,"C",  3, 0, "Código de usuario",                                     "",                   "", "( cDbf )"} )
   aAdd( aItmAlbCli, { "dFecCre"   ,"D",  8, 0, "Fecha de creación/modificación del documento",          "",                   "", "( cDbf )"} )
   aAdd( aItmAlbCli, { "cTimCre"   ,"C",  5, 0, "Hora de creación/modificación del documento",           "",                   "", "( cDbf )"} )
   aAdd( aItmAlbCli, { "dFecEnv"   ,"D",  8, 0, "Fecha de envio",                                        "",                   "", "( cDbf )"} )
   aAdd( aItmAlbCli, { "cCodGrp"   ,"C",  4, 0, "Código de grupo de cliente" ,                           "",                   "", "( cDbf )"} )
   aAdd( aItmAlbCli, { "lImprimido","L",  1, 0, "Lógico de imprimido" ,                                  "",                   "", "( cDbf )"} )
   aAdd( aItmAlbCli, { "dFecImp"   ,"D",  8, 0, "Última fecha de impresión" ,                            "",                   "", "( cDbf )"} )
   aAdd( aItmAlbCli, { "cHorImp"   ,"C",  5, 0, "Hora de la última impresión" ,                          "",                   "", "( cDbf )"} )
   aAdd( aItmAlbCli, { "cCodDlg"   ,"C",  2, 0, "Código delegación" ,                                    "",                   "", "( cDbf )"} )
   aAdd( aItmAlbCli, { "nDtoAtp"   ,"N",  6, 2, "Porcentaje de descuento atípico",                       "",                   "", "( cDbf )"} )
   aAdd( aItmAlbCli, { "nSbrAtp"   ,"N",  1, 0, "Lugar donde aplicar dto atípico",                       "",                   "", "( cDbf )"} )
   aAdd( aItmAlbCli, { "nMontaje"  ,"N",  6, 2, "Horas de montaje",                                      "'@EZ 999,99'",       "", "( cDbf )"} )
   aAdd( aItmAlbCli, { "dFecEntr",  "D",  8, 0, "Fecha de entrada de alquiler",                          "",                   "", "( cDbf )"} )
   aAdd( aItmAlbCli, { "dFecSal",   "D",  8, 0, "Fecha de salida de alquiler",                           "",                   "", "( cDbf )"} )
   aAdd( aItmAlbCli, { "lAlquiler", "L",  1, 0, "Lógico de alquiler",                                    "",                   "", "( cDbf )"} )
   aAdd( aItmAlbCli, { "cManObr",   "C",250, 0, "" ,                                                     "",                   "", "( cDbf )"} )
   aAdd( aItmAlbCli, { "lOrdCar",   "L",  1, 0, "Lógico de pertenecer a un orden de carga" ,             "",                   "", "( cDbf )"} )
   aAdd( aItmAlbCli, { "CNUMTIK",   "C", 13, 0, "Número del ticket" ,                                    "",                   "", "( cDbf )"} )
   aAdd( aItmAlbCli, { "CTLFCLI",   "C", 20, 0, "Teléfono del cliente" ,                                 "",                   "", "( cDbf )"} )
   aAdd( aItmAlbCli, { "nTotNet",   "N", 16, 6, "Total neto" ,                                           "",                   "", "( cDbf )"} )
   aAdd( aItmAlbCli, { "nTotIva",   "N", 16, 6, "Total " + cImp() ,                                      "",                   "", "( cDbf )"} )
   aAdd( aItmAlbCli, { "nTotReq",   "N", 16, 6, "Total recargo" ,                                        "",                   "", "( cDbf )"} )
   aAdd( aItmAlbCli, { "nTotAlb",   "N", 16, 6, "Total albarán" ,                                        "",                   "", "( cDbf )"} )
   aAdd( aItmAlbCli, { "nTotPag",   "N", 16, 6, "Total anticipado" ,                                     "",                   "", "( cDbf )"} )
   aAdd( aItmAlbCli, { "lOperPV",   "L",  1, 0, "Lógico para operar con punto verde" ,                   "",                   "", "( cDbf )"} )
   aAdd( aItmAlbCli, { "cBanco"   , "C", 50, 0, "Nombre del banco del cliente",                          "",                   "", "( cDbf )", nil } )
   aAdd( aItmAlbCli, { "cEntBnc"  , "C",  4, 0, "Entidad de la cuenta bancaria del cliente",             "",                   "", "( cDbf )", nil } )
   aAdd( aItmAlbCli, { "cSucBnc"  , "C",  4, 0, "Sucursal de la cuenta bancaria del cliente",            "",                   "", "( cDbf )", nil } )
   aAdd( aItmAlbCli, { "cDigBnc"  , "C",  2, 0, "Dígito de control de la cuenta bancaria del cliente",   "",                   "", "( cDbf )", nil } )
   aAdd( aItmAlbCli, { "cCtaBnc"  , "C", 10, 0, "Cuenta bancaria del cliente",                           "",                   "", "( cDbf )", nil } )

Return ( aItmAlbCli )

//---------------------------------------------------------------------------//

FUNCTION nTotAlbCli( cAlbaran, cAlbCliT, cAlbCliL, cIva, cDiv, aTmp, cDivRet, lPic, lExcCnt, lNeto )

   local nRecno
	local bCondition
   local dFecAlb
   local lRecargo
   local nDtoUno
   local nDtoDos
   local nDtoEsp
	local nDtoPP
	local nDtoCnt
	local nDtoRap
	local nDtoPub
	local nDtoPgo
	local nDtoPtf
	local cCodDiv
	local cCodPgo
   local lIvaInc
   local nDtoAtp
   local nSbrAtp
   local nKgsTrn
   local nIvaMan
   local nManObr           := 0
   local nTotalArt         := 0
   local nTotalUnd         := 0
   local nTotalLin         := 0
   local nTotalTrn         := 0
   local nTotalPnt         := 0
   local nTotalIvm         := 0
   local nImpIva           := { 0, 0, 0 }
   local nImpReq           := { 0, 0, 0 }
   local aTotalDto         := { 0, 0, 0 }
   local aTotalDPP         := { 0, 0, 0 }
   local aTotalUno         := { 0, 0, 0 }
   local aTotalDos         := { 0, 0, 0 }
   local aTotalAtp         := { 0, 0, 0 }
   local nDescuentosLineas := 0
   local lOperarPntVer     := .f.

   DEFAULT cAlbCliT        := dbfAlbCliT
   DEFAULT cAlbCliL        := dbfAlbCliL
   DEFAULT cAlbaran        := ( cAlbCliT )->cSerAlb + Str( ( cAlbCliT )->nNumAlb ) + ( cAlbCliT )->cSufAlb
   DEFAULT cIva            := dbfIva
   DEFAULT cDiv            := dbfDiv
   DEFAULT lPic            := .f.
   DEFAULT lNeto           := .f.

   if Empty( Select( cAlbCliT ) )
      Return ( 0 )
   end if

   if Empty( Select( cAlbCliL ) )
      Return ( 0 )
   end if

   if Empty( Select( cIva ) )
      Return ( 0 )
   end if

   if Empty( Select( cDiv ) )
      Return ( 0 )
   end if

   public nTotBrt    := 0
   public nTotAlb    := 0
   public nTotDto    := 0
   public nTotDPP    := 0
   public nTotNet    := 0
   public nTotIva    := 0
   public nTotIvm    := 0
   public nTotAge    := 0
   public nTotReq    := 0
   public nTotPnt    := 0
   public nTotUno    := 0
   public nTotDos    := 0
   public nTotCos    := 0
   public nTotPes    := 0
   public nTotDif    := 0
   public nTotAtp    := 0
   public nTotTrn    := 0
   public nPctRnt    := 0
   public nTotRnt    := 0
   public cCtaCli    := cClientCuenta( ( cAlbCliT )->cCodCli )

   public aTotIva    := { { 0,0,nil,0,0,0,0,0,0 }, { 0,0,nil,0,0,0,0,0,0 }, { 0,0,nil,0,0,0,0,0,0 } }
   public aIvaUno    := aTotIva[ 1 ]
   public aIvaDos    := aTotIva[ 2 ]
   public aIvaTre    := aTotIva[ 3 ]

   public aTotIvm    := { { 0,nil,0 }, { 0,nil,0 }, { 0,nil,0 }, }
   public aIvmUno    := aTotIvm[ 1 ]
   public aIvmDos    := aTotIvm[ 2 ]
   public aIvmTre    := aTotIvm[ 3 ]


   public nTotalDto  := 0

   public nTotArt    := 0
   public nTotCaj    := 0

   nImpIva           := { 0,0,0 }
   nImpReq           := { 0,0,0 }

   nRecno            := ( cAlbCliL )->( recno() )

   if aTmp != nil
      nDtoUno        := aTmp[ _NDTOUNO ]
      nDtoDos        := aTmp[ _NDTODOS ]
      dFecAlb        := aTmp[ _DFECALB ]
		nDtoEsp			:= aTmp[ _NDTOESP ]
      nDtoPP         := aTmp[ _NDPP    ]
		nDtoCnt			:= aTmp[ _NDTOCNT ]
		nDtoRap     	:= aTmp[ _NDTORAP ]
		nDtoPub     	:= aTmp[ _NDTOPUB ]
		nDtoPgo     	:= aTmp[ _NDTOPGO ]
		nDtoPtf			:= aTmp[ _NDTOPTF ]
      lRecargo       := aTmp[ _LRECARGO]
      nIvaMan        := aTmp[ _NIVAMAN ]
      nManObr        := aTmp[ _NMANOBR ]
      cCodDiv        := aTmp[ _CDIVALB ]
      nVdvDiv        := aTmp[ _NVDVALB ]
		cCodPgo			:= aTmp[ _CCODPAGO]
      lIvaInc        := aTmp[ _LIVAINC ]
      nDtoAtp        := aTmp[ _NDTOATP ]
      nSbrAtp        := aTmp[ _NSBRATP ]
      nKgsTrn        := aTmp[ _NKGSTRN ]
      lOperarPntVer  := aTmp[ _LOPERPV ]
      bCondition     := {|| ( cAlbCliL )->( !eof() ) }
      ( cAlbCliL )->( dbGoTop() )
   else
      nDtoUno        := ( cAlbCliT )->nDtoUno
      nDtoDos        := ( cAlbCliT )->nDtoDos
      dFecAlb        := ( cAlbCliT )->dFecAlb
      nDtoEsp        := ( cAlbCliT )->nDtoEsp
      nDtoPP         := ( cAlbCliT )->nDpp
      nDtoCnt        := ( cAlbCliT )->nDtoCnt
      nDtoRap        := ( cAlbCliT )->nDtoRap
      nDtoPub        := ( cAlbCliT )->nDtoPub
      nDtoPgo        := ( cAlbCliT )->nDtoPgo
      nDtoPtf        := ( cAlbCliT )->nDtoPtf
      lRecargo       := ( cAlbCliT )->lRecargo
      nIvaMan        := ( cAlbCliT )->nIvaMan
      nManObr        := ( cAlbCliT )->nManObr
      cCodDiv        := ( cAlbCliT )->cDivAlb
      nVdvDiv        := ( cAlbCliT )->nVdvAlb
      cCodPgo        := ( cAlbCliT )->cCodPago
      lIvaInc        := ( cAlbCliT )->lIvaInc
      nDtoAtp        := ( cAlbCliT )->nDtoAtp
      nSbrAtp        := ( cAlbCliT )->nSbrAtp
      nKgsTrn        := ( cAlbCliT )->nKgsTrn
      lOperarPntVer  := ( cAlbCliT )->lOperPV
      bCondition     := {|| ( cAlbCliL )->cSerAlb + Str( ( cAlbCliL )->nNumAlb ) + ( cAlbCliL )->cSufAlb == cAlbaran .and. ( cAlbCliL )->( !eof() ) }
      ( cAlbCliL )->( dbSeek( cAlbaran ) )
   endif

    /*
	Cargamos los pictures dependiendo de la moneda
   */

   cPorDiv           := cPorDiv( cCodDiv, cDiv )
   cPouDiv           := cPouDiv( cCodDiv, cDiv )
   nDouDiv           := nDouDiv( cCodDiv, cDiv )
   nRouDiv           := nRouDiv( cCodDiv, cDiv )
   nDpvDiv           := nDpvDiv( cCodDiv, cDiv )

   while Eval( bCondition )

      if lValLine( cAlbCliL )

         if ( lExcCnt == nil                                .or.;    // Entran todos
            ( lExcCnt .and. ( cAlbCliL )->nCtlStk != 2 )    .or.;    // Articulos sin contadores
            ( !lExcCnt .and. ( cAlbCliL )->nCtlStk == 2 ) )          // Articulos con contadores

            if ( cAlbCliL )->lTotLin

               // Esto es para evitar escirbir en el fichero muchas veces

               if ( cAlbCliL )->nPreUnit != nTotalLin .or. ( cAlbCliL )->nUniCaja != nTotalUnd

                  if dbLock( cAlbCliL )
                     ( cAlbCliL )->nPreUnit := nTotalLin
                     ( cAlbCliL )->nUniCaja := nTotalUnd
                     ( cAlbCliL )->( dbUnLock() )
                  end if

               end if

               // Limpien

               nTotalLin         := 0
               nTotalUnd         := 0

            else

               nTotalArt         := nTotLAlbCli( cAlbCliL, nDouDiv, nRouDiv, nil, .t., .f., .f. )
               nTotalTrn         := nTrnLAlbCli( cAlbCliL, nDouDiv )
               nTotalPnt         := if( lOperarPntVer, nPntLAlbCli( cAlbCliL, nDpvDiv ), 0 )
               nTotalIvm         := nTotIAlbCli( cAlbCliL, nDouDiv, nRouDiv )
               nTotCos           += nCosLAlbCli( cAlbCliL, nDouDiv, nDorDiv )
               nTotPes           += nPesLAlbCli( cAlbCliL )
               nDescuentosLineas += nTotDtoLAlbCli( cAlbCliL, nDouDiv )

               if aTmp != nil
                  nTotAge        += nComLAlbCli( aTmp, cAlbCliL, nDouDiv, nRouDiv )
               else
                  nTotAge        += nComLAlbCli( cAlbCliT, cAlbCliL, nDouDiv, nRouDiv )
               end if

               // Acumuladores para las lineas de totales----------------------

               nTotalLin         += nTotalArt
               nTotalUnd         += nTotNAlbCli( cAlbCliL )

               nTotArt           += nTotNAlbCli( cAlbCliL )
               nTotCaj           += ( cAlbCliL )->nCanEnt

               // Estudio de IGIC-----------------------------------------------

               if nTotalArt + nTotalIvm + nTotalTrn + nTotalPnt != 0

                  do case
                     case _NPCTIVA1 == nil .OR. _NPCTIVA1 == ( cAlbCliL )->nIva

                        _NPCTIVA1   := ( cAlbCliL )->nIva
                        _NPCTREQ1   := ( cAlbCliL )->nReq
                        _NBRTIVA1   += nTotalArt
                        _NIVMIVA1   += nTotalIvm
                        _NTRNIVA1   += nTotalTrn
                        _NPNTVER1   += nTotalPnt

                     case _NPCTIVA2 == nil .OR. _NPCTIVA2 == ( cAlbCliL )->nIva

                        _NPCTIVA2   := (cAlbCliL)->nIva
                        _NPCTREQ2   := (cAlbCliL)->nReq
                        _NBRTIVA2   += nTotalArt
                        _NIVMIVA2   += nTotalIvm
                        _NTRNIVA2   += nTotalTrn
                        _NPNTVER3   += nTotalPnt

                     case _NPCTIVA3 == nil .OR. _NPCTIVA3 == ( cAlbCliL )->nIva

                        _NPCTIVA3   := ( cAlbCliL )->nIva
                        _NPCTREQ3   := ( cAlbCliL )->nReq
                        _NBRTIVA3   += nTotalArt
                        _NIVMIVA3   += nTotalIvm
                        _NTRNIVA3   += nTotalTrn
                        _NPNTVER3   += nTotalPnt

                  end case

                  //Estudio de los impuestos especiales------------------------

                  if ( cAlbCliL )->nValImp != 0

                     do case
                        case aTotIvm[ 1, 2 ] == nil .or. aTotIvm[ 1, 2 ] == ( cAlbCliL )->nValImp
                           aTotIvm[ 1, 1 ]      += nTotNAlbCli( cAlbCliL ) * if( ( cAlbCliL )->lVolImp, NotCero( ( cAlbCliL )->nVolumen ), 1 )
                           aTotIvm[ 1, 2 ]      := ( cAlbCliL )->nValImp
                           aTotIvm[ 1, 3 ]      := aTotIvm[ 1, 1 ] * aTotIvm[ 1, 2 ]

                        case aTotIvm[ 2, 2 ] == nil .or. aTotIvm[ 2, 2 ] == ( cAlbCliL )->nValImp
                           aTotIvm[ 2, 1 ]      += nTotNAlbCli( cAlbCliL ) * if( ( cAlbCliL )->lVolImp, NotCero( ( cAlbCliL )->nVolumen ), 1 )
                           aTotIvm[ 2, 2 ]      := ( cAlbCliL )->nValImp
                           aTotIvm[ 2, 3 ]      := aTotIvm[ 2, 1 ] * aTotIvm[ 2, 2 ]

                        case aTotIvm[ 3, 2 ] == nil .or. aTotIvm[ 3, 2 ] == ( cAlbCliL )->nValImp
                           aTotIvm[ 3, 1 ]      += nTotNAlbCli( cAlbCliL ) * if( ( cAlbCliL )->lVolImp, NotCero( ( cAlbCliL )->nVolumen ), 1 )
                           aTotIvm[ 3, 2 ]      := ( cAlbCliL )->nValImp
                           aTotIvm[ 3, 3 ]      := aTotIvm[ 3, 1 ] * aTotIvm[ 3, 2 ]

                     end case

                  end if

               end if

            end if

         else

           // Limpien tambien si tenemos una linea de control

            nTotalLin   := 0
            nTotalUnd   := 0

         end if

      end if

      ( cAlbCliL )->( dbSkip() )

   end while

   ( cAlbCliL )->( dbGoto( nRecno ) )

   // Ordenamos los IGICS de menor a mayor

   aTotIva           := aSort( aTotIva,,, {|x,y| if( x[3] != nil, x[3], -1 ) > if( y[3] != nil, y[3], -1 )  } )

   _NBASIVA1         := Round( _NBRTIVA1, nRouDiv )
   _NBASIVA2         := Round( _NBRTIVA2, nRouDiv )
   _NBASIVA3         := Round( _NBRTIVA3, nRouDiv )

   nTotBrt           := _NBRTIVA1 + _NBRTIVA2 + _NBRTIVA3

   // Descuentos atipicos sobre base

   if nSbrAtp <= 1 .and. nDtoAtp != 0

      aTotalAtp[1]   := Round( _NBASIVA1 * nDtoAtp / 100, nRouDiv )
      aTotalAtp[2]   := Round( _NBASIVA2 * nDtoAtp / 100, nRouDiv )
      aTotalAtp[3]   := Round( _NBASIVA3 * nDtoAtp / 100, nRouDiv )

      nTotAtp        := aTotalAtp[ 1 ] + aTotalAtp[ 2 ] + aTotalAtp[ 3 ]

   end if

   // Descuentos Especiales

   if nDtoEsp  != 0

      aTotalDto[1]   := Round( _NBASIVA1 * nDtoEsp / 100, nRouDiv )
      aTotalDto[2]   := Round( _NBASIVA2 * nDtoEsp / 100, nRouDiv )
      aTotalDto[3]   := Round( _NBASIVA3 * nDtoEsp / 100, nRouDiv )

      nTotDto        := aTotalDto[1] + aTotalDto[2] + aTotalDto[3]

		_NBASIVA1		-= aTotalDto[1]
		_NBASIVA2		-= aTotalDto[2]
		_NBASIVA3		-= aTotalDto[3]

   end if

   // Descuentos atipicos sobre Descuentos especiales


   if nSbrAtp == 2 .and. nDtoAtp != 0

      aTotalAtp[1]   := Round( _NBASIVA1 * nDtoAtp / 100, nRouDiv )
      aTotalAtp[2]   := Round( _NBASIVA2 * nDtoAtp / 100, nRouDiv )
      aTotalAtp[3]   := Round( _NBASIVA3 * nDtoAtp / 100, nRouDiv )

      nTotAtp        := aTotalAtp[ 1 ] + aTotalAtp[ 2 ] + aTotalAtp[ 3 ]

   end if

   // Descuentos por Pronto Pago estos son los buenos

	IF nDtoPP	!= 0

      aTotalDPP[1]   := Round( _NBASIVA1 * nDtoPP / 100, nRouDiv )
      aTotalDPP[2]   := Round( _NBASIVA2 * nDtoPP / 100, nRouDiv )
      aTotalDPP[3]   := Round( _NBASIVA3 * nDtoPP / 100, nRouDiv )

      nTotDPP        := aTotalDPP[1] + aTotalDPP[2] + aTotalDPP[3]

		_NBASIVA1		-= aTotalDPP[1]
		_NBASIVA2		-= aTotalDPP[2]
		_NBASIVA3		-= aTotalDPP[3]

	END IF

   // Descuentos atipicos sobre Descuento Pronto Pago

   if nSbrAtp == 3 .and. nDtoAtp != 0

      aTotalAtp[1]   := Round( _NBASIVA1 * nDtoAtp / 100, nRouDiv )
      aTotalAtp[2]   := Round( _NBASIVA2 * nDtoAtp / 100, nRouDiv )
      aTotalAtp[3]   := Round( _NBASIVA3 * nDtoAtp / 100, nRouDiv )

      nTotAtp        := aTotalAtp[ 1 ] + aTotalAtp[ 2 ] + aTotalAtp[ 3 ]

   end if

	IF nDtoUno != 0

      aTotalUno[1]   := Round( _NBASIVA1 * nDtoUno / 100, nRouDiv )
      aTotalUno[2]   := Round( _NBASIVA2 * nDtoUno / 100, nRouDiv )
      aTotalUno[3]   := Round( _NBASIVA3 * nDtoUno / 100, nRouDiv )

      nTotUno        := aTotalUno[1] + aTotalUno[2] + aTotalUno[3]

		_NBASIVA1		-= aTotalUno[1]
		_NBASIVA2		-= aTotalUno[2]
		_NBASIVA3		-= aTotalUno[3]

	END IF

   // Descuentos atipicos sobre Descuento definido 1

   if nSbrAtp == 4 .and. nDtoAtp != 0

      aTotalAtp[1]   := Round( _NBASIVA1 * nDtoAtp / 100, nRouDiv )
      aTotalAtp[2]   := Round( _NBASIVA2 * nDtoAtp / 100, nRouDiv )
      aTotalAtp[3]   := Round( _NBASIVA3 * nDtoAtp / 100, nRouDiv )

      nTotAtp        := aTotalAtp[ 1 ] + aTotalAtp[ 2 ] + aTotalAtp[ 3 ]

   end if

	IF nDtoDos != 0

      aTotalDos[1]   := Round( _NBASIVA1 * nDtoDos / 100, nRouDiv )
      aTotalDos[2]   := Round( _NBASIVA2 * nDtoDos / 100, nRouDiv )
      aTotalDos[3]   := Round( _NBASIVA3 * nDtoDos / 100, nRouDiv )

      nTotDos        := aTotalDos[1] + aTotalDos[2] + aTotalDos[3]

		_NBASIVA1		-= aTotalDos[1]
		_NBASIVA2		-= aTotalDos[2]
		_NBASIVA3		-= aTotalDos[3]

	END IF

   // Descuentos atipicos sobre Descuento definido 2

   if nSbrAtp == 5 .and. nDtoAtp != 0

      aTotalAtp[1]   := Round( _NBASIVA1 * nDtoAtp / 100, nRouDiv )
      aTotalAtp[2]   := Round( _NBASIVA2 * nDtoAtp / 100, nRouDiv )
      aTotalAtp[3]   := Round( _NBASIVA3 * nDtoAtp / 100, nRouDiv )

      nTotAtp        := aTotalAtp[ 1 ] + aTotalAtp[ 2 ] + aTotalAtp[ 3 ]

   end if

   /*
   Estudio de IGIC para el Gasto despues de los descuentos----------------------
   */

   if nManObr != 0

      do case
      case _NPCTIVA1 == nil .or. _NPCTIVA1 == nIvaMan

         _NPCTIVA1   := nIvaMan
         _NBASIVA1   += nManObr

      case _NPCTIVA2 == nil .or. _NPCTIVA2 == nIvaMan

         _NPCTIVA2   := nIvaMan
         _NBASIVA2   += nManObr

      case _NPCTIVA3 == nil .or. _NPCTIVA3 == nIvaMan

         _NPCTIVA3   := nIvaMan
         _NBASIVA3   += nManObr

      end case

   end if

   // Una vez echos los descuentos le sumamos los transportes------------------

   _NBASIVA1         += _NTRNIVA1
   _NBASIVA2         += _NTRNIVA2
   _NBASIVA3         += _NTRNIVA3

   // Una vez echos los descuentos le sumamos el punto verde-------------------

   _NBASIVA1         += _NPNTVER1
   _NBASIVA2         += _NPNTVER2
   _NBASIVA3         += _NPNTVER3

   /*
   Una vez echos los descuentos le sumamos el IVMH-----------------------------
	*/

   if uFieldEmpresa( "lIvaImpEsp" )
      _NBASIVA1      += _NIVMIVA1
      _NBASIVA2      += _NIVMIVA2
      _NBASIVA3      += _NIVMIVA3
   end if

   // Calculamos los IGICS-----------------------------------------------------

   if !lIvaInc

      //Calculos de IGIC

      _NIMPIVA1      := if ( _NPCTIVA1 != NIL, Round( _NBASIVA1 * _NPCTIVA1 / 100, nRouDiv ), 0 )
      _NIMPIVA2      := if ( _NPCTIVA2 != NIL, Round( _NBASIVA2 * _NPCTIVA2 / 100, nRouDiv ), 0 )
      _NIMPIVA3      := if ( _NPCTIVA3 != NIL, Round( _NBASIVA3 * _NPCTIVA3 / 100, nRouDiv ), 0 )

      //Calculo de recargo

      if lRecargo
         _NIMSATQ1   := if ( _NPCTIVA1 != NIL, Round( _NBASIVA1 * _NPCTREQ1 / 100, nRouDiv ), 0 )
         _NIMSATQ2   := if ( _NPCTIVA2 != NIL, Round( _NBASIVA2 * _NPCTREQ2 / 100, nRouDiv ), 0 )
         _NIMSATQ3   := if ( _NPCTIVA3 != NIL, Round( _NBASIVA3 * _NPCTREQ3 / 100, nRouDiv ), 0 )
      end if

   else

      if _NPCTIVA1 != 0
         _NIMPIVA1   := if( _NPCTIVA1 != nil, Round( _NBASIVA1 / ( 100 / _NPCTIVA1 + 1 ), nRouDiv ), 0 )
      end if

      if _NPCTIVA2 != 0
         _NIMPIVA2   := if( _NPCTIVA2 != nil, Round( _NBASIVA2 / ( 100 / _NPCTIVA2 + 1 ), nRouDiv ), 0 )
      end if

      if _NPCTIVA3 != 0
         _NIMPIVA3   := if( _NPCTIVA3 != nil, Round( _NBASIVA3 / ( 100 / _NPCTIVA3 + 1 ), nRouDiv ), 0 )
      end if

      if lRecargo
         if _NPCTREQ1 != 0
            _NIMSATQ1   := if( _NPCTIVA1 != NIL, Round( _NBASIVA1 / ( 100 / _NPCTREQ1 + 1 ), nRouDiv ), 0 )
         end if
         if _NPCTREQ2 != 0
            _NIMSATQ2   := if( _NPCTIVA2 != NIL, Round( _NBASIVA2 / ( 100 / _NPCTREQ2 + 1 ), nRouDiv ), 0 )
         end if
         if _NPCTREQ3 != 0
            _NIMSATQ3   := if( _NPCTIVA3 != NIL, Round( _NBASIVA3 / ( 100 / _NPCTREQ3 + 1 ), nRouDiv ), 0 )
         end if
      end if

      _NBASIVA1      -= _NIMPIVA1
      _NBASIVA2      -= _NIMPIVA2
      _NBASIVA3      -= _NIMPIVA3

      _NBASIVA1      -= _NIMSATQ1
      _NBASIVA2      -= _NIMSATQ2
      _NBASIVA3      -= _NIMSATQ3

   end if

   //Neto del Albaran

   nTotNet           := Round( _NBASIVA1 + _NBASIVA2 + _NBASIVA3, nRouDiv )

   // Total IVMH

   nTotIvm           := Round( aTotIvm[ 1, 3 ] + aTotIvm[ 2, 3 ] + aTotIvm[ 3, 3 ], nRouDiv )

   //Total Transpote

   nTotTrn           := Round( _NTRNIVA1 + _NTRNIVA2 + _NTRNIVA3, nRouDiv )

   //Total punto verde

   nTotPnt           := Round( _NPNTVER1 + _NPNTVER2 + _NPNTVER3, nRouDiv )

   //Total de IGIC

   nTotIva           := Round( _NIMPIVA1 + _NIMPIVA2 + _NIMPIVA3, nRouDiv )

   //Total de R.E.

   nTotReq           := Round( _NIMSATQ1 + _NIMSATQ2 + _NIMSATQ3, nRouDiv )

   //Total de impuestos

   nTotImp           := nTotIva + nTotReq // + nTotIvm

   /*
   Total rentabilidad----------------------------------------------------------
   */

   nTotRnt           := Round(         nTotNet - nManObr - nTotAge - nTotPnt - nTotAtp - nTotCos, nRouDiv )

   nPctRnt           := nRentabilidad( nTotNet - nManObr - nTotAge - nTotPnt,  nTotAtp,  nTotCos )

   // Diferencias de pesos

   if nKgsTrn != 0
      nTotDif        := nKgsTrn - nTotPes
   else
      nTotDif        := 0
   end if

   // Total facturas-----------------------------------------------------------

   nTotAlb           := nTotNet + nTotImp

   if nTotNet == 0
      nPctRnt        := 0
   end if

   /*
   Total de descuentos del albaran---------------------------------------------
   */

   nTotalDto         := nDescuentosLineas + nTotDto + nTotDpp + nTotUno + nTotDos + nTotAtp

   // Solicitan una divisa distinta a la q se hizo originalmente la factura

   if cDivRet != nil .and. cDivRet != cCodDiv
      nTotNet        := nCnv2Div( nTotNet, cCodDiv, cDivRet, cDiv )
      nTotIvm        := nCnv2Div( nTotIvm, cCodDiv, cDivRet, cDiv )
      nTotIva        := nCnv2Div( nTotIva, cCodDiv, cDivRet, cDiv )
      nTotReq        := nCnv2Div( nTotReq, cCodDiv, cDivRet, cDiv )
      nTotAlb        := nCnv2Div( nTotAlb, cCodDiv, cDivRet, cDiv )
      nTotPnt        := nCnv2Div( nTotPnt, cCodDiv, cDivRet, cDiv )
      nTotTrn        := nCnv2Div( nTotTrn, cCodDiv, cDivRet, cDiv )
      cPorDiv        := cPorDiv( cDivRet, cDiv )
   end if

RETURN ( if( lPic, Trans( if( lNeto, nTotNet, nTotAlb ), cPorDiv ), if( lNeto, nTotNet, nTotAlb ) ) )

//--------------------------------------------------------------------------//

/*
Devuelve la comisi¢n de un agente en una linea de detalle
*/

FUNCTION nComLAlbCli( dbfAlbCliT, dbfAlbCliL, nDecOut, nDerOut )

   local nImp  := nImpLAlbCli( dbfAlbCliT, dbfAlbCliL, nDecOut, nDerOut, , .f., .t., .f., .f. )

RETURN ( Round( ( nImp * ( dbfAlbCliL )->nComAge / 100 ), nDerOut ) )

//---------------------------------------------------------------------------//

FUNCTION nImpUAlbCli( uAlbCliT, uAlbCliL, nDec, nVdv, lIva, cPouDiv )

   local nIva
   local lIvaInc
   local nCalculo

   DEFAULT nDec      := 0
   DEFAULT nVdv      := 1
   DEFAULT lIva      := .f.

   nCalculo          := nTotUAlbCli( uAlbCliL, nDec, nVdv )

   do case
   case ValType( uAlbCliT ) == "A"
      nCalculo       -= Round( nCalculo * uAlbCliT[ _NDTOESP ]  / 100, nDec )
      nCalculo       -= Round( nCalculo * uAlbCliT[ _NDPP    ]  / 100, nDec )
      nCalculo       -= Round( nCalculo * uAlbCliT[ _NDTOUNO ]  / 100, nDec )
      nCalculo       -= Round( nCalculo * uAlbCliT[ _NDTODOS ]  / 100, nDec )

      lIvaInc        := uAlbCliT[ _LIVAINC ]

   case ValType( uAlbCliT ) == "C"
      nCalculo       -= Round( nCalculo * ( uAlbCliT )->nDtoEsp / 100, nDec )
      nCalculo       -= Round( nCalculo * ( uAlbCliT )->nDpp    / 100, nDec )
      nCalculo       -= Round( nCalculo * ( uAlbCliT )->nDtoUno / 100, nDec )
      nCalculo       -= Round( nCalculo * ( uAlbCliT )->nDtoDos / 100, nDec )

      lIvaInc        := ( uAlbCliT )->lIvaInc

   case ValType( uAlbCliT ) == "O"
      nCalculo       -= Round( nCalculo * uAlbCliT:nDtoEsp / 100, nDec )
      nCalculo       -= Round( nCalculo * uAlbCliT:nDpp    / 100, nDec )
      nCalculo       -= Round( nCalculo * uAlbCliT:nDtoUno / 100, nDec )
      nCalculo       -= Round( nCalculo * uAlbCliT:nDtoDos / 100, nDec )

      lIvaInc        := uAlbCliT:lIvaInc

   end case

   do case
   case IsArray( uAlbCliL )
      nIva           := uAlbCliL[ _NIVA    ]

   case IsChar( uAlbCliL )
      nIva           := ( uAlbCliL )->nIva

   case IsObject( uAlbCliL )
      nIva           := uAlbCliL:nIva

   end case

   if nIva != 0
      if lIva  // lo quermos con IGIC
         if !lIvaInc
            nCalculo += Round( nCalculo * nIva / 100, nDec )
         end if
      else     // lo queremos sin IGIC
         if lIvaInc
            nCalculo -= Round( nCalculo / ( 100 / nIva  + 1 ), nDec )
         end if
      end if
   end if

RETURN ( if( cPouDiv != nil, Trans( nCalculo, cPouDiv ), nCalculo ) )

//---------------------------------------------------------------------------//

FUNCTION nImpLAlbCli( uAlbCliT, dbfAlbCliL, nDec, nRou, nVdv, lIva, lDto, lImpTrn, lPntVer, cPouDiv )

   local lIvaInc
   local nCalculo

   DEFAULT nDec      := 0
   DEFAULT nRou      := 0
   DEFAULT nVdv      := 1
   DEFAULT lIva      := .f.
   DEFAULT lDto      := .t.
   DEFAULT lPntVer   := .f.
   DEFAULT lImpTrn   := .f.

   nCalculo          := nTotLAlbCli( dbfAlbCliL, nDec, nRou, nVdv, .t., lImpTrn, lPntVer )

   do case
   case ValType( uAlbCliT ) == "A"
      nCalculo       -= Round( nCalculo * uAlbCliT[ _NDTOESP ]  / 100, nRou )
      nCalculo       -= Round( nCalculo * uAlbCliT[ _NDPP    ]  / 100, nRou )
      nCalculo       -= Round( nCalculo * uAlbCliT[ _NDTOUNO ]  / 100, nRou )
      nCalculo       -= Round( nCalculo * uAlbCliT[ _NDTODOS ]  / 100, nRou )

      lIvaInc        := uAlbCliT[ _LIVAINC ]

   case ValType( uAlbCliT ) == "C"
      nCalculo       -= Round( nCalculo * ( uAlbCliT )->nDtoEsp / 100, nRou )
      nCalculo       -= Round( nCalculo * ( uAlbCliT )->nDpp    / 100, nRou )
      nCalculo       -= Round( nCalculo * ( uAlbCliT )->nDtoUno / 100, nRou )
      nCalculo       -= Round( nCalculo * ( uAlbCliT )->nDtoDos / 100, nRou )

      lIvaInc        := ( uAlbCliT )->lIvaInc

   case ValType( uAlbCliT ) == "O"
      nCalculo       -= Round( nCalculo * uAlbCliT:nDtoEsp / 100, nRou )
      nCalculo       -= Round( nCalculo * uAlbCliT:nDpp    / 100, nRou )
      nCalculo       -= Round( nCalculo * uAlbCliT:nDtoUno / 100, nRou )
      nCalculo       -= Round( nCalculo * uAlbCliT:nDtoDos / 100, nRou )

      lIvaInc        := uAlbCliT:lIvaInc

   end if

   if ( dbfAlbCliL )->nIva != 0
      if lIva  // lo quermos con IGIC
         if !lIvaInc
            nCalculo += Round( nCalculo * ( dbfAlbCliL )->nIva / 100, nRou )
         end if
      else     // lo queremos sin IGIC
         if lIvaInc
            nCalculo -= Round( nCalculo / ( 100 / ( dbfAlbCliL )->nIva  + 1 ), nRou )
         end if
      end if
   end if

RETURN ( if( cPouDiv != nil, Trans( nCalculo, cPouDiv ), nCalculo ) )

//---------------------------------------------------------------------------//

FUNCTION nPesLAlbCli( cAlbCliL )

	local nCalculo

   DEFAULT cAlbCliL  := dbfAlbCliL

   if !( cAlbCliL )->lTotLin
      nCalculo       := Abs( nTotNAlbCli( cAlbCliL ) ) * ( cAlbCliL )->nPesoKg
   end if

RETURN ( nCalculo )

//---------------------------------------------------------------------------//

FUNCTION nCosLAlbCli( dbfLine, nDec, nRec, nVdv, cPouDiv )

   local nCalculo       := 0

   DEFAULT nDec         := 0
   DEFAULT nRec         := 0
   DEFAULT nVdv         := 1

   if !( dbfLine )->lKitChl
      nCalculo          := nTotNAlbCli( dbfLine )
      nCalculo          *= ( dbfLine )->nCosDiv
   end if

   if nVdv != 0
      nCalculo          := nCalculo / nVdv
   end if

   nCalculo             := Round( nCalculo, nRec )

RETURN ( if( cPouDiv != nil, Trans( nCalculo, cPouDiv ), nCalculo ) )

//---------------------------------------------------------------------------//

//
// Devuelve el valor del IVMH
//

FUNCTION nTotIAlbCli( dbfLin, nDec, nRouDec, nVdv, cPorDiv )

   local nCalculo    := 0

   DEFAULT dbfLin    := dbfAlbCliL
   DEFAULT nDec      := 0
   DEFAULT nRouDec   := 0
   DEFAULT nVdv      := 1

   if !( dbfLin )->lTotLin

      /*
      Tomamos los valores redondeados------------------------------------------
      */

      nCalculo       := Round( ( dbfLin )->nValImp, nDec )

      /*
      Unidades-----------------------------------------------------------------
      */

      nCalculo       *= nTotNAlbCli( dbfLin )

         if ( dbfLin )->LVOLIMP
            nCalculo *= NotCero( ( dbfLin )->nVolumen )
         end if

      nCalculo       := Round( nCalculo / nVdv, nRouDec )

   end if

RETURN ( if( cPorDiv != NIL, Trans( nCalculo, cPorDiv ), nCalculo ) )

//----------------------------------------------------------------------------//

FUNCTION nTrnLAlbCli( dbfLin, nDec, nRou, nVdv )

   local nImpTrn

   DEFAULT dbfLin    := dbfAlbCliL
   DEFAULT nDec      := 2
   DEFAULT nRou      := 2
   DEFAULT nVdv      := 1

   /*
   Punto Verde-----------------------------------------------------------------
   */

   nImpTrn           := nTrnUAlbCli( dbfLin, nDec ) * nTotNAlbCli( dbfLin )

   IF nVdv != 0
      nImpTrn        := nImpTrn / nVdv
	END IF

RETURN ( Round( nImpTrn, nRou ) )

//---------------------------------------------------------------------------//

FUNCTION nTrnUAlbCli( dbfTmpLin, nDec, nVdv )

	local nCalculo

   DEFAULT nDec   := 0
   DEFAULT nVdv   := 1

   nCalculo       := ( dbfTmpLin )->nImpTrn

	IF nVdv != 0
      nCalculo    := nCalculo / nVdv
	END IF

RETURN ( Round( nCalculo, nDec ) )

//---------------------------------------------------------------------------//

STATIC FUNCTION KillTrans()

	/*
   Borramos los ficheros-------------------------------------------------------
   */

   if !Empty( dbfTmpLin ) .and. ( dbfTmpLin )->( Used() )
      ( dbfTmpLin )->( dbCloseArea() )
   end if

   if !Empty( dbfTmpPgo ) .and. ( dbfTmpPgo )->( Used() )
      ( dbfTmpPgo )->( dbCloseArea() )
   end if

   if !Empty( dbfTmpInc ) .and. ( dbfTmpInc )->( Used() )
      ( dbfTmpInc )->( dbCloseArea() )
   end if

   if !Empty( dbfTmpDoc ) .and. ( dbfTmpDoc )->( Used() )
      ( dbfTmpDoc )->( dbCloseArea() )
   end if

   if !Empty( dbfTmpSer ) .and. ( dbfTmpSer )->( Used() )
      ( dbfTmpSer )->( dbCloseArea() )
   end if

   dbfTmpLin      := nil
   dbfTmpInc      := nil
   dbfTmpDoc      := nil
   dbfTmpPgo      := nil
   dbfTmpSer      := nil

   dbfErase( cTmpLin )
   dbfErase( cTmpPgo )
   dbfErase( cTmpInc )
   dbfErase( cTmpDoc )
   dbfErase( cTmpSer )

   oStock:SetTmpAlbCliL()
   oStock:SetTmpAlbCliS()

RETURN NIL

//------------------------------------------------------------------------//

STATIC FUNCTION BeginTrans( aTmp, nMode )

   local oError
   local oBlock
   local lErrors     := .f.
   local cDbfLin     := "ACliL"
   local cDbfInc     := "ACliI"
   local cDbfDoc     := "ACliD"
   local cDbfPgo     := "ACliP"
   local cDbfSer     := "ACliS"
   local cAlbaran

   CursorWait()

   oBlock            := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      aNumPed        := {}
      aNumSat        := {}

      cAlbaran       := aTmp[ _CSERALB ] + Str( aTmp[ _NNUMALB ] ) + aTmp[ _CSUFALB ]

      cTmpLin        := cGetNewFileName( cPatTmp() + cDbfLin )
      cTmpInc        := cGetNewFileName( cPatTmp() + cDbfInc )
      cTmpDoc        := cGetNewFileName( cPatTmp() + cDbfDoc )
      cTmpPgo        := cGetNewFileName( cPatTmp() + cDbfPgo )
      cTmpSer        := cGetNewFileName( cPatTmp() + cDbfSer )

      do case
         case nMode == APPD_MODE .or. nMode == DUPL_MODE

            nTotOld  := 0

         case nMode == EDIT_MODE

            nTotOld  := nTotAlb

      end case

      /*
      Primero Crear la base de datos local----------------------------------------
      */

      dbCreate( cTmpLin, aSqlStruct( aColAlbCli() ), cLocalDriver() )
      dbUseArea( .t., cLocalDriver(), cTmpLin, cCheckArea( cDbfLin, @dbfTmpLin ), .f. )

      if !NetErr() .and. ( dbfTmpLin )->( Used() )

         ( dbfTmpLin )->( OrdCondSet( "!Deleted()", {|| !Deleted() } ) )
         ( dbfTmpLin )->( OrdCreate( cTmpLin, "nNumLin", "Str( nNumLin, 4 )", {|| Str( Field->nNumLin ) } ) )

         ( dbfTmpLin )->( OrdCondSet( "!Deleted()", {|| !Deleted() } ) )
         ( dbfTmpLin )->( OrdCreate( cTmpLin, "nNumAlb", "Str( Recno() )", {|| Str( Recno() ) } ) )

         if ( dbfAlbCliL )->( dbSeek( cAlbaran ) )
            while ( ( dbfAlbCliL )->cSerAlb + Str( ( dbfAlbCliL )->nNumAlb ) + ( dbfAlbCliL )->cSufAlb ) == cAlbaran .and. !( dbfAlbCliL )->( eof() )
               dbPass( dbfAlbCliL, dbfTmpLin, .t. )
               ( dbfAlbCliL )->( dbSkip() )
            end while
         end if

         ( dbfTmpLin )->( dbGoTop() )

         oStock:SetTmpAlbCliL( dbfTmpLin )

      else

         lErrors           := .t.

      end if

      /*
      Base de datos de los anticipos----------------------------------------------
      */

      dbCreate( cTmpPgo, aSqlStruct( aItmAlbPgo() ), cLocalDriver() )
      dbUseArea( .t., cLocalDriver(), cTmpPgo, cCheckArea( cDbfPgo, @dbfTmpPgo ), .f. )

      if !NetErr()

         ( dbfTmpPgo )->( OrdCondSet( "!Deleted()", {||!Deleted() } ) )
         ( dbfTmpPgo )->( OrdCreate( cTmpPgo, "nNumAlb", "Str( Recno() )", {|| Str( Recno() ) } ) )

         if ( dbfAlbCliP )->( dbSeek( cAlbaran ) )
            while ( ( dbfAlbCliP )->cSerAlb + Str( ( dbfAlbCliP )->nNumAlb ) + ( dbfAlbCliP )->cSufAlb ) == cAlbaran .and. !( dbfAlbCliP )->( eof() )
               dbPass( dbfAlbCliP, dbfTmpPgo, .t. )
               ( dbfAlbCliP )->( dbSkip() )
            end while
         end if

         ( dbfTmpPgo )->( dbGoTop() )

      else

         lErrors     := .t.

      end if

      /*
      A¤adimos desde el fichero de incidencias
      */

      dbCreate( cTmpInc, aSqlStruct( aIncAlbCli() ), cLocalDriver() )
      dbUseArea( .t., cLocalDriver(), cTmpInc, cCheckArea( cDbfInc, @dbfTmpInc ), .f. )

      if !NetErr()
         ( dbfTmpInc )->( ordCondSet( "!Deleted()", {||!Deleted() } ) )
         ( dbfTmpInc )->( ordCreate( cTmpInc, "nNumAlb", "Recno()", {|| Recno() } ) )

         if ( dbfAlbCliI )->( dbSeek( cAlbaran ) )
            while ( ( dbfAlbCliI )->cSerAlb + Str( ( dbfAlbCliI )->nNumAlb ) + ( dbfAlbCliI )->cSufAlb == cAlbaran ) .and. ( dbfAlbCliI )->( !eof() )
               dbPass( dbfAlbCliI, dbfTmpInc, .t. )
               ( dbfAlbCliI )->( dbSkip() )
            end while
         end if

         ( dbfTmpInc )->( dbGoTop() )

      else

         lErrors     := .t.

      end if

      /*
      Añadimos desde el fichero de documentos
      */

      dbCreate( cTmpDoc, aSqlStruct( aAlbCliDoc() ), cLocalDriver() )
      dbUseArea( .t., cLocalDriver(), cTmpDoc, cCheckArea( cDbfDoc, @dbfTmpDoc ), .f. )

      if !NetErr()

         ( dbfTmpDoc )->( ordCondSet( "!Deleted()", {||!Deleted() } ) )
         ( dbfTmpDoc )->( ordCreate( cTmpDoc, "nNumAlb", "Recno()", {|| Recno() } ) )

         if ( dbfAlbCliD )->( dbSeek( cAlbaran ) )
            while ( ( dbfAlbCliD )->cSerAlb + Str( ( dbfAlbCliD )->nNumAlb ) + ( dbfAlbCliD )->cSufAlb == cAlbaran ) .and. ( dbfAlbCliD )->( !eof() )
               dbPass( dbfAlbCliD, dbfTmpDoc, .t. )
               ( dbfAlbCliD )->( dbSkip() )
            end while
         end if

         ( dbfTmpDoc )->( dbGoTop() )

      else

         lErrors     := .t.

      end if

      /*
      Creamos el fichero de series------------------------------------------------
      */

      dbCreate( cTmpSer, aSqlStruct( aSerAlbCli() ), cLocalDriver() )
      dbUseArea( .t., cLocalDriver(), cTmpSer, cCheckArea( cDbfSer, @dbfTmpSer ), .f. )

      if !( dbfTmpSer )->( NetErr() )

         ( dbfTmpSer )->( OrdCondSet( "!Deleted()", {||!Deleted() } ) )
         ( dbfTmpSer )->( OrdCreate( cTmpSer, "nNumLin", "Str( nNumLin, 4 ) + cRef", {|| Str( Field->nNumLin, 4 ) + Field->cRef } ) )

         if ( dbfAlbCliS )->( dbSeek( cAlbaran ) )
            while ( ( dbfAlbCliS )->cSerAlb + Str( ( dbfAlbCliS )->nNumAlb ) + ( dbfAlbCliS )->cSufAlb == cAlbaran ) .and. !( dbfAlbCliS )->( eof() )
               dbPass( dbfAlbCliS, dbfTmpSer, .t. )
               ( dbfAlbCliS )->( dbSkip() )
            end while
         end if

         ( dbfTmpSer )->( dbGoTop() )

         oStock:SetTmpAlbCliS( dbfTmpSer )

      else

         lErrors     := .t.

      end if

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Imposible crear tablas temporales." )

      KillTrans()

      lErrors        := .t.

   END SEQUENCE

   ErrorBlock( oBlock )

   CursorWE()

Return ( lErrors )

//-----------------------------------------------------------------------//

/*
Calcula el Total del albaran
*/

Static Function RecalculaTotal( aTmpAlb )

   local nTotAlbCli     := nTotAlbCli( nil, dbfAlbCliT, dbfTmpLin, dbfIva, dbfDiv, aTmpAlb )
   local nEntAlbCli     := nPagAlbCli( nil, dbfTmpPgo, dbfDiv )

   if oBrwIva != nil
      oBrwIva:Refresh()
   end if

   if oGetNet != nil
      oGetNet:SetText( Trans( nTotNet, cPorDiv ) )
   end if

   if oGetIva != NIL
      oGetIva:SetText( Trans( nTotIva, cPorDiv ) )
   end if

   if oGetReq != NIL
      oGetReq:SetText( Trans( nTotReq, cPorDiv ) )
   end if

   if oGetIvm != nil
      oGetIvm:SetText( Trans( nTotIvm, cPorDiv ) )
   end if

   if oGetRnt != nil
      oGetRnt:SetText( AllTrim( Trans( nTotRnt, cPorDiv ) + Space( 1 ) + AllTrim( cSimDiv( aTmpAlb[ _CDIVALB ], dbfDiv ) ) + " : " + AllTrim( Trans( nPctRnt, "999.99" ) ) + "%" ) )
   end if

   if oGetPnt != nil
      oGetPnt:SetText( Trans( nTotPnt, cPorDiv ) )
   end if

   if oGetTrn != nil
      oGetTrn:SetText( Trans( nTotTrn, cPorDiv ) )
   end if

   if oGetTotal != NIL
      oGetTotal:SetText( Trans( nTotAlb, cPorDiv ) )
   end if

   if oTotAlbLin != NIL
      oTotAlbLin:SetText( Trans( nTotAlb, cPorDiv ) )
   end if

   if oGetAlb != nil
      oGetAlb:SetText( Trans( nTotAlb, cPorDiv ) )
   end if

   if oGetEnt != nil
      oGetEnt:SetText( Trans( nTotPag, cPorDiv ) )
   end if

   if oGetPdt != nil
      oGetPdt:SetText( Trans( nTotAlb - nTotPag, cPorDiv ) )
   end if

   if oGetAge != nil
      oGetAge:SetText( Trans( nTotAge, cPorDiv ) )
   end if

   if oGetPes != nil
      oGetPes:cText( nTotPes )
   end if

   if oGetDif != nil
      oGetDif:cText( nTotDif )
   end if

Return .t.

//--------------------------------------------------------------------------//

//
// Total anticipos de un albaran
//

FUNCTION nPagAlbCli( cNumAlb, cAlbCliP, cDiv, cDivRet, lPic )

   local nRec
   local nOrd
   local cCodDiv
   local cPorDiv
   local nRouDiv

   public nTotPag       := 0

   DEFAULT cAlbCliP     := dbfAlbCliP
   DEFAULT cDiv         := dbfDiv
   DEFAULT lPic         := .f.

   nRec                 := ( cAlbCliP )->( Recno() )
   nOrd                 := ( cAlbCliP )->( OrdSetFocus( "nNumAlb" ) )
   cCodDiv              := cDivEmp()
   cPorDiv              := cPorDiv( cCodDiv, cDiv ) // Picture de la divisa redondeada
   nRouDiv              := nRouDiv( cCodDiv, cDiv )

   if IsNil( cNumAlb )

      ( cAlbCliP )->( dbGoTop() )
      while !( cAlbCliP )->( Eof() )
         nTotPag        += nEntAlbCli( cAlbCliP, cDiv, cDivRet )
         ( cAlbCliP )->( dbSkip() )
      end while

   else

      if ( cAlbCliP )->( dbSeek( cNumAlb ) )
         while ( cAlbCliP )->cSerAlb + Str( ( cAlbCliP )->nNumAlb ) + ( cAlbCliP )->cSufAlb == cNumAlb .and. !( cAlbCliP )->( eof() )
            nTotPag     += nEntAlbCli( cAlbCliP, cDiv, cDivRet )
            ( cAlbCliP )->( dbSkip() )
         end while
      end if

   end if

   ( cAlbCliP )->( OrdSetFocus( nOrd ) )
   ( cAlbCliP )->( dbGoTo( nRec ) )

   if cDivRet != nil .and. cCodDiv != cDivRet
      nTotPag           := nCnv2Div( nTotPag, cCodDiv, cDivRet, cDiv )
      cPorDiv           := cPorDiv( cDivRet, cDiv ) // Picture de la divisa redondeada
      nRouDiv           := nRouDiv( cDivRet, cDiv )
   end if

   nTotPag              := Round( nTotPag, nRouDiv )

   if lPic
      nTotPag           := Trans( nTotPag, cPorDiv )
   end if

RETURN ( nTotPag )

//--------------------------------------------------------------------------//

function nEntAlbCli( uAlbCliP, cDbfDiv, cDivRet, lPic )

   local cDivPgo
   local nRouDiv
   local cPorDiv
   local nTotRec

   DEFAULT uAlbCliP  := dbfAlbCliP
   DEFAULT cDbfDiv   := dbfDiv
   DEFAULT cDivRet   := cDivEmp()
   DEFAULT lPic      := .f.

   if ValType( uAlbCliP ) == "O"
      cDivPgo        := uAlbCliP:cDivPgo
      nTotRec        := uAlbCliP:nImporte
   else
      cDivPgo        := ( uAlbCliP )->cDivPgo
      nTotRec        := ( uAlbCliP )->nImporte
   end if

   nRouDiv           := nRouDiv( cDivPgo, cDbfDiv )
   cPorDiv           := cPorDiv( cDivPgo, cDbfDiv )

   nTotRec           := Round( nTotRec, nRouDiv )

   if cDivRet != cDivPgo
      nRouDiv        := nRouDiv( cDivRet, cDbfDiv )
      cPorDiv        := cPorDiv( cDivRet, cDbfDiv )
      nTotRec        := nCnv2Div( nTotRec, cDivPgo, cDivRet, cDbfDiv )
   end if

RETURN if( lPic, Trans( nTotRec, cPorDiv ), nTotRec )

//---------------------------------------------------------------------------//

STATIC FUNCTION LoaCli( aGet, aTmp, nMode, oRieCli, oTlfCli )

   local lValid      := .t.
   local cNewCodCli  := aGet[ _CCODCLI ]:varGet()
   local lChgCodCli  := ( Empty( cOldCodCli ) .or. cOldCodCli != cNewCodCli )

	IF Empty( cNewCodCli )
      Return .t.
	ELSEIF At( ".", cNewCodCli ) != 0
      cNewCodCli     := PntReplace( aGet[_CCODCLI], "0", RetNumCodCliEmp() )
	ELSE
      cNewCodCli     := Rjust( cNewCodCli, "0", RetNumCodCliEmp() )
	END IF

   /*
   Calculo del reisgo del cliente
   */

   if ( dbfClient )->( dbSeek( cNewCodCli ) )

      /*
      Asignamos el codigo siempre
      */

      aGet[ _CCODCLI ]:cText( ( dbfClient )->Cod )

      if oTlfCli != nil
         oTlfCli:SetText( ( dbfClient )->Telefono )
      end if

      /*
      Color de fondo del cliente
      */

      if ( dbfClient )->nColor != 0
         aGet[_CNOMCLI]:SetColor( , ( dbfClient )->nColor )
      end if

      if Empty( aGet[_CNOMCLI]:varGet() ) .or. lChgCodCli
         aGet[_CNOMCLI]:cText( ( dbfClient )->Titulo )
      end if

      if Empty( aGet[_CDIRCLI]:varGet() ) .or. lChgCodCli
         aGet[_CDIRCLI]:cText( ( dbfClient )->Domicilio )
      end if

      if Empty( aGet[ _CTLFCLI ]:varGet() ) .or. lChgCodCli
         aGet[ _CTLFCLI ]:cText( ( dbfClient )->Telefono )
      end if

      if Empty( aGet[_CPOBCLI]:varGet() ) .or. lChgCodCli
         aGet[_CPOBCLI]:cText( ( dbfClient )->Poblacion )
      end if

      if !Empty( aGet[_CPRVCLI] )
         if Empty( aGet[_CPRVCLI]:varGet() ) .or. lChgCodCli
            aGet[_CPRVCLI]:cText( ( dbfClient )->Provincia )
         end if
      end if

      if !Empty( aGet[_CPOSCLI] )
         if Empty( aGet[_CPOSCLI]:varGet() ) .or. lChgCodCli
            aGet[_CPOSCLI]:cText( ( dbfClient )->CodPostal )
         end if
      end if

      if !Empty( aGet[_CDNICLI] )
         if Empty( aGet[_CDNICLI]:varGet() ) .or. lChgCodCli
            aGet[_CDNICLI]:cText( ( dbfClient )->Nif )
         end if
      end if

      if Empty( aTmp[_CCODGRP] ) .or. lChgCodCli
         aTmp[_CCODGRP]    := ( dbfClient )->cCodGrp
      end if

      if ( lChgCodCli )

         /*
         Calculo del reisgo del cliente-------------------------------------------
         */

         if oRieCli != nil
            oStock:SetRiesgo( cNewCodCli, oRieCli, ( dbfClient )->Riesgo )
         end if

         aTmp[ _LMODCLI ]  := ( dbfClient )->lModDat

      end if

      if ( lChgCodCli )
         aTmp[ _LOPERPV ]  := ( dbfClient )->lPntVer
      end if

      if nMode == APPD_MODE

         aTmp[ _NREGIVA ]  := ( dbfClient )->nRegIva

         /*
         Si estamos a¤adiendo cargamos todos los datos del cliente
         */

         if Empty( aTmp[ _CSERALB ] )

            if !Empty( ( dbfClient )->Serie )
               aGet[ _CSERALB ]:cText( ( dbfClient )->Serie )
            end if

         else

            if !Empty( ( dbfClient )->Serie )                .and.;
               aTmp[ _CSERALB ] != ( dbfClient )->Serie      .and.;
               ApoloMsgNoYes( "La serie del cliente seleccionado es distinta a la anterior.", "¿Desea cambiar la serie?" )
               aGet[ _CSERALB ]:cText( ( dbfClient )->Serie )
            end if

         end if

         if !Empty( aGet[_CCODALM] )
            if ( Empty( aGet[_CCODALM]:varGet() ) .or. lChgCodCli ) .and. !Empty( ( dbfClient )->cCodAlm )
                aGet[_CCODALM]:cText( ( dbfClient )->cCodAlm )
                aGet[_CCODALM]:lValid()
            end if
         end if

         if !Empty( aGet[_CCODTAR] )
            if ( Empty( aGet[_CCODTAR]:varGet() ) .or. lChgCodCli ) .and. !Empty( ( dbfClient )->cCodTar )
               aGet[_CCODTAR]:cText( ( dbfClient )->CCODTAR )
               aGet[_CCODTAR]:lValid()
            end if
         end if

         if ( Empty( aGet[_CCODPAGO]:varGet() ) .or. lChgCodCli ) .and. !Empty( ( dbfClient )->CodPago )
            aGet[_CCODPAGO]:cText( (dbfClient)->CODPAGO )
            aGet[_CCODPAGO]:lValid()
         end if

         /*
         Si la forma de pago es un movimiento bancario le asignamos el banco y cuenta por defecto
         */

         if ( lChgCodCli .and. lBancoDefecto( ( dbfClient )->Cod, dbfCliBnc ) )

            if !Empty( aGet[ _CBANCO ] )
               aGet[ _CBANCO ]:cText( ( dbfCliBnc )->cCodBnc )
               aGet[ _CBANCO ]:lValid()
            end if

            if !Empty( aGet[ _CENTBNC ] )
               aGet[ _CENTBNC ]:cText( ( dbfCliBnc )->cEntBnc )
               aGet[ _CENTBNC ]:lValid()
            end if

            if !Empty( aGet[ _CSUCBNC ] )
               aGet[ _CSUCBNC ]:cText( ( dbfCliBnc )->cSucBnc )
               aGet[ _CSUCBNC ]:lValid()
            end if

            if !Empty( aGet[ _CDIGBNC ] )
               aGet[ _CDIGBNC ]:cText( ( dbfCliBnc )->cDigBnc )
               aGet[ _CDIGBNC ]:lValid()
            end if

            if !Empty( aGet[ _CCTABNC ] )
               aGet[ _CCTABNC ]:cText( ( dbfCliBnc )->cCtaBnc )
               aGet[ _CCTABNC ]:lValid()
            end if

         end if

         if !Empty( aGet[_CCODAGE] )
            if ( Empty( aGet[_CCODAGE]:varGet() ) .or. lChgCodCli ) .and. !Empty( ( dbfClient )->cAgente )
                aGet[_CCODAGE]:cText( (dbfClient)->CAGENTE )
                aGet[_CCODAGE]:lValid()
            end if
         end if

         if ( Empty( aGet[_CCODRUT]:varGet() ) .or. lChgCodCli ) .and. !Empty( ( dbfClient )->cCodRut )
            aGet[_CCODRUT]:cText( ( dbfClient)->CCODRUT )
            aGet[_CCODRUT]:lValid()
         end if

         if ( Empty( aGet[ _NTARIFA ]:varGet() ) .or. lChgCodCli ) .and. !Empty( ( dbfClient )->nTarifa )
             aGet[ _NTARIFA ]:cText( ( dbfClient )->nTarifa )
         end if

         if !Empty( aGet[ _CCODTRN ] ) .and. ( Empty( aGet[ _CCODTRN ]:varGet() ) .or. lChgCodCli ) .and. !Empty( ( dbfClient )->cCodTrn )
            aGet[ _CCODTRN ]:cText( ( dbfClient )->cCodTrn )
            aGet[ _CCODTRN ]:lValid()
         end if


         if lChgCodCli

            aGet[ _LRECARGO ]:Click( ( dbfClient )->lReq ):Refresh()

            aGet[ _LOPERPV  ]:Click( ( dbfClient )->lPntVer ):Refresh()

            /*
            Retenciones desde la ficha de cliente----------------------------------

            if !Empty( aGet[ _NTISATT ] )
               aGet[ _NTISATT  ]:Select( ( dbfClient )->nTipRet )
            else
               aTmp[ _NTISATT  ] := ( dbfClient )->nTipRet
            end if

            if !Empty( aGet[ _NPCTRET ] )
               aGet[ _NPCTRET  ]:cText( ( dbfClient )->nPctRet )
            else
               aTmp[ _NPCTRET  ] := ( dbfClient )->nPctRet
            end if
            */

            /*
            Descuentos desde la ficha de cliente----------------------------------
            */

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

            if !Empty( aGet[ _CDTOUNO ] )
               aGet[ _CDTOUNO ]:cText( ( dbfClient )->cDtoUno )
            else
               aTmp[ _CDTOUNO ]  := ( dbfClient )->cDtoUno
            end if

            if !Empty( aGet[ _CDTODOS ] )
               aGet[ _CDTODOS ]:cText( ( dbfClient )->cDtoDos )
            else
               aTmp[ _CDTODOS ]  := ( dbfClient )->cDtoDos
            end if

            if !Empty( aGet[ _NDTOUNO ] )
               aGet[ _NDTOUNO ]:cText( ( dbfClient )->nDtoCnt )
            else
               aTmp[ _NDTOUNO ]  := ( dbfClient )->nDtoCnt
            end if

            if !Empty( aGet[ _NDTODOS ] )
               aGet[ _NDTODOS ]:cText( ( dbfClient )->nDtoRap )
            else
               aTmp[ _NDTODOS ]  := ( dbfClient )->nDtoRap
            end if

            aTmp[ _NSBRATP ]  := ( dbfClient )->nSbrAtp

            aTmp[ _NDTOATP ]  := ( dbfClient )->nDtoAtp

         end if

      end if

      if lChgCodCli

         if ( dbfClient )->lMosCom .and. !Empty( ( dbfClient )->mComent )
            MsgStop( Trim( ( dbfClient )->mComent ) )
         end if

#ifndef __PDA__
         ShowInciCliente( ( dbfClient )->Cod, dbfCliInc )
#endif

         if ( dbfClient )->lBlqCli
            msgStop( "Cliente bloqueado, no se pueden realizar operaciones de venta" , "Imposible archivar como albarán" )
         end if

         if !( dbfClient )->lChgPre
            msgStop( "Este cliente no tiene autorización para venta a credito", "Imposible archivar como albarán" )
         end if



      end if

      cOldCodCli  := ( dbfClient )->Cod

      lValid      := .t.

	ELSE

		msgStop( "Cliente no encontrado" )

      lValid      := .f.

	END IF

RETURN lValid

//----------------------------------------------------------------------------//

/*
Estudiamos la posiblidades que se pueden dar en una linea de detalle
*/

STATIC FUNCTION SetDlgMode( aTmp, aGet, oFld, nMode, oSayPr1, oSayPr2, oSayVp1, oSayVp2, oStkAct, oGet2, oTotal, aTmpAlb, oRentLin )

   if !lUseCaj()
      aGet[ _NCANENT ]:Hide()
   else
      if !Empty( aGet[ _NCANENT ] )
         aGet[ _NCANENT ]:SetText( cNombreCajas() )
      end if
   end if

   aGet[ _NUNICAJA ]:SetText( cNombreUnidades() )

   if aGet[ _NVALIMP ] != nil

      if !uFieldEmpresa( "lUseImp" )
         aGet[ _NVALIMP ]:Hide()
      else
         if !uFieldEmpresa( "lModImp" )
            aGet[ _NVALIMP ]:Disable()
         end if
      end if

   end if

   if !lTipMov()

      if !Empty( aGet[ _CTIPMOV ] )
         aGet[ _CTIPMOV ]:hide()
      end if

      if !Empty( oGet2 )
         oGet2:hide()
      end if

   end if

   if aGet[ _NIMPTRN ] != nil
      if !uFieldEmpresa( "lUsePor", .f. )
         aGet[ _NIMPTRN ]:Hide()
      end if
   end if

   if aGet[ _NPNTVER ] != nil
      if !uFieldEmpresa( "lUsePnt", .f. ) .or. !aTmpAlb[ _LOPERPV ]
         aGet[ _NPNTVER ]:Hide()
      end if
   end if

   if aGet[ _NDTODIV ] != nil
      if !uFieldEmpresa( "lDtoLin", .f. )
         aGet[ _NDTODIV ]:Hide()
      end if
   end if


   if oRentLin != nil .and. oUser():lNotRentabilidad()
      oRentLin:Hide()
   end if

   if aTmp[ __LALQUILER ]
      aGet[ _NSATUNIT ]:Hide()
      aGet[ _NSATALQ  ]:Show()
   end if

   do case
   case nMode == APPD_MODE

      aTmp[ _CREF    ]  := Space( 32 )
      aTmp[ _LIVALIN ]  := aTmpAlb[ _LIVAINC ]

      aGet[ _NCANENT ]:cText( 1 )
      aGet[ _NUNICAJA]:cText( 1 )

      if !Empty( aGet[ _NNUMLIN ] )
         aGet[ _NNUMLIN ]:cText( nLastNum( dbfTmpLin )  )
      end if

      aGet[ _CALMLIN ]:cText( aTmpAlb[ _CCODALM ] )

      if lTipMov() .and. aGet[ _CTIPMOV ] != nil
         aGet[ _CTIPMOV ]:cText( cDefVta() )
      end if

      if !Empty( aGet[ _LCONTROL] )
         aGet[ _LCONTROL]:Click( .f. )
      end if

      if !Empty( oStkAct )

         if !uFieldEmpresa( "lNStkAct" )
            oStkAct:Show()
            oStkAct:cText( 0 )
         else
            oStkAct:Hide()
         end if

      end if

      aGet[ _CDETALLE]:Show()
      aGet[ _MLNGDES ]:Hide()

      if !Empty( aGet[ _CLOTE ] )
         aGet[ _CLOTE ]:Hide()
      end if

      if !Empty( aGet[ _DFECCAD ] )
         aGet[ _DFECCAD ]:Hide()
      end if

      if aTmpAlb[ _NREGIVA ] <= 1
         aGet[ _NIVA ]:cText( nIva( dbfIva, cDefIva() ) )
      end if

   case ( nMode == DUPL_MODE .or. nMode == EDIT_MODE .OR. nMode == ZOOM_MODE )

      if aTmp[ _LLOTE ]

         if !Empty( aGet[ _CLOTE ] )
            aGet[ _CLOTE ]:Show()
         end if

         if !Empty( aGet[ _DFECCAD ] )
            aGet[ _DFECCAD ]:Show()
         end if

      else

         if !Empty( aGet[ _CLOTE ] )
             aGet[ _CLOTE ]:Hide()
         end if

         if !Empty( aGet[ _DFECCAD ] )
            aGet[ _DFECCAD ]:Hide()
         end if

      end if

      if !Empty( aTmp[_CREF] )
         aGet[ _CDETALLE ]:show()
         aGet[ _MLNGDES  ]:hide()
      else
         aGet[ _CDETALLE ]:hide()
         aGet[ _MLNGDES  ]:show()
      end if

   if !Empty( oStock )

      oStock:nPutStockActual( aTmp[ _CREF ], aTmp[ _CALMLIN ], aTmp[ _CVALPR1 ], aTmp[ _CVALPR2 ], aTmp[ _CLOTE ], aTmp[ _LKITART ], aTmp[ _NCTLSTK ], oStkAct )

      if uFieldEmpresa( "lNStkAct" )
         oStkAct:Hide()
      end if

   end if

   end case

   if !Empty( aTmp[_CCODPR1 ] )

      if !Empty( aGet[ _CVALPR1 ] )
         aGet[ _CVALPR1 ]:Show()
         aGet[ _CVALPR1 ]:lValid()
      end if
      if !Empty( oSayPr1 )
         oSayPr1:Show()
         oSayPr1:SetText( retProp( aTmp[_CCODPR1], dbfPro ) )
      end if
      if !Empty( oSayVp1 )
         oSayVp1:Show()
      end if

   else

      if !Empty( aGet[ _CVALPR1 ] )
         aGet[_CVALPR1 ]:hide()
      end if
      if !Empty( oSayPr1 )
         oSayPr1:hide()
      end if
      if !Empty( oSayVp1 )
         oSayVp1:hide()
      end if

   end if

   if !Empty( aTmp[_CCODPR2 ] )

      if !Empty( aGet[ _CVALPR2 ] )
         aGet[ _CVALPR2 ]:Show()
         aGet[ _CVALPR2 ]:lValid()
      end if
      if !Empty( oSayPr2 )
         oSayPr2:Show()
         oSayPr2:SetText( retProp( aTmp[ _CCODPR2 ], dbfPro ) )
      end if
      if !Empty( oSayVp2 )
         oSayVp2:Show()
      end if

   else

      if !Empty( aGet[ _CVALPR2 ] )
         aGet[_CVALPR2 ]:hide()
      end if
      if !Empty( oSayPr2 )
         oSayPr2:hide()
      end if
      if !Empty( oSayVp2 )
         oSayVp2:hide()
      end if

   end if

   /*
   Ocultamos el precio de costo------------------------------------------------
   */

   if !lAccArticulo() .or. oUser():lNotCostos()

      if !Empty( aGet[ _NCOSDIV ] )
         aGet[ _NCOSDIV ]:Hide()
      end if

   end if

   /*
   Solo pueden modificar los precios los administradores-----------------------
   */

   if ( Empty( aTmp[ _NSATUNIT ] ) .or. lUsrMaster() .or. oUser():lCambiarPrecio() ) .and. nMode != ZOOM_MODE

      if !Empty( aGet[ _NSATUNIT ] )
         aGet[ _NSATUNIT ]:HardEnable()
      end if

      aGet[ _NIMPTRN ]:HardEnable()

      if !Empty( aGet[ _NPNTVER ] )
         aGet[ _NPNTVER ]:HardEnable()
      end if

      aGet[ _NDTO     ]:HardEnable()
      aGet[ _NDTOPRM  ]:HardEnable()

      if !Empty( aGet[ _NDTODIV ] )
         aGet[ _NDTODIV  ]:HardEnable()
      end if

   else

      aGet[ _NSATUNIT ]:HardDisable()
      aGet[ _NIMPTRN  ]:HardDisable()

      if !Empty( aGet[ _NPNTVER ] )
         aGet[ _NPNTVER  ]:HardDisable()
      end if

      aGet[ _NDTO     ]:HardDisable()
      aGet[ _NDTOPRM  ]:HardDisable()

      if !Empty( aGet[ _NDTODIV  ] )
          aGet[ _NDTODIV ]:HardDisable()
      end if

   end if

   /*
   Ocultamos las tres unidades de medicion-------------------------------------
   */

   if !Empty( aGet[ ( dbfAlbCliL )->( fieldpos( "nMedUno" ) ) ] )
      aGet[ ( dbfAlbCliL )->( fieldpos( "nMedUno" ) ) ]:Hide()
   end if

   if !Empty( aGet[ ( dbfAlbCliL )->( fieldpos( "nMedDos" ) ) ] )
      aGet[ ( dbfAlbCliL )->( fieldpos( "nMedDos" ) ) ]:Hide()
   end if

   if !Empty( aGet[ ( dbfAlbCliL )->( fieldpos( "nMedTre" ) ) ] )
      aGet[ ( dbfAlbCliL )->( fieldpos( "nMedTre" ) ) ]:Hide()
   end if

   if oUndMedicion:oDbf:Seek( aTmp[ _CUNIDAD ] )

      if !Empty( aGet[ ( dbfAlbCliL )->( fieldpos( "nMedUno" ) ) ] ) .and. oUndMedicion:oDbf:nDimension >= 1 .and. !Empty( oUndMedicion:oDbf:cTextoDim1 )
         aGet[ ( dbfAlbCliL )->( fieldpos( "nMedUno" ) ) ]:oSay:SetText( oUndMedicion:oDbf:cTextoDim1 )
         aGet[ ( dbfAlbCliL )->( fieldpos( "nMedUno" ) ) ]:Show()
      end if

      if !Empty( aGet[ ( dbfAlbCliL )->( fieldpos( "nMedDos" ) ) ] ) .and. oUndMedicion:oDbf:nDimension >= 2 .and. !Empty( oUndMedicion:oDbf:cTextoDim2 )
         aGet[ ( dbfAlbCliL )->( fieldpos( "nMedDos" ) ) ]:oSay:SetText( oUndMedicion:oDbf:cTextoDim2 )
         aGet[ ( dbfAlbCliL )->( fieldpos( "nMedDos" ) ) ]:Show()
      end if

      if !Empty( aGet[ ( dbfAlbCliL )->( fieldpos( "nMedTre" ) ) ] ) .and. oUndMedicion:oDbf:nDimension >= 3 .and. !Empty( oUndMedicion:oDbf:cTextoDim3 )
         aGet[ ( dbfAlbCliL )->( fieldpos( "nMedTre" ) ) ]:oSay:SetText( oUndMedicion:oDbf:cTextoDim3 )
         aGet[ ( dbfAlbCliL )->( fieldpos( "nMedTre" ) ) ]:Show()
      end if

   end if

   /*
   Mostramos u ocultamos las tarifas por líneas--------------------------------
   */

   if Empty( aTmp[ _NTARLIN ] )
      if !Empty( aGet[ _NTARLIN ] )
         aGet[ _NTARLIN ]:cText( aTmpAlb[ _NTARIFA ] )
      else
         aTmp[ _NTARLIN ]     := aTmpAlb[ _NTARIFA ]
      end if
   end if

   if !Empty( aGet[ _NTARLIN ] )
      if !uFieldEmpresa( "lPreLin" )
         aGet[ _NTARLIN ]:Hide()
      else
         aGet[ _NTARLIN ]:Show()
      end if
   end if

   /*
   Focus y validaci¢n----------------------------------------------------------
   */

   if !Empty( oFld )
      oFld:SetOption( 1 )
   end if

   if !Empty( oTotal )
      oTotal:cText( 0 )
   end if

   if !Empty( aGet[ _CTIPMOV ] )
      aGet[ _CTIPMOV ]:lValid()
   end if

   if !Empty( aGet[ _CALMLIN ] )
      aGet[ _CALMLIN ]:lValid()
   end if

Return nil

//---------------------------------------------------------------------------//

/*
Calcula totales en las lineas de Detalle
*/

STATIC FUNCTION lCalcDeta( aTmp, aTmpAlb, nDouDiv, oTotal, oMargen, cCodDiv, lTotal )

   local nCalculo
   local nUnidades
   local nCosto
   local nMargen
   local nRentabilidad
   local nBase    := 0

   DEFAULT lTotal := .f.

   if aTmp[ __LALQUILER ]
      nCalculo    := aTmp[ _NSATALQ  ]
   else
      nCalculo    := aTmp[ _NSATUNIT  ]
   end if

   nCalculo       -= aTmp[ _NDTODIV  ]

   /*
   Unidades
   */

   nUnidades      := nTotNAlbCli( aTmp )

   /*
   IVMH
   */

   if !aTmp[ _LIVALIN ]
      if aTmp[ _LVOLIMP ]
         nCalculo += aTmp[ _NVALIMP ] * NotCero( aTmp[ _NVOLUMEN ] )
      else
         nCalculo += aTmp[ _NVALIMP ]
      end if
   end if

   nCalculo       *= nUnidades

   /*
   Transporte------------------------------------------------------------------
   */

   if aTmp[ _NIMPTRN ] != 0
      nCalculo     += aTmp[ _NIMPTRN ] * nUnidades
   end if

   /*
   Descuentos------------------------------------------------------------------
   */

   if aTmp[ _NDTO    ] != 0
      nCalculo    -= nCalculo * aTmp[ _NDTO    ] / 100
   end if

   if aTmp[ _NDTOPRM ] != 0
      nCalculo    -= nCalculo * aTmp[ _NDTOPRM ] / 100
   end if

   /*
   Calculo del margen y rentabilidad-------------------------------------------
   */

   nCosto            := nUnidades * aTmp[ _NCOSDIV ]

   if aTmp[ _LIVALIN ] .and. aTmp[ _NIVA ] != 0
      nMargen        := nCalculo - Round( nCalculo / ( 100 / aTmp[ _NIVA ] + 1 ), nRouDiv )
   else
      nMargen        := nCalculo
   end if

   nBase             := nMargen

   nMargen           -= nCosto

   if nCalculo == 0
      nRentabilidad  := 0
   else
      nRentabilidad  := nRentabilidad( nCalculo, 0, nCosto )
   end if

   /*
   Punto Verde-----------------------------------------------------------------
   */

   if aTmpAlb[ _LOPERPV ]
      nCalculo       += nUnidades * aTmp[ _NPNTVER ]
   end if

   if !Empty( oTotal )
      oTotal:cText( Round( nCalculo, nDouDiv ) )
   end if

   if oMargen != nil
      oMargen:cText( AllTrim( Trans( nMargen, cPorDiv ) + AllTrim( cSimDiv( cCodDiv, dbfDiv ) ) + " : " + AllTrim( Trans( nRentabilidad, "999.99" ) ) + "%" ) )
   end if

   if !Empty( oComisionLinea )
      oComisionLinea:cText( Round( ( nBase * aTmp[ _NCOMAGE ] / 100 ), nRouDiv ) )
   end if

RETURN ( if( !lTotal, .t., nCalculo ) )

//--------------------------------------------------------------------------//

FUNCTION nDtoUAlbCli( dbfTmpLin, nDec, nVdv )

   local nCalculo := ( dbfTmpLin )->nDtoDiv

   DEFAULT nDec   := 0
   DEFAULT nVdv   := 1

	IF nVdv != 0
      nCalculo    := ( dbfTmpLin )->nDtoDiv / nVdv
	END IF

RETURN ( round( nCalculo, nDec ) )

//---------------------------------------------------------------------------//

/*
Funcion Auxiliar para A¤adir lineas de detalle a un albaran
*/

STATIC FUNCTION AppDeta( oBrwLin, bEdtDet, aTmpAlb, lTot, nMode, cCodArt )

   DEFAULT lTot := .f.

   WinAppRec( oBrwLin, bEdtDet, dbfTmpLin, lTot, cCodArt, aTmpAlb )

RETURN ( RecalculaTotal( aTmpAlb ) )

//---------------------------------------------------------------------------//

function nTotFAlbCli( cCodArt, dbfAlbCliT, dbfAlbCliL )

   local nTotVta        := 0
   local nRecno         := ( dbfAlbCliL )->( Recno() )

   if ( dbfAlbCliL )->( dbSeek( cCodArt ) )

      while ( dbfAlbCliL )->cRef == cCodArt .and. !( dbfAlbCliL )->( eof() )

         If !( dbfAlbCliL )->lTotLin .and. !lFacAlbCli( ( dbfAlbCliL )->cSerAlb + Str( ( dbfAlbCliL )->nNumFac ) + ( dbfAlbCliL )->cSufAlb, dbfAlbCliT )
            nTotVta     += nTotNAlbCli( dbfAlbCliL )
         end if

         ( dbfAlbCliL )->( dbSkip() )

      end while

   end if

   ( dbfAlbCliL )->( dbGoTo( nRecno ) )

return ( nTotVta )

//----------------------------------------------------------------------------//

FUNCTION lFacAlbCli( cAlbCli, uAlbCliT )

   local lFacAlb  := .f.

   if ValType( uAlbCliT ) == "C"

      if ( uAlbCliT )->( dbSeek( cAlbCli ) )
         lFacAlb  := ( uAlbCliT )->lFacturado
      end if

   else

      if uAlbCliT:Seek( cAlbCli )
         lFacAlb  := uAlbCliT:lFacturado
      end if

   end if

RETURN ( lFacAlb )

//---------------------------------------------------------------------------//

STATIC FUNCTION LoaArt( cCodArt, aTmp, aGet, aTmpAlb, oStkAct, oSayPr1, oSayPr2, oSayVp1, oSayVp2, bmpImage, nMode, lFocused )

   local nDtoAge
   local cCodFam
   local cPrpArt
   local nCosPro
   local nPrePro     := 0
   local nImpAtp     := 0
   local nImpOfe     := 0
   local lChgCodArt  := ( Empty( cOldCodArt ) .or. Rtrim( cOldCodArt ) != Rtrim( cCodArt ) )
   local nPosComa
   local cProveedor
   local nTarOld     := aTmp[ _NTARLIN ]
   local nNumDto     := 0

   DEFAULT lFocused  := .t.

   if Empty( cCodArt )

      if lRetCodArt()
         MsgStop( "No se pueden añadir líneas sin codificar" )
         return .f.
      end if

      if Empty( aTmp[ _NIVA ] )
         aGet[ _NIVA ]:bWhen      := {|| .t. }
      end if

      if !Empty( aGet[ _CDETALLE ] )
          aGet[ _CDETALLE ]:cText( Space( 50 ) )
      end if

      aGet[_CDETALLE]:bWhen      := {|| .t. }
      aGet[_CDETALLE]:Hide()

      if !Empty( aGet[ _MLNGDES ] )
          aGet[ _MLNGDES ]:Show()
      end if

      if lFocused .and. !Empty( aGet[ _MLNGDES ] )
        aGet[ _MLNGDES ]:SetFocus()
      end if

   else

      if lModIva()
         aGet[ _NIVA ]:bWhen      := {|| .t. }
      else
         aGet[ _NIVA ]:bWhen      := {|| .f. }
      end if

      /*
      Primero buscamos por codigos de barra y por referencia de proveedor
      */

      if "," $ cCodArt
         nPosComa                := At( ",", cCodArt )
         cProveedor              := RJust( Left( cCodArt, nPosComa - 1 ), "0", RetNumCodPrvEmp() )
         cCodArt                 := cSeekProveedor( cCodArt, dbfArtPrv )
      else
         cCodArt                 := cSeekCodebar( cCodArt, dbfCodebar, dbfArticulo )
      end if

      /*
      Ahora buscamos por el codigo interno
      */

      if ( dbfArticulo )->( dbSeek( cCodArt ) ) .or. ( dbfArticulo )->( dbSeek( Upper( cCodArt ) ) )

         if ( dbfArticulo )->lObs
            MsgStop( "Artículo catalogado como obsoleto" )
            return .f.
         end if

         if ( lChgCodArt )

            cCodArt              := ( dbfArticulo )->Codigo
            aTmp[ _CREF   ]      := cCodArt
            aGet[ _CREF   ]:cText( cCodArt )

            if ( dbfArticulo )->lMosCom .and. !Empty( ( dbfArticulo )->mComent )
               MsgStop( Trim( ( dbfArticulo )->mComent ) )
            end if

            if !Empty( cProveedor )
               aTmp[ _CCODPRV ]  := cProveedor
               aTmp[ _CNOMPRV ]  := AllTrim( RetProvee( cProveedor ) )
               aTmp[ _CREFPRV ]  := Padr( cRefPrvArt( cCodArt, Padr( cProveedor, 12 ) , dbfArtPrv ), 18 )
            else
               aTmp[ _CCODPRV ]  := ( dbfArticulo )->cPrvHab
               aTmp[ _CNOMPRV ]  := AllTrim( RetProvee( ( dbfArticulo )->cPrvHab ) )
               aTmp[ _CREFPRV ]  := Padr( cRefPrvArt( cCodArt, ( dbfArticulo )->cPrvHab , dbfArtPrv ), 18 )
            end if

            aGet[_CDETALLE ]:show()
            aGet[_MLNGDES  ]:hide()

            aGet[_CDETALLE ]:cText( ( dbfArticulo )->Nombre )

            /*
            Descripciones largas--------------------------------------------------
            */

            if aGet[ _MLNGDES ] != nil
               aGet[ _MLNGDES ]:cText( ( dbfArticulo )->Descrip )
            else
               aTmp[ _MLNGDES ] := ( dbfArticulo )->Descrip
            end if

            if !Empty( aGet[ _DESCRIP ] )
               aGet[ _DESCRIP ]:cText( ( dbfArticulo )->Descrip )
            else
               aTmp[ _DESCRIP ]     := ( dbfArticulo )->Descrip
            end if

            /*
            Peso y volumen
            -------------------------------------------------------------------
            */

            if !Empty( aGet[ _NPESOKG ] )
               aGet[ _NPESOKG  ]:cText( ( dbfArticulo )->nPesoKg )
            else
               aGet[ _NPESOKG  ] := ( dbfArticulo )->nPesoKg
            end if

            if !Empty( aGet[ _CPESOKG ] )
                aGet[ _CPESOKG ]:cText( ( dbfArticulo )->cUndDim )
            else
                aGet[ _CPESOKG ] := ( dbfArticulo )->cUndDim
            end if

            if !Empty( aGet[ _NVOLUMEN ] )
               aGet[ _NVOLUMEN ]:cText( ( dbfArticulo )->nVolumen )
            else
               aGet[ _NVOLUMEN ] := ( dbfArticulo )->nVolumen
            end if

            if !Empty( aGet[ _CUNIDAD ] )
                aGet[ _CUNIDAD ]:cText( ( dbfArticulo )->cUnidad )
                aGet[ _CUNIDAD ]:lValid()
            else
                aTmp[ _CUNIDAD ] := ( dbfArticulo )->cUnidad
            end if

            if !Empty( aGet[ _CVOLUMEN ] )
                aGet[ _CVOLUMEN ]:cText( ( dbfArticulo )->cVolumen )
            else
                aTmp[ _CVOLUMEN ]:= ( dbfArticulo )->cVolumen
            end if

            /*
            Lotes
            -------------------------------------------------------------------
            */

            if ( dbfArticulo )->lLote

               if !Empty( aGet[ _CLOTE ] )

                  aGet[ _CLOTE ]:Show()

                  if Empty( aGet[ _CLOTE ]:VarGet() )
                     aGet[ _CLOTE ]:cText( ( dbfArticulo )->cLote )
                     aGet[ _CLOTE ]:lValid()
                  end if

               else

                  if Empty( aTmp[ _CLOTE ] )
                     aTmp[ _CLOTE ] := ( dbfArticulo )->cLote
                  end if

               end if

               aTmp[ _LLOTE ] := ( dbfArticulo )->lLote

               if !Empty( aGet[ _DFECCAD ] )

                  aGet[ _DFECCAD ]:Show()

                  if Empty( aGet[ _DFECCAD ]:VarGet() )
                     aGet[ _DFECCAD ]:cText( dFechaCaducidadLote( aTmp[ _CREF ], aTmp[ _CVALPR1 ], aTmp[ _CVALPR2 ], aTmp[ _CLOTE ], dbfAlbPrvL, dbfFacPrvL ) )
                  end if

               end if

            else

               if !Empty( aGet[ _CLOTE ] )
                  aGet[ _CLOTE ]:Hide()
               end if

               if !Empty( aGet[ _DFECCAD ] )
                  aGet[ _DFECCAD ]:Hide()
               end if

            end if

            /*
            Cogemos las familias y los grupos de familias----------------------
            */

            cCodFam              := ( dbfArticulo )->Familia

            if !Empty( cCodFam )

               if aGet[ _CCODFAM ] != nil
                  aGet[ _CCODFAM ]:cText( cCodFam )
                  aGet[ _CCODFAM ]:lValid()
               else
                  aTmp[ _CCODFAM ]  := cCodFam
               end if

               if aGet[ _CGRPFAM ] != nil
                  aGet[ _CGRPFAM ]:cText( cGruFam( cCodFam, dbfFamilia ) )
                  aGet[ _CGRPFAM ]:lValid()
               else
                  aTmp[ _CGRPFAM ]  := cGruFam( cCodFam, dbfFamilia )
               end if

               if aGet[ _CCODFRA ] != nil
                  aGet[ _CCODFRA ]:cText( cCodFra( cCodFam, dbfFamilia ) )
                  aGet[ _CCODFRA ]:lValid()
               else
                  aTmp[ _CCODFRA ]  := cCodFra( cCodFam, dbfFamilia )
               end if

            else

               if aGet[ _CCODFAM ] != nil
                  aGet[ _CCODFAM ]:cText( Space( 8 ) )
                  aGet[ _CCODFAM ]:lValid()
               end if

               if aGet[ _CGRPFAM ] != nil
                  aGet[ _CGRPFAM ]:cText( Space( 3 ) )
                  aGet[ _CGRPFAM ]:lValid()
               end if

               if aGet[ _CCODFRA ] != nil
                  aGet[ _CCODFRA ]:cText( Space( 3 ) )
                  aGet[ _CCODFRA ]:lValid()
               end if

            end if

            /*
            Tratamientos kits-----------------------------------------------------
            */

            if ( dbfArticulo )->lKitArt

               aTmp[ _LKITART ]     := ( dbfArticulo )->lKitArt                        // Marcamos como padre del kit
               aTmp[ _LIMPLIN ]     := lImprimirCompuesto( ( dbfArticulo )->Codigo, dbfArticulo ) // 1 Todos, 2 Compuesto
               aTmp[ _LKITPRC ]     := lPreciosCompuestos( ( dbfArticulo )->Codigo, dbfArticulo ) // 1 Todos, 2 Compuesto

               if lStockCompuestos( ( dbfArticulo )->Codigo, dbfArticulo )

                  if aGet[ _NCTLSTK ] != nil
                     aGet[ _NCTLSTK ]:SetOption( ( dbfArticulo )->nCtlStock )
                  else
                     aTmp[ _NCTLSTK ]  := ( dbfArticulo )->nCtlStock
                  end if

               else

                  if aGet[ _NCTLSTK ] != nil
                     aGet[ _NCTLSTK ]:SetOption( STOCK_NO_CONTROLAR )
                  else
                     aTmp[ _NCTLSTK ]  := STOCK_NO_CONTROLAR
                  end if

               end if

            else

               aTmp[ _LIMPLIN ]     := .f.

               if aGet[ _NCTLSTK ] != nil
                  aGet[ _NCTLSTK ]:SetOption( ( dbfArticulo )->nCtlStock )
               else
                  aTmp[ _NCTLSTK ]  := ( dbfArticulo )->nCtlStock
               end if

            end if

            /*
            Preguntamos si el regimen de IGIC es distinto de Exento-------------
            */

            if aTmpAlb[ _NREGIVA ] <= 1
               aGet[ _NIVA ]:cText( nIva( dbfIva, ( dbfArticulo )->TipoIva ) )
               aTmp[ _NREQ ]        := nReq( dbfIva, ( dbfArticulo )->TipoIva )
            end if

            /*
            Ahora recogemos el impuesto especial si lo hay---------------------
            */

            if !Empty( ( dbfArticulo )->cCodImp )
               aTmp[ _CCODIMP ]     := ( dbfArticulo )->cCodImp
               aGet[ _NVALIMP ]:cText( oNewImp:nValImp( ( dbfArticulo )->cCodImp ) )

               aTmp[ _LVOLIMP ]     := RetFld( ( dbfArticulo )->cCodImp, oNewImp:oDbf:cAlias, "lIvaVol" )

            end if

            if ( dbfArticulo )->nCajEnt != 0
               aGet[_NCANENT ]:cText( ( dbfArticulo )->nCajEnt )
            end if

            if ( dbfArticulo )->nUniCaja != 0
               aGet[_NUNICAJA]:cText( ( dbfArticulo )->nUniCaja )
            end if

            /*
            Meses de grantia---------------------------------------------------
            */
            if !Empty( aGet[ _NMESGRT ] )
               aGet[ _NMESGRT ]:cText( ( dbfArticulo )->nMesGrt )
            end if

            /*
            Si la comisi¢n del articulo hacia el agente es distinto de cero----
            */

            aGet[ _NCOMAGE ]:cText( aTmpAlb[ _NPCTCOMAGE ] )

            /*
            Tomamos el valor del stock y anotamos si nos dejan vender sin stock
            */

            if oStkAct != nil .and. aTmp[ _NCTLSTK ] <= 1
               oStock:nPutStockActual( cCodArt, aTmp[ _CALMLIN ], , , , aTmp[ _LKITART ], aTmp[ _NCTLSTK ], oStkAct )
            end if

            /*
            No permitir venta sin stock----------------------------------------
            */

            aTmp[ _LMSGVTA ]     := ( dbfArticulo )->lMsgVta
            aTmp[ _LNOTVTA ]     := ( dbfArticulo )->lNotVta

            if ( dbfArticulo )->lFacCnv
               aTmp[ _NFACCNV ]  := ( dbfArticulo )->nFacCnv
            end if

            /*
            Tipo de articulo---------------------------------------------------
            */

            if !Empty( aGet[_CCODTIP ] )
               aGet[_CCODTIP ]:cText( ( dbfArticulo )->cCodTip )
            end if

            /*
            Imagen del producto------------------------------------------------
            */

            if !Empty( aGet[ _CIMAGEN ] )
               aGet[ _CIMAGEN ]:cText( ( dbfArticulo )->cImagen )
            else
               aTmp[ _CIMAGEN ]     := ( dbfArticulo )->cImagen
            end if

            if !Empty( bmpImage )
               if !Empty( aTmp[ _CIMAGEN ] )
                  bmpImage:Show()
                  bmpImage:LoadBmp( cFileBitmap( cPatImg(), aTmp[ _CIMAGEN ] ) )
               else
                  bmpImage:Hide()
               end if
            end if

            /*
            Código de la frase publicitaria------------------------------------
            */

            if !Empty( ( dbfArticulo )->cCodFra )

               if aGet[ _CCODFRA ] != nil
                  aGet[ _CCODFRA ]:cText( ( dbfArticulo )->cCodFra )
                  aGet[ _CCODFRA ]:lValid()
               else
                  aTmp[ _CCODFRA ]  := ( dbfArticulo )->cCodFra
               end if

            end if

            /*
            Buscamos la familia del articulo y anotamos las propiedades--------
            */

            aTmp[_CCODPR1 ]   := ( dbfArticulo )->cCodPrp1
            aTmp[_CCODPR2 ]   := ( dbfArticulo )->cCodPrp2

            if !Empty( aTmp[ _CCODPR1 ] )

               if aGet[ _CVALPR1 ] != nil
                  aGet[ _CVALPR1 ]:Show()
                  if lFocused
                     aGet[ _CVALPR1 ]:SetFocus()
                  end if
               end if

               if oSayPr1 != nil
                  oSayPr1:SetText( retProp( ( dbfArticulo )->cCodPrp1, dbfPro ) )
                  oSayPr1:show()
               end if

               if oSayVp1 != nil
                  oSayVp1:SetText( "" )
                  oSayVp1:Show()
               end if

            else

               if !Empty( aGet[ _CVALPR1 ] )
                  aGet[ _CVALPR1 ]:hide()
               end if

               if !Empty( oSayPr1 )
                  oSayPr1:hide()
               end if

               if !Empty( oSayVp1 )
                  oSayVp1:hide()
               end if

            end if

            if !empty( aTmp[ _CCODPR2 ] )

               if aGet[ _CVALPR2 ] != nil
                  aGet[ _CVALPR2 ]:show()
               end if

               if oSayPr2 != nil
                  oSayPr2:SetText( retProp( ( dbfArticulo )->cCodPrp2, dbfPro ) )
                  oSayPr2:show()
               end if

               if oSayVp2 != nil
                  oSayVp2:SetText( "" )
                  oSayVp2:Show()
               end if

            else

               if !Empty( aGet[ _CVALPR2 ] )
                  aGet[ _CVALPR2 ]:hide()
               end if

               if !Empty( oSayPr2 )
                  oSayPr2:hide()
               end if

               if !Empty( oSayVp2 )
                  oSayVp2:hide()
               end if

            end if

         end if

         /*
         He terminado de meter todo lo que no son precios----------------------
         ahora es cuando meteré los precios con todas las opciones posibles----
         */

         cPrpArt              := aTmp[ _CCODPR1 ] + aTmp[ _CCODPR2 ] + aTmp[ _CVALPR1 ] + aTmp[ _CVALPR2 ]

         if ( lChgCodArt ) .or. ( cPrpArt != cOldPrpArt )

            // Tomamos el valor de la familia----------------------------------

            if nMode == APPD_MODE
               cCodFam        := RetFamArt( cCodArt, dbfArticulo )
            else
               cCodFam        := aTmp[_CCODFAM]
            end if

            //--Tomamos el precio recomendado, el costo y el punto verde--//

            aTmp[_NPVSATC ]      := ( dbfArticulo )->PvpRec

            if !Empty( aGet[_NPNTVER ] )
               aGet[_NPNTVER ]:cText( ( dbfArticulo )->nPntVer1 )
            end if

            /*
            Cargamos los costos
            */

            if !uFieldEmpresa( "lCosAct" )
               nCosPro           := oStock:nCostoMedio( aTmp[ _CREF ], aTmp[ _CALMLIN ], aTmp[ _CCODPR1 ], aTmp[ _CVALPR1 ], aTmp[ _CCODPR2 ], aTmp[ _CVALPR2 ] )
               if nCosPro == 0
                  nCosPro        := nCosto( aTmp[ _CREF ], dbfArticulo, dbfKit, .f., , dbfDiv )
               end if
            else
               nCosPro           := nCosto( aTmp[ _CREF ], dbfArticulo, dbfKit, .f., , dbfDiv )
            end if

            if aGet[ _NCOSDIV ] != nil
               aGet[ _NCOSDIV ]:cText( nCosPro )
            else
               aTmp[ _NCOSDIV ]  := nCosPro
            end if

            /*
            Descuento de artículo----------------------------------------------
            */

            nNumDto              := RetFld( aTmpAlb[ _CCODCLI ], dbfClient, "nDtoArt" )

            if nNumDto != 0

               do case
                  case nNumDto == 1

                     if !Empty( aGet[ _NDTO ] )
                        aGet[ _NDTO ]:cText( ( dbfArticulo )->nDtoArt1 )
                        aTmp[ _NDTO ]     := ( dbfArticulo )->nDtoArt1
                     else
                        aTmp[ _NDTO ]     := ( dbfArticulo )->nDtoArt1
                     end if

                  case nNumDto == 2

                     if !Empty( aGet[ _NDTO ] )
                        aGet[ _NDTO ]:cText( ( dbfArticulo )->nDtoArt2 )
                        aTmp[ _NDTO ]     := ( dbfArticulo )->nDtoArt2
                     else
                        aTmp[ _NDTO ]     := ( dbfArticulo )->nDtoArt2
                     end if

                  case nNumDto == 3

                     if !Empty( aGet[ _NDTO ] )
                        aGet[ _NDTO]:cText( ( dbfArticulo )->nDtoArt3 )
                        aTmp[ _NDTO ]     := ( dbfArticulo )->nDtoArt3
                     else
                        aTmp[ _NDTO ]     := ( dbfArticulo )->nDtoArt3
                     end if

                  case nNumDto == 4

                     if !Empty( aGet[ _NDTO ] )
                        aGet[ _NDTO ]:cText( ( dbfArticulo )->nDtoArt4 )
                        aTmp[ _NDTO ]     := ( dbfArticulo )->nDtoArt4
                     else
                        aTmp[ _NDTO ]     := ( dbfArticulo )->nDtoArt4
                     end if

                  case nNumDto == 5

                     if !Empty( aGet[ _NDTO ] )
                        aGet[ _NDTO ]:cText( ( dbfArticulo )->nDtoArt5 )
                        aTmp[ _NDTO ]     := ( dbfArticulo )->nDtoArt5
                     else
                        aTmp[ _NDTO ]     := ( dbfArticulo )->nDtoArt5
                     end if

                  case nNumDto == 6

                     if !Empty( aGet[ _NDTO ] )
                        aGet[ _NDTO]:cText( ( dbfArticulo )->nDtoArt6 )
                        aTmp[ _NDTO ]     := ( dbfArticulo )->nDtoArt6
                     else
                        aTmp[ _NDTO ]     := ( dbfArticulo )->nDtoArt6
                     end if

               end case

            end if

            /*
            Vemos si hay descuentos en las familias----------------------------
            */

            if aTmp[ _NDTO ] == 0

               if !Empty( aGet[ _NDTO ] )
                  aGet[ _NDTO ]:cText( nDescuentoFamilia( cCodFam, dbfFamilia ) )
               else
                  aTmp[ _NDTO ]     := nDescuentoFamilia( cCodFam, dbfFamilia )
               end if

            end if

            /*
            Cargamos el codigo de las unidades---------------------------------
            */

            if !Empty( aGet[ _CUNIDAD ] )
               aGet[ _CUNIDAD ]:cText( ( dbfArticulo )->cUnidad )
            else
               aTmp[ _CUNIDAD ]  := ( dbfArticulo )->cUnidad
            end if

            // Tomamos el precio del articulo dependiento de las propiedades---

            nPrePro           := nPrePro( aTmp[ _CREF ], aTmp[ _CCODPR1 ], aTmp[ _CVALPR1 ], aTmp[ _CCODPR2 ], aTmp[ _CVALPR2 ], aTmp[ _NTARLIN ], aTmpAlb[ _LIVAINC ], dbfArtDiv, dbfTarPreL, aTmpAlb[_CCODTAR] )
            if nPrePro == 0
               if !Empty( aGet[ _NSATUNIT ] )
                  aGet[ _NSATUNIT ]:cText( nRetPreArt( aTmp[ _NTARLIN ], aTmpAlb[ _CDIVALB ], aTmpAlb[_LIVAINC], dbfArticulo, dbfDiv, dbfKit, dbfIva, , aGet[ _NTARLIN ] ) )
               end if
            else
               aGet[ _NSATUNIT ]:cText( nPrePro )
            end if

            if aTmp[ __LALQUILER ]
               aGet[ _NSATUNIT ]:cText( 0 )
               aGet[ _NSATALQ ]:cText( nPreAlq( aTmp[ _CREF ], aTmp[ _NTARLIN ], aTmpAlb[_LIVAINC], dbfArticulo ) )
            end if

            /*
            Precios por tarifas------------------------------------------------
            */

            if !Empty( aTmpAlb[ _CCODTAR ] )

               /*
               Precio
               */

               nImpOfe     := RetPrcTar( cCodArt, aTmpAlb[ _CCODTAR ], aTmp[ _CCODPR1 ], aTmp[ _CCODPR2 ], aTmp[ _CVALPR1 ], aTmp[ _CVALPR2 ], dbfTarPreL, aTmp[ _NTARLIN ] )
               if nImpOfe  != 0
                  aGet[ _NSATUNIT ]:cText( nImpOfe )
               end if

               //--Descuento porcentual--//

               nImpOfe     := RetPctTar( cCodArt, cCodFam, aTmpAlb[ _CCODTAR ], aTmp[ _CCODPR1 ], aTmp[ _CCODPR2 ], aTmp[ _CVALPR1 ], aTmp[ _CVALPR2 ], dbfTarPreL )
               if nImpOfe  != 0
                  aGet[_NDTO    ]:cText( nImpOfe )
               end if

               //--Descuento Lineal--//
               nImpOfe     := RetLinTar( cCodArt, cCodFam, aTmpAlb[_CCODTAR], aTmp[_CCODPR1], aTmp[_CCODPR2], aTmp[_CVALPR1], aTmp[_CVALPR2], dbfTarPreL )
               if nImpOfe  != 0
                  aGet[_NDTODIV ]:cText( nImpOfe )
               end if

               //--comisión de agente--//

               nImpOfe     := RetComTar( cCodArt, cCodFam, aTmpAlb[_CCODTAR], aTmp[_CCODPR1], aTmp[_CCODPR2], aTmp[_CVALPR1], aTmp[_CVALPR2], aTmpAlb[_CCODAGE], dbfTarPreL, dbfTarPreS )

               if nImpOfe  != 0
                  aGet[_NCOMAGE ]:cText( nImpOfe )
               end if

               //--Descuento de promoci¢n--//

               nImpOfe     := RetDtoPrm( cCodArt, cCodFam, aTmpAlb[_CCODTAR], aTmp[_CCODPR1], aTmp[_CCODPR2], aTmp[_CVALPR1], aTmp[_CVALPR2], aTmpAlb[_DFECALB], dbfTarPreL )
               if nImpOfe  != 0
                  aGet[_NDTOPRM]:cText( nImpOfe )
               end if

               //--Descuento de promoci¢n para agente--//

               nDtoAge     := RetDtoAge( cCodArt, cCodFam, aTmpAlb[_CCODTAR], aTmp[_CCODPR1], aTmp[_CCODPR2], aTmp[_CVALPR1], aTmp[_CVALPR2], aTmpAlb[_DFECALB], aTmpAlb[_CCODAGE], dbfTarPreL, dbfTarPreS )
               if nDtoAge  != 0
                  aGet[ _NCOMAGE ]:cText( nDtoAge )
               end if

            end if

            /*
            Chequeamos situaciones especiales y comprobamos las fechas
            */

            do case
               case  lSeekAtpArt( aTmpAlb[ _CCODCLI ] + cCodArt, aTmp[ _CCODPR1 ] + aTmp[ _CCODPR2 ], aTmp[ _CVALPR1 ] + aTmp[ _CVALPR2 ], aTmpAlb[ _DFECALB ], dbfCliAtp ) .and.;
                  ( dbfCliAtp )->lAplAlb

                  nImpAtp     := nImpAtp( nTarOld, dbfCliAtp, , , aGet[ _NTARLIN ] )
                  if nImpAtp  != 0
                     aGet[ _NSATUNIT ]:cText( nImpAtp )
                  end if

                  /*
                  Descuentos por tarifas de precios----------------------------
                  */

                  nImpAtp     := nDtoAtp( nTarOld, dbfCliAtp )
                  if nImpAtp  != 0
                     aGet[ _NDTO ]:cText( nImpAtp )
                  end if

                  /*
                  Descuento por promocion--------------------------------------
                  */

                  if ( dbfCliAtp )->nDprArt != 0
                     aGet[ _NDTOPRM ]:cText( ( dbfCliAtp )->nDprArt )
                  end if

                  if ( dbfCliAtp )->NCOMAGE != 0
                     aGet[ _NCOMAGE ]:cText( ( dbfCliAtp )->nComAge )
                  end if

                  if ( dbfCliAtp )->nDtoDiv != 0
                     aGet[ _NDTODIV ]:cText( ( dbfCliAtp )->nDtoDiv )
                  end if

               //--Atipicas de clientes por familias--//

               case  lSeekAtpFam( aTmpAlb[ _CCODCLI ] + aTmp[ _CCODFAM ], aTmpAlb[ _DFECALB ], dbfCliAtp ) .and. ;
                  ( dbfCliAtp )->lAplAlb

                  if ( dbfCliAtp )->nDtoArt != 0
                     aGet[_NDTO    ]:cText( ( dbfCliAtp )->nDtoArt )
                  end if

                  if ( dbfCliAtp )->nDprArt != 0
                     aGet[ _NDTOPRM ]:cText( ( dbfCliAtp )->nDprArt )
                  end if

                  if ( dbfCliAtp )->nComAge != 0
                     aGet[ _NCOMAGE ]:cText( ( dbfCliAtp )->nComAge )
                  end if

                  if ( dbfCliAtp )->nDtoDiv != 0
                     aGet[ _NDTODIV ]:cText( ( dbfCliAtp )->nDtoDiv )
                  end if

            end case

            ValidaMedicion( aTmp, aGet )

         end if

         /*
         Buscamos si hay ofertas-----------------------------------------------
         */

         lBuscaOferta( cCodArt, aGet, aTmp, aTmpAlb, dbfOferta, dbfArticulo, dbfDiv, dbfKit, dbfIva  )

         /*
         Cargamos los valores para los cambios---------------------------------
         */

         cOldPrpArt     := cPrpArt
         cOldCodArt     := cCodArt

         /*
         Solo pueden modificar los precios los administradores--------------
         */

         if Empty( aTmp[ _NSATUNIT ] ) .or. lUsrMaster() .or. oUser():lCambiarPrecio()

            if !Empty( aGet[ _NSATUNIT ] )
                aGet[ _NSATUNIT ]:HardEnable()
            end if

             aGet[ _NIMPTRN  ]:HardEnable()

            if !Empty( aGet[ _NPNTVER ] )
               aGet[ _NPNTVER  ]:HardEnable()
            end if

            aGet[ _NDTO     ]:HardEnable()
            aGet[ _NDTOPRM  ]:HardEnable()

            if !Empty( aGet[ _NDTODIV ] )
               aGet[ _NDTODIV  ]:HardEnable()
            end if

         else
            aGet[ _NSATUNIT ]:HardDisable()
            aGet[ _NIMPTRN  ]:HardDisable()
            aGet[ _NPNTVER  ]:HardDisable()
            aGet[ _NDTO     ]:HardDisable()
            aGet[ _NDTOPRM  ]:HardDisable()
            aGet[ _NDTODIV  ]:HardDisable()
         end if

      else

         MsgStop( "Artículo no encontrado" )
         Return ( .f. )

      end if

   end if

RETURN ( .t. )

//--------------------------------------------------------------------------//

STATIC FUNCTION SaveDeta( aTmp, aTmpAlb, oFld, aGet, oBrw, bmpImage, oDlg, nMode, oSayPr1, oSayPr2, oSayVp1, oSayVp2, oGet2, oStkAct, nStkAct, oTotal, cCodArt, oBtn, oBtnSer )

   local aXbyStr
   local nTotUnd  := 0
   local aClo     := aClone( aTmp )

   oBtn:SetFocus()

   if !aGet[ _CREF ]:lValid()
      return nil
   end if

   if !lMoreIva( aTmp[ _NIVA ] )
      return nil
   end if

   if Empty( aTmp[ _CALMLIN ] )
      MsgStop( "Código de almacen no puede estar vacio" )
      aGet[ _CALMLIN ]:SetFocus()
      Return nil
   end if

   if !cAlmacen( aGet[ _CALMLIN ], dbfAlm )
      Return nil
   end if

   /*
   Comprobamos si tiene que introducir números de serie------------------------
   */

   if ( nMode == APPD_MODE ) .and. RetFld( aTmp[ _CREF ], dbfArticulo, "lNumSer" ) .and. !( dbfTmpSer )->( dbSeek( Str( aTmp[ _NNUMLIN ], 4 ) + aTmp[ _CREF ] ) )
      MsgStop( "Tiene que introducir números de serie para este artículo." )
      oBtnSer:Click()
      Return .f.
   end if

   if !Empty( aTmp[ _CREF ] ) .and. ( aTmp[ _LNOTVTA ] .or. aTmp[ _LMSGVTA ] )

      nTotUnd     := nTotNAlbCli( aTmp )

      if nMode == EDIT_MODE
         nTotUnd  -= nTotNAlbCli( dbfTmpLin )
      end if

      if nTotUnd  != 0

         do case
            case ( nStkAct - nTotUnd ) < 0

               if aTmp[ _LNOTVTA ]
                  MsgStop( "No hay stock suficiente, tenemos " + Alltrim( Trans( nStkAct, MasUnd() ) ) + " unidad(es) disponible(s)," + CRLF + "en almacén " + aTmp[ _CALMLIN ] + "." )
                  return nil
               end if

               if aTmp[ _LMSGVTA ]
                  if !ApoloMsgNoYes( "No hay stock suficiente, tenemos " + Alltrim( Trans( nStkAct, MasUnd() ) ) + " unidad(es) disponible(s)," + CRLF + " en almacén " + aTmp[ _CALMLIN ] + ".", "¿Desea continuar?" )
                     return nil
                  end if
               end if

            case ( nStkAct - nTotUnd ) < RetFld( aTmp[ _CREF ], dbfArticulo, "nMinimo"  )

               if aTmp[ _LMSGVTA ]
                  if !ApoloMsgNoYes( "El stock está por debajo del minimo.", "¿Desea continuar?" )
                     return nil
                  end if
               end if

         end case

      end if

   end if

   aTmp[ _NREQ ]  := nPReq( dbfIva, aTmp[ _NIVA ] )

   if nMode == APPD_MODE

      aTmp[ _CREF ]  := cCodArt

      if aTmp[ _LLOTE ]
         GraLotArt( aTmp[ _CREF ], dbfArticulo, aTmp[ _CLOTE ] )
      end if

      /*
      Chequeamos las ofertas X * Y
      */

      aXbYStr        := nXbYAtipica( aTmp[ _CREF ], aTmpAlb[ _CCODCLI ], aTmp[ _NCANENT ], aTmp[ _NUNICAJA ], aTmpAlb[ _DFECALB ], dbfCliAtp )

      if aXbYStr[ 1 ] == 0

         /*
         Chequeamos las ofertas por artículos X  *  Y--------------------------
         */

         if !aTmp[ _LLINOFE ]

            aXbyStr              := nXbYOferta( aTmp[ _CREF ], aTmpAlb[ _CCODCLI ], aTmpAlb[ _CCODGRP ], aTmp[ _NCANENT ], aTmp[ _NUNICAJA ], aTmpAlb[ _DFECALB ], dbfOferta, 1 )

            if aXbYStr[ 1 ] != 0
               aTmp[ _LLINOFE ]  := .t.
            end if

         end if

         /*
         Chequeamos las ofertas por familia X  *  Y----------------------------
         */

         if !aTmp[ _LLINOFE ]

            aXbyStr              := nXbYOferta( RetFld( aTmp[ _CREF ], dbfArticulo, "FAMILIA", "CODIGO" ), aTmpAlb[ _CCODCLI ], aTmpAlb[ _CCODGRP ], aTmp[ _NCANENT ], aTmp[ _NUNICAJA ], aTmpAlb[ _DFECALB ], dbfOferta, 2 )

            if aXbYStr[ 1 ] != 0
               aTmp[ _LLINOFE ]  := .t.
            end if

         end if

         /*
         Chequeamos las ofertas por tipo de artículos X  *  Y------------------
         */

         if !aTmp[ _LLINOFE ]

            aXbyStr              := nXbYOferta( RetFld( aTmp[ _CREF ], dbfArticulo, "CCODTIP", "CODIGO" ), aTmpAlb[ _CCODCLI ], aTmpAlb[ _CCODGRP ], aTmp[ _NCANENT ], aTmp[ _NUNICAJA ], aTmpAlb[ _DFECALB ], dbfOferta, 3 )

            if aXbYStr[ 1 ] != 0
               aTmp[ _LLINOFE ]  := .t.
            end if

         end if

         /*
         Chequeamos las ofertas por categoria X  *  Y--------------------------
         */

         if !aTmp[ _LLINOFE ]

            aXbyStr              := nXbYOferta( RetFld( aTmp[ _CREF ], dbfArticulo, "CCODCATE", "CODIGO" ), aTmpAlb[ _CCODCLI ], aTmpAlb[ _CCODGRP ], aTmp[ _NCANENT ], aTmp[ _NUNICAJA ], aTmpAlb[ _DFECALB ], dbfOferta, 4 )

            if aXbYStr[ 1 ] != 0
               aTmp[ _LLINOFE ]  := .t.
            end if

         end if

         /*
         Chequeamos las ofertas por temporada X  *  Y--------------------------
         */

         if !aTmp[ _LLINOFE ]

            aXbyStr              := nXbYOferta( RetFld( aTmp[ _CREF ], dbfArticulo, "CCODTEMP", "CODIGO" ), aTmpAlb[ _CCODCLI ], aTmpAlb[ _CCODGRP ], aTmp[ _NCANENT ], aTmp[ _NUNICAJA ], aTmpAlb[ _DFECALB ], dbfOferta, 5 )

            if aXbYStr[ 1 ] != 0
               aTmp[ _LLINOFE ]  := .t.
            end if

         end if

         /*
         Chequeamos las ofertas por fabricante X  *  Y-------------------------
         */

         if !aTmp[ _LLINOFE ]

            aXbyStr              := nXbYOferta( RetFld( aTmp[ _CREF ], dbfArticulo, "CCODFAB", "CODIGO" ), aTmpAlb[ _CCODCLI ], aTmpAlb[ _CCODGRP ], aTmp[ _NCANENT ], aTmp[ _NUNICAJA ], aTmpAlb[ _DFECALB ], dbfOferta, 6 )

            if aXbYStr[ 1 ] != 0
               aTmp[ _LLINOFE ]  := .t.
            end if

         end if

      end if

      /*
      si tenemos q reagalar unidades
      */

      if aXbYStr[ 1 ] != 0 .and. aXbYStr[ 2 ] != 0

         /*
         Tenemos oferta vamos a ver de q tipo
         */

         if aXbYStr[ 1 ] == 1

            /*
            Ofertas de cajas---------------------------------------------------
            */

            aTmp[ _NCANENT  ] -= aXbYStr[ 2 ]
            aClo              := aClone( aTmp )

            WinGather( aTmp, , dbfTmpLin, oBrw, nMode, nil, .f. )

            if aClo[ _LKITART ]
               AppendKit( aClo, aTmpAlb )
            end if

            /*
            Cajas a regalar----------------------------------------------------
            */

            aTmp[ _NCANENT  ] := aXbYStr[ 2 ]
            aTmp[ _NSATUNIT ] := 0

            WinGather( aTmp, aGet, dbfTmpLin, oBrw, nMode )

            if aClo[ _LKITART ]
               AppendKit( aClo, aTmpAlb )
            end if

         else

            /*
            Restamos las unidades q vamos a regalar al total de unidades y guardamos primer registro
            */

            if aTmp[ _NUNICAJA ] < 0
               aTmp[ _NUNICAJA ] += aXbYStr[ 2 ]
            else
               aTmp[ _NUNICAJA ] -= aXbYStr[ 2 ]
            end if

            WinGather( aTmp, , dbfTmpLin, oBrw, nMode, nil, .f. )

            if aClo[ _LKITART ]
               AppendKit( aClo, aTmpAlb )
            end if

            /*
            Unidades q vamos a regalar-----------------------------------------
            */

            if aTmp[ _NUNICAJA ] < 0
               aTmp[ _NUNICAJA ] := -( aXbYStr[ 2 ] )
            else
               aTmp[ _NUNICAJA ] := aXbYStr[ 2 ]
            end if

            aTmp[ _NSATUNIT ] := 0

            WinGather( aTmp, aGet, dbfTmpLin, oBrw, nMode )

            if aClo[ _LKITART ]
               AppendKit( aClo, aTmpAlb )
            end if

         end if

      else

         /*
         Guardamos el registro de manera normal
         */

         WinGather( aTmp, aGet, dbfTmpLin, oBrw, nMode )

         /*
         Guardamos los productos kits
         */

         if aClo[ _LKITART ]
            AppendKit( aClo, aTmpAlb )
         end if

      end if

   else

      /*
      Guardamos el registro de manera normal
      */

      WinGather( aTmp, aGet, dbfTmpLin, oBrw, nMode )

   end if

   /*
   Liberacion del bitmap-------------------------------------------------------
   */

   if !Empty( bmpImage )
       bmpImage:Hide()
   end if

   if !Empty( bmpImage )
      PalBmpFree( bmpImage:hBitmap, bmpImage:hPalette )
   end if

   cOldCodArt     := ""
   cOldUndMed     := ""

   if !Empty( aGet[ _CUNIDAD ] )
      aGet[ _CUNIDAD ]:lValid()
   end if

   if nMode == APPD_MODE .AND. lEntCon()

      RecalculaTotal( aTmpAlb )

      SetDlgMode( aTmp, aGet, oFld, nMode, oSayPr1, oSayPr2, oSayVp1, oSayVp2, oStkAct, oGet2, oTotal, aTmpAlb )

      SysRefresh()

      if !Empty( aGet[ _CREF ] )
         aGet[ _CREF ]:SetFocus()
      end if

   else

      oDlg:End( IDOK )

   end if

RETURN NIL

//--------------------------------------------------------------------------//

STATIC FUNCTION AppendKit( uTmpLin, aTmpAlb )

   local cCodArt
   local cSerAlb
   local nNumAlb
   local cSufAlb
   local nCanEnt
   local dFecAlb
   local cTipMov
   local cAlmLin
   local nIvaLin
   local lIvaLin
   local nComAge
   local nUniCaj
   local nDtoGrl
   local nDtoPrm
   local nDtoDiv
   local cNumPed
   local nTarLin
   local nNumLin                       := ( dbfTmpLin )->nNumLin
   local nRecAct                       := ( dbfKit    )->( RecNo() )
   local nRecLin                       := ( dbfTmpLin )->( RecNo() )
   local nUnidades                     := 0
   local nStkActual                    := 0

   if ValType( uTmpLin ) == "A"
      cCodArt                          := uTmpLin[ _CREF    ]
      cSerAlb                          := uTmpLin[ _CSERALB ]
      nNumAlb                          := uTmpLin[ _NNUMALB ]
      cSufAlb                          := uTmpLin[ _CSUFALB ]
      nCanEnt                          := uTmpLin[ _NCANENT ]
      dFecAlb                          := uTmpLin[ _DFECHA  ]
      cTipMov                          := uTmpLin[ _CTIPMOV ]
      cAlmLin                          := uTmpLin[ _CALMLIN ]
      nIvaLin                          := uTmpLin[ _NIVA    ]
      lIvaLin                          := uTmpLin[ _LIVALIN ]
      nComAge                          := uTmpLin[ _NCOMAGE ]
      nUniCaj                          := uTmpLin[ _NUNICAJA]
      nDtoGrl                          := uTmpLin[ _NDTO    ]
      nDtoPrm                          := uTmpLin[ _NDTOPRM ]
      nDtoDiv                          := uTmpLin[ _NDTODIV ]
      nNumLin                          := uTmpLin[ _NNUMLIN ]
      cNumPed                          := uTmpLin[ _dCNUMPED]
      nTarLin                          := uTmpLin[ _NTARLIN ]
   else
      cCodArt                          := ( uTmpLin )->cRef
      cSerAlb                          := ( uTmpLin )->cSerAlb
      nNumAlb                          := ( uTmpLin )->nNumAlb
      cSufAlb                          := ( uTmpLin )->cSufAlb
      nCanEnt                          := ( uTmpLin )->nCanEnt
      dFecAlb                          := ( uTmpLin )->dFecha
      cTipMov                          := ( uTmpLin )->cTipMov
      cAlmLin                          := ( uTmpLin )->cAlmLin
      nIvaLin                          := ( uTmpLin )->nIva
      lIvaLin                          := ( uTmpLin )->lIvaLin
      nComAge                          := ( uTmpLin )->nComAge
      nUniCaj                          := ( uTmpLin )->nUniCaja
      nDtoGrl                          := ( uTmpLin )->nDto
      nDtoPrm                          := ( uTmpLin )->nDtoPrm
      nDtoDiv                          := ( uTmpLin )->nDtoDiv
      nNumLin                          := ( uTmpLin )->nNumLin
      cNumPed                          := ( uTmpLin )->cNumPed
      nTarLin                          := ( uTmpLin )->nTarLin
   end if

   /*
   Guardamos los productos kits
   */

   if ( dbfKit )->( dbSeek( cCodArt ) )

      while ( dbfKit )->cCodKit == cCodArt .and. !( dbfKit )->( eof() )

         if ( dbfArticulo )->( dbSeek( ( dbfKit )->cRefKit ) )

            ( dbfTmpLin )->( dbAppend() )

            if lKitAsociado( cCodArt, dbfArticulo )
               ( dbfTmpLin )->nNumLin  := nLastNum( dbfTmpLin )
               ( dbfTmpLin )->lKitChl  := .f.
            else
               ( dbfTmpLin )->nNumLin  := nNumLin
               ( dbfTmpLin )->lKitChl  := .t.
            end if

            ( dbfTmpLin )->cRef        := ( dbfKit      )->cRefKit
            ( dbfTmpLin )->cDetalle    := ( dbfArticulo )->Nombre
            ( dbfTmpLin )->nPntVer     := ( dbfArticulo )->nPntVer1
            ( dbfTmpLin )->nPesokg     := ( dbfArticulo )->nPesoKg
            ( dbfTmpLin )->cPesokg     := ( dbfArticulo )->cUndDim
            ( dbfTmpLin )->cUnidad     := ( dbfArticulo )->cUnidad
            ( dbfTmpLin )->nVolumen    := ( dbfArticulo )->nVolumen
            ( dbfTmpLin )->cVolumen    := ( dbfArticulo )->cVolumen
            ( dbfTmpLin )->nCtlStk     := ( dbfArticulo )->nCtlStock
            ( dbfTmpLin )->nPvpRec     := ( dbfArticulo )->PvpRec
            ( dbfTmpLin )->cCodImp     := ( dbfArticulo )->cCodImp
            ( dbfTmpLin )->lLote       := ( dbfArticulo )->lLote
            ( dbfTmpLin )->cLote       := ( dbfArticulo )->cLote

            ( dbfTmpLin )->nCosDiv     := nCosto( nil, dbfArticulo, dbfKit )
            ( dbfTmpLin )->nValImp     := oNewImp:nValImp( ( dbfArticulo )->cCodImp )

            if ( dbfArticulo )->lFacCnv
               ( dbfTmpLin )->nFacCnv  := ( dbfArticulo )->nFacCnv
            end if

            ( dbfTmpLin )->cSerAlb     := cSerAlb
            ( dbfTmpLin )->nNumAlb     := nNumAlb
            ( dbfTmpLin )->cSufAlb     := cSufAlb
            ( dbfTmpLin )->nCanEnt     := nCanEnt
            ( dbfTmpLin )->dFecha      := dFecAlb
            ( dbfTmpLin )->cTipMov     := cTipMov
            ( dbfTmpLin )->cNumPed     := cNumPed
            ( dbfTmpLin )->nNumLin     := nNumLin
            ( dbfTmpLin )->cAlmLin     := cAlmLin
            ( dbfTmpLin )->lIvaLin     := lIvaLin

            /*
            Propiedades de los kits-----------------------------------------
            */

            ( dbfTmpLin )->lImpLin     := lImprimirComponente( cCodArt, dbfArticulo )   // 1 Todos, 2 Compuesto, 3 Componentes
            ( dbfTmpLin )->lKitPrc     := lPreciosComponentes( cCodArt, dbfArticulo )   // 1 Todos, 2 Compuesto, 3 Componentes

            ( dbfTmpLin )->nComAge     := nComAge
            ( dbfTmpLin )->nUniCaja    := nUniCaj * ( dbfKit )->nUndKit

            /*
            Estudio de los tipos de IGIC si el padre el cero todos cero---------
            */

            if !Empty( nIvaLin )
               ( dbfTmpLin )->nIva     := nIva( dbfIva, ( dbfArticulo )->TipoIva )
               ( dbfTmpLin )->nReq     := nReq( dbfIva, ( dbfArticulo )->TipoIva )
            else
               ( dbfTmpLin )->nIva     := 0
               ( dbfTmpLin )->nReq     := 0
            end if

            /*
            Cojemos el precio del kit------------------------------------------
            */

            if ( dbfTmpLin )->lKitPrc
               ( dbfTmpLin )->nPreUnit := nRetPreArt( nTarLin, aTmpAlb[ _CDIVALB ], aTmpAlb[ _LIVAINC ], dbfArticulo, dbfDiv, dbfKit, dbfIva )
            end if

            /*
            Tratamiento de stocks----------------------------------------------
            */

            if lStockComponentes( cCodArt, dbfArticulo )
               ( dbfTmpLin )->nCtlStk  := ( dbfArticulo )->nCtlStock
            else
               ( dbfTmpLin )->nCtlstk  := STOCK_NO_CONTROLAR // No controlar Stock
            end if

            /*
            Descuentos------------------------------------------------------
            */

            if ( dbfKit )->lAplDto
               ( dbfTmpLin )->nDto     := nDtoGrl
               ( dbfTmpLin )->nDtoPrm  := nDtoPrm
               ( dbfTmpLin )->nDtoDiv  := nDtoDiv
            end if

            if ( dbfArticulo )->lKitArt
               AppendKit( dbfTmpLin, aTmpAlb )
            end if

            /*
            Avisaremos del stock bajo minimo--------------------------------------
            */

            if ( dbfArticulo )->lMsgVta .and. !uFieldEmpresa( "lNStkAct" )

               nStkActual     := oStock:nStockAlmacen( ( dbfKit )->cRefKit, cAlmLin )
               nUnidades      := nUniCaj * ( dbfKit )->nUndKit

               do case
                  case nStkActual - nUnidades < 0

                        MsgStop( "No hay stock suficiente para realizar la venta" + CRLF + ;
                                 "del componente " + AllTrim( ( dbfKit )->cRefKit ) + " - " + AllTrim( ( dbfArticulo )->Nombre ),;
                                 "¡Atención!" )

                  case nStkActual - nUnidades < ( dbfArticulo)->nMinimo

                        MsgStop( "El stock del componente " + AllTrim( ( dbfKit )->cRefKit ) + " - " + AllTrim( ( dbfArticulo )->Nombre ) + CRLF + ;
                                 "está bajo minimo."                                                                                      + CRLF + ;
                                 "Unidades a vender : " + AllTrim( Trans( nUnidades, MasUnd() ) )                                         + CRLF + ;
                                 "Stock minimo : " + AllTrim( Trans( ( dbfArticulo)->nMinimo, MasUnd() ) )                                + CRLF + ;
                                 "Stock actual : " + AllTrim( Trans( nStkActual, MasUnd() ) ),;
                                 "¡Atención!" )
               end case

            end if

         end if

         ( dbfKit )->( dbSkip() )

      end while

   end if

   ( dbfKit    )->( dbGoTo( nRecAct ) )
   ( dbfTmpLin )->( dbGoTo( nRecLin ) )

RETURN NIL

//---------------------------------------------------------------------------//

STATIC FUNCTION lMoreIva( nCodIva )

	/*
	Si no esta dentro de los porcentajes anteriores
	*/

   IF _NPCTIVA1 == nil .OR. _NPCTIVA2 == nil .OR. _NPCTIVA3 == nil
		RETURN .T.
	END IF

	IF _NPCTIVA1 == nCodIva .OR. _NPCTIVA2 == nCodIva .OR. _NPCTIVA3 == nCodIva
		RETURN .T.
	END IF

   MsgStop( "Documento con mas de 3 Tipos de " + cImp() )

RETURN .F.

//---------------------------------------------------------------------------//

/*
Funcion Auxiliar para la Edici¢n de Lineas de Detalle en un albaran
*/

STATIC FUNCTION EdtDeta( oBrwLin, bEdtDet, aTmpAlb, lTot, nMode )

   WinEdtRec( oBrwLin, bEdtDet, dbfTmpLin, lTot, nMode, aTmpAlb )

RETURN ( RecalculaTotal( aTmpAlb ) )

//---------------------------------------------------------------------------//

/*
Funcion Auxiliar para borrar las Lineas de Detalle en un albaran
*/

STATIC FUNCTION DelDeta( oBrwLin )

   CursorWait()

   while ( dbfTmpSer )->( dbSeek( Str( ( dbfTmpLin )->nNumLin, 4 ) ) )
      ( dbfTmpSer )->( dbDelete() )
   end while

   if ( dbfTmpLin )->lKitArt
      dbDelKit( oBrwLin, dbfTmpLin, ( dbfTmpLin )->nNumLin )
   end if

   CursorWE()

RETURN ( .t. )

//---------------------------------------------------------------------------//

STATIC FUNCTION EndTrans( aTmp, aGet, oBrw, oBrwInc, nMode, oDlg )

   local aTabla
   local oError
   local oBlock
   local cSerAlb
   local nNumAlb
   local cSufAlb
   local cNumPed
   local dFecAlb
   local cPedido
   local cSat 

   if Empty( aTmp[ _CSERALB ] )
      aTmp[ _CSERALB ]  := "A"
   end if

   cSerAlb              := aTmp[ _CSERALB ]
   nNumAlb              := aTmp[ _NNUMALB ]
   cSufAlb              := aTmp[ _CSUFALB ]
   cNumPed              := aTmp[ _CNUMPED ]
   dFecAlb              := aTmp[ _DFECALB ]

   /*
   Comprobamos la fecha del documento------------------------------------------
   */

   #ifndef __PDA__
   if !lValidaOperacion( aTmp[ _DFECALB ] )
      Return .f.
   end if
   #endif

   /*
   Estos campos no pueden estar vacios-----------------------------------------
   */

   if Empty( aTmp[ _CCODCLI ] )
      msgStop( "Código de cliente no puede estar vacío." )
      aGet[ _CCODCLI ]:SetFocus()
      return .f.
   end if

   if lCliBlq( aTmp[ _CCODCLI ], dbfClient )
      msgStop( "Cliente bloqueado, no se pueden realizar operaciones de venta" , "Imposible archivar como albarán" )
      aGet[ _CCODCLI ]:SetFocus()
      return .f.
   end if

   if !lCliChg( aTmp[ _CCODCLI ], dbfClient )
      msgStop( "Este cliente no tiene autorización para venta a credito.", "Imposible archivar como albarán" )
      aGet[ _CCODCLI ]:SetFocus()
      return .f.
   end if

   if Empty( aTmp[ _CCODALM ] )
      msgStop( "Almacén no puede estar vacío." )
      aGet[ _CCODALM ]:SetFocus()
      return .f.
   end if

   if Empty( aTmp[ _CCODCAJ ] )
      msgStop( "Caja no puede estar vacía." )
      aGet[ _CCODCAJ ]:SetFocus()
      return .f.
   end if

   if Empty( aTmp[ _CCODPAGO ] )
      msgStop( "Forma de pago no puede estar vacía." )
      aGet[ _CCODPAGO ]:SetFocus()
      return .f.
   end if

   if Empty( aTmp[ _CDIVALB ] )
      MsgStop( "No puede almacenar documento sin código de divisa." )
      aGet[ _CDIVALB ]:SetFocus()
      return .f.
   end if

   #ifndef __PDA__

   if Empty( aTmp[ _CCODAGE ] ) .and. lRecogerAgentes()
      msgStop( "Agente no puede estar vacío." )
      aGet[ _CCODAGE ]:SetFocus()
      return .f.
   end if

   if Empty( aTmp[ _CCODOBR ] ) .and. lObras()
      MsgStop( "Debe de introducir una obra." )
      aGet[ _CCODOBR ]:SetFocus()
      return .f.
   end if

   #endif

   if ( dbfTmpLin )->( eof() )
      MsgStop( "No puede almacenar un documento sin líneas." )
      return .f.
   end if

   if nTotDif < 0
      MsgStop( "La carga excede la capacidad del medio de transporte." )
   end if

   CursorWait()

   oDlg:Disable()

   oMsgText( "Archivando" )

   oBlock                  := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   BeginTransaction()

   /*
   Quitamos los filtros--------------------------------------------------------
   */

   ( dbfTmpLin )->( dbClearFilter() )

   oMsgProgress()
   oMsgProgress():SetRange( 0, ( dbfTmpLin )->( LastRec() ) )

   /*
   Primero hacer el RollBack---------------------------------------------------
	*/

   aTmp[ _DFECCRE ]        := Date()
   aTmp[ _CTIMCRE ]        := Time()

   /*
   Guardamos el tipo para alquileres
   */

   if !Empty( oTipAlb ) .and. oTipAlb:nAt == 2
      aTmp[ _LALQUILER ]   := .t.
   else
      aTmp[ _LALQUILER ]   := .f.
   end if

   do case
   case nMode == APPD_MODE .or. nMode == DUPL_MODE

      nNumAlb              := nNewDoc( aTmp[ _CSERALB ], dbfAlbCliT, "NALBCLI", , dbfCount )
      aTmp[ _NNUMALB ]     := nNumAlb
      nTotOld              := 0

   case nMode == EDIT_MODE

      while ( dbfAlbCliL )->( dbSeek( cSerAlb + str( nNumAlb ) + cSufAlb ) ) .and. !( dbfAlbCliL )->( eof() )
         if dbLock( dbfAlbCliL )
            ( dbfAlbCliL )->( dbDelete() )
            ( dbfAlbCliL )->( dbUnLock() )
         end if
      end while

      while ( dbfAlbCliP )->( dbSeek( cSerAlb + str( nNumAlb ) + cSufAlb ) ) .and. !( dbfAlbCliP )->( eof() )
         if dbLock( dbfAlbCliP )
            ( dbfAlbCliP )->( dbDelete() )
            ( dbfAlbCliP )->( dbUnLock() )
         end if
      end while

      while ( dbfAlbCliI )->( dbSeek( cSerAlb + str( nNumAlb ) + cSufAlb ) ) .and. !( dbfAlbCliI )->( eof() )
         if dbLock( dbfAlbCliI )
            ( dbfAlbCliI )->( dbDelete() )
            ( dbfAlbCliI )->( dbUnLock() )
         end if
      end while

      while ( dbfAlbCliD )->( dbSeek( cSerAlb + str( nNumAlb ) + cSufAlb ) ) .and. !( dbfAlbCliD )->( eof() )
         if dbLock( dbfAlbCliD )
            ( dbfAlbCliD )->( dbDelete() )
            ( dbfAlbCliD )->( dbUnLock() )
         end if
      end while

      while ( dbfAlbCliS )->( dbSeek( cSerAlb + Str( nNumAlb ) + cSufAlb ) ) .and. !( dbfAlbCliS )->( eof() )
         if dbLock( dbfAlbCliS )
            ( dbfAlbCliS )->( dbDelete() )
            ( dbfAlbCliS )->( dbUnLock() )
         end if
      end while

   end case

   /*
   Guardamos el albaran
   */

   ( dbfTmpLin )->( dbGoTop() )
   while !( dbfTmpLin )->( eof() )

      ( dbfTmpLin )->dFecAlb  := aTmp[ _DFECALB ]

      dbPass( dbfTmpLin, dbfAlbCliL, .t., cSerAlb, nNumAlb, cSufAlb )

      ( dbfTmpLin )->( dbSkip() )

      oMsgProgress():Deltapos(1)

   end while

   /*
   Guardamos los totales-------------------------------------------------------
   */

   aTmp[ _NTOTNET ]     := nTotNet
   aTmp[ _NTOTIVA ]     := nTotIva
   aTmp[ _NTOTREQ ]     := nTotReq
   aTmp[ _NTOTALB ]     := nTotAlb
   aTmp[ _NTOTPAG ]     := nTotPag

   WinGather( aTmp, , dbfAlbCliT, , nMode )

   /*
   Ahora escribimos en el fichero definitivo-----------------------------------
	*/

   ( dbfTmpPgo )->( dbGoTop() )
   while ( dbfTmpPgo )->( !eof() )
      dbPass( dbfTmpPgo, dbfAlbCliP, .t., cSerAlb, nNumAlb, cSufAlb )
      ( dbfTmpPgo )->( dbSkip() )
   end while

   /*
   Ahora escribimos en el fichero definitivo-----------------------------------
	*/

   ( dbfTmpInc )->( dbGoTop() )
   while ( dbfTmpInc )->( !eof() )
      dbPass( dbfTmpInc, dbfAlbCliI, .t., cSerAlb, nNumAlb, cSufAlb )
      ( dbfTmpInc )->( dbSkip() )
   end while

   /*
   Ahora escribimos en el fichero definitivo-----------------------------------
	*/

   ( dbfTmpDoc )->( dbGoTop() )
   while ( dbfTmpDoc )->( !eof() )
      dbPass( dbfTmpDoc, dbfAlbCliD, .t., cSerAlb, nNumAlb, cSufAlb )
      ( dbfTmpDoc )->( dbSkip() )
   end while

   /*
   Ahora escribimos en el fichero definitivo-----------------------------------
	*/

   ( dbfTmpSer )->( dbGoTop() )
   while ( dbfTmpSer )->( !eof() )
      dbPass( dbfTmpSer, dbfAlbCliS, .t., cSerAlb, nNumAlb, cSufAlb, dFecAlb )
      ( dbfTmpSer )->( dbSkip() )
   end while

   /*
   Estado del pedido-----------------------------------------------------------
   */

   if !Empty( cNumPed )

      /*
      Si el albarán proviene de un pedido, le ponemos el estado----------------
      */

      oStock:SetEstadoPedCli( cNumPed, .t., cSerAlb + Str( nNumAlb ) + cSufAlb )

      if ( dbfPedCliP )->( dbSeek( cNumPed ) )

         while ( dbfPedCliP )->cSerPed + Str( ( dbfPedCliP )->nNumPed ) + ( dbfPedCliP )->cSufPed == cNumPed .and. !( dbfPedCliP )->( Eof() )

            if !( dbfPedCliP )->lPasado

               if dbLock( dbfPedCliP )
                  ( dbfPedCliP )->lPasado := .t.
                  ( dbfPedCliP )->( dbUnLock() )
               end if

            end if

            ( dbfPedCliP )->( dbSkip() )

         end while

      end if

   end if

   /*
   Estado de los pedidos al agrupar--------------------------------------------
   */

   if Len( aPedidos ) != 0

      for each cPedido in aPedidos

         if ( cPedido[ 1 ] ) .and. ( dbSeekInOrd( cPedido[ 3 ], "nNumPed", dbfPedCliT ) )

            oStock:SetEstadoPedCli( cPedido[ 3 ], .t., cSerAlb + Str( nNumAlb ) + cSufAlb )

            if dbLock( dbfPedCliT )
               ( dbfPedCliT )->cNumAlb    := cSerAlb + Str( nNumAlb ) + cSufAlb
               ( dbfPedCliT )->( dbUnLock() )
            end if

         end if

      next

   end if

   /*
   Estado de los Sat al agrupar------------------------------------------------
   */

   if Len( aNumSat ) != 0

      for each cSat in aNumSat

         if ( dbSeekInOrd( cSat, "nNumSat", dbfSatCliT ) )

            if dbLock( dbfSatCliT )
               ( dbfSatCliT )->lEstado    := .t.
               ( dbfSatCliT )->cNumAlb    := cSerAlb + Str( nNumAlb ) + cSufAlb
               ( dbfSatCliT )->( dbUnLock() )
            end if

         end if

      next

   end if

   /*
   Escribe los datos pendientes------------------------------------------------
   */

   dbCommitAll()

   CommitTransaction()

   CursorWE()

   RECOVER USING oError

      RollBackTransaction()

      msgStop( "Imposible almacenar documento" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE
   ErrorBlock( oBlock )

   oMsgText()
   EndProgress()

   oDlg:Enable()
   oDlg:End( IDOK )

RETURN .t.

//---------------------------------------------------------------------------//

FUNCTION SetFacturadoAlbaranCliente( lFacturado, oBrw, cAlbCliT, cAlbCliL, cAlbCliS, cNumFac )

   local nOrd
   local nRec
   local nRecHead             := ( cAlbCliT )->( Recno() )

   DEFAULT lFacturado         := .f.
   DEFAULT cNumFac            := Space( 12 )
   DEFAULT cAlbCliT           := dbfAlbCliT
   DEFAULT cAlbCliL           := dbfAlbCliL
   DEFAULT cAlbCliS           := dbfAlbCliS

   if oBrw != nil

      for each nRec in ( oBrw:aSelected )

         nRecHead             := nRec

         ( cAlbCliT )->( dbGoTo( nRec ) )

         /*
         Restauramos los datos de cabecera----------------------------------------
         */

         if dbLock( cAlbCliT )
            ( cAlbCliT )->lFacturado := lFacturado
            ( cAlbCliT )->cNumFac    := cNumFac
            ( cAlbCliT )->( dbUnLock() )
         end if

         /*
         Cambiamos el estado en las lineas-------------------------------------------
         */

         nOrd                 := ( cAlbCliL )->( OrdSetFocus( "nNumAlb" ) )

         if ( cAlbCliL )->( dbSeek( ( cAlbCliT )->cSerAlb + Str( ( cAlbCliT )->nNumAlb ) + ( cAlbCliT )->cSufAlb ) )

            while ( cAlbCliT )->cSerAlb + Str( ( cAlbCliT )->nNumAlb ) + ( cAlbCliT )->cSufAlb == ( cAlbCliL )->cSerAlb + Str( ( cAlbCliL )->nNumAlb ) + ( cAlbCliL )->cSufAlb .and. !( cAlbCliL )->( Eof() )

               if dbLock( cAlbCliL )
                  ( cAlbCliL )->lFacturado := lFacturado
                  ( cAlbCliL )->( dbUnlock() )
                end if

               ( cAlbCliL )->( dbSkip() )

            end while

         end if

         ( cAlbCliL )->( OrdSetFocus( nOrd ) )

         /*
         Cambiamos el estado en las series-------------------------------------------
         */

         nOrd                 := ( cAlbCliS )->( OrdSetFocus( "nNumAlb" ) )

         if ( cAlbCliS )->( dbSeek( ( cAlbCliT )->cSerAlb + Str( ( cAlbCliT )->nNumAlb ) + ( cAlbCliT )->cSufAlb ) )

            while ( cAlbCliT )->cSerAlb + Str( ( cAlbCliT )->nNumAlb ) + ( cAlbCliT )->cSufAlb == ( cAlbCliS )->cSerAlb + Str( ( cAlbCliS )->nNumAlb ) + ( cAlbCliS )->cSufAlb .and. !( cAlbCliS )->( Eof() )

               if dbLock( cAlbCliS )
                  ( cAlbCliS )->lFacturado := lFacturado
                  ( cAlbCliS )->( dbUnlock() )
                end if

               ( cAlbCliS )->( dbSkip() )

            end while

         end if

         ( cAlbCliS )->( OrdSetFocus( nOrd ) )

      next

   else

      /*
      Restauramos los datos de cabecera----------------------------------------
      */

      if dbLock( cAlbCliT )
         ( cAlbCliT )->lFacturado := lFacturado
         ( cAlbCliT )->cNumFac    := cNumFac
         ( cAlbCliT )->( dbUnLock() )
      end if

      /*
      Cambiamos el estado en las lineas-------------------------------------------
      */

      nOrd                    := ( cAlbCliL )->( OrdSetFocus( "nNumAlb" ) )

      if ( cAlbCliL )->( dbSeek( ( cAlbCliT )->cSerAlb + Str( ( cAlbCliT )->nNumAlb ) + ( cAlbCliT )->cSufAlb ) )

         while ( cAlbCliT )->cSerAlb + Str( ( cAlbCliT )->nNumAlb ) + ( cAlbCliT )->cSufAlb == ( cAlbCliL )->cSerAlb + Str( ( cAlbCliL )->nNumAlb ) + ( cAlbCliL )->cSufAlb .and. !( cAlbCliL )->( Eof() )

            if dbLock( cAlbCliL )
               ( cAlbCliL )->lFacturado := lFacturado
               ( cAlbCliL )->( dbUnlock() )
             end if

            ( cAlbCliL )->( dbSkip() )

         end while

      end if

      ( cAlbCliL )->( OrdSetFocus( nOrd ) )

      /*
      Cambiamos el estado en las series-------------------------------------------
      */

      nOrd                   := ( cAlbCliS )->( OrdSetFocus( "nNumAlb" ) )

      if ( cAlbCliS )->( dbSeek( ( cAlbCliT )->cSerAlb + Str( ( cAlbCliT )->nNumAlb ) + ( cAlbCliT )->cSufAlb ) )

         while ( cAlbCliT )->cSerAlb + Str( ( cAlbCliT )->nNumAlb ) + ( cAlbCliT )->cSufAlb == ( cAlbCliS )->cSerAlb + Str( ( cAlbCliS )->nNumAlb ) + ( cAlbCliS )->cSufAlb .and. !( cAlbCliS )->( Eof() )

            if dbLock( cAlbCliS )
               ( cAlbCliS )->lFacturado := lFacturado
               ( cAlbCliS )->( dbUnlock() )
             end if

            ( cAlbCliS )->( dbSkip() )

         end while

      end if

      ( cAlbCliS )->( OrdSetFocus( nOrd ) )

   end if

   /*
   Dejamos la tabla en el registro que estaba----------------------------------
   */

   ( cAlbCliT )->( dbGoTo( nRecHead ) )

   if oBrw != nil
      oBrw:Refresh()
      oBrw:SetFocus()
   end if

RETURN NIL

//---------------------------------------------------------------------------//
//
// Devuelve el importe del descuento lineal
//

FUNCTION nDtoLAlbCli( dbfLin, nDec, nVdv, cPorDiv )

   local nCalculo    := 0

   DEFAULT dbfLin    := dbfAlbCliL
   DEFAULT nDec      := nDouDiv()
   DEFAULT nVdv      := 1

   if ( dbfLin )->nDto != 0
      nCalculo       := nTotUAlbCli( dbfLin, nDec ) * ( dbfLin )->nDto / 100
      nCalculo       := Round( nCalculo / nVdv, nDec )
   end if

RETURN ( if( cPorDiv != nil, Trans( nCalculo, cPorDiv ), nCalculo ) )

//---------------------------------------------------------------------------//

Function nTotDtoLAlbCli( dbfLin, nDec, nVdv, cPorDiv )

   local nCalculo

   DEFAULT dbfLin    := dbfAlbCliL
   DEFAULT nDec      := nDouDiv()
   DEFAULT nVdv      := 1

   nCalculo          := nDtoLAlbCli( dbfLin, nDec, nVdv ) * nTotNAlbCli( dbfLin )

   if nVdv != 0
      nCalculo       := nCalculo / nVdv
   end if

   nCalculo          := Round( nCalculo, nDec )

RETURN ( if( cPorDiv != nil, Trans( nCalculo, cPorDiv ), nCalculo ) )

//----------------------------------------------------------------------------//

Function dJulianoAlbCli( cAlbCliL )

   local cPrefijo
   local cLote

   DEFAULT cAlbCliL  := dbfAlbCliL

   cLote             := ( cAlbCliL )->cLote

   cPrefijo          := Substr( ( cAlbCliL )->cLote, 1, 1 )

   if Val( cPrefijo ) == 0
      cLote          := Substr( ( cAlbCliL )->cLote, 2 )
   end if

RETURN ( AddMonth( JulianoToDate( Year( ( cAlbCliL )->dFecAlb ), Val( cLote ) ), 6 ) )

//---------------------------------------------------------------------------//

Function dJulianoAlbAnio( cAlbCliL )

   local cPrefijo
   local cLote

   DEFAULT cAlbCliL  := dbfAlbCliL

   cLote             := ( cAlbCliL )->cLote

   cPrefijo          := Substr( ( cAlbCliL )->cLote, 1, 1 )

   if Val( cPrefijo ) == 0
      cLote          := Substr( ( cAlbCliL )->cLote, 2 )
   end if

RETURN ( AddMonth( JulianoToDate( Year( ( cAlbCliL )->dFecAlb ), Val( cLote ) ), 8 ) )

//---------------------------------------------------------------------------//

Static Function YearComboBoxChange()

   if oWndBrw:oWndBar:lAllYearComboBox()
      DestroyFastFilter( dbfAlbCliT )
      CreateUserFilter( "", dbfAlbCliT, .f., , , "all" )
   else
      DestroyFastFilter( dbfAlbCliT )
      CreateUserFilter( "Year( Field->dFecAlb ) == " + oWndBrw:oWndBar:cYearComboBox(), dbfAlbCliT, .f., , , "Year( Field->dFecAlb ) == " + oWndBrw:oWndBar:cYearComboBox() )
   end if

   ( dbfAlbCliT )->( dbGoTop() )

   oWndBrw:Refresh()

Return nil

//--------------------------------------------------------------------------//

Static Function lBuscaOferta( cCodArt, aGet, aTmp, aTmpAlb, dbfOferta, dbfArticulo, dbfDiv, dbfKit, dbfIva  )

   local sOfeArt
   local nTotalLinea    := 0

   if ( dbfArticulo )->Codigo == cCodArt .or. ( dbfArticulo )->( dbSeek( cCodArt ) )

      /*
      Buscamos si existen ofertas por artículo----------------------------
      */

      nTotalLinea := lCalcDeta( aTmp, aTmpAlb, nDouDiv, , , aTmpAlb[ _CDIVALB ], .t. )

      sOfeArt     := sOfertaArticulo( cCodArt, aTmpAlb[ _CCODCLI ], aTmpAlb[ _CCODGRP ], aTmp[ _NUNICAJA ], aTmpAlb[ _DFECALB ], dbfOferta, aTmp[ _NTARLIN ], , aTmp[_CCODPR1], aTmp[_CCODPR2], aTmp[_CVALPR1], aTmp[_CVALPR2], aTmp[ _CDIVALB ], dbfArticulo, dbfDiv, dbfKit, dbfIva, aTmp[ _NCANENT ], nTotalLinea )

      if !Empty( sOfeArt ) 
         if ( sOfeArt:nPrecio != 0 )
            aGet[ _NSATUNIT ]:cText( sOfeArt:nPrecio )
         end if 
         if ( sOfeArt:nDtoPorcentual != 0 )
            aGet[ _NDTO     ]:cText( sOfeArt:nDtoPorcentual )
         end if 
         if ( sOfeArt:nDtoLineal != 0)
            aGet[ _NDTODIV  ]:cText( sOfeArt:nDtoLineal )
         end if 
         aTmp[ _LLINOFE  ] := .t.
      end if

      /*
      Buscamos si existen ofertas por familia----------------------------
      */

      if !aTmp[ _LLINOFE ]

         sOfeArt     := sOfertaFamilia( ( dbfArticulo )->Familia, aTmpAlb[ _CCODCLI ], aTmpAlb[ _CCODGRP ], aTmpAlb[ _DFECALB ], dbfOferta, aTmp[ _NTARLIN ], dbfArticulo, aTmp[ _NUNICAJA ], aTmp[ _NCANENT ], nTotalLinea )

         if !Empty( sOfeArt ) 
            if ( sOfeArt:nDtoPorcentual != 0 )
               aGet[ _NDTO    ]:cText( sOfeArt:nDtoPorcentual )
            end if 
            if ( sOfeArt:nDtoLineal != 0 )
               aGet[ _NDTODIV ]:cText( sOfeArt:nDtoLineal )
            end if 
            aTmp[ _LLINOFE ]  := .t.
         end if

      end if

      /*
      Buscamos si existen ofertas por tipos de articulos--------------
      */

      if !aTmp[ _LLINOFE ]

         sOfeArt     := sOfertaTipoArticulo( ( dbfArticulo )->cCodTip, aTmpAlb[ _CCODCLI ], aTmpAlb[ _CCODGRP ], aTmpAlb[ _DFECALB ], dbfOferta, aTmp[ _NTARLIN ], dbfArticulo, aTmp[ _NUNICAJA ], aTmp[ _NCANENT ], nTotalLinea )

         if !Empty( sOfeArt )
            if ( sOfeArt:nDtoPorcentual != 0 )
               aGet[ _NDTO    ]:cText( sOfeArt:nDtoPorcentual )
            end if 
            if ( sOfeArt:nDtoLineal != 0 )
               aGet[ _NDTODIV ]:cText( sOfeArt:nDtoLineal )
            end if 
            aTmp[ _LLINOFE ]  := .t.
         end if

      end if

      /*
      Buscamos si existen ofertas por tipos de articulos--------------
      */

      if !aTmp[ _LLINOFE ]

         sOfeArt     := sOfertaCategoria( ( dbfArticulo )->cCodCate, aTmpAlb[ _CCODCLI ], aTmpAlb[ _CCODGRP ], aTmpAlb[ _DFECALB ], dbfOferta, aTmp[ _NTARLIN ], dbfArticulo, aTmp[ _NUNICAJA ], aTmp[ _NCANENT ], nTotalLinea )

         if !Empty( sOfeArt )
            if ( sOfeArt:nDtoPorcentual != 0 )
               aGet[ _NDTO    ]:cText( sOfeArt:nDtoPorcentual )
            end if 
            if ( sOfeArt:nDtoLineal != 0 )
               aGet[ _NDTODIV ]:cText( sOfeArt:nDtoLineal )
            end if 
            aTmp[ _LLINOFE ]  := .t.
         end if

      end if

      /*
      Buscamos si existen ofertas por temporadas-------------------------------
      */

      if !aTmp[ _LLINOFE ]

         sOfeArt     := sOfertaTemporada( ( dbfArticulo )->cCodTemp, aTmpAlb[ _CCODCLI ], aTmpAlb[ _CCODGRP ], aTmpAlb[ _DFECALB ], dbfOferta, aTmp[ _NTARLIN ], dbfArticulo, aTmp[ _NUNICAJA ], aTmp[ _NCANENT ], nTotalLinea )

         if !Empty( sOfeArt ) .and. ( sOfeArt:nDtoPorcentual != 0 .or. sOfeArt:nDtoLineal != 0 )
            if ( sOfeArt:nDtoPorcentual != 0 )
               aGet[ _NDTO    ]:cText( sOfeArt:nDtoPorcentual )
            end if 
            if ( sOfeArt:nDtoLineal != 0 )
               aGet[ _NDTODIV ]:cText( sOfeArt:nDtoLineal )
            end if 
            aTmp[ _LLINOFE ]  := .t.
         end if

      end if

      /*
      Buscamos si existen ofertas por fabricantes---------------------------
      */

      if !aTmp[ _LLINOFE ]

         sOfeArt     := sOfertaFabricante( ( dbfArticulo )->cCodFab, aTmpAlb[ _CCODCLI ], aTmpAlb[ _CCODGRP ], aTmpAlb[ _DFECALB ], dbfOferta, aTmp[ _NTARLIN ], dbfArticulo, aTmp[ _NUNICAJA ], aTmp[ _NCANENT ], nTotalLinea )

         if !Empty( sOfeArt )
            if ( sOfeArt:nDtoPorcentual != 0 )
               aGet[ _NDTO    ]:cText( sOfeArt:nDtoPorcentual )
            end if 
            if ( sOfeArt:nDtoLineal != 0 )
               aGet[ _NDTODIV ]:cText( sOfeArt:nDtoLineal )
            end if 
            aTmp[ _LLINOFE ]  := .t.
         end if

      end if

   end if

return .t.

//--------------------------------------------------------------------------//

Static Function lValidLote( aTmp, aGet, oStkAct )

   if !uFieldEmpresa( "lNStkAct" )
      oStock:nPutStockActual( aTmp[ _CREF ], aTmp[ _CALMLIN ], aTmp[ _CVALPR1 ], aTmp[ _CVALPR2 ], aTmp[ _CLOTE ], aTmp[ _LKITART ], aTmp[ _NCTLSTK ], oStkAct )
   end if

Return ( .t. )

//--------------------------------------------------------------------------//

Static Function EditarNumeroSerie( aTmp, oStock, nMode )

   with object ( TNumerosSerie() )

      :nMode            := nMode

      :cCodArt          := aTmp[ _CREF    ]
      :cCodAlm          := aTmp[ _CALMLIN ]
      :nNumLin          := aTmp[ _NNUMLIN ]

      :nTotalUnidades   := nTotNAlbCli( aTmp )

      :oStock           := oStock

      :uTmpSer          := dbfTmpSer

      :Resource()

   end with

Return ( nil )

//--------------------------------------------------------------------------//

Static Function lValSer( cCodArt, cCodAlm, aNumSer, aValSer, nTotUnd, oStock, oBrwSer, oProSer, oSaySer )

   local n
   local lValid         := .t.

   CursorWait()

   if !Empty( oProSer )
      oProSer:Show()
      oProSer:SetTotal( nTotUnd )
   end if

   if !Empty( oSaySer )
      oSaySer:SetText( "Calculando disponibilidad del stock..." )
   end if

   for n := 1 to nTotUnd

      if !Empty( aNumSer[ n ] )

         aValSer[ n ]   := oStock:lValidNumeroSerie( cCodArt, cCodAlm, aNumSer[ n ] )

         if !aValSer[ n ]
            lValid      := .f.
         end if

      else

         lValid         := .f.

      end if

      if !Empty( oProSer ) .and. ( Mod( n, int( nTotUnd / 100 ) ) == 0 )
         oProSer:Set( n )
      end if

   next

   if !Empty( oBrwSer )
      oBrwSer:Refresh()
   end if

   if !Empty( oProSer )
      oProSer:Set( 0 )
      oProSer:Hide()
   end if

   if !Empty( oSaySer )
      oSaySer:SetText( "" )
   end if

   CursorWE()

Return ( lValid )

//---------------------------------------------------------------------------//

Static Function lChkSer( aValSer, nTotUnd, oProSer, oBrwSer )

   local l
   local n
   local lValid            := .t.

   CursorWait()

   if !Empty( oProSer )
      oProSer:Show()
      oProSer:SetTotal( nTotUnd )
   end if

   for each l in aValSer

      if IsFalse( l )

         lValid            := .f.
         n                 := hb_EnumIndex()
         exit

      else

         if !Empty( oProSer ) // .and. ( Mod( n, int( nTotUnd / 10 ) ) == 0 )
            oProSer:Set( hb_EnumIndex() )
         end if

      end if

   next

   if !lValid

      if uFieldEmpresa( "lSerNoCom" )
         msgStop( "Hay números de serie sin stock para su venta." )
      else
         lValid            := ApoloMsgNoYes( "Hay números de serie sin stock para su venta.", "¿Desea continuar con la venta?" )
      end if

      if !Empty( oBrwSer ) .and. IsNum( n )
         oBrwSer:nArrayAt  := n
         oBrwSer:Refresh()
      end if

   end if

   if !Empty( oProSer )
      oProSer:Hide()
   end if

   CursorWE()

Return ( lValid )

//---------------------------------------------------------------------------//

Static Function SalvarNumeroSerie( aNumSer, aTmp, oProSer, oDlg )

   local cNumSer
   local nTotUnd              := len( aNumSer )

   oDlg:Disable()

   EliminarNumeroSerie( aTmp )

   if !Empty( oProSer )
      oProSer:SetTotal( nTotUnd )
   end if

   for each cNumSer in aNumSer

      ( dbfTmpSer )->( dbAppend() )
      ( dbfTmpSer )->cRef        := aTmp[ _CREF        ]
      ( dbfTmpSer )->cAlmLin     := aTmp[ _CALMLIN     ]
      ( dbfTmpSer )->nNumLin     := aTmp[ _NNUMLIN     ]
      ( dbfTmpSer )->lFacturado  := aTmp[ _dLFACTURADO ]
      ( dbfTmpSer )->cNumSer     := cNumSer

      if !Empty( oProSer ) .and. ( Mod( hb_enumindex(), int( nTotUnd / 100 ) ) == 0 )
         oProSer:Set( hb_enumindex() )
      end if

   next

   oDlg:Enable()
   oDlg:End()

Return ( nil )

//----------------------------------------------------------------------------//

Static Function EliminarNumeroSerie( aTmp )

   while ( ( dbfTmpSer )->( dbSeek( Str( aTmp[ _NNUMLIN ], 4 ) + aTmp[ _CREF ] ) ) ) .and. !( dbfTmpSer )->( Eof() )
      ( dbfTmpSer )->( dbDelete() )
   end while

Return ( nil )

//---------------------------------------------------------------------------//
//
// Importa presupuestos de clientes
//

STATIC FUNCTION cPreCli( aGet, aTmp, oBrw, nMode )

   local cDesAlb
   local cPedido  := aGet[ _CNUMSAT ]:VarGet()
   local lValid   := .f.

   if nMode != APPD_MODE .OR. Empty( cPedido )
      return .t.
   end if

   if dbSeekInOrd( cPedido, "nNumPre", dbfPreCliT )

      if ( dbfPreCliT )->lEstado

         MsgStop( "Presupuesto ya aprobado" )
         lValid   := .f.

      else

         CursorWait()

         HideImportacion()

         aGet[ _CCODCLI ]:cText( ( dbfPreCliT )->CCODCLI )
         aGet[ _CCODCLI ]:lValid()
         aGet[ _CCODCLI ]:Disable()

         aGet[ _CNOMCLI ]:cText( ( dbfPreCliT )->CNOMCLI )
         aGet[ _CDIRCLI ]:cText( ( dbfPreCliT )->CDIRCLI )
         aGet[ _CPOBCLI ]:cText( ( dbfPreCliT )->CPOBCLI )
         aGet[ _CPRVCLI ]:cText( ( dbfPreCliT )->CPRVCLI )
         aGet[ _CPOSCLI ]:cText( ( dbfPreCliT )->CPOSCLI )
         aGet[ _CDNICLI ]:cText( ( dbfPreCliT )->CDNICLI )
         aGet[ _CTLFCLI ]:cText( ( dbfPreCliT )->CTLFCLI )

         aGet[ _CCODALM ]:cText( ( dbfPreCliT )->CCODALM )
         aGet[ _CCODALM ]:lValid()

         aGet[ _CCODCAJ ]:cText( ( dbfPreCliT )->cCodCaj )
         aGet[ _CCODCAJ ]:lValid()

         aGet[ _CCODPAGO]:cText( ( dbfPreCliT )->CCODPGO )
         aGet[ _CCODPAGO]:lValid()

         aGet[ _CCODAGE ]:cText( ( dbfPreCliT )->CCODAGE )
         aGet[ _CCODAGE ]:lValid()

         aGet[ _NPCTCOMAGE]:cText( ( dbfPreCliT )->nPctComAge )

         aGet[ _CCODTAR ]:cText( ( dbfPreCliT )->CCODTAR )
         aGet[ _CCODTAR ]:lValid()

         aGet[ _CCODOBR ]:cText( ( dbfPreCliT )->CCODOBR )
         aGet[ _CCODOBR ]:lValid()

         aGet[ _NTARIFA ]:cText( ( dbfPreCliT )->nTarifa )

         aGet[ _CCODTRN ]:cText( ( dbfPreCliT )->cCodTrn )
         aGet[ _CCODTRN ]:lValid() 

         aGet[ _LIVAINC ]:Click( ( dbfPreCliT )->lIvaInc )
         aGet[ _LRECARGO]:Click( ( dbfPreCliT )->lRecargo )
         aGet[ _LOPERPV ]:Click( ( dbfPreCliT )->lOperPv )

         aGet[ _CCONDENT]:cText( ( dbfPreCliT )->cCondEnt )
         aGet[ _MCOMENT ]:cText( ( dbfPreCliT )->mComent )
         aGet[ _MOBSERV ]:cText( ( dbfPreCliT )->mObserv )

         aGet[ _CDTOESP ]:cText( ( dbfPreCliT )->cDtoEsp )
         aGet[ _CDPP    ]:cText( ( dbfPreCliT )->cDpp    )
         aGet[ _NDTOESP ]:cText( ( dbfPreCliT )->nDtoEsp )
         aGet[ _NDPP    ]:cText( ( dbfPreCliT )->nDpp    )
         aGet[ _CDTOUNO ]:cText( ( dbfPreCliT )->cDtoUno )
         aGet[ _NDTOUNO ]:cText( ( dbfPreCliT )->nDtoUno )
         aGet[ _CDTODOS ]:cText( ( dbfPreCliT )->cDtoDos )
         aGet[ _NDTODOS ]:cText( ( dbfPreCliT )->nDtoDos )
         aGet[ _CMANOBR ]:cText( ( dbfPreCliT )->cManObr )
         aGet[ _NIVAMAN ]:cText( ( dbfPreCliT )->nIvaMan )
         aGet[ _NMANOBR ]:cText( ( dbfPreCliT )->nManObr )
         aGet[ _NBULTOS ]:cText( ( dbfPreCliT )->nBultos )

         aTmp[ _CCODGRP]         := ( dbfPreCliT )->cCodGrp
         aTmp[ _LMODCLI]         := ( dbfPreCliT )->lModCli

         /*
         Datos de alquileres---------------------------------------------------
         */

         aTmp[ _LALQUILER ]      := ( dbfPreCliT )->lAlquiler
         aTmp[ _DFECENTR  ]      := ( dbfPreCliT )->dFecEntr
         aTmp[ _DFECSAL   ]      := ( dbfPreCliT )->dFecSal

         if ( dbfPreCliL )->( dbSeek( cPedido ) )

            ( dbfTmpLin )->( dbAppend() )
            cDesAlb                    := ""
            cDesAlb                    += "Presupuesto Nº " + ( dbfPreCliT )->cSerPre + "/" + AllTrim( Str( ( dbfPreCliT )->nNumPre ) ) + "/" + ( dbfPreCliT )->cSufPre
            cDesAlb                    += " - Fecha " + Dtoc( ( dbfPreCliT )->dFecPre )
            ( dbfTmpLin )->MLNGDES     := cDesAlb
            ( dbfTmpLin )->LCONTROL    := .t.

            while ( (dbfPreCliL)->cSerPre + Str( (dbfPreCliL)->nNumPre ) + (dbfPreCliL)->cSufPre == cPedido )

               (dbfTmpLin)->( dbAppend() )

               (dbfTmpLin)->nNumLin    := (dbfPreCliL)->nNumLin
               (dbfTmpLin)->cRef       := (dbfPreCliL)->cRef
               (dbfTmpLin)->cDetalle   := (dbfPreCliL)->cDetAlle
               (dbfTmpLin)->mLngDes    := (dbfPreCliL)->mLngDes
               (dbfTmpLin)->mNumSer    := (dbfPreCliL)->mNumSer
               (dbfTmpLin)->nPreUnit   := (dbfPreCliL)->nPreDiv
               (dbfTmpLin)->nPntVer    := (dbfPreCliL)->nPntVer
               (dbfTmpLin)->nImpTrn    := (dbfPreCliL)->nImpTrn
               (dbfTmpLin)->nPESOKG    := (dbfPreCliL)->nPesOkg
               (dbfTmpLin)->cPESOKG    := (dbfPreCliL)->cPesOkg
               (dbfTmpLin)->cUnidad    := (dbfPreCliL)->cUnidad
               (dbfTmpLin)->nVolumen   := (dbfPreCliL)->nVolumen
               (dbfTmpLin)->cVolumen   := (dbfPreCliL)->cVolumen
               (dbfTmpLin)->nIVA       := (dbfPreCliL)->nIva
               (dbfTmpLin)->nReq       := (dbfPreCliL)->nReq
               (dbfTmpLin)->cUNIDAD    := (dbfPreCliL)->cUnidad
               (dbfTmpLin)->nDTO       := (dbfPreCliL)->nDto
               (dbfTmpLin)->nDTOPRM    := (dbfPreCliL)->nDtoPrm
               (dbfTmpLin)->nCOMAGE    := (dbfPreCliL)->nComAge
               (dbfTmpLin)->lTOTLIN    := (dbfPreCliL)->lTotLin
               (dbfTmpLin)->nDtoDiv    := (dbfPreCliL)->nDtoDiv
               (dbfTmpLin)->nCtlStk    := (dbfPreCliL)->nCtlStk
               (dbfTmpLin)->nCosDiv    := (dbfPreCliL)->nCosDiv
               (dbfTmpLin)->nPvpRec    := (dbfPreCliL)->nPvpRec
               (dbfTmpLin)->cTipMov    := (dbfPreCliL)->cTipMov
               (dbfTmpLin)->cAlmLin    := (dbfPreCliL)->cAlmLin
               (dbfTmpLin)->cCodImp    := (dbfPedCLiL)->cCodImp
               (dbfTmpLin)->nValImp    := (dbfPreCliL)->nValImp
               (dbfTmpLin)->CCODPR1    := (dbfPreCliL)->cCodPr1
               (dbfTmpLin)->CCODPR2    := (dbfPreCliL)->cCodPr2
               (dbfTmpLin)->CVALPR1    := (dbfPreCliL)->cValPr1
               (dbfTmpLin)->CVALPR2    := (dbfPreCliL)->cValPr2
               (dbfTmpLin)->nCanEnt    := (dbfPreCLiL)->nCanPre
               (dbfTmpLin)->nUniCaja   := (dbfPreCLiL)->nUniCaja
               (dbfTmpLin)->nUndKit    := (dbfPreCLiL)->nUndKit
               (dbfTmpLin)->lKitArt    := (dbfPreCLiL)->lKitArt
               (dbfTmpLin)->lKitChl    := (dbfPreCLiL)->lKitChl
               (dbfTmpLin)->lKitPrc    := (dbfPreCliL)->lKitPrc
               (dbfTmpLin)->nMesGrt    := (dbfPreCLiL)->nMesGrt
               (dbfTmpLin)->lLote      := (dbfPreCliL)->lLote
               (dbfTmpLin)->nLote      := (dbfPreCliL)->nLote
               (dbfTmpLin)->cLote      := (dbfPreCliL)->cLote
               (dbfTmpLin)->lMsgVta    := (dbfPreCliL)->lMsgVta
               (dbfTmpLin)->lNotVta    := (dbfPreCliL)->lNotVta
               (dbfTmpLin)->lImpLin    := (dbfPreCliL)->lImpLin
               (dbfTmpLin)->cCodTip    := (dbfPreCliL)->cCodTip
               (dbfTmpLin)->mObsLin    := (dbfPreCliL)->mObsLin
               (dbfTmpLin)->Descrip    := (dbfPedCliL)->Descrip
               (dbfTmpLin)->cCodPrv    := (dbfPreCliL)->cCodPrv
               (dbfTmpLin)->cNomPrv    := (dbfPreCliL)->cNomPrv
               (dbfTmpLin)->cImagen    := (dbfPreCliL)->cImagen
               (dbfTmpLin)->cCodFam    := (dbfPreCliL)->cCodFam
               (dbfTmpLin)->cGrpFam    := (dbfPreCliL)->cGrpFam
               (dbfTmpLin)->cRefPrv    := (dbfPreCliL)->cRefPrv
               (dbfTmpLin)->dFecEnt    := (dbfPreCliL)->dFecEnt
               (dbfTmpLin)->dFecSal    := (dbfPreCliL)->dFecSal
               (dbfTmpLin)->nPreAlq    := (dbfPreCliL)->nPreAlq
               (dbfTmpLin)->lAlquiler  := (dbfPreCliL)->lAlquiler
               (dbfTmpLin)->nNumMed    := (dbfPreCliL)->nNumMed
               (dbfTmpLin)->nMedUno    := (dbfPreCliL)->nMedUno
               (dbfTmpLin)->nMedDos    := (dbfPreCliL)->nMedDos
               (dbfTmpLin)->nMedTre    := (dbfPreCliL)->nMedTre
               (dbfTmpLin)->nPuntos    := (dbfPreCliL)->nPuntos
               (dbfTmpLin)->nValPnt    := (dbfPreCliL)->nValPnt
               (dbfTmpLin)->nDtoPnt    := (dbfPreCliL)->nDtoPnt
               (dbfTmpLin)->nIncPnt    := (dbfPreCliL)->nIncPnt
               (dbfTmpLin)->lControl   := (dbfPreCliL)->lControl
               (dbfTmpLin)->lLinOfe    := (dbfPreCliL)->lLinOfe

               (dbfPreCliL)->( dbSkip() )

            end while

            ( dbfTmpLin )->( dbGoTop() )

            /*
            Pasamos las incidencias del presupuesto----------------------------
            */

            if ( dbfPreCliI )->( dbSeek( cPedido ) )

               while ( dbfPreCliI )->cSerPre + Str( ( dbfPreCliI )->nNumPre ) + ( dbfPreCliI )->cSufPre == cPedido .and. !( dbfPreCliI )->( Eof() )
                  dbPass( dbfPreCliI, dbfTmpInc, .t. )
                  ( dbfPreCliI )->( dbSkip() )
               end while

            end if

            ( dbfPreCliI )->( dbGoTop() )

            /*
            Pasamos los documentos del presupuesto-----------------------------
            */

            if ( dbfPreCliD )->( dbSeek( cPedido ) )

               while ( dbfPreCliD )->cSerPre + Str( ( dbfPreCliD )->nNumPre ) + ( dbfPreCliD )->cSufPre == cPedido .and. !( dbfPreCliD )->( Eof() )
                  dbPass( dbfPreCliD, dbfTmpDoc, .t. )
                  ( dbfPreCliD )->( dbSkip() )
               end while

            end if 

            ( dbfPreCliD )->( dbGoTop() )

            oBrw:refresh()
            oBrw:setFocus()

         end if

         lValid   := .t.

         if ( dbfPreCliT )->( dbRLock() )
            ( dbfPreCliT )->lEstado := .t.
            ( dbfPreCliT )->( dbUnlock() )
         end if

         CursorWE()

      end if

      aGet[ _CNUMSAT ]:Hide()
      aGet[ _CNUMPED ]:Show()

   else

      MsgStop( "Presupuesto no existe" )

   end if

RETURN lValid

//---------------------------------------------------------------------------//

STATIC FUNCTION cSatCli( aGet, aTmp, oBrw, nMode )

   local cDesAlb
   local cPedido  := aGet[ _CNUMSAT ]:VarGet()
   local lValid   := .f.

   if nMode != APPD_MODE .OR. Empty( cPedido )
      return .t.
   end if

   if dbSeekInOrd( cPedido, "nNumSat", dbfSatCliT )

      if ( dbfSatCliT )->lEstado

         MsgStop( "S.A.T. ya procesado" )
         lValid   := .f.

      else

         CursorWait()

         HideImportacion()

         aGet[ _CCODCLI ]:cText( ( dbfSatCliT )->CCODCLI )
         aGet[ _CCODCLI ]:lValid()
         aGet[ _CCODCLI ]:Disable()

         aGet[ _CNOMCLI ]:cText( ( dbfSatCliT )->CNOMCLI )
         aGet[ _CDIRCLI ]:cText( ( dbfSatCliT )->CDIRCLI )
         aGet[ _CPOBCLI ]:cText( ( dbfSatCliT )->CPOBCLI )
         aGet[ _CPRVCLI ]:cText( ( dbfSatCliT )->CPRVCLI )
         aGet[ _CPOSCLI ]:cText( ( dbfSatCliT )->CPOSCLI )
         aGet[ _CDNICLI ]:cText( ( dbfSatCliT )->CDNICLI )
         aGet[ _CTLFCLI ]:cText( ( dbfSatCliT )->CTLFCLI )

         aGet[ _CCODALM ]:cText( ( dbfSatCliT )->CCODALM )
         aGet[ _CCODALM ]:lValid()

         aGet[ _CCODCAJ ]:cText( ( dbfSatCliT )->cCodCaj )
         aGet[ _CCODCAJ ]:lValid()

         aGet[ _CCODPAGO]:cText( ( dbfSatCliT )->CCODPGO )
         aGet[ _CCODPAGO]:lValid()

         aGet[ _CCODAGE ]:cText( ( dbfSatCliT )->CCODAGE )
         aGet[ _CCODAGE ]:lValid()

         aGet[ _NPCTCOMAGE]:cText( ( dbfSatCliT )->nPctComAge )

         aGet[ _CCODTAR ]:cText( ( dbfSatCliT )->CCODTAR )
         aGet[ _CCODTAR ]:lValid()

         aGet[ _CCODOBR ]:cText( ( dbfSatCliT )->CCODOBR )
         aGet[ _CCODOBR ]:lValid()

         aGet[ _NTARIFA ]:cText( ( dbfSatCliT )->nTarifa )

         aGet[ _CCODTRN ]:cText( ( dbfSatCliT )->cCodTrn )
         aGet[ _CCODTRN ]:lValid() 

         aGet[ _LIVAINC ]:Click( ( dbfSatCliT )->lIvaInc )
         aGet[ _LRECARGO]:Click( ( dbfSatCliT )->lRecargo )
         aGet[ _LOPERPV ]:Click( ( dbfSatCliT )->lOperPv )

         aGet[ _CCONDENT]:cText( ( dbfSatCliT )->cCondEnt )
         aGet[ _MCOMENT ]:cText( ( dbfSatCliT )->mComent )
         aGet[ _MOBSERV ]:cText( ( dbfSatCliT )->mObserv )

         aGet[ _CDTOESP ]:cText( ( dbfSatCliT )->cDtoEsp )
         aGet[ _CDPP    ]:cText( ( dbfSatCliT )->cDpp    )
         aGet[ _NDTOESP ]:cText( ( dbfSatCliT )->nDtoEsp )
         aGet[ _NDPP    ]:cText( ( dbfSatCliT )->nDpp    )
         aGet[ _CDTOUNO ]:cText( ( dbfSatCliT )->cDtoUno )
         aGet[ _NDTOUNO ]:cText( ( dbfSatCliT )->nDtoUno )
         aGet[ _CDTODOS ]:cText( ( dbfSatCliT )->cDtoDos )
         aGet[ _NDTODOS ]:cText( ( dbfSatCliT )->nDtoDos )
         aGet[ _CMANOBR ]:cText( ( dbfSatCliT )->cManObr )
         aGet[ _NIVAMAN ]:cText( ( dbfSatCliT )->nIvaMan )
         aGet[ _NMANOBR ]:cText( ( dbfSatCliT )->nManObr )
         aGet[ _NBULTOS ]:cText( ( dbfSatCliT )->nBultos )

         aTmp[ _CCODGRP]         := ( dbfSatCliT )->cCodGrp
         aTmp[ _LMODCLI]         := ( dbfSatCliT )->lModCli

         /*
         Datos de alquileres---------------------------------------------------
         */

         aTmp[ _LALQUILER ]      := ( dbfSatCliT )->lAlquiler
         aTmp[ _DFECENTR  ]      := ( dbfSatCliT )->dFecEntr
         aTmp[ _DFECSAL   ]      := ( dbfSatCliT )->dFecSal

         if ( dbfSatCliL )->( dbSeek( cPedido ) )

            ( dbfTmpLin )->( dbAppend() )
            cDesAlb                    := ""
            cDesAlb                    += "S.A.T. Nº " + ( dbfSatCliT )->cSerSat + "/" + AllTrim( Str( ( dbfSatCliT )->nNumSat ) ) + "/" + ( dbfSatCliT )->cSufSat
            cDesAlb                    += " - Fecha " + Dtoc( ( dbfSatCliT )->dFecSat )
            ( dbfTmpLin )->MLNGDES     := cDesAlb
            ( dbfTmpLin )->LCONTROL    := .t.

            while ( (dbfSatCliL)->cSerSat + Str( (dbfSatCliL)->nNumSat ) + (dbfSatCliL)->cSufSat == cPedido )

               (dbfTmpLin)->( dbAppend() )

               (dbfTmpLin)->nNumLin    := (dbfSatCliL)->nNumLin
               (dbfTmpLin)->cRef       := (dbfSatCliL)->cRef
               (dbfTmpLin)->cDetalle   := (dbfSatCliL)->cDetAlle
               (dbfTmpLin)->mLngDes    := (dbfSatCliL)->mLngDes
               (dbfTmpLin)->mNumSer    := (dbfSatCliL)->mNumSer
               (dbfTmpLin)->nPreUnit   := (dbfSatCliL)->nPreDiv
               (dbfTmpLin)->nPntVer    := (dbfSatCliL)->nPntVer
               (dbfTmpLin)->nImpTrn    := (dbfSatCliL)->nImpTrn
               (dbfTmpLin)->nPesoKG    := (dbfSatCliL)->nPesokg
               (dbfTmpLin)->cPesoKG    := (dbfSatCliL)->cPesokg
               (dbfTmpLin)->cUnidad    := (dbfSatCliL)->cUnidad
               (dbfTmpLin)->nVolumen   := (dbfSatCliL)->nVolumen
               (dbfTmpLin)->cVolumen   := (dbfSatCliL)->cVolumen
               (dbfTmpLin)->nIVA       := (dbfSatCliL)->nIva
               (dbfTmpLin)->nReq       := (dbfSatCliL)->nReq
               (dbfTmpLin)->cUNIDAD    := (dbfSatCliL)->cUnidad
               (dbfTmpLin)->nDTO       := (dbfSatCliL)->nDto
               (dbfTmpLin)->nDTOPRM    := (dbfSatCliL)->nDtoPrm
               (dbfTmpLin)->nCOMAGE    := (dbfSatCliL)->nComAge
               (dbfTmpLin)->lTOTLIN    := (dbfSatCliL)->lTotLin
               (dbfTmpLin)->nDtoDiv    := (dbfSatCliL)->nDtoDiv
               (dbfTmpLin)->nCtlStk    := (dbfSatCliL)->nCtlStk
               (dbfTmpLin)->nCosDiv    := (dbfSatCliL)->nCosDiv
               (dbfTmpLin)->cTipMov    := (dbfSatCliL)->cTipMov
               (dbfTmpLin)->cAlmLin    := (dbfSatCliL)->cAlmLin
               (dbfTmpLin)->cCodImp    := (dbfPedCLiL)->cCodImp
               (dbfTmpLin)->nValImp    := (dbfSatCliL)->nValImp
               (dbfTmpLin)->CCODPR1    := (dbfSatCliL)->cCodPr1
               (dbfTmpLin)->CCODPR2    := (dbfSatCliL)->cCodPr2
               (dbfTmpLin)->CVALPR1    := (dbfSatCliL)->cValPr1
               (dbfTmpLin)->CVALPR2    := (dbfSatCliL)->cValPr2
               (dbfTmpLin)->nCanEnt    := (dbfSatCLiL)->nCanSat
               (dbfTmpLin)->nUniCaja   := (dbfSatCLiL)->nUniCaja
               (dbfTmpLin)->nUndKit    := (dbfSatCLiL)->nUndKit
               (dbfTmpLin)->lKitArt    := (dbfSatCLiL)->lKitArt
               (dbfTmpLin)->lKitChl    := (dbfSatCLiL)->lKitChl
               (dbfTmpLin)->lKitPrc    := (dbfSatCliL)->lKitPrc
               (dbfTmpLin)->nMesGrt    := (dbfSatCLiL)->nMesGrt
               (dbfTmpLin)->lLote      := (dbfSatCliL)->lLote
               (dbfTmpLin)->nLote      := (dbfSatCliL)->nLote
               (dbfTmpLin)->cLote      := (dbfSatCliL)->cLote
               (dbfTmpLin)->lMsgVta    := (dbfSatCliL)->lMsgVta
               (dbfTmpLin)->lNotVta    := (dbfSatCliL)->lNotVta
               (dbfTmpLin)->lImpLin    := (dbfSatCliL)->lImpLin
               (dbfTmpLin)->cCodTip    := (dbfSatCliL)->cCodTip
               (dbfTmpLin)->mObsLin    := (dbfSatCliL)->mObsLin
               (dbfTmpLin)->Descrip    := (dbfPedCliL)->Descrip
               (dbfTmpLin)->cCodPrv    := (dbfSatCliL)->cCodPrv
               (dbfTmpLin)->cNomPrv    := (dbfSatCliL)->cNomPrv
               (dbfTmpLin)->cImagen    := (dbfSatCliL)->cImagen
               (dbfTmpLin)->cCodFam    := (dbfSatCliL)->cCodFam
               (dbfTmpLin)->cGrpFam    := (dbfSatCliL)->cGrpFam
               (dbfTmpLin)->cRefPrv    := (dbfSatCliL)->cRefPrv
               (dbfTmpLin)->dFecEnt    := (dbfSatCliL)->dFecEnt
               (dbfTmpLin)->dFecSal    := (dbfSatCliL)->dFecSal
               (dbfTmpLin)->nPreAlq    := (dbfSatCliL)->nPreAlq
               (dbfTmpLin)->lAlquiler  := (dbfSatCliL)->lAlquiler
               (dbfTmpLin)->nNumMed    := (dbfSatCliL)->nNumMed
               (dbfTmpLin)->nMedUno    := (dbfSatCliL)->nMedUno
               (dbfTmpLin)->nMedDos    := (dbfSatCliL)->nMedDos
               (dbfTmpLin)->nMedTre    := (dbfSatCliL)->nMedTre
               (dbfTmpLin)->nPuntos    := (dbfSatCliL)->nPuntos
               (dbfTmpLin)->nValPnt    := (dbfSatCliL)->nValPnt
               (dbfTmpLin)->nDtoPnt    := (dbfSatCliL)->nDtoPnt
               (dbfTmpLin)->nIncPnt    := (dbfSatCliL)->nIncPnt
               (dbfTmpLin)->lControl   := (dbfSatCliL)->lControl
               (dbfTmpLin)->lLinOfe    := (dbfSatCliL)->lLinOfe

               (dbfSatCliL)->( dbSkip() )

            end while

            ( dbfTmpLin )->( dbGoTop() )

            /*
            Pasamos las incidencias del SAT----------------------------
            */

            if ( dbfSatCliI )->( dbSeek( cPedido ) )

               while ( dbfSatCliI )->cSerSat + Str( ( dbfSatCliI )->nNumSat ) + ( dbfSatCliI )->cSufSat == cPedido .and. !( dbfSatCliI )->( Eof() )
                  dbPass( dbfSatCliI, dbfTmpInc, .t. )
                  ( dbfSatCliI )->( dbSkip() )
               end while

            end if

            ( dbfSatCliI )->( dbGoTop() )

            /*
            Pasamos los documentos del SAT-----------------------------
            */

            if ( dbfSatCliD )->( dbSeek( cPedido ) )

               while ( dbfSatCliD )->cSerSat + Str( ( dbfSatCliD )->nNumSat ) + ( dbfSatCliD )->cSufSat == cPedido .and. !( dbfSatCliD )->( Eof() )
                  dbPass( dbfSatCliD, dbfTmpDoc, .t. )
                  ( dbfSatCliD )->( dbSkip() )
               end while

            end if 
   
            /*
            Pasamos todas las series----------------------------------------------
            */

            if ( dbfSatCliS )->( dbSeek( cPedido ) )

               while ( dbfSatCliS )->cSerSat + Str( ( dbfSatCliS )->nNumSat ) + ( dbfSatCliS )->cSufSat == cPedido .and. !( dbfSatCliS )->( Eof() )
                  dbPass( dbfSatCliS, dbfTmpSer, .t. )
                  ( dbfSatCliS )->( dbSkip() )
               end while

            end if 

            oBrw:refresh()
            oBrw:setFocus()

         end if

         lValid   := .t.

         if ( dbfSatCliT )->( dbRLock() )
            ( dbfSatCliT )->lEstado := .t.
            ( dbfSatCliT )->( dbUnlock() )
         end if

         CursorWE()

      end if

      aGet[ _CNUMPED ]:Hide()
      aGet[ _CNUMSAT ]:Show()

   else

      MsgStop( "S.A.T. no existe" )

   end if

RETURN lValid

//---------------------------------------------------------------------------//

/*
Funcion que nos permite a¤adir a los albaranes pedidos ye existentes
*/

STATIC FUNCTION GrpSat( aGet, aTmp, oBrw )

   local oDlg
   local nDiv
   local nItem       := 1
   local cCodAge
   local oBrwLin
   local nOrdAnt
   local nNumLin
   local lCodAge     := .f.
   local nOffSet     := 0
   local cDesAlb     := ""
   local cCodCli     := aGet[ _CCODCLI ]:varGet()
   local nTotPed
   local nTotRec
   local nTotPdt
   local lAlquiler   := .f.
   local cCliente    := RTrim( aTmp[ _CNOMCLI ] )
   local cObra       := if( Empty( aTmp[ _CCODOBR ] ), "Todas", Rtrim( aTmp[ _CCODOBR ] ) )  
   local cIva        := cImp() + Space( 1 ) + if( aTmp[ _LIVAINC ], "Incluido", "Desglosado" )

   aSats             := {}

   if !Empty( oTipAlb ) .and. oTipAlb:nAt == 2
      lAlquiler      := .t.
   end if

   if Empty( cCodCli )
      msgStop( "Es necesario codificar un cliente", "Agrupar SAT" )
      return .t.
   end if

   if !Empty( aGet[ _CNUMSAT ]:VarGet() )
      msgStop( "Ya ha importado un SAT", "Agrupar SAT" )
      return .t.
   end if


   /*
   Seleccion de Registros
   --------------------------------------------------------------------------
   */

   CursorWait()
   
   nOrdAnt           := ( dbfSatCliT )->( ordSetFocus( "cCodCli" ) )

   if ( dbfSatCliT )->( dbSeek( cCodCli ) )

      while ( dbfSatCliT )->cCodCli == cCodCli .and. ( dbfSatCliT )->( !eof() )

         if ( dbfSatCliT )->lAlquiler == lAlquiler                                              .and.;
            !( dbfSatCliT )->lEstado                                                            .and.;
            ( dbfSatCliT )->lIvaInc == aTmp[ _LIVAINC ]                                         .and.;
            if( Empty( aTmp[ _CCODOBR ] ), .t., ( dbfSatCliT )->cCodObr == aTmp[ _CCODOBR ] )   .and.;
            aScan( aNumSat, ( dbfSatCliT )->cSerSat + Str( ( dbfSatCliT )->nNumSat ) + ( dbfSatCliT )->cSufSat ) == 0

            aAdd( aSats,    {  .f. ,;
                                 ( dbfSatCliT )->lEstado,;
                                 ( dbfSatCliT )->cSerSat + Str( ( dbfSatCliT )->nNumSat ) + ( dbfSatCliT )->cSufSat,;
                                 ( dbfSatCliT )->dFecSat ,;
                                 ( dbfSatCliT )->cCodCli ,;
                                 ( dbfSatCliT )->cNomCli ,;
                                 ( dbfSatCliT )->cCodObr ,;
                                 RetObras( ( dbfSatCliT )->cCodCli, ( dbfSatCliT )->cCodObr, dbfObrasT ),;
                                 ( dbfSatCliT )->cCodAge,;
                                 ( dbfSatCliT )->nTotSat } )

         endif

         ( dbfSatCliT )->( dbSkip() )

      end while

   end if

   ( dbfSatCliT )->( ordSetFocus( nOrdAnt ) )

   CursorWE()

   /*
   Puede que no hay albaranes que facturar-------------------------------------
   */

   if Len( aSats ) == 0
      msgStop( "No existen S.A.T. pendientes de este cliente" )
      return .t.
   end if

   /*
   Caja de Dialogo
   ----------------------------------------------------------------------------
   */

   DEFINE DIALOG  oDlg ;
      RESOURCE    "SET_ALBARAN" ;
      TITLE       "Agrupando S.A.T."

      REDEFINE SAY PROMPT cCliente ;
         ID       501 ;
         OF       oDlg

      REDEFINE SAY PROMPT cObra ;
         ID       502 ;
         OF       oDlg

      REDEFINE SAY PROMPT cIva ;
         ID       503 ;
         OF       oDlg

      oBrwLin                       := TXBrowse():New( oDlg )

      oBrwLin:bClrSel               := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwLin:bClrSelFocus          := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrwLin:SetArray( aSats, , , .f. )
      oBrwLin:lHscroll              := .f.

      oBrwLin:nMarqueeStyle         := 5
      oBrwLin:lRecordSelector       := .f.

      oBrwLin:CreateFromResource( 130 )

      oBrwLin:bLDblClick            := {|| aSats[ oBrwLin:nArrayAt, 1 ] := !aSats[ oBrwLin:nArrayAt, 1 ], oBrwLin:refresh() }

      with object ( oBrwLin:AddCol() )
         :cHeader          := "Seleccionado"
         :bStrData         := {|| "" }
         :bEditValue       := {|| aSats[ oBrwLin:nArrayAt, 1 ] }
         :nWidth           := 20
         :SetCheck( { "Sel16", "Nil16" } )
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader          := "Estado"
         :bStrData         := {|| "" }
         :bEditValue       := {|| ( aSats[ oBrwLin:nArrayAt, 2 ] ) }
         :nWidth           := 20
         :SetCheck( { "Bullet_Square_Yellow_16", "Bullet_Square_Red_16" } )
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader          := "Número"
         :bEditValue       := {|| aSats[ oBrwLin:nArrayAt, 3 ] }
         :cEditPicture     := "@R #/999999999/##"
         :nWidth           := 80
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader          := "Fecha"
         :bEditValue       := {|| Dtoc( aSats[ oBrwLin:nArrayAt, 4 ] ) }
         :nWidth           := 80
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader          := "Cliente"
         :bEditValue       := {|| Rtrim( aSats[ oBrwLin:nArrayAt, 5 ] ) + Space(1) + aSats[ oBrwLin:nArrayAt, 6 ] }
         :nWidth           := 250
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader          := "Obra"
         :bEditValue       := {|| Rtrim( aSats[ oBrwLin:nArrayAt, 7 ] ) + Space(1) + aSats[ oBrwLin:nArrayAt, 8 ] }
         :nWidth           := 220
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader          := "Agente"
         :bEditValue       := {|| aSats[ oBrwLin:nArrayAt, 9 ] }
         :lHide            := .t.
         :nWidth           := 60
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader          := "Total"
         :bEditValue       := {|| aSats[ oBrwLin:nArrayAt, 10 ] }
         :cEditPicture     := cPorDiv( ( dbfSatCliT )->cDivSat, dbfDiv )
         :nWidth           := 80
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      REDEFINE BUTTON ;
         ID       514 ;
         OF       oDlg ;
         ACTION   (  aSats[ oBrwLin:nArrayAt, 1 ] := !aSats[ oBrwLin:nArrayAt, 1 ],;
                     oBrwLin:refresh(),;
                     oBrwLin:setFocus() )

      REDEFINE BUTTON ;
         ID       516 ;
         OF       oDlg ;
         ACTION   (  aEval( aSats, { |aItem| aItem[1] := .t. } ),;
                     oBrwLin:refresh(),;
                     oBrwLin:setFocus() )

      REDEFINE BUTTON ;
         ID       517 ;
         OF       oDlg ;
         ACTION   (  aEval( aSats, { |aItem| aItem[1] := .f. } ),;
                     oBrwLin:Refresh(),;
                     oBrwLin:SetFocus() )

      REDEFINE BUTTON ;
         ID       518 ;
         OF       oDlg ;
         ACTION   ( ZooSatCli( aSats[ oBrwLin:nArrayAt, 3 ] ) )

      REDEFINE BUTTON ;
         ID       IDOK ;
         OF       oDlg ;
         ACTION   ( oDlg:end( IDOK ) )

      REDEFINE BUTTON ;
         ID       IDCANCEL ;
         OF       oDlg ;
         ACTION   ( oDlg:end() )

   ACTIVATE DIALOG oDlg CENTER

   if oDlg:nResult != IDOK
      aSats       := {}
   end if

   /*
   Llamada a la funcion que busca el Albaran-----------------------------------
   */

   if oDlg:nResult == IDOK .and. Len( aSats ) >= 1

      CursorWait()

      HideImportacion()      

      /*
      A¤adimos los albaranes seleccionado para despues-------------------------
      */

      for nItem := 1 to Len( aSats )

         if ( aSats[ nItem, 1 ] )

            aAdd( aNumSat, aSats[ nItem, 3 ] )

            if Empty( cCodAge )
               cCodAge  := aSats[ nItem, 9 ]
            end if

            if cCodAge != aSats[ nItem, 9 ]
               lCodAge  := .t.
            end if

         end if

      next

      if lCodAge
         MsgInfo( "Existen conflictos de agentes" )
      end if

      for nItem := 1 to Len( aSats )

         /*
         Cabeceras de albaranes a facturas-------------------------------------
         */

         if !lCodAge .and. cCodAge != nil
            aGet[ _CCODAGE ]:cText( cCodAge )
            aGet[ _CCODAGE ]:lValid()
         end if

         if ( dbfSatCliT )->( dbSeek( aSats[ nItem, 3 ] ) ) .and. aSats[ nItem, 1 ]

            if ( dbfSatCliT )->lRecargo
               aTmp[ _LRECARGO ] := .t.
               aGet[ _LRECARGO ]:Refresh()
            end if

            if ( dbfSatCliT )->lOperPv
               aTmp[ _LOPERPV ] := .t.
               aGet[ _LOPERPV ]:Refresh()
            end if

         end if

         /*
         Detalle de albaranes a facturas---------------------------------------
         */

         if ( dbfSatCliL )->( dbSeek( aSats[ nItem, 3] ) ) .AND. aSats[ nItem, 1]

            /*
            Cabeceras de Albaranes-----------------------------------------------
            */

            nNumLin                       := nil

            ( dbfTmpLin )->( dbAppend() )
            cDesAlb                       := "SAT Nº " + StrTran( Alltrim( Trans( aSats[ nItem, 3 ], "@R #/999999999/##" ) ), " ", "" )
            cDesAlb                       += " - Fecha " + Dtoc( aSats[ nItem, 4] )
            ( dbfTmpLin )->mLngDes        := cDesAlb
            ( dbfTmpLin )->lControl       := .t.
            ( dbfTmpLin )->nNumLin        := ++nOffSet

            /*
            Mientras estemos en el mismo Satido--------------------------------
            */

            while ( dbfSatCliL )->cSerSat + Str( ( dbfSatCliL )->nNumSat ) + ( dbfSatCliL )->cSufSat == aSats[ nItem, 3]

               if nNumLin != (dbfSatCliL)->nNumLin
                  ++nOffSet
                  nNumLin                 := ( dbfSatCliL )->nNumLin
               end if

               ( dbfTmpLin )->( dbAppend() )

               ( dbfTmpLin )->cNumSat     := aSats[ nItem, 3 ]
               ( dbfTmpLin )->nNumAlb     := 0 
               ( dbfTmpLin )->nNumLin     := nOffSet
               ( dbfTmpLin )->cRef        := ( dbfSatCliL )->cRef
               ( dbfTmpLin )->cDetalle    := ( dbfSatCliL )->cDetalle
               ( dbfTmpLin )->mLngDes     := ( dbfSatCliL )->mLngDes
               ( dbfTmpLin )->nPreUnit    := ( dbfSatCliL )->nPreDiv
               ( dbfTmpLin )->cUnidad     := ( dbfSatCliL )->cUnidad
               ( dbfTmpLin )->nPesoKg     := ( dbfSatCliL )->nPesoKg
               ( dbfTmpLin )->cPesoKg     := ( dbfSatCliL )->cPesoKg
               ( dbfTmpLin )->nVolumen    := ( dbfSatCliL )->nVolumen
               ( dbfTmpLin )->cVolumen    := ( dbfSatCliL )->cVolumen
               ( dbfTmpLin )->nIva        := ( dbfSatClil )->nIva
               ( dbfTmpLin )->nReq        := ( dbfSatClil )->nReq
               ( dbfTmpLin )->nDto        := ( dbfSatClil )->nDto
               ( dbfTmpLin )->nPntVer     := ( dbfSatCliL )->nPntVer
               ( dbfTmpLin )->nImpTrn     := ( dbfSatCliL )->nImpTrn
               ( dbfTmpLin )->nDtoPrm     := ( dbfSatCliL )->nDtoPrm
               ( dbfTmpLin )->nComAge     := ( dbfSatCliL )->nComAge
               ( dbfTmpLin )->dFecHa      := ( dbfSatCliL )->dFecha
               ( dbfTmpLin )->cTipMov     := ( dbfSatCliL )->cTipMov
               ( dbfTmpLin )->nDtoDiv     := ( dbfSatCliL )->nDtoDiv
               ( dbfTmpLin )->nUniCaja    := ( dbfSatCliL )->nUniCaja
               ( dbfTmpLin )->nCanEnt     := ( dbfSatCliL )->nCanSat 
               ( dbfTmpLin )->nUndKit     := ( dbfSatCliL )->nUndKit
               ( dbfTmpLin )->lKitArt     := ( dbfSatCliL )->lKitArt
               ( dbfTmpLin )->lKitChl     := ( dbfSatCliL )->lKitChl
               ( dbfTmpLin )->lKitPrc     := ( dbfSatCliL )->lKitPrc
               ( dbfTmpLin )->cCodPr1     := ( dbfSatCliL )->cCodPr1
               ( dbfTmpLin )->cCodPr2     := ( dbfSatCliL )->cCodPr2
               ( dbfTmpLin )->cValPr1     := ( dbfSatCliL )->cValPr1
               ( dbfTmpLin )->cValPr2     := ( dbfSatCliL )->cValPr2
               ( dbfTmpLin )->nCosDiv     := ( dbfSatCliL )->nCosDiv
               ( dbfTmpLin )->nMesGrt     := ( dbfSatCliL )->nMesGrt
               ( dbfTmpLin )->lMsgVta     := ( dbfSatCliL )->lMsgVta
               ( dbfTmpLin )->lNotVta     := ( dbfSatCliL )->lNotVta
               ( dbfTmpLin )->lLote       := ( dbfSatCliL )->lLote
               ( dbfTmpLin )->nLote       := ( dbfSatCliL )->nLote
               ( dbfTmpLin )->cLote       := ( dbfSatCliL )->cLote
               ( dbfTmpLin )->mObsLin     := ( dbfSatCliL )->mObsLin
               ( dbfTmpLin )->Descrip     := ( dbfSatCliL )->Descrip
               ( dbfTmpLin )->cCodPrv     := ( dbfSatCliL )->cCodPrv
               ( dbfTmpLin )->cNomPrv     := ( dbfSatCliL )->cNomPrv
               ( dbfTmpLin )->cCodFam     := ( dbfSatCliL )->cCodFam
               ( dbfTmpLin )->cGrpFam     := ( dbfSatCliL )->cGrpFam
               ( dbfTmpLin )->cAlmLin     := ( dbfSatCliL )->cAlmLin
               ( dbfTmpLin )->cRefPrv     := ( dbfSatCliL )->cRefPrv
               ( dbfTmpLin )->dFecEnt     := ( dbfSatCliL )->dFecEnt
               ( dbfTmpLin )->dFecSal     := ( dbfSatCliL )->dFecSal
               ( dbfTmpLin )->lAlquiler   := ( dbfSatCliL )->lAlquiler
               ( dbfTmpLin )->nPreAlq     := ( dbfSatCliL )->nPreAlq
               ( dbfTmpLin )->cUnidad     := ( dbfSatCliL )->cUnidad
               ( dbfTmpLin )->nNumMed     := ( dbfSatCliL )->nNumMed
               ( dbfTmpLin )->nMedUno     := ( dbfSatCliL )->nMedUno
               ( dbfTmpLin )->nMedDos     := ( dbfSatCliL )->nMedDos
               ( dbfTmpLin )->nMedTre     := ( dbfSatCliL )->nMedTre
               ( dbfTmpLin )->nPuntos     := ( dbfSatCliL )->nPuntos
               ( dbfTmpLin )->nValPnt     := ( dbfSatCliL )->nValPnt
               ( dbfTmpLin )->nDtoPnt     := ( dbfSatCliL )->nDtoPnt
               ( dbfTmpLin )->nIncPnt     := ( dbfSatCliL )->nIncPnt
               ( dbfTmpLin )->lLinOfe     := ( dbfSatCliL )->lLinOfe
               
               ( dbfTmpLin )->( dbUnLock() )
             
               /*
               Pasamos todas las series----------------------------------------
               */

               if ( dbfSatCliS )->( dbSeek( aSats[ nItem, 3] + Str( nNumLin, 4 ) ) ) .and. ( aSats[ nItem, 1 ] )

                  while ( dbfSatCliS )->cSerSat + Str( ( dbfSatCliS )->nNumSat ) + ( dbfSatCliS )->cSufSat + Str( ( dbfSatCliS )->nNumLin ) == aSats[ nItem, 3] + Str( nNumLin, 4 ) .and. !( dbfSatCliS )->( Eof() )
                  
                     ( dbfTmpSer )->( dbAppend() )
                     ( dbfTmpSer )->nNumLin  := nOffSet
                     ( dbfTmpSer )->cRef     := ( dbfSatCliS )->cRef
                     ( dbfTmpSer )->cAlmLin  := ( dbfSatCliS )->cAlmLin
                     ( dbfTmpSer )->cNumSer  := ( dbfSatCliS )->cNumSer
                     ( dbfTmpSer )->( dbUnLock() )
                  
                     ( dbfSatCliS )->( dbSkip() )

                  end while

               end if 

               ( dbfSatCliL )->( dbSkip() ) 

            end while

            ( dbfTmpLin )->( dbGoTop() )

            /*
            Pasamos las incidencias del SAT------------------------------------
            */

            if ( dbfSatCliI )->( dbSeek( aSats[ nItem, 3] ) ) .and. aSats[ nItem, 1 ]

               while ( dbfSatCliI )->cSerSat + Str( ( dbfSatCliI )->nNumSat ) + ( dbfSatCliI )->cSufSat == aSats[ nItem, 3] .and. !( dbfSatCliI )->( Eof() )
                  dbPass( dbfSatCliI, dbfTmpInc, .t. )
                  ( dbfSatCliI )->( dbSkip() )
               end while

            end if

            ( dbfSatCliI )->( dbGoTop() )

            /*
            Pasamos los documentos del SAT-------------------------------------
            */

            if ( dbfSatCliD )->( dbSeek( aSats[ nItem, 3] ) ) .and. aSats[ nItem, 1 ]

               while ( dbfSatCliD )->cSerSat + Str( ( dbfSatCliD )->nNumSat ) + ( dbfSatCliD )->cSufSat == aSats[ nItem, 3] .and. !( dbfSatCliD )->( Eof() )
                  dbPass( dbfSatCliD, dbfTmpDoc, .t. )
                  ( dbfSatCliD )->( dbSkip() )
               end while

            end if 
   
         end if

      next

      /*
      No dejamos importar Albaranes directos-----------------------------------
      */

      aGet[ _CNUMSAT ]:bWhen           := {|| .f. }
      aGet[ _CNUMSAT ]:Disable()

      /*
      Refresco de lineas-------------------------------------------------------
      */
      
      oBrw:Refresh()

      /*
      Recalculo de totales-----------------------------------------------------
      */

      RecalculaTotal( aTmp )

      CursorWE()

   end if

return .t.

//---------------------------------------------------------------------------//

Static Function HideImportacion()

   oBtnPre:Hide()
   oBtnPed:Hide()
   oBtnSat:Hide()

   oBtnAgruparPedido:Hide()
   oBtnAgruparSat:Hide()

Return nil 

//---------------------------------------------------------------------------//

