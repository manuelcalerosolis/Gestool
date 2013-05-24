#ifndef __PDA__
#include "FiveWin.Ch"
#include "Folder.ch"
#include "Factu.ch"
#include "Report.ch"
#include "Menu.ch"
#else
#include "FWCE.ch"
REQUEST DBFCDX
#endif

#ifndef __PDA__

#define CLR_BAR                  14197607

#define _MENUITEM_               "01098"

/*
Definici¢n de la base de datos de S.A.T. a clientes
*/

#define _CSERSAT                   1      //   C      1     0
#define _NNUMSAT                   2      //   N      9     0
#define _CSUFSAT                   3      //   C      2     0
#define _CTURSAT                   4      //   C      2     0
#define _DFECSAT                   5      //   D      8     0
#define _CCODCLI                   6      //   C     10     0
#define _CNOMCLI                   7      //   C     35     0
#define _CDIRCLI                   8      //   C     35     0
#define _CPOBCLI                   9      //   C     25     0
#define _CPRVCLI                  10      //   C     20     0
#define _CPOSCLI                  11      //   C      5     0
#define _CDNICLI                  12      //   C     15     0
#define _LMODCLI                  13      //   L      1     0
#define _CCODAGE                  14      //   C      3     0
#define _CCODOBR                  15      //   C      3     0
#define _CCODTAR                  16      //   C      4     0
#define _CCODALM                  17      //   C      4     0
#define _CCODCAJ                  18      //   C      4     0
#define _CCODPGO                  19      //   C      2     0
#define _CCODRUT                  20      //   C      2     0
#define _DFECENT                  21      //   D      8     0
#define _LESTADO                  22      //   L      1     0
#define _CSUSAT                   23      //   C     10     0
#define _CCONDENT                 24      //   C     20     0
#define _MCOMENT                  25      //   M     10     0
#define _MOBSERV                  26      //   M     10     0
#define _LMAYOR                   27      //   L      1     0
#define _NTARIFA                  28      //   L      1     0
#define _CDTOESP                  29      //   N      4     1
#define _NDTOESP                  30      //   N      4     1
#define _CDPP                     31      //   N      4     1
#define _NDPP                     32      //   N      4     1
#define _CDTOUNO                  33      //   N      4     1
#define _NDTOUNO                  34      //   N      4     1
#define _CDTODOS                  35      //   N      4     1
#define _NDTODOS                  36      //   N      4     1
#define _NDTOCNT                  37      //   N      5     2
#define _NDTORAP                  38      //   N      5     2
#define _NDTOPUB                  39      //   N      5     2
#define _NDTOPGO                  40      //   N      5     2
#define _NDTOPTF                  41      //   N      5     2
#define _LRECARGO                 42      //   L      1     0
#define _NPCTCOMAGE               43      //   N      5     2
#define _NBULTOS                  44      //   N      3     0
#define _CNUMSat                  45      //   C     10     0
#define _CDIVSAT                  46      //   C      3     0
#define _NVDVSAT                  47      //   C     10     4
#define _LSNDDOC                  48      //   L      1     0
#define _CRETPOR                  49
#define _CRETMAT                  50
#define _NREGIVA                  51
#define _LIVAINC                  52      //   N
#define _NIVAMAN                  53
#define _NMANOBR                  54
#define _CCODTRN                  55
#define _NKGSTRN                  56
#define _LCLOSAT                  57
#define _CCODUSR                  58
#define _DFECCRE                  59
#define _CTIMCRE                  60
#define _CSITUAC                  61      //   C     20     0
#define _NDIAVAL                  62      //   C     20     0
#define _CCODGRP                  63
#define _LIMPRIMIDO               64      //   L      1     0
#define _DFECIMP                  65      //   D      8     0
#define _CHORIMP                  66      //   C      5     0
#define _CCODDLG                  67
#define _NDTOATP                  68      //   N      6     2
#define _NSBRATP                  69      //   N      1     0
#define _DFECENTR                 70      //   D      8     0
#define _DFECSAL                  71      //   D      8     0
#define _LALQUILER                72      //   L      1     0
#define _CMANOBR                  73      //   C    250     0
#define _CNUMTIK                  74      //   C     13     0
#define _CTLFCLI                  75      //   C     20     0
#define _NTOTNET                  76
#define _NTOTIVA                  77
#define _NTOTREQ                  78
#define _NTOTSAT                  79
#define _LOPERPV                  80
#define _CNUMALB                  81
#define _LGARANTIA                82

/*
Definici¢n de la base de datos de lineas de detalle
*/

#define _CREF                      4
#define _CDETALLE                  5
#define _NIVA                      6
#define _NCANSAT                   7
#define _NUNICAJA                  8
#define _LCONTROL                  9
#define _NUNDKIT                  10
#define _NPREDIV                  11
#define _NPNTVER                  12
#define _NIMPTRN                  13
#define _NDTO                     14
#define _NDTOPRM                  15
#define _NCOMAGE                  16
#define _NCANENT                  17
#define _CUNIDAD                  18
#define _NPESOKG                  19
#define _CPESOKG                  20
#define _DFECHA                   21
#define _MLNGDES                  22
#define _LTOTLIN                  23
#define _LIMPLIN                  24
#define _CCODPR1                  25
#define _CCODPR2                  26
#define _CVALPR1                  27
#define _CVALPR2                  28
#define _NFACCNV                  29
#define _NDTODIV                  30
#define _CTIPMOV                  31
#define _NNUMLIN                  32
#define _NCTLSTK                  33
#define _NCOSDIV                  34
#define _NPVSATC                  35
#define _CALMLIN                  36
#define _LIVALIN                  37
#define _CCODIMP                  38
#define _NVALIMP                  39
#define _LLOTE                    40
#define _NLOTE                    41
#define _CLOTE                    42
#define _LKITART                  43
#define _LKITCHL                  44
#define _LKITPRC                  45
#define _NMESGRT                  46
#define _LMSGVTA                  47
#define _LNOTVTA                  48
#define _MNUMSER                  49
#define _CCODTIP                  50      //   C     3      0
#define _CCODFAM                  51      //   C     8      0
#define _CGRPFAM                  52      //   C     3      0
#define _NREQ                     53      //   N    16      6
#define _MOBSLIN                  54      //   M    10      0
#define _CCODPRV                  55      //   C    12      0
#define _CNOMPRV                  56      //   C    30      0
#define _CIMAGEN                  57      //   C    30      0
#define _NPUNTOS                  58
#define _NVALPNT                  59
#define _NDTOPNT                  60
#define _NINCPNT                  61
#define _CREFPRV                  62
#define _NVOLUMEN                 63
#define _CVOLUMEN                 64
#define __DFECENT                 65
#define __DFECSAL                 66
#define _NPREALQ                  67
#define __LALQUILER               68
#define _NNUMMED                  69
#define _NMEDUNO                  70
#define _NMEDDOS                  71
#define _NMEDTRE                  72
#define _NTARLIN                  73      //   L      1     0
#define _LIMPFRA                  74
#define _CCODFRA                  75
#define _CTXTFRA                  76
#define _DESCRIP                  77
#define _LLINOFE                  78
#define _LVOLIMP                  79

/*
Array para IGIC
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
memvar cDetalle
memvar cCliente
memvar cDbfCli
memvar cDbfObr
memvar cDbfAge
memvar cAgente
memvar cDbfPgo
memvar cFPago
memvar cDbfIva
memvar cDbfUsr
memvar cIva
memvar cPromoL
memvar cDbfPromol
memvar cDbfRut
memvar cDbfTrn
memvar cDbfPro
memvar cDbfTblPro
memvar aTotIva
memvar aTotIvm
memvar cCtaCli
memvar nTotBrt
memvar nTotIva
memvar nTotReq
memvar nTotImp
memvar nTotSat
memvar nTotDto
memvar nTotDpp
memvar nTotUno
memvar nTotDos
memvar nTotNet
memvar nTotPnt
memvar nTotCos
memvar nTotIvm
memvar nTotPes
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
memvar nTotUnd
memvar nTotPage
memvar aImpVto
memvar aDatVto
memvar cPicUndSat
memvar nVdvDivSat
memvar cPouDivSat
memvar cPorDivSat
memvar cPouChgSat
memvar nDouDivSat
memvar nRouDivSat
memvar nTotArt
memvar nTotCaj
memvar nPagina
memvar lEnd
memvar nTotalDto

memvar oReport

static oWndBrw
static oBrwIva
static dbfUsr
static dbfRuta
static dbfSatCliT
static dbfSatCliL
static dbfSatCliI
static dbfSatCliD
static dbfSatCliS
static dbfClient
static dbfCliInc
static dbfArtPrv
static dbfDiv
static dbfCajT
static dbfInci
static oBandera
static oNewImp
static dbfArticulo
static dbfCodebar
static dbfTarPreL
static dbfTarPreS
static dbfPromoT
static dbfPromoL
static dbfPromoC
static dbfTblCnv
static dbfIva
static dbfTmpLin
static dbfTmpInc
static dbfTmpDoc
static dbfTmpSer
static dbfKit
static dbfFPago
static dbfObrasT
static dbfAlm
static dbfAgent
static dbfFamilia
static dbfCliAtp
static dbfDoc
static dbfOferta
static dbfTVta
static dbfTblPro
static dbfPro
static dbfFlt
static dbfArtDiv
static dbfDelega
static dbfAgeCom
static dbfCount
static dbfEmp
static dbfPedPrvL
static dbfAlbPrvL
static dbfFacPrvL
static dbfRctPrvL
static dbfPreCliL
static dbfPedCliL
static dbfFacCliL
static dbfFacRecL
static dbfTikCliL
static dbfFacCliP
static dbfAntCliT
static dbfTikCliT
static dbfProLin
static dbfProMat
static dbfHisMov
static dbfSitua
static cTmpLin
static cTmpInc
static cTmpDoc
static cTmpSer
static oGetNet
static oGetTrn
static oGetIva
static oGetReq
static oGetAge
static oGetIvm
static oGetPnt
static oGetRnt
static oGetPes
static oGetDif
static oGetTotal
static oFont
static oMenu
static cPouDiv
static cPorDiv
static cPicUnd
static nDouDiv
static nRouDiv
static cPpvDiv
static nDpvDiv
static oTrans
static nVdvDiv
static oStock
static oTipArt
static oGrpFam
static oFraPub
static bEdtRec          := { | aTmp, aGet, dbfSatCliT, oBrw, bWhen, bValid, nMode | EdtRec( aTmp, aGet, dbfSatCliT, oBrw, bWhen, bValid, nMode ) }
static bEdtDet          := { | aTmp, aGet, dbfSatCliL, oBrw, bWhen, bValid, nMode, aTmpSat | EdtDet( aTmp, aGet, dbfSatCliL, oBrw, bWhen, bValid, nMode, aTmpSat ) }
static bEdtInc          := { | aTmp, aGet, dbfSatCliL, oBrw, bWhen, bValid, nMode, aTmpSat | EdtInc( aTmp, aGet, dbfSatCliI, oBrw, bWhen, bValid, nMode, aTmpSat ) }
static bEdtDoc          := { | aTmp, aGet, dbfSatCliD, oBrw, bWhen, bValid, nMode, aTmpSat | EdtDoc( aTmp, aGet, dbfSatCliD, oBrw, bWhen, bValid, nMode, aTmpSat ) }
static nNumArt          := 0
static nNumCaj          := 0
static cOldCodCli       := ""
static cOldCodArt       := ""
static cOldPrpArt       := ""
static cOldUndMed       := ""
static cOldSituacion    := ""
static lOpenFiles       := .f.
static lExternal        := .f.
static oUndMedicion
static cFiltroUsuario   := ""

static nTarifaPrecio    := 0

static oComisionLinea
static nComisionLinea   := 0

#endif

#ifndef __PDA__

//----------------------------------------------------------------------------//
//Funciones del programa
//----------------------------------------------------------------------------//

FUNCTION GenSatCli( nDevice, cCaption, cCodDoc, cPrinter, nCopies )

   local oInf
   local oDevice
   local nNumSat

   if ( dbfSatCliT )->( Lastrec() ) == 0
      return nil
   end if

   nNumSat              := ( dbfSatCliT )->cSerSat + Str( ( dbfSatCliT )->nNumSat ) + ( dbfSatCliT )->cSufSat

   DEFAULT nDevice      := IS_PRINTER
   DEFAULT cCaption     := "Imprimiendo S.A.T."
   DEFAULT cCodDoc      := cFormatoDocumento( ( dbfSatCliT )->cSerSat, "nSatCli", dbfCount )
   DEFAULT nCopies      := if( nCopiasDocumento( ( dbfSatCliT )->cSerSat, "nSatCli", dbfCount ) == 0, Max( Retfld( ( dbfSatCliT )->cCodCli, dbfClient, "CopiasF" ), 1 ), nCopiasDocumento( ( dbfSatCliT )->cSerSat, "nSatCli", dbfCount ) )

   if Empty( cCodDoc )
      cCodDoc           := cFirstDoc( "SC", dbfDoc )
   end if

   if !lExisteDocumento( cCodDoc, dbfDoc )
      return nil
   end if

   /*
   Si el documento es de tipo visual-------------------------------------------
   */

   PrintReportSatCli( nDevice, nCopies, cPrinter, dbfDoc )

   lChgImpDoc( dbfSatCliT )

RETURN NIL

//--------------------------------------------------------------------------//

Static Function SatCliReportSkipper( dbfSatCliT, dbfSatCliL )

   ( dbfSatCliL )->( dbSkip() )

   nTotPage              += nTotLSatCli( dbfSatCliT, dbfSatCliL )

Return nil

//--------------------------------------------------------------------------//

Static Function ePage( oInf, cCodDoc )

   private nPagina      := oInf:nPage
   private lEnd         := oInf:lFinish

   PrintItems( cCodDoc, oInf )

Return nil

//--------------------------------------------------------------------------//

STATIC FUNCTION OpenFiles( lExt )

   local oError
   local oBlock

   if lOpenFiles
      MsgStop( 'Imposible abrir ficheros de S.A.T. de clientes' )
      Return ( .f. )
   end if

   DEFAULT lExt         := .f.

   lExternal            := lExt

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

      DisableAcceso() 

      lOpenFiles        := .t.

      USE ( cPatEmp() + "SATCLIL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "SATCLIL", @dbfSatCliL ) )
      SET ADSINDEX TO ( cPatEmp() + "SATCLIL.CDX" ) ADDITIVE

      USE ( cPatEmp() + "SATCLII.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "SATCLII", @dbfSatCliI ) )
      SET ADSINDEX TO ( cPatEmp() + "SATCLII.CDX" ) ADDITIVE

      USE ( cPatEmp() + "SATCLID.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "SATCLID", @dbfSatCliD ) )
      SET ADSINDEX TO ( cPatEmp() + "SATCLID.CDX" ) ADDITIVE

      USE ( cPatEmp() + "SATCLIS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "SATCLIS", @dbfSatCliS ) )
      SET ADSINDEX TO ( cPatEmp() + "SATCLIS.CDX" ) ADDITIVE

      USE ( cPatDat() + "TIVA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIVA", @dbfIva ) )
      SET ADSINDEX TO ( cPatDat() + "TIVA.CDX" ) ADDITIVE

      USE ( cPatCli() + "CLIENT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CLIENT", @dbfClient ) )
      SET ADSINDEX TO ( cPatCli() + "CLIENT.CDX" ) ADDITIVE

      USE ( cPatCli() + "CliInc.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CliInc", @dbfCliInc ) )
      SET ADSINDEX TO ( cPatCli() + "CliInc.Cdx" ) ADDITIVE

      USE ( cPatArt() + "PROVART.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PROVART", @dbfArtPrv ) )
      SET ADSINDEX TO ( cPatArt() + "PROVART.CDX" ) ADDITIVE

      USE ( cPatCli() + "CliAtp.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CLIATP", @dbfCliAtp ) )
      SET ADSINDEX TO ( cPatCli() + "CliAtp.Cdx" ) ADDITIVE

      USE ( cPatCli() + "AGENTES.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "AGENTES", @dbfAgent ) )
      SET ADSINDEX TO ( cPatCli() + "AGENTES.CDX" ) ADDITIVE

      USE ( cPatArt() + "ARTICULO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ARTICULO", @dbfArticulo ) )
      SET ADSINDEX TO ( cPatArt() + "ARTICULO.CDX" ) ADDITIVE

      USE ( cPatArt() + "ArtCodebar.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CODEBAR", @dbfCodebar ) )
      SET ADSINDEX TO ( cPatArt() + "ArtCodebar.Cdx" ) ADDITIVE

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

      USE ( cPatGrp() + "FPAGO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FPAGO", @dbfFPago ) )
      SET ADSINDEX TO ( cPatGrp() + "FPAGO.CDX" ) ADDITIVE

      USE ( cPatDat() + "DIVISAS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "DIVISAS", @dbfDiv ) )
      SET ADSINDEX TO ( cPatDat() + "DIVISAS.CDX" ) ADDITIVE

      USE ( cPatEmp() + "RDOCUMEN.DBF" ) NEW SHARED VIA ( cDriver() )ALIAS ( cCheckArea( "RDOCUMEN", @dbfDoc ) )
      SET ADSINDEX TO ( cPatEmp() + "RDOCUMEN.CDX" ) ADDITIVE
      SET TAG TO "CTIPO"

      USE ( cPatArt() + "FAMILIAS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FAMILIAS", @dbfFamilia ) )
      SET ADSINDEX TO ( cPatArt() + "FAMILIAS.CDX" ) ADDITIVE

      USE ( cPatArt() + "OFERTA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "OFERTA", @dbfOferta ) )
      SET ADSINDEX TO ( cPatArt() + "OFERTA.CDX" ) ADDITIVE

      USE ( cPatArt() + "ARTKIT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ARTTIK", @dbfKit ) )
      SET ADSINDEX TO ( cPatArt() + "ARTKIT.CDX" ) ADDITIVE

      USE ( cPatDat() + "TVTA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TVTA", @dbfTVta ) )
      SET ADSINDEX TO ( cPatDat() + "TVTA.CDX" ) ADDITIVE

      USE ( cPatArt() + "PRO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PRO", @dbfPro ) )
      SET ADSINDEX TO ( cPatArt() + "PRO.CDX" ) ADDITIVE

      USE ( cPatArt() + "TBLPRO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TBLPRO", @dbfTblPro ) )
      SET ADSINDEX TO ( cPatArt() + "TBLPRO.CDX" ) ADDITIVE

      USE ( cPatCli() + "ObrasT.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "OBRAS", @dbfObrasT ) )
      SET ADSINDEX TO ( cPatCli() + "ObrasT.Cdx" ) ADDITIVE

      USE ( cPatCli() + "RUTA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "RUTA", @dbfRuta ) )
      SET ADSINDEX TO ( cPatCli() + "RUTA.CDX" ) ADDITIVE

      USE ( cPatArt() + "ARTDIV.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ARTDIV", @dbfArtDiv ) )
      SET ADSINDEX TO ( cPatArt() + "ARTDIV.CDX" ) ADDITIVE

      USE ( cPatDat() + "TBLCNV.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TBLCNV", @dbfTblCnv ) )
      SET ADSINDEX TO ( cPatDat() + "TBLCNV.CDX" ) ADDITIVE

      USE ( cPatDat() + "Cajas.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CAJAS", @dbfCajT ) )
      SET ADSINDEX TO ( cPatDat() + "Cajas.Cdx" ) ADDITIVE

      USE ( cPatAlm() + "Almacen.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALMACEN", @dbfAlm ) )
      SET ADSINDEX TO ( cPatAlm() + "Almacen.Cdx" ) ADDITIVE

      USE ( cPatDat() + "USERS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "USERS", @dbfUsr ) )
      SET ADSINDEX TO ( cPatDat() + "USERS.CDX" ) ADDITIVE

      USE ( cPatEmp() + "TIPINCI.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIPINCI", @dbfInci ) )
      SET ADSINDEX TO ( cPatEmp() + "TIPINCI.CDX" ) ADDITIVE

      USE ( cPatDat() + "DELEGA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "DELEGA", @dbfDelega ) )
      SET ADSINDEX TO ( cPatDat() + "DELEGA.CDX" ) ADDITIVE

      USE ( cPatDat() + "CNFFLT.DBF" ) NEW SHARED VIA ( cDriver() )ALIAS ( cCheckArea( "CNFFLT", @dbfFlt ) )
      SET ADSINDEX TO ( cPatDat() + "CNFFLT.CDX" ) ADDITIVE

      USE ( cPatGrp() + "AGECOM.DBF" ) NEW SHARED VIA ( cDriver() )ALIAS ( cCheckArea( "AGECOM", @dbfAgeCom ) )
      SET ADSINDEX TO ( cPatGrp() + "AGECOM.CDX" ) ADDITIVE

      USE ( cPatEmp() + "NCOUNT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "NCOUNT", @dbfCount ) )
      SET ADSINDEX TO ( cPatEmp() + "NCOUNT.CDX" ) ADDITIVE

      USE ( cPatDat() + "Empresa.DBF" ) NEW SHARED VIA ( cDriver() )ALIAS ( cCheckArea( "Empresa", @dbfEmp ) )
      SET ADSINDEX TO ( cPatDat() + "Empresa.CDX" ) ADDITIVE

      USE ( cPatEmp() + "PedProvL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PedProvL", @dbfPedPrvL ) )
      SET ADSINDEX TO ( cPatEmp() + "PedProvL.CDX" ) ADDITIVE

      USE ( cPatEmp() + "AlbProvL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "AlbPROVL", @dbfAlbPrvL ) )
      SET ADSINDEX TO ( cPatEmp() + "AlbProvL.CDX" ) ADDITIVE
      SET TAG TO "cStkFast"

      USE ( cPatEmp() + "FACPRVL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACPRVL", @dbfFacPrvL ) )
      SET ADSINDEX TO ( cPatEmp() + "FACPRVL.CDX" ) ADDITIVE
      SET TAG TO "cRef"

      USE ( cPatEmp() + "RctPrvL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "RctPrvL", @dbfRctPrvL ) )
      SET ADSINDEX TO ( cPatEmp() + "RctPrvL.CDX" ) ADDITIVE
      SET TAG TO "cRef"

      USE ( cPatEmp() + "PedCliL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PedCliL", @dbfPedCliL ) )
      SET ADSINDEX TO ( cPatEmp() + "PedCliL.CDX" ) ADDITIVE

      USE ( cPatEmp() + "PreCLIL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PreCLIL", @dbfPreCliL ) )
      SET ADSINDEX TO ( cPatEmp() + "PreCLIL.CDX" ) ADDITIVE
      SET TAG TO "cStkFast"

      USE ( cPatEmp() + "FACCLIL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACCLIL", @dbfFacCliL ) )
      SET ADSINDEX TO ( cPatEmp() + "FACCLIL.CDX" ) ADDITIVE
      SET TAG TO "cRef"

      USE ( cPatEmp() + "FacRecL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FacRecL", @dbfFacRecL ) )
      SET ADSINDEX TO ( cPatEmp() + "FacRecL.CDX" ) ADDITIVE
      SET TAG TO "cRef"

      USE ( cPatEmp() + "TIKET.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIKET", @dbfTikCliT ) )
      SET ADSINDEX TO ( cPatEmp() + "TIKET.CDX" ) ADDITIVE

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

      USE ( cPatDat() + "SITUA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "SITUA", @dbfSitua ) )
      SET ADSINDEX TO ( cPatDat() + "SITUA.CDX" ) ADDITIVE

      USE ( cPatEmp() + "AntCliT.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "AntCliT", @dbfAntCliT ) )
      SET ADSINDEX TO ( cPatEmp() + "AntCliT.Cdx" ) ADDITIVE

      if !TDataCenter():OpenSatCliT( @dbfSatCliT )
         lOpenFiles     := .f.
      end if

      if !TDataCenter():OpenFacCliP( @dbfFacCliP )
         lOpenFiles     := .f.
      end if

      oBandera          := TBandera():New()

      oStock            := TStock():Create( cPatGrp() )
      if !oStock:lOpenFiles()
         lOpenFiles     := .f.
      end if

      oNewImp           := TNewImp():New( cPatEmp() )
      if !oNewImp:OpenFiles()
         lOpenFiles     := .f.
      end if

      oTrans            := TTrans():New( cPatCli() )
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

      oFraPub           := TFrasesPublicitarias():Create( cPatArt() )
      if !oFraPub:OpenFiles()
         lOpenFiles     := .f.
      end if

      // Unidades de medicion

      oUndMedicion      := UniMedicion():Create( cPatGrp() )
      if !oUndMedicion:OpenFiles()
         lOpenFiles     := .f.
      end if

      /*
      Recursos y fuente--------------------------------------------------------
      */

      oFont             := TFont():New( "Arial", 8, 26, .F., .T. )

      /*
      Declaración variables públicas-------------------------------------------
      */

      public nTotSat    := 0
      public nTotDto    := 0
      public nTotDPP    := 0
      public nTotNet    := 0
      public nTotIvm    := 0
      public nTotIva    := 0
      public nTotReq    := 0
      public nTotAge    := 0
      public nTotUno    := 0
      public nTotDos    := 0
      public nTotPnt    := 0
      public nTotTrn    := 0
      public nTotCos    := 0
      public nTotAtp    := 0
      public nTotPes    := 0
      public nPctRnt    := 0
      public nTotRnt    := 0
      public nTotDif    := 0
      public nTotUnd    := 0

      public aTotIva    := { { 0,0,nil,0,0,0,0,0,0 }, { 0,0,nil,0,0,0,0,0,0 }, { 0,0,nil,0,0,0,0,0,0 } }
      public aIvaUno    := aTotIva[ 1 ]
      public aIvaDos    := aTotIva[ 2 ]
      public aIvaTre    := aTotIva[ 3 ]

      public aTotIvm    := { { 0,nil,0 }, { 0,nil,0 }, { 0,nil,0 }, }
      public aIvmUno    := aTotIvm[ 1 ]
      public aIvmDos    := aTotIvm[ 2 ]
      public aIvmTre    := aTotIvm[ 3 ]

      public aImpVto    := {}
      public aDatVto    := {}

      public nNumArt    := 0
      public nNumCaj    := 0

      /*
      Limitaciones de cajero y cajas--------------------------------------------------------
      */

      if lAIS() .and. !oUser():lAdministrador()
      
         cFiltroUsuario    := "Field->cSufPre == '" + oUser():cDelegacion() + "' .and. Field->cCodCaj == '" + oUser():cCaja() + "'"
         if oUser():lFiltroVentas()         
            cFiltroUsuario += " .and. Field->cCodUsr == '" + oUser():cCodigo() + "'"
         end if 

         ( dbfSatCliT )->( AdsSetAOF( cFiltroUsuario ) )

      end if

      EnableAcceso()

   RECOVER USING oError

      lOpenFiles     := .f.

      msgStop( "Imposible abrir todas las bases de datos" + CRLF + ErrorMessage( oError ) )

      EnableAcceso()

   END SEQUENCE

   ErrorBlock( oBlock )

   if !lOpenFiles
      CloseFiles()
   end if

RETURN ( lOpenFiles )

//----------------------------------------------------------------------------//

STATIC FUNCTION CloseFiles()

   DisableAcceso()

   DestroyFastFilter( dbfSatCliT, .t., .t. )

   if !Empty( oFont )
      oFont:end()
   end if

   if ( dbfSatCliT ) != nil
      ( dbfSatCliT )->( dbCloseArea() )
   end if

   if !Empty( dbfSatCliL   )
      ( dbfSatCliL   )->( dbCloseArea() )
   end if

   if !Empty( dbfSatCliI   )
      ( dbfSatCliI   )->( dbCloseArea() )
   end if

   if !Empty( dbfSatCliD   )
      ( dbfSatCliD   )->( dbCloseArea() )
   end if

   if !Empty( dbfSatCliS   )
      ( dbfSatCliS   )->( dbCloseArea() )
   end if

   if !Empty( dbfClient )
      ( dbfClient    )->( dbCloseArea() )
   end if

   if !Empty( dbfIva )
      ( dbfIva       )->( dbCloseArea() )
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

   if !Empty( dbfAgent )
      ( dbfAgent     )->( dbCloseArea() )
   end if

   if !Empty( dbfArticulo )
      ( dbfArticulo  )->( dbCloseArea() )
   end if

   if dbfCodebar != nil
      ( dbfCodebar )->( dbCloseArea() )
   end if

   if !Empty( dbfCliAtp )
      ( dbfCliAtp    )->( dbCloseArea() )
   end if

   if !Empty( dbfFPago )
      ( dbfFPago     )->( dbCloseArea() )
   end if

   if !Empty( dbfDiv )
      ( dbfDiv       )->( dbCloseArea() )
   end if

   if !Empty( dbfDoc )
      ( dbfDoc       )->( dbCloseArea() )
   end if

   if !Empty( dbfFamilia )
      ( dbfFamilia   )->( dbCloseArea() )
   end if

   if !Empty( dbfOferta )
      ( dbfOferta    )->( dbCloseArea() )
   end if

   if !Empty( dbfKit )
      ( dbfKit       )->( dbCloseArea() )
   end if

   if !Empty( dbfTVta )
      ( dbfTVta      )->( dbCloseArea() )
   end if

   if !Empty( dbfPro )
      ( dbfPro       )->( dbCloseArea() )
   end if

   if !Empty( dbfTblPro )
      ( dbfTblPro    )->( dbCloseArea() )
   end if

   if !Empty( dbfObrasT )
      ( dbfObrasT    )->( dbCloseArea() )
   end if

   if !Empty( dbfRuta )
      ( dbfRuta      )->( dbCloseArea() )
   end if

   if !Empty( dbfArtDiv )
      ( dbfArtDiv    )->( dbCloseArea() )
   end if

   if !Empty( dbfTblCnv )
      ( dbfTblCnv    )->( dbCloseArea() )
   end if

   if !Empty( dbfCajT )
      ( dbfCajT )->( dbCloseArea() )
   end if

   if !Empty( dbfAlm )
      ( dbfAlm )->( dbCloseArea() )
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

   if dbfDelega != nil
      ( dbfDelega )->( dbCloseArea() )
   end if

   if dbfAgeCom != nil
      ( dbfAgeCom )->( dbCloseArea() )
   end if

   if dbfFlt != nil
      ( dbfFlt )->( dbCloseArea() )
   end if

   if dbfCount != nil
      ( dbfCount )->( dbCloseArea() )
   end if

   if dbfEmp != nil
      ( dbfEmp )->( dbCloseArea() )
   end if

   if dbfPedPrvL != nil
      ( dbfPedPrvL )->( dbCloseArea() )
   end if

   if dbfAlbPrvL != nil
      ( dbfAlbPrvL )->( dbCloseArea() )
   end if

   if dbfFacPrvL != nil
      ( dbfFacPrvL )->( dbCloseArea() )
   end if

   if dbfRctPrvL != nil
      ( dbfRctPrvL )->( dbCloseArea() )
   end if

   if dbfPedCliL != nil
      ( dbfPedCliL )->( dbCloseArea() )
   end if

   if dbfPreCliL != nil
      ( dbfPreCliL )->( dbCloseArea() )
   end if

   if dbfFacCliL != nil
      ( dbfFacCliL )->( dbCloseArea() )
   end if

   if dbfFacRecL != nil
      ( dbfFacRecL )->( dbCloseArea() )
   end if

   if dbfTikCliT != nil
      ( dbfTikCliT )->( dbCloseArea() )
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

   if dbfCliInc != nil
      ( dbfCliInc )->( dbCloseArea() )
   end if

   if dbfSitua != nil
      ( dbfSitua )->( dbCloseArea() )
   end if

   if dbfFacCliP != nil
      ( dbfFacCliP )->( dbCloseArea() )
   end if

   if dbfAntCliT != nil
      ( dbfAntCliT )->( dbCloseArea() )
   end if

   if !Empty( oNewImp )
      oNewImp:End()
   end if

   if !Empty( oTrans )
      oTrans:End()
   end if

   if !Empty( oStock )
      oStock:end()
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

   dbfSatCliT     := nil
   dbfSatCliL     := nil
   dbfSatCliI     := nil
   dbfSatCliD     := nil
   dbfClient      := nil
   dbfArtPrv      := nil
   dbfIva         := nil
   dbfTarPreL     := nil
   dbfTarPreS     := nil
   dbfPromoT      := nil
   dbfPromoL      := nil
   dbfPromoC      := nil
   dbfAgent       := nil
   dbfArticulo    := nil
   dbfCodebar     := nil
   dbfCliAtp      := nil
   dbfFpago       := nil
   dbfDiv         := nil
   dbfDoc         := nil
   dbfFamilia     := nil
   dbfOferta      := nil
   dbfKit         := nil
   dbfTVta        := nil
   dbfPro         := nil
   dbfTblPro      := nil
   dbfObrasT      := nil
   dbfRuta        := nil
   dbfArtDiv      := nil
   dbfTblCnv      := nil
   dbfCajT        := nil
   dbfUsr         := nil
   dbfDelega      := nil
   dbfCount       := nil
   oBandera       := nil
   oNewImp        := nil
   oTrans         := nil
   oStock         := nil
   oTipArt        := nil
   oGrpFam        := nil
   dbfInci        := nil
   dbfFlt         := nil
   dbfAgeCom      := nil
   dbfEmp         := nil

   dbfPedPrvL     := nil
   dbfAlbPrvL     := nil
   dbfFacPrvL     := nil
   dbfFacPrvL     := nil

   dbfPedCliL     := nil
   dbfPedCliL     := nil
   dbfFacCliL     := nil
   dbfFacRecL     := nil
   dbfTikCliL     := nil

   dbfProLin      := nil
   dbfProMat      := nil
   dbfHisMov      := nil
   dbfCliInc      := nil

   lOpenFiles     := .f.

   oWndBrw        := nil

   EnableAcceso()

RETURN .T.

//----------------------------------------------------------------------------//

FUNCTION SatCli( oMenuItem, oWnd, cCodCli, cCodArt )

   local oSnd
   local oRpl
   local oImp
   local oPrv
   local oDel
   local oPdf
   local oMail
   local oDup
   local oBtnEur
   local nLevel
   local lEuro          := .f.
   local oRotor

   DEFAULT oMenuItem    := _MENUITEM_
   DEFAULT oWnd         := oWnd()
   DEFAULT cCodCli      := ""
   DEFAULT cCodArt      := ""

   nLevel               := nLevelUsr( oMenuItem )
   if nAnd( nLevel, 1 ) != 0
      msgStop( "Acceso no permitido." )
      return .f.
   end if

   /*
   Cerramos todas las ventanas-------------------------------------------------
   */

   if oWnd != nil
      SysRefresh(); oWnd:CloseAll(); SysRefresh()
   end if

   if !OpenFiles()
      return .f.
   end if

   /*
   Anotamos el movimiento para el navegador------------------------------------
   */

   DisableAcceso()

   DEFINE SHELL oWndBrw FROM 0, 0 TO 22, 80 ;
      XBROWSE ;
      TITLE    "S.A.T. a clientes" ;
      PROMPT   "Número",;
               "Fecha",;
               "Código",;
               "Nombre",;
               "Obra",;
               "Agente";
      MRU      "Power-drill_user1_16";
      BITMAP   clrTopArchivos ;
      ALIAS    ( dbfSatCliT );
      APPEND   ( WinAppRec( oWndBrw:oBrw, bEdtRec, dbfSatCliT, cCodCli, cCodArt ) );
      DUPLICAT ( WinDupRec( oWndBrw:oBrw, bEdtRec, dbfSatCliT, cCodCli, cCodArt ) );
      EDIT     ( WinEdtRec( oWndBrw:oBrw, bEdtRec, dbfSatCliT, cCodCli, cCodArt ) );
      ZOOM     ( WinZooRec( oWndBrw:oBrw, bEdtRec, dbfSatCliT ) );
      DELETE   ( WinDelRec( oWndBrw:oBrw, dbfSatCliT, {|| QuiSatCli() } ) ) ;
      LEVEL    nLevel ;
      OF       oWnd

     oWndBrw:lFechado     := .t.

     oWndBrw:bChgIndex    := {|| if( oUser():lFiltroVentas(), CreateFastFilter( cFiltroUsuario, dbfSatCliT, .f., , cFiltroUsuario ), CreateFastFilter( "", dbfSatCliT, .f. ) ) }

     oWndBrw:SetYearComboBoxChange( {|| YearComboBoxChange() } )

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Sesión cerrada"
         :nHeadBmpNo       := 3
         :bStrData         := {|| "" }
         :bEditValue       := {|| ( dbfSatCliT )->lCloSat }
         :nWidth           := 20
         :SetCheck( { "Sel16", "Nil16" } )
         :AddResource( "Zoom16" )

      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Estado"
         :nHeadBmpNo       := 3
         :bStrData         := {|| "" }
         :bEditValue       := {|| ( dbfSatCliT )->lEstado }
         :nWidth           := 20
         :SetCheck( { "Bullet_Square_Green_16", "Bullet_Square_Red_16" } )
         :AddResource( "Trafficlight_on_16" )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Envio"
         :nHeadBmpNo       := 3
         :bStrData         := {|| "" }
         :bEditValue       := {|| ( dbfSatCliT )->lSndDoc }
         :nWidth           := 20
         :SetCheck( { "Sel16", "Nil16" } )
         :AddResource( "Lbl16" )

      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Incidencia"
         :nHeadBmpNo       := 4
         :bStrData         := {|| "" }
         :bBmpData         := {|| nEstadoIncidencia( ( dbfSatCliT )->cSerSat + Str( ( dbfSatCliT )->nNumSat ) + ( dbfSatCliT )->cSufSat ) }
         :nWidth           := 20
         :lHide            := .t.
         :AddResource( "Bullet_Square_Red_16" )
         :AddResource( "Bullet_Square_Yellow_16" )
         :AddResource( "Bullet_Square_Green_16" )
         :AddResource( "informacion_16" )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Imprimir"
         :nHeadBmpNo       := 3
         :bStrData         := {|| "" }
         :bEditValue       := {|| ( dbfSatCliT )->lImprimido }
         :nWidth           := 20
         :lHide            := .t.
         :SetCheck( { "Sel16", "Nil16" } )
         :AddResource( "IMP16" )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Número"
         :cSortOrder       := "nNumSat"
         :bEditValue       := {|| ( dbfSatCliT )->cSerSat + "/" + AllTrim( Str( ( dbfSatCliT )->nNumSat ) ) }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Delegación"
         :bEditValue       := {|| ( dbfSatCliT )->cCodDlg }
         :nWidth           := 40
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Sesión"
         :bEditValue       := {|| Trans( ( dbfSatCliT )->cTurSat, "######" ) }
         :nWidth           := 40
         :lHide            := .t.
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Fecha"
         :cSortOrder       := "dFecSat"
         :bEditValue       := {|| Dtoc( ( dbfSatCliT )->dFecSat ) }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Caja"
         :bEditValue       := {|| ( dbfSatCliT )->cCodCaj }
         :nWidth           := 40
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Usuario"
         :bEditValue       := {|| ( dbfSatCliT )->cCodUsr }
         :nWidth           := 40
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Situación"
         :bEditValue       := {|| AllTrim( ( dbfSatCliT )->cSituac ) }
         :nWidth           := 80
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Código"
         :cSortOrder       := "cCodCli"
         :bEditValue       := {|| AllTrim( ( dbfSatCliT )->cCodCli ) }
         :nWidth           := 70
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Nombre"
         :cSortOrder       := "cNomCli"
         :bEditValue       := {|| ( dbfSatCliT )->cNomCli }
         :nWidth           := 180
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Agente"
         :cSortOrder       := "cCodAge"
         :bEditValue       := {|| ( dbfSatCliT )->cCodAge }
         :nWidth           := 50
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Ruta"
         :bEditValue       := {|| ( dbfSatCliT )->cCodRut }
         :nWidth           := 40
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Almacén"
         :bEditValue       := {|| ( dbfSatCliT )->cCodAlm }
         :nWidth           := 60
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Obra"
         :cSortOrder       := "cCodObr"
         :bEditValue       := {|| ( dbfSatCliT )->cCodObr }
         :nWidth           := 50
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Base"
         :bEditValue       := {|| ( dbfSatCliT )->nTotNet }
         :cEditPicture     := cPorDiv( ( dbfSatCliT )->cDivSat, dbfDiv )
         :nWidth           := 80
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := cImp()
         :bEditValue       := {|| ( dbfSatCliT )->nTotIva }
         :cEditPicture     := cPorDiv( ( dbfSatCliT )->cDivSat, dbfDiv )
         :nWidth           := 80
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "R.E."
         :bEditValue       := {|| ( dbfSatCliT )->nTotReq }
         :cEditPicture     := cPorDiv( ( dbfSatCliT )->cDivSat, dbfDiv )
         :nWidth           := 80
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Total"
         :bEditValue       := {|| ( dbfSatCliT )->nTotSat }
         :cEditPicture     := cPorDiv( ( dbfSatCliT )->cDivSat, dbfDiv )
         :nWidth           := 80
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Div."
         :bEditValue       := {|| cSimDiv( if( lEuro, cDivChg(), ( dbfSatCliT )->cDivSat ), dbfDiv ) }
         :nWidth           := 30
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
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
      TOOLTIP  "(A)ñadir";
      BEGIN GROUP;
      HOTKEY   "A";
      LEVEL    ACC_APPD

   DEFINE BTNSHELL oDup RESOURCE "DUP" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( oWndBrw:RecDup() );
      MENU     This:Toggle() ;
      TOOLTIP  "(D)uplicar";
      HOTKEY   "D";
      LEVEL    ACC_APPD

      DEFINE BTNSHELL RESOURCE "Dup" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( DupSerie( oWndBrw ) );
         TOOLTIP  "Series" ;
         FROM     oDup ;
         CLOSED ;
         LEVEL    ACC_APPD

   DEFINE BTNSHELL RESOURCE "EDIT" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( oWndBrw:RecEdit() );
      TOOLTIP  "(M)odificar";
      HOTKEY   "M" ;
      LEVEL    ACC_EDIT

   DEFINE BTNSHELL RESOURCE "ZOOM" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( oWndBrw:RecZoom() );
      TOOLTIP  "(Z)oom";
      HOTKEY   "Z" ;
      LEVEL    ACC_ZOOM

   DEFINE BTNSHELL oDel RESOURCE "DEL" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( oWndBrw:RecDel() );
      MENU     This:Toggle() ;
      TOOLTIP  "(E)liminar";
      HOTKEY   "E";
      LEVEL    ACC_DELE

   DEFINE BTNSHELL oPrv RESOURCE "IMP" GROUP OF oWndBrw ;
      NOBORDER ;
      ACTION   ( GenSatCli( IS_PRINTER ), oWndBrw:Refresh() ) ;
      MENU     This:Toggle() ;
      TOOLTIP  "(I)mprimir";
      MESSAGE  "Imprimir pedidos" ;
      HOTKEY   "I";
      LEVEL    ACC_IMPR

      lGenSatCli( oWndBrw:oBrw, oPrv, IS_PRINTER ) ;

   DEFINE BTNSHELL RESOURCE "SERIE1" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( PrnSerie( oWndBrw:oBrw ), oWndBrw:Refresh() ) ;
      TOOLTIP  "Imp(r)imir series";
      HOTKEY   "R";
      LEVEL    ACC_IMPR

   DEFINE BTNSHELL oImp RESOURCE "PREV1" GROUP OF oWndBrw ;
      NOBORDER ;
      MENU     This:Toggle() ;
      ACTION   ( GenSatCli( IS_SCREEN ), oWndBrw:Refresh() ) ;
      TOOLTIP  "(P)revisualizar";
      MESSAGE  "Satvisualizar pedidos" ;
      HOTKEY   "P";
      LEVEL    ACC_IMPR

      lGenSatCli( oWndBrw:oBrw, oImp, IS_SCREEN ) ;

   DEFINE BTNSHELL oPdf RESOURCE "DOCLOCK" OF oWndBrw ;
      NOBORDER ;
      MENU     This:Toggle() ;
      ACTION   ( GenSatCli( IS_PDF ) ) ;
      TOOLTIP  "Pd(f)";
      HOTKEY   "F";
      LEVEL    ACC_IMPR

      lGenSatCli( oWndBrw:oBrw, oPdf, IS_PDF ) ;

   DEFINE BTNSHELL oMail RESOURCE "Mail" OF oWndBrw ;
      NOBORDER ;
      MENU     This:Toggle() ;
      ACTION   ( GenSatCli( IS_MAIL ) ) ;
      TOOLTIP  "Correo electrónico";
      LEVEL    ACC_IMPR

      lGenSatCli( oWndBrw:oBrw, oMail, IS_MAIL ) ;

   if oUser():lAdministrador()

      DEFINE BTNSHELL RESOURCE "CHGSTATE" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( ChgState( oWndBrw:oBrw ) ) ;
         TOOLTIP  "Cambiar Es(t)ado" ;
         HOTKEY   "T";
         LEVEL    ACC_EDIT

   end if

   DEFINE BTNSHELL oSnd RESOURCE "LBL" GROUP OF oWndBrw ;
      NOBORDER ;
      MENU     This:Toggle() ;
      TOOLTIP  "En(v)iar" ;
      MESSAGE  "Seleccionar S.A.T. para ser enviados" ;
      ACTION   lSnd( oWndBrw, dbfSatCliT ) ;
      HOTKEY   "V";
      LEVEL    ACC_EDIT

      DEFINE BTNSHELL RESOURCE "LBL" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( lSelectAll( oWndBrw, dbfSatCliT, "lSndDoc", .t., .t., .t. ) );
         TOOLTIP  "Todos" ;
         FROM     oSnd ;
         CLOSED ;
         LEVEL    ACC_EDIT

      DEFINE BTNSHELL RESOURCE "LBL" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( lSelectAll( oWndBrw, dbfSatCliT, "lSndDoc", .f., .t., .t. ) );
         TOOLTIP  "Ninguno" ;
         FROM     oSnd ;
         CLOSED ;
         LEVEL    ACC_EDIT

      DEFINE BTNSHELL RESOURCE "LBL" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( lSelectAll( oWndBrw, dbfSatCliT, "lSndDoc", .t., .f., .t. ) );
         TOOLTIP  "Abajo" ;
         FROM     oSnd ;
         CLOSED ;
         LEVEL    ACC_EDIT

   DEFINE BTNSHELL oBtnEur RESOURCE "BAL_EURO" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( lEuro := !lEuro, oWndBrw:Refresh() ) ;
      TOOLTIP  "M(o)neda";
      HOTKEY   "O";

   if oUser():lAdministrador()

      DEFINE BTNSHELL oRpl RESOURCE "BMPCHG" GROUP OF oWndBrw ;
         NOBORDER ;
         MENU     This:Toggle() ;
         ACTION   ( TDlgFlt():New( aItmSatCli(), dbfSatCliT ):ChgFields(), oWndBrw:Refresh() ) ;
         TOOLTIP  "Cambiar campos" ;
         LEVEL    ACC_EDIT

         DEFINE BTNSHELL RESOURCE "BMPCHG" OF oWndBrw ;
            NOBORDER ;
            ACTION   ( TDlgFlt():New( aColSatCli(), dbfSatCliL ):ChgFields(), oWndBrw:Refresh() ) ;
            TOOLTIP  "Lineas" ;
            FROM     oRpl ;
            CLOSED ;
            LEVEL    ACC_EDIT

   end if

   DEFINE BTNSHELL RESOURCE "INFO" GROUP OF oWndBrw ;
      NOBORDER ;
      ACTION   ( TTrazaDocumento():Activate( SAT_CLI, ( dbfSatCliT )->cSerSat + Str( ( dbfSatCliT )->nNumSat ) + ( dbfSatCliT )->cSufSat ) ) ;
      TOOLTIP  "I(n)forme documento" ;
      HOTKEY   "N" ;
      LEVEL    ACC_EDIT

   DEFINE BTNSHELL oRotor RESOURCE "ROTOR" GROUP OF oWndBrw ;
         NOBORDER ;
         MENU     This:Toggle() ;
         ACTION   ( oRotor:Expand() ) ;
         TOOLTIP  "Rotor" ;

      DEFINE BTNSHELL RESOURCE "USER1_" OF oWndBrw ;
            ACTION   ( EdtCli( ( dbfSatCliT )->cCodCli ) );
            TOOLTIP  "Modificar cliente" ;
            FROM     oRotor ;

      DEFINE BTNSHELL RESOURCE "INFO" OF oWndBrw ;
            ACTION   ( InfCliente( ( dbfSatCliT )->cCodCli ) ); 
            TOOLTIP  "Informe de cliente" ;
            FROM     oRotor ;

      DEFINE BTNSHELL RESOURCE "Worker" OF oWndBrw ;
            ACTION   ( if( !Empty( ( dbfSatCliT )->cCodObr ), EdtObras( ( dbfSatCliT )->cCodCli, ( dbfSatCliT )->cCodObr, dbfObrasT ), MsgStop( "No hay obra asociada al S.A.T." ) ) );
            TOOLTIP  "Modificar obra" ;
            FROM     oRotor ;

      DEFINE BTNSHELL RESOURCE "DOCUMENT_PLAIN_USER1_" OF oWndBrw ;
            ALLOW    EXIT ;
            ACTION   ( if( !( dbfSatCliT )->lEstado, AlbCli( nil, nil, { "SAT" => ( dbfSatCliT )->cSerSat + Str( ( dbfSatCliT )->nNumSat ) + ( dbfSatCliT )->cSufSat } ), MsgStop( "El S.A.T. ya ha sido aceptado" ) ) );
            TOOLTIP  "Generar albarán" ;
            FROM     oRotor ;

      DEFINE BTNSHELL RESOURCE "DOCUMENT_USER1_" OF oWndBrw ;
            ALLOW    EXIT ;
            ACTION   ( if( !( dbfSatCliT )->lEstado, FactCli( nil, nil, nil, nil, nil, { nil, nil, nil, ( dbfSatCliT )->cSerSat + Str( ( dbfSatCliT )->nNumSat ) + ( dbfSatCliT )->cSufSat } ), MsgStop( "El S.A.T. ya ha sido aceptado" ) ) );
            TOOLTIP  "Generar factura" ;
            FROM     oRotor ;

   DEFINE BTNSHELL RESOURCE "END" GROUP OF oWndBrw ;
      NOBORDER ;
      ACTION   ( oWndBrw:End() ) ;
      TOOLTIP  "(S)alir";
      HOTKEY   "S"

   if !oUser():lFiltroVentas()
      oWndBrw:oActiveFilter:aTField       := aItmSatCli()
      oWndBrw:oActiveFilter:cDbfFilter    := dbfFlt
      oWndBrw:oActiveFilter:cTipFilter    := SAT_CLI
   end if

   ACTIVATE WINDOW oWndBrw VALID ( CloseFiles() )

   EnableAcceso()

   if !Empty( cCodCli ) .or. !Empty( cCodArt )
      oWndBrw:RecAdd()
      cCodCli  := nil
      cCodArt  := nil
   end if

Return .t.

//----------------------------------------------------------------------------//

STATIC FUNCTION EdtRec( aTmp, aGet, dbfSatCliT, oBrw, cCodCli, cCodArt, nMode )

   local oDlg
   local oFld
   local nOrd
   local oBrwLin
   local oBrwInc
   local oBrwDoc
   local oSay           := Array( 11 )
   local cSay           := Array( 11 )
   local oSayLabels     := Array( 10 )
   local oGetMasDiv
   local cGetMasDiv     := ""
   local oBmpEmp
   local oBmpDiv
   local oBtnKit
   local oRieCli
   local nRieCli
   local oTlfCli
   local cTlfCli
   local cSerie         := cNewSer( "nSatCli", dbfCount )
   local oAprovado
   local cAprovado
   local oSayGetRnt
   local cTipSat
   local oSayDias
   local oBmpGeneral

   /*
   Este valor los guaradamos para detectar los posibles cambios----------------
   */

   cOldCodCli           := aTmp[_CCODCLI]
   cOldSituacion        := aTmp[ _CSITUAC ]

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

      aTmp[ _CTURSAT ]  := cCurSesion()
      aTmp[ _CCODALM ]  := oUser():cAlmacen()
      aTmp[ _CDIVSAT ]  := cDivEmp()
      aTmp[ _CCODCAJ ]  := oUser():cCaja()
      aTmp[ _CCODPGO ]  := cDefFpg()
      aTmp[ _CCODUSR ]  := cCurUsr()
      aTmp[ _NVDVSAT ]  := nChgDiv( aTmp[ _CDIVSAT ], dbfDiv )
      aTmp[ _LESTADO ]  := .f.
      aTmp[ _CSUFSAT ]  := RetSufEmp()
      aTmp[ _NDIAVAL ]  := nDiasValidez()
      aTmp[ _LSNDDOC ]  := .t.
      aTmp[ _CCODDLG ]  := oUser():cDelegacion()
      aTmp[ _LIVAINC ]  := uFieldEmpresa( "lIvaInc" )
      aTmp[ _CMANOBR ]  := Padr( "Gastos", 250 )
      aTmp[ _NIVAMAN ]  := nIva( dbfIva, cDefIva() )

      if !Empty( cCodCli )
         aTmp[ _CCODCLI ]  := cCodCli
      end if

   case nMode == EDIT_MODE

      if aTmp[ _LCLOSAT ] .and. !oUser():lAdministrador()
         msgStop( "El S.A.T. está cerrado." )
         Return .f.
      end if

   case nMode == DUPL_MODE

      if !lCurSesion()
         MsgStop( "No hay sesiones activas, imposible añadir documentos" )
         Return .f.
      end if

      if !lCajaOpen( oUser():cCaja() ) .and. !oUser():lAdministrador()
         msgStop( "Esta caja " + oUser():cCaja() + " esta cerrada." )
         Return .f.
      end if

      aTmp[ _DFECSAT ]  := GetSysDate()
      aTmp[ _CTURSAT ]  := cCurSesion()
      aTmp[ _LESTADO ]  := .f.
      aTmp[ _LCLOSAT ]  := .f.

   end case

   if Empty( Rtrim( aTmp[ _CSERSAT ] ) )
      aTmp[ _CSERSAT ]  := cSerie
   end if

   if Empty( aTmp[ _NTARIFA ] )
      aTmp[ _NTARIFA ]  := Max( uFieldEmpresa( "nPreVta" ), 1 )
   end if

   if Empty( aTmp[ _CDTOESP ] )
      aTmp[ _CDTOESP ]  := Padr( "General", 50 )
   end if

   if Empty( aTmp[ _CDPP ] )
      aTmp[ _CDPP ]     := Padr( "Pronto pago", 50 )
   end if

   /*
   Comineza la transaccion-----------------------------------------------------
   */

   if BeginTrans( aTmp )
      Return .f.
   end if

   cAprovado            := if( aTmp[ _LESTADO ], "Aprobado", "" )

   /*
   Mostramos datos de clientes-------------------------------------------------
   */

   if Empty( aTmp[ _CTLFCLI ] )
      aTmp[ _CTLFCLI ]  := RetFld( aTmp[ _CCODCLI ], dbfClient, "Telefono" )
   end if

   /*
   Necestamos el orden el la primera clave-------------------------------------
   */

   nOrd                 := ( dbfSatCliT )->( ordSetFocus( 1 ) )

   cPicUnd              := MasUnd()
   cPouDiv              := cPouDiv( aTmp[ _CDIVSAT ], dbfDiv ) // Picture de la divisa
   cPorDiv              := cPorDiv( aTmp[ _CDIVSAT ], dbfDiv ) // Picture de la divisa
   nDouDiv              := nDouDiv( aTmp[ _CDIVSAT ], dbfDiv )
   nRouDiv              := nRouDiv( aTmp[ _CDIVSAT ], dbfDiv )

   /*
   Etiquetas-------------------------------------------------------------------
   */

   cSay[ 2 ]            := RetFld( aTmp[ _CCODTAR ], dbfTarPreS )
   cSay[ 3 ]            := RetFld( aTmp[ _CCODCLI ] + aTmp[ _CCODOBR ], dbfObrasT, "cNomObr" )
   cSay[ 4 ]            := RetFld( aTmp[ _CCODALM ], dbfAlm )
   cSay[ 5 ]            := RetFld( aTmp[ _CCODPGO ], dbfFPago )
   cSay[ 6 ]            := RetFld( aTmp[ _CCODAGE ], dbfAgent )
   cSay[ 7 ]            := RetFld( aTmp[ _CCODRUT ], dbfRuta )
   cSay[ 8 ]            := oTrans:cNombre( aTmp[ _CCODTRN ] )
   cSay[ 9 ]            := RetFld( aTmp[ _CCODCAJ ], dbfCajT )
   cSay[10 ]            := RetFld( aTmp[ _CCODUSR ], dbfUsr, "cNbrUse" )
   cSay[11 ]            := RetFld( cCodEmp() + aTmp[ _CCODDLG ], dbfDelega, "cNomDlg" )

   cTlfCli              := RetFld( aTmp[ _CCODCLI ], dbfClient, "Telefono" )

   nRieCli              := oStock:nRiesgo( aTmp[ _CCODCLI ] )

   /*
   Inicializamos el valor de la tarifa por si cambian--------------------------
   */

   InitTarifaCabecera( aTmp[ _NTARIFA ] )

   /*
   Comienza el dialogo---------------------------------------------------------
   */

   DEFINE DIALOG oDlg RESOURCE "PEDCLI" TITLE LblTitle( nMode ) + "S.A.T. a clientes"

      REDEFINE FOLDER oFld ;
         ID       200 ;
         OF       oDlg ;
         PROMPT   "&S.A.T.",;
                  "Da&tos",;
                  "&Incidencias",;
                  "D&ocumentos" ;
         DIALOGS  "SATCLI_1",;
                  "SATCLI_2",;
                  "PEDCLI_3",;
                  "PEDCLI_4"

      /*
      Cliente_________________________________________________________________
      */

      REDEFINE BITMAP oBmpGeneral ;
        ID       990 ;
        RESOURCE "S.A.T._cliente_48_alpha" ;
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

      REDEFINE GET aGet[_CCODCLI] VAR aTmp[_CCODCLI] ;
         ID       130 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( LoaCli( aGet, aTmp, nMode, oRieCli ), RecalculaTotal( aTmp ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwClient( aGet[_CCODCLI] ) ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[_CNOMCLI] VAR aTmp[_CNOMCLI] ;
         ID       131 ;
         WHEN     ( nMode != ZOOM_MODE .and. ( !aTmp[ _LMODCLI ] .or. oUser():lAdministrador() ) ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[_CDNICLI] VAR aTmp[_CDNICLI] ;
         ID       101 ;
         WHEN     ( nMode != ZOOM_MODE .and. ( !aTmp[ _LMODCLI ] .or. oUser():lAdministrador() ) ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CDIRCLI ] VAR aTmp[ _CDIRCLI ] ;
         ID       102 ;
         BITMAP   "Environnment_View_16" ;
         ON HELP  GoogleMaps( aTmp[ _CDIRCLI ], Rtrim( aTmp[ _CPOBCLI ] ) + Space( 1 ) + Rtrim( aTmp[ _CPRVCLI ] ) ) ;
         WHEN     ( nMode != ZOOM_MODE .and. ( !aTmp[ _LMODCLI ] .or. oUser():lAdministrador() ) ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CPOBCLI ] VAR aTmp[ _CPOBCLI ] ;
         ID       103 ;
         WHEN     ( nMode != ZOOM_MODE .and. ( !aTmp[ _LMODCLI ] .or. oUser():lAdministrador() ) ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CPRVCLI ] VAR aTmp[ _CPRVCLI ] ;
         ID       104 ;
         WHEN     ( nMode != ZOOM_MODE .and. ( !aTmp[ _LMODCLI ] .or. oUser():lAdministrador() ) ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CPOSCLI ] VAR aTmp[ _CPOSCLI ] ;
         ID       107 ;
         WHEN     ( nMode != ZOOM_MODE .and. ( !aTmp[ _LMODCLI ] .or. oUser():lAdministrador() ) ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _NTARIFA ] VAR aTmp[ _NTARIFA ];
         ID       132 ;
         SPINNER ;
         MIN      1 ;
         MAX      6 ;
         PICTURE  "9" ;
         VALID    ( ChangeTarifaCabecera( aTmp[ _NTARIFA ], dbfTmpLin, oBrwLin ) ) ;
         WHEN     ( nMode != ZOOM_MODE .and. ( lUsrMaster() .or. oUser():lCambiarPrecio() ) );
         OF       oFld:aDialogs[1]

      REDEFINE GET oRieCli VAR nRieCli;
         ID       133 ;
         WHEN     ( nMode != ZOOM_MODE );
         PICTURE  cPorDiv ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[_CTLFCLI] VAR aTmp[_CTLFCLI] ;
         ID       106 ;
         COLOR    CLR_GET ;
         WHEN     ( nMode != ZOOM_MODE .and. ( !aTmp[ _LMODCLI ] .or. oUser():lAdministrador() ) ) ;
         OF       oFld:aDialogs[1]

		/*
		Tarifa_________________________________________________________________
		*/

      REDEFINE GET aGet[_CCODTAR] VAR aTmp[_CCODTAR] ;
         ID       140 ;
         WHEN     ( nMode != ZOOM_MODE .and. oUser():lAdministrador() ) ;
         VALID    ( cTarifa( aGet[_CCODTAR], oSay[ 2 ] ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwTarifa( aGet[_CCODTAR], oSay[ 2 ] ) ) ;
         COLOR    CLR_GET ;
         OF       oFld:aDialogs[1]

      REDEFINE GET oSay[ 2 ] VAR cSay[ 2 ] ;
         WHEN     .F. ;
         ID       141 ;
         OF       oFld:aDialogs[1]

      /*
      Obra____________________________________________________________________
      */

      REDEFINE GET aGet[_CCODOBR] VAR aTmp[_CCODOBR] ;
         ID       150 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( cObras( aGet[_CCODOBR], oSay[ 3 ], aTmp[_CCODCLI], dbfObrasT ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwObras( aGet[_CCODOBR], oSay[ 3 ], aTmp[_CCODCLI], dbfObrasT ) ) ;
         COLOR    CLR_GET ;
         OF       oFld:aDialogs[1]

      REDEFINE GET oSay[ 3 ] VAR cSay[ 3 ] ;
         WHEN     .F. ;
         ID       151 ;
         OF       oFld:aDialogs[1]

      /*
      Almacen________________________________________________________________
      */

      REDEFINE GET aGet[ _CCODALM ] VAR aTmp[ _CCODALM ] ;
         ID       160 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( cAlmacen( aGet[ _CCODALM ], , oSay[ 4 ] ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwAlmacen( aGet[ _CCODALM ], oSay[ 4 ] ) ) ;
         OF       oFld:aDialogs[ 1 ]

      REDEFINE GET oSay[ 4 ] VAR cSay[ 4 ] ;
         ID       161 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         BITMAP   "Bot" ;
         ON HELP  ( ExpAlmacen( aTmp[ _CCODALM ], dbfTmpLin, oBrwLin ) ) ;
         OF       oFld:aDialogs[ 1 ]

      /*
      Forma de Pago__________________________________________________________
      */

      REDEFINE GET aGet[ _CCODPGO ] VAR aTmp[ _CCODPGO ] ;
         ID       170 ;
         PICTURE  "@!" ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( cFPago( aGet[ _CCODPGO ], dbfFPago, oSay[ 5 ] ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwFPago( aGet[ _CCODPGO ], oSay[ 5 ] ) ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET oSay[ 5 ] VAR cSay[ 5 ] ;
         WHEN     .F. ;
         ID       171 ;
         OF       oFld:aDialogs[1]

      /*
      Agente_________________________________________________________________
      */

      REDEFINE GET aGet[ _CCODAGE ] VAR aTmp[ _CCODAGE ] ;
         ID       180 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( cAgentes( aGet[ _CCODAGE ], dbfAgent, oSay[ 6 ], aGet[ _NPCTCOMAGE ], dbfAgeCom ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwAgentes( aGet[ _CCODAGE ], oSay[ 6 ] ) ) ;
         COLOR    CLR_GET ;
         OF       oFld:aDialogs[1]

      REDEFINE GET oSay[ 6 ] VAR cSay[ 6 ] ;
         ID       181 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         BITMAP   "Bot" ;
         ON HELP  ( ExpAgente( aTmp[ _CCODAGE ], aTmp[ _NPCTCOMAGE ], dbfTmpLin, oBrwLin ), RecalculaTotal( aTmp ) ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _NPCTCOMAGE ] VAR aTmp[ _NPCTCOMAGE ] ;
         WHEN     ( !Empty( aTmp[ _CCODAGE ] ) .AND. nMode != ZOOM_MODE ) ;
         VALID    ( RecalculaTotal( aTmp ) );
         PICTURE  "@E 99.99" ;
         SPINNER;
         ID       182 ;
         OF       oFld:aDialogs[1]

      REDEFINE GET oGetAge VAR nTotAge ;
         ID       183 ;
         WHEN     ( .f. );
         OF       oFld:aDialogs[1]
      /*
      Ruta____________________________________________________________________
      */

      REDEFINE GET aGet[ _CCODRUT ] VAR aTmp[ _CCODRUT ] ;
         ID       185 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( cRuta( aGet[ _CCODRUT ], dbfRuta, oSay[ 7 ] ) );
         BITMAP   "LUPA" ;
         ON HELP  ( BrwRuta( aGet[ _CCODRUT ], dbfRuta, oSay[ 7 ] ) );
         OF       oFld:aDialogs[1]

      REDEFINE GET oSay[ 7 ] VAR cSay[ 7 ] ;
         ID       186 ;
         WHEN     .F. ;
         OF       oFld:aDialogs[1]

      /*
      Divisa____________________________________________________________________
      */

      REDEFINE GET aGet[ _CDIVSAT ] VAR aTmp[ _CDIVSAT ];
         WHEN     ( nMode == APPD_MODE .AND. ( dbfTmpLin )->( LastRec() ) == 0 ) ;
         VALID    ( cDivOut( aGet[ _CDIVSAT ], oBmpDiv, aGet[ _NVDVSAT ], @cPouDiv, @nDouDiv, @cPorDiv, @nRouDiv, nil, nil, oGetMasDiv, dbfDiv, oBandera ) );
         PICTURE  "@!";
         ID       200 ;
         COLOR    CLR_GET ;
         BITMAP   "LUPA" ;
         ON HELP  BrwDiv( aGet[ _CDIVSAT ], oBmpDiv, aGet[ _NVDVSAT ], dbfDiv, oBandera ) ;
         OF       oFld:aDialogs[1]

      REDEFINE BITMAP oBmpDiv ;
         RESOURCE "BAN_EURO" ;
         ID       201;
         OF       oFld:aDialogs[1]

      /*
      Bitmap________________________________________________________________
      */

      REDEFINE BITMAP oBmpEmp ;
         FILE     "Bmp\ImgSatCli.bmp" ;
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
      oBrwLin:cName           := "Satsupuesto a cliente.Detalle"

      oBrwLin:CreateFromResource( 210 )

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
         :nWidth              := 60
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader             := "Código"
         :bEditValue          := {|| ( dbfTmpLin )->cRef }
         :nWidth              := 60
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader             := "C. Barras"
         :bEditValue          := {|| cCodigoBarrasDefecto( ( dbfTmpLin )->cRef, dbfCodeBar ) }
         :nWidth              := 100
         :lHide               := .t.
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader             := "Descripción"
         :bEditValue          := {|| if( Empty( ( dbfTmpLin )->cRef ), ( dbfTmpLin )->mLngDes, ( dbfTmpLin )->cDetalle ) }
         :nWidth              := 300
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
         :cHeader             := cNombreUnidades()
         :bEditValue          := {|| nTotNSatCli( dbfTmpLin ) }
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
         :bEditValue          := {|| nImpUSatCli( dbfTmpLin, nDouDiv ) }
         :cEditPicture        := cPouDiv
         :nWidth              := 80
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader             := "% Dto."
         :bEditValue          := {|| ( dbfTmpLin )->nDto }
         :cEditPicture        := "@E 999.99"
         :nWidth              := 50
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader             := "Dto. Lin."
         :bEditValue          := {|| nDtoUSatCli( dbfTmpLin, nDouDiv ) }
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
         :cEditPicture        := "@E 99.9"
         :nWidth              := 50
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader             := "Portes"
         :bEditValue          := {|| nTrnUSatCli( dbfTmpLin, nDouDiv ) }
         :cEditPicture        := cPouDiv
         :nWidth              := 70
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
         :lHide               := .t.
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader             := "P. verde"
         :bEditValue          := {|| nPntUSatCli( dbfTmpLin, nDouDiv ) }
         :cEditPicture        := cPouDiv
         :nWidth              := 70
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
         :lHide               := .t.
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader             := "Total"
         :bEditValue          := {|| nTotLSatCli( , dbfTmpLin, nDouDiv, nRouDiv, , , aTmp[ _LOPERPV ] ) }
         :cEditPicture        := cPorDiv
         :nWidth              := 80
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
      end with

      if nMode != ZOOM_MODE
         oBrwLin:bLDblClick  := {|| EdtDeta( oBrwLin, bEdtDet, aTmp ) }
      end if

      /*
      Descuentos______________________________________________________________
      */

      REDEFINE GET aGet[ _CDTOESP ] VAR aTmp[ _CDTOESP ] ;
         ID       219 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _NDTOESP ] VAR aTmp[ _NDTOESP ] ;
         ID       220 ;
         PICTURE  "@E 99.99" ;
         SPINNER ;
         VALID    ( RecalculaTotal( aTmp ) );
         ON CHANGE( RecalculaTotal( aTmp ) );
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CDPP ] VAR aTmp[ _CDPP ] ;
         ID       229 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _NDPP ] VAR aTmp[ _NDPP ];
         ID       230 ;
         PICTURE  "@E 99.99" ;
         SPINNER ;
         VALID    ( RecalculaTotal( aTmp ) );
         ON CHANGE( RecalculaTotal( aTmp ) );
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CDTOUNO ] VAR aTmp[ _CDTOUNO ] ;
         ID       240 ;
         PICTURE  "@!" ;
         COLOR    CLR_GET ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _NDTOUNO ] VAR aTmp[ _NDTOUNO ];
         ID       250 ;
         PICTURE  "@E 99.99" ;
         SPINNER ;
         COLOR    CLR_GET ;
         VALID    ( RecalculaTotal( aTmp ) );
         ON CHANGE( RecalculaTotal( aTmp ) );
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CDTODOS ] VAR aTmp[ _CDTODOS ] ;
         ID       260 ;
         PICTURE  "@!" ;
         COLOR    CLR_GET ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _NDTODOS ] VAR aTmp[ _NDTODOS ];
         ID       270 ;
         PICTURE  "@E 99.99" ;
         SPINNER ;
         COLOR    CLR_GET ;
         VALID    ( RecalculaTotal( aTmp ) );
         ON CHANGE( RecalculaTotal( aTmp ) );
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

      /*
      Desglose del IGIC---------------------------------------------------------
      */

      oBrwIva                        := TXBrowse():New( oFld:aDialogs[ 1 ] )

      oBrwIva:bClrSel                := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwIva:bClrSelFocus           := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrwIva:SetArray( aTotIva, , , .f. )
      oBrwIva:lHscroll               := .f.

      oBrwIva:nMarqueeStyle          := 5
      oBrwIva:lRecordSelector        := .f.

      oBrwIva:CreateFromResource( 490 )

      with object ( oBrwIva:AddCol() )
         :cHeader          := "Base"
         :bStrData         := {|| if( aTotIva[ oBrwIva:nArrayAt, 3 ] != nil, Trans( aTotIva[ oBrwIva:nArrayAt, 2 ], cPorDiv ), "" ) }
         :nWidth           := 105
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      with object ( oBrwIva:AddCol() )
         :cHeader       := "%" + cImp()
         :bStrData      := {|| if( !IsNil( aTotIva[ oBrwIva:nArrayAt, 3 ] ), aTotIva[ oBrwIva:nArrayAt, 3 ], "" ) }
         :bEditValue    := {|| aTotIva[ oBrwIva:nArrayAt, 3 ] }
         :nWidth        := 58
         :cEditPicture  := "@E 999.99"
         :nDataStrAlign := 1
         :nHeadStrAlign := 1
         :nFootStrAlign := 1
         :nEditType     := 1
         :bEditWhen     := {|| !IsNil( aTotIva[ oBrwIva:nArrayAt, 3 ] ) }
         :bOnPostEdit   := {|o,x| EdtIva( o, x, aTotIva[ oBrwIva:nArrayAt, 3 ], dbfTmpLin, dbfIva, oBrwLin ), RecalculaTotal( aTmp ) }
      end with

      with object ( oBrwIva:AddCol() )
         :cHeader          := cImp()
         :bStrData         := {|| if( aTotIva[ oBrwIva:nArrayAt, 3 ] != nil, Trans( aTotIva[ oBrwIva:nArrayAt, 8 ], cPorDiv ), "" ) }
         :nWidth           := 64
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      with object ( oBrwIva:AddCol() )
         :cHeader          := "% R.E."
         :bStrData         := {|| if( aTotIva[ oBrwIva:nArrayAt, 3 ] != nil .and. aTmp[ _LRECARGO ], Trans( aTotIva[ oBrwIva:nArrayAt, 4 ], "@EZ 99.9" ), "" ) }
         :nWidth           := 58
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      with object ( oBrwIva:AddCol() )
         :cHeader          := "R.E."
         :bStrData         := {|| if( aTotIva[ oBrwIva:nArrayAt, 3 ] != nil .and. aTmp[ _LRECARGO ], Trans( aTotIva[ oBrwIva:nArrayAt, 9 ], cPorDiv ), "" ) }
         :nWidth           := 58
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      /*
      Cajas de Totales
      ------------------------------------------------------------------------
      */

      REDEFINE GET aGet[ _CMANOBR ] VAR aTmp[ _CMANOBR ] ;
         ID       411 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _NIVAMAN ] VAR aTmp[ _NIVAMAN ] ;
         ID       412 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  "@E 99.99" ;
         VALID    ( lTiva( dbfIva, aTmp[ _NIVAMAN ] ) );
         ON CHANGE( RecalculaTotal( aTmp ) );
         BITMAP   "LUPA" ;
         ON HELP  ( BrwIva( aGet[ _NIVAMAN ], dbfIva, , .t. ) );
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _NMANOBR ] VAR aTmp[ _NMANOBR ] ;
         ID       400 ;
         PICTURE  cPorDiv ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( RecalculaTotal( aTmp ) );
         ON CHANGE( RecalculaTotal( aTmp ) );
         OF       oFld:aDialogs[1]

      REDEFINE SAY oGetNet VAR nTotNet ;
         ID       401 ;
         OF       oFld:aDialogs[1]

      REDEFINE SAY oGetTrn VAR nTotTrn ;
         ID       402 ;
         OF       oFld:aDialogs[1]

      REDEFINE SAY oGetIvm VAR nTotIvm ;
         ID       403 ;
         OF       oFld:aDialogs[1]

      REDEFINE CHECKBOX aGet[ _LOPERPV ] VAR aTmp[ _LOPERPV ] ;
         ID       409 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ON CHANGE( RecalculaTotal( aTmp ), oBrwLin:Refresh() );
         OF       oFld:aDialogs[1]

      REDEFINE SAY oGetPnt VAR nTotPnt ;
         ID       404 ;
         OF       oFld:aDialogs[1]

      REDEFINE SAY oGetIva VAR nTotIva ;
         ID       405 ;
         OF       oFld:aDialogs[1]

      REDEFINE CHECKBOX aGet[ _LRECARGO ] VAR aTmp[ _LRECARGO ] ;
         ID       406 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ON CHANGE( RecalculaTotal( aTmp ) );
         OF       oFld:aDialogs[1]

      REDEFINE SAY oGetReq VAR nTotReq ;
         ID       407 ;
         OF       oFld:aDialogs[1]

      REDEFINE SAY oSayGetRnt ID 709 OF oFld:aDialogs[1]

      REDEFINE GET oGetRnt VAR nTotRnt;
         ID       408 ;
         OF       oFld:aDialogs[1]

      REDEFINE SAY oGetMasDiv VAR cGetMasDiv ;
         ID       410 ;
         FONT     oFont ;
         OF       oFld:aDialogs[1]

      REDEFINE SAY oGetTotal VAR nTotSat ;
         ID       420 ;
         FONT     oFont ;
         OF       oFld:aDialogs[1]

      /*
      Botones de la caja de dialogo___________________________________________
      */

      REDEFINE BUTTON ;
         ID       515 ;
         OF       oFld:aDialogs[1] ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( AppDeta( oBrwLin, bEdtDet, aTmp, .t. ) )

      REDEFINE BUTTON ;
         ID       500 ;
         OF       oFld:aDialogs[1] ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( AppDeta( oBrwLin, bEdtDet, aTmp, .f. ) )

      REDEFINE BUTTON ;
         ID       501 ;
         OF       oFld:aDialogs[1] ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( EdtDeta( oBrwLin, bEdtDet, aTmp ) )

      REDEFINE BUTTON ;
         ID       502 ;
         OF       oFld:aDialogs[1] ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( DelDeta( oBrwLin, aTmp ) )

      REDEFINE BUTTON ;
         ID       503 ;
         OF       oFld:aDialogs[1] ;
         ACTION   ( EdtZoom( oBrwLin, bEdtDet, aTmp ) )

      REDEFINE BUTTON ;
         ID       524 ;
         OF       oFld:aDialogs[1] ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( DbSwapUp( dbfTmpLin, oBrwLin ) )

      REDEFINE BUTTON ;
         ID       525 ;
         OF       oFld:aDialogs[1] ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( DbSwapDown( dbfTmpLin, oBrwLin ) )

      REDEFINE BUTTON oBtnKit;
         ID       526 ;
         OF       oFld:aDialogs[1] ;
         ACTION   ( ShowKit( dbfSatCliT, dbfTmpLin, oBtnKit, oBrwLin ) )

      REDEFINE GET aGet[_CSERSAT] VAR aTmp[_CSERSAT] ;
         ID       90 ;
         PICTURE  "@!" ;
         COLOR    CLR_GET ;
         SPINNER ;
         ON UP    ( UpSerie( aGet[_CSERSAT] ) );
         ON DOWN  ( DwSerie( aGet[_CSERSAT] ) );
         WHEN     ( nMode == APPD_MODE .OR. nMode == DUPL_MODE );
         VALID    ( aTmp[_CSERSAT] >= "A" .AND. aTmp[_CSERSAT] <= "Z"  );
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[_NNUMSAT] VAR aTmp[_NNUMSAT];
         ID       100 ;
         PICTURE  "999999999" ;
         WHEN     .F. ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[_CSUFSAT] VAR aTmp[_CSUFSAT];
         ID       105 ;
         WHEN     .F. ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _DFECSAT ] VAR aTmp[ _DFECSAT ];
         ID       110 ;
         SPINNER;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _DFECSAL ] VAR aTmp[ _DFECSAL ];
         ID       111 ;
         IDSAY    112 ;
         SPINNER;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ON CHANGE( SetDiasSAT( aTmp, aGet ) );
         OF       oFld:aDialogs[1]

      REDEFINE CHECKBOX aGet[ _LGARANTIA ] VAR aTmp[ _LGARANTIA ] ;
         ID       115 ;
         OF       oFld:aDialogs[1]

      REDEFINE GET oAprovado VAR cAprovado ;
         ID       120 ;
         WHEN     ( .F. ) ;
         OF       oFld:aDialogs[1]

      REDEFINE COMBOBOX aGet[ _CSITUAC ] VAR aTmp[ _CSITUAC ] ;
         ID       218 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ITEMS    ( aSituacion( dbfSitua ) ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CSUSAT ] VAR aTmp[ _CSUSAT ] ;
         ID       122 ;
         IDSAY    123 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         COLOR    CLR_GET ;
         OF       oFld:aDialogs[1]

      REDEFINE CHECKBOX aGet[ _LIVAINC ] VAR aTmp[ _LIVAINC ] ;
         ID       129 ;
         WHEN     ( ( dbfTmpLin )->( LastRec() ) == 0 ) ;
         OF       oFld:aDialogs[1]

      /*
      Segunda caja de dialogo--------------------------------------------------
      */

      REDEFINE GET aGet[ _CCODUSR ] VAR aTmp[ _CCODUSR ];
         ID       115 ;
         WHEN     ( .f. ) ;
         VALID    ( SetUsuario( aGet[ _CCODUSR ], oSay[ 10 ], nil, dbfUsr ) );
         OF       oFld:aDialogs[2]

      REDEFINE GET oSay[ 10 ] VAR cSay[ 10 ] ;
         ID       116 ;
         WHEN     ( .f. ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ _CCODDLG ] VAR aTmp[ _CCODDLG ] ;
         ID       300 ;
         WHEN     ( .f. ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET oSay[ 11 ] VAR cSay[ 11 ] ;
         ID       301 ;
         WHEN     ( .f. ) ;
         OF       oFld:aDialogs[2]

      /*
      Transportistas-----------------------------------------------------------
      */

      REDEFINE GET aGet[ _CCODTRN ] VAR aTmp[ _CCODTRN ] ;
         ID       235 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( LoadTrans( aTmp, aGet[ _CCODTRN ], aGet[ _NKGSTRN ], oSay[ 8 ] ) );
         BITMAP   "LUPA" ;
         ON HELP  ( oTrans:Buscar( aGet[ _CCODTRN ] ), .t. );
         OF       oFld:aDialogs[2]

      REDEFINE GET oSay[ 8 ] VAR cSay[ 8 ] ;
         ID       236 ;
         WHEN     .F. ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ _NKGSTRN ] VAR aTmp[ _NKGSTRN ] ;
         ID       237 ;
         WHEN     ( .f. ) ;
         PICTURE  ( MasUnd() ) ;
         OF       oFld:aDialogs[2]

      /*
      Cajas____________________________________________________________________
      */

      REDEFINE GET aGet[ _CCODCAJ ] VAR aTmp[ _CCODCAJ ];
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    cCajas( aGet[ _CCODCAJ ], dbfCajT, oSay[ 9 ] ) ;
         ID       165 ;
         COLOR    CLR_GET ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwCajas( aGet[ _CCODCAJ ], oSay[ 9 ] ) ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET oSay[ 9 ] VAR cSay[ 9 ] ;
         ID       166 ;
         WHEN     .f. ;
         COLOR    CLR_GET ;
         OF       oFld:aDialogs[2]

     REDEFINE GET aGet[ _NBULTOS ] VAR aTmp[ _NBULTOS ];
         ID       128 ;
			SPINNER;
         PICTURE  "999" ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[2]

      /*
      Retirado por________________________________________________________________
      */

      REDEFINE GET aGet[_CRETPOR] VAR aTmp[_CRETPOR] ;
         ID       160 ;
         COLOR    CLR_GET ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[_CRETMAT] VAR aTmp[_CRETMAT] ;
         ID       170 ;
         COLOR    CLR_GET ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[2]

      /*
      Comentarios_____________________________________________________________
      */

      REDEFINE GET aGet[ _CCONDENT ] VAR aTmp[ _CCONDENT ] ;
         ID       230 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ _MCOMENT ] VAR aTmp[ _MCOMENT ] MEMO ;
         ID       250 ;
         COLOR    CLR_GET ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[2]

		REDEFINE GET aGet[ _MOBSERV ] VAR aTmp[ _MOBSERV ] MEMO ;
         ID       240 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			OF 		oFld:aDialogs[2]

      /*
      Impresión ( informa de si está impreimido o no y de cuando se imprimió )-
      */

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
      Incidencias--------------------------------------------------------------
      */

      oBrwInc                 := IXBrowse():New( oFld:aDialogs[ 3 ] )

      oBrwInc:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwInc:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrwInc:cAlias          := dbfTmpInc

      oBrwInc:nMarqueeStyle   := 6
      oBrwInc:cName           := "Satsupuesto a cliente.Incidencias"

         with object ( oBrwInc:AddCol() )
            :cHeader          := "Resuelta"
            :bStrData         := {|| "" }
            :bEditValue       := {|| ( dbfTmpInc )->lListo }
            :nWidth           := 70
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
            :nWidth           := 250
         end with

         with object ( oBrwInc:AddCol() )
            :cHeader          := "Fecha"
            :bEditValue       := {|| Dtoc( ( dbfTmpInc )->dFecInc ) }
            :nWidth           := 90
         end with

         with object ( oBrwInc:AddCol() )
            :cHeader          := "Descripción"
            :bEditValue       := {|| ( dbfTmpInc )->mDesInc }
            :nWidth           := 500
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
         ACTION   ( WinDelRec( oBrwInc, dbfTmpInc ) )

      REDEFINE BUTTON ;
         ID       503 ;
         OF       oFld:aDialogs[ 3 ] ;
         ACTION   ( WinZooRec( oBrwInc, bEdtInc, dbfTmpInc ) )

      /*
      Caja de diálogo de documentos--------------------------------------------
      */

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
            :nWidth           := 960
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
         ACTION   ( WinDelRec( oBrwDoc, dbfTmpDoc ) )

      REDEFINE BUTTON ;
         ID       503 ;
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
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( RecSatCli( aTmp ), nTotSatCli( nil, dbfSatCliT, dbfTmpLin, dbfIva, dbfDiv, dbfFPago, aTmp ) )

      REDEFINE BUTTON ;
         ID       IDOK ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( EndTrans( aTmp, aGet, nMode, oBrwLin, oBrw, oBrwInc, oDlg ) )

      REDEFINE BUTTON ;
         ID       4 ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( if( EndTrans( aTmp, aGet, nMode, oBrwLin, oBrw, oBrwInc, oDlg ), GenSatCli( IS_PRINTER ), ) )

      REDEFINE BUTTON ;
         ID       IDCANCEL ;
         OF       oDlg ;
         ACTION   ( if ( ExitNoSave( nMode, dbfTmpLin ), oDlg:end(), ) )

      REDEFINE GROUP oSayLabels[ 1 ] ID 700 OF oFld:aDialogs[ 1 ] TRANSPARENT
      REDEFINE SAY   oSayLabels[ 2 ] ID 703 OF oFld:aDialogs[ 1 ]
      REDEFINE SAY   oSayLabels[ 3 ] ID 704 OF oFld:aDialogs[ 1 ]
      REDEFINE SAY   oSayLabels[ 4 ] ID 705 OF oFld:aDialogs[ 1 ]
      REDEFINE SAY   oSayLabels[ 5 ] ID 706 OF oFld:aDialogs[ 1 ]
      REDEFINE SAY   oSayLabels[ 6 ] ID 708 OF oFld:aDialogs[ 1 ]
      REDEFINE SAY   oSayLabels[ 7 ] ID 710 OF oFld:aDialogs[ 1 ]
      REDEFINE SAY   oSayLabels[ 8 ] ID 711 OF oFld:aDialogs[ 1 ]
      REDEFINE SAY   oSayLabels[ 9 ] ID 712 OF oFld:aDialogs[ 1 ]

   if nMode != ZOOM_MODE

      oFld:aDialogs[1]:AddFastKey( VK_F2, {|| AppDeta( oBrwLin, bEdtDet, aTmp, .f. ) } )
      oFld:aDialogs[1]:AddFastKey( VK_F3, {|| EdtDeta( oBrwLin, bEdtDet, aTmp ) } )
      oFld:aDialogs[1]:AddFastKey( VK_F4, {|| DelDeta( oBrwLin, aTmp ) } )

      oFld:aDialogs[3]:AddFastKey( VK_F2, {|| WinAppRec( oBrwInc, bEdtInc, dbfTmpInc, nil, nil, aTmp ) } )
      oFld:aDialogs[3]:AddFastKey( VK_F3, {|| WinEdtRec( oBrwInc, bEdtInc, dbfTmpInc, nil, nil, aTmp ) } )
      oFld:aDialogs[3]:AddFastKey( VK_F4, {|| WinDelRec( oBrwInc, dbfTmpInc ) } )

      oFld:aDialogs[4]:AddFastKey( VK_F2, {|| WinAppRec( oBrwDoc, bEdtDoc, dbfTmpDoc, nil, nil, aTmp ) } )
      oFld:aDialogs[4]:AddFastKey( VK_F3, {|| WinEdtRec( oBrwDoc, bEdtDoc, dbfTmpDoc, nil, nil, aTmp ) } )
      oFld:aDialogs[4]:AddFastKey( VK_F4, {|| WinDelRec( oBrwDoc, dbfTmpDoc ) } )

      oDlg:AddFastKey( VK_F5, {|| EndTrans( aTmp, aGet, nMode, oBrwLin, oBrw, oBrwInc, oDlg ) } )
      oDlg:AddFastKey( VK_F6, {|| if( EndTrans( aTmp, aGet, nMode, oBrwLin, oBrw, oBrwInc, oDlg ), GenSatCli( IS_PRINTER ), ) } )

      oDlg:AddFastKey( 65,    {|| if( GetKeyState( VK_CONTROL ), CreateInfoArticulo(), ) } )

   end if

   oDlg:AddFastKey( VK_F1, {|| ChmHelp( "Satsupuesto" ) } )

   do case
      case nMode == APPD_MODE .and. lRecogerUsuario() .and. Empty( cCodArt )
         oDlg:bStart := {|| if( lGetUsuario( aGet[ _CCODUSR ], dbfUsr ), , oDlg:End() ) }

      case nMode == APPD_MODE .and. lRecogerUsuario() .and. !Empty( cCodArt )
         oDlg:bStart := {|| if( lGetUsuario( aGet[ _CCODUSR ], dbfUsr ), AppDeta( oBrwLin, bEdtDet, aTmp, nil, cCodArt ), oDlg:End() ) }

      case nMode == APPD_MODE .and. !lRecogerUsuario() .and. !Empty( cCodArt )
         oDlg:bStart := {|| AppDeta( oBrwLin, bEdtDet, aTmp, nil, cCodArt ) }

      otherwise
         oDlg:bStart := {|| ShowKit( dbfSatCliT, dbfTmpLin, oBtnKit, oBrwLin, .f., dbfTmpInc, cCodCli, dbfClient, oRieCli, oGetRnt, aGet, oSayGetRnt ) }

   end case

   ACTIVATE DIALOG oDlg;
         ON INIT  (  EdtRecMenu( aTmp, oDlg ) ,;
                     SetDialog( aGet, oSayGetRnt, oGetRnt ) ,;
                     oBrwLin:Load() ,;
                     oBrwInc:Load() );
         ON PAINT (  RecalculaTotal( aTmp ) );
         CENTER

   oMenu:End()

   oBmpEmp:end()
   oBmpDiv:end()
   oBmpGeneral:End()

   ( dbfSatCliT )->( ordSetFocus( nOrd ) )

   KillTrans( oBrwLin )

   /*
    Guardamos los datos del browse
   */

   oBrwInc:CloseData()

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

Static Function EdtRecMenu( aTmp, oDlg )

   MENU oMenu

      MENUITEM    "&1. Rotor"

         MENU

            if !lExternal

            MENUITEM    "&1. Modificar cliente";
               MESSAGE  "Modificar la ficha del cliente" ;
               RESOURCE "User1_16" ;
               ACTION   ( if( !Empty( aTmp[ _CCODCLI ] ), EdtCli( aTmp[ _CCODCLI ] ), MsgStop( "Código cliente vacío" ) ) )

            MENUITEM    "&2. Informe de cliente";
               MESSAGE  "Abrir el informe del cliente" ;
               RESOURCE "Info16" ;
               ACTION   ( if( !Empty( aTmp[ _CCODCLI ] ), InfCliente( aTmp[ _CCODCLI ] ), MsgStop( "Código cliente vacío" ) ) );

            MENUITEM    "&3. Modificar obra";
               MESSAGE  "Modificar ficha de la obra" ;
               RESOURCE "Worker16" ;
               ACTION   ( if( !Empty( aTmp[ _CCODOBR ] ), EdtObras( aTmp[ _CCODCLI ], aTmp[ _CCODOBR ], dbfObrasT ), MsgStop( "No hay obra asociada para el S.A.T." ) ) )

            SEPARATOR

            end if

            MENUITEM    "&4. Informe del documento";
               MESSAGE  "Abrir el informe del documento" ;
               RESOURCE "Info16" ;
               ACTION   ( TTrazaDocumento():Activate( SAT_CLI, aTmp[ _CSERSAT ] + Str( aTmp[ _NNUMSAT ] ) + aTmp[ _CSUFSAT ] ) )

         ENDMENU

   ENDMENU

   oDlg:SetMenu( oMenu )

Return ( oMenu )

//----------------------------------------------------------------------------//
/*
Funcion Auxiliar para Añadir lineas de detalle a un Pedido
*/

STATIC FUNCTION AppDeta( oBrwLin, bEdtDet, aTmp, lTot, cCodArt  )

   DEFAULT lTot      := .f.

   /*
   Ultimo numero de la linea
   */

   WinAppRec( oBrwLin, bEdtDet, dbfTmpLin, lTot, cCodArt, aTmp )

   if !Empty( oBrwLin )
      oBrwLin:Refresh()
   end if

RETURN RecalculaTotal( aTmp )

//--------------------------------------------------------------------------//

/*
Funcion Auxiliar para la Edici¢n de Lineas de Detalle en un Pedido
*/

STATIC FUNCTION EdtDeta( oBrwLin, bEdtDet, aTmp )

   WinEdtRec( oBrwLin, bEdtDet, dbfTmpLin, .f., nil, aTmp )

RETURN RecalculaTotal( aTmp )

//--------------------------------------------------------------------------//

/*
Funcion Auxiliar para borrar las Lineas de Detalle en un Pedido
*/

STATIC FUNCTION DelDeta( oBrwLin, aTmp ) 

   CursorWait()

   while ( dbfTmpSer )->( dbSeek( Str( ( dbfTmpLin )->nNumLin, 4 ) ) )
      ( dbfTmpSer )->( dbDelete() )
   end while

   if ( dbfTmpLin )->lKitArt
      dbDelKit( oBrwLin, dbfTmpLin, ( dbfTmpLin )->nNumLin )
   end if

   WinDelRec( oBrwLin, dbfTmpLin )

   RecalculaTotal( aTmp )

   CursorWE()

RETURN ( .t. )

//--------------------------------------------------------------------------//

/*
Funcion Auxiliar para la Visualizaci¢n de Lineas de Detalle en una Abono
*/

STATIC FUNCTION EdtZoom( oBrwLin, bEdtDet, aTmp )

RETURN WinZooRec( oBrwLin, bEdtDet, dbfTmpLin, .f., nil, aTmp )

//--------------------------------------------------------------------------//
/*
Edita las lineas de Detalle
*/

STATIC FUNCTION EdtDet( aTmp, aGet, dbfSatCliL, oBrw, lTotLin, cCodArtEnt, nMode, aTmpSat )

   local oDlg
   local oFld
   local oBtn
   local oTotal
   local nTotSatCli
   local cGet2
   local oGet2
   local cGet3
   local oGet3
   local oBtnSer
   local oSayPr1
   local oSayPr2
   local cSayPr1           := ""
   local cSayPr2           := ""
   local oSayVp1
   local oSayVp2
   local cSayVp1           := ""
   local cSayVp2           := ""
   local oSayAlm
   local cSayAlm           := ""
   local bmpImage
   local oSayLote
   local oSayGrp
   local cSayGrp           := ""
   local oSayFam
   local cSayFam           := ""
   local oStkAct
   local nStkAct           := 0
   local cCodArt           := Padr( aTmp[ _CREF ], 32 )
   local oRentLin
   local cRentLin
   local cCodDiv           := aTmpSat[ _CDIVSAT ]
   local oSayDias
   local oGetCaducidad
   local dGetCaducidad

   DEFAULT lTotLin         := .f.

   SysRefresh()

   do case
   case nMode == APPD_MODE

      aTmp[ _CSERSAT  ]    := aTmpSat[ _CSERSAT ]
      aTmp[ _NNUMSAT  ]    := aTmpSat[ _NNUMSAT ]
      aTmp[ _CSUFSAT  ]    := aTmpSat[ _CSUFSAT ]
      aTmp[ _NUNICAJA ]    := 1
      aTmp[ _CTIPMOV  ]    := cDefVta()
      aTmp[ _LTOTLIN  ]    := lTotLin
      aTmp[ _NCANSAT  ]    := 1
      aTmp[ _LIVALIN  ]    := aTmpSat[ _LIVAINC ]
      aTmp[ _CALMLIN  ]    := aTmpSat[ _CCODALM ]
      aTmp[ _NTARLIN  ]    := aTmpSat[ _NTARIFA ]
      aTmp[ _LIMPFRA  ]    := .t.

      if !Empty( cCodArtEnt )
         cCodArt           := Padr( cCodArtEnt, 32 )
      end if

      aTmp[ __DFECSAL ]    := aTmpSat[ _DFECSAL ]

   case nMode == EDIT_MODE

      lTotLin              := aTmp[ _LTOTLIN ]

   end case

   /*
   Este valor los guaradamos para detectar los posibles cambios----------------
   */

   cOldCodArt           := aTmp[ _CREF ]
   cOldPrpArt           := aTmp[ _CCODPR1 ] + aTmp[ _CCODPR2 ] + aTmp[ _CVALPR1 ] + aTmp[ _CVALPR2 ]
   cOldUndMed           := aTmp[ _CUNIDAD ]

   /*
   Etiquetas de familias y grupos de familias----------------------------------
   */

   cSayGrp              := RetFld( aTmp[ _CGRPFAM ], oGrpFam:GetAlias() )
   cSayFam              := RetFld( aTmp[ _CCODFAM ], dbfFamilia )

   DEFINE DIALOG oDlg RESOURCE "LFACCLI" TITLE LblTitle( nMode ) + "líneas de S.A.T. a clientes"

      REDEFINE FOLDER oFld ;
         ID       400 ;
         OF       oDlg ;
         PROMPT   "&General",;
                  "Da&tos",;
                  "&Observaciones" ;
         DIALOGS  "LFACCLI_1",;
                  "LALBCLI_2",;
                  "LFACCLI_3"

      REDEFINE GET aGet[ _CREF ] VAR cCodArt;
         ID       100 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( LoaArt( aTmp, aGet, aTmpSat, oStkAct, oSayPr1, oSayPr2, oSayVp1, oSayVp2, bmpImage, oSayLote, nMode ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwArticulo( aGet[ _CREF ], aGet[ _CDETALLE ] ) ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CDETALLE ] VAR aTmp[ _CDETALLE ] ;
         ID       110 ;
         WHEN     ( ( lModDes() .or. Empty( aTmp[ _CDETALLE ] ) ) .AND. nMode != ZOOM_MODE );
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _MLNGDES ] VAR aTmp[ _MLNGDES ] ;
         MEMO ;
         ID       111 ;
         WHEN     ( ( lModDes() .or. Empty( aTmp[ _MLNGDES ] ) ) .AND. nMode != ZOOM_MODE );
         OF       oFld:aDialogs[1]

      /*
      Lotes
      -------------------------------------------------------------------------
      */

      REDEFINE SAY oSayLote;
         ID       113;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CLOTE ] VAR aTmp[ _CLOTE ];
         ID       112 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

      aGet[ _CLOTE ]:bValid   := {|| if( !uFieldEmpresa( "lNStkAct" ), oStock:nPutStockActual( aTmp[ _CREF ], aTmp[ _CALMLIN ], aTmp[ _CVALPR1 ], aTmp[ _CVALPR2 ], aTmp[ _CLOTE ], aTmp[ _LKITART ], aTmp[ _NCTLSTK ], oStkAct ), .t. ), .t. }

      if !aTmp[ __LALQUILER ]

      REDEFINE GET oGetCaducidad VAR dGetCaducidad ;
         ID       340 ;
         IDSAY    341 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

      end if

      /*
      Propiedades
      -------------------------------------------------------------------------
      */

      if !aTmp[ __LALQUILER ]

      REDEFINE GET aGet[ _CVALPR1 ] VAR aTmp[ _CVALPR1 ];
         ID       270 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         COLOR    CLR_GET ;
         BITMAP   "LUPA" ;
         VALID    ( if( lPrpAct( aTmp[_CVALPR1], oSayVp1, aTmp[_CCODPR1 ], dbfTblPro ),;
                        LoaArt( aTmp, aGet, aTmpSat, oStkAct, oSayPr1, oSayPr2, oSayVp1, oSayVp2, bmpImage, oSayLote, nMode, .f. ),;
                        .f. ) );
         ON HELP  ( brwPrpAct( aGet[_CVALPR1], oSayVp1, aTmp[_CCODPR1 ] ) ) ;
         OF       oFld:aDialogs[1]

         aGet[ _CVALPR1 ]:bChange   := {|| aGet[ _CVALPR1 ]:Assign(), if( !uFieldEmpresa( "lNStkAct" ), oStock:nPutStockActual( aTmp[ _CREF ], aTmp[ _CALMLIN ], aTmp[ _CVALPR1 ], aTmp[ _CVALPR2 ], aTmp[ _CLOTE ], aTmp[ _LKITART ], aTmp[ _NCTLSTK ], oStkAct ), .t. ) }

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
         COLOR    CLR_GET ;
         BITMAP   "LUPA" ;
         VALID    ( if( lPrpAct( aTmp[_CVALPR2], oSayVp2, aTmp[_CCODPR2 ], dbfTblPro ),;
                        LoaArt( aTmp, aGet, aTmpSat, oStkAct, oSayPr1, oSayPr2, oSayVp1, oSayVp2, bmpImage, oSayLote, nMode, .f. ),;
                        .f. ) );
         ON HELP  ( brwPrpAct( aGet[_CVALPR2], oSayVp2, aTmp[_CCODPR2 ] ) ) ;
         OF       oFld:aDialogs[1]

         aGet[ _CVALPR2 ]:bChange   := {|| aGet[ _CVALPR2 ]:Assign(), if( !uFieldEmpresa( "lNStkAct" ), oStock:nPutStockActual( aTmp[ _CREF ], aTmp[ _CALMLIN ], aTmp[ _CVALPR1 ], aTmp[ _CVALPR2 ], aTmp[ _CLOTE ], aTmp[ _LKITART ], aTmp[ _NCTLSTK ], oStkAct ), .t. ) }

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

      REDEFINE GET aGet[ _CUNIDAD ] VAR aTmp[ _CUNIDAD ] ;
         ID       170 ;
         IDTEXT   171 ;
         BITMAP   "LUPA" ;
         VALID    ( oUndMedicion:Existe( aGet[ _CUNIDAD ], aGet[ _CUNIDAD ]:oHelpText, "cNombre" ), ValidaMedicion( aTmp, aGet ) );
         ON HELP  ( oUndMedicion:Buscar( aGet[ _CUNIDAD ] ), ValidaMedicion( aTmp, aGet ) ) ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

      // Campos de las descripciones de la unidad de medición

      REDEFINE GET aGet[ ( dbfSatCliL )->( fieldpos( "nMedUno" ) ) ] ;
         VAR      aTmp[ ( dbfSatCliL )->( fieldpos( "nMedUno" ) ) ] ;
         ID       520 ;
         IDSAY    521 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ON CHANGE( RecalculaLinea( aTmp, aTmpSat, nDouDiv, oTotal, oRentLin, cCodDiv ) );
         PICTURE  MasUnd() ;
         OF       oFld:aDialogs[1]

         aGet[ ( dbfSatCliL )->( fieldpos( "nMedUno" ) ) ]:oSay:SetColor( CLR_BLUE )

      REDEFINE GET aGet[ ( dbfSatCliL )->( fieldpos( "nMedDos" ) ) ] ;
         VAR      aTmp[ ( dbfSatCliL )->( fieldpos( "nMedDos" ) ) ] ;
         ID       530 ;
         IDSAY    531 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ON CHANGE( RecalculaLinea( aTmp, aTmpSat, nDouDiv, oTotal, oRentLin, cCodDiv ) );
         PICTURE  MasUnd() ;
         OF       oFld:aDialogs[1]

         aGet[ ( dbfSatCliL )->( fieldpos( "nMedDos" ) ) ]:oSay:SetColor( CLR_BLUE )

      REDEFINE GET aGet[ ( dbfSatCliL )->( fieldpos( "nMedTre" ) ) ] ;
         VAR      aTmp[ ( dbfSatCliL )->( fieldpos( "nMedTre" ) ) ] ;
         ID       540 ;
         IDSAY    541 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ON CHANGE( RecalculaLinea( aTmp, aTmpSat, nDouDiv, oTotal, oRentLin, cCodDiv ) );
         PICTURE  MasUnd() ;
         OF       oFld:aDialogs[1]

         aGet[ ( dbfSatCliL )->( fieldpos( "nMedTre" ) ) ]:oSay:SetColor( CLR_BLUE )

      REDEFINE GET aGet[ _NIVA ] VAR aTmp[ _NIVA ] ;
         ID       120 ;
         WHEN     ( lModIva() .AND. nMode != ZOOM_MODE .AND. !lTotLin ) ;
         PICTURE  "@E 99.99" ;
         COLOR    CLR_GET ;
         VALID    ( lTiva( dbfIva, aTmp[ _NIVA ], @aTmp[ _NREQ ] ) );
         BITMAP   "LUPA" ;
         ON HELP  ( BrwIva( aGet[ _NIVA ], dbfIva, , .t. ) ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _NVALIMP ] ;
         VAR      aTmp[ _NVALIMP ] ;
         ID       125 ;
         IDSAY    126 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  cPouDiv ;
         ON CHANGE( RecalculaLinea( aTmp, aTmpSat, nDouDiv, oTotal, oRentLin, cCodDiv ) );
         ON HELP  ( oNewImp:nBrwImp( aGet[ _NVALIMP ] ) );
         OF       oFld:aDialogs[ 1 ]

      REDEFINE GET aGet[ _NCANSAT ] ;
         VAR      aTmp[ _NCANSAT ];
         ID       130 ;
         SPINNER ;
         WHEN     ( lUseCaj() .AND. nMode != ZOOM_MODE .AND. !lTotLin ) ;
         ON CHANGE( RecalculaLinea( aTmp, aTmpSat, nDouDiv, oTotal, oRentLin, cCodDiv ), LoaArt( aTmp, aGet, aTmpSat, oStkAct, oSayPr1, oSayPr2, oSayVp1, oSayVp2, bmpImage, oSayLote, nMode, .f. ) );
         VALID    ( RecalculaLinea( aTmp, aTmpSat, nDouDiv, oTotal, oRentLin, cCodDiv ), LoaArt( aTmp, aGet, aTmpSat, oStkAct, oSayPr1, oSayPr2, oSayVp1, oSayVp2, bmpImage, oSayLote, nMode, .f. ) );
         PICTURE  cPicUnd ;
         OF       oFld:aDialogs[1];
         IDSAY    131

      REDEFINE GET aGet[ _NUNICAJA ] VAR aTmp[ _NUNICAJA ];
         ID       140 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE .AND. !lTotLin ) ;
         ON CHANGE( RecalculaLinea( aTmp, aTmpSat, nDouDiv, oTotal, oRentLin, cCodDiv ), LoaArt( aTmp, aGet, aTmpSat, oStkAct, oSayPr1, oSayPr2, oSayVp1, oSayVp2, bmpImage, oSayLote, nMode, .f. ) );
         VALID    ( RecalculaLinea( aTmp, aTmpSat, nDouDiv, oTotal, oRentLin, cCodDiv ), LoaArt( aTmp, aGet, aTmpSat, oStkAct, oSayPr1, oSayPr2, oSayVp1, oSayVp2, bmpImage, oSayLote, nMode, .f. ) );
         PICTURE  cPicUnd ;
         OF       oFld:aDialogs[1] ;
         IDSAY    141

      REDEFINE GET aGet[ _NPREDIV ] VAR aTmp[ _NPREDIV ] ;
         ID       150 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE .and. !lTotLin ) ;
         ON CHANGE( RecalculaLinea( aTmp, aTmpSat, nDouDiv, oTotal, oRentLin, cCodDiv ) );
         VALID    ( RecalculaLinea( aTmp, aTmpSat, nDouDiv, oTotal, oRentLin, cCodDiv ) );
         COLOR    CLR_GET ;
         PICTURE  cPouDiv ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _NTARLIN ] VAR aTmp[ _NTARLIN ];
         ID       156 ;
         SPINNER ;
         MIN      1 ;
         MAX      6 ;
         PICTURE  "9" ;
         VALID    ( aTmp[ _NTARLIN ] >= 1 .AND. aTmp[ _NTARLIN ] <= 6 );
         WHEN     ( nMode != ZOOM_MODE .and. ( lUsrMaster() .or. oUser():lCambiarPrecio() ) );
         ON CHANGE( ChangeTarifa( aTmp, aGet, aTmpSat ), RecalculaLinea( aTmp, aTmpSat, nDouDiv, oTotal, oRentLin, cCodDiv ) );
         OF       oFld:aDialogs[1]

      /*
      Para el caso de alquieres vamos a utilizar su precio---------------------
      */

      REDEFINE GET aGet[ _NIMPTRN ] VAR aTmp[ _NIMPTRN ] ;
         ID       350 ;
         IDSAY    351 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE .AND. !lTotLin ) ;
         ON CHANGE( RecalculaLinea( aTmp, aTmpSat, nDouDiv, oTotal, oRentLin, cCodDiv ) );
         VALID    ( RecalculaLinea( aTmp, aTmpSat, nDouDiv, oTotal, oRentLin, cCodDiv ) );
         PICTURE  cPouDiv ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[_NPNTVER] VAR aTmp[_NPNTVER] ;
         ID       151 ;
         IDSAY    152 ;
         SPINNER ;
         PICTURE  cPpvDiv ;
         ON CHANGE( RecalculaLinea( aTmp, aTmpSat, nDouDiv, oTotal, oRentLin, cCodDiv ) );
         VALID    ( RecalculaLinea( aTmp, aTmpSat, nDouDiv, oTotal, oRentLin, cCodDiv ) );
         WHEN     ( nMode != ZOOM_MODE .and. !lTotLin ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _NFACCNV ] VAR aTmp[ _NFACCNV ] ;
         ID       295 ;
         WHEN     ( nMode != ZOOM_MODE .AND. !lTotLin ) ;
         PICTURE  "@E 999,999.999999";
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _NPESOKG ] VAR aTmp[ _NPESOKG ];
         ID       160 ;
         WHEN     ( nMode != ZOOM_MODE .AND. !lTotLin ) ;
         PICTURE  "@E 999,999.999999";
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CPESOKG ] VAR aTmp[ _CPESOKG ];
         ID       175 ;
         WHEN     ( nMode != ZOOM_MODE .AND. !lTotLin ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _NVOLUMEN ] VAR aTmp[ _NVOLUMEN ] ;
         ID       400 ;
         WHEN     ( nMode != ZOOM_MODE .AND. !lTotLin) ;
         PICTURE  "@E 999,999.999999";
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CVOLUMEN ] VAR aTmp[ _CVOLUMEN ] ;
         ID       410;
         WHEN     ( nMode != ZOOM_MODE .AND. !lTotLin ) ;
         COLOR    CLR_GET ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[_NDTO] VAR aTmp[_NDTO] ;
         ID       180 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE .and. !lTotLin ) ;
         ON CHANGE( RecalculaLinea( aTmp, aTmpSat, nDouDiv, oTotal, oRentLin, cCodDiv ) );
         VALID    ( RecalculaLinea( aTmp, aTmpSat, nDouDiv, oTotal, oRentLin, cCodDiv ) );
         PICTURE  "@E 999.99" ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _NDTOPRM ] VAR aTmp[ _NDTOPRM ] ;
         ID       190 ;
         SPINNER ;
         ON CHANGE( RecalculaLinea( aTmp, aTmpSat, nDouDiv, oTotal, oRentLin, cCodDiv ) );
         WHEN     ( nMode != ZOOM_MODE .and. !lTotLin ) ;
         VALID    ( RecalculaLinea( aTmp, aTmpSat, nDouDiv, oTotal, oRentLin, cCodDiv ) );
         PICTURE  "@E 99.99";
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _NCOMAGE ] VAR aTmp[ _NCOMAGE ] ;
         ID       200 ;
         WHEN     ( nMode != ZOOM_MODE .AND. !lTotLin ) ;
         PICTURE  "@E 99.99" ;
         SPINNER ;
         COLOR    CLR_GET ;
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
         ON CHANGE( RecalculaLinea( aTmp, aTmpSat, nDouDiv, oTotal, oRentLin, cCodDiv ) );
         VALID    ( RecalculaLinea( aTmp, aTmpSat, nDouDiv, oTotal, oRentLin, cCodDiv ) .and. aTmp[_NDTODIV] >= 0 );
         WHEN     ( nMode != ZOOM_MODE .AND. !lTotLin ) ;
         PICTURE  cPouDiv ;
         OF       oFld:aDialogs[1]

      REDEFINE GET oTotal VAR nTotSat ;
         ID       220 ;
         COLOR    CLR_GET ;
         WHEN     .F. ;
         PICTURE  cPorDiv ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[_CTIPMOV] VAR aTmp[ _CTIPMOV ] ;
         WHEN     ( nMode != ZOOM_MODE .AND. !lTotLin ) ;
         VALID    ( cTVta( aGet[_CTIPMOV], dbfTVta, oGet2 ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwTVta( aGet[_CTIPMOV], dbfTVta, oGet2 ) ) ;
         ID       290 ;
         OF       oFld:aDialogs[1];
         IDSAY    292

      REDEFINE GET oGet2 VAR cGet2 ;
         ID       291 ;
         WHEN     ( .F. ) ;
         COLOR    CLR_GET ;
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
         WHEN     ( .F. ) ;
         COLOR    CLR_GET ;
         OF       oFld:aDialogs[1]

      /*
      Codigo de almacen--------------------------------------------------------
      */

      REDEFINE GET aGet[_CALMLIN] VAR aTmp[_CALMLIN] ;
         ID       300 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( cAlmacen( aGet[_CALMLIN], , oSayAlm ), if( !uFieldEmpresa( "lNStkAct" ), oStock:lPutStockActual( aTmp[ _CREF ], aTmp[ _CALMLIN ], aTmp[ _CVALPR1 ], aTmp[ _CVALPR2 ], aTmp[ _CLOTE ], aTmp[ _LKITART ], aTmp[ _NCTLSTK ], oStkAct ), .t. ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwAlmacen( aGet[_CALMLIN], oSayAlm ) ) ;
         COLOR    CLR_GET ;
         OF       oFld:aDialogs[1]

      REDEFINE GET oSayAlm VAR cSayAlm ;
         WHEN     .F. ;
         ID       301 ;
         OF       oFld:aDialogs[1]

      REDEFINE GET oStkAct VAR nStkAct ;
         ID       310 ;
         WHEN     .f. ;
         PICTURE  cPicUnd ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[_NMESGRT] VAR aTmp[_NMESGRT] ;
         ID       330 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  "99" ;
         OF       oFld:aDialogs[1]

      /*
      Segunda caja de dialogo--------------------------------------------------
      */

      REDEFINE GET aGet[_NNUMLIN] VAR aTmp[_NNUMLIN] ;
         ID       100 ;
         SPINNER ;
         COLOR    CLR_GET ;
         WHEN     ( nMode == APPD_MODE ) ;
         PICTURE  "9999" ;
         OF       oFld:aDialogs[2]

      REDEFINE CHECKBOX aGet[_LIMPLIN] VAR aTmp[_LIMPLIN]  ;
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

      REDEFINE GET aGet[ _NCOSDIV ] VAR aTmp[ _NCOSDIV ] ;
         ID       320 ;
         WHEN     ( oUser():lAdministrador() .and. nMode != ZOOM_MODE );
         PICTURE  cPouDiv ;
         OF       oFld:aDialogs[1] ;
         IDSAY    321 ;

      REDEFINE GET aGet[ _NPVSATC ] ;
         VAR      aTmp[ _NPVSATC ] ;
         ID       140 ;
         COLOR    CLR_GET ;
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
      Definición de familias y grupos de familias
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

      REDEFINE GET aGet[ _CCODFAM ] VAR aTmp[ _CCODFAM ] ;
         ID       160 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         BITMAP   "LUPA" ;
         VALID    ( oSayFam:cText( RetFld( aTmp[ _CCODFAM  ], dbfFamilia ) ), .t. );
         ON HELP  ( BrwFamilia( aGet[ _CCODFAM ], oSayFam ) );
         OF       oFld:aDialogs[2]

      REDEFINE GET oSayFam VAR cSayFam ;
         WHEN     ( .F. );
         ID       161 ;
         OF       oFld:aDialogs[2]

      REDEFINE GET oRentLin VAR cRentLin ;
         ID       300 ;
         IDSAY    301 ;
         OF       oFld:aDialogs[2]

      REDEFINE CHECKBOX aGet[ _LIMPFRA ] VAR aTmp[ _LIMPFRA ]  ;
         ID       310 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[ 2 ]

      REDEFINE GET aGet[ _CCODFRA ] ;
         VAR      aTmp[ _CCODFRA ] ;
         ID       320 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         BITMAP   "LUPA" ;
         OF       oFld:aDialogs[ 2 ]

         aGet[ _CCODFRA ]:bValid := {|| oFraPub:lValid( aGet[ _CCODFRA ], aGet[ _CTXTFRA ] ) }
         aGet[ _CCODFRA ]:bHelp  := {|| oFraPub:Buscar( aGet[ _CCODFRA ] ) }

      REDEFINE GET aGet[ _CTXTFRA ] ;
         VAR      aTmp[ _CTXTFRA ] ;
         ID       321 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[ 2 ]

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
         OF       oFld:aDialogs[3]

      REDEFINE GET aGet[ _DESCRIP ] VAR aTmp[ _DESCRIP ] ;
         MEMO ;
         ID       110 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[3]

if ( IsMuebles() )

      REDEFINE GET aGet[_CCODPRV] VAR aTmp[_CCODPRV] ;
         ID       800 ;
         WHEN     ( .f. ) ;
         COLOR    CLR_GET ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[_CNOMPRV] VAR aTmp[_CNOMPRV] ;
         ID       801 ;
         WHEN     ( .f. ) ;
         COLOR    CLR_GET ;
         OF       oFld:aDialogs[1]

end if

      REDEFINE BITMAP bmpImage ;
         ID       220 ;
         FILE     ( cFileBitmap( cPatImg(), aTmp[ _CIMAGEN ] ) );
         ON RIGHT CLICK ( bmpImage:lStretch := !bmpImage:lStretch, bmpImage:Refresh() );
         OF       oDlg

         bmpImage:SetColor( , GetSysColor( 15 ) )

      /*
      Botones generales--------------------------------------------------------
      */

      REDEFINE BUTTON oBtn ;
         ID       IDOK ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( SaveDeta( aTmp, aTmpSat, aGet, oDlg, oBrw, bmpImage, nMode, oStkAct, oSayPr1, oSayPr2, oSayVp1, oSayVp2, oGet2, oTotal, oSayLote, cCodArt, oBtn, oBtnSer ) )

      REDEFINE BUTTON ;
         ID       IDCANCEL ;
         OF       oDlg ;
         CANCEL ;
         ACTION   ( oDlg:end() )

      REDEFINE BUTTON ;
         ID       9 ;
         OF       oDlg ;
         ACTION   ( ChmHelp( "Añadir_v" ) )

      REDEFINE BUTTON oBtnSer;
         ID       552 ;
         OF       oDlg ;
         ACTION   ( EditarNumeroSerie( aTmp, oStock, nMode ) )

      if nMode != ZOOM_MODE
         oDlg:AddFastKey( VK_F5, {|| oBtn:SetFocus(), oBtn:Click() } )
         oDlg:AddFastKey( VK_F6, {|| oBtnSer:Click() } )
      end if

      oDlg:AddFastKey( VK_F1, {|| ChmHelp( "Añadir_v" ) } )

      oDlg:bStart := {||   SetDlgMode( aTmp, aGet, nMode, oStkAct, oSayPr1, oSayPr2, oSayVp1, oSayVp2, oGet2, oTotal, aTmpSat, oSayLote, oRentLin ),;
                           if( !Empty( oGetCaducidad ), oGetCaducidad:Hide(), ),;
                           if( !Empty( cCodArtEnt ), aGet[ _CREF ]:lValid(), ),;
                           aGet[ _CUNIDAD ]:lValid() }

   ACTIVATE DIALOG oDlg CENTER ;
         ON INIT  ( EdtDetMenu( aGet[ _CREF ], oDlg ) );
         ON PAINT ( RecalculaLinea( aTmp, aTmpSat, nDouDiv, oTotal, oRentLin, cCodDiv ) )

   EndDetMenu()

RETURN ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

/*
Estudiamos la posiblidades que se pueden dar en una linea de detalle
*/

STATIC FUNCTION SetDlgMode( aTmp, aGet, nMode, oStkAct, oSayPr1, oSayPr2, oSayVp1, oSayVp2, oGet2, oTotal, aTmpSat, oSayLote, oRentLin )

   local cCodArt  := aGet[ _CREF ]:varGet()

   if aGet[ _NCANSAT ] != nil
      if !lUseCaj()
         aGet[ _NCANSAT ]:hide()
      else
         aGet[ _NCANSAT ]:SetText( cNombreCajas() )
      end if
   end if

   if aGet[ _NUNICAJA ] != nil
      aGet[ _NUNICAJA ]:SetText( cNombreUnidades() )
   end if

   if aGet[ _NVALIMP ] != nil
      if !uFieldEmpresa( "lUseImp" )
         aGet[ _NVALIMP ]:Hide()
      else
         if !uFieldEmpresa( "lModImp" )
            aGet[ _NVALIMP ]:Disable()
         end if
      end if
   end if

   if aGet[ _NIMPTRN ] != nil
      if !uFieldEmpresa( "lUsePor" )
         aGet[ _NIMPTRN ]:Hide()
      end if
   end if

   if aGet[ _NPNTVER ] != nil
      if !uFieldEmpresa( "lUsePnt" ) .or. !aTmpSat[ _LOPERPV ]
         aGet[ _NPNTVER ]:Hide()
      end if
   end if

   if aGet[ _NDTODIV ] != nil
      if !uFieldEmpresa( "lDtoLin" )
         aGet[ _NDTODIV ]:Hide()
      end if
   end if

   if oRentLin != nil .and. oUser():lNotRentabilidad()
      oRentLin:Hide()
   end if

   if aTmp[ __LALQUILER ]
      aGet[ _NPREDIV ]:Hide()
      aGet[ _NPREALQ ]:Show()
   end if

   do case
   case nMode == APPD_MODE

      aTmp[ _CREF    ]  := Space( 32 )
      aTmp[ _LIVALIN ]  := aTmpSat[ _LIVAINC ]

      if aGet[ _NNUMLIN ] != nil
         aGet[ _NNUMLIN ]:cText( nLastNum( dbfTmpLin ) )
      end if

      aGet[ _NCANSAT ]:cText( 1 )
      aGet[ _NUNICAJA ]:cText( 1 )
      aGet[ _CALMLIN  ]:cText( aTmpSat[ _CCODALM ] )
      aGet[ _CDETALLE ]:show()

      if aGet[ _MLNGDES ] != nil
         aGet[ _MLNGDES ]:hide()
      end if

      if aGet[ _CLOTE ] != nil
         aGet[ _CLOTE ]:hide()
      end if

      if oSayLote != nil
         oSayLote:Hide()
      end if

      if aTmpSat[ _NREGIVA ] <= 1
         aGet[ _NIVA ]:cText( nIva( dbfIva, cDefIva() ) )
      end if

   case nMode != APPD_MODE .AND. empty( cCodArt )

      aGet[ _CREF    ]:hide()
      aGet[ _CDETALLE]:hide()

      if aGet[ _MLNGDES ] != nil
         aGet[ _MLNGDES ]:show()
      end if

      if aGet[ _CLOTE ] != nil
         aGet[ _CLOTE ]:hide()
      end if

      if oSayLote != nil
         oSayLote:hide()
      end if

   case nMode != APPD_MODE .AND. !empty( cCodArt )

      aGet[ _CREF     ]:show()
      aGet[ _CDETALLE ]:show()
      aGet[ _MLNGDES  ]:hide()

      if aTmp[ _LLOTE ]

         if !Empty( aGet[ _CLOTE ] ) .and. !Empty( oSayLote )
            aGet[ _CLOTE ]:Show()
            oSayLote:Show()
         end if

      else

        if !Empty( aGet[ _CLOTE ] ) .and. !Empty( oSayLote )
            aGet[ _CLOTE ]:Hide()
            oSayLote:Hide()
        end if

      end if

      if oStkAct != nil
         oStock:nPutStockActual( cCodArt, aTmp[ _CALMLIN ], aTmp[ _CVALPR1 ], aTmp[ _CVALPR2 ], aTmp[ _CLOTE ], aTmp[ _LKITART ], aTmp[ _NCTLSTK ], oStkAct )
      end if

   end case

   if !Empty( oStkAct )

      if !uFieldEmpresa( "lNStkAct" )
         oStkAct:Show()
      else
         oStkAct:Hide()
      end if

   end if

   if !lTipMov()

      if aGet[ _CTIPMOV ] != nil
         aGet[ _CTIPMOV ]:hide()
      end if

      if oGet2 != nil
         oGet2:hide()
      end if

   end if

   if !aTmp[ __LALQUILER ]

      if !Empty( aTmp[ _CCODPR1 ] )

         if !Empty( aGet[_CVALPR1 ] )
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

         if !Empty( aGet[_CVALPR1 ] )
            aGet[_CVALPR1 ]:hide()
         end if
         if !Empty( oSayPr1 )
            oSayPr1:hide()
         end if
         if !Empty( oSayVp1 )
            oSayVp1:hide()
         end if

      end if

      if !Empty( aTmp[ _CCODPR2 ] )

         if !Empty( aGet[_CVALPR2 ] )
            aGet[ _CVALPR2 ]:Show()
            aGet[ _CVALPR2 ]:lValid()
         end if

         if !Empty( oSayPr2 )
            oSayPr2:Show()
            oSayPr2:SetText( retProp(  aTmp[_CCODPR2], dbfPro ) )
         end if

         if !Empty( oSayVp2 )
            oSayVp2:Show()
         end if

      else

         if !Empty( aGet[_CVALPR2 ] )
            aGet[_CVALPR2 ]:hide()
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
   Mostramos u ocultamos las tarifas por líneas--------------------------------
   */

   if Empty( aTmp[ _NTARLIN ] )
      if !Empty( aGet[ _NTARLIN ] )
         aGet[ _NTARLIN ]:cText( aTmpSat[ _NTARIFA ] )
      else
         aTmp[ _NTARLIN ]     := aTmpSat[ _NTARIFA ]
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
   Focus y validación----------------------------------------------------------
   */

   if aGet[ _CTIPMOV ] != nil
      aGet[ _CTIPMOV ]:lValid()
   end if

   if aGet[ _CALMLIN ] != nil
      aGet[ _CALMLIN ]:lValid()
   end if

   aGet[ _CREF ]:SetFocus()

   if !lAccArticulo() .or. oUser():lNotCostos()

      if !Empty( aGet[ _NCOSDIV ] )
         aGet[ _NCOSDIV ]:Hide()
      end if

   end if

   /*
   Solo pueden modificar los precios los administradores--------------------
   */

   if ( Empty( aTmp[ _NPREDIV ] ) .or. lUsrMaster() .or. oUser():lCambiarPrecio() ) .and. nMode != ZOOM_MODE

      aGet[ _NPREDIV ]:HardEnable()
      aGet[ _NDTO    ]:HardEnable()
      aGet[ _NDTOPRM ]:HardEnable()

      if aGet[ _NIMPTRN ] != nil
         aGet[ _NIMPTRN ]:HardEnable()
      end if

      if aGet[ _NPNTVER ] != nil
         aGet[ _NPNTVER ]:HardEnable()
      end if

      if aGet[ _NDTODIV ] != nil
         aGet[ _NDTODIV ]:HardEnable()
      end if

   else

      aGet[ _NPREDIV ]:HardDisable()
      aGet[ _NDTO    ]:HardDisable()
      aGet[ _NDTOPRM ]:HardDisable()

      if aGet[ _NIMPTRN ] != nil
         aGet[ _NIMPTRN ]:HardDisable()
      end if

      if aGet[ _NPNTVER ] != nil
         aGet[ _NPNTVER ]:HardDisable()
      end if

      if aGet[ _NDTODIV ] != nil
         aGet[ _NDTODIV ]:HardDisable()
      end if

   end if

   // Ocultamos o mostramos las tres unidades de medicion----------------------

   if !Empty( aGet[ ( dbfSatCliL )->( fieldpos( "nMedUno" ) ) ] )
      aGet[ ( dbfSatCliL )->( fieldpos( "nMedUno" ) ) ]:Hide()
   end if

   if !Empty( aGet[ ( dbfSatCliL )->( fieldpos( "nMedDos" ) ) ] )
      aGet[ ( dbfSatCliL )->( fieldpos( "nMedDos" ) ) ]:Hide()
   end if

   if !Empty( aGet[ ( dbfSatCliL )->( fieldpos( "nMedTre" ) ) ] )
      aGet[ ( dbfSatCliL )->( fieldpos( "nMedTre" ) ) ]:Hide()
   end if

   if oUndMedicion:oDbf:Seek(  aTmp[ _CUNIDAD ] )

      if !Empty( aGet[ ( dbfSatCliL )->( fieldpos( "nMedUno" ) ) ] ) .and. oUndMedicion:oDbf:nDimension >= 1 .and. !Empty( oUndMedicion:oDbf:cTextoDim1 )
         aGet[ ( dbfSatCliL )->( fieldpos( "nMedUno" ) ) ]:oSay:SetText( oUndMedicion:oDbf:cTextoDim1 )
         aGet[ ( dbfSatCliL )->( fieldpos( "nMedUno" ) ) ]:Show()
      end if

      if !Empty( aGet[ ( dbfSatCliL )->( fieldpos( "nMedDos" ) ) ] ) .and. oUndMedicion:oDbf:nDimension >= 2 .and. !Empty( oUndMedicion:oDbf:cTextoDim2 )
         aGet[ ( dbfSatCliL )->( fieldpos( "nMedDos" ) ) ]:oSay:SetText( oUndMedicion:oDbf:cTextoDim2 )
         aGet[ ( dbfSatCliL )->( fieldpos( "nMedDos" ) ) ]:Show()
      end if

      if !Empty( aGet[ ( dbfSatCliL )->( fieldpos( "nMedTre" ) ) ] ) .and. oUndMedicion:oDbf:nDimension >= 3 .and. !Empty( oUndMedicion:oDbf:cTextoDim3 )
         aGet[ ( dbfSatCliL )->( fieldpos( "nMedTre" ) ) ]:oSay:SetText( oUndMedicion:oDbf:cTextoDim3 )
         aGet[ ( dbfSatCliL )->( fieldpos( "nMedTre" ) ) ]:Show()
      end if

   end if

Return nil

//--------------------------------------------------------------------------//

STATIC FUNCTION SaveDeta( aTmp, aTmpSat, aGet, oDlg2, oBrw, bmpImage, nMode, oStkAct, oSayPr1, oSayPr2, oSayVp1, oSayVp2, oGet2, oTotal, oSayLote, cCodArt, oBtn, oBtnSer )

   local aXbyStr
   local aClo     := aClone( aTmp )
   local nRec     := ( dbfTmpLin )->( RecNo() )

   oBtn:SetFocus()

   if !aGet[ _CREF ]:lValid()
      return nil
   end if

   if !lMoreIva( aTmp[_NIVA] )
      return nil
   end if

   if Empty( aTmp[ _CALMLIN ] ) .and. !Empty( aTmp[ _CREF ] )
      msgStop( "Código de almacén no puede estar vacío", "Atención" )
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

   if nMode == APPD_MODE

      aTmp[_CREF]    := cCodArt

      if aTmp[ _LLOTE ]
         GraLotArt( aTmp[ _CREF ], dbfArticulo, aTmp[ _CLOTE ] )
      end if

      /*
      Chequeamos las atipicas X * Y--------------------------------------------
      */

      aXbYStr                    := nXbYAtipica( aTmp[ _CREF ], aTmpSat[ _CCODCLI ], aTmp[ _NCANSAT ], aTmp[ _NUNICAJA ], aTmpSat[ _DFECSAT ], dbfCliAtp )

      if aXbYStr[ 1 ] == 0

         /*
         Chequeamos las ofertas por artículos X  *  Y--------------------------
         */

         if !aTmp[ _LLINOFE ]

            aXbyStr              := nXbYOferta( aTmp[ _CREF ], aTmpSat[ _CCODCLI ], aTmpSat[ _CCODGRP ], aTmp[ _NCANSAT ], aTmp[ _NUNICAJA ], aTmpSat[ _DFECSAT ], dbfOferta, 1 )

            if aXbYStr[ 1 ] != 0
               aTmp[ _LLINOFE ]  := .t.
            end if

         end if

         /*
         Chequeamos las ofertas por familia X  *  Y----------------------------
         */

         if !aTmp[ _LLINOFE ]

            aXbyStr              := nXbYOferta( RetFld( aTmp[ _CREF ], dbfArticulo, "FAMILIA", "CODIGO" ), aTmpSat[ _CCODCLI ], aTmpSat[ _CCODGRP ], aTmp[ _NCANSAT ], aTmp[ _NUNICAJA ], aTmpSat[ _DFECSAT ], dbfOferta, 2 )

            if aXbYStr[ 1 ] != 0
               aTmp[ _LLINOFE ]  := .t.
            end if

         end if

         /*
         Chequeamos las ofertas por tipo de artículos X  *  Y------------------
         */

         if !aTmp[ _LLINOFE ]

            aXbyStr              := nXbYOferta( RetFld( aTmp[ _CREF ], dbfArticulo, "CCODTIP", "CODIGO" ), aTmpSat[ _CCODCLI ], aTmpSat[ _CCODGRP ], aTmp[ _NCANSAT ], aTmp[ _NUNICAJA ], aTmpSat[ _DFECSAT ], dbfOferta, 3 )

            if aXbYStr[ 1 ] != 0
               aTmp[ _LLINOFE ]  := .t.
            end if

         end if

         /*
         Chequeamos las ofertas por categoria X  *  Y--------------------------
         */

         if !aTmp[ _LLINOFE ]

            aXbyStr              := nXbYOferta( RetFld( aTmp[ _CREF ], dbfArticulo, "CCODCATE", "CODIGO" ), aTmpSat[ _CCODCLI ], aTmpSat[ _CCODGRP ], aTmp[ _NCANSAT ], aTmp[ _NUNICAJA ], aTmpSat[ _DFECSAT ], dbfOferta, 4 )

            if aXbYStr[ 1 ] != 0
               aTmp[ _LLINOFE ]  := .t.
            end if

         end if

         /*
         Chequeamos las ofertas por temporada X  *  Y--------------------------
         */

         if !aTmp[ _LLINOFE ]

            aXbyStr              := nXbYOferta( RetFld( aTmp[ _CREF ], dbfArticulo, "CCODTEMP", "CODIGO" ), aTmpSat[ _CCODCLI ], aTmpSat[ _CCODGRP ], aTmp[ _NCANSAT ], aTmp[ _NUNICAJA ], aTmpSat[ _DFECSAT ], dbfOferta, 5 )

            if aXbYStr[ 1 ] != 0
               aTmp[ _LLINOFE ]  := .t.
            end if

         end if

         /*
         Chequeamos las ofertas por fabricante X  *  Y-------------------------
         */

         if !aTmp[ _LLINOFE ]

            aXbyStr              := nXbYOferta( RetFld( aTmp[ _CREF ], dbfArticulo, "CCODFAB", "CODIGO" ), aTmpSat[ _CCODCLI ], aTmpSat[ _CCODGRP ], aTmp[ _NCANSAT ], aTmp[ _NUNICAJA ], aTmpSat[ _DFECSAT ], dbfOferta, 6 )

            if aXbYStr[ 1 ] != 0
               aTmp[ _LLINOFE ]  := .t.
            end if

         end if

      end if

      /*
      si tenemos q regalar unidades
      */

      if aXbYStr[ 1 ] != 0 .and. aXbYStr[ 2 ] != 0

         /*
         Tenemos oferta vamos a ver de q tipo
         */

         if aXbyStr[ 1 ] == 1

            /*
            Ofertas de cajas
            */

            aTmp[ _NCANSAT  ] -= aXbyStr[ 2 ]

            WinGather( aTmp, , dbfTmpLin, oBrw, nMode, nil, .f. )

            if aClo[ _LKITART ]
               AppendKit( aClo, aTmpSat )
            end if

            aTmp[ _NCANSAT  ] := aXbYStr[ 2 ]
            aTmp[ _NPREDIV  ] := 0

            WinGather( aTmp, aGet, dbfTmpLin, oBrw, nMode )

            if aClo[ _LKITART ]
               AppendKit( aClo, aTmpSat )
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
               AppendKit( aClo, aTmpSat )
            end if

            if aTmp[ _NUNICAJA ] < 0
               aTmp[ _NUNICAJA ] := -( aXbYStr[ 2 ] )
            else
               aTmp[ _NUNICAJA ] := aXbYStr[ 2 ]
            end if

            aTmp[ _NPREDIV  ] := 0

            WinGather( aTmp, aGet, dbfTmpLin, oBrw, nMode )

            if aClo[ _LKITART ]
               AppendKit( aClo, aTmpSat )
            end if

         end if

      else

         /*
         Guardamos el registro de manera normal
         */

         WinGather( aTmp, aGet, dbfTmpLin, oBrw, nMode )

         if aClo[ _LKITART ]
            AppendKit( aClo, aTmpSat )
         end if

      end if

   else

      aTmp[ _NREQ ]                    := nPReq( dbfIva, aTmp[ _NIVA ] )

      /*
      Guardamos el registro de manera normal-----------------------------------
      */

      WinGather( aTmp, aGet, dbfTmpLin, oBrw, nMode )

   end if

   ( dbfTmpLin )->( dbGoTo( nRec ) )

   /*
   Si estamos a¤adiendo y hay entradas continuas
   */

   cOldCodArt                          := ""
   cOldUndMed                          := ""

   if !Empty( aGet[ _CUNIDAD ] )
      aGet[ _CUNIDAD ]:lValid()
   end if

   /*
   Liberacion del bitmap-------------------------------------------------------
   */

   if bmpImage != nil

      bmpImage:Hide()

      if !Empty( bmpImage:hBitmap )
         PalbmpFree( bmpImage:hBitmap, bmpImage:hPalette )
      endif

   end if

   if nMode == APPD_MODE .and. lEntCon()

      nTotSatCli( nil, dbfSatCliT, dbfTmpLin, dbfIva, dbfDiv, dbfFPago, aTmpSat )

      SetDlgMode( aTmp, aGet, nMode, oStkAct, oSayPr1, oSayPr2, oSayVp1, oSayVp2, oGet2, oTotal, aTmpSat, oSayLote )

      SysRefresh()

      if !Empty( aGet[ _CREF ] )
         aGet[ _CREF ]:SetFocus()
      end if

   else

      oDlg2:end( IDOK )

   end if

RETURN NIL

//--------------------------------------------------------------------------//

Static Function EditarNumeroSerie( aTmp, oStock, nMode )

   with object ( TNumerosSerie() )

      :nMode            := nMode

      :cCodArt          := aTmp[ _CREF    ]
      :cCodAlm          := aTmp[ _CALMLIN ]
      :nNumLin          := aTmp[ _NNUMLIN ]

      :lCompras         := .t.

      :nTotalUnidades   := nTotNSatCli( aTmp )

      :oStock           := oStock

      :uTmpSer          := dbfTmpSer

      :Resource()

   end with

Return ( nil )

//--------------------------------------------------------------------------//

Static Function EdtInc( aTmp, aGet, dbfSatCliI, oBrw, bWhen, bValid, nMode, aTmpSat )

   local oDlg
   local oNomInci
   local cNomInci          := RetFld( aTmp[ ( dbfTmpInc )->( FieldPos( "cCodTip" ) ) ], dbfInci )

   if nMode == APPD_MODE
      aTmp[ ( dbfTmpInc )->( FieldPos( "lAviso" ) ) ]  := .t.
   end if

   if ( "PDA" $ cParamsMain() )
   DEFINE DIALOG oDlg RESOURCE "SATCLI_INC_PDA"
   else
   DEFINE DIALOG oDlg RESOURCE "INCIDENCIA" TITLE LblTitle( nMode ) + "incidencias de S.A.T. a clientes"
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

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

Static Function EdtDoc( aTmp, aGet, dbfSatCliD, oBrw, bWhen, bValid, nMode, aTmpLin )

   local oDlg
   local oRuta
   local oNombre
   local oObservacion

   DEFINE DIALOG oDlg RESOURCE "DOCUMENTOS" TITLE LblTitle( nMode ) + "documento de S.A.T. a cliente"

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

STATIC FUNCTION PrnSerie()

   local oDlg
   local oFmtDoc
   local cFmtDoc     := cFormatoDocumento( ( dbfSatCliT )->cSerSat, "nSatCli", dbfCount )
   local oSayFmt
   local cSayFmt
   local oSerIni
   local oSerFin
   local nRecno      := ( dbfSatCliT )->( recno() )
   local nOrdAnt     := ( dbfSatCliT )->( OrdSetFocus(1) )
   local cSerIni     := ( dbfSatCliT )->cSerSat
   local cSerFin     := ( dbfSatCliT )->cSerSat
   local nDocIni     := ( dbfSatCliT )->nNumSat
   local nDocFin     := ( dbfSatCliT )->nNumSat
   local cSufIni     := ( dbfSatCliT )->cSufSat
   local cSufFin     := ( dbfSatCliT )->cSufSat
   local oPrinter
   local cPrinter    := PrnGetName()
   local lCopiasSat  := .t.
   local lInvOrden   := .f.
   local oNumCop
   local nNumCop     := if( nCopiasDocumento( ( dbfSatCliT )->cSerSat, "nSatCli", dbfCount ) == 0, Max( Retfld( ( dbfSatCliT )->cCodCli, dbfClient, "CopiasF" ), 1 ), nCopiasDocumento( ( dbfSatCliT )->cSerSat, "nSatCli", dbfCount ) )

   if Empty( cFmtDoc )
      cFmtDoc           := cSelPrimerDoc( "SC" )
   end if

   cSayFmt           := cNombreDoc( cFmtDoc )

   DEFINE DIALOG oDlg RESOURCE "IMPSERDOC" TITLE "Imprimir series de S.A.T."

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
      PICTURE  "999999999" ;
      SPINNER ;
      OF       oDlg

   REDEFINE GET nDocFin;
      ID       130 ;
      PICTURE  "999999999" ;
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

   REDEFINE CHECKBOX lCopiasSat ;
      ID       170 ;
      OF       oDlg

   REDEFINE GET oNumCop VAR nNumCop;
      ID       180 ;
      WHEN     !lCopiasSat ;
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
      ON HELP  ( BrwDocumento( oFmtDoc, oSayFmt, "SC" ) ) ;
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
      ACTION   (  StartPrint( SubStr( cFmtDoc, 1, 3 ), cSerIni + Str( nDocIni, 9 ) + cSufIni, cSerFin + Str( nDocFin, 9 ) + cSufFin, oDlg, nil, lCopiasSat, nNumCop, lInvOrden ),;
                  oDlg:end( IDOK ) )

   REDEFINE BUTTON ;
      ID       IDCANCEL ;
      OF       oDlg ;
      CANCEL ;
      ACTION   ( oDlg:end() )

   oDlg:AddFastKey( VK_F5, {|| StartPrint( SubStr( cFmtDoc, 1, 3 ), cSerIni + Str( nDocIni, 9 ) + cSufIni, cSerFin + Str( nDocFin, 9 ) + cSufFin, oDlg, nil, lCopiasSat, nNumCop, lInvOrden ), oDlg:end( IDOK ) } )

   oDlg:bStart := { || oSerIni:SetFocus() }

   ACTIVATE DIALOG oDlg CENTER

   (dbfSatCliT)->( dbGoTo( nRecNo ) )
   (dbfSatCliT)->( ordSetFocus( nOrdAnt ) )

   oWndBrw:oBrw:refresh()

RETURN NIL

//--------------------------------------------------------------------------//

STATIC FUNCTION StartPrint( cFmtDoc, cDocIni, cDocFin, oDlg, cPrinter, lCopiasSat, nNumCop, lInvOrden )

   local nCopyClient

   oDlg:disable()

   if ! lInvOrden

      if ( dbfSatCliT )->( dbSeek( cDocIni, .t. ) )

         while ( dbfSatCliT )->cSerSat + Str( ( dbfSatCliT )->nNumSat ) + ( dbfSatCliT )->cSufSat >= cDocIni   .and. ;
               ( dbfSatCliT )->cSerSat + Str( ( dbfSatCliT )->nNumSat ) + ( dbfSatCliT )->cSufSat <= cDocFin   .and. ;
               !( dbfSatCliT )->( Eof() )

               lChgImpDoc( dbfSatCliT )

            if lCopiasSat

               nCopyClient := if( nCopiasDocumento( ( dbfSatCliT )->cSerSat, "nSatCli", dbfCount ) == 0, Max( Retfld( ( dbfSatCliT )->cCodCli, dbfClient, "CopiasF" ), 1 ), nCopiasDocumento( ( dbfSatCliT )->cSerSat, "nSatCli", dbfCount ) )

               GenSatCli( IS_PRINTER, "Imprimiendo documento : " + ( dbfSatCliT )->cSerSat + Str( ( dbfSatCliT )->nNumSat ) + ( dbfSatCliT )->cSufSat, cFmtDoc, cPrinter, nCopyClient )

            else

               GenSatCli( IS_PRINTER, "Imprimiendo documento : " + ( dbfSatCliT )->cSerSat + Str( ( dbfSatCliT )->nNumSat ) + ( dbfSatCliT )->cSufSat, cFmtDoc, cPrinter, nNumCop )

            end if

            ( dbfSatCliT )->( dbSkip() )

         end do

      end if

   else

      if ( dbfSatCliT )->( dbSeek( cDocFin ) )

         while ( dbfSatCliT )->cSerSat + Str( ( dbfSatCliT )->nNumSat ) + ( dbfSatCliT )->cSufSat >= cDocIni   .and.;
               ( dbfSatCliT )->cSerSat + Str( ( dbfSatCliT )->nNumSat ) + ( dbfSatCliT )->cSufSat <= cDocFin   .and.;
               !( dbfSatCliT )->( Bof() )

               lChgImpDoc( dbfSatCliT )

            if lCopiasSat

               nCopyClient := if( nCopiasDocumento( ( dbfSatCliT )->cSerSat, "nSatCli", dbfCount ) == 0, Max( Retfld( ( dbfSatCliT )->cCodCli, dbfClient, "CopiasF" ), 1 ), nCopiasDocumento( ( dbfSatCliT )->cSerSat, "nSatCli", dbfCount ) )

               GenSatCli( IS_PRINTER, "Imprimiendo documento : " + ( dbfSatCliT )->cSerSat + Str( ( dbfSatCliT )->nNumSat ) + ( dbfSatCliT )->cSufSat, cFmtDoc, cPrinter, nCopyClient )

            else

               GenSatCli( IS_PRINTER, "Imprimiendo documento : " + ( dbfSatCliT )->cSerSat + Str( ( dbfSatCliT )->nNumSat ) + ( dbfSatCliT )->cSufSat, cFmtDoc, cPrinter, nNumCop )

            end if

            ( dbfSatCliT )->( dbSkip( -1 ) )

         end while

      end if

   end if

   oDlg:enable()

RETURN NIL

//--------------------------------------------------------------------------//

FUNCTION nTotSatCli( cSatsupuesto, cSatCliT, cSatCliL, cIva, cDiv, cFPago, aTmp, cDivRet, lPic )

   local nRecno
   local cCodDiv
   local bCondition
   local nTotalArt
   local nDtoEsp
   local nDtoPP
   local nDtoUno
   local nDtoDos
   local nDtoAtp
   local nSbrAtp
   local dFecFac
   local lIvaInc
   local nIvaMan
   local nKgsTrn
   local lPntVer           := .f.
   local nManObr           := 0
   local nTotalLin         := 0
   local nTotalUnd         := 0
   local aTotalDto         := { 0, 0, 0 }
   local aTotalDPP         := { 0, 0, 0 }
   local aTotalUno         := { 0, 0, 0 }
   local aTotalDos         := { 0, 0, 0 }
   local aTotalAtp         := { 0, 0, 0 }
   local lRecargo
   local nTotAcu           := 0
   local n
   local nDescuentosLineas := 0

   DEFAULT cSatCliT        := dbfSatCliT
   DEFAULT cSatCliL        := dbfSatCliL
   DEFAULT cIva            := dbfIva
   DEFAULT cDiv            := dbfDiv
   DEFAULT cFPago          := dbfFPago
   DEFAULT cSatsupuesto    := ( cSatCliT )->cSerSat + Str( ( cSatCliT )->nNumSat ) + ( cSatCliT )->cSufSat
   DEFAULT lPic            := .f.

   if Empty( Select( cSatCliT ) )
      Return ( 0 )
   end if

   if Empty( Select( cSatCliL ) )
      Return ( 0 )
   end if

   if Empty( Select( cIva ) )
      Return ( 0 )
   end if

   if Empty( Select( cDiv ) )
      Return ( 0 )
   end if

   public nTotBrt    := 0
   public nTotSat    := 0
   public nTotDto    := 0
   public nTotDPP    := 0
   public nTotNet    := 0
   public nTotIvm    := 0
   public nTotIva    := 0
   public nTotReq    := 0
   public nTotAge    := 0
   public nTotUno    := 0
   public nTotDos    := 0
   public nTotPnt    := 0
   public nTotTrn    := 0
   public nTotCos    := 0
   public nTotRnt    := 0
   public nTotAtp    := 0
   public nTotPes    := 0
   public nPctRnt    := 0
   public nTotDif    := 0
   public nTotUnd    := 0

   public aTotIva    := { { 0,0,nil,0,0,0,0,0,0 }, { 0,0,nil,0,0,0,0,0,0 }, { 0,0,nil,0,0,0,0,0,0 } }
   public aIvaUno    := aTotIva[ 1 ]
   public aIvaDos    := aTotIva[ 2 ]
   public aIvaTre    := aTotIva[ 3 ]

   public aTotIvm    := { { 0,nil,0 }, { 0,nil,0 }, { 0,nil,0 }, }
   public aIvmUno    := aTotIvm[ 1 ]
   public aIvmDos    := aTotIvm[ 2 ]
   public aIvmTre    := aTotIvm[ 3 ]

   public aImpVto    := {}
   public aDatVto    := {}

   public nNumArt    := 0
   public nNumCaj    := 0

   public nTotalDto  := 0

   public cCtaCli    := cClientCuenta( ( cSatCliT )->cCodCli )

   nRecno            := ( cSatCliL )->( RecNo() )

   if aTmp != nil
      lRecargo       := aTmp[ _LRECARGO]
      nDtoEsp        := aTmp[ _NDTOESP ]
      nDtoPP         := aTmp[ _NDPP    ]
      nDtoUno        := aTmp[ _NDTOUNO ]
      nDtoDos        := aTmp[ _NDTODOS ]
      cCodDiv        := aTmp[ _CDIVSAT ]
      nVdvDiv        := aTmp[ _NVDVSAT ]
      dFecFac        := aTmp[ _DFECSAT ]
      lIvaInc        := aTmp[ _LIVAINC ]
      nIvaMan        := aTmp[ _NIVAMAN ]
      nManObr        := aTmp[ _NMANOBR ]
      nDtoAtp        := aTmp[ _NDTOATP ]
      nSbrAtp        := aTmp[ _NSBRATP ]
      nKgsTrn        := aTmp[ _NKGSTRN ]
      lPntVer        := aTmp[ _LOPERPV ]
      bCondition     := {|| !( cSatCliL )->( eof() ) }
      ( cSatCliL )->( dbGoTop() )
   else
      lRecargo       := ( cSatCliT )->lRecargo
      nDtoEsp        := ( cSatCliT )->nDtoEsp
      nDtoPP         := ( cSatCliT )->nDpp
      nDtoUno        := ( cSatCliT )->nDtoUno
      nDtoDos        := ( cSatCliT )->nDtoDos
      cCodDiv        := ( cSatCliT )->cDivSat
      nVdvDiv        := ( cSatCliT )->nVdvSat
      dFecFac        := ( cSatCliT )->dFecSat
      nIvaMan        := ( cSatCliT )->nIvaMan
      lIvaInc        := ( cSatCliT )->lIvaInc
      nManObr        := ( cSatCliT )->nManObr
      nDtoAtp        := ( cSatCliT )->nDtoAtp
      nSbrAtp        := ( cSatCliT )->nSbrAtp
      nKgsTrn        := ( cSatCliT )->nKgsTrn
      lPntVer        := ( cSatCliT )->lOperPV
      bCondition     := {|| ( cSatCliL )->cSerSat + Str( ( cSatCliL )->nNumSat ) + ( cSatCliL )->cSufSat == cSatsupuesto .and. !( cSatCliL )->( eof() ) }
      ( cSatCliL )->( dbSeek( cSatsupuesto ) )
   end if

   /*
   Cargamos los pictures dependiendo de la moneda
   */

   cPouDiv           := cPouDiv( cCodDiv, cDiv ) // Picture de la divisa redondeada
   cPorDiv           := cPorDiv( cCodDiv, cDiv ) // Picture de la divisa redondeada
   cPpvDiv           := cPpvDiv( cCodDiv, cDiv ) // Picture del punto verde
   nDouDiv           := nDouDiv( cCodDiv, cDiv ) // Decimales
   nRouDiv           := nRouDiv( cCodDiv, cDiv ) // Decimales de redondeo
   nDpvDiv           := nDpvDiv( cCodDiv, cDiv ) // Decimales de redondeo del punto verde

   WHILE Eval( bCondition )

      if lValLine( cSatCliL )

         if ( cSatCliL )->lTotLin

            /*
            Esto es para evitar escirbir en el fichero muchas veces
            */

            if ( cSatCliL )->nSatDiv != nTotalLin .OR. ( cSatCliL )->nUniCaja != nTotalUnd

               if ( cSatCliL )->( dbRLock() )
                  ( cSatCliL )->nSatDiv    := nTotalLin
                  ( cSatCliL )->nUniCaja   := nTotalUnd
                  ( cSatCliL )->( dbUnLock() )
               end if

            end if

            /*
            Limpien------------------------------------------------------------
            */

            nTotalLin         := 0
            nTotalUnd         := 0

         else

            nTotArt           := nTotLSatCli( cSatCliT, cSatCliL, nDouDiv, nRouDiv, , , .f., .f. )
            nTotPnt           := if( lPntVer, nPntLSatCli( cSatCliL, nDpvDiv ), 0 )
            nTotTrn           := nTrnLSatCli( cSatCliL, nDouDiv )
            nTotIvm           := nTotISatCli( cSatCliL, nDouDiv, nRouDiv )
            nTotCos           += nTotCSatCli( cSatCliL, nDouDiv, nRouDiv )
            nTotPes           += nPesLSatCli( cSatCliL )
            nDescuentosLineas += nTotDtoLSatCli( cSatCliL, nDouDiv )

            if aTmp != nil
               nTotAge        += nComLSatCli( aTmp, cSatCliL, nDouDiv, nRouDiv )
            else
               nTotAge        += nComLSatCli( cSatCliT, cSatCliL, nDouDiv, nRouDiv )
            end if

            nNumArt           += nTotNSatCli( cSatCliL )
            nNumCaj           += ( cSatCliL )->nCanSat

            /*
            Acumuladores para las lineas de totales
            */

            nTotUnd           += nTotNSatCli( cSatCliL )

            /*
            Estudio de IGIC-----------------------------------------------------
            */

            DO CASE
            CASE _NPCTIVA1 == nil .OR. _NPCTIVA1 == ( cSatCliL )->nIva
               _NPCTIVA1      := ( cSatCliL )->nIva
               _NPCTREQ1      := ( cSatCliL )->nReq
               _NBRTIVA1      += nTotArt
               _NIVMIVA1      += nTotIvm
               _NTRNIVA1      += nTotTrn
               _NPNTVER1      += nTotPnt

            CASE _NPCTIVA2 == NIL .OR. _NPCTIVA2 == ( cSatCliL )->nIva
               _NPCTIVA2      := ( cSatCliL )->nIva
               _NPCTREQ2      := ( cSatCliL )->nReq
               _NBRTIVA2      += nTotArt
               _NIVMIVA2      += nTotIvm
               _NTRNIVA2      += nTotTrn
               _NPNTVER2      += nTotPnt

            CASE _NPCTIVA3 == NIL .OR. _NPCTIVA3 == ( cSatCliL )->nIva
               _NPCTIVA3      := ( cSatCliL )->nIva
               _NPCTREQ3      := ( cSatCliL )->nReq
               _NBRTIVA3      += nTotArt
               _NIVMIVA3      += nTotIvm
               _NTRNIVA3      += nTotTrn
               _NPNTVER3      += nTotPnt

            END CASE

            /*
            Estudio de IVMH-----------------------------------------------------
            */
            if ( cSatCliL )->nValImp != 0

               do case
                  case aTotIvm[ 1, 2 ] == nil .or. aTotIvm[ 1, 2 ] == ( cSatCliL )->nValImp
                     aTotIvm[ 1, 1 ]      += nTotNSatCli( cSatCliL ) * if( ( cSatCliL )->lVolImp, NotCero( ( cSatCliL )->nVolumen ), 1 )
                     aTotIvm[ 1, 2 ]      := ( cSatCliL )->nValImp
                     aTotIvm[ 1, 3 ]      := aTotIvm[ 1, 1 ] * aTotIvm[ 1, 2 ]

                  case aTotIvm[ 2, 2 ] == nil .or. aTotIvm[ 2, 2 ] == ( cSatCliL )->nValImp
                     aTotIvm[ 2, 1 ]      += nTotNSatCli( cSatCliL ) * if( ( cSatCliL )->lVolImp, NotCero( ( cSatCliL )->nVolumen ), 1 )
                     aTotIvm[ 2, 2 ]      := ( cSatCliL )->nValImp
                     aTotIvm[ 2, 3 ]      := aTotIvm[ 2, 1 ] * aTotIvm[ 2, 2 ]

                  case aTotIvm[ 3, 2 ] == nil .or. aTotIvm[ 3, 2 ] == ( cSatCliL )->nValImp
                     aTotIvm[ 3, 1 ]      += nTotNSatCli( cSatCliL ) * if( ( cSatCliL )->lVolImp, NotCero( ( cSatCliL )->nVolumen ), 1 )
                     aTotIvm[ 3, 2 ]      := ( cSatCliL )->nValImp
                     aTotIvm[ 3, 3 ]      := aTotIvm[ 3, 1 ] * aTotIvm[ 3, 2 ]

               end case

            end if

         end if

      end if

      ( cSatCliL )->( dbSkip() )

   end while

   ( cSatCliL )->( dbGoto( nRecno ) )

   /*
   Ordenamos los IGICS de menor a mayor
   */

   aTotIva           := aSort( aTotIva,,, {|x,y| if( x[3] != nil, x[3], -1 ) > if( y[3] != nil, y[3], -1 )  } )

   _NBASIVA1         := Round( _NBRTIVA1, nRouDiv )
   _NBASIVA2         := Round( _NBRTIVA2, nRouDiv )
   _NBASIVA3         := Round( _NBRTIVA3, nRouDiv )

   nTotBrt           := _NBRTIVA1 + _NBRTIVA2 + _NBRTIVA3

   // aTotIvm           := aSort( aTotIvm,,, {|x,y| if( x[2] != nil, x[2], -1 ) > if( y[2] != nil, y[2], -1 )  } )

   /*
   Descuentos atipicos sobre base
   */

   if nSbrAtp <= 1 .and. nDtoAtp != 0

      aTotalAtp[1]   := Round( _NBASIVA1 * nDtoAtp / 100, nRouDiv )
      aTotalAtp[2]   := Round( _NBASIVA2 * nDtoAtp / 100, nRouDiv )
      aTotalAtp[3]   := Round( _NBASIVA3 * nDtoAtp / 100, nRouDiv )

      nTotAtp        := aTotalAtp[ 1 ] + aTotalAtp[ 2 ] + aTotalAtp[ 3 ]

   end if

   /*
   Descuentos Especiales
   */

   IF nDtoEsp  != 0

      aTotalDto[1]   := Round( _NBASIVA1 * nDtoEsp / 100, nRouDiv )
      aTotalDto[2]   := Round( _NBASIVA2 * nDtoEsp / 100, nRouDiv )
      aTotalDto[3]   := Round( _NBASIVA3 * nDtoEsp / 100, nRouDiv )

      nTotDto        := aTotalDto[1] + aTotalDto[2] + aTotalDto[3]

      _NBASIVA1      -= aTotalDto[1]
      _NBASIVA2      -= aTotalDto[2]
      _NBASIVA3      -= aTotalDto[3]

   END IF

   /*
   Descuentos atipicos sobre Dto General
   */

   if nSbrAtp == 2 .and. nDtoAtp != 0

      aTotalAtp[1]   := Round( _NBASIVA1 * nDtoAtp / 100, nRouDiv )
      aTotalAtp[2]   := Round( _NBASIVA2 * nDtoAtp / 100, nRouDiv )
      aTotalAtp[3]   := Round( _NBASIVA3 * nDtoAtp / 100, nRouDiv )

      nTotAtp        := aTotalAtp[ 1 ] + aTotalAtp[ 2 ] + aTotalAtp[ 3 ]

   end if

   /*
   Descuentos por Pronto Pago estos son los buenos
   */

   IF nDtoPP   != 0

      aTotalDPP[1]   := Round( _NBASIVA1 * nDtoPP / 100, nRouDiv )
      aTotalDPP[2]   := Round( _NBASIVA2 * nDtoPP / 100, nRouDiv )
      aTotalDPP[3]   := Round( _NBASIVA3 * nDtoPP / 100, nRouDiv )

      nTotDPP        := aTotalDPP[1] + aTotalDPP[2] + aTotalDPP[3]

      _NBASIVA1      -= aTotalDPP[1]
      _NBASIVA2      -= aTotalDPP[2]
      _NBASIVA3      -= aTotalDPP[3]

   END IF

   /*
   Descuentos atipicos sobre Dto Pronto Pago
   */

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

      _NBASIVA1      -= aTotalUno[1]
      _NBASIVA2      -= aTotalUno[2]
      _NBASIVA3      -= aTotalUno[3]

   END IF

   /*
   Descuentos atipicos sobre Dto definido 1
   */

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

      _NBASIVA1      -= aTotalDos[1]
      _NBASIVA2      -= aTotalDos[2]
      _NBASIVA3      -= aTotalDos[3]

   END IF

   /*
   Descuentos atipicos sobre Dto definido 2
   */

   if nSbrAtp == 5 .and. nDtoAtp != 0

      aTotalAtp[1]   := Round( _NBASIVA1 * nDtoAtp / 100, nRouDiv )
      aTotalAtp[2]   := Round( _NBASIVA2 * nDtoAtp / 100, nRouDiv )
      aTotalAtp[3]   := Round( _NBASIVA3 * nDtoAtp / 100, nRouDiv )

      nTotAtp        := aTotalAtp[ 1 ] + aTotalAtp[ 2 ] + aTotalAtp[ 3 ]

   end if

   /*
   Estudio de " + cImp() + " para el Gasto despues de los descuentos----------------------
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

   /*
   Una vez echos los descuentos le sumamos los transportes---------------------
   */

   _NBASIVA1         += _NTRNIVA1
   _NBASIVA2         += _NTRNIVA2
   _NBASIVA3         += _NTRNIVA3

   /*
   Una vez echos los descuentos le sumamos el punto verde----------------------
   */

   _NBASIVA1         += _NPNTVER1
   _NBASIVA2         += _NPNTVER2
   _NBASIVA3         += _NPNTVER3

   /*
   Una vez echos los descuentos le sumamos el IVMH-----------------------------
   */

   _NBASIVA1         += _NIVMIVA1
   _NBASIVA2         += _NIVMIVA2
   _NBASIVA3         += _NIVMIVA3

   if !lIvaInc

      /*
      Calculos de IGIC
      */

      _NIMPIVA1      := if( _NPCTIVA1 != NIL, Round( _NBASIVA1 * _NPCTIVA1 / 100, nRouDiv ), 0 )
      _NIMPIVA2      := if( _NPCTIVA2 != NIL, Round( _NBASIVA2 * _NPCTIVA2 / 100, nRouDiv ), 0 )
      _NIMPIVA3      := if( _NPCTIVA3 != NIL, Round( _NBASIVA3 * _NPCTIVA3 / 100, nRouDiv ), 0 )

      /*
      Calculo de recargo
      */

      if lRecargo
         _NIMSATQ1   := if( _NPCTIVA1 != NIL, Round( _NBASIVA1 * _NPCTREQ1 / 100, nRouDiv ), 0 )
         _NIMSATQ2   := if( _NPCTIVA2 != NIL, Round( _NBASIVA2 * _NPCTREQ2 / 100, nRouDiv ), 0 )
         _NIMSATQ3   := if( _NPCTIVA3 != NIL, Round( _NBASIVA3 * _NPCTREQ3 / 100, nRouDiv ), 0 )
      end if

      _NBASIVA1      -= _NIVMIVA1
      _NBASIVA2      -= _NIVMIVA2
      _NBASIVA3      -= _NIVMIVA3

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
         if _NPCTREQ3 != 0
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

   /*
   Redondeo del neto de la S.A.T.
   */

   nTotNet           := Round( _NBASIVA1 + _NBASIVA2 + _NBASIVA3, nRouDiv )

   /*
   Diferencias de pesos
   */

   if nKgsTrn != 0
      nTotDif        := nKgsTrn - nTotPes
   else
      nTotDif        := 0
   end if

   /*
   Total IVMH
   */

   nTotIvm           := Round( aTotIvm[ 1, 3 ] + aTotIvm[ 2, 3 ] + aTotIvm[ 3, 3 ], nRouDiv )

   /*
   Total Transpote
   */

   nTotTrn           := Round( _NTRNIVA1 + _NTRNIVA2 + _NTRNIVA3, nRouDiv )

   /*
   Total punto verde
   */

   nTotPnt           := Round( _NPNTVER1 + _NPNTVER2 + _NPNTVER3, nRouDiv )

   /*
   Total de IGIC
   */

   nTotIva           := Round( _NIMPIVA1 + _NIMPIVA2 + _NIMPIVA3, nRouDiv )

   /*
   Total de R.E.
   */

   nTotReq           := Round( _NIMSATQ1 + _NIMSATQ2 + _NIMSATQ3, nRouDiv )

   /*
   Total de impuestos
   */

   nTotImp           := nTotIva + nTotReq + nTotIvm

   /*
   Total rentabilidad
   */

   nTotRnt           := Round(  nTotNet - nManObr - nTotAge - nTotPnt - nTotAtp - nTotCos, nRouDiv )

   nPctRnt           := nRentabilidad( nTotNet - nManObr - nTotAge - nTotPnt, nTotAtp, nTotCos )

   /*
   Total facturas
   */

   nTotSat           := nTotNet + nTotImp

   /*
   Total de descuentos del precupuesto-----------------------------------------
   */

   nTotalDto         := nDescuentosLineas + nTotDto + nTotDpp + nTotUno + nTotDos + nTotAtp

   /*
   Estudio de la Forma de Pago
   */

   /*if cFPago != nil                                      .and. ;
      ( cFPago )->( dbSeek( ( cSatCliT )->cCodPgo ) )

      nTotAcu        := nTotSat

      for n := 1 to ( cFPago )->nPlazos

         if n != ( cFPago )->nPlazos
            nTotAcu  -= Round( nTotSat / ( cFPago )->nPlazos, nRouDiv )
         end if

         aAdd( aImpVto, if( n != ( cFPago )->nPlazos, Round( nTotSat / ( cFPago )->nPlazos, nRouDiv ), Round( nTotAcu, nRouDiv ) ) )

         aAdd( aDatVto, dNexDay( dFecFac + ( cFPago )->nPlaUno + ( ( cFPago )->nDiaPla * ( n - 1 ) ), cDbfClient ) )

      next

   end if*/

   ( cSatCliL )->( dbGoTo( nRecno) )

   /*
   Solicitan una divisa distinta a la q se hizo originalmente la factura
   */

   if cDivRet != nil .and. cDivRet != cCodDiv
      nTotNet     := nCnv2Div( nTotNet, cCodDiv, cDivRet, cDiv )
      nTotIvm     := nCnv2Div( nTotIvm, cCodDiv, cDivRet, cDiv )
      nTotIva     := nCnv2Div( nTotIva, cCodDiv, cDivRet, cDiv )
      nTotReq     := nCnv2Div( nTotReq, cCodDiv, cDivRet, cDiv )
      nTotSat     := nCnv2Div( nTotSat, cCodDiv, cDivRet, cDiv )
      nTotPnt     := nCnv2Div( nTotPnt, cCodDiv, cDivRet, cDiv )
      nTotTrn     := nCnv2Div( nTotTrn, cCodDiv, cDivRet, cDiv )
      cPorDiv     := cPorDiv( cDivRet, cDiv )
   end if

RETURN ( if( lPic, Trans( nTotSat, cPorDiv ), nTotSat ) )

//--------------------------------------------------------------------------//

STATIC FUNCTION RecalculaTotal( aTmp )

   nTotSatCli( nil, dbfSatCliT, dbfTmpLin, dbfIva, dbfDiv, dbfFPago, aTmp )

   /*
   Refrescos en Pantalla-------------------------------------------------------
   */

   aTotIva     := aSort( aTotIva,,, {|x,y| x[1] > y[1] } )

   if oBrwIva  != nil
      oBrwIva:Refresh()
   end if

   /*
   Base de la Factura----------------------------------------------------------
   */

   if oGetNet != nil
      oGetNet:SetText( Trans( nTotNet, cPorDiv ) )
   end if

   if oGetIvm != nil
      oGetIvm:SetText( Trans( nTotIvm, cPorDiv ) )
   end if

   if oGetRnt != nil
      oGetRnt:cText( AllTrim( Trans( nTotRnt, cPorDiv ) + Space( 1 ) + AllTrim( cSimDiv( aTmp[ _CDIVSAT ], dbfDiv ) ) + " : " + AllTrim( Trans( nPctRnt, "999.99" ) ) + "%" ) )
   end if

   IF oGetIva != nil
      oGetIva:SetText( Trans( nTotIva, cPorDiv ) )
   END IF

   if oGetReq != nil
      oGetReq:SetText( Trans( nTotReq, cPorDiv ) )
   end if

   if oGetPnt != nil
      oGetPnt:SetText( Trans( nTotPnt, cPorDiv ) )
   end if

   if oGetTrn != nil
      oGetTrn:SetText( Trans( nTotTrn, cPorDiv ) )
   end if

   if oGetTotal != nil
      oGetTotal:SetText( Trans( nTotSat, cPorDiv ) )
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

FUNCTION aTotSatCli( cSat, dbfMaster, dbfLine, dbfIva, dbfDiv, dbfFPago, cDivRet )

   nTotSatCli( cSat, dbfMaster, dbfLine, dbfIva, dbfDiv, dbfFPago, nil, cDivRet )

RETURN ( { nTotNet, nTotIva, nTotReq, nTotSat, nTotPnt, nTotTrn, nTotAge, nTotCos } )

//--------------------------------------------------------------------------//

STATIC FUNCTION LoaArt( aTmp, aGet, aTmpSat, oStkAct, oSayPr1, oSayPr2, oSayVp1, oSayVp2, bmpImage, oSayLote, nMode, lFocused )

   local nDtoAge
   local nImpAtp
   local nImpOfe
   local nCosPro
   local cCodFam
   local cCodArt     := aGet[ _CREF ]:VarGet()
   local cPrpArt
   local nPrePro     := 0
   local nPosComa
   local cProveedor
   local nTarOld     := aTmp[ _NTARLIN ]
   local lChgCodArt  := ( Empty( cOldCodArt ) .or. Rtrim( cOldCodArt ) != Rtrim( cCodArt ) )
   local nNumDto     := 0

   DEFAULT lFocused  := .t.

   if Empty( cCodArt )

      if lRetCodArt()
         MsgStop( "No se pueden añadir lineas sin codificar" )
         return .f.
      end if

      if Empty( aTmp[ _NIVA ] )
         aGet[ _NIVA ]:bWhen     := {|| .t. }
      end if

      aGet[ _CDETALLE ]:Hide()

      if !Empty( aGet[ _MLNGDES ] )
          aGet[ _MLNGDES ]:Show()
      end if

      if lFocused .and. !Empty( aGet[ _MLNGDES ] )
        aGet[ _MLNGDES ]:SetFocus()
      end if

   else

      if lModIva()
         aGet[_NIVA    ]:bWhen   := {|| .t. }
      else
         aGet[_NIVA    ]:bWhen   := {|| .f. }
      end if

      aGet[_CDETALLE]:show()

      if aGet[_MLNGDES ] != nil
         aGet[_MLNGDES ]:hide()
      end if

      /*
      Primero buscamos por codigos de barra
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

            cCodArt := ( dbfArticulo )->Codigo

            aTmp[ _CREF ]        := cCodArt
            aGet[ _CREF ]:cText( cCodArt )

            if ( dbfArticulo )->lMosCom .and. !Empty( ( dbfArticulo )->mComent )
               MsgStop( Trim( ( dbfArticulo )->mComent ) )
            end if

            if !Empty( cProveedor )
               aTmp[ _CCODPRV ]  := cProveedor
               aTmp[ _CNOMPRV ]  := AllTrim( RetProvee( cProveedor ) )
               aTmp[ _CREFPRV ]  := Padr( cRefPrvArt( cCodArt, Padr( cProveedor, 12 ) , dbfArtPrv ), 18 )

if ( IsMuebles() )
               aGet[ _CCODPRV ]:cText( cProveedor )
               aGet[ _CNOMPRV ]:cText( AllTrim( RetProvee( cProveedor ) ) )
               aGet[ _CREFPRV ]:cText( Padr( cRefPrvArt( cCodArt, Padr( cProveedor, 12 ) , dbfArtPrv ), 18 ) )
end if

            else
               aTmp[ _CCODPRV ]  := (dbfArticulo)->cPrvHab
               aTmp[ _CNOMPRV ]  := AllTrim( RetProvee( (dbfArticulo)->cPrvHab ) )
               aTmp[ _CREFPRV ]  := Padr( cRefPrvArt( cCodArt, ( dbfArticulo )->cPrvHab , dbfArtPrv ), 18 )

if ( IsMuebles() )
               aGet[ _CCODPRV ]:cText( (dbfArticulo)->cPrvHab )
               aGet[ _CNOMPRV ]:cText( AllTrim( RetProvee( (dbfArticulo)->cPrvHab ) ) )
               aGet[ _CREFPRV ]:cText( Padr( cRefPrvArt( cCodArt, ( dbfArticulo )->cPrvHab , dbfArtPrv ), 18 ) )
end if

            end if

            /*
            Lotes
            ---------------------------------------------------------------------
            */

            if ( dbfArticulo )->lLote

               if oSayLote != nil
                  oSayLote:Show()
               end if

               if aGet[ _CLOTE ] != nil
                  aGet[ _CLOTE ]:show()
               end if

               if aGet[ _CLOTE ] != nil
                  aGet[ _CLOTE ]:cText( ( dbfArticulo )->cLote )
               else
                  aTmp[ _CLOTE ] := ( dbfArticulo )->cLote
               end if

               aTmp[ _LLOTE ]    := ( dbfArticulo )->lLote

            else

               if oSayLote != nil
                  oSayLote:hide()
               end if

               if aGet[ _CLOTE ] != nil
                  aGet[ _CLOTE ]:hide()
               end if

            end if

            aTmp[_LLOTE   ]      := ( dbfArticulo )->lLote

            /*
            Coger el tipo de venta------------------------------------------------
            */

            aTmp[_LMSGVTA ]      := ( dbfArticulo )->lMsgVta
            aTmp[_LNOTVTA ]      := ( dbfArticulo )->lNotVta

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
            Descripciones largas--------------------------------------------------
            */

            if !Empty( aGet[ _DESCRIP ] )
               aGet[ _DESCRIP ]:cText( ( dbfArticulo )->Descrip )
            else
               aTmp[ _DESCRIP ]     := ( dbfArticulo )->Descrip
            end if

            /*
            Unidades e IGIC--------------------------------------------------------
            */

            if ( dbfArticulo )->nCajEnt != 0
               if  aGet[ _NCANSAT ] != nil
                   aGet[ _NCANSAT ]:cText( ( dbfArticulo )->nCajEnt )
               else
                   aTmp[ _NCANSAT ] := ( dbfArticulo )->nCajEnt

               end if
            end if

            if ( dbfArticulo )->nUniCaja != 0
               if aGet[ _NUNICAJA ] != nil
                  aGet[ _NUNICAJA ]:cText( ( dbfArticulo )->nUniCaja )
               else
                  aTmp[ _NUNICAJA ] := ( dbfArticulo )->nUniCaja
               end if
            end if

            /*
            Satguntamos si el regimen de " + cImp() + " es distinto de Exento
            */

            if aTmpSat[ _NREGIVA ] <= 1

               if aGet[ _NIVA ] != nil
                  aGet[ _NIVA ]:cText( nIva( dbfIva, ( dbfArticulo )->TipoIva ) )
               else
                  aTmp[ _NIVA ] := nIva( dbfIva, ( dbfArticulo )->TipoIva )
               end if

               aTmp[ _NREQ ]     := nReq( dbfIva, ( dbfArticulo )->TipoIva )

            end if

            if aGet[ _CDETALLE ] != nil
               aGet[ _CDETALLE ]:cText( ( dbfArticulo )->Nombre )
            else
               aTmp[ _CDETALLE ] := ( dbfArticulo )->Nombre
            end if

            if aGet[ _MLNGDES ] != nil
               aGet[ _MLNGDES ]:cText( ( dbfArticulo )->Descrip )
            else
               aTmp[ _MLNGDES ]  := ( dbfArticulo )->Descrip
            end if

            /*
            Tratamientos kits-----------------------------------------------------
            */

            if ( dbfArticulo )->lKitArt
               aTmp[ _LKITART ]        := .t.                                             // Marcamos como padre del kit
               aTmp[ _LIMPLIN ]        := lImprimirCompuesto( ( dbfArticulo )->Codigo, dbfArticulo ) // 1 Todos, 2 Compuesto
               aTmp[ _LKITPRC ]        := lPreciosCompuestos( ( dbfArticulo )->Codigo, dbfArticulo ) // 1 Todos, 2 Compuesto

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

               aTmp[ _LIMPLIN ]        := .f.
               if aGet[ _NCTLSTK ] != nil
                  aGet[ _NCTLSTK ]:SetOption( ( dbfArticulo )->nCtlStock )
               else
                  aTmp[ _NCTLSTK ]     := ( dbfArticulo )->nCtlStock
               end if

            end if

            /*
            Impuestos especiales--------------------------------------------------
            */

            if !Empty( ( dbfArticulo )->cCodImp )
               aTmp[ _CCODIMP ]     := ( dbfArticulo )->cCodImp

               if aGet[ _NVALIMP ] != nil
                  aGet[ _NVALIMP ]:cText( oNewImp:nValImp( ( dbfArticulo )->cCodImp, aTmpSat[ _LIVAINC ], aTmp[ _NIVA ] ) )
               else
                  aTmp[ _NVALIMP ]  := oNewImp:nValImp( ( dbfArticulo )->cCodImp, aTmpSat[ _LIVAINC ], aTmp[ _NIVA ] )
               end if

               aTmp[ _LVOLIMP ]     := RetFld( ( dbfArticulo )->cCodImp, oNewImp:oDbf:cAlias, "lIvaVol" )

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
            Buscamos la familia del articulo y anotamos las propiedades-----------
            */

            aTmp[_CCODPR1 ]         := ( dbfArticulo )->cCodPrp1
            aTmp[_CCODPR2 ]         := ( dbfArticulo )->cCodPrp2

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

               if aGet[ _CVALPR1 ] !=  nil
                  aGet[ _CVALPR1 ]:hide()
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
                  aGet[ _CVALPR2 ]:show()
               end if

               if oSayPr2 != nil
                  oSayPr2:SetText( retProp( ( dbfArticulo )->cCodPrp2, dbfPro ) )
                  oSayPr2:Show()
               end if

               if oSayVp2 != nil
                  oSayVp2:SetText( "" )
                  oSayVp2:Show()
               end if

            else

               if aGet[ _CVALPR2 ] != nil
                  aGet[ _CVALPR2 ]:hide()
               end if

               if oSayPr2 != nil
                  oSayPr2:hide()
               end if

               if oSayVp2 != nil
                  oSayVp2:hide()
               end if

            end if

            /*
            Meses de grantia------------------------------------------------------
            */

            if aGet[ _NMESGRT ] != nil
               aGet[ _NMESGRT ]:cText( ( dbfArticulo )->nMesGrt )
            else
               aTmp[ _NMESGRT ]  := ( dbfArticulo )->nMesGrt
            end if

            /*
            Si la comisi¢n del articulo hacia el agente es distinto de cero----
            */

            aGet[ _NCOMAGE ]:cText( aTmpSat[ _NPCTCOMAGE ] )

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
            Buscamos si el articulo tiene factor de conversion--------------------
            */

            if ( dbfArticulo )->lFacCnv
               aTmp[ _NFACCNV ]     := ( dbfArticulo )->nFacCnv
            end if

            /*
            Tomamos el valor del stock y anotamos si nos dejan vender sin stock
            */

            if oStkAct != nil .and. !uFieldEmpresa( "lNStkAct" ) .and. aTmp[ _NCTLSTK ] <= 1
               oStock:nPutStockActual( cCodArt, aTmp[ _CALMLIN ], , , , aTmp[ _LKITART ], aTmp[ _NCTLSTK ], oStkAct )
            end if

            /*
            Imagen del producto---------------------------------------------------
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
            Tipo de articulo---------------------------------------------------
            */

            if aGet[ _CCODTIP ] != nil
               aGet[ _CCODTIP ]:cText( ( dbfArticulo )->cCodTip )
            else
               aTmp[ _CCODTIP ]  := ( dbfArticulo )->cCodTip
            end if

         end if

         /*
         He terminado de meter todo lo que no son precios
         ahora es cuando meteré los precios con todas las opciones posibles
         */

         cPrpArt                 := aTmp[ _CCODPR1 ] + aTmp[ _CCODPR2 ] + aTmp[ _CVALPR1 ] + aTmp[ _CVALPR2 ]

         if ( lChgCodArt ) .or. ( cPrpArt != cOldPrpArt )

            /*
            Obtenemos la familia
            */

            if nMode == APPD_MODE
               cCodFam        := RetFamArt( cCodArt, dbfArticulo )
            else
               cCodFam        := aTmp[ _CCODFAM ]
            end if

            /*
            Cargamos el precio recomendado y el precio de costo
            */

            if aGet[ _NPNTVER ] != nil
               aGet[ _NPNTVER ]:cText( ( dbfArticulo )->nPntVer1 )
            else
               aTmp[ _NPNTVER ]  := ( dbfArticulo )->nPntVer1
            end if

            aTmp[ _NPVSATC ]     := ( dbfArticulo )->PvpRec

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

            nNumDto              := RetFld( aTmpSat[ _CCODCLI ], dbfClient, "nDtoArt" )

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

            /*
            Obtenemos el precio del artículo
            */

            if !aTmp[ __LALQUILER ]

               nPrePro        := nPrePro( aTmp[ _CREF ], aTmp[ _CCODPR1 ], aTmp[ _CVALPR1 ], aTmp[ _CCODPR2 ], aTmp[ _CVALPR2 ], aTmp[ _NTARLIN ], aTmpSat[ _LIVAINC ], dbfArtDiv, dbfTarPreL, aTmpSat[_CCODTAR] )

               if nPrePro == 0
                  aGet[ _NPREDIV ]:cText( nRetPreArt( aTmp[ _NTARLIN ], aTmpSat[ _CDIVSAT ], aTmpSat[_LIVAINC], dbfArticulo, dbfDiv, dbfKit, dbfIva, , aGet[ _NTARLIN ] ) )
               else
                  aGet[ _NPREDIV ]:cText( nPrePro )
               end if

            else

               aGet[ _NPREDIV ]:cText( 0 )
               aGet[ _NPREALQ ]:cText( nPreAlq( aTmp[ _CREF ], aTmp[ _NTARLIN ], aTmpSat[_LIVAINC], dbfArticulo ) )

            end if

            /*
            Usando Tarifas-----------------------------------------------------
            */

            if !Empty( aTmpSat[ _CCODTAR ] )

               /*
               Cojemos el descuento fijo y el precio del Articulo
               */

               nImpOfe     := RetPrcTar( cCodArt, aTmpSat[_CCODTAR], aTmp[_CCODPR1], aTmp[_CCODPR2], aTmp[_CVALPR1], aTmp[_CVALPR2], dbfTarPreL, aTmp[ _NTARLIN ] )
               if nImpOfe  != 0
                  aGet[ _NPREDIV ]:cText( nImpOfe )
               end if

               nImpOfe     := RetPctTar( cCodArt, cCodFam, aTmpSat[_CCODTAR], aTmp[_CCODPR1], aTmp[_CCODPR2], aTmp[_CVALPR1], aTmp[_CVALPR2], dbfTarPreL )
               if nImpOfe  != 0
                  aGet[ _NDTO ]:cText( nImpOfe )
               end if

               nImpOfe     := RetLinTar( cCodArt, cCodFam, aTmpSat[_CCODTAR], aTmp[_CCODPR1], aTmp[_CCODPR2], aTmp[_CVALPR1], aTmp[_CVALPR2], dbfTarPreL )
               if nImpOfe  != 0
                  aGet[ _NDTODIV ]:cText( nImpOfe )
               end if

               nImpOfe     := RetComTar( cCodArt, cCodFam, aTmpSat[_CCODTAR], aTmp[_CCODPR1], aTmp[_CCODPR2], aTmp[_CVALPR1], aTmp[_CVALPR2], aTmpSat[_CCODAGE], dbfTarPreL, dbfTarPreS )
               if nImpOfe  != 0
                  aGet[ _NCOMAGE ]:cText( nImpOfe )
               end if

               /*Descuento de promoci¢n*/

               nImpOfe     := RetDtoPrm( cCodArt, cCodFam, aTmpSat[_CCODTAR], aTmp[_CCODPR1], aTmp[_CCODPR2], aTmp[_CVALPR1], aTmp[_CVALPR2], aTmpSat[_DFECSAT], dbfTarPreL )
               if nImpOfe  != 0
                  aGet[ _NDTOPRM ]:cText( nImpOfe )
               end if

               /*
               Obtenemos el descuento de Agente
               */

               nDtoAge     := RetDtoAge( cCodArt, cCodFam, aTmpSat[_CCODTAR], aTmp[_CCODPR1], aTmp[_CCODPR2], aTmp[_CVALPR1], aTmp[_CVALPR2], aTmpSat[_DFECSAT], aTmpSat[_CCODAGE], dbfTarPreL, dbfTarPreS )
               if nDtoAge  != 0
                  aGet[ _NCOMAGE ]:cText( nDtoAge )
               end if

            end if

            /*
            Atipicas de clientes por artículo
            */

            do case
            case  lSeekAtpArt( aTmpSat[ _CCODCLI ] + cCodArt, aTmp[ _CCODPR1 ] + aTmp[ _CCODPR2 ], aTmp[ _CVALPR1 ] + aTmp[ _CVALPR2 ], aTmpSat[ _DFECSAT ], dbfCliAtp ) .AND. ;
                  ( dbfCliAtp )->lAplSat

               nImpAtp     := nImpAtp( nTarOld, dbfCliAtp, , , aGet[ _NTARLIN ] )
               if nImpAtp  != 0
                  aGet[ _NPREDIV ]:cText( nImpAtp )
               end if

               /*
               Descuentos por tarifas de precios----------------------------
               */

               nImpAtp     := nDtoAtp( nTarOld, dbfCliAtp )
               /*COMENTADO PARA QUE LA ATIPICA SEA LA QUE MANDE*/ 
               //if nImpAtp  != 0
                  aGet[ _NDTO ]:cText( nImpAtp )
               //end if

               /*
               Descuento por promocion--------------------------------------
               */

               if ( dbfCliAtp )->nDprArt != 0
                  aGet[_NDTOPRM]:cText( ( dbfCliAtp )->nDprArt )
               end if

               if ( dbfCliAtp )->nComAge != 0
                  aGet[_NCOMAGE]:cText( ( dbfCliAtp )->nComAge )
               end if

               if ( dbfCliAtp )->nDtoDiv != 0
                  if aGet[ _NDTODIV ] != nil
                     aGet[ _NDTODIV ]:cText( ( dbfCliAtp )->nDtoDiv )
                  else
                     aTmp[ _NDTODIV ]  := ( dbfCliAtp )->nDtoDiv
                  end if
               end if

            /*
            Atipicas de clientes por familias
            */

            case lSeekAtpFam( aTmpSat[ _CCODCLI ] + aTmp[ _CCODFAM ], aTmpSat[ _DFECSAT ], dbfCliAtp ) .and. ;
                  ( dbfCliAtp )->lAplSat

               /*COMENTADO PARA QUE LA ATIPICA SEA LA QUE MANDE*/ 
               //if ( dbfCliAtp )->nDtoArt != 0
                  aGet[_NDTO   ]:cText( ( dbfCliAtp )->nDtoArt )
               //end if

               if ( dbfCliAtp )->nDprArt != 0
                  aGet[_NDTOPRM]:cText( ( dbfCliAtp )->nDprArt )
               end if

               if ( dbfCliAtp )->nComAge != 0
                  aGet[_NCOMAGE]:cText( ( dbfCliAtp )->nComAge )
               end if

               if ( dbfCliAtp )->nDtoDiv != 0
                  if aGet[ _NDTODIV ] != nil
                     aGet[ _NDTODIV ]:cText( ( dbfCliAtp )->nDtoDiv )
                  else
                     aGet[ _NDTODIV ]  := ( dbfCliAtp )->nDtoDiv
                  end if
               end if

            end case

            if oUndMedicion:oDbf:Seek( ( dbfArticulo )->cUnidad )

               if oUndMedicion:oDbf:nDimension >= 1 .and. !Empty( oUndMedicion:oDbf:cTextoDim1 )
                  aGet[ ( dbfSatCliL )->( fieldpos( "nMedUno" ) ) ]:oSay:SetText( oUndMedicion:oDbf:cTextoDim1 )
                  aGet[ ( dbfSatCliL )->( fieldpos( "nMedUno" ) ) ]:cText( ( dbfArticulo )->nLngArt )
                  aGet[ ( dbfSatCliL )->( fieldpos( "nMedUno" ) ) ]:Show()
               else
                  aGet[ ( dbfSatCliL )->( fieldpos( "nMedUno" ) ) ]:cText( 0 )
                  aGet[ ( dbfSatCliL )->( fieldpos( "nMedUno" ) ) ]:Hide()
               end if

               if oUndMedicion:oDbf:nDimension >= 2 .and. !Empty( oUndMedicion:oDbf:cTextoDim2 )
                  aGet[ ( dbfSatCliL )->( fieldpos( "nMedDos" ) ) ]:oSay:SetText( oUndMedicion:oDbf:cTextoDim2 )
                  aGet[ ( dbfSatCliL )->( fieldpos( "nMedDos" ) ) ]:cText( ( dbfArticulo )->nAltArt )
                  aGet[ ( dbfSatCliL )->( fieldpos( "nMedDos" ) ) ]:Show()
               else
                  aGet[ ( dbfSatCliL )->( fieldpos( "nMedDos" ) ) ]:cText( 0 )
                  aGet[ ( dbfSatCliL )->( fieldpos( "nMedDos" ) ) ]:Hide()
               end if

               if oUndMedicion:oDbf:nDimension >= 3 .and. !Empty( oUndMedicion:oDbf:cTextoDim3 )
                  aGet[ ( dbfSatCliL )->( fieldpos( "nMedTre" ) ) ]:oSay:SetText( oUndMedicion:oDbf:cTextoDim3 )
                  aGet[ ( dbfSatCliL )->( fieldpos( "nMedTre" ) ) ]:cText( ( dbfArticulo )->nAncArt )
                  aGet[ ( dbfSatCliL )->( fieldpos( "nMedTre" ) ) ]:Show()
               else
                  aGet[ ( dbfSatCliL )->( fieldpos( "nMedTre" ) ) ]:cText( 0 )
                  aGet[ ( dbfSatCliL )->( fieldpos( "nMedTre" ) ) ]:Hide()
               end if

            else

               aGet[ ( dbfSatCliL )->( fieldpos( "nMedUno" ) ) ]:cText( 0 )
               aGet[ ( dbfSatCliL )->( fieldpos( "nMedUno" ) ) ]:Hide()

               aGet[ ( dbfSatCliL )->( fieldpos( "nMedDos" ) ) ]:cText( 0 )
               aGet[ ( dbfSatCliL )->( fieldpos( "nMedDos" ) ) ]:Hide()

               aGet[ ( dbfSatCliL )->( fieldpos( "nMedTre" ) ) ]:cText( 0 )
               aGet[ ( dbfSatCliL )->( fieldpos( "nMedTre" ) ) ]:Hide()

            end if

         end if

         /*
         Buscamos si hay ofertas-----------------------------------------------
         */

         lBuscaOferta( cCodArt, aGet, aTmp, aTmpSat, dbfOferta, dbfArticulo, dbfDiv, dbfKit, dbfIva  )

         /*
         Cargamos los valores para los cambios---------------------------------
         */

         cOldPrpArt := cPrpArt
         cOldCodArt := cCodArt

         /*
         Solo pueden modificar los precios los administradores-----------------
         */

         if Empty( aTmp[ _NPREDIV ] ) .or. lUsrMaster() .or. oUser():lCambiarPrecio()
            aGet[ _NPREDIV ]:HardEnable()
            aGet[ _NDTO    ]:HardEnable()
            aGet[ _NDTOPRM ]:HardEnable()
            if aGet[ _NIMPTRN ] != nil
               aGet[ _NIMPTRN ]:HardEnable()
            end if
            if aGet[ _NPNTVER ] != nil
               aGet[ _NPNTVER ]:HardEnable()
            end if
            if aGet[ _NDTODIV ] != nil
               aGet[ _NDTODIV ]:HardEnable()
            end if
         else
            aGet[ _NPREDIV ]:HardDisable()
            aGet[ _NDTO    ]:HardDisable()
            aGet[ _NDTOPRM ]:HardDisable()
            if aGet[ _NIMPTRN ] != nil
               aGet[ _NIMPTRN ]:HardDisable()
            end if
            if aGet[ _NPNTVER ] != nil
               aGet[ _NPNTVER ]:HardDisable()
            end if
            if aGet[ _NDTODIV ] != nil
               aGet[ _NDTODIV ]:HardDisable()
            end if
         end if

      else

         MsgStop( "Artículo no encontrado" )
         Return .f.

      end if

   end if

Return .t.

//--------------------------------------------------------------------------//

static function lBuscaOferta( cCodArt, aGet, aTmp, aTmpSat, dbfOferta, dbfArticulo, dbfDiv, dbfKit, dbfIva  )

   local sOfeArt
   local nTotalLinea    := 0


   if ( dbfArticulo )->Codigo == cCodArt .or. ( dbfArticulo )->( dbSeek( cCodArt ) )

      /*
      Buscamos si existen ofertas por artículo----------------------------
      */

      nTotalLinea := RecalculaLinea( aTmp, aTmpSat, nDouDiv, , , aTmpSat[ _CDIVSAT ], .t. )

      sOfeArt     := sOfertaArticulo( cCodArt, aTmpSat[ _CCODCLI ], aTmpSat[ _CCODGRP ], aTmp[ _NUNICAJA ], aTmpSat[ _DFECSAT ], dbfOferta, aTmp[ _NTARLIN ], , aTmp[_CCODPR1], aTmp[_CCODPR2], aTmp[_CVALPR1], aTmp[_CVALPR2], aTmp[ _CDIVSAT ], dbfArticulo, dbfDiv, dbfKit, dbfIva, aTmp[ _NCANSAT ], nTotalLinea )

      if !Empty( sOfeArt ) 
         if ( sOfeArt:nPrecio != 0 )
            aGet[ _NPREDIV ]:cText( sOfeArt:nPrecio )
         end if 
         if ( sOfeArt:nDtoPorcentual != 0 )
            aGet[ _NDTO     ]:cText( sOfeArt:nDtoPorcentual )
         end if 
         if ( sOfeArt:nDtoLineal != 0)
            aGet[ _NDTODIV  ]:cText( sOfeArt:nDtoLineal )
         end if 
         aTmp[ _LLINOFE  ] := .t.
      end if

      if !aTmp[ _LLINOFE ]

         /*
         Buscamos si existen ofertas por familia----------------------------
         */

         sOfeArt     := sOfertaFamilia( ( dbfArticulo )->Familia, aTmpSat[ _CCODCLI ], aTmpSat[ _CCODGRP ], aTmpSat[ _DFECSAT ], dbfOferta, aTmp[ _NTARLIN ], dbfArticulo, aTmp[ _NUNICAJA ], aTmp[ _NCANSAT ], nTotalLinea )

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

      if !aTmp[ _LLINOFE ]

         /*
         Buscamos si existen ofertas por tipos de articulos--------------
         */

         sOfeArt     := sOfertaTipoArticulo( ( dbfArticulo )->cCodTip, aTmpSat[ _CCODCLI ], aTmpSat[ _CCODGRP ], aTmpSat[ _DFECSAT ], dbfOferta, aTmp[ _NTARLIN ], dbfArticulo, aTmp[ _NUNICAJA ], aTmp[ _NCANSAT ], nTotalLinea )

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

      if !aTmp[ _LLINOFE ]

         /*
         Buscamos si existen ofertas por tipos de articulos--------------
         */

         sOfeArt     := sOfertaCategoria( ( dbfArticulo )->cCodCate, aTmpSat[ _CCODCLI ], aTmpSat[ _CCODGRP ], aTmpSat[ _DFECSAT ], dbfOferta, aTmp[ _NTARLIN ], dbfArticulo, aTmp[ _NUNICAJA ], aTmp[ _NCANSAT ], nTotalLinea )

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

      if !aTmp[ _LLINOFE ]

         /*
         Buscamos si existen ofertas por temporadas----------------------
         */

         sOfeArt     := sOfertaTemporada( ( dbfArticulo )->cCodTemp, aTmpSat[ _CCODCLI ], aTmpSat[ _CCODGRP ], aTmpSat[ _DFECSAT ], dbfOferta, aTmp[ _NTARLIN ], dbfArticulo, aTmp[ _NUNICAJA ], aTmp[ _NCANSAT ], nTotalLinea )

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

      if !aTmp[ _LLINOFE ]

         /*
         Buscamos si existen ofertas por fabricantes---------------------------
         */

         sOfeArt     := sOfertaFabricante( ( dbfArticulo )->cCodFab, aTmpSat[ _CCODCLI ], aTmpSat[ _CCODGRP ], aTmpSat[ _DFECSAT ], dbfOferta, aTmp[ _NTARLIN ], dbfArticulo, aTmp[ _NUNICAJA ], aTmp[ _NCANSAT ], nTotalLinea )

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

FUNCTION BrwSatCli( oGet, dbfSatCliT, dbfSatCliL, dbfIva, dbfDiv, dbfFPago, oIva )

   local oDlg
   local oBrw
   local oGet1
   local cGet1
   local nOrd     := GetBrwOpt( "BrwSatCli" )
   local lIva     := oIva:VarGet()
   local oCbxOrd
   local aCbxOrd  := { "Número", "Fecha", "Cliente", "Nombre" }
   local cCbxOrd
   local nOrdAnt
   local nRecAnt

   nOrd           := Min( Max( nOrd, 1 ), len( aCbxOrd ) )
   cCbxOrd        := aCbxOrd[ nOrd ]
   nOrdAnt        := ( dbfSatCliT )->( OrdSetFocus( nOrd ) )
   nRecAnt        := ( dbfSatCliT )->( Recno() )

   ( dbfSatCliT )->( dbSetFilter( {|| !Field->lEstado .and. Field->lIvaInc == lIva }, "!lEstado .and. lIvaInc == lIva" ) )
   ( dbfSatCliT )->( dbGoTop() )

   DEFINE DIALOG oDlg RESOURCE "HELPENTRY" TITLE if( lIva, "S.A.T. de clientes con " + cImp() + " incluido", "S.A.T. de clientes con " + cImp() + " desglosado" )

      REDEFINE GET oGet1 VAR cGet1;
         ID       104 ;
         ON CHANGE( AutoSeek( nKey, nFlags, Self, oBrw, dbfSatCliT, .t., nil, .f. ) );
         VALID    ( OrdClearScope( oBrw, dbfSatCliT ) );
         BITMAP   "FIND" ;
         OF       oDlg

      REDEFINE COMBOBOX oCbxOrd ;
         VAR      cCbxOrd ;
         ID       102 ;
         ITEMS    aCbxOrd ;
         ON CHANGE( ( dbfSatCliT )->( ordSetFocus( oCbxOrd:nAt ) ), oBrw:Refresh(), oGet1:SetFocus() ) ;
         OF       oDlg

      oBrw                 := IXBrowse():New( oDlg )

      oBrw:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrw:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrw:cAlias          := dbfSatCliT
      oBrw:nMarqueeStyle   := 5
      oBrw:cName           := "SAT a cliente.Browse"

      oBrw:bLDblClick      := {|| oDlg:end( IDOK ) }

      oBrw:CreateFromResource( 105 )

      with object ( oBrw:AddCol() )
         :cHeader          := "Número"
         :cSortOrder       := "nNumSat"
         :bEditValue       := {|| ( dbfSatCliT )->cSerSat + "/" + AllTrim( Str( ( dbfSatCliT )->nNumSat ) ) + "/" + ( dbfSatCliT )->cSufSat }
         :nWidth           := 60
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Fecha"
         :cSortOrder       := "dFecSat"
         :bEditValue       := {|| dtoc( ( dbfSatCliT )->dFecSat ) }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Cliente"
         :cSortOrder       := "cCodCli"
         :bEditValue       := {|| AllTrim( ( dbfSatCliT )->cCodCli ) }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Nombre"
         :cSortOrder       := "cNomCli"
         :bEditValue       := {|| AllTrim( ( dbfSatCliT )->cNomCli ) }
         :nWidth           := 300
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Importe"
         :bEditValue       := {|| nTotSatCli( ( dbfSatCliT )->cSerSat + Str( ( dbfSatCliT )->nNumSat ) + ( dbfSatCliT )->cSufSat, dbfSatCliT, dbfSatCliL, dbfIva, dbfDiv, dbfFPago, nil, cDivEmp(), .t. ) }
         :nWidth           := 100
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      REDEFINE BUTTON ;
         ID       IDOK ;
         OF       oDlg ;
         ACTION   ( oDlg:end( IDOK ) )

      REDEFINE BUTTON ;
         ID       IDCANCEL ;
         OF       oDlg ;
         CANCEL ;
         ACTION   ( oDlg:end() )

      REDEFINE BUTTON ;
         ID       500 ;
         OF       oDlg ;
         WHEN     .F.

      REDEFINE BUTTON ;
         ID       501 ;
         OF       oDlg ;
         WHEN     .F.

   oDlg:AddFastKey( VK_F5,       {|| oDlg:end( IDOK ) } )
   oDlg:AddFastKey( VK_RETURN,   {|| oDlg:end( IDOK ) } )

   ACTIVATE DIALOG oDlg ;
      ON INIT ( oBrw:Load() ) ;
      CENTER

   DestroyFastFilter( dbfSatCliT )

   SetBrwOpt( "BrwSatCli", ( dbfSatCliT )->( OrdNumber() ) )

   if oDlg:nResult == IDOK
      oGet:cText( ( dbfSatCliT )->cSerSat + Str( ( dbfSatCliT )->nNumSat ) + ( dbfSatCliT )->cSufSat )
      oGet:lValid()
   end if

   ( dbfSatCliT )->( dbClearFilter() )
   ( dbfSatCliT )->( ordSetFocus( nOrdAnt ) )
   ( dbfSatCliT )->( dbGoTo( nRecAnt ) )

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

FUNCTION ChgSatCli( cSat, nMode, dbfSatCliT )

   local oBlock
   local oError
   local lExito := .T.
   local lClose := .F.

   IF nMode != APPD_MODE .OR. Empty( cSat )
      RETURN NIL
   END IF

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   IF dbfSatCliT == NIL

      USE ( cPatEmp() + "SATCLI.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "SATCLI", @dbfSatCliT ) )
      SET ADSINDEX TO ( cPatEmp() + "SATCLI.CDX" ) ADDITIVE
      lClose := .T.

   END IF

   IF (dbfSatCliT)->( dbSeek( cSat ) )
      if dbDialogLock( dbfSatCliT )
         (dbfSatCliT)->lEstado   := .t.
         (dbfSatCliT)->( dbUnLock() )
      end if
   ELSE
      lExito := .F.
   END IF

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   IF lClose
      CLOSE (dbfSatCliT)
   END IF

RETURN lExito

//-------------------------------------------------------------------------//

/*
Calcula totales en las lineas de Detalle
*/

STATIC FUNCTION RecalculaLinea( aTmp, aTmpSat, nDec, oTotal, oMargen, cCodDiv, lTotal )

   local nCalculo
   local nUnidades
   local nMargen
   local nCosto
   local nRentabilidad
   local nBase    := 0

   DEFAULT lTotal := .f.

   nUnidades      := nTotNSatCli( aTmp )

   if aTmp[ __LALQUILER ]
      nCalculo    := aTmp[ _NPREALQ  ]
   else
      nCalculo    := aTmp[ _NPREDIV  ]
   end if

   nCalculo       -= aTmp[ _NDTODIV  ]

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
   Transporte
   */

   if aTmp[ _NIMPTRN ] != 0
      nCalculo    += aTmp[ _NIMPTRN ] * nUnidades
   end if

   /*
   Descuentos
   */

   IF aTmp[ _NDTO    ] != 0
      nCalculo    -= nCalculo * aTmp[ _NDTO    ] / 100
   END IF

   IF aTmp[ _NDTOPRM ] != 0
      nCalculo    -= nCalculo * aTmp[ _NDTOPRM ] / 100
   END IF

   /*
   Calculo del margen y rentabilidad-------------------------------------------
   */

   nCosto            := nUnidades * aTmp[ _NCOSDIV ]

   if aTmp[ _LIVALIN ] .and. aTmp[ _NIVA ] != 0
      nBase          := nCalculo - Round( nCalculo / ( 100 / aTmp[ _NIVA ] + 1 ), nRouDiv )
   else
      nBase          := nCalculo
   end if

   nMargen           := nBase - nCosto

   if nCalculo == 0
      nRentabilidad  := 0
   else
      nRentabilidad  := nRentabilidad( nCalculo, 0, nCosto )
   end if

   /*
   Punto Verde
   */

   if aTmpSat[ _LOPERPV ] .and. aTmp[ _NPNTVER ] != 0
      nCalculo    += aTmp[ _NPNTVER  ] * nUnidades
   end if

   nCalculo       := Round( nCalculo, nDec )

   if !Empty( oTotal )
      oTotal:cText( nCalculo )
   end if

   if oMargen != nil
      oMargen:cText( AllTrim( Trans( nMargen, cPorDiv ) + Space( 1 ) + AllTrim( cSimDiv( cCodDiv, dbfDiv ) ) + " : " + AllTrim( Trans( nRentabilidad, "999.99" ) ) + "%" ) )
   end if

   if !Empty( oComisionLinea )
      oComisionLinea:cText( Round( ( nMargen * aTmp[ _NCOMAGE ] / 100 ), nRouDiv ) )
   end if

return if( !lTotal, .t., nCalculo )

//---------------------------------------------------------------------------//

FUNCTION nTotUSatCli( uTmpLin, nDec, nVdv )

   local nCalculo       := 0

   DEFAULT uTmpLin      := dbfSatCliL
   DEFAULT nDec         := nDouDiv()
   DEFAULT nVdv         := 1

   do case
      case Valtype( uTmpLin ) == "C"

         if ( uTmpLin )->lAlquiler
            nCalculo    := ( uTmpLin )->nPreAlq
         else
            nCalculo    := ( uTmpLin )->nPreDiv
         end if

      case Valtype( uTmpLin ) == "O"

         if uTmpLin:lAlquiler
            nCalculo    := uTmpLin:nPreAlq
         else
            nCalculo    := uTmpLin:nPreDiv
         end if

   end case

   if nVdv != 0
      nCalculo          := nCalculo / nVdv
   end if

RETURN ( Round( nCalculo, nDec ) )

//---------------------------------------------------------------------------//

FUNCTION nImpUSatCli( uTmpLin, nDec, nVdv, cPorDiv )

   local nCalculo    := 0

   DEFAULT nDec      := 2
   DEFAULT nVdv      := 1

   if ValType( uTmpLin ) == "C"

      if ( uTmpLin )->lAlquiler
         nCalculo    := ( uTmpLin )->nPreAlq
      else
         nCalculo    := ( uTmpLin )->nPreDiv
      end if

      if ( uTmpLin )->lIvaLin

         if ( uTmpLin )->nIva != 0
            nCalculo -= nCalculo / ( 100 / ( uTmpLin )->nIva + 1 )
         end if

         if ( uTmpLin )->nValImp != 0
            nCalculo -= ( uTmpLin )->nValImp
         end if

      end if

   else

      if uTmpLin:lAlquiler
         nCalculo    := uTmpLin:nPreAlq
      else
         nCalculo    := uTmpLin:nPreDiv
      end if

      if uTmpLin:lIvaLin

         if uTmpLin:nIva != 0
            nCalculo -= nCalculo / ( 100 / uTmpLin:nIva + 1 )
         end if

         if uTmpLin:nValImp != 0
            nCalculo -= uTmpLin:nValImp
         end if

      end if

   end if

   nCalculo          := Round( nCalculo / nVdv, nDec )

Return ( if( cPorDiv != nil, Trans( nCalculo, cPorDiv ), nCalculo ) )

//---------------------------------------------------------------------------//

FUNCTION nBrtLSatCli( uTmpLin, nDec, nRec, nVdv, cPorDiv )

   local nCalculo    := 0

   DEFAULT nDec      := 2
   DEFAULT nVdv      := 1

   nCalculo          := nImpUSatCli( uTmpLin, nDec, nVdv, cPorDiv )
   nCalculo          *= nTotNSatCli( uTmpLin )

   nCalculo          := Round( nCalculo / nVdv, nRec )

Return ( if( cPorDiv != nil, Trans( nCalculo, cPorDiv ), nCalculo ) )

//---------------------------------------------------------------------------//

FUNCTION nIvaUSatCli( dbfTmpLin, nDec, nVdv )

   local nCalculo

   DEFAULT nDec   := 0
   DEFAULT nVdv   := 1

   nCalculo       := nTotUSatCli( dbfTmpLin, nDec, nVdv )
   nCalculo       := nCalculo * ( dbfTmpLin )->nIva / 100

   if nVdv != 0
      nCalculo    := nCalculo / nVdv
   end if

RETURN ( Round( nCalculo, nDec ) )

//---------------------------------------------------------------------------//
/*
Devuelve el total de una linea con impuestos incluidos
*/

FUNCTION nTotFSatCli( dbfLin, nDec, nRou, nVdv, lDto, lPntVer, lImpTrn, cPorDiv )

   local nCalculo    := 0

   DEFAULT dbfLin    := dbfSatCliL
   DEFAULT nDec      := nDouDiv()
   DEFAULT nRou      := nRouDiv()
   DEFAULT nVdv      := 1
   DEFAULT lDto      := .t.
   DEFAULT lPntVer   := .t.
   DEFAULT lImpTrn   := .t.

   nCalculo          += nTotLSatCli( dbfLin, nDec, nRou, nVdv, lDto, lPntVer, lImpTrn )
   nCalculo          += nTotISatCli( dbfLin, nDec, nRou, nVdv )

return ( if( cPorDiv != nil, Trans( nCalculo, cPorDiv ), nCalculo ) )

//---------------------------------------------------------------------------//

FUNCTION cDesSatCli( cSatCliL, cSatCliS )

   DEFAULT cSatCliL  := dbfSatCliL
   DEFAULT cSatCliS  := dbfSatCliS

RETURN ( Descrip( cSatCliL, cSatCliS ) )

//---------------------------------------------------------------------------//

FUNCTION nTotLSatCli( cSatCliT, cSatCliL, nDec, nRou, nVdv, lDto, lPntVer, lImpTrn, cPouDiv )

   local nCalculo

   DEFAULT cSatCliT     := dbfSatCliT
   DEFAULT cSatCliL     := dbfSatCliL
   DEFAULT nDec         := nDouDiv()
   DEFAULT nRou         := nRouDiv()
   DEFAULT nVdv         := 1
   DEFAULT lDto         := .t.
   DEFAULT lPntVer      := ( cSatCliT )->lOperPv
   DEFAULT lImpTrn      := .t.

   if ( cSatCliL )->lTotLin

      nCalculo          := nTotUSatCli( cSatCliL, nDec )

   else

      nCalculo          := nTotUSatCli( cSatCliL, nDec ) * nTotNSatCli( cSatCliL )

      /*
      Descuentos---------------------------------------------------------------
      */

      nCalculo          -= Round( ( cSatCliL )->nDtoDiv / nVdv , nDec )

      if ( cSatCliL )->nDto != 0 .AND. lDto
         nCalculo       -= nCalculo * ( cSatCliL )->nDto / 100
      end if

      if ( cSatCliL )->nDtoPrm != 0 .AND. lDto
         nCalculo       -= nCalculo * ( cSatCliL )->nDtoPrm / 100
      end if

      /*
      Punto Verde
      */

      if lPntVer .and. ( cSatCliL )->nPntVer != 0
         nCalculo       += ( cSatCliL )->nPntVer * nTotNSatCli( cSatCliL )
      end if

      /*
      Transporte---------------------------------------------------------------
      */

      if lImpTrn .and. ( cSatCliL )->nImpTrn != 0
         nCalculo       += ( cSatCliL )->nImpTrn * nTotNSatCli( cSatCliL )
      end if

   end if

   if nVdv != 0
      nCalculo          := nCalculo / nVdv
   end if

   if nRou != nil
      nCalculo          := Round( nCalculo, nRou )
   end if

RETURN ( if( cPouDiv != nil, Trans( nCalculo, cPouDiv ), nCalculo ) )

//---------------------------------------------------------------------------//

FUNCTION nTotCSatCli( dbfLine, nDec, nRec, nVdv, cPouDiv )

   local nCalculo       := 0

   DEFAULT nDec         := 0
   DEFAULT nRec         := 0
   DEFAULT nVdv         := 1

   if !( dbfLine )->lKitChl
      nCalculo          := nTotNSatCli( dbfLine )
      nCalculo          *= ( dbfLine )->nCosDiv
   end if

   if nVdv != 0
      nCalculo          := nCalculo / nVdv
   end if

   nCalculo             := Round( nCalculo, nRec )

RETURN ( if( cPouDiv != nil, Trans( nCalculo, cPouDiv ), nCalculo ) )

//---------------------------------------------------------------------------//

FUNCTION nPesLSatCli( cSatCliL )

   local nCalculo    := 0

   DEFAULT cSatCliL  := dbfSatCliL

   if !( cSatCliL )->lTotLin .and. !( cSatCliL )->lControl
      nCalculo       := Abs( nTotNSatCli( cSatCliL ) ) * ( cSatCliL )->nPesoKg
   end if

RETURN ( nCalculo )

//---------------------------------------------------------------------------//

FUNCTION nVolLSatCli( dbfLine )

   local nCalculo    := 0

   if !( dbfLine )->lTotLin .and. !( dbfLine )->lControl
      nCalculo       := nTotNSatCli( dbfLine ) * ( dbfLine )->nVolumen
   end if

RETURN ( nCalculo )

//---------------------------------------------------------------------------//

FUNCTION nIvaLSatCli( dbfT, dbfLin, nDec, nRouDec, nVdv, lDto, lPntVer, lImpTrn, cPouDiv )

   local nCalculo := nTotLSatCli( dbfT, dbfLin, nDec, nRouDec, nVdv, lDto, lPntVer, lImpTrn, cPouDiv )

   if !( dbfLin )->lIvaLin
      nCalculo    := nCalculo * ( dbfLin )->nIva / 100
   else
      nCalculo    -= nCalculo / ( 1 + ( dbfLin )->nIva / 100 )
   end if

RETURN ( if( cPouDiv != nil, Trans( nCalculo, cPouDiv ), nCalculo ) )

//---------------------------------------------------------------------------//

Function nPntUSatCli( dbfTmpLin, nDec, nVdv )

   local nCalculo

   DEFAULT nDec   := 0
   DEFAULT nVdv   := 1

   nCalculo       := ( dbfTmpLin )->nPntVer

   IF nVdv != 0
      nCalculo    := ( dbfTmpLin )->nPntVer / nVdv
   END IF

RETURN ( round( nCalculo, nDec ) )

//---------------------------------------------------------------------------//

FUNCTION nPntLSatCli( dbfLin, nDec, nVdv )

   local nPntVer

   DEFAULT dbfLin    := dbfSatCliL
   DEFAULT nDec      := 2
   DEFAULT nVdv      := 1

   /*
   Punto Verde
   */

   nPntVer           := nPntUSatCli( dbfLin, nDec, nVdv )
   nPntVer           *= nTotNSatCli( dbfLin )

RETURN ( Round( nPntVer, nDec ) )

//---------------------------------------------------------------------------//

FUNCTION nTrnUSatCli( dbfTmpLin, nDec, nVdv )

   local nCalculo

   DEFAULT nDec   := 0
   DEFAULT nVdv   := 1

   nCalculo       := ( dbfTmpLin )->nImpTrn

   IF nVdv != 0
      nCalculo    := nCalculo / nVdv
   END IF

RETURN ( Round( nCalculo, nDec ) )

//---------------------------------------------------------------------------//

FUNCTION nTrnLSatCli( dbfLin, nDec, nRou, nVdv )

   local nImpTrn

   DEFAULT dbfLin    := dbfSatCliL
   DEFAULT nDec      := 2
   DEFAULT nRou      := 2
   DEFAULT nVdv      := 1

   /*
   Punto Verde
   */

   nImpTrn           := nTrnUSatCli( dbfLin, nDec ) * nTotNSatCli( dbfLin )

   IF nVdv != 0
      nImpTrn        := nImpTrn / nVdv
   END IF

RETURN ( Round( nImpTrn, nRou ) )

//---------------------------------------------------------------------------//

FUNCTION nDtoUSatCli( dbfTmpLin, nDec, nVdv )

   local nCalculo := ( dbfTmpLin )->nDtoDiv

   DEFAULT nDec   := 0
   DEFAULT nVdv   := 1

   if nVdv != 0
      nCalculo    /= nVdv
   end if

RETURN ( round( nCalculo, nDec ) )

//---------------------------------------------------------------------------//

STATIC FUNCTION nTotLAgeSat( dbfDetalle )

   local nCalculo := ( dbfDetalle )->nPreDiv * (dbfDetalle)->nUniCaja

   IF lCalCaj()
      nCalculo    *= If( ( dbfDetalle )->nCanSat != 0, ( dbfDetalle )->nCanSat, 1 )
   END IF

   nCalculo       := Round( nCalculo * ( dbfDetalle )->nComAge / 100, 0 )

RETURN ( nCalculo )

//---------------------------------------------------------------------------//

/*
Devuelve en numero de articulos en una linea de detalle
*/

STATIC FUNCTION nTotLNumArt( dbfDetalle )

   local nCalculo := 0

   IF lCalCaj() .AND. (dbfDetalle)->NCANSAT != 0 .AND. (dbfDetalle)->NPreDiv != 0
      nCalculo := (dbfDetalle)->NCANSAT
   END IF

RETURN ( nCalculo )

//---------------------------------------------------------------------------//

FUNCTION mkSatCli( cPath, lAppend, cPathOld, oMeter, bFor )

   local dbfSatCliT
   local dbfSatCliL
   local dbfSatCliI
   local dbfSatCliD
   local oldSatCliT
   local oldSatCliL
   local oldSatCliI
   local oldSatCliD

   if oMeter != NIL
      oMeter:cText   := "Generando Bases"
      sysrefresh()
   end if

   DEFAULT bFor   := {|| .t. }

   CreateFiles( cPath )
   rxSatCli( cPath, oMeter )

   If lAppend .and. lIsDir( cPathOld )

      dbUseArea( .t., cDriver(), cPath + "SATCLIT.DBF", cCheckArea( "SATCLIT", @dbfSatCliT ), .f. )
      if !( dbfSatCliT )->( neterr() )
         ( dbfSatCliT )->( ordListAdd( cPath + "SATCLIT.CDX" ) )
      end if

      dbUseArea( .t., cDriver(), cPath + "SatCliL.DBF", cCheckArea( "SatCliL", @dbfSatCliL ), .f. )
      if !( dbfSatCliL )->( neterr() )
         ( dbfSatCliL )->( ordListAdd( cPath + "SatCliL.CDX" ) )
      end if

      dbUseArea( .t., cDriver(), cPath + "SatCliI.Dbf", cCheckArea( "SatCliI", @dbfSatCliI ), .f. )
      if !( dbfSatCliI )->( neterr() )
         ( dbfSatCliI )->( ordListAdd( cPath + "SatCliI.Cdx" ) )
      end if

      dbUseArea( .t., cDriver(), cPath + "SatCliD.Dbf", cCheckArea( "SatCliD", @dbfSatCliD ), .f. )
      if !( dbfSatCliD )->( neterr() )
         ( dbfSatCliD )->( ordListAdd( cPath + "SatCliD.Cdx" ) )
      end if

      /*
      Bases de datos de la empresa a importar----------------------------------
      */

      dbUseArea( .t., cDriver(), cPathOld + "SatCliT.DBF", cCheckArea( "SatCliT", @oldSatCliT ), .f. )
      if !( dbfSatCliT )->( neterr() )
         ( oldSatCliT )->( ordListAdd( cPathOld + "SatCliT.CDX" ) )
      end if

      dbUseArea( .t., cDriver(), cPathOld + "SatCliL.DBF", cCheckArea( "SatCliL", @oldSatCliL ), .f. )
      if !( oldSatCliL )->( neterr() )
         ( oldSatCliL )->( ordListAdd( cPathOld + "SatCliL.CDX" ) )
      end if

      dbUseArea( .t., cDriver(), cPathOld + "SatCliI.DBF", cCheckArea( "SatCliI", @oldSatCliI ), .f. )
      if !( oldSatCliI )->( neterr() )
         ( oldSatCliI )->( ordListAdd( cPathOld + "SatCliI.CDX"  ) )
      end if

      dbUseArea( .t., cDriver(), cPathOld + "SatCliD.DBF", cCheckArea( "SatCliD", @oldSatCliD ), .f. )
      if !( oldSatCliD )->( neterr() )
         ( oldSatCliD )->( ordListAdd( cPathOld + "SatCliD.CDX"  ) )
      end if

      /*
      Proceso de importacion --------------------------------------------------
      */

      while !( oldSatCliT )->( eof() )

         if eval( bFor, oldSatCliT )

            dbCopy( oldSatCliT, dbfSatCliT, .t. )

            if ( oldSatCliL )->( dbSeek( ( oldSatCliT )->cSerSat + Str( ( oldSatCliT )->nNumSat ) + ( oldSatCliT )->cSufSat ) )
               while ( oldSatCliL )->cSerSat + Str( ( oldSatCliL )->nNumSat ) + ( oldSatCliL )->cSufSat == ( oldSatCliT )->cSerSat + Str( ( oldSatCliT )->nNumSat ) + ( oldSatCliT )->cSufSat .and. !( oldSatCliL )->( eof() )
                  dbCopy( oldSatCliL, dbfSatCliL, .t. )
                  ( oldSatCliL )->( dbSkip() )
               end while
            end if

            if ( oldSatCliI )->( dbSeek( ( oldSatCliT )->cSerSat + Str( ( oldSatCliT )->nNumSat ) + ( oldSatCliT )->cSufSat ) )
               while ( oldSatCliI )->cSerSat + Str( ( oldSatCliI )->nNumSat ) + ( oldSatCliI )->cSufSat == ( oldSatCliT )->cSerSat + Str( ( oldSatCliT )->nNumSat ) + ( oldSatCliT )->cSufSat .and. !( oldSatCliI )->( eof() )
                  dbCopy( oldSatCliI, dbfSatCliI, .t. )
                  ( oldSatCliI )->( dbSkip() )
               end while
            end if

            if ( oldSatCliD )->( dbSeek( ( oldSatCliT )->cSerSat + Str( ( oldSatCliT )->nNumSat ) + ( oldSatCliT )->cSufSat ) )
               while ( oldSatCliD )->cSerSat + Str( ( oldSatCliD )->nNumSat ) + ( oldSatCliD )->cSufSat == ( oldSatCliT )->cSerSat + Str( ( oldSatCliT )->nNumSat ) + ( oldSatCliT )->cSufSat .and. !( oldSatCliI )->( eof() )
                  dbCopy( oldSatCliD, dbfSatCliD, .t. )
                  ( oldSatCliD )->( dbSkip() )
               end while
            end if

         end if

         ( oldSatCliT )->( dbSkip() )

      end while

      ( dbfSatCliT )->( dbCloseArea() )
      ( dbfSatCliL )->( dbCloseArea() )
      ( dbfSatCliI )->( dbCloseArea() )
      ( dbfSatCliD )->( dbCloseArea() )

      ( oldSatCliT )->( dbCloseArea() )
      ( oldSatCliL )->( dbCloseArea() )
      ( oldSatCliI )->( dbCloseArea() )
      ( oldSatCliD )->( dbCloseArea() )

   End If

Return Nil

//---------------------------------------------------------------------------//

FUNCTION rxSatCli( cPath, oMeter )

   local dbfSatCliT

   DEFAULT cPath  := cPatEmp()

   if !lExistTable( cPath + "SATCLIT.DBF" ) .OR. ;
      !lExistTable( cPath + "SATCLIL.DBF" ) .OR. ;
      !lExistTable( cPath + "SATCLII.DBF" ) .OR. ;
      !lExistTable( cPath + "SATCLID.DBF" )
      !lExistTable( cPath + "SATCLIS.DBF" )
      CreateFiles( cPath )
   end if

   fEraseIndex( cPath + "SATCLIT.CDX" )
   fEraseIndex( cPath + "SATCLIL.CDX" )
   fEraseIndex( cPath + "SATCLII.CDX" )
   fEraseIndex( cPath + "SATCLID.CDX" )
   fEraseIndex( cPath + "SatCliS.Cdx" )

   dbUseArea( .t., cDriver(), cPath + "SATCLIT.DBF", cCheckArea( "SATCLIT", @dbfSatCliT ), .f. )
   if !( dbfSatCliT )->( neterr() )
      ( dbfSatCliT )->( __dbPack() )

      ( dbfSatCliT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfSatCliT )->( ordCreate( cPath + "SATCLIT.CDX", "NNUMSAT", "CSERSAT + STR( NNUMSAT ) + CSUFSAT", {|| Field->CSERSAT + STR(Field->NNUMSAT) + Field->CSUFSAT } ) )

      ( dbfSatCliT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfSatCliT )->( ordCreate( cPath + "SATCLIT.CDX", "DFECSAT", "DFECSAT", {|| Field->DFECSAT } ) )

      ( dbfSatCliT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfSatCliT )->( ordCreate( cPath + "SATCLIT.CDX", "CCODCLI", "CCODCLI + Dtos( dFecSat )", {|| Field->CCODCLI + Dtos( Field->dFecSat ) } ) )

      ( dbfSatCliT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfSatCliT )->( ordCreate( cPath + "SATCLIT.CDX", "CNOMCLI", "cNomCli + Dtos( dFecSat )", {|| Field->cNomCli + Dtos( Field->dFecSat ) } ) )

      ( dbfSatCliT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfSatCliT )->( ordCreate( cPath + "SATCLIT.CDX", "cCodObr", "cCodObr", {|| Field->cCodObr } ) )

      ( dbfSatCliT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfSatCliT )->( ordCreate( cPath + "SATCLIT.CDX", "cCodAge", "cCodAge", {|| Field->cCodAge } ) )

      ( dbfSatCliT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfSatCliT )->( ordCreate( cPath + "SATCLIT.CDX", "CTURSAT", "CTURSAT + CSUFSAT + cCodCaj", {|| Field->CTURSAT + Field->CSUFSAT + Field->cCodCaj } ) )

      ( dbfSatCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( dbfSatCliT )->( ordCreate( cPath + "SatCliT.CDX", "lSndDoc", "lSndDoc", {|| Field->lSndDoc } ) )

      ( dbfSatCliT )->( ordCondSet( "!Deleted()", {||!Deleted()}  ) )
      ( dbfSatCliT )->( ordCreate( cPath + "SatCliT.Cdx", "cCodUsr", "cCodUsr + Dtos( dFecCre ) + cTimCre", {|| Field->cCodUsr + Dtos( Field->dFecCre ) + Field->cTimCre } ) )

      ( dbfSatCliT )->( ordCondSet( "!Deleted()", {||!Deleted()}  ) )
      ( dbfSatCliT )->( ordCreate( cPath + "SatCliT.Cdx", "cNumAlb", "cNumAlb", {|| Field->cNumAlb } ) )

      ( dbfSatCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( dbfSatCliT )->( ordCreate( cPath + "SatCliT.Cdx", "iNumSat", "'32' + cSerSat + Str( nNumSat ) + Space( 1 ) + cSufSat", {|| '32' + Field->cSerSat + Str( Field->nNumSat ) + Space( 1 ) + Field->cSufSat } ) )

      ( dbfSatCliT )->( dbCloseArea() )

   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de S.A.T. de clientes" )
   end if

   dbUseArea( .t., cDriver(), cPath + "SATCLIL.DBF", cCheckArea( "SATCLIL", @dbfSatCliT ), .f. )
   if !( dbfSatCliT )->( neterr() )
      ( dbfSatCliT )->( __dbPack() )

      ( dbfSatCliT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfSatCliT )->( ordCreate( cPath + "SatCliL.Cdx", "NNUMSAT", "CSERSAT + STR( NNUMSAT ) + CSUFSAT", {|| Field->CSERSAT + STR( Field->NNUMSAT ) + Field->CSUFSAT } ) )

      ( dbfSatCliT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfSatCliT )->( ordCreate( cPath + "SatCliL.Cdx", "CREF", "CREF", {|| Field->CREF }, ) )

      ( dbfSatCliT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfSatCliT )->( ordCreate( cPath + "SatCliL.Cdx", "Lote", "cLote", {|| Field->cLote }, ) )

      ( dbfSatCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( dbfSatCliT )->( ordCreate( cPath + "SatCliL.Cdx", "iNumSat", "'32' + cSerSat + Str( nNumSat ) + Space( 1 ) + cSufSat", {|| '32' + Field->cSerSat + Str( Field->nNumSat ) + Space( 1 ) + Field->cSufSat } ) )

      ( dbfSatCliT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfSatCliT )->( ordCreate( cPath + "SatCliL.Cdx", "nNumLin", "Str( NNUMSAT ) + Str( nNumLin )", {|| Str( Field->nNumSat ) + Str( Field->nNumLin ) }, ) )

      ( dbfSatCliT )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de S.A.T. de clientes" )
   end if

   dbUseArea( .t., cDriver(), cPath + "SATCLII.DBF", cCheckArea( "SATCLII", @dbfSatCliT ), .f. )
   if !( dbfSatCliT )->( neterr() )
      ( dbfSatCliT )->( __dbPack() )

      ( dbfSatCliT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfSatCliT )->( ordCreate( cPath + "SATCLII.CDX", "NNUMSAT", "CSERSAT + STR( NNUMSAT ) + CSUFSAT", {|| Field->CSERSAT + STR(Field->NNUMSAT) + Field->CSUFSAT } ) )

      ( dbfSatCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( dbfSatCliT )->( ordCreate( cPath + "SatCliI.Cdx", "iNumSat", "'32' + cSerSat + Str( nNumSat ) + Space( 1 ) + cSufSat", {|| '32' + Field->cSerSat + Str( Field->nNumSat ) + Space( 1 ) + Field->cSufSat } ) )

      ( dbfSatCliT )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de S.A.T. de clientes" )
   end if

   dbUseArea( .t., cDriver(), cPath + "SATCLID.DBF", cCheckArea( "SATCLID", @dbfSatCliT ), .f. )
   if !( dbfSatCliT )->( neterr() )
      ( dbfSatCliT )->( __dbPack() )

      ( dbfSatCliT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfSatCliT )->( ordCreate( cPath + "SATCLID.CDX", "NNUMSAT", "CSERSAT + STR( NNUMSAT ) + CSUFSAT", {|| Field->CSERSAT + STR(Field->NNUMSAT) + Field->CSUFSAT } ) )

      ( dbfSatCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( dbfSatCliT )->( ordCreate( cPath + "SatCliD.Cdx", "iNumSat", "'32' + cSerSat + Str( nNumSat ) + Space( 1 ) + cSufSat", {|| '32' + Field->cSerSat + Str( Field->nNumSat ) + Space( 1 ) + Field->cSufSat } ) )

      ( dbfSatCliT )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de S.A.T. de clientes" )
   end if

   dbUseArea( .t., cDriver(), cPath + "SatCliS.Dbf", cCheckArea( "SatCliS", @dbfSatCliT ), .f. )

   if !( dbfSatCliT )->( neterr() )
      ( dbfSatCliT )->( __dbPack() )

      ( dbfSatCliT )->( ordCondSet( "!Deleted()", {||!Deleted()}  ) )
      ( dbfSatCliT )->( ordCreate( cPath + "SatCliS.CDX", "nNumSat", "cSerSat + Str( nNumSat ) + cSufSat + Str( nNumLin )", {|| Field->cSerSat + Str( Field->nNumSat ) + Field->cSufSat + Str( Field->nNumLin ) } ) )

      ( dbfSatCliT )->( ordCondSet( "!Deleted()", {|| ! !Deleted() } ) )
      ( dbfSatCliT )->( ordCreate( cPath + "SatCliS.CDX", "cRefSer", "cRef + cAlmLin + cNumSer", {|| Field->cRef + Field->cAlmLin + Field->cNumSer } ) )

      ( dbfSatCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( dbfSatCliT )->( ordCreate( cPath + "SatCliS.CDX", "cNumSer", "cNumSer", {|| Field->cNumSer } ) )

      ( dbfSatCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( dbfSatCliT )->( ordCreate( cPath + "SatCliS.Cdx", "iNumSat", "'32' + cSerSat + Str( nNumSat ) + Space( 1 ) + cSufSat", {|| '32' + Field->cSerSat + Str( Field->nNumSat ) + Space( 1 ) + Field->cSufSat } ) )

      ( dbfSatCliT )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de numeros de series de Sataranes de clientes" )
   end if

RETURN NIL

//--------------------------------------------------------------------------//

STATIC FUNCTION BeginTrans( aTmp, lIndex )

   local lErrors  := .f.
   local cDbfLin  := "PCliL"
   local cDbfInc  := "PCliI"
   local cDbfDoc  := "PCliD"
   local cDbfSer  := "SCliS"
   local cSat     := aTmp[ _CSERSAT ] + Str( aTmp[ _NNUMSAT ] ) + aTmp[ _CSUFSAT ]
   local oError
   local oBlock   

   DEFAULT lIndex := .t.

   oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )   
   BEGIN SEQUENCE

   cTmpLin        := cGetNewFileName( cPatTmp() + cDbfLin )
   cTmpInc        := cGetNewFileName( cPatTmp() + cDbfInc )
   cTmpDoc        := cGetNewFileName( cPatTmp() + cDbfDoc )
   cTmpSer        := cGetNewFileName( cPatTmp() + cDbfSer )

   /*
   Primero Crear la base de datos local
   */

   dbCreate( cTmpInc, aSqlStruct( aIncSatCli() ), cLocalDriver() )
   dbUseArea( .t., cLocalDriver(), cTmpInc, cCheckArea( cDbfInc, @dbfTmpInc ), .f. )
   if lIndex
      if !NetErr()
         ( dbfTmpInc )->( OrdCondSet( "!Deleted()", {||!Deleted()} ) )
         ( dbfTmpInc )->( OrdCreate( cTmpInc, "Recno", "Str( Recno() )", {|| Str( Recno() ) } ) )
      else
         lErrors     := .t.
      end if
   end if

   dbCreate( cTmpDoc, aSqlStruct( aSatCliDoc() ), cLocalDriver() )
   dbUseArea( .t., cLocalDriver(), cTmpDoc, cCheckArea( cDbfDoc, @dbfTmpDoc ), .f. )
   if lIndex
      if !NetErr()
         ( dbfTmpDoc )->( OrdCondSet( "!Deleted()", {||!Deleted()} ) )
         ( dbfTmpDoc )->( OrdCreate( cTmpDoc, "Recno", "Str( Recno() )", {|| Str( Recno() ) } ) )
      else
         lErrors     := .t.
      end if
   end if

   dbCreate( cTmpLin, aSqlStruct( aColSatCli() ), cLocalDriver() )
   dbUseArea( .t., cLocalDriver(), cTmpLin, cCheckArea( cDbfLin, @dbfTmpLin ), .f. )
   if lIndex
      if !NetErr()

         ( dbfTmpLin )->( OrdCondSet( "!Deleted()", {||!Deleted() } ) )
         ( dbfTmpLin )->( OrdCreate( cTmpLin, "nNumLin", "Str( nNumLin, 4 )", {|| Str( Field->nNumLin ) } ) )

         ( dbfTmpLin )->( OrdCondSet( "!Deleted()", {||!Deleted()} ) )
         ( dbfTmpLin )->( OrdCreate( cTmpLin, "Recno", "Str( Recno() )", {|| Str( Recno() ) } ) )

      else
         lErrors     := .t.
      end if
   end if

   /*
   A¤adimos desde el fichero de lineas
   */

   if ( dbfSatCliL )->( dbSeek( cSat ) )

      while ( ( dbfSatCliL )->cSerSat + Str( ( dbfSatCliL )->NNUMSAT ) + ( dbfSatCliL )->CSUFSAT == cSat .AND. !( dbfSatCliL )->( eof() ) )

         dbPass( dbfSatCliL, dbfTmpLin, .t. )
         ( dbfSatCliL )->( dbSkip() )

      end while

   end if

   ( dbfTmpLin )->( dbGoTop() )

   /*
   A¤adimos desde el fichero de incidencias
   */

   if ( dbfSatCliI )->( dbSeek( cSat ) )

      do while ( ( dbfSatCliI )->cSerSat + Str( ( dbfSatCliI )->NNUMSAT ) + ( dbfSatCliI )->CSUFSAT == cSat .AND. !( dbfSatCliI )->( eof() ) )

         dbPass( dbfSatCliI, dbfTmpInc, .t. )
         ( dbfSatCliI )->( DbSkip() )

      end while

   end if

   ( dbfTmpInc )->( dbGoTop() )

   /*
   A¤adimos desde el fichero de documentos
   */

   if ( dbfSatCliD )->( dbSeek( cSat ) )

      do while ( ( dbfSatCliD )->cSerSat + Str( ( dbfSatCliD )->NNUMSAT ) + ( dbfSatCliD )->CSUFSAT == cSat .AND. !( dbfSatCliD )->( eof() ) )

         dbPass( dbfSatCliD, dbfTmpDoc, .t. )
         ( dbfSatCliD )->( dbSkip() )

      end while

   end if

   ( dbfTmpDoc )->( dbGoTop() )

   /*
   Creamos el fichero de series------------------------------------------------
   */
   
   dbCreate( cTmpSer, aSqlStruct( aSerSatCli() ), cLocalDriver() )

   dbUseArea( .t., cLocalDriver(), cTmpSer, cCheckArea( cDbfSer, @dbfTmpSer ), .f. )

   if !( dbfTmpSer )->( NetErr() )

      ( dbfTmpSer )->( OrdCondSet( "!Deleted()", {||!Deleted() } ) )
      ( dbfTmpSer )->( OrdCreate( cTmpSer, "nNumLin", "Str( nNumLin, 4 ) + cRef", {|| Str( Field->nNumLin, 4 ) + Field->cRef } ) )

      if ( dbfSatCliS )->( dbSeek( cSat ) )

         while ( ( dbfSatCliS )->cSerSat + Str( ( dbfSatCliS )->nNumSat ) + ( dbfSatCliS )->cSufSat == cSat ) .and. !( dbfSatCliS )->( eof() )
      
            dbPass( dbfSatCliS, dbfTmpSer, .t. )
      
            ( dbfSatCliS )->( dbSkip() )
      
         end while
      
      end if

      ( dbfTmpSer )->( dbGoTop() )

   else
      lErrors     := .t.
   end if

   RECOVER USING oError

      msgStop( "Imposible crear tablas temporales" + CRLF + ErrorMessage( oError ) )

      KillTrans()

      lErrors     := .t.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lErrors )

//-----------------------------------------------------------------------//

STATIC FUNCTION EndTrans( aTmp, aGet, nMode, oBrwLin, oBrw, oBrwInc, oDlg )

   local aTabla
   local oError
   local oBlock
   local cSerSat
   local nNumSat
   local cSufSat
   local dFecSat

   if Empty( aTmp[ _CSERSAT ] )
      aTmp[ _CSERSAT ]  := "A"
   end if

   cSerSat              := aTmp[ _CSERSAT ]
   nNumSat              := aTmp[ _NNUMSAT ]
   cSufSat              := aTmp[ _CSUFSAT ]
   dFecSat              := aTmp[ _DFECSAT ]

   /*
   Comprobamos la fecha del documento
   */

   if !lValidaOperacion( aTmp[ _DFECSAT ] )
      Return .f.
   end if

   if Empty( aTmp[ _CCODCLI ] )
      msgStop( "Cliente no puede estar vacío." )
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

   if Empty( aTmp[ _CDIVSAT ] )
      MsgStop( "No puede almacenar documento sin código de divisa." )
      aGet[ _CDIVSAT ]:SetFocus()
      return .f.
   end if

   if Empty( aTmp[ _CCODAGE ] ) .and. lRecogerAgentes()
      msgStop( "Agente no puede estar vacio." )
      aGet[ _CCODAGE ]:SetFocus()
      return .f.
   end if

   if ( dbfTmpLin )->( eof() )
      MsgStop( "No puede almacenar un documento sin lineas." )
      return .f.
   end if

   oDlg:Disable()

   oMsgText( "Archivando" )

   /*
   Anotamos los cambios de estado en las inicidencias--------------------------
   */

   if ( cOldSituacion != aTmp[ _CSITUAC ] )
      ( dbfTmpInc )->( dbAppend() )
      ( dbfTmpInc )->dFecInc     := GetSysDate()
      ( dbfTmpInc )->mDesInc     := "Cambio de estado de " + AllTrim( cOldSituacion ) + " a " + Alltrim( aTmp[ _CSITUAC ] ) + "."
   end if 

   /*
   Quitamos los filtros--------------------------------------------------------
   */

   ( dbfTmpLin )->( dbClearFilter() )

   /*
   Primero hacer el RollBack---------------------------------------------------
   */

   aTmp[ _DFECCRE ]        := Date()
   aTmp[ _CTIMCRE ]        := Time()

   do case
   case nMode == APPD_MODE .or. nMode == DUPL_MODE

      nNumSat              := nNewDoc( cSerSat, dbfSatCliT, "nSatCli", , dbfCount )
      aTmp[ _NNUMSAT ]     := nNumSat

   case nMode == EDIT_MODE

      while ( dbfSatCliL )->( dbSeek( cSerSat + str( nNumSat ) + cSufSat ) ) 
         if dbLock( dbfSatCliL )
            ( dbfSatCliL )->( dbDelete() )
            ( dbfSatCliL )->( dbUnLock() )
         end if
         ( dbfSatCliL )->( dbSkip() )
      end while

      while ( dbfSatCliI )->( dbSeek( cSerSat + str( nNumSat ) + cSufSat ) )
         if dbLock( dbfSatCliI )
            ( dbfSatCliI )->( dbDelete() )
            ( dbfSatCliI )->( dbUnLock() )
         end if
      end while

      while ( dbfSatCliD )->( dbSeek( cSerSat + str( nNumSat ) + cSufSat ) )
         if dbLock( dbfSatCliD )
            ( dbfSatCliD )->( dbDelete() )
            ( dbfSatCliD )->( dbUnLock() )
         end if
      end while

      while ( dbfSatCliS )->( dbSeek( cSerSat + str( nNumSat ) + cSufSat ) )
         if dbLock( dbfSatCliS )
            ( dbfSatCliS )->( dbDelete() )
            ( dbfSatCliS )->( dbUnLock() )
         end if
      end while

   end case

   oMsgProgress()
   oMsgProgress():SetRange( 0, ( dbfTmpLin )->( LastRec() ) )

   /*
   Ahora escribimos en el fichero definitivo-----------------------------------
   */

   ( dbfTmpLin )->( dbGoTop() )
   do while !( dbfTmpLin )->( Eof() )

      dbPass( dbfTmpLin, dbfSatCliL, .t., cSerSat, nNumSat, cSufSat )
      ( dbfTmpLin )->( dbSkip() )

      oMsgProgress():Deltapos(1)

   end while

   /*
   Ahora escribimos en el fichero incidencias----------------------------------
   */

   ( dbfTmpInc )->( dbGoTop() )
   do while !( dbfTmpInc )->( Eof() )

      dbPass( dbfTmpInc, dbfSatCliI, .t., cSerSat, nNumSat, cSufSat )
      ( dbfTmpInc )->( dbSkip() )

   end while

   /*
   Ahora escribimos en el fichero definitivo
   */

   ( dbfTmpDoc )->( dbGoTop() )
   do while !( dbfTmpDoc )->( Eof() )

      dbPass( dbfTmpDoc, dbfSatCliD, .t., cSerSat, nNumSat, cSufSat )

      ( dbfTmpDoc )->( dbSkip() )

   end while

   /*
   Ahora escribimos en el fichero definitivo-----------------------------------
   */

   ( dbfTmpSer )->( dbGoTop() )
   while ( dbfTmpSer )->( !eof() )

      dbPass( dbfTmpSer, dbfSatCliS, .t., cSerSat, nNumSat, cSufSat, dFecSat )

      ( dbfTmpSer )->( dbSkip() )

   end while

   /*
   Guardamos los totales-------------------------------------------------------
   */

   aTmp[ _NTOTNET ]     := nTotNet
   aTmp[ _NTOTIVA ]     := nTotIva
   aTmp[ _NTOTREQ ]     := nTotReq
   aTmp[ _NTOTSAT ]     := nTotSat

   WinGather( aTmp, , dbfSatCliT, , nMode )

   /*
   Escribe los datos pendientes------------------------------------------------
   */

   dbCommitAll()

   oMsgProgress()
   oMsgText()

   EndProgress()

   oDlg:Enable()
   oDlg:End( IDOK )

Return .t.

//------------------------------------------------------------------------//

Static Function KillTrans( oBrwLin )

   /*
   Borramos los ficheros
   */

   if !Empty( dbfTmpLin ) .and. ( dbfTmpLin )->( Used() )
      ( dbfTmpLin )->( dbCloseArea() )
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

   dbfErase( cTmpLin )
   dbfErase( cTmpInc )
   dbfErase( cTmpDoc )
   dbfErase( cTmpSer )

Return .t.

//------------------------------------------------------------------------//

STATIC FUNCTION LoaCli( aGet, aTmp, nMode, oRieCli, oTlfCli )

   local lValid      := .t.
   local cNewCodCli  := aGet[ _CCODCLI ]:VarGet()
   local lChgCodCli  := ( Empty( cOldCodCli ) .or. cOldCodCli != cNewCodCli )

   if Empty( cNewCodCli )
      return .t.
   elseif At( ".", cNewCodCli ) != 0
      cNewCodCli     := PntReplace( aGet[ _CCODCLI ], "0", RetNumCodCliEmp() )
   else
      cNewCodCli     := Rjust( cNewCodCli, "0", RetNumCodCliEmp() )
   end if

   if ( dbfClient )->( dbSeek( cNewCodCli ) )

      if ( dbfClient )->lBlqCli
         msgStop( "Cliente bloqueado, no se pueden realizar operaciones de venta" )
         return .f.
      end if

      if oTlfCli != nil
         oTlfCli:SetText( ( dbfClient )->Telefono )
      end if

      /*
      Asignamos el codigo siempre
      */

      aGet[ _CCODCLI ]:cText( ( dbfClient )->Cod )

      /*
      Color de fondo del cliente-----------------------------------------------
      */

      if ( dbfClient )->nColor != 0
         aGet[ _CNOMCLI ]:SetColor( , ( dbfClient )->nColor )
      end if

      if Empty( aGet[ _CNOMCLI ]:varGet() ) .or. lChgCodCli
         aGet[ _CNOMCLI ]:cText( ( dbfClient )->Titulo )
      end if

      if Empty( aGet[ _CTLFCLI ]:varGet() ) .or. lChgCodCli
         aGet[ _CTLFCLI ]:cText( ( dbfClient )->Telefono )
      end if

      if !Empty( aGet[ _CDIRCLI ] ) .and. ( Empty( aGet[ _CDIRCLI ]:varGet() ) .or. lChgCodCli )
         aGet[ _CDIRCLI ]:cText( ( dbfClient )->Domicilio )
      end if

      if !Empty( aGet[ _CPOBCLI ] ) .and. ( Empty( aGet[ _CPOBCLI ]:varGet() ) .or. lChgCodCli )
         aGet[ _CPOBCLI ]:cText( ( dbfClient )->Poblacion )
      end if

      if !Empty( aGet[ _CPRVCLI ] ) .and. ( Empty( aGet[ _CPRVCLI ]:varGet() ) .or. lChgCodCli )
         aGet[ _CPRVCLI ]:cText( ( dbfClient )->Provincia )
      end if

      if !Empty( aGet[ _CPOSCLI ] ) .and. ( Empty( aGet[ _CPOSCLI ]:varGet() ) .or. lChgCodCli )
         aGet[ _CPOSCLI ]:cText( ( dbfClient )->CodPostal )
      end if

      if !Empty( aGet[_CDNICLI] ) .and. ( Empty( aGet[ _CDNICLI ]:varGet() ) .or. lChgCodCli )
         aGet[ _CDNICLI ]:cText( ( dbfClient )->Nif )
      end if

      if ( Empty( aTmp[_CCODGRP] ) .or. lChgCodCli )
         aTmp[ _CCODGRP ]  := ( dbfClient )->cCodGrp
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

         aTmp[ _NREGIVA ]   := ( dbfClient )->nRegIva

         /*
         Si estamos a¤adiendo cargamos todos los datos del cliente
         */

         if Empty( aTmp[ _CSERSAT ] )

            if !Empty( ( dbfClient )->Serie )
               aGet[ _CSERSAT ]:cText( ( dbfClient )->Serie )
            end if

         else

            if !Empty( ( dbfClient )->Serie ) .and. aTmp[ _CSERSAT ] != ( dbfClient )->Serie .and. ApoloMsgNoYes( "La serie del cliente seleccionado es distinta a la anterior.", "¿Desea cambiar la serie?" )
               aGet[ _CSERSAT ]:cText( ( dbfClient )->Serie )
            end if

         end if

         if !Empty( aGet[ _CCODALM ] )
            if ( Empty( aGet[ _CCODALM ]:varGet() ) .or. lChgCodCli ) .and. !Empty( ( dbfClient )->cCodAlm )
               aGet[ _CCODALM ]:cText( ( dbfClient )->cCodAlm )
               aGet[ _CCODALM ]:lValid()
            end if
         end if

         if aGet[ _CCODTAR ] != nil
            if !Empty( aGet[ _CCODTAR ] ) .and. ( Empty( aGet[ _CCODTAR ]:varGet() ) .or. lChgCodCli ) .and. !Empty( ( dbfClient )->cCodTar )
               aGet[ _CCODTAR ]:cText( ( dbfClient )->cCodTar )
               aGet[ _CCODTAR ]:lValid()
            end if
         end if

         if ( Empty( aGet[ _CCODPGO ]:varGet() ) .or. lChgCodCli ) .and. !Empty( ( dbfClient )->CodPago )
            aGet[ _CCODPGO ]:cText( (dbfClient )->CodPago )
            aGet[ _CCODPGO ]:lValid()
         end if

         if aGet[_CCODAGE] != nil
            if ( Empty( aGet[ _CCODAGE ]:varGet() ) .or. lChgCodCli ) .and. !Empty( ( dbfClient )->cAgente )
               aGet[ _CCODAGE ]:cText( ( dbfClient )->cAgente )
               aGet[ _CCODAGE ]:lValid()
            end if
         end if

         if ( Empty( aGet[ _CCODRUT ]:varGet() ) .or. lChgCodCli ) .and. !Empty( ( dbfClient )->cCodRut )
            aGet[ _CCODRUT ]:cText( ( dbfClient )->cCodRut )
            aGet[ _CCODRUT ]:lValid()
         end if

         if !Empty( aGet[ _NTARIFA ] ) .and. ( Empty( aGet[ _NTARIFA ]:varGet() ) .or. lChgCodCli ) .and. !Empty( ( dbfClient )->nTarifa )
            aGet[ _NTARIFA ]:cText( ( dbfClient )->nTarifa )
         end if

         if !Empty( aGet[ _CCODTRN ] ) .and. ( Empty( aGet[ _CCODTRN ]:varGet() ) .or. lChgCodCli ) .and. !Empty( ( dbfClient )->cCodTrn )
            aGet[ _CCODTRN ]:cText( ( dbfClient )->cCodTrn )
            aGet[ _CCODTRN ]:lValid()
         end if

         if lChgCodCli

            aGet[ _LRECARGO ]:Click( ( dbfClient )->lReq ):Refresh()

            aGet[ _LOPERPV ]:Click( ( dbfClient )->lPntVer ):Refresh()

            if ( dbfClient )->lMosCom .and. !Empty( ( dbfClient )->mComent ) .and. lChgCodCli
               MsgStop( Trim( ( dbfClient )->mComent ) )
            end if

            /*
            Descuentos desde la ficha de cliente----------------------------------
            */

            aGet[ _CDTOESP ]:cText( ( dbfClient )->cDtoEsp )

            aGet[ _NDTOESP ]:cText( ( dbfClient )->nDtoEsp )

            aGet[ _CDPP    ]:cText( ( dbfClient )->cDpp )

            aGet[ _NDPP    ]:cText( ( dbfClient )->nDpp )

            aGet[ _CDTOUNO ]:cText( ( dbfClient )->cDtoUno )

            aGet[ _NDTOUNO ]:cText( ( dbfClient )->nDtoCnt )

            aGet[ _CDTODOS ]:cText( ( dbfClient )->cDtoDos )

            aGet[ _NDTODOS ]:cText( ( dbfClient )->nDtoRap )

            aTmp[ _NDTOATP ]  := ( dbfClient )->nDtoAtp

            aTmp[ _NSBRATP ]  := ( dbfClient )->nSbrAtp

            ShowInciCliente( ( dbfClient )->Cod, dbfCliInc )

         end if

      end if

      cOldCodCli  := ( dbfClient )->Cod

      lValid      := .t.

   ELSE

      msgStop( "Cliente no encontrado", "Cadena buscada : " + cNewCodCli )
      lValid      := .t.

   END IF

RETURN lValid

//----------------------------------------------------------------------------//

STATIC FUNCTION CreateFiles( cPath )

   if !lExistTable( cPath + "SatCliT.Dbf" )
      dbCreate( cPath + "SatCliT.Dbf", aSqlStruct( aItmSatCli() ), cDriver() )
   end if

   if !lExistTable( cPath + "SatCliL.Dbf" )
      dbCreate( cPath + "SatCliL.Dbf", aSqlStruct( aColSatCli() ),  cDriver() )
   end if

   if !lExistTable( cPath + "SatCliI.Dbf" )
      dbCreate( cPath + "SatCliI.Dbf", aSqlStruct( aIncSatCli() ),  cDriver() )
   end if

   if !lExistTable( cPath + "SatCliD.Dbf" )
      dbCreate( cPath + "SatCliD.Dbf", aSqlStruct( aSatCliDoc() ),  cDriver() )
   end if

   if !lExistTable( cPath + "SatCliS.Dbf" )
      dbCreate( cPath + "SatCliS.Dbf", aSqlStruct( aSerSatCli() ),  cDriver() )
   end if

RETURN NIL

//----------------------------------------------------------------------------//

STATIC FUNCTION ChgState( oBrw )

   local nRec

   for each nRec in ( oBrw:aSelected )

      ( dbfSatCliT )->( dbGoTo( nRec ) )

      if dbLock( dbfSatCliT )
         ( dbfSatCliT )->lEstado := !( dbfSatCliT )->lEstado
         ( dbfSatCliT )->( dbRUnlock() )
      end if

   next

   oBrw:Refresh()
   oBrw:SetFocus()

RETURN NIL

//-------------------------------------------------------------------------//
/*
Comprime y envia los documentos
*/

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

static function lGenSatCli( oBrw, oBtn, nDevice )

   local bAction

   DEFAULT nDevice   := IS_PRINTER

   if Empty( oBtn )
      return nil
   end if

   IF !( dbfDoc )->( dbSeek( "SC" ) )

         DEFINE BTNSHELL RESOURCE "DOCUMENT" OF oWndBrw ;
            NOBORDER ;
            ACTION   ( msgStop( "No hay pedidos de proveedores predefinidos" ) );
            TOOLTIP  "No hay documentos" ;
            HOTKEY   "N";
            FROM     oBtn ;
            CLOSED ;
            LEVEL    ACC_EDIT

   ELSE

      WHILE ( dbfDoc )->CTIPO == "SC" .AND. !( dbfDoc )->( eof() )

         bAction  := bGenSatCli( nDevice, "Imprimiendo S.A.T. a clientes", ( dbfDoc )->CODIGO )

         oWndBrw:NewAt( "Document", , , bAction, Rtrim( ( dbfDoc )->cDescrip ) , , , , , oBtn )

         ( dbfDoc )->( dbSkip() )

      END DO

   END IF

   SysRefresh()

return nil

//---------------------------------------------------------------------------//

static function bGenSatCli( nDevice, cTitle, cCodDoc )

   local bGen
   local nDev  := by( nDevice )
   local cTit  := by( cTitle    )
   local cCod  := by( cCodDoc   )

   if nDev == IS_PRINTER
      bGen     := {|| nGenSatCli( nDev, cTit, cCod ) }
   else
      bGen     := {|| GenSatCli( nDev, cTit, cCod ) }
   end if

return ( bGen )

//---------------------------------------------------------------------------//

static function nGenSatCli( nDevice, cTitle, cCodDoc, cPrinter, nCopy )

   local nImpYet     := 1
   local nCopyClient := Retfld( ( dbfSatCliT )->cCodCli, dbfClient, "CopiasF" )

   DEFAULT nDevice   := IS_PRINTER
   DEFAULT nCopy     := Max( nCopyClient, nCopiasDocumento( ( dbfSatCliT )->cSerSat, "nSatCli", dbfCount ) )

   nCopy             := Max( nCopy, 1 )

   while nImpYet <= nCopy
      GenSatCli( nDevice, cTitle, cCodDoc, cPrinter )
      nImpYet++
   end while

   //Funcion para marcar el documento como imprimido
   lChgImpDoc( dbfSatCliT )

return nil

//--------------------------------------------------------------------------//

FUNCTION nTotNSatCli( uDbf )

   local nTotUnd

   DEFAULT uDbf   := dbfSatCliL

   do case
      case ValType( uDbf ) == "A"

         nTotUnd  := NotCaja( uDbf[ _NCANSAT ] )
         nTotUnd  *= uDbf[ _NUNICAJA ]
         nTotUnd  *= NotCero( uDbf[ _NUNDKIT ] )
         nTotUnd  *= NotCero( uDbf[ _NMEDUNO ] )
         nTotUnd  *= NotCero( uDbf[ _NMEDDOS ] )
         nTotUnd  *= NotCero( uDbf[ _NMEDTRE ] )

      case ValType( uDbf ) == "O"

         nTotUnd  := NotCaja( uDbf:nCanSat )
         nTotUnd  *= uDbf:nUniCaja
         nTotUnd  *= NotCero( uDbf:nUndKit )
         nTotUnd  *= NotCero( uDbf:nMedUno )
         nTotUnd  *= NotCero( uDbf:nMedDos )
         nTotUnd  *= NotCero( uDbf:nMedTre )

      otherwise

         nTotUnd  := NotCaja( ( uDbf )->nCanSat )
         nTotUnd  *= ( uDbf )->nUniCaja
         nTotUnd  *= NotCero( ( uDbf )->nUndKit )
         nTotUnd  *= NotCero( ( uDbf )->nMedUno )
         nTotUnd  *= NotCero( ( uDbf )->nMedDos )
         nTotUnd  *= NotCero( ( uDbf )->nMedTre )

   end case

RETURN ( nTotUnd )

//--------------------------------------------------------------------------//

STATIC FUNCTION nClrPane( dbfTmpLin )

   local cClr

   if ( dbfTmpLin )->lControl .or. ( dbfTmpLin )->lTotLin
      cClr     := CLR_BAR
   else
      cClr     := CLR_WHITE
   end if

return cClr

//----------------------------------------------------------------------------//

STATIC FUNCTION nClrText( dbfTmpLin )

   local cClr

   if ( dbfTmpLin )->lKitChl
      cClr     := CLR_GRAY
   else
      cClr     := CLR_BLACK
   end if

return cClr

//----------------------------------------------------------------------------//

FUNCTION nTotISatCli( dbfLin, nDec, nRouDec, nVdv, cPorDiv )

   local nCalculo    := 0

   DEFAULT dbfLin    := dbfSatCliL
   DEFAULT nDec      := 0
   DEFAULT nRouDec   := 0
   DEFAULT nVdv      := 1

   IF !( dbfLin )->LTOTLIN

      /*
      Tomamos los valores redondeados------------------------------------------
      */

      nCalculo       := Round( ( dbfLin )->nValImp, nDec )

      /*
      Unidades-----------------------------------------------------------------
      */

      nCalculo       *= nTotNSatCli( dbfLin )

         if ( dbfLin )->LVOLIMP
            nCalculo *= NotCero( ( dbfLin )->nVolumen )
         end if

      nCalculo       := Round( nCalculo / nVdv, nRouDec )

   END IF

RETURN ( if( cPorDiv != NIL, Trans( nCalculo, cPorDiv ), nCalculo ) )

//----------------------------------------------------------------------------//

FUNCTION nImpLSatCli( uSatCliT, dbfSatCliL, nDec, nRou, nVdv, lIva, lDto, lPntVer, lImpTrn, cPouDiv )

   local nCalculo
   local lIvaInc

   DEFAULT nDec      := 0
   DEFAULT nRou      := 0
   DEFAULT nVdv      := 1
   DEFAULT lIva      := .f.
   DEFAULT lDto      := .t.
   DEFAULT lPntVer   := .f.
   DEFAULT lImpTrn   := .f.

   nCalculo          := nTotLSatCli( uSatCliT, dbfSatCliL, nDec, nRou, nVdv, .t., lPntVer, lImpTrn )

   if ValType( uSatCliT ) == "A"
      nCalculo       -= Round( nCalculo * uSatCliT[ _NDTOESP ]  / 100, nRou )
      nCalculo       -= Round( nCalculo * uSatCliT[ _NDPP    ]  / 100, nRou )
      nCalculo       -= Round( nCalculo * uSatCliT[ _NDTOUNO ]  / 100, nRou )
      nCalculo       -= Round( nCalculo * uSatCliT[ _NDTODOS ]  / 100, nRou )
      lIvaInc        := uSatCliT[ _LIVAINC ]
   else
      nCalculo       -= Round( nCalculo * ( uSatCliT )->nDtoEsp / 100, nRou )
      nCalculo       -= Round( nCalculo * ( uSatCliT )->nDpp    / 100, nRou )
      nCalculo       -= Round( nCalculo * ( uSatCliT )->nDtoUno / 100, nRou )
      nCalculo       -= Round( nCalculo * ( uSatCliT )->nDtoDos / 100, nRou )
      lIvaInc        := ( uSatCliT )->lIvaInc
   end if

   if ( dbfSatCliL )->nIva != 0
      if lIva  // lo quermos con IGIC
         if !lIvaInc
            nCalculo += Round( nCalculo * ( dbfSatCliL )->nIva / 100, nRou )
         end if
      else     // lo queremos sin IGIC
         if lIvaInc
            nCalculo -= Round( nCalculo / ( 100 / ( dbfSatCliL )->nIva  + 1 ), nRou )
         end if
      end if
   end if

RETURN ( if( cPouDiv != nil, Trans( nCalculo, cPouDiv ), nCalculo ) )

//----------------------------------------------------------------------------//

FUNCTION nDtoAtpSatCli( uSatCliT, dbfSatCliL, nDec, nRou, nVdv, lPntVer, lImpTrn )

   local nCalculo    := 0
   local nDtoAtp     := 0

   DEFAULT nDec      := 0
   DEFAULT nRou      := 0
   DEFAULT nVdv      := 1
   DEFAULT lPntVer   := .f.
   DEFAULT lImpTrn   := .f.

   nCalculo          := nTotLSatCli( uSatCliT, dbfSatCliL, nDec, nRou, nVdv, .t., lPntVer, lImpTrn )

   if ( uSatCliT )->nSbrAtp <= 1 .and. ( uSatCliT )->nDtoAtp != 0
      nDtoAtp     += Round( nCalculo * ( uSatCliT )->nDtoAtp / 100, nRou )
   end if

   nCalculo       -= Round( nCalculo * ( uSatCliT )->nDtoEsp / 100, nRou )

   if ( uSatCliT )->nSbrAtp == 2 .and. ( uSatCliT )->nDtoAtp != 0
      nDtoAtp     += Round( nCalculo * ( uSatCliT )->nDtoAtp / 100, nRou )
   end if

   nCalculo       -= Round( nCalculo * ( uSatCliT )->nDpp    / 100, nRou )

   if ( uSatCliT )->nSbrAtp == 3 .and. ( uSatCliT )->nDtoAtp != 0
      nDtoAtp     += Round( nCalculo * ( uSatCliT )->nDtoAtp / 100, nRou )
   end if

   nCalculo       -= Round( nCalculo * ( uSatCliT )->nDtoUno / 100, nRou )

   if ( uSatCliT )->nSbrAtp == 4 .and. ( uSatCliT )->nDtoAtp != 0
      nDtoAtp     += Round( nCalculo * ( uSatCliT )->nDtoAtp / 100, nRou )
   end if

   nCalculo       -= Round( nCalculo * ( uSatCliT )->nDtoDos / 100, nRou )

   if ( uSatCliT )->nSbrAtp == 5 .and. ( uSatCliT )->nDtoAtp != 0
      nDtoAtp     += Round( nCalculo * ( uSatCliT )->nDtoAtp / 100, nRou )
   end if

RETURN ( nDtoAtp )

//----------------------------------------------------------------------------//

FUNCTION nComLSatCli( dbfSatCliT, dbfSatCliL, nDecOut, nDerOut )

   local nImp        := nImpLSatCli( dbfSatCliT, dbfSatCliL, nDecOut, nDerOut )

RETURN ( nImp * ( dbfSatCliL )->nComAge / 100 )

//--------------------------------------------------------------------------//

FUNCTION dFecSatCli( cSatCli, dbfSatCliT )

   local dFecSat  := CtoD("")

   IF ( dbfSatCliT )->( dbSeek( cSatCli ) )
      dFecSat  := ( dbfSatCliT )->dFecSat
   END IF

RETURN ( dFecSat )

//---------------------------------------------------------------------------//

FUNCTION lEstSatCli( cSatCli, dbfSatCliT )

   local lEstSat  := .f.

   IF ( dbfSatCliT )->( dbSeek( cSatCli ) )
      lEstSat     := ( dbfSatCliT )->lEstado
   END IF

RETURN ( lEstSat )

//---------------------------------------------------------------------------//

FUNCTION cNbrSatCli( cSatCli, dbfSatCliT )

   local cNomCli  := ""

   IF ( dbfSatCliT )->( dbSeek( cSatCli ) )
      cNomCli  := ( dbfSatCliT )->CNOMCLI
   END IF

RETURN ( cNomCli )

//----------------------------------------------------------------------------//
//
// Devuelve el total de la compra en Sataranes de clientes de un articulo
//

function nTotDSatCli( cCodArt, dbfSatCliL )

   local nTotVta  := 0
   local nRecno   := ( dbfSatCliL )->( Recno() )

   if ( dbfSatCliL )->( dbSeek( cCodArt ) )

      while ( dbfSatCliL )->CREF == cCodArt .and. !( dbfSatCliL )->( eof() )

         If !( dbfSatCliL )->LTOTLIN
            nTotVta += nTotNSatCli( dbfSatCliL )
         end if

         ( dbfSatCliL )->( dbSkip() )

      end while

   end if

   ( dbfSatCliL )->( dbGoTo( nRecno ) )

return ( nTotVta )

//---------------------------------------------------------------------------//

function nVtaSatCli( cCodCli, dDesde, dHasta, dbfSatCliT, dbfSatCliL, dbfIva, dbfDiv )

   local nCon     := 0
   local nRec     := ( dbfSatCliT )->( Recno() )

   /*
   Facturas a Clientes -------------------------------------------------------
   */

   if ( dbfSatCliT )->( dbSeek( cCodCli ) )

      while ( dbfSatCliT )->cCodCli == cCodCli .and. !( dbfSatCliT )->( Eof() )

         if ( dDesde == nil .or. ( dbfSatCliT )->dFecSat >= dDesde )    .and.;
            ( dHasta == nil .or. ( dbfSatCliT )->dFecSat <= dHasta )

            nCon  += nTotSatCli( ( dbfSatCliT )->cSerSat + Str( ( dbfSatCliT )->nNumSat ) + ( dbfSatCliT )->cSufSat, dbfSatCliT, dbfSatCliL, dbfIva, dbfDiv, nil, nil, cDivEmp(), .f. )

         end if

         ( dbfSatCliT )->( dbSkip() )

      end while

   end if

   ( dbfSatCliT )->( dbGoTo( nRec ) )

return nCon

//----------------------------------------------------------------------------//

function aItmSatCli()

   local aItmSatCli :=  {}

   aAdd( aItmSatCli, { "CSERSAT",   "C",  1,  0, "Serie de S.A.T." ,           "",                        "", "( cDbf )"} )
   aAdd( aItmSatCli, { "NNUMSAT",   "N",  9,  0, "Número de S.A.T." ,          "'999999999'",             "", "( cDbf )"} )
   aAdd( aItmSatCli, { "CSUFSAT",   "C",  2,  0, "Sufijo de S.A.T." ,          "",                        "", "( cDbf )"} )
   aAdd( aItmSatCli, { "CTURSAT",   "C",  6,  0, "Sesión del S.A.T.",          "",                        "", "( cDbf )"} )
   aAdd( aItmSatCli, { "DFECSAT",   "D",  8,  0, "Fecha del S.A.T.",           "",                        "", "( cDbf )"} )
   aAdd( aItmSatCli, { "CCODCLI",   "C", 12,  0, "Código del cliente",              "",                   "", "( cDbf )"} )
   aAdd( aItmSatCli, { "CNOMCLI",   "C", 80,  0, "Nombre del cliente",              "'@!'",               "", "( cDbf )"} )
   aAdd( aItmSatCli, { "CDIRCLI",   "C",100,  0, "Domicilio del cliente",           "'@!'",               "", "( cDbf )"} )
   aAdd( aItmSatCli, { "CPOBCLI",   "C", 35,  0, "Población del cliente",           "'@!'",               "", "( cDbf )"} )
   aAdd( aItmSatCli, { "CPRVCLI",   "C", 20,  0, "Provincia del cliente",           "'@!'",               "", "( cDbf )"} )
   aAdd( aItmSatCli, { "CPOSCLI",   "C", 15,  0, "Código postal del cliente",       "'@!'",               "", "( cDbf )"} )
   aAdd( aItmSatCli, { "CDNICLI",   "C", 30,  0, "DNI del cliente",                 "'@!'",               "", "( cDbf )"} )
   aAdd( aItmSatCli, { "LMODCLI",   "L",  1,  0, "Modificar datos del cliente",     "",                   "", "( cDbf )"} )
   aAdd( aItmSatCli, { "CCODAGE",   "C",  3,  0, "Código del agente",               "",                   "", "( cDbf )"} )
   aAdd( aItmSatCli, { "CCODOBR",   "C", 10,  0, "Código de obra",                  "",                   "", "( cDbf )"} )
   aAdd( aItmSatCli, { "CCODTAR",   "C",  5,  0, "Código de tarifa",                "",                   "", "( cDbf )"} )
   aAdd( aItmSatCli, { "CCODALM",   "C",  3,  0, "Código del almacen",              "",                   "", "( cDbf )"} )
   aAdd( aItmSatCli, { "CCODCAJ",   "C",  3,  0, "Código de caja",                  "",                   "", "( cDbf )"} )
   aAdd( aItmSatCli, { "CCODPGO",   "C",  2,  0, "Código de pago",                  "",                   "", "( cDbf )"} )
   aAdd( aItmSatCli, { "CCODRUT",   "C",  4,  0, "Código de la ruta",               "",                   "", "( cDbf )"} )
   aAdd( aItmSatCli, { "DFECENT",   "D",  8,  0, "Fecha de entrada",                "",                   "", "( cDbf )"} )
   aAdd( aItmSatCli, { "lEstado",   "L",  1,  0, "Estado del S.A.T.",               "",                   "", "( cDbf )"} )
   aAdd( aItmSatCli, { "CSUSAT",    "C", 10,  0, "",                                "",                   "", "( cDbf )"} )
   aAdd( aItmSatCli, { "CCONDENT",  "C",100,  0, "",                                "",                   "", "( cDbf )"} )
   aAdd( aItmSatCli, { "MCOMENT",   "M", 10,  0, "Comentarios",                     "",                   "", "( cDbf )"} )
   aAdd( aItmSatCli, { "MOBSERV",   "M", 10,  0, "Averia",                          "",                   "", "( cDbf )"} )
   aAdd( aItmSatCli, { "LMAYOR",    "L",  1,  0, "" ,                               "",                   "", "( cDbf )"} )
   aAdd( aItmSatCli, { "NTARIFA",   "N",  1,  0, "Tarifa de precio aplicada" ,      "",                   "", "( cDbf )"} )
   aAdd( aItmSatCli, { "CDTOESP",   "C", 50,  0, "Descripción del descuento",       "",                   "", "( cDbf )"} )
   aAdd( aItmSatCli, { "NDTOESP",   "N",  5,  2, "Porcentaje de descuento",         "'@EZ 99,99'",        "", "( cDbf )"} )
   aAdd( aItmSatCli, { "CDPP",      "C", 50,  0, "Descripción del descuento por pronto pago","",          "", "( cDbf )"} )
   aAdd( aItmSatCli, { "NDPP",      "N",  5,  2, "Pct. de dto. por pronto pago",    "'@EZ 99,99'",        "", "( cDbf )"} )
   aAdd( aItmSatCli, { "CDTOUNO",   "C", 50,  0, "Desc. del primer descuento pers.","'@!'",               "", "( cDbf )"} )
   aAdd( aItmSatCli, { "NDTOUNO",   "N",  5,  2, "Pct. del primer descuento pers.", "'@EZ 99,99'",        "", "( cDbf )"} )
   aAdd( aItmSatCli, { "CDTODOS",   "C", 50,  0, "Desc. del segundo descuento pers.","'@!'",              "", "( cDbf )"} )
   aAdd( aItmSatCli, { "NDTODOS",   "N",  5,  2, "Pct. del segundo descuento pers.","'@EZ 99,99'",        "", "( cDbf )"} )
   aAdd( aItmSatCli, { "NDTOCNT",   "N",  5,  2, "Pct. de dto. por pago contado",   "'@EZ 99,99'",        "", "( cDbf )"} )
   aAdd( aItmSatCli, { "NDTORAP",   "N",  5,  2, "Pct. de dto. por rappel",         "'@EZ 99,99'",        "", "( cDbf )"} )
   aAdd( aItmSatCli, { "NDTOPUB",   "N",  5,  2, "Pct. de dto. por publicidad",     "'@EZ 99,99'",        "", "( cDbf )"} )
   aAdd( aItmSatCli, { "NDTOPGO",   "N",  5,  2, "Pct. de dto. por pago centralizado", "'@EZ 99,99'",     "", "( cDbf )"} )
   aAdd( aItmSatCli, { "NDTOPTF",   "N",  7,  2, "",                                "",                   "", "( cDbf )"} )
   aAdd( aItmSatCli, { "LRECARGO",  "L",  1,  0, "Aplicar recargo de equivalencia", "",                   "", "( cDbf )"} )
   aAdd( aItmSatCli, { "NPCTCOMAGE","N",  5,  2, "Pct. de comisión del agente",     "",                   "", "( cDbf )"} )
   aAdd( aItmSatCli, { "NBULTOS",   "N",  3,  0, "Numero de bultos",                "'999'",              "", "( cDbf )"} )
   aAdd( aItmSatCli, { "CNUMSat",   "C", 10,  0, "" ,                               "",                   "", "( cDbf )"} )
   aAdd( aItmSatCli, { "CDIVSAT",   "C",  3,  0, "Código de divisa",                "",                   "", "( cDbf )"} )
   aAdd( aItmSatCli, { "NVDVSAT",   "N", 10,  4, "Valor del cambio de la divisa",   "'@EZ 999,999.9999'", "", "( cDbf )"} )
   aAdd( aItmSatCli, { "LSNDDOC",   "L",  1,  0, "Valor lógico documento enviado",  "",                   "", "( cDbf )"} )
   aAdd( aItmSatCli, { "CRETPOR",   "C",150,  0, "Retirado por" ,                   "",                   "", "( cDbf )"} )
   aAdd( aItmSatCli, { "CRETMAT",   "C",150,  0, "Matrícula" ,                      "",                   "", "( cDbf )"} )
   aAdd( aItmSatCli, { "NREGIVA",   "N",  1,  0, "Regimen de " + cImp() ,           "",                   "", "( cDbf )"} )
   aAdd( aItmSatCli, { "LIVAINC",   "L",  1,  0, "Lógico de " + cImp() + " incluido" ,        "",                   "", "( cDbf )"} )
   aAdd( aItmSatCli, { "NIVAMAN",   "N",  6,  2, "Porcentaje de " + cImp() + " del gasto" ,   "'@EZ 999,99'",       "", "( cDbf )"} )
   aAdd( aItmSatCli, { "NMANOBR",   "N", 16,  6, "Gastos" ,                         "cPorDivSat",         "", "( cDbf )"} )
   aAdd( aItmSatCli, { "cCodTrn",   "C",  9,  0, "Código de transportista" ,        "",                   "", "( cDbf )"} )
   aAdd( aItmSatCli, { "nKgsTrn"   ,"N", 16,  6, "TARA del transportista" ,         "",                   "", "( cDbf )"} )
   aAdd( aItmSatCli, { "lCloSat",   "L",  1,  0, "" ,                               "",                   "", "( cDbf )"} )
   aAdd( aItmSatCli, { "cCodUsr",   "C",  3,  0, "Código de usuario",               "",                   "", "( cDbf )"} )
   aAdd( aItmSatCli, { "dFecCre",   "D",  8,  0, "Fecha de creación del documento", "",                   "", "( cDbf )"} )
   aAdd( aItmSatCli, { "cTimCre",   "C",  5,  0, "Hora de creación del documento",  "",                   "", "( cDbf )"} )
   aAdd( aItmSatCli, { "cSituac",   "C", 20,  0, "Situación del documento",         "",                   "", "( cDbf )"} )
   aAdd( aItmSatCli, { "nDiaVal",   "N",  3,  0, "Dias de validez",                 "",                   "", "( cDbf )"} )
   aAdd( aItmSatCli, { "cCodGrp",   "C",  4,  0, "Código de grupo de cliente",      "",                   "", "( cDbf )"} )
   aAdd( aItmSatCli, { "lImprimido","L",  1,  0, "Lógico de imprimido del documento",                 "", "", "( cDbf )"} )
   aAdd( aItmSatCli, { "dFecImp",   "D",  8,  0, "Última fecha de impresión del documento",           "", "", "( cDbf )"} )
   aAdd( aItmSatCli, { "cHorImp",   "C",  5,  0, "Hora de la última impresión del documento",         "", "", "( cDbf )"} )
   aAdd( aItmSatCli, { "cCodDlg",   "C",  2,  0, "Código delegación" ,                                "", "", "( cDbf )"} )
   aAdd( aItmSatCli, { "nDtoAtp",   "N",  6,  2, "Porcentaje de descuento atípico",                   "", "", "( cDbf )"} )
   aAdd( aItmSatCli, { "nSbrAtp",   "N",  1,  0, "Lugar donde aplicar dto atípico",                   "", "", "( cDbf )"} )
   aAdd( aItmSatCli, { "dFecEntr",  "D",  8,  0, "Fecha de entrada de alquiler",                      "", "", "( cDbf )"} )
   aAdd( aItmSatCli, { "dFecSal",   "D",  8,  0, "fecha de salidad de alquiler",                      "", "", "( cDbf )"} )
   aAdd( aItmSatCli, { "lAlquiler", "L",  1,  0, "Lógico de alquiler",                                "", "", "( cDbf )"} )
   aAdd( aItmSatCli, { "cManObr",   "C",250,  0, "Literal de gastos" ,                                "", "", "( cDbf )"} )
   aAdd( aItmSatCli, { "cNumTik",   "C", 13,  0, "Número del ticket generado" ,                       "", "", "( cDbf )"} )
   aAdd( aItmSatCli, { "CTLFCLI",   "C", 20,  0, "Teléfono del cliente" ,                             "", "", "( cDbf )"} )
   aAdd( aItmSatCli, { "nTotNet",   "N", 16,  6, "Total neto" ,                                       "", "", "( cDbf )"} )
   aAdd( aItmSatCli, { "nTotIva",   "N", 16,  6, "Total " + cImp() ,                                  "", "", "( cDbf )"} )
   aAdd( aItmSatCli, { "nTotReq",   "N", 16,  6, "Total recargo" ,                                    "", "", "( cDbf )"} )
   aAdd( aItmSatCli, { "nTotSat",   "N", 16,  6, "Total S.A.T." ,                                     "", "", "( cDbf )"} )
   aAdd( aItmSatCli, { "lOperPV",   "L",  1,  0, "Lógico para operar con punto verde" ,               "", "", "( cDbf )", .t.} )
   aAdd( aItmSatCli, { "cNumAlb",   "C", 12,  0, "Número del albarán donde se agrupa" ,               "", "", "( cDbf )", nil } )
   aAdd( aItmSatCli, { "lGarantia", "L",  1,  0, "Lógico de reparación en garantía" ,                 "", "", "( cDbf )"} )

return ( aItmSatCli )

//---------------------------------------------------------------------------//

function aCalSatCli()

   local aCalSatCli  := {}

   aAdd( aCalSatCli, { "nTotArt",                                                   "N", 16,  6, "Total artículos",             "cPicUndSat",  "" } )
   aAdd( aCalSatCli, { "nTotCaj",                                                   "N", 16,  6, "Total cajas",                 "cPicUndSat",  "" } )
   aAdd( aCalSatCli, { "aTotIva[1,1]",                                              "N", 16,  6, "Bruto primer tipo de " + cImp(),    "cPorDivSat",  "aTotIva[1,1] != 0" } )
   aAdd( aCalSatCli, { "aTotIva[2,1]",                                              "N", 16,  6, "Bruto segundo tipo de " + cImp(),   "cPorDivSat",  "aTotIva[2,1] != 0" } )
   aAdd( aCalSatCli, { "aTotIva[3,1]",                                              "N", 16,  6, "Bruto tercer tipo de " + cImp(),    "cPorDivSat",  "aTotIva[3,1] != 0" } )
   aAdd( aCalSatCli, { "aTotIva[1,2]",                                              "N", 16,  6, "Base primer tipo de " + cImp(),     "cPorDivSat",  "aTotIva[1,2] != 0" } )
   aAdd( aCalSatCli, { "aTotIva[2,2]",                                              "N", 16,  6, "Base segundo tipo de " + cImp(),    "cPorDivSat",  "aTotIva[2,2] != 0" } )
   aAdd( aCalSatCli, { "aTotIva[3,2]",                                              "N", 16,  6, "Base tercer tipo de " + cImp(),     "cPorDivSat",  "aTotIva[3,2] != 0" } )
   aAdd( aCalSatCli, { "aTotIva[1,3]",                                              "N",  5,  2, "Porcentaje primer tipo " + cImp(),  "'@R 99.99%'", "aTotIva[1,3] != 0" } )
   aAdd( aCalSatCli, { "aTotIva[2,3]",                                              "N",  5,  2, "Porcentaje segundo tipo " + cImp(), "'@R 99.99%'", "aTotIva[2,3] != 0" } )
   aAdd( aCalSatCli, { "aTotIva[3,3]",                                              "N",  5,  2, "Porcentaje tercer tipo " + cImp(),  "'@R 99.99%'", "aTotIva[3,3] != 0" } )
   aAdd( aCalSatCli, { "aTotIva[1,4]",                                              "N",  5,  2, "Porcentaje primer tipo RE",   "'@R 99.99%'", "aTotIva[1,4] != 0" } )
   aAdd( aCalSatCli, { "aTotIva[2,4]",                                              "N",  5,  2, "Porcentaje segundo tipo RE",  "'@R 99.99%'", "aTotIva[2,4] != 0" } )
   aAdd( aCalSatCli, { "aTotIva[3,4]",                                              "N",  5,  2, "Porcentaje tercer tipo RE",   "'@R 99.99%'", "aTotIva[3,4] != 0" } )
   aAdd( aCalSatCli, { "round( aTotIva[1,2] * aTotIva[1,3] / 100, nDouDivSat )",    "N", 16,  6, "Importe primer tipo " + cImp(),     "cPorDivSat",  "aTotIva[1,2] != 0" } )
   aAdd( aCalSatCli, { "round( aTotIva[2,2] * aTotIva[2,3] / 100, nDouDivSat )",    "N", 16,  6, "Importe segundo tipo " + cImp(),    "cPorDivSat",  "aTotIva[2,2] != 0" } )
   aAdd( aCalSatCli, { "round( aTotIva[3,2] * aTotIva[3,3] / 100, nDouDivSat )",    "N", 16,  6, "Importe tercer tipo " + cImp(),     "cPorDivSat",  "aTotIva[3,2] != 0" } )
   aAdd( aCalSatCli, { "round( aTotIva[1,2] * aTotIva[1,4] / 100, nDouDivSat )",    "N", 16,  6, "Importe primer RE",           "cPorDivSat",  "aTotIva[1,2] != 0" } )
   aAdd( aCalSatCli, { "round( aTotIva[2,2] * aTotIva[2,4] / 100, nDouDivSat )",    "N", 16,  6, "Importe segundo RE",          "cPorDivSat",  "aTotIva[2,2] != 0" } )
   aAdd( aCalSatCli, { "round( aTotIva[3,2] * aTotIva[3,4] / 100, nDouDivSat )",    "N", 16,  6, "Importe tercer RE",           "cPorDivSat",  "aTotIva[3,2] != 0" } )
   aAdd( aCalSatCli, { "aTotIvm[1,1]",                                              "N", 16,  6, "Total unidades primer tipo de impuestos especiales",    "cPorDivSat",  "aTotIvm[1,1] != 0" } )
   aAdd( aCalSatCli, { "aTotIvm[2,1]",                                              "N", 16,  6, "Total unidades segundo tipo de impuestos especiales",   "cPorDivSat",  "aTotIvm[2,1] != 0" } )
   aAdd( aCalSatCli, { "aTotIvm[3,1]",                                              "N", 16,  6, "Total unidades tercer tipo de impuestos especiales",    "cPorDivSat",  "aTotIvm[3,1] != 0" } )
   aAdd( aCalSatCli, { "aTotIva[1,2]",                                              "N", 16,  6, "Importe del primer tipo de impuestos especiales",       "cPorDivSat",  "aTotIvm[1,2] != 0" } )
   aAdd( aCalSatCli, { "aTotIva[2,2]",                                              "N", 16,  6, "Importe del segundo tipo de impuestos especiales",      "cPorDivSat",  "aTotIvm[2,2] != 0" } )
   aAdd( aCalSatCli, { "aTotIva[3,2]",                                              "N", 16,  6, "Importe del tercer tipo de impuestos especiales",       "cPorDivSat",  "aTotIvm[3,2] != 0" } )
   aAdd( aCalSatCli, { "aTotIvm[1,3]",                                              "N", 16,  6, "Total importe primer tipo de impuestos especiales",     "cPorDivSat",  "aTotIvm[1,3] != 0" } )
   aAdd( aCalSatCli, { "aTotIvm[2,3]",                                              "N", 16,  6, "Total importe segundo tipo de impuestos especiales",    "cPorDivSat",  "aTotIvm[2,3] != 0" } )
   aAdd( aCalSatCli, { "aTotIvm[3,3]",                                              "N", 16,  6, "Total importe tercer tipo de impuestos especiales",     "cPorDivSat",  "aTotIvm[3,3] != 0" } )
   aAdd( aCalSatCli, { "nTotBrt",                                                   "N", 16,  6, "Total bruto",                 "cPorDivSat",  "lEnd" } )
   aAdd( aCalSatCli, { "nTotDto",                                                   "N", 16,  6, "Total descuento",             "cPorDivSat",  "lEnd" } )
   aAdd( aCalSatCli, { "nTotDpp",                                                   "N", 16,  6, "Total descuento pronto pago", "cPorDivSat",  "lEnd" } )
   aAdd( aCalSatCli, { "nTotNet",                                                   "N", 16,  6, "Total neto",                  "cPorDivSat",  "lEnd" } )
   aAdd( aCalSatCli, { "nTotIva",                                                   "N", 16,  6, "Total " + cImp(),             "cPorDivSat",  "lEnd" } )
   aAdd( aCalSatCli, { "nTotIvm",                                                   "N", 16,  6, "Total IVMH",                  "cPorDivSat",  "lEnd" } )
   aAdd( aCalSatCli, { "nTotReq",                                                   "N", 16,  6, "Total RE",                    "cPorDivSat",  "lEnd" } )
   aAdd( aCalSatCli, { "nTotSat",                                                   "N", 16,  6, "Total S.A.T.",           "cPorDivSat",  "lEnd" } )
   aAdd( aCalSatCli, { "nTotPes",                                                   "N", 16,  6, "Total peso",                  "'@E 99,999.99'","lEnd" } )
   aAdd( aCalSatCli, { "nTotCos",                                                   "N", 16,  6, "Total costo",                 "cPorDivSat",  "lEnd" } )
   aAdd( aCalSatCli, { "nTotPage",                                                  "N", 16,  6, "Total página",                "cPorDivSat",  "!lEnd" } )
   aAdd( aCalSatCli, { "nImpEuros( nTotSat, (cDbf)->cDivSat, cDbfDiv )",            "N", 16,  6, "Total Satsupuesto (Euros)",   "",            "lEnd" } )
   aAdd( aCalSatCli, { "nImpPesetas( nTotSat, (cDbf)->cDivSat, cDbfDiv )",          "N", 16,  6, "Total Satsupuesto (Pesetas)", "",            "lEnd" } )
   aAdd( aCalSatCli, { "nPagina",                                                   "N",  2,  0, "Numero de página",            "'99'",        "" } )
   aAdd( aCalSatCli, { "lEnd",                                                      "L",  1,  0, "Fin del documento",           "",            "" } )

return ( aCalSatCli )

//---------------------------------------------------------------------------//

function aColSatCli()

   local aColSatCli  := {}

   aAdd( aColSatCli, { "CSERSAT", "C",    1,  0, "Serie de S.A.T." ,                 "",                   "", "( cDbfCol )" } )
   aAdd( aColSatCli, { "NNUMSAT", "N",    9,  0, "Numero de S.A.T." ,                "'999999999'",        "", "( cDbfCol )" } )
   aAdd( aColSatCli, { "CSUFSAT", "C",    2,  0, "Sufijo de S.A.T." ,                "",                   "", "( cDbfCol )" } )
   aAdd( aColSatCli, { "CREF",    "C",   18,  0, "Referencia del artículo" ,         "",                   "", "( cDbfCol )" } )
   aAdd( aColSatCli, { "CDETALLE","C",  250,  0, "Descripción de artículo" ,         "",                   "", "( cDbfCol )" } )
   aAdd( aColSatCli, { "NIVA"    ,"N",    6,  2, "Porcentaje de " + cImp() ,         "'@E 99.9'",          "", "( cDbfCol )" } )
   aAdd( aColSatCli, { "NCANSAT" ,"N",   16,  6, "Cantidad pedida" ,                 "MasUnd()",           "", "( cDbfCol )" } )
   aAdd( aColSatCli, { "NUNICAJA","N",   16,  6, "Unidades por caja" ,               "MasUnd()",           "", "( cDbfCol )" } )
   aAdd( aColSatCli, { "LCONTROL","L",    1,  0, "" ,                                "",                   "", "( cDbfCol )" } )
   aAdd( aColSatCli, { "NUNDKIT", "N",   16,  6, "Unidades tipo kit" ,               "MasUnd()",           "", "( cDbfCol )" } )
   aAdd( aColSatCli, { "NPreDiv" ,"N",   16,  6, "Importe del artículo" ,            "cPorDivSat",         "", "( cDbfCol )" } )
   aAdd( aColSatCli, { "NPNTVER", "N",   16,  6, "Importe punto verde" ,             "cPorDivSat",         "", "( cDbfCol )" } )
   aAdd( aColSatCli, { "nImpTrn", "N",   16,  6, "Importe del transporte",           "cPorDivSat",         "", "( cDbfCol )" } )
   aAdd( aColSatCli, { "NDTO",    "N",    6,  2, "Descuento del artículo" ,          "'@E 99.99'",         "", "( cDbfCol )" } )
   aAdd( aColSatCli, { "NDTOPRM", "N",    6,  2, "Descuento de la promoción" ,       "'@E 99.99'",         "", "( cDbfCol )" } )
   aAdd( aColSatCli, { "NCOMAGE", "N",    6,  2, "Comisión del agente" ,             "'@E 99.99'",         "", "( cDbfCol )" } )
   aAdd( aColSatCli, { "NCANENT", "N",   16,  6, "Unidades de entrada" ,             "MasUnd()",           "", "( cDbfCol )" } )
   aAdd( aColSatCli, { "CUNIDAD", "C",    2,  0, "Unidad de venta" ,                 "",                   "", "( cDbfCol )" } )
   aAdd( aColSatCli, { "NPESOKG", "N",   16,  6, "Peso del artículo" ,               "",                   "", "( cDbfCol )" } )
   aAdd( aColSatCli, { "cPesoKg", "C",    2,  0, "Unidad de peso del artículo" ,     "",                   "", "( cDbfCol )" } )
   aAdd( aColSatCli, { "DFECHA",  "D",    8,  0, "Fecha de entrega",                 "",                   "", "( cDbfCol )" } )
   aAdd( aColSatCli, { "MLNGDES", "M",   10,  0, "Descripción de artículo sin codificar", "",              "", "( cDbfCol )" } )
   aAdd( aColSatCli, { "LTOTLIN", "L",    1,  0, "Linea de total" ,                  "",                   "", "( cDbfCol )" } )
   aAdd( aColSatCli, { "LIMPLIN", "L",    1,  0, "Linea no imprimible" ,             "",                   "", "( cDbfCol )" } )
   aAdd( aColSatCli, { "CCODPR1", "C",   10,  0, "Código de la primera propiedad",   "",                   "", "( cDbfCol )" } )
   aAdd( aColSatCli, { "CCODPR2", "C",   10,  0, "Código de la segunda propiedad",   "",                   "", "( cDbfCol )" } )
   aAdd( aColSatCli, { "CVALPR1", "C",   10,  0, "Valor de la primera propiedad",    "",                   "", "( cDbfCol )" } )
   aAdd( aColSatCli, { "CVALPR2", "C",   10,  0, "Valor de la segunda propiedad",    "",                   "", "( cDbfCol )" } )
   aAdd( aColSatCli, { "NFACCNV", "N",   16,  6, "Factor de conversión de la compra","",                   "", "( cDbfCol )" } )
   aAdd( aColSatCli, { "NDTODIV", "N",   16,  6, "Descuento lineal de la compra",    "",                   "", "( cDbfCol )" } )
   aAdd( aColSatCli, { "CTIPMOV", "C",    2,  0, "Tipo de movimiento",               "",                   "", "( cDbfCol )" } )
   aAdd( aColSatCli, { "NNUMLIN", "N",    4,  0, "Numero de la línea",               "'9999'",             "", "( cDbfCol )" } )
   aAdd( aColSatCli, { "NCTLSTK", "N",    1,  0, "Tipo de stock de la línea",        "'9'",                "", "( cDbfCol )" } )
   aAdd( aColSatCli, { "NCOSDIV", "N",   16,  6, "Costo del artículo" ,              "cPorDivSat",         "", "( cDbfCol )" } )
   aAdd( aColSatCli, { "NPVSATC", "N",   16,  6, "Precio de venta recomendado" ,     "cPorDivSat",         "", "( cDbfCol )" } )
   aAdd( aColSatCli, { "CALMLIN", "C",    3,  0, "Código de almacén" ,               "",                   "", "( cDbfCol )" } )
   aAdd( aColSatCli, { "LIVALIN", "L",    1,  0, "Línea con " + cImp() + " incluido","",                   "", "( cDbfCol )" } )
   aAdd( aColSatCli, { "CCODIMP", "C",    3,  0, "Código del impuesto especial",     "",                   "", "( cDbfCol )" } )
   aAdd( aColSatCli, { "NVALIMP", "N",   16,  6, "Importe de impuesto",              "",                   "", "( cDbfCol )" } )
   aAdd( aColSatCli, { "LLOTE",   "L",    1,  0, "",                                 "",                   "", "( cDbfCol )" } )
   aAdd( aColSatCli, { "NLOTE",   "N",    9,  0, "",                                 "'999999999'",        "", "( cDbfCol )" } )
   aAdd( aColSatCli, { "CLOTE",   "C",   12,  0, "Número de Lote",                   "",                   "", "( cDbfCol )" } )
   aAdd( aColSatCli, { "LKITART", "L",    1,  0, "Línea con escandallo",             "" ,                  "", "( cDbfCol )" } )
   aAdd( aColSatCli, { "LKITCHL", "L",    1,  0, "Línea pertenciente a escandallo",  "" ,                  "", "( cDbfCol )" } )
   aAdd( aColSatCli, { "LKITPRC", "L",    1,  0, "",                                 "" ,                  "", "( cDbfCol )" } )
   aAdd( aColSatCli, { "NMESGRT", "N",    2,  0, "Meses de garantía",                "'99'",               "", "( cDbfCol )" } )
   aAdd( aColSatCli, { "LMSGVTA", "L",    1,  0, "Avisar en venta sin stocks",       "",                   "", "( cDbfCol )" } )
   aAdd( aColSatCli, { "LNOTVTA", "L",    1,  0, "No permitir venta sin stocks",     "",                   "", "( cDbfCol )" } )
   aAdd( aColSatCli, { "MNUMSER", "M",   10,  0, "" ,                                "",                   "", "( cDbfCol )" } )
   aAdd( aColSatCli, { "CCODTIP", "C",    3,  0, "Código del tipo de artículo",      "",                   "", "( cDbfCol )" } )
   aAdd( aColSatCli, { "CCODFAM", "C",   16,  0, "Código de familia",                "",                   "", "( cDbfCol )" } )
   aAdd( aColSatCli, { "CGRPFAM", "C",    3,  0, "Código del grupo de familia",      "",                   "", "( cDbfCol )" } )
   aAdd( aColSatCli, { "NREQ",    "N",    6,  2, "Recargo de equivalencia",          "",                   "", "( cDbfCol )" } )
   aAdd( aColSatCli, { "MOBSLIN", "M",   10,  0, "Observacion de línea",             "",                   "", "( cDbfCol )" } )
   aAdd( aColSatCli, { "CCODPRV", "C",   12,  0, "Código del proveedor",             "",                   "", "( cDbfCol )" } )
   aAdd( aColSatCli, { "CNOMPRV", "C",   30,  0, "Nombre del proveedor",             "",                   "", "( cDbfCol )" } )
   aAdd( aColSatCli, { "CIMAGEN", "C",  250,  0, "Fichero de imagen" ,               "",                   "", "( cDbfCol )", .t. } )
   aAdd( aColSatCli, { "NPUNTOS", "N",   15,  6, "Puntos del artículo",              "",                   "", "( cDbfCol )" } )
   aAdd( aColSatCli, { "NVALPNT", "N",   16,  6, "Valor del punto",                  "",                   "", "( cDbfCol )" } )
   aAdd( aColSatCli, { "NDTOPNT", "N",    5,  2, "Descuento puntos",                 "",                   "", "( cDbfCol )" } )
   aAdd( aColSatCli, { "NINCPNT", "N",    5,  2, "Incremento porcentual",            "",                   "", "( cDbfCol )" } )
   aAdd( aColSatCli, { "CREFPRV", "C",   18,  0, "Referencia artículo proveedor",    "",                   "", "( cDbfCol )" } )
   aAdd( aColSatCli, { "NVOLUMEN","N",   16,  6, "Volumen del artículo" ,            "'@E 9,999.99'",      "", "( cDbfCol )" } )
   aAdd( aColSatCli, { "CVOLUMEN","C",    2,  0, "Unidad del volumen" ,              "",                   "", "( cDbfCol )" } )
   aAdd( aColSatCli, { "DFECENT" ,"D",    8,  0, "Fecha de entrada del alquiler",    "",                   "", "( cDbfCol )" } )
   aAdd( aColSatCli, { "DFECSAL" ,"D",    8,  0, "Fecha de salida del alquiler",     "",                   "", "( cDbfCol )" } )
   aAdd( aColSatCli, { "nPreAlq" ,"N",   16,  6, "Precio de alquiler",               "",                   "", "( cDbfCol )" } )
   aAdd( aColSatCli, { "lAlquiler","L",   1,  0, "Lógico de alquiler",               "",                   "", "( cDbfCol )" } )
   aAdd( aColSatCli, { "nNumMed"  ,"N",   1,  0, "Número de mediciones",             "MasUnd()",           "", "( cDbfCol )" } )
   aAdd( aColSatCli, { "nMedUno"  ,"N",  16,  6, "Primera unidad de medición",       "MasUnd()",           "", "( cDbfCol )" } )
   aAdd( aColSatCli, { "nMedDos"  ,"N",  16,  6, "Segunda unidad de medición",       "MasUnd()",           "", "( cDbfCol )" } )
   aAdd( aColSatCli, { "nMedTre"  ,"N",  16,  6, "Tercera unidad de medición",       "MasUnd()",           "", "( cDbfCol )" } )
   aAdd( aColSatCli, { "nTarLin"  ,"N",   1,  0, "Tarifa de precio aplicada" ,       "",                   "", "( cDbfCol )" } )
   aAdd( aColSatCli, { "lImpFra"  ,"L",   1,  0, "Lógico de imprimir frase publicitaria", "",              "", "( cDbfCol )" } )
   aAdd( aColSatCli, { "cCodFra"  ,"C",   3,  0, "Código de frase publicitaria",     "",                   "", "( cDbfCol )" } )
   aAdd( aColSatCli, { "cTxtFra"  ,"C", 250,  0, "",                                 "",                   "", "( cDbfCol )" } )
   aAdd( aColSatCli, { "Descrip"  ,"M",  10,  0, "Descripción larga",                "",                   "", "( cDbfCol )" } )
   aAdd( aColSatCli, { "lLinOfe"  ,"L",   1,  0, "Línea con oferta",                 "",                   "", "( cDbfCol )" } )
   aAdd( aColSatCli, { "lVolImp"  ,"L",   1,  0, "Lógico aplicar volumen con impuestos especiales", "",    "", "( cDbfCol )" } )

return ( aColSatCli )

//---------------------------------------------------------------------------//

function aCocSatCli()

   local aCocSatCli :=  {}

   aAdd( aCocSatCli, { "Descrip( cDbfCol )",                                         "C", 50, 0, "Detalle del artículo",         "",            "Descripción", "" } )
   aAdd( aCocSatCli, { "nTotNSatCli( cDbfCol )",                                     "N", 16, 6, "Total articulos",              "MasUnd()",    "Unidades",    "" } )
   aAdd( aCocSatCli, { "nTotUSatCli( cDbfCol, nDouDivSat, nVdvDivSat )",             "N", 16, 6, "Precio unitario",              "cPouDivSat",  "Precio",      "" } )
   aAdd( aCocSatCli, { "nTotLSatCli( cDbfCol, nDouDivSat, nRouDivSat, nVdvDivSat )", "N", 16, 6, "Total línea de S.A.T.",        "cPorDivSat",  "Total",       "" } )

return ( aCocSatCli )

//---------------------------------------------------------------------------//

function aIncSatCli()

   local aColSatCli  := {}

   aAdd( aColSatCli, { "cSerSat", "C",    1,  0, "Serie de S.A.T." ,                "",                   "", "( cDbfCol )" } )
   aAdd( aColSatCli, { "nNumSat", "N",    9,  0, "Numero de S.A.T." ,               "'999999999'",        "", "( cDbfCol )" } )
   aAdd( aColSatCli, { "cSufSat", "C",    2,  0, "Sufijo de S.A.T." ,               "",                   "", "( cDbfCol )" } )
   aAdd( aColSatCli, { "cCodTip", "C",    3,  0, "Tipo de incidencia" ,             "",                   "", "( cDbfCol )" } )
   aAdd( aColSatCli, { "dFecInc", "D",    8,  0, "Fecha de la incidencia" ,         "",                   "", "( cDbfCol )" } )
   aAdd( aColSatCli, { "mDesInc", "M",   10,  0, "Descripción de la incidencia" ,   "",                   "", "( cDbfCol )" } )
   aAdd( aColSatCli, { "lListo",  "L",    1,  0, "Lógico de listo" ,                "",                   "", "( cDbfCol )" } )
   aAdd( aColSatCli, { "lAviso",  "L",    1,  0, "Lógico de aviso" ,                "",                   "", "( cDbfCol )" } )

return ( aColSatCli )

//---------------------------------------------------------------------------//

function aSatCliDoc()

   local aSatCliDoc  := {}

   aAdd( aSatCliDoc, { "cSerSat", "C",    1,  0, "Serie de S.A.T." ,                "",                   "", "( cDbfCol )" } )
   aAdd( aSatCliDoc, { "nNumSat", "N",    9,  0, "Numero de S.A.T." ,               "'999999999'",        "", "( cDbfCol )" } )
   aAdd( aSatCliDoc, { "cSufSat", "C",    2,  0, "Sufijo de S.A.T." ,               "",                   "", "( cDbfCol )" } )
   aAdd( aSatCliDoc, { "cNombre", "C",  250,  0, "Nombre del documento" ,           "",                   "", "( cDbfCol )" } )
   aAdd( aSatCliDoc, { "cRuta",   "C",  250,  0, "Ruta del documento" ,             "",                   "", "( cDbfCol )" } )
   aAdd( aSatCliDoc, { "mObsDoc", "M",   10,  0, "Observaciones del documento" ,    "",                   "", "( cDbfCol )" } )

return ( aSatCliDoc )

//---------------------------------------------------------------------------//

function aSerSatCli()

   local aColSatCli  := {}

   aAdd( aColSatCli,  { "cSerSat",     "C",  1,   0, "",                                 "",                  "", "( cDbfCol )" } )
   aAdd( aColSatCli,  { "nNumSat",     "N",  9,   0, "",                                 "",                  "", "( cDbfCol )" } )
   aAdd( aColSatCli,  { "cSufSat",     "C",  2,   0, "",                                 "",                  "", "( cDbfCol )" } )
   aAdd( aColSatCli,  { "dFecSat",     "D",  8,   0, "",                                 "",                  "", "( cDbfCol )" } )
   aAdd( aColSatCli,  { "nNumLin",     "N",  4,   0, "Número de la línea",               "'9999'",            "", "( cDbfCol )" } )
   aAdd( aColSatCli,  { "lUndNeg",     "L",  1,   0, "Lógico de unidades en negativo",   "",                  "", "( cDbfCol )" } )
   aAdd( aColSatCli,  { "cRef",        "C", 18,   0, "Referencia del artículo",          "",                  "", "( cDbfCol )" } )
   aAdd( aColSatCli,  { "cAlmLin",     "C",  3,   0, "Almacen del artículo",             "",                  "", "( cDbfCol )" } )
   aAdd( aColSatCli,  { "cNumSer",     "C", 30,   0, "Número de serie",                  "",                  "", "( cDbfCol )" } )

return ( aColSatCli )

//---------------------------------------------------------------------------//

STATIC FUNCTION RecSatCli( aTmpSat )

   local nDtoAge
   local nImpAtp  := 0
   local nImpOfe  := 0
   local nRecno
   local cCodFam

   if !ApoloMsgNoYes( "¡Atención!,"                                      + CRLF + ;
                  "todos los precios se recalcularán en función de"  + CRLF + ;
                  "los valores en las bases de datos.",;
                  "¿Desea proceder?" )
      return nil
   end if

   nRecno         := ( dbfTmpLin )->( RecNo() )

   ( dbfTmpLin )->( dbGotop() )
   ( dbfArticulo )->( ordSetFocus( "CODIGO" ) )

   while !( dbfTmpLin )->( eof() )

      /*
      Ahora buscamos por el codigo interno
      */

      if ( dbfArticulo )->( dbSeek( ( dbfTmpLin )->cRef ) )

         if aTmpSat[ _NREGIVA ] <= 1
            ( dbfTmpLin )->nIva     := nIva( dbfIva, ( dbfArticulo )->TipoIva )
            ( dbfTmpLin )->nReq     := nReq( dbfIva, ( dbfArticulo )->TipoIva )
         end if

         /*
         Ahora recogemos el impuesto especial si lo hay
         */

         if !Empty( ( dbfArticulo )->cCodImp )
            ( dbfTmpLin )->cCodImp  := ( dbfArticulo )->cCodImp
            ( dbfTmpLin )->nValImp  := oNewImp:nValImp( ( dbfArticulo )->cCodImp, aTmpSat[ _LIVAINC ], ( dbfTmpLin )->nIva )
         end if

         /*
         Tomamos los precios de la base de datos de articulos---------------------
         */

         ( dbfTmpLin )->nPreDiv  := nRetPreArt( ( dbfTmpLin )->nTarLin, aTmpSat[ _CDIVSAT ], aTmpSat[ _LIVAINC ], dbfArticulo, dbfDiv, dbfKit, dbfIva )

         /*
         Linea por contadores-----------------------------------------------------
         */

         ( dbfTmpLin )->nCtlStk  := ( dbfArticulo )->nCtlStock
         ( dbfTmpLin )->nCosDiv  := nCosto( nil, dbfArticulo, dbfKit )

         /*
         Punto verde--------------------------------------------------------------
         */

         ( dbfTmpLin )->nPntVer  := ( dbfArticulo )->nPntVer1

         /*
         Chequeamos situaciones especiales y comprobamos las fechas
         */

         do case
         case lSeekAtpArt( aTmpSat[ _CCODCLI ] + ( dbfTmpLin )->cRef, ( dbfTmpLin )->cCodPr1 + ( dbfTmpLin )->cCodPr2, ( dbfTmpLin )->cValPr1 + ( dbfTmpLin )->cValPr2, aTmpSat[ _DFECSAT ], dbfCliAtp ) .and. ;
               ( dbfCliAtp )->lAplSat

               nImpAtp  := nImpAtp( ( dbfTmpLin )->nTarLin, dbfCliAtp )
               if nImpAtp != 0
                  ( dbfTmpLin )->nPreDiv  := nImpAtp
               end if

               nImpAtp  := nDtoAtp( ( dbfTmpLin )->nTarLin, dbfCliAtp )
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
         Precios en tarifas
         */

         case !Empty( aTmpSat[ _CCODTAR ] )

            cCodFam  := ( dbfTmpLin )->cCodFam

            nImpOfe  := RetPrcTar( ( dbfTmpLin )->cRef, aTmpSat[ _CCODTAR ], ( dbfTmpLin )->cCodPr1, ( dbfTmpLin )->cCodPr2, ( dbfTmpLin )->cValPr1, ( dbfTmpLin )->cValPr2, dbfTarPreL, ( dbfTmpLin )->nTarLin )
            if nImpOfe != 0
               ( dbfTmpLin )->nPreDiv  := nImpOfe
            end if

            nImpOfe  := RetPctTar( ( dbfTmpLin )->cRef, cCodFam, aTmpSat[ _CCODTAR ], ( dbfTmpLin )->cCodPr1, ( dbfTmpLin )->cCodPr2, ( dbfTmpLin )->cValPr1, ( dbfTmpLin )->cValPr2, dbfTarPreL )
            if nImpOfe != 0
               ( dbfTmpLin )->nDto     := nImpOfe
            end if

            nImpOfe  := RetComTar( ( dbfTmpLin )->cRef, cCodFam, aTmpSat[ _CCODTAR ], ( dbfTmpLin )->cCodPr1, ( dbfTmpLin )->cCodPr2, ( dbfTmpLin )->cValPr1, ( dbfTmpLin )->cValPr2, aTmpSat[ _CCODAGE ], dbfTarPreL, dbfTarPreS )
            if nImpOfe != 0
               ( dbfTmpLin )->nComAge  := nImpOfe
            end if

            /*
            Descuento de promoci¢n, esta funci¢n comprueba si existe y si es asi devuelve el descunto de la promoci¢n.
            */

            nImpOfe  := RetDtoPrm( ( dbfTmpLin )->cRef, cCodFam, aTmpSat[ _CCODTAR ], ( dbfTmpLin )->cCodPr1, ( dbfTmpLin )->cCodPr2, ( dbfTmpLin )->cValPr1, ( dbfTmpLin )->cValPr2, aTmpSat[ _DFECSAT ], dbfTarPreL )
            if nImpOfe != 0
               ( dbfTmpLin )->nDtoPrm  := nImpOfe
            end if

            /*
            Obtenemos el descuento de Agente
            */

            nDtoAge  := RetDtoAge( ( dbfTmpLin )->cRef, cCodFam, aTmpSat[ _CCODTAR ], ( dbfTmpLin )->cCodPr1, ( dbfTmpLin )->cCodPr2, ( dbfTmpLin )->cValPr1, ( dbfTmpLin )->cValPr2, aTmpSat[ _DFECSAT ], aTmpSat[ _CCODAGE ], dbfTarPreL, dbfTarPreS )
            if nDtoAge != 0
               ( dbfTmpLin )->nComAge  := nDtoAge
            end if

         end case

         /*
         Buscamos si existen ofertas para este articulo y le cambiamos el precio
         */

         nImpOfe     := nImpOferta( ( dbfTmpLin )->cRef, aTmpSat[ _CCODCLI ], aTmpSat[ _CCODGRP ], ( dbfTmpLin )->nUniCaja, aTmpSat[ _DFECSAT ], dbfOferta, ( dbfTmpLin )->nTarLin, nil, ( dbfTmpLin )->cCodPr1, ( dbfTmpLin )->cCodPr2, ( dbfTmpLin )->cValPr1, ( dbfTmpLin )->cValPr2 )
         if nImpOfe  != 0
            ( dbfTmpLin )->nPreDiv     := nCnv2Div( nImpOfe, cDivEmp(), aTmpSat[ _CDIVSAT ], dbfDiv )
         end if

         /*
         Buscamos si existen descuentos en las ofertas
         */

         nImpOfe     := nDtoOferta( ( dbfTmpLin )->cRef, aTmpSat[ _CCODCLI ], aTmpSat[ _CCODGRP ], ( dbfTmpLin )->nUniCaja, aTmpSat[ _DFECSAT ], dbfOferta, ( dbfTmpLin )->cCodPr1, ( dbfTmpLin )->cCodPr2, ( dbfTmpLin )->cValPr1, ( dbfTmpLin )->cValPr2 )
         if nImpOfe  != 0
            ( dbfTmpLin )->nDtoPrm  := nImpOfe
         end if

      end if

      ( dbfTmpLin )->( dbSkip() )

   end while

   ( dbfTmpLin )->( dbGoTo( nRecno ) )

return nil

//--------------------------------------------------------------------------//

Function SynSatCli( cPath )

   local oError
   local oBlock
   local nOrdAnt
   local aTotSat

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   USE ( cPatEmp() + "SATCLIT.DBF" )   NEW VIA ( cDriver() ) ALIAS ( cCheckArea( "SATCLIT", @dbfSatCliT ) ) EXCLUSIVE
   SET ADSINDEX TO ( cPatEmp() + "SATCLIT.CDX" ) ADDITIVE

   USE ( cPatEmp() + "SATCLIL.DBF" )   NEW VIA ( cDriver() ) ALIAS ( cCheckArea( "SATCLIL", @dbfSatCliL ) ) EXCLUSIVE
   SET ADSINDEX TO ( cPatEmp() + "SATCLIL.CDX" ) ADDITIVE

   USE ( cPatEmp() + "SATCLII.DBF" )   NEW VIA ( cDriver() ) ALIAS ( cCheckArea( "SATCLII", @dbfSatCliI ) ) EXCLUSIVE
   SET ADSINDEX TO ( cPatEmp() + "SATCLII.CDX" ) ADDITIVE

   USE ( cPatEmp() + "SATCLIS.DBF" )   NEW VIA ( cDriver() ) ALIAS ( cCheckArea( "SATCLIS", @dbfSatCliS ) ) EXCLUSIVE
   SET ADSINDEX TO ( cPatEmp() + "SATCLIS.CDX" ) ADDITIVE

   USE ( cPatArt() + "ARTICULO.DBF" )  NEW VIA ( cDriver() ) ALIAS ( cCheckArea( "ARTICULO", @dbfArticulo ) ) EXCLUSIVE
   SET ADSINDEX TO ( cPatArt() + "ARTICULO.CDX" ) ADDITIVE

   USE ( cPatArt() + "FAMILIAS.DBF" )  NEW VIA ( cDriver() ) ALIAS ( cCheckArea( "FAMILIAS", @dbfFamilia ) ) EXCLUSIVE
   SET ADSINDEX TO ( cPatArt() + "FAMILIAS.CDX" ) ADDITIVE

   USE ( cPatGrp() + "FPAGO.DBF" )     NEW VIA ( cDriver() ) ALIAS ( cCheckArea( "FPAGO", @dbfFPago ) ) EXCLUSIVE
   SET ADSINDEX TO ( cPatGrp() + "FPAGO.CDX" ) ADDITIVE

   USE ( cPatDat() + "TIVA.DBF" )      NEW VIA ( cDriver() ) ALIAS ( cCheckArea( "TIVA", @dbfIva ) ) SHARED
   SET ADSINDEX TO ( cPatDat() + "TIVA.CDX" ) ADDITIVE

   USE ( cPatDat() + "DIVISAS.DBF" )   NEW VIA ( cDriver() ) ALIAS ( cCheckArea( "DIVISAS", @dbfDiv ) ) SHARED
   SET ADSINDEX TO ( cPatDat() + "DIVISAS.CDX" ) ADDITIVE

   ( dbfSatCliT )->( ordSetFocus( 0 ) )
   ( dbfSatCliT )->( dbGoTop() )

      while !( dbfSatCliT )->( eof() )

         if Empty( ( dbfSatCliT )->cSufSat )
            ( dbfSatCliT )->cSufSat := "00"
         end if

         if Empty( ( dbfSatCliT )->cCodCaj )
            ( dbfSatCliT )->cCodCaj := "000"
         end if

         if Empty( ( dbfSatCliT )->cCodGrp )
            ( dbfSatCliT )->cCodGrp := RetGrpCli( ( dbfSatCliT )->cCodCli, dbfClient )
         end if

         /*
         Rellenamos los campos de totales

         if ( dbfSatCliT )->nTotSat == 0 .and. dbLock( dbfSatCliT )

            aTotSat                 := aTotSatCli( ( dbfSatCliT )->cSerSat + Str( ( dbfSatCliT )->nNumSat ) + ( dbfSatCliT )->cSufSat, dbfSatCliT, dbfSatCliL, dbfIva, dbfDiv, dbfFPago, ( dbfSatCliT )->cDivSat )

            ( dbfSatCliT )->nTotNet := aTotSat[1]
            ( dbfSatCliT )->nTotIva := aTotSat[2]
            ( dbfSatCliT )->nTotReq := aTotSat[3]
            ( dbfSatCliT )->nTotSat := aTotSat[4]

            ( dbfSatCliT )->( dbUnLock() )

         end if
         */

         ( dbfSatCliT )->( dbSkip() )

      end while

   ( dbfSatCliT )->( ordSetFocus( 1 ) )

   // lineas ------------------------------------------------------------------

   ( dbfSatCliL )->( ordSetFocus( 0 ) )
   ( dbfSatCliL )->( dbGoTop() )

      while !( dbfSatCliL )->( eof() )

         if Empty( ( dbfSatCliL )->cSufSat )
            ( dbfSatCliL )->cSufSat := "00"
         end if

         if Empty( ( dbfSatCliL )->cLote ) .and. !Empty( ( dbfSatCliL )->nLote )
            ( dbfSatCliL )->cLote   := AllTrim( Str( ( dbfSatCliL )->nLote ) )
         end if

         if ( dbfSatCliL )->lIvaLin != RetFld( ( dbfSatCliL )->cSerSat + Str( ( dbfSatCliL )->nNumSat ) + ( dbfSatCliL )->cSufSat, dbfSatCliT, "lIvaInc" )
            ( dbfSatCliL )->lIvaLin := RetFld( ( dbfSatCliL )->cSerSat + Str( ( dbfSatCliL )->nNumSat ) + ( dbfSatCliL )->cSufSat, dbfSatCliT, "lIvaInc" )
         end if

         if !Empty( ( dbfSatCliL )->cRef ) .and. Empty( ( dbfSatCliL )->cCodFam )
            ( dbfSatCliL )->cCodFam := RetFamArt( ( dbfSatCliL )->cRef, dbfArticulo )
         end if

         if !Empty( ( dbfSatCliL )->cRef ) .and. !Empty( ( dbfSatCliL )->cCodFam )
            ( dbfSatCliL )->cGrpFam := cGruFam( ( dbfSatCliL )->cCodFam, dbfFamilia )
         end if

         if Empty( ( dbfSatCliL )->nReq )
            ( dbfSatCliL )->nReq    := nPReq( dbfIva, ( dbfSatCliL )->nIva )
         end if

         ( dbfSatCliL )->( dbSkip() )

         SysRefresh()

      end while

   ( dbfSatCliL )->( ordSetFocus( 1 ) )

   // Incidencias ------------------------------------------------------------------

   ( dbfSatCliI )->( ordSetFocus( 0 ) )
   ( dbfSatCliI )->( dbGoTop() )

      while !( dbfSatCliI )->( eof() )

         if Empty( ( dbfSatCliI )->cSufSat )
            ( dbfSatCliI )->cSufSat := "00"
         end if

         ( dbfSatCliI )->( dbSkip() )

         SysRefresh()

      end while

   ( dbfSatCliI )->( ordSetFocus( 1 ) )

   // series ------------------------------------------------------------------

   ( dbfSatCliS )->( ordSetFocus( 0 ) )
   ( dbfSatCliS )->( dbGoTop() )

      while !( dbfSatCliS )->( eof() )

         if Empty( ( dbfSatCliS )->cSufSat )
            ( dbfSatCliS )->cSufSat := "00"
         end if
   
         if ( dbfSatCliS )->dFecSat != RetFld( ( dbfSatCliS )->cSerSat + Str( ( dbfSatCliS )->nNumSat ) + ( dbfSatCliS )->cSufSat, dbfSatCliT, "dFecSat" )
            ( dbfSatCliS )->dFecSat := RetFld( ( dbfSatCliS )->cSerSat + Str( ( dbfSatCliS )->nNumSat ) + ( dbfSatCliS )->cSufSat, dbfSatCliT, "dFecSat" )
         end if
   
         ( dbfSatCliS )->( dbSkip() )
   
         SysRefresh()
   
      end while

   ( dbfSatCliS )->( ordSetFocus( 1 ) )

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   CLOSE ( dbfSatCliT )
   CLOSE ( dbfSatCliL )
   CLOSE ( dbfSatCliI )
   CLOSE ( dbfSatCliS )
   CLOSE ( dbfArticulo)
   CLOSE ( dbfFamilia )
   CLOSE ( dbfIva     )
   CLOSE ( dbfDiv     )
   CLOSE ( dbfFPago   )

return nil

//------------------------------------------------------------------------//

CLASS TSATClientesSenderReciver FROM TSenderReciverItem

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
   local dbfSatCliT
   local dbfSatCliL
   local dbfSatCliI
   local tmpSatCliT
   local tmpSatCliL
   local tmpSatCliI
   local cFileName   := "SatCli" + StrZero( ::nGetNumberToSend(), 6 ) + "." + RetSufEmp()

   ::oSender:SetText( "Enviando S.A.T. de clientes" )

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   USE ( cPatEmp() + "SatCliT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "SatCliT", @dbfSatCliT ) )
   SET ADSINDEX TO ( cPatEmp() + "SatCliT.CDX" ) ADDITIVE

   USE ( cPatEmp() + "SatCliL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "SatCliL", @dbfSatCliL ) )
   SET ADSINDEX TO ( cPatEmp() + "SatCliL.CDX" ) ADDITIVE

   USE ( cPatEmp() + "SatCliI.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "SatCliI", @dbfSatCliI ) )
   SET ADSINDEX TO ( cPatEmp() + "SatCliI.CDX" ) ADDITIVE

   /*
   Creamos todas las bases de datos relacionadas con Articulos
   */

   rxSatCli( cPatSnd() )

   USE ( cPatSnd() + "SatCliT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "SatCliT", @tmpSatCliT ) )
   SET ADSINDEX TO ( cPatSnd() + "SatCliT.CDX" ) ADDITIVE

   USE ( cPatSnd() + "SatCliL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "SatCliL", @tmpSatCliL ) )
   SET ADSINDEX TO ( cPatSnd() + "SatCliL.CDX" ) ADDITIVE

   USE ( cPatSnd() + "SatCliI.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "SatCliI", @tmpSatCliI ) )
   SET ADSINDEX TO ( cPatSnd() + "SatCliI.CDX" ) ADDITIVE

   if !Empty( ::oSender:oMtr )
      ::oSender:oMtr:nTotal := ( dbfSatCliT )->( LastRec() )
   end if

   while !( dbfSatCliT )->( eof() )

      if ( dbfSatCliT )->lSndDoc

         lSnd  := .t.

         dbPass( dbfSatCliT, tmpSatCliT, .t. )
         ::oSender:SetText( ( dbfSatCliT )->cSerSat + "/" + AllTrim( Str( ( dbfSatCliT )->nNumSat ) ) + "/" + AllTrim( ( dbfSatCliT )->cSufSat ) + "; " + Dtoc( ( dbfSatCliT )->dFecSat ) + "; " + AllTrim( ( dbfSatCliT )->cCodCli ) + "; " + ( dbfSatCliT )->cNomCli )

         if ( dbfSatCliL )->( dbSeek( ( dbfSatCliT )->CSERSat + Str( ( dbfSatCliT )->NNUMSat ) + ( dbfSatCliT )->CSUFSat ) )
            while ( ( dbfSatCliL )->cSerSat + Str( ( dbfSatCliL )->NNUMSat ) + ( dbfSatCliL )->CSUFSat ) == ( ( dbfSatCliT )->CSERSat + Str( ( dbfSatCliT )->NNUMSat ) + ( dbfSatCliT )->CSUFSat ) .AND. !( dbfSatCliL )->( eof() )
               dbPass( dbfSatCliL, tmpSatCliL, .t. )
               ( dbfSatCliL )->( dbSkip() )
            end do
         end if

         if ( dbfSatCliI )->( dbSeek( ( dbfSatCliT )->cSerSat + Str( ( dbfSatCliT )->nNumSat ) + ( dbfSatCliT )->cSufSat ) )
            while ( ( dbfSatCliI )->cSerSat + Str( ( dbfSatCliI )->nNumSat ) + ( dbfSatCliI )->cSufSat ) == ( ( dbfSatCliT )->cSerSat + Str( ( dbfSatCliT )->nNumSat ) + ( dbfSatCliT )->cSufSat ) .AND. !( dbfSatCliI )->( eof() )
               dbPass( dbfSatCliI, tmpSatCliI, .t. )
               ( dbfSatCliI )->( dbSkip() )
            end do
         end if

      end if

      ( dbfSatCliT )->( dbSkip() )

      if !Empty( ::oSender:oMtr )
         ::oSender:oMtr:Set( ( dbfSatCliT )->( OrdKeyNo() ) )
      end if

   END DO

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   CLOSE ( dbfSatCliT )
   CLOSE ( dbfSatCliL )
   CLOSE ( dbfSatCliI )
   CLOSE ( tmpSatCliT )
   CLOSE ( tmpSatCliL )
   CLOSE ( tmpSatCliI )

   if lSnd

      /*
      Comprimir los archivos---------------------------------------------------
      */

      ::oSender:SetText( "Comprimiendo S.A.T. a clientes" )

      if ::oSender:lZipData( cFileName )
         ::oSender:SetText( "Ficheros comprimidos" )
      else
         ::oSender:SetText( "ERROR al crear fichero comprimido" )
      end if

   else

      ::oSender:SetText( "No hay S.A.T. a clientes para enviar" )

   end if

Return ( Self )

//----------------------------------------------------------------------------//

Method RestoreData()

   local oBlock
   local oError
   local dbfSatCliT

   if ::lSuccesfullSend

      /*
      Retorna el valor anterior
      */

      oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
      BEGIN SEQUENCE

      USE ( cPatEmp() + "SatCliT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "SatCliT", @dbfSatCliT ) )
      SET ADSINDEX TO ( cPatEmp() + "SatCliT.Cdx" ) ADDITIVE
      
      ( dbfSatCliT )->( OrdSetFocus( "lSndDoc" ) )

      while ( dbfSatCliT )->( dbSeek( .t. ) ) .and. !( dbfSatCliT )->( eof() )
         if ( dbfSatCliT )->( dbRLock() )
            ( dbfSatCliT )->lSndDoc := .f.
            ( dbfSatCliT )->( dbRUnlock() )
         end if
      end do

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

      CLOSE ( dbfSatCliT )

   end if

Return ( Self )

//----------------------------------------------------------------------------//

Method SendData()

   local cFileName         := "SatCli" + StrZero( ::nGetNumberToSend(), 6 ) + "." + RetSufEmp()

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

Method ReciveData()

   local n
   local aExt        := aRetDlgEmp()

   /*
   Recibirlo de internet
   */

   ::oSender:SetText( "Recibiendo S.A.T. de clientes" )

   for n := 1 to len( aExt )
      ftpGetFiles( "SatCli*." + aExt[ n ], cPatIn(), 2000, ::oSender )
   next

   ::oSender:SetText( "S.A.T. de clientes recibidos" )

Return Self

//----------------------------------------------------------------------------//

Method Process()

   local m
   local oBlock
   local oError
   local dbfSatCliT
   local dbfSatCliL
   local dbfSatCliI
   local dbfSatClid
   local tmpSatCliT
   local tmpSatCliL
   local tmpSatCliI
   local tmpSatCliD
   local aFiles      := Directory( cPatIn() + "SatCli*.*" )

   for m := 1 to len( aFiles )

      ::oSender:SetText( "Procesando fichero : " + aFiles[ m, 1 ] )

      oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )

      BEGIN SEQUENCE

         if ::oSender:lUnZipData( cPatIn() + aFiles[ m, 1 ] )

            /*
            Ficheros temporales
            */

            if lExistTable( cPatSnd() + "SatCliT.DBF" )   .and.;
               lExistTable( cPatSnd() + "SatCliL.DBF" )   .and.;
               lExistTable( cPatSnd() + "SatCliI.DBF" )

               USE ( cPatSnd() + "SatCliT.DBF" ) NEW VIA ( cDriver() ) READONLY ALIAS ( cCheckArea( "SatCliT", @tmpSatCliT ) )
               SET ADSINDEX TO ( cPatSnd() + "SatCliT.CDX" ) ADDITIVE

               USE ( cPatSnd() + "SatCliL.DBF" ) NEW VIA ( cDriver() ) READONLY ALIAS ( cCheckArea( "SatCliL", @tmpSatCliL ) )
               SET ADSINDEX TO ( cPatSnd() + "SatCliL.CDX" ) ADDITIVE

               USE ( cPatSnd() + "SatCliI.DBF" ) NEW VIA ( cDriver() ) READONLY ALIAS ( cCheckArea( "SatCliI", @tmpSatCliI ) )
               SET ADSINDEX TO ( cPatSnd() + "SatCliI.CDX" ) ADDITIVE

               USE ( cPatSnd() + "SatCliD.DBF" ) NEW VIA ( cDriver() ) READONLY ALIAS ( cCheckArea( "SatCliD", @tmpSatCliD ) )
               SET ADSINDEX TO ( cPatSnd() + "SatCliD.CDX" ) ADDITIVE

               USE ( cPatEmp() + "SatCliT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "SatCliT", @dbfSatCliT ) )
               SET ADSINDEX TO ( cPatEmp() + "SatCliT.CDX" ) ADDITIVE

               USE ( cPatEmp() + "SatCliL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "SatCliL", @dbfSatCliL ) )
               SET ADSINDEX TO ( cPatEmp() + "SatCliL.CDX" ) ADDITIVE

               USE ( cPatEmp() + "SatCliI.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "SatCliI", @dbfSatCliI ) )
               SET ADSINDEX TO ( cPatEmp() + "SatCliI.CDX" ) ADDITIVE

               USE ( cPatEmp() + "SatCliD.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "SatCliD", @dbfSatCliD ) )
               SET ADSINDEX TO ( cPatEmp() + "SatCliD.CDX" ) ADDITIVE

               while !( tmpSatCliT )->( eof() )

                  if lValidaOperacion( ( tmpSatCliT )->dFecSat, .f. ) .and. ;
                     !( dbfSatCliT )->( dbSeek( ( tmpSatCliT )->cSerSat + Str( ( tmpSatCliT )->nNumSat ) + ( tmpSatCliT )->cSufSat ) )

                     dbPass( tmpSatCliT, dbfSatCliT, .t. )
                     ::oSender:SetText( "Añadido     : " + ( tmpSatCliL )->cSerSat + "/" + AllTrim( Str( ( tmpSatCliL )->nNumSat ) ) + "/" + AllTrim( ( tmpSatCliL )->cSufSat ) + "; " + Dtoc( ( tmpSatCliT )->dFecSat ) + "; " + AllTrim( ( tmpSatCliT )->cCodCli ) + "; " + ( tmpSatCliT )->cNomCli )

                     if ( tmpSatCliL )->( dbSeek( ( tmpSatCliT )->cSerSat + Str( ( tmpSatCliT )->nNumSat ) + ( tmpSatCliT )->cSufSat ) )
                        do while ( tmpSatCliL )->cSerSat + Str( ( tmpSatCliL )->nNumSat ) + ( tmpSatCliL )->cSufSat == ( tmpSatCliT )->cSerSat + Str( ( tmpSatCliT )->nNumSat ) + ( tmpSatCliT )->cSufSat .and. !( tmpSatCliL )->( eof() )
                           dbPass( tmpSatCliL, dbfSatCliL, .t. )
                           ( tmpSatCliL )->( dbSkip() )
                        end do
                     end if

                     if ( tmpSatCliI )->( dbSeek( ( tmpSatCliT )->cSerSat + Str( ( tmpSatCliT )->nNumSat ) + ( tmpSatCliT )->cSufSat ) )
                        do while ( tmpSatCliI )->cSerSat + Str( ( tmpSatCliI )->nNumSat ) + ( tmpSatCliI )->cSufSat == ( tmpSatCliT )->cSerSat + Str( ( tmpSatCliT )->nNumSat ) + ( tmpSatCliT )->cSufSat .and. !( tmpSatCliI )->( eof() )
                           dbPass( tmpSatCliI, dbfSatCliI, .t. )
                           ( tmpSatCliI )->( dbSkip() )
                        end do
                     end if

                     if ( tmpSatCliD )->( dbSeek( ( tmpSatCliT )->cSerSat + Str( ( tmpSatCliT )->nNumSat ) + ( tmpSatCliT )->cSufSat ) )
                        do while ( tmpSatCliD )->cSerSat + Str( ( tmpSatCliD )->nNumSat ) + ( tmpSatCliD )->cSufSat == ( tmpSatCliT )->cSerSat + Str( ( tmpSatCliT )->nNumSat ) + ( tmpSatCliT )->cSufSat .and. !( tmpSatCliD )->( eof() )
                           dbPass( tmpSatCliD, dbfSatCliD, .t. )
                           ( tmpSatCliD )->( dbSkip() )
                        end do
                     end if

                  else

                     ::oSender:SetText( "Desestimado : " + ( tmpSatCliL )->cSerSat + "/" + AllTrim( Str( ( tmpSatCliL )->nNumSat ) ) + "/" + AllTrim( ( tmpSatCliL )->cSufSat ) + "; " + Dtoc( ( tmpSatCliT )->dFecSat ) + "; " + AllTrim( ( tmpSatCliT )->cCodCli ) + "; " + ( tmpSatCliT )->cNomCli )

                  end if

                  ( tmpSatCliT )->( dbSkip() )

               end do

               CLOSE ( dbfSatCliT )
               CLOSE ( dbfSatCliL )
               CLOSE ( dbfSatCliI )
               CLOSE ( tmpSatCliT )
               CLOSE ( tmpSatCliL )
               CLOSE ( tmpSatCliI )

               ::oSender:AppendFileRecive( aFiles[ m, 1 ] )

            else

               ::oSender:SetText( "Faltan ficheros" )

               if !lExistTable( cPatSnd() + "SatCliT.DBF" )
                  ::oSender:SetText( "Falta " + cPatSnd() + "SatCliT.DBF" )
               end if

               if !lExistTable( cPatSnd() + "SatCliL.DBF" )
                  ::oSender:SetText( "Falta " + cPatSnd() + "SatCliL.DBF" )
               end if

               if !lExistTable( cPatSnd() + "SatCliI.DBF" )
                  ::oSender:SetText( "Falta " + cPatSnd() + "SatCliL.DBF" )
               end if

               if !lExistTable( cPatSnd() + "SatCliD.DBF" )
                  ::oSender:SetText( "Falta " + cPatSnd() + "SatCliD.DBF" )
               end if

            end if

            fErase( cPatSnd() + "SatCliT.DBF" )
            fErase( cPatSnd() + "SatCliL.DBF" )
            fErase( cPatSnd() + "SatCliI.DBF" )
            fErase( cPatSnd() + "SatCliD.DBF" )

         else

            ::oSender:SetText( "Error al descomprimir los ficheros" )

         end if

      RECOVER USING oError

         CLOSE ( dbfSatCliT )
         CLOSE ( dbfSatCliL )
         CLOSE ( dbfSatCliI )
         CLOSE ( dbfSatCliD )
         CLOSE ( tmpSatCliT )
         CLOSE ( tmpSatCliL )
         CLOSE ( tmpSatCliI )
         CLOSE ( tmpSatCliD )

         ::oSender:SetText( "Error procesando fichero " + aFiles[ m, 1 ] )
         ::oSender:SetText( ErrorMessage( oError ) )

      END SEQUENCE

      ErrorBlock( oBlock )

   next

Return Self

//----------------------------------------------------------------------------//

Static Function nEstadoIncidencia( cNumSat )

   local nEstado  := 0

   if ( dbfSatCliI )->( dbSeek( cNumSat ) )

      while ( dbfSatCliI )->cSerSat + Str( ( dbfSatCliI )->nNumSat ) + ( dbfSatCliI )->cSufSat == cNumSat .and. !( dbfSatCliI )->( Eof() )

         if ( dbfSatCliI )->lListo
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

         ( dbfSatCliI )->( dbSkip() )

      end while

   end if

Return ( nEstado )

//----------------------------------------------------------------------------//

Function AppSatCli( cCodCli, cCodArt, lOpenBrowse )

   local nLevel         := nLevelUsr( _MENUITEM_ )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) != 0 .or. nAnd( nLevel, ACC_APPD ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if lOpenBrowse

      if SatCli( nil, nil, cCodCli, cCodArt )
         oWndBrw:RecAdd()
      end if

   else

      if OpenFiles( .t. )
         WinAppRec( nil, bEdtRec, dbfSatCliT, cCodCli, cCodArt )
         CloseFiles()
      end if

   end if

RETURN .t.

//----------------------------------------------------------------------------//

FUNCTION EdtSatCli( cNumSat, lOpenBrowse )

   local nLevel         := nLevelUsr( _MENUITEM_ )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) != 0 .or. nAnd( nLevel, ACC_EDIT ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if lOpenBrowse

      if SatCli()
         if dbSeekInOrd( cNumSat, "nNumSat", dbfSatCliT )
            oWndBrw:RecEdit()
         else
            MsgStop( "No se encuentra S.A.T." )
         end if
      end if

   else

      if OpenFiles( .t. )

         if dbSeekInOrd( cNumSat, "nNumSat", dbfSatCliT )
            WinEdtRec( nil, bEdtRec, dbfSatCliT )
         end if

         CloseFiles()

      end if

   end if

Return .t.

//----------------------------------------------------------------------------//

FUNCTION ZooSatCli( cNumSat, lOpenBrowse, lPda )

   local nLevel         := nLevelUsr( _MENUITEM_ )

   DEFAULT lOpenBrowse  := .f.
   DEFAULT lPda         := .f.

   if nAnd( nLevel, 1 ) != 0 .or. nAnd( nLevel, ACC_ZOOM ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if lOpenBrowse

      if SatCli()
         if dbSeekInOrd( cNumSat, "nNumSat", dbfSatCliT )
            oWndBrw:RecZoom()
         else
            MsgStop( "No se encuentra S.A.T." )
         end if
      end if

   else

      if OpenFiles( .t. )

         if dbSeekInOrd( cNumSat, "nNumSat", dbfSatCliT )
            WinZooRec( nil, bEdtRec, dbfSatCliT )
         end if

         CloseFiles()

      end if

   end if

Return .t.

//----------------------------------------------------------------------------//

FUNCTION DelSatCli( cNumSat, lOpenBrowse )

   local nLevel         := nLevelUsr( _MENUITEM_ )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) != 0 .or. nAnd( nLevel, ACC_DELE ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if lOpenBrowse

      if SatCli()
         if dbSeekInOrd( cNumSat, "nNumSat", dbfSatCliT )
            WinDelRec( nil, dbfSatCliT, {|| QuiSatCli() } )
         else
            MsgStop( "No se encuentra S.A.T." )
         end if
      end if

   else

      if OpenFiles( .t. )

         if dbSeekInOrd( cNumSat, "nNumSat", dbfSatCliT )
            WinDelRec( nil, dbfSatCliT, {|| QuiSatCli() } )
         end if

         CloseFiles()

      end if

   end if

Return .t.

//----------------------------------------------------------------------------//

FUNCTION PrnSatCli( cNumSat, lOpenBrowse )

   local nLevel         := nLevelUsr( _MENUITEM_ )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) != 0 .or. nAnd( nLevel, ACC_IMPR ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if lOpenBrowse

      if SatCli()
         if dbSeekInOrd( cNumSat, "nNumSat", dbfSatCliT )
            GenSatCli( IS_PRINTER )
         else
            MsgStop( "No se encuentra S.A.T." )
         end if
      end if

   else

      if OpenFiles( .t. )
         if dbSeekInOrd( cNumSat, "nNumSat", dbfSatCliT )
            GenSatCli( IS_PRINTER )
         else
            MsgStop( "No se encuentra S.A.T." )
         end if
         CloseFiles()
      end if

   end if

Return .t.

//----------------------------------------------------------------------------//

FUNCTION VisSatCli( cNumSat, lOpenBrowse )

   local nLevel         := nLevelUsr( _MENUITEM_ )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) != 0 .or. nAnd( nLevel, ACC_IMPR ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if lOpenBrowse

      if SatCli()
         if dbSeekInOrd( cNumSat, "nNumSat", dbfSatCliT )
            GenSatCli( IS_SCREEN )
         else
            MsgStop( "No se encuentra S.A.T." )
         end if
      end if

   else

      if OpenFiles( .t. )

         if dbSeekInOrd( cNumSat, "nNumSat", dbfSatCliT )
            GenSatCli( IS_SCREEN )
         end if

         CloseFiles()

      end if

   end if

Return .t.

//----------------------------------------------------------------------------//

FUNCTION QuiSatCli()

   local nOrdDet
   local nOrdInc
   local nOrdDoc

   if ( dbfSatCliT )->lEstado
      msgStop( "No se pueden eliminar S.A.T. ya procesados." )
      Return .f.
   end if

   if ( dbfSatCliT )->lCloSat .and. !oUser():lAdministrador()
      msgStop( "Solo puede eliminar S.A.T. cerrados los administradores." )
      Return .f.
   end if

   nOrdDet        := ( dbfSatCliL )->( OrdSetFocus( "nNumSat" ) )
   nOrdInc        := ( dbfSatCliI )->( OrdSetFocus( "nNumSat" ) )
   nOrdDoc        := ( dbfSatCliD )->( OrdSetFocus( "nNumSat" ) )

   /*
   Detalle---------------------------------------------------------------------
   */

   while ( dbfSatCliL )->( dbSeek( ( dbfSatCliT )->cSerSat + Str( ( dbfSatCliT )->nNumSat ) + ( dbfSatCliT  )->cSufSat ) ) .and. !( dbfSatCliL )->( eof() )
      if dbLock( dbfSatCliL )
         ( dbfSatCliL )->( dbDelete() )
         ( dbfSatCliL )->( dbUnLock() )
      end if
   end while

   /*
   Documentos------------------------------------------------------------------
   */

   while ( dbfSatCliI )->( dbSeek( ( dbfSatCliT )->cSerSat + Str( ( dbfSatCliT )->nNumSat ) + ( dbfSatCliT  )->cSufSat ) ) .and. !( dbfSatCliI )->( eof() )
      if dbLock( dbfSatCliI )
         ( dbfSatCliI )->( dbDelete() )
         ( dbfSatCliI )->( dbUnLock() )
      end if
   end while

   /*
   Incidencias-----------------------------------------------------------------
   */

   while ( dbfSatCliD )->( dbSeek( ( dbfSatCliT )->cSerSat + Str( ( dbfSatCliT )->nNumSat ) + ( dbfSatCliT  )->cSufSat ) ) .and. !( dbfSatCliD )->( eof() )
      if dbLock( dbfSatCliD )
         ( dbfSatCliD )->( dbDelete() )
         ( dbfSatCliD )->( dbUnLock() )
      end if
   end while

   ( dbfSatCliL )->( OrdSetFocus( nOrdDet ) )
   ( dbfSatCliI )->( OrdSetFocus( nOrdInc ) )
   ( dbfSatCliD )->( OrdSetFocus( nOrdDoc ) )

Return .t.

//---------------------------------------------------------------------------//

Static Function SatCliNotas()

   local cObserv  := ""
   local aData    := {}

   aAdd( aData, "S.A.T. " + ( dbfSatCliT )->cSerSat + "/" + AllTrim( Str( ( dbfSatCliT )->nNumSat ) ) + "/" + Alltrim( ( dbfSatCliT )->cSufSat ) + " de " + Rtrim( ( dbfSatCliT )->cNomCli ) )
   aAdd( aData, SAT_CLI )
   aAdd( aData, ( dbfSatCliT )->cCodCli )
   aAdd( aData, ( dbfSatCliT )->cNomCli )
   aAdd( aData, ( dbfSatCliT )->cSerSat + Str( ( dbfSatCliT )->nNumSat ) + ( dbfSatCliT )->cSufSat )

   if !Empty( ( dbfSatCliT )->cRetPor )
      cObserv     += Rtrim( ( dbfSatCliT )->cRetPor ) + Space( 1 )
   end if

   if !Empty( ( dbfSatCliT )->cRetMat )
      cObserv     += Rtrim( ( dbfSatCliT )->cRetMat ) + Space( 1 )
   end if

   aAdd( aData, cObserv )

   GenerarNotas( aData )

Return ( nil )

//---------------------------------------------------------------------------//

Static Function AppendKit( uTmpLin, aTmpSat )

   local cCodArt
   local cSerSat
   local nNumSat
   local cSufSat
   local nCanSat
   local dFecSat
   local cTipMov
   local cAlmLin
   local nIvaLin
   local lIvaLin
   local nComAge
   local nUniCaj
   local nDtoGrl
   local nDtoPrm
   local nDtoDiv
   local nNumLin
   local nTarLin
   local nRecAct                       := ( dbfKit )->( Recno() )
   local nUnidades                     := 0
   local nStkActual                    := 0

   if ValType( uTmpLin ) == "A"
      cCodArt                          := uTmpLin[ _CREF    ]
      cSerSat                          := uTmpLin[ _CSERSAT ]
      nNumSat                          := uTmpLin[ _NNUMSAT ]
      cSufSat                          := uTmpLin[ _CSUFSAT ]
      nCanSat                          := uTmpLin[ _NCANSAT ]
      dFecSat                          := uTmpLin[ _DFECHA  ]
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
      nTarLin                          := uTmpLin[ _NTARLIN ]
   else
      cCodArt                          := ( uTmpLin )->cRef
      cSerSat                          := ( uTmpLin )->cSerSat
      nNumSat                          := ( uTmpLin )->nNumSat
      cSufSat                          := ( uTmpLin )->cSufSat
      nCanSat                          := ( uTmpLin )->nCanSat
      dFecSat                          := ( uTmpLin )->dFecha
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
      nTarLin                          := ( uTmpLin )->nTarLin
   end if

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

            ( dbfTmpLin )->cRef        := ( dbfkit      )->cRefKit
            ( dbfTmpLin )->cDetalle    := ( dbfArticulo )->Nombre
            ( dbfTmpLin )->nPntVer     := ( dbfArticulo )->nPntVer1
            ( dbfTmpLin )->cUnidad     := ( dbfArticulo )->cUnidad
            ( dbfTmpLin )->nPesokg     := ( dbfArticulo )->nPesoKg
            ( dbfTmpLin )->cPesokg     := ( dbfArticulo )->cUndDim
            ( dbfTmpLin )->nVolumen    := ( dbfArticulo )->nVolumen
            ( dbfTmpLin )->cVolumen    := ( dbfArticulo )->cVolumen

            ( dbfTmpLin )->cCodImp     := ( dbfArticulo )->cCodImp
            ( dbfTmpLin )->lLote       := ( dbfArticulo )->lLote
            ( dbfTmpLin )->nLote       := ( dbfArticulo )->nLote
            ( dbfTmpLin )->cLote       := ( dbfArticulo )->cLote

            ( dbfTmpLin )->nValImp     := oNewImp:nValImp( ( dbfArticulo )->cCodImp )
            ( dbfTmpLin )->nCosDiv     := nCosto( nil, dbfArticulo, dbfKit )

            if ( dbfArticulo )->lFacCnv
               ( dbfTmpLin )->nFacCnv  := ( dbfArticulo )->nFacCnv
            end if

            ( dbfTmpLin )->cSerSat     := cSerSat
            ( dbfTmpLin )->nNumSat     := nNumSat
            ( dbfTmpLin )->cSufSat     := cSufSat
            ( dbfTmpLin )->nCanSat     := nCanSat
            ( dbfTmpLin )->dFecha      := dFecSat
            ( dbfTmpLin )->cTipMov     := cTipMov
            ( dbfTmpLin )->cAlmLin     := cAlmLin
            ( dbfTmpLin )->lIvaLin     := lIvaLin
            ( dbfTmpLin )->nComAge     := nComAge

            /*
            Propiedades de los kits-----------------------------------------
            */

            ( dbfTmpLin )->lImpLin     := lImprimirComponente( cCodArt, dbfArticulo )   // 1 Todos, 2 Compuesto, 3 Componentes
            ( dbfTmpLin )->lKitPrc     := lPreciosComponentes( cCodArt, dbfArticulo )

            /*
            Unidades y precios de los componentes------------------------------
            */

            ( dbfTmpLin )->nUniCaja    := nUniCaj * ( dbfKit )->nUndKit

            if ( dbfTmpLin )->lKitPrc
               ( dbfTmpLin )->nPreDiv  := nRetPreArt( nTarLin, aTmpSat[ _CDIVSAT ], aTmpSat[ _LIVAINC ], dbfArticulo, dbfDiv, dbfKit, dbfIva )
            end if

            /*
            Estudio de los tipos de " + cImp() + " si el padre el cero todos cero------
            */

            if !Empty( nIvaLin )
               ( dbfTmpLin )->nIva     := nIva( dbfIva, ( dbfArticulo )->TipoIva )
               ( dbfTmpLin )->nReq     := nReq( dbfIva, ( dbfArticulo )->TipoIva )
            else
               ( dbfTmpLin )->nIva     := 0
               ( dbfTmpLin )->nReq     := 0
            end if

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
               AppendKit( dbfTmpLin, aTmpSat )
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
                                 "está bajo minimo." + CRLF + ;
                                 "Unidades a vender : " + AllTrim( Trans( nUnidades, MasUnd() ) ) + CRLF + ;
                                 "Stock actual : " + AllTrim( Trans( nStkActual, MasUnd() ) ),;
                                 "¡Atención!" )

               end case

            end if

         end if

         ( dbfKit )->( dbSkip() )

      end while

   end if

   ( dbfKit )->( dbGoTo( nRecAct ) )

Return ( nil )

//---------------------------------------------------------------------------//

STATIC FUNCTION DupSerie( oWndBrw )

   local oDlg
   local oSerIni
   local oSerFin
   local oTxtDup
   local nTxtDup     := 0
   local nRecno      := ( dbfSatCliT )->( Recno() )
   local nOrdAnt     := ( dbfSatCliT )->( OrdSetFocus( 1 ) )
   local oDesde      := TDesdeHasta():Init( ( dbfSatCliT )->cSerSat, ( dbfSatCliT )->nNumSat, ( dbfSatCliT )->cSufSat, GetSysDate() )
   local lCancel     := .f.
   local oBtnAceptar
   local oBtnCancel
   local oFecDoc
   local cFecDoc     := GetSysDate()

   DEFINE DIALOG oDlg ;
      RESOURCE "DUPSERDOC" ;
      TITLE    "Duplicar series de S.A.T." ;
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
      PICTURE  "999999999" ;
      SPINNER ;
      WHEN     ( oDesde:nRadio == 1 );
      OF       oDlg

   REDEFINE GET oDesde:nNumeroFin ;
      ID       130 ;
      PICTURE  "999999999" ;
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
      OF       oDlg ;
      ACTION   ( DupStart( oDesde, oDlg, oBtnAceptar, oBtnCancel, oTxtDup, @lCancel, cFecDoc ) )

   REDEFINE BUTTON oBtnCancel ;
      ID       IDCANCEL ;
      OF       oDlg ;
      CANCEL ;
      ACTION   ( lCancel := .t., oDlg:end() )

   REDEFINE METER oTxtDup VAR nTxtDup ;
      ID       160 ;
      NOPERCENTAGE ;
      TOTAL    ( dbfSatCliT )->( OrdKeyCount() ) ;
      OF       oDlg

      oDlg:AddFastKey( VK_F5, {|| DupStart( oDesde, oDlg, oBtnAceptar, oBtnCancel, oTxtDup, @lCancel, cFecDoc ) } )

   ACTIVATE DIALOG oDlg CENTER VALID ( lCancel )

   ( dbfSatCliT )->( dbGoTo( nRecNo ) )
   ( dbfSatCliT )->( ordSetFocus( nOrdAnt ) )

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

      nOrd              := ( dbfSatCliT )->( OrdSetFocus( "nNumSat" ) )

      ( dbfSatCliT )->( dbSeek( oDesde:cNumeroInicio(), .t. ) )

      while !lCancel .and. ( dbfSatCliT )->( !eof() )

         if ( dbfSatCliT )->cSerSat >= oDesde:cSerieInicio  .and.;
            ( dbfSatCliT )->cSerSat <= oDesde:cSerieFin     .and.;
            ( dbfSatCliT )->nNumSat >= oDesde:nNumeroInicio .and.;
            ( dbfSatCliT )->nNumSat <= oDesde:nNumeroFin    .and.;
            ( dbfSatCliT )->cSufSat >= oDesde:cSufijoInicio .and.;
            ( dbfSatCliT )->cSufSat <= oDesde:cSufijoFin

            ++nDuplicados

            oTxtDup:cText  := "Duplicando : " + ( dbfSatCliT )->cSerSat + "/" + Alltrim( Str( ( dbfSatCliT )->nNumSat ) ) + "/" + ( dbfSatCliT )->cSufSat

            DupSatsupuesto( cFecDoc )

         end if

         ( dbfSatCliT )->( dbSkip() )

         ++nProcesed

         oTxtDup:Set( nProcesed )

      end do

      ( dbfSatCliT )->( OrdSetFocus( nOrd ) )

   else

      nOrd              := ( dbfSatCliT )->( OrdSetFocus( "dFecSat" ) )

      ( dbfSatCliT )->( dbSeek( oDesde:dFechaInicio, .t. ) )

      while !lCancel .and. ( dbfSatCliT )->( !eof() )

         if ( dbfSatCliT )->dFecSat >= oDesde:dFechaInicio  .and.;
            ( dbfSatCliT )->dFecSat <= oDesde:dFechaFin

            ++nDuplicados

            oTxtDup:cText  := "Duplicando : " + ( dbfSatCliT )->cSerSat + "/" + Alltrim( Str( ( dbfSatCliT )->nNumSat ) ) + "/" + ( dbfSatCliT )->cSufSat

            DupSatsupuesto( cFecDoc )

         end if

         ( dbfSatCliT )->( dbSkip() )

         ++nProcesed

         oTxtDup:Set( nProcesed )

      end do

      ( dbfSatCliT )->( OrdSetFocus( nOrd ) )

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

STATIC FUNCTION SatRecDup( cDbf, xField1, xField2, xField3, lCab, cFecDoc )

   local nRec           := ( cDbf )->( Recno() )
   local aTabla         := {}
   local nOrdAnt

   DEFAULT lCab         := .f.

   aTabla               := DBScatter( cDbf )
   aTabla[ _CSERSAT ]   := xField1
   aTabla[ _NNUMSAT ]   := xField2
   aTabla[ _CSUFSAT ]   := xField3

   if lCab

      aTabla[ _CTURSAT     ]  := cCurSesion()
      if !Empty( cFecDoc )
         aTabla[ _DFECSAT  ]  := cFecDoc
      end if
      aTabla[ _CCODCAJ     ]  := oUser():cCaja()
      aTabla[ _DFECENT     ]  := Ctod("")
      aTabla[ _CNUMSat     ]  := Space( 12 )
      aTabla[ _LSNDDOC     ]  := .t.
      aTabla[ _LCLOSAT     ]  := .f.
      aTabla[ _CCODUSR     ]  := cCurUsr()
      aTabla[ _DFECCRE     ]  := GetSysDate()
      aTabla[ _CTIMCRE     ]  := Time()
      aTabla[ _LIMPRIMIDO  ]  := .f.
      aTabla[ _DFECIMP     ]  := Ctod("")
      aTabla[ _CHORIMP     ]  := Space( 5 )
      aTabla[ _CCODDLG     ]  := oUser():cDelegacion()
      aTabla[ _LESTADO     ]  := .f.

      nOrdAnt                 := ( cDbf )->( OrdSetFocus( "NNUMSAT" ) )

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

STATIC FUNCTION DupSatsupuesto( cFecDoc )

   local nNewNumSat  := 0

   //Recogemos el nuevo numero de S.A.T.--------------------------------------

   nNewNumSat  := nNewDoc( ( dbfSatCliT )->cSerSat, dbfSatCliT, "NSATCLI" )

   //Duplicamos las cabeceras--------------------------------------------------

   SatRecDup( dbfSatCliT, ( dbfSatCliT )->cSerSat, nNewNumSat, ( dbfSatCliT )->cSufSat, .t., cFecDoc )

   //Duplicamos las lineas del documento---------------------------------------

   if ( dbfSatCliL )->( dbSeek( ( dbfSatCliT )->cSerSat + Str( ( dbfSatCliT )->nNumSat ) + ( dbfSatCliT )->cSufSat ) )

      while ( dbfSatCliT )->cSerSat + Str( ( dbfSatCliT )->nNumSat ) + ( dbfSatCliT )->cSufSat == ( dbfSatCliL )->cSerSat + Str( ( dbfSatCliL )->nNumSat ) + ( dbfSatCliL )->cSufSat .and. ;
            !( dbfSatCliL )->( Eof() )

         SatRecDup( dbfSatCliL, ( dbfSatCliT )->cSerSat, nNewNumSat, ( dbfSatCliT )->cSufSat, .f. )

         ( dbfSatCliL )->( dbSkip() )

      end while

   end if

   //Duplicamos los documentos-------------------------------------------------

   if ( dbfSatCliD )->( dbSeek( ( dbfSatCliT )->cSerSat + Str( ( dbfSatCliT )->nNumSat ) + ( dbfSatCliT )->cSufSat ) )

      while ( dbfSatCliT )->cSerSat + Str( ( dbfSatCliT )->nNumSat ) + ( dbfSatCliT )->cSufSat == ( dbfSatCliD )->cSerSat + Str( ( dbfSatCliD )->nNumSat ) + ( dbfSatCliD )->cSufSat .and. ;
            !( dbfSatCliD )->( Eof() )

         SatRecDup( dbfSatCliD, ( dbfSatCliT )->cSerSat, nNewNumSat, ( dbfSatCliT )->cSufSat, .f. )

         ( dbfSatCliD )->( dbSkip() )

      end while

   end if

RETURN ( .t. )

//---------------------------------------------------------------------------//

STATIC FUNCTION SetDialog( aGet, oSayGetRnt, oGetRnt )

   aGet[ _CSUSAT   ]:Refresh()

   if !lAccArticulo() .or. oUser():lNotRentabilidad()

      if !Empty( oSayGetRnt )
         oSayGetRnt:Hide()
      end if

      if !Empty( oGetRnt )
         oGetRnt:Hide()
      end if

   end if

   Eval( aGet[ _DFECSAL  ]:bChange )

Return nil

//---------------------------------------------------------------------------//

STATIC FUNCTION ChangeTarifa( aTmp, aGet, aTmpSat )

   local nPrePro  := 0

   if !aTmp[ __LALQUILER ]

      nPrePro     := nPrePro( aTmp[ _CREF ], aTmp[ _CCODPR1 ], aTmp[ _CVALPR1 ], aTmp[ _CCODPR2 ], aTmp[ _CVALPR2 ], aTmp[ _NTARLIN ], aTmpSat[ _LIVAINC ], dbfArtDiv, dbfTarPreL, aTmpSat[ _CCODTAR ] )

      if nPrePro == 0
         nPrePro  := nRetPreArt( aTmp[ _NTARLIN ], aTmpSat[ _CDIVSAT ], aTmpSat[ _LIVAINC ], dbfArticulo, dbfDiv, dbfKit, dbfIva )
      end if

      if nPrePro != 0
         aGet[ _NPREDIV ]:cText( nPrePro )
      end if


   else

      aGet[ _NPREDIV ]:cText( 0 )

      nPrePro := nPreAlq( aTmp[ _CREF ], aTmp[ _NTARLIN ], aTmpSat[ _LIVAINC ], dbfArticulo )

      if nPrePro != 0
         aGet[ _NPREALQ ]:cText( nPrePro )
      end if

   end if

return .t.

//---------------------------------------------------------------------------//

Static Function ValidaMedicion( aTmp, aGet )

   local cNewUndMed  := aGet[ _CUNIDAD ]:VarGet

   /*
   Cargamos el codigo de las unidades---------------------------------
   */

   if ( Empty( cOldUndMed ) .or. cOldUndMed != cNewUndMed )

      if oUndMedicion:oDbf:Seek( aTmp[ _CUNIDAD ] )

         if oUndMedicion:oDbf:nDimension >= 1 .and. !Empty( oUndMedicion:oDbf:cTextoDim1 )
            if !Empty( aGet[ ( dbfSatCliL )->( fieldpos( "nMedUno" ) ) ] )
               aGet[ ( dbfSatCliL )->( fieldpos( "nMedUno" ) ) ]:oSay:SetText( oUndMedicion:oDbf:cTextoDim1 )
               aGet[ ( dbfSatCliL )->( fieldpos( "nMedUno" ) ) ]:cText( ( dbfArticulo )->nLngArt )
               aGet[ ( dbfSatCliL )->( fieldpos( "nMedUno" ) ) ]:Show()
            else
               aTmp[ ( dbfSatCliL )->( fieldpos( "nMedUno" ) ) ]  := ( dbfArticulo )->nLngArt
            end if
         else
            if !Empty( aGet[ ( dbfSatCliL )->( fieldpos( "nMedUno" ) ) ] )
               aGet[ ( dbfSatCliL )->( fieldpos( "nMedUno" ) ) ]:cText( 0 )
               aGet[ ( dbfSatCliL )->( fieldpos( "nMedUno" ) ) ]:Hide()
            else
               aTmp[ ( dbfSatCliL )->( fieldpos( "nMedUno" ) ) ]  := 0
            end if
         end if

         if oUndMedicion:oDbf:nDimension >= 2 .and. !Empty( oUndMedicion:oDbf:cTextoDim2 )
            if !Empty( aGet[ ( dbfSatCliL )->( fieldpos( "nMedDos" ) ) ] )
               aGet[ ( dbfSatCliL )->( fieldpos( "nMedDos" ) ) ]:oSay:SetText( oUndMedicion:oDbf:cTextoDim2 )
               aGet[ ( dbfSatCliL )->( fieldpos( "nMedDos" ) ) ]:cText( ( dbfArticulo )->nAltArt )
               aGet[ ( dbfSatCliL )->( fieldpos( "nMedDos" ) ) ]:Show()
            else
               aTmp[ ( dbfSatCliL )->( fieldpos( "nMedDos" ) ) ]  := ( dbfArticulo )->nAltArt
            end if

         else
            if !Empty( aGet[ ( dbfSatCliL )->( fieldpos( "nMedDos" ) ) ] )
               aGet[ ( dbfSatCliL )->( fieldpos( "nMedDos" ) ) ]:cText( 0 )
               aGet[ ( dbfSatCliL )->( fieldpos( "nMedDos" ) ) ]:Hide()
            else
               aTmp[ ( dbfSatCliL )->( fieldpos( "nMedDos" ) ) ]  := 0
            end if
         end if

         if oUndMedicion:oDbf:nDimension >= 3 .and. !Empty( oUndMedicion:oDbf:cTextoDim3 )
            if !Empty( aGet[ ( dbfSatCliL )->( fieldpos( "nMedTre" ) ) ] )
               aGet[ ( dbfSatCliL )->( fieldpos( "nMedTre" ) ) ]:oSay:SetText( oUndMedicion:oDbf:cTextoDim3 )
               aGet[ ( dbfSatCliL )->( fieldpos( "nMedTre" ) ) ]:cText( ( dbfArticulo ) ->nAncArt )
               aGet[ ( dbfSatCliL )->( fieldpos( "nMedTre" ) ) ]:Show()
            else
               aTmp[ ( dbfSatCliL )->( fieldpos( "nMedTre" ) ) ]  := ( dbfArticulo )->nAncArt
            end if
         else
            if !Empty( aGet[ ( dbfSatCliL )->( fieldpos( "nMedTre" ) ) ] )
               aGet[ ( dbfSatCliL )->( fieldpos( "nMedTre" ) ) ]:cText( 0 )
               aGet[ ( dbfSatCliL )->( fieldpos( "nMedTre" ) ) ]:Hide()
            else
               aTmp[ ( dbfSatCliL )->( fieldpos( "nMedTre" ) ) ]  := 0
            end if
         end if

      else

         if !Empty( aGet[ ( dbfSatCliL )->( fieldpos( "nMedUno" ) ) ] )
            aGet[ ( dbfSatCliL )->( fieldpos( "nMedUno" ) ) ]:Hide()
            aGet[ ( dbfSatCliL )->( fieldpos( "nMedUno" ) ) ]:cText( 0 )
         end if

         if !Empty( aGet[ ( dbfSatCliL )->( fieldpos( "nMedDos" ) ) ] )
            aGet[ ( dbfSatCliL )->( fieldpos( "nMedDos" ) ) ]:Hide()
            aGet[ ( dbfSatCliL )->( fieldpos( "nMedDos" ) ) ]:cText( 0 )
         end if

         if !Empty( aGet[ ( dbfSatCliL )->( fieldpos( "nMedTre" ) ) ] )
            aGet[ ( dbfSatCliL )->( fieldpos( "nMedTre" ) ) ]:Hide()
            aGet[ ( dbfSatCliL )->( fieldpos( "nMedTre" ) ) ]:cText( 0 )
         end if

      end if

      cOldUndMed := cNewUndMed

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

FUNCTION IsSatCli( cPath )

   DEFAULT cPath  := cPatEmp()

   if !lExistTable( cPath + "SatCliT.Dbf" )
      dbCreate( cPath + "SatCliT.Dbf", aSqlStruct( aItmSatCli() ), cDriver() )
   end if

   if !lExistTable( cPath + "SatCliL.Dbf" )
      dbCreate( cPath + "SatCliL.Dbf", aSqlStruct( aColSatCli() ), cDriver() )
   end if

   if !lExistTable( cPath + "SatCliI.Dbf" )
      dbCreate( cPath + "SatCliI.Dbf", aSqlStruct( aIncSatCli() ), cDriver() )
   end if

   if !lExistTable( cPath + "SatCliD.Dbf" )
      dbCreate( cPath + "SatCliD.Dbf", aSqlStruct( aSatCliDoc() ), cDriver() )
   end if

   if !lExistIndex( cPath + "SatCliT.Cdx" ) .or. ;
      !lExistIndex( cPath + "SatCliL.Cdx" ) .or. ;
      !lExistIndex( cPath + "SatCliI.Cdx" ) .or. ;
      !lExistTable( cPath + "SatCliD.Cdx" )

      rxSatCli( cPath )

   end if

Return ( nil )

//---------------------------------------------------------------------------//

#include "FastRepH.ch"

Static Function DataReport( oFr )

   /*
   Zona de datos------------------------------------------------------------
   */

   oFr:ClearDataSets()

   oFr:SetWorkArea(     "SAT", ( dbfSatCliT )->( Select() ), .f., { FR_RB_CURRENT, FR_RB_CURRENT, 0 } )
   oFr:SetFieldAliases( "SAT", cItemsToReport( aItmSatCli() ) )

   oFr:SetWorkArea(     "Lineas de SAT", ( dbfSatCliL )->( Select() ) )
   oFr:SetFieldAliases( "Lineas de SAT", cItemsToReport( aColSatCli() ) )

   oFr:SetWorkArea(     "Incidencias de SAT", ( dbfSatCliI )->( Select() ) )
   oFr:SetFieldAliases( "Incidencias de SAT", cItemsToReport( aIncSatCli() ) )

   oFr:SetWorkArea(     "Documentos de SAT", ( dbfSatCliD )->( Select() ) )
   oFr:SetFieldAliases( "Documentos de SAT", cItemsToReport( aSatCliDoc() ) )

   oFr:SetWorkArea(     "Series de lineas de SAT", ( dbfSatCliS )->( Select() ) )
   oFr:SetFieldAliases( "Series de lineas de SAT", cItemsToReport( aSerSatCli() ) )

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

   oFr:SetWorkArea(     "Ofertas", ( dbfOferta )->( Select() ) )
   oFr:SetFieldAliases( "Ofertas", cItemsToReport( aItmOfe() ) )

   oFr:SetWorkArea(     "Unidades de medición",  oUndMedicion:Select() )
   oFr:SetFieldAliases( "Unidades de medición",  cObjectsToReport( oUndMedicion:oDbf ) )

   oFr:SetWorkArea(     "Usuarios", ( dbfUsr )->( Select() ) )
   oFr:SetFieldAliases( "Usuarios", cItemsToReport( aItmUsr() ) )

   oFr:SetMasterDetail( "SAT", "Lineas de SAT",                   {|| ( dbfSatCliT )->cSerSat + Str( ( dbfSatCliT )->nNumSat ) + ( dbfSatCliT )->cSufSat } )
   oFr:SetMasterDetail( "SAT", "Series de lineas de SAT",         {|| ( dbfSatCliT )->cSerSat + Str( ( dbfSatCliT )->nNumSat ) + ( dbfSatCliT )->cSufSat } )
   oFr:SetMasterDetail( "SAT", "Incidencias de SAT",              {|| ( dbfSatCliT )->cSerSat + Str( ( dbfSatCliT )->nNumSat ) + ( dbfSatCliT )->cSufSat } )
   oFr:SetMasterDetail( "SAT", "Documentos de SAT",               {|| ( dbfSatCliT )->cSerSat + Str( ( dbfSatCliT )->nNumSat ) + ( dbfSatCliT )->cSufSat } )
   oFr:SetMasterDetail( "SAT", "Empresa",                         {|| cCodigoEmpresaEnUso() } )
   oFr:SetMasterDetail( "SAT", "Clientes",                        {|| ( dbfSatCliT )->cCodCli } )
   oFr:SetMasterDetail( "SAT", "Obras",                           {|| ( dbfSatCliT )->cCodCli + ( dbfSatCliT )->cCodObr } )
   oFr:SetMasterDetail( "SAT", "Almacen",                         {|| ( dbfSatCliT )->cCodAlm } )
   oFr:SetMasterDetail( "SAT", "Rutas",                           {|| ( dbfSatCliT )->cCodRut } )
   oFr:SetMasterDetail( "SAT", "Agentes",                         {|| ( dbfSatCliT )->cCodAge } )
   oFr:SetMasterDetail( "SAT", "Formas de pago",                  {|| ( dbfSatCliT )->cCodPgo } )
   oFr:SetMasterDetail( "SAT", "Transportistas",                  {|| ( dbfSatCliT )->cCodTrn } )
   oFr:SetMasterDetail( "SAT", "Usuarios",                        {|| ( dbfSatCliT )->cCodUsr } )

   oFr:SetMasterDetail( "Lineas de SAT", "Artículos",             {|| ( dbfSatCliL )->cRef } )
   oFr:SetMasterDetail( "Lineas de SAT", "Ofertas",               {|| ( dbfSatCliL )->cRef } )
   oFr:SetMasterDetail( "Lineas de SAT", "Unidades de medición",  {|| ( dbfSatCliL )->cUnidad } )

   oFr:SetResyncPair(   "SAT", "Lineas de SAT" )
   oFr:SetResyncPair(   "SAT", "Series de lineas de SAT" )
   oFr:SetResyncPair(   "SAT", "Incidencias de SAT" )
   oFr:SetResyncPair(   "SAT", "Documentos de SAT" )
   oFr:SetResyncPair(   "SAT", "Empresa" )
   oFr:SetResyncPair(   "SAT", "Clientes" )
   oFr:SetResyncPair(   "SAT", "Obras" )
   oFr:SetResyncPair(   "SAT", "Almacenes" )
   oFr:SetResyncPair(   "SAT", "Rutas" )
   oFr:SetResyncPair(   "SAT", "Agentes" )
   oFr:SetResyncPair(   "SAT", "Formas de pago" )
   oFr:SetResyncPair(   "SAT", "Transportistas" )
   oFr:SetResyncPair(   "SAT", "Usuarios" )

   oFr:SetResyncPair(   "Lineas de SAT", "Artículos" )
   oFr:SetResyncPair(   "Lineas de SAT", "Ofertas" )
   oFr:SetResyncPair(   "Lineas de SAT", "Unidades de medición" )

Return nil

//---------------------------------------------------------------------------//

Static Function VariableReport( oFr )

   oFr:DeleteCategory(  "SAT" )
   oFr:DeleteCategory(  "Lineas de SAT" )

   /*
   Creación de variables----------------------------------------------------
   */

   oFr:AddVariable(     "SAT",             "Total bruto",                        "GetHbVar('nTotBrt')" )
   oFr:AddVariable(     "SAT",             "Total SAT",                          "GetHbVar('nTotSat')" )
   oFr:AddVariable(     "SAT",             "Total descuento",                    "GetHbVar('nTotDto')" )
   oFr:AddVariable(     "SAT",             "Total descuento pronto pago",        "GetHbVar('nTotDpp')" )
   oFr:AddVariable(     "SAT",             "Total descuentos",                   "GetHbVar('nTotalDto')" )
   oFr:AddVariable(     "SAT",             "Total neto",                         "GetHbVar('nTotNet')" )
   oFr:AddVariable(     "SAT",             "Total primer descuento definible",   "GetHbVar('nTotUno')" )
   oFr:AddVariable(     "SAT",             "Total segundo descuento definible",  "GetHbVar('nTotDos')" )
   oFr:AddVariable(     "SAT",             "Total " + cImp(),                    "GetHbVar('nTotIva')" )
   oFr:AddVariable(     "SAT",             "Total RE",                           "GetHbVar('nTotReq')" )
   oFr:AddVariable(     "SAT",             "Total página",                       "GetHbVar('nTotPag')" )
   oFr:AddVariable(     "SAT",             "Total retención",                    "GetHbVar('nTotRet')" )
   oFr:AddVariable(     "SAT",             "Total peso",                         "GetHbVar('nTotPes')" )
   oFr:AddVariable(     "SAT",             "Total costo",                        "GetHbVar('nTotCos')" )
   oFr:AddVariable(     "SAT",             "Total anticipado",                   "GetHbVar('nTotAnt')" )
   oFr:AddVariable(     "SAT",             "Total cobrado",                      "GetHbVar('nTotCob')" )
   oFr:AddVariable(     "SAT",             "Total artículos",                    "GetHbVar('nTotArt')" )
   oFr:AddVariable(     "SAT",             "Total cajas",                        "GetHbVar('nTotCaj')" )
   oFr:AddVariable(     "SAT",             "Cuenta por defecto del cliente",     "GetHbVar('cCtaCli')" )

   oFr:AddVariable(     "SAT",             "Bruto primer tipo de " + cImp(),     "GetHbArrayVar('aIvaUno',1)" )
   oFr:AddVariable(     "SAT",             "Bruto segundo tipo de " + cImp(),    "GetHbArrayVar('aIvaDos',1)" )
   oFr:AddVariable(     "SAT",             "Bruto tercer tipo de " + cImp(),     "GetHbArrayVar('aIvaTre',1)" )
   oFr:AddVariable(     "SAT",             "Base primer tipo de " + cImp(),      "GetHbArrayVar('aIvaUno',2)" )
   oFr:AddVariable(     "SAT",             "Base segundo tipo de " + cImp(),     "GetHbArrayVar('aIvaDos',2)" )
   oFr:AddVariable(     "SAT",             "Base tercer tipo de " + cImp(),      "GetHbArrayVar('aIvaTre',2)" )
   oFr:AddVariable(     "SAT",             "Porcentaje primer tipo " + cImp(),   "GetHbArrayVar('aIvaUno',3)" )
   oFr:AddVariable(     "SAT",             "Porcentaje segundo tipo " + cImp(),  "GetHbArrayVar('aIvaDos',3)" )
   oFr:AddVariable(     "SAT",             "Porcentaje tercer tipo " + cImp(),   "GetHbArrayVar('aIvaTre',3)" )
   oFr:AddVariable(     "SAT",             "Porcentaje primer tipo RE",          "GetHbArrayVar('aIvaUno',4)" )
   oFr:AddVariable(     "SAT",             "Porcentaje segundo tipo RE",         "GetHbArrayVar('aIvaDos',4)" )
   oFr:AddVariable(     "SAT",             "Porcentaje tercer tipo RE",          "GetHbArrayVar('aIvaTre',4)" )
   oFr:AddVariable(     "SAT",             "Importe primer tipo " + cImp(),      "GetHbArrayVar('aIvaUno',8)" )
   oFr:AddVariable(     "SAT",             "Importe segundo tipo " + cImp(),     "GetHbArrayVar('aIvaDos',8)" )
   oFr:AddVariable(     "SAT",             "Importe tercer tipo " + cImp(),      "GetHbArrayVar('aIvaTre',8)" )
   oFr:AddVariable(     "SAT",             "Importe primer RE",                  "GetHbArrayVar('aIvaUno',9)" )
   oFr:AddVariable(     "SAT",             "Importe segundo RE",                 "GetHbArrayVar('aIvaDos',9)" )
   oFr:AddVariable(     "SAT",             "Importe tercer RE",                  "GetHbArrayVar('aIvaTre',9)" )

   oFr:AddVariable(     "SAT",             "Total unidades primer tipo de impuestos especiales",            "GetHbArrayVar('aIvmUno',1 )" )
   oFr:AddVariable(     "SAT",             "Total unidades segundo tipo de impuestos especiales",           "GetHbArrayVar('aIvmDos',1 )" )
   oFr:AddVariable(     "SAT",             "Total unidades tercer tipo de impuestos especiales",            "GetHbArrayVar('aIvmTre',1 )" )
   oFr:AddVariable(     "SAT",             "Importe del primer tipo de impuestos especiales",               "GetHbArrayVar('aIvmUno',2 )" )
   oFr:AddVariable(     "SAT",             "Importe del segundo tipo de impuestos especiales",              "GetHbArrayVar('aIvmDos',2 )" )
   oFr:AddVariable(     "SAT",             "Importe del tercer tipo de impuestos especiales",               "GetHbArrayVar('aIvmTre',2 )" )
   oFr:AddVariable(     "SAT",             "Total importe primer tipo de impuestos especiales",             "GetHbArrayVar('aIvmUno',3 )" )
   oFr:AddVariable(     "SAT",             "Total importe segundo tipo de impuestos especiales",            "GetHbArrayVar('aIvmDos',3 )" )
   oFr:AddVariable(     "SAT",             "Total importe tercer tipo de impuestos especiales",             "GetHbArrayVar('aIvmTre',3 )" )

   oFr:AddVariable(     "SAT",             "Fecha del primer vencimiento",        "GetHbArrayVar('aDatVto',1)" )
   oFr:AddVariable(     "SAT",             "Fecha del segundo vencimiento",       "GetHbArrayVar('aDatVto',2)" )
   oFr:AddVariable(     "SAT",             "Fecha del tercer vencimiento",        "GetHbArrayVar('aDatVto',3)" )
   oFr:AddVariable(     "SAT",             "Fecha del cuarto vencimiento",        "GetHbArrayVar('aDatVto',4)" )
   oFr:AddVariable(     "SAT",             "Fecha del quinto vencimiento",        "GetHbArrayVar('aDatVto',5)" )
   oFr:AddVariable(     "SAT",             "Importe del primer vencimiento",      "GetHbArrayVar('aImpVto',1)" )
   oFr:AddVariable(     "SAT",             "Importe del segundo vencimiento",     "GetHbArrayVar('aImpVto',2)" )
   oFr:AddVariable(     "SAT",             "Importe del tercero vencimiento",     "GetHbArrayVar('aImpVto',3)" )
   oFr:AddVariable(     "SAT",             "Importe del cuarto vencimiento",      "GetHbArrayVar('aImpVto',4)" )
   oFr:AddVariable(     "SAT",             "Importe del quinto vencimiento",      "GetHbArrayVar('aImpVto',5)" )

   oFr:AddVariable(     "Lineas de SAT",   "Detalle del artículo",                "CallHbFunc('cDesSatCli')"  )
   oFr:AddVariable(     "Lineas de SAT",   "Total unidades artículo",             "CallHbFunc('nTotNSatCli')" )
   oFr:AddVariable(     "Lineas de SAT",   "Precio unitario del artículo",        "CallHbFunc('nTotUSatCli')" )
   oFr:AddVariable(     "Lineas de SAT",   "Total línea de SAT",                  "CallHbFunc('nTotLSatCli')" )
   oFr:AddVariable(     "Lineas de SAT",   "Total peso por línea",                "CallHbFunc('nPesLSatCli')" )
   oFr:AddVariable(     "Lineas de SAT",   "Total final línea del SAT",           "CallHbFunc('nTotFSatCli')" )

Return nil

//---------------------------------------------------------------------------//

Function DesignReportSatCli( oFr, dbfDoc )

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
                                                   "   CallHbFunc('nTotSatCli');"                              + Chr(13) + Chr(10) + ;
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
         oFr:SetObjProperty(  "CabeceraColumnas",  "DataSet", "SAT" )

         oFr:AddBand(         "DetalleColumnas",   "MainPage", frxDetailData  )
         oFr:SetProperty(     "DetalleColumnas",   "Top", 230 )
         oFr:SetProperty(     "DetalleColumnas",   "Height", 28 )
         oFr:SetObjProperty(  "DetalleColumnas",   "DataSet", "Lineas de SAT" )
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

Function PrintReportSatCli( nDevice, nCopies, cPrinter, dbfDoc )

   local oFr

  local cFilePdf       := cPatTmp() + "SATCliente" + StrTran( ( dbfSatCliT )->cSerSat + Str( ( dbfSatCliT )->nNumSat ) + ( dbfSatCliT )->cSufSat, " ", "" ) + ".Pdf"

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
      Satparar el report-------------------------------------------------------
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

                  :SetTypeDocument( "nSatCli" )
                  :SetDe(           uFieldEmpresa( "cNombre" ) )
                  :SetCopia(        uFieldEmpresa( "cCcpMai" ) )
                  :SetAdjunto(      cFilePdf )
                  :SetPara(         RetFld( ( dbfSatCliT )->cCodCli, dbfClient, "cMeiInt" ) )
                  :SetAsunto(       "Envio de S.A.T. de cliente número " + ( dbfSatCliT )->cSerSat + "/" + Alltrim( Str( ( dbfSatCliT )->nNumSat ) ) )
                  :SetMensaje(      "Adjunto le remito nuestro S.A.T. de cliente " + ( dbfSatCliT )->cSerSat + "/" + Alltrim( Str( ( dbfSatCliT )->nNumSat ) ) + Space( 1 ) )
                  :SetMensaje(      "de fecha " + Dtoc( ( dbfSatCliT )->dFecSat ) + Space( 1 ) )
                  :SetMensaje(      CRLF )
                  :SetMensaje(      CRLF )
                  :SetMensaje(      "Reciba un cordial saludo." )

                  :GeneralResource( dbfSatCliT, aItmSatCli() )

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

#endif

//----------------------------------------------------------------------------//
//Funciones comunes del programa y pda
//----------------------------------------------------------------------------//

FUNCTION nDtoLSatCli( dbfLin, nDec, nVdv, cPorDiv )

   local nCalculo    := 0

   DEFAULT dbfLin    := dbfSatCliL
   DEFAULT nDec      := nDouDiv()
   DEFAULT nVdv      := 1

   if ( dbfLin )->nDto != 0
      nCalculo       := nTotUSatCli( dbfLin, nDec ) * ( dbfLin )->nDto / 100
      nCalculo       := Round( nCalculo / nVdv, nDec )
   end if

RETURN ( if( cPorDiv != nil, Trans( nCalculo, cPorDiv ), nCalculo ) )

//---------------------------------------------------------------------------//

Function nTotDtoLSatCli( dbfLin, nDec, nVdv, cPorDiv )

   local nCalculo

   DEFAULT dbfLin    := dbfSatCliL
   DEFAULT nDec      := nDouDiv()
   DEFAULT nVdv      := 1

   nCalculo          := nDtoLSatCli( dbfLin, nDec, nVdv ) * nTotNSatCli( dbfLin )

   if nVdv != 0
      nCalculo       := nCalculo / nVdv
   end if

   nCalculo          := Round( nCalculo, nDec )

RETURN ( if( cPorDiv != nil, Trans( nCalculo, cPorDiv ), nCalculo ) )

//----------------------------------------------------------------------------//

Static Function YearComboBoxChange()

    if oWndBrw:oWndBar:lAllYearComboBox()
      DestroyFastFilter( dbfSatCliT )
      CreateUserFilter( "", dbfSatCliT, .f., , , "all" )
    else
      DestroyFastFilter( dbfSatCliT )
      CreateUserFilter( "Year( Field->dFecSat ) == " + oWndBrw:oWndBar:cYearComboBox(), dbfSatCliT, .f., , , "Year( Field->dFecSat ) == " + oWndBrw:oWndBar:cYearComboBox() )
    end if

    ( dbfSatCliT )->( dbGoTop() )

    oWndBrw:Refresh()

Return nil

//---------------------------------------------------------------------------//

Function sTotSatCli( cSat, dbfMaster, dbfLine, dbfIva, dbfDiv, cDivRet, lExcCnt )

   local sTotal

   nTotSatCli( cSat, dbfMaster, dbfLine, dbfIva, dbfDiv, nil, nil, cDivRet, .f., lExcCnt )

   sTotal                                 := sTotal()
   sTotal:nTotalBruto                     := nTotBrt
   sTotal:nTotalNeto                      := nTotNet
   sTotal:nTotalIva                       := nTotIva
   sTotal:aTotalIva                       := aTotIva
   sTotal:nTotalRecargoEquivalencia       := nTotReq
   sTotal:nTotalDocumento                 := nTotSat
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

//---------------------------------------------------------------------------//

Static Function SetDiasSAT( aTmp, aGet )

   aGet[ _DFECSAL ]:oSay:SetText( "Entrega " + Alltrim( Str( aTmp[ _DFECSAL ] - aTmp[ _DFECSAT ] ) ) + " dias" )

Return nil 

//---------------------------------------------------------------------------//

