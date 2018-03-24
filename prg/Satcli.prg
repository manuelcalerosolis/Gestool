#include "FiveWin.Ch"
#include "Folder.ch"
#include "Factu.ch" 
#include "Report.ch"
#include "Menu.ch"
#include "Xbrowse.ch"

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
#define _CCODOPE                  83
#define _CCODCAT                  84
#define _CHORINI                  85
#define _CHORFIN                  86
#define _CCODEST                  87
#define _MFIRMA                   88
#define _CCENTROCOSTE             89

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
#define __NBULTOS                 80
#define _CFORMATO                 81
#define __CCODCLI                 82
#define __DFECSAT                 83
#define _NCNTACT                  84
#define _CDESUBI                  85
#define _LLABEL                   86
#define _NLABEL                   87
#define _COBRLIN                  88
#define _CREFAUX                  89
#define _CREFAUX2                 90
#define _NPOSPRINT                91
#define __CCENTROCOSTE            92
#define _CTIPCTR                  93
#define _CTERCTR                  94
#define _ID_TIPO_V                95
#define __NREGIVA                 96

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

memvar nNumArt
memvar nNumCaj

memvar oReport

static oWndBrw

static nView

static oBrwIva
static dbfUsr
static dbfRuta

static dbfSatCliI
static dbfSatCliD
static dbfSatCliS
static dbfClient
static dbfArtPrv
static dbfDiv
static dbfCajT
static oBandera
static oNewImp
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
static dbfProvee
static dbfDoc
static dbfTblPro
static dbfPro
static dbfEstado

static lImpuestos
static oImpuestos

static dbfArtDiv
static dbfDelega
static dbfAgeCom
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
static oOperario
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
static oGetTarifa
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
static bEdtRec          := { | aTmp, aGet, cSatCliT, oBrw, bWhen, bValid, nMode | EdtRec( aTmp, aGet, cSatCliT, oBrw, bWhen, bValid, nMode ) }
static bEdtDet          := { | aTmp, aGet, dbfSatCliL, oBrw, bWhen, bValid, nMode, aTmpSat | EdtDet( aTmp, aGet, dbfSatCliL, oBrw, bWhen, bValid, nMode, aTmpSat ) }
static bEdtInc          := { | aTmp, aGet, dbfSatCliL, oBrw, bWhen, bValid, nMode, aTmpSat | EdtInc( aTmp, aGet, dbfSatCliI, oBrw, bWhen, bValid, nMode, aTmpSat ) }
static bEdtDoc          := { | aTmp, aGet, dbfSatCliD, oBrw, bWhen, bValid, nMode, aTmpSat | EdtDoc( aTmp, aGet, dbfSatCliD, oBrw, bWhen, bValid, nMode, aTmpSat ) }

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
static oBtnPrecio

static oComisionLinea
static nComisionLinea   := 0

static oMailing
static oMailingOperario

static cMaquina         := ""

static oDetCamposExtra

static oBtnKit

static oBrwProperties

static Counter

static oTipoCtrCoste
static cTipoCtrCoste
static aTipoCtrCoste       := { "Centro de coste", "Proveedor", "Agente", "Cliente" }
static oCentroCoste

//----------------------------------------------------------------------------//
//Funciones del programa
//----------------------------------------------------------------------------//

FUNCTION GenSatCli( nDevice, cCaption, cCodDoc, cPrinter, nCopies )

   local oInf
   local oDevice
   local nNumSat

   if ( D():SatClientes( nView ) )->( Lastrec() ) == 0
      return nil
   end if

   nNumSat              := ( D():SatClientes( nView ) )->cSerSat + Str( ( D():SatClientes( nView ) )->nNumSat ) + ( D():SatClientes( nView ) )->cSufSat

   DEFAULT nDevice      := IS_PRINTER
   DEFAULT cCaption     := "Imprimiendo S.A.T."
   DEFAULT cCodDoc      := cFormatoSATClientes()

   if !lExisteDocumento( cCodDoc, dbfDoc )
      return nil
   end if

   // Numero de copias---------------------------------------------------------

   if Empty( nCopies )
      nCopies           := retfld( ( D():SatClientes( nView ) )->cCodCli, D():Get( "Client", nView ), "CopiasF" ) 
   end if

   if nCopies == 0 
      nCopies           := nCopiasDocumento( ( D():SatClientes( nView ) )->cSerSat, "nSatCli", D():Get( "NCount", nView ) )
   end if 

   if nCopies == 0
      nCopies           := 1
   end if  

   /*
   Si el documento es de tipo visual-------------------------------------------
   */

   if lVisualDocumento( cCodDoc, D():Documentos( nView ) )
      PrintReportSatCli( nDevice, nCopies, cPrinter, cCodDoc )
   else
      msgStop( "El formato ya no es soportado" )
   end if

   lChgImpDoc( D():SatClientes( nView ) )

RETURN NIL

//--------------------------------------------------------------------------//

Static Function SatCliReportSkipper( dbf, dbfSatCliL )

   ( dbfSatCliL )->( dbSkip() )

   nTotPage              += nTotLSatCli( dbfSatCliL )

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

      nView             := D():CreateView()

      /*
      Atipicas de clientes-----------------------------------------------------
      */

      D():Atipicas( nView )

      D():SatClientes( nView )

      D():SatClientesLineas( nView )

      D():Clientes( nView )

      D():objectGruposClientes( nView )

      D():Get( "CliInc", nView )

      D():ArticuloStockAlmacenes( nView )  

      D():Articulos( nView )         

      D():Documentos( nView )

      D():Contadores( nView )

      D():ArticuloLenguaje( nView )

      D():GetObject( "UnidadMedicion", nView )

      D():ImpuestosEspeciales( nView )

      D():Ofertas( nView )

      USE ( cPatEmp() + "SATCLII.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "SATCLII", @dbfSatCliI ) )
      SET ADSINDEX TO ( cPatEmp() + "SATCLII.CDX" ) ADDITIVE

      USE ( cPatEmp() + "SATCLID.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "SATCLID", @dbfSatCliD ) )
      SET ADSINDEX TO ( cPatEmp() + "SATCLID.CDX" ) ADDITIVE

      USE ( cPatEmp() + "SATCLIS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "SATCLIS", @dbfSatCliS ) )
      SET ADSINDEX TO ( cPatEmp() + "SATCLIS.CDX" ) ADDITIVE

      USE ( cPatDat() + "TIVA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIVA", @dbfIva ) )
      SET ADSINDEX TO ( cPatDat() + "TIVA.CDX" ) ADDITIVE

      USE ( cPatArt() + "PROVART.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PROVART", @dbfArtPrv ) )
      SET ADSINDEX TO ( cPatArt() + "PROVART.CDX" ) ADDITIVE

      USE ( cPatCli() + "AGENTES.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "AGENTES", @dbfAgent ) )
      SET ADSINDEX TO ( cPatCli() + "AGENTES.CDX" ) ADDITIVE

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

      USE ( cPatEmp() + "FPAGO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FPAGO", @dbfFPago ) )
      SET ADSINDEX TO ( cPatEmp() + "FPAGO.CDX" ) ADDITIVE

      USE ( cPatDat() + "DIVISAS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "DIVISAS", @dbfDiv ) )
      SET ADSINDEX TO ( cPatDat() + "DIVISAS.CDX" ) ADDITIVE

      USE ( cPatEmp() + "RDOCUMEN.DBF" ) NEW SHARED VIA ( cDriver() )ALIAS ( cCheckArea( "RDOCUMEN", @dbfDoc ) )
      SET ADSINDEX TO ( cPatEmp() + "RDOCUMEN.CDX" ) ADDITIVE
      SET TAG TO "CTIPO"

      USE ( cPatArt() + "FAMILIAS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FAMILIAS", @dbfFamilia ) )
      SET ADSINDEX TO ( cPatArt() + "FAMILIAS.CDX" ) ADDITIVE

      USE ( cPatArt() + "ARTKIT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ARTTIK", @dbfKit ) )
      SET ADSINDEX TO ( cPatArt() + "ARTKIT.CDX" ) ADDITIVE

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

      USE ( cPatDat() + "DELEGA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "DELEGA", @dbfDelega ) )
      SET ADSINDEX TO ( cPatDat() + "DELEGA.CDX" ) ADDITIVE

      USE ( cPatEmp() + "AGECOM.DBF" ) NEW SHARED VIA ( cDriver() )ALIAS ( cCheckArea( "AGECOM", @dbfAgeCom ) )
      SET ADSINDEX TO ( cPatEmp() + "AGECOM.CDX" ) ADDITIVE

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

      USE ( cPatEmp() + "AntCliT.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "AntCliT", @dbfAntCliT ) )
      SET ADSINDEX TO ( cPatEmp() + "AntCliT.Cdx" ) ADDITIVE

      USE ( cPatPrv() + "Provee.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "Provee", @dbfProvee ) )
      SET ADSINDEX TO ( cPatPrv() + "Provee.Cdx" ) ADDITIVE

      USE ( cPatEmp() + "ESTADOSAT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ESTADOSAT", @dbfEstado ) )
      SET ADSINDEX TO ( cPatEmp() + "ESTADOSAT.CDX" ) ADDITIVE

      if !TDataCenter():OpenFacCliP( @dbfFacCliP )
         lOpenFiles     := .f.
      end if

      oBandera          := TBandera():New()

      oStock            := TStock():Create( cPatEmp() )
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

      oUndMedicion      := UniMedicion():Create( cPatEmp() )
      if !oUndMedicion:OpenFiles()
         lOpenFiles     := .f.
      end if

      oOperario         := TOperarios():Create()
      if !oOperario:OpenFiles()
         lOpenFiles     := .f.
      end if  

      oCentroCoste        := TCentroCoste():Create( cPatDat() )
      if !oCentroCoste:OpenFiles()
         lOpenFiles     := .f.
      end if 

      oDetCamposExtra   := TDetCamposExtra():New()
      oDetCamposExtra:OpenFiles()
      oDetCamposExtra:SetTipoDocumento( "S.A.T" )
      oDetCamposExtra:setbId( {|| D():SatClientesId( nView ) } )

      oMailing          := TGenmailingDatabaseSATClientes():New( nView )
      oMailing:setBlockRecipients( {|| alltrim( retFld( ( D():SatClientes( nView ) )->cCodCli, D():Clientes( nView ), "cMeiInt" ) ) } )

      oMailingOperario  := TGenmailingDatabaseSATClientes():New( nView )
      oMailingOperario:setBlockRecipients( {|| alltrim( oRetFld( ( D():SatClientes( nView ) )->cCodOpe, oOperario:oDbf, "cMeiTra" ) ) } )

      Counter           := TCounter():New( nView, "nSatCli" )

      CodigosPostales():GetInstance():OpenFiles()

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

      public aTotIva    := { { 0,0,nil,0,0,0,0,0,0,0,0 }, { 0,0,nil,0,0,0,0,0,0,0,0 }, { 0,0,nil,0,0,0,0,0,0,0,0 } }
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
         if SQLAjustableModel():getRolFiltrarVentas( Auth():rolUuid() )         
            cFiltroUsuario += " .and. Field->cCodUsr == '" + Auth():Codigo()  + "'"
         end if 

         ( D():SatClientes( nView ) )->( AdsSetAOF( cFiltroUsuario ) )

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

   DestroyFastFilter( D():SatClientes( nView ), .t., .t. )

   if !Empty( oFont )
      oFont:end()
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

   if !Empty( D():Clientes( nView ) )
      ( D():Clientes( nView )    )->( dbCloseArea() )
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

   if dbfCodebar != nil
      ( dbfCodebar )->( dbCloseArea() )
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

   if !Empty( dbfKit )
      ( dbfKit       )->( dbCloseArea() )
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

   if dbfArtPrv != nil
      ( dbfArtPrv )->( dbCloseArea() )
   end if

   if dbfDelega != nil
      ( dbfDelega )->( dbCloseArea() )
   end if

   if dbfAgeCom != nil
      ( dbfAgeCom )->( dbCloseArea() )
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

   if dbfFacCliP != nil
      ( dbfFacCliP )->( dbCloseArea() )
   end if

   if dbfAntCliT != nil
      ( dbfAntCliT )->( dbCloseArea() )
   end if

   if dbfEstado != nil
      ( dbfEstado )->( dbCloseArea() )
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

   if !Empty( oOperario )
      oOperario:End()
   end if   

   if !Empty( oDetCamposExtra )
      oDetCamposExtra:CloseFiles()
   end if

   if !Empty( oCentroCoste )
      oCentroCoste:End()
   end if

   if !empty( oMailing )
      oMailing:end()
   end if 

   if !empty( oMailingOperario )
      oMailingOperario:End()
   end if 

   D():DeleteView( nView )

   CodigosPostales():GetInstance():CloseFiles()

   dbfSatCliI     := nil
   dbfSatCliD     := nil
   dbfArtPrv      := nil
   dbfIva         := nil
   dbfTarPreL     := nil
   dbfTarPreS     := nil
   dbfPromoT      := nil
   dbfPromoL      := nil
   dbfPromoC      := nil
   dbfAgent       := nil
   dbfCodebar     := nil
   dbfFpago       := nil
   dbfDiv         := nil
   dbfDoc         := nil
   dbfFamilia     := nil
   dbfKit         := nil
   dbfPro         := nil
   dbfTblPro      := nil
   dbfObrasT      := nil
   dbfRuta        := nil
   dbfArtDiv      := nil
   dbfTblCnv      := nil
   dbfCajT        := nil
   dbfUsr         := nil
   dbfDelega      := nil
   oBandera       := nil
   oNewImp        := nil
   oTrans         := nil
   oStock         := nil
   oTipArt        := nil
   oGrpFam        := nil
   dbfAgeCom      := nil
   dbfEmp         := nil
   dbfEstado      := nil

   oOperario      := nil

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

   oCentroCoste   := nil

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
   local oScript

   DEFAULT oMenuItem    := _MENUITEM_
   DEFAULT oWnd         := oWnd()
   DEFAULT cCodCli      := ""
   DEFAULT cCodArt      := ""

   nLevel               := Auth():Level( oMenuItem )
   if nAnd( nLevel, 1 ) == 0
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
               "Código postal",;
               "Población",;
               "Provincia",;
               "Dirección",;
               "Agente",;
               "Operario",;
               "Estado artículo",;
               "Situación";
      MRU      "gc_power_drill_sat_user_16";
      BITMAP   clrTopArchivos ;
      ALIAS    ( D():SatClientes( nView ) );
      APPEND   ( WinAppRec( oWndBrw:oBrw, bEdtRec, D():SatClientes( nView ), cCodCli, cCodArt ) );
      DUPLICAT ( WinDupRec( oWndBrw:oBrw, bEdtRec, D():SatClientes( nView ), cCodCli, cCodArt ) );
      EDIT     ( WinEdtRec( oWndBrw:oBrw, bEdtRec, D():SatClientes( nView ), cCodCli, cCodArt ) );
      ZOOM     ( WinZooRec( oWndBrw:oBrw, bEdtRec, D():SatClientes( nView ) ) );
      DELETE   ( WinDelRec( oWndBrw:oBrw, D():SatClientes( nView ), {|| QuiSatCli() } ) ) ;
      LEVEL    nLevel ;
      OF       oWnd

     oWndBrw:lFechado     := .t.

     oWndBrw:bChgIndex    := {|| if( SQLAjustableModel():getRolFiltrarVentas( Auth():rolUuid() ), CreateFastFilter( cFiltroUsuario, D():SatClientes( nView ), .f., , cFiltroUsuario ), CreateFastFilter( "", D():SatClientes( nView ), .f. ) ) }

     oWndBrw:SetYearComboBoxChange( {|| YearComboBoxChange() } )

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Sesión cerrada"
         :nHeadBmpNo       := 3
         :bStrData         := {|| "" }
         :bEditValue       := {|| ( D():SatClientes( nView ) )->lCloSat }
         :nWidth           := 20
         :SetCheck( { "Sel16", "Nil16" } )
         :AddResource( "gc_lock2_16" )

      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Estado"
         :nHeadBmpNo       := 3
         :bStrData         := {|| "" }
         :bEditValue       := {|| ( D():SatClientes( nView ) )->lEstado }
         :nWidth           := 20
         :SetCheck( { "gc_check_12", "gc_delete_12" } )
         :AddResource( "gc_trafficlight_on_16" )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Envio"
         :nHeadBmpNo       := 3
         :bStrData         := {|| "" }
         :bEditValue       := {|| ( D():SatClientes( nView ) )->lSndDoc }
         :nWidth           := 20
         :SetCheck( { "Sel16", "Nil16" } )
         :AddResource( "gc_mail2_16" )

      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Incidencia"
         :nHeadBmpNo       := 4
         :bStrData         := {|| "" }
         :bBmpData         := {|| nEstadoIncidencia( ( D():SatClientes( nView ) )->cSerSat + Str( ( D():SatClientes( nView ) )->nNumSat ) + ( D():SatClientes( nView ) )->cSufSat ) }
         :nWidth           := 20
         :lHide            := .t.
         :AddResource( "gc_delete_12" )
         :AddResource( "gc_shape_square_12" )
         :AddResource( "gc_check_12" )
         :AddResource( "gc_document_information_16" )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Imprimir"
         :nHeadBmpNo       := 3
         :bStrData         := {|| "" }
         :bEditValue       := {|| ( D():SatClientes( nView ) )->lImprimido }
         :nWidth           := 20
         :lHide            := .t.
         :SetCheck( { "Sel16", "Nil16" } )
         :AddResource( "gc_printer2_16" )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Número"
         :cSortOrder       := "nNumSat"
         :bEditValue       := {|| ( D():SatClientes( nView ) )->cSerSat + "/" + AllTrim( Str( ( D():SatClientes( nView ) )->nNumSat ) ) }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Delegación"
         :bEditValue       := {|| ( D():SatClientes( nView ) )->cCodDlg }
         :nWidth           := 40
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Sesión"
         :bEditValue       := {|| Trans( ( D():SatClientes( nView ) )->cTurSat, "######" ) }
         :nWidth           := 40
         :lHide            := .t.
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Fecha"
         :cSortOrder       := "dDesFec"
         :bEditValue       := {|| Dtoc( ( D():SatClientes( nView ) )->dFecSat ) }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Caja"
         :bEditValue       := {|| ( D():SatClientes( nView ) )->cCodCaj }
         :nWidth           := 40
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Usuario"
         :bEditValue       := {|| ( D():SatClientes( nView ) )->cCodUsr }
         :nWidth           := 40
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Código"
         :cSortOrder       := "cCodCli"
         :bEditValue       := {|| AllTrim( ( D():SatClientes( nView ) )->cCodCli ) }
         :nWidth           := 70
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Nombre"
         :cSortOrder       := "cNomCli"
         :bEditValue       := {|| ( D():SatClientes( nView ) )->cNomCli }
         :nWidth           := 180
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Código postal"
         :cSortOrder       := "CodPostal"
         :bEditValue       := {|| alltrim( ( D():SatClientes( nView ) )->cPosCli ) }
         :nWidth           := 60
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Población"
         :cSortOrder       := "Poblacion"
         :bEditValue       := {|| alltrim( ( D():SatClientes( nView ) )->cPobCli ) }
         :nWidth           := 180
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Provincia"
         :cSortOrder       := "Provincia"
         :bEditValue       := {|| alltrim( ( D():SatClientes( nView ) )->cPrvCli ) }
         :nWidth           := 100
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Agente"
         :cSortOrder       := "cCodAge"
         :bEditValue       := {|| ( D():SatClientes( nView ) )->cCodAge }
         :nWidth           := 50
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Situación"
         :cSortOrder       := "cSituac"
         :bEditValue       := {|| AllTrim( ( D():SatClientes( nView ) )->cSituac ) }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Estado artículo"
         :cSortOrder       := "cCodEst"
         :bStrData         := {|| AllTrim( ( D():SatClientes( nView ) )->cCodEst ) + if( !Empty( ( D():SatClientes( nView ) )->cCodEst ), " - ", "" ) + RetFld( ( D():SatClientes( nView ) )->cCodEst, dbfEstado, "cNombre" ) }
         :nWidth           := 140
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
         :lHide            := .t. 
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Operario"
         :cSortOrder       := "cCodOpe"
         :bStrData         := {|| AllTrim( ( D():SatClientes( nView ) )->cCodOpe ) + if( !Empty( ( D():SatClientes( nView ) )->cCodOpe ), " - ", "" ) + oRetFld( ( D():SatClientes( nView ) )->cCodOpe, oOperario:oDbf, "cNomTra", "cCodTra" ) }
         :nWidth           := 140
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
         :lHide            := .t. 
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Ruta"
         :bEditValue       := {|| ( D():SatClientes( nView ) )->cCodRut }
         :nWidth           := 40
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Almacén"
         :bEditValue       := {|| ( D():SatClientes( nView ) )->cCodAlm }
         :nWidth           := 60
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Dirección"
         :cSortOrder       := "cCodObr"
         :bEditValue       := {|| ( D():SatClientes( nView ) )->cCodObr }
         :nWidth           := 50
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Base"
         :bEditValue       := {|| ( D():SatClientes( nView ) )->nTotNet }
         :cEditPicture     := cPorDiv()
         :nWidth           := 80
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := cImp()
         :bEditValue       := {|| ( D():SatClientes( nView ) )->nTotIva }
         :cEditPicture     := cPorDiv()
         :nWidth           := 80
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "R.E."
         :bEditValue       := {|| ( D():SatClientes( nView ) )->nTotReq }
         :cEditPicture     := cPorDiv()
         :nWidth           := 80
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Total"
         :bEditValue       := {|| ( D():SatClientes( nView ) )->nTotSat }
         :cEditPicture     := cPorDiv()
         :nWidth           := 80
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Div."
         :bEditValue       := {|| cSimDiv( if( lEuro, cDivChg(), ( D():SatClientes( nView ) )->cDivSat ), dbfDiv ) }
         :nWidth           := 30
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

   oDetCamposExtra:addCamposExtra( oWndBrw )

   oWndBrw:cHtmlHelp    := "S.A.T de clientes"
   
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

   DEFINE BTNSHELL RESOURCE "GC_PRINTER2_" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( ImprimirSeriesSatClientes() ) ;
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

   DEFINE BTNSHELL oMail RESOURCE "GC_MAIL_EARTH_" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( oMailing:documentsDialog( oWndBrw:oBrw:aSelected ) ) ;
      TOOLTIP  "Correo electrónico cliente";
      LEVEL    ACC_IMPR

   DEFINE BTNSHELL oMail RESOURCE "GC_MAIL_EARTH_" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( oMailingOperario:documentsDialog( oWndBrw:oBrw:aSelected ) ) ;
      TOOLTIP  "Correo electrónico operario";
      LEVEL    ACC_IMPR

   DEFINE BTNSHELL RESOURCE "gc_portable_barcode_scanner_" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( TLabelGeneratorSATClientes():New( nView ):Dialog() ) ;
         TOOLTIP  "Eti(q)uetas" ;
         HOTKEY   "Q";
         LEVEL    ACC_IMPR

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
      ACTION   lSnd( oWndBrw, D():SatClientes( nView ) ) ;
      HOTKEY   "V";
      LEVEL    ACC_EDIT

      DEFINE BTNSHELL RESOURCE "LBL" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( lSelectAll( oWndBrw, D():SatClientes( nView ), "lSndDoc", .t., .t., .t. ) );
         TOOLTIP  "Todos" ;
         FROM     oSnd ;
         CLOSED ;
         LEVEL    ACC_EDIT

      DEFINE BTNSHELL RESOURCE "LBL" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( lSelectAll( oWndBrw, D():SatClientes( nView ), "lSndDoc", .f., .t., .t. ) );
         TOOLTIP  "Ninguno" ;
         FROM     oSnd ;
         CLOSED ;
         LEVEL    ACC_EDIT

      DEFINE BTNSHELL RESOURCE "LBL" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( lSelectAll( oWndBrw, D():SatClientes( nView ), "lSndDoc", .t., .f., .t. ) );
         TOOLTIP  "Abajo" ;
         FROM     oSnd ;
         CLOSED ;
         LEVEL    ACC_EDIT

   DEFINE BTNSHELL oBtnEur RESOURCE "gc_currency_euro_" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( lEuro := !lEuro, oWndBrw:Refresh() ) ;
      TOOLTIP  "M(o)neda";
      HOTKEY   "O";

   if oUser():lAdministrador()

      DEFINE BTNSHELL oRpl RESOURCE "BMPCHG" GROUP OF oWndBrw ;
         NOBORDER ;
         MENU     This:Toggle() ;
         ACTION   ( ReplaceCreator( oWndBrw, D():SatClientes( nView ), aItmSatCli() ) ) ;
         TOOLTIP  "Cambiar campos" ;
         LEVEL    ACC_EDIT

         DEFINE BTNSHELL RESOURCE "BMPCHG" OF oWndBrw ;
            NOBORDER ;
            ACTION   ( ReplaceCreator( oWndBrw, D():SatClientesLineas( nView ), aColSatCli() ) ) ;
            TOOLTIP  "Lineas" ;
            FROM     oRpl ;
            CLOSED ;
            LEVEL    ACC_EDIT

   end if

   DEFINE BTNSHELL RESOURCE "INFO" GROUP OF oWndBrw ;
      NOBORDER ;
      ACTION   ( TTrazaDocumento():Activate( SAT_CLI, ( D():SatClientes( nView ) )->cSerSat + Str( ( D():SatClientes( nView ) )->nNumSat ) + ( D():SatClientes( nView ) )->cSufSat ) ) ;
      TOOLTIP  "I(n)forme documento" ;
      HOTKEY   "N" ;
      LEVEL    ACC_EDIT

   DEFINE BTNSHELL RESOURCE "gc_document_text_pencil_" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( Counter:OpenDialog() ) ;
      TOOLTIP  "Establecer contadores" 

   DEFINE BTNSHELL oScript RESOURCE "gc_folder_document_" GROUP OF oWndBrw ;
      NOBORDER ;
      ACTION   ( oScript:Expand() ) ;
      TOOLTIP  "Scripts" ;

      ImportScript( oWndBrw, oScript, "SATClientes", nView )  

   DEFINE BTNSHELL oRotor RESOURCE "ROTOR" GROUP OF oWndBrw ;
      NOBORDER ;
      MENU     This:Toggle() ;
      ACTION   ( oRotor:Expand() ) ;
      TOOLTIP  "Rotor" ;

      DEFINE BTNSHELL RESOURCE "GC_USER_" OF oWndBrw ;
         ACTION   ( EdtCli( ( D():SatClientes( nView ) )->cCodCli ) );
         TOOLTIP  "Modificar cliente" ;
         FROM     oRotor ;

      DEFINE BTNSHELL RESOURCE "INFO" OF oWndBrw ;
         ACTION   ( InfCliente( ( D():SatClientes( nView ) )->cCodCli ) ); 
         TOOLTIP  "Informe de cliente" ;
         FROM     oRotor ;

      DEFINE BTNSHELL RESOURCE "GC_WORKER2_" OF oWndBrw ;
         ACTION   ( if( !Empty( ( D():SatClientes( nView ) )->cCodObr ), EdtObras( ( D():SatClientes( nView ) )->cCodCli, ( D():SatClientes( nView ) )->cCodObr, dbfObrasT ), MsgStop( "No hay obra asociada al S.A.T." ) ) );
         TOOLTIP  "Modificar dirección" ;
         FROM     oRotor ;

      DEFINE BTNSHELL RESOURCE "GC_DOCUMENT_EMPTY_" OF oWndBrw ;
         ALLOW    EXIT ;
         ACTION   ( if( !( D():SatClientes( nView ) )->lEstado,;
                        AlbCli( nil, nil, { "SAT" => D():SatClientesId( nView ) }  ),;
                        msgStop( "El S.A.T. ya ha sido convertido" ) ) );
         TOOLTIP  "Generar albarán" ;
         FROM     oRotor ;

      DEFINE BTNSHELL RESOURCE "GC_DOCUMENT_TEXT_USER_" OF oWndBrw ;
         ALLOW    EXIT ;
         ACTION   ( if( !( D():SatClientes( nView ) )->lEstado,;
                        FactCli( nil, nil, { "SAT" => D():SatClientesId( nView ) } ),;
                        msgStop( "El S.A.T. ya ha sido convertido" ) ) );
         TOOLTIP  "Generar factura" ;
         FROM     oRotor ;

      DEFINE BTNSHELL RESOURCE "GC_CASH_REGISTER_USER_" OF oWndBrw ;
         ALLOW    EXIT ;
         ACTION   ( if( !( D():SatClientes( nView ) )->lEstado,;
                        generateTicketFromDocument( { "SAT" => D():SatClientesId( nView ) } ),;
                        msgStop( "El S.A.T. ya ha sido convertido" ) ) );
         TOOLTIP  "Convertir a ticket" ;
         FROM     oRotor ;

   DEFINE BTNSHELL RESOURCE "END" GROUP OF oWndBrw ;
      NOBORDER ;
      ACTION   ( oWndBrw:End() ) ;
      TOOLTIP  "(S)alir";
      HOTKEY   "S"

   if SQLAjustableModel():getRolNoFiltrarVentas( Auth():rolUuid() )
      oWndBrw:oActiveFilter:SetFields( aItmSatCli() )
      oWndBrw:oActiveFilter:SetFilterType( SAT_CLI )
   end if

   ACTIVATE WINDOW oWndBrw VALID ( CloseFiles() )

   EnableAcceso()

   if !empty( oWndBrw )

      if uFieldempresa( 'lFltYea' )
         oWndBrw:setYearCombobox()
      end if

      if !empty( cCodCli ) .or. !empty( cCodArt )
         oWndBrw:RecAdd()
         cCodCli  := nil
         cCodArt  := nil
      end if

   end if 

Return .t.

//----------------------------------------------------------------------------//

STATIC FUNCTION EdtRec( aTmp, aGet, dbf, oBrw, cCodCli, cCodArt, nMode )

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
   local oRieCli
   local nRieCli
   local oTlfCli
   local cTlfCli
   local cSerie         := cNewSer( "nSatCli", D():Documentos( nView ) )
   local oAprovado
   local cAprovado
   local oSayGetRnt
   local cTipSat
   local oSayDias
   local oBmpGeneral
   local oBmpEstado

   /*
   Este valor los guaradamos para detectar los posibles cambios----------------
   */

   cOldCodCli           := aTmp[_CCODCLI]
   cOldSituacion        := aTmp[ _CSITUAC ]

   setOldPorcentajeAgente( aTmp[ _NPCTCOMAGE ] )

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
      aTmp[ _CCODUSR ]  := Auth():Codigo()
      aTmp[ _NVDVSAT ]  := nChgDiv( aTmp[ _CDIVSAT ], dbfDiv )
      aTmp[ _LESTADO ]  := .f.
      aTmp[ _CSUFSAT ]  := RetSufEmp()
      aTmp[ _NDIAVAL ]  := nDiasValidez()
      aTmp[ _LSNDDOC ]  := .t.
      aTmp[ _CCODDLG ]  := oUser():cDelegacion()
      aTmp[ _LIVAINC ]  := uFieldEmpresa( "lIvaInc" )
      aTmp[ _CMANOBR ]  := padr( getConfigTraslation( "Gastos" ), 250 )
      aTmp[ _NIVAMAN ]  := nIva( dbfIva, cDefIva() )

      if !Empty( cCodCli )
         aTmp[ _CCODCLI ]  := cCodCli
      end if

   case nMode == EDIT_MODE

      if aTmp[ _LCLOSAT ] .and. !oUser():lAdministrador()
         msgStop( "El S.A.T. está cerrado." )
         Return .f.
      end if

      lChangeRegIva( aTmp )

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
      aTmp[ _CCODUSR ]  := Auth():Codigo()

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

   if BeginTrans( aTmp, nMode )
      Return .f.
   end if

   cAprovado            := if( aTmp[ _LESTADO ], "Aprobado", "" )

   /*
   Mostramos datos de clientes-------------------------------------------------
   */

   if Empty( aTmp[ _CTLFCLI ] )
      aTmp[ _CTLFCLI ]  := RetFld( aTmp[ _CCODCLI ], D():Clientes( nView ), "Telefono" )
   end if

   /*
   Necestamos el orden el la primera clave-------------------------------------
   */

   nOrd                 := ( D():SatClientes( nView ) )->( ordSetFocus( 1 ) )

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

   cTlfCli              := RetFld( aTmp[ _CCODCLI ], D():Clientes( nView ), "Telefono" )

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
        RESOURCE "gc_power_drill_sat_user_48" ;
        TRANSPARENT ;
        OF       oFld:aDialogs[1]

      REDEFINE BITMAP oBmpGeneral ;
        ID       990 ;
        RESOURCE "gc_folders2_48" ;
        TRANSPARENT ;
        OF       oFld:aDialogs[2]

      REDEFINE BITMAP oBmpGeneral ;
        ID       990 ;
        RESOURCE "gc_information_48" ;
        TRANSPARENT ;
        OF       oFld:aDialogs[3]

      REDEFINE BITMAP oBmpGeneral ;
        ID       990 ;
        RESOURCE "gc_address_book_48" ;
        TRANSPARENT ;
        OF       oFld:aDialogs[4]

      REDEFINE GET aGet[_CCODCLI] VAR aTmp[_CCODCLI] ;
         ID       130 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( LoaCli( aGet, aTmp, nMode, oRieCli ), RecalculaTotal( aTmp ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwClient( aGet[_CCODCLI] ) ) ;
         OF       oFld:aDialogs[1]

      REDEFINE BTNBMP ;
         ID       341 ;
         OF       oFld:aDialogs[1] ;
         RESOURCE "Info16" ;
         NOBORDER ;
         TOOLTIP  "" ;
         ACTION   ( CargaMaquinas( aTmp, oBrwLin ) )

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
         BITMAP   "gc_earth_lupa_16" ;
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
         VALID    ( CodigosPostales():GetInstance():validCodigoPostal() );
         OF       oFld:aDialogs[1]

     /* REDEFINE GET aGet[ _NTARIFA ] VAR aTmp[ _NTARIFA ];
         ID       132 ;
         SPINNER ;
         MIN      1 ;
         MAX      6 ;
         PICTURE  "9" ;
         VALID    ( ChangeTarifaCabecera( aTmp[ _NTARIFA ], dbfTmpLin, oBrwLin ) ) ;
         WHEN     ( nMode != ZOOM_MODE .and. ( lUsrMaster() .or. ( SQLAjustableModel():getRolCambiarPrecios( Auth():rolUuid() ) ) ) );
         OF       oFld:aDialogs[1]*/

      /*
      Tarifas______________________________________________________________
      */

      oGetTarifa  := comboTarifa():Build( { "idCombo" => 132, "uValue" => aTmp[ _NTARIFA ] } )
      oGetTarifa:Resource( oFld:aDialogs[1] )

      REDEFINE BTNBMP oBtnPrecio ;
         ID       174 ;
         OF       oFld:aDialogs[1] ;
         RESOURCE "gc_arrow_down_16" ;
         NOBORDER ;
         ACTION   ( ChangeTarifaCabecera( oGetTarifa:getTarifa(), dbfTmpLin, oBrwLin ) );
         WHEN     ( nMode != ZOOM_MODE .and. ( SQLAjustableModel():getRolCambiarPrecios( Auth():rolUuid() ) ) )


      //____________________________________________________________________

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
         VALID    ( cObras( aGet[ _CCODOBR ], oSay[ 3 ], aTmp[ _CCODCLI ], dbfObrasT ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwObras( aGet[ _CCODOBR ], oSay[ 3 ], aTmp[ _CCODCLI ], dbfObrasT ) ) ;
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
         VALID    ( LoadAgente( aGet[ _CCODAGE ], dbfAgent, oSay[ 6 ], aGet[ _NPCTCOMAGE ], dbfAgeCom, dbfTmpLin, oBrwLin ), RecalculaTotal( aTmp ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwAgentes( aGet[ _CCODAGE ], oSay[ 6 ] ) ) ;
         COLOR    CLR_GET ;
         OF       oFld:aDialogs[1]

      REDEFINE GET oSay[ 6 ] VAR cSay[ 6 ] ;
         ID       181 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         BITMAP   "Bot" ;
         ON HELP  ( changeAgentPercentageInAllLines(aTmp[ _NPCTCOMAGE ], dbfTmpLin, oBrwLin ), RecalculaTotal( aTmp ) ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _NPCTCOMAGE ] VAR aTmp[ _NPCTCOMAGE ] ;
         WHEN     ( !Empty( aTmp[ _CCODAGE ] ) .AND. nMode != ZOOM_MODE ) ;
         VALID    ( validateAgentPercentage( aGet[ _NPCTCOMAGE ], dbfTmpLin, oBrwLin ), RecalculaTotal( aTmp ) );
         PICTURE  "@E 99.99" ;
         SPINNER;
         ID       182 ;
         OF       oFld:aDialogs[1]

      REDEFINE GET oGetAge VAR nTotAge ;
         ID       183 ;
         WHEN     ( .f. );
         OF       oFld:aDialogs[1]
      
      /*
      Operario-----------------------------------------------------------------
      */

      REDEFINE GET aGet[ _CCODOPE ]  VAR aTmp[ _CCODOPE ] ;
         ID       300 ;
         IDTEXT   310 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         BITMAP   "LUPA" ;
         OF       oFld:aDialogs[1]

         aGet[ _CCODOPE ]:bHelp     := {|| oOperario:Buscar( aGet[ _CCODOPE ] ) }
         aGet[ _CCODOPE ]:bValid    := {|| oOperario:Existe( aGet[ _CCODOPE ], aGet[ _CCODOPE ]:oHelpText, "cNomTra", .t., .t., "0" ) }

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
      oBrwLin:bClrStd         := {|| { if( ( dbfTmpLin )->lKitChl, CLR_GRAY, CLR_BLACK ), GetSysColor( COLOR_WINDOW ) } }

      oBrwLin:cAlias          := dbfTmpLin

      oBrwLin:nMarqueeStyle   := 6
      oBrwLin:lFooter         := .t.
      oBrwLin:cName           := "Satsupuesto a cliente.Detalle"

      oBrwLin:CreateFromResource( 210 )

      with object ( oBrwLin:AddCol() )
         :cHeader             := "Oferta"
         :bStrData            := {|| "" }
         :bEditValue          := {|| ( dbfTmpLin )->lLinOfe }
         :nWidth              := 60
         :SetCheck( { "gc_star2_16", "Nil16" } )
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader             := "Número"
         :bEditValue          := {|| ( dbfTmpLin )->nNumLin }
         :cEditPicture        := "9999"
         :nWidth              := 60
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
         :lHide               := .t.
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader             := "Posición"
         :cSortOrder          := "nPosPrint"
         :bEditValue          := {|| ( dbfTmpLin )->nPosPrint }
         :bLClickHeader       := {| nMRow, nMCol, nFlags, oCol | if( !empty( oCol ), oCol:SetOrder(), ) }
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
         :cHeader             := "Observaciones"
         :bEditValue          := {|| ( dbfTmpLin )->mObsLin }
         :nWidth              := 300
         :lHide               := .t.
         :nEditType           := 1
         :bOnPostEdit         := {|o,x,n| ChangeComentario( o, x, n, aTmp ) }
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
         :cHeader             := "Valor prop. 1"
         :bEditValue          := {|| retValProp( ( dbfTmpLin )->cCodPr1 + ( dbfTmpLin )->cValPr1 )}
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
         :cHeader             := "Valor prop. 2"
         :bEditValue          := {|| retValProp( ( dbfTmpLin )->cCodPr2 + ( dbfTmpLin )->cValPr2 )}
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
         :cHeader             := "Bultos"
         :bEditValue          := {|| ( dbfTmpLin )->nBultos }
         :cEditPicture        := cPicUnd
         :nWidth              := 60
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
         :lHide               := .t.
         :nFooterType         := AGGR_SUM
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader             := cNombreCajas()
         :bEditValue          := {|| NotCaja( ( dbfTmpLin )->nCanSat ) }
         :cEditPicture        := cPicUnd
         :nWidth              := 60
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
         :lHide               := .t.
         :nFooterType         := AGGR_SUM
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader             := cNombreUnidades()
         :bEditValue          := {|| nTotNSatCli( dbfTmpLin ) }
         :cEditPicture        := cPicUnd
         :nWidth              := 60
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
         :nFooterType         := AGGR_SUM
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
         :bEditValue          := {|| nTotLSatCli( dbfTmpLin, nDouDiv, nRouDiv, , , aTmp[ _LOPERPV ] ) }
         :cEditPicture        := cPorDiv
         :nWidth              := 80
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
         :nFooterType         := AGGR_SUM
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
      Desglose del impuestos---------------------------------------------------------
      */

      oBrwIva                        := IXBrowse():New( oFld:aDialogs[ 1 ] )

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
         :nWidth           := 76
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      with object ( oBrwIva:AddCol() )
         :cHeader          := "Imp. esp."
         :bStrData         := {|| if( aTotIva[ oBrwIva:nArrayAt, 3 ] != nil, Trans( aTotIva[ oBrwIva:nArrayAt, 6 ], cPorDiv ), "" ) }
         :nWidth           := 76
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      with object ( oBrwIva:AddCol() )
         :cHeader       := "%" + cImp()
         :bStrData      := {|| if( !IsNil( aTotIva[ oBrwIva:nArrayAt, 3 ] ), aTotIva[ oBrwIva:nArrayAt, 3 ], "" ) }
         :bEditValue    := {|| aTotIva[ oBrwIva:nArrayAt, 3 ] }
         :nWidth        := 44
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
         :nWidth           := 76
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      with object ( oBrwIva:AddCol() )
         :cHeader          := "% R.E."
         :bStrData         := {|| if( aTotIva[ oBrwIva:nArrayAt, 3 ] != nil .and. aTmp[ _LRECARGO ], Trans( aTotIva[ oBrwIva:nArrayAt, 4 ], "@EZ 99.9" ), "" ) }
         :nWidth           := 44
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      with object ( oBrwIva:AddCol() )
         :cHeader          := "R.E."
         :bStrData         := {|| if( aTotIva[ oBrwIva:nArrayAt, 3 ] != nil .and. aTmp[ _LRECARGO ], Trans( aTotIva[ oBrwIva:nArrayAt, 9 ], cPorDiv ), "" ) }
         :nWidth           := 76
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

      REDEFINE CHECKBOX oImpuestos VAR lImpuestos ;
         ID       711 ;
         WHEN     ( .f. ) ;
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
         ACTION   ( LineUp( dbfTmpLin, oBrwLin ) )

      REDEFINE BUTTON ;
         ID       525 ;
         OF       oFld:aDialogs[1] ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( LineDown( dbfTmpLin, oBrwLin ) )

      REDEFINE BUTTON oBtnKit;
         ID       526 ;
         OF       oFld:aDialogs[1] ;
         ACTION   ( lEscandalloEdtRec( .t., oBrwLin ) )

      REDEFINE BUTTON ;
         ID       527 ;
         OF       oFld:aDialogs[1] ;
         ACTION   ( importarArticulosScaner() )

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

      REDEFINE GET oAprovado VAR cAprovado ;
         ID       120 ;
         WHEN     ( .F. ) ;
         OF       oFld:aDialogs[1]

      REDEFINE COMBOBOX aGet[ _CSITUAC ] ;
         VAR      aTmp[ _CSITUAC ] ;
         ID       218 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ITEMS    ( SituacionesRepository():getNombres() ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CSUSAT ] VAR aTmp[ _CSUSAT ] ;
         ID       122 ;
         IDSAY    123 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         COLOR    CLR_GET ;
         OF       oFld:aDialogs[1]

      REDEFINE CHECKBOX aGet[ _LIVAINC ] VAR aTmp[ _LIVAINC ] ;
         ID       129 ;
         WHEN     ( ( dbfTmpLin )->( ordKeyCount() ) == 0 ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CCODEST ] VAR aTmp[ _CCODEST ] ;
         ID       350 ;
         IDTEXT   351 ;         
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( cEstadoArticulo( aGet[ _CCODEST ], dbfEstado, aGet[ _CCODEST ]:oHelpText, oBmpEstado ) ) ;
         ON HELP  ( BrwEstadoArticulo( aGet[ _CCODEST ], aGet[ _CCODEST ]:oHelpText, oBmpEstado ) ) ;
         BITMAP   "LUPA" ;
         OF       oFld:aDialogs[1]

      REDEFINE BITMAP oBmpEstado ;
         ID       352 ;
         TRANSPARENT ;
         OF       oFld:aDialogs[1]   

      /*
      Segunda caja de dialogo--------------------------------------------------
      */

      REDEFINE CHECKBOX aGet[ _LGARANTIA ] VAR aTmp[ _LGARANTIA ] ;
         ID       400 ;
         OF       oFld:aDialogs[2]

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

      REDEFINE GET aGet[ _CCENTROCOSTE ] VAR aTmp[ _CCENTROCOSTE ] ;
         ID       350 ;
         IDTEXT   351 ;
         BITMAP   "LUPA" ;
         VALID    ( oCentroCoste:Existe( aGet[ _CCENTROCOSTE ], aGet[ _CCENTROCOSTE ]:oHelpText, "cNombre" ) );
         ON HELP  ( oCentroCoste:Buscar( aGet[ _CCENTROCOSTE ] ) ) ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[2]

     REDEFINE GET aGet[ _NBULTOS ] VAR aTmp[ _NBULTOS ];
         ID       128 ;
         SPINNER;
         PICTURE  "99999" ;
         WHEN     ( nMode != ZOOM_MODE ) ;
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
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[2]

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

      REDEFINE GET aGet[ _CHORINI ] VAR aTmp[ _CHORINI ] ;
         ID       590 ;
         PICTURE  "@R 99:99";
         WHEN     ( nMode != ZOOM_MODE .and. lUsrMaster() ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ _CHORFIN ] VAR aTmp[ _CHORFIN ] ;
         ID       591 ;
         PICTURE  "@R 99:99";
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

      oBrwDoc                 := IXBrowse():New( oFld:aDialogs[ 4 ] )

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
         ACTION   ( RecSatCli( aTmp ), oBrwLin:Refresh( .t. ), RecalculaTotal( aTmp ) )

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
      oDlg:AddFastKey( VK_F9, {|| oDetCamposExtra:Play( Space(1) ) } )

      oDlg:AddFastKey( 65,    {|| if( GetKeyState( VK_CONTROL ), CreateInfoArticulo(), ) } )

   end if

   CodigosPostales():GetInstance():setBinding( { "CodigoPostal" => aGet[ _CPOSCLI ], "Poblacion" => aGet[ _CPOBCLI ], "Provincia" => aGet[ _CPRVCLI ] } )

   do case
      case nMode == APPD_MODE .and. lRecogerUsuario() .and. Empty( cCodArt )
         oDlg:bStart := {|| if( lGetUsuario( aGet[ _CCODUSR ], dbfUsr ), ( aGet[ _CCODOPE ]:lValid(), aGet[ _CCODEST ]:lValid() ), oDlg:End() ) }

      case nMode == APPD_MODE .and. lRecogerUsuario() .and. !Empty( cCodArt )
         oDlg:bStart := {|| if( lGetUsuario( aGet[ _CCODUSR ], dbfUsr ), ( aGet[ _CCODOPE ]:lValid(), aGet[ _CCODEST ]:lValid(), AppDeta( oBrwLin, bEdtDet, aTmp, nil, cCodArt ) ), oDlg:End() ) }

      case nMode == APPD_MODE .and. !lRecogerUsuario() .and. !Empty( cCodArt )
         oDlg:bStart := {|| aGet[ _CCODOPE ]:lValid(), aGet[ _CCODEST ]:lValid(), AppDeta( oBrwLin, bEdtDet, aTmp, nil, cCodArt ) }

      otherwise
         oDlg:bStart := {|| StartEdtRec( oBrwLin ) }

   end case

   ACTIVATE DIALOG oDlg;
         ON INIT  (  edtRecMenu( aTmp, oDlg ) ,;
                     setDialog( aGet, oSayGetRnt, oGetRnt ) ,;
                     oBrwLin:Load() ,;
                     oBrwInc:Load() );
         ON PAINT (  RecalculaTotal( aTmp ) );
         CENTER

   oMenu:End()

   oBmpEmp:end()
   oBmpDiv:end()
   oBmpGeneral:End()
   oBmpEstado:End()

   ( D():SatClientes( nView ) )->( ordSetFocus( nOrd ) )

   KillTrans( oBrwLin )

   /*
    Guardamos los datos del browse
   */

   oBrwInc:CloseData()

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

Static Function StartEdtRec( oBrwLin )

   /*
   Mostramos los escandallos---------------------------------------------------
   */

   lEscandalloEdtRec( .f., oBrwLin )


Return ( nil )

//---------------------------------------------------------------------------//
Static Function lEscandalloEdtRec( lSet, oBrwLin )

   local lShwKit     := lShwKit()

   if lSet
      lShwKit        := !lShwKit
   end if

   if lShwKit
      SetWindowText( oBtnKit:hWnd, "Ocultar Esc&ll." )
      if ( dbfTmpLin )->( Used() )
         ( dbfTmpLin )->( dbClearFilter() )
      end if
   else
      SetWindowText( oBtnKit:hWnd, "Mostrar Esc&ll." )
      if ( dbfTmpLin )->( Used() )
         ( dbfTmpLin )->( dbSetFilter( {|| ! Field->lKitChl }, "!lKitChl" ) )
      end if
   end if

   if lSet
      lShwKit( lShwKit )
   end if

   if !Empty( oBrwLin )
      oBrwLin:Refresh()
   end if   

Return ( nil )

//---------------------------------------------------------------------------//

static function CargaMaquinas( aTmp, oBrwLin )

   if !Empty( aTmp[ _CCODCLI ] )
      cMaquina    := InfCliente( aTmp[ _CCODCLI ], nil, .t. )
   end if
   
   if !Empty( cMaquina )
      AppDeta( oBrwLin, bEdtDet, aTmp, , cMaquina  )
   end if

return .t.

//---------------------------------------------------------------------------//

Static Function EdtRecMenu( aTmp, oDlg )

   MENU oMenu

      MENUITEM    "&1. Rotor"

         MENU

            if !lExternal

            MENUITEM    "&1. Campos extra [F9]";
               MESSAGE  "Mostramos y rellenamos los campos extra para la familia" ;
               RESOURCE "gc_form_plus2_16" ;
               ACTION   ( oDetCamposExtra:Play( Space(1) ) )

            MENUITEM    "&2. Modificar cliente";
               MESSAGE  "Modificar la ficha del cliente" ;
               RESOURCE "gc_user_16" ;
               ACTION   ( if( !Empty( aTmp[ _CCODCLI ] ), EdtCli( aTmp[ _CCODCLI ] ), MsgStop( "Código cliente vacío" ) ) )

            MENUITEM    "&3. Modificar cliente contactos";
               MESSAGE  "Modifica la ficha del cliente en contactos" ;
               RESOURCE "gc_user_16" ;
               ACTION   ( if( !Empty( aTmp[ _CCODCLI ] ), EdtCli( aTmp[ _CCODCLI ], , 5 ), MsgStop( "Código de cliente vacío" ) ) )

            MENUITEM    "&4. Informe de cliente";
               MESSAGE  "Abrir el informe del cliente" ;
               RESOURCE "Info16" ;
               ACTION   ( if( !Empty( aTmp[ _CCODCLI ] ), InfCliente( aTmp[ _CCODCLI ] ), MsgStop( "Código cliente vacío" ) ) );

            MENUITEM    "&5. Modificar dirección";
               MESSAGE  "Modificar ficha de la dirección" ;
               RESOURCE "gc_worker2_16" ;
               ACTION   ( if( !Empty( aTmp[ _CCODOBR ] ), EdtObras( aTmp[ _CCODCLI ], aTmp[ _CCODOBR ], dbfObrasT ), MsgStop( "No hay obra asociada para el S.A.T." ) ) )

            SEPARATOR

            end if

            MENUITEM    "&6. Informe del documento";
               MESSAGE  "Abrir el informe del documento" ;
               RESOURCE "Info16" ;
               ACTION   ( TTrazaDocumento():Activate( SAT_CLI, aTmp[ _CSERSAT ] + Str( aTmp[ _NNUMSAT ] ) + aTmp[ _CSUFSAT ] ) )

            MENUITEM    "&7. Firmar documento";
               MESSAGE  "Firmar documento" ;
               RESOURCE "gc_sign_document_16" ;
               ACTION   ( if( empty( aTmp[ _MFIRMA ] ) .or.  msgNoYes( "El documento ya está firmado, ¿Desea voler a firmarlo?" ),;
                              aTmp[ _MFIRMA ] := signatureToMemo(),;
                              ) ) 

         ENDMENU

   ENDMENU

   oDlg:SetMenu( oMenu )

Return ( oMenu )

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

   cTipoCtrCoste           := AllTrim( aTmp[ _CTIPCTR ] )

   do case
   case nMode == APPD_MODE

      aTmp[ _CSERSAT  ]    := aTmpSat[ _CSERSAT ]
      aTmp[ _NNUMSAT  ]    := aTmpSat[ _NNUMSAT ]
      aTmp[ _CSUFSAT  ]    := aTmpSat[ _CSUFSAT ]
      aTmp[ _NUNICAJA ]    := 1
      aTmp[ _LTOTLIN  ]    := lTotLin
      aTmp[ _NCANSAT  ]    := 1
      aTmp[ _LIVALIN  ]    := aTmpSat[ _LIVAINC ]
      aTmp[ _CALMLIN  ]    := aTmpSat[ _CCODALM ]
      aTmp[ __CCODCLI ]    := aTmpSat[ _CCODCLI ]
      aTmp[ __DFECSAT ]    := aTmpSat[ _DFECSAT ]

      aTmp[ _NTARLIN  ]    := oGetTarifa:getTarifa()

      aTmp[ _COBRLIN  ]    := aTmpSat[ _CCODOBR ]

      if !Empty( cCodArtEnt )
         cCodArt           := Padr( cCodArtEnt, 32 )
      end if

      aTmp[ __DFECSAL ]    := aTmpSat[ _DFECSAL ]

      cTipoCtrCoste        := "Centro de coste"

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
                  "&Observaciones",;
                  "&Centro coste";
         DIALOGS  "LFACCLI_1",;
                  "LSATCLI_2",;
                  "LFACCLI_3",;
                  "LCTRCOSTE"

      REDEFINE GET aGet[ _CREF ] VAR cCodArt;
         ID       100 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( LoaArt( aTmp, aGet, aTmpSat, oStkAct, oSayPr1, oSayPr2, oSayVp1, oSayVp2, bmpImage, oSayLote, nMode ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwArticulo( aGet[ _CREF ], aGet[ _CDETALLE ], .f., .t., oBtn, aGet[ _CLOTE ], aTmp[ _CCODPR1 ], aTmp[ _CCODPR2 ], aGet[ _CVALPR1 ], aGet[ _CVALPR2 ], , if( uFieldEmpresa( "lStockAlm" ), aTmp[ _CALMLIN ], nil ) ) ) ;
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

      aGet[ _CLOTE ]:bValid   := {|| oStock:lPutStockActual( aTmp[ _CREF ], aTmp[ _CALMLIN ], aTmp[ _CVALPR1 ], aTmp[ _CVALPR2 ], aTmp[ _CLOTE ], aTmp[ _LKITART ], aTmp[ _NCTLSTK ], oStkAct ) }

      if !aTmp[ __LALQUILER ]

      REDEFINE GET oGetCaducidad VAR dGetCaducidad ;
         ID       340 ;
         IDSAY    341 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

      end if

      // Browse de propiedades-------------------------------------------------

      oBrwProperties                       := IXBrowse():New( oFld:aDialogs[1] )

      oBrwProperties:nDataType             := DATATYPE_ARRAY

      oBrwProperties:bClrSel               := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwProperties:bClrSelFocus          := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrwProperties:lHScroll              := .t.
      oBrwProperties:lVScroll              := .t.

      oBrwProperties:nMarqueeStyle         := 3
      oBrwProperties:lRecordSelector       := .f.
      oBrwProperties:lFastEdit             := .t.
      oBrwProperties:nFreeze               := 1
      oBrwProperties:lFooter               := .t.

      oBrwProperties:SetArray( {}, .f., 0, .f. )

      oBrwProperties:MakeTotals()

      oBrwProperties:CreateFromResource( 500 )

      // Controles de propiedades----------------------------------------------

      REDEFINE GET aGet[ _CVALPR1 ] VAR aTmp[ _CVALPR1 ];
         ID       270 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         BITMAP   "LUPA" ;
         VALID    ( if( lPrpAct( aTmp[_CVALPR1], oSayVp1, aTmp[_CCODPR1 ], dbfTblPro ),;
                        LoaArt( aTmp, aGet, aTmpSat, oStkAct, oSayPr1, oSayPr2, oSayVp1, oSayVp2, bmpImage, oSayLote, nMode, .f. ),;
                        .f. ) );
         ON HELP  ( brwPropiedadActual( aGet[_CVALPR1], oSayVp1, aTmp[_CCODPR1 ] ) ) ;
         OF       oFld:aDialogs[1]

         aGet[ _CVALPR1 ]:bChange   := {|| aGet[ _CVALPR1 ]:Assign(), oStock:lPutStockActual( aTmp[ _CREF ], aTmp[ _CALMLIN ], aTmp[ _CVALPR1 ], aTmp[ _CVALPR2 ], aTmp[ _CLOTE ], aTmp[ _LKITART ], aTmp[ _NCTLSTK ], oStkAct ) }

      REDEFINE SAY oSayPr1 VAR cSayPr1;
         ID       271 ;
         OF       oFld:aDialogs[1]

      REDEFINE GET oSayVp1 VAR cSayVp1;
         ID       272 ;
         WHEN     .f. ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[_CVALPR2] VAR aTmp[_CVALPR2];
         ID       280 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         BITMAP   "LUPA" ;
         VALID    ( if( lPrpAct( aTmp[_CVALPR2], oSayVp2, aTmp[_CCODPR2 ], dbfTblPro ),;
                        LoaArt( aTmp, aGet, aTmpSat, oStkAct, oSayPr1, oSayPr2, oSayVp1, oSayVp2, bmpImage, oSayLote, nMode, .f. ),;
                        .f. ) );
         ON HELP  ( brwPropiedadActual( aGet[_CVALPR2], oSayVp2, aTmp[_CCODPR2 ] ) ) ;
         OF       oFld:aDialogs[1]

         aGet[ _CVALPR2 ]:bChange   := {|| aGet[ _CVALPR2 ]:Assign(), oStock:lPutStockActual( aTmp[ _CREF ], aTmp[ _CALMLIN ], aTmp[ _CVALPR1 ], aTmp[ _CVALPR2 ], aTmp[ _CLOTE ], aTmp[ _LKITART ], aTmp[ _NCTLSTK ], oStkAct ) }

      REDEFINE SAY oSayPr2 VAR cSayPr2;
         ID       281 ;
         OF       oFld:aDialogs[1]

      REDEFINE GET oSayVp2 VAR cSayVp2;
         ID       282 ;
         WHEN     .f. ;
         OF       oFld:aDialogs[1]

      /*
      fin de propiedades
      -------------------------------------------------------------------------
      */

      REDEFINE GET aGet[ _NCNTACT ] VAR aTmp[ _NCNTACT ];
         ID       256 ;
         IDSAY    257 ;
         SPINNER;
         PICTURE  "@E 999999999999.99" ;
         WHEN     ( nMode != ZOOM_MODE ) ;
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

      /*
      Bultos, cajas y unidades-------------------------------------------------
      */

      REDEFINE GET aGet[ __NBULTOS ] ;
         VAR      aTmp[ __NBULTOS ] ;
         ID       450 ;
         IDSAY    451 ;
         SPINNER ;
         WHEN     ( uFieldEmpresa( "lUseBultos" ) .AND. nMode != ZOOM_MODE ) ;
         PICTURE  cPicUnd ;
         OF       oFld:aDialogs[1]

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
         WHEN     ( nMode != ZOOM_MODE .AND. !lTotLin .and. oUser():lModificaUnidades() ) ;
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
         WHEN     ( nMode != ZOOM_MODE .and. ( SQLAjustableModel():getRolCambiarPrecios( Auth():rolUuid() ) ) );
         ON CHANGE(  changeTarifa( aTmp, aGet, aTmpSat ),;
                     loadComisionAgente( aTmp, aGet, aTmpSat ),;
                     recalculaLinea( aTmp, aTmpSat, nDouDiv, oTotal, oRentLin, cCodDiv ) );
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

      REDEFINE GET aGet[ _CFORMATO ] VAR aTmp[ _CFORMATO ];
         ID       460;
         WHEN     ( nMode != ZOOM_MODE ) ;
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
         WHEN     .F. ;
         PICTURE  cPorDiv ;
         OF       oFld:aDialogs[1]

      /*
      Tipo de articulo---------------------------------------------------------
      */

      REDEFINE GET aGet[ _CCODTIP ] VAR aTmp[ _CCODTIP ] ;
         WHEN     ( nMode != ZOOM_MODE .and. nMode != MULT_MODE .and. !lTotLin ) ;
         VALID    ( oTipArt:Existe( aGet[ _CCODTIP ], oGet3 ) ) ;
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

      REDEFINE GET aGet[ _COBRLIN ] VAR aTmp[ _COBRLIN ] ;
         ID       330 ;
         IDTEXT   331 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( cObras( aGet[ _COBRLIN ], aGet[ _COBRLIN ]:oHelpText, aTmpSat[ _CCODCLI ], dbfObrasT ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwObras( aGet[ _COBRLIN ], aGet[ _COBRLIN ]:oHelpText, aTmpSat[ _CCODCLI ], dbfObrasT ) ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET oStkAct VAR nStkAct ;
         ID       310 ;
         WHEN     .f. ;
         PICTURE  cPicUnd ;
         OF       oFld:aDialogs[1]

      /*
      Segunda caja de dialogo--------------------------------------------------
      */

      REDEFINE GET aGet[ _NPOSPRINT ] VAR aTmp[ _NPOSPRINT ] ;
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

      REDEFINE GET aGet[__DFECSAT] VAR aTmp[__DFECSAT] ;
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

      REDEFINE GET aGet[ _CDESUBI ] VAR aTmp[ _CDESUBI ];
         ID       310 ;
         SPINNER;
         WHEN     ( nMode != ZOOM_MODE ) ;
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

      REDEFINE GET aGet[ _CCODPRV ] VAR  aTmp[ _CCODPRV ] ;
        ID       200 ;
        IDTEXT   201 ;   
        WHEN     ( nMode != ZOOM_MODE ) ;
        VALID    ( cProvee( aGet[ _CCODPRV ], dbfProvee, aGet[ _CCODPRV ]:oHelpText ) );
        BITMAP   "LUPA" ;
        ON HELP  ( BrwProvee( aGet[ _CCODPRV ], aGet[ _CCODPRV ]:oHelpText ) ) ;
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
         OF       oFld:aDialogs[3]

      REDEFINE GET aGet[ _DESCRIP ] VAR aTmp[ _DESCRIP ] ;
         MEMO ;
         ID       110 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[3]

      REDEFINE BITMAP bmpImage ;
         ID       220 ;
         FILE     ( cFileBitmap( cPatImg(), aTmp[ _CIMAGEN ] ) );
         ON RIGHT CLICK ( bmpImage:lStretch := !bmpImage:lStretch, bmpImage:Refresh() );
         OF       oDlg

         bmpImage:SetColor( , GetSysColor( 15 ) )

      /*
      Cuarta caja de diálogo-----------------------------------------------------  
      */

      REDEFINE GET aGet[ __CCENTROCOSTE ] VAR  aTmp[ __CCENTROCOSTE ] ;
         ID       410 ;
         IDTEXT   411 ;
         BITMAP   "LUPA" ;  
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( oCentroCoste:Existe( aGet[ __CCENTROCOSTE ], aGet[ __CCENTROCOSTE ]:oHelpText, "cNombre" ) );
         ON HELP  ( oCentroCoste:Buscar( aGet[ __CCENTROCOSTE ] ) ) ;
         OF       oFld:aDialogs[4]

      REDEFINE COMBOBOX oTipoCtrCoste ;
         VAR      cTipoCtrCoste ;
         ITEMS    aTipoCtrCoste ;
         ID       140 ;
         WHEN     ( nMode != ZOOM_MODE ) ; 
         OF       oFld:aDialogs[4]

         oTipoCtrCoste:bChange   := {|| clearGet( aGet[ _CTERCTR ] ), loadGet( aGet[ _CTERCTR ], cTipoCtrCoste ) }

      REDEFINE GET aGet[ _CTERCTR ] ;
         VAR      aTmp[ _CTERCTR ] ;
         ID       150 ;
         IDTEXT   160 ;
         BITMAP   "LUPA" ;
         WHEN     ( nMode != ZOOM_MODE ) ; 
         OF       oFld:aDialogs[4]

      /*
      Botones generales--------------------------------------------------------
      */

      REDEFINE BUTTON oBtn ;
         ID       IDOK ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( SaveDeta( aTmp, aTmpSat, aGet, oDlg, oBrw, bmpImage, nMode, oStkAct, oSayPr1, oSayPr2, oSayVp1, oSayVp2, oTotal, oSayLote, cCodArt, oBtn, oBtnSer, oFld ) )

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
         if uFieldEmpresa( "lGetLot")
            oDlg:AddFastKey( VK_RETURN,   {|| oBtn:SetFocus(), oBtn:Click() } )
         end if 
         oDlg:AddFastKey( VK_F5,          {|| oBtn:SetFocus(), oBtn:Click() } )
      end if

      oDlg:AddFastKey( VK_F6, {|| oBtnSer:Click() } )

      oDlg:bStart := {||   SetDlgMode( aTmp, aGet, nMode, oStkAct, oSayPr1, oSayPr2, oSayVp1, oSayVp2, oTotal, aTmpSat, oSayLote, oRentLin, oFld ),;
                           if( !Empty( oGetCaducidad ), oGetCaducidad:Hide(), ),;
                           if( !Empty( cCodArtEnt ), aGet[ _CREF ]:lValid(), ),;
                           loadGet( aGet[ _CTERCTR ], cTipoCtrCoste ), aGet[ _CTERCTR ]:lValid(),;
                           aGet[ _CUNIDAD ]:lValid(), aGet[ _CCODPRV ]:lValid(), aGet[ _COBRLIN ]:lValid() }

   ACTIVATE DIALOG oDlg CENTER ;
         ON INIT  ( EdtDetMenu( aGet[ _CREF ], oDlg ) );
         ON PAINT ( RecalculaLinea( aTmp, aTmpSat, nDouDiv, oTotal, oRentLin, cCodDiv ) )

   EndDetMenu()

RETURN ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

/*
Estudiamos la posiblidades que se pueden dar en una linea de detalle
*/

STATIC FUNCTION SetDlgMode( aTmp, aGet, nMode, oStkAct, oSayPr1, oSayPr2, oSayVp1, oSayVp2, oTotal, aTmpSat, oSayLote, oRentLin, oFld )

   local cCodArt  := aGet[ _CREF ]:varGet()

   if !uFieldEmpresa( "lUseBultos" )
      aGet[ __NBULTOS ]:Hide()
   else
      if !Empty( aGet[ __NBULTOS ] )
         aGet[ __NBULTOS ]:SetText( uFieldempresa( "cNbrBultos" ) )
      end if 
   end if

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

   if oRentLin != nil .and. SQLAjustableModel():getRolNoMostrarRentabilidad( Auth():rolUuid() )
      oRentLin:Hide()
   end if

   if aTmp[ __LALQUILER ]
      aGet[ _NPREDIV ]:Hide()
      aGet[ _NPREALQ ]:Show()
   end if

   if aTmp[ _NCTLSTK ] == 2

      if !Empty( aGet[ _NCNTACT ] )
         aGet[ _NCNTACT ]:Show()
      end if

   else

      if !Empty( aGet[ _NCNTACT ] )
         aGet[ _NCNTACT ]:Hide()
      end if

   end if

   do case
   case nMode == APPD_MODE

      aTmp[ _CREF    ]  := Space( 32 )
      aTmp[ _LIVALIN ]  := aTmpSat[ _LIVAINC ]
      aTmp[ _NNUMLIN ]  := nLastNum( dbfTmpLin )

      if aGet[ _NPOSPRINT ] != nil
         aGet[ _NPOSPRINT ]:cText( nLastNum( dbfTmpLin, "nPosPrint" ) )
      end if

      aGet[ _NCANSAT  ]:cText( 1 )
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

      if aTmpSat[ _NREGIVA ] <= 2
         aGet[ _NIVA ]:cText( nIva( dbfIva, cDefIva() ) )
      end if

      if !empty( aGet[ __CCENTROCOSTE ] )
         aGet[ __CCENTROCOSTE ]:cText( aTmpSat[ _CCENTROCOSTE ] )
         aGet[ __CCENTROCOSTE ]:lValid()
      endif

      cTipoCtrCoste        := "Centro de coste"
      oTipoCtrCoste:Refresh()
      clearGet( aGet[ _CTERCTR ] )

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

   if !empty( aGet[ __CCENTROCOSTE ] )
      aGet[ __CCENTROCOSTE ]:lValid()
   endif

   if !Empty( oStkAct )

      if !uFieldEmpresa( "lNStkAct" )
         oStkAct:Show()
      else
         oStkAct:Hide()
      end if

   end if

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

   /*
   Mostramos u ocultamos las tarifas por líneas--------------------------------
   */

   if Empty( aTmp[ _NTARLIN ] )
      if !Empty( aGet[ _NTARLIN ] )
         aGet[ _NTARLIN ]:cText( oGetTarifa:getTarifa() )
      else
         aTmp[ _NTARLIN ]     := oGetTarifa:getTarifa()
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

   if ( empty( aTmp[ _NPREDIV ] ) .or. ( SQLAjustableModel():getRolCambiarPrecios( Auth():rolUuid() ) ) ) .and. nMode != ZOOM_MODE

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

   if !Empty( aGet[ ( D():SatClientesLineas( nView ) )->( fieldpos( "nMedUno" ) ) ] )
      aGet[ ( D():SatClientesLineas( nView ) )->( fieldpos( "nMedUno" ) ) ]:Hide()
   end if

   if !Empty( aGet[ ( D():SatClientesLineas( nView ) )->( fieldpos( "nMedDos" ) ) ] )
      aGet[ ( D():SatClientesLineas( nView ) )->( fieldpos( "nMedDos" ) ) ]:Hide()
   end if

   if !Empty( aGet[ ( D():SatClientesLineas( nView ) )->( fieldpos( "nMedTre" ) ) ] )
      aGet[ ( D():SatClientesLineas( nView ) )->( fieldpos( "nMedTre" ) ) ]:Hide()
   end if

   if oUndMedicion:oDbf:Seek(  aTmp[ _CUNIDAD ] )

      if !Empty( aGet[ ( D():SatClientesLineas( nView ) )->( fieldpos( "nMedUno" ) ) ] ) .and. oUndMedicion:oDbf:nDimension >= 1 .and. !Empty( oUndMedicion:oDbf:cTextoDim1 )
         aGet[ ( D():SatClientesLineas( nView ) )->( fieldpos( "nMedUno" ) ) ]:oSay:SetText( oUndMedicion:oDbf:cTextoDim1 )
         aGet[ ( D():SatClientesLineas( nView ) )->( fieldpos( "nMedUno" ) ) ]:Show()
      end if

      if !Empty( aGet[ ( D():SatClientesLineas( nView ) )->( fieldpos( "nMedDos" ) ) ] ) .and. oUndMedicion:oDbf:nDimension >= 2 .and. !Empty( oUndMedicion:oDbf:cTextoDim2 )
         aGet[ ( D():SatClientesLineas( nView ) )->( fieldpos( "nMedDos" ) ) ]:oSay:SetText( oUndMedicion:oDbf:cTextoDim2 )
         aGet[ ( D():SatClientesLineas( nView ) )->( fieldpos( "nMedDos" ) ) ]:Show()
      end if

      if !Empty( aGet[ ( D():SatClientesLineas( nView ) )->( fieldpos( "nMedTre" ) ) ] ) .and. oUndMedicion:oDbf:nDimension >= 3 .and. !Empty( oUndMedicion:oDbf:cTextoDim3 )
         aGet[ ( D():SatClientesLineas( nView ) )->( fieldpos( "nMedTre" ) ) ]:oSay:SetText( oUndMedicion:oDbf:cTextoDim3 )
         aGet[ ( D():SatClientesLineas( nView ) )->( fieldpos( "nMedTre" ) ) ]:Show()
      end if

   end if

   // Empieza la edicion-------------------------------------------------------

   if !Empty( oFld )
      oFld:SetOption( 1 )
   end if

   // Propiedades--------------------------------------------------------------

   if !empty(oBrwProperties)
      oBrwProperties:Hide()
      oBrwProperties:Cargo    := nil
   end if 

   // Focus al codigo-------------------------------------------------------------

   aGet[ _CREF ]:SetFocus()

Return nil

//--------------------------------------------------------------------------//

STATIC FUNCTION SaveDeta( aTmp, aTmpSat, aGet, oDlg2, oBrw, bmpImage, nMode, oStkAct, oSayPr1, oSayPr2, oSayVp1, oSayVp2, oTotal, oSayLote, cCodArt, oBtn, oBtnSer, oFld )

   local n
   local i
   local aClo     
   local nRec     
   local hAtipica
   local nPrecioPropiedades   := 0

   oBtn:SetFocus()

   if !aGet[ _CREF ]:lValid()
      return nil
   end if

   if !lMoreIva( aTmp[ _NIVA ] )
      return nil
   end if

   if Empty( aTmp[ _CALMLIN ] ) .and. !Empty( aTmp[ _CREF ] )
      msgStop( "Código de almacén no puede estar vacío", "Atención" )
      return nil
   end if

   if !cAlmacen( aGet[ _CALMLIN ], dbfAlm )
      return nil
   end if

   //Comprobamos si tiene que introducir números de serie------------------------

   if ( nMode == APPD_MODE ) .and. RetFld( aTmp[ _CREF ], D():Articulos( nView ), "lNumSer" ) .and. !( dbfTmpSer )->( dbSeek( Str( aTmp[ _NNUMLIN ], 4 ) + aTmp[ _CREF ] ) )
      MsgStop( "Tiene que introducir números de serie para este artículo." )
      oBtnSer:Click()
      Return nil
   end if

   // control de precios minimos-----------------------------------------------

   if lPrecioMinimo( aTmp[ _CREF ], aTmp[ _NPREDIV ], nMode, D():Articulos( nView ) )
      msgStop( "El precio de venta es inferior al precio mínimo.")
      Return nil
   end if 

   // Comprobamos, si estamos por contadores, que no sea 0

   if aTmp[ _NCTLSTK ] == 2 .and. aTmp[ _NCNTACT ] == 0
      if !ApoloMsgNoYes( "¿Está seguro de dejar el contador del producto a 0?", "Elija una opción" )
         aGet[ _NCNTACT ]:SetFocus()
         Return nil
      end if
   end if

   // Recno--------------------------------------------------------------------

   aTmp[ _CTIPCTR ]     := cTipoCtrCoste
   nRec                 := ( dbfTmpLin )->( RecNo() )

   aTmp[ _NREQ ]        := nPReq( dbfIva, aTmp[ _NIVA ] )

   aClo                 := aClone( aTmp )

   // Situaciones atipicas-----------------------------------------------------

   if nMode == APPD_MODE

      aTmp[ _CREF ]     := cCodArt

      if aTmp[ _LLOTE ]
         saveLoteActual( aTmp[ _CREF ], aTmp[ _CLOTE ], nView )   
      end if

      // Propiedades ----------------------------------------------------------

      if !empty( oBrwProperties:Cargo )

         for n := 1 to len( oBrwProperties:Cargo )

            for i := 1 to len( oBrwProperties:Cargo[ n ] )

               if isNum( oBrwProperties:Cargo[ n, i ]:Value ) .and. oBrwProperties:Cargo[ n, i ]:Value != 0

                  aTmp[ _NNUMLIN ]     := nLastNum( dbfTmpLin )
                  aTmp[ _NPOSPRINT ]   := nLastNum( dbfTmpLin, "nPosPrint" )
                  aTmp[ _NUNICAJA]     := oBrwProperties:Cargo[ n, i ]:Value
                  aTmp[ _CCODPR1 ]     := oBrwProperties:Cargo[ n, i ]:cCodigoPropiedad1
                  aTmp[ _CVALPR1 ]     := oBrwProperties:Cargo[ n, i ]:cValorPropiedad1
                  aTmp[ _CCODPR2 ]     := oBrwProperties:Cargo[ n, i ]:cCodigoPropiedad2
                  aTmp[ _CVALPR2 ]     := oBrwProperties:Cargo[ n, i ]:cValorPropiedad2

                  // Precio por propiedades --------------------------------------------------

                  nPrecioPropiedades   := nPrePro( aTmp[ _CREF ], aTmp[ _CCODPR1 ], aTmp[ _CVALPR1 ], aTmp[ _CCODPR2 ], aTmp[ _CVALPR2 ], aTmp[ _NTARLIN ], aTmpSat[ _LIVAINC ], dbfArtDiv, dbfTarPreL, aTmpSat[ _CCODTAR ] )
                  if !empty(nPrecioPropiedades)
                     aTmp[ _NPREDIV ]  := nPrecioPropiedades
                  end if 

                  // guarda la linea------------------------------------------- 

                  saveDetail( aTmp, aClo, aGet, aTmpSat, dbfTmpLin, oBrw, nMode )

               end if

            next

         next

         aCopy( dbBlankRec( dbfTmpLin ), aTmp )

         aEval( aGet, {| o, i | if( "GET" $ o:ClassName(), o:cText( aTmp[ i ] ), ) } )

      else

         saveDetail( aTmp, aClo, aGet, aTmpSat, dbfTmpLin, oBrw, nMode )

         //WinGather( aTmp, aGet, dbfTmpLin, oBrw, nMode )

      end if

   else

      WinGather( aTmp, aGet, dbfTmpLin, oBrw, nMode )

   end if

   ( dbfTmpLin )->( dbGoTo( nRec ) )

   // Si estamos añadiendo y hay entradas continuas--------------------------------

   cOldCodArt                          := ""
   cOldUndMed                          := ""

   if !Empty( aGet[ _CUNIDAD ] )
      aGet[ _CUNIDAD ]:lValid()
   end if

   // Liberacion del bitmap-------------------------------------------------------

   if bmpImage != nil
      bmpImage:Hide()
      if !Empty( bmpImage:hBitmap )
         PalbmpFree( bmpImage:hBitmap, bmpImage:hPalette )
      endif
   end if

   if nMode == APPD_MODE .and. lEntCon()

      nTotSatCli( nil, D():SatClientes( nView ), dbfTmpLin, dbfIva, dbfDiv, dbfFPago, aTmpSat )

      aCopy( dbBlankRec( dbfTmpLin ), aTmp )
      aEval( aGet, {| o, i | if( "GET" $ o:ClassName(), o:cText( aTmp[ i ] ), ) } )

      setDlgMode( aTmp, aGet, nMode, oStkAct, oSayPr1, oSayPr2, oSayVp1, oSayVp2, oTotal, aTmpSat, oSayLote, , oFld )

      SysRefresh()

   else

      oDlg2:end( IDOK )

   end if

RETURN NIL

//--------------------------------------------------------------------------//

Static Function saveDetail( aTmp, aClo, aGet, aTmpSat, dbfTmpLin, oBrw, nMode )

   local hAtipica
   local sOfertaArticulo
   local nCajasGratis         := 0
   local nUnidadesGratis      := 0

   // Atipicas ----------------------------------------------------------------

   hAtipica                   := hAtipica( hValue( aTmp, aTmpSat ) )
   if !empty( hAtipica ) 
      if hhaskey( hAtipica, "nCajasGratis" ) .and. hget( hAtipica, "nCajasGratis" ) != 0
         nCajasGratis         := hget( hAtipica, "nCajasGratis" ) 
      end if 
      if hhaskey( hAtipica, "nUnidadesGratis" ) .and. hget( hAtipica, "nUnidadesGratis" ) != 0
         nUnidadesGratis      := hget( hAtipica, "nUnidadesGratis" ) 
      end if
   end if

   // Ofertas------------------------------------------------------------------

   if empty( nCajasGratis ) .and. empty( nUnidadesGratis )
      sOfertaArticulo         := structOfertaArticulo( D():getHashArray( aTmpSat, "SatCliT", nView ), D():getHashArray( aTmp, "SatCliL", nView ), nTotLSatCli( aTmp ), nView )
      if !empty( sOfertaArticulo ) 
         nCajasGratis         := sOfertaArticulo:nCajasGratis
         nUnidadesGratis      := sOfertaArticulo:nUnidadesGratis
      end if
   end if 

   // Cajas gratis ---------------------------------------------------------

   if nCajasGratis != 0
      aTmp[ _LLINOFE ]        := .t.
      aTmp[ _NCANSAT ]        -= nCajasGratis
      commitDetail( aTmp, aClo, nil, aTmpSat, dbfTmpLin, oBrw, nMode )

      aTmp[ _LLINOFE ]        := .t.
      aTmp[ _NCANSAT ]        := nCajasGratis
      aTmp[ _NPREDIV ]        := 0
      aTmp[ _NDTO    ]        := 0
      aTmp[ _NDTODIV ]        := 0
      aTmp[ _NDTOPRM ]        := 0
      aTmp[ _NCOMAGE ]        := 0
   end if 

   // unidades gratis ---------------------------------------------------------

   if nUnidadesGratis != 0
      aTmp[ _LLINOFE ]        := .t.
      aTmp[ _NUNICAJA]        -= nUnidadesGratis 

      commitDetail( aTmp, aClo, nil, aTmpSat, dbfTmpLin, oBrw, nMode )

      aTmp[ _LLINOFE ]        := .t.
      aTmp[ _NUNICAJA]        := nUnidadesGratis 
      aTmp[ _NPREDIV ]        := 0
      aTmp[ _NDTO    ]        := 0
      aTmp[ _NDTODIV ]        := 0
      aTmp[ _NDTOPRM ]        := 0
      aTmp[ _NCOMAGE ]        := 0
   end if 

   commitDetail( aTmp, aClo, aGet, aTmpSat, dbfTmpLin, oBrw, nMode )

Return nil

//--------------------------------------------------------------------------//

Static Function commitDetail( aTmp, aClo, aGet, aTmpSat, dbfTmpLin, oBrw, nMode )

   winGather( aTmp, aGet, dbfTmpLin, oBrw, nMode, nil, .f. )

   if ( nMode == APPD_MODE ) .and. ( aClo[ _LKITART ] )
      appendKit( aClo, aTmpSat )
   end if

Return nil

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

   if nMode == APPD_MODE
      aTmp[ ( dbfTmpInc )->( FieldPos( "lAviso" ) ) ]  := .t.
   end if

   DEFINE DIALOG oDlg RESOURCE "INCIDENCIA" TITLE LblTitle( nMode ) + "incidencias de S.A.T. a clientes"

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
   local cFmtDoc     := cFormatoDocumento( ( D():SatClientes( nView ) )->cSerSat, "nSatCli", D():Documentos( nView ) )
   local oSayFmt
   local cSayFmt
   local oSerIni
   local oSerFin   
   local cSerIni     := ( D():SatClientes( nView ) )->cSerSat
   local cSerFin     := ( D():SatClientes( nView ) )->cSerSat
   local nDocIni     := ( D():SatClientes( nView ) )->nNumSat
   local nDocFin     := ( D():SatClientes( nView ) )->nNumSat
   local cSufIni     := ( D():SatClientes( nView ) )->cSufSat
   local cSufFin     := ( D():SatClientes( nView ) )->cSufSat
   local oPrinter
   local cPrinter    := PrnGetName()
   local lCopiasSat  := .t.
   local lInvOrden   := .f.
   local oNumCop
   local nNumCop     := if( nCopiasDocumento( ( D():SatClientes( nView ) )->cSerSat, "nSatCli", D():Documentos( nView ) ) == 0, Max( Retfld( ( D():SatClientes( nView ) )->cCodCli, D():Clientes( nView ), "CopiasF" ), 1 ), nCopiasDocumento( ( D():SatClientes( nView ) )->cSerSat, "nSatCli", D():Documentos( nView ) ) )
   local oRango
   local nRango      := 1
   local dFecDesde   := CtoD( "01/01/" + Str( Year( Date() ) ) )
   local dFecHasta   := Date()

   if Empty( cFmtDoc )
      cFmtDoc           := cSelPrimerDoc( "SC" )
   end if

   cSayFmt           := cNombreDoc( cFmtDoc )

   DEFINE DIALOG oDlg RESOURCE "IMPSERIES" TITLE "Imprimir series de S.A.T."

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

   TBtnBmp():ReDefine( 92, "gc_document_text_pencil_12",,,,,{|| EdtDocumento( cFmtDoc ) }, oDlg, .f., , .f.,  )

   REDEFINE GET oPrinter VAR cPrinter;
      WHEN     ( .f. ) ;
      ID       160 ;
      OF       oDlg

   TBtnBmp():ReDefine( 161, "gc_printer2_check_16",,,,,{|| PrinterPreferences( oPrinter ) }, oDlg, .f., , .f.,  )

   REDEFINE BUTTON ;
      ID       IDOK ;
      OF       oDlg ;
      ACTION   (  StartPrint( SubStr( cFmtDoc, 1, 3 ), cSerIni + Str( nDocIni, 9 ) + cSufIni, cSerFin + Str( nDocFin, 9 ) + cSufFin, oDlg, nil, lCopiasSat, nNumCop, lInvOrden, nRango, dFecDesde, dFecHasta ),;
                  oDlg:end( IDOK ) )

   REDEFINE BUTTON ;
      ID       IDCANCEL ;
      OF       oDlg ;
      CANCEL ;
      ACTION   ( oDlg:end() )

   oDlg:AddFastKey( VK_F5, {|| StartPrint( SubStr( cFmtDoc, 1, 3 ), cSerIni + Str( nDocIni, 9 ) + cSufIni, cSerFin + Str( nDocFin, 9 ) + cSufFin, oDlg, nil, lCopiasSat, nNumCop, lInvOrden, nRango, dFecDesde, dFecHasta ), oDlg:end( IDOK ) } )

   oDlg:bStart := { || oSerIni:SetFocus() }

   ACTIVATE DIALOG oDlg CENTER
   
   oWndBrw:oBrw:refresh()

RETURN NIL

//--------------------------------------------------------------------------//

STATIC FUNCTION StartPrint( cFmtDoc, cDocIni, cDocFin, oDlg, cPrinter, lCopiasSat, nNumCop, lInvOrden, nRango, dFecDesde, dFecHasta )

   local nCopyClient
   local nRecno
   local nOrdAnt

   oDlg:disable()

   if nRango == 1

      nRecno      := ( D():SatClientes( nView ) )->( recno() )
      nOrdAnt     := ( D():SatClientes( nView ) )->( OrdSetFocus( "nNumSat" ) )

      if ! lInvOrden

         if ( D():SatClientes( nView ) )->( dbSeek( cDocIni, .t. ) )

            while ( D():SatClientes( nView ) )->cSerSat + Str( ( D():SatClientes( nView ) )->nNumSat ) + ( D():SatClientes( nView ) )->cSufSat >= cDocIni   .and. ;
                  ( D():SatClientes( nView ) )->cSerSat + Str( ( D():SatClientes( nView ) )->nNumSat ) + ( D():SatClientes( nView ) )->cSufSat <= cDocFin   .and. ;
                  !( D():SatClientes( nView ) )->( Eof() )

                  lChgImpDoc( D():SatClientes( nView ) )

               if lCopiasSat

                  nCopyClient := if( nCopiasDocumento( ( D():SatClientes( nView ) )->cSerSat, "nSatCli", D():Documentos( nView ) ) == 0, Max( Retfld( ( D():SatClientes( nView ) )->cCodCli, D():Clientes( nView ), "CopiasF" ), 1 ), nCopiasDocumento( ( D():SatClientes( nView ) )->cSerSat, "nSatCli", D():Documentos( nView ) ) )

                  GenSatCli( IS_PRINTER, "Imprimiendo documento : " + ( D():SatClientes( nView ) )->cSerSat + Str( ( D():SatClientes( nView ) )->nNumSat ) + ( D():SatClientes( nView ) )->cSufSat, cFmtDoc, cPrinter, nCopyClient )

               else

                  GenSatCli( IS_PRINTER, "Imprimiendo documento : " + ( D():SatClientes( nView ) )->cSerSat + Str( ( D():SatClientes( nView ) )->nNumSat ) + ( D():SatClientes( nView ) )->cSufSat, cFmtDoc, cPrinter, nNumCop )

               end if

               ( D():SatClientes( nView ) )->( dbSkip() )

            end do

         end if

      else

         if ( D():SatClientes( nView ) )->( dbSeek( cDocFin ) )

            while ( D():SatClientes( nView ) )->cSerSat + Str( ( D():SatClientes( nView ) )->nNumSat ) + ( D():SatClientes( nView ) )->cSufSat >= cDocIni   .and.;
                  ( D():SatClientes( nView ) )->cSerSat + Str( ( D():SatClientes( nView ) )->nNumSat ) + ( D():SatClientes( nView ) )->cSufSat <= cDocFin   .and.;
                  !( D():SatClientes( nView ) )->( Bof() )

                  lChgImpDoc( D():SatClientes( nView ) )

               if lCopiasSat

                  nCopyClient := if( nCopiasDocumento( ( D():SatClientes( nView ) )->cSerSat, "nSatCli", D():Documentos( nView ) ) == 0, Max( Retfld( ( D():SatClientes( nView ) )->cCodCli, D():Clientes( nView ), "CopiasF" ), 1 ), nCopiasDocumento( ( D():SatClientes( nView ) )->cSerSat, "nSatCli", D():Documentos( nView ) ) )

                  GenSatCli( IS_PRINTER, "Imprimiendo documento : " + ( D():SatClientes( nView ) )->cSerSat + Str( ( D():SatClientes( nView ) )->nNumSat ) + ( D():SatClientes( nView ) )->cSufSat, cFmtDoc, cPrinter, nCopyClient )

               else

                  GenSatCli( IS_PRINTER, "Imprimiendo documento : " + ( D():SatClientes( nView ) )->cSerSat + Str( ( D():SatClientes( nView ) )->nNumSat ) + ( D():SatClientes( nView ) )->cSufSat, cFmtDoc, cPrinter, nNumCop )

               end if

               ( D():SatClientes( nView ) )->( dbSkip( -1 ) )

            end while

         end if

      end if

   else
   
      nRecno      := ( D():SatClientes( nView ) )->( recno() )
      nOrdAnt     := ( D():SatClientes( nView ) )->( OrdSetFocus( "dFecSat" ) )

      if ! lInvOrden

         ( D():SatClientes( nView ) )->( dbGoTop() )

         while !( D():SatClientes( nView ) )->( Eof() )

            if ( D():SatClientes( nView ) )->dFecSat >= dFecDesde .and. ( D():SatClientes( nView ) )->dFecSat <= dFecHasta

               lChgImpDoc( D():SatClientes( nView ) )

               if lCopiasSat

                  nCopyClient := if( nCopiasDocumento( ( D():SatClientes( nView ) )->cSerSat, "nSatCli", D():Documentos( nView ) ) == 0, Max( Retfld( ( D():SatClientes( nView ) )->cCodCli, D():Clientes( nView ), "CopiasF" ), 1 ), nCopiasDocumento( ( D():SatClientes( nView ) )->cSerSat, "nSatCli", D():Documentos( nView ) ) )

                  GenSatCli( IS_PRINTER, "Imprimiendo documento : " + ( D():SatClientes( nView ) )->cSerSat + Str( ( D():SatClientes( nView ) )->nNumSat ) + ( D():SatClientes( nView ) )->cSufSat, cFmtDoc, cPrinter, nCopyClient )

               else

                  GenSatCli( IS_PRINTER, "Imprimiendo documento : " + ( D():SatClientes( nView ) )->cSerSat + Str( ( D():SatClientes( nView ) )->nNumSat ) + ( D():SatClientes( nView ) )->cSufSat, cFmtDoc, cPrinter, nNumCop )

               end if

            end if   

            ( D():SatClientes( nView ) )->( dbSkip() )

         end while

      else

         ( D():SatClientes( nView ) )->( dbGobottom() )

         while !( D():SatClientes( nView ) )->( Bof() )

            if ( D():SatClientes( nView ) )->dFecSat >= dFecDesde .and. ( D():SatClientes( nView ) )->dFecSat <= dFecHasta

               lChgImpDoc( D():SatClientes( nView ) )

               if lCopiasSat

                  nCopyClient := if( nCopiasDocumento( ( D():SatClientes( nView ) )->cSerSat, "nSatCli", D():Documentos( nView ) ) == 0, Max( Retfld( ( D():SatClientes( nView ) )->cCodCli, D():Clientes( nView ), "CopiasF" ), 1 ), nCopiasDocumento( ( D():SatClientes( nView ) )->cSerSat, "nSatCli", D():Documentos( nView ) ) )

                  GenSatCli( IS_PRINTER, "Imprimiendo documento : " + ( D():SatClientes( nView ) )->cSerSat + Str( ( D():SatClientes( nView ) )->nNumSat ) + ( D():SatClientes( nView ) )->cSufSat, cFmtDoc, cPrinter, nCopyClient )

               else

                  GenSatCli( IS_PRINTER, "Imprimiendo documento : " + ( D():SatClientes( nView ) )->cSerSat + Str( ( D():SatClientes( nView ) )->nNumSat ) + ( D():SatClientes( nView ) )->cSufSat, cFmtDoc, cPrinter, nNumCop )

               end if

            end if   

            ( D():SatClientes( nView ) )->( dbSkip( -1 ) )

         end while

      end if

   end if   

   ( D():SatClientes( nView ) )->( dbGoTo( nRecNo ) )
   ( D():SatClientes( nView ) )->( ordSetFocus( nOrdAnt ) )

   oDlg:enable()

RETURN NIL

//--------------------------------------------------------------------------//

STATIC FUNCTION RecalculaTotal( aTmp )

   nTotSatCli( nil, D():SatClientes( nView ), dbfTmpLin, dbfIva, dbfDiv, dbfFPago, aTmp )

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

STATIC FUNCTION LoaArt( aTmp, aGet, aTmpSat, oStkAct, oSayPr1, oSayPr2, oSayVp1, oSayVp2, bmpImage, oSayLote, nMode, lFocused )

   local nDtoAge
   local nImpAtp
   local nImporteTarifa
   local nCosPro
   local cCodFam
   local cCodArt              := aGet[ _CREF ]:VarGet()
   local cPrpArt
   local nPrePro              := 0
   local nPosComa
   local cProveedor
   local nTarOld              := aTmp[ _NTARLIN ]
   local lChgCodArt           := ( empty( cOldCodArt ) .or. rtrim( cOldCodArt ) != rtrim( cCodArt ) )
   local nDescuentoArticulo   := 0
   local hValue
   local hAtipica
   local sOfertaArticulo

   DEFAULT lFocused  := .t.

   if empty( cCodArt )

      if lRetCodArt()
         MsgStop( "No se pueden añadir lineas sin codificar" )
         return .f.
      end if

      if empty( aTmp[ _NIVA ] )
         aGet[ _NIVA ]:bWhen     := {|| .t. }
      end if

      aGet[ _CDETALLE ]:Hide()

      if !empty( aGet[ _MLNGDES ] )
          aGet[ _MLNGDES ]:Show()
      end if

      if !empty( oBrwProperties )
         oBrwProperties:Hide()
      end if

      if lFocused .and. !empty( aGet[ _MLNGDES ] )
        aGet[ _MLNGDES ]:SetFocus()
      end if

   else

      aGet[ _NIVA     ]:bWhen   := {|| lModIva() }
      aGet[ _CDETALLE ]:show()

      if aGet[ _MLNGDES ] != nil
         aGet[ _MLNGDES ]:hide()
      end if

      /*
      Primero buscamos por codigos de barra
      */

      if "," $ cCodArt
         nPosComa                := At( ",", cCodArt )
         cProveedor              := RJust( Left( cCodArt, nPosComa - 1 ), "0", RetNumCodPrvEmp() )
         cCodArt                 := cSeekProveedor( cCodArt, dbfArtPrv )
      else
         cCodArt                 := cSeekCodebar( cCodArt, dbfCodebar, D():Articulos( nView ) )
      end if

      /*
      Ahora buscamos por el codigo interno
      */

      if ( D():Articulos( nView ) )->( dbSeek( cCodArt ) ) .or. ( D():Articulos( nView ) )->( dbSeek( Upper( cCodArt ) ) )

         if ( D():Articulos( nView ) )->lObs
            MsgStop( "Artículo catalogado como obsoleto" )
            return .f.
         end if

         if ( lChgCodArt )

            cCodArt              := ( D():Articulos( nView ) )->Codigo
            aTmp[ _CREF ]        := cCodArt
            aGet[ _CREF ]:cText( cCodArt )

            //Pasamos las referencias adicionales------------------------------

            aTmp[ _CREFAUX ]     := ( D():Articulos( nView ) )->cRefAux
            aTmp[ _CREFAUX2 ]    := ( D():Articulos( nView ) )->cRefAux2

            if ( D():Articulos( nView ) )->lMosCom .and. !Empty( ( D():Articulos( nView ) )->mComent )
               MsgStop( Trim( ( D():Articulos( nView ) )->mComent ) )
            end if

            /*
            Metemos el proveedor habitual--------------------------------------
            */

            if !Empty( aGet[ _CCODPRV ] )
               aGet[ _CCODPRV ]:cText( ( D():Articulos( nView ) )->cPrvHab )
               aGet[ _CCODPRV ]:lValid()
            else
               aTmp[ _CCODPRV ]  := ( D():Articulos( nView ) )->cPrvHab   
            end if

            aTmp[ _CREFPRV ]  := Padr( cRefPrvArt( cCodArt, ( D():Articulos( nView ) )->cPrvHab , dbfArtPrv ), 18 )

            /*
            Lotes--------------------------------------------------------------
            */

            if ( D():Articulos( nView ) )->lLote

               if oSayLote != nil
                  oSayLote:Show()
               end if

               if aGet[ _CLOTE ] != nil
                  aGet[ _CLOTE ]:show()
               end if

               if aGet[ _CLOTE ] != nil
                  aGet[ _CLOTE ]:cText( ( D():Articulos( nView ) )->cLote )
               else
                  aTmp[ _CLOTE ] := ( D():Articulos( nView ) )->cLote
               end if

               aTmp[ _LLOTE ]    := ( D():Articulos( nView ) )->lLote

            else

               if oSayLote != nil
                  oSayLote:hide()
               end if

               if aGet[ _CLOTE ] != nil
                  aGet[ _CLOTE ]:hide()
               end if

            end if

            aTmp[ _LLOTE   ]     := ( D():Articulos( nView ) )->lLote

            /*
            Coger el tipo de venta------------------------------------------------
            */

            aTmp[ _LMSGVTA ]     := ( D():Articulos( nView ) )->lMsgVta
            aTmp[ _LNOTVTA ]     := ( D():Articulos( nView ) )->lNotVta

            cCodFam              := ( D():Articulos( nView ) )->Familia

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

            else

               if aGet[ _CCODFAM ] != nil
                  aGet[ _CCODFAM ]:cText( Space( 8 ) )
                  aGet[ _CCODFAM ]:lValid()
               end if

               if aGet[ _CGRPFAM ] != nil
                  aGet[ _CGRPFAM ]:cText( Space( 3 ) )
                  aGet[ _CGRPFAM ]:lValid()
               end if

            end if

            /*
            Descripciones largas--------------------------------------------------
            */

            if !Empty( aGet[ _DESCRIP ] )
               aGet[ _DESCRIP ]:cText( ( D():Articulos( nView ) )->Descrip )
            else
               aTmp[ _DESCRIP ]     := ( D():Articulos( nView ) )->Descrip
            end if

            /*
            Ubicación----------------------------------------------------------
            */

            if !Empty( aGet[ _CDESUBI ] )
               aGet[ _CDESUBI ]:cText( ( D():Articulos( nView ) )->cDesUbi )
            else
               aTmp[ _CDESUBI ]     := ( D():Articulos( nView ) )->cDesUbi
            end if

            /*
            Unidades e impuestos--------------------------------------------------------
            */

            if ( D():Articulos( nView ) )->nCajEnt != 0
               if  aGet[ _NCANSAT ] != nil
                   aGet[ _NCANSAT ]:cText( ( D():Articulos( nView ) )->nCajEnt )
               else
                   aTmp[ _NCANSAT ] := ( D():Articulos( nView ) )->nCajEnt

               end if
            end if

            if ( D():Articulos( nView ) )->nUniCaja != 0
               if aGet[ _NUNICAJA ] != nil
                  aGet[ _NUNICAJA ]:cText( ( D():Articulos( nView ) )->nUniCaja )
               else
                  aTmp[ _NUNICAJA ] := ( D():Articulos( nView ) )->nUniCaja
               end if
            end if

            /*
            Satguntamos si el regimen de " + cImp() + " es distinto de Exento
            */

            if aTmpSat[ _NREGIVA ] <= 2

               if aGet[ _NIVA ] != nil
                  aGet[ _NIVA ]:cText( nIva( dbfIva, ( D():Articulos( nView ) )->TipoIva ) )
               else
                  aTmp[ _NIVA ] := nIva( dbfIva, ( D():Articulos( nView ) )->TipoIva )
               end if

               aTmp[ _NREQ ]     := nReq( dbfIva, ( D():Articulos( nView ) )->TipoIva )

            end if

            if aGet[ _CDETALLE ] != nil
               aGet[ _CDETALLE ]:cText( ( D():Articulos( nView ) )->Nombre )
            else
               aTmp[ _CDETALLE ] := ( D():Articulos( nView ) )->Nombre
            end if

            if aGet[ _MLNGDES ] != nil
               aGet[ _MLNGDES ]:cText( ( D():Articulos( nView ) )->Descrip )
            else
               aTmp[ _MLNGDES ]  := ( D():Articulos( nView ) )->Descrip
            end if

            /*
            Tratamientos kits-----------------------------------------------------
            */

            if ( D():Articulos( nView ) )->lKitArt

               aTmp[ _LKITART ]        := .t.                                             // Marcamos como padre del kit
               aTmp[ _LIMPLIN ]        := lImprimirCompuesto( ( D():Articulos( nView ) )->Codigo, D():Articulos( nView ) ) // 1 Todos, 2 Compuesto
               aTmp[ _LKITPRC ]        := lPreciosCompuestos( ( D():Articulos( nView ) )->Codigo, D():Articulos( nView ) ) // 1 Todos, 2 Compuesto

               if lStockCompuestos( ( D():Articulos( nView ) )->Codigo, D():Articulos( nView ) )
                  if aGet[ _NCTLSTK ] != nil
                     aGet[ _NCTLSTK ]:SetOption( ( D():Articulos( nView ) )->nCtlStock )
                  else
                     aTmp[ _NCTLSTK ]  := ( D():Articulos( nView ) )->nCtlStock
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
                  aGet[ _NCTLSTK ]:SetOption( ( D():Articulos( nView ) )->nCtlStock )
               else
                  aTmp[ _NCTLSTK ]     := ( D():Articulos( nView ) )->nCtlStock
               end if

            end if

            if aTmp[ _NCTLSTK ] == 2

               if !Empty( aGet[ _NCNTACT ] )
                  aGet[ _NCNTACT ]:cText( ( D():Articulos( nView ) )->nCntAct )
                  aGet[ _NCNTACT ]:Show()
               else
                  aTmp[ _NCNTACT ]     := ( D():Articulos( nView ) )->nCntAct
               end if

            else

               if !Empty( aGet[ _NCNTACT ] )
                  aGet[ _NCNTACT ]:Hide()
               end if

            end if

            /*
            Impuestos especiales--------------------------------------------------
            */

            aTmp[ _CCODIMP ]     := ( D():Articulos( nView ) )->cCodImp
            oNewImp:setCodeAndValue( aTmp[ _CCODIMP ], aGet[ _NVALIMP ] )

            if !Empty( ( D():Articulos( nView ) )->cCodImp )
               aTmp[ _LVOLIMP ]     := RetFld( ( D():Articulos( nView ) )->cCodImp, oNewImp:oDbf:cAlias, "lIvaVol" )
            end if

            /*
            Buscamos la familia del articulo y anotamos las propiedades-----------
            */

            aTmp[ _CCODPR1 ]        := ( D():Articulos( nView ) )->cCodPrp1
            aTmp[ _CCODPR2 ]        := ( D():Articulos( nView ) )->cCodPrp2

            if ( !Empty( aTmp[ _CCODPR1 ] ) .or. !Empty( aTmp[ _CCODPR2 ] ) ) .and. ( uFieldEmpresa( "lUseTbl" ) .and. ( nMode == APPD_MODE ) )

               aGet[ _NCANSAT  ]:cText( 0 )
               aGet[ _NUNICAJA ]:cText( 0 )

               setPropertiesTable( cCodArt, aTmp[ _CCODPR1 ], aTmp[ _CCODPR2 ], 0, aGet[ _NUNICAJA ], oBrwProperties, nView )

            else

               hidePropertiesTable( oBrwProperties )

               if !Empty( aTmp[ _CCODPR1 ] )

                  if aGet[ _CVALPR1 ] != nil
                     aGet[ _CVALPR1 ]:Show()
                     if lFocused
                        aGet[ _CVALPR1 ]:SetFocus()
                     end if
                  end if

                  if oSayPr1 != nil
                     oSayPr1:SetText( retProp( ( D():Articulos( nView ) )->cCodPrp1, dbfPro ) )
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
                     oSayPr2:SetText( retProp( ( D():Articulos( nView ) )->cCodPrp2, dbfPro ) )
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

            end if 

            // Si la comisi¢n del articulo hacia el agente es distinto de cero----

            loadComisionAgente( aTmp, aGet, aTmpSat )

            /*
            Peso y volumen
            -------------------------------------------------------------------
            */

            if !Empty( aGet[ _NPESOKG ] )
               aGet[ _NPESOKG  ]:cText( ( D():Articulos( nView ) )->nPesoKg )
            else
               aGet[ _NPESOKG  ] := ( D():Articulos( nView ) )->nPesoKg
            end if

            if !Empty( aGet[ _CPESOKG ] )
                aGet[ _CPESOKG ]:cText( ( D():Articulos( nView ) )->cUndDim )
            else
                aGet[ _CPESOKG ] := ( D():Articulos( nView ) )->cUndDim
            end if

            if !Empty( aGet[ _NVOLUMEN ] )
               aGet[ _NVOLUMEN ]:cText( ( D():Articulos( nView ) )->nVolumen )
            else
               aGet[ _NVOLUMEN ] := ( D():Articulos( nView ) )->nVolumen
            end if

            if !Empty( aGet[ _CUNIDAD ] )
                aGet[ _CUNIDAD ]:cText( ( D():Articulos( nView ) )->cUnidad )
                aGet[ _CUNIDAD ]:lValid()
            else
                aTmp[ _CUNIDAD ] := ( D():Articulos( nView ) )->cUnidad
            end if

            if !Empty( aGet[ _CVOLUMEN ] )
                aGet[ _CVOLUMEN ]:cText( ( D():Articulos( nView ) )->cVolumen )
            else
                aTmp[ _CVOLUMEN ]:= ( D():Articulos( nView ) )->cVolumen
            end if

            /*
            Buscamos si el articulo tiene factor de conversion--------------------
            */

            if ( D():Articulos( nView ) )->lFacCnv
               aTmp[ _NFACCNV ]     := ( D():Articulos( nView ) )->nFacCnv
            end if

            /*
            Tomamos el valor del stock y anotamos si nos dejan vender sin stock
            */

            if oStkAct != nil .and. aTmp[ _NCTLSTK ] <= 1
               oStock:nPutStockActual( cCodArt, aTmp[ _CALMLIN ], , , , aTmp[ _LKITART ], aTmp[ _NCTLSTK ], oStkAct )
            end if

            /*
            Imagen del producto---------------------------------------------------
            */

            if !Empty( aGet[ _CIMAGEN ] )
               aGet[ _CIMAGEN ]:cText( ( D():Articulos( nView ) )->cImagen )
            else
               aTmp[ _CIMAGEN ]     := ( D():Articulos( nView ) )->cImagen
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
               aGet[ _CCODTIP ]:cText( ( D():Articulos( nView ) )->cCodTip )
            else
               aTmp[ _CCODTIP ]  := ( D():Articulos( nView ) )->cCodTip
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
               cCodFam        := RetFamArt( cCodArt, D():Articulos( nView ) )
            else
               cCodFam        := aTmp[ _CCODFAM ]
            end if

            // Inicializamos el descuento y el logico de oferta

            if !Empty( aGet[ _NDTO ] )
               aGet[ _NDTO ]:cText( 0 )
            else
               aTmp[ _NDTO ] := 0
            end if

            if !Empty( aGet[ _NDTODIV ] )
               aGet[ _NDTODIV ]:cText( 0 )
            else 
               aTmp[ _NDTODIV ] := 0
            end if 

            if !Empty( aGet[ _NDTOPRM ] )
               aGet[ _NDTOPRM ]:cText( 0 )
            else 
               aTmp[ _NDTOPRM ]:= 0
            end if

            aTmp[ _LLINOFE  ] := .f.

            /*
            Cargamos el precio recomendado y el precio de costo
            */

            if aGet[ _NPNTVER ] != nil
               aGet[ _NPNTVER ]:cText( ( D():Articulos( nView ) )->nPntVer1 )
            else
               aTmp[ _NPNTVER ]  := ( D():Articulos( nView ) )->nPntVer1
            end if

            aTmp[ _NPVSATC ]     := ( D():Articulos( nView ) )->PvpRec

            /*
            Cargamos los costos
            */

            if !uFieldEmpresa( "lCosAct" )
               nCosPro           := oStock:nCostoMedio( aTmp[ _CREF ], aTmp[ _CALMLIN ], aTmp[ _CCODPR1 ], aTmp[ _CVALPR1 ], aTmp[ _CCODPR2 ], aTmp[ _CVALPR2 ], aTmp[ _CLOTE ] )
               if nCosPro == 0
                  nCosPro        := nCosto( aTmp[ _CREF ], D():Articulos( nView ), dbfKit, .f., , dbfDiv )
               end if
            else
               nCosPro           := nCosto( aTmp[ _CREF ], D():Articulos( nView ), dbfKit, .f., , dbfDiv )
            end if

            if aGet[ _NCOSDIV ] != nil
               aGet[ _NCOSDIV ]:cText( nCosPro )
            else
               aTmp[ _NCOSDIV ]  := nCosPro
            end if

            /*
            Descuento de artículo----------------------------------------------
            */

            nDescuentoArticulo   := nDescuentoArticulo( cCodArt, aTmpSat[ _CCODCLI ], nView )
            if nDescuentoArticulo != 0
               if !Empty( aGet[ _NDTO ] )
                  aGet[ _NDTO ]:cText( nDescuentoArticulo )
               else
                  aTmp[ _NDTO ]  := nDescuentoArticulo
               end if
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
               aGet[ _CUNIDAD ]:cText( ( D():Articulos( nView ) )->cUnidad )
            else
               aTmp[ _CUNIDAD ]  := ( D():Articulos( nView ) )->cUnidad
            end if

            /*
            Obtenemos el precio del artículo
            */

            if !aTmp[ __LALQUILER ]

               nPrePro        := nPrePro( aTmp[ _CREF ], aTmp[ _CCODPR1 ], aTmp[ _CVALPR1 ], aTmp[ _CCODPR2 ], aTmp[ _CVALPR2 ], aTmp[ _NTARLIN ], aTmpSat[ _LIVAINC ], dbfArtDiv, dbfTarPreL, aTmpSat[_CCODTAR] )

               if nPrePro == 0
                  aGet[ _NPREDIV ]:cText( nRetPreArt( aTmp[ _NTARLIN ], aTmpSat[ _CDIVSAT ], aTmpSat[_LIVAINC], D():Articulos( nView ), dbfDiv, dbfKit, dbfIva, , , oNewImp ) )
               else
                  aGet[ _NPREDIV ]:cText( nPrePro )
               end if

            else

               aGet[ _NPREDIV ]:cText( 0 )
               aGet[ _NPREALQ ]:cText( nPreAlq( aTmp[ _CREF ], aTmp[ _NTARLIN ], aTmpSat[_LIVAINC], D():Articulos( nView ) ) )

            end if

            /*
            Usando Tarifas-----------------------------------------------------
            */

            if !Empty( aTmpSat[ _CCODTAR ] )

               /*
               Cojemos el descuento fijo y el precio del Articulo
               */

               nImporteTarifa     := RetPrcTar( cCodArt, aTmpSat[_CCODTAR], aTmp[_CCODPR1], aTmp[_CCODPR2], aTmp[_CVALPR1], aTmp[_CVALPR2], dbfTarPreL, aTmp[ _NTARLIN ] )
               if nImporteTarifa  != 0
                  aGet[ _NPREDIV ]:cText( nImporteTarifa )
               end if

               nImporteTarifa     := RetPctTar( cCodArt, cCodFam, aTmpSat[_CCODTAR], aTmp[_CCODPR1], aTmp[_CCODPR2], aTmp[_CVALPR1], aTmp[_CVALPR2], dbfTarPreL )
               if nImporteTarifa  != 0
                  aGet[ _NDTO ]:cText( nImporteTarifa )
               end if

               nImporteTarifa     := RetLinTar( cCodArt, cCodFam, aTmpSat[_CCODTAR], aTmp[_CCODPR1], aTmp[_CCODPR2], aTmp[_CVALPR1], aTmp[_CVALPR2], dbfTarPreL )
               if nImporteTarifa  != 0
                  aGet[ _NDTODIV ]:cText( nImporteTarifa )
               end if

               nImporteTarifa     := RetComTar( cCodArt, cCodFam, aTmpSat[_CCODTAR], aTmp[_CCODPR1], aTmp[_CCODPR2], aTmp[_CVALPR1], aTmp[_CVALPR2], aTmpSat[_CCODAGE], dbfTarPreL, dbfTarPreS )
               if nImporteTarifa  != 0
                  aGet[ _NCOMAGE ]:cText( nImporteTarifa )
               end if

               /*Descuento de promoci¢n*/

               nImporteTarifa     := RetDtoPrm( cCodArt, cCodFam, aTmpSat[_CCODTAR], aTmp[_CCODPR1], aTmp[_CCODPR2], aTmp[_CVALPR1], aTmp[_CVALPR2], aTmpSat[_DFECSAT], dbfTarPreL )
               if nImporteTarifa  != 0
                  aGet[ _NDTOPRM ]:cText( nImporteTarifa )
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
            Chequeamos las atipicas del cliente--------------------------------
            */

            hValue   := hValue( aTmp, aTmpSAT )
            hAtipica := hAtipica( hValue )

            if !Empty( hAtipica )
               
               if hhaskey( hAtipica, "nImporte" ) .and. hAtipica[ "nImporte" ] != 0
                  aGet[ _NPREDIV ]:cText( hAtipica[ "nImporte" ] )
               end if

               if hhaskey( hAtipica, "nDescuentoPorcentual" ) .and. hAtipica[ "nDescuentoPorcentual"] != 0
                  aGet[ _NDTO ]:cText( hAtipica[ "nDescuentoPorcentual"] )   
               end if

               if hhaskey( hAtipica, "nDescuentoPromocional" ) .and. hAtipica[ "nDescuentoPromocional" ] != 0
                  aGet[ _NDTOPRM ]:cText( hAtipica[ "nDescuentoPromocional" ] )
               end if

               if hhaskey( hAtipica, "nComisionAgente" ) .and. hAtipica[ "nComisionAgente" ] != 0
                  aGet[ _NCOMAGE ]:cText( hAtipica[ "nComisionAgente" ] )
               end if

               if hhaskey( hAtipica, "nDescuentoLineal" ) .and. hAtipica[ "nDescuentoLineal" ] != 0
                  aGet[ _NDTODIV ]:cText( hAtipica[ "nDescuentoLineal" ] )
               end if

            end if

            // Buscamos si hay ofertas-----------------------------------------------

            sOfertaArticulo   := structOfertaArticulo( D():getHashArray( aTmpSat, "SatCliT", nView ), D():getHashArray( aTmp, "SatCliL", nView ), nTotLSatCli( aTmp ), nView )

            if !empty( sOfertaArticulo ) 
               
               if ( sOfertaArticulo:nPrecio != 0 )
                  aGet[ _NPREDIV ]:cText( sOfertaArticulo:nPrecio )
               end if 
               
               if ( sOfertaArticulo:nDtoPorcentual != 0 )
                  aGet[ _NDTO ]:cText( sOfertaArticulo:nDtoPorcentual )
               end if 
               
               if ( sOfertaArticulo:nDtoLineal != 0 )
                  aGet[ _NDTODIV ]:cText( sOfertaArticulo:nDtoLineal )
               end if 
               
               aTmp[ _LLINOFE ] := .t.

            end if

            // Unidades de medicion -------------------------------------------

            if oUndMedicion:oDbf:Seek( ( D():Articulos( nView ) )->cUnidad )

               if oUndMedicion:oDbf:nDimension >= 1 .and. !Empty( oUndMedicion:oDbf:cTextoDim1 )
                  aGet[ ( D():SatClientesLineas( nView ) )->( fieldpos( "nMedUno" ) ) ]:oSay:SetText( oUndMedicion:oDbf:cTextoDim1 )
                  aGet[ ( D():SatClientesLineas( nView ) )->( fieldpos( "nMedUno" ) ) ]:cText( ( D():Articulos( nView ) )->nLngArt )
                  aGet[ ( D():SatClientesLineas( nView ) )->( fieldpos( "nMedUno" ) ) ]:Show()
               else
                  aGet[ ( D():SatClientesLineas( nView ) )->( fieldpos( "nMedUno" ) ) ]:cText( 0 )
                  aGet[ ( D():SatClientesLineas( nView ) )->( fieldpos( "nMedUno" ) ) ]:Hide()
               end if

               if oUndMedicion:oDbf:nDimension >= 2 .and. !Empty( oUndMedicion:oDbf:cTextoDim2 )
                  aGet[ ( D():SatClientesLineas( nView ) )->( fieldpos( "nMedDos" ) ) ]:oSay:SetText( oUndMedicion:oDbf:cTextoDim2 )
                  aGet[ ( D():SatClientesLineas( nView ) )->( fieldpos( "nMedDos" ) ) ]:cText( ( D():Articulos( nView ) )->nAltArt )
                  aGet[ ( D():SatClientesLineas( nView ) )->( fieldpos( "nMedDos" ) ) ]:Show()
               else
                  aGet[ ( D():SatClientesLineas( nView ) )->( fieldpos( "nMedDos" ) ) ]:cText( 0 )
                  aGet[ ( D():SatClientesLineas( nView ) )->( fieldpos( "nMedDos" ) ) ]:Hide()
               end if

               if oUndMedicion:oDbf:nDimension >= 3 .and. !Empty( oUndMedicion:oDbf:cTextoDim3 )
                  aGet[ ( D():SatClientesLineas( nView ) )->( fieldpos( "nMedTre" ) ) ]:oSay:SetText( oUndMedicion:oDbf:cTextoDim3 )
                  aGet[ ( D():SatClientesLineas( nView ) )->( fieldpos( "nMedTre" ) ) ]:cText( ( D():Articulos( nView ) )->nAncArt )
                  aGet[ ( D():SatClientesLineas( nView ) )->( fieldpos( "nMedTre" ) ) ]:Show()
               else
                  aGet[ ( D():SatClientesLineas( nView ) )->( fieldpos( "nMedTre" ) ) ]:cText( 0 )
                  aGet[ ( D():SatClientesLineas( nView ) )->( fieldpos( "nMedTre" ) ) ]:Hide()
               end if

            else

               aGet[ ( D():SatClientesLineas( nView ) )->( fieldpos( "nMedUno" ) ) ]:cText( 0 )
               aGet[ ( D():SatClientesLineas( nView ) )->( fieldpos( "nMedUno" ) ) ]:Hide()

               aGet[ ( D():SatClientesLineas( nView ) )->( fieldpos( "nMedDos" ) ) ]:cText( 0 )
               aGet[ ( D():SatClientesLineas( nView ) )->( fieldpos( "nMedDos" ) ) ]:Hide()

               aGet[ ( D():SatClientesLineas( nView ) )->( fieldpos( "nMedTre" ) ) ]:cText( 0 )
               aGet[ ( D():SatClientesLineas( nView ) )->( fieldpos( "nMedTre" ) ) ]:Hide()

            end if

         end if

         /*
         Cargamos los valores para los cambios---------------------------------
         */

         cOldPrpArt := cPrpArt
         cOldCodArt := cCodArt

         /*
         Solo pueden modificar los precios los administradores-----------------
         */

         if Empty( aTmp[ _NPREDIV ] ) .or. ( SQLAjustableModel():getRolCambiarPrecios( Auth():rolUuid() ) )
            
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

STATIC FUNCTION BeginTrans( aTmp, nMode )

   local lErrors  := .f.
   local cDbfLin  := "PCliL"
   local cDbfInc  := "PCliI"
   local cDbfDoc  := "PCliD"
   local cDbfSer  := "SCliS"
   local cSat     := aTmp[ _CSERSAT ] + Str( aTmp[ _NNUMSAT ] ) + aTmp[ _CSUFSAT ]
   local oError
   local oBlock   

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

   if !NetErr()
      ( dbfTmpInc )->( OrdCondSet( "!Deleted()", {||!Deleted()} ) )
      ( dbfTmpInc )->( OrdCreate( cTmpInc, "Recno", "Str( Recno() )", {|| Str( Recno() ) } ) )
   else
      lErrors     := .t.
   end if

   dbCreate( cTmpDoc, aSqlStruct( aSatCliDoc() ), cLocalDriver() )
   dbUseArea( .t., cLocalDriver(), cTmpDoc, cCheckArea( cDbfDoc, @dbfTmpDoc ), .f. )

   if !NetErr()
      ( dbfTmpDoc )->( OrdCondSet( "!Deleted()", {||!Deleted()} ) )
      ( dbfTmpDoc )->( OrdCreate( cTmpDoc, "Recno", "Str( Recno() )", {|| Str( Recno() ) } ) )
   else
      lErrors     := .t.
   end if
   
   dbCreate( cTmpLin, aSqlStruct( aColSatCli() ), cLocalDriver() )
   dbUseArea( .t., cLocalDriver(), cTmpLin, cCheckArea( cDbfLin, @dbfTmpLin ), .f. )

   if !NetErr()

      ( dbfTmpLin )->( OrdCondSet( "!Deleted()", {||!Deleted() } ) )
      ( dbfTmpLin )->( OrdCreate( cTmpLin, "nNumLin", "Str( nNumLin, 4 )", {|| Str( Field->nNumLin ) } ) )

      ( dbfTmpLin )->( OrdCondSet( "!Deleted()", {||!Deleted()} ) )
      ( dbfTmpLin )->( OrdCreate( cTmpLin, "Recno", "Str( Recno() )", {|| Str( Recno() ) } ) )

      ( dbfTmpLin )->( OrdCondSet( "!Deleted()", {||!Deleted() } ) )
      ( dbfTmpLin )->( OrdCreate( cTmpLin, "nPosPrint", "Str( nPosPrint, 4 )", {|| Str( Field->nPosPrint ) } ) )

   else
      lErrors     := .t.
   end if

   /*
   A¤adimos desde el fichero de lineas
   */

   if ( D():SatClientesLineas( nView ) )->( dbSeek( cSat ) )

      while ( D():SatClientesLineasId( nView ) == cSat .AND. !( D():SatClientesLineas( nView ) )->( eof() ) )

         dbPass( D():SatClientesLineas( nView ), dbfTmpLin, .t. )
         ( D():SatClientesLineas( nView ) )->( dbSkip() )

      end while

   end if

   ( dbfTmpLin )->( dbGoTop() )

   /*
   A¤adimos desde el fichero de incidencias
   */

   if ( nMode != DUPL_MODE ) .and. ( dbfSatCliI )->( dbSeek( cSat ) )

      do while ( ( dbfSatCliI )->cSerSat + Str( ( dbfSatCliI )->NNUMSAT ) + ( dbfSatCliI )->CSUFSAT == cSat .AND. !( dbfSatCliI )->( eof() ) )

         dbPass( dbfSatCliI, dbfTmpInc, .t. )
         ( dbfSatCliI )->( DbSkip() )

      end while

   end if

   ( dbfTmpInc )->( dbGoTop() )

   /*
   A¤adimos desde el fichero de documentos
   */

   if ( nMode != DUPL_MODE ) .and. ( dbfSatCliD )->( dbSeek( cSat ) )

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

      if ( nMode != DUPL_MODE ) .and. ( dbfSatCliS )->( dbSeek( cSat ) )

         while ( ( dbfSatCliS )->cSerSat + Str( ( dbfSatCliS )->nNumSat ) + ( dbfSatCliS )->cSufSat == cSat ) .and. !( dbfSatCliS )->( eof() )
      
            dbPass( dbfSatCliS, dbfTmpSer, .t. )
      
            ( dbfSatCliS )->( dbSkip() )
      
         end while
      
      end if

      ( dbfTmpSer )->( dbGoTop() )

   else
      lErrors     := .t.
   end if

   oDetCamposExtra:SetTemporal( aTmp[ _CSERSAT ] + Str( aTmp[ _NNUMSAT ] ) + aTmp[ _CSUFSAT ], "", nMode ) 

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
   local cCodCli
   local cCodEst
   local nOrdAnt
   local lResultBeforeEndEvent := .t.

   if Empty( aTmp[ _CSERSAT ] )
      aTmp[ _CSERSAT ]  := "A"
   end if

   cSerSat              := aTmp[ _CSERSAT ]
   nNumSat              := aTmp[ _NNUMSAT ]
   cSufSat              := aTmp[ _CSUFSAT ]
   cCodCli              := aTmp[ _CCODCLI ]
   dFecSat              := aTmp[ _DFECSAT ]
   cCodEst              := aTmp[ _CCODEST ]

   /*
   Comprobamos la fecha del documento
   */

   if !lValidaOperacion( aTmp[ _DFECSAT ] )
      Return .f.
   end if

   if !lValidaSerie( aTmp[ _CSERSAT ] )
      return .f.
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

   lResultBeforeEndEvent   := runEventScript( "SatClientes\beforeEndTrans", aGet, aTmp, nView, dbfTmpLin, nMode )

   if IsLogic( lResultBeforeEndEvent ) .and. !lResultBeforeEndEvent
      Return .f.
   end if

   oDlg:Disable()

   oMsgText( "Archivando" )

   oBlock      := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   // Anotamos los cambios de estado en las inicidencias--------------------------

   if ( cOldSituacion != aTmp[ _CSITUAC ] )
      ( dbfTmpInc )->( dbAppend() )
      ( dbfTmpInc )->dFecInc     := GetSysDate()
      ( dbfTmpInc )->mDesInc     := "Cambio de estado de " + AllTrim( cOldSituacion ) + " a " + Alltrim( aTmp[ _CSITUAC ] ) + "."
   end if 

   // Quitamos los filtros--------------------------------------------------------

   ( dbfTmpLin )->( dbClearFilter() )

   // Primero hacer el RollBack---------------------------------------------------

   aTmp[ _DFECCRE ]        := Date()
   aTmp[ _CTIMCRE ]        := Time()
   aTmp[ _NTARIFA ]        := oGetTarifa:getTarifa()

   if isAppendOrDuplicateMode( nMode )
      nNumSat              := nNewDoc( cSerSat, D():SatClientes( nView ), "nSatCli", , D():Contadores( nView ) )
      aTmp[ _NNUMSAT ]     := nNumSat
      cSufSat              := retSufEmp()
      aTmp[ _CSUFSAT ]     := cSufSat
   end if 

   // Comenzamos la transaccion------------------------------------------------

   begintransaction()

   // Eliminamos los registros de tablas anteriores----------------------------

   if isEditMode( nMode )

      while ( D():SatClientesLineas( nView ) )->( dbSeek( cSerSat + str( nNumSat ) + cSufSat ) ) 
         if dbLock( D():SatClientesLineas( nView ) )
            ( D():SatClientesLineas( nView ) )->( dbDelete() )
            ( D():SatClientesLineas( nView ) )->( dbUnLock() )
         end if
         ( D():SatClientesLineas( nView ) )->( dbSkip() )
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

      ( dbfTmpLin )->dFecSat     := dFecSat
      ( dbfTmpLin )->dFecha      := dFecSat
      ( dbfTmpLin )->cCodCli     := cCodCli
      ( dbfTmpLin )->nRegIva     := aTmp[ _NREGIVA ]

      if isEditMode( nMode ) .and. ( dbfTmpLin )->nCtlstk == 2

         if ( D():Articulos( nView ) )->( dbSeek( ( dbfTmpLin )->cRef ) )

            if dbLock( D():Articulos( nView ) )
               ( D():Articulos( nView ) )->cCodEst    := aTmp[ _CCODEST ]
               ( D():Articulos( nView ) )->( dbUnLock() )
            end if

         end if

      end if

      dbPass( dbfTmpLin, D():SatClientesLineas( nView ), .t., cSerSat, nNumSat, cSufSat )
      
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

   /*
   Guardamos los campos extra-----------------------------------------------
   */

   oDetCamposExtra:saveExtraField( aTmp[ _CSERSAT ] + Str( aTmp[ _NNUMSAT ] ) + aTmp[ _CSUFSAT ], "" )

   WinGather( aTmp, , D():SatClientes( nView ), , nMode )

   /*
   Pasamos, si estamos modificando, el estado a los artículos------------------
   */

   if nMode == EDIT_MODE

      nOrdAnt := ( D():SatClientes( nView ) )->( OrdSetFocus( "cNumDes" ) )

      ( D():SatClientes( nView ) )->( dbGoTop() )

      if ( D():SatClientes( nView ) )->cSerSat + Str( ( D():SatClientes( nView ) )->nNumSat ) + ( D():SatClientes( nView ) )->cSufSat == cSerSat + Str( nNumSat ) + cSufSat .and.;
         ( D():SatClientes( nView ) )->dFecSat  == dFecSat

         if ( D():SatClientesLineas( nView ) )->( dbSeek( cSerSat + Str( nNumSat ) + cSufSat ) )

            while ( D():SatClientesLineas( nView ) )->cSerSat + Str( ( D():SatClientesLineas( nView ) )->nNumSat ) + ( D():SatClientesLineas( nView ) )->cSufSat == cSerSat + Str( nNumSat ) + cSufSat .and. !( D():SatClientesLineas( nView ) )->( Eof() )

               if ( D():Articulos( nView ) )->( dbSeek( ( D():SatClientesLineas( nView ) )->cRef ) )

                  if dbLock( D():Articulos( nView ) )
                     ( D():Articulos( nView ) )->cCodEst    := cCodEst
                     ( D():Articulos( nView ) )->( dbUnLock() )
                  end if

               end if

               ( D():SatClientesLineas( nView ) )->( dbSkip() )

            end while

         end if

      end if

      ( D():SatClientes( nView ) )->( OrdSetFocus( nOrdAnt ) )

   end if

   // Escribe los datos pendientes------------------------------------------------

   commitTransaction()

   oMsgText( "Finalizamos la transacción" )

   RECOVER USING oError

      rollBackTransaction()

      msgStop( "Imposible almacenar documento" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE
   ErrorBlock( oBlock )

   oMsgProgress()
   oMsgText()

   endProgress()

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

   if ( D():Clientes( nView ) )->( dbSeek( cNewCodCli ) )

      if !( isAviableClient( nView, nMode ) )
         return .f.
      end if

      if oTlfCli != nil
         oTlfCli:SetText( ( D():Clientes( nView ) )->Telefono )
      end if

      /*
      Asignamos el codigo siempre
      */

      aGet[ _CCODCLI ]:cText( ( D():Clientes( nView ) )->Cod )

      /*
      Color de fondo del cliente-----------------------------------------------
      */

      if ( D():Clientes( nView ) )->nColor != 0
         aGet[ _CNOMCLI ]:SetColor( , ( D():Clientes( nView ) )->nColor )
      end if

      if Empty( aGet[ _CNOMCLI ]:varGet() ) .or. lChgCodCli
         aGet[ _CNOMCLI ]:cText( ( D():Clientes( nView ) )->Titulo )
      end if

      if Empty( aGet[ _CTLFCLI ]:varGet() ) .or. lChgCodCli
         aGet[ _CTLFCLI ]:cText( ( D():Clientes( nView ) )->Telefono )
      end if

      if !Empty( aGet[ _CDIRCLI ] ) .and. ( Empty( aGet[ _CDIRCLI ]:varGet() ) .or. lChgCodCli )
         aGet[ _CDIRCLI ]:cText( ( D():Clientes( nView ) )->Domicilio )
      end if

      if !Empty( aGet[ _CPOBCLI ] ) .and. ( Empty( aGet[ _CPOBCLI ]:varGet() ) .or. lChgCodCli )
         aGet[ _CPOBCLI ]:cText( ( D():Clientes( nView ) )->Poblacion )
      end if

      if !Empty( aGet[ _CPRVCLI ] ) .and. ( Empty( aGet[ _CPRVCLI ]:varGet() ) .or. lChgCodCli )
         aGet[ _CPRVCLI ]:cText( ( D():Clientes( nView ) )->Provincia )
      end if

      if !Empty( aGet[ _CPOSCLI ] ) .and. ( Empty( aGet[ _CPOSCLI ]:varGet() ) .or. lChgCodCli )
         aGet[ _CPOSCLI ]:cText( ( D():Clientes( nView ) )->CodPostal )
      end if

      if !Empty( aGet[_CDNICLI] ) .and. ( Empty( aGet[ _CDNICLI ]:varGet() ) .or. lChgCodCli )
         aGet[ _CDNICLI ]:cText( ( D():Clientes( nView ) )->Nif )
      end if

      if ( Empty( aTmp[_CCODGRP] ) .or. lChgCodCli )
         aTmp[ _CCODGRP ]  := ( D():Clientes( nView ) )->cCodGrp
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

      if ( lChgCodCli )

         /*
         Calculo del reisgo del cliente-------------------------------------------
         */

         if oRieCli != nil
            oStock:SetRiesgo( cNewCodCli, oRieCli, ( D():Clientes( nView ) )->Riesgo )
         end if

         aTmp[ _LMODCLI ]  := ( D():Clientes( nView ) )->lModDat

      end if

      if ( lChgCodCli )
         aTmp[ _LOPERPV ]  := ( D():Clientes( nView ) )->lPntVer
      end if

      if nMode == APPD_MODE

         aTmp[ _NREGIVA ]   := ( D():Clientes( nView ) )->nRegIva

         lChangeRegIva( aTmp )

         /*
         Si estamos a¤adiendo cargamos todos los datos del cliente
         */

         if Empty( aTmp[ _CSERSAT ] )

            if !Empty( ( D():Clientes( nView ) )->Serie )
               aGet[ _CSERSAT ]:cText( ( D():Clientes( nView ) )->Serie )
            end if

         else

            if !Empty( ( D():Clientes( nView ) )->Serie ) .and. aTmp[ _CSERSAT ] != ( D():Clientes( nView ) )->Serie .and. ApoloMsgNoYes( "La serie del cliente seleccionado es distinta a la anterior.", "¿Desea cambiar la serie?" )
               aGet[ _CSERSAT ]:cText( ( D():Clientes( nView ) )->Serie )
            end if

         end if

         if !Empty( aGet[ _CCODALM ] )
            if ( Empty( aGet[ _CCODALM ]:varGet() ) .or. lChgCodCli ) .and. !Empty( ( D():Clientes( nView ) )->cCodAlm )
               aGet[ _CCODALM ]:cText( ( D():Clientes( nView ) )->cCodAlm )
               aGet[ _CCODALM ]:lValid()
            end if
         end if

         if aGet[ _CCODTAR ] != nil
            if !Empty( aGet[ _CCODTAR ] ) .and. ( Empty( aGet[ _CCODTAR ]:varGet() ) .or. lChgCodCli ) .and. !Empty( ( D():Clientes( nView ) )->cCodTar )
               aGet[ _CCODTAR ]:cText( ( D():Clientes( nView ) )->cCodTar )
               aGet[ _CCODTAR ]:lValid()
            end if
         end if

         if ( Empty( aGet[ _CCODPGO ]:varGet() ) .or. lChgCodCli ) .and. !Empty( ( D():Clientes( nView ) )->CodPago )
            aGet[ _CCODPGO ]:cText( (D():Clientes( nView ) )->CodPago )
            aGet[ _CCODPGO ]:lValid()
         end if

         if aGet[_CCODAGE] != nil
            if ( Empty( aGet[ _CCODAGE ]:varGet() ) .or. lChgCodCli ) .and. !Empty( ( D():Clientes( nView ) )->cAgente )
               aGet[ _CCODAGE ]:cText( ( D():Clientes( nView ) )->cAgente )
               aGet[ _CCODAGE ]:lValid()
            end if
         end if

         if ( Empty( aGet[ _CCODRUT ]:varGet() ) .or. lChgCodCli ) .and. !Empty( ( D():Clientes( nView ) )->cCodRut )
            aGet[ _CCODRUT ]:cText( ( D():Clientes( nView ) )->cCodRut )
            aGet[ _CCODRUT ]:lValid()
         end if

         if !empty( oGetTarifa )         
            if ( empty( oGetTarifa:varGet() ) .or. lChgCodCli ) .and. !empty( ( D():Clientes( nView ) )->nTarifa )
               oGetTarifa:setTarifa( ( D():Clientes( nView ) )->nTarifa )
            end if
         else
            aTmp[ _NTARIFA ]  := ( D():Clientes( nView ) )->nTarifa
         end if

         if !Empty( aGet[ _CCODTRN ] ) .and. ( Empty( aGet[ _CCODTRN ]:varGet() ) .or. lChgCodCli ) .and. !Empty( ( D():Clientes( nView ) )->cCodTrn )
            aGet[ _CCODTRN ]:cText( ( D():Clientes( nView ) )->cCodTrn )
            aGet[ _CCODTRN ]:lValid()
         end if

         if lChgCodCli

            aGet[ _LRECARGO ]:Click( ( D():Clientes( nView ) )->lReq ):Refresh()

            aGet[ _LOPERPV ]:Click( ( D():Clientes( nView ) )->lPntVer ):Refresh()

            if ( D():Clientes( nView ) )->lMosCom .and. !Empty( ( D():Clientes( nView ) )->mComent ) .and. lChgCodCli
               MsgStop( Trim( ( D():Clientes( nView ) )->mComent ) )
            end if

            /*
            Descuentos desde la ficha de cliente----------------------------------
            */

            aGet[ _CDTOESP ]:cText( ( D():Clientes( nView ) )->cDtoEsp )

            aGet[ _NDTOESP ]:cText( ( D():Clientes( nView ) )->nDtoEsp )

            aGet[ _CDPP    ]:cText( ( D():Clientes( nView ) )->cDpp )

            aGet[ _NDPP    ]:cText( ( D():Clientes( nView ) )->nDpp )

            aGet[ _CDTOUNO ]:cText( ( D():Clientes( nView ) )->cDtoUno )

            aGet[ _NDTOUNO ]:cText( ( D():Clientes( nView ) )->nDtoCnt )

            aGet[ _CDTODOS ]:cText( ( D():Clientes( nView ) )->cDtoDos )

            aGet[ _NDTODOS ]:cText( ( D():Clientes( nView ) )->nDtoRap )

            aTmp[ _NDTOATP ]  := ( D():Clientes( nView ) )->nDtoAtp

            aTmp[ _NSBRATP ]  := ( D():Clientes( nView ) )->nSbrAtp

            ShowIncidenciaCliente( ( D():Clientes( nView ) )->Cod, nView )

         end if

      end if

      cOldCodCli  := ( D():Clientes( nView ) )->Cod

      lValid      := .t.

   ELSE

      msgStop( "Cliente no encontrado", "Cadena buscada : " + cNewCodCli )
      lValid      := .t.

   END IF

RETURN lValid

//----------------------------------------------------------------------------//

STATIC FUNCTION CreateFiles( cPath )

   if !lExistTable( cPath + "SatCliT.Dbf", cLocalDriver() )
      dbCreate( cPath + "SatCliT.Dbf", aSqlStruct( aItmSatCli() ), cLocalDriver() )
   end if

   if !lExistTable( cPath + "SatCliL.Dbf", cLocalDriver() )
      dbCreate( cPath + "SatCliL.Dbf", aSqlStruct( aColSatCli() ),  cLocalDriver() )
   end if

   if !lExistTable( cPath + "SatCliI.Dbf", cLocalDriver() )
      dbCreate( cPath + "SatCliI.Dbf", aSqlStruct( aIncSatCli() ),  cLocalDriver() )
   end if

   if !lExistTable( cPath + "SatCliD.Dbf", cLocalDriver() )
      dbCreate( cPath + "SatCliD.Dbf", aSqlStruct( aSatCliDoc() ),  cLocalDriver() )
   end if

   if !lExistTable( cPath + "SatCliS.Dbf", cLocalDriver() )
      dbCreate( cPath + "SatCliS.Dbf", aSqlStruct( aSerSatCli() ),  cLocalDriver() )
   end if

RETURN NIL

//----------------------------------------------------------------------------//

STATIC FUNCTION ChgState( oBrw )

   local nRec

   for each nRec in ( oBrw:aSelected )

      ( D():SatClientes( nView ) )->( dbGoTo( nRec ) )

      if dbLock( D():SatClientes( nView ) )
         ( D():SatClientes( nView ) )->lEstado := !( D():SatClientes( nView ) )->lEstado
         ( D():SatClientes( nView ) )->( dbRUnlock() )
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

         DEFINE BTNSHELL RESOURCE "GC_DOCUMENT_WHITE_" OF oWndBrw ;
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

         oWndBrw:NewAt( "gc_document_white_", , , bAction, Rtrim( ( dbfDoc )->cDescrip ) , , , , , oBtn )

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
   local nCopyClient := Retfld( ( D():SatClientes( nView ) )->cCodCli, D():Clientes( nView ), "CopiasF" )

   DEFAULT nDevice   := IS_PRINTER
   DEFAULT nCopy     := Max( nCopyClient, nCopiasDocumento( ( D():SatClientes( nView ) )->cSerSat, "nSatCli", D():Contadores( nView ) ) )

   nCopy             := Max( nCopy, 1 )

   while nImpYet <= nCopy
      GenSatCli( nDevice, cTitle, cCodDoc, cPrinter )
      nImpYet++
   end while

   //Funcion para marcar el documento como imprimido
   lChgImpDoc( D():SatClientes( nView ) )

return nil

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

STATIC FUNCTION RecSatCli( aTmpSat )

   local nDtoAge
   local nImpAtp           := 0
   local nImporteTarifa    := 0
   local nRecno
   local cCodFam
   local hAtipica
   local sOfertaArticulo

   if !apoloMsgNoYes(      "¡Atención!,"                                      + CRLF + ;
                           "todos los precios se recalcularán en función de"  + CRLF + ;
                           "los valores en las bases de datos.",;
                           "¿Desea proceder?" )
      return nil
   end if

   nRecno                  := ( dbfTmpLin )->( RecNo() )

   ( dbfTmpLin )->( dbGotop() )

   ( D():Articulos( nView ) )->( ordSetFocus( "Codigo" ) )
   while !( dbfTmpLin )->( eof() )

      /*
      Ahora buscamos por el codigo interno
      */

      if ( D():Articulos( nView ) )->( dbSeek( ( dbfTmpLin )->cRef ) )

         if aTmpSat[ _NREGIVA ] <= 2
            ( dbfTmpLin )->nIva     := nIva( dbfIva, ( D():Articulos( nView ) )->TipoIva )
            ( dbfTmpLin )->nReq     := nReq( dbfIva, ( D():Articulos( nView ) )->TipoIva )
         end if

         /*
         Ahora recogemos el impuesto especial si lo hay
         */

         if !Empty( ( D():Articulos( nView ) )->cCodImp )
            ( dbfTmpLin )->cCodImp  := ( D():Articulos( nView ) )->cCodImp
            ( dbfTmpLin )->nValImp  := oNewImp:nValImp( ( D():Articulos( nView ) )->cCodImp, aTmpSat[ _LIVAINC ], ( dbfTmpLin )->nIva )
         end if

         /*
         Tomamos los precios de la base de datos de articulos---------------------
         */

         ( dbfTmpLin )->nPreDiv     := nRetPreArt( ( dbfTmpLin )->nTarLin, aTmpSat[ _CDIVSAT ], aTmpSat[ _LIVAINC ], D():Articulos( nView ), dbfDiv, dbfKit, dbfIva, , , oNewImp )

         /*
         Linea por contadores-----------------------------------------------------
         */

         ( dbfTmpLin )->nCtlStk     := ( D():Articulos( nView ) )->nCtlStock
         ( dbfTmpLin )->nCosDiv     := nCosto( nil, D():Articulos( nView ), dbfKit )

         /*
         Punto verde--------------------------------------------------------------
         */

         ( dbfTmpLin )->nPntVer     := ( D():Articulos( nView ) )->nPntVer1

         /*
         Chequeamos situaciones especiales y comprobamos las fechas
         */

         do case

         /*
         Precios en tarifas----------------------------------------------------
         */

         case !Empty( aTmpSat[ _CCODTAR ] )

            cCodFam  := ( dbfTmpLin )->cCodFam

            nImporteTarifa  := RetPrcTar( ( dbfTmpLin )->cRef, aTmpSat[ _CCODTAR ], ( dbfTmpLin )->cCodPr1, ( dbfTmpLin )->cCodPr2, ( dbfTmpLin )->cValPr1, ( dbfTmpLin )->cValPr2, dbfTarPreL, ( dbfTmpLin )->nTarLin )
            if nImporteTarifa != 0
               ( dbfTmpLin )->nPreDiv  := nImporteTarifa
            end if

            nImporteTarifa  := RetPctTar( ( dbfTmpLin )->cRef, cCodFam, aTmpSat[ _CCODTAR ], ( dbfTmpLin )->cCodPr1, ( dbfTmpLin )->cCodPr2, ( dbfTmpLin )->cValPr1, ( dbfTmpLin )->cValPr2, dbfTarPreL )
            if nImporteTarifa != 0
               ( dbfTmpLin )->nDto     := nImporteTarifa
            end if

            nImporteTarifa  := RetComTar( ( dbfTmpLin )->cRef, cCodFam, aTmpSat[ _CCODTAR ], ( dbfTmpLin )->cCodPr1, ( dbfTmpLin )->cCodPr2, ( dbfTmpLin )->cValPr1, ( dbfTmpLin )->cValPr2, aTmpSat[ _CCODAGE ], dbfTarPreL, dbfTarPreS )
            if nImporteTarifa != 0
               ( dbfTmpLin )->nComAge  := nImporteTarifa
            end if

            /*
            Descuento de promoci¢n, esta funci¢n comprueba si existe y si es asi devuelve el descunto de la promoci¢n.
            */

            nImporteTarifa  := RetDtoPrm( ( dbfTmpLin )->cRef, cCodFam, aTmpSat[ _CCODTAR ], ( dbfTmpLin )->cCodPr1, ( dbfTmpLin )->cCodPr2, ( dbfTmpLin )->cValPr1, ( dbfTmpLin )->cValPr2, aTmpSat[ _DFECSAT ], dbfTarPreL )
            if nImporteTarifa != 0
               ( dbfTmpLin )->nDtoPrm  := nImporteTarifa
            end if

            /*
            Obtenemos el descuento de Agente
            */

            nDtoAge  := RetDtoAge( ( dbfTmpLin )->cRef, cCodFam, aTmpSat[ _CCODTAR ], ( dbfTmpLin )->cCodPr1, ( dbfTmpLin )->cCodPr2, ( dbfTmpLin )->cValPr1, ( dbfTmpLin )->cValPr2, aTmpSat[ _DFECSAT ], aTmpSat[ _CCODAGE ], dbfTarPreL, dbfTarPreS )
            if nDtoAge != 0
               ( dbfTmpLin )->nComAge  := nDtoAge
            end if

         /*
         Precios en tarifas
         */

         case !Empty( aTmpSat[ _CCODTAR ] )

            cCodFam  := ( dbfTmpLin )->cCodFam

            nImporteTarifa  := RetPrcTar( ( dbfTmpLin )->cRef, aTmpSat[ _CCODTAR ], ( dbfTmpLin )->cCodPr1, ( dbfTmpLin )->cCodPr2, ( dbfTmpLin )->cValPr1, ( dbfTmpLin )->cValPr2, dbfTarPreL, ( dbfTmpLin )->nTarLin )
            if nImporteTarifa != 0
               ( dbfTmpLin )->nPreDiv  := nImporteTarifa
            end if

            nImporteTarifa  := RetPctTar( ( dbfTmpLin )->cRef, cCodFam, aTmpSat[ _CCODTAR ], ( dbfTmpLin )->cCodPr1, ( dbfTmpLin )->cCodPr2, ( dbfTmpLin )->cValPr1, ( dbfTmpLin )->cValPr2, dbfTarPreL )
            if nImporteTarifa != 0
               ( dbfTmpLin )->nDto     := nImporteTarifa
            end if

            nImporteTarifa  := RetComTar( ( dbfTmpLin )->cRef, cCodFam, aTmpSat[ _CCODTAR ], ( dbfTmpLin )->cCodPr1, ( dbfTmpLin )->cCodPr2, ( dbfTmpLin )->cValPr1, ( dbfTmpLin )->cValPr2, aTmpSat[ _CCODAGE ], dbfTarPreL, dbfTarPreS )
            if nImporteTarifa != 0
               ( dbfTmpLin )->nComAge  := nImporteTarifa
            end if

            /*
            Descuento de promoci¢n, esta funci¢n comprueba si existe y si es asi devuelve el descunto de la promoci¢n.
            */

            nImporteTarifa  := RetDtoPrm( ( dbfTmpLin )->cRef, cCodFam, aTmpSat[ _CCODTAR ], ( dbfTmpLin )->cCodPr1, ( dbfTmpLin )->cCodPr2, ( dbfTmpLin )->cValPr1, ( dbfTmpLin )->cValPr2, aTmpSat[ _DFECSAT ], dbfTarPreL )
            if nImporteTarifa != 0
               ( dbfTmpLin )->nDtoPrm  := nImporteTarifa
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
         Buscamos si existen atipicas de clientes------------------------------
         */

         hAtipica := hAtipica( hValue( dbfTmpLin, aTmpSat ) )

         if !Empty( hAtipica )
               
            if hhaskey( hAtipica, "nImporte" ) .and. hAtipica[ "nImporte" ] != 0
               ( dbfTmpLin )->nPreDiv := hAtipica[ "nImporte" ]
            end if

            if hhaskey( hAtipica, "nDescuentoPorcentual" ) .and. hAtipica[ "nDescuentoPorcentual" ] != 0
               ( dbfTmpLin )->nDto     := hAtipica[ "nDescuentoPorcentual" ]
            end if

            if hhaskey( hAtipica, "nDescuentoPromocional" ) .and. hAtipica[ "nDescuentoPromocional" ] != 0
               ( dbfTmpLin )->nDtoPrm  := hAtipica[ "nDescuentoPromocional" ]
            end if

            if hhaskey( hAtipica, "nDescuentoLineal" ) .and. hAtipica[ "nDescuentoLineal" ] != 0
               ( dbfTmpLin )->nDtoDiv  := hAtipica[ "nDescuentoLineal" ]
            end if

            if hhaskey( hAtipica, "nComisionAgente" ) .and. hAtipica[ "nComisionAgente" ] != 0
               ( dbfTmpLin )->nComAge  := hAtipica[ "nComisionAgente" ]
            end if

         end if

         // Buscamos si hay ofertas-----------------------------------------------

         sOfertaArticulo   := structOfertaArticulo( D():getHashArray( aTmpSat, "SatCliT", nView ), D():getHashTable( dbfTmpLin, "SatCliL", nView ), nTotLSatCli( dbfTmpLin ), nView )

         if !empty( sOfertaArticulo ) 
            
            if ( sOfertaArticulo:nPrecio != 0 )
               ( dbfTmpLin )->nPreDiv  := sOfertaArticulo:nPrecio 
            end if 
            
            if ( sOfertaArticulo:nDtoPorcentual != 0 )
               ( dbfTmpLin )->nDto     := sOfertaArticulo:nDtoPorcentual 
            end if 
            
            if ( sOfertaArticulo:nDtoLineal != 0 )
               ( dbfTmpLin )->nDtoDiv  := sOfertaArticulo:nDtoLineal 
            end if 
            
            ( dbfTmpLin )->lLinOfe     := sOfertaArticulo:isImporte()

         end if 

      end if

      ( dbfTmpLin )->( dbSkip() )

   end while

   ( dbfTmpLin )->( dbGoTo( nRecno ) )

return nil

//--------------------------------------------------------------------------//

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

Static Function SatCliNotas()

   local cObserv  := ""
   local aData    := {}

   aAdd( aData, "S.A.T. " + ( D():SatClientes( nView ) )->cSerSat + "/" + AllTrim( Str( ( D():SatClientes( nView ) )->nNumSat ) ) + "/" + Alltrim( ( D():SatClientes( nView ) )->cSufSat ) + " de " + Rtrim( ( D():SatClientes( nView ) )->cNomCli ) )
   aAdd( aData, SAT_CLI )
   aAdd( aData, ( D():SatClientes( nView ) )->cCodCli )
   aAdd( aData, ( D():SatClientes( nView ) )->cNomCli )
   aAdd( aData, ( D():SatClientes( nView ) )->cSerSat + Str( ( D():SatClientes( nView ) )->nNumSat ) + ( D():SatClientes( nView ) )->cSufSat )

   if !Empty( ( D():SatClientes( nView ) )->cRetPor )
      cObserv     += Rtrim( ( D():SatClientes( nView ) )->cRetPor ) + Space( 1 )
   end if

   if !Empty( ( D():SatClientes( nView ) )->cRetMat )
      cObserv     += Rtrim( ( D():SatClientes( nView ) )->cRetMat ) + Space( 1 )
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
   local cAlmLin
   local nIvaLin
   local lIvaLin
   local nComAge
   local nUniCaj
   local nDtoGrl
   local nDtoPrm
   local nDtoDiv
   local nNumLin
   local nPosPrint
   local nTarLin
   local nRecAct                       := ( dbfKit )->( Recno() )
   local nUnidades                     := 0
   local nStkActual                    := 0
   local nStockMinimo                  := 0

   if ValType( uTmpLin ) == "A"
      cCodArt                          := uTmpLin[ _CREF    ]
      cSerSat                          := uTmpLin[ _CSERSAT ]
      nNumSat                          := uTmpLin[ _NNUMSAT ]
      cSufSat                          := uTmpLin[ _CSUFSAT ]
      nCanSat                          := uTmpLin[ _NCANSAT ]
      dFecSat                          := uTmpLin[ _DFECHA  ]
      cAlmLin                          := uTmpLin[ _CALMLIN ]
      nIvaLin                          := uTmpLin[ _NIVA    ]
      lIvaLin                          := uTmpLin[ _LIVALIN ]
      nComAge                          := uTmpLin[ _NCOMAGE ]
      nUniCaj                          := uTmpLin[ _NUNICAJA]
      nDtoGrl                          := uTmpLin[ _NDTO    ]
      nDtoPrm                          := uTmpLin[ _NDTOPRM ]
      nDtoDiv                          := uTmpLin[ _NDTODIV ]
      nNumLin                          := uTmpLin[ _NNUMLIN ]
      nPosPrint                        := uTmpLin[ _NPOSPRINT ]
      nTarLin                          := uTmpLin[ _NTARLIN ]
   else
      cCodArt                          := ( uTmpLin )->cRef
      cSerSat                          := ( uTmpLin )->cSerSat
      nNumSat                          := ( uTmpLin )->nNumSat
      cSufSat                          := ( uTmpLin )->cSufSat
      nCanSat                          := ( uTmpLin )->nCanSat
      dFecSat                          := ( uTmpLin )->dFecha
      cAlmLin                          := ( uTmpLin )->cAlmLin
      nIvaLin                          := ( uTmpLin )->nIva
      lIvaLin                          := ( uTmpLin )->lIvaLin
      nComAge                          := ( uTmpLin )->nComAge
      nUniCaj                          := ( uTmpLin )->nUniCaja
      nDtoGrl                          := ( uTmpLin )->nDto
      nDtoPrm                          := ( uTmpLin )->nDtoPrm
      nDtoDiv                          := ( uTmpLin )->nDtoDiv
      nNumLin                          := ( uTmpLin )->nNumLin
      nPosPrint                        := ( uTmpLin )->nPosPrint
      nTarLin                          := ( uTmpLin )->nTarLin
   end if

   if ( dbfKit )->( dbSeek( cCodArt ) )

      while ( dbfKit )->cCodKit == cCodArt .and. !( dbfKit )->( eof() )

         if ( D():Articulos( nView ) )->( dbSeek( ( dbfKit )->cRefKit ) )

            ( dbfTmpLin )->( dbAppend() )

            if lKitAsociado( cCodArt, D():Articulos( nView ) )
               ( dbfTmpLin )->nNumLin     := nLastNum( dbfTmpLin )
               ( dbfTmpLin )->nPosPrint   := nLastNum( dbfTmpLin , "nPosPrint" )
               ( dbfTmpLin )->lKitChl     := .f.
            else
               ( dbfTmpLin )->nNumLin     := nNumLin
               ( dbfTmpLin )->nPosPrint   := nPosPrint
               ( dbfTmpLin )->lKitChl     := .t.
            end if

            ( dbfTmpLin )->cRef        := ( dbfkit      )->cRefKit
            ( dbfTmpLin )->cDetalle    := ( D():Articulos( nView ) )->Nombre
            ( dbfTmpLin )->nPntVer     := ( D():Articulos( nView ) )->nPntVer1
            ( dbfTmpLin )->cUnidad     := ( D():Articulos( nView ) )->cUnidad
            ( dbfTmpLin )->nPesokg     := ( D():Articulos( nView ) )->nPesoKg
            ( dbfTmpLin )->cPesokg     := ( D():Articulos( nView ) )->cUndDim
            ( dbfTmpLin )->nVolumen    := ( D():Articulos( nView ) )->nVolumen
            ( dbfTmpLin )->cVolumen    := ( D():Articulos( nView ) )->cVolumen

            ( dbfTmpLin )->cCodImp     := ( D():Articulos( nView ) )->cCodImp
            ( dbfTmpLin )->lLote       := ( D():Articulos( nView ) )->lLote
            ( dbfTmpLin )->nLote       := ( D():Articulos( nView ) )->nLote
            ( dbfTmpLin )->cLote       := ( D():Articulos( nView ) )->cLote

            ( dbfTmpLin )->nValImp     := oNewImp:nValImp( ( D():Articulos( nView ) )->cCodImp )
            ( dbfTmpLin )->nCosDiv     := nCosto( nil, D():Articulos( nView ), dbfKit )

            if ( D():Articulos( nView ) )->lFacCnv
               ( dbfTmpLin )->nFacCnv  := ( D():Articulos( nView ) )->nFacCnv
            end if

            ( dbfTmpLin )->cSerSat     := cSerSat
            ( dbfTmpLin )->nNumSat     := nNumSat
            ( dbfTmpLin )->cSufSat     := cSufSat
            ( dbfTmpLin )->nCanSat     := nCanSat
            ( dbfTmpLin )->dFecha      := dFecSat
            ( dbfTmpLin )->cAlmLin     := cAlmLin
            ( dbfTmpLin )->lIvaLin     := lIvaLin
            ( dbfTmpLin )->nComAge     := nComAge

            /*
            Propiedades de los kits-----------------------------------------
            */

            ( dbfTmpLin )->lImpLin     := lImprimirComponente( cCodArt, D():Articulos( nView ) )   // 1 Todos, 2 Compuesto, 3 Componentes
            ( dbfTmpLin )->lKitPrc     := lPreciosComponentes( cCodArt, D():Articulos( nView ) )

            /*
            Unidades y precios de los componentes------------------------------
            */

            ( dbfTmpLin )->nUniCaja    := nUniCaj * ( dbfKit )->nUndKit

            if ( dbfTmpLin )->lKitPrc
               ( dbfTmpLin )->nPreDiv  := nRetPreArt( nTarLin, aTmpSat[ _CDIVSAT ], aTmpSat[ _LIVAINC ], D():Articulos( nView ), dbfDiv, dbfKit, dbfIva, , , oNewImp )
            end if

            /*
            Estudio de los tipos de " + cImp() + " si el padre el cero todos cero------
            */

            if !Empty( nIvaLin )
               ( dbfTmpLin )->nIva     := nIva( dbfIva, ( D():Articulos( nView ) )->TipoIva )
               ( dbfTmpLin )->nReq     := nReq( dbfIva, ( D():Articulos( nView ) )->TipoIva )
            else
               ( dbfTmpLin )->nIva     := 0
               ( dbfTmpLin )->nReq     := 0
            end if

            if lStockComponentes( cCodArt, D():Articulos( nView ) )
               ( dbfTmpLin )->nCtlStk  := ( D():Articulos( nView ) )->nCtlStock
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

            if ( D():Articulos( nView ) )->lKitArt
               AppendKit( dbfTmpLin, aTmpSat )
            end if

            /*
            Avisaremos del stock bajo minimo--------------------------------------
            */
            
            nStockMinimo      := nStockMinimo( ( dbfKit )->cRefKit, cAlmLin, nView )

            if ( D():Articulos( nView ) )->lMsgVta .and. !uFieldEmpresa( "lNStkAct" ) .and. nStockMinimo > 0

               nStkActual     := oStock:nStockAlmacen( ( dbfKit )->cRefKit, cAlmLin )
               nUnidades      := nUniCaj * ( dbfKit )->nUndKit

               do case
                  case nStkActual - nUnidades < 0

                        MsgStop( "No hay stock suficiente para realizar la venta" + CRLF + ;
                                 "del componente " + AllTrim( ( dbfKit )->cRefKit ) + " - " + AllTrim( ( D():Articulos( nView ) )->Nombre ),;
                                 "¡Atención!" )

                  case nStkActual - nUnidades < nStockMinimo

                        MsgStop( "El stock del componente " + AllTrim( ( dbfKit )->cRefKit ) + " - " + AllTrim( ( D():Articulos( nView ) )->Nombre ) + CRLF + ;
                                 "está bajo minimo." + CRLF + ;
                                 "Unidades a vender : " + AllTrim( Trans( nUnidades, MasUnd() ) ) + CRLF + ;
                                 "Stock minimo : " + AllTrim( Trans( nStockMinimo, MasUnd() ) ) + CRLF + ;
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
   local nRecno      := ( D():SatClientes( nView ) )->( Recno() )
   local nOrdAnt     := ( D():SatClientes( nView ) )->( OrdSetFocus( 1 ) )
   local oDesde      := TDesdeHasta():Init( ( D():SatClientes( nView ) )->cSerSat, ( D():SatClientes( nView ) )->nNumSat, ( D():SatClientes( nView ) )->cSufSat, GetSysDate() )
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

   /*REDEFINE APOLOMETER oTxtDup VAR nTxtDup ;
      ID       160 ;
      NOPERCENTAGE ;
      TOTAL    ( D():SatClientes( nView ) )->( OrdKeyCount() ) ;
      OF       oDlg*/

      oDlg:AddFastKey( VK_F5, {|| DupStart( oDesde, oDlg, oBtnAceptar, oBtnCancel, oTxtDup, @lCancel, cFecDoc ) } )

   ACTIVATE DIALOG oDlg CENTER VALID ( lCancel )

   ( D():SatClientes( nView ) )->( dbGoTo( nRecNo ) )
   ( D():SatClientes( nView ) )->( ordSetFocus( nOrdAnt ) )

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

      nOrd              := ( D():SatClientes( nView ) )->( OrdSetFocus( "nNumSat" ) )

      ( D():SatClientes( nView ) )->( dbSeek( oDesde:cNumeroInicio(), .t. ) )

      while !lCancel .and. ( D():SatClientes( nView ) )->( !eof() )

         if ( D():SatClientes( nView ) )->cSerSat >= oDesde:cSerieInicio  .and.;
            ( D():SatClientes( nView ) )->cSerSat <= oDesde:cSerieFin     .and.;
            ( D():SatClientes( nView ) )->nNumSat >= oDesde:nNumeroInicio .and.;
            ( D():SatClientes( nView ) )->nNumSat <= oDesde:nNumeroFin    .and.;
            ( D():SatClientes( nView ) )->cSufSat >= oDesde:cSufijoInicio .and.;
            ( D():SatClientes( nView ) )->cSufSat <= oDesde:cSufijoFin

            ++nDuplicados

            oTxtDup:cText  := "Duplicando : " + ( D():SatClientes( nView ) )->cSerSat + "/" + Alltrim( Str( ( D():SatClientes( nView ) )->nNumSat ) ) + "/" + ( D():SatClientes( nView ) )->cSufSat

            DuplicateSAST( cFecDoc )

         end if

         ( D():SatClientes( nView ) )->( dbSkip() )

         ++nProcesed

         oTxtDup:Set( nProcesed )

      end do

      ( D():SatClientes( nView ) )->( OrdSetFocus( nOrd ) )

   else

      nOrd              := ( D():SatClientes( nView ) )->( OrdSetFocus( "dFecSat" ) )

      ( D():SatClientes( nView ) )->( dbSeek( oDesde:dFechaInicio, .t. ) )

      while !lCancel .and. ( D():SatClientes( nView ) )->( !eof() )

         if ( D():SatClientes( nView ) )->dFecSat >= oDesde:dFechaInicio  .and.;
            ( D():SatClientes( nView ) )->dFecSat <= oDesde:dFechaFin

            ++nDuplicados

            oTxtDup:cText  := "Duplicando : " + ( D():SatClientes( nView ) )->cSerSat + "/" + Alltrim( Str( ( D():SatClientes( nView ) )->nNumSat ) ) + "/" + ( D():SatClientes( nView ) )->cSufSat

            DuplicateSAST( cFecDoc )

         end if

         ( D():SatClientes( nView ) )->( dbSkip() )

         ++nProcesed

         oTxtDup:Set( nProcesed )

      end do

      ( D():SatClientes( nView ) )->( OrdSetFocus( nOrd ) )

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
      aTabla[ _CCODUSR     ]  := Auth():Codigo()
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

STATIC FUNCTION DuplicateSAST( cFecDoc )

   local nNewNumSat  := 0

   //Recogemos el nuevo numero de S.A.T.--------------------------------------

   nNewNumSat  := nNewDoc( ( D():SatClientes( nView ) )->cSerSat, D():SatClientes( nView ), "NSATCLI" )

   //Duplicamos las cabeceras--------------------------------------------------

   SatRecDup( D():SatClientes( nView ), ( D():SatClientes( nView ) )->cSerSat, nNewNumSat, ( D():SatClientes( nView ) )->cSufSat, .t., cFecDoc )

   //Duplicamos las lineas del documento---------------------------------------

   if ( D():SatClientesLineas( nView ) )->( dbSeek( ( D():SatClientes( nView ) )->cSerSat + Str( ( D():SatClientes( nView ) )->nNumSat ) + ( D():SatClientes( nView ) )->cSufSat ) )

      while D():SatClientesId( nView ) == D():SatClientesLineasId( nView ) .and. D():SatClientesLineasNotEof( nView )

         SatRecDup( D():SatClientesLineas( nView ), ( D():SatClientes( nView ) )->cSerSat, nNewNumSat, ( D():SatClientes( nView ) )->cSufSat, .f. )

         ( D():SatClientesLineas( nView ) )->( dbSkip() )

      end while

   end if

   //Duplicamos los documentos-------------------------------------------------

   if ( dbfSatCliD )->( dbSeek( ( D():SatClientes( nView ) )->cSerSat + Str( ( D():SatClientes( nView ) )->nNumSat ) + ( D():SatClientes( nView ) )->cSufSat ) )

      while ( D():SatClientes( nView ) )->cSerSat + Str( ( D():SatClientes( nView ) )->nNumSat ) + ( D():SatClientes( nView ) )->cSufSat == ( dbfSatCliD )->cSerSat + Str( ( dbfSatCliD )->nNumSat ) + ( dbfSatCliD )->cSufSat .and. ;
            !( dbfSatCliD )->( Eof() )

         SatRecDup( dbfSatCliD, ( D():SatClientes( nView ) )->cSerSat, nNewNumSat, ( D():SatClientes( nView ) )->cSufSat, .f. )

         ( dbfSatCliD )->( dbSkip() )

      end while

   end if

RETURN ( .t. )

//---------------------------------------------------------------------------//

STATIC FUNCTION SetDialog( aGet, oSayGetRnt, oGetRnt )

   aGet[ _CSUSAT   ]:Refresh()

   if !lAccArticulo() .or. SQLAjustableModel():getRolNoMostrarRentabilidad( Auth():rolUuid() )

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
         nPrePro  := nRetPreArt( aTmp[ _NTARLIN ], aTmpSat[ _CDIVSAT ], aTmpSat[ _LIVAINC ], D():Articulos( nView ), dbfDiv, dbfKit, dbfIva, , , oNewImp )
      end if

      if nPrePro != 0
         aGet[ _NPREDIV ]:cText( nPrePro )
      end if


   else

      aGet[ _NPREDIV ]:cText( 0 )

      nPrePro := nPreAlq( aTmp[ _CREF ], aTmp[ _NTARLIN ], aTmpSat[ _LIVAINC ], D():Articulos( nView ) )

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
            if !Empty( aGet[ ( D():SatClientesLineas( nView ) )->( fieldpos( "nMedUno" ) ) ] )
               aGet[ ( D():SatClientesLineas( nView ) )->( fieldpos( "nMedUno" ) ) ]:oSay:SetText( oUndMedicion:oDbf:cTextoDim1 )
               aGet[ ( D():SatClientesLineas( nView ) )->( fieldpos( "nMedUno" ) ) ]:cText( ( D():Articulos( nView ) )->nLngArt )
               aGet[ ( D():SatClientesLineas( nView ) )->( fieldpos( "nMedUno" ) ) ]:Show()
            else
               aTmp[ ( D():SatClientesLineas( nView ) )->( fieldpos( "nMedUno" ) ) ]  := ( D():Articulos( nView ) )->nLngArt
            end if
         else
            if !Empty( aGet[ ( D():SatClientesLineas( nView ) )->( fieldpos( "nMedUno" ) ) ] )
               aGet[ ( D():SatClientesLineas( nView ) )->( fieldpos( "nMedUno" ) ) ]:cText( 0 )
               aGet[ ( D():SatClientesLineas( nView ) )->( fieldpos( "nMedUno" ) ) ]:Hide()
            else
               aTmp[ ( D():SatClientesLineas( nView ) )->( fieldpos( "nMedUno" ) ) ]  := 0
            end if
         end if

         if oUndMedicion:oDbf:nDimension >= 2 .and. !Empty( oUndMedicion:oDbf:cTextoDim2 )
            if !Empty( aGet[ ( D():SatClientesLineas( nView ) )->( fieldpos( "nMedDos" ) ) ] )
               aGet[ ( D():SatClientesLineas( nView ) )->( fieldpos( "nMedDos" ) ) ]:oSay:SetText( oUndMedicion:oDbf:cTextoDim2 )
               aGet[ ( D():SatClientesLineas( nView ) )->( fieldpos( "nMedDos" ) ) ]:cText( ( D():Articulos( nView ) )->nAltArt )
               aGet[ ( D():SatClientesLineas( nView ) )->( fieldpos( "nMedDos" ) ) ]:Show()
            else
               aTmp[ ( D():SatClientesLineas( nView ) )->( fieldpos( "nMedDos" ) ) ]  := ( D():Articulos( nView ) )->nAltArt
            end if

         else
            if !Empty( aGet[ ( D():SatClientesLineas( nView ) )->( fieldpos( "nMedDos" ) ) ] )
               aGet[ ( D():SatClientesLineas( nView ) )->( fieldpos( "nMedDos" ) ) ]:cText( 0 )
               aGet[ ( D():SatClientesLineas( nView ) )->( fieldpos( "nMedDos" ) ) ]:Hide()
            else
               aTmp[ ( D():SatClientesLineas( nView ) )->( fieldpos( "nMedDos" ) ) ]  := 0
            end if
         end if

         if oUndMedicion:oDbf:nDimension >= 3 .and. !Empty( oUndMedicion:oDbf:cTextoDim3 )
            if !Empty( aGet[ ( D():SatClientesLineas( nView ) )->( fieldpos( "nMedTre" ) ) ] )
               aGet[ ( D():SatClientesLineas( nView ) )->( fieldpos( "nMedTre" ) ) ]:oSay:SetText( oUndMedicion:oDbf:cTextoDim3 )
               aGet[ ( D():SatClientesLineas( nView ) )->( fieldpos( "nMedTre" ) ) ]:cText( ( D():Articulos( nView ) ) ->nAncArt )
               aGet[ ( D():SatClientesLineas( nView ) )->( fieldpos( "nMedTre" ) ) ]:Show()
            else
               aTmp[ ( D():SatClientesLineas( nView ) )->( fieldpos( "nMedTre" ) ) ]  := ( D():Articulos( nView ) )->nAncArt
            end if
         else
            if !Empty( aGet[ ( D():SatClientesLineas( nView ) )->( fieldpos( "nMedTre" ) ) ] )
               aGet[ ( D():SatClientesLineas( nView ) )->( fieldpos( "nMedTre" ) ) ]:cText( 0 )
               aGet[ ( D():SatClientesLineas( nView ) )->( fieldpos( "nMedTre" ) ) ]:Hide()
            else
               aTmp[ ( D():SatClientesLineas( nView ) )->( fieldpos( "nMedTre" ) ) ]  := 0
            end if
         end if

      else

         if !Empty( aGet[ ( D():SatClientesLineas( nView ) )->( fieldpos( "nMedUno" ) ) ] )
            aGet[ ( D():SatClientesLineas( nView ) )->( fieldpos( "nMedUno" ) ) ]:Hide()
            aGet[ ( D():SatClientesLineas( nView ) )->( fieldpos( "nMedUno" ) ) ]:cText( 0 )
         end if

         if !Empty( aGet[ ( D():SatClientesLineas( nView ) )->( fieldpos( "nMedDos" ) ) ] )
            aGet[ ( D():SatClientesLineas( nView ) )->( fieldpos( "nMedDos" ) ) ]:Hide()
            aGet[ ( D():SatClientesLineas( nView ) )->( fieldpos( "nMedDos" ) ) ]:cText( 0 )
         end if

         if !Empty( aGet[ ( D():SatClientesLineas( nView ) )->( fieldpos( "nMedTre" ) ) ] )
            aGet[ ( D():SatClientesLineas( nView ) )->( fieldpos( "nMedTre" ) ) ]:Hide()
            aGet[ ( D():SatClientesLineas( nView ) )->( fieldpos( "nMedTre" ) ) ]:cText( 0 )
         end if

      end if

      cOldUndMed := cNewUndMed

   end if

Return .t.

//---------------------------------------------------------------------------//

Static Function loadComisionAgente( aTmp, aGet, aTmpSat )

   local nComisionAgenteTarifa   

   nComisionAgenteTarifa      := nComisionAgenteTarifa( aTmpSat[ _CCODAGE ], aTmp[ _NTARLIN ], nView ) 
   if nComisionAgenteTarifa == 0
      nComisionAgenteTarifa   := aTmpSat[ _NPCTCOMAGE ]
   end if 

   if !empty( aGet[ _NCOMAGE ] )
      aGet[ _NCOMAGE ]:cText( nComisionAgenteTarifa )
   else 
      aTmp[ _NCOMAGE ]        := nComisionAgenteTarifa
   end if

return .t.

//-----------------------------------------------------------------------------

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

#include "FastRepH.ch"

Static Function DataReport( oFr )

   /*
   Zona de datos------------------------------------------------------------
   */

   oFr:ClearDataSets()

   oFr:SetWorkArea(     "SAT", ( D():SatClientes( nView ) )->( Select() ), .f., { FR_RB_CURRENT, FR_RB_CURRENT, 0 } )
   oFr:SetFieldAliases( "SAT", cItemsToReport( aItmSatCli() ) )

   oFr:SetWorkArea(     "Lineas de SAT", ( D():SatClientesLineas( nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Lineas de SAT", cItemsToReport( aColSatCli() ) )

   oFr:SetWorkArea(     "Incidencias de SAT", ( dbfSatCliI )->( Select() ) )
   oFr:SetFieldAliases( "Incidencias de SAT", cItemsToReport( aIncSatCli() ) )

   oFr:SetWorkArea(     "Documentos de SAT", ( dbfSatCliD )->( Select() ) )
   oFr:SetFieldAliases( "Documentos de SAT", cItemsToReport( aSatCliDoc() ) )

   oFr:SetWorkArea(     "Series de lineas de SAT", ( dbfSatCliS )->( Select() ) )
   oFr:SetFieldAliases( "Series de lineas de SAT", cItemsToReport( aSerSatCli() ) )

   oFr:SetWorkArea(     "Empresa", ( dbfEmp )->( Select() ) )
   oFr:SetFieldAliases( "Empresa", cItemsToReport( aItmEmp() ) )

   oFr:SetWorkArea(     "Clientes", ( D():Clientes( nView ) )->( Select() ) )
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

   oFr:SetWorkArea(     "Artículos", ( D():Articulos( nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Artículos", cItemsToReport( aItmArt() ) )

   oFr:SetWorkArea(     "Ofertas", ( D():Ofertas( nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Ofertas", cItemsToReport( aItmOfe() ) )

   oFr:SetWorkArea(     "Unidades de medición",  oUndMedicion:Select() )
   oFr:SetFieldAliases( "Unidades de medición",  cObjectsToReport( oUndMedicion:oDbf ) )

   oFr:SetWorkArea(     "Usuarios", ( dbfUsr )->( Select() ) )
   oFr:SetFieldAliases( "Usuarios", cItemsToReport( aItmUsuario() ) )

   oFr:SetWorkArea(     "Impuestos especiales",  oNewImp:Select() )
   oFr:SetFieldAliases( "Impuestos especiales",  cObjectsToReport( oNewImp:oDbf ) )

   oFr:SetMasterDetail( "SAT", "Lineas de SAT",                   {|| ( D():SatClientes( nView ) )->cSerSat + Str( ( D():SatClientes( nView ) )->nNumSat ) + ( D():SatClientes( nView ) )->cSufSat } )
   oFr:SetMasterDetail( "SAT", "Series de lineas de SAT",         {|| ( D():SatClientes( nView ) )->cSerSat + Str( ( D():SatClientes( nView ) )->nNumSat ) + ( D():SatClientes( nView ) )->cSufSat } )
   oFr:SetMasterDetail( "SAT", "Incidencias de SAT",              {|| ( D():SatClientes( nView ) )->cSerSat + Str( ( D():SatClientes( nView ) )->nNumSat ) + ( D():SatClientes( nView ) )->cSufSat } )
   oFr:SetMasterDetail( "SAT", "Documentos de SAT",               {|| ( D():SatClientes( nView ) )->cSerSat + Str( ( D():SatClientes( nView ) )->nNumSat ) + ( D():SatClientes( nView ) )->cSufSat } )
   oFr:SetMasterDetail( "SAT", "Empresa",                         {|| cCodigoEmpresaEnUso() } )
   oFr:SetMasterDetail( "SAT", "Clientes",                        {|| ( D():SatClientes( nView ) )->cCodCli } )
   oFr:SetMasterDetail( "SAT", "Obras",                           {|| ( D():SatClientes( nView ) )->cCodCli + ( D():SatClientes( nView ) )->cCodObr } )
   oFr:SetMasterDetail( "SAT", "Almacen",                         {|| ( D():SatClientes( nView ) )->cCodAlm } )
   oFr:SetMasterDetail( "SAT", "Rutas",                           {|| ( D():SatClientes( nView ) )->cCodRut } )
   oFr:SetMasterDetail( "SAT", "Agentes",                         {|| ( D():SatClientes( nView ) )->cCodAge } )
   oFr:SetMasterDetail( "SAT", "Formas de pago",                  {|| ( D():SatClientes( nView ) )->cCodPgo } )
   oFr:SetMasterDetail( "SAT", "Transportistas",                  {|| ( D():SatClientes( nView ) )->cCodTrn } )
   oFr:SetMasterDetail( "SAT", "Usuarios",                        {|| ( D():SatClientes( nView ) )->cCodUsr } )

   oFr:SetMasterDetail( "Lineas de SAT", "Artículos",             {|| SynchronizeDetails() } )
   oFr:SetMasterDetail( "Lineas de SAT", "Ofertas",               {|| ( D():SatClientesLineas( nView ) )->cRef } )
   oFr:SetMasterDetail( "Lineas de SAT", "Unidades de medición",  {|| ( D():SatClientesLineas( nView ) )->cUnidad } )
   oFr:SetMasterDetail( "Lineas de SAT", "Impuestos especiales",  {|| ( D():SatClientesLineas( nView ) )->cCodImp } )

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
   oFr:SetResyncPair(   "Lineas de SAT", "Impuestos especiales" )

Return nil

//---------------------------------------------------------------------------//

Static Function SynchronizeDetails()

Return ( ( D():SatClientesLineas( nView ) )->cRef )

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

   oFr:AddVariable(     "SAT",             "Fecha del primer vencimiento",       "GetHbArrayVar('aDatVto',1)" )
   oFr:AddVariable(     "SAT",             "Fecha del segundo vencimiento",      "GetHbArrayVar('aDatVto',2)" )
   oFr:AddVariable(     "SAT",             "Fecha del tercer vencimiento",       "GetHbArrayVar('aDatVto',3)" )
   oFr:AddVariable(     "SAT",             "Fecha del cuarto vencimiento",       "GetHbArrayVar('aDatVto',4)" )
   oFr:AddVariable(     "SAT",             "Fecha del quinto vencimiento",       "GetHbArrayVar('aDatVto',5)" )
   oFr:AddVariable(     "SAT",             "Fecha del sexto vencimiento",        "GetHbArrayVar('aDatVto',6)" )
   oFr:AddVariable(     "SAT",             "Fecha del septimo vencimiento",      "GetHbArrayVar('aDatVto',7)" )
   oFr:AddVariable(     "SAT",             "Fecha del octavovencimiento",        "GetHbArrayVar('aDatVto',8)" )
   oFr:AddVariable(     "SAT",             "Fecha del noveno vencimiento",       "GetHbArrayVar('aDatVto',9)" )
   oFr:AddVariable(     "SAT",             "Fecha del decimo vencimiento",       "GetHbArrayVar('aDatVto',10)" )
   oFr:AddVariable(     "SAT",             "Fecha del undecimo vencimiento",     "GetHbArrayVar('aDatVto',11)" )
   oFr:AddVariable(     "SAT",             "Fecha del duodecimo vencimiento",    "GetHbArrayVar('aDatVto',12)" )

   oFr:AddVariable(     "SAT",             "Importe del primer vencimiento",     "GetHbArrayVar('aImpVto',1)" )
   oFr:AddVariable(     "SAT",             "Importe del segundo vencimiento",    "GetHbArrayVar('aImpVto',2)" )
   oFr:AddVariable(     "SAT",             "Importe del tercero vencimiento",    "GetHbArrayVar('aImpVto',3)" )
   oFr:AddVariable(     "SAT",             "Importe del cuarto vencimiento",     "GetHbArrayVar('aImpVto',4)" )
   oFr:AddVariable(     "SAT",             "Importe del quinto vencimiento",     "GetHbArrayVar('aImpVto',5)" )
   oFr:AddVariable(     "SAT",             "Importe del sexto vencimiento",      "GetHbArrayVar('aImpVto',6)" )
   oFr:AddVariable(     "SAT",             "Importe del septimo vencimiento",    "GetHbArrayVar('aImpVto',7)" )
   oFr:AddVariable(     "SAT",             "Importe del octavo vencimiento",     "GetHbArrayVar('aImpVto',8)" )
   oFr:AddVariable(     "SAT",             "Importe del noveno vencimiento",     "GetHbArrayVar('aImpVto',9)" )
   oFr:AddVariable(     "SAT",             "Importe del decimo vencimiento",     "GetHbArrayVar('aImpVto',10)" )
   oFr:AddVariable(     "SAT",             "Importe del undecimo vencimiento",   "GetHbArrayVar('aImpVto',11)" )
   oFr:AddVariable(     "SAT",             "Importe del duodecimo vencimiento",  "GetHbArrayVar('aImpVto',12)" )   

   oFr:AddVariable(     "Lineas de SAT",   "Detalle del artículo",                "CallHbFunc('cDesSatCli')"  )
   oFr:AddVariable(     "Lineas de SAT",   "Detalle del artículo otro lenguaje",  "CallHbFunc('cDesSatCliLeng')"  )
   oFr:AddVariable(     "Lineas de SAT",   "Total unidades artículo",             "CallHbFunc('nTotNSatCli')" )
   oFr:AddVariable(     "Lineas de SAT",   "Precio unitario del artículo",        "CallHbFunc('nTotUSatCli')" )
   oFr:AddVariable(     "Lineas de SAT",   "Total línea de SAT",                  "CallHbFunc('nTotLSatCli')" )
   oFr:AddVariable(     "Lineas de SAT",   "Total peso por línea",                "CallHbFunc('nPesLSatCli')" )
   oFr:AddVariable(     "Lineas de SAT",   "Total final línea del SAT",           "CallHbFunc('nTotFSatCli')" )

Return nil

//---------------------------------------------------------------------------//

Static Function SetDiasSAT( aTmp, aGet )

   aGet[ _DFECSAL ]:oSay:SetText( "Entrega " + Alltrim( Str( aTmp[ _DFECSAL ] - aTmp[ _DFECSAT ] ) ) + " dias" )

Return nil 

//---------------------------------------------------------------------------//

Static Function hValue( aTmp, aTmpSat )

   local hValue                        := {=>}

   do case 
      case ValType( aTmp ) == "A"

         hValue[ "cCodigoArticulo"   ] := aTmp[ _CREF ]
         hValue[ "cCodigoPropiedad1" ] := aTmp[ _CCODPR1 ]
         hValue[ "cCodigoPropiedad2" ] := aTmp[ _CCODPR2 ]
         hValue[ "cValorPropiedad1"  ] := aTmp[ _CVALPR1 ]
         hValue[ "cValorPropiedad2"  ] := aTmp[ _CVALPR2 ]
         hValue[ "cCodigoFamilia"    ] := aTmp[ _CCODFAM ]
         hValue[ "nTarifaPrecio"     ] := aTmp[ _NTARLIN ]
         hValue[ "nCajas"            ] := aTmp[ _NCANSAT ]
         hValue[ "nUnidades"         ] := aTmp[ _NUNICAJA ]
         hValue[ "lIvaIncluido"      ] := aTmp[ _LIVALIN ]

      case ValType( aTmp ) == "C"

         hValue[ "cCodigoArticulo"   ] := ( aTmp )->cRef
         hValue[ "cCodigoPropiedad1" ] := ( aTmp )->cCodPr1
         hValue[ "cCodigoPropiedad2" ] := ( aTmp )->cCodPr2
         hValue[ "cValorPropiedad1"  ] := ( aTmp )->cValPr1
         hValue[ "cValorPropiedad2"  ] := ( aTmp )->cValPr2
         hValue[ "cCodigoFamilia"    ] := ( aTmp )->cCodFam
         hValue[ "nTarifaPrecio"     ] := ( aTmp )->nTarLin         
         hValue[ "nCajas"            ] := ( aTmp )->nCanSat
         hValue[ "nUnidades"         ] := ( aTmp )->nUniCaja
         hValue[ "lIvaIncluido"      ] := ( aTmp )->lIvaLin

   end case      

   hValue[ "nTotalLinea"       ]       := nTotLSatCli( aTmp )

   do case 
      case ValType( aTmpSat ) == "A"

         hValue[ "cCodigoCliente"    ] := aTmpSat[ _CCODCLI ]
         hValue[ "cCodigoGrupo"      ] := aTmpSat[ _CCODGRP ]
         hValue[ "lIvaIncluido"      ] := aTmpSat[ _LIVAINC ]
         hValue[ "dFecha"            ] := aTmpSat[ _DFECSAT ]
         hValue[ "cGrupoCliente"     ] := aTmpSat[ _CCODGRP ]
         hValue[ "cDivisa"           ] := aTmpSat[ _CDIVSAT ]

      case ValType( aTmpSat ) == "C"
         
         hValue[ "cCodigoCliente"    ] := ( aTmpSat )->cCodCli
         hValue[ "cCodigoGrupo"      ] := ( aTmpSat )->cCodGrp
         hValue[ "lIvaIncluido"      ] := ( aTmpSat )->lIvaInc
         hValue[ "dFecha"            ] := ( aTmpSat )->dFecSat
         hValue[ "cGrupoCliente"     ] := ( aTmpSat )->cCodGrp 
         hValue[ "cDivisa"           ] := ( aTmpSat )->cDivSat 

   end case

   hValue[ "nTipoDocumento"         ]  := SAT_CLI
   hValue[ "nView"                  ]  := nView

Return ( hValue )

//---------------------------------------------------------------------------//

Static Function ImprimirSeriesSatClientes( nDevice, lExt )

   local aStatus
   local oPrinter   
   local cFormato 

   DEFAULT nDevice   := IS_PRINTER
   DEFAULT lExt      := .f.

   // Cremaos el dialogo-------------------------------------------------------

   oPrinter          := PrintSeries():New( nView ):SetVentas()

   // Establecemos sus valores-------------------------------------------------

   oPrinter:Serie(      ( D():SatClientes( nView ) )->cSerSat )
   oPrinter:Documento(  ( D():SatClientes( nView ) )->nNumSat )
   oPrinter:Sufijo(     ( D():SatClientes( nView ) )->cSufSat )

   if lExt

      oPrinter:oFechaInicio:cText( ( D():SatClientes( nView ) )->dFecSat )
      oPrinter:oFechaFin:cText( ( D():SatClientes( nView ) )->dFecSat )

   end if

   oPrinter:oFormatoDocumento:TypeDocumento( "SC" )   

   // Formato de documento-----------------------------------------------------

   cFormato          := cFormatoDocumento( ( D():SatClientes( nView ) )->cSerSat, "nSatCli", D():Contadores( nView ) )
   if empty( cFormato )
      cFormato       := cFirstDoc( "SC", D():Documentos( nView ) )
   end if
   oPrinter:oFormatoDocumento:cText( cFormato )

   // Codeblocks para que trabaje----------------------------------------------

   aStatus           := D():GetInitStatus( "SatCliT", nView )

   oPrinter:bInit    := {||   ( D():SatClientes( nView ) )->( dbSeek( oPrinter:DocumentoInicio(), .t. ) ) }

   oPrinter:bWhile   := {||   oPrinter:InRangeDocumento( D():SatClientesId( nView ) )                  .and. ;
                              ( D():SatClientes( nView ) )->( !eof() ) }

   oPrinter:bFor     := {||   oPrinter:InRangeFecha( ( D():SatClientes( nView ) )->dFecSat )           .and. ;
                              oPrinter:InRangeCliente( ( D():SatClientes( nView ) )->cCodCli )         .and. ;
                              oPrinter:InRangeAgente( ( D():SatClientes( nView ) )->cCodAge )         .and. ;
                              oPrinter:InRangeGrupoCliente( retGrpCli( ( D():SatClientes( nView ) )->cCodCli, D():Clientes( nView ) ) ) }

   oPrinter:bSkip    := {||   ( D():SatClientes( nView ) )->( dbSkip() ) }

   oPrinter:bAction  := {||   GenSatCli(  nDevice,;
                                          "Imprimiendo documento : " + D():SatClientesId( nView ),;
                                          oPrinter:oFormatoDocumento:uGetValue,;
                                          oPrinter:oImpresora:uGetValue,;
                                          if( !oPrinter:oCopias:lCopiasPredeterminadas, oPrinter:oCopias:uGetValue, ) ) }

   oPrinter:bStart   := {||   if( lExt, oPrinter:DisableRange(), ) }

   // Abrimos el dialogo-------------------------------------------------------

   oPrinter:Resource():End()

   // Restore -----------------------------------------------------------------

   D():SetStatus( "SatCliT", nView, aStatus )
   
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

FUNCTION nTotSatCli( cNumSat, cSatCliT, cSatCliL, cIva, cDiv, cFPago, aTmp, cDivRet, lPic )

   local n
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
   local nDescuentosLineas := 0
   local nRegIva
   local nBaseGasto
   local nIvaGasto

   DEFAULT cSatCliT        := D():SatClientes( nView )
   DEFAULT cSatCliL        := D():SatClientesLineas( nView )
   DEFAULT cIva            := dbfIva
   DEFAULT cDiv            := dbfDiv
   DEFAULT cFPago          := dbfFPago
   DEFAULT cNumSat    := ( cSatCliT )->cSerSat + Str( ( cSatCliT )->nNumSat ) + ( cSatCliT )->cSufSat
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

   public aTotIva    := { { 0,0,nil,0,0,0,0,0,0,0,0 }, { 0,0,nil,0,0,0,0,0,0,0,0 }, { 0,0,nil,0,0,0,0,0,0,0,0 } }
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
      nRegIva        := aTmp[ _NREGIVA ]
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
      nRegIva        := ( cSatCliT )->nRegIva
      bCondition     := {|| ( cSatCliL )->cSerSat + Str( ( cSatCliL )->nNumSat ) + ( cSatCliL )->cSufSat == cNumSat .and. !( cSatCliL )->( eof() ) }
      ( cSatCliL )->( dbSeek( cNumSat ) )
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

            if ( cSatCliL )->nPreDiv != nTotalLin .OR. ( cSatCliL )->nUniCaja != nTotalUnd

               if ( cSatCliL )->( dbRLock() )
                  ( cSatCliL )->nPreDiv    := nTotalLin
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

            nTotArt           := nTotLSatCli( cSatCliL, nDouDiv, nRouDiv, , , .f., .f. )
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
            Estudio de impuestos-----------------------------------------------------
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
   Ordenamos los impuestosS de menor a mayor
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

   if !lIvaInc .and. uFieldEmpresa( "lIvaImpEsp" )
      _NBASIVA1      += _NIVMIVA1
      _NBASIVA2      += _NIVMIVA2
      _NBASIVA3      += _NIVMIVA3
   end if

   if !lIvaInc

      if nRegIva <= 1

         /*
         Calculos de impuestos
         */

         _NIMPIVA1      := if( _NPCTIVA1 != NIL, Round( _NBASIVA1 * _NPCTIVA1 / 100, nRouDiv ), 0 )
         _NIMPIVA2      := if( _NPCTIVA2 != NIL, Round( _NBASIVA2 * _NPCTIVA2 / 100, nRouDiv ), 0 )
         _NIMPIVA3      := if( _NPCTIVA3 != NIL, Round( _NBASIVA3 * _NPCTIVA3 / 100, nRouDiv ), 0 )

         /*
         Calculo de recargo
         */

         if lRecargo
            _NIMPREQ1   := if( _NPCTIVA1 != NIL, Round( _NBASIVA1 * _NPCTREQ1 / 100, nRouDiv ), 0 )
            _NIMPREQ2   := if( _NPCTIVA2 != NIL, Round( _NBASIVA2 * _NPCTREQ2 / 100, nRouDiv ), 0 )
            _NIMPREQ3   := if( _NPCTIVA3 != NIL, Round( _NBASIVA3 * _NPCTREQ3 / 100, nRouDiv ), 0 )
         end if

         if uFieldEmpresa( "lIvaImpEsp")
            _NBASIVA1            -= _NIVMIVA1
            _NBASIVA2            -= _NIVMIVA2
            _NBASIVA3            -= _NIVMIVA3
         end if

      end if

   else

      if  !uFieldEmpresa( "lIvaImpEsp" )
         _NBASIVA1         -= _NIVMIVA1
         _NBASIVA2         -= _NIVMIVA2
         _NBASIVA3         -= _NIVMIVA3   
      end if

      if nRegIva <= 1

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
               _NIMPREQ1   := if( _NPCTIVA1 != NIL, Round( _NBASIVA1 / ( 100 / _NPCTREQ1 + 1 ), nRouDiv ), 0 )
            end if
            if _NPCTREQ3 != 0
               _NIMPREQ2   := if( _NPCTIVA2 != NIL, Round( _NBASIVA2 / ( 100 / _NPCTREQ2 + 1 ), nRouDiv ), 0 )
            end if
            if _NPCTREQ3 != 0
               _NIMPREQ3   := if( _NPCTIVA3 != NIL, Round( _NBASIVA3 / ( 100 / _NPCTREQ3 + 1 ), nRouDiv ), 0 )
            end if
         end if

         _NBASIVA1      -= _NIMPIVA1
         _NBASIVA2      -= _NIMPIVA2
         _NBASIVA3      -= _NIMPIVA3

      end if

      if uFieldEmpresa( "lIvaImpEsp")
         _NBASIVA1         -= _NIVMIVA1
         _NBASIVA2         -= _NIVMIVA2
         _NBASIVA3         -= _NIVMIVA3
      end if

      _NBASIVA1      -= _NIMPREQ1
      _NBASIVA2      -= _NIMPREQ2
      _NBASIVA3      -= _NIMPREQ3

   end if

   // Estudio de impuestos para el Gasto despues de los descuentos-------------

   if nManObr != 0

      if lIvaInc 
         nIvaGasto   := Round( nManObr / ( 100 / nIvaMan + 1 ), nRouDiv )
         nBaseGasto  := nManObr - nIvaGasto
      else 
         nBaseGasto  := nManObr 
         nIvaGasto   := Round( nManObr * nIvaMan / 100, nRouDiv )
      end if 

      do case
      case _NPCTIVA1 == nil .or. _NPCTIVA1 == nIvaMan
         _NPCTIVA1   := nIvaMan
         _NBASIVA1   += nBaseGasto
         _NIMPIVA1   += nIvaGasto

      case _NPCTIVA2 == nil .or. _NPCTIVA2 == nIvaMan
         _NPCTIVA2   := nIvaMan
         _NBASIVA2   += nBaseGasto
         _NIMPIVA2   += nIvaGasto

      case _NPCTIVA3 == nil .or. _NPCTIVA3 == nIvaMan
         _NPCTIVA3   := nIvaMan
         _NBASIVA3   += nBaseGasto
         _NIMPIVA3   += nIvaGasto

      end case

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
   Total de impuestos
   */

   nTotIva           := Round( _NIMPIVA1 + _NIMPIVA2 + _NIMPIVA3, nRouDiv )

   /*
   Total de R.E.
   */

   nTotReq           := Round( _NIMPREQ1 + _NIMPREQ2 + _NIMPREQ3, nRouDiv )

   /*
   Total de impuestos
   */

   nTotImp           := Round( nTotIva + nTotReq + nTotIvm, nRouDiv )

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

   ( cSatCliL )->( dbGoTo( nRecno) )

   /*
   Solicitan una divisa distinta a la q se hizo originalmente la factura
   */

   if cDivRet != nil .and. cDivRet != cCodDiv
      nTotNet     := nCnv2Div( nTotNet, cCodDiv, cDivRet )
      nTotIvm     := nCnv2Div( nTotIvm, cCodDiv, cDivRet )
      nTotIva     := nCnv2Div( nTotIva, cCodDiv, cDivRet )
      nTotReq     := nCnv2Div( nTotReq, cCodDiv, cDivRet )
      nTotSat     := nCnv2Div( nTotSat, cCodDiv, cDivRet )
      nTotPnt     := nCnv2Div( nTotPnt, cCodDiv, cDivRet )
      nTotTrn     := nCnv2Div( nTotTrn, cCodDiv, cDivRet )
      cPorDiv     := cPorDiv( cDivRet, cDiv )
   end if

RETURN ( if( lPic, Trans( nTotSat, cPorDiv ), nTotSat ) )

//--------------------------------------------------------------------------//

FUNCTION aTotSatCli( cSat, dbfMaster, dbfLine, dbfIva, dbfDiv, dbfFPago, cDivRet )

   nTotSatCli( cSat, dbfMaster, dbfLine, dbfIva, dbfDiv, dbfFPago, nil, cDivRet )

RETURN ( { nTotNet, nTotIva, nTotReq, nTotSat, nTotPnt, nTotTrn, nTotAge, nTotCos } )

//--------------------------------------------------------------------------//

FUNCTION BrwSatCli( oGet, cSatCliT, cSatCliL, dbfIva, dbfDiv, dbfFPago, oIva )

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
   nOrdAnt        := ( cSatCliT )->( OrdSetFocus( nOrd ) )
   nRecAnt        := ( cSatCliT )->( Recno() )

   ( cSatCliT )->( dbSetFilter( {|| !Field->lEstado .and. Field->lIvaInc == lIva }, "!lEstado .and. lIvaInc == lIva" ) )
   ( cSatCliT )->( dbGoTop() )

   DEFINE DIALOG oDlg RESOURCE "HELPENTRY" TITLE if( lIva, "S.A.T. de clientes con " + cImp() + " incluido", "S.A.T. de clientes con " + cImp() + " desglosado" )

      REDEFINE GET oGet1 VAR cGet1;
         ID       104 ;
         ON CHANGE( AutoSeek( nKey, nFlags, Self, oBrw, cSatCliT, .t., nil, .f. ) );
         VALID    ( OrdClearScope( oBrw, cSatCliT ) );
         BITMAP   "FIND" ;
         OF       oDlg

      REDEFINE COMBOBOX oCbxOrd ;
         VAR      cCbxOrd ;
         ID       102 ;
         ITEMS    aCbxOrd ;
         ON CHANGE( ( cSatCliT )->( ordSetFocus( oCbxOrd:nAt ) ), oBrw:Refresh(), oGet1:SetFocus() ) ;
         OF       oDlg

      oBrw                 := IXBrowse():New( oDlg )

      oBrw:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrw:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrw:cAlias          := cSatCliT
      oBrw:nMarqueeStyle   := 5
      oBrw:cName           := "SAT a cliente.Browse"

      oBrw:bLDblClick      := {|| oDlg:end( IDOK ) }

      oBrw:CreateFromResource( 105 )

      with object ( oBrw:AddCol() )
         :cHeader          := "Número"
         :cSortOrder       := "nNumSat"
         :bEditValue       := {|| ( cSatCliT )->cSerSat + "/" + AllTrim( Str( ( cSatCliT )->nNumSat ) ) + "/" + ( cSatCliT )->cSufSat }
         :nWidth           := 60
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Fecha"
         :cSortOrder       := "dFecSat"
         :bEditValue       := {|| dtoc( ( cSatCliT )->dFecSat ) }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Cliente"
         :cSortOrder       := "cCodCli"
         :bEditValue       := {|| AllTrim( ( cSatCliT )->cCodCli ) }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Nombre"
         :cSortOrder       := "cNomCli"
         :bEditValue       := {|| AllTrim( ( cSatCliT )->cNomCli ) }
         :nWidth           := 300
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Importe"
         :bEditValue       := {|| nTotSatCli( ( cSatCliT )->cSerSat + Str( ( cSatCliT )->nNumSat ) + ( cSatCliT )->cSufSat, cSatCliT, cSatCliL, dbfIva, dbfDiv, dbfFPago, nil, cDivEmp(), .t. ) }
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

   DestroyFastFilter( cSatCliT )

   SetBrwOpt( "BrwSatCli", ( cSatCliT )->( OrdNumber() ) )

   if oDlg:nResult == IDOK
      oGet:cText( ( cSatCliT )->cSerSat + Str( ( cSatCliT )->nNumSat ) + ( cSatCliT )->cSufSat )
      oGet:lValid()
   end if

   ( cSatCliT )->( dbClearFilter() )
   ( cSatCliT )->( ordSetFocus( nOrdAnt ) )
   ( cSatCliT )->( dbGoTo( nRecAnt ) )

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

FUNCTION ChgSatCli( cSat, nMode, cSatCliT )

   local oBlock
   local oError
   local lExito := .T.
   local lClose := .F.

   IF nMode != APPD_MODE .OR. Empty( cSat )
      RETURN NIL
   END IF

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   IF cSatCliT == NIL

      USE ( cPatEmp() + "SATCLI.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "SATCLI", @cSatCliT ) )
      SET ADSINDEX TO ( cPatEmp() + "SATCLI.CDX" ) ADDITIVE
      lClose := .T.

   END IF

   IF (cSatCliT)->( dbSeek( cSat ) )
      if dbDialogLock( cSatCliT )
         (cSatCliT)->lEstado   := .t.
         (cSatCliT)->( dbUnLock() )
      end if
   ELSE
      lExito := .F.
   END IF

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   IF lClose
      CLOSE (cSatCliT)
   END IF

RETURN lExito

//-------------------------------------------------------------------------//

FUNCTION nTotUSatCli( uTmpLin, nDec, nVdv )

   local nCalculo       := 0

   DEFAULT uTmpLin      := D():SatClientesLineas( nView )
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

   DEFAULT nDec      := nDouDiv()
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

   DEFAULT nDec      := nDouDiv()
   DEFAULT nVdv      := 1

   nCalculo          := nImpUSatCli( uTmpLin, nDec, nVdv, cPorDiv )
   nCalculo          *= nTotNSatCli( uTmpLin )

   nCalculo          := Round( nCalculo / nVdv, nRec )

Return ( if( cPorDiv != nil, Trans( nCalculo, cPorDiv ), nCalculo ) )

//---------------------------------------------------------------------------//

FUNCTION nIvaUSatCli( dbfTmpLin, nDec, nVdv )

   local nCalculo

   DEFAULT nDec   := nDouDiv()
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

   DEFAULT dbfLin    := D():SatClientesLineas( nView )
   DEFAULT nDec      := nDouDiv()
   DEFAULT nRou      := nRouDiv()
   DEFAULT nVdv      := 1
   DEFAULT lDto      := .t.
   DEFAULT lPntVer   := .t.
   DEFAULT lImpTrn   := .t.

   nCalculo          += nTotLSatCli( dbfLin, nDec, nRou, nVdv, lDto, lPntVer, lImpTrn )
   nCalculo          += nIvaLSatCli( dbfLin, nDec, nRou, nVdv, lDto, lPntVer, lImpTrn )


return ( if( cPorDiv != nil, Trans( nCalculo, cPorDiv ), nCalculo ) )


//---------------------------------------------------------------------------//

FUNCTION cDesSatCli( cSatCliL, cSatCliS )

   DEFAULT cSatCliL  := D():SatClientesLineas( nView )
   DEFAULT cSatCliS  := dbfSatCliS

RETURN ( Descrip( cSatCliL, cSatCliS ) )

//---------------------------------------------------------------------------//

FUNCTION cDesSatCliLeng( cSatCliL, cSatCliS, cArtLeng )

   DEFAULT cSatCliL  := D():SatClientesLineas( nView )
   DEFAULT cSatCliS  := dbfSatCliS
   DEFAULT cArtLeng  := D():ArticuloLenguaje( nView )

RETURN ( DescripLeng( cSatCliL, cSatCliS, cArtLeng ) )

//---------------------------------------------------------------------------//

Function isLineaTotalSatCli( uSatCliL )

   if isArray( uSatCliL )
      Return ( uSatCliL[ _LTOTLIN ] )
   end if

Return ( ( uSatCliL )->lTotLin )

//---------------------------------------------------------------------------//

Function nDescuentoLinealSatCli( uSatCliL, nDec, nVdv )

   local nDescuentoLineal

   if isArray( uSatCliL )
      nDescuentoLineal  := uSatCliL[ _NDTODIV ]
   else 
      nDescuentoLineal  := ( uSatCliL )->nDtoDiv
   end if

Return ( Round( nDescuentoLineal / nVdv, nDec ) )

//---------------------------------------------------------------------------//

Function nDescuentoPorcentualSatCli( uSatCliL )

   local nDescuentoPorcentual

   if isArray( uSatCliL )
      nDescuentoPorcentual  := uSatCliL[ _NDTO ]
   else 
      nDescuentoPorcentual  := ( uSatCliL )->nDto
   end if

Return ( nDescuentoPorcentual )

//---------------------------------------------------------------------------//

Function nDescuentoPromocionSatCli( uSatCliL )

   local nDescuentoPromocion

   if isArray( uSatCliL )
      nDescuentoPromocion  := uSatCliL[ _NDTOPRM ]
   else 
      nDescuentoPromocion  := ( uSatCliL )->nDtoPrm
   end if

Return ( nDescuentoPromocion )

//---------------------------------------------------------------------------//

Function nPuntoVerdeSatCli( uSatCliL )

   local nPuntoVerde

   if isArray( uSatCliL )
      nPuntoVerde  := uSatCliL[ _NPNTVER ]
   else 
      nPuntoVerde  := ( uSatCliL )->nPntVer
   end if

Return ( nPuntoVerde )

//---------------------------------------------------------------------------//

Function nTransporteSatCli( uSatCliL )

   local nTransporte

   if isArray( uSatCliL )
      nTransporte  := uSatCliL[ _NIMPTRN ]
   else 
      nTransporte  := ( uSatCliL )->nImpTrn
   end if

Return ( nTransporte )

//---------------------------------------------------------------------------//

FUNCTION nTotLSatCli( uSatCliL, nDec, nRou, nVdv, lDto, lPntVer, lImpTrn, cPouDiv )

   local nCalculo
   local nUnidades

   DEFAULT uSatCliL     := D():SatClientesLineas( nView )
   DEFAULT nDec         := nDouDiv()
   DEFAULT nRou         := nRouDiv()
   DEFAULT nVdv         := 1
   DEFAULT lDto         := .t.
   DEFAULT lPntVer      := .t.
   DEFAULT lImpTrn      := .t.

   if isLineaTotalSatCli( uSatCliL )

      nCalculo          := nTotUSatCli( uSatCliL, nDec, nVdv )

   else

      nUnidades         := nTotNSatCli( uSatCliL )
      nCalculo          := nTotUSatCli( uSatCliL, nDec, nVdv ) * nUnidades

      /*
      Descuentos---------------------------------------------------------------
      */

      nCalculo          -= nDescuentoLinealSatCli( uSatCliL, nDec, nVdv ) * nUnidades

      if lDto .and. nDescuentoPorcentualSatCli( uSatCliL ) != 0 
         nCalculo       -= nCalculo * nDescuentoPorcentualSatCli( uSatCliL ) / 100
      end if

      if lDto .and. nDescuentoPromocionSatCli( uSatCliL ) != 0 
         nCalculo       -= nCalculo * nDescuentoPromocionSatCli( uSatCliL ) / 100
      end if

      /*
      Punto Verde--------------------------------------------------------------
      */

      if lPntVer .and. nPuntoVerdeSatCli( uSatCliL ) != 0
         nCalculo       += nPuntoVerdeSatCli( uSatCliL ) * nUnidades
      end if

      /*
      Transporte---------------------------------------------------------------
      */

      if lImpTrn .and. nTransporteSatCli( uSatCliL ) != 0
         nCalculo       += nTransporteSatCli( uSatCliL ) * nUnidades
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

//---------------------------------------------------------------------------//
/*
Devuelve el importe de descuento porcentual en promociones por cada linea------
*/

FUNCTION nPrmLSatCli( cSatCliL, nDec, nRou, nVdv )

   local nCalculo       := 0

   DEFAULT cSatCliL     := D():SatClientesLineas( nView )
   DEFAULT nDec         := nDouDiv()
   DEFAULT nRou         := nRouDiv()
   DEFAULT nVdv         := 1

   if ( cSatCliL )->nDtoPrm != 0 .and. !( cSatCliL )->lTotLin

      nCalculo          := nTotUSatCli( cSatCliL, nDec ) * nTotNSatCli( cSatCliL )

      /*
      Descuentos---------------------------------------------------------------
      */

      nCalculo          -= Round( ( cSatCliL )->nDtoDiv / nVdv , nDec )

      if ( cSatCliL )->nDto != 0 
         nCalculo       -= nCalculo * ( cSatCliL )->nDto / 100
      end if

      nCalculo          := nCalculo * ( cSatCliL )->nDtoPrm / 100

      if nVdv != 0
         nCalculo       := nCalculo / nVdv
      end if

      if nRou != nil
         nCalculo       := Round( nCalculo, nRou )
      end if

   end if

RETURN ( nCalculo ) 

//---------------------------------------------------------------------------//

FUNCTION nTotCSatCli( dbfLine, nDec, nRec, nVdv, cPouDiv )

   local nCalculo       := 0

   DEFAULT nDec         := nDouDiv()
   DEFAULT nRec         := nRouDiv()
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

   DEFAULT cSatCliL  := D():SatClientesLineas( nView )

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

FUNCTION nIvaLSatCli( dbfLin, nDec, nRouDec, nVdv, lDto, lPntVer, lImpTrn, cPouDiv )

   local nCalculo    := 0

   if ( dbfLin )->nRegIva <= 1

      nCalculo          := nTotLSatCli( dbfLin, nDec, nRouDec, nVdv, lDto, lPntVer, lImpTrn, cPouDiv )

      if !( dbfLin )->lIvaLin
         nCalculo    := nCalculo * ( dbfLin )->nIva / 100
      else
         nCalculo    -= nCalculo / ( 1 + ( dbfLin )->nIva / 100 )
      end if

   end if

RETURN ( if( cPouDiv != nil, Trans( nCalculo, cPouDiv ), nCalculo ) )

//---------------------------------------------------------------------------//

Function nPntUSatCli( dbfTmpLin, nDec, nVdv )

   local nCalculo

   DEFAULT nDec   := nDouDiv()
   DEFAULT nVdv   := 1

   nCalculo       := ( dbfTmpLin )->nPntVer

   IF nVdv != 0
      nCalculo    := ( dbfTmpLin )->nPntVer / nVdv
   END IF

RETURN ( round( nCalculo, nDec ) )

//---------------------------------------------------------------------------//

FUNCTION nPntLSatCli( dbfLin, nDec, nVdv )

   local nPntVer

   DEFAULT dbfLin    := D():SatClientesLineas( nView )
   DEFAULT nDec      := nDouDiv()
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

   DEFAULT nDec   := nDouDiv()
   DEFAULT nVdv   := 1

   nCalculo       := ( dbfTmpLin )->nImpTrn

   IF nVdv != 0
      nCalculo    := nCalculo / nVdv
   END IF

RETURN ( Round( nCalculo, nDec ) )

//---------------------------------------------------------------------------//

FUNCTION nDtoUSatCli( dbfTmpLin, nDec, nVdv )

   local nCalculo := ( dbfTmpLin )->nDtoDiv

   DEFAULT nDec   := nDouDiv()
   DEFAULT nVdv   := 1

   if nVdv != 0
      nCalculo    /= nVdv
   end if

RETURN ( round( nCalculo, nDec ) )

//---------------------------------------------------------------------------//

FUNCTION nTrnLSatCli( dbfLin, nDec, nRou, nVdv )

   local nImpTrn

   DEFAULT dbfLin    := D():SatClientesLineas( nView )
   DEFAULT nDec      := nDouDiv()
   DEFAULT nRou      := nRouDiv()
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
/*
Devuelve el importe de descuento porcentual por cada linea---------------------
*/

FUNCTION nDtoLSatCli( cSatCliL, nDec, nRou, nVdv )

   local nCalculo       := 0

   DEFAULT cSatCliL     := D():SatClientesLineas( nView )
   DEFAULT nDec         := nDouDiv()
   DEFAULT nRou         := nRouDiv()
   DEFAULT nVdv         := 1

   if ( cSatCliL )->nDto != 0 .and. !( cSatCliL )->lTotLin

      nCalculo          := nTotUSatCli( cSatCliL, nDec ) * nTotNSatCli( cSatCliL )

      /*
      Descuentos---------------------------------------------------------------
      */

      nCalculo          -= Round( ( cSatCliL )->nDtoDiv / nVdv , nDec )

      nCalculo          := nCalculo * ( cSatCliL )->nDto / 100


      if nVdv != 0
         nCalculo       := nCalculo / nVdv
      end if

      if nRou != nil
         nCalculo       := Round( nCalculo, nRou )
      end if

   end if

RETURN ( nCalculo ) 

//---------------------------------------------------------------------------//

FUNCTION mkSatCli( cPath, lAppend, cPathOld, oMeter, bFor )
   
   local cSatCliT
   local cSatCliL

   local oldSatCliT
   local oldSatCliL
   local oldSatCliI
   local oldSatCliD

   if oMeter != NIL
      oMeter:cText   := "Generando Bases"
      sysrefresh()
   end if

   DEFAULT lAppend   := .f.
   DEFAULT bFor      := {|| .t. }

   createFiles( cPath )

   rxSatCli( cPath, cLocalDriver() )

   if lAppend .and. lIsDir( cPathOld )

      dbUseArea( .t., cDriver(), cPath + "SATCLIT.DBF", cCheckArea( "SATCLIT", @cSatCliT ), .f. )
      if !( cSatCliT )->( neterr() )
         ( cSatCliT )->( ordListAdd( cPath + "SATCLIT.CDX" ) )
      end if

      dbUseArea( .t., cDriver(), cPath + "SatCliL.DBF", cCheckArea( "SatCliL", @cSatCliL ), .f. )
      if !( cSatCliL )->( neterr() )
         ( cSatCliL )->( ordListAdd( cPath + "SatCliL.CDX" ) )
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
      if !( cSatCliT )->( neterr() )
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

            dbCopy( oldSatCliT, cSatCliT, .t. )

            if ( oldSatCliL )->( dbSeek( ( oldSatCliT )->cSerSat + Str( ( oldSatCliT )->nNumSat ) + ( oldSatCliT )->cSufSat ) )
               while ( oldSatCliL )->cSerSat + Str( ( oldSatCliL )->nNumSat ) + ( oldSatCliL )->cSufSat == ( oldSatCliT )->cSerSat + Str( ( oldSatCliT )->nNumSat ) + ( oldSatCliT )->cSufSat .and. !( oldSatCliL )->( eof() )
                  dbCopy( oldSatCliL, cSatCliL, .t. )
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

      ( cSatCliT )->( dbCloseArea() )
      ( cSatCliL )->( dbCloseArea() )
      ( dbfSatCliI )->( dbCloseArea() )
      ( dbfSatCliD )->( dbCloseArea() )

      ( oldSatCliT )->( dbCloseArea() )
      ( oldSatCliL )->( dbCloseArea() )
      ( oldSatCliI )->( dbCloseArea() )
      ( oldSatCliD )->( dbCloseArea() )

   end if

Return Nil

//---------------------------------------------------------------------------//

FUNCTION rxSatCli( cPath, cDriver )

   local cSatCliT

   DEFAULT cPath     := cPatEmp()
   DEFAULT cDriver   := cDriver()

   if !lExistTable( cPath + "SatCliT.Dbf", cDriver ) .OR. ;
      !lExistTable( cPath + "SatCliL.Dbf", cDriver ) .OR. ;
      !lExistTable( cPath + "SatCliI.Dbf", cDriver ) .OR. ;
      !lExistTable( cPath + "SatCliD.Dbf", cDriver )
      !lExistTable( cPath + "SatCliS.Dbf", cDriver )
      createFiles( cPath )
   end if

   fEraseIndex( cPath + "SatCliT.Cdx", cDriver )
   fEraseIndex( cPath + "SatCliL.Cdx", cDriver )
   fEraseIndex( cPath + "SatCliI.Cdx", cDriver )
   fEraseIndex( cPath + "SatCliD.Cdx", cDriver )
   fEraseIndex( cPath + "SatCliS.Cdx", cDriver )

   dbUseArea( .t., cDriver, cPath + "SATCLIT.DBF", cCheckArea( "SATCLIT", @cSatCliT ), .f. )
   if !( cSatCliT )->( neterr() )
      ( cSatCliT )->( __dbPack() )

      ( cSatCliT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cSatCliT )->( ordCreate( cPath + "SATCLIT.CDX", "NNUMSAT", "CSERSAT + STR( NNUMSAT ) + CSUFSAT", {|| Field->CSERSAT + STR(Field->NNUMSAT) + Field->CSUFSAT } ) )

      ( cSatCliT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cSatCliT )->( ordCreate( cPath + "SATCLIT.CDX", "DFECSAT", "DFECSAT", {|| Field->DFECSAT } ) )

      ( cSatCliT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cSatCliT )->( ordCreate( cPath + "SATCLIT.CDX", "CCODCLI", "CCODCLI + Dtos( dFecSat )", {|| Field->CCODCLI + Dtos( Field->dFecSat ) } ) )

      ( cSatCliT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cSatCliT )->( ordCreate( cPath + "SATCLIT.CDX", "CNOMCLI", "cNomCli + Dtos( dFecSat )", {|| Field->cNomCli + Dtos( Field->dFecSat ) } ) )

      ( cSatCliT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cSatCliT )->( ordCreate( cPath + "SATCLIT.CDX", "cCodObr", "cCodObr", {|| Field->cCodObr } ) )

      ( cSatCliT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cSatCliT )->( ordCreate( cPath + "SATCLIT.CDX", "cCodAge", "cCodAge", {|| Field->cCodAge } ) )

      ( cSatCliT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cSatCliT )->( ordCreate( cPath + "SATCLIT.CDX", "CTURSAT", "CTURSAT + CSUFSAT + cCodCaj", {|| Field->CTURSAT + Field->CSUFSAT + Field->cCodCaj } ) )

      ( cSatCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( cSatCliT )->( ordCreate( cPath + "SatCliT.CDX", "lSndDoc", "lSndDoc", {|| Field->lSndDoc } ) )

      ( cSatCliT )->( ordCondSet( "!Deleted()", {||!Deleted()}  ) )
      ( cSatCliT )->( ordCreate( cPath + "SatCliT.Cdx", "cCodUsr", "cCodUsr + Dtos( dFecCre ) + cTimCre", {|| Field->cCodUsr + Dtos( Field->dFecCre ) + Field->cTimCre } ) )

      ( cSatCliT )->( ordCondSet( "!Deleted()", {||!Deleted()}  ) )
      ( cSatCliT )->( ordCreate( cPath + "SatCliT.Cdx", "cNumAlb", "cNumAlb", {|| Field->cNumAlb } ) )

      ( cSatCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( cSatCliT )->( ordCreate( cPath + "SatCliT.Cdx", "iNumSat", "'32' + cSerSat + Str( nNumSat ) + Space( 1 ) + cSufSat", {|| '32' + Field->cSerSat + Str( Field->nNumSat ) + Space( 1 ) + Field->cSufSat } ) )

      ( cSatCliT )->( ordCondSet( "!Deleted()", {||!Deleted()}  ) )
      ( cSatCliT )->( ordCreate( cPath + "SatCliT.Cdx", "cCodOpe", "cCodOpe", {|| Field->cCodOpe } ) )

      ( cSatCliT )->( ordCondSet( "!Deleted()", {||!Deleted()}  ) )
      ( cSatCliT )->( ordCreate( cPath + "SatCliT.Cdx", "cCodCat", "cCodCat", {|| Field->cCodCat } ) )

      ( cSatCliT )->( ordCondSet( "!Deleted()", {||!Deleted()}  ) )
      ( cSatCliT )->( ordCreate( cPath + "SatCliT.Cdx", "cSituac", "cSituac", {|| Field->cSituac } ) )

      ( cSatCliT )->( ordCondSet( "!Deleted()", {||!Deleted()}  ) )
      ( cSatCliT )->( ordCreate( cPath + "SatCliT.Cdx", "cCodEst", "cCodEst", {|| Field->cCodEst } ) )

      ( cSatCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() }, , , , , , , , , .t. ) )
      ( cSatCliT )->( ordCreate( cPath + "SatCliT.Cdx", "cNumDes", "CSERSAT + STR( NNUMSAT ) + CSUFSAT", {|| Field->CSERSAT + STR(Field->NNUMSAT) + Field->CSUFSAT } ) )

      ( cSatCliT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cSatCliT )->( ordCreate( cPath + "SatCliT.CDX", "Poblacion", "UPPER( Field->cPobCli )", {|| UPPER( Field->cPobCli ) } ) )

      ( cSatCliT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cSatCliT )->( ordCreate( cPath + "SatCliT.CDX", "Provincia", "UPPER( Field->cPrvCli )", {|| UPPER( Field->cPrvCli ) } ) )

      ( cSatCliT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cSatCliT )->( ordCreate( cPath + "SatCliT.CDX", "CodPostal", "Field->cPosCli", {|| Field->cPosCli } ) )

      ( cSatCliT )->( ordCondSet("!Deleted()", {||!Deleted()}, , , , , , , , , .t.  ) )
      ( cSatCliT )->( ordCreate( cPath + "SATCLIT.CDX", "DDESFEC", "DFECSAT", {|| Field->DFECSAT } ) )

      ( cSatCliT )->( dbCloseArea() )

   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de S.A.T. de clientes" )
   end if

   dbUseArea( .t., cDriver, cPath + "SATCLIL.DBF", cCheckArea( "SATCLIL", @cSatCliT ), .f. )
   if !( cSatCliT )->( neterr() )
      ( cSatCliT )->( __dbPack() )

      ( cSatCliT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cSatCliT )->( ordCreate( cPath + "SatCliL.Cdx", "NNUMSAT", "CSERSAT + STR( NNUMSAT ) + CSUFSAT", {|| Field->CSERSAT + STR( Field->NNUMSAT ) + Field->CSUFSAT } ) )

      ( cSatCliT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cSatCliT )->( ordCreate( cPath + "SatCliL.Cdx", "CREF", "CREF", {|| Field->CREF }, ) )

      ( cSatCliT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cSatCliT )->( ordCreate( cPath + "SatCliL.Cdx", "Lote", "cLote", {|| Field->cLote }, ) )

      ( cSatCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( cSatCliT )->( ordCreate( cPath + "SatCliL.Cdx", "iNumSat", "'32' + cSerSat + Str( nNumSat ) + Space( 1 ) + cSufSat + Str( nNumLin )", {|| '32' + Field->cSerSat + Str( Field->nNumSat ) + Space( 1 ) + Field->cSufSat + Str( Field->nNumLin ) } ) )

      ( cSatCliT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cSatCliT )->( ordCreate( cPath + "SatCliL.Cdx", "nNumLin", "Str( NNUMSAT ) + Str( nNumLin )", {|| Str( Field->nNumSat ) + Str( Field->nNumLin ) }, ) )

      ( cSatCliT )->( ordCondSet("!Deleted() .and. NCTLSTK == 2", {||!Deleted() .and. Field->NCTLSTK == 2 }  ) )
      ( cSatCliT )->( ordCreate( cPath + "SatCliL.Cdx", "cCodCli", "cCodCli", {|| Field->cCodCli }, ) )

      ( cSatCliT )->( ordCondSet("!Deleted() .and. NCTLSTK == 2", {||!Deleted() .and. Field->NCTLSTK == 2 }  ) )
      ( cSatCliT )->( ordCreate( cPath + "SatCliL.Cdx", "cCliArt", "cCodCli + cRef", {|| Field->cCodCli + Field->cRef }, ) )

      ( cSatCliT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cSatCliT )->( ordCreate( cPath + "SatCliL.Cdx", "nPosPrint", "cSerSat + Str( nNumSat ) + cSufSat + Str( nPosPrint )", {|| Field->cSerSat + Str( Field->nNumSat ) + Field->cSufSat + Str( Field->nPosPrint ) } ) )

      ( cSatCliT )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de S.A.T. de clientes" )
   end if

   dbUseArea( .t., cDriver, cPath + "SATCLII.DBF", cCheckArea( "SATCLII", @cSatCliT ), .f. )
   if !( cSatCliT )->( neterr() )
      ( cSatCliT )->( __dbPack() )

      ( cSatCliT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cSatCliT )->( ordCreate( cPath + "SATCLII.CDX", "NNUMSAT", "CSERSAT + STR( NNUMSAT ) + CSUFSAT", {|| Field->CSERSAT + STR(Field->NNUMSAT) + Field->CSUFSAT } ) )

      ( cSatCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( cSatCliT )->( ordCreate( cPath + "SatCliI.Cdx", "iNumSat", "'32' + cSerSat + Str( nNumSat ) + Space( 1 ) + cSufSat", {|| '32' + Field->cSerSat + Str( Field->nNumSat ) + Space( 1 ) + Field->cSufSat } ) )

      ( cSatCliT )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de S.A.T. de clientes" )
   end if

   dbUseArea( .t., cDriver, cPath + "SATCLID.DBF", cCheckArea( "SATCLID", @cSatCliT ), .f. )
   if !( cSatCliT )->( neterr() )
      ( cSatCliT )->( __dbPack() )

      ( cSatCliT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cSatCliT )->( ordCreate( cPath + "SATCLID.CDX", "NNUMSAT", "CSERSAT + STR( NNUMSAT ) + CSUFSAT", {|| Field->CSERSAT + STR(Field->NNUMSAT) + Field->CSUFSAT } ) )

      ( cSatCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( cSatCliT )->( ordCreate( cPath + "SatCliD.Cdx", "iNumSat", "'32' + cSerSat + Str( nNumSat ) + Space( 1 ) + cSufSat", {|| '32' + Field->cSerSat + Str( Field->nNumSat ) + Space( 1 ) + Field->cSufSat } ) )

      ( cSatCliT )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de S.A.T. de clientes" )
   end if

   dbUseArea( .t., cDriver, cPath + "SatCliS.Dbf", cCheckArea( "SatCliS", @cSatCliT ), .f. )

   if !( cSatCliT )->( neterr() )
      ( cSatCliT )->( __dbPack() )

      ( cSatCliT )->( ordCondSet( "!Deleted()", {||!Deleted()}  ) )
      ( cSatCliT )->( ordCreate( cPath + "SatCliS.CDX", "nNumSat", "cSerSat + Str( nNumSat ) + cSufSat + Str( nNumLin )", {|| Field->cSerSat + Str( Field->nNumSat ) + Field->cSufSat + Str( Field->nNumLin ) } ) )

      ( cSatCliT )->( ordCondSet( "!Deleted()", {|| ! !Deleted() } ) )
      ( cSatCliT )->( ordCreate( cPath + "SatCliS.CDX", "cRefSer", "cRef + cAlmLin + cNumSer", {|| Field->cRef + Field->cAlmLin + Field->cNumSer } ) )

      ( cSatCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( cSatCliT )->( ordCreate( cPath + "SatCliS.CDX", "cNumSer", "cNumSer", {|| Field->cNumSer } ) )

      ( cSatCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( cSatCliT )->( ordCreate( cPath + "SatCliS.Cdx", "iNumSat", "'32' + cSerSat + Str( nNumSat ) + Space( 1 ) + cSufSat", {|| '32' + Field->cSerSat + Str( Field->nNumSat ) + Space( 1 ) + Field->cSufSat } ) )

      ( cSatCliT )->( ordCondSet( "!Deleted()", {||!Deleted()}  ) )
      ( cSatCliT )->( ordCreate( cPath + "SatCliS.CDX", "nNumRef", "cSerSat + Str( nNumSat ) + cSufSat + cRef + Str( nNumLin )", {|| Field->cSerSat + Str( Field->nNumSat ) + Field->cSufSat + Field->cRef + + Str( Field->nNumLin ) } ) )

      ( cSatCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( cSatCliT )->( ordCreate( cPath + "SatCliS.CDX", "cRef", "cRef + cNumSer", {|| Field->cRef + Field->cNumSer } ) )

      ( cSatCliT )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de numeros de series de Sataranes de clientes" )
   end if

RETURN NIL

//--------------------------------------------------------------------------//

FUNCTION nTotNSatCli( uDbf )

   local nTotUnd

   DEFAULT uDbf   := D():SatClientesLineas( nView )

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

FUNCTION nTotISatCli( dbfLin, nDec, nRouDec, nVdv, cPorDiv )

   local nCalculo    := 0

   DEFAULT dbfLin    := D():SatClientesLineas( nView )
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

FUNCTION nImpLSatCli( uSatCliT, cSatCliL, nDec, nRou, nVdv, lIva, lDto, lPntVer, lImpTrn, cPouDiv )

   local nCalculo
   local lIvaInc

   DEFAULT nDec      := 0
   DEFAULT nRou      := 0
   DEFAULT nVdv      := 1
   DEFAULT lIva      := .f.
   DEFAULT lDto      := .t.
   DEFAULT lPntVer   := .f.
   DEFAULT lImpTrn   := .f.

   nCalculo          := nTotLSatCli( cSatCliL, nDec, nRou, nVdv, .t., lPntVer, lImpTrn )

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

   if ( cSatCliL )->nIva != 0
      if lIva  // lo quermos con impuestos
         if !lIvaInc
            nCalculo += Round( nCalculo * ( cSatCliL )->nIva / 100, nRou )
         end if
      else     // lo queremos sin impuestos
         if lIvaInc
            nCalculo -= Round( nCalculo / ( 100 / ( cSatCliL )->nIva  + 1 ), nRou )
         end if
      end if
   end if

RETURN ( if( cPouDiv != nil, Trans( nCalculo, cPouDiv ), nCalculo ) )

//----------------------------------------------------------------------------//

FUNCTION nDtoAtpSatCli( uSatCliT, cSatCliL, nDec, nRou, nVdv, lPntVer, lImpTrn )

   local nCalculo    := 0
   local nDtoAtp     := 0

   DEFAULT nDec      := 0
   DEFAULT nRou      := 0
   DEFAULT nVdv      := 1
   DEFAULT lPntVer   := .f.
   DEFAULT lImpTrn   := .f.

   nCalculo          := nTotLSatCli( cSatCliL, nDec, nRou, nVdv, .t., lPntVer, lImpTrn )

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

FUNCTION nComLSatCli( cSatCliT, cSatCliL, nDecOut, nDerOut )

   local nImp        := nImpLSatCli( cSatCliT, cSatCliL, nDecOut, nDerOut )

RETURN ( nImp * ( cSatCliL )->nComAge / 100 )

//--------------------------------------------------------------------------//

FUNCTION dFecSatCli( cSatCli, cSatCliT )

   local dFecSat  := CtoD("")

   IF ( cSatCliT )->( dbSeek( cSatCli ) )
      dFecSat  := ( cSatCliT )->dFecSat
   END IF

RETURN ( dFecSat )

//---------------------------------------------------------------------------//

FUNCTION lEstSatCli( cSatCli, cSatCliT )

   local lEstSat  := .f.

   IF ( cSatCliT )->( dbSeek( cSatCli ) )
      lEstSat     := ( cSatCliT )->lEstado
   END IF

RETURN ( lEstSat )

//---------------------------------------------------------------------------//

FUNCTION cNbrSatCli( cSatCli, cSatCliT )

   local cNomCli  := ""

   IF ( cSatCliT )->( dbSeek( cSatCli ) )
      cNomCli  := ( cSatCliT )->CNOMCLI
   END IF

RETURN ( cNomCli )

//----------------------------------------------------------------------------//
//
// Devuelve el total de la compra en Sataranes de clientes de un articulo
//

function nTotDSatCli( cCodArt, cSatCliL )

   local nTotVta  := 0
   local nRecno   := ( cSatCliL )->( Recno() )

   if ( cSatCliL )->( dbSeek( cCodArt ) )

      while ( cSatCliL )->CREF == cCodArt .and. !( cSatCliL )->( eof() )

         If !( cSatCliL )->LTOTLIN
            nTotVta += nTotNSatCli( cSatCliL )
         end if

         ( cSatCliL )->( dbSkip() )

      end while

   end if

   ( cSatCliL )->( dbGoTo( nRecno ) )

return ( nTotVta )

//---------------------------------------------------------------------------//

function nVtaSatCli( cCodCli, dDesde, dHasta, cSatCliT, cSatCliL, dbfIva, dbfDiv )

   local nCon     := 0
   local nRec     := ( cSatCliT )->( Recno() )

   /*
   Facturas a Clientes -------------------------------------------------------
   */

   if ( cSatCliT )->( dbSeek( cCodCli ) )

      while ( cSatCliT )->cCodCli == cCodCli .and. !( cSatCliT )->( Eof() )

         if ( dDesde == nil .or. ( cSatCliT )->dFecSat >= dDesde )    .and.;
            ( dHasta == nil .or. ( cSatCliT )->dFecSat <= dHasta )

            nCon  += nTotSatCli( ( cSatCliT )->cSerSat + Str( ( cSatCliT )->nNumSat ) + ( cSatCliT )->cSufSat, cSatCliT, cSatCliL, dbfIva, dbfDiv, nil, nil, cDivEmp(), .f. )

         end if

         ( cSatCliT )->( dbSkip() )

      end while

   end if

   ( cSatCliT )->( dbGoTo( nRec ) )

return nCon

//----------------------------------------------------------------------------//

function aItmSatCli()

   local aItmSatCli :=  {}

   aAdd( aItmSatCli, { "CSERSAT",   "C",  1,  0, "Serie de S.A.T." ,                            "Serie",                   "", "( cDbf )", nil } )
   aAdd( aItmSatCli, { "NNUMSAT",   "N",  9,  0, "Número de S.A.T." ,                           "Numero",                  "", "( cDbf )", nil } )
   aAdd( aItmSatCli, { "CSUFSAT",   "C",  2,  0, "Sufijo de S.A.T." ,                           "Sufijo",                  "", "( cDbf )", {|| RetSufEmp() } } )
   aAdd( aItmSatCli, { "CTURSAT",   "C",  6,  0, "Sesión del S.A.T.",                           "Turno",                   "", "( cDbf )", {|| cCurSesion( nil, .f.) } } )
   aAdd( aItmSatCli, { "DFECSAT",   "D",  8,  0, "Fecha del S.A.T.",                            "Fecha",                   "", "( cDbf )", {|| GetSysDate() } } )
   aAdd( aItmSatCli, { "CCODCLI",   "C", 12,  0, "Código del cliente",                          "Cliente",                 "", "( cDbf )", nil } )
   aAdd( aItmSatCli, { "CNOMCLI",   "C", 80,  0, "Nombre del cliente",                          "NombreCliente",           "", "( cDbf )", nil } )
   aAdd( aItmSatCli, { "CDIRCLI",   "C",200,  0, "Domicilio del cliente",                       "DomicilioCliente",        "", "( cDbf )", nil } )
   aAdd( aItmSatCli, { "CPOBCLI",   "C",200,  0, "Población del cliente",                       "PoblacionCliente",        "", "( cDbf )", nil } )
   aAdd( aItmSatCli, { "CPRVCLI",   "C",100,  0, "Provincia del cliente",                       "ProvinciaCliente",        "", "( cDbf )", nil } )
   aAdd( aItmSatCli, { "CPOSCLI",   "C", 15,  0, "Código postal del cliente",                   "CodigoPostalCliente",     "", "( cDbf )", nil } )
   aAdd( aItmSatCli, { "CDNICLI",   "C", 30,  0, "DNI del cliente",                             "DniCliente",              "", "( cDbf )", nil } )
   aAdd( aItmSatCli, { "LMODCLI",   "L",  1,  0, "Modificar datos del cliente",                 "ModificarDatosCliente",   "", "( cDbf )", nil } )
   aAdd( aItmSatCli, { "CCODAGE",   "C",  3,  0, "Código del agente",                           "Agente",                  "", "( cDbf )", nil } )
   aAdd( aItmSatCli, { "CCODOBR",   "C", 10,  0, "Código de dirección",                         "Direccion",               "", "( cDbf )", nil } )
   aAdd( aItmSatCli, { "CCODTAR",   "C",  5,  0, "Código de tarifa",                            "Tarifa",                  "", "( cDbf )", nil } )
   aAdd( aItmSatCli, { "CCODALM",   "C", 16,  0, "Código del almacen",                          "Almacen",                 "", "( cDbf )", {|| oUser():cAlmacen() } } )
   aAdd( aItmSatCli, { "CCODCAJ",   "C",  3,  0, "Código de caja",                              "Caja",                    "", "( cDbf )", {|| oUser():cCaja() } } )
   aAdd( aItmSatCli, { "CCODPGO",   "C",  2,  0, "Código de pago",                              "Pago",                    "", "( cDbf )", {|| cDefFpg() } } )
   aAdd( aItmSatCli, { "CCODRUT",   "C",  4,  0, "Código de la ruta",                           "Ruta",                    "", "( cDbf )", nil } )
   aAdd( aItmSatCli, { "DFECENT",   "D",  8,  0, "Fecha de entrada",                            "FechaEntrada",            "", "( cDbf )", nil } )
   aAdd( aItmSatCli, { "lEstado",   "L",  1,  0, "Estado del S.A.T.",                           "Estado",                  "", "( cDbf )", {|| 1 } } )
   aAdd( aItmSatCli, { "CSUSAT",    "C",100,  0, "",                                            "",                        "", "( cDbf )", nil } )
   aAdd( aItmSatCli, { "CCONDENT",  "C",100,  0, "",                                            "",                        "", "( cDbf )", nil } )
   aAdd( aItmSatCli, { "MCOMENT",   "M", 10,  0, "Comentarios",                                 "Comentarios",             "", "( cDbf )", nil } )
   aAdd( aItmSatCli, { "MOBSERV",   "M", 10,  0, "Averia",                                      "Averia",                  "", "( cDbf )", nil } )
   aAdd( aItmSatCli, { "LMAYOR",    "L",  1,  0, "" ,                                           "",                        "", "( cDbf )", nil } )
   aAdd( aItmSatCli, { "NTARIFA",   "N",  1,  0, "Tarifa de precio aplicada" ,                  "NumeroTarifa",            "", "( cDbf )", nil } )
   aAdd( aItmSatCli, { "CDTOESP",   "C", 50,  0, "Descripción del descuento",                   "DescripcionDescuento1",   "", "( cDbf )", nil } )
   aAdd( aItmSatCli, { "NDTOESP",   "N",  5,  2, "Porcentaje de descuento",                     "PorcentajeDescuento1",    "", "( cDbf )", nil } )
   aAdd( aItmSatCli, { "CDPP",      "C", 50,  0, "Descripción del descuento por pronto pago",   "DescripcionDescuento2",   "", "( cDbf )", nil } )
   aAdd( aItmSatCli, { "NDPP",      "N",  5,  2, "Pct. de dto. por pronto pago",                "PorcentajeDescuento2",    "", "( cDbf )", nil } )
   aAdd( aItmSatCli, { "CDTOUNO",   "C", 50,  0, "Desc. del primer descuento pers.",            "DescripcionDescuento3",   "", "( cDbf )", nil } )
   aAdd( aItmSatCli, { "NDTOUNO",   "N",  5,  2, "Pct. del primer descuento pers.",             "PorcentajeDescuento3",    "", "( cDbf )", nil } )
   aAdd( aItmSatCli, { "CDTODOS",   "C", 50,  0, "Desc. del segundo descuento pers.",           "DescripcionDescuento4",   "", "( cDbf )", nil } )
   aAdd( aItmSatCli, { "NDTODOS",   "N",  5,  2, "Pct. del segundo descuento pers.",            "PorcentajeDescuento4",    "", "( cDbf )", nil } )
   aAdd( aItmSatCli, { "NDTOCNT",   "N",  5,  2, "Pct. de dto. por pago contado",               "",                        "", "( cDbf )", nil } )
   aAdd( aItmSatCli, { "NDTORAP",   "N",  5,  2, "Pct. de dto. por rappel",                     "",                        "", "( cDbf )", nil } )
   aAdd( aItmSatCli, { "NDTOPUB",   "N",  5,  2, "Pct. de dto. por publicidad",                 "",                        "", "( cDbf )", nil } )
   aAdd( aItmSatCli, { "NDTOPGO",   "N",  5,  2, "Pct. de dto. por pago centralizado",          "",                        "", "( cDbf )", nil } )
   aAdd( aItmSatCli, { "NDTOPTF",   "N",  7,  2, "",                                            "",                        "", "( cDbf )", nil } )
   aAdd( aItmSatCli, { "LRECARGO",  "L",  1,  0, "Aplicar recargo de equivalencia",             "RecargoEquivalencia",     "", "( cDbf )", nil } )
   aAdd( aItmSatCli, { "NPCTCOMAGE","N",  5,  2, "Pct. de comisión del agente",                 "ComisionAgente",          "", "( cDbf )", nil } )
   aAdd( aItmSatCli, { "NBULTOS",   "N",  5,  0, "Numero de bultos",                            "Bultos",                  "", "( cDbf )", nil } )
   aAdd( aItmSatCli, { "CNUMSat",   "C", 10,  0, "" ,                                           "",                        "", "( cDbf )", nil } )
   aAdd( aItmSatCli, { "CDIVSAT",   "C",  3,  0, "Código de divisa",                            "Divisa",                  "", "( cDbf )", {|| cDivEmp() } } )
   aAdd( aItmSatCli, { "NVDVSAT",   "N", 10,  4, "Valor del cambio de la divisa",               "ValorDivisa",             "", "( cDbf )", {|| nChgDiv() } } )
   aAdd( aItmSatCli, { "LSNDDOC",   "L",  1,  0, "Valor lógico documento enviado",              "Envio",                   "", "( cDbf )", {|| .t. } } )
   aAdd( aItmSatCli, { "CRETPOR",   "C",150,  0, "Retirado por" ,                               "Retirado",                "", "( cDbf )", nil } )
   aAdd( aItmSatCli, { "CRETMAT",   "C",150,  0, "Matrícula" ,                                  "Matricula",               "", "( cDbf )", nil } )
   aAdd( aItmSatCli, { "NREGIVA",   "N",  1,  0, "Regimen de " + cImp() ,                       "TipoImpuesto",            "", "( cDbf )", nil } )
   aAdd( aItmSatCli, { "LIVAINC",   "L",  1,  0, "Lógico de " + cImp() + " incluido",           "ImpuestosIncluidos",      "", "( cDbf )", {|| uFieldEmpresa( "lIvaInc" ) } } )
   aAdd( aItmSatCli, { "NIVAMAN",   "N",  6,  2, "Porcentaje de " + cImp() + " del gasto",      "ImpuestoGastos",          "", "( cDbf )", {|| nIva( nil, cDefIva() ) } } )
   aAdd( aItmSatCli, { "NMANOBR",   "N", 16,  6, "Gastos" ,                                     "Gastos",                  "", "( cDbf )", nil } )                        
   aAdd( aItmSatCli, { "cCodTrn",   "C",  9,  0, "Código de transportista" ,                    "Transportista",           "", "( cDbf )", nil } )
   aAdd( aItmSatCli, { "nKgsTrn"   ,"N", 16,  6, "TARA del transportista" ,                     "TaraTransportista",       "", "( cDbf )", nil } )
   aAdd( aItmSatCli, { "lCloSat",   "L",  1,  0, "" ,                                           "DocumentoCerrado",        "", "( cDbf )", nil } )
   aAdd( aItmSatCli, { "cCodUsr",   "C",  3,  0, "Código de usuario",                           "Usuario",                 "", "( cDbf )", {|| Auth():Codigo() } } )
   aAdd( aItmSatCli, { "dFecCre",   "D",  8,  0, "Fecha de creación del documento",             "FechaCreacion",           "", "( cDbf )", nil } )
   aAdd( aItmSatCli, { "cTimCre",   "C",  5,  0, "Hora de creación del documento",              "HoraCreacion",            "", "( cDbf )", nil } )
   aAdd( aItmSatCli, { "cSituac",   "C", 20,  0, "Situación del documento",                     "Situacion",               "", "( cDbf )", nil } )
   aAdd( aItmSatCli, { "nDiaVal",   "N",  3,  0, "Dias de validez",                             "DiasValidez",             "", "( cDbf )", nil } )
   aAdd( aItmSatCli, { "cCodGrp",   "C",  4,  0, "Código de grupo de cliente",                  "GrupoCliente",            "", "( cDbf )", nil } )                  
   aAdd( aItmSatCli, { "lImprimido","L",  1,  0, "Lógico de imprimido del documento",           "Imprimido",               "", "( cDbf )", nil } )      
   aAdd( aItmSatCli, { "dFecImp",   "D",  8,  0, "Última fecha de impresión del documento",     "FechaImpresion",          "", "( cDbf )", nil } )      
   aAdd( aItmSatCli, { "cHorImp",   "C",  5,  0, "Hora de la última impresión del documento",   "HoraImpresion",           "", "( cDbf )", nil } )      
   aAdd( aItmSatCli, { "cCodDlg",   "C",  2,  0, "Código delegación" ,                          "Delegacion",              "", "( cDbf )", {|| oUser():cDelegacion() } } )      
   aAdd( aItmSatCli, { "nDtoAtp",   "N",  6,  2, "Porcentaje de descuento atípico",             "DescuentoAtipico",        "", "( cDbf )", nil } )      
   aAdd( aItmSatCli, { "nSbrAtp",   "N",  1,  0, "Lugar donde aplicar dto atípico",             "LugarAplicarDescuentoAtipico","", "( cDbf )", nil } )      
   aAdd( aItmSatCli, { "dFecEntr",  "D",  8,  0, "Fecha de entrada de alquiler",                "EntradaAlquiler",         "", "( cDbf )", nil } )      
   aAdd( aItmSatCli, { "dFecSal",   "D",  8,  0, "Fecha de salidad de alquiler",                "SalidaAlquiler",          "", "( cDbf )", nil } )      
   aAdd( aItmSatCli, { "lAlquiler", "L",  1,  0, "Lógico de alquiler",                          "Alquiler",                "", "( cDbf )", nil } )      
   aAdd( aItmSatCli, { "cManObr",   "C",250,  0, "Literal de gastos" ,                          "LiteralGastos",           "", "( cDbf )", {|| padr( getConfigTraslation( "Gastos" ), 250 ) } } )      
   aAdd( aItmSatCli, { "cNumTik",   "C", 13,  0, "Número del ticket generado" ,                 "NumeroTicket",            "", "( cDbf )", nil } )      
   aAdd( aItmSatCli, { "CTLFCLI",   "C", 20,  0, "Teléfono del cliente" ,                       "TelefonoCliente",         "", "( cDbf )", nil } )      
   aAdd( aItmSatCli, { "nTotNet",   "N", 16,  6, "Total neto" ,                                 "TotalNeto",               "", "( cDbf )", nil } )      
   aAdd( aItmSatCli, { "nTotIva",   "N", 16,  6, "Total " + cImp() ,                            "TotalImpuesto",           "", "( cDbf )", nil } )      
   aAdd( aItmSatCli, { "nTotReq",   "N", 16,  6, "Total recargo" ,                              "TotalRecargo",            "", "( cDbf )", nil } )      
   aAdd( aItmSatCli, { "nTotSat",   "N", 16,  6, "Total S.A.T." ,                               "TotalDocumento",          "", "( cDbf )", nil } )      
   aAdd( aItmSatCli, { "lOperPV",   "L",  1,  0, "Lógico para operar con punto verde" ,         "OperarPuntoVerde",        "", "( cDbf )", {|| .f. } } )      
   aAdd( aItmSatCli, { "cNumAlb",   "C", 12,  0, "Número del albarán donde se agrupa" ,         "",                        "", "( cDbf )", nil } )      
   aAdd( aItmSatCli, { "lGarantia", "L",  1,  0, "Lógico de reparación en garantía" ,           "ReparacionGarantia",      "", "( cDbf )", nil } )            
   aAdd( aItmSatCli, { "cCodOpe",   "C",  5,  0, "Código operario" ,                            "Operario",                "", "( cDbf )", nil } )                  
   aAdd( aItmSatCli, { "cCodCat",   "C", 10,  0, "Código categoría" ,                           "Categoria",               "", "( cDbf )", nil } )                  
   aAdd( aItmSatCli, { "cHorIni",   "C",  5,  0, "Hora de inicio" ,                             "HoraInicio",              "", "( cDbf )", nil } )                  
   aAdd( aItmSatCli, { "cHorFin",   "C",  5,  0, "Hora de fin" ,                                "HoraFin",                 "", "( cDbf )", nil } )                  
   aAdd( aItmSatCli, { "cCodEst",   "C",  3,  0, "Código estado" ,                              "Estado",                  "", "( cDbf )", nil } )                  
   aAdd( aItmSatCli, { "mFirma",    "M", 10,  0, "Firma" ,                                      "Firma",                   "", "( cDbf )", nil } )                  
   aAdd( aItmSatCli, { "cCtrCoste", "C",  9,  0, "Código del centro de coste" ,                 "CentroCoste",             "", "( cDbf )", nil } )

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

   aAdd( aColSatCli, { "CSERSAT", "C",    1,  0, "Serie de S.A.T." ,                                  "Serie",                   "", "( cDbfCol )", nil } )
   aAdd( aColSatCli, { "NNUMSAT", "N",    9,  0, "Numero de S.A.T." ,                                 "Numero",                  "", "( cDbfCol )", nil } )
   aAdd( aColSatCli, { "CSUFSAT", "C",    2,  0, "Sufijo de S.A.T." ,                                 "Sufijo",                  "", "( cDbfCol )", nil } )
   aAdd( aColSatCli, { "CREF",    "C",   18,  0, "Referencia del artículo" ,                          "Articulo",                "", "( cDbfCol )", nil } )
   aAdd( aColSatCli, { "CDETALLE","C",  250,  0, "Descripción de artículo" ,                          "DescripcionArticulo",     "", "( cDbfCol )", nil } )
   aAdd( aColSatCli, { "NIVA"    ,"N",    6,  2, "Porcentaje de " + cImp() ,                          "PorcentajeImpuesto",      "", "( cDbfCol )", nil } )
   aAdd( aColSatCli, { "NCANSAT" ,"N",   16,  6, "Cantidad pedida" ,                                  "Cajas",                   "", "( cDbfCol )", nil } )
   aAdd( aColSatCli, { "NUNICAJA","N",   16,  6, "Unidades por caja" ,                                "Unidades",                "", "( cDbfCol )", nil } )
   aAdd( aColSatCli, { "LCONTROL","L",    1,  0, "" ,                                                 "",                        "", "( cDbfCol )", nil } )
   aAdd( aColSatCli, { "NUNDKIT", "N",   16,  6, "Unidades tipo kit" ,                                "UnidadesKit",             "", "( cDbfCol )", nil } )
   aAdd( aColSatCli, { "NPreDiv" ,"N",   16,  6, "Importe del artículo" ,                             "PrecioVenta",             "", "( cDbfCol )", nil } )
   aAdd( aColSatCli, { "NPNTVER", "N",   16,  6, "Importe punto verde" ,                              "PuntoVerde",              "", "( cDbfCol )", nil } )
   aAdd( aColSatCli, { "nImpTrn", "N",   16,  6, "Importe del transporte",                            "Portes",                  "", "( cDbfCol )", nil } )
   aAdd( aColSatCli, { "NDTO",    "N",    6,  2, "Descuento del artículo" ,                           "",                        "", "( cDbfCol )", nil } )
   aAdd( aColSatCli, { "NDTOPRM", "N",    6,  2, "Descuento de la promoción" ,                        "",                        "", "( cDbfCol )", nil } )
   aAdd( aColSatCli, { "NCOMAGE", "N",    6,  2, "Comisión del agente" ,                              "",                        "", "( cDbfCol )", nil } )
   aAdd( aColSatCli, { "NCANENT", "N",   16,  6, "Unidades de entrada" ,                              "",                        "", "( cDbfCol )", nil } )
   aAdd( aColSatCli, { "CUNIDAD", "C",    2,  0, "Unidad de venta" ,                                  "",                        "", "( cDbfCol )", nil } )
   aAdd( aColSatCli, { "NPESOKG", "N",   16,  6, "Peso del artículo" ,                                "",                        "", "( cDbfCol )", nil } )
   aAdd( aColSatCli, { "cPesoKg", "C",    2,  0, "Unidad de peso del artículo" ,                      "",                        "", "( cDbfCol )", nil } )
   aAdd( aColSatCli, { "DFECHA",  "D",    8,  0, "Fecha de entrega",                                  "",                        "", "( cDbfCol )", nil } )
   aAdd( aColSatCli, { "MLNGDES", "M",   10,  0, "Descripción de artículo sin codificar",             "",                        "", "( cDbfCol )", nil } )
   aAdd( aColSatCli, { "LTOTLIN", "L",    1,  0, "Linea de total" ,                                   "",                        "", "( cDbfCol )", nil } )
   aAdd( aColSatCli, { "LIMPLIN", "L",    1,  0, "Linea no imprimible" ,                              "",                        "", "( cDbfCol )", nil } )
   aAdd( aColSatCli, { "CCODPR1", "C",   20,  0, "Código de la primera propiedad",                    "CodigoPropiedad1",        "", "( cDbfCol )", nil } )
   aAdd( aColSatCli, { "CCODPR2", "C",   20,  0, "Código de la segunda propiedad",                    "CodigoPropiedad2",        "", "( cDbfCol )", nil } )
   aAdd( aColSatCli, { "CVALPR1", "C",   20,  0, "Valor de la primera propiedad",                     "ValorPropiedad1",         "", "( cDbfCol )", nil } )
   aAdd( aColSatCli, { "CVALPR2", "C",   20,  0, "Valor de la segunda propiedad",                     "ValorPropiedad2",         "", "( cDbfCol )", nil } )
   aAdd( aColSatCli, { "NFACCNV", "N",   16,  6, "Factor de conversión de la compra",                 "",                        "", "( cDbfCol )", nil } )
   aAdd( aColSatCli, { "NDTODIV", "N",   16,  6, "Descuento lineal de la compra",                     "",                        "", "( cDbfCol )", nil } )
   aAdd( aColSatCli, { "CTIPMOV", "C",    2,  0, "Tipo de movimiento",                                "",                        "", "( cDbfCol )", nil } )
   aAdd( aColSatCli, { "NNUMLIN", "N",    4,  0, "Numero de la línea",                                "",                        "", "( cDbfCol )", nil } )
   aAdd( aColSatCli, { "NCTLSTK", "N",    1,  0, "Tipo de stock de la línea",                         "",                        "", "( cDbfCol )", nil } )
   aAdd( aColSatCli, { "NCOSDIV", "N",   16,  6, "Costo del artículo" ,                               "",                        "", "( cDbfCol )", nil } )
   aAdd( aColSatCli, { "NPVSATC", "N",   16,  6, "Precio de venta recomendado" ,                      "",                        "", "( cDbfCol )", nil } )
   aAdd( aColSatCli, { "CALMLIN", "C",   16,  0, "Código de almacén" ,                                "",                        "", "( cDbfCol )", nil } )
   aAdd( aColSatCli, { "LIVALIN", "L",    1,  0, "Línea con " + cImp() + " incluido",                 "LineaImpuestoIncluido",   "", "( cDbfCol )", nil } )
   aAdd( aColSatCli, { "CCODIMP", "C",    3,  0, "Código del impuesto especial",                      "",                        "", "( cDbfCol )", nil } )
   aAdd( aColSatCli, { "NVALIMP", "N",   16,  6, "Importe de impuesto",                               "",                        "", "( cDbfCol )", nil } )
   aAdd( aColSatCli, { "LLOTE",   "L",    1,  0, "",                                                  "",                        "", "( cDbfCol )", nil } )
   aAdd( aColSatCli, { "NLOTE",   "N",    9,  0, "",                                                  "",                        "", "( cDbfCol )", nil } )
   aAdd( aColSatCli, { "cLote",   "C",   14,  0, "Número de Lote",                                    "",                        "", "( cDbfCol )", nil } )
   aAdd( aColSatCli, { "LKITART", "L",    1,  0, "Línea con escandallo",                              "",                        "", "( cDbfCol )", nil } )
   aAdd( aColSatCli, { "LKITCHL", "L",    1,  0, "Línea pertenciente a escandallo",                   "",                        "", "( cDbfCol )", nil } )
   aAdd( aColSatCli, { "LKITPRC", "L",    1,  0, "",                                                  "",                        "", "( cDbfCol )", nil } )
   aAdd( aColSatCli, { "NMESGRT", "N",    2,  0, "Meses de garantía",                                 "",                        "", "( cDbfCol )", nil } )
   aAdd( aColSatCli, { "LMSGVTA", "L",    1,  0, "Avisar en venta sin stocks",                        "",                        "", "( cDbfCol )", nil } )
   aAdd( aColSatCli, { "LNOTVTA", "L",    1,  0, "No permitir venta sin stocks",                      "",                        "", "( cDbfCol )", nil } )
   aAdd( aColSatCli, { "MNUMSER", "M",   10,  0, "" ,                                                 "",                        "", "( cDbfCol )", nil } )
   aAdd( aColSatCli, { "CCODTIP", "C",    4,  0, "Código del tipo de artículo",                       "Tipo",                    "", "( cDbfCol )", nil } )
   aAdd( aColSatCli, { "CCODFAM", "C",   16,  0, "Código de familia",                                 "Familia",                 "", "( cDbfCol )", nil } )
   aAdd( aColSatCli, { "CGRPFAM", "C",    3,  0, "Código del grupo de familia",                       "",                        "", "( cDbfCol )", nil } )
   aAdd( aColSatCli, { "NREQ",    "N",    6,  2, "Recargo de equivalencia",                           "",                        "", "( cDbfCol )", nil } )
   aAdd( aColSatCli, { "MOBSLIN", "M",   10,  0, "Observacion de línea",                              "",                        "", "( cDbfCol )", nil } )
   aAdd( aColSatCli, { "CCODPRV", "C",   12,  0, "Código del proveedor",                              "",                        "", "( cDbfCol )", nil } )
   aAdd( aColSatCli, { "CNOMPRV", "C",   30,  0, "Nombre del proveedor",                              "",                        "", "( cDbfCol )", nil } )
   aAdd( aColSatCli, { "CIMAGEN", "C",  250,  0, "Fichero de imagen" ,                                "",                        "", "( cDbfCol )", nil } )
   aAdd( aColSatCli, { "NPUNTOS", "N",   15,  6, "Puntos del artículo",                               "",                        "", "( cDbfCol )", nil } )
   aAdd( aColSatCli, { "NVALPNT", "N",   16,  6, "Valor del punto",                                   "",                        "", "( cDbfCol )", nil } )
   aAdd( aColSatCli, { "NDTOPNT", "N",    5,  2, "Descuento puntos",                                  "",                        "", "( cDbfCol )", nil } )
   aAdd( aColSatCli, { "NINCPNT", "N",    5,  2, "Incremento porcentual",                             "",                        "", "( cDbfCol )", nil } )
   aAdd( aColSatCli, { "CREFPRV", "C",   18,  0, "Referencia artículo proveedor",                     "",                        "", "( cDbfCol )", nil } )
   aAdd( aColSatCli, { "NVOLUMEN","N",   16,  6, "Volumen del artículo" ,                             "",                        "", "( cDbfCol )", nil } )
   aAdd( aColSatCli, { "CVOLUMEN","C",    2,  0, "Unidad del volumen" ,                               "",                        "", "( cDbfCol )", nil } )
   aAdd( aColSatCli, { "DFECENT" ,"D",    8,  0, "Fecha de entrada del alquiler",                     "",                        "", "( cDbfCol )", nil } )
   aAdd( aColSatCli, { "DFECSAL" ,"D",    8,  0, "Fecha de salida del alquiler",                      "",                        "", "( cDbfCol )", nil } )
   aAdd( aColSatCli, { "nPreAlq" ,"N",   16,  6, "Precio de alquiler",                                "",                        "", "( cDbfCol )", nil } )
   aAdd( aColSatCli, { "lAlquiler","L",   1,  0, "Lógico de alquiler",                                "",                        "", "( cDbfCol )", nil } )
   aAdd( aColSatCli, { "nNumMed"  ,"N",   1,  0, "Número de mediciones",                              "",                        "", "( cDbfCol )", nil } )
   aAdd( aColSatCli, { "nMedUno"  ,"N",  16,  6, "Primera unidad de medición",                        "",                        "", "( cDbfCol )", nil } )
   aAdd( aColSatCli, { "nMedDos"  ,"N",  16,  6, "Segunda unidad de medición",                        "",                        "", "( cDbfCol )", nil } )
   aAdd( aColSatCli, { "nMedTre"  ,"N",  16,  6, "Tercera unidad de medición",                        "",                        "", "( cDbfCol )", nil } )
   aAdd( aColSatCli, { "nTarLin"  ,"N",   1,  0, "Tarifa de precio aplicada" ,                        "NumeroTarifa",            "", "( cDbfCol )", nil } )
   aAdd( aColSatCli, { "lImpFra"  ,"L",   1,  0, "Lógico de imprimir frase publicitaria",             "",                        "", "( cDbfCol )", nil } )
   aAdd( aColSatCli, { "cCodFra"  ,"C",   3,  0, "Código de frase publicitaria",                      "",                        "", "( cDbfCol )", nil } )
   aAdd( aColSatCli, { "cTxtFra"  ,"C", 250,  0, "",                                                  "",                        "", "( cDbfCol )", nil } )
   aAdd( aColSatCli, { "Descrip"  ,"M",  10,  0, "Descripción larga",                                 "",                        "", "( cDbfCol )", nil } )
   aAdd( aColSatCli, { "lLinOfe"  ,"L",   1,  0, "Línea con oferta",                                  "",                        "", "( cDbfCol )", nil } )
   aAdd( aColSatCli, { "lVolImp"  ,"L",   1,  0, "Lógico aplicar volumen con impuestos especiales",   "",                        "", "( cDbfCol )", nil } )
   aAdd( aColSatCli, { "nBultos"  ,"N",  16,  6, "Número de bultos en líneas",                        "",                        "", "( cDbfCol )", nil } )
   aAdd( aColSatCli, { "cFormato" ,"C", 100,  0, "Formato de venta",                                  "",                        "", "( cDbfCol )", nil } )
   aAdd( aColSatCli, { "cCodCli"  ,"C",  12,  0, "Código del cliente",                                "",                        "", "( cDbfCol )", nil } )
   aAdd( aColSatCli, { "dFecSat"  ,"D",   8,  0, "Fecha del SAT",                                     "",                        "", "( cDbfCol )", nil } )
   aAdd( aColSatCli, { "NCNTACT"  ,"N",  15,  6, "Contador actual",                                   "",                        "", "( cDbfCol )", nil } )
   aAdd( aColSatCli, { "CDESUBI"  ,"C", 200,  0, "Descripción de la ubicación",                       "",                        "", "( cDbfCol )", nil } )
   aAdd( aColSatCli, { "lLabel"   ,"L",   1,  0, "Lógico para marca de etiqueta",                     "",                        "", "( cDbfCol )", nil } )
   aAdd( aColSatCli, { "nLabel"   ,"N",   6,  0, "Unidades de etiquetas a imprimir",                  "",                        "", "( cDbfCol )", nil } )
   aAdd( aColSatCli, { "cObrLin"  ,"C",  10,  0, "Dirección de la linea",                             "Direccion",               "", "( cDbfCol )", nil } )
   aAdd( aColSatCli, { "cRefAux"  ,"C",  18,  0, "Referencia auxiliar",                               "",                        "", "( cDbfCol )" } )
   aAdd( aColSatCli, { "cRefAux2" ,"C",  18,  0, "Segunda referencia auxiliar",                       "",                        "", "( cDbfCol )" } )
   aAdd( aColSatCli, { "nPosPrint","N",   4,  0, "Posición de impresión",                             "",                        "", "( cDbfCol )", nil } )
   aAdd( aColSatCli, { "cCtrCoste","C",   9,  0, "Código del centro de coste",                        "",                        "", "( cDbfCol )", nil } )
   aAdd( aColSatCli, { "cTipCtr",  "C",  20,  0, "Tipo tercero centro de coste",                      "",                        "", "( cDbfCol )", nil } )
   aAdd( aColSatCli, { "cTerCtr",  "C",  20,  0, "Tercero centro de coste",                           "",                        "", "( cDbfCol )", nil } )
   aAdd( aColSatCli, { "id_tipo_v","N",  16,  0, "Identificador tipo de venta",                       "IdentificadorTipoVenta",  "", "( cDbfCol )", nil } )
   aAdd( aColSatCli, { "nRegIva",  "N",   1,  0, "Régimen de " + cImp(),                              "TipoImpuesto",            "", "( cDbfCol )", nil } )
  
return ( aColSatCli )

//---------------------------------------------------------------------------//

function aCocSatCli()

   local aCocSatCli :=  {}

   aAdd( aCocSatCli, { "Descrip( cDbfCol )",                                         "C", 50, 0, "Detalle del artículo",      "",            "Descripción", "" } )
   aAdd( aCocSatCli, { "nTotNSatCli( cDbfCol )",                                     "N", 16, 6, "Total articulos",           "MasUnd()",    "Unidades",    "" } )
   aAdd( aCocSatCli, { "nTotUSatCli( cDbfCol, nDouDivSat, nVdvDivSat )",             "N", 16, 6, "Precio unitario",           "cPouDivSat",  "Precio",      "" } )
   aAdd( aCocSatCli, { "nTotLSatCli( cDbfCol, nDouDivSat, nRouDivSat, nVdvDivSat )", "N", 16, 6, "Total línea de S.A.T.",     "cPorDivSat",  "Total",       "" } )

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
   aAdd( aColSatCli,  { "cAlmLin",     "C", 16,   0, "Almacen del artículo",             "",                  "", "( cDbfCol )" } )
   aAdd( aColSatCli,  { "cNumSer",     "C", 30,   0, "Número de serie",                  "",                  "", "( cDbfCol )" } )

return ( aColSatCli )

//---------------------------------------------------------------------------//

Function SynSatCli( cPath )

   local oError
   local oBlock
   local nOrdAnt
   local aTotSat
   local cSatCliL
   local cSatCliT
   local dbfArticulo

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   USE ( cPatEmp() + "SATCLIT.DBF" )   NEW VIA ( cDriver() ) ALIAS ( cCheckArea( "SATCLIT", @cSatCliT ) ) EXCLUSIVE
   SET ADSINDEX TO ( cPatEmp() + "SATCLIT.CDX" ) ADDITIVE

   USE ( cPatEmp() + "SATCLIL.DBF" )   NEW VIA ( cDriver() ) ALIAS ( cCheckArea( "SATCLIL", @cSatCliL ) ) EXCLUSIVE
   SET ADSINDEX TO ( cPatEmp() + "SATCLIL.CDX" ) ADDITIVE

   USE ( cPatEmp() + "SATCLII.DBF" )   NEW VIA ( cDriver() ) ALIAS ( cCheckArea( "SATCLII", @dbfSatCliI ) ) EXCLUSIVE
   SET ADSINDEX TO ( cPatEmp() + "SATCLII.CDX" ) ADDITIVE

   USE ( cPatEmp() + "SATCLIS.DBF" )   NEW VIA ( cDriver() ) ALIAS ( cCheckArea( "SATCLIS", @dbfSatCliS ) ) EXCLUSIVE
   SET ADSINDEX TO ( cPatEmp() + "SATCLIS.CDX" ) ADDITIVE

   USE ( cPatEmp() + "CLIENT.DBF" )   NEW VIA ( cDriver() ) ALIAS ( cCheckArea( "CLIENT", @dbfClient ) ) SHARED
   SET ADSINDEX TO ( cPatEmp() + "CLIENT.CDX" ) ADDITIVE

   USE ( cPatArt() + "ARTICULO.DBF" )  NEW VIA ( cDriver() ) ALIAS ( cCheckArea( "ARTICULO", @dbfArticulo ) ) SHARED
   SET ADSINDEX TO ( cPatArt() + "ARTICULO.CDX" ) ADDITIVE

   USE ( cPatArt() + "FAMILIAS.DBF" )  NEW VIA ( cDriver() ) ALIAS ( cCheckArea( "FAMILIAS", @dbfFamilia ) ) SHARED
   SET ADSINDEX TO ( cPatArt() + "FAMILIAS.CDX" ) ADDITIVE

   USE ( cPatEmp() + "FPAGO.DBF" )     NEW VIA ( cDriver() ) ALIAS ( cCheckArea( "FPAGO", @dbfFPago ) ) SHARED
   SET ADSINDEX TO ( cPatEmp() + "FPAGO.CDX" ) ADDITIVE

   USE ( cPatDat() + "TIVA.DBF" )      NEW VIA ( cDriver() ) ALIAS ( cCheckArea( "TIVA", @dbfIva ) ) SHARED
   SET ADSINDEX TO ( cPatDat() + "TIVA.CDX" ) ADDITIVE

   USE ( cPatDat() + "DIVISAS.DBF" )   NEW VIA ( cDriver() ) ALIAS ( cCheckArea( "DIVISAS", @dbfDiv ) ) SHARED
   SET ADSINDEX TO ( cPatDat() + "DIVISAS.CDX" ) ADDITIVE

   ( cSatCliT )->( ordSetFocus( 0 ) )
   ( cSatCliT )->( dbGoTop() )

      while !( cSatCliT )->( eof() )

         if Empty( ( cSatCliT )->cSufSat )
            ( cSatCliT )->cSufSat := "00"
         end if

         if !Empty( ( cSatCliT )->cNumAlb ) .and. Len( AllTrim( ( cSatCliT )->cNumAlb ) ) != 12
         ( cSatCliT )->cNumAlb := AllTrim( ( cSatCliT )->cNumAlb ) + "00"
         end if

         if !Empty( ( cSatCliT )->cNumTik ) .and. Len( AllTrim( ( cSatCliT )->cNumTik ) ) != 13
         ( cSatCliT )->cNumTik := AllTrim( ( cSatCliT )->cNumTik ) + "00"
         end if

         if Empty( ( cSatCliT )->cCodCaj )
            ( cSatCliT )->cCodCaj := "000"
         end if

         if Empty( ( cSatCliT )->cCodGrp )
            ( cSatCliT )->cCodGrp := RetGrpCli( ( cSatCliT )->cCodCli, dbfClient )
         end if

         if Empty( ( cSatCliT )->cCodRut )
            ( cSatCliT )->cCodRut := RetFld( ( cSatCliT )->cCodCli, dbfClient, "cCodRut" )
         end if

         if Empty( ( cSatCliT )->cNomCli )
            ( cSatCliT )->cNomCli := RetFld( ( cSatCliT )->cCodCli, dbfClient, "Titulo" )
         end if

         if Empty( ( cSatCliT )->cDirCli )
            ( cSatCliT )->cDirCli := RetFld( ( cSatCliT )->cCodCli, dbfClient, "Domicilio" )
         end if

         if Empty( ( cSatCliT )->cPobCli )
            ( cSatCliT )->cPobCli := RetFld( ( cSatCliT )->cCodCli, dbfClient, "Poblacion" )
         end if

         if Empty( ( cSatCliT )->cPrvCli )
            ( cSatCliT )->cPrvCli := RetFld( ( cSatCliT )->cCodCli, dbfClient, "Provincia" )
         end if

         if Empty( ( cSatCliT )->cPosCli )
            ( cSatCliT )->cPosCli := RetFld( ( cSatCliT )->cCodCli, dbfClient, "CodPostal" )
         end if

         if Empty( ( cSatCliT )->cDniCli )
            ( cSatCliT )->cDniCli := RetFld( ( cSatCliT )->cCodCli, dbfClient, "Nif" )
         end if

         /*
         Rellenamos los campos de totales
         */

         if ( cSatCliT )->nTotSat == 0 .and. dbLock( cSatCliT )

            aTotSat                 := aTotSatCli( ( cSatCliT )->cSerSat + Str( ( cSatCliT )->nNumSat ) + ( cSatCliT )->cSufSat, cSatCliT, cSatCliL, dbfIva, dbfDiv, dbfFPago, ( cSatCliT )->cDivSat )

            ( cSatCliT )->nTotNet := aTotSat[1]
            ( cSatCliT )->nTotIva := aTotSat[2]
            ( cSatCliT )->nTotReq := aTotSat[3]
            ( cSatCliT )->nTotSat := aTotSat[4]

            ( cSatCliT )->( dbUnLock() )

         end if

         ( cSatCliT )->( dbSkip() )

      end while

   ( cSatCliT )->( ordSetFocus( 1 ) )

   // lineas ------------------------------------------------------------------

   ( cSatCliL )->( ordSetFocus( 0 ) )
   ( cSatCliL )->( dbGoTop() )

      while !( cSatCliL )->( eof() )

         if Empty( ( cSatCliL )->cSufSat )
            ( cSatCliL )->cSufSat := "00"
         end if

         if Empty( ( cSatCliL )->cLote ) .and. !Empty( ( cSatCliL )->nLote )
            ( cSatCliL )->cLote      := AllTrim( Str( ( cSatCliL )->nLote ) )
         end if

         if ( cSatCliL )->lIvaLin    != RetFld( ( cSatCliL )->cSerSat + Str( ( cSatCliL )->nNumSat ) + ( cSatCliL )->cSufSat, cSatCliT, "lIvaInc" )
            ( cSatCliL )->lIvaLin    := RetFld( ( cSatCliL )->cSerSat + Str( ( cSatCliL )->nNumSat ) + ( cSatCliL )->cSufSat, cSatCliT, "lIvaInc" )
         end if

         if !Empty( ( cSatCliL )->cRef ) .and. Empty( ( cSatCliL )->cCodFam )
            ( cSatCliL )->cCodFam    := RetFamArt( ( cSatCliL )->cRef, dbfArticulo )
         end if

         if !Empty( ( cSatCliL )->cRef ) .and. !Empty( ( cSatCliL )->cCodFam )
            ( cSatCliL )->cGrpFam    := cGruFam( ( cSatCliL )->cCodFam, dbfFamilia )
         end if

         if !Empty( ( cSatCliL )->cRef ) .and. Empty( ( cSatCliL )->cCodTip )
            ( cSatCliL )->cCodTip    := RetFld( ( cSatCliL )->cRef, dbfArticulo, "cCodTip" )
         end if

         if Empty( ( cSatCliL )->nReq )
            ( cSatCliL )->nReq       := nPReq( dbfIva, ( cSatCliL )->nIva )
         end if

         if Empty( ( cSatCliL )->nPosPrint )
            ( cSatCliL )->nPosPrint  := ( cSatCliL )->nNumLin
         end if 

         if ( cSatCliL )->nRegIva != RetFld( ( cSatCliL )->cSerSat + str( ( cSatCliL )->nNumSat ) + ( cSatCliL )->cSufSat, cSatCliT, "nRegIva" )
            if ( cSatCliL )->( dbRLock() )
               ( cSatCliL )->nRegIva    := RetFld( ( cSatCliL )->cSerSat + str( ( cSatCliL )->nNumSat ) + ( cSatCliL )->cSufSat, cSatCliT, "nRegIva" )
               ( cSatCliL )->( dbUnLock() )
            end if
         end if

         ( cSatCliL )->( dbSkip() )

         SysRefresh()

      end while

   ( cSatCliL )->( ordSetFocus( 1 ) )

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
   
         if ( dbfSatCliS )->dFecSat != RetFld( ( dbfSatCliS )->cSerSat + Str( ( dbfSatCliS )->nNumSat ) + ( dbfSatCliS )->cSufSat, cSatCliT, "dFecSat" )
            ( dbfSatCliS )->dFecSat := RetFld( ( dbfSatCliS )->cSerSat + Str( ( dbfSatCliS )->nNumSat ) + ( dbfSatCliS )->cSufSat, cSatCliT, "dFecSat" )
         end if
   
         ( dbfSatCliS )->( dbSkip() )
   
         SysRefresh()
   
      end while

   ( dbfSatCliS )->( ordSetFocus( 1 ) )

   // Purgamos los datos----------------------------------------------------
      
   ( cSatCliL )->( dbGoTop() )
   while !( cSatCliL )->( eof() )

      if !( cSatCliT )->( dbSeek( ( cSatCliL )->cSerSat + str( ( cSatCliL )->nNumSat ) + ( cSatCliL )->cSufSat ) )
         
         if ( cSatCliL )->( dbRLock() )
            ( cSatCliL )->( dbDelete() )
            ( cSatCliL )->( dbRUnLock() )
         end if 

      end if

      ( cSatCliL )->( dbSkip() )

   end while 

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   CLOSE ( cSatCliT )
   CLOSE ( cSatCliL )
   CLOSE ( dbfSatCliI )
   CLOSE ( dbfSatCliS )
   CLOSE ( dbfArticulo)
   CLOSE ( dbfFamilia )
   CLOSE ( dbfIva     )
   CLOSE ( dbfDiv     )
   CLOSE ( dbfFPago   )
   CLOSE ( dbfClient  )

return nil

//------------------------------------------------------------------------//
//------------------------------------------------------------------------//
//------------------------------------------------------------------------//
//------------------------------------------------------------------------//
//------------------------------------------------------------------------//
//------------------------------------------------------------------------//

CLASS TSATClientesSenderReciver FROM TSenderReciverItem

   Method CreateData()

   Method RestoreData()

   Method SendData()

   Method ReciveData()

   Method Process()

   METHOD validateRecepcion()

END CLASS

//----------------------------------------------------------------------------//

Method CreateData() CLASS TSATClientesSenderReciver

   local oBlock
   local oError
   local lSnd        := .f.
   local cSatCliT
   local cSatCliL
   local dbfSatCliI
   local tmpSatCliT
   local tmpSatCliL
   local tmpSatCliI
   local cFileName   := "SatCli" + StrZero( ::nGetNumberToSend(), 6 ) + "." + RetSufEmp()

   ::oSender:SetText( "Enviando S.A.T. de clientes" )

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   USE ( cPatEmp() + "SatCliT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "SatCliT", @cSatCliT ) )
   SET ADSINDEX TO ( cPatEmp() + "SatCliT.CDX" ) ADDITIVE

   USE ( cPatEmp() + "SatCliL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "SatCliL", @cSatCliL ) )
   SET ADSINDEX TO ( cPatEmp() + "SatCliL.CDX" ) ADDITIVE

   USE ( cPatEmp() + "SatCliI.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "SatCliI", @dbfSatCliI ) )
   SET ADSINDEX TO ( cPatEmp() + "SatCliI.CDX" ) ADDITIVE

   // Creamos todas las bases de datos relacionadas con Articulos

   mkSatCli( cPatSnd() )

   USE ( cPatSnd() + "SatCliT.DBF" ) NEW VIA ( cLocalDriver() ) SHARED ALIAS ( cCheckArea( "SatCliT", @tmpSatCliT ) )
   SET INDEX TO ( cPatSnd() + "SatCliT.CDX" ) ADDITIVE

   USE ( cPatSnd() + "SatCliL.DBF" ) NEW VIA ( cLocalDriver() ) SHARED ALIAS ( cCheckArea( "SatCliL", @tmpSatCliL ) )
   SET INDEX TO ( cPatSnd() + "SatCliL.CDX" ) ADDITIVE

   USE ( cPatSnd() + "SatCliI.DBF" ) NEW VIA ( cLocalDriver() ) SHARED ALIAS ( cCheckArea( "SatCliI", @tmpSatCliI ) )
   SET INDEX TO ( cPatSnd() + "SatCliI.CDX" ) ADDITIVE

   if !Empty( ::oSender:oMtr )
      ::oSender:oMtr:nTotal := ( cSatCliT )->( LastRec() )
   end if

   while !( cSatCliT )->( eof() )

      if ( cSatCliT )->lSndDoc

         lSnd  := .t.

         dbPass( cSatCliT, tmpSatCliT, .t. )
         
         ::oSender:SetText( ( cSatCliT )->cSerSat + "/" + AllTrim( Str( ( cSatCliT )->nNumSat ) ) + "/" + AllTrim( ( cSatCliT )->cSufSat ) + "; " + Dtoc( ( cSatCliT )->dFecSat ) + "; " + AllTrim( ( cSatCliT )->cCodCli ) + "; " + ( cSatCliT )->cNomCli )

         if ( cSatCliL )->( dbSeek( ( cSatCliT )->CSERSat + Str( ( cSatCliT )->NNUMSat ) + ( cSatCliT )->CSUFSat ) )
            while ( ( cSatCliL )->cSerSat + Str( ( cSatCliL )->NNUMSat ) + ( cSatCliL )->CSUFSat ) == ( ( cSatCliT )->CSERSat + Str( ( cSatCliT )->NNUMSat ) + ( cSatCliT )->CSUFSat ) .AND. !( cSatCliL )->( eof() )
               dbPass( cSatCliL, tmpSatCliL, .t. )
               ( cSatCliL )->( dbSkip() )
            end do
         end if

         if ( dbfSatCliI )->( dbSeek( ( cSatCliT )->cSerSat + Str( ( cSatCliT )->nNumSat ) + ( cSatCliT )->cSufSat ) )
            while ( ( dbfSatCliI )->cSerSat + Str( ( dbfSatCliI )->nNumSat ) + ( dbfSatCliI )->cSufSat ) == ( ( cSatCliT )->cSerSat + Str( ( cSatCliT )->nNumSat ) + ( cSatCliT )->cSufSat ) .AND. !( dbfSatCliI )->( eof() )
               dbPass( dbfSatCliI, tmpSatCliI, .t. )
               ( dbfSatCliI )->( dbSkip() )
            end do
         end if

      end if

      ( cSatCliT )->( dbSkip() )

      if !Empty( ::oSender:oMtr )
         ::oSender:oMtr:Set( ( cSatCliT )->( OrdKeyNo() ) )
      end if

   end do

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   CLOSE ( cSatCliT )
   CLOSE ( cSatCliL )
   CLOSE ( dbfSatCliI )
   CLOSE ( tmpSatCliT )
   CLOSE ( tmpSatCliL )
   CLOSE ( tmpSatCliI )

   if lSnd

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

Method RestoreData() CLASS TSATClientesSenderReciver

   local oBlock
   local oError
   local cSatCliT

   if ::lSuccesfullSend

      oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
      BEGIN SEQUENCE

      USE ( cPatEmp() + "SatCliT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "SatCliT", @cSatCliT ) )
      SET ADSINDEX TO ( cPatEmp() + "SatCliT.Cdx" ) ADDITIVE
      
      ( cSatCliT )->( OrdSetFocus( "lSndDoc" ) )

      while ( cSatCliT )->( dbSeek( .t. ) ) .and. !( cSatCliT )->( eof() )
         if ( cSatCliT )->( dbRLock() )
            ( cSatCliT )->lSndDoc := .f.
            ( cSatCliT )->( dbRUnlock() )
         end if
      end do

      RECOVER USING oError

         msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

      END SEQUENCE

      ErrorBlock( oBlock )

      CLOSE ( cSatCliT )

   end if

Return ( Self )

//----------------------------------------------------------------------------//

Method SendData() CLASS TSATClientesSenderReciver

   local cFileName         := "SatCli" + StrZero( ::nGetNumberToSend(), 6 ) + "." + RetSufEmp()

   if File( cPatOut() + cFileName )

      /*
      Enviarlos a internet
      */

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

Method ReciveData() CLASS TSATClientesSenderReciver

   local n
   local aExt

   aExt     := ::oSender:aExtensions()

   /*
   Recibirlo de internet
   */

   ::oSender:SetText( "Recibiendo S.A.T. de clientes" )

   for n := 1 to len( aExt )
      ::oSender:GetFiles( "SatCli*." + aExt[ n ], cPatIn() )
   next

   ::oSender:SetText( "S.A.T. de clientes recibidos" )

Return Self

//----------------------------------------------------------------------------//

Method Process() CLASS TSATClientesSenderReciver

   local m
   local oBlock
   local oError
   local cSatCliT
   local cSatCliL
   local dbfSatCliI
   local dbfSatClid
   local tmpSatCliT
   local tmpSatCliL
   local tmpSatCliI
   local tmpSatCliD
   local aFiles      := Directory( cPatIn() + "SatCli*.*" )
   local cOperario   := GetPvProfString(  "Envioyrecepcion", "Operario", "",   cIniAplication() )

   for m := 1 to len( aFiles )

      ::oSender:SetText( "Procesando fichero : " + aFiles[ m, 1 ] )

      oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )

      BEGIN SEQUENCE

         if ::oSender:lUnZipData( cPatIn() + aFiles[ m, 1 ] )

            if lExistTable( cPatSnd() + "SatCliT.DBF", cLocalDriver() )    .and.;
               lExistTable( cPatSnd() + "SatCliL.DBF", cLocalDriver() )    .and.;
               lExistTable( cPatSnd() + "SatCliI.DBF", cLocalDriver() )    .and.;
               lExistTable( cPatSnd() + "SatCliD.DBF", cLocalDriver() )

               USE ( cPatSnd() + "SatCliT.DBF" ) NEW VIA ( cLocalDriver() ) READONLY ALIAS ( cCheckArea( "SatCliT", @tmpSatCliT ) )
               SET INDEX TO ( cPatSnd() + "SatCliT.CDX" ) ADDITIVE

               USE ( cPatSnd() + "SatCliL.DBF" ) NEW VIA ( cLocalDriver() ) READONLY ALIAS ( cCheckArea( "SatCliL", @tmpSatCliL ) )
               SET INDEX TO ( cPatSnd() + "SatCliL.CDX" ) ADDITIVE

               USE ( cPatSnd() + "SatCliI.DBF" ) NEW VIA ( cLocalDriver() ) READONLY ALIAS ( cCheckArea( "SatCliI", @tmpSatCliI ) )
               SET INDEX TO ( cPatSnd() + "SatCliI.CDX" ) ADDITIVE

               USE ( cPatSnd() + "SatCliD.DBF" ) NEW VIA ( cLocalDriver() ) READONLY ALIAS ( cCheckArea( "SatCliD", @tmpSatCliD ) )
               SET INDEX TO ( cPatSnd() + "SatCliD.CDX" ) ADDITIVE

               USE ( cPatEmp() + "SatCliT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "SatCliT", @cSatCliT ) )
               SET ADSINDEX TO ( cPatEmp() + "SatCliT.CDX" ) ADDITIVE

               USE ( cPatEmp() + "SatCliL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "SatCliL", @cSatCliL ) )
               SET ADSINDEX TO ( cPatEmp() + "SatCliL.CDX" ) ADDITIVE

               USE ( cPatEmp() + "SatCliI.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "SatCliI", @dbfSatCliI ) )
               SET ADSINDEX TO ( cPatEmp() + "SatCliI.CDX" ) ADDITIVE

               USE ( cPatEmp() + "SatCliD.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "SatCliD", @dbfSatCliD ) )
               SET ADSINDEX TO ( cPatEmp() + "SatCliD.CDX" ) ADDITIVE

               while !( tmpSatCliT )->( eof() )

                  if ::validateRecepcion( tmpSatCliT, cSatCliT, cOperario )

                     dbPass( tmpSatCliT, cSatCliT, .t. )

                     if dbLock( cSatCliT )
                        ( cSatCliT )->lSndDoc := .f.
                        ( cSatCliT )->( dbUnLock() )
                     end if

                     ::oSender:SetText( "Añadido     : " + ( tmpSatCliL )->cSerSat + "/" + AllTrim( Str( ( tmpSatCliL )->nNumSat ) ) + "/" + AllTrim( ( tmpSatCliL )->cSufSat ) + "; " + Dtoc( ( tmpSatCliT )->dFecSat ) + "; " + AllTrim( ( tmpSatCliT )->cCodCli ) + "; " + ( tmpSatCliT )->cNomCli )

                     if ( tmpSatCliL )->( dbSeek( ( tmpSatCliT )->cSerSat + Str( ( tmpSatCliT )->nNumSat ) + ( tmpSatCliT )->cSufSat ) )
                        do while ( tmpSatCliL )->cSerSat + Str( ( tmpSatCliL )->nNumSat ) + ( tmpSatCliL )->cSufSat == ( tmpSatCliT )->cSerSat + Str( ( tmpSatCliT )->nNumSat ) + ( tmpSatCliT )->cSufSat .and. !( tmpSatCliL )->( eof() )
                           dbPass( tmpSatCliL, cSatCliL, .t. )
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

               CLOSE ( cSatCliT )
               CLOSE ( cSatCliL )
               CLOSE ( dbfSatCliI )
               CLOSE ( dbfSatCliD )
               CLOSE ( tmpSatCliT )
               CLOSE ( tmpSatCliL )
               CLOSE ( tmpSatCliI )
               CLOSE ( tmpSatCliD )

               ::oSender:AppendFileRecive( aFiles[ m, 1 ] )

            else

               ::oSender:SetText( "Faltan ficheros" )

               if !lExistTable( cPatSnd() + "SatCliT.DBF", cLocalDriver() )
                  ::oSender:SetText( "Falta " + cPatSnd() + "SatCliT.DBF" )
               end if

               if !lExistTable( cPatSnd() + "SatCliL.DBF", cLocalDriver() )
                  ::oSender:SetText( "Falta " + cPatSnd() + "SatCliL.DBF" )
               end if


               if !lExistTable( cPatSnd() + "SatCliI.DBF", cLocalDriver() )
                  ::oSender:SetText( "Falta " + cPatSnd() + "SatCliL.DBF" )
               end if

               if !lExistTable( cPatSnd() + "SatCliD.DBF", cLocalDriver() )
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

         CLOSE ( cSatCliT )
         CLOSE ( cSatCliL )
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

METHOD validateRecepcion( tmpSatCliT, dbfSatCliT, cOperario ) CLASS TSATClientesSenderReciver

   ::cErrorRecepcion       := "Pocesando S.A.T. de cliente número " + ( dbfSatCliT )->cSerSat + "/" + alltrim( Str( ( dbfSatCliT )->nNumSat ) ) + "/" + alltrim( ( dbfSatCliT )->cSufSat ) + " "

   if !( lValidaOperacion( ( tmpSatCliT )->dFecSat, .f. ) )
      ::cErrorRecepcion    += "la fecha " + dtoc( ( tmpSatCliT )->dFecSat ) + " no es valida en esta empresa"
      Return .f. 
   end if 

   if !empty( cOperario ) .and. ( ( tmpSatCliT )->cCodOpe != cOperario )
      ::cErrorRecepcion    += "el operario " + cOperario + " no coincide"
      Return .f. 
   end if 

   if !( ( dbfSatCliT )->( dbSeek( ( tmpSatCliT )->cSerSat + Str( ( tmpSatCliT )->nNumSat ) + ( tmpSatCliT )->cSufSat ) ) )
      Return .t.
   end if 

   if dtos( ( dbfSatCliT )->dFecCre ) + ( dbfSatCliT )->cTimCre >= dtos( ( tmpSatCliT )->dFecCre ) + ( tmpSatCliT )->cTimCre 
      ::cErrorRecepcion    += "la fecha en la empresa " + dtoc( ( dbfSatCliT )->dFecCre ) + " " + ( dbfSatCliT )->cTimCre + " es más reciente que la recepción " + dtoc( ( tmpSatCliT )->dFecCre ) + " " + ( tmpSatCliT )->cTimCre 
      Return .f.
   end if

Return ( .t. )

//---------------------------------------------------------------------------//

Function AppSatCli( cCodCli, cCodArt, lOpenBrowse )

   local nLevel         := Auth():Level( _MENUITEM_ )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) == 0 .or. nAnd( nLevel, ACC_APPD ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if lOpenBrowse

      if SatCli( nil, nil, cCodCli, cCodArt )
         oWndBrw:RecAdd()
      end if

   else

      if OpenFiles( .t. )
         WinAppRec( nil, bEdtRec, D():SatClientes( nView ), cCodCli, cCodArt )
         CloseFiles()
      end if

   end if

RETURN .t.

//----------------------------------------------------------------------------//

FUNCTION EdtSatCli( cNumSat, lOpenBrowse )

   local nLevel         := Auth():Level( _MENUITEM_ )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) == 0 .or. nAnd( nLevel, ACC_EDIT ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if lOpenBrowse

      if SatCli()
         if dbSeekInOrd( cNumSat, "nNumSat", D():SatClientes( nView ) )
            oWndBrw:RecEdit()
         else
            MsgStop( "No se encuentra S.A.T." )
         end if
      end if

   else

      if OpenFiles( .t. )

         if dbSeekInOrd( cNumSat, "nNumSat", D():SatClientes( nView ) )
            WinEdtRec( nil, bEdtRec, D():SatClientes( nView ) )
         end if

         CloseFiles()

      end if

   end if

Return .t.

//----------------------------------------------------------------------------//

FUNCTION ZooSatCli( cNumSat, lOpenBrowse, lPda )

   local nLevel         := Auth():Level( _MENUITEM_ )

   DEFAULT lOpenBrowse  := .f.
   DEFAULT lPda         := .f.

   if nAnd( nLevel, 1 ) == 0 .or. nAnd( nLevel, ACC_ZOOM ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if lOpenBrowse

      if SatCli()
         if dbSeekInOrd( cNumSat, "nNumSat", D():SatClientes( nView ) )
            oWndBrw:RecZoom()
         else
            MsgStop( "No se encuentra S.A.T." )
         end if
      end if

   else

      if OpenFiles( .t. )

         if dbSeekInOrd( cNumSat, "nNumSat", D():SatClientes( nView ) )
            WinZooRec( nil, bEdtRec, D():SatClientes( nView ) )
         end if

         CloseFiles()

      end if

   end if

Return .t.

//----------------------------------------------------------------------------//

FUNCTION DelSatCli( cNumSat, lOpenBrowse )

   local nLevel         := Auth():Level( _MENUITEM_ )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) == 0 .or. nAnd( nLevel, ACC_DELE ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if lOpenBrowse

      if SatCli()
         if dbSeekInOrd( cNumSat, "nNumSat", D():SatClientes( nView ) )
            WinDelRec( nil, D():SatClientes( nView ), {|| QuiSatCli() } )
         else
            MsgStop( "No se encuentra S.A.T." )
         end if
      end if

   else

      if OpenFiles( .t. )

         if dbSeekInOrd( cNumSat, "nNumSat", D():SatClientes( nView ) )
            WinDelRec( nil, D():SatClientes( nView ), {|| QuiSatCli() } )
         end if

         CloseFiles()

      end if

   end if

Return .t.

//----------------------------------------------------------------------------//

FUNCTION PrnSatCli( cNumSat, lOpenBrowse )

   local nLevel         := Auth():Level( _MENUITEM_ )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) == 0 .or. nAnd( nLevel, ACC_IMPR ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if lOpenBrowse

      if SatCli()
         if dbSeekInOrd( cNumSat, "nNumSat", D():SatClientes( nView ) )
            GenSatCli( IS_PRINTER )
         else
            MsgStop( "No se encuentra S.A.T." )
         end if
      end if

   else

      if OpenFiles( .t. )
         if dbSeekInOrd( cNumSat, "nNumSat", D():SatClientes( nView ) )
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

   local nLevel         := Auth():Level( _MENUITEM_ )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) == 0 .or. nAnd( nLevel, ACC_IMPR ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if lOpenBrowse

      if SatCli()
         if dbSeekInOrd( cNumSat, "nNumSat", D():SatClientes( nView ) )
            GenSatCli( IS_SCREEN )
         else
            MsgStop( "No se encuentra S.A.T." )
         end if
      end if

   else

      if OpenFiles( .t. )

         if dbSeekInOrd( cNumSat, "nNumSat", D():SatClientes( nView ) )
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

   if ( D():SatClientes( nView ) )->lEstado
      msgStop( "No se pueden eliminar S.A.T. ya procesados." )
      Return .f.
   end if

   if ( D():SatClientes( nView ) )->lCloSat .and. !oUser():lAdministrador()
      msgStop( "Solo puede eliminar S.A.T. cerrados los administradores." )
      Return .f.
   end if

   nOrdInc        := ( dbfSatCliI )->( OrdSetFocus( "nNumSat" ) )
   nOrdDoc        := ( dbfSatCliD )->( OrdSetFocus( "nNumSat" ) )

   /*
   Detalle---------------------------------------------------------------------
   */
   
   while ( D():SatClientesLineas( nView ) )->( dbSeek( D():SatClientesId( nView ) ) ) .and. D():SatClientesLineasNotEof( nView )
     if dbLock( D():SatClientesLineas( nView ) )
        ( D():SatClientesLineas( nView ) )->( dbDelete() )
        ( D():SatClientesLineas( nView ) )->( dbUnLock() )
      end if
   end while

   /*
   Documentos------------------------------------------------------------------
   */

   while ( dbfSatCliI )->( dbSeek( ( D():SatClientes( nView ) )->cSerSat + Str( ( D():SatClientes( nView ) )->nNumSat ) + ( D():SatClientes( nView )  )->cSufSat ) ) .and. !( dbfSatCliI )->( eof() )
      if dbLock( dbfSatCliI )
         ( dbfSatCliI )->( dbDelete() )
         ( dbfSatCliI )->( dbUnLock() )
      end if
   end while

   /*
   Incidencias-----------------------------------------------------------------
   */

   while ( dbfSatCliD )->( dbSeek( ( D():SatClientes( nView ) )->cSerSat + Str( ( D():SatClientes( nView ) )->nNumSat ) + ( D():SatClientes( nView )  )->cSufSat ) ) .and. !( dbfSatCliD )->( eof() )
      if dbLock( dbfSatCliD )
         ( dbfSatCliD )->( dbDelete() )
         ( dbfSatCliD )->( dbUnLock() )
      end if
   end while

   ( dbfSatCliI )->( OrdSetFocus( nOrdInc ) )
   ( dbfSatCliD )->( OrdSetFocus( nOrdDoc ) )

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

         oFr:AddBand(         "MasterData",  "MainPage", frxMasterData )
         oFr:SetProperty(     "MasterData",  "Top", 200 )
         oFr:SetProperty(     "MasterData",  "Height", 0 )
         oFr:SetProperty(     "MasterData",  "StartNewPage", .t. )
         oFr:SetObjProperty(  "MasterData",  "DataSet", "SAT" )

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

Function mailReportSATCli( cCodigoDocumento )

Return ( printReportSATCli( IS_MAIL, 1, prnGetName(), cCodigoDocumento ) )

//---------------------------------------------------------------------------//

Function PrintReportSatCli( nDevice, nCopies, cPrinter, cCodigoDocumento )

   local oFr
   local cFilePdf              := cPatTmp() + "SATCliente" + StrTran( ( D():SatClientes( nView ) )->cSerSat + Str( ( D():SatClientes( nView ) )->nNumSat ) + ( D():SatClientes( nView ) )->cSufSat, " ", "" ) + ".Pdf"
   local nOrd

   DEFAULT nDevice            := IS_SCREEN
   DEFAULT nCopies            := 1
   DEFAULT cPrinter           := PrnGetName()
   DEFAULT cCodigoDocumento   := cFormatoSATClientes()   

   if empty( cCodigoDocumento )
      msgStop( "El código del documento esta vacio" )
      Return ( nil )
   end if 

   if !lMemoDocumento( cCodigoDocumento, dbfDoc )
      msgStop( "El formato " + cCodigoDocumento + " no se encuentra, o no es un formato visual." )
      Return ( nil )
   end if 

   SysRefresh()


   oFr                        := frReportManager():New()

   oFr:LoadLangRes( "Spanish.Xml" )
   oFr:SetIcon( 1 )
   oFr:SetTitle( "Diseñador de documentos" )

   /*
   Manejador de eventos--------------------------------------------------------
   */

   oFr:SetEventHandler( "Designer", "OnSaveReport", {|| oFr:SaveToBlob( ( dbfDoc )->( Select() ), "mReport" ) } )

   /*
   Zona de datos---------------------------------------------------------------
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

      end case

   end if

   /*
   Destruye el diseñador-------------------------------------------------------
   */

   oFr:DestroyFr()


Return cFilePdf

//---------------------------------------------------------------------------//

//----------------------------------------------------------------------------//
//Funciones comunes del programa y pda
//----------------------------------------------------------------------------//

Function nTotDtoLSatCli( dbfLin, nDec, nVdv, cPorDiv )

   local nCalculo

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

   if ( oWndBrw:oWndBar:cYearComboBox() != __txtAllYearsFilter__ )
      oWndBrw:oWndBar:setYearComboBoxExpression( "Year( Field->dFecSat ) == " + oWndBrw:oWndBar:cYearComboBox() )
   else
      oWndBrw:oWndBar:setYearComboBoxExpression( "" )
   end if 

   oWndBrw:chgFilter()

Return nil

//---------------------------------------------------------------------------//

Function sTotSatCli( cSat, dbfMaster, dbfLine, dbfIva, dbfDiv, cDivRet )

   local sTotal

   nTotSatCli( cSat, dbfMaster, dbfLine, dbfIva, dbfDiv, nil, nil, cDivRet, .f. )

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

Static Function cFormatoSATClientes( cSerie )

   local cFormato

   DEFAULT cSerie    := ( D():SatClientes( nView ) )->cSerSat

   cFormato          := cFormatoDocumento( cSerie, "nSatCli", D():Contadores( nView ) )

   if Empty( cFormato )
      cFormato       := cFirstDoc( "SC", D():Documentos( nView ) )
   end if

Return ( cFormato ) 

//---------------------------------------------------------------------------//   

static function ChangeComentario( oCol, uNewValue, nKey, aTmp )

   /*
   Cambiamos el valor de las unidades de la linea de la factura---------------
   */

   if IsNum( nKey ) .and. ( nKey != VK_ESCAPE ) .and. !IsNil( uNewValue )

      ( dbfTmpLin )->mObsLin       := uNewValue

      RecalculaTotal( aTmp )

   end if

Return .t.  

//---------------------------------------------------------------------------//   

Function DesignLabelSATClientes( oFr, cDoc )

   local oLabel
   local lOpenFiles  := empty( nView ) 

   if lOpenFiles .and. !Openfiles()
      Return .f.
   endif

   oLabel            := TLabelGeneratorSATClientes():New( nView )

   // Zona de datos---------------------------------------------------------
   
   oLabel:createTempLabelReport()
   oLabel:loadTempLabelReport()      
   oLabel:dataLabel( oFr )

   // Paginas y bandas------------------------------------------------------

   if !Empty( ( cDoc )->mReport )
      oFr:LoadFromBlob( ( cDoc )->( Select() ), "mReport")
   else
      oFr:AddPage(         "MainPage" )
      oFr:AddBand(         "MasterData",  "MainPage",       frxMasterData )
      oFr:SetProperty(     "MasterData",  "Top",            200 )
      oFr:SetProperty(     "MasterData",  "Height",         100 )
      oFr:SetObjProperty(  "MasterData",  "DataSet",        "Lineas de SAT" )
   end if

   oFr:DesignReport()
   oFr:DestroyFr()

   oLabel:DestroyTempReport()
   oLabel:End()

   if lOpenFiles
      closeFiles()
   end if 

Return .t.

//---------------------------------------------------------------------------//

Function getExtraFieldSATCliente( cFieldName )

Return ( getExtraField( cFieldName, oDetCamposExtra, D():SATClientesId( nView ) ) )

//---------------------------------------------------------------------------//

Static Function lChangeRegIva( aTmp )

   lImpuestos     := ( aTmp[ _NREGIVA ] <= 1 )

   if !Empty( oImpuestos )
      oImpuestos:Refresh()
   end if

return ( .t. )

//---------------------------------------------------------------------------//

Static Function importarArticulosScaner()

   local memoArticulos

   memoArticulos  := dialogArticulosScaner()
   
   if memoArticulos != nil
      msgStop( "tengo q procesar ")
   end if

Return nil       

//---------------------------------------------------------------------------//
