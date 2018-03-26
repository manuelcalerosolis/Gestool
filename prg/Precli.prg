#include "FiveWin.Ch"
#include "Folder.ch"
#include "Factu.ch" 
#include "Report.ch"
#include "Menu.ch"
#include "Xbrowse.ch"

#define CLR_BAR             14197607

#define _MENUITEM_           "01055"

/*
Definici¢n de la base de datos de presupuestos a clientes
*/

#define _CSERPRE                   1      //   C      1     0
#define _NNUMPRE                   2      //   N      9     0
#define _CSUFPRE                   3      //   C      2     0
#define _CTURPRE                   4      //   C      2     0
#define _DFECPRE                   5      //   D      8     0
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
#define _CSUPRE                   23      //   C     10     0
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
#define _CNUMALB                  45      //   C     10     0
#define _CDIVPRE                  46      //   C      3     0
#define _NVDVPRE                  47      //   C     10     4
#define _LSNDDOC                  48      //   L      1     0
#define _CRETPOR                  49
#define _CRETMAT                  50
#define _NREGIVA                  51
#define _LIVAINC                  52      //   N
#define _NIVAMAN                  53
#define _NMANOBR                  54
#define _CCODTRN                  55
#define _NKGSTRN                  56
#define _LCLOPRE                  57
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
#define _NTOTPRE                  79
#define _LOPERPV                  80
#define _NDTOTARIFA               81  
#define _CCODWEB                  82
#define _LWEB                     83
#define _LINTERNET                84
#define _MFIRMA                   85
#define _CCENTROCOSTE             86

/*
Definici¢n de la base de datos de lineas de detalle
*/

#define _CREF                      4
#define _CDETALLE                  5
#define _NIVA                      6
#define _NCANPRE                   7
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
#define _NPVPREC                  35
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
#define _DFECCAD                  80
#define __NBULTOS                 81
#define _CFORMATO                 82
#define _LLABEL                   83
#define _NLABEL                   84
#define _COBRLIN                  85
#define _CREFAUX                  86
#define _CREFAUX2                 87
#define _NPOSPRINT                88
#define __CCENTROCOSTE            89
#define _CTIPCTR                  90
#define _CTERCTR                  91
#define _ID_TIPO_V                92
#define __NREGIVA                 93

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
memvar cTarPreL
memvar cTarPreS
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
memvar nTotPre
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
memvar cPicUndPre
memvar nVdvDivPre
memvar cPouDivPre
memvar cPorDivPre
memvar cPouChgPre
memvar nDouDivPre
memvar nRouDivPre
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
static dbfPreCliT
static dbfPreCliI
static dbfPreCliD
static dbfClient
static dbfCliInc
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
static dbfTmpEst
static dbfTmpDoc
static dbfKit
static dbfFPago
static dbfObrasT
static dbfAlm
static dbfAgent
static dbfFamilia
static dbfProvee
static dbfOferta
static dbfTblPro
static dbfPro

static oImpuestos
static lImpuestos

static dbfArtDiv
static dbfDelega
static dbfAgeCom
static dbfCount
static dbfEmp
static dbfPedPrvL
static dbfAlbPrvL
static dbfFacPrvL
static dbfRctPrvL
static dbfPedCliL
static dbfAlbCliL
static dbfFacCliL
static dbfFacRecL
static dbfTikCliL
static dbfAlbCliT
static dbfFacCliP
static dbfAntCliT
static dbfTikCliT
static dbfProLin
static dbfProMat
static cTmpLin
static cTmpInc
static cTmpDoc
static cTmpEst
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
static bEdtRec          := { | aTmp, aGet, dbfPreCliT, oBrw, bWhen, bValid, nMode | EdtRec( aTmp, aGet, dbfPreCliT, oBrw, bWhen, bValid, nMode ) }
static bEdtDet          := { | aTmp, aGet, dbfPreCliL, oBrw, bWhen, bValid, nMode, aTmpPre | EdtDet( aTmp, aGet, dbfPreCliL, oBrw, bWhen, bValid, nMode, aTmpPre ) }
static bEdtInc          := { | aTmp, aGet, dbfPreCliL, oBrw, bWhen, bValid, nMode, aTmpPre | EdtInc( aTmp, aGet, dbfPreCliI, oBrw, bWhen, bValid, nMode, aTmpPre ) }
static bEdtDoc          := { | aTmp, aGet, dbfPreCliD, oBrw, bWhen, bValid, nMode, aTmpPre | EdtDoc( aTmp, aGet, dbfPreCliD, oBrw, bWhen, bValid, nMode, aTmpPre ) }
static bEdtEst          := { | aTmp, aGet, dbf, oBrw, bWhen, bValid, nMode, aTmpPre | EdtEst( aTmp, aGet, dbf, oBrw, bWhen, bValid, nMode, aTmpPre ) }
static cOldCodCli       := ""
static cOldCodArt       := ""
static cOldPrpArt       := ""
static cOldUndMed       := ""
static cOldSituacion    := ""
static lOpenFiles       := .f.
static lExternal        := .f.
static aTipPre          := { "Venta", "Alquiler" }
static oTipPre
static oUndMedicion
static cFiltroUsuario   := ""

static nTarifaPrecio    := 0
static oBtnPrecio

static oComisionLinea
static nComisionLinea   := 0

static oMailing

static oDetCamposExtra

static oBrwProperties

static oTipoCtrCoste
static cTipoCtrCoste
static aTipoCtrCoste       := { "Centro de coste", "Proveedor", "Agente", "Cliente" }
static oCentroCoste

static Counter

//----------------------------------------------------------------------------//
//Funciones del programa
//----------------------------------------------------------------------------//

FUNCTION GenPreCli( nDevice, cCaption, cCodDoc, cPrinter, nCopies )

   local oInf
   local oDevice
   local nNumPre

   if ( D():PresupuestosClientes( nView ) )->( Lastrec() ) == 0
      return nil
   end if

   nNumPre              := ( D():PresupuestosClientes( nView ) )->cSerPre + Str( ( D():PresupuestosClientes( nView ) )->nNumPre ) + ( D():PresupuestosClientes( nView ) )->cSufPre

   DEFAULT nDevice      := IS_PRINTER
   DEFAULT cCaption     := "Imprimiendo presupuesto"
   DEFAULT cCodDoc      := cFormatoPresupuestosClientes()

   if !lExisteDocumento( cCodDoc, D():Documentos( nView ) )
      return nil
   end if

   // Numero de copias---------------------------------------------------------

   if Empty( nCopies )
      nCopies           := retfld( ( D():PresupuestosClientes( nView ) )->cCodCli, D():Get( "Client", nView ), "CopiasF" ) 
   end if

   if nCopies == 0 
      nCopies           := nCopiasDocumento( ( D():PresupuestosClientes( nView ) )->cSerPre, "nPreCli", D():Get( "NCount", nView ) )
   end if 

   if nCopies == 0
      nCopies           := 1
   end if  

   /*
   Si el documento es de tipo visual-------------------------------------------
   */

   if lVisualDocumento( cCodDoc, D():Documentos( nView ) )
      printReportPreCli( nDevice, nCopies, cPrinter, cCodDoc )
   else
      msgStop( "El formato ya no es soportado" )
   end if

   lChgImpDoc( D():PresupuestosClientes( nView ) )

RETURN NIL

//--------------------------------------------------------------------------//

Static Function PreCliReportSkipper( dbf, dbfPreCliL )

   ( dbfPreCliL )->( dbSkip() )

   nTotPage              += nTotLPreCli( dbfPreCliL )

Return nil

//--------------------------------------------------------------------------//

Static Function ePage( oInf, cCodDoc )

   private nPagina      := oInf:nPage
	private lEnd			:= oInf:lFinish

   PrintItems( cCodDoc, oInf )

Return nil

//--------------------------------------------------------------------------//

STATIC FUNCTION OpenFiles( lExt )

   local oError
   local oBlock

   if lOpenFiles
      MsgStop( 'Imposible abrir ficheros de presupuestos de clientes' )
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

      D():Get( "CliInc", nView )

      D():PresupuestosClientes( nView )

      D():PresupuestosClientesLineas( nView )

      D():Clientes( nView )

      D():objectGruposClientes( nView )

      D():ArticuloStockAlmacenes( nView )    

      D():Articulos( nView )      

      D():Documentos( nView )
      ( D():Documentos( nView ) )->( ordSetFocus( "cTipo" ) )

      D():ArticuloLenguaje( nView )

      D():GetObject( "UnidadMedicion", nView )

      D():ImpuestosEspeciales( nView )

      USE ( cPatEmp() + "PRECLII.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PRECLII", @dbfPreCliI ) )
      SET ADSINDEX TO ( cPatEmp() + "PRECLII.CDX" ) ADDITIVE

      USE ( cPatEmp() + "PRECLID.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PRECLID", @dbfPreCliD ) )
      SET ADSINDEX TO ( cPatEmp() + "PreCliD.Cdx" ) ADDITIVE

      USE ( cPatDat() + "TIVA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIVA", @dbfIva ) )
      SET ADSINDEX TO ( cPatDat() + "TIVA.CDX" ) ADDITIVE

      USE ( cPatArt() + "PROVART.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PROVART", @dbfArtPrv ) )
      SET ADSINDEX TO ( cPatArt() + "PROVART.CDX" ) ADDITIVE

      USE ( cPatCli() + "AGENTES.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "AGENTES", @dbfAgent ) )
      SET ADSINDEX TO ( cPatCli() + "AGENTES.CDX" ) ADDITIVE

      USE ( cPatArt() + "ArtCodebar.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CODEBAR", @dbfCodebar ) )
      SET ADSINDEX TO ( cPatArt() + "ArtCodebar.Cdx" ) ADDITIVE

      USE ( cPatArt() + "TARPREL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TARPREL", @dbfTarPreL ) )
      SET ADSINDEX TO ( cPatArt() + "TARPREL.CDX" ) ADDITIVE

      USE ( cPatArt() + "TARPRES.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TARPRES", @dbfTarPreS ) )
      SET ADSINDEX TO ( cPatArt() + "TARPRES.CDX" ) ADDITIVE

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

      USE ( cPatArt() + "FAMILIAS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FAMILIAS", @dbfFamilia ) )
      SET ADSINDEX TO ( cPatArt() + "FAMILIAS.CDX" ) ADDITIVE

      USE ( cPatArt() + "OFERTA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "OFERTA", @dbfOferta ) )
      SET ADSINDEX TO ( cPatArt() + "OFERTA.CDX" ) ADDITIVE

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

      USE ( cPatEmp() + "NCOUNT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "NCOUNT", @dbfCount ) )
      SET ADSINDEX TO ( cPatEmp() + "NCOUNT.CDX" ) ADDITIVE

      USE ( cPatDat() + "EMPRESA.DBF" ) NEW SHARED VIA ( cDriver() )ALIAS ( cCheckArea( "EMPRESA", @dbfEmp ) )
      SET ADSINDEX TO ( cPatDat() + "EMPRESA.CDX" ) ADDITIVE

      USE ( cPatEmp() + "PedProvL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PedProvL", @dbfPedPrvL ) )
      SET ADSINDEX TO ( cPatEmp() + "PedProvL.CDX" ) ADDITIVE

      USE ( cPatEmp() + "ALBPROVL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALBPROVL", @dbfAlbPrvL ) )
      SET ADSINDEX TO ( cPatEmp() + "ALBPROVL.CDX" ) ADDITIVE
      SET TAG TO "cStkFast"

      USE ( cPatEmp() + "FACPRVL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACPRVL", @dbfFacPrvL ) )
      SET ADSINDEX TO ( cPatEmp() + "FACPRVL.CDX" ) ADDITIVE
      SET TAG TO "cRef"

      USE ( cPatEmp() + "RctPrvL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "RctPrvL", @dbfRctPrvL ) )
      SET ADSINDEX TO ( cPatEmp() + "RctPrvL.CDX" ) ADDITIVE
      SET TAG TO "cRef"

      USE ( cPatEmp() + "PedCliL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PedCliL", @dbfPedCliL ) )
      SET ADSINDEX TO ( cPatEmp() + "PedCliL.CDX" ) ADDITIVE

      USE ( cPatEmp() + "ALBCLIL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALBCLIL", @dbfAlbCliL ) )
      SET ADSINDEX TO ( cPatEmp() + "ALBCLIL.CDX" ) ADDITIVE
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

      if !TDataCenter():OpenAlbCliT( @dbfAlbCliT )
         lOpenFiles     := .f.
      end if

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

      oCentroCoste        := TCentroCoste():Create( cPatDat() )
      if !oCentroCoste:OpenFiles()
         lOpenFiles     := .f.
      end if

      oMailing          := TGenmailingDatabasePresupuestosClientes():New( nView )

      Counter           := TCounter():New( nView, "nPreCli" )

      CodigosPostales():GetInstance():OpenFiles()

      // Recursos y fuente--------------------------------------------------------

      oFont             := TFont():New( "Arial", 8, 26, .f., .t. )

      // Declaración variables públicas-------------------------------------------

      public nTotPre    := 0
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
      
         cFiltroUsuario    := "Field->cSufPre == '" + Application():CodigoDelegacion() + "' .and. Field->cCodCaj == '" + oUser():cCaja() + "'"
         if SQLAjustableModel():getRolFiltrarVentas( Auth():rolUuid() )         
            cFiltroUsuario += " .and. Field->cCodUsr == '" + Auth():Codigo()  + "'"
         end if 

         ( D():PresupuestosClientes( nView ) )->( AdsSetAOF( cFiltroUsuario ) )

      end if

      EnableAcceso()

      /*
      Campos extras------------------------------------------------------------------------
      */

      oDetCamposExtra      := TDetCamposExtra():New()
      oDetCamposExtra:OpenFiles()
      oDetCamposExtra:SetTipoDocumento( "Presupuestos a clientes" )
      oDetCamposExtra:setbId( {|| D():PresupuestosClientesId( nView ) } )



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

   DestroyFastFilter( D():PresupuestosClientes( nView ), .t., .t. )

   if !Empty( oFont )
      oFont:end()
   end if

   if !Empty( dbfPreCliI   )
      ( dbfPreCliI   )->( dbCloseArea() )
   end if

   if !Empty( dbfPreCliD   )
      ( dbfPreCliD   )->( dbCloseArea() )
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

   if !Empty( D():Articulos( nView ) )
      ( D():Articulos( nView )  )->( dbCloseArea() )
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

   if !Empty( dbfFamilia )
      ( dbfFamilia   )->( dbCloseArea() )
   end if

   if !Empty( dbfOferta )
      ( dbfOferta    )->( dbCloseArea() )
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

   if !Empty( dbfAlbCliT )
      ( dbfAlbCliT )->( dbCloseArea() )
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

   if dbfCliInc != nil
      ( dbfCliInc )->( dbCloseArea() )
   end if

   if dbfFacCliP != nil
      ( dbfFacCliP )->( dbCloseArea() )
   end if

   if dbfAntCliT != nil
      ( dbfAntCliT )->( dbCloseArea() )
   end if

   if dbfProvee != nil
      ( dbfProvee )->( dbCloseArea() )
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

   if !Empty( oDetCamposExtra )
      oDetCamposExtra:CloseFiles()
   end if

   if !Empty( oCentroCoste )
      oCentroCoste:End()
   end if

   if !empty(oMailing)
      oMailing:end()
   end if 

   D():DeleteView( nView )

   CodigosPostales():GetInstance():CloseFiles()

   dbfPreCliI     := nil
   dbfPreCliD     := nil
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
   dbfFamilia     := nil
   dbfOferta      := nil
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
   dbfCount       := nil
   oBandera       := nil
   oNewImp        := nil
   oTrans         := nil
   oStock         := nil
   oTipArt        := nil
   oGrpFam        := nil
   dbfAgeCom      := nil
   dbfEmp         := nil

   dbfPedPrvL     := nil
   dbfAlbPrvL     := nil
   dbfFacPrvL     := nil
   dbfFacPrvL     := nil

   dbfPedCliL     := nil
   dbfAlbCliL     := nil
   dbfFacCliL     := nil
   dbfFacRecL     := nil
   dbfTikCliL     := nil

   dbfProLin      := nil
   dbfProMat      := nil
   dbfCliInc      := nil

   dbfProvee      := nil

   oCentroCoste   := nil

   lOpenFiles     := .f.

   oWndBrw        := nil

   EnableAcceso()

RETURN .T.

//----------------------------------------------------------------------------//

FUNCTION PreCli( oMenuItem, oWnd, cCodCli, cCodArt )

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
      TITLE    "Presupuestos a clientes" ;
      PROMPT   "Número",;
               "Fecha",;
               "Código",;
               "Nombre",;
               "Código postal",;
               "Población",;
               "Provincia",;
               "Dirección",;
               "Agente";
      MRU      "gc_notebook_user_16";
      BITMAP   clrTopArchivos ;
      ALIAS    ( D():PresupuestosClientes( nView ) );
      APPEND   ( WinAppRec( oWndBrw:oBrw, bEdtRec, D():PresupuestosClientes( nView ), cCodCli, cCodArt ) );
      DUPLICAT ( WinDupRec( oWndBrw:oBrw, bEdtRec, D():PresupuestosClientes( nView ), cCodCli, cCodArt ) );
      EDIT     ( WinEdtRec( oWndBrw:oBrw, bEdtRec, D():PresupuestosClientes( nView ), cCodCli, cCodArt ) );
      ZOOM     ( WinZooRec( oWndBrw:oBrw, bEdtRec, D():PresupuestosClientes( nView ) ) );
      DELETE   ( WinDelRec( oWndBrw:oBrw, D():PresupuestosClientes( nView ), {|| QuiPreCli() } ) ) ;
      LEVEL    nLevel ;
      OF       oWnd

	  oWndBrw:lFechado     := .t.

	  oWndBrw:SetYearComboBoxChange( {|| YearComboBoxChange() } )

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Sesión cerrada"
         :nHeadBmpNo       := 3
         :bStrData         := {|| "" }
         :bEditValue       := {|| ( D():PresupuestosClientes( nView ) )->lCloPre }
         :nWidth           := 20
         :SetCheck( { "Sel16", "Nil16" } )
         :AddResource( "gc_lock2_16" )

      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Estado"
         :nHeadBmpNo       := 3
         :bStrData         := {|| "" }
         :bEditValue       := {|| ( D():PresupuestosClientes( nView ) )->lEstado }
         :nWidth           := 20
         :SetCheck( { "gc_check_12", "gc_delete_12" } )
         :AddResource( "gc_trafficlight_on_16" )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Envio"
         :nHeadBmpNo       := 3
         :bStrData         := {|| "" }
         :bEditValue       := {|| ( D():PresupuestosClientes( nView ) )->lSndDoc }
         :nWidth           := 20
         :SetCheck( { "gc_mail2_12", "Nil16" } )
         :AddResource( "gc_mail2_16" )

      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Incidencia"
         :nHeadBmpNo       := 4
         :bStrData         := {|| "" }
         :bBmpData         := {|| nEstadoIncidencia( ( D():PresupuestosClientes( nView ) )->cSerPre + Str( ( D():PresupuestosClientes( nView ) )->nNumPre ) + ( D():PresupuestosClientes( nView ) )->cSufPre ) }
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
         :bEditValue       := {|| ( D():PresupuestosClientes( nView ) )->lImprimido }
         :nWidth           := 20
         :lHide            := .t.
         :SetCheck( { "Sel16", "Nil16" } )
         :AddResource( "gc_printer2_16" )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Tipo"
         :bEditValue       := {|| aTipPre[ if( ( D():PresupuestosClientes( nView ) )->lAlquiler, 2, 1 ) ] }
         :nWidth           := 50
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Número"
         :cSortOrder       := "nNumPre"
         :bEditValue       := {|| ( D():PresupuestosClientes( nView ) )->cSerPre + "/" + AllTrim( Str( ( D():PresupuestosClientes( nView ) )->nNumPre ) ) }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Delegación"
         :bEditValue       := {|| ( D():PresupuestosClientes( nView ) )->cSufPre }
         :nWidth           := 20
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Sesión"
         :bEditValue       := {|| Trans( ( D():PresupuestosClientes( nView ) )->cTurPre, "######" ) }
         :nWidth           := 40
         :lHide            := .t.
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Fecha"
         :cSortOrder       := "dDesFec"
         :bEditValue       := {|| Dtoc( ( D():PresupuestosClientes( nView ) )->dFecPre ) }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Caja"
         :bEditValue       := {|| ( D():PresupuestosClientes( nView ) )->cCodCaj }
         :nWidth           := 40
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Usuario"
         :bEditValue       := {|| ( D():PresupuestosClientes( nView ) )->cCodUsr }
         :nWidth           := 40
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Situación"
         :bEditValue       := {|| AllTrim( ( D():PresupuestosClientes( nView ) )->cSituac ) }
         :nWidth           := 80
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Código"
         :cSortOrder       := "cCodCli"
         :bEditValue       := {|| AllTrim( ( D():PresupuestosClientes( nView ) )->cCodCli ) }
         :nWidth           := 70
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Nombre"
         :cSortOrder       := "cNomCli"
         :bEditValue       := {|| ( D():PresupuestosClientes( nView ) )->cNomCli }
         :nWidth           := 180
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Código postal"
         :cSortOrder       := "CodPostal"
         :bEditValue       := {|| alltrim( ( D():PresupuestosClientes( nView ) )->cPosCli ) }
         :nWidth           := 60
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Población"
         :cSortOrder       := "Poblacion"
         :bEditValue       := {|| alltrim( ( D():PresupuestosClientes( nView ) )->cPobCli ) }
         :nWidth           := 180
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Provincia"
         :cSortOrder       := "Provincia"
         :bEditValue       := {|| alltrim( ( D():PresupuestosClientes( nView ) )->cPrvCli ) }
         :nWidth           := 100
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Agente"
         :cSortOrder       := "cCodAge"
         :bEditValue       := {|| ( D():PresupuestosClientes( nView ) )->cCodAge }
         :nWidth           := 50
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Ruta"
         :bEditValue       := {|| ( D():PresupuestosClientes( nView ) )->cCodRut }
         :nWidth           := 40
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Almacén"
         :bEditValue       := {|| ( D():PresupuestosClientes( nView ) )->cCodAlm }
         :nWidth           := 60
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Dirección"
         :cSortOrder       := "cCodObr"
         :bEditValue       := {|| ( D():PresupuestosClientes( nView ) )->cCodObr }
         :nWidth           := 50
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Base"
         :bEditValue       := {|| ( D():PresupuestosClientes( nView ) )->nTotNet }
         :cEditPicture     := cPorDiv( ( D():PresupuestosClientes( nView ) )->cDivPre, dbfDiv )
         :nWidth           := 80
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := cImp()
         :bEditValue       := {|| ( D():PresupuestosClientes( nView ) )->nTotIva }
         :cEditPicture     := cPorDiv( ( D():PresupuestosClientes( nView ) )->cDivPre, dbfDiv )
         :nWidth           := 80
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "R.E."
         :bEditValue       := {|| ( D():PresupuestosClientes( nView ) )->nTotReq }
         :cEditPicture     := cPorDiv( ( D():PresupuestosClientes( nView ) )->cDivPre, dbfDiv )
         :nWidth           := 80
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Total"
         :bEditValue       := {|| ( D():PresupuestosClientes( nView ) )->nTotPre }
         :cEditPicture     := cPorDiv( ( D():PresupuestosClientes( nView ) )->cDivPre, dbfDiv )
         :nWidth           := 80
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Div."
         :bEditValue       := {|| cSimDiv( if( lEuro, cDivChg(), ( D():PresupuestosClientes( nView ) )->cDivPre ), dbfDiv ) }
         :nWidth           := 30
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

   oDetCamposExtra:addCamposExtra( oWndBrw )

   oWndBrw:cHtmlHelp    := "Presupuestos a clientes"
   
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
      ACTION   ( GenPreCli( IS_PRINTER ), oWndBrw:Refresh() ) ;
      MENU     This:Toggle() ;
      TOOLTIP  "(I)mprimir";
      MESSAGE  "Imprimir pedidos" ;
      HOTKEY   "I";
      LEVEL    ACC_IMPR

      lGenPreCli( oWndBrw:oBrw, oPrv, IS_PRINTER ) ;

   DEFINE BTNSHELL RESOURCE "GC_PRINTER2_" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( ImprimirSeriesPresupuestosClientes() ) ;
      TOOLTIP  "Imp(r)imir series";
      HOTKEY   "R";
      LEVEL    ACC_IMPR

   DEFINE BTNSHELL oImp RESOURCE "PREV1" GROUP OF oWndBrw ;
      NOBORDER ;
      MENU     This:Toggle() ;
      ACTION   ( GenPreCli( IS_SCREEN ), oWndBrw:Refresh() ) ;
      TOOLTIP  "(P)revisualizar";
      MESSAGE  "Previsualizar pedidos" ;
      HOTKEY   "P";
      LEVEL    ACC_IMPR

      lGenPreCli( oWndBrw:oBrw, oImp, IS_SCREEN ) ;

   DEFINE BTNSHELL oPdf RESOURCE "DOCLOCK" OF oWndBrw ;
      NOBORDER ;
      MENU     This:Toggle() ;
      ACTION   ( GenPreCli( IS_PDF ) ) ;
      TOOLTIP  "Pd(f)";
      HOTKEY   "F";
      LEVEL    ACC_IMPR

      lGenPreCli( oWndBrw:oBrw, oPdf, IS_PDF ) ;

   DEFINE BTNSHELL oMail RESOURCE "GC_MAIL_EARTH_" OF oWndBrw ;
      NOBORDER ;
      MENU     This:Toggle() ;
      ACTION   ( oMailing:documentsDialog( oWndBrw:oBrw:aSelected ) ) ;
      TOOLTIP  "Correo electrónico";
      LEVEL    ACC_IMPR

   DEFINE BTNSHELL RESOURCE "gc_portable_barcode_scanner_" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( TLabelGeneratorPresupuestoClientes():New( nView ):Dialog() ) ;
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
      MESSAGE  "Seleccionar presupuestos para ser enviados" ;
      ACTION   lSnd( oWndBrw, D():PresupuestosClientes( nView ) ) ;
      HOTKEY   "V";
      LEVEL    ACC_EDIT

      DEFINE BTNSHELL RESOURCE "LBL" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( lSelectAll( oWndBrw, D():PresupuestosClientes( nView ), "lSndDoc", .t., .t., .t. ) );
         TOOLTIP  "Todos" ;
         FROM     oSnd ;
         CLOSED ;
         LEVEL    ACC_EDIT

      DEFINE BTNSHELL RESOURCE "LBL" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( lSelectAll( oWndBrw, D():PresupuestosClientes( nView ), "lSndDoc", .f., .t., .t. ) );
         TOOLTIP  "Ninguno" ;
         FROM     oSnd ;
         CLOSED ;
         LEVEL    ACC_EDIT

      DEFINE BTNSHELL RESOURCE "LBL" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( lSelectAll( oWndBrw, D():PresupuestosClientes( nView ), "lSndDoc", .t., .f., .t. ) );
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
         ACTION   ( ReplaceCreator( oWndBrw, D():PresupuestosClientes( nView ), aItmPreCli() ) ) ;
         TOOLTIP  "Cambiar campos" ;
         LEVEL    ACC_EDIT

         DEFINE BTNSHELL RESOURCE "BMPCHG" OF oWndBrw ;
            NOBORDER ;
            ACTION   ( ReplaceCreator( oWndBrw, D():PresupuestosClientesLineas( nView ), aColPreCli() ) ) ;
            TOOLTIP  "Lineas" ;
            FROM     oRpl ;
            CLOSED ;
            LEVEL    ACC_EDIT

   end if

   DEFINE BTNSHELL RESOURCE "INFO" GROUP OF oWndBrw ;
      NOBORDER ;
      ACTION   ( TTrazaDocumento():Activate( PRE_CLI, ( D():PresupuestosClientes( nView ) )->cSerPre + Str( ( D():PresupuestosClientes( nView ) )->nNumPre ) + ( D():PresupuestosClientes( nView ) )->cSufPre ) ) ;
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

      ImportScript( oWndBrw, oScript, "PresupuestosClientes" )  

   DEFINE BTNSHELL oRotor RESOURCE "ROTOR" GROUP OF oWndBrw ;
         NOBORDER ;
         MENU     This:Toggle() ;
         ACTION   ( oRotor:Expand() ) ;
         TOOLTIP  "Rotor" ;

      DEFINE BTNSHELL RESOURCE "GC_USER_" OF oWndBrw ;
            ACTION   ( EdtCli( ( D():PresupuestosClientes( nView ) )->cCodCli ) );
            TOOLTIP  "Modificar cliente" ;
            FROM     oRotor ;

      DEFINE BTNSHELL RESOURCE "INFO" OF oWndBrw ;
            ACTION   ( InfCliente( ( D():PresupuestosClientes( nView ) )->cCodCli ) );
            TOOLTIP  "Informe de cliente" ;
            FROM     oRotor ;

      DEFINE BTNSHELL RESOURCE "gc_clipboard_empty_user_" OF oWndBrw ;
            ACTION   ( if( !Empty( ( D():PresupuestosClientes( nView ) )->cCodObr ), EdtObras( ( D():PresupuestosClientes( nView ) )->cCodCli, ( D():PresupuestosClientes( nView ) )->cCodObr, dbfObrasT ), MsgStop( "No hay obra asociada al presupuesto" ) ) );
            TOOLTIP  "Modificar dirección" ;
            FROM     oRotor ;

      DEFINE BTNSHELL RESOURCE "GC_CLIPBOARD_EMPTY_USER_" OF oWndBrw ;
            ALLOW    EXIT ;
            ACTION   ( if( !( D():PresupuestosClientes( nView ) )->lEstado, PedCli( nil, nil, nil, nil, ( D():PresupuestosClientes( nView ) )->cSerPre + Str( ( D():PresupuestosClientes( nView ) )->nNumPre ) + ( D():PresupuestosClientes( nView ) )->cSufPre ), MsgStop( "El presupuesto ya ha sido aceptado" ) ) );
            TOOLTIP  "Generar pedido" ;
            FROM     oRotor ;

      DEFINE BTNSHELL RESOURCE "GC_CLIPBOARD_EMPTY_USER_" OF oWndBrw ;
            ACTION   ( Pre2Ped( ( D():PresupuestosClientes( nView ) )->cSerPre + Str( ( D():PresupuestosClientes( nView ) )->nNumPre ) + ( D():PresupuestosClientes( nView ) )->cSufPre ) );
            TOOLTIP  "Modificar pedido" ;
            FROM     oRotor ;

      DEFINE BTNSHELL RESOURCE "GC_DOCUMENT_EMPTY_" OF oWndBrw ;
            ALLOW    EXIT ;
            ACTION   ( if( !( D():PresupuestosClientes( nView ) )->lEstado, AlbCli( nil, nil, { "Presupuesto" => ( D():PresupuestosClientes( nView ) )->cSerPre + Str( ( D():PresupuestosClientes( nView ) )->nNumPre ) + ( D():PresupuestosClientes( nView ) )->cSufPre } ), MsgStop( "El presupuesto ya ha sido aceptado" ) ) );
            TOOLTIP  "Generar albarán" ;
            FROM     oRotor ;

      DEFINE BTNSHELL RESOURCE "GC_DOCUMENT_TEXT_USER_" OF oWndBrw ;
            ALLOW    EXIT ;
            ACTION   ( if( !( D():PresupuestosClientes( nView ) )->lEstado, FactCli( nil, nil, { "Presupuesto" => ( D():PresupuestosClientes( nView ) )->cSerPre + Str( ( D():PresupuestosClientes( nView ) )->nNumPre ) + ( D():PresupuestosClientes( nView ) )->cSufPre } ), MsgStop( "El presupuesto ya ha sido aceptado" ) ) );
            TOOLTIP  "Generar factura" ;
            FROM     oRotor ;

      DEFINE BTNSHELL RESOURCE "gc_note_" OF oWndBrw ;
            ALLOW    EXIT ;
            ACTION   ( PreCliNotas() );
            TOOLTIP  "Generar nota de agenda" ;
            FROM     oRotor ;

      DEFINE BTNSHELL RESOURCE "GC_CASH_REGISTER_USER_" OF oWndBrw ;
            ALLOW    EXIT ;
            ACTION   ( if( !( D():PresupuestosClientes( nView ) )->lEstado .and. empty( ( D():PresupuestosClientes( nView ) )->cNumTik ),;
                           generateTicketFromDocument( { "Presupuesto" => D():PresupuestosClientesId( nView ) } ),;
                           msgStop( "Presupuesto aceptado o convertido a ticket" ) ) );
            TOOLTIP  "Convertir a ticket" ;
            FROM     oRotor ;

   DEFINE BTNSHELL RESOURCE "END" GROUP OF oWndBrw ;
      NOBORDER ;
      ACTION   ( oWndBrw:End() ) ;
      TOOLTIP  "(S)alir";
      HOTKEY   "S"

   if SQLAjustableModel():getRolNoFiltrarVentas( Auth():rolUuid() )
      oWndBrw:oActiveFilter:SetFields( aItmPreCli() )
      oWndBrw:oActiveFilter:SetFilterType( PRE_CLI )
   end if

   ACTIVATE WINDOW oWndBrw VALID ( CloseFiles() )

   enableAcceso()

   if uFieldempresa( 'lFltYea' )
      oWndBrw:setYearCombobox()
   end if

   if !empty( cCodCli ) .or. !empty( cCodArt )
      oWndBrw:RecAdd()
      cCodCli  := nil
      cCodArt  := nil
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
   local oBrwEst
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
   local cSerie         := cNewSer( "nPreCli", dbfCount )
   local oAprovado
   local cAprovado
   local oSayGetRnt
   local cTipPre
   local oSayDias
   local oSayTxtDias
   local oBmpGeneral

   /*
   Este valor los guaradamos para detectar los posibles cambios----------------
   */

   cOldCodCli           := aTmp[ _CCODCLI ]
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

      aTmp[ _CTURPRE ]  := cCurSesion()
      aTmp[ _CCODALM ]  := oUser():cAlmacen()
      aTmp[ _CDIVPRE ]  := cDivEmp()
      aTmp[ _CCODCAJ ]  := oUser():cCaja()
      aTmp[ _CCODPGO ]  := cDefFpg()
      aTmp[ _CCODUSR ]  := Auth():Codigo()
      aTmp[ _NVDVPRE ]  := nChgDiv( aTmp[ _CDIVPRE ], dbfDiv )
      aTmp[ _LESTADO ]  := .f.
      aTmp[ _CSUFPRE ]  := RetSufEmp()
      aTmp[ _NDIAVAL ]  := nDiasValidez()
      aTmp[ _LSNDDOC ]  := .t.
      aTmp[ _CCODDLG ]  := Application():CodigoDelegacion()
      aTmp[ _LIVAINC ]  := uFieldEmpresa( "lIvaInc" )
      aTmp[ _CMANOBR ]  := padr( getConfigTraslation( "Gastos" ), 250 )
      aTmp[ _NIVAMAN ]  := nIva( dbfIva, cDefIva() )

      if !Empty( cCodCli )
         aTmp[ _CCODCLI ]  := cCodCli
      end if

   case nMode == EDIT_MODE

      if aTmp[ _LCLOPRE ] .and. !oUser():lAdministrador()
         msgStop( "El presupuesto está cerrado." )
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

      aTmp[ _DFECPRE ]   := GetSysDate()
      aTmp[ _CTURPRE ]  := cCurSesion()
      aTmp[ _LESTADO ]  := .f.
      aTmp[ _LCLOPRE ]  := .f.
      aTmp[ _CCODUSR ]  := Auth():Codigo()

   end case

   if Empty( Rtrim( aTmp[ _CSERPRE ] ) )
      aTmp[ _CSERPRE ]  := cSerie
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
   Tipo de presupuesto---------------------------------------------------------
   */

   cTipPre              := aTipPre[ if( aTmp[ _LALQUILER ], 2, 1  ) ]
   cAprovado            := if( aTmp[ _LESTADO ], "Aprobado", "" )

   if empty( aTmp[ _CTLFCLI ] )
      aTmp[ _CTLFCLI ] := RetFld( aTmp[ _CCODCLI ], D():Clientes( nView ), "Telefono" )
   end if

   /*
   Comineza la transaccion-----------------------------------------------------
   */

   if BeginTrans( aTmp, nMode )
      Return .f.
   end if

   /*
   Necestamos el orden el la primera clave-------------------------------------
   */

   nOrd                 := ( D():PresupuestosClientes( nView ) )->( ordSetFocus( 1 ) )

   cPicUnd              := MasUnd()
   cPouDiv              := cPouDiv( aTmp[ _CDIVPRE ], dbfDiv ) // Picture de la divisa
   cPorDiv              := cPorDiv( aTmp[ _CDIVPRE ], dbfDiv ) // Picture de la divisa
   nDouDiv              := nDouDiv( aTmp[ _CDIVPRE ], dbfDiv )
   nRouDiv              := nRouDiv( aTmp[ _CDIVPRE ], dbfDiv )

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

   // Inicializamos el valor de la tarifa por si cambian--------------------------

   InitTarifaCabecera( aTmp[ _NTARIFA ] )

   // Comienza el dialogo---------------------------------------------------------

   DEFINE DIALOG oDlg RESOURCE "PEDCLI" TITLE LblTitle( nMode ) + "presupuestos a clientes"

      REDEFINE FOLDER oFld ;
         ID       200 ;
         OF       oDlg ;
         PROMPT   "&Presupuesto",;
                  "Da&tos",;
                  "&Incidencias",;
                  "D&ocumentos",;
                  "&Situaciones";
         DIALOGS  "PRECLI_1",;
                  "PRECLI_2",;
                  "PEDCLI_3",;
                  "PEDCLI_4",;
                  "PEDCLI_5"

		//Cliente_________________________________________________________________

      REDEFINE BITMAP oBmpGeneral ;
        ID       990 ;
        RESOURCE "gc_notebook_user_48" ;
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

      REDEFINE BITMAP oBmpGeneral ;
        ID       990 ;
        RESOURCE "gc_document_attachment_48";
        TRANSPARENT ;
        OF       oFld:aDialogs[5]

		REDEFINE GET aGet[_CCODCLI] VAR aTmp[_CCODCLI] ;
			ID 		130 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         VALID    ( LoaCli( aGet, aTmp, nMode, oRieCli ), RecalculaTotal( aTmp ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwClient( aGet[_CCODCLI] ) ) ;
			OF 		oFld:aDialogs[1]

      REDEFINE GET aGet[_CNOMCLI] VAR aTmp[_CNOMCLI] ;
			ID 		131 ;
         WHEN     ( nMode != ZOOM_MODE .and. ( !aTmp[ _LMODCLI ] .or. oUser():lAdministrador() ) ) ;
			OF 		oFld:aDialogs[1]

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

      // Tarifas-----------------------------------

      oGetTarifa  := comboTarifa():Build( { "idCombo" => 132, "uValue" => aTmp[ _NTARIFA ] } )
      oGetTarifa:Resource( oFld:aDialogs[1] )

      REDEFINE BTNBMP oBtnPrecio ;
         ID       174 ;
         OF       oFld:aDialogs[1] ;
         RESOURCE "gc_arrow_down_16" ;
         NOBORDER ;
         ACTION   ( ChangeTarifaCabecera( oGetTarifa:getTarifa(), dbfTmpLin, oBrwLin ) );
         WHEN     ( nMode != ZOOM_MODE .and. ( SQLAjustableModel():getRolCambiarPrecios( Auth():rolUuid() ) ) )

      // Riesgo -------------------------------------------

      REDEFINE GET oRieCli VAR nRieCli;
         ID       133 ;
         WHEN     ( nMode != ZOOM_MODE );
         PICTURE  cPorDiv ;
			OF 		oFld:aDialogs[1]

      REDEFINE GET aGet[_CTLFCLI] VAR aTmp[_CTLFCLI] ;
         ID       106 ;
         COLOR    CLR_GET ;
         WHEN     ( nMode != ZOOM_MODE .and. ( !aTmp[ _LMODCLI ] .or. oUser():lAdministrador() ) ) ;
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

		// Tarifa_________________________________________________________________

		REDEFINE GET aGet[_CCODTAR] VAR aTmp[_CCODTAR] ;
			ID 		140 ;
         WHEN     ( nMode != ZOOM_MODE .and. oUser():lAdministrador() ) ;
         VALID    ( cTarifa( aGet[_CCODTAR], oSay[ 2 ] ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwTarifa( aGet[_CCODTAR], oSay[ 2 ] ) ) ;
			COLOR 	CLR_GET ;
			OF 		oFld:aDialogs[1]

      REDEFINE GET oSay[ 2 ] VAR cSay[ 2 ] ;
			WHEN 		.F. ;
			ID 		141 ;
			OF 		oFld:aDialogs[1]

		// Obra____________________________________________________________________

		REDEFINE GET aGet[_CCODOBR] VAR aTmp[_CCODOBR] ;
			ID 		150 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         VALID    ( cObras( aGet[_CCODOBR], oSay[ 3 ], aTmp[_CCODCLI], dbfObrasT ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwObras( aGet[_CCODOBR], oSay[ 3 ], aTmp[_CCODCLI], dbfObrasT ) ) ;
			COLOR 	CLR_GET ;
			OF 		oFld:aDialogs[1]

      REDEFINE GET oSay[ 3 ] VAR cSay[ 3 ] ;
			WHEN 		.F. ;
			ID 		151 ;
			OF 		oFld:aDialogs[1]

		// Almacen________________________________________________________________

      REDEFINE GET aGet[ _CCODALM ] VAR aTmp[ _CCODALM ] ;
			ID 		160 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
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

		// Forma de Pago__________________________________________________________

      REDEFINE GET aGet[ _CCODPGO ] VAR aTmp[ _CCODPGO ] ;
			ID 		170 ;
         PICTURE  "@!" ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         VALID    ( cFPago( aGet[ _CCODPGO ], dbfFPago, oSay[ 5 ] ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwFPago( aGet[ _CCODPGO ], oSay[ 5 ] ) ) ;
			OF 		oFld:aDialogs[1]

      REDEFINE GET oSay[ 5 ] VAR cSay[ 5 ] ;
			WHEN 		.F. ;
			ID 		171 ;
			OF 		oFld:aDialogs[1]

		// Agente_________________________________________________________________

      REDEFINE GET aGet[ _CCODAGE ] VAR aTmp[ _CCODAGE ] ;
			ID 		180 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         VALID    ( LoadAgente( aGet[ _CCODAGE ], dbfAgent, oSay[ 6 ], aGet[ _NPCTCOMAGE ], dbfAgeCom, dbfTmpLin, oBrwLin ), RecalculaTotal( aTmp ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwAgentes( aGet[ _CCODAGE ], oSay[ 6 ] ) ) ;
			COLOR 	CLR_GET ;
			OF 		oFld:aDialogs[1]

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
			OF 		oFld:aDialogs[1]

      REDEFINE GET oGetAge VAR nTotAge ;
			ID 		183 ;
         WHEN     ( .f. );
			OF 		oFld:aDialogs[1]

		// Ruta____________________________________________________________________

      REDEFINE GET aGet[ _CCODRUT ] VAR aTmp[ _CCODRUT ] ;
         ID       185 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         VALID    ( cRuta( aGet[ _CCODRUT ], dbfRuta, oSay[ 7 ] ) );
         BITMAP   "LUPA" ;
         ON HELP  ( BrwRuta( aGet[ _CCODRUT ], dbfRuta, oSay[ 7 ] ) );
         OF       oFld:aDialogs[1]

      REDEFINE GET oSay[ 7 ] VAR cSay[ 7 ] ;
         ID       186 ;
			WHEN 		.F. ;
         OF       oFld:aDialogs[1]

		// Divisa____________________________________________________________________

		REDEFINE GET aGet[ _CDIVPRE ] VAR aTmp[ _CDIVPRE ];
         WHEN     ( nMode == APPD_MODE .AND. ( dbfTmpLin )->( LastRec() ) == 0 ) ;
         VALID    ( cDivOut( aGet[ _CDIVPRE ], oBmpDiv, aGet[ _NVDVPRE ], @cPouDiv, @nDouDiv, @cPorDiv, @nRouDiv, nil, nil, oGetMasDiv, dbfDiv, oBandera ) );
			PICTURE	"@!";
			ID 		200 ;
			COLOR 	CLR_GET ;
         BITMAP   "LUPA" ;
         ON HELP  BrwDiv( aGet[ _CDIVPRE ], oBmpDiv, aGet[ _NVDVPRE ], dbfDiv, oBandera ) ;
			OF 		oFld:aDialogs[1]

		REDEFINE BITMAP oBmpDiv ;
         RESOURCE "BAN_EURO" ;
			ID 		201;
			OF 		oFld:aDialogs[1]

      // Bitmap________________________________________________________________

      REDEFINE BITMAP oBmpEmp ;
         FILE     "Bmp\ImgPreCli.bmp" ;
         ID       500 ;
         OF       oDlg

      // Detalle------------------------------------------------------------------

      oBrwLin                 := IXBrowse():New( oFld:aDialogs[1] )

      oBrwLin:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwLin:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }
      oBrwLin:bClrStd         := {|| { if( ( dbfTmpLin )->lKitChl, CLR_GRAY, CLR_BLACK ), GetSysColor( COLOR_WINDOW ) } }

      oBrwLin:cAlias          := dbfTmpLin

      oBrwLin:nMarqueeStyle   := 6
      oBrwLin:lFooter         := .t.   
      oBrwLin:cName           := "Presupuesto a cliente.Detalle"

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
         :bEditValue          := {|| NotCaja( ( dbfTmpLin )->nCanPre ) }
         :cEditPicture        := cPicUnd
         :nWidth              := 60
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
         :lHide               := .t.
         :nFooterType         := AGGR_SUM
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader             := cNombreUnidades()
         :bEditValue          := {|| nTotNPreCli( dbfTmpLin ) }
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
         :bEditValue          := {|| nImpUPreCli( dbfTmpLin, nDouDiv ) }
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
         :bEditValue          := {|| nDtoUPreCli( dbfTmpLin, nDouDiv ) }
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
         :bEditValue          := {|| nTrnUPreCli( dbfTmpLin, nDouDiv ) }
         :cEditPicture        := cPouDiv
         :nWidth              := 70
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
         :lHide               := .t.
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader             := "P. verde"
         :bEditValue          := {|| nPntUPreCli( dbfTmpLin, nDouDiv ) }
         :cEditPicture        := cPouDiv
         :nWidth              := 70
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
         :lHide               := .t.
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader             := "Total"
         :bEditValue          := {|| nTotLPreCli( dbfTmpLin, nDouDiv, nRouDiv, , , aTmp[ _LOPERPV ] ) }
         :cEditPicture        := cPorDiv
         :nWidth              := 80
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
         :nFooterType         := AGGR_SUM
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader             := "Familia"
         :bEditValue          := {|| ( dbfTmpLin )->cCodFam }
         :nWidth              := 35
         :lHide               := .t.
      end with

      if nMode != ZOOM_MODE
         oBrwLin:bLDblClick  := {|| EdtDeta( oBrwLin, bEdtDet, aTmp ) }
      end if

		// Descuentos______________________________________________________________

      REDEFINE GET aGet[ _CDTOESP ] VAR aTmp[ _CDTOESP ] ;
         ID       219 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			OF 		oFld:aDialogs[1]

      REDEFINE GET aGet[ _NDTOESP ] VAR aTmp[ _NDTOESP ] ;
			ID 		220 ;
			PICTURE 	"@E 99.99" ;
         SPINNER ;
         VALID    ( RecalculaTotal( aTmp ) );
         ON CHANGE( RecalculaTotal( aTmp ) );
         WHEN     ( nMode != ZOOM_MODE ) ;
			OF 		oFld:aDialogs[1]

      REDEFINE GET aGet[ _CDPP ] VAR aTmp[ _CDPP ] ;
         ID       229 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			OF 		oFld:aDialogs[1]

		REDEFINE GET aGet[ _NDPP ] VAR aTmp[ _NDPP ];
			ID 		230 ;
			PICTURE 	"@E 99.99" ;
         SPINNER ;
         VALID    ( RecalculaTotal( aTmp ) );
         ON CHANGE( RecalculaTotal( aTmp ) );
         WHEN     ( nMode != ZOOM_MODE ) ;
			OF 		oFld:aDialogs[1]

		REDEFINE GET aGet[ _CDTOUNO ] VAR aTmp[ _CDTOUNO ] ;
			ID 		240 ;
			PICTURE 	"@!" ;
         COLOR    CLR_GET ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			OF 		oFld:aDialogs[1]

		REDEFINE GET aGet[ _NDTOUNO ] VAR aTmp[ _NDTOUNO ];
			ID 		250 ;
			PICTURE 	"@E 99.99" ;
         SPINNER ;
         COLOR    CLR_GET ;
         VALID    ( RecalculaTotal( aTmp ) );
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
         VALID    ( RecalculaTotal( aTmp ) );
         ON CHANGE( RecalculaTotal( aTmp ) );
         WHEN     ( nMode != ZOOM_MODE ) ;
			OF 		oFld:aDialogs[1]

      // Desglose del impuestos---------------------------------------------------------

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

      // Cajas de Totales

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
			WHEN 		( nMode != ZOOM_MODE ) ;
         ON CHANGE( RecalculaTotal( aTmp ), oBrwLin:Refresh() );
			OF 		oFld:aDialogs[1]

      REDEFINE SAY oGetPnt VAR nTotPnt ;
         ID       404 ;
         OF       oFld:aDialogs[1]

      REDEFINE SAY oGetIva VAR nTotIva ;
         ID       405 ;
         OF       oFld:aDialogs[1]

      REDEFINE CHECKBOX aGet[ _LRECARGO ] VAR aTmp[ _LRECARGO ] ;
         ID       406 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ON CHANGE( RecalculaTotal( aTmp ) );
			OF 		oFld:aDialogs[1]

      REDEFINE CHECKBOX oImpuestos VAR lImpuestos ;
         ID       711 ;
         WHEN     ( .f. ) ;
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
			FONT 		oFont ;
			OF 		oFld:aDialogs[1]

      REDEFINE SAY oGetTotal VAR nTotPre ;
         ID       420 ;
			FONT 		oFont ;
			OF 		oFld:aDialogs[1]

		// Botones de la caja de dialogo___________________________________________

		REDEFINE BUTTON ;
			ID 		515 ;
			OF 		oFld:aDialogs[1] ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( AppDeta( oBrwLin, bEdtDet, aTmp, .t. ) )

		REDEFINE BUTTON ;
			ID 		500 ;
			OF 		oFld:aDialogs[1] ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( AppDeta( oBrwLin, bEdtDet, aTmp, .f. ) )

		REDEFINE BUTTON ;
			ID 		501 ;
			OF 		oFld:aDialogs[1] ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( EdtDeta( oBrwLin, bEdtDet, aTmp ) )

		REDEFINE BUTTON ;
			ID 		502 ;
			OF 		oFld:aDialogs[1] ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( DelDeta( oBrwLin, aTmp ), oTipPre:Refresh() )

		REDEFINE BUTTON ;
			ID 		503 ;
			OF 		oFld:aDialogs[1] ;
         ACTION   ( EdtZoom( oBrwLin, bEdtDet, aTmp ) )

		REDEFINE BUTTON ;
			ID 		524 ;
			OF 		oFld:aDialogs[1] ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( LineUp( dbfTmpLin, oBrwLin ) )

		REDEFINE BUTTON ;
			ID 		525 ;
			OF 		oFld:aDialogs[1] ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( LineDown( dbfTmpLin, oBrwLin ) )

      REDEFINE BUTTON oBtnKit;
         ID       526 ;
			OF 		oFld:aDialogs[1] ;
         ACTION   ( ShowKit( D():PresupuestosClientes( nView ), dbfTmpLin, oBrwLin ) )

      REDEFINE BUTTON ;
         ID       527 ;
         OF       oFld:aDialogs[1] ;
         ACTION   ( importarArticulosScaner() )

      REDEFINE GET aGet[_CSERPRE] VAR aTmp[_CSERPRE] ;
         ID       90 ;
         PICTURE  "@!" ;
			COLOR 	CLR_GET ;
         SPINNER ;
         ON UP    ( UpSerie( aGet[_CSERPRE] ) );
         ON DOWN  ( DwSerie( aGet[_CSERPRE] ) );
         WHEN     ( nMode == APPD_MODE .OR. nMode == DUPL_MODE );
         VALID    ( aTmp[_CSERPRE] >= "A" .AND. aTmp[_CSERPRE] <= "Z"  );
         OF       oFld:aDialogs[1]

		REDEFINE GET aGet[_NNUMPRE] VAR aTmp[_NNUMPRE];
			ID 		100 ;
			PICTURE 	"999999999" ;
			WHEN 		.F. ;
			OF 		oFld:aDialogs[1]

		REDEFINE GET aGet[_CSUFPRE] VAR aTmp[_CSUFPRE];
			ID 		105 ;
			WHEN 		.F. ;
			OF 		oFld:aDialogs[1]

		REDEFINE GET aGet[_DFECPRE] VAR aTmp[_DFECPRE];
			ID 		110 ;
			SPINNER;
			WHEN 		( nMode != ZOOM_MODE ) ;
			COLOR 	CLR_GET ;
			OF 		oFld:aDialogs[1]

      REDEFINE GET aGet[ _DFECSAL ] VAR aTmp[ _DFECSAL ];
         ID       111 ;
         IDSAY    114 ;
			SPINNER;
			WHEN 		( nMode != ZOOM_MODE ) ;
			COLOR 	CLR_GET ;
         ON CHANGE( oSayDias:Refresh() );
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _DFECENTR ] VAR aTmp[ _DFECENTR ];
         ID       112 ;
         IDSAY    115 ;
			SPINNER;
			WHEN 		( nMode != ZOOM_MODE ) ;
         COLOR    CLR_GET ;
         ON CHANGE( oSayDias:Refresh() );
         OF       oFld:aDialogs[1]

      REDEFINE SAY oSayDias ;
         VAR      ( aTmp[ _DFECENTR ] - aTmp[ _DFECSAL ] );
         ID       113 ;
         PICTURE  "9999" ;
         OF       oFld:aDialogs[1]

      REDEFINE SAY oSayTxtDias ;
         ID       116 ;
         OF       oFld:aDialogs[1]

      REDEFINE GET oAprovado VAR cAprovado ;
			ID 		120 ;
         IDSAY    121 ;
			WHEN 		( .F. ) ;
			OF 		oFld:aDialogs[1]

      REDEFINE COMBOBOX aGet[ _CSITUAC ] VAR aTmp[ _CSITUAC ] ;
         ID       218 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ITEMS    ( SituacionesRepository():getNombres() ) ;
         OF       oFld:aDialogs[1]

      REDEFINE COMBOBOX oTipPre VAR cTipPre ;
         ID       217 ;
         WHEN     ( ( dbfTmpLin )->( LastRec() ) == 0 ) ;
         ITEMS    aTipPre ;
         ON CHANGE(SetDialog( aGet, oSayDias, oSayTxtDias, oSayGetRnt, oGetRnt ) );
         OF       oFld:aDialogs[1]

		REDEFINE GET aGet[_CSUPRE] VAR aTmp[_CSUPRE] ;
         ID       122 ;
         IDSAY    123 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

      REDEFINE CHECKBOX aGet[_LIVAINC] VAR aTmp[_LIVAINC] ;
         ID       129 ;
         WHEN     ( nMode != ZOOM_MODE .and. ( dbfTmpLin )->( ordkeycount() ) == 0 ) ;
         OF       oFld:aDialogs[1]

      //Segunda caja de dialogo

      REDEFINE GET aGet[ _CCODDLG ] VAR aTmp[ _CCODDLG ] ;
         ID       300 ;
         WHEN     ( .f. ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET oSay[ 11 ] VAR cSay[ 11 ] ;
         ID       301 ;
         WHEN     ( .f. ) ;
         OF       oFld:aDialogs[2]

      // Transportistas-----------------------------------------------------------

      REDEFINE GET aGet[ _CCODTRN ] VAR aTmp[ _CCODTRN ] ;
         ID       235 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         VALID    ( LoadTrans( aTmp, aGet[ _CCODTRN ], aGet[ _NKGSTRN ], oSay[ 8 ] ) );
         BITMAP   "LUPA" ;
         ON HELP  ( oTrans:Buscar( aGet[ _CCODTRN ] ), .t. );
         OF       oFld:aDialogs[2]

      REDEFINE GET oSay[ 8 ] VAR cSay[ 8 ] ;
         ID       236 ;
			WHEN 		.F. ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ _NKGSTRN ] VAR aTmp[ _NKGSTRN ] ;
         ID       237 ;
         WHEN     ( .f. ) ;
         PICTURE  ( MasUnd() ) ;
         OF       oFld:aDialogs[2]

		// Cajas____________________________________________________________________

      REDEFINE GET aGet[ _CCODCAJ ] VAR aTmp[ _CCODCAJ ];
			WHEN 		( nMode != ZOOM_MODE ) ;
         VALID    cCajas( aGet[ _CCODCAJ ], dbfCajT, oSay[ 9 ] ) ;
         ID       165 ;
			COLOR 	CLR_GET ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwCajas( aGet[ _CCODCAJ ], oSay[ 9 ] ) ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET oSay[ 9 ] VAR cSay[ 9 ] ;
         ID       166 ;
         WHEN     .f. ;
			COLOR 	CLR_GET ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ _CCENTROCOSTE ] VAR aTmp[ _CCENTROCOSTE ] ;
         ID       350 ;
         IDTEXT   351 ;
         BITMAP   "LUPA" ;
         VALID    ( oCentroCoste:Existe( aGet[ _CCENTROCOSTE ], aGet[ _CCENTROCOSTE ]:oHelpText, "cNombre" ) );
         ON HELP  ( oCentroCoste:Buscar( aGet[ _CCENTROCOSTE ] ) ) ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[2]

     REDEFINE GET aGet[_NBULTOS] VAR aTmp[_NBULTOS];
         ID       128 ;
			SPINNER;
         PICTURE  "99999" ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			COLOR 	CLR_GET ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ _NDIAVAL ] VAR aTmp[ _NDIAVAL ];
         ID       219 ;
         PICTURE  "999" ;
			SPINNER;
			WHEN 		( nMode != ZOOM_MODE ) ;
			COLOR 	CLR_GET ;
         OF       oFld:aDialogs[2]

      // Retirado por________________________________________________________________

      REDEFINE GET aGet[_CRETPOR] VAR aTmp[_CRETPOR] ;
         ID       160 ;
			COLOR 	CLR_GET ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[_CRETMAT] VAR aTmp[_CRETMAT] ;
         ID       170 ;
			COLOR 	CLR_GET ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[2]

		// Comentarios_____________________________________________________________

      REDEFINE GET aGet[_DFECENT] VAR aTmp[_DFECENT];
         ID       127 ;
			SPINNER;
			WHEN 		( nMode != ZOOM_MODE ) ;
			COLOR 	CLR_GET ;
         OF       oFld:aDialogs[2]

		REDEFINE GET aGet[_CCONDENT] VAR aTmp[_CCONDENT] ;
			ID 		230 ;
			COLOR 	CLR_GET ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			OF 		oFld:aDialogs[2]

		REDEFINE GET aGet[_MCOMENT] VAR aTmp[_MCOMENT] MEMO ;
         ID       250 ;
			COLOR 	CLR_GET ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			OF 		oFld:aDialogs[2]

		REDEFINE GET aGet[_MOBSERV] VAR aTmp[_MOBSERV] MEMO ;
         ID       240 ;
			COLOR 	CLR_GET ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			OF 		oFld:aDialogs[2]

      // Impresión ( informa de si está impreimido o no y de cuando se imprimió )-

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

      // Incidencias--------------------------------------------------------------

      oBrwInc                 := IXBrowse():New( oFld:aDialogs[ 3 ] )

      oBrwInc:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwInc:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrwInc:cAlias          := dbfTmpInc

      oBrwInc:nMarqueeStyle   := 6
      oBrwInc:cName           := "Presupuesto a cliente.Incidencias"

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
         ACTION   ( WinDelRec( oBrwInc, dbfTmpInc ) )

		REDEFINE BUTTON ;
			ID 		503 ;
         OF       oFld:aDialogs[ 3 ] ;
         ACTION   ( WinZooRec( oBrwInc, bEdtInc, dbfTmpInc ) )

      // Caja de diálogo de documentos

      oBrwDoc                 := IXBrowse():New( oFld:aDialogs[ 4 ] )

      oBrwDoc:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwDoc:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrwDoc:cAlias          := dbfTmpDoc

      oBrwDoc:nMarqueeStyle   := 6
      oBrwDoc:nRowHeight      := 40
      oBrwDoc:nDataLines      := 2

      with object ( oBrwDoc:AddCol() )
         :cHeader             := "Documento"
         :bEditValue          := {|| Rtrim( ( dbfTmpDoc )->cNombre ) + CRLF + Space( 5 ) + Rtrim( ( dbfTmpDoc )->cRuta ) }
         :nWidth              := 960
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
         ACTION   ( WinDelRec( oBrwDoc, dbfTmpDoc ) )

		REDEFINE BUTTON ;
			ID 		503 ;
         OF       oFld:aDialogs[ 4 ] ;
         ACTION   ( WinZooRec( oBrwDoc, bEdtDoc, dbfTmpDoc ) )

      REDEFINE BUTTON ;
         ID       504 ;
         OF       oFld:aDialogs[ 4 ] ;
         ACTION   ( ShellExecute( oDlg:hWnd, "open", rTrim( ( dbfTmpDoc )->cRuta ) ) )

      // Situaciones--------------------------------------------------------------

      oBrwEst                 := IXBrowse():New( oFld:aDialogs[ 5 ] )

      oBrwEst:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwEst:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrwEst:cAlias          := dbfTmpEst

      oBrwEst:nMarqueeStyle   := 6
      oBrwEst:cName           := "Presupuesto de cliente.Situaciones"

         with object ( oBrwEst:AddCol() )
            :cHeader          := "Nombre"
            :bEditValue       := {|| ( dbfTmpEst )->cSitua }
            :nWidth           := 140
         end with

         with object ( oBrwEst:AddCol() )
            :cHeader          := "Fecha"
            :bEditValue       := {|| Dtoc( ( dbfTmpEst )->dFecSit ) }
            :nWidth           := 90
            :nDataStrAlign    := 1
            :nHeadStrAlign    := 1
         end with

         with object ( oBrwEst:AddCol() )
            :cHeader          := "Hora"
            :bEditValue       := {|| trans( ( dbfTmpEst )->tFecSit, "@R 99:99:99" ) }
            :nWidth           := 90
         end with

         if nMode != ZOOM_MODE
            oBrwEst:bLDblClick   := {|| WinEdtRec( oBrwEst, bEdtEst, dbfTmpEst, nil, nil, aTmp ) }
         end if

         oBrwEst:CreateFromResource( 210 )

      REDEFINE BUTTON ;
         ID       500 ;
         OF       oFld:aDialogs[ 5 ] ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( WinAppRec( oBrwEst, bEdtEst, dbfTmpEst, nil, nil, aTmp ) )

      REDEFINE BUTTON ;
         ID       501 ;
         OF       oFld:aDialogs[ 5 ] ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( WinEdtRec( oBrwEst, bEdtEst, dbfTmpEst, nil, nil, aTmp ) )


      REDEFINE BUTTON ;
         ID        502 ;
         OF       oFld:aDialogs[ 5 ] ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( WinDelRec( oBrwEst, dbfTmpEst ) )


      REDEFINE BUTTON ;
         ID        503 ;
         OF       oFld:aDialogs[ 5 ] ;
         ACTION   ( WinZooRec( oBrwEst, bEdtEst, dbfTmpEst, nil, nil, aTmp ) )

		// Botones comunes a la caja de dialogo____________________________________

      REDEFINE BUTTON ;
         ID       3 ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( RecPreCli( aTmp ), oBrwLin:Refresh( .t. ), RecalculaTotal( aTmp ) )

		REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( EndTrans( aTmp, aGet, nMode, oBrwLin, oBrw, oBrwInc, oDlg ) )

      REDEFINE BUTTON ;
         ID       4 ;
			OF 		oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( if( EndTrans( aTmp, aGet, nMode, oBrwLin, oBrw, oBrwInc, oDlg ), GenPreCli( IS_PRINTER ), ) )

      REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
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
      oFld:aDialogs[1]:AddFastKey( VK_F4, {|| DelDeta( oBrwLin, aTmp ), oTipPre:Refresh() } )

      oFld:aDialogs[3]:AddFastKey( VK_F2, {|| WinAppRec( oBrwInc, bEdtInc, dbfTmpInc, nil, nil, aTmp ) } )
      oFld:aDialogs[3]:AddFastKey( VK_F3, {|| WinEdtRec( oBrwInc, bEdtInc, dbfTmpInc, nil, nil, aTmp ) } )
      oFld:aDialogs[3]:AddFastKey( VK_F4, {|| WinDelRec( oBrwInc, dbfTmpInc ) } )

      oFld:aDialogs[4]:AddFastKey( VK_F2, {|| WinAppRec( oBrwDoc, bEdtDoc, dbfTmpDoc, nil, nil, aTmp ) } )
      oFld:aDialogs[4]:AddFastKey( VK_F3, {|| WinEdtRec( oBrwDoc, bEdtDoc, dbfTmpDoc, nil, nil, aTmp ) } )
      oFld:aDialogs[4]:AddFastKey( VK_F4, {|| WinDelRec( oBrwDoc, dbfTmpDoc ) } )

      oFld:aDialogs[5]:AddFastKey( VK_F2, {|| WinAppRec( oBrwEst, bEdtEst, dbfTmpEst, nil, nil, aTmp ) } )
      oFld:aDialogs[5]:AddFastKey( VK_F3, {|| WinEdtRec( oBrwEst, bEdtEst, dbfTmpEst, nil, nil, aTmp ) } )
      oFld:aDialogs[5]:AddFastKey( VK_F4, {|| WinDelRec( oBrwEst, dbfTmpEst ) } )

      oDlg:AddFastKey( VK_F5, {|| EndTrans( aTmp, aGet, nMode, oBrwLin, oBrw, oBrwInc, oDlg ) } )
      oDlg:AddFastKey( VK_F6, {|| if( EndTrans( aTmp, aGet, nMode, oBrwLin, oBrw, oBrwInc, oDlg ), GenPreCli( IS_PRINTER ), ) } )
      oDlg:AddFastKey( VK_F9, {|| oDetCamposExtra:Play( space(1) ) } )

      oDlg:AddFastKey( 65,    {|| if( GetKeyState( VK_CONTROL ), CreateInfoArticulo(), ) } )

   end if

   CodigosPostales():GetInstance():setBinding( { "CodigoPostal" => aGet[ _CPOSCLI ], "Poblacion" => aGet[ _CPOBCLI ], "Provincia" => aGet[ _CPRVCLI ] } )

   do case
      case nMode == APPD_MODE .and. lRecogerUsuario() .and. Empty( cCodArt )
         oDlg:bStart := {|| if( lGetUsuario( aGet[ _CCODUSR ], dbfUsr ), , oDlg:End() ) }

      case nMode == APPD_MODE .and. lRecogerUsuario() .and. !Empty( cCodArt )
         oDlg:bStart := {|| if( lGetUsuario( aGet[ _CCODUSR ], dbfUsr ), AppDeta( oBrwLin, bEdtDet, aTmp, nil, cCodArt ), oDlg:End() ) }

      case nMode == APPD_MODE .and. !lRecogerUsuario() .and. !Empty( cCodArt )
         oDlg:bStart := {|| AppDeta( oBrwLin, bEdtDet, aTmp, nil, cCodArt ) }

      otherwise
         oDlg:bStart := {|| ShowKit( D():PresupuestosClientes( nView ), dbfTmpLin, oBrwLin, .f., dbfTmpInc, cCodCli, D():Clientes( nView ), oGetRnt, aGet, oSayGetRnt ) }

   end case

	ACTIVATE DIALOG oDlg;
      ON PAINT (  RecalculaTotal( aTmp ) );
      ON INIT  (  EdtRecMenu( aTmp, oDlg ) ,;
                  SetDialog( aGet, oSayDias, oSayTxtDias, oSayGetRnt, oGetRnt ) ,;
                  oBrwLin:Load() ,;
                  oBrwInc:Load() );
      CENTER

   oMenu:End()

   oBmpEmp:end()
   oBmpDiv:end()
   oBmpGeneral:End()

   ( D():PresupuestosClientes( nView ) )->( ordSetFocus( nOrd ) )

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
               ACTION   ( if( !Empty( aTmp[ _CCODOBR ] ), EdtObras( aTmp[ _CCODCLI ], aTmp[ _CCODOBR ], dbfObrasT ), MsgStop( "No hay obra asociada para el presupuesto" ) ) )

            SEPARATOR

            end if

            MENUITEM    "&6. Informe del documento";
               MESSAGE  "Abrir el informe del documento" ;
               RESOURCE "Info16" ;
               ACTION   ( TTrazaDocumento():Activate( PRE_CLI, aTmp[ _CSERPRE ] + Str( aTmp[ _NNUMPRE ] ) + aTmp[ _CSUFPRE ] ) )

            MENUITEM    "&7. Firmar documento";
               MESSAGE  "Firmar documento" ;
               RESOURCE "gc_sign_document_16" ;
               ACTION   ( if( empty( aTmp[ _MFIRMA ] ) .or.  msgNoYes( "El documento ya esta firmado, ¿Desea voler a firmarlo?" ),;
                              aTmp[ _MFIRMA ] := signatureToMemo(),;
                              ) ) 

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

   local lKitArt  := ( dbfTmpLin )->lKitArt
   local nNumLin  := ( dbfTmpLin )->nNumLin

   if lKitArt
      DbDelKit( oBrwLin, dbfTmpLin, nNumLin )
   end if

   WinDelRec( oBrwLin, dbfTmpLin, , {|| if( lKitArt, DbDelKit( oBrwLin, dbfTmpLin, nNumLin ), ) } )

   RecalculaTotal( aTmp )

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

STATIC FUNCTION EdtDet( aTmp, aGet, dbf, oBrw, lTotLin, cCodArtEnt, nMode, aTmpPre )

   local oDlg
   local oFld
   local oBtn
	local oTotal
   local nTotPreCli
   local cGet3
   local oGet3
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
   local oSayGrp
   local cSayGrp           := ""
   local oSayFam
   local cSayFam           := ""
   local oStkAct
   local nStkAct           := 0
   local cCodArt           := Padr( aTmp[ _CREF ], 200 )
   local oRentLin
   local cRentLin
   local cCodDiv           := aTmpPre[ _CDIVPRE ]
   local oSayDias

   DEFAULT lTotLin         := .f.

   SysRefresh()

   cTipoCtrCoste           := AllTrim( aTmp[ _CTIPCTR ] )

   do case
   case nMode == APPD_MODE
      aTmp[ _CSERPRE  ]    := aTmpPre[ _CSERPRE ]
      aTmp[ _NNUMPRE  ]    := aTmpPre[ _NNUMPRE ]
      aTmp[ _CSUFPRE  ]    := aTmpPre[ _CSUFPRE ]
      aTmp[ _NUNICAJA ]    := 1
      aTmp[ _LTOTLIN  ]    := lTotLin
      aTmp[ _NCANPRE  ]    := 1
      aTmp[ _LIVALIN  ]    := aTmpPre[ _LIVAINC ]
      aTmp[ _CALMLIN  ]    := aTmpPre[ _CCODALM ]
      aTmp[ _NTARLIN  ]    := oGetTarifa:getTarifa()
      aTmp[ _DFECCAD  ]    := Ctod( "" )
      aTmp[ __DFECSAL ]    := aTmpPre[ _DFECSAL ]
      aTmp[ __DFECENT ]    := aTmpPre[ _DFECENTR ]
      aTmp[ __LALQUILER ]  := !Empty( oTipPre ) .and. ( oTipPre:nAt == 2 )
      aTmp[ _COBRLIN ]     := aTmpPre[ _CCODOBR ]

      if !Empty( cCodArtEnt )
         cCodArt           := Padr( cCodArtEnt, 200 )
      end if

      cTipoCtrCoste        := "Centro de coste"

   case nMode == EDIT_MODE
      lTotLin              := aTmp[ _LTOTLIN ]

   end case

   /*
   Este valor los guaradamos para detectar los posibles cambios----------------
   */

   cOldCodArt              := aTmp[ _CREF    ]
   cOldPrpArt              := aTmp[ _CCODPR1 ] + aTmp[ _CCODPR2 ] + aTmp[ _CVALPR1 ] + aTmp[ _CVALPR2 ]
   cOldUndMed              := aTmp[ _CUNIDAD ]

   /*
   Etiquetas de familias y grupos de familias----------------------------------
   */

   cSayGrp                 := RetFld( aTmp[ _CGRPFAM ], oGrpFam:GetAlias() )
   cSayFam                 := RetFld( aTmp[ _CCODFAM ], dbfFamilia )

   DEFINE DIALOG oDlg RESOURCE "LFACCLI" TITLE LblTitle( nMode ) + "líneas de presupuestos a clientes"

      REDEFINE FOLDER oFld ;
         ID       400 ;
         OF       oDlg ;
         PROMPT   "&General",;
                  "Da&tos",;
                  "&Observaciones",;
                  "&Centro coste";
         DIALOGS  "LFACCLI_1",;
                  "LALBCLI_2",;
                  "LFACCLI_3",;
                  "LCTRCOSTE"

      REDEFINE GET aGet[ _CREF ] VAR cCodArt;
         ID       100 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( LoaArt( cCodArt, aTmp, aGet, aTmpPre, oStkAct, oSayPr1, oSayPr2, oSayVp1, oSayVp2, bmpImage,  nMode ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwArticulo( aGet[ _CREF ], aGet[ _CDETALLE ], .f., .t., oBtn, aGet[ _CLOTE ], aTmp[ _CCODPR1 ], aTmp[ _CCODPR2 ], aGet[ _CVALPR1 ], aGet[ _CVALPR2 ], aGet[ _DFECCAD ], if( uFieldEmpresa( "lStockAlm" ), aTmp[ _CALMLIN ], nil ) ) ) ;
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

      REDEFINE GET aGet[ _CLOTE ] VAR aTmp[ _CLOTE ];
         ID       112 ;
         IDSAY    113 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
			OF 		oFld:aDialogs[1]

         aGet[ _CLOTE ]:bValid   := {|| oStock:lPutStockActual( aTmp[ _CREF ], aTmp[ _CALMLIN ], aTmp[ _CVALPR1 ], aTmp[ _CVALPR2 ], aTmp[ _CLOTE ], aTmp[ _LKITART ], aTmp[ _NCTLSTK ], oStkAct ) }

      /*
      Fecha caducidad
      -------------------------------------------------------------------------
      */

      REDEFINE GET aGet[ _DFECCAD ] VAR aTmp[ _DFECCAD ];
         ID       340 ;
         IDSAY    341 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

      // Propiedades-------------------------------------------------

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

      REDEFINE GET aGet[ _CVALPR1 ] ;
         VAR      aTmp[ _CVALPR1 ];
         ID       270 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         BITMAP   "LUPA" ;
         VALID    ( if( lPrpAct( aTmp[ _CVALPR1 ], oSayVp1, aTmp[ _CCODPR1 ], dbfTblPro ),;
                        LoaArt( cCodArt, aTmp, aGet, aTmpPre, oStkAct, oSayPr1, oSayPr2, oSayVp1, oSayVp2, bmpImage,  nMode, .f. ),;
                        .f. ) );
         ON HELP  ( brwPropiedadActual( aGet[ _CVALPR1 ], oSayVp1, aTmp[ _CCODPR1 ] ) ) ;
         OF       oFld:aDialogs[1]

         aGet[ _CVALPR1 ]:bChange   := {|| aGet[ _CVALPR1 ]:Assign(), oStock:lPutStockActual( aTmp[ _CREF ], aTmp[ _CALMLIN ], aTmp[ _CVALPR1 ], aTmp[ _CVALPR2 ], aTmp[ _CLOTE ], aTmp[ _LKITART ], aTmp[ _NCTLSTK ], oStkAct ) }

      REDEFINE SAY oSayPr1 ;
         VAR      cSayPr1;
         ID       271 ;
         OF       oFld:aDialogs[1]

      REDEFINE GET oSayVp1 ;
         VAR      cSayVp1;
         ID       272 ;
         WHEN     .f. ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CVALPR2 ] ;
         VAR      aTmp[ _CVALPR2 ];
         ID       280 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         BITMAP   "LUPA" ;
         VALID    ( if( lPrpAct( aTmp[_CVALPR2], oSayVp2, aTmp[_CCODPR2 ], dbfTblPro ),;
                        LoaArt( cCodArt, aTmp, aGet, aTmpPre, oStkAct, oSayPr1, oSayPr2, oSayVp1, oSayVp2, bmpImage,  nMode, .f. ),;
                        .f. ) );
         ON HELP  ( brwPropiedadActual( aGet[_CVALPR2], oSayVp2, aTmp[_CCODPR2 ] ) ) ;
         OF       oFld:aDialogs[1]

         aGet[ _CVALPR2 ]:bChange   := {|| aGet[ _CVALPR2 ]:Assign(), oStock:lPutStockActual( aTmp[ _CREF ], aTmp[ _CALMLIN ], aTmp[ _CVALPR1 ], aTmp[ _CVALPR2 ], aTmp[ _CLOTE ], aTmp[ _LKITART ], aTmp[ _NCTLSTK ], oStkAct ) }

      REDEFINE SAY oSayPr2 ;
         VAR      cSayPr2;
         ID       281 ;
         OF       oFld:aDialogs[1]

      REDEFINE GET oSayVp2 ;
         VAR      cSayVp2;
         ID       282 ;
         WHEN     .f. ;
         OF       oFld:aDialogs[1]

      // fin de propiedades----------------------------------------------------

      REDEFINE GET aGet[ _CUNIDAD ] VAR aTmp[ _CUNIDAD ] ;
         ID       170 ;
         IDTEXT   171 ;
         BITMAP   "LUPA" ;
         VALID    ( oUndMedicion:Existe( aGet[ _CUNIDAD ], aGet[ _CUNIDAD ]:oHelpText, "cNombre" ), ValidaMedicion( aTmp, aGet ) );
         ON HELP  ( oUndMedicion:Buscar( aGet[ _CUNIDAD ] ), ValidaMedicion( aTmp, aGet ) ) ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

      // Campos de las descripciones de la unidad de medición

      REDEFINE GET aGet[ ( D():PresupuestosClientesLineas( nView ) )->( fieldpos( "nMedUno" ) ) ] ;
         VAR      aTmp[ ( D():PresupuestosClientesLineas( nView ) )->( fieldpos( "nMedUno" ) ) ] ;
         ID       520 ;
         IDSAY    521 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ON CHANGE( RecalculaLinea( aTmp, aTmpPre, nDouDiv, oTotal, oRentLin, cCodDiv ) );
         PICTURE  MasUnd() ;
         OF       oFld:aDialogs[1]

         aGet[ ( D():PresupuestosClientesLineas( nView ) )->( fieldpos( "nMedUno" ) ) ]:oSay:SetColor( CLR_BLUE )

      REDEFINE GET aGet[ ( D():PresupuestosClientesLineas( nView ) )->( fieldpos( "nMedDos" ) ) ] ;
         VAR      aTmp[ ( D():PresupuestosClientesLineas( nView ) )->( fieldpos( "nMedDos" ) ) ] ;
         ID       530 ;
         IDSAY    531 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ON CHANGE( RecalculaLinea( aTmp, aTmpPre, nDouDiv, oTotal, oRentLin, cCodDiv ) );
         PICTURE  MasUnd() ;
         OF       oFld:aDialogs[1]

         aGet[ ( D():PresupuestosClientesLineas( nView ) )->( fieldpos( "nMedDos" ) ) ]:oSay:SetColor( CLR_BLUE )

      REDEFINE GET aGet[ ( D():PresupuestosClientesLineas( nView ) )->( fieldpos( "nMedTre" ) ) ] ;
         VAR      aTmp[ ( D():PresupuestosClientesLineas( nView ) )->( fieldpos( "nMedTre" ) ) ] ;
         ID       540 ;
         IDSAY    541 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ON CHANGE( RecalculaLinea( aTmp, aTmpPre, nDouDiv, oTotal, oRentLin, cCodDiv ) );
         PICTURE  MasUnd() ;
         OF       oFld:aDialogs[1]

         aGet[ ( D():PresupuestosClientesLineas( nView ) )->( fieldpos( "nMedTre" ) ) ]:oSay:SetColor( CLR_BLUE )

      REDEFINE GET aGet[ _NIVA ] VAR aTmp[ _NIVA ] ;
         ID       120 ;
         WHEN     ( lModIva() .AND. nMode != ZOOM_MODE .AND. !lTotLin ) ;
         PICTURE  "@E 99.99" ;
         COLOR    CLR_GET ;
         VALID    ( lTiva( dbfIva, aTmp[ _NIVA ], @aTmp[ _NREQ ] ) );
         BITMAP   "LUPA" ;
         ON HELP  ( BrwIva( aGet[ _NIVA ], dbfIva, , .t. ) ) ;
         OF       oFld:aDialogs[1]

      if aTmp[ __LALQUILER ]

      REDEFINE GET aGet[ __DFECSAL ] VAR aTmp[ __DFECSAL ];
         ID       420 ;
			SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( RecalculaLinea( aTmp, aTmpPre, nDouDiv, oTotal, oRentLin, cCodDiv ) );
         ON CHANGE( RecalculaLinea( aTmp, aTmpPre, nDouDiv, oTotal, oRentLin, cCodDiv ), oSayDias:Refresh() );
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ __DFECENT ] VAR aTmp[ __DFECENT ];
         ID       430 ;
			SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( RecalculaLinea( aTmp, aTmpPre, nDouDiv, oTotal, oRentLin, cCodDiv ) );
         ON CHANGE( RecalculaLinea( aTmp, aTmpPre, nDouDiv, oTotal, oRentLin, cCodDiv ), oSayDias:Refresh() );
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
         ON CHANGE( RecalculaLinea( aTmp, aTmpPre, nDouDiv, oTotal, oRentLin, cCodDiv ) );
         ON HELP  ( oNewImp:nBrwImp( aGet[ _NVALIMP ] ) );
         OF       oFld:aDialogs[1]

      end if

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

      REDEFINE GET aGet[ _NCANPRE ] VAR aTmp[ _NCANPRE ];
         ID       130 ;
         SPINNER ;
         WHEN     ( lUseCaj() .AND. nMode != ZOOM_MODE .AND. !lTotLin ) ;
         ON CHANGE( RecalculaLinea( aTmp, aTmpPre, nDouDiv, oTotal, oRentLin, cCodDiv ), LoaArt( cCodArt, aTmp, aGet, aTmpPre, oStkAct, oSayPr1, oSayPr2, oSayVp1, oSayVp2, bmpImage,  nMode, .f. ) );
         VALID    ( RecalculaLinea( aTmp, aTmpPre, nDouDiv, oTotal, oRentLin, cCodDiv ), LoaArt( cCodArt, aTmp, aGet, aTmpPre, oStkAct, oSayPr1, oSayPr2, oSayVp1, oSayVp2, bmpImage,  nMode, .f. ) );
         PICTURE  cPicUnd ;
         OF       oFld:aDialogs[1];
         IDSAY    131

      REDEFINE GET aGet[ _NUNICAJA ] VAR aTmp[ _NUNICAJA ];
         ID       140 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE .AND. !lTotLin .and. oUser():lModificaUnidades() ) ;
         ON CHANGE( RecalculaLinea( aTmp, aTmpPre, nDouDiv, oTotal, oRentLin, cCodDiv ), LoaArt( cCodArt, aTmp, aGet, aTmpPre, oStkAct, oSayPr1, oSayPr2, oSayVp1, oSayVp2, bmpImage,  nMode, .f. ) );
         VALID    ( RecalculaLinea( aTmp, aTmpPre, nDouDiv, oTotal, oRentLin, cCodDiv ), LoaArt( cCodArt, aTmp, aGet, aTmpPre, oStkAct, oSayPr1, oSayPr2, oSayVp1, oSayVp2, bmpImage,  nMode, .f. ) );
         PICTURE  cPicUnd ;
         OF       oFld:aDialogs[1] ;
         IDSAY    141

      REDEFINE GET aGet[ _NPREDIV ] VAR aTmp[ _NPREDIV ] ;
         ID       150 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE .and. !lTotLin ) ;
         ON CHANGE( RecalculaLinea( aTmp, aTmpPre, nDouDiv, oTotal, oRentLin, cCodDiv ) );
         VALID    ( RecalculaLinea( aTmp, aTmpPre, nDouDiv, oTotal, oRentLin, cCodDiv ) );
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
         ON CHANGE(  changeTarifa( aTmp, aGet, aTmpPre ),;
                     loadComisionAgente( aTmp, aGet, aTmpPre ),;
                     recalculaLinea( aTmp, aTmpPre, nDouDiv, oTotal, oRentLin, cCodDiv ) );
         OF       oFld:aDialogs[1]

      /*
      Para el caso de alquieres vamos a utilizar su precio---------------------
      */

      if aTmp[ __LALQUILER ]

         REDEFINE GET aGet[ _NPREALQ ] VAR aTmp[ _NPREALQ ] ;
            ID       250 ;
            SPINNER ;
            WHEN     ( nMode != ZOOM_MODE .and. !lTotLin ) ;
            ON CHANGE( RecalculaLinea( aTmp, aTmpPre, nDouDiv, oTotal, oRentLin, cCodDiv ) );
            VALID    ( RecalculaLinea( aTmp, aTmpPre, nDouDiv, oTotal, oRentLin, cCodDiv ) );
            COLOR    CLR_GET ;
            PICTURE  cPouDiv ;
            OF       oFld:aDialogs[1]

      end if

      REDEFINE GET aGet[ _NIMPTRN ] VAR aTmp[ _NIMPTRN ] ;
         ID       350 ;
         IDSAY    351 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE .AND. !lTotLin ) ;
         ON CHANGE( RecalculaLinea( aTmp, aTmpPre, nDouDiv, oTotal, oRentLin, cCodDiv ) );
         VALID    ( RecalculaLinea( aTmp, aTmpPre, nDouDiv, oTotal, oRentLin, cCodDiv ) );
         PICTURE  cPouDiv ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[_NPNTVER] VAR aTmp[_NPNTVER] ;
         ID       151 ;
         IDSAY    152 ;
         SPINNER ;
         PICTURE  cPpvDiv ;
         ON CHANGE( RecalculaLinea( aTmp, aTmpPre, nDouDiv, oTotal, oRentLin, cCodDiv ) );
         VALID    ( RecalculaLinea( aTmp, aTmpPre, nDouDiv, oTotal, oRentLin, cCodDiv ) );
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
			COLOR 	CLR_GET ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CFORMATO ] VAR aTmp[ _CFORMATO ];
         ID       460;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[_NDTO] VAR aTmp[_NDTO] ;
         ID       180 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE .and. !lTotLin ) ;
         ON CHANGE( RecalculaLinea( aTmp, aTmpPre, nDouDiv, oTotal, oRentLin, cCodDiv ) );
         VALID    ( RecalculaLinea( aTmp, aTmpPre, nDouDiv, oTotal, oRentLin, cCodDiv ) );
         PICTURE  "@E 999.99" ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _NDTOPRM ] VAR aTmp[ _NDTOPRM ] ;
         ID       190 ;
         SPINNER ;
         ON CHANGE( RecalculaLinea( aTmp, aTmpPre, nDouDiv, oTotal, oRentLin, cCodDiv ) );
         WHEN     ( nMode != ZOOM_MODE .and. !lTotLin ) ;
         VALID    ( RecalculaLinea( aTmp, aTmpPre, nDouDiv, oTotal, oRentLin, cCodDiv ) );
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
         ON CHANGE( RecalculaLinea( aTmp, aTmpPre, nDouDiv, oTotal, oRentLin, cCodDiv ) );
         VALID    ( RecalculaLinea( aTmp, aTmpPre, nDouDiv, oTotal, oRentLin, cCodDiv ) .and. aTmp[_NDTODIV] >= 0 );
         WHEN     ( nMode != ZOOM_MODE .AND. !lTotLin ) ;
         PICTURE  cPouDiv ;
         OF       oFld:aDialogs[1]

      REDEFINE GET oTotal VAR nTotPre ;
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
			WHEN 		( .F. ) ;
			COLOR 	CLR_GET ;
         OF       oFld:aDialogs[1]

      /*
      Codigo de almacen--------------------------------------------------------
      */

      REDEFINE GET aGet[_CALMLIN] VAR aTmp[_CALMLIN] ;
         ID       300 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         VALID    ( cAlmacen( aGet[_CALMLIN], , oSayAlm ), if( !uFieldEmpresa( "lNStkAct" ), oStock:lPutStockActual( aTmp[ _CREF ], aTmp[ _CALMLIN ], aTmp[ _CVALPR1 ], aTmp[ _CVALPR2 ], aTmp[ _CLOTE ], aTmp[ _LKITART ], aTmp[ _NCTLSTK ], oStkAct ), .t. ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwAlmacen( aGet[_CALMLIN], oSayAlm ) ) ;
			COLOR 	CLR_GET ;
         OF       oFld:aDialogs[1]

      REDEFINE GET oSayAlm VAR cSayAlm ;
			WHEN 		.F. ;
         ID       301 ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _COBRLIN ] VAR aTmp[ _COBRLIN ] ;
         ID       330 ;
         IDTEXT   331 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( cObras( aGet[ _COBRLIN ], aGet[ _COBRLIN ]:oHelpText, aTmpPre[ _CCODCLI ], dbfObrasT ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwObras( aGet[ _COBRLIN ], aGet[ _COBRLIN ]:oHelpText, aTmpPre[ _CCODCLI ], dbfObrasT ) ) ;
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
			COLOR 	CLR_GET ;
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

      REDEFINE GET aGet[ _NPVPREC ] VAR aTmp[ _NPVPREC ] ;
         ID       140 ;
         WHEN     ( .f. ) ;
         PICTURE  cPouDiv ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ _CIMAGEN ] VAR aTmp[ _CIMAGEN ] ;
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

      REDEFINE GET oRentLin VAR cRentLin ;
         ID       300 ;
         IDSAY    301 ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ _CCODPRV ] VAR  aTmp[ _CCODPRV ] ;
         ID       200 ;
         IDTEXT   201 ;   
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( cProvee( aGet[ _CCODPRV ], dbfProvee, aGet[ _CCODPRV ]:oHelpText ) );
         BITMAP   "LUPA" ;
         ON HELP  ( BrwProvee( aGet[ _CCODPRV ], aGet[ _CCODPRV ]:oHelpText ) ) ;
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
         ACTION   ( SaveDeta( cCodArt, aTmp, aTmpPre, aGet, oDlg, oBrw, bmpImage, nMode, oStkAct, oSayPr1, oSayPr2, oSayVp1, oSayVp2, oTotal, oBtn, oFld ) )

      REDEFINE BUTTON ;
         ID       IDCANCEL ;
         OF       oDlg ;
         CANCEL ;
         ACTION   ( oDlg:end() )

      REDEFINE BUTTON ;
         ID       9 ;
         OF       oDlg ;
         ACTION   ( ChmHelp( "Añadir_v" ) )

      // Keys --------------------------------------------------------------------

      if nMode != ZOOM_MODE
         if uFieldEmpresa( "lGetLot")
            oDlg:AddFastKey( VK_RETURN,   {|| oBtn:SetFocus(), oBtn:Click() } )
         end if 
         oDlg:AddFastKey( VK_F5,          {|| oBtn:SetFocus(), oBtn:Click() } )
      end if

      oDlg:AddFastKey( VK_F1, {|| ChmHelp( "Añadir_v" ) } )

      oDlg:bStart := {||   SetDlgMode( aTmp, aGet, nMode, oStkAct, oSayPr1, oSayPr2, oSayVp1, oSayVp2, oTotal, aTmpPre, oRentLin, oFld ),;
                           if( !Empty( cCodArtEnt ), aGet[ _CREF ]:lValid(), ),;
                           loadGet( aGet[ _CTERCTR ], cTipoCtrCoste ), aGet[ _CTERCTR ]:lValid(),;
                           aGet[ _CUNIDAD ]:lValid(), aGet[ _CCODPRV ]:lValid(), aGet[ _COBRLIN ]:lValid() }

   ACTIVATE DIALOG oDlg CENTER ;
         ON INIT  ( EdtDetMenu( aGet[ _CREF ], oDlg ) );
         ON PAINT ( RecalculaLinea( aTmp, aTmpPre, nDouDiv, oTotal, oRentLin, cCodDiv ) )

   EndDetMenu()

RETURN ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

/*
Estudiamos la posiblidades que se pueden dar en una linea de detalle
*/

STATIC FUNCTION SetDlgMode( aTmp, aGet, nMode, oStkAct, oSayPr1, oSayPr2, oSayVp1, oSayVp2, oTotal, aTmpPre, oRentLin, oFld )

   local cCodArt        := Left( aGet[ _CREF ]:VarGet(), 18 )

   if !uFieldEmpresa( "lUseBultos" )
      aGet[ __NBULTOS ]:Hide()
   else
      if !Empty( aGet[ __NBULTOS ] )
         aGet[ __NBULTOS ]:SetText( uFieldempresa( "cNbrBultos" ) )
      end if 
   end if

   if aGet[ _NCANPRE ] != nil
      if !lUseCaj()
         aGet[ _NCANPRE ]:hide()
      else
         aGet[ _NCANPRE ]:SetText( cNombreCajas() )
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
      if !uFieldEmpresa( "lUsePnt" ) .or. !aTmpPre[ _LOPERPV ]
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

   do case
   case nMode == APPD_MODE

      aGet[ _CREF    ]:cText( Space( 200 ) )

      aTmp[ _LIVALIN ]  := aTmpPre[ _LIVAINC ]
      aTmp[ _NNUMLIN ]  := nLastNum( dbfTmpLin )

      if aGet[ _NPOSPRINT ] != nil
         aGet[ _NPOSPRINT ]:cText( nLastNum( dbfTmpLin, "nPosPrint" ) )
      end if

      aGet[ _NCANPRE  ]:cText( 1 )
      aGet[ _NUNICAJA ]:cText( 1 )
      aGet[ _CALMLIN  ]:cText( aTmpPre[ _CCODALM ] )
      aGet[ _CDETALLE ]:show()

      if aGet[ _MLNGDES ] != nil
         aGet[ _MLNGDES ]:hide()
      end if

      if aGet[ _CLOTE ] != nil
         aGet[ _CLOTE ]:hide()
      end if

      if !Empty( aGet[ _DFECCAD ] )
         aGet[ _DFECCAD ]:Hide()
      end if

      if aTmpPre[ _NREGIVA ] <= 2
         if !empty( aGet[ _NIVA ] )
            aGet[ _NIVA ]:cText( nIva( dbfIva, cDefIva() ) )
         else
            aTmp[ _NIVA ]  := nIva( dbfIva, cDefIva() )
         end if   

         aTmp[ _NREQ ]     := nReq( dbfIva, cDefIva() )
      end if

      if !empty( aGet[ __CCENTROCOSTE ] )
         aGet[ __CCENTROCOSTE ]:cText( aTmpPre[ _CCENTROCOSTE ] )
         aGet[ __CCENTROCOSTE ]:lValid()
      endif

      cTipoCtrCoste        := "Centro de coste"
      oTipoCtrCoste:Refresh()
      clearGet( aGet[ _CTERCTR ] )

   case nMode != APPD_MODE .and. Empty( cCodArt )

      aGet[ _CREF     ]:hide()
      aGet[ _CDETALLE ]:hide()

      if aGet[ _MLNGDES ] != nil
         aGet[ _MLNGDES ]:show()
      end if

      if aGet[ _CLOTE ] != nil
         aGet[ _CLOTE ]:hide()
      end if

      if !Empty( aGet[ _DFECCAD ] )
         aGet[ _DFECCAD ]:Hide()
      end if

   case nMode != APPD_MODE .and. !Empty( cCodArt )

      aGet[ _CREF     ]:show()
      aGet[ _CDETALLE ]:show()
      aGet[ _MLNGDES  ]:hide()

      if !Empty( aGet[ _CLOTE ] ) 
         if aTmp[ _LLOTE ]
            aGet[ _CLOTE ]:Show()
         else
            aGet[ _CLOTE ]:Hide()
        end if
      end if

      // Edicion de las propiedades--------------------------------------------

      if ( !empty( aTmp[ _CCODPR1 ] ) .or. !empty( aTmp[ _CCODPR2 ] ) ) .and. ( uFieldEmpresa( "lUseTbl" ) )
         
         setPropertiesTable( cCodArt, aTmp[ _CCODPR1 ], aTmp[ _CCODPR2 ], 0, aGet[ _NUNICAJA ], oBrwProperties, nView )
         
         setValuesPropertiesTable( dbfTmpLin, oBrwProperties )

      end if 

      if !empty( oStkAct )
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
            oSayPr2:SetText( retProp(  aTmp[ _CCODPR2 ], dbfPro ) )
         end if

         if !Empty( oSayVp2 )
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

   if !Empty( aGet[ ( D():PresupuestosClientesLineas( nView ) )->( fieldpos( "nMedUno" ) ) ] )
      aGet[ ( D():PresupuestosClientesLineas( nView ) )->( fieldpos( "nMedUno" ) ) ]:Hide()
   end if

   if !Empty( aGet[ ( D():PresupuestosClientesLineas( nView ) )->( fieldpos( "nMedDos" ) ) ] )
      aGet[ ( D():PresupuestosClientesLineas( nView ) )->( fieldpos( "nMedDos" ) ) ]:Hide()
   end if

   if !Empty( aGet[ ( D():PresupuestosClientesLineas( nView ) )->( fieldpos( "nMedTre" ) ) ] )
      aGet[ ( D():PresupuestosClientesLineas( nView ) )->( fieldpos( "nMedTre" ) ) ]:Hide()
   end if

   if oUndMedicion:oDbf:Seek(  aTmp[ _CUNIDAD ] )

      if !Empty( aGet[ ( D():PresupuestosClientesLineas( nView ) )->( fieldpos( "nMedUno" ) ) ] ) .and. oUndMedicion:oDbf:nDimension >= 1 .and. !Empty( oUndMedicion:oDbf:cTextoDim1 )
         aGet[ ( D():PresupuestosClientesLineas( nView ) )->( fieldpos( "nMedUno" ) ) ]:oSay:SetText( oUndMedicion:oDbf:cTextoDim1 )
         aGet[ ( D():PresupuestosClientesLineas( nView ) )->( fieldpos( "nMedUno" ) ) ]:Show()
      end if

      if !Empty( aGet[ ( D():PresupuestosClientesLineas( nView ) )->( fieldpos( "nMedDos" ) ) ] ) .and. oUndMedicion:oDbf:nDimension >= 2 .and. !Empty( oUndMedicion:oDbf:cTextoDim2 )
         aGet[ ( D():PresupuestosClientesLineas( nView ) )->( fieldpos( "nMedDos" ) ) ]:oSay:SetText( oUndMedicion:oDbf:cTextoDim2 )
         aGet[ ( D():PresupuestosClientesLineas( nView ) )->( fieldpos( "nMedDos" ) ) ]:Show()
      end if

      if !Empty( aGet[ ( D():PresupuestosClientesLineas( nView ) )->( fieldpos( "nMedTre" ) ) ] ) .and. oUndMedicion:oDbf:nDimension >= 3 .and. !Empty( oUndMedicion:oDbf:cTextoDim3 )
         aGet[ ( D():PresupuestosClientesLineas( nView ) )->( fieldpos( "nMedTre" ) ) ]:oSay:SetText( oUndMedicion:oDbf:cTextoDim3 )
         aGet[ ( D():PresupuestosClientesLineas( nView ) )->( fieldpos( "nMedTre" ) ) ]:Show()
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

STATIC FUNCTION SaveDeta( cCodArt, aTmp, aTmpPre, aGet, oDlg2, oBrw, bmpImage, nMode, oStkAct, oSayPr1, oSayPr2, oSayVp1, oSayVp2, oTotal, oBtn, oFld )

   local n
   local i
   local aClo
   local nRec
   local aXbyStr              := { 0, 0 }
   local hAtipica
   local nPrecioPropiedades   := 0
   local nNumeroLinea         := 0
   local nPosicionLinea       := 0

   /*
   Condiciones para guardar la linea-------------------------------------------
   */

   oBtn:SetFocus()

   if !aGet[ _CREF ]:lValid()
      return nil
   end if

   if !lMoreIva( aTmp[ _NIVA ] )
      return nil
   end if

   if !cAlmacen( aGet[ _CALMLIN ], dbfAlm )
      return nil
   end if

   if Empty( aTmp[ _CALMLIN ] ) .and. !Empty( aTmp[ _CREF ] )
      msgStop( "Código de almacén no puede estar vacío", "Atención" )
      return nil
   end if

   SysRefresh()

   // control de precios minimos-----------------------------------------------

   if lPrecioMinimo( aTmp[ _CREF ], aTmp[ _NPREDIV ], nMode, D():Articulos( nView ) )
      msgStop( "El precio de venta es inferior al precio mínimo.")
      return nil
   end if 

   // Situaciones atipicas-----------------------------------------------------

   nRec                          := ( dbfTmpLin )->( RecNo() )

   aTmp[ _CTIPCTR ]              := cTipoCtrCoste
   aTmp[ _NREQ ]                 := nPReq( dbfIva, aTmp[ _NIVA ] )

   aClo                          := aClone( aTmp )

   if nMode == APPD_MODE

      if aTmp[ _LLOTE ]
         saveLoteActual( aTmp[ _CREF ], aTmp[ _CLOTE ], nView )   
      end if

      // Propiedades ----------------------------------------------------------

      if !empty( oBrwProperties:Cargo )

         for n := 1 to len( oBrwProperties:Cargo )

            for i := 1 to len( oBrwProperties:Cargo[ n ] )

               if isNum( oBrwProperties:Cargo[ n, i ]:Value ) .and. oBrwProperties:Cargo[ n, i ]:Value != 0

                  if empty(nNumeroLinea)
                     nNumeroLinea      := nLastNum( dbfTmpLin )
                  end if 

                  if empty(nPosicionLinea)
                     nPosicionLinea    := nLastNum( dbfTmpLin, "nPosPrint" )
                  end if 

                  aTmp[ _NNUMLIN ]     := nNumeroLinea
                  aTmp[ _NPOSPRINT ]   := nPosicionLinea
                  aTmp[ _NUNICAJA]     := oBrwProperties:Cargo[ n, i ]:Value
                  aTmp[ _CCODPR1 ]     := oBrwProperties:Cargo[ n, i ]:cCodigoPropiedad1
                  aTmp[ _CCODPR2 ]     := oBrwProperties:Cargo[ n, i ]:cCodigoPropiedad2
                  aTmp[ _CVALPR1 ]     := oBrwProperties:Cargo[ n, i ]:cValorPropiedad1
                  aTmp[ _CVALPR2 ]     := oBrwProperties:Cargo[ n, i ]:cValorPropiedad2

                  // Precio por propiedades --------------------------------------------------

                  nPrecioPropiedades   := nPrePro( aTmp[ _CREF ], aTmp[ _CCODPR1 ], aTmp[ _CVALPR1 ], aTmp[ _CCODPR2 ], aTmp[ _CVALPR2 ], aTmp[ _NTARLIN ], aTmpPre[ _LIVAINC ], dbfArtDiv, dbfTarPreL, aTmpPre[ _CCODTAR ] )
                  if !empty(nPrecioPropiedades)
                     aTmp[ _NPREDIV ]  := nPrecioPropiedades
                  end if 

                  saveDetail( aTmp, aClo, aGet, aTmpPre, dbfTmpLin, oBrw, nMode )

               end if

            next

         next

      else

         saveDetail( aTmp, aClo, aGet, aTmpPre, dbfTmpLin, oBrw, nMode )

      end if

   else

      WinGather( aTmp, aGet, dbfTmpLin, oBrw, nMode )

   end if

   ( dbfTmpLin )->( dbGoTo( nRec ) )

   /*
	Si estamos a¤adiendo y hay entradas continuas-------------------------------
	*/

   cOldCodArt                          := ""
   cOldUndMed                          := ""

   /*
   Liberacion del bitmap-------------------------------------------------------
   */

   if bmpImage != nil
      bmpImage:Hide()

      if !empty( bmpImage:hBitmap )
         PalBmpFree( bmpImage:hBitmap, bmpImage:hPalette )
      endif

   end if

   if nMode == APPD_MODE .AND. lEntCon()

      nTotPreCli( nil, D():PresupuestosClientes( nView ), dbfTmpLin, dbfIva, dbfDiv, dbfFPago, aTmpPre )

      aCopy( dbBlankRec( dbfTmpLin ), aTmp )
      aEval( aGet, {| o, i | if( "GET" $ o:ClassName(), o:cText( aTmp[ i ] ), ) } )

      SetDlgMode( aTmp, aGet, nMode, oStkAct, oSayPr1, oSayPr2, oSayVp1, oSayVp2, oTotal, aTmpPre, , oFld )

      SysRefresh()

   else

      oDlg2:end( IDOK )

   end if

RETURN NIL

//--------------------------------------------------------------------------//

Static Function saveDetail( aTmp, aClo, aGet, aTmpPre, dbfTmpLin, oBrw, nMode )

   local hAtipica
   local sOfertaArticulo
   local nCajasGratis         := 0
   local nUnidadesGratis      := 0

   // Atipicas ----------------------------------------------------------------

   hAtipica                   := hAtipica( hValue( aTmp, aTmpPre ) )
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

      sOfertaArticulo         := structOfertaArticulo( D():getHashArray( aTmpPre, "PreCliT", nView ), D():getHashArray( aTmp, "PreCliL", nView ), nTotLPreCli( aTmp ), nView )
      if !empty( sOfertaArticulo ) 
         nCajasGratis         := sOfertaArticulo:nCajasGratis
         nUnidadesGratis      := sOfertaArticulo:nUnidadesGratis
      end if
   end if 

   // Cajas gratis ---------------------------------------------------------

   if nCajasGratis != 0
      aTmp[ _LLINOFE ]        := .t.
      aTmp[ _NCANPRE ]        -= nCajasGratis
      
      commitDetail( aTmp, aClo, nil, aTmpPre, dbfTmpLin, oBrw, nMode, .f. )

      aTmp[ _LLINOFE ]        := .t.
      aTmp[ _NCANPRE ]        := nCajasGratis
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

      commitDetail( aTmp, aClo, nil, aTmpPre, dbfTmpLin, oBrw, nMode, .f. )

      aTmp[ _LLINOFE ]        := .t.
      aTmp[ _NUNICAJA]        := nUnidadesGratis 
      aTmp[ _NPREDIV ]        := 0
      aTmp[ _NDTO    ]        := 0
      aTmp[ _NDTODIV ]        := 0
      aTmp[ _NDTOPRM ]        := 0
      aTmp[ _NCOMAGE ]        := 0
   end if 

   commitDetail( aTmp, aClo, aGet, aTmpPre, dbfTmpLin, oBrw, nMode, .t. )

Return nil

//--------------------------------------------------------------------------//

Static Function commitDetail( aTmp, aClo, aGet, aTmpPre, dbfTmpLin, oBrw, nMode, lEmpty )

   winGather( aTmp, aGet, dbfTmpLin, oBrw, nMode, nil, .f. )

   if ( nMode == APPD_MODE ) .and. ( aClo[ _LKITART ] )
      appendKit( aClo, aTmpPre )
   end if

Return nil

//--------------------------------------------------------------------------//

Static Function EdtInc( aTmp, aGet, dbfPreCliI, oBrw, bWhen, bValid, nMode, aTmpPre )

   local oDlg

   if nMode == APPD_MODE
      aTmp[ ( dbfTmpInc )->( FieldPos( "lAviso" ) ) ]  := .t.
   end if

   DEFINE DIALOG oDlg RESOURCE "INCIDENCIA" TITLE LblTitle( nMode ) + "incidencias de presupuestos a clientes"

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

Static Function EdtEst( aTmp, aGet, dbf, oBrw, bWhen, bValid, nMode, aTmpPre )

      local oDlg

      if nMode == APPD_MODE
         
         aTmp[ ( D():PresupuestosClientesSituaciones( nView ) )->( fieldpos( "tFecSit" ) ) ]   := GetSysTime()
 
    end if

      DEFINE DIALOG oDlg RESOURCE "SITUACION_ESTADO" TITLE LblTitle( nMode ) + "Situación del documento del cliente"

         REDEFINE COMBOBOX aGet[ (D():PresupuestosClientesSituaciones( nView ))->(fieldpos("cSitua")) ] ;
            VAR    aTmp[ (D():PresupuestosClientesSituaciones( nView ))->(fieldpos("cSitua")) ] ;
            ID       200 ;
            WHEN     ( nMode != ZOOM_MODE );
            ITEMS    ( SituacionesRepository():getNombres() ) ;
            OF       oDlg

         REDEFINE GET aGet[ (D():PresupuestosClientesSituaciones( nView ))->(fieldpos("dFecSit")) ] ;
            VAR   aTmp[ (D():PresupuestosClientesSituaciones( nView ))->(fieldpos("dFecSit")) ] ;
            ID       100 ;
            SPINNER ;
            ON HELP  aGet[ (D():PresupuestosClientesSituaciones( nView ))->(fieldpos("dFecSit")) ]:cText( Calendario( aTmp[ (D():PresupuestosClientesSituaciones( nView ))->(fieldpos("dFecSit")) ] ) ) ;
            WHEN  ( nMode != ZOOM_MODE ) ;
            OF       oDlg

         REDEFINE GET aGet[ (D():PresupuestosClientesSituaciones( nView ))->(fieldpos("tFecSit")) ] ;
            VAR    aTmp[ (D():PresupuestosClientesSituaciones( nView ))->(fieldpos("tFecSit")) ] ;
            ID       101 ;
            PICTURE  "@R 99:99:99" ;
            WHEN     ( nMode != ZOOM_MODE ) ;
            VALID    ( iif( !validTime( aTmp[ (D():PresupuestosClientesSituaciones( nView ))->(fieldpos("tFecSit")) ] ),;
                          ( msgStop( "El formato de la hora no es correcto" ), .f. ),;
                          .t. ) );
            OF       oDlg

         REDEFINE BUTTON ;
            ID       IDOK ;
            OF       oDlg ;
            WHEN     ( nMode != ZOOM_MODE ) ;
            ACTION   ( WinGather( aTmp, nil, dbfTmpEst, oBrw, nMode ), oDlg:end( IDOK ) )

         REDEFINE BUTTON ;
            ID       IDCANCEL ;
            OF       oDlg ;
            CANCEL ;
            ACTION   ( oDlg:end() )

      if nMode != ZOOM_MODE
      oDlg:AddFastKey( VK_F5, {|| WinGather( aTmp, nil, dbfTmpEst, oBrw, nMode ), oDlg:end( IDOK ) } )
      end if

   ACTIVATE DIALOG oDlg CENTER

Return ( .t. )


//---------------------------------------------------------------------------//

Static Function EdtDoc( aTmp, aGet, dbfPreCliD, oBrw, bWhen, bValid, nMode, aTmpLin )

   local oDlg
   local oRuta
   local oNombre
   local oObservacion

   DEFINE DIALOG oDlg RESOURCE "DOCUMENTOS" TITLE LblTitle( nMode ) + "documento de presupuesto a cliente"

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
   local cFmtDoc     := cFormatoDocumento( ( D():PresupuestosClientes( nView ) )->cSerPre, "nPreCli", dbfCount )
   local oSayFmt
   local cSayFmt
   local oSerIni
   local oSerFin
   local cSerIni     := ( D():PresupuestosClientes( nView ) )->cSerPre
   local cSerFin     := ( D():PresupuestosClientes( nView ) )->cSerPre
   local nDocIni     := ( D():PresupuestosClientes( nView ) )->nNumPre
   local nDocFin     := ( D():PresupuestosClientes( nView ) )->nNumPre
   local cSufIni     := ( D():PresupuestosClientes( nView ) )->cSufPre
   local cSufFin     := ( D():PresupuestosClientes( nView ) )->cSufPre
   local oPrinter
   local cPrinter    := PrnGetName()
   local lCopiasPre  := .t.
   local lInvOrden   := .f.
   local dFecDesde   := CtoD( "01/01/" + Str( Year( Date() ) ) )
   local dFecHasta   := Date()
   local oRango
   local nRango      := 1
   local oNumCop
   local nNumCop     := if( nCopiasDocumento( ( D():PresupuestosClientes( nView ) )->cSerPre, "nPreCli", dbfCount ) == 0, Max( Retfld( ( D():PresupuestosClientes( nView ) )->cCodCli, D():Clientes( nView ), "CopiasF" ), 1 ), nCopiasDocumento( ( D():PresupuestosClientes( nView ) )->cSerPre, "nPreCli", dbfCount ) )

   if Empty( cFmtDoc )
      cFmtDoc           := cSelPrimerDoc( "RC" )
   end if

   cSayFmt           := cNombreDoc( cFmtDoc )

   DEFINE DIALOG oDlg RESOURCE "IMPSERIES" TITLE "Imprimir series de presupuestos"

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
		PICTURE 	"999999999" ;
      SPINNER ;
      WHEN     ( nRango == 1 );
		OF 		oDlg

   REDEFINE GET nDocFin;
      ID       130 ;
		PICTURE 	"999999999" ;
      SPINNER ;
      WHEN     ( nRango == 1 );
		OF 		oDlg

   REDEFINE GET cSufIni ;
      ID       140 ;
      PICTURE  "##" ;
      WHEN     ( nRango == 1 );
		OF 		oDlg

   REDEFINE GET cSufFin ;
      ID       150 ;
      PICTURE  "##" ;
      WHEN     ( nRango == 1 );
		OF 		oDlg

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
		PICTURE 	"999999999" ;
      SPINNER ;
      MIN      1 ;
      MAX      99999 ;
      OF       oDlg

   REDEFINE GET oFmtDoc VAR cFmtDoc ;
      ID       90 ;
      COLOR    CLR_GET ;
      VALID    ( cDocumento( oFmtDoc, oSayFmt, D():Documentos( nView ) ) ) ;
      BITMAP   "LUPA" ;
      ON HELP  ( BrwDocumento( oFmtDoc, oSayFmt, "RC" ) ) ;
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
		OF 		oDlg ;
      ACTION   (  StartPrint( SubStr( cFmtDoc, 1, 3 ), cSerIni + Str( nDocIni, 9 ) + cSufIni, cSerFin + Str( nDocFin, 9 ) + cSufFin, oDlg, nil, lCopiasPre, nNumCop, lInvOrden, nRango, dFecDesde, dFecHasta ),;
                  oDlg:end( IDOK ) )

   REDEFINE BUTTON ;
      ID       IDCANCEL ;
		OF 		oDlg ;
      CANCEL ;
      ACTION   ( oDlg:end() )

   oDlg:AddFastKey( VK_F5, {|| StartPrint( SubStr( cFmtDoc, 1, 3 ), cSerIni + Str( nDocIni, 9 ) + cSufIni, cSerFin + Str( nDocFin, 9 ) + cSufFin, oDlg, nil, lCopiasPre, nNumCop, lInvOrden, nRango, dFecDesde, dFecHasta ), oDlg:end( IDOK ) } )

   oDlg:bStart := { || oSerIni:SetFocus() }

   ACTIVATE DIALOG oDlg CENTER

	oWndBrw:oBrw:refresh()

RETURN NIL

//--------------------------------------------------------------------------//

STATIC FUNCTION StartPrint( cFmtDoc, cDocIni, cDocFin, oDlg, cPrinter, lCopiasPre, nNumCop, lInvOrden, nRango, dFecDesde, dFecHasta )

   local nCopyClient
   local nRecno
   local nOrdAnt

   oDlg:disable()

   if nRango == 1

      nRecno      := ( D():PresupuestosClientes( nView ) )->( recno() )
      nOrdAnt     := ( D():PresupuestosClientes( nView ) )->( OrdSetFocus( "nNumPre" ) )

      if ! lInvOrden

         if ( D():PresupuestosClientes( nView ) )->( dbSeek( cDocIni, .t. ) )

            while ( D():PresupuestosClientes( nView ) )->cSerPre + Str( ( D():PresupuestosClientes( nView ) )->nNumPre ) + ( D():PresupuestosClientes( nView ) )->cSufPre >= cDocIni   .and. ;
                  ( D():PresupuestosClientes( nView ) )->cSerPre + Str( ( D():PresupuestosClientes( nView ) )->nNumPre ) + ( D():PresupuestosClientes( nView ) )->cSufPre <= cDocFin   .and. ;
                  !( D():PresupuestosClientes( nView ) )->( Eof() )

                  lChgImpDoc( D():PresupuestosClientes( nView ) )

               if lCopiasPre

                  nCopyClient := if( nCopiasDocumento( ( D():PresupuestosClientes( nView ) )->cSerPre, "nPreCli", dbfCount ) == 0, Max( Retfld( ( D():PresupuestosClientes( nView ) )->cCodCli, D():Clientes( nView ), "CopiasF" ), 1 ), nCopiasDocumento( ( D():PresupuestosClientes( nView ) )->cSerPre, "nPreCli", dbfCount ) )

                  GenPreCli( IS_PRINTER, "Imprimiendo documento : " + ( D():PresupuestosClientes( nView ) )->cSerPre + Str( ( D():PresupuestosClientes( nView ) )->nNumPre ) + ( D():PresupuestosClientes( nView ) )->cSufPre, cFmtDoc, cPrinter, nCopyClient )

               else

                  GenPreCli( IS_PRINTER, "Imprimiendo documento : " + ( D():PresupuestosClientes( nView ) )->cSerPre + Str( ( D():PresupuestosClientes( nView ) )->nNumPre ) + ( D():PresupuestosClientes( nView ) )->cSufPre, cFmtDoc, cPrinter, nNumCop )

               end if

               ( D():PresupuestosClientes( nView ) )->( dbSkip() )

            end do

         end if

      else

         if ( D():PresupuestosClientes( nView ) )->( dbSeek( cDocFin ) )

            while ( D():PresupuestosClientes( nView ) )->cSerPre + Str( ( D():PresupuestosClientes( nView ) )->nNumPre ) + ( D():PresupuestosClientes( nView ) )->cSufPre >= cDocIni   .and.;
                  ( D():PresupuestosClientes( nView ) )->cSerPre + Str( ( D():PresupuestosClientes( nView ) )->nNumPre ) + ( D():PresupuestosClientes( nView ) )->cSufPre <= cDocFin   .and.;
                  !( D():PresupuestosClientes( nView ) )->( Bof() )

                  lChgImpDoc( D():PresupuestosClientes( nView ) )

               if lCopiasPre

                  nCopyClient := if( nCopiasDocumento( ( D():PresupuestosClientes( nView ) )->cSerPre, "nPreCli", dbfCount ) == 0, Max( Retfld( ( D():PresupuestosClientes( nView ) )->cCodCli, D():Clientes( nView ), "CopiasF" ), 1 ), nCopiasDocumento( ( D():PresupuestosClientes( nView ) )->cSerPre, "nPreCli", dbfCount ) )

                  GenPreCli( IS_PRINTER, "Imprimiendo documento : " + ( D():PresupuestosClientes( nView ) )->cSerPre + Str( ( D():PresupuestosClientes( nView ) )->nNumPre ) + ( D():PresupuestosClientes( nView ) )->cSufPre, cFmtDoc, cPrinter, nCopyClient )

               else

                  GenPreCli( IS_PRINTER, "Imprimiendo documento : " + ( D():PresupuestosClientes( nView ) )->cSerPre + Str( ( D():PresupuestosClientes( nView ) )->nNumPre ) + ( D():PresupuestosClientes( nView ) )->cSufPre, cFmtDoc, cPrinter, nNumCop )

               end if

               ( D():PresupuestosClientes( nView ) )->( dbSkip( -1 ) )

            end while

         end if

      end if

   else

      nRecno      := ( D():PresupuestosClientes( nView ) )->( recno() )
      nOrdAnt     := ( D():PresupuestosClientes( nView ) )->( OrdSetFocus( "dFecPre" ) )

      if ! lInvOrden

         ( D():PresupuestosClientes( nView ) )->( dbGoTop() )

         while !( D():PresupuestosClientes( nView ) )->( Eof() )

            if ( D():PresupuestosClientes( nView ) )->dFecPre >= dFecDesde .and. ( D():PresupuestosClientes( nView ) )->dFecPre <= dFecHasta

               lChgImpDoc( D():PresupuestosClientes( nView ) )

               if lCopiasPre

                  nCopyClient := if( nCopiasDocumento( ( D():PresupuestosClientes( nView ) )->cSerPre, "nPreCli", dbfCount ) == 0, Max( Retfld( ( D():PresupuestosClientes( nView ) )->cCodCli, D():Clientes( nView ), "CopiasF" ), 1 ), nCopiasDocumento( ( D():PresupuestosClientes( nView ) )->cSerPre, "nPreCli", dbfCount ) )

                  GenPreCli( IS_PRINTER, "Imprimiendo documento : " + ( D():PresupuestosClientes( nView ) )->cSerPre + Str( ( D():PresupuestosClientes( nView ) )->nNumPre ) + ( D():PresupuestosClientes( nView ) )->cSufPre, cFmtDoc, cPrinter, nCopyClient )

               else

                  GenPreCli( IS_PRINTER, "Imprimiendo documento : " + ( D():PresupuestosClientes( nView ) )->cSerPre + Str( ( D():PresupuestosClientes( nView ) )->nNumPre ) + ( D():PresupuestosClientes( nView ) )->cSufPre, cFmtDoc, cPrinter, nNumCop )

               end if

            end if   

            ( D():PresupuestosClientes( nView ) )->( dbSkip() )

         end while

      else

         ( D():PresupuestosClientes( nView ) )->( dbGobottom() )

         while !( D():PresupuestosClientes( nView ) )->( Bof() )

            if ( D():PresupuestosClientes( nView ) )->dFecPre >= dFecDesde .and. ( D():PresupuestosClientes( nView ) )->dFecPre <= dFecHasta

               lChgImpDoc( D():PresupuestosClientes( nView ) )

               if lCopiasPre

                  nCopyClient := if( nCopiasDocumento( ( D():PresupuestosClientes( nView ) )->cSerPre, "nPreCli", dbfCount ) == 0, Max( Retfld( ( D():PresupuestosClientes( nView ) )->cCodCli, D():Clientes( nView ), "CopiasF" ), 1 ), nCopiasDocumento( ( D():PresupuestosClientes( nView ) )->cSerPre, "nPreCli", dbfCount ) )

                  GenPreCli( IS_PRINTER, "Imprimiendo documento : " + ( D():PresupuestosClientes( nView ) )->cSerPre + Str( ( D():PresupuestosClientes( nView ) )->nNumPre ) + ( D():PresupuestosClientes( nView ) )->cSufPre, cFmtDoc, cPrinter, nCopyClient )

               else

                  GenPreCli( IS_PRINTER, "Imprimiendo documento : " + ( D():PresupuestosClientes( nView ) )->cSerPre + Str( ( D():PresupuestosClientes( nView ) )->nNumPre ) + ( D():PresupuestosClientes( nView ) )->cSufPre, cFmtDoc, cPrinter, nNumCop )

               end if

            end if

            ( D():PresupuestosClientes( nView ) )->( dbSkip( -1 ) )

         end while

      end if

   end if

   ( D():PresupuestosClientes( nView ) )->( dbGoTo( nRecNo ) )
   ( D():PresupuestosClientes( nView ) )->( ordSetFocus( nOrdAnt ) )

   oDlg:enable()

RETURN NIL

//--------------------------------------------------------------------------//

STATIC FUNCTION RecalculaTotal( aTmp )

   nTotPreCli( nil, D():PresupuestosClientes( nView ), dbfTmpLin, dbfIva, dbfDiv, dbfFPago, aTmp )

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
      oGetRnt:cText( AllTrim( Trans( nTotRnt, cPorDiv ) + Space( 1 ) + AllTrim( cSimDiv( aTmp[ _CDIVPRE ], dbfDiv ) ) + " : " + AllTrim( Trans( nPctRnt, "999.99" ) ) + "%" ) )
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
      oGetTotal:SetText( Trans( nTotPre, cPorDiv ) )
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

STATIC FUNCTION LoaArt( cCodArt, aTmp, aGet, aTmpPre, oStkAct, oSayPr1, oSayPr2, oSayVp1, oSayVp2, bmpImage, nMode, lFocused )

   local hHas128
   local cLote
	local nDtoAge
   local nImpAtp
   local nImpOfe
   local nCosPro
   local cCodFam
   local cPrpArt
   local nPrePro              := 0
   local nPosComa
   local cProveedor
   local nTarOld              := aTmp[ _NTARLIN ]
   local lChgCodArt           := ( Empty( cOldCodArt ) .or. Rtrim( cOldCodArt ) != Rtrim( cCodArt ) )
   local nNumDto              := 0
   local hAtipica
   local nDescuentoArticulo
   local sOfertaArticulo

   DEFAULT lFocused           := .t.

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

      if !empty( oBrwProperties )
         oBrwProperties:Hide()
      end if

   else

      if lModIva()
         aGet[ _NIVA ]:bWhen     := {|| .t. }
      else
         aGet[ _NIVA ]:bWhen     := {|| .f. }
      end if

		aGet[ _CDETALLE ]:show()

      if aGet[ _MLNGDES ] != nil
         aGet[ _MLNGDES ]:hide()
      end if

      // Buscamos codificacion GS1-128-----------------------------------------

      if len( alltrim( cCodArt ) ) > 18

         hHas128                 := ReadHashCodeGS128( cCodArt )
         if !empty( hHas128 )
            
            cCodArt              := uGetCodigo( hHas128, "00" )
            
            if Empty( cCodArt )
               cCodArt           := uGetCodigo( hHas128, "01" )
            end if

         end if 

      end if 

      cCodArt                    := cSeekCodebar( cCodArt, dbfCodebar, D():Articulos( nView ) )

      // Ahora buscamos por el codigo interno----------------------------------

      if ( D():Articulos( nView ) )->( dbSeek( cCodArt ) ) .or. ( D():Articulos( nView ) )->( dbSeek( Upper( cCodArt ) ) )

         if ( D():Articulos( nView ) )->lObs
            MsgStop( "Artículo catalogado como obsoleto" )
            return .f.
         end if

         if ( lChgCodArt )

            cCodArt              := ( D():Articulos( nView ) )->Codigo

            aGet[ _CREF ]:cText( Padr( cCodArt, 200 ) )
            aTmp[ _CREF ]        := cCodArt

            // Pasamos las referencias adicionales-----------------------------

            aTmp[ _CREFAUX ]     := ( D():Articulos( nView ) )->cRefAux
            aTmp[ _CREFAUX2 ]    := ( D():Articulos( nView ) )->cRefAux2

            if ( D():Articulos( nView ) )->lMosCom .and. !Empty( ( D():Articulos( nView ) )->mComent )
               MsgStop( Trim( ( D():Articulos( nView ) )->mComent ) )
            end if

            // Metemos el proveedor habitual-----------------------------------

            if !empty( aGet[ _CCODPRV ] )
               aGet[ _CCODPRV ]:cText( ( D():Articulos( nView ) )->cPrvHab )
               aGet[ _CCODPRV ]:lValid()
            else
               aTmp[ _CCODPRV ]  := ( D():Articulos( nView ) )->cPrvHab   
            end if

            aTmp[ _CREFPRV ]     := Padr( cRefPrvArt( aTmp[ _CREF ], ( D():Articulos( nView ) )->cPrvHab , dbfArtPrv ), 18 )

            // Lotes-----------------------------------------------------------

            if ( D():Articulos( nView ) )->lLote

               if empty( cLote )
                  cLote          := ( D():Articulos( nView ) )->cLote
               end if 

               aTmp[ _LLOTE ]    := ( D():Articulos( nView ) )->lLote

               if !empty( aGet[ _CLOTE ] )

                  aGet[ _CLOTE ]:Show()

                  if empty( aGet[ _CLOTE ]:VarGet() )
                     aGet[ _CLOTE ]:cText( cLote )
                     aGet[ _CLOTE ]:lValid()
                  end if

               else

                  if empty( aTmp[ _CLOTE ] )
                     aTmp[ _CLOTE ] := cLote 
                  end if

               end if

            else

               if !empty( aGet[ _CLOTE ] )
                  aGet[ _CLOTE ]:Hide()
               end if

               if !empty( aGet[ _DFECCAD ] )
                  aGet[ _DFECCAD ]:Hide()
               end if

            end if

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
            Unidades e impuestos--------------------------------------------------------
            */

            if ( D():Articulos( nView ) )->nCajEnt != 0
               if  aGet[ _NCANPRE ] != nil
                   aGet[ _NCANPRE ]:cText( ( D():Articulos( nView ) )->nCajEnt )
               else
                   aTmp[ _NCANPRE ] := ( D():Articulos( nView ) )->nCajEnt

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
            Preguntamos si el regimen de " + cImp() + " es distinto de Exento
            */

            if aTmpPre[ _NREGIVA ] <= 2

               if aGet[ _NIVA ] != nil
                  aGet[ _NIVA ]:cText( nIva( dbfIva, ( D():Articulos( nView ) )->TipoIva ) )
               else
                  aTmp[ _NIVA ]  := nIva( dbfIva, ( D():Articulos( nView ) )->TipoIva )
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

            // Impuestos especiales--------------------------------------------------

            aTmp[ _CCODIMP ]        := ( D():Articulos( nView ) )->cCodImp
            oNewImp:setCodeAndValue( aTmp[ _CCODIMP ], aGet[ _NVALIMP ] )

            if !Empty( ( D():Articulos( nView ) )->cCodImp )
               aTmp[ _LVOLIMP ]     := RetFld( ( D():Articulos( nView ) )->cCodImp, oNewImp:oDbf:cAlias, "lIvaVol" )
            end if

            // Buscamos la familia del articulo y anotamos las propiedades-----------

            aTmp[ _CCODPR1 ]         := ( D():Articulos( nView ) )->cCodPrp1
            aTmp[ _CCODPR2 ]         := ( D():Articulos( nView ) )->cCodPrp2

            if ( !empty( aTmp[ _CCODPR1 ] ) .or. !empty( aTmp[ _CCODPR2 ] ) ) .and. ( uFieldEmpresa( "lUseTbl" ) ) .and. ( nMode == APPD_MODE ) 

               aGet[ _NCANPRE  ]:cText( 0 )
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

            loadComisionAgente( aTmp, aGet, aTmpPre )

            // Peso y volumen

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

            if oStkAct != nil .and. !uFieldEmpresa( "lNStkAct" ) .and. aTmp[ _NCTLSTK ] <= 1
               oStock:nPutStockActual( aTmp[ _CREF ], aTmp[ _CALMLIN ], , , , aTmp[ _LKITART ], aTmp[ _NCTLSTK ], oStkAct )
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
               cCodFam        := RetFamArt( aTmp[ _CREF ], D():Articulos( nView ) )
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

            aTmp[ _NPVPREC ]     := ( D():Articulos( nView ) )->PvpRec

            // Cargamos los costos---------------------------------------------

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

            // Descuento de artículo----------------------------------------------
         
            nDescuentoArticulo   := nDescuentoArticulo( cCodArt, aTmpPre[ _CCODCLI ], nView )
            if nDescuentoArticulo != 0
               if !Empty( aGet[ _NDTO ] )
                  aGet[ _NDTO ]:cText( nDescuentoArticulo )
               else
                  aTmp[ _NDTO ]  := nDescuentoArticulo
               end if
            end if

            // Vemos si hay descuentos en las familias----------------------------

            if aTmp[ _NDTO ] == 0
               if !Empty( aGet[ _NDTO ] )
                  aGet[ _NDTO ]:cText( nDescuentoFamilia( cCodFam, D():Familias( nView ) ) )
               else
                  aTmp[ _NDTO ]     := nDescuentoFamilia( cCodFam, D():Familias( nView ) )
               end if
            end if

            // Vemos si hay descuentos en las familias----------------------------

            if aTmp[ _NDTO ] == 0
               if !Empty( aGet[ _NDTO ] )
                  aGet[ _NDTO ]:cText( nDescuentoFamilia( cCodFam, dbfFamilia ) )
               else
                  aTmp[ _NDTO ]  := nDescuentoFamilia( cCodFam, dbfFamilia )
               end if
            end if

            // Cargamos el codigo de las unidades---------------------------------

            if !Empty( aGet[ _CUNIDAD ] )
               aGet[ _CUNIDAD ]:cText( ( D():Articulos( nView ) )->cUnidad )
            else
               aTmp[ _CUNIDAD ]  := ( D():Articulos( nView ) )->cUnidad
            end if

            // Obtenemos el precio del artículo

            nPrePro           := nPrePro( aTmp[ _CREF ], aTmp[ _CCODPR1 ], aTmp[ _CVALPR1 ], aTmp[ _CCODPR2 ], aTmp[ _CVALPR2 ], aTmp[ _NTARLIN ], aTmpPre[ _LIVAINC ], dbfArtDiv, dbfTarPreL, aTmpPre[_CCODTAR] )

            if nPrePro == 0
               aGet[ _NPREDIV ]:cText( nRetPreArt( aTmp[ _NTARLIN ], aTmpPre[ _CDIVPRE ], aTmpPre[_LIVAINC], D():Articulos( nView ), dbfDiv, dbfKit, dbfIva, , , oNewImp ) )
            else
               aGet[ _NPREDIV ]:cText( nPrePro )
            end if

            /*
            Usando Tarifas-----------------------------------------------------
            */

            if !Empty( aTmpPre[ _CCODTAR ] )

               // Cojemos el descuento fijo y el precio del Articulo

               nImpOfe     := RetPrcTar( aTmp[ _CREF ], aTmpPre[_CCODTAR], aTmp[_CCODPR1], aTmp[_CCODPR2], aTmp[_CVALPR1], aTmp[_CVALPR2], dbfTarPreL, aTmp[ _NTARLIN ] )
               if nImpOfe  != 0
                  aGet[ _NPREDIV ]:cText( nImpOfe )
               end if

               nImpOfe     := RetPctTar( aTmp[ _CREF ], cCodFam, aTmpPre[_CCODTAR], aTmp[_CCODPR1], aTmp[_CCODPR2], aTmp[_CVALPR1], aTmp[_CVALPR2], dbfTarPreL )
               if nImpOfe  != 0
                  aGet[ _NDTO ]:cText( nImpOfe )
               end if

               nImpOfe     := RetLinTar( aTmp[ _CREF ], cCodFam, aTmpPre[_CCODTAR], aTmp[_CCODPR1], aTmp[_CCODPR2], aTmp[_CVALPR1], aTmp[_CVALPR2], dbfTarPreL )
               if nImpOfe  != 0
                  aGet[ _NDTODIV ]:cText( nImpOfe )
               end if

               nImpOfe     := RetComTar( aTmp[ _CREF ], cCodFam, aTmpPre[_CCODTAR], aTmp[_CCODPR1], aTmp[_CCODPR2], aTmp[_CVALPR1], aTmp[_CVALPR2], aTmpPre[_CCODAGE], dbfTarPreL, dbfTarPreS )
               if nImpOfe  != 0
                  aGet[ _NCOMAGE ]:cText( nImpOfe )
               end if

               // Descuento de promoción

               nImpOfe     := RetDtoPrm( aTmp[ _CREF ], cCodFam, aTmpPre[_CCODTAR], aTmp[_CCODPR1], aTmp[_CCODPR2], aTmp[_CVALPR1], aTmp[_CVALPR2], aTmpPre[_DFECPRE], dbfTarPreL )
               if nImpOfe  != 0
                  aGet[ _NDTOPRM ]:cText( nImpOfe )
               end if

               // Obtenemos el descuento de Agente

               nDtoAge     := RetDtoAge( aTmp[ _CREF ], cCodFam, aTmpPre[_CCODTAR], aTmp[_CCODPR1], aTmp[_CCODPR2], aTmp[_CVALPR1], aTmp[_CVALPR2], aTmpPre[_DFECPRE], aTmpPre[_CCODAGE], dbfTarPreL, dbfTarPreS )
               if nDtoAge  != 0
                  aGet[ _NCOMAGE ]:cText( nDtoAge )
               end if

            end if

            // Chequeamos las atipicas del cliente--------------------------------

            hAtipica := hAtipica( hValue( aTmp, aTmpPre ) )

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

            sOfertaArticulo   := structOfertaArticulo( D():getHashArray( aTmpPre, "PreCliT", nView ), D():getHashArray( aTmp, "PreCliL", nView ), nTotLPreCli( aTmp ), nView )

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

            // Mediciones

            ValidaMedicion( aTmp, aGet )

         end if

         /*
         Buscamos si hay ofertas-----------------------------------------------
         */

         lBuscaOferta( aTmp[ _CREF ], aGet, aTmp, aTmpPre, dbfOferta, D():Articulos( nView ), dbfDiv, dbfKit, dbfIva  )

         /*
         Cargamos los valores para los cambios---------------------------------
         */

         cOldPrpArt := cPrpArt
         cOldCodArt := cCodArt

         /*
         Solo pueden modificar los precios los administradores-----------------
         */

         if empty( aTmp[ _NPREDIV ] ) .or. ( SQLAjustableModel():getRolCambiarPrecios( Auth():rolUuid() ) )
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

static function lBuscaOferta( cCodArt, aGet, aTmp, aTmpPre, dbfOferta, dbfArticulo, dbfDiv, dbfKit, dbfIva  )

   local sOfeArt
   local nTotalLinea    := 0

   if ( dbfArticulo )->Codigo == cCodArt .or. ( dbfArticulo )->( dbSeek( cCodArt ) )

      /*
      Buscamos si existen ofertas por artículo----------------------------
      */

      nTotalLinea       := RecalculaLinea( aTmp, aTmpPre, nDouDiv, , , aTmpPre[ _CDIVPRE ], .t. )

      sOfeArt           := sOfertaArticulo( cCodArt, aTmpPre[ _CCODCLI ], aTmpPre[ _CCODGRP ], aTmp[ _NUNICAJA ], aTmpPre[ _DFECPRE ], dbfOferta, aTmp[ _NTARLIN ], aTmpPre[ _LIVAINC ], aTmp[_CCODPR1], aTmp[_CCODPR2], aTmp[_CVALPR1], aTmp[_CVALPR2], aTmp[ _CDIVPRE ], aTmp[ _NCANPRE ], nTotalLinea )

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

         sOfeArt        := sOfertaFamilia( ( dbfArticulo )->Familia, aTmpPre[ _CCODCLI ], aTmpPre[ _CCODGRP ], aTmpPre[ _DFECPRE ], dbfOferta, aTmp[ _NTARLIN ], dbfArticulo, aTmp[ _NUNICAJA ], aTmp[ _NCANPRE ], nTotalLinea )

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

         sOfeArt           := sOfertaTipoArticulo( ( dbfArticulo )->cCodTip, aTmpPre[ _CCODCLI ], aTmpPre[ _CCODGRP ], aTmpPre[ _DFECPRE ], dbfOferta, aTmp[ _NTARLIN ], dbfArticulo, aTmp[ _NUNICAJA ], aTmp[ _NCANPRE ], nTotalLinea )

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

         sOfeArt           := sOfertaCategoria( ( dbfArticulo )->cCodCate, aTmpPre[ _CCODCLI ], aTmpPre[ _CCODGRP ], aTmpPre[ _DFECPRE ], dbfOferta, aTmp[ _NTARLIN ], dbfArticulo, aTmp[ _NUNICAJA ], aTmp[ _NCANPRE ], nTotalLinea )

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

         sOfeArt           := sOfertaTemporada( ( dbfArticulo )->cCodTemp, aTmpPre[ _CCODCLI ], aTmpPre[ _CCODGRP ], aTmpPre[ _DFECPRE ], dbfOferta, aTmp[ _NTARLIN ], dbfArticulo, aTmp[ _NUNICAJA ], aTmp[ _NCANPRE ], nTotalLinea )

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

         sOfeArt     := sOfertaFabricante( ( dbfArticulo )->cCodFab, aTmpPre[ _CCODCLI ], aTmpPre[ _CCODGRP ], aTmpPre[ _DFECPRE ], dbfOferta, aTmp[ _NTARLIN ], dbfArticulo, aTmp[ _NUNICAJA ], aTmp[ _NCANPRE ], nTotalLinea )

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

/*
Calcula totales en las lineas de Detalle
*/

STATIC FUNCTION RecalculaLinea( aTmp, aTmpPre, nDec, oTotal, oMargen, cCodDiv, lTotal )

   local nCalculo
   local nUnidades
   local nMargen
   local nCosto
   local nRentabilidad
   local nBase    := 0

   DEFAULT lTotal := .f.

   nUnidades      := nTotNPreCli( aTmp )

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

   if aTmpPre[ _LOPERPV ] .and. aTmp[ _NPNTVER ] != 0
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

STATIC FUNCTION nTotLAgePre( dbfDetalle )

   local nCalculo := ( dbfDetalle )->nPreDiv * (dbfDetalle)->nUniCaja

   IF lCalCaj()
      nCalculo    *= If( ( dbfDetalle )->nCanPre != 0, ( dbfDetalle )->nCanPre, 1 )
	END IF

   nCalculo       := Round( nCalculo * ( dbfDetalle )->nComAge / 100, 0 )

RETURN ( nCalculo )

//---------------------------------------------------------------------------//

/*
Devuelve en numero de articulos en una linea de detalle
*/

STATIC FUNCTION nTotLNumArt( dbfDetalle )

	local nCalculo := 0

   IF lCalCaj() .AND. (dbfDetalle)->NCANPRE != 0 .AND. (dbfDetalle)->NPREDIV != 0
		nCalculo := (dbfDetalle)->NCANPRE
	END IF

RETURN ( nCalculo )

//---------------------------------------------------------------------------//

STATIC FUNCTION BeginTrans( aTmp, nMode )

   local lErrors  := .f.
   local cDbfLin  := "PCliL"
   local cDbfInc  := "PCliI"
   local cDbfDoc  := "PCliD"
   local cDbfEst  := "PCliE"
   local cPre     := aTmp[ _CSERPRE ] + Str( aTmp[ _NNUMPRE ] ) + aTmp[ _CSUFPRE ]
   local oError
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   cTmpLin        := cGetNewFileName( cPatTmp() + cDbfLin )
   cTmpInc        := cGetNewFileName( cPatTmp() + cDbfInc )
   cTmpDoc        := cGetNewFileName( cPatTmp() + cDbfDoc )
   cTmpEst        := cGetNewFileName( cPatTmp() + cDbfEst )

	/*
	Primero Crear la base de datos local
	*/

   dbCreate( cTmpInc, aSqlStruct( aIncPreCli() ), cLocalDriver() )
   dbUseArea( .t., cLocalDriver(), cTmpInc, cCheckArea( cDbfInc, @dbfTmpInc ), .f. )

   if !NetErr()
      ( dbfTmpInc )->( OrdCondSet( "!Deleted()", {||!Deleted()} ) )
      ( dbfTmpInc )->( OrdCreate( cTmpInc, "Recno", "Str( Recno() )", {|| Str( Recno() ) } ) )
   else
      lErrors     := .t.
   end if

   dbCreate( cTmpDoc, aSqlStruct( aPreCliDoc() ), cLocalDriver() )
   dbUseArea( .t., cLocalDriver(), cTmpDoc, cCheckArea( cDbfDoc, @dbfTmpDoc ), .f. )

   if !NetErr()
      ( dbfTmpDoc )->( OrdCondSet( "!Deleted()", {||!Deleted()} ) )
      ( dbfTmpDoc )->( OrdCreate( cTmpDoc, "Recno", "Str( Recno() )", {|| Str( Recno() ) } ) )
   else
      lErrors     := .t.
   end if

   dbCreate( cTmpLin, aSqlStruct( aColPreCli() ), cLocalDriver() )
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

   dbCreate( cTmpEst, aSqlStruct( aPreCliEst() ), cLocalDriver() )
   dbUseArea( .t., cLocalDriver(), cTmpEst, cCheckArea( cDbfEst, @dbfTmpEst ), .f. )

   if !NetErr()
      ( dbfTmpEst )->( ordCreate( cTmpEst, "nNumPre", "cSerPre + str( nNumPre ) + cSufPre + dtos( dFecSit )  + tFecSit", {|| Field->cSerPre + str( Field->nNumPre ) + Field->cSufPre + dtos( Field->dFecSit )  + Field->tFecSit } ) )
      ( dbfTmpEst )->( ordListAdd( cTmpEst ) )
   else
      lErrors     := .t.
   endif

	/*
	A¤adimos desde el fichero de lineas-----------------------------------------
	*/

   if ( D():PresupuestosClientesLineas( nView ) )->( dbSeek( cPre ) )

      while ( ( D():PresupuestosClientesLineas( nView ) )->cSerPre + Str( ( D():PresupuestosClientesLineas( nView ) )->NNUMPRE ) + ( D():PresupuestosClientesLineas( nView ) )->CSUFPRE == cPre .AND. !( D():PresupuestosClientesLineas( nView ) )->( eof() ) )

         dbPass( D():PresupuestosClientesLineas( nView ), dbfTmpLin, .t. )
         ( D():PresupuestosClientesLineas( nView ) )->( dbSkip() )

      end while

   end if

   ( dbfTmpLin )->( dbGoTop() )

   /*
   A¤adimos desde el fichero de incidencias------------------------------------
	*/

   if ( nMode != DUPL_MODE ) .and. ( dbfPreCliI )->( dbSeek( cPre ) )

      do while ( ( dbfPreCliI )->cSerPre + Str( ( dbfPreCliI )->NNUMPRE ) + ( dbfPreCliI )->CSUFPRE == cPre .AND. !( dbfPreCliI )->( eof() ) )

         dbPass( dbfPreCliI, dbfTmpInc, .t. )
         ( dbfPreCliI )->( DbSkip() )

      end while

   end if

   ( dbfTmpInc )->( dbGoTop() )

   /*
   A¤adimos desde el fichero de documentos-------------------------------------
	*/

   if ( nMode != DUPL_MODE ) .and. ( dbfPreCliD )->( dbSeek( cPre ) )

      do while ( ( dbfPreCliD )->cSerPre + Str( ( dbfPreCliD )->NNUMPRE ) + ( dbfPreCliD )->CSUFPRE == cPre .AND. !( dbfPreCliD )->( eof() ) )

         dbPass( dbfPreCliD, dbfTmpDoc, .t. )
         ( dbfPreCliD )->( dbSkip() )

      end while

   end if

   ( dbfTmpDoc )->( dbGoTop() )

   /*
   A¤adimos desde el fichero de situaciones------------------------------------
   */
   
   if ( nMode != DUPL_MODE ) .and. ( D():PresupuestosClientesSituaciones( nView ) )->( dbSeek( cPre ) )

         while ( ( D():PresupuestosClientesSituaciones( nView ) )->cSerPre + Str( ( D():PresupuestosClientesSituaciones( nView ) )->nNumPre ) + ( D():PresupuestosClientesSituaciones( nView ) )->cSufPre == cPre ) .AND. ( D():PresupuestosClientesSituaciones( nView ) )->( !eof() ) 

         dbPass( D():PresupuestosClientesSituaciones( nView ), dbfTmpEst, .t. )
         ( D():PresupuestosClientesSituaciones( nView ) )->( dbSkip() )

      end while

   end if

   ( dbfTmpEst )->( dbGoTop() )

   oDetCamposExtra:SetTemporal( aTmp[ _CSERPRE ] + Str( aTmp[ _NNUMPRE ] ) + aTmp[ _CSUFPRE ], "", nMode )

   RECOVER USING oError

      msgStop( "Imposible crear tablas temporales" + CRLF + ErrorMessage( oError ) )

      KillTrans()

      lErrors     := .t.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lErrors )

//-----------------------------------------------------------------------//

STATIC FUNCTION EndTrans( aTmp, aGet, nMode, oBrwLin, oBrw, oBrwInc, oDlg, lActualizaWeb )

	local aTabla
   local oError
   local oBlock
   local cSerPre
   local nNumPre
   local cSufPre

   DEFAULT lActualizaWeb      := .f.

   if Empty( aTmp[ _CSERPRE ] )
      aTmp[ _CSERPRE ]  := "A"
   end if

   cSerPre              := aTmp[ _CSERPRE ]
   nNumPre              := aTmp[ _NNUMPRE ]
   cSufPre              := aTmp[ _CSUFPRE ]

   /*
   Comprobamos la fecha del documento
   */

   if !lValidaOperacion( aTmp[ _DFECPRE ] )
      Return .f.
   end if

   if !lValidaSerie( aTmp[ _CSERPRE ] )
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

   if Empty( aTmp[ _CDIVPRE ] )
      MsgStop( "No puede almacenar documento sin código de divisa." )
      aGet[ _CDIVPRE ]:SetFocus()
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
   aTmp[ _NTARIFA ]        := oGetTarifa:getTarifa()

   /*
   Guardamos el tipo para alquileres-------------------------------------------
   */

   aTmp[ _LALQUILER ]      := !Empty( oTipPre ) .and. ( oTipPre:nAt == 2 )

   do case
   case isAppendOrDuplicateMode( nMode )

      nNumPre              := nNewDoc( cSerPre, D():PresupuestosClientes( nView ), "nPreCli", , dbfCount )
      aTmp[ _NNUMPRE ]     := nNumPre
      cSufPre              := retSufEmp()
      aTmp[ _CSUFPRE ]     := cSufPre

   case isEditMode( nMode )

      if nNumPre != 0 .AND. ( D():PresupuestosClientesLineas( nView ) )->( dbSeek( cSerPre + str( nNumPre ) + cSufPre ) )

         do while ( ( D():PresupuestosClientesLineas( nView ) )->cSerPre + Str( ( D():PresupuestosClientesLineas( nView ) )->nNumPre ) + ( D():PresupuestosClientesLineas( nView ) )->cSufPre == cSerPre + str( nNumPre ) + cSufPre )

            if dbLock( D():PresupuestosClientesLineas( nView ) )
               ( D():PresupuestosClientesLineas( nView ) )->( dbDelete() )
               ( D():PresupuestosClientesLineas( nView ) )->( dbUnLock() )
            end if

            ( D():PresupuestosClientesLineas( nView ) )->( dbSkip() )

         end while

      end if

      if nNumPre != 0

         while ( dbfPreCliI )->( dbSeek( cSerPre + str( nNumPre ) + cSufPre ) )
            if dbLock( dbfPreCliI )
               ( dbfPreCliI )->( dbDelete() )
               ( dbfPreCliI )->( dbUnLock() )
            end if
         end while

         while ( dbfPreCliD )->( dbSeek( cSerPre + str( nNumPre ) + cSufPre ) )
            if dbLock( dbfPreCliD )
               ( dbfPreCliD )->( dbDelete() )
               ( dbfPreCliD )->( dbUnLock() )
            end if
         end while

         while ( D():PresupuestosClientesSituaciones( nView ) )->( dbSeek( cSerPre + str( nNumPre ) + cSufPre ) )
            if dbLock( D():PresupuestosClientesSituaciones( nView ) )
               ( D():PresupuestosClientesSituaciones( nView ) )->( dbDelete() )
               ( D():PresupuestosClientesSituaciones( nView ) )->( dbUnLock() )
            end if
         end while

      end if

   end case

   if !( "PDA" $ appParamsMain() )
      oMsgProgress()
      oMsgProgress():SetRange( 0, ( dbfTmpLin )->( LastRec() ) )
   end if

	/*
	Ahora escribimos en el fichero definitivo-----------------------------------
	*/

   ( dbfTmpLin )->( dbGoTop() )
   do while !( dbfTmpLin )->( Eof() )

      ( dbfTmpLin )->nRegIva     := aTmp[ _NREGIVA ]

      dbPass( dbfTmpLin, D():PresupuestosClientesLineas( nView ), .t., cSerPre, nNumPre, cSufPre )
      ( dbfTmpLin )->( dbSkip() )

      if !( "PDA" $ appParamsMain() )
         oMsgProgress():Deltapos(1)
      end if

   end while

   /*
	Ahora escribimos en el fichero incidencias----------------------------------
	*/

   ( dbfTmpInc )->( dbGoTop() )
   do while !( dbfTmpInc )->( Eof() )

      dbPass( dbfTmpInc, dbfPreCliI, .t., cSerPre, nNumPre, cSufPre )
      ( dbfTmpInc )->( dbSkip() )

   end while

   /*
	Ahora escribimos en el fichero definitivo
	*/

   ( dbfTmpDoc )->( dbGoTop() )
   do while !( dbfTmpDoc )->( Eof() )

      dbPass( dbfTmpDoc, dbfPreCliD, .t., cSerPre, nNumPre, cSufPre )
      ( dbfTmpDoc )->( dbSkip() )

   end while

   /*
   Escribimos en el fichero definitivo (Situaciones)
   */

    ( dbfTmpEst )->( DbGoTop() )
      while ( dbfTmpEst )->( !eof() )
         dbPass( dbfTmpEst, D():PresupuestosClientesSituaciones( nView ), .t., cSerPre, nNumPre, cSufPre ) 
         ( dbfTmpEst )->( dbSkip() )
      end while

   /*
   Guardamos los totales-------------------------------------------------------
   */

   aTmp[ _NTOTNET ]     := nTotNet
   aTmp[ _NTOTIVA ]     := nTotIva
   aTmp[ _NTOTREQ ]     := nTotReq
   aTmp[ _NTOTPRE ]     := nTotPre

   /*
   Guardamos los campos extra-----------------------------------------------
   */

   oDetCamposExtra:saveExtraField( aTmp[ _CSERPRE ] + Str( aTmp[ _NNUMPRE ] ) + aTmp[ _CSUFPRE ], "" )

   WinGather( aTmp, , D():PresupuestosClientes( nView ), , nMode )

   /*
   Actualizamos los datos de la web para tiempo real------------------------
   */

      
   if uFieldempresa( "lRealWeb" ) .and. ( !empty( ( D():PresupuestosClientes( nView ) )->cCodWeb ) )
      with object ( TComercio():New() )
         :syncSituacionesPresupuestoPrestashop( ( D():PresupuestosClientes( nView ) )->cCodWeb, ( D():PresupuestosClientes( nView ) )->cSerPre, ( D():PresupuestosClientes( nView ) )->nNumPre, ( D():PresupuestosClientes( nView ) )->cSufPre )
      end with
   end if

   /*
   Escribe los datos pendientes------------------------------------------------
   */

   dbCommitAll()

   if !( "PDA" $ appParamsMain() )
      oMsgProgress()
      oMsgText()

      EndProgress()
   end if

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

   dbfErase( cTmpLin )
   dbfErase( cTmpInc )
   dbfErase( cTmpDoc )

Return .t.

//------------------------------------------------------------------------//

STATIC FUNCTION LoaCli( aGet, aTmp, nMode, oRieCli, oTlfCli )

   local lValid      := .t.
   local cNewCodCli  := aGet[ _CCODCLI ]:VarGet()
   local lChgCodCli  := ( Empty( cOldCodCli ) .or. cOldCodCli != cNewCodCli )

   if Empty( cNewCodCli )
      return .t.
   elseif At( ".", cNewCodCli ) != 0
      cNewCodCli     := PntReplace( aGet[_CCODCLI], "0", RetNumCodCliEmp() )
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
      Asignamos el codigo siempre----------------------------------------------
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

      /*
      Calculo del reisgo del cliente-------------------------------------------
      */

      if ( lChgCodCli )

         if oRieCli != nil
            oStock:SetRiesgo( cNewCodCli, oRieCli, ( D():Clientes( nView ) )->Riesgo )
         end if

         aTmp[ _LMODCLI ]  := ( D():Clientes( nView ) )->lModDat

         aTmp[ _LOPERPV ]  := ( D():Clientes( nView ) )->lPntVer
      end if

      if nMode == APPD_MODE

         aTmp[ _NREGIVA ]   := ( D():Clientes( nView ) )->nRegIva

         lChangeRegIva( aTmp )

         /*
         Si estamos a¤adiendo cargamos todos los datos del cliente
         */

         if Empty( aTmp[ _CSERPRE ] )

            if !Empty( ( D():Clientes( nView ) )->Serie )
               aGet[ _CSERPRE ]:cText( ( D():Clientes( nView ) )->Serie )
            end if

         else

            if !Empty( ( D():Clientes( nView ) )->Serie ) .and. aTmp[ _CSERPRE ] != ( D():Clientes( nView ) )->Serie .and. ApoloMsgNoYes( "La serie del cliente seleccionado es distinta a la anterior.", "¿Desea cambiar la serie?" )
               aGet[ _CSERPRE ]:cText( ( D():Clientes( nView ) )->Serie )
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
            if ( Empty( oGetTarifa:varGet() ) .or. lChgCodCli ) .and. !Empty( ( D():Clientes( nView ) )->nTarifa )
               oGetTarifa:setTarifa( ( D():Clientes( nView ) )->nTarifa )
            end if
        else
             aTmp[ _NTARIFA ]    := ( D():Clientes( nView ) )->nTarifa
         end if

         if ( Empty( aTmp[ _NDTOTARIFA ] ) .or. lChgCodCli )
             aTmp[ _NDTOTARIFA ]    := ( D():Clientes( nView ) )->nDtoArt
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

   if !lExistTable( cPath + "PreCliT.Dbf", cLocalDriver() )
      dbCreate( cPath + "PreCliT.Dbf", aSqlStruct( aItmPreCli() ), cLocalDriver() )
   end if

   if !lExistTable( cPath + "PreCliL.Dbf", cLocalDriver() )
      dbCreate( cPath + "PreCliL.Dbf", aSqlStruct( aColPreCli() ), cLocalDriver() )
   end if

   if !lExistTable( cPath + "PreCliI.Dbf", cLocalDriver() )
      dbCreate( cPath + "PreCliI.Dbf", aSqlStruct( aIncPreCli() ), cLocalDriver() )
   end if

   if !lExistTable( cPath + "PreCliD.Dbf", cLocalDriver() )
      dbCreate( cPath + "PreCliD.Dbf", aSqlStruct( aPreCliDoc() ), cLocalDriver() )
   end if

   if !lExistTable( cPath + "PreCliE.Dbf", cLocalDriver() )
      dbCreate( cPath + "PreCliE.Dbf", aSqlStruct( aPreCliEst() ), cLocalDriver() )
   end if

RETURN NIL

//----------------------------------------------------------------------------//

STATIC FUNCTION ChgState( oBrw )

   local nRec

   for each nRec in ( oBrw:aSelected )

      ( D():PresupuestosClientes( nView ) )->( dbGoTo( nRec ) )

      if dbLock( D():PresupuestosClientes( nView ) )
         ( D():PresupuestosClientes( nView ) )->lEstado := !( D():PresupuestosClientes( nView ) )->lEstado
         ( D():PresupuestosClientes( nView ) )->( dbRUnlock() )
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

static function lGenPreCli( oBrw, oBtn, nDevice )

   local bAction

   DEFAULT nDevice   := IS_PRINTER

   if Empty( oBtn )
      return nil
   end if

   IF !( D():Documentos( nView ) )->( dbSeek( "RC" ) )

         DEFINE BTNSHELL RESOURCE "GC_DOCUMENT_WHITE_" OF oWndBrw ;
            NOBORDER ;
            ACTION   ( msgStop( "No hay presupuestos de proveedores predefinidos" ) );
            TOOLTIP  "No hay documentos" ;
            HOTKEY   "N";
            FROM     oBtn ;
            CLOSED ;
            LEVEL    ACC_EDIT

   ELSE

      WHILE ( D():Documentos( nView ) )->cTipo == "RC" .AND. !( D():Documentos( nView ) )->( eof() )

         bAction  := bGenPreCli( nDevice, "Imprimiendo presupuestos a clientes", ( D():Documentos( nView ) )->CODIGO )

         oWndBrw:NewAt( "gc_document_white_", , , bAction, Rtrim( ( D():Documentos( nView ) )->cDescrip ) , , , , , oBtn )

         ( D():Documentos( nView ) )->( dbSkip() )

      END DO

   END IF

   SysRefresh()

return nil

//---------------------------------------------------------------------------//

static function bGenPreCli( nDevice, cTitle, cCodDoc )

   local bGen
   local nDev  := by( nDevice )
   local cTit  := by( cTitle )
   local cCod  := by( cCodDoc )

   if nDev == IS_PRINTER
      bGen     := {|| nGenPreCli( nDev, cTit, cCod ) }
   else
      bGen     := {|| GenPreCli( nDev, cTit, cCod ) }
   end if

return ( bGen )

//---------------------------------------------------------------------------//

static function nGenPreCli( nDevice, cTitle, cCodDoc, cPrinter, nCopy )

   local nImpYet     := 1
   local nCopyClient := Retfld( ( D():PresupuestosClientes( nView ) )->cCodCli, D():Clientes( nView ), "CopiasF" )

   DEFAULT nDevice   := IS_PRINTER
   DEFAULT nCopy     := Max( nCopyClient, nCopiasDocumento( ( D():PresupuestosClientes( nView ) )->cSerPre, "nPreCli", dbfCount ) )

   nCopy             := Max( nCopy, 1 )

   while nImpYet <= nCopy
      GenPreCli( nDevice, cTitle, cCodDoc, cPrinter )
      nImpYet++
   end while

   //Funcion para marcar el documento como imprimido
   lChgImpDoc( D():PresupuestosClientes( nView ) )

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

Static Function nEstadoIncidencia( cNumPre )

   local nEstado  := 0

   if ( dbfPreCliI )->( dbSeek( cNumPre ) )

      while ( dbfPreCliI )->cSerPre + Str( ( dbfPreCliI )->nNumPre ) + ( dbfPreCliI )->cSufPre == cNumPre .and. !( dbfPreCliI )->( Eof() )

         if ( dbfPreCliI )->lListo
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

         ( dbfPreCliI )->( dbSkip() )

      end while

   end if

Return ( nEstado )

//----------------------------------------------------------------------------//

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
      ACTION   ( EndDesgPnt( cCodArt, nTarifa, oPreDiv, oImporte, D():Articulos( nView ), nDouDiv ), oDlg:end( IDOK ) )

   REDEFINE BUTTON ;
      ID       550 ;
      OF       oDlg ;
      ACTION   ( oDlg:end() )

   if nMode != ZOOM_MODE
      oDlg:AddFastKey( VK_F5, {|| EndDesgPnt( cCodArt, nTarifa, oPreDiv, oImporte, D():Articulos( nView ), nDouDiv ), oDlg:end( IDOK ) } )
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


//--------------------------------------------------------------------------//

Static Function PreCliNotas()

   local cObserv  := ""
   local aData    := {}

   aAdd( aData, "Presupuesto " + ( D():PresupuestosClientes( nView ) )->cSerPre + "/" + AllTrim( Str( ( D():PresupuestosClientes( nView ) )->nNumPre ) ) + "/" + Alltrim( ( D():PresupuestosClientes( nView ) )->cSufPre ) + " de " + Rtrim( ( D():PresupuestosClientes( nView ) )->cNomCli ) )
   aAdd( aData, PRE_CLI )
   aAdd( aData, ( D():PresupuestosClientes( nView ) )->cCodCli )
   aAdd( aData, ( D():PresupuestosClientes( nView ) )->cNomCli )
   aAdd( aData, ( D():PresupuestosClientes( nView ) )->cSerPre + Str( ( D():PresupuestosClientes( nView ) )->nNumPre ) + ( D():PresupuestosClientes( nView ) )->cSufPre )

   if !Empty( ( D():PresupuestosClientes( nView ) )->cRetPor )
      cObserv     += Rtrim( ( D():PresupuestosClientes( nView ) )->cRetPor ) + Space( 1 )
   end if

   if !Empty( ( D():PresupuestosClientes( nView ) )->cRetMat )
      cObserv     += Rtrim( ( D():PresupuestosClientes( nView ) )->cRetMat ) + Space( 1 )
   end if

   /*
   if ( D():Clientes( nView ) )->( dbSeek( ( D():PresupuestosClientes( nView ) )->cCodCli ) )

      if !Empty( ( D():Clientes( nView ) )->Telefono )
         cObserv  += "Télefono : " + Rtrim( ( D():Clientes( nView ) )->Telefono ) + Space( 1 )
      end if

      if !Empty( ( D():Clientes( nView ) )->Movil )
         cObserv  += "Móvil : " + Rtrim( ( D():Clientes( nView ) )->Movil ) + Space( 1 )
      end if

      if !Empty( ( D():Clientes( nView ) )->Fax )
         cObserv  += "Fax : " + Rtrim( ( D():Clientes( nView ) )->Fax ) + Space( 1 )
      end if

   end if
   */

   aAdd( aData, cObserv )

   GenerarNotas( aData )

Return ( nil )

//---------------------------------------------------------------------------//

Static Function AppendKit( uTmpLin, aTmpPre )

   local cCodArt
   local cSerPre
   local nNumPre
   local cSufPre
   local nCanPre
   local dFecPre
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
      cSerPre                          := uTmpLin[ _CSERPRE ]
      nNumPre                          := uTmpLin[ _NNUMPRE ]
      cSufPre                          := uTmpLin[ _CSUFPRE ]
      nCanPre                          := uTmpLin[ _NCANPRE ]
      dFecPre                          := uTmpLin[ _DFECHA  ]
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
      cSerPre                          := ( uTmpLin )->cSerPre
      nNumPre                          := ( uTmpLin )->nNumPre
      cSufPre                          := ( uTmpLin )->cSufPre
      nCanPre                          := ( uTmpLin )->nCanPre
      dFecPre                          := ( uTmpLin )->dFecha
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

            ( dbfTmpLin )->nPvpRec     := ( D():Articulos( nView ) )->PvpRec
            ( dbfTmpLin )->cCodImp     := ( D():Articulos( nView ) )->cCodImp
            ( dbfTmpLin )->lLote       := ( D():Articulos( nView ) )->lLote
            ( dbfTmpLin )->nLote       := ( D():Articulos( nView ) )->nLote
            ( dbfTmpLin )->cLote       := ( D():Articulos( nView ) )->cLote

            ( dbfTmpLin )->nValImp     := oNewImp:nValImp( ( D():Articulos( nView ) )->cCodImp )
            ( dbfTmpLin )->nCosDiv     := nCosto( nil, D():Articulos( nView ), dbfKit )

            if ( D():Articulos( nView ) )->lFacCnv
               ( dbfTmpLin )->nFacCnv  := ( D():Articulos( nView ) )->nFacCnv
            end if

            /*
            Valores q arrastramos----------------------------------------------
            */           

            ( dbfTmpLin )->cCodFam     := ( D():Articulos( nView ) )->Familia
            ( dbfTmpLin )->cGrpFam     := cGruFam( ( dbfTmpLin )->cCodFam, dbfFamilia )

            /*
            Datos de la cabecera-----------------------------------------------
            */           

            ( dbfTmpLin )->cSerPre     := cSerPre
            ( dbfTmpLin )->nNumPre     := nNumPre
            ( dbfTmpLin )->cSufPre     := cSufPre
            ( dbfTmpLin )->nCanPre     := nCanPre
            ( dbfTmpLin )->dFecha      := dFecPre
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
               ( dbfTmpLin )->nPreDiv  := nRetPreArt( nTarLin, aTmpPre[ _CDIVPRE ], aTmpPre[ _LIVAINC ], D():Articulos( nView ), dbfDiv, dbfKit, dbfIva, , , oNewImp )
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
               AppendKit( dbfTmpLin, aTmpPre )
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
   local nRecno      := ( D():PresupuestosClientes( nView ) )->( Recno() )
   local nOrdAnt     := ( D():PresupuestosClientes( nView ) )->( OrdSetFocus( 1 ) )
   local oDesde      := TDesdeHasta():Init( ( D():PresupuestosClientes( nView ) )->cSerPre, ( D():PresupuestosClientes( nView ) )->nNumPre, ( D():PresupuestosClientes( nView ) )->cSufPre, GetSysDate() )
   local lCancel     := .f.
   local oBtnAceptar
   local oBtnCancel
   local oFecDoc
   local cFecDoc     := GetSysDate()

   DEFINE DIALOG oDlg ;
      RESOURCE "DUPSERDOC" ;
      TITLE    "Duplicar series de presupuestos" ;
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

 REDEFINE APOLOMETER oTxtDup VAR nTxtDup ;
      ID       160 ;
      NOPERCENTAGE ;
      TOTAL    ( D():PresupuestosClientes( nView ) )->( OrdKeyCount() ) ;
      OF       oDlg

      oDlg:AddFastKey( VK_F5, {|| DupStart( oDesde, oDlg, oBtnAceptar, oBtnCancel, oTxtDup, @lCancel, cFecDoc ) } )

   ACTIVATE DIALOG oDlg CENTER VALID ( lCancel )

   ( D():PresupuestosClientes( nView ) )->( dbGoTo( nRecNo ) )
   ( D():PresupuestosClientes( nView ) )->( ordSetFocus( nOrdAnt ) )

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

      nOrd              := ( D():PresupuestosClientes( nView ) )->( OrdSetFocus( "nNumPre" ) )

      ( D():PresupuestosClientes( nView ) )->( dbSeek( oDesde:cNumeroInicio(), .t. ) )

      while !lCancel .and. ( D():PresupuestosClientes( nView ) )->( !eof() )

         if ( D():PresupuestosClientes( nView ) )->cSerPre >= oDesde:cSerieInicio  .and.;
            ( D():PresupuestosClientes( nView ) )->cSerPre <= oDesde:cSerieFin     .and.;
            ( D():PresupuestosClientes( nView ) )->nNumPre >= oDesde:nNumeroInicio .and.;
            ( D():PresupuestosClientes( nView ) )->nNumPre <= oDesde:nNumeroFin    .and.;
            ( D():PresupuestosClientes( nView ) )->cSufPre >= oDesde:cSufijoInicio .and.;
            ( D():PresupuestosClientes( nView ) )->cSufPre <= oDesde:cSufijoFin

            ++nDuplicados

            oTxtDup:cText  := "Duplicando : " + ( D():PresupuestosClientes( nView ) )->cSerPre + "/" + Alltrim( Str( ( D():PresupuestosClientes( nView ) )->nNumPre ) ) + "/" + ( D():PresupuestosClientes( nView ) )->cSufPre

            DupPresupuesto( cFecDoc )

         end if

         ( D():PresupuestosClientes( nView ) )->( dbSkip() )

         ++nProcesed

         oTxtDup:Set( nProcesed )

      end do

      ( D():PresupuestosClientes( nView ) )->( OrdSetFocus( nOrd ) )

   else

      nOrd              := ( D():PresupuestosClientes( nView ) )->( OrdSetFocus( "dFecPre" ) )

      ( D():PresupuestosClientes( nView ) )->( dbSeek( oDesde:dFechaInicio, .t. ) )

      while !lCancel .and. ( D():PresupuestosClientes( nView ) )->( !eof() )

         if ( D():PresupuestosClientes( nView ) )->dFecPre >= oDesde:dFechaInicio  .and.;
            ( D():PresupuestosClientes( nView ) )->dFecPre <= oDesde:dFechaFin

            ++nDuplicados

            oTxtDup:cText  := "Duplicando : " + ( D():PresupuestosClientes( nView ) )->cSerPre + "/" + Alltrim( Str( ( D():PresupuestosClientes( nView ) )->nNumPre ) ) + "/" + ( D():PresupuestosClientes( nView ) )->cSufPre

            DupPresupuesto( cFecDoc )

         end if

         ( D():PresupuestosClientes( nView ) )->( dbSkip() )

         ++nProcesed

         oTxtDup:Set( nProcesed )

      end do

      ( D():PresupuestosClientes( nView ) )->( OrdSetFocus( nOrd ) )

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

STATIC FUNCTION PreRecDup( cDbf, xField1, xField2, xField3, lCab, cFecDoc )

   local nRec           := ( cDbf )->( Recno() )
   local aTabla         := {}
   local nOrdAnt

   DEFAULT lCab         := .f.

   aTabla               := DBScatter( cDbf )
   aTabla[ _CSERPRE ]   := xField1
   aTabla[ _NNUMPRE ]   := xField2
   aTabla[ _CSUFPRE ]   := xField3

   if lCab

      aTabla[ _CTURPRE     ]  := cCurSesion()
      if !Empty( cFecDoc )
         aTabla[ _DFECPRE  ]  := cFecDoc
      end if
      aTabla[ _CCODCAJ     ]  := oUser():cCaja()
      aTabla[ _DFECENT     ]  := Ctod("")
      aTabla[ _CNUMALB     ]  := Space( 12 )
      aTabla[ _LSNDDOC     ]  := .t.
      aTabla[ _LCLOPRE     ]  := .f.
      aTabla[ _CCODUSR     ]  := Auth():Codigo()
      aTabla[ _DFECCRE     ]  := GetSysDate()
      aTabla[ _CTIMCRE     ]  := Time()
      aTabla[ _LIMPRIMIDO  ]  := .f.
      aTabla[ _DFECIMP     ]  := Ctod("")
      aTabla[ _CHORIMP     ]  := Space( 5 )
      aTabla[ _CCODDLG     ]  := Application():CodigoDelegacion()
      aTabla[ _LESTADO     ]  := .f.

      nOrdAnt                 := ( cDbf )->( OrdSetFocus( "NNUMPRE" ) )

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

STATIC FUNCTION DupPresupuesto( cFecDoc )

   local nNewNumPre  := 0

   //Recogemos el nuevo numero de presupuesto--------------------------------------

   nNewNumPre  := nNewDoc( ( D():PresupuestosClientes( nView ) )->cSerPre, D():PresupuestosClientes( nView ), "NPRECLI" )

   //Duplicamos las cabeceras--------------------------------------------------

   PreRecDup( D():PresupuestosClientes( nView ), ( D():PresupuestosClientes( nView ) )->cSerPre, nNewNumPre, ( D():PresupuestosClientes( nView ) )->cSufPre, .t., cFecDoc )

   //Duplicamos las lineas del documento---------------------------------------

   if ( D():PresupuestosClientesLineas( nView ) )->( dbSeek( ( D():PresupuestosClientes( nView ) )->cSerPre + Str( ( D():PresupuestosClientes( nView ) )->nNumPre ) + ( D():PresupuestosClientes( nView ) )->cSufPre ) )

      while ( D():PresupuestosClientes( nView ) )->cSerPre + Str( ( D():PresupuestosClientes( nView ) )->nNumPre ) + ( D():PresupuestosClientes( nView ) )->cSufPre == ( D():PresupuestosClientesLineas( nView ) )->cSerPre + Str( ( D():PresupuestosClientesLineas( nView ) )->nNumPre ) + ( D():PresupuestosClientesLineas( nView ) )->cSufPre .and. ;
            !( D():PresupuestosClientesLineas( nView ) )->( Eof() )

         PreRecDup( D():PresupuestosClientesLineas( nView ), ( D():PresupuestosClientes( nView ) )->cSerPre, nNewNumPre, ( D():PresupuestosClientes( nView ) )->cSufPre, .f. )

         ( D():PresupuestosClientesLineas( nView ) )->( dbSkip() )

      end while

   end if

   //Duplicamos los documentos-------------------------------------------------

   if ( dbfPreCliD )->( dbSeek( ( D():PresupuestosClientes( nView ) )->cSerPre + Str( ( D():PresupuestosClientes( nView ) )->nNumPre ) + ( D():PresupuestosClientes( nView ) )->cSufPre ) )

      while ( D():PresupuestosClientes( nView ) )->cSerPre + Str( ( D():PresupuestosClientes( nView ) )->nNumPre ) + ( D():PresupuestosClientes( nView ) )->cSufPre == ( dbfPreCliD )->cSerPre + Str( ( dbfPreCliD )->nNumPre ) + ( dbfPreCliD )->cSufPre .and. ;
            !( dbfPreCliD )->( Eof() )

         PreRecDup( dbfPreCliD, ( D():PresupuestosClientes( nView ) )->cSerPre, nNewNumPre, ( D():PresupuestosClientes( nView ) )->cSufPre, .f. )

         ( dbfPreCliD )->( dbSkip() )

      end while

   end if

RETURN ( .t. )

//---------------------------------------------------------------------------//

STATIC FUNCTION SetDialog( aGet, oSayDias, oSayTxtDias, oSayGetRnt, oGetRnt )

   if oTipPre:nAt == 2

      aGet[ _DFECENTR ]:Show()
      aGet[ _DFECSAL  ]:Show()
      aGet[ _CSUPRE   ]:Hide()

      oSayDias:Show()
      oSayTxtDias:Show()

   else

      aGet[ _DFECENTR ]:Hide()
      aGet[ _DFECSAL  ]:Hide()
      aGet[ _CSUPRE   ]:Show()

      oSayDias:Hide()
      oSayTxtDias:Hide()

   end if

   aGet[ _DFECENTR ]:Refresh()
   aGet[ _DFECSAL  ]:Refresh()
   aGet[ _CSUPRE   ]:Refresh()

   oSayDias:Refresh()
   oSayTxtDias:Refresh()

   if !lAccArticulo() .or. SQLAjustableModel():getRolNoMostrarRentabilidad( Auth():rolUuid() )

      if !Empty( oSayGetRnt )
         oSayGetRnt:Hide()
      end if

      if !Empty( oGetRnt )
         oGetRnt:Hide()
      end if

   end if

Return nil

//---------------------------------------------------------------------------//

STATIC FUNCTION ChangeTarifa( aTmp, aGet, aTmpPre )

   local nPrePro  := 0

   if !aTmp[ __LALQUILER ]

      nPrePro     := nPrePro( aTmp[ _CREF ], aTmp[ _CCODPR1 ], aTmp[ _CVALPR1 ], aTmp[ _CCODPR2 ], aTmp[ _CVALPR2 ], aTmp[ _NTARLIN ], aTmpPre[ _LIVAINC ], dbfArtDiv, dbfTarPreL, aTmpPre[ _CCODTAR ] )

      if nPrePro == 0
         nPrePro  := nRetPreArt( aTmp[ _NTARLIN ], aTmpPre[ _CDIVPRE ], aTmpPre[ _LIVAINC ], D():Articulos( nView ), dbfDiv, dbfKit, dbfIva, , , oNewImp )
      end if

      if nPrePro != 0
         aGet[ _NPREDIV ]:cText( nPrePro )
      end if


   else

      aGet[ _NPREDIV ]:cText( 0 )

      nPrePro := nPreAlq( aTmp[ _CREF ], aTmp[ _NTARLIN ], aTmpPre[ _LIVAINC ], D():Articulos( nView ) )

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
            if !Empty( aGet[ ( D():PresupuestosClientesLineas( nView ) )->( fieldpos( "nMedUno" ) ) ] )
               aGet[ ( D():PresupuestosClientesLineas( nView ) )->( fieldpos( "nMedUno" ) ) ]:oSay:SetText( oUndMedicion:oDbf:cTextoDim1 )
               aGet[ ( D():PresupuestosClientesLineas( nView ) )->( fieldpos( "nMedUno" ) ) ]:cText( ( D():Articulos( nView ) )->nLngArt )
               aGet[ ( D():PresupuestosClientesLineas( nView ) )->( fieldpos( "nMedUno" ) ) ]:Show()
            else
               aTmp[ ( D():PresupuestosClientesLineas( nView ) )->( fieldpos( "nMedUno" ) ) ]  := ( D():Articulos( nView ) )->nLngArt
            end if
         else
            if !Empty( aGet[ ( D():PresupuestosClientesLineas( nView ) )->( fieldpos( "nMedUno" ) ) ] )
               aGet[ ( D():PresupuestosClientesLineas( nView ) )->( fieldpos( "nMedUno" ) ) ]:cText( 0 )
               aGet[ ( D():PresupuestosClientesLineas( nView ) )->( fieldpos( "nMedUno" ) ) ]:Hide()
            else
               aTmp[ ( D():PresupuestosClientesLineas( nView ) )->( fieldpos( "nMedUno" ) ) ]  := 0
            end if
         end if

         if oUndMedicion:oDbf:nDimension >= 2 .and. !Empty( oUndMedicion:oDbf:cTextoDim2 )
            if !Empty( aGet[ ( D():PresupuestosClientesLineas( nView ) )->( fieldpos( "nMedDos" ) ) ] )
               aGet[ ( D():PresupuestosClientesLineas( nView ) )->( fieldpos( "nMedDos" ) ) ]:oSay:SetText( oUndMedicion:oDbf:cTextoDim2 )
               aGet[ ( D():PresupuestosClientesLineas( nView ) )->( fieldpos( "nMedDos" ) ) ]:cText( ( D():Articulos( nView ) )->nAltArt )
               aGet[ ( D():PresupuestosClientesLineas( nView ) )->( fieldpos( "nMedDos" ) ) ]:Show()
            else
               aTmp[ ( D():PresupuestosClientesLineas( nView ) )->( fieldpos( "nMedDos" ) ) ]  := ( D():Articulos( nView ) )->nAltArt
            end if

         else
            if !Empty( aGet[ ( D():PresupuestosClientesLineas( nView ) )->( fieldpos( "nMedDos" ) ) ] )
               aGet[ ( D():PresupuestosClientesLineas( nView ) )->( fieldpos( "nMedDos" ) ) ]:cText( 0 )
               aGet[ ( D():PresupuestosClientesLineas( nView ) )->( fieldpos( "nMedDos" ) ) ]:Hide()
            else
               aTmp[ ( D():PresupuestosClientesLineas( nView ) )->( fieldpos( "nMedDos" ) ) ]  := 0
            end if
         end if

         if oUndMedicion:oDbf:nDimension >= 3 .and. !Empty( oUndMedicion:oDbf:cTextoDim3 )
            if !Empty( aGet[ ( D():PresupuestosClientesLineas( nView ) )->( fieldpos( "nMedTre" ) ) ] )
               aGet[ ( D():PresupuestosClientesLineas( nView ) )->( fieldpos( "nMedTre" ) ) ]:oSay:SetText( oUndMedicion:oDbf:cTextoDim3 )
               aGet[ ( D():PresupuestosClientesLineas( nView ) )->( fieldpos( "nMedTre" ) ) ]:cText( ( D():Articulos( nView ) ) ->nAncArt )
               aGet[ ( D():PresupuestosClientesLineas( nView ) )->( fieldpos( "nMedTre" ) ) ]:Show()
            else
               aTmp[ ( D():PresupuestosClientesLineas( nView ) )->( fieldpos( "nMedTre" ) ) ]  := ( D():Articulos( nView ) )->nAncArt
            end if
         else
            if !Empty( aGet[ ( D():PresupuestosClientesLineas( nView ) )->( fieldpos( "nMedTre" ) ) ] )
               aGet[ ( D():PresupuestosClientesLineas( nView ) )->( fieldpos( "nMedTre" ) ) ]:cText( 0 )
               aGet[ ( D():PresupuestosClientesLineas( nView ) )->( fieldpos( "nMedTre" ) ) ]:Hide()
            else
               aTmp[ ( D():PresupuestosClientesLineas( nView ) )->( fieldpos( "nMedTre" ) ) ]  := 0
            end if
         end if

      else

         if !Empty( aGet[ ( D():PresupuestosClientesLineas( nView ) )->( fieldpos( "nMedUno" ) ) ] )
            aGet[ ( D():PresupuestosClientesLineas( nView ) )->( fieldpos( "nMedUno" ) ) ]:Hide()
            aGet[ ( D():PresupuestosClientesLineas( nView ) )->( fieldpos( "nMedUno" ) ) ]:cText( 0 )
         end if

         if !Empty( aGet[ ( D():PresupuestosClientesLineas( nView ) )->( fieldpos( "nMedDos" ) ) ] )
            aGet[ ( D():PresupuestosClientesLineas( nView ) )->( fieldpos( "nMedDos" ) ) ]:Hide()
            aGet[ ( D():PresupuestosClientesLineas( nView ) )->( fieldpos( "nMedDos" ) ) ]:cText( 0 )
         end if

         if !Empty( aGet[ ( D():PresupuestosClientesLineas( nView ) )->( fieldpos( "nMedTre" ) ) ] )
            aGet[ ( D():PresupuestosClientesLineas( nView ) )->( fieldpos( "nMedTre" ) ) ]:Hide()
            aGet[ ( D():PresupuestosClientesLineas( nView ) )->( fieldpos( "nMedTre" ) ) ]:cText( 0 )
         end if

      end if

      cOldUndMed := cNewUndMed

   end if

Return .t.

//---------------------------------------------------------------------------//

Static Function loadComisionAgente( aTmp, aGet, aTmpPre )

   local nComisionAgenteTarifa   

   nComisionAgenteTarifa      := nComisionAgenteTarifa( aTmpPre[ _CCODAGE ], aTmp[ _NTARLIN ], nView ) 
   if nComisionAgenteTarifa == 0
      nComisionAgenteTarifa   := aTmpPre[ _NPCTCOMAGE ]
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

   oFr:SetWorkArea(     "Presupuestos", ( D():PresupuestosClientes( nView ) )->( Select() ), .f., { FR_RB_CURRENT, FR_RB_CURRENT, 0 } )
   oFr:SetFieldAliases( "Presupuestos", cItemsToReport( aItmPreCli() ) )

   oFr:SetWorkArea(     "Lineas de presupuestos", ( D():PresupuestosClientesLineas( nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Lineas de presupuestos", cItemsToReport( aColPreCli() ) )

   oFr:SetWorkArea(     "Incidencias de presupuestos", ( dbfPreCliI )->( Select() ) )
   oFr:SetFieldAliases( "Incidencias de presupuestos", cItemsToReport( aIncPreCli() ) )

   oFr:SetWorkArea(     "Documentos de presupuestos", ( dbfPreCliD )->( Select() ) )
   oFr:SetFieldAliases( "Documentos de presupuestos", cItemsToReport( aPreCliDoc() ) )

   oFr:SetWorkArea(     "Situaciones de presupuesto", ( D():PresupuestosClientesSituaciones( nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Situaciones de presupuesto", cItemsToReport( aPreCliEst() ) )

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

   oFr:SetWorkArea(     "Ofertas", ( dbfOferta )->( Select() ) )
   oFr:SetFieldAliases( "Ofertas", cItemsToReport( aItmOfe() ) )

   oFr:SetWorkArea(     "Unidades de medición",  oUndMedicion:Select() )
   oFr:SetFieldAliases( "Unidades de medición",  cObjectsToReport( oUndMedicion:oDbf ) )

   oFr:SetWorkArea(     "Usuarios", ( dbfUsr )->( Select() ) )
   oFr:SetFieldAliases( "Usuarios", cItemsToReport( aItmUsuario() ) )

   oFr:SetWorkArea(     "Impuestos especiales",  oNewImp:Select() )
   oFr:SetFieldAliases( "Impuestos especiales",  cObjectsToReport( oNewImp:oDbf ) )

   oFr:SetWorkArea(     "Familias", ( dbfFamilia )->( Select() ) )
   oFr:SetFieldAliases( "Familias", cItemsToReport( aItmFam() ) )

   oFr:SetMasterDetail( "Presupuestos", "Lineas de presupuestos",          {|| ( D():PresupuestosClientes( nView ) )->cSerPre + Str( ( D():PresupuestosClientes( nView ) )->nNumPre ) + ( D():PresupuestosClientes( nView ) )->cSufPre } )
   oFr:SetMasterDetail( "Presupuestos", "Incidencias de presupuestos",     {|| ( D():PresupuestosClientes( nView ) )->cSerPre + Str( ( D():PresupuestosClientes( nView ) )->nNumPre ) + ( D():PresupuestosClientes( nView ) )->cSufPre } )
   oFr:SetMasterDetail( "Presupuestos", "Documentos de presupuestos",      {|| ( D():PresupuestosClientes( nView ) )->cSerPre + Str( ( D():PresupuestosClientes( nView ) )->nNumPre ) + ( D():PresupuestosClientes( nView ) )->cSufPre } )
   oFr:SetMasterDetail( "Presupuestos", "Empresa",                         {|| cCodigoEmpresaEnUso() } )
   oFr:SetMasterDetail( "Presupuestos", "Clientes",                        {|| ( D():PresupuestosClientes( nView ) )->cCodCli } )
   oFr:SetMasterDetail( "Presupuestos", "Obras",                           {|| ( D():PresupuestosClientes( nView ) )->cCodCli + ( D():PresupuestosClientes( nView ) )->cCodObr } )
   oFr:SetMasterDetail( "Presupuestos", "Almacen",                         {|| ( D():PresupuestosClientes( nView ) )->cCodAlm } )
   oFr:SetMasterDetail( "Presupuestos", "Rutas",                           {|| ( D():PresupuestosClientes( nView ) )->cCodRut } )
   oFr:SetMasterDetail( "Presupuestos", "Agentes",                         {|| ( D():PresupuestosClientes( nView ) )->cCodAge } )
   oFr:SetMasterDetail( "Presupuestos", "Formas de pago",                  {|| ( D():PresupuestosClientes( nView ) )->cCodPgo } )
   oFr:SetMasterDetail( "Presupuestos", "Transportistas",                  {|| ( D():PresupuestosClientes( nView ) )->cCodTrn } )
   oFr:SetMasterDetail( "Presupuestos", "Usuarios",                        {|| ( D():PresupuestosClientes( nView ) )->cCodUsr } )

   oFr:SetMasterDetail( "Lineas de presupuestos", "Artículos",             {|| ( D():PresupuestosClientesLineas( nView ) )->cRef } )
   oFr:SetMasterDetail( "Lineas de presupuestos", "Ofertas",               {|| ( D():PresupuestosClientesLineas( nView ) )->cRef } )
   oFr:SetMasterDetail( "Lineas de presupuestos", "Unidades de medición",  {|| ( D():PresupuestosClientesLineas( nView ) )->cUnidad } )
   oFr:SetMasterDetail( "Lineas de presupuestos", "Impuestos especiales",  {|| ( D():PresupuestosClientesLineas( nView ) )->cCodImp } )
   oFr:SetMasterDetail( "Lineas de presupuestos", "Familias",               {|| ( D():PresupuestosClientesLineas( nView ) )->cCodFam } )

   oFr:SetResyncPair(   "Presupuestos", "Lineas de presupuestos" )
   oFr:SetResyncPair(   "Presupuestos", "Incidencias de presupuestos" )
   oFr:SetResyncPair(   "Presupuestos", "Documentos de presupuestos" )
   oFr:SetResyncPair(   "Presupuestos", "Empresa" )
   oFr:SetResyncPair(   "Presupuestos", "Clientes" )
   oFr:SetResyncPair(   "Presupuestos", "Obras" )
   oFr:SetResyncPair(   "Presupuestos", "Almacenes" )
   oFr:SetResyncPair(   "Presupuestos", "Rutas" )
   oFr:SetResyncPair(   "Presupuestos", "Agentes" )
   oFr:SetResyncPair(   "Presupuestos", "Formas de pago" )
   oFr:SetResyncPair(   "Presupuestos", "Transportistas" )
   oFr:SetResyncPair(   "Presupuestos", "Usuarios" )

   oFr:SetResyncPair(   "Lineas de presupuestos", "Artículos" )
   oFr:SetResyncPair(   "Lineas de presupuestos", "Ofertas" )
   oFr:SetResyncPair(   "Lineas de presupuestos", "Unidades de medición" )
   oFr:SetResyncPair(   "Lineas de presupuestos", "Impuestos especiales" )
   oFr:SetResyncPair(   "Lineas de presupuestos", "Familias" )

Return nil

//---------------------------------------------------------------------------//

Static Function VariableReport( oFr )

   oFr:DeleteCategory(  "Presupuestos" )
   oFr:DeleteCategory(  "Lineas de presupuestos" )

   /*
   Creación de variables----------------------------------------------------
   */

   oFr:AddVariable(     "Presupuestos",             "Total bruto",                         "GetHbVar('nTotBrt')" )
   oFr:AddVariable(     "Presupuestos",             "Total presupuesto",                   "GetHbVar('nTotPre')" )
   oFr:AddVariable(     "Presupuestos",             "Total descuento",                     "GetHbVar('nTotDto')" )
   oFr:AddVariable(     "Presupuestos",             "Total descuento pronto pago",         "GetHbVar('nTotDpp')" )
   oFr:AddVariable(     "Presupuestos",             "Total descuentos",                    "GetHbVar('nTotalDto')" )
   oFr:AddVariable(     "Presupuestos",             "Total neto",                          "GetHbVar('nTotNet')" )
   oFr:AddVariable(     "Presupuestos",             "Total primer descuento definible",    "GetHbVar('nTotUno')" )
   oFr:AddVariable(     "Presupuestos",             "Total segundo descuento definible",   "GetHbVar('nTotDos')" )
   oFr:AddVariable(     "Presupuestos",             "Total " + cImp(),                     "GetHbVar('nTotIva')" )
   oFr:AddVariable(     "Presupuestos",             "Total RE",                            "GetHbVar('nTotReq')" )
   oFr:AddVariable(     "Presupuestos",             "Total página",                        "GetHbVar('nTotPag')" )
   oFr:AddVariable(     "Presupuestos",             "Total retención",                     "GetHbVar('nTotRet')" )
   oFr:AddVariable(     "Presupuestos",             "Total peso",                          "GetHbVar('nTotPes')" )
   oFr:AddVariable(     "Presupuestos",             "Total costo",                         "GetHbVar('nTotCos')" )
   oFr:AddVariable(     "Presupuestos",             "Total anticipado",                    "GetHbVar('nTotAnt')" )
   oFr:AddVariable(     "Presupuestos",             "Total cobrado",                       "GetHbVar('nTotCob')" )
   oFr:AddVariable(     "Presupuestos",             "Total artículos",                     "GetHbVar('nTotArt')" )
   oFr:AddVariable(     "Presupuestos",             "Total cajas",                         "GetHbVar('nTotCaj')" )
   oFr:AddVariable(     "Presupuestos",             "Cuenta por defecto del cliente",      "GetHbVar('cCtaCli')" )

   oFr:AddVariable(     "Presupuestos",             "Bruto primer tipo de " + cImp(),      "GetHbArrayVar('aIvaUno',1)" )
   oFr:AddVariable(     "Presupuestos",             "Bruto segundo tipo de " + cImp(),     "GetHbArrayVar('aIvaDos',1)" )
   oFr:AddVariable(     "Presupuestos",             "Bruto tercer tipo de " + cImp(),      "GetHbArrayVar('aIvaTre',1)" )
   oFr:AddVariable(     "Presupuestos",             "Base primer tipo de " + cImp(),       "GetHbArrayVar('aIvaUno',2)" )
   oFr:AddVariable(     "Presupuestos",             "Base segundo tipo de " + cImp(),      "GetHbArrayVar('aIvaDos',2)" )
   oFr:AddVariable(     "Presupuestos",             "Base tercer tipo de " + cImp(),       "GetHbArrayVar('aIvaTre',2)" )
   oFr:AddVariable(     "Presupuestos",             "Porcentaje primer tipo " + cImp(),    "GetHbArrayVar('aIvaUno',3)" )
   oFr:AddVariable(     "Presupuestos",             "Porcentaje segundo tipo " + cImp(),   "GetHbArrayVar('aIvaDos',3)" )
   oFr:AddVariable(     "Presupuestos",             "Porcentaje tercer tipo " + cImp(),    "GetHbArrayVar('aIvaTre',3)" )
   oFr:AddVariable(     "Presupuestos",             "Porcentaje primer tipo RE",           "GetHbArrayVar('aIvaUno',4)" )
   oFr:AddVariable(     "Presupuestos",             "Porcentaje segundo tipo RE",          "GetHbArrayVar('aIvaDos',4)" )
   oFr:AddVariable(     "Presupuestos",             "Porcentaje tercer tipo RE",           "GetHbArrayVar('aIvaTre',4)" )
   oFr:AddVariable(     "Presupuestos",             "Importe primer tipo " + cImp(),       "GetHbArrayVar('aIvaUno',8)" )
   oFr:AddVariable(     "Presupuestos",             "Importe segundo tipo " + cImp(),      "GetHbArrayVar('aIvaDos',8)" )
   oFr:AddVariable(     "Presupuestos",             "Importe tercer tipo " + cImp(),       "GetHbArrayVar('aIvaTre',8)" )
   oFr:AddVariable(     "Presupuestos",             "Importe primer RE",                   "GetHbArrayVar('aIvaUno',9)" )
   oFr:AddVariable(     "Presupuestos",             "Importe segundo RE",                  "GetHbArrayVar('aIvaDos',9)" )
   oFr:AddVariable(     "Presupuestos",             "Importe tercer RE",                   "GetHbArrayVar('aIvaTre',9)" )

   oFr:AddVariable(     "Presupuestos",             "Total unidades primer tipo de impuestos especiales",            "GetHbArrayVar('aIvmUno',1 )" )
   oFr:AddVariable(     "Presupuestos",             "Total unidades segundo tipo de impuestos especiales",           "GetHbArrayVar('aIvmDos',1 )" )
   oFr:AddVariable(     "Presupuestos",             "Total unidades tercer tipo de impuestos especiales",            "GetHbArrayVar('aIvmTre',1 )" )
   oFr:AddVariable(     "Presupuestos",             "Importe del primer tipo de impuestos especiales",               "GetHbArrayVar('aIvmUno',2 )" )
   oFr:AddVariable(     "Presupuestos",             "Importe del segundo tipo de impuestos especiales",              "GetHbArrayVar('aIvmDos',2 )" )
   oFr:AddVariable(     "Presupuestos",             "Importe del tercer tipo de impuestos especiales",               "GetHbArrayVar('aIvmTre',2 )" )
   oFr:AddVariable(     "Presupuestos",             "Total importe primer tipo de impuestos especiales",             "GetHbArrayVar('aIvmUno',3 )" )
   oFr:AddVariable(     "Presupuestos",             "Total importe segundo tipo de impuestos especiales",            "GetHbArrayVar('aIvmDos',3 )" )
   oFr:AddVariable(     "Presupuestos",             "Total importe tercer tipo de impuestos especiales",             "GetHbArrayVar('aIvmTre',3 )" )

   oFr:AddVariable(     "Presupuestos",             "Fecha del primer vencimiento",        "GetHbArrayVar('aDatVto',1)" )
   oFr:AddVariable(     "Presupuestos",             "Fecha del segundo vencimiento",       "GetHbArrayVar('aDatVto',2)" )
   oFr:AddVariable(     "Presupuestos",             "Fecha del tercer vencimiento",        "GetHbArrayVar('aDatVto',3)" )
   oFr:AddVariable(     "Presupuestos",             "Fecha del cuarto vencimiento",        "GetHbArrayVar('aDatVto',4)" )
   oFr:AddVariable(     "Presupuestos",             "Fecha del quinto vencimiento",        "GetHbArrayVar('aDatVto',5)" )
   oFr:AddVariable(     "Presupuestos",             "Fecha del sexto vencimiento",         "GetHbArrayVar('aDatVto',6)" )
   oFr:AddVariable(     "Presupuestos",             "Fecha del septimo vencimiento",       "GetHbArrayVar('aDatVto',7)" )
   oFr:AddVariable(     "Presupuestos",             "Fecha del octavovencimiento",         "GetHbArrayVar('aDatVto',8)" )
   oFr:AddVariable(     "Presupuestos",             "Fecha del noveno vencimiento",        "GetHbArrayVar('aDatVto',9)" )
   oFr:AddVariable(     "Presupuestos",             "Fecha del decimo vencimiento",        "GetHbArrayVar('aDatVto',10)" )
   oFr:AddVariable(     "Presupuestos",             "Fecha del undecimo vencimiento",      "GetHbArrayVar('aDatVto',11)" )
   oFr:AddVariable(     "Presupuestos",             "Fecha del duodecimo vencimiento",     "GetHbArrayVar('aDatVto',12)" )
   
   oFr:AddVariable(     "Presupuestos",             "Importe del primer vencimiento",      "GetHbArrayVar('aImpVto',1)" )
   oFr:AddVariable(     "Presupuestos",             "Importe del segundo vencimiento",     "GetHbArrayVar('aImpVto',2)" )
   oFr:AddVariable(     "Presupuestos",             "Importe del tercero vencimiento",     "GetHbArrayVar('aImpVto',3)" )
   oFr:AddVariable(     "Presupuestos",             "Importe del cuarto vencimiento",      "GetHbArrayVar('aImpVto',4)" )
   oFr:AddVariable(     "Presupuestos",             "Importe del quinto vencimiento",      "GetHbArrayVar('aImpVto',5)" )
   oFr:AddVariable(     "Presupuestos",             "Importe del sexto vencimiento",       "GetHbArrayVar('aImpVto',6)" )
   oFr:AddVariable(     "Presupuestos",             "Importe del septimo vencimiento",     "GetHbArrayVar('aImpVto',7)" )
   oFr:AddVariable(     "Presupuestos",             "Importe del octavo vencimiento",      "GetHbArrayVar('aImpVto',8)" )
   oFr:AddVariable(     "Presupuestos",             "Importe del noveno vencimiento",      "GetHbArrayVar('aImpVto',9)" )
   oFr:AddVariable(     "Presupuestos",             "Importe del decimo vencimiento",      "GetHbArrayVar('aImpVto',10)" )
   oFr:AddVariable(     "Presupuestos",             "Importe del undecimo vencimiento",    "GetHbArrayVar('aImpVto',11)" )
   oFr:AddVariable(     "Presupuestos",             "Importe del duodecimo vencimiento",   "GetHbArrayVar('aImpVto',12)" )

   oFr:AddVariable(     "Lineas de presupuestos",   "Detalle del artículo",                "CallHbFunc('cDesPreCli' )" )
   oFr:AddVariable(     "Lineas de presupuestos",   "Detalle del artículo otro lenguaje",  "CallHbFunc('cDesPreCliLeng')" )
   oFr:AddVariable(     "Lineas de presupuestos",   "Total unidades artículo",             "CallHbFunc('nTotNPreCli')" )
   oFr:AddVariable(     "Lineas de presupuestos",   "Precio unitario del artículo",        "CallHbFunc('nTotUPreCli')" )
   oFr:AddVariable(     "Lineas de presupuestos",   "Total línea de presupuesto",          "CallHbFunc('nTotLPreCli')" )
   oFr:AddVariable(     "Lineas de presupuestos",   "Total peso por línea",                "CallHbFunc('nPesLPreCli')" )
   oFr:AddVariable(     "Lineas de presupuestos",   "Total final línea del presupuesto",   "CallHbFunc('nTotFPreCli')" )

Return nil

//---------------------------------------------------------------------------//

Static Function YearComboBoxChange()

   if ( oWndBrw:oWndBar:cYearComboBox() != __txtAllYearsFilter__ )
      oWndBrw:oWndBar:setYearComboBoxExpression( "Year( Field->dFecPre ) == " + oWndBrw:oWndBar:cYearComboBox() )
   else
      oWndBrw:oWndBar:setYearComboBoxExpression( "" )
   end if 

   oWndBrw:chgFilter()

Return nil

//---------------------------------------------------------------------------//

Static Function hValue( aTmp, aTmpPre )

   local hValue                  := {=>}

   do case 
      case ValType( aTmp ) == "A"

         hValue[ "cCodigoArticulo"   ] := aTmp[ _CREF ]
         hValue[ "cCodigoPropiedad1" ] := aTmp[ _CCODPR1 ]
         hValue[ "cCodigoPropiedad2" ] := aTmp[ _CCODPR2 ]
         hValue[ "cValorPropiedad1"  ] := aTmp[ _CVALPR1 ]
         hValue[ "cValorPropiedad2"  ] := aTmp[ _CVALPR2 ]
         hValue[ "cCodigoFamilia"    ] := aTmp[ _CCODFAM ]
         hValue[ "nTarifaPrecio"     ] := aTmp[ _NTARLIN ]
         hValue[ "nCajas"            ] := aTmp[ _NCANPRE ]
         hValue[ "nUnidades"         ] := aTmp[ _NUNICAJA ]

      case ValType( aTmp ) == "C"

         hValue[ "cCodigoArticulo"   ] := ( aTmp )->cRef
         hValue[ "cCodigoPropiedad1" ] := ( aTmp )->cCodPr1
         hValue[ "cCodigoPropiedad2" ] := ( aTmp )->cCodPr2
         hValue[ "cValorPropiedad1"  ] := ( aTmp )->cValPr1
         hValue[ "cValorPropiedad2"  ] := ( aTmp )->cValPr2
         hValue[ "cCodigoFamilia"    ] := ( aTmp )->cCodFam
         hValue[ "nTarifaPrecio"     ] := ( aTmp )->nTarLin         
         hValue[ "nCajas"            ] := ( aTmp )->nCanPre
         hValue[ "nUnidades"         ] := ( aTmp )->nUniCaja

   end case      

   do case 
      case ValType( aTmpPre ) == "A"

         hValue[ "cCodigoCliente"    ] := aTmpPre[ _CCODCLI ]
         hValue[ "cCodigoGrupo"      ] := aTmpPre[ _CCODGRP ]
         hValue[ "lIvaIncluido"      ] := aTmpPre[ _LIVAINC ]
         hValue[ "dFecha"            ] := aTmpPre[ _DFECPRE ]
         hValue[ "nDescuentoTarifa"  ] := aTmpPre[ _NDTOTARIFA ]

      case ValType( aTmpPre ) == "C"
         
         hValue[ "cCodigoCliente"    ] := ( aTmpPre )->cCodCli
         hValue[ "cCodigoGrupo"      ] := ( aTmpPre )->cCodGrp
         hValue[ "lIvaIncluido"      ] := ( aTmpPre )->lIvaInc
         hValue[ "dFecha"            ] := ( aTmpPre )->dFecPre
         hValue[ "nDescuentoTarifa"  ] := ( aTmpPre )->nDtoTarifa
   end case

   hValue[ "nTipoDocumento"         ] := PRE_CLI
   hValue[ "nView"                  ] := nView

Return ( hValue )

//---------------------------------------------------------------------------//

Static Function ImprimirSeriesPresupuestosClientes( nDevice, lExt )

   local aStatus
   local oPrinter   
   local cFormato 

   DEFAULT nDevice   := IS_PRINTER
   DEFAULT lExt      := .f.

   // Cremaos el dialogo-------------------------------------------------------

   oPrinter          := PrintSeries():New( nView ):SetVentas()

   // Establecemos sus valores-------------------------------------------------

   oPrinter:Serie(      ( D():PresupuestosClientes( nView ) )->cSerPre )
   oPrinter:Documento(  ( D():PresupuestosClientes( nView ) )->nNumPre )
   oPrinter:Sufijo(     ( D():PresupuestosClientes( nView ) )->cSufPre )

   if lExt

      oPrinter:oFechaInicio:cText( ( D():PresupuestosClientes( nView ) )->dFecPre )
      oPrinter:oFechaFin:cText( ( D():PresupuestosClientes( nView ) )->dFecPre )

   end if

   oPrinter:oFormatoDocumento:TypeDocumento( "RC" )   

   // Formato de documento-----------------------------------------------------

   cFormato          := cFormatoDocumento( ( D():PresupuestosClientes( nView ) )->cSerPre, "nPreCli", D():Contadores( nView ) )
   if empty( cFormato )
      cFormato       := cFirstDoc( "RC", D():Documentos( nView ) )
   end if
   oPrinter:oFormatoDocumento:cText( cFormato )

   // Codeblocks para que trabaje----------------------------------------------

   aStatus           := D():GetInitStatus( "PreCliT", nView )

   oPrinter:bInit    := {||   ( D():PresupuestosClientes( nView ) )->( dbSeek( oPrinter:DocumentoInicio(), .t. ) ) }

   oPrinter:bWhile   := {||   oPrinter:InRangeDocumento( D():PresupuestosClientesId( nView ) )                  .and. ;
                              ( D():PresupuestosClientes( nView ) )->( !eof() ) }

   oPrinter:bFor     := {||   oPrinter:InRangeFecha( ( D():PresupuestosClientes( nView ) )->dFecPre )           .and. ;
                              oPrinter:InRangeCliente( ( D():PresupuestosClientes( nView ) )->cCodCli )         .and. ;
                              oPrinter:InRangeAgente( ( D():PresupuestosClientes( nView ) )->cCodAge )         .and. ;
                              oPrinter:InRangeGrupoCliente( retGrpCli( ( D():PresupuestosClientes( nView ) )->cCodCli, D():Clientes( nView ) ) ) }

   oPrinter:bSkip    := {||   ( D():PresupuestosClientes( nView ) )->( dbSkip() ) }

   oPrinter:bAction  := {||   GenPreCli(  nDevice,; 
                                          "Imprimiendo documento : " + D():PresupuestosClientesId( nView ),;
                                          oPrinter:oFormatoDocumento:uGetValue,;
                                          oPrinter:oImpresora:uGetValue,;
                                          if( !oPrinter:oCopias:lCopiasPredeterminadas, oPrinter:oCopias:uGetValue, ) ) }

   oPrinter:bStart   := {||   if( lExt, oPrinter:DisableRange(), ) }

   // Abrimos el dialogo-------------------------------------------------------

   oPrinter:Resource():End()

   // Restore -----------------------------------------------------------------

   D():SetStatus( "PreCliT", nView, aStatus )
   
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

FUNCTION nTotPreCli( cPresupuesto, cPreCliT, cPreCliL, cIva, cDiv, cFPago, aTmp, cDivRet, lPic )

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

   DEFAULT cPreCliT        := D():PresupuestosClientes( nView )
   DEFAULT cPreCliL        := D():PresupuestosClientesLineas( nView )
   DEFAULT cIva            := dbfIva
   DEFAULT cDiv            := dbfDiv
   DEFAULT cFPago          := dbfFPago
   DEFAULT cPresupuesto    := ( D():PresupuestosClientes( nView ) )->cSerPre + Str( ( D():PresupuestosClientes( nView ) )->nNumPre ) + ( D():PresupuestosClientes( nView ) )->cSufPre
   DEFAULT lPic            := .f.

   if Empty( Select( cPreCliT ) )
      Return ( 0 )
   end if

   if Empty( Select( cPreCliL ) )
      Return ( 0 )
   end if

   if Empty( Select( cIva ) )
      Return ( 0 )
   end if

   if Empty( Select( cDiv ) )
      Return ( 0 )
   end if

   public nTotBrt    := 0
   public nTotPre    := 0
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

   public cCtaCli    := cClientCuenta( ( cPreCliT )->cCodCli )

   nRecno            := ( cPreCliL )->( RecNo() )

   if aTmp != nil
      lRecargo       := aTmp[ _LRECARGO]
      nDtoEsp        := aTmp[ _NDTOESP ]
      nDtoPP         := aTmp[ _NDPP    ]
      nDtoUno        := aTmp[ _NDTOUNO ]
      nDtoDos        := aTmp[ _NDTODOS ]
      cCodDiv        := aTmp[ _CDIVPRE ]
      nVdvDiv        := aTmp[ _NVDVPRE ]
      dFecFac        := aTmp[ _DFECPRE ]
      lIvaInc        := aTmp[ _LIVAINC ]
      nIvaMan        := aTmp[ _NIVAMAN ]
      nManObr        := aTmp[ _NMANOBR ]
      nDtoAtp        := aTmp[ _NDTOATP ]
      nSbrAtp        := aTmp[ _NSBRATP ]
      nKgsTrn        := aTmp[ _NKGSTRN ]
      lPntVer        := aTmp[ _LOPERPV ]
      nRegIva        := aTmp[ _NREGIVA ]
      bCondition     := {|| !( cPreCliL )->( eof() ) }
      ( cPreCliL )->( dbGoTop() )
   else
      lRecargo       := ( cPreCliT )->lRecargo
      nDtoEsp        := ( cPreCliT )->nDtoEsp
      nDtoPP         := ( cPreCliT )->nDpp
      nDtoUno        := ( cPreCliT )->nDtoUno
      nDtoDos        := ( cPreCliT )->nDtoDos
      cCodDiv        := ( cPreCliT )->cDivPre
      nVdvDiv        := ( cPreCliT )->nVdvPre
      dFecFac        := ( cPreCliT )->dFecPre
      nIvaMan        := ( cPreCliT )->nIvaMan
      lIvaInc        := ( cPreCliT )->lIvaInc
      nManObr        := ( cPreCliT )->nManObr
      nDtoAtp        := ( cPreCliT )->nDtoAtp
      nSbrAtp        := ( cPreCliT )->nSbrAtp
      nKgsTrn        := ( cPreCliT )->nKgsTrn
      lPntVer        := ( cPreCliT )->lOperPV
      nRegIva        := ( cPreCliT )->nRegIva
      bCondition     := {|| ( cPreCliL )->cSerPre + Str( ( cPreCliL )->nNumPre ) + ( cPreCliL )->cSufPre == cPresupuesto .and. !( cPreCliL )->( eof() ) }
      ( cPreCliL )->( dbSeek( cPresupuesto ) )
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

      if lValLine( cPreCliL )

         if ( cPreCliL )->lTotLin

            /*
            Esto es para evitar escirbir en el fichero muchas veces
            */

            if ( cPreCliL )->nPreDiv != nTotalLin .OR. ( cPreCliL )->nUniCaja != nTotalUnd

               if ( cPreCliL )->( dbRLock() )
                  ( cPreCliL )->nPreDiv    := nTotalLin
                  ( cPreCliL )->nUniCaja   := nTotalUnd
                  ( cPreCliL )->( dbUnLock() )
               end if

            end if

            /*
            Limpien------------------------------------------------------------
            */

            nTotalLin         := 0
            nTotalUnd         := 0

         else

            nTotArt           := nTotLPreCli( cPreCliL, nDouDiv, nRouDiv, , , .f., .f. )
            nTotPnt           := if( lPntVer, nPntLPreCli( cPreCliL, nDpvDiv ), 0 )
            nTotTrn           := nTrnLPreCli( cPreCliL, nDouDiv )
            nTotIvm           := nTotIPreCli( cPreCliL, nDouDiv, nRouDiv )
            nTotCos           += nTotCPreCli( cPreCliL, nDouDiv, nRouDiv )
            nTotPes           += nPesLPreCli( cPreCliL )
            nDescuentosLineas += nTotDtoLPreCli( cPreCliL, nDouDiv )

            if aTmp != nil
               nTotAge        += nComLPreCli( aTmp, cPreCliL, nDouDiv, nRouDiv )
            else
               nTotAge        += nComLPreCli( cPreCliT, cPreCliL, nDouDiv, nRouDiv )
            end if

            nNumArt           += nTotNPreCli( cPreCliL )
            nNumCaj           += ( cPreCliL )->nCanPre

            /*
            Acumuladores para las lineas de totales
            */

            nTotUnd           += nTotNPreCli( cPreCliL )

            /*
            Estudio de impuestos-----------------------------------------------------
            */

            DO CASE
            CASE _NPCTIVA1 == nil .OR. _NPCTIVA1 == ( cPreCliL )->nIva
               _NPCTIVA1      := ( cPreCliL )->nIva
               _NPCTREQ1      := ( cPreCliL )->nReq
               _NBRTIVA1      += nTotArt
               _NIVMIVA1      += nTotIvm
               _NTRNIVA1      += nTotTrn
               _NPNTVER1      += nTotPnt

            CASE _NPCTIVA2 == NIL .OR. _NPCTIVA2 == ( cPreCliL )->nIva
               _NPCTIVA2      := ( cPreCliL )->nIva
               _NPCTREQ2      := ( cPreCliL )->nReq
               _NBRTIVA2      += nTotArt
               _NIVMIVA2      += nTotIvm
               _NTRNIVA2      += nTotTrn
               _NPNTVER2      += nTotPnt

            CASE _NPCTIVA3 == NIL .OR. _NPCTIVA3 == ( cPreCliL )->nIva
               _NPCTIVA3      := ( cPreCliL )->nIva
               _NPCTREQ3      := ( cPreCliL )->nReq
               _NBRTIVA3      += nTotArt
               _NIVMIVA3      += nTotIvm
               _NTRNIVA3      += nTotTrn
               _NPNTVER3      += nTotPnt

            END CASE

            /*
            Estudio de IVMH-----------------------------------------------------
            */
            if ( cPreCliL )->nValImp != 0

               do case
                  case aTotIvm[ 1, 2 ] == nil .or. aTotIvm[ 1, 2 ] == ( cPreCliL )->nValImp
                     aTotIvm[ 1, 1 ]      += nTotNPreCli( cPreCliL ) * if( ( cPreCliL )->lVolImp, NotCero( ( cPreCliL )->nVolumen ), 1 )
                     aTotIvm[ 1, 2 ]      := ( cPreCliL )->nValImp
                     aTotIvm[ 1, 3 ]      := aTotIvm[ 1, 1 ] * aTotIvm[ 1, 2 ]

                  case aTotIvm[ 2, 2 ] == nil .or. aTotIvm[ 2, 2 ] == ( cPreCliL )->nValImp
                     aTotIvm[ 2, 1 ]      += nTotNPreCli( cPreCliL ) * if( ( cPreCliL )->lVolImp, NotCero( ( cPreCliL )->nVolumen ), 1 )
                     aTotIvm[ 2, 2 ]      := ( cPreCliL )->nValImp
                     aTotIvm[ 2, 3 ]      := aTotIvm[ 2, 1 ] * aTotIvm[ 2, 2 ]

                  case aTotIvm[ 3, 2 ] == nil .or. aTotIvm[ 3, 2 ] == ( cPreCliL )->nValImp
                     aTotIvm[ 3, 1 ]      += nTotNPreCli( cPreCliL ) * if( ( cPreCliL )->lVolImp, NotCero( ( cPreCliL )->nVolumen ), 1 )
                     aTotIvm[ 3, 2 ]      := ( cPreCliL )->nValImp
                     aTotIvm[ 3, 3 ]      := aTotIvm[ 3, 1 ] * aTotIvm[ 3, 2 ]

               end case

            end if

         end if

      end if

      ( cPreCliL )->( dbSkip() )

   end while

   ( cPreCliL )->( dbGoto( nRecno ) )

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

         if uFieldEmpresa( "lIvaImpEsp" )
            _NBASIVA1   -= _NIVMIVA1
            _NBASIVA2   -= _NIVMIVA2
            _NBASIVA3   -= _NIVMIVA3
         end if

      end if

   else

      if  !uFieldEmpresa( "lIvaImpEsp" )
         _NBASIVA1      -= _NIVMIVA1
         _NBASIVA2      -= _NIVMIVA2
         _NBASIVA3      -= _NIVMIVA3   
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

         _NBASIVA1         -= _NIMPIVA1
         _NBASIVA2         -= _NIMPIVA2
         _NBASIVA3         -= _NIMPIVA3

         _NBASIVA1         -= _NIMPREQ1
         _NBASIVA2         -= _NIMPREQ2
         _NBASIVA3         -= _NIMPREQ3

      end if

      if uFieldEmpresa( "lIvaImpEsp")
         _NBASIVA1         -= _NIVMIVA1
         _NBASIVA2         -= _NIVMIVA2
         _NBASIVA3         -= _NIVMIVA3
      end if

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
   Redondeo del neto de la presupuesto
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

   nTotPre           := nTotNet + nTotImp

   /*
   Total de descuentos del precupuesto-----------------------------------------
   */

   nTotalDto         := nDescuentosLineas + nTotDto + nTotDpp + nTotUno + nTotDos + nTotAtp

   ( cPreCliL )->( dbGoTo( nRecno) )

   /*
   Solicitan una divisa distinta a la q se hizo originalmente la factura
   */

   if cDivRet != nil .and. cDivRet != cCodDiv
      nTotNet     := nCnv2Div( nTotNet, cCodDiv, cDivRet )
      nTotIvm     := nCnv2Div( nTotIvm, cCodDiv, cDivRet )
      nTotIva     := nCnv2Div( nTotIva, cCodDiv, cDivRet )
      nTotReq     := nCnv2Div( nTotReq, cCodDiv, cDivRet )
      nTotPre     := nCnv2Div( nTotPre, cCodDiv, cDivRet )
      nTotPnt     := nCnv2Div( nTotPnt, cCodDiv, cDivRet )
      nTotTrn     := nCnv2Div( nTotTrn, cCodDiv, cDivRet )
      cPorDiv     := cPorDiv( cDivRet, cDiv )
   end if

RETURN ( if( lPic, Trans( nTotPre, cPorDiv ), nTotPre ) )

//--------------------------------------------------------------------------//

FUNCTION aTotPreCli( cPre, dbfMaster, dbfLine, dbfIva, dbfDiv, dbfFPago, cDivRet )

   nTotPreCli( cPre, dbfMaster, dbfLine, dbfIva, dbfDiv, dbfFPago, nil, cDivRet )

RETURN ( { nTotNet, nTotIva, nTotReq, nTotPre, nTotPnt, nTotTrn, nTotAge, nTotCos } )

//--------------------------------------------------------------------------//

FUNCTION BrwPreCli( oGet, cPreCliT, dbfPreCliL, dbfIva, dbfDiv, dbfFPago, oIva )

   local oDlg
   local oBrw
   local oGet1
   local cGet1
   local nOrd     := GetBrwOpt( "BrwPreCli" )
   local lIva     := oIva:VarGet()
   local oCbxOrd
   local aCbxOrd  := { "Número", "Fecha", "Cliente", "Nombre" }
   local cCbxOrd
   local nOrdAnt
   local nRecAnt

   nOrd           := Min( Max( nOrd, 1 ), len( aCbxOrd ) )
   cCbxOrd        := aCbxOrd[ nOrd ]
   nOrdAnt        := ( cPreCliT )->( OrdSetFocus( nOrd ) )
   nRecAnt        := ( cPreCliT )->( Recno() )

   ( cPreCliT )->( dbSetFilter( {|| !Field->lEstado .and. Field->lIvaInc == lIva }, "!lEstado .and. lIvaInc == lIva" ) )
   ( cPreCliT )->( dbGoTop() )

   DEFINE DIALOG oDlg RESOURCE "HELPENTRY" TITLE if( lIva, "Presupuestos de clientes con " + cImp() + " incluido", "Presupuestos de clientes con " + cImp() + " desglosado" )

      REDEFINE GET oGet1 VAR cGet1;
         ID       104 ;
         ON CHANGE( AutoSeek( nKey, nFlags, Self, oBrw, cPreCliT, .t., nil, .f. ) );
         VALID    ( OrdClearScope( oBrw, cPreCliT ) );
         BITMAP   "FIND" ;
         OF       oDlg

      REDEFINE COMBOBOX oCbxOrd ;
         VAR      cCbxOrd ;
         ID       102 ;
         ITEMS    aCbxOrd ;
         ON CHANGE( ( cPreCliT )->( ordSetFocus( oCbxOrd:nAt ) ), oBrw:Refresh(), oGet1:SetFocus() ) ;
         OF       oDlg

      oBrw                 := IXBrowse():New( oDlg )

      oBrw:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrw:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrw:cAlias          := cPreCliT
      oBrw:nMarqueeStyle   := 5
      oBrw:cName           := "Presupuesto a cliente.Browse"

      oBrw:bLDblClick      := {|| oDlg:end( IDOK ) }

      oBrw:CreateFromResource( 105 )

      with object ( oBrw:AddCol() )
         :cHeader          := "Tipo"
         :bEditValue       := {|| aTipPre[ if( ( cPreCliT )->lAlquiler, 2, 1  ) ] }
         :nWidth           := 50
         :lHide            := .t.
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Número"
         :cSortOrder       := "nNumPre"
         :bEditValue       := {|| ( cPreCliT )->cSerPre + "/" + AllTrim( Str( ( cPreCliT )->nNumPre ) ) + "/" + ( cPreCliT )->cSufPre }
         :nWidth           := 60
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Fecha"
         :cSortOrder       := "dFecPre"
         :bEditValue       := {|| dtoc( ( cPreCliT )->dFecPre ) }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Cliente"
         :cSortOrder       := "cCodCli"
         :bEditValue       := {|| AllTrim( ( cPreCliT )->cCodCli ) }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Nombre"
         :cSortOrder       := "cNomCli"
         :bEditValue       := {|| AllTrim( ( cPreCliT )->cNomCli ) }
         :nWidth           := 300
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Importe"
         :bEditValue       := {|| ( cPreCliT )->nTotPre }
         :cEditPicture     := cPorDiv()
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

   DestroyFastFilter( cPreCliT )

   SetBrwOpt( "BrwPreCli", ( cPreCliT )->( OrdNumber() ) )

   if oDlg:nResult == IDOK
      oGet:cText( ( cPreCliT )->cSerPre + Str( ( cPreCliT )->nNumPre ) + ( cPreCliT )->cSufPre )
      oGet:lValid()
   end if

   ( cPreCliT )->( dbClearFilter() )
   ( cPreCliT )->( ordSetFocus( nOrdAnt ) )
   ( cPreCliT )->( dbGoTo( nRecAnt ) )

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

FUNCTION ChgPreCli( cPre, nMode, cPreCliT )

   local oBlock
   local oError
   local lExito := .T.
   local lClose := .F.

   IF nMode != APPD_MODE .OR. Empty( cPre )
      RETURN NIL
   END IF

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   IF cPreCliT == NIL

      USE ( cPatEmp() + "PRECLI.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PRECLI", @cPreCliT ) )
      SET ADSINDEX TO ( cPatEmp() + "PRECLI.CDX" ) ADDITIVE
      lClose := .T.

   END IF

   IF (cPreCliT)->( dbSeek( cPre ) )
      if dbDialogLock( cPreCliT )
         (cPreCliT)->lEstado   := .t.
         (cPreCliT)->( dbUnLock() )
      end if
   ELSE
      lExito := .F.
   END IF

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   IF lClose
      CLOSE (cPreCliT)
   END IF

RETURN lExito

//-------------------------------------------------------------------------//

FUNCTION nTotUPreCli( uTmpLin, nDec, nVdv )

   local nCalculo       := 0

   DEFAULT uTmpLin      := D():PresupuestosClientesLineas( nView )
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

FUNCTION nImpUPreCli( uTmpLin, nDec, nVdv, cPorDiv )

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

FUNCTION nBrtLPreCli( uTmpLin, nDec, nRec, nVdv, cPorDiv )

   local nCalculo    := 0

   DEFAULT nDec      := 2
   DEFAULT nVdv      := 1

   nCalculo          := nImpUPreCli( uTmpLin, nDec, nVdv, cPorDiv )
   nCalculo          *= nTotNPreCli( uTmpLin )

   nCalculo          := Round( nCalculo / nVdv, nRec )

Return ( if( cPorDiv != nil, Trans( nCalculo, cPorDiv ), nCalculo ) )

//---------------------------------------------------------------------------//

FUNCTION nIvaUPreCli( dbfTmpLin, nDec, nVdv )

   local nCalculo

   DEFAULT nDec   := 0
   DEFAULT nVdv   := 1

   nCalculo       := nTotUPreCli( dbfTmpLin, nDec, nVdv )
   nCalculo       := nCalculo * ( dbfTmpLin )->nIva / 100

   if nVdv != 0
      nCalculo    := nCalculo / nVdv
   end if

RETURN ( Round( nCalculo, nDec ) )

//---------------------------------------------------------------------------//
/*
Devuelve el total de una linea con impuestos incluidos
*/

FUNCTION nTotFPreCli( dbfLin, nDec, nRou, nVdv, lDto, lPntVer, lImpTrn, cPorDiv )

   local nCalculo    := 0

   DEFAULT dbfLin    := D():PresupuestosClientesLineas( nView )
   DEFAULT nDec      := nDouDiv()
   DEFAULT nRou      := nRouDiv()
   DEFAULT nVdv      := 1
   DEFAULT lDto      := .t.
   DEFAULT lPntVer   := .t.
   DEFAULT lImpTrn   := .t.

   nCalculo          += nTotLPreCli( dbfLin, nDec, nRou, nVdv, lDto, lPntVer, lImpTrn )
   nCalculo          += nIvaLPreCli( dbfLin, nDec, nRou, nVdv, lDto, lPntVer, lImpTrn )
   

return ( if( cPorDiv != nil, Trans( nCalculo, cPorDiv ), nCalculo ) )

//---------------------------------------------------------------------------//

FUNCTION cDesPreCli( cPreCliL )

   DEFAULT cPreCliL  := D():PresupuestosClientesLineas( nView )

RETURN ( Descrip( cPreCliL ) )

//---------------------------------------------------------------------------//

FUNCTION cDesPreCliLeng( cPreCliL, cArtLeng )

   DEFAULT cPreCliL  := D():PresupuestosClientesLineas( nView )
   DEFAULT cArtLeng  := D():ArticuloLenguaje( nView )

RETURN ( DescripLeng( cPreCliL, , cArtLeng ) )

//---------------------------------------------------------------------------//

Function isLineaTotalPreCli( uPreCliL )

   if isArray( uPreCliL )
      Return ( uPreCliL[ _LTOTLIN ] )
   end if

Return ( ( uPreCliL )->lTotLin )

//---------------------------------------------------------------------------//

Function nDescuentoLinealPreCli( uPreCliL, nDec, nVdv )

   local nDescuentoLineal

   if isArray( uPreCliL )
      nDescuentoLineal  := uPreCliL[ _NDTODIV ]
   else 
      nDescuentoLineal  := ( uPreCliL )->nDtoDiv
   end if

Return ( Round( nDescuentoLineal / nVdv, nDec ) )

//---------------------------------------------------------------------------//

Function nDescuentoPorcentualPreCli( uPreCliL )

   local nDescuentoPorcentual

   if isArray( uPreCliL )
      nDescuentoPorcentual  := uPreCliL[ _NDTO ]
   else 
      nDescuentoPorcentual  := ( uPreCliL )->nDto
   end if

Return ( nDescuentoPorcentual )

//---------------------------------------------------------------------------//

Function nDescuentoPromocionPreCli( uPreCliL )

   local nDescuentoPromocion

   if isArray( uPreCliL )
      nDescuentoPromocion  := uPreCliL[ _NDTOPRM ]
   else 
      nDescuentoPromocion  := ( uPreCliL )->nDtoPrm
   end if

Return ( nDescuentoPromocion )

//---------------------------------------------------------------------------//

Function nPuntoVerdePreCli( uPreCliL )

   local nPuntoVerde

   if isArray( uPreCliL )
      nPuntoVerde  := uPreCliL[ _NPNTVER ]
   else 
      nPuntoVerde  := ( uPreCliL )->nPntVer
   end if

Return ( nPuntoVerde )

//---------------------------------------------------------------------------//

Function nTransportePreCli( uPreCliL )

   local nTransporte

   if isArray( uPreCliL )
      nTransporte  := uPreCliL[ _NIMPTRN ]
   else 
      nTransporte  := ( uPreCliL )->nImpTrn
   end if

Return ( nTransporte )

//---------------------------------------------------------------------------//

FUNCTION nTotLPreCli( uPreCliL, nDec, nRou, nVdv, lDto, lPntVer, lImpTrn, cPouDiv )

   local nCalculo
   local nUnidades

   if empty( uPreCliL ) .and. !empty( nView )
      uPreCliL       := D():PresupuestosClientesLineas( nView )
   end if

   DEFAULT nDec      := nDouDiv()
   DEFAULT nRou      := nRouDiv()
   DEFAULT nVdv      := 1
   DEFAULT lDto      := .t.
   DEFAULT lPntVer   := .t.
   DEFAULT lImpTrn   := .t.

   if isLineaTotalPreCli( uPreCliL )

      nCalculo       := nTotUPreCli( uPreCliL, nDec, nVdv )
      
   else

      nUnidades      := nTotNPreCli( uPreCliL )
      nCalculo       := nTotUPreCli( uPreCliL, nDec, nVdv ) * nUnidades

      /*
      Descuentos lineales------------------------------------------------------
      */

      nCalculo       -= nDescuentoLinealPreCli( uPreCliL, nDec, nVdv ) * nUnidades

      if lDto .and. nDescuentoPorcentualPreCli( uPreCliL ) != 0 
         nCalculo    -= nCalculo * nDescuentoPorcentualPreCli( uPreCliL ) / 100
      end if

      if lDto .and. nDescuentoPromocionPreCli( uPreCliL ) != 0 
         nCalculo    -= nCalculo * nDescuentoPromocionPreCli( uPreCliL ) / 100
      end if

      /*
      Punto Verde--------------------------------------------------------------
      */

      if lPntVer .and. nPuntoVerdePreCli( uPreCliL ) != 0
         nCalculo    += nPuntoVerdePreCli( uPreCliL ) * nUnidades
      end if

      /*
      Transporte---------------------------------------------------------------
      */

      if lImpTrn .and. nTransportePreCli( uPreCliL ) != 0
         nCalculo    += nTransportePreCli( uPreCliL ) * nUnidades
      end if

   end if

   if nVdv != 0
      nCalculo       := nCalculo / nVdv
   end if

   if nRou != nil
      nCalculo       := Round( Div( nCalculo, nVdv ), nRou )
   end if

RETURN ( if( cPouDiv != nil, Trans( nCalculo, cPouDiv ), nCalculo ) )

//---------------------------------------------------------------------------//
/*
Devuelve el importe de descuento porcentual por cada linea---------------------
*/

FUNCTION nDtoLPreCli( cPreCliL, nDec, nRou, nVdv )

   local nCalculo       := 0

   DEFAULT cPreCliL     := D():PresupuestosClientesLineas( nView )
   DEFAULT nDec         := nDouDiv()
   DEFAULT nRou         := nRouDiv()
   DEFAULT nVdv         := 1

   if ( cPreCliL )->nDto != 0 .and. !( cPreCliL )->lTotLin

      nCalculo          := nTotUPreCli( cPreCliL, nDec ) * nTotNPreCli( cPreCliL )

      /*
      Descuentos---------------------------------------------------------------
      */

      nCalculo          -= Round( ( cPreCliL )->nDtoDiv / nVdv , nDec )

      nCalculo          := nCalculo * ( cPreCliL )->nDto / 100


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

FUNCTION nPrmLPreCli( cPreCliL, nDec, nRou, nVdv )

   local nCalculo       := 0

   DEFAULT cPreCliL     := D():PresupuestosClientesLineas( nView )
   DEFAULT nDec         := nDouDiv()
   DEFAULT nRou         := nRouDiv()
   DEFAULT nVdv         := 1

   if ( cPreCliL )->nDtoPrm != 0 .and. !( cPreCliL )->lTotLin

      nCalculo          := nTotUPreCli( cPreCliL, nDec ) * nTotNPreCli( cPreCliL )

      /*
      Descuentos---------------------------------------------------------------
      */

      nCalculo          -= Round( ( cPreCliL )->nDtoDiv / nVdv , nDec )

      if ( cPreCliL )->nDto != 0 
         nCalculo       -= nCalculo * ( cPreCliL )->nDto / 100
      end if

      nCalculo          := nCalculo * ( cPreCliL )->nDtoPrm / 100

      if nVdv != 0
         nCalculo       := nCalculo / nVdv
      end if

      if nRou != nil
         nCalculo       := Round( nCalculo, nRou )
      end if

   end if

RETURN ( nCalculo ) 

//---------------------------------------------------------------------------//

FUNCTION nTotCPreCli( dbfLine, nDec, nRec, nVdv, cPouDiv )

   local nCalculo       := 0

   DEFAULT nDec         := 0
   DEFAULT nRec         := 0
   DEFAULT nVdv         := 1

   if !( dbfLine )->lKitChl
      nCalculo          := nTotNPreCli( dbfLine )
      nCalculo          *= ( dbfLine )->nCosDiv
   end if

   if nVdv != 0
      nCalculo          := nCalculo / nVdv
   end if

   nCalculo             := Round( nCalculo, nRec )

RETURN ( if( cPouDiv != nil, Trans( nCalculo, cPouDiv ), nCalculo ) )

//---------------------------------------------------------------------------//

FUNCTION nPesLPreCli( cPreCliL )

   local nCalculo    := 0

   DEFAULT cPreCliL  := D():PresupuestosClientesLineas( nView )

   if !( cPreCliL )->lTotLin .and. !( cPreCliL )->lControl
      nCalculo       := Abs( nTotNPreCli( cPreCliL ) ) * ( cPreCliL )->nPesoKg
   end if

RETURN ( nCalculo )

//---------------------------------------------------------------------------//

FUNCTION nVolLPreCli( dbfLine )

   local nCalculo    := 0

   if !( dbfLine )->lTotLin .and. !( dbfLine )->lControl
      nCalculo       := nTotNPreCli( dbfLine ) * ( dbfLine )->nVolumen
   end if

RETURN ( nCalculo )

//---------------------------------------------------------------------------//

FUNCTION nIvaLPreCli( dbfLin, nDec, nRouDec, nVdv, lDto, lPntVer, lImpTrn, cPouDiv )

   local nCalculo    := 0

   if ( dbfLin )->nRegIva <= 1

      nCalculo          := nTotLPreCli( dbfLin, nDec, nRouDec, nVdv, lDto, lPntVer, lImpTrn, cPouDiv )

      if !( dbfLin )->lIvaLin
         nCalculo       := nCalculo * ( dbfLin )->nIva / 100
      else
         nCalculo       -= nCalculo / ( 1 + ( dbfLin )->nIva / 100 )
      end if

   end if

RETURN ( if( cPouDiv != nil, Trans( nCalculo, cPouDiv ), nCalculo ) )

//---------------------------------------------------------------------------//

Function nPntUPreCli( dbfTmpLin, nDec, nVdv )

   local nCalculo

   DEFAULT nDec   := 0
   DEFAULT nVdv   := 1

   nCalculo       := ( dbfTmpLin )->nPntVer

   IF nVdv != 0
      nCalculo    := ( dbfTmpLin )->nPntVer / nVdv
   END IF

RETURN ( round( nCalculo, nDec ) )

//---------------------------------------------------------------------------//

FUNCTION nPntLPreCli( dbfLin, nDec, nVdv )

   local nPntVer

   DEFAULT dbfLin    := D():PresupuestosClientesLineas( nView )
   DEFAULT nDec      := 2
   DEFAULT nVdv      := 1

   /*
   Punto Verde
   */

   nPntVer           := nPntUPreCli( dbfLin, nDec, nVdv )
   nPntVer           *= nTotNPreCli( dbfLin )

RETURN ( Round( nPntVer, nDec ) )

//---------------------------------------------------------------------------//

FUNCTION nTrnUPreCli( dbfTmpLin, nDec, nVdv )

   local nCalculo

   DEFAULT nDec   := 0
   DEFAULT nVdv   := 1

   nCalculo       := ( dbfTmpLin )->nImpTrn

   IF nVdv != 0
      nCalculo    := nCalculo / nVdv
   END IF

RETURN ( Round( nCalculo, nDec ) )

//---------------------------------------------------------------------------//

FUNCTION nTrnLPreCli( dbfLin, nDec, nRou, nVdv )

   local nImpTrn

   DEFAULT dbfLin    := D():PresupuestosClientesLineas( nView )
   DEFAULT nDec      := 2
   DEFAULT nRou      := 2
   DEFAULT nVdv      := 1

   /*
   Punto Verde
   */

   nImpTrn           := nTrnUPreCli( dbfLin, nDec ) * nTotNPreCli( dbfLin )

   IF nVdv != 0
      nImpTrn        := nImpTrn / nVdv
   END IF

RETURN ( Round( nImpTrn, nRou ) )

//---------------------------------------------------------------------------//

FUNCTION nDtoUPreCli( dbfTmpLin, nDec, nVdv )

   local nCalculo := ( dbfTmpLin )->nDtoDiv

   DEFAULT nDec   := 0
   DEFAULT nVdv   := 1

   if nVdv != 0
      nCalculo    /= nVdv
   end if

RETURN ( round( nCalculo, nDec ) )

//---------------------------------------------------------------------------//

FUNCTION mkPreCli( cPath, lAppend, cPathOld, oMeter, bFor )

   local dbfPreCliT
   local dbfPreCliL
   local dbfPreCliI
   local dbfPreCliD
   local oldPreCliT
   local oldPreCliL
   local oldPreCliI
   local oldPreCliD

   if oMeter != NIL
      oMeter:cText   := "Generando Bases"
      sysrefresh()
   end if

   DEFAULT lAppend   := .f. 
   DEFAULT bFor      := {|| .t. }

   createFiles( cPath )
   
   rxPreCli( cPath, cLocalDriver() )

   If lAppend .and. lIsDir( cPathOld )

      dbUseArea( .t., cDriver(), cPath + "PRECLIT.DBF", cCheckArea( "PRECLIT", @dbfPreCliT ), .f. )
      if !( dbfPreCliT )->( neterr() )
         ( dbfPreCliT )->( ordListAdd( cPath + "PreCliT.Cdx" ) )
      end if

      dbUseArea( .t., cDriver(), cPath + "PreCliL.DBF", cCheckArea( "PreCliL", @dbfPreCliL ), .f. )
      if !( dbfPreCliL )->( neterr() )
         ( dbfPreCliL )->( ordListAdd( cPath + "PreCliL.CDX" ) )
      end if

      dbUseArea( .t., cDriver(), cPath + "PreCliI.Dbf", cCheckArea( "PreCliI", @dbfPreCliI ), .f. )
      if !( dbfPreCliI )->( neterr() )
         ( dbfPreCliI )->( ordListAdd( cPath + "PreCliI.Cdx" ) )
      end if

      dbUseArea( .t., cDriver(), cPath + "PreCliD.Dbf", cCheckArea( "PreCliD", @dbfPreCliD ), .f. )
      if !( dbfPreCliD )->( neterr() )
         ( dbfPreCliD )->( ordListAdd( cPath + "PreCliD.Cdx" ) )
      end if

      /*
      Bases de datos de la empresa a importar----------------------------------
      */

      dbUseArea( .t., cDriver(), cPathOld + "PreCliT.DBF", cCheckArea( "PreCliT", @oldPreCliT ), .f. )
      if !( dbfPreCliT )->( neterr() )
         ( oldPreCliT )->( ordListAdd( cPathOld + "PreCliT.Cdx" ) )
      end if

      dbUseArea( .t., cDriver(), cPathOld + "PreCliL.DBF", cCheckArea( "PreCliL", @oldPreCliL ), .f. )
      if !( oldPreCliL )->( neterr() )
         ( oldPreCliL )->( ordListAdd( cPathOld + "PreCliL.CDX" ) )
      end if

      dbUseArea( .t., cDriver(), cPathOld + "PreCliI.DBF", cCheckArea( "PreCliI", @oldPreCliI ), .f. )
      if !( oldPreCliI )->( neterr() )
         ( oldPreCliI )->( ordListAdd( cPathOld + "PreCliI.CDX"  ) )
      end if

      dbUseArea( .t., cDriver(), cPathOld + "PreCliD.DBF", cCheckArea( "PreCliD", @oldPreCliD ), .f. )
      if !( oldPreCliD )->( neterr() )
         ( oldPreCliD )->( ordListAdd( cPathOld + "PreCliD.Cdx"  ) )
      end if

      /*
      Proceso de importacion --------------------------------------------------
      */

      while !( oldPreCliT )->( eof() )

         if eval( bFor, oldPreCliT )

            dbCopy( oldPreCliT, dbfPreCliT, .t. )

            if ( oldPreCliL )->( dbSeek( ( oldPreCliT )->cSerPre + Str( ( oldPreCliT )->nNumPre ) + ( oldPreCliT )->cSufPre ) )
               while ( oldPreCliL )->cSerPre + Str( ( oldPreCliL )->nNumPre ) + ( oldPreCliL )->cSufPre == ( oldPreCliT )->cSerPre + Str( ( oldPreCliT )->nNumPre ) + ( oldPreCliT )->cSufPre .and. !( oldPreCliL )->( eof() )
                  dbCopy( oldPreCliL, dbfPreCliL, .t. )
                  ( oldPreCliL )->( dbSkip() )
               end while
            end if

            if ( oldPreCliI )->( dbSeek( ( oldPreCliT )->cSerPre + Str( ( oldPreCliT )->nNumPre ) + ( oldPreCliT )->cSufPre ) )
               while ( oldPreCliI )->cSerPre + Str( ( oldPreCliI )->nNumPre ) + ( oldPreCliI )->cSufPre == ( oldPreCliT )->cSerPre + Str( ( oldPreCliT )->nNumPre ) + ( oldPreCliT )->cSufPre .and. !( oldPreCliI )->( eof() )
                  dbCopy( oldPreCliI, dbfPreCliI, .t. )
                  ( oldPreCliI )->( dbSkip() )
               end while
            end if

            if ( oldPreCliD )->( dbSeek( ( oldPreCliT )->cSerPre + Str( ( oldPreCliT )->nNumPre ) + ( oldPreCliT )->cSufPre ) )
               while ( oldPreCliD )->cSerPre + Str( ( oldPreCliD )->nNumPre ) + ( oldPreCliD )->cSufPre == ( oldPreCliT )->cSerPre + Str( ( oldPreCliT )->nNumPre ) + ( oldPreCliT )->cSufPre .and. !( oldPreCliI )->( eof() )
                  dbCopy( oldPreCliD, dbfPreCliD, .t. )
                  ( oldPreCliD )->( dbSkip() )
               end while
            end if

         end if

         ( oldPreCliT )->( dbSkip() )

      end while

      ( dbfPreCliT )->( dbCloseArea() )
      ( dbfPreCliL )->( dbCloseArea() )
      ( dbfPreCliI )->( dbCloseArea() )
      ( dbfPreCliD )->( dbCloseArea() )

      ( oldPreCliT )->( dbCloseArea() )
      ( oldPreCliL )->( dbCloseArea() )
      ( oldPreCliI )->( dbCloseArea() )
      ( oldPreCliD )->( dbCloseArea() )

   End If

Return Nil

//---------------------------------------------------------------------------//

FUNCTION rxPreCli( cPath, cDriver )

   local dbfPreCliT

   DEFAULT cPath     := cPatEmp()
   DEFAULT cDriver   := cDriver()

   if !lExistTable( cPath + "PRECLIT.DBF", cDriver ) .OR. ;
      !lExistTable( cPath + "PRECLIL.DBF", cDriver ) .OR. ;
      !lExistTable( cPath + "PRECLII.DBF", cDriver ) .OR. ;
      !lExistTable( cPath + "PRECLID.DBF", cDriver ) .OR. ;
      !lExistTable( cPath + "PRECLIE.DBF", cDriver )

      CreateFiles( cPath )

   end if

   fEraseIndex( cPath + "PreCliT.Cdx", cDriver )
   fEraseIndex( cPath + "PRECLIL.CDX", cDriver )
   fEraseIndex( cPath + "PRECLII.CDX", cDriver )
   fEraseIndex( cPath + "PreCliD.Cdx", cDriver )
   fEraseIndex( cPath + "PRECLIE.CDX", cDriver )

   dbUseArea( .t., cDriver, cPath + "PRECLIT.DBF", cCheckArea( "PRECLIT", @dbfPreCliT ), .f. )
   if !( dbfPreCliT )->( neterr() )
      ( dbfPreCliT )->( __dbPack() )

      ( dbfPreCliT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfPreCliT )->( ordCreate( cPath + "PreCliT.Cdx", "NNUMPRE", "CSERPRE + STR( NNUMPRE ) + CSUFPRE", {|| Field->CSERPRE + STR(Field->NNUMPRE) + Field->CSUFPRE } ) )

      ( dbfPreCliT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfPreCliT )->( ordCreate( cPath + "PreCliT.Cdx", "DFECPRE", "DFECPRE", {|| Field->DFECPRE } ) )

      ( dbfPreCliT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfPreCliT )->( ordCreate( cPath + "PreCliT.Cdx", "CCODCLI", "CCODCLI + Dtos( dFecPre )", {|| Field->CCODCLI + Dtos( Field->dFecPre ) } ) )

      ( dbfPreCliT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfPreCliT )->( ordCreate( cPath + "PreCliT.Cdx", "CNOMCLI", "cNomCli + Dtos( dFecPre )", {|| Field->cNomCli + Dtos( Field->dFecPre ) } ) )

      ( dbfPreCliT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfPreCliT )->( ordCreate( cPath + "PreCliT.Cdx", "cCodObr", "cCodObr", {|| Field->cCodObr } ) )

      ( dbfPreCliT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfPreCliT )->( ordCreate( cPath + "PreCliT.Cdx", "cCodAge", "cCodAge", {|| Field->cCodAge } ) )

      ( dbfPreCliT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfPreCliT )->( ordCreate( cPath + "PreCliT.Cdx", "CTURPRE", "CTURPRE + CSUFPRE + cCodCaj", {|| Field->CTURPRE + Field->CSUFPRE + Field->cCodCaj } ) )

      ( dbfPreCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( dbfPreCliT )->( ordCreate( cPath + "PreCliT.Cdx", "lSndDoc", "lSndDoc", {|| Field->lSndDoc } ) )

      ( dbfPreCliT )->( ordCondSet( "!Deleted()", {||!Deleted()}  ) )
      ( dbfPreCliT )->( ordCreate( cPath + "PreCliT.Cdx", "cCodUsr", "cCodUsr + Dtos( dFecCre ) + cTimCre", {|| Field->cCodUsr + Dtos( Field->dFecCre ) + Field->cTimCre } ) )

      ( dbfPreCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( dbfPreCliT )->( ordCreate( cPath + "PreCliT.Cdx", "iNumPre", "'08' + cSerPre + Str( nNumPre ) + Space( 1 ) + cSufPre", {|| '08' + Field->cSerPre + Str( Field->nNumPre ) + Space( 1 ) + Field->cSufPre } ) )

      ( dbfPreCliT )->( ordCondSet( "!Deleted()", {||!Deleted()}  ) )
      ( dbfPreCliT )->( ordCreate( cPath + "PreCliT.Cdx", "cCodWeb", "Str( Field->cCodWeb )", {|| Str( Field->cCodWeb ) } ) )

      ( dbfPreCliT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfPreCliT )->( ordCreate( cPath + "PreCliT.Cdx", "Poblacion", "UPPER( Field->cPobCli )", {|| UPPER( Field->cPobCli ) } ) )

      ( dbfPreCliT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfPreCliT )->( ordCreate( cPath + "PreCliT.Cdx", "Provincia", "UPPER( Field->cPrvCli )", {|| UPPER( Field->cPrvCli ) } ) )

      ( dbfPreCliT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfPreCliT )->( ordCreate( cPath + "PreCliT.Cdx", "CodPostal", "Field->cPosCli", {|| Field->cPosCli } ) )

      ( dbfPreCliT )->( ordCondSet("!Deleted()", {||!Deleted()}, , , , , , , , , .t. ) )
      ( dbfPreCliT )->( ordCreate( cPath + "PreCliT.Cdx", "dDesFec", "dFecPre", {|| Field->dFecPre } ) )

      ( dbfPreCliT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfPreCliT )->( ordCreate( cPath + "PreCliT.Cdx", "cSuPre", "Field->cSuPre", {|| Field->cSuPre } ) )

      ( dbfPreCliT )->( dbCloseArea() )

   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de presupuestos de clientes" )
   end if

   dbUseArea( .t., cDriver, cPath + "PRECLIL.DBF", cCheckArea( "PRECLIL", @dbfPreCliT ), .f. )
   if !( dbfPreCliT )->( neterr() )
      ( dbfPreCliT )->( __dbPack() )

      ( dbfPreCliT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfPreCliT )->( ordCreate( cPath + "PreCliL.Cdx", "NNUMPRE", "CSERPRE + STR( NNUMPRE ) + CSUFPRE", {|| Field->CSERPRE + STR( Field->NNUMPRE ) + Field->CSUFPRE } ) )

      ( dbfPreCliT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfPreCliT )->( ordCreate( cPath + "PreCliL.Cdx", "CREF", "CREF", {|| Field->CREF }, ) )

      ( dbfPreCliT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfPreCliT )->( ordCreate( cPath + "PreCliL.Cdx", "Lote", "cLote", {|| Field->cLote }, ) )

      ( dbfPreCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( dbfPreCliT )->( ordCreate( cPath + "PreCliL.Cdx", "iNumPre", "'08' + cSerPre + Str( nNumPre ) + Space( 1 ) + cSufPre + Str( nNumLin )", {|| '08' + Field->cSerPre + Str( Field->nNumPre ) + Space( 1 ) + Field->cSufPre + Str( Field->nNumLin ) } ) )

      ( dbfPreCliT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfPreCliT )->( ordCreate( cPath + "PreCliL.Cdx", "nNumLin", "Str( NNUMPRE ) + Str( nNumLin )", {|| Str( Field->nNumPre ) + Str( Field->nNumLin ) }, ) )

      ( dbfPreCliT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfPreCliT )->( ordCreate( cPath + "PreCliL.Cdx", "cCodFam", "CSERPRE + STR( NNUMPRE ) + CSUFPRE + ccodFam", {|| Field->CSERPRE + STR( Field->NNUMPRE ) + Field->CSUFPRE + Field->cCodFam }, ) )

      ( dbfPreCliT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfPreCliT )->( ordCreate( cPath + "PreCliL.Cdx", "nPosPrint", "cSerPre + Str( nNumPre ) + cSufPre + Str( nPosPrint )", {|| Field->cSerPre + Str( Field->nNumPre ) + Field->cSufPre + Str( Field->nPosPrint )}, ) )

      ( dbfPreCliT )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de presupuestos de clientes" )
   end if

   dbUseArea( .t., cDriver, cPath + "PRECLII.DBF", cCheckArea( "PRECLII", @dbfPreCliT ), .f. )
   if !( dbfPreCliT )->( neterr() )
      ( dbfPreCliT )->( __dbPack() )

      ( dbfPreCliT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfPreCliT )->( ordCreate( cPath + "PreCliI.Cdx", "NNUMPRE", "CSERPRE + STR( NNUMPRE ) + CSUFPRE", {|| Field->CSERPRE + STR(Field->NNUMPRE) + Field->CSUFPRE } ) )

      ( dbfPreCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( dbfPreCliT )->( ordCreate( cPath + "PreCliI.Cdx", "iNumPre", "'08' + cSerPre + Str( nNumPre ) + Space( 1 ) + cSufPre", {|| '08' + Field->cSerPre + Str( Field->nNumPre ) + Space( 1 ) + Field->cSufPre } ) )

      ( dbfPreCliT )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de presupuestos de clientes" )
   end if

   dbUseArea( .t., cDriver, cPath + "PRECLID.DBF", cCheckArea( "PRECLID", @dbfPreCliT ), .f. )
   if !( dbfPreCliT )->( neterr() )
      ( dbfPreCliT )->( __dbPack() )

      ( dbfPreCliT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfPreCliT )->( ordCreate( cPath + "PreCliD.Cdx", "NNUMPRE", "CSERPRE + STR( NNUMPRE ) + CSUFPRE", {|| Field->CSERPRE + STR(Field->NNUMPRE) + Field->CSUFPRE } ) )

      ( dbfPreCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( dbfPreCliT )->( ordCreate( cPath + "PreCliD.Cdx", "iNumPre", "'08' + cSerPre + Str( nNumPre ) + Space( 1 ) + cSufPre", {|| '08' + Field->cSerPre + Str( Field->nNumPre ) + Space( 1 ) + Field->cSufPre } ) )

      ( dbfPreCliT )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de presupuestos de clientes" )
   end if

   dbUseArea( .t., cDriver, cPath + "PreCliE.DBF", cCheckArea( "PreCliE", @dbfPreCliT ), .f. )

   if !( dbfPreCliT )->( neterr() )

      ( dbfPreCliT )->( __dbPack() )

      ( dbfPreCliT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfPreCliT )->( ordCreate( cPath + "PreCliE.CDX", "NNUMPRE", "CSERPRE + STR( NNUMPRE ) + CSUFPRE", {|| Field->CSERPRE + STR( Field->NNUMPRE ) + Field->CSUFPRE } ) )

      ( dbfPreCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( dbfPreCliT )->( ordCreate( cPath + "PreCliE.Cdx", "cSitua", "cSitua", {|| Field->cSitua } ) )

      ( dbfPreCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( dbfPreCliT )->( ordCreate( cPath + "PreCliE.Cdx", "idPs", "str( idPs )", {|| str( Field->idPs ) } ) )

      ( dbfPreCliT )->( dbCloseArea() )

   else

      msgStop( "Imposible abrir en modo exclusivo la tabla de presupuestos de clientes" )

   end if

RETURN NIL

//--------------------------------------------------------------------------//

FUNCTION nTotNPreCli( uDbf )

   local nTotUnd

   DEFAULT uDbf   := D():PresupuestosClientesLineas( nView )

   do case
   case ValType( uDbf ) == "A"

      if uDbf[ __LALQUILER ]

         nTotUnd  := NotCaja( uDbf[ _NCANPRE ] )
         nTotUnd  *= uDbf[ _NUNICAJA ]
         nTotUnd  *= NotCero( uDbf[ _NUNDKIT ] )
         nTotUnd  *= NotCero( uDbf[ __DFECENT ] - uDbf[ __DFECSAL ] )
         nTotUnd  *= NotCero( uDbf[ _NMEDUNO ] )
         nTotUnd  *= NotCero( uDbf[ _NMEDDOS ] )
         nTotUnd  *= NotCero( uDbf[ _NMEDTRE ] )

      else

         nTotUnd  := NotCaja( uDbf[ _NCANPRE ] )
         nTotUnd  *= uDbf[ _NUNICAJA ]
         nTotUnd  *= NotCero( uDbf[ _NUNDKIT ] )
         nTotUnd  *= NotCero( uDbf[ _NMEDUNO ] )
         nTotUnd  *= NotCero( uDbf[ _NMEDDOS ] )
         nTotUnd  *= NotCero( uDbf[ _NMEDTRE ] )

      end if

   case ValType( uDbf ) == "O"

      if uDbf:lAlquiler

         nTotUnd  := NotCaja( uDbf:nCanPre )
         nTotUnd  *= uDbf:nUniCaja
         nTotUnd  *= NotCero( uDbf:nUndKit )
         nTotUnd  *= NotCero( uDbf:dFecEnt - uDbf:dFecSal )
         nTotUnd  *= NotCero( uDbf:nMedUno )
         nTotUnd  *= NotCero( uDbf:nMedDos )
         nTotUnd  *= NotCero( uDbf:nMedTre )

      else

         nTotUnd  := NotCaja( uDbf:nCanPre )
         nTotUnd  *= uDbf:nUniCaja
         nTotUnd  *= NotCero( uDbf:nUndKit )
         nTotUnd  *= NotCero( uDbf:nMedUno )
         nTotUnd  *= NotCero( uDbf:nMedDos )
         nTotUnd  *= NotCero( uDbf:nMedTre )

      end if

   otherwise

      if ( uDbf )->lAlquiler

         nTotUnd  := NotCaja( ( uDbf )->nCanPre )
         nTotUnd  *= ( uDbf )->nUniCaja
         nTotUnd  *= NotCero( ( uDbf )->nUndKit )
         nTotUnd  *= NotCero( ( uDbf )->dFecEnt - ( uDbf )->dFecSal )
         nTotUnd  *= NotCero( ( uDbf )->nMedUno )
         nTotUnd  *= NotCero( ( uDbf )->nMedDos )
         nTotUnd  *= NotCero( ( uDbf )->nMedTre )

      else

         nTotUnd  := NotCaja( ( uDbf )->nCanPre )
         nTotUnd  *= ( uDbf )->nUniCaja
         nTotUnd  *= NotCero( ( uDbf )->nUndKit )
         nTotUnd  *= NotCero( ( uDbf )->nMedUno )
         nTotUnd  *= NotCero( ( uDbf )->nMedDos )
         nTotUnd  *= NotCero( ( uDbf )->nMedTre )

      end if

   end case

RETURN ( nTotUnd )

//--------------------------------------------------------------------------//

FUNCTION nTotIPreCli( dbfLin, nDec, nRouDec, nVdv, cPorDiv )

   local nCalculo    := 0

   DEFAULT dbfLin    := D():PresupuestosClientesLineas( nView )
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

      nCalculo       *= nTotNPreCli( dbfLin )

         if ( dbfLin )->LVOLIMP
            nCalculo *= NotCero( ( dbfLin )->nVolumen )
         end if

      nCalculo       := Round( nCalculo / nVdv, nRouDec )

   END IF

RETURN ( if( cPorDiv != NIL, Trans( nCalculo, cPorDiv ), nCalculo ) )

//----------------------------------------------------------------------------//

FUNCTION nImpLPreCli( uPreCliT, uPreCliL, nDec, nRou, nVdv, lIva, lDto, lPntVer, lImpTrn, cPouDiv )

   local nCalculo
   local lIvaInc

   DEFAULT nDec      := 0
   DEFAULT nRou      := 0
   DEFAULT nVdv      := 1
   DEFAULT lIva      := .f.
   DEFAULT lDto      := .t.
   DEFAULT lPntVer   := .f.
   DEFAULT lImpTrn   := .f.

   nCalculo          := nTotLPreCli( uPreCliL, nDec, nRou, nVdv, .t., lPntVer, lImpTrn )

   if ValType( uPreCliT ) == "A"
      nCalculo       -= Round( nCalculo * uPreCliT[ _NDTOESP ]  / 100, nRou )
      nCalculo       -= Round( nCalculo * uPreCliT[ _NDPP    ]  / 100, nRou )
      nCalculo       -= Round( nCalculo * uPreCliT[ _NDTOUNO ]  / 100, nRou )
      nCalculo       -= Round( nCalculo * uPreCliT[ _NDTODOS ]  / 100, nRou )
      lIvaInc        := uPreCliT[ _LIVAINC ]
   else
      nCalculo       -= Round( nCalculo * ( uPreCliT )->nDtoEsp / 100, nRou )
      nCalculo       -= Round( nCalculo * ( uPreCliT )->nDpp    / 100, nRou )
      nCalculo       -= Round( nCalculo * ( uPreCliT )->nDtoUno / 100, nRou )
      nCalculo       -= Round( nCalculo * ( uPreCliT )->nDtoDos / 100, nRou )
      lIvaInc        := ( uPreCliT )->lIvaInc
   end if

   if ( uPreCliL )->nIva != 0
      if lIva  // lo quermos con impuestos
         if !lIvaInc
            nCalculo += Round( nCalculo * ( uPreCliL )->nIva / 100, nRou )
         end if
      else     // lo queremos sin impuestos
         if lIvaInc
            nCalculo -= Round( nCalculo / ( 100 / ( uPreCliL )->nIva  + 1 ), nRou )
         end if
      end if
   end if

RETURN ( if( cPouDiv != nil, Trans( nCalculo, cPouDiv ), nCalculo ) )

//----------------------------------------------------------------------------//

FUNCTION nDtoAtpPreCli( uPreCliT, uPreCliL, nDec, nRou, nVdv, lPntVer, lImpTrn )

   local nCalculo    := 0
   local nDtoAtp     := 0

   DEFAULT nDec      := 0
   DEFAULT nRou      := 0
   DEFAULT nVdv      := 1
   DEFAULT lPntVer   := .f.
   DEFAULT lImpTrn   := .f.

   nCalculo          := nTotLPreCli( uPreCliL, nDec, nRou, nVdv, .t., lPntVer, lImpTrn )

   if ( uPreCliT )->nSbrAtp <= 1 .and. ( uPreCliT )->nDtoAtp != 0
      nDtoAtp     += Round( nCalculo * ( uPreCliT )->nDtoAtp / 100, nRou )
   end if

   nCalculo       -= Round( nCalculo * ( uPreCliT )->nDtoEsp / 100, nRou )

   if ( uPreCliT )->nSbrAtp == 2 .and. ( uPreCliT )->nDtoAtp != 0
      nDtoAtp     += Round( nCalculo * ( uPreCliT )->nDtoAtp / 100, nRou )
   end if

   nCalculo       -= Round( nCalculo * ( uPreCliT )->nDpp    / 100, nRou )

   if ( uPreCliT )->nSbrAtp == 3 .and. ( uPreCliT )->nDtoAtp != 0
      nDtoAtp     += Round( nCalculo * ( uPreCliT )->nDtoAtp / 100, nRou )
   end if

   nCalculo       -= Round( nCalculo * ( uPreCliT )->nDtoUno / 100, nRou )

   if ( uPreCliT )->nSbrAtp == 4 .and. ( uPreCliT )->nDtoAtp != 0
      nDtoAtp     += Round( nCalculo * ( uPreCliT )->nDtoAtp / 100, nRou )
   end if

   nCalculo       -= Round( nCalculo * ( uPreCliT )->nDtoDos / 100, nRou )

   if ( uPreCliT )->nSbrAtp == 5 .and. ( uPreCliT )->nDtoAtp != 0
      nDtoAtp     += Round( nCalculo * ( uPreCliT )->nDtoAtp / 100, nRou )
   end if

RETURN ( nDtoAtp )

//----------------------------------------------------------------------------//

FUNCTION nComLPreCli( cPreCliT, uPreCliL, nDecOut, nDerOut )

   local nImp        := nImpLPreCli( cPreCliT, uPreCliL, nDecOut, nDerOut )

RETURN ( nImp * ( uPreCliL )->nComAge / 100 )

//--------------------------------------------------------------------------//

FUNCTION dFecPreCli( cPreCli, cPreCliT )

   local dFecPre  := CtoD("")

   IF ( cPreCliT )->( dbSeek( cPreCli ) )
      dFecPre  := ( cPreCliT )->dFecPre
   END IF

RETURN ( dFecPre )

//---------------------------------------------------------------------------//

FUNCTION lEstPreCli( cPreCli, cPreCliT )

   local lEstPre  := .f.

   IF ( cPreCliT )->( dbSeek( cPreCli ) )
      lEstPre     := ( cPreCliT )->lEstado
   END IF

RETURN ( lEstPre )

//---------------------------------------------------------------------------//

FUNCTION cNbrPreCli( cPreCli, cPreCliT )

   local cNomCli  := ""

   IF ( cPreCliT )->( dbSeek( cPreCli ) )
      cNomCli  := ( cPreCliT )->CNOMCLI
   END IF

RETURN ( cNomCli )

//----------------------------------------------------------------------------//
//
// Devuelve el total de la compra en albaranes de clientes de un articulo
//

function nTotDPreCli( cCodArt, dbfPreCliL )

   local nTotVta  := 0
   local nRecno   := ( dbfPreCliL )->( Recno() )

   if ( dbfPreCliL )->( dbSeek( cCodArt ) )

      while ( dbfPreCliL )->CREF == cCodArt .and. !( dbfPreCliL )->( eof() )

         If !( dbfPreCliL )->LTOTLIN
            nTotVta += nTotNPreCli( dbfPreCliL )
         end if

         ( dbfPreCliL )->( dbSkip() )

      end while

   end if

   ( dbfPreCliL )->( dbGoTo( nRecno ) )

return ( nTotVta )

//---------------------------------------------------------------------------//

function nVtaPreCli( cCodCli, dDesde, dHasta, cPreCliT, cPreCliL, dbfIva, dbfDiv )

   local nCon     := 0
   local nRec     := ( cPreCliT )->( Recno() )

   /*
   Facturas a Clientes -------------------------------------------------------
   */

   if ( cPreCliT )->( dbSeek( cCodCli ) )

      while ( cPreCliT )->cCodCli == cCodCli .and. !( cPreCliT )->( Eof() )

         if ( dDesde == nil .or. ( cPreCliT )->dFecPre >= dDesde )    .and.;
            ( dHasta == nil .or. ( cPreCliT )->dFecPre <= dHasta )

            nCon  += nTotPreCli( ( cPreCliT )->cSerPre + Str( ( cPreCliT )->nNumPre ) + ( cPreCliT )->cSufPre, cPreCliT, cPreCliL, dbfIva, dbfDiv, nil, nil, cDivEmp(), .f. )

         end if

         ( cPreCliT )->( dbSkip() )

      end while

   end if

   ( cPreCliT )->( dbGoTo( nRec ) )

return nCon

//----------------------------------------------------------------------------//

FUNCTION aDocPreCli()

   local aDoc  := {}

   /*
   Itmes-----------------------------------------------------------------------
   */

   aAdd( aDoc, { "Empresa",         "EM" } )
   aAdd( aDoc, { "Presupuesto",     "RC" } )
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

function aItmPreCli()

   local aItmPreCli :=  {}

   aAdd( aItmPreCli, { "CSERPRE",   "C",  1,  0, "Serie de presupuesto" ,                             "Serie",                         "", "( cDbf )", nil } )
   aAdd( aItmPreCli, { "NNUMPRE",   "N",  9,  0, "Número de presupuesto" ,                            "Numero",                        "", "( cDbf )", nil } )
   aAdd( aItmPreCli, { "CSUFPRE",   "C",  2,  0, "Sufijo de presupuesto" ,                            "Sufijo",                        "", "( cDbf )", nil } )
   aAdd( aItmPreCli, { "CTURPRE",   "C",  6,  0, "Sesión del presupuesto",                            "Turno",                         "", "( cDbf )", nil } )
   aAdd( aItmPreCli, { "DFECPRE",   "D",  8,  0, "Fecha del presupuesto",                             "Fecha",                         "", "( cDbf )", nil } )
   aAdd( aItmPreCli, { "CCODCLI",   "C", 12,  0, "Código del cliente",                                "Cliente",                       "", "( cDbf )", nil } )
   aAdd( aItmPreCli, { "CNOMCLI",   "C", 80,  0, "Nombre del cliente",                                "NombreCliente",                 "", "( cDbf )", nil } )
   aAdd( aItmPreCli, { "CDIRCLI",   "C",200,  0, "Domicilio del cliente",                             "DomicilioCliente",              "", "( cDbf )", nil } )
   aAdd( aItmPreCli, { "CPOBCLI",   "C",200,  0, "Población del cliente",                             "PoblacionCliente",              "", "( cDbf )", nil } )
   aAdd( aItmPreCli, { "CPRVCLI",   "C",100,  0, "Provincia del cliente",                             "ProvinciaCliente",              "", "( cDbf )", nil } )
   aAdd( aItmPreCli, { "CPOSCLI",   "C", 15,  0, "Código postal del cliente",                         "CodigoPostalCliente",           "", "( cDbf )", nil } )
   aAdd( aItmPreCli, { "CDNICLI",   "C", 30,  0, "DNI del cliente",                                   "DniCliente",                    "", "( cDbf )", nil } )
   aAdd( aItmPreCli, { "LMODCLI",   "L",  1,  0, "Modificar datos del cliente",                       "ModificarDatosCliente",         "", "( cDbf )", nil } )
   aAdd( aItmPreCli, { "CCODAGE",   "C",  3,  0, "Código del agente",                                 "Agente",                        "", "( cDbf )", nil } )
   aAdd( aItmPreCli, { "CCODOBR",   "C", 10,  0, "Código de dirección",                               "Direccion",                     "", "( cDbf )", nil } )
   aAdd( aItmPreCli, { "CCODTAR",   "C",  5,  0, "Código de tarifa",                                  "Tarifa",                        "", "( cDbf )", nil } )
   aAdd( aItmPreCli, { "CCODALM",   "C", 16,  0, "Código del almacen",                                "Almacen",                       "", "( cDbf )", nil } )
   aAdd( aItmPreCli, { "CCODCAJ",   "C",  3,  0, "Código de caja",                                    "Caja",                          "", "( cDbf )", nil } )
   aAdd( aItmPreCli, { "CCODPGO",   "C",  2,  0, "Código de pago",                                    "Pago",                          "", "( cDbf )", nil } )
   aAdd( aItmPreCli, { "CCODRUT",   "C",  4,  0, "Código de la ruta",                                 "Ruta",                          "", "( cDbf )", nil } )
   aAdd( aItmPreCli, { "DFECENT",   "D",  8,  0, "Fecha de entrada",                                  "FechaSalida",                   "", "( cDbf )", nil } )
   aAdd( aItmPreCli, { "LESTADO",   "L",  1,  0, "Estado del presupuesto",                            "Estado",                        "", "( cDbf )", nil } )
   aAdd( aItmPreCli, { "CSUPRE",    "C", 10,  0, "Su presupuesto",                                    "DocumentoOrigen",               "", "( cDbf )", nil } )
   aAdd( aItmPreCli, { "CCONDENT",  "C",100,  0, "Condiciones del presupuesto",                       "Condiciones",                   "", "( cDbf )", nil } )
   aAdd( aItmPreCli, { "MCOMENT",   "M", 10,  0, "Comentarios",                                       "Comentarios",                   "", "( cDbf )", nil } )
   aAdd( aItmPreCli, { "MOBSERV",   "M", 10,  0, "Observaciones",                                     "Observaciones",                 "", "( cDbf )", nil } )
   aAdd( aItmPreCli, { "LMAYOR",    "L",  1,  0, "" ,                                                 "",                              "", "( cDbf )", nil } )
   aAdd( aItmPreCli, { "NTARIFA",   "N",  1,  0, "Tarifa de precio aplicada" ,                        "NumeroTarifa",                  "", "( cDbf )", nil } )
   aAdd( aItmPreCli, { "CDTOESP",   "C", 50,  0, "Descripción del descuento",                         "DescripcionDescuento1",         "", "( cDbf )", nil } )
   aAdd( aItmPreCli, { "NDTOESP",   "N",  5,  2, "Porcentaje de descuento",                           "PorcentajeDescuento1",          "", "( cDbf )", nil } )
   aAdd( aItmPreCli, { "CDPP",      "C", 50,  0, "Descripción del descuento por pronto pago",         "DescripcionDescuento2",         "", "( cDbf )", nil } )
   aAdd( aItmPreCli, { "NDPP",      "N",  5,  2, "Pct. de dto. por pronto pago",                      "PorcentajeDescuento2",          "", "( cDbf )", nil } )
   aAdd( aItmPreCli, { "CDTOUNO",   "C", 50,  0, "Desc. del primer descuento pers.",                  "DescripcionDescuento3",         "", "( cDbf )", nil } )
   aAdd( aItmPreCli, { "NDTOUNO",   "N",  5,  2, "Pct. del primer descuento pers.",                   "PorcentajeDescuento3",          "", "( cDbf )", nil } )
   aAdd( aItmPreCli, { "CDTODOS",   "C", 50,  0, "Desc. del segundo descuento pers.",                 "DescripcionDescuento4",         "", "( cDbf )", nil } )
   aAdd( aItmPreCli, { "NDTODOS",   "N",  5,  2, "Pct. del segundo descuento pers.",                  "PorcentajeDescuento4",          "", "( cDbf )", nil } )
   aAdd( aItmPreCli, { "NDTOCNT",   "N",  5,  2, "Pct. de dto. por pago contado",                     "",                              "", "( cDbf )", nil } )
   aAdd( aItmPreCli, { "NDTORAP",   "N",  5,  2, "Pct. de dto. por rappel",                           "",                              "", "( cDbf )", nil } )
   aAdd( aItmPreCli, { "NDTOPUB",   "N",  5,  2, "Pct. de dto. por publicidad",                       "",                              "", "( cDbf )", nil } )
   aAdd( aItmPreCli, { "NDTOPGO",   "N",  5,  2, "Pct. de dto. por pago centralizado",                "",                              "", "( cDbf )", nil } )
   aAdd( aItmPreCli, { "NDTOPTF",   "N",  7,  2, "",                                                  "",                              "", "( cDbf )", nil } )
   aAdd( aItmPreCli, { "LRECARGO",  "L",  1,  0, "Aplicar recargo de equivalencia",                   "RecargoEquivalencia",           "", "( cDbf )", nil } )
   aAdd( aItmPreCli, { "NPCTCOMAGE","N",  5,  2, "Pct. de comisión del agente",                       "ComisionAgente",                "", "( cDbf )", nil } )
   aAdd( aItmPreCli, { "NBULTOS",   "N",  5,  0, "Numero de bultos",                                  "Bultos",                        "", "( cDbf )", nil } )
   aAdd( aItmPreCli, { "CNUMALB",   "C", 10,  0, "" ,                                                 "NumeroAlbaran",                 "", "( cDbf )", nil } )
   aAdd( aItmPreCli, { "CDIVPRE",   "C",  3,  0, "Código de divisa",                                  "Divisa",                        "", "( cDbf )", nil } )
   aAdd( aItmPreCli, { "NVDVPRE",   "N", 10,  4, "Valor del cambio de la divisa",                     "ValorDivisa",                   "", "( cDbf )", nil } )
   aAdd( aItmPreCli, { "LSNDDOC",   "L",  1,  0, "Valor lógico documento enviado",                    "Envio",                         "", "( cDbf )", nil } )
   aAdd( aItmPreCli, { "CRETPOR",   "C",150,  0, "Retirado por" ,                                     "RetiradoPor",                   "", "( cDbf )", nil } )
   aAdd( aItmPreCli, { "CRETMAT",   "C",150,  0, "Matrícula" ,                                        "Matricula",                     "", "( cDbf )", nil } )
   aAdd( aItmPreCli, { "NREGIVA",   "N",  1,  0, "Regimen de " + cImp() ,                             "TipoImpuesto",                  "", "( cDbf )", nil } )
   aAdd( aItmPreCli, { "LIVAINC",   "L",  1,  0, "Lógico de " + cImp() + " incluido" ,                "ImpuestosIncluidos",            "", "( cDbf )", nil } )
   aAdd( aItmPreCli, { "NIVAMAN",   "N",  6,  2, "Porcentaje de " + cImp() + " del gasto" ,           "ImpuestoGastos",                "", "( cDbf )", nil } )
   aAdd( aItmPreCli, { "NMANOBR",   "N", 16,  6, "Gastos" ,                                           "Gastos",                        "", "( cDbf )", nil } )
   aAdd( aItmPreCli, { "cCodTrn",   "C",  9,  0, "Código de transportista" ,                          "Transportista",                 "", "( cDbf )", nil } )
   aAdd( aItmPreCli, { "nKgsTrn"   ,"N", 16,  6, "TARA del transportista" ,                           "TaraTransportista",             "", "( cDbf )", nil } )
   aAdd( aItmPreCli, { "lCloPre",   "L",  1,  0, "Lógico de presupuesto cerrado" ,                    "DocumentoCerrado",              "", "( cDbf )", nil } )
   aAdd( aItmPreCli, { "cCodUsr",   "C",  3,  0, "Código de usuario",                                 "Usuario",                       "", "( cDbf )", nil } )
   aAdd( aItmPreCli, { "dFecCre",   "D",  8,  0, "Fecha de creación del documento",                   "FechaCreacion",                 "", "( cDbf )", nil } )
   aAdd( aItmPreCli, { "cTimCre",   "C",  5,  0, "Hora de creación del documento",                    "HoraCreacion",                  "", "( cDbf )", nil } )
   aAdd( aItmPreCli, { "cSituac",   "C", 20,  0, "Situación del documento",                           "Situacion",                     "", "( cDbf )", nil } )
   aAdd( aItmPreCli, { "nDiaVal",   "N",  3,  0, "Dias de validez",                                   "DiasValidez",                   "", "( cDbf )", nil } )
   aAdd( aItmPreCli, { "cCodGrp",   "C",  4,  0, "Código de grupo de cliente",                        "GrupoCliente",                  "", "( cDbf )", nil } )
   aAdd( aItmPreCli, { "lImprimido","L",  1,  0, "Lógico de imprimido del documento",                 "Imprimido",                     "", "( cDbf )", nil } )
   aAdd( aItmPreCli, { "dFecImp",   "D",  8,  0, "Última fecha de impresión del documento",           "FechaImpresion",                "", "( cDbf )", nil } )
   aAdd( aItmPreCli, { "cHorImp",   "C",  5,  0, "Hora de la última impresión del documento",         "HoraImpresion",                 "", "( cDbf )", nil } )
   aAdd( aItmPreCli, { "cCodDlg",   "C",  2,  0, "Código delegación" ,                                "Delegacion",                    "", "( cDbf )", nil } )
   aAdd( aItmPreCli, { "nDtoAtp",   "N",  6,  2, "Porcentaje de descuento atípico",                   "DescuentoAtipico",              "", "( cDbf )", nil } )
   aAdd( aItmPreCli, { "nSbrAtp",   "N",  1,  0, "Lugar donde aplicar dto atípico",                   "LugarAplicarDescuentoAtipico",  "", "( cDbf )", nil } )
   aAdd( aItmPreCli, { "dFecEntr",  "D",  8,  0, "Fecha de entrada de alquiler",                      "EntradaAlquiler",               "", "( cDbf )", nil } )
   aAdd( aItmPreCli, { "dFecSal",   "D",  8,  0, "Fecha de salidad de alquiler",                      "SalidaAlquiler",                "", "( cDbf )", nil } )
   aAdd( aItmPreCli, { "lAlquiler", "L",  1,  0, "Lógico de alquiler",                                "Alquiler",                      "", "( cDbf )", nil } )
   aAdd( aItmPreCli, { "cManObr",   "C",250,  0, "Literal de gastos" ,                                "LiteralGastos",                 "", "( cDbf )", nil } )
   aAdd( aItmPreCli, { "cNumTik",   "C", 13,  0, "Número del ticket generado" ,                       "NumeroTicket",                  "", "( cDbf )", nil } )
   aAdd( aItmPreCli, { "cTlfCli",   "C", 20,  0, "Teléfono del cliente" ,                             "TelefonoCliente",               "", "( cDbf )", nil } )
   aAdd( aItmPreCli, { "nTotNet",   "N", 16,  6, "Total neto" ,                                       "TotalNeto",                     "", "( cDbf )", nil } )
   aAdd( aItmPreCli, { "nTotIva",   "N", 16,  6, "Total " + cImp() ,                                  "TotalImpuesto",                 "", "( cDbf )", nil } )
   aAdd( aItmPreCli, { "nTotReq",   "N", 16,  6, "Total recargo" ,                                    "TotalRecargo",                  "", "( cDbf )", nil } )
   aAdd( aItmPreCli, { "nTotPre",   "N", 16,  6, "Total presupuesto" ,                                "TotalDocumento",                "", "( cDbf )", nil } )
   aAdd( aItmPreCli, { "lOperPV",   "L",  1,  0, "Lógico para operar con punto verde" ,               "OperarPuntoVerde",              "", "( cDbf )", nil } )
   aAdd( aItmPreCli, { "nDtoTarifa","N",  6,  2, "Descuento de tarifa de cliente",                    "DescuentoTarifa",               "", "( cDbf )", nil } )
   aAdd( aItmPreCli, { "cCodWeb",   "N", 11,  0, "Codigo del presupuesto en la web" ,                 "CodigoWeb",                     "", "( cDbf )", nil } )
   aAdd( aItmPreCli, { "lWeb",      "L",  1,  0, "Lógico de recibido por web" ,                       "",                              "", "( cDbf )", nil } )
   aAdd( aItmPreCli, { "lInternet", "L",  1,  0, "Pedido desde internet" ,                            "",                              "", "( cDbf )", nil } )
   aAdd( aItmPreCli, { "mFirma",    "M", 10,  2, "Firma",                                             "Firma",                         "", "( cDbf )", nil } )
   aAdd( aItmPreCli, { "cCtrCoste", "C",  9,  0, "Código del centro de coste" ,                       "CentroCoste",                   "", "( cDbf )", nil } )

return ( aItmPreCli )

//---------------------------------------------------------------------------//

function aCalPreCli()

   local aCalPreCli  := {  { "nTotArt",                                                   "N", 16,  6, "Total artículos",             "cPicUndPre",  "" },;
                           { "nTotCaj",                                                   "N", 16,  6, "Total cajas",                 "cPicUndPre",  "" },;
                           { "aTotIva[1,1]",                                              "N", 16,  6, "Bruto primer tipo de " + cImp(),    "cPorDivPre",  "aTotIva[1,1] != 0" },;
                           { "aTotIva[2,1]",                                              "N", 16,  6, "Bruto segundo tipo de " + cImp(),   "cPorDivPre",  "aTotIva[2,1] != 0" },;
                           { "aTotIva[3,1]",                                              "N", 16,  6, "Bruto tercer tipo de " + cImp(),    "cPorDivPre",  "aTotIva[3,1] != 0" },;
                           { "aTotIva[1,2]",                                              "N", 16,  6, "Base primer tipo de " + cImp(),     "cPorDivPre",  "aTotIva[1,2] != 0" },;
                           { "aTotIva[2,2]",                                              "N", 16,  6, "Base segundo tipo de " + cImp(),    "cPorDivPre",  "aTotIva[2,2] != 0" },;
                           { "aTotIva[3,2]",                                              "N", 16,  6, "Base tercer tipo de " + cImp(),     "cPorDivPre",  "aTotIva[3,2] != 0" },;
                           { "aTotIva[1,3]",                                              "N",  5,  2, "Porcentaje primer tipo " + cImp(),  "'@R 99.99%'", "aTotIva[1,3] != 0" },;
                           { "aTotIva[2,3]",                                              "N",  5,  2, "Porcentaje segundo tipo " + cImp(), "'@R 99.99%'", "aTotIva[2,3] != 0" },;
                           { "aTotIva[3,3]",                                              "N",  5,  2, "Porcentaje tercer tipo " + cImp(),  "'@R 99.99%'", "aTotIva[3,3] != 0" },;
                           { "aTotIva[1,4]",                                              "N",  5,  2, "Porcentaje primer tipo RE",   "'@R 99.99%'", "aTotIva[1,4] != 0" },;
                           { "aTotIva[2,4]",                                              "N",  5,  2, "Porcentaje segundo tipo RE",  "'@R 99.99%'", "aTotIva[2,4] != 0" },;
                           { "aTotIva[3,4]",                                              "N",  5,  2, "Porcentaje tercer tipo RE",   "'@R 99.99%'", "aTotIva[3,4] != 0" },;
                           { "round( aTotIva[1,2] * aTotIva[1,3] / 100, nDouDivPre )",    "N", 16,  6, "Importe primer tipo " + cImp(),     "cPorDivPre",  "aTotIva[1,2] != 0" },;
                           { "round( aTotIva[2,2] * aTotIva[2,3] / 100, nDouDivPre )",    "N", 16,  6, "Importe segundo tipo " + cImp(),    "cPorDivPre",  "aTotIva[2,2] != 0" },;
                           { "round( aTotIva[3,2] * aTotIva[3,3] / 100, nDouDivPre )",    "N", 16,  6, "Importe tercer tipo " + cImp(),     "cPorDivPre",  "aTotIva[3,2] != 0" },;
                           { "round( aTotIva[1,2] * aTotIva[1,4] / 100, nDouDivPre )",    "N", 16,  6, "Importe primer RE",           "cPorDivPre",  "aTotIva[1,2] != 0" },;
                           { "round( aTotIva[2,2] * aTotIva[2,4] / 100, nDouDivPre )",    "N", 16,  6, "Importe segundo RE",          "cPorDivPre",  "aTotIva[2,2] != 0" },;
                           { "round( aTotIva[3,2] * aTotIva[3,4] / 100, nDouDivPre )",    "N", 16,  6, "Importe tercer RE",           "cPorDivPre",  "aTotIva[3,2] != 0" },;
                           { "aTotIvm[1,1]",                                              "N", 16,  6, "Total unidades primer tipo de impuestos especiales",    "cPorDivPre",  "aTotIvm[1,1] != 0" },;
                           { "aTotIvm[2,1]",                                              "N", 16,  6, "Total unidades segundo tipo de impuestos especiales",   "cPorDivPre",  "aTotIvm[2,1] != 0" },;
                           { "aTotIvm[3,1]",                                              "N", 16,  6, "Total unidades tercer tipo de impuestos especiales",    "cPorDivPre",  "aTotIvm[3,1] != 0" },;
                           { "aTotIva[1,2]",                                              "N", 16,  6, "Importe del primer tipo de impuestos especiales",       "cPorDivPre",  "aTotIvm[1,2] != 0" },;
                           { "aTotIva[2,2]",                                              "N", 16,  6, "Importe del segundo tipo de impuestos especiales",      "cPorDivPre",  "aTotIvm[2,2] != 0" },;
                           { "aTotIva[3,2]",                                              "N", 16,  6, "Importe del tercer tipo de impuestos especiales",       "cPorDivPre",  "aTotIvm[3,2] != 0" },;
                           { "aTotIvm[1,3]",                                              "N", 16,  6, "Total importe primer tipo de impuestos especiales",     "cPorDivPre",  "aTotIvm[1,3] != 0" },;
                           { "aTotIvm[2,3]",                                              "N", 16,  6, "Total importe segundo tipo de impuestos especiales",    "cPorDivPre",  "aTotIvm[2,3] != 0" },;
                           { "aTotIvm[3,3]",                                              "N", 16,  6, "Total importe tercer tipo de impuestos especiales",     "cPorDivPre",  "aTotIvm[3,3] != 0" },;
                           { "nTotBrt",                                                   "N", 16,  6, "Total bruto",                 "cPorDivPre",  "lEnd" },;
                           { "nTotDto",                                                   "N", 16,  6, "Total descuento",             "cPorDivPre",  "lEnd" },;
                           { "nTotDpp",                                                   "N", 16,  6, "Total descuento pronto pago", "cPorDivPre",  "lEnd" },;
                           { "nTotNet",                                                   "N", 16,  6, "Total neto",                  "cPorDivPre",  "lEnd" },;
                           { "nTotIva",                                                   "N", 16,  6, "Total " + cImp(),             "cPorDivPre",  "lEnd" },;
                           { "nTotIvm",                                                   "N", 16,  6, "Total IVMH",                  "cPorDivPre",  "lEnd" },;
                           { "nTotReq",                                                   "N", 16,  6, "Total RE",                    "cPorDivPre",  "lEnd" },;
                           { "nTotPre",                                                   "N", 16,  6, "Total presupuesto",           "cPorDivPre",  "lEnd" },;
                           { "nTotPes",                                                   "N", 16,  6, "Total peso",                  "'@E 99,999.99'","lEnd" },;
                           { "nTotCos",                                                   "N", 16,  6, "Total costo",                 "cPorDivPre",  "lEnd" },;
                           { "nTotPage",                                                  "N", 16,  6, "Total página",                "cPorDivPre",  "!lEnd" },;
                           { "nImpEuros( nTotPre, (cDbf)->cDivPre, cDbfDiv )",            "N", 16,  6, "Total Presupuesto (Euros)",   "",            "lEnd" },;
                           { "nImpPesetas( nTotPre, (cDbf)->cDivPre, cDbfDiv )",          "N", 16,  6, "Total Presupuesto (Pesetas)", "",            "lEnd" },;
                           { "nPagina",                                                   "N",  2,  0, "Numero de página",            "'99'",        "" },;
                           { "lEnd",                                                      "L",  1,  0, "Fin del documento",           "",            "" } }

return ( aCalPreCli )

//---------------------------------------------------------------------------//

function aColPreCli()

   local aColPreCli  := {}

   aAdd( aColPreCli, { "cSerPre", "C",    1,  0, "Serie de presupuesto" ,                    "Serie",                         "", "( cDbfCol )", nil } )
   aAdd( aColPreCli, { "nNumPre", "N",    9,  0, "Numero de presupuesto" ,                   "Numero",                        "", "( cDbfCol )", nil } )
   aAdd( aColPreCli, { "cSufPre", "C",    2,  0, "Sufijo de presupuesto" ,                   "Sufijo",                        "", "( cDbfCol )", nil } )
   aAdd( aColPreCli, { "cRef",    "C",   18,  0, "Referencia del producto" ,                 "Articulo",                      "", "( cDbfCol )", nil } )
   aAdd( aColPreCli, { "cDetalle","C",  250,  0, "Descripción de artículo" ,                 "DescripcionArticulo",           "", "( cDbfCol )", nil } )
   aAdd( aColPreCli, { "nIva"    ,"N",    6,  2, "Importe del " + cImp() ,                   "PorcentajeImpuesto",            "", "( cDbfCol )", nil } )
   aAdd( aColPreCli, { "nCanPre" ,"N",   16,  6, cNombreCajas(),                             "Cajas",                         "", "( cDbfCol )", nil } )
   aAdd( aColPreCli, { "nUniCaja","N",   16,  6, cNombreUnidades(),                          "Unidades",                      "", "( cDbfCol )", nil } )
   aAdd( aColPreCli, { "lControl","L",    1,  0, "" ,                                        "",                              "", "( cDbfCol )", nil } )
   aAdd( aColPreCli, { "nUndKit", "N",   16,  6, "Unidades tipo kit" ,                       "UnidadesKit",                   "", "( cDbfCol )", nil } )
   aAdd( aColPreCli, { "nPreDiv" ,"N",   16,  6, "Importe del producto" ,                    "PrecioVenta",                   "", "( cDbfCol )", nil } )
   aAdd( aColPreCli, { "nPntVer", "N",   16,  6, "Importe punto verde" ,                     "PuntoVerde",                    "", "( cDbfCol )", nil } )
   aAdd( aColPreCli, { "nImpTrn", "N",   16,  6, "Importe del transporte",                   "Portes",                        "", "( cDbfCol )", nil } )
   aAdd( aColPreCli, { "nDto",    "N",    6,  2, "Descuento del producto" ,                  "DescuentoPorcentual",           "", "( cDbfCol )", nil } )
   aAdd( aColPreCli, { "nDtoPrm", "N",    6,  2, "Descuento de la promoción" ,               "DescuentoPromocion",            "", "( cDbfCol )", nil } )
   aAdd( aColPreCli, { "nComAge", "N",    6,  2, "Comisión del agente" ,                     "ComisionAgente",                "", "( cDbfCol )", nil } )
   aAdd( aColPreCli, { "nCanEnt", "N",   16,  6, "Unidades de entrada" ,                     "",                              "", "( cDbfCol )", nil } )
   aAdd( aColPreCli, { "cUnidad", "C",    2,  0, "Unidad de venta" ,                         "UnidadMedicion",                "", "( cDbfCol )", nil } )
   aAdd( aColPreCli, { "nPesokg", "N",   16,  6, "Peso del producto" ,                       "Peso",                          "", "( cDbfCol )", nil } )
   aAdd( aColPreCli, { "cPesokg", "C",    2,  0, "Unidad de peso del producto" ,             "UnidadMedicionPeso",            "", "( cDbfCol )", nil } )
   aAdd( aColPreCli, { "dFecha",  "D",    8,  0, "Fecha de entrega",                         "FechaEntrega",                  "", "( cDbfCol )", nil } )
   aAdd( aColPreCli, { "mLngDes", "M",   10,  0, "Descripción de artículo sin codificar",    "DescripcionAmpliada",           "", "( cDbfCol )", nil } )
   aAdd( aColPreCli, { "lTotLin", "L",    1,  0, "Linea de total" ,                          "LineaTotal",                    "", "( cDbfCol )", nil } )
   aAdd( aColPreCli, { "lImpLin", "L",    1,  0, "Linea no imprimible" ,                     "LineaNoImprimible",             "", "( cDbfCol )", nil } )
   aAdd( aColPreCli, { "cCodPr1", "C",   20,  0, "Código de la primera propiedad",           "CodigoPropiedad1",              "", "( cDbfCol )", nil } )
   aAdd( aColPreCli, { "cCodPr2", "C",   20,  0, "Código de la segunda propiedad",           "CodigoPropiedad2",              "", "( cDbfCol )", nil } )
   aAdd( aColPreCli, { "cValPr1", "C",   20,  0, "Valor de la primera propiedad",            "ValorPropiedad1",               "", "( cDbfCol )", nil } )
   aAdd( aColPreCli, { "cValPr2", "C",   20,  0, "Valor de la segunda propiedad",            "ValorPropiedad2",               "", "( cDbfCol )", nil } )
   aAdd( aColPreCli, { "nFacCnv", "N",   16,  6, "Factor de conversión de la compra",        "FactorConversion",              "", "( cDbfCol )", nil } )
   aAdd( aColPreCli, { "nDtoDiv", "N",   16,  6, "Descuento lineal de la compra",            "DescuentoLineal",               "", "( cDbfCol )", nil } )
   aAdd( aColPreCli, { "cTipMov", "C",    2,  0, "Tipo de movimiento",                       "Tipo",                          "", "( cDbfCol )", nil } )
   aAdd( aColPreCli, { "nNumLin", "N",    4,  0, "Numero de la línea",                       "NumeroLinea",                   "", "( cDbfCol )", nil } )
   aAdd( aColPreCli, { "nCtlStk", "N",    1,  0, "Tipo de stock de la línea",                "TipoStock",                     "", "( cDbfCol )", nil } )
   aAdd( aColPreCli, { "nCosDiv", "N",   16,  6, "Costo del producto" ,                      "PrecioCosto",                   "", "( cDbfCol )", nil } )
   aAdd( aColPreCli, { "nPvpRec", "N",   16,  6, "Precio de venta recomendado" ,             "PrecioVentaRecomendado",        "", "( cDbfCol )", nil } )
   aAdd( aColPreCli, { "cAlmLin", "C",   16,  0, "Código de almacén" ,                       "Almacen",                       "", "( cDbfCol )", nil } )
   aAdd( aColPreCli, { "lIvaLin", "L",    1,  0, "Línea con " + cImp() + " incluido",        "LineaImpuestoIncluido",         "", "( cDbfCol )", nil } )
   aAdd( aColPreCli, { "cCodImp", "C",    3,  0, "Código del impuesto especial",             "ImpuestoEspecial",              "", "( cDbfCol )", nil } )
   aAdd( aColPreCli, { "nValImp", "N",   16,  6, "Importe de impuesto",                      "ImporteImpuestoEspecial",       "", "( cDbfCol )", nil } )
   aAdd( aColPreCli, { "lLote",   "L",    1,  0, "",                                         "LogicoLote",                    "", "( cDbfCol )", nil } )
   aAdd( aColPreCli, { "nLote",   "N",    9,  0, "",                                         "",                              "", "( cDbfCol )", nil } )
   aAdd( aColPreCli, { "cLote",   "C",   14,  0, "Número de Lote",                           "Lote",                          "", "( cDbfCol )", nil } )
   aAdd( aColPreCli, { "lKitArt", "L",    1,  0, "Línea con escandallo",                     "LineaEscandallo" ,              "", "( cDbfCol )", nil } )
   aAdd( aColPreCli, { "lKitChl", "L",    1,  0, "Línea pertenciente a escandallo",          "LineaPerteneceEscandallo" ,     "", "( cDbfCol )", nil } )
   aAdd( aColPreCli, { "lKitPrc", "L",    1,  0, "Línea de escandallos con precio",          "LineaEscandalloPrecio" ,        "", "( cDbfCol )", nil } )
   aAdd( aColPreCli, { "nMesGrt", "N",    2,  0, "Meses de garantía",                        "MesesGarantia",                 "", "( cDbfCol )", nil } )
   aAdd( aColPreCli, { "lMsgVta", "L",    1,  0, "Avisar en venta sin stocks",               "AvisarSinStock",                "", "( cDbfCol )", nil } )
   aAdd( aColPreCli, { "lNotVta", "L",    1,  0, "No permitir venta sin stocks",             "NoPermitirSinStock",            "", "( cDbfCol )", nil } )
   aAdd( aColPreCli, { "mNumSer", "M",   10,  0, "" ,                                        "",                              "", "( cDbfCol )", nil } )
   aAdd( aColPreCli, { "cCodTip", "C",    4,  0, "Código del tipo de artículo",              "TipoArticulo",                  "", "( cDbfCol )", nil } )
   aAdd( aColPreCli, { "cCodFam", "C",   16,  0, "Código de familia",                        "Familia",                       "", "( cDbfCol )", nil } )
   aAdd( aColPreCli, { "cGrpFam", "C",    3,  0, "Código del grupo de familia",              "GrupoFamilia",                  "", "( cDbfCol )", nil } )
   aAdd( aColPreCli, { "nReq",    "N",    6,  2, "Recargo de equivalencia",                  "RecargoEquivalencia",           "", "( cDbfCol )", nil } )
   aAdd( aColPreCli, { "mObsLin", "M",   10,  0, "Observacion de línea",                     "Observaciones",                 "", "( cDbfCol )", nil } )
   aAdd( aColPreCli, { "cCodPrv", "C",   12,  0, "Código del proveedor",                     "Proveedor",                     "", "( cDbfCol )", nil } )
   aAdd( aColPreCli, { "cNomPrv", "C",   30,  0, "Nombre del proveedor",                     "NombreProveedor",               "", "( cDbfCol )", nil } )
   aAdd( aColPreCli, { "cImagen", "C",  250,  0, "Fichero de imagen" ,                       "Imagen",                        "", "( cDbfCol )", nil } )
   aAdd( aColPreCli, { "nPuntos", "N",   15,  6, "Puntos del artículo",                      "",                              "", "( cDbfCol )", nil } )
   aAdd( aColPreCli, { "nValPnt", "N",   16,  6, "Valor del punto",                          "",                              "", "( cDbfCol )", nil } )
   aAdd( aColPreCli, { "nDtoPnt", "N",    5,  2, "Descuento puntos",                         "",                              "", "( cDbfCol )", nil } )
   aAdd( aColPreCli, { "nIncPnt", "N",    5,  2, "Incremento porcentual",                    "",                              "", "( cDbfCol )", nil } )
   aAdd( aColPreCli, { "cRefPrv", "C",   18,  0, "Referencia artículo proveedor",            "ReferenciaProveedor",           "", "( cDbfCol )", nil } )
   aAdd( aColPreCli, { "nVolumen","N",   16,  6, "Volumen del producto" ,                    "Volumen",                       "", "( cDbfCol )", nil } )
   aAdd( aColPreCli, { "cVolumen","C",    2,  0, "Unidad del volumen" ,                      "UnidadMedicionVolumen",         "", "( cDbfCol )", nil } )
   aAdd( aColPreCli, { "dFecEnt" ,"D",    8,  0, "Fecha de entrada del alquiler",            "FechaEntradaAlquiler",          "", "( cDbfCol )", nil } )
   aAdd( aColPreCli, { "dFecSal" ,"D",    8,  0, "Fecha de salida del alquiler",             "FechaSalidaAlquiler",           "", "( cDbfCol )", nil } )
   aAdd( aColPreCli, { "nPreAlq" ,"N",   16,  6, "Precio de alquiler",                       "PrecioAlquiler",                "", "( cDbfCol )", nil } )
   aAdd( aColPreCli, { "lAlquiler","L",   1,  0, "Lógico de alquiler",                       "Alquiler",                      "", "( cDbfCol )", nil } )
   aAdd( aColPreCli, { "nNumMed"  ,"N",   1,  0, "Número de mediciones",                     "NumeroMedidiones",              "", "( cDbfCol )", nil } )
   aAdd( aColPreCli, { "nMedUno"  ,"N",  16,  6, "Primera unidad de medición",               "Medicion1",                     "", "( cDbfCol )", nil } )
   aAdd( aColPreCli, { "nMedDos"  ,"N",  16,  6, "Segunda unidad de medición",               "Medicion2",                     "", "( cDbfCol )", nil } )
   aAdd( aColPreCli, { "nMedTre"  ,"N",  16,  6, "Tercera unidad de medición",               "Medicion3",                     "", "( cDbfCol )", nil } )
   aAdd( aColPreCli, { "nTarLin"  ,"N",   1,  0, "Tarifa de precio aplicada" ,               "NumeroTarifa",                  "", "( cDbfCol )", nil } )
   aAdd( aColPreCli, { "lImpFra"  ,"L",   1,  0, "Lógico de imprimir frase publicitaria",    "",                              "", "( cDbfCol )", nil } )
   aAdd( aColPreCli, { "cCodFra"  ,"C",   3,  0, "Código de frase publicitaria",             "",                              "", "( cDbfCol )", nil } )
   aAdd( aColPreCli, { "cTxtFra"  ,"C", 250,  0, "",                                         "",                              "", "( cDbfCol )", nil } )
   aAdd( aColPreCli, { "Descrip"  ,"M",  10,  0, "Descripción larga",                        "DescripcionTecnica",            "", "( cDbfCol )", nil } )
   aAdd( aColPreCli, { "lLinOfe"  ,"L",   1,  0, "Línea con oferta",                         "LineaOferta",                   "", "( cDbfCol )", nil } )
   aAdd( aColPreCli, { "lVolImp"  ,"L",   1,  0, "Lógico aplicar volumen con IpusEsp",       "VolumenImpuestosEspeciales",    "", "( cDbfCol )", nil } )
   aAdd( aColPreCli, { "dFecCad"  ,"D",   8,  0, "Fecha de caducidad",                       "FechaCaducidad",                "", "( cDbfCol )", nil } )
   aAdd( aColPreCli, { "nBultos"  ,"N",  16,  6, "Numero de bultos en líneas",               "Bultos",                        "", "( cDbfCol )", nil } )
   aAdd( aColPreCli, { "cFormato" ,"C", 100,  0, "Formato de venta",                         "",                              "", "( cDbfCol )", nil } )
   aAdd( aColPreCli, { "lLabel"   ,"L",   1,  0, "Lógico para marca de etiqueta",            "LogicoEtiqueta",                "", "( cDbfCol )", nil } )
   aAdd( aColPreCli, { "nLabel"   ,"N",   6,  0, "Unidades de etiquetas a imprimir",         "NumeroEtiqueta",                "", "( cDbfCol )", nil } )
   aAdd( aColPreCli, { "cObrLin"  ,"C",  10,  0, "Dirección de la linea",                    "Direccion",                     "", "( cDbfCol )", nil } )
   aAdd( aColPreCli, { "cRefAux"  ,"C",  18,  0, "Referencia auxiliar",                      "",                              "", "( cDbfCol )", nil } )
   aAdd( aColPreCli, { "cRefAux2" ,"C",  18,  0, "Segunda referencia auxiliar",              "",                              "", "( cDbfCol )", nil } )
   aAdd( aColPreCli, { "nPosPrint","N",   4,  0, "Posición de impresión",                    "",                              "", "( cDbfCol )", nil } )
   aAdd( aColPreCli, { "cCtrCoste","C",   9,  0, "Código del centro de coste",               "",                              "", "( cDbfCol )", nil } )
   aAdd( aColPreCli, { "cTipCtr",  "C",  20,  0, "Tipo tercero centro de coste",             "",                              "", "( cDbfCol )", nil } )
   aAdd( aColPreCli, { "cTerCtr",  "C",  20,  0, "Tercero centro de coste",                  "",                              "", "( cDbfCol )", nil } )
   aAdd( aColPreCli, { "id_tipo_v","N",  16,  0, "Identificador tipo de venta",              "IdentificadorTipoVenta",        "", "( cDbfCol )", nil } )
   aAdd( aColPreCli, { "nRegIva",  "N",   1,  0, "Régimen de " + cImp(),                     "TipoImpuesto",                  "", "( cDbfCol )", nil } )

return ( aColPreCli )

//---------------------------------------------------------------------------//

function aCocPreCli()

   local aCocPreCli :=  {}

   aAdd( aCocPreCli, { "Descrip( cDbfCol )",                                         "C", 50, 0, "Detalle del artículo",       "",            "Descripción", "" } )
   aAdd( aCocPreCli, { "nTotNPreCli( cDbfCol )",                                     "N", 16, 6, "Total articulos",            "MasUnd()",    "Unidades",    "" } )
   aAdd( aCocPreCli, { "nTotUPreCli( cDbfCol, nDouDivPre, nVdvDivPre )",             "N", 16, 6, "Precio unitario",            "cPouDivPre",  "Precio",      "" } )
   aAdd( aCocPreCli, { "nTotLPreCli( cDbfCol, nDouDivPre, nRouDivPre, nVdvDivPre )", "N", 16, 6, "Total línea de presupuesto", "cPorDivPre",  "Total",       "" } )

return ( aCocPreCli )

//---------------------------------------------------------------------------//

function aIncPreCli()

   local aColPreCli  := {}

   aAdd( aColPreCli, { "cSerPre", "C",    1,  0, "Serie de presupuesto" ,            "",                   "", "( cDbfCol )" } )
   aAdd( aColPreCli, { "nNumPre", "N",    9,  0, "Numero de presupuesto" ,           "'999999999'",        "", "( cDbfCol )" } )
   aAdd( aColPreCli, { "cSufPre", "C",    2,  0, "Sufijo de presupuesto" ,           "",                   "", "( cDbfCol )" } )
   aAdd( aColPreCli, { "cCodTip", "C",    3,  0, "Tipo de incidencia" ,              "",                   "", "( cDbfCol )" } )
   aAdd( aColPreCli, { "dFecInc", "D",    8,  0, "Fecha de la incidencia" ,          "",                   "", "( cDbfCol )" } )
   aAdd( aColPreCli, { "mDesInc", "M",   10,  0, "Descripción de la incidencia" ,    "",                   "", "( cDbfCol )" } )
   aAdd( aColPreCli, { "lListo",  "L",    1,  0, "Lógico de listo" ,                 "",                   "", "( cDbfCol )" } )
   aAdd( aColPreCli, { "lAviso",  "L",    1,  0, "Lógico de aviso" ,                 "",                   "", "( cDbfCol )" } )

return ( aColPreCli )

//---------------------------------------------------------------------------//

function aPreCliEst()

   local aPreCliEst  := {}

   aAdd( aPreCliEst, { "cSerPre", "C",    1,  0, "Serie de presupuesto" ,            "",                   "", "( cDbfCol )", nil } )
   aAdd( aPreCliEst, { "nNumPre", "N",    9,  0, "Numero de presupuesto" ,           "'999999999'",        "", "( cDbfCol )", nil } )
   aAdd( aPreCliEst, { "cSufPre", "C",    2,  0, "Sufijo de presupuesto" ,           "",                   "", "( cDbfCol )", nil } )
   aAdd( aPreCliEst, { "cSitua",  "C",  140,  0, "Situación" ,                       "",                   "", "( cDbfCol )", nil } )
   aAdd( aPreCliEst, { "dFecSit", "D",    8,  0, "Fecha de la situación" ,           "",                   "", "( cDbfCol )", nil } )
   aAdd( aPreCliEst, { "tFecSit", "C",    6,  0, "Hora de la situación" ,            "",                   "", "( cDbfCol )", nil } )
   aAdd( aPreCliEst, { "idPs",    "N",   11,  0, "Id prestashop" ,                   "",                   "", "( cDbfCol )", nil } )   

return ( aPreCliEst )

//---------------------------------------------------------------------------//


function aPreCliDoc()

   local aPreCliDoc  := {}

   aAdd( aPreCliDoc, { "cSerPre", "C",    1,  0, "Serie de presupuesto" ,            "",                   "", "( cDbfCol )" } )
   aAdd( aPreCliDoc, { "nNumPre", "N",    9,  0, "Numero de presupuesto" ,           "'999999999'",        "", "( cDbfCol )" } )
   aAdd( aPreCliDoc, { "cSufPre", "C",    2,  0, "Sufijo de presupuesto" ,           "",                   "", "( cDbfCol )" } )
   aAdd( aPreCliDoc, { "cNombre", "C",  250,  0, "Nombre del documento" ,            "",                   "", "( cDbfCol )" } )
   aAdd( aPreCliDoc, { "cRuta",   "C",  250,  0, "Ruta del documento" ,              "",                   "", "( cDbfCol )" } )
   aAdd( aPreCliDoc, { "mObsDoc", "M",   10,  0, "Observaciones del documento" ,     "",                   "", "( cDbfCol )" } )

return ( aPreCliDoc )

//---------------------------------------------------------------------------//

STATIC FUNCTION RecPreCli( aTmpPre )

   local nDtoAge
   local nImpAtp  := 0
   local nImpOfe  := 0
   local nRecno
   local cCodFam
   local hAtipica

   if !ApoloMsgNoYes(   "¡Atención!,"                                      + CRLF + ;
                        "todos los precios se recalcularán en función de"  + CRLF + ;
                        "los valores en las bases de datos.",;
                        "¿Desea proceder?" )
      return nil
   end if

   nRecno         := ( dbfTmpLin )->( RecNo() )

   ( dbfTmpLin )->( dbGotop() )
   ( D():Articulos( nView ) )->( ordSetFocus( "Codigo" ) )

   while !( dbfTmpLin )->( eof() )

      /*
      Ahora buscamos por el codigo interno
      */

      if ( D():Articulos( nView ) )->( dbSeek( ( dbfTmpLin )->cRef ) )

         if aTmpPre[ _NREGIVA ] <= 2
            ( dbfTmpLin )->nIva     := nIva( dbfIva, ( D():Articulos( nView ) )->TipoIva )
            ( dbfTmpLin )->nReq     := nReq( dbfIva, ( D():Articulos( nView ) )->TipoIva )
         end if

         /*
         Ahora recogemos el impuesto especial si lo hay
         */

         if !Empty( ( D():Articulos( nView ) )->cCodImp )
            ( dbfTmpLin )->cCodImp  := ( D():Articulos( nView ) )->cCodImp
            ( dbfTmpLin )->nValImp  := oNewImp:nValImp( ( D():Articulos( nView ) )->cCodImp, aTmpPre[ _LIVAINC ], ( dbfTmpLin )->nIva )
         end if

         /*
         Tomamos los precios de la base de datos de articulos---------------------
         */

         ( dbfTmpLin )->nPreDiv  := nRetPreArt( ( dbfTmpLin )->nTarLin, aTmpPre[ _CDIVPRE ], aTmpPre[ _LIVAINC ], D():Articulos( nView ), dbfDiv, dbfKit, dbfIva, , , oNewImp )

         /*
         Linea por contadores-----------------------------------------------------
         */

         ( dbfTmpLin )->nCtlStk  := ( D():Articulos( nView ) )->nCtlStock
         ( dbfTmpLin )->nPvpRec  := ( D():Articulos( nView ) )->PvpRec
         ( dbfTmpLin )->nCosDiv  := nCosto( nil, D():Articulos( nView ), dbfKit )

         /*
         Punto verde--------------------------------------------------------------
         */

         ( dbfTmpLin )->nPntVer  := ( D():Articulos( nView ) )->nPntVer1

         /*
         Chequeamos situaciones especiales y comprobamos las fechas
         */

         do case

         /*
         Precios en tarifas----------------------------------------------------
         */

         case !Empty( aTmpPre[ _CCODTAR ] )

            cCodFam  := ( dbfTmpLin )->cCodFam

            nImpOfe  := RetPrcTar( ( dbfTmpLin )->cRef, aTmpPre[ _CCODTAR ], ( dbfTmpLin )->cCodPr1, ( dbfTmpLin )->cCodPr2, ( dbfTmpLin )->cValPr1, ( dbfTmpLin )->cValPr2, dbfTarPreL, ( dbfTmpLin )->nTarLin )
            if nImpOfe != 0
               ( dbfTmpLin )->nPreDiv  := nImpOfe
            end if

            nImpOfe  := RetPctTar( ( dbfTmpLin )->cRef, cCodFam, aTmpPre[ _CCODTAR ], ( dbfTmpLin )->cCodPr1, ( dbfTmpLin )->cCodPr2, ( dbfTmpLin )->cValPr1, ( dbfTmpLin )->cValPr2, dbfTarPreL )
            if nImpOfe != 0
               ( dbfTmpLin )->nDto     := nImpOfe
            end if

            nImpOfe  := RetComTar( ( dbfTmpLin )->cRef, cCodFam, aTmpPre[ _CCODTAR ], ( dbfTmpLin )->cCodPr1, ( dbfTmpLin )->cCodPr2, ( dbfTmpLin )->cValPr1, ( dbfTmpLin )->cValPr2, aTmpPre[ _CCODAGE ], dbfTarPreL, dbfTarPreS )
            if nImpOfe != 0
               ( dbfTmpLin )->nComAge  := nImpOfe
            end if

            /*
            Descuento de promoci¢n, esta funci¢n comprueba si existe y si es asi devuelve el descunto de la promoci¢n.
            */

            nImpOfe  := RetDtoPrm( ( dbfTmpLin )->cRef, cCodFam, aTmpPre[ _CCODTAR ], ( dbfTmpLin )->cCodPr1, ( dbfTmpLin )->cCodPr2, ( dbfTmpLin )->cValPr1, ( dbfTmpLin )->cValPr2, aTmpPre[ _DFECPRE ], dbfTarPreL )
            if nImpOfe != 0
               ( dbfTmpLin )->nDtoPrm  := nImpOfe
            end if

            /*
            Obtenemos el descuento de Agente
            */

            nDtoAge  := RetDtoAge( ( dbfTmpLin )->cRef, cCodFam, aTmpPre[ _CCODTAR ], ( dbfTmpLin )->cCodPr1, ( dbfTmpLin )->cCodPr2, ( dbfTmpLin )->cValPr1, ( dbfTmpLin )->cValPr2, aTmpPre[ _DFECPRE ], aTmpPre[ _CCODAGE ], dbfTarPreL, dbfTarPreS )
            if nDtoAge != 0
               ( dbfTmpLin )->nComAge  := nDtoAge
            end if

         end case

         /*
         Buscamos si existen atipicas de clientes------------------------------
         */

         hAtipica := hAtipica( hValue( dbfTmpLin, aTmpPre ) )

         if !Empty( hAtipica )
               
            if hhaskey( hAtipica, "nImporte" )
               if hAtipica[ "nImporte" ] != 0
                  ( dbfTmpLin )->nPreDiv := hAtipica[ "nImporte" ]
               end if
            end if

            if hhaskey( hAtipica, "nDescuentoPorcentual" )
               if hAtipica[ "nDescuentoPorcentual" ] != 0
                  ( dbfTmpLin )->nDto     := hAtipica[ "nDescuentoPorcentual" ]
               end if   
            end if

            if hhaskey( hAtipica, "nDescuentoPromocional" )
               if hAtipica[ "nDescuentoPromocional" ] != 0
                  ( dbfTmpLin )->nDtoPrm  := hAtipica[ "nDescuentoPromocional" ]
               end if
            end if

            if hhaskey( hAtipica, "nDescuentoLineal" )
               if hAtipica[ "nDescuentoLineal" ] != 0
                  ( dbfTmpLin )->nDtoDiv  := hAtipica[ "nDescuentoLineal" ]
               end if   
            end if

            if hhaskey( hAtipica, "nComisionAgente" )
               if hAtipica[ "nComisionAgente" ] != 0
                  ( dbfTmpLin )->nComAge  := hAtipica[ "nComisionAgente" ]
               end if   
            end if

         end if

         /*
         Buscamos si existen ofertas para este articulo y le cambiamos el precio
         */

         nImpOfe     := nImpOferta( ( dbfTmpLin )->cRef, aTmpPre[ _CCODCLI ], aTmpPre[ _CCODGRP ], ( dbfTmpLin )->nUniCaja, aTmpPre[ _DFECPRE ], dbfOferta, ( dbfTmpLin )->nTarLin, nil, ( dbfTmpLin )->cCodPr1, ( dbfTmpLin )->cCodPr2, ( dbfTmpLin )->cValPr1, ( dbfTmpLin )->cValPr2 )
         if nImpOfe  != 0
            ( dbfTmpLin )->nPreDiv     := nCnv2Div( nImpOfe, cDivEmp(), aTmpPre[ _CDIVPRE ], dbfDiv )
         end if

         /*
         Buscamos si existen descuentos en las ofertas
         */

         nImpOfe     := nDtoOferta( ( dbfTmpLin )->cRef, aTmpPre[ _CCODCLI ], aTmpPre[ _CCODGRP ], ( dbfTmpLin )->nUniCaja, aTmpPre[ _DFECPRE ], dbfOferta, ( dbfTmpLin )->cCodPr1, ( dbfTmpLin )->cCodPr2, ( dbfTmpLin )->cValPr1, ( dbfTmpLin )->cValPr2 )
         if nImpOfe  != 0
            ( dbfTmpLin )->nDtoPrm  := nImpOfe
         end if

      end if

      ( dbfTmpLin )->( dbSkip() )

   end while

   ( dbfTmpLin )->( dbGoTo( nRecno ) )

return nil

//--------------------------------------------------------------------------//

Function SynPreCli( cPath )

   local oError
   local oBlock
   local nOrdAnt
   local aTotPre
   local dbfPreCliT
   local dbfPreCliL
   local dbfPreCliI
   local dbfClient
   local dbfArticulo
   local dbfFamilia
   local dbfFPago
   local dbfIva
   local dbfDiv

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   USE ( cPatEmp() + "PRECLIT.DBF" )   NEW VIA ( cDriver() ) ALIAS ( cCheckArea( "PRECLIT", @dbfPreCliT ) ) EXCLUSIVE
   SET ADSINDEX TO ( cPatEmp() + "PreCliT.Cdx" ) ADDITIVE

   USE ( cPatEmp() + "PRECLIL.DBF" )   NEW VIA ( cDriver() ) ALIAS ( cCheckArea( "PRECLIL", @dbfPreCliL ) ) EXCLUSIVE
   SET ADSINDEX TO ( cPatEmp() + "PRECLIL.CDX" ) ADDITIVE

   USE ( cPatEmp() + "PRECLII.DBF" )   NEW VIA ( cDriver() ) ALIAS ( cCheckArea( "PRECLII", @dbfPreCliI ) ) EXCLUSIVE
   SET ADSINDEX TO ( cPatEmp() + "PRECLII.CDX" ) ADDITIVE
   
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

   ( dbfPreCliT )->( ordSetFocus( 0 ) )
   ( dbfPreCliT )->( dbGoTop() )

      while !( dbfPreCliT )->( eof() )

         if Empty( ( dbfPreCliT )->cSufPre )
            ( dbfPreCliT )->cSufPre := "00"
         end if

         if !Empty( ( dbfPreCliT )->cNumTik ) .and. Len( AllTrim( ( dbfPreCliT )->cNumTik ) ) != 13
            ( dbfPreCliT )->cNumTik := AllTrim( ( dbfPreCliT )->cNumTik ) + "00"
         end if

         if Empty( ( dbfPreCliT )->cCodCaj )
            ( dbfPreCliT )->cCodCaj := "000"
         end if

         if Empty( ( dbfPreCliT )->cCodGrp )
            ( dbfPreCliT )->cCodGrp := RetGrpCli( ( dbfPreCliT )->cCodCli, dbfClient )
         end if

         /*
         Rellenamos los campos de totales--------------------------------------
         */

         if ( dbfPreCliT )->nTotPre == 0 .and. dbLock( dbfPreCliT )

            aTotPre                 := aTotPreCli( ( dbfPreCliT )->cSerPre + Str( ( dbfPreCliT )->nNumPre ) + ( dbfPreCliT )->cSufPre, dbfPreCliT, dbfPreCliL, dbfIva, dbfDiv, dbfFPago, ( dbfPreCliT )->cDivPre )

            ( dbfPreCliT )->nTotNet := aTotPre[1]
            ( dbfPreCliT )->nTotIva := aTotPre[2]
            ( dbfPreCliT )->nTotReq := aTotPre[3]
            ( dbfPreCliT )->nTotPre := aTotPre[4]

            ( dbfPreCliT )->( dbUnLock() )

         end if

         ( dbfPreCliT )->( dbSkip() )

      end while

   ( dbfPreCliT )->( ordSetFocus( 1 ) )

   // Lineas ------------------------------------------------------------------

   ( dbfPreCliL )->( ordSetFocus( 0 ) )
   ( dbfPreCliL )->( dbGoTop() )

   while !( dbfPreCliL )->( eof() )

      if Empty( ( dbfPreCliL )->cSufPre )
         ( dbfPreCliL )->cSufPre := "00"
      end if

      if Empty( ( dbfPreCliL )->cLote ) .and. !Empty( ( dbfPreCliL )->nLote )
         ( dbfPreCliL )->cLote   := AllTrim( Str( ( dbfPreCliL )->nLote ) )
      end if

      if ( dbfPreCliL )->lIvaLin       != RetFld( ( dbfPreCliL )->cSerPre + Str( ( dbfPreCliL )->nNumPre ) + ( dbfPreCliL )->cSufPre, dbfPreCliT, "lIvaInc" )
         ( dbfPreCliL )->lIvaLin       := RetFld( ( dbfPreCliL )->cSerPre + Str( ( dbfPreCliL )->nNumPre ) + ( dbfPreCliL )->cSufPre, dbfPreCliT, "lIvaInc" )
      end if

      if !Empty( ( dbfPreCliL )->cRef ) .and. Empty( ( dbfPreCliL )->cCodFam )
         ( dbfPreCliL )->cCodFam       := RetFamArt( ( dbfPreCliL )->cRef, dbfArticulo )
      end if

      if Empty( ( dbfPreCliL )->cAlmLin )
         ( dbfPreCliL )->cAlmLin       := RetFld( ( dbfPreCliL )->cSerPre + Str( ( dbfPreCliL )->nNumPre ) + ( dbfPreCliL )->cSufPre, dbfPreCliT, "cCodAlm" )         
      end if

      if Empty( ( dbfPreCliL )->nReq )
         ( dbfPreCliL )->nReq          := nPReq( dbfIva, ( dbfPreCliL )->nIva )
      end if

      if Empty( ( dbfPreCliL )->nPosPrint )
         ( dbfPreCliL )->nPosPrint     := ( dbfPreCliL )->nNumLin
      end if

      if ( dbfPreCliL )->nRegIva != RetFld( ( dbfPreCliL )->cSerPre + Str( ( dbfPreCliL )->nNumPre ) + ( dbfPreCliL )->cSufPre, dbfPreCliT, "nRegIva" )
         if dbLock( dbfPreCliL )
            ( dbfPreCliL )->nRegIva := RetFld( ( dbfPreCliL )->cSerPre + Str( ( dbfPreCliL )->nNumPre ) + ( dbfPreCliL )->cSufPre, dbfPreCliT, "nRegIva" )
            ( dbfPreCliL )->( dbUnlock() )
         end if
      end if

      ( dbfPreCliL )->( dbSkip() )

      SysRefresh()

   end while

   ( dbfPreCliL )->( ordSetFocus( 1 ) )

   // Lineas ------------------------------------------------------------------

   ( dbfPreCliI )->( ordSetFocus( 0 ) )
   ( dbfPreCliI )->( dbGoTop() )

      while !( dbfPreCliI )->( eof() )

         if Empty( ( dbfPreCliI )->cSufPre )
            ( dbfPreCliI )->cSufPre := "00"
         end if

         ( dbfPreCliI )->( dbSkip() )

         SysRefresh()

      end while

   ( dbfPreCliI )->( ordSetFocus( 1 ) )

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   CLOSE ( dbfPreCliT )
   CLOSE ( dbfPreCliL )
   CLOSE ( dbfPreCliI )
   CLOSE ( dbfArticulo)
   CLOSE ( dbfFamilia )
   CLOSE ( dbfIva     )
   CLOSE ( dbfDiv     )
   CLOSE ( dbfFPago   )
   CLOSE ( dbfClient  )

return nil

//------------------------------------------------------------------------//

Function EdtIva( oColumn, uVal, nIvaAnt, dbfTmpLin, dbfIva, oBrw )

   local nRec        := ( dbfTmpLin )->( Recno() )

   if Valtype( uVal ) != "N"
      uVal           := Val( uVal )
   end if

   if uVal != nIvaAnt

      if lTiva( dbfIva, uVal )

         /*
         Si tiene filtrado los escandallos, le quitamos el filtro--------------
         */

         if !lShwKit()
            ( dbfTmpLin )->( dbClearFilter() )
         end if

         ( dbfTmpLin )->( dbGoTop() )

         while !( dbfTmpLin )->( eof() )

            if ( dbfTmpLin )->nIva == nIvaAnt
               ( dbfTmpLin )->nIva := uVal
               ( dbfTmpLin )->nReq := nPorcentajeRE( dbfIva, uVal )
            end if

            ( dbfTmpLin )->( dbSkip() )

         end while

         /*
         Volvemos a ponerle el filtro para que no muestre los escandallos------
         */

         if !lShwKit()
            ( dbfTmpLin )->( dbSetFilter( {|| ! Field->lKitChl }, "!lKitChl" ) )
         end if

         ( dbfTmpLin )->( dbGoTo( nRec ) )

      end if

      oBrw:Refresh()

   end if

return .t.

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS TPresupuestosClientesSenderReciver FROM TSenderReciverItem

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
   local cPreCliT
   local dbfPreCliL
   local dbfPreCliI
   local tmpPreCliT
   local tmpPreCliL
   local tmpPreCliI
   local cFileName

   if ::oSender:lServer
      cFileName         := "PreCli" + StrZero( ::nGetNumberToSend(), 6 ) + ".All"
   else
      cFileName         := "PreCli" + StrZero( ::nGetNumberToSend(), 6 ) + "." + RetSufEmp()
   end if

   ::oSender:SetText( "Enviando presupuestos de clientes" )

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   USE ( cPatEmp() + "PreCliT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PreCliT", @cPreCliT ) )
   SET ADSINDEX TO ( cPatEmp() + "PreCliT.Cdx" ) ADDITIVE

   USE ( cPatEmp() + "PreCliL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PreCliL", @dbfPreCliL ) )
   SET ADSINDEX TO ( cPatEmp() + "PreCliL.CDX" ) ADDITIVE

   USE ( cPatEmp() + "PreCliI.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PreCliI", @dbfPreCliI ) )
   SET ADSINDEX TO ( cPatEmp() + "PreCliI.CDX" ) ADDITIVE

   // Creamos todas las bases de datos relacionadas 

   mkPreCli( cPatSnd() )

   USE ( cPatSnd() + "PreCliT.DBF" ) NEW VIA ( cLocalDriver() ) SHARED ALIAS ( cCheckArea( "PreCliT", @tmpPreCliT ) )
   SET INDEX TO ( cPatSnd() + "PreCliT.Cdx" ) ADDITIVE

   USE ( cPatSnd() + "PreCliL.DBF" ) NEW VIA ( cLocalDriver() ) SHARED ALIAS ( cCheckArea( "PreCliL", @tmpPreCliL ) )
   SET INDEX TO ( cPatSnd() + "PreCliL.CDX" ) ADDITIVE

   USE ( cPatSnd() + "PreCliI.DBF" ) NEW VIA ( cLocalDriver() ) SHARED ALIAS ( cCheckArea( "PreCliI", @tmpPreCliI ) )
   SET INDEX TO ( cPatSnd() + "PreCliI.CDX" ) ADDITIVE

   if !empty( ::oSender:oMtr )
      ::oSender:oMtr:nTotal := ( cPreCliT )->( LastRec() )
   end if

   while !( cPreCliT )->( eof() )

      if ( cPreCliT )->lSndDoc

         lSnd  := .t.

         dbPass( cPreCliT, tmpPreCliT, .t. )
         ::oSender:SetText( ( cPreCliT )->cSerPre + "/" + AllTrim( Str( ( cPreCliT )->nNumPre ) ) + "/" + AllTrim( ( cPreCliT )->cSufPre ) + "; " + Dtoc( ( cPreCliT )->dFecPre ) + "; " + AllTrim( ( cPreCliT )->cCodCli ) + "; " + ( cPreCliT )->cNomCli )

         if ( dbfPreCliL )->( dbSeek( ( cPreCliT )->CSERPre + Str( ( cPreCliT )->NNUMPre ) + ( cPreCliT )->CSUFPre ) )
            while ( ( dbfPreCliL )->cSerPre + Str( ( dbfPreCliL )->NNUMPre ) + ( dbfPreCliL )->CSUFPre ) == ( ( cPreCliT )->CSERPre + Str( ( cPreCliT )->NNUMPre ) + ( cPreCliT )->CSUFPre ) .AND. !( dbfPreCliL )->( eof() )
               dbPass( dbfPreCliL, tmpPreCliL, .t. )
               ( dbfPreCliL )->( dbSkip() )
            end do
         end if

         if ( dbfPreCliI )->( dbSeek( ( cPreCliT )->cSerPre + Str( ( cPreCliT )->nNumPre ) + ( cPreCliT )->cSufPre ) )
            while ( ( dbfPreCliI )->cSerPre + Str( ( dbfPreCliI )->nNumPre ) + ( dbfPreCliI )->cSufPre ) == ( ( cPreCliT )->cSerPre + Str( ( cPreCliT )->nNumPre ) + ( cPreCliT )->cSufPre ) .AND. !( dbfPreCliI )->( eof() )
               dbPass( dbfPreCliI, tmpPreCliI, .t. )
               ( dbfPreCliI )->( dbSkip() )
            end do
         end if

      end if

      ( cPreCliT )->( dbSkip() )

      if !Empty( ::oSender:oMtr )
         ::oSender:oMtr:Set( ( cPreCliT )->( OrdKeyNo() ) )
      end if

   END DO

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   CLOSE ( cPreCliT )
   CLOSE ( dbfPreCliL )
   CLOSE ( dbfPreCliI )
   CLOSE ( tmpPreCliT )
   CLOSE ( tmpPreCliL )
   CLOSE ( tmpPreCliI )

   if lSnd

      /*
      Comprimir los archivos---------------------------------------------------
      */

      ::oSender:SetText( "Comprimiendo presupuestos a clientes" )

      if ::oSender:lZipData( cFileName )
         ::oSender:SetText( "Ficheros comprimidos" )
      else
         ::oSender:SetText( "ERROR al crear fichero comprimido" )
      end if

   else

      ::oSender:SetText( "No hay presupuestos a clientes para enviar" )

   end if

Return ( Self )

//----------------------------------------------------------------------------//

Method RestoreData()

   local oBlock
   local oError
   local cPreCliT

   if ::lSuccesfullSend

      /*
      Retorna el valor anterior
      */

      oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
      BEGIN SEQUENCE

      USE ( cPatEmp() + "PreCliT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PreCliT", @cPreCliT ) )
      SET ADSINDEX TO ( cPatEmp() + "PreCliT.Cdx" ) ADDITIVE
      
      ( cPreCliT )->( OrdSetFocus( "lSndDoc" ) )

      while ( cPreCliT )->( dbSeek( .t. ) ) .and. !( cPreCliT )->( eof() )
         if ( cPreCliT )->( dbRLock() )
            ( cPreCliT )->lSndDoc := .f.
            ( cPreCliT )->( dbRUnlock() )
         end if
      end do

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

      CLOSE ( cPreCliT )

   end if

Return ( Self )

//----------------------------------------------------------------------------//

Method SendData()

   local cFileName

   if ::oSender:lServer
      cFileName         := "PreCli" + StrZero( ::nGetNumberToSend(), 6 ) + ".All"
   else
      cFileName         := "PreCli" + StrZero( ::nGetNumberToSend(), 6 ) + "." + RetSufEmp()
   end if

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

Method ReciveData()

   local n
   local aExt

   aExt     := ::oSender:aExtensions()

   /*
   Recibirlo de internet
   */

   ::oSender:SetText( "Recibiendo presupuestos de clientes" )

   for n := 1 to len( aExt )
      ::oSender:GetFiles( "PreCli*." + aExt[ n ], cPatIn() )
   next

   ::oSender:SetText( "Presupuestos de clientes recibidos" )

Return Self

//----------------------------------------------------------------------------//

Method Process()

   local m
   local oBlock
   local oError
   local cPreCliT
   local dbfPreCliL
   local dbfPreCliI
   local dbfPreClid
   local tmpPreCliT
   local tmpPreCliL
   local tmpPreCliI
   local tmpPreCliD
   local aFiles      := Directory( cPatIn() + "PreCli*.*" )

   for m := 1 to len( aFiles )

      ::oSender:SetText( "Procesando fichero : " + aFiles[ m, 1 ] )

      oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
      BEGIN SEQUENCE

         if ::oSender:lUnZipData( cPatIn() + aFiles[ m, 1 ] )

            /*
            Ficheros temporales
            */

            if lExistTable( cPatSnd() + "PreCliT.DBF", cLocalDriver() )   .and.;
               lExistTable( cPatSnd() + "PreCliL.DBF", cLocalDriver() )   .and.;
               lExistTable( cPatSnd() + "PreCliI.DBF", cLocalDriver() )

               USE ( cPatSnd() + "PreCliT.DBF" ) NEW VIA ( cLocalDriver() )READONLY ALIAS ( cCheckArea( "PreCliT", @tmpPreCliT ) )
               SET INDEX TO ( cPatSnd() + "PreCliT.Cdx" ) ADDITIVE

               USE ( cPatSnd() + "PreCliL.DBF" ) NEW VIA ( cLocalDriver() )READONLY ALIAS ( cCheckArea( "PreCliL", @tmpPreCliL ) )
               SET INDEX TO ( cPatSnd() + "PreCliL.CDX" ) ADDITIVE

               USE ( cPatSnd() + "PreCliI.DBF" ) NEW VIA ( cLocalDriver() )READONLY ALIAS ( cCheckArea( "PreCliI", @tmpPreCliI ) )
               SET INDEX TO ( cPatSnd() + "PreCliI.CDX" ) ADDITIVE

               USE ( cPatSnd() + "PreCliD.DBF" ) NEW VIA ( cLocalDriver() )READONLY ALIAS ( cCheckArea( "PreCliD", @tmpPreCliD ) )
               SET INDEX TO ( cPatSnd() + "PreCliD.Cdx" ) ADDITIVE

               USE ( cPatEmp() + "PreCliT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PreCliT", @cPreCliT ) )
               SET ADSINDEX TO ( cPatEmp() + "PreCliT.Cdx" ) ADDITIVE

               USE ( cPatEmp() + "PreCliL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PreCliL", @dbfPreCliL ) )
               SET ADSINDEX TO ( cPatEmp() + "PreCliL.CDX" ) ADDITIVE

               USE ( cPatEmp() + "PreCliI.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PreCliI", @dbfPreCliI ) )
               SET ADSINDEX TO ( cPatEmp() + "PreCliI.CDX" ) ADDITIVE

               USE ( cPatEmp() + "PreCliD.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PreCliD", @dbfPreCliD ) )
               SET ADSINDEX TO ( cPatEmp() + "PreCliD.Cdx" ) ADDITIVE

               while !( tmpPreCliT )->( eof() )

                  if lValidaOperacion( ( tmpPreCliT )->dFecPre, .f. ) .and. ;
                     !( cPreCliT )->( dbSeek( ( tmpPreCliT )->cSerPre + Str( ( tmpPreCliT )->nNumPre ) + ( tmpPreCliT )->cSufPre ) )

                     dbPass( tmpPreCliT, cPreCliT, .t. )

                     if dbLock( cPreCliT )
                        ( cPreCliT )->lSndDoc := .f.
                        ( cPreCliT )->( dbUnLock() )
                     end if
                     
                     ::oSender:SetText( "Añadido : " + ( tmpPreCliL )->cSerPre + "/" + AllTrim( Str( ( tmpPreCliL )->nNumPre ) ) + "/" + AllTrim( ( tmpPreCliL )->cSufPre ) + "; " + Dtoc( ( tmpPreCliT )->dFecPre ) + "; " + AllTrim( ( tmpPreCliT )->cCodCli ) + "; " + ( tmpPreCliT )->cNomCli )

                     if ( tmpPreCliL )->( dbSeek( ( tmpPreCliT )->cSerPre + Str( ( tmpPreCliT )->nNumPre ) + ( tmpPreCliT )->cSufPre ) )
                        do while ( tmpPreCliL )->cSerPre + Str( ( tmpPreCliL )->nNumPre ) + ( tmpPreCliL )->cSufPre == ( tmpPreCliT )->cSerPre + Str( ( tmpPreCliT )->nNumPre ) + ( tmpPreCliT )->cSufPre .and. !( tmpPreCliL )->( eof() )
                           dbPass( tmpPreCliL, dbfPreCliL, .t. )
                           ( tmpPreCliL )->( dbSkip() )
                        end do
                     end if

                     if ( tmpPreCliI )->( dbSeek( ( tmpPreCliT )->cSerPre + Str( ( tmpPreCliT )->nNumPre ) + ( tmpPreCliT )->cSufPre ) )
                        do while ( tmpPreCliI )->cSerPre + Str( ( tmpPreCliI )->nNumPre ) + ( tmpPreCliI )->cSufPre == ( tmpPreCliT )->cSerPre + Str( ( tmpPreCliT )->nNumPre ) + ( tmpPreCliT )->cSufPre .and. !( tmpPreCliI )->( eof() )
                           dbPass( tmpPreCliI, dbfPreCliI, .t. )
                           ( tmpPreCliI )->( dbSkip() )
                        end do
                     end if

                     if ( tmpPreCliD )->( dbSeek( ( tmpPreCliT )->cSerPre + Str( ( tmpPreCliT )->nNumPre ) + ( tmpPreCliT )->cSufPre ) )
                        do while ( tmpPreCliD )->cSerPre + Str( ( tmpPreCliD )->nNumPre ) + ( tmpPreCliD )->cSufPre == ( tmpPreCliT )->cSerPre + Str( ( tmpPreCliT )->nNumPre ) + ( tmpPreCliT )->cSufPre .and. !( tmpPreCliD )->( eof() )
                           dbPass( tmpPreCliD, dbfPreCliD, .t. )
                           ( tmpPreCliD )->( dbSkip() )
                        end do
                     end if

                  else

                     ::oSender:SetText( "Desestimado : " + ( tmpPreCliL )->cSerPre + "/" + AllTrim( Str( ( tmpPreCliL )->nNumPre ) ) + "/" + AllTrim( ( tmpPreCliL )->cSufPre ) + "; " + Dtoc( ( tmpPreCliT )->dFecPre ) + "; " + AllTrim( ( tmpPreCliT )->cCodCli ) + "; " + ( tmpPreCliT )->cNomCli )

                  end if

                  ( tmpPreCliT )->( dbSkip() )

               end do

               CLOSE ( cPreCliT )
               CLOSE ( dbfPreCliL )
               CLOSE ( dbfPreCliI )
               CLOSE ( tmpPreCliT )
               CLOSE ( tmpPreCliL )
               CLOSE ( tmpPreCliI )

               ::oSender:AppendFileRecive( aFiles[ m, 1 ] )

            else

               ::oSender:SetText( "Faltan ficheros" )

               if !lExistTable( cPatSnd() + "PreCliT.DBF", cLocalDriver() )
                  ::oSender:SetText( "Falta " + cPatSnd() + "PreCliT.DBF" )
               end if

               if !lExistTable( cPatSnd() + "PreCliL.DBF", cLocalDriver() )
                  ::oSender:SetText( "Falta " + cPatSnd() + "PreCliL.DBF" )
               end if

               if !lExistTable( cPatSnd() + "PreCliI.DBF", cLocalDriver() )
                  ::oSender:SetText( "Falta " + cPatSnd() + "PreCliL.DBF" )
               end if

               if !lExistTable( cPatSnd() + "PreCliD.DBF", cLocalDriver() )
                  ::oSender:SetText( "Falta " + cPatSnd() + "PreCliD.DBF" )
               end if

            end if

            fErase( cPatSnd() + "PreCliT.DBF" )
            fErase( cPatSnd() + "PreCliL.DBF" )
            fErase( cPatSnd() + "PreCliI.DBF" )
            fErase( cPatSnd() + "PreCliD.DBF" )

         else

            ::oSender:SetText( "Error al descomprimir los ficheros" )

         end if

      RECOVER USING oError

         CLOSE ( cPreCliT )
         CLOSE ( dbfPreCliL )
         CLOSE ( dbfPreCliI )
         CLOSE ( dbfPreCliD )
         CLOSE ( tmpPreCliT )
         CLOSE ( tmpPreCliL )
         CLOSE ( tmpPreCliI )
         CLOSE ( tmpPreCliD )

         ::oSender:SetText( "Error procesando fichero " + aFiles[ m, 1 ] )
         ::oSender:SetText( ErrorMessage( oError ) )

      END SEQUENCE

      ErrorBlock( oBlock )

   next

Return Self

//----------------------------------------------------------------------------//

Function AppPreCli( cCodCli, cCodArt, lOpenBrowse )

   local nLevel         := Auth():Level( _MENUITEM_ )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) == 0 .or. nAnd( nLevel, ACC_APPD ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if lOpenBrowse

      if PreCli( nil, nil, cCodCli, cCodArt )
         oWndBrw:RecAdd()
      end if

   else

      if OpenFiles( .t. )
         WinAppRec( nil, bEdtRec, D():PresupuestosClientes( nView ), cCodCli, cCodArt )
         CloseFiles()
      end if

   end if

RETURN .t.

//----------------------------------------------------------------------------//

FUNCTION EdtPreCli( cNumPre, lOpenBrowse )

   local nLevel         := Auth():Level( _MENUITEM_ )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) == 0 .or. nAnd( nLevel, ACC_EDIT ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if lOpenBrowse

      if PreCli()
         if dbSeekInOrd( cNumPre, "nNumPre", D():PresupuestosClientes( nView ) )
            oWndBrw:RecEdit()
         else
            MsgStop( "No se encuentra presupuesto" )
         end if
      end if

   else

      if OpenFiles( .t. )

         if dbSeekInOrd( cNumPre, "nNumPre", D():PresupuestosClientes( nView ) )
            WinEdtRec( nil, bEdtRec, D():PresupuestosClientes( nView ) )
         end if

         CloseFiles()

      end if

   end if

Return .t.

//----------------------------------------------------------------------------//

FUNCTION ZooPreCli( cNumPre, lOpenBrowse, lPda )

   local nLevel         := Auth():Level( _MENUITEM_ )

   DEFAULT lOpenBrowse  := .f.
   DEFAULT lPda         := .f.

   if nAnd( nLevel, 1 ) == 0 .or. nAnd( nLevel, ACC_ZOOM ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if lOpenBrowse

      if PreCli()
         if dbSeekInOrd( cNumPre, "nNumPre", D():PresupuestosClientes( nView ) )
            oWndBrw:RecZoom()
         else
            MsgStop( "No se encuentra presupuesto" )
         end if
      end if

   else

      if OpenFiles( .t. )

         if dbSeekInOrd( cNumPre, "nNumPre", D():PresupuestosClientes( nView ) )
            WinZooRec( nil, bEdtRec, D():PresupuestosClientes( nView ) )
         end if

         CloseFiles()

      end if

   end if

Return .t.

//----------------------------------------------------------------------------//

FUNCTION DelPreCli( cNumPre, lOpenBrowse )

   local nLevel         := Auth():Level( _MENUITEM_ )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) == 0 .or. nAnd( nLevel, ACC_DELE ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if lOpenBrowse

      if PreCli()
         if dbSeekInOrd( cNumPre, "nNumPre", D():PresupuestosClientes( nView ) )
            WinDelRec( nil, D():PresupuestosClientes( nView ), {|| QuiPreCli() } )
         else
            MsgStop( "No se encuentra presupuesto" )
         end if
      end if

   else

      if OpenFiles( .t. )

         if dbSeekInOrd( cNumPre, "nNumPre", D():PresupuestosClientes( nView ) )
            WinDelRec( nil, D():PresupuestosClientes( nView ), {|| QuiPreCli() } )
         end if

         CloseFiles()

      end if

   end if

Return .t.

//----------------------------------------------------------------------------//

FUNCTION PrnPreCli( cNumPre, lOpenBrowse )

   local nLevel         := Auth():Level( _MENUITEM_ )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) == 0 .or. nAnd( nLevel, ACC_IMPR ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if lOpenBrowse

      if PreCli()
         if dbSeekInOrd( cNumPre, "nNumPre", D():PresupuestosClientes( nView ) )
            ImprimirSeriesPresupuestosClientes( IS_PRINTER, .t. )
            //GenPreCli( IS_PRINTER )
         else
            MsgStop( "No se encuentra presupuesto" )
         end if
      end if

   else

      if OpenFiles( .t. )
         if dbSeekInOrd( cNumPre, "nNumPre", D():PresupuestosClientes( nView ) )
            ImprimirSeriesPresupuestosClientes( IS_PRINTER, .t. )
            //GenPreCli( IS_PRINTER )
         else
            MsgStop( "No se encuentra presupuesto" )
         end if
         CloseFiles()
      end if

   end if

Return .t.

//----------------------------------------------------------------------------//

FUNCTION VisPreCli( cNumPre, lOpenBrowse )

   local nLevel         := Auth():Level( _MENUITEM_ )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) == 0 .or. nAnd( nLevel, ACC_IMPR ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if lOpenBrowse

      if PreCli()
         if dbSeekInOrd( cNumPre, "nNumPre", D():PresupuestosClientes( nView ) )
            ImprimirSeriesPresupuestosClientes( IS_SCREEN, .t. )
            //GenPreCli( IS_SCREEN )
         else
            MsgStop( "No se encuentra presupuesto" )
         end if
      end if

   else

      if OpenFiles( .t. )

         if dbSeekInOrd( cNumPre, "nNumPre", D():PresupuestosClientes( nView ) )
            ImprimirSeriesPresupuestosClientes( IS_SCREEN, .t. )
            //GenPreCli( IS_SCREEN )
         end if

         CloseFiles()

      end if

   end if

Return .t.

//----------------------------------------------------------------------------//

FUNCTION QuiPreCli()

   local nOrdDet
   local nOrdInc
   local nOrdDoc
   local nOrdEst

   if ( D():PresupuestosClientes( nView ) )->lCloPre .and. !oUser():lAdministrador()
      msgStop( "Solo puede eliminar presupuestos cerrados los administradores." )
      Return .f.
   end if

   nOrdDet        := ( D():PresupuestosClientesLineas( nView ) )->( OrdSetFocus( "nNumPre" ) )
   nOrdInc        := ( dbfPreCliI )->( OrdSetFocus( "nNumPre" ) )
   nOrdDoc        := ( dbfPreCliD )->( OrdSetFocus( "nNumPre" ) )
   nOrdEst        := ( D():PresupuestosClientesSituaciones( nView ) )->( OrdSetFocus( "nNumPre" ) ) 


   /*
   Detalle---------------------------------------------------------------------
   */

   while ( D():PresupuestosClientesLineas( nView ) )->( dbSeek( ( D():PresupuestosClientes( nView ) )->cSerPre + Str( ( D():PresupuestosClientes( nView ) )->nNumPre ) + ( D():PresupuestosClientes( nView )  )->cSufPre ) ) .and. !( D():PresupuestosClientesLineas( nView ) )->( eof() )
      if dbLock( D():PresupuestosClientesLineas( nView ) )
         ( D():PresupuestosClientesLineas( nView ) )->( dbDelete() )
         ( D():PresupuestosClientesLineas( nView ) )->( dbUnLock() )
      end if
   end while

   /*
   Documentos------------------------------------------------------------------
   */

   while ( dbfPreCliI )->( dbSeek( ( D():PresupuestosClientes( nView ) )->cSerPre + Str( ( D():PresupuestosClientes( nView ) )->nNumPre ) + ( D():PresupuestosClientes( nView )  )->cSufPre ) ) .and. !( dbfPreCliI )->( eof() )
      if dbLock( dbfPreCliI )
         ( dbfPreCliI )->( dbDelete() )
         ( dbfPreCliI )->( dbUnLock() )
      end if
   end while

   /*
   Incidencias-----------------------------------------------------------------
   */

   while ( dbfPreCliD )->( dbSeek( ( D():PresupuestosClientes( nView ) )->cSerPre + Str( ( D():PresupuestosClientes( nView ) )->nNumPre ) + ( D():PresupuestosClientes( nView )  )->cSufPre ) ) .and. !( dbfPreCliD )->( eof() )
      if dbLock( dbfPreCliD )
         ( dbfPreCliD )->( dbDelete() )
         ( dbfPreCliD )->( dbUnLock() )
      end if
   end while

   /*
   Situaciones--------------------------------------------------------
   */

   while ( D():PresupuestosClientesSituaciones( nView ) )->( dbSeek( ( D():PresupuestosClientes( nView ) )->cSerPre + Str( ( D():PresupuestosClientes( nView ) )->nNumPre ) + ( D():PresupuestosClientes( nView )  )->cSufPre ) ) .and. !( D():PresupuestosClientesSituaciones( nView ) )->( eof() )
      if dbLock( D():PresupuestosClientesSituaciones( nView ) )
         ( D():PresupuestosClientesSituaciones( nView ) )->( dbDelete() )
         ( D():PresupuestosClientesSituaciones( nView ) )->( dbUnLock() )
      end if
   end while



   ( D():PresupuestosClientesLineas( nView ) )->( OrdSetFocus( nOrdDet ) )
   ( dbfPreCliI )->( OrdSetFocus( nOrdInc ) )
   ( dbfPreCliD )->( OrdSetFocus( nOrdDoc ) )
   ( D():PresupuestosClientesSituaciones( nView ) )->( OrdSetFocus( nOrdEst ) )


Return .t.

//---------------------------------------------------------------------------//

Function EndDesgPnt( cCodArt, nTarifa, oPreDiv, oImporte, dbfArticulo, nDouDiv )

   local nCosto   := oImporte:VarGet()
   local nRec     := ( D():Articulos( nView ) )->( RecNo() )
   local nNewPre

   if ( dbfArticulo )->( dbSeek( cCodArt ) )

      do case
         case nTarifa == 1
            nNewPre := CalPre( if( ( dbfArticulo )->nBnfSbr1 <= 1, .t., .f. ), nCosto, .t., ( dbfArticulo )->Benef1, ( dbfArticulo )->TipoIva, nil, nil, nDouDiv, ( dbfArticulo )->cCodImp, nil )
         case nTarifa == 2
            nNewPre := CalPre( if( ( dbfArticulo )->nBnfSbr2 <= 1, .t., .f. ), nCosto, .t., ( dbfArticulo )->Benef2, ( dbfArticulo )->TipoIva, nil, nil, nDouDiv, ( dbfArticulo )->cCodImp, nil )
         case nTarifa == 3
            nNewPre := CalPre( if( ( dbfArticulo )->nBnfSbr3 <= 1, .t., .f. ), nCosto, .t., ( dbfArticulo )->Benef3, ( dbfArticulo )->TipoIva, nil, nil, nDouDiv, ( dbfArticulo )->cCodImp, nil )
         case nTarifa == 4
            nNewPre := CalPre( if( ( dbfArticulo )->nBnfSbr4 <= 1, .t., .f. ), nCosto, .t., ( dbfArticulo )->Benef4, ( dbfArticulo )->TipoIva, nil, nil, nDouDiv, ( dbfArticulo )->cCodImp, nil )
         case nTarifa == 5
            nNewPre := CalPre( if( ( dbfArticulo )->nBnfSbr5 <= 1, .t., .f. ), nCosto, .t., ( dbfArticulo )->Benef5, ( dbfArticulo )->TipoIva, nil, nil, nDouDiv, ( dbfArticulo )->cCodImp, nil )
         case nTarifa == 6
            nNewPre := CalPre( if( ( dbfArticulo )->nBnfSbr6 <= 1, .t., .f. ), nCosto, .t., ( dbfArticulo )->Benef6, ( dbfArticulo )->TipoIva, nil, nil, nDouDiv, ( dbfArticulo )->cCodImp, nil )
      end case

   end if

   oPreDiv:cText( nNewPre )

   oPreDiv:Refresh()

   ( dbfArticulo )->( dbGoTo( nRec ) )

Return ( .t. )

//---------------------------------------------------------------------------//

Function ExpAlmacen( cCodAlm, dbfTmpLin, oBrw )

   local nRec  := ( dbfTmpLin )->( Recno() )

   ( dbfTmpLin )->( dbGoTop() )
   while !( dbfTmpLin )->( eof() )

      if ( dbfTmpLin )->cAlmLin != cCodAlm
         ( dbfTmpLin )->cAlmLin := cCodAlm
      end if

      ( dbfTmpLin )->( dbSkip() )

   end while

   ( dbfTmpLin )->( dbGoTo( nRec ) )

   oBrw:Refresh()

Return nil

//---------------------------------------------------------------------------//

Function changeAgentPercentageInAllLines( nComAge, dbfTmpLin, oBrw )

   local nRec  := ( dbfTmpLin )->( Recno() )

   ( dbfTmpLin )->( dbGoTop() )
   while !( dbfTmpLin )->( eof() )

      if ( dbfTmpLin )->nComAge != nComAge
         ( dbfTmpLin )->nComAge := nComAge
      end if

      ( dbfTmpLin )->( dbSkip() )

   end while

   ( dbfTmpLin )->( dbGoTo( nRec ) )

   oBrw:Refresh()

Return nil

//---------------------------------------------------------------------------//

Function ChangeTarifaCabecera( nNumTar, dbfTmpLin, oBrw )

   local nRec

   if ( nNumTar >= 1 .and. nNumTar <= 6 )

      if ( nNumTar != nTarifaPrecio .and. ( dbfTmpLin )->( LastRec() ) > 0 )

         CursorWait()

         nRec           := ( dbfTmpLin )->( Recno() )

         ( dbfTmpLin )->( dbGoTop() )
         while !( dbfTmpLin )->( eof() )

            if ( dbfTmpLin )->nTarLin != nNumTar
               ( dbfTmpLin )->nTarLin := nNumTar
            end if

            ( dbfTmpLin )->( dbSkip() )

         end while

         ( dbfTmpLin )->( dbGoTo( nRec ) )

         oBrw:Refresh()

         nTarifaPrecio  := nNumTar

         CursorWE()

      end if

   end if

Return .t.

//---------------------------------------------------------------------------//

Function InitTarifaCabecera( nNumTar )

   nTarifaPrecio  := nNumTar

Return .t.

//---------------------------------------------------------------------------//

Function cFrasePublicitaria( cDbfCol )

   local cTxtFra  := ""

Return ( cTxtFra )

//---------------------------------------------------------------------------//

FUNCTION IsPreCli( cPath )

   DEFAULT cPath  := cPatEmp()

   if !lExistTable( cPath + "PreCliT.Dbf" )
      dbCreate( cPath + "PreCliT.Dbf", aSqlStruct( aItmPreCli() ), cDriver() )
   end if

   if !lExistTable( cPath + "PreCliL.Dbf" )
      dbCreate( cPath + "PreCliL.Dbf", aSqlStruct( aColPreCli() ), cDriver() )
   end if

   if !lExistTable( cPath + "PreCliI.Dbf" )
      dbCreate( cPath + "PreCliI.Dbf", aSqlStruct( aIncPreCli() ), cDriver() )
   end if

   if !lExistTable( cPath + "PreCliD.Dbf" )
      dbCreate( cPath + "PreCliD.Dbf", aSqlStruct( aPreCliDoc() ), cDriver() )
   end if

   if !lExistTable( cPath + "PreCliE.Dbf" )
      dbCreate( cPath + "PreCliE.Dbf", aSqlStruct( aPreCliEst() ), cDriver() )
   end if

   if !lExistIndex( cPath + "PreCliT.Cdx" ) .or. ;
      !lExistIndex( cPath + "PreCliL.Cdx" ) .or. ;
      !lExistIndex( cPath + "PreCliI.Cdx" ) .or. ;
      !lExistTable( cPath + "PreCliD.Cdx" ) .or. ;
      !lExistTable( cPath + "PreCliE.Cdx" )

      rxPreCli( cPath )

   end if

Return ( nil )

//---------------------------------------------------------------------------//

Function DesignReportPreCli( oFr, dbfDoc )

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
                                                   "   CallHbFunc('nTotPreCli');"                              + Chr(13) + Chr(10) + ;
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
         oFr:SetObjProperty(  "MasterData",  "DataSet", "Presupuestos" )

         oFr:AddBand(         "DetalleColumnas",   "MainPage", frxDetailData  )
         oFr:SetProperty(     "DetalleColumnas",   "Top", 230 )
         oFr:SetProperty(     "DetalleColumnas",   "Height", 28 )
         oFr:SetObjProperty(  "DetalleColumnas",   "DataSet", "Lineas de presupuestos" )
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

Function mailReportPreCli( cCodigoDocumento )

Return ( printReportPreCli( IS_MAIL, 1, prnGetName(), cCodigoDocumento ) )

//---------------------------------------------------------------------------//

Static Function printReportPreCli( nDevice, nCopies, cPrinter, cCodigoDocumento )

   local oFr

   local cFilePdf              := cPatTmp() + "PresupuestoCliente" + StrTran( ( D():PresupuestosClientes( nView ) )->cSerPre + Str( ( D():PresupuestosClientes( nView ) )->nNumPre ) + ( D():PresupuestosClientes( nView ) )->cSufPre, " ", "" ) + ".Pdf"
   local nOrd

   DEFAULT nDevice            := IS_SCREEN
   DEFAULT nCopies            := 1
   DEFAULT cPrinter           := PrnGetName()
   DEFAULT cCodigoDocumento   := cFormatoPresupuestosClientes()   

   if empty( cCodigoDocumento )
      msgStop( "El código del documento esta vacio" )
      Return ( nil )
   end if 

   SysRefresh()

   nOrd                 := ( D():PresupuestosClientesLineas( nView ) )->( ordSetFocus( "nPosPrint" ) )

   oFr                  := frReportManager():New()

   oFr:LoadLangRes( "Spanish.Xml" )

   oFr:SetIcon( 1 )

   oFr:SetTitle( "Diseñador de documentos" )

   /*
   Manejador de eventos--------------------------------------------------------
   */

   oFr:SetEventHandler( "Designer", "OnSaveReport", {|| oFr:SaveToBlob( ( D():Documentos( nView ) )->( Select() ), "mReport" ) } )

   /*
   Zona de datos------------------------------------------------------------
   */

   DataReport( oFr )

   /*
   Cargar el informe-----------------------------------------------------------
   */

   if lMemoDocumento( cCodigoDocumento, D():Documentos( nView ) )

      oFr:LoadFromBlob( ( D():Documentos( nView ) )->( Select() ), "mReport")

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

      end case

   end if

   /*
   Destruye el diseñador-------------------------------------------------------
   */

   oFr:DestroyFr()
   
   ( D():PresupuestosClientesLineas( nView ) )->( ordSetFocus( nOrd ) )

Return ( cFilePdf )

//---------------------------------------------------------------------------//

//----------------------------------------------------------------------------//
//Funciones comunes del programa y pda
//----------------------------------------------------------------------------//

FUNCTION nRentabilidad( nImporte, nDtoAtipico, nCosto )

   if nCosto == 0
      Return ( 100 )
   end if

RETURN( ( ( ( nImporte - nDtoAtipico ) / nCosto ) - 1 ) * 100  )

//---------------------------------------------------------------------------//

FUNCTION nRentabilidadVentas( nImporte, nDtoAtipico, nCosto )

   if nImporte == 0
      Return ( 100 )
   end if

RETURN( ( 1 - Div( nCosto, ( nImporte - nDtoAtipico ) ) ) * 100  )

//----------------------------------------------------------------------------//

Function lValLine( dbfLine )

   local lVal  := .t.

   if ( dbfLine )->lControl
      Return .f.
   end if

   if ( dbfLine )->lKitArt .or. ( dbfLine )->lKitChl
      lVal     := ( dbfLine )->lKitPrc
   end if

Return ( lVal )

//---------------------------------------------------------------------------//

FUNCTION UpSerie( oGet )

   local nAsc
   local cChr
   local cSer  := oGet:VarGet()

   if Empty( cSer ) .or. cSer < "A"
      cSer     := "A"
      nAsc     := Asc( cSer )
   else
      nAsc     := Asc( cSer ) + 1
   end if

   cChr        := Chr( nAsc )

   if cChr <= "Z"
      oGet:cText( cChr )
   end if

return nil

//----------------------------------------------------------------------------//

FUNCTION DwSerie( oGet )

   local nAsc
   local cChr
   local cSer  := oGet:VarGet()

   nAsc        := Asc( cSer ) - 1
   cChr        := Chr( nAsc )

   if cChr >= "A"
      oGet:cText( cChr )
   end if

return nil

//----------------------------------------------------------------------------//

Function nLastNum( uTmpLin, cFieldName )

   local nRec
   local nNum           := 0

   DEFAULT cFieldName   := "nNumLin"

   do case
   case IsChar( uTmpLin )

      nRec              := ( uTmpLin )->( RecNo() )
      ( uTmpLin )->( dbGoTop() )

      while !( uTmpLin )->( eof() )
         nNum           := Max( nNum, ( uTmpLin )->( FieldGet( FieldPos( cFieldName ) ) ) )
         ( uTmpLin )->( dbSkip() )
      end while

      ( uTmpLin )->( dbGoTo( nRec ) )

   case IsObject( uTmpLin )

      nRec              := uTmpLin:RecNo()
      uTmpLin:GoTop()

      while !( uTmpLin:eof() )
         nNum           := Max( nNum, uTmpLin:FieldGetByName( cFieldName ) )
         uTmpLin:Skip()
      end while

      uTmpLin:GoTo( nRec )

   end case

Return ( ++nNum )

//---------------------------------------------------------------------------//

Function nCalculoPuntos( nPuntos, nValorPunto, nDtoPnt, nIncPnt )

   local nTotal   := 0

   nTotal         := nPuntos * nValorPunto
   nTotal         -= ( nTotal * nDtoPnt ) / 100

   if nIncPnt != 0
      nTotal      := nTotal + ( ( nIncPnt * nTotal ) / 100 )
   end if

Return ( nTotal )

//---------------------------------------------------------------------------//

Function cRefPrvArt( cCodArt, cCodPrv, dbfArtPrv )

   local cReferencia := ""
   local nRec        := ( dbfArtPrv )->( RecNo() )
   local nOrdAnt     := ( dbfArtPrv )->( OrdSetFocus( "cCodPrv" ) )

   if ( dbfArtPrv )->( dbSeek( cCodPrv + cCodArt ) )
      cReferencia    := AllTrim( ( dbfArtPrv )->cRefPrv )
   end if

   ( dbfArtPrv )->( OrdSetFocus( nOrdAnt ) )
   ( dbfArtPrv )->( dbGoTo( nRec ) )

Return cReferencia

//---------------------------------------------------------------------------//
//
// Devuelve el importe del descuento lineal
//

Function nTotDtoLPreCli( dbfLin, nDec, nVdv, cPorDiv )

   local nCalculo

   DEFAULT dbfLin    := D():PresupuestosClientesLineas( nView )
   DEFAULT nDec      := nDouDiv()
   DEFAULT nVdv      := 1

   nCalculo          := nDtoLPreCli( dbfLin, nDec, nVdv ) * nTotNPreCli( dbfLin )

   if nVdv != 0
      nCalculo       := nCalculo / nVdv
   end if

   nCalculo          := Round( nCalculo, nDec )

RETURN ( if( cPorDiv != nil, Trans( nCalculo, cPorDiv ), nCalculo ) )

//----------------------------------------------------------------------------//

Function sTotPreCli( cPresupuesto, dbfMaster, dbfLine, dbfIva, dbfDiv, cDivRet, lExcCnt )

   local sTotal

   nTotPreCli( cPresupuesto, dbfMaster, dbfLine, dbfIva, dbfDiv, nil, nil, cDivRet, .f., lExcCnt )

   sTotal                                 := sTotal()
   sTotal:nTotalBruto                     := nTotBrt
   sTotal:nTotalNeto                      := nTotNet
   sTotal:nTotalIva                       := nTotIva
   sTotal:aTotalIva                       := aTotIva
   sTotal:nTotalRecargoEquivalencia       := nTotReq
   sTotal:nTotalDocumento                 := nTotPre
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

Static Function cFormatoPresupuestosClientes( cSerie )

   local cFormato

   DEFAULT cSerie    := ( D():PresupuestosClientes( nView ) )->cSerPre

   cFormato          := cFormatoDocumento( cSerie, "nPreCli", D():Contadores( nView ) )

   if Empty( cFormato )
      cFormato       := cFirstDoc( "RC", D():Documentos( nView ) )
   end if

Return ( cFormato ) 

//---------------------------------------------------------------------------//   

Function DesignLabelPresupuestoClientes( oFr, cDoc )

   local oLabel
   local lOpenFiles  := empty( nView ) 

   if lOpenFiles .and. !Openfiles()
      Return .f.
   endif

   oLabel            := TLabelGeneratorPresupuestoClientes():New( nView )

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
      oFr:SetObjProperty(  "MasterData",  "DataSet",        "Lineas de presupuestos" )
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
      msgStop( memoArticulos, "procesar")
   end if

Return nil       

//---------------------------------------------------------------------------//
