#include "FiveWin.ch"
#include "Folder.ch"
#include "Report.ch"
#include "Label.ch"
#include "Factu.ch"
#include "Menu.ch"
#include "Xbrowse.ch"
#include "FastRepH.ch"

#define _MENUITEM_               "01047"

#define _ICG_LINE_LEN_           211

/*
Definici¢n de la base de datos de albaranes a proveedores
*/

#define _CSERALB                   1     //   C      1     0 "CSERALB",
#define _NNUMALB                   2     //   N      9     0 "NNUMALB",
#define _CSUFALB                   3     //   C      2     0 "CSUFALB",
#define _CTURALB                   4     //   C      6     0 "CTURALB",
#define _DFECALB                   5     //   D      8     0 "DFECALB",
#define _CCODPRV                   6     //   C      7     0 "CCODPRV",
#define _CCODALM                   7     //   C      3     0 "CCODALM",
#define _CCODCAJ                   8     //   C      3     0 "CCODCAJ",
#define _CNOMPRV                   9     //   C     35     0 "CNOMPRV",
#define _CDIRPRV                  10     //   C     35     0 "CDIRPRV",
#define _CPOBPRV                  11     //   C     25     0 "CPOBPRV",
#define _CPROPRV                  12     //   C     20     0 "CPROPRV",
#define _CPOSPRV                  13     //   C      5     0 "CPOSPRV",
#define _CDNIPRV                  14     //   C     15     0 "CDNIPRV",
#define _DFECENT                  15     //   D      8     0 "DFECENT",
#define _CSUALB                   16     //   C     10     0 "CSUALB",
#define _DSUALB                   17     //   C     10     0 "DSUALB",
#define _CCODPGO                  18     //   C      2     0 "CCODPGO",
#define _NBULTOS                  19     //   N      3     0 "NBULTOS",
#define _NPORTES                  20     //   N      6     0 "NPORTES",
#define _CDTOESP                  21     //   N      4     1 "CDTOESP",
#define _NDTOESP                  22     //   N      4     1 "NDTOESP",
#define _CDPP                     23     //   N      4     1 "CDPP",
#define _NDPP                     24     //   N      4     1 "NDPP",
#define _LRECARGO                 25     //   L      1     0 "LRECARGO",
#define _CCONDENT                 26     //   C     20     0 "CCONDENT",
#define _CEXPED                   27     //   C     20     0 "CEXPED",
#define _COBSERV                  28     //   M     10     0 "COBSERV",
#define _CNUMPED                  29     //   C     13     0 "CNUMPED",
#define _LFACTURADO               30     //   L      1     0 "LFACTURADO"
#define _CNUMFAC                  31     //   C     12     0 "CNUMFAC",
#define _CDIVALB                  32     //   C      3     0 "CDIVALB",
#define _NVDVALB                  33     //   N     10     4 "NVDVALB",
#define _LSNDDOC                  34     //   L      1     0 "LSNDDOC",
#define _CDTOUNO                  35     //   N      4     1 "CDTOUNO",
#define _NDTOUNO                  36     //   N      4     1 "NDTOUNO",
#define _CDTODOS                  37     //   N      4     1 "CDTODOS",
#define _NDTODOS                  38     //   N      4     1 "NDTODOS",
#define _LCLOALB                  39     //   N      4     1 "LCLOALB",
#define _CCODUSR                  40     //                  "CCODUSR",
#define _CCODUBIT1                41     //   C      5     0 "CCODUBIT1",
#define _CCODUBIT2                42     //   C      5     0 "CCODUBIT2",
#define _CCODUBIT3                43     //   C      5     0 "CCODUBIT3",
#define _CVALUBIT1                44     //   C      5     0 "CVALUBIT1",
#define _CVALUBIT2                45     //   C      5     0 "CVALUBIT2",
#define _CVALUBIT3                46     //   C      5     0 "CVALUBIT3",
#define _CNOMUBIT1                47     //   C     30     0 "CNOMUBIT1",
#define _CNOMUBIT2                48     //   C     30     0 "CNOMUBIT2",
#define _CNOMUBIT3                49     //   C     30     0 "CNOMUBIT3",
#define _LIMPRIMIDO               50     //   L      1     0 "LIMPRIMIDO"
#define _DFECIMP                  51     //   D      8     0 "DFECIMP",
#define _CHORIMP                  52     //   C      5     0 "CHORIMP",
#define _DFECCHG                  53     //                  "DFECCHG",
#define _CTIMCHG                  54     //                  "CTIMCHG",
#define _CCODDLG                  55     //                  "CCODDLG",
#define _NREGIVA                  56     //   L      1     0
#define _NTOTNET                  57
#define _NTOTIVA                  58
#define _NTOTREQ                  59
#define _NTOTALB                  60

/*
Definici¢n de la base de datos de lineas de detalle
*/

#define _CREF                      4    //   C     14     0
#define _CREFPRV                   5    //   C     14     0
#define _CDETALLE                  6    //   C     35     0
#define _NIVA                      7    //   N      6     2
#define _NUNICAJA                  8    //   N     13     3
#define _NCANENT                   9    //   N     13     3
#define _NPREDIV                  10    //   N     13     3
#define _NCANPED                  11    //   N     13     3
#define _NUNIPED                  12    //   N     13     3
#define _CUNIDAD                  13    //   C      2     0
#define _MLNGDES                  14    //   M     10     0
#define _NDTOLIN                  15    //   N      5     2
#define _NDTOPRM                  16
#define _NDTORAP                  17
#define _NPRECOM                  18    //   N      5     2
#define _LBNFLIN1                 19    //   N      5     1
#define _LBNFLIN2                 20    //   N      5     1
#define _LBNFLIN3                 21    //   N      5     1
#define _LBNFLIN4                 22    //   N      5     1
#define _LBNFLIN5                 23    //   N      5     1
#define _LBNFLIN6                 24    //   N      5     1
#define _NBNFLIN1                 25    //   N      5     1
#define _NBNFLIN2                 26    //   N      5     1
#define _NBNFLIN3                 27    //   N      5     1
#define _NBNFLIN4                 28    //   N      5     1
#define _NBNFLIN5                 29    //   N      5     1
#define _NBNFLIN6                 30    //   N      5     1
#define _NBNFSBR1                 31    //   N     13     3
#define _NBNFSBR2                 32    //   N     13     3
#define _NBNFSBR3                 33    //   N     13     3
#define _NBNFSBR4                 34    //   N     13     3
#define _NBNFSBR5                 35    //   N     13     3
#define _NBNFSBR6                 36    //   N     13     3
#define _NPVPLIN1                 37    //   N      6     2
#define _NPVPLIN2                 38    //   L      1     0
#define _NPVPLIN3                 39    //   L      1     0
#define _NPVPLIN4                 40    //   C      5     0
#define _NPVPLIN5                 41    //   C      5     0
#define _NPVPLIN6                 42    //   C      5     0
#define _NIVALIN1                 43    //   C      5     0
#define _NIVALIN2                 44    //   N     13     4
#define _NIVALIN3                 45    //   C     11     0
#define _NIVALIN4                 46    //   C      3     0
#define _NIVALIN5                 47    //   N      1     0
#define _NIVALIN6                 48    //   L      1     0
#define _NIVALIN                  49    //   N      4     0
#define _LIVALIN                  50
#define _LCHGLIN                  51
#define _CCODPR1                  52
#define _CCODPR2                  53
#define _CVALPR1                  54
#define _CVALPR2                  55      //   L     4      0
#define _NFACCNV                  56
#define _CCODPED                  57
#define _CALMLIN                  58
#define _NCTLSTK                  59
#define _LLOTE                    60
#define _NLOTE                    61
#define _CLOTE                    62
#define _NNUMLIN                  63
#define _NUNDKIT                  64
#define _LKITART                  65
#define _LKITCHL                  66
#define _LKITPRC                  67
#define _LIMPLIN                  68
#define _LCONTROL                 69
#define _MNUMSER                  70
#define _NDTO1                    71
#define _NDTO2                    72
#define _NDTO3                    73
#define _NDTO4                    74
#define _NDTO5                    75
#define _NRAP1                    76
#define _NRAP2                    77
#define _NRAP3                    78
#define _NRAP4                    79
#define _NRAP5                    80
#define _CCODUBI1                 81      //   C     5      0
#define _CCODUBI2                 82      //   C     5      0
#define _CCODUBI3                 83      //   C     5      0
#define _CVALUBI1                 84      //   C     5      0
#define _CVALUBI2                 85      //   C     5      0
#define _CVALUBI3                 86      //   C     5      0
#define _CNOMUBI1                 87      //   C    30      0
#define _CNOMUBI2                 88      //   C    30      0
#define _CNOMUBI3                 89      //   C    30      0
#define _CCODFAM                  90      //   C     8      0
#define _CGRPFAM                  91      //   C     3      0
#define _NREQ                     92      //   N    16      6
#define _MOBSLIN                  93      //   M    10      0
#define __CNUMPED                 94
#define _NPVPREC                  95
#define _NNUMMED                  96
#define _NMEDUNO                  97
#define _NMEDDOS                  98
#define _NMEDTRE                  99
#define __LFACTURADO             100      //   L     1      0
#define _DFECCAD                 101      //   D     8      0
#define _NUNDLIN                 102
#define _LLABEL                  103
#define _NLABEL                  104
#define __DFECALB                105
#define _LNUMSER                 106
#define _LAUTSER                 107

/*
Definici¢n de Array para IGIC
*/

#define _NBRTIVA1                aTotIva[ 1, 1 ]
#define _NBASIVA1                aTotIva[ 1, 2 ]
#define _NPCTIVA1                aTotIva[ 1, 3 ]
#define _NPCTREQ1                aTotIva[ 1, 4 ]
#define _NIMPIVA1                aTotIva[ 1, 5 ]
#define _NIMPREQ1                aTotIva[ 1, 6 ]
#define _NBRTIVA2                aTotIva[ 2, 1 ]
#define _NBASIVA2                aTotIva[ 2, 2 ]
#define _NPCTIVA2                aTotIva[ 2, 3 ]
#define _NPCTREQ2                aTotIva[ 2, 4 ]
#define _NIMPIVA2                aTotIva[ 2, 5 ]
#define _NIMPREQ2                aTotIva[ 2, 6 ]
#define _NBRTIVA3                aTotIva[ 3, 1 ]
#define _NBASIVA3                aTotIva[ 3, 2 ]
#define _NPCTIVA3                aTotIva[ 3, 3 ]
#define _NPCTREQ3                aTotIva[ 3, 4 ]
#define _NIMPIVA3                aTotIva[ 3, 5 ]
#define _NIMPREQ3                aTotIva[ 3, 6 ]

memvar cDbf
memvar cDbfCol
memvar cDbfPrv
memvar cDbfPgo
memvar cDbfIva
memvar cDbfDiv
memvar cDbfAlm
memvar cDbfArt
memvar cDbfKit
memvar cDbfPro
memvar cDbfTblPro
memvar aTotIva
memvar aIvaUno
memvar aIvaDos
memvar aIvaTre
memvar nTotBrt
memvar nTotDto
memvar nTotDpp
memvar nTotNet
memvar nTotIva
memvar nTotReq
memvar nTotAlb
memvar nTotImp
memvar aImpVto
memvar aDatVto
memvar cPicUndAlb
memvar cPinDivAlb
memvar cPirDivAlb
memvar nDinDivAlb
memvar nDirDivAlb
memvar nVdvDivAlb
memvar nPagina
memvar lEnd

static oWndBrw
static oInf
static oGetTot
static dbfPrv
static dbfIva
static dbfTmp
static dbfInci
static dbfTmpInc
static dbfTmpDoc
static dbfTmpSer
static dbfAlbPrvT
static dbfAlbPrvL
static dbfAlbPrvS
static tmpAlbPrvL
static tmpAlbPrvS
static filAlbPrvL
static dbfAlbPrvI
static dbfAlbPrvD
static dbfFPago
static dbfArtCom
static dbfUbicaL
static dbfDiv
static dbfCajT
static oBandera
static dbfArticulo
static dbfCodebar
static dbfFamilia
static dbfArtPrv
static dbfKit
static dbfDoc
static dbfTblCnv
static dbfPedPrvT
static dbfPedPrvL
static dbfPedCliT
static dbfPedCliL
static dbfPro
static dbfFlt
static dbfTblPro
static dbfDelega
static dbfAlm
static dbfUsr
static dbfCount
static dbfEmp
static dbfFacPrvL
static dbfFacPrvS
static dbfRctPrvL
static dbfRctPrvS
static dbfAlbCliL
static dbfAlbCliS
static dbfFacCliL
static dbfFacCliS
static dbfFacRecL
static dbfFacRecS
static dbfTikCliL
static dbfTikCliS
static dbfProLin
static dbfProSer
static dbfProMat
static dbfHisMov
static cNewFile
static cTmpInc
static cTmpDoc
static cTmpSer
static cPinDiv
static cPirDiv
static cPicUnd
static nDinDiv
static nDirDiv
static oGetNet
static oGetIva
static oGetReq
static oUsr
static cUsr
static nOldEst
static oBrwIva
static oStock
static oFont
static oMenu
static nNumAlb
static aNumAlb          := {}
static nGetNeto         := 0
static nGetIva          := 0
static nGetReq          := 0
static nLabels          := 1
static aAlbaranes       := {}

static cOldCodCli       := ""
static cOldCodArt       := ""
static cOldPrpArt       := ""
static cOldUndMed       := ""

static lOpenFiles       := .f.
static lExternal        := .f.

static bEdtRec          := { |aTmp, aGet, dbfAlbPrvT, oBrw, bWhen, bValid, nMode, cCodPed | EdtRec( aTmp, aGet, dbfAlbPrvT, oBrw, bWhen, bValid, nMode, cCodPed ) }
static bEdtDet          := { |aTmp, aGet, dbfAlbPrvT, oBrw, bWhen, bValid, nMode, aAlbPrv | EdtDet( aTmp, aGet, dbfAlbPrvT, oBrw, bWhen, bValid, nMode ) }
static bEdtInc          := { |aTmp, aGet, dbfAlbPrvI, oBrw, bWhen, bValid, nMode, aTmpLin | EdtInc( aTmp, aGet, dbfAlbPrvI, oBrw, bWhen, bValid, nMode, aTmpLin ) }
static bEdtDoc          := { |aTmp, aGet, dbfAlbPrvD, oBrw, bWhen, bValid, nMode, aTmpLin | EdtDoc( aTmp, aGet, dbfAlbPrvD, oBrw, bWhen, bValid, nMode, aTmpLin ) }

static oUndMedicion
static cFiltroUsuario   := ""
static cInforme

static oNumerosSerie
static oBtnNumerosSerie

//----------------------------------------------------------------------------//

STATIC FUNCTION OpenFiles( lExt )

   local oBlock

   if lOpenFiles
      MsgStop( 'Ficheros de albaranes de proveedores ya abiertos' )
      Return ( .f. )
   end if

   DEFAULT lExt         := .f.

   lExternal            := lExt

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      DisableAcceso()

      lOpenFiles        := .t.

      USE ( cPatEmp() + "ALBPROVT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALBPROVT", @dbfAlbPrvT ) )
      SET ADSINDEX TO ( cPatEmp() + "ALBPROVT.CDX" ) ADDITIVE

      USE ( cPatEmp() + "ALBPROVL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALBPROVL", @dbfAlbPrvL ) )
      SET ADSINDEX TO ( cPatEmp() + "ALBPROVL.CDX" ) ADDITIVE

      USE ( cPatEmp() + "ALBPRVI.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALBPRVI", @dbfAlbPrvI ) )
      SET ADSINDEX TO ( cPatEmp() + "ALBPRVI.CDX" ) ADDITIVE

      USE ( cPatEmp() + "ALBPRVD.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALBPRVD", @dbfAlbPrvD ) )
      SET ADSINDEX TO ( cPatEmp() + "ALBPRVD.CDX" ) ADDITIVE

      USE ( cPatEmp() + "AlbPrvS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "AlbPrvS", @dbfAlbPrvS ) )
      SET ADSINDEX TO ( cPatEmp() + "AlbPrvS.CDX" ) ADDITIVE

      USE ( cPatPrv() + "PROVEE.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PROVEE", @dbfPrv ) )
      SET ADSINDEX TO ( cPatPrv() + "PROVEE.CDX" ) ADDITIVE

      USE ( cPatArt() + "PROVART.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PROVART", @dbfArtPrv ) )
      SET ADSINDEX TO ( cPatArt() + "PROVART.CDX" ) ADDITIVE
      SET TAG TO "cCodPrv"

      USE ( cPatDat() + "TIVA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIVA", @dbfIva ) )
      SET ADSINDEX TO ( cPatDat() + "TIVA.CDX" ) ADDITIVE

      USE ( cPatArt() + "ARTICULO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ARTICULO", @dbfArticulo ) )
      SET ADSINDEX TO ( cPatArt() + "ARTICULO.CDX" ) ADDITIVE

      USE ( cPatArt() + "ArtCodebar.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CODEBAR", @dbfCodebar ) )
      SET ADSINDEX TO ( cPatArt() + "ArtCodebar.Cdx" ) ADDITIVE

      USE ( cPatArt() + "FAMILIAS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FAMILIAS", @dbfFamilia ) )
      SET ADSINDEX TO ( cPatArt() + "FAMILIAS.CDX" ) ADDITIVE

      USE ( cPatAlm() + "ALMACEN.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALMACEN", @dbfAlm ) )
      SET ADSINDEX TO ( cPatAlm() + "ALMACEN.CDX" ) ADDITIVE

      USE ( cPatArt() + "ARTKIT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ARTTIK", @dbfKit ) )
      SET ADSINDEX TO ( cPatArt() + "ARTKIT.CDX" ) ADDITIVE

      USE ( cPatArt() + "ArtDiv.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ARTCOM", @dbfArtCom ) )
      SET ADSINDEX TO ( cPatArt() + "ArtDiv.Cdx" ) ADDITIVE

      USE ( cPatDat() + "DIVISAS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "DIVISAS", @dbfDiv ) )
      SET ADSINDEX TO ( cPatDat() + "DIVISAS.CDX" ) ADDITIVE

      USE ( cPatDat() + "TBLCNV.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TBLCNV", @dbfTblCnv ) )
      SET ADSINDEX TO ( cPatDat() + "TBLCNV.CDX" ) ADDITIVE

      USE ( cPatEmp() + "RDOCUMEN.DBF" ) NEW SHARED VIA ( cDriver() )ALIAS ( cCheckArea( "RDOCUMEN", @dbfDoc ) )
      SET ADSINDEX TO ( cPatEmp() + "RDOCUMEN.CDX" ) ADDITIVE
      SET TAG TO "CTIPO"

      USE ( cPatEmp() + "PEDPROVT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PEDPROVT", @dbfPedPrvT ) )
      SET ADSINDEX TO ( cPatEmp() + "PEDPROVT.CDX" ) ADDITIVE

      USE ( cPatEmp() + "PEDPROVL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PEDPROVL", @dbfPedPrvL ) )
      SET ADSINDEX TO ( cPatEmp() + "PEDPROVL.CDX" ) ADDITIVE

      USE ( cPatEmp() + "PEDCLIT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PEDCLIT", @dbfPedCliT ) )
      SET ADSINDEX TO ( cPatEmp() + "PEDCLIT.CDX" ) ADDITIVE

      USE ( cPatEmp() + "PEDCLIL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PEDCLIL", @dbfPedCliL ) )
      SET ADSINDEX TO ( cPatEmp() + "PEDCLIL.CDX" ) ADDITIVE

      USE ( cPatGrp() + "FPAGO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FPAGO", @dbfFPago ) )
      SET ADSINDEX TO ( cPatGrp() + "FPAGO.CDX" ) ADDITIVE

      USE ( cPatDat() + "Cajas.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CAJAS", @dbfCajT ) )
      SET ADSINDEX TO ( cPatDat() + "Cajas.Cdx" ) ADDITIVE

      USE ( cPatAlm() + "UBICAL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "UBICAL", @dbfUbicaL ) )
      SET ADSINDEX TO ( cPatAlm() + "UBICAL.CDX" ) ADDITIVE

      USE ( cPatDat() + "USERS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "USERS", @dbfUsr ) )
      SET ADSINDEX TO ( cPatDat() + "USERS.CDX" ) ADDITIVE

      USE ( cPatEmp() + "TIPINCI.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIPINCI", @dbfInci ) )
      SET ADSINDEX TO ( cPatEmp() + "TIPINCI.CDX" ) ADDITIVE

      USE ( cPatArt() + "PRO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PRO", @dbfPro ) )
      SET ADSINDEX TO ( cPatArt() + "PRO.CDX" ) ADDITIVE

      USE ( cPatArt() + "TBLPRO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TBLPRO", @dbfTblPro ) )
      SET ADSINDEX TO ( cPatArt() + "TBLPRO.CDX" ) ADDITIVE

      USE ( cPatDat() + "DELEGA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "DELEGA", @dbfDelega ) )
      SET ADSINDEX TO ( cPatDat() + "DELEGA.CDX" ) ADDITIVE

      USE ( cPatEmp() + "NCOUNT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "NCOUNT", @dbfCount ) )
      SET ADSINDEX TO ( cPatEmp() + "NCOUNT.CDX" ) ADDITIVE

      USE ( cPatDat() + "CNFFLT.DBF" ) NEW SHARED VIA ( cDriver() )ALIAS ( cCheckArea( "CNFFLT", @dbfFlt ) )
      SET ADSINDEX TO ( cPatDat() + "CNFFLT.CDX" ) ADDITIVE

      USE ( cPatDat() + "EMPRESA.DBF" ) NEW SHARED VIA ( cDriver() )ALIAS ( cCheckArea( "EMPRESA", @dbfEmp ) )
      SET ADSINDEX TO ( cPatDat() + "EMPRESA.CDX" ) ADDITIVE

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

      USE ( cPatEmp() + "ALBCLIL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALBCLIL", @dbfAlbCliL ) )
      SET ADSINDEX TO ( cPatEmp() + "ALBCLIL.CDX" ) ADDITIVE
      SET TAG TO "cStkFast"

      USE ( cPatEmp() + "ALBCLIS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALBCLIS", @dbfAlbCliS ) )
      SET ADSINDEX TO ( cPatEmp() + "ALBCLIS.CDX" ) ADDITIVE

      USE ( cPatEmp() + "FACCLIL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACCLIL", @dbfFacCliL ) )
      SET ADSINDEX TO ( cPatEmp() + "FACCLIL.CDX" ) ADDITIVE
      SET TAG TO "cRef"

      USE ( cPatEmp() + "FACCLIS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACCLIS", @dbfFacCliS ) )
      SET ADSINDEX TO ( cPatEmp() + "FACCLIS.CDX" ) ADDITIVE

      USE ( cPatEmp() + "FacRecL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FacRecL", @dbfFacRecL ) )
      SET ADSINDEX TO ( cPatEmp() + "FacRecL.CDX" ) ADDITIVE
      SET TAG TO "cRef"

      USE ( cPatEmp() + "FacRecS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FacRecS", @dbfFacRecS ) )
      SET ADSINDEX TO ( cPatEmp() + "FacRecS.CDX" ) ADDITIVE

      USE ( cPatEmp() + "TIKEL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIKEL", @dbfTikCliL ) )
      SET ADSINDEX TO ( cPatEmp() + "TIKEL.CDX" ) ADDITIVE
      SET TAG TO "CSTKFAST"

      USE ( cPatEmp() + "TIKES.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIKES", @dbfTikCliS ) )
      SET ADSINDEX TO ( cPatEmp() + "TIKES.CDX" ) ADDITIVE

      USE ( cPatEmp() + "PROLIN.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PROLIN", @dbfProLin ) )
      SET ADSINDEX TO ( cPatEmp() + "PROLIN.CDX" ) ADDITIVE
      SET TAG TO "cCodArt"

      USE ( cPatEmp() + "PROSER.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PROSER", @dbfProSer ) )
      SET ADSINDEX TO ( cPatEmp() + "PROSER.CDX" ) ADDITIVE

      USE ( cPatEmp() + "PROMAT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PROMAT", @dbfProMat ) )
      SET ADSINDEX TO ( cPatEmp() + "PROMAT.CDX" ) ADDITIVE
      SET TAG TO "cCodArt"

      USE ( cPatEmp() + "HISMOV.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "HISMOV", @dbfHisMov ) )
      SET ADSINDEX TO ( cPatEmp() + "HISMOV.CDX" ) ADDITIVE
      SET TAG TO "cRefMov"

      // Unidades de medicion--------------------------------------------------

      oUndMedicion      := UniMedicion():Create( cPatGrp() )
      if !oUndMedicion:OpenFiles()
         lOpenFiles     := .f.
      end if

      // ----------------------------------------------------------------------

      oBandera             := TBandera():New()

      oStock               := TStock():Create( cPatGrp() )
      if !oStock:lOpenFiles()
         lOpenFiles        := .f.
      end if

      cPicUnd              := MasUnd()                               // Picture de las unidades

      /*
      Declaración de variables públicas----------------------------------------
      */

      public nTotAlb       := 0
      public nTotBrt       := 0
      public nTotDto       := 0
      public nTotDPP       := 0
      public nTotNet       := 0
      public nTotIva       := 0
      public nTotReq       := 0
      public nTotImp       := 0
      public aTotIva       := { { 0,0,nil,0,0,0 }, { 0,0,nil,0,0,0 }, { 0,0,nil,0,0,0 } }
      public aIvaUno       := aTotIva[ 1 ]
      public aIvaDos       := aTotIva[ 2 ]
      public aIvaTre       := aTotIva[ 3 ]
      public aImpVto       := {}
      public aDatVto       := {}

      /*
      Limitaciones de cajero y cajas--------------------------------------------------------
      */

      if oUser():lFiltroVentas()
         cFiltroUsuario    := "Field->cCodUsr == '" + oUser():cCodigo() + "' .and. Field->cCodCaj == '" + oUser():cCaja() + "'"
      end if

      /*
      Numeros de serie---------------------------------------------------------
      */

      oNumerosSerie           := TNumerosSerie()
      oNumerosSerie:lCompras  := .t.
      oNumerosSerie:oStock    := oStock

      EnableAcceso()

   RECOVER

      lOpenFiles           := .f.

      EnableAcceso()

      MsgStop( 'Imposible abrir ficheros de albaranes de proveedores' )

   END SEQUENCE

   ErrorBlock( oBlock )

   if !lOpenFiles
      CloseFiles()
   end if

RETURN ( lOpenFiles )

//----------------------------------------------------------------------------//

STATIC FUNCTION CloseFiles()

   DisableAcceso()

   DestroyFastFilter( dbfAlbPrvT, .t., .t. )

   if !Empty( oFont )
      oFont:end()
   end if

   if !Empty( dbfAlbPrvT )
      ( dbfAlbPrvT )->( dbCloseArea() )
   end if

   if dbfAlbPrvL != nil
      ( dbfAlbPrvL )->( dbCloseArea() )
   end if

   if dbfAlbPrvI != nil
      ( dbfAlbPrvI )->( dbCloseArea() )
   end if

   if dbfAlbPrvD != nil
      ( dbfAlbPrvD )->( dbCloseArea() )
   end if

   if !Empty( dbfAlbPrvS )
      ( dbfAlbPrvS )->( dbCloseArea() )
   end if

   if dbfPrv != nil
      ( dbfPrv )->( dbCloseArea() )
   end if

   if dbfArtPrv != nil
      ( dbfArtPrv )->( dbCloseArea() )
   end if

   if dbfIva != nil
      ( dbfIva )->( dbCloseArea() )
   end if

   if dbfAlm != nil
      ( dbfAlm )->( dbCloseArea() )
   end if

   if dbfArticulo != nil
      ( dbfArticulo)->( dbCloseArea() )
   end if

   if dbfCodebar != nil
      ( dbfCodebar )->( dbCloseArea() )
   end if

   if dbfFamilia != nil
      ( dbfFamilia )->( dbCloseArea() )
   end if

   if dbfKit != nil
      ( dbfKit )->( dbCloseArea() )
   end if

   if dbfArtCom != nil
      ( dbfArtCom )->( dbCloseArea() )
   end if

   if dbfDiv != nil
      ( dbfDiv )->( dbCloseArea() )
   end if

   if dbfTblCnv != nil
      ( dbfTblCnv )->( dbCloseArea() )
   end if

   if dbfDoc != nil
      ( dbfDoc )->( dbCloseArea() )
   end if

   if dbfPedPrvT != nil
      ( dbfPedPrvT )->( dbCloseArea() )
   end if

   if dbfPedPrvL != nil
      ( dbfPedPrvL )->( dbCloseArea() )
   end if

   if dbfPro != nil
      ( dbfPro )->( dbCloseArea() )
   end if

   if dbfTblPro != nil
      ( dbfTblPro)->( dbCloseArea() )
   end if

   if dbfFPago != nil
      ( dbfFPago )->( dbCloseArea() )
   end if

   if dbfCajT != nil
      ( dbfCajT )->( dbCloseArea() )
   end if

   if dbfUbicaL != nil
      ( dbfUbicaL )->( dbCloseArea() )
   end if

   if dbfUsr != nil
      ( dbfUsr )->( dbCloseArea() )
   end if

   if dbfInci != nil
      ( dbfInci )->( dbCloseArea() )
   end if

   if dbfDelega != nil
      ( dbfDelega )->( dbCloseArea() )
   end if

   if dbfCount != nil
      ( dbfCount )->( dbCloseArea() )
   end if

   if dbfFlt != nil
      ( dbfFlt )->( dbCloseArea() )
   end if

   if dbfPedCliT != nil
      ( dbfPedCliT )->( dbCloseArea() )
   end if

   if dbfPedCliL != nil
      ( dbfPedCliL )->( dbCloseArea() )
   end if

   if dbfEmp != nil
      ( dbfEmp )->( dbCloseArea() )
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

   if dbfAlbCliL != nil
      ( dbfAlbCliL )->( dbCloseArea() )
   end if

   if dbfAlbCliS != nil
      ( dbfAlbCliS )->( dbCloseArea() )
   end if

   if dbfFacCliL != nil
      ( dbfFacCliL )->( dbCloseArea() )
   end if

   if dbfFacCliS != nil
      ( dbfFacCliS )->( dbCloseArea() )
   end if

   if dbfFacRecL != nil
      ( dbfFacRecL )->( dbCloseArea() )
   end if

   if dbfFacRecS != nil
      ( dbfFacRecS )->( dbCloseArea() )
   end if

   if dbfTikCliL != nil
      ( dbfTikCliL )->( dbCloseArea() )
   end if

   if dbfTikCliS != nil
      ( dbfTikCliS )->( dbCloseArea() )
   end if

   if dbfProLin != nil
      ( dbfProLin )->( dbCloseArea() )
   end if

   if dbfProSer != nil
      ( dbfProSer )->( dbCloseArea() )
   end if

   if dbfProMat != nil
      ( dbfProMat )->( dbCloseArea() )
   end if

   if dbfHisMov != nil
      ( dbfHisMov )->( dbCloseArea() )
   end if

   if oStock != nil
      oStock:end()
   end if

   if !Empty( oUndMedicion )
      oUndMedicion:end()
   end if

   dbfUbicaL   := nil
   dbfPrv      := nil
   dbfAlbPrvT  := nil
   dbfAlbPrvL  := nil
   dbfAlbPrvI  := nil
   dbfAlbPrvD  := nil
   dbfAlbPrvS  := nil
   dbfArtPrv   := nil
   dbfIva      := nil
   dbfArticulo := nil
   dbfCodebar  := nil
   dbfFamilia  := nil
   dbfKit      := nil
   dbfArtCom   := nil
   dbfDiv      := nil
   dbfTblCnv   := nil
   dbfDoc      := nil
   dbfPro      := nil
   dbfTblPro   := nil
   dbfAlm      := nil
   dbfFPago    := nil
   dbfCajT     := nil
   dbfUsr      := nil
   dbfInci     := nil
   dbfDelega   := nil
   dbfFlt      := nil
   dbfCount    := nil
   dbfPedCliT  := nil
   dbfPedCliL  := nil
   dbfEmp      := nil
   dbfFacPrvL  := nil
   dbfFacPrvS  := nil
   dbfRctPrvL  := nil
   dbfRctPrvS  := nil

   dbfAlbCliL  := nil
   dbfAlbCliS  := nil

   dbfFacCliL  := nil
   dbfFacCliS  := nil

   dbfFacRecL  := nil
   dbfFacRecS  := nil

   dbfTikCliL  := nil
   dbfTikCliS  := nil

   dbfProLin   := nil
   dbfProSer   := nil

   dbfProMat   := nil

   dbfHisMov   := nil

   oBandera    := nil
   oStock      := nil

   lOpenFiles  := .f.

   oWndBrw     := nil

   EnableAcceso()

RETURN .T.

//----------------------------------------------------------------------------//

FUNCTION AlbPrv( oMenuItem, oWnd, cCodPrv, cCodArt, cCodPed )

   local oSnd
   local oRpl
   local oPrv
   local oImp
   local oDel
   local oPdf
   local oMail
   local oRotor
   local nLevel
   local oBtnEur
   local lEuro          := .f.

   DEFAULT oMenuItem    := _MENUITEM_
   DEFAULT oWnd         := oWnd()
   DEFAULT cCodPrv      := ""
   DEFAULT cCodArt      := ""
   DEFAULT cCodPed      := ""

   /*
   Obtenemos el nivel de acceso
   */

   nLevel            := nLevelUsr( oMenuItem )
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
   Anotamos el movimiento para el navegador
   */

   DisableAcceso()

   DEFINE SHELL oWndBrw FROM 0, 0 TO 22, 80 ;
      XBROWSE ;
      TITLE    "Albaranes de proveedores" ;
      PROMPT   "Número",;
               "Fecha",;
               "Código",;
               "Nombre proveedor",;
               "Su albarán";
      MRU      "Document_plain_businessman_16";
      BITMAP   Rgb( 0, 114, 198 ) ;
      ALIAS    ( dbfAlbPrvT );
      APPEND   ( WinAppRec( oWndBrw:oBrw, bEdtRec, dbfAlbPrvT, cCodPrv, cCodArt, cCodPed ) );
      DUPLICAT ( WinDupRec( oWndBrw:oBrw, bEdtRec, dbfAlbPrvT, cCodPrv, cCodArt, cCodPed ) );
      EDIT     ( WinEdtRec( oWndBrw:oBrw, bEdtRec, dbfAlbPrvT, cCodPrv, cCodArt, cCodPed ) );
      ZOOM     ( WinZooRec( oWndBrw:oBrw, bEdtRec, dbfAlbPrvT ) );
      DELETE   ( WinDelRec( oWndBrw:oBrw, dbfAlbPrvT, {|| QuiAlbPrv() } ) );
      LEVEL    nLevel ;
      OF       oWnd

	  oWndBrw:lFechado     := .t.

	  oWndBrw:bChgIndex    := {|| if( oUser():lFiltroVentas(), CreateFastFilter( cFiltroUsuario, dbfAlbPrvT, .f., , cFiltroUsuario ), CreateFastFilter( "", dbfAlbPrvT, .f. ) ) }

	  oWndBrw:SetYearComboBoxChange( {|| YearComboBoxChange() } )

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Sesión cerrada"
         :nHeadBmpNo       := 3
         :bStrData         := {|| "" }
         :bEditValue       := {|| ( dbfAlbPrvT )->lCloAlb }
         :nWidth           := 20
         :lHide            := .t.
         :SetCheck( { "Sel16", "Nil16" } )
         :AddResource( "Zoom16" )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Envio"
         :nHeadBmpNo       := 3
         :bStrData         := {|| "" }
         :bEditValue       := {|| ( dbfAlbPrvT )->lSndDoc }
         :nWidth           := 20
         :SetCheck( { "Sel16", "Nil16" } )
         :AddResource( "Lbl16" )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Facturado"
         :nHeadBmpNo       := 3
         :bStrData         := {|| "" }
         :bEditValue       := {|| ( dbfAlbPrvT )->lFacturado }
         :nWidth           := 20
         :SetCheck( { "Bullet_Square_Green_16", "Bullet_Square_Red_16" } )
         :AddResource( "Trafficlight_on_16" )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Incidencia"
         :nHeadBmpNo       := 4
         :bStrData         := {|| "" }
         :bBmpData         := {|| nEstadoIncidencia( ( dbfAlbPrvT )->cSerAlb + Str( ( dbfAlbPrvT )->nNumAlb ) + ( dbfAlbPrvT )->cSufAlb ) }
         :nWidth           := 20
         :lHide            := .t.
         :AddResource( "Bullet_Square_Red_16" )
         :AddResource( "Bullet_Square_Yellow_16" )
         :AddResource( "Bullet_Square_Green_16" )
         :AddResource( "Informacion_16" )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Impreso"
         :nHeadBmpNo       := 3
         :bStrData         := {|| "" }
         :bEditValue       := {|| ( dbfAlbPrvT )->lImprimido }
         :nWidth           := 20
         :lHide            := .t.
         :SetCheck( { "Sel16", "Nil16" } )
         :AddResource( "IMP16" )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Número"
         :cSortOrder       := "nNumAlb"
         :bEditValue       := {|| ( dbfAlbPrvT )->cSerAlb + "/" + Alltrim( Str( ( dbfAlbPrvT )->nNumAlb ) ) + "/" + ( dbfAlbPrvT )->cSufAlb }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Su albarán"
         :cSortOrder       := "cSuAlb"
         :bEditValue       := {|| ( dbfAlbPrvT )->cSuAlb }
         :nWidth           := 60
         :lHide            := .t.
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Delegación"
         :bEditValue       := {|| ( dbfAlbPrvT )->cCodDlg }
         :nWidth           := 60
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Sesión"
         :bEditValue       := {|| Trans( ( dbfAlbPrvT )->cTurAlb, "######" ) }
         :nWidth           := 60
         :lHide            := .t.
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Fecha"
         :cSortOrder       := "dFecAlb"
         :bEditValue       := {|| Dtoc( ( dbfAlbPrvT )->dFecAlb ) }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Caja"
         :bEditValue       := {|| ( dbfAlbPrvT )->cCodCaj }
         :nWidth           := 40
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Usuario"
         :bEditValue       := {|| ( dbfAlbPrvT )->cCodUsr }
         :nWidth           := 40
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Entrada"
         :cSortOrder       := "dFecEnt"
         :bEditValue       := {|| Dtoc( ( dbfAlbPrvT )->dFecEnt ) }
         :nWidth           := 80
         :lHide            := .t.
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Código"
         :cSortOrder       := "cCodPrv"
         :bEditValue       := {|| ( dbfAlbPrvT )->cCodPrv }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Nombre proveedor"
         :cSortOrder       := "cNomPrv"
         :bEditValue       := {|| ( dbfAlbPrvT )->cNomPrv }
         :nWidth           := 180
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Base"
         :bEditValue       := {|| ( dbfAlbPrvT )->nTotNet }
         :cEditPicture     := cPirDiv( ( dbfAlbPrvT )->cDivAlb, dbfDiv )
         :nWidth           := 80
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := cImp()
         :bEditValue       := {|| ( dbfAlbPrvT )->nTotIva }
         :cEditPicture     := cPirDiv( ( dbfAlbPrvT )->cDivAlb, dbfDiv )
         :nWidth           := 80
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "R.E."
         :bEditValue       := {|| ( dbfAlbPrvT )->nTotReq }
         :cEditPicture     := cPirDiv( ( dbfAlbPrvT )->cDivAlb, dbfDiv )
         :nWidth           := 80
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Total"
         :bEditValue       := {|| ( dbfAlbPrvT )->nTotAlb }
         :cEditPicture     := cPirDiv( ( dbfAlbPrvT )->cDivAlb, dbfDiv )
         :nWidth           := 80
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Div."
         :bEditValue       := {|| cSimDiv( if( lEuro, cDivChg(), ( dbfAlbPrvT )->cDivAlb ), dbfDiv ) }
         :nWidth           := 30
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Total unidades"
         :bEditValue       := {|| nTotalUnd( ( dbfAlbPrvT )->cSerAlb + Str( ( dbfAlbPrvT )->nNumAlb ) + ( dbfAlbPrvT )->cSufAlb, dbfAlbPrvL, cPicUnd ) }
         :nWidth           := 80
         :lHide            := .t.
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      oWndBrw:cHtmlHelp    := "Albaran de proveedor"

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
      BEGIN GROUP;
      HOTKEY   "A";
      LEVEL    ACC_APPD

   DEFINE BTNSHELL RESOURCE "DUP" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( oWndBrw:RecDup() );
      TOOLTIP  "(D)uplicar";
      MRU ;
      HOTKEY   "D";
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
      LEVEL    ACC_EDIT

   DEFINE BTNSHELL oDel RESOURCE "Del" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( oWndBrw:RecDel() );
      MENU     This:Toggle() ;
      TOOLTIP  "(E)liminar";
      HOTKEY   "E";
      LEVEL    ACC_DELE

   DEFINE BTNSHELL oPrv RESOURCE "Imp" GROUP OF oWndBrw ;
      NOBORDER ;
      ACTION   ( GenAlbPrv( IS_PRINTER ), oWndBrw:Refresh() ) ;
      MENU     This:Toggle() ;
      TOOLTIP  "(I)mprimir";
      HOTKEY   "I";
      LEVEL    ACC_IMPR

      if !Empty( oPrv )
         lGenAlb( oWndBrw:oBrw, oPrv, IS_PRINTER )
      end if

   DEFINE BTNSHELL RESOURCE "Serie1" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( PrnSerie( oWndBrw ), oWndBrw:Refresh() ) ;
      TOOLTIP  "Imp(r)imir series";
      HOTKEY   "R";
      LEVEL    ACC_IMPR

   DEFINE BTNSHELL oImp RESOURCE "Prev1" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( GenAlbPrv( IS_SCREEN ), oWndBrw:Refresh() ) ;
      MENU     This:Toggle() ;
      TOOLTIP  "(P)revisualizar";
      HOTKEY   "P";
      LEVEL    ACC_IMPR

      if !Empty( oImp )
         lGenAlb( oWndBrw:oBrw, oImp, IS_SCREEN )
      end if

   DEFINE BTNSHELL oPdf RESOURCE "DocLock" OF oWndBrw ;
      NOBORDER ;
      MENU     This:Toggle() ;
      ACTION   ( GenAlbPrv( IS_PDF ) ) ;
      TOOLTIP  "Pd(f)";
      HOTKEY   "F";
      LEVEL    ACC_IMPR

      if !Empty( oPdf )
         lGenAlb( oWndBrw:oBrw, oPdf, IS_PDF )
      end if

   DEFINE BTNSHELL oMail RESOURCE "Mail" OF oWndBrw ;
      NOBORDER ;
      MENU     This:Toggle() ;
      ACTION   ( GenAlbPrv( IS_MAIL ) ) ;
      TOOLTIP  "Correo electrónico";
      LEVEL    ACC_IMPR

      lGenAlb( oWndBrw:oBrw, oMail, IS_MAIL ) ;

   DEFINE BTNSHELL RESOURCE "RemoteControl_" OF oWndBrw ;
			NOBORDER ;
         ACTION   ( TAlbaranProveedoresLabelGenerator():Create() ) ;
         TOOLTIP  "Eti(q)uetas" ;
         HOTKEY   "Q";
         LEVEL    ACC_IMPR

   if oUser():lAdministrador()

      DEFINE BTNSHELL RESOURCE "ChgState" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( SetFacturadoAlbaranProveedor( !( dbfAlbPrvT )->lFacturado, oStock, oWndBrw:oBrw ) );
         TOOLTIP  "Cambiar es(t)ado" ;
         HOTKEY   "T";
         LEVEL    ACC_EDIT

   end if

   DEFINE BTNSHELL oSnd RESOURCE "Lbl" GROUP OF oWndBrw ;
      NOBORDER ;
      MENU     This:Toggle() ;
      TOOLTIP  "En(v)iar" ;
      MESSAGE  "Seleccionar albaranes para ser enviados" ;
      ACTION   lSnd( oWndBrw, dbfAlbPrvT ) ;
      HOTKEY   "V";
      LEVEL    ACC_EDIT

   DEFINE BTNSHELL oBtnEur RESOURCE "BAL_EURO" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( lEuro := !lEuro, oWndBrw:Refresh() ) ;
      TOOLTIP  "M(o)neda";
      HOTKEY   "O";

   if oUser():lAdministrador()

      //Condicionamos para que sólo el administrador toque los campos

      DEFINE BTNSHELL oRpl RESOURCE "BMPCHG" GROUP OF oWndBrw ;
         NOBORDER ;
         MENU     This:Toggle() ;
         ACTION   ( TDlgFlt():New( aItmAlbPrv(), dbfAlbPrvT ):ChgFields(), oWndBrw:Refresh() ) ;
         TOOLTIP  "Cambiar campos" ;
         LEVEL    ACC_EDIT

         DEFINE BTNSHELL RESOURCE "BMPCHG" OF oWndBrw ;
            NOBORDER ;
            ACTION   ( TDlgFlt():New( aColAlbPrv(), dbfAlbPrvL ):ChgFields(), oWndBrw:Refresh() ) ;
            TOOLTIP  "Lineas" ;
            FROM     oRpl ;
            CLOSED ;
            LEVEL    ACC_EDIT

   end if

   DEFINE BTNSHELL RESOURCE "INFO" GROUP OF oWndBrw ;
      NOBORDER ;
      ACTION   ( TTrazaDocumento():Activate( ALB_PRV, ( dbfAlbPrvT )->cSerAlb + Str( ( dbfAlbPrvT )->nNumAlb ) + ( dbfAlbPrvT )->cSufAlb ) ) ;
      TOOLTIP  "I(n)forme documento" ;
      HOTKEY   "N" ;
      LEVEL    ACC_EDIT

   DEFINE BTNSHELL oRotor RESOURCE "ROTOR" GROUP OF oWndBrw ;
      NOBORDER ;
      ACTION   ( oRotor:Expand() ) ;
      TOOLTIP  "Rotor" ;
      LEVEL    ACC_EDIT

      DEFINE BTNSHELL RESOURCE "BUSINESSMAN_" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( EdtPrv( ( dbfAlbPrvT )->cCodPrv ) );
         TOOLTIP  "Modificar proveedor" ;
         FROM     oRotor ;
         LEVEL    ACC_EDIT

      DEFINE BTNSHELL RESOURCE "INFO" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( InfProveedor( ( dbfAlbPrvT )->cCodPrv ) );
         TOOLTIP  "Informe proveedor" ;
         FROM     oRotor ;
         LEVEL    ACC_EDIT

      DEFINE BTNSHELL RESOURCE "CLIPBOARD_EMPTY_BUSINESSMAN_" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( if( !Empty( ( dbfAlbPrvT )->cNumPed ), ZooPedPrv( ( dbfAlbPrvT )->cNumPed ), msgStop( "No hay pedido asociado" ) ) );
         TOOLTIP  "Visualizar pedido" ;
         FROM     oRotor ;
         LEVEL    ACC_EDIT

      DEFINE BTNSHELL RESOURCE "DOCUMENT_BUSINESSMAN_" OF oWndBrw ;
         ALLOW    EXIT ;
         ACTION   ( if( ( dbfAlbPrvT )->lFacturado, MsgStop( "Albarán facturado" ), FacPrv( nil, oWnd, nil, nil, ( dbfAlbPrvT )->cSerAlb + Str( ( dbfAlbPrvT )->nNumAlb ) + ( dbfAlbPrvT )->cSufAlb ) ) );
         TOOLTIP  "Generar factura" ;
         FROM     oRotor ;
         LEVEL    ACC_EDIT

      DEFINE BTNSHELL RESOURCE "DOCUMENT_BUSINESSMAN_" OF oWndBrw ;
         ACTION   ( if( !Empty( ( dbfAlbPrvT )->cNumFac ), EdtFacPrv( ( dbfAlbPrvT )->cNumFac ), msgStop( "No hay factura asociada" ) ) );
         TOOLTIP  "Modificar factura" ;
         FROM     oRotor ;
         LEVEL    ACC_EDIT

   if ( "ICG" $ cParamsMain() )

   DEFINE BTNSHELL RESOURCE "Document_plain_user1_" GROUP OF oWndBrw;
      NOBORDER ;
      ACTION   ( IcgMotor() ) ;
      TOOLTIP  "ICG" ;

   end if

   DEFINE BTNSHELL RESOURCE "END" GROUP OF oWndBrw ;
      ALLOW    EXIT ;
      ACTION   ( oWndBrw:End() ) ;
      TOOLTIP  "(S)alir";
      HOTKEY   "S"

   if !oUser():lFiltroVentas()
      oWndBrw:oActiveFilter:aTField       := aItmAlbPrv()
      oWndBrw:oActiveFilter:cDbfFilter    := dbfFlt
      oWndBrw:oActiveFilter:cTipFilter    := ALB_PRV
   end if

   ACTIVATE WINDOW oWndBrw VALID ( CloseFiles() )

   EnableAcceso()

   if !Empty( cCodPrv ) .or. !Empty( cCodArt ) .or. !Empty( cCodPed )

      if !Empty( oWndBrw )
         oWndBrw:RecAdd()
      end if

      cCodPrv  := nil
      cCodArt  := nil
      cCodPed  := nil

   end if

RETURN .t.

//----------------------------------------------------------------------------//

STATIC FUNCTION EdtRec( aTmp, aGet, dbfAlbPrvT, oBrw, cCodPrv, cCodArt, nMode, cCodPed )

   local nOrd
   local oDlg
   local oFld
   local oBrwLin
   local oBrwInc
   local oBrwDoc
   local oBmpDiv
   local oSay           := Array( 6 )
   local cSay           := Array( 6 )
   local oSayLabels     := Array( 7 )
   local oGetMasDiv
   local cGetMasDiv     := ""
   local oBmpEmp
   local cEstado        := if( aTmp[ _LFACTURADO ], "Facturado", "No facturado" )
   local cTlfPrv
   local oTlfPrv
   local oBmpGeneral

   cTlfPrv              := RetFld( aTmp[ _CCODPRV ], dbfPrv, "Telefono" )

	DO CASE
   CASE nMode == APPD_MODE

      if !lCajaOpen( oUser():cCaja() ) .and. !oUser():lAdministrador()
         msgStop( "Esta caja " + oUser():cCaja() + " esta cerrada." )
         Return .f.
      end if

      aTmp[ _CSERALB ]     := cNewSer( "NALBPRV", dbfCount )
      aTmp[ _CTURALB ]     := cCurSesion()
      aTmp[ _CCODALM ]     := oUser():cAlmacen()
      aTmp[ _CCODCAJ ]     := oUser():cCaja()
      aTmp[ _CDIVALB ]     := cDivEmp()
      aTmp[ _NVDVALB ]     := nChgDiv( aTmp[ _CDIVALB ], dbfDiv )
      aTmp[ _CSUFALB ]     := RetSufEmp()
      aTmp[ _LSNDDOC ]     := .t.
      aTmp[ _CCODUSR ]     := cCurUsr()
      aTmp[ _CCODDLG ]     := oUser():cDelegacion()
      aTmp[ _DFECIMP ]     := Ctod( "" )
      aTmp[ _DSUALB  ]     := Ctod( "" )

      if !Empty( cCodPrv )
         aTmp[ _CCODPRV ]  := cCodPrv
      end if

      if !Empty( cCodPed )
         aTmp[ _CNUMPED ]  := cCodPed
      end if

   CASE nMode == DUPL_MODE

      if !lCajaOpen( oUser():cCaja() ) .and. !oUser():lAdministrador()
         msgStop( "Esta caja " + oUser():cCaja() + " esta cerrada." )
         Return .f.
      end if

      aTmp[ _CTURALB ]     := cCurSesion()
      aTmp[ _CCODCAJ ]     := oUser():cCaja()
      aTmp[ _LSNDDOC ]     := .t.
      aTmp[ _DFECIMP ]     := Ctod( "" )
      aTmp[ _LCLOALB ]     := .f.

   CASE nMode == EDIT_MODE

      if aTmp[ _LFACTURADO ]
         msgStop( "Albarán ya fue facturado." )
         Return .t.
      end if

      if aTmp[ _LCLOALB ] .AND. !oUser():lAdministrador()
         msgStop( "Solo puede modificar los albaranes cerrados los administradores." )
         Return .f.
      end if

   END CASE

   if Empty( aTmp[ _CDTOESP ] )
      aTmp[ _CDTOESP ]  := Padr( "General", 50 )
   end if

   if Empty( aTmp[ _CDPP ] )
      aTmp[ _CDPP ]     := Padr( "Pronto pago", 50 )
   end if

   if BeginTrans( aTmp )
      Return .f.
   end if

   /*
   Este valor los guaradamos para detectar los posibles cambios
   */

   cOldCodCli           := aTmp[ _CCODPRV ]

   /*
   Necestamos el orden el la primera clave
   */

   nOrd                 := ( dbfAlbPrvT )->( ordSetFocus( 1 ) )

   cPicUnd              := MasUnd()                               // Picture de las unidades
   cPinDiv              := cPinDiv( aTmp[ _CDIVALB ], dbfDiv ) // Picture de la divisa
   cPirDiv              := cPirDiv( aTmp[ _CDIVALB ], dbfDiv ) // Picture de la divisa redondeada
   nDinDiv              := nDinDiv( aTmp[ _CDIVALB ], dbfDiv ) // Decimales de la divisa
   nDirDiv              := nRouDiv( aTmp[ _CDIVALB ], dbfDiv ) // Decimales de la divisa redondeada

   oFont                := TFont():New( "Arial", 8, 26, .F., .T. )

   /*
   Etiquetas-------------------------------------------------------------------
   */

   cSay[ 2 ]            := RetFld( aTmp[ _CCODALM ], dbfAlm )
   cSay[ 3 ]            := RetFld( aTmp[ _CCODPGO ], dbfFPago )
   cSay[ 4 ]            := RetFld( aTmp[ _CCODCAJ ], dbfCajT )
   cSay[ 5 ]            := RetFld( aTmp[ _CCODPRV ], dbfPrv )
   cSay[ 6 ]            := RetFld( cCodEmp() + aTmp[ _CCODDLG ], dbfDelega, "cNomDlg" )

   DEFINE DIALOG oDlg RESOURCE "PEDPRV" TITLE LblTitle( nMode ) + "albaranes de proveedores"

      REDEFINE FOLDER oFld ;
         ID       400 ;
         OF       oDlg ;
         PROMPT   "&Albarán",;
                  "Da&tos",;
                  "&Incidencias",;
                  "D&ocumentos";
         DIALOGS  "ALBPRV_1",;
                  "ALBPRV_2",;
                  "PEDCLI_3",;
                  "PEDCLI_4"

      // cuadro del usuario

      REDEFINE BITMAP oBmpGeneral ;
        ID       990 ;
        RESOURCE "albaran_proveedor_48_alpha" ;
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

      REDEFINE GET aGet[ _CCODUSR ] VAR aTmp[ _CCODUSR ];
         ID       220 ;
         WHEN     ( .f. ) ;
         VALID    ( SetUsuario( aGet[ _CCODUSR ], oUsr, nil, dbfUsr ) );
         OF       oFld:aDialogs[2]

      REDEFINE GET oUsr VAR cUsr ;
         ID       221 ;
         WHEN     ( .f. ) ;
         OF       oFld:aDialogs[2]

      cUsr        := RetFld( aTmp[ _CCODUSR ], dbfUsr, "cNbrUse" )

      /*
      Datos del Proveedor______________________________________________________
      */

      REDEFINE GET aGet[_CCODPRV] VAR aTmp[_CCODPRV] ;
			ID 		140 ;
			COLOR 	CLR_GET ;
			PICTURE	( RetPicCodPrvEmp() ) ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         VALID    ( LoaPrv( aGet, aTmp, dbfPrv, nMode, oSay[ 5 ], oTlfPrv ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwProvee( aGet[_CCODPRV], oSay[ 5 ] ) ) ;
			OF 		oFld:aDialogs[1]

      REDEFINE GET aGet[_CNOMPRV] VAR aTmp[ _CNOMPRV ];
			ID 		141 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
			COLOR 	CLR_GET ;
			OF 		oFld:aDialogs[1]

      REDEFINE GET aGet[_CDNIPRV] VAR aTmp[_CDNIPRV] ;
         ID       104 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			COLOR 	CLR_GET ;
         OF       oFld:aDialogs[1]

      REDEFINE GET oTlfPrv VAR cTlfPrv ;
         ID       106 ;
         WHEN     ( .f. ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CDIRPRV ] VAR aTmp[ _CDIRPRV ] ;
         ID       101 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         BITMAP   "Environnment_View_16" ;
         ON HELP  GoogleMaps( aTmp[ _CDIRPRV ], Rtrim( aTmp[ _CPOBPRV ] ) + Space( 1 ) + Rtrim( aTmp[ _CPROPRV ] ) ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CPOSPRV ] VAR aTmp[ _CPOSPRV ] ;
         ID       102 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			COLOR 	CLR_GET ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CPOBPRV ] VAR aTmp[ _CPOBPRV ] ;
         ID       103 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			COLOR 	CLR_GET ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CPROPRV ] VAR aTmp[ _CPROPRV ] ;
         ID       107 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			COLOR 	CLR_GET ;
         OF       oFld:aDialogs[1]

		REDEFINE GET aGet[_CCODPGO] VAR aTmp[_CCODPGO];
			ID 		160 ;
			PICTURE 	"@!" ;
			COLOR 	CLR_GET ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         VALID    cFPago( aGet[_CCODPGO], dbfFPago, oSay[ 3 ] ) ;
         BITMAP   "LUPA" ;
         ON HELP  BrwFPago( aGet[_CCODPGO ], oSay[ 3 ] ) ;
			OF 		oFld:aDialogs[1]

      REDEFINE GET oSay[ 3 ] VAR cSay[ 3 ];
			ID 		161 ;
			WHEN 		.F. ;
			COLOR 	CLR_GET ;
			OF 		oFld:aDialogs[1]

      /*
		Cajas____________________________________________________________________
		*/

      REDEFINE GET aGet[ _CCODCAJ ] VAR aTmp[ _CCODCAJ ];
			WHEN 		( nMode != ZOOM_MODE ) ;
         VALID    cCajas( aGet[ _CCODCAJ ], dbfCajT, oSay[ 4 ] ) ;
         ID       165 ;
			COLOR 	CLR_GET ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwCajas( aGet[ _CCODCAJ ], oSay[ 4 ] ) ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET oSay[ 4 ] VAR cSay[ 4 ] ;
         ID       166 ;
         WHEN     .f. ;
			COLOR 	CLR_GET ;
         OF       oFld:aDialogs[1]

		/*
		Moneda__________________________________________________________________
		*/

		REDEFINE GET aGet[ _CDIVALB ] VAR aTmp[ _CDIVALB ];
         WHEN     ( nMode == APPD_MODE .AND. ( dbfTmp )->( LastRec() ) == 0 ) ;
         VALID    ( cDivIn( aGet[ _CDIVALB ], oBmpDiv, aGet[ _NVDVALB ], @cPinDiv, @nDinDiv, @cPirDiv, @nDirDiv, oGetMasDiv, dbfDiv, oBandera ) );
			PICTURE	"@!";
			ID 		170 ;
			COLOR 	CLR_GET ;
         BITMAP   "LUPA" ;
         ON HELP  BrwDiv( aGet[ _CDIVALB ], oBmpDiv, aGet[ _NVDVALB ], dbfDiv, oBandera ) ;
			OF 		oFld:aDialogs[1]

      REDEFINE BITMAP oBmpDiv ;
         RESOURCE "BAN_EURO" ;
			ID 		171;
			OF 		oFld:aDialogs[1]

		REDEFINE GET aGet[ _NVDVALB ] VAR aTmp[ _NVDVALB ];
			WHEN 		( .F. ) ;
			ID 		180 ;
			PICTURE	"@E 999,999.9999" ;
			COLOR 	CLR_GET ;
			OF 		oFld:aDialogs[1]

      REDEFINE GET aGet[_CCODALM] VAR aTmp[_CCODALM]  ;
			ID 		150 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         VALID    ( cNomUbicaT( aTmp, aGet, dbfAlm ), cAlmacen( aGet[_CCODALM], dbfAlm, oSay[ 2 ] ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwAlmacen( Self, oSay[ 2 ] ) ) ;
			COLOR 	CLR_GET ;
			OF 		oFld:aDialogs[1]

      REDEFINE GET oSay[ 2 ] VAR cSay[ 2 ] ;
			WHEN 		.F. ;
			ID 		151 ;
         OF       oFld:aDialogs[1]

      REDEFINE SAY aGet[_CCODUBIT1] VAR aTmp[_CCODUBIT1];
         ID       310 ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[_CVALUBIT1] VAR aTmp[_CVALUBIT1] ;
         ID       311 ;
         BITMAP   "LUPA" ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ON HELP  ( BrwUbiLin( aGet[_CVALUBIT1], aGet[_CNOMUBIT1], aTmp[_CCODUBIT1], dbfUbicaL ) ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[_CNOMUBIT1] VAR aTmp[_CNOMUBIT1];
         WHEN     .F. ;
         ID       3111 ;
         OF       oFld:aDialogs[1]

      REDEFINE SAY aGet[_CCODUBIT2] VAR aTmp[_CCODUBIT2];
         ID       320 ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[_CVALUBIT2] VAR aTmp[_CVALUBIT2] ;
         ID       321 ;
         BITMAP   "LUPA" ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ON HELP  ( BrwUbiLin( aGet[_CVALUBIT2], aGet[_CNOMUBIT2], aTmp[_CCODUBIT2], dbfUbicaL ) ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[_CNOMUBIT2] VAR aTmp[_CNOMUBIT2];
         WHEN     .F. ;
         ID       3211 ;
         OF       oFld:aDialogs[1]

      REDEFINE SAY aGet[_CCODUBIT3] VAR aTmp[_CCODUBIT3];
         ID       330 ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[_CVALUBIT3] VAR aTmp[_CVALUBIT3] ;
         ID       331 ;
         BITMAP   "LUPA" ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ON HELP  ( BrwUbiLin( aGet[_CVALUBIT3], aGet[_CNOMUBIT3], aTmp[_CCODUBIT3], dbfUbicaL ) ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[_CNOMUBIT3] VAR aTmp[_CNOMUBIT3];
         WHEN     .F. ;
         ID       3311 ;
         OF       oFld:aDialogs[1]

		/*
		Bitmap________________________________________________________________
		*/

      REDEFINE BITMAP oBmpEmp;
         FILE     "Bmp\ImgAlbPrv.bmp" ;
         ID       500 ;
         OF       oDlg ;

      oBrwLin                 := IXBrowse():New( oFld:aDialogs[1] )

      oBrwLin:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwLin:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrwLin:cAlias          := dbfTmp

      oBrwLin:nMarqueeStyle   := 6
      oBrwLin:cName           := "Lineas de albaranes a proveedor"

         with object ( oBrwLin:AddCol() )
            :cHeader          := "Número"
            :bEditValue       := {|| if( ( dbfTmp )->lKitChl, "", Trans( ( dbfTmp )->nNumLin, "9999" ) ) }
            :nWidth           := 65
            :nDataStrAlign    := 1
            :nHeadStrAlign    := 1
         end with

         with object ( oBrwLin:AddCol() )
            :cHeader          := "Código"
            :bEditValue       := {|| ( dbfTmp )->cRef }
            :nWidth           := 80
         end with

         with object ( oBrwLin:AddCol() )
            :cHeader          := "C. Barras"
            :bEditValue       := {|| cCodigoBarrasDefecto( ( dbfTmp )->cRef, dbfCodeBar ) }
            :nWidth           := 100
            :lHide            := .t.
         end with

         with object ( oBrwLin:AddCol() )
            :cHeader          := "Código proveedor"
            :bEditValue       := {|| ( dbfTmp )->cRefPrv }
            :nWidth           := 80
            :lHide            := .t.
         end with

         with object ( oBrwLin:AddCol() )
            :cHeader          := "Descripción"
            :bEditValue       := {|| if( Empty( ( dbfTmp )->cRef ) .and. !Empty( ( dbfTmp )->mLngDes ), ( dbfTmp )->mLngDes, ( dbfTmp )->cDetalle ) }
            :nWidth           := 305
         end with

         with object ( oBrwLin:AddCol() )
            :cHeader          := "Prop. 1"
            :bEditValue       := {|| ( dbfTmp )->cValPr1 }
            :nWidth           := 60
            :lHide            := .t.
         end with

         with object ( oBrwLin:AddCol() )
            :cHeader          := "Prop. 2"
            :bEditValue       := {|| ( dbfTmp )->cValPr2 }
            :nWidth           := 60
            :lHide            := .t.
         end with

         with object ( oBrwLin:AddCol() )
            :cHeader          := "Lote"
            :bEditValue       := {|| ( dbfTmp )->cLote }
            :nWidth           := 80
            :lHide            := .t.
         end with

         with object ( oBrwLin:AddCol() )
            :cHeader          := "Caducidad"
            :bEditValue       := {|| ( dbfTmp )->dFecCad }
            :nWidth           := 80
            :lHide            := .t.
         end with

         with object ( oBrwLin:AddCol() )
            :cHeader          := "Pedido cliente"
            :bEditValue       := {|| if( !Empty( ( dbfTmp )->cNumPed ), Trans( ( dbfTmp )->cNumPed, "@R #/#########/##" ), "" ) }
            :nWidth           := 80
            :lHide            := .t.
         end with

         with object ( oBrwLin:AddCol() )
            :cHeader          := "Cliente"
            :bEditValue       := {|| if( !Empty( (dbfTmp)->cNumPed ), GetCliente( (dbfTmp)->cNumPed ), "" ) }
            :nWidth           := 180
            :lHide            := .t.
         end with

         with object ( oBrwLin:AddCol() )
            :cHeader          := cNombreUnidades()
            :bEditValue       := {|| nTotNAlbPrv( dbfTmp ) }
            :cEditPicture     := cPicUnd
            :nWidth           := 60
            :nDataStrAlign    := 1
            :nHeadStrAlign    := 1
         end with

         with object ( oBrwLin:AddCol() )
            :cHeader          := "UM. Unidad de medición"
            :bEditValue       := {|| ( dbfTmp )->cUnidad }
            :nWidth           := 25
         end with

         with object ( oBrwLin:AddCol() )
            :cHeader          := "Almacen"
            :bEditValue       := {|| ( dbfTmp )->cAlmLin }
            :nWidth           := 60
         end with

         with object ( oBrwLin:AddCol() )
            :cHeader          := "Importe"
            :bEditValue       := {|| nTotUAlbPrv( dbfTmp, nDinDiv ) }
            :cEditPicture     := cPinDiv
            :nWidth           := 90
            :nDataStrAlign    := 1
            :nHeadStrAlign    := 1
         end with

         with object ( oBrwLin:AddCol() )
            :cHeader          := "% Dto."
            :bEditValue       := {|| ( dbfTmp )->nDtoLin }
            :cEditPicture     := "@E 999.99"
            :nWidth           := 50
            :nDataStrAlign    := 1
            :nHeadStrAlign    := 1
         end with

         with object ( oBrwLin:AddCol() )
            :cHeader          := "% Prm."
            :bEditValue       := {|| ( dbfTmp )->nDtoPrm }
            :cEditPicture     := "@E 999.99"
            :nWidth           := 40
            :lHide            := .t.
            :nDataStrAlign    := 1
            :nHeadStrAlign    := 1
         end with

         with object ( oBrwLin:AddCol() )
            :cHeader          := "% " + cImp()
            :bEditValue       := {|| ( dbfTmp )->nIva }
            :cEditPicture     := "@E 999.99"
            :nWidth           := 50
            :nDataStrAlign    := 1
            :nHeadStrAlign    := 1
         end with

         with object ( oBrwLin:AddCol() )
            :cHeader          := "Total"
            :bEditValue       := {|| nTotLAlbPrv( dbfTmp, nDinDiv, nDirDiv ) }
            :cEditPicture     := cPirDiv
            :nWidth           := 80
            :nDataStrAlign    := 1
            :nHeadStrAlign    := 1
         end with

         if nMode != ZOOM_MODE
            oBrwLin:bLDblClick   := {|| EdtDeta( oBrwLin, bEdtDet, aTmp ) }
         end if

         oBrwLin:CreateFromResource( 190 )

		REDEFINE BUTTON ;
			ID 		500 ;
			OF 		oFld:aDialogs[1] ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( AppDeta( oBrwLin, bEdtDet, aTmp ) )

		REDEFINE BUTTON ;
			ID 		501 ;
			OF 		oFld:aDialogs[1] ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( EdtDeta( oBrwLin, bEdtDet, aTmp ) )

		REDEFINE BUTTON ;
			ID 		502 ;
			OF 		oFld:aDialogs[1] ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( WinDelRec( oBrwLin, dbfTmp, {|| delDeta() }, {|| RecalculaTotal( aTmp ) } ) )

		REDEFINE BUTTON ;
			ID 		503 ;
			OF 		oFld:aDialogs[1] ;
         ACTION   ( EdtZoom( oBrwLin, bEdtDet, aTmp ) )

		REDEFINE BUTTON ;
			ID 		524 ;
			OF 		oFld:aDialogs[1] ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( DbSwapUp( dbfTmp, oBrwLin ) )

		REDEFINE BUTTON ;
			ID 		525 ;
			OF 		oFld:aDialogs[1] ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( DbSwapDown( dbfTmp, oBrwLin ) )

		/*
		Descuentos______________________________________________________________
		*/

      REDEFINE GET aGet[ _CDTOESP ] VAR aTmp[ _CDTOESP ] ;
         ID       199 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ON CHANGE( RecalculaTotal( aTmp ) );
         OF       oFld:aDialogs[1]

		REDEFINE GET aGet[ _NDTOESP ] VAR aTmp[ _NDTOESP ] ;
			ID 		200 ;
         SPINNER ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         PICTURE  "@E 999.99" ;
         ON CHANGE( RecalculaTotal( aTmp ) );
			OF 		oFld:aDialogs[1]

      REDEFINE GET aGet[ _CDPP ] VAR aTmp[ _CDPP ] ;
         ID       209 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ON CHANGE( RecalculaTotal( aTmp ) );
         OF       oFld:aDialogs[1]

		REDEFINE GET aGet[ _NDPP ] VAR aTmp[ _NDPP ];
			ID 		210 ;
         SPINNER ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         PICTURE  "@E 999.99" ;
			COLOR 	CLR_GET ;
         ON CHANGE( RecalculaTotal( aTmp ) );
			OF 		oFld:aDialogs[1]

      REDEFINE GET aGet[ _CDTOUNO ] VAR aTmp[ _CDTOUNO ] ;
			ID 		240 ;
			PICTURE 	"@!" ;
			COLOR 	CLR_GET ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			OF 		oFld:aDialogs[1]

      REDEFINE GET aGet[ _NDTOUNO ] VAR aTmp[ _NDTOUNO ];
			ID 		250 ;
			PICTURE 	"@E 99.99" ;
         SPINNER ;
			COLOR 	CLR_GET ;
         ON CHANGE( RecalculaTotal( aTmp ) );
         WHEN     ( nMode != ZOOM_MODE ) ;
			OF 		oFld:aDialogs[1]

      REDEFINE GET aGet[ _CDTODOS ] VAR aTmp[ _CDTODOS ] ;
         ID       260 ;
			PICTURE 	"@!" ;
         COLOR    CLR_GET ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			OF 		oFld:aDialogs[1]

      REDEFINE GET aGet[ _NDTODOS ] VAR aTmp[ _NDTODOS ];
         ID       270 ;
			PICTURE 	"@E 99.99" ;
         SPINNER ;
         COLOR    CLR_GET ;
         ON CHANGE( RecalculaTotal( aTmp ) );
         WHEN     ( nMode != ZOOM_MODE ) ;
			OF 		oFld:aDialogs[1]

      /*
      Desglose del IGIC
		________________________________________________________________________

      REDEFINE LISTBOX oBrwIva ;
			FIELDS ;
                  if( aTotIva[ oBrwIva:nAt, 3 ] != nil,                          Trans( aTotIva[ oBrwIva:nAt, 1 ], cPirDiv ), "" ),;
                  if( aTotIva[ oBrwIva:nAt, 3 ] != nil,                          Trans( aTotIva[ oBrwIva:nAt, 2 ], cPirDiv ), "" ),;
                  if( aTotIva[ oBrwIva:nAt, 3 ] != nil,                          Trans( aTotIva[ oBrwIva:nAt, 3 ], "@E 99.9"), "" ),;
                  if( aTotIva[ oBrwIva:nAt, 3 ] != nil,                          Trans( aTotIva[ oBrwIva:nAt, 3 ] * aTotIva[ oBrwIva:nAt, 2 ] / 100, cPirDiv ), "" ),;
                  if( aTotIva[ oBrwIva:nAt, 3 ] != nil .and. aTmp[ _LRECARGO ],  Trans( aTotIva[ oBrwIva:nAt, 4 ], "@E 99.9"), "" ),;
                  if( aTotIva[ oBrwIva:nAt, 3 ] != nil .and. aTmp[ _LRECARGO ],  Trans( aTotIva[ oBrwIva:nAt, 4 ] * aTotIva[ oBrwIva:nAt, 2 ] / 100, cPirDiv ), "" ) ;
         FIELDSIZES ;
                  85,;
                  85,;
                  40,;
                  80,;
                  40,;
                  80 ;
         HEAD ;
                  "Bruto",;
                  "Base",;
                  "%" + cImp(),;
                  cImp(),;
                  "%R.E.",;
                  "R.E." ;
         ID       490 ;
			OF 		oFld:aDialogs[1]

      oBrwIva:SetArray( aTotIva )
      oBrwIva:aJustify     := { .t., .t., .t., .t., .t., .t. }
      oBrwIva:aFooters     := {||{ Trans( nTotBrt, cPirDiv ), Trans( nTotNet, cPirDiv ), "" , Trans( nTotIva, cPirDiv ) , "" , Trans( nTotReq, cPirDiv ) } }
      oBrwIva:lDrawFooters := .t.
      */

      oBrwIva                        := TXBrowse():New( oFld:aDialogs[ 1 ] )

      oBrwIva:bClrSel                := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwIva:bClrSelFocus           := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrwIva:SetArray( aTotIva )

      oBrwIva:lHScroll               := .f.
      oBrwIva:lVScroll               := .f.
      oBrwIva:nMarqueeStyle          := 5
      oBrwIva:lRecordSelector        := .f.

      oBrwIva:CreateFromResource( 490 )

      with object ( oBrwIva:aCols[ 1 ] )
         :cHeader       := "Bruto"
         :bStrData      := {|| if( !Empty( aTotIva[ oBrwIva:nArrayAt, 1 ] ), Trans( aTotIva[ oBrwIva:nArrayAt, 2 ], cPirDiv ), "" ) }
         :nWidth        := 96
         :nDataStrAlign := 1
         :nHeadStrAlign := 1
         :nFootStrAlign := 1
      end with

      with object ( oBrwIva:aCols[ 2 ] )
         :cHeader       := "Base"
         :bStrData      := {|| if( !Empty( aTotIva[ oBrwIva:nArrayAt, 2 ] ), Trans( aTotIva[ oBrwIva:nArrayAt, 2 ], cPirDiv ), "" ) }
         :nWidth        := 96
         :cEditPicture  := cPirDiv
         :nDataStrAlign := 1
         :nHeadStrAlign := 1
         :nFootStrAlign := 1
      end with

      with object ( oBrwIva:aCols[ 3 ] )
         :cHeader       := "%" + cImp()
         :bStrData      := {|| if( !IsNil( aTotIva[ oBrwIva:nArrayAt, 3 ] ), aTotIva[ oBrwIva:nArrayAt, 3 ], "" ) }
         :bEditValue    := {|| aTotIva[ oBrwIva:nArrayAt, 3 ] }
         :nWidth        := 50
         :cEditPicture  := "@E 999.99"
         :nDataStrAlign := 1
         :nHeadStrAlign := 1
         :nFootStrAlign := 1
         :nEditType     := 1
         :bEditWhen     := {|| !IsNil( aTotIva[ oBrwIva:nArrayAt, 3 ] ) }
         :bOnPostEdit   := {|o,x| EdtIva( o, x, aTotIva[ oBrwIva:nArrayAt, 3 ], dbfTmp, dbfIva, oBrwLin ), RecalculaTotal( aTmp ) }
      end with

      with object ( oBrwIva:aCols[ 4 ] )
         :cHeader       := "%R.E."
         :bStrData      := {|| if( !Empty( aTotIva[ oBrwIva:nArrayAt, 4 ] ) .and. aTmp[ _LRECARGO ], Trans( aTotIva[ oBrwIva:nArrayAt, 4 ], "@E 99.9" ), "" ) }
         :nWidth        := 50
         :nDataStrAlign := 1
         :nHeadStrAlign := 1
         :nFootStrAlign := 1
      end with

      with object ( oBrwIva:aCols[ 5 ] )
         :cHeader       := cImp()
         :bStrData      := {|| if( !Empty( aTotIva[ oBrwIva:nArrayAt, 5 ] ), Trans( aTotIva[ oBrwIva:nArrayAt, 5 ], cPirDiv ), "" ) }
         :nWidth        := 80
         :nDataStrAlign := 1
         :nHeadStrAlign := 1
         :nFootStrAlign := 1
      end with

      with object ( oBrwIva:aCols[ 6 ] )
         :cHeader       := "R.E."
         :bStrData      := {|| if( !Empty( aTotIva[ oBrwIva:nArrayAt, 6 ] ) .and. aTmp[ _LRECARGO ], Trans( aTotIva[ oBrwIva:nArrayAt, 6 ], cPirDiv ), "" ) }
         :nWidth        := 80
         :cEditPicture  := cPirDiv
         :nDataStrAlign := 1
         :nHeadStrAlign := 1
      end with

		/*
		Cajas de Totales
		------------------------------------------------------------------------
		*/

		REDEFINE SAY oGetNet VAR nGetNeto ;
			ID 		370 ;
			OF 		oFld:aDialogs[1]

		REDEFINE SAY oGetIva VAR nGetIva ;
			ID 		380 ;
			OF 		oFld:aDialogs[1]

		REDEFINE SAY oGetReq VAR nGetReq ;
			ID 		390 ;
			OF 		oFld:aDialogs[1]

      REDEFINE CHECKBOX aGet[ _LRECARGO ] VAR aTmp[ _LRECARGO ] ;
			ID 		400 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ON CHANGE( RecalculaTotal( aTmp ) );
			OF 		oFld:aDialogs[1]

      REDEFINE SAY oGetTot VAR nTotAlb;
			ID 		410 ;
			FONT 		oFont ;
			OF 		oFld:aDialogs[1]

      REDEFINE SAY oGetMasDiv VAR cGetMasDiv;
         ID       420 ;
			FONT 		oFont ;
			OF 		oFld:aDialogs[1]

      REDEFINE GET aGet[ _CSERALB ] VAR aTmp[ _CSERALB ] ;
         ID       90 ;
         PICTURE  "@!" ;
         SPINNER ;
         ON UP    ( UpSerie( aGet[ _CSERALB ] ) );
         ON DOWN  ( DwSerie( aGet[ _CSERALB ] ) );
         COLOR    CLR_GET ;
         WHEN     ( nMode == APPD_MODE .OR. nMode == DUPL_MODE );
         VALID    ( aTmp[ _CSERALB ] >= "A" .AND. aTmp[ _CSERALB ] <= "Z"  );
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _NNUMALB ] VAR aTmp[ _NNUMALB ];
			ID 		100 ;
			WHEN  	( .F. ) ;
			PICTURE 	"999999999";
			OF 		oFld:aDialogs[1]

      REDEFINE GET aGet[ _CSUFALB ] VAR aTmp[ _CSUFALB ];
			ID 		105 ;
			WHEN 		.F. ;
			OF 		oFld:aDialogs[1]

      REDEFINE GET aTmp[ _DFECALB ];
			ID 		110 ;
			SPINNER ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			COLOR 	CLR_GET ;
			OF 		oFld:aDialogs[1]

      REDEFINE BUTTON ;
         ID       558 ;
			OF 		oFld:aDialogs[1] ;
         WHEN     ( nMode == APPD_MODE .and. Empty( aTmp[_CNUMPED] ) ) ;
         ACTION   ( GrpPed( aGet, aTmp, oBrwLin ) )

      REDEFINE GET aGet[ _CNUMPED ] VAR aTmp[ _CNUMPED ];
			ID 		120 ;
         PICTURE  "@R #/#########/##" ;
         WHEN     ( nMode == APPD_MODE );
         VALID    ( cPedPrv( aGet, aTmp, oBrwLin, nMode ) );
			COLOR 	CLR_GET ;
         BITMAP   "LUPA" ;
         ON HELP  (  BrwPedPrv( aGet[ _CNUMPED ], dbfPedPrvT, dbfPedPrvL, dbfIva, dbfDiv, dbfFPago ),;
                     ::lValid(),;
                     oFld:aDialogs[1]:GoNextCtrl( oFld:aDialogs[1]:hWnd ) );
			OF 		oFld:aDialogs[1]

      REDEFINE GET aGet[ _LFACTURADO ] VAR cEstado;
         WHEN     .f. ;
         ID       130 ;
			OF 		oFld:aDialogs[1]

      REDEFINE GET aGet[ _CSUALB ] VAR aTmp[ _CSUALB ];
         ID       135 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _DSUALB ] VAR aTmp[ _DSUALB ];
         ID       136 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GROUP oSayLabels[ 1 ] ID 700 OF oFld:aDialogs[ 1 ] TRANSPARENT
      REDEFINE SAY   oSayLabels[ 2 ] ID 701 OF oFld:aDialogs[ 1 ]
      REDEFINE SAY   oSayLabels[ 3 ] ID 702 OF oFld:aDialogs[ 1 ]
      REDEFINE SAY   oSayLabels[ 4 ] ID 703 OF oFld:aDialogs[ 1 ]
      REDEFINE SAY   oSayLabels[ 5 ] ID 704 OF oFld:aDialogs[ 1 ]
      REDEFINE SAY   oSayLabels[ 6 ] ID 705 OF oFld:aDialogs[ 1 ]
      REDEFINE SAY   oSayLabels[ 7 ] ID 706 OF oFld:aDialogs[ 1 ]

      //Segunda caja de dialogo

      REDEFINE GET aGet[ _CCODDLG ] VAR aTmp[ _CCODDLG ] ;
         ID       300 ;
         WHEN     ( .f. ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET oSay[ 6 ] VAR cSay[ 6 ] ;
         ID       301 ;
         WHEN     ( .f. ) ;
         OF       oFld:aDialogs[2]

      /*
      Regimen de IGIC-----------------------------------------------------------
      */

      REDEFINE RADIO aGet[ _NREGIVA ] VAR aTmp[ _NREGIVA ] ;
         ID       270, 271, 272, 273 ;
         WHEN     ( .f. ) ;
         OF       oFld:aDialogs[2]

      /*
      Datos de envio-----------------------------------------------------------
      */

		REDEFINE GET aGet[_DFECENT] VAR aTmp[_DFECENT] ;
			ID 		160 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			OF 		oFld:aDialogs[2]

      REDEFINE GET aGet[_NBULTOS] VAR aTmp[_NBULTOS] ;
         ID       170 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         SPINNER ;
         PICTURE  "@E 999,999" ;
         OF       oFld:aDialogs[2]

		REDEFINE GET aGet[_CEXPED] VAR aTmp[_CEXPED];
         ID       180 ;
			COLOR 	CLR_GET ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			OF 		oFld:aDialogs[2]

		REDEFINE GET aGet[_COBSERV] VAR aTmp[_COBSERV];
         MEMO;
         ID       200 ;
			COLOR 	CLR_GET ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			OF 		oFld:aDialogs[2]

      /*Impresión ( informa de si está imprimido o no y de cuando se imprimió )*/

      REDEFINE CHECKBOX aGet[ _LIMPRIMIDO ] VAR aTmp[ _LIMPRIMIDO ] ;
         ID       120 ;
         WHEN     ( nMode != ZOOM_MODE .and. lUsrMaster() ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ _DFECIMP ] VAR aTmp[ _DFECIMP ] ;
         ID       121 ;
         WHEN     ( nMode != ZOOM_MODE .and. lUsrMaster() ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ _CHORIMP ] VAR aTmp[ _CHORIMP ] ;
         ID       122 ;
         WHEN     ( nMode != ZOOM_MODE .and. lUsrMaster() ) ;
         OF       oFld:aDialogs[2]

      /*
      Caja de diálogo de incidencias-------------------------------------------
      */

      oBrwInc                 := IXBrowse():New( oFld:aDialogs[ 3 ] )

      oBrwInc:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwInc:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrwInc:cAlias          := dbfTmpInc

      oBrwInc:nMarqueeStyle   := 5
      oBrwInc:cName           := "Incidencias de albaranes a proveedor"

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
            :nWidth           := 220
         end with

         with object ( oBrwInc:AddCol() )
            :cHeader          := "Fecha"
            :bEditValue       := {|| Dtoc( ( dbfTmpInc )->dFecInc ) }
            :nWidth           := 90
         end with

         with object ( oBrwInc:AddCol() )
            :cHeader          := "Descripción"
            :bEditValue       := {|| ( dbfTmpInc )->mDesInc }
            :nWidth           := 420
         end with

         if nMode != ZOOM_MODE
            oBrwInc:bLDblClick   := {|| WinEdtRec( oBrwInc, bEdtInc, dbfTmpInc, nil, nil, aTmp ) }
         end if

         oBrwInc:CreateFromResource( 210 )

      REDEFINE BUTTON ;
         ID       500 ;
         OF       oFld:aDialogs[ 3 ] ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( WinAppRec( oBrwInc, bEdtInc, dbfTmpInc, nil, nil, aTmp ) )

      REDEFINE BUTTON ;
         ID       501 ;
         OF       oFld:aDialogs[ 3 ] ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( WinEdtRec( oBrwInc, bEdtInc, dbfTmpInc, nil, nil, aTmp ) )

		REDEFINE BUTTON ;
			ID 		502 ;
         OF       oFld:aDialogs[ 3 ] ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( DbDelRec( oBrwInc, dbfTmpInc, nil, nil, .t. ) )

		REDEFINE BUTTON ;
			ID 		503 ;
         OF       oFld:aDialogs[ 3 ] ;
         ACTION   ( WinZooRec( oBrwInc, bEdtInc, dbfTmpInc ) )

      /*
      Caja de diálogo de documentos--------------------------------------------
      */

      oBrwDoc                 := TXBrowse():New( oFld:aDialogs[ 4 ] )

      oBrwDoc:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwDoc:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrwDoc:cAlias          := dbfTmpDoc

      oBrwDoc:nMarqueeStyle   := 5
      oBrwDoc:nRowHeight      := 40
      oBrwDoc:nDataLines      := 2

         with object ( oBrwDoc:AddCol() )
            :cHeader          := "Documento"
            :bEditValue       := {|| Rtrim( ( dbfTmpDoc )->cNombre ) + CRLF + Space( 5 ) + Rtrim( ( dbfTmpDoc )->cRuta ) }
            :nWidth           := 885
         end with

         if nMode != ZOOM_MODE
            oBrwDoc:bLDblClick   := {|| ShellExecute( oDlg:hWnd, "open", Rtrim( ( dbfTmpDoc )->cRuta ) ) }
         end if

         oBrwDoc:CreateFromResource( 210 )

      REDEFINE BUTTON ;
         ID       500 ;
         OF       oFld:aDialogs[ 4 ] ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( WinAppRec( oBrwDoc, bEdtDoc, dbfTmpDoc, nil, nil, aTmp ) )

      REDEFINE BUTTON ;
         ID       501 ;
         OF       oFld:aDialogs[ 4 ] ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( WinEdtRec( oBrwDoc, bEdtDoc, dbfTmpDoc, nil, nil, aTmp ) )

		REDEFINE BUTTON ;
			ID 		502 ;
         OF       oFld:aDialogs[ 4 ] ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( DbDelRec( oBrwDoc, dbfTmpDoc, nil, nil, .f. ) )

		REDEFINE BUTTON ;
			ID 		503 ;
         OF       oFld:aDialogs[ 4 ] ;
         ACTION   ( WinZooRec( oBrwDoc, bEdtDoc, dbfTmpDoc ) )

      REDEFINE BUTTON ;
         ID       504 ;
         OF       oFld:aDialogs[ 4 ] ;
         ACTION   ( ShellExecute( oDlg:hWnd, "open", rTrim( ( dbfTmpDoc )->cRuta ) ) )

      /*
		Botones comunes a la caja de dialogo___________________________________
		*/

      REDEFINE BUTTON ;
         ID       4 ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( RecalculaAlbaranProveedores( aTmp, oDlg ), ( oBrwLin:Refresh() ), RecalculaTotal( aTmp ) )

		REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( EndTrans( aTmp, aGet, dbfIva, nDinDiv, nDirDiv, oBrw, nMode, oDlg ) )

      REDEFINE BUTTON ;
         ID       3 ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( if( EndTrans( aTmp, aGet, dbfIva, nDinDiv, nDirDiv, oBrw, nMode, oDlg ), GenAlbPrv( IS_PRINTER ), ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
         CANCEL ;
         ACTION   ( If( ExitNoSave( nMode, dbfTmp ), oDlg:end(), ) )

   if nMode != ZOOM_MODE
      oFld:aDialogs[1]:AddFastKey( VK_F2, {|| AppDeta( oBrwLin, bEdtDet, aTmp ) } )
      oFld:aDialogs[1]:AddFastKey( VK_F3, {|| EdtDeta( oBrwLin, bEdtDet, aTmp ) } )
      oFld:aDialogs[1]:AddFastKey( VK_F4, {|| WinDelRec( oBrwLin, dbfTmp, {|| delDeta() }, {|| RecalculaTotal( aTmp ) } ) } )

      oFld:aDialogs[3]:AddFastKey( VK_F2, {|| WinAppRec( oBrwInc, bEdtInc, dbfTmpInc, nil, nil, aTmp ) } )
      oFld:aDialogs[3]:AddFastKey( VK_F3, {|| WinEdtRec( oBrwInc, bEdtInc, dbfTmpInc, nil, nil, aTmp ) } )
      oFld:aDialogs[3]:AddFastKey( VK_F4, {|| DbDelRec( oBrwInc, dbfTmpInc, nil, nil, .t. ) } )

      oFld:aDialogs[4]:AddFastKey( VK_F2, {|| WinAppRec( oBrwDoc, bEdtDoc, dbfTmpDoc, nil, nil, aTmp ) } )
      oFld:aDialogs[4]:AddFastKey( VK_F3, {|| WinEdtRec( oBrwDoc, bEdtDoc, dbfTmpDoc, nil, nil, aTmp ) } )
      oFld:aDialogs[4]:AddFastKey( VK_F4, {|| DbDelRec( oBrwDoc, dbfTmpDoc, nil, nil, .f. ) } )

      oDlg:AddFastKey( VK_F7, {|| ExcelImport( aTmp, dbfTmp, dbfArticulo, dbfArtCom, dbfFamilia, dbfDiv, oBrwLin ) } )
      oDlg:AddFastKey( VK_F5, {|| EndTrans( aTmp, aGet, dbfIva, nDinDiv, nDirDiv, oBrw, nMode, oDlg ) } )
      oDlg:AddFastKey( VK_F6, {|| if( EndTrans( aTmp, aGet, dbfIva, nDinDiv, nDirDiv, oBrw, nMode, oDlg ), GenAlbPrv( IS_PRINTER ), ) } )
      oDlg:AddFastKey( 65,    {|| if( GetKeyState( VK_CONTROL ), CreateInfoArticulo(), ) } )
   end if

   oDlg:AddFastKey ( VK_F1, {|| GoHelp() } )

   do case
      case nMode == APPD_MODE .and. lRecogerUsuario() .and. Empty( cCodArt )
         oDlg:bStart := {|| if( lGetUsuario( aGet[ _CCODUSR ], dbfUsr ),;
                              ShowKitCom( dbfAlbPrvT, dbfTmp, oBrwLin, cCodPrv, dbfTmpInc, aGet ),;
                              oDlg:end() ) }

      case nMode == APPD_MODE .and. lRecogerUsuario() .and. !Empty( cCodArt )
         oDlg:bStart := {|| if( lGetUsuario( aGet[ _CCODUSR ], dbfUsr ),;
                              ( AppDeta( oBrwLin, bEdtDet, aTmp, cCodArt ), ShowKitCom( dbfAlbPrvT, dbfTmp, oBrwLin, cCodPrv, dbfTmpInc, aGet ) ),;
                              oDlg:end() ) }

      case nMode == APPD_MODE .and. !lRecogerUsuario() .and. !Empty( cCodArt )
         oDlg:bStart := {|| AppDeta( oBrwLin, bEdtDet, aTmp, cCodArt ), ShowKitCom( dbfAlbPrvT, dbfTmp, oBrwLin, cCodPrv, dbfTmpInc, aGet ) }

      otherwise
         oDlg:bStart := {|| ShowKitCom( dbfAlbPrvT, dbfTmp, oBrwLin, cCodPrv, dbfTmpInc, aGet ) }

   end case

	ACTIVATE DIALOG oDlg	;
      ON INIT     (  if( !Empty( cCodPed ), aGet[ _CNUMPED ]:lValid(), ), cNomUbicaT( aTmp, aGet, dbfAlm ), EdtRecMenu( aTmp, oDlg ),;
                     oBrwLin:Load() ) ;
      ON PAINT    ( RecalculaTotal( aTmp ) );
      CENTER

   EndEdtRecMenu()

   oBmpEmp:end()
   oBmpDiv:end()
   oFont:end()
   oBmpGeneral:End()

   ( dbfAlbPrvT )->( OrdSetFocus( nOrd ) )

   /*
   Estado anterior del pedido si lo hay----------------------------------------
   */

   if !Empty( aTmp[_CNUMPED] ) .and. nOldEst != nil
      if dbLock( dbfPedPrvT )
         ( dbfPedPrvT )->nEstado := nOldEst
         ( dbfPedPrvT )->( dbUnLock() )
      end if
   end if

   nOldEst           := nil

   /*
   Borramos los ficheros temporales--------------------------------------------
   */

   KillTrans( oBrwLin, oBrwInc )

   /*
   Escribe los datos pendientes------------------------------------------------
   */

   dbCommitAll()

RETURN ( oDlg:nResult == IDOK )

//----------------------------------------------------------------------------//

Static Function EdtRecMenu( aTmp, oDlg )

   MENU oMenu

      MENUITEM    "&1. Rotor"

         MENU

            if !lExternal

            MENUITEM    "&1. Visualizar pedido";
               MESSAGE  "Visualiza el pedido del que proviene" ;
               RESOURCE "Clipboard_empty_businessman_16" ;
               ACTION   ( if(!Empty( aTmp[ _CNUMPED ] ), ZooPedPrv( aTmp[ _CNUMPED ] ), msgStop( "No hay pedido asociado" ) ) )

            SEPARATOR

            MENUITEM    "&2. Modificar proveedor";
               MESSAGE  "Modificar la ficha del proveedor" ;
               RESOURCE "Businessman_16" ;
               ACTION   ( EdtPrv( aTmp[ _CCODPRV ] ) )

            MENUITEM    "&3. Informe de proveedor";
               MESSAGE  "Abrir el informe del proveedor" ;
               RESOURCE "Info16" ;
               ACTION   ( InfProveedor( aTmp[ _CCODPRV ] ) );

            SEPARATOR

            end if

            MENUITEM    "&4. Informe del documento";
               MESSAGE  "Abrir el informe del documento" ;
               RESOURCE "Info16" ;
               ACTION   ( TTrazaDocumento():Activate( ALB_PRV, ( dbfAlbPrvT )->cSerAlb + Str( ( dbfAlbPrvT )->nNumAlb ) + ( dbfAlbPrvT )->cSufAlb ) )

         ENDMENU

   ENDMENU

   oDlg:SetMenu( oMenu )

Return ( oMenu )

//----------------------------------------------------------------------------//

Static Function EndEdtRecMenu()

Return ( oMenu:End() )

//---------------------------------------------------------------------------//

Static Function RecalculaAlbaranProveedores( aTmp, oDlg )

   local nRecNum
   local nPreCom
   local cCodPrv                    := aTmp[ _CCODPRV ]

   if !ApoloMsgNoYes( "¡Atención!,"                                      + CRLF + ;
                  "todos los precios se recalcularán en función de"  + CRLF + ;
                  "los valores en las bases de datos.",;
                  "¿ Desea proceder ?" )
      return nil
   end if

   oDlg:Disable()

   ( dbfArticulo )->( ordSetFocus( "Codigo" ) )

   nRecNum                          := ( dbfTmp )->( RecNo() )

   ( dbfTmp )->( dbGotop() )
   while !( dbfTmp )->( eof() )

      /*
      Ahora buscamos por el codigo interno
      */

      nPreCom                       := nComPro( ( dbfTmp )->cRef, ( dbfTmp )->cCodPr1, ( dbfTmp )->cValPr1, ( dbfTmp )->cCodPr2, ( dbfTmp )->cValPr2, dbfArtCom )

      if nPrecom  != 0

         ( dbfTmp )->nPreDiv        := nPreCom

      else

         if uFieldEmpresa( "lCosPrv", .f. )
            nPreCom                 := nPreArtPrv( cCodPrv, ( dbfTmp )->cRef, dbfArtPrv )
         end if

         if nPreCom != 0
            ( dbfTmp )->nPreDiv     := nPreCom
         else
            ( dbfTmp )->nPreDiv     := nCosto( ( dbfTmp )->cRef, dbfArticulo, dbfKit, .f., aTmp[ _CDIVALB ], dbfDiv )
         end if

         /*
         Descuento de articulo----------------------------------------------
         */

         if uFieldEmpresa( "lCosPrv", .f. )

            nPreCom                 := nDtoArtPrv( cCodPrv, ( dbfTmp )->cRef, dbfArtPrv )

            if nPreCom != 0
               ( dbfTmp )->nPreDiv  := nPreCom
            end if

            /*
            Descuento de promocional-------------------------------------------
            */

            nPreCom                 := nPrmArtPrv( cCodPrv, ( dbfTmp )->cRef, dbfArtPrv )

            if nPreCom != 0
               ( dbfTmp )->nDtoPrm  := nPreCom
            end if

         end if

      end if

      ( dbfTmp )->( dbSkip() )

   end while

   ( dbfTmp )->( dbGoTo( nRecNum ) )

   oDlg:Enable()

return nil

//----------------------------------------------------------------------------//

Function ExcelImport( aTmpAlb, dbfTmp, dbfArticulo, dbfArtCom, dbfFamilia, dbfDiv, oBrw, lPedido )

   local n
   local m
   local nComPro
   local nUnidad
   local nCajas
   local cCodigo
   local cProp1
   local cProp2
   local oOleExcel
   local cFileExcel  := cGetFile( "Excel ( *.Xls ) | " + "*.Xls", "Seleccione la hoja de calculo" )

   DEFAULT lPedido   := .f.

   if File( cFileExcel )

      oOleExcel                        := TOleExcel():New( "Importando hoja de excel", "Conectando...", .f. )

      oOleExcel:oExcel:Visible         := .t.
      oOleExcel:oExcel:DisplayAlerts   := .f.
      oOleExcel:oExcel:WorkBooks:Open( cFileExcel )

      for m := 1 to 3

         oOleExcel:oExcel:WorkSheets( m ):Activate()

         for n := 9 to 33

            nUnidad  := oOleExcel:oExcel:ActiveSheet:Range( "C" + lTrim( Str( n ) ) ):Value
            nCajas   := oOleExcel:oExcel:ActiveSheet:Range( "E" + lTrim( Str( n ) ) ):Value
            cCodigo  := oOleExcel:oExcel:ActiveSheet:Range( "D" + lTrim( Str( n ) ) ):Value

            if !Empty( nUnidad ) .and. !Empty( nCajas ) .and. !Empty( cCodigo )
               cProp1   := Str( nCajas, 3 )
               cProp2   := StrTran( cCodigo, "V", "T" )
               cCodigo  := "2044" + StrTran( Str( nCajas, 3 ), Space( 1 ), "0" )

               /*
               Buscamos el articulo en la tabla--------------------------------
               */

               if ( dbfArticulo )->( dbSeek( cCodigo ) )

                  ( dbfTmp )->( dbAppend() )

                  ( dbfTmp )->nNumLin     := nLastNum( dbfTmp )
                  ( dbfTmp )->cRef        := ( dbfArticulo )->Codigo
                  ( dbfTmp )->cDetalle    := ( dbfArticulo )->Nombre
                  ( dbfTmp )->cCodPr1     := "1"
                  ( dbfTmp )->cValPr1     := cProp1
                  ( dbfTmp )->cCodPr2     := "2"
                  ( dbfTmp )->cValPr2     := cProp2
                  ( dbfTmp )->nIva        := nIva( dbfIva, ( dbfArticulo )->TipoIva )
                  ( dbfTmp )->nUniCaja    := nUnidad
                  ( dbfTmp )->cCodFam     := ( dbfArticulo )->Familia
                  ( dbfTmp )->cGrpFam     := cGruFam( ( dbfArticulo )->Familia, dbfFamilia )

                  if lPedido

                     ( dbfTmp )->nCanPed  := nCajas / 100
                     ( dbfTmp )->nPreDiv  := nRetPreArt( 1, cDivEmp(), .f., dbfArticulo, dbfDiv, dbfKit, dbfIva )

                  else

                     ( dbfTmp )->nCanEnt     := nCajas / 100

                     nComPro                 := nComPro( ( dbfTmp )->cRef, ( dbfTmp )->cCodPr1, ( dbfTmp )->cValPr1, ( dbfTmp )->cCodPr2, ( dbfTmp )->cValPr2, dbfArtCom )
                     if nComPro != 0
                        ( dbfTmp )->nPreDiv  := nComPro // nCnv2Div( nComPro, cDivEmp(), aTmpAlb[ _CDIVALB ], dbfDiv, .f. )
                     else
                        ( dbfTmp )->nPreDiv  := ( dbfArticulo )->pCosto // nCnv2Div( ( dbfArticulo )->pCosto, cDivEmp(), aTmpAlb[ _CDIVALB ], dbfDiv, .f. )
                     end if

                  end if

                  /*
                  Tratamos de obtener el precio por propiedades----------------
                  */

                  ( dbfTmp )->( dbUnLock() )

               end if

            end if

         next

      next

      oOleExcel:oExcel:Quit()

      oOleExcel:oExcel:DisplayAlerts := .t.

      oOleExcel:End()

      ( dbfTmp )->( dbGoTop() )

      oBrw:Refresh()

   end if

Return nil

//---------------------------------------------------------------------------//

/*
Carga los datos del proveedor
*/

STATIC FUNCTION LoaPrv( aGet, aTmp, dbfPrv, nMode, oSay, oTlfPrv )

   local lValid      := .f.
   local cNewCodCli  := aGet[ _CCODPRV ]:VarGet()
   local lChgCodCli  := ( Empty( cOldCodCli ) .or. cOldCodCli != cNewCodCli )

   if Empty( cNewCodCli )
      Return .t.
   elseif At( ".", cNewCodCli ) != 0
      cNewCodCli     := PntReplace( aGet[ _CCODPRV ], "0", RetNumCodPrvEmp() )
   else
      cNewCodCli     := Rjust( cNewCodCli, "0", RetNumCodPrvEmp() )
   end if

   if ( dbfPrv )->( dbSeek( cNewCodCli ) )

      if ( dbfPrv )->lBlqPrv
         msgStop( "Proveedor bloqueado, no se pueden realizar operaciones de compra" )
         return .f.
      end if

      aGet[ _CCODPRV ]:cText( ( dbfPrv )->Cod )

      if Empty( aGet[ _CNOMPRV ]:varGet() ) .or. lChgCodCli
         aGet[ _CNOMPRV ]:cText( ( dbfPrv )->Titulo )
      end if

      if oTlfPrv != nil
         oTlfPrv:cText( ( dbfPrv )->Telefono )
      end if

      if Empty( aGet[ _CDIRPRV ]:varGet() ) .or. lChgCodCli
         aGet[ _CDIRPRV ]:cText( ( dbfPrv )->Domicilio )
      endif

      if Empty( aGet[ _CPOBPRV ]:varGet() ) .or. lChgCodCli
         aGet[ _CPOBPRV ]:cText( (dbfPrv)->Poblacion )
      endif

      if Empty( aGet[ _CPROPRV ]:varGet() ) .or. lChgCodCli
         aGet[ _CPROPRV ]:cText( (dbfPrv)->Provincia )
      endif

      if Empty( aGet[ _CPOSPRV ]:varGet() ) .or. lChgCodCli
         aGet[ _CPOSPRV ]:cText( (dbfPrv)->CodPostal )
      endif

      if Empty( aGet[ _CDNIPRV ]:varGet() ) .or. lChgCodCli
         aGet[ _CDNIPRV ]:cText( ( dbfPrv )->Nif )
      endif

      /*
      Descuentos
      */

      if lChgCodCli
         aGet[ _CDTOESP ]:cText( ( dbfPrv )->cDtoEsp )
         aGet[ _NDTOESP ]:cText( ( dbfPrv )->nDtoEsp )
         aGet[ _CDPP    ]:cText( ( dbfPrv )->cDtoPp )
         aGet[ _NDPP    ]:cText( ( dbfPrv )->DtoPp )
      end if

      if Empty( aGet[ _CCODPGO ]:VarGet() )
         aGet[ _CCODPGO ]:cText( ( dbfPrv )->fPago )
         aGet[ _CCODPGO ]:lValid()
      end if

      if nMode == APPD_MODE

         aGet[ _NREGIVA ]:nOption( Max( ( dbfPrv )->nRegIva, 1 ) )
         aGet[ _NREGIVA ]:Refresh()

         if Empty( aTmp[ _CSERALB ] )

            if !Empty( ( dbfPrv )->Serie )
               aGet[ _CSERALB ]:cText( ( dbfPrv )->Serie )
            end if

         else

            if !Empty( ( dbfPrv )->Serie ) .and. aTmp[ _CSERALB ] != ( dbfPrv )->Serie .and. ApoloMsgNoYes( "La serie del proveedor seleccionado es distinta a la anterior.", "¿Desea cambiar la serie?" )
               aGet[ _CSERALB ]:cText( ( dbfPrv )->Serie )
            end if

         end if

      end if

      if lChgCodCli
         aTmp[ _LRECARGO ] := ( dbfPrv )->lReq
         aGet[ _LRECARGO ]:Refresh()
      end if

      if ( dbfPrv )->lMosCom .and. !Empty( ( dbfPrv )->mComent ) .and. lChgCodCli
         MsgStop( AllTrim( ( dbfPrv )->mComent ) )
      end if

      cOldCodCli  := ( dbfPrv )->Cod

      lValid      := .t.

   else

      msgStop( "Proveedor no encontrado" )

   end if

RETURN lValid

//----------------------------------------------------------------------------//

/*
Funcion Auxiliar para A¤adir lineas de detalle a un albaran
*/

STATIC FUNCTION AppDeta( oBrwLin, bEdtDet, aTmp, cCodArt )

   WinAppRec( oBrwLin, bEdtDet, dbfTmp, aTmp, cCodArt )

RETURN ( RecalculaTotal( aTmp ) )

//--------------------------------------------------------------------------//

/*
Funcion Auxiliar para la Edici¢n de Lineas de Detalle en un albaran
*/

STATIC FUNCTION EdtDeta( oBrwLin, bEdtDet, aTmp )

   WinEdtRec( oBrwLin, bEdtDet, dbfTmp, aTmp )

RETURN ( RecalculaTotal( aTmp ) )

//--------------------------------------------------------------------------//

/*
Funcion Auxiliar para borrar las Lineas de Detalle en un albaran
*/

STATIC FUNCTION DelDeta()

   CursorWait()

   while ( dbfTmpSer )->( dbSeek( Str( ( dbfTmp )->nNumLin, 4 ) ) )
      ( dbfTmpSer )->( dbDelete() )
   end while

   if ( dbfTmp )->lKitArt
      dbDelKit( , dbfTmp, ( dbfTmp )->nNumLin )
   end if

   CursorWE()

Return ( .t. )

//--------------------------------------------------------------------------//

/*
Funcion Auxiliar para la Visualizaci¢n de Lineas de Detalle en una Abono
*/

STATIC FUNCTION EdtZoom( oBrwLin, bEdtDet, aTmp )

   WinZooRec( oBrwLin, bEdtDet, dbfTmp, aTmp )

RETURN NIL

//--------------------------------------------------------------------------//

/*
Edita las lineas de Detalle
*/

STATIC FUNCTION EdtDet( aTmp, aGet, dbfAlbPrvL, oBrw, aTmpAlb, cCodArt, nMode )

	local oDlg
   local oFld
   local oBmp
   local oBtn
   local oGet1
   local oTotal
	local nTotal
   local cSay2
   local oSay2
   local cGetIra           := Space( 50 )
   local oGetIra
   local oBrwPrp
   local oSayPr1
   local oSayPr2
   local oSayVp1
   local oSayVp2
   local cSayVp1           := ""
   local cSayVp2           := ""
   local cSayPr1           := ""
   local cSayPr2           := ""
   local oBeneficioSobre   := Array( 6 )
   local cBeneficioSobre   := Afill( Array( 6 ), "" )
   local aBeneficioSobre   := { "Costo", "Venta" }
   local oGetStk
   local nGetStk           := 0
   local oSayLote

   cOldCodArt              := aTmp[ _CREF ]
   cOldPrpArt              := aTmp[ _CCODPR1 ] + aTmp[ _CCODPR2 ] + aTmp[ _CVALPR1 ] + aTmp[ _CVALPR2 ]
   cOldUndMed              := aTmp[ _CUNIDAD ]

	/*
	Modificamos los valores por defecto
	*/

   do case
   case nMode == APPD_MODE

      aTmp[ _NUNICAJA ]    := 1
      aTmp[ _CALMLIN  ]    := aTmpAlb[ _CCODALM ]
      aTmp[ _CCODPED  ]    := aTmpAlb[ _CNUMPED ]
      aTmp[ _LCHGLIN  ]    := lActCos()
      aTmp[ _DFECCAD  ]    := Ctod( "" )
      aTmp[ _NNUMLIN  ]    := nLastNum( dbfTmp )

      if !Empty( cCodArt )
         aTmp[ _CREF ]     := cCodArt
      end if

   case nMode == EDIT_MODE

      if !Empty( aTmp[ _CREF ] )
         ( dbfArticulo )->( dbSeek( aTmp[ _CREF ] ) )
      end if

   end case

   cBeneficioSobre[ 1 ]    := aBeneficioSobre[ Max( aTmp[ _NBNFSBR1 ], 1 ) ]
   cBeneficioSobre[ 2 ]    := aBeneficioSobre[ Max( aTmp[ _NBNFSBR2 ], 1 ) ]
   cBeneficioSobre[ 3 ]    := aBeneficioSobre[ Max( aTmp[ _NBNFSBR3 ], 1 ) ]
   cBeneficioSobre[ 4 ]    := aBeneficioSobre[ Max( aTmp[ _NBNFSBR4 ], 1 ) ]
   cBeneficioSobre[ 5 ]    := aBeneficioSobre[ Max( aTmp[ _NBNFSBR5 ], 1 ) ]
   cBeneficioSobre[ 6 ]    := aBeneficioSobre[ Max( aTmp[ _NBNFSBR6 ], 1 ) ]

   DEFINE DIALOG oDlg RESOURCE "LAlbPrv" TITLE LblTitle( nMode ) + "lineas a albaranes de proveedores"

      REDEFINE FOLDER oFld ;
         ID       400 ;
         OF       oDlg ;
         PROMPT   "&General",;
                  "&Precios",;
                  "&Observaciones" ;
         DIALOGS  "LALBPRV_1",;
                  "LALBPRV_2",;
                  "LFACPRV_5"

      oFld:aEnable   := { .t., !Empty( aTmp[ _CREF ] ), .t. }

      REDEFINE GET aGet[ _CREF ] VAR aTmp[ _CREF ];
			ID 		110 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( loaArt( aGet, aTmp, aTmpAlb, oFld, oSayPr1, oSayPr2, oSayVp1, oSayVp2, oBmp, oBrwPrp, oGetIra, oDlg, oSayLote, oGetStk, oBeneficioSobre, oTotal, nMode ) );
         BITMAP   "LUPA" ;
         ON HELP  ( BrwArticulo( aGet[ _CREF ], aGet[ _CDETALLE ] ) ) ;
			OF 		oFld:aDialogs[1]

      /*
      Lotes
      ------------------------------------------------------
      */

      REDEFINE SAY oSayLote;
         ID       111 ;
			OF 		oFld:aDialogs[1]

      REDEFINE GET aGet[ _CLOTE ] VAR aTmp[ _CLOTE ];
         ID       112 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
			OF 		oFld:aDialogs[1]

      REDEFINE GET aGet[ _DFECCAD ] VAR aTmp[ _DFECCAD ];
         ID       113 ;
         IDSAY    114 ;
			SPINNER ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CDETALLE ] VAR aTmp[ _CDETALLE ] ;
			ID 		120 ;
         WHEN     ( ( lModDes() .or. Empty( aTmp[ _CDETALLE ] ) ) .AND. nMode != ZOOM_MODE ) ;
			OF 		oFld:aDialogs[1]

      REDEFINE GET aGet[ _MLNGDES ] VAR aTmp[ _MLNGDES ] ;
			MEMO ;
			ID 		121 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			OF 		oFld:aDialogs[1]

      REDEFINE GET aGet[ _NIVA ] VAR aTmp[ _NIVA ] ;
			ID 		130 ;
         WHEN     ( lModIva() .AND. nMode != ZOOM_MODE ) ;
			PICTURE 	"@E 99.99" ;
         ON CHANGE( lCalcDeta( aTmp, aTmpAlb, aGet, oTotal ) );
         VALID    ( if( lTiva( dbfIva, aTmp[ _NIVA ], @aTmp[ _NREQ ] ), ( aGet[ _NIVALIN ]:cText( aTmp[ _NIVA ] ), .t. ), .f. ) );
         BITMAP   "LUPA" ;
         ON HELP  ( BrwIva( Self, dbfIva, , .t. ) ) ;
			OF 		oFld:aDialogs[1]

      /*
      Propiedades
      -------------------------------------------------------------------------
      */

      REDEFINE GET aGet[ _CVALPR1 ] VAR aTmp[ _CVALPR1 ];
         ID       220 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         BITMAP   "LUPA" ;
         VALID    ( if( lPrpAct( aGet[ _CVALPR1 ], oSayVp1, aTmp[ _CCODPR1 ], dbfTblPro ),;
                        loaArt( aGet, aTmp, aTmpAlb, oFld, oSayPr1, oSayPr2, oSayVp1, oSayVp2, oBmp, oBrwPrp, oGetIra, oDlg, oSayLote, oGetStk, oBeneficioSobre, oTotal, nMode ),;
                        .f. ) ) ;
         ON HELP  ( brwPrpAct( aGet[ _CVALPR1 ], oSayVp1, aTmp[ _CCODPR1 ] ) ) ;
			OF 		oFld:aDialogs[1]

         aGet[ _CVALPR1 ]:bChange   := {|| aGet[ _CVALPR1 ]:Assign(), oStock:nPutStockActual( aTmp[ _CREF ], aTmp[ _CALMLIN ], aTmp[ _CVALPR1 ], aTmp[ _CVALPR2 ], aTmp[ _CLOTE ], aTmp[ _LKITART ], aTmp[ _NCTLSTK ], oGetStk ) }

      REDEFINE SAY oSayPr1 VAR cSayPr1;
         ID       221 ;
			OF 		oFld:aDialogs[1]

      REDEFINE GET oSayVp1 VAR cSayVp1;
         ID       222 ;
         WHEN     .f. ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CVALPR2 ] VAR aTmp[ _CVALPR2 ];
         ID       230 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         BITMAP   "LUPA" ;
         VALID    ( if( lPrpAct( aGet[ _CVALPR2 ], oSayVp2, aTmp[ _CCODPR2 ], dbfTblPro ),;
                        loaArt( aGet, aTmp, aTmpAlb, oFld, oSayPr1, oSayPr2, oSayVp1, oSayVp2, oBmp, oBrwPrp, oGetIra, oDlg, oSayLote, oGetStk, oBeneficioSobre, oTotal, nMode ),;
                        .f. ) ) ;
         ON HELP  ( brwPrpAct( aGet[ _CVALPR2 ], oSayVp2, aTmp[ _CCODPR2 ] ) ) ;
			OF 		oFld:aDialogs[1]

         aGet[ _CVALPR2 ]:bChange   := {|| aGet[ _CVALPR2 ]:Assign(), oStock:nPutStockActual( aTmp[ _CREF ], aTmp[ _CALMLIN ], aTmp[ _CVALPR1 ], aTmp[ _CVALPR2 ], aTmp[ _CLOTE ], aTmp[ _LKITART ], aTmp[ _NCTLSTK ], oGetStk ) }

      REDEFINE SAY oSayPr2 VAR cSayPr2;
         ID       231 ;
			OF 		oFld:aDialogs[1]

      REDEFINE GET oSayVp2 VAR cSayVp2;
         ID       232 ;
         WHEN     .f. ;
         OF       oFld:aDialogs[1]

      REDEFINE LISTBOX oBrwPrp ;
         FIELDS   "" ;
         HEAD     "" ;
         ID       100 ;
         OF       oFld:aDialogs[1]

      /*
      fin de propiedades
      -------------------------------------------------------------------------
      */

      REDEFINE GET aGet[ _NCANENT ] VAR aTmp[ _NCANENT ];
			ID 		140 ;
			SPINNER ;
         WHEN     ( lUseCaj() .AND. nMode != ZOOM_MODE ) ;
         VALID    ( lCalcDeta( aTmp, aTmpAlb, aGet, oTotal ) );
         ON CHANGE( lCalcDeta( aTmp, aTmpAlb, aGet, oTotal ) );
			COLOR 	CLR_GET ;
			PICTURE 	cPicUnd ;
         OF       oFld:aDialogs[1] ;
         IDSAY    141

      REDEFINE GET aGet[ _NUNICAJA ] VAR aTmp[ _NUNICAJA ];
			ID 		150 ;
			SPINNER ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         VALID    ( lCalcDeta( aTmp, aTmpAlb, aGet, oTotal ) );
         ON CHANGE( lCalcDeta( aTmp, aTmpAlb, aGet, oTotal ) );
			COLOR 	CLR_GET ;
			PICTURE 	cPicUnd ;
         OF       oFld:aDialogs[1] ;
         IDSAY    151

      REDEFINE GET aGet[ _CUNIDAD ] VAR aTmp[ _CUNIDAD ] ;
         ID       152 ;
         IDTEXT   153 ;
         BITMAP   "LUPA" ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( oUndMedicion:Existe( aGet[ _CUNIDAD ], aGet[ _CUNIDAD ]:oHelpText, "cNombre" ), ValidaMedicion( aTmp, aGet) );
         ON HELP  ( oUndMedicion:Buscar( aGet[ _CUNIDAD ] ), ValidaMedicion( aTmp, aGet ) ) ;
         OF       oFld:aDialogs[1]

      // Campos de las descripciones de la unidad de medición

      REDEFINE GET aGet[ ( dbfAlbPrvL )->( fieldpos( "nMedUno" ) ) ] ;
         VAR      aTmp[ ( dbfAlbPrvL )->( fieldpos( "nMedUno" ) ) ] ;
         ID       420 ;
         IDSAY    421 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ON CHANGE( lCalcDeta( aTmp, aTmpAlb, aGet, oTotal ) );
         PICTURE  MasUnd() ;
         OF       oFld:aDialogs[1]

      aGet[ ( dbfAlbPrvL )->( fieldpos( "nMedUno" ) ) ]:oSay:SetColor( CLR_BLUE )

      REDEFINE GET aGet[ ( dbfAlbPrvL )->( fieldpos( "nMedDos" ) ) ] ;
         VAR      aTmp[ ( dbfAlbPrvL )->( fieldpos( "nMedDos" ) ) ] ;
         ID       430 ;
         IDSAY    431 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ON CHANGE( lCalcDeta( aTmp, aTmpAlb, aGet, oTotal ) );
         PICTURE  MasUnd() ;
         OF       oFld:aDialogs[1]

      aGet[ ( dbfAlbPrvL )->( fieldpos( "nMedDos" ) ) ]:oSay:SetColor( CLR_BLUE )

      REDEFINE GET aGet[ ( dbfAlbPrvL )->( fieldpos( "nMedTre" ) ) ] ;
         VAR      aTmp[ ( dbfAlbPrvL )->( fieldpos( "nMedTre" ) ) ] ;
         ID       440 ;
         IDSAY    441 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ON CHANGE( lCalcDeta( aTmp, aTmpAlb, aGet, oTotal ) );
         PICTURE  MasUnd() ;
         OF       oFld:aDialogs[1]

      aGet[ ( dbfAlbPrvL )->( fieldpos( "nMedTre" ) ) ]:oSay:SetColor( CLR_BLUE )

      REDEFINE GET aGet[ _NPREDIV ] VAR aTmp[ _NPREDIV ] ;
			ID 		160 ;
			SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( lCalcDeta( aTmp, aTmpAlb, aGet, oTotal ) );
         ON CHANGE( lCalcDeta( aTmp, aTmpAlb, aGet, oTotal ) );
			COLOR 	CLR_GET ;
			PICTURE 	cPinDiv ;
			OF 		oFld:aDialogs[1]

		REDEFINE GET aGet[_NDTOLIN] VAR aTmp[_NDTOLIN] ;
			ID 		180 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         VALID    ( lCalcDeta( aTmp, aTmpAlb, aGet, oTotal ) );
         ON CHANGE( lCalcDeta( aTmp, aTmpAlb, aGet, oTotal ) );
			SPINNER ;
         PICTURE  "@E 999.99" ;
			COLOR 	CLR_GET ;
			OF 		oFld:aDialogs[1]

      REDEFINE GET aGet[_NDTOPRM] VAR aTmp[_NDTOPRM] ;
         ID       250 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         VALID    ( lCalcDeta( aTmp, aTmpAlb, aGet, oTotal ) );
         ON CHANGE( lCalcDeta( aTmp, aTmpAlb, aGet, oTotal ) );
			SPINNER ;
			PICTURE	"@E 99.99" ;
			COLOR 	CLR_GET ;
			OF 		oFld:aDialogs[1]

      REDEFINE GET aGet[_NDTORAP] VAR aTmp[_NDTORAP] ;
         ID       260 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			SPINNER ;
			PICTURE	"@E 99.99" ;
			COLOR 	CLR_GET ;
			OF 		oFld:aDialogs[1]

      REDEFINE GET oGetStk VAR nGetStk ;
         ID       190 ;
         WHEN     .f. ;
			PICTURE 	cPicUnd ;
			OF 		oFld:aDialogs[1]

      REDEFINE GET aGet[ _CREFPRV ] VAR aTmp[ _CREFPRV ];
         ID       400 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

      /*
		REDEFINE SAY PROMPT "Cantidad Ped : " ;
			ID 		185 ;
			OF 		oFld:aDialogs[1]

      REDEFINE SAY VAR aTmp[_NCANPED] ;
			ID 		190 ;
			PICTURE 	cPicUnd ;
			OF 		oFld:aDialogs[1]
      */

      REDEFINE GET aGet[_CALMLIN] VAR aTmp[_CALMLIN]  ;
         ID       240 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         VALID    ( cNomUbica( aTmp, aGet, dbfAlm ), cAlmacen( aGet[_CALMLIN], dbfAlm, oSay2 ), oStock:lPutStockActual( aTmp[ _CREF ], aTmp[ _CALMLIN ], aTmp[ _CVALPR1 ], aTmp[ _CVALPR2 ], aTmp[ _CLOTE ], aTmp[ _LKITART ], aTmp[ _NCTLSTK ], oGetStk ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwAlmacen( Self, oSay2 ) ) ;
			COLOR 	CLR_GET ;
			OF 		oFld:aDialogs[1]

		REDEFINE GET oSay2 VAR cSay2 ;
			WHEN 		.F. ;
         ID       241 ;
			OF 		oFld:aDialogs[1]

      REDEFINE SAY aGet[_CCODUBI1] VAR aTmp[_CCODUBI1];
         ID       300 ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[_CVALUBI1] VAR aTmp[_CVALUBI1] ;
         ID       270 ;
         BITMAP   "LUPA" ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ON HELP  ( BrwUbiLin( aGet[_CVALUBI1], aGet[_CNOMUBI1], aTmp[_CCODUBI1], dbfUbicaL ) ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[_CNOMUBI1] VAR aTmp[_CNOMUBI1];
         WHEN     .F. ;
         ID       271 ;
         OF       oFld:aDialogs[1]

      REDEFINE SAY aGet[_CCODUBI2] VAR aTmp[_CCODUBI2];
         ID       310 ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[_CVALUBI2] VAR aTmp[_CVALUBI2] ;
         ID       280 ;
         BITMAP   "LUPA" ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ON HELP  ( BrwUbiLin( aGet[_CVALUBI2], aGet[_CNOMUBI2], aTmp[_CCODUBI2], dbfUbicaL ) ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[_CNOMUBI2] VAR aTmp[_CNOMUBI2];
         WHEN     .F. ;
         ID       281 ;
         OF       oFld:aDialogs[1]

      REDEFINE SAY aGet[_CCODUBI3] VAR aTmp[_CCODUBI3];
         ID       320 ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[_CVALUBI3] VAR aTmp[_CVALUBI3] ;
         ID       290 ;
         BITMAP   "LUPA" ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ON HELP  ( BrwUbiLin( aGet[_CVALUBI3], aGet[_CNOMUBI3], aTmp[_CCODUBI3], dbfUbicaL ) ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[_CNOMUBI3] VAR aTmp[_CNOMUBI3];
         WHEN     .F. ;
         ID       291 ;
         OF       oFld:aDialogs[1]

      REDEFINE GET oTotal VAR nTotal ;
			ID 		210 ;
			WHEN 		.F. ;
         PICTURE  cPirDiv ;
			OF 		oFld:aDialogs[1]

      REDEFINE GET oGetIra VAR cGetIra;
         ID       410 ;
         IDSAY    411 ;
         BITMAP   "Lupa" ;
         ON HELP  ( SearchProperty( oGetIra, oBrwPrp ) ) ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

      /*
      Segunda cajas de dialogo-------------------------------------------------
      */

      REDEFINE GET aGet[ _NIVALIN ] VAR aTmp[ _NIVALIN ] ;
			ID 		80 ;
			WHEN		.F. ;
			PICTURE 	"@E 999.99" ;
			OF 		oFld:aDialogs[2]

		REDEFINE CHECKBOX aGet[ _LIVALIN ] VAR aTmp[ _LIVALIN ] ;
         WHEN     .f. ;
			ID 		90 ;
			OF 		oFld:aDialogs[2]

      REDEFINE GET aGet[ _NPRECOM ] VAR aTmp[ _NPRECOM ] ;
         WHEN     .f. ;
         ID       230 ;
         PICTURE  cPinDiv ;
         OF       oFld:aDialogs[2]

      /*
      Tarifa1 ______________________________________________________________________________
      */

      REDEFINE CHECKBOX aGet[ _LBNFLIN1 ] ;
            VAR      aTmp[ _LBNFLIN1 ] ;
            ID       500 ;
            WHEN     ( nMode != ZOOM_MODE ) ;
            OF       oFld:aDialogs[ 2 ]

      REDEFINE GET   aGet[ _NBNFLIN1 ] ;
            VAR      aTmp[ _NBNFLIN1 ] ;
            ID       510 ;
            SPINNER ;
            ON CHANGE( ::lValid() ) ;
            WHEN     ( aTmp[ _LBNFLIN1 ] .AND. nMode != ZOOM_MODE ) ;
            VALID    ( lCalPre( oBeneficioSobre[ 1 ]:nAt <= 1, aTmp[ _NPRECOM ], aTmp[ _LBNFLIN1 ], aTmp[ _NBNFLIN1 ], aTmp[ _NIVA ], aGet[ _NPVPLIN1 ], aGet[ _NIVALIN1 ], nDinDiv ) ) ;
            PICTURE  "@E 999.99" ;
            OF       oFld:aDialogs[ 2 ]

      REDEFINE COMBOBOX oBeneficioSobre[ 1 ] VAR cBeneficioSobre[ 1 ] ;
            ITEMS    aBeneficioSobre ;
            ID       520 ;
            WHEN     ( nMode != ZOOM_MODE ) ;
            ON CHANGE( if( aTmp[ _LBNFLIN1 ], aGet[ _NBNFLIN1 ]:lValid(), aGet[ _NPVPLIN1 ]:lValid() ) );
            OF       oFld:aDialogs[ 2 ]

      REDEFINE GET   aGet[ _NPVPLIN1 ] ;
            VAR      aTmp[ _NPVPLIN1 ] ;
            ID       530 ;
            ON CHANGE( ::lValid() ) ;
            WHEN     ( !aTmp[ _LIVALIN ] .and. nMode != ZOOM_MODE ) ;
            VALID    ( CalBnfPts( oBeneficioSobre[ 1 ]:nAt <= 1, aTmp[ _LIVALIN ], aTmp[ _NPRECOM ], aTmp[ _NPVPLIN1 ], aGet[ _NBNFLIN1 ], aTmp[ _NIVA ], aGet[ _NIVALIN1 ], nDinDiv ) );
            PICTURE  cPinDiv ;
            OF       oFld:aDialogs[ 2 ]

      REDEFINE GET   aGet[ _NIVALIN1 ] ;
            VAR      aTmp[ _NIVALIN1 ] ;
            ID       540 ;
            ON CHANGE( ::lValid() ) ;
            WHEN     ( aTmp[ _LIVALIN ] .and. nMode != ZOOM_MODE ) ;
            VALID    ( CalBnfIva( oBeneficioSobre[ 1 ]:nAt <= 1, aTmp[ _LIVALIN ], aTmp[ _NPRECOM ], aTmp[ _NIVALIN1 ], aGet[ _NBNFLIN1 ], aTmp[ _NIVA ], aGet[ _NPVPLIN1 ], nDinDiv ) );
            PICTURE  cPinDiv ;
            OF       oFld:aDialogs[ 2 ]

      /*
      Tarifa 2______________________________________________________________________________
      */

      REDEFINE CHECKBOX aGet[ _LBNFLIN2 ] ;
            VAR      aTmp[ _LBNFLIN2 ] ;
            ID       IDOK ;
            WHEN     ( nMode != ZOOM_MODE ) ;
            OF       oFld:aDialogs[ 2 ]

      REDEFINE GET   aGet[ _NBNFLIN2 ] ;
            VAR      aTmp[ _NBNFLIN2 ] ;
            ID       560 ;
            SPINNER ;
            ON CHANGE( ::lValid() ) ;
            WHEN     ( aTmp[ _LBNFLIN2 ] .AND. nMode != ZOOM_MODE ) ;
            VALID    ( lCalPre( oBeneficioSobre[ 2 ]:nAt <= 1, aTmp[ _NPRECOM ], aTmp[ _LBNFLIN2 ], aTmp[ _NBNFLIN2 ], aTmp[ _NIVA ], aGet[ _NPVPLIN2 ], aGet[ _NIVALIN2 ], nDinDiv ) ) ;
            PICTURE  "@E 999.99" ;
            OF       oFld:aDialogs[ 2 ]

      REDEFINE COMBOBOX oBeneficioSobre[ 2 ] VAR cBeneficioSobre[ 2 ] ;
            ITEMS    aBeneficioSobre ;
            ID       570 ;
            WHEN     ( nMode != ZOOM_MODE ) ;
            ON CHANGE( if( aTmp[ _LBNFLIN2 ], aGet[ _NBNFLIN2 ]:lValid(), aGet[ _NPVPLIN2 ]:lValid() ) );
            OF       oFld:aDialogs[ 2 ]

      REDEFINE GET   aGet[ _NPVPLIN2 ] ;
            VAR      aTmp[ _NPVPLIN2 ] ;
            ID       580 ;
            ON CHANGE( ::lValid() ) ;
            WHEN     ( !aTmp[ _LIVALIN ] .and. nMode != ZOOM_MODE ) ;
            VALID    ( CalBnfPts( oBeneficioSobre[ 2 ]:nAt <= 1, aTmp[ _LIVALIN ], aTmp[ _NPRECOM ], aTmp[ _NPVPLIN2 ], aGet[ _NBNFLIN2 ], aTmp[ _NIVA ], aGet[ _NIVALIN2 ], nDinDiv ) );
            PICTURE  cPinDiv ;
            OF       oFld:aDialogs[ 2 ]

      REDEFINE GET   aGet[ _NIVALIN2 ] ;
            VAR      aTmp[ _NIVALIN2 ] ;
            ID       590 ;
            ON CHANGE( ::lValid() ) ;
            WHEN     ( aTmp[ _LIVALIN ] .and. nMode != ZOOM_MODE ) ;
            VALID    ( CalBnfIva( oBeneficioSobre[ 2 ]:nAt <= 1, aTmp[ _LIVALIN ], aTmp[ _NPRECOM ], aTmp[ _NIVALIN2 ], aGet[ _NBNFLIN2 ], aTmp[ _NIVA ], aGet[ _NPVPLIN2 ], nDinDiv ) );
            PICTURE  cPinDiv ;
            OF       oFld:aDialogs[ 2 ]

      /*
      Tarifa 3______________________________________________________________________________
      */

      REDEFINE CHECKBOX aGet[ _LBNFLIN3 ] ;
            VAR      aTmp[ _LBNFLIN3 ] ;
            ID       600 ;
            WHEN     ( nMode != ZOOM_MODE ) ;
            OF       oFld:aDialogs[ 2 ]

      REDEFINE GET   aGet[ _NBNFLIN3 ] ;
            VAR      aTmp[ _NBNFLIN3 ] ;
            ID       610 ;
            SPINNER ;
            ON CHANGE( ::lValid() ) ;
            WHEN     ( aTmp[ _LBNFLIN3 ] .AND. nMode != ZOOM_MODE ) ;
            VALID    ( lCalPre( oBeneficioSobre[ 3 ]:nAt <= 1, aTmp[ _NPRECOM ], aTmp[ _LBNFLIN3 ], aTmp[ _NBNFLIN3 ], aTmp[ _NIVA ], aGet[ _NPVPLIN3 ], aGet[ _NIVALIN3 ], nDinDiv ) ) ;
            PICTURE  "@E 999.99" ;
            OF       oFld:aDialogs[ 2 ]

      REDEFINE COMBOBOX oBeneficioSobre[ 3 ] VAR cBeneficioSobre[ 3 ] ;
            ITEMS    aBeneficioSobre ;
            ID       620 ;
            WHEN     ( nMode != ZOOM_MODE ) ;
            ON CHANGE( if( aTmp[ _LBNFLIN3 ], aGet[ _NBNFLIN3 ]:lValid(), aGet[ _NPVPLIN3 ]:lValid() ) );
            OF       oFld:aDialogs[ 2 ]

      REDEFINE GET   aGet[ _NPVPLIN3 ] ;
            VAR      aTmp[ _NPVPLIN3 ] ;
            ID       630 ;
            ON CHANGE( ::lValid() ) ;
            WHEN     ( !aTmp[ _LIVALIN ] .and. nMode != ZOOM_MODE ) ;
            VALID    ( CalBnfPts( oBeneficioSobre[ 3 ]:nAt <= 1, aTmp[ _LIVALIN ], aTmp[ _NPRECOM ], aTmp[ _NPVPLIN3 ], aGet[ _NBNFLIN3 ], aTmp[ _NIVA ], aGet[ _NIVALIN3 ], nDinDiv ) );
            PICTURE  cPinDiv ;
            OF       oFld:aDialogs[ 2 ]

      REDEFINE GET   aGet[ _NIVALIN3 ] ;
            VAR      aTmp[ _NIVALIN3 ] ;
            ID       640 ;
            ON CHANGE( ::lValid() ) ;
            WHEN     ( aTmp[ _LIVALIN ] .and. nMode != ZOOM_MODE ) ;
            VALID    ( CalBnfIva( oBeneficioSobre[ 3 ]:nAt <= 1, aTmp[ _LIVALIN ], aTmp[ _NPRECOM ], aTmp[ _NIVALIN3 ], aGet[ _NBNFLIN3 ], aTmp[ _NIVA ], aGet[ _NPVPLIN3 ], nDinDiv ) );
            PICTURE  cPinDiv ;
            OF       oFld:aDialogs[ 2 ]

      /*
      Tarifa 4______________________________________________________________________________
      */

      REDEFINE CHECKBOX aGet[ _LBNFLIN4 ] ;
            VAR      aTmp[ _LBNFLIN4 ] ;
            ID       650 ;
            WHEN     ( nMode != ZOOM_MODE ) ;
            OF       oFld:aDialogs[ 2 ]

      REDEFINE GET   aGet[ _NBNFLIN4 ] ;
            VAR      aTmp[ _NBNFLIN4 ] ;
            ID       660 ;
            SPINNER ;
            ON CHANGE( ::lValid() ) ;
            WHEN     ( aTmp[ _LBNFLIN4 ] .AND. nMode != ZOOM_MODE ) ;
            VALID    ( lCalPre( oBeneficioSobre[ 4 ]:nAt <= 1, aTmp[ _NPRECOM ], aTmp[ _LBNFLIN4 ], aTmp[ _NBNFLIN4 ], aTmp[ _NIVA ], aGet[ _NPVPLIN4 ], aGet[ _NIVALIN4 ], nDinDiv ) ) ;
            PICTURE  "@E 999.99" ;
            OF       oFld:aDialogs[ 2 ]

      REDEFINE COMBOBOX oBeneficioSobre[ 4 ] VAR cBeneficioSobre[ 4 ] ;
            ITEMS    aBeneficioSobre ;
            ID       670 ;
            WHEN     ( nMode != ZOOM_MODE ) ;
            ON CHANGE( if( aTmp[ _LBNFLIN4 ], aGet[ _NBNFLIN4 ]:lValid(), aGet[ _NPVPLIN4 ]:lValid() ) );
            OF       oFld:aDialogs[ 2 ]

      REDEFINE GET   aGet[ _NPVPLIN4 ] ;
            VAR      aTmp[ _NPVPLIN4 ] ;
            ID       680 ;
            ON CHANGE( ::lValid() ) ;
            WHEN     ( !aTmp[ _LIVALIN ] .and. nMode != ZOOM_MODE ) ;
            VALID    ( CalBnfPts( oBeneficioSobre[ 4 ]:nAt <= 1, aTmp[ _LIVALIN ], aTmp[ _NPRECOM ], aTmp[ _NPVPLIN4 ], aGet[ _NBNFLIN4 ], aTmp[ _NIVA ], aGet[ _NIVALIN4 ], nDinDiv ) );
            PICTURE  cPinDiv ;
            OF       oFld:aDialogs[ 2 ]

      REDEFINE GET   aGet[ _NIVALIN4 ] ;
            VAR      aTmp[ _NIVALIN4 ] ;
            ID       690 ;
            ON CHANGE( ::lValid() ) ;
            WHEN     ( aTmp[ _LIVALIN ] .and. nMode != ZOOM_MODE ) ;
            VALID    ( CalBnfIva( oBeneficioSobre[ 4 ]:nAt <= 1, aTmp[ _LIVALIN ], aTmp[ _NPRECOM ], aTmp[ _NIVALIN4 ], aGet[ _NBNFLIN4 ], aTmp[ _NIVA ], aGet[ _NPVPLIN4 ], nDinDiv ) );
            PICTURE  cPinDiv ;
            OF       oFld:aDialogs[ 2 ]

      /*
      Tarifa 5______________________________________________________________________________
      */

      REDEFINE CHECKBOX aGet[ _LBNFLIN5 ] ;
            VAR      aTmp[ _LBNFLIN5 ] ;
            ID       700 ;
            WHEN     ( nMode != ZOOM_MODE ) ;
            OF       oFld:aDialogs[ 2 ]

      REDEFINE GET   aGet[ _NBNFLIN5 ] ;
            VAR      aTmp[ _NBNFLIN5 ] ;
            ID       710 ;
            SPINNER ;
            ON CHANGE( ::lValid() ) ;
            WHEN     ( aTmp[ _LBNFLIN5 ] .AND. nMode != ZOOM_MODE ) ;
            VALID    ( lCalPre( oBeneficioSobre[ 5 ]:nAt <= 1, aTmp[ _NPRECOM ], aTmp[ _LBNFLIN5 ], aTmp[ _NBNFLIN5 ], aTmp[ _NIVA ], aGet[ _NPVPLIN5 ], aGet[ _NIVALIN5 ], nDinDiv ) ) ;
            PICTURE  "@E 999.99" ;
            OF       oFld:aDialogs[ 2 ]

      REDEFINE COMBOBOX oBeneficioSobre[ 5 ] VAR cBeneficioSobre[ 5 ] ;
            ITEMS    aBeneficioSobre ;
            ID       720 ;
            WHEN     ( nMode != ZOOM_MODE ) ;
            ON CHANGE( if( aTmp[ _LBNFLIN5 ], aGet[ _NBNFLIN5 ]:lValid(), aGet[ _NPVPLIN5 ]:lValid() ) );
            OF       oFld:aDialogs[ 2 ]

      REDEFINE GET   aGet[ _NPVPLIN5 ] ;
            VAR      aTmp[ _NPVPLIN5 ] ;
            ID       730 ;
            ON CHANGE( ::lValid() ) ;
            WHEN     ( !aTmp[ _LIVALIN ] .and. nMode != ZOOM_MODE ) ;
            VALID    ( CalBnfPts( oBeneficioSobre[ 5 ]:nAt <= 1, aTmp[ _LIVALIN ], aTmp[ _NPRECOM ], aTmp[ _NPVPLIN5 ], aGet[ _NBNFLIN5 ], aTmp[ _NIVA ], aGet[ _NIVALIN5 ], nDinDiv ) );
            PICTURE  cPinDiv ;
            OF       oFld:aDialogs[ 2 ]

      REDEFINE GET   aGet[ _NIVALIN5 ] ;
            VAR      aTmp[ _NIVALIN5 ] ;
            ID       740 ;
            ON CHANGE( ::lValid() ) ;
            WHEN     ( aTmp[ _LIVALIN ] .and. nMode != ZOOM_MODE ) ;
            VALID    ( CalBnfIva( oBeneficioSobre[ 5 ]:nAt <= 1, aTmp[ _LIVALIN ], aTmp[ _NPRECOM ], aTmp[ _NIVALIN5 ], aGet[ _NBNFLIN5 ], aTmp[ _NIVA ], aGet[ _NPVPLIN5 ], nDinDiv ) );
            PICTURE  cPinDiv ;
            OF       oFld:aDialogs[ 2 ]

      /*
      Tarifa 6______________________________________________________________________________
      */

      REDEFINE CHECKBOX aGet[ _LBNFLIN6 ] ;
            VAR      aTmp[ _LBNFLIN6 ] ;
            ID       750 ;
            WHEN     ( nMode != ZOOM_MODE ) ;
            OF       oFld:aDialogs[ 2 ]

      REDEFINE GET   aGet[ _NBNFLIN6 ] ;
            VAR      aTmp[ _NBNFLIN6 ] ;
            ID       760 ;
            SPINNER ;
            ON CHANGE( ::lValid() ) ;
            WHEN     ( aTmp[ _LBNFLIN6 ] .AND. nMode != ZOOM_MODE ) ;
            VALID    ( lCalPre( oBeneficioSobre[ 6 ]:nAt <= 1, aTmp[ _NPRECOM ], aTmp[ _LBNFLIN6 ], aTmp[ _NBNFLIN6 ], aTmp[ _NIVA ], aGet[ _NPVPLIN6 ], aGet[ _NIVALIN6 ], nDinDiv ) ) ;
            PICTURE  "@E 999.99" ;
            OF       oFld:aDialogs[ 2 ]

      REDEFINE COMBOBOX oBeneficioSobre[ 6 ] VAR cBeneficioSobre[ 6 ] ;
            ITEMS    aBeneficioSobre ;
            ID       770 ;
            WHEN     ( nMode != ZOOM_MODE ) ;
            ON CHANGE( if( aTmp[ _LBNFLIN6 ], aGet[ _NBNFLIN6 ]:lValid(), aGet[ _NPVPLIN6 ]:lValid() ) );
            OF       oFld:aDialogs[ 2 ]

      REDEFINE GET   aGet[ _NPVPLIN6 ] ;
            VAR      aTmp[ _NPVPLIN6 ] ;
            ID       780 ;
            ON CHANGE( ::lValid() ) ;
            WHEN     ( !aTmp[ _LIVALIN ] .and. nMode != ZOOM_MODE ) ;
            VALID    ( CalBnfPts( oBeneficioSobre[ 6 ]:nAt <= 1, aTmp[ _LIVALIN ], aTmp[ _NPRECOM ], aTmp[ _NPVPLIN6 ], aGet[ _NBNFLIN6 ], aTmp[ _NIVA ], aGet[ _NIVALIN6 ], nDinDiv ) );
            PICTURE  cPinDiv ;
            OF       oFld:aDialogs[ 2 ]

      REDEFINE GET   aGet[ _NIVALIN6 ] ;
            VAR      aTmp[ _NIVALIN6 ] ;
            ID       790 ;
            ON CHANGE( ::lValid() ) ;
            WHEN     ( aTmp[ _LIVALIN ] .and. nMode != ZOOM_MODE ) ;
            VALID    ( CalBnfIva( oBeneficioSobre[ 6 ]:nAt <= 1, aTmp[ _LIVALIN ], aTmp[ _NPRECOM ], aTmp[ _NIVALIN6 ], aGet[ _NBNFLIN6 ], aTmp[ _NIVA ], aGet[ _NPVPLIN6 ], nDinDiv ) );
            PICTURE  cPinDiv ;
            OF       oFld:aDialogs[ 2 ]

      /*
      Control de stock
      -------------------------------------------------------------------------
      */

      REDEFINE RADIO aGet[ _NCTLSTK ] ;
         VAR      aTmp[ _NCTLSTK ] ;
         ID       350, 351, 352 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[ 2 ]

      REDEFINE CHECKBOX aGet[ _LCHGLIN ] VAR aTmp[ _LCHGLIN ];
         ID       420 ;
         WHEN     ( nMode != ZOOM_MODE .and. lActCos() );
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ _MOBSLIN ] VAR aTmp[ _MOBSLIN ] ;
         MEMO ;
         ID       100 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[3]

      REDEFINE BUTTON oBtn ;
         ID       IDOK ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( SaveDeta( aTmp, aGet, oDlg, oFld, oBrw, nMode, oTotal, oGet1, aTmpAlb, oSayPr1, oSayPr2, oSayVp1, oSayVp2, oBrwPrp, oGetIra, oBmp, oSayLote, oGetStk, oBtn ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
         CANCEL ;
         ACTION   ( oDlg:end() )

      REDEFINE BUTTON ;
         ID       9 ;
			OF 		oDlg ;
         ACTION   ( GoHelp() )

      REDEFINE BUTTON oBtnNumerosSerie ;
         ID       552 ;
			OF 		oDlg ;
         ACTION   ( EditarNumerosSerie( aTmp, nMode ) )

      if nMode != ZOOM_MODE
         oDlg:AddFastKey( VK_F6, {|| oBtnNumerosSerie:Click() } )
         oDlg:AddFastKey( VK_F5, {|| oBtn:SetFocus(), oBtn:Click() } )
      end if

      oDlg:AddFastKey ( VK_F1, {|| GoHelp() } )

      oDlg:bStart := {|| SetDlgMode( aGet, aTmp, aTmpAlb, nMode, oSayPr1, oSayPr2, oSayVp1, oSayVp2, oBrwPrp, oGetIra, oBmp, oDlg, oSayLote, oTotal ),;
                         if( !Empty( cCodArt ), aGet[ _CREF ]:lValid(), ),;
                         aGet[ _CUNIDAD ]:lValid() }

   ACTIVATE DIALOG oDlg ;
      ON INIT     ( EdtDetMenu( aGet[ _CREF ], oDlg ) );
      CENTER

   EndDetMenu()

RETURN ( oDlg:nResult == IDOK )

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

static Function cNomUbicaT( aTmp, aGet, dbfAlm )

   if !Empty( aTmp[_CCODALM] )

      aTmp[_CCODUBIT1]      := cGetUbica( aTmp[_CCODALM], dbfAlm, 1 )
      aTmp[_CCODUBIT2]      := cGetUbica( aTmp[_CCODALM], dbfAlm, 2 )
      aTmp[_CCODUBIT3]      := cGetUbica( aTmp[_CCODALM], dbfAlm, 3 )

      if Empty( aTmp[_CCODUBIT1] )
         aGet[_CCODUBIT1]:Hide()
         aGet[_CVALUBIT1]:Hide()
         aGet[_CNOMUBIT1]:Hide()
      else
         aGet[_CCODUBIT1]:Show()
         aGet[_CVALUBIT1]:Show()
         aGet[_CNOMUBIT1]:Show()
      end if

      if Empty( aTmp[_CCODUBIT2] )
         aGet[_CCODUBIT2]:Hide()
         aGet[_CVALUBIT2]:Hide()
         aGet[_CNOMUBIT2]:Hide()
      else
         aGet[_CCODUBIT2]:Show()
         aGet[_CVALUBIT2]:Show()
         aGet[_CNOMUBIT2]:Show()
      end if

      if Empty( aTmp[_CCODUBIT3] )
         aGet[_CCODUBIT3]:Hide()
         aGet[_CVALUBIT3]:Hide()
         aGet[_CNOMUBIT3]:Hide()
      else
         aGet[_CCODUBIT3]:Show()
         aGet[_CVALUBIT3]:Show()
         aGet[_CNOMUBIT3]:Show()
      end if

   else

      aGet[_CCODUBIT1]:Hide()
      aGet[_CVALUBIT1]:Hide()
      aGet[_CNOMUBIT1]:Hide()
      aGet[_CCODUBIT2]:Hide()
      aGet[_CVALUBIT2]:Hide()
      aGet[_CNOMUBIT2]:Hide()
      aGet[_CCODUBIT3]:Hide()
      aGet[_CVALUBIT3]:Hide()
      aGet[_CNOMUBIT3]:Hide()

   end if

   aGet[_CCODUBIT1]:Refresh()
   aGet[_CVALUBIT1]:Refresh()
   aGet[_CNOMUBIT1]:Refresh()
   aGet[_CCODUBIT2]:Refresh()
   aGet[_CVALUBIT2]:Refresh()
   aGet[_CNOMUBIT3]:Refresh()
   aGet[_CCODUBIT3]:Refresh()
   aGet[_CVALUBIT3]:Refresh()
   aGet[_CNOMUBIT3]:Refresh()

return .t.

//---------------------------------------------------------------------------//

Static Function SetDlgMode( aGet, aTmp, aTmpAlb, nMode, oSayPr1, oSayPr2, oSayVp1, oSayVp2, oBrwPrp, oGetIra, oBmp, oDlg, oSayLote, oTotal )

   local cCodArt     := aGet[ _CREF ]:varGet()

   if !lUseCaj()
      aGet[ _NCANENT ]:Hide()
   else
      aGet[ _NCANENT ]:SetText( cNombreCajas() )
   end if

   aGet[ _NUNICAJA ]:SetText( cNombreUnidades() )

   if Empty( aTmp[_CALMLIN ] )
      aTmp[ _CALMLIN ]  := aTmpAlb[ _CCODALM ]
   end if

   oBrwPrp:Hide()
   oGetIra:Hide()

   oSayPr1:SetText( "" )
   oSayVp1:SetText( "" )

   oSayPr2:SetText( "" )
   oSayVp2:SetText( "" )

   do case
   case nMode == APPD_MODE

      aGet[ _CREF    ]:show()
      aGet[ _CDETALLE]:show()
      aGet[ _MLNGDES ]:Hide()
      aGet[ _CLOTE   ]:Hide()
      aGet[ _DFECCAD ]:Hide()
      aGet[ _NCANENT ]:cText( 1 )
      aGet[ _NUNICAJA]:cText( 1 )
      aGet[ _CALMLIN ]:cText( aTmpAlb[ _CCODALM ] )

      aGet[ _NIVA    ]:cText( nIva( dbfIva, cDefIva() ) )
      aGet[ _NIVALIN ]:cText( nIva( dbfIva, cDefIva() ) )

      aTmp[ _NREQ    ]  := nReq( dbfIva, cDefIva() )
      aTmp[ _NNUMLIN ]  := nLastNum( dbfTmp )

      oSayLote:Hide()

   case nMode != APPD_MODE .AND. empty( cCodArt )

      aGet[ _CREF    ]:Hide()
      aGet[ _CDETALLE]:Hide()
      aGet[ _MLNGDES ]:show()
      aGet[ _CLOTE   ]:Hide()
      aGet[ _DFECCAD ]:Hide()

      oSayLote:Hide()

   case nMode != APPD_MODE .AND. !empty( cCodArt )

      aGet[ _CREF    ]:show()
      aGet[ _CDETALLE]:show()
      aGet[ _MLNGDES ]:Hide()

      if aTmp[ _LLOTE   ]
         aGet[ _CLOTE   ]:Show()
         aGet[ _DFECCAD ]:Show()
         oSayLote:Show()
      else
         aGet[ _CLOTE   ]:Hide()
         aGet[ _DFECCAD ]:Hide()
         oSayLote:Hide()
      end if

   end case

   lCalcDeta( aTmp, aTmpAlb, aGet, oTotal )

   IF !empty( aTmp[ _CCODPR1 ] )
      aGet[ _CVALPR1 ]:Show()
      aGet[ _CVALPR1 ]:lValid()
      oSayPr1:Show()
      oSayPr1:SetText( retProp( aTmp[_CCODPR1], dbfPro ) )
      oSayVp1:Show()
   ELSE
      aGet[ _CVALPR1 ]:Hide()
      oSayPr1:Hide()
      oSayVp1:Hide()
   END IF

   IF !empty( aTmp[ _CCODPR2 ] )
      aGet[ _CVALPR2 ]:Show()
      aGet[ _CVALPR2 ]:lValid()
      oSayPr2:Show()
      oSayPr2:SetText( retProp( aTmp[ _CCODPR2 ], dbfPro ) )
      oSayVp2:Show()
   ELSE
      aGet[ _CVALPR2 ]:Hide()
      oSayPr2:Hide()
      oSayVp2:Hide()
   END IF

   //Ocultamos las tres unidades de medicion

   aGet[ ( dbfAlbPrvL )->( fieldpos( "nMedUno" ) ) ]:Hide()
   aGet[ ( dbfAlbPrvL )->( fieldpos( "nMedDos" ) ) ]:Hide()
   aGet[ ( dbfAlbPrvL )->( fieldpos( "nMedTre" ) ) ]:Hide()

   if oUndMedicion:oDbf:Seek( aTmp[ _CUNIDAD ] )

      if oUndMedicion:oDbf:nDimension >= 1 .and. !Empty( oUndMedicion:oDbf:cTextoDim1 )
         aGet[ ( dbfAlbPrvL )->( fieldpos( "nMedUno" ) ) ]:oSay:SetText( oUndMedicion:oDbf:cTextoDim1 )
         aGet[ ( dbfAlbPrvL )->( fieldpos( "nMedUno" ) ) ]:Show()
      end if

      if oUndMedicion:oDbf:nDimension >= 2 .and. !Empty( oUndMedicion:oDbf:cTextoDim2 )
         aGet[ ( dbfAlbPrvL )->( fieldpos( "nMedDos" ) ) ]:oSay:SetText( oUndMedicion:oDbf:cTextoDim2 )
         aGet[ ( dbfAlbPrvL )->( fieldpos( "nMedDos" ) ) ]:Show()
      end if

      if oUndMedicion:oDbf:nDimension >= 3 .and. !Empty( oUndMedicion:oDbf:cTextoDim3 )
         aGet[ ( dbfAlbPrvL )->( fieldpos( "nMedTre" ) ) ]:oSay:SetText( oUndMedicion:oDbf:cTextoDim3 )
         aGet[ ( dbfAlbPrvL )->( fieldpos( "nMedTre" ) ) ]:Show()
      end if

   end if

   aGet[ _CALMLIN  ]:lValid()
   aGet[ _CREF     ]:SetFocus()

   /*
   IF oDlg != nil
      aRect := GetWndRect( oDlg:hWnd )
      oDlg:Move( aRect[1], aRect[2], 520, oDlg:nHeight, .t. )
   END IF
   */

RETURN .t.

//--------------------------------------------------------------------------//

STATIC FUNCTION SaveDeta( aTmp, aGet, oDlg, oFld, oBrw, nMode, oTotal, oGet, aTmpAlb, oSayPr1, oSayPr2, oSayVp1, oSayVp2, oBrwPrp, oGetIra, oBmp, oSayLote, oGetStk, oBtn, oBtnSer )

   local n, i

   if !lMoreIva( aTmp[ _NIVA ] )
      Return nil
   end if

   if Empty( aTmp[ _CALMLIN ] )
      MsgStop( "Código de almacen no puede estar vacio" )
      aGet[ _CALMLIN ]:SetFocus()
      Return nil
   end if

   if !cAlmacen( aGet[ _CALMLIN ], dbfAlm )
      MsgStop( "Código de almacen no encontrado" )
      Return nil
   end if

   /*
   Comprobamos si tiene que introducir números de serie------------------------
   */

   if ( nMode == APPD_MODE ) .and. ( aTmp[ _LNUMSER ] )

      if ( aTmp[ _LAUTSER ] )

         AutoNumerosSerie( aTmp, nMode )

      elseif !( dbfTmpSer )->( dbSeek( Str( aTmp[ _NNUMLIN ], 4 ) + aTmp[ _CREF ] ) )

         msgStop( "Tiene que introducir números de serie para este artículo." )

         EditarNumerosSerie( aTmp, nMode )

         Return .f.

      end if

   end if

   /*
   Cambio de la moneda---------------------------------------------------------
   */

   if aTmp[ _LLOTE ] .AND. nMode == APPD_MODE
      GraLotArt( aTmp[ _CREF ], dbfArticulo, aTmp[ _CLOTE ] )
   end if

   if nMode == APPD_MODE

      if !Empty( oBrwPrp:Cargo )

         for n := 1 to len( oBrwPrp:Cargo )

            for i := 1 to len( oBrwPrp:Cargo[ n ] )

               if IsNum( oBrwPrp:Cargo[ n, i ]:Value ) .and. oBrwPrp:Cargo[ n, i ]:Value != 0

                  aTmp[ _NUNICAJA]  := oBrwPrp:Cargo[ n, i ]:Value
                  aTmp[ _CCODPR1 ]  := oBrwPrp:Cargo[ n, i ]:cCodigoPropiedad1
                  aTmp[ _CVALPR1 ]  := oBrwPrp:Cargo[ n, i ]:cValorPropiedad1
                  aTmp[ _CCODPR2 ]  := oBrwPrp:Cargo[ n, i ]:cCodigoPropiedad2
                  aTmp[ _CVALPR2 ]  := oBrwPrp:Cargo[ n, i ]:cValorPropiedad2
                  aTmp[ _NPREDIV ]  := oBrwPrp:Cargo[ n, i ]:nPrecioCompra

                  WinGather( aTmp, aGet, dbfTmp, oBrw, nMode, nil, .f. )

               end if

            next

         next

         aCopy( dbBlankRec( dbfTmp ), aTmp )

         aEval( aGet, {| o, i | if( "GET" $ o:ClassName(), o:cText( aTmp[ i ] ), ) } )

      else

         WinGather( aTmp, aGet, dbfTmp, oBrw, nMode )

      end if

      if lEntCon()

         SetDlgMode( aGet, aTmp, aTmpalb, nMode, oSayPr1, oSayPr2, oSayVp1, oSayVp2, oBrwPrp, oGetIra, oBmp, oDlg, oSayLote, oTotal )

         nTotAlbPrv( nil, dbfAlbPrvT, dbfTmp, dbfIva, dbfDiv, aTmpAlb )

      else

         oDlg:End( IDOK )

      end if

   else

      WinGather( aTmp, aGet, dbfTmp, oBrw, nMode )

      oDlg:end( IDOK )

   end if

   cOldCodArt        := ""
   cOldPrpArt        := ""
   cOldUndMed        := ""

   if !Empty( aGet[ _CUNIDAD ] )
      aGet[ _CUNIDAD ]:lValid()
   end if

   if !Empty( oBrwPrp )
      oBrwPrp:Cargo  := nil
   end if

   if oGet != nil
      oGet:cText( Space( 18 ) )
      oGet:SetFocus()
   end if

   if oGetStk != nil
      oGetStk:cText( 0 )
   end if

RETURN NIL

//---------------------------------------------------------------------------//

Static Function EdtInc( aTmp, aGet, dbfAlbPrvI, oBrw, bWhen, bValid, nMode, aTmpAlb )

   local oDlg
   local oNomInci
   local cNomInci

   if !Empty( aTmp[ ( dbfTmpInc )->( FieldPos( "cCodTip" ) ) ] )
      cNomInci          := cNomInci( aTmp[ ( dbfTmpInc )->( FieldPos( "cCodTip" ) ) ], dbfInci )
   end if

   if nMode == APPD_MODE
      aTmp[ _CSERALB  ] := aTmpAlb[ _CSERALB ]
      aTmp[ _NNUMALB  ] := aTmpAlb[ _NNUMALB ]
      aTmp[ _CSUFALB  ] := aTmpAlb[ _CSUFALB ]
      if IsMuebles()
         aTmp[ ( dbfTmpInc )->( FieldPos( "lAviso" ) ) ]  := .t.
      end if
   end if

   DEFINE DIALOG oDlg RESOURCE "INCIDENCIA" TITLE LblTitle( nMode ) + "incidencias de albaranes a proveedores"

      REDEFINE GET aGet[ ( dbfTmpInc )->( FieldPos( "cCodTip" ) ) ];
         VAR      aTmp[ ( dbfTmpInc )->( FieldPos( "cCodTip" ) ) ];
         ID       120 ;
         WHEN     ( nMode != ZOOM_MODE );
         VALID    ( cTipInci( aGet[ ( dbfTmpInc )->( FieldPos( "cCodTip" ) ) ], dbfInci, oNomInci ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwIncidencia( dbfInci, aGet[ ( dbfTmpInc )->( FieldPos( "cCodTip" ) ) ], oNomInci ) ) ;
         OF       oDlg

      REDEFINE GET oNomInci VAR cNomInci;
         WHEN     .f. ;
         ID       130 ;
         OF       oDlg

      REDEFINE GET aTmp[ ( dbfTmpInc )->( FieldPos( "dFecInc" ) ) ] ;
         ID       100 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
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

      REDEFINE CHECKBOX aTmp[ ( dbfTmpInc )->( FieldPos( "lAviso" ) ) ] ;
         ID       150 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         OF       oDlg

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

Static Function EdtDoc( aTmp, aGet, dbfPedPrvD, oBrw, bWhen, bValid, nMode, aTmpLin )

   local oDlg
   local oRuta
   local oNombre
   local oObservacion

   DEFINE DIALOG oDlg RESOURCE "DOCUMENTOS" TITLE LblTitle( nMode ) + "documento de albarán a proveedor"

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

STATIC FUNCTION PrnSerie( oBrw )

	local oDlg
   local oFmtDoc
   local cFmtDoc     := cFormatoDocumento( ( dbfAlbPrvT )->cSerAlb, "nAlbPrv", dbfCount )
   local oSayFmt
   local cSayFmt
   local oSerIni
   local oSerFin
   local nRecno      := ( dbfAlbPrvT )->( Recno() )
   local nOrdAnt     := ( dbfAlbPrvT )->( OrdSetFocus( 1 ) )
   local cSerIni     := ( dbfAlbPrvT )->cSerAlb
   local cSerFin     := ( dbfAlbPrvT )->cSerAlb
   local nDocIni     := ( dbfAlbPrvT )->nNumAlb
   local nDocFin     := ( dbfAlbPrvT )->nNumAlb
   local cSufIni     := ( dbfAlbPrvT )->CSUFALB
   local cSufFin     := ( dbfAlbPrvT )->CSUFALB
   local oPrinter
   local cPrinter    := PrnGetName()
   local lCopiasPre  := .t.
   local lInvOrden   := .f.
   local oNumCop
   local nNumCop     := if( nCopiasDocumento( ( dbfAlbPrvT )->cSerAlb, "nAlbPrv", dbfCount ) == 0, Max( Retfld( ( dbfAlbPrvT )->cCodPrv, dbfPrv, "nCopiasF" ), 1 ), nCopiasDocumento( ( dbfAlbPrvT )->cSerAlb, "nAlbPrv", dbfCount ) )

   if Empty( cFmtDoc )
      cFmtDoc        := cSelPrimerDoc( "AP" )
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
      VALID    ( If ( !( dbfAlbPrvT )->( dbSeek( cSerIni + Str( nDocIni, 9 ) + cSufIni ) ),;
							( msgStop( "Documento no valido" ), .F. ),;
							( .T. ) ) );
		COLOR 	CLR_GET ;
		OF 		oDlg

   REDEFINE GET nDocFin;
      ID       130 ;
		PICTURE 	"999999999" ;
      SPINNER ;
      VALID    ( If ( !( dbfAlbPrvT )->( dbSeek( cSerFin  + Str( nDocFin, 9 ) + cSufFin ) ),;
						( msgStop( "Documento no valido" ), .F. ),;
						( .T. ) ) );
		COLOR 	CLR_GET ;
		OF 		oDlg

   REDEFINE GET cSufIni ;
      ID       140 ;
      PICTURE  "##" ;
      VALID    ( If ( !( dbfAlbPrvT )->( dbSeek( cSerIni  + Str( nDocIni, 9 ) + cSufIni ) ),;
							( msgStop( "Documento no valido" ), .F. ),;
							( .T. ) ) );
		COLOR 	CLR_GET ;
		OF 		oDlg

   REDEFINE GET cSufFin ;
      ID       150 ;
      PICTURE  "##" ;
		OF 		oDlg

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
      ON HELP  ( BrwDocumento( oFmtDoc, oSayFmt, "AP" ) ) ;
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
		ACTION 	( oDlg:end() )

   oDlg:AddFastKey( VK_F5, {|| StartPrint( SubStr( cFmtDoc, 1, 3 ), cSerIni + Str( nDocIni, 9 ) + cSufIni, cSerFin + Str( nDocFin, 9 ) + cSufFin, oDlg, cPrinter, lCopiasPre, nNumCop, lInvOrden ), oDlg:end( IDOK ) } )

   oDlg:bStart := { || oSerIni:SetFocus() }

   ACTIVATE DIALOG oDlg CENTER

   ( dbfAlbPrvT )->( ordSetFocus( nOrdAnt ) )
   ( dbfAlbPrvT )->( dbGoTo( nRecNo ) )

	oBrw:refresh()

RETURN NIL

//--------------------------------------------------------------------------//

STATIC FUNCTION StartPrint( cFmtDoc, cDocIni, cDocFin, oDlg, cPrinter, lCopiasPre, nNumCop, lInvOrden )

local nCopyProvee

   oDlg:disable()

   if !lInvOrden

      ( dbfAlbPrvT )->( dbSeek( cDocIni, .t. ) )

      while ( dbfAlbPrvT )->cSerAlb + Str( ( dbfAlbPrvT )->nNumAlb ) + ( dbfAlbPrvT )->cSufAlb >= cDocIni .AND. ;
            ( dbfAlbPrvT )->cSerAlb + Str( ( dbfAlbPrvT )->nNumAlb ) + ( dbfAlbPrvT )->cSufAlb <= cDocFin

            lChgImpDoc( dbfAlbPrvT )

         if lCopiasPre

            nCopyProvee := if( nCopiasDocumento( ( dbfAlbPrvT )->cSerAlb, "nAlbPrv", dbfCount ) == 0, Max( Retfld( ( dbfAlbPrvT )->cCodPrv, dbfPrv, "nCopiasF" ), 1 ), nCopiasDocumento( ( dbfAlbPrvT )->cSerAlb, "nAlbPrv", dbfCount ) )

            GenAlbPrv( IS_PRINTER, "Imprimiendo documento : " + ( dbfAlbPrvT )->cSerAlb + Str( ( dbfAlbPrvT )->nNumAlb ) + ( dbfAlbPrvT )->cSufAlb, cFmtDoc, cPrinter, nCopyProvee )

         else

            GenAlbPrv( IS_PRINTER, "Imprimiendo documento : " + ( dbfAlbPrvT )->cSerAlb + Str( ( dbfAlbPrvT )->nNumAlb ) + ( dbfAlbPrvT )->cSufAlb, cFmtDoc, cPrinter, nNumCop )

         end if

      ( dbfAlbPrvT )->( dbSkip() )

      end while

   else

      ( dbfAlbPrvT )->( dbSeek( cDocFin ) )

      while ( dbfAlbPrvT )->cSerAlb + Str( ( dbfAlbPrvT )->nNumAlb ) + ( dbfAlbPrvT )->cSufAlb >= cDocIni .and.;
            ( dbfAlbPrvT )->cSerAlb + Str( ( dbfAlbPrvT )->nNumAlb ) + ( dbfAlbPrvT )->cSufAlb <= cDocFin .and.;
            !( dbfAlbPrvT )->( Bof() )

            lChgImpDoc( dbfAlbPrvT )

         if lCopiasPre

            nCopyProvee := if( nCopiasDocumento( ( dbfAlbPrvT )->cSerAlb, "nAlbPrv", dbfCount ) == 0, Max( Retfld( ( dbfAlbPrvT )->cCodPrv, dbfPrv, "nCopiasF" ), 1 ), nCopiasDocumento( ( dbfAlbPrvT )->cSerAlb, "nAlbPrv", dbfCount ) )

            GenAlbPrv( IS_PRINTER, "Imprimiendo documento : " + ( dbfAlbPrvT )->cSerAlb + Str( ( dbfAlbPrvT )->nNumAlb ) + ( dbfAlbPrvT )->cSufAlb, cFmtDoc, cPrinter, nCopyProvee )

         else

            GenAlbPrv( IS_PRINTER, "Imprimiendo documento : " + ( dbfAlbPrvT )->cSerAlb + Str( ( dbfAlbPrvT )->nNumAlb ) + ( dbfAlbPrvT )->cSufAlb, cFmtDoc, cPrinter, nNumCop )

         end if

      ( dbfAlbPrvT )->( dbSkip( -1 ) )

      end while

   end if

   oDlg:enable()

RETURN NIL

//--------------------------------------------------------------------------//

FUNCTION GenAlbPrv( nDevice, cCaption, cCodDoc, cPrinter, nCopies )

   local oDevice
   local nAlbaran

   if ( dbfAlbPrvT )->( Lastrec() ) == 0
      Return nil
   end if

   nAlbaran             := ( dbfAlbPrvT )->cSerAlb + Str( ( dbfAlbPrvT )->nNumAlb ) + ( dbfAlbPrvT )->CSUFALB

   DEFAULT nDevice      := IS_PRINTER
   DEFAULT cCaption     := "Imprimiendo albarán"
   DEFAULT cCodDoc      := cFormatoDocumento( ( dbfAlbPrvT )->cSerAlb, "nAlbPrv", dbfCount )
   DEFAULT nCopies      := if( nCopiasDocumento( ( dbfAlbPrvT )->cSerAlb, "nAlbPrv", dbfCount ) == 0, Max( Retfld( ( dbfAlbPrvT )->cCodPrv, dbfPrv, "nCopiasF" ), 1 ), nCopiasDocumento( ( dbfAlbPrvT )->cSerAlb, "nAlbPrv", dbfCount ) )

   if Empty( cCodDoc )
      cCodDoc           := cFirstDoc( "AP", dbfDoc )
   end if

   if !lExisteDocumento( cCodDoc, dbfDoc )
      return nil
   end if

   /*
   Si el documento es de tipo visual-------------------------------------------
   */

   if lVisualDocumento( cCodDoc, dbfDoc )

      PrintReportAlbPrv( nDevice, nCopies, cPrinter, dbfDoc )

   else

      if !lExisteDocumento( cCodDoc, dbfDoc )
         return nil
      end if

      /*
      Posicionamos las tablas auxiliares
      */

      ( dbfAlbPrvL)->( dbSeek( nAlbaran ) )
      ( dbfPrv    )->( dbSeek( ( dbfAlbPrvT )->cCodPrv ) )
      ( dbfDiv    )->( dbSeek( ( dbfAlbPrvT )->cDivAlb ) )
      ( dbfFPago  )->( dbSeek( ( dbfAlbPrvT )->cCodPgo ) )
      ( dbfAlm    )->( dbSeek( ( dbfAlbPrvT )->cCodAlm ) )

      private cDbf         := dbfAlbPrvT
      private cDbfCol      := dbfAlbPrvL
      private cDbfPrv      := dbfPrv
      private cDbfPgo      := dbfFPago
      private cDbfIva      := dbfIva
      private cDbfDiv      := dbfDiv
      private cDbfAlm      := dbfAlm
      private cDbfArt      := dbfArticulo
      private cDbfKit      := dbfKit
      private cDbfPro      := dbfPro
      private cDbfTblPro   := dbfTblPro
      private cPicUndAlb   := cPicUnd
      private cPinDivAlb   := cPinDiv
      private cPirDivAlb   := cPirDiv
      private nDinDivAlb   := nDinDiv
      private nDirDivAlb   := nDirDiv
      private nVdvDivAlb   := ( dbfAlbPrvT )->nVdvAlb

      if !Empty( cPrinter )
         oDevice           := TPrinter():New( cCaption, .f., .t., cPrinter )
         REPORT oInf CAPTION cCaption TO DEVICE oDevice
      else
         REPORT oInf CAPTION cCaption PREVIEW
      end if

      if !Empty( oInf ) .and. oInf:lCreated
         oInf:lAutoLand          := .f.
         oInf:lFinish            := .f.
         oInf:lNoCancel          := .t.
         oInf:bSkip              := {|| AlbPrvReportSkipper( dbfAlbPrvL ) }

         oInf:oDevice:lPrvModal  := .t.

         do case
            case nDevice == IS_PRINTER
               oInf:bPreview     := {| oDevice | PrintPreview( oDevice ) }

            case nDevice == IS_PDF
               oInf:bPreview     := {| oDevice | PrintPdf( oDevice ) }

         end if

         SetMargin(  cCodDoc, oInf )
         PrintColum( cCodDoc, oInf )

      end if

      END REPORT

      ACTIVATE REPORT      oInf ;
         WHILE             ( ( dbfAlbPrvT )->cSerAlb + Str( ( dbfAlbPrvL )->nNumAlb ) + ( dbfAlbPrvL )->CSUFALB == nAlbaran );
         FOR               ( !( dbfAlbPrvL )->lImpLin ) ;
         ON ENDPAGE        EPage( oInf, cCodDoc )

      if nDevice == IS_PRINTER
         oInf:oDevice:end()
      end if

      oInf                 := nil

   end if

   lChgImpDoc( dbfAlbPrvT )

RETURN NIL

//---------------------------------------------------------------------------//

Static Function AlbPrvReportSkipper( dbfAlbPrvL )

   ( dbfAlbPrvL )->( dbSkip() )

Return nil

//---------------------------------------------------------------------------//

static function nGenAlbPrv( nDevice, cTitle, cCodDoc, cPrinter, nCopy )

   local nImpYet     := 1
   local nCopyClient := Retfld( ( dbfAlbPrvT )->cCodPrv, dbfPrv, "nCopiasF" )

   DEFAULT nDevice   := IS_PRINTER
   DEFAULT nCopy     := Max( nCopyClient, nCopiasDocumento( ( dbfAlbPrvT )->cSerAlb, "nAlbPrv", dbfCount ) )

   nCopy             := Max( nCopy, 1 )

   while nImpYet <= nCopy
      GenAlbPrv( nDevice, cTitle, cCodDoc, cPrinter )
      nImpYet++
   end while

   //Funcion para marcar el documento como imprimido
   lChgImpDoc( dbfAlbPrvT )

return nil

//--------------------------------------------------------------------------//

STATIC FUNCTION EPage( oInf, cCodDoc )

   private nPagina      := oInf:nPage
	private lEnd			:= oInf:lFinish

   PrintItems( cCodDoc, oInf )

RETURN NIL

//--------------------------------------------------------------------------//
/*
Total de unidades en un albaran
*/

static function nTotalUnd( nAlbaran, dbfAlbPrvL, cPicUnd )

   local nTotUnd  := 0

   if ( dbfAlbPrvL )->( dbSeek( nAlbaran ) )
      while  ( dbfAlbPrvL )->cSerAlb + Str( ( dbfAlbPrvL )->nNumAlb ) + ( dbfAlbPrvL )->CSUFALB == nAlbaran .and. ( dbfAlbPrvL )->( !eof() )
         nTotUnd  += nTotNAlbPrv( dbfAlbPrvL )
         ( dbfAlbPrvL )->( dbSkip() )
      end do
   end if

RETURN ( Trans( nTotUnd, cPicUnd ) )

//--------------------------------------------------------------------------//

/*
Calcula el Total del albaran
*/

FUNCTION nTotAlbPrv( nAlbaran, cAlbPrvT, cAlbPrvL, cIva, cDiv, aTmp, cDivRet, lPic )

	local bCondition
   local nTotArt
	local dFecFac
	local lRecargo
	local nDtoEsp
	local nDtoPP
   local nDtoUno
	local nDtoDos
   local nPorte
	local nRecno
	local cCodDiv
	local cPinDiv
	local nDinDiv
   local nRegIva
	local aTotalDto	:= { 0, 0, 0 }
	local aTotalDPP	:= { 0, 0, 0 }
   local aTotalUno   := { 0, 0, 0 }
  	local aTotalDos   := { 0, 0, 0 }
   local nTotUno
   local nTotDos

   DEFAULT cAlbPrvT  := dbfAlbPrvT
   DEFAULT cAlbPrvL  := dbfAlbPrvL
   DEFAULT cIva      := cIva
   DEFAULT cDiv      := cDiv
   DEFAULT nAlbaran  := ( cAlbPrvT )->cSerAlb + Str( ( cAlbPrvT )->nNumAlb ) + ( cAlbPrvT )->cSufAlb
   DEFAULT lPic      := .f.

   public nTotAlb    := 0
   public nTotBrt    := 0
   public nTotDto    := 0
   public nTotDPP    := 0
   public nTotNet    := 0
   public nTotIva    := 0
   public nTotReq    := 0
   public nTotImp    := 0
   public aTotIva    := { { 0,0,nil,0,0,0 }, { 0,0,nil,0,0,0 }, { 0,0,nil,0,0,0 } }
   public aIvaUno    := aTotIva[ 1 ]
   public aIvaDos    := aTotIva[ 2 ]
   public aIvaTre    := aTotIva[ 3 ]
   public aImpVto    := {}
   public aDatVto    := {}

   nRecno            := ( cAlbPrvL )->( Recno() )

	IF aTmp != NIL
		dFecFac			:= aTmp[ _DFECALB ]
		lRecargo			:= aTmp[ _LRECARGO]
		nDtoEsp			:= aTmp[ _NDTOESP ]
		nDtoPP			:= aTmp[ _NDPP    ]
      nDtoUno        := aTmp[ _NDTOUNO ]
      nDtoDos        := aTmp[ _NDTODOS ]
      nPorte         := aTmp[ _NPORTES ]
		cCodDiv			:= aTmp[ _CDIVALB ]
      nRegIva        := aTmp[ _NREGIVA ]
      bCondition     := {|| !( cAlbPrvL )->( Eof() ) }
      (cAlbPrvL)->( dbGoTop() )
	ELSE
      dFecFac        := ( cAlbPrvT )->dFecAlb
      lRecargo       := ( cAlbPrvT )->lRecargo
      nDtoEsp        := ( cAlbPrvT )->nDtoEsp
      nDtoPP         := ( cAlbPrvT )->nDpp
      nDtoUno        := ( cAlbPrvT )->nDtoUno
      nDtoDos        := ( cAlbPrvT )->nDtoDos
      nPorte         := ( cAlbPrvT )->nPortes
      cCodDiv        := ( cAlbPrvT )->cDivAlb
      nRegIva        := ( cAlbPrvT )->nRegIva
      bCondition     := {|| ( cAlbPrvL )->cSerAlb + Str( ( cAlbPrvL )->nNumAlb ) + ( cAlbPrvL )->cSufAlb == nAlbaran .AND. (cAlbPrvL)->( !eof() ) }
      ( cAlbPrvL )->( dbSeek( nAlbaran ) )
	END IF

   cPinDiv           := cPinDiv( cCodDiv, cDiv )
   cPirDiv           := cPirDiv( cCodDiv, cDiv )
   nDinDiv           := nDinDiv( cCodDiv, cDiv )
   nDirDiv           := nRinDiv( cCodDiv, cDiv )

   while Eval( bCondition )

      if lValLine( cAlbPrvL )

         nTotArt     := nTotLAlbPrv( cAlbPrvL, nDinDiv, nDirDiv )
         if nTotArt != 0

            /*
            Estudio de IGIC
            */

            do case
            case _NPCTIVA1 == nil .OR. _NPCTIVA1 == ( cAlbPrvL )->nIva
               _NPCTIVA1   := ( cAlbPrvL )->nIva
               _NPCTREQ1   := ( cAlbPrvL )->nReq
               _NBRTIVA1   += nTotArt

            case _NPCTIVA2 == nil .OR. _NPCTIVA2 == ( cAlbPrvL )->nIva
               _NPCTIVA2   := ( cAlbPrvL )->nIva
               _NPCTREQ2   := ( cAlbPrvL )->nReq
               _NBRTIVA2   += nTotArt

            case _NPCTIVA3 == nil .OR. _NPCTIVA3 == ( cAlbPrvL )->nIva
               _NPCTIVA3   := ( cAlbPrvL )->nIva
               _NPCTREQ3   := ( cAlbPrvL )->nReq
               _NBRTIVA3   += nTotArt
            end case

         end if

      end if

      ( cAlbPrvL )->( dbSkip() )

   end while

   ( cAlbPrvL )->( dbGoTo( nRecno) )

	/*
   Ordenamos los IGICS de menor a mayor
	*/

   nTotBrt           := _NBRTIVA1 + _NBRTIVA2 + _NBRTIVA3

	/*
	Portes de la Factura
	*/

   nTotBrt           += nPorte

   _NBASIVA1         := _NBRTIVA1
   _NBASIVA2         := _NBRTIVA2
   _NBASIVA3         := _NBRTIVA3

	/*
	Descuentos de la Facturas
	*/

   if nDtoEsp != 0
		aTotalDto[1]	:= Round( _NBASIVA1 * nDtoEsp / 100, nDinDiv )
		aTotalDto[2]	:= Round( _NBASIVA2 * nDtoEsp / 100, nDinDiv )
		aTotalDto[3]	:= Round( _NBASIVA3 * nDtoEsp / 100, nDinDiv )

      nTotDto        := aTotalDto[1] + aTotalDto[2] + aTotalDto[3]

		_NBASIVA1		-= aTotalDto[1]
		_NBASIVA2		-= aTotalDto[2]
		_NBASIVA3		-= aTotalDto[3]
   end if

   if nDtoPP != 0
		aTotalDPP[1]	:= Round( _NBASIVA1 * nDtoPP / 100, nDinDiv )
		aTotalDPP[2]	:= Round( _NBASIVA2 * nDtoPP / 100, nDinDiv )
		aTotalDPP[3]	:= Round( _NBASIVA3 * nDtoPP / 100, nDinDiv )

      nTotDPP        := aTotalDPP[1] + aTotalDPP[2] + aTotalDPP[3]

		_NBASIVA1		-= aTotalDPP[1]
		_NBASIVA2		-= aTotalDPP[2]
		_NBASIVA3		-= aTotalDPP[3]
   end if

   if nDtoUno != 0
      aTotalUno[1]   := Round( _NBASIVA1 * nDtoUno / 100, nDirDiv )
      aTotalUno[2]   := Round( _NBASIVA2 * nDtoUno / 100, nDirDiv )
      aTotalUno[3]   := Round( _NBASIVA3 * nDtoUno / 100, nDirDiv )

      nTotUno        := aTotalUno[1] + aTotalUno[2] + aTotalUno[3]

		_NBASIVA1		-= aTotalUno[1]
		_NBASIVA2		-= aTotalUno[2]
		_NBASIVA3		-= aTotalUno[3]
   end if

   if nDtoDos != 0
      aTotalDos[1]   := Round( _NBASIVA1 * nDtoDos / 100, nDirDiv )
      aTotalDos[2]   := Round( _NBASIVA2 * nDtoDos / 100, nDirDiv )
      aTotalDos[3]   := Round( _NBASIVA3 * nDtoDos / 100, nDirDiv )

      nTotDos        := aTotalDos[1] + aTotalDos[2] + aTotalDos[3]

		_NBASIVA1		-= aTotalDos[1]
		_NBASIVA2		-= aTotalDos[2]
		_NBASIVA3		-= aTotalDos[3]
   end if

   nTotNet           := _NBASIVA1 + _NBASIVA2   + _NBASIVA3

	/*
   Calculos de IGIC
	*/

   if nRegIva <= 1

      _NIMPIVA1      := if( _NPCTIVA1 != NIL, Round( _NBASIVA1 * _NPCTIVA1 / 100, nDirDiv ), 0 )
      _NIMPIVA2      := if( _NPCTIVA2 != NIL, Round( _NBASIVA2 * _NPCTIVA2 / 100, nDirDiv ), 0 )
      _NIMPIVA3      := if( _NPCTIVA3 != NIL, Round( _NBASIVA3 * _NPCTIVA3 / 100, nDirDiv ), 0 )

      /*
      Calculo de recargo
      */

      if lRecargo
         _NIMPREQ1   := if( _NPCTIVA1 != NIL, Round( _NBASIVA1 * _NPCTREQ1 / 100, nDirDiv ), 0 )
         _NIMPREQ2   := if( _NPCTIVA2 != NIL, Round( _NBASIVA2 * _NPCTREQ2 / 100, nDirDiv ), 0 )
         _NIMPREQ3   := if( _NPCTIVA3 != NIL, Round( _NBASIVA3 * _NPCTREQ3 / 100, nDirDiv ), 0 )
      end if

   end if

   /*
   Total IGIC
   */

   nTotIva           := Round( _NIMPIVA1 + _NIMPIVA2 + _NIMPIVA3, nDirDiv )

	/*
   Total de R.E.
	*/

   nTotReq           := Round( _NIMPREQ1 + _NIMPREQ2 + _NIMPREQ3, nDirDiv )

	/*
	Total de impuestos
	*/

   nTotImp        := nTotIva + nTotReq

	/*
	Total facturas
	*/

   nTotAlb        := nTotNet + nTotImp

   aTotIva        := aSort( aTotIva,,, {|x,y| abs( x[1] ) > abs( y[1] ) } )

   /*
   Solicitan una divisa distinta a la q se hizo originalmente la factura-------
   */

   if cDivRet != nil .and. cDivRet != cCodDiv
      nTotNet     := nCnv2Div( nTotNet, cCodDiv, cDivRet, cDiv )
      nTotIva     := nCnv2Div( nTotIva, cCodDiv, cDivRet, cDiv )
      nTotReq     := nCnv2Div( nTotReq, cCodDiv, cDivRet, cDiv )
      nTotAlb     := nCnv2Div( nTotAlb, cCodDiv, cDivRet, cDiv )
      cPirDiv     := cPirDiv( cDivRet, cDiv )
   end if

RETURN ( if( lPic, Trans( nTotAlb, cPirDiv ), nTotAlb ) )

//---------------------------------------------------------------------------//

Static Function RecalculaTotal( aTmp )

   nTotAlbPrv( nil, dbfAlbPrvT, dbfTmp, dbfIva, dbfDiv, aTmp )

   oBrwIva:Refresh()

   oGetNet:SetText( Trans( nTotNet, cPirDiv ) )

   oGetIva:SetText( Trans( nTotIva, cPirDiv ) )

   oGetReq:SetText( Trans( nTotReq, cPirDiv ) )

   oGetTot:SetText( Trans( nTotAlb, cPirDiv ) )

Return .t.

//--------------------------------------------------------------------------//


FUNCTION aTotAlbPrv( cAlbaran, dbfAlbPrvT, dbfAlbPrvL, dbfIva, dbfDiv, cDivRet )

   nTotAlbPrv( cAlbaran, dbfAlbPrvT, dbfAlbPrvL, dbfIva, dbfDiv, nil, cDivRet, .f. )

RETURN ( { nTotNet, nTotIva, nTotReq, nTotAlb, aTotIva } )

//--------------------------------------------------------------------------//

Static Function GetArtPrv( cRefPrv, cCodPrv, aGet )

   local nOrdAnt  := ( dbfArtPrv )->( ordSetFocus( "cRefPrv" ) )

   if Empty( cRefPrv )

      return .t.

   else

      if ( dbfArtPrv )->( dbSeek( cCodPrv + cRefPrv ) )

         aGet[ _CREF ]:cText( ( dbfArtPrv )->cCodArt )
			aGet[ _CREF ]:lValid()

      else

         msgStop( "Referencia de proveedor no encontrada" )

      end if

		( dbfArtPrv )->( ordSetFocus( nOrdAnt ) )

   end if

Return .t.

//----------------------------------------------------------------------------//

Static Function LoaArt( aGet, aTmp, aTmpAlb, oFld, oSayPr1, oSayPr2, oSayVp1, oSayVp2, oBmp, oBrwPrp, oGetIra, oDlg, oSayLote, oGetStk, oBeneficioSobre, oTotal, nMode )

   local nIva
   local nOrdAnt
   local cCodFam
   local nPreCos
   local cCodPrv
   local cCodArt
   local cPrpArt
   local nPreCom
   local lChgCodArt
   local lSeek       := .f.

   nIva              := 0
   nPreCom           := 0
   cCodPrv           := aTmpAlb[ _CCODPRV ]
   cCodArt           := aGet[ _CREF    ]:varGet()
   cPrpArt           := aTmp[ _CCODPR1 ] + aTmp[ _CCODPR2 ] + aTmp[ _CVALPR1 ] + aTmp[ _CVALPR2 ]
   lChgCodArt        := ( Rtrim( cOldCodArt ) != Rtrim( cCodArt ) .or. Rtrim( cOldPrpArt ) != Rtrim( cPrpArt ) )

   if Empty( cCodArt )

      if lRetCodArt()
         MsgStop( "No se pueden añadir lineas sin codificar" )
         return .f.
      end if

      aGet[ _NIVA    ]:bWhen  := {|| .t. }

      aGet[ _CDETALLE]:Hide()

      aGet[ _MLNGDES ]:Show()
      aGet[ _MLNGDES ]:SetFocus()

      if !Empty( oBrwPrp )
         oBrwPrp:Hide()
      end if

   else

      if lModIva()
         aGet[ _NIVA ]:bWhen  := {|| .t. }
      else
         aGet[ _NIVA ]:bWhen  := {|| .f. }
      end if

      aGet[ _CREF     ]:show()
      aGet[ _CDETALLE ]:show()
      aGet[ _MLNGDES  ]:Hide()

/*
      if !( ( dbfArticulo )->( dbSeek( cCodArt ) ) .or. ( dbfArticulo )->( dbSeek( Upper( cCodArt ) ) ) )

         // Busqueda por codigo de proveedor-----------------------------------------

         nOrdAnt                 := ( dbfArtPrv )->( OrdSetFocus( "cRefPrv" ) )

         if ( dbfArtPrv )->( dbSeek( cCodPrv + cCodArt ) )

            cCodArt              := ( dbfArtPrv )->cCodArt

         end if

         ( dbfArtPrv )->( ordSetFocus( nOrdAnt ) )

         // Primero buscamos por codigos de barra------------------------------------

         cCodArt                 := cSeekCodebar( cCodArt, dbfCodebar, dbfArticulo )

         // Ahora buscamos por el codigo interno-------------------------------------

         lSeek                   := ( dbfArticulo )->( dbSeek( cCodArt ) ) .or. ( dbfArticulo )->( dbSeek( Upper( cCodArt ) ) )

      else

         lSeek                   := .t.

      end if
*/

      if lIntelliArtciculoSearch( cCodArt, cCodPrv, dbfArticulo, dbfArtPrv, dbfCodebar )

         if ( lChgCodArt )

            EliminarNumeroSerie( aTmp )

            if ( dbfArticulo )->lObs
               MsgStop( "Artículo catalogado como obsoleto" )
               return .f.
            end if

            oFld:aEnable      := { .t., .t., .t. }
            oFld:Refresh()

            /*
            Preguntamos si el regimen de IGIC es distinto de Exento-------------
            */

            nIva              := nIva( dbfIva, ( dbfArticulo )->TipoIva )

            aGet[ _NIVA    ]:cText( nIva )
            aGet[ _NIVALIN ]:cText( nIva )
            aGet[ _LIVALIN ]:Click( ( dbfArticulo )->lIvaInc ):Refresh()

            aTmp[ _NREQ    ]  := nReq( dbfIva, ( dbfArticulo )->TipoIva )

            aGet[ _CREF    ]:cText( ( dbfArticulo )->Codigo )
            aGet[ _CDETALLE]:cText( ( dbfArticulo )->Nombre )

            if ( dbfArticulo )->lMosCom .and. !Empty( ( dbfArticulo )->mComent )
               MsgStop( Trim( ( dbfArticulo )->mComent ) )
            end if

            if ( dbfArticulo )->nCajEnt != 0
               aGet[ _NCANENT ]:cText( ( dbfArticulo )->nCajEnt )
            end if

            if ( dbfArticulo )->nUniCaja != 0
               aGet[ _NUNICAJA ]:cText( ( dbfArticulo )->nUniCaja )
            end if

            /*
            Lotes
            ---------------------------------------------------------------------
            */

            aTmp[ _LLOTE ]       := ( dbfArticulo )->lLote

            if ( dbfArticulo )->lLote
               oSayLote:Show()
               aGet[ _CLOTE   ]:Show()
               aGet[ _CLOTE   ]:cText( ( dbfArticulo )->cLote )
               aGet[ _DFECCAD ]:Show()
               aGet[ _DFECCAD ]:cText( dFechaCaducidad( aTmpAlb[ _DFECALB ], ( dbfArticulo )->nDuracion, ( dbfArticulo )->nTipDur ) )
            else
               oSayLote:Hide()
               aGet[ _CLOTE   ]:Hide()
               aGet[ _DFECCAD ]:Hide()
            end if

            /*
            Series
            -------------------------------------------------------------------
            */

            aTmp[ _LNUMSER ]     := ( dbfArticulo )->lNumSer
            aTmp[ _LAUTSER ]     := ( dbfArticulo )->lAutSer

            /*
            Tomamos el valor de las familias y los grupos de familias----------
            */

            cCodFam              := ( dbfArticulo )->Familia
            if !Empty( cCodFam )
               aTmp[ _CCODFAM ]  := cCodFam
               aTmp[ _CGRPFAM ]  := cGruFam( cCodFam, dbfFamilia )
            end if

            /*
            Control de stocks--------------------------------------------------
            */

            aTmp[ _NCTLSTK ]     := ( dbfArticulo )->nCtlStock

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
            Referencia de proveedor-----------------------------------------------
            */

            nOrdAnt                 := ( dbfArtPrv )->( OrdSetFocus( "cCodPrv" ) )

            if ( dbfArtPrv )->( dbSeek( cCodPrv + cCodArt ) )

               if !Empty( aGet[ _CREFPRV ] )
                  aGet[ _CREFPRV ]:cText( ( dbfArtPrv )->cRefPrv )
               end if

            else

               if !Empty( aGet[ _CREFPRV ] )
                  aGet[ _CREFPRV ]:cText( Space( 20 ) )
               end if

            end if

            ( dbfArtPrv )->( ordSetFocus( nOrdAnt ) )

            /*
            Buscamos la familia del articulo y anotamos las propiedades-----------
            */

            aTmp[_CCODPR1 ]         := ( dbfArticulo )->cCodPrp1
            aTmp[_CCODPR2 ]         := ( dbfArticulo )->cCodPrp2

            if ( !Empty( aTmp[ _CCODPR1 ] ) .or. !Empty( aTmp[ _CCODPR2 ] ) ) .and. ;
               ( uFieldEmpresa( "lUseTbl" ) .and. ( nMode == APPD_MODE ) )

               nPreCom              := nCosto( nil, dbfArticulo, dbfKit, .f., aTmpAlb[ _CDIVALB ], dbfDiv )

               LoadPropertiesTable( cCodArt, nPreCom, aTmp[ _CCODPR1 ], aTmp[ _CCODPR2 ], dbfPro, dbfTblPro, dbfArtCom, oBrwPrp, aGet[ _NUNICAJA ], aGet[ _NPREDIV ]  )

               oGetIra:Show()

            else

               oBrwPrp:Hide()
               oGetIra:Hide()

               if !Empty( aTmp[ _CCODPR1 ] )

                  if aGet[ _CVALPR1 ] != nil
                     aGet[ _CVALPR1 ]:Show()
                     aGet[ _CVALPR1 ]:SetFocus()
                  end if

                  if oSayPr1 != nil
                     oSayPr1:SetText( retProp( ( dbfArticulo )->cCodPrp1, dbfPro ) )
                     oSayPr1:Show()
                  end if

                  if oSayVp1 != nil
                     oSayVp1:Show()
                  end if

               else

                  if aGet[ _CVALPR1 ] !=  nil
                     aGet[ _CVALPR1 ]:Hide()
                  end if

                  if oSayPr1 != nil
                     oSayPr1:Hide()
                  end if

                  if oSayVp1 != nil
                     oSayVp1:Hide()
                  end if

               end if

               if !Empty( aTmp[ _CCODPR2 ] )

                  if aGet[ _CVALPR2 ] != nil
                     aGet[ _CVALPR2 ]:Show()
                  end if

                  if oSayPr2 != nil
                     oSayPr2:SetText( retProp( ( dbfArticulo )->cCodPrp2, dbfPro ) )
                     oSayPr2:Show()
                  end if

                  if oSayVp2 != nil
                     oSayVp2:Show()
                  end if

               else

                  if aGet[ _CVALPR2 ] != nil
                     aGet[ _CVALPR2 ]:Hide()
                  end if

                  if oSayPr2 != nil
                     oSayPr2:Hide()
                  end if

                  if oSayVp2 != nil
                     oSayVp2:Hide()
                  end if

               end if

            end if

            /*
            Ponemos el stock---------------------------------------------------
            */

            if oGetStk != nil .and. aTmp[ _NCTLSTK ] <= 1
               oStock:nPutStockActual( cCodArt, aTmpAlb[ _CCODALM ], nil, nil, nil, aTmp[ _LKITART ], aTmp[ _NCTLSTK ], oGetStk )
            end if

            /*
            Cargamos el codigo de las unidades---------------------------------
            */

            if !Empty( aGet[ _CUNIDAD ] )
               aGet[ _CUNIDAD ]:cText( ( dbfArticulo )->cUnidad )
               aGet[ _CUNIDAD ]:lValid()
            else
               aTmp[ _CUNIDAD ]  := ( dbfArticulo )->cUnidad
            end if

            ValidaMedicion( aTmp, aGet )

         end if

         cPrpArt                 := aTmp[ _CCODPR1 ] + aTmp[ _CCODPR2 ] + aTmp[ _CVALPR1 ] + aTmp[ _CVALPR2 ]

         if ( lChgCodArt ) .or. ( cPrpArt != cOldPrpArt )

            nPreCom              := nComPro( aTmp[ _CREF ], aTmp[ _CCODPR1 ], aTmp[ _CVALPR1 ], aTmp[ _CCODPR2 ], aTmp[ _CVALPR2 ], dbfArtCom )

            if nPrecom  != 0

               aGet[ _NPREDIV ]:cText( nPreCom )

            else

               if uFieldEmpresa( "lCosPrv" )
                  nPreCom        := nPreArtPrv( cCodPrv, cCodArt, dbfArtPrv )
               end if

               if nPreCom != 0
                  aGet[ _NPREDIV ]:cText( nPreCom )
               else
                  aGet[ _NPREDIV ]:cText( nCosto( nil, dbfArticulo, dbfKit, .f., aTmpAlb[ _CDIVALB ], dbfDiv ) )
               end if

               /*
               Descuento de articulo----------------------------------------------
               */

               if uFieldEmpresa( "lCosPrv", .f. )

                  nPreCom           := nDtoArtPrv( cCodPrv, cCodArt, dbfArtPrv )

                  if nPreCom != 0
                     aGet[ _NDTOLIN ]:cText( nPreCom )
                  end if

               /*
               Descuento de promocional----------------------------------------------
               */

                  nPreCom           := nPrmArtPrv( cCodPrv, cCodArt, dbfArtPrv )

                  if nPreCom != 0
                     aGet[ _NDTOPRM ]:cText( nPreCom )
                  end if

               end if

            end if

            /*
            Precios de Venta---------------------------------------------------
            */

            if aGet[ _NPRECOM ] != nil
               aGet[ _NPRECOM ]:cText( nNetUAlbPrv( aTmp, aTmpAlb, nDinDiv, nDirDiv, aTmpAlb[ _NVDVALB ] ) )
            end if

            /*
            Ponemos el precio de venta recomendado-----------------------------
            */

            aTmp[ _NPVPREC ]        := nCnv2Div( ( dbfArticulo )->PvpRec, cDivEmp(), aTmpAlb[ _CDIVALB ], dbfDiv )

            /*
            Situacion posterior------------------------------------------------
            */

            aGet[ _NBNFLIN1 ]:cText( ( dbfArticulo )->Benef1 )
            aGet[ _NBNFLIN2 ]:cText( ( dbfArticulo )->Benef2 )
            aGet[ _NBNFLIN3 ]:cText( ( dbfArticulo )->Benef3 )
            aGet[ _NBNFLIN4 ]:cText( ( dbfArticulo )->Benef4 )
            aGet[ _NBNFLIN5 ]:cText( ( dbfArticulo )->Benef5 )
            aGet[ _NBNFLIN6 ]:cText( ( dbfArticulo )->Benef6 )

            aGet[ _LBNFLIN1 ]:Click( ( dbfArticulo )->lBnf1 ):Refresh()
            aGet[ _LBNFLIN2 ]:Click( ( dbfArticulo )->lBnf2 ):Refresh()
            aGet[ _LBNFLIN3 ]:Click( ( dbfArticulo )->lBnf3 ):Refresh()
            aGet[ _LBNFLIN4 ]:Click( ( dbfArticulo )->lBnf4 ):Refresh()
            aGet[ _LBNFLIN5 ]:Click( ( dbfArticulo )->lBnf5 ):Refresh()
            aGet[ _LBNFLIN6 ]:Click( ( dbfArticulo )->lBnf6 ):Refresh()

            aGet[ _NPVPLIN1 ]:cText( ( dbfarticulo )->pVenta1  )
            aGet[ _NPVPLIN2 ]:cText( ( dbfArticulo )->pVenta2  )
            aGet[ _NPVPLIN3 ]:cText( ( dbfArticulo )->pVenta3  )
            aGet[ _NPVPLIN4 ]:cText( ( dbfArticulo )->pVenta4  )
            aGet[ _NPVPLIN5 ]:cText( ( dbfArticulo )->pVenta5  )
            aGet[ _NPVPLIN6 ]:cText( ( dbfArticulo )->pVenta6  )

            aGet[ _NIVALIN1 ]:cText( ( dbfArticulo )->pVtaIva1 )
            aGet[ _NIVALIN2 ]:cText( ( dbfArticulo )->pVtaIva2 )
            aGet[ _NIVALIN3 ]:cText( ( dbfArticulo )->pVtaIva3 )
            aGet[ _NIVALIN4 ]:cText( ( dbfArticulo )->pVtaIva4 )
            aGet[ _NIVALIN5 ]:cText( ( dbfArticulo )->pVtaIva5 )
            aGet[ _NIVALIN6 ]:cText( ( dbfArticulo )->pVtaIva6 )

            oBeneficioSobre[ 1 ]:Select( Max( ( dbfArticulo )->nBnfSbr1, 1 ) )
            oBeneficioSobre[ 2 ]:Select( Max( ( dbfArticulo )->nBnfSbr2, 1 ) )
            oBeneficioSobre[ 3 ]:Select( Max( ( dbfArticulo )->nBnfSbr3, 1 ) )
            oBeneficioSobre[ 4 ]:Select( Max( ( dbfArticulo )->nBnfSbr4, 1 ) )
            oBeneficioSobre[ 5 ]:Select( Max( ( dbfArticulo )->nBnfSbr5, 1 ) )
            oBeneficioSobre[ 6 ]:Select( Max( ( dbfArticulo )->nBnfSbr6, 1 ) )

            /*
            Guardamos el precio de costo para posteriores comprobaciones
            */

            nPreCos  := nCnv2Div( ( dbfArticulo )->pCosto, cDivEmp(), aTmpAlb[ _CDIVALB ], dbfDiv )

            /*
            Imagen del producto

            if oDlg != nil .and. oBmp != nil

               aRect := GetWndRect( oDlg:hWnd )
               if file( Rtrim( (dbfArticulo)->cImagen ) )
                  oBmp:LoadBmp( Rtrim( (dbfArticulo)->cImagen ) )
                  oDlg:Move( aRect[1], aRect[2], 650, oDlg:nHeight, .t. )
               else
                  oDlg:Move( aRect[1], aRect[2], 520, oDlg:nHeight, .t. )
               end if

            end if
            */


         end if

         /*
         Recalculo de totales--------------------------------------------------
         */

         lCalcDeta( aTmp, aTmpAlb, aGet, oTotal )

      else

         msgStop( "Artículo no encontrado" )
         Return .f.

      end if

   end if

   cOldCodArt        := cCodArt
   cOldPrpArt        := cPrpArt

Return .t.

//----------------------------------------------------------------------------//

Static Function cPedPrv( aGet, aTmp, oBrw, nMode )

   local nDiv
   local cOldEst
   local cPedCli
   local nTotPed     := 0
   local nTotRec     := 0
   local nTotPdt     := 0
   local lValid      := .f.
   local cPedido     := aGet[ _CNUMPED ]:varGet()
   local nAlbaran    := aGet[ _NNUMALB ]:varGet()

   if ( nMode != APPD_MODE ) .or. Empty( cPedido )
      Return .t.
   end if

   if ( dbfPedPrvT )->( dbSeek( cPedido ) )

      if ( dbfPedPrvT )->nEstado == 3

         MsgStop( "Pedido recibido", "Opción cancelada" )
         lValid      := .f.

      else

         /*
         Guardamos el estado del pedido por si no se guarda el albaran
         */

         cOldEst  := ( dbfPedPrvT )->nEstado

         aGet[ _CNUMPED ]:cText( ( dbfPedPrvT )->cSerPed + Str( ( dbfPedPrvT )->nNumPed ) + ( dbfPedPrvT )->cSufPed )
         aGet[ _CNUMPED ]:bWhen := {|| .F. }

         aGet[ _CCODPRV ]:cText( ( dbfPedPrvT )->cCodPrv )
         aGet[ _CCODPRV ]:lValid()

         aGet[ _CCODCAJ ]:cText( ( dbfPedPrvT )->cCodCaj )
         aGet[ _CCODCAJ ]:lValid()

         aGet[ _CCODALM ]:cText( ( dbfPedPrvT )->cCodAlm )
         aGet[ _CCODALM ]:lValid()

         aGet[ _LRECARGO]:Click( ( dbfPedPrvT )->lRecargo )

         aGet[ _CCODPGO ]:cText( ( dbfPedPrvT )->cCodPgo )
         aGet[ _CCODPGO ]:lValid()

         aGet[ _CDTOESP ]:cText( ( dbfPedPrvT )->cDtoEsp )
         aGet[ _NDTOESP ]:cText( ( dbfPedPrvT )->nDtoEsp )

         aGet[ _CDPP    ]:cText( ( dbfPedPrvT )->cDpp )
         aGet[ _NDPP    ]:cText( ( dbfPedPrvT )->nDpp )

         aGet[ _CDTOUNO ]:cText( ( dbfPedPrvT )->cDtoUno )
         aGet[ _NDTOUNO ]:cText( ( dbfPedPrvT )->nDtoUno )

         aGet[ _CDTODOS ]:cText( ( dbfPedPrvT )->cDtoDos )
         aGet[ _NDTODOS ]:cText( ( dbfPedPrvT )->nDtoDos )

         aGet[ _NREGIVA ]:nOption( Max( ( dbfPrv )->nRegIva, 1 ) )
         aGet[ _NREGIVA ]:Refresh()

         aGet[ _COBSERV ]:cText( ( dbfPedPrvT )->cObserv )

         cPedCli           := ( dbfPedPrvT )->cNumPedCli

         /*
         Si lo encuentra-------------------------------------------------------
			*/

         if ( dbfPedPrvL )->( dbSeek( cPedido ) )

            while ( ( dbfPedPrvL )->cSerPed + Str( ( dbfPedPrvL )->nNumPed ) + ( dbfPedPrvL )->cSufPed == cPedido )

               /*
               Calculamos el total de unidades q se tienen q llevar------------
               */

               nTotPed                 := NotCaja( ( dbfPedPrvL )->nCanPed ) * ( dbfPedPrvL )->nUniCaja
               nTotRec                 := nUnidadesRecibidasPedPrv( ( dbfPedPrvL )->cSerPed + Str( ( dbfPedPrvL )->nNumPed ) + ( dbfPedPrvL )->cSufPed, ( dbfPedPrvL )->cRef, ( dbfPedPrvL )->cValPr1, ( dbfPedPrvL )->cValPr2, ( dbfPedPrvL )->cRefPrv, ( dbfPedPrvL )->cDetalle, dbfAlbPrvL )
               nTotPdt                 := nTotPed - nTotRec

               /*
               Vamos a ver si quedan unidades por recibir
               */

               if Abs( nTotPdt ) > 0

                  (dbfTmp)->( dbAppend() )

                  (dbfTmp)->nNumAlb    := nAlbaran
                  (dbfTmp)->cRef       := (dbfPedPrvL)->cRef
                  (dbfTmp)->nIva       := (dbfPedPrvL)->nIva
                  (dbfTmp)->nIvaLin    := (dbfPedPrvL)->nIva
                  (dbfTmp)->nReq       := (dbfPedPrvL)->nReq
                  (dbfTmp)->cDetalle   := (dbfPedPrvL)->cDetalle
                  (dbfTmp)->mLngDes    := (dbfPedPrvL)->mLngDes
                  (dbfTmp)->mNumSer    := (dbfPedPrvL)->mNumSer
                  (dbfTmp)->nPreDiv    := (dbfPedPrvL)->nPreDiv                              // Precios
                  (dbfTmp)->nPreCom    := (dbfPedPrvL)->nPreDiv                              // Precios
                  (dbfTmp)->nCanPed    := (dbfPedPrvL)->nCanPed                              // Cajas pedidas
                  (dbfTmp)->nUniPed    := (dbfPedPrvL)->nUniCaja                             // Unidades pedidas
                  (dbfTmp)->cCodPr1    := (dbfPedPrvL)->cCodPr1                              // Cod. prop. 1
                  (dbfTmp)->cCodPr2    := (dbfPedPrvL)->cCodPr2                              // Cod. prop. 2
                  (dbfTmp)->cValPr1    := (dbfPedPrvL)->cValPr1                              // Val. prop. 1
                  (dbfTmp)->cValPr2    := (dbfPedPrvL)->cValPr2                              // Val. prop. 2
                  (dbfTmp)->nFacCnv    := (dbfPedPrvL)->nFacCnv                              // Factor de conversion
                  (dbfTmp)->cAlmLin    := (dbfPedPrvL)->cAlmLin                              // Almacen en linea
                  (dbfTmp)->nCtlStk    := (dbfPedPrvL)->nCtlStk                              // Control de Stock
                  (dbfTmp)->nNumLin    := (dbfPedPrvL)->nNumLin
                  (dbfTmp)->nUndKit    := (dbfPedPrvL)->nUndKit
                  (dbfTmp)->lKitChl    := (dbfPedPrvL)->lKitChl
                  (dbfTmp)->lKitArt    := (dbfPedPrvL)->lKitArt
                  (dbfTmp)->lKitPrc    := (dbfPedPrvL)->lKitPrc
                  (dbfTmp)->nDtoLin    := (dbfPedPrvL)->nDtoLin
                  (dbfTmp)->nDtoPrm    := (dbfPedPrvL)->nDtoPrm
                  (dbfTmp)->nDtoRap    := (dbfPedPrvL)->nDtoRap
                  (dbfTmp)->lImpLin    := (dbfPedPrvL)->lImpLin
                  (dbfTmp)->lLote      := (dbfPedPrvL)->lLote
                  (dbfTmp)->nLote      := (dbfPedPrvL)->nLote
                  (dbfTmp)->cLote      := (dbfPedPrvL)->cLote
                  (dbfTmp)->mObsLin    := (dbfPedPrvL)->mObsLin
                  (dbfTmp)->cRefPrv    := (dbfPedPrvL)->cRefPrv
                  (dbfTmp)->cUnidad    := (dbfPedPrvL)->cUnidad
                  (dbfTmp)->nNumMed    := (dbfPedPrvL)->nNumMed
                  (dbfTmp)->nMedUno    := (dbfPedPrvL)->nMedUno
                  (dbfTmp)->nMedDos    := (dbfPedPrvL)->nMedDos
                  (dbfTmp)->nMedTre    := (dbfPedPrvL)->nMedTre
                  (dbfTmp)->cCodPed    := cPedido
                  (dbfTmp)->cNumPed    := cPedCli

                  /*
                  Comprobamos si hay calculos por cajas
                  */

                  if lCalCaj()

                     if nTotRec != 0

                        nDiv  := Mod( nTotPdt, ( dbfPedPrvL )->nUniCaja )
                        if nDiv == 0 .and. ( dbfPedPrvL )->nCanPed != 0
                           ( dbfTmp )->nCanEnt  := Div( nTotPdt, ( dbfPedPrvL )->nUniCaja )
                           ( dbfTmp )->nUniCaja := ( dbfPedPrvL )->nUniCaja
                        else
                           ( dbfTmp )->nCanEnt  := 0
                           ( dbfTmp )->nUniCaja := nTotPdt
                        end if

                     else

                        ( dbfTmp )->nCanEnt     := ( dbfPedPrvL )->nCanPed
                        ( dbfTmp )->nUniCaja    := ( dbfPedPrvL )->nUniCaja

                     end if

                  else

                     ( dbfTmp )->nUniCaja       := nTotPdt

                  end if

                  /*
                  Tomamos datos de la ficha de articulos-----------------------
                  */

                  if ( dbfArticulo )->( dbSeek( ( dbfPedPrvL )->cRef ) )

                     ( dbfTmp )->lIvaLin  := ( dbfArticulo )->lIvaInc

                     ( dbfTmp )->nBnfLin1 := ( dbfArticulo )->Benef1
                     ( dbfTmp )->nBnfLin2 := ( dbfArticulo )->Benef2
                     ( dbfTmp )->nBnfLin3 := ( dbfArticulo )->Benef3
                     ( dbfTmp )->nBnfLin4 := ( dbfArticulo )->Benef4
                     ( dbfTmp )->nBnfLin5 := ( dbfArticulo )->Benef5
                     ( dbfTmp )->nBnfLin6 := ( dbfArticulo )->Benef6

                     ( dbfTmp )->lBnfLin1 := ( dbfArticulo )->lBnf1
                     ( dbfTmp )->lBnfLin2 := ( dbfArticulo )->lBnf2
                     ( dbfTmp )->lBnfLin3 := ( dbfArticulo )->lBnf3
                     ( dbfTmp )->lBnfLin4 := ( dbfArticulo )->lBnf4
                     ( dbfTmp )->lBnfLin5 := ( dbfArticulo )->lBnf5
                     ( dbfTmp )->lBnfLin6 := ( dbfArticulo )->lBnf6

                     ( dbfTmp )->nBnfSbr1 := ( dbfArticulo )->nBnfSbr1
                     ( dbfTmp )->nBnfSbr2 := ( dbfArticulo )->nBnfSbr2
                     ( dbfTmp )->nBnfSbr3 := ( dbfArticulo )->nBnfSbr3
                     ( dbfTmp )->nBnfSbr4 := ( dbfArticulo )->nBnfSbr4
                     ( dbfTmp )->nBnfSbr5 := ( dbfArticulo )->nBnfSbr5
                     ( dbfTmp )->nBnfSbr6 := ( dbfArticulo )->nBnfSbr6

                     ( dbfTmp )->nPvpLin1 := ( dbfarticulo )->pVenta1
                     ( dbfTmp )->nPvpLin2 := ( dbfArticulo )->pVenta2
                     ( dbfTmp )->nPvpLin3 := ( dbfArticulo )->pVenta3
                     ( dbfTmp )->nPvpLin4 := ( dbfArticulo )->pVenta4
                     ( dbfTmp )->nPvpLin5 := ( dbfArticulo )->pVenta5
                     ( dbfTmp )->nPvpLin6 := ( dbfArticulo )->pVenta6

                     ( dbfTmp )->nIvaLin1 := ( dbfArticulo )->pVtaIva1
                     ( dbfTmp )->nIvaLin2 := ( dbfArticulo )->pVtaIva2
                     ( dbfTmp )->nIvaLin3 := ( dbfArticulo )->pVtaIva3
                     ( dbfTmp )->nIvaLin4 := ( dbfArticulo )->pVtaIva4
                     ( dbfTmp )->nIvaLin5 := ( dbfArticulo )->pVtaIva5
                     ( dbfTmp )->nIvaLin6 := ( dbfArticulo )->pVtaIva6

                  end if

                  if lActCos()
                     ( dbfTmp )->lChgLin     := .t.
                  end if

               end if

               ( dbfPedPrvL )->( dbSkip() )

            end while

            ( dbfTmp )->( dbGoTop() )

            oBrw:Refresh()

         end if

         /*
         Pasamos series de pedidos---------------------------------------------

         if ( dbfAlbPrvS )->( dbSeek( cPedido ) )

            while ( ( dbfAlbPrvS )->cSerPed + Str( ( dbfAlbPrvS )->nNumPed ) + ( dbfAlbPrvS )->cSufPed == cPedido ) .and. !( dbfAlbPrvS )->( eof() )

               dbPass( dbfTmpSer, dbfAlbPrvS, .t. )

               ( dbfAlbPrvS )->( dbSkip() )

            end while

            ( dbfTmpSer )->( dbGoTop() )

         end if
         */

         aGet[ _CNUMPED ]:bWhen     := {|| .f. }
         aGet[ _CNUMPED ]:bValid    := {|| .t. }
         lValid                     := .t.

      end if

   else

      msgStop( "Pedido no existe" )

   end if

   /*
   Recalculo del total---------------------------------------------------------
   */

   nTotAlbPrv( nil, dbfAlbPrvT, dbfTmp, dbfIva, dbfDiv, aTmp )

Return lValid

//---------------------------------------------------------------------------//

/*
Calcula totales en las lineas de Detalle
*/

Static Function lCalcDeta( aTmp, aTmpAlb, aGet, oTotal )

   oTotal:cText( nTotLAlbPrv( aTmp, nDinDiv, nDirDiv ) )

   /*
   Situacion posterior---------------------------------------------------------
   */

   aGet[ _NPRECOM ]:cText( nNetUAlbPrv( aTmp, aTmpAlb, nDinDiv, nDirDiv ) )

   if aTmp[ _LBNFLIN1 ]
         aGet[ _NBNFLIN1 ]:lValid()
   else
      if aTmp[ _LIVALIN ]
         aGet[ _NIVALIN1 ]:lValid()
      else
         aGet[ _NPVPLIN1 ]:lValid()
      end if
   end if

   if aTmp[ _LBNFLIN2 ]
         aGet[ _NBNFLIN2 ]:lValid()
   else
      if aTmp[ _LIVALIN ]
         aGet[ _NIVALIN2 ]:lValid()
      else
         aGet[ _NPVPLIN2 ]:lValid()
      end if
   end if

   if aTmp[ _LBNFLIN3 ]
         aGet[ _NBNFLIN3 ]:lValid()
   else
      if aTmp[ _LIVALIN ]
         aGet[ _NIVALIN3 ]:lValid()
      else
         aGet[ _NPVPLIN3 ]:lValid()
      end if
   end if

   if aTmp[ _LBNFLIN4 ]
         aGet[ _NBNFLIN4 ]:lValid()
   else
      if aTmp[ _LIVALIN ]
         aGet[ _NIVALIN4 ]:lValid()
      else
         aGet[ _NPVPLIN4 ]:lValid()
      end if
   end if

   if aTmp[ _LBNFLIN5 ]
         aGet[ _NBNFLIN5 ]:lValid()
   else
      if aTmp[ _LIVALIN ]
         aGet[ _NIVALIN5 ]:lValid()
      else
         aGet[ _NPVPLIN5 ]:lValid()
      end if
   end if

   if aTmp[ _LBNFLIN6 ]
         aGet[ _NBNFLIN6 ]:lValid()
   else
      if aTmp[ _LIVALIN ]
         aGet[ _NIVALIN6 ]:lValid()
      else
         aGet[ _NPVPLIN6 ]:lValid()
      end if
   end if

   if lActCos()

      if aTmp[ _NPREDIV ] != 0
         aGet[ _LCHGLIN ]:Click( .t. ):Refresh()
      else
         aGet[ _LCHGLIN ]:Click( .f. ):Refresh()
      end if

   end if

Return .t.

//---------------------------------------------------------------------------//
// Precio del articulo

FUNCTION nTotUAlbPrv( uAlbPrvL, nDec, nVdv, cPinDiv )

	local nCalculo

   DEFAULT uAlbPrvL  := if( !Empty( tmpAlbPrvL ), tmpAlbPrvL, dbfAlbPrvL )
   DEFAULT nDec      := nDinDiv()
   DEFAULT nVdv      := 1

   do case
      case ValType( uAlbPrvL ) == "A"
         nCalculo    := uAlbPrvL[ _NPREDIV ]

      case ValType( uAlbPrvL ) == "C"
         nCalculo    := ( uAlbPrvL )->nPreDiv

      case ValType( uAlbPrvL ) == "O"
         nCalculo    := uAlbPrvL:nPreDiv

   end case

   nCalculo          := Round( nCalculo / nVdv, nDec )

RETURN ( ( if( cPinDiv != nil, Trans( nCalculo, cPinDiv ), nCalculo ) )  )

//---------------------------------------------------------------------------//

FUNCTION nNetUAlbPrv( uAlbPrvL, uAlbPrvT, nDec, nRec, nVdv, cPinDiv )

   local nDtoEsp
	local nDtoPP
   local nDtoUno
	local nDtoDos
   local nCalculo
   local nDtoLin
   local nDtoPrm
   local nPorte

   DEFAULT nDec   := 0
   DEFAULT nRec   := 0
   DEFAULT nVdv   := 1

   nCalculo       := nTotUAlbPrv( uAlbPrvL, nDec, nVdv )

   if ValType( uAlbPrvL ) == "A"
      nDtoLin     := uAlbPrvL[ _NDTOLIN ]
      nDtoPrm     := uAlbPrvL[ _NDTOPRM ]
   else
      nDtoLin     := ( uAlbPrvL )->nDtoLin
      nDtoPrm     := ( uAlbPrvL )->nDtoPrm
   end if

   if nDtoLin != 0
      nCalculo    -= nCalculo * nDtoLin / 100
   end if

   if nDtoPrm != 0
      nCalculo    -= nCalculo * nDtoPrm / 100
   end if

   /*
   Comprobamos los parametros--------------------------------------------------
   */

   if ValType( uAlbPrvT ) == "A"
      nDtoEsp     := uAlbPrvT[ _NDTOESP ]
      nDtoPP      := uAlbPrvT[ _NDPP    ]
      nDtoUno     := uAlbPrvT[ _NDTOUNO ]
      nDtoDos     := uAlbPrvT[ _NDTODOS ]
      nPorte      := uAlbPrvT[ _NPORTES ]
   else
      nDtoEsp     := (uAlbPrvT)->nDtoEsp
      nDtoPP      := (uAlbPrvT)->nDpp
      nDtoUno     := (uAlbPrvT)->nDtoUno
      nDtoDos     := (uAlbPrvT)->nDtoDos
      nPorte      := (uAlbPrvT)->nPorTes
   end if

   if nDtoEsp != 0
      nCalculo    -= Round( nCalculo * nDtoEsp / 100, nDec )
   end if

   if nDtoPP != 0
      nCalculo    -= Round( nCalculo * nDtoPP  / 100, nDec )
   end if

   if nDtoUno != 0
      nCalculo    -= Round( nCalculo * nDtoUno / 100, nDec )
   end if

   if nDtoDos != 0
      nCalculo    -= Round( nCalculo * nDtoDos / 100, nDec )
   end if

   nCalculo       := Round( nCalculo, nDec )

RETURN ( if( cPinDiv != NIL, Trans( nCalculo, cPinDiv ), nCalculo ) )

//---------------------------------------------------------------------------//
// Total de linea

FUNCTION nTotLAlbPrv( uAlbPrvL, nDec, nRec, nVdv, cPirDiv )

   local nCalculo
   local nDtoLin
   local nDtoPrm
   local nTotDto     := 0

   DEFAULT uAlbPrvL  := if( !Empty( tmpAlbPrvL ), tmpAlbPrvL, dbfAlbPrvL )
   DEFAULT nDec      := nDinDiv()
   DEFAULT nRec      := nRinDiv()
   DEFAULT nVdv      := 1

   /*
   Comprobamos los parametros--------------------------------------------------------------------
   */

   nCalculo          := nTotNAlbPrv( uAlbPrvL )

   do case
      case ValType( uAlbPrvL ) == "A"
         nDtoLin     := uAlbPrvL[ _NDTOLIN ]
         nDtoPrm     := uAlbPrvL[ _NDTOPRM ]

      case ValType( uAlbPrvL ) == "C"
         nDtoLin     := ( uAlbPrvL )->nDtoLin
         nDtoPrm     := ( uAlbPrvL )->nDtoPrm

      case ValType( uAlbPrvL ) == "O"
         nDtoLin     := uAlbPrvL:nDtoLin
         nDtoPrm     := uAlbPrvL:nDtoPrm

   end case

   if nDtoLin != 0
      nCalculo       -= nCalculo * nDtoLin / 100
   end if

   if nDtoPrm != 0
      nCalculo       -= nCalculo * nDtoPrm / 100
   end if

   nCalculo          -= nTotDto

   nCalculo          *= nTotUAlbPrv( uAlbPrvL, nDec, nVdv )

   if nRec != nil
      nCalculo       := Round( nCalculo, nRec )
   end if

RETURN ( if( cPirDiv != nil, Trans( nCalculo, cPirDiv ), nCalculo ) )

//---------------------------------------------------------------------------//
//
// Precio unitario de la linea con descuentos
//

FUNCTION nImpUAlbPrv( uAlbPrvT, uAlbPrvL, nDec, nVdv, lIva, cPouDiv )

   local nCalculo

   DEFAULT uAlbPrvT  := dbfAlbPrvT
   DEFAULT uAlbPrvL  := if( !Empty( tmpAlbPrvL ), tmpAlbPrvL, dbfAlbPrvL )
   DEFAULT nDec      := nDinDiv()
   DEFAULT nVdv      := 1
   DEFAULT lIva      := .f.

   nCalculo          := nTotUAlbPrv( uAlbPrvL, nDec, nVdv )

   if ValType( uAlbPrvT ) == "A"
      nCalculo       -= Round( nCalculo * uAlbPrvT[ _NDTOESP ]  / 100, nDec )
      nCalculo       -= Round( nCalculo * uAlbPrvT[ _NDPP    ]  / 100, nDec )
      nCalculo       -= Round( nCalculo * uAlbPrvT[ _NDTOUNO ]  / 100, nDec )
      nCalculo       -= Round( nCalculo * uAlbPrvT[ _NDTODOS ]  / 100, nDec )
   else
      nCalculo       -= Round( nCalculo * ( uAlbPrvT )->nDtoEsp / 100, nDec )
      nCalculo       -= Round( nCalculo * ( uAlbPrvT )->nDpp    / 100, nDec )
      nCalculo       -= Round( nCalculo * ( uAlbPrvT )->nDtoUno / 100, nDec )
      nCalculo       -= Round( nCalculo * ( uAlbPrvT )->nDtoDos / 100, nDec )
   end if

   if lIva .and. ( uAlbPrvL )->nIva != 0
      nCalculo       += nCalculo * ( uAlbPrvL )->nIva / 100
   end if

RETURN ( if( cPouDiv != nil, Trans( nCalculo, cPouDiv ), nCalculo ) )

//---------------------------------------------------------------------------//
//
// Precio de la linea con descuentos
//

FUNCTION nImpLAlbPrv( uAlbPrvT, uAlbPrvL, nDec, nRou, nVdv, lIva, cPouDiv )

   local nCalculo

   DEFAULT uAlbPrvT  := dbfAlbPrvT
   DEFAULT uAlbPrvL  := if( !Empty( tmpAlbPrvL ), tmpAlbPrvL, dbfAlbPrvL )
   DEFAULT nDec      := nDinDiv()
   DEFAULT nRou      := nRinDiv()
   DEFAULT nVdv      := 1
   DEFAULT lIva      := .f.

   nCalculo          := nTotLAlbPrv( uAlbPrvL, nDec, nRou, nVdv )

   if ValType( uAlbPrvT ) == "A"
      nCalculo       -= Round( nCalculo * uAlbPrvT[ _NDTOESP ]  / 100, nRou )
      nCalculo       -= Round( nCalculo * uAlbPrvT[ _NDPP    ]  / 100, nRou )
      nCalculo       -= Round( nCalculo * uAlbPrvT[ _NDTOUNO ]  / 100, nRou )
      nCalculo       -= Round( nCalculo * uAlbPrvT[ _NDTODOS ]  / 100, nRou )
   else
      nCalculo       -= Round( nCalculo * ( uAlbPrvT )->nDtoEsp / 100, nRou )
      nCalculo       -= Round( nCalculo * ( uAlbPrvT )->nDpp    / 100, nRou )
      nCalculo       -= Round( nCalculo * ( uAlbPrvT )->nDtoUno / 100, nRou )
      nCalculo       -= Round( nCalculo * ( uAlbPrvT )->nDtoDos / 100, nRou )
   end if

   if lIva .and. ( uAlbPrvL )->nIva != 0
      nCalculo       += nCalculo * ( uAlbPrvL )->nIva / 100
   end if

RETURN ( if( cPouDiv != NIL, Trans( nCalculo, cPouDiv ), nCalculo ) )

//---------------------------------------------------------------------------//

FUNCTION BrwAlbPrv( oGetNum, dbfAlbPrvT, dbfAlbPrvL, dbfIva, dbfDiv )

	local oDlg
	local oBrw
   local oGet1
   local cGet1
   local nOrd     := GetBrwOpt( "BrwAlbPrv" )
	local oCbxOrd
   local aCbxOrd  := { "N. albarán", "Fecha", "Cod. proveedor", "Nom. proveedor" }
   local cCbxOrd
   local aBmp     := {  LoadBitmap( GetResources(), "BGREEN" ),;
                        LoadBitmap( GetResources(), "BRED" ) }

   nOrd           := Min( Max( nOrd, 1 ), len( aCbxOrd ) )
   cCbxOrd        := aCbxOrd[ nOrd ]
   nOrd           := ( dbfAlbPrvT )->( OrdSetFocus( nOrd ) )

   ( dbfAlbPrvT )->( dbSetFilter( {|| !Field->lFacturado }, "!lFacturado" ) )
   ( dbfAlbPrvT )->( dbGoTop() )

   DEFINE DIALOG oDlg RESOURCE "HELPENTRY" TITLE "Albaranes de proveedores"

		REDEFINE GET oGet1 VAR cGet1;
			ID 		104 ;
         ON CHANGE( AutoSeek( nKey, nFlags, Self, oBrw, dbfAlbPrvT ) );
         VALID    ( OrdClearScope( oBrw, dbfAlbPrvT ) );
         BITMAP   "FIND" ;
         OF       oDlg

		REDEFINE COMBOBOX oCbxOrd ;
			VAR 		cCbxOrd ;
			ID 		102 ;
         ITEMS    aCbxOrd ;
         ON CHANGE( ( dbfAlbPrvT )->( OrdSetFocus( oCbxOrd:nAt ) ), oBrw:refresh(), oGet1:SetFocus() ) ;
			OF 		oDlg

      oBrw                 := IXBrowse():New( oDlg )

      oBrw:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrw:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrw:cAlias          := dbfAlbPrvT
      oBrw:nMarqueeStyle   := 5
      oBrw:cName           := "Albaran de proveedor.Browse"

      oBrw:bLDblClick      := {|| oDlg:end( IDOK ) }

      oBrw:CreateFromResource( 105 )

      with object ( oBrw:AddCol() )
         :cHeader          := "Es. Estado"
         :bStrData         := {|| "" }
         :bEditValue       := {|| ( dbfAlbPrvT )->lFacturado }
         :nWidth           := 20
         :SetCheck( { "Sel16", "Cnt16" } )
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "N. albarán"
         :cSortOrder       := "nNumAlb"
         :bEditValue       := {|| ( dbfAlbPrvT )->cSerAlb + "/" + AllTrim( Str( ( dbfAlbPrvT )->nNumAlb ) ) + "/" + ( dbfAlbPrvT )->cSufAlb }
         :nWidth           := 60
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Fecha"
         :cSortOrder       := "dFecAlb"
         :bEditValue       := {|| dToc( ( dbfAlbPrvT )->dFecAlb ) }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Cod. proveedor"
         :cSortOrder       := "cCodPrv"
         :bEditValue       := {|| Rtrim( ( dbfAlbPrvT )->cCodPrv ) }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Nom. proveedor"
         :cSortOrder       := "cNomPrv"
         :bEditValue       := {|| Rtrim( ( dbfAlbPrvT )->cNomPrv ) }
         :nWidth           := 200
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Importe"
         :bEditValue       := {|| nTotAlbPrv( ( dbfAlbPrvT )->cSerAlb + Str( (dbfAlbPrvT)->nNumAlb ) + (dbfAlbPrvT)->cSufAlb, dbfAlbPrvT, dbfAlbPrvL, dbfIva, dbfDiv, nil, cDivEmp(), .t. ) }
         :nWidth           := 60
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

		REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
         ACTION   ( oDlg:end( IDOK ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
			ACTION 	( oDlg:end() )

		REDEFINE BUTTON ;
			ID 		500 ;
			OF 		oDlg ;
			WHEN 		.F.

		REDEFINE BUTTON ;
			ID 		501 ;
			OF 		oDlg ;
			WHEN 		.F.

   oDlg:AddFastKey( VK_RETURN, {|| oDlg:end( IDOK ) } )
   oDlg:AddFastKey( VK_F5, {|| oDlg:end( IDOK ) } )

   oDlg:bStart    := {|| oBrw:Load() }

   ACTIVATE DIALOG oDlg CENTER

   if oDlg:nResult == IDOK
      oGetNum:cText( ( dbfAlbPrvT )->cSerAlb + Str( ( dbfAlbPrvT )->nNumAlb ) + ( dbfAlbPrvT )->cSufAlb )
      oGetNum:disable()
   end if

   DestroyFastFilter( dbfAlbPrvT )

   SetBrwOpt( "BrwAlbPrv", ( dbfAlbPrvT )->( OrdNumber() ) )

   ( dbfAlbPrvT )->( dbSetFilter() )
   ( dbfAlbPrvT )->( OrdSetFocus( nOrd ) )

   aEval( aBmp, { | hBmp | DeleteObject( hBmp ) } )

   oBrw:CloseData()

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

/*
Añade a la empresa nueva los albaranes a proveedor y regulariza el Stock si nos lo piden
*/

FUNCTION mkAlbPrv( cPath, lAppend, cPathOld, oMeter, bFor, dbfMov )

   local oBlock
   local oError
   local dbfAlbPrvT
   local dbfAlbPrvL
   local dbfAlbPrvI
   local dbfAlbPrvD
   local oldAlbPrvT
   local oldAlbPrvL
   local oldAlbPrvI
   local oldAlbPrvD

   DEFAULT lAppend   := .f.
   DEFAULT bFor      := {|| .t. }

	IF oMeter != NIL
      oMeter:cText   := "Generando bases"
		sysrefresh()
	END IF

   CreateFiles( cPath )
   rxAlbPrv( cPath, oMeter )

   IF lAppend .and. lIsDir( cPathOld )

      oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
      BEGIN SEQUENCE

      dbUseArea( .t., cDriver(), cPath + "ALBPROVT.DBF", cCheckArea( "ALBPROVT", @dbfAlbPrvT ), .f. )
      ordListAdd( cPath + "ALBPROVT.CDX"  )

      dbUseArea( .t., cDriver(), cPath + "ALBPROVL.DBF", cCheckArea( "ALBPROVL", @dbfAlbPrvL ), .f. )
      ordListAdd( cPath + "ALBPROVL.CDX"  )

      dbUseArea( .t., cDriver(), cPath + "AlbPrvI.Dbf", cCheckArea( "AlbPrvI", @dbfAlbPrvI ), .f. )
      ( dbfAlbPrvI )->( ordListAdd( cPath + "AlbPrvI.Cdx"  ) )

      dbUseArea( .t., cDriver(), cPath + "AlbPrvD.Dbf", cCheckArea( "AlbPrvD", @dbfAlbPrvD ), .f. )
      ( dbfAlbPrvD )->( ordListAdd( cPath + "AlbPrvD.Cdx"  ) )

      dbUseArea( .t., cDriver(), cPathOld + "ALBPROVT.DBF", cCheckArea( "ALBPROVT", @oldAlbPrvT ), .f. )
      ordListAdd( cPathOld + "ALBPROVT.CDX"  )

      dbUseArea( .t., cDriver(), cPathOld + "ALBPROVL.DBF", cCheckArea( "ALBPROVL", @oldAlbPrvL ), .f. )
      ordListAdd( cPathOld + "ALBPROVL.CDX"  )

      dbUseArea( .t., cDriver(), cPathOld + "ALBPRVI.Dbf", cCheckArea( "ALBPRVI", @oldAlbPrvI ), .f. )
      ( oldAlbPrvI )->( ordListAdd( cPathOld + "ALBPRVI.Cdx"  ) )

      dbUseArea( .t., cDriver(), cPathOld + "ALBPRVD.Dbf", cCheckArea( "ALBPRVD", @oldAlbPrvD ), .f. )
      ( oldAlbPrvD )->( ordListAdd( cPathOld + "ALBPRVD.Cdx"  ) )

      while !( oldAlbPrvT )->( eof() )

         if eval( bFor, oldAlbPrvT )
            dbCopy( oldAlbPrvT, dbfAlbPrvT, .t. )

            if ( dbfAlbPrvT )->( Rlock() )
               ( dbfAlbPrvT )->cTurAlb    := "   1"
               ( dbfAlbPrvT )->( dbRUnlock() )
            end if

            if ( oldAlbPrvL )->( dbSeek( (oldAlbPrvT)->cSerAlb + Str( (oldAlbPrvT)->nNumAlb ) + (oldAlbPrvT)->CSUFALB ) )

               while (oldAlbPrvT)->cSerAlb + Str( (oldAlbPrvL)->nNumAlb ) + (oldAlbPrvL)->CSUFALB == (oldAlbPrvT)->cSerAlb + Str( (dbfAlbPrvT)->nNumAlb ) + (dbfAlbPrvT)->CSUFALB .and. !(oldAlbPrvL)->( eof() )

                  dbCopy( oldAlbPrvL, dbfAlbPrvL, .t. )

                  /*
                  Quitamos stocks del stock inicial
                  */

                  if dbfMov != nil
                     putStock( ( dbfAlbPrvL )->cRef, ( dbfAlbPrvT )->cCodAlm, nCanEnt( dbfAlbprvL ) * - 1 , dbfMov, "EI" )
                  end if

                  ( oldAlbPrvL )->( dbSkip() )

               end while

            end if

            if ( oldAlbPrvI )->( dbSeek( (oldAlbPrvT)->cSerAlb + Str( (oldAlbPrvT)->nNumAlb ) + (oldAlbPrvT)->CSUFALB ) )
               while ( oldAlbPrvI )->cSerAlb + Str( ( oldAlbPrvI )->nNumAlb ) + ( oldAlbPrvI )->cSufAlb == ( oldAlbPrvT )->cSerAlb + Str( ( dbfAlbPrvT )->nNumAlb ) + ( dbfAlbPrvT )->cSufAlb .and. !( oldAlbPrvI )->( eof() )
                  dbCopy( oldAlbPrvL, dbfAlbPrvL, .t. )
                  ( oldAlbPrvI )->( dbSkip() )
               end while
            end if

            if ( oldAlbPrvD )->( dbSeek( (oldAlbPrvT)->cSerAlb + Str( (oldAlbPrvT)->nNumAlb ) + (oldAlbPrvT)->CSUFALB ) )
               while ( oldAlbPrvD )->cSerAlb + Str( ( oldAlbPrvD )->nNumAlb ) + ( oldAlbPrvD )->cSufAlb == ( oldAlbPrvT )->cSerAlb + Str( ( dbfAlbPrvT )->nNumAlb ) + ( dbfAlbPrvT )->cSufAlb .and. !( oldAlbPrvI )->( eof() )
                  dbCopy( oldAlbPrvD, dbfAlbPrvD, .t. )
                  ( oldAlbPrvD )->( dbSkip() )
               end while
            end if

         end if

         ( oldAlbPrvT )->( dbSkip() )

      end while

      /*
      Reemplaza la antigua sesion----------------------------------------------
      */

      ( dbfAlbPrvT )->( dbEval( {|| ( dbfAlbPrvT )->cTurAlb := Space( 6 ) },,,,, .f. ) )

      /*
      Cerramos las bases de datos----------------------------------------------
      */

      ( dbfAlbPrvT )->( dbCloseArea() )
      ( dbfAlbPrvL )->( dbCloseArea() )
      ( dbfAlbPrvI )->( dbCloseArea() )
      ( dbfAlbPrvD )->( dbCloseArea() )

      ( oldAlbPrvT )->( dbCloseArea() )
      ( oldAlbPrvL )->( dbCloseArea() )
      ( oldAlbPrvI )->( dbCloseArea() )
      ( oldAlbPrvD )->( dbCloseArea() )

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos de agentes" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

	END IF

Return nil

//---------------------------------------------------------------------------//

FUNCTION rxAlbPrv( cPath, oMeter )

	local dbfAlbPrvT

   DEFAULT cPath  := cPatEmp()

   if !lExistTable( cPath + "ALBPROVT.DBF" ) .or. ;
      !lExistTable( cPath + "ALBPROVL.DBF" ) .or. ;
      !lExistTable( cPath + "ALBPRVI.DBF" )  .or. ;
      !lExistTable( cPath + "ALBPRVD.DBF" )  .or. ;
      !lExistTable( cPath + "AlbPrvS.DBF" )
      CreateFiles( cPath )
   end if

	/*
	Eliminamos los indices
	*/

   fEraseIndex( cPath + "ALBPROVT.CDX" )
   fEraseIndex( cPath + "ALBPROVL.CDX" )
   fEraseIndex( cPath + "ALBPRVI.CDX" )
   fEraseIndex( cPath + "ALBPRVD.CDX" )
   fEraseIndex( cPath + "AlbPrvS.Cdx" )

   dbUseArea( .t., cDriver(), cPath + "ALBPROVT.DBF", cCheckArea( "ALBPROVT", @dbfAlbPrvT ), .f. )

   if !( dbfAlbPrvT )->( neterr() )
      ( dbfAlbPrvT)->( __dbPack() )

      ( dbfAlbPrvT)->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfAlbPrvT)->( ordCreate( cPath + "ALBPROVT.CDX", "NNUMALB", "CSERALB + STR( NNUMALB ) + CSUFALB", {|| Field->cSerAlb + STR( Field->nNumAlb ) + Field->CSUFALB } ) )

      ( dbfAlbPrvT)->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfAlbPrvT)->( ordCreate( cPath + "ALBPROVT.CDX", "DFECALB", "DFECALB", {|| Field->DFECALB } ) )

      ( dbfAlbPrvT)->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfAlbPrvT)->( ordCreate( cPath + "ALBPROVT.CDX", "CCODPRV", "CCODPRV", {|| Field->CCODPRV } ) )

      ( dbfAlbPrvT)->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfAlbPrvT)->( ordCreate( cPath + "ALBPROVT.CDX", "CNOMPRV", "Upper( CNOMPRV )", {|| Upper( Field->CNOMPRV ) } ) )

      ( dbfAlbPrvT)->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfAlbPrvT)->( ordCreate( cPath + "ALBPROVT.CDX", "CSUALB", "CSUALB", {|| Field->CSUALB } ) )

      ( dbfAlbPrvT)->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( dbfAlbPrvT)->( ordCreate( cPath + "ALBPROVT.CDX", "CNUMFAC", "CNUMFAC", {|| Field->CNUMFAC }, ) )

      ( dbfAlbPrvT)->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfAlbPrvT)->( ordCreate( cPath + "ALBPROVT.CDX", "CTURALB", "CTURALB + CSUFALB + cCodCaj", {|| Field->CTURALB + Field->CSUFALB + Field->cCodCaj } ) )

      ( dbfAlbPrvT)->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfAlbPrvT)->( ordCreate( cPath + "ALBPROVT.CDX", "CNUMPED", "CNUMPED", {|| Field->CNUMPED } ) )

      ( dbfAlbPrvT)->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfAlbPrvT)->( ordCreate( cPath + "AlbProvT.Cdx", "cCodUsr", "Field->cCodUsr + Dtos( Field->dFecChg ) + Field->cTimChg", {|| Field->cCodUsr + Dtos( Field->dFecChg ) + Field->cTimChg } ) )

      ( dbfAlbPrvT )->( dbCloseArea() )

   else

      msgStop( "Imposible abrir en modo exclusivo la tabla de albaranes de proveedores" )

   end if

   dbUseArea( .t., cDriver(), cPath + "ALBPROVL.DBF", cCheckArea( "ALBPROVL", @dbfAlbPrvT ), .f. )

   if !( dbfAlbPrvT )->( neterr() )
      ( dbfAlbPrvT)->( __dbPack() )

      ( dbfAlbPrvT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfAlbPrvT )->( ordCreate( cPath + "AlbProvL.Cdx", "nNumAlb", "cSerAlb + Str( nNumAlb ) + cSufAlb", {|| Field->cSerAlb + STR( Field->nNumAlb ) + Field->cSufAlb } ) )

      ( dbfAlbPrvT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfAlbPrvT )->( ordCreate( cPath + "AlbProvL.Cdx", "cRef", "cRef + cValPr1 + cValPr2", {|| Field->cRef + Field->cValPr1 + Field->cValPr2 } ) )

      ( dbfAlbPrvT )->( ordCondSet( "!lFacturado .and. !Deleted()", {|| !Field->lFacturado .and. !Deleted() } ) )
      ( dbfAlbPrvT )->( ordCreate( cPath + "AlbProvL.Cdx", "cRefLote", "cRef + cValPr1 + cValPr2 + cLote", {|| Field->cRef + Field->cValPr1 + Field->cValPr2 + Field->cLote } ) )

      ( dbfAlbPrvT )->( ordCondSet( "!Deleted()", {||!Deleted()}  ) )
      ( dbfAlbPrvT )->( ordCreate( cPath + "AlbProvL.Cdx", "Lote", "cLote", {|| Field->cLote } ) )

      ( dbfAlbPrvT )->( ordCondSet( "!Deleted()", {||!Deleted()}  ) )
      ( dbfAlbPrvT )->( ordCreate( cPath + "AlbProvL.Cdx", "cRefLote", "cRef + cLote", {|| Field->cRef + Field->cLote } ) )

      ( dbfAlbPrvT)->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfAlbPrvT)->( ordCreate( cPath + "AlbProvL.Cdx", "cNumPed", "cNumPed", {|| Field->cNumPed } ) )

      ( dbfAlbPrvT)->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfAlbPrvT)->( ordCreate( cPath + "AlbProvL.Cdx", "cPedCliRef", "cNumPed + cRef + cValPr1 + cValPr2", {|| Field->cNumPed + Field->cRef + Field->cValPr1 + Field->cValPr2 } ) )

      ( dbfAlbPrvT)->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfAlbPrvT)->( ordCreate( cPath + "AlbProvL.Cdx", "cPedCliDet", "cNumPed + cRef + cValPr1 + cValPr2 + cRefPrv ", {|| Field->cNumPed + Field->cRef + Field->cValPr1 + Field->cValPr2 + Field->cRefPrv } ) ) // + cDetalle

      ( dbfAlbPrvT)->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfAlbPrvT)->( ordCreate( cPath + "AlbProvL.Cdx", "cCodPed", "cCodPed", {|| Field->cCodPed } ) )

      ( dbfAlbPrvT)->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfAlbPrvT)->( ordCreate( cPath + "AlbProvL.Cdx", "cPedPrvRef", "cCodPed + cRef + cValPr1 + cValPr2 + cLote", {|| Field->cCodPed + Field->cRef + Field->cValPr1 + Field->cValPr2 + Field->cLote } ) )

      ( dbfAlbPrvT)->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfAlbPrvT)->( ordCreate( cPath + "AlbProvL.Cdx", "cPedPrvDet", "cCodPed + cRef + cValPr1 + cValPr2 + cRefPrv ", {|| Field->cCodPed + Field->cRef + Field->cValPr1 + Field->cValPr2 + Field->cRefPrv } ) ) // + cDetalle

      ( dbfAlbPrvT)->( ordCondSet( "!lFacturado .and. !Deleted()", {|| !Field->lFacturado .and. !Deleted() } ) )
      ( dbfAlbPrvT)->( ordCreate( cPath + "AlbProvL.Cdx", "cStkFast", "cRef", {|| Field->cRef } ) )

      ( dbfAlbPrvT )->( ordCondSet( "!lFacturado .and. !Deleted()", {|| !Field->lFacturado .and. !Deleted()}  ) )
      ( dbfAlbPrvT )->( ordCreate( cPath + "AlbProvL.Cdx", "cStkRef", "cRef + cValPr1 + cValPr2", {|| Field->cRef + Field->cValPr1 + Field->cValPr2 } ) )

      ( dbfAlbPrvT)->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfAlbPrvT)->( ordCreate( cPath + "AlbProvL.Cdx", "cPCliDet", "cNumPed + cRef + cValPr1 + cValPr2 + cLote ", {|| Field->cNumPed + Field->cRef + Field->cValPr1 + Field->cValPr2 + Field->cLote } ) ) // + cDetalle

      ( dbfAlbPrvT)->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfAlbPrvT)->( ordCreate( cPath + "AlbProvL.Cdx", "cPedRef", "cCodPed + cRef", {|| Field->cCodPed + Field->cRef } ) )

      ( dbfAlbPrvT)->( ordCondSet("!Deleted() .and. !lFacturado", {||!Deleted() .and. !Field->lFacturado }, , , , , , , , , .t.  ) )
      ( dbfAlbPrvT)->( ordCreate( cPath + "AlbProvL.Cdx", "cRefFec", "cRef + dtos( dFecAlb )", {|| Field->cRef + dtos( Field->dFecAlb ) } ) )

      ( dbfAlbPrvT )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de albaranes de proveedores" )
   end if

   dbUseArea( .t., cDriver(), cPath + "AlbPrvI.DBF", cCheckArea( "AlbPrvI", @dbfAlbPrvT ), .f. )

   if !( dbfAlbPrvT )->( neterr() )
      ( dbfAlbPrvT )->( __dbPack() )

      ( dbfAlbPrvT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfAlbPrvT )->( ordCreate( cPath + "AlbPrvI.CDX", "NNUMALB", "CSERALB + STR( NNUMALB ) + CSUFALB", {|| Field->cSerAlb + Str( Field->nNumAlb ) + Field->cSufAlb } ) )

      ( dbfAlbPrvT )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de albaranes de proveedores" )
   end if

   dbUseArea( .t., cDriver(), cPath + "AlbPrvD.DBF", cCheckArea( "AlbPrvD", @dbfAlbPrvT ), .f. )

   if !( dbfAlbPrvT )->( neterr() )
      ( dbfAlbPrvT )->( __dbPack() )

      ( dbfAlbPrvT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfAlbPrvT )->( ordCreate( cPath + "AlbPrvD.CDX", "NNUMALB", "CSERALB + STR( NNUMALB ) + CSUFALB", {|| Field->cSerAlb + Str( Field->nNumAlb ) + Field->cSufAlb } ) )

      ( dbfAlbPrvT )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de albaranes de proveedores" )
   end if

   dbUseArea( .t., cDriver(), cPath + "AlbPrvS.DBF", cCheckArea( "AlbPrvS", @dbfAlbPrvT ), .f. )
   if !( dbfAlbPrvT )->( neterr() )
      ( dbfAlbPrvT )->( __dbPack() )

      ( dbfAlbPrvT )->( ordCondSet( "!Deleted()", {||!Deleted()}  ) )
      ( dbfAlbPrvT )->( ordCreate( cPath + "AlbPrvS.CDX", "nNumAlb", "cSerAlb + Str( nNumAlb ) + cSufAlb + Str( nNumLin )", {|| Field->cSerAlb + Str( Field->nNumAlb ) + Field->cSufAlb + Str( Field->nNumLin ) } ) )

      ( dbfAlbPrvT )->( ordCondSet( "!lFacturado .and. !Deleted()", {|| !Field->lFacturado .and. !Deleted() }  ) )
      ( dbfAlbPrvT )->( ordCreate( cPath + "AlbPrvS.CDX", "cRefSer", "cRef + cAlmLin + cNumSer", {|| Field->cRef + Field->cAlmLin + Field->cNumSer } ) )

      ( dbfAlbPrvT )->( ordCondSet( "!Deleted()", {|| !Field->lFacturado .and. !Deleted() }  ) )
      ( dbfAlbPrvT )->( ordCreate( cPath + "AlbPrvS.CDX", "cNumSer", "cNumSer", {|| Field->cNumSer } ) )

      ( dbfAlbPrvT )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de numeros de series de albaranes de proveedores" )
   end if

RETURN NIL

//--------------------------------------------------------------------------//

STATIC FUNCTION BeginTrans( aTmp, aOld )

   local oBlock
   local lErrors     := .f.
   local cDbf        := "AProL"
   local cDbfInc     := "AProI"
   local cDbfDoc     := "AProD"
   local cDbfSer     := "AProS"
   local nAlbaran    := aTmp[ _CSERALB ] + Str( aTmp[ _NNUMALB ] ) + aTmp[ _CSUFALB ]

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      CursorWait()

      cNewFile       := cGetNewFileName( cPatTmp() + cDbf )
      cTmpInc        := cGetNewFileName( cPatTmp() + cDbfInc )
      cTmpDoc        := cGetNewFileName( cPatTmp() + cDbfDoc )
      cTmpSer        := cGetNewFileName( cPatTmp() + cDbfSer )

      /*
      Primero Crear la base de datos local----------------------------------------
      */

      dbCreate( cNewFile, aSqlStruct( aColAlbPrv() ), cLocalDriver() )
      dbUseArea( .t., cLocalDriver(), cNewFile, cCheckArea( cDbf, @dbfTmp ), .f. )

      if !( dbfTmp )->( neterr() )
         ( dbfTmp )->( OrdCondSet( "!Deleted()", {||!Deleted() } ) )
         ( dbfTmp )->( OrdCreate( cNewFile, "nNumLin", "Str( nNumLin, 4 )", {|| Str( Field->nNumLin ) } ) )

         ( dbfTmp )->( OrdCondSet( "!Deleted()", {||!Deleted()} ) )
         ( dbfTmp )->( OrdCreate( cNewFile, "Recno", "Str( Recno() )", {|| Str( Recno() ) } ) )
      end if

      /*
      A¤adimos desde el fichero de lineas
      */

      if ( dbfAlbPrvL )->( dbSeek( nAlbaran ) )
         while ( ( dbfAlbPrvL )->cSerAlb + Str( ( dbfAlbPrvL )->nNumAlb ) + ( dbfAlbPrvL )->cSufAlb == nAlbaran .AND. !( dbfAlbPrvL )->( eof() ) )
            dbPass( dbfAlbPrvL, dbfTmp, .t. )
            ( dbfAlbPrvL )->( DbSkip() )
         end while
      end if

      ( dbfTmp )->( dbGoTop() )

      /*
      Creamos la tabla temporal de incidencias
      */

      dbCreate( cTmpInc, aSqlStruct( aIncAlbPrv() ), cLocalDriver() )
      dbUseArea( .t., cLocalDriver(), cTmpInc, cCheckArea( cDbfInc, @dbfTmpInc ), .f. )

      if !( dbfTmpInc )->( neterr() )
         ( dbfTmpInc )->( ordCondSet( "!Deleted()", {||!Deleted() } ) )
         ( dbfTmpInc )->( ordCreate( cTmpInc, "Recno", "Recno()", {|| Recno() } ) )
      end if

      /*
      A¤adimos desde el fichero de incidencias
      */

      if ( dbfAlbPrvI )->( dbSeek( nAlbaran ) )
         while ( ( dbfAlbPrvI )->cSerAlb + Str( ( dbfAlbPrvI )->nNumAlb ) + ( dbfAlbPrvI )->cSufAlb == nAlbaran ) .AND. ( dbfAlbPrvI )->( !eof() )
            dbPass( dbfAlbPrvI, dbfTmpInc, .t. )
            ( dbfAlbPrvI )->( dbSkip() )
         end while
      end if

      ( dbfTmpInc )->( dbGoTop() )

      /*
      Creamos la tabla temporal de Documentos
      */

      dbCreate( cTmpDoc, aSqlStruct( aAlbPrvDoc() ), cLocalDriver() )
      dbUseArea( .t., cLocalDriver(), cTmpDoc, cCheckArea( cDbfDoc, @dbfTmpDoc ), .f. )

      if !( dbfTmpDoc )->( neterr() )
         ( dbfTmpDoc )->( ordCondSet( "!Deleted()", {||!Deleted() } ) )
         ( dbfTmpDoc )->( ordCreate( cTmpDoc, "Recno", "Recno()", {|| Recno() } ) )
      end if

      /*
      A¤adimos desde el fichero de documentos----------------------------------
      */

      if ( dbfAlbPrvD )->( dbSeek( nAlbaran ) )
         while ( ( dbfAlbPrvD )->cSerAlb + Str( ( dbfAlbPrvD )->nNumAlb ) + ( dbfAlbPrvD )->cSufAlb == nAlbaran ) .AND. ( dbfAlbPrvD )->( !eof() )
            dbPass( dbfAlbPrvD, dbfTmpDoc, .t. )
            ( dbfAlbPrvD )->( dbSkip() )
         end while
      end if

      ( dbfTmpDoc )->( dbGoTop() )

      /*
      Creamos el fichero de series------------------------------------------------
      */

      dbCreate( cTmpSer, aSqlStruct( aSerAlbPrv() ), cLocalDriver() )
      dbUseArea( .t., cLocalDriver(), cTmpSer, cCheckArea( cDbf, @dbfTmpSer ), .f. )

      if !( dbfTmpSer )->( neterr() )
         ( dbfTmpSer )->( OrdCondSet( "!Deleted()", {||!Deleted() } ) )
         ( dbfTmpSer )->( OrdCreate( cTmpSer, "nNumLin", "Str( nNumLin, 4 ) + cRef", {|| Str( Field->nNumLin, 4 ) + Field->cRef } ) )
      end if

      /*
      A¤adimos desde el fichero de series-----------------------------------------
      */

      if ( dbfAlbPrvS )->( dbSeek( nAlbaran ) )
         do while ( ( dbfAlbPrvS )->cSerAlb + Str( ( dbfAlbPrvS )->nNumAlb ) + ( dbfAlbPrvS )->cSufAlb == nAlbaran )
            dbPass( dbfAlbPrvS, dbfTmpSer, .t. )
            ( dbfAlbPrvS )->( dbSkip() )
         end while
      end if

      ( dbfTmpSer )->( dbGoTop() )

      CursorWE()

   RECOVER

      msgStop( "Imposible crear tablas temporales." )

      KillTrans()

      lErrors     := .t.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lErrors )

//---------------------------------------------------------------------------//

function aIncAlbPrv()

   local aIncAlbPrv  := {}

   aAdd( aIncAlbPrv, { "cSerAlb", "C",    1,  0, "Serie de albarán" ,                "",                   "", "( cDbfCol )" } )
   aAdd( aIncAlbPrv, { "nNumAlb", "N",    9,  0, "Número de albarán" ,               "'999999999'",        "", "( cDbfCol )" } )
   aAdd( aIncAlbPrv, { "cSufAlb", "C",    2,  0, "Sufijo de albarán" ,               "",                   "", "( cDbfCol )" } )
   aAdd( aIncAlbPrv, { "cCodTip", "C",    3,  0, "Tipo de incidencia" ,              "",                   "", "( cDbfCol )" } )
   aAdd( aIncAlbPrv, { "dFecInc", "D",    8,  0, "Fecha de la incidencia" ,          "",                   "", "( cDbfCol )" } )
   aAdd( aIncAlbPrv, { "mDesInc", "M",   10,  0, "Descripción de la incidencia" ,    "",                   "", "( cDbfCol )" } )
   aAdd( aIncAlbPrv, { "lListo",  "L",    1,  0, "Lógico de listo" ,                 "",                   "", "( cDbfCol )" } )
   aAdd( aIncAlbPrv, { "lAviso",  "L",    1,  0, "Lógico de aviso" ,                 "",                   "", "( cDbfCol )" } )

return ( aIncAlbPrv )

//---------------------------------------------------------------------------//

function aAlbPrvDoc()

   local aAlbPrvDoc  := {}

   aAdd( aAlbPrvDoc, { "cSerAlb", "C",    1,  0, "Serie del albarán" ,               "",                   "", "( cDbfCol )" } )
   aAdd( aAlbPrvDoc, { "nNumAlb", "N",    9,  0, "Número del albarán" ,              "'999999999'",        "", "( cDbfCol )" } )
   aAdd( aAlbPrvDoc, { "cSufAlb", "C",    2,  0, "Sufijo del albarán" ,              "",                   "", "( cDbfCol )" } )
   aAdd( aAlbPrvDoc, { "cNombre", "C",  240,  0, "Nombre del documento" ,            "",                   "", "( cDbfCol )" } )
   aAdd( aAlbPrvDoc, { "cRuta",   "C",  240,  0, "Ruta del documento" ,              "",                   "", "( cDbfCol )" } )
   aAdd( aAlbPrvDoc, { "mObsDoc", "M",   10,  0, "Observaciones del documento" ,     "",                   "", "( cDbfCol )" } )

return ( aAlbPrvDoc )

//---------------------------------------------------------------------------//

STATIC FUNCTION EndTrans( aTmp, aGet, dbfIva, nDec, nRec, oBrw, nMode, oDlg )

   local aTbl
   local oError
   local oBlock
   local cNumPed
   local cSerAlb
   local nNumAlb
   local cSufAlb
   local dFecAlb
   local aNumPedCli
   local cNumPedPrv
   local aNumPed
   local i

   if Empty( aTmp[ _CSERALB ] )
      aTmp[ _CSERALB ]  := "A"
   end if

   cSerAlb              := aTmp[ _CSERALB ]
   nNumAlb              := aTmp[ _NNUMALB ]
   cSufAlb              := aTmp[ _CSUFALB ]
   dFecAlb              := aTmp[ _DFECALB ]
   cNumPedPrv           := aTmp[ _CNUMPED ]
   aNumPedCli           := {}

   /*
   Comprobamos la fecha del documento------------------------------------------
   */

   if !lValidaOperacion( aTmp[_DFECALB] )
      Return .f.
   end if

   /*
   Estos campos no pueden estar vacios
   */

   if Empty( aTmp[ _CCODPRV ] )
      msgStop( "Código de proveedor no puede estar vacío." )
      aGet[ _CCODPRV ]:SetFocus()
      return .f.
   end if

   if Empty( aTmp[ _CCODCAJ ] )
      msgStop( "Caja no puede estar vacía." )
      aGet[ _CCODCAJ ]:SetFocus()
      return .f.
   end if

   if Empty( aTmp[ _CCODALM ] )
      msgStop( "Almacen no puede estar vacío." )
      aGet[ _CCODALM ]:SetFocus()
      return .f.
   end if

   if ( dbfTmp )->( eof() )
      MsgStop( "No puede almacenar un documento sin líneas." )
      return .f.
   end if

   CursorWait()

   oDlg:Disable()

   oMsgText( "Archivando" )

   oBlock                  := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      BeginTransaction()

      /*
      Primero hacer el RollBack---------------------------------------------------
      */

      aTmp[ _DFECCHG ]     := GetSysDate()
      aTmp[ _CTIMCHG ]     := Time()

      do case
      case nMode == APPD_MODE .or. nMode == DUPL_MODE

         nNumAlb           := nNewDoc( cSerAlb, dbfAlbPrvT, "nAlbPrv", , dbfCount )
         aTmp[ _NNUMALB ]  := nNumAlb

         /*
         if ( aTmp[ _LNUMSER ] .and. aTmp[ _LAUTSER ] )

         end if
         */

      case nMode == EDIT_MODE

         /*
         Resetea los pedidos de proveedores------------------------------------
         */

         while ( dbfAlbPrvL )->( dbSeek( cSerAlb + Str( nNumAlb ) + cSufAlb ) ) .and. !( dbfAlbPrvL )->( eof() )
            if dbLock( dbfAlbPrvL )
               ( dbfAlbPrvL )->( dbDelete() )
               ( dbfAlbPrvL )->( dbUnLock() )
            end if
         end while

         while ( dbfAlbPrvI )->( dbSeek( cSerAlb + Str( nNumAlb ) + cSufAlb ) ) .and. !( dbfAlbPrvI )->( eof() )
            if dbLock( dbfAlbPrvI )
               ( dbfAlbPrvI )->( dbDelete() )
               ( dbfAlbPrvI )->( dbUnLock() )
            end if
         end while

         while ( dbfAlbPrvD )->( dbSeek( cSerAlb + Str( nNumAlb ) + cSufAlb ) ) .and. !( dbfAlbPrvD )->( eof() )
            if dbLock( dbfAlbPrvD )
               ( dbfAlbPrvD )->( dbDelete() )
               ( dbfAlbPrvD )->( dbUnLock() )
            end if
         end while

         while ( dbfAlbPrvS )->( dbSeek( cSerAlb + Str( nNumAlb ) + cSufAlb ) ) .and. !( dbfAlbPrvS )->( eof() )
            if dbLock( dbfAlbPrvS )
               ( dbfAlbPrvS )->( dbDelete() )
               ( dbfAlbPrvS )->( dbUnLock() )
            end if
         end while

      end case

      /*
      Quitamos los filtros-----------------------------------------------------
      */

      ( dbfTmp )->( dbClearFilter() )

      oMsgProgress()
      oMsgProgress():SetRange( 0, ( dbfTmp )->( LastRec() ) )

      /*
      Escritura en el fichero definitivo_______________________________________
      */

      ( dbfTmp )->( dbGoTop() )
      while !( dbfTmp )->( eof() )

         aTbl                                               := dbScatter( dbfTmp )
         aTbl[ _CSERALB ]                                   := cSerAlb
         aTbl[ _NNUMALB ]                                   := nNumAlb
         aTbl[ _CSUFALB ]                                   := cSufAlb
         aTbl[ _LCHGLIN ]                                   := .f.
         aTbl[ _NPRECOM ]                                   := nNetUAlbPrv( aTbl, aTmp, nDinDiv, nDirDiv, aTmp[ _NVDVALB ] )
         aTbl[ ( dbfAlbPrvL )->( FieldPos( "dFecAlb" ) ) ]  := aTmp[ _DFECALB ]

         AppRefPrv( aTbl[ _CREFPRV ], aTmp[ _CCODPRV ], aTbl[ _CREF ], aTbl[ _NDTOLIN ], aTbl[ _NDTOPRM ], aTmp[ _CDIVALB ], aTbl[ _NPREDIV ], dbfArtPrv )

         /*
         Cambios de precios-------------------------------------------------------
         */

         if ( dbfArticulo )->( dbSeek( ( dbfTmp )->cRef ) ) .and. ( dbfTmp )->lChgLin
            CambioPrecio( aTmp[ _DFECALB ], dbfArticulo, dbfTmp )
         end if

         /*
         Grabamos-----------------------------------------------------------------
         */

         dbGather( aTbl, dbfAlbPrvL, .t. )

         ( dbfTmp )->( dbSkip() )

         oMsgProgress():Deltapos( 1 )

      end while

      /*
      Guardamos los totales-------------------------------------------------------
      */

      aTmp[ _NTOTNET ]     := nTotNet
      aTmp[ _NTOTIVA ]     := nTotIva
      aTmp[ _NTOTREQ ]     := nTotReq
      aTmp[ _NTOTALB ]     := nTotAlb

      /*
      Grabamos las cabeceras de los albaranes----------------------------------
      */

      WinGather( aTmp, , dbfAlbPrvT, , nMode )

      /*
      Ponemos el estado al pedido----------------------------------------------
      */

      if !Empty( cNumPedPrv )
         oStock:SetPedPrv( cNumPedPrv )
      end if

      /*
      Ahora escribimos en el fichero definitivo de incidencias-----------------
      */

      ( dbfTmpInc )->( dbGoTop() )
      while ( dbfTmpInc )->( !eof() )
         dbPass( dbfTmpInc, dbfAlbPrvI, .t., cSerAlb, nNumAlb, cSufAlb )
         ( dbfTmpInc )->( dbSkip() )
      end while

      /*
      Escribimos el fichero definitivo de documentos
      */

      ( dbfTmpDoc )->( dbGoTop() )
      while ( dbfTmpDoc )->( !eof() )
         dbPass( dbfTmpDoc, dbfAlbPrvD, .t., cSerAlb, nNumAlb, cSufAlb )
         ( dbfTmpDoc )->( dbSkip() )
      end while

      /*
      Escribimos el fichero definitivo de series
      */

      ( dbfTmpSer )->( dbGoTop() )
      while ( dbfTmpSer )->( !eof() )
         dbPass( dbfTmpSer, dbfAlbPrvS, .t., cSerAlb, nNumAlb, cSufAlb, dFecAlb )
         ( dbfTmpSer )->( dbSkip() )
      end while

      /*
      Actualizamos pedidos de clientes--------------------------------------------
      */

      ( dbfTmp )->( dbGoTop() )
      while !( dbfTmp )->( Eof() )
         if aScan( aNumPedCli, ( dbfTmp )->cNumPed ) == 0
            aAdd( aNumPedCli, ( dbfTmp )->cNumPed )
         end if
         ( dbfTmp )->( dbSkip() )
      end while

      for each cNumPed in aNumPedCli
         oStock:SetRecibidoPedCli( cNumPed )
      next


      /*
      SiAgrupamos ponemos el estado en el pedido-------------------------------
      */

      if Len( aAlbaranes ) != 0

         for each aNumPed in aAlbaranes

            oStock:SetPedPrv( aNumPed[ 3 ] )

            if dbSeekInOrd( aNumPed[ 3 ], "nNumPed", dbfPedPrvT )

               if dbLock( dbfPedPrvT )
                  ( dbfPedPrvT )->cNumAlb    := cSerAlb + Str( nNumAlb ) + cSufAlb
                  ( dbfPedPrvT )->( dbUnLock() )
               end if

            end if

         next

      end if

      /*
      Actualizamos los precios de costo-------------------------------------------
      */

      dbCommitAll()

      CommitTransaction()

   RECOVER USING oError

      RollBackTransaction()

      msgStop( "Imposible guardar el documento" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   oMsgText()
   EndProgress()

   oDlg:Enable()
   oDlg:End( IDOK )

   CursorWE()

return .t.

//------------------------------------------------------------------------//

STATIC FUNCTION KillTrans( oBrwLin, oBrwInc )

   if !Empty( dbfTmp ) .and. ( dbfTmp )->( Used() )
      ( dbfTmp )->( dbCloseArea() )
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

   dbfErase( cNewFile )
   dbfErase( cTmpInc  )
   dbfErase( cTmpDoc  )
   dbfErase( cTmpSer  )

   /*
   Guardamos los posibles cambios en el browse
   */

   if oBrwLin != nil
      oBrwLin:CloseData()
   end if

   if oBrwInc != nil
      oBrwInc:CloseData()
   end if

RETURN NIL

//------------------------------------------------------------------------//

STATIC FUNCTION CreateFiles( cPath )

   if !lExistTable( cPath + "ALBPROVT.DBF" )
      dbCreate( cPath + "ALBPROVT.DBF", aSqlStruct( aItmAlbPrv() ), cDriver() )
   end if

   if !lExistTable( cPath + "ALBPROVL.DBF" )
      dbCreate( cPath + "ALBPROVL.DBF", aSqlStruct( aColAlbPrv() ), cDriver() )
   end if

   if !lExistTable( cPath + "ALBPRVI.DBF" )
      dbCreate( cPath + "ALBPRVI.DBF", aSqlStruct( aIncAlbPrv() ), cDriver() )
   end if

   if !lExistTable( cPath + "ALBPRVD.DBF" )
      dbCreate( cPath + "ALBPRVD.DBF", aSqlStruct( aAlbPrvDoc() ), cDriver() )
   end if

   if !lExistTable( cPath + "ALBPRVS.DBF" )
      dbCreate( cPath + "ALBPRVS.DBF", aSqlStruct( aSerAlbPrv() ), cDriver() )
   end if

RETURN NIL

//-------------------------------------------------------------------------//
/*
Cambia el estado de un albaran
*/

STATIC FUNCTION ChgState( oBrw )

   if dbDialogLock( dbfAlbPrvT )

      ( dbfAlbPrvT )->lFacturado := !( dbfAlbPrvT )->lFacturado
      ( dbfAlbPrvT )->cNumFac    := Space( 12 )
      ( dbfAlbPrvT )->( dbUnlock() )

      /*if ( dbfAlbPrvT )->lFacturado
         oStock:AlbPrv( ( dbfAlbPrvT )->cSerAlb + Str( ( dbfAlbPrvT )->nNumAlb ) + ( dbfAlbPrvT )->cSufAlb, ( dbfAlbPrvT )->cCodAlm, ( dbfAlbPrvT )->cNumPed, .f., .f., .t. )
      else
         oStock:AlbPrv( ( dbfAlbPrvT )->cSerAlb + Str( ( dbfAlbPrvT )->nNumAlb ) + ( dbfAlbPrvT )->cSufAlb, ( dbfAlbPrvT )->cCodAlm, ( dbfAlbPrvT )->cNumPed, .f., .t., .t. )
      end if*/

   end if

   oBrw:Refresh()
   oBrw:SetFocus()

RETURN NIL

//-------------------------------------------------------------------------//


STATIC FUNCTION lMoreIva( nCodIva )

	/*
	Si no esta dentro de los porcentajes anteriores
	*/

	IF _NPCTIVA1 == NIL .OR. _NPCTIVA2 == NIL .OR. _NPCTIVA3 == NIL
		RETURN .T.
	END IF

	IF _NPCTIVA1 == nCodIva .OR. _NPCTIVA2 == nCodIva .OR. _NPCTIVA3 == nCodIva
		RETURN .T.
	END IF

   MsgStop( "Albarán con mas de 3 tipos de " + cImp(), "Imposible añadir" )

RETURN .F.

//---------------------------------------------------------------------------//

/*
Devuelve la fecha de un albaran de proveedor
*/

FUNCTION dFecAlbPrv( cAlbPrv, dbfAlbPrvT )

	local dFecFac	:= CtoD("")

   if ( dbfAlbPrvT )->( dbSeek( cAlbPrv ) )
      dFecFac     := ( dbfAlbPrvT )->dFecAlb
   end if

RETURN ( dFecFac )

//----------------------------------------------------------------------------//

/*
Devuelve el nombre del proveedor de un albaran de proveedor
*/

FUNCTION cNbrAlbPrv( cAlbPrv, dbfAlbPrvT )

   local cNomPrv  := ""

   if ( dbfAlbPrvT )->( dbSeek( cAlbPrv ) )
      cNomPrv     := ( dbfAlbPrvT )->cNomPrv
   end if

RETURN ( cNomPrv )

//----------------------------------------------------------------------------//

/*
Devuelve si el albaran esta facturado
*/

FUNCTION lFacAlbPrv( cAlbPrv, dbfAlbPrvT )

   local lFacAlb  := .f.

   if ( dbfAlbPrvT )->( dbSeek( cAlbPrv ) )
      lFacAlb     := ( dbfAlbPrvT )->lFacturado
   end if

RETURN ( lFacAlb )

//----------------------------------------------------------------------------//
//
// Devuelve el total de la compra en albaranes de proveedores de un articulo
//

function nTotVAlbPrv( cCodArt, dbfAlbPrvL )

   local nTotVta  := 0
   local nRecno   := ( dbfAlbPrvL )->( Recno() )

   if ( dbfAlbPrvL )->( dbSeek( cCodArt ) )

      while ( dbfAlbPrvL )->CREF == cCodArt .and. !( dbfAlbPrvL )->( eof() )

         nTotVta += nTotLAlbPrv( dbfAlbPrvL, 0 )
         ( dbfAlbPrvL )->( dbSkip() )

      end while

   end if

   ( dbfAlbPrvL )->( dbGoTo( nRecno ) )

return ( nTotVta )

//----------------------------------------------------------------------------//
//
// Devuelve el total de unidades de la compra en albaranes de proveedores de un articulo
//

function nTotDAlbPrv( cCodArt, dbfAlbPrvL, dbfAlbPrvT, cCodAlm )

   local lFacAlb  := .f.
   local nTotVta  := 0
   local nRecno   := ( dbfAlbPrvL )->( Recno() )

   if ( dbfAlbPrvL )->( dbSeek( cCodArt ) )

      while ( dbfAlbPrvL )->cRef == cCodArt .and. !( dbfAlbPrvL )->( eof() )

         if dbfAlbPrvT != nil
            lFacAlb     := lFacAlbPrv( ( dbfAlbPrvL )->cSerAlb + Str( ( dbfAlbPrvL )->nNumAlb ) + ( dbfAlbPrvL )->CSUFALB, dbfAlbPrvT )
         end if

         if !lFacAlb
            if cCodAlm != nil
               if cCodAlm == ( dbfAlbPrvL )->cAlmLin
                  nTotVta  += nTotNAlbPrv( dbfAlbPrvL )
               end if
            else
               nTotVta     += nTotNAlbPrv( dbfAlbPrvL )
            end if
         end if

         ( dbfAlbPrvL )->( dbSkip() )

      end while

   end if

   ( dbfAlbPrvL )->( dbGoTo( nRecno ) )

return ( nTotVta )

//---------------------------------------------------------------------------//
//
// Devuelve el precio de compra real de un articulo una vez aplicados los descuentos
//

FUNCTION nPreAlbPrv( dbfAlbPrvL, uTmp, nDec, nRec )

   local cDivAlb
   local nDtoEsp
   local nDtoPp
   local nCalculo := 0

   do case
   case Valtype( uTmp ) == "A"
      cDivAlb     := uTmp[ _CDIVALB ]
      nDtoEsp     := uTmp[ _NDTOESP ]
      nDtoPp      := uTmp[ _NDPP    ]
   case Valtype( uTmp ) == "C"
      cDivAlb     := (uTmp)->CDIVALB
      nDtoEsp     := (uTmp)->NDTOESP
      nDtoPp      := (uTmp)->NDPP
   end case

   DEFAULT nDec   := nDinDiv( cDivAlb, dbfDiv )
   DEFAULT nRec   := nRinDiv( cDivAlb, dbfDiv )

   nCalculo       := nTotLAlbPrv( dbfAlbPrvL, nDec, nRec )

   If nDtoEsp != 0
      nCalculo    -= nCalculo * nDtoEsp / 100
   end if

   If nDtoPp != 0
      nCalculo    -= nCalculo * nDtoPp / 100
   end if

RETURN ( round( nCalculo, nDec ) )

//---------------------------------------------------------------------------//

static function lNotOpen()

   if NetErr()
      MsgStop( 'Imposible abrir ficheros de albaranes de proveedores' )
      CloseFiles()
      return .t.
   end if

return .f.

//---------------------------------------------------------------------------//

static function lGenAlb( oBrw, oBtn, nDevice )

   local bAction

   DEFAULT nDevice   := IS_PRINTER

   if Empty( oBtn )
      return nil
   end if

   if !( dbfDoc )->( dbSeek( "AP" ) )

         DEFINE BTNSHELL RESOURCE "DOCUMENT" OF oWndBrw ;
            NOBORDER ;
            ACTION   ( msgStop( "No hay albaranes de proveedores predefinidos" ) );
            TOOLTIP  "No hay documentos" ;
            HOTKEY   "N";
            FROM     oBtn ;
            CLOSED ;
            LEVEL    ACC_EDIT

   else

      while ( dbfDoc )->cTipo == "AP" .and. !( dbfDoc )->( eof() )

         bAction  := bGenAlb( nDevice, "Imprimiendo albaranes de proveedores", ( dbfDoc )->Codigo )

         oWndBrw:NewAt( "Document", , , bAction, Rtrim( ( dbfDoc )->cDescrip ) , , , , , oBtn )

         ( dbfDoc )->( dbSkip() )

      end do

   end if

   SysRefresh()

return nil

//---------------------------------------------------------------------------//

static function bGenAlb( nDevice, cTitle, cCodDoc )

   local bGen
   local nDev  := by( nDevice )
   local cTit  := by( cTitle  )
   local cCod  := by( cCodDoc )

   if nDev == IS_PRINTER
      bGen     := {|| nGenAlbPrv( nDevice, cTit, cCod ) }
   else
      bGen     := {|| GenAlbPrv( nDevice, cTit, cCod ) }
   end if

return bGen

//---------------------------------------------------------------------------//

static function nCanEnt( dbfAlbPrvL )

return ( If( ( dbfAlbPrvL )->NCANENT != 0, ( dbfAlbPrvL )->NCANENT, 1 ) * ( dbfAlbPrvL )->NUNICAJA )

//---------------------------------------------------------------------------//

FUNCTION Ped2Alb( cNumPed, lZoom )

   local oBlock
   local oError
   local cNumAlb

   DEFAULT lZoom  := .f.

   oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   USE ( cPatEmp() + "ALBPROVT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALBPROVT", @dbfAlbPrvT ) )
   SET ADSINDEX TO ( cPatEmp() + "ALBPROVT.CDX" ) ADDITIVE
   ( dbfAlbPrvT )->( OrdSetFocus( "cNumPed" ) )

   if ( dbfAlbPrvT )->( dbSeek( cNumPed ) )
      cNumAlb     := ( dbfAlbPrvT )->cSerAlb + Str( ( dbfAlbPrvT )->nNumAlb ) + ( dbfAlbPrvT )->cSufAlb
   end if

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos de albaranes de proveedores" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   CLOSE( dbfAlbPrvT )

   if !Empty( cNumAlb )
      if lZoom
         ZooAlbPrv( cNumAlb )
      else
         EdtAlbPrv( cNumAlb )
      end if
   else
      msgStop( "No hay albarán asociado" )
   end if

return NIL

//---------------------------------------------------------------------------//

function nVtaAlbPrv( cCodPrv, dDesde, dHasta, dbfAlbPrvT, dbfAlbPrvL, dbfIva, dbfDiv )

   local nCon     := 0
   local nRec     := ( dbfAlbPrvT )->( Recno() )

   /*
   Facturas a Clientes -------------------------------------------------------
   */

   if ( dbfAlbPrvT )->( dbSeek( cCodPrv ) )

      while ( dbfAlbPrvT )->cCodPrv == cCodPrv .and. !( dbfAlbPrvT )->( Eof() )

         if ( dDesde == nil .or. ( dbfAlbPrvT )->dFecAlb >= dDesde )    .and.;
            ( dHasta == nil .or. ( dbfAlbPrvT )->dFecAlb <= dHasta )

            nCon  += nTotAlbPrv( ( dbfAlbPrvT )->cSerAlb + Str( (dbfAlbPrvT)->nNumAlb ) + (dbfAlbPrvT)->cSufAlb, dbfAlbPrvT, dbfAlbPrvL, dbfIva, dbfDiv, nil, cDivEmp(), .f. )

         end if

         ( dbfAlbPrvT )->( dbSkip() )

      end while

   end if

   ( dbfAlbPrvT )->( dbGoTo( nRec ) )

return nCon

//----------------------------------------------------------------------------//
/*
Calcula el precio teniendo en cuenta el tipo de IGIC
*/

/*STATIC FUNCTION lCalPre( nPreUnt, nBnf, lIva, nIva, oGet, lBnf )

   local nPre  := 0

   if lBnf

      nPre     := nPreUnt * nBnf / 100 + nPreUnt

      /*
      Si lleva IGIC incluido
      */

/*      if lIva
         nPre  += nPre * nIva / 100
      end if

      do case
      case Valtype( oGet ) == "O"
         oGet:cText( nPre )
      case Valtype( oGet ) == "N"
         oGet  := nPre
      end case

   end if

RETURN .T.*/

//--------------------------------------------------------------------------//

/*STATIC FUNCTION lCalBnf( nPreCos, nPreVta, lIva, nIva, oGet, cCodDiv )

	local nBnf
   local nDec     := nDinDiv( cCodDiv, dbfDiv )

	IF nPreVta != 0

		/*
      Si va con IGIC incluido nos quedamos con la base redondeamos a los
		decimales de la divisa
		*/

/*      IF lIva
         nPreVta  := Round( nPreVta / ( 1 + nIva / 100 ), nDec )
		END IF

		nBnf			:= ( ( nPreVta / nPreCos ) - 1 ) * 100

      if nBnf > 0 .AND. nBnf < 1000
         do case
            case Valtype( oGet ) == "O"
               oGet:cText( nBnf )
            case Valtype( oGet ) == "N"
               oGet  := nBnf
         end case
      end if

   end if

RETURN .T.*/

//--------------------------------------------------------------------------//
//
// Carga la situación anterior del articulo
//
/*

STATIC FUNCTION loaAnt( aTmpAlb, oPre, aGet )

   local cCod  := aGet[ _CREF ]:VarGet()

   if ( dbfArticulo )->( dbSeek( cCod ) )

      oPre[  1 ]:SetText( nCnv2Div( ( dbfArticulo )->pCosto, cDivEmp(), aTmpAlb[ _CDIVALB ], dbfDiv, .f. ) )
      oPre[  2 ]:SetText( ( dbfArticulo )->BENEF1   )
      oPre[  3 ]:SetText( if( ( dbfArticulo )->lIvaInc, ( dbfArticulo )->PVTAIVA1, ( dbfArticulo )->PVENTA1 ) )
      oPre[  4 ]:SetText( ( dbfArticulo )->BENEF2   )
      oPre[  5 ]:SetText( if( ( dbfArticulo )->lIvaInc, ( dbfArticulo )->PVTAIVA2, ( dbfArticulo )->PVENTA2 ) )
      oPre[  6 ]:SetText( ( dbfArticulo )->BENEF3   )
      oPre[  7 ]:SetText( if( ( dbfArticulo )->lIvaInc, ( dbfArticulo )->PVTAIVA3, ( dbfArticulo )->PVENTA3 ) )
      oPre[  8 ]:SetText( ( dbfArticulo )->BENEF4   )
      oPre[  9 ]:SetText( if( ( dbfArticulo )->lIvaInc, ( dbfArticulo )->PVTAIVA4, ( dbfArticulo )->PVENTA4 ) )
      oPre[ 10 ]:SetText( ( dbfArticulo )->BENEF5   )
      oPre[ 11 ]:SetText( if( ( dbfArticulo )->lIvaInc, ( dbfArticulo )->PVTAIVA5, ( dbfArticulo )->PVENTA5 ) )
      oPre[ 12 ]:SetText( ( dbfArticulo )->BENEF6   )
      oPre[ 13 ]:SetText( if( ( dbfArticulo )->lIvaInc, ( dbfArticulo )->PVTAIVA6, ( dbfArticulo )->PVENTA6 ) )

   end if

RETURN .T.
*/

//--------------------------------------------------------------------------//

/*FUNCTION DocAlbPrv( dbfDocFld, dbfDocCol )

   /*
   Itmes-----------------------------------------------------------------------
   */

/*   AppDocItm( dbfDocFld, "AP", aItmAlbPrv() )         // Campos
   AppDocCal( dbfDocFld, "AP", aCalAlbPrv() )         // Datos calculados
   AppDocItm( dbfDocFld, "AP", aItmPrv() )      // Proveedores
   AppDocItm( dbfDocFld, "AP", aItmAlm() )      // Almacen
   AppDocItm( dbfDocFld, "AP", aItmDiv() )      // Divisas
   AppDocItm( dbfDocFld, "AP", aItmFPago() )    // Formas de pago

   /*
   Columnas--------------------------------------------------------------------
   */

/*   AppDocItm( dbfDocCol, "AP", aColAlbPrv() )
   AppDocCal( dbfDocCol, "AP", aCocAlbPrv() )

RETURN NIL*/

//---------------------------------------------------------------------------//

static function nTotUnd( uDbf )

   local nTotUnd

   if ValType( uDbf ) == "A"
      nTotUnd  := NotCaja( uDbf[ _NCANENT ] ) * uDbf[ _NUNICAJA ]
   else
      nTotUnd  := NotCaja( ( uDbf )->NCANENT ) * ( uDbf )->NUNICAJA
   end if

return ( nTotUnd )

//---------------------------------------------------------------------------//

/*
Cambia el precio
*/

FUNCTION CambioPrecio( dFecha, dbfArticulo, dbfTmp )

   if dbDialogLock( dbfArticulo )

      if ( dbfTmp )->nPreCom > 0
         ( dbfArticulo )->pCosto    := ( dbfTmp )->nPreCom
      end if

      ( dbfArticulo )->lBnf1        := ( dbfTmp )->lBnfLin1
      ( dbfArticulo )->lBnf2        := ( dbfTmp )->lBnfLin2
      ( dbfArticulo )->lBnf3        := ( dbfTmp )->lBnfLin3
      ( dbfArticulo )->lBnf4        := ( dbfTmp )->lBnfLin4
      ( dbfArticulo )->lBnf5        := ( dbfTmp )->lBnfLin5
      ( dbfArticulo )->lBnf6        := ( dbfTmp )->lBnfLin6

      ( dbfArticulo )->Benef1       := ( dbfTmp )->nBnfLin1
      ( dbfArticulo )->Benef2       := ( dbfTmp )->nBnfLin2
      ( dbfArticulo )->Benef3       := ( dbfTmp )->nBnfLin3
      ( dbfArticulo )->Benef4       := ( dbfTmp )->nBnfLin4
      ( dbfArticulo )->Benef5       := ( dbfTmp )->nBnfLin5
      ( dbfArticulo )->Benef6       := ( dbfTmp )->nBnfLin6

      ( dbfArticulo )->lIvaInc      := ( dbfTmp )->lIvaLin

      ( dbfArticulo )->pVenta1      := ( dbfTmp )->nPvpLin1
      ( dbfArticulo )->pVtaIva1     := ( dbfTmp )->nIvaLin1
      ( dbfArticulo )->pVenta2      := ( dbfTmp )->nPvpLin2
      ( dbfArticulo )->pVtaIva2     := ( dbfTmp )->nIvaLin2
      ( dbfArticulo )->pVenta3      := ( dbfTmp )->nPvpLin3
      ( dbfArticulo )->pVtaIva3     := ( dbfTmp )->nIvaLin3
      ( dbfArticulo )->pVenta4      := ( dbfTmp )->nPvpLin4
      ( dbfArticulo )->pVtaIva4     := ( dbfTmp )->nIvaLin4
      ( dbfArticulo )->pVenta5      := ( dbfTmp )->nPvpLin5
      ( dbfArticulo )->pVtaIva5     := ( dbfTmp )->nIvaLin5
      ( dbfArticulo )->pVenta6      := ( dbfTmp )->nPvpLin6
      ( dbfArticulo )->pVtaIva6     := ( dbfTmp )->nIvaLin6

      /*
      Marca para etiqueta
      */

      ( dbfArticulo )->lLabel       := .t.
      ( dbfArticulo )->nLabel       := Max( ( dbfArticulo )->nLabel, 1 )

      /*
      Marca para el cambio
      */

      ( dbfArticulo )->dFecChg      := date()

      if dFecha >= ( dbfArticulo )->LastIn
         ( dbfArticulo )->LastIn    := dFecha
      end if

      ( dbfArticulo )->lSndDoc      := .t.
      ( dbfArticulo )->LastChg      := GetSysDate()

      /*
      Pasamos tambien la unidad de medición------------------------------------
      */

      ( dbfArticulo )->cUnidad      := ( dbfTmp )->cUnidad

      /*
      Desbloqueo del registro
      */

      ( dbfArticulo )->( dbRUnLock() )

   end if

RETURN NIL

//---------------------------------------------------------------------------//

FUNCTION nTotNAlbPrv( uDbf )

   local nTotUnd

   DEFAULT uDbf   := if( !Empty( tmpAlbPrvL ), tmpAlbPrvL, dbfAlbPrvL )

   do case
      case ValType( uDbf ) == "A"
         nTotUnd  := NotCaja( uDbf[ _NCANENT ] )
         nTotUnd  *= uDbf[ _NUNICAJA ]
         nTotUnd  *= NotCero( uDbf[ _NUNDKIT ] )
         nTotUnd  *= NotCero( uDbf[ _NMEDUNO ] )
         nTotUnd  *= NotCero( uDbf[ _NMEDDOS ] )
         nTotUnd  *= NotCero( uDbf[ _NMEDTRE ] )

      case ValType( uDbf ) == "O"
         nTotUnd  := NotCaja( uDbf:nCanEnt )
         nTotUnd  *= uDbf:nUniCaja
         nTotUnd  *= NotCero( uDbf:nUndKit )
         nTotUnd  *= NotCero( uDbf:nMedUno )
         nTotUnd  *= NotCero( uDbf:nMedDos )
         nTotUnd  *= NotCero( uDbf:nMedTre )

      otherwise
         nTotUnd  := NotCaja( ( uDbf )->nCanEnt )
         nTotUnd  *= ( uDbf )->nUniCaja
         nTotUnd  *= NotCero( ( uDbf )->nUndKit )
         nTotUnd  *= NotCero( ( uDbf )->nMedUno )
         nTotUnd  *= NotCero( ( uDbf )->nMedDos )
         nTotUnd  *= NotCero( ( uDbf )->nMedTre )

   end case

RETURN ( nTotUnd )

//--------------------------------------------------------------------------//

FUNCTION nBrtLAlbPrv( uTmpLin, nDec, nRec, nVdv, cPorDiv )

   local nCalculo    := 0

   DEFAULT nDec      := 2
   DEFAULT nVdv      := 1

   nCalculo          := nTotUAlbPrv( uTmpLin, nDec, nVdv, cPorDiv )
   nCalculo          *= nTotNAlbPrv( uTmpLin )

   nCalculo          := Round( nCalculo / nVdv, nRec )

Return ( if( cPorDiv != nil, Trans( nCalculo, cPorDiv ), nCalculo ) )

//---------------------------------------------------------------------------//

FUNCTION nIvaUAlbPrv( dbfTmp, nDec, nVdv )

   local nCalculo

   DEFAULT nDec   := 0
   DEFAULT nVdv   := 1

   nCalculo       := nTotUAlbPrv( dbfTmp, nDec, nVdv )

   if !( dbfTmp )->lIvaLin
      nCalculo    += nCalculo * ( dbfTmp )->nIva / 100
   end if

   if nVdv != 0
      nCalculo    := nCalculo / nVdv
   end if

RETURN ( Round( nCalculo, nDec ) )

//---------------------------------------------------------------------------//

FUNCTION nIvaLAlbPrv( dbfAlb, dbfLin, nDec, nRou, nVdv, cPorDiv )

   local nCalculo := nImpLAlbPrv( dbfAlb, dbfLin, nDec, nRou, nVdv )

   nCalculo       := Round( nCalculo * ( dbfLin )->nIva / 100, nRou )

RETURN ( if( cPorDiv != nil, Trans( nCalculo, cPorDiv ), nCalculo ) )

//---------------------------------------------------------------------------//
/*
Borra todas las lineas de detalle de un Albarán
*/

Static Function QuiAlbPrv( lDetail )

   local cNumPed
   local aNumPedCli  := {}
   local nRecAnt
   local nOrdAnt
   local nRecPed
   local nOrdPed
   local cNumPedPrv  := ( dbfAlbPrvT )->cNumPed

   DEFAULT lDetail   := .t.

   if ( dbfAlbPrvT )->lCloAlb .and. !oUser():lAdministrador()
      msgStop( "Solo puede eliminar albaranes cerrados los administradores." )
      return .f.
   end if

   CursorWait()

   nRecAnt           := ( dbfAlbPrvL )->( Recno() )
   nOrdAnt           := ( dbfAlbPrvL )->( OrdSetFocus( "nNumAlb" ) )

   if ( dbfAlbPrvL )->( dbSeek( ( dbfAlbPrvT )->cSerAlb + Str( ( dbfAlbPrvT )->nNumAlb ) + ( dbfAlbPrvT )->cSufAlb ) )

      while ( dbfAlbPrvT )->cSerAlb + Str( ( dbfAlbPrvT )->nNumAlb ) + ( dbfAlbPrvT )->cSufAlb == ( dbfAlbPrvL )->cSerAlb + Str( ( dbfAlbPrvL )->nNumAlb ) + ( dbfAlbPrvL )->cSufAlb .and. ;
            !( dbfAlbPrvL )->( Eof() )

         if aScan( aNumPedCli, ( dbfAlbPrvL )->cNumPed ) == 0
            aAdd( aNumPedCli, ( dbfAlbPrvL )->cNumPed )
         end if

         ( dbfAlbPrvL )->( dbSkip() )

      end while

   end if

   ( dbfAlbPrvL )->( OrdSetFocus( nOrdAnt ) )
   ( dbfAlbPrvL )->( dbGoTo( nRecAnt ) )

   /*
   Detalle---------------------------------------------------------------------
   */

   while ( dbfAlbPrvL )->( dbSeek( ( dbfAlbPrvT )->cSerAlb + Str( ( dbfAlbPrvT )->nNumAlb ) + ( dbfAlbPrvT  )->cSufAlb ) ) .and. !( dbfAlbPrvL )->( eof() )

      if dbLock( dbfAlbPrvL )
         ( dbfAlbPrvL )->( dbDelete() )
         ( dbfAlbPrvL )->( dbUnLock() )
      end if

   end while

   /*
   Incidencias-----------------------------------------------------------------
   */

   while ( dbfAlbPrvI )->( dbSeek( ( dbfAlbPrvT )->cSerAlb + Str( ( dbfAlbPrvT )->nNumAlb ) + ( dbfAlbPrvT  )->cSufAlb ) ) .and. !( dbfAlbPrvI )->( eof() )

      if dbLock( dbfAlbPrvI )
         ( dbfAlbPrvI )->( dbDelete() )
         ( dbfAlbPrvI )->( dbUnLock() )
      end if

   end while

   /*
   Documentos------------------------------------------------------------------
   */

   while ( dbfAlbPrvD )->( dbSeek( ( dbfAlbPrvT )->cSerAlb + Str( ( dbfAlbPrvT )->nNumAlb ) + ( dbfAlbPrvT  )->cSufAlb ) ) .and. !( dbfAlbPrvD )->( eof() )

      if dbLock( dbfAlbPrvD )
         ( dbfAlbPrvD )->( dbDelete() )
         ( dbfAlbPrvD )->( dbUnLock() )
      end if

   end while

   /*
   Numeros de serie------------------------------------------------------------
   */

   while ( dbfAlbPrvS )->( dbSeek( ( dbfAlbPrvT )->cSerAlb + Str( ( dbfAlbPrvT )->nNumAlb ) + ( dbfAlbPrvT  )->cSufAlb ) ) .and. !( dbfAlbPrvS )->( eof() )

      if dbLock( dbfAlbPrvS )
         ( dbfAlbPrvS )->( dbDelete() )
         ( dbfAlbPrvS )->( dbUnLock() )
      end if

   end while

   /*
   Estado del pedido de cliente------------------------------------------------
   */

   for each cNumPed in aNumPedCli
      oStock:SetRecibidoPedCli( cNumPed )
   next

   /*
   Estado del pedido si tiramos de uno-----------------------------------------
   */

   if !Empty( cNumPedPrv )
      oStock:SetPedPrv( cNumPedPrv )
   end if

   /*
   Estado de los pedidos cuando es agrupando-----------------------------------
   */

   nRecPed  := ( dbfPedPrvT )->( RecNo() )
   nOrdPed  := ( dbfPedPrvT )->( OrdSetFocus( "cNumAlb" ) )

   if ( dbfPedPrvT )->( dbSeek( ( dbfAlbPrvT )->cSerAlb + Str( ( dbfAlbPrvT )->nNumAlb ) + ( dbfAlbPrvT )->cSufAlb ) )

      while ( dbfPedPrvT )->cNumAlb == ( dbfAlbPrvT )->cSerAlb + Str( ( dbfAlbPrvT )->nNumAlb ) + ( dbfAlbPrvT  )->cSufAlb .and. !( dbfPedPrvT )->( Eof() )

         if dbLock( dbfPedPrvT )
            ( dbfPedPrvT )->cNumAlb    := ""
            ( dbfPedPrvT )->nEstado    := 1
            ( dbfPedPrvT )->( dbUnLock() )
         end if

         oStock:SetPedPrv( ( dbfPedPrvT )->cSerPed + Str( ( dbfPedPrvT )->nNumPed ) + ( dbfPedPrvT )->cSufPed )

         ( dbfPedPrvT )->( dbSkip() )

      end while

   end if

   ( dbfPedPrvT )->( OrdSetFocus( nOrdPed ) )
   ( dbfPedPrvT )->( dbGoTo( nRecPed ) )

   CursorWE()

Return .t.

//--------------------------------------------------------------------------//

function aItmAlbPrv()

   local aItmAlbPrv  := {}

   aAdd( aItmAlbPrv, { "CSERALB",      "C",  1,  0, "Serie del albarán",           "",                   "", "( cDbf )"} )
   aAdd( aItmAlbPrv, { "NNUMALB",      "N",  9,  0, "Número del albarán",          "'999999999'",        "", "( cDbf )"} )
   aAdd( aItmAlbPrv, { "CSUFALB",      "C",  2,  0, "Sufijo de albarán",           "",                   "", "( cDbf )"} )
   aAdd( aItmAlbPrv, { "CTURALB",      "C",  6,  0, "Sesión del albarán",          "",                   "", "( cDbf )"} )
   aAdd( aItmAlbPrv, { "DFECALB",      "D",  8,  0, "Fecha del albarán",           "",                   "", "( cDbf )"} )
   aAdd( aItmAlbPrv, { "CCODPRV",      "C", 12,  0, "Código del proveedor",        "",                   "", "( cDbf )"} )
   aAdd( aItmAlbPrv, { "CCODALM",      "C",  3,  0, "Código de almacén",           "",                   "", "( cDbf )"} )
   aAdd( aItmAlbPrv, { "CCODCAJ",      "C",  3,  0, "Código de caja",              "",                   "", "( cDbf )"} )
   aAdd( aItmAlbPrv, { "CNOMPRV",      "C", 35,  0, "Nombre del proveedor",        "'@!'",               "", "( cDbf )"} )
   aAdd( aItmAlbPrv, { "CDIRPRV",      "C", 35,  0, "Domicilio del proveedor",     "'@!'",               "", "( cDbf )"} )
   aAdd( aItmAlbPrv, { "CPOBPRV",      "C", 25,  0, "Población del proveedor",     "'@!'",               "", "( cDbf )"} )
   aAdd( aItmAlbPrv, { "CPROPRV",      "C", 20,  0, "Provincia del proveedor",     "'@!'",               "", "( cDbf )"} )
   aAdd( aItmAlbPrv, { "CPOSPRV",      "C",  5,  0, "Código postal del proveedor", "",                   "", "( cDbf )"} )
   aAdd( aItmAlbPrv, { "CDNIPRV",      "C", 30,  0, "D.N.I. del proveedor",        "",                   "", "( cDbf )"} )
   aAdd( aItmAlbPrv, { "DFECENT",      "D",  8,  0, "Fecha de entrada",            "",                   "", "( cDbf )"} )
   aAdd( aItmAlbPrv, { "CSUALB",       "C", 12,  0, "Número de su albarán",        "",                   "", "( cDbf )"} )
   aAdd( aItmAlbPrv, { "DSUALB",       "D",  8,  0, "Fecha de su albarán",         "",                   "", "( cDbf )"} )
   aAdd( aItmAlbPrv, { "CCODPGO",      "C",  2,  0, "Código de la forma de pago",  "",                   "", "( cDbf )"} )
   aAdd( aItmAlbPrv, { "NBULTOS",      "N",  3,  0, "Número de bultos",            "'999'",              "", "( cDbf )"} )
   aAdd( aItmAlbPrv, { "NPORTES",      "N",  6,  0, "Precio de los portes",        "'@EZ 999,999'",      "", "( cDbf )"} )
   aAdd( aItmAlbPrv, { "CDTOESP",      "C", 50,  0, "Descripción de descuento factura","",               "", "( cDbf )"} )
   aAdd( aItmAlbPrv, { "NDTOESP",      "N",  6,  2, "Descuento factura",           "'@EZ 99.99'",        "", "( cDbf )"} )
   aAdd( aItmAlbPrv, { "CDPP",         "C", 50,  0, "Descripción de descuento pronto pago","",           "", "( cDbf )"} )
   aAdd( aItmAlbPrv, { "NDPP",         "N",  6,  2, "Descuento pronto pago",       "'@EZ 99.99'",        "", "( cDbf )"} )
   aAdd( aItmAlbPrv, { "LRECARGO",     "L",  1,  0, "Recargo de equivalencia",     "",                   "", "( cDbf )"} )
   aAdd( aItmAlbPrv, { "CCONDENT",     "C", 20,  0, "Comentarios del albarán",     "",                   "", "( cDbf )"} )
   aAdd( aItmAlbPrv, { "CEXPED",       "C", 20,  0, "Expedición",                  "",                   "", "( cDbf )"} )
   aAdd( aItmAlbPrv, { "COBSERV",      "M", 10,  0, "Observaciones",               "",                   "", "( cDbf )"} )
   aAdd( aItmAlbPrv, { "CNUMPED",      "C", 12,  0, "Número del pedido",           "",                   "", "( cDbf )"} )
   aAdd( aItmAlbPrv, { "LFACTURADO",   "L",  1,  0, "Estado del albarán",          "",                   "", "( cDbf )"} )
   aAdd( aItmAlbPrv, { "CNUMFAC",      "C", 12,  0, "Número de la factura",        "",                   "", "( cDbf )"} )
   aAdd( aItmAlbPrv, { "CDIVALB",      "C",  3,  0, "Divisa del albarán",          "",                   "", "( cDbf )"} )
   aAdd( aItmAlbPrv, { "NVDVALB",      "N", 10,  4, "Valor de la divisa",          "'@EZ 999,999.9999'", "", "( cDbf )"} )
   aAdd( aItmAlbPrv, { "LSNDDOC",      "L",  1,  0, "Enviar documento",            "",                   "", "( cDbf )"} )
   aAdd( aItmAlbPrv, { "CDTOUNO",      "C", 25,  0, "Descripción de primer descuento personalizado", "", "", "( cDbf )"} )
   aAdd( aItmAlbPrv, { "NDTOUNO",      "N",  5,  2, "Porcentaje de primer descuento personalizado",  "", "", "( cDbf )"} )
   aAdd( aItmAlbPrv, { "CDTODOS",      "C", 25,  0, "Descripción de segundo descuento personalizado","", "", "( cDbf )"} )
   aAdd( aItmAlbPrv, { "NDTODOS",      "N",  5,  2, "Porcentaje de segundo descuento personalizado", "", "", "( cDbf )"} )
   aAdd( aItmAlbPrv, { "LCLOALB",      "L",  1,  0, "",                            "",                   "", "( cDbf )"} )
   aAdd( aItmAlbPrv, { "CCODUSR",      "C",  3,  0, "Código de usuario",           "",                   "", "( cDbf )"} )
   aAdd( aItmAlbPrv, { "CCODUBIT1",    "C",  5,  0, "",                            "",                   "", "( cDbf )"} )
   aAdd( aItmAlbPrv, { "CCODUBIT2",    "C",  5,  0, "",                            "",                   "", "( cDbf )"} )
   aAdd( aItmAlbPrv, { "CCODUBIT3",    "C",  5,  0, "",                            "",                   "", "( cDbf )"} )
   aAdd( aItmAlbPrv, { "CVALUBIT1",    "C",  5,  0, "",                            "",                   "", "( cDbf )"} )
   aAdd( aItmAlbPrv, { "CVALUBIT2",    "C",  5,  0, "",                            "",                   "", "( cDbf )"} )
   aAdd( aItmAlbPrv, { "CVALUBIT3",    "C",  5,  0, "",                            "",                   "", "( cDbf )"} )
   aAdd( aItmAlbPrv, { "CNOMUBIT1",    "C", 30,  0, "",                            "",                   "", "( cDbf )"} )
   aAdd( aItmAlbPrv, { "CNOMUBIT2",    "C", 30,  0, "",                            "",                   "", "( cDbf )"} )
   aAdd( aItmAlbPrv, { "CNOMUBIT3",    "C", 30,  0, "",                            "",                   "", "( cDbf )"} )
   aAdd( aItmAlbPrv, { "LIMPRIMIDO",   "L",  1,  0, "Lógico de impreso del documento", "",               "", "( cDbf )"} )
   aAdd( aItmAlbPrv, { "DFECIMP",      "D",  8,  0, "Última fecha de impresión del documento", "",       "", "( cDbf )"} )
   aAdd( aItmAlbPrv, { "CHORIMP",      "C",  5,  0, "Hora de la última impresión del documento", "",     "", "( cDbf )"} )
   aAdd( aItmAlbPrv, { "DFECCHG",      "D",  8,  0, "Fecha de modificación del documento", "",           "", "( cDbf )"} )
   aAdd( aItmAlbPrv, { "CTIMCHG",      "C",  5,  0, "Hora de modificación del documento", "",            "", "( cDbf )"} )
   aAdd( aItmAlbPrv, { "CCODDLG",      "C",  2,  0, "Código delegación",           "",                   "", "( cDbf )"} )
   aAdd( aItmAlbPrv, { "nRegIva",      "N",  1,  0, "Regimen de " + cImp(),           "",                   "", "( cDbf )"} )
   aAdd( aItmAlbPrv, { "nTotNet",      "N", 16,  6, "Total neto",                  "",                   "", "( cDbf )"} )
   aAdd( aItmAlbPrv, { "nTotIva",      "N", 16,  6, "Total " + cImp(),                "",                   "", "( cDbf )"} )
   aAdd( aItmAlbPrv, { "nTotReq",      "N", 16,  6, "Total R.E.",                  "",                   "", "( cDbf )"} )
   aAdd( aItmAlbPrv, { "nTotAlb",      "N", 16,  6, "Total albarán",               "",                   "", "( cDbf )"} )

Return ( aItmAlbPrv )

//---------------------------------------------------------------------------//

function aColAlbPrv()

   local aColAlbPrv  := {}

   aAdd( aColAlbPrv, { "CSERALB",      "C",  1,  0, "Serie del albarán",           "",                    "", "( cDbfCol )" } )
   aAdd( aColAlbPrv, { "NNUMALB",      "N",  9,  0, "Número de albarán",           "'999999999'",         "", "( cDbfCol )" } )
   aAdd( aColAlbPrv, { "CSUFALB",      "C",  2,  0, "Sufijo de albarán",           "",                    "", "( cDbfCol )" } )
   aAdd( aColAlbPrv, { "CREF",         "C", 18,  0, "Código de artículo",          "",                    "", "( cDbfCol )" } )
   aAdd( aColAlbPrv, { "CREFPRV",      "C", 18,  0, "Referencia del proveedor",    "",                    "", "( cDbfCol )" } )
   aAdd( aColAlbPrv, { "CDETALLE",     "C",240,  0, "Nombre del artículo",         "",                    "", "( cDbfCol )" } )
   aAdd( aColAlbPrv, { "NIVA",         "N",  6,  2, cImp() + " del artículo",            "'@EZ 999.99'",        "", "( cDbfCol )" } )
   aAdd( aColAlbPrv, { "NUNICAJA",     "N", 16,  6, "Unidades por caja",           "cMasUnd()",           "", "( cDbfCol )" } )
   aAdd( aColAlbPrv, { "NCANENT",      "N", 16,  6, "Cantidad recibida",           "cPirDivAlb",          "", "( cDbfCol )" } )
   aAdd( aColAlbPrv, { "NPREDIV",      "N", 16,  6, "Precio",                      "cPirDivAlb",          "", "( cDbfCol )" } )
   aAdd( aColAlbPrv, { "NCANPED",      "N", 16,  6, "Cajas pedidas",               "cMasUnd()",           "", "( cDbfCol )" } )
   aAdd( aColAlbPrv, { "NUNIPED",      "N", 16,  6, "Unidades pedidas",            "cMasUnd()",           "", "( cDbfCol )" } )
   aAdd( aColAlbPrv, { "CUNIDAD",      "C",  2,  0, cNombreUnidades(),             "'@!'",                "", "( cDbfCol )" } )
   aAdd( aColAlbPrv, { "MLNGDES",      "M", 10,  0, "Descripción de artículo sin codificar", "",          "", "( cDbfCol )" } )
   aAdd( aColAlbPrv, { "NDTOLIN",      "N",  6,  2, "Descuento en líneas",         "'@EZ 999.99'",        "", "( cDbfCol )" } )
   aAdd( aColAlbPrv, { "NDTOPRM",      "N",  6,  2, "Descuento por promociones",   "'@EZ 999.99'",        "", "( cDbfCol )" } )
   aAdd( aColAlbPrv, { "NDTORAP",      "N",  6,  2, "Descuento por rappels",       "'@EZ 999.99'",        "", "( cDbfCol )" } )
   aAdd( aColAlbPrv, { "NPRECOM",      "N", 16,  6, "Precio real de la compra",    "cPinDivAlb",          "", "( cDbfCol )" } )
   aAdd( aColAlbPrv, { "LBNFLIN1",     "L",  1,  0, "",                            "",                    "", "( cDbfCol )" } )
   aAdd( aColAlbPrv, { "LBNFLIN2",     "L",  1,  0, "",                            "",                    "", "( cDbfCol )" } )
   aAdd( aColAlbPrv, { "LBNFLIN3",     "L",  1,  0, "",                            "",                    "", "( cDbfCol )" } )
   aAdd( aColAlbPrv, { "LBNFLIN4",     "L",  1,  0, "",                            "",                    "", "( cDbfCol )" } )
   aAdd( aColAlbPrv, { "LBNFLIN5",     "L",  1,  0, "",                            "",                    "", "( cDbfCol )" } )
   aAdd( aColAlbPrv, { "LBNFLIN6",     "L",  1,  0, "",                            "",                    "", "( cDbfCol )" } )
   aAdd( aColAlbPrv, { "NBNFLIN1",     "N",  6,  2, "",                            "",                    "", "( cDbfCol )" } )
   aAdd( aColAlbPrv, { "NBNFLIN2",     "N",  6,  2, "",                            "",                    "", "( cDbfCol )" } )
   aAdd( aColAlbPrv, { "NBNFLIN3",     "N",  6,  2, "",                            "",                    "", "( cDbfCol )" } )
   aAdd( aColAlbPrv, { "NBNFLIN4",     "N",  6,  2, "",                            "",                    "", "( cDbfCol )" } )
   aAdd( aColAlbPrv, { "NBNFLIN5",     "N",  6,  2, "",                            "",                    "", "( cDbfCol )" } )
   aAdd( aColAlbPrv, { "NBNFLIN6",     "N",  6,  2, "",                            "",                    "", "( cDbfCol )" } )
   aAdd( aColAlbPrv, { "NBNFSBR1",     "N",  1,  0, "",                            "",                    "", "( cDbfCol )" } )
   aAdd( aColAlbPrv, { "NBNFSBR2",     "N",  1,  0, "",                            "",                    "", "( cDbfCol )" } )
   aAdd( aColAlbPrv, { "NBNFSBR3",     "N",  1,  0, "",                            "",                    "", "( cDbfCol )" } )
   aAdd( aColAlbPrv, { "NBNFSBR4",     "N",  1,  0, "",                            "",                    "", "( cDbfCol )" } )
   aAdd( aColAlbPrv, { "NBNFSBR5",     "N",  1,  0, "",                            "",                    "", "( cDbfCol )" } )
   aAdd( aColAlbPrv, { "NBNFSBR6",     "N",  1,  0, "",                            "",                    "", "( cDbfCol )" } )
   aAdd( aColAlbPrv, { "NPVPLIN1",     "N", 16,  6, "",                            "",                    "", "( cDbfCol )" } )
   aAdd( aColAlbPrv, { "NPVPLIN2",     "N", 16,  6, "",                            "",                    "", "( cDbfCol )" } )
   aAdd( aColAlbPrv, { "NPVPLIN3",     "N", 16,  6, "",                            "",                    "", "( cDbfCol )" } )
   aAdd( aColAlbPrv, { "NPVPLIN4",     "N", 16,  6, "",                            "",                    "", "( cDbfCol )" } )
   aAdd( aColAlbPrv, { "NPVPLIN5",     "N", 16,  6, "",                            "",                    "", "( cDbfCol )" } )
   aAdd( aColAlbPrv, { "NPVPLIN6",     "N", 16,  6, "",                            "",                    "", "( cDbfCol )" } )
   aAdd( aColAlbPrv, { "NIVALIN1",     "N", 16,  6, "",                            "",                    "", "( cDbfCol )" } )
   aAdd( aColAlbPrv, { "NIVALIN2",     "N", 16,  6, "",                            "",                    "", "( cDbfCol )" } )
   aAdd( aColAlbPrv, { "NIVALIN3",     "N", 16,  6, "",                            "",                    "", "( cDbfCol )" } )
   aAdd( aColAlbPrv, { "NIVALIN4",     "N", 16,  6, "",                            "",                    "", "( cDbfCol )" } )
   aAdd( aColAlbPrv, { "NIVALIN5",     "N", 16,  6, "",                            "",                    "", "( cDbfCol )" } )
   aAdd( aColAlbPrv, { "NIVALIN6",     "N", 16,  6, "",                            "",                    "", "( cDbfCol )" } )
   aAdd( aColAlbPrv, { "NIVALIN",      "N",  6,  2, "",                            "",                    "", "( cDbfCol )" } )
   aAdd( aColAlbPrv, { "LIVALIN",      "L",  1,  0, "",                            "",                    "", "( cDbfCol )" } )
   aAdd( aColAlbPrv, { "LCHGLIN",      "L",  1,  0, "",                            "",                    "", "( cDbfCol )" } )
   aAdd( aColAlbPrv, { "CCODPR1",      "C", 10,  0, "Código de primera propiedad", "",                    "", "( cDbfCol )" } )
   aAdd( aColAlbPrv, { "CCODPR2",      "C", 10,  0, "Código de segunda propiedad", "",                    "", "( cDbfCol )" } )
   aAdd( aColAlbPrv, { "CVALPR1",      "C", 10,  0, "Valor de primera propiedad",  "",                    "", "( cDbfCol )" } )
   aAdd( aColAlbPrv, { "CVALPR2",      "C", 10,  0, "Valor de segunda propiedad",  "",                    "", "( cDbfCol )" } )
   aAdd( aColAlbPrv, { "NFACCNV",      "N", 13,  4, "Factor de conversión de la compra","",               "", "( cDbfCol )" } )
   aAdd( aColAlbPrv, { "CCODPED",      "C", 12,  0, "Número del pedido",           "",                    "", "( cDbfCol )" } )
   aAdd( aColAlbPrv, { "CALMLIN",      "C",  3,  0, "Código del almacén",          "",                    "", "( cDbfCol )" } )
   aAdd( aColAlbPrv, { "NCTLSTK",      "N",  1,  0, "Tipo de stock de la línea",   "'9'",                 "", "( cDbfCol )" } )
   aAdd( aColAlbPrv, { "LLOTE",        "L",  1,  0, "",                            "",                    "", "( cDbfCol )" } )
   aAdd( aColAlbPrv, { "NLOTE",        "N",  9,  0, "",                            "",                    "", "( cDbfCol )" } )
   aAdd( aColAlbPrv, { "CLOTE",        "C", 12,  0, "Número de lote",              "",                    "", "( cDbfCol )" } )
   aAdd( aColAlbPrv, { "NNUMLIN",      "N",  4,  0, "Número de la línea",          "'9999'",              "", "( cDbfCol )" } )
   aAdd( aColAlbPrv, { "NUNDKIT",      "N", 16,  6, "Unidades del producto kit",   "MasUnd()",            "", "( cDbfCol )" } )
   aAdd( aColAlbPrv, { "LKITART",      "L",  1,  0, "Línea con escandallo",        "",                    "", "( cDbfCol )" } )
   aAdd( aColAlbPrv, { "LKITCHL",      "L",  1,  0, "Línea pertenciente a escandallo",  "",               "", "( cDbfCol )" } )
   aAdd( aColAlbPrv, { "LKITPRC",      "L",  1,  0, "",                            "",                    "", "( cDbfCol )" } )
   aAdd( aColAlbPrv, { "LIMPLIN",      "L",  1,  0, "Imprimir línea",              "",                    "", "( cDbfCol )" } )
   aAdd( aColAlbPrv, { "LCONTROL",     "L",  1,  0, "" ,                           "",                    "", "( cDbfCol )" } )
   aAdd( aColAlbPrv, { "MNUMSER",      "M", 10,  0, "" ,                           "",                    "", "( cDbfCol )" } )
   aAdd( aColAlbPrv, { "NDTO1",        "N",  5,  2, "",                            "",                    "", "( cDbfCol )" } )
   aAdd( aColAlbPrv, { "NDTO2",        "N",  5,  2, "",                            "",                    "", "( cDbfCol )" } )
   aAdd( aColAlbPrv, { "NDTO3",        "N",  5,  2, "",                            "",                    "", "( cDbfCol )" } )
   aAdd( aColAlbPrv, { "NDTO4",        "N",  5,  2, "",                            "",                    "", "( cDbfCol )" } )
   aAdd( aColAlbPrv, { "NDTO5",        "N",  5,  2, "",                            "",                    "", "( cDbfCol )" } )
   aAdd( aColAlbPrv, { "NRAP1",        "N",  5,  2, "",                            "",                    "", "( cDbfCol )" } )
   aAdd( aColAlbPrv, { "NRAP2",        "N",  5,  2, "",                            "",                    "", "( cDbfCol )" } )
   aAdd( aColAlbPrv, { "NRAP3",        "N",  5,  2, "",                            "",                    "", "( cDbfCol )" } )
   aAdd( aColAlbPrv, { "NRAP4",        "N",  5,  2, "",                            "",                    "", "( cDbfCol )" } )
   aAdd( aColAlbPrv, { "NRAP5",        "N",  5,  2, "",                            "",                    "", "( cDbfCol )" } )
   aAdd( aColAlbPrv, { "CCODUBI1",     "C",  5,  0, "",                            "",                    "", "( cDbfCol )" } )
   aAdd( aColAlbPrv, { "CCODUBI2",     "C",  5,  0, "",                            "",                    "", "( cDbfCol )" } )
   aAdd( aColAlbPrv, { "CCODUBI3",     "C",  5,  0, "",                            "",                    "", "( cDbfCol )" } )
   aAdd( aColAlbPrv, { "CVALUBI1",     "C",  5,  0, "",                            "",                    "", "( cDbfCol )" } )
   aAdd( aColAlbPrv, { "CVALUBI2",     "C",  5,  0, "",                            "",                    "", "( cDbfCol )" } )
   aAdd( aColAlbPrv, { "CVALUBI3",     "C",  5,  0, "",                            "",                    "", "( cDbfCol )" } )
   aAdd( aColAlbPrv, { "CNOMUBI1",     "C", 30,  0, "",                            "",                    "", "( cDbfCol )" } )
   aAdd( aColAlbPrv, { "CNOMUBI2",     "C", 30,  0, "",                            "",                    "", "( cDbfCol )" } )
   aAdd( aColAlbPrv, { "CNOMUBI3",     "C", 30,  0, "",                            "",                    "", "( cDbfCol )" } )
   aAdd( aColAlbPrv, { "CCODFAM",      "C", 16,  0, "Código de familia",           "",                    "", "( cDbfCol )" } )
   aAdd( aColAlbPrv, { "CGRPFAM",      "C",  3,  0, "Código del grupo de familia", "",                    "", "( cDbfCol )" } )
   aAdd( aColAlbPrv, { "NREQ",         "N", 16,  6, "Recargo de equivalencia",     "",                    "", "( cDbfCol )" } )
   aAdd( aColAlbPrv, { "MOBSLIN",      "M", 10,  0, "Observación de la línea",     "",                    "", "( cDbfCol )" } )
   aAdd( aColAlbPrv, { "CNUMPED",      "C", 12,  0, "Número del pedido de cliente" , "",                  "", "( cDbfCol )" } )
   aAdd( aColAlbPrv, { "nPvpRec",      "N", 16,  6, "Precio de venta recomendado", "cPirDivAlb",          "", "( cDbfCol )" } )
   aAdd( aColAlbPrv, { "nNumMed",      "N",  1,  0, "Número de mediciones",        "MasUnd()",            "", "( cDbfCol )" } )
   aAdd( aColAlbPrv, { "nMedUno",      "N", 16,  6, "Primera unidad de medición",  "MasUnd()",            "", "( cDbfCol )" } )
   aAdd( aColAlbPrv, { "nMedDos",      "N", 16,  6, "Segunda unidad de medición",  "MasUnd()",            "", "( cDbfCol )" } )
   aAdd( aColAlbPrv, { "nMedTre",      "N", 16,  6, "Tercera unidad de medición",  "MasUnd()",            "", "( cDbfCol )" } )
   aAdd( aColAlbPrv, { "lFacturado",   "L",  1,  0, "Estado del albarán",          "",                    "", "( cDbfCol )" } )
   aAdd( aColAlbPrv, { "dFecCad",      "D",  8,  0, "Fecha de caducidad",          "",                    "", "( cDbfCol )" } )
   aAdd( aColAlbPrv, { "nUndLin",      "N", 16,  6, "",                            "MasUnd()",            "", "( cDbfCol )" } )
   aAdd( aColAlbPrv, { "lLabel",       "L",  1,  0, "Lógico para marca de etiqueta","",                   "", "( cDbfCol )" } )
   aAdd( aColAlbPrv, { "nLabel",       "N",  6,  0, "Unidades de etiquetas a imprimir","",                "", "( cDbfCol )" } )
   aAdd( aColAlbPrv, { "dFecAlb",      "D",  8,  0, "Fecha de albaran",            "",                    "", "( cDbfCol )" } )
   aAdd( aColAlbPrv, { "lNumSer",      "L",  1, 0, "Lógico solicitar numero de serie", "",                "", "( cDbfCol )" } )
   aAdd( aColAlbPrv, { "lAutSer",      "L",  1, 0, "Lógico de autoserializar",     "",                    "", "( cDbfCol )" } )

return ( aColAlbPrv )

//---------------------------------------------------------------------------//

function aSerAlbPrv()

   local aColAlbPrv  := {}

   aAdd( aColAlbPrv,  { "cSerAlb",     "C",  1,   0, "",                                 "",                  "", "(cDbfCol)" } )
   aAdd( aColAlbPrv,  { "nNumAlb",     "N",  9,   0, "",                                 "",                  "", "(cDbfCol)" } )
   aAdd( aColAlbPrv,  { "cSufAlb",     "C",  2,   0, "",                                 "",                  "", "(cDbfCol)" } )
   aAdd( aColAlbPrv,  { "dFecAlb",     "D",  8,   0, "",                                 "",                  "", "(cDbfCol)" } )
   aAdd( aColAlbPrv,  { "nNumLin",     "N",  4,   0, "Número de la línea",               "'9999'",            "", "(cDbfCol)" } )
   aAdd( aColAlbPrv,  { "cRef",        "C", 18,   0, "Referencia del artículo",          "",                  "", "(cDbfCol)" } )
   aAdd( aColAlbPrv,  { "cAlmLin",     "C",  3,   0, "Código de almacen",                "",                  "", "(cDbfCol)" } )
   aAdd( aColAlbPrv,  { "lFacturado",  "L",  1,   0, "Lógico de facturado",              "",                  "", "(cDbfCol)" } )
   aAdd( aColAlbPrv,  { "lUndNeg",     "L",  1,   0, "Lógico de unidades en negativo",   "",                  "", "( cDbfCol )" } )
   aAdd( aColAlbPrv,  { "cNumSer",     "C", 30,   0, "Numero de serie",                  "",                  "", "(cDbfCol)" } )

return ( aColAlbPrv )

//---------------------------------------------------------------------------//

STATIC FUNCTION nClrText( dbfTmp )

   local cClr

   if ( dbfTmp )->lKitChl
      cClr     := CLR_GRAY
   else
      cClr     := CLR_BLACK
   end if

Return cClr

//----------------------------------------------------------------------------//
//
// Unidades recibidas en albaranes de proveedor desde un pedido de cliente
//

function nUnidadesRecibidasPedCli( cPedCli, cCodArt, cValPr1, cValPr2, cRefPrv, cDetalle, dbfAlbPrvL )

   local nRec
   local nOrd
   local nTot        := 0

   DEFAULT cValPr1   := Space( 10 )
   DEFAULT cValPr2   := Space( 10 )

   if IsMuebles()

      nRec           := ( dbfAlbPrvL )->( Recno() )
      nOrd           := ( dbfAlbPrvL )->( OrdSetFocus( "cPedCliDet" ) )

      if ( dbfAlbPrvL )->( dbSeek( cPedCli + cCodArt + cValPr1 + cValPr2 + cRefPrv + cDetalle ) )

         while ( dbfAlbPrvL )->cNumPed + ( dbfAlbPrvL )->cRef + ( dbfAlbPrvL )->cValPr1 + ( dbfAlbPrvL )->cValPr2 + ( dbfAlbPrvL )->cRefPrv + ( dbfAlbPrvL )->cDetalle  == cPedCli + cCodArt + cValPr1 + cValPr2 + cRefPRv + cDetalle .and. !( dbfAlbPrvL )->( eof() )

            nTot     += nTotNAlbPrv( dbfAlbPrvL )

            ( dbfAlbPrvL )->( dbSkip() )

         end while

      end if

      ( dbfAlbPrvL )->( OrdSetFocus( nOrd ) )
      ( dbfAlbPrvL )->( dbGoTo( nRec ) )

   else

      nRec           := ( dbfAlbPrvL )->( Recno() )
      nOrd           := ( dbfAlbPrvL )->( OrdSetFocus( "cPedCliRef" ) )

      if ( dbfAlbPrvL )->( dbSeek( cPedCli + cCodArt + cValPr1 + cValPr2 ) )

         while ( dbfAlbPrvL )->cNumPed + ( dbfAlbPrvL )->cRef + ( dbfAlbPrvL )->cValPr1 + ( dbfAlbPrvL )->cValPr2 == cPedCli + cCodArt + cValPr1 + cValPr2 .and. !( dbfAlbPrvL )->( eof() )

            nTot     += nTotNAlbPrv( dbfAlbPrvL )

            ( dbfAlbPrvL )->( dbSkip() )

         end while

      end if

      ( dbfAlbPrvL )->( OrdSetFocus( nOrd ) )
      ( dbfAlbPrvL )->( dbGoTo( nRec ) )

   end if

return ( nTot )

//-----------------------------------------------------------------------------//

function nUnidadesRecibidasPedPrv( cPedPrv, cCodArt, cValPr1, cValPr2, cRefPrv, cDetalle, dbfAlbPrvL )

   local nRec
   local nOrd
   local nTot        := 0

   DEFAULT cValPr1   := Space( 10 )
   DEFAULT cValPr2   := Space( 10 )

   if IsMuebles()

      nRec           := ( dbfAlbPrvL )->( Recno() )
      nOrd           := ( dbfAlbPrvL )->( OrdSetFocus( "cPedPrvDet" ) )

      if ( dbfAlbPrvL )->( dbSeek( cPedPrv + cCodArt + cValPr1 + cValPr2 + cRefPrv + cDetalle ) )

         while ( dbfAlbPrvL )->cCodPed + ( dbfAlbPrvL )->cRef + ( dbfAlbPrvL )->cValPr1 + ( dbfAlbPrvL )->cValPr2 + ( dbfAlbPrvL )->cRefPrv + ( dbfAlbPrvL )->cDetalle  == cPedPrv + cCodArt + cValPr1 + cValPr2 + cRefPRv + cDetalle .and. !( dbfAlbPrvL )->( eof() )

            nTot     += nTotNAlbPrv( dbfAlbPrvL )

            ( dbfAlbPrvL )->( dbSkip() )

         end while

      end if

      ( dbfAlbPrvL )->( OrdSetFocus( nOrd ) )
      ( dbfAlbPrvL )->( dbGoTo( nRec ) )

   else

      nRec           := ( dbfAlbPrvL )->( Recno() )
      nOrd           := ( dbfAlbPrvL )->( OrdSetFocus( "cPedPrvRef" ) )

      if ( dbfAlbPrvL )->( dbSeek( cPedPrv + cCodArt + cValPr1 + cValPr2 ) )

         while ( dbfAlbPrvL )->cCodPed + ( dbfAlbPrvL )->cRef + ( dbfAlbPrvL )->cValPr1 + ( dbfAlbPrvL )->cValPr2 == cPedPrv + cCodArt + cValPr1 + cValPr2 .and. !( dbfAlbPrvL )->( eof() )

            nTot     += nTotNAlbPrv( dbfAlbPrvL )

            ( dbfAlbPrvL )->( dbSkip() )

         end while

      end if

      ( dbfAlbPrvL )->( OrdSetFocus( nOrd ) )
      ( dbfAlbPrvL )->( dbGoTo( nRec ) )

   end if

return ( nTot )

//-----------------------------------------------------------------------------//

Function SynAlbPrv( cPath )

   local oError
   local oBlock      
   local aTotAlb
   local cNumSer
   local aNumSer
   local nRecPed
   local nOrdPed
   local cPedPrv
   local aPedPrv     := {}

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   dbUseArea( .t., cDriver(), cPath + "ALBPROVT.DBF", cCheckArea( "ALBPROVT", @dbfAlbPrvT ), .f. )
   if !lAIS(); ordListAdd( cPath + "ALBPROVT.CDX" ); else ; ordSetFocus( 1 ) ; end

   dbUseArea( .t., cDriver(), cPath + "ALBPROVL.DBF", cCheckArea( "ALBPROVL", @dbfAlbPrvL ), .f. )
   if !lAIS(); ordListAdd( cPath + "ALBPROVL.CDX" ); else ; ordSetFocus( 1 ) ; end

   dbUseArea( .t., cDriver(), cPath + "ALBPRVS.DBF", cCheckArea( "ALBPRVS", @dbfAlbPrvS ), .f. )
   if !lAIS(); ordListAdd( cPath + "ALBPRVS.CDX" ); else ; ordSetFocus( 1 ) ; end

   dbUseArea( .t., cDriver(), cPath + "ALBPRVI.DBF", cCheckArea( "ALBPRVI", @dbfAlbPrvI ), .f. )
   if !lAIS(); ordListAdd( cPath + "ALBPRVI.CDX" ); else ; ordSetFocus( 1 ) ; end

   dbUseArea( .t., cDriver(), cPatArt() + "FAMILIAS.DBF", cCheckArea( "FAMILIAS", @dbfFamilia ), .f. )
   if !lAIS(); ordListAdd( cPatArt() + "FAMILIAS.CDX" ); else ; ordSetFocus( 1 ) ; end

   dbUseArea( .t., cDriver(), cPatArt() + "ARTICULO.DBF", cCheckArea( "ARTICULO", @dbfArticulo ), .f. )
   if !lAIS(); ordListAdd( cPatArt() + "ARTICULO.CDX" ); else ; ordSetFocus( 1 ) ; end

   dbUseArea( .t., cDriver(), cPatArt() + "PROVART.DBF", cCheckArea( "PROVART", @dbfArtPrv ), .f. )
   if !lAIS(); ordListAdd( cPatArt() + "PROVART.CDX" ); else ; ordSetFocus( 1 ) ; end

   dbUseArea( .t., cDriver(), cPatDat() + "TIVA.DBF", cCheckArea( "TIVA", @dbfIva ), .t. )
   if !lAIS(); ordListAdd( cPatDat() + "TIVA.CDX" ); else ; ordSetFocus( 1 ) ; end

   dbUseArea( .t., cDriver(), cPatDat() + "DIVISAS.DBF", cCheckArea( "DIVISAS", @dbfDiv ), .t. )
   if !lAIS(); ordListAdd( cPatDat() + "DIVISAS.CDX" ); else ; ordSetFocus( 1 ) ; end

   dbUseArea( .t., cDriver(), cPath + "PEDPROVT.DBF", cCheckArea( "PEDPROVT", @dbfPedPrvT ), .f. )
   if !lAIS(); ordListAdd( cPath + "PEDPROVT.CDX" ); else ; ordSetFocus( 1 ) ; end

   dbUseArea( .t., cDriver(), cPath + "PEDPROVL.DBF", cCheckArea( "PEDPROVL", @dbfPedPrvL ), .f. )
   if !lAIS(); ordListAdd( cPath + "PEDPROVL.CDX" ); else ; ordSetFocus( 1 ) ; end

   while !( dbfAlbPrvT )->( eof() )

      if Empty( ( dbfAlbPrvT )->cCodCaj )
         ( dbfAlbPrvT )->cCodCaj := "000"
      end if

      if !( ( dbfAlbPrvT )->cSerAlb >= "A" .and. ( dbfAlbPrvT )->cSerAlb <= "Z" )
         ( dbfAlbPrvT )->( dbDelete() )
      end if

      /*
      Rellenamos los campos de totales-----------------------------------------
      */

      if ( dbfAlbPrvT )->nTotAlb == 0 .and. dbLock( dbfAlbPrvT )

         aTotAlb                 := aTotAlbPrv( ( dbfAlbPrvT )->cSerAlb + Str( ( dbfAlbPrvT )->nNumAlb ) + ( dbfAlbPrvT )->cSufAlb, dbfAlbPrvT, dbfAlbPrvL, dbfIva, dbfDiv, ( dbfAlbPrvT )->cDivAlb )

         ( dbfAlbPrvT )->nTotNet := aTotAlb[ 1 ]
         ( dbfAlbPrvT )->nTotIva := aTotAlb[ 2 ]
         ( dbfAlbPrvT )->nTotReq := aTotAlb[ 3 ]
         ( dbfAlbPrvT )->nTotAlb := aTotAlb[ 4 ]

         ( dbfAlbPrvT )->( dbUnLock() )

      end if

      /*
      Refrescamos el estado del pedido-----------------------------------------
      */

      if !Empty( ( dbfAlbPrvT )->cNumPed )
         oStock:SetPedPrv( ( dbfAlbPrvT )->cNumPed )
      end if

      /*
      Estado de los pedidos cuando es agrupando-----------------------------------
      */

      nRecPed  := ( dbfPedPrvT )->( RecNo() )
      nOrdPed  := ( dbfPedPrvT )->( OrdSetFocus( "cNumAlb" ) )

      if ( dbfPedPrvT )->( dbSeek( ( dbfAlbPrvT )->cSerAlb + Str( ( dbfAlbPrvT )->nNumAlb ) + ( dbfAlbPrvT )->cSufAlb ) )

         while ( dbfPedPrvT )->cNumAlb == ( dbfAlbPrvT )->cSerAlb + Str( ( dbfAlbPrvT )->nNumAlb ) + ( dbfAlbPrvT  )->cSufAlb .and. !( dbfPedPrvT )->( Eof() )
            
            aAdd( aPedPrv, ( dbfPedPrvT )->cSerPed + Str( ( dbfPedPrvT )->nNumPed ) + ( dbfPedPrvT )->cSufPed )

            ( dbfPedPrvT )->( dbSkip() )

         end while

      end if

      ( dbfPedPrvT )->( OrdSetFocus( nOrdPed ) )
      ( dbfPedPrvT )->( dbGoTo( nRecPed ) )

      ( dbfAlbPrvT )->( dbSkip() )

   end while

   while !( dbfAlbPrvL )->( eof() )

      if !( dbfAlbPrvT )->( dbSeek( ( dbfAlbPrvL )->cSerAlb + Str( ( dbfAlbPrvL )->nNumAlb ) + ( dbfAlbPrvL )->cSufAlb ) )

         ( dbfAlbPrvL )->( dbDelete() )

      else

         if Empty( ( dbfAlbPrvL )->cLote ) .and. !Empty( ( dbfAlbPrvL )->nLote )
            ( dbfAlbPrvL )->cLote      := AllTrim( Str( ( dbfAlbPrvL )->nLote ) )
         end if

         if !Empty( ( dbfAlbPrvL )->cRef ) .and. Empty( ( dbfAlbPrvL )->cCodFam )
            ( dbfAlbPrvL )->cCodFam    := RetFamArt( ( dbfAlbPrvL )->cRef, dbfArticulo )
         end if

         if !Empty( ( dbfAlbPrvL )->cRef ) .and. !Empty( ( dbfAlbPrvL )->cCodFam )
            ( dbfAlbPrvL )->cGrpFam    := cGruFam( ( dbfAlbPrvL )->cCodFam, dbfFamilia )
         end if

         if Empty( ( dbfAlbPrvL )->nReq )
            ( dbfAlbPrvL )->nReq       := nPReq( dbfIva, ( dbfAlbPrvL )->nIva )
         end if

         if ( dbfAlbPrvL )->lFacturado != ( dbfAlbPrvT )->lFacturado
            ( dbfAlbPrvL )->lFacturado := ( dbfAlbPrvT )->lFacturado
         end if

         if ( dbfAlbPrvL )->dFecAlb != ( dbfAlbPrvT )->dFecAlb
            ( dbfAlbPrvL )->dFecAlb    := ( dbfAlbPrvT )->dFecAlb
         end if

         if !Empty( ( dbfAlbPrvL )->mNumSer )

            aNumSer                       := hb_aTokens( ( dbfAlbPrvL )->mNumSer, "," )
            for each cNumSer in aNumSer
               ( dbfAlbPrvS )->( dbAppend() )
               ( dbfAlbPrvS )->cSerAlb    := ( dbfAlbPrvL )->cSerAlb
               ( dbfAlbPrvS )->nNumAlb    := ( dbfAlbPrvL )->nNumAlb
               ( dbfAlbPrvS )->cSufAlb    := ( dbfAlbPrvL )->cSufAlb
               ( dbfAlbPrvS )->cRef       := ( dbfAlbPrvL )->cRef
               ( dbfAlbPrvS )->cAlmLin    := ( dbfAlbPrvL )->cAlmLin
               ( dbfAlbPrvS )->nNumLin    := ( dbfAlbPrvL )->nNumLin
               ( dbfAlbPrvS )->lFacturado := ( dbfAlbPrvL )->lFacturado
               ( dbfAlbPrvS )->cNumSer    := cNumSer
            next


            ( dbfAlbPrvL )->mNumSer       := ""

         end if

         AppRefPrv( ( dbfAlbPrvL )->cRefPrv, ( dbfAlbPrvT )->cCodPrv, ( dbfAlbPrvL )->cRef, ( dbfAlbPrvL )->nDtoLin, ( dbfAlbPrvL )->nDtoPrm, ( dbfAlbPrvT )->cDivAlb, ( dbfAlbPrvL )->nPreDiv, dbfArtPrv )

      end if

      ( dbfAlbPrvL )->( dbSkip() )

      SysRefresh()

   end while

   while !( dbfAlbPrvI )->( eof() )

      if !( dbfAlbPrvT )->( dbSeek( ( dbfAlbPrvI )->cSerAlb + Str( ( dbfAlbPrvI )->nNumAlb ) + ( dbfAlbPrvI )->cSufAlb ) )
         ( dbfAlbPrvI )->( dbDelete() )
      end if

      ( dbfAlbPrvI )->( dbSkip() )

      SysRefresh()

   end while

   // Series ---------------------------------------------------------------

   while !( dbfAlbPrvS )->( eof() )

      if !( dbfAlbPrvT )->( dbSeek( ( dbfAlbPrvS )->cSerAlb + Str( ( dbfAlbPrvS )->nNumAlb ) + ( dbfAlbPrvS )->cSufAlb ) )

         ( dbfAlbPrvS )->( dbDelete() )

      else

         if ( dbfAlbPrvS )->dFecAlb != ( dbfAlbPrvT )->dFecAlb
            ( dbfAlbPrvS )->dFecAlb    := ( dbfAlbPrvT )->dFecAlb
         end if

      end if

      ( dbfAlbPrvS )->( dbSkip() )

      SysRefresh()

   end while

   RECOVER USING oError

      msgStop( "Imposible sincronizar albaranes de proveedores" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   if !Empty( dbfAlbPrvT ) .and. ( dbfAlbPrvT )->( Used() )
      ( dbfAlbPrvT )->( dbCloseArea() )
   end if

   if !Empty( dbfAlbPrvL ) .and. ( dbfAlbPrvL )->( Used() )
      ( dbfAlbPrvL )->( dbCloseArea() )
   end if

   if !Empty( dbfAlbPrvI ) .and. ( dbfAlbPrvI )->( Used() )
      ( dbfAlbPrvI )->( dbCloseArea() )
   end if

   if !Empty( dbfAlbPrvS ) .and. ( dbfAlbPrvS )->( Used() )
      ( dbfAlbPrvS )->( dbCloseArea() )
   end if

   if !Empty( dbfArticulo ) .and. ( dbfArticulo )->( Used() )
      ( dbfArticulo )->( dbCloseArea() )
   end if

   if !Empty( dbfFamilia ) .and. ( dbfFamilia )->( Used() )
      ( dbfFamilia )->( dbCloseArea() )
   end if

   if !Empty( dbfArtPrv ) .and. ( dbfArtPrv )->( Used() )
      ( dbfArtPrv )->( dbCloseArea() )
   end if

   if !Empty( dbfIva ) .and. ( dbfIva )->( Used() )
      ( dbfIva )->( dbCloseArea() )
   end if

   if !Empty( dbfDiv ) .and. ( dbfDiv )->( Used() )
      ( dbfDiv )->( dbCloseArea() )
   end if

   if !Empty( dbfPedPrvT ) .and. ( dbfPedPrvT )->( Used() )
      ( dbfPedPrvT )->( dbCloseArea() )
   end if

   if !Empty( dbfPedPrvL ) .and. ( dbfPedPrvL )->( Used() )
      ( dbfPedPrvL )->( dbCloseArea() )
   end if

   /*
   Calculo d stocks------------------------------------------------------------
   */

   oStock               := TStock():Create()
   if oStock:lOpenFiles()

      for each cPedPrv in aPedPrv      
         oStock:SetPedPrv( cPedPrv )
      next

   end if 

   if !Empty( oStock )
      oStock:end()
   end if
 
   oStock      := nil

return nil

//------------------------------------------------------------------------//

CLASS TAlbaranesProveedorSenderReciver FROM TSenderReciverItem

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
   local dbfAlbPrvT
   local dbfAlbPrvL
   local tmpAlbPrvT
   local tmpAlbPrvL
   local cFileName

   if ::oSender:lServer
      cFileName      := "AlbPrv" + StrZero( ::nGetNumberToSend(), 6 ) + ".All"
   else
      cFileName      := "AlbPrv" + StrZero( ::nGetNumberToSend(), 6 ) + "." + RetSufEmp()
   end if

   ::oSender:SetText( "Enviando albaranes a proveedores" )

   oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   USE ( cPatEmp() + "AlbProvT.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "AlbProvT", @dbfAlbPrvT ) )
   SET ADSINDEX TO ( cPatEmp() + "AlbProvT.Cdx" ) ADDITIVE

   USE ( cPatEmp() + "AlbProvL.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "AlbProvL", @dbfAlbPrvL ) )
   SET ADSINDEX TO ( cPatEmp() + "AlbProvL.Cdx" ) ADDITIVE

   /*
   Creamos todas las bases de datos relacionadas con Articulos
   */

   rxAlbPrv( cPatSnd() )

   USE ( cPatSnd() + "AlbProvT.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "AlbProvT", @tmpAlbPrvT ) )
   SET ADSINDEX TO ( cPatSnd() + "AlbProvT.Cdx" ) ADDITIVE

   USE ( cPatSnd() + "AlbProvL.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "AlbProvL", @tmpAlbPrvL ) )
   SET ADSINDEX TO ( cPatSnd() + "AlbProvL.Cdx" ) ADDITIVE

   if !Empty( ::oSender:oMtr )
      ::oSender:oMtr:nTotal := ( dbfAlbPrvT )->( lastrec() )
   end if

   while !( dbfAlbPrvT )->( eof() )

      if ( dbfAlbPrvT )->lSndDoc

         lSnd  := .t.

         dbPass( dbfAlbPrvT, tmpAlbPrvT, .t. )

         ::oSender:SetText( ( dbfAlbPrvT )->cSerAlb + "/" + AllTrim( Str( ( dbfAlbPrvT )->nNumAlb ) ) + "/" + AllTrim( ( dbfAlbPrvT )->cSufAlb ) + "; " + Dtoc( ( dbfAlbPrvT )->dFecAlb ) + "; " + AllTrim( ( dbfAlbPrvT )->cCodPrv ) + "; " + ( dbfAlbPrvT )->cNomPrv )

         if ( dbfAlbPrvL )->( dbSeek( ( dbfAlbPrvT )->cSerAlb + Str( ( dbfAlbPrvT )->nNumAlb ) + ( dbfAlbPrvT )->cSufAlb ) )
            while ( ( dbfAlbPrvL )->cSerAlb + Str( ( dbfAlbPrvL )->nNumAlb ) + ( dbfAlbPrvL )->CSUFAlb ) == ( ( dbfAlbPrvT )->cSerAlb + Str( ( dbfAlbPrvT )->nNumAlb ) + ( dbfAlbPrvT )->CSUFAlb ) .AND. !( dbfAlbPrvL )->( eof() )
               dbPass( dbfAlbPrvL, tmpAlbPrvL, .t. )
               ( dbfAlbPrvL )->( dbSkip() )
            end do
         end if

      end if

      ( dbfAlbPrvT )->( dbSkip() )

      if !Empty( ::oSender:oMtr )
         ::oSender:oMtr:Set( ( dbfAlbPrvT )->( OrdKeyNo() ) )
      end if

   END DO

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos de albaranes de proveedores" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   CLOSE ( dbfAlbPrvT )
   CLOSE ( dbfAlbPrvL )
   CLOSE ( tmpAlbPrvT )
   CLOSE ( tmpAlbPrvL )

   dbfAlbPrvT  := nil
   dbfAlbPrvL  := nil
   tmpAlbPrvT  := nil
   tmpAlbPrvL  := nil

   /*
   Comprimir los archivos------------------------------------------------------
   */

   if lSnd

      ::oSender:SetText( "Comprimiendo albaranes de proveedores" )

      if ::oSender:lZipData( cFileName )
         ::oSender:SetText( "Ficheros comprimidos" )
      else
         ::oSender:SetText( "ERROR al crear fichero comprimido" )
      end if

   else

      ::oSender:SetText( "No hay albaranes de proveedores para enviar" )

   end if

Return ( Self )

//----------------------------------------------------------------------------//

Method RestoreData()

   local oBlock
   local oError
   local dbfAlbPrvT

   if ::lSuccesfullSend

      /*
      Retorna el valor anterior
      */

      oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
      BEGIN SEQUENCE

      USE ( cPatEmp() + "AlbProvT.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "AlbProvT", @dbfAlbPrvT ) )
      SET ADSINDEX TO ( cPatEmp() + "AlbProvT.Cdx" ) ADDITIVE

         lSelectAll( nil, dbfAlbPrvT, "lSndDoc", .f., .t., .f. )

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos de agentes" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

      CLOSE ( dbfAlbPrvT )

   end if

Return ( Self )

//----------------------------------------------------------------------------//

Method SendData()

   local cFileName   := "AlbPrv" + StrZero( ::nGetNumberToSend(), 6 ) + "." + RetSufEmp()

   if file( cPatOut() + cFileName )

      /*
      Enviarlos a internet
      */

      if ftpSndFile( cPatOut() + cFileName, cFileName, 2000, ::oSender )
         ::lSuccesfullSend := .t.
         ::IncNumberToSend()
         ::oSender:SetText( "Fichero enviado " + cFileName  )
      else
         ::oSender:SetText( "ERROR al enviar fichero" )
      end if

   end if

Return ( Self )

//----------------------------------------------------------------------------//

Method ReciveData()

   local n
   local aExt        := aRetDlgEmp()

   /*
   Recibirlo de internet
   */

   ::oSender:SetText( "Recibiendo albaranes de proveedores" )

   for n := 1 to len( aExt )
      ftpGetFiles( "AlbPrv*." + aExt[ n ], cPatIn(), 2000, ::oSender )
   next

   ::oSender:SetText( "Albaranes de proveedores recibidos" )

Return Self

//----------------------------------------------------------------------------//

Method Process()

   local m
   local dbfAlbPrvT
   local dbfAlbPrvL
   local tmpAlbPrvT
   local tmpAlbPrvL
   local aFiles      := Directory( cPatIn() + "AlbPrv*.*" )
   local oBlock
   local oError

   for m := 1 to len( aFiles )

      ::oSender:SetText( "Procesando fichero : " + aFiles[ m, 1 ] )

      oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )

      BEGIN SEQUENCE

      /*
      descomprimimos el fichero
      */

      if ::oSender:lUnZipData( cPatIn() + aFiles[ m, 1 ] )

         dbUseArea(.t., cDriver(), cPatSnd() + "AlbProvT.Dbf", cCheckArea( "AlbProvT", @tmpAlbPrvT ), .f., .t. )
         ( tmpAlbPrvT )->( ordListAdd( cPatSnd() + "AlbProvT.Cdx" ) )

         dbUseArea(.t., cDriver(), cPatSnd() + "AlbProvL.Dbf", cCheckArea( "AlbProvL", @tmpAlbPrvL ), .f., .t. )
         ( tmpAlbPrvL )->( ordListAdd( cPatSnd() + "AlbProvL.Cdx" ) )

         USE ( cPatEmp() + "AlbProvT.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "AlbProvT", @dbfAlbPrvT ) )
         SET ADSINDEX TO ( cPatEmp() + "AlbProvT.Cdx" ) ADDITIVE

         USE ( cPatEmp() + "AlbProvL.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "AlbProvL", @dbfAlbPrvL ) )
         SET ADSINDEX TO ( cPatEmp() + "AlbProvL.Cdx" ) ADDITIVE

         WHILE ( tmpAlbPrvT )->( !eof() )

            /*
            Comprobamos que no exista el pedido en la base de datos
            */

            if lValidaOperacion( ( tmpAlbPrvT )->dFecAlb, .f. ) .and. ;
               !( dbfAlbPrvT )->( dbSeek( ( tmpAlbPrvT )->cSerAlb + Str( ( tmpAlbPrvT )->nNumAlb ) + ( tmpAlbPrvT )->cSufAlb ) )

               dbPass( tmpAlbPrvT, dbfAlbPrvT, .t. )
               ::oSender:SetText( "Añadido     : " + ( tmpAlbPrvT )->cSerAlb + "/" + AllTrim( Str( ( tmpAlbPrvT )->nNumAlb ) ) + "/" + AllTrim( ( tmpAlbPrvT )->cSufAlb ) + "; " + Dtoc( ( tmpAlbPrvT )->dFecAlb ) + "; " + AllTrim( ( dbfAlbPrvT )->cCodPrv ) + "; " + ( dbfAlbPrvT )->cNomPrv )

               if ( tmpAlbPrvL )->( dbSeek( ( tmpAlbPrvT )->cSerAlb + Str( ( tmpAlbPrvT )->nNumAlb ) + ( tmpAlbPrvT )->CSUFAlb ) )

                  do while ( ( tmpAlbPrvL )->cSerAlb + Str( ( tmpAlbPrvL )->nNumAlb ) + ( tmpAlbPrvL )->CSUFAlb ) == ( ( tmpAlbPrvT )->cSerAlb + Str( ( tmpAlbPrvT )->nNumAlb ) + ( tmpAlbPrvT )->CSUFAlb ) .AND. !( tmpAlbPrvL )->( eof() )
                     dbPass( tmpAlbPrvL, dbfAlbPrvL, .t. )
                     ( tmpAlbPrvL )->( dbSkip() )
                  end do

               end if

            else

               ::oSender:SetText( "Desestimado : " + ( tmpAlbPrvT )->cSerAlb + "/" + AllTrim( Str( ( tmpAlbPrvT )->nNumAlb ) ) + "/" + AllTrim( ( tmpAlbPrvT )->cSufAlb ) + "; " + Dtoc( ( tmpAlbPrvT )->dFecAlb ) + "; " + AllTrim( ( dbfAlbPrvT )->cCodPrv ) + "; " + ( dbfAlbPrvT )->cNomPrv )

            end if

            ( tmpAlbPrvT )->( dbSkip() )

         END DO

         CLOSE ( dbfAlbPrvT )
         CLOSE ( dbfAlbPrvL )
         CLOSE ( tmpAlbPrvT )
         CLOSE ( tmpAlbPrvL )

      end if

      ::oSender:AppendFileRecive( aFiles[ m, 1 ] )

      RECOVER USING oError

         CLOSE ( dbfAlbPrvT )
         CLOSE ( dbfAlbPrvL )
         CLOSE ( tmpAlbPrvT )
         CLOSE ( tmpAlbPrvL )

         ::oSender:SetText( "Error procesando fichero " + aFiles[ m, 1 ] )
         ::oSender:SetText( ErrorMessage( oError ) )

      END SEQUENCE

      ErrorBlock( oBlock )

   next

Return Self

//---------------------------------------------------------------------------//

STATIC FUNCTION GrpPed( aGet, aTmp, oBrw )

   local a
   local oDlg
   local nDiv
   local nOrdAnt
   local oBrwLin
   local nNumLin
   local nTotPed
   local nTotRec
   local nTotPdt
   local nItem       := 1
   local nOffSet     := 0
   local cDesAlb     := ""
   local cCodPrv     := aGet[_CCODPRV]:varGet()

   aNumAlb           := {}
   aAlbaranes        := {}

   //Comprueba si hay proveedor seleccionado

   if Empty( cCodPrv )
      msgStop( "Es necesario codificar un proveedor", "Agrupar pedidos" )
      return .t.
   end if

   //Captura en una array los pedidos del proveedor seleccionado
   //Ordena la base de datos de pedidos de proveedores por el codigo de proveedor

   nOrdAnt           := ( dbfPedPrvT )->( ordSetFocus( "CCODPRV" ) )

   //si hay registros los mete en una array

   if !( dbfPedPrvT )->( dbSeek( cCodPrv ) )
       msgStop( "No existen pedidos de este proveedor" )
      RETURN .T.
   else

      do while ( dbfPedPrvT )->cCodPrv == cCodPrv .AND. ( dbfPedPrvT )->( !eof() )

         if ( dbfPedPrvT )->nEstado != 3

            aAdd( aAlbaranes, {  .f. ,;
                                 ( if( ( dbfPedPrvT )->nEstado <= 1, 3, ( dbfPedPrvT )->nEstado ) ),;
                                 ( dbfPedPrvT )->cSerPed + Str( ( dbfPedPrvT )->nNumPed ) + ( dbfPedPrvT )->cSufPed,;
                                 ( dbfPedPrvT )->dFecPed ,;
                                 ( dbfPedPrvT )->cCodPrv ,;
                                 ( dbfPedPrvT )->cNomPrv ,;
                                 ( dbfPedPrvT )->cNumPedCli } )

         endif

         ( dbfPedPrvT )->( dbSkip( 1 ) )

      end do

   end if

   if Len( aAlbaranes ) == 0
      msgStop( "No existen pedidos de este proveedor" )
      return .t.
   end if

   //Ordena la base de datos de pedidos de proveedores por el codigo de proveedor

   ( dbfPedPrvT )->( ordSetFocus( nOrdAnt ) )

   //Abre la caja de dialogo para seleccionar los pedidos a agrupar

   DEFINE DIALOG oDlg RESOURCE "SET_ALBARAN" ;
      TITLE "Seleccionando pedidos de : " + Rtrim( cCodPrv ) + '-' + Rtrim( RetProvee( cCodPrv ) )

      oBrwLin                        := IXBrowse():New( oDlg )

      oBrwLin:bClrSel                := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwLin:bClrSelFocus           := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrwLin:SetArray( aAlbaranes, , , .f. )

      oBrwLin:nMarqueeStyle          := 5
      oBrwLin:lRecordSelector        := .f.
      oBrwLin:lHScroll               := .f.
      oBrwLin:cName                  := "Agrupar pedidos proveedor"

      oBrwLin:bLDblClick             := {|| aAlbaranes[ oBrwLin:nArrayAt, 1 ] := !aAlbaranes[ oBrwLin:nArrayAt, 1 ], oBrwLin:refresh() }

      oBrwLin:CreateFromResource( 130 )

      with object ( oBrwLin:AddCol() )
         :cHeader                   := "Se. seleccionado"
         :bStrData                  := {|| "" }
         :bEditValue                := {|| aAlbaranes[ oBrwLin:nArrayAt, 1 ] }
         :nWidth                    := 20
         :SetCheck( { "Sel16", "Nil16" } )
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader                   := "Es. estado"
         :bStrData                  := {|| "" }
         :bBmpData                  := {|| aAlbaranes[ oBrwLin:nArrayAt, 2 ] }
         :nWidth                    := 20
         :AddResource( "Bullet_Square_Red_16" )
         :AddResource( "Bullet_Square_Yellow_16" )
         :AddResource( "Bullet_Square_Green_16" )
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader                   := "Número"
         :bStrData                  := {|| Trans( aAlbaranes[ oBrwLin:nArrayAt, 3 ], "@R #/999999999/##" ) }
         :nWidth                    := 75
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader                   := "Fecha"
         :bStrData                  := {|| Dtoc( aAlbaranes[ oBrwLin:nArrayAt, 4 ] ) }
         :nWidth                    := 75
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader                   := "Proveedor"
         :bStrData                  := {|| aAlbaranes[ oBrwLin:nArrayAt, 5 ] + Space(1) + aAlbaranes[ oBrwLin:nArrayAt, 6 ] }
         :nWidth                    := 400
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader                   := "Ped. cliente"
         :bStrData                  := {|| Trans( aAlbaranes[ oBrwLin:nArrayAt, 7 ], "@R #/999999999/##" ) }
         :nWidth                    := 75
         :lHide                     := .t.
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader                   := "Cliente"
         :bStrData                  := {|| GetCliente( aAlbaranes[ oBrwLin:nArrayAt, 7 ] ) }
         :nWidth                    := 150
         :lHide                     := .t.
      end with

      REDEFINE BUTTON ;
         ID       514 ;
         OF       oDlg ;
         ACTION   (  aAlbaranes[ oBrwLin:nArrayAt, 1 ] := !aAlbaranes[ oBrwLin:nArrayAt, 1 ],;
                     oBrwLin:refresh(),;
                     oBrwLin:setFocus() )

      REDEFINE BUTTON ;
         ID       516 ;
         OF       oDlg ;
         ACTION   (  aEval( aAlbaranes, { |aItem| aItem[1] := .t. } ),;
                     oBrwLin:refresh(),;
                     oBrwLin:setFocus() )

      REDEFINE BUTTON ;
         ID       517 ;
         OF       oDlg ;
         ACTION   (  aEval( aAlbaranes, { |aItem| aItem[1] := .f. } ),;
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

   oDlg:AddFastKey( VK_F5, {|| oDlg:end( IDOK ) } )

   oDlg:bStart       := {|| oBrwLin:Load() }

   ACTIVATE DIALOG oDlg CENTER

   if oDlg:nResult != IDOK
      aAlbaranes  := {}
   end if

   //Llamda a la funcion que busca el Pedido

   IF oDlg:nResult == IDOK .AND. Len( aAlbaranes ) >= 1

      //A¤adimos los pedidos seleccionados para despues

      for nItem := 1 to Len( aAlbaranes )
         if ( aAlbaranes[ nItem, 1 ] )
            aAdd( aNumAlb, aAlbaranes[ nItem, 3 ] )
         end if
      next

      FOR nItem := 1 TO Len( aAlbaranes )

         //Cabeceras de pedidos a albaranes

         IF ( dbfPedPrvT )->( dbSeek( aAlbaranes[ nItem, 3] ) ) .AND. aAlbaranes[ nItem, 1]

            if ( dbfPedPrvT )->lRecargo
               aTmp[ _LRECARGO ] := .t.
               aGet[ _LRECARGO ]:Refresh()
            end if

         END IF

         //Detalle de pedidos a albaranes

         IF ( dbfPedPrvL )->( dbSeek( aAlbaranes[ nItem, 3] ) ) .AND. aAlbaranes[ nItem, 1]

            //Cabeceras de pedidos

            ++nOffSet
            nNumLin              := nil

            if lNumPed()
            (dbfTmp)->( dbAppend() )
            cDesAlb              := "Pedido Nº " + Alltrim( Trans( aAlbaranes[ nItem, 3 ], "@R #/999999999/##" ) )
            cDesAlb              += " - Fecha " + Dtoc( aAlbaranes[ nItem, 4] )
            (dbfTmp)->mLngDes    := cDesAlb
            (dbfTmp)->lControl   := .t.
            (dbfTmp)->nNumLin    := nOffSet
            end if

            //Mientras estemos en el mismo pedido pasamos los datos al albarán

            WHILE ( ( dbfPedPrvL )->cSerPed + Str( ( dbfPedPrvL )->nNumPed ) + ( dbfPedPrvL )->cSufPed == aAlbaranes[ nItem, 3 ] )

               if aAlbaranes[ nItem, 2 ] == 2

                  nTotPed              := nTotNPedPrv( dbfPedPrvL )
                  nTotRec              := nUnidadesRecibidasPedPrv( aAlbaranes[ nItem, 3 ], ( dbfPedPrvL )->cRef, ( dbfPedPrvL )->cCodPr1, ( dbfPedPrvL )->cCodPr2, ( dbfPedPrvL )->cRefPrv, ( dbfPedPrvL )->cDetalle, dbfAlbPrvL )
                  nTotPdt              := nTotPed - nTotRec

                  if nTotPdt > 0

                     if nNumLin != (dbfPedPrvL)->nNumLin
                        ++nOffSet
                        nNumLin           := (dbfPedPrvL)->nNumLin
                     end if

                     (dbfTmp)->( dbAppend() )
                     (dbfTmp)->nNumAlb    := 0
                     (dbfTmp)->nNumLin    := nOffSet
                     (dbfTmp)->cRef       := (dbfPedPrvL)->cRef
                     (dbfTmp)->cRefPrv    := (dbfPedPrvL)->cRefPrv
                     (dbfTmp)->cDetalle   := (dbfPedPrvL)->cDetalle
                     (dbfTmp)->mLngDes    := (dbfPedPrvL)->mLngDes
                     (dbfTmp)->nPreDiv    := (dbfPedPrvL)->nPreDiv
                     (dbfTmp)->cUnidad    := (dbfPedPrvL)->cUnidad
                     (dbfTmp)->nIva       := (dbfPedPrvL)->nIva
                     (dbfTmp)->nReq       := (dbfPedPrvL)->nReq
                     (dbfTmp)->nDtoLin    := (dbfPedPrvL)->nDtoLin
                     (dbfTmp)->nDtoPrm    := (dbfPedPrvL)->nDtoPrm
                     (dbfTmp)->cCodPed    := aAlbaranes[ nItem, 3]
                     (dbfTmp)->nUndKit    := (dbfPedPrvL)->nUndKit
                     (dbfTmp)->lKitArt    := (dbfPedPrvL)->lKitArt
                     (dbfTmp)->lKitChl    := (dbfPedPrvL)->lKitChl
                     (dbfTmp)->lKitPrc    := (dbfPedPrvL)->lKitPrc
                     (dbfTmp)->lImpLin    := (dbfPedPrvL)->lImpLin
                     (dbfTmp)->cCodPr1    := (dbfPedPrvL)->cCodPr1
                     (dbfTmp)->cCodPr2    := (dbfPedPrvL)->cCodPr2
                     (dbfTmp)->cValPr1    := (dbfPedPrvL)->cValPr1
                     (dbfTmp)->cValPr2    := (dbfPedPrvL)->cValPr2
                     (dbfTmp)->nCanPed    := (dbfPedPrvL)->nCanPed
                     (dbfTmp)->nDtoRap    := (dbfPedPrvL)->nDtoRap
                     (dbfTmp)->mNumSer    := (dbfPedPrvL)->mNumSer
                     (dbfTmp)->lLote      := (dbfPedPrvL)->lLote
                     (dbfTmp)->nLote      := (dbfPedPrvL)->nLote
                     (dbfTmp)->cLote      := (dbfPedPrvL)->cLote
                     (dbfTmp)->nFacCnv    := (dbfPedPrvL)->nFacCnv
                     (dbfTmp)->cAlmLin    := (dbfPedPrvL)->cAlmLin
                     (dbfTmp)->nCtlStk    := (dbfPedPrvL)->nCtlStk
                     (dbfTmp)->lControl   := (dbfPedPrvL)->lControl
                     (dbfTmp)->cNumPed    := aAlbaranes[ nItem, 7 ]
                     (dbfTmp)->cUnidad    := (dbfPedPrvL)->cUnidad
                     (dbfTmp)->nNumMed    := (dbfPedPrvL)->nNumMed
                     (dbfTmp)->nMedUno    := (dbfPedPrvL)->nMedUno
                     (dbfTmp)->nMedDos    := (dbfPedPrvL)->nMedDos
                     (dbfTmp)->nMedTre    := (dbfPedPrvL)->nMedTre

                     if dbSeekInOrd( ( dbfPedPrvL )->cRef, "Codigo", dbfArticulo )

                        ( dbfTmp )->lIvaLin  := ( dbfArticulo )->lIvaInc

                        ( dbfTmp )->nBnfLin1 := ( dbfArticulo )->Benef1
                        ( dbfTmp )->nBnfLin2 := ( dbfArticulo )->Benef2
                        ( dbfTmp )->nBnfLin3 := ( dbfArticulo )->Benef3
                        ( dbfTmp )->nBnfLin4 := ( dbfArticulo )->Benef4
                        ( dbfTmp )->nBnfLin5 := ( dbfArticulo )->Benef5
                        ( dbfTmp )->nBnfLin6 := ( dbfArticulo )->Benef6

                        ( dbfTmp )->lBnfLin1 := ( dbfArticulo )->lBnf1
                        ( dbfTmp )->lBnfLin2 := ( dbfArticulo )->lBnf2
                        ( dbfTmp )->lBnfLin3 := ( dbfArticulo )->lBnf3
                        ( dbfTmp )->lBnfLin4 := ( dbfArticulo )->lBnf4
                        ( dbfTmp )->lBnfLin5 := ( dbfArticulo )->lBnf5
                        ( dbfTmp )->lBnfLin6 := ( dbfArticulo )->lBnf6

                        ( dbfTmp )->nBnfSbr1 := ( dbfArticulo )->nBnfSbr1
                        ( dbfTmp )->nBnfSbr2 := ( dbfArticulo )->nBnfSbr2
                        ( dbfTmp )->nBnfSbr3 := ( dbfArticulo )->nBnfSbr3
                        ( dbfTmp )->nBnfSbr4 := ( dbfArticulo )->nBnfSbr4
                        ( dbfTmp )->nBnfSbr5 := ( dbfArticulo )->nBnfSbr5
                        ( dbfTmp )->nBnfSbr6 := ( dbfArticulo )->nBnfSbr6

                        ( dbfTmp )->nPvpLin1 := ( dbfarticulo )->pVenta1
                        ( dbfTmp )->nPvpLin2 := ( dbfArticulo )->pVenta2
                        ( dbfTmp )->nPvpLin3 := ( dbfArticulo )->pVenta3
                        ( dbfTmp )->nPvpLin4 := ( dbfArticulo )->pVenta4
                        ( dbfTmp )->nPvpLin5 := ( dbfArticulo )->pVenta5
                        ( dbfTmp )->nPvpLin6 := ( dbfArticulo )->pVenta6

                        ( dbfTmp )->nIvaLin1 := ( dbfArticulo )->pVtaIva1
                        ( dbfTmp )->nIvaLin2 := ( dbfArticulo )->pVtaIva2
                        ( dbfTmp )->nIvaLin3 := ( dbfArticulo )->pVtaIva3
                        ( dbfTmp )->nIvaLin4 := ( dbfArticulo )->pVtaIva4
                        ( dbfTmp )->nIvaLin5 := ( dbfArticulo )->pVtaIva5
                        ( dbfTmp )->nIvaLin6 := ( dbfArticulo )->pVtaIva6

                     end if


                  if lCalCaj()

                     if nTotRec != 0

                        nDiv  := Mod( nTotPdt, ( dbfPedPrvL )->nUniCaja )
                        if nDiv == 0 .and. ( dbfPedPrvL )->nCanPed != 0
                           ( dbfTmp )->nCanEnt  := Div( nTotPdt, ( dbfPedPrvL )->nUniCaja )
                           ( dbfTmp )->nUniCaja := ( dbfPedPrvL )->nUniCaja
                        else
                           ( dbfTmp )->nCanEnt  := 0
                           ( dbfTmp )->nUniCaja := nTotPdt
                        end if

                     else

                        ( dbfTmp )->nCanEnt     := ( dbfPedPrvL )->nCanPed
                        ( dbfTmp )->nUniCaja    := ( dbfPedPrvL )->nUniCaja

                     end if

                  else

                     ( dbfTmp )->nUniCaja       := nTotPdt

                  end if

                  end if

               else

                  if nNumLin != (dbfPedPrvL)->nNumLin
                     ++nOffSet
                     nNumLin           := (dbfPedPrvL)->nNumLin
                  end if

                  (dbfTmp)->( dbAppend() )
                  (dbfTmp)->nNumAlb    := 0
                  (dbfTmp)->nNumLin    := nOffSet
                  (dbfTmp)->cRef       := (dbfPedPrvL)->cRef
                  (dbfTmp)->cRefPrv    := (dbfPedPrvL)->cRefPrv
                  (dbfTmp)->cDetalle   := (dbfPedPrvL)->cDetalle
                  (dbfTmp)->mLngDes    := (dbfPedPrvL)->mLngDes
                  (dbfTmp)->nPreDiv    := (dbfPedPrvL)->nPreDiv
                  (dbfTmp)->cUnidad    := (dbfPedPrvL)->cUnidad
                  (dbfTmp)->nIva       := (dbfpedPrvl)->nIva
                  (dbfTmp)->nReq       := (dbfpedPrvl)->nReq
                  (dbfTmp)->nDtoLin    := (dbfpedPrvl)->nDtoLin
                  (dbfTmp)->nDtoPrm    := (dbfPedPrvL)->nDtoPrm
                  (dbfTmp)->cCodPed    := aAlbaranes[ nItem, 3]
                  (dbfTmp)->nUniCaja   := (dbfPedPrvL)->nUniCaja
                  (dbfTmp)->nCanEnt    := (dbfPedPrvL)->nCanEnt
                  (dbfTmp)->nUndKit    := (dbfPedPrvL)->nUndKit
                  (dbfTmp)->lKitArt    := (dbfPedPrvL)->lKitArt
                  (dbfTmp)->lKitChl    := (dbfPedPrvL)->lKitChl
                  (dbfTmp)->lKitPrc    := (dbfPedPrvL)->lKitPrc
                  (dbfTmp)->lImpLin    := (dbfPedPrvL)->lImpLin
                  (dbfTmp)->cCodPr1    := (dbfPedPrvL)->cCodPr1
                  (dbfTmp)->cCodPr2    := (dbfPedPrvL)->cCodPr2
                  (dbfTmp)->cValPr1    := (dbfPedPrvL)->cValPr1
                  (dbfTmp)->cValPr2    := (dbfPedPrvL)->cValPr2
                  (dbfTmp)->nCanPed    := (dbfPedPrvL)->nCanPed
                  (dbfTmp)->nDtoRap    := (dbfPedPrvL)->nDtoRap
                  (dbfTmp)->mNumSer    := (dbfPedPrvL)->mNumSer
                  (dbfTmp)->lLote      := (dbfPedPrvL)->lLote
                  (dbfTmp)->nLote      := (dbfPedPrvL)->nLote
                  (dbfTmp)->cLote      := (dbfPedPrvL)->cLote
                  (dbfTmp)->nFacCnv    := (dbfPedPrvL)->nFacCnv
                  (dbfTmp)->cAlmLin    := (dbfPedPrvL)->cAlmLin
                  (dbfTmp)->nCtlStk    := (dbfPedPrvL)->nCtlStk
                  (dbfTmp)->lControl   := (dbfPedPrvL)->lControl
                  (dbfTmp)->mObsLin    := (dbfPedPrvL)->mObsLin
                  (dbfTmp)->cNumPed    := aAlbaranes[ nItem, 7 ]
                  (dbfTmp)->cUnidad    := (dbfPedPrvL)->cUnidad
                  (dbfTmp)->nNumMed    := (dbfPedPrvL)->nNumMed
                  (dbfTmp)->nMedUno    := (dbfPedPrvL)->nMedUno
                  (dbfTmp)->nMedDos    := (dbfPedPrvL)->nMedDos
                  (dbfTmp)->nMedTre    := (dbfPedPrvL)->nMedTre

                  if dbSeekInOrd( ( dbfPedPrvL )->cRef, "Codigo", dbfArticulo )

                     ( dbfTmp )->lIvaLin  := ( dbfArticulo )->lIvaInc

                     ( dbfTmp )->nBnfLin1 := ( dbfArticulo )->Benef1
                     ( dbfTmp )->nBnfLin2 := ( dbfArticulo )->Benef2
                     ( dbfTmp )->nBnfLin3 := ( dbfArticulo )->Benef3
                     ( dbfTmp )->nBnfLin4 := ( dbfArticulo )->Benef4
                     ( dbfTmp )->nBnfLin5 := ( dbfArticulo )->Benef5
                     ( dbfTmp )->nBnfLin6 := ( dbfArticulo )->Benef6

                     ( dbfTmp )->lBnfLin1 := ( dbfArticulo )->lBnf1
                     ( dbfTmp )->lBnfLin2 := ( dbfArticulo )->lBnf2
                     ( dbfTmp )->lBnfLin3 := ( dbfArticulo )->lBnf3
                     ( dbfTmp )->lBnfLin4 := ( dbfArticulo )->lBnf4
                     ( dbfTmp )->lBnfLin5 := ( dbfArticulo )->lBnf5
                     ( dbfTmp )->lBnfLin6 := ( dbfArticulo )->lBnf6

                     ( dbfTmp )->nBnfSbr1 := ( dbfArticulo )->nBnfSbr1
                     ( dbfTmp )->nBnfSbr2 := ( dbfArticulo )->nBnfSbr2
                     ( dbfTmp )->nBnfSbr3 := ( dbfArticulo )->nBnfSbr3
                     ( dbfTmp )->nBnfSbr4 := ( dbfArticulo )->nBnfSbr4
                     ( dbfTmp )->nBnfSbr5 := ( dbfArticulo )->nBnfSbr5
                     ( dbfTmp )->nBnfSbr6 := ( dbfArticulo )->nBnfSbr6

                     ( dbfTmp )->nPvpLin1 := ( dbfarticulo )->pVenta1
                     ( dbfTmp )->nPvpLin2 := ( dbfArticulo )->pVenta2
                     ( dbfTmp )->nPvpLin3 := ( dbfArticulo )->pVenta3
                     ( dbfTmp )->nPvpLin4 := ( dbfArticulo )->pVenta4
                     ( dbfTmp )->nPvpLin5 := ( dbfArticulo )->pVenta5
                     ( dbfTmp )->nPvpLin6 := ( dbfArticulo )->pVenta6

                     ( dbfTmp )->nIvaLin1 := ( dbfArticulo )->pVtaIva1
                     ( dbfTmp )->nIvaLin2 := ( dbfArticulo )->pVtaIva2
                     ( dbfTmp )->nIvaLin3 := ( dbfArticulo )->pVtaIva3
                     ( dbfTmp )->nIvaLin4 := ( dbfArticulo )->pVtaIva4
                     ( dbfTmp )->nIvaLin5 := ( dbfArticulo )->pVtaIva5
                     ( dbfTmp )->nIvaLin6 := ( dbfArticulo )->pVtaIva6

                  end if

               end if

               ( dbfPedPrvL )->( dbSkip( 1 ) )

            END WHILE

            ( dbfTmp )->( dbGoTop() )

            //refrescamos el brws
            oBrw:refresh()

         END IF

      NEXT

      //No dejamos importar pedidos directos

      aGet[_CNUMPED]:Disable()

      //Recalculo de totales

      nTotAlbPrv( nil, dbfAlbPrvT, dbfTmp, dbfIva, dbfDiv, aTmp )

  END IF

RETURN .T.

//---------------------------------------------------------------------------//

Static Function nEstadoIncidencia( cNumAlb )

   local nEstado  := 0

   if ( dbfAlbPrvI )->( dbSeek( cNumAlb ) )

      while ( dbfAlbPrvI )->cSerAlb + Str( ( dbfAlbPrvI )->nNumAlb ) + ( dbfAlbPrvI )->cSufAlb == cNumAlb .and. !( dbfAlbPrvI )->( Eof() )

         if ( dbfAlbPrvI )->lListo
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

         ( dbfAlbPrvI )->( dbSkip() )

      end while

   end if

Return ( nEstado )

//---------------------------------------------------------------------------//

Function AppAlbPrv( cCodPrv, cCodArt, lOpenBrowse )

   local nLevel         := nLevelUsr( _MENUITEM_ )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) != 0 .or. nAnd( nLevel, ACC_APPD ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if lOpenBrowse

      if AlbPrv( nil, nil, cCodPrv, cCodArt )
         oWndBrw:RecAdd()
      end if

   else

      if OpenFiles( .t. )
         WinAppRec( nil, bEdtRec, dbfAlbPrvT, cCodPrv, cCodArt )
         CloseFiles()
      end if

   end if

RETURN .t.

//----------------------------------------------------------------------------//

FUNCTION EdtAlbPrv( nNumAlb, lOpenBrowse )

   local nLevel         := nLevelUsr( _MENUITEM_ )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) != 0 .or. nAnd( nLevel, ACC_EDIT ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if lOpenBrowse

      if AlbPrv()
         if dbSeekInOrd( nNumAlb, "nNumAlb", dbfAlbPrvT )
            oWndBrw:RecEdit()
         else
            MsgStop( "No se encuentra albaran" )
         end if
      end if

   else

      if OpenFiles( .t. )
         if dbSeekInOrd( nNumAlb, "nNumAlb", dbfAlbPrvT )
            WinEdtRec( nil, bEdtRec, dbfAlbPrvT )
         else
            MsgStop( "No se encuentra albaran" )
         end if
         CloseFiles()
      end if

   end if

RETURN NIL

//----------------------------------------------------------------------------//

FUNCTION ZooAlbPrv( nNumAlb, lOpenBrowse )

   local nLevel         := nLevelUsr( _MENUITEM_ )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) != 0 .or. nAnd( nLevel, ACC_ZOOM ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if lOpenBrowse

      if AlbPrv()
         if dbSeekInOrd( nNumAlb, "nNumAlb", dbfAlbPrvT )
            oWndBrw:RecZoom()
         else
            MsgStop( "No se encuentra albaran" )
         end if
      end if

   else

      if OpenFiles( .t. )
         if dbSeekInOrd( nNumAlb, "nNumAlb", dbfAlbPrvT )
            WinZooRec( nil, bEdtRec, dbfAlbPrvT )
         else
            MsgStop( "No se encuentra albaran" )
         end if
         CloseFiles()
      end if

   end if

RETURN NIL

//----------------------------------------------------------------------------//

FUNCTION DelAlbPrv( nNumAlb, lOpenBrowse )

   local nLevel         := nLevelUsr( _MENUITEM_ )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) != 0 .or. nAnd( nLevel, ACC_ZOOM ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if lOpenBrowse

      if AlbPrv()
         if dbSeekInOrd( nNumAlb, "nNumAlb", dbfAlbPrvT )
            WinDelRec( nil, dbfAlbPrvT, {|| QuiAlbPrv() } )
         else
            MsgStop( "No se encuentra albaran" )
         end if
      end if

   else

      if OpenFiles( .t. )
         if dbSeekInOrd( nNumAlb, "nNumAlb", dbfAlbPrvT )
            WinDelRec( nil, dbfAlbPrvT, {|| QuiAlbPrv() } )
         else
            MsgStop( "No se encuentra albaran" )
         end if
         CloseFiles()
      end if

   end if

Return nil

//----------------------------------------------------------------------------//

FUNCTION PrnAlbPrv( nNumAlb, lOpenBrowse )

   local nLevel         := nLevelUsr( _MENUITEM_ )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) != 0 .or. nAnd( nLevel, ACC_ZOOM ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if lOpenBrowse

      if AlbPrv()
         if dbSeekInOrd( nNumAlb, "nNumAlb", dbfAlbPrvT )
            GenAlbPrv( IS_PRINTER )
         else
            MsgStop( "No se encuentra albaran" )
         end if
      end if

   else

      if OpenFiles( .t. )
         if dbSeekInOrd( nNumAlb, "nNumAlb", dbfAlbPrvT )
            GenAlbPrv( IS_PRINTER )
         else
            MsgStop( "No se encuentra albaran" )
         end if
         CloseFiles()
      end if

   end if

RETURN NIL

//---------------------------------------------------------------------------//

FUNCTION VisAlbPrv( nNumAlb, lOpenBrowse )

   local nLevel         := nLevelUsr( _MENUITEM_ )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) != 0 .or. nAnd( nLevel, ACC_ZOOM ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if lOpenBrowse

      if AlbPrv()
         if dbSeekInOrd( nNumAlb, "nNumAlb", dbfAlbPrvT )
            GenAlbPrv( IS_SCREEN )
         else
            MsgStop( "No se encuentra albaran" )
         end if
      end if

   else

      if OpenFiles( .t. )
         if dbSeekInOrd( nNumAlb, "nNumAlb", dbfAlbPrvT )
            GenAlbPrv( IS_SCREEN )
         else
            MsgStop( "No se encuentra albaran" )
         end if
         CloseFiles()
      end if

   end if

Return nil

//---------------------------------------------------------------------------//

Static Function GetCliente( cNumPed )

   local oBlock
   local oError
   local cCliente := ""
   local dbfPedCliT

   oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   USE ( cPatEmp() + "PEDCLIT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PEDCLIT", @dbfPedCliT ) )
   SET ADSINDEX TO ( cPatEmp() + "PEDCLIT.CDX" ) ADDITIVE
   ( dbfPedCliT )->( OrdSetFocus( "NNUMPED" ) )

   if ( dbfPedCliT )->( dbSeek( cNumPed ) )

      cCliente := AllTrim( ( dbfPedCliT )->cCodCli ) + " - " + AllTrim( ( dbfPedCliT )->cNomCli )

   end if

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos de agentes" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   CLOSE( dbfPedCliT )

Return cCliente

//----------------------------------------------------------------------------//

STATIC FUNCTION ValidaMedicion( aTmp, aGet )

   local cNewUndMed  := aGet[ _CUNIDAD ]:VarGet

   /*
   Cargamos el codigo de las unidades---------------------------------
   */

   if ( Empty( cOldUndMed ) .or. cOldUndMed != cNewUndMed )

      if oUndMedicion:oDbf:Seek( aTmp[ _CUNIDAD ] )

         if oUndMedicion:oDbf:nDimension >= 1 .and. !Empty( oUndMedicion:oDbf:cTextoDim1 )
            if !Empty( aGet[ ( dbfAlbPrvL )->( fieldpos( "nMedUno" ) ) ] )
               aGet[ ( dbfAlbPrvL )->( fieldpos( "nMedUno" ) ) ]:oSay:SetText( oUndMedicion:oDbf:cTextoDim1 )
               aGet[ ( dbfAlbPrvL )->( fieldpos( "nMedUno" ) ) ]:cText( ( dbfArticulo )->nLngArt )
               aGet[ ( dbfAlbPrvL )->( fieldpos( "nMedUno" ) ) ]:Show()
            else
               aTmp[ ( dbfAlbPrvL )->( fieldpos( "nMedUno" ) ) ]  := ( dbfArticulo )->nLngArt
            end if
         else
            if !Empty( aGet[ ( dbfAlbPrvL )->( fieldpos( "nMedUno" ) ) ] )
               aGet[ ( dbfAlbPrvL )->( fieldpos( "nMedUno" ) ) ]:cText( 0 )
               aGet[ ( dbfAlbPrvL )->( fieldpos( "nMedUno" ) ) ]:Hide()
            else
               aTmp[ ( dbfAlbPrvL )->( fieldpos( "nMedUno" ) ) ]  := 0
            end if
         end if

         if oUndMedicion:oDbf:nDimension >= 2 .and. !Empty( oUndMedicion:oDbf:cTextoDim2 )
            if !Empty( aGet[ ( dbfAlbPrvL )->( fieldpos( "nMedDos" ) ) ] )
               aGet[ ( dbfAlbPrvL )->( fieldpos( "nMedDos" ) ) ]:oSay:SetText( oUndMedicion:oDbf:cTextoDim2 )
               aGet[ ( dbfAlbPrvL )->( fieldpos( "nMedDos" ) ) ]:cText( ( dbfArticulo )->nAltArt )
               aGet[ ( dbfAlbPrvL )->( fieldpos( "nMedDos" ) ) ]:Show()
            else
               aTmp[ ( dbfAlbPrvL )->( fieldpos( "nMedDos" ) ) ]  := ( dbfArticulo )->nAltArt
            end if

         else
            if !Empty( aGet[ ( dbfAlbPrvL )->( fieldpos( "nMedDos" ) ) ] )
               aGet[ ( dbfAlbPrvL )->( fieldpos( "nMedDos" ) ) ]:cText( 0 )
               aGet[ ( dbfAlbPrvL )->( fieldpos( "nMedDos" ) ) ]:Hide()
            else
                 aTmp[ ( dbfAlbPrvL )->( fieldpos( "nMedDos" ) ) ]  := 0
            end if
         end if

         if oUndMedicion:oDbf:nDimension >= 3 .and. !Empty( oUndMedicion:oDbf:cTextoDim3 )
            if !Empty( aGet[ ( dbfAlbPrvL )->( fieldpos( "nMedTre" ) ) ] )
               aGet[ ( dbfAlbPrvL )->( fieldpos( "nMedTre" ) ) ]:oSay:SetText( oUndMedicion:oDbf:cTextoDim3 )
               aGet[ ( dbfAlbPrvL )->( fieldpos( "nMedTre" ) ) ]:cText( ( dbfArticulo ) ->nAncArt )
               aGet[ ( dbfAlbPrvL )->( fieldpos( "nMedTre" ) ) ]:Show()
            else
               aTmp[ ( dbfAlbPrvL )->( fieldpos( "nMedTre" ) ) ]  := ( dbfArticulo )->nAncArt
            end if
         else
            if !Empty( aGet[ ( dbfAlbPrvL )->( fieldpos( "nMedTre" ) ) ] )
               aGet[ ( dbfAlbPrvL )->( fieldpos( "nMedTre" ) ) ]:cText( 0 )
               aGet[ ( dbfAlbPrvL )->( fieldpos( "nMedTre" ) ) ]:Hide()
            else
               aTmp[ ( dbfAlbPrvL )->( fieldpos( "nMedTre" ) ) ]  := 0
            end if
         end if

      else

         if !Empty( aGet[ ( dbfAlbPrvL )->( fieldpos( "nMedUno" ) ) ] )
            aGet[ ( dbfAlbPrvL )->( fieldpos( "nMedUno" ) ) ]:Hide()
            aGet[ ( dbfAlbPrvL )->( fieldpos( "nMedUno" ) ) ]:cText( 0 )
         end if

         if !Empty( aGet[ ( dbfAlbPrvL )->( fieldpos( "nMedDos" ) ) ] )
            aGet[ ( dbfAlbPrvL )->( fieldpos( "nMedDos" ) ) ]:Hide()
            aGet[ ( dbfAlbPrvL )->( fieldpos( "nMedDos" ) ) ]:cText( 0 )
         end if

         if !Empty( aGet[ ( dbfAlbPrvL )->( fieldpos( "nMedTre" ) ) ] )
            aGet[ ( dbfAlbPrvL )->( fieldpos( "nMedTre" ) ) ]:Hide()
            aGet[ ( dbfAlbPrvL )->( fieldpos( "nMedTre" ) ) ]:cText( 0 )
         end if

      end if

      cOldUndMed := cNewUndMed

   end if

RETURN .t.

//-------------------------------------------------------------------------//

FUNCTION SetFacturadoAlbaranProveedor( lFacturado, oStock, oBrw, cAlbPrvT, cAlbPrvL, cAlbPrvS, cNumFac )

   local nRec
   local nOrd

   DEFAULT lFacturado   := .f.
   DEFAULT cNumFac      := Space( 12 )
   DEFAULT cAlbPrvT     := dbfAlbPrvT
   DEFAULT cAlbPrvL     := dbfAlbPrvL
   DEFAULT cAlbPrvS     := dbfAlbPrvS

   CursorWait()

   /*
   Cambiamos las cabeceras-----------------------------------------------------
   */

   if dbDialogLock( cAlbPrvT )

      ( cAlbPrvT )->lFacturado := lFacturado
      ( cAlbPrvT )->cNumFac    := cNumFac
      ( cAlbPrvT )->( dbUnlock() )

   end if

   /*
   Cambiamos el estado en las lineas-------------------------------------------
   */

   nRec                 := ( cAlbPrvL )->( Recno() )
   nOrd                 := ( cAlbPrvL )->( OrdSetFocus( "nNumAlb" ) )

   if ( cAlbPrvL )->( dbSeek( ( cAlbPrvT )->cSerAlb + Str( ( cAlbPrvT )->nNumAlb ) + ( cAlbPrvT )->cSufAlb ) )

      while ( cAlbPrvT )->cSerAlb + Str( ( cAlbPrvT )->nNumAlb ) + ( cAlbPrvT )->cSufAlb == ( cAlbPrvL )->cSerAlb + Str( ( cAlbPrvL )->nNumAlb ) + ( cAlbPrvL )->cSufAlb .and. !( cAlbPrvL )->( Eof() )

         if dbDialogLock( cAlbPrvL )
            ( cAlbPrvL )->lFacturado := lFacturado
            ( cAlbPrvL )->( dbUnlock() )
          end if

         ( cAlbPrvL )->( dbSkip() )

      end while

   end if

   ( cAlbPrvL )->( OrdSetFocus( nOrd ) )
   ( cAlbPrvL )->( dbGoTo( nRec ) )

   /*
   Cambiamos el estado de las series-------------------------------------------
   */

   nRec                 := ( cAlbPrvS )->( Recno() )
   nOrd                 := ( cAlbPrvS )->( OrdSetFocus( "nNumAlb" ) )

   if ( cAlbPrvS )->( dbSeek( ( cAlbPrvT )->cSerAlb + Str( ( cAlbPrvT )->nNumAlb ) + ( cAlbPrvT )->cSufAlb ) )

      while ( cAlbPrvT )->cSerAlb + Str( ( cAlbPrvT )->nNumAlb ) + ( cAlbPrvT )->cSufAlb == ( cAlbPrvS )->cSerAlb + Str( ( cAlbPrvS )->nNumAlb ) + ( cAlbPrvS )->cSufAlb .and. !( cAlbPrvS )->( Eof() )

         if dbDialogLock( cAlbPrvS )
            ( cAlbPrvS )->lFacturado := lFacturado
            ( cAlbPrvS )->( dbUnlock() )
          end if

         ( cAlbPrvS )->( dbSkip() )

      end while

   end if

   ( cAlbPrvS )->( OrdSetFocus( nOrd ) )
   ( cAlbPrvS )->( dbGoTo( nRec ) )

   CursorWE()

   /*
   Refrescamos el browse si lo hubiese-----------------------------------------
   */

   if oBrw != nil
      oBrw:Refresh()
      oBrw:SetFocus()
   end if

RETURN NIL

//---------------------------------------------------------------------------//

Function IsAlbPrv( cPath )

   DEFAULT cPath  := cPatEmp()

   if !lExistTable( cPath + "AlbProvT.Dbf" )
      dbCreate( cPath + "AlbProvT.Dbf", aSqlStruct( aItmAlbPrv() ), cDriver() )
   end if

   if !lExistTable( cPath + "AlbProvL.Dbf" )
      dbCreate( cPath + "AlbProvL.Dbf", aSqlStruct( aColAlbPrv() ), cDriver() )
   end if

   if !lExistTable( cPath + "AlbPrvI.Dbf" )
      dbCreate( cPath + "AlbPrvI.Dbf", aSqlStruct( aIncAlbPrv() ), cDriver() )
   end if

   if !lExistTable( cPath + "AlbPrvD.Dbf" )
      dbCreate( cPath + "AlbPrvD.Dbf", aSqlStruct( aAlbPrvDoc() ), cDriver() )
   end if

   if !lExistTable( cPath + "AlbPrvS.Dbf" )
      dbCreate( cPath + "AlbPrvS.Dbf", aSqlStruct( aSerAlbPrv() ), cDriver() )
   end if

   if !lExistIndex( cPath + "AlbProvT.Cdx" ) .or. ;
      !lExistIndex( cPath + "AlbProvL.Cdx" ) .or. ;
      !lExistIndex( cPath + "AlbPrvI.Cdx" )  .or. ;
      !lExistIndex( cPath + "AlbPrvD.Cdx" )  .or. ;
      !lExistIndex( cPath + "AlbPrvS.Cdx" )

      rxAlbPrv( cPath )

   end if

Return ( nil )

//---------------------------------------------------------------------------//

FUNCTION cCodAlbPrv( cAlbPrvL )

   local cReturn     := ""

   DEFAULT cAlbPrvL  := if( !Empty( tmpAlbPrvL ), tmpAlbPrvL, dbfAlbPrvL )

   cReturn           += Alltrim( ( cAlbPrvL )->cRef )

   if !Empty( ( cAlbPrvL )->cValPr1 )
      cReturn        += "."
      cReturn        += Alltrim( ( cAlbPrvL )->cValPr1 )
   end if

   if !Empty( ( cAlbPrvL )->cValPr2 )
      cReturn        += "."
      cReturn        += Alltrim( ( cAlbPrvL )->cValPr2 )
   end if

RETURN ( cReturn )

//---------------------------------------------------------------------------//

FUNCTION cDesAlbPrv( cAlbPrvL, cAlbPrvS )

   DEFAULT cAlbPrvL  := dbfAlbPrvL
   DEFAULT cAlbPrvS  := dbfAlbPrvS

RETURN ( Descrip( cAlbPrvL, cAlbPrvS ) )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS TAlbaranProveedoresLabelGenerator

   Data oDlg
   Data oFld

   Data nRecno

   Data oSerieInicio
   Data cSerieInicio

   Data oSerieFin
   Data cSerieFin

   Data nDocumentoInicio
   Data nDocumentoFin

   Data cSufijoInicio
   Data cSufijoFin

   Data oFormatoLabel
   Data cFormatoLabel

   Data cPrinter

   Data nFilaInicio
   Data nColumnaInicio

   Data oBrwLabel

   Data nCantidadLabels
   Data nUnidadesLabels

   Data oMtrLabel
   Data nMtrLabel

   Data oFilter

   Data lClose

   Data lErrorOnCreate

   Data oBtnListado
   Data oBtnFilter
   Data oBtnSiguiente
   Data oBtnAnterior
   Data oBtnCancel

   Data aSearch

   Data cFileTmpLabel
   Data cAreaTmpLabel

   Method New()
   Method Init()

   Method Create()
   Method lCreateAuxiliar()
   Method DestroyAuxiliar()

   Method lCreateTemporal()
   Method PrepareTemporal( oFr )
   Method DestroyTemporal()

   Method End()

   Method BotonAnterior()

   Method BotonSiguiente()

   Method PutLabel()

   Method SelectAllLabels()

   Method AddLabel()

   Method DelLabel()

   Method EditLabel()

   Method FilterLabel()

   Method LoadAuxiliar()

   Method lPrintLabels()

   Method InitLabel( oLabel )

   Method SelectColumn( oCombo )

END CLASS

//----------------------------------------------------------------------------//

Method New() CLASS TAlbaranProveedoresLabelGenerator

   local oError
   local oBlock

   oBlock                  := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      ::nRecno             := ( dbfAlbPrvT )->( Recno() )

      ::cSerieInicio       := ( dbfAlbPrvT )->cSerAlb
      ::cSerieFin          := ( dbfAlbPrvT )->cSerAlb

      ::nDocumentoInicio   := ( dbfAlbPrvT )->nNumAlb
      ::nDocumentoFin      := ( dbfAlbPrvT )->nNumAlb

      ::cSufijoInicio      := ( dbfAlbPrvT )->cSufAlb
      ::cSufijoFin         := ( dbfAlbPrvT )->cSufAlb

      ::cFormatoLabel      := GetPvProfString( "Etiquetas", "Albaran proveedor", Space( 3 ), cPatEmp() + "Empresa.Ini" )
      if len( ::cFormatoLabel ) < 3
         ::cFormatoLabel   := Space( 3 )
      end if

      ::nMtrLabel          := 0

      ::nFilaInicio        := 1
      ::nColumnaInicio     := 1

      ::nCantidadLabels    := 1
      ::nUnidadesLabels    := 1

      ::aSearch            := { "Código", "Nombre" }

      ::lErrorOnCreate     := .f.

   RECOVER USING oError

      ::lErrorOnCreate     := .t.

      msgStop( "Error en la creación de generador de etiquetas" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE
   ErrorBlock( oBlock )

Return ( Self )

//--------------------------------------------------------------------------//

Method Init() CLASS TAlbaranProveedoresLabelGenerator

   local oError
   local oBlock
   local lError            := .f.

   oBlock                  := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      if !lOpenFiles
         OpenFiles()
         ::lClose          := .t.
      end if

      ::cSerieInicio       := ( dbfAlbPrvT )->cSerAlb
      ::cSerieFin          := ( dbfAlbPrvT )->cSerAlb

      ::nDocumentoInicio   := ( dbfAlbPrvT )->nNumAlb
      ::nDocumentoFin      := ( dbfAlbPrvT )->nNumAlb

      ::cSufijoInicio      := ( dbfAlbPrvT )->cSufAlb
      ::cSufijoFin         := ( dbfAlbPrvT )->cSufAlb

      ::nCantidadLabels    := 1
      ::nUnidadesLabels    := 1

      ::lErrorOnCreate     := .f.

   RECOVER USING oError

      ::lErrorOnCreate     := .t.

      msgStop( "Error en la creación de generador de etiquetas" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE
   ErrorBlock( oBlock )

Return ( Self )

//--------------------------------------------------------------------------//

Method Create() CLASS TAlbaranProveedoresLabelGenerator

   local oBtnPrp
   local oBtnMod
   local oBtnZoo
   local oGetOrd
   local cGetOrd     := Space( 100 )
	local oCbxOrd
   local cCbxOrd     := "Código"
   local aCbxOrd     := { "Código", "Nombre" }

   ::New()

   if !::lErrorOnCreate .and. ::lCreateAuxiliar()

      DEFINE DIALOG ::oDlg RESOURCE "SelectLabels_0"

         REDEFINE PAGES ::oFld ;
            ID       10;
            OF       ::oDlg ;
            DIALOGS  "SelectLabels_1",;
                     "SelectLabels_2"

         /*
         Bitmap-------------------------------------------------------------------
         */

         REDEFINE BITMAP ;
            RESOURCE "EnvioEtiquetas" ;
            ID       500 ;
            OF       ::oDlg ;

         REDEFINE GET ::oSerieInicio VAR ::cSerieInicio ;
            ID       100 ;
            PICTURE  "@!" ;
            SPINNER ;
            ON UP    ( UpSerie( ::oSerieInicio ) );
            ON DOWN  ( DwSerie( ::oSerieInicio ) );
            VALID    ( ::cSerieInicio >= "A" .and. ::cSerieInicio <= "Z" );
            UPDATE ;
            OF       ::oFld:aDialogs[ 1 ]

         REDEFINE GET ::oSerieFin VAR ::cSerieFin ;
            ID       110 ;
            PICTURE  "@!" ;
            SPINNER ;
            ON UP    ( UpSerie( ::oSerieFin ) );
            ON DOWN  ( DwSerie( ::oSerieFin ) );
            VALID    ( ::cSerieFin >= "A" .and. ::cSerieFin <= "Z" );
            UPDATE ;
            OF       ::oFld:aDialogs[ 1 ]

         REDEFINE GET ::nDocumentoInicio ;
            ID       120 ;
            PICTURE  "999999999" ;
            SPINNER ;
            OF       ::oFld:aDialogs[ 1 ]

         REDEFINE GET ::nDocumentoFin ;
            ID       130 ;
            PICTURE  "999999999" ;
            SPINNER ;
            OF       ::oFld:aDialogs[ 1 ]

         REDEFINE GET ::cSufijoInicio ;
            ID       140 ;
            PICTURE  "##" ;
            OF       ::oFld:aDialogs[ 1 ]

         REDEFINE GET ::cSufijoFin ;
            ID       150 ;
            PICTURE  "##" ;
            OF       ::oFld:aDialogs[ 1 ]

         REDEFINE GET ::nFilaInicio ;
            ID       180 ;
            PICTURE  "999" ;
            SPINNER ;
            OF       ::oFld:aDialogs[ 1 ]

         REDEFINE GET ::nColumnaInicio ;
            ID       190 ;
            PICTURE  "999" ;
            SPINNER ;
            OF       ::oFld:aDialogs[ 1 ]

         REDEFINE GET ::oFormatoLabel VAR ::cFormatoLabel ;
            ID       160 ;
            IDTEXT   161 ;
            BITMAP   "LUPA" ;
            OF       ::oFld:aDialogs[ 1 ]

            ::oFormatoLabel:bValid  := {|| cDocumento( ::oFormatoLabel, ::oFormatoLabel:oHelpText, dbfDoc, "AL" ) }
            ::oFormatoLabel:bHelp   := {|| BrwDocumento( ::oFormatoLabel, ::oFormatoLabel:oHelpText, "AL" ) }

         TBtnBmp():ReDefine( 220, "Printer_pencil_16",,,,, {|| EdtDocumento( ::cFormatoLabel ) }, ::oFld:aDialogs[ 1 ], .f., , .f., "Modificar formato de etiquetas" )

         REDEFINE RADIO ::nCantidadLabels ;
            ID       200, 201 ;
            OF       ::oFld:aDialogs[ 1 ]

         REDEFINE GET ::nUnidadesLabels ;
            ID       210 ;
            PICTURE  "99999" ;
            SPINNER ;
            MIN      1 ;
            MAX      99999 ;
            WHEN     ( ::nCantidadLabels == 2 ) ;
            OF       ::oFld:aDialogs[ 1 ]

         /*
         Segunda caja de dialogo--------------------------------------------------
         */

         REDEFINE GET oGetOrd ;
            VAR      cGetOrd ;
            ID       200 ;
            BITMAP   "FIND" ;
            OF       ::oFld:aDialogs[ 2 ]

         oGetOrd:bChange   := {| nKey, nFlags, oGet | AutoSeek( nKey, nFlags, oGet, ::oBrwLabel, ::cAreaTmpLabel ) }
         oGetOrd:bValid    := {|| ( ::cAreaTmpLabel )->( OrdScope( 0, nil ) ), ( ::cAreaTmpLabel )->( OrdScope( 1, nil ) ), ::oBrwLabel:Refresh(), .t. }

         REDEFINE COMBOBOX oCbxOrd ;
            VAR      cCbxOrd ;
            ID       210 ;
            ITEMS    aCbxOrd ;
            OF       ::oFld:aDialogs[ 2 ]

         oCbxOrd:bChange   := {|| ::SelectColumn( oCbxOrd ) }

         REDEFINE BUTTON ;
            ID       100 ;
            OF       ::oFld:aDialogs[ 2 ] ;
            ACTION   ( ::PutLabel() )

         REDEFINE BUTTON ;
            ID       110 ;
            OF       ::oFld:aDialogs[ 2 ] ;
            ACTION   ( ::SelectAllLabels( .t. ) )

         REDEFINE BUTTON ;
            ID       120 ;
            OF       ::oFld:aDialogs[ 2 ] ;
            ACTION   ( ::SelectAllLabels( .f. ) )

         REDEFINE BUTTON ;
            ID       130 ;
            OF       ::oFld:aDialogs[ 2 ] ;
            ACTION   ( ::AddLabel() )

         REDEFINE BUTTON ;
            ID       140 ;
            OF       ::oFld:aDialogs[ 2 ] ;
            ACTION   ( ::DelLabel() )

         REDEFINE BUTTON ;
            ID       150 ;
            OF       ::oFld:aDialogs[ 2 ] ;
            ACTION   ( ::EditLabel() )

         REDEFINE BUTTON oBtnPrp ;
            ID       220 ;
            OF       ::oFld:aDialogs[ 2 ] ;
            ACTION   ( nil )

         REDEFINE BUTTON oBtnMod;
            ID       160 ;
            OF       ::oFld:aDialogs[ 2 ] ;
            ACTION   ( nil )

         REDEFINE BUTTON oBtnZoo;
            ID       165 ;
            OF       ::oFld:aDialogs[ 2 ] ;
            ACTION   ( nil )

         REDEFINE BUTTON ::oBtnFilter ;
            ID       170 ;
            OF       ::oFld:aDialogs[ 2 ] ;
            ACTION   ( ::FilterLabel() )

         ::oBrwLabel                 := TXBrowse():New( ::oFld:aDialogs[ 2 ] )

         ::oBrwLabel:nMarqueeStyle   := 5
         ::oBrwLabel:nColSel         := 2

         ::oBrwLabel:lHScroll        := .f.
         ::oBrwLabel:cAlias          := ::cAreaTmpLabel

         ::oBrwLabel:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
         ::oBrwLabel:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }
         ::oBrwLabel:bLDblClick      := {|| ::PutLabel() }

         ::oBrwLabel:CreateFromResource( 180 )

         with object ( ::oBrwLabel:AddCol() )
            :cHeader          := "Sl. Seleccionada"
            :bEditValue       := {|| ( ::cAreaTmpLabel )->lLabel }
            :nWidth           := 20
            :SetCheck( { "Sel16", "Nil16" } )
         end with

         with object ( ::oBrwLabel:AddCol() )
            :cHeader          := "Código"
            :bEditValue       := {|| ( ::cAreaTmpLabel )->cRef }
            :nWidth           := 80
            :cSortOrder       := "cRef"
            :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
         end with

         with object ( ::oBrwLabel:AddCol() )
            :cHeader          := "Nombre"
            :bEditValue       := {|| ( ::cAreaTmpLabel )->cDetalle }
            :nWidth           := 250
            :cSortOrder       := "cDetalle"
            :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
         end with

         with object ( ::oBrwLabel:AddCol() )
            :cHeader          := "Prp. 1"
            :bEditValue       := {|| ( ::cAreaTmpLabel )->cValPr1 }
            :nWidth           := 40
         end with

         with object ( ::oBrwLabel:AddCol() )
            :cHeader          := "Prp. 2"
            :bEditValue       := {|| ( ::cAreaTmpLabel )->cValPr2 }
            :nWidth           := 40
         end with

         with object ( ::oBrwLabel:AddCol() )
            :cHeader          := "N. etiquetas"
            :bEditValue       := {|| ( ::cAreaTmpLabel )->nLabel }
            :cEditPicture     := "@E 99,999"
            :nWidth           := 80
            :nDataStrAlign    := 1
            :nHeadStrAlign    := 1
            :nEditType        := 1
            :bOnPostEdit      := {|o,x| if( dbDialogLock( ::cAreaTmpLabel ), ( ( ::cAreaTmpLabel )->nLabel := x, ( ::cAreaTmpLabel )->( dbUnlock() ) ), ) }
         end with

         REDEFINE METER ::oMtrLabel ;
            VAR      ::nMtrLabel ;
            PROMPT   "" ;
            ID       190 ;
            OF       ::oFld:aDialogs[ 2 ] ;
            TOTAL    ( ::cAreaTmpLabel  )->( lastrec() )

         ::oMtrLabel:nClrText   := rgb( 128,255,0 )
         ::oMtrLabel:nClrBar    := rgb( 128,255,0 )
         ::oMtrLabel:nClrBText  := rgb( 128,255,0 )

         /*
         Botones generales--------------------------------------------------------
         */

         REDEFINE BUTTON ::oBtnListado ;          // Boton anterior
            ID       40 ;
            OF       ::oDlg ;
            ACTION   ( ::BotonAnterior() )

         REDEFINE BUTTON ::oBtnAnterior ;          // Boton anterior
            ID       20 ;
            OF       ::oDlg ;
            ACTION   ( ::BotonAnterior() )

         REDEFINE BUTTON ::oBtnSiguiente ;         // Boton de Siguiente
            ID       30 ;
            OF       ::oDlg ;
            ACTION   ( ::BotonSiguiente() )

         REDEFINE BUTTON ::oBtnCancel ;            // Boton de Siguiente
            ID       IDCANCEL ;
            OF       ::oDlg ;
            ACTION   ( ::oDlg:End() )

      ::oDlg:bStart  := {|| ::oBtnListado:Hide(), ::oBtnAnterior:Hide(), ::oFormatoLabel:lValid(), oBtnMod:Hide(), oBtnZoo:Hide(), oBtnPrp:Hide() }

      ACTIVATE DIALOG ::oDlg CENTER

      ::End()

   end if

Return ( Self )

//--------------------------------------------------------------------------//

Method lCreateAuxiliar() CLASS TAlbaranProveedoresLabelGenerator

   local oBlock
   local oError
   local lCreateAuxiliar   := .t.

   oBlock                  := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      ::cAreaTmpLabel      := "Lbl" + cCurUsr()
      ::cFileTmpLabel      := cGetNewFileName( cPatTmp() + "Lbl" )

      ::DestroyAuxiliar()

      dbCreate( ::cFileTmpLabel, aSqlStruct( aColAlbPrv() ), cLocalDriver() )
      dbUseArea( .t., cLocalDriver(), ::cFileTmpLabel, ::cAreaTmpLabel, .f. )

      if!( ::cAreaTmpLabel )->( neterr() )
         ( ::cAreaTmpLabel )->( ordCondSet( "!Deleted()", {|| !Deleted() }  ) )
         ( ::cAreaTmpLabel )->( OrdCreate( ::cFileTmpLabel, "cRef", "cRef", {|| Field->cRef } ) )

         ( ::cAreaTmpLabel )->( ordCondSet( "!Deleted()", {|| !Deleted() }  ) )
         ( ::cAreaTmpLabel )->( OrdCreate( ::cFileTmpLabel, "cDetalle", "Upper( cDetalle )", {|| Upper( Field->cDetalle ) } ) )
      end if

      ( ::cAreaTmpLabel )->( OrdsetFocus( "cRef" ) )

   RECOVER USING oError

      lCreateAuxiliar      := .f.

      MsgStop( 'Imposible crear fichero temporal' + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( lCreateAuxiliar )

//--------------------------------------------------------------------------//

Method DestroyAuxiliar() CLASS TAlbaranProveedoresLabelGenerator

   if !Empty( ::cAreaTmpLabel ) .and. ( ::cAreaTmpLabel )->( Used() )
      ( ::cAreaTmpLabel )->( dbCloseArea() )
   end if

   dbfErase( ::cFileTmpLabel )

   SysRefresh()

Return ( nil )

//--------------------------------------------------------------------------//

Method BotonAnterior() CLASS TAlbaranProveedoresLabelGenerator

   ::oFld:GoPrev()

   ::oBtnAnterior:Hide()

   SetWindowText( ::oBtnSiguiente:hWnd, "Siguien&te >" )

Return ( Self )

//--------------------------------------------------------------------------//

Method BotonSiguiente() CLASS TAlbaranProveedoresLabelGenerator

   do case
      case ::oFld:nOption == 1

         if Empty( ::cFormatoLabel )

            MsgStop( "Debe cumplimentar un formato de etiquetas" )

         else

            ::LoadAuxiliar()

            ::oFld:GoNext()
            ::oBtnAnterior:Show()
            SetWindowText( ::oBtnSiguiente:hWnd, "&Terminar" )

         end if

      case ::oFld:nOption == 2

         if ::lPrintLabels()

            SetWindowText( ::oBtnCancel:hWnd, "&Cerrar" )

         end if

   end case

Return ( Self )

//--------------------------------------------------------------------------//

Method lCreateTemporal() CLASS TAlbaranProveedoresLabelGenerator

   local n
   local nRec
   local oBlock
   local oError
   local nBlancos
   local lCreateTemporal   := .t.

   oBlock                  := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      tmpAlbPrvL           := "LblAlb"
      filAlbPrvL           := cGetNewFileName( cPatTmp() + "LblAlb" )

      dbCreate( filAlbPrvL, aSqlStruct( aColAlbPrv() ), cLocalDriver() )
      dbUseArea( .t., cLocalDriver(), filAlbPrvL, tmpAlbPrvL, .f. )

      ( tmpAlbPrvL )->( OrdCondSet( "!Deleted()", {||!Deleted()} ) )
      ( tmpAlbPrvL )->( OrdCreate( filAlbPrvL, "nNumAlb", "cSerAlb + Str( nNumAlb ) + cSufAlb", {|| Field->cSerAlb + Str( Field->nNumAlb ) + Field->cSufAlb } ) )

      nRec                 := ( ::cAreaTmpLabel )->( Recno() )

      ( ::cAreaTmpLabel )->( dbGoTop() )
      while !( ::cAreaTmpLabel )->( eof() )

         if ( ::cAreaTmpLabel )->lLabel
            for n := 1 to ( ::cAreaTmpLabel )->nLabel
               dbPass( ::cAreaTmpLabel, tmpAlbPrvL, .t. )
            next
         end if

         ( ::cAreaTmpLabel )->( dbSkip() )

      end while
      ( tmpAlbPrvL )->( dbGoTop() )

      ( ::cAreaTmpLabel )->( dbGoTo( nRec ) )

   RECOVER USING oError

      lCreateTemporal      := .f.

      MsgStop( 'Imposible crear un fichero temporal de lineas de albaranes' + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( lCreateTemporal )

//---------------------------------------------------------------------------//

Method DestroyTemporal() CLASS TAlbaranProveedoresLabelGenerator

   if ( tmpAlbPrvL )->( Used() )
      ( tmpAlbPrvL )->( dbCloseArea() )
   end if

   dbfErase( filAlbPrvL )

   tmpAlbPrvL           := nil

   SysRefresh()

Return ( .t. )

//---------------------------------------------------------------------------//

Method PrepareTemporal( oFr ) CLASS TAlbaranProveedoresLabelGenerator

   local n
   local nBlancos       := 0
   local nPaperHeight   := oFr:GetProperty( "MainPage", "PaperHeight" ) * fr01cm
   local nHeight        := oFr:GetProperty( "CabeceraColumnas", "Height" )
   local nColumns       := oFr:GetProperty( "MainPage", "Columns" )
   local nItemsInColumn := int( nPaperHeight / nHeight )

   nBlancos             := ( ::nColumnaInicio - 1 ) * nItemsInColumn
   nBlancos             += ( ::nFilaInicio - 1 )

   for n := 1 to nBlancos
      dbPass( dbBlankRec( dbfAlbPrvL ), tmpAlbPrvL, .t. )
   next

   ( tmpAlbPrvL )->( dbGoTop() )

Return ( .t. )

//---------------------------------------------------------------------------//

Method lPrintLabels() CLASS TAlbaranProveedoresLabelGenerator

   local oFr

   local nCopies      := 1
   local nDevice      := IS_SCREEN
   local cPrinter     := PrnGetName()

   if ::lCreateTemporal()

      SysRefresh()

      oFr             := frReportManager():New()

      oFr:LoadLangRes(     "Spanish.Xml" )

      oFr:SetIcon( 1 )

      oFr:SetTitle(        "Diseñador de documentos" )

      /*
      Manejador de eventos--------------------------------------------------------
      */

      oFr:SetEventHandler( "Designer", "OnSaveReport", {|| oFr:SaveToBlob( ( dbfDoc )->( Select() ), "mReport" ) } )

      /*
      Zona de datos---------------------------------------------------------------
      */

      DataLabel( oFr, .t. )

      /*
      Cargar el informe-----------------------------------------------------------
      */

      if !Empty( ( dbfDoc )->mReport )

         oFr:LoadFromBlob( ( dbfDoc )->( Select() ), "mReport")

         /*
         Zona de variables--------------------------------------------------------
         */

         ::PrepareTemporal( oFr )

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

      ::DestroyTemporal()

   end if

Return .t.

//---------------------------------------------------------------------------//

Method End() CLASS TAlbaranProveedoresLabelGenerator

   if !Empty( ::nRecno )
      ( dbfAlbPrvT )->( dbGoTo( ::nRecno ) )
   end if

   if IsTrue( ::lClose )
      CloseFiles()
   end if

   /*
   Destruye el fichero temporal------------------------------------------------
   */

   ::DestroyAuxiliar()

   WritePProString( "Etiquetas", "Albaran proveedor", ::cFormatoLabel, cPatEmp() + "Empresa.Ini" )

Return ( Self )

//--------------------------------------------------------------------------//

Method PutLabel() CLASS TAlbaranProveedoresLabelGenerator

   ( ::cAreaTmpLabel )->lLabel   := !( ::cAreaTmpLabel )->lLabel

   ::oBrwLabel:Refresh()
   ::oBrwLabel:Select()

Return ( Self )

//--------------------------------------------------------------------------//

Method SelectAllLabels( lSelect ) CLASS TAlbaranProveedoresLabelGenerator

	local n			:= 0
   local nRecno   := ( ::cAreaTmpLabel )->( Recno() )

	CursorWait()

   ( ::cAreaTmpLabel )->( dbGoTop() )
   while !( ::cAreaTmpLabel )->( eof() )

      ( ::cAreaTmpLabel )->lLabel := lSelect

      ( ::cAreaTmpLabel )->( dbSkip() )

      ::oMtrLabel:Set( ++n )

   end while

   ( ::cAreaTmpLabel )->( dbGoTo( nRecno ) )

   ::oBrwLabel:Refresh()

   ::oMtrLabel:Set( 0 )
   ::oMtrLabel:Refresh()

	CursorArrow()

Return ( Self )

//--------------------------------------------------------------------------//

Method AddLabel() CLASS TAlbaranProveedoresLabelGenerator

   ( ::cAreaTmpLabel )->nLabel++

   ::oBrwLabel:Refresh()
   ::oBrwLabel:SetFocus()

Return ( Self )

//--------------------------------------------------------------------------//

Method DelLabel() CLASS TAlbaranProveedoresLabelGenerator

   if ( ::cAreaTmpLabel )->nLabel > 1
      ( ::cAreaTmpLabel )->nLabel--
   end if

   ::oBrwLabel:Refresh()
   ::oBrwLabel:SetFocus()

Return ( Self )

//---------------------------------------------------------------------------//

Method EditLabel() CLASS TAlbaranProveedoresLabelGenerator

   ::oBrwLabel:aCols[ 6 ]:Edit()

Return ( Self )

//---------------------------------------------------------------------------//

Method FilterLabel()

   if Empty( ::oFilter )
      ::oFilter      := TDlgFlt():New( aColAlbPrv(), ::cAreaTmpLabel )
   end if

   if !Empty( ::oFilter )

      ::oFilter:Resource()

      if ::oFilter:cExpFilter != nil
         SetWindowText( ::oBtnFilter:hWnd, "Filtro activo" )
      else
         SetWindowText( ::oBtnFilter:hWnd, "Filtrar" )
      end if

   end if

   ::oBrwLabel:Refresh()
   ::oBrwLabel:SetFocus()

Return ( Self )

//---------------------------------------------------------------------------//

Method LoadAuxiliar() CLASS TAlbaranProveedoresLabelGenerator

   local nRec
   local nOrd

   /*
   Limpiamos la base de datos temporal-----------------------------------------
   */

   ( ::cAreaTmpLabel )->( __dbZap() )

   /*
   Llenamos la tabla temporal--------------------------------------------------
	*/

   nRec           := ( dbfAlbPrvT )->( Recno() )
   nOrd           := ( dbfAlbPrvT )->( OrdSetFocus( "nNumAlb" ) )

   if ( dbfAlbPrvT )->( dbSeek( ::cSerieInicio + Str( ::nDocumentoInicio, 9 ) + ::cSufijoInicio, .t. ) )

      while ( dbfAlbPrvT )->cSerAlb + Str( ( dbfAlbPrvT )->nNumAlb ) + ( dbfAlbPrvT )->cSufAlb >= ::cSerieInicio + Str( ::nDocumentoInicio, 9 ) + ::cSufijoInicio .and. ;
            ( dbfAlbPrvT )->cSerAlb + Str( ( dbfAlbPrvT )->nNumAlb ) + ( dbfAlbPrvT )->cSufAlb <= ::cSerieFin + Str( ::nDocumentoFin, 9 ) + ::cSufijoFin          .and. ;
            !( dbfAlbPrvT )->( eof() )

         if ( dbfAlbPrvL )->( dbSeek( ( dbfAlbPrvT )->cSerAlb + Str( ( dbfAlbPrvT )->nNumAlb ) + ( dbfAlbPrvT )->cSufAlb ) )

            while ( ( dbfAlbPrvL )->cSerAlb + Str( ( dbfAlbPrvL )->nNumAlb ) + ( dbfAlbPrvL )->cSufAlb == ( dbfAlbPrvT )->cSerAlb + Str( ( dbfAlbPrvT )->nNumAlb ) + ( dbfAlbPrvT )->cSufAlb ) .and. ( dbfAlbPrvL )->( !eof() )

               if !Empty( ( dbfAlbPrvL )->cRef )

                  ( ::cAreaTmpLabel )->( dbAppend() )

                  ( ::cAreaTmpLabel )->cSerAlb  := ( dbfAlbPrvL )->cSerAlb
                  ( ::cAreaTmpLabel )->nNumAlb  := ( dbfAlbPrvL )->nNumAlb
                  ( ::cAreaTmpLabel )->cSufAlb  := ( dbfAlbPrvL )->cSufAlb
                  ( ::cAreaTmpLabel )->cRef     := ( dbfAlbPrvL )->cRef
                  ( ::cAreaTmpLabel )->cRefPrv  := ( dbfAlbPrvL )->cRefPrv
                  ( ::cAreaTmpLabel )->cDetalle := ( dbfAlbPrvL )->cDetalle
                  ( ::cAreaTmpLabel )->nPreDiv  := ( dbfAlbPrvL )->nPreDiv
                  ( ::cAreaTmpLabel )->nIva     := ( dbfAlbPrvL )->nIva
                  ( ::cAreaTmpLabel )->nReq     := ( dbfAlbPrvL )->nReq
                  ( ::cAreaTmpLabel )->nCanEnt  := ( dbfAlbPrvL )->nCanEnt
                  ( ::cAreaTmpLabel )->lControl := ( dbfAlbPrvL )->lControl
                  ( ::cAreaTmpLabel )->cUnidad  := ( dbfAlbPrvL )->cUnidad
                  ( ::cAreaTmpLabel )->nUniCaja := ( dbfAlbPrvL )->nUniCaja
                  ( ::cAreaTmpLabel )->lChgLin  := ( dbfAlbPrvL )->lChgLin
                  ( ::cAreaTmpLabel )->mLngDes  := ( dbfAlbPrvL )->mLngDes
                  ( ::cAreaTmpLabel )->nDtoLin  := ( dbfAlbPrvL )->nDtoLin
                  ( ::cAreaTmpLabel )->nDtoPrm  := ( dbfAlbPrvL )->nDtoPrm
                  ( ::cAreaTmpLabel )->nDtoRap  := ( dbfAlbPrvL )->nDtoRap
                  ( ::cAreaTmpLabel )->nPreCom  := ( dbfAlbPrvL )->nPreCom
                  ( ::cAreaTmpLabel )->lBnfLin1 := ( dbfAlbPrvL )->lBnfLin1
                  ( ::cAreaTmpLabel )->lBnfLin2 := ( dbfAlbPrvL )->lBnfLin2
                  ( ::cAreaTmpLabel )->lBnfLin3 := ( dbfAlbPrvL )->lBnfLin3
                  ( ::cAreaTmpLabel )->lBnfLin4 := ( dbfAlbPrvL )->lBnfLin4
                  ( ::cAreaTmpLabel )->lBnfLin5 := ( dbfAlbPrvL )->lBnfLin5
                  ( ::cAreaTmpLabel )->lBnfLin6 := ( dbfAlbPrvL )->lBnfLin6
                  ( ::cAreaTmpLabel )->nBnfLin1 := ( dbfAlbPrvL )->nBnfLin1
                  ( ::cAreaTmpLabel )->nBnfLin2 := ( dbfAlbPrvL )->nBnfLin2
                  ( ::cAreaTmpLabel )->nBnfLin3 := ( dbfAlbPrvL )->nBnfLin3
                  ( ::cAreaTmpLabel )->nBnfLin4 := ( dbfAlbPrvL )->nBnfLin4
                  ( ::cAreaTmpLabel )->nBnfLin5 := ( dbfAlbPrvL )->nBnfLin5
                  ( ::cAreaTmpLabel )->nBnfLin6 := ( dbfAlbPrvL )->nBnfLin6
                  ( ::cAreaTmpLabel )->nBnfSbr1 := ( dbfAlbPrvL )->nBnfSbr1
                  ( ::cAreaTmpLabel )->nBnfSbr2 := ( dbfAlbPrvL )->nBnfSbr2
                  ( ::cAreaTmpLabel )->nBnfSbr3 := ( dbfAlbPrvL )->nBnfSbr3
                  ( ::cAreaTmpLabel )->nBnfSbr4 := ( dbfAlbPrvL )->nBnfSbr4
                  ( ::cAreaTmpLabel )->nBnfSbr5 := ( dbfAlbPrvL )->nBnfSbr5
                  ( ::cAreaTmpLabel )->nBnfSbr6 := ( dbfAlbPrvL )->nBnfSbr6
                  ( ::cAreaTmpLabel )->nPvpLin1 := ( dbfAlbPrvL )->nPvpLin1
                  ( ::cAreaTmpLabel )->nPvpLin2 := ( dbfAlbPrvL )->nPvpLin2
                  ( ::cAreaTmpLabel )->nPvpLin3 := ( dbfAlbPrvL )->nPvpLin3
                  ( ::cAreaTmpLabel )->nPvpLin4 := ( dbfAlbPrvL )->nPvpLin4
                  ( ::cAreaTmpLabel )->nPvpLin5 := ( dbfAlbPrvL )->nPvpLin5
                  ( ::cAreaTmpLabel )->nPvpLin6 := ( dbfAlbPrvL )->nPvpLin6
                  ( ::cAreaTmpLabel )->nIvaLin1 := ( dbfAlbPrvL )->nIvaLin1
                  ( ::cAreaTmpLabel )->nIvaLin2 := ( dbfAlbPrvL )->nIvaLin2
                  ( ::cAreaTmpLabel )->nIvaLin3 := ( dbfAlbPrvL )->nIvaLin3
                  ( ::cAreaTmpLabel )->nIvaLin4 := ( dbfAlbPrvL )->nIvaLin4
                  ( ::cAreaTmpLabel )->nIvaLin5 := ( dbfAlbPrvL )->nIvaLin5
                  ( ::cAreaTmpLabel )->nIvaLin6 := ( dbfAlbPrvL )->nIvaLin6
                  ( ::cAreaTmpLabel )->nIvaLin  := ( dbfAlbPrvL )->nIvaLin
                  ( ::cAreaTmpLabel )->lIvaLin  := ( dbfAlbPrvL )->lIvaLin
                  ( ::cAreaTmpLabel )->cCodPr1  := ( dbfAlbPrvL )->cCodPr1
                  ( ::cAreaTmpLabel )->cCodPr2  := ( dbfAlbPrvL )->cCodPr2
                  ( ::cAreaTmpLabel )->cValPr1  := ( dbfAlbPrvL )->cValPr1
                  ( ::cAreaTmpLabel )->cValPr2  := ( dbfAlbPrvL )->cValPr2
                  ( ::cAreaTmpLabel )->nFacCnv  := ( dbfAlbPrvL )->nFacCnv
                  ( ::cAreaTmpLabel )->cAlmLin  := ( dbfAlbPrvL )->cAlmLin
                  ( ::cAreaTmpLabel )->nCtlStk  := ( dbfAlbPrvL )->nCtlStk
                  ( ::cAreaTmpLabel )->lLote    := ( dbfAlbPrvL )->lLote
                  ( ::cAreaTmpLabel )->nLote    := ( dbfAlbPrvL )->nLote
                  ( ::cAreaTmpLabel )->cLote    := ( dbfAlbPrvL )->cLote
                  ( ::cAreaTmpLabel )->nNumLin  := ( dbfAlbPrvL )->nNumLin
                  ( ::cAreaTmpLabel )->nUndKit  := ( dbfAlbPrvL )->nUndKit
                  ( ::cAreaTmpLabel )->lKitArt  := ( dbfAlbPrvL )->lKitArt
                  ( ::cAreaTmpLabel )->lKitChl  := ( dbfAlbPrvL )->lKitChl
                  ( ::cAreaTmpLabel )->lKitPrc  := ( dbfAlbPrvL )->lKitPrc
                  ( ::cAreaTmpLabel )->lImpLin  := ( dbfAlbPrvL )->lImpLin
                  ( ::cAreaTmpLabel )->mNumSer  := ( dbfAlbPrvL )->mNumSer
                  ( ::cAreaTmpLabel )->cCodUbi1 := ( dbfAlbPrvL )->cCodUbi1
                  ( ::cAreaTmpLabel )->cCodUbi2 := ( dbfAlbPrvL )->cCodUbi2
                  ( ::cAreaTmpLabel )->cCodUbi3 := ( dbfAlbPrvL )->cCodUbi3
                  ( ::cAreaTmpLabel )->cValUbi1 := ( dbfAlbPrvL )->cValUbi1
                  ( ::cAreaTmpLabel )->cValUbi2 := ( dbfAlbPrvL )->cValUbi2
                  ( ::cAreaTmpLabel )->cValUbi3 := ( dbfAlbPrvL )->cValUbi3
                  ( ::cAreaTmpLabel )->cNomUbi1 := ( dbfAlbPrvL )->cNomUbi1
                  ( ::cAreaTmpLabel )->cNomUbi2 := ( dbfAlbPrvL )->cNomUbi2
                  ( ::cAreaTmpLabel )->cNomUbi3 := ( dbfAlbPrvL )->cNomUbi3
                  ( ::cAreaTmpLabel )->cCodFam  := ( dbfAlbPrvL )->cCodFam
                  ( ::cAreaTmpLabel )->cGrpFam  := ( dbfAlbPrvL )->cGrpFam
                  ( ::cAreaTmpLabel )->mObsLin  := ( dbfAlbPrvL )->mObsLin
                  ( ::cAreaTmpLabel )->nPvpRec  := ( dbfAlbPrvL )->nPvpRec
                  ( ::cAreaTmpLabel )->nUndLin  := nTotNAlbPrv( dbfAlbPrvL )
                  ( ::cAreaTmpLabel )->lLabel   := .t.

                  if ::nCantidadLabels == 1
                  ( ::cAreaTmpLabel )->nLabel   := nTotNAlbPrv( dbfAlbPrvL )
                  else
                  ( ::cAreaTmpLabel )->nLabel   := ::nUnidadesLabels
                  end if

               end if

               ( dbfAlbPrvL )->( dbSkip() )

            end while

         end if

         ( dbfAlbPrvT )->( dbSkip() )

      end while

   end if

   ( dbfAlbPrvT )->( OrdSetFocus( nOrd ) )
   ( dbfAlbPrvT )->( dbGoTo( nRec ) )

   ( ::cAreaTmpLabel )->( dbGoTop() )

   ::oBrwLabel:Refresh()

Return ( Self )

//---------------------------------------------------------------------------//

Method InitLabel( oLabel ) CLASS TAlbaranProveedoresLabelGenerator

   local nStartRow

   if ::nFilaInicio > 1
      nStartRow            := oLabel:nStartRow
      nStartRow            += ( ::nFilaInicio - 1 ) * ( oLabel:nLblHeight + oLabel:nVSeparator )

      if nStartRow < oLabel:nBottomRow
         oLabel:nStartRow  := nStartRow
      end if
   end if

   if ::nColumnaInicio > 1 .and. ::nColumnaInicio <= oLabel:nLblOnLine
      oLabel:nLblCurrent   := ::nColumnaInicio
   end if

Return ( Self )

//---------------------------------------------------------------------------//

Method SelectColumn( oCombo ) CLASS TAlbaranProveedoresLabelGenerator

   local oCol
   local cOrd                    := oCombo:VarGet()

   if ::oBrwLabel != nil

      with object ::oBrwLabel

         for each oCol in :aCols

            if Eq( cOrd, oCol:cHeader )
               oCol:cOrder       := "A"
               oCol:SetOrder()
            else
               oCol:cOrder       := " "
            end if

         next

      end with

      ::oBrwLabel:Refresh()

   end if

Return ( Self )

//---------------------------------------------------------------------------//

Static Function DataLabel( oFr, lTemporal )

   /*
   Zona de datos------------------------------------------------------------

   oFr:ClearDataSets()

   if lTemporal
      oFr:SetWorkArea(  "Lineas de albaranes", ( tmpAlbPrvL )->( Select() ), .f., { FR_RB_FIRST, FR_RE_LAST, 0 } )
   else
      oFr:SetWorkArea(  "Lineas de albaranes", ( dbfAlbPrvL )->( Select() ), .f., { FR_RB_FIRST, FR_RE_LAST, 0 } )
   end if
   oFr:SetFieldAliases( "Lineas de albaranes", cItemsToReport( aColAlbPrv() ) )

   oFr:SetWorkArea(     "Albaranes", ( dbfAlbPrvT )->( Select() ) )
   oFr:SetFieldAliases( "Albaranes", cItemsToReport( aItmAlbPrv() ) )

   oFr:SetWorkArea(     "Artículos", ( dbfArticulo )->( Select() ) )
   oFr:SetFieldAliases( "Artículos", cItemsToReport( aItmArt() ) )

   oFr:SetWorkArea(     "Precios por propiedades", ( dbfArtCom )->( Select() ) )
   oFr:SetFieldAliases( "Precios por propiedades", cItemsToReport( aItmVta() ) )

   if lTemporal
      oFr:SetMasterDetail( "Lineas de albaranes", "Albaranes", {|| ( tmpAlbPrvL )->cSerAlb + Str( ( tmpAlbPrvL )->nNumAlb ) + ( tmpAlbPrvL )->cSufAlb } )
      oFr:SetMasterDetail( "Lineas de albaranes", "Artículos", {|| ( tmpAlbPrvL )->cRef } )
      oFr:SetMasterDetail( "Lineas de albaranes", "Precios por propiedades", {|| ( tmpAlbPrvL )->cRef + ( tmpAlbPrvL )->cCodPr1 + ( tmpAlbPrvL )->cCodPr2 + ( tmpAlbPrvL )->cValPr1 + ( tmpAlbPrvL )->cValPr2 } )
   else
      oFr:SetMasterDetail( "Lineas de albaranes", "Albaranes", {|| ( dbfAlbPrvL )->cSerAlb + Str( ( dbfAlbPrvL )->nNumAlb ) + ( dbfAlbPrvL )->cSufAlb } )
      oFr:SetMasterDetail( "Lineas de albaranes", "Artículos", {|| ( dbfAlbPrvL )->cRef } )
      oFr:SetMasterDetail( "Lineas de albaranes", "Precios por propiedades", {|| ( dbfAlbPrvL )->cRef + ( dbfAlbPrvL )->cCodPr1 + ( dbfAlbPrvL )->cCodPr2 + ( dbfAlbPrvL )->cValPr1 + ( dbfAlbPrvL )->cValPr2 } )
   end if

   oFr:SetResyncPair(      "Lineas de albaranes", "Albaranes" )
   oFr:SetResyncPair(      "Lineas de albaranes", "Artículos" )
   oFr:SetResyncPair(      "Lineas de albaranes", "Precios por propiedades" )
   */

   /*
   Zona de datos------------------------------------------------------------
   */

   oFr:ClearDataSets()

   if lTemporal
      oFr:SetWorkArea(  "Lineas de albaranes", ( tmpAlbPrvL )->( Select() ), .f., { FR_RB_FIRST, FR_RE_LAST, 0 } )
   else
      oFr:SetWorkArea(  "Lineas de albaranes", ( dbfAlbPrvL )->( Select() ), .f., { FR_RB_FIRST, FR_RE_COUNT, 20 } )
   end if

   oFr:SetFieldAliases( "Lineas de albaranes", cItemsToReport( aColAlbPrv() ) )

   oFr:SetWorkArea(     "Albaranes", ( dbfAlbPrvT )->( Select() ) )
   oFr:SetFieldAliases( "Albaranes", cItemsToReport( aItmAlbPrv() ) )

   oFr:SetWorkArea(     "Artículos", ( dbfArticulo )->( Select() ) )
   oFr:SetFieldAliases( "Artículos", cItemsToReport( aItmArt() ) )

   oFr:SetWorkArea(     "Precios por propiedades", ( dbfArtCom )->( Select() ) )
   oFr:SetFieldAliases( "Precios por propiedades", cItemsToReport( aItmVta() ) )

   oFr:SetWorkArea(     "Incidencias de albaranes", ( dbfAlbPrvI )->( Select() ) )
   oFr:SetFieldAliases( "Incidencias de albaranes", cItemsToReport( aIncAlbPrv() ) )

   oFr:SetWorkArea(     "Documentos de albaranes", ( dbfAlbPrvD )->( Select() ) )
   oFr:SetFieldAliases( "Documentos de albaranes", cItemsToReport( aAlbPrvDoc() ) )

   oFr:SetWorkArea(     "Empresa", ( dbfEmp )->( Select() ) )
   oFr:SetFieldAliases( "Empresa", cItemsToReport( aItmEmp() ) )

   oFr:SetWorkArea(     "Proveedores", ( dbfPrv )->( Select() ) )
   oFr:SetFieldAliases( "Proveedores", cItemsToReport( aItmPrv() ) )

   oFr:SetWorkArea(     "Almacenes", ( dbfAlm )->( Select() ) )
   oFr:SetFieldAliases( "Almacenes", cItemsToReport( aItmAlm() ) )

   oFr:SetWorkArea(     "Formas de pago", ( dbfFpago )->( Select() ) )
   oFr:SetFieldAliases( "Formas de pago", cItemsToReport( aItmFPago() ) )

   oFr:SetWorkArea(     "Artículos", ( dbfArticulo )->( Select() ) )
   oFr:SetFieldAliases( "Artículos", cItemsToReport( aItmArt() ) )

   oFr:SetWorkArea(     "Código de proveedores", ( dbfArtPrv )->( Select() ) )
   oFr:SetFieldAliases( "Código de proveedores", cItemsToReport( aItmArtPrv() ) )

   oFr:SetWorkArea(     "Unidades de medición",  oUndMedicion:Select() )
   oFr:SetFieldAliases( "Unidades de medición",  cObjectsToReport( oUndMedicion:oDbf ) )

   if lTemporal
      oFr:SetMasterDetail( "Lineas de albaranes", "Albaranes",                {|| ( tmpAlbPrvL )->cSerAlb + Str( ( tmpAlbPrvL )->nNumAlb ) + ( tmpAlbPrvL )->cSufAlb } )
      oFr:SetMasterDetail( "Lineas de albaranes", "Artículos",                {|| ( tmpAlbPrvL )->cRef } )
      oFr:SetMasterDetail( "Lineas de albaranes", "Precios por propiedades",  {|| ( tmpAlbPrvL )->cRef + ( tmpAlbPrvL )->cCodPr1 + ( tmpAlbPrvL )->cCodPr2 + ( tmpAlbPrvL )->cValPr1 + ( tmpAlbPrvL )->cValPr2 } )
      oFr:SetMasterDetail( "Lineas de albaranes", "Incidencias de albaranes", {|| ( tmpAlbPrvL )->cSerAlb + Str( ( tmpAlbPrvL )->nNumAlb ) + ( tmpAlbPrvL )->cSufAlb } )
      oFr:SetMasterDetail( "Lineas de albaranes", "Documentos de albaranes",  {|| ( tmpAlbPrvL )->cSerAlb + Str( ( tmpAlbPrvL )->nNumAlb ) + ( tmpAlbPrvL )->cSufAlb } )
   else
      oFr:SetMasterDetail( "Lineas de albaranes", "Albaranes",                {|| ( dbfAlbPrvL )->cSerAlb + Str( ( dbfAlbPrvL )->nNumAlb ) + ( dbfAlbPrvL )->cSufAlb } )
      oFr:SetMasterDetail( "Lineas de albaranes", "Artículos",                {|| ( dbfAlbPrvL )->cRef } )
      oFr:SetMasterDetail( "Lineas de albaranes", "Precios por propiedades",  {|| ( dbfAlbPrvL )->cRef + ( dbfAlbPrvL )->cCodPr1 + ( dbfAlbPrvL )->cCodPr2 + ( dbfAlbPrvL )->cValPr1 + ( dbfAlbPrvL )->cValPr2 } )
      oFr:SetMasterDetail( "Lineas de albaranes", "Incidencias de albaranes", {|| ( dbfAlbPrvL )->cSerAlb + Str( ( dbfAlbPrvL )->nNumAlb ) + ( dbfAlbPrvL )->cSufAlb } )
      oFr:SetMasterDetail( "Lineas de albaranes", "Documentos de albaranes",  {|| ( dbfAlbPrvL )->cSerAlb + Str( ( dbfAlbPrvL )->nNumAlb ) + ( dbfAlbPrvL )->cSufAlb } )
   end if

   oFr:SetMasterDetail(    "Albaranes", "Proveedores",                        {|| ( dbfAlbPrvT )->cCodPrv } )
   oFr:SetMasterDetail(    "Albaranes", "Almacenes",                          {|| ( dbfAlbPrvT )->cCodAlm } )
   oFr:SetMasterDetail(    "Albaranes", "Empresa",                            {|| cCodigoEmpresaEnUso() } )

   oFr:SetResyncPair(      "Lineas de albaranes", "Albaranes" )
   oFr:SetResyncPair(      "Lineas de albaranes", "Artículos" )
   oFr:SetResyncPair(      "Lineas de albaranes", "Precios por propiedades" )
   oFr:SetResyncPair(      "Lineas de albaranes", "Incidencias de albaranes" )
   oFr:SetResyncPair(      "Lineas de albaranes", "Documentos de albaranes" )

   oFr:SetResyncPair(      "Albaranes", "Proveedores" )
   oFr:SetResyncPair(      "Albaranes", "Almacenes" )
   oFr:SetResyncPair(      "Albaranes", "Empresa" )

Return nil

//---------------------------------------------------------------------------//

Function DesignLabelAlbPrv( oFr, dbfDoc )

   local oLabel   := TAlbaranProveedoresLabelGenerator():Init()

   if !oLabel:lErrorOnCreate

      /*
      Zona de datos---------------------------------------------------------
      */

      DataLabel( oFr, .f. )

      /*
      Paginas y bandas------------------------------------------------------
      */

      if !Empty( ( dbfDoc )->mReport )

         oFr:LoadFromBlob( ( dbfDoc )->( Select() ), "mReport")

      else

         oFr:AddPage(         "MainPage" )

         oFr:AddBand(         "CabeceraColumnas",  "MainPage",       frxMasterData )
         oFr:SetProperty(     "CabeceraColumnas",  "Top",            200 )
         oFr:SetProperty(     "CabeceraColumnas",  "Height",         100 )
         oFr:SetObjProperty(  "CabeceraColumnas",  "DataSet",        "Lineas de albaranes" )

      end if

      /*
      Zona de variables--------------------------------------------------------
      */

      VariableReport( oFr )

      /*
      Diseño de report------------------------------------------------------
      */

      oFr:DesignReport()

      /*
      Destruye el diseñador-------------------------------------------------
      */

      oFr:DestroyFr()

      /*
      Cierra ficheros-------------------------------------------------------
      */

      oLabel:End()

   else

      Return .f.

   end if

Return .t.

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

Static Function DataReport( oFr )

   /*
   Zona de datos------------------------------------------------------------
   */

   oFr:ClearDataSets()

   oFr:SetWorkArea(     "Albaranes", ( dbfAlbPrvT )->( Select() ), .f., { FR_RB_CURRENT, FR_RB_CURRENT, 0 } )
   oFr:SetFieldAliases( "Albaranes", cItemsToReport( aItmAlbPrv() ) )

   oFr:SetWorkArea(     "Lineas de albaranes", ( dbfAlbPrvL )->( Select() ) )
   oFr:SetFieldAliases( "Lineas de albaranes", cItemsToReport( aColAlbPrv() ) )

   oFr:SetWorkArea(     "Series de lineas de albaranes", ( dbfAlbPrvS )->( Select() ) )
   oFr:SetFieldAliases( "Series de lineas de albaranes", cItemsToReport( aSerAlbPrv() ) )

   oFr:SetWorkArea(     "Incidencias de albaranes", ( dbfAlbPrvI )->( Select() ) )
   oFr:SetFieldAliases( "Incidencias de albaranes", cItemsToReport( aIncAlbPrv() ) )

   oFr:SetWorkArea(     "Documentos de albaranes", ( dbfAlbPrvD )->( Select() ) )
   oFr:SetFieldAliases( "Documentos de albaranes", cItemsToReport( aAlbPrvDoc() ) )

   oFr:SetWorkArea(     "Empresa", ( dbfEmp )->( Select() ) )
   oFr:SetFieldAliases( "Empresa", cItemsToReport( aItmEmp() ) )

   oFr:SetWorkArea(     "Proveedor", ( dbfPrv )->( Select() ) )
   oFr:SetFieldAliases( "Proveedor", cItemsToReport( aItmPrv() ) )

   oFr:SetWorkArea(     "Almacenes", ( dbfAlm )->( Select() ) )
   oFr:SetFieldAliases( "Almacenes", cItemsToReport( aItmAlm() ) )

   oFr:SetWorkArea(     "Formas de pago", ( dbfFpago )->( Select() ) )
   oFr:SetFieldAliases( "Formas de pago", cItemsToReport( aItmFPago() ) )

   oFr:SetWorkArea(     "Artículos", ( dbfArticulo )->( Select() ) )
   oFr:SetFieldAliases( "Artículos", cItemsToReport( aItmArt() ) )

   oFr:SetWorkArea(     "Código de proveedores", ( dbfArtPrv )->( Select() ) )
   oFr:SetFieldAliases( "Código de proveedores", cItemsToReport( aItmArtPrv() ) )

   oFr:SetWorkArea(     "Unidades de medición",  oUndMedicion:Select() )
   oFr:SetFieldAliases( "Unidades de medición",  cObjectsToReport( oUndMedicion:oDbf ) )

   oFr:SetMasterDetail( "Albaranes", "Lineas de albaranes",             {|| ( dbfAlbPrvT )->cSerAlb + Str( ( dbfAlbPrvT )->nNumAlb ) + ( dbfAlbPrvT )->cSufAlb } )
   oFr:SetMasterDetail( "Albaranes", "Series de lineas de albaranes",   {|| ( dbfAlbPrvT )->cSerAlb + Str( ( dbfAlbPrvT )->nNumAlb ) + ( dbfAlbPrvT )->cSufAlb } )
   oFr:SetMasterDetail( "Albaranes", "Incidencias de albaranes",        {|| ( dbfAlbPrvT )->cSerAlb + Str( ( dbfAlbPrvT )->nNumAlb ) + ( dbfAlbPrvT )->cSufAlb } )
   oFr:SetMasterDetail( "Albaranes", "Documentos de albaranes",         {|| ( dbfAlbPrvT )->cSerAlb + Str( ( dbfAlbPrvT )->nNumAlb ) + ( dbfAlbPrvT )->cSufAlb } )
   oFr:SetMasterDetail( "Albaranes", "Proveedor",                       {|| ( dbfAlbPrvT )->cCodPrv } )
   oFr:SetMasterDetail( "Albaranes", "Almacenes",                       {|| ( dbfAlbPrvT )->cCodAlm } )
   oFr:SetMasterDetail( "Albaranes", "Formas de pago",                  {|| ( dbfAlbPrvT )->cCodPgo } )
   oFr:SetMasterDetail( "Albaranes", "Empresa",                         {|| cCodigoEmpresaEnUso() } )

   oFr:SetMasterDetail( "Lineas de albaranes", "Artículos",             {|| ( dbfAlbPrvL )->cRef } )
   oFr:SetMasterDetail( "Lineas de albaranes", "Código de proveedores", {|| ( dbfAlbPrvT )->cCodPrv + ( dbfAlbPrvL )->cRef } )
   oFr:SetMasterDetail( "Lineas de albaranes", "Unidades de medición",  {|| ( dbfAlbPrvL )->cUnidad } )

   oFr:SetResyncPair(   "Albaranes", "Lineas de albaranes" )
   oFr:SetResyncPair(   "Albaranes", "Series de lineas de albaranes" )
   oFr:SetResyncPair(   "Albaranes", "Incidencias de albaranes" )
   oFr:SetResyncPair(   "Albaranes", "Documentos de albaranes" )
   oFr:SetResyncPair(   "Albaranes", "Empresa" )
   oFr:SetResyncPair(   "Albaranes", "Proveedor" )
   oFr:SetResyncPair(   "Albaranes", "Almacenes" )
   oFr:SetResyncPair(   "Albaranes", "Formas de pago" )

   oFr:SetResyncPair(   "Lineas de albaranes", "Artículos" )
   oFr:SetResyncPair(   "Lineas de albaranes", "Código de proveedores" )
   oFr:SetResyncPair(   "Lineas de albaranes", "Unidades de medición" )

Return nil

//---------------------------------------------------------------------------//

Static Function VariableReport( oFr )

   oFr:DeleteCategory(  "Albaranes" )
   oFr:DeleteCategory(  "Lineas de albaranes" )

   /*
   Creación de variables----------------------------------------------------
   */

   oFr:AddVariable(     "Albaranes",             "Total albaran",                       "GetHbVar('nTotAlb')" )
   oFr:AddVariable(     "Albaranes",             "Total bruto",                         "GetHbVar('nTotBrt')" )
   oFr:AddVariable(     "Albaranes",             "Total descuento",                     "GetHbVar('nTotDto')" )
   oFr:AddVariable(     "Albaranes",             "Total descuento pronto pago",         "GetHbVar('nTotDpp')" )
   oFr:AddVariable(     "Albaranes",             "Total bruto",                         "GetHbVar('nTotBrt')" )
   oFr:AddVariable(     "Albaranes",             "Total descuento pronto pago",         "GetHbVar('nTotDpp')" )
   oFr:AddVariable(     "Albaranes",             "Total neto",                          "GetHbVar('nTotNet')" )
   oFr:AddVariable(     "Albaranes",             "Total primer descuento definible",    "GetHbVar('nTotUno')" )
   oFr:AddVariable(     "Albaranes",             "Total segundo descuento definible",   "GetHbVar('nTotDos')" )
   oFr:AddVariable(     "Albaranes",             "Total " + cImp(),                           "GetHbVar('nTotIva')" )
   oFr:AddVariable(     "Albaranes",             "Total RE",                            "GetHbVar('nTotReq')" )
   oFr:AddVariable(     "Albaranes",             "Total retención",                     "GetHbVar('nTotRet')" )
   oFr:AddVariable(     "Albaranes",             "Bruto primer tipo de " + cImp(),            "GetHbArrayVar('aIvaUno',1)" )
   oFr:AddVariable(     "Albaranes",             "Bruto segundo tipo de " + cImp(),           "GetHbArrayVar('aIvaDos',1)" )
   oFr:AddVariable(     "Albaranes",             "Bruto tercer tipo de " + cImp(),            "GetHbArrayVar('aIvaTre',1)" )
   oFr:AddVariable(     "Albaranes",             "Base primer tipo de " + cImp(),             "GetHbArrayVar('aIvaUno',2)" )
   oFr:AddVariable(     "Albaranes",             "Base segundo tipo de " + cImp(),            "GetHbArrayVar('aIvaDos',2)" )
   oFr:AddVariable(     "Albaranes",             "Base tercer tipo de " + cImp(),             "GetHbArrayVar('aIvaTre',2)" )
   oFr:AddVariable(     "Albaranes",             "Porcentaje primer tipo " + cImp(),          "GetHbArrayVar('aIvaUno',3)" )
   oFr:AddVariable(     "Albaranes",             "Porcentaje segundo tipo " + cImp(),         "GetHbArrayVar('aIvaDos',3)" )
   oFr:AddVariable(     "Albaranes",             "Porcentaje tercer tipo " + cImp(),          "GetHbArrayVar('aIvaTre',3)" )
   oFr:AddVariable(     "Albaranes",             "Porcentaje primer tipo RE",           "GetHbArrayVar('aIvaUno',4)" )
   oFr:AddVariable(     "Albaranes",             "Porcentaje segundo tipo RE",          "GetHbArrayVar('aIvaDos',4)" )
   oFr:AddVariable(     "Albaranes",             "Porcentaje tercer tipo RE",           "GetHbArrayVar('aIvaTre',4)" )
   oFr:AddVariable(     "Albaranes",             "Importe primer tipo " + cImp(),             "GetHbArrayVar('aIvaUno',5)" )
   oFr:AddVariable(     "Albaranes",             "Importe segundo tipo " + cImp(),            "GetHbArrayVar('aIvaDos',5)" )
   oFr:AddVariable(     "Albaranes",             "Importe tercer tipo " + cImp(),             "GetHbArrayVar('aIvaTre',5)" )
   oFr:AddVariable(     "Albaranes",             "Importe primer RE",                   "GetHbArrayVar('aIvaUno',6)" )
   oFr:AddVariable(     "Albaranes",             "Importe segundo RE",                  "GetHbArrayVar('aIvaDos',6)" )
   oFr:AddVariable(     "Albaranes",             "Importe tercer RE",                   "GetHbArrayVar('aIvaTre',6)" )

   oFr:AddVariable(     "Lineas de albaranes",   "Código del artículo con propiedades",      "CallHbFunc('cCodAlbPrv')" )
   oFr:AddVariable(     "Lineas de albaranes",   "Detalle del artículo",                     "CallHbFunc('cDesAlbPrv')" )
   oFr:AddVariable(     "Lineas de albaranes",   "Total unidades artículo",                  "CallHbFunc('nTotNAlbPrv')" )
   oFr:AddVariable(     "Lineas de albaranes",   "Precio unitario del artículo",             "CallHbFunc('nTotUAlbPrv')" )
   oFr:AddVariable(     "Lineas de albaranes",   "Total línea de albaran",                   "CallHbFunc('nTotLAlbPrv')" )
   oFr:AddVariable(     "Lineas de albaranes",   "Código de barras para primera propiedad",  "CallHbFunc('cBarPrp1')" )
   oFr:AddVariable(     "Lineas de albaranes",   "Código de barras para segunda propiedad",  "CallHbFunc('cBarPrp2')" )

Return nil

//---------------------------------------------------------------------------//

Function DesignReportAlbPrv( oFr, dbfDoc )

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
                                                   "CallHbFunc('nTotAlbPrv');"                                 + Chr(13) + Chr(10) + ;
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

Function PrintReportAlbPrv( nDevice, nCopies, cPrinter, dbfDoc )

   local oFr
   local cFilePdf       := cPatTmp() + "AlbaranProveedor" +  ( dbfAlbPrvT )->cSerAlb + Alltrim( Str( ( dbfAlbPrvT )->nNumAlb ) ) + ".Pdf"

   DEFAULT nCopies      := 1
   DEFAULT nDevice      := IS_SCREEN
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

                  :SetTypeDocument( "nAlbPrv" )
                  :SetDe(           uFieldEmpresa( "cNombre" ) )
                  :SetCopia(        uFieldEmpresa( "cCcpMai" ) )
                  :SetAdjunto(      cFilePdf )
                  :SetPara(         RetFld( ( dbfAlbPrvT )->cCodPrv, dbfPrv, "cMeiInt" ) )
                  :SetAsunto(       "Envio de albaran de proveedor número " + ( dbfAlbPrvT )->cSerAlb + "/" + Alltrim( Str( ( dbfAlbPrvT )->nNumAlb ) ) )
                  :SetMensaje(      "Adjunto le remito nuestro albaran de proveedor " + ( dbfAlbPrvT )->cSerAlb + "/" + Alltrim( Str( ( dbfAlbPrvT )->nNumAlb ) ) + Space( 1 ) )
                  :SetMensaje(      "de fecha " + Dtoc( ( dbfAlbPrvT )->dfecAlb ) + Space( 1 ) )
                  :SetMensaje(      CRLF )
                  :SetMensaje(      CRLF )
                  :SetMensaje(      "Reciba un cordial saludo." )

                  :GeneralResource( dbfAlbPrvT, aItmAlbPrv() )

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
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

FUNCTION nIncUAlbPrv( dbfTmpLin, nDec, nVdv )

   local nCalculo

   DEFAULT nDec   := 0
   DEFAULT nVdv   := 1

   nCalculo       := nTotUAlbPrv( dbfTmpLin, nDec, nVdv )

   if !( dbfTmpLin )->lIvaLin
      nCalculo    += nCalculo * ( dbfTmpLin )->nIva / 100
   end if

   IF nVdv != 0
      nCalculo    := nCalculo / nVdv
   END IF

RETURN ( Round( nCalculo, nDec ) )

//---------------------------------------------------------------------------//

FUNCTION nIncLAlbPrv( dbfLin, nDec, nRouDec, nVdv )

   local nCalculo := nTotLAlbPrv( dbfLin, nDec, nRouDec, nVdv )

   if !( dbfLin )->lIvaLin
      nCalculo    += nCalculo * ( dbfLin )->nIva / 100
   end if

RETURN ( nCalculo )

//---------------------------------------------------------------------------//

Static Function YearComboBoxChange()

	 if oWndBrw:oWndBar:lAllYearComboBox()
		DestroyFastFilter( dbfAlbPrvT )
      CreateUserFilter( "", dbfAlbPrvT, .f., , , "all" )
	 else
		DestroyFastFilter( dbfAlbPrvT )
      CreateUserFilter( "Year( Field->dFecAlb ) == " + oWndBrw:oWndBar:cYearComboBox(), dbfAlbPrvT, .f., , , "Year( Field->dFecAlb ) == " + oWndBrw:oWndBar:cYearComboBox() )
	 end if

	 ( dbfAlbPrvT )->( dbGoTop() )

	 oWndBrw:Refresh()

Return nil

//---------------------------------------------------------------------------//

FUNCTION cBarPrp1( uAlbPrvL, uTblPro )

   local cBarPrp1    := ""

   DEFAULT uAlbPrvL  := if( !Empty( tmpAlbPrvL ), tmpAlbPrvL, dbfAlbPrvL )
   DEFAULT uTblPro   := dbfTblPro

   if dbSeekInOrd( ( uAlbPrvL )->cCodPr1 + ( uAlbPrvL )->cValPr1, "cCodPro", uTblPro )
      cBarPrp1       := ( uTblPro )->nBarTbl
   end if

RETURN ( cBarPrp1 )

//---------------------------------------------------------------------------//

FUNCTION cBarPrp2( uAlbPrvL, uTblPro )

   local cBarPrp2    := ""

   DEFAULT uAlbPrvL  := if( !Empty( tmpAlbPrvL ), tmpAlbPrvL, dbfAlbPrvL )
   DEFAULT uTblPro   := dbfTblPro

   if dbSeekInOrd( ( uAlbPrvL )->cCodPr2 + ( uAlbPrvL )->cValPr2, "cCodPro", uTblPro )
      cBarPrp2       := ( uTblPro )->nBarTbl
   end if

RETURN ( cBarPrp2 )

//---------------------------------------------------------------------------//

Function IcgMotor()

   local oDlg
   local aFichero
   local oInforme
   local oBrwFichero
   local oTreeImportacion
   local oImageImportacion

   aFichero                         := {}
   cInforme                         := ""

   DEFINE DIALOG oDlg RESOURCE "ImportarICG"

      /*
      Browse de ficheros a importar--------------------------------------------
      */

      oBrwFichero                   := TXBrowse():New( oDlg )

      oBrwFichero:bClrSel           := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwFichero:bClrSelFocus      := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrwFichero:SetArray( aFichero, , , .f. )

      oBrwFichero:nMarqueeStyle     := 5

      oBrwFichero:lHScroll          := .f.

      oBrwFichero:CreateFromResource( 220 )

      oBrwFichero:bLDblClick        := {|| ShellExecute( oDlg:hWnd, "open", Rtrim( aFichero[ oBrwFichero:nArrayAt ] ) ) }

      with object ( oBrwFichero:AddCol() )
         :cHeader          := "Fichero"
         :bEditValue       := {|| aFichero[ oBrwFichero:nArrayAt ] }
         :nWidth           := 460
      end with

      REDEFINE BUTTON ;
         ID       200 ;
         OF       oDlg ;
         ACTION   ( AddFicheroICG( aFichero, oBrwFichero ) )

      REDEFINE BUTTON ;
         ID       210 ;
         OF       oDlg ;
         ACTION   ( DelFicheroICG( aFichero, oBrwFichero ) )

      /*
      Tree de importación------------------------------------------------------
      */

      REDEFINE GET oInforme VAR cInforme ;
         MEMO ;
         ID       230;
			OF 		oDlg

      REDEFINE BUTTON ;
         ID       IDOK ;
         OF       oDlg ;
         ACTION   ( IcgAlbPrv( aFichero, oDlg, oInforme ) )

      REDEFINE BUTTON ;
         ID       IDCANCEL ;
         OF       oDlg ;
         CANCEL ;
         ACTION   ( oDlg:end() )

      oDlg:AddFastKey( VK_F5, {|| IcgAlbPrv( aFichero, oDlg, oInforme ) } )

   ACTIVATE DIALOG oDlg CENTER

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

#define OFN_PATHMUSTEXIST            0x00000800
#define OFN_NOCHANGEDIR              0x00000008
#define OFN_ALLOWMULTISELECT         0x00000200
#define OFN_EXPLORER                 0x00080000     // new look commdlg
#define OFN_LONGNAMES                0x00200000     // force long names for 3.x modules
#define OFN_ENABLESIZING             0x00800000

//---------------------------------------------------------------------------//

Static Function AddFicheroICG( aFichero, oBrwFichero )

   local i
   local cFile
   local aFile
   local nFlag    := nOr( OFN_PATHMUSTEXIST, OFN_NOCHANGEDIR, OFN_ALLOWMULTISELECT, OFN_EXPLORER, OFN_LONGNAMES )

   cFile          := cGetFile( "All | *.*", "Seleccione los ficheros a importar", "*.*" , , .f., .t., nFlag )
   cFile          := Left( cFile, At( Chr( 0 ) + Chr( 0 ), cFile ) - 1 )

   if !Empty( cFile ) //.or. Valtype( cFile ) == "N"

      cFile       := StrTran( cFile, Chr( 0 ), "," )
      aFile       := hb_aTokens( cFile, "," )

      if Len( aFile ) > 1

         for i := 2 to Len( aFile )
            aFile[ i ] := aFile[ 1 ] + "\" + aFile[ i ]
         next

         aDel( aFile, 1, .t. )

      endif

      if IsArray( aFile )

         for i := 1 to Len( aFile )
            aAdd( aFichero, aFile[ i ] ) // if( SubStr( aFile[ i ], 4, 1 ) == "\", aFileDisc( aFile[i] ) + "\" + aFileName( aFile[ i ] ), aFile[ i ] ) )
         next

      else

         aAdd( aFichero, aFile )

      endif

   end if

   oBrwFichero:Refresh()

RETURN ( aFichero )

//---------------------------------------------------------------------------//

Static Function DelFicheroICG( aFichero, oBrwFichero )

   aDel( aFichero, oBrwFichero:nArrayAt, .t. )

   oBrwFichero:Refresh()

RETURN ( nil )

//---------------------------------------------------------------------------//

FUNCTION IcgAlbPrv( aFichero, oDlg, oInforme )

   local nBytes
   local aTotAlb
   local cSerDoc
   local nNumDoc
   local cSufDoc
   local dFecDoc
   local cRefLin
   local cDesLin
   local nUntLin
   local nPvpLin
   local nDtoLin
   local cFilEdm
   local hFilEdm
   local cBuffer

   cInforme                := ""

   /*
   Obtenemos la fecha del albaran----------------------------------------------
   */

   for each cFilEdm in aFichero

      if file( cFilEdm )

         cInforme          += "Importando el fichero " + cFilEdm + CRLF

         /*
         Abrimos las bases de datos--------------------------------------------------
         */

         hFilEdm           := fOpen( cFilEdm )

         fSeek( hFilEdm, 0, 0 )

         SysRefresh()

         cBuffer           := Space( _ICG_LINE_LEN_ )
         nBytes            := fRead( hFilEdm, @cBuffer, _ICG_LINE_LEN_ )

         cSerDoc           := SubStr( cBuffer,  9, 1 )
         nNumDoc           := SubStr( cBuffer, 11, 8 )
         cSufDoc           := SubStr( cBuffer,  9, 2 )
         dFecDoc           := SubStr( cBuffer, 20, 8 )

         IcgCabAlbPrv( cSerDoc, nNumDoc, cSufDoc, dFecDoc )

         cBuffer           := Space( _ICG_LINE_LEN_ )

         nBytes            := fRead( hFilEdm, @cBuffer, _ICG_LINE_LEN_ )

         cBuffer           := Space( _ICG_LINE_LEN_ )

         while ( nBytes    := fRead( hFilEdm, @cBuffer, _ICG_LINE_LEN_ ) ) == _ICG_LINE_LEN_

            cBuffer        := Alltrim( cBuffer )

            cDesLin        := Upper( AllTrim( SubStr( cBuffer, 21, 30 ) ) )

            nUntLin        := SubStr( cBuffer, 57, 5 )

            if At( "-", nUntLin ) != 0
               nUntLin     := StrTran( nUntLin, "-", "" )
               nUntLin     := Val( nUntLin ) * -1
            else
               nUntLin     := Val( nUntLin )
            end if

            nPvpLin        := Val( SubStr( cBuffer, 63, 7 ) )

            nDtoLin        := Val( SubStr( cBuffer, 71, 7 ) )

            if ( nDtoLin >= 100 )

               cRefLin     := Alltrim( SubStr( cBuffer, 87, 8 ) )

               // Desplazamiento por los melones de Andel----------------------

               fRead( hFilEdm, @cBuffer, 1 )

            else

               cRefLin     := Alltrim( SubStr( cBuffer, 87, 8 ) )

            end if

            if Left( cDesLin, 1 ) != "*"
               IcgDetAlbPrv( cSerDoc, cSufDoc, cDesLin, nUntLin, nPvpLin, nDtoLin, cRefLin )
            end if

            SysRefresh()

            /*
            MsgStop( "deslin :" + cvaltochar( cDesLin ) + CRLF + ;
                     "nUntLin :" + cvaltochar( nUntLin) + CRLF + ;
                     "nPvpLin :" + cvaltochar( nPvpLin) + CRLF + ;
                     "nDtoLin :" + cvaltochar( nDtoLin) + CRLF + ;
                     "cRefLin :" + cvaltochar( cRefLin) + CRLF,;
                     cBuffer )
            */

            cBuffer        := Space( _ICG_LINE_LEN_ )

         end while

         fClose( hFilEdm )

         // Recalculo del total------------------------------------------------

         if dbLock( dbfAlbPrvT )

            aTotAlb                 := aTotAlbPrv( ( dbfAlbPrvT )->cSerAlb + Str( ( dbfAlbPrvT )->nNumAlb ) + ( dbfAlbPrvT )->cSufAlb, dbfAlbPrvT, dbfAlbPrvL, dbfIva, dbfDiv, ( dbfAlbPrvT )->cDivAlb )

            ( dbfAlbPrvT )->nTotNet := aTotAlb[ 1 ]
            ( dbfAlbPrvT )->nTotIva := aTotAlb[ 2 ]
            ( dbfAlbPrvT )->nTotReq := aTotAlb[ 3 ]
            ( dbfAlbPrvT )->nTotAlb := aTotAlb[ 4 ]

            ( dbfAlbPrvT )->( dbUnLock() )

         end if

      else

         cInforme                   += "No existe el fichero " + cFilEdm + CRLF

      end if

   next

   oInforme:cText( cInforme )

RETURN ( nil )

//---------------------------------------------------------------------------//

Static Function IcgCabAlbPrv( cSerDoc, nNumDoc, cSufDoc, dFecDoc )

   local lApp
   local cCodPrv                 := Replicate( "0", RetNumCodPrvEmp() )

   if dbSeekInOrd( cSerDoc + nNumDoc + cSufDoc, "cSuAlb", dbfAlbPrvT )

      lApp                       := .f.
      cSerDoc                    := ( dbfAlbPrvT )->cSerAlb
      nNumAlb                    := ( dbfAlbPrvT )->nNumAlb
      cSufDoc                    := ( dbfAlbPrvT )->cSufAlb

      while ( dbfAlbPrvL )->( dbSeek( cSerDoc + Str( nNumAlb ) + cSufDoc ) )
         if dbLock( dbfAlbPrvL )
            ( dbfAlbPrvL )->( dbDelete() )
            ( dbfAlbPrvL )->( dbUnLock() )
         end if
      end while

   else

      lApp                       := .t.
      nNumAlb                    := nNewDoc( cSerDoc, dbfAlbPrvT, "nAlbPrv", , dbfCount )

   end if

   if lApp
      dbAppe( dbfAlbPrvT )
   else
      dbLock( dbfAlbPrvT )
   end if

      ( dbfAlbPrvT )->cSerAlb    := cSerDoc
      ( dbfAlbPrvT )->nNumAlb    := nNumAlb
      ( dbfAlbPrvT )->cSufAlb    := cSufDoc
      ( dbfAlbPrvT )->dFecAlb    := Stod( dFecDoc )
      ( dbfAlbPrvT )->cCodAlm    := oUser():cAlmacen()
      ( dbfAlbPrvT )->cDivAlb    := cDivEmp()
      ( dbfAlbPrvT )->nVdvAlb    := nChgDiv( cDivEmp(), dbfDiv )
      ( dbfAlbPrvT )->cSuAlb     := cSerDoc + nNumDoc + cSufDoc
      ( dbfAlbPrvT )->cCodUsr    := cCurUsr()
      ( dbfAlbPrvT )->cCodDlg    := oUser():cDelegacion()
      ( dbfAlbPrvT )->cCodCaj    := oUser():cCaja()
      ( dbfAlbPrvT )->cTurAlb    := cCurSesion()

      ( dbfAlbPrvT )->cCodPrv    := cCodPrv

      if ( dbfPrv )->( dbSeek( cCodPrv ) )
         ( dbfAlbPrvT )->cNomPrv := ( dbfPrv )->Titulo
         ( dbfAlbPrvT )->cDirPrv := ( dbfPrv )->Domicilio
         ( dbfAlbPrvT )->cPobPrv := ( dbfPrv )->Poblacion
         ( dbfAlbPrvT )->cProPrv := ( dbfPrv )->Provincia
         ( dbfAlbPrvT )->cPosPrv := ( dbfPrv )->CodPostal
         ( dbfAlbPrvT )->cDniPrv := ( dbfPrv )->Nif
      end if

   ( dbfAlbPrvT )->( dbUnlock() )

RETURN ( nil )

//---------------------------------------------------------------------------//

Static Function IcgDetAlbPrv( cSerDoc, cSufDoc, cDesLin, nUntLin, nPvpLin, nDtoLin, cRefLin )

   if !dbSeekInOrd( cRefLin, "Codigo", dbfArticulo )
      cInforme                += "Articulo " + cRefLin + " no existe en la base de datos, albaran número " + cSerDoc + "/" + Alltrim( Str( nNumAlb ) ) + "/" + RetSufEmp() + CRLF
   end if

   ( dbfAlbPrvL )->( dbAppend() )
   ( dbfAlbPrvL )->cSerAlb    := cSerDoc
   ( dbfAlbPrvL )->nNumAlb    := nNumAlb
   ( dbfAlbPrvL )->cSufAlb    := cSufDoc
   ( dbfAlbPrvL )->cAlmLin    := oUser():cAlmacen()
   ( dbfAlbPrvL )->cRef       := cRefLin
   ( dbfAlbPrvL )->cDetalle   := cDesLin
   ( dbfAlbPrvL )->mLngDes    := cDesLin
   ( dbfAlbPrvL )->nUniCaja   := nUntLin
   ( dbfAlbPrvL )->nPreDiv    := nPvpLin
   ( dbfAlbPrvL )->nDtoLin    := nDtoLin
   ( dbfAlbPrvL )->nIva       := nIva( dbfIva, "G" )
   ( dbfAlbPrvL )->( dbUnlock() )

RETURN ( nil )

//---------------------------------------------------------------------------//

Function dFechaCaducidadLote( cCodArt, cValPr1, cValPr2, cLote, dbfAlbPrvL, dbfFacPrvL )

   local dFechaCaducidad      := Ctod( "" )

   if dbSeekInOrd( cCodArt + cValPr1 + cValPr2 + cLote, "cRefLote", dbfAlbPrvL )
      dFechaCaducidad         := ( dbfAlbPrvL )->dFecCad
   else
      if dbSeekInOrd( cCodArt + cValPr1 + cValPr2 + cLote, "cRefLote", dbfFacPrvL )
         dFechaCaducidad      := ( dbfFacPrvL )->dFecCad
      end if
   end if

Return ( dFechaCaducidad )

//---------------------------------------------------------------------------//

Static Function EditarNumerosSerie( aTmp, nMode )

   oNumerosSerie:nMode              := nMode

   oNumerosSerie:cCodArt            := aTmp[ _CREF    ]
   oNumerosSerie:cCodAlm            := aTmp[ _CALMLIN ]
   oNumerosSerie:nNumLin            := aTmp[ _NNUMLIN ]
   oNumerosSerie:lAutoSerializacion := aTmp[ _LAUTSER ]

   oNumerosSerie:nTotalUnidades     := nTotNAlbPrv( aTmp )

   oNumerosSerie:uTmpSer            := dbfTmpSer

   if oNumerosSerie:lAutoSerializacion
       oNumerosSerie:AutoSerializa()
   end if

   oNumerosSerie:Resource()

Return ( nil )

//--------------------------------------------------------------------------//

Static Function AutoNumerosSerie( aTmp, nMode )

   oNumerosSerie:nMode              := nMode

   oNumerosSerie:cCodArt            := aTmp[ _CREF    ]
   oNumerosSerie:cCodAlm            := aTmp[ _CALMLIN ]
   oNumerosSerie:nNumLin            := aTmp[ _NNUMLIN ]
   oNumerosSerie:lAutoSerializacion := aTmp[ _LAUTSER ]

   oNumerosSerie:nTotalUnidades     := nTotNAlbPrv( aTmp )

   oNumerosSerie:uTmpSer            := dbfTmpSer

   if oNumerosSerie:lAutoSerializacion
       oNumerosSerie:AutoSerializa()
   end if

Return ( nil )

//----------------------------------------------------------------------------//

Static Function EliminarNumeroSerie( aTmp )

   while ( ( dbfTmpSer )->( dbSeek( Str( aTmp[ _NNUMLIN ], 4 ) + aTmp[ _CREF ] ) ) ) .and. !( dbfTmpSer )->( Eof() )
      ( dbfTmpSer )->( dbDelete() )
   end while

Return ( nil )

//----------------------------------------------------------------------------//