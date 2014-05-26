#include "FiveWin.Ch"
#include "Font.ch"
#include "Folder.ch"
#include "Factu.ch" 
#include "Report.ch"
#include "Label.ch"
#include "FastRepH.ch"
#include "Xbrowse.ch"  

#define CLR_BAR                  14197607
#define _MENUITEM_               "01048"

#define _CSERFAC                 1    //   C      1     0
#define _NNUMFAC                 2    //   N      9     0
#define _CSUFFAC                 3    //   N      9     0
#define _CTURFAC                 4    //   C      6     0
#define _DFECFAC                 5    //   D      8     0
#define _CCODPRV                 6    //   C      7     0
#define _CCODALM                 7    //   C      3     0
#define _CCODCAJ                 8    //   C      3     0
#define _CNOMPRV                 9    //   C     35     0
#define _CDIRPRV                 10   //   C     35     0
#define _CPOBPRV                 11   //   C     25     0
#define _CPROVPROV               12   //   C     20     0
#define _CPOSPRV                 13   //   C      5     0
#define _CDNIPRV                 14   //   C     15     0
#define _LLIQUIDADA              15   //   L      1     0
#define _LCONTAB                 16   //   L      1     0
#define _DFECENT                 17   //   D      8     0
#define _CSUPED                  18   //   C     10     0
#define _CCONDENT                19   //   C     20     0
#define _MCOMENT                 20   //   M     10     0  Comentarios
#define _CEXPED                  21   //   C     20     0
#define _COBSERV                 22   //   C     20     0
#define _CCODPAGO                23   //   C      2     0
#define _NBULTOS                 24   //   N      3     0
#define _NPORTES                 25   //   N      6     0
#define _CNUMALB                 26   //   C     12     0
#define _CSUFALB                 27   //   C     12     0
#define _LIMPALB                 28   //   L      1     0
#define _CDTOESP                 29   //   N      4     1
#define _NDTOESP                 30   //   N      4     1
#define _CDPP                    31   //   N      4     1
#define _NDPP                    32   //   N      4     1
#define _LRECARGO                33   //   L      1     0
#define _NIRPF                   34   //   N      4     1
#define _CCODAGE                 35   //   C      3     0
#define _CDIVFAC                 36   //   C      3     0
#define _NVDVFAC                 37   //   N     10     4
#define _LSNDDOC                 38   //   L      1     0
#define _CDTOUNO                 39   //   N      4     1
#define _NDTOUNO                 40   //   N      4     1
#define _CDTODOS                 41   //   N      4     1
#define _NDTODOS                 42   //   N      4     1
#define _CCODPRO                 43   //
#define _LRECDOC                 44   //   L      1     0
#define _LCLOFAC                 45   //   L      1     0
#define _CNUMDOC                 46   //   C     20     0
#define _CCODUSR                 47
#define _LIMPRIMIDO              48   //   L      1     0
#define _DFECIMP                 49   //   D      8     0
#define _CHORIMP                 50   //   C      5     0
#define _NTIPRET                 51
#define _NPCTRET                 52
#define _DFECCHG                 53   //   D      8     0
#define _CTIMCHG                 54   //   C      5     0
#define _CCODDLG                 55   //   C      2     0
#define _NREGIVA                 56   //   L      1     0
#define _LFACGAS                 57
#define _MCOMGAS                 58
#define _NNETGAS1                59
#define _NNETGAS2                60
#define _NNETGAS3                61
#define _NIVAGAS1                62
#define _NIVAGAS2                63
#define _NIVAGAS3                64
#define _NREGAS1                 65
#define _NREGAS2                 66
#define _NREGAS3                 67
#define _NTOTNET                 68
#define _NTOTIVA                 69
#define _NTOTREQ                 70
#define _NTOTFAC                 71
#define _CNFC                    72
#define _SUBCTA                  73
#define _NTOTSUP                 74
#define _CBANCO                  75
#define _CPAISIBAN               76
#define _CCTRLIBAN               77
#define _CENTBNC                 78
#define _CSUCBNC                 79
#define _CDIGBNC                 80
#define _CCTABNC                 81
#define _LRECC                   82

/*
Lineas de Detalle
*/

#define _CREF                     4      //   C     10     0
#define _CREFPRV                  5      //
#define _CDETALLE                 6      //   C     50     0
#define _NPREUNIT                 7      //   N     13     4
#define _NDTO                     8      //   N      5     1
#define _NIVA                     9      //   N      6     2
#define _NCANENT                 10      //   N     13     4
#define _LCONTROL                11      //   L      1     0
#define _CUNIDAD                 12      //   C      2     0
#define _NUNICAJA                13      //   N      8     3
#define _LCHGLIN                 14      //   L      1     0
#define _MLNGDES                 15      //   M     10     0
#define _NDTOLIN                 16      //   N      5     2
#define _NDTOPRM                 17      //   N      5     2
#define _NDTORAP                 18      //   N      5     2
#define _NPRECOM                 19      //   N      5     2
#define _LBNFLIN1                20      //   N      5     1
#define _LBNFLIN2                21      //   N      5     1
#define _LBNFLIN3                22      //   N      5     1
#define _LBNFLIN4                23      //   N      5     1
#define _LBNFLIN5                24      //   N      5     1
#define _LBNFLIN6                25      //   N      5     1
#define _NBNFLIN1                26      //   N      5     1
#define _NBNFLIN2                27      //   N      5     1
#define _NBNFLIN3                28      //   N      5     1
#define _NBNFLIN4                29      //   N      5     1
#define _NBNFLIN5                30      //   N      5     1
#define _NBNFLIN6                31      //   N      5     1
#define _NBNFSBR1                32      //   N     13     3
#define _NBNFSBR2                33      //   N     13     3
#define _NBNFSBR3                34      //   N     13     3
#define _NBNFSBR4                35      //   N     13     3
#define _NBNFSBR5                36      //   N     13     3
#define _NBNFSBR6                37      //   N     13     3
#define _NPVPLIN1                38      //   N      6     2
#define _NPVPLIN2                39      //   L      1     0
#define _NPVPLIN3                40      //   C      5     0
#define _NPVPLIN4                41      //   C      5     0
#define _NPVPLIN5                42      //   C      5     0
#define _NPVPLIN6                43      //   C      5     0
#define _NIVALIN1                44      //   N     13     4
#define _NIVALIN2                45      //   C      3     0
#define _NIVALIN3                46      //   C      3     0
#define _NIVALIN4                47      //   L      1     0
#define _NIVALIN5                48      //   N      4     0
#define _NIVALIN6                49
#define _NIVALIN                 50
#define _LIVALIN                 51      //   L     1      0
#define _CCODPR1                 52
#define _CCODPR2                 53      //   L     4      0
#define _CVALPR1                 54
#define _CVALPR2                 55
#define _NFACCNV                 56
#define _CALMLIN                 57
#define _NCTLSTK                 58
#define _LLOTE                   59
#define _NLOTE                   60
#define _CLOTE                   61
#define _NNUMLIN                 62
#define _NUNDKIT                 63
#define _LKITART                 64
#define _LKITCHL                 65
#define _LKITPRC                 66
#define _LIMPLIN                 67
#define _MNUMSER                 68
#define _CCODUBI1                69
#define _CCODUBI2                70
#define _CCODUBI3                71
#define _CVALUBI1                72
#define _CVALUBI2                73
#define _CVALUBI3                74
#define _CNOMUBI1                75
#define _CNOMUBI2                76
#define _CNOMUBI3                77
#define _CCODFAM                 78   //    C    8    0
#define _CGRPFAM                 79   //    C    3    0
#define _NREQ                    80   //    N   16    6
#define _MOBSLIN                 81   //    M   10    0
#define _NPVPREC                 82
#define _NNUMMED                 83
#define _NMEDUNO                 84
#define _NMEDDOS                 85
#define _NMEDTRE                 86
#define _DFECCAD                 87   //    D    8    0
#define _NUNDLIN                 88
#define _LLABEL                  89
#define _NLABEL                  90
#define __CSUPED                 91
#define _LGASSUP                 92
#define __DFECFAC                93
#define __CCODPRV                94
#define _LNUMSER                 95
#define _LAUTSER                 96

/*
Definici¢n de Array para impuestos--------------------------------------------------
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

/*
Variables memvar para todo el .prg logico no-----------------------------------
*/

memvar cDbf
memvar cDbfCol
memvar cDbfRec
memvar cDbfAlm
memvar cDbfPrv
memvar cDbfPgo
memvar cDbfIva
memvar cDbfDiv
memvar cDbfArt
memvar cDbfKit
memvar cDbfPro
memvar cDbfTblPro
memvar aTotIva
memvar aIvaUno
memvar aIvaDos
memvar aIvaTre
memvar aDatVcto
memvar aImpVcto
memvar nTotBrt
memvar nTotNet
memvar nTotSup
memvar nTotIva
memvar nTotReq
memvar nTotRet
memvar nTotFac
memvar nTotDto
memvar nTotDpp
memvar nTotUno
memvar nTotDos
memvar nTotImp
memvar nTotUnd
memvar nPagFac
memvar nTipRet
memvar nTotPage
memvar cPinDivFac
memvar cPirDivFac
memvar cPicEurFac
memvar nDinDivFac
memvar nDirDivFac
memvar nVdvDivFac
memvar nPagina
memvar lEnd
memvar aImpVto
memvar aDatVto

/*
Variables Staticas para todo el .prg logico no!
*/

static oWndBrw
static oBrwIva
static oInf
static dbfFacPrvT
static dbfRctPrvT
static dbfRctPrvL
static dbfIva
static dbfInci
static dbfFacPrvL
static filFacPrvL
static tmpFacPrvT
static tmpFacPrvP
static tmpFacPrvL
static tmpFacPrvI
static tmpFacPrvS
static dbfFacPrvP
static dbfFacPrvI
static dbfFacPrvD
static dbfFacPrvS
static dbfPedPrvT
static dbfPedPrvL
static dbfPrv
static dbfArtPrv
static dbfFPago
static dbfTmp
static dbfTmpSer
static dbfKit
static dbfArticulo
static dbfUbicaL
static dbfCodebar
static dbfFamilia
static dbfTblCnv
static dbfArtCom
static dbfPro
static dbfDoc
static dbfCajT
static dbfTblPro
static dbfDiv
static dbfUsr

static dbfCount
static oBandera
static dbfAlbPrvT
static dbfAlbPrvL
static dbfAlbPrvS
static dbfDelega
static dbfEmp
static dbfAlm
static dbfPedCliL
static dbfAlbCliL
static dbfFacCliL
static dbfFacRecL
static dbfTikCliL
static dbfProLin
static dbfProMat
static dbfHisMov
static oStock
static cNewFile
static cPicEur
static cPicUnd
static cPinDiv
static cPouDiv
static cPorDiv
static cTmpInc
static cTmpDoc
static cTmpPgo
static cTmpSer
static dbfTmpInc
static dbfTmpDoc
static dbfTmpPgo
static cPirDiv
static nDinDiv
static nRinDiv
static oGetTotal
static oGetTotPg
static oGetRet
static oGetNet
static oGetIva
static oGetReq
static oGetPgd
static oGetPdt
static oUsr
static cUsr
static oFntTot
static oBanco
static dbfPrvBnc
static oUndMedicion

static oMnuPgo
static oMnuRec

static aNumAlb          := {}
static nGetNeto         := 0
static nGetIva          := 0
static nGetReq          := 0
static nGetPgd          := 0
static cOldCodCli       := ""
static cOldCodArt       := ""
static cOldPrpArt       := ""
static cOldUndMed       := ""
static lOpenFiles       := .f.
static lExternal        := .f.
static nLabels          := 1
static cFiltroUsuario   := ""
static bEdtRec          := { |aTmp, aGet, dbfFacPrvT, oBrw, bWhen, bValid, nMode, cNumAlb | EdtRec( aTmp, aGet, dbfFacPrvT, oBrw, bWhen, bValid, nMode, cNumAlb ) }
static bEdtDet          := { |aTmp, aGet, dbfFacPrvT, oBrw, bWhen, bValid, nMode, aFac    | EdtDet( aTmp, aGet, dbfFacPrvT, oBrw, bWhen, bValid, nMode ) }
static bEdtInc          := { |aTmp, aGet, dbfFacPrvI, oBrw, bWhen, bValid, nMode, aTmpLin | EdtInc( aTmp, aGet, dbfFacPrvI, oBrw, bWhen, bValid, nMode, aTmpLin ) }
static bEdtDoc          := { |aTmp, aGet, dbfFacPrvD, oBrw, bWhen, bValid, nMode, aTmpLin | EdtDoc( aTmp, aGet, dbfFacPrvD, oBrw, bWhen, bValid, nMode, aTmpLin ) }

static oNumerosSerie
static oBtnNumerosSerie

static nView

//----------------------------------------------------------------------------//
//Funciones del programa
//----------------------------------------------------------------------------//

STATIC FUNCTION OpenFiles( lExt )

   local oBlock

   if lOpenFiles
      MsgStop( 'Imposible abrir ficheros de facturas a proveedores' )
      Return ( .f. )
   end if

   DEFAULT lExt         := .f.

   lExternal            := lExt

   oBlock               := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      DisableAcceso()

      lOpenFiles        := .t.

      nView             := TDataView():CreateView()

      TDataView():FacturasProveedores( nView )

      TDataView():Proveedores( nView )

      TDataView():GruposProveedores( nView )


      USE ( cPatEmp() + "FACPRVL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACPRVL", @dbfFacPrvL ) )
      SET ADSINDEX TO ( cPatEmp() + "FACPRVL.CDX" ) ADDITIVE

      USE ( cPatEmp() + "FACPRVI.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACPRVI", @dbfFacPrvI ) )
      SET ADSINDEX TO ( cPatEmp() + "FACPRVI.CDX" ) ADDITIVE

      USE ( cPatEmp() + "FACPRVD.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACPRVD", @dbfFacPrvD ) )
      SET ADSINDEX TO ( cPatEmp() + "FACPRVD.CDX" ) ADDITIVE

      USE ( cPatEmp() + "FACPRVS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACPRVS", @dbfFacPrvS ) )
      SET ADSINDEX TO ( cPatEmp() + "FACPRVS.CDX" ) ADDITIVE

      USE ( cPatEmp() + "FACPRVP.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACPRVP", @dbfFacPrvP ) )
      SET ADSINDEX TO ( cPatEmp() + "FACPRVP.CDX" ) ADDITIVE

      USE ( cPatDat() + "TIVA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIVA", @dbfIva ) )
      SET ADSINDEX TO ( cPatDat() + "TIVA.CDX" ) ADDITIVE

      USE ( cPatArt() + "PROVART.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PROVART", @dbfArtPrv ) )
      SET ADSINDEX TO ( cPatArt() + "PROVART.CDX" ) ADDITIVE
      SET TAG TO "cCodPrv"

      USE ( cPatArt() + "ARTICULO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ARTICULO", @dbfArticulo ) )
      SET ADSINDEX TO ( cPatArt() + "ARTICULO.CDX" ) ADDITIVE

      USE ( cPatArt() + "ArtCodebar.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CODEBAR", @dbfCodebar ) )
      SET ADSINDEX TO ( cPatArt() + "ArtCodebar.Cdx" ) ADDITIVE

      USE ( cPatArt() + "FAMILIAS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FAMILIAS", @dbfFamilia ) )
      SET ADSINDEX TO ( cPatArt() + "FAMILIAS.CDX" ) ADDITIVE

      USE ( cPatArt() + "ARTKIT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ARTTIK", @dbfKit ) )
      SET ADSINDEX TO ( cPatArt() + "ARTKIT.CDX" ) ADDITIVE

      USE ( cPatGrp() + "FPAGO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FPAGO", @dbfFPago ) )
      SET ADSINDEX TO ( cPatGrp() + "FPAGO.CDX" ) ADDITIVE

      USE ( cPatArt() + "ArtDiv.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ARTCOM", @dbfArtCom ) )
      SET ADSINDEX TO ( cPatArt() + "ArtDiv.Cdx" ) ADDITIVE

      USE ( cPatDat() + "DIVISAS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "DIVISAS", @dbfDiv ) )
      SET ADSINDEX TO ( cPatDat() + "DIVISAS.CDX" ) ADDITIVE

      USE ( cPatDat() + "TBLCNV.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TBLCNV", @dbfTblCnv ) )
      SET ADSINDEX TO ( cPatDat() + "TBLCNV.CDX" ) ADDITIVE

      USE ( cPatEmp() + "ALBPROVT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALBPROVT", @dbfAlbPrvT ) )
      SET ADSINDEX TO ( cPatEmp() + "ALBPROVT.CDX" ) ADDITIVE

      USE ( cPatEmp() + "ALBPROVL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALBPROVL", @dbfAlbPrvL ) )
      SET ADSINDEX TO ( cPatEmp() + "ALBPROVL.CDX" ) ADDITIVE

      USE ( cPatEmp() + "ALBPRVS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALBPRVS", @dbfAlbPrvS ) )
      SET ADSINDEX TO ( cPatEmp() + "ALBPRVS.CDX" ) ADDITIVE

      USE ( cPatDat() + "Cajas.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CAJAS", @dbfCajT ) )
      SET ADSINDEX TO ( cPatDat() + "Cajas.Cdx" ) ADDITIVE

      USE ( cPatEmp() + "PEDPROVT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PEDPROVT", @dbfPedPrvT ) )
      SET ADSINDEX TO ( cPatEmp() + "PEDPROVT.CDX" ) ADDITIVE

      USE ( cPatEmp() + "PEDPROVL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PEDPROVL", @dbfPedPrvL ) )
      SET ADSINDEX TO ( cPatEmp() + "PEDPROVL.CDX" ) ADDITIVE

      USE ( cPatEmp() + "TIPINCI.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIPINCI", @dbfInci ) )
      SET ADSINDEX TO ( cPatEmp() + "TIPINCI.CDX" ) ADDITIVE

      USE ( cPatArt() + "PRO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PRO", @dbfPro ) )
      SET ADSINDEX TO ( cPatArt() + "PRO.CDX" ) ADDITIVE

      USE ( cPatArt() + "TBLPRO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TBLPRO", @dbfTblPro ) )
      SET ADSINDEX TO ( cPatArt() + "TBLPRO.CDX" ) ADDITIVE

      USE ( cPatAlm() + "ALMACEN.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALMACEN", @dbfAlm ) )
      SET ADSINDEX TO ( cPatAlm() + "ALMACEN.CDX" ) ADDITIVE

      USE ( cPatEmp() + "RDOCUMEN.DBF" ) NEW SHARED VIA ( cDriver() )ALIAS ( cCheckArea( "RDOCUMEN", @dbfDoc ) )
      SET ADSINDEX TO ( cPatEmp() + "RDOCUMEN.CDX" ) ADDITIVE
      SET TAG TO "CTIPO"

      USE ( cPatDat() + "USERS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "USERS", @dbfUsr ) )
      SET ADSINDEX TO ( cPatDat() + "USERS.CDX" ) ADDITIVE

      USE ( cPatAlm() + "UBICAL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "UBICAL", @dbfUbicaL ) )
      SET ADSINDEX TO ( cPatAlm() + "UBICAL.CDX" ) ADDITIVE

      USE ( cPatDat() + "DELEGA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "DELEGA", @dbfDelega ) )
      SET ADSINDEX TO ( cPatDat() + "DELEGA.CDX" ) ADDITIVE

      USE ( cPatEmp() + "NCOUNT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "NCOUNT", @dbfCount ) )
      SET ADSINDEX TO ( cPatEmp() + "NCOUNT.CDX" ) ADDITIVE

      USE ( cPatDat() + "EMPRESA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "EMPRESA", @dbfEmp ) )
      SET ADSINDEX TO ( cPatDat() + "EMPRESA.CDX" ) ADDITIVE

      USE ( cPatEmp() + "PedCliL.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PedCLIL", @dbfPedCliL ) )
      SET ADSINDEX TO ( cPatEmp() + "PedCliL.Cdx" ) ADDITIVE

      USE ( cPatEmp() + "ALBCLIL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALBCLIL", @dbfAlbCliL ) )
      SET ADSINDEX TO ( cPatEmp() + "ALBCLIL.CDX" ) ADDITIVE
      SET TAG TO "cStkFast"

      USE ( cPatEmp() + "RctPrvT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "RctPrvT", @dbfRctPrvT ) )
      SET ADSINDEX TO ( cPatEmp() + "RctPrvT.CDX" ) ADDITIVE

      USE ( cPatEmp() + "RctPrvL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "RctPrvL", @dbfRctPrvL ) )
      SET ADSINDEX TO ( cPatEmp() + "RctPrvL.CDX" ) ADDITIVE
      SET TAG TO "cRef"

      USE ( cPatEmp() + "FACCLIL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACCLIL", @dbfFacCliL ) )
      SET ADSINDEX TO ( cPatEmp() + "FACCLIL.CDX" ) ADDITIVE
      SET TAG TO "cRef"

      USE ( cPatEmp() + "FacRecL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FacRecL", @dbfFacRecL ) )
      SET ADSINDEX TO ( cPatEmp() + "FacRecL.CDX" ) ADDITIVE
      SET TAG TO "cRef"

      USE ( cPatEmp() + "TIKEL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIKEL", @dbfTikCliL ) )
      SET ADSINDEX TO ( cPatEmp() + "TIKEL.CDX" ) ADDITIVE
      SET TAG TO "CSTKFAST"

      USE ( cPatEmp() + "PROLIN.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PROLIN", @dbfProLin ) )
      SET ADSINDEX TO ( cPatEmp() + "PROLIN.CDX" ) ADDITIVE
      SET TAG TO "cCodArt"

      USE ( cPatEmp() + "PROMAT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PROMAT", @dbfProMat ) )
      SET ADSINDEX TO ( cPatEmp() + "PROMAT.CDX" ) ADDITIVE
      SET TAG TO "cCodArt"

      USE ( cPatEmp() + "HISMOV.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "HISMOV", @dbfHisMov ) )
      SET ADSINDEX TO ( cPatEmp() + "HISMOV.CDX" ) ADDITIVE
      SET TAG TO "cRefMov"

      USE ( cPatPrv() + "PRVBNC.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PRVBNC", @dbfPrvBnc ) )
      SET ADSINDEX TO ( cPatPrv() + "PRVBNC.CDX" ) ADDITIVE

      // Unidades de medicion

      oUndMedicion      := UniMedicion():Create( cPatGrp() )
      if !oUndMedicion:OpenFiles()
         lOpenFiles     := .f.
      end if

      oBandera          := TBandera():New()

      oStock            := TStock():Create( cPatGrp() )
      if !oStock:lOpenFiles()
         lOpenFiles     := .f.
      end if

      oBanco            := TBancos():Create()
      if !oBanco:OpenFiles()
         lOpenFiles     := .f.
      end if

      oFntTot           := TFont():New( "Arial", 8, 26, .F., .T. )// Font del total

      /*
      Declaración variables públicas-------------------------------------------
      */

      public nTotBrt    := 0
      public nTotNet    := 0
      public nTotSup    := 0
      public nTotIva    := 0
      public nTotReq    := 0
      public nTotRet    := 0
      public nTotFac    := 0
      public nTotDto    := 0
      public nTotDpp    := 0
      public nTotUno    := 0
      public nTotDos    := 0
      public nTotImp    := 0
      public nTotUnd    := 0
      public nPagFac    := 0
      public nTipRet    := 0
      public aTotIva    := { { 0,0,nil,0,0,0 }, { 0,0,nil,0,0,0 }, { 0,0,nil,0,0,0 } }
      public aIvaUno    := aTotIva[ 1 ]
      public aIvaDos    := aTotIva[ 2 ]
      public aIvaTre    := aTotIva[ 3 ]

      /*
      Limitaciones de cajero y cajas--------------------------------------------------------
      */

      if oUser():lFiltroVentas()
         cFiltroUsuario       := "Field->cCodUsr == '" + oUser():cCodigo() + "' .and. Field->cCodCaj == '" + oUser():cCaja() + "'"
      end if

      /*
      Numeros de serie---------------------------------------------------------
      */

      oNumerosSerie           := TNumerosSerie()
      oNumerosSerie:lCompras  := .t.
      oNumerosSerie:oStock    := oStock

      EnableAcceso()

   RECOVER

      lOpenFiles        := .f.

      EnableAcceso()

      msgStop( "Imposible abrir todas las bases de datos" )

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( lOpenFiles )

//---------------------------------------------------------------------------//

Static Function CloseFiles()

   DisableAcceso()

   DestroyFastFilter( TDataView():FacturasProveedores( nView ), .t., .t. )

   if dbfFacPrvL != nil
      ( dbfFacPrvL )->( dbCloseArea() )
   end if

   if dbfFacPrvI != nil
      ( dbfFacPrvI )->( dbCloseArea() )
   end if

   if dbfFacPrvD != nil
      ( dbfFacPrvD )->( dbCloseArea() )
   end if

   if dbfFacPrvS != nil
      ( dbfFacPrvS )->( dbCloseArea() )
   end if

   if dbfRctPrvL != nil
      ( dbfRctPrvL )->( dbCloseArea() )
   end if

   if dbfRctPrvT != nil
      ( dbfRctPrvT )->( dbCloseArea() )
   end if

   if dbfPedPrvT != nil
      ( dbfPedPrvT )->( dbCloseArea() )
   end if

   if dbfPedPrvL != nil
      ( dbfPedPrvL )->( dbCloseArea() )
   end if

   if dbfIva != nil
      ( dbfIva )->( dbCloseArea() )
   end if

   if dbfArtPrv != nil
      ( dbfArtPrv )->( dbCloseArea() )
   end if

   if dbfFPago != nil
      ( dbfFPago )->( dbCloseArea() )
   end if

   if dbfArticulo != nil
      ( dbfArticulo )->( dbCloseArea() )
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

   if dbfFacPrvP != nil
      ( dbfFacPrvP )->( dbCloseArea() )
   end if

   if dbfArtCom != nil
      ( dbfArtCom )->( dbCloseArea() )
   end if

   if dbfDiv != nil
      ( dbfDiv )->( dbCloseArea() )
   end if

   if ( dbfTblCnv ) != nil
      ( dbfTblCnv )->( dbCloseArea() )
   end if

   if dbfPro != nil
      ( dbfPro )->( dbCloseArea() )
   end if

   if dbfTblPro != nil
      ( dbfTblPro )->( dbCloseArea() )
   end if

   if dbfAlbPrvT != nil
      ( dbfAlbPrvT )->( dbCloseArea() )
   end if

   if dbfAlbPrvL != nil
      ( dbfAlbPrvL )->( dbCloseArea() )
   end if

   if dbfAlbPrvS != nil
      ( dbfAlbPrvS )->( dbCloseArea() )
   end if

   if dbfAlm != nil
      ( dbfAlm )->( dbCloseArea() )
   end if

   if dbfDoc != nil
      ( dbfDoc )->( dbCloseArea() )
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

   if dbfEmp != nil
      ( dbfEmp )->( dbCloseArea() )
   end if

   if dbfPedCliL != nil
      ( dbfPedCliL )->( dbCloseArea() )
   end if

   if dbfAlbCliL != nil
      ( dbfAlbCliL )->( dbCloseArea() )
   end if

   if dbfFacCliL != nil
      ( dbfFacCliL )->( dbCloseArea() )
   end if

   if dbfFacRecL != nil
      ( dbfFacRecL )->( dbCloseArea() )
   end if

   if dbfTikCliL != nil
      ( dbfTikCliL )->( dbCloseArea() )
   end if

   if dbfProLin != nil
      ( dbfProLin )->( dbCloseArea() )
   end if

   if dbfProMat != nil
      ( dbfProMat )->( dbCloseArea() )
   end if

   if dbfHisMov != nil
      ( dbfHisMov )->( dbCloseArea() )
   end if

   if dbfPrvBnc != nil
      ( dbfPrvBnc )->( dbCloseArea() )
   end if

   if !Empty( oUndMedicion )
      oUndMedicion:end()
   end if

   if oStock != nil
      oStock:end()
   end if

   if oBanco != nil
      oBanco:CloseFiles()
      oBanco:End()
   end if

   TDataView():DeleteView( nView )

   dbfFacPrvL  := nil
   dbfFacPrvI  := nil
   dbfFacPrvD  := nil
   dbfFacPrvS  := nil
   dbfRctPrvT  := nil
   dbfRctPrvL  := nil
   dbfIva      := nil
   dbfArtPrv   := nil
   dbfFPago    := nil
   dbfUbicaL   := nil
   dbfArticulo := nil
   dbfCodebar  := nil
   dbfKit      := nil
   dbfFacPrvP  := nil
   dbfArtCom   := nil
   dbfDiv      := nil
   oBandera    := nil
   dbfTblCnv   := nil
   dbfPro      := nil
   dbfTblPro   := nil
   dbfAlbPrvT  := nil
   dbfAlbPrvL  := nil
   dbfAlbPrvS  := nil
   dbfDoc      := nil
   dbfCajT     := nil
   dbfUsr      := nil
   oStock      := nil
   dbfInci     := nil
   dbfDelega   := nil
   dbfCount    := nil
   oBanco      := nil
   dbfEmp      := nil
   dbfPedCliL  := nil
   dbfAlbCliL  := nil
   dbfFacCliL  := nil
   dbfFacRecL  := nil
   dbfTikCliL  := nil
   dbfProLin   := nil
   dbfProMat   := nil
   dbfHisMov   := nil
   dbfPrvBnc   := nil

   lOpenFiles  := .f.

   oWndBrw     := nil

   if !Empty( oFntTot )
      oFntTot:end()
   end if

   EnableAcceso()

RETURN .T.

//------------------------------------------------------------------------//

FUNCTION FacPrv( oMenuItem, oWnd, cCodPrv, cCodArt, cNumAlb )

   local oSnd
   local oRpl
   local oImp
   local oRotor
   local oFlt
   local oDel
   local oPrv
   local oPdf
   local oMail
   local oBtnEur
   local nLevel
   local lEuro          := .f.
   local oLiq

   DEFAULT oMenuItem    := _MENUITEM_
   DEFAULT oWnd         := oWnd()
   DEFAULT cCodPrv      := ""
   DEFAULT cCodArt      := ""
   DEFAULT cNumAlb      := ""

   /*
   Obtenemos el nivel de acceso
   */

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
   Anotamos el movimiento para el navegador
   */

   DisableAcceso()

   DEFINE SHELL oWndBrw FROM 0, 0 TO 22, 80 ;
      XBROWSE ;
      TITLE    "Facturas de proveedores" ;
      PROMPTS  "Número",;
               "Fecha",;
               "Código",;
               "Nombre",;
               "Su factura",;
               "Número documento",;
               "Pago",;
               "NFC";
      MRU      "Document_businessman_16";
      BITMAP   ( clrTopCompras ) ;
      ALIAS    ( TDataView():FacturasProveedores( nView ) );
      APPEND   ( WinAppRec( oWndBrw:oBrw, bEdtRec, TDataView():FacturasProveedores( nView ), cCodPrv, cCodArt, cNumAlb ) );
      DUPLICAT ( WinDupRec( oWndBrw:oBrw, bEdtRec, TDataView():FacturasProveedores( nView ), cCodPrv, cCodArt, cNumAlb ) );
      EDIT     ( WinEdtRec( oWndBrw:oBrw, bEdtRec, TDataView():FacturasProveedores( nView ), cCodPrv, cCodArt, cNumAlb ) );
      ZOOM     ( WinZooRec( oWndBrw:oBrw, bEdtRec, TDataView():FacturasProveedores( nView ) ) );
      DELETE   ( WinDelRec( oWndBrw:oBrw, TDataView():FacturasProveedores( nView ), {|| QuiFacPrv() } ) );
      LEVEL    nLevel ;
      OF       oWnd

     oWndBrw:lFechado     := .t.

     oWndBrw:bChgIndex    := {|| if( oUser():lFiltroVentas(), CreateFastFilter( cFiltroUsuario, TDataView():FacturasProveedores( nView ), .f., , cFiltroUsuario ), CreateFastFilter( "", TDataView():FacturasProveedores( nView ), .f. ) ) }

      oWndBrw:SetYearComboBoxChange( {|| YearComboBoxChange() } )

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Sesión cerrada"
         :nHeadBmpNo       := 3
         :bStrData         := {|| "" }
         :bEditValue       := {|| ( TDataView():FacturasProveedores( nView ) )->lCloFac }
         :nWidth           := 20
         :lHide            := .t.
         :SetCheck( { "Sel16", "Nil16" } )
         :AddResource( "Zoom16" )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Envio"
         :nHeadBmpNo       := 3
         :bStrData         := {|| "" }
         :bEditValue       := {|| ( TDataView():FacturasProveedores( nView ) )->lSndDoc }
         :nWidth           := 20
         :SetCheck( { "Sel16", "Nil16" } )
         :AddResource( "Lbl16" )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Pagado"
         :nHeadBmpNo       := 4
         :bStrData         := {|| "" }
         :bBmpData         := {|| ChkPagFacPrv( TDataView():FacturasProveedores( nView ), dbfFacPrvP ) }
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
         :bEditValue       := {|| ( TDataView():FacturasProveedores( nView ) )->lContab }
         :nWidth           := 20
         :SetCheck( { "Sel16", "Nil16" } )
         :AddResource( "BmpConta16" )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Incidencia"
         :nHeadBmpNo       := 4
         :bStrData         := {|| "" }
         :bBmpData         := {|| nEstadoIncidencia( ( TDataView():FacturasProveedores( nView ) )->cSerFac + Str( ( TDataView():FacturasProveedores( nView ) )->nNumFac ) + ( TDataView():FacturasProveedores( nView ) )->cSufFac ) }
         :nWidth           := 20
         :lHide            := .t.
         :AddResource( "Bullet_Square_Red_16" )
         :AddResource( "Bullet_Square_Yellow_16" )
         :AddResource( "Bullet_Square_Green_16" )
         :AddResource( "Informacion_16" )

      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Rectificada"
         :nHeadBmpNo       := 3
         :bStrData         := {|| "" }
         :bEditValue       := {|| lRectificadaPrv( ( TDataView():FacturasProveedores( nView ) )->cSerFac + Str( ( TDataView():FacturasProveedores( nView ) )->nNumFac ) + ( TDataView():FacturasProveedores( nView ) )->cSufFac, TDataView():FacturasProveedores( nView ), dbfRctPrvT ) }
         :nWidth           := 20
         :lHide            := .t.
         :SetCheck( { "Sel16", "Nil16" } )
         :AddResource( "Document_navigate_cross_16" )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Impreso"
         :nHeadBmpNo       := 3
         :bStrData         := {|| "" }
         :bEditValue       := {|| ( TDataView():FacturasProveedores( nView ) )->lImprimido }
         :nWidth           := 20
         :lHide            := .t.
         :SetCheck( { "Sel16", "Nil16" } )
         :AddResource( "IMP16" )

      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Número"
         :cSortOrder       := "nNumFac"
         :bEditValue       := {|| ( TDataView():FacturasProveedores( nView ) )->cSerFac + "/" + Alltrim( Str( ( TDataView():FacturasProveedores( nView ) )->nNumFac ) )  }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Delegación"
         :bEditValue       := {|| ( TDataView():FacturasProveedores( nView ) )->cSufFac  }
         :nWidth           := 20
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Su factura"
         :cSortOrder       := "cSuPed"
         :bEditValue       := {|| ( TDataView():FacturasProveedores( nView ) )->cSuPed }
         :nWidth           := 80
         :lHide            := .t.
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "NFC"
         :cSortOrder       := "cNfc"
         :bEditValue       := {|| ( TDataView():FacturasProveedores( nView ) )->cNFC }
         :nWidth           := 160
         :lHide            := .t.
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Delegación"
         :bEditValue       := {|| ( TDataView():FacturasProveedores( nView ) )->cCodDlg }
         :nWidth           := 60
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Sesión"
         :bEditValue       := {|| Trans( ( TDataView():FacturasProveedores( nView ) )->cTurFac, "######" ) }
         :nWidth           := 60
         :lHide            := .t.
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Número documento"
         :cSortOrder       := "cNumDoc"
         :bEditValue       := {|| ( TDataView():FacturasProveedores( nView ) )->cNumDoc }
         :nWidth           := 80
         :lHide            := .t.
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Fecha"
         :cSortOrder       := "dFecFac"
         :bEditValue       := {|| Dtoc( ( TDataView():FacturasProveedores( nView ) )->dFecFac ) }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Caja"
         :bEditValue       := {|| ( TDataView():FacturasProveedores( nView ) )->cCodCaj }
         :nWidth           := 40
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Usuario"
         :bEditValue       := {|| ( TDataView():FacturasProveedores( nView ) )->cCodUsr }
         :nWidth           := 40
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Código"
         :cSortOrder       := "cCodPrv"
         :bEditValue       := {|| ( TDataView():FacturasProveedores( nView ) )->cCodPrv }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Nombre"
         :cSortOrder       := "cNomPrv"
         :bEditValue       := {|| ( TDataView():FacturasProveedores( nView ) )->cNomPrv }
         :nWidth           := 260
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Pago"
         :cSortOrder       := "cCodPago"
         :bEditValue       := {|| ( TDataView():FacturasProveedores( nView ) )->cCodPago }
         :nWidth           := 40
         :lHide            := .t.
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Base"
         :bEditValue       := {|| ( TDataView():FacturasProveedores( nView ) )->nTotNet }
         :cEditPicture     := cPirDiv()
         :nWidth           := 80
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := cImp()
         :bEditValue       := {|| ( TDataView():FacturasProveedores( nView ) )->nTotIva }
         :cEditPicture     := cPirDiv()
         :nWidth           := 80
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "R.E."
         :bEditValue       := {|| ( TDataView():FacturasProveedores( nView ) )->nTotReq }
         :cEditPicture     := cPirDiv()
         :nWidth           := 80
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Total"
         :bEditValue       := {|| ( TDataView():FacturasProveedores( nView ) )->nTotFac }
         :cEditPicture     := cPirDiv()
         :nWidth           := 80
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Div."
         :bEditValue       := {|| cSimDiv( if( lEuro, cDivChg(), ( TDataView():FacturasProveedores( nView ) )->cDivFac ), dbfDiv ) }
         :nWidth           := 30
      end with

      oWndBrw:lAutoSeek    := .f.
      oWndBrw:cHtmlHelp    := "Factura de proveedor"

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
      MRU ;
      HOTKEY   "M";
      LEVEL    ACC_EDIT

   DEFINE BTNSHELL RESOURCE "ZOOM" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( oWndBrw:RecZoom() );
      TOOLTIP  "(Z)oom";
      MRU ;
      HOTKEY   "Z";
      LEVEL    ACC_ZOOM

   DEFINE BTNSHELL oDel RESOURCE "DEL" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( oWndBrw:RecDel() );
      MENU     This:Toggle() ;
      TOOLTIP  "(E)liminar";
      HOTKEY   "E";
      LEVEL    ACC_DELE

   DEFINE BTNSHELL oImp RESOURCE "IMP" GROUP OF oWndBrw ;
      NOBORDER ;
      ACTION   ( nGenFacPrv( IS_PRINTER ) ) ;
      MENU     This:Toggle() ;
      TOOLTIP  "(I)mprimir";
      HOTKEY   "I";
      LEVEL    ACC_IMPR

      lGenFac( oWndBrw:oBrw, oImp, IS_PRINTER ) ;

   DEFINE BTNSHELL RESOURCE "SERIE1" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( ImprimirSeriesFacturasProveedores() ) ;
      TOOLTIP  "Imp(r)imir series";
      HOTKEY   "R";
      LEVEL    ACC_IMPR

   DEFINE BTNSHELL oPrv RESOURCE "PREV1" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( nGenFacPrv( IS_SCREEN ), oWndBrw:Refresh() ) ;
      MENU     This:Toggle() ;
      TOOLTIP  "(P)revisualizar";
      HOTKEY   "P";
      LEVEL    ACC_IMPR

      lGenFac( oWndBrw:oBrw, oPrv, IS_SCREEN ) ;

   DEFINE BTNSHELL oPdf RESOURCE "DOCLOCK" OF oWndBrw ;
      NOBORDER ;
      MENU     This:Toggle() ;
      ACTION   ( nGenFacPrv( IS_PDF ) ) ;
      TOOLTIP  "Pd(f)";
      HOTKEY   "F";
      LEVEL    ACC_IMPR

      lGenFac( oWndBrw:oBrw, oPdf, IS_PDF ) ;

   DEFINE BTNSHELL oMail RESOURCE "Mail" OF oWndBrw ;
      NOBORDER ;
      MENU     This:Toggle() ;
      ACTION   ( GenFacPrv( IS_MAIL ) ) ;
      TOOLTIP  "Correo electrónico";
      LEVEL    ACC_IMPR

      lGenFac( oWndBrw:oBrw, oMail, IS_MAIL ) ;

   DEFINE BTNSHELL RESOURCE "RemoteControl_" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( TFacturaProveedorLabelGenerator():Create() ) ;
      TOOLTIP  "Eti(q)uetas" ;
      HOTKEY   "Q";
      LEVEL    ACC_IMPR

   DEFINE BTNSHELL oLiq RESOURCE "Money2_" GROUP OF oWndBrw ;
      NOBORDER ;
      ACTION   ( lLiquida( oWndBrw:oBrw ) ) ;
      TOOLTIP  "Pagar" ;
      LEVEL    ACC_EDIT

      DEFINE BTNSHELL RESOURCE "Money2_" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( aGetSelRec( oWndBrw, {|| lLiquida( oWndBrw:oBrw, ( TDataView():FacturasProveedores( nView ) )->cSerFac + Str( ( TDataView():FacturasProveedores( nView ) )->nNumFac ) + ( TDataView():FacturasProveedores( nView ) )->cSufFac ) }, "Liquidar series de facturas", .t., nil, .t., nil ) ) ;
         TOOLTIP  "Pagar series" ;
         FROM     oLiq ;
         CLOSED ;
         LEVEL    ACC_EDIT

   DEFINE BTNSHELL RESOURCE "BmpConta" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( aGetSelRec( oWndBrw, {|lChk1, lChk2, oTree | CntFacPrv( lChk1, lChk2, .t., oTree, nil, nil, TDataView():FacturasProveedores( nView ), dbfFacPrvL, dbfFacPrvP, TDataView():Proveedores( nView ), dbfDiv, dbfArticulo, dbfFPago, dbfIva ) }, "Contabilizar facturas", .f., "Simular resultados", .f., "Contabilizar pagos" ) ) ;
      TOOLTIP  "(C)ontabilizar" ;
      HOTKEY   "C";
      LEVEL    ACC_EDIT

   if oUser():lAdministrador()

   DEFINE BTNSHELL RESOURCE "ChgState" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( aGetSelRec( oWndBrw, {|lChk1| lCntFacPrv( lChk1, TDataView():FacturasProveedores( nView ) ) }, "Cambiar estado", .f., "Contabilizado", .t., "" ) ) ;
      TOOLTIP  "Cambiar Es(t)ado" ;
      HOTKEY   "T";
      LEVEL    ACC_EDIT

   end if

   DEFINE BTNSHELL oSnd RESOURCE "Lbl" GROUP OF oWndBrw ;
      NOBORDER ;
      MENU     This:Toggle() ;
      TOOLTIP  "En(v)iar" ;
      MESSAGE  "Seleccionar facturas para ser enviados" ;
      ACTION   lSnd( oWndBrw, TDataView():FacturasProveedores( nView ) ) ;
      HOTKEY   "V";
      LEVEL    ACC_EDIT

   DEFINE BTNSHELL oBtnEur RESOURCE "BAL_EURO" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( lEuro := !lEuro, oWndBrw:Refresh() ) ;
      TOOLTIP  "M(o)neda";
      HOTKEY   "O"

   DEFINE BTNSHELL RESOURCE "INFO" GROUP OF oWndBrw ;
      NOBORDER ;
      ACTION   ( TTrazaDocumento():Activate( FAC_PRV, ( TDataView():FacturasProveedores( nView ) )->cSerFac + Str( ( TDataView():FacturasProveedores( nView ) )->nNumFac ) + ( TDataView():FacturasProveedores( nView ) )->cSufFac ) ) ;
      TOOLTIP  "I(n)forme documento" ;
      HOTKEY   "N" ;
      LEVEL    ACC_EDIT

   if oUser():lAdministrador()

      DEFINE BTNSHELL oRpl RESOURCE "BMPCHG" GROUP OF oWndBrw ;
         NOBORDER ;
         MENU     This:Toggle() ;
         ACTION   ( ReplaceCreator( oWndBrw, TDataView():FacturasProveedores( nView ), aItmFacPrv() ) ) ;
         TOOLTIP  "Cambiar campos" ;
         LEVEL    ACC_EDIT

         DEFINE BTNSHELL RESOURCE "BMPCHG" OF oWndBrw ;
            NOBORDER ;
            ACTION   ( ReplaceCreator( oWndBrw, dbfFacPrvL, aColFacPrv() ) ) ;
            TOOLTIP  "Líneas" ;
            FROM     oRpl ;
            CLOSED ;
            LEVEL    ACC_EDIT

   end if

   DEFINE BTNSHELL oRotor RESOURCE "ROTOR" GROUP OF oWndBrw ;
      ACTION   ( oRotor:Expand() ) ;
      TOOLTIP  "Rotor" ;
      LEVEL    ACC_EDIT

      DEFINE BTNSHELL RESOURCE "Businessman_" OF oWndBrw ;
         ACTION   ( EdtPrv( ( TDataView():FacturasProveedores( nView ) )->cCodPrv ) );
         TOOLTIP  "Modificar proveedor";
         FROM     oRotor ;
         LEVEL    ACC_EDIT

      DEFINE BTNSHELL RESOURCE "INFO" OF oWndBrw ;
         ACTION   ( InfProveedor( ( TDataView():FacturasProveedores( nView ) )->cCodPrv ) );
         TOOLTIP  "Informe proveedor";
         FROM     oRotor ;
         LEVEL    ACC_EDIT

      DEFINE BTNSHELL RESOURCE "Document_plain_businessman_" OF oWndBrw ;
         ACTION   ( if( !Empty( ( TDataView():FacturasProveedores( nView ) )->cNumAlb ), ZooAlbPrv( ( TDataView():FacturasProveedores( nView ) )->cNumAlb ), MsgStop( "La factura no proviene de un albarán" ) ) );
         TOOLTIP  "Visualizar albarán";
         FROM     oRotor ;
         LEVEL    ACC_EDIT

      DEFINE BTNSHELL RESOURCE "Money2_businessman_" OF oWndBrw ;
         ALLOW    EXIT ;
         ACTION   ( RecPrv( , , { ( TDataView():FacturasProveedores( nView ) )->cSerFac + Str( ( TDataView():FacturasProveedores( nView ) )->nNumFac ) + ( TDataView():FacturasProveedores( nView ) )->cSufFac } ) );
         TOOLTIP  "Modificar recibo" ;
         FROM     oRotor ;
         LEVEL    ACC_EDIT

      DEFINE BTNSHELL RESOURCE "DOCUMENT_USER1_" OF oWndBrw ;
         ALLOW    EXIT ;
         ACTION   ( FactCli( nil, nil, { "Factura" => ( TDataView():FacturasProveedores( nView ) )->cSerFac + Str( ( TDataView():FacturasProveedores( nView ) )->nNumFac ) + ( TDataView():FacturasProveedores( nView ) )->cSufFac } ) );
         TOOLTIP  "Generar factura" ;
         FROM     oRotor ;
         LEVEL    ACC_APPD

   DEFINE BTNSHELL RESOURCE "END" GROUP OF oWndBrw ;
      ALLOW    EXIT ;
      ACTION   ( oWndBrw:End() ) ;
      TOOLTIP  "(S)alir" ;
      HOTKEY   "S"

   if !oUser():lFiltroVentas()
      oWndBrw:oActiveFilter:SetFields( aItmFacPrv() )
      oWndBrw:oActiveFilter:SetFilterType( FAC_PRV )
   end if

   ACTIVATE WINDOW oWndBrw VALID ( CloseFiles() )

   EnableAcceso()

   if !Empty( cCodPrv ) .or. !Empty( cCodArt ) .or. !Empty( cNumAlb )
      if !Empty( oWndBrw )
         oWndBrw:RecAdd()
      end if
      cCodPrv  := nil
      cCodArt  := nil
      cNumAlb  := nil
   end if

Return .t.

//----------------------------------------------------------------------------//

STATIC FUNCTION EdtRec( aTmp, aGet, dbf, oBrw, cCodPrv, cCodArt, nMode, cNumAlb )

   local n
   local oDlg
   local oFld
   local oBtnOk
   local oBrwLin
   local oBrwPgo
   local oBrwInc
   local oBrwDoc
   local cGetRet
   local oGet        := Array( 6 )
   local cGet        := Array( 6 )
   local oSayLabels  := Array( 7 )
   local cTlfPrv
   local oTlfPrv
   local oBmpDiv
   local oBmpEmp
   local nOrd        := ( TDataView():FacturasProveedores( nView ) )->( ordSetFocus( 1 ) )
   local aControl    := Array( 6 )
   local oSayGas     := Array( 16 )
   local oBmpGeneral

   cTlfPrv           := RetFld( aTmp[ _CCODPRV ], TDataView():Proveedores( nView ), "Telefono" )
   cUsr              := RetFld( aTmp[ _CCODUSR ], dbfUsr, "cNbrUse" )

   do case
   case nMode == APPD_MODE

      if !lCajaOpen( oUser():cCaja() ) .and. !oUser():lAdministrador()
         msgStop( "Esta caja " + oUser():cCaja() + " esta cerrada." )
         Return .f.
      end if

      aTmp[ _CSERFAC ]     := cNewSer( "nFacPrv", dbfCount )
      aTmp[ _CSUFFAC ]     := RetSufEmp()
      aTmp[ _CTURFAC ]     := cCurSesion()
      aTmp[ _CDIVFAC ]     := cDivEmp()
      aTmp[ _NVDVFAC ]     := nChgDiv( aTmp[ _CDIVFAC ], dbfDiv )
      aTmp[ _CCODALM ]     := oUser():cAlmacen()
      aTmp[ _CCODCAJ ]     := oUser():cCaja()
      aTmp[ _LSNDDOC ]     := .t.
      aTmp[ _CCODPRO ]     := cProCnt()
      aTmp[ _CCODUSR ]     := cCurUsr()
      aTmp[ _CCODDLG ]     := oUser():cDelegacion()
      aTmp[ _DFECENT ]     := Ctod( "" )
      aTmp[ _DFECIMP ]     := Ctod( "" )

      if !Empty( cCodPrv )
         aTmp[ _CCODPRV ]  := cCodPrv
      end if

      if !Empty( cNumAlb )
         aTmp[ _CNUMALB ]  := cNumAlb
      end if

   case nMode == DUPL_MODE

      if !lCajaOpen( oUser():cCaja() ) .and. !oUser():lAdministrador()
         msgStop( "Esta caja " + oUser():cCaja() + " esta cerrada." )
         Return .f.
      end if

      aTmp[ _CTURFAC ]  := cCurSesion()
      aTmp[ _CCODCAJ ]  := oUser():cCaja()
      aTmp[ _LSNDDOC ]  := .t.
      aTmp[ _DFECENT ]  := Ctod( "" )
      aTmp[ _DFECIMP ]  := Ctod( "" )
      aTmp[ _LCLOFAC ]  := .f.
      aTmp[ _LCONTAB ]  := .f.
      aTmp[ _CNFC    ]  := Space( 20 )

   case nMode == EDIT_MODE

      if aTmp[ _LCONTAB ] .and. !ApoloMsgNoYes( "La modificación de esta factura puede provocar descuadres contables." + CRLF + "¿ Desea continuar ?", "Factura ya contabilizada" )
         return .f.
      end if

      if aTmp[ _LRECDOC ]
         MsgStop( "El documento ha sido recibido por internet", "Imposible modificar" )
         return .f.
      end if

      if aTmp[ _LCLOFAC ] .and. !oUser():lAdministrador()
         msgStop( "Solo puede modificar los facturas cerradas los administradores." )
         return .f.
      end if

   end case

   if Empty( aTmp[ _CDTOESP ] )
      aTmp[ _CDTOESP ]  := Padr( "General", 50 )
   end if

   if Empty( aTmp[ _CDPP ] )
      aTmp[ _CDPP ]     := Padr( "Pronto pago", 50 )
   end if

   /*
   Comienza la transaccion-----------------------------------------------------
   */

   if BeginTrans( aTmp, nMode )
      Return .f.
   end if

   /*
   Este valor los guaradamos para detectar los posibles cambios
   */

   cOldCodCli           := aTmp[ _CCODPRV ]

   cPicUnd              := MasUnd()                               // Picture de las unidades
   cPinDiv              := cPinDiv( aTmp[ _CDIVFAC ], dbfDiv )    // Picture de la divisa
   cPirDiv              := cPirDiv( aTmp[ _CDIVFAC ], dbfDiv )    // Picture de la divisa redondeada
   nDinDiv              := nDinDiv( aTmp[ _CDIVFAC ], dbfDiv )    // Decimales de la divisa
   nRinDiv              := nRinDiv( aTmp[ _CDIVFAC ], dbfDiv )    // Decimales de la divisa redondeada
   cPouDiv              := cPouDiv( aTmp[ _CDIVFAC ], dbfDiv )    // Picture de la divisa
   cPorDiv              := cPorDiv( aTmp[ _CDIVFAC ], dbfDiv )    // Picture de la divisa redondeada

   /*
   Etiquetas-------------------------------------------------------------------
   */

   cGet[ 1 ]            := RetFld( aTmp[ _CCODALM ], dbfAlm )
   cGet[ 2 ]            := RetFld( aTmp[ _CCODPRV ], TDataView():Proveedores( nView ) )
   cGet[ 3 ]            := RetFld( aTmp[ _CCODPAGO], dbfFPago )
   cGet[ 5 ]            := RetFld( aTmp[ _CCODCAJ ], dbfCajT )
   cGet[ 6 ]            := RetFld( cCodEmp() + aTmp[ _CCODDLG ], dbfDelega, "cNomDlg" )

   DEFINE DIALOG oDlg RESOURCE "PEDPRV" TITLE LblTitle( nMode ) + "facturas a proveedores"

      REDEFINE FOLDER oFld ;
         ID          400 ;
         OF          oDlg ;
         PROMPT      "&Factura",;
                     "Da&tos",;
                     "&Incidencias",;
                     "D&ocumentos" ;
         DIALOGS     "FACPRV_1",;
                     "FACPRV_2",;
                     "PEDCLI_3",;
                     "PEDCLI_4"

      REDEFINE GET   aGet[ _CNFC ] ;
         VAR         aTmp[ _CNFC ] ;
         ID          570 ;
         WHEN        ( nMode != ZOOM_MODE );
         OF          oFld:aDialogs[1]

      /*
      Datos del proveedor------------------------------------------------------
      */

      REDEFINE BITMAP oBmpGeneral ;
        ID       990 ;
        RESOURCE "facturas_proveedores_48_alpha" ;
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

      REDEFINE GET aGet[ _CCODPRV ] VAR aTmp[ _CCODPRV ] ;
         ID       140 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  ( RetPicCodPrvEmp() ) ;
         VALID    ( loaPrv( aGet, aTmp, TDataView():Proveedores( nView ), nMode, oGet[ 2 ], oTlfPrv ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwProvee( aGet[ _CCODPRV ], oGet[ 2 ] ) );
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CNOMPRV ] VAR aTmp[ _CNOMPRV ];
         ID       141 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         COLOR    CLR_GET ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CDNIPRV ] VAR aTmp[ _CDNIPRV ] ;
         ID       106 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         COLOR    CLR_GET ;
         OF       oFld:aDialogs[1]

      REDEFINE GET oTlfPrv VAR cTlfPrv ;
         ID       107 ;
         WHEN     ( .f. );
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CDIRPRV ] VAR aTmp[ _CDIRPRV ] ;
         ID       103 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         BITMAP   "Environnment_View_16" ;
         ON HELP  GoogleMaps( aTmp[ _CDIRPRV ], Rtrim( aTmp[ _CPOBPRV ] ) + Space( 1 ) + Rtrim( aTmp[ _CPROVPROV ] ) ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CPOBPRV ] VAR aTmp[ _CPOBPRV ] ;
         ID       105 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         COLOR    CLR_GET ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CPROVPROV ] VAR aTmp[ _CPROVPROV ] ;
         ID       108 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         COLOR    CLR_GET ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CPOSPRV ] VAR aTmp[ _CPOSPRV ] ;
         ID       104 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         COLOR    CLR_GET ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CCODALM ] VAR aTmp[ _CCODALM ] ;
         ID       150 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         COLOR    CLR_GET ;
         VALID    cAlmacen( aGet[_CCODALM], dbfAlm, oGet[ 1 ] );
         BITMAP   "LUPA" ;
         ON HELP  brwAlmacen( aGet[ _CCODALM ], oGet[ 1 ] );
         OF       oFld:aDialogs[1]

      REDEFINE GET oGet[1] VAR cGet[1] ;
         ID       151 ;
         WHEN     ( .F. );
         COLOR    CLR_GET ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CCODPAGO ] VAR aTmp[ _CCODPAGO ];
         ID       160 ;
         PICTURE  "@!" ;
         COLOR    CLR_GET ;
         WHEN     ( nMode != ZOOM_MODE .and. !lRecibosPagadosTmp( dbfTmpPgo ) ) ;
         VALID    cFPago( aGet[ _CCODPAGO ], dbfFPago, oGet[3] ) ;
         BITMAP   "LUPA" ;
         ON HELP  BrwFPago( aGet[ _CCODPAGO ], oGet[3] ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET oGet[3] VAR cGet[3];
         ID       161 ;
         WHEN     .F. ;
         COLOR    CLR_GET ;
         OF       oFld:aDialogs[1]

      /*
      Bancos-------------------------------------------------------------------
      */

      REDEFINE GET aGet[ _CBANCO ] VAR aTmp[ _CBANCO ];
         ID       300 ;
         WHEN     ( nMode != ZOOM_MODE .and. !lRecibosPagadosTmp( dbfTmpPgo ) );
         BITMAP   "LUPA" ;
         ON HELP  ( BrwBncPrv( aGet[ _CBANCO ], aGet[ _CPAISIBAN ], aGet[ _CCTRLIBAN ], aGet[ _CENTBNC ], aGet[ _CSUCBNC ], aGet[ _CDIGBNC ], aGet[ _CCTABNC ], aTmp[ _CCODPRV ] ) );
         OF       oFld:aDialogs[1]
       
      REDEFINE GET aGet[ _CPAISIBAN ] VAR aTmp[ _CPAISIBAN ] ;
         PICTURE  "@!" ;
         ID       305 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( lIbanDigit( aTmp[ _CPAISIBAN ], aTmp[ _CENTBNC ], aTmp[ _CSUCBNC ], aTmp[ _CDIGBNC ], aTmp[ _CCTABNC ], aGet[ _CCTRLIBAN ] ) ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CCTRLIBAN ] VAR aTmp[ _CCTRLIBAN ] ;
         ID       306 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( lIbanDigit( aTmp[ _CPAISIBAN ], aTmp[ _CENTBNC ], aTmp[ _CSUCBNC ], aTmp[ _CDIGBNC ], aTmp[ _CCTABNC ], aGet[ _CCTRLIBAN ] ) ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CENTBNC ] VAR aTmp[ _CENTBNC ];
         ID       301 ;
         WHEN     ( nMode != ZOOM_MODE .and. !lRecibosPagadosTmp( dbfTmpPgo ) );
         VALID    (  lCalcDC( aTmp[ _CENTBNC ], aTmp[ _CSUCBNC ], aTmp[ _CDIGBNC ], aTmp[ _CCTABNC ], aGet[ _CDIGBNC ] ),;
                     aGet[ _CPAISIBAN ]:lValid() ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CSUCBNC ] VAR aTmp[ _CSUCBNC ];
         ID       302 ;
         WHEN     ( nMode != ZOOM_MODE .and. !lRecibosPagadosTmp( dbfTmpPgo ) );
         VALID    (  lCalcDC( aTmp[ _CENTBNC ], aTmp[ _CSUCBNC ], aTmp[ _CDIGBNC ], aTmp[ _CCTABNC ], aGet[ _CDIGBNC ] ),;
                     aGet[ _CPAISIBAN ]:lValid() ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CDIGBNC ] VAR aTmp[ _CDIGBNC ];
         ID       303 ;
         WHEN     ( nMode != ZOOM_MODE .and. !lRecibosPagadosTmp( dbfTmpPgo ) );
         VALID    (  lCalcDC( aTmp[ _CENTBNC ], aTmp[ _CSUCBNC ], aTmp[ _CDIGBNC ], aTmp[ _CCTABNC ], aGet[ _CDIGBNC ] ),;
                     aGet[ _CPAISIBAN ]:lValid() ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CCTABNC ] VAR aTmp[ _CCTABNC ];
         ID       304 ;
         PICTURE  "9999999999" ;
         WHEN     ( nMode != ZOOM_MODE .and. !lRecibosPagadosTmp( dbfTmpPgo ) );
         VALID    (  lCalcDC( aTmp[ _CENTBNC ], aTmp[ _CSUCBNC ], aTmp[ _CDIGBNC ], aTmp[ _CCTABNC ], aGet[ _CDIGBNC ] ),;
                     aGet[ _CPAISIBAN ]:lValid() ) ;
         OF       oFld:aDialogs[1]

      /*
      Cajas____________________________________________________________________
      */

      REDEFINE GET aGet[ _CCODCAJ ] VAR aTmp[ _CCODCAJ ];
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    cCajas( aGet[ _CCODCAJ ], dbfCajT, oGet[ 5 ] ) ;
         ID       165 ;
         COLOR    CLR_GET ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwCajas( aGet[ _CCODCAJ ], oGet[ 5 ] ) ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET oGet[ 5 ] VAR cGet[ 5 ] ;
         ID       166 ;
         WHEN     .f. ;
         OF       oFld:aDialogs[1]

      /*
      Criterio de caja_________________________________________________________
      */

      REDEFINE CHECKBOX aGet[ _LRECC ] VAR aTmp[ _LRECC ] ;
         ID       195 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ON CHANGE( RecalculaTotal( aTmp ) );
         OF       oFld:aDialogs[1]

      /*
      Moneda__________________________________________________________________
      */

      REDEFINE GET aGet[ _CDIVFAC ] VAR aTmp[ _CDIVFAC ];
         WHEN     ( nMode == APPD_MODE ) ;
         VALID    ( cDivIn( aGet[ _CDIVFAC ], oBmpDiv, aGet[ _NVDVFAC ], @cPinDiv, @nDinDiv, @cPirDiv, @nRinDiv, nil, dbfDiv, oBandera ) );
         PICTURE  "@!";
         ID       170 ;
         BITMAP   "LUPA" ;
         ON HELP  BrwDiv( aGet[ _CDIVFAC ], oBmpDiv, aGet[ _NVDVFAC ], dbfDiv, oBandera ) ;
         OF       oFld:aDialogs[1]

      REDEFINE BITMAP oBmpDiv ;
         RESOURCE "BAN_EURO" ;
         ID       171;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _NVDVFAC ] VAR aTmp[ _NVDVFAC ];
         WHEN     ( .F. ) ;
         ID       180 ;
         PICTURE  "@E 999,999.9999" ;
         OF       oFld:aDialogs[1]

      /*
      Bitmap________________________________________________________________
      */

      REDEFINE BITMAP oBmpEmp ;
         FILE     "Bmp\ImgFacPrv.bmp" ;
         ID       500 ;
         OF       oDlg

      /*
      Botones_________________________________________________________________
      */

      REDEFINE BUTTON aControl[1] ;
         ID       500 ;
         OF       oFld:aDialogs[1] ;
         WHEN     ( nMode != ZOOM_MODE .and. !lRecibosPagadosTmp( dbfTmpPgo ) ) ;
         ACTION   ( AppDeta( oBrwLin, bEdtDet, aTmp) )

      REDEFINE BUTTON aControl[2] ;
         ID       501 ;
         OF       oFld:aDialogs[1] ;
         WHEN     ( nMode != ZOOM_MODE .and. !lRecibosPagadosTmp( dbfTmpPgo )  ) ;
         ACTION   ( EdtDeta( oBrwLin, bEdtDet, aTmp ) )

      REDEFINE BUTTON aControl[3] ;
         ID       502 ;
         OF       oFld:aDialogs[1] ;
         WHEN     ( nMode != ZOOM_MODE .and. !lRecibosPagadosTmp( dbfTmpPgo ) ) ;
         ACTION   ( WinDelRec( oBrwLin, dbfTmp, {|| delDeta() }, {|| RecalculaTotal( aTmp ) } ) )

      REDEFINE BUTTON aControl[4] ;
         ID       503 ;
         OF       oFld:aDialogs[1] ;
         ACTION   ( if( !( dbfTmp )->lControl, WinZooRec( oBrwLin, bEdtDet, dbfTmp, aTmp ), ) )

      REDEFINE BUTTON ;
         ID       512 ;
         OF       oFld:aDialogs[1] ;
         WHEN     ( nMode == APPD_MODE .AND. !lRecibosPagadosTmp( dbfTmpPgo ) ) ;
         ACTION   ( GrpAlb( aGet[ _CCODPRV ], aTmp, oBrwLin ), RecalculaTotal( aTmp ) )

      REDEFINE BUTTON aControl[5] ;
         ID       524 ;
         OF       oFld:aDialogs[1] ;
         WHEN     ( nMode != ZOOM_MODE .AND. !lRecibosPagadosTmp( dbfTmpPgo ) ) ;
         ACTION   ( DbSwapUp( dbfTmp, oBrwLin ) )

      REDEFINE BUTTON aControl[6] ;
         ID       525 ;
         OF       oFld:aDialogs[1] ;
         WHEN     ( nMode != ZOOM_MODE .AND. !lRecibosPagadosTmp( dbfTmpPgo ) ) ;
         ACTION   ( DbSwapDown( dbfTmp, oBrwLin ) )

      /*
      Detalle________________________________________________________________
      */

      oBrwLin                 := IXBrowse():New( oFld:aDialogs[1] )

      oBrwLin:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwLin:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrwLin:cAlias          := dbfTmp

      oBrwLin:nMarqueeStyle   := 6
      oBrwLin:lFooter         := .t.
      oBrwLin:cName           := "Lineas de facturas a proveedor"

         with object ( oBrwLin:AddCol() )
            :cHeader          := "Cm. Cambio"
            :bStrData         := {|| "" }
            :bEditValue       := {|| ( dbfTmp )->lChgLin }
            :nWidth           := 20
            :lHide            := .t.
            :SetCheck( { "Sel16", "Nil16" } )
         end with

         with object ( oBrwLin:AddCol() )
            :cHeader          := "Número"
            :bEditValue       := {|| if( ( dbfTmp )->lKitChl, "", Trans( ( dbfTmp )->nNumLin, "@Z 9999" ) ) }
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
            :bEditValue       := {|| if( Empty( ( dbfTmp )->cRef ) .and. !( dbfTmp )->lControl, ( dbfTmp )->mLngDes, ( dbfTmp )->cDetalle ) }
            :nWidth           := 286
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
            :cHeader          := cNombreUnidades()
            :bEditValue       := {|| nTotNFacPrv( dbfTmp ) }
            :cEditPicture     := cPicUnd
            :nWidth           := 60
            :nDataStrAlign    := 1
            :nHeadStrAlign    := 1
            :nFooterType      := AGGR_SUM
         end with

         with object ( oBrwLin:AddCol() )
            :cHeader          := "UM. Unidad de medición"
            :bEditValue       := {|| ( dbfTmp )->cUnidad }
            :nWidth           := 25
         end with

         with object ( oBrwLin:AddCol() )
            :cHeader          := "Almacen"
            :bEditValue       := {|| ( dbfTmp )->cAlmLin }
            :nWidth           := 65
         end with

         with object ( oBrwLin:AddCol() )
            :cHeader          := "Importe"
            :bEditValue       := {|| nTotUFacPrv( dbfTmp, nDinDiv ) }
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
            :bEditValue       := {|| nTotLFacPrv( dbfTmp, nDinDiv, nRinDiv ) }
            :cEditPicture     := cPirDiv
            :nWidth           := 90
            :nDataStrAlign    := 1
            :nHeadStrAlign    := 1
            :nFooterType      := AGGR_SUM
         end with

         if nMode != ZOOM_MODE
            oBrwLin:bLDblClick   := {|| EdtDeta( oBrwLin, bEdtDet, aTmp ) }
         end if

      oBrwLin:CreateFromResource( 190 )

      /*
      Comentario para la factura de gastos_____________________________________
      */

      REDEFINE GET aGet[ _MCOMGAS ] VAR aTmp[ _MCOMGAS ] MEMO ;
         ID       290 ;
         COLOR    CLR_GET ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

       /*
       Primer tipo de " + cImp() + " de gastos____________________________________________
       */

       REDEFINE GET aGet[ _NNETGAS1 ] VAR aTmp[ _NNETGAS1 ] ;
         ID       600 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  cPirDiv ;
         VALID    ( oSayGas[11]:Refresh(), oSayGas[12]:Refresh(), .t. );
         ON CHANGE( RecalculaTotal( aTmp ) );
         OF       oFld:aDialogs[1]

       REDEFINE GET aGet[ _NIVAGAS1 ] VAR aTmp[ _NIVAGAS1 ] ;
         ID       601 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  "@ER 99.99%" ;
         SPINNER ;
         VALID    ( oSayGas[11]:Refresh(), oSayGas[12]:Refresh(), .t. );
         ON CHANGE( RecalculaTotal( aTmp ) );
         OF       oFld:aDialogs[1]

      REDEFINE SAY oSayGas[11] PROMPT Trans( aTmp[ _NNETGAS1 ] * aTmp[ _NIVAGAS1 ] / 100, cPirDiv ) ;
         ID       602 ;
         COLOR    CLR_GET ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _NREGAS1 ] VAR aTmp[ _NREGAS1 ] ;
         ID       603 ;
         WHEN     ( nMode != ZOOM_MODE .and. aTmp[ _LRECARGO ] ) ;
         PICTURE  "@ER 99.99%" ;
         SPINNER ;
         VALID    ( oSayGas[11]:Refresh(), oSayGas[12]:Refresh(), .t. );
         ON CHANGE( RecalculaTotal( aTmp ) );
         OF       oFld:aDialogs[1]

      REDEFINE SAY oSayGas[12] PROMPT Trans( aTmp[ _NNETGAS1 ] * aTmp[ _NREGAS1 ] / 100, cPirDiv ) ;
         ID       604 ;
         COLOR    CLR_GET ;
         OF       oFld:aDialogs[1]

      /*
      Segundo tipo de " + cImp() + " de gastos____________________________________________
      */

      REDEFINE GET aGet[ _NNETGAS2 ] VAR aTmp[ _NNETGAS2 ] ;
         ID       610 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  cPirDiv ;
         VALID    ( oSayGas[13]:Refresh(), oSayGas[14]:Refresh(), .t. );
         ON CHANGE( RecalculaTotal( aTmp ) );
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _NIVAGAS2 ] VAR aTmp[ _NIVAGAS2 ] ;
         ID       611 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  "@ER 99.99%" ;
         SPINNER ;
         VALID    ( oSayGas[13]:Refresh(), oSayGas[14]:Refresh(), .t. );
         ON CHANGE( RecalculaTotal( aTmp ) );
         OF       oFld:aDialogs[1]

      REDEFINE SAY oSayGas[13] PROMPT Trans( aTmp[ _NNETGAS2 ] * aTmp[ _NIVAGAS2 ] / 100, cPirDiv ) ;
         ID       612 ;
         COLOR    CLR_GET ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _NREGAS2 ] VAR aTmp[ _NREGAS2 ] ;
         ID       613 ;
         WHEN     ( nMode != ZOOM_MODE .and. aTmp[ _LRECARGO ] ) ;
         PICTURE  "@ER 99.99%" ;
         SPINNER ;
         VALID    ( oSayGas[13]:Refresh(), oSayGas[14]:Refresh(), .t. );
         ON CHANGE( RecalculaTotal( aTmp ) );
         OF       oFld:aDialogs[1]

      REDEFINE SAY oSayGas[14] PROMPT Trans( aTmp[ _NNETGAS2 ] * aTmp[ _NREGAS2 ] / 100, cPirDiv ) ;
         ID       614 ;
         COLOR    CLR_GET ;
         OF       oFld:aDialogs[1]

      /*
      Tercer tipo de " + cImp() + " de gastos____________________________________________
      */

      REDEFINE GET aGet[ _NNETGAS3 ] VAR aTmp[ _NNETGAS3 ] ;
         ID       620 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  cPirDiv ;
         VALID    ( oSayGas[15]:Refresh(), oSayGas[16]:Refresh(), .t. );
         ON CHANGE( RecalculaTotal( aTmp ) );
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _NIVAGAS3 ] VAR aTmp[ _NIVAGAS3 ] ;
         ID       621 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  "@ER 99.99%" ;
         SPINNER ;
         VALID    ( oSayGas[15]:Refresh(), oSayGas[16]:Refresh(), .t. );
         ON CHANGE( RecalculaTotal( aTmp ) );
         OF       oFld:aDialogs[1]

      REDEFINE SAY oSayGas[15] PROMPT Trans( aTmp[ _NNETGAS3 ] * aTmp[ _NIVAGAS3 ] / 100, cPirDiv ) ;
         ID       622 ;
         COLOR    CLR_GET ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _NREGAS3 ] VAR aTmp[ _NREGAS3 ] ;
         ID       623 ;
         WHEN     ( nMode != ZOOM_MODE .and. aTmp[ _LRECARGO ] ) ;
         PICTURE  "@ER 99.99%" ;
         SPINNER ;
         VALID    ( oSayGas[15]:Refresh(), oSayGas[16]:Refresh(), .t. );
         ON CHANGE( RecalculaTotal( aTmp ) );
         OF       oFld:aDialogs[1]

      REDEFINE SAY oSayGas[16] PROMPT Trans( aTmp[ _NNETGAS3 ] * aTmp[ _NREGAS3 ] / 100, cPirDiv ) ;
         ID       624 ;
         COLOR    CLR_GET ;
         OF       oFld:aDialogs[1]

      /*
      Descuentos_______________________________________________________________
      */

      REDEFINE GET aGet[ _CDTOESP ] VAR aTmp[ _CDTOESP ] ;
         ID       199 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ON CHANGE( RecalculaTotal( aTmp ) );
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _NDTOESP ] VAR aTmp[ _NDTOESP ] ;
         ID       200 ;
         WHEN     ( nMode != ZOOM_MODE .AND. !lRecibosPagadosTmp( dbfTmpPgo ) ) ;
         PICTURE  "@E 99.99" ;
         SPINNER ;
         ON CHANGE( RecalculaTotal( aTmp ) );
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CDPP ] VAR aTmp[ _CDPP ] ;
         ID       209 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ON CHANGE( RecalculaTotal( aTmp ) );
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _NDPP ] VAR aTmp[ _NDPP ];
         ID       210 ;
         WHEN     ( nMode != ZOOM_MODE .AND. !lRecibosPagadosTmp( dbfTmpPgo ) ) ;
         PICTURE  "@E 99.99" ;
         SPINNER ;
         ON CHANGE( RecalculaTotal( aTmp ) );
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CDTOUNO ] VAR aTmp[ _CDTOUNO ] ;
         ID       240 ;
         PICTURE  "@!" ;
         COLOR    CLR_GET ;
         WHEN     ( nMode != ZOOM_MODE .AND. !lRecibosPagadosTmp( dbfTmpPgo ) ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _NDTOUNO ] VAR aTmp[ _NDTOUNO ];
         ID       250 ;
         PICTURE  "@E 99.99" ;
         SPINNER ;
         ON CHANGE( RecalculaTotal( aTmp ) );
         WHEN     ( nMode != ZOOM_MODE .AND. !lRecibosPagadosTmp( dbfTmpPgo ) ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CDTODOS ] VAR aTmp[ _CDTODOS ] ;
         ID       260 ;
         PICTURE  "@!" ;
         WHEN     ( nMode != ZOOM_MODE .AND. !lRecibosPagadosTmp( dbfTmpPgo ) ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _NDTODOS ] VAR aTmp[ _NDTODOS ];
         ID       270 ;
         PICTURE  "@E 99.99" ;
         SPINNER ;
         ON CHANGE( RecalculaTotal( aTmp ) );
         WHEN     ( nMode != ZOOM_MODE .AND. !lRecibosPagadosTmp( dbfTmpPgo ) ) ;
         OF       oFld:aDialogs[1]

      /*
      Desglose del impuestos---------------------------------------------------------
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
         :nWidth        := 82
         :nDataStrAlign := 1
         :nHeadStrAlign := 1
         :nFootStrAlign := 1
      end with

      with object ( oBrwIva:aCols[ 2 ] )
         :cHeader       := "Base"
         :bStrData      := {|| if( !Empty( aTotIva[ oBrwIva:nArrayAt, 2 ] ), Trans( aTotIva[ oBrwIva:nArrayAt, 2 ], cPirDiv ), "" ) }
         :nWidth        := 82
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
         :nWidth        := 75
         :nDataStrAlign := 1
         :nHeadStrAlign := 1
         :nFootStrAlign := 1
      end with

      with object ( oBrwIva:aCols[ 6 ] )
         :cHeader       := "R.E."
         :bStrData      := {|| if( !Empty( aTotIva[ oBrwIva:nArrayAt, 6 ] ) .and. aTmp[ _LRECARGO ], Trans( aTotIva[ oBrwIva:nArrayAt, 6 ], cPirDiv ), "" ) }
         :nWidth        := 75
         :cEditPicture  := cPirDiv
         :nDataStrAlign := 1
         :nHeadStrAlign := 1
      end with

      /*
      Cajas de Totales
      ------------------------------------------------------------------------
      */

      REDEFINE SAY oGetNet VAR nGetNeto ;
         ID       370 ;
         OF       oFld:aDialogs[1]

      REDEFINE SAY oGetIva VAR nGetIva ;
         ID       380 ;
         OF       oFld:aDialogs[1]

      REDEFINE SAY oGetReq VAR nGetReq ;
         ID       390 ;
         OF       oFld:aDialogs[1]

      REDEFINE CHECKBOX aGet[ _LRECARGO ] VAR aTmp[ _LRECARGO ] ;
         ID       400 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ON CHANGE( RecalculaTotal( aTmp ) );
         OF       oFld:aDialogs[1]

      REDEFINE SAY oGetTotal VAR nTotFac ;
         ID       410 ;
         FONT     oFntTot ;
         OF       oFld:aDialogs[1]

/*
      REDEFINE SAY oGet[4] VAR cGet[4];
         ID       420 ;
         FONT     oFont ;
         OF       oFld:aDialogs[1]
*/

      REDEFINE GET aGet[ _CSERFAC ] VAR aTmp[ _CSERFAC ] ;
         ID       100 ;
         PICTURE  "@!" ;
         SPINNER ;
         ON UP    ( UpSerie( aGet[ _CSERFAC ] ) );
         ON DOWN  ( DwSerie( aGet[ _CSERFAC ] ) );
         WHEN     ( nMode == APPD_MODE .OR. nMode == DUPL_MODE );
         VALID    ( aTmp[ _CSERFAC ] >= "A" .and. aTmp[ _CSERFAC ] <= "Z"  );
         OF       oFld:aDialogs[1]

         aGet[ _CSERFAC ]:bLostFocus := {|| aGet[ _CCODPRO ]:cText( cProCnt( aTmp[ _CSERFAC ] ) ) }

      REDEFINE GET aGet[_NNUMFAC] VAR aTmp[_NNUMFAC] ;
         ID       101 ;
         PICTURE  "999999999";
         WHEN     .F. ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[_CSUFFAC] VAR aTmp[_CSUFFAC];
         ID       102 ;
         WHEN     .F. ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[_DFECFAC] VAR aTmp[_DFECFAC] ;
         ID       110 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CSUPED ] VAR aTmp[ _CSUPED ] ;
         ID       120 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( ValidaSuFactura( aGet ) ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CNUMALB ] VAR aTmp[ _CNUMALB ] ;
         ID       130 ;
         PICTURE  "@R A/#########/##" ;
         WHEN     ( nMode == APPD_MODE ) ;
         VALID    ( cAlbPrv( aGet, oBrwLin, nMode, aTmp ), RecalculaTotal( aTmp ) ) ;
         ON HELP  ( brwAlbPrv( aGet[ _CNUMALB ], dbfAlbPrvT, dbfAlbPrvL, dbfIva, dbfDiv ) );
         BITMAP   "LUPA" ;
         OF       oFld:aDialogs[1]

      REDEFINE CHECKBOX aGet[ _LFACGAS ] VAR aTmp[ _LFACGAS ] ;
         ID       550;
         WHEN     ( nMode == APPD_MODE ) ;
         ON CHANGE( ShowKitFacPrv( TDataView():FacturasProveedores( nView ), oBrwLin, cCodPrv, nil, aGet, aTmp, aControl, oSayGas, oSayLabels, oBrwIva ),;
                    RecalculaTotal( aTmp ), .t. );
         OF       oFld:aDialogs[1]

      REDEFINE COMBOBOX aGet[ _NTIPRET ] VAR aTmp[ _NTIPRET ] ;
         ITEMS    { "Ret. S/Base", "Ret. S/Total" };
         ID       440 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( RecalculaTotal( aTmp ) );
         ON CHANGE( RecalculaTotal( aTmp ) );
         OF       oFld:aDialogs[ 1 ]

      REDEFINE GET aGet[ _NPCTRET ] VAR aTmp[ _NPCTRET ] ;
         ID       450 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( RecalculaTotal( aTmp ) );
         ON CHANGE( RecalculaTotal( aTmp ) );
         PICTURE  "@E 99.9" ;
         OF       oFld:aDialogs[ 1 ]

      REDEFINE SAY oGetRet VAR cGetRet;
         ID       491 ;
         OF       oFld:aDialogs[1]

      REDEFINE GROUP oSayLabels[ 1 ] ID 700 OF oFld:aDialogs[ 1 ] TRANSPARENT
      REDEFINE SAY   oSayLabels[ 2 ] ID 701 OF oFld:aDialogs[ 1 ]
      REDEFINE SAY   oSayLabels[ 3 ] ID 702 OF oFld:aDialogs[ 1 ]
      REDEFINE SAY   oSayLabels[ 4 ] ID 703 OF oFld:aDialogs[ 1 ]
      REDEFINE SAY   oSayLabels[ 5 ] ID 704 OF oFld:aDialogs[ 1 ]
      REDEFINE SAY   oSayLabels[ 6 ] ID 705 OF oFld:aDialogs[ 1 ]
      REDEFINE SAY   oSayLabels[ 7 ] ID 706 OF oFld:aDialogs[ 1 ]

      REDEFINE SAY   oSayGas[ 1 ]    ID 707 OF oFld:aDialogs[ 1 ]
      REDEFINE SAY   oSayGas[ 2 ]    ID 708 OF oFld:aDialogs[ 1 ]
      REDEFINE SAY   oSayGas[ 3 ]    ID 709 OF oFld:aDialogs[ 1 ]
      REDEFINE SAY   oSayGas[ 4 ]    ID 710 OF oFld:aDialogs[ 1 ]
      REDEFINE SAY   oSayGas[ 5 ]    ID 711 OF oFld:aDialogs[ 1 ]
      REDEFINE SAY   oSayGas[ 6 ]    ID 712 OF oFld:aDialogs[ 1 ]
      REDEFINE SAY   oSayGas[ 7 ]    ID 713 OF oFld:aDialogs[ 1 ]
      REDEFINE SAY   oSayGas[ 8 ]    ID 714 OF oFld:aDialogs[ 1 ]
      REDEFINE SAY   oSayGas[ 9 ]    ID 715 OF oFld:aDialogs[ 1 ]
      REDEFINE SAY   oSayGas[ 10]    ID 716 OF oFld:aDialogs[ 1 ]

      REDEFINE GET   aGet[ _CCODUSR ] VAR aTmp[ _CCODUSR ];
         ID          125 ;
         WHEN        ( .f. ) ;
         VALID       ( SetUsuario( aGet[ _CCODUSR ], oUsr, nil, dbfUsr ) );
         OF          oFld:aDialogs[2]

      REDEFINE GET   oUsr VAR cUsr ;
         ID          126 ;
         WHEN        ( .f. ) ;
         OF          oFld:aDialogs[2]

      /*
      Redefinición de la segunda caja de dialogo
      ------------------------------------------------------------------------
      */

      REDEFINE GET aGet[ _DFECENT ] VAR aTmp[ _DFECENT ] ;
         ID       131 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[ 2 ]

      REDEFINE GET aGet[ _CNUMDOC ] VAR aTmp[ _CNUMDOC ] ;
         ID       142 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[ 2 ]

      /*
      Regimen de impuestos-----------------------------------------------------------
      */

      REDEFINE RADIO aGet[ _NREGIVA ] VAR aTmp[ _NREGIVA ] ;
         ID       270, 271, 272, 273 ;
         WHEN     ( .f. ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ _CCODDLG ] VAR aTmp[ _CCODDLG ] ;
         ID       300 ;
         WHEN     ( .f. ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET oGet[ 6 ] VAR cGet[ 6 ] ;
         ID       301 ;
         WHEN     ( .f. ) ;
         OF       oFld:aDialogs[ 2 ]

      REDEFINE GET aGet[ _SUBCTA ] VAR aTmp[ _SUBCTA ] ;
         ID       370 ;
         IDTEXT   371 ;
         PICTURE  ( Replicate( "X", nLenSubcuentaContaplus() ) ) ;
         WHEN     ( aTmp[ _LFACGAS ] .and. nLenCuentaContaplus() != 0 .and. nMode != ZOOM_MODE ) ;
         BITMAP   "Lupa" ;
         ON HELP  ( BrwChkSubcuenta( aGet[ _SUBCTA ], aGet[ _SUBCTA ]:oHelpText ) ) ;
         VALID    ( MkSubcuenta( aGet[ _SUBCTA ], nil, aGet[ _SUBCTA ]:oHelpText ) ) ;
         OF       oFld:aDialogs[ 2 ]

      REDEFINE GET aGet[ _CCODPRO ] VAR aTmp[ _CCODPRO ] ;
         ID       170 ;
         PICTURE  "@R ###.######" ;
         COLOR    CLR_GET ;
         WHEN     ( nLenCuentaContaplus() != 0 .AND. nMode != ZOOM_MODE ) ;
         VALID    ( ChkProyecto( aTmp[ _CCODPRO ], oGet[ 4 ] ), .t. );
         BITMAP   "Lupa" ;
         ON HELP  ( BrwProyecto( aGet[ _CCODPRO ], oGet[ 4 ] ) );
         OF       oFld:aDialogs[2]

      REDEFINE GET oGet[ 4 ] VAR cGet[ 4 ] ;
         ID       171 ;
         WHEN     .F.;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ _NBULTOS ] VAR aTmp[ _NBULTOS ] ;
         ID       132 ;
         PICTURE  "999999" ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[2]

      /*
      Campo para los comentarios---------------------------------------------
      */

      REDEFINE GET aGet[ _MCOMENT ] VAR aTmp[ _MCOMENT ];
         MEMO ;
         ID       210 ;
         COLOR    CLR_GET ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[2]

      /*
      Redefine de la Zona de pagos-------------------------------------------
      */

      oBrwPgo                 := IXBrowse():New( oFld:aDialogs[2] )

      oBrwPgo:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwPgo:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrwPgo:cAlias          := dbfTmpPgo
      oBrwPgo:cName           := "Pagos de facturas a proveedor"

      oBrwPgo:nMarqueeStyle   := 6

      oBrwPgo:CreateFromResource( 220 )

         with object ( oBrwPgo:AddCol() )
            :cHeader          := "Pg. Pagado"
            :bStrData         := {|| "" }
            :bBmpData         := {|| nEstadoRecibo( dbfTmpPgo ) }
            :nWidth           := 22
            :AddResource( "Cnt16" )
            :AddResource( "Sel16" )
            :AddResource( "UndoRed16" )
         end with

         with object ( oBrwPgo:AddCol() )
            :cHeader          := "Cn. Contabilizado"
            :bStrData         := {|| "" }
            :bEditValue       := {|| ( dbfTmpPgo )->lConPgo }
            :nWidth           := 22
            :SetCheck( { "Sel16", "Nil16" } )
         end with

         with object ( oBrwPgo:AddCol() )
            :cHeader          := "Sesión"
            :bEditValue       := {|| Trans( ( dbfTmpPgo )->cTurRec, "######" ) }
            :nWidth           := 40
            :nDataStrAlign    := 1
            :nHeadStrAlign    := 1
         end with

         with object ( oBrwPgo:AddCol() )
            :cHeader          := "Fecha"
            :bEditValue       := {|| Dtoc( ( dbfTmpPgo )->dPreCob ) }
            :nWidth           := 75
         end with

         with object ( oBrwPgo:AddCol() )
            :cHeader          := "Vencimiento"
            :bEditValue       := {|| Dtoc( ( dbfTmpPgo )->dFecVto ) }
            :lHide            := .t.
            :nWidth           := 70
         end with

         with object ( oBrwPgo:AddCol() )
            :cHeader          := "Cobro"
            :bEditValue       := {|| Dtoc( ( dbfTmpPgo )->dEntrada ) }
            :nWidth           := 75
         end with

         with object ( oBrwPgo:AddCol() )
            :cHeader          := "Descripción"
            :bEditValue       := {|| ( dbfTmpPgo )->cDescrip }
            :nWidth           := 180
         end with

         with object ( oBrwPgo:AddCol() )
            :cHeader          := "Importe"
            :bEditValue       := {|| nTotRecPrv( dbfTmpPgo, dbfDiv, nil, .t. ) }
            :nWidth           := 85
            :nDataStrAlign    := 1
            :nHeadStrAlign    := 1
         end with

         with object ( oBrwPgo:AddCol() )
            :cHeader          := "Divisa"
            :bEditValue       := {|| cSimDiv( ( dbfTmpPgo )->cDivPgo, dbfDiv ) }
            :nWidth           := 55
         end with

         if nMode != ZOOM_MODE
            oBrwPgo:bLDblClick   := {|| ExtEdtRecPrv( dbfTmpPgo, TDataView():FacturasProveedores( nView ), dbfFacPrvL, dbfFPago, dbfIva, dbfDiv, oBanco, oBandera ), oBrwPgo:Refresh(), RecalculaTotal( aTmp ) }
         end if

      REDEFINE BUTTON ;
         ID       501 ;
         OF       oFld:aDialogs[2];
         WHEN     ( nMode == EDIT_MODE ) ;
         ACTION   ( ExtEdtRecPrv( dbfTmpPgo, TDataView():FacturasProveedores( nView ), dbfFacPrvL, dbfFPago, dbfIva, dbfDiv, oBanco, oBandera ), oBrwPgo:Refresh(), RecalculaTotal( aTmp ) )

      REDEFINE BUTTON ;
         ID       502 ;
         OF       oFld:aDialogs[2];
         WHEN     ( nMode == EDIT_MODE ) ;
         ACTION   ( ExtDelRecPrv( dbfTmpPgo ), oBrwPgo:Refresh(), RecalculaTotal( aTmp ) )

      REDEFINE BUTTON ;
         ID       505 ;
         OF       oFld:aDialogs[2];
         WHEN     ( nMode == EDIT_MODE ) ;
         ACTION   ( PrnRecPrv( ( dbfTmpPgo )->cSerFac + Str( ( dbfTmpPgo )->nNumFac ) + ( dbfTmpPgo )->cSufFac + Str( ( dbfTmpPgo )->nNumRec ), .f. ) )

      REDEFINE BUTTON ;
         ID       506 ;
         OF       oFld:aDialogs[2];
         WHEN     ( nMode == EDIT_MODE ) ;
         ACTION   ( VisRecPrv( ( dbfTmpPgo )->cSerFac + Str( ( dbfTmpPgo )->nNumFac ) + ( dbfTmpPgo )->cSufFac + Str( ( dbfTmpPgo )->nNumRec ), .f. ) )

      REDEFINE SAY oGetTotPg VAR nTotFac ;
         ID       405 ;
         OF       oFld:aDialogs[2]

      REDEFINE SAY oGetPgd VAR nGetPgd ;
         ID       400 ;
         OF       oFld:aDialogs[2]

      REDEFINE SAY oGetPdt VAR ( nTotFac - nGetPgd ) ;
         ID       410 ;
         OF       oFld:aDialogs[2]

      /*Impresión ( informa de si está impreimido o no y de cuando se imprimió )*/

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
      Caja de dialogo de incidencias
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
            :nWidth           := 60
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
            :nWidth           := 240
         end with

         with object ( oBrwInc:AddCol() )
            :cHeader          := "Fecha"
            :bEditValue       := {|| Dtoc( ( dbfTmpInc )->dFecInc ) }
            :nWidth           := 90
         end with

         with object ( oBrwInc:AddCol() )
            :cHeader          := "Descripción"
            :bEditValue       := {|| ( dbfTmpInc )->mDesInc }
            :nWidth           := 410
         end with

         if nMode != ZOOM_MODE
            oBrwInc:bLDblClick   := {|| WinEdtRec( oBrwInc, bEdtInc, dbfTmpInc, nil, nil, aTmp ) }
         end if

         oBrwInc:CreateFromResource( 210 )

      REDEFINE BUTTON ;
         ID       500 ;
         OF       oFld:aDialogs[ 3 ] ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( WinAppRec( oBrwInc, bEdtInc, dbfTmpInc, nil, nil, aTmp ) )

      REDEFINE BUTTON ;
         ID       501 ;
         OF       oFld:aDialogs[ 3 ] ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( WinEdtRec( oBrwInc, bEdtInc, dbfTmpInc, nil, nil, aTmp ) )

      REDEFINE BUTTON ;
         ID       502 ;
         OF       oFld:aDialogs[ 3 ] ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( DbDelRec( oBrwInc, dbfTmpInc, nil, nil, .t. ) )

      REDEFINE BUTTON ;
         ID       503 ;
         OF       oFld:aDialogs[ 3 ] ;
         ACTION   ( WinZooRec( oBrwInc, bEdtInc, dbfTmpInc ) )

      /*
      Caja de dialogo de incidencias
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
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( WinAppRec( oBrwDoc, bEdtDoc, dbfTmpDoc, nil, nil, aTmp ) )

      REDEFINE BUTTON ;
         ID       501 ;
         OF       oFld:aDialogs[ 4 ] ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( WinEdtRec( oBrwDoc, bEdtDoc, dbfTmpDoc, nil, nil, aTmp ) )

      REDEFINE BUTTON ;
         ID       502 ;
         OF       oFld:aDialogs[ 4 ] ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( DbDelRec( oBrwDoc, dbfTmpDoc, nil, nil, .f. ) )

      REDEFINE BUTTON ;
         ID       503 ;
         OF       oFld:aDialogs[ 4 ] ;
         ACTION   ( WinZooRec( oBrwDoc, bEdtDoc, dbfTmpDoc ) )

      REDEFINE BUTTON ;
         ID       504 ;
         OF       oFld:aDialogs[ 4 ] ;
         ACTION   ( ShellExecute( oDlg:hWnd, "open", rTrim( ( dbfTmpDoc )->cRuta ) ) )

      REDEFINE BUTTON ;
         ID       4 ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( RecalculaFacturaProveedores( aTmp, oDlg ), ( oBrwLin:Refresh() ), RecalculaTotal( aTmp ) )

      REDEFINE BUTTON oBtnOk;
         ID       IDOK ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( EndTrans( aTmp, aGet, oBrw, oBrwLin, nMode, nDinDiv, oDlg ) )

      REDEFINE BUTTON ;
         ID       3 ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( if( EndTrans( aTmp, aGet, oBrw, oBrwLin, nMode, nDinDiv, oDlg ), GenFacPrv( IS_PRINTER ), ) )

      REDEFINE BUTTON ;
         ID       IDCANCEL ;
         OF       oDlg ;
         CANCEL ;
         ACTION   ( If( ExitNoSave( nMode, dbfTmp ), ( oDlg:end() ), ) )

   if nMode != ZOOM_MODE
      oFld:aDialogs[1]:AddFastKey( VK_F2, {|| AppDeta( oBrwLin, bEdtDet, aTmp) } )
      oFld:aDialogs[1]:AddFastKey( VK_F3, {|| EdtDeta( oBrwLin, bEdtDet, aTmp ) } )
      oFld:aDialogs[1]:AddFastKey( VK_F4, {|| WinDelRec( oBrwLin, dbfTmp, {|| delDeta() }, {|| RecalculaTotal( aTmp ) } ) } )

      oFld:aDialogs[2]:AddFastKey( VK_F3, {|| ExtEdtRecPrv( dbfTmpPgo, TDataView():FacturasProveedores( nView ), dbfFacPrvL, dbfFPago, dbfIva, dbfDiv, oBanco, oBandera ), oBrwPgo:Refresh(), RecalculaTotal( aTmp ) } )
      oFld:aDialogs[2]:AddFastKey( VK_F4, {|| ExtDelRecPrv( dbfTmpPgo ), oBrwPgo:Refresh(), RecalculaTotal( aTmp ) } )

      oFld:aDialogs[3]:AddFastKey( VK_F2, {|| WinAppRec( oBrwInc, bEdtInc, dbfTmpInc, nil, nil, aTmp ) } )
      oFld:aDialogs[3]:AddFastKey( VK_F3, {|| WinEdtRec( oBrwInc, bEdtInc, dbfTmpInc, nil, nil, aTmp ) } )
      oFld:aDialogs[3]:AddFastKey( VK_F4, {|| DbDelRec( oBrwInc, dbfTmpInc, nil, nil, .t. ) } )

      oFld:aDialogs[4]:AddFastKey( VK_F2, {|| WinAppRec( oBrwDoc, bEdtDoc, dbfTmpDoc, nil, nil, aTmp ) } )
      oFld:aDialogs[4]:AddFastKey( VK_F3, {|| WinEdtRec( oBrwDoc, bEdtDoc, dbfTmpDoc, nil, nil, aTmp ) } )
      oFld:aDialogs[4]:AddFastKey( VK_F4, {|| DbDelRec( oBrwDoc, dbfTmpDoc, nil, nil, .f. ) } )

      oDlg:AddFastKey( VK_F5,             {|| EndTrans( aTmp, aGet, oBrw, oBrwLin, nMode, nDinDiv, oDlg ) } )
      oDlg:AddFastKey( VK_F6,             {|| if( EndTrans( aTmp, aGet, oBrw, oBrwLin, nMode, nDinDiv, oDlg ), GenFacPrv( IS_PRINTER ), ) } )
      oDlg:AddFastKey( 65,                {|| if( GetKeyState( VK_CONTROL ), CreateInfoArticulo(), ) } )
   end if

   oDlg:AddFastKey ( VK_F1, {|| GoHelp() } )

   do case
      case nMode == APPD_MODE .and. lRecogerUsuario() .and. Empty( cCodArt )
         oDlg:bStart := {|| if( lGetUsuario( aGet[ _CCODUSR ], dbfUsr ), , oDlg:end() ) }

      case nMode == APPD_MODE .and. lRecogerUsuario() .and. !Empty( cCodArt )
         oDlg:bStart := {|| if( lGetUsuario( aGet[ _CCODUSR ], dbfUsr ), AppDeta( oBrwLin, bEdtDet, aTmp, cCodArt ), oDlg:end() ) }

      case nMode == APPD_MODE .and. !lRecogerUsuario() .and. !Empty( cCodArt )
         oDlg:bStart := {|| AppDeta( oBrwLin, bEdtDet, aTmp, cCodArt ) }

   end case

   ACTIVATE DIALOG oDlg ;
      ON INIT     (  if( !Empty( cNumAlb ), aGet[ _CNUMALB ]:lValid(), ),;
                     EdtRecMenu( aTmp, oDlg ),;
                     ShowKitFacPrv( TDataView():FacturasProveedores( nView ), oBrwLin, cCodPrv, dbfTmpInc, aGet, aTmp, aControl, oSayGas, oSayLabels, oBrwIva ),;
                     oBrwLin:Load(),;
                     oBrwPgo:Load(),;
                     oBrwInc:Load() ) ;
      ON PAINT    (  RecalculaTotal( aTmp ) );
      CENTER

   oBmpEmp:End()
   oBmpGeneral:End()

   /*
   Estado de albaran facurado--------------------------------------------------
   */

   if oDlg:nResult != IDOK
      if len( aNumAlb ) > 0
         for n := 1 to len( aNumAlb )
            if ( dbfAlbPrvT )->( dbSeek( aNumAlb[ n ] ) )
               SetFacturadoAlbaranProveedor( .f., , , dbfAlbPrvT, dbfAlbPrvL, dbfAlbPrvS )
            end if
         next
      end if
   end if

   ( TDataView():FacturasProveedores( nView ) )->( OrdSetFocus( nOrd ) )

   /*
   Chequea si la factura esta liquidada----------------------------------------
   */

   ChkLqdFacPrv( nil, TDataView():FacturasProveedores( nView ), dbfFacPrvL, dbfFacPrvP, dbfIva, dbfDiv )

   /*
   Cerramos los ficheros-------------------------------------------------------
   */

   KillTrans( oBrwLin )

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

Static Function EdtRecMenu( aTmp, oDlg )

   MENU oMnuRec

      MENUITEM    "&1. Rotor"

         MENU

            if !lExternal

            MENUITEM    "&1. Visualizar albarán";
               MESSAGE  "Visualiza el albarán del que proviene" ;
               RESOURCE "Document_plain_businessman_16" ;
               ACTION   ( if( !Empty( ( TDataView():FacturasProveedores( nView ) )->cNumAlb ), ZooAlbPrv( ( TDataView():FacturasProveedores( nView ) )->cNumAlb ), MsgStop( "La factura no proviene de un albarán" ) ))

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
               ACTION   ( TTrazaDocumento():Activate( FAC_PRV, ( TDataView():FacturasProveedores( nView ) )->cSerFac + Str( ( TDataView():FacturasProveedores( nView ) )->nNumFac ) + ( TDataView():FacturasProveedores( nView ) )->cSufFac ) )

         ENDMENU

   ENDMENU

   oDlg:SetMenu( oMnuRec )

Return ( oMnuRec )

//----------------------------------------------------------------------------//

Static Function RecalculaFacturaProveedores( aTmp, oDlg )

   local nRecNum
   local nPreCom

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

         ( dbfTmp )->nPreUnit       := nPreCom

      else

         if uFieldEmpresa( "lCosPrv", .f. )
            nPreCom                 := nPreArtPrv( aTmp[ _CCODPRV ], ( dbfTmp )->cRef, dbfArtPrv )
         end if

         if nPreCom != 0
            ( dbfTmp )->nPreUnit    := nPreCom
         else
            ( dbfTmp )->nPreUnit    := nCosto( ( dbfTmp )->cRef, dbfArticulo, dbfKit, .f., aTmp[ _CDIVFAC ], dbfDiv )
         end if

         /*
         Descuento de articulo----------------------------------------------
         */

         if uFieldEmpresa( "lCosPrv", .f. )

            nPreCom                 := nDtoArtPrv( aTmp[ _CCODPRV ], ( dbfTmp )->cRef, dbfArtPrv )

            if nPreCom != 0
               ( dbfTmp )->nDtoLin  := nPreCom
            end if

         /*
         Descuento de promocional----------------------------------------------
         */

            nPreCom                 := nPrmArtPrv( aTmp[ _CCODPRV ], ( dbfTmp )->cRef, dbfArtPrv )

            if nPreCom != 0
               ( dbfTmp )->nDtoPrm  :=  nPreCom
            end if

         end if

      end if

      ( dbfTmp )->( dbSkip() )

   end while

   ( dbfTmp )->( dbGoTo( nRecNum ) )

   oDlg:Enable()

return nil

//----------------------------------------------------------------------------//

Static Function EdtInc( aTmp, aGet, dbfFacPrvI, oBrw, bWhen, bValid, nMode, aTmpFac )

   local oDlg
   local oNomInci
   local cNomInci       := RetFld( aTmp[ ( dbfTmpInc )->( FieldPos( "cCodTip" ) ) ], dbfInci )

   if nMode == APPD_MODE

      aTmp[ _CSERFAC  ] := aTmpFac[ _CSERFAC ]
      aTmp[ _NNUMFAC  ] := aTmpFac[ _NNUMFAC ]
      aTmp[ _CSUFFAC  ] := aTmpFac[ _CSUFFAC ]

      if IsMuebles()
         aTmp[ ( dbfTmpInc )->( FieldPos( "lAviso" ) ) ]  := .t.
      end if

   end if

   DEFINE DIALOG oDlg RESOURCE "INCIDENCIA" TITLE LblTitle( nMode ) + "incidencias de facturas a proveedores"

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
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE CHECKBOX aTmp[ ( dbfTmpInc )->( FieldPos( "lAviso" ) ) ] ;
         ID       150 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
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

Static Function EdtDoc( aTmp, aGet, dbfAlbPrvD, oBrw, bWhen, bValid, nMode, aTmpLin )

   local oDlg
   local oRuta
   local oNombre
   local oObservacion

   DEFINE DIALOG oDlg RESOURCE "DOCUMENTOS" TITLE LblTitle( nMode ) + "documento de facturas a proveedor"

      REDEFINE GET oNombre VAR aTmp[ ( dbfTmpDoc )->( FieldPos( "cNombre" ) ) ] ;
         ID       120 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET oRuta VAR aTmp[ ( dbfTmpDoc )->( FieldPos( "cRuta" ) ) ] ;
         ID       100 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         BITMAP   "FOLDER" ;
         ON HELP  ( oRuta:cText( cGetFile( 'Doc ( *.* ) | ' + '*.*', 'Seleccione el nombre del fichero' ) ) ) ;
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
/*
Edita las lineas de Detalle
*/

STATIC FUNCTION EdtDet( aTmp, aGet, dbfFacPrvL, oBrw, aTmpFac, cCodArtEnt, nMode )

   local oDlg
   local oFld
   local oBtn
   local oTotal
   local cSay2
   local oSay2
   local oBmp
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
   local nTotal            := 0
   local oBeneficioSobre   := Array( 6 )
   local cBeneficioSobre   := Afill( Array( 6 ), "" )
   local aBeneficioSobre   := { "Costo", "Venta" }
   local nStkAct           := 0
   local oStkAct
   local oSayLote
   local cCodArt           := Padr( aTmp[ _CREF ], 200 )

   /*
   Este valor los guaradamos para detectar los posibles cambios----------------
   */

   cOldCodArt              := aTmp[ _CREF    ]
   cOldPrpArt              := aTmp[ _CCODPR1 ] + aTmp[ _CCODPR2 ] + aTmp[ _CVALPR1 ] + aTmp[ _CVALPR2 ]
   cOldUndMed              := aTmp[ _CUNIDAD ]

   do case
   case nMode == APPD_MODE

      aTmp[ _NUNICAJA ]    := 1
      aTmp[ _CALMLIN  ]    := aTmpFac[ _CCODALM ]
      aTmp[ _NNUMLIN  ]    := nLastNum( dbfTmp )
      aTmp[ _LCHGLIN  ]    := lActCos()
      aTmp[ _DFECCAD  ]    := Ctod( "" )

      if !Empty( cCodArtEnt )
         cCodArt           := cCodArtEnt
      end if

   case nMode == EDIT_MODE

      if !Empty( aTmp[ _CREF ] )
         ( dbfArticulo )->( dbSeek( Alltrim( aTmp[ _CREF ] ) ) )
      end if

   end case

   /*
   Beneficion sobre------------------------------------------------------------
   */

   cBeneficioSobre[ 1 ]    := aBeneficioSobre[ Max( aTmp[ _NBNFSBR1 ], 1 ) ]
   cBeneficioSobre[ 2 ]    := aBeneficioSobre[ Max( aTmp[ _NBNFSBR2 ], 1 ) ]
   cBeneficioSobre[ 3 ]    := aBeneficioSobre[ Max( aTmp[ _NBNFSBR3 ], 1 ) ]
   cBeneficioSobre[ 4 ]    := aBeneficioSobre[ Max( aTmp[ _NBNFSBR4 ], 1 ) ]
   cBeneficioSobre[ 5 ]    := aBeneficioSobre[ Max( aTmp[ _NBNFSBR5 ], 1 ) ]
   cBeneficioSobre[ 6 ]    := aBeneficioSobre[ Max( aTmp[ _NBNFSBR6 ], 1 ) ]

   /*
   Caja de dialogo-------------------------------------------------------------
   */

   DEFINE DIALOG oDlg RESOURCE "LALBPRV" TITLE LblTitle( nMode ) + "lineas a facturas de proveedores"

      REDEFINE FOLDER oFld ;
         ID       400 ;
         OF       oDlg ;
         PROMPT   "&General",;
                  "&Precios",;
                  "&Observaciones" ;
         DIALOGS  "LFACPRV_7",;
                  "LALBPRV_2",;
                  "LFACPRV_5"

      REDEFINE GET aGet[ _CREF ] VAR cCodArt ;
         ID       110 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( LoaArt( cCodArt, aGet, aTmp, aTmpFac, oFld, oSayPr1, oSayPr2, oSayVp1, oSayVp2, oBmp, oBrwPrp, oGetIra, oDlg, oStkAct, oSayLote, oBeneficioSobre, oTotal, nMode ) );
         BITMAP   "LUPA" ;
         ON HELP  ( BrwArticulo( aGet[ _CREF ], aGet[ _CDETALLE ] ) ) ;
         OF       oFld:aDialogs[1]

      /*
      Lotes
      ------------------------------------------------------
      */

     REDEFINE SAY oSayLote;
         ID       111 ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CLOTE ] VAR aTmp[ _CLOTE ];
         ID       112 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

      aGet[ _CLOTE ]:bValid   := {|| oStock:nPutStockActual( aTmp[ _CREF ], aTmp[ _CALMLIN ], aTmp[ _CVALPR1 ], aTmp[ _CVALPR2 ], aTmp[ _CLOTE ], aTmp[ _LKITART ], aTmp[ _NCTLSTK ], oStkAct ), .t. }

      REDEFINE GET aGet[ _DFECCAD ] VAR aTmp[ _DFECCAD ];
         ID       113 ;
         IDSAY    114 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[_CDETALLE] VAR aTmp[_CDETALLE] ;
         ID       120 ;
         WHEN     ( ( lModDes() .or. Empty( aTmp[ _CDETALLE ] ) ) .AND. nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[_MLNGDES] VAR aTmp[_MLNGDES] ;
         MEMO ;
         ID       121 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _NIVA ] VAR aTmp[ _NIVA ] ;
         ID       130 ;
         WHEN     ( lModIva() .and. nMode != ZOOM_MODE ) ;
         PICTURE  "@E 99.99" ;
         ON CHANGE( lCalcDeta( aTmp, aTmpFac, aGet, oTotal ) );
         VALID    ( if( lTiva( dbfIva, aTmp[ _NIVA ], @aTmp[ _NREQ ] ), ( aGet[ _NIVALIN ]:cText( aTmp[ _NIVA ] ), .t. ), .f. ) );
         BITMAP   "LUPA" ;
         ON HELP  ( BrwIva( aGet[ _NIVA ], dbfIva, , .t. ) ) ;
         OF       oFld:aDialogs[1]

      /*
      Propiedades
      -------------------------------------------------------------------------
      */

      REDEFINE GET aGet[ _CVALPR1 ] VAR aTmp[ _CVALPR1 ];
         ID       220 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         BITMAP   "LUPA" ;
         VALID    ( if( lPrpAct( aGet[ _CVALPR1 ], oSayVp1, aTmp[ _CCODPR1 ], dbfTblPro ),;
                        LoaArt( cCodArt, aGet, aTmp, aTmpFac, oFld, oSayPr1, oSayPr2, oSayVp1, oSayVp2, oBmp, oBrwPrp, oGetIra, oDlg, oStkAct, oSayLote, oBeneficioSobre, oTotal, nMode ),;
                        .f. ) ) ;
         ON HELP  ( brwPrpAct( aGet[ _CVALPR1 ], oSayVp1, aTmp[ _CCODPR1 ] ) ) ;
         OF       oFld:aDialogs[1]

         aGet[ _CVALPR1 ]:bChange   := {|| aGet[ _CVALPR1 ]:Assign(), oStock:nPutStockActual( aTmp[ _CREF ], aTmp[ _CALMLIN ], aTmp[ _CVALPR1 ], aTmp[ _CVALPR2 ], aTmp[ _CLOTE ], aTmp[ _LKITART ], aTmp[ _NCTLSTK ], oStkAct ) }

      REDEFINE SAY oSayPr1 VAR cSayPr1;
         ID       221 ;
         OF       oFld:aDialogs[1]

      REDEFINE GET oSayVp1 VAR cSayVp1;
         ID       222 ;
         WHEN     .f. ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CVALPR2 ] VAR aTmp[ _CVALPR2 ];
         ID       230 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         BITMAP   "LUPA" ;
         VALID    ( if( lPrpAct( aGet[ _CVALPR2 ], oSayVp2, aTmp[ _CCODPR2 ], dbfTblPro ),;
                        LoaArt( cCodArt, aGet, aTmp, aTmpFac, oFld, oSayPr1, oSayPr2, oSayVp1, oSayVp2, oBmp, oBrwPrp, oGetIra, oDlg, oStkAct, oSayLote, oBeneficioSobre, oTotal, nMode ),;
                        .f. ) ) ;
         ON HELP  ( brwPrpAct( aGet[ _CVALPR2 ], oSayVp2, aTmp[ _CCODPR2 ] ) ) ;
         OF       oFld:aDialogs[1]

         aGet[ _CVALPR2 ]:bChange   := {|| aGet[ _CVALPR2 ]:Assign(), oStock:nPutStockActual( aTmp[ _CREF ], aTmp[ _CALMLIN ], aTmp[ _CVALPR1 ], aTmp[ _CVALPR2 ], aTmp[ _CLOTE ], aTmp[ _LKITART ], aTmp[ _NCTLSTK ], oStkAct ) }

      REDEFINE SAY oSayPr2 VAR cSayPr2;
         ID       231 ;
         OF       oFld:aDialogs[1]

      REDEFINE GET oSayVp2 VAR cSayVp2;
         ID       232 ;
         WHEN     .f. ;
         COLOR    CLR_GET ;
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

      REDEFINE GET aGet[_CUNIDAD] VAR aTmp[_CUNIDAD] ;
         ID       152 ;
         IDTEXT   153 ;
         BITMAP   "LUPA" ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( oUndMedicion:Existe( aGet[ _CUNIDAD ], aGet[ _CUNIDAD ]:oHelpText, "cNombre" ), ValidaMedicion( aTmp, aGet) );
         ON HELP  ( oUndMedicion:Buscar( aGet[ _CUNIDAD ] ), ValidaMedicion( aTmp, aGet ) ) ;
         OF       oFld:aDialogs[1]

      // Campos de las descripciones de la unidad de medición

      REDEFINE GET aGet[ ( dbfFacPrvL )->( fieldpos( "nMedUno" ) ) ] ;
         VAR      aTmp[ ( dbfFacPrvL )->( fieldpos( "nMedUno" ) ) ] ;
         ID       420 ;
         IDSAY    421 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ON CHANGE( lCalcDeta( aTmp, aTmpFac, aGet, oTotal ) );
         PICTURE  MasUnd() ;
         OF       oFld:aDialogs[1]

      aGet[ ( dbfFacPrvL )->( fieldpos( "nMedUno" ) ) ]:oSay:SetColor( CLR_BLUE )

      REDEFINE GET aGet[ ( dbfFacPrvL )->( fieldpos( "nMedDos" ) ) ] ;
         VAR      aTmp[ ( dbfFacPrvL )->( fieldpos( "nMedDos" ) ) ] ;
         ID       430 ;
         IDSAY    431 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ON CHANGE( lCalcDeta( aTmp, aTmpFac, aGet, oTotal ) );
         PICTURE  MasUnd() ;
         OF       oFld:aDialogs[1]

      aGet[ ( dbfFacPrvL )->( fieldpos( "nMedDos" ) ) ]:oSay:SetColor( CLR_BLUE )

      REDEFINE GET aGet[ ( dbfFacPrvL )->( fieldpos( "nMedTre" ) ) ] ;
         VAR      aTmp[ ( dbfFacPrvL )->( fieldpos( "nMedTre" ) ) ] ;
         ID       440 ;
         IDSAY    441 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ON CHANGE( lCalcDeta( aTmp, aTmpFac, aGet, oTotal ) );
         PICTURE  MasUnd() ;
         OF       oFld:aDialogs[1]

      aGet[ ( dbfFacPrvL )->( fieldpos( "nMedTre" ) ) ]:oSay:SetColor( CLR_BLUE )

      REDEFINE GET aGet[_NCANENT] VAR aTmp[_NCANENT] ;
         ID       140 ;
         WHEN     ( lUseCaj() .AND. nMode != ZOOM_MODE ) ;
         VALID    ( lCalcDeta( aTmp, aTmpFac, aGet, oTotal ) );
         ON CHANGE( lCalcDeta( aTmp, aTmpFac, aGet, oTotal ) );
         SPINNER ;
         PICTURE  cPicUnd ;
         OF       oFld:aDialogs[1] ;
         IDSAY    141

      REDEFINE GET aGet[_NUNICAJA] VAR aTmp[_NUNICAJA] ;
         ID       150 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( lCalcDeta( aTmp, aTmpFac, aGet, oTotal ) );
         ON CHANGE( lCalcDeta( aTmp, aTmpFac, aGet, oTotal ) );
         SPINNER ;
         PICTURE  cPicUnd;
         OF       oFld:aDialogs[1] ;
         IDSAY    151

      REDEFINE GET aGet[_NPREUNIT] VAR aTmp[_NPREUNIT] ;
         SPINNER ;
         ID       160 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( lCalcDeta( aTmp, aTmpFac, aGet, oTotal ) );
         ON CHANGE( lCalcDeta( aTmp, aTmpFac, aGet, oTotal ) );
         COLOR    CLR_GET ;
         PICTURE  cPinDiv ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _NDTOLIN ] VAR aTmp[ _NDTOLIN ] ;
         ID       180 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( lCalcDeta( aTmp, aTmpFac, aGet, oTotal ) );
         ON CHANGE( lCalcDeta( aTmp, aTmpFac, aGet, oTotal ) );
         COLOR    CLR_GET ;
         SPINNER ;
         PICTURE  "@E 999.99" ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _NDTOPRM ] VAR aTmp[ _NDTOPRM ] ;
         ID       250 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( lCalcDeta( aTmp, aTmpFac, aGet, oTotal ) );
         ON CHANGE( lCalcDeta( aTmp, aTmpFac, aGet, oTotal ) );
         COLOR    CLR_GET ;
         SPINNER ;
         PICTURE  "@E 99.99" ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[_NDTORAP] VAR aTmp[_NDTORAP] ;
         ID       260 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         SPINNER ;
         PICTURE  "@E 99.99" ;
         COLOR    CLR_GET ;
         OF       oFld:aDialogs[1]

      REDEFINE CHECKBOX aGet[ _LGASSUP ] VAR aTmp[ _LGASSUP ] ;
         ID       460;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

      aGet[ _LGASSUP ]:bChange   := {|| if( aTmp[ _LGASSUP ], ( aGet[ _NIVA ]:cText( 0 ), aGet[ _NIVA ]:HardDisable() ), ( aGet[ _NIVA ]:HardEnable() ) ) }

      REDEFINE GET oStkAct VAR nStkAct ;
         ID       190 ;
         WHEN     ( .f. );
         PICTURE  MasUnd() ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CREFPRV ] VAR aTmp[ _CREFPRV ];
         ID       400 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET oTotal VAR nTotal ;
         ID       210 ;
         PICTURE  cPirDiv ;
         WHEN     .F. ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[_CALMLIN] VAR aTmp[_CALMLIN]  ;
         ID       240 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( cNomUbica( aTmp, aGet, dbfAlm ), cAlmacen( aGet[_CALMLIN], dbfAlm, oSay2 ), oStock:lPutStockActual( aTmp[ _CREF ], aTmp[ _CALMLIN ], aTmp[ _CVALPR1 ], aTmp[ _CVALPR2 ], aTmp[ _CLOTE ], aTmp[ _LKITART ], aTmp[ _NCTLSTK ], oStkAct ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwAlmacen( Self, oSay2 ) ) ;
         COLOR    CLR_GET ;
         OF       oFld:aDialogs[1]

      REDEFINE GET oSay2 VAR cSay2 ;
         WHEN     .F. ;
         ID       241 ;
         OF       oFld:aDialogs[1]

      REDEFINE SAY aGet[_CCODUBI1] VAR aTmp[_CCODUBI1];
         ID       300 ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[_CVALUBI1] VAR aTmp[_CVALUBI1] ;
         ID       270 ;
         BITMAP   "LUPA" ;
         WHEN     ( nMode != ZOOM_MODE ) ;
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
         WHEN     ( nMode != ZOOM_MODE ) ;
         ON HELP  ( BrwUbiLin( aGet[_CVALUBI3], aGet[_CNOMUBI3], aTmp[_CCODUBI3], dbfUbicaL ) ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[_CNOMUBI3] VAR aTmp[_CNOMUBI3];
         WHEN     .F. ;
         ID       291 ;
         OF       oFld:aDialogs[1]

      REDEFINE GET oGetIra VAR cGetIra;
         ID       410 ;
         IDSAY    411 ;
         BITMAP   "Lupa" ;
         ON HELP  ( SearchProperty( oGetIra, oBrwPrp ) ) ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

      /*
      Segunda caja de dialogo_________________________________________________
      */

      REDEFINE GET aGet[ _NIVALIN ] VAR aTmp[ _NIVALIN ] ;
         ID       80 ;
         WHEN     .F. ;
         PICTURE  "@E 999.99" ;
         OF       oFld:aDialogs[2]

      REDEFINE CHECKBOX aGet[ _LIVALIN ] VAR aTmp[ _LIVALIN ] ;
         ID       90 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[2]

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
            PICTURE  cPorDiv ;
            OF       oFld:aDialogs[ 2 ]

      REDEFINE GET   aGet[ _NIVALIN1 ] ;
            VAR      aTmp[ _NIVALIN1 ] ;
            ID       540 ;
            ON CHANGE( ::lValid() ) ;
            WHEN     ( aTmp[ _LIVALIN ] .and. nMode != ZOOM_MODE ) ;
            VALID    ( CalBnfIva( oBeneficioSobre[ 1 ]:nAt <= 1, aTmp[ _LIVALIN ], aTmp[ _NPRECOM ], aTmp[ _NIVALIN1 ], aGet[ _NBNFLIN1 ], aTmp[ _NIVA ], aGet[ _NPVPLIN1 ], nDinDiv ) );
            PICTURE  cPorDiv ;
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
            PICTURE  cPorDiv ;
            OF       oFld:aDialogs[ 2 ]

      REDEFINE GET   aGet[ _NIVALIN2 ] ;
            VAR      aTmp[ _NIVALIN2 ] ;
            ID       590 ;
            ON CHANGE( ::lValid() ) ;
            WHEN     ( aTmp[ _LIVALIN ] .and. nMode != ZOOM_MODE ) ;
            VALID    ( CalBnfIva( oBeneficioSobre[ 2 ]:nAt <= 1, aTmp[ _LIVALIN ], aTmp[ _NPRECOM ], aTmp[ _NIVALIN2 ], aGet[ _NBNFLIN2 ], aTmp[ _NIVA ], aGet[ _NPVPLIN2 ], nDinDiv ) );
            PICTURE  cPorDiv ;
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
            PICTURE  cPorDiv ;
            OF       oFld:aDialogs[ 2 ]

      REDEFINE GET   aGet[ _NIVALIN3 ] ;
            VAR      aTmp[ _NIVALIN3 ] ;
            ID       640 ;
            ON CHANGE( ::lValid() ) ;
            WHEN     ( aTmp[ _LIVALIN ] .and. nMode != ZOOM_MODE ) ;
            VALID    ( CalBnfIva( oBeneficioSobre[ 3 ]:nAt <= 1, aTmp[ _LIVALIN ], aTmp[ _NPRECOM ], aTmp[ _NIVALIN3 ], aGet[ _NBNFLIN3 ], aTmp[ _NIVA ], aGet[ _NPVPLIN3 ], nDinDiv ) );
            PICTURE  cPorDiv ;
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
            PICTURE  cPorDiv ;
            OF       oFld:aDialogs[ 2 ]

      REDEFINE GET   aGet[ _NIVALIN4 ] ;
            VAR      aTmp[ _NIVALIN4 ] ;
            ID       690 ;
            ON CHANGE( ::lValid() ) ;
            WHEN     ( aTmp[ _LIVALIN ] .and. nMode != ZOOM_MODE ) ;
            VALID    ( CalBnfIva( oBeneficioSobre[ 4 ]:nAt <= 1, aTmp[ _LIVALIN ], aTmp[ _NPRECOM ], aTmp[ _NIVALIN4 ], aGet[ _NBNFLIN4 ], aTmp[ _NIVA ], aGet[ _NPVPLIN4 ], nDinDiv ) );
            PICTURE  cPorDiv ;
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
            PICTURE  cPorDiv ;
            OF       oFld:aDialogs[ 2 ]

      REDEFINE GET   aGet[ _NIVALIN5 ] ;
            VAR      aTmp[ _NIVALIN5 ] ;
            ID       740 ;
            ON CHANGE( ::lValid() ) ;
            WHEN     ( aTmp[ _LIVALIN ] .and. nMode != ZOOM_MODE ) ;
            VALID    ( CalBnfIva( oBeneficioSobre[ 5 ]:nAt <= 1, aTmp[ _LIVALIN ], aTmp[ _NPRECOM ], aTmp[ _NIVALIN5 ], aGet[ _NBNFLIN5 ], aTmp[ _NIVA ], aGet[ _NPVPLIN5 ], nDinDiv ) );
            PICTURE  cPorDiv ;
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
            PICTURE  cPorDiv ;
            OF       oFld:aDialogs[ 2 ]

      REDEFINE GET   aGet[ _NIVALIN6 ] ;
            VAR      aTmp[ _NIVALIN6 ] ;
            ID       790 ;
            ON CHANGE( ::lValid() ) ;
            WHEN     ( aTmp[ _LIVALIN ] .and. nMode != ZOOM_MODE ) ;
            VALID    ( CalBnfIva( oBeneficioSobre[ 6 ]:nAt <= 1, aTmp[ _LIVALIN ], aTmp[ _NPRECOM ], aTmp[ _NIVALIN6 ], aGet[ _NBNFLIN6 ], aTmp[ _NIVA ], aGet[ _NPVPLIN6 ], nDinDiv ) );
            PICTURE  cPorDiv ;
            OF       oFld:aDialogs[ 2 ]

      REDEFINE CHECKBOX aGet[ _LCHGLIN ] VAR aTmp[ _LCHGLIN ];
         ID       420 ;
         WHEN     ( nMode != ZOOM_MODE .and. lActCos() );
         OF       oFld:aDialogs[2]

      /*
      Control de stock
      -------------------------------------------------------------------------
      */

      REDEFINE RADIO aGet[ _NCTLSTK ] ;
         VAR      aTmp[ _NCTLSTK ] ;
         ID       350, 351, 352 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[ 2 ]

      REDEFINE GET aGet[_MOBSLIN] VAR aTmp[_MOBSLIN] ;
         MEMO ;
         ID       100 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[3]

      REDEFINE BUTTON oBtn;
         ID       IDOK ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( SaveDeta( aTmp, aGet, oBrw, oDlg, nMode, oTotal, oFld, aTmpFac, oSayPr1, oSayPr2, oSayVp1, oSayVp2, oStkAct, oSayLote, oBrwPrp, oGetIra, oBtn ) )

      REDEFINE BUTTON ;
         ID       IDCANCEL ;
         OF       oDlg ;
         CANCEL ;
         ACTION   ( oDlg:end() )

      REDEFINE BUTTON ;
         ID       9 ;
         OF       oDlg ;
         ACTION   ( GoHelp() )

      REDEFINE BUTTON oBtnNumerosSerie ;
         ID       552 ;
         OF       oDlg ;
         ACTION   ( EditarNumerosSerie( aTmp, nMode ) )

   if nMode != ZOOM_MODE
      oDlg:AddFastKey( VK_F6, {|| oBtnNumerosSerie:Click() } )
      oDlg:AddFastKey( VK_F5, {|| oBtn:SetFocus(), oBtn:Click() } )
   end if

   oDlg:AddFastKey ( VK_F1, {|| GoHelp() } )

   oDlg:bStart    := {|| SetDlgMode( aGet, aTmp, oFld, aTmpFac, nMode, oSayPr1, oSayPr2, oSayVp1, oSayVp2, oSayLote, oTotal, oBrwPrp, oGetIra ),;
                         if( !Empty( cCodArtEnt ), aGet[ _CREF ]:lValid(), ) }

   ACTIVATE DIALOG oDlg ;
      ON INIT     ( EdtDetMenu( aGet[ _CREF ], oDlg ) );
      CENTER

   EndDetMenu()

RETURN ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

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

//--------------------------------------------------------------------------//

STATIC FUNCTION SetDlgMode( aGet, aTmp, oFld, aTmpFac, nMode, oSayPr1, oSayPr2, oSayVp1, oSayVp2, oSayLote, oTotal, oBrwPrp, oGetIra )

   local cCodArt        := Left( aGet[ _CREF ]:VarGet(), 18 )

   if !lUseCaj()
      aGet[ _NCANENT ]:Hide()
   else
      aGet[ _NCANENT ]:SetText( cNombreCajas() )
   end if

   aGet[ _NUNICAJA ]:SetText( cNombreUnidades() )

   oBrwPrp:Hide()
   oGetIra:Hide()

   oSayPr1:SetText( "" )
   oSayVp1:SetText( "" )

   oSayPr2:SetText( "" )
   oSayVp2:SetText( "" )

   /*
   Colocamos nuevamente los folders
   */

   oFld:aEnable   := { .t., !Empty( aTmp[ _CREF ] ), .t. }
   oFld:SetOption( 1 )

   do case
   case nMode == APPD_MODE

      aGet[ _CREF    ]:Show()
      aGet[ _CREF    ]:cText( Space( 200 ) )

      aGet[ _CDETALLE]:Show()
      aGet[ _MLNGDES ]:Hide()
      aGet[ _CLOTE   ]:Hide()
      aGet[ _DFECCAD ]:Hide()
      aGet[ _NCANENT ]:cText( 1 )
      aGet[ _NUNICAJA]:cText( 1 )
      aGet[ _CALMLIN ]:cText( aTmpFac[ _CCODALM ] )

      aGet[ _NIVA    ]:cText( nIva( dbfIva, cDefIva() ) )
      aGet[ _NIVALIN ]:cText( nIva( dbfIva, cDefIva() ) )

      aTmp[ _NREQ    ]  := nReq( dbfIva, cDefIva() )
      aTmp[ _NNUMLIN ]  := nLastNum( dbfTmp )

      oSayLote:Hide()

   case nMode != APPD_MODE .AND. empty( cCodArt )

      aGet[ _CREF    ]:Hide()
      aGet[ _CDETALLE]:Hide()
      aGet[ _MLNGDES ]:Show()
      aGet[ _CLOTE   ]:Hide()
      aGet[ _DFECCAD ]:Hide()
 
      oSayLote:Hide()

   case nMode != APPD_MODE .AND. !empty( cCodArt )

      aGet[ _CREF    ]:Show()
      aGet[ _CDETALLE]:Show()
      aGet[ _MLNGDES ]:Hide()

      if aTmp[ _LLOTE   ]
         aGet[ _CLOTE   ]:Show()
         aGet[ _DFECFAC ]:Show()
         oSayLote:Show()
      else
         aGet[ _CLOTE   ]:Hide()
         aGet[ _DFECCAD ]:Hide()
         oSayLote:Hide()
      end if

   end case

   lCalcDeta( aTmp, aTmpFac, aGet, oTotal )

   if !Empty( aTmp[ _CCODPR1 ] )
      aGet[ _CVALPR1 ]:Show()
      aGet[ _CVALPR1 ]:lValid()
      oSayPr1:Show()
      oSayVp1:Show()
      oSayPr1:SetText( retProp( aTmp[_CCODPR1], dbfPro ) )
   else
      aGet[ _CVALPR1 ]:Hide()
      oSayPr1:Hide()
      oSayVp1:Hide()
   end if

   if !Empty( aTmp[ _CCODPR2 ] )
      aGet[ _CVALPR2 ]:Show()
      aGet[ _CVALPR2 ]:lValid()
      oSayPr2:Show()
      oSayVp2:Show()
      oSayPr2:SetText( retProp(  aTmp[_CCODPR2], dbfPro ) )
   else
      aGet[ _CVALPR2 ]:Hide()
      oSayPr2:Hide()
      oSayVp2:Hide()
   end if

   /*
   Ocultamos las tres unidades de medicion-------------------------------------
   */

   aGet[ ( dbfFacPrvL )->( fieldpos( "nMedUno" ) ) ]:Hide()
   aGet[ ( dbfFacPrvL )->( fieldpos( "nMedDos" ) ) ]:Hide()
   aGet[ ( dbfFacPrvL )->( fieldpos( "nMedTre" ) ) ]:Hide()

   if oUndMedicion:oDbf:Seek(  aTmp[ _CUNIDAD ] )

      if oUndMedicion:oDbf:nDimension >= 1 .and. !Empty( oUndMedicion:oDbf:cTextoDim1 )
         aGet[ ( dbfFacPrvL )->( fieldpos( "nMedUno" ) ) ]:oSay:SetText( oUndMedicion:oDbf:cTextoDim1 )
         aGet[ ( dbfFacPrvL )->( fieldpos( "nMedUno" ) ) ]:Show()
      end if

      if oUndMedicion:oDbf:nDimension >= 2 .and. !Empty( oUndMedicion:oDbf:cTextoDim2 )
         aGet[ ( dbfFacPrvL )->( fieldpos( "nMedDos" ) ) ]:oSay:SetText( oUndMedicion:oDbf:cTextoDim2 )
         aGet[ ( dbfFacPrvL )->( fieldpos( "nMedDos" ) ) ]:Show()
      end if

      if oUndMedicion:oDbf:nDimension >= 3 .and. !Empty( oUndMedicion:oDbf:cTextoDim3 )
         aGet[ ( dbfFacPrvL )->( fieldpos( "nMedTre" ) ) ]:oSay:SetText( oUndMedicion:oDbf:cTextoDim3 )
         aGet[ ( dbfFacPrvL )->( fieldpos( "nMedTre" ) ) ]:Show()
      end if

   end if

   aGet[ _CALMLIN ]:lValid()
   aGet[ _CREF    ]:SetFocus()

Return Nil

//--------------------------------------------------------------------------//

STATIC FUNCTION SaveDeta( aTmp, aGet, oBrw, oDlg2, nMode, oTotal, oFld, aTmpFac, oSayPr1, oSayPr2, oSayVp1, oSayVp2, oStkAct, oSayLote, oBrwPrp, oGetIra, oBtn )

   local n
   local i

   oBtn:SetFocus()

   if !aGet[ _CREF ]:lValid()
      Return nil
   end if

   if Empty( aTmp[ _CREF ] ) .and. lRetCodArt()
      MsgStop( "No se pueden añadir lineas sin codificar" )
      Return .f.
   end if

   if !lMoreIva( aTmp[_NIVA] )
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
   Grabamos el registro--------------------------------------------------------
   */

   cOldCodArt     := ""
   cOldUndMed     := ""

   if nMode == APPD_MODE

      if aTmp[ _LLOTE ]
         GraLotArt( aTmp[ _CREF ], dbfArticulo, aTmp[ _CLOTE ] )
      end if

      if !Empty( oBrwPrp:Cargo )

         for n := 1 to len( oBrwPrp:Cargo )

            for i := 1 to len( oBrwPrp:Cargo[ n ] )

               if IsNum( oBrwPrp:Cargo[ n, i ]:Value ) .and. oBrwPrp:Cargo[ n, i ]:Value != 0 //  .and.

                  aTmp[ _NUNICAJA]  := oBrwPrp:Cargo[ n, i ]:Value
                  aTmp[ _CCODPR1 ]  := oBrwPrp:Cargo[ n, i ]:cCodigoPropiedad1
                  aTmp[ _CVALPR1 ]  := oBrwPrp:Cargo[ n, i ]:cValorPropiedad1
                  aTmp[ _CCODPR2 ]  := oBrwPrp:Cargo[ n, i ]:cCodigoPropiedad2
                  aTmp[ _CVALPR2 ]  := oBrwPrp:Cargo[ n, i ]:cValorPropiedad2
                  aTmp[ _NPREUNIT]  := oBrwPrp:Cargo[ n, i ]:nPrecioCompra

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
         RecalculaTotal( aTmpFac )
         SetDlgMode( aGet, aTmp, oFld, aTmpFac, nMode, oSayPr1, oSayPr2, oSayVp1, oSayVp2, oSayLote, oTotal, oBrwPrp, oGetIra )
      else
         oDlg2:End( IDOK )
      end if

   else

      WinGather( aTmp, aGet, dbfTmp, oBrw, nMode )

      oDlg2:end( IDOK )

   end if

   if !Empty( aGet[ _CUNIDAD ] )
      aGet[ _CUNIDAD ]:lValid()
   end if

   if !Empty( oBrwPrp )
      oBrwPrp:Cargo                 := nil
   end if

RETURN NIL

//--------------------------------------------------------------------------//

/*
Funcion Auxiliar para A¤adir lineas de detalle a una Factura
*/

STATIC FUNCTION AppDeta( oBrwLin, bEdtDet, aTmp, cCodArt )

   /*
   if !Empty( aNumAlb ) .or. aTmp[ _LIMPALB ]
      MsgStop( "No se pueden modificar registros a una factura que" + CRLF + ;
               "proviene de albaranes." )
      return .f.
   end if
   */

   if lRecibosPagadosTmp( dbfTmpPgo )
      MsgStop( "No se pueden modificar registros de una factura con pagos" )
      return .f.
   end if

   WinAppRec( oBrwLin, bEdtDet, dbfTmp, aTmp, cCodArt )

RETURN ( RecalculaTotal( aTmp ) )

//---------------------------------------------------------------------------//

/*
Funcion Auxiliar para la Edici¢n de Lineas de Detalle en una Factura
*/

STATIC FUNCTION EdtDeta( oBrwLin, bEdtDet, aTmp, cLoop )

   if lRecibosPagadosTmp( dbfTmpPgo )
      MsgStop( "No se pueden modificar registros de una factura con pagos" )
      return .f.
   end if

   if !( dbfTmp )->lControl
      WinEdtRec( oBrwLin, bEdtDet, dbfTmp, aTmp )
   end if

RETURN ( RecalculaTotal( aTmp ) )

//--------------------------------------------------------------------------//
/*
Funcion Auxiliar para borrar las Lineas de Detalle en una Factura
*/

STATIC FUNCTION DelDeta()

   if lRecibosPagadosTmp( dbfTmpPgo )
      MsgStop( "No se pueden eliminar registros de una factura con pagos" )
      return .f.
   end if

   CursorWait()

   while ( dbfTmpSer )->( dbSeek( Str( ( dbfTmp )->nNumLin, 4 ) ) )
      ( dbfTmpSer )->( dbDelete() )
   end while

   if ( dbfTmp )->lKitArt
      dbDelKit( , dbfTmp, ( dbfTmp )->nNumLin )
   end if

   CursorWE()

RETURN ( .t. )

//--------------------------------------------------------------------------//

STATIC FUNCTION PrnSerie( oBrw )

   local oDlg
   local oFmtDoc
   local cFmtDoc     := cFormatoDocumento( ( TDataView():FacturasProveedores( nView ) )->cSerFac, "nFacPrv", dbfCount )
   local oSayFmt
   local cSayFmt
   local oSerIni
   local oSerFin   
   local cSerIni     := ( TDataView():FacturasProveedores( nView ) )->cSerFac
   local cSerFin     := ( TDataView():FacturasProveedores( nView ) )->cSerFac
   local nDocIni     := ( TDataView():FacturasProveedores( nView ) )->nNumFac
   local nDocFin     := ( TDataView():FacturasProveedores( nView ) )->nNumFac
   local cSufIni     := ( TDataView():FacturasProveedores( nView ) )->cSufFac
   local cSufFin     := ( TDataView():FacturasProveedores( nView ) )->cSufFac
   local oPrinter
   local cPrinter    := PrnGetName()
   local lCopiasPre  := .t.
   local lInvOrden   := .f.
   local oNumCop
   local nNumCop     := if( nCopiasDocumento( ( TDataView():FacturasProveedores( nView ) )->cSerFac, "nFacPrv", dbfCount ) == 0, Max( Retfld( ( TDataView():FacturasProveedores( nView ) )->cCodPrv, TDataView():Proveedores( nView ), "nCopiasF" ), 1 ), nCopiasDocumento( ( TDataView():FacturasProveedores( nView ) )->cSerFac, "nFacPrv", dbfCount ) )
   local oRango
   local nRango      := 1
   local dFecDesde   := CtoD( "01/01/" + Str( Year( Date() ) ) )
   local dFecHasta   := Date()

   if Empty( cFmtDoc )
      cFmtDoc        := cSelPrimerDoc( "FP" )
   end if

   cSayFmt           := cNombreDoc( cFmtDoc )

   DEFINE DIALOG oDlg RESOURCE "IMPSERIES" TITLE "Imprimir series de facturas"

   REDEFINE RADIO oRango VAR nRango ;
      ID       201, 202 ;
      OF       oDlg

   REDEFINE GET oSerIni VAR cSerIni ;
      ID       100 ;
      PICTURE  "@!" ;
      UPDATE ;
      SPINNER ;
      ON UP    ( UpSerie( oSerIni ) );
      ON DOWN  ( DwSerie( oSerIni ) );
      VALID    ( cSerIni >= "A" .AND. cSerIni <= "Z"  );
      WHEN     ( nRango == 1 );
      OF       oDlg

   REDEFINE GET oSerFin VAR cSerFin ;
      ID       110 ;
      PICTURE  "@!" ;
      UPDATE ;
      SPINNER ;
      ON UP    ( UpSerie( oSerFin ) );
      ON DOWN  ( DwSerie( oSerFin ) );
      VALID    ( cSerFin >= "A" .AND. cSerFin <= "Z"  );
      WHEN     ( nRango == 1 );
      OF       oDlg

   REDEFINE GET nDocIni;
      ID       120 ;
      PICTURE  "999999999" ;
      SPINNER ;
      WHEN     ( nRango == 1 );
      OF       oDlg

   REDEFINE GET nDocFin;
      ID       130 ;
      PICTURE  "999999999" ;
      SPINNER ;
      WHEN     ( nRango == 1 );
      OF       oDlg

   REDEFINE GET cSufIni ;
      ID       140 ;
      PICTURE  "##" ;
      WHEN     ( nRango == 1 );
      OF       oDlg

   REDEFINE GET cSufFin ;
      ID       150 ;
      PICTURE  "##" ;
      WHEN     ( nRango == 1 );
      OF       oDlg

   REDEFINE GET dFecDesde ;
      ID       210 ;
      WHEN     ( nRango == 2 ) ;
      SPINNER ;
      OF       oDlg

   REDEFINE GET dFecHasta ;
      ID       220 ;
      WHEN     ( nRango == 2 ) ;
      SPINNER ;
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
      PICTURE  "999999999" ;
      SPINNER ;
      MIN      1 ;
      MAX      99999 ;
      OF       oDlg

   REDEFINE GET oFmtDoc VAR cFmtDoc ;
      ID       90 ;
      COLOR    CLR_GET ;
      VALID    ( cDocumento( oFmtDoc, oSayFmt, dbfDoc ) ) ;
      BITMAP   "LUPA" ;
      ON HELP  ( BrwDocumento( oFmtDoc, oSayFmt, "FP" ) ) ;
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
      OF       oDlg ;
      ACTION   (  StartPrint( SubStr( cFmtDoc, 1, 3 ), cSerIni + Str( nDocIni, 9 ) + cSufIni, cSerFin + Str( nDocFin, 9 ) + cSufFin, oDlg, cPrinter, lCopiasPre, nNumCop, lInvOrden, nRango, dFecDesde, dFecHasta ),;
                  oDlg:end( IDOK ) )

   REDEFINE BUTTON ;
      ID       IDCANCEL ;
      OF       oDlg ;
      CANCEL ;
      ACTION   ( oDlg:end() )

   oDlg:AddFastKey( VK_F5, {|| StartPrint( SubStr( cFmtDoc, 1, 3 ), cSerIni + Str( nDocIni, 9 ) + cSufIni, cSerFin + Str( nDocFin, 9 ) + cSufFin, oDlg, cPrinter, lCopiasPre, nNumCop, lInvOrden, nRango, dFecDesde, dFecHasta ), oDlg:end( IDOK ) } )

   oDlg:bStart := { || oSerIni:SetFocus() }

   ACTIVATE DIALOG oDlg CENTER
   
   oBrw:refresh()

RETURN NIL

//--------------------------------------------------------------------------//

STATIC FUNCTION StartPrint( cFmtDoc, cDocIni, cDocFin, oDlg, cPrinter, lCopiasPre, nNumCop, lInvOrden, nRango, dFecDesde, dFecHasta )

   local nCopyProvee
   local nRecno
   local nOrdAnt

   oDlg:disable()

   if nRango == 1

      nRecno      := ( TDataView():FacturasProveedores( nView ) )->( Recno() )
      nOrdAnt     := ( TDataView():FacturasProveedores( nView ) )->( OrdSetFocus( "NNUMFAC" ) )

      if !lInvOrden

         ( TDataView():FacturasProveedores( nView ) )->( dbSeek( cDocIni, .t. ) )

         while ( TDataView():FacturasProveedores( nView ) )->cSerFac + Str( ( TDataView():FacturasProveedores( nView ) )->nNumFac ) + (TDataView():FacturasProveedores( nView ))->cSufFac >= cDocIni .AND. ;
               ( TDataView():FacturasProveedores( nView ) )->cSerFac + Str( ( TDataView():FacturasProveedores( nView ) )->nNumFac ) + (TDataView():FacturasProveedores( nView ))->cSufFac <= cDocFin

               lChgImpDoc( TDataView():FacturasProveedores( nView ) )

            if lCopiasPre

               nCopyProvee    := if( nCopiasDocumento( ( TDataView():FacturasProveedores( nView ) )->cSerFac, "nFacPrv", dbfCount ) == 0, Max( Retfld( ( TDataView():FacturasProveedores( nView ) )->cCodPrv, TDataView():Proveedores( nView ), "nCopiasF" ), 1 ), nCopiasDocumento( ( TDataView():FacturasProveedores( nView ) )->cSerFac, "nFacPrv", dbfCount ) )

               GenFacPrv( IS_PRINTER, "Imprimiendo documento : " + ( TDataView():FacturasProveedores( nView ) )->cSerFac + Str( ( TDataView():FacturasProveedores( nView ) )->nNumFac ) + (TDataView():FacturasProveedores( nView ))->cSufFac, cFmtDoc, cPrinter, nCopyProvee )

            else

               GenFacPrv( IS_PRINTER, "Imprimiendo documento : " + ( TDataView():FacturasProveedores( nView ) )->cSerFac + Str( ( TDataView():FacturasProveedores( nView ) )->nNumFac ) + (TDataView():FacturasProveedores( nView ))->cSufFac, cFmtDoc, cPrinter, nNumCop )

            end if

         (TDataView():FacturasProveedores( nView ))->( dbSkip() )

         end while

      else

         ( TDataView():FacturasProveedores( nView ) )->( dbSeek( cDocFin ) )

         while ( TDataView():FacturasProveedores( nView ) )->cSerFac + Str( ( TDataView():FacturasProveedores( nView ) )->nNumFac ) + ( TDataView():FacturasProveedores( nView ) )->cSufFac >= cDocIni .and. ;
               ( TDataView():FacturasProveedores( nView ) )->cSerFac + Str( ( TDataView():FacturasProveedores( nView ) )->nNumFac ) + ( TDataView():FacturasProveedores( nView ) )->cSufFac <= cDocFin .and.;
               !( TDataView():FacturasProveedores( nView ) )->( Bof() )

               lChgImpDoc( TDataView():FacturasProveedores( nView ) )

            if lCopiasPre

               nCopyProvee    := if( nCopiasDocumento( ( TDataView():FacturasProveedores( nView ) )->cSerFac, "nFacPrv", dbfCount ) == 0, Max( Retfld( ( TDataView():FacturasProveedores( nView ) )->cCodPrv, TDataView():Proveedores( nView ), "nCopiasF" ), 1 ), nCopiasDocumento( ( TDataView():FacturasProveedores( nView ) )->cSerFac, "nFacPrv", dbfCount ) )

               GenFacPrv( IS_PRINTER, "Imprimiendo documento : " + ( TDataView():FacturasProveedores( nView ) )->cSerFac + Str( ( TDataView():FacturasProveedores( nView ) )->nNumFac ) + (TDataView():FacturasProveedores( nView ))->cSufFac, cFmtDoc, cPrinter, nCopyProvee )

            else

               GenFacPrv( IS_PRINTER, "Imprimiendo documento : " + ( TDataView():FacturasProveedores( nView ) )->cSerFac + Str( ( TDataView():FacturasProveedores( nView ) )->nNumFac ) + (TDataView():FacturasProveedores( nView ))->cSufFac, cFmtDoc, cPrinter, nNumCop )

            end if

         ( TDataView():FacturasProveedores( nView ) )->( dbSkip( -1 ) )

         end while

      end if

   else
   
   nRecno      := ( TDataView():FacturasProveedores( nView ) )->( Recno() )
   nOrdAnt     := ( TDataView():FacturasProveedores( nView ) )->( OrdSetFocus( "DFECFAC" ) )

      if !lInvOrden

         ( TDataView():FacturasProveedores( nView ) )->( dbGoTop() )

         while !( TDataView():FacturasProveedores( nView ) )->( Eof() )

            if ( TDataView():FacturasProveedores( nView ) )->dFecFac >= dFecDesde .and. ( TDataView():FacturasProveedores( nView ) )->dFecFac <= dFecHasta

               lChgImpDoc( TDataView():FacturasProveedores( nView ) ) 

               if lCopiasPre

                  nCopyProvee    := if( nCopiasDocumento( ( TDataView():FacturasProveedores( nView ) )->cSerFac, "nFacPrv", dbfCount ) == 0, Max( Retfld( ( TDataView():FacturasProveedores( nView ) )->cCodPrv, TDataView():Proveedores( nView ), "nCopiasF" ), 1 ), nCopiasDocumento( ( TDataView():FacturasProveedores( nView ) )->cSerFac, "nFacPrv", dbfCount ) )

                  GenFacPrv( IS_PRINTER, "Imprimiendo documento : " + ( TDataView():FacturasProveedores( nView ) )->cSerFac + Str( ( TDataView():FacturasProveedores( nView ) )->nNumFac ) + (TDataView():FacturasProveedores( nView ))->cSufFac, cFmtDoc, cPrinter, nCopyProvee )

               else

                  GenFacPrv( IS_PRINTER, "Imprimiendo documento : " + ( TDataView():FacturasProveedores( nView ) )->cSerFac + Str( ( TDataView():FacturasProveedores( nView ) )->nNumFac ) + (TDataView():FacturasProveedores( nView ))->cSufFac, cFmtDoc, cPrinter, nNumCop )

               end if

            end if   

         (TDataView():FacturasProveedores( nView ))->( dbSkip() )

         end while

      else

         ( TDataView():FacturasProveedores( nView ) )->( dbGoBottom() )

         while !( TDataView():FacturasProveedores( nView ) )->( Bof() )

            if ( TDataView():FacturasProveedores( nView ) )->dFecFac >= dFecDesde .and. ( TDataView():FacturasProveedores( nView ) )->dFecFac <= dFecHasta

               lChgImpDoc( TDataView():FacturasProveedores( nView ) )

               if lCopiasPre

                  nCopyProvee    := if( nCopiasDocumento( ( TDataView():FacturasProveedores( nView ) )->cSerFac, "nFacPrv", dbfCount ) == 0, Max( Retfld( ( TDataView():FacturasProveedores( nView ) )->cCodPrv, TDataView():Proveedores( nView ), "nCopiasF" ), 1 ), nCopiasDocumento( ( TDataView():FacturasProveedores( nView ) )->cSerFac, "nFacPrv", dbfCount ) )

                  GenFacPrv( IS_PRINTER, "Imprimiendo documento : " + ( TDataView():FacturasProveedores( nView ) )->cSerFac + Str( ( TDataView():FacturasProveedores( nView ) )->nNumFac ) + (TDataView():FacturasProveedores( nView ))->cSufFac, cFmtDoc, cPrinter, nCopyProvee )

               else

                  GenFacPrv( IS_PRINTER, "Imprimiendo documento : " + ( TDataView():FacturasProveedores( nView ) )->cSerFac + Str( ( TDataView():FacturasProveedores( nView ) )->nNumFac ) + (TDataView():FacturasProveedores( nView ))->cSufFac, cFmtDoc, cPrinter, nNumCop )

               end if

            end if   

         ( TDataView():FacturasProveedores( nView ) )->( dbSkip( -1 ) )

         end while

      end if

   end if   

   ( TDataView():FacturasProveedores( nView ) )->( ordSetFocus( nOrdAnt ) )
   ( TDataView():FacturasProveedores( nView ) )->( dbGoTo( nRecNo ) )

   oDlg:enable()

RETURN NIL

//--------------------------------------------------------------------------//

/*
Calcula totales en las lineas de Detalle
*/

STATIC FUNCTION lCalcDeta( aTmp, aTmpFac, aGet, oTotal )

   oTotal:cText( nTotLFacPrv( aTmp, nDinDiv, nRinDiv ) )

   /*
   Situacion posterior---------------------------------------------------------
   */

   aGet[ _NPRECOM ]:cText( nNetUFacPrv( aTmp, aTmpFac, nDinDiv, nRinDiv, aTmpFac[ _NVDVFAC ] ) )

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

      if aTmp[ _NPREUNIT ] != 0
         aGet[ _LCHGLIN ]:Click( .t. ):Refresh()
      else
         aGet[ _LCHGLIN ]:Click( .f. ):Refresh()
      end if

   end if

RETURN .T.

//---------------------------------------------------------------------------//

Static Function RecalculaTotal( aTmp )

   nTotFacPrv( nil, TDataView():FacturasProveedores( nView ), dbfTmp, dbfIva, dbfDiv, dbfTmpPgo, aTmp )

   if oBrwIva != nil
      oBrwIva:refresh()
   end if

   if oGetNet != nil
      oGetNet:SetText( Trans( nTotNet, cPirDiv ) )
   end if

   if oGetIva != nil
      oGetIva:SetText( Trans( nTotIva, cPirDiv ) )
   end if

   if oGetReq != nil
      oGetReq:SetText( Trans( nTotReq, cPirDiv ) )
   end if

   if oGetTotal != nil
      oGetTotal:SetText( Trans( nTotFac, cPirDiv ) )
   end if

   if oGetRet != nil
      oGetRet:SetText( Trans( nTotRet, cPirDiv ) )
   end if

   if oGetTotPg != nil
      oGetTotPg:SetText( Trans( nTotFac, cPirDiv ) )
   end if

   if oGetPgd != nil
      oGetPgd:SetText( Trans( nPagFac, cPirDiv ) )
   end if

   if oGetPdt != nil
      oGetPdt:SetText( Trans( nTotFac - nPagFac, cPirDiv ) )
   end if

Return .t.

//---------------------------------------------------------------------------//

Static Function nGenFacPrv( nDevice, cCaption, cCodDoc, cPrinter, nCopies )

   local nFac

   CursorWait()

   for each nFac in ( oWndBrw:oBrw:aSelected )

      ( TDataView():FacturasProveedores( nView ) )->( dbGoTo( nFac ) )

      GenFacPrv( nDevice, cCaption, cCodDoc, cPrinter, nCopies )

   next

   CursorWE()

Return ( nil )

//----------------------------------------------------------------------------//

Static Function GenFacPrv( nDevice, cCaption, cCodDoc, cPrinter, nCopies )

   local oDevice
   local nFactura

   if ( TDataView():FacturasProveedores( nView ) )->( Lastrec() ) == 0
      Return nil
   end if

   nFactura             := ( TDataView():FacturasProveedores( nView ) )->cSerFac + Str( ( TDataView():FacturasProveedores( nView ) )->nNumFac ) + ( TDataView():FacturasProveedores( nView ) )->cSufFac

   DEFAULT nDevice      := IS_PRINTER
   DEFAULT cCaption     := "Imprimiendo facturas de proveedores"
   DEFAULT cCodDoc      := cFormatoDocumento( ( TDataView():FacturasProveedores( nView ) )->cSerFac, "nFacPrv", dbfCount )
   DEFAULT nCopies      := if( nCopiasDocumento( ( TDataView():FacturasProveedores( nView ) )->cSerFac, "nFacPrv", dbfCount ) == 0, Max( Retfld( ( TDataView():FacturasProveedores( nView ) )->cCodPrv, TDataView():Proveedores( nView ), "nCopiasF" ), 1 ), nCopiasDocumento( ( TDataView():FacturasProveedores( nView ) )->cSerFac, "nFacPrv", dbfCount ) )

   if Empty( cCodDoc )
      cCodDoc           := cFirstDoc( "FP", dbfDoc )
   end if

   if !lExisteDocumento( cCodDoc, dbfDoc )
      return nil
   end if

   /*
   Si el documento es de tipo visual-------------------------------------------
   */

   if lVisualDocumento( cCodDoc, dbfDoc )

      PrintReportFacPrv( nDevice, nCopies, cPrinter, dbfDoc )

   else

      /*
      Recalculamos la factura
      */

      nTotFacPrv( nFactura, TDataView():FacturasProveedores( nView ), dbfFacPrvL, dbfIva, dbfDiv, dbfFacPrvP )

      /*
      Buscamos el primer registro
      */

      ( dbfFacPrvL )->( dbSeek( nFactura ) )
      ( dbfFacPrvP )->( dbSeek( nFactura ) )

      /*
      Posicionamos en ficheros auxiliares
      */

      ( TDataView():Proveedores( nView )   )->( dbSeek( ( TDataView():FacturasProveedores( nView ) )->cCodPrv ) )
      ( dbfAlm   )->( dbSeek( ( TDataView():FacturasProveedores( nView ) )->cCodAlm ) )
      ( dbfFPago )->( dbSeek( ( TDataView():FacturasProveedores( nView ) )->cCodPago) )
      ( dbfDiv   )->( DbSeek( ( TDataView():FacturasProveedores( nView ) )->cDivFac ) )

      private cDbf         := TDataView():FacturasProveedores( nView )
      private cDbfCol      := dbfFacPrvL
      private cDbfRec      := dbfFacPrvP
      private cDbfAlm      := dbfAlm
      private cDbfPrv      := TDataView():Proveedores( nView )
      private cDbfPgo      := dbfFPago
      private cDbfIva      := dbfIva
      private cDbfDiv      := dbfDiv
      private cDbfArt      := dbfArticulo
      private cDbfKit      := dbfKit
      private cDbfPro      := dbfPro
      private cDbfTblPro   := dbfTblPro
      private nTotPage     := nTotLFacPrv( dbfFacPrvL )
      private cPinDivFac   := cPinDiv
      private cPirDivFac   := cPirDiv
      private cPicEurFac   := cPicEur
      private nDinDivFac   := nDinDiv
      private nDirDivFac   := nRinDiv
      private nVdvDivFac   := ( TDataView():FacturasProveedores( nView ) )->nVdvFac

      if !Empty( cPrinter )
         oDevice           := TPrinter():New( cCaption, .f., .t., cPrinter )
         REPORT oInf CAPTION cCaption TO DEVICE oDevice
      else
         REPORT oInf CAPTION cCaption PREVIEW
      end if

      /*
      Cabeceras del listado
      */

      if !Empty( oInf ) .and. oInf:lCreated
         oInf:lAutoLand          := .f.
         oInf:lFinish            := .f.
         oInf:lNoCancel          := .t.
         oInf:bSkip              := {|| FacPrvReportSkipper( dbfFacPrvL ) }

         oInf:oDevice:lPrvModal  := .t.

         do case
            case nDevice == IS_PRINTER
               oInf:bPreview  := {| oDevice | PrintPreview( oDevice ) }

            case nDevice == IS_PDF
               oInf:bPreview  := {| oDevice | PrintPdf( oDevice ) }

         end case

         SetMargin(  cCodDoc, oInf )
         PrintColum( cCodDoc, oInf )
      end if

      END REPORT

      if !Empty( oInf )

         ACTIVATE REPORT oInf ;
            WHILE       ( ( dbfFacPrvL )->cSerFac + Str( ( dbfFacPrvL )->nNumFac ) + ( dbfFacPrvL )->cSufFac = nFactura ) ;
            ON ENDPAGE  ( Epage( oInf, cCodDoc ) )

         if nDevice == IS_PRINTER
            oInf:oDevice:end()
         end if

      end if

      oInf                 := nil

   end if

   lChgImpDoc( TDataView():FacturasProveedores( nView ) )

RETURN NIL

//---------------------------------------------------------------------------//

Static Function FacPrvReportSkipper( dbfFacPrvL )

   ( dbfFacPrvL )->( dbSkip() )

   nTotPage              += nTotLFacPrv( dbfFacPrvL )

Return nil

//---------------------------------------------------------------------------//

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

   MsgStop( "Factura con mas de 3 tipos de " + cImp(), "Imposible añadir" )

RETURN .F.

//---------------------------------------------------------------------------//

STATIC FUNCTION ChgFactu( dbf, oBrw )

   if dbLock( TDataView():FacturasProveedores( nView ) )
      ( TDataView():FacturasProveedores( nView ) )->lLiquidada := !( TDataView():FacturasProveedores( nView ) )->lLiquidada
      ( TDataView():FacturasProveedores( nView ) )->( dbUnLock() )
   end if

   oBrw:refresh()

RETURN NIL

//----------------------------------------------------------------------------//

STATIC FUNCTION loaPrv( aGet, aTmp, dbf, nMode, oSay, oTlfPrv )

   local lValid      := .f.
   local cNewCodCli  := aGet[ _CCODPRV ]:VarGet()
   local lChgCodCli  := ( Empty( cOldCodCli ) .or. cOldCodCli != cNewCodCli )

   if Empty( cNewCodCli )
      Return .t.
   elseif At( ".", cNewCodCli ) != 0
      cNewCodCli := PntReplace( aGet[_CCODPRV], "0", RetNumCodPrvEmp() )
   else
      cNewCodCli := Rjust( cNewCodCli, "0", RetNumCodPrvEmp() )
   end if

   if ( TDataView():Proveedores( nView ) )->( dbSeek( cNewCodCli ) )

      if ( TDataView():Proveedores( nView ) )->lBlqPrv
         msgStop( "Proveedor bloqueado, no se pueden realizar operaciones de compra" )
         return .f.
      end if

      aGet[_CCODPRV ]:cText( ( TDataView():Proveedores( nView ) )->Cod )

      if Empty( aGet[_CNOMPRV]:varGet() ) .or. lChgCodCli
         aGet[_CNOMPRV]:cText( ( TDataView():Proveedores( nView ) )->Titulo )
      end if

      if oTlfPrv != nil
         oTlfPrv:SetText( ( TDataView():Proveedores( nView ) )->Telefono )
      end if

      if Empty( aGet[_CDIRPRV]:varGet() ) .or. lChgCodCli
         aGet[_CDIRPRV]:cText( ( TDataView():Proveedores( nView ) )->Domicilio )
      endif

      if Empty( aGet[_CPOBPRV]:varGet() ) .or. lChgCodCli
         aGet[_CPOBPRV]:cText( (TDataView():Proveedores( nView ))->POBLACION )
      endif

      if Empty( aGet[_CPROVPROV]:varGet() ) .or. lChgCodCli
         aGet[_CPROVPROV]:cText( (TDataView():Proveedores( nView ))->PROVINCIA )
      endif

      if Empty( aGet[_CPOSPRV]:varGet() ) .or. lChgCodCli
         aGet[_CPOSPRV]:cText( (TDataView():Proveedores( nView ))->CODPOSTAL )
      endif

      if Empty( aGet[_CDNIPRV]:varGet() ) .or. lChgCodCli
         aGet[_CDNIPRV]:cText( (TDataView():Proveedores( nView ))->NIF )
      endif

      if lChgCodCli
         aGet[ _CDTOESP ]:cText( ( TDataView():Proveedores( nView ) )->cDtoEsp )
         aGet[ _NDTOESP ]:cText( ( TDataView():Proveedores( nView ) )->nDtoEsp )
         aGet[ _CDPP    ]:cText( ( TDataView():Proveedores( nView ) )->cDtoPP )
         aGet[ _NDPP    ]:cText( ( TDataView():Proveedores( nView ) )->DtoPP )
      end if

      if Empty( aGet[ _CCODPAGO ]:VarGet() ) .or. lChgCodCli
         aGet[ _CCODPAGO ]:cText( ( TDataView():Proveedores( nView ) )->fPago )
         aGet[ _CCODPAGO ]:lValid()

         /*
         Si la forma de pago es un movimiento bancario le asignamos el banco y cuenta por defecto
         */

         if RetFld( aTmp[ _CCODPAGO ], dbfFPago, "LUTLBNC" )

            if dbSeekInOrd( ( TDataView():Proveedores( nView ) )->Cod, "CCODDEF", dbfPrvBnc )

               if !Empty( aGet[ _CBANCO ] )
                  aGet[ _CBANCO ]:cText( ( dbfPrvBnc )->cCodBnc )
                  aGet[ _CBANCO ]:lValid()
               end if

               if !Empty( aGet[ _CPAISIBAN ] )
                  aGet[ _CPAISIBAN ]:cText( ( dbfPrvBnc )->cPaisIBAN )
                  aGet[ _CPAISIBAN ]:lValid()
               end if

               if !Empty( aGet[ _CCTRLIBAN ] )
                  aGet[ _CCTRLIBAN ]:cText( ( dbfPrvBnc )->cCtrlIBAN )
                  aGet[ _CCTRLIBAN ]:lValid()
               end if

               if !Empty( aGet[ _CENTBNC ] )
                  aGet[ _CENTBNC ]:cText( ( dbfPrvBnc )->cEntBnc )
                  aGet[ _CENTBNC ]:lValid()
               end if

               if !Empty( aGet[ _CSUCBNC ] )
                  aGet[ _CSUCBNC ]:cText( ( dbfPrvBnc )->cSucBnc )
                  aGet[ _CSUCBNC ]:lValid()
               end if

               if !Empty( aGet[ _CDIGBNC ] )
                  aGet[ _CDIGBNC ]:cText( ( dbfPrvBnc )->cDigBnc )
                  aGet[ _CDIGBNC ]:lValid()
               end if

               if !Empty( aGet[ _CCTABNC ] )
                  aGet[ _CCTABNC ]:cText( ( dbfPrvBnc )->cCtaBnc )
                  aGet[ _CCTABNC ]:lValid()
               end if

            end if

         end if

      end if

      if Empty( aGet[ _NTIPRET ]:VarGet() ) .or. lChgCodCli
         aGet[ _NTIPRET ]:oGet:cText(  ( TDataView():Proveedores( nView ) )->nTipRet )
         aGet[ _NTIPRET ]:Select(      ( TDataView():Proveedores( nView ) )->nTipRet )
      end if

      if Empty( aGet[ _NPCTRET ]:VarGet() ) .or. lChgCodCli
         aGet[ _NPCTRET ]:cText( ( TDataView():Proveedores( nView ) )->nPctRet )
      end if

      if nMode == APPD_MODE

         aGet[ _NREGIVA ]:nOption( Max( ( TDataView():Proveedores( nView ) )->nRegIva, 1 ) )
         aGet[ _NREGIVA ]:Refresh()

         if Empty( aTmp[ _CSERFAC ] )

            if !Empty( ( TDataView():Proveedores( nView ) )->Serie )
               aGet[ _CSERFAC ]:cText( ( TDataView():Proveedores( nView ) )->Serie )
            end if

         else

            if !Empty( ( TDataView():Proveedores( nView ) )->Serie ) .and. aTmp[ _CSERFAC ] != ( TDataView():Proveedores( nView ) )->Serie .and. ApoloMsgNoYes( "La serie del proveedor seleccionado es distinta a la anterior.", "¿Desea cambiar la serie?" )
               aGet[ _CSERFAC ]:cText( ( TDataView():Proveedores( nView ) )->Serie )
            end if

         end if

      end if

      if lChgCodCli
         aTmp[ _LRECARGO ] := ( TDataView():Proveedores( nView ) )->lReq
         aGet[ _LRECARGO ]:Refresh()

         aTmp[ _LRECC ]    := ( TDataView():Proveedores( nView ) )->lRecc
         aGet[ _LRECC ]:Refresh()        
      end if

      if ( TDataView():Proveedores( nView ) )->lMosCom .and. !Empty( ( TDataView():Proveedores( nView ) )->mComent ) .and. lChgCodCli
         MsgStop( AllTrim( ( TDataView():Proveedores( nView ) )->mComent ) )
      end if

      cOldCodCli  := ( TDataView():Proveedores( nView ) )->Cod
      lValid      := .t.

   ELSE

      msgStop( "Proveedor no encontrado" )

   END IF

RETURN lValid

//----------------------------------------------------------------------------//

/*
Carga los articulos
*/

STATIC FUNCTION LoaArt( cCodArt, aGet, aTmp, aTmpFac, oFld, oSayPr1, oSayPr2, oSayVp1, oSayVp2, oBmp, oBrwPrp, oGetIra, oDlg, oStkAct, oSayLote, oBeneficioSobre, oTotal, nMode )

   local hHas128
   local cLote
   local dFechaCaducidad
   local nIva
   local nOrdAnt
   local nPreUnt
   local nPreCom
   local cCodFam
   local cPrpArt
   local cCodPrv
   local lChgCodArt
   local lSeek       := .f.

   nIva              := 0
   cPrpArt           := aTmp[ _CCODPR1 ] + aTmp[ _CCODPR2 ] + aTmp[ _CVALPR1 ] + aTmp[ _CVALPR2 ]
   cCodPrv           := aTmpFac[ _CCODPRV ]
   lChgCodArt        := ( Rtrim( cOldCodArt ) != Rtrim( cCodArt ) .or. Rtrim( cOldPrpArt ) != Rtrim( cPrpArt ) )

   if Empty( cCodArt )

      if lRetCodArt()
         MsgStop( "No se pueden añadir lineas sin codificar" )
         return .f.
      end if

      aGet[ _NIVA     ]:bWhen := {|| .t. }

      aGet[ _CDETALLE ]:Hide()

      aGet [_MLNGDES  ]:Show()
      aGet [_MLNGDES  ]:SetFocus()

      if !Empty( oBrwPrp )
         oBrwPrp:Hide()
      end if

   else

      if lModIva()
         aGet[ _NIVA ]:bWhen  := {|| .t. }
      else
         aGet[ _NIVA ]:bWhen  := {|| .f. }
      end if

      aGet[ _CREF    ]:Show()
      aGet[ _CDETALLE]:Show()
      aGet[ _MLNGDES ]:Hide()
  
      /*
      Buscamos codificacion GS1-128--------------------------------------------
      */

      if Len( Alltrim( cCodArt ) ) > 18

         hHas128              := ReadCodeGS128( cCodArt )
         if !Empty( hHas128 )
            cCodArt           := uGetCodigo( hHas128, "01" )
            cLote             := uGetCodigo( hHas128, "10" )
            dFechaCaducidad   := uGetCodigo( hHas128, "15" )
         end if 

      end if

      /*
      Ahora buscamos por el codigo interno-------------------------------------
      */

      if lIntelliArtciculoSearch( cCodArt, cCodPrv, dbfArticulo, dbfArtPrv, dbfCodebar )

         if ( lChgCodArt )

            if ( dbfArticulo )->lObs
               MsgStop( "Artículo catalogado como obsoleto" )
               return .f.
            end if

            cCodArt              := ( dbfArticulo )->Codigo

            aGet[ _CREF ]:cText( Padr( cCodArt, 200 ) )
            aTmp[ _CREF ]        := cCodArt

            /*
            Lotes
            ---------------------------------------------------------------------
            */

            aTmp[ _LLOTE  ]      := ( dbfArticulo )->lLote

            if ( dbfArticulo )->lLote

               if Empty( cLote )
                  cLote          := ( dbfArticulo )->cLote
               end if 

               oSayLote:Show()
               aGet[ _CLOTE   ]:Show()
               aGet[ _CLOTE   ]:cText( cLote )

               /*
               Fecha de caducidad----------------------------------------------
               */

               if Empty( dFechaCaducidad )
                  dFechaCaducidad   := dFechaCaducidadLote( cCodArt, aTmp[ _CVALPR1 ], aTmp[ _CVALPR2 ], aTmp[ _CLOTE ], dbfAlbPrvL, dbfFacPrvL )
               end if 

               aGet[ _DFECCAD ]:Show()

               if Empty( aTmp[ _DFECCAD ] )
                  aGet[ _DFECCAD ]:cText( dFechaCaducidad )
               end if

            else

               oSayLote:Hide()
               aGet[ _CLOTE   ]:Hide()
               aGet[ _DFECCAD ]:Hide()

            end if

            /*
            Cogemos las familias y grupos de familias
            */

            cCodFam                 := ( dbfArticulo )->Familia
            if !Empty( cCodFam )
               aTmp[ _CCODFAM ]     := cCodFam
               aTmp[ _CGRPFAM ]     := cGruFam( cCodFam, dbfFamilia )
            end if

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
            Series
            -------------------------------------------------------------------
            */

            aTmp[ _LNUMSER ]        := ( dbfArticulo )->lNumSer
            aTmp[ _LAUTSER ]        := ( dbfArticulo )->lAutSer

            /*
            Tomamos el valor del precio unitario-------------------------------
            */

            if oStkAct != nil .and. aTmp[ _NCTLSTK ] <= 1
               oStock:nPutStockActual( cCodArt, aTmpFac[ _CCODALM ], , , , aTmp[ _LKITART ], aTmp[ _NCTLSTK ], oStkAct )
            end if

            /*
            Tomamos el valor del precio unitario-------------------------------
            */

            nPreUnt                 := aGet[ _NPREUNIT ]:VarGet()

            /*
            Abilitamos la segunda caja de dialogo
            */

            oFld:aEnable            := { .t., .t., .t. }
            oFld:refresh()

            aGet[_CREF    ]:cText( ( dbfArticulo )->Codigo )
            aGet[_CDETALLE]:cText( ( dbfArticulo )->Nombre )

            if ( dbfArticulo )->lMosCom .and. !Empty( ( dbfArticulo )->mComent )
               MsgStop( Trim( ( dbfArticulo )->mComent ) )
            end if

            /*
            Preguntamos si el regimen de " + cImp() + " es distinto de Exento
            */

            if aTmpFac[ _NREGIVA ] <= 1

               nIva           := nIva( dbfIva, ( dbfArticulo )->TipoIva )
               aGet[ _NIVA    ]:cText( nIva )
               aGet[ _NIVALIN ]:cText( nIva )
               aGet[ _LIVALIN ]:Click( ( dbfArticulo )->lIvaInc ):Refresh()

               aTmp[ _NREQ ]  := nReq( dbfIva, ( dbfArticulo )->TipoIva )

            end if   

            if ( dbfArticulo )->nCajEnt != 0
               aGet[_NCANENT]:cText( ( dbfArticulo )->nCajEnt )
            end if

            if ( dbfArticulo )->nUniCaja != 0
               aGet[_NUNICAJA]:cText( ( dbfArticulo )->nUniCaja )
            end if

            /*
            Referencia de proveedor-----------------------------------------------
            */

            nOrdAnt                 := ( dbfArtPrv )->( OrdSetFocus( "cCodPrv" ) )

            if ( dbfArtPrv )->( dbSeek( cCodPrv + cCodArt) )

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
            Ponemos el precio de venta recomendado--------------------------------
            */

            aTmp[ _NPVPREC ]     := ( dbfArticulo )->PvpRec

            /*
            Buscamos la familia del articulo y anotamos las propiedades-----------
            */

            aTmp[ _CCODPR1 ]     := ( dbfArticulo )->cCodPrp1
            aTmp[ _CCODPR2 ]     := ( dbfArticulo )->cCodPrp2

            if ( !Empty( aTmp[ _CCODPR1 ] ) .or. !Empty( aTmp[ _CCODPR2 ] ) ) .and. ;
               ( uFieldEmpresa( "lUseTbl" ) .and. ( nMode == APPD_MODE ) )

               nPreCom           := nCosto( nil, dbfArticulo, dbfKit, .f., aTmpFac[ _CDIVFAC ], dbfDiv )

               LoadPropertiesTable( cCodArt, nPreCom, aTmp[ _CCODPR1 ], aTmp[ _CCODPR2 ], dbfPro, dbfTblPro, dbfArtCom, oBrwPrp, aGet[ _NUNICAJA ], aGet[ _NPREUNIT ] )

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
            Cargamos el codigo de las unidades---------------------------------
            */

            if !Empty( aGet[ _CUNIDAD ] )
               aGet[ _CUNIDAD ]:cText( ( dbfArticulo )->cUnidad )
               aGet[ _CUNIDAD ]:lValid()
            else
               aTmp[ _CUNIDAD ]  := ( dbfArticulo )->cUnidad
            end if

            ValidaMedicion( aTmp, aGet)

         end if

         cPrpArt                 := aTmp[ _CCODPR1 ] + aTmp[ _CCODPR2 ] + aTmp[ _CVALPR1 ] + aTmp[ _CVALPR2 ]

         if ( lChgCodArt ) .or. ( cPrpArt != cOldPrpArt )

            /*
            Precios de Compra-----------------------------------------------------
            */

            if !Empty( aGet[ _NPRECOM ] )
               aGet[ _NPRECOM ]:cText( nNetUFacPrv( aTmp, aTmpFac, nDinDiv, nRinDiv, aTmpFac[ _NVDVFAC ] ) )
            end if

            nPreCom              := nComPro( cCodArt, aTmp[ _CCODPR1 ], aTmp[ _CVALPR1 ], aTmp[ _CCODPR2 ], aTmp[ _CVALPR2 ], dbfArtCom )
            if nPrecom  != 0

               aGet[ _NPREUNIT ]:cText( nPreCom )

            else

               if uFieldEmpresa( "lCosPrv", .f. )
                  nPreCom        := nPreArtPrv( cCodPrv, cCodArt, dbfArtPrv )
               end if

               if nPreCom != 0
                  aGet[ _NPREUNIT ]:cText( nPreCom )
               else
                  aGet[ _NPREUNIT ]:cText( nCosto( nil, dbfArticulo, dbfKit, .f., aTmpFac[ _CDIVFAC ], dbfDiv ) )
               end if

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

            /*
            Situacion posterior---------------------------------------------------
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

         end if

         /*
         Recalculamos los totales de la linea----------------------------------
         */

         lCalcDeta( aTmp, aTmpFac, aGet, oTotal )

      else

         MsgStop( "Artículo no encontrado" )
         Return .f.

      end if

   end if

   cOldCodArt                    := cCodArt
   cOldPrpArt                    := cPrpArt

Return .t.

//--------------------------------------------------------------------------//

STATIC FUNCTION LoadPreCosto( aGet, oGet )

   local xValor   := aGet[_CREF]:varGet()

   IF Empty( xValor )
      RETURN .F.
   END IF

   if oGet == nil
      return .f.
   end if

   IF ( dbfArticulo )->( dbSeek( xValor ) )
      oGet:cText( ( dbfArticulo )->pCosto )
   END IF

   aGet[_CREF]:bWhen := {|| .F. }

RETURN .F.

//--------------------------------------------------------------------------//

STATIC FUNCTION LoadArtPed( aGet )

   local lValid               := .f.
   local xValor               := aGet[_CREF]:varGet()

   IF Empty( xValor )

      aGet[_NIVA]:cText( 0 )
      aGet[_NIVA]:bWhen       := {|| .t. }

      aGet[_CDETALLE]:cText( Space( 50 ) )
      aGet[_CDETALLE]:bWhen   := {|| .t. }

      RETURN .T.

   END IF

   if ( dbfArticulo )->( dbSeek( xValor ) )

      aGet[_CREF    ]:cText( ( dbfArticulo )->Codigo )
      aGet[_CREF    ]:bWhen   := {|| .t. }

      aGet[_CDETALLE]:cText( ( dbfArticulo )->Nombre )
      aGet[_NPREUNIT]:cText( ( dbfArticulo )->pCosto )

      lValid                  := .t.

   else

      MsgStop( "Artículo no encontrado" )

   end if

RETURN lValid

//--------------------------------------------------------------------------//

STATIC FUNCTION GetArtPrv( cRefPrv, cCodPrv, aGet )

   local nOrdAnt

   if Empty( cRefPrv )

      return .t.

   else

      nOrdAnt  := ( dbfArtPrv )->( ordSetFocus( 3 ) )

      if ( dbfArtPrv )->( dbSeek( cCodPrv + cRefPrv ) )

         aGet[ _CREF ]:cText( ( dbfArtPrv )->cCodArt )
         aGet[ _CREF ]:lValid()

      else

         msgStop( "Referencia de proveedor no encontrada" )

      end if

      ( dbfArtPrv )->( ordSetFocus( nOrdAnt ) )

   end if

return .t.

//----------------------------------------------------------------------------//

STATIC FUNCTION SearchFact( oBrw )

   local oDlg
   local xToSearch
   local nNumFac  := 0
   local cCodCli  := (TDataView():FacturasProveedores( nView ))->CCODPRV
   local dFactura := date()
   local nIndex   := (TDataView():FacturasProveedores( nView ))->(OrdNumber())

   DEFINE DIALOG oDlg RESOURCE "FINFACPRV"

      REDEFINE GET nNumFac ;
         ID       130 ;
         PICTURE  "999999999" ;
         WHEN     ( nIndex == 1 ) ;
         VALID    ( xToSearch := nNumFac, .T. ) ;
         COLOR    CLR_GET ;
         OF       oDlg

      REDEFINE GET dFactura ;
         ID       140 ;
         WHEN     ( nIndex == 2 ) ;
         VALID    ( xToSearch := dFactura, .T. ) ;
         COLOR    CLR_GET ;
         OF       oDlg

      REDEFINE GET cCodCli ;
         ID       150 ;
         WHEN     ( nIndex == 3 ) ;
         VALID    ( xToSearch := cCodCli, .T. ) ;
         COLOR    CLR_GET ;
         OF       oDlg

      REDEFINE BUTTON ;
         ID       504 ;
         OF       oDlg ;
         ACTION   ( (TDataView():FacturasProveedores( nView ))->( dbSeek( xToSearch ) ), oBrw:Refresh() )

      REDEFINE BUTTON ;
         ID       510 ;
         OF       oDlg ;
         CANCEL ;
         ACTION   ( oDlg:end() )

   ACTIVATE DIALOG oDlg CENTER

RETURN NIL

//-------------------------------------------------------------------------//

STATIC FUNCTION EPage( oInf, cCodDoc )

   private nPagina      := oInf:nPage
   private lEnd         := oInf:lFinish

   /*
   Ahora montamos los Items
   */

   PrintItems( cCodDoc, oInf )

RETURN NIL

//--------------------------------------------------------------------------//

STATIC FUNCTION aGetSelRec( oBrw, bAction, cTitle, lHide1, cTitle1, lHide2, cTitle2, bPreAction, bPostAction )

   local oDlg
   local oBtn
   local oBtnCancel
   local oRad
   local nRad        := 1
   local aRet        := {}
   local oTree
   local oChk1
   local oChk2
   local lChk1       := .t.
   local lChk2       := .t.
   local nRecno      := ( TDataView():FacturasProveedores( nView ) )->( Recno() )
   local nOrdAnt     := ( TDataView():FacturasProveedores( nView ) )->( OrdSetFocus( 1 ) )
   local oSerIni
   local oSerFin
   local cSerIni     := ( TDataView():FacturasProveedores( nView ) )->cSerFac
   local cSerFin     := ( TDataView():FacturasProveedores( nView ) )->cSerFac
   local oDocIni
   local oDocFin
   local nDocIni     := ( TDataView():FacturasProveedores( nView ) )->nNumFac
   local nDocFin     := ( TDataView():FacturasProveedores( nView ) )->nNumFac
   local oSufIni
   local oSufFin
   local cSufIni     := ( TDataView():FacturasProveedores( nView ) )->cSufFac
   local cSufFin     := ( TDataView():FacturasProveedores( nView ) )->cSufFac
   local oMtrInf
   local nMtrInf
   local lFechas     := .t.
   local dDesde      := CtoD( "01/01/" + Str( Year( Date() ) ) )
   local dHasta      := Date()
   local oImageList

   DEFAULT cTitle    := ""
   DEFAULT lHide1    := .f.
   DEFAULT cTitle1   := ""
   DEFAULT lHide2    := .f.
   DEFAULT cTitle2   := ""

   oImageList        := TImageList():New( 16, 16 )
   oImageList:AddMasked( TBitmap():Define( "Bullet_Square_Red_16" ),    Rgb( 255, 0, 255 ) )
   oImageList:AddMasked( TBitmap():Define( "Bullet_Square_Green_16" ),  Rgb( 255, 0, 255 ) )

   DEFINE DIALOG oDlg RESOURCE "SelectRango" TITLE cTitle

   REDEFINE RADIO oRad VAR nRad ;
      ID       80, 81 ;
      OF       oDlg

   REDEFINE GET oSerIni VAR cSerIni ;
      ID       100 ;
      PICTURE  "@!" ;
      SPINNER ;
      ON UP    ( UpSerie( oSerIni ) );
      ON DOWN  ( DwSerie( oSerIni ) );
      WHEN     ( oRad:nOption == 2 ) ;
      VALID    ( cSerIni >= "A" .and. cSerIni <= "Z" );
      UPDATE ;
      OF       oDlg

   REDEFINE BTNBMP ;
      ID       101 ;
      OF       oDlg ;
      RESOURCE "Up16" ;
      NOBORDER ;
      ACTION   ( dbFirst( TDataView():FacturasProveedores( nView ), "nNumFac", oDocIni, cSerIni, "nNumFac" ) )

   REDEFINE GET oSerFin VAR cSerFin ;
      ID       110 ;
      PICTURE  "@!" ;
      SPINNER ;
      ON UP    ( UpSerie( oSerFin ) );
      ON DOWN  ( DwSerie( oSerFin ) );
      WHEN     ( oRad:nOption == 2 ) ;
      VALID    ( cSerFin >= "A" .and. cSerFin <= "Z" );
      UPDATE ;
      OF       oDlg

   REDEFINE BTNBMP ;
      ID       111 ;
      OF       oDlg ;
      RESOURCE "Down16" ;
      NOBORDER ;
      ACTION   ( dbLast( TDataView():FacturasProveedores( nView ), "nNumFac", oDocFin, cSerFin, "nNumFac" ) )

   REDEFINE GET oDocIni VAR nDocIni;
      ID       120 ;
      PICTURE  "999999999" ;
      SPINNER ;
      WHEN     ( nRad == 2 ) ;
      OF       oDlg

   REDEFINE GET oDocFin VAR nDocFin;
      ID       130 ;
      PICTURE  "999999999" ;
      SPINNER ;
      WHEN     ( nRad == 2 ) ;
      OF       oDlg

   REDEFINE GET oSufIni VAR cSufIni ;
      ID       140 ;
      PICTURE  "##" ;
      WHEN     ( nRad == 2 ) ;
      OF       oDlg

   REDEFINE GET oSufFin VAR cSufFin ;
      ID       150 ;
      PICTURE  "##" ;
      WHEN     ( nRad == 2 ) ;
      OF       oDlg

   REDEFINE CHECKBOX oChk1 VAR lChk1 ;
      ID       160 ;
      OF       oDlg

   REDEFINE CHECKBOX oChk2 VAR lChk2 ;
      ID       180 ;
      OF       oDlg

   /*
   Rango de fechas-------------------------------------------------------------
   */

   REDEFINE CHECKBOX lFechas ;
      ID       300 ;
      OF       oDlg

   REDEFINE GET dDesde ;
      ID       310 ;
      WHEN     ( !lFechas ) ;
      SPINNER ;
      OF       oDlg

   REDEFINE GET dHasta ;
      ID       320 ;
      WHEN     ( !lFechas ) ;
      SPINNER ;
      OF       oDlg

   /*
   Resultados del proceso------------------------------------------------------
   */

   oTree             := TTreeView():Redefine( 170, oDlg )
   oTree:bLDblClick  := {|| TreeChanged( oTree ) }

   REDEFINE METER oMtrInf ;
      VAR      nMtrInf ;
      NOPERCENTAGE ;
      ID       200 ;
      OF       oDlg

   oMtrInf:SetTotal( ( TDataView():FacturasProveedores( nView ) )->( OrdKeyCount() ) )

   REDEFINE BUTTON oBtn ;
      ID       IDOK ;
      OF       oDlg ;
      ACTION   ( MakSelRec( bAction, bPreAction, bPostAction, cSerIni + Str( nDocIni, 9 ) + cSufIni, cSerFin + Str( nDocFin, 9 ) + cSufFin, nRad, lChk1, lChk2, lFechas, dDesde, dHasta, oDlg, oBtnCancel, TDataView():FacturasProveedores( nView ), dbfFacPrvL, oTree, oBrw, oMtrInf ) )

   REDEFINE BUTTON oBtnCancel ;
      ID       IDCANCEL ;
      OF       oDlg ;
      CANCEL ;
      ACTION   ( oDlg:end() )

   oDlg:bStart := {|| StartGetSelRec( oBrw, oRad, oChk1, oChk2, oSerIni, oSerFin, oDocIni, oDocFin, oSufIni, oSufFin, lHide1, lHide2, cTitle1, cTitle2 ) }

   oDlg:AddFastKey( VK_F5, {|| oBtn:Click() } )

   ACTIVATE DIALOG oDlg ;
      CENTER ;
      ON INIT  ( oTree:SetImageList( oImageList ) )

   ( TDataView():FacturasProveedores( nView ) )->( ordSetFocus( nOrdAnt ) )
   ( TDataView():FacturasProveedores( nView ) )->( dbGoTo( nRecNo ) )

   oImageList:End()

   oTree:Destroy()

   oBrw:SetFocus()
   oBrw:Refresh()

RETURN ( aRet )

//---------------------------------------------------------------------------//

Static Function StartGetSelRec( oBrw, oRad, oChk1, oChk2, oSerIni, oSerFin, oDocIni, oDocFin, oSufIni, oSufFin, lHide1, lHide2, cTitle1, cTitle2 )

   if !Empty( oBrw ) .and. ( len( oBrw:oBrw:aSelected ) > 1 )

      oRad:SetOption( 1 )

   else

      oRad:SetOption( 2 )

      oSerIni:Enable()
      oSerFin:Enable()
      oDocIni:Enable()
      oDocFin:Enable()
      oSufIni:Enable()
      oSufFin:Enable()

   end if

   if lHide1
      oChk1:Hide()
   else
      SetWindowText( oChk1:hWnd, cTitle1 )
      oChk1:Refresh()
   end if

   if lHide2
      oChk2:Hide()
   else
      SetWindowText( oChk2:hWnd, cTitle2 )
      oChk2:Refresh()
   end if

Return ( nil )

//---------------------------------------------------------------------------//

Static Function TreeChanged( oTree )

   local oItemTree   := oTree:GetItem()

   if !Empty( oItemTree ) .and. !Empty( oItemTree:bAction )
      Eval( oItemTree:bAction )
   end if

RETURN NIL

//---------------------------------------------------------------------------//

static function MakSelRec( bAction, bPreAction, bPostAction, cDocIni, cDocFin, nRad, lChk1, lChk2, lFechas, dDesde, dHasta, oDlg, oBtnCancel, dbf, dbfFacPrvL, oTree, oBrw, oMtrInf )

   local n        := 0
   local nPos     := 0
   local nRec     := ( TDataView():FacturasProveedores( nView ) )->( Recno() )
   local aPos
   local lPre
   local lRet
   local lWhile   := .t.

   /*
   Preparamos la pantalla para mostrar la simulación---------------------------
   */

   if lChk1
      aPos        := { 0, 0 }
      ClientToScreen( oDlg:hWnd, aPos )
      oDlg:Move( aPos[ 1 ] - 22, aPos[ 2 ] - 510 )
   end if

   /*
   Desabilitamos el dialogo para iniciar el proceso----------------------------
   */

   oDlg:Disable()

   oTree:Enable()
   oTree:DeleteAll()

   oBtnCancel:bAction   := {|| lWhile := .f. }
   oBtnCancel:Enable()

   if !Empty( bPreAction )
      lPre              := Eval( bPreAction )
   end if

   if !IsLogic( lPre ) .or. lPre

      if ( nRad == 1 )

         for each nPos in ( oBrw:oBrw:aSelected )

            ( TDataView():FacturasProveedores( nView ) )->( dbGoTo( nPos ) )

            if lFechas .or.( ( TDataView():FacturasProveedores( nView ) )->dFecFac >= dDesde .and. ( TDataView():FacturasProveedores( nView ) )->dFecFac <= dHasta )

               lRet  := Eval( bAction, lChk1, lChk2, oTree, TDataView():FacturasProveedores( nView ), dbfFacPrvL )

               if IsFalse( lRet )
                  exit
               end if

            end if

            oMtrInf:Set( ++n )

            SysRefresh()

            if !lWhile
               exit
            end if

         next

      else

         ( TDataView():FacturasProveedores( nView ) )->( dbSeek( cDocIni, .t. ) )

         while ( lWhile )                                                                                         .and.;
               ( TDataView():FacturasProveedores( nView ) )->cSerFac + Str( ( TDataView():FacturasProveedores( nView ) )->nNumFac, 9 ) + ( TDataView():FacturasProveedores( nView ) )->cSufFac >= cDocIni   .and. ;
               ( TDataView():FacturasProveedores( nView ) )->cSerFac + Str( ( TDataView():FacturasProveedores( nView ) )->nNumFac, 9 ) + ( TDataView():FacturasProveedores( nView ) )->cSufFac <= cDocFin   .and. ;
               !( TDataView():FacturasProveedores( nView ) )->( eof() )

            if lFechas .or.( ( TDataView():FacturasProveedores( nView ) )->dFecFac >= dDesde .and. ( TDataView():FacturasProveedores( nView ) )->dFecFac <= dHasta )

               lRet  := Eval( bAction, lChk1, lChk2, oTree, TDataView():FacturasProveedores( nView ), dbfFacPrvL )

               if IsFalse( lRet )
                  exit
               end if

            end if

            oMtrInf:Set( ( TDataView():FacturasProveedores( nView ) )->( OrdKeyNo() ) )

            ( TDataView():FacturasProveedores( nView ) )->( dbSkip() )

            SysRefresh()

         end do

      end if

      if !Empty( bPostAction )
         Eval( bPostAction )
      end if

   end if

   oMtrInf:Set( ( TDataView():FacturasProveedores( nView ) )->( LastRec() ) )

   ( TDataView():FacturasProveedores( nView ) )->( dbGoTo( nRec ) )

   if lChk1
      WndCenter( oDlg:hWnd ) // Move( aPos[ 1 ], aPos[ 2 ] + 200 )
   end if

   oBtnCancel:bAction   := {|| oDlg:End() }

   oDlg:Enable()

   if oBrw != nil
      oBrw:Refresh()
   end if

RETURN ( nil )

//---------------------------------------------------------------------------//
/*
Realiza asientos en Contaplus, partiendo de la factura
*/

STATIC FUNCTION ContFactu( lSimula, lPago, oTree )

   local n
   local nAsiento    := 0
   local cCtaVent
   local nPosicion
   local nPosIva
   local dFecha
   local aTotFac
   local nTotFac
   local nTotRet
   local aTotIva
   local cConcepto
   local cConCompr
   local cSubCtaIva
   local cSubCtaReq
   local cRuta
   local cCodEmp
   local nImpDeta
   local nDinDiv     := nDinDiv( ( TDataView():FacturasProveedores( nView ) )->cDivFac, dbfDiv )
   local nRinDiv     := nRinDiv( ( TDataView():FacturasProveedores( nView ) )->cDivFac, dbfDiv )
   local aSimula     := {}
   local aIva        := {}
   local aVentas     := {}
   local cCodDiv     := ( TDataView():FacturasProveedores( nView ) )->cDivFac
   local cCtaPrv     := cPrvCta( ( TDataView():FacturasProveedores( nView ) )->cCodPrv, TDataView():Proveedores( nView ) )
   local cCtaPrvVta  := cPrvCtaVta( ( TDataView():FacturasProveedores( nView ) )->cCodPrv, TDataView():Proveedores( nView ) )
   local nFactura    := ( TDataView():FacturasProveedores( nView ) )->cSerFac + Str( ( TDataView():FacturasProveedores( nView ) )->nNumFac ) + ( TDataView():FacturasProveedores( nView ) )->cSufFac
   local cFactura    := ( TDataView():FacturasProveedores( nView ) )->cSerFac + "/" + Ltrim( Str( ( TDataView():FacturasProveedores( nView ) )->nNumFac ) ) + "/" + ( TDataView():FacturasProveedores( nView ) )->cSufFac
   local nNumFac     := ( TDataView():FacturasProveedores( nView ) )->nNumFac
   local cCodPro     := Left( ( TDataView():FacturasProveedores( nView ) )->cCodPro, 3 )
   local cClave      := Right( ( TDataView():FacturasProveedores( nView ) )->cCodPro, 6 )
   local lErrorFound := .f.
   local cTerNif     := ( TDataView():FacturasProveedores( nView ) )->cDniPrv
   local cTerNom     := ( TDataView():FacturasProveedores( nView ) )->cNomPrv
   local lReturn

   /*
   Chequeando antes de pasar a Contaplus
   */

   if ( TDataView():FacturasProveedores( nView ) )->lContab
      oTree:Select( oTree:Add( "Factura : " + Rtrim( cFactura ) + " ya contabilizada.", 0 ) )
      lErrorFound    := .t.
   end if

   if !ChkRuta( cRutCnt() )
      oTree:Select( oTree:Add( "Factura : " + rtrim( cFactura ) + " ruta no valida.", 0 ) )
      lErrorFound    := .t.
   end if

   /*
   Chequeamos todos los valores
   */

   cRuta             := cRutCnt()
   cCodEmp           := cCodEmpCnt( ( TDataView():FacturasProveedores( nView ) )->cSerFac )

   if Empty( cCtaPrvVta )
      cCtaPrvVta     := cCtaPrv()
   end if

   if !ChkSubcuenta( cRutCnt(), cCodEmp, cCtaPrv, , .f., .f. )
      oTree:Select( oTree:Add( "Factura : " + rtrim( cFactura ) + " subcuenta " + cCtaPrv + " no encontada.", 0 ) )
      lErrorFound    := .t.
   end if

   /*
   Totales de las facturas
   */

   aTotFac           := aTotFacPrv( nFactura, TDataView():FacturasProveedores( nView ), dbfFacPrvL, dbfIva, dbfDiv, dbfFacPrvP )
   nTotFac           := aTotFac[ 4 ]
   aTotIva           := aTotFac[ 5 ]
   nTotRet           := aTotFac[ 6 ]

   /*
   Vamos a ver si es una factura de gastos-------------------------------------
   */

   if ( TDataView():FacturasProveedores( nView ) )->lFacGas

      aAdd( aVentas, { ( TDataView():FacturasProveedores( nView ) )->SubCta, aTotFac[ 1 ] } )

      /*
      Construimos las bases de los impuestosS
      */

      for n := 1 to Len( aTotIva )

         if ( TDataView():FacturasProveedores( nView ) )->nRegIva == 2
            cSubCtaIva  := uFieldEmpresa( "cCtaCeeRpt" )
            cSubCtaReq  := uFieldEmpresa( "cCtaCeeSpt" )
         else
            cSubCtaIva  := cSubCuentaIva(       aTotIva[ n, 3 ], ( TDataView():FacturasProveedores( nView ) )->lRecargo, cRuta, cCodEmp, dbfIva, .f. )
            cSubCtaReq  := cSubCuentaRecargo(   aTotIva[ n, 3 ], ( TDataView():FacturasProveedores( nView ) )->lRecargo, cRuta, cCodEmp, dbfIva )
         end if

         nPosIva        := aScan( aIva, {|x| x[ 1 ] == aTotIva[ n, 3 ] } )
         if nPosIva == 0
            aAdd( aIva, { aTotIva[ n, 3 ], cSubCtaIva, cSubCtaReq, aTotIva[ n, 1 ] } )
         else
            aIva[ nPosIva, 4 ]   += aTotIva[ n, 1 ]
         end if

      next

   else

      /*
      Estudio de los Articulos de una factura----------------------------------
      */

      if ( dbfFacPrvL )->( dbSeek( nFactura ) )

         while ( ( dbfFacPrvL )->cSerFac + Str( ( dbfFacPrvL )->nNumFac ) + ( dbfFacPrvL )->cSufFac == nFactura .and. !( dbfFacPrvL )->( eof() ) )

            nImpDeta       := nTotLFacPrv( dbfFacPrvL, nDinDiv, nRinDiv ) // , ( TDataView():FacturasProveedores( nView ) )->nVdvFac )

            if nImpDeta != 0

               cCtaVent    := RetCtaCom( ( dbfFacPrvL )->cRef, dbfArticulo )
               if Empty( cCtaVent )
                  cCtaVent := cCtaPrvVta + RetGrpVta( ( dbfFacPrvL )->cRef, cRuta, cCodEmp, dbfArticulo, ( dbfFacPrvL )->nIva )
               end if

               nPosicion   := aScan( aVentas, {|x| x[1] == cCtaVent } )

               if nPosicion == 0
                  aadd( aVentas, { cCtaVent, nImpDeta } )
               else
                  aVentas[ nPosicion, 2 ] += nImpDeta
               end if

               /*
               Construimos las bases de los impuestosS
               */

               if ( TDataView():FacturasProveedores( nView ) )->nRegIva == 2
                  cSubCtaIva  := uFieldEmpresa( "cCtaCeeRpt" )
                  cSubCtaReq  := uFieldEmpresa( "cCtaCeeSpt" )
               else
                  cSubCtaIva  := cSubCuentaIva( ( dbfFacPrvL )->nIva, ( TDataView():FacturasProveedores( nView ) )->lRecargo, cRuta, cCodEmp, dbfIva, .f. )
                  cSubCtaReq  := cSubCuentaRecargo( ( dbfFacPrvL )->nIva, ( TDataView():FacturasProveedores( nView ) )->lRecargo, cRuta, cCodEmp, dbfIva )
               end if

               nPosIva        := aScan( aIva, {|x| x[1] == ( dbfFacPrvL )->nIva } )
               if nPosIva == 0
                  aadd( aIva, { ( dbfFacPrvL )->nIva, cSubCtaIva, cSubCtaReq, nImpDeta } )
               else
                  aIva[ nPosIva, 4 ]   += nImpDeta
               end if

            end if

            ( dbfFacPrvL )->( dbSkip() )

         end while

      else

         oTree:Select( oTree:Add( "Factura : " + Rtrim( cFactura ) + " factura sin artículos.", 0 ) )

         lErrorFound    := .t.

      end if

   end if

   /*
   Descuentos sobres grupos de Venta-------------------------------------------
   */

   for n := 1 TO Len( aVentas )

      if ( TDataView():FacturasProveedores( nView ) )->nDtoEsp != 0
         aVentas[ n, 2 ] -= Round( aVentas[ n, 2 ] * ( TDataView():FacturasProveedores( nView ) )->nDtoEsp / 100, nRinDiv )
      end if

      if ( TDataView():FacturasProveedores( nView ) )->nDpp != 0
         aVentas[ n, 2 ] -= Round( aVentas[ n, 2 ] * ( TDataView():FacturasProveedores( nView ) )->nDpp / 100, nRinDiv )
      end if

      if ( TDataView():FacturasProveedores( nView ) )->nDtoUno != 0
         aVentas[ n, 2 ] -= Round( aVentas[ n, 2 ] * ( TDataView():FacturasProveedores( nView ) )->nDtoUno / 100, nRinDiv )
      end if

      if ( TDataView():FacturasProveedores( nView ) )->nDtoDos != 0
         aVentas[ n, 2 ] -= Round( aVentas[ n, 2 ] * ( TDataView():FacturasProveedores( nView ) )->nDtoDos / 100, nRinDiv )
      end if

   next

   /*
   Descuentos sobres grupos de impuestos
   */

   for n := 1 to Len( aIva )

      if ( TDataView():FacturasProveedores( nView ) )->nDtoEsp != 0
         aIva[ n, 4 ] -= Round( aIva[ n, 4 ] * ( TDataView():FacturasProveedores( nView ) )->nDtoEsp / 100, nRinDiv )
      end if

      if ( TDataView():FacturasProveedores( nView ) )->nDpp != 0
         aIva[ n, 4 ] -= Round( aIva[ n, 4 ] * ( TDataView():FacturasProveedores( nView ) )->nDpp / 100, nRinDiv )
      end if

      if ( TDataView():FacturasProveedores( nView ) )->nDtoUno != 0
         aIva[ n, 4 ] -= Round( aIva[ n, 4 ] * ( TDataView():FacturasProveedores( nView ) )->nDtoUno / 100, nRinDiv )
      end if

      if ( TDataView():FacturasProveedores( nView ) )->nDtoDos != 0
         aIva[ n, 2 ] -= Round( aIva[ n, 4 ] * ( TDataView():FacturasProveedores( nView ) )->nDtoDos / 100, nRinDiv )
      end if

   next

   /*
   Chequeo de Cuentas de Ventas------------------------------------------------
   */

   for n := 1 TO len( aVentas )
      if !ChkSubcuenta( cRutCnt(), cCodEmp, aVentas[ n, 1 ], , .f., .f. )
         oTree:Select( oTree:Add( "Factura : " + rtrim( cFactura ) + " subcuenta " + aVentas[ n, 1 ] + " no encontada.", 0 ) )
         lErrorFound    := .t.
      end if
   next

   /*
   Chequeo de Cuentas de impuestos---------------------------------------------------
   */

   for n := 1 to len( aIva )

      if !ChkSubcuenta( cRuta, cCodEmp, aIva[ n, 2 ], , .f., .f. )
         oTree:Select( oTree:Add( "Factura : " + Rtrim( cFactura ) + " subcuenta " + aIva[ n, 2 ] + " no encontada.", 0 ) )
         lErrorFound    := .t.
      end if

      if !ChkSubcuenta( cRuta, cCodEmp, aIva[ n, 3 ], , .f., .f. )
         oTree:Select( oTree:Add( "Factura : " + Rtrim( cFactura ) + " subcuenta " + aIva[ n, 3 ] + " no encontada.", 0 ) )
         lErrorFound    := .t.
      end if

   next

   if nTotRet != 0

      if !ChkSubcuenta( cRuta, cCodEmp, cCtaRet(), , .f., .f. )
         oTree:Select( oTree:Add( "Factura : " + Rtrim( cFactura ) + " subcuenta " + cCtaRet() + " no encontada.", 0 ) )
         lErrorFound    := .t.
      end if

   end if

   /*
   Comprobamos fechas----------------------------------------------------------
   */

   if !ChkFecha( , , ( TDataView():FacturasProveedores( nView ) )->dFecFac, .f. )
      oTree:Select( oTree:Add(  "Factura : " + Rtrim( cFactura ) + " asiento fuera de fechas.", 0 ) )
      lErrorFound    := .t.
   end if

   /*
   Datos comunes a todos los Asientos------------------------------------------
   */

   if lSimula .or. !lErrorFound

      if Empty( ( TDataView():FacturasProveedores( nView ) )->dFecEnt )
         dFecha      := ( TDataView():FacturasProveedores( nView ) )->dFecFac
      else
         dFecha      := ( TDataView():FacturasProveedores( nView ) )->dFecEnt
      end if

      cConCompr      := "S/Fcta."
      if !Empty( ( TDataView():FacturasProveedores( nView ) )->cSuPed )
         nNumFac     := Val( ( TDataView():FacturasProveedores( nView ) )->cSuPed )
         cConCompr   += " N." + Rtrim( ( TDataView():FacturasProveedores( nView ) )->cSuPed )
      elseif !Empty( ( TDataView():FacturasProveedores( nView ) )->cNumDoc )
         cConCompr   += " Doc. " + Rtrim( ( TDataView():FacturasProveedores( nView ) )->cNumDoc )
      else
         cConCompr   += " N." + Rtrim( cFactura )
      end if
      cConcepto      := cConCompr + Space( 1 ) + DtoC( ( TDataView():FacturasProveedores( nView ) )->dFecFac )
      cConCompr      += Space( 1 ) + Rtrim( ( TDataView():FacturasProveedores( nView ) )->cNomPrv )

      /*
      Realizaci¢n de Asientos-----------------------------------------------------
      */

      if OpenDiario( , cCodEmp )
         nAsiento    := RetLastAsi()
      else
         oTree:Select( oTree:Add( "Factura : " + Rtrim( cFactura ) + " imposible abrir ficheros de contaplus.", 0 ) )
         return .f.
      end if

      /*
      Asiento de Proveedor________________________________________________________
      */

      aAdd( aSimula, MkAsiento(  nAsiento,;
                                 cCodDiv,;
                                 dFecha,;
                                 cCtaPrv,;
                                 ,;
                                 ,;
                                 cConcepto,;
                                 nTotFac,;
                                 nNumFac,;
                                 ,;
                                 ,;
                                 ,;
                                 ( TDataView():FacturasProveedores( nView ) )->cNumDoc,;
                                 cCodPro,;
                                 cClave,;
                                 ,;
                                 ,;
                                 ,;
                                 lSimula,;
                                 cTerNif,;
                                 cTerNom ) )

      /*
      Asientos de Compras_________________________________________________________
      */

      for n := 1 TO len( aVentas )

         aAdd( aSimula, MkAsiento(  nAsiento,;
                                    cCodDiv,;
                                    dFecha,;
                                    aVentas[ n, 1 ],;
                                    ,;
                                    aVentas[ n, 2 ],;
                                    cConCompr,;
                                    ,;
                                    nNumFac,;
                                    ,;
                                    ,;
                                    ,;
                                    ( TDataView():FacturasProveedores( nView ) )->cNumDoc,;
                                    cCodPro,;
                                    cClave,;
                                    ,;
                                    ,;
                                    ,;
                                    lSimula,;
                                    cTerNif,;
                                    cTerNom ) )

      next

      /*
      Asientos de impuestos_____________________________________________________________
      */

      if ( TDataView():FacturasProveedores( nView ) )->nRegIva == 2

         for n := 1 to len( aIva )

            if aIva[ n, 1 ] != 0 .or. uFieldEmpresa( "lConIva" )

               aadd( aSimula, MkAsiento(  nAsiento, ;
                                          cCodDiv,;
                                          dFecha, ;
                                          aIva[ n, 3 ],;                                        // Cuenta de impuestos
                                          aIva[ n, 2 ],;                                        // Contrapartida
                                          Round( aIva[ n, 1 ] * aIva[ n, 4 ] / 100, nRinDiv ),; // Ptas. Debe
                                          cConCompr,;
                                          Round( aIva[ n, 1 ] * aIva[ n, 4 ] / 100, nRinDiv ),; // Ptas. Haber
                                          nNumFac,;
                                          aIva[ n, 4 ],;
                                          aIva[ n, 1 ],;
                                          If( ( TDataView():FacturasProveedores( nView ) )->lRecargo, nPReq( dbfIva, aIva[ n, 1 ] ), 0 ),;
                                          ( TDataView():FacturasProveedores( nView ) )->cNumDoc,;
                                          cCodPro,;
                                          cClave,;
                                          ,;
                                          ,;
                                          ,;
                                          lSimula,;
                                          cTerNif,;
                                          cTerNom ) )

            end if

         next

      else

         for n := 1 to len( aIva )

            if aIva[ n, 1 ] != 0 .or. uFieldEmpresa( "lConIva" )

               aadd( aSimula, MkAsiento(  nAsiento, ;
                                          cCodDiv,;
                                          dFecha, ;
                                          aIva[ n, 2 ],;    // Cuenta de impuestos
                                          cCtaPrv,;         // Contrapartida
                                          Round( aIva[ n, 1 ] * aIva[ n, 4 ] / 100, nRinDiv ),;
                                          cConCompr,;
                                          ,;                // Ptas. Haber
                                          nNumFac,;
                                          aIva[ n, 4 ],;
                                          aIva[ n, 1 ],;
                                          If( ( TDataView():FacturasProveedores( nView ) )->lRecargo, nPReq( dbfIva, aIva[ n, 1 ] ), 0 ),;
                                          ( TDataView():FacturasProveedores( nView ) )->cNumDoc,;
                                          cCodPro,;
                                          cClave,;
                                          ,;
                                          ,;
                                          ,;
                                          lSimula,;
                                          cTerNif,;
                                          cTerNom ) )

            end if

         next

         /*
         Asientos del Recargo________________________________________________________
         */

         if ( TDataView():FacturasProveedores( nView ) )->lRecargo

            for n := 1 to len( aIva )

               if aIva[ n, 1 ] != 0 .or. uFieldEmpresa( "lConIva" )

                  aadd( aSimula, MkAsiento(  nAsiento,;
                                             cCodDiv,;
                                             dFecha,;
                                             aIva[ n, 3 ],; // Cuenta de impuestos
                                             ,;
                                             Round( nPReq( dbfIva, aIva[ n, 1 ] ) * aIva[ n, 4 ] / 100, nRinDiv ),;
                                             cConCompr,;
                                             ,;
                                             nNumFac,;
                                             ,;
                                             ,;
                                             ,;
                                             ( TDataView():FacturasProveedores( nView ) )->cNumDoc,;
                                             cCodPro,;
                                             cClave,;
                                             ,;
                                             ,;
                                             ,;
                                             lSimula,;
                                             cTerNif,;
                                             cTerNom ) )

               end if

            next

         end if

      end if

      /*
      Asientos del retenciones________________________________________________________
      */

      if nTotRet != 0

         aadd( aSimula, MkAsiento(  nAsiento,;
                                    cCodDiv,;
                                    dFecha,;
                                    cCtaRet(),;   // Cuenta de retencion
                                    ,;
                                    ,;
                                    cConCompr,;
                                    nTotRet,;
                                    nNumFac,;
                                    ,;
                                    ,;
                                    ,;
                                    ( TDataView():FacturasProveedores( nView ) )->cNumDoc,;
                                    cCodPro,;
                                    cClave,;
                                    ,;
                                    ,;
                                    ,;
                                    lSimula,;
                                    cTerNif,;
                                    cTerNom ) )

      end if

      /*
      Contabilizaci¢n de Pagos
      --------------------------------------------------------------------------
      */

      if lPago .and. ( dbfFacPrvP )->( dbSeek( nFactura ) )

         while ( ( dbfFacPrvP )->cSerFac + Str( ( dbfFacPrvP )->nNumFac ) + ( dbfFacPrvP )->cSufFac = nFactura ) .and. !( dbfFacPrvP )->( eof() )

            lReturn  := CntRecPrv( lSimula, oTree, nAsiento, aSimula, .t., dbfRctPrvT, dbfFacPrvP, TDataView():Proveedores( nView ), dbfFPago, dbfDiv )

            if IsFalse( lReturn )
               exit
            end if

            ( dbfFacPrvP )->( dbSkip() )

         end while

      end if

      /*
      Ponemos la factura como Contabilizada---------------------------------------
      */

      if !lSimula

         lReturn  := ChgContabilizado( .t., cFactura, nAsiento, oTree )

      else

         lReturn  := msgTblCon( aSimula, cCodDiv, dbfDiv, !lErrorFound, cFactura, {|| aWriteAsiento( aSimula, cCodDiv, .t., oTree, cFactura, nAsiento ), ChgContabilizado( .t., cFactura, nAsiento, oTree ) } )

      end if

      CloseDiario()

   end if

Return ( lReturn )

//---------------------------------------------------------------------------//

/*
Funcion que nos permite a¤adir a las facturas articulos de Albaranes ya
existentes
- Parametros:
   oGet     -> Objeto que contiene el valor del nuevo Albaran
   nAlbaran -> Numero del Albaran que se esta creando,
   oBrw     -> Objeto Browse se pasa para hacer los referscos
*/

STATIC FUNCTION GrpAlb( oGet, aTmp, oBrw )

   local oDlg
   local oBrwLin
   local cDetalle    := ""
   local aAlbaranes  := {}
   local nItem       := 1
   local cCodPrv     := oGet:varGet()
   local nOrd        := ( dbfAlbPrvT )->( ordSetFocus( "CCODPRV" ) )

   if Empty( cCodPrv )
      MsgStop( "Es necesario codificar un proveedor" )
      ( dbfAlbPrvT )->( ordSetFocus( nOrd ) )
      return .t.
   end if

   /*
   Seleccion de Registros
   --------------------------------------------------------------------------
   */

   if !( dbfAlbPrvT )->( dbSeek( cCodPrv ) )
      MsgStop( "No existen albaranes por facturar." )
      return .t.
   end if

   while ( ( dbfAlbPrvT )->cCodPrv = cCodPrv .and. !( dbfAlbPrvT )->(Eof()) )

      if !( dbfAlbPrvT )->lFacturado
         aAdd( aAlbaranes, {  ( dbfAlbPrvT )->lFacturado ,;
                              ( dbfAlbPrvT )->cSerAlb + Str( ( dbfAlbPrvT )->nNumAlb ) + ( dbfAlbPrvT )->cSufAlb ,;
                              ( dbfAlbPrvT )->cSuAlb  ,;
                              ( dbfAlbPrvT )->dFecAlb ,;
                              ( dbfAlbPrvT )->cCodPrv ,;
                              ( dbfAlbPrvT )->cNomPrv ,;
                              nTotAlbPrv( ( dbfAlbPrvT )->cSerAlb + Str( ( dbfAlbPrvT )->nNumAlb ) + ( dbfAlbPrvT )->cSufAlb, dbfAlbPrvT, dbfAlbPrvL, dbfIva, dbfDiv, nil, nil, .t. ) } )

      endif

      (dbfAlbPrvT)->( DbSkip(1) )

   end do

   /*
   Puede que no hay Albaranes que facturar
   */

   if Len( aAlbaranes ) == 0
      MsgStop( "No existen albaranes por facturar." )
      Return .t.
   end if

   /*
   Caja de Dialogo
   --------------------------------------------------------------------------
   */

   DEFINE DIALOG oDlg RESOURCE "SET_ALBARAN"

   oBrwLin                       := IXBrowse():New( oDlg )

   oBrwLin:bClrSel               := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
   oBrwLin:bClrSelFocus          := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

   oBrwLin:SetArray( aAlbaranes, , , .f. )

   oBrwLin:nMarqueeStyle         := 5
   oBrwLin:cName                 := "Factura de proveedor.Agrupar albaranes"

   oBrwLin:bRClicked             := {| nRow, nCol, nFlags | oBrwLin:RButtonDown( nRow, nCol, nFlags ) }

   oBrwLin:CreateFromResource( 130 )

      with object ( oBrwLin:addCol() )
         :cHeader       := "Sl. Seleccionado"
         :bStrData      := {|| "" }
         :bEditValue    := {|| aAlbaranes[ oBrwLin:nArrayAt, 1 ] }
         :nWidth        := 18
         :SetCheck( { "Sel16", "Nil16" } )
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader       := "Albarán"
         :nWidth        := 80
         :bEditValue    := {|| aAlbaranes[ oBrwLin:nArrayAt, 2 ] }
         :cEditPicture  := "@R #/999999999/##"
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader       := "Su albarán"
         :nWidth        := 80
         :bEditValue    := {|| aAlbaranes[ oBrwLin:nArrayAt, 3 ] }
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader       := "Fecha"
         :nWidth        := 80
         :bEditValue    := {|| aAlbaranes[ oBrwLin:nArrayAt, 4 ] }
         :nDataStrAlign := 3
         :nHeadStrAlign := 3
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader       := "Código"
         :nWidth        := 80
         :bEditValue    := {|| aAlbaranes[ oBrwLin:nArrayAt, 5 ] }
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader       := "Proveedor"
         :nWidth        := 200
         :bEditValue    := {|| aAlbaranes[ oBrwLin:nArrayAt, 6 ] }
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader       := "Total"
         :nWidth        := 80
         :bEditValue    := {|| aAlbaranes[ oBrwLin:nArrayAt, 7 ] }
         :nDataStrAlign := 1
         :nHeadStrAlign := 1
      end with

      REDEFINE BUTTON ;
         ID       514 ;
         OF       oDlg ;
         ACTION   ( aAlbaranes[ oBrwLin:nArrayAt, 1 ] := !aAlbaranes[ oBrwLin:nArrayAt, 1 ], oBrwLin:Refresh() )

      REDEFINE BUTTON ;
         ID       517 ;
         OF       oDlg ;
         ACTION   ( aEval( aAlbaranes, { |aItem| aItem[1] := .f. } ), oBrwLin:Refresh() )

      REDEFINE BUTTON ;
         ID       516 ;
         OF       oDlg ;
         ACTION   ( aEval( aAlbaranes, { |aItem| aItem[1] := .t. } ), oBrwLin:Refresh() )

      REDEFINE BUTTON ;
         ID       IDOK ;
         OF       oDlg ;
         ACTION   ( oDlg:End( IDOK ) )

      REDEFINE BUTTON ;
         ID       IDCANCEL ;
         OF       oDlg ;
         CANCEL ;
         ACTION   ( oDlg:End() )

   oDlg:AddFastKey( VK_F5, {|| oDlg:end( IDOK ) } )

   ACTIVATE DIALOG oDlg CENTER

   CursorWait()

   /*
   Llamda a la funcion que busca el Albaran____________________________________
   */

   ( dbfAlbPrvT )->( ordSetFocus( 1 ) )

   if oDlg:nResult == IDOK

      for nItem := 1 to Len( aAlbaranes )

         if aAlbaranes[ nItem, 1 ]

            aAdd( aNumAlb, aAlbaranes[ nItem, 2 ] )

            if ( dbfAlbPrvT )->( dbSeek( aAlbaranes[ nItem, 2 ] ) )
               SetFacturadoAlbaranProveedor( !( dbfAlbPrvT )->lFacturado, , , dbfAlbPrvT, dbfAlbPrvL, dbfAlbPrvS )
            end if

            if ( dbfAlbPrvL )->( dbSeek( aAlbaranes[ nItem, 2 ] ) )

               cDetalle                := "Albaran Nº" + ( dbfAlbPrvL )->cSerAlb + "/" + AllTrim( Str( ( dbfAlbPrvL )->nNumAlb ) ) + "/" + Rtrim( ( dbfAlbPrvL )->cSufAlb )
               if !Empty( Alltrim( aAlbaranes[ nItem, 3 ] ) )
                  cDetalle             += " - " + Alltrim( aAlbaranes[ nItem, 3 ] )
               end if
               cDetalle                += " - Fecha " + Dtoc( aAlbaranes[ nItem, 4 ] )

               ( dbfTmp )->( dbAppend() )

               ( dbfTmp )->cDetalle    := cDetalle
               ( dbfTmp )->lControl    := .t.

               AddLineasAlbaranProveedor( aAlbaranes[ nItem, 2 ], .t. )

            end if

            oBrw:Refresh()

         end if

      next

      /*
      Ponemos los Albaranes como facturados
      -----------------------------------------------------------------------
      */

      nTotFacPrv( nil, TDataView():FacturasProveedores( nView ), dbfTmp, dbfIva, dbfDiv, dbfFacPrvP, aTmp )

   end if

   ( dbfAlbPrvT )->( ordSetFocus( nOrd ) )

   /*
   Guardamos los datos del browse-------------------------------------------
   */

   oBrwLin:CloseData()

   CursorWE()

RETURN .T.

//----------------------------------------------------------------------------//

/*
Prcesa los albaranes de proveedores
*/

STATIC FUNCTION cAlbPrv( aGet, oBrw, nMode, aTmp )

   local lValid   := .f.
   local cAlbaran := aGet[ _CNUMALB ]:varGet()

   if nMode != APPD_MODE .OR. Empty( cAlbaran )
      return .t.
   end if

   if ( dbfAlbPrvT )->( dbSeek( cAlbaran ) )

      if ( dbfAlbPrvT )->lFacturado

         MsgStop( "Albaran facturado" )
         lValid   := .f.

      else

         aGet[ _CSERFAC ]:cText( ( dbfAlbPrvT )->cSerAlb )

         aGet[ _CCODPRV ]:cText( ( dbfAlbPrvT )->cCodPrv )
         aGet[ _CCODPRV ]:lValid()

         aGet[ _CCODALM ]:cText( ( dbfAlbPrvT )->cCodAlm )
         aGet[ _CCODALM ]:lValid()

         aGet[ _CCODCAJ ]:cText( ( dbfAlbPrvT )->cCodCaj )
         aGet[ _CCODCAJ ]:lValid()

         aGet[ _CCODPAGO]:cText( ( dbfAlbPrvT )->cCodPgo )
         aGet[ _CCODPAGO]:lValid()

         aGet[ _CDTOESP ]:cText( ( dbfAlbPrvT )->cDtoEsp )
         aGet[ _NDTOESP ]:cText( ( dbfAlbPrvT )->nDtoEsp )

         aGet[ _CDPP    ]:cText( ( dbfAlbPrvT )->cDpp )
         aGet[ _NDPP    ]:cText( ( dbfAlbPrvT )->nDpp )

         aGet[ _CDTOUNO ]:cText( ( dbfAlbPrvT )->cDtoUno )
         aGet[ _NDTOUNO ]:cText( ( dbfAlbPrvT )->nDtoUno )

         aGet[ _CDTODOS ]:cText( ( dbfAlbPrvT )->cDtoDos )
         aGet[ _NDTODOS ]:cText( ( dbfAlbPrvT )->nDtoDos )

         aGet[ _NREGIVA ]:nOption( Max( ( TDataView():Proveedores( nView ) )->nRegIva, 1 ) )
         aGet[ _NREGIVA ]:Refresh()

         aGet[ _MCOMENT ]:cText( ( dbfAlbPrvT )->cObserv )

         aGet[ _CNUMDOC ]:cText( ( dbfAlbPrvT )->cSuAlb )

         /*
         Añadimos las lineas---------------------------------------------------
         */

         AddLineasAlbaranProveedor( cAlbaran )

         /*
         Refrescamos-----------------------------------------------------------
         */

         oBrw:Refresh()

         /*
         Actualizamos el estado------------------------------------------------
         */

         SetFacturadoAlbaranProveedor( .t., , , dbfAlbPrvT, dbfAlbPrvL, dbfAlbPrvS )

      end if

      aGet[ _CNUMALB ]:bWhen           := {|| .f. }

      /*
      Guardamos el numero del Albaran pos si no guardamos la factura
      */

      if aScan( aNumAlb, cAlbaran ) == 0
         aAdd( aNumAlb, cAlbaran )
      end if

   else

      MsgStop( "Albaran no encontrado." )

   end if

   nTotFacPrv( nil, TDataView():FacturasProveedores( nView ), dbfTmp, dbfIva, dbfDiv, dbfFacPrvP, aTmp )

RETURN lValid

//---------------------------------------------------------------------------//

STATIC FUNCTION BeginTrans( aTmp, nMode )

   local oError
   local oBlock
   local lErrors  := .f.
   local cDbf     := "FPrvL"
   local cDbfInc  := "FPrvI"
   local cDbfDoc  := "FPrvD"
   local cDbfPgo  := "FPrvP"
   local cDbfSer  := "FPrvS"
   local nFactura := aTmp[ _CSERFAC ] + Str( aTmp[ _NNUMFAC ] ) + aTmp[ _CSUFFAC ]

   oBlock         := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      CursorWait()

      aNumAlb     := {}

      cNewFile    := cGetNewFileName( cPatTmp() + cDbf )
      cTmpInc     := cGetNewFileName( cPatTmp() + cDbfInc )
      cTmpDoc     := cGetNewFileName( cPatTmp() + cDbfDoc )
      cTmpPgo     := cGetNewFileName( cPatTmp() + cDbfPgo )
      cTmpSer     := cGetNewFileName( cPatTmp() + cDbfSer )

      /*
      Primero Crear la base de datos local
      */

      dbCreate( cNewFile, aSqlStruct( aColFacPrv() ), cLocalDriver() )
      dbUseArea( .t., cLocalDriver(), cNewFile, cCheckArea( cDbf, @dbfTmp ), .f. )

      if !( dbfTmp )->( neterr() )
         ( dbfTmp )->( OrdCondSet( "!Deleted()", {||!Deleted() } ) )
         ( dbfTmp )->( OrdCreate( cNewFile, "nNumLin", "Str( nNumLin, 4 )", {|| Str( Field->nNumLin ) } ) )

         ( dbfTmp )->( OrdCondSet( "!Deleted()", {||!Deleted() } ) )
         ( dbfTmp )->( OrdCreate( cNewFile, "Recno", "Str( Recno() )", {|| Str( Recno() ) } ) )
      end if

      /*
      A¤adimos desde el fichero de lineas
      */

      if ( dbfFacPrvL )->( dbSeek( nFactura ) )
         while ( ( dbfFacPrvL )->CSERFAC + Str( ( dbfFacPrvL )->NNUMFAC ) + ( dbfFacPrvL )->CSUFFAC == nFactura .AND. !( dbfFacPrvL )->( eof() ) )
            dbPass( dbfFacPrvL, dbfTmp, .t. )
            ( dbfFacPrvL )->( dbSkip() )
         end while
      end if

      ( dbfTmp )->( dbGoTop() )

      /*
      Creamos la tabla temporal de incidencias
      */

      dbCreate( cTmpInc, aSqlStruct( aIncFacPrv() ), cLocalDriver() )
      dbUseArea( .t., cLocalDriver(), cTmpInc, cCheckArea( cDbfInc, @dbfTmpInc ), .f. )
      if !( dbfTmpInc )->( neterr() )
         ( dbfTmpInc )->( ordCondSet( "!Deleted()", {||!Deleted() } ) )
         ( dbfTmpInc )->( ordCreate( cTmpInc, "Recno", "Recno()", {|| Recno() } ) )
      end if

      /*
      A¤adimos desde el fichero de incidencias
      */

      if ( dbfFacPrvI )->( dbSeek( nFactura ) )
         while ( ( dbfFacPrvI )->cSerie + Str( ( dbfFacPrvI )->nNumFac ) + ( dbfFacPrvI )->cSufFac == nFactura ) .AND. ( dbfFacPrvI )->( !eof() )
            dbPass( dbfFacPrvI, dbfTmpInc, .t. )
            ( dbfFacPrvI )->( dbSkip() )
         end while
      end if

      ( dbfTmpInc )->( dbGoTop() )

      /*
      Creamos la tabla temporal de documentos
      */

      dbCreate( cTmpDoc, aSqlStruct( aFacPrvDoc() ), cLocalDriver() )
      dbUseArea( .t., cLocalDriver(), cTmpDoc, cCheckArea( cDbfDoc, @dbfTmpDoc ), .f. )
      if !( dbfTmpDoc )->( neterr() )
         ( dbfTmpDoc )->( ordCondSet( "!Deleted()", {||!Deleted() } ) )
         ( dbfTmpDoc )->( ordCreate( cTmpDoc, "Recno", "Recno()", {|| Recno() } ) )
      end if

      /*
      A¤adimos desde el fichero de incidencias
      */

      if ( dbfFacPrvD )->( dbSeek( nFactura ) )
         while ( ( dbfFacPrvD )->cSerFac + Str( ( dbfFacPrvD )->nNumFac ) + ( dbfFacPrvD )->cSufFac == nFactura ) .AND. ( dbfFacPrvD )->( !eof() )
            dbPass( dbfFacPrvD, dbfTmpDoc, .t. )
            ( dbfFacPrvD )->( dbSkip() )
         end while
      end if

      ( dbfTmpDoc )->( dbGoTop() )

      /*
      Creamos el fichero de series------------------------------------------------
      */

      dbCreate( cTmpSer, aSqlStruct( aSerFacPrv() ), cLocalDriver() )
      dbUseArea( .t., cLocalDriver(), cTmpSer, cCheckArea( cDbf, @dbfTmpSer ), .f. )

      if !( dbfTmpSer )->( neterr() )
         ( dbfTmpSer )->( OrdCondSet( "!Deleted()", {||!Deleted() } ) )
         ( dbfTmpSer )->( OrdCreate( cTmpSer, "nNumLin", "Str( nNumLin, 4 ) + cRef", {|| Str( Field->nNumLin, 4 ) + Field->cRef } ) )
      end if

      /*
      A¤adimos desde el fichero de series-----------------------------------------
      */

      if ( dbfFacPrvS )->( dbSeek( nFactura ) )
         while ( ( dbfFacPrvS )->cSerFac + Str( ( dbfFacPrvS )->nNumFac ) + ( dbfFacPrvS )->cSufFac == nFactura .and. !( dbfFacPrvS )->( eof() ) )
            dbPass( dbfFacPrvS, dbfTmpSer, .t. )
            ( dbfFacPrvS )->( dbSkip() )
         end while
      end if

      ( dbfTmpSer )->( dbGoTop() )

      /*
      Creamos la tabla temporal de pagos a proveedores
      */

      dbCreate( cTmpPgo, aSqlStruct( aItmRecPrv() ), cLocalDriver() )
      dbUseArea( .t., cLocalDriver(), cTmpPgo, cCheckArea( cDbfPgo, @dbfTmpPgo ), .f. )
      if !( dbfTmpPgo )->( neterr() )

         ( dbfTmpPgo )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
         ( dbfTmpPgo )->( ordCreate( cTmpPgo, "cRecDev", "cRecDev", {|| Field->cRecDev } ) )

         ( dbfTmpPgo )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
         ( dbfTmpPgo )->( ordCreate( cTmpPgo, "nNumFac", "cSerFac + Str( nNumFac ) + cSufFac + Str( nNumRec )", {|| Field->cSerFac + Str( Field->nNumFac ) + Field->cSufFac + Str( Field->nNumRec ) }, ) )

         ( dbfTmpPgo )->( ordCondSet( "!Deleted()", {||!Deleted() } ) )
         ( dbfTmpPgo )->( ordCreate( cTmpPgo, "Recno", "Recno()", {|| Recno() } ) )

      end if

      /*
      A¤adimos desde el fichero de pagos
      */

      if ( dbfFacPrvP )->( dbSeek( nFactura ) ) .and. nMode != DUPL_MODE
         while ( ( dbfFacPrvP )->cSerFac + Str( ( dbfFacPrvP )->nNumFac ) + ( dbfFacPrvP )->cSufFac == nFactura ) .AND. ( dbfFacPrvP )->( !eof() )
            dbPass( dbfFacPrvP, dbfTmpPgo, .t. )
            ( dbfFacPrvP )->( dbSkip() )
         end while
      end if

      ( dbfTmpPgo )->( dbGoTop() )

      CursorWE()

   RECOVER USING oError

      msgStop( "Imposible crear tablas temporales." + CRLF + ErrorMessage( oError ) )

      KillTrans()

      lErrors     := .t.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lErrors )

//---------------------------------------------------------------------------//

STATIC FUNCTION EndTrans( aTmp, aGet, oBrw, oBrwLin, nMode, nDec, oDlg )

   local aTbl
   local nItem
   local nNumLin
   local cSerFac
   local nNumNFC
   local nNumFac
   local cSufFac
   local dFecFac
   local oError
   local oBlock

   if Empty( aTmp[ _CSERFAC ] )
      aTmp[ _CSERFAC ]  := "A"
   end if

   nNumLin              := 1
   cSerFac              := aTmp[ _CSERFAC ]
   nNumFac              := aTmp[ _NNUMFAC ]
   cSufFac              := aTmp[ _CSUFFAC ]
   dFecFac              := aTmp[ _DFECFAC ]

   /*
   Comprobamos la fecha del documento
   */

   if !lValidaOperacion( aTmp[ _DFECFAC ] )
      Return .f.
   end if

   /*
   Estos campos no pueden estar vacios
   */

   if Empty( aTmp[ _CCODPRV ] )
      msgStop( "Proveedor no puede estar vacío." )
      aGet[ _CCODPRV ]:SetFocus()
      return .f.
   end if

   if Empty( aTmp[ _CCODALM ] )
      msgStop( "Almacen no puede estar vacío." )
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

   if !aTmp[ _LFACGAS ] .and. ( dbfTmp )->( lastrec() ) == 0
      MsgStop( "No puede almacenar un documento sin líneas." )
      return .f.
   end if

   /*
   Para q nadie toque mientras grabamos
   */

   CursorWait()

   oDlg:Disable()

   oMsgText( "Archivando" )

   oBlock      := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   BeginTransaction()

   /*
   Primero hacer el RollBack
   */

   aTmp[ _DFECCHG ]  := GetSysDate()
   aTmp[ _CTIMCHG ]  := Time()

   /*
   RollBack en edici¢n de registros
   */

   do case
   case nMode == APPD_MODE .or. nMode == DUPL_MODE

      /*
      Obtenemos el nuevo numero de la factura----------------------------------
      */

      nNumFac           := nNewDoc( cSerFac, TDataView():FacturasProveedores( nView ), "NFACPRV", , dbfCount )
      aTmp[ _NNUMFAC ]  := nNumFac

      nNumNFC           := nNewNFC( cSerFac, TDataView():FacturasProveedores( nView ), "NFACPRV", dbfCount )
      aTmp[ _CNFC    ]  := nNumNFC

      aTmp[ _LIMPALB ]  := !Empty( aNumAlb ) .or. !Empty( aTmp[ _CNUMALB ] )

   case nMode == EDIT_MODE

      while ( dbfFacPrvL )->( dbSeek( cSerFac + str( nNumFac ) + cSufFac ) .and. !( dbfFacPrvL )->( eof() ) )
         if dbLock( dbfFacPrvL )
            ( dbfFacPrvL )->( dbDelete() )
            ( dbfFacPrvL )->( dbUnLock() )
         end if
      end while

      while ( dbfFacPrvI )->( dbSeek( cSerFac + str( nNumFac ) + cSufFac ) .and. !( dbfFacPrvI )->( eof() ) )
         if dbLock( dbfFacPrvI )
            ( dbfFacPrvI )->( dbDelete() )
            ( dbfFacPrvI )->( dbUnLock() )
         end if
      end while

      while ( dbfFacPrvD )->( dbSeek( cSerFac + str( nNumFac ) + cSufFac ) .and. !( dbfFacPrvD )->( eof() ) )
         if dbLock( dbfFacPrvD )
            ( dbfFacPrvD )->( dbDelete() )
            ( dbfFacPrvD )->( dbUnLock() )
         end if
      end while

      while ( dbfFacPrvP )->( dbSeek( cSerFac + str( nNumFac ) + cSufFac ) .and. !( dbfFacPrvP )->( eof() ) )
         if dbLock( dbfFacPrvP )
            ( dbfFacPrvP )->( dbDelete() )
            ( dbfFacPrvP )->( dbUnLock() )
         end if
      end while

      while ( dbfFacPrvS )->( dbSeek( cSerFac + Str( nNumFac ) + cSufFac ) )
         if dbLock( dbfFacPrvS )
            ( dbfFacPrvS )->( dbDelete() )
            ( dbfFacPrvS )->( dbUnLock() )
         end if
      end while

   end case

   /*
   Quitamos los filtros
   */

   ( dbfTmp )->( dbClearFilter() )

   oMsgProgress()
   oMsgProgress():SetRange( 0, ( dbfTmp )->( LastRec() ) )

   /*
   Ahora escribimos en el fichero definitivo
   */

   ( dbfTmp )->( dbGoTop() )
   while !( dbfTmp )->( eof() )

      aTbl                                               := dbScatter( dbfTmp )
      aTbl[ _CSERFAC ]                                   := cSerFac
      aTbl[ _NNUMFAC ]                                   := nNumFac
      aTbl[ _CSUFFAC ]                                   := cSufFac
      aTbl[ _LCHGLIN ]                                   := .f.
      aTbl[ _NPRECOM ]                                   := nNetUFacPrv( aTbl, aTmp, nDinDiv, nRinDiv ) //, aTmp[ _NVDVFAC ] )
      aTbl[ ( dbfFacPrvL )->( FieldPos( "dFecFac" ) ) ]  := aTmp[ _DFECFAC ]

      /*
      Comprobamos que exista el articulo en la base de datos----------------
      */

      AppRefPrv( aTbl[ _CREFPRV ], aTmp[ _CCODPRV ], aTbl[ _CREF ], aTbl[ _NDTOLIN ], aTbl[ _NDTOPRM ], aTmp[ _CDIVFAC ], aTbl[ _NPREUNIT ], dbfArtPrv )

      /*
      Cambios de precios-------------------------------------------------------
      */

      if ( dbfArticulo )->( dbSeek( ( dbfTmp )->cRef ) ) .and. ( dbfTmp )->lChgLin
         CambioPrecio( aTmp[ _DFECFAC ], dbfArticulo, dbfTmp )
      end if

      dbGather( aTbl, dbfFacPrvL, .t. )

      ( dbfTmp )->( dbSkip() )

      oMsgProgress():Deltapos(1)

   end while

   /*
   Ahora escribimos en el fichero definitivo de incidencias--------------------
   */

   ( dbfTmpInc )->( dbGoTop() )
   while ( dbfTmpInc )->( !eof() )
      dbPass( dbfTmpInc, dbfFacPrvI, .t., cSerFac, nNumFac, cSufFac )
      ( dbfTmpInc )->( dbSkip() )
   end while

   /*
   Ahora escribimos en el fichero definitivo de documentos--------------------
   */

   ( dbfTmpDoc )->( dbGoTop() )
   while ( dbfTmpDoc )->( !eof() )
      dbPass( dbfTmpDoc, dbfFacPrvD, .t., cSerFac, nNumFac, cSufFac )
      ( dbfTmpDoc )->( dbSkip() )
   end while

   /*
   Escribimos el fichero definitivo de series---------------------------------
   */

   ( dbfTmpSer )->( dbGoTop() )
   while ( dbfTmpSer )->( !eof() )
      dbPass( dbfTmpSer, dbfFacPrvS, .t., cSerFac, nNumFac, cSufFac, dFecFac )
      ( dbfTmpSer )->( dbSkip() )
   end while

   /*
   Si cambia el cliente en la factura, lo cambiamos en los recibos-------------
   */

   ( dbfTmpPgo )->( dbGoTop() )

   while ( dbfTmpPgo )->( !eof() )

      if ( dbfTmpPgo )->cCodPrv != aTmp[ _CCODPRV ]
         ( dbfTmpPgo )->cCodPrv := aTmp[ _CCODPRV ]
      end if

      if ( dbfTmpPgo )->cNomPrv != aTmp[ _CNOMPRV ]
         ( dbfTmpPgo )->cNomPrv := aTmp[ _CNOMPRV ]
      end if

      ( dbfTmpPgo )->( dbSkip() )

   end while

   /*
   Ahora escribimos en el fichero definitivo de pagos--------------------------
   */

   ( dbfTmpPgo )->( dbGoTop() )
   while ( dbfTmpPgo )->( !eof() )
      dbPass( dbfTmpPgo, dbfFacPrvP, .t., cSerFac, nNumFac, cSufFac )
      ( dbfTmpPgo )->( dbSkip() )
   end while

   /*
   Rellenamos los campos de los totales----------------------------------------
   */

   aTmp[ _NTOTNET ]  := nTotNet
   aTmp[ _NTOTSUP ]  := nTotSup
   aTmp[ _NTOTIVA ]  := nTotIva
   aTmp[ _NTOTREQ ]  := nTotReq
   aTmp[ _NTOTFAC ]  := nTotFac

   /*
   Grabamos las cabeceras de los albaranes-------------------------------------
   */

   WinGather( aTmp, , TDataView():FacturasProveedores( nView ), , nMode )

   /*
   Actualizamos el stock en la web------------------------------------------
   */

   ActualizaStockWeb( cSerFac + Str( nNumFac ) + cSufFac )

   /*
   Escribe los datos pendientes------------------------------------------------
   */

   CommitTransaction()

   /*
   Generar los pagos de las facturas-------------------------------------------
   */

   GenPgoFacPrv( cSerFac + Str( nNumFac ) + cSufFac, TDataView():FacturasProveedores( nView ), dbfFacPrvL, dbfFacPrvP, TDataView():Proveedores( nView ), dbfFPago, dbfDiv )

   if nMode == APPD_MODE

      if Len( aNumAlb ) > 0

         for nItem := 1 to Len( aNumAlb )

            if ( dbfAlbPrvT )->( dbSeek( aNumAlb[ nItem ] ) )

               /*
               Ponemos el albaran como facturado-------------------------------
               */

               SetFacturadoAlbaranProveedor( .t., , , dbfAlbPrvT, dbfAlbPrvL, dbfAlbPrvS, cSerFac + Str( nNumFac ) + cSufFac )

               /*
               Rollback de los stocks------------------------------------------
               */

               //oStock:AlbPrv( aNumAlb[ nItem ], ( dbfAlbPrvT )->cCodAlm, ( dbfAlbPrvT )->cNumPed, .f., .f., .t., .f. )

            end if

         next

      end if

   end if

   RECOVER USING oError

      RollBackTransaction()

      msgStop( ErrorMessage( oError ), "Imposible almacenar documentos"  )

   END SEQUENCE
   ErrorBlock( oBlock )

   oMsgText()
   EndProgress()

   oDlg:Enable()
   oDlg:End( IDOK )

   CursorWE()

RETURN .T.

//------------------------------------------------------------------------//

STATIC FUNCTION KillTrans( oBrwLin )

   /*
   Borramos los ficheros
   */

   if !Empty( dbfTmp ) .and. ( dbfTmp )->( Used() )
      ( dbfTmp )->( dbCloseArea() )
   end if

   if !Empty( dbfTmpInc ) .and. ( dbfTmpInc )->( Used() )
      ( dbfTmpInc )->( dbCloseArea() )
   end if

   if !Empty( dbfTmpDoc ) .and. ( dbfTmpDoc )->( Used() )
      ( dbfTmpDoc )->( dbCloseArea() )
   end if

   if !Empty( dbfTmpPgo ) .and. ( dbfTmpPgo )->( Used() )
      ( dbfTmpPgo )->( dbCloseArea() )
   end if

   if !Empty( dbfTmpSer ) .and. ( dbfTmpSer )->( Used() )
      ( dbfTmpSer )->( dbCloseArea() )
   end if

   dbfTmp            := nil
   dbfTmpInc         := nil
   dbfTmpDoc         := nil
   dbfTmpPgo         := nil
   dbfTmpSer         := nil

   dbfErase( cNewFile )
   dbfErase( cTmpInc  )
   dbfErase( cTmpDoc  )
   dbfErase( cTmpPgo  )
   dbfErase( cTmpSer  )

   aNumAlb           := {}

   if !Empty( oMnuRec )
      oMnuRec:End()
   end if

   memory( -1 )

   if oBrwLin != nil
      oBrwLin:CloseData()
   end if

RETURN NIL

//------------------------------------------------------------------------//

STATIC FUNCTION CreateFiles( cPath )

   if !lExistTable( cPath + "FACPRVT.DBF" )
      dbCreate( cPath + "FACPRVT.DBF", aSqlStruct( aItmFacPrv() ), cDriver() )
   end if
   if !lExistTable( cPath + "FACPRVL.DBF" )
      dbCreate( cPath + "FACPRVL.DBF", aSqlStruct( aColFacPrv() ), cDriver() )
   end if
   if !lExistTable( cPath + "FACPRVI.DBF" )
      dbCreate( cPath + "FACPRVI.DBF", aSqlStruct( aIncFacPrv() ), cDriver() )
   end if
   if !lExistTable( cPath + "FACPRVD.DBF" )
      dbCreate( cPath + "FACPRVD.DBF", aSqlStruct( aFacPrvDoc() ), cDriver() )
   end if
   if !lExistTable( cPath + "FACPRVS.DBF" )
      dbCreate( cPath + "FACPRVS.DBF", aSqlStruct( aSerFacPrv() ), cDriver() )
   end if

RETURN NIL

//----------------------------------------------------------------------------//

/*
Cambia el estado de una factura
*/

STATIC FUNCTION ChgContabilizado( lContabilizado, cFactura, nAsiento, oTree )

   local lReturn  := .t.

   if dbDialogLock( TDataView():FacturasProveedores( nView ) )
      ( TDataView():FacturasProveedores( nView ) )->lContab := lContabilizado
      ( TDataView():FacturasProveedores( nView ) )->( dbUnlock() )
   else
      lReturn     := .f.
   end if

   if !Empty( oTree )
      oTree:Select( oTree:Add( "Factura : " + Rtrim( cFactura ) + " asiento generado num. " + Alltrim( Str( nAsiento ) ), 1 ) )
   end if

Return ( lReturn )

//-------------------------------------------------------------------------//

STATIC FUNCTION ImpFactura( oBrw, aGet, aTmp )

   local oDlg
   local oBrwFac
   local oGetDes
   local cGetDes
   local cSelFac  := ""
   local aLinFac  := {}

   local nChgDiv  := aTmp[ _NVDVFAC ]

   IF Empty( aGet[ _CCODPRV ]:varGet() )
      msgStop( "Es necesario codificar un proveedor" )
      RETURN .T.
   END IF

   DEFINE DIALOG oDlg RESOURCE "IMPFACPRV"

      REDEFINE GET oGetDes VAR cGetDes;
         ID       110 ;
         COLOR    CLR_GET ;
         VALID    ( loadFac( cGetDes, oBrwFac, @aLinFac ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( oGetDes:cText( cGetFile( "*.dat", "Seleccione el fichero de la factura" ) ) );
         OF       oDlg

      REDEFINE LISTBOX oBrwFac ;
         VAR      cSelFac ;
         ITEMS    {} ;
         ID       120 ;
         OF       oDlg

      REDEFINE BUTTON ;
         ID       IDOK ;
         OF       oDlg ;
         ACTION   (  appdFac( aGet, cSelFac, oBrwFac:aItems, aLinFac, nChgDiv ),;
                     oDlg:end( IDOK ) )

      REDEFINE BUTTON ;
         ID       IDCANCEL ;
         OF       oDlg ;
         CANCEL ;
         ACTION   ( oDlg:end() )

      ACTIVATE DIALOG oDlg CENTER

RETURN NIL

//--------------------------------------------------------------------------//

/*
Esta funcion carga las facturas y sus lineas en dos arrays
*/

STATIC FUNCTION loadFac( cGetDes, oBrwFac, aLinFac )

   local a1
   local a2
   local cIni
   local cSep
   local oText
   local nCont    := 0

   IF empty( cGetDes )
      RETURN .T.
   END IF

   CursorWait()

   IF file( cGetDes )

      oText          := TTxtFile():New( cGetDes )
      oText:Open()

      /*
      Inicializamos los valores
      */

      aLinFac        := {}
      oBrwFac:reset()

      /*
      Cabeceras de la factura
      */

      WHILE !oText:lEof()

         a1 := oText:cGetStr( 6 )
               oText:cGetStr( 1 )
         a2 := oText:cGetStr( 6 )
               oText:cGetStr( 1 )

         ++nCont
         aadd( aLinFac, {} )

         oBrwFac:Add( a1 + space( 1 ) + substr( a2, 1, 2 ) + "/" + substr( a2, 3, 2 ) + "/" + substr( a2, 5, 2 ) )

         WHILE !oText:lEof()

            /*
            Avanzadilla en la lectura
            */

            cIni  := oText:cGetStr( 1 )

            IF cIni == chr( 255 )
               EXIT
            END IF

            /*
            A¤adimos la linea de detalle a un array
            */

            aadd( aLinFac[ nCont ],;
                              {  cIni + oText:cGetStr( 5 ),;   // "Codigo interno"
                                 oText:cGetStr( 13 ),;         // "Codigo Barras"
                                 oText:cGetStr( 30 ),;         // "Descripción"
                                 oText:cGetStr(  7 ),;         // "Unidades"
                                 oText:cGetStr(  7 ),;         // "Coste"
                                 oText:cGetStr(  1 ) } )       // "tipo " + cImp()

            /*
            Estudiamos el separador
            */

            cSep  := oText:cGetStr( 1 )

            IF cSep == chr( 254 )
               LOOP
            END IF

         END WHILE

      END WHILE

      oText:Close()

   ELSE

      msgStop( "Fichero no encontrado" )

   END IF

   oBrwFac:setFocus()

   CursorWe()

RETURN .T.

//--------------------------------------------------------------------------//

/*
A¤ade las lineas de detalle al fichero definitivamente
*/

STATIC FUNCTION appdFac( aGet, cSelFac, aSelFac, aLinFac, nChgDiv )

   local n
   local nIva
   local nSelFac

   nSelFac     := AScan( aSelFac, { | cItem | Upper( AllTrim( cItem ) ) == Upper( AllTrim( cSelFac ) ) } )
   if nSelFac  != 0

      aGet[ _CSUPED ]:cText( substr( cSelFac, 1, 6 ) )

      FOR n := 1 TO len( aLinFac[ nSelFac ] )

         (dbfTmp)->( dbAppend() )

         (dbfTmp)->CREF       := aLinFac[ nSelFac, n, 1 ]
         (dbfTmp)->CDETALLE   := aLinFac[ nSelFac, n, 3 ]
         (dbfTmp)->NUNICAJA   := val( aLinFac[ nSelFac, n, 4 ] ) / 100
         (dbfTmp)->NPREUNIT   := val( aLinFac[ nSelFac, n, 5 ] ) / 100

         /*
         Ojo esto es una chapuza para FECA
         */

         DO CASE
         CASE aLinFac[ nSelFac, n, 6 ] == "1"
            nIva  := 7
         CASE aLinFac[ nSelFac, n, 6 ] == "2"
            nIva  := 16
         CASE aLinFac[ nSelFac, n, 6 ] == "3"
            nIva  := 4
         END CASE

         (dbfTmp)->NIVA       := nIva

         /*
         Buscamos valores anteriores del Articulo
         */

         IF ( dbfArticulo )->( DbSeek( ( dbfTmp )->CREF ) )

            /*
            Marcamos el cambio de precio
            */

            IF (dbfTmp)->NPREUNIT != ( dbfArticulo )->PCOSTO / nChgDiv
               (dbfTmp)->LCHGLIN := .T.
            END IF

            /*
            Cargamos los valores por defecto de la factura
            */

            (dbfTmp)->NBNFLIN1   := ( dbfArticulo )->BENEF1
            (dbfTmp)->NBNFLIN2   := ( dbfArticulo )->BENEF2
            (dbfTmp)->NBNFLIN3   := ( dbfArticulo )->BENEF3
            (dbfTmp)->NBNFLIN4   := ( dbfArticulo )->BENEF4
            (dbfTmp)->NBNFLIN5   := ( dbfArticulo )->BENEF5
            (dbfTmp)->NBNFLIN6   := ( dbfArticulo )->BENEF6

            /*
            Calculamos con los nuevos datos con la nueva base mas los viejos
            porcentajes de beneficios.
            */

            (dbfTmp)->NPVPLIN1   := ( dbfTmp )->NPREUNIT * ( dbfTmp )->NBNFLIN1 / 100 + ( dbfTmp )->NPREUNIT
            IF ( dbfArticulo )->LIVAINC
               (dbfTmp)->NPVPLIN1 += (dbfTmp)->NPVPLIN1 * nIva / 100
            END IF

            (dbfTmp)->NPVPLIN2   := ( dbfTmp )->NPREUNIT * ( dbfTmp )->NBNFLIN2 / 100 + ( dbfTmp )->NPREUNIT
            IF ( dbfArticulo )->LIVAINC
               (dbfTmp)->NPVPLIN2 += (dbfTmp)->NPVPLIN2 * nIva / 100
            END IF

            (dbfTmp)->NPVPLIN3   := ( dbfTmp )->NPREUNIT * ( dbfTmp )->NBNFLIN3 / 100 + ( dbfTmp )->NPREUNIT
            IF ( dbfArticulo )->LIVAINC
               (dbfTmp)->NPVPLIN3 += (dbfTmp)->NPVPLIN3 * nIva / 100
            END IF

            (dbfTmp)->NPVPLIN4   := ( dbfTmp )->NPREUNIT * ( dbfTmp )->NBNFLIN4 / 100 + ( dbfTmp )->NPREUNIT
            IF ( dbfArticulo )->LIVAINC
               (dbfTmp)->NPVPLIN4 += (dbfTmp)->NPVPLIN4 * nIva / 100
            END IF

            (dbfTmp)->NPVPLIN5   := ( dbfTmp )->NPREUNIT * ( dbfTmp )->NBNFLIN5 / 100 + ( dbfTmp )->NPREUNIT
            IF ( dbfArticulo )->LIVAINC
               (dbfTmp)->NPVPLIN5 += (dbfTmp)->NPVPLIN5 * nIva / 100
            END IF

            (dbfTmp)->NPVPLIN6   := ( dbfTmp )->NPREUNIT * ( dbfTmp )->NBNFLIN6 / 100 + ( dbfTmp )->NPREUNIT
            IF ( dbfArticulo )->LIVAINC
               (dbfTmp)->NPVPLIN6 += (dbfTmp)->NPVPLIN6 * nIva / 100
            END IF

         ELSE

            (dbfTmp)->LCHGLIN    := .T.

         END IF

      NEXT

      (dbfTmp)->( dbGoTop() )

   END IF

RETURN NIL

//---------------------------------------------------------------------------//

static function lNotOpen()

   if NetErr()
      msgStop( "Imposible abrir ficheros." )
      CloseFiles()
      return .t.
   end if

return .f.

//--------------------------------------------------------------------------//

/*
Comprueba q no existan recibos pagados
*/

static function lRecibosPagados( uFacPrv, dbfFacPrvP )

   local cNumFac
   local lRecPgd  := .f.
   local nRecAct  := ( dbfFacPrvP )->( Recno() )
   local nOrdAct  := ( dbfFacPrvP )->( OrdSetFocus( "NNUMFAC" ) )

   if ValType( uFacPrv ) == "A"
      cNumFac     := uFacPrv[ _CSERFAC ] + Str( uFacPrv[ _NNUMFAC ], 9 ) + uFacPrv[ _CSUFFAC ]
   else
      cNumFac     := ( uFacPrv )->CSERFAC + Str( ( uFacPrv )->NNUMFAC ) + ( uFacPrv )->CSUFFAC
   end if

   if ( dbfFacPrvP )->( dbSeek( cNumFac ) )
      while cNumFac == ( dbfFacPrvP )->cSerFac + Str( ( dbfFacPrvP )->nNumFac ) + ( dbfFacPrvP )->cSufFac .and. !( dbfFacPrvP )->( eof() )
         if ( dbfFacPrvP )->lCobrado .and. !( dbfFacPrvP )->lDevuelto
            lRecPgd   := .t.
            exit
         end if
         ( dbfFacPrvP )->( dbSkip() )
      end while
   end if

   ( dbfFacPrvP )->( OrdSetFocus( nOrdAct ) )
   ( dbfFacPrvP )->( dbGoTo( nRecAct) )

return ( lRecPgd )

//----------------------------------------------------------------------------//

static function lGenFac( oBrw, oBtn, nDevice )

   local bAction

   DEFAULT nDevice   := IS_PRINTER

   if Empty( oBtn )
      return nil
   end if

   IF !( dbfDoc )->( dbSeek( "FP" ) )

         DEFINE BTNSHELL RESOURCE "DOCUMENT" OF oWndBrw ;
            NOBORDER ;
            ACTION   ( msgStop( "No hay facturas de proveedores predefinidos" ) );
            TOOLTIP  "No hay documentos" ;
            HOTKEY   "N";
            FROM     oBtn ;
            CLOSED ;
            LEVEL    ACC_EDIT

   ELSE

      WHILE ( dbfDoc )->cTipo == "FP" .AND. !( dbfDoc )->( eof() )

         bAction  := bGenFac( nDevice, "Imprimiendo facturas de proveedores", ( dbfDoc )->Codigo )

         oWndBrw:NewAt( "Document", , , bAction, Rtrim( ( dbfDoc )->cDescrip ) , , , , , oBtn )

         ( dbfDoc )->( dbSkip() )

      END DO

   END IF

   SysRefresh()

return nil

//---------------------------------------------------------------------------//

static function bGenFac( nDevice, cTitle, cCodDoc )

   local bGen
   local nDev  := by( nDevice )
   local cTit  := by( cTitle  )
   local cCod  := by( cCodDoc )

   if nDev == IS_PRINTER
      bGen     := {|| nGenFacPrv( nDevice, cTit, cCod ) }
   else
      bGen     := {|| nGenFacPrv( nDevice, cTit, cCod ) }
   end if

return bGen

//---------------------------------------------------------------------------//

Static Function QuiFacPrv( lDetail )

   local nOrdAnt
   local cFactura

   DEFAULT lDetail   := .t.

   if ( TDataView():FacturasProveedores( nView ) )->lCloFac .and. !oUser():lAdministrador()
      msgStop( "Solo puede eliminar facturas cerradas los administradores." )
      Return .f.
   end if

   CursorWait()

   cFactura          := ( TDataView():FacturasProveedores( nView ) )->cSerFac + Str( ( TDataView():FacturasProveedores( nView ) )->nNumFac ) + ( TDataView():FacturasProveedores( nView ) )->cSufFac

   if lDetail
      DelDetalle( cFactura )
   end if

   /*
   Restaura los Albaranes caso de estar facturados-----------------------------
   */

   nOrdAnt           := ( dbfAlbPrvT )->( OrdSetFocus( "cNumFac" ) )

   if ( dbfAlbPrvT )->( dbSeek( cFactura ) )

      while ( dbfAlbPrvT )->cNumFac == cFactura .and. !( dbfAlbPrvT )->( eof() )

         SetFacturadoAlbaranProveedor( .f., oStock, , dbfAlbPrvT, dbfAlbPrvL, dbfAlbPrvS )

         ( dbfAlbPrvT )->( dbSkip() )

      end while

   end if

   ( dbfAlbPrvT )->( OrdSetFocus( nOrdAnt ) )

   if uFieldEmpresa( "LRECNUMFAC" )
      nPutDoc( ( TDataView():FacturasProveedores( nView ) )->cSerFac, ( TDataView():FacturasProveedores( nView ) )->nNumFac, ( TDataView():FacturasProveedores( nView ) )->cSufFac, TDataView():FacturasProveedores( nView ), "nFacPrv" )
   end if

   CursorWE()

Return .t.

//--------------------------------------------------------------------------//

Static Function DelDetalle( cFactura )

   local nOrdAnt

   DEFAULT cFactura  := ( TDataView():FacturasProveedores( nView ) )->cSerFac + Str( ( TDataView():FacturasProveedores( nView ) )->nNumFac ) + ( TDataView():FacturasProveedores( nView ) )->cSufFac

   CursorWait()

   /*
   Eliminamos los apuntes de stocks--------------------------------------------
   */

   nOrdAnt           := ( dbfFacPrvL )->( OrdSetFocus( "nNumFac" ) )

   while ( dbfFacPrvL )->( dbSeek( cFactura ) ) .and. !( dbfFacPrvL )->( eof() )
      if dbDialogLock( dbfFacPrvL )
         ( dbfFacPrvL )->( dbDelete() )
         ( dbfFacPrvL )->( dbUnLock() )
      end if
   end do

   ( dbfFacPrvL )->( OrdSetFocus( nOrdAnt ) )

   while ( dbfFacPrvP )->( dbSeek( cFactura ) ) .and. !( dbfFacPrvP )->( eof() )
      if dbLock( dbfFacPrvP )
         ( dbfFacPrvP )->( dbDelete() )
         ( dbfFacPrvP )->( dbUnLock() )
      end if
   end do

   while ( dbfFacPrvI )->( dbSeek( cFactura ) .and. !( dbfFacPrvI )->( eof() ) )
      if dbLock( dbfFacPrvI )
         ( dbfFacPrvI )->( dbDelete() )
         ( dbfFacPrvI )->( dbUnLock() )
      end if
   end while

   while ( dbfFacPrvD )->( dbSeek( cFactura ) .and. !( dbfFacPrvD )->( eof() ) )
      if dbLock( dbfFacPrvD )
         ( dbfFacPrvD )->( dbDelete() )
         ( dbfFacPrvD )->( dbUnLock() )
      end if
   end while

   while ( dbfFacPrvS )->( dbSeek( cFactura ) .and. !( dbfFacPrvS )->( eof() ) )
      if dbLock( dbfFacPrvS )
         ( dbfFacPrvS )->( dbDelete() )
         ( dbfFacPrvS )->( dbUnLock() )
      end if
   end while

   CursorWe()

RETURN NIL

//--------------------------------------------------------------------------//

STATIC FUNCTION lLiquida( oBrw, cFactura, cDivFac )

   DEFAULT cFactura  := ( TDataView():FacturasProveedores( nView ) )->cSerFac + Str( ( TDataView():FacturasProveedores( nView ) )->nNumFac ) + ( TDataView():FacturasProveedores( nView ) )->cSufFac
   DEFAULT cDivFac   := ( TDataView():FacturasProveedores( nView ) )->cDivFac

   if ( TDataView():FacturasProveedores( nView ) )->lLiquidada
      MsgStop( "Factura ya pagada" )
      return .f.
   end if

   /*
   Comporbamos si existen recibos de esta factura
   */

   ( dbfFacPrvP )->( dbGoTop() )

   if ( dbfFacPrvP )->( dbSeek( cFactura ) )

      while ( dbfFacPrvP )->cSerFac + Str( ( dbfFacPrvP )->nNumFac ) + ( dbfFacPrvP )->cSufFac == cFactura .and. !( dbfFacPrvP )->( eof() )

         if Empty( ( dbfFacPrvP )->cTipRec ) .and. !( dbfFacPrvP )->lCobrado

            EdtRecPrv( ( dbfFacPrvP )->cSerFac + Str( ( dbfFacPrvP )->nNumFac ) + ( dbfFacPrvP )->cSufFac, .f. )

            exit

         end if

         ( dbfFacPrvP )->( dbSkip() )

      end do

      /*
      Chequea si la factura esta liquidada----------------------------------------
      */

      ChkLqdFacPrv( nil, TDataView():FacturasProveedores( nView ), dbfFacPrvL, dbfFacPrvP, dbfIva, dbfDiv )

   end if

   oBrw:Refresh()
   oBrw:SetFocus()

return .t.

//---------------------------------------------------------------------------//

Static Function nEstadoIncidencia( cNumFac )

   local nEstado  := 0

   if ( dbfFacPrvI )->( dbSeek( cNumFac ) )

      while ( dbfFacPrvI )->cSerie + Str( ( dbfFacPrvI )->nNumFac ) + ( dbfFacPrvI )->cSufFac == cNumFac .and. !( dbfFacPrvI )->( Eof() )

         if ( dbfFacPrvI )->lListo
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

         ( dbfFacPrvI )->( dbSkip() )

      end while

   end if

Return ( nEstado )

//---------------------------------------------------------------------------//

static function lRecibosPagadosTmp( dbfTmpPgo )

   local lRecPgd  := .f.
   local nRecAct  := ( dbfTmpPgo )->( Recno() )

   while !( dbfTmpPgo )->( eof() )
      if ( dbfTmpPgo )->lCobrado .and. !( dbfTmpPgo )->lDevuelto
         lRecPgd  := .t.
         exit
      end if
      ( dbfTmpPgo )->( dbSkip() )
   end while

   ( dbfTmpPgo )->( dbGoTo( nRecAct) )

return ( lRecPgd )

//---------------------------------------------------------------------------//

static function ShowKitFacPrv( dbfMaster, oBrw, cCodPrv, dbfTmpInc, aGet, aTmp, aControl, oSayGas, oSayLabels, oBrwIva )

   if !Empty( aGet )

      if lUsrMaster() .or. oUser():lCambiarPrecio()
         aGet[ ( dbfMaster )->( FieldPos( "lRecargo" ) ) ]:HardEnable()
      else
         aGet[ ( dbfMaster )->( FieldPos( "lRecargo" ) ) ]:HardDisable()
      end if

      if !Empty( cCodPrv )
         aGet[ ( dbfMaster )->( FieldPos( "cCodPrv" ) ) ]:cText( cCodPrv )
         aGet[ ( dbfMaster )->( FieldPos( "cCodPrv" ) ) ]:lValid()
      end if

      aGet[ ( dbfMaster )->( FieldPos( "cCodPrv" ) ) ]:SetFocus()

      aGet[ ( dbfMaster )->( FieldPos( "SubCta" ) ) ]:lValid()

      if !Empty( aTmp ) .and. aTmp[ _LFACGAS ]

         oBrw:Hide()
         oBrwIva:Hide()
         aEval( aControl, {| o | o:Hide() } )

         oSayLabels[1]:Hide()
         oSayLabels[2]:Hide()
         oSayLabels[3]:Hide()
         oSayLabels[4]:Hide()
         oSayLabels[5]:Hide()

         aGet[ _CDTOESP ]:Hide()
         aGet[ _CDPP    ]:Hide()
         aGet[ _NDTOESP ]:Hide()
         aGet[ _NDPP    ]:Hide()
         aGet[ _CDTOUNO ]:Hide()
         aGet[ _NDTOUNO ]:Hide()
         aGet[ _CDTODOS ]:Hide()
         aGet[ _NDTODOS ]:Hide()

         aEval( oSayGas, {| o | o:Show() } )

         aGet[ _MCOMGAS  ]:Show()
         aGet[ _NNETGAS1 ]:Show()
         aGet[ _NNETGAS2 ]:Show()
         aGet[ _NNETGAS3 ]:Show()
         aGet[ _NIVAGAS1 ]:Show()
         aGet[ _NIVAGAS2 ]:Show()
         aGet[ _NIVAGAS3 ]:Show()
         aGet[ _NREGAS1  ]:Show()
         aGet[ _NREGAS2  ]:Show()
         aGet[ _NREGAS3  ]:Show()

      else

         oBrw:Show()
         oBrwIva:Show()
         aEval( aControl, {| o | o:Show() } )

         oSayLabels[1]:Show()
         oSayLabels[2]:Show()
         oSayLabels[3]:Show()
         oSayLabels[4]:Show()
         oSayLabels[5]:Show()

         aGet[ _CDTOESP ]:Show()
         aGet[ _CDPP    ]:Show()
         aGet[ _NDTOESP ]:Show()
         aGet[ _NDPP    ]:Show()
         aGet[ _CDTOUNO ]:Show()
         aGet[ _NDTOUNO ]:Show()
         aGet[ _CDTODOS ]:Show()
         aGet[ _NDTODOS ]:Show()

         aEval( oSayGas, {| o | o:Hide() } )

         aGet[ _MCOMGAS  ]:Hide()
         aGet[ _MCOMGAS  ]:Hide()
         aGet[ _NNETGAS1 ]:Hide()
         aGet[ _NNETGAS2 ]:Hide()
         aGet[ _NNETGAS3 ]:Hide()
         aGet[ _NIVAGAS1 ]:Hide()
         aGet[ _NIVAGAS2 ]:Hide()
         aGet[ _NIVAGAS3 ]:Hide()
         aGet[ _NREGAS1  ]:Hide()
         aGet[ _NREGAS2  ]:Hide()
         aGet[ _NREGAS3  ]:Hide()

      end if

   end if

   /*
   Hace que salte la incidencia al entrar en el documento----------------------
   */

   if !Empty( dbfTmpInc )

      while !( dbfTmpInc )->( Eof() )
         if ( dbfTmpInc )->lAviso .and. !( dbfTmpInc )->lListo
            MsgInfo( Trim( ( dbfTmpInc )->mDesInc ), "¡Incidencia!" )
         end if
         ( dbfTmpInc )->( dbSkip() )
      end while

      ( dbfTmpInc )->( dbGoTop() )

   end if

   oBrw:Refresh()

return nil

//----------------------------------------------------------------------------//

STATIC FUNCTION ValidaMedicion( aTmp, aGet )

   local cNewUndMed  := aGet[ _CUNIDAD ]:VarGet

   /*
   Cargamos el codigo de las unidades---------------------------------
   */

   if ( Empty( cOldUndMed ) .or. cOldUndMed != cNewUndMed )

      if oUndMedicion:oDbf:Seek( aTmp[ _CUNIDAD ] )

         if oUndMedicion:oDbf:nDimension >= 1 .and. !Empty( oUndMedicion:oDbf:cTextoDim1 )
            if !Empty( aGet[ ( dbfFacPrvL )->( fieldpos( "nMedUno" ) ) ] )
               aGet[ ( dbfFacPrvL )->( fieldpos( "nMedUno" ) ) ]:oSay:SetText( oUndMedicion:oDbf:cTextoDim1 )
               aGet[ ( dbfFacPrvL )->( fieldpos( "nMedUno" ) ) ]:cText( ( dbfArticulo )->nLngArt )
               aGet[ ( dbfFacPrvL )->( fieldpos( "nMedUno" ) ) ]:Show()
            else
               aTmp[ ( dbfFacPrvL )->( fieldpos( "nMedUno" ) ) ]  := ( dbfArticulo )->nLngArt
            end if
         else
            if !Empty( aGet[ ( dbfFacPrvL )->( fieldpos( "nMedUno" ) ) ] )
               aGet[ ( dbfFacPrvL )->( fieldpos( "nMedUno" ) ) ]:cText( 0 )
               aGet[ ( dbfFacPrvL )->( fieldpos( "nMedUno" ) ) ]:Hide()
            else
               aTmp[ ( dbfFacPrvL )->( fieldpos( "nMedUno" ) ) ]  := 0
            end if
         end if

         if oUndMedicion:oDbf:nDimension >= 1 .and. !Empty( oUndMedicion:oDbf:cTextoDim2 )
            if !Empty( aGet[ ( dbfFacPrvL )->( fieldpos( "nMedDos" ) ) ] )
               aGet[ ( dbfFacPrvL )->( fieldpos( "nMedDos" ) ) ]:oSay:SetText( oUndMedicion:oDbf:cTextoDim2 )
               aGet[ ( dbfFacPrvL )->( fieldpos( "nMedDos" ) ) ]:cText( ( dbfArticulo )->nAltArt )
               aGet[ ( dbfFacPrvL )->( fieldpos( "nMedDos" ) ) ]:Show()
            else
               aTmp[ ( dbfFacPrvL )->( fieldpos( "nMedDos" ) ) ]  := ( dbfArticulo )->nAltArt
            end if

         else
            if !Empty( aGet[ ( dbfFacPrvL )->( fieldpos( "nMedDos" ) ) ] )
               aGet[ ( dbfFacPrvL )->( fieldpos( "nMedDos" ) ) ]:cText( 0 )
               aGet[ ( dbfFacPrvL )->( fieldpos( "nMedDos" ) ) ]:Hide()
            else
                 aTmp[ ( dbfFacPrvL )->( fieldpos( "nMedDos" ) ) ]  := 0
            end if
         end if

         if oUndMedicion:oDbf:nDimension >= 1 .and. !Empty( oUndMedicion:oDbf:cTextoDim3 )
            if !Empty( aGet[ ( dbfFacPrvL )->( fieldpos( "nMedTre" ) ) ] )
               aGet[ ( dbfFacPrvL )->( fieldpos( "nMedTre" ) ) ]:oSay:SetText( oUndMedicion:oDbf:cTextoDim3 )
               aGet[ ( dbfFacPrvL )->( fieldpos( "nMedTre" ) ) ]:cText( ( dbfArticulo ) ->nAncArt )
               aGet[ ( dbfFacPrvL )->( fieldpos( "nMedTre" ) ) ]:Show()
            else
               aTmp[ ( dbfFacPrvL )->( fieldpos( "nMedTre" ) ) ]  := ( dbfArticulo )->nAncArt
            end if
         else
            if !Empty( aGet[ ( dbfFacPrvL )->( fieldpos( "nMedTre" ) ) ] )
               aGet[ ( dbfFacPrvL )->( fieldpos( "nMedTre" ) ) ]:cText( 0 )
               aGet[ ( dbfFacPrvL )->( fieldpos( "nMedTre" ) ) ]:Hide()
            else
               aTmp[ ( dbfFacPrvL )->( fieldpos( "nMedTre" ) ) ]  := 0
            end if
         end if

      else

         if !Empty( aGet[ ( dbfFacPrvL )->( fieldpos( "nMedUno" ) ) ] )
            aGet[ ( dbfFacPrvL )->( fieldpos( "nMedUno" ) ) ]:Hide()
            aGet[ ( dbfFacPrvL )->( fieldpos( "nMedUno" ) ) ]:cText( 0 )
         end if

         if !Empty( aGet[ ( dbfFacPrvL )->( fieldpos( "nMedDos" ) ) ] )
            aGet[ ( dbfFacPrvL )->( fieldpos( "nMedDos" ) ) ]:Hide()
            aGet[ ( dbfFacPrvL )->( fieldpos( "nMedDos" ) ) ]:cText( 0 )
         end if

         if !Empty( aGet[ ( dbfFacPrvL )->( fieldpos( "nMedTre" ) ) ] )
            aGet[ ( dbfFacPrvL )->( fieldpos( "nMedTre" ) ) ]:Hide()
            aGet[ ( dbfFacPrvL )->( fieldpos( "nMedTre" ) ) ]:cText( 0 )
         end if

      end if

      cOldUndMed := cNewUndMed

   end if

RETURN .t.

//---------------------------------------------------------------------------//

Static Function DataLabel( oFr, lTemporal )

   /*
   Zona de datos------------------------------------------------------------
   */

   oFr:ClearDataSets()

   if lTemporal
      oFr:SetWorkArea(  "Lineas de facturas", ( tmpFacPrvL )->( Select() ), .f., { FR_RB_FIRST, FR_RE_LAST, 0 } )
   else
      oFr:SetWorkArea(  "Lineas de facturas", ( dbfFacPrvL )->( Select() ), .f., { FR_RB_FIRST, FR_RE_COUNT, 20 } )
   end if

   oFr:SetFieldAliases( "Lineas de facturas", cItemsToReport( aColFacPrv() ) )

   oFr:SetWorkArea(     "Facturas", ( TDataView():FacturasProveedores( nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Facturas", cItemsToReport( aItmFacPrv() ) )

   oFr:SetWorkArea(     "Artículos", ( dbfArticulo )->( Select() ) )
   oFr:SetFieldAliases( "Artículos", cItemsToReport( aItmArt() ) )

   oFr:SetWorkArea(     "Precios por propiedades", ( dbfArtCom )->( Select() ) )
   oFr:SetFieldAliases( "Precios por propiedades", cItemsToReport( aItmVta() ) )

   oFr:SetWorkArea(     "Incidencias de facturas", ( dbfFacPrvI )->( Select() ) )
   oFr:SetFieldAliases( "Incidencias de facturas", cItemsToReport( aIncFacPrv() ) )

   oFr:SetWorkArea(     "Documentos de facturas", ( dbfFacPrvD )->( Select() ) )
   oFr:SetFieldAliases( "Documentos de facturas", cItemsToReport( aFacPrvDoc() ) )

   oFr:SetWorkArea(     "Empresa", ( dbfEmp )->( Select() ) )
   oFr:SetFieldAliases( "Empresa", cItemsToReport( aItmEmp() ) )

   oFr:SetWorkArea(     "Proveedores", ( TDataView():Proveedores( nView ) )->( Select() ) )
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

   oFr:SetWorkArea(     "Bancos", ( dbfPrvBnc )->( Select() ) )
   oFr:SetFieldAliases( "Bancos", cItemsToReport( aPrvBnc() ) )

   if lTemporal
      oFr:SetMasterDetail( "Lineas de facturas", "Facturas",                  {|| ( tmpFacPrvL )->cSerFac + Str( ( tmpFacPrvL )->nNumFac ) + ( tmpFacPrvL )->cSufFac } )
      oFr:SetMasterDetail( "Lineas de facturas", "Artículos",                 {|| ( tmpFacPrvL )->cRef } )
      oFr:SetMasterDetail( "Lineas de facturas", "Precios por propiedades",   {|| ( tmpFacPrvL )->cRef + ( tmpFacPrvL )->cCodPr1 + ( tmpFacPrvL )->cCodPr2 + ( tmpFacPrvL )->cValPr1 + ( tmpFacPrvL )->cValPr2 } )
      oFr:SetMasterDetail( "Lineas de facturas", "Incidencias de facturas",   {|| ( tmpFacPrvL )->cSerFac + Str( ( tmpFacPrvL )->nNumFac ) + ( tmpFacPrvL )->cSufFac } )
      oFr:SetMasterDetail( "Lineas de facturas", "Documentos de facturas",    {|| ( tmpFacPrvL )->cSerFac + Str( ( tmpFacPrvL )->nNumFac ) + ( tmpFacPrvL )->cSufFac } )
   else
      oFr:SetMasterDetail( "Lineas de facturas", "Facturas",                  {|| ( dbfFacPrvL )->cSerFac + Str( ( dbfFacPrvL )->nNumFac ) + ( dbfFacPrvL )->cSufFac } )
      oFr:SetMasterDetail( "Lineas de facturas", "Artículos",                 {|| ( dbfFacPrvL )->cRef } )
      oFr:SetMasterDetail( "Lineas de facturas", "Precios por propiedades",   {|| ( dbfFacPrvL )->cRef + ( dbfFacPrvL )->cCodPr1 + ( dbfFacPrvL )->cCodPr2 + ( dbfFacPrvL )->cValPr1 + ( dbfFacPrvL )->cValPr2 } )
      oFr:SetMasterDetail( "Lineas de facturas", "Incidencias de facturas",   {|| ( dbfFacPrvL )->cSerFac + Str( ( dbfFacPrvL )->nNumFac ) + ( dbfFacPrvL )->cSufFac } )
      oFr:SetMasterDetail( "Lineas de facturas", "Documentos de facturas",    {|| ( dbfFacPrvL )->cSerFac + Str( ( dbfFacPrvL )->nNumFac ) + ( dbfFacPrvL )->cSufFac } )
   end if

   oFr:SetMasterDetail(    "Facturas", "Proveedores",                         {|| ( TDataView():FacturasProveedores( nView ) )->cCodPrv } )
   oFr:SetMasterDetail(    "Facturas", "Almacenes",                           {|| ( TDataView():FacturasProveedores( nView ) )->cCodAlm } )
   oFr:SetMasterDetail(    "Facturas", "Formas de pago",                      {|| ( TDataView():FacturasProveedores( nView ) )->cCodPago} )
   oFr:SetMasterDetail(    "Facturas", "Bancos",                              {|| ( TDataView():FacturasProveedores( nView ) )->cCodPrv } )
   oFr:SetMasterDetail(    "Facturas", "Empresa",                             {|| cCodigoEmpresaEnUso() } )

   oFr:SetResyncPair(      "Lineas de facturas", "Facturas" )
   oFr:SetResyncPair(      "Lineas de facturas", "Artículos" )
   oFr:SetResyncPair(      "Lineas de facturas", "Precios por propiedades" )
   oFr:SetResyncPair(      "Lineas de facturas", "Incidencias de facturas" )
   oFr:SetResyncPair(      "Lineas de facturas", "Documentos de facturas" )

   oFr:SetResyncPair(      "Facturas", "Proveedores" )
   oFr:SetResyncPair(      "Facturas", "Almacenes" )
   oFr:SetResyncPair(      "Facturas", "Formas de pago" )
   oFr:SetResyncPair(      "Facturas", "Bancos" )
   oFr:SetResyncPair(      "Facturas", "Empresa" )

Return nil

//---------------------------------------------------------------------------//

Static Function DataReport( oFr )

   /*
   Zona de datos------------------------------------------------------------
   */

   oFr:ClearDataSets()

   oFr:SetWorkArea(     "Facturas", ( TDataView():FacturasProveedores( nView ) )->( Select() ), .f., { FR_RB_CURRENT, FR_RB_CURRENT, 0 } )
   oFr:SetFieldAliases( "Facturas", cItemsToReport( aItmFacPrv() ) )

   oFr:SetWorkArea(     "Lineas de facturas", ( dbfFacPrvL )->( Select() ) )
   oFr:SetFieldAliases( "Lineas de facturas", cItemsToReport( aColFacPrv() ) )

   oFr:SetWorkArea(     "Incidencias de facturas", ( dbfFacPrvI )->( Select() ) )
   oFr:SetFieldAliases( "Incidencias de facturas", cItemsToReport( aIncFacPrv() ) )

   oFr:SetWorkArea(     "Documentos de facturas", ( dbfFacPrvD )->( Select() ) )
   oFr:SetFieldAliases( "Documentos de facturas", cItemsToReport( aFacPrvDoc() ) )

   oFr:SetWorkArea(     "Empresa", ( dbfEmp )->( Select() ) )
   oFr:SetFieldAliases( "Empresa", cItemsToReport( aItmEmp() ) )

   oFr:SetWorkArea(     "Proveedores", ( TDataView():Proveedores( nView ) )->( Select() ) )
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

   oFr:SetWorkArea(     "Bancos", ( dbfPrvBnc )->( Select() ) )
   oFr:SetFieldAliases( "Bancos", cItemsToReport( aPrvBnc() ) )

   oFr:SetMasterDetail( "Facturas", "Lineas de facturas",      {|| ( TDataView():FacturasProveedores( nView ) )->cSerFac + Str( ( TDataView():FacturasProveedores( nView ) )->nNumFac ) + ( TDataView():FacturasProveedores( nView ) )->cSufFac } )
   oFr:SetMasterDetail( "Facturas", "Incidencias de facturas", {|| ( TDataView():FacturasProveedores( nView ) )->cSerFac + Str( ( TDataView():FacturasProveedores( nView ) )->nNumFac ) + ( TDataView():FacturasProveedores( nView ) )->cSufFac } )
   oFr:SetMasterDetail( "Facturas", "Documentos de facturas",  {|| ( TDataView():FacturasProveedores( nView ) )->cSerFac + Str( ( TDataView():FacturasProveedores( nView ) )->nNumFac ) + ( TDataView():FacturasProveedores( nView ) )->cSufFac } )
   oFr:SetMasterDetail( "Facturas", "Proveedores",             {|| ( TDataView():FacturasProveedores( nView ) )->cCodPrv } )
   oFr:SetMasterDetail( "Facturas", "Almacenes",               {|| ( TDataView():FacturasProveedores( nView ) )->cCodAlm } )
   oFr:SetMasterDetail( "Facturas", "Formas de pago",          {|| ( TDataView():FacturasProveedores( nView ) )->cCodPago} )
   oFr:SetMasterDetail( "Facturas", "Bancos",                  {|| ( TDataView():FacturasProveedores( nView ) )->cCodPrv } )
   oFr:SetMasterDetail( "Facturas", "Empresa",                 {|| cCodigoEmpresaEnUso() } )

   oFr:SetMasterDetail( "Lineas de facturas", "Artículos",               {|| ( dbfFacPrvL )->cRef } )
   oFr:SetMasterDetail( "Lineas de facturas", "Código de proveedores",   {|| ( TDataView():FacturasProveedores( nView ) )->cCodPrv + ( dbfFacPrvL )->cRef } )
   oFr:SetMasterDetail( "Lineas de facturas", "Unidades de medición",    {|| ( dbfFacPrvL )->cUnidad } )

   oFr:SetResyncPair(   "Facturas", "Lineas de facturas" )
   oFr:SetResyncPair(   "Facturas", "Incidencias de facturas" )
   oFr:SetResyncPair(   "Facturas", "Documentos de facturas" )
   oFr:SetResyncPair(   "Facturas", "Proveedores" )
   oFr:SetResyncPair(   "Facturas", "Almacenes" )
   oFr:SetResyncPair(   "Facturas", "Formas de pago" )
   oFr:SetResyncPair(   "Facturas", "Bancos" )

   oFr:SetResyncPair(   "Lineas de facturas", "Artículos" )
   oFr:SetResyncPair(   "Lineas de facturas", "Código de proveedores" )
   oFr:SetResyncPair(   "Lineas de facturas", "Unidades de medición" )

Return nil

//---------------------------------------------------------------------------//

Static Function VariableReport( oFr )

   oFr:DeleteCategory(  "Facturas" )
   oFr:DeleteCategory(  "Lineas de facturas" )

   /*
   Creación de variables----------------------------------------------------
   */

   oFr:AddVariable(     "Facturas",             "Total bruto",                         "GetHbVar('nTotBrt')" )
   oFr:AddVariable(     "Facturas",             "Total factura",                       "GetHbVar('nTotFac')" )
   oFr:AddVariable(     "Facturas",             "Total descuento",                     "GetHbVar('nTotDto')" )
   oFr:AddVariable(     "Facturas",             "Total descuento pronto pago",         "GetHbVar('nTotDpp')" )
   oFr:AddVariable(     "Facturas",             "Total primer descuento definible",    "GetHbVar('nTotDto')" )
   oFr:AddVariable(     "Facturas",             "Total segundo descuento definible",   "GetHbVar('nTotDpp')" )
   oFr:AddVariable(     "Facturas",             "Total neto",                          "GetHbVar('nTotNet')" )
   oFr:AddVariable(     "Facturas",             "Total " + cImp(),                           "GetHbVar('nTotIva')" )
   oFr:AddVariable(     "Facturas",             "Total RE",                            "GetHbVar('nTotReq')" )
   oFr:AddVariable(     "Facturas",             "Total retenciones por IRPF",          "GetHbVar('nTotRet')" )
   oFr:AddVariable(     "Facturas",             "Total impuestos",                     "GetHbVar('nTotImp')" )
   oFr:AddVariable(     "Facturas",             "Total unidades",                      "GetHbVar('nTotUnd')" )
   oFr:AddVariable(     "Facturas",             "Bruto primer tipo de " + cImp(),            "GetHbArrayVar('aIvaUno',1)" )
   oFr:AddVariable(     "Facturas",             "Bruto segundo tipo de " + cImp(),           "GetHbArrayVar('aIvaDos',1)" )
   oFr:AddVariable(     "Facturas",             "Bruto tercer tipo de " + cImp(),            "GetHbArrayVar('aIvaTre',1)" )
   oFr:AddVariable(     "Facturas",             "Base primer tipo de " + cImp(),             "GetHbArrayVar('aIvaUno',2)" )
   oFr:AddVariable(     "Facturas",             "Base segundo tipo de " + cImp(),            "GetHbArrayVar('aIvaDos',2)" )
   oFr:AddVariable(     "Facturas",             "Base tercer tipo de " + cImp(),             "GetHbArrayVar('aIvaTre',2)" )
   oFr:AddVariable(     "Facturas",             "Porcentaje primer tipo " + cImp(),          "GetHbArrayVar('aIvaUno',3)" )
   oFr:AddVariable(     "Facturas",             "Porcentaje segundo tipo " + cImp(),         "GetHbArrayVar('aIvaDos',3)" )
   oFr:AddVariable(     "Facturas",             "Porcentaje tercer tipo " + cImp(),          "GetHbArrayVar('aIvaTre',3)" )
   oFr:AddVariable(     "Facturas",             "Porcentaje primer tipo RE",           "GetHbArrayVar('aIvaUno',4)" )
   oFr:AddVariable(     "Facturas",             "Porcentaje segundo tipo RE",          "GetHbArrayVar('aIvaDos',4)" )
   oFr:AddVariable(     "Facturas",             "Porcentaje tercer tipo RE",           "GetHbArrayVar('aIvaTre',4)" )
   oFr:AddVariable(     "Facturas",             "Importe primer tipo " + cImp(),             "GetHbArrayVar('aIvaUno',5)" )
   oFr:AddVariable(     "Facturas",             "Importe segundo tipo " + cImp(),            "GetHbArrayVar('aIvaDos',5)" )
   oFr:AddVariable(     "Facturas",             "Importe tercer tipo " + cImp(),             "GetHbArrayVar('aIvaTre',5)" )
   oFr:AddVariable(     "Facturas",             "Importe primer RE",                   "GetHbArrayVar('aIvaUno',6)" )
   oFr:AddVariable(     "Facturas",             "Importe segundo RE",                  "GetHbArrayVar('aIvaDos',6)" )
   oFr:AddVariable(     "Facturas",             "Importe tercer RE",                   "GetHbArrayVar('aIvaTre',6)" )

   oFr:AddVariable(     "Facturas",             "Cuenta bancaria proveedor",                 "CallHbFunc('cCtaFacPrv')" )

   oFr:AddVariable(     "Lineas de facturas",   "Código del artículo con propiedades",       "CallHbFunc('cPrpFacPrv')" )
   oFr:AddVariable(     "Lineas de facturas",   "Detalle del artículo",                      "CallHbFunc('cDesFacPrv')" )
   oFr:AddVariable(     "Lineas de facturas",   "Total unidades artículo",                   "CallHbFunc('nTotNFacPrv')" )
   oFr:AddVariable(     "Lineas de facturas",   "Precio unitario de factura",                "CallHbFunc('nTotUFacPrv')" )
   oFr:AddVariable(     "Lineas de facturas",   "Total línea de factura",                    "CallHbFunc('nTotLFacPrv')" )
   oFr:AddVariable(     "Lineas de facturas",   "Código de barras para primera propiedad",   "CallHbFunc('cBarPrp1FacPrv')" )
   oFr:AddVariable(     "Lineas de facturas",   "Código de barras para segunda propiedad",   "CallHbFunc('cBarPrp2FacPrv')" )

   oFr:AddVariable(     "Lineas de facturas",   "Stock actual en almacén",                   "CallHbFunc('nStockLineaFacPrv')" )

Return nil

//---------------------------------------------------------------------------//

Static Function YearComboBoxChange()

    if oWndBrw:oWndBar:lAllYearComboBox()
      DestroyFastFilter( TDataView():FacturasProveedores( nView ) )
      CreateUserFilter( "", TDataView():FacturasProveedores( nView ), .f., , , "all" )
    else
      DestroyFastFilter( TDataView():FacturasProveedores( nView ) )
      CreateUserFilter( "Year( Field->dFecFac ) == " + oWndBrw:oWndBar:cYearComboBox(), TDataView():FacturasProveedores( nView ), .f., , , "Year( Field->dFecFac ) == " + oWndBrw:oWndBar:cYearComboBox() )
    end if

    ( TDataView():FacturasProveedores( nView ) )->( dbGoTop() )

    oWndBrw:Refresh()

Return nil

//---------------------------------------------------------------------------//

Static Function AddLineasAlbaranProveedor( cAlbaran, lNewLin )

   local nNumLin
   local nNewLin

   DEFAULT lNewLin               := .f.

   /*
   Si lo encuentra-------------------------------------------------------
   */

   if ( dbfAlbPrvL )->( dbSeek( cAlbaran ) )

      while ( ( dbfAlbPrvL )->cSerAlb + Str( ( dbfAlbPrvL )->nNumAlb ) + ( dbfAlbPrvL )->cSufAlb == cAlbaran ) .and. !( dbfAlbPrvL )->( eof() )

         nNumLin                 := ( dbfAlbPrvL )->nNumLin

         ( dbfTmp )->( dbAppend() )

         if lNewLin
            nNewLin              := nLastNum( dbfTmp )
            ( dbfTmp )->nNumLin  := nNewLin
         else
            ( dbfTmp )->nNumLin  := nNumLin
         end if

         ( dbfTmp )->cRef        := ( dbfAlbPrvL )->cRef
         ( dbfTmp )->cDetalle    := ( dbfAlbPrvL )->cDetalle
         ( dbfTmp )->mLngDes     := ( dbfAlbPrvL )->mLngDes
         ( dbfTmp )->mNumSer     := ( dbfAlbPrvL )->mNumSer
         ( dbfTmp )->nIva        := ( dbfAlbPrvL )->nIva
         ( dbfTmp )->nReq        := ( dbfAlbPrvL )->nReq
         ( dbfTmp )->nPreUnit    := ( dbfAlbPrvL )->nPreDiv
         ( dbfTmp )->nPreCom     := ( dbfAlbPrvL )->nPreCom
         ( dbfTmp )->nUniCaja    := ( dbfAlbPrvL )->nUniCaja
         ( dbfTmp )->nCanEnt     := ( dbfAlbPrvL )->nCanEnt
         ( dbfTmp )->nDtoLin     := ( dbfAlbPrvL )->nDtoLin
         ( dbfTmp )->nDtoPrm     := ( dbfAlbPrvL )->nDtoPrm
         ( dbfTmp )->nDtoRap     := ( dbfAlbPrvL )->nDtoRap
         ( dbfTmp )->cAlmLin     := ( dbfAlbPrvL )->cAlmLin
         ( dbfTmp )->nUndKit     := ( dbfAlbPrvL )->nUndKit
         ( dbfTmp )->lKitChl     := ( dbfAlbPrvL )->lKitChl
         ( dbfTmp )->lKitArt     := ( dbfAlbPrvL )->lKitArt
         ( dbfTmp )->lKitPrc     := ( dbfAlbPrvL )->lKitPrc
         ( dbfTmp )->lIvaLin     := ( dbfAlbPrvL )->lIvaLin
         ( dbfTmp )->cCodPr1     := ( dbfAlbPrvL )->cCodPr1                           // Cod. prop. 1
         ( dbfTmp )->cCodPr2     := ( dbfAlbPrvL )->cCodPr2                           // Cod. prop. 2
         ( dbfTmp )->cValPr1     := ( dbfAlbPrvL )->cValPr1                           // Val. prop. 1
         ( dbfTmp )->cValPr2     := ( dbfAlbPrvL )->cValPr2                           // Val. prop. 2
         ( dbfTmp )->nBnfLin1    := ( dbfAlbPrvL )->nBnfLin1
         ( dbfTmp )->nBnfLin2    := ( dbfAlbPrvL )->nBnfLin2
         ( dbfTmp )->nBnfLin3    := ( dbfAlbPrvL )->nBnfLin3
         ( dbfTmp )->nBnfLin4    := ( dbfAlbPrvL )->nBnfLin4
         ( dbfTmp )->nBnfLin5    := ( dbfAlbPrvL )->nBnfLin5
         ( dbfTmp )->nBnfLin6    := ( dbfAlbPrvL )->nBnfLin6
         ( dbfTmp )->lBnfLin1    := ( dbfAlbPrvL )->lBnfLin1
         ( dbfTmp )->lBnfLin2    := ( dbfAlbPrvL )->lBnfLin2
         ( dbfTmp )->lBnfLin3    := ( dbfAlbPrvL )->lBnfLin3
         ( dbfTmp )->lBnfLin4    := ( dbfAlbPrvL )->lBnfLin4
         ( dbfTmp )->lBnfLin5    := ( dbfAlbPrvL )->lBnfLin5
         ( dbfTmp )->lBnfLin6    := ( dbfAlbPrvL )->lBnfLin6
         ( dbfTmp )->nPvpLin1    := ( dbfAlbPrvL )->nPvpLin1
         ( dbfTmp )->nPvpLin2    := ( dbfAlbPrvL )->nPvpLin2
         ( dbfTmp )->nPvpLin3    := ( dbfAlbPrvL )->nPvpLin3
         ( dbfTmp )->nPvpLin4    := ( dbfAlbPrvL )->nPvpLin4
         ( dbfTmp )->nPvpLin5    := ( dbfAlbPrvL )->nPvpLin5
         ( dbfTmp )->nPvpLin6    := ( dbfAlbPrvL )->nPvpLin6
         ( dbfTmp )->nIvaLin1    := ( dbfAlbPrvL )->nIvaLin1
         ( dbfTmp )->nIvaLin2    := ( dbfAlbPrvL )->nIvaLin2
         ( dbfTmp )->nIvaLin3    := ( dbfAlbPrvL )->nIvaLin3
         ( dbfTmp )->nIvaLin4    := ( dbfAlbPrvL )->nIvaLin4
         ( dbfTmp )->nIvaLin5    := ( dbfAlbPrvL )->nIvaLin5
         ( dbfTmp )->nIvaLin6    := ( dbfAlbPrvL )->nIvaLin6
         ( dbfTmp )->lLote       := ( dbfAlbPrvL )->lLote
         ( dbfTmp )->nLote       := ( dbfAlbPrvL )->nLote
         ( dbfTmp )->cLote       := ( dbfAlbPrvL )->cLote
         ( dbfTmp )->mObsLin     := ( dbfAlbPrvL )->mObsLin
         ( dbfTmp )->cRefPrv     := ( dbfAlbPrvL )->cRefPrv
         ( dbfTmp )->cUnidad     := ( dbfAlbPrvL )->cUnidad
         ( dbfTmp )->nNumMed     := ( dbfAlbPrvL )->nNumMed
         ( dbfTmp )->nMedUno     := ( dbfAlbPrvL )->nMedUno
         ( dbfTmp )->nMedDos     := ( dbfAlbPrvL )->nMedDos
         ( dbfTmp )->nMedTre     := ( dbfAlbPrvL )->nMedTre
         ( dbfTmp )->dFecCad     := ( dbfAlbPrvL )->dFecCad

         /*
         Pasamos series de pedidos---------------------------------------------------
         */

         if ( dbfAlbPrvS )->( dbSeek( cAlbaran + Str( nNumLin ) ) )

            while ( ( dbfAlbPrvS )->cSerAlb + Str( ( dbfAlbPrvS )->nNumAlb ) + ( dbfAlbPrvS )->cSufAlb + Str( ( dbfAlbPrvS )->nNumLin ) == cAlbaran + Str( nNumLin ) ) .and. !( dbfAlbPrvS )->( eof() )

               ( dbfTmpSer )->( dbAppend() )

               if lNewLin
                  ( dbfTmpSer )->nNumLin  := nNewLin
               else
                  ( dbfTmpSer )->nNumLin  := nNumLin
               end if

               ( dbfTmpSer )->cSerFac     := ( dbfAlbPrvS )->cSerAlb
               ( dbfTmpSer )->nNumFac     := ( dbfAlbPrvS )->nNumAlb
               ( dbfTmpSer )->cSufFac     := ( dbfAlbPrvS )->cSufAlb
               ( dbfTmpSer )->cRef        := ( dbfAlbPrvS )->cRef
               ( dbfTmpSer )->cAlmLin     := ( dbfAlbPrvS )->cAlmLin
               ( dbfTmpSer )->lUndNeg     := ( dbfAlbPrvS )->lUndNeg
               ( dbfTmpSer )->cNumSer     := ( dbfAlbPrvS )->cNumSer

               ( dbfAlbPrvS )->( dbSkip() )

            end while

         end if

         ( dbfAlbPrvL )->( dbSkip() )

      end while

      ( dbfTmp )->( dbGoTop() )

   end if

Return ( nil )

//---------------------------------------------------------------------------//

Static Function EditarNumerosSerie( aTmp, nMode )

   AutoNumerosSerie( aTmp, nMode )

   oNumerosSerie:Resource()

Return ( nil )

//--------------------------------------------------------------------------//

Static Function AutoNumerosSerie( aTmp, nMode )

   oNumerosSerie:nMode              := nMode

   oNumerosSerie:cCodArt            := aTmp[ _CREF    ]
   oNumerosSerie:cCodAlm            := aTmp[ _CALMLIN ]
   oNumerosSerie:nNumLin            := aTmp[ _NNUMLIN ]
   oNumerosSerie:lAutoSerializacion := aTmp[ _LAUTSER ]

   oNumerosSerie:nTotalUnidades     := nTotNFacPrv( aTmp )

   oNumerosSerie:uTmpSer            := dbfTmpSer

   if oNumerosSerie:lAutoSerializacion
       oNumerosSerie:AutoSerializa()
   end if

Return ( nil )

//----------------------------------------------------------------------------//

Static Function ValidaSuFactura( aGet, nMode )

   local nRecno
   local cSuFactura

   if nMode != APPD_MODE
      Return .t.
   end if

   cSuFactura        := aGet[ _CCODPRV ]:VarGet() + Upper( aGet[ _CSUPED ]:VarGet() )

   nRecno            := ( TDataView():FacturasProveedores( nView ) )->( Recno() )

   if dbSeekInOrd( cSuFactura, "cPrvFac", TDataView():FacturasProveedores( nView ) )
      MsgInfo( "La referencia de esta factura ya existe.")
   end if

   ( TDataView():FacturasProveedores( nView ) )->( dbGoTo( nRecno ) )

Return ( .t. )

//---------------------------------------------------------------------------//

static Function ActualizaStockWeb( cNumDoc )

   local nRec     := ( dbfFacPrvL )->( Recno() )
   local nOrdAnt  := ( dbfFacPrvL )->( OrdSetFocus( "nNumFac" ) )

   if uFieldEmpresa( "lRealWeb" )

      with object ( TComercio():GetInstance() )

         if ( dbfFacPrvL )->( dbSeek( cNumDoc ) )

            while ( dbfFacPrvL )->cSerFac + Str( ( dbfFacPrvL )->nNumFac ) + ( dbfFacPrvL )->cSufFac == cNumDoc .and. !( dbfFacPrvL )->( Eof() )

               :ActualizaStockProductsPrestashop( ( dbfFacPrvL )->cRef, ( dbfFacPrvL )->cCodPr1, ( dbfFacPrvL )->cCodPr2, ( dbfFacPrvL )->cValPr1, ( dbfFacPrvL )->cValPr2 )

               ( dbfFacPrvL )->( dbSkip() )

            end while

        end if
        
      end with

   end if 

   ( dbfFacPrvL )->( OrdSetFocus( nOrdAnt ) )
   ( dbfFacPrvL )->( dbGoTo( nRec ) )  

Return .t.

//---------------------------------------------------------------------------//

Static Function ImprimirSeriesFacturasProveedores( nDevice, lExt )

   local aStatus
   local oPrinter   
   local cFormato 

   DEFAULT nDevice   := IS_PRINTER
   DEFAULT lExt      := .f.

   // Cremaos el dialogo-------------------------------------------------------

   oPrinter          := PrintSeries():New( nView ):SetCompras()

   // Establecemos sus valores-------------------------------------------------

   oPrinter:Serie(      ( TDataView():FacturasProveedores( nView ) )->cSerFac )
   oPrinter:Documento(  ( TDataView():FacturasProveedores( nView ) )->nNumFac )
   oPrinter:Sufijo(     ( TDataView():FacturasProveedores( nView ) )->cSufFac )

   if lExt

      oPrinter:oFechaInicio:cText( ( TDataView():FacturasProveedores( nView ) )->dFecFac )
      oPrinter:oFechaFin:cText( ( TDataView():FacturasProveedores( nView ) )->dFecFac )

   end if

   oPrinter:oFormatoDocumento:TypeDocumento( "FP" )   

   // Formato de documento-----------------------------------------------------

   cFormato          := cFormatoDocumento( ( TDataView():FacturasProveedores( nView ) )->cSerFac, "nFacPrv", TDataView():Contadores( nView ) )
   if empty( cFormato )
      cFormato       := cFirstDoc( "FP", TDataView():Documentos( nView ) )
   end if
   oPrinter:oFormatoDocumento:cText( cFormato )

   // Codeblocks para que trabaje----------------------------------------------

   aStatus           := TDataview():GetInitStatus( "FacPrvT", nView )

   oPrinter:bInit    := {||   ( TDataview():FacturasProveedores( nView ) )->( dbSeek( oPrinter:DocumentoInicio(), .t. ) ) }

   oPrinter:bWhile   := {||   oPrinter:InRangeDocumento( TDataView():FacturasProveedoresId( nView ) )                  .and. ;
                              ( TDataView():FacturasProveedores( nView ) )->( !eof() ) }

   oPrinter:bFor     := {||   oPrinter:InRangeFecha( ( TDataView():FacturasProveedores( nView ) )->dFecFac )           .and. ;
                              oPrinter:InRangeProveedor( ( TDataView():FacturasProveedores( nView ) )->cCodPrv )         .and. ;
                              oPrinter:InRangeGrupoProveedor( RetFld( ( TDataView():FacturasProveedores( nView ) )->cCodPrv, TDataView():Proveedores( nView ), "cCodGrp" ) ) }

   oPrinter:bSkip    := {||   ( TDataView():FacturasProveedores( nView ) )->( dbSkip() ) }

   oPrinter:bAction  := {||   GenFacPrv( nDevice, "Imprimiendo documento : " + TDataView():FacturasProveedoresId( nView ), oPrinter:oFormatoDocumento:uGetValue, oPrinter:oImpresora:uGetValue, oPrinter:oCopias:uGetValue ) }

   oPrinter:bStart   := {||   if( lExt, oPrinter:DisableRange(), ) }

   // Abrimos el dialogo-------------------------------------------------------

   oPrinter:Resource():End()

   // Restore -----------------------------------------------------------------

   TDataview():SetStatus( "FacPrvT", nView, aStatus )
   
   if !Empty( oWndBrw )
      oWndBrw:Refresh()
   end if   

Return .t.

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
/*------------------------FUNCIONES GLOBALESS--------------------------------*/
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

/*
Devuelve el importe total de pagos de una factura de proveedores
*/

FUNCTION nPagFacPrv( cFactura, cFacPrvP, cDivRet, dbfDiv, lOnlyCob, aTmp )

   local nRec
   local nOrd
   local nRinDiv
   local cCodDiv
   local nTotalPagado   := 0

   DEFAULT cFacPrvP     := dbfFacPrvP
   DEFAULT cDivRet      := cDivEmp()
   DEFAULT lOnlyCob     := .t.

   nRinDiv              := nRinDiv( cDivRet, dbfDiv )

   /*
   Si nos pasan la divisa tomamos el valor de la misma-------------------------
   */

   nRec                    := ( cFacPrvP )->( Recno() )

   if !Empty( aTmp )

      cCodDiv              := ( cFacPrvP )->cDivPgo

      ( cFacPrvP )->( dbGoTop() )
      while !( cFacPrvP )->( Eof() )

         if ( lOnlyCob .and. ( cFacPrvP )->lCobrado .and. !( cFacPrvP )->lDevuelto ) .or. ( !lOnlyCob .and. !( cFacPrvP )->lDevuelto )

            nTotalPagado   += ( cFacPrvP )->nImporte

         end if

         ( cFacPrvP )->( dbSkip() )

      end while

      ( cFacPrvP )->( dbGoTo( nRec ) )

   else

      nOrd                 := ( cFacPrvP )->( OrdSetFocus( "NNUMFAC" ) )

      if ( cFacPrvP )->( dbSeek( cFactura, .t. ) )

         cCodDiv           := ( cFacPrvP )->cDivPgo

         while ( ( cFacPrvP )->cSerFac + Str( ( cFacPrvP )->nNumFac ) + ( cFacPrvP )->cSufFac = cFactura )

            if ( lOnlyCob .and. ( cFacPrvP )->lCobrado .and. !( cFacPrvP )->lDevuelto ) .or. ( !lOnlyCob .and. !( cFacPrvP )->lDevuelto )

               nTotalPagado   += ( cFacPrvP )->nImporte

            end if

            ( cFacPrvP )->( dbSkip() )

         end while

      end if

      ( cFacPrvP )->( OrdSetFocus( nOrd ) )

   end if

   ( cFacPrvP )->( dbGoTo( nRec ) )

   if cDivRet != nil .and. cCodDiv != cDivRet
      nTotalPagado   := nCnv2Div( nTotalPagado, cCodDiv, cDivRet )
   else
      nTotalPagado   := Round( nTotalPagado, nRinDiv )
   end if

RETURN ( nTotalPagado )

//---------------------------------------------------------------------------//

FUNCTION ChkPagFacPrv( cFacPrvT, dbfFacPrvP )

   local nBitmap

   do case
   case ( cFacPrvT )->lLiquidada
      nBitmap  := 1
   case lRecibosPagados( cFacPrvT, dbfFacPrvP )
      nBitmap  := 2
   otherwise
      nBitmap  := 3
   end case

RETURN nBitmap

//---------------------------------------------------------------------------//
/*
Comprueba si una factura esta liquidada
*/

FUNCTION ChkLqdFacPrv( aTmp, cFacPrvT, dbfFacPrvL, dbfFacPrvP, dbfIva, dbfDiv )

   local oError
   local oBlock
   local nTotFac
   local cDivFac
   local cNumFac
   local nPagFac

   oBlock            := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   if aTmp != nil
      cNumFac        := aTmp[ _CSERFAC ] + Str( aTmp[ _NNUMFAC ] ) + aTmp[ _CSUFFAC ]
      cDivFac        := aTmp[ _CDIVFAC ]
   else
      cNumFac        := ( cFacPrvT )->cSerFac + Str( ( cFacPrvT )->nNumFac ) + ( cFacPrvT )->cSufFac
      cDivFac        := ( cFacPrvT )->cDivFac
   end if

   nPagFac           := abs( nPagFacPrv( cNumFac, dbfFacPrvP, cDivFac, dbfDiv ) )
   nTotFac           := abs( nTotFacPrv( cNumFac, cFacPrvT, dbfFacPrvL, dbfIva, dbfDiv, dbfFacPrvP, nil, nil, .f. ) )

   if aTmp != nil
      aTmp[ _LLIQUIDADA ]           := ( ( nPagFac == nTotFac ) .or. ( nPagFac > nTotFac ) )
   else
      if dbLock( cFacPrvT )
         ( cFacPrvT )->lLiquidada := ( ( nPagFac == nTotFac ) .or. ( nPagFac > nTotFac ) )
         ( cFacPrvT )->( dbRUnLock() )
      end if
   end if

   RECOVER USING oError

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN NIL

//---------------------------------------------------------------------------//

FUNCTION nNetUFacPrv( uFacPrvL, uFacPrvT, nDec, nRec, nVdv, cPinDiv )

   local nDtoEsp
   local nDtoPP
   local nDtoUno
   local nDtoDos
   local nCalculo
   local nDtoLin
   local nDtoPrm
   local nPorte

   DEFAULT nDec   := nDinDiv()
   DEFAULT nRec   := nRinDiv()
   DEFAULT nVdv   := 1

   nCalculo       := nTotUFacPrv( uFacPrvL, nDec, nVdv )

   if ValType( uFacPrvL ) == "A"
      nDtoLin     := uFacPrvL[ _NDTOLIN ]
      nDtoPrm     := uFacPrvL[ _NDTOPRM ]
   else
      nDtoLin     := ( uFacPrvL )->nDtoLin
      nDtoPrm     := ( uFacPrvL )->nDtoPrm
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

   if ValType( uFacPrvT ) == "A"
      nDtoEsp     := uFacPrvT[ _NDTOESP ]
      nDtoPP      := uFacPrvT[ _NDPP    ]
      nDtoUno     := uFacPrvT[ _NDTOUNO ]
      nDtoDos     := uFacPrvT[ _NDTODOS ]
      nPorte      := uFacPrvT[ _NPORTES ]
   else
      nDtoEsp     := (uFacPrvT)->NDTOESP
      nDtoPP      := (uFacPrvT)->NDPP
      nDtoUno     := (uFacPrvT)->NDTOUNO
      nDtoDos     := (uFacPrvT)->NDTODOS
      nPorte      := (uFacPrvT)->NPORTES
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

FUNCTION nImpUFacPrv( uFacPrvT, dbfFacPrvL, nDec, nVdv, lIva, cPouDiv )

   local nCalculo

   DEFAULT nDec   := nDinDiv()
   DEFAULT nVdv   := 1
   DEFAULT lIva   := .f.

   nCalculo       := nTotUFacPrv( dbfFacPrvL, nDec, nVdv )

   if ValType( uFacPrvT ) == "A"
      nCalculo    -= Round( nCalculo * uFacPrvT[ _NDTOESP ]  / 100, nDec )
      nCalculo    -= Round( nCalculo * uFacPrvT[ _NDPP    ]  / 100, nDec )
      nCalculo    -= Round( nCalculo * uFacPrvT[ _NDTOUNO ]  / 100, nDec )
      nCalculo    -= Round( nCalculo * uFacPrvT[ _NDTODOS ]  / 100, nDec )
   else
      nCalculo    -= Round( nCalculo * ( uFacPrvT )->nDtoEsp / 100, nDec )
      nCalculo    -= Round( nCalculo * ( uFacPrvT )->nDpp    / 100, nDec )
      nCalculo    -= Round( nCalculo * ( uFacPrvT )->nDtoUno / 100, nDec )
      nCalculo    -= Round( nCalculo * ( uFacPrvT )->nDtoDos / 100, nDec )
   end if

   if lIva .and. ( dbfFacPrvL )->nIva != 0
      nCalculo    += nCalculo * ( dbfFacPrvL )->nIva / 100
   end if

RETURN ( if( cPouDiv != nil, Trans( nCalculo, cPouDiv ), nCalculo ) )

//---------------------------------------------------------------------------//

FUNCTION nImpLFacPrv( uFacPrvT, dbfFacPrvL, nDec, nRou, nVdv, lIva, cPouDiv )

   local nCalculo

   DEFAULT nDec   := nDinDiv()
   DEFAULT nVdv   := 1
   DEFAULT lIva   := .f.

   nCalculo       := nTotLFacPrv( dbfFacPrvL, nDec, nRou, nVdv )

   if ValType( uFacPrvT ) == "A"
      nCalculo    -= Round( nCalculo * uFacPrvT[ _NDTOESP ]  / 100, nRou )
      nCalculo    -= Round( nCalculo * uFacPrvT[ _NDPP    ]  / 100, nRou )
      nCalculo    -= Round( nCalculo * uFacPrvT[ _NDTOUNO ]  / 100, nRou )
      nCalculo    -= Round( nCalculo * uFacPrvT[ _NDTODOS ]  / 100, nRou )
   else
      nCalculo    -= Round( nCalculo * ( uFacPrvT )->nDtoEsp / 100, nRou )
      nCalculo    -= Round( nCalculo * ( uFacPrvT )->nDpp    / 100, nRou )
      nCalculo    -= Round( nCalculo * ( uFacPrvT )->nDtoUno / 100, nRou )
      nCalculo    -= Round( nCalculo * ( uFacPrvT )->nDtoDos / 100, nRou )
   end if

   if lIva .and. ( dbfFacPrvL )->nIva != 0
      nCalculo    += nCalculo * ( dbfFacPrvL )->nIva / 100
   end if

RETURN ( if( cPouDiv != NIL, Trans( nCalculo, cPouDiv ), nCalculo ) )

//---------------------------------------------------------------------------//

FUNCTION nTotFacPrv( cFactura, cFacPrvT, cFacPrvL, cDbfIva, cDbfDiv, cFacPrvP, aTmp, cDivRet, lPic )

   local bCondition
   local nTotalArt
   local lRecargo
   local dFecFac
   local nDtoEsp
   local nDtoPP
   local nDtoUno
   local nDtoDos
   local nPorte
   local nPctRet
   local nRecno
   local cCodDiv
   local cCodPgo
   local nRegIva
   local aTotalUno   := { 0, 0, 0 }
   local aTotalDos   := { 0, 0, 0 }
   local aTotalDto   := { 0, 0, 0 }
   local aTotalDPP   := { 0, 0, 0 }
   local lFacGas     := .f.
   local aNetGas     := { 0, 0, 0 }
   local aPIvGas     := { 0, 0, 0 }
   local aPReGas     := { 0, 0, 0 }

   DEFAULT cFacPrvT  := TDataView():FacturasProveedores( nView )
   DEFAULT cFacPrvL  := dbfFacPrvL
   DEFAULT cDbfIva   := dbfIva
   DEFAULT cDbfDiv   := dbfDiv
   DEFAULT cFacPrvP  := dbfFacPrvP
   DEFAULT cFactura  := ( cFacPrvT )->cSerFac + Str( ( cFacPrvT )->nNumFac ) + ( cFacPrvT )->cSufFac
   DEFAULT lPic      := .f.

   public nTotBrt    := 0
   public nTotNet    := 0
   public nTotSup    := 0
   public nTotIva    := 0
   public nTotReq    := 0
   public nTotRet    := 0
   public nTotFac    := 0
   public nTotDto    := 0
   public nTotDpp    := 0
   public nTotUno    := 0
   public nTotDos    := 0
   public nTotImp    := 0
   public nTotUnd    := 0
   public nPagFac    := 0
   public nTipRet    := 0
   public aTotIva    := { { 0,0,nil,0,0,0 }, { 0,0,nil,0,0,0 }, { 0,0,nil,0,0,0 } }
   public aIvaUno    := aTotIva[ 1 ]
   public aIvaDos    := aTotIva[ 2 ]
   public aIvaTre    := aTotIva[ 3 ]

   nRecno            := ( cFacPrvL )->( recno() )

   if aTmp != nil
      dFecFac        := aTmp[ _DFECFAC ]
      lRecargo       := aTmp[ _LRECARGO]
      nDtoEsp        := aTmp[ _NDTOESP ]
      nDtoPP         := aTmp[ _NDPP    ]
      nDtoUno        := aTmp[ _NDTOUNO ]
      nDtoDos        := aTmp[ _NDTODOS ]
      nPorte         := aTmp[ _NPORTES ]
      cCodDiv        := aTmp[ _CDIVFAC ]
      cCodPgo        := aTmp[ _CCODPAGO]
      nTipRet        := aTmp[ _NTIPRET ]
      nPctRet        := aTmp[ _NPCTRET ]
      nRegIva        := aTmp[ _NREGIVA ]
      lFacGas        := aTmp[ _LFACGAS ]
      aNetGas        := { aTmp[ _NNETGAS1 ], aTmp[ _NNETGAS2 ], aTmp[ _NNETGAS3 ] }
      aPIvGas        := { aTmp[ _NIVAGAS1 ], aTmp[ _NIVAGAS2 ], aTmp[ _NIVAGAS3 ] }
      aPReGas        := { aTmp[ _NREGAS1  ], aTmp[ _NREGAS2  ], aTmp[ _NREGAS3  ] }
      bCondition     := {|| ( cFacPrvL )->( !eof() ) }
      ( cFacPrvL )->( dbGoTop() )
   else
      dFecFac        := ( cFacPrvT )->dFecFac
      lRecargo       := ( cFacPrvT )->lRecargo
      nDtoEsp        := ( cFacPrvT )->nDtoEsp
      nDtoPP         := ( cFacPrvT )->nDpp
      nDtoUno        := ( cFacPrvT )->nDtoUno
      nDtoDos        := ( cFacPrvT )->nDtoDos
      nPorte         := ( cFacPrvT )->nPortes
      cCodDiv        := ( cFacPrvT )->cDivFac
      cCodPgo        := ( cFacPrvT )->cCodPago
      nTipRet        := ( cFacPrvT )->nTipRet
      nPctRet        := ( cFacPrvT )->nPctRet
      nRegIva        := ( cFacPrvT )->nRegIva
      lFacGas        := ( cFacPrvT )->lFacGas
      aNetGas        := { ( cFacPrvT )->nNetGas1, ( cFacPrvT )->nNetGas2, ( cFacPrvT )->nNetGas3 }
      aPIvGas        := { ( cFacPrvT )->nIvaGas1, ( cFacPrvT )->nIvaGas2, ( cFacPrvT )->nIvaGas3 }
      aPReGas        := { ( cFacPrvT )->nReGas1,  ( cFacPrvT )->nReGas2,  ( cFacPrvT )->nReGas3  }
      bCondition     := {|| ( cFacPrvL )->cSerFac + Str( ( cFacPrvL )->nNumFac ) + ( cFacPrvL )->cSufFac == cFactura .AND. ( cFacPrvL )->( !eof() ) }
      ( cFacPrvL )->( dbSeek( cFactura ) )
   end if

   /*
   Cargamos los pictures dependiendo de la moneda
   */

   cPinDiv           := cPinDiv( cCodDiv, cDbfDiv )
   cPirDiv           := cPirDiv( cCodDiv, cDbfDiv )
   nDinDiv           := nDinDiv( cCodDiv, cDbfDiv )
   nRinDiv           := nRinDiv( cCodDiv, cDbfDiv )

   if !lFacGas

      while Eval( bCondition )

         if lValLine( cFacPrvL )

            nTotalArt            := nTotLFacPrv( cFacPrvL, nDinDiv, nRinDiv )

            if nTotalArt != 0

               if ( cFacPrvL )->lGasSup
                  nTotSup        += nTotalArt
               end if

               /*
               Estudio de impuestos--------------------------------------------------
               */

               do case
                  case _NPCTIVA1 == nil .or. _NPCTIVA1 == ( cFacPrvL )->nIva
                     _NPCTIVA1   := ( cFacPrvL )->nIva
                     _NPCTREQ1   := ( cFacPrvL )->nReq
                     _NBRTIVA1   += nTotalArt

                  case _NPCTIVA2 == nil .or. _NPCTIVA2 == ( cFacPrvL )->nIva
                     _NPCTIVA2   := ( cFacPrvL )->nIva
                     _NPCTREQ2   := ( cFacPrvL )->nReq
                     _NBRTIVA2   += nTotalArt

                  case _NPCTIVA3 == nil .or. _NPCTIVA3 == ( cFacPrvL )->nIva
                     _NPCTIVA3   := ( cFacPrvL )->nIva
                     _NPCTREQ3   := ( cFacPrvL )->nReq
                     _NBRTIVA3   += nTotalArt

               end case

            end if

            nTotUnd              += nTotNFacPrv( cFacPrvL )

         end if

         ( cFacPrvL )->( dbSkip() )

      end while

      ( cFacPrvL )->( dbGoto( nRecno ) )

   else

      _NBRTIVA1   := aNetGas[1]
      _NPCTIVA1   := aPIvGas[1]
      _NPCTREQ1   := aPReGas[1]

      _NBRTIVA2   := aNetGas[2]
      _NPCTIVA2   := aPIvGas[2]
      _NPCTREQ2   := aPReGas[2]

      _NBRTIVA3   := aNetGas[3]
      _NPCTIVA3   := aPIvGas[3]
      _NPCTREQ3   := aPReGas[3]

   end if

   /*
   Ordenamos los impuestosS de menor a mayor
   */

   aTotIva              := aSort( aTotIva,,, {|x,y| abs( x[1] ) > abs( y[1] ) } )

   _NBASIVA1            := Round( _NBRTIVA1, nRinDiv )
   _NBASIVA2            := Round( _NBRTIVA2, nRinDiv )
   _NBASIVA3            := Round( _NBRTIVA3, nRinDiv )

   nTotBrt              := _NBASIVA1 + _NBASIVA2 + _NBASIVA3

   /*
   Portes de la Factura
   */

   nTotBrt              += nPorte

   /*
   Descuentos de la Facturas
   */

   if !lFacGas

      IF nDtoEsp != 0

         aTotalDto[1]   := Round( _NBASIVA1 * nDtoEsp / 100, nRinDiv )
         aTotalDto[2]   := Round( _NBASIVA2 * nDtoEsp / 100, nRinDiv )
         aTotalDto[3]   := Round( _NBASIVA3 * nDtoEsp / 100, nRinDiv )

         nTotDto        := aTotalDto[1] + aTotalDto[2] + aTotalDto[3]

         _NBASIVA1      -= aTotalDto[1]
         _NBASIVA2      -= aTotalDto[2]
         _NBASIVA3      -= aTotalDto[3]

      END IF

      IF nDtoPP != 0

         aTotalDPP[1]   := Round( _NBASIVA1 * nDtoPP / 100, nRinDiv )
         aTotalDPP[2]   := Round( _NBASIVA2 * nDtoPP / 100, nRinDiv )
         aTotalDPP[3]   := Round( _NBASIVA3 * nDtoPP / 100, nRinDiv )

         nTotDPP        := aTotalDPP[1] + aTotalDPP[2] + aTotalDPP[3]

         _NBASIVA1      -= aTotalDPP[1]
         _NBASIVA2      -= aTotalDPP[2]
         _NBASIVA3      -= aTotalDPP[3]

      END IF

      IF nDtoUno != 0

         aTotalUno[1]   := Round( _NBASIVA1 * nDtoUno / 100, nRinDiv )
         aTotalUno[2]   := Round( _NBASIVA2 * nDtoUno / 100, nRinDiv )
         aTotalUno[3]   := Round( _NBASIVA3 * nDtoUno / 100, nRinDiv )

         nTotUno        := aTotalUno[1] + aTotalUno[2] + aTotalUno[3]

         _NBASIVA1      -= aTotalUno[1]
         _NBASIVA2      -= aTotalUno[2]
         _NBASIVA3      -= aTotalUno[3]

      END IF

      IF nDtoDos != 0

         aTotalDos[1]   := Round( _NBASIVA1 * nDtoDos / 100, nRinDiv )
         aTotalDos[2]   := Round( _NBASIVA2 * nDtoDos / 100, nRinDiv )
         aTotalDos[3]   := Round( _NBASIVA3 * nDtoDos / 100, nRinDiv )

         nTotDos        := aTotalDos[1] + aTotalDos[2] + aTotalDos[3]

         _NBASIVA1      -= aTotalDos[1]
         _NBASIVA2      -= aTotalDos[2]
         _NBASIVA3      -= aTotalDos[3]

      END IF

   end if

   /*
   Calculos de impuestos
   */

   if nRegIva <= 1

      _NIMPIVA1         := if( _NPCTIVA1 != NIL, Round( _NBASIVA1 * _NPCTIVA1 / 100, nRinDiv ), 0 )
      _NIMPIVA2         := if( _NPCTIVA2 != NIL, Round( _NBASIVA2 * _NPCTIVA2 / 100, nRinDiv ), 0 )
      _NIMPIVA3         := if( _NPCTIVA3 != NIL, Round( _NBASIVA3 * _NPCTIVA3 / 100, nRinDiv ), 0 )

      /*
      Calculo de recargo
      */

      if lRecargo
         _NIMPREQ1   := if( _NPCTIVA1 != NIL, Round( _NBASIVA1 * _NPCTREQ1 / 100, nRinDiv ), 0 )
         _NIMPREQ2   := if( _NPCTIVA2 != NIL, Round( _NBASIVA2 * _NPCTREQ2 / 100, nRinDiv ), 0 )
         _NIMPREQ3   := if( _NPCTIVA3 != NIL, Round( _NBASIVA3 * _NPCTREQ3 / 100, nRinDiv ), 0 )
      end if

   end if

   /*
   Total impuestos
   */

   nTotIva           := Round( _NIMPIVA1 + _NIMPIVA2 + _NIMPIVA3, nRinDiv )

   /*
   Total de R.E.
   */

   nTotReq           := Round( _NIMPREQ1 + _NIMPREQ2 + _NIMPREQ3, nRinDiv )

   /*
   Redondeo del neto de la factura
   */

   nTotNet           := Round( _NBASIVA1 + _NBASIVA2 + _NBASIVA3, nRinDiv )

   /*
   Total de impuestos
   */

   nTotImp           := Round( nTotIva + nTotReq, nRinDiv )

   /*
   Total retenciones
   */

   if isNum( nTipRet )
      if nTipRet <= 1
         nTotRet     := Round( ( nTotNet - nTotSup ) * nPctRet / 100, nRinDiv )
      else
         nTotRet     := Round( ( nTotNet - nTotSup + nTotIva ) * nPctRet / 100, nRinDiv )
      end if
   end if

   /*
   Total facturas
   */

   nTotFac           := Round( nTotNet + nTotImp - nTotRet, nRinDiv )

   /*
   Calculo de pagos
   */

   if cFacPrvP != nil
      nPagFac        := nPagFacPrv( cFactura, cFacPrvP, cCodDiv, cDbfDiv, .t., aTmp )
   end if

   aTotIva           := aSort( aTotIva,,, {|x,y| abs( x[1] ) > abs( y[1] ) } )

   /*
   Solicitan una divisa distinta a la q se hizo originalmente la factura
   */

   if cDivRet != nil .and. cDivRet != cCodDiv
      nTotNet        := nCnv2Div( nTotNet, cCodDiv, cDivRet )
      nTotIva        := nCnv2Div( nTotIva, cCodDiv, cDivRet )
      nTotReq        := nCnv2Div( nTotReq, cCodDiv, cDivRet )
      nTotFac        := nCnv2Div( nTotFac, cCodDiv, cDivRet )
      cPirDiv        := cPirDiv( cDivRet, cDbfDiv )
   end if

RETURN ( if( lPic, Trans( nTotFac, cPirDiv ), nTotFac ) )

//--------------------------------------------------------------------------//

function nVtaFacPrv( cCodPrv, dDesde, dHasta, cFacPrvT, dbfFacPrvL, dbfIva, dbfDiv, nYear )

   local nCon     := 0
   local nRec     := ( cFacPrvT )->( Recno() )

   /*
   Facturas a Clientes -------------------------------------------------------
   */

   if ( cFacPrvT )->( dbSeek( cCodPrv ) )

      while ( cFacPrvT )->cCodPrv == cCodPrv .and. !( cFacPrvT )->( Eof() )

         if ( dDesde == nil .or. ( cFacPrvT )->dFecFac >= dDesde )    .and.;
            ( dHasta == nil .or. ( cFacPrvT )->dFecFac <= dHasta )    .and.;
            ( nYear == nil .or. Year( ( cFacPrvT )->dFecFac ) == nYear )

            nCon  += nTotFacPrv( ( cFacPrvT )->cSerFac + Str( (cFacPrvT)->nNumFac ) + (cFacPrvT)->cSufFac, cFacPrvT, dbfFacPrvL, dbfIva, dbfDiv, nil, nil, cDivEmp(), .f. )

         end if

         ( cFacPrvT )->( dbSkip() )

      end while

   end if

   ( cFacPrvT )->( dbGoTo( nRec ) )

return nCon

//----------------------------------------------------------------------------//
//
// Devuelve el total de pagos en Facturas de un clientes determinado
//

function nCobFacPrv( cCodPrv, dDesde, dHasta, cFacPrvT, dbfFacPrvP, dbfIva, dbfDiv, lOnlyCob, nYear )

   local nCob        := 0
   local nOrd        := ( cFacPrvT )->( OrdSetFocus( "cCodPrv" ) )
   local nRec        := ( cFacPrvT )->( Recno() )

   DEFAULT lOnlyCob  := .t.

   /*
   Facturas a Prventes -------------------------------------------------------
   */

   if ( cFacPrvT )->( dbSeek( cCodPrv ) )

      while ( cFacPrvT )->cCodPrv = cCodPrv .and. !( cFacPrvT )->( Eof() )

         if ( dDesde == nil .or. ( cFacPrvT )->DFECFAC >= dDesde ) .and.;
            ( dHasta == nil .or. ( cFacPrvT )->DFECFAC <= dHasta ) .and.;
            ( nYear == nil .or. Year( ( cFacPrvT )->dFecFac ) == nYear )

            nCob  += nPagFacPrv( ( cFacPrvT )->cSerFac + Str( (cFacPrvT)->nNumFac ) + (cFacPrvT)->cSufFac, dbfFacPrvP, cDivEmp(), dbfDiv, lOnlyCob )

         end if

         ( cFacPrvT )->( dbSkip() )

      end while

   end if

   ( cFacPrvT )->( OrdSetFocus( nOrd ) )
   ( cFacPrvT )->( dbGoTo( nRec ) )

return nCob

//----------------------------------------------------------------------------//

FUNCTION mkFacPrv( cPath, oMeter )

   IF oMeter != NIL
      oMeter:cText   := "Generando Bases"
      sysrefresh()
   END IF

   CreateFiles( cPath )

   rxFacPrv( cPath, oMeter )

RETURN NIL

//---------------------------------------------------------------------------//

FUNCTION rxFacPrv( cPath, oMeter )

   local cFacPrvT
   local dbfFacPrvL

   DEFAULT cPath  := cPatEmp()

   if !lExistTable( cPath + "FacPrvT.DBF" ) .OR. ;
      !lExistTable( cPath + "FacPrvL.DBF" ) .OR. ;
      !lExistTable( cPath + "FacPrvI.Dbf" ) .OR. ;
      !lExistTable( cPath + "FacPrvD.Dbf" ) .or. ;
      !lExistTable( cPath + "FacPrvS.Dbf" )
      CreateFiles( cPath )
   end if

   /*
   Eliminamos los indices
   */

   fEraseIndex( cPath + "FacPrvT.CDX" )
   fEraseIndex( cPath + "FacPrvL.CDX" )
   fEraseIndex( cPath + "FacPrvI.CDX" )
   fEraseIndex( cPath + "FacPrvD.CDX" )
   fEraseIndex( cPath + "FacPrvS.CDX" )

   dbUseArea( .t., cDriver(), cPath + "FACPRVT.DBF", cCheckArea( "FACPRVT", @cFacPrvT ), .f. )

   if !( cFacPrvT )->( neterr() )

      ( cFacPrvT )->( __dbPack() )

      ( cFacPrvT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cFacPrvT )->( ordCreate( cPath + "FACPRVT.CDX", "NNUMFAC", "CSERFAC + STR( NNUMFAC ) + CSUFFAC", {|| Field->CSERFAC + STR( Field->NNUMFAC ) + Field->CSUFFAC } ) )

      ( cFacPrvT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cFacPrvT )->( ordCreate( cPath + "FACPRVT.CDX", "DFECFAC", "DFECFAC", {|| Field->DFECFAC } ) )

      ( cFacPrvT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cFacPrvT )->( ordCreate( cPath + "FACPRVT.CDX", "CCODPRV", "CCODPRV", {|| Field->CCODPRV } ) )

      ( cFacPrvT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cFacPrvT )->( ordCreate( cPath + "FACPRVT.CDX", "CNOMPRV", "Upper( CNOMPRV )", {|| Upper( Field->CNOMPRV ) } ) )

      ( cFacPrvT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cFacPrvT )->( ordCreate( cPath + "FACPRVT.CDX", "cSuPed", "Upper( cSuPed )", {|| Upper( Field->cSuPed ) } ) )

      ( cFacPrvT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cFacPrvT )->( ordCreate( cPath + "FACPRVT.CDX", "cNumDoc", "Upper( cNumDoc )", {|| Upper( Field->cNumDoc ) } ) )

      ( cFacPrvT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cFacPrvT )->( ordCreate( cPath + "FACPRVT.CDX", "cNfc", "Upper( cNfc )", {||  Upper( Field->cNfc ) } ) )

      ( cFacPrvT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cFacPrvT )->( ordCreate( cPath + "FACPRVT.CDX", "CTURFAC", "CTURFAC + CSUFFAC + cCodCaj", {|| Field->CTURFAC + Field->CSUFFAC + Field->cCodCaj } ) )

      ( cFacPrvT)->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cFacPrvT)->( ordCreate( cPath + "FacPrvT.Cdx", "cCodUsr", "Field->cCodUsr + Dtos( Field->dFecChg ) + Field->cTimChg", {|| Field->cCodUsr + Dtos( Field->dFecChg ) + Field->cTimChg } ) )

      ( cFacPrvT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cFacPrvT )->( ordCreate( cPath + "FACPRVT.CDX", "cCodPago", "cCodPago", {|| Field->cCodPago } ) )

      ( cFacPrvT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cFacPrvT )->( ordCreate( cPath + "FACPRVT.CDX", "iNumFac", "'03' + CSERFAC + STR( NNUMFAC ) + CSUFFAC", {|| '03' + Field->CSERFAC + STR( Field->NNUMFAC ) + Field->CSUFFAC } ) )

      ( cFacPrvT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cFacPrvT )->( ordCreate( cPath + "FACPRVT.CDX", "cPrvFac", "cCodPrv + Upper( cSuPed )", {|| Field->cCodPrv + Upper( Field->cSuPed ) } ) )

      ( cFacPrvT )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de facturas de proveedores" )
   end if

   /*
   Nuevo Area------------------------------------------------------------------
   */

   dbUseArea( .t., cDriver(), cPath + "FACPRVL.DBF", cCheckArea( "FACPRVL", @dbfFacPrvL ), .f. )
   if !( dbfFacPrvL )->( neterr() )
      ( dbfFacPrvL )->( __dbPack() )

      ( dbfFacPrvL )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfFacPrvL )->( ordCreate( cPath + "FACPRVL.CDX", "NNUMFAC", "CSERFAC + STR( NNUMFAC ) + CSUFFAC", {|| Field->CSERFAC + STR( Field->NNUMFAC ) + Field->CSUFFAC } ) )

      ( dbfFacPrvL )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfFacPrvL )->( ordCreate( cPath + "FACPRVL.CDX", "cRef", "cRef + cValPr1 + cValPr2", {|| Field->cRef + Field->cValPr1 + Field->cValPr2 }, ) )

      ( dbfFacPrvL )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( dbfFacPrvL )->( ordCreate( cPath + "FacPrvL.Cdx", "cRefLote", "cRef + cValPr1 + cValPr2 + cLote", {|| Field->cRef + Field->cValPr1 + Field->cValPr2 + Field->cLote } ) )

      ( dbfFacPrvL )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfFacPrvL )->( ordCreate( cPath + "FACPRVL.CDX", "Lote", "cLote", {|| Field->cLote }, ) )

      ( dbfFacPrvL )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfFacPrvL )->( ordCreate( cPath + "FACPRVL.CDX", "cRefPrv", "cSerFac + Str( nNumFac ) + cSufFac + cRef + cRefPrv", {|| Field->cSerFac + Str( Field->nNumFac ) + Field->cSufFac + Field->cRef + Field->cRefPrv } ) )

      ( dbfFacPrvL )->( ordCondSet("!Deleted()", {||!Deleted()}, , , , , , , , , .t. ) )
      ( dbfFacPrvL )->( ordCreate( cPath + "FACPRVL.CDX", "cRefFec", "cRef + dTos( dFecFac )", {|| Field->cRef + dTos( Field->dFecFac ) } ) )

      ( dbfFacPrvL )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfFacPrvL )->( ordCreate( cPath + "FACPRVL.CDX", "iNumFac", "'03' + CSERFAC + STR( NNUMFAC ) + CSUFFAC", {|| '03' + Field->CSERFAC + STR( Field->NNUMFAC ) + Field->CSUFFAC } ) )

      ( dbfFacPrvL )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( dbfFacPrvL )->( ordCreate( cPath + "FACPRVL.Cdx", "cArtLote", "cRef + cLote", {|| Field->cRef + Field->cLote } ) )

      ( dbfFacPrvL )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de facturas de proveedores" )
   end if

   dbUseArea( .t., cDriver(), cPath + "FacPrvI.DBF", cCheckArea( "FacPrvI", @cFacPrvT ), .f. )
   if !( cFacPrvT )->( neterr() )
      ( cFacPrvT )->( __dbPack() )

      ( cFacPrvT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cFacPrvT )->( ordCreate( cPath + "FacPrvI.CDX", "nNumFac", "cSerie + Str( nNumFac ) + cSufFac", {|| Field->cSerie + STR( Field->nNumFac ) + Field->cSufFac } ) )

      ( cFacPrvT )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de facturas de proveedores" )
   end if

   dbUseArea( .t., cDriver(), cPath + "FacPrvD.DBF", cCheckArea( "FacPrvD", @cFacPrvT ), .f. )
   if !( cFacPrvT )->( neterr() )
      ( cFacPrvT )->( __dbPack() )

      ( cFacPrvT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cFacPrvT )->( ordCreate( cPath + "FacPrvD.CDX", "nNumFac", "cSerFac + STR( nNumFac ) + cSufFac", {|| Field->cSerFac + STR( Field->nNumFac ) + Field->cSufFac } ) )

      ( cFacPrvT )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de facturas de proveedores" )
   end if

   dbUseArea( .t., cDriver(), cPath + "FacPrvS.DBF", cCheckArea( "FacPrvS", @cFacPrvT ), .f. )
   if !( cFacPrvT )->( neterr() )
      ( cFacPrvT )->( __dbPack() )

      ( cFacPrvT )->( ordCondSet( "!Deleted()", {||!Deleted()}  ) )
      ( cFacPrvT )->( ordCreate( cPath + "FacPrvS.CDX", "nNumFac", "cSerFac + Str( nNumFac ) + cSufFac + Str( nNumLin )", {|| Field->cSerFac + Str( Field->nNumFac ) + Field->cSufFac + Str( Field->nNumLin ) } ) )

      ( cFacPrvT )->( ordCondSet( "!Deleted()", {||!Deleted()}  ) )
      ( cFacPrvT )->( ordCreate( cPath + "FacPrvS.CDX", "cRefSer", "cRef + cAlmLin + cNumSer", {|| Field->cRef + Field->cAlmLin + Field->cNumSer } ) )

      ( cFacPrvT )->( ordCondSet( "!Deleted()", {||!Deleted()}  ) )
      ( cFacPrvT )->( ordCreate( cPath + "FacPrvS.CDX", "cNumSer", "cNumSer", {|| Field->cNumSer } ) )

      ( cFacPrvT )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de numeros de series de facturas de proveedores" )
   end if

RETURN NIL

//--------------------------------------------------------------------------//

function aIncFacPrv()

   local aIncFacPrv  := {}

   aAdd( aIncFacPrv, { "cSerie",  "C",    1,  0, "Serie de factura" ,              "",                   "", "( cDbfCol )" } )
   aAdd( aIncFacPrv, { "nNumFac", "N",    9,  0, "Número de factura" ,             "'999999999'",        "", "( cDbfCol )" } )
   aAdd( aIncFacPrv, { "cSufFac", "C",    2,  0, "Sufijo de factura" ,             "",                   "", "( cDbfCol )" } )
   aAdd( aIncFacPrv, { "cCodTip", "C",    3,  0, "Tipo de incidencia" ,            "",                   "", "( cDbfCol )" } )
   aAdd( aIncFacPrv, { "dFecInc", "D",    8,  0, "Fecha de la incidencia" ,        "",                   "", "( cDbfCol )" } )
   aAdd( aIncFacPrv, { "mDesInc", "M",   10,  0, "Descripción de la incidencia" ,  "",                   "", "( cDbfCol )" } )
   aAdd( aIncFacPrv, { "lListo",  "L",    1,  0, "Lógico de listo" ,               "",                   "", "( cDbfCol )" } )
   aAdd( aIncFacPrv, { "lAviso",  "L",    1,  0, "Lógico de aviso" ,               "",                   "", "( cDbfCol )" } )

return ( aIncFacPrv )

//---------------------------------------------------------------------------//

function aFacPrvDoc()

   local aFacPrvDoc  := {}

   aAdd( aFacPrvDoc, { "cSerFac", "C",    1,  0, "Serie de facturas" ,               "",                   "", "( cDbfCol )" } )
   aAdd( aFacPrvDoc, { "nNumFac", "N",    9,  0, "Número de facturas" ,              "'999999999'",        "", "( cDbfCol )" } )
   aAdd( aFacPrvDoc, { "cSufFac", "C",    2,  0, "Sufijo de facturas" ,              "",                   "", "( cDbfCol )" } )
   aAdd( aFacPrvDoc, { "cNombre", "C",  250,  0, "Nombre del documento" ,            "",                   "", "( cDbfCol )" } )
   aAdd( aFacPrvDoc, { "cRuta",   "C",  250,  0, "Ruta del documento" ,              "",                   "", "( cDbfCol )" } )
   aAdd( aFacPrvDoc, { "mObsDoc", "M",   10,  0, "Observaciones del documento" ,     "",                   "", "( cDbfCol )" } )

return ( aFacPrvDoc )

//---------------------------------------------------------------------------//

/*
Devuelve la fecha de una factura de proveedor
*/

FUNCTION dFecFacPrv( cFacPrv, cFacPrvT )

   local dFecFac  := Ctod("")

   IF (cFacPrvT)->( dbSeek( cFacPrv ) )
      dFecFac  := (cFacPrvT)->DFECFAC
   END IF

RETURN ( dFecFac )

//----------------------------------------------------------------------------//
/*
Devuelve el codigo del Proveedor pasando un numero de factura
*/

FUNCTION cPrvFacPrv( cFacPrv, cFacPrvT )

   local cCodPrv  := ""

   IF (cFacPrvT)->( dbSeek( cFacPrv ) )
      cCodPrv  := (cFacPrvT)->CCODPRV
   END IF

RETURN ( cCodPrv )

//----------------------------------------------------------------------------//
/*
Devuelve el Nombre del Proveedor pasando un numero de factura
*/

FUNCTION cNbrFacPrv( cFacPrv, cFacPrvT )

   local cNomPrv  := ""

   IF (cFacPrvT)->( dbSeek( cFacPrv ) )
      cNomPrv  := (cFacPrvT)->CNOMPRV
   END IF

RETURN ( cNomPrv )

//--------------------------------------------------------------------------//

FUNCTION nEstFacPrv( cFacPrv, cFacPrvT, dbfFacPrvP )

   local nBitmap  := 3

   if ( cFacPrvT )->( dbSeek( cFacPrv ) )
      nBitmap     := ChkPagFacPrv( cFacPrvT, dbfFacPrvP )
   end if

RETURN nBitmap

//---------------------------------------------------------------------------//

/*
Genera los recibos de una factura
*/

FUNCTION GenPgoFacPrv( cNumFac, cFacPrvT, dbfFacPrvL, dbfFacPrvP, cPrv, dbfFPago, dbfDiv, aTmp )

   local nCobro
   local cCodPgo
   local cSerFac
   local nNumFac
   local cSufFac
   local cDivFac
   local nVdvFac
   local dFecFac
   local cCodPrv
   local cNomPrv
   local cCodUsr
   local cCodCaj
   local nTotal
   local nTotCob
   local nDec
   local nInc        := 0
   local n           := 0
   local nTotAcu     := 0
   local nPlazos     := 0
   local cBanco
   local cPaisIBAN
   local cCtrlIBAN
   local cEntidad
   local cSucursal
   local cControl
   local cCuenta

   if aTmp != nil
      cSerFac        := aTmp[ _CSERFAC    ]
      nNumFac        := aTmp[ _NNUMFAC    ]
      cSufFac        := aTmp[ _CSUFFAC    ]
      cDivFac        := aTmp[ _CDIVFAC    ]
      nVdvFac        := aTmp[ _NVDVFAC    ]
      dFecFac        := aTmp[ _DFECFAC    ]
      cCodPgo        := aTmp[ _CCODPAGO   ]
      cCodPrv        := aTmp[ _CCODPRV    ]
      cNomPrv        := aTmp[ _CNOMPRV    ]
      cCodUsr        := aTmp[ _CCODUSR    ]
      cCodCaj        := aTmp[ _CCODCAJ    ]
      cEntidad       := aTmp[ _CENTBNC    ]
      cSucursal      := aTmp[ _CSUCBNC    ]
      cControl       := aTmp[ _CDIGBNC    ]
      cCuenta        := aTmp[ _CCTABNC    ]
      cBanco         := aTmp[ _CBANCO     ]
      cPaisIBAN      := aTmp[ _CPAISIBAN  ]
      cCtrlIBAN      := aTmp[ _CCTRLIBAN  ]
      cEntidad       := aTmp[ _CENTBNC    ]
      cSucursal      := aTmp[ _CSUCBNC    ]
      cControl       := aTmp[ _CDIGBNC    ]
      cCuenta        := aTmp[ _CCTABNC    ]

   else
      cSerFac        := ( cFacPrvT )->cSerFac
      nNumFac        := ( cFacPrvT )->nNumFac
      cSufFac        := ( cFacPrvT )->cSufFac
      cDivFac        := ( cFacPrvT )->cDivFac
      nVdvFac        := ( cFacPrvT )->nVdvFac
      dFecFac        := ( cFacPrvT )->dFecFac
      cCodPgo        := ( cFacPrvT )->cCodPago
      cCodPrv        := ( cFacPrvT )->cCodPrv
      cNomPrv        := ( cFacPrvT )->cNomPrv
      cCodUsr        := ( cFacPrvT )->cCodUsr
      cCodCaj        := ( cFacPrvT )->cCodCaj
      cBanco         := ( cFacPrvT )->cBanco
      cPaisIBAN      := ( cFacPrvT )->cPaisIBAN
      cCtrlIBAN      := ( cFacPrvT )->cCtrlIBAN
      cEntidad       := ( cFacPrvT )->cEntBnc
      cSucursal      := ( cFacPrvT )->cSucBnc
      cControl       := ( cFacPrvT )->cDigBnc
      cCuenta        := ( cFacPrvT )->cCtaBnc
   end if

   /*
   Comprobar q el total de factura no es igual al de pagos
   */

   nTotal            := nTotFacPrv( cNumFac, cFacPrvT, dbfFacPrvL, dbfIva, dbfDiv, dbfFacPrvP, nil, nil, .f. )
   nTotCob           := nPagFacPrv( cNumFac, dbfFacPrvP, nil, dbfDiv, .f. )
   nDec              := nRouDiv( cDivFac, dbfDiv ) // Decimales de la divisa redondeada

   if nTotal != nTotCob

      /*
      Si no hay recibos pagados eliminamos los recibos y se vuelven a generar
      */

      if ( dbfFacPrvP )->( dbSeek( cNumFac ) )
         while cNumFac == ( dbfFacPrvP )->cSerFac + Str( ( dbfFacPrvP )->nNumFac ) + ( dbfFacPrvP )->cSufFac .and. !( dbfFacPrvP )->( eof() )
            if !( dbfFacPrvP )->lCobrado .and. dbLock( dbfFacPrvP )
               ( dbfFacPrvP )->( dbDelete() )
               ( dbfFacPrvP )->( dbUnLock() )
            else
               nInc  := ( dbfFacPrvP )->nNumRec
            end if
            ( dbfFacPrvP )->( dbSkip() )
         end while
      end if

      nTotal         -= nPagFacPrv( cNumFac, dbfFacPrvP, nil, dbfDiv, .f. )

      /*
      Genera pagos
      */

      if ( dbfFPago )->( dbSeek( cCodPgo ) )

         nTotAcu        := nTotal
         nPlazos        := Max( ( dbfFPago )->nPlazos, 1 )

         for n := 1 to nPlazos

            if n != nPlazos
               nTotAcu  -= Round( nTotal / nPlazos, nDec )
            end if

            ( dbfFacPrvP)->( dbAppend() )

            ( dbfFacPrvP )->cSerFac       := cSerFac
            ( dbfFacPrvP )->nNumFac       := nNumFac
            ( dbfFacPrvP )->cSufFac       := cSufFac
            ( dbfFacPrvP )->cCodPrv       := cCodPrv
            ( dbfFacPrvP )->cNomPrv       := cNomPrv
            ( dbfFacPrvP )->nNumRec       := ++nInc
            ( dbfFacPrvP )->nImporte      := if( n != nPlazos, Round( nTotal / nPlazos, nDec ), Round( nTotAcu, nDec ) )
            ( dbfFacPrvP )->cTurRec       := cCurSesion()
            ( dbfFacPrvP )->cDescrip      := "Recibo nº" + AllTrim( Str( ( dbfFacPrvP )->nNumRec ) ) + " de factura " + cSerFac  + '/' + allTrim( Str( nNumFac ) ) + '/' + cSufFac
            ( dbfFacPrvP )->cDivPgo       := cDivFac
            ( dbfFacPrvP )->nVdvPgo       := nVdvFac
            ( dbfFacPrvP )->lCobRado      := ( ( dbfFPago )->nCobRec == 1 )
            ( dbfFacPrvP )->dPreCob       := dFecFac
            ( dbfFacPrvP )->dFecVto       := dNexDay( dFecFac + ( dbfFPago )->nPlaUno + ( ( dbfFPago )->nDiaPla * ( n - 1 ) ), cPrv )
            ( dbfFacPrvP )->cCtaRec       := ( dbfFPago )->cCtaCobro
            ( dbfFacPrvP )->dFecChg       := GetSysDate()
            ( dbfFacPrvP )->cTimChg       := Time()
            ( dbfFacPrvP )->cCodPgo       := cCodPgo
            ( dbfFacPrvP )->lNotArqueo    := .f.
            ( dbfFacPrvP )->cCodCaj       := cCodCaj
            ( dbfFacPrvP )->cCodUsr       := cCodUsr

            if ( dbfFPago )->lUtlBnc
               ( dbfFacPrvP )->cEPaisIBAN := ( dbfFPago )->cPaisIBAN
               ( dbfFacPrvP )->cECtrlIBAN := ( dbfFPago )->cCtrlIBAN
               ( dbfFacPrvP )->cBncEmp    := ( dbfFPago )->cBanco
               ( dbfFacPrvP )->cEntEmp    := ( dbfFPago )->cEntBnc
               ( dbfFacPrvP )->cSucEmp    := ( dbfFPago )->cSucBnc
               ( dbfFacPrvP )->cDigEmp    := ( dbfFPago )->cDigBnc
               ( dbfFacPrvP )->cCtaEmp    := ( dbfFPago )->cCtaBnc
            end if

            ( dbfFacPrvP )->cPaisIBAN     := cPaisIBAN
            ( dbfFacPrvP )->cCtrlIBAN     := cCtrlIBAN
            ( dbfFacPrvP )->cBncPrv       := cBanco
            ( dbfFacPrvP )->cEntPrv       := cEntidad
            ( dbfFacPrvP )->cSucPrv       := cSucursal
            ( dbfFacPrvP )->cDigPrv       := cControl
            ( dbfFacPrvP )->cCtaPrv       := cCuenta

            if ( dbfFPago )->nCobRec == 1
               ( dbfFacPrvP )->dEntrada   := dNexDay( dFecFac + ( dbfFPago )->nPlaUno + ( ( dbfFPago )->nDiaPla * ( n - 1 ) ), cPrv )
            end if

            ( dbfFacPrvP )->( dbUnLock() )

         next

      end if

   end if

RETURN NIL

//---------------------------------------------------------------------------//
//
// Devuelve el total de la compra en facturas de proveedores de un articulo
//

function nTotVFacPrv( cCodArt, dbfFacPrvL, nDinDiv, nDirDiv )

   local nTotVta  := 0
   local nRecno   := ( dbfFacPrvL )->( Recno() )

   if ( dbfFacPrvL )->( dbSeek( cCodArt ) )

      while ( dbfFacPrvL )->cRef == cCodArt .and. !( dbfFacPrvL )->( eof() )

         nTotVta  += nTotLFacPrv( dbfFacPrvL, nDinDiv, nDirDiv )

         ( dbfFacPrvL )->( dbSkip() )

      end while

   end if

   ( dbfFacPrvL )->( dbGoTo( nRecno ) )

return ( nTotVta )

//---------------------------------------------------------------------------//
//
// Devuelve el total de unidades de la compra en facturas de proveedores de un articulo
//

function nTotDFacPrv( cCodArt, dbfFacPrvL, cCodAlm )

   local nTotVta  := 0
   local nRecno   := ( dbfFacPrvL )->( Recno() )

   if ( dbfFacPrvL )->( dbSeek( cCodArt ) )

      while ( dbfFacPrvL )->CREF == cCodArt .and. !( dbfFacPrvL )->( eof() )

         if cCodAlm != nil
            if cCodAlm == ( dbfFacPrvL )->cAlmLin
               nTotVta  += nTotNFacPrv( dbfFacPrvL )
            end if
         else
            nTotVta     += nTotNFacPrv( dbfFacPrvL )
         end if

         ( dbfFacPrvL )->( dbSkip() )

      end while

   end if

   ( dbfFacPrvL )->( dbGoTo( nRecno ) )

return ( nTotVta )

//---------------------------------------------------------------------------//

/*
Devuelve el codigo del Prvente pasando un numero de factura
*/

FUNCTION dPrvFacPrv( cFacPrv, cFacPrvT )

   local cCodPrv  := ""

   if dbSeekInOrd( cFacPrv, "nNumFac", cFacPrvT )
      cCodPrv     := (cFacPrvT)->cCodPrv
   END IF

RETURN ( cCodPrv )

//----------------------------------------------------------------------------//
/*
Devuelve la forma de pago pasando un numero de factura
*/

FUNCTION cPgoFacPrv( cFacPrv, cFacPrvT )

   local cCodPgo  := ""

   if dbSeekInOrd( cFacPrv, "nNumFac", cFacPrvT )
      cCodPgo     := ( cFacPrvT )->cCodPago
   END IF

RETURN ( cCodPgo )

//----------------------------------------------------------------------------//

FUNCTION cNomFacPrv( cFacPrv, cFacPrvT )

   local cNomPrv := ""

   if dbSeekInOrd( cFacPrv, "nNumFac", cFacPrvT )
      cNomPrv  := ( cFacPrvT )->cNomPrv
   END IF

RETURN ( cNomPrv )

//----------------------------------------------------------------------------//

FUNCTION cCodFacPrv( cFacPrv, uFacPrvT )

   local cCodPrv := ""

   if ValType( uFacPrvT ) == "O"

      if uFacPrvT:SeekInOrd( cFacPrv, "nNumFac" )
         cCodPrv  := uFacPrvT:cCodPrv
      end if

   else

      if dbSeekInOrd( cFacPrv, "nNumFac", TDataView():FacturasProveedores( nView ) )
         cCodPrv  := ( uFacPrvT )->cCodPrv
      end if

   end if

RETURN ( cCodPrv )

//----------------------------------------------------------------------------//

/*
Devuelve si la factura esta contabilizada o no
*/

FUNCTION lConFacPrv( cFacPrv, cFacPrvT )

   local lConFac  := .f.

   if dbSeekInOrd( cFacPrv, "nNumFac", cFacPrvT )
      lConFac     := ( cFacPrvT )->lContab
   end if

RETURN ( lConFac )

//----------------------------------------------------------------------------//

function dFecVtoPrv( nVto )

   local dVto     := Ctod( "  /  /  " )

   DEFAULT nVto   := 1

   if nVto <= len( aDatVcto )
      dVto        := aDatVcto[ nVto ]
   end if

return ( dVto )

//----------------------------------------------------------------------------//

function nImpVtoPrv( nVto )

   local nImp     := 0

   DEFAULT nVto   := 1

   if nVto <= len( aImpVcto )
      nImp        := aImpVcto[ nVto ]
   end if

return ( nImp )

//----------------------------------------------------------------------------//

FUNCTION cProFacPrv( cFacPro, cFacPrvT )

   local cCodPro  := ""

   if dbSeekInOrd( cFacPro, "nNumFac", cFacPrvT )
      cCodPro     := ( cFacPrvT )->cCodPro
   end if

RETURN ( cCodPro )

//----------------------------------------------------------------------------//

FUNCTION nTotNFacPrv( uDbf )

   local nTotUnd

   DEFAULT uDbf   := dbfFacPrvL

   do case
      case ValType( uDbf ) == "A"
         nTotUnd  := uDbf[ _NUNICAJA ]
         nTotUnd  *= NotCaja( uDbf[ _NCANENT ] )
         nTotUnd  *= NotCero( uDbf[ _NUNDKIT ] )
         nTotUnd  *= NotCero( uDbf[ _NMEDUNO ] )
         nTotUnd  *= NotCero( uDbf[ _NMEDDOS ] )
         nTotUnd  *= NotCero( uDbf[ _NMEDTRE ] )

      case ValType( uDbf ) == "O"
         nTotUnd  := uDbf:nUniCaja
         nTotUnd  *= NotCaja( uDbf:nCanEnt )
         nTotUnd  *= NotCero( uDbf:nUndKit )
         nTotUnd  *= NotCero( uDbf:nMedUno )
         nTotUnd  *= NotCero( uDbf:nMedDos )
         nTotUnd  *= NotCero( uDbf:nMedTre )

      otherwise
         nTotUnd  := ( uDbf )->nUniCaja
         nTotUnd  *= NotCaja( ( uDbf )->nCanEnt )
         nTotUnd  *= NotCero( ( uDbf )->nUndKit )
         nTotUnd  *= NotCero( ( uDbf )->nMedUno )
         nTotUnd  *= NotCero( ( uDbf )->nMedDos )
         nTotUnd  *= NotCero( ( uDbf )->nMedTre )

   end case

RETURN ( nTotUnd )

//--------------------------------------------------------------------------//

FUNCTION nBrtLFacPrv( uTmpLin, nDec, nRec, nVdv, cPorDiv )

   local nCalculo := 0

   DEFAULT nDec   := nDinDiv()
   DEFAULT nRec   := nRinDiv()
   DEFAULT nVdv   := 1

   nCalculo       := nTotUFacPrv( uTmpLin, nDec, nVdv, cPorDiv )
   nCalculo       *= nTotNFacPrv( uTmpLin )

   nCalculo       := Round( nCalculo / nVdv, nRec )

Return ( if( cPorDiv != nil, Trans( nCalculo, cPorDiv ), nCalculo ) )

//---------------------------------------------------------------------------//

FUNCTION nIvaUFacPrv( dbfTmp, nDec, nVdv )

   local nCalculo

   DEFAULT nDec   := nDinDiv()
   DEFAULT nVdv   := 1

   nCalculo       := nTotUFacPrv( dbfTmp, nDec, nVdv )

   if !( dbfTmp )->lIvaLin
      nCalculo    += nCalculo * ( dbfTmp )->nIva / 100
   end if

   if nVdv != 0
      nCalculo    := nCalculo / nVdv
   end if

RETURN ( Round( nCalculo, nDec ) )

//---------------------------------------------------------------------------//

FUNCTION nIvaLFacPrv( dbfLin, nDec, nRou, nVdv, cPorDiv )

   local nCalculo

   DEFAULT nDec   := nDinDiv()
   DEFAULT nRou   := nRinDiv()
   DEFAULT nVdv   := 1

   nCalculo       := nTotLFacPrv( dbfLin, nDec, nRou, nVdv )

   nCalculo       := Round( nCalculo * ( dbfLin )->nIva / 100, nRou )

RETURN ( if( cPorDiv != nil, Trans( nCalculo, cPorDiv ), nCalculo ) )

//---------------------------------------------------------------------------//

/*
Devuelve un array con el neto, impuestos, recargo y total
*/

FUNCTION aTotFacPrv( cFactura, cFacPrvT, dbfFacPrvL, dbfIva, dbfDiv, dbfFacPrvP, cDivRet )

   nTotFacPrv( cFactura, cFacPrvT, dbfFacPrvL, dbfIva, dbfDiv, dbfFacPrvP, nil, cDivRet )

RETURN ( { nTotNet, nTotIva, nTotReq, nTotFac, aTotIva, nTotRet } )

//---------------------------------------------------------------------------//

Function sTotFacPrv( cFactura, cFacPrvT, dbfFacPrvL, dbfIva, dbfDiv, dbfFacPrvP, cDivRet )

   local sTotal

   nTotFacPrv( cFactura, cFacPrvT, dbfFacPrvL, dbfIva, dbfDiv, dbfFacPrvP, nil, cDivRet )

   sTotal                                 := sTotal()
   sTotal:nTotalBruto                     := nTotBrt
   sTotal:nTotalNeto                      := nTotNet
   sTotal:nTotalIva                       := nTotIva
   sTotal:aTotalIva                       := aTotIva
   sTotal:nTotalRecargoEquivalencia       := nTotReq
   sTotal:nTotalDocumento                 := nTotFac
   sTotal:nTotalDescuentoGeneral          := nTotDto
   sTotal:nTotalDescuentoProntoPago       := nTotDpp
   sTotal:nTotalDescuentoUno              := nTotUno
   sTotal:nTotalDescuentoDos              := nTotDos

Return ( sTotal )

//--------------------------------------------------------------------------//

//
// Devuelve el precio neto de un articulo en un factura
//

FUNCTION nNetLFacPrv( uFacPrvL, uFacPrvT, nDec, nRec, nVdv, cPirDiv )

   local nCalculo

   DEFAULT nDec   := nDinDiv()
   DEFAULT nRec   := nRinDiv()
   DEFAULT nVdv   := 1

   nCalculo       := nNetUFacPrv( uFacPrvL, nDec, nRec, nVdv )

   nCalculo       *= nTotNFacPrv( uFacPrvL )

   /*
   Comprobamos los parametros--------------------------------------------------------------------
   */

   if ValType( uFacPrvL ) == "A"

      if uFacPrvL[ _NDTO ]!= 0
         nCalculo    -= nCalculo * uFacPrvL[ _NDTO ] / 100
      end if

   else

      if ( uFacPrvL )->nDto != 0
         nCalculo    -= nCalculo * ( uFacPrvL )->nDto / 100
      end if

   end if

   nCalculo          := Round( nCalculo, nRec )

RETURN ( if( cPirDiv != NIL, Trans( nCalculo, cPirDiv ), nCalculo ) )

//---------------------------------------------------------------------------//

FUNCTION aDocFacPrv()

   local aDoc  := {}

   /*
   Itmes-----------------------------------------------------------------------
   */

   aAdd( aDoc, { "Empresa",         "EM" } )
   aAdd( aDoc, { "Factura",         "FP" } )
   aAdd( aDoc, { "Proveedor",       "PR" } )
   aAdd( aDoc, { "Almacen",         "AL" } )
   aAdd( aDoc, { "Divisas",         "DV" } )
   aAdd( aDoc, { "Formas de pago",  "PG" } )
   aAdd( aDoc, { "Recibos",         "RP" } )

RETURN ( aDoc )

//--------------------------------------------------------------------------//

function aItmFacPrv()

   local aItmFacPrv  := {}

   aAdd( aItmFacPrv, { "CSERFAC"    ,"C",  1, 0, "Serie de factura"                         ,"",                   "", "( cDbf )", "A" } )
   aAdd( aItmFacPrv, { "NNUMFAC"    ,"N",  9, 0, "Número de factura"                        ,"'999999999'",        "", "( cDbf )", 0 } )
   aAdd( aItmFacPrv, { "CSUFFAC"    ,"C",  2, 0, "Sufijo de factura"                        ,"",                   "", "( cDbf )", Space( 2 ) } )
   aAdd( aItmFacPrv, { "CTURFAC"    ,"C",  6, 0, "Sesión del factura"                       ,"",                   "", "( cDbf )", nil } )
   aAdd( aItmFacPrv, { "DFECFAC"    ,"D",  8, 0, "Fecha de la factura"                      ,"",                   "", "( cDbf )", nil } )
   aAdd( aItmFacPrv, { "CCODPRV"    ,"C", 12, 0, "Código del proveedor"                     ,"",                   "", "( cDbf )", nil } )
   aAdd( aItmFacPrv, { "CCODALM"    ,"C",  3, 0, "Código de almacen"                        ,"",                   "", "( cDbf )", nil } )
   aAdd( aItmFacPrv, { "CCODCAJ"    ,"C",  3, 0, "Código de caja"                           ,"",                   "", "( cDbf )", nil } )
   aAdd( aItmFacPrv, { "CNOMPRV"    ,"C", 35, 0, "Nombre del proveedor"                     ,"'@!'",               "", "( cDbf )", nil } )
   aAdd( aItmFacPrv, { "CDIRPRV"    ,"C", 35, 0, "Domicilio del proveedor"                  ,"'@!'",               "", "( cDbf )", nil } )
   aAdd( aItmFacPrv, { "CPOBPRV"    ,"C", 25, 0, "Población del proveedor"                  ,"'@!'",               "", "( cDbf )", nil } )
   aAdd( aItmFacPrv, { "CPROVPROV"  ,"C", 20, 0, "Provincia del proveedor"                  ,"'@!'",               "", "( cDbf )", nil } )
   aAdd( aItmFacPrv, { "CPOSPRV"    ,"C",  5, 0, "Código postal del proveedor"              ,"",                   "", "( cDbf )", nil } )
   aAdd( aItmFacPrv, { "CDNIPRV"    ,"C", 30, 0, "DNI/CIF del proveedor"                    ,"",                   "", "( cDbf )", nil } )
   aAdd( aItmFacPrv, { "LLIQUIDADA" ,"L",  1, 0, "Lógico de la liquidación"                 ,"",                   "", "( cDbf )", nil } )
   aAdd( aItmFacPrv, { "LCONTAB"    ,"L",  1, 0, "Lógico de la contabilización"             ,"",                   "", "( cDbf )", nil } )
   aAdd( aItmFacPrv, { "DFECENT"    ,"D",  8, 0, "Fecha de entrada"                         ,"",                   "", "( cDbf )", nil } )
   aAdd( aItmFacPrv, { "CSUPED"     ,"C", 50, 0, "Su factura"                               ,"",                   "", "( cDbf )", nil } )
   aAdd( aItmFacPrv, { "CCONDENT"   ,"C", 20, 0, "Condición de entrada"                     ,"",                   "", "( cDbf )", nil } )
   aAdd( aItmFacPrv, { "MCOMENT"    ,"M", 10, 0, "Comentarios"                              ,"",                   "", "( cDbf )", nil } )
   aAdd( aItmFacPrv, { "CEXPED"     ,"C", 20, 0, "Expedición"                               ,"",                   "", "( cDbf )", nil } )
   aAdd( aItmFacPrv, { "COBSERV"    ,"C", 20, 0, "Observaciones"                            ,"",                   "", "( cDbf )", nil } )
   aAdd( aItmFacPrv, { "CCODPAGO"   ,"C",  2, 0, "Código del tipo de pago"                  ,"",                   "", "( cDbf )", nil } )
   aAdd( aItmFacPrv, { "NBULTOS"    ,"N",  3, 0, "Número de bultos"                         ,"",                   "", "( cDbf )", nil } )
   aAdd( aItmFacPrv, { "NPORTES"    ,"N",  6, 0, "Valor de los portes"                      ,"",                   "", "( cDbf )", nil } )
   aAdd( aItmFacPrv, { "CNUMALB"    ,"C", 12, 0, "Número de albaran"                        ,"",                   "", "( cDbf )", nil } )
   aAdd( aItmFacPrv, { "CSUFALB"    ,"C",  2, 0, "Sufijo de albaran"                        ,"",                   "", "( cDbf )", nil } )
   aAdd( aItmFacPrv, { "LIMPALB"    ,"L",  1, 0, "Factura importada desde albaranes"        ,"",                   "", "( cDbf )", nil } )
   aAdd( aItmFacPrv, { "CDTOESP"    ,"C", 50, 0, "Descripción de descuento especial"        ,"",                   "", "( cDbf )", nil } )
   aAdd( aItmFacPrv, { "NDTOESP"    ,"N",  5, 2, "Porcentaje de descuento especial"         ,"'@EZ 99.99'",        "", "( cDbf )", nil } )
   aAdd( aItmFacPrv, { "CDPP"       ,"C", 50, 0, "Descripción descuento por pronto pago"    ,"",                   "", "( cDbf )", nil } )
   aAdd( aItmFacPrv, { "NDPP"       ,"N",  5, 2, "Porcentaje de descuento por pronto pago"  ,"'@EZ 99.99'",        "", "( cDbf )", nil } )
   aAdd( aItmFacPrv, { "LRECARGO"   ,"L",  1, 0, "Lógico para recargo"                      ,"",                   "", "( cDbf )", nil } )
   aAdd( aItmFacPrv, { "NIRPF"      ,"N",  4, 1, ""                                         ,"'@EZ 99.99'",        "", "( cDbf )", nil } )
   aAdd( aItmFacPrv, { "CCODAGE"    ,"C",  3, 0, "Código del agente"                        ,"",                   "", "( cDbf )", nil } )
   aAdd( aItmFacPrv, { "CDIVFAC"    ,"C",  3, 0, "Código de divisa"                         ,"",                   "", "( cDbf )", nil } )
   aAdd( aItmFacPrv, { "NVDVFAC"    ,"N", 13, 6, "Valor del cambio de la divisa"            ,"'@E 999,999.999999'","", "( cDbf )", nil } )
   aAdd( aItmFacPrv, { "LSNDDOC"    ,"L",  1, 0, "Enviar documento por internet"            ,"",                   "", "( cDbf )", nil } )
   aAdd( aItmFacPrv, { "CDTOUNO"    ,"C", 25, 0, "Descripción de primer descuento personalizado", "",              "", "( cDbf )", nil } )
   aAdd( aItmFacPrv, { "NDTOUNO"    ,"N",  5, 2, "Porcentaje de primer descuento personalizado",  "",              "", "( cDbf )", nil } )
   aAdd( aItmFacPrv, { "CDTODOS"    ,"C", 25, 0, "Descripción de segundo descuento personalizado","",              "", "( cDbf )", nil } )
   aAdd( aItmFacPrv, { "NDTODOS"    ,"N",  5, 2, "Porcentaje de segundo descuento personalizado", "",              "", "( cDbf )", nil } )
   aAdd( aItmFacPrv, { "CCODPRO"    ,"C",  9, 0, "Código de proyecto en contabilidad",            "",              "", "( cDbf )", nil } )
   aAdd( aItmFacPrv, { "LRECDOC"    ,"L",  1, 0, "Documento recibido por internet"          ,"",                   "", "( cDbf )", nil } )
   aAdd( aItmFacPrv, { "LCLOFAC"    ,"L",  1, 0, ""                                         ,"",                   "", "( cDbf )", nil } )
   aAdd( aItmFacPrv, { "CNUMDOC"    ,"C", 50, 0, "Número de documento"                      ,"",                   "", "( cDbf )", nil } )
   aAdd( aItmFacPrv, { "CCODUSR"    ,"C",  3, 0, "Código de usuario",                        "",                   "", "( cDbf )", nil } )
   aAdd( aItmFacPrv, { "LIMPRIMIDO" ,"L",  1, 0, "Lógico de imprimido del documento",        "",                   "", "( cDbf )", nil } )
   aAdd( aItmFacPrv, { "DFECIMP"    ,"D",  8, 0, "Última fecha de impresión del documento",  "",                   "", "( cDbf )", nil } )
   aAdd( aItmFacPrv, { "CHORIMP"    ,"C",  5, 0, "Hora de la última impresión del documento","",                   "", "( cDbf )", nil } )
   aAdd( aItmFacPrv, { "nTipRet"    ,"N",  1, 0, "Tipo de retención ( 1. Base / 2. Base+IVA )","",                 "", "( cDbf )", nil } )
   aAdd( aItmFacPrv, { "nPctRet"    ,"N",  6, 2, "Porcentaje de retención IRPF",             "",                   "", "( cDbf )", nil } )
   aAdd( aItmFacPrv, { "dFecChg"    ,"D",  8, 0, "Fecha de modificación del documento",      "",                   "", "( cDbf )", nil } )
   aAdd( aItmFacPrv, { "cTimChg"    ,"C",  5, 0, "Hora de modificación del documento",       "",                   "", "( cDbf )", nil } )
   aAdd( aItmFacPrv, { "cCodDlg"    ,"C",  2, 0, "Código delegación",                        "",                   "", "( cDbf )", nil } )
   aAdd( aItmFacPrv, { "nRegIva"    ,"N",  1, 0, "Régimen de " + cImp(),                     "",                   "", "( cDbf )", nil } )
   aAdd( aItmFacPrv, { "lFacGas"    ,"L",  1, 0, "Lógico factura de gastos",                 "",                   "", "( cDbf )", nil } )
   aAdd( aItmFacPrv, { "mComGas"    ,"M", 10, 0, "Comentario de gastos",                     "",                   "", "( cDbf )", nil } )
   aAdd( aItmFacPrv, { "nNetGas1"   ,"N", 16, 6, "Primer importe neto de gastos",            "cPirDivFac",         "", "( cDbf )", nil } )
   aAdd( aItmFacPrv, { "nNetGas2"   ,"N", 16, 6, "Segundo importe neto de gastos",           "cPirDivFac",         "", "( cDbf )", nil } )
   aAdd( aItmFacPrv, { "nNetGas3"   ,"N", 16, 6, "Tercer importe neto de gastos",            "cPirDivFac",         "", "( cDbf )", nil } )
   aAdd( aItmFacPrv, { "nIvaGas1"   ,"N",  6, 2, "Porcentaje primer tipo " + cImp() + " de gastos",  "'@EZ 99.99'","", "( cDbf )", nil } )
   aAdd( aItmFacPrv, { "nIvaGas2"   ,"N",  6, 2, "Porcentaje segundo tipo " + cImp() + " de gastos", "'@EZ 99.99'","", "( cDbf )", nil } )
   aAdd( aItmFacPrv, { "nIvaGas3"   ,"N",  6, 2, "Porcentaje tercer tipo " + cImp() + " de gastos",  "'@EZ 99.99'","", "( cDbf )", nil } )
   aAdd( aItmFacPrv, { "nReGas1"    ,"N",  6, 2, "Porcentaje primer R.E. de gastos",         "'@EZ 99.99'",        "", "( cDbf )", nil } )
   aAdd( aItmFacPrv, { "nReGas2"    ,"N",  6, 2, "Porcentaje segundo R.E. de gastos",        "'@EZ 99.99'",        "", "( cDbf )", nil } )
   aAdd( aItmFacPrv, { "nReGas3"    ,"N",  6, 2, "Porcentaje tercer R.E. de gastos",         "'@EZ 99.99'",        "", "( cDbf )", nil } )
   aAdd( aItmFacPrv, { "nTotNet"    ,"N", 16, 6, "Total neto",                               "",                   "", "( cDbf )", nil } )
   aAdd( aItmFacPrv, { "nTotIva"    ,"N", 16, 6, "Total " + cImp(),                          "",                   "", "( cDbf )", nil } )
   aAdd( aItmFacPrv, { "nTotReq"    ,"N", 16, 6, "Total req",                                "",                   "", "( cDbf )", nil } )
   aAdd( aItmFacPrv, { "nTotFac"    ,"N", 16, 6, "Total factura",                            "",                   "", "( cDbf )", nil } )
   aAdd( aItmFacPrv, { "cNFC"       ,"C", 20, 0, "Código NFC" ,                              "'@!",                "", "( cDbf )", nil } )
   aAdd( aItmFacPrv, { "SubCta"     ,"C", 12, 0, "Código subcuenta para gastos enlace contaplus", "",              "", "( cDbf )", nil } )
   aAdd( aItmFacPrv, { "nTotSup"    ,"N", 16, 6, "Total gastos suplidos",                    "",                   "", "( cDbf )", nil } )
   aAdd( aItmFacPrv, { "cBanco"     ,"C", 50, 0, "Nombre del banco del proveedor" ,          "",                   "", "( cDbf )", nil } )
   aAdd( aItmFacPrv, { "cPaisIBAN"  ,"C",  2, 0, "País IBAN de la cuenta bancaria del proveedor" ,          "",    "", "( cDbf )", nil } )
   aAdd( aItmFacPrv, { "cCtrlIBAN"  ,"C",  2, 0, "Dígito de control IBAN de la cuenta bancaria del proveedor" , "","", "( cDbf )", nil } )
   aAdd( aItmFacPrv, { "cEntBnc"    ,"C",  4, 0, "Entidad de la cuenta bancaria del proveedor" ,          "",      "", "( cDbf )", nil } )
   aAdd( aItmFacPrv, { "cSucBnc"    ,"C",  4, 0, "Sucursal de la cuenta bancaria del proveedor" ,         "",      "", "( cDbf )", nil } )
   aAdd( aItmFacPrv, { "cDigBnc"    ,"C",  2, 0, "Dígito de control de la cuenta bancaria del proveedor" ,"",      "", "( cDbf )", nil } )
   aAdd( aItmFacPrv, { "cCtaBnc"    ,"C", 10, 0, "Cuenta bancaria del proveedor" ,                        "",      "", "( cDbf )", nil } )
   aAdd( aItmFacPrv, { "lRECC"      ,"L",  1, 0, "Acogida al régimen especial del criterio de caja",      "",      "", "( cDbf )", .f. } )

return ( aItmFacPrv )

//---------------------------------------------------------------------------//

function aCalFacPrv()

   local aCalFacPrv :=  {{"aTotIva[1,1]", "N", 16,  6, "Bruto primer tipo de " + cImp(),    "cPirDivFac",         "aTotIva[1,1] != 0" },;
                        { "aTotIva[2,1]", "N", 16,  6, "Bruto segundo tipo de " + cImp(),   "cPirDivFac",         "aTotIva[2,1] != 0" },;
                        { "aTotIva[3,1]", "N", 16,  6, "Bruto tercer tipo de " + cImp(),    "cPirDivFac",         "aTotIva[3,1] != 0" },;
                        { "aTotIva[1,2]", "N", 16,  6, "Base primer tipo de " + cImp(),     "cPirDivFac",         "aTotIva[1,2] != 0" },;
                        { "aTotIva[2,2]", "N", 16,  6, "Base segundo tipo de " + cImp(),    "cPirDivFac",         "aTotIva[2,2] != 0" },;
                        { "aTotIva[3,2]", "N", 16,  6, "Base tercer tipo de " + cImp(),     "cPirDivFac",         "aTotIva[3,2] != 0" },;
                        { "aTotIva[1,3]", "N",  6,  2, "Porcentaje primer tipo " + cImp(),  "'@R 99 %'",          "aTotIva[1,3] != 0" },;
                        { "aTotIva[2,3]", "N",  6,  2, "Porcentaje segundo tipo " + cImp(), "'@R 99 %'",          "aTotIva[2,3] != 0" },;
                        { "aTotIva[3,3]", "N",  6,  2, "Porcentaje tercer tipo " + cImp(),  "'@R 99 %'",          "aTotIva[3,3] != 0" },;
                        { "aTotIva[1,4]", "N",  6,  2, "Porcentaje primer tipo RE",   "'@R 99 %'",          "aTotIva[1,4] != 0" },;
                        { "aTotIva[2,4]", "N",  6,  2, "Porcentaje segundo tipo RE",  "'@R 99 %'",          "aTotIva[2,4] != 0" },;
                        { "aTotIva[3,4]", "N",  6,  2, "Porcentaje tercer tipo RE",   "'@R 99 %'",          "aTotIva[3,4] != 0" },;
                        { "Round( aTotIva[1,2] * aTotIva[1,3] / 100, nDouDivFac )",   "N", 16, 6, "Importe primer tipo " + cImp(),  "cPirDivFac", "aTotIva[1,2] != 0" },;
                        { "Round( aTotIva[2,2] * aTotIva[2,3] / 100, nDouDivFac )",   "N", 16, 6, "Importe segundo tipo " + cImp(), "cPirDivFac", "aTotIva[2,2] != 0" },;
                        { "Round( aTotIva[3,2] * aTotIva[3,3] / 100, nDouDivFac )",   "N", 16, 6, "Importe tercer tipo " + cImp(),  "cPirDivFac", "aTotIva[3,2] != 0" },;
                        { "Round( aTotIva[1,2] * aTotIva[1,4] / 100, nDouDivFac )",   "N", 16, 6, "Importe primer RE",        "cPirDivFac", "aTotIva[1,2] != 0" },;
                        { "Round( aTotIva[2,2] * aTotIva[2,4] / 100, nDouDivFac )",   "N", 16, 6, "Importe segundo RE",       "cPirDivFac", "aTotIva[2,2] != 0" },;
                        { "Round( aTotIva[3,2] * aTotIva[3,4] / 100, nDouDivFac )",   "N", 16, 6, "Importe tercer RE",        "cPirDivFac", "aTotIva[3,2] != 0" },;
                        { "nTotBrt",      "N", 16,  6, "Total bruto",                 "cPirDivFac",         "lEnd" },;
                        { "nTotDto",      "N", 16,  6, "Total descuento",             "cPirDivFac",         "lEnd" },;
                        { "nTotDpp",      "N", 16,  6, "Total descuento pronto pago", "cPirDivFac",         "lEnd" },;
                        { "nTotNet",      "N", 16,  6, "Total neto",                  "cPirDivFac",         "lEnd" },;
                        { "nTotIva",      "N", 16,  6, "Total " + cImp(),             "cPirDivFac",         "lEnd" },;
                        { "nTotReq",      "N", 16,  6, "Total RE",                    "cPirDivFac",         "lEnd" },;
                        { "nTotRet",      "N", 16,  6, "Total retenciones por IRPF",  "cPirDivFac",         "lEnd" },;
                        { "nTotFac",      "N", 16,  6, "Total factura",               "cPirDivFac",         "lEnd" },;
                        { "nTotPage",     "N", 16,  6, "Total página",                "cPirDivFac",         "!lEnd" },;
                        { "nPagina",      "N",  2,  0, "Número de página",            "'99'",               "" },;
                        { "lEnd",         "L",  1,  0, "Fin del documento",           "",                   "" } }

return ( aCalFacPrv )

//---------------------------------------------------------------------------//

function aColFacPrv()

   local aColFacPrv  := {}

   aAdd( aColFacPrv, { "CSERFAC"    ,"C",  1, 0, "Serie de factura"            ,"",                    "", "( cDbfCol )", "A" } )
   aAdd( aColFacPrv, { "NNUMFAC"    ,"N",  9, 0, "Número de factura"           ,"'999999999'",         "", "( cDbfCol )", 0 } )
   aAdd( aColFacPrv, { "CSUFFAC"    ,"C",  2, 0, "Sufijo de factura"           ,"",                    "", "( cDbfCol )", Space( 2 ) } )
   aAdd( aColFacPrv, { "CREF"       ,"C", 18, 0, "Referencia artículo"         ,"",                    "", "( cDbfCol )", nil } )
   aAdd( aColFacPrv, { "CREFPRV"    ,"C", 20, 0, "Referencia del proveedor"    ,"",                    "", "( cDbfCol )", nil } )
   aAdd( aColFacPrv, { "CDETALLE"   ,"C",240, 0, "Detalle de articulo"         ,"",                    "", "( cDbfCol )", nil } )
   aAdd( aColFacPrv, { "NPREUNIT"   ,"N", 16, 6, "Precio unitario"             ,"cPinDivFac",          "", "( cDbfCol )", nil } )
   aAdd( aColFacPrv, { "NDTO"       ,"N",  6, 2, ""                            ,"'@E 99,99'",          "", "( cDbfCol )", nil } )
   aAdd( aColFacPrv, { "NIVA"       ,"N",  6, 2, "Porcentaje de " + cImp()     ,"'@E 99,99'",          "", "( cDbfCol )", nil } )
   aAdd( aColFacPrv, { "NCANENT"    ,"N", 16, 6, "Cajas recibidas"             ,"MasUnd()",            "", "( cDbfCol )", nil } )
   aAdd( aColFacPrv, { "LCONTROL"   ,"L",  1, 0, "Control reservado"           ,"",                    "", "( cDbfCol )", nil } )
   aAdd( aColFacPrv, { "CUNIDAD"    ,"C",  2, 0, "Unidad de venta"             ,"",                    "", "( cDbfCol )", nil } )
   aAdd( aColFacPrv, { "NUNICAJA"   ,"N", 16, 6, "Unidades recibidas"          ,"MasUnd()",            "", "( cDbfCol )", nil } )
   aAdd( aColFacPrv, { "LCHGLIN"    ,"L",  1, 0, "Cambio de precio"            ,"",                    "", "( cDbfCol )", nil } )
   aAdd( aColFacPrv, { "MLNGDES"    ,"M", 10, 0, "Descripción larga de artículo","",                   "", "( cDbfCol )", nil } )
   aAdd( aColFacPrv, { "NDTOLIN"    ,"N",  6, 2, "Descuento lineal"            ,"'@E 999,99'",         "", "( cDbfCol )", nil } )
   aAdd( aColFacPrv, { "NDTOPRM"    ,"N",  6, 2, "Descuento por promoción"     ,"'@E 999,99'",         "", "( cDbfCol )", nil } )
   aAdd( aColFacPrv, { "NDTORAP"    ,"N",  6, 2, "Descuento por rappels"       ,"'@E 999,99'",         "", "( cDbfCol )", nil } )
   aAdd( aColFacPrv, { "NPRECOM"    ,"N", 16, 6, "Precio de compra"            ,"cPinDivFac",          "", "( cDbfCol )", nil } )
   aAdd( aColFacPrv, { "LBNFLIN1"   ,"L",  1, 0, ""                            ,"",                    "", "( cDbfCol )", nil } )
   aAdd( aColFacPrv, { "LBNFLIN2"   ,"L",  1, 0, ""                            ,"",                    "", "( cDbfCol )", nil } )
   aAdd( aColFacPrv, { "LBNFLIN3"   ,"L",  1, 0, ""                            ,"",                    "", "( cDbfCol )", nil } )
   aAdd( aColFacPrv, { "LBNFLIN4"   ,"L",  1, 0, ""                            ,"",                    "", "( cDbfCol )", nil } )
   aAdd( aColFacPrv, { "LBNFLIN5"   ,"L",  1, 0, ""                            ,"",                    "", "( cDbfCol )", nil } )
   aAdd( aColFacPrv, { "LBNFLIN6"   ,"L",  1, 0, ""                            ,"",                    "", "( cDbfCol )", nil } )
   aAdd( aColFacPrv, { "NBNFLIN1"   ,"N",  6, 2, ""                            ,"",                    "", "( cDbfCol )", nil } )
   aAdd( aColFacPrv, { "NBNFLIN2"   ,"N",  6, 2, ""                            ,"",                    "", "( cDbfCol )", nil } )
   aAdd( aColFacPrv, { "NBNFLIN3"   ,"N",  6, 2, ""                            ,"",                    "", "( cDbfCol )", nil } )
   aAdd( aColFacPrv, { "NBNFLIN4"   ,"N",  6, 2, ""                            ,"",                    "", "( cDbfCol )", nil } )
   aAdd( aColFacPrv, { "NBNFLIN5"   ,"N",  6, 2, ""                            ,"",                    "", "( cDbfCol )", nil } )
   aAdd( aColFacPrv, { "NBNFLIN6"   ,"N",  6, 2, ""                            ,"",                    "", "( cDbfCol )", nil } )
   aAdd( aColFacPrv, { "NBNFSBR1"   ,"N",  1, 0, ""                            ,"",                    "", "( cDbfCol )", nil } )
   aAdd( aColFacPrv, { "NBNFSBR2"   ,"N",  1, 0, ""                            ,"",                    "", "( cDbfCol )", nil } )
   aAdd( aColFacPrv, { "NBNFSBR3"   ,"N",  1, 0, ""                            ,"",                    "", "( cDbfCol )", nil } )
   aAdd( aColFacPrv, { "NBNFSBR4"   ,"N",  1, 0, ""                            ,"",                    "", "( cDbfCol )", nil } )
   aAdd( aColFacPrv, { "NBNFSBR5"   ,"N",  1, 0, ""                            ,"",                    "", "( cDbfCol )", nil } )
   aAdd( aColFacPrv, { "NBNFSBR6"   ,"N",  1, 0, ""                            ,"",                    "", "( cDbfCol )", nil } )
   aAdd( aColFacPrv, { "NPVPLIN1"   ,"N", 16, 6, ""                            ,"",                    "", "( cDbfCol )", nil } )
   aAdd( aColFacPrv, { "NPVPLIN2"   ,"N", 16, 6, ""                            ,"",                    "", "( cDbfCol )", nil } )
   aAdd( aColFacPrv, { "NPVPLIN3"   ,"N", 16, 6, ""                            ,"",                    "", "( cDbfCol )", nil } )
   aAdd( aColFacPrv, { "NPVPLIN4"   ,"N", 16, 6, ""                            ,"",                    "", "( cDbfCol )", nil } )
   aAdd( aColFacPrv, { "NPVPLIN5"   ,"N", 16, 6, ""                            ,"",                    "", "( cDbfCol )", nil } )
   aAdd( aColFacPrv, { "NPVPLIN6"   ,"N", 16, 6, ""                            ,"",                    "", "( cDbfCol )", nil } )
   aAdd( aColFacPrv, { "NIVALIN1"   ,"N", 16, 6, ""                            ,"",                    "", "( cDbfCol )", nil } )
   aAdd( aColFacPrv, { "NIVALIN2"   ,"N", 16, 6, ""                            ,"",                    "", "( cDbfCol )", nil } )
   aAdd( aColFacPrv, { "NIVALIN3"   ,"N", 16, 6, ""                            ,"",                    "", "( cDbfCol )", nil } )
   aAdd( aColFacPrv, { "NIVALIN4"   ,"N", 16, 6, ""                            ,"",                    "", "( cDbfCol )", nil } )
   aAdd( aColFacPrv, { "NIVALIN5"   ,"N", 16, 6, ""                            ,"",                    "", "( cDbfCol )", nil } )
   aAdd( aColFacPrv, { "NIVALIN6"   ,"N", 16, 6, ""                            ,"",                    "", "( cDbfCol )", nil } )
   aAdd( aColFacPrv, { "NIVALIN"    ,"N",  6, 2, ""                            ,"",                    "", "( cDbfCol )", nil } )
   aAdd( aColFacPrv, { "LIVALIN"    ,"L",  1, 0, ""                            ,"",                    "", "( cDbfCol )", nil } )
   aAdd( aColFacPrv, { "CCODPR1"    ,"C", 20, 0, "Código de la propiedad 1",     "",                   "", "( cDbfCol )", nil } )
   aAdd( aColFacPrv, { "CCODPR2"    ,"C", 20, 0, "Código de la propiedad 2",     "",                   "", "( cDbfCol )", nil } )
   aAdd( aColFacPrv, { "CVALPR1"    ,"C", 20, 0, "Valor de la propiedad 1" ,     "",                   "", "( cDbfCol )", nil } )
   aAdd( aColFacPrv, { "CVALPR2"    ,"C", 20, 0, "Valor de la propiedad 2" ,     "",                   "", "( cDbfCol )", nil } )
   aAdd( aColFacPrv, { "NFACCNV"    ,"N", 16, 6, "Factor de conversión de la compra", "",              "", "( cDbfCol )", nil } )
   aAdd( aColFacPrv, { "CALMLIN"    ,"C",  3, 0, "Código del almacen" ,          "",                   "", "( cDbfCol )", nil } )
   aAdd( aColFacPrv, { "NCTLSTK"    ,"N",  1, 0, "Tipo de stock de la línea",    "'9'",                "", "( cDbfCol )", nil } )
   aAdd( aColFacPrv, { "LLOTE"      ,"L",  1, 0, "",                             "",                   "", "( cDbfCol )", nil } )
   aAdd( aColFacPrv, { "NLOTE"      ,"N",  9, 0, "",                             "'999999999'",        "", "( cDbfCol )", nil } )
   aAdd( aColFacPrv, { "CLOTE"      ,"C", 12, 0, "Número de lote",               "",                   "", "( cDbfCol )", nil } )
   aAdd( aColFacPrv, { "NNUMLIN"    ,"N",  4, 0, "Número de la línea",           "9999",               "", "( cDbfCol )", nil } )
   aAdd( aColFacPrv, { "NUNDKIT"    ,"N", 16, 6, "Unidades del producto kit",    "MasUnd()",           "", "( cDbfCol )", nil } )
   aAdd( aColFacPrv, { "LKITART"    ,"L",  1, 0, "Línea con escandallo",         "",                   "", "( cDbfCol )", nil } )
   aAdd( aColFacPrv, { "LKITCHL"    ,"L",  1, 0, "Línea pertenciente a escandallo", "",                "", "( cDbfCol )", nil } )
   aAdd( aColFacPrv, { "LKITPRC"    ,"L",  1, 0, "",                             "",                   "", "( cDbfCol )", nil } )
   aAdd( aColFacPrv, { "LIMPLIN"    ,"L",  1, 0, "Imprimir linea",               "",                   "", "( cDbfCol )", nil } )
   aAdd( aColFacPrv, { "MNUMSER"    ,"M", 10, 0, "" ,                            "",                   "", "( cDbfCol )", nil } )
   aAdd( aColFacPrv, { "CCODUBI1"   ,"C",  5, 0, "",                             "",                   "", "( cDbfCol )", nil } )
   aAdd( aColFacPrv, { "CCODUBI2"   ,"C",  5, 0, "",                             "",                   "", "( cDbfCol )", nil } )
   aAdd( aColFacPrv, { "CCODUBI3"   ,"C",  5, 0, "",                             "",                   "", "( cDbfCol )", nil } )
   aAdd( aColFacPrv, { "CVALUBI1"   ,"C",  5, 0, "",                             "",                   "", "( cDbfCol )", nil } )
   aAdd( aColFacPrv, { "CVALUBI2"   ,"C",  5, 0, "",                             "",                   "", "( cDbfCol )", nil } )
   aAdd( aColFacPrv, { "CVALUBI3"   ,"C",  5, 0, "",                             "",                   "", "( cDbfCol )", nil } )
   aAdd( aColFacPrv, { "CNOMUBI1"   ,"C", 30, 0, "",                             "",                   "", "( cDbfCol )", nil } )
   aAdd( aColFacPrv, { "CNOMUBI2"   ,"C", 30, 0, "",                             "",                   "", "( cDbfCol )", nil } )
   aAdd( aColFacPrv, { "CNOMUBI3"   ,"C", 30, 0, "",                             "",                   "", "( cDbfCol )", nil } )
   aAdd( aColFacPrv, { "CCODFAM"    ,"C", 16, 0, "Código de familia",            "",                   "", "( cDbfCol )", nil } )
   aAdd( aColFacPrv, { "CGRPFAM"    ,"C",  3, 0, "Código del grupo de familia",  "",                   "", "( cDbfCol )", nil } )
   aAdd( aColFacPrv, { "NREQ"       ,"N", 16, 6, "Recargo de equivalencia",      "",                   "", "( cDbfCol )", nil } )
   aAdd( aColFacPrv, { "MOBSLIN"    ,"M", 10, 0, "Observacion de línea",         "",                   "", "( cDbfCol )", nil } )
   aAdd( aColFacPrv, { "nPvpRec"    ,"N", 16, 6, "Precio de venta recomendado",  "cPinDivFac",         "", "( cDbfCol )", nil } )
   aAdd( aColFacPrv, { "nNumMed"    ,"N",  1, 0, "Número de mediciones",         "MasUnd()",           "", "( cDbfCol )", nil } )
   aAdd( aColFacPrv, { "nMedUno"    ,"N", 16, 6, "Primera unidad de medición",   "MasUnd()",           "", "( cDbfCol )", nil } )
   aAdd( aColFacPrv, { "nMedDos"    ,"N", 16, 6, "Segunda unidad de medición",   "MasUnd()",           "", "( cDbfCol )", nil } )
   aAdd( aColFacPrv, { "nMedTre"    ,"N", 16, 6, "Tercera unidad de medición",   "MasUnd()",           "", "( cDbfCol )", nil } )
   aAdd( aColFacPrv, { "dFecCad"    ,"D",  8, 0, "Fecha de caducidad",           "",                   "", "( cDbfCol )", nil } )
   aAdd( aColFacPrv, { "nUndLin"    ,"N",  5, 0, "",                             "",                   "", "( cDbfCol )", nil } )
   aAdd( aColFacPrv, { "lLabel"     ,"L",  1, 0, "Lógico de etiqueta",           "",                   "", "( cDbfCol )", nil } )
   aAdd( aColFacPrv, { "nLabel"     ,"N",  5, 0, "Número de etiquetas",          "",                   "", "( cDbfCol )", nil } )
   aAdd( aColFacPrv, { "cSuPed"     ,"C", 10, 0, "Su pedido",                    "",                   "", "( cDbfCol )", nil } )
   aAdd( aColFacPrv, { "lGasSup"    ,"L",  1, 0, "Linea de gastos suplidos",     "",                   "", "( cDbfCol )", nil } )
   aAdd( aColFacPrv, { "dFecFac"    ,"D",  8, 0, "Fecha de la factura",          "",                   "", "( cDbfCol )", nil } )
   aAdd( aColFacPrv, { "cCodPrv"    ,"C", 12, 0, "Código de proveedor",          "",                   "", "( cDbfCol )", nil } )
   aAdd( aColFacPrv, { "lNumSer"    ,"L",  1, 0, "Lógico solicitar numero de serie", "",               "", "( cDbfCol )", nil } )
   aAdd( aColFacPrv, { "lAutSer"    ,"L",  1, 0, "Lógico de autoserializar",     "",                   "", "( cDbfCol )", nil } )

return ( aColFacPrv )

//---------------------------------------------------------------------------//

function aCocFacPrv()

   local aCocFacPrv  := {{"( Descrip( cDbfCol ) )",                                           "C", 50, 0, "Descripción larga",           "",            "Descripción", "" },;
                        { "( nTotNFacPrv( cDbfCol ) )",                                       "N", 16, 6, "Total unidades",              "cPinDivFac",  cNombreUnidades(),    "" },;
                        { "( nTotUFacPrv( cDbfCol, nDinDivFac, nVdvDivFac ) )",               "N", 16, 6, "Precio unitario de factura",  "cPinDivFac",  "Precio",      "" },;
                        { "( nTotLFacPrv( cDbfCol, nDinDivFac, nDirDivFac, nVdvDivFac ) )",   "N", 16, 6, "Total linea de factura",      "cPirDivFac",  "Total",       "" } }

return ( aCocFacPrv )

//---------------------------------------------------------------------------//

function aSerFacPrv()

   local aColFacPrv  := {}

   aAdd( aColFacPrv,  { "cSerFac", "C",  1,   0, "",                                 "",                  "", "( cDbfCol )" } )
   aAdd( aColFacPrv,  { "nNumFac", "N",  9,   0, "",                                 "",                  "", "( cDbfCol )" } )
   aAdd( aColFacPrv,  { "cSufFac", "C",  2,   0, "",                                 "",                  "", "( cDbfCol )" } )
   aAdd( aColFacPrv,  { "dFecFac", "D",  8,   0, "",                                 "",                  "", "( cDbfCol )" } )
   aAdd( aColFacPrv,  { "nNumLin", "N",  4,   0, "Número de la línea",               "'9999'",            "", "( cDbfCol )" } )
   aAdd( aColFacPrv,  { "cRef",    "C", 18,   0, "Referencia del artículo",          "",                  "", "( cDbfCol )" } )
   aAdd( aColFacPrv,  { "cAlmLin", "C",  3,   0, "Código de almacen",                "",                  "", "( cDbfCol )" } )
   aAdd( aColFacPrv,  { "lUndNeg", "L",  1,   0, "Lógico de unidades en negativo",   "",                  "", "( cDbfCol )" } )
   aAdd( aColFacPrv,  { "cNumSer", "C", 30,   0, "Numero de serie",                  "",                  "", "( cDbfCol )" } )

return ( aColFacPrv )

//---------------------------------------------------------------------------//

Function SynFacPrv( cPath )

   local oError
   local oBlock      
   local aTotFac
   local aNumSer
   local cNumSer

   BEGIN SEQUENCE
   oBlock            := ErrorBlock( { | oError | ApoloBreak( oError ) } )

   dbUseArea( .t., cDriver(), cPath + "FacPrvT.DBF", cCheckArea( "FacPrvT", @dbfFacPrvT ), .f. )
   if !lAIS(); ordListAdd( cPath + "FacPrvT.CDX" ); else ; ordSetFocus( 1 ) ; end

   dbUseArea( .t., cDriver(), cPath + "FacPrvL.DBF", cCheckArea( "FacPrvL", @dbfFacPrvL ), .f. )
   if !lAIS(); ordListAdd( cPath + "FacPrvL.CDX" ); else ; ordSetFocus( 1 ) ; end

   dbUseArea( .t., cDriver(), cPath + "FacPrvS.DBF", cCheckArea( "FacPrvS", @dbfFacPrvS ), .f. )
   if !lAIS(); ordListAdd( cPath + "FacPrvS.CDX" ); else ; ordSetFocus( 1 ) ; end

   dbUseArea( .t., cDriver(), cPath + "FacPRVI.DBF", cCheckArea( "FacPRVI", @dbfFacPrvI ), .f. )
   if !lAIS(); ordListAdd( cPath + "FacPRVI.CDX" ); else ; ordSetFocus( 1 ) ; end

   dbUseArea( .t., cDriver(), cPath + "FacPrvP.DBF", cCheckArea( "FacPrvP", @dbfFacPrvP ), .f. )
   if !lAIS(); ordListAdd( cPath + "FacPrvP.CDX" ); else ; ordSetFocus( 1 ) ; end

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

   // Cabeceras -------------------------------------------------------------------

   ( dbfFacPrvT )->( OrdSetFocus( 0 ) )
   ( dbfFacPrvT )->( dbGoTop() )
   
   while !( dbfFacPrvT )->( eof() )

      if Empty( ( dbfFacPrvT )->cSufFac )
         ( dbfFacPrvT )->cSufFac := "00"
      end if

      if !Empty( ( dbfFacPrvT )->cNumAlb ) .and. Len( AllTrim( ( dbfFacPrvT )->cNumAlb ) ) != 12
         ( dbfFacPrvT )->cNumAlb := AllTrim( ( dbfFacPrvT )->cNumAlb ) + "00"
      end if

      if Empty( ( dbfFacPrvT )->cCodCaj )
         ( dbfFacPrvT )->cCodCaj := "000"
      end if

      if Empty( ( dbfFacPrvT )->cPaisIBAN )
         ( dbfFacPrvT )->cPaisIBAN  := "ES"
      end if 

      if Empty( ( dbfFacPrvT )->cCtrlIBAN )
         ( dbfFacPrvT )->cCtrlIBAN  := IbanDigit( ( dbfFacPrvT )->cPaisIBAN, ( dbfFacPrvT )->cEntBnc, ( dbfFacPrvT )->cSucBnc, ( dbfFacPrvT )->cDigBnc, ( dbfFacPrvT )->cCtaBnc )
      end if 

      ( dbfFacPrvT )->( dbSkip() )

      SysRefresh()

   end while

   ( dbfFacPrvT )->( OrdSetFocus( 1 ) )

   /*
   lineas de facturas de proveedores-------------------------------------------
   */

   ( dbfFacPrvL )->( OrdSetFocus( 0 ) )
   ( dbfFacPrvL )->( dbGoTop() )

   while !( dbfFacPrvL )->( eof() )

      if Empty( ( dbfFacPrvL )->cSufFac )
         ( dbfFacPrvL )->cSufFac := "00"
      end if

      if Empty( ( dbfFacPrvL )->cLote ) .and. !Empty( ( dbfFacPrvL )->nLote )
         ( dbfFacPrvL )->cLote   := AllTrim( Str( ( dbfFacPrvL )->nLote ) )
      end if

      if !Empty( ( dbfFacPrvL )->cRef ) .and. Empty( ( dbfFacPrvL )->cCodFam )
         ( dbfFacPrvL )->cCodFam := RetFamArt( ( dbfFacPrvL )->cRef, dbfArticulo )
      end if

      if !Empty( ( dbfFacPrvL )->cRef ) .and. !Empty( ( dbfFacPrvL )->cCodFam )
         ( dbfFacPrvL )->cGrpFam := cGruFam( ( dbfFacPrvL )->cCodFam, dbfFamilia )
      end if

      if Empty( ( dbfFacPrvL )->nReq )
         ( dbfFacPrvL )->nReq    := nPReq( dbfIva, ( dbfFacPrvL )->nIva )
      end if

      if ( dbfFacPrvL )->dFecFac != RetFld( ( dbfFacPrvL )->cSerFac + Str( ( dbfFacPrvL )->nNumFac ) + ( dbfFacPrvL )->cSufFac, dbfFacPrvT, "dFecFac" )
         ( dbfFacPrvL )->dFecFac := RetFld( ( dbfFacPrvL )->cSerFac + Str( ( dbfFacPrvL )->nNumFac ) + ( dbfFacPrvL )->cSufFac, dbfFacPrvT, "dFecFac" )
      end if

      if Empty( ( dbfFacPrvL )->cAlmLin )
         ( dbfFacPrvL )->cAlmLin    := RetFld( ( dbfFacPrvL )->cSerFac + Str( ( dbfFacPrvL )->nNumFac ) + ( dbfFacPrvL )->cSufFac, dbfFacPrvT, "cCodAlm" )
      end if

      if !Empty( ( dbfFacPrvL )->mNumSer )
         aNumSer                       := hb_aTokens( ( dbfFacPrvL )->mNumSer, "," )
         for each cNumSer in aNumSer
            ( dbfFacPrvS )->( dbAppend() )
            ( dbfFacPrvS )->cSerFac    := ( dbfFacPrvL )->cSerFac
            ( dbfFacPrvS )->nNumFac    := ( dbfFacPrvL )->nNumFac
            ( dbfFacPrvS )->cSufFac    := ( dbfFacPrvL )->cSufFac
            ( dbfFacPrvS )->cRef       := ( dbfFacPrvL )->cRef
            ( dbfFacPrvS )->cAlmLin    := ( dbfFacPrvL )->cAlmLin
            ( dbfFacPrvS )->nNumLin    := ( dbfFacPrvL )->nNumLin
            ( dbfFacPrvS )->cNumSer    := cNumSer
         next
         ( dbfFacPrvL )->mNumSer       := ""
      end if

      ( dbfFacPrvL )->( dbSkip() )

      SysRefresh()

   end while

   ( dbfFacPrvL )->( OrdSetFocus( 1 ) )

   // Lineas ------------------------------------------------------------------

   ( dbfFacPrvI )->( OrdSetFocus( 0 ) )
   ( dbfFacPrvI )->( dbGoTop() )
   
   while !( dbfFacPrvI )->( eof() )

      if Empty( ( dbfFacPrvI )->cSufFac )
         ( dbfFacPrvI )->cSufFac := "00"
      end if

      ( dbfFacPrvI )->( dbSkip() )

      SysRefresh()

   end while
   
   ( dbfFacPrvI )->( OrdSetFocus( 1 ) )

   // Series ---------------------------------------------------------------

   ( dbfFacPrvS )->( OrdSetFocus( 0 ) )
   ( dbfFacPrvS )->( dbGoTop() )
   
   while !( dbfFacPrvS )->( eof() )

      if Empty( ( dbfFacPrvS )->cSufFac )
         ( dbfFacPrvS )->cSufFac := "00"
      end if

      if ( dbfFacPrvS )->dFecFac != ( dbfFacPrvT )->dFecFac
         ( dbfFacPrvS )->dFecFac := ( dbfFacPrvT )->dFecFac
      end if

      ( dbfFacPrvS )->( dbSkip() )

      SysRefresh()

   end while

   ( dbfFacPrvS )->( OrdSetFocus( 1 ) )

   // Totales -------------------------------------------------------------------

   ( dbfFacPrvT )->( OrdSetFocus( 0 ) )
   ( dbfFacPrvT )->( dbGoTop() )

   while !( dbfFacPrvT )->( eof() )

      if ( dbfFacPrvT )->nTotFac == 0 .and. dbLock( dbfFacPrvT )

         aTotFac                 := aTotFacPrv( ( dbfFacPrvT )->cSerFac + Str( ( dbfFacPrvT )->nNumFac ) + ( dbfFacPrvT )->cSufFac, dbfFacPrvT, dbfFacPrvL, dbfIva, dbfDiv, dbfFacPrvP, ( dbfFacPrvT )->cDivFac )

         ( dbfFacPrvT )->nTotNet := aTotFac[1]
         ( dbfFacPrvT )->nTotIva := aTotFac[2]
         ( dbfFacPrvT )->nTotReq := aTotFac[3]
         ( dbfFacPrvT )->nTotFac := aTotFac[4]

         ( dbfFacPrvT )->( dbUnLock() )

      end if

      ( dbfFacPrvT )->( dbSkip() )

      SysRefresh()

   end while

   RECOVER USING oError

      msgStop( "Imposible sincronizar factura de proveedores" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   if !Empty( dbfFacPrvT ) .and. ( dbfFacPrvT )->( Used() )
      ( dbfFacPrvT )->( dbCloseArea() )
   end if

   if !Empty( dbfFacPrvL ) .and. ( dbfFacPrvL )->( Used() )
      ( dbfFacPrvL )->( dbCloseArea() )
   end if

   if !Empty( dbfFacPrvS ) .and. ( dbfFacPrvS )->( Used() )
      ( dbfFacPrvS )->( dbCloseArea() )
   end if

   if !Empty( dbfFacPrvI ) .and. ( dbfFacPrvI )->( Used() )
      ( dbfFacPrvI )->( dbCloseArea() )
   end if

   if !Empty( dbfFacPrvP ) .and. ( dbfFacPrvP )->( Used() )
      ( dbfFacPrvP )->( dbCloseArea() )
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

return nil

//------------------------------------------------------------------------//
//------------------------------------------------------------------------//
//------------------------------------------------------------------------//
//------------------------------------------------------------------------//
//------------------------------------------------------------------------//
//------------------------------------------------------------------------//

CLASS TFacturasProveedorSenderReciver FROM TSenderReciverItem

   Method CreateData()

   Method RestoreData()

   Method SendData()

   Method ReciveData()

   Method Process()

END CLASS

//----------------------------------------------------------------------------//

Method CreateData() CLASS TFacturasProveedorSenderReciver

   local oBlock
   local oError
   local lSnd        := .f.
   local cFacPrvT
   local dbfFacPrvL
   local dbfFacPrvI
   local dbfFacPrvP
   local cFileName   := "FacPrv" + StrZero( ::nGetNumberToSend(), 6 ) + "." + RetSufEmp()

   ::oSender:SetText( "Enviando facturas a proveedores" )

   oBlock            := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   USE ( cPatEmp() + "FACPRVT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACPRVT", @cFacPrvT ) )
   SET ADSINDEX TO ( cPatEmp() + "FACPRVT.CDX" ) ADDITIVE

   USE ( cPatEmp() + "FACPRVL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACPRVL", @dbfFacPrvL ) )
   SET ADSINDEX TO ( cPatEmp() + "FACPRVL.CDX" ) ADDITIVE

   USE ( cPatEmp() + "FacPrvI.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FacPrvI", @dbfFacPrvI ) )
   SET ADSINDEX TO ( cPatEmp() + "FacPrvI.CDX" ) ADDITIVE

   USE ( cPatEmp() + "FacPrvP.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FacPrvP", @dbfFacPrvP ) )
   SET ADSINDEX TO ( cPatEmp() + "FacPrvP.CDX" ) ADDITIVE

   /*
   Creamos todas las bases de datos relacionadas con Articulos
   */

   rxFacPrv( cPatSnd() )
   rxRecPrv( cPatSnd() )

   USE ( cPatSnd() + "FACPRVT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACPRVT", @tmpFacPrvT ) )
   SET ADSINDEX TO ( cPatSnd() + "FACPRVT.CDX" ) ADDITIVE

   USE ( cPatSnd() + "FACPRVL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACPRVL", @tmpFacPrvL ) )
   SET ADSINDEX TO ( cPatSnd() + "FACPRVL.CDX" ) ADDITIVE

   USE ( cPatSnd() + "FacPrvI.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FacPrvI", @tmpFacPrvI ) )
   SET ADSINDEX TO ( cPatSnd() + "FacPrvI.CDX" ) ADDITIVE

   USE ( cPatSnd() + "FacPrvP.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FacPrvP", @tmpFacPrvP ) )
   SET ADSINDEX TO ( cPatSnd() + "FacPrvP.CDX" ) ADDITIVE

   if !Empty( ::oSender:oMtr )
      ::oSender:oMtr:nTotal := ( cFacPrvT )->( LastRec() )
   end if

   while !( cFacPrvT )->( eof() )

      if ( cFacPrvT )->lSndDoc

         lSnd  := .t.

         dbPass( cFacPrvT, tmpFacPrvT, .t. )
         ::oSender:SetText( ( cFacPrvT )->cSerFac + "/" + AllTrim( Str( ( cFacPrvT )->nNumFac ) ) + "/" + AllTrim( ( cFacPrvT )->cSufFac ) + "; " + Dtoc( ( cFacPrvT )->dFecFac ) + "; " + AllTrim( ( cFacPrvT )->cCodPrv ) + "; " + ( cFacPrvT )->cNomPrv )

         if ( dbfFacPrvL )->( dbSeek( ( cFacPrvT )->cSerFac + Str( ( cFacPrvT )->nNumFac ) + ( cFacPrvT )->cSufFac ) )
            do while ( dbfFacPrvL )->cSerFac + Str( ( dbfFacPrvL )->nNumFac ) + ( dbfFacPrvL )->cSufFac == ( cFacPrvT )->cSerFac + Str( ( cFacPrvT )->nNumFac ) + ( cFacPrvT )->cSufFac .AND. !( dbfFacPrvL )->( eof() )
               dbPass( dbfFacPrvL, tmpFacPrvL, .t. )
               ( dbfFacPrvL )->( dbSkip() )
            end do
         end if

         if ( dbfFacPrvI )->( dbSeek( ( cFacPrvT )->cSerFac + Str( ( cFacPrvT )->nNumFac ) + ( cFacPrvT )->cSufFac ) )
            do while ( dbfFacPrvI )->cSerFac + Str( ( dbfFacPrvI )->nNumFac ) + ( dbfFacPrvI )->cSufFac == ( cFacPrvT )->cSerFac + Str( ( cFacPrvT )->nNumFac ) + ( cFacPrvT )->cSufFac .AND. !( dbfFacPrvI )->( eof() )
               dbPass( dbfFacPrvI, tmpFacPrvI, .t. )
               ( dbfFacPrvI )->( dbSkip() )
            end do
         end if

         if ( dbfFacPrvP )->( dbSeek( ( cFacPrvT )->cSerFac + Str( ( cFacPrvT )->nNumFac ) + ( cFacPrvT )->cSufFac ) )
            do while ( dbfFacPrvP )->cSerFac + Str( ( dbfFacPrvL )->nNumFac ) + ( dbfFacPrvL )->cSufFac == ( cFacPrvT )->cSerFac + Str( ( cFacPrvT )->nNumFac ) + ( cFacPrvT )->cSufFac .AND. !( dbfFacPrvP )->( eof() )
               dbPass( dbfFacPrvP, tmpFacPrvP, .t. )
               ( dbfFacPrvP )->( dbSkip() )
            end do
         end if

      end if

      ( cFacPrvT )->( dbSkip() )

      if !Empty( ::oSender:oMtr )
         ::oSender:oMtr:Set( ( cFacPrvT )->( OrdKeyNo() ) )
      end if

   END DO

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   CLOSE ( cFacPrvT )
   CLOSE ( dbfFacPrvL )
   CLOSE ( dbfFacPrvI )
   CLOSE ( dbfFacPrvP )
   CLOSE ( tmpFacPrvT )
   CLOSE ( tmpFacPrvL )
   CLOSE ( tmpFacPrvI )
   CLOSE ( tmpFacPrvP )

   if lSnd

      /*
      Comprimir los archivos---------------------------------------------------
      */

      ::oSender:SetText( "Comprimiendo facturas de proveedores" )

      if ::oSender:lZipData( cFileName )
         ::oSender:SetText( "Ficheros comprimidos" )
      else
         ::oSender:SetText( "ERROR al crear fichero comprimido" )
      end if

   else

      ::oSender:SetText( "No hay facturas de proveedores para enviar" )

   end if

Return ( Self )

//----------------------------------------------------------------------------//

Method RestoreData() CLASS TFacturasProveedorSenderReciver

   local oBlock
   local oError
   local cFacPrvT

   if ::lSuccesfullSend

      /*
      Retorna el valor anterior
      */

      oBlock            := ErrorBlock( { | oError | ApoloBreak( oError ) } )
      BEGIN SEQUENCE

      USE ( cPatEmp() + "FacPrvT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FacPrvT", @cFacPrvT ) )
      SET ADSINDEX TO ( cPatEmp() + "FacPrvT.CDX" ) ADDITIVE

         lSelectAll( oWndBrw, cFacPrvT, "lSndDoc", .f., .t., .t. )

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

      CLOSE ( cFacPrvT )

   end if

Return ( Self )

//----------------------------------------------------------------------------//

Method SendData() CLASS TFacturasProveedorSenderReciver

   local cFileName         := "FacPrv" + StrZero( ::nGetNumberToSend(), 6 ) + "." + RetSufEmp()

   if File( cPatOut() + cFileName )

      /*
      Enviarlos a internet
      */

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

Method ReciveData() CLASS TFacturasProveedorSenderReciver

   local n
   local aExt

   if ::oSender:lServer
      aExt  := aRetDlgEmp()
   else
      aExt  := { "All" }
   end if

   /*
   Recibirlo de internet
   */

   ::oSender:SetText( "Recibiendo facturas de proveedores" )

   if !::oSender:lFranquiciado

      for n := 1 to len( aExt )
         ftpGetFiles( "FacPrv*." + aExt[ n ], cPatIn(), 2000, ::oSender )
      next

   else

      for n := 1 to len( aExt )
         ftpGetFiles( "FacCli*." + aExt[ n ], cPatIn(), 2000, ::oSender )
      next
   
   end if   

   ::oSender:SetText( "Facturas de proveedores recibidas" )

Return Self

//----------------------------------------------------------------------------//

Method Process() CLASS TFacturasProveedorSenderReciver

   local m
   local oStock
   local cFacPrvT
   local dbfFacPrvL
   local dbfFacPrvP
   local dbfProvee
   local dbfCount
   local aFiles
   local oBlock
   local oError
   local cSerie
   local nNumero
   local cSufijo
   
   if !::oSender:lFranquiciado
      aFiles      := Directory( cPatIn() + "FacPrv*.*" )
   else
      aFiles      := Directory( cPatIn() + "FacCli*.*" )
   end if

   /*
   Recibirlo de internet
   */

   ::oSender:SetText( "Recibiendo facturas de proveedores" )

   for m := 1 to len( aFiles )

      ::oSender:SetText( "Procesando fichero : " + aFiles[ m, 1 ] )

      oBlock         := ErrorBlock( { | oError | ApoloBreak( oError ) } )

      BEGIN SEQUENCE

      /*
      descomprimimos el fichero
      */

      if ::oSender:lUnZipData( cPatIn() + aFiles[ m, 1 ] )

         /*
         Comprobamos si es franquiciado o no-----------------------------------
         */

         if !::oSender:lFranquiciado

            /*
            Ficheros temporales------------------------------------------------
            */

            if lExistTable( cPatSnd() + "FacPrvT.DBF" ) .and.;
               lExistTable( cPatSnd() + "FacPrvL.DBF" ) .and.;
               lExistTable( cPatSnd() + "FacPrvP.DBF" )

               USE ( cPatSnd() + "FacPrvT.DBF" ) NEW VIA ( cDriver() )READONLY ALIAS ( cCheckArea( "FacPrvT", @tmpFacPrvT ) )
               SET ADSINDEX TO ( cPatSnd() + "FacPrvT.CDX" ) ADDITIVE

               USE ( cPatSnd() + "FacPrvL.DBF" ) NEW VIA ( cDriver() )READONLY ALIAS ( cCheckArea( "FacPrvL", @tmpFacPrvL ) )
               SET ADSINDEX TO ( cPatSnd() + "FacPrvL.CDX" ) ADDITIVE

               USE ( cPatSnd() + "FacPrvP.Dbf" ) NEW VIA ( cDriver() )READONLY ALIAS ( cCheckArea( "FacPrvP", @tmpFacPrvP ) )
               SET ADSINDEX TO ( cPatSnd() + "FacPrvP.Cdx" ) ADDITIVE

               USE ( cPatEmp() + "FacPrvT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FacPrvT", @cFacPrvT ) )
               SET ADSINDEX TO ( cPatEmp() + "FacPrvT.CDX" ) ADDITIVE

               USE ( cPatEmp() + "FacPrvL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FacPrvL", @dbfFacPrvL ) )
               SET ADSINDEX TO ( cPatEmp() + "FacPrvL.CDX" ) ADDITIVE

               USE ( cPatEmp() + "FacPrvP.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FacPrvP", @dbfFacPrvP ) )
               SET ADSINDEX TO ( cPatEmp() + "FacPrvP.CDX" ) ADDITIVE

               USE ( cPatPrv() + "Provee.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "Provee", @dbfProvee ) )
               SET ADSINDEX TO ( cPatPrv() + "Provee.CDX" ) ADDITIVE

               USE ( cPatEmp() + "NCOUNT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "NCOUNT", @dbfCount ) )
               SET ADSINDEX TO ( cPatEmp() + "NCOUNT.CDX" ) ADDITIVE

               oStock            := TStock():New()
               oStock:cFacPrvT   := cFacPrvT
               oStock:cFacPrvL   := dbfFacPrvL

               while ( tmpFacPrvT )->( !eof() )

                  /*
                  Comprobamos que no exista el Facido en la base de datos
                  */

                  if lValidaOperacion( ( tmpFacPrvT )->dFecFac, .f. ) .and. ;
                     !( cFacPrvT )->( dbSeek( ( tmpFacPrvT )->cSerFac + Str( ( tmpFacPrvT )->nNumFac ) + ( tmpFacPrvT )->cSufFac ) )

                     dbPass( tmpFacPrvT, cFacPrvT, .t. )
                     ::oSender:SetText( "Añadido     : " + ( tmpFacPrvT )->cSerFac + "/" + AllTrim( Str( ( tmpFacPrvT )->nNumFac ) ) +"/" + AllTrim( ( tmpFacPrvT )->cSufFac ) + "; " + Dtoc( ( tmpFacPrvT )->dFecFac ) + "; " + AllTrim( ( tmpFacPrvT )->cCodPrv ) + ( tmpFacPrvT )->cNomPrv )

                     if ( tmpFacPrvL )->( dbSeek( ( tmpFacPrvT )->cSerFac + Str( ( tmpFacPrvT )->nNumFac ) + ( tmpFacPrvT )->cSufFac ) )
                        while ( tmpFacPrvL )->cSerFac + Str( ( tmpFacPrvL )->nNumFac ) + ( tmpFacPrvL )->cSufFac == ( tmpFacPrvT )->cSerFac + Str( ( tmpFacPrvT )->nNumFac ) + ( tmpFacPrvT )->cSufFac .and. !( tmpFacPrvL )->( eof() )
                           dbPass( tmpFacPrvL, dbfFacPrvL, .t. )
                           ( tmpFacPrvL )->( dbSkip() )
                        end do
                     end if

                     /*
                     Pasamos los pagos-----------------------------------------------
                     */

                     if ( tmpFacPrvP )->( dbSeek( ( tmpFacPrvT )->cSerFac + Str( ( tmpFacPrvT )->nNumFac ) + ( tmpFacPrvT )->cSufFac ) )
                        while ( tmpFacPrvP )->cSerFac + Str( ( tmpFacPrvP )->nNumFac ) + ( tmpFacPrvP )->cSufFac == ( tmpFacPrvT )->cSerFac + Str( ( tmpFacPrvT )->nNumFac ) + ( tmpFacPrvT )->cSufFac .and. !( tmpFacPrvP )->( eof() )
                           dbPass( tmpFacPrvP, dbfFacPrvP, .t. )
                           ( tmpFacPrvP )->( dbSkip() )
                        end do
                     end if

                  else

                     ::oSender:SetText( "Desestimado : " + ( tmpFacPrvT )->cSerFac + "/" + AllTrim( Str( ( tmpFacPrvT )->nNumFac ) ) +"/" + AllTrim( ( tmpFacPrvT )->cSufFac ) + "; " + Dtoc( ( tmpFacPrvT )->dFecFac ) + "; " + AllTrim( ( tmpFacPrvT )->cCodPrv ) + ( tmpFacPrvT )->cNomPrv )

                  end if

                  ( tmpFacPrvT )->( dbSkip() )

               end do

               CLOSE ( cFacPrvT )
               CLOSE ( dbfFacPrvL )
               CLOSE ( dbfFacPrvP )
               CLOSE ( tmpFacPrvT )
               CLOSE ( tmpFacPrvL )
               CLOSE ( tmpFacPrvP )

               oStock:end()

            end if

         else


            /*
            Caso de que se trate de un cliente franquiciado--------------------
            */

            /*
            Ficheros temporales
            */

            if file( cPatSnd() + "FacCliT.Dbf" ) .and.;
               file( cPatSnd() + "FacCliL.Dbf" ) .and.;
               file( cPatSnd() + "FacCliP.Dbf" )

               USE ( cPatSnd() + "FacCliT.DBF" ) NEW VIA ( cDriver() ) READONLY ALIAS ( cCheckArea( "FacCliT", @tmpFacPrvT ) )
               SET ADSINDEX TO ( cPatSnd() + "FacCliT.CDX" ) ADDITIVE

               USE ( cPatSnd() + "FacCliL.DBF" ) NEW VIA ( cDriver() ) READONLY ALIAS ( cCheckArea( "FacCliL", @tmpFacPrvL ) )
               SET ADSINDEX TO ( cPatSnd() + "FacCliL.CDX" ) ADDITIVE

               USE ( cPatSnd() + "FacCliP.DBF" ) NEW VIA ( cDriver() ) READONLY ALIAS ( cCheckArea( "FacCliP", @tmpFacPrvP ) )
               SET ADSINDEX TO ( cPatSnd() + "FacCliP.CDX" ) ADDITIVE

               USE ( cPatEmp() + "FacPrvT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FacPrvT", @cFacPrvT ) )
               SET ADSINDEX TO ( cPatEmp() + "FacPrvT.CDX" ) ADDITIVE

               USE ( cPatEmp() + "FacPrvL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FacPrvL", @dbfFacPrvL ) )
               SET ADSINDEX TO ( cPatEmp() + "FacPrvL.CDX" ) ADDITIVE

               USE ( cPatEmp() + "FacPrvP.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FacPrvP", @dbfFacPrvP ) )
               SET ADSINDEX TO ( cPatEmp() + "FacPrvP.CDX" ) ADDITIVE

               USE ( cPatPrv() + "Provee.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "Provee", @dbfProvee ) )
               SET ADSINDEX TO ( cPatPrv() + "Provee.CDX" ) ADDITIVE

               USE ( cPatEmp() + "NCOUNT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "NCOUNT", @dbfCount ) )
               SET ADSINDEX TO ( cPatEmp() + "NCOUNT.CDX" ) ADDITIVE

               while ( tmpFacPrvT )->( !eof() )

                  /*
                  Comprobamos que no exista la factura en la base de datos---
                  */

                  ( cFacPrvT )->( OrdSetFocus( "cSuPed" ) )

                  if !( cFacPrvT )->( dbSeek( ( tmpFacPrvT )->cSerie + Str( ( tmpFacPrvT )->nNumFac ) + ( tmpFacPrvT )->cSufFac ) )

                     /*
                     Pasamos las cabeceras----------------------------------
                     */

                     cSerie      := ( tmpFacPrvT )->cSerie
                     nNumero     := nNewDoc( ( tmpFacPrvT )->cSerie, cFacPrvT, "NFACPRV", , dbfCount )
                     cSufijo  := oUser():cDelegacion()

                     ( cFacPrvT)->( dbAppend() )

                     ( cFacPrvT)->CSERFAC     := cSerie
                     ( cFacPrvT)->NNUMFAC     := nNumero
                     ( cFacPrvT)->CSUFFAC     := cSufijo
                     ( cFacPrvT)->CTURFAC     := cCurSesion()
                     ( cFacPrvT)->DFECFAC     := ( tmpFacPrvT )->dFecFac
                     ( cFacPrvT)->CCODPRV     := ( tmpFacPrvT )->cCodCli
                     ( cFacPrvT)->CCODALM     := oUser():cAlmacen()
                     ( cFacPrvT)->CCODCAJ     := oUser():cCaja()
                     ( cFacPrvT)->CNOMPRV     := ( tmpFacPrvT )->cNomCli
                     ( cFacPrvT)->CDIRPRV     := ( tmpFacPrvT )->cDirCli
                     ( cFacPrvT)->CPOBPRV     := ( tmpFacPrvT )->cPobCli
                     ( cFacPrvT)->CPROVPROV   := ( tmpFacPrvT )->cPrvCli
                     ( cFacPrvT)->CPOSPRV     := ( tmpFacPrvT )->cPosCli
                     ( cFacPrvT)->CDNIPRV     := ( tmpFacPrvT )->cDniCli
                     ( cFacPrvT)->LLIQUIDADA  := ( tmpFacPrvT )->lLiquidada
                     ( cFacPrvT)->LCONTAB     := .f.
                     ( cFacPrvT)->DFECENT     := ( tmpFacPrvT )->DFECENT
                     ( cFacPrvT)->CSUPED      := ( tmpFacPrvT )->cSerie + Str( ( tmpFacPrvT )->nNumFac ) + ( tmpFacPrvT )->cSufFac
                     ( cFacPrvT)->CCONDENT    := ( tmpFacPrvT )->cCondEnt
                     ( cFacPrvT)->MCOMENT     := ( tmpFacPrvT )->mComent
                     ( cFacPrvT)->CCODPAGO    := ( tmpFacPrvT )->cCodPago
                     ( cFacPrvT)->CDTOESP     := ( tmpFacPrvT )->cDtoEsp
                     ( cFacPrvT)->NDTOESP     := ( tmpFacPrvT )->nDtoEsp
                     ( cFacPrvT)->CDPP        := ( tmpFacPrvT )->cDpp
                     ( cFacPrvT)->NDPP        := ( tmpFacPrvT )->nDpp
                     ( cFacPrvT)->LRECARGO    := ( tmpFacPrvT )->lRecargo
                     ( cFacPrvT)->CDIVFAC     := ( tmpFacPrvT )->cDivFac
                     ( cFacPrvT)->NVDVFAC     := ( tmpFacPrvT )->nVdvFac
                     ( cFacPrvT)->LSNDDOC     := .t.
                     ( cFacPrvT)->CDTOUNO     := ( tmpFacPrvT )->cDtoUno
                     ( cFacPrvT)->NDTOUNO     := ( tmpFacPrvT )->nDtoUno
                     ( cFacPrvT)->CDTODOS     := ( tmpFacPrvT )->cDtoDos
                     ( cFacPrvT)->NDTODOS     := ( tmpFacPrvT )->nDtoDos
                     ( cFacPrvT)->LCLOFAC     := .f.
                     ( cFacPrvT)->CCODUSR     := cCurUsr()
                     ( cFacPrvT)->nTipRet     := ( tmpFacPrvT )->nTipRet
                     ( cFacPrvT)->nPctRet     := ( tmpFacPrvT )->nPctRet
                     ( cFacPrvT)->dFecChg     := GetSysDate()
                     ( cFacPrvT)->cTimChg     := Time()
                     ( cFacPrvT)->cCodDlg     := oUser():cDelegacion()
                     ( cFacPrvT)->nRegIva     := ( tmpFacPrvT )->nRegIva
                     ( cFacPrvT)->nTotNet     := ( tmpFacPrvT )->nTotNet
                     ( cFacPrvT)->nTotIva     := ( tmpFacPrvT )->nTotIva
                     ( cFacPrvT)->nTotReq     := ( tmpFacPrvT )->nTotReq
                     ( cFacPrvT)->nTotFac     := ( tmpFacPrvT )->nTotFac

                     ( cFacPrvT )->( dbUnLock() )

                     ::oSender:SetText( "Añadida factura     : " + cSerie + "/" + AllTrim( Str( nNumero ) ) + "/" +  AllTrim( cSufijo ) )

                     /*
                     Pasamos las lineas de las facturas---------------------
                     */

                     if ( tmpFacPrvL )->( dbSeek( ( tmpFacPrvT )->cSerie + Str( ( tmpFacPrvT )->nNumFac ) + ( tmpFacPrvT )->cSufFac ) )
                           
                        while ( tmpFacPrvL )->cSerie + Str( ( tmpFacPrvL )->nNumFac ) + ( tmpFacPrvL )->cSufFac == ( tmpFacPrvT )->cSerie + Str( ( tmpFacPrvT )->nNumFac ) + ( tmpFacPrvT )->cSufFac .and. !( tmpFacPrvL )->( eof() )
                              
                           ( dbfFacPrvL)->( dbAppend() )

                           ( dbfFacPrvL)->CSERFAC    := cSerie
                           ( dbfFacPrvL)->NNUMFAC    := nNumero
                           ( dbfFacPrvL)->CSUFFAC    := cSufijo
                           ( dbfFacPrvL)->CREF       := ( tmpFacPrvL )->cRef
                           ( dbfFacPrvL)->CREFPRV    := ( tmpFacPrvL )->cRefPrv
                           ( dbfFacPrvL)->CDETALLE   := ( tmpFacPrvL )->cDetalle
                           ( dbfFacPrvL)->NPREUNIT   := ( tmpFacPrvL )->nPreUnit
                           ( dbfFacPrvL)->NDTO       := ( tmpFacPrvL )->nDto
                           ( dbfFacPrvL)->NIVA       := ( tmpFacPrvL )->nIva
                           ( dbfFacPrvL)->NCANENT    := ( tmpFacPrvL )->nCanEnt
                           ( dbfFacPrvL)->LCONTROL   := ( tmpFacPrvL )->lControl
                           ( dbfFacPrvL)->CUNIDAD    := ( tmpFacPrvL )->cUnidad
                           ( dbfFacPrvL)->NUNICAJA   := ( tmpFacPrvL )->nUniCaja
                           ( dbfFacPrvL)->MLNGDES    := ( tmpFacPrvL )->mLngDes
                           ( dbfFacPrvL)->NDTOLIN    := ( tmpFacPrvL )->nDtoDiv
                           ( dbfFacPrvL)->NDTOPRM    := ( tmpFacPrvL )->nDtoPrm
                           ( dbfFacPrvL)->NIVALIN    := ( tmpFacPrvL )->nIva
                           ( dbfFacPrvL)->LIVALIN    := ( tmpFacPrvL )->lIvaLin
                           ( dbfFacPrvL)->CCODPR1    := ( tmpFacPrvL )->cCodPr1
                           ( dbfFacPrvL)->CCODPR2    := ( tmpFacPrvL )->cCodPr2
                           ( dbfFacPrvL)->CVALPR1    := ( tmpFacPrvL )->cValPr1
                           ( dbfFacPrvL)->CVALPR2    := ( tmpFacPrvL )->cValPr2
                           ( dbfFacPrvL)->NFACCNV    := ( tmpFacPrvL )->nFacCnv
                           ( dbfFacPrvL)->CALMLIN    := ( tmpFacPrvL )->cAlmLin
                           ( dbfFacPrvL)->NCTLSTK    := ( tmpFacPrvL )->nCtlStk
                           ( dbfFacPrvL)->LLOTE      := ( tmpFacPrvL )->lLote
                           ( dbfFacPrvL)->NLOTE      := ( tmpFacPrvL )->nLote
                           ( dbfFacPrvL)->CLOTE      := ( tmpFacPrvL )->cLote
                           ( dbfFacPrvL)->NNUMLIN    := ( tmpFacPrvL )->nNumLin
                           ( dbfFacPrvL)->NUNDKIT    := ( tmpFacPrvL )->nUndKit
                           ( dbfFacPrvL)->LKITART    := ( tmpFacPrvL )->lKitArt
                           ( dbfFacPrvL)->LKITCHL    := ( tmpFacPrvL )->lKitChl
                           ( dbfFacPrvL)->LKITPRC    := ( tmpFacPrvL )->lKitPrc
                           ( dbfFacPrvL)->MNUMSER    := ( tmpFacPrvL )->mNumSer
                           ( dbfFacPrvL)->CCODFAM    := ( tmpFacPrvL )->cCodFam
                           ( dbfFacPrvL)->CGRPFAM    := ( tmpFacPrvL )->cGrpFam
                           ( dbfFacPrvL)->NREQ       := ( tmpFacPrvL )->nReq
                           ( dbfFacPrvL)->MOBSLIN    := ( tmpFacPrvL )->mObsLin
                           ( dbfFacPrvL)->nNumMed    := ( tmpFacPrvL )->nNumMed
                           ( dbfFacPrvL)->nMedUno    := ( tmpFacPrvL )->nMedUno
                           ( dbfFacPrvL)->nMedDos    := ( tmpFacPrvL )->nMedDos
                           ( dbfFacPrvL)->nMedTre    := ( tmpFacPrvL )->nMedTre
                           ( dbfFacPrvL)->dFecCad    := ( tmpFacPrvL )->dFecCad
                           ( dbfFacPrvL)->cSuPed     := ( tmpFacPrvT )->cSerie + Str( ( tmpFacPrvT )->nNumFac ) + ( tmpFacPrvT )->cSufFac
                           ( dbfFacPrvL)->dFecFac    := ( tmpFacPrvT )->dFecFac
                           ( dbfFacPrvL)->cCodPrv    := ( tmpFacPrvT )->cCodCli

                           ( dbfFacPrvL )->( dbUnLock() )

                           ( tmpFacPrvL )->( dbSkip() )

                        end while

                     end if

                     /*
                     Pasamos los recibos de las facturas--------------------
                     */

                     if ( tmpFacPrvP )->( dbSeek( ( tmpFacPrvT )->cSerie + Str( ( tmpFacPrvT )->nNumFac ) + ( tmpFacPrvT )->cSufFac ) )
                           
                        while ( tmpFacPrvP )->cSerie + Str( ( tmpFacPrvP )->nNumFac ) + ( tmpFacPrvP )->cSufFac == ( tmpFacPrvT )->cSerie + Str( ( tmpFacPrvT )->nNumFac ) + ( tmpFacPrvT )->cSufFac .and. !( tmpFacPrvP )->( eof() )
                              
                           ( dbfFacPrvP)->( dbAppend() )

                           ( dbfFacPrvP )->cSerFac    := cSerie
                           ( dbfFacPrvP )->nNumFac    := nNumero
                           ( dbfFacPrvP )->cSufFac    := cSufijo
                           ( dbfFacPrvP )->nNumRec    := ( tmpFacPrvP )->nNumRec
                           ( dbfFacPrvP )->cTipRec    := ( tmpFacPrvP )->cTipRec
                           ( dbfFacPrvP )->CCODCAJ    := oUser():cCaja()
                           ( dbfFacPrvP )->CCODPRV    := ( tmpFacPrvT )->cCodCli
                           ( dbfFacPrvP )->cNomPrv    := ( tmpFacPrvP )->cNomCli
                           ( dbfFacPrvP )->DENTRADA   := ( tmpFacPrvP )->dEntrada
                           ( dbfFacPrvP )->NIMPORTE   := ( tmpFacPrvP )->nImporte
                           ( dbfFacPrvP )->CDESCRIP   := ( tmpFacPrvP )->cDescrip
                           ( dbfFacPrvP )->DPRECOB    := ( tmpFacPrvP )->dPreCob
                           ( dbfFacPrvP )->CPGDOPOR   := ( tmpFacPrvP )->cPgdoPor
                           ( dbfFacPrvP )->LCOBRADO   := ( tmpFacPrvP )->lCobrado
                           ( dbfFacPrvP )->CDIVPGO    := ( tmpFacPrvP )->cDivPgo
                           ( dbfFacPrvP )->NVDVPGO    := ( tmpFacPrvP )->nVdvPgo
                           ( dbfFacPrvP )->DFECVTO    := ( tmpFacPrvP )->dFecVto
                           ( dbfFacPrvP )->cCodUsr    := cCurUsr()
                           ( dbfFacPrvP )->dFecChg    := GetSysDate()
                           ( dbfFacPrvP )->cTimChg    := Time()
                           ( dbfFacPrvP )->cTurRec    := cCurSesion()
                           ( dbfFacPrvP )->cCodPgo    := ( tmpFacPrvP )->cCodPgo
                           
                           ( dbfFacPrvP )->( dbUnLock() )

                           ( tmpFacPrvP )->( dbSkip() )

                        end while

                     end if

                  else

                     ::oSender:SetText( "Desestimada factura : " + ( tmpFacPrvT )->cSerie + "/" + AllTrim( Str( ( tmpFacPrvT )->nNumFac ) ) + "/" +  AllTrim( ( tmpFacPrvL )->cSufFac ) + "; " + Dtoc( ( tmpFacPrvT )->dFecFac ) + "; " + AllTrim( ( tmpFacPrvT )->cCodCli ) + "; " + ( tmpFacPrvT )->cNomCli )

                  end if

                  ( tmpFacPrvT )->( dbSkip() )

               end while

               CLOSE ( cFacPrvT )
               CLOSE ( dbfFacPrvL )
               CLOSE ( dbfFacPrvP )
               CLOSE ( tmpFacPrvT )
               CLOSE ( tmpFacPrvL )
               CLOSE ( tmpFacPrvP )
               CLOSE ( dbfProvee  )
               CLOSE ( dbfCount   )

               ::oSender:AppendFileRecive( aFiles[ m, 1 ] )

            else

               ::oSender:SetText( "Faltan ficheros" )

               if !file( cPatSnd() + "FacCliT.Dbf" )
               ::oSender:SetText( "Falta" + cPatSnd() + "FacCliT.Dbf" )
               end if

               if !file( cPatSnd() + "FacCliL.Dbf" )
                     ::oSender:SetText( "Falta" + cPatSnd() + "FacCliL.Dbf" )
               end if

               if !file( cPatSnd() + "FacCliP.Dbf" )
                     ::oSender:SetText( "Falta" + cPatSnd() + "FacCliP.Dbf" )
               end if

            end if

         end if   

      end if

      ::oSender:AppendFileRecive( aFiles[ m, 1 ] )

      RECOVER USING oError

         CLOSE ( cFacPrvT )
         CLOSE ( dbfFacPrvL )
         CLOSE ( dbfFacPrvP )
         CLOSE ( tmpFacPrvT )
         CLOSE ( tmpFacPrvL )
         CLOSE ( tmpFacPrvP )
         CLOSE ( dbfProvee  )
         CLOSE ( dbfCount   )

         ::oSender:SetText( "Error procesando fichero " + aFiles[ m, 1 ] )
         ::oSender:SetText( ErrorMessage( oError ) )

      END SEQUENCE

      ErrorBlock( oBlock )

   next

Return Self

//----------------------------------------------------------------------------//

FUNCTION aEtqFacPrv( dbfDocFld, dbfDocCol )

   local aDoc  := {}

   aAdd( aDoc, { "Empresa",         "EM" } )
   aAdd( aDoc, { "Proveedor",       "PR" } )
   aAdd( aDoc, { "Artículos",       "AR" } )
   aAdd( aDoc, { "Factura cabecera","FP" } )
   aAdd( aDoc, { "Factura líneas",  "FX" } )

RETURN ( aDoc )

//---------------------------------------------------------------------------//

Function AppFacPrv( cCodPrv, cCodArt, lOpenBrowse )

   local nLevel         := nLevelUsr( _MENUITEM_ )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) != 0 .or. nAnd( nLevel, ACC_APPD ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if lOpenBrowse

      if FacPrv( nil, nil, cCodPrv, cCodArt )
         oWndBrw:RecAdd()
      end if

   else

      if OpenFiles( .t. )
         WinAppRec( nil, bEdtRec, TDataView():FacturasProveedores( nView ), cCodPrv, cCodArt )
         CloseFiles()
      end if

   end if

RETURN .t.

//----------------------------------------------------------------------------//

Function bGenEdtFacPrv( nNumFac )

   local bGen
   local cDoc           := by( nNumFac )

   bGen                 := {|| EdtFacPrv( nNumFac ) }

return ( bGen )

//---------------------------------------------------------------------------//

FUNCTION EdtFacPrv( nNumFac, lOpenBrowse )

   local nLevel         := nLevelUsr( _MENUITEM_ )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) != 0 .or. nAnd( nLevel, ACC_EDIT ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if lOpenBrowse

      if FacPrv()
         if dbSeekInOrd( nNumFac, "nNumFac", TDataView():FacturasProveedores( nView ) )
            oWndBrw:RecEdit()
         else
            MsgStop( "No se encuentra factura" )
         end if
      end if

   else

      if OpenFiles( .t. )
         if dbSeekInOrd( nNumFac, "nNumFac", TDataView():FacturasProveedores( nView ) )
            nTotFacPrv()
            WinEdtRec( nil, bEdtRec, TDataView():FacturasProveedores( nView ) )
         else
            MsgStop( "No se encuentra factura" )
         end if
         CloseFiles()
      end if

   end if

RETURN NIL

//----------------------------------------------------------------------------//

FUNCTION ZooFacPrv( nNumFac, lOpenBrowse )

   local nLevel         := nLevelUsr( _MENUITEM_ )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) != 0 .or. nAnd( nLevel, ACC_ZOOM ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if lOpenBrowse

      if FacPrv()
         if dbSeekInOrd( nNumFac, "nNumFac", TDataView():FacturasProveedores( nView ) )
            oWndBrw:RecZoom()
         else
            MsgStop( "No se encuentra factura" )
         end if
      end if

   else

      if OpenFiles( .t. )
         if dbSeekInOrd( nNumFac, "nNumFac", TDataView():FacturasProveedores( nView ) )
            nTotFacPrv()
            WinZooRec( nil, bEdtRec, TDataView():FacturasProveedores( nView ) )
         else
            MsgStop( "No se encuentra factura" )
         end if
         CloseFiles()
      end if

   end if

RETURN NIL

//----------------------------------------------------------------------------//

FUNCTION DelFacPrv( nNumFac, lOpenBrowse )

   local nLevel         := nLevelUsr( _MENUITEM_ )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) != 0 .or. nAnd( nLevel, ACC_ZOOM ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if lOpenBrowse

      if FacPrv()
         if dbSeekInOrd( nNumFac, "nNumFac", TDataView():FacturasProveedores( nView ) )
            WinDelRec( nil, TDataView():FacturasProveedores( nView ), {|| QuiFacPrv() } )
         else
            MsgStop( "No se encuentra factura" )
         end if
      end if

   else

      if OpenFiles( .t. )
         if dbSeekInOrd( nNumFac, "nNumFac", TDataView():FacturasProveedores( nView ) )
            WinDelRec( nil, TDataView():FacturasProveedores( nView ), {|| QuiFacPrv() } )
         else
            MsgStop( "No se encuentra factura" )
         end if
         CloseFiles()
      end if

   end if

Return nil

//----------------------------------------------------------------------------//

FUNCTION PrnFacPrv( nNumFac, lOpenBrowse )

   local nLevel         := nLevelUsr( _MENUITEM_ )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) != 0 .or. nAnd( nLevel, ACC_ZOOM ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if lOpenBrowse

      if FacPrv()
         if dbSeekInOrd( nNumFac, "nNumFac", TDataView():FacturasProveedores( nView ) )
            GenFacPrv( IS_PRINTER )
         else
            MsgStop( "No se encuentra factura" )
         end if
      end if

   else

      if OpenFiles( .t. )
         if dbSeekInOrd( nNumFac, "nNumFac", TDataView():FacturasProveedores( nView ) )
            nTotFacPrv()
            GenFacPrv( IS_PRINTER )
         else
            MsgStop( "No se encuentra factura" )
         end if
         CloseFiles()
      end if

   end if

RETURN NIL

//---------------------------------------------------------------------------//

FUNCTION VisFacPrv( nNumFac, lOpenBrowse )

   local nLevel         := nLevelUsr( _MENUITEM_ )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) != 0 .or. nAnd( nLevel, ACC_ZOOM ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if lOpenBrowse

      if FacPrv()
         if dbSeekInOrd( nNumFac, "nNumFac", TDataView():FacturasProveedores( nView ) )
            GenFacPrv( IS_SCREEN )
         else
            MsgStop( "No se encuentra factura" )
         end if
      end if

   else

      if OpenFiles( .t. )
         if dbSeekInOrd( nNumFac, "nNumFac", TDataView():FacturasProveedores( nView ) )
            nTotFacPrv()
            GenFacPrv( IS_SCREEN )
         else
            MsgStop( "No se encuentra factura" )
         end if
         CloseFiles()
      end if

   end if

Return nil

//---------------------------------------------------------------------------//

Function IsFacPrv( cPath )

   DEFAULT cPath  := cPatEmp()

   if !lExistTable( cPath + "FacPrvT.Dbf" )
      dbCreate( cPath + "FacPrvT.Dbf", aSqlStruct( aItmFacPrv() ), cDriver() )
   end if

   if !lExistTable( cPath + "FacPrvL.Dbf" )
      dbCreate( cPath + "FacPrvL.Dbf", aSqlStruct( aColFacPrv() ), cDriver() )
   end if

   if !lExistTable( cPath + "FacPrvI.Dbf" )
      dbCreate( cPath + "FacPrvI.Dbf", aSqlStruct( aIncFacPrv() ), cDriver() )
   end if

   if !lExistTable( cPath + "FacPrvD.Dbf" )
      dbCreate( cPath + "FacPrvD.Dbf", aSqlStruct( aFacPrvDoc() ), cDriver() )
   end if

   if !lExistIndex( cPath + "FacPrvT.Cdx" ) .OR. ;
      !lExistIndex( cPath + "FacPrvL.Cdx" ) .OR. ;
      !lExistIndex( cPath + "FacPrvI.Cdx" ) .OR. ;
      !lExistIndex( cPath + "FacPrvD.Cdx" )

      rxFacPrv( cPath )

   end if

Return ( nil )

//---------------------------------------------------------------------------//

FUNCTION cPrpFacPrv( cFacPrvL )

   local cReturn     := ""

   DEFAULT cFacPrvL  := if( !Empty( tmpFacPrvL ), tmpFacPrvL, dbfFacPrvL )

   cReturn           += Alltrim( ( cFacPrvL )->cRef )

   if !Empty( ( cFacPrvL )->cValPr1 )
      cReturn        += "."
      cReturn        += Alltrim( ( cFacPrvL )->cValPr1 )
   end if

   if !Empty( ( cFacPrvL )->cValPr2 )
      cReturn        += "."
      cReturn        += Alltrim( ( cFacPrvL )->cValPr2 )
   end if

RETURN ( cReturn )

//---------------------------------------------------------------------------//

/*
Devuelve la descripción de una linea de factura
*/

FUNCTION cDesFacPrv( cFacPrvT, cFacPrvL, cFacPrvS )

   local cReturn     := ""

   DEFAULT cFacPrvT  := TDataView():FacturasProveedores( nView )
   DEFAULT cFacPrvL  := dbfFacPrvL
   DEFAULT cFacPrvS  := dbfFacPrvS

   if ( cFacPrvT )->lFacGas
      cReturn        := Rtrim( ( cFacPrvT )->cDetalle )
   else
      cReturn        := Descrip( cFacPrvL, cFacPrvS )
   end if

RETURN ( cReturn )

//---------------------------------------------------------------------------//

Function cCtaFacPrv( cFacPrvT, cFacPrvP, cBncPrv )

   local cCtaFacPrv  := ""

   DEFAULT cFacPrvT  := TDataView():FacturasProveedores( nView )
   DEFAULT cFacPrvP  := dbfFacPrvP
   DEFAULT cBncPrv   := dbfPrvBnc

   cCtaFacPrv        := Rtrim( ( cFacPrvT )->cEntBnc + ( cFacPrvT )->cSucBnc + ( cFacPrvT )->cDigBnc + ( cFacPrvT )->cCtaBnc )

   if Empty( cCtaFacPrv )
      if dbSeekInOrd( ( cFacPrvT )->cSerFac + Str( ( cFacPrvT )->nNumFac ) + ( cFacPrvT )->cSufFac, "nNumFac", cFacPrvP )
         cCtaFacPrv  := cProveeCuenta( ( cFacPrvP )->cCodPrv, cBncPrv )
      end if
   end if

Return ( cCtaFacPrv )

//------------------------------------------------------------------------//

/*
Funcion que nos indica si una factura está rectificada o no--------------------
*/

Function lRectificadaPrv( cNumFac, cFacPrvT, cRctPrvT )

   local lRectificada   := .f.

   DEFAULT cFacPrvT     := TDataView():FacturasProveedores( nView )
   DEFAULT cRctPrvT     := dbfRctPrvT
   DEFAULT cNumFac      := ( cFacPrvT )->cSerFac + Str( ( cFacPrvT )->nNumFac ) + ( cFacPrvT )->cSufFac

   if dbSeekInOrd( cNumFac, "CNUMFAC", cRctPrvT )
      lRectificada      := .t.
   end if

return ( lRectificada )

//---------------------------------------------------------------------------//
/*
Calcula el total de linea de factura
*/

FUNCTION nTotLFacPrv( uFacPrvL, nDec, nRec, nVdv, cPirDiv )

   local nCalculo
   local nDtoLin
   local nDtoPrm

   DEFAULT uFacPrvL  := if( !Empty( tmpFacPrvL ), tmpFacPrvL, dbfFacPrvL )
   DEFAULT nDec      := nDinDiv()
   DEFAULT nRec      := nRinDiv()
   DEFAULT nVdv      := 1

   nCalculo          := nTotUFacPrv( uFacPrvL, nDec, nVdv )

   do case
   case ValType( uFacPrvL ) == "A"
      nDtoLin        := uFacPrvL[ _NDTOLIN ]
      nDtoPrm        := uFacPrvL[ _NDTOPRM ]
   case ValType( uFacPrvL ) == "C"
      nDtoLin        := ( uFacPrvL )->nDtoLin
      nDtoPrm        := ( uFacPrvL )->nDtoPrm
   case ValType( uFacPrvL ) == "O"
      nDtoLin        := uFacPrvL:nDtoLin
      nDtoPrm        := uFacPrvL:nDtoPrm
   end case

   if nDtoLin != 0
      nCalculo       -= nCalculo * nDtoLin / 100
   end if

   if nDtoPrm != 0
      nCalculo       -= nCalculo * nDtoPrm / 100
   end if

   nCalculo          *= nTotNFacPrv( uFacPrvL )

   nCalculo          := Round( nCalculo, nRec )

RETURN ( if( cPirDiv != NIL, Trans( nCalculo, cPirDiv ), nCalculo ) )

//---------------------------------------------------------------------------//
//Total de una linea con impuestos incluidos

FUNCTION nTotFFacPrv( cFacPrvL, nDec, nRou, nVdv, cPorDiv )

   local nCalculo := 0

   nCalculo       += nTotLFacPrv( cFacPrvL, nDec, nRou, nVdv )
   nCalculo       += nIvaLFacPrv( cFacPrvL, nDec, nRou, nVdv )

return ( if( cPorDiv != nil, Trans( nCalculo, cPorDiv ), nCalculo ) )

//---------------------------------------------------------------------------//
/*
Devuelve el importe de descuento porcentual por cada linea---------------------
*/

FUNCTION nDtoLFacPrv( cFacPrvL, nDec, nRou, nVdv )

   local nCalculo       := 0

   DEFAULT cFacPrvL     := dbfFacPrvL
   DEFAULT nDec         := nDinDiv()   // Decimales de la divisa
   DEFAULT nRou         := nRinDiv()   
   DEFAULT nVdv         := 1

   if ( cFacPrvL )->nDtoLin != 0 

      nCalculo          := nTotUFacPrv( cFacPrvL, nDec ) * nTotNFacPrv( cFacPrvL )

      /*
      Descuentos---------------------------------------------------------------
      */

      nCalculo          := nCalculo * ( cFacPrvL )->nDtoLin / 100


      if nVdv != 0
         nCalculo       := nCalculo / nVdv
      end if

      if nRou != nil
         nCalculo       := Round( nCalculo, nRou )
      end if

   end if

RETURN ( nCalculo ) 

//---------------------------------------------------------------------------//
/*
Devuelve el importe de descuento porcentual en promociones por cada linea------
*/

FUNCTION nPrmLFacPrv( cFacPrvL, nDec, nRou, nVdv )

   local nCalculo       := 0

   DEFAULT cFacPrvL     := dbfFacPrvL
   DEFAULT nDec         := nDinDiv()   // Decimales de la divisa
   DEFAULT nRou         := nRinDiv()   
   DEFAULT nVdv         := 1

   if ( cFacPrvL )->nDtoPrm != 0 

      nCalculo          := nTotUFacPrv( cFacPrvL, nDec ) * nTotNFacPrv( cFacPrvL )

      /*
      Descuentos---------------------------------------------------------------
      */

      if ( cFacPrvL )->nDtoLin != 0 
         nCalculo       -= nCalculo * ( cFacPrvL )->nDtoLin / 100
      end if

      nCalculo          := nCalculo * ( cFacPrvL )->nDtoPrm / 100

      if nVdv != 0
         nCalculo       := nCalculo / nVdv
      end if

      if nRou != nil
         nCalculo       := Round( nCalculo, nRou )
      end if

   end if

RETURN ( nCalculo ) 

//---------------------------------------------------------------------------//

FUNCTION nTotUFacPrv( uFacPrvL, nDec, nVdv, cPinDiv )

   local nCalculo

   DEFAULT uFacPrvL     := if( !Empty( tmpFacPrvL ), tmpFacPrvL, dbfFacPrvL )
   DEFAULT nDec         := nDinDiv()   // Decimales de la divisa
   DEFAULT nVdv         := 1

   do case
   case ValType( uFacPrvL ) == "O"
      nCalculo          := uFacPrvL:nPreUnit       / NotCero( nVdv )
   case ValType( uFacPrvL ) == "A"
      nCalculo          := uFacPrvL[ _NPREUNIT ]   / NotCero( nVdv )
   case ValType( uFacPrvL ) == "C"
      nCalculo          := ( uFacPrvL )->nPreUnit  / NotCero( nVdv )
   end case

   nCalculo             := Round( nCalculo, nDec )

RETURN ( ( if( cPinDiv != nil, Trans( nCalculo, cPinDiv ), nCalculo ) )  )

//---------------------------------------------------------------------------//

FUNCTION cBarPrp1FacPrv( uFacPrvL, uTblPro )

   local cBarPrp1    := ""

   DEFAULT uFacPrvL  := if( !Empty( tmpFacPrvL ), tmpFacPrvL, dbfFacPrvL )
   DEFAULT uTblPro   := dbfTblPro

   if dbSeekInOrd( ( uFacPrvL )->cCodPr1 + ( uFacPrvL )->cValPr1, "cCodPro", uTblPro )
      cBarPrp1       := ( uTblPro )->nBarTbl
   end if

RETURN ( cBarPrp1 )

//---------------------------------------------------------------------------//

FUNCTION cBarPrp2FacPrv( uFacPrvL, uTblPro )

   local cBarPrp2    := ""

   DEFAULT uFacPrvL  := if( !Empty( tmpFacPrvL ), tmpFacPrvL, dbfFacPrvL )
   DEFAULT uTblPro   := dbfTblPro

   if dbSeekInOrd( ( uFacPrvL )->cCodPr2 + ( uFacPrvL )->cValPr2, "cCodPro", uTblPro )
      cBarPrp2       := ( uTblPro )->nBarTbl
   end if

RETURN ( cBarPrp2 )

//---------------------------------------------------------------------------//

Function nStockLineaFacPrv()

Return ( oStock:nTotStockAct( ( dbfFacPrvL )->cRef, ( dbfFacPrvL )->cAlmLin, ( dbfFacPrvL )->cValPr1, ( dbfFacPrvL )->cValPr2 ) )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS TFacturaProveedorLabelGenerator

   Data oDlg
   Data oFld

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

   Data nFilaInicio
   Data nColumnaInicio

   Data nRecno

   Data oBrwLabel

   Data nCantidadLabels
   Data nUnidadesLabels

   Data oMtrLabel
   Data nMtrLabel

   Data lClose

   Data lErrorOnCreate

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

   Method LoadAuxiliar()

   Method lPrintLabels()

   Method InitLabel( oLabel )

   Method SelectColumn( oCombo )

END CLASS

//----------------------------------------------------------------------------//

Method New() CLASS TFacturaProveedorLabelGenerator

   local oError
   local oBlock

   oBlock                  := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      ::cSerieInicio       := ( TDataView():FacturasProveedores( nView ) )->cSerFac
      ::cSerieFin          := ( TDataView():FacturasProveedores( nView ) )->cSerFac

      ::nDocumentoInicio   := ( TDataView():FacturasProveedores( nView ) )->nNumFac
      ::nDocumentoFin      := ( TDataView():FacturasProveedores( nView ) )->nNumFac

      ::cSufijoInicio      := ( TDataView():FacturasProveedores( nView ) )->cSufFac
      ::cSufijoFin         := ( TDataView():FacturasProveedores( nView ) )->cSufFac

      ::nRecno             := ( TDataView():FacturasProveedores( nView ) )->( Recno() )

      ::cFormatoLabel      := GetPvProfString( "Etiquetas", "Factura proveedor", Space( 3 ), cPatEmp() + "Empresa.Ini" )
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

Method Init() CLASS TFacturaProveedorLabelGenerator

   local oError
   local oBlock
   local lError            := .f.

   oBlock                  := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      if !lOpenFiles
         OpenFiles()
         ::lClose          := .t.
      end if

      ::cSerieInicio       := ( TDataView():FacturasProveedores( nView ) )->cSerFac
      ::cSerieFin          := ( TDataView():FacturasProveedores( nView ) )->cSerFac

      ::nDocumentoInicio   := ( TDataView():FacturasProveedores( nView ) )->nNumFac
      ::nDocumentoFin      := ( TDataView():FacturasProveedores( nView ) )->nNumFac

      ::cSufijoInicio      := ( TDataView():FacturasProveedores( nView ) )->cSufFac
      ::cSufijoFin         := ( TDataView():FacturasProveedores( nView ) )->cSufFac

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

Method Create() CLASS TFacturaProveedorLabelGenerator

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

            ::oFormatoLabel:bValid  := {|| cDocumento( ::oFormatoLabel, ::oFormatoLabel:oHelpText, dbfDoc, "FL" ) }
            ::oFormatoLabel:bHelp   := {|| BrwDocumento( ::oFormatoLabel, ::oFormatoLabel:oHelpText, "FL" ) }

         TBtnBmp():ReDefine( 220, "Printer_pencil_16",,,,,{|| EdtDocumento( ::cFormatoLabel ) }, ::oFld:aDialogs[ 1 ], .f., , .f., "Modificar formato de etiquetas" )

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

         REDEFINE BUTTON oBtnMod;
            ID       160 ;
            OF       ::oFld:aDialogs[ 2 ] ;
            ACTION   ( nil )

         REDEFINE BUTTON oBtnZoo;
            ID       165 ;
            OF       ::oFld:aDialogs[ 2 ] ;
            ACTION   ( nil )

         REDEFINE BUTTON oBtnPrp ;
            ID       220 ;
            OF       ::oFld:aDialogs[ 2 ] ;
            ACTION   ( nil )

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

      ::oDlg:bStart  := {|| ::oBtnAnterior:Hide(), ::oFormatoLabel:lValid(), oBtnMod:Hide(), oBtnZoo:Hide(), oBtnPrp:Hide() }

      ACTIVATE DIALOG ::oDlg CENTER

      ::End()

   end if

Return ( Self )

//--------------------------------------------------------------------------//

Method lCreateAuxiliar() CLASS TFacturaProveedorLabelGenerator

   local oBlock
   local oError
   local lCreateAuxiliar   := .t.

   oBlock                  := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      ::cAreaTmpLabel      := "Lbl" + cCurUsr()
      ::cFileTmpLabel      := cGetNewFileName( cPatTmp() + "Lbl" )

      dbCreate( ::cFileTmpLabel, aSqlStruct( aColFacPrv() ), cLocalDriver() )
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

Method BotonAnterior() CLASS TFacturaProveedorLabelGenerator

   ::oFld:GoPrev()

   ::oBtnAnterior:Hide()

   SetWindowText( ::oBtnSiguiente:hWnd, "Siguien&te >" )

Return ( Self )

//--------------------------------------------------------------------------//

Method BotonSiguiente() CLASS TFacturaProveedorLabelGenerator

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

Method lCreateTemporal() CLASS TFacturaProveedorLabelGenerator

   local n
   local nRec
   local oBlock
   local oError
   local nBlancos
   local lCreateTemporal   := .t.

   oBlock                  := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      tmpFacPrvL           := "LblFac"
      filFacPrvL           := cGetNewFileName( cPatTmp() + "LblFac" )

      dbCreate( filFacPrvL, aSqlStruct( aColFacPrv() ), cLocalDriver() )
      dbUseArea( .t., cLocalDriver(), filFacPrvL, tmpFacPrvL, .f. )

      ( tmpFacPrvL )->( OrdCondSet( "!Deleted()", {||!Deleted()} ) )
      ( tmpFacPrvL )->( OrdCreate( filFacPrvL, "nNumFac", "cSerFac + Str( nNumFac ) + cSufFac", {|| Field->cSerFac + Str( Field->nNumFac ) + Field->cSufFac } ) )

      nRec                 := ( ::cAreaTmpLabel )->( Recno() )

      ( ::cAreaTmpLabel )->( dbGoTop() )
      while !( ::cAreaTmpLabel )->( eof() )

         if ( ::cAreaTmpLabel )->lLabel
            for n := 1 to ( ::cAreaTmpLabel )->nLabel
               dbPass( ::cAreaTmpLabel, tmpFacPrvL, .t. )
            next
         end if

         ( ::cAreaTmpLabel )->( dbSkip() )

      end while
      ( tmpFacPrvL )->( dbGoTop() )

      ( ::cAreaTmpLabel )->( dbGoTo( nRec ) )

   RECOVER USING oError

      lCreateTemporal      := .f.

      MsgStop( 'Imposible abrir ficheros de artículos' + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( lCreateTemporal )

//---------------------------------------------------------------------------//

Method DestroyTemporal() CLASS TFacturaProveedorLabelGenerator

   if ( tmpFacPrvL )->( Used() )
      ( tmpFacPrvL )->( dbCloseArea() )
   end if

   dbfErase( filFacPrvL )

   tmpFacPrvL           := nil

   SysRefresh()

Return ( .t. )

//---------------------------------------------------------------------------//

Method PrepareTemporal( oFr ) CLASS TFacturaProveedorLabelGenerator

   local n
   local nBlancos       := 0
   local nPaperHeight   := oFr:GetProperty( "MainPage", "PaperHeight" ) * fr01cm
   local nHeight        := oFr:GetProperty( "CabeceraColumnas", "Height" )
   local nColumns       := oFr:GetProperty( "MainPage", "Columns" )
   local nItemsInColumn := 0

   if !Empty( nPaperHeight ) .and. !Empty( nHeight ) .and. !Empty( nColumns )

      nItemsInColumn       := int( nPaperHeight / nHeight )

      nBlancos             := ( ::nColumnaInicio - 1 ) * nItemsInColumn
      nBlancos             += ( ::nFilaInicio - 1 )

      for n := 1 to nBlancos
         dbPass( dbBlankRec( dbfFacPrvL ), tmpFacPrvL, .t. )
      next

   end if 

   ( tmpFacPrvL )->( dbGoTop() )

Return ( .t. )

//---------------------------------------------------------------------------//

Method lPrintLabels() CLASS TFacturaProveedorLabelGenerator

   local oFr

   local nCopies      := 1
   local nDevice      := IS_SCREEN
   local cPrinter     := PrnGetName()

   if ::lCreateTemporal()

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

      /*
      Destruye el fichero temporal------------------------------------------------
      */

      ::DestroyTemporal()

   end if

Return .t.

//---------------------------------------------------------------------------//

Method End() CLASS TFacturaProveedorLabelGenerator

   if !Empty( ::nRecno )
      ( TDataView():FacturasProveedores( nView ) )->( dbGoTo( ::nRecno ) )
   end if

   if IsTrue( ::lClose )
      CloseFiles()
   end if

   if !Empty( ::cAreaTmpLabel ) .and. ( ::cAreaTmpLabel )->( Used() )
      ( ::cAreaTmpLabel )->( dbCloseArea() )
   end if

   dbfErase( ::cFileTmpLabel )

   WritePProString( "Etiquetas", "Factura proveedor", ::cFormatoLabel, cPatEmp() + "Empresa.Ini" )

Return ( Self )

//--------------------------------------------------------------------------//

Method PutLabel() CLASS TFacturaProveedorLabelGenerator

   ( ::cAreaTmpLabel )->lLabel   := !( ::cAreaTmpLabel )->lLabel

   ::oBrwLabel:Refresh()
   ::oBrwLabel:Select()

Return ( Self )

//--------------------------------------------------------------------------//

Method SelectAllLabels( lSelect ) CLASS TFacturaProveedorLabelGenerator

   local n        := 0
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

Method AddLabel() CLASS TFacturaProveedorLabelGenerator

   ( ::cAreaTmpLabel )->nLabel++

   ::oBrwLabel:Refresh()
   ::oBrwLabel:SetFocus()

Return ( Self )

//--------------------------------------------------------------------------//

Method DelLabel() CLASS TFacturaProveedorLabelGenerator

   if ( ::cAreaTmpLabel )->nLabel > 1
      ( ::cAreaTmpLabel )->nLabel--
   end if

   ::oBrwLabel:Refresh()
   ::oBrwLabel:SetFocus()

Return ( Self )

//---------------------------------------------------------------------------//

Method EditLabel() CLASS TFacturaProveedorLabelGenerator

   ::oBrwLabel:aCols[ 6 ]:Edit()

Return ( Self )

//---------------------------------------------------------------------------//

Method LoadAuxiliar() CLASS TFacturaProveedorLabelGenerator

   local nRec
   local nOrd

   /*
   Limpiamos la base de datos temporal-----------------------------------------
   */

   ( ::cAreaTmpLabel )->( __dbZap() )

   /*
   Llenamos la tabla temporal--------------------------------------------------
   */

   nRec           := ( TDataView():FacturasProveedores( nView ) )->( Recno() )
   nOrd           := ( TDataView():FacturasProveedores( nView ) )->( OrdSetFocus( "nNumFac" ) )

   if ( TDataView():FacturasProveedores( nView ) )->( dbSeek( ::cSerieInicio + Str( ::nDocumentoInicio, 9 ) + ::cSufijoInicio, .t. ) )

      while ( TDataView():FacturasProveedores( nView ) )->cSerFac + Str( ( TDataView():FacturasProveedores( nView ) )->nNumFac ) + ( TDataView():FacturasProveedores( nView ) )->cSufFac >= ::cSerieInicio + Str( ::nDocumentoInicio, 9 ) + ::cSufijoInicio .and. ;
            ( TDataView():FacturasProveedores( nView ) )->cSerFac + Str( ( TDataView():FacturasProveedores( nView ) )->nNumFac ) + ( TDataView():FacturasProveedores( nView ) )->cSufFac <= ::cSerieFin + Str( ::nDocumentoFin, 9 ) + ::cSufijoFin          .and. ;
            !( TDataView():FacturasProveedores( nView ) )->( eof() )

         if ( dbfFacPrvL )->( dbSeek( ( TDataView():FacturasProveedores( nView ) )->cSerFac + Str( ( TDataView():FacturasProveedores( nView ) )->nNumFac ) + ( TDataView():FacturasProveedores( nView ) )->cSufFac ) )

            while ( ( dbfFacPrvL )->cSerFac + Str( ( dbfFacPrvL )->nNumFac ) + ( dbfFacPrvL )->cSufFac == ( TDataView():FacturasProveedores( nView ) )->cSerFac + Str( ( TDataView():FacturasProveedores( nView ) )->nNumFac ) + ( TDataView():FacturasProveedores( nView ) )->cSufFac ) .and. ( dbfFacPrvL )->( !eof() )

               if !Empty( ( dbfFacPrvL )->cRef )

                  ( ::cAreaTmpLabel )->( dbAppend() )

                  ( ::cAreaTmpLabel )->cSerFac  := ( dbfFacPrvL )->cSerFac
                  ( ::cAreaTmpLabel )->nNumFac  := ( dbfFacPrvL )->nNumFac
                  ( ::cAreaTmpLabel )->cSufFac  := ( dbfFacPrvL )->cSufFac
                  ( ::cAreaTmpLabel )->cRef     := ( dbfFacPrvL )->cRef
                  ( ::cAreaTmpLabel )->cRefPrv  := ( dbfFacPrvL )->cRefPrv
                  ( ::cAreaTmpLabel )->cDetalle := ( dbfFacPrvL )->cDetalle
                  ( ::cAreaTmpLabel )->nPreUnit := ( dbfFacPrvL )->nPreUnit
                  ( ::cAreaTmpLabel )->nIva     := ( dbfFacPrvL )->nIva
                  ( ::cAreaTmpLabel )->nReq     := ( dbfFacPrvL )->nReq
                  ( ::cAreaTmpLabel )->nCanEnt  := ( dbfFacPrvL )->nCanEnt
                  ( ::cAreaTmpLabel )->lControl := ( dbfFacPrvL )->lControl
                  ( ::cAreaTmpLabel )->cUnidad  := ( dbfFacPrvL )->cUnidad
                  ( ::cAreaTmpLabel )->nUniCaja := ( dbfFacPrvL )->nUniCaja
                  ( ::cAreaTmpLabel )->lChgLin  := ( dbfFacPrvL )->lChgLin
                  ( ::cAreaTmpLabel )->mLngDes  := ( dbfFacPrvL )->mLngDes
                  ( ::cAreaTmpLabel )->nDtoLin  := ( dbfFacPrvL )->nDtoLin
                  ( ::cAreaTmpLabel )->nDtoPrm  := ( dbfFacPrvL )->nDtoPrm
                  ( ::cAreaTmpLabel )->nDtoRap  := ( dbfFacPrvL )->nDtoRap
                  ( ::cAreaTmpLabel )->nPreCom  := ( dbfFacPrvL )->nPreCom
                  ( ::cAreaTmpLabel )->lBnfLin1 := ( dbfFacPrvL )->lBnfLin1
                  ( ::cAreaTmpLabel )->lBnfLin2 := ( dbfFacPrvL )->lBnfLin2
                  ( ::cAreaTmpLabel )->lBnfLin3 := ( dbfFacPrvL )->lBnfLin3
                  ( ::cAreaTmpLabel )->lBnfLin4 := ( dbfFacPrvL )->lBnfLin4
                  ( ::cAreaTmpLabel )->lBnfLin5 := ( dbfFacPrvL )->lBnfLin5
                  ( ::cAreaTmpLabel )->lBnfLin6 := ( dbfFacPrvL )->lBnfLin6
                  ( ::cAreaTmpLabel )->nBnfLin1 := ( dbfFacPrvL )->nBnfLin1
                  ( ::cAreaTmpLabel )->nBnfLin2 := ( dbfFacPrvL )->nBnfLin2
                  ( ::cAreaTmpLabel )->nBnfLin3 := ( dbfFacPrvL )->nBnfLin3
                  ( ::cAreaTmpLabel )->nBnfLin4 := ( dbfFacPrvL )->nBnfLin4
                  ( ::cAreaTmpLabel )->nBnfLin5 := ( dbfFacPrvL )->nBnfLin5
                  ( ::cAreaTmpLabel )->nBnfLin6 := ( dbfFacPrvL )->nBnfLin6
                  ( ::cAreaTmpLabel )->nBnfSbr1 := ( dbfFacPrvL )->nBnfSbr1
                  ( ::cAreaTmpLabel )->nBnfSbr2 := ( dbfFacPrvL )->nBnfSbr2
                  ( ::cAreaTmpLabel )->nBnfSbr3 := ( dbfFacPrvL )->nBnfSbr3
                  ( ::cAreaTmpLabel )->nBnfSbr4 := ( dbfFacPrvL )->nBnfSbr4
                  ( ::cAreaTmpLabel )->nBnfSbr5 := ( dbfFacPrvL )->nBnfSbr5
                  ( ::cAreaTmpLabel )->nBnfSbr6 := ( dbfFacPrvL )->nBnfSbr6
                  ( ::cAreaTmpLabel )->nPvpLin1 := ( dbfFacPrvL )->nPvpLin1
                  ( ::cAreaTmpLabel )->nPvpLin2 := ( dbfFacPrvL )->nPvpLin2
                  ( ::cAreaTmpLabel )->nPvpLin3 := ( dbfFacPrvL )->nPvpLin3
                  ( ::cAreaTmpLabel )->nPvpLin4 := ( dbfFacPrvL )->nPvpLin4
                  ( ::cAreaTmpLabel )->nPvpLin5 := ( dbfFacPrvL )->nPvpLin5
                  ( ::cAreaTmpLabel )->nPvpLin6 := ( dbfFacPrvL )->nPvpLin6
                  ( ::cAreaTmpLabel )->nIvaLin1 := ( dbfFacPrvL )->nIvaLin1
                  ( ::cAreaTmpLabel )->nIvaLin2 := ( dbfFacPrvL )->nIvaLin2
                  ( ::cAreaTmpLabel )->nIvaLin3 := ( dbfFacPrvL )->nIvaLin3
                  ( ::cAreaTmpLabel )->nIvaLin4 := ( dbfFacPrvL )->nIvaLin4
                  ( ::cAreaTmpLabel )->nIvaLin5 := ( dbfFacPrvL )->nIvaLin5
                  ( ::cAreaTmpLabel )->nIvaLin6 := ( dbfFacPrvL )->nIvaLin6
                  ( ::cAreaTmpLabel )->nIvaLin  := ( dbfFacPrvL )->nIvaLin
                  ( ::cAreaTmpLabel )->lIvaLin  := ( dbfFacPrvL )->lIvaLin
                  ( ::cAreaTmpLabel )->cCodPr1  := ( dbfFacPrvL )->cCodPr1
                  ( ::cAreaTmpLabel )->cCodPr2  := ( dbfFacPrvL )->cCodPr2
                  ( ::cAreaTmpLabel )->cValPr1  := ( dbfFacPrvL )->cValPr1
                  ( ::cAreaTmpLabel )->cValPr2  := ( dbfFacPrvL )->cValPr2
                  ( ::cAreaTmpLabel )->nFacCnv  := ( dbfFacPrvL )->nFacCnv
                  ( ::cAreaTmpLabel )->cAlmLin  := ( dbfFacPrvL )->cAlmLin
                  ( ::cAreaTmpLabel )->nCtlStk  := ( dbfFacPrvL )->nCtlStk
                  ( ::cAreaTmpLabel )->lLote    := ( dbfFacPrvL )->lLote
                  ( ::cAreaTmpLabel )->nLote    := ( dbfFacPrvL )->nLote
                  ( ::cAreaTmpLabel )->cLote    := ( dbfFacPrvL )->cLote
                  ( ::cAreaTmpLabel )->nNumLin  := ( dbfFacPrvL )->nNumLin
                  ( ::cAreaTmpLabel )->nUndKit  := ( dbfFacPrvL )->nUndKit
                  ( ::cAreaTmpLabel )->lKitArt  := ( dbfFacPrvL )->lKitArt
                  ( ::cAreaTmpLabel )->lKitChl  := ( dbfFacPrvL )->lKitChl
                  ( ::cAreaTmpLabel )->lKitPrc  := ( dbfFacPrvL )->lKitPrc
                  ( ::cAreaTmpLabel )->lImpLin  := ( dbfFacPrvL )->lImpLin
                  ( ::cAreaTmpLabel )->mNumSer  := ( dbfFacPrvL )->mNumSer
                  ( ::cAreaTmpLabel )->cCodUbi1 := ( dbfFacPrvL )->cCodUbi1
                  ( ::cAreaTmpLabel )->cCodUbi2 := ( dbfFacPrvL )->cCodUbi2
                  ( ::cAreaTmpLabel )->cCodUbi3 := ( dbfFacPrvL )->cCodUbi3
                  ( ::cAreaTmpLabel )->cValUbi1 := ( dbfFacPrvL )->cValUbi1
                  ( ::cAreaTmpLabel )->cValUbi2 := ( dbfFacPrvL )->cValUbi2
                  ( ::cAreaTmpLabel )->cValUbi3 := ( dbfFacPrvL )->cValUbi3
                  ( ::cAreaTmpLabel )->cNomUbi1 := ( dbfFacPrvL )->cNomUbi1
                  ( ::cAreaTmpLabel )->cNomUbi2 := ( dbfFacPrvL )->cNomUbi2
                  ( ::cAreaTmpLabel )->cNomUbi3 := ( dbfFacPrvL )->cNomUbi3
                  ( ::cAreaTmpLabel )->cCodFam  := ( dbfFacPrvL )->cCodFam
                  ( ::cAreaTmpLabel )->cGrpFam  := ( dbfFacPrvL )->cGrpFam
                  ( ::cAreaTmpLabel )->mObsLin  := ( dbfFacPrvL )->mObsLin
                  ( ::cAreaTmpLabel )->nPvpRec  := ( dbfFacPrvL )->nPvpRec
                  ( ::cAreaTmpLabel )->nUndLin  := nTotNFacPrv( dbfFacPrvL )
                  ( ::cAreaTmpLabel )->lLabel   := .t.

                  if ::nCantidadLabels == 1
                  ( ::cAreaTmpLabel )->nLabel   := nTotNFacPrv( dbfFacPrvL )
                  else
                  ( ::cAreaTmpLabel )->nLabel   := ::nUnidadesLabels
                  end if

               end if

               ( dbfFacPrvL )->( dbSkip() )

            end while

         end if

         ( TDataView():FacturasProveedores( nView ) )->( dbSkip() )

      end while

   end if

   ( TDataView():FacturasProveedores( nView ) )->( OrdSetFocus( nOrd ) )
   ( TDataView():FacturasProveedores( nView ) )->( dbGoTo( nRec ) )

   ( ::cAreaTmpLabel )->( dbGoTop() )

   ::oBrwLabel:Refresh()

Return ( Self )

//---------------------------------------------------------------------------//

Method InitLabel( oLabel ) CLASS TFacturaProveedorLabelGenerator

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

Method SelectColumn( oCombo ) CLASS TFacturaProveedorLabelGenerator

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

Function DesignLabelFacPrv( oFr, dbfDoc )

   local oLabel   := TFacturaProveedorLabelGenerator():Init()

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
         oFr:SetObjProperty(  "CabeceraColumnas",  "DataSet",        "Lineas de facturas" )

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
      Destruye el fichero temporal------------------------------------------------
      */

      oLabel:DestroyTemporal()

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
//---------------------------------------------------------------------------//

Function DesignReportFacPrv( oFr, dbfDoc )

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
                                                   "CallHbFunc('nTotFacPrv');"                                 + Chr(13) + Chr(10) + ;
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
         oFr:SetObjProperty(  "CabeceraColumnas",  "DataSet", "Facturas" )

         oFr:AddBand(         "DetalleColumnas",   "MainPage", frxDetailData  )
         oFr:SetProperty(     "DetalleColumnas",   "Top", 230 )
         oFr:SetProperty(     "DetalleColumnas",   "Height", 28 )
         oFr:SetObjProperty(  "DetalleColumnas",   "DataSet", "Lineas de facturas" )
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

      oFr:SetTabTreeExpanded( FR_tvAll, .f. )
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

Function PrintReportFacPrv( nDevice, nCopies, cPrinter, dbfDoc )

   local oFr
   local cFilePdf       := cPatTmp() + "FacturaProveedor" + StrTran( ( TDataView():FacturasProveedores( nView ) )->cSerFac + Str( ( TDataView():FacturasProveedores( nView ) )->nNumFac ) + ( TDataView():FacturasProveedores( nView ) )->cSufFac, " ", "" ) + ".Pdf"

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
            oFr:PrepareReport()
            oFr:ShowPreparedReport()

         case nDevice == IS_PRINTER
            oFr:PrintOptions:SetPrinter( cPrinter )
            oFr:PrintOptions:SetCopies( nCopies )
            oFr:PrintOptions:SetShowDialog( .f. )
            oFr:PrepareReport()
            oFr:Print()

         case nDevice == IS_PDF
            oFr:PrintOptions:SetShowDialog( .f. )
            oFr:SetProperty(  "PDFExport", "DefaultPath",      cPatTmp() )
            oFr:SetProperty(  "PDFExport", "FileName",         cFilePdf )
            oFr:SetProperty(  "PDFExport", "ShowDialog",       .f. )
            oFr:SetProperty(  "PDFExport", "EmbeddedFonts",    .t. )
            oFr:SetProperty(  "PDFExport", "PrintOptimized",   .t. )
            oFr:SetProperty(  "PDFExport", "Outline",          .t. )
            oFr:SetProperty(  "PDFExport", "OpenAfterExport",  .t. )
            oFr:DoExport(     "PDFExport" )

         case nDevice == IS_MAIL

            oFr:SetProperty(  "PDFExport", "ShowDialog",       .f. )
            oFr:SetProperty(  "PDFExport", "DefaultPath",      cPatTmp() )
            oFr:SetProperty(  "PDFExport", "FileName",         cFilePdf  )
            oFr:SetProperty(  "PDFExport", "EmbeddedFonts",    .t. )
            oFr:SetProperty(  "PDFExport", "PrintOptimized",   .t. )
            oFr:SetProperty(  "PDFExport", "Outline",          .t. )
            oFr:SetProperty(  "PDFExport", "OpenAfterExport",  .f. )
            oFr:DoExport(     "PDFExport" )

            if file( cFilePdf )

               with object ( TGenMailing():New() )

                  :SetTypeDocument( "nFacPrv" )
                  :SetDe(           uFieldEmpresa( "cNombre" ) )
                  :SetCopia(        uFieldEmpresa( "cCcpMai" ) )
                  :SetAdjunto(      cFilePdf )
                  :SetPara(         RetFld( ( TDataView():FacturasProveedores( nView ) )->cCodPrv, TDataView():Proveedores( nView ), "cMeiInt" ) )
                  :SetAsunto(       "Envio de factura de proveedor número " + ( TDataView():FacturasProveedores( nView ) )->cSerFac + "/" + Alltrim( Str( ( TDataView():FacturasProveedores( nView ) )->nNumFac ) ) )
                  :SetMensaje(      "Adjunto le remito nuestra factura de proveedor " + ( TDataView():FacturasProveedores( nView ) )->cSerFac + "/" + Alltrim( Str( ( TDataView():FacturasProveedores( nView ) )->nNumFac ) ) + Space( 1 ) )
                  :SetMensaje(      "de fecha " + Dtoc( ( TDataView():FacturasProveedores( nView ) )->dfecFac ) + Space( 1 ) )
                  :SetMensaje(      CRLF )
                  :SetMensaje(      CRLF )
                  :SetMensaje(      "Reciba un cordial saludo." )

                  :GeneralResource( TDataView():FacturasProveedores( nView ), aItmFacPrv() )

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

FUNCTION nIncUFacPrv( dbfTmpLin, nDec, nVdv )

   local nCalculo

   DEFAULT nDec   := nDinDiv()
   DEFAULT nVdv   := 1

   nCalculo       := nTotUFacPrv( dbfTmpLin, nDec, nVdv )

   if !( dbfTmpLin )->lIvaLin
      nCalculo    += nCalculo * ( dbfTmpLin )->nIva / 100
   end if

   IF nVdv != 0
      nCalculo    := nCalculo / nVdv
   END IF

RETURN ( Round( nCalculo, nDec ) )

//---------------------------------------------------------------------------//

FUNCTION nIncLFacPrv( dbfLin, nDec, nRou, nVdv )

   local nCalculo := nTotLFacPrv( dbfLin, nDec, nRou, nVdv )

   if !( dbfLin )->lIvaLin
      nCalculo    += nCalculo * ( dbfLin )->nIva / 100
   end if

RETURN ( nCalculo )

//---------------------------------------------------------------------------//

Function BrwFacPrv( oGet, oIva )

   local oDlg
   local oBrw
   local nOrd
   local oGet1
   local cGet1
   local oCbxOrd
   local cCbxOrd
   local aCbxOrd

   if !OpenFiles()
      Return .f.
   end if

   aCbxOrd           := { "Número", "Fecha", "Proveedor", "Nombre" }
   nOrd              := GetBrwOpt( "BrwFacPrv" )
   nOrd              := Min( Max( nOrd, 1 ), len( aCbxOrd ) )
   cCbxOrd           := aCbxOrd[ nOrd ]

   DEFINE DIALOG oDlg RESOURCE "HelpEntry" TITLE "Facturas rectificativas de clientes"

      REDEFINE GET oGet1 VAR cGet1;
         ID       104 ;
         ON CHANGE( AutoSeek( nKey, nFlags, Self, oBrw, TDataView():FacturasProveedores( nView ), nil, nil, .f. ) );
         VALID    ( OrdClearScope( oBrw, TDataView():FacturasProveedores( nView ) ) );
         BITMAP   "FIND" ;
         OF       oDlg

      REDEFINE COMBOBOX oCbxOrd ;
         VAR      cCbxOrd ;
         ID       102 ;
         ITEMS    aCbxOrd ;
         ON CHANGE( ( TDataView():FacturasProveedores( nView ) )->( OrdSetFocus( oCbxOrd:nAt ) ), oBrw:refresh(), oGet1:SetFocus() ) ;
         OF       oDlg

      oBrw                 := IXBrowse():New( oDlg )

      oBrw:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrw:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrw:cAlias          := TDataView():FacturasProveedores( nView )
      oBrw:nMarqueeStyle   := 5
      oBrw:cName           := "Factura de proveedores.Browse"

      oBrw:bLDblClick      := {|| oDlg:end( IDOK ) }

      oBrw:CreateFromResource( 105 )

      with object ( oBrw:AddCol() )
         :cHeader          := "Número"
         :cSortOrder       := "nNumFac"
         :bEditValue       := {|| ( TDataView():FacturasProveedores( nView ) )->cSerFac + "/" + RTrim( Str( ( TDataView():FacturasProveedores( nView ) )->nNumFac ) ) + "/" + ( TDataView():FacturasProveedores( nView ) )->cSufFac }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Fecha"
         :cSortOrder       := "dFecFac"
         :bEditValue       := {|| Dtoc( ( TDataView():FacturasProveedores( nView ) )->dFecFac ) }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Proveedor"
         :cSortOrder       := "cCodPrv"
         :bEditValue       := {|| Rtrim( ( TDataView():FacturasProveedores( nView ) )->cCodPrv ) }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Nombre"
         :cSortOrder       := "cNomPrv"
         :bEditValue       := {|| Rtrim( ( TDataView():FacturasProveedores( nView ) )->cNomPrv ) }
         :nWidth           := 180
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Importe"
         :bEditValue       := {|| nTotFacPrv( ( TDataView():FacturasProveedores( nView ) )->cSerFac + Str( ( TDataView():FacturasProveedores( nView ) )->nNumFac ) + ( TDataView():FacturasProveedores( nView ) )->cSufFac, TDataView():FacturasProveedores( nView ), dbfFacPrvL, dbfIva, dbfDiv, dbfFacPrvP, nil, cDivEmp(), .t. ) }
         :nWidth           := 80
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      REDEFINE BUTTON ;
         ID       500 ;
         OF       oDlg ;
         WHEN     ( .f. ) ;
         ACTION   ( nil )

      REDEFINE BUTTON ;
         ID       501 ;
         OF       oDlg ;
         WHEN     ( .f. ) ;
         ACTION   ( nil )

      REDEFINE BUTTON ;
         ID       IDOK ;
         OF       oDlg ;
         ACTION   ( oDlg:end( IDOK ) )

      REDEFINE BUTTON ;
         ID       IDCANCEL ;
         OF       oDlg ;
         ACTION   ( oDlg:end() )

   oDlg:AddFastKey( VK_F5, {|| oDlg:end( IDOK ) } )

   ACTIVATE DIALOG oDlg ON INIT ( oBrw:Load() ) CENTER

   if oDlg:nResult == IDOK
      oGet:cText( ( TDataView():FacturasProveedores( nView ) )->cSerFac + Str( ( TDataView():FacturasProveedores( nView ) )->nNumFac ) + ( TDataView():FacturasProveedores( nView ) )->cSufFac )
      oGet:bWhen   := {|| .f. }
   end if

   SetBrwOpt( "BrwFacPrv", ( TDataView():FacturasProveedores( nView ) )->( OrdNumber() ) )

   ( TDataView():FacturasProveedores( nView ) )->( dbClearFilter() )

   CloseFiles()

   /*
   Guardamos los datos del browse-------------------------------------------
   */

   oBrw:CloseData()

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

FUNCTION BrowseInformesFacPrv( oGet, oGet2 )

   local oDlg
   local oBrw
   local oGet1
   local cGet1
   local oCbxOrd
   local cCbxOrd
   local nOrd
   local aCbxOrd

   if !OpenFiles()
      Return .f.
   end if

   aCbxOrd           := { "Número", "Fecha", "Proveedor", "Nombre" }
   nOrd              := GetBrwOpt( "BrwFacPrv" )
   nOrd              := Min( Max( nOrd, 1 ), len( aCbxOrd ) )
   cCbxOrd           := aCbxOrd[ nOrd ]

   DEFINE DIALOG oDlg RESOURCE "HELPENTRY" TITLE "Facturas de proveedor"

      REDEFINE GET oGet1 VAR cGet1;
         ID       104 ;
         ON CHANGE( AutoSeek( nKey, nFlags, Self, oBrw, TDataView():FacturasProveedores( nView ), nil, nil, .f. ) );
         VALID    ( OrdClearScope( oBrw, TDataView():FacturasProveedores( nView ) ) );
         BITMAP   "FIND" ;
         OF       oDlg

      REDEFINE COMBOBOX oCbxOrd ;
         VAR      cCbxOrd ;
         ID       102 ;
         ITEMS    aCbxOrd ;
         ON CHANGE( ( TDataView():FacturasProveedores( nView ) )->( OrdSetFocus( oCbxOrd:nAt ) ), oBrw:refresh(), oGet1:SetFocus() ) ;
         OF       oDlg

      oBrw                 := IXBrowse():New( oDlg )

      oBrw:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrw:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrw:cAlias          := TDataView():FacturasProveedores( nView )
      oBrw:nMarqueeStyle   := 5
      oBrw:cName           := "Factura de proveedor.Browse informes"

      oBrw:bLDblClick      := {|| oDlg:end( IDOK ) }

      oBrw:CreateFromResource( 105 )

      with object ( oBrw:AddCol() )
         :cHeader          := "Número"
         :cSortOrder       := "nNumFac"
         :bEditValue       := {|| ( TDataView():FacturasProveedores( nView ) )->cSerFac + "/" + RTrim( Str( ( TDataView():FacturasProveedores( nView ) )->nNumFac ) ) + "/" + ( TDataView():FacturasProveedores( nView ) )->cSufFac }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Fecha"
         :cSortOrder       := "dFecFac"
         :bEditValue       := {|| Dtoc( ( TDataView():FacturasProveedores( nView ) )->dFecFac ) }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Proveedor"
         :cSortOrder       := "cCodPrv"
         :bEditValue       := {|| Rtrim( ( TDataView():FacturasProveedores( nView ) )->cCodPrv ) }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Nombre"
         :cSortOrder       := "cNomCli"
         :bEditValue       := {|| Rtrim( ( TDataView():FacturasProveedores( nView ) )->cNomPrv ) }
         :nWidth           := 180
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Importe"
         :bEditValue       := {|| nTotFacPrv( ( TDataView():FacturasProveedores( nView ) )->cSerFac + Str( ( TDataView():FacturasProveedores( nView ) )->nNumFac ) + ( TDataView():FacturasProveedores( nView ) )->cSufFac, TDataView():FacturasProveedores( nView ), dbfFacPrvL, dbfIva, dbfDiv, dbfFacPrvP, nil, cDivEmp(), .f. ) }
         :nWidth           := 80
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      REDEFINE BUTTON ;
         ID       500 ;
         OF       oDlg ;
         WHEN     ( .f. ) ;
         ACTION   ( nil )

      REDEFINE BUTTON ;
         ID       501 ;
         OF       oDlg ;
         WHEN     ( .f. ) ;
         ACTION   ( nil )

      REDEFINE BUTTON ;
         ID       IDOK ;
         OF       oDlg ;
         ACTION   ( oDlg:end( IDOK ) )

      REDEFINE BUTTON ;
         ID       IDCANCEL ;
         OF       oDlg ;
         ACTION   ( oDlg:end() )

   oDlg:AddFastKey( VK_F5, {|| oDlg:end( IDOK ) } )

   ACTIVATE DIALOG oDlg ;
   ON INIT ( oBrw:Load() ) ;
   CENTER

   if oDlg:nResult == IDOK
      oGet:cText( ( TDataView():FacturasProveedores( nView ) )->cSerFac + Str( ( TDataView():FacturasProveedores( nView ) )->nNumFac ) + ( TDataView():FacturasProveedores( nView ) )->cSufFac )
      oGet2:cText( ( TDataView():FacturasProveedores( nView ) )->cNomPrv )
   end if

   SetBrwOpt( "BrwFacPrv", ( TDataView():FacturasProveedores( nView ) )->( OrdNumber() ) )

   ( TDataView():FacturasProveedores( nView ) )->( dbClearFilter() )

   CloseFiles()

   /*
    Guardamos los datos del browse-------------------------------------------
   */

   oBrw:CloseData()

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

FUNCTION lValidInformeFacPrv( oGet, oGet2 )

   local lClose   := .f.
   local lValid   := .f.
   local xValor   := oGet:varGet()

   if Empty( xValor )
      return .t.
   end if

   if !OpenFiles()
      Return .f.
   end if

   if ( TDataView():FacturasProveedores( nView ) )->( dbSeek( xValor ) )

      oGet:cText( ( TDataView():FacturasProveedores( nView ) )->cSerFac + Str( ( TDataView():FacturasProveedores( nView ) )->nNumFac ) + ( TDataView():FacturasProveedores( nView ) )->cSufFac )

      oGet2:cText( ( TDataView():FacturasProveedores( nView ) )->cNomPrv )

      lValid   := .t.

   else

      msgStop( "Factura no encontrada" )

   end if

   CloseFiles()

RETURN lValid

//---------------------------------------------------------------------------//

Function lIntelliArtciculoSearch( cCodArt, cCodPrv, dbfArticulo, dbfArtPrv, dbfCodebar )

   local nOrdAnt
   local cCodigoArticulo   
   local cCodigoProveedor

   /*
   Busqueda por codigo interno-------------------------------------------------
   */

   cCodArt                 := cSeekCodebar( cCodArt, dbfCodebar, dbfArticulo )

   if ( dbfArticulo )->( dbSeek( cCodArt ) ) .or. ( dbfArticulo )->( dbSeek( Upper( cCodArt ) ) )
      cCodigoArticulo      := ( dbfArticulo )->Codigo 
   end if

   /*
   Busqueda por codigo de proveedor--------------------------------------------
   */

   nOrdAnt                 := ( dbfArtPrv )->( OrdSetFocus( "cRefPrv" ) )

   if ( dbfArtPrv )->( dbSeek( cCodPrv + cCodArt ) )
      cCodigoProveedor     := ( dbfArtPrv )->cCodArt 
   end if

   ( dbfArtPrv )->( ordSetFocus( nOrdAnt ) )

   /*
   Vamos a ver q ha pasado-----------------------------------------------------
   */

   do case
      case Empty( cCodigoArticulo ) .and. Empty( cCodigoProveedor )

         Return ( .f. )

      case !Empty( cCodigoArticulo ) .and. Empty( cCodigoProveedor )

         if ( dbfArticulo )->( dbSeek( cCodigoArticulo ) )
            Return ( .t. )
         end if 
      
      case Empty( cCodigoArticulo ) .and. !Empty( cCodigoProveedor )

         if ( dbfArticulo )->( dbSeek( cCodigoProveedor ) )
            Return ( .t. )
         end if

      case !Empty( cCodigoArticulo ) .and. !Empty( cCodigoProveedor )
         
         if uFieldEmpresa( "nCopSea") == 1
            if ( dbfArticulo )->( dbSeek( cCodigoArticulo ) )
               Return ( .t. )
            end if 
         else
            if ( dbfArticulo )->( dbSeek( cCodigoProveedor ) )
               Return ( .t. )
            end if
         end if 

   end case

Return ( .f. )

//---------------------------------------------------------------------------//