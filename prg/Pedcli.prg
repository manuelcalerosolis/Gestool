#include "FiveWin.Ch"
#include "Folder.ch"
#include "Report.ch"
#include "Menu.ch"
#include "Xbrowse.ch"

#include "Factu.ch" 

#define CLR_BAR                    14197607
#define _MENUITEM_                 "01056"

/*
Definici¢n de la base de datos de pedidos a clientes
*/

#define _CSERPED                   1      //"CSERPED"
#define _NNUMPED                   2      //"NNUMPED"
#define _CSUFPED                   3      //"CSUFPED"
#define _CTURPED                   4      //"CTURPED"
#define _DFECPED                   5      //"DFECPED"
#define _CCODCLI                   6      //"CCODCLI"
#define _CNOMCLI                   7      //"CNOMCLI"
#define _CDIRCLI                   8      //"CDIRCLI"
#define _CPOBCLI                   9      //"CPOBCLI"
#define _CPRVCLI                  10      //"CPRVCLI"
#define _CPOSCLI                  11      //"CPOSCLI"
#define _CDNICLI                  12      //"CDNICLI"
#define _LMODCLI                  13      //
#define _CCODAGE                  14      //"CCODAGE"
#define _CCODOBR                  15      //"CCODOBR"
#define _CCODTAR                  16      //"CCODTAR"
#define _CCODALM                  17      //"CCODALM"
#define _CCODCAJ                  18      //"CCODCAJ"
#define _CCODPGO                  19      //"CCODPGO"
#define _CCODRUT                  20      //"CCODRUT"
#define _DFECENT                  21      //"DFECENT"
#define _NESTADO                  22      //"NESTADO"
#define _CSUPED                   23      //"CSUPED",
#define _CCONDENT                 24      //"CCONDENT
#define _MCOMENT                  25      //"MCOMENT"
#define _MOBSERV                  26      //"MOBSERV"
#define _LMAYOR                   27      //"LMAYOR",
#define _NTARIFA                  28      //"NTARIFA" 
#define _CDTOESP                  29      //"CDTOESP"
#define _NDTOESP                  30      //"NDTOESP"
#define _CDPP                     31      //"CDPP",
#define _NDPP                     32      //"NDPP",
#define _CDTOUNO                  33      //"CDTOUNO"
#define _NDTOUNO                  34      //"NDTOUNO"
#define _CDTODOS                  35      //"CDTODOS"
#define _NDTODOS                  36      //"NDTODOS"
#define _NDTOCNT                  37      //"NDTOCNT"
#define _NDTORAP                  38      //"NDTORAP"
#define _NDTOPUB                  39      //"NDTOPUB"
#define _NDTOPGO                  40      //"NDTOPGO"
#define _NDTOPTF                  41      //"NDTOPTF"
#define _LRECARGO                 42      //"LRECARGO
#define _NPCTCOMAGE               43      //"NPCTCOMA
#define _NBULTOS                  44      //"NBULTOS"
#define _CNUMPRE                  45      //"CNUMPRE"
#define _CDIVPED                  46      //"CDIVPED"
#define _NVDVPED                  47      //"NVDVPED"
#define _LSNDDOC                  48      //"LSNDDOC"
#define _LPDTCRG                  49      //"LPDTCRG"
#define _NREGIVA                  50      //"NREGIVA"
#define _LIVAINC                  51      //"LIVAINC"
#define _NIVAMAN                  52      //"NMANOBR"
#define _NMANOBR                  53      //"NMANOBR"
#define _CCODTRN                  54      //"CCODTRN"
#define _NKGSTRN                  55
#define _LCLOPED                  56      //"LCLOPED"
#define _CCODUSR                  57      //"CCODUSR"
#define _DFECCRE                  58      //"DFECCRE"
#define _CTIMCRE                  59      //"CTIMCRE"
#define _CRETMAT                  60      //"CRETMAT"
#define _CRETPOR                  61      //"CRETPOR"   C     20     0
#define _NPEDPROV                 62      //"NPEDPROV   N      1     0
#define _NMONTAJE                 63      //"NMONTAJE   N      6     0
#define _CCODGRP                  64      //"CCODGRP"
#define _LIMPRIMIDO               65      //"LIMPRIMI   L      1     0
#define _DFECIMP                  66      //"DFECIMP"   D      8     0
#define _CHORIMP                  67      //"CHORIMP"   C      5     0
#define _CCODDLG                  68      //"cCodDlg"
#define _NDTOATP                  69      //"nDtoAtp"   N      6     2
#define _NSBRATP                  70      //"nSbrAtp"   N      1     0
#define _CSITUAC                  71      //"cSituac"   C     20     0
#define _LWEB                     72
#define _LALQUILER                73      //LALQUILER   L      1     0
#define _DFECENTR                 74
#define _DFECSAL                  75
#define _CMANOBR                  76
#define _NGENERADO                77      //NGENERADO   N      1     0 ( 1-no rec., 2-parcial, 3-rec. )
#define _NRECIBIDO                78      //NRECIBIDO   N      1     0 ( 1-no rec., 2-parcial, 3-rec. )
#define _LINTERNET                79      //LINTERNET   L      1     0
#define _CNUMTIK                  80
#define _LCANCEL                  81      //LCANCEL     L      1     0
#define _DCANCEL                  82      //DCANCEL     D      8     0
#define _CCANCEL                  83      //CCANCEL     C    100     0
#define _CCODWEB                  84      //CCODWEB     C     11     0
#define _CTLFCLI                  85      //CTLFCLI     C     20     0
#define _NTOTNET                  86
#define _NTOTIVA                  87
#define _NTOTREQ                  88
#define _NTOTPED                  89
#define _CNUMALB                  90
#define _LOPERPV                  91
#define _CBANCO                   92
#define _CPAISIBAN 				    93
#define _CCTRLIBAN 				    94
#define _CENTBNC                  95
#define _CSUCBNC                  96
#define _CDIGBNC                  97
#define _CCTABNC                  98
#define _LPRODUC                  99
#define _NDTOTARIFA              100
#define _MFIRMA                  101
#define _CCENTROCOSTE            102
#define _UUID_TRN                103

/*
Definici¢n de la base de datos de lineas de detalle
*/

#define _CREF                      4      //   C     14     0
#define _CCODPR1                   5      //   C      5     0
#define _CCODPR2                   6      //   C      5     0
#define _CVALPR1                   7      //   C      5     0
#define _CVALPR2                   8      //   C      5     0
#define _CDETALLE                  9      //   C     50     0
#define _NIVA                     10      //   N      6     2
#define _NCANPED                  11      //   N     13     3
#define _NUNICAJA                 12      //   N     13     3
#define _NUNDKIT                  13      //   N     13     3
#define _NPREDIV                  14      //   N     13     3
#define _NPNTVER                  15      //   N     13     6
#define _NIMPTRN                  16      //   N     16     6
#define _NDTO                     17      //   N      5     1
#define _NDTOPRM                  18      //   N      5     1
#define _NCOMAGE                  19      //   N      5     1
#define _NCANENT                  20      //   N     13     3
#define _NUNIENT                  21      //   N     13     3
#define _CUNIDAD                  22      //   C      2     0
#define _NPESOKG                  23      //   N      7     3
#define _CPESOKG                  24      //   N      7     3
#define _DFECHA                   25      //   D      8     0
#define _CTIPMOV                  26      //   C      2     0
#define _MLNGDES                  27      //   M     10     0
#define _LTOTLIN                  28      //   L      1     0
#define _LIMPLIN                  29      //   L      1     0
#define _NFACCNV                  30      //   N     13     4
#define _NDTODIV                  31
#define _LRESUND                  32      //   L      1     0
#define _NRESUND                  33      //   N     13     0
#define _NRETUND                  34      //   N     13     0
#define _NNUMLIN                  35      //   N      4     0
#define _NCTLSTK                  36      //   N      1     0
#define _NCOSDIV                  37      //   N     13     3
#define _NPVPREC                  38      //   N     13     3
#define _CALMLIN                  39      //   C     3      0
#define _CCODIMP                  40      //   C     3      0
#define _NVALIMP                  41      //   N    16      6
#define _LIVALIN                  42      //   L     1,     0
#define _LLOTE                    43      //   L     1      0
#define _NLOTE                    44      //   N     4      0
#define _CLOTE                    45      //   N     4      0
#define _LKITART                  46      //   L     4      0
#define _LKITCHL                  47      //   L     4      0
#define _LKITPRC                  48      //   L     4      0
#define _NMESGRT                  49      //   N     2      0
#define _LMSGVTA                  50
#define _LNOTVTA                  51
#define _LCONTROL                 52
#define _MNUMSER                  53
#define _CCODTIP                  54      //   C     3      0
#define _LANULADO                 55
#define _DANULADO                 56
#define _MANULADO                 57
#define _CCODFAM                  58      //   C     8      0
#define _CGRPFAM                  59      //   C     3      0
#define _NREQ                     60      //   N    16      6
#define _MOBSLIN                  61      //   M    10      0
#define _NRECIBIDA                62      //   N     1      0
#define _CCODPRV                  63      //   C    12      0
#define _CNOMPRV                  64      //   C    30      0
#define _CIMAGEN                  65      //   C    30      0
#define _NPUNTOS                  66
#define _NVALPNT                  67
#define _NDTOPNT                  68
#define _NINCPNT                  69
#define _CREFPRV                  70
#define _NVOLUMEN                 71
#define _CVOLUMEN                 72
#define __DFECENT                 73
#define __DFECSAL                 74
#define __LALQUILER               75
#define _NPREALQ                  76
#define _NNUMMED                  77
#define _NMEDUNO                  78
#define _NMEDDOS                  79
#define _NMEDTRE                  80
#define _NTARLIN                  81      //   L      1     0
#define _LIMPFRA                  82
#define _CCODFRA                  83
#define _CTXTFRA                  84
#define _DESCRIP                  85
#define _LLINOFE                  86
#define _LVOLIMP                  87
#define _NPRODUC                  88
#define _DFECCAD                  89
#define _DFECULTCOM 			  		 90	
#define _LFROMATP				  		 91
#define _NUNIULTCOM 			  		 92
#define __NBULTOS 					 93
#define _CFORMATO 					 94
#define _LLABEL                   95
#define _NLABEL                   96
#define _DFECFIN                  97  
#define _COBRLIN                  98  
#define _CREFAUX                  99
#define _CREFAUX2                100
#define _NPOSPRINT               101
#define __CCENTROCOSTE           102
#define _CTIPCTR                 103
#define _CTERCTR                 104
#define _NNUMKIT                 105
#define _ID_TIPO_V               106
#define __NREGIVA                107
#define _NPRCULTCOM              108

/*
Array para impuestos
*/

memvar cDbf
memvar cDbfCol
memvar cDbfPag
memvar cCliente
memvar cDbfCli
memvar cDbfObr
memvar cAgente
memvar cDbfAge
memvar cIva
memvar cDbfIva
memvar cFPago
memvar cDbfPgo
memvar cTarPreL
memvar cTarPreS
memvar cPromoL
memvar cDbfRut
memvar cDbfTrn
memvar cDbfPro
memvar cDbfTblPro
memvar aTotIva
memvar aTotIvm
memvar cCtaCli
memvar nTotBrt
memvar nTotIva
memvar nTotIvm
memvar nTotReq
memvar nTotImp
memvar nTotDto
memvar nTotDpp
memvar nTotUno
memvar nTotDos
memvar nTotNet
memvar nTotPed
memvar nTotPag
memvar nTotPnt
memvar nTotCos
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
memvar nVdv
memvar nVdvDivPed
memvar cPicUndPed
memvar cPouDivPed
memvar cPorDivPed
memvar cPouChgPed
memvar nDouDivPed
memvar nRouDivPed
memvar nTotArt
memvar nTotCaj
memvar nPagina
memvar lEnd
memvar cDbfEnt
memvar cDbfDiv
memvar cPorDivEnt
memvar nTotPage
memvar nTotalDto

memvar aImpVto
memvar aDatVto

memvar nNumArt
memvar nNumCaj

static bEdtRec       := { |aTmp, aGet, dbfPedCliT, oBrw, bWhen, bValid, nMode, cCodPre | EdtRec( aTmp, aGet, dbfPedCliT, oBrw, bWhen, bValid, nMode, cCodPre ) }
static bEdtDet       := { |aTmp, aGet, dbf, oBrw, bWhen, bValid, nMode, aTmpPed | EdtDet( aTmp, aGet, dbf, oBrw, bWhen, bValid, nMode, aTmpPed ) }
static bEdtRes       := { |aTmp, aGet, dbfPedCliR, oBrw, bWhen, bValid, nMode, aTmpLin | EdtRes( aTmp, aGet, dbfPedCliR, oBrw, bWhen, bValid, nMode, aTmpLin ) }
static bEdtDoc       := { |aTmp, aGet, dbfPedCliD, oBrw, bWhen, bValid, nMode, aTmpLin | EdtDoc( aTmp, aGet, dbfPedCliD, oBrw, bWhen, bValid, nMode, aTmpLin ) }
static bEdtPgo       := { |aTmp, aGet, dbfPedCliP, oBrw, bWhen, bValid, nMode, aTmpPed | EdtEnt( aTmp, aGet, dbfPedCliP, oBrw, bWhen, bValid, nMode, aTmpPed ) }
static bEdtTablet    := { |aTmp, aGet, dbfPedCliT, oBrw, bWhen, bValid, nMode, aNumDoc| EdtTablet( aTmp, aGet, dbfPedCliT, oBrw, bWhen, bValid, nMode, aNumDoc ) }
static bEdtEst       := { |aTmp, aGet, dbf, oBrw, bWhen, bValid, nMode, aTmpLin | EdtEst( aTmp, aGet, dbf, oBrw, bWhen, bValid, nMode, aTmpLin ) } 


static lExternal     := .f.
static aTipPed       := { "Venta", "Alquiler" }

static cOldCodCli    := ""
static cOldCodArt    := ""
static cOldPrpArt    := ""
static cOldUndMed    := ""

static dbfOferta
static lOpenFiles    := .f.

static oWndBrw

static nView

static dbfPedCliT
static dbfPedCliL
static dbfPedCliI
static dbfPedCliD
static dbfPedCliP
static dbfPreCliT
static dbfPreCliL
static dbfPreCliI
static dbfPreCliD
static dbfAlbCliT
static dbfAlbCliL
static dbfAlbCliP
static dbfAlbPrvT
static dbfAlbPrvL
static dbfClient
static dbfCliBnc
static dbfTarPreL
static dbfTarPreS
static dbfPromoT
static dbfPromoL
static dbfPromoC
static dbfAgent
static dbfCodebar
static dbfKit
static dbfArtDiv
static dbfRuta
static dbfAlm
static dbfObrasT
static oBrwIva
static dbfArtPrv
static dbfDelega
static dbfEmp
static dbfFacPrvL
static dbfRctPrvL
static dbfAntCliT
static dbfFacCliT
static dbfFacCliL
static dbfFacCliP
static dbfFacRecL
static dbfTikCliT
static dbfTikCliL
static dbfProLin
static dbfProMat
static dbfsitua
static cOrdAnt
static oBandera
static oNewImp
static oDetCamposExtra
static dbfTmpLin
static dbfTmpPedLin
static dbfTmpFin
static dbfTmpRes
static dbfTmpInc
static dbfTmpDoc
static dbfTmpPgo
static dbfPro
static dbfPedCliE
static dbfTmpEst

static oImpuestos
static lImpuestos

static dbfAgeCom
static dbfCajT
static oStock
static cTmpLin
static cTmpRes
static cTmpInc
static cTmpDoc
static cTmpPgo
static cTmpEst
static oGetNet
static oGetTrn
static oGetIvm
static oGetPnt
static oGetIva
static oGetReq
static oGetAge
static oGetRnt
static oGetTotal
static oGetTarifa
static oTotPedLin
static oGetPed
static oGetEnt
static oGetPdt
static oGetPes
static oGetDif
static nVdvDiv
static cPouDiv
static cPorDiv
static cPpvDiv
static cPicEur
static cPicUnd
static nDouDiv
static nRouDiv
static nDpvDiv
static oFont
static oMenu
static oGrpFam
static oTipArt
static oFabricante
static oUndMedicion
static oBtnPrecio

static oBtnKit
static oBtnAtp

static oDlgPedidosWeb
static oBrwPedidosWeb
static oBrwDetallesPedidos

static oComisionLinea
static nComisionLinea      := 0

static cFiltroUsuario      := ""

static oMsgAlarm

static bEdtInc             := { |aTmp, aGet, dbfPedCliI, oBrw, bWhen, bValid, nMode, aTmpLin | EdtInc( aTmp, aGet, dbfPedCliI, oBrw, bWhen, bValid, nMode, aTmpLin ) }

static aEstadoProduccion   := { "Producido", "En producción", "Pendiente de producción" }
static aEstadoPedido       := { "Pendiente", "Parcial", "Entregado" }

static oMailing

static oBrwProperties

static oTipoCtrCoste
static cTipoCtrCoste
static aTipoCtrCoste       := { "Centro de coste", "Proveedor", "Agente", "Cliente" }

static oCentroCoste

static Counter

static oTransportistaSelector

//---------------------------------------------------------------------------//
//Comenzamos la parte de código que se compila para el ejecutable normal
//---------------------------------------------------------------------------//

FUNCTION GenPedCli( nDevice, cCaption, cCodDoc, cPrinter, nCopies )

   local oInf
   local oDevice
   local nNumPed

   if ( D():PedidosClientes( nView ) )->( Lastrec() ) == 0
      return nil
   end if

   nNumPed              := ( D():PedidosClientes( nView ) )->cSerPed + Str( ( D():PedidosClientes( nView ) )->nNumPed ) + ( D():PedidosClientes( nView ) )->cSufPed

   DEFAULT nDevice      := IS_PRINTER
   DEFAULT cCaption     := "Imprimiendo pedido"
   DEFAULT cCodDoc      := cFormatoPedidosClientes()

   if !lExisteDocumento( cCodDoc, D():Documentos( nView ) )
      return nil
   end if

   
   // Numero de copias---------------------------------------------------------

   if Empty( nCopies )
      nCopies           := retfld( ( D():PedidosClientes( nView ) )->cCodCli, D():Get( "Client", nView ), "CopiasF" ) 
   end if

   if nCopies == 0 
      nCopies           := nCopiasDocumento( ( D():Get( "PedCliT", nView ) )->cSerPed, "nPedCli", D():Get( "NCount", nView ) )
   end if 

   if nCopies == 0
      nCopies           := 1
   end if  

   /*
   Si el documento es de tipo visual-------------------------------------------
   */

   if lVisualDocumento( cCodDoc, D():Documentos( nView ) )
      PrintReportPedCli( nDevice, nCopies, cPrinter, cCodDoc )
   else
      msgStop( "El formato ya no es soportado" )
   end if

   lChgImpDoc( D():PedidosClientes( nView ) )

RETURN NIL

//--------------------------------------------------------------------------//

Static Function PedCliReportSkipper( cPedCliL )

   ( cPedCliL )->( dbSkip() )

   nTotPage              += nTotLPedCli( cPedCliL )

Return nil

//---------------------------------------------------------------------------//

STATIC FUNCTION EPage( oInf, cCodDoc )

	private nPagina		:= oInf:nPage
	private lEnd			:= oInf:lFinish

   DEFAULT cCodDoc      := "PC1"

   PrintItems( cCodDoc, oInf )

RETURN NIL

//--------------------------------------------------------------------------//

STATIC FUNCTION OpenFiles( lExt )

   local oError
   local oBlock

   if lOpenFiles
      MsgStop( 'Imposible abrir ficheros de pedidos de clientes' )
      Return ( .f. )
   end if

   DEFAULT lExt         := .f.

   lExternal            := lExt

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      DisableAcceso()

      if !lExistTable( cPatEmp() + "PedCliT.Dbf" )  .or.;
         !lExistTable( cPatEmp() + "PedCliL.Dbf" )  .or.;
         !lExistTable( cPatEmp() + "PedCliR.Dbf" )  .or.;
         !lExistTable( cPatEmp() + "PedCliI.Dbf" )  .or.;
         !lExistTable( cPatEmp() + "PedCliD.Dbf" )
         mkPedCli( cPatEmp() )
      end if

      lOpenFiles        := .t.

      nView             := D():CreateView()

      /*
    	Atipicas de clientes-----------------------------------------------------
      */

      D():Atipicas( nView )

      D():PedidosClientes( nView )

      D():PedidosClientesLineas( nView )

      D():PedidosClientesSituaciones( nView )

      D():PedidosClientesReservas( nView )

      D():PedidosClientesPagos( nView )

      D():Clientes( nView )

      D():objectGruposClientes( nView )

      D():GetObject( "UnidadMedicion", nView )

      D():ImpuestosEspeciales( nView )

      D():ArticuloStockAlmacenes( nView )

      D():Articulos( nView )

      D():ArticuloLenguaje( nView )

      D():ProveedorArticulo( nView ) 

      D():Familias( nView )

      D():Documentos( nView )
      ( D():Documentos( nView ) )->( OrdSetFocus( "cTipo" ) )

      D():PedidosProveedores( nView )

      D():PedidosProveedoresLineas( nView )

      D():TiposIva( nView )

      D():PropiedadesLineas( nView )

      D():Proveedores( nView )

      D():Contadores( nView )

      D():Divisas( nView )

      D():FormasPago( nView )

      D():ImpuestosEspeciales( nView )

      USE ( cPatEmp() + "PEDCLII.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PEDCLII", @dbfPedCliI ) )
      SET ADSINDEX TO ( cPatEmp() + "PEDCLII.CDX" ) ADDITIVE

      USE ( cPatEmp() + "PEDCLID.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PEDCLID", @dbfPedCliD ) )
      SET ADSINDEX TO ( cPatEmp() + "PEDCLID.CDX" ) ADDITIVE

      USE ( cPatEmp() + "PEDCLIP.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PEDCLIP", @dbfPedCliP ) )
      SET ADSINDEX TO ( cPatEmp() + "PEDCLIP.CDX" ) ADDITIVE

      USE ( cPatEmp() + "PRECLIL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PRECLIL", @dbfPreCliL ) )
      SET ADSINDEX TO ( cPatEmp() + "PRECLIL.CDX" ) ADDITIVE

      USE ( cPatEmp() + "PRECLII.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PRECLII", @dbfPreCliI ) )
      SET ADSINDEX TO ( cPatEmp() + "PRECLII.CDX" ) ADDITIVE

      USE ( cPatEmp() + "PRECLID.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PRECLID", @dbfPreCliD ) )
      SET ADSINDEX TO ( cPatEmp() + "PRECLID.CDX" ) ADDITIVE

      USE ( cPatEmp() + "ALBCLIL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALBCLIL", @dbfAlbCliL ) )
      SET ADSINDEX TO ( cPatEmp() + "ALBCLIL.CDX" ) ADDITIVE

      USE ( cPatEmp() + "ALBCLIP.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALBCLIP", @dbfAlbCliP ) )
      SET ADSINDEX TO ( cPatEmp() + "ALBCLIP.CDX" ) ADDITIVE

      USE ( cPatEmp() + "ALBPROVT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALBPROVT", @dbfAlbPrvT ) )
      SET ADSINDEX TO ( cPatEmp() + "ALBPROVT.CDX" ) ADDITIVE

      USE ( cPatEmp() + "ALBPROVL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALBPROVL", @dbfAlbPrvL ) )
      SET ADSINDEX TO ( cPatEmp() + "ALBPROVL.CDX" ) ADDITIVE

      USE ( cPatEmp() + "AGENTES.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "AGENTES", @dbfAgent ) )
      SET ADSINDEX TO ( cPatEmp() + "AGENTES.CDX" ) ADDITIVE

      USE ( cPatEmp() + "ArtCodebar.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CODEBAR", @dbfCodebar ) )
      SET ADSINDEX TO ( cPatEmp() + "ArtCodebar.Cdx" ) ADDITIVE

      USE ( cPatEmp() + "TARPREL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TARPREL", @dbfTarPreL ) )
      SET ADSINDEX TO ( cPatEmp() + "TARPREL.CDX" ) ADDITIVE

      USE ( cPatEmp() + "TARPRES.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TARPRES", @dbfTarPreS ) )
      SET ADSINDEX TO ( cPatEmp() + "TARPRES.CDX" ) ADDITIVE

      USE ( cPatEmp() + "PROMOT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PROMOT", @dbfPromoT ) )
      SET ADSINDEX TO ( cPatEmp() + "PROMOT.CDX" ) ADDITIVE

      USE ( cPatEmp() + "PROMOL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PROMOL", @dbfPromoL ) )
      SET ADSINDEX TO ( cPatEmp() + "PROMOL.CDX" ) ADDITIVE

      USE ( cPatEmp() + "PROMOC.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PROMOC", @dbfPromoC ) )
      SET ADSINDEX TO ( cPatEmp() + "PROMOC.CDX" ) ADDITIVE

      USE ( cPatEmp() + "ObrasT.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "OBRAST", @dbfObrasT ) )
      SET ADSINDEX TO ( cPatEmp() + "ObrasT.Cdx" ) ADDITIVE

      USE ( cPatEmp() + "OFERTA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "OFERTA", @dbfOferta ) )
      SET ADSINDEX TO ( cPatEmp() + "OFERTA.CDX" ) ADDITIVE

      USE ( cPatEmp() + "PRO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PRO", @dbfPro ) )
      SET ADSINDEX TO ( cPatEmp() + "PRO.CDX" ) ADDITIVE

      USE ( cPatEmp() + "ARTKIT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ARTTIK", @dbfKit ) )
      SET ADSINDEX TO ( cPatEmp() + "ARTKIT.CDX" ) ADDITIVE

      USE ( cPatEmp() + "ArtDiv.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ARTDIV", @dbfArtDiv ) )
      SET ADSINDEX TO ( cPatEmp() + "ArtDiv.Cdx" ) ADDITIVE

      USE ( cPatEmp() + "RUTA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "RUTA", @dbfRuta ) )
      SET ADSINDEX TO ( cPatEmp() + "RUTA.CDX" ) ADDITIVE

      USE ( cPatDat() + "Cajas.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CAJAS", @dbfCajT ) )
      SET ADSINDEX TO ( cPatDat() + "Cajas.Cdx" ) ADDITIVE

      USE ( cPatEmp() + "Almacen.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALMACEN", @dbfAlm ) )
      SET ADSINDEX TO ( cPatEmp() + "Almacen.Cdx" ) ADDITIVE

      USE ( cPatEmp() + "PROVART.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PROVART", @dbfArtPrv ) )
      SET ADSINDEX TO ( cPatEmp() + "PROVART.CDX" ) ADDITIVE

      USE ( cPatDat() + "DELEGA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "DELEGA", @dbfDelega ) )
      SET ADSINDEX TO ( cPatDat() + "DELEGA.CDX" ) ADDITIVE

      USE ( cPatEmp() + "AGECOM.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "AGECOM", @dbfAgeCom ) )
      SET ADSINDEX TO ( cPatEmp() + "AGECOM.CDX" ) ADDITIVE

      USE ( cPatDat() + "EMPRESA.DBF" ) NEW SHARED VIA ( cDriver() )ALIAS ( cCheckArea( "EMPRESA", @dbfEmp ) )
      SET ADSINDEX TO ( cPatDat() + "EMPRESA.CDX" ) ADDITIVE

      USE ( cPatEmp() + "FACPRVL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACPRVL", @dbfFacPrvL ) )
      SET ADSINDEX TO ( cPatEmp() + "FACPRVL.CDX" ) ADDITIVE
      SET TAG TO "cRef"

      USE ( cPatEmp() + "RctPrvL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "RctPrvL", @dbfRctPrvL ) )
      SET ADSINDEX TO ( cPatEmp() + "RctPrvL.CDX" ) ADDITIVE
      SET TAG TO "cRef"

      USE ( cPatEmp() + "FACCLIL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACCLIL", @dbfFacCliL ) )
      SET ADSINDEX TO ( cPatEmp() + "FACCLIL.CDX" ) ADDITIVE
      SET TAG TO "cRef"

      USE ( cPatEmp() + "AntCliT.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "AntCliT", @dbfAntCliT ) )
      SET ADSINDEX TO ( cPatEmp() + "AntCliT.Cdx" ) ADDITIVE

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

      USE ( cPatEmp() + "CliBnc.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CLIBNC", @dbfCliBnc ) )
      SET ADSINDEX TO ( cPatEmp() + "CliBnc.Cdx" ) ADDITIVE

   	if !TDataCenter():OpenPreCliT( @dbfPreCliT )
   		lOpenFiles     := .f.
   	end if 

      if !TDataCenter():OpenAlbCliT( @dbfAlbCliT )
  		  lOpenFiles     := .f.
	  end if

      if !TDataCenter():OpenFacCliT( @dbfFacCliT )
         lOpenFiles    := .f.
      end if

      if !TDataCenter():OpenFacCliP( @dbfFacCliP )
	     lOpenFiles     	:= .f.
      end if

      // Unidades de medicion

      oUndMedicion      := UniMedicion():Create( cPatEmp() )
      if !oUndMedicion:OpenFiles()
         lOpenFiles     := .f.
      end if

      oBandera          := TBandera():New()

      oStock            := TStock():Create( cPatEmp() )
      if !oStock:lOpenFiles()
         lOpenFiles     := .f.
      end if

      oNewImp           := TNewImp():Create( cPatEmp() )
      if !oNewImp:OpenFiles()
         lOpenFiles     := .f.
      end if

      oTipArt           := TTipArt():Create( cPatEmp() )
      if !oTipArt:OpenFiles()
         lOpenFiles     := .f.
      end if

      oFabricante          := TFabricantes():Create( cPatEmp() )
      if !oFabricante:OpenFiles()
         lOpenFiles        := .f.
      end if

      oGrpFam           := TGrpFam():Create( cPatEmp() )
      if !oGrpFam:OpenFiles()
         lOpenFiles     := .f.
      end if

      oCentroCoste        := TCentroCoste():Create( cPatDat() )
      if !oCentroCoste:OpenFiles()
         lOpenFiles     := .f.
      end if

      CodigosPostales():GetInstance():OpenFiles()

      oMailing          := TGenmailingDatabasePedidosClientes():New( nView )

      Counter           := TCounter():New( nView, "nPedCli" )

      oTransportistaSelector     := TransportistasController():New():oGetSelectorTransportista

      /*
      Recursos y fuente--------------------------------------------------------
      */

      oFont                := TFont():New( "Arial", 8, 26, .F., .T. )

      /*
      Variables privadas-------------------------------------------------------
      */

      public nTotBrt       := 0
      public nTotPed       := 0
      public nTotDto       := 0
      public nTotDPP       := 0
      public nTotNet       := 0
      public nTotIvm       := 0
      public nTotIva       := 0
      public nTotReq       := 0
      public nTotAge       := 0
      public nTotPnt       := 0
      public nTotUno       := 0
      public nTotDos       := 0
      public nTotTrn       := 0
      public nTotCos       := 0
      public nTotRnt       := 0
      public nTotAtp       := 0
      public nTotPes       := 0
      public nTotDif       := 0
      public nPctRnt       := 0

      public aTotIva       := { { 0,0,nil,0,0,0,0,0,0,0,0 }, { 0,0,nil,0,0,0,0,0,0,0,0 }, { 0,0,nil,0,0,0,0,0,0,0,0 } }
      public aIvaUno       := aTotIva[ 1 ]
      public aIvaDos       := aTotIva[ 2 ]
      public aIvaTre       := aTotIva[ 3 ]

      public aTotIvm       := { { 0,nil,0 }, { 0,nil,0 }, { 0,nil,0 }, }
      public aIvmUno       := aTotIvm[ 1 ]
      public aIvmDos       := aTotIvm[ 2 ]
      public aIvmTre       := aTotIvm[ 3 ]

      public aImpVto       := {}
      public aDatVto       := {}

      /*
      Limitaciones de cajero y cajas--------------------------------------------------------
      */

      if lAIS() .and. !oUser():lAdministrador()
      
         cFiltroUsuario    := "Field->cSufPed == '" + Application():CodigoDelegacion() + "' .and. Field->cCodCaj == '" + Application():CodigoCaja() + "'"
         if SQLAjustableModel():getRolFiltrarVentas( Auth():rolUuid() )         
            cFiltroUsuario += " .and. Field->cCodUsr == '" + Auth():Codigo()  + "'"
         end if 

         ( D():PedidosClientes( nView ) )->( AdsSetAOF( cFiltroUsuario ) )

      end if

      EnableAcceso()

      /*
		Campos extras------------------------------------------------------------------------
      */

      oDetCamposExtra      := TDetCamposExtra():New()
      oDetCamposExtra:OpenFiles()
      oDetCamposExtra:SetTipoDocumento( "Pedidos a clientes" )
      oDetCamposExtra:setbId( {|| D():PedidosClientesId( nView ) } )


   RECOVER USING oError

      lOpenFiles           := .f.

      EnableAcceso()

      msgStop( "Imposible abrir todas las bases de datos" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   if !lOpenFiles
      CloseFiles()
   end if

RETURN ( lOpenFiles )

//----------------------------------------------------------------------------//

FUNCTION PedCli( oMenuItem, oWnd, cCodCli, cCodArt, cCodPre, lPedWeb )

   local oImp
   local oPrv
   local oSnd
   local oChangeState
   local oRpl
   local oPdf
   local oMail
   local oDup
   local oBtnEur
   local nLevel
   local lEuro          := .f.
   local oRotor
   local oScript
   local aEstGen        := {  "No" , "Parcial" , "Si" }

   DEFAULT  oMenuItem   := _MENUITEM_
   DEFAULT  oWnd        := oWnd()
   DEFAULT  cCodCli     := ""
   DEFAULT  cCodArt     := ""
   DEFAULT  cCodPre     := ""
   DEFAULT  lPedWeb     := .f.

   nLevel               := Auth():Level( oMenuItem )
   if nAnd( nLevel, 1 ) == 0
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

   DEFINE SHELL oWndBrw FROM 0, 0 TO 22, 80 ;
      XBROWSE ;
      TITLE    "Pedidos de clientes" ;
      PROMPT   "Número",;
               "Fecha",;
               "Código",;
               "Nombre",;
               "Código postal",;
               "Población",;
               "Provincia",;
               "Dirección",;
               "Agente",;
               "Entrada",;
               "Comercio electrónico",;
               "Situación",;
               "Delegación";
      MRU      "gc_clipboard_empty_user_16";
      BITMAP   clrTopArchivos ;
      ALIAS    ( D():PedidosClientes( nView ) );
      APPEND   ( WinAppRec( oWndBrw:oBrw, bEdtRec, D():PedidosClientes( nView ), cCodCli, cCodArt, cCodPre ) ) ;
      DUPLICAT ( WinDupRec( oWndBrw:oBrw, bEdtRec, D():PedidosClientes( nView ), cCodCli, cCodArt, cCodPre ) ) ;
      EDIT     ( WinEdtRec( oWndBrw:oBrw, bEdtRec, D():PedidosClientes( nView ), cCodCli, cCodArt, cCodPre ) ) ;
      ZOOM     ( WinZooRec( oWndBrw:oBrw, bEdtRec, D():PedidosClientes( nView ) ) ) ;
      DELETE   ( WinDelRec( oWndBrw:oBrw, D():PedidosClientes( nView ), {|| QuiPedCli() } ) ) ;
      LEVEL    nLevel ;
      OF       oWnd

	  oWndBrw:lFechado     := .t.

	  oWndBrw:SetYearComboBoxChange( {|| YearComboBoxChange() } )

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Sesión cerrada"
         :nHeadBmpNo       := 3
         :bStrData         := {|| "" }
         :bEditValue       := {|| ( D():PedidosClientes( nView ) )->lCloPed }
         :nWidth           := 20
         :SetCheck( { "Sel16", "Nil16" } )
         :AddResource( "gc_lock2_16" )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Cancelado"
         :nHeadBmpNo       := 3
         :bStrData         := {|| "" }
         :bEditValue       := {|| ( D():PedidosClientes( nView ) )->lCancel }
         :nWidth           := 20
         :lHide            := .t.
         :SetCheck( { "Sel16", "Nil16" } )
         :AddResource( "gc_lock2_16" )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Estado"
         :nHeadBmpNo       := 4
         :bStrData         := {|| cEstadoPedido( ( D():PedidosClientes( nView ) )->nEstado ) }
         :bBmpData         := {|| Max( ( D():PedidosClientes( nView ) )->nEstado, 1 ) }
         :nWidth           := 20
         :AddResource( "gc_delete_12" )
         :AddResource( "gc_shape_square_12" )
         :AddResource( "gc_check_12" )
         :AddResource( "gc_trafficlight_on_16" )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Envio"
         :nHeadBmpNo       := 3
         :bStrData         := {|| "" }
         :bEditValue       := {|| ( D():PedidosClientes( nView ) )->lSndDoc }
         :nWidth           := 20
         :SetCheck( { "gc_mail2_12", "Nil16" } )
         :AddResource( "gc_mail2_16" )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Incidencia"
         :nHeadBmpNo       := 4
         :bStrData         := {|| "" }
         :bBmpData         := {|| nEstadoIncidencia( ( D():PedidosClientes( nView ) )->cSerPed + Str( ( D():PedidosClientes( nView ) )->nNumPed ) + ( D():PedidosClientes( nView ) )->cSufPed ) }
         :nWidth           := 20
         :lHide            := .t.
         :AddResource( "gc_delete_12" )
         :AddResource( "gc_shape_square_12" )
         :AddResource( "gc_check_12" )
         :AddResource( "gc_document_information_16" )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Producción"
         :nHeadBmpNo       := 4
         :bStrData         := {|| cEstadoProduccion( ( D():PedidosClientes( nView ) )->cSerPed + Str( ( D():PedidosClientes( nView ) )->nNumPed ) + ( D():PedidosClientes( nView ) )->cSufPed ) }
         :bBmpData         := {|| nEstadoProduccion( ( D():PedidosClientes( nView ) )->cSerPed + Str( ( D():PedidosClientes( nView ) )->nNumPed ) + ( D():PedidosClientes( nView ) )->cSufPed ) }
         :nWidth           := 20
         :lHide            := .t.
         :AddResource( "gc_check_12" )
         :AddResource( "gc_shape_square_12" )
         :AddResource( "gc_delete_12" )
         :AddResource( "gc_worker2_16" )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Impreso"
         :nHeadBmpNo       := 3
         :bStrData         := {|| "" }
         :bEditValue       := {|| ( D():PedidosClientes( nView ) )->lImprimido }
         :nWidth           := 20
         :lHide            := .t.
         :SetCheck( { "Sel16", "Nil16" } )
         :AddResource( "gc_printer2_16" )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Comercio electrónico"
         :cSortOrder       := "lInternet"
         :nHeadBmpNo       := 3
         :bStrData         := {|| "" }
         :bEditValue       := {|| ( D():PedidosClientes( nView ) )->lInternet }
         :nWidth           := 20
         :lHide            := .t.
         :SetCheck( { "Sel16", "Nil16" } )
         :AddResource( "gc_earth_16" )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Listo para entregar"
         :nHeadBmpNo       := 3
         :bStrData         := {|| "" }
         :bEditValue       := {|| ( D():PedidosClientes( nView ) )->lPdtCrg }
         :nWidth           := 20
         :lHide            := .t.
         :SetCheck( { "Sel16", "Nil16" } )
         :AddResource( "gc_clipboard_checks_16" )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Generado"
         :bEditValue       := {|| aEstGen[ Max( Min( ( D():PedidosClientes( nView ) )->nGenerado, len( aEstGen ) ), 1 ) ] }
         :nWidth           := 60
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Recibido"
         :bEditValue       := {|| aEstGen[ Max( Min( ( D():PedidosClientes( nView ) )->nRecibido, len( aEstGen ) ), 1 ) ] }
         :nWidth           := 60
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Entrega"
         :cSortOrder       := "dFecEnt"
         :bEditValue       := {|| Dtoc( ( D():PedidosClientes( nView ) )->dFecEnt ) }
         :nWidth           := 80
         :lHide            := .t.
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Inicio servicio"
         :cSortOrder       := "dFecEntr"
         :bEditValue       := {|| Dtoc( ( D():PedidosClientes( nView ) )->dFecEntr ) }
         :nWidth           := 80
         :lHide            := .t.
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Fin servicio"
         :cSortOrder       := "dFecSal"
         :bEditValue       := {|| Dtoc( ( D():PedidosClientes( nView ) )->dFecSal ) }
         :nWidth           := 80
         :lHide            := .t.
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Tipo"
         :bEditValue       := {|| aTipPed[ if( ( D():PedidosClientes( nView ) )->lAlquiler, 2, 1 ) ] }
         :nWidth           := 50
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Número"
         :cSortOrder       := "nNumPed"
         :bEditValue       := {|| ( D():PedidosClientes( nView ) )->cSerPed + "/" + AllTrim( Str( ( D():PedidosClientes( nView ) )->nNumPed ) ) }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Delegación"
         :bEditValue       := {|| ( D():PedidosClientes( nView ) )->cSufPed }
         :nWidth           := 40
         :lHide            := .t.
         :cSortOrder       := "cSufPed"
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Sesión"
         :bEditValue       := {|| Trans( ( D():PedidosClientes( nView ) )->cTurPed, "######" ) }
         :nWidth           := 40
         :lHide            := .t.
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Fecha"
         :cSortOrder       := "dFecDes"
         :bEditValue       := {|| Dtoc( ( D():PedidosClientes( nView ) )->dFecPed ) }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Caja"
         :bEditValue       := {|| ( D():PedidosClientes( nView ) )->cCodCaj }
         :nWidth           := 40
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Usuario"
         :bEditValue       := {|| ( D():PedidosClientes( nView ) )->cCodUsr }
         :nWidth           := 40
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Situación"
         :cSortOrder       := "cSituac"
         :bEditValue       := {|| AllTrim( ( D():PedidosClientes( nView ) )->cSituac ) }
         :nWidth           := 80
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Código"
         :cSortOrder       := "cCodCli"
         :bEditValue       := {|| AllTrim( ( D():PedidosClientes( nView ) )->cCodCli ) }
         :nWidth           := 70
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Nombre"
         :cSortOrder       := "cNomCli"
         :bEditValue       := {|| ( D():PedidosClientes( nView ) )->cNomCli }
         :nWidth           := 280
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Código postal"
         :cSortOrder       := "CodPostal"
         :bEditValue       := {|| alltrim( ( D():PedidosClientes( nView ) )->cPosCli ) }
         :nWidth           := 60
         :lHide            := .t.
         :bLDClickData     := {|| oWndBrw:RecEdit() }
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Población"
         :cSortOrder       := "Poblacion"
         :bEditValue       := {|| alltrim( ( D():PedidosClientes( nView ) )->cPobCli ) }
         :nWidth           := 180
         :lHide            := .t.
         :bLDClickData     := {|| oWndBrw:RecEdit() }
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Provincia"
         :cSortOrder       := "Provincia"
         :bEditValue       := {|| alltrim( ( D():PedidosClientes( nView ) )->cPrvCli ) }
         :nWidth           := 100
         :lHide            := .t.
         :bLDClickData     := {|| oWndBrw:RecEdit() }
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Agente"
         :cSortOrder       := "cCodAge"
         :bEditValue       := {|| ( D():PedidosClientes( nView ) )->cCodAge }
         :nWidth           := 50
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Nombre agente"
         :bEditValue       := {|| retNbrAge( ( D():PedidosClientes( nView ) )->cCodAge, dbfAgent )  }
         :nWidth           := 200
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Ruta"
         :bEditValue       := {|| ( D():PedidosClientes( nView ) )->cCodRut }
         :nWidth           := 40
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Forma pago"
         :bEditValue       := {|| if( !Empty( ( D():PedidosClientes( nView ) )->cCodPgo ), ( D():PedidosClientes( nView ) )->cCodPgo + " - " + AllTrim( RetFld( ( D():PedidosClientes( nView ) )->cCodPgo, D():FormasPago( nView ), "cDesPago" ) ), "" ) }
         :nWidth           := 200
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Almacén"
         :bEditValue       := {|| ( D():PedidosClientes( nView ) )->cCodAlm }
         :nWidth           := 60
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Dirección"
         :cSortOrder       := "cCodObr"
         :bEditValue       := {|| ( D():PedidosClientes( nView ) )->cCodObr }
         :nWidth           := 50
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Entregado " + cDivEmp()
         :bEditValue       := {|| nPagPedCli( ( D():PedidosClientes( nView ) )->cSerPed + Str( ( D():PedidosClientes( nView ) )->nNumPed ) + ( D():PedidosClientes( nView ) )->cSufPed, D():PedidosClientesPagos( nView ), D():Divisas( nView ), if( lEuro, cDivChg(), cDivEmp() ), .t. ) }
         :nWidth           := 100
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Base"
         :bEditValue       := {|| iif( ( D():PedidosClientes( nView ) )->lCancel, 0, ( D():PedidosClientes( nView ) )->nTotNet ) }
         :cEditPicture     := cPorDiv( ( D():PedidosClientes( nView ) )->cDivPed, D():Divisas( nView ) )
         :nWidth           := 80
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := cImp()
         :bEditValue       := {|| iif( ( D():PedidosClientes( nView ) )->lCancel, 0, ( D():PedidosClientes( nView ) )->nTotIva ) }
         :cEditPicture     := cPorDiv( ( D():PedidosClientes( nView ) )->cDivPed, D():Divisas( nView ) )
         :nWidth           := 80
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "R.E."
         :bEditValue       := {|| iif( ( D():PedidosClientes( nView ) )->lCancel, 0, ( D():PedidosClientes( nView ) )->nTotReq ) }
         :cEditPicture     := cPorDiv( ( D():PedidosClientes( nView ) )->cDivPed, D():Divisas( nView ) )
         :nWidth           := 80
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Total"
         :bEditValue       := {|| iif( ( D():PedidosClientes( nView ) )->lCancel, 0, ( D():PedidosClientes( nView ) )->nTotPed ) }
         :cEditPicture     := cPorDiv( ( D():PedidosClientes( nView ) )->cDivPed, D():Divisas( nView ) )
         :nWidth           := 80
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Div."
         :bEditValue       := {|| cSimDiv( if( lEuro, cDivChg(), ( D():PedidosClientes( nView ) )->cDivPed ), D():Divisas( nView ) ) }
         :nWidth           := 30
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Pendiente"
         :bEditValue       := {|| ( nTotPedCli( ( D():PedidosClientes( nView ) )->cSerPed + Str( ( D():PedidosClientes( nView ) )->nNumPed ) + ( D():PedidosClientes( nView ) )->cSufPed, D():PedidosClientes( nView ), D():PedidosClientesLineas( nView ), D():TiposIva( nView ), D():Divisas( nView ), D():FormasPago( nView ), nil, nil, .f. ) - nPagPedCli( ( D():PedidosClientes( nView ) )->cSerPed + Str( ( D():PedidosClientes( nView ) )->nNumPed ) + ( D():PedidosClientes( nView ) )->cSufPed, D():PedidosClientesPagos( nView ), D():Divisas( nView ), nil, .f. ) ) }
         :nWidth           := 100
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
         :cEditPicture     := cPorDiv
         :lHide            := .t. 
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Comisión agente"
         :bEditValue       := {|| sTotPedCli( ( D():PedidosClientes( nView ) )->cSerPed + Str( ( D():PedidosClientes( nView ) )->nNumPed ) + ( D():PedidosClientes( nView ) )->cSufPed, D():PedidosClientes( nView ), D():PedidosClientesLineas( nView ), D():TiposIva( nView ), D():Divisas( nView ) ):nTotalAgente }
         :nWidth           := 100
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
         :cEditPicture     := cPorDiv
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Horas montaje"
         :bEditValue       := {|| ( D():PedidosClientes( nView ) )->nMontaje }
         :nWidth           := 70
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
         :cEditPicture     := "@E 999.99"
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Su pedido"
         :bEditValue       := {|| ( D():PedidosClientes( nView ) )->cSuPed }
         :nWidth           := 100
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Condición"
         :bEditValue       := {|| AllTrim( ( D():PedidosClientes( nView ) )->cCondEnt ) }
         :nWidth           := 200
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Creación/Modificación"
         :bEditValue       := {|| dtoc( ( D():PedidosClientes( nView ) )->dFecCre ) + space( 1 ) + ( D():PedidosClientes( nView ) )->cTimCre }
         :nWidth           := 120
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Nombre establecimiento"
         :bEditValue       := {|| retfld( ( D():PedidosClientes( nView ) )->cCodCli, D():Clientes( nView ), "NbrEst" ) }
         :nWidth           := 120
         :lHide            := .t.
      end with

      oDetCamposExtra:addCamposExtra( oWndBrw )

   	oWndBrw:cHtmlHelp    := "Pedidos a clientes"
    
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
      TOOLTIP  "(Z)oom" ;
      HOTKEY   "Z" ;
      LEVEL    ACC_ZOOM

   DEFINE BTNSHELL RESOURCE "DEL" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( oWndBrw:RecDel() );
      MENU     This:Toggle() ;
      TOOLTIP  "(E)liminar";
      HOTKEY   "E";
      LEVEL    ACC_DELE

   DEFINE BTNSHELL oImp RESOURCE "IMP" GROUP OF oWndBrw ;
      NOBORDER ;
      MENU     This:Toggle() ;
      ACTION   ( GenPedCli( IS_PRINTER ), oWndBrw:Refresh() ) ;
      TOOLTIP  "(I)mprimir";
      HOTKEY   "I";
      LEVEL    ACC_IMPR

      lGenPedCli( oWndBrw:oBrw, oImp, IS_PRINTER ) ;

   DEFINE BTNSHELL RESOURCE "GC_PRINTER2_" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( ImprimirSeriesPedidosClientes() ) ;
      TOOLTIP  "Imp(r)imir series";
      HOTKEY   "R";
      LEVEL    ACC_IMPR

   DEFINE BTNSHELL oPrv RESOURCE "PREV1" OF oWndBrw ;
      NOBORDER ;
      MENU     This:Toggle() ;
      ACTION   ( GenPedCli( IS_SCREEN ), oWndBrw:Refresh() ) ;
      TOOLTIP  "(P)revisualizar";
      HOTKEY   "P";
      LEVEL    ACC_IMPR

      lGenPedCli( oWndBrw:oBrw, oPrv, IS_SCREEN ) ;

   DEFINE BTNSHELL oPdf RESOURCE "DOCLOCK" OF oWndBrw ;
      NOBORDER ;
      MENU     This:Toggle() ;
      ACTION   ( GenPedCli( IS_PDF ) ) ;
      TOOLTIP  "Pd(f)";
      HOTKEY   "F";
      LEVEL    ACC_IMPR

      lGenPedCli( oWndBrw:oBrw, oPdf, IS_PDF ) ;

   DEFINE BTNSHELL oMail RESOURCE "GC_MAIL_EARTH_" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( oMailing:documentsDialog( oWndBrw:oBrw:aSelected ) ) ;
      TOOLTIP  "Correo electrónico";
      LEVEL    ACC_IMPR

     DEFINE BTNSHELL RESOURCE "gc_portable_barcode_scanner_" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( TLabelGeneratorPedidoClientes():New( nView ):Dialog() ) ;
         TOOLTIP  "Eti(q)uetas" ;
         HOTKEY   "Q";
         LEVEL    ACC_IMPR

   DEFINE BTNSHELL RESOURCE "gc_money2_" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( WinAppRec( oWndBrw:oBrw, bEdtPgo, D():PedidosClientesPagos( nView ) ) ) ;
      TOOLTIP  "Entregas a (c)uenta" ;
      HOTKEY   "C";
      LEVEL    ACC_APPD

   if oUser():lAdministrador()

      DEFINE BTNSHELL oChangeState RESOURCE "CHGSTATE" OF oWndBrw ;
         NOBORDER ;
         MENU     This:Toggle() ;
         ACTION   ( ChgSta( oWndBrw:oBrw ) ) ;
         TOOLTIP  "Cambiar es(t)ado" ;
         HOTKEY   "T";
         LEVEL    ACC_EDIT

      DEFINE BTNSHELL RESOURCE "CHGSTATE" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( oStock:SetEstadoPedCli( D():PedidosClientesId( nView ), oWndBrw:Refresh() ) );
         TOOLTIP  "(R)ecalcular estado" ;
         HOTKEY   "R";
         FROM     oChangeState ;
         CLOSED ;
         LEVEL    ACC_EDIT

   end if

   DEFINE BTNSHELL RESOURCE "Sel" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( SelSend( oWndBrw:oBrw ) ) ;
      TOOLTIP  "(L)isto entrega" ;
      HOTKEY   "L";
      LEVEL    ACC_APPD

   DEFINE BTNSHELL oSnd RESOURCE "LBL" GROUP OF oWndBrw ;
      NOBORDER ;
      MENU     This:Toggle() ;
      TOOLTIP  "En(v)iar" ;
      MESSAGE  "Seleccionar pedidos para ser enviados" ;
      ACTION   lSnd( oWndBrw, D():PedidosClientes( nView ) ) ;
      HOTKEY   "V";
      LEVEL    ACC_EDIT

      DEFINE BTNSHELL RESOURCE "LBL" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( lSelectAll( oWndBrw, D():PedidosClientes( nView ), "lSndDoc", .t., .t., .t. ) );
         TOOLTIP  "Todos" ;
         FROM     oSnd ;
         CLOSED ;
         LEVEL    ACC_EDIT

      DEFINE BTNSHELL RESOURCE "LBL" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( lSelectAll( oWndBrw, D():PedidosClientes( nView ), "lSndDoc", .f., .t., .t. ) );
         TOOLTIP  "Ninguno" ;
         FROM     oSnd ;
         CLOSED ;
         LEVEL    ACC_EDIT

      DEFINE BTNSHELL RESOURCE "LBL" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( lSelectAll( oWndBrw, D():PedidosClientes( nView ), "lSndDoc", .t., .f., .t. ) );
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
         ACTION   ( ReplaceCreator( oWndBrw, D():PedidosClientes( nView ), aItmPedCli() ) ) ;
         TOOLTIP  "Cambiar campos" ;
         LEVEL    ACC_EDIT

         DEFINE BTNSHELL RESOURCE "BMPCHG" OF oWndBrw ;
            NOBORDER ;
         	ACTION   ( ReplaceCreator( oWndBrw, D():PedidosClientesLineas( nView ), aColPedCli() ) ) ;
            TOOLTIP  "Lineas" ;
            FROM     oRpl ;
            CLOSED ;
            LEVEL    ACC_EDIT

   end if

   DEFINE BTNSHELL RESOURCE "GC_SHOPPING_CART_" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( PedCliente2PedProveedor():New( nView, oTipArt, oFabricante, oStock ) ) ;
      TOOLTIP  "(G)enerar pedidos a proveedores" ;
      HOTKEY   "G";   

   DEFINE BTNSHELL RESOURCE "INFO" GROUP OF oWndBrw ;
      NOBORDER ;
      ACTION   ( TTrazaDocumento():Activate( PED_CLI, ( D():PedidosClientes( nView ) )->cSerPed + Str( ( D():PedidosClientes( nView ) )->nNumPed ) + ( D():PedidosClientes( nView ) )->cSufPed ) ) ;
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

      ImportScript( oWndBrw, oScript, "PedidosClientes", nView )  

   DEFINE BTNSHELL oRotor RESOURCE "ROTOR" GROUP OF oWndBrw ;
         ACTION   ( oRotor:Expand() ) ;
         TOOLTIP  "Rotor" ;

      DEFINE BTNSHELL RESOURCE "GC_USER_" OF oWndBrw ;
            ACTION   ( EdtCli( ( D():PedidosClientes( nView ) )->cCodCli ) );
            TOOLTIP  "Modificar cliente" ;
            FROM     oRotor ;

      DEFINE BTNSHELL RESOURCE "INFO" OF oWndBrw ;
            ACTION   ( InfCliente( ( D():PedidosClientes( nView ) )->cCodCli ) );
            TOOLTIP  "Informe de cliente" ;
            FROM     oRotor ;

      DEFINE BTNSHELL RESOURCE "gc_clipboard_empty_user_" OF oWndBrw ;
            ACTION   ( EdtObras( ( D():PedidosClientes( nView ) )->cCodCli, ( D():PedidosClientes( nView ) )->cCodObr, dbfObrasT ) );
            TOOLTIP  "Modificar dirección" ;
            FROM     oRotor ;

      DEFINE BTNSHELL RESOURCE "GC_NOTEBOOK_USER_" OF oWndBrw ;
            ACTION   ( if( !Empty( ( D():PedidosClientes( nView ) )->cNumPre ), ZooPreCli( ( D():PedidosClientes( nView ) )->cNumPre ), MsgStop( "El pedido no proviene de presupuesto" ) ) );
            TOOLTIP  "Visualizar presupuesto" ;
            FROM     oRotor ;

      DEFINE BTNSHELL RESOURCE "GC_DOCUMENT_EMPTY_" OF oWndBrw ;
            ALLOW    EXIT ;
            ACTION   ( if( ( D():PedidosClientes( nView ) )->nEstado != 3, AlbCli( nil, nil, { "Pedido" => ( D():PedidosClientes( nView ) )->cSerPed + Str( ( D():PedidosClientes( nView ) )->nNumPed, 9 ) + ( D():PedidosClientes( nView ) )->cSufPed } ), MsgInfo( "Pedido entregado o cancelado" ) ) );
            TOOLTIP  "Generar albarán" ;
            FROM     oRotor ;

      DEFINE BTNSHELL RESOURCE "GC_DOCUMENT_EMPTY_" OF oWndBrw ;
            NOBORDER ;
            ACTION   ( Ped2AlbCli( ( D():PedidosClientes( nView ) )->cSerPed + Str( ( D():PedidosClientes( nView ) )->nNumPed, 9 ) + ( D():PedidosClientes( nView ) )->cSufPed, dbfAlbCliT ) );
            TOOLTIP  "Modificar albarán" ;
            FROM     oRotor ;
            CLOSED ;

      DEFINE BTNSHELL RESOURCE "GC_DOCUMENT_TEXT_USER_" OF oWndBrw ;
            ALLOW    EXIT ;
            ACTION   ( if( ( D():PedidosClientes( nView ) )->nEstado <= 2, FactCli( nil, nil, { "Pedido" => ( D():PedidosClientes( nView ) )->cSerPed + Str( ( D():PedidosClientes( nView ) )->nNumPed, 9 ) + ( D():PedidosClientes( nView ) )->cSufPed } ), MsgInfo( "Pedido entregado o cancelado" ) ) );
            TOOLTIP  "Generar factura" ;
            FROM     oRotor ;

      DEFINE BTNSHELL RESOURCE "GC_DOCUMENT_TEXT_USER_" OF oWndBrw ;
            ACTION   ( Ped2FacCli( ( D():PedidosClientes( nView ) )->cSerPed + Str( ( D():PedidosClientes( nView ) )->nNumPed, 9 ) + ( D():PedidosClientes( nView ) )->cSufPed, dbfFacCliT ) );
            TOOLTIP  "Modificar factura" ;
            FROM     oRotor ;

      DEFINE BTNSHELL RESOURCE "GC_DOCUMENT_TEXT_MONEY2_" OF oWndBrw ;
            ALLOW    EXIT ;
            ACTION   ( FacAntCli( , , ( D():PedidosClientes( nView ) )->cCodCli ) );
            TOOLTIP  "Generar anticipo" ;
            FROM     oRotor ;

      DEFINE BTNSHELL RESOURCE "GC_NOTE_" OF oWndBrw ;
            ALLOW    EXIT ;
            ACTION   ( PedCliNotas() );
            TOOLTIP  "Generar nota de agenda" ;
            FROM     oRotor ;

      DEFINE BTNSHELL RESOURCE "GC_CASH_REGISTER_USER_" OF oWndBrw ;
            ALLOW    EXIT ;
            ACTION   (  if (  ( D():PedidosClientes( nView ) )->nEstado <= 1 .and. empty( ( D():PedidosClientes( nView ) )->cNumTik ),;
                              generateTicketFromDocument( { "Pedido" => D():PedidosClientesId( nView ) } ),;
                              msgStop( "Pedido albaranado, cancelado o convertido a ticket" ) ) );
            TOOLTIP  "Convertir a ticket" ;
            FROM     oRotor ;

      DEFINE BTNSHELL RESOURCE "GC_SHOPPING_CART_" OF oWndBrw ;
            ALLOW    EXIT ;
            ACTION   ( PedCliente2PedProveedor():New( nView, oTipArt, oFabricante, oStock, .t. ) ) ;
            TOOLTIP  "Generar pedido a proveedor" ;
            FROM     oRotor ;   

   DEFINE BTNSHELL RESOURCE "END" GROUP OF oWndBrw ;
      ALLOW    EXIT ;
      ACTION   ( oWndBrw:End() ) ;
      TOOLTIP  "(S)alir";
      HOTKEY   "S"

   if SQLAjustableModel():getRolNoFiltrarVentas( Auth():rolUuid() )
      oWndBrw:oActiveFilter:SetFields( aItmPedCli() ) 
      oWndBrw:oActiveFilter:SetFilterType( PED_CLI )
   end if

   if lPedWeb
      ( D():PedidosClientes( nView ) )->( OrdSetFocus( "lInternet" ) )
      ( D():PedidosClientes( nView ) )->( dbGoTop() )
   end if

   ACTIVATE SHELL oWndBrw VALID ( CloseFiles() )

   EnableAcceso()

   if !empty( oWndBrw )
   
      if uFieldempresa( 'lFltYea' )
         oWndBrw:setYearCombobox()
      end if

      if !empty( cCodCli ) .or. !empty( cCodArt ) .or. !empty( cCodPre )
         oWndBrw:RecAdd()
      end if

      cCodCli  := nil
      cCodArt  := nil
      cCodPre  := nil

   end if

Return .t.

//----------------------------------------------------------------------------//

STATIC FUNCTION EdtRec( aTmp, aGet, dbf, oBrw, cCodCli, cCodArt, nMode, cCodPre )

   local oDlg
   local oFld
   local nOrd
   local lWhen
   local oBrwLin
   local oBrwInc
   local oBrwDoc
   local oBrwPgo
   local oBrwEst
   local oSay           := Array( 11 )
   local cSay           := Array( 11 )
   local oSayLabels     := Array(  9 )
   local oGetMasDiv
   local cGetMasDiv     := ""
   local oBmpEmp
   local oBmpDiv
   local cEstPed        := ""
   local oRieCli
   local nRieCli        := 0
   local oSayGetRnt
   local cTipPed
   local cSerie         := cNewSer( "nPedCli", D():Contadores( nView ) )
   local oBmpGeneral

   lWhen                := if( oUser():lAdministrador(), ( nMode != ZOOM_MODE ), if( nMode == EDIT_MODE, !aTmp[ _LCLOPED ], ( nMode != ZOOM_MODE ) ) )

   /*
   Este valor los guaradamos para detectar los posibles cambios
   */

   cOldCodCli           := aTmp[ _CCODCLI ]

   setOldPorcentajeAgente( aTmp[ _NPCTCOMAGE ] )

   do case
      case nMode == APPD_MODE

         if !lCurSesion()
            msgStop( "No hay sesiones activas, imposible añadir documentos" )
            Return .f.
         end if

         if !lCajaOpen( Application():CodigoCaja() ) .and. !oUser():lAdministrador()
            msgStop( "Esta caja " + Application():CodigoCaja() + " esta cerrada." )
            Return .f.
         end if

         aTmp[ _CTURPED ]     := cCurSesion()
         aTmp[ _CCODALM ]     := Application():codigoAlmacen()
         aTmp[ _CCODCAJ ]     := Application():CodigoCaja()
         aTmp[ _CDIVPED ]     := cDivEmp()
         aTmp[ _CCODPGO ]     := cDefFpg()
         aTmp[ _NVDVPED ]     := nChgDiv( aTmp[ _CDIVPED ], D():Divisas( nView ) )
         aTmp[ _CSUFPED ]     := RetSufEmp()
         aTmp[ _NESTADO ]     := 1
         aTmp[ _CCODUSR ]     := Auth():Codigo()
         aTmp[ _CCODDLG ]     := Application():CodigoDelegacion()
         aTmp[ _LIVAINC ]     := uFieldEmpresa( "lIvaInc" )
         aTmp[ _CMANOBR ]     := padr( getConfigTraslation( "Gastos" ), 250 )
         aTmp[ _NIVAMAN ]     := nIva( D():TiposIva( nView ), cDefIva() )
         aTmp[ _DFECENTR]     := ctod( "" )
         aTmp[ _DFECSAL ]     := ctod( "" )

         if !empty( cCodPre )
            aTmp[ _CNUMPRE ]  := cCodPre
         end if

      case nMode == DUPL_MODE

         if !lCurSesion()
            msgStop( "No hay sesiones activas, imposible añadir documentos" )
            Return .f.
         end if

         if !lCajaOpen( Application():CodigoCaja() ) .and. !oUser():lAdministrador()
            msgStop( "Esta caja " + Application():CodigoCaja() + " esta cerrada." )
            Return .f.
         end if

         aTmp[ _DFECPED ]  := GetSysDate()
         aTmp[ _CTURPED ]  := cCurSesion()
         aTmp[ _NESTADO ]  := 1
         aTmp[ _LCLOPED ]  := .f.

      case nMode == EDIT_MODE

         if aTmp[ _LCLOPED ] .and. !oUser():lAdministrador()
            msgStop( "El pedido está cerrado." )
            Return .f.
         end if

         if aTmp[ _NESTADO ] == 3 .and. !aTmp[ _LCANCEL ]
            msgStop( "El pedido ya fue entregado." )
            Return .f.
         end if

         lChangeRegIva( aTmp )

   end case

   if empty( rtrim( aTmp[ _CSERPED ] ) )
      aTmp[ _CSERPED ]     := cSerie
   end if

   if empty( aTmp[ _NTARIFA ] )
      aTmp[ _NTARIFA ]     := Max( uFieldEmpresa( "nPreVta" ), 1 )
   end if

   if empty( aTmp[ _CDTOESP ] )
      aTmp[ _CDTOESP ]     := Padr( "General", 50 )
   end if

   if empty( aTmp[ _CDPP ] )
      aTmp[ _CDPP ]        := Padr( "Pronto pago", 50 )
   end if

   /*
   tipo de presupuesto---------------------------------------------------------
   */

   cTipPed                 := aTipPed[ if( aTmp[ _LALQUILER ], 2, 1 ) ]

   /*
   Comineza la transaccion-----------------------------------------------------
   */

   if BeginTrans( aTmp, nMode )
      Return .f.
   end if

   /*
   Mostramos datos de clientes-------------------------------------------------
   */

   if Empty( aTmp[ _CTLFCLI ] )
      aTmp[ _CTLFCLI ] := RetFld( aTmp[ _CCODCLI ], D():Clientes( nView ), "Telefono" )
   end if

   nRieCli              := oStock:nRiesgo( aTmp[ _CCODCLI ] )

   /*
   Necestamos el orden el la primera clave-------------------------------------
   */

   nOrd                 := ( D():PedidosClientes( nView ) )->( ordSetFocus( 1 ) )

   cPouDiv              := cPouDiv( aTmp[ _CDIVPED ], D():Divisas( nView ) ) // Picture de la divisa
   cPorDiv              := cPorDiv( aTmp[ _CDIVPED ], D():Divisas( nView ) ) // Picture de la divisa
   nDouDiv              := nDouDiv( aTmp[ _CDIVPED ], D():Divisas( nView ) )
   nRouDiv              := nRouDiv( aTmp[ _CDIVPED ], D():Divisas( nView ) )
   cPpvDiv              := cPpvDiv( aTmp[ _CDIVPED ], D():Divisas( nView ) ) // Picture del punto verde
   nDpvDiv              := nDpvDiv( aTmp[ _CDIVPED ], D():Divisas( nView ) ) // Decimales de redondeo del punto verde
   cPicEur              := cPouDiv( "EUR", D():Divisas( nView ) )            // Picture del euro
   cPicUnd              := MasUnd()

   cEstPed              := cEstadoPedido( aTmp[ _NESTADO ] )

   /*
   Etiquetas-------------------------------------------------------------------
   */

   cSay[ 2 ]        := RetFld( aTmp[ _CCODTAR ], dbfTarPreS )
   cSay[ 3 ]        := RetFld( aTmp[ _CCODCLI ] + aTmp[ _CCODOBR ], dbfObrasT, "cNomObr" )
   cSay[ 4 ]        := RetFld( aTmp[ _CCODALM ], dbfAlm )
   cSay[ 5 ]        := RetFld( aTmp[ _CCODPGO ], D():FormasPago( nView ) )
   cSay[ 6 ]        := cNbrAgent( aTmp[ _CCODAGE ], dbfAgent )
   cSay[ 7 ]        := RetFld( aTmp[ _CCODRUT ], dbfRuta )
   cSay[ 9 ]        := RetFld( aTmp[ _CCODCAJ ], dbfCajT )
   cSay[10 ]        := SQLUsuariosModel():getNombreWhereCodigo( aTmp[ _CCODUSR ] )
   cSay[11 ]        := RetFld( cCodEmp() + aTmp[ _CCODDLG ], dbfDelega, "cNomDlg" )

   /*
   Inicializamos el valor de la tarifa por si cambian--------------------------
   */

   InitTarifaCabecera( aTmp[ _NTARIFA ] )

   /*
   Comienza el dialogo---------------------------------------------------------
   */

   DEFINE DIALOG oDlg RESOURCE "PEDCLI" TITLE LblTitle( nMode ) + "Pedidos de clientes"

      REDEFINE FOLDER oFld;
         ID       200 ;
         OF       oDlg ;
         PROMPT   "&Pedido",;
                  "Da&tos",;
                  "&Incidencias",;
                  "D&ocumentos",;
                  "&Situaciones";
         DIALOGS  "PEDCLI_1",;
                  "PEDCLI_2",;
                  "PEDCLI_3",;
                  "PEDCLI_4",;
                  "PEDCLI_5"

      /*
		Cliente_________________________________________________________________
		*/

      REDEFINE BITMAP oBmpGeneral ;
        ID       990 ;
        RESOURCE "gc_clipboard_empty_user_48" ;
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

      REDEFINE GET aGet[ _CCODCLI ] VAR aTmp[ _CCODCLI ] ;
			ID 		130 ;
         WHEN     ( lWhen ) ;
         VALID    ( LoaCli( aGet, aTmp, nMode, oRieCli ), RecalculaTotal( aTmp ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwClient( aGet[_CCODCLI], aGet[_CNOMCLI] ) ) ;
			OF 		oFld:aDialogs[1]

      REDEFINE GET aGet[ _CNOMCLI ] VAR aTmp[ _CNOMCLI ] ;
			ID 		131 ;
         WHEN     ( lWhen .and. ( !aTmp[ _LMODCLI ] .or. oUser():lAdministrador() ) ) ;
			OF 		oFld:aDialogs[1]

      REDEFINE GET aGet[ _CDNICLI ] VAR aTmp[ _CDNICLI ] ;
         ID       101 ;
         WHEN     ( lWhen .and. ( !aTmp[ _LMODCLI ] .or. oUser():lAdministrador() ) ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CDIRCLI ] VAR aTmp[ _CDIRCLI ] ;
         ID       102 ;
         BITMAP   "gc_earth_lupa_16" ;
         ON HELP  GoogleMaps( aTmp[ _CDIRCLI ], Rtrim( aTmp[ _CPOBCLI ] ) + Space( 1 ) + Rtrim( aTmp[ _CPRVCLI ] ) ) ;
         WHEN     ( lWhen .and. ( !aTmp[ _LMODCLI ] .or. oUser():lAdministrador() ) ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CPOBCLI ] VAR aTmp[ _CPOBCLI ] ;
         ID       103 ;
         WHEN     ( lWhen .and. ( !aTmp[ _LMODCLI ] .or. oUser():lAdministrador() ) ) ;
         OF       oFld:aDialogs[1]

		REDEFINE GET aGet[ _CPRVCLI ] VAR aTmp[ _CPRVCLI ] ;
         ID       104 ;
         WHEN     ( lWhen .and. ( !aTmp[ _LMODCLI ] .or. oUser():lAdministrador() ) ) ;
         OF       oFld:aDialogs[1]

		REDEFINE GET aGet[ _CPOSCLI ] VAR aTmp[ _CPOSCLI ] ;
         ID       107 ;
         WHEN     ( lWhen .and. ( !aTmp[ _LMODCLI ] .or. oUser():lAdministrador() ) ) ;
         VALID    ( CodigosPostales():GetInstance():validCodigoPostal() );
         OF       oFld:aDialogs[1]

         // tarifa

      oGetTarifa  := comboTarifa():Build( { "idCombo" => 132, "uValue" => aTmp[ _NTARIFA ] } )
      oGetTarifa:Resource( oFld:aDialogs[1] )

      REDEFINE BTNBMP oBtnPrecio ;
         ID       174 ;
         OF       oFld:aDialogs[1] ;
         RESOURCE "gc_arrow_down_16" ;
         NOBORDER ;
         ACTION   ( ChangeTarifaCabecera( oGetTarifa:getTarifa(), dbfTmpLin, oBrwLin ) );
         WHEN     ( nMode != ZOOM_MODE .and. ( SQLAjustableModel():getRolCambiarPrecios( Auth():rolUuid() ) ) )

      REDEFINE GET oRieCli VAR nRieCli;
         ID       133 ;
         WHEN     ( nMode != ZOOM_MODE );
         PICTURE  cPorDiv ;
			OF 		oFld:aDialogs[1]

      REDEFINE GET aGet[_CTLFCLI] VAR aTmp[_CTLFCLI] ;
         ID       106 ;
         COLOR    CLR_GET ;
         WHEN     ( lWhen .and. ( !aTmp[ _LMODCLI ] .or. oUser():lAdministrador() ) ) ;
         OF       oFld:aDialogs[1]

      /*
		Tarifa_________________________________________________________________
		*/

      REDEFINE GET aGet[ _CCODTAR ] VAR aTmp[ _CCODTAR ] ;
			ID 		140 ;
         WHEN     ( lWhen .and. oUser():lAdministrador() ) ;
         VALID    ( cTarifa( aGet[_CCODTAR], oSay[ 2 ] ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwTarifa( aGet[_CCODTAR], oSay[ 2 ] ) ) ;
			COLOR 	CLR_GET ;
			OF 		oFld:aDialogs[1]

      REDEFINE GET oSay[ 2 ] VAR cSay[ 2 ] ;
			WHEN 		.F. ;
			ID 		141 ;
			OF 		oFld:aDialogs[1]

		/*
		Obra____________________________________________________________________
		*/

      REDEFINE GET aGet[ _CCODOBR ] VAR aTmp[ _CCODOBR ] ;
			ID 		150 ;
         WHEN     ( lWhen ) ;
         VALID    ( cObras( aGet[ _CCODOBR ], oSay[ 3 ], aTmp[ _CCODCLI ] ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwObras( aGet[ _CCODOBR ], oSay[ 3 ], aTmp[ _CCODCLI ], dbfObrasT ) ) ;
			COLOR 	CLR_GET ;
			OF 		oFld:aDialogs[1]

      REDEFINE GET oSay[ 3 ] VAR cSay[ 3 ] ;
         WHEN     .f. ;
			ID 		151 ;
			OF 		oFld:aDialogs[1]

		/*
		Almacen________________________________________________________________
		*/

      REDEFINE GET aGet[ _CCODALM ] VAR aTmp[ _CCODALM ] ;
			ID 		160 ;
         WHEN     ( lWhen ) ;
         VALID    ( cAlmacen( aGet[ _CCODALM ], , oSay[ 4 ] ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwAlmacen( aGet[ _CCODALM ], oSay[ 4 ] ) ) ;
			OF 		oFld:aDialogs[1]

      REDEFINE GET oSay[ 4 ] VAR cSay[ 4 ] ;
         ID       161 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         BITMAP   "Bot" ;
         ON HELP  ( ExpAlmacen( aTmp[ _CCODALM ], dbfTmpLin, oBrwLin ) ) ;
         OF       oFld:aDialogs[1]

		/*
		Forma de Pago__________________________________________________________
		*/

      REDEFINE GET aGet[ _CCODPGO ] VAR aTmp[ _CCODPGO ] ;
			ID 		170 ;
         WHEN     ( if( IsMuebles(), .t., lWhen ) );
         VALID    ( cFPago( aGet[_CCODPGO], , oSay[ 5 ] ) ) ;
         PICTURE  "@!" ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwFPago( aGet[ _CCODPGO ], oSay[ 5 ] ) ) ;
			OF 		oFld:aDialogs[1]

      REDEFINE GET oSay[ 5 ] VAR cSay[ 5 ] ;
			WHEN 		.F. ;
			ID 		171 ;
			OF 		oFld:aDialogs[1]

      /*
      Banco del cliente--------------------------------------------------------
      oGet, oEntBnc, oSucBnc, oDigBnc, oCtaBnc, cCodCli, dbfBancos
      */

      REDEFINE GET aGet[ _CBANCO ] VAR aTmp[ _CBANCO ];
         ID       410 ;
         WHEN     ( lWhen );
         BITMAP   "LUPA" ;
         ON HELP  ( BrwBncCli( aGet[ _CBANCO ], aGet[ _CPAISIBAN ], aGet[ _CCTRLIBAN ], aGet[ _CENTBNC ], aGet[ _CSUCBNC ], aGet[ _CDIGBNC ], aGet[ _CCTABNC ], aTmp[ _CCODCLI ] ) );
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CPAISIBAN ] VAR aTmp[ _CPAISIBAN ] ;
         PICTURE  "@!" ;
         ID       424 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( lIbanDigit( aTmp[ _CPAISIBAN ], aTmp[ _CENTBNC ], aTmp[ _CSUCBNC ], aTmp[ _CDIGBNC ], aTmp[ _CCTABNC ], aGet[ _CCTRLIBAN ] ) ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CCTRLIBAN ] VAR aTmp[ _CCTRLIBAN ] ;
         ID       425 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( lIbanDigit( aTmp[ _CPAISIBAN ], aTmp[ _CENTBNC ], aTmp[ _CSUCBNC ], aTmp[ _CDIGBNC ], aTmp[ _CCTABNC ], aGet[ _CCTRLIBAN ] ) ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CENTBNC ] VAR aTmp[ _CENTBNC ];
         ID       420 ;
         WHEN     ( lWhen );
         VALID    ( 	lCalcDC( aTmp[ _CENTBNC ], aTmp[ _CSUCBNC ], aTmp[ _CDIGBNC ], aTmp[ _CCTABNC ], aGet[ _CDIGBNC ] ),;
         				aGet[ _CPAISIBAN ]:lValid() ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CSUCBNC ] VAR aTmp[ _CSUCBNC ];
         ID       421 ;
         WHEN     ( lWhen );
         VALID    ( 	lCalcDC( aTmp[ _CENTBNC ], aTmp[ _CSUCBNC ], aTmp[ _CDIGBNC ], aTmp[ _CCTABNC ], aGet[ _CDIGBNC ] ),;
         				aGet[ _CPAISIBAN ]:lValid() ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CDIGBNC ] VAR aTmp[ _CDIGBNC ];
         ID       422 ;
         WHEN     ( lWhen );
         VALID    ( 	lCalcDC( aTmp[ _CENTBNC ], aTmp[ _CSUCBNC ], aTmp[ _CDIGBNC ], aTmp[ _CCTABNC ], aGet[ _CDIGBNC ] ),;
         				aGet[ _CPAISIBAN ]:lValid() ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CCTABNC ] VAR aTmp[ _CCTABNC ];
         ID       423 ;
         WHEN     ( lWhen );
         PICTURE  "9999999999" ;
         VALID    ( 	lCalcDC( aTmp[ _CENTBNC ], aTmp[ _CSUCBNC ], aTmp[ _CDIGBNC ], aTmp[ _CCTABNC ], aGet[ _CDIGBNC ] ),;
         				aGet[ _CPAISIBAN ]:lValid() ) ;
         OF       oFld:aDialogs[1]

		/*
		Agente_________________________________________________________________
		*/

      REDEFINE GET aGet[ _CCODAGE ] VAR aTmp[ _CCODAGE ] ;
			ID 		180 ;
         WHEN     ( lWhen ) ;
         VALID    ( LoadAgente( aGet[ _CCODAGE ], dbfAgent, oSay[ 6 ], aGet[ _NPCTCOMAGE ], dbfAgeCom, dbfTmpLin, oBrwLin ), RecalculaTotal( aTmp ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwAgentes( aGet[ _CCODAGE ], oSay[ 6 ] ) ) ;
			OF 		oFld:aDialogs[1]

      REDEFINE GET oSay[ 6 ] VAR cSay[ 6 ] ;
			ID 		181 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         BITMAP   "Bot" ;
         ON HELP  ( changeAgentPercentageInAllLines(aTmp[ _NPCTCOMAGE ], dbfTmpLin, oBrwLin ), RecalculaTotal( aTmp ) ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _NPCTCOMAGE ] VAR aTmp[ _NPCTCOMAGE ] ;
         WHEN     ( !Empty( aTmp[ _CCODAGE] ) .AND. lWhen ) ;
         VALID    ( validateAgentPercentage( aGet[ _NPCTCOMAGE ], dbfTmpLin, oBrwLin ), RecalculaTotal( aTmp ) ) ;
         PICTURE  "@E 99.99" ;
         SPINNER;
			ID 		182 ;
			OF 		oFld:aDialogs[1]

      REDEFINE GET oGetAge VAR nTotAge ;
			ID 		183 ;
         WHEN     ( .f. );
			OF 		oFld:aDialogs[1]

      /*
		Ruta____________________________________________________________________
		*/

      REDEFINE GET aGet[ _CCODRUT ] VAR aTmp[ _CCODRUT ] ;
         ID       185 ;
			COLOR 	CLR_GET ;
         WHEN     ( lWhen ) ;
         VALID    ( cRuta( aGet[ _CCODRUT ], dbfRuta, oSay[ 7 ] ) );
         BITMAP   "LUPA" ;
         ON HELP  ( BrwRuta( aGet[ _CCODRUT ], dbfRuta, oSay[ 7 ] ) );
         OF       oFld:aDialogs[1]

      REDEFINE GET oSay[ 7 ] VAR cSay[ 7 ] ;
         ID       186 ;
			WHEN 		.F. ;
			COLOR 	CLR_GET ;
         OF       oFld:aDialogs[1]

		/*
		Divisa____________________________________________________________________
		*/

		REDEFINE GET aGet[ _CDIVPED ] VAR aTmp[ _CDIVPED ];
         WHEN     (  nMode == APPD_MODE .AND. ( dbfTmpLin )->( LastRec() ) == 0 ) ;
         VALID    (  cDivOut( aGet[ _CDIVPED ], oBmpDiv, aGet[ _NVDVPED ], @cPouDiv, @nDouDiv, @cPorDiv, @nRouDiv, @cPpvDiv, @nDpvDiv, oGetMasDiv, D():Divisas( nView ), oBandera ) );
			PICTURE	"@!";
			ID 		200 ;
			COLOR 	CLR_GET ;
         BITMAP   "LUPA" ;
         ON HELP  BrwDiv( aGet[ _CDIVPED ], oBmpDiv, aGet[ _NVDVPED ], D():Divisas( nView ), oBandera ) ;
			OF 		oFld:aDialogs[1]

		REDEFINE BITMAP oBmpDiv ;
         RESOURCE "BAN_EURO" ;
			ID 		201;
			OF 		oFld:aDialogs[1]

      /*
      REDEFINE GET aGet[ _NVDVPED ] VAR aTmp[ _NVDVPED ];
			WHEN		( .F. ) ;
			ID 		202 ;
			VALID		( aTmp[ _NVDVPED ] > 0 ) ;
			PICTURE	"@E 999,999.9999" ;
			COLOR 	CLR_GET ;
			OF 		oFld:aDialogs[1]

      Bitmap________________________________________________________________
		*/

      REDEFINE BITMAP oBmpEmp ;
         FILE     "Bmp\ImgPedCli.bmp" ;
         ID       500 ;
         OF       oDlg ;

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
      oBrwLin:cName           := "Pedido a cliente.Detalle"

      oBrwLin:CreateFromResource( 210 )

      with object ( oBrwLin:AddCol() )
         :cHeader             := "Oferta"
         :bStrData            := {|| "" }
         :bEditValue          := {|| ( dbfTmpLin )->lLinOfe }
         :nWidth              := 50
         :lHide               := .t.
         :SetCheck( { "gc_check_12", "nil16" } )
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader             := "Re. Recibido"
         :bStrData            := {|| "" }
         :bBmpData            := {|| nEstadoUnidadesRecibidasPedidosClientes( D():PedidosProveedoresLineas( nView ), dbfAlbPrvL, dbfTmpLin ) }
         :nWidth              := 20
         :lHide               := .t.
         :AddResource( "gc_delete_12" )
         :AddResource( "gc_shape_square_12" )
         :AddResource( "gc_check_12" )
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader             := "Pr. Estado producción"
         :bStrData            := {|| "" }
         :bBmpData            := {|| Min( Max( ( dbfTmpLin )->nProduc + 1, 1 ), 3 ) }
         :nWidth              := 20
         :lHide               := .t.
         :AddResource( "gc_check_12" )
         :AddResource( "gc_shape_square_12" )
         :AddResource( "gc_delete_12" )
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader             := "En. Entregado"
         :bStrData            := {|| "" }
         :bBmpData            := {|| nEstadoUnidadesEntregadasPedidosClientes( dbfTmpLin, dbfAlbCliL ) }
         :nWidth              := 20
         :lHide               := .t.
         :AddResource( "gc_delete_12" )
         :AddResource( "gc_shape_square_12" )
         :AddResource( "gc_check_12" )
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader             := "Número"
         :cSortOrder          := "nNumLin"
         :bEditValue          := {|| ( dbfTmpLin )->nNumLin }
         :bLClickHeader       := {| nMRow, nMCol, nFlags, oCol | if( !empty( oCol ), oCol:SetOrder(), ) }
         :cEditPicture        := "9999"
         :nWidth              := 54
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
         :lHide 					:= .t.
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader             := "Número Kit"
         :bEditValue          := {|| ( dbfTmpLin )->nNumKit }
         :cEditPicture        := "9999"
         :nWidth              := 55
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
         :nWidth              := 54
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
      end with 
     
      with object ( oBrwLin:AddCol() )
         :cHeader             := "Código"
         :cSortOrder          := "cRef"
         :bEditValue          := {|| ( dbfTmpLin )->cRef }
         :bLClickHeader       := {| nMRow, nMCol, nFlags, oCol | if( !empty( oCol ), oCol:SetOrder(), ) }
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
         :cSortOrder          := "cDetalle"
         :bEditValue          := {|| if( Empty( ( dbfTmpLin )->cRef ), ( dbfTmpLin )->mLngDes, ( dbfTmpLin )->cDetalle ) }
         :bLClickHeader       := {| nMRow, nMCol, nFlags, oCol | if( !empty( oCol ), oCol:SetOrder(), ) }         
         :nWidth              := 250
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader             := "Última venta"
         :cSortOrder          := "dFecUltCom"
         :bEditValue          := {|| Dtoc( ( dbfTmpLin )->dFecUltCom ) }
         :nWidth              := 80
         :lHide               := .t.
         :bLClickHeader       := {| nMRow, nMCol, nFlags, oCol | if( !empty( oCol ), oCol:SetOrder(), ) }         
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader             := "Última unidades"
         :cSortOrder          := "nUniUltCom"
         :bEditValue          := {|| ( dbfTmpLin )->nUniUltCom }
         :cEditPicture        := MasUnd()
         :nWidth              := 60
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
         :lHide               := .t.
         :nFooterType         := AGGR_SUM
         :bLClickHeader       := {| nMRow, nMCol, nFlags, oCol | if( !empty( oCol ), oCol:SetOrder(), ) }         
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader             := "Último precio"
         :bEditValue          := {|| ( dbfTmpLin )->nPrcUltCom }
         :cEditPicture        := cPouDiv
         :nWidth              := 60
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
         :lHide               := .t.
         :nFooterType         := AGGR_SUM
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader             := "Prop. 1"
         :bEditValue          := {|| alltrim( ( dbfTmpLin )->cValPr1 ) }
         :nWidth              := 40
         :lHide               := .t.
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader             := "Valor prop. 1"
         :bEditValue          := {|| nombrePropiedad( ( dbfTmpLin )->cCodPr1, ( dbfTmpLin )->cValPr1, nView ) }
         :nWidth              := 40
         :lHide               := .t.
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader             := "Prop. 2"
         :bEditValue          := {|| alltrim( ( dbfTmpLin )->cValPr2 ) }
         :nWidth              := 40
         :lHide               := .t.
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader             := "Valor prop. 2"
         :bEditValue          := {|| nombrePropiedad( ( dbfTmpLin )->cCodPr2, ( dbfTmpLin )->cValPr2, nView ) }
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
         :bEditValue          := {|| NotCaja( ( dbfTmpLin )->nCanPed ) }
         :cEditPicture        := cPicUnd
         :nWidth              := 60
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
         :lHide               := .t.
         :nFooterType         := AGGR_SUM
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader             := cNombreUnidades()
         :cSortOrder          := "nUniCaja"
         :bEditValue          := {|| ( dbfTmpLin )->nUniCaja }
         :cEditPicture        := cPicUnd
         :nWidth              := 60
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
         :lHide               := .t.
         :nEditType           := 1
         :bOnPostEdit         := {|o,x,n| ChangeUnidades( o, x, n, aTmp, dbfTmpLin ) }
         :nFooterType         := AGGR_SUM
         :bLClickHeader       := {| nMRow, nMCol, nFlags, oCol | if( !empty( oCol ), oCol:SetOrder(), ) }         
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader             := "Sumar unidades"
         :bStrData            := {|| "" }
         :bOnPostEdit         := {|| .t. }
         :bEditBlock          := {|| SumaUnidadLinea( aTmp ) }
         :nEditType           := 5
         :nWidth              := 20
         :nHeadBmpNo          := 1
         :nBtnBmp             := 1
         :nHeadBmpAlign       := 1
         :AddResource( "gc_navigate_plus_16" )
         :lHide               := .t.
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader             := "Restar unidades"
         :bStrData            := {|| "" }
         :bOnPostEdit         := {|| .t. }
         :bEditBlock          := {|| RestaUnidadLinea( aTmp ) }
         :nEditType           := 5
         :nWidth              := 20
         :nHeadBmpNo          := 1
         :nBtnBmp             := 1
         :nHeadBmpAlign       := 1
         :AddResource( "gc_navigate_minus_16" )
         :lHide               := .t.
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader             := "Total " + cNombreUnidades()
         :bEditValue          := {|| nTotNPedCli( dbfTmpLin ) } 
         :cEditPicture        := cPicUnd
         :nWidth              := 80
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
         :nFooterType         := AGGR_SUM
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader             := "Total entregadas"
         :bEditValue          := {|| nUnidadesRecibidasAlbaranesClientes( ( dbfTmpLin )->cSerPed + Str( ( dbfTmpLin )->nNumPed ) + ( dbfTmpLin )->cSufPed, ( dbfTmpLin )->cRef, ( dbfTmpLin )->cValPr1, ( dbfTmpLin )->cValPr2, dbfAlbCliL ) }
         :cEditPicture        := cPicUnd
         :nWidth              := 60
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
         :lHide               := .t.
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader             := "Unidad de medición"
         :bEditValue          := {|| ( dbfTmpLin )->cUnidad }
         :nWidth              := 24
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader             := "Alm."
         :bEditValue          := {|| ( dbfTmpLin )->cAlmLin }
         :nWidth              := 30
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader             := "Precio"
         :bEditValue          := {|| nTotUPedCli( dbfTmpLin, nDouDiv ) }
         :cEditPicture        := cPouDiv
         :nWidth              := 70
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
         :nEditType     	   := 1
         :bOnPostEdit   	   := {|o,x,n| ChangePrecio( o, x, n, aTmp, dbfTmpLin ) }
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader             := "% Dto."
         :bEditValue          := {|| ( dbfTmpLin )->nDto }
         :cEditPicture        := "@E 999.99"
         :nWidth              := 52
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader             := "Dto. Lin."
         :bEditValue          := {|| nDtoUPedCli( dbfTmpLin, nDouDiv ) }
         :cEditPicture        := cPouDiv
         :nWidth              := 50
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
         :lHide               := .t.
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader             := "% Prm."
         :bEditValue          := {|| ( dbfTmpLin )->nDtoPrm }
         :cEditPicture        := "@E 99.99"
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
         :nWidth              := 44
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader             := "Portes"
         :bEditValue          := {|| nTrnUPedCli( dbfTmpLin, nDouDiv ) }
         :cEditPicture        := cPouDiv
         :nWidth              := 70
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
         :lHide               := .t.
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader             := "P. verde"
         :bEditValue          := {|| nPntUPedCli( dbfTmpLin, nDpvDiv ) }
         :cEditPicture        := cPouDiv
         :nWidth              := 70
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
         :lHide               := .t.
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader             := "Total"
         :bEditValue          := {|| nTotLPedCli( dbfTmpLin, nDouDiv, nRouDiv, , , aTmp[ _LOPERPV ] ) }
         :cEditPicture        := cPorDiv
         :nWidth              := 80
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
         :nFooterType         := AGGR_SUM
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader             := "Dirección"
         :bEditValue          := {|| ( dbfTmpLin )->cObrLin + Space( 1 ) + RetFld( aTmp[ _CCODCLI ] + ( dbfTmpLin )->cObrLin, dbfObrasT, "cNomObr" ) }
         :nWidth              := 250
         :lHide               := .t.
      end with

      if nMode != ZOOM_MODE
         oBrwLin:bLDblClick  := {|| EdtDeta( oBrwLin, bEdtDet, aTmp ) }
      end if

      /*
		Descuentos______________________________________________________________
		*/

      REDEFINE GET aGet[ _CDTOESP ] VAR aTmp[ _CDTOESP ] ;
         ID       219 ;
         WHEN     ( lWhen ) ;
         OF       oFld:aDialogs[ 1 ]

      REDEFINE GET aGet[ _NDTOESP ] VAR aTmp[ _NDTOESP ] ;
			ID 		220 ;
			PICTURE 	"@E 99.99" ;
         SPINNER ;
         VALID    ( RecalculaTotal( aTmp ) );
         ON CHANGE( RecalculaTotal( aTmp ) );
         WHEN     ( lWhen ) ;
         OF       oFld:aDialogs[ 1 ]

      REDEFINE GET aGet[ _CDPP ] VAR aTmp[ _CDPP ] ;
         ID       229 ;
         WHEN     ( lWhen ) ;
         OF       oFld:aDialogs[ 1 ]

		REDEFINE GET aGet[ _NDPP ] VAR aTmp[ _NDPP ];
			ID 		230 ;
			PICTURE 	"@E 99.99" ;
         SPINNER ;
         COLOR    CLR_GET ;
         VALID    ( RecalculaTotal( aTmp ) );
         ON CHANGE( RecalculaTotal( aTmp ) );
         WHEN     ( lWhen ) ;
			OF 		oFld:aDialogs[1]

		REDEFINE GET aGet[ _CDTOUNO ] VAR aTmp[ _CDTOUNO ] ;
			ID 		240 ;
			COLOR 	CLR_GET ;
         WHEN     ( lWhen ) ;
			OF 		oFld:aDialogs[1]

		REDEFINE GET aGet[ _NDTOUNO ] VAR aTmp[ _NDTOUNO ];
			ID 		250 ;
			PICTURE 	"@E 99.99" ;
         SPINNER ;
         COLOR    CLR_GET ;
         VALID    ( RecalculaTotal( aTmp ) );
         ON CHANGE( RecalculaTotal( aTmp ) );
         WHEN     ( lWhen ) ;
			OF 		oFld:aDialogs[1]

      REDEFINE GET aGet[ _CDTODOS ] VAR aTmp[ _CDTODOS ] ;
         ID       260 ;
			PICTURE 	"@!" ;
         COLOR    CLR_GET ;
         WHEN     ( lWhen ) ;
			OF 		oFld:aDialogs[1]

      REDEFINE GET aGet[ _NDTODOS ] VAR aTmp[ _NDTODOS ];
         ID       270 ;
			PICTURE 	"@E 99.99" ;
         SPINNER ;
         COLOR    CLR_GET ;
         VALID    ( RecalculaTotal( aTmp ) );
         ON CHANGE( RecalculaTotal( aTmp ) );
         WHEN     ( lWhen ) ;
			OF 		oFld:aDialogs[1]

		/*
      Cajas para el desglose de impuestos--------------------------------------------
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
         :cHeader          := "%" + cImp()
         :bStrData         := {|| if( !IsNil( aTotIva[ oBrwIva:nArrayAt, 3 ] ), aTotIva[ oBrwIva:nArrayAt, 3 ], "" ) }
         :bEditValue       := {|| aTotIva[ oBrwIva:nArrayAt, 3 ] }
         :nWidth           := 44
         :cEditPicture     := "@E 999.99"
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
         :nFootStrAlign    := 1
         :nEditType        := 1
         :bEditWhen        := {|| !IsNil( aTotIva[ oBrwIva:nArrayAt, 3 ] ) }
         :bOnPostEdit      := {|o,x| EdtIva( o, x, aTotIva[ oBrwIva:nArrayAt, 3 ], dbfTmpLin, D():TiposIva( nView ), oBrwLin ), RecalculaTotal( aTmp ) }
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
         :bStrData         := {|| if( aTotIva[ oBrwIva:nArrayAt, 3 ] != nil .and. aTmp[ _LRECARGO ], Trans( aTotIva[ oBrwIva:nArrayAt, 4 ], "@E 99.9"), "" ) }
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
         WHEN     ( lWhen ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _NIVAMAN ] VAR aTmp[ _NIVAMAN ] ;
         ID       412 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  "@E 99.99" ;
         VALID    ( lTiva( D():TiposIva( nView ), aTmp[ _NIVAMAN ] ) );
         ON CHANGE( nTotPedCli( nil, D():PedidosClientes( nView ), dbfTmpLin, D():TiposIva( nView ), D():Divisas( nView ), D():FormasPago( nView ), aTmp ) );
         BITMAP   "LUPA" ;
         ON HELP  ( BrwIva( aGet[ _NIVAMAN ], D():TiposIva( nView ), , .t. ) );
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _NMANOBR ] VAR aTmp[ _NMANOBR ] ;
         ID       400 ;
         PICTURE  cPorDiv ;
         WHEN     ( lWhen ) ;
         VALID    ( nTotPedCli( nil, D():PedidosClientes( nView ), dbfTmpLin, D():TiposIva( nView ), D():Divisas( nView ), D():FormasPago( nView ), aTmp ), .t. ) ;
         ON CHANGE( nTotPedCli( nil, D():PedidosClientes( nView ), dbfTmpLin, D():TiposIva( nView ), D():Divisas( nView ), D():FormasPago( nView ), aTmp ) );
         OF       oFld:aDialogs[1]

      REDEFINE SAY oGetNet VAR nTotNet ;
         ID       401 ;
         OF 		oFld:aDialogs[1]

      REDEFINE SAY oGetTrn VAR nTotTrn ;
         ID       402 ;
         OF       oFld:aDialogs[1]

      REDEFINE SAY oGetIvm VAR nTotIvm ;
         ID       403 ;
         OF       oFld:aDialogs[1]

      REDEFINE CHECKBOX aGet[ _LOPERPV ] VAR aTmp[ _LOPERPV  ] ;
         ID       409 ;
         WHEN     ( lWhen ) ;
         ON CHANGE( RecalculaTotal( aTmp ), oBrwLin:Refresh() );
         OF       oFld:aDialogs[1]

      REDEFINE SAY oGetPnt VAR nTotPnt ;
         ID       404 ;
         OF       oFld:aDialogs[1]

      REDEFINE SAY oSayGetRnt ;
         ID       709 ;
         OF       oFld:aDialogs[1]

      REDEFINE GET oGetRnt VAR nTotRnt ;
         ID       408 ;
         OF       oFld:aDialogs[ 1 ]

      REDEFINE SAY oGetIva VAR nTotIva ;
         ID       405 ;
         OF       oFld:aDialogs[ 1 ]

      REDEFINE CHECKBOX aGet[ _LRECARGO ] VAR aTmp[ _LRECARGO ] ;
         ID       406 ;
         WHEN     ( lWhen ) ;
         ON CHANGE( RecalculaTotal( aTmp ) );
         OF       oFld:aDialogs[1]

      REDEFINE CHECKBOX oImpuestos VAR lImpuestos ;
         ID       711 ;
         WHEN     ( .f.) ;
         OF       oFld:aDialogs[1]

      REDEFINE SAY oGetReq VAR nTotReq ;
         ID       407 ;
			OF 		oFld:aDialogs[1]

      REDEFINE SAY oGetTotal VAR nTotPed ;
			ID 		470 ;
			FONT 		oFont ;
			OF 		oFld:aDialogs[1]

		/*
		Botones de la caja de dialogo___________________________________________
		*/

      REDEFINE BUTTON ;
			ID 		515 ;
			OF 		oFld:aDialogs[1] ;
         WHEN     ( lWhen ) ;
         ACTION   ( AppDeta( oBrwLin, bEdtDet, aTmp, .t. ) )

		REDEFINE BUTTON ;
			ID 		500 ;
			OF 		oFld:aDialogs[1] ;
         WHEN     ( lWhen ) ;
         ACTION   ( AppDeta( oBrwLin, bEdtDet, aTmp) )

		REDEFINE BUTTON ;
			ID 		501 ;
			OF 		oFld:aDialogs[1] ;
         WHEN     ( lWhen ) ;
         ACTION   ( EdtDeta( oBrwLin, bEdtDet, aTmp ) )

		REDEFINE BUTTON ;
			ID 		502 ;
			OF 		oFld:aDialogs[1] ;
         WHEN     ( lWhen ) ;
         ACTION   ( DelDeta( oBrwLin ), RecalculaTotal( aTmp ) )

		REDEFINE BUTTON ;
			ID 		503 ;
			OF 		oFld:aDialogs[1] ;
         ACTION   ( WinZooRec( oBrwLin, bEdtDet, dbfTmpLin, nil, nil, aTmp ) )

		REDEFINE BUTTON ;
			ID 		524 ;
			OF 		oFld:aDialogs[1] ;
         WHEN     ( lWhen ) ;
         ACTION   ( LineUp( dbfTmpLin, oBrwLin ) )
      //   ACTION   ( DbSwapUp( dbfTmpLin, oBrwLin ) )

		REDEFINE BUTTON ;
			ID 		525 ;
			OF 		oFld:aDialogs[1] ;
         WHEN     ( lWhen ) ;
         ACTION   ( LineDown( dbfTmpLin, oBrwLin ) )
      //   ACTION   ( DbSwapDown( dbfTmpLin, oBrwLin ) )

      REDEFINE BUTTON oBtnKit;
        ID       	526 ;
		OF 			oFld:aDialogs[1] ;
        ACTION   	( lEscandalloEdtRec( .t., oBrwLin ) )

	  REDEFINE BUTTON oBtnAtp;
        ID       	527 ;
        OF       	oFld:aDialogs[1] ;
        ACTION   	( CargaAtipicasCliente( aTmp, oBrwLin, oDlg ) )
	
	  REDEFINE BUTTON ;
        ID          528 ;
        OF          oFld:aDialogs[1] ;
        ACTION      ( importarArticulosScaner() )

      REDEFINE GET aGet[_CSERPED] VAR aTmp[_CSERPED] ;
         ID       90 ;
         PICTURE  "@!" ;
			COLOR 	CLR_GET ;
         SPINNER ;
         ON UP    ( UpSerie( aGet[_CSERPED] ) );
         ON DOWN  ( DwSerie( aGet[ _CSERPED] ) );
         WHEN     ( nMode == APPD_MODE .OR. nMode == DUPL_MODE );
         VALID    ( aTmp[_CSERPED] >= "A" .AND. aTmp[_CSERPED] <= "Z"  );
         OF       oFld:aDialogs[1]

		REDEFINE GET aGet[_NNUMPED] VAR aTmp[_NNUMPED];
			ID 		100 ;
			PICTURE 	"999999999" ;
			WHEN 		.F. ;
			OF 		oFld:aDialogs[1]

		REDEFINE GET aGet[ _CSUFPED ] VAR aTmp[ _CSUFPED ];
			ID 		105 ;
			WHEN 		.F. ;
			OF 		oFld:aDialogs[1]

      REDEFINE GET aGet[ _DFECPED ] VAR aTmp[ _DFECPED ];
			ID 		110 ;
			SPINNER;
         WHEN     ( lWhen ) ;
			OF 		oFld:aDialogs[1]

      REDEFINE GET aGet[ _NESTADO ] VAR cEstPed;
         WHEN     .f. ;
         ID       120 ;
         IDSAY    121 ;
			OF 		oFld:aDialogs[1]

      REDEFINE GET aGet[ _DFECENTR ] VAR aTmp[ _DFECENTR ];
         ID       111 ;
         IDSAY    112 ;
         SPINNER;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _DFECSAL ] VAR aTmp[ _DFECSAL ];
         ID       113 ;
         IDSAY    114 ;
			SPINNER;
			WHEN 		( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

      // Codigo del usuario----------------------------------------------------

      REDEFINE GET aGet[ _CCODUSR ] VAR aTmp[ _CCODUSR ];
         ID       115 ;
         WHEN     ( .f. ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET oSay[ 10 ] VAR cSay[ 10 ] ;
         ID       116 ;
         WHEN     ( .f. ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ _CNUMPRE ] ;
         VAR      aTmp[ _CNUMPRE ];
         ID       125 ;
         IDSAY    124 ;
         PICTURE  "@R #/#########/##" ;
         WHEN     ( nMode == APPD_MODE ) ;
         BITMAP   "LUPA" ;
         VALID    ( cPreCli( aTmp, aGet, oBrwLin, nMode ), SetDialog( aGet, oSayGetRnt, oGetRnt ) );
         ON HELP  ( brwPreCli( aGet[ _CNUMPRE ], dbfPreCliT, dbfPreCliL, D():TiposIva( nView ), D():Divisas( nView ), D():FormasPago( nView ), aGet[ _LIVAINC ] ) );
			OF 		oFld:aDialogs[1]

      REDEFINE COMBOBOX aGet[ _CSITUAC ] ;
         VAR      aTmp[ _CSITUAC ] ;
         ID       218 ;
         WHEN     ( lWhen );
         ITEMS    ( SituacionesRepository():getNombres() ) ;
         OF       oFld:aDialogs[1]

      REDEFINE CHECKBOX aGet[ _LIVAINC ] ;
         VAR      aTmp[ _LIVAINC ] ;
         ID       129 ;
         WHEN     ( ( dbfTmpLin )->( ordKeyCount() ) == 0 ) ;
         OF       oFld:aDialogs[1]

		/*
		Segunda caja de dialogo_________________________________________________
		*/

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
      
      oTransportistaSelector:Bind( bSETGET( aTmp[ _UUID_TRN ] ) )
      oTransportistaSelector:Activate( 236, 235, oFld:aDialogs[2] )
      
      REDEFINE GET aGet[ _NKGSTRN ] VAR aTmp[ _NKGSTRN ] ;
         ID       237 ;
         WHEN     ( .f. ) ;
         PICTURE  ( MasUnd() ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ _NBULTOS ] VAR aTmp[ _NBULTOS ];
         ID       128 ;
			SPINNER;
         PICTURE  "99999" ;
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

      REDEFINE GET aGet[ _CRETPOR ] VAR aTmp[ _CRETPOR ] ;
         ID       160 ;
			COLOR 	CLR_GET ;
         WHEN     ( lWhen ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[_CRETMAT] VAR aTmp[_CRETMAT] ;
         ID       170 ;
			COLOR 	CLR_GET ;
         WHEN     ( lWhen ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[_CSUPED] VAR aTmp[_CSUPED];
         ID       115 ;
         WHEN     ( lWhen ) ;
			COLOR 	CLR_GET ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[_DFECENT] VAR aTmp[_DFECENT];
         ID       127 ;
			SPINNER;
         WHEN     ( lWhen ) ;
			COLOR 	CLR_GET ;
         OF       oFld:aDialogs[2]

      REDEFINE CHECKBOX aGet[_LPDTCRG] VAR aTmp[_LPDTCRG] ;
         ID       126 ;
         WHEN     ( lWhen ) ;
         OF       oFld:aDialogs[2]

		/*
		Comentarios_____________________________________________________________
		*/

		REDEFINE GET aGet[_CCONDENT] VAR aTmp[_CCONDENT] ;
			ID 		230 ;
			COLOR 	CLR_GET ;
         WHEN     ( lWhen ) ;
			OF 		oFld:aDialogs[2]

      REDEFINE GET aGet[_MOBSERV] VAR aTmp[_MOBSERV] MEMO ;
         ID       240 ;
			COLOR 	CLR_GET ;
         WHEN     ( lWhen ) ;
			OF 		oFld:aDialogs[2]

      REDEFINE GET aGet[_MCOMENT] VAR aTmp[_MCOMENT] MEMO ;
         ID       250 ;
			COLOR 	CLR_GET ;
         WHEN     ( lWhen ) ;
			OF 		oFld:aDialogs[2]

      REDEFINE SAY oGetMasDiv VAR cGetMasDiv;
         ID       480 ;
			FONT 		oFont ;
         OF       oFld:aDialogs[1]

      /*
      Entregas a cuenta
      -------------------------------------------------------------------------
      */

      REDEFINE BUTTON ;
         ID       500 ;
         OF       oFld:aDialogs[2] ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( WinAppRec( oBrwPgo, bEdtPgo, dbfTmpPgo, nil, nil, aTmp ), RecalculaTotal( aTmp ) )

      REDEFINE BUTTON ;
         ID       510 ;
         OF       oFld:aDialogs[2] ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( WinEdtRec( oBrwPgo, bEdtPgo, dbfTmpPgo, nil, nil, aTmp ), RecalculaTotal( aTmp ) )

      REDEFINE BUTTON ;
         ID       520 ;
         OF       oFld:aDialogs[2] ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( if( ( dbfTmpPgo )->lCloPgo .and. !oUser():lAdministrador(), MsgStop( "Solo pueden eliminar las entregas cerradas los administradores." ), ( WinDelRec( oBrwPgo, dbfTmpPgo ), RecalculaTotal( aTmp ) ) ) )

      REDEFINE BUTTON ;
         ID       600 ;
         OF       oFld:aDialogs[2] ;
         ACTION   ( PrnEntregas( .f., dbfTmpPgo ) )

      REDEFINE BUTTON ;
         ID       610 ;
         OF       oFld:aDialogs[2] ;
         ACTION   ( PrnEntregas( .t., dbfTmpPgo ) )

      /*
      Impresión ( informa de si está imprimido o no y de cuando se imprimió )--
      */

      REDEFINE CHECKBOX aGet[ _LIMPRIMIDO ] VAR aTmp[ _LIMPRIMIDO ] ;
         ID       120 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ _DFECIMP ] VAR aTmp[ _DFECIMP ] ;
         ID       121 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ _CHORIMP ] VAR aTmp[ _CHORIMP ] ;
         ID       122 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[2]

      /*
      Cancelado ( informa de si está cancelado o no, la fecha y el motivo de cancelación )
      */

      REDEFINE CHECKBOX aGet[ _LCANCEL ] VAR aTmp[ _LCANCEL ] ;
         ID       130 ;
         ON CHANGE( lChangeCancel( aGet, aTmp, dbfTmpLin ) ) ;
         VALID    ( lValidCancel( aGet, aTmp, oBrwLin ) ) ;
         WHEN     ( nMode != ZOOM_MODE .and. aTmp[ _NESTADO ] != 2 ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ _DCANCEL ] VAR aTmp[ _DCANCEL ] ;
         ID       131 ;
         WHEN     ( nMode != ZOOM_MODE .and. aTmp[ _LCANCEL ] ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ _CCANCEL ] VAR aTmp[ _CCANCEL ] ;
         ID       132 ;
         WHEN     ( nMode != ZOOM_MODE .and. aTmp[ _LCANCEL ] ) ;
         OF       oFld:aDialogs[2]

      /*
      Pagos
      -------------------------------------------------------------------------
      */

      oBrwPgo                 := IXBrowse():New( oFld:aDialogs[2] )

      oBrwPgo:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwPgo:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrwPgo:cAlias          := dbfTmpPgo
      oBrwPgo:cName           := "Pedido de cliente.Pago"

      oBrwPgo:nMarqueeStyle   := 6
      oBrwPgo:lHScroll        := .f.

      oBrwPgo:CreateFromResource( 530 )

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
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
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
         :nWidth              := 176
      end with

      with object ( oBrwPgo:AddCol() )
         :cHeader             := "Importe"
         :bEditValue          := {|| nEntPedCli( dbfTmpPgo, D():Divisas( nView ), cDivEmp(), .t. ) }
         :nWidth              := 90
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

      /*
      Pagado y pendiente en facturas
      ------------------------------------------------------------------------
      */

      REDEFINE SAY oGetPed VAR nTotPed ;
         ID       540 ;
         OF       oFld:aDialogs[2]

      REDEFINE SAY oGetEnt VAR 0 ;
         ID       550 ;
         OF       oFld:aDialogs[2]

      REDEFINE SAY oGetPdt VAR 0 ;
         ID       560 ;
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
      oBrwInc:cName           := "Pedido de cliente.Incidencia"

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
            :nWidth           := 470
         end with

         if nMode != ZOOM_MODE
            oBrwInc:bLDblClick   := {|| WinEdtRec( oBrwInc, bEdtInc, dbfTmpInc, nil, nil, aTmp ) }
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
         ACTION   ( WinZooRec( oBrwInc, bEdtInc, dbfTmpInc, nil, nil, aTmp ) )

      //Caja de dialogo de documentos

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
            :nWidth           := 850
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
         ACTION   ( ShellExecute( oDlg:hWnd, "open", Rtrim( ( dbfTmpDoc )->cRuta ) ) )

          /*
      Situaciones--------------------------------------------------------------
      */

      oBrwEst                 := IXBrowse():New( oFld:aDialogs[ 5 ] )

      oBrwEst:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwEst:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrwEst:cAlias          := dbfTmpEst

      oBrwEst:nMarqueeStyle   := 6
      oBrwEst:cName           := "Pedido de cliente.Situaciones"

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
        WHEN     ( lWhen ) ;
        ACTION   ( WinAppRec( oBrwEst, bEdtEst, dbfTmpEst, nil, nil, aTmp ) )


    REDEFINE BUTTON ;
        ID       501 ;
        OF       oFld:aDialogs[ 5 ] ;
        WHEN     ( lWhen ) ;
        ACTION   ( WinEdtRec( oBrwEst, bEdtEst, dbfTmpEst, nil, nil, aTmp ) )


	REDEFINE BUTTON ;
		ID 		 502 ;
        OF       oFld:aDialogs[ 5 ] ;
        WHEN     ( lWhen ) ;
        ACTION   ( WinDelRec( oBrwEst, dbfTmpEst ) )


	REDEFINE BUTTON ;
		ID 		 503 ;
        OF       oFld:aDialogs[ 5 ] ;
        ACTION   ( WinZooRec( oBrwEst, bEdtEst, dbfTmpEst, nil, nil, aTmp ) )


		/*
		Botones comunes a la caja de dialogo____________________________________
		*/

      REDEFINE BUTTON ;
         ID       3 ;
         OF       oDlg ;
         WHEN     ( lWhen ) ;
         ACTION   ( RecPedCli( aTmp ), oBrwLin:Refresh( .t. ), RecalculaTotal( aTmp ) )

      REDEFINE BUTTON ;
         ID       4 ;
			OF 		oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( if( EndTrans( aTmp, aGet, oBrwLin, oBrwInc, nMode, oDlg ), GenPedCli( IS_PRINTER ), ) )

		REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( EndTrans( aTmp, aGet, oBrwLin, oBrwInc, nMode, oDlg ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
         CANCEL ;
         ACTION   ( if( exitNoSave( nMode, dbfTmpLin ), oDlg:end(), ) )

      REDEFINE GROUP oSayLabels[ 1 ] ID 700 OF oFld:aDialogs[ 1 ] TRANSPARENT
      REDEFINE SAY   oSayLabels[ 2 ] ID 703 OF oFld:aDialogs[ 1 ]
      REDEFINE SAY   oSayLabels[ 3 ] ID 704 OF oFld:aDialogs[ 1 ]
      REDEFINE SAY   oSayLabels[ 4 ] ID 705 OF oFld:aDialogs[ 1 ]
      REDEFINE SAY   oSayLabels[ 5 ] ID 706 OF oFld:aDialogs[ 1 ]
      REDEFINE SAY   oSayLabels[ 6 ] ID 708 OF oFld:aDialogs[ 1 ]
      REDEFINE SAY   oSayLabels[ 7 ] ID 710 OF oFld:aDialogs[ 1 ]
      REDEFINE SAY   oSayLabels[ 9 ] ID 712 OF oFld:aDialogs[ 1 ]

   CodigosPostales():GetInstance():setBinding( { "CodigoPostal" => aGet[ _CPOSCLI ], "Poblacion" => aGet[ _CPOBCLI ], "Provincia" => aGet[ _CPRVCLI ] } )

   if nMode != ZOOM_MODE

      oFld:aDialogs[1]:AddFastKey( VK_F2, {|| AppDeta( oBrwLin, bEdtDet, aTmp ) } )
      oFld:aDialogs[1]:AddFastKey( VK_F3, {|| EdtDeta( oBrwLin, bEdtDet, aTmp ) } )
      oFld:aDialogs[1]:AddFastKey( VK_F4, {|| DelDeta( oBrwLin ), RecalculaTotal( aTmp ) } )

      oFld:aDialogs[2]:AddFastKey( VK_F2, {|| WinAppRec( oBrwPgo, bEdtPgo, dbfTmpPgo, nil, nil, aTmp ), RecalculaTotal( aTmp ) } )
      oFld:aDialogs[2]:AddFastKey( VK_F3, {|| WinEdtRec( oBrwPgo, bEdtPgo, dbfTmpPgo, nil, nil, aTmp ), RecalculaTotal( aTmp ) } )
      oFld:aDialogs[2]:AddFastKey( VK_F4, {|| if( ( dbfTmpPgo )->lCloPgo .and. !oUser():lAdministrador(), MsgStop( "Solo pueden eliminar las entregas cerradas los administradores." ), ( WinDelRec( oBrwPgo, dbfTmpPgo ), RecalculaTotal( aTmp ) ) ) } )

      oFld:aDialogs[3]:AddFastKey( VK_F2, {|| WinAppRec( oBrwInc, bEdtInc, dbfTmpInc, nil, nil, aTmp ) } )
      oFld:aDialogs[3]:AddFastKey( VK_F3, {|| WinEdtRec( oBrwInc, bEdtInc, dbfTmpInc, nil, nil, aTmp ) } )
      oFld:aDialogs[3]:AddFastKey( VK_F4, {|| WinDelRec( oBrwInc, dbfTmpInc ) } )

      oFld:aDialogs[4]:AddFastKey( VK_F2, {|| WinAppRec( oBrwDoc, bEdtDoc, dbfTmpDoc, nil, nil, aTmp ) } )
      oFld:aDialogs[4]:AddFastKey( VK_F3, {|| WinEdtRec( oBrwDoc, bEdtDoc, dbfTmpDoc, nil, nil, aTmp ) } )
      oFld:aDialogs[4]:AddFastKey( VK_F4, {|| WinDelRec( oBrwDoc, dbfTmpDoc ) } )

      oFld:aDialogs[5]:AddFastKey( VK_F2, {|| WinAppRec( oBrwEst, bEdtEst, dbfTmpEst, nil, nil, aTmp ) } )
      oFld:aDialogs[5]:AddFastKey( VK_F3, {|| WinEdtRec( oBrwEst, bEdtEst, dbfTmpEst, nil, nil, aTmp ) } )
      oFld:aDialogs[5]:AddFastKey( VK_F4, {|| WinDelRec( oBrwEst, dbfTmpEst ) } )

      oDlg:AddFastKey( VK_F5, {|| EndTrans( aTmp, aGet, oBrwLin, oBrwInc, nMode, oDlg ) } )
      oDlg:AddFastKey( VK_F6, {|| if( EndTrans( aTmp, aGet, oBrwLin, oBrwInc, nMode, oDlg ), GenPedCli( IS_PRINTER ), ) } )
      oDlg:AddFastKey( VK_F7, {|| ExcelImport( aTmp, dbfTmpLin, D():Articulos( nView ), dbfArtDiv, D():Familias( nView ), D():Divisas( nView ), oBrwLin, .t. ) } )
      oDlg:AddFastKey( VK_F9, {|| oDetCamposExtra:Play( Space(1) ) } )

      oDlg:AddFastKey( 65,    {|| if( GetKeyState( VK_CONTROL ), CreateInfoArticulo(), ) } )

   end if

   oDlg:SetControlFastKey( "PedidosClientesLineas", nView, aGet, dbfTmpLin )

   oDlg:bStart 		:= {|| StartEdtRec( aTmp, aGet, oDlg, nMode, cCodArt, cCodPre, oBrwLin, cCodCli ) }

	ACTIVATE DIALOG oDlg;
      ON INIT  (  InitEdtRec( aTmp, aGet, oDlg, oBrwLin, oBrwInc, oBrwPgo ), SetDialog( aGet, oSayGetRnt, oGetRnt ) );
      ON PAINT (  RecalculaTotal( aTmp ) );
      CENTER

   oMenu:end()

   oBmpEmp:end()
   oBmpDiv:end()

   /*
   Ponemos los presupuestos como estaban---------------------------------------
   */

   if oDlg:nResult != IDOK

      if !Empty( aTmp[ _CNUMPRE ] ) .and. nMode == APPD_MODE

         if ( dbfPreCliT )->( dbSeek( aTmp[ _CNUMPRE ] ) )

            if dbLock( dbfPreCliT )
               ( dbfPreCliT )->lEstado := .f.
               ( dbfPreCliT )->( dbUnLock() )
            end if

         end if

      end if

   end if

   ( D():PedidosClientes( nView ) )->( ordSetFocus( nOrd ) )

   oBmpGeneral:End()

   /*
   Muestra los avisos para nuevos pedidos por internet-------------------------
   */

   lPedidosWeb( D():PedidosClientes( nView ) )

   /*
   Guardamos los datos browse--------------------------------------------------
   */

   oBrwLin:CloseData()
   oBrwInc:CloseData()
   oBrwPgo:CloseData()

   /*
   Salida sin grabar-----------------------------------------------------------
   */

   KillTrans()

RETURN ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

Static Function StartEdtRec( aTmp, aGet, oDlg, nMode, cCodArt, cCodPre, oBrwLin, cCodCli )

	lEscandalloEdtRec( .f., oBrwLin )

	if nMode == APPD_MODE

		if !Empty( aGet ) .and. !Empty( cCodCli )
   		aGet[ _CCODCLI ]:cText( cCodCli )
    		aGet[ _CCODCLI ]:lValid()
		end if

		do case
   		case lRecogerUsuario() .and. Empty( cCodArt )

         	if !lGetUsuario( aGet[ _CCODUSR ] )
      			oDlg:End()
      		end if

   		case lRecogerUsuario() .and. !Empty( cCodArt )
      		
   			if lGetUsuario( aGet[ _CCODUSR ] )
      			AppDeta( oBrwLin, bEdtDet, aTmp, nil, cCodArt )
   			else
      			oDlg:End()
   			end if 
      
   		case !lRecogerUsuario() .and. !Empty( cCodArt )
         	
      		AppDeta( oBrwLin, bEdtDet, aTmp, nil, cCodArt ) 

   	end case 

   	if !Empty( cCodPre )
   		aGet[ _CNUMPRE ]:lValid()
   	end if 

	end if

   if uFieldempresa( "lServicio" )
      aGet[ _DFECENTR ]:Show()
      aGet[ _DFECSAL ]:Show()
   else
      aGet[ _DFECENTR ]:Hide()
      aGet[ _DFECSAL ]:Hide()
   end if

	/*
	Hace que salte la incidencia al entrar en el documento----------------------
	*/

	if !Empty( dbfTmpInc ) .and. ( dbfTmpInc )->( Used() ) 

   	while !( dbfTmpInc )->( Eof() )
      	if ( dbfTmpInc )->lAviso .and. !( dbfTmpInc )->lListo
         	MsgInfo( Trim( ( dbfTmpInc )->mDesInc ), "¡Incidencia!" )
      	end if
      	( dbfTmpInc )->( dbSkip() )
   	end while

   	( dbfTmpInc )->( dbGoTop() )

	end if

Return ( nil )

//--------------------------------------------------------------------------//

Static Function InitEdtRec( aTmp, aGet, oDlg, oBrwLin, oBrwInc, oBrwPgo )

   edtRecMenu( aTmp, oDlg )
   
   oBrwLin:Load()
   oBrwLin:MakeTotals()
   oBrwLin:RefreshFooters()

   oBrwInc:Load()
   oBrwPgo:Load()

Return ( nil )

//--------------------------------------------------------------------------//

Static Function EdtEnt( aTmp, aGet, dbfTmpPgo, oBrw, bWhen, bValid, nMode, aTmpPed )

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

   DEFAULT aTmpPed   := dbScatter( D():PedidosClientes( nView ) )

   do case
      case nMode == APPD_MODE

         aTmp[ ( dbfTmpPgo )->( FieldPos( "cTurRec" ) ) ]      	:= cCurSesion()
         aTmp[ ( dbfTmpPgo )->( FieldPos( "cCodCaj" ) ) ]      	:= Application():CodigoCaja()

         aTmp[ ( dbfTmpPgo )->( FieldPos( "cSerPed" ) ) ]      	:= aTmpPed[ _CSERPED ]
         aTmp[ ( dbfTmpPgo )->( FieldPos( "nNumPed" ) ) ]      	:= aTmpPed[ _NNUMPED ]
         aTmp[ ( dbfTmpPgo )->( FieldPos( "cSufPed" ) ) ]      	:= aTmpPed[ _CSUFPED ]
         aTmp[ ( dbfTmpPgo )->( FieldPos( "cCodCli" ) ) ]      	:= aTmpPed[ _CCODCLI ]
         aTmp[ ( dbfTmpPgo )->( FieldPos( "cCodAge" ) ) ]      	:= aTmpPed[ _CCODAGE ]
         aTmp[ ( dbfTmpPgo )->( FieldPos( "cDivPgo" ) ) ]      	:= aTmpPed[ _CDIVPED ]
         aTmp[ ( dbfTmpPgo )->( FieldPos( "cCodPgo" ) ) ]      	:= aTmpPed[ _CCODPGO ]

         if dbSeekInOrd( aTmpPed[ _CCODPGO ], "cCodPago", D():FormasPago( nView ) ) .and. ( D():FormasPago( nView ) )->lUtlBnc

            aTmp[ ( dbfTmpPgo )->( FieldPos( "cBncEmp" ) ) ]   	:= ( D():FormasPago( nView ) )->cBanco
            aTmp[ ( dbfTmpPgo )->( FieldPos( "cEPaisIBAN" ) ) ]   := ( D():FormasPago( nView ) )->cPaisIBAN
            aTmp[ ( dbfTmpPgo )->( FieldPos( "cECtrlIBAN" ) ) ]   := ( D():FormasPago( nView ) )->cCtrlIBAN
            aTmp[ ( dbfTmpPgo )->( FieldPos( "cEntEmp" ) ) ]   	:= ( D():FormasPago( nView ) )->cEntBnc
            aTmp[ ( dbfTmpPgo )->( FieldPos( "cSucEmp" ) ) ]   	:= ( D():FormasPago( nView ) )->cSucBnc
            aTmp[ ( dbfTmpPgo )->( FieldPos( "cDigEmp" ) ) ]   	:= ( D():FormasPago( nView ) )->cDigBnc
            aTmp[ ( dbfTmpPgo )->( FieldPos( "cCtaEmp" ) ) ]   	:= ( D():FormasPago( nView ) )->cCtaBnc

            aTmp[ ( dbfTmpPgo )->( FieldPos( "cBncCli" ) ) ]   	:= aTmpPed[ _CBANCO  ]
            aTmp[ ( dbfTmpPgo )->( FieldPos( "cPaisIBAN" ) ) ] 	:= aTmpPed[ _CPAISIBAN ]
            aTmp[ ( dbfTmpPgo )->( FieldPos( "cCtrlIBAN" ) ) ] 	:= aTmpPed[ _CCTRLIBAN ]
            aTmp[ ( dbfTmpPgo )->( FieldPos( "cEntCli" ) ) ]   	:= aTmpPed[ _CENTBNC ]
            aTmp[ ( dbfTmpPgo )->( FieldPos( "cSucCli" ) ) ]   	:= aTmpPed[ _CSUCBNC ]
            aTmp[ ( dbfTmpPgo )->( FieldPos( "cDigCli" ) ) ]   	:= aTmpPed[ _CDIGBNC ]
            aTmp[ ( dbfTmpPgo )->( FieldPos( "cCtaCli" ) ) ]   	:= aTmpPed[ _CCTABNC ]

         end if

     case nMode == EDIT_MODE

         if aTmp[ ( dbfTmpPgo )->( FieldPos( "lCloPgo" ) ) ] .AND. !oUser():lAdministrador()
            msgStop( "Solo pueden modificar las entregas cerradas los administradores." )
            return .f.
         end if

   end case

   cGetCli           := RetFld( aTmp[ ( dbfTmpPgo )->( FieldPos( "cCodCli" ) ) ], D():Clientes( nView ), "Titulo" )
   cGetAge           := cNbrAgent( aTmp[ ( dbfTmpPgo )->( FieldPos( "cCodAge" ) ) ], dbfAgent )
   cGetCaj           := RetFld( aTmp[ ( dbfTmpPgo )->( FieldPos( "cCodCaj" ) ) ], dbfCajT, "cNomCaj" )
   cPorDiv           := cPorDiv(aTmp[ ( dbfTmpPgo )->( FieldPos( "cDivPgo" ) ) ], D():Divisas( nView ) )
   cFPago            := RetFld( aTmp[ ( dbfTmpPgo )->( FieldPos( "cCodPgo" ) ) ], D():FormasPago( nView ) )

   DEFINE DIALOG  oDlg ;
         RESOURCE "Recibos" ;
         TITLE    LblTitle( nMode ) + "Entregas a cuenta"

      REDEFINE FOLDER oFld ;
         ID       500;
         OF       oDlg ;
         PROMPT   "&General",;
                  "Bancos";
         DIALOGS  "Entregas_1",;
                  "RecibosProveedoresBancos"

      REDEFINE BITMAP oBmp ;
         ID       500 ;
         RESOURCE "gc_money2_48" ;
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
         VALID    ( cDivOut( aGet[ ( dbfTmpPgo )->( FieldPos( "cDivPgo" ) ) ], oBmpDiv, aGet[ ( dbfTmpPgo )->( FieldPos( "nVdvPgo" ) ) ], nil, nil, @cPorDiv, nil, nil, nil, nil, D():Divisas( nView ), oBandera ) );
         PICTURE  "@!";
         ID       150 ;
         BITMAP   "LUPA" ;
         ON HELP  BrwDiv( aGet[ ( dbfTmpPgo )->( FieldPos( "cDivPgo" ) ) ], oBmpDiv, aGet[ ( dbfTmpPgo )->( FieldPos( "nVdvPgo" ) ) ], D():Divisas( nView ), oBandera ) ;
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
         VALID    ( cFPago( aGet[ ( dbfTmpPgo )->( FieldPos( "cCodPgo" ) ) ], D():FormasPago( nView ), oFpago ) ) ;
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
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[ 1 ]

      //Cliente

      REDEFINE GET aGet[ ( dbfTmpPgo )->( FieldPos( "cCodCli" ) ) ] ;
         VAR      aTmp[ ( dbfTmpPgo )->( FieldPos( "cCodCli" ) ) ] ;
         ID       110 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( cClient( aGet[ ( dbfTmpPgo )->( FieldPos( "cCodCli" ) ) ], D():Clientes( nView ), oGetCli ) ) ;
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
         RESOURCE "gc_office_building_48" ;
         TRANSPARENT ;
         OF       oFld:aDialogs[ 2 ]

      REDEFINE GET aGet[ ( dbfTmpPgo )->( FieldPos( "CBNCEMP" ) ) ] VAR aTmp[ ( dbfTmpPgo )->( FieldPos( "CBNCEMP" ) ) ];
         ID       100 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwBncEmp( aGet[ ( dbfTmpPgo )->( FieldPos( "CBNCEMP" ) ) ], aGet[ ( dbfTmpPgo )->( FieldPos( "cEPaisIBAN" ) ) ], aGet[ ( dbfTmpPgo )->( FieldPos( "cECtrlIBAN" ) ) ], aGet[ ( dbfTmpPgo )->( FieldPos( "CENTEMP" ) ) ], aGet[ ( dbfTmpPgo )->( FieldPos( "CSUCEMP" ) ) ], aGet[ ( dbfTmpPgo )->( FieldPos( "CDIGEMP" ) ) ], aGet[ ( dbfTmpPgo )->( FieldPos( "CCTAEMP" ) ) ] ) );
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ ( dbfTmpPgo )->( FieldPos( "cEPaisIBAN" ) ) ] VAR aTmp[ ( dbfTmpPgo )->( FieldPos( "cEPaisIBAN" ) ) ] ;
         PICTURE  "@!" ;
         ID       270 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( lIbanDigit( aTmp[ ( dbfTmpPgo )->( FieldPos( "cEPaisIBAN" ) ) ], aTmp[ ( dbfTmpPgo )->( FieldPos( "CENTEMP" ) ) ], aTmp[ ( dbfTmpPgo )->( FieldPos( "CSUCEMP" ) ) ], aTmp[ ( dbfTmpPgo )->( FieldPos( "CDIGEMP" ) ) ], aTmp[ ( dbfTmpPgo )->( FieldPos( "CCTAEMP" ) ) ], aGet[ ( dbfTmpPgo )->( FieldPos( "CECTRLIBAN" ) ) ] ) ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ ( dbfTmpPgo )->( FieldPos( "cECtrlIBAN" ) ) ] VAR aTmp[ ( dbfTmpPgo )->( FieldPos( "cECtrlIBAN" ) ) ] ;
         ID       280 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( lIbanDigit( aTmp[ ( dbfTmpPgo )->( FieldPos( "cEPaisIBAN" ) ) ], aTmp[ ( dbfTmpPgo )->( FieldPos( "CENTEMP" ) ) ], aTmp[ ( dbfTmpPgo )->( FieldPos( "CSUCEMP" ) ) ], aTmp[ ( dbfTmpPgo )->( FieldPos( "CDIGEMP" ) ) ], aTmp[ ( dbfTmpPgo )->( FieldPos( "CCTAEMP" ) ) ], aGet[ ( dbfTmpPgo )->( FieldPos( "CECTRLIBAN" ) ) ] ) ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ ( dbfTmpPgo )->( FieldPos( "CENTEMP" ) ) ] VAR aTmp[ ( dbfTmpPgo )->( FieldPos( "CENTEMP" ) ) ];
         ID       110 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    (	lCalcDC( aTmp[ ( dbfTmpPgo )->( FieldPos( "CENTEMP" ) ) ], aTmp[ ( dbfTmpPgo )->( FieldPos( "CSUCEMP" ) ) ], aTmp[ ( dbfTmpPgo )->( FieldPos( "CDIGEMP" ) ) ], aTmp[ ( dbfTmpPgo )->( FieldPos( "CCTAEMP" ) ) ], aGet[ ( dbfTmpPgo )->( FieldPos( "CDIGEMP" ) ) ] ),;
         				aGet[ ( dbfTmpPgo )->( FieldPos( "cEPaisIBAN" ) ) ]:lValid() ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ ( dbfTmpPgo )->( FieldPos( "CSUCEMP" ) ) ] VAR aTmp[ ( dbfTmpPgo )->( FieldPos( "CSUCEMP" ) ) ];
         ID       120 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    (	lCalcDC( aTmp[ ( dbfTmpPgo )->( FieldPos( "CENTEMP" ) ) ], aTmp[ ( dbfTmpPgo )->( FieldPos( "CSUCEMP" ) ) ], aTmp[ ( dbfTmpPgo )->( FieldPos( "CDIGEMP" ) ) ], aTmp[ ( dbfTmpPgo )->( FieldPos( "CCTAEMP" ) ) ], aGet[ ( dbfTmpPgo )->( FieldPos( "CDIGEMP" ) ) ] ),;
         				aGet[ ( dbfTmpPgo )->( FieldPos( "cEPaisIBAN" ) ) ]:lValid() ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ ( dbfTmpPgo )->( FieldPos( "CDIGEMP" ) ) ] VAR aTmp[ ( dbfTmpPgo )->( FieldPos( "CDIGEMP" ) ) ];
         ID       130 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    (	lCalcDC( aTmp[ ( dbfTmpPgo )->( FieldPos( "CENTEMP" ) ) ], aTmp[ ( dbfTmpPgo )->( FieldPos( "CSUCEMP" ) ) ], aTmp[ ( dbfTmpPgo )->( FieldPos( "CDIGEMP" ) ) ], aTmp[ ( dbfTmpPgo )->( FieldPos( "CCTAEMP" ) ) ], aGet[ ( dbfTmpPgo )->( FieldPos( "CDIGEMP" ) ) ] ),;
         				aGet[ ( dbfTmpPgo )->( FieldPos( "cEPaisIBAN" ) ) ]:lValid() ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ ( dbfTmpPgo )->( FieldPos( "CCTAEMP" ) ) ] VAR aTmp[ ( dbfTmpPgo )->( FieldPos( "CCTAEMP" ) ) ];
         ID       140 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    (	lCalcDC( aTmp[ ( dbfTmpPgo )->( FieldPos( "CENTEMP" ) ) ], aTmp[ ( dbfTmpPgo )->( FieldPos( "CSUCEMP" ) ) ], aTmp[ ( dbfTmpPgo )->( FieldPos( "CDIGEMP" ) ) ], aTmp[ ( dbfTmpPgo )->( FieldPos( "CCTAEMP" ) ) ], aGet[ ( dbfTmpPgo )->( FieldPos( "CDIGEMP" ) ) ] ),;
         				aGet[ ( dbfTmpPgo )->( FieldPos( "cEPaisIBAN" ) ) ]:lValid() ) ;
         OF       oFld:aDialogs[2]

      /*
      Banco del cliente--------------------------------------------------------
      */

      REDEFINE GET aGet[ ( dbfTmpPgo )->( FieldPos( "CBNCCLI" ) ) ] VAR aTmp[ ( dbfTmpPgo )->( FieldPos( "CBNCCLI" ) ) ];
         ID       200 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwBncCli( aGet[ ( dbfTmpPgo )->( FieldPos( "CBNCCLI" ) ) ], aGet[ ( dbfTmpPgo )->( FieldPos( "CPAISIBAN" ) ) ], aGet[ ( dbfTmpPgo )->( FieldPos( "CCTRLIBAN" ) ) ], aGet[ ( dbfTmpPgo )->( FieldPos( "CENTCLI" ) ) ], aGet[ ( dbfTmpPgo )->( FieldPos( "CSUCCLI" ) ) ], aGet[ ( dbfTmpPgo )->( FieldPos( "CDIGCLI" ) ) ], aGet[ ( dbfTmpPgo )->( FieldPos( "CCTACLI" ) ) ], aTmp[ ( dbfTmpPgo )->( FieldPos( "CCODCLI" ) ) ] ) );
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ ( dbfTmpPgo )->( FieldPos( "CPAISIBAN" ) ) ] VAR aTmp[ ( dbfTmpPgo )->( FieldPos( "CPAISIBAN" ) ) ] ;
         PICTURE  "@!" ;
         ID       250 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( lIbanDigit( aTmp[ ( dbfTmpPgo )->( FieldPos( "CPAISIBAN" ) ) ], aTmp[ ( dbfTmpPgo )->( FieldPos( "CENTCLI" ) ) ], aTmp[ ( dbfTmpPgo )->( FieldPos( "CSUCCLI" ) ) ], aTmp[ ( dbfTmpPgo )->( FieldPos( "CDIGCLI" ) ) ], aTmp[ ( dbfTmpPgo )->( FieldPos( "CCTACLI" ) ) ], aGet[ ( dbfTmpPgo )->( FieldPos( "CCTRLIBAN" ) ) ] ) ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ ( dbfTmpPgo )->( FieldPos( "CCTRLIBAN" ) ) ] VAR aTmp[ ( dbfTmpPgo )->( FieldPos( "CCTRLIBAN" ) ) ] ;
         ID       260 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( lIbanDigit( aTmp[ ( dbfTmpPgo )->( FieldPos( "CPAISIBAN" ) ) ], aTmp[ ( dbfTmpPgo )->( FieldPos( "CENTCLI" ) ) ], aTmp[ ( dbfTmpPgo )->( FieldPos( "CSUCCLI" ) ) ], aTmp[ ( dbfTmpPgo )->( FieldPos( "CDIGCLI" ) ) ], aTmp[ ( dbfTmpPgo )->( FieldPos( "CCTACLI" ) ) ], aGet[ ( dbfTmpPgo )->( FieldPos( "CCTRLIBAN" ) ) ] ) ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ ( dbfTmpPgo )->( FieldPos( "CENTCLI" ) ) ] VAR aTmp[ ( dbfTmpPgo )->( FieldPos( "CENTCLI" ) ) ];
         ID       210 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( 	lCalcDC( aTmp[ ( dbfTmpPgo )->( FieldPos( "CENTCLI" ) ) ], aTmp[ ( dbfTmpPgo )->( FieldPos( "CSUCCLI" ) ) ], aTmp[ ( dbfTmpPgo )->( FieldPos( "CDIGCLI" ) ) ], aTmp[ ( dbfTmpPgo )->( FieldPos( "CCTACLI" ) ) ], aGet[ ( dbfTmpPgo )->( FieldPos( "CDIGCLI" ) ) ] ),;
         				aGet[ ( dbfTmpPgo )->( FieldPos( "cPaisIBAN" ) ) ]:lValid() ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ ( dbfTmpPgo )->( FieldPos( "CSUCCLI" ) ) ] VAR aTmp[ ( dbfTmpPgo )->( FieldPos( "CSUCCLI" ) ) ];
         ID       220 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( 	lCalcDC( aTmp[ ( dbfTmpPgo )->( FieldPos( "CENTCLI" ) ) ], aTmp[ ( dbfTmpPgo )->( FieldPos( "CSUCCLI" ) ) ], aTmp[ ( dbfTmpPgo )->( FieldPos( "CDIGCLI" ) ) ], aTmp[ ( dbfTmpPgo )->( FieldPos( "CCTACLI" ) ) ], aGet[ ( dbfTmpPgo )->( FieldPos( "CDIGCLI" ) ) ] ),;
         				aGet[ ( dbfTmpPgo )->( FieldPos( "cPaisIBAN" ) ) ]:lValid() ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ ( dbfTmpPgo )->( FieldPos( "CDIGCLI" ) ) ] VAR aTmp[ ( dbfTmpPgo )->( FieldPos( "CDIGCLI" ) ) ];
         ID       230 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( 	lCalcDC( aTmp[ ( dbfTmpPgo )->( FieldPos( "CENTCLI" ) ) ], aTmp[ ( dbfTmpPgo )->( FieldPos( "CSUCCLI" ) ) ], aTmp[ ( dbfTmpPgo )->( FieldPos( "CDIGCLI" ) ) ], aTmp[ ( dbfTmpPgo )->( FieldPos( "CCTACLI" ) ) ], aGet[ ( dbfTmpPgo )->( FieldPos( "CDIGCLI" ) ) ] ),;
         				aGet[ ( dbfTmpPgo )->( FieldPos( "cPaisIBAN" ) ) ]:lValid() ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ ( dbfTmpPgo )->( FieldPos( "CCTACLI" ) ) ] VAR aTmp[ ( dbfTmpPgo )->( FieldPos( "CCTACLI" ) ) ];
         ID       240 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( 	lCalcDC( aTmp[ ( dbfTmpPgo )->( FieldPos( "CENTCLI" ) ) ], aTmp[ ( dbfTmpPgo )->( FieldPos( "CSUCCLI" ) ) ], aTmp[ ( dbfTmpPgo )->( FieldPos( "CDIGCLI" ) ) ], aTmp[ ( dbfTmpPgo )->( FieldPos( "CCTACLI" ) ) ], aGet[ ( dbfTmpPgo )->( FieldPos( "CDIGCLI" ) ) ] ),;
         				aGet[ ( dbfTmpPgo )->( FieldPos( "cPaisIBAN" ) ) ]:lValid() ) ;
         OF       oFld:aDialogs[2]

      /*
      Botones------------------------------------------------------------------
      */

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

   ACTIVATE DIALOG oDlg CENTER ON INIT ( CreateMenuEntrega( aTmp, oDlg ) )

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

//--------------------------------------------------------------------------//

Static Function CreateMenuEntrega( aTmp, oDlg )

   MENU oMenu

      MENUITEM    "&1. Rotor"

         MENU

            MENUITEM    "&1. Modificar cliente";
               MESSAGE  "Modifica la ficha del cliente" ;
               RESOURCE "gc_user_16" ;
               ACTION   ( if( !Empty( aTmp[ ( dbfTmpPgo )->( FieldPos( "cCodCli" ) ) ] ), EdtCli( aTmp[ ( dbfTmpPgo )->( FieldPos( "cCodCli" ) ) ] ), MsgStop( "Código de cliente vacío" ) ) )

            MENUITEM    "&2. Modificar cliente contactos";
               MESSAGE  "Modifica la ficha del cliente en contactos" ;
               RESOURCE "gc_user_16" ;
               ACTION   ( if( !Empty( aTmp[ ( dbfTmpPgo )->( FieldPos( "cCodCli" ) ) ] ), EdtCli( aTmp[ ( dbfTmpPgo )->( FieldPos( "cCodCli" ) ) ], , 5 ), MsgStop( "Código de cliente vacío" ) ) )

            MENUITEM    "&3. Informe de cliente";
               MESSAGE  "Informe de cliente" ;
               RESOURCE "Info16" ;
               ACTION   ( if( !Empty( aTmp[ ( dbfTmpPgo )->( FieldPos( "cCodCli" ) ) ] ), InfCliente( aTmp[ ( dbfTmpPgo )->( FieldPos( "cCodCli" ) ) ] ), MsgStop( "Código de cliente vacío" ) ) );

         ENDMENU

   ENDMENU

   oDlg:SetMenu( oMenu )

RETURN ( oMenu )

//--------------------------------------------------------------------------//

Static Function ValidEdtEnt( aTmp, aGet, oBrw, oDlg, nMode, dbfTmpPgo )

   if nMode == APPD_MODE
      aTmp[ ( dbfTmpPgo )->( FieldPos( "nNumRec" ) ) ]   := ( dbfTmpPgo )->( RecNo() ) + 1
   end if

   WinGather( aTmp, aGet, dbfTmpPgo, oBrw, nMode )

   oDlg:End( IDOK )

Return .t.

//--------------------------------------------------------------------------//

Static Function EdtRecMenu( aTmp, oDlg )

   MENU oMenu

      MENUITEM    "&1. Rotor"

         MENU

            if !lExternal

            MENUITEM    "&1. Campos extra [F9]";
               MESSAGE  "Mostramos y rellenamos los campos extra para la familia" ;
               RESOURCE "gc_form_plus2_16" ;
               ACTION   ( oDetCamposExtra:Play( Space(1) ) )

            MENUITEM    "&2. Visualizar presupuesto";
               MESSAGE  "Visualiza el presupuesto del cliente" ;
               RESOURCE "gc_notebook_user_16";
               ACTION   ( if( !Empty( aTmp[ _CNUMPRE ] ), ZooPreCli( aTmp[ _CNUMPRE ] ), MsgStop( "El pedido no proviene de presupuesto" ) ) )

            SEPARATOR

            MENUITEM    "&3. Generar anticipo";
               MESSAGE  "Genera anticipo de cliente" ;
               RESOURCE "gc_document_text_money2_16";
               ACTION   ( if( !Empty( aTmp[ _CCODCLI ] ), CreateAntCli( aTmp[ _CCODCLI ] ), msgStop("Debe seleccionar un cliente para hacer una factura de anticipo" ) ) );

            SEPARATOR

            MENUITEM    "&4. Modificar cliente";
               MESSAGE  "Modificar la ficha del cliente" ;
               RESOURCE "gc_user_16";
               ACTION   ( if( !Empty( aTmp[ _CCODCLI ] ), EdtCli( aTmp[ _CCODCLI ] ), MsgStop( "Código de cliente vacío" ) ) )

            MENUITEM    "&5. Modificar cliente contactos";
               MESSAGE  "Modifica la ficha del cliente en contactos" ;
               RESOURCE "gc_user_16" ;
               ACTION   ( if( !Empty( aTmp[ _CCODCLI ] ), EdtCli( aTmp[ _CCODCLI ], , 5 ), MsgStop( "Código de cliente vacío" ) ) )

            MENUITEM    "&6. Informe de cliente";
               MESSAGE  "Abrir el informe del cliente" ;
               RESOURCE "Info16";
               ACTION   ( if( !Empty( aTmp[ _CCODCLI ] ), InfCliente( aTmp[ _CCODCLI ] ), MsgStop( "Código de cliente vacío" ) ) );

            MENUITEM    "&7. Modificar dirección";
               MESSAGE  "Modifica la obra del documento" ;
               RESOURCE "gc_worker2_16";
               ACTION   ( if( !Empty( aTmp[ _CCODOBR ] ), EdtObras( aTmp[ _CCODCLI ], aTmp[ _CCODOBR ], dbfObrasT ), MsgStop( "Código de obra vacío" ) ) );

            SEPARATOR

            end if

            MENUITEM    "&8. Informe del documento";
               MESSAGE  "Informe del documento" ;
               RESOURCE "Info16";
               ACTION   ( TTrazaDocumento():Activate( PED_CLI, aTmp[ _CSERPED ] + Str( aTmp[ _NNUMPED ] ) + aTmp[ _CSUFPED ] ) );

            MENUITEM    "&9. Firmar documento";
               MESSAGE  "Firmar documento" ;
               RESOURCE "gc_sign_document_16" ;
               ACTION   ( if( empty( aTmp[ _MFIRMA ] ) .or.  msgNoYes( "El documento ya esta firmado, ¿Desea voler a firmarlo?" ),;
                              aTmp[ _MFIRMA ] := signatureToMemo(),;
                              ) ) 

         ENDMENU

   ENDMENU

   oDlg:SetMenu( oMenu )

Return ( oMenu )

//--------------------------------------------------------------------------//

/*
Edita las lineas de Detalle
*/

STATIC FUNCTION EdtDet( aTmp, aGet, dbf, oBrw, lTotLin, cCodArtEnt, nMode, aTmpPed )

   local oDlg
   local oFld
   local oBtn
   local oBrwResCli
   local oBrwAlbCli
   local oBrwFacCli
   local oBrwAlbPrv
   local oGet3
   local cGet3
   local oTot           	:= Array( 6 )
   local oTotal
   local nTotal
   local oSayPr1
   local oSayPr2
   local cSayPr1        	:= ""
   local cSayPr2        	:= ""
   local oSayVp1
   local oSayVp2
   local cSayVp1        	:= ""
   local cSayVp2        	:= ""
   local oSayAlm
   local cSayAlm        	:= ""
   local nOrdAnt
   local nOrdPedPrv
   local nOrdAlbPrv
   local nTotRes        	:= 0
   local cNumPed        	:= aTmp[ _CSERPED ] + Str( aTmp[ _NNUMPED ] ) + aTmp[ _CSUFPED ]
   local oStkAct
   local nStkAct        	:= 0
   local nTotEnt
   local dFecRes
   local cCodArt        	:= Padr( aTmp[ _CREF ], 200 )
   local bmpImage
   local oTotUni
   local oTotPdt
   local nTotPdt        	:= 0
   local oTotEnt
   local oSayGrp
   local cSayGrp        	:= ""
   local oSayFam
   local cSayFam        	:= ""
   local cNumedPrv      	:= ""
   local oRentLin
   local cRentLin
   local cCodDiv        	:= aTmpPed[ _CDIVPED ]
   local oGetCaducidad
   local dGetCaducidad
   local nOrdFacCliL
   local oBtnSer
   local oEstadoProduccion
   local cEstadoProduccion
   local idPedidoCliente   := ""
   local idArticulo        := "" 
   local idShortArticulo   := ""

   cTipoCtrCoste           := AllTrim( aTmp[ _CTIPCTR ] )

   do case
   case nMode == APPD_MODE

      aTmp[ _NCANPED    ]  := 1
      aTmp[ _NUNICAJA   ]  := 1
      aTmp[ _NPRODUC    ]  := 0
      aTmp[ _DFECHA     ]  := ctod( "" )
      aTmp[ _DFECCAD    ]  := Ctod( "" )
      aTmp[ _LTOTLIN    ]  := lTotLin
      aTmp[ _NNUMPED    ]  := aTmpPed[ _NNUMPED ]
      aTmp[ _CALMLIN    ]  := aTmpPed[ _CCODALM ]
      aTmp[ _LIVALIN    ]  := aTmpPed[ _LIVAINC ]
      aTmp[ __DFECSAL   ]  := aTmpPed[ _DFECSAL ]
      aTmp[ __DFECENT   ]  := aTmpPed[ _DFECENTR]
      aTmp[ _NTARLIN    ]  := oGetTarifa:getTarifa()
      aTmp[ _COBRLIN    ]  := aTmpPed[ _CCODOBR ]

      if !Empty( cCodArtEnt )
         cCodArt        	:= Padr( cCodArtEnt, 200 )
      end if

      cTipoCtrCoste           := "Centro de coste"

   case nMode == EDIT_MODE

      lTotLin           	:= aTmp[ _LTOTLIN ]

   end case

   idPedidoCliente         := aTmp[ _CSERPED ] + Str( aTmp[ _NNUMPED ] ) + aTmp[ _CSUFPED ]
   idShortArticulo         := aTmp[ _CREF ] + aTmp[ _CVALPR1 ] + aTmp[ _CVALPR2 ]
   idArticulo              := aTmp[ _CREF ] + aTmp[ _CCODPR1 ] + aTmp[ _CCODPR2 ] + aTmp[ _CVALPR1 ] + aTmp[ _CVALPR2 ]

   /*
   Este valor los guaradamos para detectar los posibles cambios----------------
   */

   cOldCodArt           	:= aTmp[ _CREF    ]
   cOldUndMed           	:= aTmp[ _CUNIDAD ]
   cOldPrpArt              := aTmp[ _CCODPR1 ] + aTmp[ _CCODPR2 ] + aTmp[ _CVALPR1 ] + aTmp[ _CVALPR2 ]

   nOrdPedPrv           	:= ( D():PedidosProveedoresLineas( nView ) )->( OrdSetFocus( "cPedCliRef" ) )

   dFecRes              	:= dTmpPdtRec( aTmp[ _CREF ], aTmp[ _CVALPR1 ], aTmp[ _CVALPR2 ], dbfTmpRes )

   nTotRes              	:= nUnidadesRecibidasAlbaranesClientesNoFacturados( cNumPed, aTmp[ _CREF ], aTmp[ _CVALPR1 ], aTmp[ _CVALPR2 ], dbfAlbCliL )
   nTotRes              	+= nUnidadesRecibidasFacturasClientes( cNumPed, aTmp[ _CREF ], aTmp[ _CVALPR1 ], aTmp[ _CVALPR2 ], dbfFacCliL )

   if nTotRes > nTotNPedCli( aTmp )
      nTotRes           	:= nTotNPedCli( aTmp )
   end if

   nTotEnt              	:= nUnidadesRecibidasPedCli( aTmp[ _CSERPED ] + Str( aTmp[ _NNUMPED ] ) + aTmp[ _CSUFPED ], aTmp[ _CREF ], aTmp[ _CVALPR1 ], aTmp[ _CVALPR2 ], aTmp[ _CREFPRV ], aTmp[ _CDETALLE ], dbfAlbPrvL )
   nTotPdt              	:= nTotNPedCli( aTmp ) - nTotEnt

   cEstadoProduccion 		:= aEstadoProduccion[ Min( Max( aTmp[ _NPRODUC ] + 1, 1 ), len( aEstadoProduccion ) ) ]

   /*
   Etiquetas de familias y grupos de familias----------------------------------
   */

   cSayGrp              	:= RetFld( aTmp[ _CGRPFAM ], oGrpFam:GetAlias() )
   cSayFam              	:= RetFld( aTmp[ _CCODFAM ], D():Familias( nView ) )

   // Filtros de tablas relacionadas con el pedido-----------------------------

   nOrdAnt              	:= ( dbfAlbCliL )->( OrdSetFocus( "cNumPedRef" ) )

   ( dbfAlbCliL )->( OrdScope( 0, idPedidoCliente + idShortArticulo ) )
   ( dbfAlbCliL )->( OrdScope( 1, idPedidoCliente + idShortArticulo ) )
   ( dbfAlbCliL )->( dbGoTop() )

   nOrdFacCliL          	:= ( dbfFacCliL )->( OrdSetFocus( "cNumPedRef" ) )

   ( dbfFacCliL )->( OrdScope( 0, idPedidoCliente + idShortArticulo ) )
   ( dbfFacCliL )->( OrdScope( 1, idPedidoCliente + idShortArticulo ) )
   ( dbfFacCliL )->( dbGoTop() )

   nOrdAlbPrv           	:= ( dbfAlbPrvL )->( OrdSetFocus( "cPedCliRef" ) )

   ( dbfAlbPrvL )->( OrdScope( 0, idPedidoCliente + idArticulo ) )
   ( dbfAlbPrvL )->( OrdScope( 1, idPedidoCliente + idArticulo ) )
   ( dbfAlbPrvL )->( dbGoTop() )

   // Reservas-----------------------------------------------------------------

   ( dbfTmpRes )->( OrdScope( 0, idArticulo ) )
   ( dbfTmpRes )->( OrdScope( 1, idArticulo ) )
   ( dbfTmpRes )->( dbGoTop() )

   // Dialogo------------------------------------------------------------------

   DEFINE DIALOG oDlg RESOURCE "LFACCLI" TITLE LblTitle( nMode ) + "lineas a pedidos de clientes"

      REDEFINE FOLDER oFld ;
         ID       400 ;
         OF       oDlg ;
         PROMPT   "&General",;
                  "Da&tos",;
                  "R&ecepciones",;
                  "Reser&vas",;
                  "Entre&gas",;
                  "&Anular",;
                  "&Observaciones",;
                  "&Centro coste";
         DIALOGS  "LFACCLI_1",;
                  "LPEDCLI_2",;
                  "LPEDCLI_6",;
                  "LPEDCLI_4",;
                  "LPEDCLI_5",;
                  "LPEDCLI_3",;
                  "LFACCLI_3",;
                  "LCTRCOSTE"

      REDEFINE GET aGet[ _CREF ] VAR cCodArt;
			ID 		100 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( LoaArt( cCodArt, aTmp, aGet, aTmpPed, oStkAct, oSayPr1, oSayPr2, oSayVp1, oSayVp2, bmpImage, nMode ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwArticulo( aGet[ _CREF ], aGet[ _CDETALLE ], .f., .t., oBtn, aGet[ _CLOTE ], aTmp[ _CCODPR1 ], aTmp[ _CCODPR2 ], aGet[ _CVALPR1 ], aGet[ _CVALPR2 ], aGet[ _DFECCAD ], if( uFieldEmpresa( "lStockAlm" ), aTmp[ _CALMLIN ], nil ) ) ) ;
			COLOR 	CLR_GET ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CDETALLE ] ;
         VAR      aTmp[ _CDETALLE ] ;
         ID       110 ;
         WHEN     ( ( lModDes() .or. Empty( aTmp[ _CDETALLE ] ) ) .AND. nMode != ZOOM_MODE );
         OF       oFld:aDialogs[1]

      /*
      Lotes
      -------------------------------------------------------------------------
      */

      REDEFINE GET aGet[ _CLOTE ] ;
         VAR      aTmp[ _CLOTE ] ;
         ID       112 ;
         IDSAY    113 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF 		oFld:aDialogs[1]

   		aGet[ _CLOTE ]:bValid   := {|| oStock:lPutStockActual( aTmp[ _CREF ], aTmp[ _CALMLIN ], aTmp[ _CVALPR1 ], aTmp[ _CVALPR2 ], aTmp[ _CLOTE ], aTmp[ _LKITART ], aTmp[ _NCTLSTK ], oStkAct ) }

      REDEFINE GET oGetCaducidad VAR dGetCaducidad ;
         ID       340 ;
         IDSAY    341 ;
			SPINNER ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _MLNGDES ] VAR aTmp[ _MLNGDES ] ;
			MEMO ;
			ID 		111 ;
         WHEN     ( ( lModDes() .or. Empty( aTmp[ _MLNGDES ] ) ) .AND. nMode != ZOOM_MODE );
         OF       oFld:aDialogs[1]

      // Propiedades-------------------------------------------------

      oBrwProperties                      := IXBrowse():New( oFld:aDialogs[1] )

      oBrwProperties:nDataType            := DATATYPE_ARRAY

      oBrwProperties:bClrSel              := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwProperties:bClrSelFocus         := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrwProperties:lHScroll             := .t.
      oBrwProperties:lVScroll             := .t.

      oBrwProperties:nMarqueeStyle        := 3
      oBrwProperties:lRecordSelector      := .f.
      oBrwProperties:lFastEdit            := .t.
      oBrwProperties:nFreeze              := 1
      oBrwProperties:lFooter              := .t.
      oBrwProperties:lFreezeLikeExcel     := .t.  

      oBrwProperties:SetArray( {}, .f., 0, .f. )

      oBrwProperties:MakeTotals()

      oBrwProperties:CreateFromResource( 500 )

      REDEFINE GET aGet[ _CVALPR1 ] VAR aTmp[ _CVALPR1 ];
         ID       270 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
			COLOR 	CLR_GET ;
         BITMAP   "LUPA" ;
         VALID    ( if( lPrpAct( aTmp[ _CVALPR1 ], oSayVp1, aTmp[ _CCODPR1 ], D():PropiedadesLineas( nView ) ),;
                        LoaArt( cCodArt, aTmp, aGet, aTmpPed, oStkAct, oSayPr1, oSayPr2, oSayVp1, oSayVp2, bmpImage, nMode, .f. ),;
                        .f. ) );
         ON HELP  ( brwPropiedadActual( aGet[ _CVALPR1 ], oSayVp1, aTmp[ _CCODPR1 ] ) ) ;
         OF       oFld:aDialogs[1]

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
			COLOR 	CLR_GET ;
         BITMAP   "LUPA" ;
         VALID    ( if( lPrpAct( aTmp[ _CVALPR2 ], oSayVp2, aTmp[ _CCODPR2 ], D():PropiedadesLineas( nView ) ),;
                        LoaArt( cCodArt, aTmp, aGet, aTmpPed, oStkAct, oSayPr1, oSayPr2, oSayVp1, oSayVp2, bmpImage, nMode, .f. ),;
                        .f. ) );
         ON HELP  ( brwPropiedadActual( aGet[_CVALPR2], oSayVp2, aTmp[_CCODPR2 ] ) ) ;
         OF       oFld:aDialogs[1]

      REDEFINE SAY oSayPr2 VAR cSayPr2;
         ID       281 ;
         OF       oFld:aDialogs[1]

      REDEFINE GET oSayVp2 VAR cSayVp2;
         ID       282 ;
         WHEN     .f. ;
         COLOR    CLR_GET ;
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

      REDEFINE GET aGet[ ( D():PedidosClientesLineas( nView ) )->( fieldpos( "nMedUno" ) ) ] ;
         VAR      aTmp[ ( D():PedidosClientesLineas( nView ) )->( fieldpos( "nMedUno" ) ) ] ;
         ID       520 ;
         IDSAY    521 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ON CHANGE( RecalculaLinea( aTmp, aTmpPed, nDouDiv, oTotal, oTot, oRentLin, cCodDiv ) );
         PICTURE  MasUnd() ;
         OF       oFld:aDialogs[1]

         aGet[ ( D():PedidosClientesLineas( nView ) )->( fieldpos( "nMedUno" ) ) ]:oSay:SetColor( CLR_BLUE )

      REDEFINE GET aGet[ ( D():PedidosClientesLineas( nView ) )->( fieldpos( "nMedDos" ) ) ] ;
         VAR      aTmp[ ( D():PedidosClientesLineas( nView ) )->( fieldpos( "nMedDos" ) ) ] ;
         ID       530 ;
         IDSAY    531 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ON CHANGE( RecalculaLinea( aTmp, aTmpPed, nDouDiv, oTotal, oTot, oRentLin, cCodDiv ) );
         PICTURE  MasUnd() ;
         OF       oFld:aDialogs[1]

         aGet[ ( D():PedidosClientesLineas( nView ) )->( fieldpos( "nMedDos" ) ) ]:oSay:SetColor( CLR_BLUE )

      REDEFINE GET aGet[ ( D():PedidosClientesLineas( nView ) )->( fieldpos( "nMedTre" ) ) ] ;
         VAR      aTmp[ ( D():PedidosClientesLineas( nView ) )->( fieldpos( "nMedTre" ) ) ] ;
         ID       540 ;
         IDSAY    541 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ON CHANGE( RecalculaLinea( aTmp, aTmpPed, nDouDiv, oTotal, oTot, oRentLin, cCodDiv ) );
         PICTURE  MasUnd() ;
         OF       oFld:aDialogs[1]

         aGet[ ( D():PedidosClientesLineas( nView ) )->( fieldpos( "nMedTre" ) ) ]:oSay:SetColor( CLR_BLUE )

      // Tipo de impuestos-------------------------------------------------------------------------

      REDEFINE GET aGet[ _NIVA ] VAR aTmp[ _NIVA ] ;
			ID 		120 ;
         WHEN     ( lModIva() .AND. nMode != ZOOM_MODE .AND. !lTotLin ) ;
         PICTURE  "@E 99.99" ;
			COLOR 	CLR_GET ;
         ON CHANGE( RecalculaLinea( aTmp, aTmpPed, nDouDiv, oTotal, oTot, oRentLin, cCodDiv ) );
         VALID    ( lTiva( D():TiposIva( nView ), aTmp[ _NIVA ], @aTmp[ _NREQ ] ) );
         BITMAP   "LUPA" ;
         ON HELP  ( BrwIva( aGet[ _NIVA ], D():TiposIva( nView ), , .t. ) ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _NVALIMP ] ;
         VAR      aTmp[ _NVALIMP ] ;
         ID       125 ;
         SPINNER ;
         WHEN     ( uFieldEmpresa( "lModImp" ) .AND. nMode != ZOOM_MODE ) ;
         PICTURE  cPouDiv ;
         ON CHANGE( RecalculaLinea( aTmp, aTmpPed, nDouDiv, oTotal, oTot, oRentLin, cCodDiv ) );
         ON HELP  ( oNewImp:nBrwImp( aGet[ _NVALIMP ] ) );
         IDSAY    126 ;
         OF       oFld:aDialogs[1]

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

      aGet[ __NBULTOS ]:Cargo          := "nBultos"
      aGet[ __NBULTOS ]:bPostValidate  := {| oSender | runScript( "PedidosClientes\Lineas\validControl.prg", oSender, aGet, nView, nMode, aTmpPed ) } 

		REDEFINE GET aGet[_NCANPED] VAR aTmp[_NCANPED];
			ID 		130 ;
			SPINNER ;
         WHEN     ( lUseCaj() .AND. nMode != ZOOM_MODE .AND. !lTotLin ) ;
         ON CHANGE( RecalculaLinea( aTmp, aTmpPed, nDouDiv, oTotal, oTot, oRentLin, cCodDiv ), LoaArt( cCodArt, aTmp, aGet, aTmpPed, oStkAct, oSayPr1, oSayPr2, oSayVp1, oSayVp2, bmpImage, nMode, .f. ) ) ;
         VALID    ( RecalculaLinea( aTmp, aTmpPed, nDouDiv, oTotal, oTot, oRentLin, cCodDiv ), LoaArt( cCodArt, aTmp, aGet, aTmpPed, oStkAct, oSayPr1, oSayPr2, oSayVp1, oSayVp2, bmpImage, nMode, .f. ) ) ;
			PICTURE 	cPicUnd ;
         OF       oFld:aDialogs[1] ;
         IDSAY    131

      aGet[ _NCANPED ]:Cargo          := "nCanPed"
      aGet[ _NCANPED ]:bPostValidate  := {| oSender | runScript( "PedidosClientes\Lineas\validControl.prg", oSender, aGet, nView, nMode, aTmpPed ) } 

		REDEFINE GET aGet[_NUNICAJA] VAR aTmp[_NUNICAJA];
			ID 		140 ;
			SPINNER ;
         WHEN     ( nMode != ZOOM_MODE .AND. !lTotLin .and. oUser():lModificaUnidades() ) ;
         ON CHANGE( RecalculaLinea( aTmp, aTmpPed, nDouDiv, oTotal, oTot, oRentLin, cCodDiv ), LoaArt( cCodArt, aTmp, aGet, aTmpPed, oStkAct, oSayPr1, oSayPr2, oSayVp1, oSayVp2, bmpImage, nMode, .f. ) ) ;
         VALID    ( RecalculaLinea( aTmp, aTmpPed, nDouDiv, oTotal, oTot, oRentLin, cCodDiv ), LoaArt( cCodArt, aTmp, aGet, aTmpPed, oStkAct, oSayPr1, oSayPr2, oSayVp1, oSayVp2, bmpImage, nMode, .f. ) ) ;
			PICTURE 	cPicUnd ;
         OF       oFld:aDialogs[1] ;
         IDSAY    141

      aGet[ _NUNICAJA ]:Cargo          := "nUniCaja"
      aGet[ _NUNICAJA ]:bPostValidate  := {| oSender | runScript( "PedidosClientes\Lineas\validControl.prg", oSender, aGet, nView, nMode, aTmpPed ) } 

      /*
      Precios
      -------------------------------------------------------------------------
      */

      REDEFINE GET aGet[ _NPREDIV ] VAR aTmp[ _NPREDIV ] ;
			ID 		150 ;
			SPINNER ;
         WHEN     ( nMode != ZOOM_MODE .and. !lTotLin ) ;
         VALID    ( RecalculaLinea( aTmp, aTmpPed, nDouDiv, oTotal, oTot, oRentLin, cCodDiv ) );
         ON CHANGE( RecalculaLinea( aTmp, aTmpPed, nDouDiv, oTotal, oTot, oRentLin, cCodDiv ) );
			PICTURE 	cPouDiv ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _NTARLIN ] VAR aTmp[ _NTARLIN ];
         ID       156 ;
         SPINNER ;
         MIN      1 ;
         MAX      6 ;
         PICTURE  "9" ;
         VALID    ( aTmp[ _NTARLIN ] >= 1 .and. aTmp[ _NTARLIN ] <= 6 );
         WHEN     ( nMode != ZOOM_MODE .and. ( SQLAjustableModel():getRolCambiarPrecios( Auth():rolUuid() ) ) ) ;
         ON CHANGE(  changeTarifa( aTmp, aGet, aTmpPed ),;
                     loadComisionAgente( aTmp, aGet, aTmpPed ),;
                     recalculaLinea( aTmp, aTmpPed, nDouDiv, oTotal, oTot, oRentLin, cCodDiv ) );
         OF       oFld:aDialogs[1]

      /*
      Para el caso de alquieres vamos a utilizar su precio---------------------
      */

      if aTmp[ __LALQUILER ]

         REDEFINE GET aGet[ _NPREALQ ] VAR aTmp[ _NPREALQ ] ;
            ID       250 ;
            SPINNER ;
            WHEN     ( nMode != ZOOM_MODE .and. !lTotLin ) ;
            ON CHANGE( RecalculaLinea( aTmp, aTmpPed, nDouDiv, oTotal, oTot, oRentLin, cCodDiv ) );
            VALID    ( RecalculaLinea( aTmp, aTmpPed, nDouDiv, oTotal, oTot, oRentLin, cCodDiv ) );
            COLOR    CLR_GET ;
            PICTURE  cPouDiv ;
            OF       oFld:aDialogs[1]

      end if

      REDEFINE GET aGet[ _NIMPTRN ] VAR aTmp[ _NIMPTRN ] ;
         ID       350 ;
         IDSAY    351 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE .AND. !lTotLin ) ;
         ON CHANGE( RecalculaLinea( aTmp, aTmpPed, nDouDiv, oTotal, oTot, oRentLin, cCodDiv ) );
         VALID    ( RecalculaLinea( aTmp, aTmpPed, nDouDiv, oTotal, oTot, oRentLin, cCodDiv ) );
         PICTURE  cPouDiv ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _NPNTVER ] VAR aTmp[ _NPNTVER ] ;
         ID       151 ;
         IDSAY    152 ;
         SPINNER ;
			COLOR 	CLR_GET ;
         PICTURE  cPpvDiv ;
         WHEN     ( nMode != ZOOM_MODE .AND. !lTotLin ) ;
         ON CHANGE( RecalculaLinea( aTmp, aTmpPed, nDouDiv, oTotal, oTot, oRentLin, cCodDiv ) );
         VALID    ( RecalculaLinea( aTmp, aTmpPed, nDouDiv, oTotal, oTot, oRentLin, cCodDiv ) );
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[_NDTODIV] VAR aTmp[_NDTODIV] ;
         ID       260 ;
         IDSAY    261 ;
			SPINNER ;
         MIN      0 ;
         COLOR    Rgb( 255, 0, 0 ) ;
         ON CHANGE( RecalculaLinea( aTmp, aTmpPed, nDouDiv, oTotal, oTot, oRentLin, cCodDiv ) );
         VALID    ( RecalculaLinea( aTmp, aTmpPed, nDouDiv, oTotal, oTot, oRentLin, cCodDiv ) );
         WHEN     ( nMode != ZOOM_MODE .AND. !lTotLin ) ;
         PICTURE  cPouDiv ;
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

      REDEFINE GET aGet[ _CPESOKG ] VAR aTmp[ _CPESOKG ] ;
         ID       175 ;
         WHEN     ( nMode != ZOOM_MODE .AND. !lTotLin ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _NVOLUMEN ] VAR aTmp[ _NVOLUMEN ] ;
         ID       400 ;
         WHEN     ( nMode != ZOOM_MODE .AND. !lTotLin ) ;
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
         WHEN     ( nMode != ZOOM_MODE .AND. !lTotLin ) ;
         ON CHANGE( RecalculaLinea( aTmp, aTmpPed, nDouDiv, oTotal, oTot, oRentLin, cCodDiv ) );
         VALID    ( RecalculaLinea( aTmp, aTmpPed, nDouDiv, oTotal, oTot, oRentLin, cCodDiv ) );
         PICTURE  "@E 999.99" ;
			SPINNER ;
			COLOR 	CLR_GET ;
         OF       oFld:aDialogs[1]

		REDEFINE GET aGet[_NDTOPRM] VAR aTmp[_NDTOPRM] ;
         ID       190 ;
			SPINNER ;
			COLOR 	CLR_GET ;
         WHEN     ( nMode != ZOOM_MODE .AND. !lTotLin ) ;
         ON CHANGE( RecalculaLinea( aTmp, aTmpPed, nDouDiv, oTotal, oTot, oRentLin, cCodDiv ) );
         VALID    ( RecalculaLinea( aTmp, aTmpPed, nDouDiv, oTotal, oTot, oRentLin, cCodDiv ) );
         PICTURE  "@E 99.99";
         OF       oFld:aDialogs[1]

		REDEFINE GET aGet[_NCOMAGE] VAR aTmp[_NCOMAGE] ;
         ID       200 ;
         WHEN     ( nMode != ZOOM_MODE .AND. !lTotLin ) ;
			PICTURE	"@E 99.99" ;
			SPINNER ;
			COLOR 	CLR_GET ;
         OF       oFld:aDialogs[1]

      if !aTmp[ __LALQUILER ]

      REDEFINE GET oComisionLinea VAR nComisionLinea ;
         ID       201 ;
         WHEN     ( .f. ) ;
         PICTURE  cPorDiv ;
         OF       oFld:aDialogs[ 1 ]

      end if

      REDEFINE GET oTotal VAR nTotal ;
         ID       220 ;
         COLOR    CLR_GET ;
         WHEN     .F. ;
			PICTURE 	cPouDiv ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[_NCOSDIV] VAR aTmp[_NCOSDIV] ;
         ID       320 ;
         WHEN     ( oUser():lAdministrador() .and. nMode != ZOOM_MODE );
         PICTURE  cPouDiv ;
         OF       oFld:aDialogs[1] ;
         IDSAY    321 ;

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
         OF       oFld:aDialogs[1]

      /*
      Codigo de almacen--------------------------------------------------------
      */

      REDEFINE GET aGet[ _CALMLIN ] VAR aTmp[ _CALMLIN ] ;
         ID       300 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         VALID    ( cAlmacen( aGet[ _CALMLIN ], , oSayAlm ), if( !uFieldEmpresa( "lNStkAct" ), oStock:lPutStockActual( aTmp[ _CREF ], aTmp[ _CALMLIN ], aTmp[ _CVALPR1 ], aTmp[ _CVALPR2 ], aTmp[ _CLOTE ], aTmp[ _LKITART ], aTmp[ _NCTLSTK ], oStkAct ), .t. ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwAlmacen( aGet[ _CALMLIN ], oSayAlm ) ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET oSayAlm VAR cSayAlm ;
			WHEN 		.F. ;
         ID       301 ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _COBRLIN ] VAR aTmp[ _COBRLIN ] ;
         ID       330 ;
         IDTEXT   331 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( cObras( aGet[ _COBRLIN ], aGet[ _COBRLIN ]:oHelpText, aTmpPed[ _CCODCLI ] ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwObras( aGet[ _COBRLIN ], aGet[ _COBRLIN ]:oHelpText, aTmpPed[ _CCODCLI ], dbfObrasT ) ) ;
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
         WHEN     ( nMode == APPD_MODE ) ;
         PICTURE  "9999" ;
         OF       oFld:aDialogs[2]

      REDEFINE CHECKBOX aGet[ _LIMPLIN ] VAR aTmp[ _LIMPLIN ] ;
         ID       110 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ _DFECHA ] VAR aTmp[ _DFECHA ] ;
         ID       120 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ _DFECFIN ] ;
         VAR      aTmp[ _DFECFIN ] ;
         ID       121 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[2]

      REDEFINE CHECKBOX aGet[ _LCONTROL ] ;
         VAR      aTmp[ _LCONTROL ]  ;
         ID       130 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ _NPVPREC ] ;
         VAR      aTmp[ _NPVPREC ] ;
         ID       140 ;
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

      REDEFINE GET aGet[ _CCODFAM ] VAR aTmp[ _CCODFAM ] ;
			ID 		160 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         BITMAP   "LUPA" ;
         VALID    ( oSayFam:cText( RetFld( aTmp[ _CCODFAM  ], D():Familias( nView ) ) ), .t. );
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

      REDEFINE GET aGet[ _CCODPRV ] VAR aTmp[ _CCODPRV ] ;
         ID       360 ;
         IDTEXT   361 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  ( RetPicCodPrvEmp() ) ;
         BITMAP   "LUPA" ;
         OF       oFld:aDialogs[ 2 ]

      aGet[ _CCODPRV ]:bValid  := {|| cProvee( aGet[ _CCODPRV ], D():Proveedores( nView ), aGet[ _CCODPRV ]:oHelpText ) }
      aGet[ _CCODPRV ]:bHelp   := {|| brwProvee( aGet[ _CCODPRV ], aGet[ _CCODPRV ]:oHelpText ) }

      REDEFINE COMBOBOX oEstadoProduccion ;
         VAR      cEstadoProduccion ;
         ITEMS    aEstadoProduccion ;
         ID       380 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[ 2 ]

      REDEFINE GET aGet[ __DFECSAL ] ;
         VAR      aTmp[ __DFECSAL ];
         ID       200 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[ 2 ]

      REDEFINE GET aGet[ __DFECENT ] ;
         VAR      aTmp[ __DFECENT ];
         ID       210 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[ 2 ]

      /*
      Tercera caja de diálogo--------------------------------------------------
      */

      REDEFINE SAY oTotUni PROMPT nTotNPedCli( aTmp ) ;
         ID       150 ;
         COLOR    "B/W*" ;
         PICTURE  cPicUnd ;
         OF       oFld:aDialogs[3]

      REDEFINE SAY oTotEnt PROMPT nTotEnt ;
         ID       160 ;
         COLOR    "G/W*" ;
         PICTURE  cPicUnd ;
         OF       oFld:aDialogs[3]

      REDEFINE SAY oTotPdt PROMPT nTotPdt;
         ID       170 ;
         COLOR    "R/W*" ;
         PICTURE  cPicUnd ;
         OF       oFld:aDialogs[3]

      oBrwAlbPrv                 := IXBrowse():New( oFld:aDialogs[3] )

      oBrwAlbPrv:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwAlbPrv:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrwAlbPrv:cAlias          := dbfAlbPrvL

      oBrwAlbPrv:lFooter         := .f.
      oBrwAlbPrv:nMarqueeStyle   := 5

      oBrwAlbPrv:CreateFromResource( 180 )

      with object ( oBrwAlbPrv:AddCol() )
         :cHeader             := "Fecha"
         :bEditValue          := {|| Dtoc( dFecAlbPrv( ( dbfAlbPrvL )->cSerAlb + Str( ( dbfAlbPrvL )->nNumAlb ) + ( dbfAlbPrvL )->cSufAlb, dbfAlbPrvT ) ) }
         :nWidth              := 70
      end with

      with object ( oBrwAlbPrv:AddCol() )
         :cHeader             := "Albarán"
         :bEditValue          := {|| AllTrim( ( dbfAlbPrvL )->cSerAlb ) + "/" + AllTrim( Str( ( dbfAlbPrvL )->nNumAlb ) ) + "/" + AllTrim( ( dbfAlbPrvL )->cSufAlb ) }
         :nWidth              := 80
      end with

      with object ( oBrwAlbPrv:AddCol() )
         :cHeader             := "Proveedor"
         :bEditValue          := {|| cNbrAlbPrv( ( dbfAlbPrvL )->cSerAlb + Str( ( dbfAlbPrvL )->nNumAlb ) + ( dbfAlbPrvL )->cSufAlb, dbfAlbPrvT ) }
         :nWidth              := 210
      end with

      with object ( oBrwAlbPrv:AddCol() )
         :cHeader             := "Prop. 1"
         :bEditValue          := {|| ( dbfAlbPrvL )->cValPr1 }
         :nWidth              := 40
         :lHide               := .t.
      end with

      with object ( oBrwAlbPrv:AddCol() )
         :cHeader             := "Prop. 2"
         :bEditValue          := {|| ( dbfAlbPrvL )->cValPr2 }
         :nWidth              := 40
         :lHide               := .t.
      end with

      with object ( oBrwAlbPrv:AddCol() )
         :cHeader             := "Lote"
         :bEditValue          := {|| ( dbfAlbPrvL )->cLote }
         :nWidth              := 60
         :lHide               := .t.
      end with

      with object ( oBrwAlbPrv:AddCol() )
         :cHeader             := cNombreUnidades()
         :bEditValue          := {|| nTotNAlbPrv( dbfAlbPrvL ) }
         :bFooter             := {|| nTotEnt }
         :cEditPicture        := cPicUnd
         :nWidth              := 60
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
      end with

      with object ( oBrwAlbPrv:AddCol() )
         :cHeader             := "UM. Unidad de medición"
         :bEditValue          := {|| ( dbfAlbPrvL )->cUnidad }
         :nWidth              := 25
         :lHide               := .t.
      end with

      with object ( oBrwAlbPrv:AddCol() )
         :cHeader             := "Alm."
         :bEditValue          := {|| ( dbfAlbPrvL )->cAlmLin }
         :nWidth              := 30
      end with

      oBrwAlbPrv:bLDblClick     := {|| EdtAlbPrv( ( dbfAlbPrvL )->cSerAlb + Str( ( dbfAlbPrvL )->nNumAlb ) + ( dbfAlbPrvL )->cSufAlb ), oBrwAlbPrv:Refresh(), oTotEnt:Refresh(), oTotPdt:Refresh() }

      /*
      Cuarta caja de diálogo---------------------------------------------------
      */

      REDEFINE SAY oTot[ 4 ] ;
         PROMPT   nTotRPedCli( aTmp[ _CREF ], aTmp[ _CVALPR1 ], aTmp[ _CVALPR2 ], dbfTmpRes ) ;
         ID       190 ;
         COLOR    "B/W*" ;
         PICTURE  cPicUnd ;
         OF       oFld:aDialogs[4]

      REDEFINE SAY oTot[ 5 ] ;
         PROMPT   nUnidadesRecibidasAlbaranesClientes( cNumPed, aTmp[ _CREF ], aTmp[ _CVALPR1 ], aTmp[ _CVALPR2 ], dbfAlbCliL ) ;
         ID       200 ;
         COLOR    "G/W*" ;
			PICTURE 	cPicUnd ;
         OF       oFld:aDialogs[4]

      REDEFINE SAY oTot[ 6 ] ;
         PROMPT   NotMinus( nTotRPedCli( aTmp[ _CREF ], aTmp[ _CVALPR1 ], aTmp[ _CVALPR2 ], dbfTmpRes ) - nUnidadesRecibidasAlbaranesClientes( cNumPed, aTmp[ _CREF ], aTmp[ _CVALPR1 ], aTmp[ _CVALPR2 ], dbfAlbCliL ) ) ;
         ID       210 ;
         COLOR    "R/W*" ;
			PICTURE 	cPicUnd ;
         OF       oFld:aDialogs[4]

      REDEFINE BUTTON ;
         ID       501 ;
         OF       oFld:aDialogs[4] ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( WinAppRec( oBrwResCli, bEdtRes, dbfTmpRes, oTot, nil, aTmp ) )

      REDEFINE BUTTON ;
         ID       502 ;
         OF       oFld:aDialogs[4] ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( WinEdtRec( oBrwResCli, bEdtRes, dbfTmpRes, oTot, nil, aTmp ) )

      REDEFINE BUTTON ;
         ID       503 ;
         OF       oFld:aDialogs[4] ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( WinDelRec( nil, dbfTmpRes , nil, {|| oBrwResCli:Refresh() } ), oTot[4]:Refresh(), oTot[5]:Refresh(), oTot[6]:Refresh() )

      oBrwResCli                 := IXBrowse():New( oFld:aDialogs[4] )

      oBrwResCli:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwResCli:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrwResCli:cAlias          := dbfTmpRes

      oBrwResCli:nMarqueeStyle   := 6
      oBrwResCli:cName           := "Pedido de cliente.Detalle.Reservas"

      oBrwResCli:CreateFromResource( 220 )

      with object ( oBrwResCli:AddCol() )
         :cHeader             := "Fecha"
         :bEditValue          := {|| Dtoc( ( dbfTmpRes )->dFecRes ) }
         :nWidth              := 70
      end with

      with object ( oBrwResCli:AddCol() )
         :cHeader             := cNombreCajas()
         :bEditValue          := {|| ( dbfTmpRes )->nCajRes }
         :cEditPicture        := cPicUnd
         :nWidth              := 80
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
      end with

      with object ( oBrwResCli:AddCol() )
         :cHeader             := cNombreUnidades()
         :bEditValue          := {|| ( dbfTmpRes )->nUndRes }
         :cEditPicture        := cPicUnd
         :nWidth              := 80
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
      end with

      with object ( oBrwResCli:AddCol() )
         :cHeader             := "Total " + cNombreUnidades()
         :bEditValue          := {|| nTotNResCli( dbfTmpRes ) }
         :cEditPicture        := cPicUnd
         :nWidth              := 230
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
      end with

      if nMode != ZOOM_MODE
         oBrwResCli:bLDblClick  := {|| WinEdtRec( oBrwResCli, bEdtRes, dbfTmpRes, oTot, nil, aTmp ) }
      end if

      /*
      Quinta caja de diálogo---------------------------------------------------
      */

      REDEFINE SAY oTot[ 1 ] PROMPT nTotNPedCli( aTmp ) ;
         ID       150 ;
         COLOR    "B/W*" ;
         PICTURE  cPicUnd ;
         OF       oFld:aDialogs[5]

      REDEFINE SAY oTot[ 2 ] PROMPT nTotRes ;
         ID       160 ;
         COLOR    "G/W*" ;
         PICTURE  cPicUnd ;
         OF       oFld:aDialogs[5]

      REDEFINE SAY oTot[ 3 ] PROMPT nTotNPedCli( aTmp ) - nTotRes ;
         ID       170 ;
         COLOR    "R/W*" ;
         PICTURE  cPicUnd ;
         OF       oFld:aDialogs[5]

      oBrwAlbCli                 := IXBrowse():New( oFld:aDialogs[5] )

      oBrwAlbCli:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwAlbCli:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrwAlbCli:cAlias          := dbfAlbCliL

      oBrwAlbCli:lFooter         := .f.
      oBrwAlbCli:nMarqueeStyle   := 5

      oBrwAlbCli:CreateFromResource( 230 )

      with object ( oBrwAlbCli:AddCol() )
         :cHeader             := "Fecha"
         :bEditValue          := {|| Dtoc( dFecAlbCli( ( dbfAlbCliL )->cSerAlb + Str( ( dbfAlbCliL )->nNumAlb ) + ( dbfAlbCliL )->cSufAlb, dbfAlbCliT ) ) }
         :nWidth              := 70
      end with

      with object ( oBrwAlbCli:AddCol() )
         :cHeader             := "Albarán"
         :bEditValue          := {|| ( dbfAlbCliL )->cSerAlb + "/" + AllTrim( Str( ( dbfAlbCliL )->nNumAlb ) ) + "/" + ( dbfAlbCliL )->cSufAlb }
         :nWidth              := 80
      end with

      with object ( oBrwAlbCli:AddCol() )
         :cHeader             := "Cliente"
         :bEditValue          := {|| cNbrAlbCli( ( dbfAlbCliL )->cSerAlb + Str( ( dbfAlbCliL )->nNumAlb ) + ( dbfAlbCliL )->cSufAlb, dbfAlbCliT ) }
         :nWidth              := 210
      end with

      with object ( oBrwAlbCli:AddCol() )
         :cHeader             := "Prop. 1"
         :bEditValue          := {|| ( dbfAlbCliL )->cValPr1 }
         :nWidth              := 40
         :lHide               := .t.
      end with

      with object ( oBrwAlbCli:AddCol() )
         :cHeader             := "Prop. 2"
         :bEditValue          := {|| ( dbfAlbCliL )->cValPr2 }
         :nWidth              := 40
         :lHide               := .t.
      end with

      with object ( oBrwAlbCli:AddCol() )
         :cHeader             := "Lote"
         :bEditValue          := {|| ( dbfAlbCliL )->cLote }
         :nWidth              := 60
         :lHide               := .t.
      end with

      with object ( oBrwAlbCli:AddCol() )
         :cHeader             := cNombreUnidades()
         :bEditValue          := {|| nTotNAlbCli( dbfAlbCliL ) }
         :cEditPicture        := cPicUnd
         :nWidth              := 60
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
      end with

      with object ( oBrwAlbCli:AddCol() )
         :cHeader             := "UM. Unidad de medición"
         :bEditValue          := {|| ( dbfAlbCliL )->cUnidad }
         :nWidth              := 25
         :lHide               := .t.
      end with

      with object ( oBrwAlbCli:AddCol() )
         :cHeader             := "Alm."
         :bEditValue          := {|| ( dbfAlbCliL )->cAlmLin }
         :nWidth              := 30
      end with

      oBrwAlbCli:bLDblClick     := {|| ZooAlbCli( ( dbfAlbCliL )->cSerAlb + Str( ( dbfAlbCliL )->nNumAlb ) + ( dbfAlbCliL )->cSufAlb ), oBrwAlbCli:Refresh() }

      /*
      Relación de facturas-----------------------------------------------------
      */

      oBrwFacCli                 := IXBrowse():New( oFld:aDialogs[5] )

      oBrwFacCli:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwFacCli:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrwFacCli:cAlias          := dbfFacCliL

      oBrwFacCli:lFooter         := .f.
      oBrwFacCli:nMarqueeStyle   := 5

      oBrwFacCli:CreateFromResource( 240 )

      with object ( oBrwFacCli:AddCol() )
         :cHeader             := "Fecha"
         :bEditValue          := {|| Dtoc( dFecFacCli( ( dbfFacCliL )->cSerie + Str( ( dbfFacCliL )->nNumFac ) + ( dbfFacCliL )->cSufFac, dbfFacCliT ) ) }
         :nWidth              := 70
      end with

      with object ( oBrwFacCli:AddCol() )
         :cHeader             := "Factura"
         :bEditValue          := {|| ( dbfFacCliL )->cSerie + "/" + AllTrim( Str( ( dbfFacCliL )->nNumFac ) ) + "/" + ( dbfFacCliL )->cSufFac }
         :nWidth              := 80
      end with

      with object ( oBrwFacCli:AddCol() )
         :cHeader             := "Cliente"
         :bEditValue          := {|| cNbrFacCli( ( dbfFacCliL )->cSerie + Str( ( dbfFacCliL )->nNumFac ) + ( dbfFacCliL )->cSufFac, dbfFacCliT ) }
         :nWidth              := 210
      end with

      with object ( oBrwFacCli:AddCol() )
         :cHeader             := "Prop. 1"
         :bEditValue          := {|| ( dbfFacCliL )->cValPr1 }
         :nWidth              := 40
         :lHide               := .t.
      end with

      with object ( oBrwFacCli:AddCol() )
         :cHeader             := "Prop. 2"
         :bEditValue          := {|| ( dbfFacCliL )->cValPr2 }
         :nWidth              := 40
         :lHide               := .t.
      end with

      with object ( oBrwFacCli:AddCol() )
         :cHeader             := "Lote"
         :bEditValue          := {|| ( dbfFacCliL )->cLote }
         :nWidth              := 60
         :lHide               := .t.
      end with

      with object ( oBrwFacCli:AddCol() )
         :cHeader             := cNombreUnidades()
         :bEditValue          := {|| nTotNFacCli( dbfFacCliL ) }
         :cEditPicture        := cPicUnd
         :nWidth              := 60
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
      end with

      with object ( oBrwFacCli:AddCol() )
         :cHeader             := "UM. Unidad de medición"
         :bEditValue          := {|| ( dbfFacCliL )->cUnidad }
         :nWidth              := 25
         :lHide               := .t.
      end with

      with object ( oBrwFacCli:AddCol() )
         :cHeader             := "Alm."
         :bEditValue          := {|| ( dbfFacCliL )->cAlmLin }
         :nWidth              := 30
      end with

      oBrwFacCli:bLDblClick   := {|| ZooFacCli( ( dbfFacCliL )->cSerie + Str( ( dbfFacCliL )->nNumFac ) + ( dbfFacCliL )->cSufFac ), oBrwFacCli:Refresh() }

      /*
      Sexta caja de diálogo----------------------------------------------------
      */

      REDEFINE CHECKBOX aGet[_LANULADO] VAR aTmp[_LANULADO] ;
			ID 		400 ;
         WHEN     ( nMode != ZOOM_MODE );
         ON CHANGE( CambiaAnulado( aGet, aTmp ) );
         OF       oFld:aDialogs[6]

      REDEFINE GET aGet[ _DANULADO ] VAR aTmp[ _DANULADO ] ;
         ID       410 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE );
         COLOR    CLR_GET ;
         OF       oFld:aDialogs[6]

      REDEFINE GET aGet[_MANULADO] VAR aTmp[_MANULADO] ;
			MEMO ;
         ID       420 ;
         WHEN     ( nMode != ZOOM_MODE );
			COLOR 	CLR_GET ;
         OF       oFld:aDialogs[6]

      /*
      Septima caja de diálogo--------------------------------------------------
      */

      REDEFINE GET aGet[ _MOBSLIN ] VAR aTmp[ _MOBSLIN ] ;
         MEMO ;
         ID       100 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[ 7 ]

      REDEFINE GET aGet[ _DESCRIP ] VAR aTmp[ _DESCRIP ] ;
         MEMO ;
         ID       110 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[ 7 ]

      REDEFINE BITMAP bmpImage ;
         ID       220 ;
         FILE     ( cFileBitmap( cPatImg(), aTmp[ _CIMAGEN ] ) );
         ON RIGHT CLICK ( bmpImage:lStretch := !bmpImage:lStretch, bmpImage:Refresh() );
         OF       oDlg

         bmpImage:SetColor( , GetSysColor( 15 ) )

      /*
      Octaba caja de diálogo---------------------------------------------------
      */

      REDEFINE GET aGet[ __CCENTROCOSTE ] VAR  aTmp[ __CCENTROCOSTE ] ;
         ID       410 ;
         IDTEXT   411 ;
         BITMAP   "LUPA" ;  
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( oCentroCoste:Existe( aGet[ __CCENTROCOSTE ], aGet[ __CCENTROCOSTE ]:oHelpText, "cNombre" ) );
         ON HELP  ( oCentroCoste:Buscar( aGet[ __CCENTROCOSTE ] ) ) ;
         OF       oFld:aDialogs[8]

      REDEFINE COMBOBOX oTipoCtrCoste ;
         VAR      cTipoCtrCoste ;
         ITEMS    aTipoCtrCoste ;
         ID       140 ;
         WHEN     ( nMode != ZOOM_MODE ) ; 
         OF       oFld:aDialogs[8]

         oTipoCtrCoste:bChange   := {|| clearGet( aGet[ _CTERCTR ] ), loadGet( aGet[ _CTERCTR ], cTipoCtrCoste ) }

      REDEFINE GET aGet[ _CTERCTR ] ;
         VAR      aTmp[ _CTERCTR ] ;
         ID       150 ;
         IDTEXT   160 ;
         BITMAP   "LUPA" ;
         WHEN     ( nMode != ZOOM_MODE ) ; 
         OF       oFld:aDialogs[8]

      /*
      Botones comunes----------------------------------------------------------
      */

      REDEFINE BUTTON oBtnSer;
         ID       552 ;
			OF 		oDlg ;
         ACTION   ( nil )

      REDEFINE BUTTON oBtn ;
         ID       IDOK ;
         OF       oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( SaveDeta( aTmp, aTmpPed, aGet, oFld, oDlg, oBrw, bmpImage, nMode, oStkAct, oSayPr1, oSayPr2, oSayVp1, oSayVp2, oTotal, oEstadoProduccion, oBtn ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
         OF       oDlg ;
         CANCEL ;
         ACTION   ( oDlg:end() )

      REDEFINE BUTTON ;
         ID       9 ;
         OF       oDlg ;
         ACTION   ( ChmHelp( "Añadir_v" ) )

      if nMode != ZOOM_MODE

         if uFieldEmpresa( "lGetLot")
            oDlg:AddFastKey( VK_RETURN,   {|| oBtn:SetFocus(), oBtn:Click() } )
         end if 

         oDlg:AddFastKey( VK_F5, 			{|| oBtn:SetFocus(), oBtn:Click() } )

         oFld:aDialogs[4]:AddFastKey( VK_F2, {|| WinAppRec( oBrwResCli, bEdtRes, dbfTmpRes, oTot, nil, aTmp ) } )
         oFld:aDialogs[4]:AddFastKey( VK_F3, {|| WinEdtRec( oBrwResCli, bEdtRes, dbfTmpRes, oTot, nil, aTmp ) } )
         oFld:aDialogs[4]:AddFastKey( VK_F4, {|| DbDelRec( oBrwResCli, dbfTmpRes ), oTot[4]:Refresh(), oTot[5]:Refresh(), oTot[6]:Refresh() } )

      end if

      oDlg:AddFastKey( VK_F1, {|| ChmHelp( "Añadir_v" ) } )

      oDlg:bStart := {||   SetDlgMode( aTmp, aGet, nMode, oStkAct, oSayPr1, oSayPr2, oSayVp1, oSayVp2, oTotal, aTmpPed, oFld, oRentLin, oBrwAlbCli, oBrwAlbPrv, oBrwFacCli ),;
                           if( !Empty( oBtnSer ), oBtnSer:Hide(), ),;
                           if( !Empty( cCodArtEnt ), aGet[ _CREF ]:lValid(), ),;
                           loadGet( aGet[ _CTERCTR ], cTipoCtrCoste ), aGet[ _CTERCTR ]:lValid(),;
                           aGet[ _CUNIDAD ]:lValid(), aGet[ _CCODPRV ]:lValid(), aGet[ _COBRLIN ]:lValid() }

   ACTIVATE DIALOG oDlg ; 
         ON INIT     ( EdtDetMenu( aGet[ _CREF ], oDlg ), oBrwResCli:Load() );
         ON PAINT    ( RecalculaLinea( aTmp, aTmpPed, nDouDiv, oTotal, oTot, oRentLin, cCodDiv ) );
         CENTER

   EndDetMenu()

   ( D():PedidosProveedoresLineas( nView ) )->( OrdSetFocus( nOrdPedPrv ) )

   ( dbfAlbCliL )->( OrdScope( 0, nil ) )
   ( dbfAlbCliL )->( OrdScope( 1, nil ) )
   ( dbfAlbCliL )->( OrdSetFocus( nOrdAnt ) )

   ( dbfFacCliL )->( OrdScope( 0, nil ) )
   ( dbfFacCliL )->( OrdScope( 1, nil ) )
   ( dbfFacCliL )->( OrdSetFocus( nOrdFacCliL ) )

   ( dbfAlbPrvL )->( OrdScope( 0, nil ) )
   ( dbfAlbPrvL )->( OrdScope( 1, nil ) )
   ( dbfAlbPrvL )->( OrdSetFocus( nOrdAlbPrv ) )

   ( dbfTmpRes )->( OrdScope( 0, nil ) )
   ( dbfTmpRes )->( OrdScope( 1, nil ) )
   ( dbfTmpRes )->( dbGoTop() )

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

STATIC FUNCTION EdtRes( aTmp, aGet, dbfTmpRes, oBrw, oTot, bValid, nMode, aTmpLin )

   local oDlg
   local oGet
   local oSay

   if nMode == APPD_MODE
      aTmp[ _CSERPED ]  := aTmpLin[ _CSERPED ]
      aTmp[ _NNUMPED ]  := aTmpLin[ _NNUMPED ]
      aTmp[ _CSUFPED ]  := aTmpLin[ _CSUFPED ]
      aTmp[ _CREF    ]  := aTmpLin[ _CREF    ]
      aTmp[ _CCODPR1 ]  := aTmpLin[ _CCODPR1 ]
      aTmp[ _CCODPR2 ]  := aTmpLin[ _CCODPR2 ]
      aTmp[ _CVALPR1 ]  := aTmpLin[ _CVALPR1 ]
      aTmp[ _CVALPR2 ]  := aTmpLin[ _CVALPR2 ]
   end if

   DEFINE DIALOG oDlg RESOURCE "LRESPEDCLI" TITLE LblTitle( nMode ) + "reservas a pedidos de clientes"

      REDEFINE GET aTmp[ ( D():PedidosClientesReservas( nView ) )->( fieldPos( "DFECRES" ) ) ];
			ID 		100 ;
         SPINNER ;
			COLOR 	CLR_GET ;
         OF       oDlg

      REDEFINE GET oGet VAR aTmp[ ( D():PedidosClientesReservas( nView ) )->( fieldPos( "NCAJRES" ) ) ] ;
			ID 		110 ;
         PICTURE  cPicUnd ;
			COLOR 	CLR_GET ;
         ON CHANGE( oSay:Refresh() ) ;
         SPINNER ;
         OF       oDlg

      REDEFINE GET aTmp[ ( D():PedidosClientesReservas( nView ) )->( fieldPos( "NUNDRES" ) ) ] ;
         ID       120 ;
         PICTURE  cPicUnd ;
         COLOR    CLR_GET ;
         ON CHANGE( oSay:Refresh() ) ;
         SPINNER ;
         OF       oDlg

      REDEFINE SAY oSay PROMPT NotCaja( aTmp[ ( D():PedidosClientesReservas( nView ) )->( fieldPos( "NCAJRES" ) ) ] ) * aTmp[ ( D():PedidosClientesReservas( nView ) )->( fieldPos( "NUNDRES" ) ) ] ;
         ID       130 ;
         PICTURE  cPicUnd ;
         COLOR    CLR_GET ;
         OF       oDlg

      /*
      Botones------------------------------------------------------------------
      */

		REDEFINE BUTTON ;
         ID       IDOK ;
         OF       oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( WinGather( aTmp, nil, dbfTmpRes, oBrw, nMode ),;
                    oTot[4]:Refresh(), oTot[5]:Refresh(), oTot[6]:Refresh(),;
                    oDlg:end( IDOK ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
         OF       oDlg ;
         CANCEL ;
         ACTION   ( oDlg:end() )

   if nMode != ZOOM_MODE
      oDlg:AddFastKey( VK_F5, {|| WinGather( aTmp, nil, dbfTmpRes, oBrw, nMode ), oTot[4]:Refresh(), oTot[5]:Refresh(), oTot[6]:Refresh(), oDlg:end( IDOK ) } )
   end if

   ACTIVATE DIALOG oDlg ON INIT ( if( !lUseCaj(), oGet:hide(), ) ) CENTER

RETURN ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

Static Function EdtDoc( aTmp, aGet, dbfPedCliD, oBrw, bWhen, bValid, nMode, aTmpLin )

   local oDlg
   local oRuta
   local oNombre
   local oObservacion

   DEFINE DIALOG oDlg RESOURCE "DOCUMENTOS" TITLE LblTitle( nMode ) + "documento de pedidos de clientes"

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

Static Function PrnSerie()

	local oDlg
   local oFmtDoc
   local cFmtDoc     := cFormatoDocumento( ( D():PedidosClientes( nView ) )->cSerPed, "nPedCli", D():Contadores( nView ) )
   local oSayFmt
   local cSayFmt
   local oSerIni
   local oSerFin
   local cSerIni     := (D():PedidosClientes( nView ))->cSerPed
   local cSerFin     := (D():PedidosClientes( nView ))->cSerPed
   local nDocIni     := (D():PedidosClientes( nView ))->nNumPed
   local nDocFin     := (D():PedidosClientes( nView ))->nNumPed
   local cSufIni     := (D():PedidosClientes( nView ))->cSufPed
   local cSufFin     := (D():PedidosClientes( nView ))->cSufPed
   local dFecDesde   := CtoD( "01/01/" + Str( Year( Date() ) ) )
   local dFecHasta   := Date()
   local oRango
   local nRango      := 1
   local oPrinter
   local cPrinter    := PrnGetName()
   local lCopiasPre  := .t.
   local lInvOrden   := .f.
   local oNumCop
   local nNumCop     := if( nCopiasDocumento( ( D():PedidosClientes( nView ) )->cSerPed, "nPedCli", D():Contadores( nView ) ) == 0, Max( Retfld( ( D():PedidosClientes( nView ) )->cCodCli, D():Clientes( nView ), "CopiasF" ), 1 ), nCopiasDocumento( ( D():PedidosClientes( nView ) )->cSerPed, "nPedCli", D():Contadores( nView ) ) )

   if Empty( cFmtDoc )
      cFmtDoc        := cSelPrimerDoc( "PC" )
   end if

   cSayFmt           := cNombreDoc( cFmtDoc )

   DEFINE DIALOG oDlg RESOURCE "IMPSERIES" TITLE "Imprimir series de pedidos"

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
     	ON HELP  ( BrwDocumento( oFmtDoc, oSayFmt, "PC" ) ) ;
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

   		nRecno      := (D():PedidosClientes( nView ))->( recno() )
   		nOrdAnt     := (D():PedidosClientes( nView ))->( OrdSetFocus("NNUMPED") )

   		if !lInvOrden

      		( D():PedidosClientes( nView ) )->( dbSeek( cDocIni, .t. ) )

      		while ( D():PedidosClientes( nView ) )->cSerPed + Str( ( D():PedidosClientes( nView ) )->nNumPed ) + ( D():PedidosClientes( nView ) )->cSufPed >= cDocIni .and. ;
            		( D():PedidosClientes( nView ) )->cSerPed + Str( ( D():PedidosClientes( nView ) )->nNumPed ) + ( D():PedidosClientes( nView ) )->cSufPed <= cDocFin .and. ;
            		!( D():PedidosClientes( nView ) )->( eof() )

            		lChgImpDoc( D():PedidosClientes( nView ) )

         		if lCopiasPre

		            nCopyClient := if( nCopiasDocumento( ( D():PedidosClientes( nView ) )->cSerPed, "nPedCli", D():Contadores( nView ) ) == 0, Max( Retfld( ( D():PedidosClientes( nView ) )->cCodCli, D():Clientes( nView ), "CopiasF" ), 1 ), nCopiasDocumento( ( D():PedidosClientes( nView ) )->cSerPed, "nPedCli", D():Contadores( nView ) ) )

            		GenPedCli( IS_PRINTER, "Imprimiendo documento : " + ( D():PedidosClientes( nView ) )->cSerPed + Str( ( D():PedidosClientes( nView ) )->nNumPed ) + ( D():PedidosClientes( nView ) )->cSufPed, cFmtDoc, cPrinter, nCopyClient )

         		else

		            GenPedCli( IS_PRINTER, "Imprimiendo documento : " + ( D():PedidosClientes( nView ) )->cSerPed + Str( ( D():PedidosClientes( nView ) )->nNumPed ) + ( D():PedidosClientes( nView ) )->cSufPed, cFmtDoc, cPrinter, nNumCop )

         		end if

         		( D():PedidosClientes( nView ) )->( dbSkip() )

      		end do

   		else

      		( D():PedidosClientes( nView ) )->( DbSeek( cDocFin ) )

      		while ( D():PedidosClientes( nView ) )->cSerPed + Str( ( D():PedidosClientes( nView ) )->nNumPed ) + ( D():PedidosClientes( nView ) )->cSufPed >= cDocIni .and.;
            		( D():PedidosClientes( nView ) )->cSerPed + Str( ( D():PedidosClientes( nView ) )->nNumPed ) + ( D():PedidosClientes( nView ) )->cSufPed <= cDocFin .and.;
            		!( D():PedidosClientes( nView ) )->( Bof() )

            		lChgImpDoc( D():PedidosClientes( nView ) )

         		if lCopiasPre

		            nCopyClient := if( nCopiasDocumento( ( D():PedidosClientes( nView ) )->cSerPed, "nPedCli", D():Contadores( nView ) ) == 0, Max( Retfld( ( D():PedidosClientes( nView ) )->cCodCli, D():Clientes( nView ), "CopiasF" ), 1 ), nCopiasDocumento( ( D():PedidosClientes( nView ) )->cSerPed, "nPedCli", D():Contadores( nView ) ) )

            		GenPedCli( IS_PRINTER, "Imprimiendo documento : " + ( D():PedidosClientes( nView ) )->cSerPed + Str( ( D():PedidosClientes( nView ) )->nNumPed ) + ( D():PedidosClientes( nView ) )->cSufPed, cFmtDoc, cPrinter, nCopyClient )

         		else

		            GenPedCli( IS_PRINTER, "Imprimiendo documento : " + ( D():PedidosClientes( nView ) )->cSerPed + Str( ( D():PedidosClientes( nView ) )->nNumPed ) + ( D():PedidosClientes( nView ) )->cSufPed, cFmtDoc, cPrinter, nNumCop )

         		end if

         		( D():PedidosClientes( nView ) )->( dbSkip( -1 ) )

      		end while

   		end if

   	else

   		nRecno      := (D():PedidosClientes( nView ))->( recno() )
   		nOrdAnt     := (D():PedidosClientes( nView ))->( OrdSetFocus( "DFECPED" ) )

   		if !lInvOrden

      		( D():PedidosClientes( nView ) )->( dbGoTop() )

      		while !( D():PedidosClientes( nView ) )->( eof() )

            	if ( D():PedidosClientes( nView ) )->dFecPed >= dFecDesde .and. ( D():PedidosClientes( nView ) )->dFecPed <= dFecHasta

            		lChgImpDoc( D():PedidosClientes( nView ) )

         			if lCopiasPre

			            nCopyClient := if( nCopiasDocumento( ( D():PedidosClientes( nView ) )->cSerPed, "nPedCli", D():Contadores( nView ) ) == 0, Max( Retfld( ( D():PedidosClientes( nView ) )->cCodCli, D():Clientes( nView ), "CopiasF" ), 1 ), nCopiasDocumento( ( D():PedidosClientes( nView ) )->cSerPed, "nPedCli", D():Contadores( nView ) ) )

	            		GenPedCli( IS_PRINTER, "Imprimiendo documento : " + ( D():PedidosClientes( nView ) )->cSerPed + Str( ( D():PedidosClientes( nView ) )->nNumPed ) + ( D():PedidosClientes( nView ) )->cSufPed, cFmtDoc, cPrinter, nCopyClient )

         			else

		            	GenPedCli( IS_PRINTER, "Imprimiendo documento : " + ( D():PedidosClientes( nView ) )->cSerPed + Str( ( D():PedidosClientes( nView ) )->nNumPed ) + ( D():PedidosClientes( nView ) )->cSufPed, cFmtDoc, cPrinter, nNumCop )

         			end if

         		end if	

         		( D():PedidosClientes( nView ) )->( dbSkip() )

      		end do

   		else

      		( D():PedidosClientes( nView ) )->( dbGobottom() )

      		while !( D():PedidosClientes( nView ) )->( Bof() )

            	if ( D():PedidosClientes( nView ) )->dFecPed >= dFecDesde .and. ( D():PedidosClientes( nView ) )->dFecPed <= dFecHasta

            		lChgImpDoc( D():PedidosClientes( nView ) )

         			if lCopiasPre

			            nCopyClient := if( nCopiasDocumento( ( D():PedidosClientes( nView ) )->cSerPed, "nPedCli", D():Contadores( nView ) ) == 0, Max( Retfld( ( D():PedidosClientes( nView ) )->cCodCli, D():Clientes( nView ), "CopiasF" ), 1 ), nCopiasDocumento( ( D():PedidosClientes( nView ) )->cSerPed, "nPedCli", D():Contadores( nView ) ) )

            			GenPedCli( IS_PRINTER, "Imprimiendo documento : " + ( D():PedidosClientes( nView ) )->cSerPed + Str( ( D():PedidosClientes( nView ) )->nNumPed ) + ( D():PedidosClientes( nView ) )->cSufPed, cFmtDoc, cPrinter, nCopyClient )

         			else

			            GenPedCli( IS_PRINTER, "Imprimiendo documento : " + ( D():PedidosClientes( nView ) )->cSerPed + Str( ( D():PedidosClientes( nView ) )->nNumPed ) + ( D():PedidosClientes( nView ) )->cSufPed, cFmtDoc, cPrinter, nNumCop )

         			end if

         		end if	

         		( D():PedidosClientes( nView ) )->( dbSkip( -1 ) )

      		end while

   		end if

   	end if

   	( D():PedidosClientes( nView ) )->( dbGoTo( nRecNo ) )
   	( D():PedidosClientes( nView ) )->( ordSetFocus( nOrdAnt ) )	

   	oDlg:enable()

RETURN NIL

//--------------------------------------------------------------------------//

/*
Borra todas las lineas de detalle de un pedido
*/

STATIC FUNCTION DelDetalle( cNumPed )

   DEFAULT cNumPed   := ( D():PedidosClientes( nView ) )->cSerPed + Str( ( D():PedidosClientes( nView ) )->nNumPed ) + ( D():PedidosClientes( nView )  )->cSufPed

   // Stock -------------------------------------------------------------------

   //oStock:PedCli( cNumPed, ( D():PedidosClientes( nView ) )->cCodAlm, .t., .f. )

   // Lineas ------------------------------------------------------------------

   if ( D():PedidosClientesLineas( nView ) )->( dbSeek( cNumPed ) )
      while ( D():PedidosClientesLineas( nView ) )->cSerPed + Str( ( D():PedidosClientesLineas( nView ) )->nNumPed ) + ( D():PedidosClientesLineas( nView ) )->cSufPed == cNumPed
         if dbLock( D():PedidosClientesLineas( nView ) )
            ( D():PedidosClientesLineas( nView ) )->( dbDelete() )
            ( D():PedidosClientesLineas( nView ) )->( dbUnLock() )
         end if
         ( D():PedidosClientesLineas( nView ) )->( dbSkip() )
      end while
   end if

   // Reservas ----------------------------------------------------------------

   if ( D():PedidosClientesReservas( nView ) )->( dbSeek( cNumPed ) )
      while ( D():PedidosClientesReservas( nView ) )->cSerPed + Str( ( D():PedidosClientesReservas( nView ) )->nNumPed ) + ( D():PedidosClientesReservas( nView ) )->cSufPed == cNumPed
         if dbLock( D():PedidosClientesReservas( nView ) )
            ( D():PedidosClientesReservas( nView ) )->( dbDelete() )
            ( D():PedidosClientesReservas( nView ) )->( dbUnLock() )
         end if
         ( D():PedidosClientesReservas( nView ) )->( dbSkip() )
      end while
   end if

   //Entregas------------------------------------------------------------------

   if ( D():PedidosClientesPagos( nView ) )->( dbSeek( cNumPed ) )
      while ( D():PedidosClientesPagos( nView ) )->( dbSeek( ( D():PedidosClientes( nView ) )->cSerPed + Str( ( D():PedidosClientes( nView ) )->nNumPed ) + ( D():PedidosClientes( nView ) )->cSufPed ) ) .and. !( D():PedidosClientesPagos( nView ) )->( eof() )
         if dbDialogLock( D():PedidosClientesPagos( nView ) )
            ( D():PedidosClientesPagos( nView ) )->( dbDelete() )
            ( D():PedidosClientesPagos( nView ) )->( dbUnLock() )
         end if
         ( D():PedidosClientesPagos( nView ) )->( dbSkip() )
      end do
   end if

RETURN NIL

//------------------------------------------------------------------------//

STATIC FUNCTION ChgSta( oBrw )

   local nRec
   local nRecAlb
   local cNumPed
   local lQuit
   local nOrdAnt

   if ApoloMsgNoYes( "Al cambiar el estado perderá la referencia a cualquier documento que esté asociado.", "¿Desea cambiarlo?" )

      for each nRec in ( oBrw:aSelected )

         ( D():PedidosClientes( nView ) )->( dbGoTo( nRec ) )

         lQuit                         := .f.
         cNumPed                       := ( D():PedidosClientes( nView ) )->cSerPed + Str( ( D():PedidosClientes( nView ) )->nNumPed ) + ( D():PedidosClientes( nView ) )->cSufPed

         /*
         Cambiamos el estado---------------------------------------------------
         */

         if dbLock( D():PedidosClientes( nView ) )

            if ( D():PedidosClientes( nView ) )->nEstado == 1
               ( D():PedidosClientes( nView ) )->nEstado := 3
            else
               lQuit                   := .f.
               ( D():PedidosClientes( nView ) )->nEstado := 1
            end if

            ( D():PedidosClientes( nView ) )->lSndDoc  := !( D():PedidosClientes( nView ) )->lSndDoc
            ( D():PedidosClientes( nView ) )->dFecCre  := Date()
            ( D():PedidosClientes( nView ) )->cTimCre  := Time()

            ( D():PedidosClientes( nView ) )->( dbRUnlock() )

         end if

         if lQuit

            /*
            Borramos la referencia a cualquier cabecera de albarán asociado-------
            */

            nRecAlb  := ( dbfAlbCliT )->( RecNo() )
            nOrdAnt  := ( dbfAlbCliT )->( OrdSetFocus( "cNumPed" ) )
          
            while ( dbfAlbCliT )->( dbSeek( cNumPed ) )  .and. !( dbfAlbCliT )->( Eof() )

            	if dbLock( dbfAlbCliT )
               	( dbfAlbCliT )->cNumPed    := ""
               	( dbfAlbCliT )->( dbUnLock() )
            	end if

            end while

            ( dbfAlbCliT )->( OrdSetFocus( nOrdAnt ) )
            ( dbfAlbCliT )->( dbGoTo( nRecAlb ) )

            /*
            Borramos la referencia a cualquier linea de albarán asociado-------
            */

            nRecAlb  := ( dbfAlbCliL )->( RecNo() )
            nOrdAnt  := ( dbfAlbCliL )->( OrdSetFocus( "cNumPed" ) )

            while ( dbfAlbCliL )->( dbSeek( cNumPed ) ) .and. !( dbfAlbCliL )->( eof() )

               if dbLock( dbfAlbCliL )
                  ( dbfAlbCliL )->cNumPed    := ""
                  ( dbfAlbCliL )->( dbUnLock() )
               end if

            end while
            
            ( dbfAlbCliL )->( OrdSetFocus( nOrdAnt ) )
            ( dbfAlbCliL )->( dbGoTo( nRecAlb ) )

            /*
            Borramos la referencia a cualquier cabecera de factura asociada-------
            */

            nRecAlb  := ( dbfFacCliT )->( RecNo() )
            nOrdAnt  := ( dbfFacCliT )->( OrdSetFocus( "cNumPed" ) )

            while ( dbfFacCliT )->( dbSeek( cNumPed ) )  .and. !( dbfFacCliT )->( Eof() )

               if dbLock( dbfFacCliT )
                  ( dbfFacCliT )->cNumPed    := ""
                  ( dbfFacCliT )->( dbUnLock() )
               end if

            end while

            ( dbfFacCliT )->( OrdSetFocus( nOrdAnt ) )
            ( dbfFacCliT )->( dbGoTo( nRecAlb ) )

            /*
            Borramos la referencia a cualquier linea de albarán asociado-------
            */

            nRecAlb  := ( dbfFacCliL )->( RecNo() )
            nOrdAnt  := ( dbfFacCliL )->( OrdSetFocus( "cNumPed" ) )

            while ( dbfFacCliL )->( dbSeek( cNumPed ) )  .and. !( dbfFacCliL )->( Eof() )

                if dbLock( dbfFacCliL )
                    ( dbfFacCliL )->cNumPed    := ""
                    ( dbfFacCliL )->( dbUnLock() )
                end if

            end while

            ( dbfFacCliL )->( OrdSetFocus( nOrdAnt ) )
            ( dbfFacCliL )->( dbGoTo( nRecAlb ) )

         end if

      next

   end if

   oBrw:Refresh()
   oBrw:SetFocus()

RETURN NIL

//-------------------------------------------------------------------------//

static function lGenPedCli( oBrw, oBtn, nDevice )

   local bAction

   DEFAULT nDevice   := IS_PRINTER

   if Empty( oBtn )
      return nil
   end if

   IF !( D():Documentos( nView ) )->( dbSeek( "PC" ) )

         DEFINE BTNSHELL RESOURCE "GC_DOCUMENT_WHITE_" OF oWndBrw ;
            NOBORDER ;
            ACTION   ( msgStop( "No hay facturas de clientes predefinidas" ) );
            TOOLTIP  "No hay documentos" ;
            FROM     oBtn ;
            CLOSED ;
            LEVEL    ACC_EDIT

   ELSE

      WHILE ( D():Documentos( nView ) )->cTipo == "PC" .AND. !( D():Documentos( nView ) )->( eof() )

         bAction  := bGenFac( nDevice, "Imprimiendo pedidos de clientes", ( D():Documentos( nView ) )->Codigo )

         oWndBrw:NewAt( "gc_document_white_", , , bAction, Rtrim( ( D():Documentos( nView ) )->cDescrip ) , , , , , oBtn )

         ( D():Documentos( nView ) )->( dbSkip() )

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
      bGen     := {|| GenPedCli( nDev, cTit, cCod ) }
   else
      bGen     := {|| GenPedCli( nDev, cTit, cCod ) }
   end if

return ( bGen )

//----------------------------------------------------------------------------//

STATIC FUNCTION RecPedCli( aTmpPed )

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

   ( D():Articulos( nView ) )->( ordSetFocus( "Codigo" ) )

   ( dbfTmpLin )->( dbGotop() )
   while !( dbfTmpLin )->( eof() )

      /*
      Ahora buscamos por el codigo interno
      */

      if ( D():Articulos( nView ) )->( dbSeek( ( dbfTmpLin )->cRef ) )

         if aTmpPed[ _NREGIVA ] <= 2
            ( dbfTmpLin )->nIva     := nIva( D():TiposIva( nView ), ( D():Articulos( nView ) )->TipoIva )
            ( dbfTmpLin )->nReq     := nReq( D():TiposIva( nView ), ( D():Articulos( nView ) )->TipoIva )
         end if

         /*
         Ahora recogemos el impuesto especial si lo hay
         */

         if !Empty( ( D():Articulos( nView ) )->cCodImp )
            ( dbfTmpLin )->cCodImp  := ( D():Articulos( nView ) )->cCodImp
            ( dbfTmpLin )->nValImp  := oNewImp:nValImp( ( D():Articulos( nView ) )->cCodImp, aTmpPed[ _LIVAINC ], ( dbfTmpLin )->nIva )
         end if

         /*
         Ahora recogemos el impuesto especial si lo hay
         */

         if !Empty( ( D():Articulos( nView ) )->cCodImp )
            ( dbfTmpLin )->cCodImp  := ( D():Articulos( nView ) )->cCodImp
            ( dbfTmpLin )->nValImp  := oNewImp:nValImp( ( D():Articulos( nView ) )->cCodImp )
         end if

         /*
         Tomamos los precios de la base de datos de articulos---------------------
         */

         ( dbfTmpLin )->nPreDiv  := nRetPreArt( ( dbfTmpLin )->nTarLin, aTmpPed[ _CDIVPED ], aTmpPed[ _LIVAINC ], D():Articulos( nView ), D():Divisas( nView ), dbfKit, D():TiposIva( nView ), , , oNewImp )

         /*
         Linea por contadores-----------------------------------------------------
         */

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

         case !Empty( aTmpPed[ _CCODTAR ] )

            cCodFam     := ( dbfTmpLin )->cCodFam

            nImpOfe     := RetPrcTar( ( dbfTmpLin )->cRef, aTmpPed[ _CCODTAR ], ( dbfTmpLin )->cCodPr1, ( dbfTmpLin )->cCodPr2, ( dbfTmpLin )->cValPr1, ( dbfTmpLin )->cValPr2, dbfTarPreL, ( dbfTmpLin )->nTarLin )
            if nImpOfe  != 0
               ( dbfTmpLin )->nPreDiv  := nImpOfe
            end if

            nImpOfe     := RetPctTar( ( dbfTmpLin )->cRef, cCodFam, aTmpPed[ _CCODTAR ], ( dbfTmpLin )->cCodPr1, ( dbfTmpLin )->cCodPr2, ( dbfTmpLin )->cValPr1, ( dbfTmpLin )->cValPr2, dbfTarPreL )
            if nImpOfe  != 0
               ( dbfTmpLin )->nDto     := nImpOfe
            end if

            nImpOfe     := RetComTar( ( dbfTmpLin )->cRef, cCodFam, aTmpPed[ _CCODTAR ], ( dbfTmpLin )->cCodPr1, ( dbfTmpLin )->cCodPr2, ( dbfTmpLin )->cValPr1, ( dbfTmpLin )->cValPr2, aTmpPed[ _CCODAGE ], dbfTarPreL, dbfTarPreS )
            if nImpOfe  != 0
               ( dbfTmpLin )->nComAge  := nImpOfe
            end if

            /*
            Descuento de promoci¢n, esta funci¢n comprueba si existe y si es
            asi devuelve el descunto de la promoci¢n.
            */

            nImpOfe     := RetDtoPrm( ( dbfTmpLin )->cRef, cCodFam, aTmpPed[ _CCODTAR ], ( dbfTmpLin )->cCodPr1, ( dbfTmpLin )->cCodPr2, ( dbfTmpLin )->cValPr1, ( dbfTmpLin )->cValPr2, aTmpPed[ _DFECPED ], dbfTarPreL )

            if nImpOfe  != 0
               ( dbfTmpLin )->nDtoPrm  := nImpOfe
            end if

            /*
            Obtenemos el descuento de Agente
            */

            nDtoAge     := RetDtoAge( ( dbfTmpLin )->cRef, cCodFam, aTmpPed[ _CCODTAR ], ( dbfTmpLin )->cCodPr1, ( dbfTmpLin )->cCodPr2, ( dbfTmpLin )->cValPr1, ( dbfTmpLin )->cValPr2, aTmpPed[ _DFECPED ], aTmpPed[ _CCODAGE ],  dbfTarPreL, dbfTarPreS )

            if nDtoAge  != 0
               ( dbfTmpLin )->nComAge  := nDtoAge
            end if

         end case

         /*
         Buscamos si existen atipicas de clientes------------------------------
         */

         hAtipica := hAtipica( hValue( dbfTmpLin, aTmpPed ) )

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

         nImpOfe     := nImpOferta( ( dbfTmpLin )->cRef, aTmpPed[ _CCODCLI ], aTmpPed[ _CCODGRP ], ( dbfTmpLin )->nUniCaja, aTmpPed[ _DFECPED ], dbfOferta, ( dbfTmpLin )->nTarLin, nil, ( dbfTmpLin )->cCodPr1, ( dbfTmpLin )->cCodPr2, ( dbfTmpLin )->cValPr1, ( dbfTmpLin )->cValPr2 )
         if nImpOfe  != 0
            ( dbfTmpLin )->nPreDiv     := nCnv2Div( nImpOfe, cDivEmp(), aTmpPed[ _CDIVPED ] )
         end if

         /*
         Buscamos si existen descuentos en las ofertas
         */

         nImpOfe     := nDtoOferta( ( dbfTmpLin )->cRef, aTmpPed[ _CCODCLI ], aTmpPed[ _CCODGRP ], ( dbfTmpLin )->nUniCaja, aTmpPed[ _DFECPED ], dbfOferta, ( dbfTmpLin )->cCodPr1, ( dbfTmpLin )->cCodPr2, ( dbfTmpLin )->cValPr1, ( dbfTmpLin )->cValPr2 )
         if nImpOfe  != 0
            ( dbfTmpLin )->nDtoPrm  := nImpOfe
         end if

      end if

      ( dbfTmpLin )->( dbSkip() )

   end while

   ( dbfTmpLin )->( dbGoTo( nRecno ) )

return nil

//--------------------------------------------------------------------------//

Static Function lCheckGenerado( cSerie, nNumero, cSufijo, cCodArt, cCodPr1, cCodPr2, cDetalle )

   local lCheck   := .t.
   local nOrdAnt  := ( D():PedidosProveedores( nView ) )->( OrdSetFocus( "CPEDCLI" ) )
   local nOrdAnt2 := ( D():PedidosProveedoresLineas( nView ) )->( OrdSetFocus( "NNUMPED" ) )

   ( D():PedidosProveedores( nView ) )->( dbGoTop() )

   if ( D():PedidosProveedores( nView ) )->( dbSeek( cSerie + Str( nNumero ) + cSufijo ) )

      while ( D():PedidosProveedores( nView ) )->cNumPedCli == cSerie + Str( nNumero ) + cSufijo .and.;
            !( D():PedidosProveedores( nView ) )->( eof() )

          if ( D():PedidosProveedoresLineas( nView ) )->( dbSeek( ( D():PedidosProveedores( nView ) )->cSerPed + Str( ( D():PedidosProveedores( nView ) )->nNumPed ) + ( D():PedidosProveedores( nView ) )->cSufPed ) )

          while ( D():PedidosProveedores( nView ) )->cSerPed + str( ( D():PedidosProveedores( nView ) )->nNumPed ) + ( D():PedidosProveedores( nView ) )->cSufPed == ( D():PedidosProveedoresLineas( nView ) )->cSerPed + str( ( D():PedidosProveedoresLineas( nView ) )->nNumPed ) + ( D():PedidosProveedoresLineas( nView ) )->cSufPed .and.;
                !( D():PedidosProveedoresLineas( nView ) )->( eof() )

                  if ( D():PedidosProveedoresLineas( nView ) )->cRef + ( D():PedidosProveedoresLineas( nView ) )->cCodPr1 + ( D():PedidosProveedoresLineas( nView ) )->cCodPr2 + ( D():PedidosProveedoresLineas( nView ) )->cDetalle == cCodArt + cCodPr1 + cCodPr2 + cDetalle
                     lCheck   := .f.
                  end if

                  ( D():PedidosProveedoresLineas( nView ) )->( dbSkip() )

              end while

          end if

          ( D():PedidosProveedores( nView ) )->( dbSkip() )

      end while

   end if

   ( D():PedidosProveedores( nView ) )->( OrdSetFocus( nOrdAnt ) )
   ( D():PedidosProveedoresLineas( nView ) )->( OrdSetFocus( nOrdAnt2 ) )
   ( D():PedidosProveedores( nView ) )->( dbGoTop() )

return lCheck

//---------------------------------------------------------------------------//

static function CambiaAnulado( aGet, aTmp )

   if aTmp[_LANULADO]

      aGet[_DANULADO]:cText( GetSysDate() )
      aTmp[_MANULADO]   := ""

   else

      aGet[_DANULADO]:cText( Ctod( "" ) )
      aTmp[_MANULADO]   := ""

   end if

return .t.

//---------------------------------------------------------------------------//

Static Function Ped2FacCli( cNumPed, dbfFacCliT )

   local nOrd
   local cNumFac

   nOrd 		:= ( dbfFacCliT )->( OrdSetFocus( "cNumPed" ) )

   if ( dbfFacCliT )->( dbSeek( cNumPed ) )
      cNumFac  	:= ( dbfFacCliT )->cSerie + Str( ( dbfFacCliT )->nNumFac ) + ( dbfFacCliT )->cSufFac
   end if

   if !Empty( cNumFac )
      EdtFacCli( cNumFac )
   else
      msgStop( "No hay factura asociada" )
   end if

   ( dbfFacCliT )->( OrdSetFocus( nOrd ) )

Return nil

//--------------------------------------------------------------------------//

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

   /*
   Comprobamos que no esté vacío el artículo
   */

   if Empty( cCodArt )
      MsgInfo( "Debe seleccinar un artículo", "Código vacío" )
      return .f.
   end if

   /*
   Cargamos valores por defecto
   */

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

Static Function PedCliNotas()

   local cObserv  := ""
   local aData    := {}

   aAdd( aData, "Pedido " + ( D():PedidosClientes( nView ) )->cSerPed + "/" + AllTrim( Str( ( D():PedidosClientes( nView ) )->nNumPed ) ) + "/" + Alltrim( ( D():PedidosClientes( nView ) )->cSufPed ) + " de " + Rtrim( ( D():PedidosClientes( nView ) )->cNomCli ) )
   aAdd( aData, PED_CLI )
   aAdd( aData, ( D():PedidosClientes( nView ) )->cCodCli )
   aAdd( aData, ( D():PedidosClientes( nView ) )->cNomCli )
   aAdd( aData, ( D():PedidosClientes( nView ) )->cSerPed + Str( ( D():PedidosClientes( nView ) )->nNumPed ) + ( D():PedidosClientes( nView ) )->cSufPed )

   if ( D():Clientes( nView ) )->( dbSeek( ( D():PedidosClientes( nView ) )->cCodCli ) )

      if !Empty( ( D():Clientes( nView ) )->cPerCto )
         cObserv  += Rtrim( ( D():Clientes( nView ) )->cPerCto ) + Space( 1 )
      end if

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

   aAdd( aData, cObserv )

   GenerarNotas( aData )

Return ( nil )

//---------------------------------------------------------------------------//
/*Esta funcion se usa para lanzar el diálogo para imprimir o visualizar las entregas a cuenta*/

STATIC FUNCTION PrnEntregas( lPrint )

	local oDlg
   local oFmtEnt
   local cFmtEnt     := cFormatoDocumento(   nil, "NENTPED", D():Contadores( nView ) )
   local oSayEnt
   local cSayEnt
   local aPrinters   := GetPrinters()
   local cPrinter    := PrnGetName()
   local oPrinter
   local oCopPrn
   local nCopPrn     := nCopiasDocumento(    nil, "NENTPED", D():Contadores( nView ) )

   cSayEnt           := cNombreDoc( cFmtEnt )

   DEFAULT lPrint    := .t.

   DEFINE DIALOG oDlg RESOURCE "IMPSERENT"

   REDEFINE GET oFmtEnt VAR cFmtEnt ;
      ID       100 ;
      COLOR    CLR_GET ;
      VALID    ( cDocumento( oFmtEnt, oSayEnt ) ) ;
      BITMAP   "LUPA" ;
      ON HELP  ( BrwDocumento( oFmtEnt, oSayEnt, "EP" ) ) ;
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

   TBtnBmp():ReDefine( 111, "gc_printer2_check_16",,,,,{|| PrinterPreferences( oPrinter ) }, oDlg, .f., , .f.,  )

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
      ACTION   ( GenPrnEntregas( lPrint, cFmtEnt, cPrinter, if( lPrint, nCopPrn, 1 ), D():PedidosClientesPagos( nView ) ), oDlg:End( IDOK ) )

   REDEFINE BUTTON ;
      ID       550 ;
		OF 		oDlg ;
      CANCEL ;
      ACTION   ( oDlg:end() )

   oDlg:bStart := {|| if( !lPrint, oCopPrn:Disable(), oCopPrn:Enable() ) }

   ACTIVATE DIALOG oDlg CENTER

return nil

//---------------------------------------------------------------------------//
/*Esta funcion se utiliza para terminar de imprimir las entregas a cuenta*/

static function GenPrnEntregas( lPrint, cFmtEnt, cPrinter, nCopies )

   local n              := 1
   local oInf
   local oDevice
   local cCaption       := 'Imprimiendo entrega a cuenta'
   local nRecno         := ( D():PedidosClientesPagos( nView ) )->( Recno() )

   DEFAULT lPrint       := .t.
   DEFAULT nCopies      := 1

   if Empty( cFmtEnt )
      MsgStop( "Es necesario elegir un formato" )
      return nil
   end if

   if !lExisteDocumento( cFmtEnt, D():Documentos( nView ) )
      return nil
   end if

   if lVisualDocumento( cFmtEnt, D():Documentos( nView ) )

      PrintReportEntPedCli( if( lPrint, IS_PRINTER, IS_SCREEN ), nCopies, cPrinter, D():Documentos( nView ), D():PedidosClientesPagos( nView ) )

   else

      private cDbf         := D():PedidosClientes( nView )
      private cDbfEnt      := D():PedidosClientesPagos( nView )
      private cCliente     := D():Clientes( nView )
      private cDbfCli      := D():Clientes( nView )
      private cFPago       := D():FormasPago( nView )
      private cDbfPgo      := D():FormasPago( nView )
      private cDbfAge      := dbfAgent
      private cDbfDiv      := D():Divisas( nView )
      private cPorDivEnt   := cPorDiv( ( D():PedidosClientesPagos( nView ) )->cDivPgo, D():Divisas( nView ) )

      while n <= nCopies

         if !Empty( cPrinter )
            oDevice           := TPrinter():New( cCaption, .f., .t., cPrinter )
            REPORT oInf CAPTION cCaption TO DEVICE oDevice
         else
            REPORT oInf CAPTION cCaption PREVIEW
         end if

         if !Empty( oInf ) .and. oInf:lCreated
            oInf:lFinish      := .f.
            oInf:lAutoland    := .t.
            oInf:lNoCancel    := .t.
            oInf:bSkip        := {|| .t. }

            if lPrint
               oInf:bPreview  := {| oDevice | PrintPreview( oDevice ) }
            end if
         end if

         SetMargin( cFmtEnt, oInf )
         PrintColum( cFmtEnt, oInf )

         END REPORT

         if !Empty( oInf )

            private nPagina   := oInf:nPage
            private lEnd      := oInf:lFinish

            ACTIVATE REPORT oInf ;
               WHILE       ( .f. ) ;
               ON ENDPAGE  ( PrintItems( cFmtEnt, oInf ) )

            if lPrint
               oInf:oDevice:end()
            end if

         end if

         ( D():PedidosClientesPagos( nView ) )->( dbGoTo( nRecno ) )

         oInf              := nil

         n++

      end while

   end if

Return nil

//---------------------------------------------------------------------------//

STATIC FUNCTION DupSerie( oWndBrw )

   local oDlg
   local oSerIni
   local oSerFin
   local oTxtDup
   local nTxtDup     := 0
   local nRecno      := ( D():PedidosClientes( nView ) )->( Recno() )
   local nOrdAnt     := ( D():PedidosClientes( nView ) )->( OrdSetFocus( 1 ) )
   local oDesde      := TDesdeHasta():Init( ( D():PedidosClientes( nView ) )->cSerPed, ( D():PedidosClientes( nView ) )->nNumPed, ( D():PedidosClientes( nView ) )->cSufPed, GetSysDate() )
   local lCancel     := .f.
   local oBtnAceptar
   local oBtnCancel
   local oFecDoc
   local cFecDoc     := GetSysDate()

   DEFINE DIALOG oDlg ;
      RESOURCE "DUPSERDOC" ;
      TITLE    "Duplicar series de pedidos" ;
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
      TOTAL    ( D():PedidosClientes( nView ) )->( OrdKeyCount() ) ;
      OF       oDlg

      oDlg:AddFastKey( VK_F5, {|| DupStart( oDesde, oDlg, oBtnAceptar, oBtnCancel, oTxtDup, @lCancel, cFecDoc ) } )

   ACTIVATE DIALOG oDlg CENTER VALID ( lCancel )

   ( D():PedidosClientes( nView ) )->( dbGoTo( nRecNo ) )
   ( D():PedidosClientes( nView ) )->( ordSetFocus( nOrdAnt ) )

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

      nOrd              := ( D():PedidosClientes( nView ) )->( OrdSetFocus( "nNumPed" ) )

      ( D():PedidosClientes( nView ) )->( dbSeek( oDesde:cNumeroInicio(), .t. ) )

      while !lCancel .and. ( D():PedidosClientes( nView ) )->( !eof() )

         if ( D():PedidosClientes( nView ) )->cSerPed >= oDesde:cSerieInicio  .and.;
            ( D():PedidosClientes( nView ) )->cSerPed <= oDesde:cSerieFin     .and.;
            ( D():PedidosClientes( nView ) )->nNumPed >= oDesde:nNumeroInicio .and.;
            ( D():PedidosClientes( nView ) )->nNumPed <= oDesde:nNumeroFin    .and.;
            ( D():PedidosClientes( nView ) )->cSufPed >= oDesde:cSufijoInicio .and.;
            ( D():PedidosClientes( nView ) )->cSufPed <= oDesde:cSufijoFin

            ++nDuplicados

            oTxtDup:cText  := "Duplicando : " + ( D():PedidosClientes( nView ) )->cSerPed + "/" + Alltrim( Str( ( D():PedidosClientes( nView ) )->nNumPed ) ) + "/" + ( D():PedidosClientes( nView ) )->cSufPed

            DupPedido( cFecDoc )

         end if

         ( D():PedidosClientes( nView ) )->( dbSkip() )

         ++nProcesed

         oTxtDup:Set( nProcesed )

      end do

      ( D():PedidosClientes( nView ) )->( OrdSetFocus( nOrd ) )

   else

      nOrd              := ( D():PedidosClientes( nView ) )->( OrdSetFocus( "dFecPed" ) )

      ( D():PedidosClientes( nView ) )->( dbSeek( oDesde:dFechaInicio, .t. ) )

      while !lCancel .and. ( D():PedidosClientes( nView ) )->( !eof() )

         if ( D():PedidosClientes( nView ) )->dFecPed >= oDesde:dFechaInicio  .and.;
            ( D():PedidosClientes( nView ) )->dFecPed <= oDesde:dFechaFin

            ++nDuplicados

            oTxtDup:cText  := "Duplicando : " + ( D():PedidosClientes( nView ) )->cSerPed + "/" + Alltrim( Str( ( D():PedidosClientes( nView ) )->nNumPed ) ) + "/" + ( D():PedidosClientes( nView ) )->cSufPed

            DupPedido( cFecDoc )

         end if

         ( D():PedidosClientes( nView ) )->( dbSkip() )

         ++nProcesed

         oTxtDup:Set( nProcesed )

      end do

      ( D():PedidosClientes( nView ) )->( OrdSetFocus( nOrd ) )

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

STATIC FUNCTION PedRecDup( cDbf, xField1, xField2, xField3, lCab, cFecDoc )

   local nRec           := ( cDbf )->( Recno() )
   local aTabla         := {}
   local nOrdAnt

   DEFAULT lCab         := .f.

   aTabla               := DBScatter( cDbf )
   aTabla[ _CSERPED ]   := xField1
   aTabla[ _NNUMPED ]   := xField2
   aTabla[ _CSUFPED ]   := xField3

   if lCab

      aTabla[ _CTURPED     ]  := cCurSesion()
      if !Empty( cFecDoc )
         aTabla[ _DFECPED  ]  := cFecDoc
      end if
      aTabla[ _CCODCAJ     ]  := Application():CodigoCaja()
      aTabla[ _DFECENT     ]  := Ctod("")
      aTabla[ _CNUMPRE     ]  := Space( 12 )
      aTabla[ _LSNDDOC     ]  := .t.
      aTabla[ _LCLOPED     ]  := .f.
      aTabla[ _CCODUSR     ]  := Auth():Codigo()
      aTabla[ _DFECCRE     ]  := GetSysDate()
      aTabla[ _CTIMCRE     ]  := Time()
      aTabla[ _LIMPRIMIDO  ]  := .f.
      aTabla[ _DFECIMP     ]  := Ctod("")
      aTabla[ _CHORIMP     ]  := Space( 5 )
      aTabla[ _CCODDLG     ]  := Application():CodigoDelegacion()
      aTabla[ _NESTADO     ]  := 1

      nOrdAnt                 := ( cDbf )->( OrdSetFocus( "NNUMPED" ) )

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

STATIC FUNCTION DupPedido( cFecDoc )

   local nNewNumPed  := 0

   //Recogemos el nuevo numero de pedido--------------------------------------

   nNewNumPed  := nNewDoc( ( D():PedidosClientes( nView ) )->cSerPed, D():PedidosClientes( nView ), "NPEDCLI", , D():Contadores( nView ) )

   //Duplicamos las cabeceras--------------------------------------------------

   PedRecDup( D():PedidosClientes( nView ), ( D():PedidosClientes( nView ) )->cSerPed, nNewNumPed, ( D():PedidosClientes( nView ) )->cSufPed, .t., cFecDoc )

   //Duplicamos las lineas del documento---------------------------------------

   if ( D():PedidosClientesLineas( nView ) )->( dbSeek( ( D():PedidosClientes( nView ) )->cSerPed + Str( ( D():PedidosClientes( nView ) )->nNumPed ) + ( D():PedidosClientes( nView ) )->cSufPed ) )

      while D():PedidosClientesId( nView ) == D():PedidosClientesLineasId( nView ) .and. ;
            !( D():PedidosClientesLineas( nView ) )->( Eof() )

            PedRecDup( D():PedidosClientesLineas( nView ), ( D():PedidosClientes( nView ) )->cSerPed, nNewNumPed, ( D():PedidosClientes( nView ) )->cSufPed, .f. )

         ( D():PedidosClientesLineas( nView ) )->( dbSkip() )

      end while

   end if

   //Duplicamos los documentos-------------------------------------------------

   if ( dbfPedCliD )->( dbSeek( ( D():PedidosClientes( nView ) )->cSerPed + Str( ( D():PedidosClientes( nView ) )->nNumPed ) + ( D():PedidosClientes( nView ) )->cSufPed ) )

      while ( D():PedidosClientes( nView ) )->cSerPed + Str( ( D():PedidosClientes( nView ) )->nNumPed ) + ( D():PedidosClientes( nView ) )->cSufPed == ( dbfPedCliD )->cSerPed + Str( ( dbfPedCliD )->nNumPed ) + ( dbfPedCliD )->cSufPed .and. ;
            !( dbfPedCliD )->( Eof() )

            PedRecDup( dbfPedCliD, ( D():PedidosClientes( nView ) )->cSerPed, nNewNumPed, ( D():PedidosClientes( nView ) )->cSufPed, .f. )

         ( dbfPedCliD )->( dbSkip() )

      end while

   end if

RETURN ( .t. )

//---------------------------------------------------------------------------//

STATIC FUNCTION SetDialog( aGet, oSayGetRnt, oGetRnt )

   aGet[ _NESTADO ]:Refresh()

   if !lAccArticulo() .or. SQLAjustableModel():getRolNoMostrarRentabilidad( Auth():rolUuid() )

      if !Empty( oSayGetRnt )
         oSayGetRnt:Hide()
      end if

      if !Empty( oGetRnt )
         oGetRnt:Hide()
      end if

   end if

Return .t.

//---------------------------------------------------------------------------//

STATIC FUNCTION ValidaMedicion( aTmp, aGet )

   local cNewUndMed  := aGet[ _CUNIDAD ]:VarGet

   /*
   Cargamos el codigo de las unidades---------------------------------
   */

   if ( Empty( cOldUndMed ) .or. cOldUndMed != cNewUndMed )

      if oUndMedicion:oDbf:Seek( aTmp[ _CUNIDAD ] )

         if oUndMedicion:oDbf:nDimension >= 1 .and. !Empty( oUndMedicion:oDbf:cTextoDim1 )
            if !Empty( aGet[ ( D():PedidosClientesLineas( nView ) )->( fieldpos( "nMedUno" ) ) ] )
               aGet[ ( D():PedidosClientesLineas( nView ) )->( fieldpos( "nMedUno" ) ) ]:oSay:SetText( oUndMedicion:oDbf:cTextoDim1 )
               aGet[ ( D():PedidosClientesLineas( nView ) )->( fieldpos( "nMedUno" ) ) ]:cText( ( D():Articulos( nView ) )->nLngArt )
               aGet[ ( D():PedidosClientesLineas( nView ) )->( fieldpos( "nMedUno" ) ) ]:Show()
            else
               aTmp[ ( D():PedidosClientesLineas( nView ) )->( fieldpos( "nMedUno" ) ) ]  := ( D():Articulos( nView ) )->nLngArt
            end if
         else
            if !Empty( aGet[ ( D():PedidosClientesLineas( nView ) )->( fieldpos( "nMedUno" ) ) ] )
               aGet[ ( D():PedidosClientesLineas( nView ) )->( fieldpos( "nMedUno" ) ) ]:cText( 0 )
               aGet[ ( D():PedidosClientesLineas( nView ) )->( fieldpos( "nMedUno" ) ) ]:Hide()
            else
               aTmp[ ( D():PedidosClientesLineas( nView ) )->( fieldpos( "nMedUno" ) ) ]  := 0
            end if
         end if

         if oUndMedicion:oDbf:nDimension >= 2 .and. !Empty( oUndMedicion:oDbf:cTextoDim2 )
            if !Empty( aGet[ ( D():PedidosClientesLineas( nView ) )->( fieldpos( "nMedDos" ) ) ] )
               aGet[ ( D():PedidosClientesLineas( nView ) )->( fieldpos( "nMedDos" ) ) ]:oSay:SetText( oUndMedicion:oDbf:cTextoDim2 )
               aGet[ ( D():PedidosClientesLineas( nView ) )->( fieldpos( "nMedDos" ) ) ]:cText( ( D():Articulos( nView ) )->nAltArt )
               aGet[ ( D():PedidosClientesLineas( nView ) )->( fieldpos( "nMedDos" ) ) ]:Show()
            else
               aTmp[ ( D():PedidosClientesLineas( nView ) )->( fieldpos( "nMedDos" ) ) ]  := ( D():Articulos( nView ) )->nAltArt
            end if

         else
            if !Empty( aGet[ ( D():PedidosClientesLineas( nView ) )->( fieldpos( "nMedDos" ) ) ] )
               aGet[ ( D():PedidosClientesLineas( nView ) )->( fieldpos( "nMedDos" ) ) ]:cText( 0 )
               aGet[ ( D():PedidosClientesLineas( nView ) )->( fieldpos( "nMedDos" ) ) ]:Hide()
            else
                 aTmp[ ( D():PedidosClientesLineas( nView ) )->( fieldpos( "nMedDos" ) ) ]  := 0
            end if
         end if

         if oUndMedicion:oDbf:nDimension >= 3 .and. !Empty( oUndMedicion:oDbf:cTextoDim3 )
            if !Empty( aGet[ ( D():PedidosClientesLineas( nView ) )->( fieldpos( "nMedTre" ) ) ] )
               aGet[ ( D():PedidosClientesLineas( nView ) )->( fieldpos( "nMedTre" ) ) ]:oSay:SetText( oUndMedicion:oDbf:cTextoDim3 )
               aGet[ ( D():PedidosClientesLineas( nView ) )->( fieldpos( "nMedTre" ) ) ]:cText( ( D():Articulos( nView ) ) ->nAncArt )
               aGet[ ( D():PedidosClientesLineas( nView ) )->( fieldpos( "nMedTre" ) ) ]:Show()
            else
               aTmp[ ( D():PedidosClientesLineas( nView ) )->( fieldpos( "nMedTre" ) ) ]  := ( D():Articulos( nView ) )->nAncArt
            end if
         else
            if !Empty( aGet[ ( D():PedidosClientesLineas( nView ) )->( fieldpos( "nMedTre" ) ) ] )
               aGet[ ( D():PedidosClientesLineas( nView ) )->( fieldpos( "nMedTre" ) ) ]:cText( 0 )
               aGet[ ( D():PedidosClientesLineas( nView ) )->( fieldpos( "nMedTre" ) ) ]:Hide()
            else
               aTmp[ ( D():PedidosClientesLineas( nView ) )->( fieldpos( "nMedTre" ) ) ]  := 0
            end if
         end if

      else

         if !Empty( aGet[ ( D():PedidosClientesLineas( nView ) )->( fieldpos( "nMedUno" ) ) ] )
            aGet[ ( D():PedidosClientesLineas( nView ) )->( fieldpos( "nMedUno" ) ) ]:Hide()
            aGet[ ( D():PedidosClientesLineas( nView ) )->( fieldpos( "nMedUno" ) ) ]:cText( 0 )
         end if

         if !Empty( aGet[ ( D():PedidosClientesLineas( nView ) )->( fieldpos( "nMedDos" ) ) ] )
            aGet[ ( D():PedidosClientesLineas( nView ) )->( fieldpos( "nMedDos" ) ) ]:Hide()
            aGet[ ( D():PedidosClientesLineas( nView ) )->( fieldpos( "nMedDos" ) ) ]:cText( 0 )
         end if

         if !Empty( aGet[ ( D():PedidosClientesLineas( nView ) )->( fieldpos( "nMedTre" ) ) ] )
            aGet[ ( D():PedidosClientesLineas( nView ) )->( fieldpos( "nMedTre" ) ) ]:Hide()
            aGet[ ( D():PedidosClientesLineas( nView ) )->( fieldpos( "nMedTre" ) ) ]:cText( 0 )
         end if

      end if

      cOldUndMed := cNewUndMed

   end if

RETURN .t.

//-----------------------------------------------------------------------------

Static Function ChangeTarifa( aTmp, aGet, aTmpPed )

   local nPrePro  := 0

   nPrePro     := nPrePro( aTmp[ _CREF ], aTmp[ _CCODPR1 ], aTmp[ _CVALPR1 ], aTmp[ _CCODPR2 ], aTmp[ _CVALPR2 ], aTmp[ _NTARLIN ], aTmpPed[ _LIVAINC ], dbfArtDiv, aTmpPed[ _CCODTAR ] )

   if nPrePro == 0
      nPrePro  := nRetPreArt( aTmp[ _NTARLIN ], aTmpPed[ _CDIVPED ], aTmpPed[ _LIVAINC ], D():Articulos( nView ), D():Divisas( nView ), dbfKit, D():TiposIva( nView ), , , oNewImp )
   end if

   if nPrePro != 0
      aGet[ _NPREDIV ]:cText( nPrePro )
   end if

Return .t.

//---------------------------------------------------------------------------//

STATIC function Calculaunidades( nCantidad, nStockDis, nStockMinMax )

   local nUnidades

   do case
      case nStockDis < 0
         nUnidades   := ( 0 - nStockDis ) + nCantidad + nStockMinMax
      case nStockDis == 0
         nUnidades   := nCantidad + nStockMinMax
      case nStockDis > 0
         nUnidades   := ( nCantidad - nStockDis ) + nStockMinMax
   end case

   if nUnidades < 0
      nUnidades      := 0
   end if

return nUnidades

//---------------------------------------------------------------------------//

STATIC FUNCTION SelSend( oBrw )

   if dbDialogLock( D():PedidosClientes( nView ) )
      ( D():PedidosClientes( nView ) )->lPdtCrg := !( D():PedidosClientes( nView ) )->lPdtCrg
      ( D():PedidosClientes( nView ) )->( dbUnLock() )
   end if

   oBrw:Refresh()
   oBrw:SetFocus()

RETURN NIL

//-------------------------------------------------------------------------//

Static Function loadComisionAgente( aTmp, aGet, aTmpPed )

   local nComisionAgenteTarifa   

   nComisionAgenteTarifa         := nComisionAgenteTarifa( aTmpPed[ _CCODAGE ], aTmp[ _NTARLIN ], nView ) 
   if nComisionAgenteTarifa == 0
      nComisionAgenteTarifa      := aTmpPed[ _NPCTCOMAGE ]
   end if 

   if !empty( aGet[ _NCOMAGE ] )
      aGet[ _NCOMAGE ]:cText( nComisionAgenteTarifa )
   else 
      aTmp[ _NCOMAGE ]        := nComisionAgenteTarifa
   end if

return .t.

//-----------------------------------------------------------------------------

#include "FastRepH.ch"

Static Function DataReport( oFr )

   /*
   Zona de datos------------------------------------------------------------
   */

   oFr:ClearDataSets()

   oFr:SetWorkArea(     "Pedidos", ( D():PedidosClientes( nView ) )->( Select() ), .f., { FR_RB_CURRENT, FR_RB_CURRENT, 0 } )
   oFr:SetFieldAliases( "Pedidos", cItemsToReport( aItmPedCli() ) )

   oFr:SetWorkArea(     "Lineas de pedidos", ( D():PedidosClientesLineas( nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Lineas de pedidos", cItemsToReport( aColPedCli() ) )

   oFr:SetWorkArea(     "Incidencias de pedidos", ( dbfPedCliI )->( Select() ) )
   oFr:SetFieldAliases( "Incidencias de pedidos", cItemsToReport( aIncPedCli() ) )

   oFr:SetWorkArea(     "Documentos de pedidos", ( dbfPedCliD )->( Select() ) )
   oFr:SetFieldAliases( "Documentos de pedidos", cItemsToReport( aPedCliDoc() ) )

   oFr:SetWorkArea(     "Situaciones de pedidos", ( D():PedidosClientesSituaciones( nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Situaciones de pedidos", cItemsToReport( aPedCliEst() ) )

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

   oFr:SetWorkArea(     "Formas de pago", ( D():FormasPago( nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Formas de pago", cItemsToReport( aItmFPago() ) )

   oFr:SetWorkArea(     "Artículos", ( D():Articulos( nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Artículos", cItemsToReport( aItmArt() ) )

   oFr:SetWorkArea(     "Ofertas", ( dbfOferta )->( Select() ) )
   oFr:SetFieldAliases( "Ofertas", cItemsToReport( aItmOfe() ) )

   if !empty(oUndMedicion)
      oFr:SetWorkArea(     "Unidades de medición",  oUndMedicion:Select() )
      oFr:SetFieldAliases( "Unidades de medición",  cObjectsToReport( oUndMedicion:oDbf ) )
   end if 

   if !empty(oNewImp)
      oFr:SetWorkArea(     "Impuestos especiales",  oNewImp:Select() )
      oFr:SetFieldAliases( "Impuestos especiales",  cObjectsToReport( oNewImp:oDbf ) )
   end if 

   oFr:SetMasterDetail( "Pedidos", "Lineas de pedidos",                 {|| ( D():PedidosClientes( nView ) )->cSerPed + Str( ( D():PedidosClientes( nView ) )->nNumPed ) + ( D():PedidosClientes( nView ) )->cSufPed } )
   oFr:SetMasterDetail( "Pedidos", "Incidencias de pedidos",            {|| ( D():PedidosClientes( nView ) )->cSerPed + Str( ( D():PedidosClientes( nView ) )->nNumPed ) + ( D():PedidosClientes( nView ) )->cSufPed } )
   oFr:SetMasterDetail( "Pedidos", "Documentos de pedidos",             {|| ( D():PedidosClientes( nView ) )->cSerPed + Str( ( D():PedidosClientes( nView ) )->nNumPed ) + ( D():PedidosClientes( nView ) )->cSufPed } )
   oFr:SetMasterDetail( "Pedidos", "Empresa",                           {|| cCodigoEmpresaEnUso() } )
   oFr:SetMasterDetail( "Pedidos", "Clientes",                          {|| ( D():PedidosClientes( nView ) )->cCodCli } )
   oFr:SetMasterDetail( "Pedidos", "Obras",                             {|| ( D():PedidosClientes( nView ) )->cCodCli + ( D():PedidosClientes( nView ) )->cCodObr } )
   oFr:SetMasterDetail( "Pedidos", "Almacenes",                         {|| ( D():PedidosClientes( nView ) )->cCodAlm } )
   oFr:SetMasterDetail( "Pedidos", "Rutas",                             {|| ( D():PedidosClientes( nView ) )->cCodRut } )
   oFr:SetMasterDetail( "Pedidos", "Agentes",                           {|| ( D():PedidosClientes( nView ) )->cCodAge } )
   oFr:SetMasterDetail( "Pedidos", "Formas de pago",                    {|| ( D():PedidosClientes( nView ) )->cCodPgo } )
   oFr:SetMasterDetail( "Pedidos", "Usuarios",                        	{|| ( D():PedidosClientes( nView ) )->cCodUsr } )

   oFr:SetMasterDetail( "Lineas de pedidos", "Artículos",               {|| SynchronizeDetails() } )
   oFr:SetMasterDetail( "Lineas de pedidos", "Ofertas",                 {|| ( D():PedidosClientesLineas( nView ) )->cRef } )
   oFr:SetMasterDetail( "Lineas de pedidos", "Unidades de medición",    {|| ( D():PedidosClientesLineas( nView ) )->cUnidad } )
   oFr:SetMasterDetail( "Lineas de pedidos", "Impuestos especiales",    {|| ( D():PedidosClientesLineas( nView ) )->cCodImp } )

   oFr:SetResyncPair( "Pedidos", "Lineas de pedidos" )
   oFr:SetResyncPair( "Pedidos", "Incidencias de pedidos" )
   oFr:SetResyncPair( "Pedidos", "Documentos de pedidos" )
   oFr:SetResyncPair( "Pedidos", "Empresa" )
   oFr:SetResyncPair( "Pedidos", "Clientes" )
   oFr:SetResyncPair( "Pedidos", "Obras" )
   oFr:SetResyncPair( "Pedidos", "Almacenes" )
   oFr:SetResyncPair( "Pedidos", "Rutas" )
   oFr:SetResyncPair( "Pedidos", "Agentes" )
   oFr:SetResyncPair( "Pedidos", "Formas de pago" )
   oFr:SetResyncPair( "Pedidos", "Usuarios" )

   oFr:SetResyncPair( "Lineas de pedidos", "Artículos" )
   oFr:SetResyncPair( "Lineas de pedidos", "Ofertas" )
   oFr:SetResyncPair( "Lineas de pedidos", "Unidades de medición" )
   oFr:SetResyncPair( "Lineas de pedidos", "Impuestos especiales" )

Return nil

//---------------------------------------------------------------------------//

Static Function SynchronizeDetails()

Return ( ( D():PedidosClientesLineas( nView ) )->cRef )

//---------------------------------------------------------------------------//

Static Function VariableReport( oFr )

   oFr:DeleteCategory(  "Pedidos" )
   oFr:DeleteCategory(  "Lineas de Pedidos" )

   /*
   Creación de variables----------------------------------------------------
   */

   oFr:AddVariable(     "Pedidos",             "Total bruto",                         "GetHbVar('nTotBrt')" )
   oFr:AddVariable(     "Pedidos",             "Total pedido",                        "GetHbVar('nTotPed')" )
   oFr:AddVariable(     "Pedidos",             "Total descuento",                     "GetHbVar('nTotDto')" )
   oFr:AddVariable(     "Pedidos",             "Total descuento pronto pago",         "GetHbVar('nTotDpp')" )
   oFr:AddVariable(     "Pedidos",             "Total descuentos",                    "GetHbVar('nTotalDto')" )
   oFr:AddVariable(     "Pedidos",             "Total neto",                          "GetHbVar('nTotNet')" )
   oFr:AddVariable(     "Pedidos",             "Total primer descuento definible",    "GetHbVar('nTotUno')" )
   oFr:AddVariable(     "Pedidos",             "Total segundo descuento definible",   "GetHbVar('nTotDos')" )
   oFr:AddVariable(     "Pedidos",             "Total " + cImp(),                     "GetHbVar('nTotIva')" )
   oFr:AddVariable(     "Pedidos",             "Total RE",                            "GetHbVar('nTotReq')" )
   oFr:AddVariable(     "Pedidos",             "Total página",                        "GetHbVar('nTotPag')" )
   oFr:AddVariable(     "Pedidos",             "Total peso",                          "GetHbVar('nTotPes')" )
   oFr:AddVariable(     "Pedidos",             "Total costo",                         "GetHbVar('nTotCos')" )
   oFr:AddVariable(     "Pedidos",             "Total artículos",                     "GetHbVar('nTotArt')" )
   oFr:AddVariable(     "Pedidos",             "Total cajas",                         "GetHbVar('nTotCaj')" )
   oFr:AddVariable(     "Pedidos",             "Cuenta por defecto del cliente",      "GetHbVar('cCtaCli')" )

   oFr:AddVariable(     "Pedidos",             "Bruto primer tipo de " + cImp(),            "GetHbArrayVar('aIvaUno',1)" )
   oFr:AddVariable(     "Pedidos",             "Bruto segundo tipo de " + cImp(),           "GetHbArrayVar('aIvaDos',1)" )
   oFr:AddVariable(     "Pedidos",             "Bruto tercer tipo de " + cImp(),            "GetHbArrayVar('aIvaTre',1)" )
   oFr:AddVariable(     "Pedidos",             "Base primer tipo de " + cImp(),             "GetHbArrayVar('aIvaUno',2)" )
   oFr:AddVariable(     "Pedidos",             "Base segundo tipo de " + cImp(),            "GetHbArrayVar('aIvaDos',2)" )
   oFr:AddVariable(     "Pedidos",             "Base tercer tipo de " + cImp(),             "GetHbArrayVar('aIvaTre',2)" )
   oFr:AddVariable(     "Pedidos",             "Porcentaje primer tipo " + cImp(),          "GetHbArrayVar('aIvaUno',3)" )
   oFr:AddVariable(     "Pedidos",             "Porcentaje segundo tipo " + cImp(),         "GetHbArrayVar('aIvaDos',3)" )
   oFr:AddVariable(     "Pedidos",             "Porcentaje tercer tipo " + cImp(),          "GetHbArrayVar('aIvaTre',3)" )
   oFr:AddVariable(     "Pedidos",             "Porcentaje primer tipo RE",           "GetHbArrayVar('aIvaUno',4)" )
   oFr:AddVariable(     "Pedidos",             "Porcentaje segundo tipo RE",          "GetHbArrayVar('aIvaDos',4)" )
   oFr:AddVariable(     "Pedidos",             "Porcentaje tercer tipo RE",           "GetHbArrayVar('aIvaTre',4)" )
   oFr:AddVariable(     "Pedidos",             "Importe primer tipo " + cImp(),             "GetHbArrayVar('aIvaUno',8)" )
   oFr:AddVariable(     "Pedidos",             "Importe segundo tipo " + cImp(),            "GetHbArrayVar('aIvaDos',8)" )
   oFr:AddVariable(     "Pedidos",             "Importe tercer tipo " + cImp(),             "GetHbArrayVar('aIvaTre',8)" )
   oFr:AddVariable(     "Pedidos",             "Importe primer RE",                   "GetHbArrayVar('aIvaUno',9)" )
   oFr:AddVariable(     "Pedidos",             "Importe segundo RE",                  "GetHbArrayVar('aIvaDos',9)" )
   oFr:AddVariable(     "Pedidos",             "Importe tercer RE",                   "GetHbArrayVar('aIvaTre',9)" )

   oFr:AddVariable(     "Pedidos",             "Total unidades primer tipo de impuestos especiales",            "GetHbArrayVar('aIvmUno',1 )" )
   oFr:AddVariable(     "Pedidos",             "Total unidades segundo tipo de impuestos especiales",           "GetHbArrayVar('aIvmDos',1 )" )
   oFr:AddVariable(     "Pedidos",             "Total unidades tercer tipo de impuestos especiales",            "GetHbArrayVar('aIvmTre',1 )" )
   oFr:AddVariable(     "Pedidos",             "Importe del primer tipo de impuestos especiales",               "GetHbArrayVar('aIvmUno',2 )" )
   oFr:AddVariable(     "Pedidos",             "Importe del segundo tipo de impuestos especiales",              "GetHbArrayVar('aIvmDos',2 )" )
   oFr:AddVariable(     "Pedidos",             "Importe del tercer tipo de impuestos especiales",               "GetHbArrayVar('aIvmTre',2 )" ) 
   oFr:AddVariable(     "Pedidos",             "Total importe primer tipo de impuestos especiales",             "GetHbArrayVar('aIvmUno',3 )" )
   oFr:AddVariable(     "Pedidos",             "Total importe segundo tipo de impuestos especiales",            "GetHbArrayVar('aIvmDos',3 )" )
   oFr:AddVariable(     "Pedidos",             "Total importe tercer tipo de impuestos especiales",             "GetHbArrayVar('aIvmTre',3 )" )

   oFr:AddVariable(     "Pedidos",             "Fecha del primer vencimiento",              "GetHbArrayVar('aDatVto',1)" )
   oFr:AddVariable(     "Pedidos",             "Fecha del segundo vencimiento",             "GetHbArrayVar('aDatVto',2)" )
   oFr:AddVariable(     "Pedidos",             "Fecha del tercer vencimiento",              "GetHbArrayVar('aDatVto',3)" )
   oFr:AddVariable(     "Pedidos",             "Fecha del cuarto vencimiento",              "GetHbArrayVar('aDatVto',4)" )
   oFr:AddVariable(     "Pedidos",             "Fecha del quinto vencimiento",              "GetHbArrayVar('aDatVto',5)" )
   oFr:AddVariable(     "Pedidos",             "Fecha del sexto vencimiento",               "GetHbArrayVar('aDatVto',6)" )
   oFr:AddVariable(     "Pedidos",             "Fecha del septimo vencimiento",             "GetHbArrayVar('aDatVto',7)" )
   oFr:AddVariable(     "Pedidos",             "Fecha del octavovencimiento",               "GetHbArrayVar('aDatVto',8)" )
   oFr:AddVariable(     "Pedidos",             "Fecha del noveno vencimiento",              "GetHbArrayVar('aDatVto',9)" )
   oFr:AddVariable(     "Pedidos",             "Fecha del decimo vencimiento",              "GetHbArrayVar('aDatVto',10)" )
   oFr:AddVariable(     "Pedidos",             "Fecha del undecimo vencimiento",            "GetHbArrayVar('aDatVto',11)" )
   oFr:AddVariable(     "Pedidos",             "Fecha del duodecimo vencimiento",           "GetHbArrayVar('aDatVto',12)" )
   
   oFr:AddVariable(     "Pedidos",             "Importe del primer vencimiento",            "GetHbArrayVar('aImpVto',1)" )
   oFr:AddVariable(     "Pedidos",             "Importe del segundo vencimiento",           "GetHbArrayVar('aImpVto',2)" )
   oFr:AddVariable(     "Pedidos",             "Importe del tercero vencimiento",           "GetHbArrayVar('aImpVto',3)" )
   oFr:AddVariable(     "Pedidos",             "Importe del cuarto vencimiento",            "GetHbArrayVar('aImpVto',4)" )
   oFr:AddVariable(     "Pedidos",             "Importe del quinto vencimiento",            "GetHbArrayVar('aImpVto',5)" )
   oFr:AddVariable(     "Pedidos",             "Importe del sexto vencimiento",             "GetHbArrayVar('aImpVto',6)" )
   oFr:AddVariable(     "Pedidos",             "Importe del septimo vencimiento",           "GetHbArrayVar('aImpVto',7)" )
   oFr:AddVariable(     "Pedidos",             "Importe del octavo vencimiento",            "GetHbArrayVar('aImpVto',8)" )
   oFr:AddVariable(     "Pedidos",             "Importe del noveno vencimiento",            "GetHbArrayVar('aImpVto',9)" )
   oFr:AddVariable(     "Pedidos",             "Importe del decimo vencimiento",            "GetHbArrayVar('aImpVto',10)" )
   oFr:AddVariable(     "Pedidos",             "Importe del undecimo vencimiento",          "GetHbArrayVar('aImpVto',11)" )
   oFr:AddVariable(     "Pedidos",             "Importe del duodecimo vencimiento",         "GetHbArrayVar('aImpVto',12)" )

   oFr:AddVariable(     "Lineas de Pedidos",   "Detalle del artículo",                       "CallHbFunc('cDesPedCli')"  )
   oFr:AddVariable(     "Lineas de Pedidos",   "Detalle del artículo otro lenguaje",         "CallHbFunc('cDesPedCliLeng')" )
   oFr:AddVariable(     "Lineas de Pedidos",   "Total unidades artículo",                    "CallHbFunc('nTotNPedCli')" )
   oFr:AddVariable(     "Lineas de Pedidos",   "Precio unitario del artículo",               "CallHbFunc('nTotUPedCli')" )
   oFr:AddVariable(     "Lineas de Pedidos",   "Total línea de pedido",                      "CallHbFunc('nTotLPedCli')" )
   oFr:AddVariable(     "Lineas de Pedidos",   "Total peso por línea",                       "CallHbFunc('nPesLPedCli')" )
   oFr:AddVariable(     "Lineas de Pedidos",   "Total final línea del pedido",               "CallHbFunc('nTotFPedCli')" )

   oFr:AddVariable(     "Lineas de Pedidos",   "Nombre primera propiedad línea del pedido",  "CallHbFunc('nombrePrimeraPropiedadPedidosClientesLineas')" )
   oFr:AddVariable(     "Lineas de Pedidos",   "Nombre segunda propiedad línea del pedido",  "CallHbFunc('nombreSegundaPropiedadPedidosClientesLineas')" )

   oFr:AddVariable(     "Transportistas",      "Nombre transportista",                       "CallHbFunc('getNombreTransportistaPedCli')" )
   
Return nil

//---------------------------------------------------------------------------//

Function getNombreTransportistaPedCli()

Return TransportistasRepository():getNombreWhereUuid( ( D():PedidosClientes( nView ) )->Uuid_Trn )

//---------------------------------------------------------------------------//

Static Function DataReportEntPedCli( oFr, cPedCliP )

   /*
   Zona de datos------------------------------------------------------------
   */

   oFr:ClearDataSets()

   if !Empty( cPedCliP )
   oFr:SetWorkArea(     "Entrega", ( cPedCliP )->( Select() ), .f., { FR_RB_CURRENT, FR_RB_CURRENT, 0 } )
   else
   oFr:SetWorkArea(     "Entrega", ( D():PedidosClientesPagos( nView ) )->( Select() ), .f., { FR_RB_CURRENT, FR_RB_CURRENT, 0 } )
   end if
   oFr:SetFieldAliases( "Entrega", cItemsToReport( aPedCliPgo() ) )

   oFr:SetWorkArea(     "Pedido de cliente", ( D():PedidosClientes( nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Pedido de cliente", cItemsToReport( aItmPedCli() ) )

   oFr:SetWorkArea(     "Empresa", ( dbfEmp )->( Select() ) )
   oFr:SetFieldAliases( "Empresa", cItemsToReport( aItmEmp() ) )

   oFr:SetWorkArea(     "Clientes", ( D():Clientes( nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Clientes", cItemsToReport( aItmCli() ) )

   oFr:SetWorkArea(     "Formas de pago", ( D():FormasPago( nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Formas de pago", cItemsToReport( aItmFPago() ) )

   if !Empty( cPedCliP )
   oFr:SetMasterDetail( "Entrega", "Pedido de cliente",        {|| ( cPedCliP )->cSerPed + Str( ( cPedCliP )->nNumPed ) + ( cPedCliP )->cSufPed } )
   oFr:SetMasterDetail( "Entrega", "Clientes",                 {|| ( cPedCliP )->cCodCli } )
   oFr:SetMasterDetail( "Entrega", "Formas de pago",           {|| ( cPedCliP )->cCodPgo } )
   else
   oFr:SetMasterDetail( "Entrega", "Pedido de cliente",        {|| ( D():PedidosClientesPagos( nView ) )->cSerPed + Str( ( D():PedidosClientesPagos( nView ) )->nNumPed ) + ( D():PedidosClientesPagos( nView ) )->cSufPed } )
   oFr:SetMasterDetail( "Entrega", "Clientes",                 {|| ( D():PedidosClientesPagos( nView ) )->cCodCli } )
   oFr:SetMasterDetail( "Entrega", "Formas de pago",           {|| ( D():PedidosClientesPagos( nView ) )->cCodPgo } )
   end if

   oFr:SetMasterDetail( "Entrega", "Empresa",                  {|| cCodigoEmpresaEnUso() } )

   oFr:SetResyncPair(   "Entrega", "Pedido de cliente" )
   oFr:SetResyncPair(   "Entrega", "Empresa" )
   oFr:SetResyncPair(   "Entrega", "Clientes" )
   oFr:SetResyncPair(   "Entrega", "Formas de pago" )

Return nil

//---------------------------------------------------------------------------//

Static Function VariableReportEntPedCli( oFr )

   /*
   Creación de variables----------------------------------------------------
   */

   oFr:AddVariable( "Pedido de cliente",     "Total bruto",                         "GetHbVar('nTotBrt')" )
   oFr:AddVariable( "Pedido de cliente",     "Total pedido",                        "GetHbVar('nTotPed')" )
   oFr:AddVariable( "Pedido de cliente",     "Total descuento",                     "GetHbVar('nTotDto')" )
   oFr:AddVariable( "Pedido de cliente",     "Total descuento pronto pago",         "GetHbVar('nTotDpp')" )
   oFr:AddVariable( "Pedido de cliente",     "Total bruto",                         "GetHbVar('nTotBrt')" )
   oFr:AddVariable( "Pedido de cliente",     "Total descuento",                     "GetHbVar('nTotDto')" )
   oFr:AddVariable( "Pedido de cliente",     "Total descuento pronto pago",         "GetHbVar('nTotDpp')" )
   oFr:AddVariable( "Pedido de cliente",     "Total neto",                          "GetHbVar('nTotNet')" )
   oFr:AddVariable( "Pedido de cliente",     "Total primer descuento definible",    "GetHbVar('nTotUno')" )
   oFr:AddVariable( "Pedido de cliente",     "Total segundo descuento definible",   "GetHbVar('nTotDos')" )
   oFr:AddVariable( "Pedido de cliente",     "Total " + cImp(),                           "GetHbVar('nTotIva')" )
   oFr:AddVariable( "Pedido de cliente",     "Total RE",                            "GetHbVar('nTotReq')" )
   oFr:AddVariable( "Pedido de cliente",     "Total página",                        "GetHbVar('nTotPag')" )
   oFr:AddVariable( "Pedido de cliente",     "Total peso",                          "GetHbVar('nTotPes')" )
   oFr:AddVariable( "Pedido de cliente",     "Total costo",                         "GetHbVar('nTotCos')" )
   oFr:AddVariable( "Pedido de cliente",     "Total artículos",                     "GetHbVar('nTotArt')" )
   oFr:AddVariable( "Pedido de cliente",     "Total cajas",                         "GetHbVar('nTotCaj')" )
   oFr:AddVariable( "Pedido de cliente",     "Bruto primer tipo de " + cImp(),            "GetHbArrayVar('aIvaUno',1)" )
   oFr:AddVariable( "Pedido de cliente",     "Bruto segundo tipo de " + cImp(),           "GetHbArrayVar('aIvaDos',1)" )
   oFr:AddVariable( "Pedido de cliente",     "Bruto tercer tipo de " + cImp(),            "GetHbArrayVar('aIvaTre',1)" )
   oFr:AddVariable( "Pedido de cliente",     "Base primer tipo de " + cImp(),             "GetHbArrayVar('aIvaUno',2)" )
   oFr:AddVariable( "Pedido de cliente",     "Base segundo tipo de " + cImp(),            "GetHbArrayVar('aIvaDos',2)" )
   oFr:AddVariable( "Pedido de cliente",     "Base tercer tipo de " + cImp(),             "GetHbArrayVar('aIvaTre',2)" )
   oFr:AddVariable( "Pedido de cliente",     "Porcentaje primer tipo " + cImp(),          "GetHbArrayVar('aIvaUno',3)" )
   oFr:AddVariable( "Pedido de cliente",     "Porcentaje segundo tipo " + cImp(),         "GetHbArrayVar('aIvaDos',3)" )
   oFr:AddVariable( "Pedido de cliente",     "Porcentaje tercer tipo " + cImp(),          "GetHbArrayVar('aIvaTre',3)" )
   oFr:AddVariable( "Pedido de cliente",     "Porcentaje primer tipo RE",           "GetHbArrayVar('aIvaUno',4)" )
   oFr:AddVariable( "Pedido de cliente",     "Porcentaje segundo tipo RE",          "GetHbArrayVar('aIvaDos',4)" )
   oFr:AddVariable( "Pedido de cliente",     "Porcentaje tercer tipo RE",           "GetHbArrayVar('aIvaTre',4)" )
   oFr:AddVariable( "Pedido de cliente",     "Importe primer tipo " + cImp(),             "GetHbArrayVar('aIvaUno',8)" )
   oFr:AddVariable( "Pedido de cliente",     "Importe segundo tipo " + cImp(),            "GetHbArrayVar('aIvaDos',8)" )
   oFr:AddVariable( "Pedido de cliente",     "Importe tercer tipo " + cImp(),             "GetHbArrayVar('aIvaTre',8)" )
   oFr:AddVariable( "Pedido de cliente",     "Importe primer RE",                   "GetHbArrayVar('aIvaUno',9)" )
   oFr:AddVariable( "Pedido de cliente",     "Importe segundo RE",                  "GetHbArrayVar('aIvaDos',9)" )
   oFr:AddVariable( "Pedido de cliente",     "Importe tercer RE",                   "GetHbArrayVar('aIvaTre',9)" )
   oFr:AddVariable( "Pedido de cliente",     "Fecha del primer vencimiento",        "GetHbArrayVar('aDatVto',1)" )
   oFr:AddVariable( "Pedido de cliente",     "Fecha del segundo vencimiento",       "GetHbArrayVar('aDatVto',2)" )
   oFr:AddVariable( "Pedido de cliente",     "Fecha del tercer vencimiento",        "GetHbArrayVar('aDatVto',3)" )
   oFr:AddVariable( "Pedido de cliente",     "Fecha del cuarto vencimiento",        "GetHbArrayVar('aDatVto',4)" )
   oFr:AddVariable( "Pedido de cliente",     "Fecha del quinto vencimiento",        "GetHbArrayVar('aDatVto',5)" )
   oFr:AddVariable( "Pedido de cliente",     "Importe del primer vencimiento",      "GetHbArrayVar('aImpVto',1)" )
   oFr:AddVariable( "Pedido de cliente",     "Importe del segundo vencimiento",     "GetHbArrayVar('aImpVto',2)" )
   oFr:AddVariable( "Pedido de cliente",     "Importe del tercero vencimiento",     "GetHbArrayVar('aImpVto',3)" )
   oFr:AddVariable( "Pedido de cliente",     "Importe del cuarto vencimiento",      "GetHbArrayVar('aImpVto',4)" )
   oFr:AddVariable( "Pedido de cliente",     "Importe del quinto vencimiento",      "GetHbArrayVar('aImpVto',5)" )

Return nil

//---------------------------------------------------------------------------//

STATIC FUNCTION CreateFiles( cPath )

   if !lExistTable( cPath + "PedCliT.Dbf", cLocalDriver() )
      dbCreate( cPath + "PedCliT.Dbf", aSqlStruct( aItmPedCli() ), cLocalDriver() )
   end if

   if !lExistTable( cPath + "PedCliL.Dbf", cLocalDriver() )
      dbCreate( cPath + "PedCliL.Dbf", aSqlStruct( aColPedCli() ), cLocalDriver() )
   end if

   if !lExistTable( cPath + "PedCliR.DBF", cLocalDriver() )
      dbCreate( cPath + "PedCliR.Dbf", aSqlStruct( aPedCliRes() ), cLocalDriver() )
   end if

   if !lExistTable( cPath + "PedCliI.Dbf", cLocalDriver() )
      dbCreate( cPath + "PedCliI.Dbf", aSqlStruct( aIncPedCli() ), cLocalDriver() )
   end if

   if !lExistTable( cPath + "PedCliD.Dbf", cLocalDriver() )
      dbCreate( cPath + "PedCliD.Dbf", aSqlStruct( aPedCliDoc() ), cLocalDriver() )
   end if

   if !lExistTable( cPath + "PedCliP.Dbf", cLocalDriver() )
      dbCreate( cPath + "PedCliP.Dbf", aSqlStruct( aPedCliPgo() ), cLocalDriver() )
   end if

   if !lExistTable( cPath + "PedCliE.Dbf", cLocalDriver() )
      dbCreate( cPath + "PedCliE.Dbf", aSqlStruct( aPedCliEst() ), cLocalDriver() )
   end if

RETURN NIL

//-------------------------------------------------------------------------//

Static Function aPedCliRes()

   local aPedCliRes  := {}

   aAdd( aPedCliRes, { "cSerPed", "C",    1,  0, "",                                "",                   "", "( cDbfCol )", nil } )
   aAdd( aPedCliRes, { "nNumPed", "N",    9,  0, "",                                "'999999999'",        "", "( cDbfCol )", nil } )
   aAdd( aPedCliRes, { "cSufPed", "C",    2,  0, "",                                "",                   "", "( cDbfCol )", nil } )
   aAdd( aPedCliRes, { "cRef",    "C",   18,  0, "Referencia del artículo",         "",                   "", "( cDbfCol )", nil } )
   aAdd( aPedCliRes, { "cCodPr1", "C",   20,  0, "Código de la primera propiedad",  "",                   "", "( cDbfCol )", nil } )
   aAdd( aPedCliRes, { "cCodPr2", "C",   20,  0, "Código de la segunda propiedad",  "",                   "", "( cDbfCol )", nil } )
   aAdd( aPedCliRes, { "cValPr1", "C",   20,  0, "Valor de la primera propiedad",   "",                   "", "( cDbfCol )", nil } )
   aAdd( aPedCliRes, { "cValPr2", "C",   20,  0, "Valor de la segunda propiedad",   "",                   "", "( cDbfCol )", nil } )
   aAdd( aPedCliRes, { "dFecRes", "D",    8,  0, "Fecha de la reserva",             "",                   "", "( cDbfCol )", nil } )
   aAdd( aPedCliRes, { "nCajRes", "N",   16,  6, "Cajas reservadas",                "MasUnd()",           "", "( cDbfCol )", nil } )
   aAdd( aPedCliRes, { "nUndRes", "N",   16,  6, "Unidades reservadas",             "MasUnd()",           "", "( cDbfCol )", nil } )
   aAdd( aPedCliRes, { "nLote",   "N",    9,  0, "",                                "'999999999'",        "", "( cDbfCol )", nil } )
   aAdd( aPedCliRes, { "cLote",   "C",   14,  0, "Número del lote",                 "",                   "", "( cDbfCol )", nil } )

return ( aPedCliRes )

//---------------------------------------------------------------------------//

STATIC FUNCTION CloseFiles()

   disableAcceso()

   lPedidosWeb( D():PedidosClientes( nView ) )

   destroyFastFilter( D():PedidosClientes( nView ), .t., .t. )

   if !Empty( oFont )
      oFont:end()
   end if

   if( !Empty( dbfPedCliI ), ( dbfPedCliI )->( dbCloseArea() ), )
   if( !Empty( dbfPedCliD ), ( dbfPedCliD )->( dbCloseArea() ), )
   if( !Empty( dbfPedCliP ), ( dbfPedCliP )->( dbCloseArea() ), )
   if( !Empty( dbfPreCliT ), ( dbfPreCliT )->( dbCloseArea() ), )
   if( !Empty( dbfPreCliL ), ( dbfPreCliL )->( dbCloseArea() ), )
   if( !Empty( dbfPreCliI ), ( dbfPreCliI )->( dbCloseArea() ), )
   if( !Empty( dbfPreCliD ), ( dbfPreCliD )->( dbCloseArea() ), )
   if( !Empty( dbfAlbCliT ), ( dbfAlbCliT )->( dbCloseArea() ), )
   if( !Empty( dbfAlbCliL ), ( dbfAlbCliL )->( dbCloseArea() ), )
   if( !Empty( dbfAlbCliP ), ( dbfAlbCliP )->( dbCloseArea() ), )
   if( !Empty( dbfAlbPrvT ), ( dbfAlbPrvT )->( dbCloseArea() ), )
   if( !Empty( dbfAlbPrvL ), ( dbfAlbPrvL )->( dbCloseArea() ), )
   if( !Empty( dbfTarPreL ), ( dbfTarPreL )->( dbCloseArea() ), )
   if( !Empty( dbfTarPreS ), ( dbfTarPreS )->( dbCloseArea() ), )
   if( !Empty( dbfPromoT  ), ( dbfPromoT  )->( dbCloseArea() ), )
   if( !Empty( dbfPromoL  ), ( dbfPromoL  )->( dbCloseArea() ), )
   if( !Empty( dbfPromoC  ), ( dbfPromoC  )->( dbCloseArea() ), )
   if( !Empty( dbfAgent   ), ( dbfAgent   )->( dbCloseArea() ), )
   if( !Empty( dbfCodebar ), ( dbfCodebar )->( dbCloseArea() ), )
   if( !Empty( dbfObrasT  ), ( dbfObrasT  )->( dbCloseArea() ), )
   if( !Empty( dbfOferta  ), ( dbfOferta  )->( dbCloseArea() ), )
   if( !Empty( dbfPro     ), ( dbfPro     )->( dbCloseArea() ), )
   if( !Empty( dbfKit     ), ( dbfKit     )->( dbCloseArea() ), )
   if( !Empty( dbfRuta    ), ( dbfRuta    )->( dbCloseArea() ), )
   if( !Empty( dbfAlm     ), ( dbfAlm     )->( dbCloseArea() ), )
   if( !Empty( dbfArtDiv  ), ( dbfArtDiv  )->( dbCloseArea() ), )
   if( !Empty( dbfCajT    ), ( dbfCajT    )->( dbCloseArea() ), )
   if( !Empty( dbfArtPrv  ), ( dbfArtPrv  )->( dbCloseArea() ), )
   if( !Empty( dbfDelega  ), ( dbfDelega  )->( dbCloseArea() ), )
   if( !Empty( dbfAgeCom  ), ( dbfAgeCom  )->( dbCloseArea() ), )
   if( !Empty( dbfEmp     ), ( dbfEmp     )->( dbCloseArea() ), )
   if( !Empty( dbfFacPrvL ), ( dbfFacPrvL )->( dbCloseArea() ), )
   if( !Empty( dbfRctPrvL ), ( dbfRctPrvL )->( dbCloseArea() ), )
   if( !Empty( dbfAntCliT ), ( dbfAntCliT )->( dbCloseArea() ), )
   if( !Empty( dbfFacCliT ), ( dbfFacCliT )->( dbCloseArea() ), )
   if( !Empty( dbfFacCliL ), ( dbfFacCliL )->( dbCloseArea() ), )
   if( !Empty( dbfFacRecL ), ( dbfFacRecL )->( dbCloseArea() ), )
   if( !Empty( dbfFacCliP ), ( dbfFacCliP )->( dbCloseArea() ), )
   if( !Empty( dbfTikCliT ), ( dbfTikCliT )->( dbCloseArea() ), )
   if( !Empty( dbfTikCliL ), ( dbfTikCliL )->( dbCloseArea() ), )
   if( !Empty( dbfProLin  ), ( dbfProLin  )->( dbCloseArea() ), )
   if( !Empty( dbfProMat  ), ( dbfProMat  )->( dbCloseArea() ), )
   if( !Empty( dbfCliBnc  ), ( dbfCliBnc  )->( dbCloseArea() ), )


   if( !Empty( oStock     ), oStock:end(),  )
   if( !Empty( oNewImp    ), oNewImp:end(), )
   if( !Empty( oTipArt    ), oTipArt:end(), )
   if( !Empty( oFabricante), oFabricante:end(), )
   if( !Empty( oGrpFam    ), oGrpFam:end(), )
   if( !Empty( oCentroCoste), oCentroCoste:end(), )

   if !Empty( oUndMedicion )
      oUndMedicion:end()
   end if

   if !Empty( oDetCamposExtra )
      oDetCamposExtra:CloseFiles()
   end if

   if !empty( oMailing )
      oMailing:end()
   end if 

   D():DeleteView( nView )

   CodigosPostales():GetInstance():CloseFiles()

   dbfPedCliI     := nil
   dbfPedCliD     := nil
   dbfPedCliP     := nil
   dbfPreCliT     := nil
   dbfPreCliL     := nil
   dbfPreCliI     := nil
   dbfPreCliD     := nil
   dbfAlbCliT     := nil
   dbfAlbCliL     := nil
   dbfAlbCliP     := nil
   dbfAlbPrvT     := nil
   dbfAlbPrvL     := nil
   dbfTarPreL     := nil
   dbfTarPreS     := nil
   dbfPromoT      := nil
   dbfPromoL      := nil
   dbfPromoC      := nil
   dbfAgent       := nil
   dbfArtPrv      := nil
   dbfCodebar     := nil
   dbfObrasT      := nil
   dbfOferta      := nil
   dbfPro         := nil
   dbfKit         := nil
   dbfRuta        := nil
   dbfAlm         := nil
   dbfArtDiv      := nil
   dbfCajT        := nil
   dbfAgeCom      := nil
   dbfEmp         := nil
   dbfFacPrvL     := nil
   dbfRctPrvL     := nil
   dbfAntCliT     := nil
   dbfFacCliT     := nil
   dbfFacCliL     := nil
   dbfFacRecL     := nil
   dbfFacCliP     := nil
   dbfTikCliT     := nil
   dbfTikCliL     := nil
   dbfProLin      := nil
   dbfProMat      := nil
   dbfCliBnc      := nil
   nView		      := nil

   oStock         := nil
   oBandera       := nil
   oNewImp        := nil
   oTipArt        := nil
   oFabricante    := nil
   oGrpFam        := nil

   oCentroCoste   := nil

   lOpenFiles     := .f.

   oWndBrw        := nil

   EnableAcceso()

RETURN .T.

//----------------------------------------------------------------------------//

Static Function KillTrans()

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

   if !Empty( dbfTmpPgo ) .and. ( dbfTmpPgo )->( Used() )
      ( dbfTmpPgo )->( dbCloseArea() )
   end if

   if !Empty( dbfTmpRes ) .and. ( dbfTmpRes )->( Used() )
      ( dbfTmpRes )->( dbCloseArea() )
   end if

   if !Empty( dbfTmpEst ) .and. ( dbfTmpEst )->( Used() )
      ( dbfTmpEst )->( dbCloseArea() )
   end if

   /*
   Eliminamos los temporales
   */

   dbfErase( cTmpLin )
   dbfErase( cTmpInc )
   dbfErase( cTmpDoc )
   dbfErase( cTmpPgo )
   dbfErase( cTmpRes )
   dbfErase( cTmpEst )

Return .t.

//------------------------------------------------------------------------//

STATIC FUNCTION EndTrans( aTmp, aGet, oBrwLin, oBrwInc, nMode, oDlg, lActualizaWeb )

   local oError
   local oBlock
   local aTabla
   local cSerPed
   local nNumPed
   local cSufPed

   DEFAULT lActualizaWeb   	:= .f.

   if Empty( aTmp[ _CSERPED ] )
      aTmp[ _CSERPED ]  := "A"
   end if

   cSerPed              := aTmp[ _CSERPED ]
   nNumPed              := aTmp[ _NNUMPED ]
   cSufPed              := aTmp[ _CSUFPED ]

   aTmp[ _LSNDDOC ]     := .t.

   /*
   Comprobamos la fecha del documento------------------------------------------
   */
   if !lValidaOperacion( aTmp[ _DFECPED ] )
      Return .f.
   end if

   if !lValidaSerie( aTmp[ _CSERPED ] )
      Return .f.
   end if

   /*
   Estos campos no pueden estar vacios
   */

   if !( isAviableClient( nView ) )
      return .f.
   end if

   if Empty( aTmp[ _CCODCLI ] )
      msgStop( "Código de cliente no puede estar vacío." )
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

   if Empty( aTmp[ _CDIVPED ] )
      MsgStop( "No puede almacenar documento sin código de divisa." )
      aGet[ _CDIVPED ]:SetFocus()
      return .f.
   end if

   if Empty( aTmp[ _CCODAGE ] ) .and. lRecogerAgentes()
      msgStop( "Agente no puede estar vacío." )
      aGet[ _CCODAGE ]:SetFocus()
      return .f.
   end if

   // solo para la jaca--------------------------------------------------------

   if uFieldempresa( "lServicio" )

      if empty( aTmp[ _DFECENTR ] )
         msgStop( "Fecha inicio servicio no puede estar vacía" )
         return .f.
      end if 

      if empty( aTmp[ _DFECSAL ] )
         msgStop( "Fecha fin servicio no puede estar vacía" )
         return .f.
      end if 

   end if

   if ( dbfTmpLin )->( eof() )
      MsgStop( "No puede almacenar un documento sin líneas." )
      return .f.
   end if

   //Ejecutamos script del evento before append--------------------------------

   if isAppendOrDuplicateMode( nMode )
      if isfalse( runEventScript( "PedidosClientes\beforeAppend", aTmp, nView, dbfTmpLin ) )
         return .f.
      end if 
   end if

   if isEditMode( nMode )
      if isfalse( runEventScript( "PedidosClientes\beforeEdit", aTmp, nView, dbfTmpLin ) )
         return .f.
      end if 
   end if

   oDlg:Disable()

   oMsgText( "Archivando" )

   oBlock      := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   BeginTransaction()

   /*
   Quitamos los filtros--------------------------------------------------------
   */

   ( dbfTmpLin )->( dbClearFilter() )

	/*
	Primero hacer el RollBack---------------------------------------------------
	*/

   aTmp[ _DFECCRE ]     := Date()
   aTmp[ _CTIMCRE ]     := Time()
   aTmp[ _NTARIFA ]		:= oGetTarifa:getTarifa()
   aTmp[ _LALQUILER ]   := .f.

   do case
   case isAppendOrDuplicateMode( nMode )

      nNumPed           := nNewDoc( cSerPed, D():PedidosClientes( nView ), "NPEDCLI", , D():Contadores( nView ) )
      aTmp[ _NNUMPED ]  := nNumPed
      cSufPed           := retSufEmp()
      aTmp[ _CSUFPED ]  := cSufPed

   case isEditMode( nMode )

      if nNumPed != 0

         while ( D():PedidosClientesLineas( nView ) )->( dbSeek( cSerPed + str( nNumPed ) + cSufPed ) )
            if dbLock( D():PedidosClientesLineas( nView ) )
               ( D():PedidosClientesLineas( nView ) )->( dbDelete() )
               ( D():PedidosClientesLineas( nView ) )->( dbUnLock() )
            end if
         end while

         while ( dbfPedCliI )->( dbSeek( cSerPed + str( nNumPed ) + cSufPed ) )
            if dbLock( dbfPedCliI )
               ( dbfPedCliI )->( dbDelete() )
               ( dbfPedCliI )->( dbUnLock() )
            end if
         end while

         while ( dbfPedCliD )->( dbSeek( cSerPed + str( nNumPed ) + cSufPed ) )
               if dbLock( dbfPedCliD )
                  ( dbfPedCliD )->( dbDelete() )
                  ( dbfPedCliD )->( dbUnLock() )
               end if
         end while

         while ( D():PedidosClientesPagos( nView ) )->( dbSeek( cSerPed + str( nNumPed ) + cSufPed ) )
            if dbLock( D():PedidosClientesPagos( nView ) )
               ( D():PedidosClientesPagos( nView ) )->( dbDelete() )
               ( D():PedidosClientesPagos( nView ) )->( dbUnLock() )
            end if
         end while

         while ( D():PedidosClientesSituaciones( nView ) )->( dbSeek( cSerPed + str( nNumPed ) + cSufPed ) ) 
            if dbLock( D():PedidosClientesSituaciones( nView ) )
               ( D():PedidosClientesSituaciones( nView ) )->( dbDelete() )
               ( D():PedidosClientesSituaciones( nView ) )->( dbUnLock() )
            end if
         end while

      end if

   end case

   if !( "PDA" $ appParamsMain() )
      oMsgProgress()
      oMsgProgress():SetRange( 0, ( dbfTmpLin )->( LastRec() ) )
   end if

	/*
	Ahora escribimos en el fichero definitivo----------------------------------
   Controlando que no metan lineas con unidades a 0 por el tema---------------
   de la importacion de las atipicas------------------------------------------
	*/

   ( dbfTmpLin )->( dbGoTop() )

   while ( dbfTmpLin )->( !eof() )

      if nMode == APPD_MODE .and. dbLock( dbfTmpLin )

         ( dbfTmpLin )->nRegIva     := aTmp[ _NREGIVA ]

         if empty( ( dbfTmpLin )->dFecEnt )
            ( dbfTmpLin )->dFecEnt  := aTmp[ _DFECSAL ]
         end if 

         if empty( ( dbfTmpLin )->dFecSal )
            ( dbfTmpLin )->dFecSal  := aTmp[ _DFECSAL ]
         end if 

         ( dbfTmpLin )->lAnulado    := aTmp[ _LCANCEL ]
         ( dbfTmpLin )->dAnulado    := aTmp[ _DCANCEL ]
         ( dbfTmpLin )->mAnulado    := aTmp[ _CCANCEL ]
         ( dbfTmpLin )->nProduc     := 2
         ( dbfTmpLin )->( dbUnLock() )

      end if

      if !( ( dbfTmpLin )->nUniCaja == 0 .and. ( dbfTmpLin )->lFromAtp )
      	dbPass( dbfTmpLin, D():PedidosClientesLineas( nView ), .t., cSerPed, nNumPed, cSufPed )
      end if

      ( dbfTmpLin )->( dbSkip() )

      oMsgProgress():Deltapos(1)

   end while

   /*
	Ahora escribimos en el fichero definitivo
	*/

   ( dbfTmpInc )->( dbGoTop() )
   while ( dbfTmpInc )->( !eof() )
      dbPass( dbfTmpInc, dbfPedCliI, .t., cSerPed, nNumPed, cSufPed )
      ( dbfTmpInc )->( dbSkip() )
   end while

   /*
	Ahora escribimos en el fichero definitivo
	*/

   ( dbfTmpDoc )->( dbGoTop() )
   while ( dbfTmpDoc )->( !eof() )
      dbPass( dbfTmpDoc, dbfPedCliD, .t., cSerPed, nNumPed, cSufPed )
      ( dbfTmpDoc )->( dbSkip() )
   end while

   /*
   Ahora escribimos en el fichero definitivo de entregas a cuenta--------------
	*/

   ( dbfTmpPgo )->( dbgotop() )
   while ( dbfTmpPgo )->( !eof() )
      dbPass( dbfTmpPgo, D():PedidosClientesPagos( nView ), .t., cSerPed, nNumPed, cSufPed )
      ( dbfTmpPgo )->( dbSkip() )
   end while

   /*
   Fichero de las reservas
   */

   ( dbfTmpRes )->( dbgotop() )
   while ( dbfTmpRes )->( !eof() )
      dbPass( dbfTmpRes, D():PedidosClientesReservas( nView ), .t., cSerPed, nNumPed, cSufPed )
      ( dbfTmpRes )->( dbSkip() )
   end while

   /*
   Escribimos en el fichero definitivo (Situaciones)
   */

   ( dbfTmpEst )->( dbgotop() )
   while ( dbfTmpEst )->( !eof() )
     	dbPass( dbfTmpEst, D():PedidosClientesSituaciones( nView ), .t., cSerPed, nNumPed, cSufPed ) 
     	( dbfTmpEst )->( dbSkip() )
   end while

   /*
   Si el pedido está cancelado ponemos el estado a 3---------------------------
   */

   if aTmp[ _LCANCEL ]
      aTmp[ _NESTADO ]  := 3
   end if

   /*
   Guardamos los totales-------------------------------------------------------
   */

   aTmp[ _NTOTNET ]     := nTotNet
   aTmp[ _NTOTIVA ]     := nTotIva
   aTmp[ _NTOTREQ ]     := nTotReq
   aTmp[ _NTOTPED ]     := nTotPed

   oDetCamposExtra:saveExtraField( aTmp[ _CSERPED ] + Str( aTmp[ _NNUMPED ] ) + aTmp[ _CSUFPED ], "" )

   /*
   Escritura en el fichero definitivo------------------------------------------
   */

   WinGather( aTmp, aGet, D():PedidosClientes( nView ), , nMode )

   /*
   Actualizamos el estado del pedido-------------------------------------------
   */

   if !Empty( oStock )
      oStock:SetRecibidoPedCli( cSerPed + Str( nNumPed ) + cSufPed )
   end if

   /*
   Actualizamos el estado del campo generado-----------------------------------
   */

   if !Empty( oStock )
      oStock:SetGeneradoPedCli( cSerPed + Str( nNumPed ) + cSufPed )
   end if

	/*
	Actualizamos los datos de la web para tiempo real------------------------
	*/

		
	if uFieldempresa( "lRealWeb" ) .and. ( !empty( ( D():PedidosClientes( nView ) )->cCodWeb ) )
		with object ( TComercio():New() )
			:syncSituacionesPedidoPrestashop( ( D():PedidosClientes( nView ) )->cCodWeb, ( D():PedidosClientes( nView ) )->cSerPed, ( D():PedidosClientes( nView ) )->nNumPed, ( D():PedidosClientes( nView ) )->cSufPed )
		end with
	end if

   /*
   Escribe los datos pendientes------------------------------------------------
   */

   dbCommitAll()

   CommitTransaction()

   RECOVER USING oError

      RollBackTransaction()
      msgStop( "Imposible almacenar documento" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE
   ErrorBlock( oBlock )

   oMsgText()

   endProgress()

   /*
   Encendemos el dialogo-------------------------------------------------------
   */

   oDlg:Enable()

   oDlg:end( IDOK )

Return .t.

//------------------------------------------------------------------------//

Static Function RecalculaTotal( aTmp )

   local nTotPedCli  := nTotPedCli( nil, D():PedidosClientes( nView ), dbfTmpLin, D():TiposIva( nView ), D():Divisas( nView ), D():FormasPago( nView ), aTmp, nil, .f. )
   local nEntPedCli  := nPagPedCli( nil, dbfTmpPgo, D():Divisas( nView ) )

   aTotIva              := aSort( aTotIva,,, {|x,y| x[1] > y[1] } )

   if oBrwIva != nil
      oBrwIva:Refresh()
   end if

   /*
   Base de la Factura
   */

   if oGetNet != nil
      oGetNet:SetText( Trans( nTotNet, cPorDiv ) )
   end if

   if oGetIvm != nil
      oGetIvm:SetText( Trans( nTotIvm, cPorDiv ) )
   end if

   if oGetRnt != nil
      oGetRnt:SetText( AllTrim( Trans( nTotRnt, cPorDiv ) + Space( 1 ) +  AllTrim( cSimDiv( aTmp[ _CDIVPED ], D():Divisas( nView ) ) ) + " : " + AllTrim( Trans( nPctRnt, "999.99" ) ) + "%" ) )
   end if

   if oGetIva != nil
      oGetIva:SetText( Trans( nTotIva, cPorDiv ) )
   end if

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
      oGetTotal:SetText( Trans( nTotPed, cPorDiv ) )
   end if

   if oTotPedLin != nil
      oTotPedLin:SetText( Trans( nTotPed, cPorDiv ) )
   end if

   if oGetAge != nil
      oGetAge:SetText( Trans( nTotAge, cPorDiv ) )
   end if

   if oGetPed != nil
      oGetPed:SetText( Trans( nTotPedCli, cPorDiv ) )
   end if

   if oGetEnt != nil
      oGetEnt:SetText( Trans( nEntPedCli, cPorDiv ) )
   end if

   if oGetPdt != nil
      oGetPdt:SetText( Trans( nTotPedCli - nEntPedCli, cPorDiv ) )
   end if

   if oGetPes != nil
      oGetPes:cText( nTotPes )
   end if

   if oGetDif != nil
      oGetDif:cText( nTotDif )
   end if

Return .t.

//--------------------------------------------------------------------------//

/*
Funcion Auxiliar para borrar las Lineas de Detalle en un pedido
*/

STATIC FUNCTION DelDeta( oBrwLin )

   local lKitArt  := ( dbfTmpLin )->lKitArt
   local nNumLin  := ( dbfTmpLin )->nNumLin

   WinDelRec( oBrwLin, dbfTmpLin, , {|| if( lKitArt, DbDelKit( oBrwLin, dbfTmpLin, nNumLin ), ) } )

RETURN ( .t. )

//--------------------------------------------------------------------------//

/*
Funcion Auxiliar para A¤adir lineas de detalle a un pedido
*/

STATIC FUNCTION AppDeta( oBrwLin, bEdtDet, aTmp, lTot, cCodArt )

   DEFAULT lTot := .f.

   WinAppRec( oBrwLin, bEdtDet, dbfTmpLin, lTot, cCodArt, aTmp )

RETURN RecalculaTotal( aTmp )

//--------------------------------------------------------------------------//

/*
Funcion Auxiliar para la Edici¢n de Lineas de Detalle en un pedido
*/
STATIC FUNCTION EdtDeta( oBrwLin, bEdtDet, aTmp )

   WinEdtRec( oBrwLin, bEdtDet, dbfTmpLin, nil, nil, aTmp )

RETURN RecalculaTotal( aTmp )

//--------------------------------------------------------------------------//

STATIC FUNCTION LoaCli( aGet, aTmp, nMode, oRieCli, oTlfCli )

	local lValid 		:= .T.
   local cNewCodCli  := aGet[ _CCODCLI ]:varGet()
   local lChgCodCli

   if Empty( cNewCodCli )
      Return .t.
   elseif At( ".", cNewCodCli ) != 0
      cNewCodCli     := PntReplace( aGet[ _CCODCLI ], "0", RetNumCodCliEmp() )
   else
      cNewCodCli     := Rjust( cNewCodCli, "0", RetNumCodCliEmp() )
   end if

   lChgCodCli  := ( Empty( cOldCodCli ) .or. cOldCodCli != cNewCodCli )

   if ( D():Clientes( nView ) )->( dbSeek( cNewCodCli ) )

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

      if empty( aGet[ _CNOMCLI ]:varGet() ) .or. lChgCodCli
         aGet[ _CNOMCLI ]:cText( ( D():Clientes( nView ) )->Titulo )
      end if

      if empty( aGet[ _CDIRCLI ]:varGet() ) .or. lChgCodCli
         aGet[ _CDIRCLI ]:cText( ( D():Clientes( nView ) )->Domicilio )
      end if

      if empty( aGet[ _CPOBCLI ]:varGet() ) .or. lChgCodCli
         aGet[ _CPOBCLI ]:cText( ( D():Clientes( nView ) )->Poblacion )
      end if

      if !empty( aGet[ _CPRVCLI ] )
         if empty( aGet[ _CPRVCLI ]:varGet() ) .or. lChgCodCli
            aGet[ _CPRVCLI ]:cText( ( D():Clientes( nView ) )->Provincia )
         end if
      end if

      if empty( aGet[ _CPOSCLI ]:varGet() ) .or. lChgCodCli
         aGet[ _CPOSCLI ]:cText( ( D():Clientes( nView ) )->CodPostal )
      end if

      if empty( aGet[ _CTLFCLI ]:varGet() ) .or. lChgCodCli
         aGet[ _CTLFCLI ]:cText( ( D():Clientes( nView ) )->Telefono )
      end if

      if !empty( aGet[ _CDNICLI ] )
         if empty( aGet[ _CDNICLI ]:varGet() ) .or. lChgCodCli
            aGet[ _CDNICLI ]:cText( ( D():Clientes( nView ) )->Nif )
         end if
      else
         if Empty( aTmp[ _CDNICLI ] ) .or. lChgCodCli
            aTmp[ _CDNICLI ]  := ( D():Clientes( nView ) )->Nif
         end if
      end if

      if Empty( aTmp[ _CCODGRP ] ) .or. lChgCodCli
         aTmp[ _CCODGRP ]     := ( D():Clientes( nView ) )->cCodGrp
      end if

      /*
      Cargamos la obra por defecto-------------------------------------
      */

      if ( lChgCodCli ) 

         // Obra del cliente-------------------------------------------

         if !empty( aGet[ _CCODOBR ] )

            if dbSeekInOrd( cNewCodCli, "lDefObr", dbfObrasT )
               aGet[ _CCODOBR ]:cText( ( dbfObrasT )->cCodObr )
            else
               aGet[ _CCODOBR ]:cText( Space( 10 ) )
            end if

            aGet[ _CCODOBR ]:lValid()

         end if

         // Reisgo del cliente-------------------------------------------

         if oRieCli != nil
            oStock:SetRiesgo( cNewCodCli, oRieCli, ( D():Clientes( nView ) )->Riesgo )
         end if

         aTmp[ _LMODCLI ]     := ( D():Clientes( nView ) )->lModDat
         aTmp[ _LOPERPV ]     := ( D():Clientes( nView ) )->lPntVer

      end if

      if nMode == APPD_MODE

         aTmp[_NREGIVA ]      := ( D():Clientes( nView ) )->nRegIva

         /*
         Si estamos a¤adiendo cargamos todos los datos del cliente
         */

         if Empty( aTmp[ _CSERPED ] )

            if !Empty( ( D():Clientes( nView ) )->Serie )
               aGet[ _CSERPED ]:cText( ( D():Clientes( nView ) )->Serie )
            end if

         else

            if !Empty( ( D():Clientes( nView ) )->Serie )                .and.;
               aTmp[ _CSERPED ] != ( D():Clientes( nView ) )->Serie      .and.;
               ApoloMsgNoYes( "La serie del cliente seleccionado es distinta a la anterior.", "¿Desea cambiar la serie?" )
               aGet[ _CSERPED ]:cText( ( D():Clientes( nView ) )->Serie )
            end if

         end if

         if aGet[ _CCODALM ] != nil

            if ( Empty( aGet[ _CCODALM ]:varGet() ) .or. lChgCodCli ) .and. !Empty( ( D():Clientes( nView ) )->cCodAlm )
               aGet[ _CCODALM ]:cText( ( D():Clientes( nView ) )->cCodAlm )
               aGet[ _CCODALM ]:lValid()
            end if

         end if

         if aGet[ _CCODTAR ] != nil

            if ( Empty( aGet[ _CCODTAR ]:varGet() ) .or. lChgCodCli ) .and. !Empty( ( D():Clientes( nView ) )->cCodTar )
               aGet[ _CCODTAR ]:cText( ( D():Clientes( nView ) )->CCODTAR )
               aGet[ _CCODTAR ]:lValid()
            end if

         end if

         if ( Empty( aGet[ _CCODPGO ]:varGet() ) .or. lChgCodCli ) .and. !Empty( ( D():Clientes( nView ) )->CodPago )
            aGet[ _CCODPGO ]:cText( ( D():Clientes( nView ) )->CodPago )
            aGet[ _CCODPGO ]:lValid()
         end if

         /*
         Si la forma de pago es un movimiento bancario le asignamos el banco y cuenta por defecto
         */

         if ( lChgCodCli .and. lBancoDefecto( ( D():Clientes( nView ) )->Cod, dbfCliBnc ) )

            if !Empty( aGet[ _CBANCO ] )
               aGet[ _CBANCO ]:cText( ( dbfCliBnc )->cCodBnc )
               aGet[ _CBANCO ]:lValid()
            end if

            if !Empty( aGet[ _CPAISIBAN ] )
               aGet[ _CPAISIBAN ]:cText( ( dbfCliBnc )->cPaisIBAN )
               aGet[ _CPAISIBAN ]:lValid()
            end if

            if !Empty( aGet[ _CCTRLIBAN ] )
               aGet[ _CCTRLIBAN ]:cText( ( dbfCliBnc )->cCtrlIBAN )
               aGet[ _CCTRLIBAN ]:lValid()
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

         if !Empty( aGet[ _CCODAGE ] )
            if ( Empty( aGet[ _CCODAGE ]:varGet() ) .or. lChgCodCli ) .and. !Empty( ( D():Clientes( nView ) )->cAgente )
               aGet[ _CCODAGE ]:cText( ( D():Clientes( nView ) )->cAgente )
               aGet[ _CCODAGE ]:lValid()
            end if
         end if

         if ( Empty( aGet[ _CCODRUT ]:varGet() ) .or. lChgCodCli ) .and. !Empty( ( D():Clientes( nView ) )->cCodRut )
            aGet[ _CCODRUT ]:cText( ( D():Clientes( nView ))->CCODRUT )
            aGet[ _CCODRUT ]:lValid()
         end if

         if !empty( oGetTarifa )
	         if ( Empty( oGetTarifa:varGet() ) .or. lChgCodCli ) .and. !Empty( ( D():Clientes( nView ) )->nTarifa )
	            oGetTarifa:setTarifa( ( D():Clientes( nView ) )->nTarifa )
	         end if
	     else
         	 aTmp[ _NTARIFA ] 	:= ( D():Clientes( nView ) )->nTarifa
         end if

         if ( Empty( aTmp[ _NDTOTARIFA ] ) .or. lChgCodCli )
             aTmp[ _NDTOTARIFA ]    := ( D():Clientes( nView ) )->nDtoArt
         end if

         if !Empty( aGet[ _CCODTRN ] ) .and. ( Empty( aGet[ _CCODTRN ]:varGet() ) .or. lChgCodCli ) .and. !Empty( ( D():Clientes( nView ) )->cCodTrn )
            aGet[ _CCODTRN ]:cText( ( D():Clientes( nView ) )->cCodTrn )
            aGet[ _CCODTRN ]:lValid()
         end if

      end if

      if lChgCodCli

         aGet[ _LRECARGO ]:Click( ( D():Clientes( nView ) )->lReq ):Refresh()

         aGet[ _LOPERPV  ]:Click( ( D():Clientes( nView ) )->lPntVer ):Refresh()

         /*
         Descuentos desde la ficha de cliente----------------------------------
         */

         aGet[ _CDTOESP ]:cText( ( D():Clientes( nView ) )->cDtoEsp )

         aGet[ _NDTOESP ]:cText( ( D():Clientes( nView ) )->nDtoEsp )

         aGet[ _CDPP    ]:cText( ( D():Clientes( nView ) )->cDpp )

         aGet[ _NDPP    ]:cText( ( D():Clientes( nView ) )->nDpp )

         aGet[ _CDTOUNO ]:cText( ( D():Clientes( nView ) )->cDtoUno )

         aGet[ _CDTODOS ]:cText( ( D():Clientes( nView ) )->cDtoDos )

         aGet[ _NDTOUNO ]:cText( ( D():Clientes( nView ) )->nDtoCnt )

         aGet[ _NDTODOS ]:cText( ( D():Clientes( nView ) )->nDtoRap )

         aTmp[ _NDTOATP ] := ( D():Clientes( nView ) )->nDtoAtp

         aTmp[ _NSBRATP ] := ( D():Clientes( nView ) )->nSbrAtp

      end if

      cOldCodCli  := ( D():Clientes( nView ) )->Cod

      if ( D():Clientes( nView ) )->lMosCom .and. !Empty( ( D():Clientes( nView ) )->mComent ) .and. lChgCodCli
         MsgStop( Trim( ( D():Clientes( nView ) )->mComent ) )
      end if

      ShowIncidenciaCliente( ( D():Clientes( nView ) )->Cod, nView )

      lValid      := .t.

	ELSE

		msgStop( "Cliente no encontrado" )
		lValid := .F.

	END IF

RETURN lValid

//----------------------------------------------------------------------------//

STATIC FUNCTION BeginTrans( aTmp, nMode )

   local oError
   local oBlock
   local lErrors  := .f.
   local cDbfLin  := "PCliL"
   local cDbfInc  := "PCliI"
   local cDbfDoc  := "PCliD"
   local cDbfRes  := "PCliR"
   local cDbfPgo  := "PCliP"
   local cDbfEst  := "PCliE"
   local cPedido  := ""
   local nOrd
   
   if nMode != APPD_MODE
      cPedido     := aTmp[ _CSERPED ] + Str( aTmp[ _NNUMPED ] ) + aTmp[ _CSUFPED ]
   end if

   oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   cTmpLin        := cGetNewFileName( cPatTmp() + cDbfLin )
   cTmpRes        := cGetNewFileName( cPatTmp() + cDbfRes )
   cTmpInc        := cGetNewFileName( cPatTmp() + cDbfInc )
   cTmpDoc        := cGetNewFileName( cPatTmp() + cDbfDoc )
   cTmpPgo        := cGetNewFileName( cPatTmp() + cDbfPgo )
   cTmpEst        := cGetNewFileName( cPatTmp() + cDbfEst )


	/*
	Primero Crear la base de datos local
	*/

   dbCreate( cTmpLin, aSqlStruct( aColPedCli() ), cLocalDriver() )
   dbUseArea( .t., cLocalDriver(), cTmpLin, cCheckArea( cDbfLin, @dbfTmpLin ), .f. )

   if !NetErr()

      ( dbfTmpLin )->( OrdCondSet( "!Deleted()", {||!Deleted() } ) )
      ( dbfTmpLin )->( OrdCreate( cTmpLin, "nNumLin", "Str( nNumLin, 4 )", {|| Str( Field->nNumLin ) } ) )

      ( dbfTmpLin )->( OrdCondSet( "!Deleted()", {||!Deleted() } ) )
      ( dbfTmpLin )->( OrdCreate( cTmpLin, "cRef", "cRef", {|| Field->cRef } ) )

      ( dbfTmpLin )->( OrdCondSet( "!Deleted()", {||!Deleted() } ) )
      ( dbfTmpLin )->( OrdCreate( cTmpLin, "cDetalle", "Left( cDetalle, 100 )", {|| Left( Field->cDetalle, 100 ) } ) )

      ( dbfTmpLin )->( OrdCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( dbfTmpLin )->( OrdCreate( cTmpLin, "nUniCaja", "nUniCaja", {|| Field->nUniCaja } ) )

      ( dbfTmpLin )->( OrdCondSet( "!Deleted()", {||!Deleted() } ) )
      ( dbfTmpLin )->( OrdCreate( cTmpLin, "nPosPrint", "Str( nPosPrint, 4 )", {|| Str( Field->nPosPrint ) } ) )

      ( dbfTmpLin )->( OrdCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( dbfTmpLin )->( OrdCreate( cTmpLin, "dFecUltCom", "dFecUltCom", {|| Field->dFecUltCom } ) )

      ( dbfTmpLin )->( OrdCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( dbfTmpLin )->( OrdCreate( cTmpLin, "nUniUltCom", "nUniUltCom", {|| Field->nUniUltCom } ) )

   else

      lErrors     := .t.

   end if

   /*
   D():BuildTmp(  "PedCliL",;
                  "PedidosClientesLineas",;
                  {  {  "tagName" => "Recno" ,;
                        "tagExpresion" => "str( recno() )",;
                        "tagBlock" => {|| str( recno() ) } },;
                     {  "tagName" => "cRef" ,;
                        "tagExpresion" => "cRef",;
                        "tagBlock" => {|| Field->cRef } },;
                     {  "tagName" => "nNumLin" ,;
                        "tagExpresion" => "str( nNumLin, 4 )",;
                        "tagBlock" => {|| str( field->nNumLin ) } },;
                     {  "tagName" => "nNumLin" ,;
                        "tagExpresion" => "str( nPosPrint, 4 )",;
                        "tagBlock" => {|| str( field->nPosPrint ) } },;
                  },;
                  ::nView ) 
   */

   dbCreate( cTmpInc, aSqlStruct( aIncPedCli() ), cLocalDriver() )
   dbUseArea( .t., cLocalDriver(), cTmpInc, cCheckArea( cDbfInc, @dbfTmpInc ), .f. )
   if !NetErr()

      ( dbfTmpInc )->( ordCondSet( "!Deleted()", {||!Deleted() } ) )
      ( dbfTmpInc )->( ordCreate( cTmpInc, "Recno", "Recno()", {|| Recno() } ) )

   else

      lErrors     := .t.

   end if

   dbCreate( cTmpDoc, aSqlStruct( aPedCliDoc() ), cLocalDriver() )
   dbUseArea( .t., cLocalDriver(), cTmpDoc, cCheckArea( cDbfDoc, @dbfTmpDoc ), .f. )
   if !NetErr()

      ( dbfTmpDoc )->( ordCondSet( "!Deleted()", {||!Deleted() } ) )
      ( dbfTmpDoc )->( ordCreate( cTmpDoc, "Recno", "Recno()", {|| Recno() } ) )

   else

      lErrors     := .t.

   end if

   dbCreate( cTmpPgo, aSqlStruct( aPedCliPgo() ), cLocalDriver() )
   dbUseArea( .t., cLocalDriver(), cTmpPgo, cCheckArea( cDbfDoc, @dbfTmpPgo ), .f. )
   if !NetErr()

      ( dbfTmpDoc )->( ordCondSet( "!Deleted()", {||!Deleted() } ) )
      ( dbfTmpDoc )->( ordCreate( cTmpDoc, "Recno", "Recno()", {|| Recno() } ) )

   else

      lErrors     := .t.

   end if

   dbCreate( cTmpRes, aSqlStruct( aPedCliRes() ), cLocalDriver() )
   dbUseArea( .t., cLocalDriver(), cTmpRes, cCheckArea( cDbfRes, @dbfTmpRes ), .f. )
   if !NetErr()

      ( dbfTmpRes )->( ordCreate( cTmpRes, "cRef", "cRef + cCodPr1 + cCodPR2 + cValPr1 + cValPr2", {|| Field->CREF + Field->CCODPR1 + Field->CCODPR2 + Field->CVALPR1 + Field->CVALPR2 } ) )
      ( dbfTmpRes )->( ordListAdd( cTmpRes ) )

   else

      lErrors     := .t.

   end if

  	dbCreate( cTmpEst, aSqlStruct( aPedCliEst() ), cLocalDriver() )
   	dbUseArea( .t., cLocalDriver(), cTmpEst, cCheckArea( cDbfEst, @dbfTmpEst ), .f. )
  	if !NetErr()

  		( dbfTmpEst )->( ordCreate( cTmpEst, "nNumPed", "cSerPed + str( nNumPed ) + cSufPed + dtos( dFecSit )  + tFecSit", {|| Field->cSerPed + str( Field->nNumPed ) + Field->cSufPed + dtos( Field->dFecSit )  + Field->tFecSit } ) )
      	( dbfTmpEst )->( ordListAdd( cTmpEst ) )

  	else

      	lErrors     := .t.

  	end if

	/*
	Añadimos desde el fichero de lineas
	*/

   if ( D():PedidosClientesLineas( nView ) )->( dbSeek( cPedido ) )

      while ( D():PedidosClientesLineasId( nView ) == cPedido ) .AND. ( D():PedidosClientesLineas( nView ) )->( !eof() )

         ( dbfTmpLin )->( dbAppend() )
         if ( D():PedidosClientesLineas( nView ) )->nNumLin == 0 .and. dbLock( D():PedidosClientesLineas( nView ) )
            ( D():PedidosClientesLineas( nView ) )->nNumLin := ( dbfTmpLin )->( Recno() )
            ( D():PedidosClientesLineas( nView ) )->( dbRUnLock() )
         end if
         dbPass( D():PedidosClientesLineas( nView ), dbfTmpLin )

			( D():PedidosClientesLineas( nView ) )->( dbSkip() )

      end while

   end if

   ( dbfTmpLin )->( dbGoTop() )

   /*
   Añadimos desde el fichero de incidencias
	*/

   if ( nMode != DUPL_MODE ) .and. ( dbfPedCliI )->( dbSeek( cPedido ) )

      while ( ( dbfPedCliI )->cSerPed + Str( ( dbfPedCliI )->nNumPed ) + ( dbfPedCliI )->cSufPed == cPedido ) .AND. ( dbfPedCliI )->( !eof() )

         dbPass( dbfPedCliI, dbfTmpInc, .t. )
         ( dbfPedCliI )->( dbSkip() )

      end while

   end if

   ( dbfTmpInc )->( dbGoTop() )

  // Añadimos desde el fichero de situaiones
	
	if ( nMode != DUPL_MODE ) .and. ( D():PedidosClientesSituaciones( nView ) )->( dbSeek( cPedido ) )

      	while ( ( D():PedidosClientesSituaciones( nView ) )->cSerPed + Str( ( D():PedidosClientesSituaciones( nView ) )->nNumPed ) + ( D():PedidosClientesSituaciones( nView ) )->cSufPed == cPedido ) .AND. ( D():PedidosClientesSituaciones( nView ) )->( !eof() ) 

         dbPass( D():PedidosClientesSituaciones( nView ), dbfTmpEst, .t. )
         ( D():PedidosClientesSituaciones( nView ) )->( dbSkip() )

    	end while

  	end if

  	( dbfTmpEst )->( dbGoTop() )

   /*
   Añadimos desde el fichero de documentos
	*/

   if ( nMode != DUPL_MODE ) .and. ( dbfPedCliD )->( dbSeek( cPedido ) )

      while ( ( dbfPedCliD )->cSerPed + Str( ( dbfPedCliD )->nNumPed ) + ( dbfPedCliD )->cSufPed == cPedido ) .AND. ( dbfPedCliD )->( !eof() )

         dbPass( dbfPedCliD, dbfTmpDoc, .t. )
         ( dbfPedCliD )->( dbSkip() )

      end while

   end if

   ( dbfTmpDoc )->( dbGoTop() )

   /*
   Añadimos desde el fichero de entregas a cuenta
	*/

   if ( nMode != DUPL_MODE ) .and. ( D():PedidosClientesPagos( nView ) )->( dbSeek( cPedido ) )

      while ( ( D():PedidosClientesPagos( nView ) )->cSerPed + Str( ( D():PedidosClientesPagos( nView ) )->nNumPed ) + ( D():PedidosClientesPagos( nView ) )->cSufPed == cPedido ) .AND. ( D():PedidosClientesPagos( nView ) )->( !eof() )

         dbPass( D():PedidosClientesPagos( nView ), dbfTmpPgo, .t. )
         ( D():PedidosClientesPagos( nView ) )->( dbSkip() )

      end while

   end if

   ( dbfTmpPgo )->( dbGoTop() )

	/*
	Añadimos desde el fichero de lineas
	*/

   if ( nMode != DUPL_MODE ) .and. ( D():PedidosClientesReservas( nView ) )->( DbSeek( cPedido ) )

      while ( ( D():PedidosClientesReservas( nView ) )->cSerPed + Str( ( D():PedidosClientesReservas( nView ) )->nNumPed ) + ( D():PedidosClientesReservas( nView ) )->cSufPed == cPedido ) .and. ( D():PedidosClientesReservas( nView ) )->( !eof() )

         dbPass( D():PedidosClientesReservas( nView ), dbfTmpRes, .t. )
         ( D():PedidosClientesReservas( nView ) )->( DbSkip() )

      end while

   end if

   ( dbfTmpRes )->( dbGoTop() )

   oDetCamposExtra:SetTemporal( aTmp[ _CSERPED ] + Str( aTmp[ _NNUMPED ] ) + aTmp[ _CSUFPED ], "", nMode )

   RECOVER USING oError

      msgStop( "Imposible crear tablas temporales." + CRLF + ErrorMessage( oError ) )

      KillTrans()

      lErrors     := .t.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN lErrors

//-----------------------------------------------------------------------//

Static Function EdtInc( aTmp, aGet, dbfPedCliI, oBrw, bWhen, bValid, nMode, aTmpPed )

   	local oDlg
   	local oNomInci

   	if nMode == APPD_MODE
      	aTmp[ _CSERPED  ]    := aTmpPed[ _CSERPED ]
      	aTmp[ _NNUMPED  ]    := aTmpPed[ _NNUMPED ]
      	aTmp[ _CSUFPED  ]    := aTmpPed[ _CSUFPED ]
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

Return ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

Static Function EdtEst( aTmp, aGet, dbf, oBrw, bWhen, bValid, nMode, aTmpPed )

   	local oDlg

   	if nMode == APPD_MODE
      	
      	aTmp[ (D():PedidosClientesSituaciones( nView ))->(fieldpos("tFecSit")) ]	:= GetSysTime()

    end if

   	DEFINE DIALOG oDlg RESOURCE "SITUACION_ESTADO" TITLE LblTitle( nMode ) + "Situación del documento del cliente"

   		REDEFINE COMBOBOX aGet[ (D():PedidosClientesSituaciones( nView ))->(fieldpos("cSitua")) ] ;
   			VAR 	 aTmp[ (D():PedidosClientesSituaciones( nView ))->(fieldpos("cSitua")) ] ;
         	ID       200 ;
         	WHEN     ( nMode != ZOOM_MODE );
         	ITEMS    ( SituacionesRepository():getNombres() ) ;
         	OF       oDlg

        REDEFINE GET aGet[ (D():PedidosClientesSituaciones( nView ))->(fieldpos("dFecSit")) ] ;
        	VAR 	aTmp[ (D():PedidosClientesSituaciones( nView ))->(fieldpos("dFecSit")) ] ;
			ID 		100 ;
			SPINNER ;
         	ON HELP  aGet[ (D():PedidosClientesSituaciones( nView ))->(fieldpos("dFecSit")) ]:cText( Calendario( aTmp[ (D():PedidosClientesSituaciones( nView ))->(fieldpos("dFecSit")) ] ) ) ;
			WHEN 	( nMode != ZOOM_MODE ) ;
			OF 		oDlg

	  	REDEFINE GET aGet[ (D():PedidosClientesSituaciones( nView ))->(fieldpos("tFecSit")) ] ;
	  		VAR 	 aTmp[ (D():PedidosClientesSituaciones( nView ))->(fieldpos("tFecSit")) ] ;
         	ID       101 ;
         	PICTURE  "@R 99:99:99" ;
         	WHEN     ( nMode != ZOOM_MODE ) ;
         	VALID    ( iif( !validTime( aTmp[ (D():PedidosClientesSituaciones( nView ))->(fieldpos("tFecSit")) ] ),;
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

/*
Estudiamos la posiblidades que se pueden dar en una linea de detalle
*/

STATIC FUNCTION SetDlgMode( aTmp, aGet, nMode, oStkAct, oSayPr1, oSayPr2, oSayVp1, oSayVp2, oTotal, aTmpPed, oFld, oRentLin, oBrwAlbCli, oBrwAlbPrv, oBrwFacCli )

   local cCodArt        := Left( aGet[ _CREF ]:VarGet(), 18 )
   
   if !Empty( aGet[ __NBULTOS ] )
      if !uFieldEmpresa( "lUseBultos" )
         aGet[ __NBULTOS ]:Hide()
      else
         aGet[ __NBULTOS ]:SetText( uFieldempresa( "cNbrBultos" ) )
      end if 
   end if

   if !lUseCaj()
      aGet[ _NCANPED ]:Hide()
   else
      aGet[ _NCANPED ]:SetText( cNombreCajas() )
   end if

   if uFieldempresa( "lServicio" )
      aGet[ __DFECENT ]:Show()
      aGet[ __DFECSAL ]:Show()
   else
      aGet[ __DFECENT ]:Hide()
      aGet[ __DFECSAL ]:Hide()
   end if

   if nMode == APPD_MODE

      if !Empty( aGet[ _DFECHA ] )
         aTmp[ _DFECHA ]   := Ctod( "" )
         aGet[ _DFECHA ]:Refresh()
      end if

   end if

   aGet[ _NUNICAJA ]:SetText( cNombreUnidades() )

   if aGet[ _NVALIMP ] != nil
      if !uFieldEmpresa( "lUseImp", .f. )
         aGet[ _NVALIMP ]:Hide()
      else
         if !uFieldEmpresa( "lModImp", .f. )
            aGet[ _NVALIMP ]:Disable()
         end if
      end if
   end if

   if aGet[ _NIMPTRN ] != nil
      if !uFieldEmpresa( "lUsePor", .f. )
         aGet[ _NIMPTRN ]:Hide()
      end if
   end if

   if aGet[ _NPNTVER ] != nil
      if !uFieldEmpresa( "lUsePnt", .f. ) .or. !aTmpPed[ _LOPERPV ]
         aGet[ _NPNTVER ]:Hide()
      end if
   end if

   if aGet[ _NDTODIV ] != nil
      if !uFieldEmpresa( "lDtoLin", .f. )
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
      
      aTmp[ _LIVALIN ] 	:= aTmpPed[ _LIVAINC ]

      aGet[ _NCANPED  ]:cText( 1 )
      aGet[ _NUNICAJA ]:cText( 1 )
      aTmp[ _NNUMLIN  ] := nLastNum( dbfTmpLin )

      if !Empty( aGet[ _NPOSPRINT  ] )
         aGet[ _NPOSPRINT  ]:cText( nLastNum( dbfTmpLin, ( "nPosPrint" ) ) )
      else
         aTmp[ _NPOSPRINT  ] := nLastNum( dbfTmpLin, ( "nPosPrint" ) )
      end if

      aGet[ _CALMLIN  ]:cText( aTmpPed[ _CCODALM ])

      if !Empty( aGet[ _DANULADO  ] )
         aGet[ _DANULADO ]:cText( Ctod( "" ) )
      else
         aTmp[ _DANULADO ] := Ctod( "" )
      end if

      if !Empty( aGet[ _LANULADO ] )
         aGet[ _LANULADO ]:Click( .f. )
      end if

      aGet[ _CREF     ]:show()
      aGet[ _CDETALLE ]:show()
      aGet[ _MLNGDES  ]:hide()

      if !Empty( aGet[ _CLOTE ] )
         aGet[ _CLOTE ]:hide()
      end if

      if !empty( aGet[ __CCENTROCOSTE ] )
         aGet[ __CCENTROCOSTE ]:cText( aTmpPed[ _CCENTROCOSTE ] )
         aGet[ __CCENTROCOSTE ]:lValid()
      endif

      cTipoCtrCoste        := "Centro de coste"
      oTipoCtrCoste:Refresh()
      clearGet( aGet[ _CTERCTR ] )

      if aTmpPed[ _NREGIVA ] <= 2
         if !empty( aGet[ _NIVA ] )
            aGet[ _NIVA ]:cText( nIva( D():TiposIva( nView ), cDefIva() ) )
         else
            aTmp[ _NIVA ]  := nIva( D():TiposIva( nView ), cDefIva() )
         end if   

         aTmp[ _NREQ ]     := nReq( D():TiposIva( nView ), cDefIva() )
      end if

   case nMode != APPD_MODE .AND. empty( cCodArt )

      aGet[ _CREF     ]:hide()
      aGet[ _CDETALLE ]:hide()
      aGet[ _MLNGDES  ]:show()

      if !Empty( aGet[ _CLOTE ] )
         if aTmp[ _LLOTE ]
            aGet[ _CLOTE ]:Show()
         else
            aGet[ _CLOTE ]:Hide()
         end if
      end if

   case nMode != APPD_MODE .AND. !empty( cCodArt )

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

      if !Empty( oStock )
         oStock:nPutStockActual( cCodArt, aTmp[ _CALMLIN ], aTmp[ _CVALPR1 ], aTmp[ _CVALPR2 ], aTmp[ _CLOTE ], aTmp[ _LKITART ], aTmp[ _NCTLSTK ], oStkAct )
      end if

      if !Empty( aGet[ _CCODPRV ] )
         aGet[ _CCODPRV ]:lValid()
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

         if !Empty( aGet[ _CVALPR1 ] )
            aGet[ _CVALPR1 ]:Show()
            aGet[ _CVALPR1 ]:lValid()
         end if

         if !Empty( oSayPr1 )
            oSayPr1:Show()
            oSayPr1:SetText( retProp( aTmp[ _CCODPR1 ], dbfPro ) )
         end if

         if !Empty( oSayVp1 )
            oSayVp1:Show()
         end if

      else

         if !Empty( aGet[_CVALPR1 ] )
            aGet[ _CVALPR1 ]:hide()
         end if

         if !Empty( oSayPr1 )
            oSayPr1:hide()
         end if

         if !Empty( oSayVp1 )
            oSayVp1:hide()
         end if

      end if

      if !Empty( aTmp[ _CCODPR2 ] )

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

   aGet[ _CALMLIN ]:lValid()

   if !lAccArticulo() .or. oUser():lNotCostos()

      if !Empty( oRentLin )
         oRentLin:Hide()
      end if

      if !Empty( aGet[ _NCOSDIV ] )
         aGet[ _NCOSDIV ]:Hide()
      end if

   end if

   /*
   Solo pueden modificar los precios los administradores--------------
   */

   if ( empty( aTmp[ _NPREDIV ] ) .or. SQLAjustableModel():getRolCambiarPrecios( Auth():rolUuid() ) ) .and. nMode != ZOOM_MODE

      aGet[ _NPREDIV ]:HardEnable()
      aGet[ _NIMPTRN ]:HardEnable()

      if !Empty( aGet[ _NPNTVER ] )
          aGet[ _NPNTVER ]:HardEnable()
      end if

      aGet[ _NDTO    ]:HardEnable()
      aGet[ _NDTOPRM ]:HardEnable()

      if !Empty( aGet[ _NDTODIV ] )
         aGet[ _NDTODIV ]:HardEnable()
      end if

   else

      aGet[ _NPREDIV ]:HardDisable()
      aGet[ _NIMPTRN ]:HardDisable()

      if !Empty( aGet[ _NPNTVER ] )
         aGet[ _NPNTVER ]:HardDisable()
      end if

      aGet[ _NDTO    ]:HardDisable()
      aGet[ _NDTOPRM ]:HardDisable()

      if !Empty( aGet[ _NDTODIV ] )
         aGet[ _NDTODIV ]:HardDisable()
      end if

   end if

   // Ocultamos o mostramos las tres unidades de medicion----------------------

   if !Empty( aGet[ ( D():PedidosClientesLineas( nView ) )->( fieldpos( "nMedUno" ) ) ] )
      aGet[ ( D():PedidosClientesLineas( nView ) )->( fieldpos( "nMedUno" ) ) ]:Hide()
   end if

   if !Empty( aGet[ ( D():PedidosClientesLineas( nView ) )->( fieldpos( "nMedDos" ) ) ] )
      aGet[ ( D():PedidosClientesLineas( nView ) )->( fieldpos( "nMedDos" ) ) ]:Hide()
   end if

   if !Empty( aGet[ ( D():PedidosClientesLineas( nView ) )->( fieldpos( "nMedTre" ) ) ] )
      aGet[ ( D():PedidosClientesLineas( nView ) )->( fieldpos( "nMedTre" ) ) ]:Hide()
   end if

   if oUndMedicion:oDbf:Seek(  aTmp[ _CUNIDAD ] )

      if !Empty( aGet[ ( D():PedidosClientesLineas( nView ) )->( fieldpos( "nMedUno" ) ) ] ) .and. oUndMedicion:oDbf:nDimension >= 1 .and. !Empty( oUndMedicion:oDbf:cTextoDim1 )
         aGet[ ( D():PedidosClientesLineas( nView ) )->( fieldpos( "nMedUno" ) ) ]:oSay:SetText( oUndMedicion:oDbf:cTextoDim1 )
         aGet[ ( D():PedidosClientesLineas( nView ) )->( fieldpos( "nMedUno" ) ) ]:Show()
      end if

      if !Empty( aGet[ ( D():PedidosClientesLineas( nView ) )->( fieldpos( "nMedDos" ) ) ] ) .and. oUndMedicion:oDbf:nDimension >= 2 .and. !Empty( oUndMedicion:oDbf:cTextoDim2 )
         aGet[ ( D():PedidosClientesLineas( nView ) )->( fieldpos( "nMedDos" ) ) ]:oSay:SetText( oUndMedicion:oDbf:cTextoDim2 )
         aGet[ ( D():PedidosClientesLineas( nView ) )->( fieldpos( "nMedDos" ) ) ]:Show()
      end if

      if !Empty( aGet[ ( D():PedidosClientesLineas( nView ) )->( fieldpos( "nMedTre" ) ) ] ) .and. oUndMedicion:oDbf:nDimension >= 3 .and. !Empty( oUndMedicion:oDbf:cTextoDim3 )
         aGet[ ( D():PedidosClientesLineas( nView ) )->( fieldpos( "nMedTre" ) ) ]:oSay:SetText( oUndMedicion:oDbf:cTextoDim3 )
         aGet[ ( D():PedidosClientesLineas( nView ) )->( fieldpos( "nMedTre" ) ) ]:Show()
      end if

   end if

   // Refrescamos los xBrowse nuevos-------------------------------------------

   if !Empty( oBrwAlbCli )
      oBrwAlbCli:GoTop()
      oBrwAlbCli:Refresh()
   end if

   if !Empty( oBrwFacCli )
      oBrwFacCli:GoTop()
      oBrwFacCli:Refresh()
   end if

   if !Empty( oBrwAlbPrv )
      oBrwAlbPrv:GoTop()
      oBrwAlbPrv:Refresh()
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

STATIC FUNCTION SaveDeta( aTmp, aTmpPed, aGet, oFld, oDlg2, oBrw, bmpImage, nMode, oStkAct, oSayPr1, oSayPr2, oSayVp1, oSayVp2, oTotal, oEstadoProduccion, oBtn )

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
      msgStop( "Demasiados tipos de " + cImp() + " en un mismo documento.", "Atención" )
      return nil
   end if

   if Empty( aTmp[ _CALMLIN ] ) .and. !Empty( aTmp[ _CREF ] )
      msgStop( "Código de almacén no puede estar vacío", "Atención" )
      return nil
   end if

   if !cAlmacen( aGet[ _CALMLIN ], dbfAlm )
      return nil
   end if

   // control de precios minimos-----------------------------------------------

   if lPrecioMinimo( aTmp[ _CREF ], aTmp[ _NPREDIV ], nMode, D():Articulos( nView ) )
      msgStop( "El precio de venta es inferior al precio mínimo.")
      return nil
   end if 
   
   // Situaciones atipicas-----------------------------------------------------

   CursorWait()

   nRec                          := ( dbfTmpLin )->( RecNo() )

   aTmp[ _CTIPCTR ]              := cTipoCtrCoste
   aTmp[ _NREQ ]                 := nPReq( D():TiposIva( nView ), aTmp[ _NIVA ] )
   aTmp[ _NPRODUC ]              := oEstadoProduccion:nAt - 1

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

                  aTmp[ _NNUMLIN ]     := nLastNum( dbfTmpLin )
                  aTmp[ _NPOSPRINT ]   := nLastNum( dbfTmpLin, "nPosPrint" )
                  aTmp[ _NUNICAJA]     := oBrwProperties:Cargo[ n, i ]:Value
                  aTmp[ _CCODPR1 ]     := oBrwProperties:Cargo[ n, i ]:cCodigoPropiedad1
                  aTmp[ _CVALPR1 ]     := oBrwProperties:Cargo[ n, i ]:cValorPropiedad1
                  aTmp[ _CCODPR2 ]     := oBrwProperties:Cargo[ n, i ]:cCodigoPropiedad2
                  aTmp[ _CVALPR2 ]     := oBrwProperties:Cargo[ n, i ]:cValorPropiedad2

                  // Precio por propiedades --------------------------------------------------

                  nPrecioPropiedades   := nPrePro( aTmp[ _CREF ], aTmp[ _CCODPR1 ], aTmp[ _CVALPR1 ], aTmp[ _CCODPR2 ], aTmp[ _CVALPR2 ], aTmp[ _NTARLIN ], aTmpPed[ _LIVAINC ], dbfArtDiv, dbfTarPreL, aTmpPed[ _CCODTAR ] )
                  if !empty(nPrecioPropiedades)
                     aTmp[ _NPREDIV ]  := nPrecioPropiedades
                  end if 

                  saveDetail( aTmp, aClo, aGet, aTmpPed, dbfTmpLin, oBrw, nMode )

               end if

            next

         next

      else

         saveDetail( aTmp, aClo, aGet, aTmpPed, dbfTmpLin, oBrw, nMode )

         //WinGather( aTmp, aGet, dbfTmpLin, oBrw, nMode )

      end if

   else

      WinGather( aTmp, aGet, dbfTmpLin, oBrw, nMode )

   end if

   ( dbfTmpLin )->( dbGoTo( nRec ) )

   // Si estamos añadiendo y hay entradas continuas--------------------------------

   cOldCodArt                          := ""
   cOldUndMed                          := ""

   // Liberacion del bitmap-------------------------------------------------------

   if !empty( bmpImage )
      bmpImage:Hide()
      palBmpFree( bmpImage:hBitmap, bmpImage:hPalette )
   end if

   // Si estamos añadiendo y hay entradas continuas-------------------------------

   if nMode == APPD_MODE .and. lEntCon()

      recalculaTotal( aTmpPed )

      aCopy( dbBlankRec( dbfTmpLin ), aTmp )
      aEval( aGet, {| o, i | if( "GET" $ o:ClassName(), o:cText( aTmp[ i ] ), ) } )

      setDlgMode( aTmp, aGet, nMode, oStkAct, oSayPr1, oSayPr2, oSayVp1, oSayVp2, oTotal, aTmpPed, oFld )

      sysRefresh()

   else

      oDlg2:end( IDOK )

   end if

   CursorWE()

Return nil

//--------------------------------------------------------------------------//

Static Function saveDetail( aTmp, aClo, aGet, aTmpPed, dbfTmpLin, oBrw, nMode )

   local hAtipica
   local sOfertaArticulo
   local nCajasGratis         := 0
   local nUnidadesGratis      := 0

   // Atipicas ----------------------------------------------------------------

   hAtipica                   := hAtipica( hValue( aTmp, aTmpPed ) )
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
      
      sOfertaArticulo         := structOfertaArticulo( D():getHashArray( aTmpPed, "PedCliT", nView ), D():getHashArray( aTmp, "PedCliL", nView ), nTotLPedCli( aTmp ), nView )
      
      if !empty( sOfertaArticulo ) 
         nCajasGratis         := sOfertaArticulo:nCajasGratis
         nUnidadesGratis      := sOfertaArticulo:nUnidadesGratis
      end if
   end if 

   // Cajas gratis ------------------------------------------------------------

   if nCajasGratis != 0
      aTmp[ _LLINOFE ]        := .t.
      aTmp[ _NCANPED ]        -= nCajasGratis
      commitDetail( aTmp, aClo, nil, aTmpPed, dbfTmpLin, oBrw, nMode, .f. )

      aTmp[ _LLINOFE ]        := .t.
      aTmp[ _NCANPED ]        := nCajasGratis
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

      commitDetail( aTmp, aClo, nil, aTmpPed, dbfTmpLin, oBrw, nMode, .f. )

      aTmp[ _LLINOFE ]        := .t.
      aTmp[ _NUNICAJA]        := nUnidadesGratis 
      aTmp[ _NPREDIV ]        := 0
      aTmp[ _NDTO    ]        := 0
      aTmp[ _NDTODIV ]        := 0
      aTmp[ _NDTOPRM ]        := 0
      aTmp[ _NCOMAGE ]        := 0
   end if 

   commitDetail( aTmp, aClo, aGet, aTmpPed, dbfTmpLin, oBrw, nMode, .t. )

Return nil

//--------------------------------------------------------------------------//

Static Function commitDetail( aTmp, aClo, aGet, aTmpPed, dbfTmpLin, oBrw, nMode, lEmpty )

   winGather( aTmp, aGet, dbfTmpLin, oBrw, nMode, nil, .f. )

   if ( nMode == APPD_MODE ) .and. ( aClo[ _LKITART ] )
      appendKit( aClo, aTmpPed )
   end if

Return nil

//--------------------------------------------------------------------------//

Static Function AppendKit( uTmpLin, aTmpPed )

   local cCodArt
   local cSerPed
   local nNumPed
   local cSufPed
   local nCanPed
   local dFecPed
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
   local nUnidades                     := 0
   local nStkActual                    := 0
   local nStockMinimo                  := 0
   local nRecAct                       := ( dbfKit 	)->( Recno() )
   local nRecLin 								:= ( dbfTmpLin )->( Recno() )

   if IsArray( uTmpLin )
      cCodArt                          := uTmpLin[ _CREF    ]
      cSerPed                          := uTmpLin[ _CSERPED ]
      nNumPed                          := uTmpLin[ _NNUMPED ]
      cSufPed                          := uTmpLin[ _CSUFPED ]
      nCanPed                          := uTmpLin[ _NCANPED ]
      dFecPed                          := uTmpLin[ _DFECHA  ]
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
      cSerPed                          := ( uTmpLin )->cSerPed
      nNumPed                          := ( uTmpLin )->nNumPed
      cSufPed                          := ( uTmpLin )->cSufPed
      nCanPed                          := ( uTmpLin )->nCanPed
      dFecPed                          := ( uTmpLin )->dFecha
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
               ( dbfTmpLin )->nNumLin  	:= nLastNum( dbfTmpLin )
               ( dbfTmpLin )->nPosPrint   := nLastNum( dbfTmpLin , "nPosPrint" )
               ( dbfTmpLin )->lKitChl  	:= .f.
            else
               ( dbfTmpLin )->nNumLin  	:= nNumLin
               ( dbfTmpLin )->nPosPrint   := nPosPrint
               ( dbfTmpLin )->lKitChl  	:= .t.
            end if

            ( dbfTmpLin )->nNumKit     := nLastNum( dbfTmpLin, "nNumKit" )
            ( dbfTmpLin )->cRef        := ( dbfkit      )->cRefKit
            ( dbfTmpLin )->cDetalle    := ( D():Articulos( nView ) )->Nombre
            ( dbfTmpLin )->nPntVer     := ( D():Articulos( nView ) )->nPntVer1
            ( dbfTmpLin )->nPesoKg     := ( D():Articulos( nView ) )->nPesoKg
            ( dbfTmpLin )->cPesoKg     := ( D():Articulos( nView ) )->cUndDim
            ( dbfTmpLin )->cUnidad     := ( D():Articulos( nView ) )->cUnidad
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

            ( dbfTmpLin )->cCodFam 		:= ( D():Articulos( nView ) )->Familia
            ( dbfTmpLin )->cGrpFam 		:= cGruFam( ( dbfTmpLin )->cCodFam, D():Familias( nView ) )

            /*
            Datos de la cabecera-----------------------------------------------
            */

            ( dbfTmpLin )->cSerPed     := cSerPed
            ( dbfTmpLin )->nNumPed     := nNumPed
            ( dbfTmpLin )->cSufPed     := cSufPed
            ( dbfTmpLin )->nCanPed     := nCanPed
            ( dbfTmpLin )->dFecha      := dFecPed
            ( dbfTmpLin )->cAlmLin     := cAlmLin
            ( dbfTmpLin )->lIvaLin     := lIvaLin
            ( dbfTmpLin )->nComAge     := nComAge

            /*
            Estudio de los tipos de " + cImp() + " si el padre el cero todos cero------
            */

            if !Empty( nIvaLin )
               ( dbfTmpLin )->nIva     := nIva( D():TiposIva( nView ), ( D():Articulos( nView ) )->TipoIva )
               ( dbfTmpLin )->nReq     := nReq( D():TiposIva( nView ), ( D():Articulos( nView ) )->TipoIva )
            else
               ( dbfTmpLin )->nIva     := 0
               ( dbfTmpLin )->nReq     := 0
            end if

            /*
            Propiedades de los kits-----------------------------------------
            */

            ( dbfTmpLin )->lImpLin     := lImprimirComponente( cCodArt, D():Articulos( nView ) )   // 1 Todos, 2 Compuesto, 3 Componentes
            ( dbfTmpLin )->lKitPrc     := lPreciosComponentes( cCodArt, D():Articulos( nView ) )

            ( dbfTmpLin )->nUniCaja    := nUniCaj * ( dbfKit )->nUndKit

            if ( dbfTmpLin )->lKitPrc
               ( dbfTmpLin )->nPreDiv  := nRetPreArt( nTarLin, aTmpPed[ _CDIVPED ], aTmpPed[ _LIVAINC ], D():Articulos( nView ), D():Divisas( nView ), dbfKit, D():TiposIva( nView ), , , oNewImp )
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
               AppendKit( dbfTmpLin, aTmpPed )
            end if

            /*
            Avisaremos del stock bajo minimo--------------------------------------
            */

            nStockMinimo      := nStockMinimo( cCodArt, cAlmLin, nView )

            if ( D():Articulos( nView ))->lMsgVta .and. !uFieldEmpresa( "lNStkAct" ) .and. nStockMinimo > 0

               nStkActual     := oStock:nStockAlmacen( ( dbfKit )->cRefKit, cAlmLin )
               nUnidades      := nUniCaj * ( dbfKit )->nUndKit

               do case
                  case nStkActual - nUnidades < 0

                       MsgStop( 	"No hay stock suficiente para realizar la venta" + CRLF + ;
                                 "del componente " + AllTrim( ( dbfKit )->cRefKit ) + " - " + AllTrim( ( D():Articulos( nView ) )->Nombre ),;
                                 "¡Atención!" )

                  case nStkActual - nUnidades < nStockMinimo

                       MsgStop( 	"El stock del componente " + AllTrim( ( dbfKit )->cRefKit ) + " - " + AllTrim( ( D():Articulos( nView ) )->Nombre ) + CRLF + ;
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

   ( dbfKit 	)->( dbGoTo( nRecAct ) )
   ( dbfTmpLin )->( dbGoTo( nRecLin ) )

Return ( nil )

//---------------------------------------------------------------------------//

STATIC FUNCTION lMoreIva( nCodIva )

	/*
	Si no esta dentro de los porcentajes anteriores
	*/

   if _NPCTIVA1 == nil .OR. _NPCTIVA2 == nil .OR. _NPCTIVA3 == nil
      return .t.
   end if

   if _NPCTIVA1 == nCodIva .OR. _NPCTIVA2 == nCodIva .OR. _NPCTIVA3 == nCodIva
      return .t.
   end if

   MsgStop( "Documento con mas de 3 Tipos de " + cImp() )

return .f.

//---------------------------------------------------------------------------//

/*
Calcula totales en las lineas de Detalle
*/

STATIC FUNCTION RecalculaLinea( aTmp, aTmpPed, nDec, oTotal, oTot, oMargen, cCodDiv, lTotal )

   local nCalculo
   local nUnidades
   local nMargen
   local nCosto
   local nRentabilidad
   local nBase       := 0

   DEFAULT lTotal    := .f.

   nUnidades         := nTotNPedCli( aTmp )

   if aTmp[ __LALQUILER ]
      nCalculo       := aTmp[ _NPREALQ  ]
   else
      nCalculo       := aTmp[ _NPREDIV  ]
   end if

   nCalculo          -= aTmp[ _NDTODIV  ]

   /*
   IVMH------------------------------------------------------------------------
   */

   if !aTmp[ _LIVALIN ]

      if aTmp[ _LVOLIMP ]
         nCalculo    += aTmp[ _NVALIMP ] * NotCero( aTmp[ _NVOLUMEN ] )
      else
         nCalculo    += aTmp[ _NVALIMP ]
      end if

   end if

   nCalculo          *= nUnidades


   /*
   Transporte------------------------------------------------------------------
   */

   if aTmp[ _NIMPTRN ] != 0
      nCalculo       += aTmp[ _NIMPTRN ] * nUnidades
   end if

   /*
   Descuentos------------------------------------------------------------------
   */

   if aTmp[ _NDTO ] != 0
      nCalculo       -= nCalculo * aTmp[ _NDTO    ] / 100
   end if

   if aTmp[ _NDTOPRM ] != 0
      nCalculo       -= nCalculo * aTmp[ _NDTOPRM ] / 100
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

   if aTmpPed[ _LOPERPV ]
      nCalculo       += aTmp[ _NPNTVER ] * nUnidades
   end if

   nCalculo          := Round( nCalculo, nDec )

   if !Empty( oTotal )
      oTotal:cText( nCalculo )
   end if

   if oTot != nil
      aEval( oTot, {|o| o:Refresh() } )
   end if

   if oMargen != nil
      oMargen:cText( AllTrim( Trans( nMargen, cPorDiv ) + Space( 1 ) + AllTrim( cSimDiv( cCodDiv, D():Divisas( nView ) ) ) + " : " + AllTrim( Trans( nRentabilidad, "999.99" ) ) + "%" ) )
   end if

   if !Empty( oComisionLinea )
      oComisionLinea:cText( Round( ( nBase * aTmp[ _NCOMAGE ] / 100 ), nRouDiv ) )
   end if

RETURN ( if( !lTotal, .t., nCalculo ) )

//---------------------------------------------------------------------------//

STATIC FUNCTION LoaArt( cCodArt, aTmp, aGet, aTmpPed, oStkAct, oSayPr1, oSayPr2, oSayVp1, oSayVp2, bmpImage, nMode, lFocused )

   local hHas128
   local cLote
   local nCosPro
   local nDtoAge
   local cCodFam
   local cPrpArt
   local nImpAtp              := 0
   local nImpOfe              := 0
   local nPrePro              := 0
   local nDescuentoArticulo   := 0
   local sOfertaArticulo
   local cProveedor
   local lChgCodArt           := ( Empty( cOldCodArt ) .or. Rtrim( cOldCodArt ) != Rtrim( cCodArt ) )
   local nTarOld              := aTmp[ _NTARLIN ]
   local dFecPed              := aTmpPed[ _DFECPED ]
   local hAtipica
   local nUnidades            := 0

   DEFAULT lFocused           := .t.

   if !Empty( aTmpPed[ _DFECENT ] )
   	dFecPed 			         := aTmpPed[ _DFECENT ]
   end if 

   if Empty( cCodArt )

      if lRetCodArt()
         MsgStop( "No se pueden añadir líneas sin codificar" )
         return .f.
      end if

      if Empty( aTmp[ _NIVA ] )
         aGet[ _NIVA ]:bWhen      := {|| .t. }
      end if

      if  !Empty( aGet[ _NVALIMP ] )
         aGet[ _NVALIMP ]:bWhen  := {|| .t. }
      end if

      aGet[ _CDETALLE ]:hide()

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

      if !Empty( aGet[ _NVALIMP ] )
         if uFieldEmpresa( "lModImp" )
            aGet[ _NVALIMP ]:bWhen   := {|| .t. }
         else
            aGet[ _NVALIMP ]:bWhen   := {|| .f. }
         end if
      end if

      aGet[ _CDETALLE ]:Show()

      if !Empty( aGet[ _NVALIMP ] )
          aGet[ _MLNGDES ]:hide()
      end if

      /*
      Buscamos codificacion GS1-128--------------------------------------------
      */

      if Len( Alltrim( cCodArt ) ) > 18

         hHas128                 := ReadHashCodeGS128( cCodArt )
         if !Empty( hHas128 )
            
            cCodArt              := uGetCodigo( hHas128, "00" )

            if Empty( cCodArt )
               cCodArt           := uGetCodigo( hHas128, "01" )
            end if

         end if 

      end if 

      cCodArt                    := cSeekCodebar( cCodArt, dbfCodebar, D():Articulos( nView ) )

      if ( D():Articulos( nView ) )->( dbSeek( cCodArt ) ) .or. ( D():Articulos( nView ) )->( dbSeek( Upper( cCodArt ) ) )

         if ( D():Articulos( nView ) )->lObs
            MsgStop( "Artículo catalogado como obsoleto" )
            return .f.
         end if

         // Entramos siempre que cambie el código del artículo-----------------

         if ( lChgCodArt )

            cCodArt              := ( D():Articulos( nView ) )->Codigo

            aGet[ _CREF ]:cText( Padr( cCodArt, 200 ) )
            aTmp[ _CREF ]        := cCodArt

            //Pasamos las referencias adicionales------------------------------

            aTmp[ _CREFAUX ]     := ( D():Articulos( nView ) )->cRefAux
            aTmp[ _CREFAUX2 ]    := ( D():Articulos( nView ) )->cRefAux2

            if ( D():Articulos( nView ) )->lMosCom .and. !Empty( ( D():Articulos( nView ) )->mComent )
               MsgStop( Trim( ( D():Articulos( nView ) )->mComent ) )
            end if

            /*
			   Proveedor del artículo---------------------------------------------
            */

            if !Empty( aGet[ _CCODPRV ] )
                aGet[ _CCODPRV ]:cText( ( D():Articulos( nView ) )->cPrvHab )
                aGet[ _CCODPRV ]:lValid()
            end if

            aTmp[ _CREFPRV ]  := Padr( cRefPrvArt( aTmp[ _CREF ], ( D():Articulos( nView ) )->cPrvHab , dbfArtPrv ) , 18 )

            /*
            Descripciones largas--------------------------------------------------
            */

            if !Empty( aGet[ _DESCRIP ] )
               aGet[ _DESCRIP ]:cText( ( D():Articulos( nView ) )->Descrip )
            else
               aTmp[ _DESCRIP ]     := ( D():Articulos( nView ) )->Descrip
            end if

            /*
            Lotes
            ---------------------------------------------------------------------
            */

            if ( D():Articulos( nView ) )->lLote

               aTmp[ _LLOTE ]       := ( D():Articulos( nView ) )->lLote

               if Empty( cLote )
                  cLote          	:= ( D():Articulos( nView ) )->cLote
               end if 

               if !Empty( aGet[ _CLOTE ] )
                  aGet[ _CLOTE ]:show()
                  aGet[ _CLOTE ]:cText( cLote )
               else
                  aTmp[ _CLOTE ]    := cLote
               end if

            else

               if !Empty( aGet[ _CLOTE ] )
                  aGet[ _CLOTE ]:hide()
               end if

            end if

            /*
            Tratamientos kits-----------------------------------------------------
            */

            if ( D():Articulos( nView ) )->lKitArt

               aTmp[ _LKITART ]        := ( D():Articulos( nView ) )->lKitArt                        				// Marcamos como padre del kit
               aTmp[ _LIMPLIN ]        := lImprimirCompuesto( ( D():Articulos( nView ) )->Codigo, D():Articulos( nView ) ) 	// 1 Todos, 2 Compuesto
               aTmp[ _LKITPRC ]        := lPreciosCompuestos( ( D():Articulos( nView ) )->Codigo, D():Articulos( nView ) )	// 1 Todos, 2 Compuesto

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

               aTmp[ _LIMPLIN ]     := .f.

               if aGet[ _NCTLSTK ] != nil
                  aGet[ _NCTLSTK ]:SetOption( ( D():Articulos( nView ) )->nCtlStock )
               else
                  aTmp[ _NCTLSTK ]  := ( D():Articulos( nView ) )->nCtlStock
               end if

            end if

            /*
            Coger el tipo de venta------------------------------------------------
            */

            aTmp[ _LMSGVTA ]        := ( D():Articulos( nView ) )->lMsgVta
            aTmp[ _LNOTVTA ]        := ( D():Articulos( nView ) )->lNotVta

            /*
            Cogemos las familias y los grupos de familias
            */

            cCodFam               	:= ( D():Articulos( nView ) )->Familia
            if !Empty( cCodFam )

               if !Empty( aGet[ _CCODFAM ] )
                  aGet[ _CCODFAM ]:cText( cCodFam )
                  aGet[ _CCODFAM ]:lValid()
               else
                  aTmp[ _CCODFAM ]  := cCodFam
               end if

               if !Empty( aGet[ _CGRPFAM ] )
                  aGet[ _CGRPFAM ]:cText( cGruFam( cCodFam, D():Familias( nView ) ) )
                  aGet[ _CGRPFAM ]:lValid()
               else
                  aTmp[ _CGRPFAM ]  := cGruFam( cCodFam, D():Familias( nView ) )
               end if

            else

               if !Empty( aGet[ _CCODFAM ] )
                  aGet[ _CCODFAM ]:cText( Space( 8 ) )
                  aGet[ _CCODFAM ]:lValid()
               else
                  aTmp[ _CCODFAM ]  := Space( 8 )
               end if

               if !Empty( aGet[ _CGRPFAM ] )
                  aGet[ _CGRPFAM ]:cText( Space( 3 ) )
                  aGet[ _CGRPFAM ]:lValid()
               else
                  aTmp[ _CGRPFAM ]  := Space( 3 )
               end if

            end if

            /*
            Unidades e impuestos--------------------------------------------------------
            */

            if aGet[ _CDETALLE ] != nil
               aGet[ _CDETALLE ]:cText( ( D():Articulos( nView ) )->Nombre )
            else
               aTmp[ _CDETALLE ] := ( D():Articulos( nView ) )->Nombre
            end if

            if aGet[ _MLNGDES ] != nil
               aGet[ _MLNGDES ]:cText( ( D():Articulos( nView ) )->Descrip )
            else
               aTmp[ _MLNGDES ] := ( D():Articulos( nView ) )->Descrip
            end if

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
               aGet[ _CPESOKG  ]:cText( ( D():Articulos( nView ) )->cUndDim )
            else
               aGet[ _CPESOKG  ] := ( D():Articulos( nView ) )->cUndDim
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
            Tipo de articulo---------------------------------------------------
            */

            if !Empty( aGet[ _CCODTIP ] )
               aGet[ _CCODTIP ]:cText( ( D():Articulos( nView ) )->cCodTip )
            else
               aTmp[ _CCODTIP ] := ( D():Articulos( nView ) )->cCodTip
            end if

            if (D():Articulos( nView ))->nCajEnt != 0
               aGet[ _NCANPED ]:cText( (D():Articulos( nView ))->nCajEnt )
            end if

            if ( D():Articulos( nView ) )->nUniCaja != 0
               aGet[ _NUNICAJA ]:cText( ( D():Articulos( nView ) )->nUniCaja )
            end if

            /*
            Preguntamos si el regimen de " + cImp() + " es distinto de Exento
            */

            if aTmpPed[ _NREGIVA ] <= 2
               aGet[ _NIVA ]:cText( nIva( D():TiposIva( nView ), ( D():Articulos( nView ) )->TipoIva ) )
               aTmp[ _NREQ ]     := nReq( D():TiposIva( nView ), ( D():Articulos( nView ) )->TipoIva )
            end if

            /*
            Ahora recogemos el impuesto especial si lo hay
            */

            aTmp[ _CCODIMP ]     := ( D():Articulos( nView ) )->cCodImp
            oNewImp:setCodeAndValue( aTmp[ _CCODIMP ], aGet[ _NVALIMP ] )

            if !Empty( ( D():Articulos( nView ) )->cCodImp )
               aTmp[ _LVOLIMP ]     := RetFld( ( D():Articulos( nView ) )->cCodImp, oNewImp:oDbf:cAlias, "lIvaVol" )
            end if

            /*
            Buscamos si el articulo tiene factor de conversion--------------------
            */

            if ( D():Articulos( nView ) )->lFacCnv
               aTmp[ _NFACCNV ]     := ( D():Articulos( nView ) )->nFacCnv
            end if

            // Si la comisi¢n del articulo hacia el agente es distinto de cero----

            loadComisionAgente( aTmp, aGet, aTmpPed )

            // Imagen del producto---------------------------------------------------

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
            Tomamos el valor del stock y anotamos si nos dejan vender sin stock
            */

            if oStkAct != nil .and. !uFieldEmpresa( "lNStkAct" ) .and. aTmp[ _NCTLSTK ] <= 1
               oStock:nPutStockActual( aTmp[ _CREF ], aTmp[ _CALMLIN ], , , , aTmp[ _LKITART ], aTmp[ _NCTLSTK ], oStkAct )
            end if

            /*
            Buscamos la familia del articulo y anotamos las propiedades-----------
            */

            aTmp[ _CCODPR1 ]  := ( D():Articulos( nView ) )->cCodPrp1
            aTmp[ _CCODPR2 ]  := ( D():Articulos( nView ) )->cCodPrp2

            if ( !Empty( aTmp[ _CCODPR1 ] ) .or. !Empty( aTmp[ _CCODPR2 ] ) ) .and. ( uFieldEmpresa( "lUseTbl" ) .and. ( nMode == APPD_MODE ) )

               aGet[ _NCANPED  ]:cText( 0 )
               aGet[ _NUNICAJA ]:cText( 0 )

               setPropertiesTable( cCodArt,  aTmp[ _CCODPR1 ], aTmp[ _CCODPR2 ], 0, aGet[ _NUNICAJA ], oBrwProperties, nView )

            else 


               hidePropertiesTable( oBrwProperties )

               if !empty( aTmp[ _CCODPR1 ] )

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

                  if !empty( aGet[ _CVALPR1 ] ) .and. !empty( oSayPr1 ) .and. !empty( oSayVp1 )
                     aGet[ _CVALPR1 ]:hide()
                     oSayPr1:hide()
                     oSayVp1:hide()
                  end if

               end if

               if !empty( aTmp[_CCODPR2 ] )

                  if aGet[ _CVALPR2 ] != nil
                     aGet[ _CVALPR2 ]:show()
                  end if

                  if oSayPr2 != nil
                     oSayPr2:SetText( retProp( ( D():Articulos( nView ) )->cCodPrp2, dbfPro ) )
                     oSayPr2:show()
                  end if

                  if oSayVp2 != nil
                      oSayVp2:SetText( "" )
                      oSayVp2:Show()
                  end if

               else

                  if !empty( aGet[ _CVALPR2 ] )
                     aGet[_CVALPR2 ]:hide()
                  end if

                  if !empty( oSayPr2 )
                     oSayPr2:hide()
                  end if

                  if !empty( oSayVp2 )
                     oSayVp2:hide()
                  end if

               end if

            end if 

         end if

         /*
         He terminado de meter todo lo que no son precios ahora es cuando meteré los precios con todas las opciones posibles
         */

         cPrpArt              := aTmp[ _CCODPR1 ] + aTmp[ _CCODPR2 ] + aTmp[ _CVALPR1 ] + aTmp[ _CVALPR2 ]

         if ( lChgCodArt ) .or. ( cPrpArt != cOldPrpArt )

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
            Cargamos el precio-------------------------------------------------
            */

            aTmp[ _NPVPREC ] := (D():Articulos( nView ))->PvpRec

            if !Empty( aGet[ _NPNTVER ] )
               aGet[ _NPNTVER ]:cText( ( D():Articulos( nView ) )->NPNTVER1 )
            else
               aTmp [ _NPNTVER ] :=  ( D():Articulos( nView ) )->NPNTVER1
            end if

            /*
            Cargamos los costos------------------------------------------------
            */

            if !uFieldEmpresa( "lCosAct" )
               nCosPro           := oStock:nCostoMedio( aTmp[ _CREF ], aTmp[ _CALMLIN ], aTmp[ _CCODPR1 ], aTmp[ _CVALPR1 ], aTmp[ _CCODPR2 ], aTmp[ _CVALPR2 ], aTmp[ _CLOTE ] )
               if nCosPro == 0
                  nCosPro        := nCosto( aTmp[ _CREF ], D():Articulos( nView ), dbfKit, .f., , D():Divisas( nView ) )
               end if
            else
               nCosPro           := nCosto( aTmp[ _CREF ], D():Articulos( nView ), dbfKit, .f., , D():Divisas( nView ) )
            end if

            if aGet[ _NCOSDIV ] != nil
               aGet[ _NCOSDIV ]:cText( nCosPro )
            else
               aTmp[ _NCOSDIV ]  := nCosPro
            end if

            // Descuento de artículo----------------------------------------------
         
            nDescuentoArticulo   := nDescuentoArticulo( cCodArt, aTmpPed[ _CCODCLI ], nView )
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

            // Cargamos el codigo de las unidades------------------------------

            if !Empty( aGet[ _CUNIDAD ] )
               aGet[ _CUNIDAD ]:cText( ( D():Articulos( nView ) )->cUnidad )
            else
               aTmp[ _CUNIDAD ]  := ( D():Articulos( nView ) )->cUnidad
            end if

            // Cargamos el precio del artículo---------------------------------

            nPrePro           := nPrePro( aTmp[ _CREF ], aTmp[ _CCODPR1 ], aTmp[ _CVALPR1 ], aTmp[ _CCODPR2 ], aTmp[ _CVALPR2 ], aTmp[ _NTARLIN ], aTmpPed[ _LIVAINC ], dbfArtDiv, dbfTarPreL, aTmpPed[ _CCODTAR ] )
            if nPrePro == 0
               aGet[ _NPREDIV ]:cText( nRetPreArt( aTmp[ _NTARLIN ], aTmpPed[ _CDIVPED ], aTmpPed[ _LIVAINC ], D():Articulos( nView ), D():Divisas( nView ), dbfKit, D():TiposIva( nView ), , , oNewImp ) )
            else
               aGet[ _NPREDIV ]:cText( nPrePro )
            end if

            // Usando tarifas--------------------------------------------------

            if !Empty( aTmpPed[ _CCODTAR ] )

               // Precio-------------------------------------------------------

               nImpOfe     := RetPrcTar( aTmp[ _CREF ], aTmpPed[_CCODTAR], aTmp[_CCODPR1], aTmp[_CCODPR2], aTmp[_CVALPR1], aTmp[_CVALPR2], dbfTarPreL, aTmp[ _NTARLIN ] )
               if nImpOfe  != 0
                  aGet[ _NPREDIV ]:cText( nImpOfe )
               end if

               // Descuento porcentual-----------------------------------------
               
               nImpOfe  := RetPctTar( aTmp[ _CREF ], cCodFam, aTmpPed[_CCODTAR], aTmp[_CCODPR1], aTmp[_CCODPR2], aTmp[_CVALPR1], aTmp[_CVALPR2], dbfTarPreL )
               if nImpOfe  != 0
                  aGet[ _NDTO   ]:cText( nImpOfe )
               end if

               //--Descuento lineal--//
               nImpOfe  := RetLinTar( aTmp[ _CREF ], cCodFam, aTmpPed[_CCODTAR], aTmp[_CCODPR1], aTmp[_CCODPR2], aTmp[_CVALPR1], aTmp[_CVALPR2], dbfTarPreL )
               if nImpOfe != 0
                  aGet[ _NDTODIV ]:cText( nImpOfe )
               end if

               //--Comision de agente--//
               nImpOfe  := RetComTar( aTmp[ _CREF ], cCodFam, aTmpPed[_CCODTAR], aTmp[_CCODPR1], aTmp[_CCODPR2], aTmp[_CVALPR1], aTmp[_CVALPR2], aTmpPed[_CCODAGE], dbfTarPreL, dbfTarPreS )
               if nImpOfe != 0
                  aGet[ _NCOMAGE ]:cText( nImpOfe )
               end if

               //--Descuento de promoci¢n--//

               nImpOfe  := RetDtoPrm( aTmp[ _CREF ], cCodFam, aTmpPed[_CCODTAR], aTmp[_CCODPR1], aTmp[_CCODPR2], aTmp[_CVALPR1], aTmp[_CVALPR2], dFecPed, dbfTarPreL )
               if nImpOfe  != 0
                  aGet[ _NDTOPRM ]:cText( nImpOfe )
               end if

               //--Descuento de promocion para el agente--//

               nDtoAge  := RetDtoAge( aTmp[ _CREF ], cCodFam, aTmpPed[_CCODTAR], aTmp[_CCODPR1], aTmp[_CCODPR2], aTmp[_CVALPR1], aTmp[_CVALPR2], dFecPed, aTmpPed[_CCODAGE], dbfTarPreL, dbfTarPreS )
               if nDtoAge  != 0
                  aGet[ _NCOMAGE ]:cText( nDtoAge )
               end if

            end if

            // Chequeamos las atipicas del cliente--------------------------------

            hAtipica          := hAtipica( hValue( aTmp, aTmpPed ) )

            if !empty( hAtipica )
               
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

            sOfertaArticulo   := structOfertaArticulo( D():getHashArray( aTmpPed, "PedCliT", nView ), D():getHashArray( aTmp, "PedCliL", nView ), nTotLPedCli( aTmp ), nView )

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
         Cargamos los valores para los cambios---------------------------------
         */

         cOldPrpArt := cPrpArt
         cOldCodArt := cCodArt

         /*
         Solo pueden modificar los precios los administradores--------------
         */

         if Empty( aTmp[ _NPREDIV ] ) .or. ( SQLAjustableModel():getRolCambiarPrecios( Auth():rolUuid() ) )

            aGet[ _NPREDIV ]:HardEnable()
            aGet[ _NIMPTRN ]:HardEnable()

            if !Empty( aGet[ _NPNTVER ] )
               aGet[ _NPNTVER ]:HardEnable()
            end if

            aGet[ _NDTO    ]:HardEnable()
            aGet[ _NDTOPRM ]:HardEnable()

            if !Empty( aGet[ _NDTODIV ] )
               aGet[ _NDTODIV ]:HardEnable()
            end if

         else

            aGet[ _NPREDIV ]:HardDisable()
            aGet[ _NIMPTRN ]:HardDisable()

            if !Empty( aGet[ _NPNTVER ] )
               aGet[ _NPNTVER ]:HardEnable()
            end if
            aGet[ _NDTO    ]:HardDisable()
            aGet[ _NDTOPRM ]:HardDisable()

            if !Empty( aGet[ _NDTODIV ] )
               aGet[ _NDTODIV ]:HardEnable()
            end if

         end if

      else

         MsgStop( "Artículo no encontrado" )
         Return .f.

      end if

   end if

RETURN .t.

//--------------------------------------------------------------------------//

Static Function nEstadoIncidencia( cNumPed )

   local nEstado  := 0
   local aBmp     := ""

   if ( dbfPedCliI )->( dbSeek( cNumPed ) )

      while ( dbfPedCliI )->cSerPed + Str( ( dbfPedCliI )->nNumPed ) + ( dbfPedCliI )->cSufPed == cNumPed .and. !( dbfPedCliI )->( Eof() )

         if ( dbfPedCliI )->lListo
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

         ( dbfPedCliI )->( dbSkip() )

      end while

   end if

Return ( nEstado )

//---------------------------------------------------------------------------//

Static Function nEstadoProduccion( cNumPed )

   local nEstado        		:= 1

   if ( D():PedidosClientesLineas( nView ) )->( dbSeek( cNumPed ) )

      while D():PedidosClientesLineasId( nView ) == cNumPed .and. !( D():PedidosClientesLineas( nView ) )->( Eof() )

      	/*
      	Las lineas hijas no pintan nada---------------------------------------
      	*/

   		if !( D():PedidosClientesLineas( nView ) )->lKitChl

	         do case
   	         case ( D():PedidosClientesLineas( nView ) )->nProduc == 0 	// No se ha producido nada

   	         	if nEstado == 3
    	         		nEstado  := 2
    	         		exit 
    	         	end if 

   	         case ( D():PedidosClientesLineas( nView ) )->nProduc == 1 	// Producido parcialmente

    	         	nEstado  	:= 2
    	         	exit 

	            case ( D():PedidosClientesLineas( nView ) )->nProduc == 2 	// Linea producida

   	            nEstado  	:= 3

      	   end case

         end if 

         ( D():PedidosClientesLineas( nView ) )->( dbSkip() )

      end while

   end if

Return ( nEstado )

//---------------------------------------------------------------------------//

Static Function cEstadoProduccion( cNumPed )

Return ( aEstadoProduccion[ Max( Min( nEstadoProduccion( cNumPed ), 3 ), 1 ) ] )

//---------------------------------------------------------------------------//

Static Function cEstadoPedido( nEstado )

Return ( aEstadoPedido[ Max( Min( nEstado, 3 ), 1 ) ] )

//---------------------------------------------------------------------------//

Static Function ChangePedidosWeb()

   /*
   Añadimos desde el fichero de lineas-----------------------------------------
	*/

   ( dbfTmpLin )->( __dbZap() )

   if ( D():PedidosClientesLineas( nView ) )->( dbSeek( ( D():PedidosClientes( nView ) )->cSerPed + Str( ( D():PedidosClientes( nView ) )->nNumPed ) + ( D():PedidosClientes( nView ) )->cSufPed ) )

      while ( D():PedidosClientesLineasId( nView ) == D():PedidosClientesId( nView ) ) .AND. ( D():PedidosClientesLineas( nView ) )->( !eof() )

         dbPass( D():PedidosClientesLineas( nView ), dbfTmpLin, .t. )

         ( D():PedidosClientesLineas( nView ) )->( dbSkip() )

      end while

   end if

   ( dbfTmpLin )->( dbGoTop() )

   /*
   Refrescos en pantalla-------------------------------------------------------
   */

   oBrwDetallesPedidos:GoTop()
   oBrwDetallesPedidos:Refresh( .t. )

return nil

//---------------------------------------------------------------------------//

Static Function StartPedidosWeb( oDlgPedidosWeb )

   local oBoton
   local oGrupo
   local oCarpeta
   local oOfficeBar

   lStopAvisoPedidos()

   oOfficeBar                 := TDotNetBar():New( 0, 0, 1008, 100, oDlgPedidosWeb, 1 )
   oOfficeBar:nHTabs          := 4
   oOfficeBar:lPaintAll       := .f.
   oOfficeBar:lDisenio        := .f.

   oOfficeBar:SetStyle( 1 )

   oDlgPedidosWeb:oTop        := oOfficeBar

   oCarpeta                   := TCarpeta():New( oOfficeBar, "" )

   oGrupo                     := TDotNetGroup():New( oCarpeta, 126, "Lineas", .f. )

   oBoton                     := TDotNetButton():New( 60, oGrupo, "Up32",              "Arriba",         1, {|| oBrwPedidosWeb:GoUp() }, , , .f., .f., .f. )
   oBoton                     := TDotNetButton():New( 60, oGrupo, "Down32",            "Abajo",          2, {|| oBrwPedidosWeb:GoDown() }, , , .f., .f., .f. )

   oGrupo                     := TDotNetGroup():New( oCarpeta, 126, "Acciones", .f. )

   oBoton                     := TDotNetButton():New( 60, oGrupo, "gc_gearwheel_run_32",        "Procesar",       1, {|| oDlgPedidosWeb:End( IDOK ) }, , , .f., .f., .f. )
   oBoton                     := TDotNetButton():New( 60, oGrupo, "gc_garbage_full_32",  "Eliminar",       2, {|| WinDelRec( oBrwPedidosWeb, D():PedidosClientes( nView ), {|| QuiPedCli() } ), ChangePedidosWeb() } , , , .f., .f., .f. )

   oGrupo                     := TDotNetGroup():New( oCarpeta, 66, "Salir", .f. )

   oBoton                     := TDotNetButton():New( 60, oGrupo, "End32",             "Salida",         1, {|| oDlgPedidosWeb:End() }, , , .f., .f., .f. )

   ChangePedidosWeb()

Return ( nil )

//---------------------------------------------------------------------------//

Static Function YearComboBoxChange()

   if ( oWndBrw:oWndBar:cYearComboBox() != __txtAllYearsFilter__ )
      oWndBrw:oWndBar:setYearComboBoxExpression( "Year( Field->dFecPed ) == " + oWndBrw:oWndBar:cYearComboBox() )
   else
      oWndBrw:oWndBar:setYearComboBoxExpression( "" )
   end if 

   oWndBrw:chgFilter()

Return nil

//-------------------------------------------------------------------------//

Static function lChangeCancel( aGet, aTmp, dbfTmpLin )

   if aTmp[ _LCANCEL ]
      aTmp[ _DCANCEL ]  := GetSysDate()
   else
      aTmp[ _DCANCEL ]  := CtoD( "" )
      aTmp[ _CCANCEL ]  := Space( 100 )
   end if

   if !Empty( aGet[ _DCANCEL ] )
      aGet[ _DCANCEL ]:Refresh()
   end if

   if !Empty( aGet[ _CCANCEL ] )
      aGet[ _CCANCEL ]:Refresh()
   end if

return ( .t. )

//---------------------------------------------------------------------------//

Static function lValidCancel( aGet, aTmp, oBrwLin )

   if aTmp[ _LCANCEL ]
      oBrwLin:Hide()
   else
      oBrwLin:Show()
   end if

return ( .t. )

//---------------------------------------------------------------------------//

static function lBuscaOferta( cCodArt, aGet, aTmp, aTmpPed, dbfOferta, dbfDiv, dbfKit, dbfIva  )

   local sOfeArt
   local nTotalLinea    := 0
   local dFecPed 			:= aTmpPed[ _DFECPED ]

   if !Empty( aTmpPed[ _DFECENT ] )
   	dFecPed 				:= aTmpPed[ _DFECENT ]
   end if

   if ( D():Articulos( nView ) )->Codigo == cCodArt .or. ( D():Articulos( nView ) )->( dbSeek( cCodArt ) )

      /*
      Buscamos si existen ofertas por artículo----------------------------
      */

      nTotalLinea := RecalculaLinea( aTmp, aTmpPed, nDouDiv, , , , aTmpPed[ _CDIVPED ], .t. )

      sOfeArt     := sOfertaArticulo( cCodArt, aTmpPed[ _CCODCLI ], aTmpPed[ _CCODGRP ], aTmp[ _NUNICAJA ], dFecPed, dbfOferta, aTmp[ _NTARLIN ], aTmpPed[ _LIVAINC ], aTmp[_CCODPR1], aTmp[_CCODPR2], aTmp[_CVALPR1], aTmp[_CVALPR2], aTmp[ _CDIVPED ], D():Articulos( nView ), D():Divisas( nView ), dbfKit, D():TiposIva( nView ), aTmp[ _NCANPED ], nTotalLinea )

      if !Empty( sOfeArt ) 
         if ( sOfeArt:nPrecio != 0 )
            aGet[ _NPREDIV ]:cText( sOfeArt:nPrecio )
         end if 
         if ( sOfeArt:nDtoPorcentual != 0 )
            aGet[ _NDTO    ]:cText( sOfeArt:nDtoPorcentual )
         end if 
         if ( sOfeArt:nDtoLineal != 0)
            aGet[ _NDTODIV ]:cText( sOfeArt:nDtoLineal )
         end if 
         aTmp[ _LLINOFE  ] := .t.
      end if

      if !aTmp[ _LLINOFE ]

         /*
         Buscamos si existen ofertas por familia----------------------------
         */

         sOfeArt     := sOfertaFamilia( ( D():Articulos( nView ) )->Familia, aTmpPed[ _CCODCLI ], aTmpPed[ _CCODGRP ], dFecPed, dbfOferta, aTmp[ _NTARLIN ], D():Articulos( nView ), aTmp[ _NUNICAJA ], aTmp[ _NCANPED ], nTotalLinea )

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

         sOfeArt     := sOfertaTipoArticulo( ( D():Articulos( nView ) )->cCodTip, aTmpPed[ _CCODCLI ], aTmpPed[ _CCODGRP ], dFecPed, dbfOferta, aTmp[ _NTARLIN ], D():Articulos( nView ), aTmp[ _NUNICAJA ], aTmp[ _NCANPED ], nTotalLinea )

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

         sOfeArt     := sOfertaCategoria( ( D():Articulos( nView ) )->cCodCate, aTmpPed[ _CCODCLI ], aTmpPed[ _CCODGRP ], dFecPed, dbfOferta, aTmp[ _NTARLIN ], D():Articulos( nView ), aTmp[ _NUNICAJA ], aTmp[ _NCANPED ], nTotalLinea )

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

         sOfeArt     := sOfertaTemporada( ( D():Articulos( nView ) )->cCodTemp, aTmpPed[ _CCODCLI ], aTmpPed[ _CCODGRP ], dFecPed, dbfOferta, aTmp[ _NTARLIN ], D():Articulos( nView ), aTmp[ _NUNICAJA ], aTmp[ _NCANPED ], nTotalLinea )

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

         sOfeArt     := sOfertaFabricante( ( D():Articulos( nView ) )->cCodFab, aTmpPed[ _CCODCLI ], aTmpPed[ _CCODGRP ], dFecPed, dbfOferta, aTmp[ _NTARLIN ], D():Articulos( nView ), aTmp[ _NUNICAJA ], aTmp[ _NCANPED ], nTotalLinea )

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

Static Function CargaAtipicasCliente( aTmpPed, oBrwLin, oDlg )

	local nOrder
   local lSearch     := .f.

   /*
   Controlamos que no nos pase código de cliente vacío------------------------
   */

   if Empty( aTmpPed[ _CCODCLI ] )
      MsgStop( "Código de cliente no puede estar vacío para utilizar el asistente." )
      Return .f.
   end if

   /*
   Controlamos que el cliente tenga atipicas----------------------------------
   */

   nOrder            := ( D():Atipicas( nView ) )->( OrdSetFocus( "cCodCli" ) )

   if ( D():Atipicas( nView ) )->( dbSeek( aTmpPed[ _CCODCLI ] ) )

      AutoMeterDialog( oDlg )

      SetTotalAutoMeterDialog( ( D():Atipicas( nView ) )->( LastRec() ) )

      while ( D():Atipicas( nView ) )->cCodCli == aTmpPed[ _CCODCLI ] .and. !( D():Atipicas( nView ) )->( Eof() )

         if lConditionAtipica( nil, D():Atipicas( nView ) ) .and. ( D():Atipicas( nView ) )->lAplPed

            AppendDatosAtipicas( aTmpPed )

         end if

         SetAutoMeterDialog( ( D():Atipicas( nView ) )->( Recno() ) )

         ( D():Atipicas( nView ) )->( dbSkip() )

      end while

      EndAutoMeterDialog( oDlg )

   end if

   /*
   Controlamos el grupo del cliente tenga atipicas----------------------------------
   */

   if !lSearch

      if !Empty( aTmpPed[ _CCODGRP ] )

         ( D():Atipicas( nView ) )->( OrdSetFocus( "cCodGrp" ) )
      
         if ( D():Atipicas( nView ) )->( dbSeek( aTmpPed[ _CCODGRP ] ) )

            AutoMeterDialog( oDlg )

            SetTotalAutoMeterDialog( ( D():Atipicas( nView ) )->( LastRec() ) )
      
            while ( D():Atipicas( nView ) )->cCodGrp == aTmpPed[ _CCODGRP ] .and. !( D():Atipicas( nView ) )->( Eof() )
      
               if lConditionAtipica( nil, D():Atipicas( nView ) ) .and. ( D():Atipicas( nView ) )->lAplAlb
      
                  AppendDatosAtipicas( aTmpPed )
      
               end if

               SetAutoMeterDialog( ( D():Atipicas( nView ) )->( Recno() ) )
      
               ( D():Atipicas( nView ) )->( dbSkip() )
      
            end while

            EndAutoMeterDialog( oDlg )
      
         end if
      
         ( D():Atipicas( nView ) )->( OrdSetFocus( nOrder ) )

      end if

   end if 

   // Recalculamos la factura y refrescamos la pantalla--------------------------

   RecalculaTotal( aTmpPed )

   if !Empty( oBrwLin )
      oBrwLin:GoTop()
      oBrwLin:Refresh()
   end if

Return .t.

//---------------------------------------------------------------------------//

Static Function AppendDatosAtipicas( aTmpPed )

   local nPrecioAtipica
   local hAtipica

   if !dbSeekInOrd( ( D():Atipicas( nView ) )->cCodArt, "cRef", dbfTmpLin )
      
      if ( D():Articulos( nView ) )->( dbSeek( ( D():Atipicas( nView ) )->cCodArt ) ) .and.;
         !( D():Articulos( nView ) )->lObs

         ( dbfTmpLin )->( dbAppend() )

         ( dbfTmpLin )->nNumLin        := nLastNum( dbfTmpLin )
         ( dbfTmpLin )->cRef           := ( D():Atipicas( nView ) )->cCodArt
         ( dbfTmpLin )->cCodPr1        := ( D():Atipicas( nView ) )->cCodPr1
         ( dbfTmpLin )->cCodPr2        := ( D():Atipicas( nView ) )->cCodPr2
         ( dbfTmpLin )->cValPr1        := ( D():Atipicas( nView ) )->cValPr1
         ( dbfTmpLin )->cValPr2        := ( D():Atipicas( nView ) )->cValPr2
         ( dbfTmpLin )->nCosDiv        := ( D():Atipicas( nView ) )->nPrcCom
         ( dbfTmpLin )->cAlmLin        := aTmpPed[ _CCODALM ]
         ( dbfTmpLin )->lIvaLin        := aTmpPed[ _LIVAINC ]
         ( dbfTmpLin )->nTarLin        := oGetTarifa:getTarifa()
         ( dbfTmpLin )->nCanEnt        := 1
         ( dbfTmpLin )->nUniCaja       := 0
         ( dbfTmpLin )->lFromAtp       := .t.
   
         //Datos de la tabla de artículo------------------------------------

         ( dbfTmpLin )->cDetalle       := ( D():Articulos( nView ) )->Nombre
         
         if aTmpPed[ _NREGIVA ] <= 2
            ( dbfTmpLin )->nIva        := nIva( D():TiposIva( nView ), ( D():Articulos( nView ) )->TipoIva )
         end if
           
         ( dbfTmpLin )->cUnidad        := ( D():Articulos( nView ) )->cUnidad
         ( dbfTmpLin )->nCtlStk        := ( D():Articulos( nView ) )->nCtlStock
         ( dbfTmpLin )->lLote          := ( D():Articulos( nView ) )->lLote
         ( dbfTmpLin )->lMsgVta        := ( D():Articulos( nView ) )->lMsgVta
         ( dbfTmpLin )->lNotVta        := ( D():Articulos( nView ) )->lNotVta
         ( dbfTmpLin )->cCodTip        := ( D():Articulos( nView ) )->cCodTip
         ( dbfTmpLin )->cCodFam        := ( D():Articulos( nView ) )->Familia
         ( dbfTmpLin )->nPesoKg        := ( D():Articulos( nView ) )->nPesoKg
   
         ( dbfTmpLin )->dFecUltCom     := dFechaUltimaVenta( aTmpPed[ _CCODCLI ], ( D():Atipicas( nView ) )->cCodArt, dbfAlbCliL, dbfFacCliL )
         ( dbfTmpLin )->nUniUltCom     := nUnidadesUltimaVenta( aTmpPed[ _CCODCLI ], ( D():Atipicas( nView ) )->cCodArt, dbfAlbCliL, dbfFacCliL )
         ( dbfTmpLin )->nPrcUltCom     := nPrecioUltimaVenta( aTmpPed[ _CCODCLI ], ( D():Atipicas( nView ) )->cCodArt, dbfAlbCliL, dbfFacCliL )

         /*
         Vamos a por los catos de la tarifa
         */      

         hAtipica := hAtipica( hValue( dbfTmpLin, aTmpPed ) )

         if !Empty( hAtipica )
               
            if hhaskey( hAtipica, "nImporte" )
               if hAtipica[ "nImporte" ] != 0
                  ( dbfTmpLin )->nPreDiv    := hAtipica[ "nImporte" ]
               else 
                  ( dbfTmpLin )->nPreDiv    := nRetPreArt( ( dbfTmpLin )->nTarLin, aTmpPed[ _CDIVPED ], aTmpPed[ _LIVAINC ], D():Articulos( nView ), D():Divisas( nView ), dbfKit, D():TiposIva( nView ), , , oNewImp )
               end if
            end if

            if hhaskey( hAtipica, "nDescuentoPorcentual" )
               ( dbfTmpLin )->nDto     := hAtipica[ "nDescuentoPorcentual" ]
            end if

            if hhaskey( hAtipica, "nDescuentoPromocional" )
               ( dbfTmpLin )->nDtoPrm  := hAtipica[ "nDescuentoPromocional" ]
            end if

            if hhaskey( hAtipica, "nDescuentoLineal" )
               ( dbfTmpLin )->nDtoDiv  := hAtipica[ "nDescuentoLineal" ]
            end if

            if hhaskey( hAtipica, "nComisionAgente" )
               ( dbfTmpLin )->nComAge  := hAtipica[ "nComisionAgente" ]
            end if

         end if

      end if

   else

      /*
      Buscamos si existen atipicas de clientes------------------------------
      */

      hAtipica := hAtipica( hValue( dbfTmpLin, aTmpPed ) )

      if !Empty( hAtipica )
               
         if hhaskey( hAtipica, "nImporte" )
            if hAtipica[ "nImporte" ] != 0
            	( dbfTmpLin )->nPreDiv  := hAtipica[ "nImporte" ]
            else
            	nRetPreArt( ( dbfTmpLin )->nTarLin, aTmpPed[ _CDIVPED ], aTmpPed[ _LIVAINC ], D():Articulos( nView ), D():Divisas( nView ), dbfKit, D():TiposIva( nView ), , , oNewImp )
            end if
         end if

         if hhaskey( hAtipica, "nDescuentoPorcentual" )
            ( dbfTmpLin )->nDto     := hAtipica[ "nDescuentoPorcentual" ]
         end if

         if hhaskey( hAtipica, "nDescuentoPromocional" )
            ( dbfTmpLin )->nDtoPrm  := hAtipica[ "nDescuentoPromocional" ]
         end if

         if hhaskey( hAtipica, "nDescuentoLineal" )
            ( dbfTmpLin )->nDtoDiv  := hAtipica[ "nDescuentoLineal" ]
         end if

         if hhaskey( hAtipica, "nComisionAgente" )
            ( dbfTmpLin )->nComAge  := hAtipica[ "nComisionAgente" ]
         end if

      end if      

   end if

Return ( nil )

//---------------------------------------------------------------------------//

Static Function ChangeUnidades( oCol, uNewValue, nKey, aTmp, dbfTmpLin )

	/*
	Cambiamos el valor de las unidades de la linea de la factura---------------
	*/

	if IsNum( nKey ) .and. ( nKey != VK_ESCAPE )

      if !IsNil( uNewValue )

      		( dbfTmpLin )->nUnicaja 	:= uNewValue

      		RecalculaTotal( aTmp )

      end if

    end if  

Return .t.

//---------------------------------------------------------------------------//

Static Function SumaUnidadLinea( aTmp )

	/*
	Sumamos una unidad a la linea de la factura--------------------------------
	*/

	( dbfTmpLin )->nUniCaja += 1

    RecalculaTotal( aTmp )  

Return .t.

//---------------------------------------------------------------------------//

Static Function RestaUnidadLinea( aTmp )

	/*
	Restamos una unidad a la linea de la factura-------------------------------
	*/

    ( dbfTmpLin )->nUniCaja -= 1

    RecalculaTotal( aTmp )

Return .t.

//---------------------------------------------------------------------------//

Static Function ChangePrecio( oCol, uNewValue, nKey, aTmp, dbfTmpLin )

	/*
	Cambiamos el valor del precio de la linea de la factura--------------------
	*/

	if IsNum( nKey ) .and. ( nKey != VK_ESCAPE )

      if !IsNil( uNewValue )

      		SetUPedCli( dbfTmpLin, uNewValue )

      		RecalculaTotal( aTmp )

      end if

    end if  

Return .t.

//---------------------------------------------------------------------------//

Static Function hValue( aTmp, aTmpPed )

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
         hValue[ "nCajas"            ] := aTmp[ _NCANPED ]
         hValue[ "nUnidades"         ] := aTmp[ _NUNICAJA ]

      case ValType( aTmp ) == "C"

         hValue[ "cCodigoArticulo"   ] := ( aTmp )->cRef
         hValue[ "cCodigoPropiedad1" ] := ( aTmp )->cCodPr1
         hValue[ "cCodigoPropiedad2" ] := ( aTmp )->cCodPr2
         hValue[ "cValorPropiedad1"  ] := ( aTmp )->cValPr1
         hValue[ "cValorPropiedad2"  ] := ( aTmp )->cValPr2
         hValue[ "cCodigoFamilia"    ] := ( aTmp )->cCodFam
         hValue[ "nTarifaPrecio"     ] := ( aTmp )->nTarLin         
         hValue[ "nCajas"            ] := ( aTmp )->nCanPed
         hValue[ "nUnidades"         ] := ( aTmp )->nUniCaja

   end case      

   do case 
      case ValType( aTmpPed ) == "A"

         hValue[ "cCodigoCliente"    ] := aTmpPed[ _CCODCLI ]
         hValue[ "cCodigoGrupo"      ] := aTmpPed[ _CCODGRP ]
         hValue[ "lIvaIncluido"      ] := aTmpPed[ _LIVAINC ]
         hValue[ "dFecha"            ] := aTmpPed[ _DFECPED ]
         hValue[ "nDescuentoTarifa"  ] := aTmpPed[ _NDTOTARIFA ]

      case ValType( aTmpPed ) == "C"
         
         hValue[ "cCodigoCliente"    ] := ( aTmpPed )->cCodCli
         hValue[ "cCodigoGrupo"      ] := ( aTmpPed )->cCodGrp
         hValue[ "lIvaIncluido"      ] := ( aTmpPed )->lIvaInc
         hValue[ "dFecha"            ] := ( aTmpPed )->dFecPed
         hValue[ "nDescuentoTarifa"  ] := ( aTmpPed )->nDtoTarifa

   end case

   hValue[ "nTipoDocumento"         ] := PED_CLI
   hValue[ "nView"                  ] := nView

Return ( hValue )

//---------------------------------------------------------------------------//

Static Function ImprimirSeriesPedidosClientes( nDevice, lExt )

   local aStatus
   local oPrinter   
   local cFormato 

   DEFAULT nDevice   := IS_PRINTER
   DEFAULT lExt      := .f.

   // Cremaos el dialogo-------------------------------------------------------

   oPrinter          := PrintSeries():New( nView ):SetVentas()

   // Establecemos sus valores-------------------------------------------------

   oPrinter:Serie(      ( D():PedidosClientes( nView ) )->cSerPed )
   oPrinter:Documento(  ( D():PedidosClientes( nView ) )->nNumPed )
   oPrinter:Sufijo(     ( D():PedidosClientes( nView ) )->cSufPed )

   if lExt

      oPrinter:oFechaInicio:cText( ( D():PedidosClientes( nView ) )->dFecPed )
      oPrinter:oFechaFin:cText( ( D():PedidosClientes( nView ) )->dFecPed )

   end if

   oPrinter:oFormatoDocumento:TypeDocumento( "PC" )   

   // Formato de documento-----------------------------------------------------

   cFormato          := cFormatoDocumento( ( D():PedidosClientes( nView ) )->cSerPed, "nPedCli", D():Contadores( nView ) )
   if empty( cFormato )
      cFormato       := cFirstDoc( "PC", D():Documentos( nView ) )
   end if
   oPrinter:oFormatoDocumento:cText( cFormato )

   // Codeblocks para que trabaje----------------------------------------------

   aStatus           := D():GetInitStatus( "PedCliT", nView )

   oPrinter:bInit    := {||   ( D():PedidosClientes( nView ) )->( dbSeek( oPrinter:DocumentoInicio(), .t. ) ) }

   oPrinter:bWhile   := {||   oPrinter:InRangeDocumento( D():PedidosClientesId( nView ) )                  .and. ;
                              ( D():PedidosClientes( nView ) )->( !eof() ) }

   oPrinter:bFor     := {||   oPrinter:InRangeFecha( ( D():PedidosClientes( nView ) )->dFecPed )           .and. ;
                              oPrinter:InRangeCliente( ( D():PedidosClientes( nView ) )->cCodCli )         .and. ;
                              oPrinter:InRangeAgente( ( D():PedidosClientes( nView ) )->cCodAge )         .and. ;
                              oPrinter:InRangeGrupoCliente( retGrpCli( ( D():PedidosClientes( nView ) )->cCodCli, D():Clientes( nView ) ) ) }

   oPrinter:bSkip    := {||   ( D():PedidosClientes( nView ) )->( dbSkip() ) }

   oPrinter:bAction  := {||   GenPedCli(  nDevice,;
                                          "Imprimiendo documento : " + D():PedidosClientesId( nView ),;
                                          oPrinter:oFormatoDocumento:uGetValue,;
                                          oPrinter:oImpresora:uGetValue,;
                                          if( !oPrinter:oCopias:lCopiasPredeterminadas, oPrinter:oCopias:uGetValue, ) ) }

   oPrinter:bStart   := {||   if( lExt, oPrinter:DisableRange(), ) }

   // Abrimos el dialogo-------------------------------------------------------

   oPrinter:Resource():End()

   // Restore -----------------------------------------------------------------

   D():SetStatus( "PedCliT", nView, aStatus )
   
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
Función creada para ejecutar el modo pedidos web desde la web de fondo del rograma
*/

FUNCTION PedCliWeb()

   PedCli( "01056", oWnd(), nil, nil, nil, .t. )

Return .t.

//--------------------------------------------------------------------------//

FUNCTION aTotPedCli( cPedido, cPedCliT, cPedCliL, cIva, cDiv, cFormaPago, cDivRet )

   nTotPedCli( cPedido, cPedCliT, cPedCliL, cIva, cDiv, cFormaPago, nil, cDivRet, .f. )

RETURN ( { nTotNet, nTotIva, nTotReq, nTotPed, nTotPnt, nTotTrn, nTotAge, nTotCos } )

//--------------------------------------------------------------------------//

FUNCTION BrwPedCli( oGet, cPedCliT, cPedCliL, cdbfIva, cdbfDiv, dbfFPago, oIva )

	local oDlg
	local oBrw
	local oGet1
	local cGet1
	local nOrd     := GetBrwOpt( "BrwPedCli" )
	local nOrdAnt
	local nRecAnt
	local oCbxOrd
	local aCbxOrd  := { "Número", "Fecha", "Cliente", "Nombre" }
	local cCbxOrd

   nOrd           := Min( Max( nOrd, 1 ), len( aCbxOrd ) )
   cCbxOrd        := aCbxOrd[ nOrd ]
   nOrdAnt        := ( cPedCliT )->( OrdSetFocus( nOrd ) )
   nRecAnt        := ( cPedCliT )->( Recno() )

   ( cPedCliT )->( dbSetFilter( {|| Field->nEstado <= 2 }, "nEstado <= 2" ) )
   ( cPedCliT )->( dbGoTop() )

   DEFINE DIALOG oDlg RESOURCE "HELPENTRY" TITLE "Pedidos de clientes"

		REDEFINE GET oGet1 VAR cGet1;
         ID       104 ;
         ON CHANGE( AutoSeek( nKey, nFlags, Self, oBrw, cPedCliT, .t., nil, .f. ) );
         VALID    ( OrdClearScope( oBrw, cPedCliT ) );
         BITMAP   "FIND" ;
         OF       oDlg

		REDEFINE COMBOBOX oCbxOrd ;
			VAR 		cCbxOrd ;
			ID 		102 ;
         ITEMS    aCbxOrd ;
         ON CHANGE( ( cPedCliT )->( OrdSetFocus( oCbxOrd:nAt ) ), oBrw:Refresh(), oGet1:SetFocus() ) ;
			OF 		oDlg

      oBrw                 := IXBrowse():New( oDlg )

      oBrw:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrw:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrw:cAlias          := cPedCliT
      oBrw:nMarqueeStyle   := 5
      oBrw:cName           := "Pedido de cliente.Browse"

      oBrw:bLDblClick      := {|| oDlg:end( IDOK ) }

      oBrw:CreateFromResource( 105 )

      with object ( oBrw:AddCol() )
         :cHeader          := "Es.Estado"
         :bStrData         := {|| "" }
         :bEditValue       := {|| ( ( cPedCliT )->nEstado == 1 ) }
         :nWidth           := 20
         :lHide            := .t.
         :SetCheck( { "gc_shape_square_12", "gc_delete_12" } )
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Tipo"
         :bEditValue       := {|| aTipPed[ if( ( cPedCliT )->lAlquiler, 2, 1  ) ] }
         :nWidth           := 50
         :lHide            := .t.
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Número"
         :cSortOrder       := "nNumPed"
         :bEditValue       := {|| ( cPedCliT )->cSerPed + "/" + Alltrim( Str( ( cPedCliT )->nNumPed ) ) + "/" + ( cPedCliT )->cSufPed }
         :nWidth           := 60
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Fecha"
         :cSortOrder       := "dFecPed"
         :bEditValue       := {|| dtoc( ( cPedCliT )->dFecPed ) }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Cliente"
         :cSortOrder       := "cCodCli"
         :bEditValue       := {|| AllTrim( ( cPedCliT )->cCodCli ) }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Nombre"
         :cSortOrder       := "cNomCli"
         :bEditValue       := {|| AllTrim( ( cPedCliT )->cNomCli ) }
         :nWidth           := 200
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Importe"
         :bEditValue       := {|| ( cPedCliT )->nTotPed }
         :cEditPicture     := cPorDiv()
         :nWidth           := 80
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
         ACTION   ( oDlg:end() )

		REDEFINE BUTTON ;
         ID       500 ;
         OF       oDlg ;
         WHEN     .F.

		REDEFINE BUTTON ;
         ID       501 ;
         OF       oDlg ;
         WHEN     .F.

   oDlg:AddFastKey( VK_F5, {|| oDlg:end( IDOK ) } )
   oDlg:AddFastKey( VK_RETURN, {|| oDlg:end( IDOK ) } )

   ACTIVATE DIALOG oDlg ;
   ON INIT ( oBrw:Load() ) ;
   CENTER

   DestroyFastFilter( cPedCliT )

   SetBrwOpt( "BrwPedCli", ( cPedCliT )->( OrdNumber() ) )

   if oDlg:nResult == IDOK
      oGet:cText( ( cPedCliT )->cSerPed + Str( ( cPedCliT )->nNumPed ) + ( cPedCliT )->cSufPed )
      oGet:lValid()
      oIva:Click( ( cPedCliT )->lIvaInc ):Refresh()
   end if

   ( cPedCliT )->( dbClearFilter() )
   ( cPedCliT )->( OrdSetFocus( nOrdAnt ) )
   ( cPedCliT )->( dbGoTo( nRecAnt ) )

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

FUNCTION nImpUPedCli( uPedCliT, cPedCliL, nDec, nVdv, cPouDiv )

   local nCalculo
   local lIvaInc

   DEFAULT nDec      := 0
   DEFAULT nVdv      := 1

   nCalculo          := nTotUPedCli( cPedCliL, nDec, nVdv )

   if IsArray( uPedCliT )

      nCalculo       -= Round( nCalculo * uPedCliT[ _NDTOESP ]  / 100, nDec )
      nCalculo       -= Round( nCalculo * uPedCliT[ _NDPP    ]  / 100, nDec )
      nCalculo       -= Round( nCalculo * uPedCliT[ _NDTOUNO ]  / 100, nDec )
      nCalculo       -= Round( nCalculo * uPedCliT[ _NDTODOS ]  / 100, nDec )

      lIvaInc        := uPedCliT[ _LIVAINC ]

   else
      
      nCalculo       -= Round( nCalculo * ( uPedCliT )->nDtoEsp / 100, nDec )
      nCalculo       -= Round( nCalculo * ( uPedCliT )->nDpp    / 100, nDec )
      nCalculo       -= Round( nCalculo * ( uPedCliT )->nDtoUno / 100, nDec )
      nCalculo       -= Round( nCalculo * ( uPedCliT )->nDtoDos / 100, nDec )
      
      lIvaInc        := ( uPedCliT )->lIvaInc
      
   end if

   if ( cPedCliL )->nIva != 0 .and. !lIvaInc
      nCalculo    	 += Round( nCalculo * ( cPedCliL )->nIva / 100, nDec )
   end if

RETURN ( if( cPouDiv != NIL, Trans( nCalculo, cPouDiv ), nCalculo ) )

//---------------------------------------------------------------------------//

FUNCTION nBrtLPedCli( uPedCliT, uTmpLin, nDec, nRec, nVdv, cPorDiv )

   local nCalculo    := 0

   DEFAULT nDec      := 2
   DEFAULT nVdv      := 1

   nCalculo          := nImpUPedCli( uPedCliT, uTmpLin, nDec, nVdv, cPorDiv )
   nCalculo          *= nTotNPedCli( uTmpLin )

   nCalculo          := Round( nCalculo / nVdv, nRec )

Return ( if( cPorDiv != nil, Trans( nCalculo, cPorDiv ), nCalculo ) )

//---------------------------------------------------------------------------//

FUNCTION nIvaUPedCli( dbfTmpLin, nDec, nVdv )

   local nCalculo

   DEFAULT nDec   := 0
   DEFAULT nVdv   := 1

   nCalculo       := nTotUPedCli( dbfTmpLin, nDec, nVdv )
   nCalculo       := nCalculo * ( dbfTmpLin )->nIva / 100

   if nVdv != 0
      nCalculo    := nCalculo / nVdv
   end if

RETURN ( Round( nCalculo, nDec ) )

//---------------------------------------------------------------------------//

FUNCTION cDesPedCli( cPedCliL )

   DEFAULT cPedCliL  := D():PedidosClientesLineas( nView )

RETURN ( Descrip( cPedCliL ) )

//---------------------------------------------------------------------------//

FUNCTION cDesPedCliLeng( cPedCliL, cArtLeng )

   DEFAULT cPedCliL  := D():PedidosClientesLineas( nView )
   DEFAULT cArtLeng  := D():ArticuloLenguaje( nView )

RETURN ( DescripLeng( cPedCliL, , cArtLeng ) )

//---------------------------------------------------------------------------//

FUNCTION nIvaLPedCli( dbfLin, nDec, nRouDec, nVdv, lDto, lPntVer, lImpTrn, cPouDiv )

   local nCalculo    := 0

   if ( dbfLin )->nRegIva <= 1

      nCalculo          := nTotLPedCli( dbfLin, nDec, nRouDec, nVdv, lDto, lPntVer, lImpTrn, cPouDiv )

      if !( dbfLin )->lIvaLin
         nCalculo       := nCalculo * ( dbfLin )->nIva / 100
      else
         nCalculo       -= nCalculo / ( 1 + ( dbfLin )->nIva / 100 )
      end if

   end if

RETURN ( if( cPouDiv != NIL, Trans( nCalculo, cPouDiv ), nCalculo ) )

//---------------------------------------------------------------------------//

FUNCTION Pre2Ped( cNumPre )

   local cNumPed

   USE ( cPatEmp() + "PedCliT.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PedCliT", @dbfPedCliT ) )
   SET ADSINDEX TO ( cPatEmp() + "PEDCLIT.CDX" ) ADDITIVE

   ( dbfPedCliT )->( OrdSetFocus( 6 ) )

   if ( dbfPedCliT )->( dbSeek( cNumPre ) )
      cNumPed 	:= ( dbfPedCliT )->cSerPed + Str( ( dbfPedCliT )->nNumPed ) + ( dbfPedCliT )->cSufPed
   end if

   if !Empty( cNumPed )
      EdtPedCli( cNumPed )
   else
      msgStop( "No hay pedido asociado" )
   end if

   CLOSE( dbfPedCliT )

RETURN NIL

//----------------------------------------------------------------------------//

STATIC FUNCTION cPreCli( aTmp, aGet, oBrw, nMode )

   local lValid   := .f.
   local cNumPre  := aGet[ _CNUMPRE ]:varGet()

   if nMode != APPD_MODE .or. Empty( cNumPre )
      return .t.
   end if

   IF ( dbfPreCLiT )->( dbSeek( cNumPre ) )

      IF ( dbfPreCLiT )->lEstado

         MsgStop( "Pesupuesto ya en pedidos" )
         lValid   := .f.

		ELSE

         aGet[_CNUMPRE]:bWhen := {|| .F. }

         aGet[_CCODCLI]:cText( ( dbfPreCLiT )->CCODCLI )
			aGet[_CCODCLI]:bWhen	:= {|| .F. }

         aGet[_CNOMCLI]:cText( ( dbfPreCLiT )->CNOMCLI )
         aGet[_CDIRCLI]:cText( ( dbfPreCLiT )->CDIRCLI )
         aGet[_CPOBCLI]:cText( ( dbfPreCLiT )->CPOBCLI )
         aGet[_CPRVCLI]:cText( ( dbfPreCLiT )->CPRVCLI )
         aGet[_CPOSCLI]:cText( ( dbfPreCLiT )->CPOSCLI )
         aGet[_CDNICLI]:cText( ( dbfPreCLiT )->CDNICLI )
         aGet[_CTLFCLI]:cText( ( dbfPreCLiT )->CTLFCLI )

         aGet[_CCODCAJ]:cText( ( dbfPreCLiT )->cCodCaj )
         aGet[_CCODCAJ]:lValid()

         aGet[_CCODALM]:cText( ( dbfPreCLiT )->CCODALM )
			aGet[_CCODALM]:lValid()

         aGet[_CCODPGO]:cText( ( dbfPreCLiT )->CCODPGO )
         aGet[_CCODPGO]:lValid()

         aGet[_CCODAGE]:cText( ( dbfPreCLiT )->CCODAGE )
			aGet[_CCODAGE]:lValid()

         aGet[_NPCTCOMAGE]:cText( ( dbfPreCliT )->nPctComAge )

         aGet[_CCODTAR]:cText( ( dbfPreCLiT)->CCODTAR )
			aGet[_CCODTAR]:lValid()

         aGet[_CCODOBR]:cText( ( dbfPreCLiT)->CCODOBR )
			aGet[_CCODOBR]:lValid()

         aGet[_LRECARGO]:Click( ( dbfPreCLiT )->lRecargo ):Refresh()
         aGet[_LOPERPV ]:Click( ( dbfPreCLiT )->lOperPv ):Refresh()
         aGet[_LIVAINC ]:Click( ( dbfPreCliT )->lIvaInc ):Refresh()

         aTmp[ _UUID_TRN ] := ( dbfPreCliT )->Uuid_Trn

         /*
         Pasamos los comentarios-----------------------------------------------
         */

         aGet[_CRETMAT]:cText( ( dbfPreCLiT )->cRetMat )
         aGet[_CCONDENT]:cText( ( dbfPreCliT )->cCondEnt )
         aGet[_MCOMENT]:cText( ( dbfPreCLiT )->mComEnt )
         aGet[_MOBSERV]:cText( ( dbfPreCLiT )->mObserv )

			/*
         Pasamos todos los Descuentos------------------------------------------
			*/

         aGet[ _CDTOESP ]:cText( ( dbfPreCLiT )->cDtoEsp )
         aGet[ _CDPP    ]:cText( ( dbfPreCLiT )->cDpp    )
         aGet[ _NDTOESP ]:cText( ( dbfPreCLiT )->nDtoEsp )
         aGet[ _NDPP    ]:cText( ( dbfPreCLiT )->nDpp    )
         aGet[ _CDTOUNO ]:cText( ( dbfPreCLiT )->cDtoUno )
         aGet[ _NDTOUNO ]:cText( ( dbfPreCLiT )->nDtoUno )
         aGet[ _CDTODOS ]:cText( ( dbfPreCLiT )->cDtoDos )
         aGet[ _NDTODOS ]:cText( ( dbfPreCLiT )->nDtoDos )
         aGet[ _CMANOBR ]:cText( ( dbfPreCLiT )->cManObr )
         aGet[ _NIVAMAN ]:cText( ( dbfPreCLiT )->nIvaMan )
         aGet[ _NMANOBR ]:cText( ( dbfPreCLiT )->nManObr )
         aGet[ _NBULTOS ]:cText( ( dbfPreCliT )->nBultos )

         /*
         Código de grupo-------------------------------------------------------
         */

         aTmp[ _CCODGRP ]     := ( dbfPreCliT )->cCodGrp
         aTmp[ _LMODCLI ]     := ( dbfPreCliT )->lModCli
         aTmp[ _LOPERPV ]     := ( dbfPreCliT )->lOperPv

         /*
         Datos de alquileres---------------------------------------------------
         */

         aTmp[ _LALQUILER ]   := ( dbfPreCliT )->lAlquiler
         aTmp[ _DFECENTR  ]   := ( dbfPreCliT )->dFecEntr
         aTmp[ _DFECSAL   ]   := ( dbfPreCliT )->dFecSal

			/*
			Cambiamos el estado del Pedido
			*/

         if dbLock( dbfPreCLiT )
            ( dbfPreCLiT )->lEstado := .t.
            ( dbfPreCLiT )->( dbUnLock() )
         end if

         if ( dbfPreCLiL )->( dbSeek( cNumPre ) )

            while ( ( dbfPreCLiL )->cSerPre + Str( ( dbfPreCLiL )->nNumPre ) + ( dbfPreCLiL )->cSufPre == cNumPre )

               (dbfTmpLin)->( dbAppend() )

               (dbfTmpLin)->nNumPed    := 0
               (dbfTmpLin)->nNumLin    := (dbfPreCLiL)->nNumLin
               (dbfTmpLin)->nPosPrint  := (dbfPreCLiL)->nPosPrint
               (dbfTmpLin)->cRef       := (dbfPreCliL)->cRef
               (dbfTmpLin)->cDetalle   := (dbfPreCLiL)->cDetalle
               (dbfTmpLin)->mLngDes    := (dbfPreCLiL)->mLngDes
               (dbfTmpLin)->mNumSer    := (dbfPreCLiL)->mNumSer
               (dbfTmpLin)->nPreDiv    := (dbfPreCLiL)->nPreDiv
               (dbfTmpLin)->nPntVer    := (dbfPreCLiL)->nPntVer
               (dbfTmpLin)->nImpTrn    := (dbfPreCLiL)->nImpTrn
               (dbfTmpLin)->nCanPed    := (dbfPreCLiL)->nCanPre
               (dbfTmpLin)->nUniCaja   := (dbfPreCLiL)->nUniCaja
               (dbfTmpLin)->nUndKit    := (dbfPreCLiL)->nUndKit
               (dbfTmpLin)->nPesOkg    := (dbfPreCLiL)->nPesOkg
               (dbfTmpLin)->cPesoKg    := (dbfPreCLiL)->cPesoKg
               (dbfTmpLin)->cUnidad    := (dbfPreCLiL)->cUnidad
               (dbfTmpLin)->nVolumen   := (dbfPreCLiL)->nVolumen
               (dbfTmpLin)->cVolumen   := (dbfPreCLiL)->cVolumen
               (dbfTmpLin)->nCanEnt    := (dbfPreCLiL)->nCanEnt
               (dbfTmpLin)->nIva       := (dbfpreclil)->nIva
               (dbfTmpLin)->nReq       := (dbfpreclil)->nReq
               (dbfTmpLin)->cUniDad    := (dbfPreCLiL)->cUniDad
               (dbfTmpLin)->nDto       := (dbfPreCliL)->nDto
               (dbfTmpLin)->nDtoPrm    := (dbfPreCLiL)->nDtoPrm
               (dbfTmpLin)->nComAge    := (dbfPreCLiL)->nComAge
               (dbfTmpLin)->lTotLin    := (dbfPreCLiL)->lTotLin
               (dbfTmpLin)->nDtoDiv    := (dbfPreCLiL)->nDtoDiv
               (dbfTmpLin)->nCtlStk    := (dbfPreCLiL)->nCtlStk
               (dbfTmpLin)->dFecHa     := (dbfPreCLiL)->dFecHa
               (dbfTmpLin)->cAlmLin    := (dbfPreCLiL)->cAlmLin
               (dbfTmpLin)->nValImp    := (dbfPreCLiL)->nValImp
               (dbfTmpLin)->cCodImp    := (dbfPreCLiL)->cCodImp
               (dbfTmpLin)->lIvaLin    := (dbfPreCLiL)->lIvaLin
               (dbfTmpLin)->cCodPr1    := (dbfPreCliL)->cCodPr1
               (dbfTmpLin)->cCodPr2    := (dbfPreCliL)->cCodPr2
               (dbfTmpLin)->cValPr1    := (dbfPreCliL)->cValPr1
               (dbfTmpLin)->cValPr2    := (dbfPreCliL)->cValPr2
               (dbfTmpLin)->nCosDiv    := (dbfPreCliL)->nCosDiv
               (dbfTmpLin)->lLote      := (dbfPreclil)->llote
               (dbfTmpLin)->nLote      := (dbfPreclil)->nlote
               (dbfTmpLin)->cLote      := (dbfPreclil)->clote
               (dbfTmpLin)->lKitArt    := (dbfPreCliL)->lKitArt
               (dbfTmpLin)->lKitChl    := (dbfPreCliL)->lKitChl
               (dbfTmpLin)->lKitPrc    := (dbfPreCliL)->lKitPrc
               (dbfTmpLin)->lMsgVta    := (dbfPreCliL)->lMsgVta
               (dbfTmpLin)->lNotVta    := (dbfPreCliL)->lNotVta
               (dbfTmpLin)->lImpLin    := (dbfPreCliL)->lImpLin
               (dbfTmpLin)->cCodTip    := (dbfPreCliL)->cCodTip
               (dbfTmpLin)->mObsLin    := (dbfPreCliL)->mObsLin
               (dbfTmpLin)->Descrip    := (dbfPreCliL)->Descrip
               (dbfTmpLin)->cCodPrv    := (dbfPreCliL)->cCodPrv
               (dbfTmpLin)->cImagen    := (dbfPreCliL)->cImagen
               (dbfTmpLin)->cCodFam    := (dbfPreCliL)->cCodFam
               (dbfTmpLin)->cGrpFam    := (dbfPreCliL)->cGrpFam
               (dbfTmpLin)->cRefPrv    := (dbfPreCliL)->cRefPrv
               (dbfTmpLin)->dFecEnt    := (dbfPreCliL)->dFecEnt
               (dbfTmpLin)->dFecSal    := (dbfPreCliL)->dFecSal
               (dbfTmpLin)->nPreAlq    := (dbfPreCliL)->nPreAlq
               (dbfTmpLin)->lAlquiler  := (dbfPreCliL)->lAlquiler
               (dbfTmpLin)->cUnidad    := (dbfPreCliL)->cUnidad
               (dbfTmpLin)->nNumMed    := (dbfPreCliL)->nNumMed
               (dbfTmpLin)->nMedUno    := (dbfPreCliL)->nMedUno
               (dbfTmpLin)->nMedDos    := (dbfPreCliL)->nMedDos
               (dbfTmpLin)->nMedTre    := (dbfPreCliL)->nMedTre
               (dbfTmpLin)->nPuntos    := (dbfPreCliL)->nPuntos
               (dbfTmpLin)->nValPnt    := (dbfPreCliL)->nValPnt
               (dbfTmpLin)->nDtoPnt    := (dbfPreCliL)->nDtoPnt
               (dbfTmpLin)->nIncPnt    := (dbfPreCliL)->nIncPnt
               (dbfTmpLin)->lLinOfe    := (dbfPreCliL)->lLinOfe
               (dbfTmpLin)->nBultos 	:= (dbfPreCliL)->nBultos
               (dbfTmpLin)->cFormato 	:= (dbfPreCliL)->cFormato
               (dbfTmpLin)->cObrLin    := (dbfPreCliL)->cObrLin
               (dbfTmpLin)->cRefAux    := (dbfPreCliL)->cRefAux
               (dbfTmpLin)->cRefAux2   := (dbfPreCliL)->cRefAux2
               (dbfTmpLin)->cCtrCoste  := (dbfPreCliL)->cCtrCoste
               (dbfTmpLin)->cTipCtr    := (dbfPreCliL)->cTipCtr
               (dbfTmpLin)->cTerCtr    := (dbfPreCliL)->cTerCtr

               (dbfPreCliL)->( dbSkip() )

            end while

            ( dbfTmpLin )->( dbGoTop() )

            /*
            Pasamos las incidencias del presupuesto
            */

            if ( dbfPreCliI )->( dbSeek( cNumPre ) )

               while ( dbfPreCliI )->cSerPre + Str( ( dbfPreCliI )->nNumPre ) + ( dbfPreCliI )->cSufPre == cNumPre .and. !( dbfPreCliI )->( Eof() )
                  dbPass( dbfPreCliI, dbfTmpInc, .t. )
                  ( dbfPreCliI )->( dbSkip() )
               end while

            end if

            ( dbfPreCliI )->( dbGoTop() )

            /*Pasamos los documentos del presupuesto*/

            if ( dbfPreCliD )->( dbSeek( cNumPre ) )

               while ( dbfPreCliD )->cSerPre + Str( ( dbfPreCliD )->nNumPre ) + ( dbfPreCliD )->cSufPre == cNumPre .and. !( dbfPreCliD )->( Eof() )
                  dbPass( dbfPreCliD, dbfTmpDoc, .t. )
                  ( dbfPreCliD )->( dbSkip() )
               end while

            end if

            ( dbfPreCliD )->( dbGoTop() )

            oBrw:Refresh()
            oBrw:SetFocus()

         end if

         lValid   := .T.

      end if

   else

      msgStop( "Presupuesto no existe" )

   end if

   RecalculaTotal( aTmp )

RETURN lValid

//----------------------------------------------------------------------------//

FUNCTION EdmPedCli( cCodRut, cPathTo, oStru, aSucces )

   local cLine
   local cFilEdm
   local oFilEdm
   local dFecPed
   local cCodCli
   local nNumPed

   DEFAULT cCodRut   := "001"
   DEFAULT cPathTo   := "C:\INTERS~1\"

   cCodRut           := SubStr( cCodRut, -3 )

   cFilEdm           := cPathTo + "PEDID" + cCodRut + ".PSI"

   /*
   Creamos el fichero destino
   */

   if !file( cFilEdm )
      msgWait( "No existe el fichero " + cFilEdm, "Atención", 1 )
      return nil
   end if

   oFilEdm           := TTxtFile():New( cFilEdm )

   /*
   Abrimos las bases de datos
   */

   OpenFiles()

   oStru:oMetDos:cText   := "Ped. Clientes"
   oStru:oMetDos:SetTotal( oFilEdm:nTLines )

   /*
   Cabecera del pedido
   */

   cLine    := oFilEdm:cLine

   /*
   Mientras no estemos en el final del archivo
   */

   while ! oFilEdm:lEoF()

      /*
      Tomamos el codigo del cliente
      */

      dFecPed  := Ctod( SubStr( cLine,  1, 10 ) )
      cCodCli  := SubStr( cLine, 11,  7 )

      if ( D():Clientes( nView ) )->( dbSeek( cCodCli ) )

         nNumPed                    := nNewDoc( ( D():Clientes( nView ) )->Serie, D():PedidosClientes( nView ), "NPEDCLI", , D():Contadores( nView ) )
         ( D():PedidosClientes( nView ) )->( dbAppend() )
         ( D():PedidosClientes( nView ) )->cSerPed    := ( D():Clientes( nView ) )->Serie
         ( D():PedidosClientes( nView ) )->cSufPed    := RetSufEmp()
         ( D():PedidosClientes( nView ) )->nNumPed    := nNumPed
         ( D():PedidosClientes( nView ) )->dFecPed    := dFecPed
         ( D():PedidosClientes( nView ) )->cCodAlm    := Application():codigoAlmacen()
         ( D():PedidosClientes( nView ) )->cDivPed    := cDivEmp()
         ( D():PedidosClientes( nView ) )->nVdvPed    := nChgDiv( ( D():PedidosClientes( nView ) )->cDivPed, D():Divisas( nView ) )
         ( D():PedidosClientes( nView ) )->nEstado    := 1
         ( D():PedidosClientes( nView ) )->cCodCli    := ( D():Clientes( nView ) )->Cod
         ( D():PedidosClientes( nView ) )->cNomCli    := ( D():Clientes( nView ) )->Titulo
         ( D():PedidosClientes( nView ) )->cDirCli    := ( D():Clientes( nView ) )->Domicilio
         ( D():PedidosClientes( nView ) )->cPobCli    := ( D():Clientes( nView ) )->Poblacion
         ( D():PedidosClientes( nView ) )->cPrvCli    := ( D():Clientes( nView ) )->Provincia
         ( D():PedidosClientes( nView ) )->cPosCli    := ( D():Clientes( nView ) )->CodPostal
         ( D():PedidosClientes( nView ) )->cDniCli    := ( D():Clientes( nView ) )->Nif
         ( D():PedidosClientes( nView ) )->cCodTar    := ( D():Clientes( nView ) )->cCodTar
         ( D():PedidosClientes( nView ) )->cCodPgo    := ( D():Clientes( nView ) )->CodPago
         ( D():PedidosClientes( nView ) )->cCodAge    := ( D():Clientes( nView ) )->cAgente
         ( D():PedidosClientes( nView ) )->cCodRut    := ( D():Clientes( nView ) )->cCodRut
         ( D():PedidosClientes( nView ) )->nTarifa    := ( D():Clientes( nView ) )->nTarifa
         ( D():PedidosClientes( nView ) )->lRecargo   := ( D():Clientes( nView ) )->lReq
         ( D():PedidosClientes( nView ) )->lOperPv    := ( D():Clientes( nView ) )->lPntVer
         ( D():PedidosClientes( nView ) )->cDtoEsp    := ( D():Clientes( nView ) )->cDtoEsp
         ( D():PedidosClientes( nView ) )->cDpp       := ( D():Clientes( nView ) )->cDpp
         ( D():PedidosClientes( nView ) )->nDtoEsp    := ( D():Clientes( nView ) )->nDtoEsp
         ( D():PedidosClientes( nView ) )->nDpp       := ( D():Clientes( nView ) )->nDpp
         ( D():PedidosClientes( nView ) )->nDtoCnt    := ( D():Clientes( nView ) )->nDtoCnt
         ( D():PedidosClientes( nView ) )->nDtoRap    := ( D():Clientes( nView ) )->nDtoRap
         ( D():PedidosClientes( nView ) )->nDtoUno    := ( D():Clientes( nView ) )->nDtoCnt
         ( D():PedidosClientes( nView ) )->nDtoDos    := ( D():Clientes( nView ) )->nDtoRap

         aAdd( aSucces, { .f., "Nuevo pedido de clientes " + ( D():PedidosClientes( nView ) )->cSerPed + "/" + Str( ( D():PedidosClientes( nView ) )->nNumPed ) + "/" + ( D():PedidosClientes( nView ) )->cSufPed } )

      end if

      /*
      Mientras estemos en el mismo pedido
      */

      while dFecPed  == Ctod( SubStr( cLine, 1, 10 ) )      .and.;
            cCodCli  == SubStr( cLine, 11,  7 )             .and.;
            ! oFilEdm:lEoF()

         /*
         Capturamos las lineas de detalle
         */

         ( D():PedidosClientesLineas( nView ) )->( dbAppend() )
         ( D():PedidosClientesLineas( nView ) )->cSerPed := ( D():PedidosClientes( nView ) )->cSerPed
         ( D():PedidosClientesLineas( nView ) )->nNumPed := ( D():PedidosClientes( nView ) )->nNumPed
         ( D():PedidosClientesLineas( nView ) )->cSufPed := ( D():PedidosClientes( nView ) )->cSufPed
         ( D():PedidosClientesLineas( nView ) )->cRef    := Ltrim( SubStr( cLine, 18, 13 ) )
         ( D():PedidosClientesLineas( nView ) )->cDetalle:= RetFld( ( D():PedidosClientesLineas( nView ) )->cRef, D():Articulos( nView ) )
         ( D():PedidosClientesLineas( nView ) )->nPreDiv := Val( SubStr( cLine, 31,  7 ) )
         ( D():PedidosClientesLineas( nView ) )->nDtoDiv := Val( SubStr( cLine, 38,  4 ) )
         ( D():PedidosClientesLineas( nView ) )->nDto    := Val( SubStr( cLine, 42,  5 ) )
         ( D():PedidosClientesLineas( nView ) )->nCanPed := Val( SubStr( cLine, 47,  4 ) )
         ( D():PedidosClientesLineas( nView ) )->nUniCaja:= Val( SubStr( cLine, 51,  7 ) )

         oFilEdm:Skip()

         oStru:oMetDos:SetTotal( oFilEdm:nLine )

         /*
         Prelectura de la siguiente linea
         */

         cLine    := oFilEdm:cLine

      end do

   end do

   CloseFiles()

   oFilEdm:Close()

RETURN ( aSucces )

//---------------------------------------------------------------------------//

FUNCTION nDtoAtpPedCli( uPedCliT, cPedCliL, nDec, nRou, nVdv, lPntVer, lImpTrn )

   local nCalculo
   local nDtoAtp     := 0

   DEFAULT nDec      := 0
   DEFAULT nRou      := 0
   DEFAULT nVdv      := 1
   DEFAULT lPntVer   := .f.
   DEFAULT lImpTrn   := .f.

   nCalculo          := nTotLPedCli( cPedCliL, nDec, nRou, nVdv, .t., lImpTrn, lPntVer )

   if ( uPedCliT )->nSbrAtp <= 1 .and. ( uPedCliT )->nDtoAtp != 0
      nDtoAtp     += Round( nCalculo * ( uPedCliT )->nDtoAtp / 100, nRou )
   end if

   nCalculo       -= Round( nCalculo * ( uPedCliT )->nDtoEsp / 100, nRou )

   if ( uPedCliT )->nSbrAtp == 2 .and. ( uPedCliT )->nDtoAtp != 0
      nDtoAtp     += Round( nCalculo * ( uPedCliT )->nDtoAtp / 100, nRou )
   end if

   nCalculo       -= Round( nCalculo * ( uPedCliT )->nDpp    / 100, nRou )

   if ( uPedCliT )->nSbrAtp == 3 .and. ( uPedCliT )->nDtoAtp != 0
      nDtoAtp     += Round( nCalculo * ( uPedCliT )->nDtoAtp / 100, nRou )
   end if

   nCalculo       -= Round( nCalculo * ( uPedCliT )->nDtoUno / 100, nRou )

   if ( uPedCliT )->nSbrAtp == 4 .and. ( uPedCliT )->nDtoAtp != 0
      nDtoAtp     += Round( nCalculo * ( uPedCliT )->nDtoAtp / 100, nRou )
   end if

   nCalculo       -= Round( nCalculo * ( uPedCliT )->nDtoDos / 100, nRou )

   if ( uPedCliT )->nSbrAtp == 5 .and. ( uPedCliT )->nDtoAtp != 0
      nDtoAtp     += Round( nCalculo * ( uPedCliT )->nDtoAtp / 100, nRou )
   end if

RETURN ( nDtoAtp )

//----------------------------------------------------------------------------//

//
// Esta funcion devuelve el numero de unidades pendiente de recibir de la reserva
//

function nTotPdtRec( cPedido, cRef, cValPr1, cValPr2, dbfPedCliR )

   local nRec           
   local bWhile
   local nTotRes        := 0

   DEFAULT dbfPedCliR   := D():PedidosClientesReservas( nView )

   nRec                 := ( dbfPedCliR )->( recno() )

   if cPedido == nil
      bWhile            := {|| !( dbfPedCliR )->( eof() ) }
      ( dbfPedCliR )->( dbgotop() )
   else
      bWhile            := {|| cPedido + ( dbfPedCliR )->cRef + ( dbfPedCliR )->cValPr1 + ( dbfPedCliR )->cValPr2 == cPedido + cRef + cValPr1 + cValPr2 .and. !( dbfPedCliR )->( eof() ) }
      ( dbfPedCliR )->( dbseek( cPedido + cRef + cValPr1 + cValPr2 ) )
   end if

   while Eval( bWhile )

      nTotRes           += nTotNResCli( dbfPedCliR )

      ( dbfPedCliR )->( dbskip() )

   end while

   ( dbfPedCliR )->( dbgoto( nRec ) )

return ( nTotRes )

//---------------------------------------------------------------------------//

function dFecPdtRec( cPedido, cRef, cValPr1, cValPr2, dbfPedCliR )

   local nRec           
   local dFecAct        := ctod( "" )

   DEFAULT cPedido      := ( D():PedidosClientesLineas( nView ) )->cSerPed + str( ( D():PedidosClientesLineas( nView ) )->nNumPed ) + ( D():PedidosClientesLineas( nView ) )->cSufPed 
   DEFAULT cRef         := ( D():PedidosClientesLineas( nView ) )->cRef
   DEFAULT cValPr1      := ( D():PedidosClientesLineas( nView ) )->cValPr1
   DEFAULT cValPr2      := ( D():PedidosClientesLineas( nView ) )->cValPr2
   DEFAULT dbfPedCliR   := D():PedidosClientesReservas( nView )

   nRec                 := ( dbfPedCliR )->( recno() )

   if ( dbfPedCliR )->( dbseek( cPedido + cRef + cValPr1 + cValPr2 ) )

      while ( dbfPedCliR )->cSerPed + Str( ( dbfPedCliR )->nNumPed ) + ( dbfPedCliR )->cSufPed == cPedido .and. !( dbfPedCliR )->( eof() )

         if empty( dFecAct ) .or. dFecAct > ( dbfPedCliR )->dFecRes
            dFecAct     := ( dbfPedCliR )->dFecRes
         end if

         ( dbfPedCliR )->( dbskip() )

      end while

   end if

   ( dbfPedCliR )->( dbgoto( nRec ) )

return ( dFecAct )

//-----------------------------------------------------------------------------//
//
// Devuelve el numero de unidades recibidas en albaranes a clientes
//

Function nUnidadesRecibidasAlbaranesClientes( cNumPed, cCodArt, cValPr1, cValPr2, cAlbCliL )

   local aStatus     
   local nUnidadades    := 0

   DEFAULT cNumPed      := ( D():PedidosClientesLineas( nView ) )->cSerPed + str( ( D():PedidosClientesLineas( nView ) )->nNumPed ) + ( D():PedidosClientesLineas( nView ) )->cSufPed 
   DEFAULT cCodArt      := ( D():PedidosClientesLineas( nView ) )->cRef
   DEFAULT cValPr1      := ( D():PedidosClientesLineas( nView ) )->cValPr1
   DEFAULT cValPr2      := ( D():PedidosClientesLineas( nView ) )->cValPr2
   DEFAULT cAlbCliL     := D():AlbaranesClientesLineas( nView )

   aStatus              := aGetStatus( cAlbCliL, .f. )

   ( cAlbCliL )->( ordsetfocus( "cNumPedRef" ) )
   if ( cAlbCliL )->( dbseek( cNumPed + cCodArt + cValPr1 + cValPr2 ) )
      
      while ( cAlbCliL )->cNumPed + ( cAlbCliL )->cRef + ( cAlbCliL )->cValPr1 + ( cAlbCliL )->cValPr2 == cNumPed + cCodArt + cValPr1 + cValPr2 .and. !( cAlbCliL )->( eof() )
         
         nUnidadades    += nTotNAlbCli( cAlbCliL )
         
         ( cAlbCliL )->( dbskip() )

      end while

   end if

   SetStatus( cAlbCliL, aStatus )

Return ( nUnidadades )

//---------------------------------------------------------------------------//

Function dTmpPdtRec( cRef, cValPr1, cValPr2, dbfPedCliR )

   local nRec     
   local dFecAct        := Ctod( "" )

   DEFAULT dbfPedCliR   := D():PedidosClientesReservas( nView )

   nRec                 := ( dbfPedCliR )->( Recno() )

   ( dbfPedCliR )->( dbgotop() )
   while !( dbfPedCliR )->( eof() )

      if ( dbfPedCliR )->cRef == cRef .and. ( dbfPedCliR )->cValPr1 == cValPr1 .and. ( dbfPedCliR )->cValPr2 == cValPr2

         if Empty( dFecAct ) .or. dFecAct > ( dbfPedCliR )->dFecRes
            dFecAct     := ( dbfPedCliR )->dFecRes
         end if

      end if

      ( dbfPedCliR )->( dbskip() )

   end while

   ( dbfPedCliR )->( dbgoto( nRec ) )

Return ( dFecAct )

//-----------------------------------------------------------------------------//

Function dFecPedCli( cPedCli, cPedCliT )

   local dFecPed  := CtoD("")

   IF ( cPedCliT )->( dbSeek( cPedCli ) )
      dFecPed  := ( cPedCliT )->dFecPed
   END IF

Return ( dFecPed )

//---------------------------------------------------------------------------//

FUNCTION cNbrPedCli( cPedCli, cPedCliT )

   local cNomCli  := ""

   IF ( cPedCliT )->( dbSeek( cPedCli ) )
      cNomCli  := ( cPedCliT )->CNOMCLI
	END IF

RETURN ( cNomCli )

//---------------------------------------------------------------------------//
//
// Devuelve el total de la venta en albaranes de clientes de un articulo
//

function nTotVPedCli( cCodArt, cPedCliL, nDec, nDor )

   local nTotVta  := 0
   local nRecno   := ( cPedCliL )->( Recno() )

   if ( cPedCliL )->( dbSeek( cCodArt ) )

      while ( cPedCliL )->CREF == cCodArt .and. !( cPedCliL )->( eof() )

         if !( cPedCliL )->LTOTLIN
            nTotVta += nTotLPedCli( cPedCliL, nDec, nDor )
         end if

         ( cPedCliL )->( dbSkip() )

      end while

   end if

   ( cPedCliL )->( dbGoTo( nRecno ) )

return ( nTotVta )

//---------------------------------------------------------------------------//

FUNCTION aDocPedCli( lEntregas )

   local aDoc        := {}

   DEFAULT lEntregas := .f.

   /*
   Itmes-----------------------------------------------------------------------
   */

   aAdd( aDoc, { "Empresa",         "EM" } )
   aAdd( aDoc, { "Pedido",          "PC" } )

   if lEntregas
      aAdd( aDoc, { "Entregas a cuenta",  "EP" } )
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

function aCalPedCli()

   local aCalPedCli :=  {{"nTotArt",                                                   "N", 16,  6, "Total artículos",             "cPicUndPed",  "" },;
                        { "nTotCaj",                                                   "N", 16,  6, "Total cajas",                 "cPicUndPed",  "" },;
                        { "aTotIva[1,1]",                                              "N", 16,  6, "Bruto primer tipo de " + cImp(),    "cPorDivPed",  "aTotIva[1,1] != 0" },;
                        { "aTotIva[2,1]",                                              "N", 16,  6, "Bruto segundo tipo de " + cImp(),   "cPorDivPed",  "aTotIva[2,1] != 0" },;
                        { "aTotIva[3,1]",                                              "N", 16,  6, "Bruto tercer tipo de " + cImp(),    "cPorDivPed",  "aTotIva[3,1] != 0" },;
                        { "aTotIva[1,2]",                                              "N", 16,  6, "Base primer tipo de " + cImp(),     "cPorDivPed",  "aTotIva[1,2] != 0" },;
                        { "aTotIva[2,2]",                                              "N", 16,  6, "Base segundo tipo de " + cImp(),    "cPorDivPed",  "aTotIva[2,2] != 0" },;
                        { "aTotIva[3,2]",                                              "N", 16,  6, "Base tercer tipo de " + cImp(),     "cPorDivPed",  "aTotIva[3,2] != 0" },;
                        { "aTotIva[1,3]",                                              "N",  5,  2, "Porcentaje primer tipo " + cImp(),  "'@R 99.99%'", "aTotIva[1,3] != 0" },;
                        { "aTotIva[2,3]",                                              "N",  5,  2, "Porcentaje segundo tipo " + cImp(), "'@R 99.99%'", "aTotIva[2,3] != 0" },;
                        { "aTotIva[3,3]",                                              "N",  5,  2, "Porcentaje tercer tipo " + cImp(),  "'@R 99.99%'", "aTotIva[3,3] != 0" },;
                        { "aTotIva[1,4]",                                              "N",  5,  2, "Porcentaje primer tipo RE",   "'@R 99.99%'", "aTotIva[1,4] != 0" },;
                        { "aTotIva[2,4]",                                              "N",  5,  2, "Porcentaje segundo tipo RE",  "'@R 99.99%'", "aTotIva[2,4] != 0" },;
                        { "aTotIva[3,4]",                                              "N",  5,  2, "Porcentaje tercer tipo RE",   "'@R 99.99%'", "aTotIva[3,4] != 0" },;
                        { "round( aTotIva[1,2] * aTotIva[1,3] / 100, nDouDivPed )",    "N", 16,  6, "Importe primer tipo " + cImp(),     "cPorDivPed",  "aTotIva[1,2] != 0" },;
                        { "round( aTotIva[2,2] * aTotIva[2,3] / 100, nDouDivPed )",    "N", 16,  6, "Importe segundo tipo " + cImp(),    "cPorDivPed",  "aTotIva[2,2] != 0" },;
                        { "round( aTotIva[3,2] * aTotIva[3,3] / 100, nDouDivPed )",    "N", 16,  6, "Importe tercer tipo " + cImp(),     "cPorDivPed",  "aTotIva[3,2] != 0" },;
                        { "round( aTotIva[1,2] * aTotIva[1,4] / 100, nDouDivPed )",    "N", 16,  6, "Importe primer RE",           "cPorDivPed",  "aTotIva[1,2] != 0" },;
                        { "round( aTotIva[2,2] * aTotIva[2,4] / 100, nDouDivPed )",    "N", 16,  6, "Importe segundo RE",          "cPorDivPed",  "aTotIva[2,2] != 0" },;
                        { "round( aTotIva[3,2] * aTotIva[3,4] / 100, nDouDivPed )",    "N", 16,  6, "Importe tercer RE",           "cPorDivPed",  "aTotIva[3,2] != 0" },;
                        { "nTotBrt",                                                   "N", 16,  6, "Total bruto",                 "cPorDivPed",  "lEnd" },;
                        { "nTotDto",                                                   "N", 16,  6, "Total descuento",             "cPorDivPed",  "lEnd" },;
                        { "nTotDpp",                                                   "N", 16,  6, "Total descuento pronto pago", "cPorDivPed",  "lEnd" },;
                        { "nTotNet",                                                   "N", 16,  6, "Total neto",                  "cPorDivPed",  "lEnd" },;
                        { "nTotIva",                                                   "N", 16,  6, "Total " + cImp(),                   "cPorDivPed",  "lEnd" },;
                        { "nTotIvm",                                                   "N", 16,  6, "Total IVMH",                  "cPorDivPed",  "lEnd" },;
                        { "nTotReq",                                                   "N", 16,  6, "Total RE",                    "cPorDivPed",  "lEnd" },;
                        { "nTotPed",                                                   "N", 16,  6, "Total pedido",                "cPorDivPed",  "lEnd" },;
                        { "nTotPag",                                                   "N", 16,  6, "Total entregas a cuenta",     "cPorDivPed",  "lEnd" },;
                        { "nTotCos",                                                   "N", 16,  6, "Total costo",                 "cPorDivPed",  "lEnd" },;
                        { "nTotPes",                                                   "N", 16,  6, "Total peso",                  "'@E 99,999.99'","lEnd" },;
                        { "nTotPage",                                                  "N", 16,  6, "Total página",                "'cPorDivPed'", "!lEnd" },;
                        { "nImpEuros( nTotPed, (cDbf)->cDivPed, cDbfDiv )",            "N", 16,  6, "Total pedido (Euros)",        "",            "lEnd" },;
                        { "nImpPesetas( nTotPed, (cDbf)->cDivPed, cDbfDiv )",          "N", 16,  6, "Total pedido (Pesetas)",      "",            "lEnd" },;
                        { "nPagina",                                                   "N",  2,  0, "Numero de página",            "'99'",        "" },;
                        { "lEnd",                                                      "L",  1,  0, "Fin del documento",           "",            "" } }

return ( aCalPedCli )

//---------------------------------------------------------------------------//

function aCocPedCli()

   local aCocPedCli  := {{"Descrip( cDbfCol )",                                         "C", 50, 0, "Detalle del artículo",       "",            "Descripción", "" },;
                        { "nTotNPedCli( cDbfCol ) )",                                   "N", 16, 6, "Total unidades",             "cPicUndPed",  "Unds.",       "" },;
                        { "nTotUPedCli( cDbfCol, nRouDivPed, nVdvDivPed )",             "N", 16, 6, "Precio unitario de pedido",  "cPouDivPed",  "Importe",     "" },;
                        { "nTotLPedCli( cDbfCol, nDouDivPed, nRouDivPed )",             "N", 16, 6, "Total línea de pedido",      "cPorDivPed",  "Total",       "" },;
                        { "nTotFPedCli( cDbfCol, nDouDivPed, nRouDivPed )",             "N", 16, 6, "Total final línea de pedido","cPorDivPed",  "Total",       "" },;
                        { "cFrasePublicitaria( cDbfCol )",                              "C", 50, 0, "Texto de frase publicitaria","",            "Publicidad",  "" } }


return ( aCocPedCli )

//---------------------------------------------------------------------------//

FUNCTION QuiPedCli()

   local nOrdDet
   local nOrdPgo
   local nOrdRes
   local nOrdInc
   local nOrdDoc
   local nOrdEst

   if ( D():PedidosClientes( nView ) )->lCloPed .and. !oUser():lAdministrador()
      msgStop( "Solo puede eliminar pedidos cerrados los administradores." )
      Return .f.
   end if

   nOrdDet        	:= ( D():PedidosClientesLineas( nView ) )->( OrdSetFocus( "NNUMPED" ) )
   nOrdPgo        	:= ( D():PedidosClientesPagos( nView ) )->( OrdSetFocus( "NNUMPED" ) )
   nOrdRes        	:= ( D():PedidosClientesReservas( nView ) )->( OrdSetFocus( "NNUMPED" ) )
   nOrdInc        	:= ( dbfPedCliI )->( OrdSetFocus( "NNUMPED" ) )
   nOrdDoc           := ( dbfPedCliD )->( OrdSetFocus( "NNUMPED" ) )
   nOrdEst           := ( D():PedidosClientesSituaciones( nView ) )->( OrdSetFocus( "NNUMPED" ) ) 

   /*
   Cambiamos el estado del presupuesto del que viene el pedido-----------------
   */

   if !Empty( dbfPreCliT )
      if dbSeekInOrd( ( D():PedidosClientes( nView ) )->cNumPre, 'nNumPre', dbfPreCliT ) .and. ( dbfPreCliT )->( dbRLock() )
         ( dbfPreCliT )->lEstado := .f.
         ( dbfPreCliT )->( dbUnLock() )
      end if
   end if

   /*
   Lineas--------------------------------------------------------------------
   */

   while ( D():PedidosClientesLineas( nView ) )->( dbSeek( ( D():PedidosClientes( nView ) )->cSerPed + Str( ( D():PedidosClientes( nView ) )->nNumPed ) + ( D():PedidosClientes( nView ) )->cSufPed ) ) .and. !( D():PedidosClientesLineas( nView ) )->( eof() )
      if dbLock( D():PedidosClientesLineas( nView ) )
         ( D():PedidosClientesLineas( nView ) )->( dbDelete() )
         ( D():PedidosClientesLineas( nView ) )->( dbUnLock() )
      end if
   end while

   /*
   Reservas--------------------------------------------------------------------
   */

   while ( D():PedidosClientesReservas( nView ) )->( dbSeek( ( D():PedidosClientes( nView ) )->cSerPed + Str( ( D():PedidosClientes( nView ) )->nNumPed ) + ( D():PedidosClientes( nView ) )->cSufPed ) ) .and. !( D():PedidosClientesReservas( nView ) )->( eof() )
      if dbLock( D():PedidosClientesReservas( nView ) )
         ( D():PedidosClientesReservas( nView ) )->( dbDelete() )
         ( D():PedidosClientesReservas( nView ) )->( dbUnLock() )
      end if
   end while

   /*
   Entregas--------------------------------------------------------------------
   */

   while ( D():PedidosClientesPagos( nView ) )->( dbSeek( ( D():PedidosClientes( nView ) )->cSerPed + Str( ( D():PedidosClientes( nView ) )->nNumPed ) + ( D():PedidosClientes( nView ) )->cSufPed ) ) .and. !( D():PedidosClientesPagos( nView ) )->( eof() )
      if dbDialogLock( D():PedidosClientesPagos( nView ) )
         ( D():PedidosClientesPagos( nView ) )->( dbDelete() )
         ( D():PedidosClientesPagos( nView ) )->( dbUnLock() )
      end if
   end while

   /*
   Incidencias-----------------------------------------------------------------
   */

   while ( dbfPedCliI )->( dbSeek( ( D():PedidosClientes( nView ) )->cSerPed + Str( ( D():PedidosClientes( nView ) )->nNumPed ) + ( D():PedidosClientes( nView )  )->cSufPed ) ) .and. !( dbfPedCliI )->( eof() )
      if dbLock( dbfPedCliI )
         ( dbfPedCliI )->( dbDelete() )
         ( dbfPedCliI )->( dbUnLock() )
      end if
   end while

   /*
   Documentos------------------------------------------------------------------
   */

   while ( dbfPedCliD )->( dbSeek( ( D():PedidosClientes( nView ) )->cSerPed + Str( ( D():PedidosClientes( nView ) )->nNumPed ) + ( D():PedidosClientes( nView )  )->cSufPed ) ) .and. !( dbfPedCliD )->( eof() )
      if dbLock( dbfPedCliD )
         ( dbfPedCliD )->( dbDelete() )
         ( dbfPedCliD )->( dbUnLock() )
      end if
   end while

   /*
   Situaciones--------------------------------------------------------
   */

   	while ( D():PedidosClientesSituaciones( nView ) )->( dbSeek( ( D():PedidosClientes( nView ) )->cSerPed + Str( ( D():PedidosClientes( nView ) )->nNumPed ) + ( D():PedidosClientes( nView )  )->cSufPed ) ) .and. !( D():PedidosClientesSituaciones( nView ) )->( eof() )
 	    if dbLock( D():PedidosClientesSituaciones( nView ) )
         	( D():PedidosClientesSituaciones( nView ) )->( dbDelete() )
         	( D():PedidosClientesSituaciones( nView ) )->( dbUnLock() )
      	end if
   	end while


   ( D():PedidosClientesLineas( nView ) )->( OrdSetFocus( nOrdDet ) )
   ( D():PedidosClientesPagos( nView ) )->( OrdSetFocus( nOrdPgo ) )
   ( D():PedidosClientesReservas( nView ) )->( OrdSetFocus( nOrdRes ) )
   ( dbfPedCliI )->( OrdSetFocus( nOrdInc ) )
   ( dbfPedCliD )->( OrdSetFocus( nOrdDoc ) )
   ( D():PedidosClientesSituaciones( nView ) )->( OrdSetFocus( nOrdEst ) ) 

Return ( .t. )

//----------------------------------------------------------------------------//

Function SynPedCli( cPath )

   local oError
   local oBlock
   local nOrdAnt
   local aTotPed
   local dbfArticulo
   local cdbfIva
   local dbfFamilia
   local cDbfPago
   local cDbfDiv
   local dbfPedCliR

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   USE ( cPatEmp() + "PedCliT.DBF" ) NEW VIA ( cDriver() ) EXCLUSIVE ALIAS ( cCheckArea( "PedCliT", @dbfPedCliT ) )
   SET ADSINDEX TO ( cPatEmp() + "PedCliT.CDX" ) ADDITIVE

   USE ( cPatEmp() + "PEDCLIL.DBF" ) NEW VIA ( cDriver() ) EXCLUSIVE ALIAS ( cCheckArea( "PEDCLIL", @dbfPedCliL ) )
   SET ADSINDEX TO ( cPatEmp() + "PEDCLIL.CDX" ) ADDITIVE

   USE ( cPatEmp() + "PEDCLIR.DBF" ) NEW VIA ( cDriver() ) EXCLUSIVE ALIAS ( cCheckArea( "PEDCLIR", @dbfPedCliR ) )
   SET ADSINDEX TO ( cPatEmp() + "PEDCLIR.CDX" ) ADDITIVE

   USE ( cPatEmp() + "PEDCLII.DBF" ) NEW VIA ( cDriver() ) EXCLUSIVE ALIAS ( cCheckArea( "PEDCLII", @dbfPedCliI ) )
   SET ADSINDEX TO ( cPatEmp() + "PEDCLII.CDX" ) ADDITIVE

   USE ( cPatEmp() + "PEDCLIE.DBF" ) NEW VIA ( cDriver() ) EXCLUSIVE ALIAS ( cCheckArea( "PEDCLIE", @dbfPedCliE ) ) 
   SET ADSINDEX TO ( cPatEmp() + "PEDCLIE.CDX" ) ADDITIVE

   USE ( cPatEmp() + "PEDCLID.DBF" ) NEW VIA ( cDriver() ) EXCLUSIVE ALIAS ( cCheckArea( "PEDCLID", @dbfPedCliD ) )
   SET ADSINDEX TO ( cPatEmp() + "PEDCLID.CDX" ) ADDITIVE

   USE ( cPatEmp() + "PEDCLIP.DBF" ) NEW VIA ( cDriver() ) EXCLUSIVE ALIAS ( cCheckArea( "PEDCLIP", @dbfPedCliP ) )
   SET ADSINDEX TO ( cPatEmp() + "PEDCLIP.CDX" ) ADDITIVE

   USE ( cPatEmp() + "ARTICULO.DBF" )  NEW VIA ( cDriver() ) ALIAS ( cCheckArea( "ARTICULO", @dbfArticulo ) ) EXCLUSIVE
   SET ADSINDEX TO ( cPatEmp() + "ARTICULO.CDX" ) ADDITIVE

   USE ( cPatEmp() + "FAMILIAS.DBF" )  NEW VIA ( cDriver() ) ALIAS ( cCheckArea( "FAMILIAS", @dbfFamilia ) ) EXCLUSIVE
   SET ADSINDEX TO ( cPatEmp() + "FAMILIAS.CDX" ) ADDITIVE

   USE ( cPatEmp() + "FPAGO.DBF" )     NEW VIA ( cDriver() ) ALIAS ( cCheckArea( "FPAGO", @cDbfPago ) ) EXCLUSIVE
   SET ADSINDEX TO ( cPatEmp() + "FPAGO.CDX" ) ADDITIVE

   USE ( cPatDat() + "TIVA.DBF" )      NEW VIA ( cDriver() ) ALIAS ( cCheckArea( "TIVA", @cdbfIva ) ) SHARED
   SET ADSINDEX TO ( cPatDat() + "TIVA.CDX" ) ADDITIVE

   USE ( cPatDat() + "DIVISAS.DBF" )   NEW VIA ( cDriver() ) ALIAS ( cCheckArea( "DIVISAS", @cdbfDiv ) ) SHARED
   SET ADSINDEX TO ( cPatDat() + "DIVISAS.CDX" ) ADDITIVE

   ( dbfPedCliT )->( ordSetFocus( 0 ) )
   ( dbfPedCliT )->( dbGoTop() )
    
   while !( dbfPedCliT )->( eof() )

      if Empty( ( dbfPedCliT )->cSufPed )
         ( dbfPedCliT )->cSufPed := "00"
      end if

      if !Empty( ( dbfPedCliT )->cNumPre ) .and. Len( AllTrim( ( dbfPedCliT )->cNumPre ) ) != 12
      	( dbfPedCliT )->cNumPre := AllTrim( ( dbfPedCliT )->cNumPre ) + "00"
      end if

      if !Empty( ( dbfPedCliT )->cNumAlb ) .and. Len( AllTrim( ( dbfPedCliT )->cNumAlb ) ) != 12
      	( dbfPedCliT )->cNumAlb := AllTrim( ( dbfPedCliT )->cNumAlb ) + "00"
      end if

      if Empty( ( dbfPedCliT )->cCodCaj )
      	( dbfPedCliT )->cCodCaj := "000"
      end if

      if Empty( ( dbfPedCliT )->Uuid_Trn )
         ( dbfPedCliT )->Uuid_Trn := TransportistasModel():getUuid( ( dbfPedCliT )->cCodTrn )
      end if

      ( dbfPedCliT )->( dbSkip() )

   end while


   ( dbfPedCliT )->( ordSetFocus( 1 ) )
 	( dbfPedCliT )->( dbGoTop() )

   while !( dbfPedCliT )->( eof() )

      /*
      Rellenamos los campos de totales--------------------------------------
      */

      if ( dbfPedCliT )->nTotPed == 0 .and. dbLock( dbfPedCliT )

         aTotPed                 := aTotPedCli( ( dbfPedCliT )->cSerPed + Str( ( dbfPedCliT )->nNumPed ) + ( dbfPedCliT )->cSufPed, dbfPedCliT, dbfPedCliL, cdbfIva, cdbfDiv, cDbfPago, ( dbfPedCliT )->cDivPed )

         ( dbfPedCliT )->nTotNet := aTotPed[ 1 ]
         ( dbfPedCliT )->nTotIva := aTotPed[ 2 ]
         ( dbfPedCliT )->nTotReq := aTotPed[ 3 ]
         ( dbfPedCliT )->nTotPed := aTotPed[ 4 ]

         ( dbfPedCliT )->( dbUnLock() )

      end if

      ( dbfPedCliT )->( dbSkip() )

   end while

   // Lineas -----------------------------------------------------------------

   ( dbfPedCliL )->( ordSetFocus( 0 ) )
   ( dbfPedCliL )->( dbGoTop() )

   while !( dbfPedCliL )->( eof() )

      if Empty( ( dbfPedCliL )->cSufPed )
         ( dbfPedCliL )->cSufPed := "00"
      end if

      if Empty( ( dbfPedCliL )->cLote ) .and. !Empty( ( dbfPedCliL )->nLote )
         ( dbfPedCliL )->cLote   := AllTrim( Str( ( dbfPedCliL )->nLote ) )
      end if

      if ( dbfPedCliL )->lIvaLin != RetFld( ( dbfPedCliL )->cSerPed + Str( ( dbfPedCliL )->nNumPed ) + ( dbfPedCliL )->cSufPed, dbfPedCliT, "lIvaInc" )
         ( dbfPedCliL )->lIvaLin := RetFld( ( dbfPedCliL )->cSerPed + Str( ( dbfPedCliL )->nNumPed ) + ( dbfPedCliL )->cSufPed, dbfPedCliT, "lIvaInc" )
      end if

      if ( dbfPedCliL )->cCodTip != retFld( ( dbfPedCliL )->cRef, dbfArticulo, "cCodTip", "Codigo" )      
         ( dbfPedCliL )->cCodTip := retFld( ( dbfPedCliL )->cRef, dbfArticulo, "cCodTip", "Codigo" )      
      end if 

      if Empty( ( dbfPedCliL )->cAlmLin )
         ( dbfPedCliL )->cAlmLin := RetFld( ( dbfPedCliL )->cSerPed + Str( ( dbfPedCliL )->nNumPed ) + ( dbfPedCliL )->cSufPed, dbfPedCliT, "cCodAlm" )
      end if

      if !Empty( ( dbfPedCliL )->cRef ) .and. Empty( ( dbfPedCliL )->cCodFam )
         ( dbfPedCliL )->cCodFam := RetFamArt( ( dbfPedCliL )->cRef, dbfArticulo )
      end if

      if !Empty( ( dbfPedCliL )->cRef ) .and. !Empty( ( dbfPedCliL )->cGrpFam )
         ( dbfPedCliL )->cGrpFam := cGruFam( ( dbfPedCliL )->cCodFam, dbfFamilia )
      end if

      if Empty( ( dbfPedCliL )->nReq )
         ( dbfPedCliL )->nReq    := nPReq( cdbfIva, ( dbfPedCliL )->nIva )
      end if

      if Empty( ( dbfPedCliL )->nPosPrint )
         ( dbfPedCliL )->nPosPrint    := ( dbfPedCliL )->nNumLin
      end if

      if ( dbfPedCliL )->nRegIva != RetFld( ( dbfPedCliL )->cSerPed + Str( ( dbfPedCliL )->nNumPed ) + ( dbfPedCliL )->cSufPed, dbfPedCliT, "nRegIva" )
         if dbLock( dbfPedCliL )
            ( dbfPedCliL )->nRegIva := RetFld( ( dbfPedCliL )->cSerPed + Str( ( dbfPedCliL )->nNumPed ) + ( dbfPedCliL )->cSufPed, dbfPedCliT, "nRegIva" )
            ( dbfPedCliL )->( dbUnlock() )
         end if
      end if

      ( dbfPedCliL )->( dbSkip() )

      SysRefresh()

   end while

	( dbfPedCliL )->( ordSetFocus( 1 ) )

   // Incidencias ----------------------------------------------------------

   ( dbfPedCliI )->( ordSetFocus( 0 ) )
	( dbfPedCliI )->( dbGoTop() )

   while !( dbfPedCliI )->( eof() )

      if Empty( ( dbfPedCliI )->cSufPed )
         ( dbfPedCliI )->cSufPed := "00"
      end if

      ( dbfPedCliI )->( dbSkip() )

      SysRefresh()

   end while

 	( dbfPedCliI )->( ordSetFocus( 1 ) )

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   CLOSE ( dbfPedCliT )
   CLOSE ( dbfPedCliL )
   CLOSE ( dbfPedCliI )
   CLOSE ( dbfPedCliR )
   CLOSE ( dbfPedCliD )
   CLOSE ( dbfPedCliP )
   CLOSE ( dbfArticulo)
   CLOSE ( dbfFamilia )
   CLOSE ( cdbfIva    )
   CLOSE ( cdbfDiv    )
   CLOSE ( cDbfPago   )
   CLOSE ( dbfPedCliE ) 

Return nil

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS TPedidosClientesSenderReciver FROM TSenderReciverItem

   METHOD CreateData()

   METHOD RestoreData()

   METHOD SendData()

   METHOD ReciveData()

   METHOD Process()

   METHOD validateRecepcion()

END CLASS

//----------------------------------------------------------------------------//

METHOD CreateData() CLASS TPedidosClientesSenderReciver

   local lSnd              := .f.
   local cPedCliT
   local dbfPedCliL
   local dbfPedCliI
   local tmpPedCliT
   local tmpPedCliL
   local tmpPedCliI
   local cFileName

   if ::oSender:lServer
      cFileName         := "PedCli" + StrZero( ::nGetNumberToSend(), 6 ) + ".All"
   else
      cFileName         := "PedCli" + StrZero( ::nGetNumberToSend(), 6 ) + "." + RetSufEmp()
   end if

   ::oSender:SetText( "Enviando pedidos de clientes" )

   USE ( cPatEmp() + "PedCliT.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PedCliT", @cPedCliT ) )
   SET ADSINDEX TO ( cPatEmp() + "PedCliT.CDX" ) ADDITIVE

   USE ( cPatEmp() + "PedCliL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PedCliL", @dbfPedCliL ) )
   SET ADSINDEX TO ( cPatEmp() + "PedCliL.CDX" ) ADDITIVE

   USE ( cPatEmp() + "PedCliI.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PedCliI", @dbfPedCliI ) )
   SET ADSINDEX TO ( cPatEmp() + "PedCliI.CDX" ) ADDITIVE

   /*
   Creamos todas las bases de datos relacionadas con Articulos
   */

   mkPedCli( cPatSnd() )

   USE ( cPatSnd() + "PedCliT.DBF" ) NEW VIA ( cLocalDriver() ) SHARED ALIAS ( cCheckArea( "PedCliT", @tmpPedCliT ) )
   SET INDEX TO ( cPatSnd() + "PedCliT.CDX" ) ADDITIVE

   USE ( cPatSnd() + "PedCliL.DBF" ) NEW VIA ( cLocalDriver() ) SHARED ALIAS ( cCheckArea( "PedCliL", @tmpPedCliL ) )
   SET INDEX TO ( cPatSnd() + "PedCliL.CDX" ) ADDITIVE

   USE ( cPatSnd() + "PedCliI.DBF" ) NEW VIA ( cLocalDriver() ) SHARED ALIAS ( cCheckArea( "PedCliI", @tmpPedCliI ) )
   SET INDEX TO ( cPatSnd() + "PedCliI.CDX" ) ADDITIVE

   if !Empty( ::oSender:oMtr )
      ::oSender:oMtr:nTotal := ( cPedCliT )->( LastRec() )
   end if

   while !( cPedCliT )->( eof() )

      if ( cPedCliT )->lSndDoc

         lSnd  := .t.

         dbPass( cPedCliT, tmpPedCliT, .t. )
         ::oSender:SetText( ( cPedCliT )->cSerPed + "/" + AllTrim( Str( ( cPedCliT )->nNumPed ) ) + "/" + AllTrim( ( cPedCliT )->cSufPed ) + "; " + Dtoc( ( cPedCliT )->dFecPed ) + "; " + AllTrim( ( cPedCliT )->cCodCli ) + "; " + ( cPedCliT )->cNomCli )

         if ( dbfPedCliL )->( dbSeek( ( cPedCliT )->cSerPed + Str( ( cPedCliT )->nNumPed ) + ( cPedCliT )->cSufPed ) )
            while ( ( dbfPedCliL )->cSerPed + Str( ( dbfPedCliL )->nNumPed ) + ( dbfPedCliL )->cSufPed ) == ( ( cPedCliT )->cSerPed + Str( ( cPedCliT )->nNumPed ) + ( cPedCliT )->cSufPed ) .AND. !( dbfPedCliL )->( eof() )
               dbPass( dbfPedCliL, tmpPedCliL, .t. )
               ( dbfPedCliL )->( dbSkip() )
            end do
         end if

         if ( dbfPedCliI )->( dbSeek( ( cPedCliT )->cSerPed + Str( ( cPedCliT )->nNumPed ) + ( cPedCliT )->cSufPed ) )
            while ( ( dbfPedCliI )->cSerPed + Str( ( dbfPedCliI )->nNumPed ) + ( dbfPedCliI )->cSufPed ) == ( ( cPedCliT )->cSerPed + Str( ( cPedCliT )->nNumPed ) + ( cPedCliT )->cSufPed ) .AND. !( dbfPedCliI )->( eof() )
               dbPass( dbfPedCliI, tmpPedCliI, .t. )
               ( dbfPedCliI )->( dbSkip() )
            end do
         end if

      end if

      ( cPedCliT )->( dbSkip() )

      if !Empty( ::oSender:oMtr )
         ::oSender:oMtr:Set( ( cPedCliT )->( OrdKeyNo() ) )
      end if

   end do

   CLOSE ( cPedCliT )
   CLOSE ( dbfPedCliL )
   CLOSE ( dbfPedCliI )
   CLOSE ( tmpPedCliT )
   CLOSE ( tmpPedCliL )
   CLOSE ( tmpPedCliI )

   // Comprimir los archivos---------------------------------------------------

   if lSnd

      ::oSender:SetText( "Comprimiendo pedidos de clientes" )

      if ::oSender:lZipData( cFileName )
         ::oSender:SetText( "Ficheros comprimidos en " + cFileName )
      else
         ::oSender:SetText( "ERROR al crear fichero comprimido" )
      end if

   else

      ::oSender:SetText( "No hay pedidos de clientes para enviar" )

   end if

Return ( Self )

//----------------------------------------------------------------------------//

METHOD RestoreData() CLASS TPedidosClientesSenderReciver

   local cPedCliT

   if ::lSuccesfullSend

      /*
      Retorna el valor anterior
      */

      USE ( cPatEmp() + "PEDCLIT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PEDCLIT", @cPedCliT ) )
      SET ADSINDEX TO ( cPatEmp() + "PedCliT.Cdx" ) ADDITIVE
      ( cPedCliT )->( OrdSetFocus( "lSndDoc" ) )

      while ( cPedCliT )->( dbSeek( .t. ) ) .and. !( cPedCliT )->( eof() )
         if ( cPedCliT )->( dbRLock() )
            ( cPedCliT )->lSndDoc := .f.
            ( cPedCliT )->( dbRUnlock() )
         end if
      end do

      CLOSE ( cPedCliT )

   end if

Return ( Self )
//----------------------------------------------------------------------------//

METHOD SendData() CLASS TPedidosClientesSenderReciver

   local cFileName

   if ::oSender:lServer
      cFileName         := "PedCli" + StrZero( ::nGetNumberToSend(), 6 ) + ".All"
   else
      cFileName         := "PedCli" + StrZero( ::nGetNumberToSend(), 6 ) + "." + RetSufEmp()
   end if

   if !file( cPatOut() + cFileName )
      ::oSender:SetText( "No existe el fichero " + cPatOut() + cFileName )
      Return (  Self )
   end if 

   // Enviarlos a internet

   if ::oSender:SendFiles( cPatOut() + cFileName, cFileName )
      ::lSuccesfullSend := .t.
      ::IncNumberToSend()
      ::oSender:SetText( "Fichero enviado " + cPatOut() + cFileName )
   else
      ::oSender:SetText( "ERROR al enviar fichero" )
   end if

Return ( Self )

//----------------------------------------------------------------------------//

METHOD ReciveData() CLASS TPedidosClientesSenderReciver

   	local n
   	local aExt

      aExt     := ::oSender:aExtensions()

   	/*
   	Recibirlo de internet
   	*/

   	::oSender:SetText( "Recibiendo pedidos de clientes" )

   	if !::oSender:lFranquiciado

   		for n := 1 to len( aExt )
      		::oSender:GetFiles( "PedCli*." + aExt[ n ], cPatIn() )
   		next

   	else

		for n := 1 to len( aExt )
      		::oSender:GetFiles( "PedPrv*." + aExt[ n ], cPatIn() )
   		next   	

   	end if	

   ::oSender:SetText( "Pedidos de clientes recibidos" )

Return Self

//----------------------------------------------------------------------------//

METHOD Process() CLASS TPedidosClientesSenderReciver

   local m
   local oBlock
   local oError
   local aFiles
   local cSerie
   local nNumero
   local cSufijo
   local dbfCount
   local dbfPedCliT
   local dbfPedCliL
   local dbfPedCliI
   local tmpPedCliT
   local tmpPedCliL
   local tmpPedCliI

   aFiles            := directory( cPatIn() + "PedCli*.*" )

   for m := 1 to len( aFiles )

      ::oSender:SetText( "Procesando fichero : " + aFiles[ m, 1 ] )

      oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
      BEGIN SEQUENCE

         if ::oSender:lUnZipData( cPatIn() + aFiles[ m, 1 ], .f. )

         	// Ficheros temporales------------------------------------------

         	if file( cPatSnd() + "PedCliT.DBF" ) .and. ;
               file( cPatSnd() + "PedCliL.DBF" ) .and. ;
               file( cPatSnd() + "PedCliI.DBF" )

               USE ( cPatSnd() + "PedCliT.DBF" ) NEW VIA ( cLocalDriver() ) READONLY ALIAS ( cCheckArea( "PedCliT", @tmpPedCliT ) )
               SET INDEX TO ( cPatSnd() + "PedCliT.CDX" ) ADDITIVE

               USE ( cPatSnd() + "PedCliL.DBF" ) NEW VIA ( cLocalDriver() ) READONLY ALIAS ( cCheckArea( "PedCliL", @tmpPedCliL ) )
               SET INDEX TO ( cPatSnd() + "PedCliL.CDX" ) ADDITIVE

               USE ( cPatSnd() + "PedCliI.DBF" ) NEW VIA ( cLocalDriver() ) READONLY ALIAS ( cCheckArea( "PedCliI", @tmpPedCliI ) )
               SET INDEX TO ( cPatSnd() + "PedCliI.CDX" ) ADDITIVE

               USE ( cPatEmp() + "PedCliT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PedCliT", @dbfPedCliT ) )
               SET ADSINDEX TO ( cPatEmp() + "PedCliT.CDX" ) ADDITIVE

               USE ( cPatEmp() + "PedCliL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PedCliL", @dbfPedCliL ) )
               SET ADSINDEX TO ( cPatEmp() + "PedCliL.CDX" ) ADDITIVE

               USE ( cPatEmp() + "PedCliI.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PedCliI", @dbfPedCliI ) )
               SET ADSINDEX TO ( cPatEmp() + "PedCliI.CDX" ) ADDITIVE

               ( tmpPedCliT )->( dbgotop() )
               while ( tmpPedCliT )->( !eof() )

               	if ::validateRecepcion( tmpPedCliT, dbfPedCliT )

                     // Eliminamos datos anteriores-------------------------

                     while ( dbfPedCliT )->( dbseek( ( tmpPedCliT )->cSerPed + Str( ( tmpPedCliT )->nNumPed ) + ( tmpPedCliT )->cSufPed ) )
                        dbLockDelete( dbfPedCliT )
                     end if 

                     while ( dbfPedCliL )->( dbseek( ( tmpPedCliT )->cSerPed + Str( ( tmpPedCliT )->nNumPed ) + ( tmpPedCliT )->cSufPed ) )
                        dbLockDelete( dbfPedCliL )
                     end if 

                     while ( dbfPedCliI )->( dbseek( ( tmpPedCliT )->cSerPed + Str( ( tmpPedCliT )->nNumPed ) + ( tmpPedCliT )->cSufPed ) )
                        dbLockDelete( dbfPedCliI )
                     end if 

                     // Traspaso de nuevos datos----------------------------

               		dbPass( tmpPedCliT, dbfPedCliT, .t. )

                     if dbLock( dbfPedCliT )
                        ( dbfPedCliT )->lSndDoc := .f.
                        ( dbfPedCliT )->( dbUnLock() )
                     end if

               		::oSender:SetText( "Añadido : " + ( tmpPedCliT )->cSerPed + "/" + AllTrim( Str( ( tmpPedCliT )->nNumPed ) ) + "/" + AllTrim( ( tmpPedCliT )->cSufPed ) + "; " + Dtoc( ( tmpPedCliT )->dFecPed ) + "; " + AllTrim( ( tmpPedCliT )->cCodCli ) + "; " + ( tmpPedCliT )->cNomCli )

               		if ( tmpPedCliL )->( dbSeek( ( tmpPedCliT )->cSerPed + Str( ( tmpPedCliT )->nNumPed ) + ( tmpPedCliT )->cSufPed ) )
                  		while ( tmpPedCliL )->cSerPed + Str( ( tmpPedCliL )->nNumPed ) + ( tmpPedCliL )->cSufPed == ( tmpPedCliT )->cSerPed + Str( ( tmpPedCliT )->nNumPed ) + ( tmpPedCliT )->cSufPed .and. !( tmpPedCliL )->( eof() )
                  			dbPass( tmpPedCliL, dbfPedCliL, .t. )
                  			( tmpPedCliL )->( dbSkip() )
                  		end do
               		end if

               		if ( tmpPedCliI )->( dbSeek( ( tmpPedCliT )->cSerPed + Str( ( tmpPedCliT )->nNumPed ) + ( tmpPedCliT )->cSufPed ) )
                  		while ( tmpPedCliI )->cSerPed + Str( ( tmpPedCliI )->nNumPed ) + ( tmpPedCliI )->cSufPed == ( tmpPedCliT )->cSerPed + Str( ( tmpPedCliT )->nNumPed ) + ( tmpPedCliT )->cSufPed .and. !( tmpPedCliI )->( eof() )
                  			dbPass( tmpPedCliI, dbfPedCliI, .t. )
                  			( tmpPedCliI )->( dbSkip() )
                  		end do
               		end if

               	else

               		::oSender:SetText( ::cErrorRecepcion  )

               	end if

               	( tmpPedCliT )->( dbSkip() )

               end do

               CLOSE ( dbfPedCliT )
               CLOSE ( dbfPedCliL )
               CLOSE ( dbfPedCliI )
               CLOSE ( tmpPedCliT )
               CLOSE ( tmpPedCliL )
               CLOSE ( tmpPedCliI )

         	else

            	::oSender:SetText( "Faltan ficheros" )

               if !file( cPatSnd() + "PedCliT.Dbf" )
                  ::oSender:SetText( "Falta" + cPatSnd() + "PedCliT.Dbf" )
               end if

               if !file( cPatSnd() + "PedCliL.Dbf" )
                  ::oSender:SetText( "Falta" + cPatSnd() + "PedCliL.Dbf" )
               end if

               if !file( cPatSnd() + "PedCliI.Dbf" )
                  ::oSender:SetText( "Falta" + cPatSnd() + "PedCliI.Dbf" )
               end if

         	end if

         	fErase( cPatSnd() + "PedCliT.Dbf" )
         	fErase( cPatSnd() + "PedCliL.Dbf" )
         	fErase( cPatSnd() + "PedCliI.Dbf" )

         else

           	::oSender:SetText( "Error al descomprimir los ficheros" )

         end if

         ::oSender:AppendFileRecive( aFiles[ m, 1 ] )

      RECOVER USING oError

         CLOSE ( dbfPedCliT )
         CLOSE ( dbfPedCliL )
         CLOSE ( dbfPedCliI )
         CLOSE ( tmpPedCliT )
         CLOSE ( tmpPedCliL )
         CLOSE ( tmpPedCliI )

         ::oSender:SetText( "Error procesando fichero " + aFiles[ m, 1 ] )
         ::oSender:SetText( ErrorMessage( oError ) )

      END SEQUENCE

      ErrorBlock( oBlock )

   next

Return Self

//---------------------------------------------------------------------------//

METHOD validateRecepcion( tmpPedCliT, dbfPedCliT ) CLASS TPedidosClientesSenderReciver

   ::cErrorRecepcion       := "Pocesando pedido de cliente número " + ( dbfPedCliT )->cSerPed + "/" + alltrim( Str( ( dbfPedCliT )->nNumPed ) ) + "/" + alltrim( ( dbfPedCliT )->cSufPed ) + " "

   if !( lValidaOperacion( ( tmpPedCliT )->dFecPed, .f. ) )
      ::cErrorRecepcion    += "la fecha " + dtoc( ( tmpPedCliT )->dFecPed ) + " no es valida en esta empresa"
      Return .f. 
   end if 

   if !( ( dbfPedCliT )->( dbSeek( ( tmpPedCliT )->cSerPed + Str( ( tmpPedCliT )->nNumPed ) + ( tmpPedCliT )->cSufPed ) ) )
      Return .t.
   end if 

   if !Empty( ( tmpPedCliT )->dFecCre ) .and. ( dtos( ( dbfPedCliT )->dFecCre ) + ( dbfPedCliT )->cTimCre >= dtos( ( tmpPedCliT )->dFecCre ) + ( tmpPedCliT )->cTimCre  )
      ::cErrorRecepcion    += "la fecha en la empresa " + dtoc( ( dbfPedCliT )->dFecCre ) + " " + ( dbfPedCliT )->cTimCre + " es más reciente que la recepción " + dtoc( ( tmpPedCliT )->dFecCre ) + " " + ( tmpPedCliT )->cTimCre 
      Return .f.
   end if

Return ( .t. )

//---------------------------------------------------------------------------//

function aColTmpLin()

   local aColTmpLin  := {}

   aAdd( aColTmpLin, { "cSerPed", "C",    1,  0, "Serie del pedido",                "",         "", "( cDbfCol )" } )
   aAdd( aColTmpLin, { "nNumPed", "N",    9,  0, "Número del pedido",               "",         "", "( cDbfCol )" } )
   aAdd( aColTmpLin, { "cSufPed", "C",    2,  0, "Sufijo del pedido",               "",         "", "( cDbfCol )" } )
   aAdd( aColTmpLin, { "cRef",    "C",   18,  0, "Referencia del artículo",         "",         "", "( cDbfCol )" } )
   aAdd( aColTmpLin, { "cDetalle","C",  250,  0, "Nombre del artículo",             "",         "", "( cDbfCol )" } )
   aAdd( aColTmpLin, { "mLngDes", "M",   10,  0, "Descripciones largas",            "",         "", "( cDbfCol )" } )
   aAdd( aColTmpLin, { "lSelArt", "L",    1,  0, "Lógico de selección de artículo", "",         "", "( cDbfCol )" } )
   aAdd( aColTmpLin, { "cCodPrv", "C",   12,  0, "Código de proveedor",             "",         "", "( cDbfCol )" } )
   aAdd( aColTmpLin, { "cCodPr1", "C",   20,  0, "Código propiedad 1",              "",         "", "( cDbfCol )" } )
   aAdd( aColTmpLin, { "cCodPr2", "C",   20,  0, "Código propiedad 2",              "",         "", "( cDbfCol )" } )
   aAdd( aColTmpLin, { "cValPr1", "C",   20,  0, "Valor propiedad 1",               "",         "", "( cDbfCol )" } )
   aAdd( aColTmpLin, { "cValPr2", "C",   20,  0, "Valor propiedad 2",               "",         "", "( cDbfCol )" } )
   aAdd( aColTmpLin, { "nNumUni", "N",   16,  6, "Unidades pedidas",                "",         "", "( cDbfCol )" } )
   aAdd( aColTmpLin, { "nNumCaj", "N",   16,  6, "Cajas pedidas",                   "",         "", "( cDbfCol )" } )
   aAdd( aColTmpLin, { "nStkFis", "N",   16,  6, "Stock fisico",                    "",         "", "( cDbfCol )" } )
   aAdd( aColTmpLin, { "nStkDis", "N",   16,  6, "Stock disponible",                "",         "", "( cDbfCol )" } )
   aAdd( aColTmpLin, { "lShow",   "L",    1,  0, "Lógico de mostrar",               "",         "", "( cDbfCol )" } )
   aAdd( aColTmpLin, { "nIva",    "N",    6,  2, "Porcentaje de " + cImp(),         "",         "", "( cDbfCol )" } )
   aAdd( aColTmpLin, { "nReq",    "N",    6,  2, "Porcentaje de recargo",           "",         "", "( cDbfCol )" } )
   aAdd( aColTmpLin, { "nPreDiv", "N",   16,  6, "Precio del artículo",             "",         "", "( cDbfCol )" } )
   aAdd( aColTmpLin, { "nDto",    "N",    6,  2, "Descuento del producto",          "",         "", "( cDbfCol )" } )
   aAdd( aColTmpLin, { "nDtoPrm", "N",    6,  2, "Descuento de promoción",          "",         "", "( cDbfCol )" } )
   aAdd( aColTmpLin, { "cUnidad", "C",    2,  0, "Unidad de medición",              "",         "", "( cDbfCol )" } )
   aAdd( aColTmpLin, { "lLote",   "L",    1,  0, "",                                "",         "", "( cDbfCol )" } )
   aAdd( aColTmpLin, { "nLote",   "N",    9,  0, "",                                "",         "", "( cDbfCol )" } )
   aAdd( aColTmpLin, { "cLote",   "C",   14,  0, "Número de lote",                  "",         "", "( cDbfCol )" } )
   aAdd( aColTmpLin, { "mObsLin", "M",   10,  0, "Observaciones de lineas",         "",         "", "( cDbfCol )" } )
   aAdd( aColTmpLin, { "cRefPrv", "C",   18,  0, "Referencia proveedor",            "",         "", "( cDbfCol )" } )
   aAdd( aColTmpLin, { "cUnidad", "C",    2,  0, "Unidad de medición",              "",         "", "( cDbfCol )" } )
   aAdd( aColTmpLin, { "nMedUno", "N",   16,  6, "Primera unidad de medición",      "MasUnd()", "", "( cDbfCol )" } )
   aAdd( aColTmpLin, { "nMedDos", "N",   16,  6, "Segunda unidad de medición",      "MasUnd()", "", "( cDbfCol )" } )
   aAdd( aColTmpLin, { "nMedTre", "N",   16,  6, "Tercera unidad de medición",      "MasUnd()", "", "( cDbfCol )" } )
   aAdd( aColTmpLin, { "nNumLin", "N",    4,  0, "Número de línea",      			   "", 		   "", "( cDbfCol )" } )

return ( aColTmpLin )

//---------------------------------------------------------------------------//

function aColTmpFin()

   local aColTmpFin  := {}

   aAdd( aColTmpFin, { "cSerie",  "C",    1,  0, "Serie del documento",             "",  "", "( cDbfCol )" } )
   aAdd( aColTmpFin, { "nNumero", "N",    9,  0, "Número del documento",            "",  "", "( cDbfCol )" } )
   aAdd( aColTmpFin, { "cSufijo", "C",    2,  0, "Sufijo del documento",            "",  "", "( cDbfCol )" } )
   aAdd( aColTmpFin, { "dFecDoc", "D",    8,  0, "Fecha del documento",             "",  "", "( cDbfCol )" } )
   aAdd( aColTmpFin, { "cCodPrv", "C",   12,  0, "Código de proveedor",             "",  "", "( cDbfCol )" } )
   aAdd( aColTmpFin, { "cNomPrv", "C",   30,  0, "Nombre de proveedor",             "",  "", "( cDbfCol )" } )

return ( aColTmpFin )

//---------------------------------------------------------------------------//

FUNCTION BrwArtPed( aGet, dbfTmpPedLin, cdbfDiv, cdbfIva )

	local oDlg
	local oBrw
	local oGet1
	local cGet1
	local oCbxOrd
   local cCbxOrd     := "Código"
   local aCbxOrd     := { "Código", "Nombre" }
   local nRecAnt     := ( dbfTmpPedLin )->( recno() )
   local nOrdAnt     := ( dbfTmpPedLin )->( OrdSetFocus( 1 ) )

   ( dbfTmpPedLin )->( DbGoTop() )

   DEFINE DIALOG oDlg RESOURCE "HELPENTRY" TITLE "Artículos"

      REDEFINE GET oGet1 VAR cGet1;
			ID 		104 ;
         ON CHANGE( AutoSeek( nKey, nFlags, Self, oBrw, dbfTmpPedLin, .t. ) );
         VALID    ( OrdClearScope( oBrw, dbfTmpPedLin ) );
			PICTURE	"@!" ;
         BITMAP   "FIND" ;
         OF       oDlg

		REDEFINE COMBOBOX oCbxOrd ;
			VAR 		cCbxOrd ;
			ID 		102 ;
         ITEMS    aCbxOrd ;
         ON CHANGE( ( dbfTmpPedLin )->( OrdSetFocus( oCbxOrd:nAt ) ), oBrw:refresh(), oGet1:SetFocus() ) ;
			OF oDlg

      REDEFINE LISTBOX oBrw ;
			FIELDS ;
                  (dbfTmpPedLin)->cRef,;
                  (dbfTmpPedLin)->cDetalle;
         HEAD;
                  "Código" ,;
                  "Nombre";
         FIELDSIZES ;
                  90 ,;
                  300;
         ALIAS    ( dbfTmpPedLin );
         ID       105 ;
         OF       oDlg

         oBrw:aActions     := {| nCol | lPressCol( nCol, oBrw, oCbxOrd, aCbxOrd, dbfTmpPedLin ) }
         oBrw:aJustify     := { .f., .f. }
         oBrw:bLDblClick   := {|| oDlg:end( IDOK ) }

      REDEFINE BUTTON ;
         ID       500 ;
			OF 		oDlg ;
         WHEN     ( .f. );
         ACTION   ( oDlg:end() )

      REDEFINE BUTTON ;
         ID       501 ;
			OF 		oDlg ;
         WHEN     ( .f. );
         ACTION   ( oDlg:end() )

      REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
         ACTION   ( oDlg:end( IDOK ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
         ACTION   ( oDlg:end() )

   oDlg:AddFastKey( VK_F5, {|| oDlg:end( IDOK ) } )
   oDlg:AddFastKey( VK_RETURN, {|| oDlg:end( IDOK ) } )

   ACTIVATE DIALOG oDlg CENTER

   if oDlg:nResult == IDOK
      aGet:cText( ( dbfTmpPedLin )->cRef )
      aGet:lValid()
   end if

   ( dbfTmpPedLin )->( OrdSetFocus( nOrdAnt ) )
   ( dbfTmpPedLin )->( dbGoTo( nRecAnt ) )

RETURN oDlg:nResult == IDOK

//---------------------------------------------------------------------------//

Function AppPedCli( cCodCli, cCodArt, lOpenBrowse )

   local nLevel         := Auth():Level( _MENUITEM_ )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) == 0 .or. nAnd( nLevel, ACC_APPD ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if lOpenBrowse

      if PedCli( nil, nil, cCodCli, cCodArt )
         oWndBrw:RecAdd()
      end if

   else

      if OpenFiles( .t. )
         nTotPedCli()
         WinAppRec( nil, bEdtRec, D():PedidosClientes( nView ), cCodCli, cCodArt )
         CloseFiles()
      end if

   end if

RETURN .t.

//----------------------------------------------------------------------------//

Function EdtPedCli( cNumPed, lOpenBrowse )

   local nLevel         := Auth():Level( _MENUITEM_ )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) == 0 .or. nAnd( nLevel, ACC_EDIT ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if lOpenBrowse

      if PedCli()
         if dbSeekInOrd( cNumPed, "nNumPed", D():PedidosClientes( nView ) )
            oWndBrw:RecEdit()
         else
            MsgStop( "No se encuentra pedido" )
         end if
      end if

   else

      if OpenFiles( .t. )

         if dbSeekInOrd( cNumPed, "nNumPed", D():PedidosClientes( nView ) )
            nTotPedCli()
            WinEdtRec( nil, bEdtRec, D():PedidosClientes( nView ) )
         end if

         CloseFiles()

      end if

   end if

Return .t.

//----------------------------------------------------------------------------//

FUNCTION ZooPedCli( cNumPed, lOpenBrowse )

   local nLevel         := Auth():Level( _MENUITEM_ )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) == 0 .or. nAnd( nLevel, ACC_ZOOM ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if lOpenBrowse

      if PedCli()
         if dbSeekInOrd( cNumPed, "nNumPed", D():PedidosClientes( nView ) )
            oWndBrw:RecZoom()
         else
            MsgStop( "No se encuentra pedido" )
         end if
      end if

   else

      if OpenFiles( .t. )

         if dbSeekInOrd( cNumPed, "nNumPed", D():PedidosClientes( nView ) )
            nTotPedCli()
            WinZooRec( nil, bEdtRec, D():PedidosClientes( nView ) )
         end if

         CloseFiles()

      end if

   end if

Return .t.

//----------------------------------------------------------------------------//

FUNCTION DelPedCli( cNumPed, lOpenBrowse )

   local nLevel         := Auth():Level( _MENUITEM_ )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) == 0 .or. nAnd( nLevel, ACC_DELE ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if lOpenBrowse

      if PedCli()
         if dbSeekInOrd( cNumPed, "nNumPed", D():PedidosClientes( nView ) )
            WinDelRec( nil, D():PedidosClientes( nView ), {|| QuiPedCli() } )
         else
            MsgStop( "No se encuentra pedido" )
         end if
      end if

   else

      if OpenFiles( .t. )

         if dbSeekInOrd( cNumPed, "nNumPed", D():PedidosClientes( nView ) )
            nTotPedCli()
            WinDelRec( nil, D():PedidosClientes( nView ), {|| QuiPedCli() } )
         end if

         CloseFiles()

      end if

   end if

Return .t.

//----------------------------------------------------------------------------//

FUNCTION PrnPedCli( cNumPed, lOpenBrowse )

   local nLevel         := Auth():Level( _MENUITEM_ )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) == 0 .or. nAnd( nLevel, ACC_IMPR ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if lOpenBrowse

      if PedCli()
         if dbSeekInOrd( cNumPed, "nNumPed", D():PedidosClientes( nView ) )
            ImprimirSeriesPedidosClientes( IS_PRINTER, .t. )
            //GenPedCli( IS_PRINTER )
         else
            MsgStop( "No se encuentra pedido" )
         end if
      end if

   else

      if OpenFiles( .t. )

         if dbSeekInOrd( cNumPed, "nNumPed", D():PedidosClientes( nView ) )
            nTotPedCli()
            ImprimirSeriesPedidosClientes( IS_PRINTER, .t. )
            //GenPedCli( IS_PRINTER )
         end if

         CloseFiles()

      end if

   end if

Return .t.

//---------------------------------------------------------------------------//

FUNCTION VisPedCli( cNumPed, lOpenBrowse )

   local nLevel         := Auth():Level( _MENUITEM_ )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) == 0 .or. nAnd( nLevel, ACC_IMPR ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if lOpenBrowse

      if PedCli()
         if dbSeekInOrd( cNumPed, "nNumPed", D():PedidosClientes( nView ) )
            ImprimirSeriesPedidosClientes( IS_SCREEN, .t. )
            //GenPedCli( IS_SCREEN )
         else
            MsgStop( "No se encuentra pedido" )
         end if
      end if

   else

      if OpenFiles( .t. )

         if dbSeekInOrd( cNumPed, "nNumPed", D():PedidosClientes( nView ) )
            nTotPedCli()
            ImprimirSeriesPedidosClientes( IS_SCREEN, .t. )
            //GenPedCli( IS_SCREEN )
         end if

         CloseFiles()

      end if

   end if

Return .t.

//---------------------------------------------------------------------------//

FUNCTION visualizaPedidoCliente( cNumeroPedido, cFormatoDocumento )

   local nLevel         := Auth():Level( _MENUITEM_ )

   if nAnd( nLevel, 1 ) == 0 .or. nAnd( nLevel, ACC_IMPR ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if OpenFiles( .t. )

      if dbSeekInOrd( cNumeroPedido, "nNumPed", D():PedidosClientes( nView ) )
         nTotPedCli()
         genPedCli( IS_SCREEN, nil, cFormatoDocumento )
      else
         msgStop( "Número de pedido " + alltrim(  cNumeroPedido ) + " no encontrado" )
      end if

      CloseFiles()

   end if

Return .t.

//---------------------------------------------------------------------------//

FUNCTION imprimePedidoCliente( cNumeroPedido, cFormatoDocumento )

   local nLevel         := Auth():Level( _MENUITEM_ )

   if nAnd( nLevel, 1 ) == 0 .or. nAnd( nLevel, ACC_IMPR ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if OpenFiles( .t. )

      if dbSeekInOrd( cNumeroPedido, "nNumPed", D():PedidosClientes( nView ) )

         nTotPedCli()

         genPedCli( IS_PRINTER, nil, cFormatoDocumento )

      else

         msgStop( "Número de pedido " + alltrim(  cNumeroPedido ) + " no encontrado" )

      end if

      CloseFiles()

   end if

Return .t.

//---------------------------------------------------------------------------//

FUNCTION PrnEntPed( cNumEnt, lPrint, dbfPedCliP )

   local nLevel         := Auth():Level( _MENUITEM_ )

   if nAnd( nLevel, 1 ) == 0 .or. nAnd( nLevel, ACC_IMPR ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if OpenFiles( .t. )

      if dbSeekInOrd( cNumEnt, "nNumPed", dbfPedCliP )
         PrnEntregas( lPrint, dbfPedCliP )
      end if

      CloseFiles()

   end if

Return .t.

//---------------------------------------------------------------------------//

function nTotReserva( cCodArt )

   local nTotal := 0

   ( D():PedidosClientesReservas( nView ) )->( ordsetfocus( "cRef" ) )

   if ( D():PedidosClientesReservas( nView ) )->( dbseek( cCodArt ) )

      while ( D():PedidosClientesReservas( nView ) )->cRef == cCodArt .and. ! ( D():PedidosClientesReservas( nView ) )->( eof() )

         nTotal += nUnidadesReservadasEnPedidosCliente( D():PedidosClientesReservasId( nView ), ( D():PedidosClientesReservas( nView ) )->cRef, ( D():PedidosClientesReservas( nView ) )->cValPr1, ( D():PedidosClientesReservas( nView ) )->cValPr2, D():PedidosClientesReservas( nView ) )

         ( D():PedidosClientesReservas( nView ) )->( dbskip() )

      end while

   end if

return ( nTotal )

//---------------------------------------------------------------------------//
//
// NOTA: Esta funcion se utiliza para el estado de recibido de pedidos de clientes
//

function nEstadoUnidadesRecibidasPedidosClientes( cPedPrvL, cAlbPrvL, cTmpLin )

   local nTotUni
   local nEstado     := 3
   local nTotRec     := 0

   nTotUni           := nTotNPedCli( cTmpLin )

   if nTotUni == 0
      Return ( nEstado )
   end if 

   nTotRec           := nTotalUnidadesRecibidasPedidosProveedor( cPedPrvL, cAlbPrvL, cTmpLin )

   do case
      case nTotRec == 0
         nEstado     := 1
      case nTotRec < nTotUni
         nEstado     := 2
      case nTotRec >= nTotUni
         nEstado     := 3
   end case

Return ( nEstado )

//---------------------------------------------------------------------------//

Static Function nTotalUnidadesRecibidasPedidosProveedor( cPedPrvL, cAlbPrvL, cTmpLin )

   local nOrden
   local nUnidadesRecibidas   := 0

   nOrden                     := ( cPedPrvL )->( ordsetfocus( "cPedCliRef" ) )
   if ( cPedPrvL )->( dbseek( ( cTmpLin )->cSerPed + Str( ( cTmpLin )->nNumPed ) + ( cTmpLin )->cSufPed + ( cTmpLin )->cRef + ( cTmpLin )->cValPr1 + ( cTmpLin )->cValPr2 ) )
      nUnidadesRecibidas      := nUnidadesRecibidasPedPrv( ( cPedPrvL )->cSerPed + Str( ( cPedPrvL )->nNumPed ) + ( cPedPrvL )->cSufPed, ( cTmpLin)->cRef, ( cTmpLin )->cValPr1, ( cTmpLin )->cValPr2, ( cTmpLin )->cRefPrv, cAlbPrvL )
   end if
   ( cPedPrvL )->( ordsetfocus( nOrden ) )

Return ( nUnidadesRecibidas )

//---------------------------------------------------------------------------//

//
// NOTA: Esta funcion se utiliza para el estado de recibido de pedidos de clientes
//

function nEstadoUnidadesEntregadasPedidosClientes( cTmpLin, cAlbCliL )

   local nEstado              := 1
   local nUnidadesPedidas     := nTotNPedCli( cTmpLin )
   local nUnidadesRecibidas   := nUnidadesRecibidasAlbaranesClientes( ( dbfTmpLin )->cSerPed + Str( ( dbfTmpLin )->nNumPed ) + ( dbfTmpLin )->cSufPed, ( dbfTmpLin )->cRef, ( dbfTmpLin )->cValPr1, ( dbfTmpLin )->cValPr2, cAlbCliL )

   do case
      case nUnidadesRecibidas == 0
         nEstado              := 1
      case nUnidadesRecibidas < nUnidadesPedidas
         nEstado              := 2
      case nUnidadesRecibidas >= nUnidadesPedidas
         nEstado              := 3
   end case

Return ( nEstado )

//---------------------------------------------------------------------------//

Function DesignReportPedCli( oFr, dbfDoc )

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
                                                   "   CallHbFunc('nTotPedCli');"                              + Chr(13) + Chr(10) + ;
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
         oFr:SetObjProperty(  "MasterData",  "DataSet", "Pedidos" )

         oFr:AddBand(         "DetalleColumnas",   "MainPage", frxDetailData  )
         oFr:SetProperty(     "DetalleColumnas",   "Top", 230 )
         oFr:SetProperty(     "DetalleColumnas",   "Height", 28 )
         oFr:SetObjProperty(  "DetalleColumnas",   "DataSet", "Lineas de pedidos" )
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

Function mailReportPedCli( cCodigoDocumento )

Return ( printReportPedCli( IS_MAIL, 1, prnGetName(), cCodigoDocumento ) )

//---------------------------------------------------------------------------//

Static Function printReportPedCli( nDevice, nCopies, cPrinter, cCodigoDocumento )

   local oFr
   local cFilePdf             := cPatTmp() + "PedidoCliente" + StrTran( ( D():PedidosClientes( nView ) )->cSerPed + Str( ( D():PedidosClientes( nView ) )->nNumPed ) + ( D():PedidosClientes( nView ) )->cSufPed, " ", "" ) + ".Pdf"
   local nOrd

   DEFAULT nDevice            := IS_SCREEN
   DEFAULT nCopies            := 1
   DEFAULT cPrinter           := PrnGetName()
   DEFAULT cCodigoDocumento   := cFormatoPedidosClientes()   

   if empty( cCodigoDocumento )
      msgStop( "El código del documento esta vacio" )
      Return ( nil )
   end if 

   SysRefresh()

   nOrd 								:= ( D():PedidosClientesLineas( nView ) )->( ordSetFocus( "nPosPrint" ) )

   oFr                        := frReportManager():New()

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

   ( D():PedidosClientesLineas( nView ) )->( ordSetFocus( nOrd ) )

Return ( cFilePdf )

//---------------------------------------------------------------------------//

Function DesignReportEntPedCli( oFr, dbfDoc )

   if OpenFiles()

      /*
      Zona de datos------------------------------------------------------------
      */

      DataReportEntPedCli( oFr )

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
                                                   "CallHbFunc('nTotPedCli');"                                 + Chr(13) + Chr(10) + ;
                                                   "end;"                                                      + Chr(13) + Chr(10) + ;
                                                   "begin"                                                     + Chr(13) + Chr(10) + ;
                                                   "end." )

         oFr:AddPage(         "MainPage" )

         oFr:SetProperty(     "MainPage",          "OnBeforePrint", "DetalleOnMasterDetail" )

         oFr:AddBand(         "CuerpoDocumento",   "MainPage", frxPageHeader )
         oFr:SetProperty(     "CuerpoDocumento",   "Top", 0 )
         oFr:SetProperty(     "CuerpoDocumento",   "Height", 300 )

         oFr:AddBand(         "MasterData",  "MainPage", frxMasterData )
         oFr:SetProperty(     "MasterData",  "Top", 300 )
         oFr:SetProperty(     "MasterData",  "Height", 0 )
         oFr:SetProperty(     "MasterData",  "StartNewPage", .t. )
         oFr:SetObjProperty(  "MasterData",  "DataSet", "Entrega" )

      end if

      /*
      Zona de variables--------------------------------------------------------
      */

      VariableReportEntPedCli( oFr )

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

Function PrintReportEntPedCli( nDevice, nCopies, cPrinter, dbfDoc, cPedCliP )

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

   DataReportEntPedCli( oFr, cPedCliP )

   /*
   Cargar el informe-----------------------------------------------------------
   */

   if !Empty( ( dbfDoc )->mReport )

      oFr:LoadFromBlob( ( dbfDoc )->( Select() ), "mReport")

      /*
      Zona de variables--------------------------------------------------------
      */

      VariableReportEntPedCli( oFr )

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

FUNCTION IsPedCli( cPath )

   DEFAULT cPath  := cPatEmp()

   if !lExistTable( cPath + "PedCliT.Dbf" )
      dbCreate( cPath + "PedCliT.Dbf", aSqlStruct( aItmPedCli() ), cDriver() )
   end if

   if !lExistTable( cPath + "PedCliL.Dbf" )
      dbCreate( cPath + "PedCliL.Dbf", aSqlStruct( aColPedCli() ), cDriver() )
   end if

   if !lExistTable( cPath + "PedCliR.DBF" )
      dbCreate( cPath + "PedCliR.Dbf", aSqlStruct( aPedCliRes() ), cDriver() )
   end if

   if !lExistTable( cPath + "PedCliI.Dbf" )
      dbCreate( cPath + "PedCliI.Dbf", aSqlStruct( aIncPedCli() ), cDriver() )
   end if

   if !lExistTable( cPath + "PedCliD.Dbf" )
      dbCreate( cPath + "PedCliD.Dbf", aSqlStruct( aPedCliDoc() ), cDriver() )
   end if

   if !lExistTable( cPath + "PedCliP.Dbf" )
      dbCreate( cPath + "PedCliP.Dbf", aSqlStruct( aPedCliPgo() ), cDriver() )
   end if

   if !lExistTable( cPath + "PedCliE.Dbf" )
      dbCreate( cPath + "PedCliE.Dbf", aSqlStruct( aPedCliEst() ), cDriver() )
   end if

   if !lExistIndex( cPath + "PedCliT.Cdx" ) .or. ;
      !lExistIndex( cPath + "PedCliL.Cdx" ) .or. ;
      !lExistIndex( cPath + "PedCliR.Cdx" ) .or. ;
      !lExistIndex( cPath + "PedCliI.Cdx" ) .or. ;
      !lExistIndex( cPath + "PedCliP.Cdx" ) .or. ;
      !lExistTable( cPath + "PedCliD.Cdx" ) .or. ;
      !lExistTable( cPath + "PedCliE.Cdx" )

      rxPedCli( cPath )

   end if

Return ( nil )

//---------------------------------------------------------------------------//

FUNCTION mkPedCli( cPath, lAppend, cPathOld, oMeter, bFor )

   local oldPedCliT
   local oldPedCliL
   local oldPedCliI
   local oldPedCliD
   local oldPedCliP
   local oldAlbCliT
   local oldAlbCliL
   local oldPedCliE

   DEFAULT cPath     := cPatEmp()
   DEFAULT lAppend   := .f.
   DEFAULT bFor      := {|| .t. }

	IF oMeter != NIL
		oMeter:cText	:= "Generando Bases"
		sysrefresh()
	END IF

   createFiles( cPath )

   rxPedCli( cPath, cLocalDriver() )

   IF lAppend .and. lIsDir( cPathOld )

      dbUseArea( .t., cDriver(), cPath + "PEDCLIT.DBF", cCheckArea( "PEDCLIT", @dbfPedCliT ), .f. )
      ( dbfPedCliT )->( ordListAdd( cPath + "PedCliT.Cdx" ) )

      dbUseArea( .t., cDriver(), cPath + "PEDCLIL.DBF", cCheckArea( "PEDCLIL", @dbfPedCliL ), .f. )
      ( dbfPedCliL )->( ordListAdd( cPath + "PedCliL.Cdx" ) )

      dbUseArea( .t., cDriver(), cPath + "PedCliI.Dbf", cCheckArea( "PedCliI", @dbfPedCliI ), .f. )
      ( dbfPedCliI )->( ordListAdd( cPath + "PedCliI.Cdx" ) )

      dbUseArea( .t., cDriver(), cPath + "PedCliD.Dbf", cCheckArea( "PedCliD", @dbfPedCliD ), .f. )
      ( dbfPedCliD )->( ordListAdd( cPath + "PedCliD.Cdx" ) )

      dbUseArea( .t., cDriver(), cPath + "PedCliP.Dbf", cCheckArea( "PedCliP", @dbfPedCliP ), .f. )
      ( dbfPedCliP )->( ordListAdd( cPath + "PedCliP.Cdx" ) )

      dbUseArea( .t., cDriver(), cPathOld + "PedCliT.Dbf", cCheckArea( "PEDCLIT", @oldPedCliT ), .f. )
      ( oldPedCliT )->( ordListAdd( cPathOld + "PedCliT.Cdx" ) )

      dbUseArea( .t., cDriver(), cPathOld + "PEDCLIL.DBF", cCheckArea( "PEDCLIL", @oldPedCliL ), .f. )
      ( oldPedCliL )->( ordListAdd( cPathOld + "PEDCLIL.CDX" ) )

      dbUseArea( .t., cDriver(), cPathOld + "PEDCLII.DBF", cCheckArea( "PEDCLII", @oldPedCliI ), .f. )
      ( oldPedCliI )->( ordListAdd( cPathOld + "PEDCLII.CDX" ) )

      dbUseArea( .t., cDriver(), cPathOld + "PEDCLID.DBF", cCheckArea( "PEDCLID", @oldPedCliD ), .f. )
      ( oldPedCliD )->( ordListAdd( cPathOld + "PEDCLID.CDX" ) )

      dbUseArea( .t., cDriver(), cPathOld + "PEDCLIP.DBF", cCheckArea( "PEDCLIP", @oldPedCliP ), .f. )
      ( oldPedCliP )->( ordListAdd( cPathOld + "PEDCLIP.CDX" ) )

      dbUseArea( .t., cDriver(), cPathOld + "AlbCliT.DBF", cCheckArea( "AlbCliT", @oldAlbCliT ), .f. )
      ( oldAlbCliT )->( ordListAdd( cPathOld + "AlbCliT.CDX" ) )

      dbUseArea( .t., cDriver(), cPathOld + "AlbCliL.DBF", cCheckArea( "AlbCliL", @oldAlbCliL ), .f. )
      ( oldAlbCliL )->( ordListAdd( cPathOld + "AlbCliL.CDX" ) )

      dbUseArea( .t., cDriver(), cPathOld + "PedCliE.DBF", cCheckArea( "PedCliE", @oldPedCliE ), .f. )
      ( oldPedCliE )->( ordListAdd( cPathOld + "PedCliE.CDX" ) )

      while !( oldPedCliT )->( eof() )

         if eval( bFor, oldPedCliT )

            dbCopy( oldPedCliT, dbfPedCliT, .t. )

            if ( dbfPedCliT )->( dbRLock() )
               ( dbfPedCliT )->cTurPed    := Padl( "1", 6 )
               ( dbfPedCliT )->( dbRUnlock() )
            end if

            if ( oldPedCliL )->( dbSeek( ( oldPedCliT )->cSerPed + Str( ( oldPedCliT )->NNUMPED ) + ( oldPedCliT )->CSUFPED ) )
               while ( oldPedCliL )->cSerPed + Str( ( oldPedCliL )->NNUMPED ) + ( oldPedCliL )->CSUFPED == ( oldPedCliT )->cSerPed + Str( ( oldPedCliT )->NNUMPED ) + ( oldPedCliT )->CSUFPED .and. !( oldPedCliL )->( eof() )

                  //if nTotNPedCli( oldPedCliL ) > 0
                  dbCopy( oldPedCliL, dbfPedCliL, .t. )
                  ( dbfPedCliL )->nUniCaja   := nTotNPedCli( oldPedCliL )
                  ( dbfPedCliL )->nUniCaja   -= nUnidadesRecibidasAlbaranesClientes( ( oldPedCliL )->cSerPed + Str( ( oldPedCliL )->nNumPed ) + ( oldPedCliL )->cSufPed, ( oldPedCliL )->cRef, ( oldPedCliL )->cValPr1, ( oldPedCliL )->cValPr2, oldAlbCliL )
                  ( dbfPedCliL )->nUniEnt    := 0
                  //end if

                  ( oldPedCliL )->( dbSkip() )

               end while
            end if

            if ( oldPedCliI )->( dbSeek( ( oldPedCliT )->cSerPed + Str( ( oldPedCliT )->NNUMPED ) + ( oldPedCliT )->CSUFPED ) )
               while ( oldPedCliI )->cSerPed + Str( ( oldPedCliI )->nNumPed ) + ( oldPedCliI )->cSufPed == ( oldPedCliT )->cSerPed + Str( ( oldPedCliT )->nNumPed ) + ( oldPedCliT )->cSufPed .and. !( oldPedCliI )->( eof() )

                  dbCopy( oldPedCliI, dbfPedCliI, .t. )
                  ( oldPedCliI )->( dbSkip() )

               end while
            end if

            if ( oldPedCliD )->( dbSeek( ( oldPedCliT )->cSerPed + Str( ( oldPedCliT )->NNUMPED ) + ( oldPedCliT )->CSUFPED ) )
               while ( oldPedCliD )->cSerPed + Str( ( oldPedCliD )->nNumPed ) + ( oldPedCliD )->cSufPed == ( oldPedCliT )->cSerPed + Str( ( oldPedCliT )->nNumPed ) + ( oldPedCliT )->cSufPed .and. !( oldPedCliD )->( eof() )

                  dbCopy( oldPedCliD, dbfPedCliD, .t. )
                  ( oldPedCliD )->( dbSkip() )

               end while
            end if

            if ( oldPedCliP )->( dbSeek( ( oldPedCliT )->cSerPed + Str( ( oldPedCliT )->NNUMPED ) + ( oldPedCliT )->CSUFPED ) )
               while ( oldPedCliP )->cSerPed + Str( ( oldPedCliP )->nNumPed ) + ( oldPedCliP )->cSufPed == ( oldPedCliT )->cSerPed + Str( ( oldPedCliT )->nNumPed ) + ( oldPedCliT )->cSufPed .and. !( oldPedCliP )->( eof() )

                  dbCopy( oldPedCliP, dbfPedCliP, .t. )
                  ( oldPedCliP )->( dbSkip() )

               end while
            end if

         end if

         SysRefresh()

         ( oldPedCliT )->( dbSkip() )

      end while

      ( dbfPedCliT )->( dbCloseArea() )
      ( dbfPedCliL )->( dbCloseArea() )
      ( dbfPedCliI )->( dbCloseArea() )
      ( dbfPedCliD )->( dbCloseArea() )
      ( dbfPedCliP )->( dbCloseArea() )

      ( oldPedCliT )->( dbCloseArea() )
      ( oldPedCliL )->( dbCloseArea() )
      ( oldPedCliI )->( dbCloseArea() )
      ( oldPedCliD )->( dbCloseArea() )
      ( oldPedCliP )->( dbCloseArea() )
      ( oldPedCliE )->( dbCloseArea() )

      ( oldAlbCliT )->( dbCloseArea() )
      ( oldAlbCliL )->( dbCloseArea() )

	END IF

RETURN .t.

//---------------------------------------------------------------------------//

FUNCTION rxPedCli( cPath, cDriver )

	local cPedCliT

   DEFAULT cPath     := cPatEmp()
   DEFAULT cDriver   := cDriver()

   if !lExistTable( cPath + "PedCliT.Dbf", cDriver ) .or. ;
      !lExistTable( cPath + "PedCliL.Dbf", cDriver ) .or. ;
      !lExistTable( cPath + "PedCliR.Dbf", cDriver ) .or. ;
      !lExistTable( cPath + "PedCliI.Dbf", cDriver ) .or. ;
      !lExistTable( cPath + "PedCliD.Dbf", cDriver ) .or. ;
      !lExistTable( cPath + "PedCliP.Dbf", cDriver ) .or. ;
      !lExistTable( cPath + "PedCliE.Dbf", cDriver )

      CreateFiles( cPath )

   end if

   fEraseIndex( cPath + "PedCliT.Cdx", cDriver )
   fEraseIndex( cPath + "PedCliL.Cdx", cDriver )
   fEraseIndex( cPath + "PedCliR.Cdx", cDriver )
   fEraseIndex( cPath + "PedCliI.Cdx", cDriver )
   fEraseIndex( cPath + "PedCliD.Cdx", cDriver )
   fEraseIndex( cPath + "PedCliP.Cdx", cDriver )
   fEraseIndex( cPath + "PedCliE.Cdx", cDriver )

   dbUseArea( .t., cDriver, cPath + "PEDCLIT.DBF", cCheckArea( "PEDCLIT", @cPedCliT ), .f. )
   if !( cPedCliT )->( neterr() )
      ( cPedCliT )->( __dbPack() )

      ( cPedCliT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cPedCliT )->( ordCreate( cPath + "PEDCLIT.CDX", "NNUMPED", "Field->CSERPED + STR( Field->NNUMPED ) + Field->CSUFPED", {|| Field->CSERPED + STR( Field->NNUMPED ) + Field->CSUFPED } ) )

      ( cPedCliT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cPedCliT )->( ordCreate( cPath + "PEDCLIT.CDX", "DFECPED", "Field->DFECPED", {|| Field->DFECPED } ) )

      ( cPedCliT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cPedCliT )->( ordCreate( cPath + "PEDCLIT.CDX", "CCODCLI", "Field->CCODCLI", {|| Field->CCODCLI } ) )

      ( cPedCliT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cPedCliT )->( ordCreate( cPath + "PEDCLIT.CDX", "CNOMCLI", "Upper( Field->CNOMCLI )", {|| Upper( Field->CNOMCLI ) } ) )

      ( cPedCliT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cPedCliT )->( ordCreate( cPath + "PEDCLIT.CDX", "cCodObr", "Field->cCodObr + Dtos( Field->dFecPed )", {|| Field->cCodObr + Dtos( Field->dFecPed ) } ) )

      ( cPedCliT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cPedCliT )->( ordCreate( cPath + "PEDCLIT.CDX", "cCodAge", "Field->cCodAge + Dtos( Field->dFecPed )", {|| Field->cCodAge + Dtos( Field->dFecPed ) } ) )

      ( cPedCliT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cPedCliT )->( ordCreate( cPath + "PEDCLIT.CDX", "dFecEnt", "Dtos( Field->dFecEnt )", {|| Dtos( Field->dFecEnt ) } ) )

      ( cPedCliT )->( ordCondSet( "!Deleted() .and. lInternet", {||!Deleted() .and. Field->lInternet } ) )
      ( cPedCliT )->( ordCreate( cPath + "ped.Cdx", "lInternet", "Dtos( Field->dFecCre ) + Field->cTimCre", {|| Dtos( Field->dFecCre ) + Field->cTimCre } ) )

      ( cPedCliT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cPedCliT )->( ordCreate( cPath + "PEDCLIT.CDX", "CTURPED", "Field->CTURPED + Field->CSUFPED + Field->CCODCAJ", {|| Field->CTURPED + Field->CSUFPED + Field->CCODCAJ} ) )

      ( cPedCliT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cPedCliT )->( ordCreate( cPath + "PEDCLIT.CDX", "cNumPre", "Field->cNumPre", {|| Field->cNumPre } ) )

      ( cPedCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() } ))
      ( cPedCliT )->( ordCreate( cPath + "PedCliT.Cdx", "lSndDoc", "Field->lSndDoc", {|| Field->lSndDoc } ) )

      ( cPedCliT )->( ordCondSet( "!Deleted()", {||!Deleted()}  ) )
      ( cPedCliT )->( ordCreate( cPath + "PedCliT.Cdx", "cCodUsr", "Field->cCodUsr + Dtos( Field->dFecCre ) + Field->cTimCre", {|| Field->cCodUsr + Dtos( Field->dFecCre ) + Field->cTimCre } ) )

      ( cPedCliT )->( ordCondSet( "!Deleted() .and. lInternet .and. nEstado != 3", {|| !Deleted() .and. Field->lInternet .and. Field->nEstado != 3 } ) )
      ( cPedCliT )->( ordCreate( cPath + "PedCliT.Cdx", "lIntPedCli", "Dtos( Field->dFecPed )", {|| Dtos( Field->dFecPed ) } ) )

      ( cPedCliT )->( ordCondSet( "!Deleted()", {||!Deleted()}  ) )
      ( cPedCliT )->( ordCreate( cPath + "PedCliT.Cdx", "cNumAlb", "Field->cNumAlb", {|| Field->cNumAlb } ) )

      ( cPedCliT )->( ordCondSet( "!Deleted()", {||!Deleted()}  ) )
      ( cPedCliT )->( ordCreate( cPath + "PedCliT.Cdx", "cCodWeb", "Str( Field->cCodWeb )", {|| Str( Field->cCodWeb ) } ) )

      ( cPedCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( cPedCliT )->( ordCreate( cPath + "PedCliT.Cdx", "iNumPed", "'09' + Field->cSerPed + Str( Field->nNumPed ) + Space( 1 ) + Field->cSufPed", {|| '09' + Field->cSerPed + Str( Field->nNumPed ) + Space( 1 ) + Field->cSufPed } ) )

      ( cPedCliT )->( ordCondSet( "!Deleted()", {||!Deleted()} ) )
      ( cPedCliT )->( ordCreate( cPath + "PedCliT.Cdx", "cSuPed", "Field->cSuPed", {|| Field->cSuPed } ) )

      ( cPedCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() }, , , , , , , , , .t. ) )
      ( cPedCliT )->( ordCreate( cPath + "PedCliT.Cdx", "dFecDes", "Field->dFecPed", {|| Field->dFecPed } ) )

      ( cPedCliT )->( ordCondSet( "!Deleted()", {||!Deleted()} ) )
      ( cPedCliT )->( ordCreate( cPath + "PedCliT.Cdx", "cSituac", "Field->cSituac", {|| Field->cSituac } ) )

      ( cPedCliT )->( ordCondSet( "!Deleted()", {||!Deleted()} ) )
      ( cPedCliT )->( ordCreate( cPath + "PedCliT.Cdx", "cSufPed", "Field->cSufPed", {|| Field->cSufPed } ) )

      ( cPedCliT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cPedCliT )->( ordCreate( cPath + "PedCliT.CDX", "Poblacion", "UPPER( Field->cPobCli )", {|| UPPER( Field->cPobCli ) } ) )

      ( cPedCliT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cPedCliT )->( ordCreate( cPath + "PedCliT.CDX", "Provincia", "UPPER( Field->cPrvCli )", {|| UPPER( Field->cPrvCli ) } ) )

      ( cPedCliT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cPedCliT )->( ordCreate( cPath + "PedCliT.CDX", "CodPostal", "Field->cPosCli", {|| Field->cPosCli } ) )

      ( cPedCliT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cPedCliT )->( ordCreate( cPath + "PedCliT.Cdx", "dFecGen", "dtos( Field->dFecPed ) + Field->cCodCli", {|| Dtos( Field->dFecPed ) + Field->cCodCli } ) )


      ( cPedCliT )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de pedidos de clientes" )
   end if

   dbUseArea( .t., cDriver, cPath + "PedCliL.DBF", cCheckArea( "PedCliL", @cPedCliT ), .f. )
   if !( cPedCliT )->( neterr() )
      ( cPedCliT )->( __dbPack() )

      ( cPedCliT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cPedCliT )->( ordCreate( cPath + "PedCliL.Cdx", "NNUMPED", "CSERPED + STR( NNUMPED ) + CSUFPED", {|| Field->CSERPED + STR( Field->NNUMPED ) + Field->CSUFPED } ) )

      ( cPedCliT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cPedCliT )->( ordCreate( cPath + "PedCliL.Cdx", "cRef", "cRef", {|| Field->CREF } ) )

      ( cPedCliT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cPedCliT )->( ordCreate( cPath + "PedCliL.Cdx", "Lote", "cLote", {|| Field->cLote } ) )

      ( cPedCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( cPedCliT )->( ordCreate( cPath + "PedCliL.Cdx", "iNumPed", "'09' + cSerPed + Str( nNumPed ) + Space( 1 ) + cSufPed + Str( nNumLin )", {|| '09' + Field->cSerPed + Str( Field->nNumPed ) + Space( 1 ) + Field->cSufPed + Str( Field->nNumLin ) } ) )

      ( cPedCliT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cPedCliT )->( ordCreate( cPath + "PedCliL.Cdx", "nPosPrint", "cSerPed + Str( nNumPed ) + cSufPed + Str( nPosPrint )", {|| Field->cSerPed + Str( Field->nNumPed ) + Field->cSufPed + Str( Field->nPosPrint )}, ) )

      // Albaranes no facturados-----------------------------------------------

      ( cPedCliT )->( ordCondSet( "nCtlStk < 2 .and. !Deleted()", {|| Field->nCtlStk < 2 .and. !Deleted() }, , , , , , , , , .t. ) )
      ( cPedCliT )->( ordCreate( cPath + "PedCliL.Cdx", "cStkFast", "cRef + cAlmLin", {|| Field->cRef + Field->cAlmLin } ) )

      ( cPedCliT )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de pedidos de clientes" )
   end if

   dbUseArea( .t., cDriver, cPath + "PEDCLIR.DBF", cCheckArea( "PEDCLIR", @cPedCliT ), .f. )
   if !( cPedCliT )->( neterr() )
      ( cPedCliT )->( __dbPack() )

      ( cPedCliT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cPedCliT )->( ordCreate( cPath + "PEDCLIR.CDX", "NNUMPED", "CSERPED + STR( NNUMPED ) + CSUFPED + CREF + CVALPR1 + CVALPR2", {|| Field->CSERPED + STR( Field->NNUMPED ) + Field->CSUFPED + Field->CREF + Field->CVALPR1 + Field->CVALPR2 } ) )

      ( cPedCliT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cPedCliT )->( ordCreate( cPath + "PEDCLIR.CDX", "CREF", "CREF + CVALPR1 + CVALPR2", {|| Field->CREF + Field->CVALPR1 + Field->CVALPR2 } ) )

      ( cPedCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( cPedCliT )->( ordCreate( cPath + "PedCliR.Cdx", "iNumPed", "'09' + cSerPed + Str( nNumPed ) + Space( 1 ) + cSufPed", {|| '09' + Field->cSerPed + Str( Field->nNumPed ) + Space( 1 ) + Field->cSufPed } ) )

      ( cPedCliT )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de pedidos de clientes" )
   end if

   dbUseArea( .t., cDriver, cPath + "PedCliI.DBF", cCheckArea( "PedCliI", @cPedCliT ), .f. )
   if !( cPedCliT )->( neterr() )
      ( cPedCliT )->( __dbPack() )

      ( cPedCliT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cPedCliT )->( ordCreate( cPath + "PedCliI.CDX", "NNUMPED", "CSERPED + STR( NNUMPED ) + CSUFPED", {|| Field->CSERPED + STR( Field->NNUMPED ) + Field->CSUFPED } ) )

      ( cPedCliT )->( ordCondSet("!Deleted() .and. !lSndWeb ", {||!Deleted() .and. !Field->lSndWeb }  ) )
      ( cPedCliT )->( ordCreate( cPath + "PedCliI.CDX", "lSndWeb", "CSERPED + STR( NNUMPED ) + CSUFPED", {|| Field->CSERPED + STR( Field->NNUMPED ) + Field->CSUFPED } ) )

      ( cPedCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( cPedCliT )->( ordCreate( cPath + "PedCliI.Cdx", "iNumPed", "'09' + cSerPed + Str( nNumPed ) + Space( 1 ) + cSufPed", {|| '09' + Field->cSerPed + Str( Field->nNumPed ) + Space( 1 ) + Field->cSufPed } ) )

      ( cPedCliT )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de pedidos de clientes" )
   end if

   dbUseArea( .t., cDriver, cPath + "PedCliD.DBF", cCheckArea( "PedCliD", @cPedCliT ), .f. )

   if !( cPedCliT )->( neterr() )

      ( cPedCliT )->( __dbPack() )

      ( cPedCliT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cPedCliT )->( ordCreate( cPath + "PedCliD.CDX", "NNUMPED", "CSERPED + STR( NNUMPED ) + CSUFPED", {|| Field->CSERPED + STR( Field->NNUMPED ) + Field->CSUFPED } ) )

      ( cPedCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( cPedCliT )->( ordCreate( cPath + "PedCliD.Cdx", "iNumPed", "'09' + cSerPed + Str( nNumPed ) + Space( 1 ) + cSufPed", {|| '09' + Field->cSerPed + Str( Field->nNumPed ) + Space( 1 ) + Field->cSufPed } ) )

      ( cPedCliT )->( dbCloseArea() )

   else

      msgStop( "Imposible abrir en modo exclusivo la tabla de pedidos de clientes" )

   end if

   dbUseArea( .t., cDriver, cPath + "PedCliP.DBF", cCheckArea( "PedCliP", @cPedCliT ), .f. )

   if !( cPedCliT )->( neterr() )

      ( cPedCliT )->( __dbPack() )

      ( cPedCliT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cPedCliT )->( ordCreate( cPath + "PedCliP.Cdx", "nNumPed", "cSerPed + Str( nNumPed ) + cSufPed + Str( nNumRec )", {|| Field->cSerPed + Str( Field->nNumPed ) + Field->cSufPed + Str( Field->nNumRec ) } ) )

      ( cPedCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( cPedCliT )->( ordCreate( cPath + "PedCliP.Cdx", "cTurRec", "cTurRec + cSufPed + cCodCaj", {|| Field->cTurRec + Field->cSufPed + Field->cCodCaj } ) )

      ( cPedCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( cPedCliT )->( ordCreate( cPath + "PedCliP.Cdx", "cCodCli", "cCodCli", {|| Field->cCodCli } ) )

      ( cPedCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( cPedCliT )->( ordCreate( cPath + "PedCliP.Cdx", "dEntrega", "dEntrega", {|| Field->dEntrega } ) )

      ( cPedCliT )->( ordCondSet("!Deleted() .and. !Field->lPasado", {|| !Deleted() .and. !Field->lPasado } ) )
      ( cPedCliT )->( ordCreate( cPath + "PedCliP.Cdx", "lCtaBnc", "cEPaisIBAN + cECtrlIBAN + cEntEmp + cSucEmp + cDigEmp + cCtaEmp", {|| Field->cEPaisIBAN + Field->cECtrlIBAN + Field->cEntEmp + Field->cSucEmp + Field->cDigEmp + Field->cCtaEmp } ) )

      ( cPedCliT )->( dbCloseArea() )

   else

      msgStop( "Imposible abrir en modo exclusivo la tabla de pedidos de clientes" )

   end if

   dbUseArea( .t., cDriver, cPath + "PedCliE.DBF", cCheckArea( "PedCliE", @cPedCliT ), .f. )

   if !( cPedCliT )->( neterr() )

      ( cPedCliT )->( __dbPack() )

      ( cPedCliT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cPedCliT )->( ordCreate( cPath + "PedCliE.CDX", "NNUMPED", "CSERPED + STR( NNUMPED ) + CSUFPED", {|| Field->CSERPED + STR( Field->NNUMPED ) + Field->CSUFPED } ) )

      ( cPedCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( cPedCliT )->( ordCreate( cPath + "PedCliE.Cdx", "cSitua", "cSitua", {|| Field->cSitua } ) )

      ( cPedCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( cPedCliT )->( ordCreate( cPath + "PedCliE.Cdx", "idPs", "str( idPs )", {|| str( Field->idPs ) } ) )

      ( cPedCliT )->( dbCloseArea() )

   else

      msgStop( "Imposible abrir en modo exclusivo la tabla de pedidos de clientes" )

   end if


RETURN NIL

//--------------------------------------------------------------------------//

function aItmPedCli()

   local aItmPedCli := {}

   aAdd( aItmPedCli, { "cSerPed",   "C",    1,  0, "Serie del pedido",                                        "Serie",                   "", "( cDbf )", {|| "A" } } )
   aAdd( aItmPedCli, { "nNumPed",   "N",    9,  0, "Número del pedido",                                       "Numero",                  "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "cSufPed",   "C",    2,  0, "Sufijo de pedido",                                        "Sufijo",                  "", "( cDbf )", {|| retSufEmp() } } )
   aAdd( aItmPedCli, { "cTurPed",   "C",    6,  0, "Sesión del pedido",                                       "Turno",                   "", "( cDbf )", {|| cCurSesion( nil, .f.) } } )
   aAdd( aItmPedCli, { "dFecPed",   "D",    8,  0, "Fecha del pedido",                                        "Fecha",                   "", "( cDbf )", {|| getSysDate() } } )
   aAdd( aItmPedCli, { "cCodCli",   "C",   12,  0, "Código del cliente",                                      "Cliente",                 "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "cNomCli",   "C",   80,  0, "Nombre del cliente",                                      "NombreCliente",           "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "cDirCli",   "C",  200,  0, "Domicilio del cliente",                                   "DomicilioCliente",        "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "cPobCli",   "C",  200,  0, "Población del cliente",                                   "PoblacionCliente",        "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "cPrvCli",   "C",  100,  0, "Provincia del cliente",                                   "ProvinciaCliente",        "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "cPosCli",   "C",   15,  0, "Código postal del cliente",                               "CodigoPostalCliente",     "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "cDniCli",   "C",   30,  0, "DNI del cliente",                                         "DniCliente",              "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "lModCli",   "L",    1,  0, "Modificar datos del cliente",                             "ModificarDatosCliente",   "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "cCodAge",   "C",    3,  0, "Código del agente",                                       "Agente",                  "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "cCodObr",   "C",   10,  0, "Código de dirección",                                     "Direccion",               "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "cCodTar",   "C",    5,  0, "Código de tarifa",                                        "Tarifa",                  "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "cCodAlm",   "C",   16,  0, "Código del almacen",                                      "Almacen",                 "", "( cDbf )", {|| Application():codigoAlmacen() } } )
   aAdd( aItmPedCli, { "cCodCaj",   "C",    3,  0, "Código de caja",                                          "Caja",                    "", "( cDbf )", {|| Application():CodigoCaja() } } )
   aAdd( aItmPedCli, { "cCodPgo",   "C",    2,  0, "Código de pago",                                          "Pago",                    "", "( cDbf )", {|| cDefFpg() } } )
   aAdd( aItmPedCli, { "cCodRut",   "C",    4,  0, "Código de la ruta",                                       "Ruta",                    "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "dFecEnt",   "D",    8,  0, "Fecha de salida",                                         "FechaSalida",             "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "nEstado",   "N",    1,  0, "Estado del pedido",                                       "Estado",                  "", "( cDbf )", {|| 1 } } )
   aAdd( aItmPedCli, { "cSuPed",    "C",   35,  0, "Su pedido",                                               "DocumentoOrigen",         "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "cCondent",  "C",  100,  0, "Condiciones del pedido",                                  "Condiciones",             "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "mComent",   "M",   10,  0, "Comentarios",                                             "Comentarios",             "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "mObserv",   "M",   10,  0, "Observaciones",                                           "Observaciones",           "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "lMayor",    "L",    1,  0, "",                                                        "",                        "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "nTarifa",   "N",    1,  0, "Tarifa de precio aplicada",                               "NumeroTarifa",            "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "cDtoEsp",   "C",   50,  0, "Descripción de porcentaje de descuento",                  "DescripcionDescuento1",   "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "nDtoEsp",   "N",    5,  2, "Porcentaje de descuento",                                 "PorcentajeDescuento1",    "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "cDpp",      "C",   50,  0, "Descripción porcentaje de descuento por pronto pago",     "DescripcionDescuento2",   "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "nDpp",      "N",    5,  2, "Pct. de dto. por pronto pago",                            "PorcentajeDescuento2",    "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "cDtoUno",   "C",   25,  0, "Desc. del primer descuento pers.",                        "DescripcionDescuento3",   "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "nDtoUno",   "N",    5,  2, "Pct. del primer descuento pers.",                         "PorcentajeDescuento3",    "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "cDtoDos",   "C",   25,  0, "Desc. del segundo descuento pers.",                       "DescripcionDescuento4",   "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "nDtoDos",   "N",    5,  2, "Pct. del segundo descuento pers.",                        "PorcentajeDescuento4",    "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "nDtoCnt",   "N",    5,  2, "Pct. de dto. por pago contado",                           "",                        "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "nDtoRap",   "N",    5,  2, "Pct. de dto. por rappel",                                 "",                        "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "nDtoPub",   "N",    5,  2, "Pct. de dto. por publicidad",                             "",                        "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "nDtoPgo",   "N",    5,  2, "Pct. de dto. por pago centralizado",                      "",                        "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "nDtoPtf",   "N",    7,  2, "",                                                        "",                        "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "lRecargo",  "L",    1,  0, "Aplicar recargo de equivalencia",                         "RecargoEquivalencia",     "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "nPctComAge","N",    5,  2, "Pct. de comisión del agente",                             "ComisionAgente",          "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "nBultos",   "N",    5,  0, "Número de bultos",                                        "Bultos",                  "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "cNumPre",   "C",   12,  0, "",                                                        "NumeroPresupuesto",       "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "cDivPed",   "C",    3,  0, "Código de divisa",                                        "Divisa",                  "", "( cDbf )", {|| cDivEmp() } } )
   aAdd( aItmPedCli, { "nVdvPed",   "N",   10,  4, "Valor del cambio de la divisa",                           "ValorDivisa",             "", "( cDbf )", {|| nChgDiv() } } )
   aAdd( aItmPedCli, { "lSndDoc",   "L",    1,  0, "Valor lógico documento enviado",                          "Envio",                   "", "( cDbf )", {|| .t. } } )
   aAdd( aItmPedCli, { "lPdtCrg",   "L",    1,  0, "Lógico para ser entregado",                               "",                        "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "nRegIva",   "N",    1,  0, "Regimen de " + cImp() ,                                   "TipoImpuesto",            "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "lIvaInc",   "L",    1,  0, "impuestos incluido" ,                                     "ImpuestosIncluidos",      "", "( cDbf )", {|| uFieldEmpresa( "lIvaInc" ) } } )
   aAdd( aItmPedCli, { "nIvaMan",   "N",    6,  2, "Porcentaje de " + cImp() + " del gasto" ,                 "ImpuestoGastos",          "", "( cDbf )", {|| nIva( nil, cDefIva() ) } } )
   aAdd( aItmPedCli, { "nManObr",   "N",   16,  6, "Gastos" ,                                                 "Gastos",                  "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "cCodTrn",   "C",    9,  0, "Código de transportista" ,                                "Transportista",           "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "nKgsTrn",   "N",   16,  6, "TARA del transportista" ,                                 "TaraTransportista",       "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "lCloPed",   "L",    1,  0, "Lógico de pedido cerrado" ,                               "DocumentoCerrado",        "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "cCodUsr",   "C",    3,  0, "Código de usuario",                                       "Usuario",                 "", "( cDbf )", {|| Auth():Codigo() } } )
   aAdd( aItmPedCli, { "dFecCre",   "D",    8,  0, "Fecha de creación del documento",                         "FechaCreacion",           "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "cTimCre",   "C",    5,  0, "Hora de creación del documento",                          "HoraCreacion",            "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "cRetMat",   "C",   20,  0, "Matricula",                                               "Matricula",               "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "cRetPor",   "C",   20,  0, "Retirado por",                                            "RetiradoPor",             "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "nPedProV",  "N",    1,  0, "",                                                        "NumeroPedidoProveedor",   "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "nMonTaje",  "N",    6 , 2, "Horas de montaje",                                        "Montaje",                 "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "cCodGrp",   "C",    4,  0, "Código de grupo de cliente",                              "GrupoCliente",            "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "lImpRimido","L",    1,  0, "Lógico de imprimido",                                     "Imprimido",               "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "dFecImp",   "D",    8,  0, "Última fecha de impresión",                               "FechaImpresion",          "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "cHorImp",   "C",    5,  0, "Hora de la última impresión",                             "HoraImpresion",           "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "cCodDlg",   "C",    2,  0, "Código delegación" ,                                      "Delegacion",              "", "( cDbf )", {|| Application():CodigoDelegacion() } } )
   aAdd( aItmPedCli, { "nDtoAtp",   "N",    6,  2, "Porcentaje de descuento atípico",                         "DescuentoAtipico",        "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "nSbrAtp",   "N",    1,  0, "Lugar donde aplicar dto atípico",                         "LugarAplicarDescuentoAtipico","", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "cSituac",   "C",   20,  0, "Situación del documento",                                 "Situacion",               "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "lWeb",      "L",    1,  0, "Lógico de recibido por web",                              "",                        "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "lAlquiler", "L",    1,  0, "Lógico de alquiler",                                      "Alquiler",                "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "dFecEntr",  "D",    8,  0, "Fecha inicio servicio",                                   "InicioServicio",          "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "dFecSal",   "D",    8,  0, "Fecha fin de servicio",                                   "FinServicio",             "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "cManObr",   "C",  250,  0, "Literal de gastos" ,                                      "LiteralGastos",           "", "( cDbf )", {|| padr( getConfigTraslation( "Gastos" ), 250 ) } } )
   aAdd( aItmPedCli, { "nGenerado", "N",    1,  0, "Estado generado" ,                                        "",                        "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "nRecibido", "N",    1,  0, "Estado recibido" ,                                        "",                        "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "lInternet", "L",    1,  0, "Pedido desde internet" ,                                  "",                        "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "cNumTik",   "C",   13,  0, "Número del ticket generado" ,                             "NumeroTicket",            "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "lCancel",   "L",    1,  0, "Lógico pedido cancelado" ,                                "Cancelado",               "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "dCancel",   "D",    8,  0, "Fecha cancelación" ,                                      "FechaCancelado",          "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "cCancel",   "C",  100,  0, "Motivo cancelación" ,                                     "MotivoCancelado",         "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "cCodWeb",   "N",   11,  0, "Codigo del pedido en la web" ,                            "CodigoWeb",               "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "cTlfCli",   "C",   20,  0, "Teléfono del cliente" ,                                   "TelefonoCliente",         "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "nTotNet",   "N",   16,  6, "Total neto" ,                                             "TotalNeto",               "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "nTotIva",   "N",   16,  6, "Total " + cImp() ,                                        "TotalImpuesto",           "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "nTotReq",   "N",   16,  6, "Total recago" ,                                           "TotalRecargo",            "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "nTotPed",   "N",   16,  6, "Total pedido" ,                                           "TotalDocumento",          "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "cNumAlb",   "C",   12,  0, "Número del albarán donde se agrupa" ,                     "NumeroAlbaran",           "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "lOperPV",   "L",    1,  0, "Lógico para operar con punto verde" ,                     "OperarPuntoVerde",        "", "( cDbf )", {|| .f. } } )
   aAdd( aItmPedCli, { "cBanco",    "C",   50,  0, "Nombre del banco del cliente",                            "NombreBanco",             "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "cPaisIBAN", "C",    2,  0, "País IBAN de la cuenta bancaria del cliente",             "CuentaIBAN",              "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "cCtrlIBAN", "C",    2,  0, "Dígito de control IBAN de la cuenta bancaria del cliente","DigitoControlIBAN",       "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "cEntBnc",   "C",    4,  0, "Entidad de la cuenta bancaria del cliente",               "EntidadCuenta",           "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "cSucBnc",   "C",    4,  0, "Sucursal de la cuenta bancaria del cliente",              "SucursalCuenta",          "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "cDigBnc",   "C",    2,  0, "Dígito de control de la cuenta bancaria del cliente",     "DigitoControlCuenta",     "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "cCtaBnc",   "C",   10,  0, "Cuenta bancaria del cliente",                             "CuentaBancaria",          "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "lProduc",   "L",    1,  0, "Lógico para incluir en producción" ,                      "IncluirEnProduccion",     "", "( cDbf )", {|| .t. } } )
   aAdd( aItmPedCli, { "nDtoTarifa","N",    6,  2, "Descuentos de tarifa", 			                           "DescuentoTarifa", 	     "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "mFirma",    "M",   10,  2, "Firma",                                                   "Firma",                   "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "cCtrCoste", "C",    9,  0, "Código del centro de coste" ,                             "CentroCoste",             "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "Uuid_Trn",  "C",   40,  0, "Identificador transportista" ,                            "UuidTransportista",       "", "( cDbf )", nil } )

return ( aItmPedCli )

//---------------------------------------------------------------------------//

function aColPedCli()

   local aColPedCli  := {}

   aAdd( aColPedCli, { "cSerPed",   "C",    1,  0, "",                                                "Serie",                      "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "nNumPed",   "N",    9,  0, "",                                                "Numero",                     "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "cSufPed",   "C",    2,  0, "",                                                "Sufijo",                     "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "cRef",      "C",   18,  0, "Referencia del artículo",                         "Articulo",                   "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "cCodPr1",   "C",   20,  0, "Código de la primera propiedad",                  "CodigoPropiedad1",           "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "cCodPr2",   "C",   20,  0, "Código de la segunda propiedad",                  "CodigoPropiedad2",           "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "cValPr1",   "C",   20,  0, "Valor de la primera propiedad",                   "ValorPropiedad1",            "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "cValPr2",   "C",   20,  0, "Valor de la segunda propiedad",                   "ValorPropiedad2",            "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "cDetalle",  "C",  250,  0, "Descripción de artículo",                         "DescripcionArticulo",        "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "nIva"    ,  "N",    6,  2, "Porcentaje de impuesto",                          "PorcentajeImpuesto",         "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "nCanPed" ,  "N",   16,  6, cNombreCajas(),                                    "Cajas",                      "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "nUniCaja",  "N",   16,  6, cNombreUnidades(),                                 "Unidades",                   "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "nUndKit",   "N",   16,  6, "Unidades del producto kit",                       "UnidadesKit",                "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "nPreDiv" ,  "N",   16,  6, "Precio del artículo",                             "PrecioVenta",                "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "nPntVer",   "N",   16,  6, "Importe punto verde",                             "PuntoVerde",                 "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "nImpTrn",   "N",   16,  6, "Importe de portes",                               "Portes",                     "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "nDto",      "N",    6,  2, "Descuento del producto",                          "DescuentoPorcentual",        "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "nDtoPrm",   "N",    6,  2, "Descuento de la promoción",                       "DescuentoPromocion",         "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "nComAge",   "N",    6,  2, "Comisión del agente",                             "ComisionAgente",             "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "nCanEnt",   "N",   16,  6, "",                                                "",                           "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "nUniEnt",   "N",   16,  6, "",                                                "",                           "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "cUnidad",   "C",   2,   0, "Unidad de medición",                              "UnidadMedicion",             "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "nPesokg",   "N",   16,  6, "Peso del producto",                               "Peso",                       "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "cPesokg",   "C",    2,  0, "Unidad de peso del producto",                     "UnidadMedicionPeso",         "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "dFecha",    "D",    8,  0, "Fecha de entrega",                                "FechaEntrega",               "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "cTipMov",   "C",    2,  0, "Tipo de movimiento",                              "Tipo",                       "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "mLngDes",   "M",   10,  0, "Descripción de artículo sin codificar",           "DescripcionAmpliada",        "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "lTotLin",   "L",    1,  0, "Línea de total",                                  "LineaTotal",                 "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "lImpLin",   "L",    1,  0, "Línea no imprimible",                             "LineaNoImprimible",          "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "nFacCnv",   "N",   13,  4, "",                                                "FactorConversion",           "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "nDtoDiv",   "N",   16,  6, "Descuento lineal de la compra",                   "DescuentoLineal",            "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "lResUnd",   "L",    1,  0, "Reservar unidades del stock",                     "",                           "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "nResUnd",   "N",   16,  6, "Unidades reservadas de del stock",                "",                           "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "nRetUnd",   "N",   16,  6, "Und. entregadas de las reservadas",               "",                           "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "nNumLin",   "N",    4,  0, "Numero de la línea",                              "NumeroLinea",                "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "nCtlStk",   "N",    1,  0, "Tipo de stock de la linea",                       "TipoStock",                  "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "nCosDiv",   "N",   16,  6, "Costo del producto" ,                             "PrecioCosto",                "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "nPvpRec",   "N",   16,  6, "Precio de venta recomendado" ,                    "PrecioVentaRecomendado",     "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "cAlmLin",   "C",   16,  0, "Código de almacén" ,                              "Almacen",                    "", "( cDbfCol )", {|| Application():codigoAlmacen() } } )
   aAdd( aColPedCli, { "cCodImp",   "C",    3,  0, "Código del IVMH",                                 "ImpuestoEspecial",           "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "nValImp",   "N",   16,  6, "Importe de impuesto",                             "ImporteImpuestoEspecial",    "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "lIvaLin",   "L",    1,  0, "Línea con impuesto incluido",                     "LineaImpuestoIncluido",      "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "lLote",     "L",    1,  0, "",                                                "LogicoLote",                 "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "nLote",     "N",    9,  0, "",                                                "",                           "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "cLote",     "C",   14,  0, "Número de lote",                                  "Lote",                       "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "lKitArt",   "L",    1,  0, "Línea con escandallo",                            "LineaEscandallo",            "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "lKitChl",   "L",    1,  0, "Línea pertenciente a escandallo",                 "LineaPerteneceEscandallo",   "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "lKitPrc",   "L",    1,  0, "Línea de escandallos con precio",                 "LineaEscandalloPrecio",      "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "nMesGrt",   "N",    2,  0, "Meses de garantía",                               "MesesGarantia",              "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "lMsgVta",   "L",    1,  0, "Avisar en venta sin stocks",                      "AvisarSinStock",             "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "lNotVta",   "L",    1,  0, "No permitir venta sin stocks",                    "NoPermitirSinStock",         "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "lConTrol",  "L",    1,  0, "" ,                                               "LineaControl",               "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "mNumSer",   "M",   10,  0, "" ,                                               "",                           "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "cCodTip",   "C",    4,  0, "Código del tipo de artículo",                     "TipoArticulo",               "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "lAnulado",  "L",    1,  0, "Anular linea",                                    "AnularLinea",                "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "dAnulado",  "D",    8,  0, "Fecha de anulacion",                              "FechaAnulacion",             "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "mAnulado",  "M",  100,  0, "Motivo anulacion",                                "MotivoAnulacion",            "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "cCodFam",   "C",   16,  0, "Código de familia",                               "Familia",                    "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "cGrpFam",   "C",    3,  0, "Código de grupo de familia",                      "GrupoFamilia",               "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "nReq",      "N",   16,  6, "Recargo de equivalencia",                         "RecargoEquivalencia",        "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "mObsLin",   "M",   10,  0, "Observaciones de linea",                          "Observaciones",              "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "nRecibida", "N",    1,  0, "Estado si recibido del artículo",                 "",                           "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "cCodPrv",   "C",   12,  0, "Código del proveedor",                            "Proveedor",                  "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "cNomPrv",   "C",   30,  0, "Nombre del proveedor",                            "NombreProveedor",            "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "cImagen",   "C",  250,  0, "Fichero de imagen" ,                              "Imagen",                     "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "nPuntos",   "N",   15,  6, "Puntos del artículo",                             "",                           "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "nValPnt",   "N",   16,  6, "Valor del punto",                                 "",                           "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "nDtoPnt",   "N",    6,  2, "Descuento puntos",                                "",                           "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "nIncPnt",   "N",    6,  2, "Incremento porcentual",                           "",                           "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "cRefPrv",   "C",   18,  0, "Referencia proveedor",                            "ReferenciaProveedor",        "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "nVolumen",  "N",   16,  6, "Volumen del producto" ,                           "Volumen",                    "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "cVolumen",  "C",    2,  0, "Unidad del volumen" ,                             "UnidadMedicionVolumen",      "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "dFecEnt" ,  "D",    8,  0, "Fecha inicio de servicio",                        "InicioServicio",             "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "dFecSal" ,  "D",    8,  0, "Fecha fin de servicio",                           "FinServicio",                "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "lAlquiler" ,"L",    1,  0, "Lógico de alquiler",                              "Alquiler",                   "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "nPreAlq",   "N",   16,  6, "Precio de alquiler",                              "PrecioAlquiler",             "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "nNumMed",   "N",    1,  0, "Número de mediciones",                            "NumeroMedidiones",           "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "nMedUno",   "N",   16,  6, "Primera unidad de medición",                      "Medicion1",                  "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "nMedDos",   "N",   16,  6, "Segunda unidad de medición",                      "Medicion2",                  "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "nMedTre",   "N",   16,  6, "Tercera unidad de medición",                      "Medicion3",                  "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "nTarLin",   "N",    1,  0, "Tarifa de precio aplicada" ,                      "NumeroTarifa",               "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "lImpFra",   "L",    1,  0, "Lógico de imprimir frase publicitaria",           "",                           "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "cCodFra",   "C",    3,  0, "Código de frase publicitaria",                    "",                           "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "cTxtFra",   "C",  250,  0, "",                                                "",                           "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "Descrip",   "M",   10,  0, "Descripción larga",                               "DescripcionTecnica",         "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "lLinOfe",   "L",    1,  0, "Linea con oferta",                                "LineaOferta",                "", "( cDbfCol )", .f. } )
   aAdd( aColPedCli, { "lVolImp",   "L",    1,  0, "Lógico aplicar volumen con impuestos especiales", "VolumenImpuestosEspeciales", "", "( cDbfCol )", .f. } )
   aAdd( aColPedCli, { "nProduc",   "N",    1,  0, "Lógico de producido",                             "EstadoProducido",            "", "( cDbfCol )", .f. } )
   aAdd( aColPedCli, { "dFecCad",   "D",    8,  0, "Fecha de caducidad",                              "FechaCaducidad",             "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "dFecUltCom","D",    8,  0, "Fecha ultima venta",                              "FechaUltimaVenta",           "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "lFromAtp"  ,"L",    1,  0, "", 								                        "",          		            "", "( cDbfCol )", .f. } )
   aAdd( aColPedCli, { "nUniUltCom","N",   16,  6, "Unidades última compra",		                     "",                           "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "nBultos",   "N",   16,  6, "Numero de bultos en líneas", 	                  "Bultos",        	            "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "cFormato",  "C",  100,  0, "Formato de venta",                                "Formato",       	            "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "lLabel",    "L",    1,  0, "Lógico para marca de etiqueta",					      "LogicoEtiqueta",             "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "nLabel",    "N",    6,  0, "Unidades de etiquetas a imprimir",                "NumeroEtiqueta",             "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "dFecFin",   "D",    8,  0, "Fecha fin de entrega",                            "FechaEntregaFin",            "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "cObrLin",   "C",   10,  0, "Dirección de la linea",                           "Direccion",                  "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "cRefAux",   "C",   18,  0, "Referencia auxiliar",                             "ReferenciaAuxiliar",         "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "cRefAux2",  "C",   18,  0, "Segunda referencia auxiliar",                     "ReferenciaAuxiliar2",        "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "nPosPrint", "N",    4,  0, "Posición de impresión",                           "PosicionImpresion",          "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "cCtrCoste", "C",    9,  0, "Código del centro de coste",                      "",                           "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "cTipCtr",   "C",   20,  0, "Tipo tercero centro de coste",                    "",                           "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "cTerCtr",   "C",   20,  0, "Tercero centro de coste",                         "",                           "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "nNumKit",   "N",    4,  0, "Número de línea de escandallo",                   "",                           "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "id_tipo_v", "N",   16,  0, "Identificador tipo de venta",                     "IdentificadorTipoVenta",     "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "nRegIva",   "N",    1,  0, "Régimen de " + cImp(),                            "TipoImpuesto",               "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "nPrcUltCom","N",   16,  6, "Precio última compra",                            "PrecioUltimaVenta",          "", "( cDbfCol )", nil } ) 

return ( aColPedCli )

//---------------------------------------------------------------------------//

function aIncPedCli()

   local aIncPedCli  := {}

   aAdd( aIncPedCli, { "cSerPed", "C",    1,  0, "Serie de pedido" ,                      "",                   "", "( cDbfCol )", nil } )
   aAdd( aIncPedCli, { "nNumPed", "N",    9,  0, "Número de pedido" ,                     "'999999999'",        "", "( cDbfCol )", nil } )
   aAdd( aIncPedCli, { "cSufPed", "C",    2,  0, "Sufijo de pedido" ,                     "",                   "", "( cDbfCol )", nil } )
   aAdd( aIncPedCli, { "cCodTip", "C",    3,  0, "Tipo de incidencia" ,                   "",                   "", "( cDbfCol )", nil } )
   aAdd( aIncPedCli, { "dFecInc", "D",    8,  0, "Fecha de la incidencia" ,               "",                   "", "( cDbfCol )", nil } )
   aAdd( aIncPedCli, { "mDesInc", "M",   10,  0, "Descripción de la incidencia" ,         "",                   "", "( cDbfCol )", nil } )
   aAdd( aIncPedCli, { "lListo",  "L",    1,  0, "Lógico de listo" ,                      "",                   "", "( cDbfCol )", nil } )
   aAdd( aIncPedCli, { "lAviso",  "L",    1,  0, "Lógico de aviso" ,                      "",                   "", "( cDbfCol )", nil } )
   aAdd( aIncPedCli, { "lSndWeb", "L",    1,  0, "Lógico de incidencia subia a la web" ,  "",                   "", "( cDbfCol )", nil } )

return ( aIncPedCli )

//---------------------------------------------------------------------------//

function aPedCliDoc()

   local aPedCliDoc  := {}

   aAdd( aPedCliDoc, { "cSerPed", "C",    1,  0, "Serie de pedido" ,            "",                   "", "( cDbfCol )", nil } )
   aAdd( aPedCliDoc, { "nNumPed", "N",    9,  0, "Numero de pedido" ,           "'999999999'",        "", "( cDbfCol )", nil } )
   aAdd( aPedCliDoc, { "cSufPed", "C",    2,  0, "Sufijo de pedido" ,           "",                   "", "( cDbfCol )", nil } )
   aAdd( aPedCliDoc, { "cNombre", "C",  250,  0, "Nombre del documento" ,       "",                   "", "( cDbfCol )", nil } )
   aAdd( aPedCliDoc, { "cRuta",   "C",  250,  0, "Ruta del documento" ,         "",                   "", "( cDbfCol )", nil } )
   aAdd( aPedCliDoc, { "mObsDoc", "M",   10,  0, "Observaciones del documento", "",                   "", "( cDbfCol )", nil } )

return ( aPedCliDoc )

//---------------------------------------------------------------------------//

function aPedCliEst()

   local aPedCliEst  := {}

   aAdd( aPedCliEst, { "cSerPed", "C",    1,  0, "Serie de pedido" ,            "",                   "", "( cDbfCol )", nil } )
   aAdd( aPedCliEst, { "nNumPed", "N",    9,  0, "Numero de pedido" ,           "'999999999'",        "", "( cDbfCol )", nil } )
   aAdd( aPedCliEst, { "cSufPed", "C",    2,  0, "Sufijo de pedido" ,           "",                   "", "( cDbfCol )", nil } )
   aAdd( aPedCliEst, { "cSitua",  "C",  140,  0, "Situación" ,   	    		     "",                   "", "( cDbfCol )", nil } )
   aAdd( aPedCliEst, { "dFecSit", "D",    8,  0, "Fecha de la situación" ,      "",                   "", "( cDbfCol )", nil } )
   aAdd( aPedCliEst, { "tFecSit", "C",    6,  0, "Hora de la situación" ,       "",                   "", "( cDbfCol )", nil } )
   aAdd( aPedCliEst, { "idPs",    "N",   11,  0, "Id prestashop" ,              "",                   "", "( cDbfCol )", nil } )   

return ( aPedCliEst )

//---------------------------------------------------------------------------//

function aPedCliPgo()

   local aPedCliPgo  := {}

   aAdd( aPedCliPgo, {"cSerPed"     ,"C",  1, 0, "Serie de pedido" ,            "",                   "", "( cDbfEnt )", nil } )
   aAdd( aPedCliPgo, {"nNumPed"     ,"N",  9, 0, "Numero de pedido" ,           "'999999999'",        "", "( cDbfEnt )", nil } )
   aAdd( aPedCliPgo, {"cSufPed"     ,"C",  2, 0, "Sufijo de pedido" ,           "",                   "", "( cDbfEnt )", nil } )
   aAdd( aPedCliPgo, {"nNumRec"     ,"N",  2, 0, "Numero del recibo",           "",                   "", "( cDbfEnt )", nil } )
   aAdd( aPedCliPgo, {"cCodCaj"     ,"C",  3, 0, "Código de caja",              "",                   "", "( cDbfEnt )", nil } )
   aAdd( aPedCliPgo, {"cTurRec"     ,"C",  6, 0, "Sesión del recibo",           "######",             "", "( cDbfEnt )", nil } )
   aAdd( aPedCliPgo, {"cCodCli"     ,"C", 12, 0, "Código de cliente",           "",                   "", "( cDbfEnt )", nil } )
   aAdd( aPedCliPgo, {"dEntrega"    ,"D",  8, 0, "Fecha de cobro",              "",                   "", "( cDbfEnt )", nil } )
   aAdd( aPedCliPgo, {"nImporte"    ,"N", 16, 6, "Importe",                     "cPorDivEnt",         "", "( cDbfEnt )", nil } )
   aAdd( aPedCliPgo, {"cDescrip"    ,"C",100, 0, "Concepto del pago",           "",                   "", "( cDbfEnt )", nil } )
   aAdd( aPedCliPgo, {"cPgdoPor"    ,"C", 50, 0, "Pagado por",                  "",                   "", "( cDbfEnt )", nil } )
   aAdd( aPedCliPgo, {"cDocPgo"     ,"C", 50, 0, "Documento de pago",           "",                   "", "( cDbfEnt )", nil } )
   aAdd( aPedCliPgo, {"cDivPgo"     ,"C",  3, 0, "Código de la divisa",         "",                   "", "( cDbfEnt )", nil } )
   aAdd( aPedCliPgo, {"nVdvPgo"     ,"N", 10, 6, "Valor de la divisa",          "",                   "", "( cDbfEnt )", nil } )
   aAdd( aPedCliPgo, {"cCodAge"     ,"C",  3, 0, "Código del agente",           "",                   "", "( cDbfEnt )", nil } )
   aAdd( aPedCliPgo, {"cCodPgo"     ,"C",  2, 0, "Código de pago",              "",                   "", "( cDbfEnt )", nil } )
   aAdd( aPedCliPgo, {"lCloPgo"     ,"L",  1, 0, "Lógico cerrado turno",        "",                   "", "( cDbfEnt )", nil } )
   aAdd( aPedCliPgo, {"lPasado"     ,"L",  1, 0, "Lógico pasado albarán",       "",                   "", "( cDbfEnt )", nil } )
   aAdd( aPedCliPgo, {"cBncEmp"     ,"C", 50, 0, "Banco de la empresa para el recibo" ,"",            "", "( cDbfEnt )", nil } )
   aAdd( aPedCliPgo, {"cBncCli"     ,"C", 50, 0, "Banco del cliente para el recibo" ,"",              "", "( cDbfEnt )", nil } )
   aAdd( aPedCliPgo, {"cEPaisIBAN"  ,"C",  2, 0, "País IBAN de la cuenta de la empresa",  "",        	"", "( cDbfEnt )", nil } )
   aAdd( aPedCliPgo, {"cECtrlIBAN"  ,"C",  2, 0, "Digito de control IBAN de la cuenta de la empresa", "", "", "( cDbfEnt )", nil } )
   aAdd( aPedCliPgo, {"cEntEmp"     ,"C",  4, 0, "Entidad de la cuenta de la empresa",  "",           "", "( cDbfEnt )", nil } )
   aAdd( aPedCliPgo, {"cSucEmp"     ,"C",  4, 0, "Sucursal de la cuenta de la empresa",  "",          "", "( cDbfEnt )", nil } )
   aAdd( aPedCliPgo, {"cDigEmp"     ,"C",  2, 0, "Dígito de control de la cuenta de la empresa", "",  "", "( cDbfEnt )", nil } )
   aAdd( aPedCliPgo, {"cCtaEmp"     ,"C", 10, 0, "Cuenta bancaria de la empresa",  "",                "", "( cDbfEnt )", nil } )
   aAdd( aPedCliPgo, {"cPaisIBAN"   ,"C",  2, 0, "País IBAN de la cuenta del cliente",  "",        	"", "( cDbfEnt )", nil } )
   aAdd( aPedCliPgo, {"cCtrlIBAN"   ,"C",  2, 0, "Digito de control IBAN de la cuenta del cliente", "", "", "( cDbfEnt )", nil } )
   aAdd( aPedCliPgo, {"cEntCli"     ,"C",  4, 0, "Entidad de la cuenta del cliente",  "",             "", "( cDbfEnt )", nil } )
   aAdd( aPedCliPgo, {"cSucCli"     ,"C",  4, 0, "Sucursal de la cuenta del cliente",  "",            "", "( cDbfEnt )", nil } )
   aAdd( aPedCliPgo, {"cDigCli"     ,"C",  2, 0, "Dígito de control de la cuenta del cliente", "",    "", "( cDbfEnt )", nil } )
   aAdd( aPedCliPgo, {"cCtaCli"     ,"C", 10, 0, "Cuenta bancaria del cliente",  "",                  "", "( cDbfEnt )", nil } )

return ( aPedCliPgo )

//---------------------------------------------------------------------------//

Function nombrePrimeraPropiedadPedidosClientesLineas( )

Return ( nombrePropiedad( ( D():PedidosClientesLineas( nView ) )->cCodPr1, ( D():PedidosClientesLineas( nView ) )->cValPr1, nView ) )

//---------------------------------------------------------------------------//

Function nombreSegundaPropiedadPedidosClientesLineas()

Return ( nombrePropiedad( ( D():PedidosClientesLineas( nView ) )->cCodPr2, ( D():PedidosClientesLineas( nView ) )->cValPr2, nView ) )

//---------------------------------------------------------------------------//

Function unidadesRecibidasPedidosClientesLineas()

Return ( nUnidadesRecibidasAlbaranesClientes( D():PedidosClientesLineasId( nView ), ( D():PedidosClientesLineas( nView ) )->cRef, ( D():PedidosClientesLineas( nView ) )->cValPr1, ( D():PedidosClientesLineas( nView ) )->cValPr2, D():AlbaranesClientesLineas( nView ) ) )

//---------------------------------------------------------------------------//
//
// Numero de unidades por linea------------------------------------------------
//

function nTotNPedCli( uDbf )

   local nTotUnd

   DEFAULT uDbf   := D():PedidosClientesLineas( nView )

   do case
   case ValType( uDbf ) == "A"

      nTotUnd  := NotCaja( uDbf[ _NCANPED ] )
      nTotUnd  *= uDbf[ _NUNICAJA ]
      nTotUnd  *= NotCero( uDbf[ _NUNDKIT ] )
      nTotUnd  *= NotCero( uDbf[ _NMEDUNO ] )
      nTotUnd  *= NotCero( uDbf[ _NMEDDOS ] )
      nTotUnd  *= NotCero( uDbf[ _NMEDTRE ] )

   case ValType( uDbf ) == "O"

      nTotUnd  := NotCaja( uDbf:nCanPed )
      nTotUnd  *= uDbf:nUniCaja
      nTotUnd  *= NotCero( uDbf:nUndKit )
      nTotUnd  *= NotCero( uDbf:nMedUno )
      nTotUnd  *= NotCero( uDbf:nMedDos )
      nTotUnd  *= NotCero( uDbf:nMedTre )

   case ValType( uDbf ) == "H"

      nTotUnd  := NotCaja( hGet( uDbf, "Cajas" ) )
      nTotUnd  *= hGet( uDbf, "Unidades" )
      nTotUnd  *= NotCero( hGet( uDbf, "UnidadesKit" ) )
      nTotUnd  *= NotCero( hGet( uDbf, "Medicion1" ) )
      nTotUnd  *= NotCero( hGet( uDbf, "Medicion2" ) )
      nTotUnd  *= NotCero( hGet( uDbf, "Medicion3" ) )

   otherwise

      nTotUnd  := NotCaja( ( uDbf )->nCanPed )
      nTotUnd  *= ( uDbf )->nUniCaja
      nTotUnd  *= NotCero( ( uDbf )->nUndKit )
      nTotUnd  *= NotCero( ( uDbf )->nMedUno )
      nTotUnd  *= NotCero( ( uDbf )->nMedDos )
      nTotUnd  *= NotCero( ( uDbf )->nMedTre )

   end case

return ( nTotUnd )

//---------------------------------------------------------------------------//

FUNCTION nTotRPedCli( cRef, cValPr1, cValPr2, dbfPedCliR )

   local nOrd
   local nRec        
   local nTotRes        := 0

   DEFAULT cValPr1      := space( 20 )
   DEFAULT cValPr2      := space( 20 )
   DEFAULT dbfPedCliR   := D():PedidosClientesReservas( nView )

   nRec                 := ( dbfPedCliR )->( recno() )
   nOrd                 := ( dbfPedCliR )->( ordsetfocus( "cRef" ) )

   if ( dbfPedCliR )->( dbseek( cRef + cValPr1 + cValPr2 ) )
      while ( dbfPedCliR )->cRef + ( dbfPedCliR )->cValPr1 + ( dbfPedCliR )->cValPr2 == cRef + cValPr1 + cValPr2 .and. !( dbfPedCliR )->( eof() )
         
         nTotRes        += nTotNResCli( dbfPedCliR )

         ( dbfPedCliR )->( dbskip() )

      end while
   end if

   ( dbfPedCliR )->( ordsetfocus( nOrd ) )
   ( dbfPedCliR )->( dbgoto( nRec ) )

return ( nTotRes )

//---------------------------------------------------------------------------//

FUNCTION nUnidadesReservadasEnPedidosCliente( nNumPed, cCodArt, cValPr1, cValPr2, dbfPedCliR )

   local nOrd
   local nRec        
   local nUnidades      := 0

   DEFAULT nNumPed      := ( D():PedidosClientesLineas( nView ) )->cSerPed + str( ( D():PedidosClientesLineas( nView ) )->nNumPed ) + ( D():PedidosClientesLineas( nView ) )->cSufPed 
   DEFAULT cCodArt      := ( D():PedidosClientesLineas( nView ) )->cRef
   DEFAULT cValPr1      := ( D():PedidosClientesLineas( nView ) )->cValPr1
   DEFAULT cValPr2      := ( D():PedidosClientesLineas( nView ) )->cValPr2
   DEFAULT dbfPedCliR   := D():PedidosClientesReservas( nView )

   nRec                 := ( dbfPedCliR )->( recno() )
   nOrd                 := ( dbfPedCliR )->( ordsetfocus( "nNumPed" ) )

   if ( dbfPedCliR )->( dbseek( nNumPed + cCodArt + cValPr1 + cValPr2 ) )
      while ( dbfPedCliR )->cSerPed + str( ( dbfPedCliR )->nNumPed ) + ( dbfPedCliR )->cSufPed + ( dbfPedCliR )->cRef + ( dbfPedCliR )->cValPr1 + ( dbfPedCliR )->cValPr2 == nNumPed + cCodArt + cValPr1 + cValPr2 .and. !( dbfPedCliR )->( eof() )
         
         nUnidades      += nTotNResCli( dbfPedCliR )
         
         ( dbfPedCliR )->( dbskip() )

      end while
   end if

   ( dbfPedCliR )->( ordsetfocus( nOrd ) )
   ( dbfPedCliR )->( dbgoto( nRec ) )

return ( nUnidades )

//---------------------------------------------------------------------------//


/*
Calcula el Total del pedido
*/

FUNCTION nTotPedCli( cPedido, cPedCliT, cPedCliL, cIva, cDiv, cFpago, aTmp, cDivRet, lPic, cClient )

   local n
   local nRecno
   local cCodDiv
   local cPouDiv
   local dFecPed
   local bCondition
   local nDtoEsp
   local nDtoPP
   local nDtoUno
   local nDtoDos
   local lIvaInc
   local nIvaMan
   local nManObr
   local nSbrAtp
   local nDtoAtp
   local nKgsTrn
   local nTotLin           := 0
   local nTotUnd           := 0
   local aTotalDto         := { 0, 0, 0 }
   local aTotalDPP         := { 0, 0, 0 }
   local aTotalUno         := { 0, 0, 0 }
   local aTotalDos         := { 0, 0, 0 }
   local aTotalAtp         := { 0, 0, 0 }
   local lRecargo
   local nTotAcu           := 0
   local nDescuentosLineas := 0
   local lPntVer           := .f.
   local nRegIva
   local nBaseGasto
   local nIvaGasto

	if !empty( nView )
      DEFAULT cPedCliT     := D():PedidosClientes( nView )
      DEFAULT cPedCliL     := D():PedidosClientesLineas( nView )
      DEFAULT cClient      := D():Clientes( nView )
      DEFAULT cIva         := D():TiposIva( nView )
      DEFAULT cDiv         := D():Divisas( nView )
      DEFAULT cFPago       := D():FormasPago( nView )
   end if
   
	DEFAULT cPedido         := ( cPedCliT )->cSerPed + Str( ( cPedCliT )->nNumPed ) + ( cPedCliT )->cSufPed
	DEFAULT lPic            := .f.

	if Empty( Select( cPedCliT ) )
   	Return ( 0 )
	end if

	if Empty( Select( cPedCliL ) )
   	Return ( 0 )
	end if

	if Empty( Select( cIva ) )
   	Return ( 0 )
	end if

	if Empty( Select( cDiv ) )
   	Return ( 0 )
   end if

   public nTotPed       := 0
   public nTotDto       := 0
   public nTotDPP       := 0
   public nTotNet       := 0
   public nTotIvm       := 0
   public nTotIva       := 0
   public nTotReq       := 0
   public nTotAge       := 0
   public nTotPnt       := 0
   public nTotUno       := 0
   public nTotDos       := 0
   public nTotTrn       := 0
   public nTotCos       := 0
   public nTotRnt       := 0
   public nTotAtp       := 0
   public nTotPes       := 0
   public nTotDif       := 0
   public nPctRnt       := 0
   public nTotBrt       := 0

   public aTotIva       := { { 0,0,nil,0,0,0,0,0,0 }, { 0,0,nil,0,0,0,0,0,0 }, { 0,0,nil,0,0,0,0,0,0 } }
   public aIvaUno       := aTotIva[ 1 ]
   public aIvaDos       := aTotIva[ 2 ]
   public aIvaTre       := aTotIva[ 3 ]

   public aTotIvm       := { { 0,nil,0 }, { 0,nil,0 }, { 0,nil,0 }, }
   public aIvmUno       := aTotIvm[ 1 ]
   public aIvmDos       := aTotIvm[ 2 ]
   public aIvmTre       := aTotIvm[ 3 ]

   public aImpVto       := {}
   public aDatVto       := {}

   public nNumArt       := 0
   public nNumCaj       := 0

   public nTotArt       := nNumArt
   public nTotCaj       := nNumCaj

   public nTotalDto     := 0

   public cCtaCli       := cClientCuenta( ( cPedCliT )->cCodCli )

   nRecno               := ( cPedCliL )->( RecNo() )

   if aTmp != nil

      lRecargo          := aTmp[ _LRECARGO]
      dFecPed           := aTmp[ _DFECPED ]
      nDtoEsp           := aTmp[ _NDTOESP ]
      nDtoPP            := aTmp[ _NDPP    ]
      nDtoUno           := aTmp[ _NDTOUNO ]
      nDtoDos           := aTmp[ _NDTODOS ]
      cCodDiv           := aTmp[ _CDIVPED ]
      nVdvDiv           := aTmp[ _NVDVPED ]
      lIvaInc           := aTmp[ _LIVAINC ]
      nIvaMan           := aTmp[ _NIVAMAN ]
      nManObr           := aTmp[ _NMANOBR ]
      nSbrAtp           := aTmp[ _NSBRATP ]
      nDtoAtp           := aTmp[ _NDTOATP ]
      nKgsTrn           := aTmp[ _NKGSTRN ]
      lPntVer           := aTmp[ _LOPERPV ]
      nRegIva           := aTmp[ _NREGIVA ]
      bCondition        := {|| ( cPedCliL )->( !eof() ) }
      ( cPedCliL )->( dbGoTop() )

   else

      lRecargo          := ( cPedCliT )->lRecargo
      dFecPed           := ( cPedCliT )->dFecPed
      nDtoEsp           := ( cPedCliT )->nDtoEsp
      nDtoPP            := ( cPedCliT )->nDpp
      nDtoUno           := ( cPedCliT )->nDtoUno
      nDtoDos           := ( cPedCliT )->nDtoDos
      cCodDiv           := ( cPedCliT )->cDivPed
      nVdvDiv           := ( cPedCliT )->nVdvPed
      lIvaInc           := ( cPedCliT )->lIvaInc
      nIvaMan           := ( cPedCliT )->nIvaMan
      nManObr           := ( cPedCliT )->nManObr
      nSbrAtp           := ( cPedCliT )->nSbrAtp
      nDtoAtp           := ( cPedCliT )->nDtoAtp
      nKgsTrn           := ( cPedCliT )->nKgsTrn
      lPntVer           := ( cPedCliT )->lOperPv
      nRegIva           := ( cPedCliT )->nRegIva
      bCondition        := {|| ( cPedCliL )->cSerPed + Str( ( cPedCliL )->nNumPed ) + ( cPedCliL )->cSufPed == cPedido .AND. ( cPedCliL )->( !eof() ) }
      ( cPedCliL )->( dbSeek( cPedido ) )

   end if

   /*
	Cargamos los pictures dependiendo de la moneda
   */

   cPouDiv              := cPouDiv( cCodDiv, cDiv )
   cPorDiv              := cPorDiv( cCodDiv, cDiv )
   cPpvDiv              := cPpvDiv( cCodDiv, cDiv )
   nDouDiv              := nDouDiv( cCodDiv, cDiv )
   nRouDiv              := nRouDiv( cCodDiv, cDiv )
   nDpvDiv              := nDpvDiv( cCodDiv, cDiv )

   while Eval( bCondition )

      if lValLine( cPedCliL )

         if ( cPedCliL )->lTotLin

            /*
            Esto es para evitar escirbir en el fichero muchas veces
            */

            if ( cPedCliL )->nPreDiv != nTotLin .or. ( cPedCliL )->nUniCaja != nTotUnd

               if dbLock( cPedCliL )
                  ( cPedCliL )->nPreDiv    := nTotLin
                  ( cPedCliL )->nUniCaja   := nTotUnd
                  ( cPedCliL )->( dbUnLock() )
               end if

            end if

            /*
            Limpien------------------------------------------------------------
            */

            nTotLin           := 0
            nTotUnd           := 0

         else

            nTotArt           := nTotLPedCli( cPedCliL, nDouDiv, nRouDiv, , , .f., .f., )
            nTotPnt           := if( lPntVer, nPntLPedCli( cPedCliL, nDpvDiv ), 0 )
            nTotTrn           := nTrnLPedCli( cPedCliL, nDouDiv )
            nTotIvm           := nTotIPedCli( cPedCliL, nDouDiv, nRouDiv )
            nTotCos           += nTotCPedCli( cPedCliL, nDouDiv, nRouDiv )
            nTotPes           += nPesLPedCli( cPedCliL )
            nDescuentosLineas += nTotDtoLPedCli( cPedCliL, nDouDiv )

            if aTmp != nil
               nTotAge        += nComLPedCli( aTmp, cPedCliL, nDouDiv, nRouDiv )
            else
               nTotAge        += nComLPedCli( cPedCliT, cPedCliL, nDouDiv, nRouDiv )
            end if

           // Acumuladores para las lineas de totales

            nTotLin           += nTotArt
            nTotUnd           += nTotNPedCli( cPedCliL )

            nNumArt           += nTotNPedCli( cPedCliL )
            nNumCaj           += ( cPedCliL )->nCanPed

            /*
            Estudio de impuestos
            */

            do case
            case _NPCTIVA1 == NIL .OR. _NPCTIVA1 == ( cPedCliL )->nIva
               _NPCTIVA1      := ( cPedCliL )->nIva
               _NPCTREQ1      := ( cPedCliL )->nReq
               _NBRTIVA1      += nTotArt
               _NIVMIVA1      += nTotIvm
               _NTRNIVA1      += nTotTrn
               _NPNTVER1      += nTotPnt

            case _NPCTIVA2 == NIL .OR. _NPCTIVA2 == ( cPedCliL )->nIva
               _NPCTIVA2      := ( cPedCliL )->nIva
               _NPCTREQ2      := ( cPedCliL )->nReq
               _NBRTIVA2      += nTotArt
               _NIVMIVA2      += nTotIvm
               _NTRNIVA2      += nTotTrn
               _NPNTVER2      += nTotPnt

            case _NPCTIVA3 == NIL .OR. _NPCTIVA3 == ( cPedCliL )->nIva
               _NPCTIVA3      := ( cPedCliL )->nIva
               _NPCTREQ3      := ( cPedCliL )->nReq
               _NBRTIVA3      += nTotArt
               _NIVMIVA3      += nTotIvm
               _NTRNIVA3      += nTotTrn
               _NPNTVER3      += nTotPnt

            end case

            /*
            Estudio de IVMH-----------------------------------------------------
            */

            if ( cPedCliL )->nValImp != 0

               do case
                  case aTotIvm[ 1, 2 ] == nil .or. aTotIvm[ 1, 2 ] == ( cPedCliL )->nValImp
                     aTotIvm[ 1, 1 ]      += nTotNPedCli( cPedCliL ) * if( ( cPedCliL )->lVolImp, NotCero( ( cPedCliL )->nVolumen ), 1 )
                     aTotIvm[ 1, 2 ]      := ( cPedCliL )->nValImp
                     aTotIvm[ 1, 3 ]      := aTotIvm[ 1, 1 ] * aTotIvm[ 1, 2 ]

                  case aTotIvm[ 2, 2 ] == nil .or. aTotIvm[ 2, 2 ] == ( cPedCliL )->nValImp
                     aTotIvm[ 2, 1 ]      += nTotNPedCli( cPedCliL ) * if( ( cPedCliL )->lVolImp, NotCero( ( cPedCliL )->nVolumen ), 1 )
                     aTotIvm[ 2, 2 ]      := ( cPedCliL )->nValImp
                     aTotIvm[ 2, 3 ]      := aTotIvm[ 2, 1 ] * aTotIvm[ 2, 2 ]

                  case aTotIvm[ 3, 2 ] == nil .or. aTotIvm[ 3, 2 ] == ( cPedCliL )->nValImp
                     aTotIvm[ 3, 1 ]      += nTotNPedCli( cPedCliL ) * if( ( cPedCliL )->lVolImp, NotCero( ( cPedCliL )->nVolumen ), 1 )
                     aTotIvm[ 3, 2 ]      := ( cPedCliL )->nValImp
                     aTotIvm[ 3, 3 ]      := aTotIvm[ 3, 1 ] * aTotIvm[ 3, 2 ]

               end case

            end if

         end if

      end if

      ( cPedCliL )->( dbSkip() )

   end while

   ( cPedCliL )->( dbGoto( nRecno ) )

   /*
   Ordenamos los impuestosS de menor a mayor
	*/

   aTotIva           := aSort( aTotIva,,, {|x,y| if( x[3] != nil, x[3], -1 ) > if( y[3] != nil, y[3], -1 )  } )

   _NBASIVA1         := Round( _NBRTIVA1, nRouDiv )
   _NBASIVA2         := Round( _NBRTIVA2, nRouDiv )
   _NBASIVA3         := Round( _NBRTIVA3, nRouDiv )

   nTotBrt         := _NBRTIVA1 + _NBRTIVA2 + _NBRTIVA3

   /*
   Descuentos atipicos sobre base
   */

   if nSbrAtp <= 1 .and. nDtoAtp != 0

      aTotalAtp[1]   := Round( _NBASIVA1 * nDtoAtp / 100, nRouDiv )
      aTotalAtp[2]   := Round( _NBASIVA2 * nDtoAtp / 100, nRouDiv )
      aTotalAtp[3]   := Round( _NBASIVA3 * nDtoAtp / 100, nRouDiv )

      nTotAtp      := aTotalAtp[ 1 ] + aTotalAtp[ 2 ] + aTotalAtp[ 3 ]

   end if

   /*
	Descuentos Especiales
	*/

	IF nDtoEsp 	!= 0

      aTotalDto[1]   := Round( _NBASIVA1 * nDtoEsp / 100, nRouDiv )
      aTotalDto[2]   := Round( _NBASIVA2 * nDtoEsp / 100, nRouDiv )
      aTotalDto[3]   := Round( _NBASIVA3 * nDtoEsp / 100, nRouDiv )

      nTotDto        := aTotalDto[ 1 ] + aTotalDto[ 2 ] + aTotalDto[ 3 ]

      _NBASIVA1      -= aTotalDto[ 1 ]
      _NBASIVA2      -= aTotalDto[ 2 ]
      _NBASIVA3      -= aTotalDto[ 3 ]

	END IF

   /*
   Descuentos atipicos sobre Dto Especial
   */

   if nSbrAtp == 2 .and. nDtoAtp != 0

      aTotalAtp[1]   := Round( _NBASIVA1 * nDtoAtp / 100, nRouDiv )
      aTotalAtp[2]   := Round( _NBASIVA2 * nDtoAtp / 100, nRouDiv )
      aTotalAtp[3]   := Round( _NBASIVA3 * nDtoAtp / 100, nRouDiv )

      nTotAtp      := aTotalAtp[ 1 ] + aTotalAtp[ 2 ] + aTotalAtp[ 3 ]

   end if

	/*
	Descuentos por Pronto Pago estos son los buenos
	*/

	IF nDtoPP	!= 0

      aTotalDPP[1]   := Round( _NBASIVA1 * nDtoPP / 100, nRouDiv )
      aTotalDPP[2]   := Round( _NBASIVA2 * nDtoPP / 100, nRouDiv )
      aTotalDPP[3]   := Round( _NBASIVA3 * nDtoPP / 100, nRouDiv )

      nTotDPP      := aTotalDPP[1] + aTotalDPP[2] + aTotalDPP[3]

		_NBASIVA1		-= aTotalDPP[1]
		_NBASIVA2		-= aTotalDPP[2]
		_NBASIVA3		-= aTotalDPP[3]

	END IF

   /*
   Descuentos atipicos sobre Dto Pronto Pago
   */

   if nSbrAtp == 3 .and. nDtoAtp != 0

      aTotalAtp[1]   := Round( _NBASIVA1 * nDtoAtp / 100, nRouDiv )
      aTotalAtp[2]   := Round( _NBASIVA2 * nDtoAtp / 100, nRouDiv )
      aTotalAtp[3]   := Round( _NBASIVA3 * nDtoAtp / 100, nRouDiv )

      nTotAtp      := aTotalAtp[ 1 ] + aTotalAtp[ 2 ] + aTotalAtp[ 3 ]

   end if

	IF nDtoUno != 0

      aTotalUno[1]   := Round( _NBASIVA1 * nDtoUno / 100, nRouDiv )
      aTotalUno[2]   := Round( _NBASIVA2 * nDtoUno / 100, nRouDiv )
      aTotalUno[3]   := Round( _NBASIVA3 * nDtoUno / 100, nRouDiv )

      nTotUno      := aTotalUno[1] + aTotalUno[2] + aTotalUno[3]

		_NBASIVA1		-= aTotalUno[1]
		_NBASIVA2		-= aTotalUno[2]
		_NBASIVA3		-= aTotalUno[3]

	END IF

   /*
   Descuentos atipicos sobre Dto Definido 1
   */

   if nSbrAtp == 4 .and. nDtoAtp != 0

      aTotalAtp[1]   := Round( _NBASIVA1 * nDtoAtp / 100, nRouDiv )
      aTotalAtp[2]   := Round( _NBASIVA2 * nDtoAtp / 100, nRouDiv )
      aTotalAtp[3]   := Round( _NBASIVA3 * nDtoAtp / 100, nRouDiv )

      nTotAtp      := aTotalAtp[ 1 ] + aTotalAtp[ 2 ] + aTotalAtp[ 3 ]

   end if

	IF nDtoDos != 0

      aTotalDos[1]   := Round( _NBASIVA1 * nDtoDos / 100, nRouDiv )
      aTotalDos[2]   := Round( _NBASIVA2 * nDtoDos / 100, nRouDiv )
      aTotalDos[3]   := Round( _NBASIVA3 * nDtoDos / 100, nRouDiv )

      nTotDos      := aTotalDos[ 1 ] + aTotalDos[ 2 ] + aTotalDos[ 3 ]

		_NBASIVA1		-= aTotalDos[1]
		_NBASIVA2		-= aTotalDos[2]
		_NBASIVA3		-= aTotalDos[3]

	END IF

   /*
   Descuentos atipicos sobre Dto Definido 2
   */

   if nSbrAtp == 5 .and. nDtoAtp != 0

      aTotalAtp[1]   := Round( _NBASIVA1 * nDtoAtp / 100, nRouDiv )
      aTotalAtp[2]   := Round( _NBASIVA2 * nDtoAtp / 100, nRouDiv )
      aTotalAtp[3]   := Round( _NBASIVA3 * nDtoAtp / 100, nRouDiv )

      nTotAtp      := aTotalAtp[ 1 ] + aTotalAtp[ 2 ] + aTotalAtp[ 3 ]

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

         _NBASIVA1      -= _NIMPREQ1
         _NBASIVA2      -= _NIMPREQ2
         _NBASIVA3      -= _NIMPREQ3

      end if

      if uFieldEmpresa( "lIvaImpEsp")
         _NBASIVA1      -= _NIVMIVA1
         _NBASIVA2      -= _NIVMIVA2
         _NBASIVA3      -= _NIVMIVA3
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
   Redondeo del neto de la pedido
   */

   nTotNet           := Round( _NBASIVA1 + _NBASIVA2 + _NBASIVA3, nRouDiv )

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

   nTotImp           := Round( nTotIva + nTotReq + nTotIvm , nRouDiv )

   /*
   Total rentabilidad----------------------------------------------------------
   */

   nTotRnt           := Round(         nTotNet - nManObr - nTotAge - nTotPnt - nTotAtp - nTotCos, nRouDiv )

   nPctRnt           := nRentabilidad( nTotNet - nManObr - nTotAge - nTotPnt, nTotAtp, nTotCos )

   /*
   Diferencias de pesos
   */

   if nKgsTrn != 0
      nTotDif        := nKgsTrn - nTotPes
   else
      nTotDif        := 0
   end if

	/*
	Total facturas
	*/

   nTotPed           := nTotNet + nTotImp

   /*
   Total de descuentos del pedido----------------------------------------------
   */

   nTotalDto         := nDescuentosLineas + nTotDto + nTotDpp + nTotUno + nTotDos + nTotAtp

	/*
	Estudio de la Forma de Pago
	*/

   if !Empty( cFpago ) .and. ( cFpago )->( dbSeek( ( cPedCliT )->cCodPgo ) )

      nTotAcu        := nTotPed

      for n := 1 to ( cFPago )->nPlazos

         if n != ( cFPago )->nPlazos
            nTotAcu  -= Round( nTotPed / ( cFPago )->nPlazos, nRouDiv )
         end if

         aAdd( aImpVto, if( n != ( cFPago )->nPlazos, Round( nTotPed / ( cFPago )->nPlazos, nRouDiv ), Round( nTotAcu, nRouDiv ) ) )

         aAdd( aDatVto, dNexDay( dFecPed + ( cFPago )->nPlaUno + ( ( cFPago )->nDiaPla * ( n - 1 ) ), cClient ) )

      next

   end if

   ( cPedCliL )->( dbGoTo( nRecno) )

   /*
   Solicitan una divisa distinta a la q se hizo originalmente la factura
   */

   if cDivRet != nil .and. cDivRet != cCodDiv
      nTotNet     := nCnv2Div( nTotNet, cCodDiv, cDivRet )
      nTotIvm     := nCnv2Div( nTotIvm, cCodDiv, cDivRet )
      nTotIva     := nCnv2Div( nTotIva, cCodDiv, cDivRet )
      nTotReq     := nCnv2Div( nTotReq, cCodDiv, cDivRet )
      nTotPed     := nCnv2Div( nTotPed, cCodDiv, cDivRet )
      nTotPnt     := nCnv2Div( nTotPnt, cCodDiv, cDivRet )
      nTotTrn     := nCnv2Div( nTotTrn, cCodDiv, cDivRet )
      cPorDiv     := cPorDiv( cDivRet, cDiv )
   end if

RETURN ( if( lPic, Trans( nTotPed, cPorDiv ), nTotPed ) )

//--------------------------------------------------------------------------//

Function nPntUPedCli( dbfTmpLin, nDec, nVdv )

   local nCalculo := ( dbfTmpLin )->NPNTVER

   DEFAULT nDec   := 2
   DEFAULT nVdv   := 1

	IF nVdv != 0
      nCalculo    /= nVdv
	END IF

RETURN ( Round( nCalculo, nDec ) )

//---------------------------------------------------------------------------//

FUNCTION nTrnUPedCli( dbfTmpLin, nDec, nVdv )

	local nCalculo

   DEFAULT nDec   := 0
   DEFAULT nVdv   := 1

   nCalculo       := ( dbfTmpLin )->nImpTrn

	IF nVdv != 0
      nCalculo    := nCalculo / nVdv
	END IF

RETURN ( Round( nCalculo, nDec ) )

//---------------------------------------------------------------------------//

FUNCTION nDtoUPedCli( dbfTmpLin, nDec, nVdv )

   local nCalculo := ( dbfTmpLin )->nDtoDiv

   DEFAULT nDec   := 2
   DEFAULT nVdv   := 1

	IF nVdv != 0
      nCalculo    /= nVdv
	END IF

RETURN ( round( nCalculo, nDec ) )

//---------------------------------------------------------------------------//
//Total de una linea con impuestos incluidos

FUNCTION nTotFPedCli( cPedCliL, nDec, nRou, nVdv, lDto, lPntVer, lImpTrn, cPorDiv )

   local nCalculo := 0

   nCalculo       += nTotLPedCli( cPedCliL, nDec, nRou, nVdv, lDto, lPntVer, lImpTrn )
   nCalculo       += nIvaLPedCli( cPedCliL, nDec, nRou, nVdv, lDto, lPntVer, lImpTrn )

return ( if( cPorDiv != nil, Trans( nCalculo, cPorDiv ), nCalculo ) )

//---------------------------------------------------------------------------//

FUNCTION nTotUPedCli( uTmpLin, nDec, nVdv )

   local nCalculo       := 0

   if !Empty( nView )
      DEFAULT uTmpLin   := D():PedidosClientesLineas( nView )
   end if

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

      case Valtype( uTmpLin ) == "H"
         nCalculo       := hGet( uTmpLin, "PrecioVenta" )

   end case 

   if nVdv != 0
      nCalculo          := nCalculo / nVdv
   end if

RETURN ( Round( nCalculo, nDec ) )

//---------------------------------------------------------------------------//

//
// Total anticipos de un pedido
//

FUNCTION nPagPedCli( cNumPed, dbfPedCliP, cdbfDiv, cDivRet, lPic, lAll )

   local nRec           := ( dbfPedCliP )->( Recno() )
   local nOrd           := ( dbfPedCliP )->( OrdSetFocus( "nNumPed" ) )
   local cCodDiv        := cDivEmp()
   local cPorDiv        := cPorDiv( cCodDiv, cdbfDiv ) // Picture de la divisa redondeada
   local nRouDiv        := nRouDiv( cCodDiv, cdbfDiv )

   nTotPag              := 0

   DEFAULT lPic         := .f.
   DEFAULT lAll         := .t.

   if Empty( cNumPed )

      ( dbfPedCliP )->( dbGoTop() )
      while !( dbfPedCliP )->( Eof() )

         if lAll .or. !( dbfPedCliP )->lPasado
            nTotPag     += nEntPedCli( dbfPedCliP, cdbfDiv, cDivRet )
         end if

         ( dbfPedCliP )->( dbSkip() )

      end while

   else

      if ( dbfPedCliP )->( dbSeek( cNumPed ) )

         while ( dbfPedCliP )->cSerPed + Str( ( dbfPedCliP )->nNumPed ) + ( dbfPedCliP )->cSufPed == cNumPed .and. !( dbfPedCliP )->( eof() )

            if lAll .or. !( dbfPedCliP )->lPasado
               nTotPag   += nEntPedCli( dbfPedCliP, cdbfDiv, cDivRet )
            end if

            ( dbfPedCliP )->( dbSkip() )

         end while

      end if

   end if

   if cDivRet != nil .and. cCodDiv != cDivRet
      nTotPag           := nCnv2Div( nTotPag, cCodDiv, cDivRet )
      cPorDiv           := cPorDiv( cDivRet, cdbfDiv ) // Picture de la divisa redondeada
      nRouDiv           := nRouDiv( cDivRet, cdbfDiv )
   end if

   nTotPag              := Round( nTotPag, nRouDiv )

   if lPic
      nTotPag           := Trans( nTotPag, cPorDiv )
   end if

   ( dbfPedCliP )->( OrdSetFocus( nOrd ) )
   ( dbfPedCliP )->( dbGoTo( nRec ) )

RETURN ( nTotPag )

//--------------------------------------------------------------------------//

function nEntPedCli( uPedCliP, cDbfDiv, cDivRet, lPic )

   local cDivPgo
   local nRouDiv
   local cPorDiv
   local nTotRec

   DEFAULT uPedCliP  := D():PedidosClientesPagos( nView )
   DEFAULT cDbfDiv   := D():Divisas( nView )
   DEFAULT cDivRet   := cDivEmp()
   DEFAULT lPic      := .f.

   if ValType( uPedCliP ) == "O"
      cDivPgo        := uPedCliP:cDivPgo
      nTotRec        := uPedCliP:nImporte
   else
      cDivPgo        := ( uPedCliP )->cDivPgo
      nTotRec        := ( uPedCliP )->nImporte
   end if

   nRouDiv           := nRouDiv( cDivPgo, cDbfDiv )
   cPorDiv           := cPorDiv( cDivPgo, cDbfDiv )

   nTotRec           := Round( nTotRec, nRouDiv )

   if cDivRet != cDivPgo
      nRouDiv        := nRouDiv( cDivRet, cDbfDiv )
      cPorDiv        := cPorDiv( cDivRet, cDbfDiv )
      nTotRec        := nCnv2Div( nTotRec, cDivPgo, cDivRet )
   end if

RETURN if( lPic, Trans( nTotRec, cPorDiv ), nTotRec )

//------------------------------------------------------------------------//

FUNCTION nComLPedCli( uPedCliT, cPedCliL, nDecOut, nDerOut )

   local nImpLPedCli := nImpLPedCli( uPedCliT, cPedCliL, nDecOut, nDerOut, , .f., .t., .f. )

RETURN ( nImpLPedCli * ( cPedCliL )->nComAge / 100 )

//--------------------------------------------------------------------------//

/*
Cálculo del neto, sin descuentos para las comisiones de los agentes
*/

FUNCTION nImpLPedCli( uPedCliT, cPedCliL, nDec, nRou, nVdv, lIva, lDto, lPntVer, lImpTrn, cPouDiv )

   local nCalculo
   local lIvaInc

   DEFAULT nDec      := 0
   DEFAULT nRou      := 0
   DEFAULT nVdv      := 1
   DEFAULT lIva      := .f.
   DEFAULT lDto      := .t.
   DEFAULT lPntVer   := .f.
   DEFAULT lImpTrn   := .f.

   nCalculo          := nTotLPedCli( cPedCliL, nDec, nRou, nVdv, .t., lImpTrn, lPntVer )

   if IsArray( uPedCliT )

      nCalculo       -= Round( nCalculo * uPedCliT[ _NDTOESP ]  / 100, nRou )
      nCalculo       -= Round( nCalculo * uPedCliT[ _NDPP    ]  / 100, nRou )
      nCalculo       -= Round( nCalculo * uPedCliT[ _NDTOUNO ]  / 100, nRou )
      nCalculo       -= Round( nCalculo * uPedCliT[ _NDTODOS ]  / 100, nRou )

      lIvaInc        := uPedCliT[ _LIVAINC ]

   else
      
      nCalculo       -= Round( nCalculo * ( uPedCliT )->nDtoEsp / 100, nRou )
      nCalculo       -= Round( nCalculo * ( uPedCliT )->nDpp    / 100, nRou )
      nCalculo       -= Round( nCalculo * ( uPedCliT )->nDtoUno / 100, nRou )
      nCalculo       -= Round( nCalculo * ( uPedCliT )->nDtoDos / 100, nRou )
      
      lIvaInc        := ( uPedCliT )->lIvaInc

   end if

   if ( cPedCliL )->nIva != 0
      if lIva  // lo quermos con impuestos
         if !lIvaInc
            nCalculo += Round( nCalculo * ( cPedCliL )->nIva / 100, nRou )
         end if
      else     // lo queremos sin impuestos
         if lIvaInc
            nCalculo -= Round( nCalculo / ( 100 / ( cPedCliL )->nIva  + 1 ), nRou )
         end if
      end if
   end if

RETURN ( if( cPouDiv != NIL, Trans( nCalculo, cPouDiv ), nCalculo ) )

//---------------------------------------------------------------------------//

FUNCTION nPesLPedCli( cPedCliL )

	local nCalculo

   if !Empty( nView )
      DEFAULT cPedCliL  := D():PedidosClientesLineas( nView )
   end if   

   if !( cPedCliL )->lTotLin
      nCalculo       := Abs( nTotNPedCli( cPedCliL ) ) * ( cPedCliL )->nPesoKg
   end if

RETURN ( nCalculo )

//---------------------------------------------------------------------------//

FUNCTION nTotCPedCli( dbfLine, nDec, nRec, nVdv, cPouDiv )

   local nCalculo       := 0

   DEFAULT nDec         := 0
   DEFAULT nRec         := 0
   DEFAULT nVdv         := 1

   if !( dbfLine )->lKitChl
      nCalculo          := nTotNPedCli( dbfLine )
      nCalculo          *= ( dbfLine )->nCosDiv
   end if

   if nVdv != 0
      nCalculo          := nCalculo / nVdv
   end if

   nCalculo             := Round( nCalculo, nRec )

RETURN ( if( cPouDiv != nil, Trans( nCalculo, cPouDiv ), nCalculo ) )

//---------------------------------------------------------------------------//

FUNCTION nTotIPedCli( dbfLin, nDec, nRouDec, nVdv, cPorDiv )

   local nCalculo       := 0

   if !Empty( nView )
      DEFAULT dbfLin    := D():PedidosClientesLineas( nView )
   end if

   DEFAULT nDec         := 0
   DEFAULT nRouDec      := 0
   DEFAULT nVdv         := 1

   IF !( dbfLin )->lTotLin

      /*
      Tomamos los valores redondeados------------------------------------------
      */

      nCalculo       := Round( ( dbfLin )->nValImp, nDec )

      /*
      Unidades-----------------------------------------------------------------
      */

      nCalculo       *= nTotNPedCli( dbfLin )

         if ( dbfLin )->LVOLIMP
            nCalculo *= NotCero( ( dbfLin )->nVolumen )
         end if

      nCalculo       := Round( nCalculo / nVdv, nRouDec )

   END IF

RETURN ( if( cPorDiv != NIL, Trans( nCalculo, cPorDiv ), nCalculo ) )

//----------------------------------------------------------------------------//

FUNCTION nTrnLPedCli( dbfLin, nDec, nRou, nVdv )

   local nImpTrn

   if !Empty( nView )
      DEFAULT dbfLin    := D():PedidosClientesLineas( nView )
   end if

   DEFAULT nDec         := 2
   DEFAULT nRou         := 2
   DEFAULT nVdv         := 1

   /*
   Punto Verde
   */

   nImpTrn           := nTrnUPedCli( dbfLin, nDec ) * nTotNPedCli( dbfLin )

   IF nVdv != 0
      nImpTrn        := nImpTrn / nVdv
	END IF

RETURN ( Round( nImpTrn, nRou ) )

//---------------------------------------------------------------------------//

FUNCTION nPntLPedCli( dbfLin, nDec, nVdv )

   local nPntVer

   if !Empty( nView )
      DEFAULT dbfLin    := D():PedidosClientesLineas( nView )
   end if

   DEFAULT nDec         := 2
   DEFAULT nVdv         := 1

   /*
   Punto Verde
   */

   nPntVer              := ( dbfLin )->nPntVer / nVdv
   nPntVer              *= nTotNPedCli( dbfLin )

RETURN ( Round( nPntVer, nDec ) )

//---------------------------------------------------------------------------//

Function isLineaTotalPedCli( uPedCliL )

   if isArray( uPedCliL )
      Return ( uPedCliL[ _LTOTLIN ] )
   end if

Return ( ( uPedCliL )->lTotLin )

//---------------------------------------------------------------------------//

Function nDescuentoLinealPedCli( uPedCliL, nDec, nVdv )

   local nDescuentoLineal

   if isArray( uPedCliL )
      nDescuentoLineal  := uPedCliL[ _NDTODIV ]
   else 
      nDescuentoLineal  := ( uPedCliL )->nDtoDiv
   end if

Return ( Round( nDescuentoLineal / nVdv, nDec ) )

//---------------------------------------------------------------------------//

Function nDescuentoPorcentualPedCli( uPedCliL )

   local nDescuentoPorcentual

   if isArray( uPedCliL )
      nDescuentoPorcentual  := uPedCliL[ _NDTO ]
   else 
      nDescuentoPorcentual  := ( uPedCliL )->nDto
   end if

Return ( nDescuentoPorcentual )

//---------------------------------------------------------------------------//

Function nDescuentoPromocionPedCli( uPedCliL )

   local nDescuentoPromocion

   if isArray( uPedCliL )
      nDescuentoPromocion  := uPedCliL[ _NDTOPRM ]
   else 
      nDescuentoPromocion  := ( uPedCliL )->nDtoPrm
   end if

Return ( nDescuentoPromocion )

//---------------------------------------------------------------------------//

Function nPuntoVerdePedCli( uPedCliL )

   local nPuntoVerde

   if isArray( uPedCliL )
      nPuntoVerde  := uPedCliL[ _NPNTVER ]
   else 
      nPuntoVerde  := ( uPedCliL )->nPntVer
   end if

Return ( nPuntoVerde )

//---------------------------------------------------------------------------//

Function nTransportePedCli( uPedCliL )

   local nTransporte

   if isArray( uPedCliL )
      nTransporte  := uPedCliL[ _NIMPTRN ]
   else 
      nTransporte  := ( uPedCliL )->nImpTrn
   end if

Return ( nTransporte )

//---------------------------------------------------------------------------//

FUNCTION nTotLPedCli( uPedCliL, nDec, nRou, nVdv, lDto, lPntVer, lImpTrn, cPouDiv )

   local nCalculo
   local nUnidades

   if empty( uPedCliL ) .and. !empty( nView )
      uPedCliL       := D():PedidosClientesLineas( nView )
   end if

   DEFAULT nDec      := nDouDiv()
   DEFAULT nRou      := nRouDiv()
   DEFAULT nVdv      := 1
   DEFAULT lDto      := .t.
   DEFAULT lPntVer   := .t.
   DEFAULT lImpTrn   := .t.

   if isLineaTotalPedCli( uPedCliL )

      nCalculo       := nTotUPedCli( uPedCliL, nDec, nVdv )
      
   else

      nUnidades      := nTotNPedCli( uPedCliL )
      nCalculo       := nTotUPedCli( uPedCliL, nDec, nVdv ) * nUnidades

      /*
      Descuentos lineales------------------------------------------------------
      */

      nCalculo        -= nDescuentoLinealPedCli( uPedCliL, nDec, nVdv ) * nUnidades

      if lDto .and. nDescuentoPorcentualPedCli( uPedCliL ) != 0 
         nCalculo    -= nCalculo * nDescuentoPorcentualPedCli( uPedCliL ) / 100
      end if

      if lDto .and. nDescuentoPromocionPedCli( uPedCliL ) != 0 
         nCalculo    -= nCalculo * nDescuentoPromocionPedCli( uPedCliL ) / 100
      end if

      /*
      Punto Verde--------------------------------------------------------------
      */

      if lPntVer .and. nPuntoVerdePedCli( uPedCliL ) != 0
         nCalculo    += nPuntoVerdePedCli( uPedCliL ) * nUnidades
      end if

      /*
      Transporte---------------------------------------------------------------
      */

      if lImpTrn .and. nTransportePedCli( uPedCliL ) != 0
         nCalculo    += nTransportePedCli( uPedCliL ) * nUnidades
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

FUNCTION nDtoLPedCli( cPedCliL, nDec, nRou, nVdv )

   local nCalculo       := 0

   if !Empty( nView )
      DEFAULT cPedCliL  := D():PedidosClientesLineas( nView )
   end if

   DEFAULT nDec         := nDouDiv()
   DEFAULT nRou         := nRouDiv()
   DEFAULT nVdv         := 1

   if ( cPedCliL )->nDto != 0 .and. !( cPedCliL )->lTotLin

      nCalculo          := nTotUPedCli( cPedCliL, nDec ) * nTotNPedCli( cPedCliL )

      /*
      Descuentos---------------------------------------------------------------
      */

      nCalculo          -= Round( ( cPedCliL )->nDtoDiv / nVdv , nDec )

      nCalculo          := nCalculo * ( cPedCliL )->nDto / 100


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

FUNCTION nPrmLPedCli( cPedCliL, nDec, nRou, nVdv )

   local nCalculo       := 0

   if !Empty( nView )
      DEFAULT cPedCliL  := D():PedidosClientesLineas( nView )
   end if

   DEFAULT nDec         := nDouDiv()
   DEFAULT nRou         := nRouDiv()
   DEFAULT nVdv         := 1

   if ( cPedCliL )->nDtoPrm != 0 .and. !( cPedCliL )->lTotLin

      nCalculo          := nTotUPedCli( cPedCliL, nDec ) * nTotNPedCli( cPedCliL )

      /*
      Descuentos---------------------------------------------------------------
      */

      nCalculo          -= Round( ( cPedCliL )->nDtoDiv / nVdv , nDec )

      if ( cPedCliL )->nDto != 0 
         nCalculo       -= nCalculo * ( cPedCliL )->nDto / 100
      end if

      nCalculo          := nCalculo * ( cPedCliL )->nDtoPrm / 100

      if nVdv != 0
         nCalculo       := nCalculo / nVdv
      end if

      if nRou != nil
         nCalculo       := Round( nCalculo, nRou )
      end if

   end if

RETURN ( nCalculo ) 

//---------------------------------------------------------------------------//

Function nTotDtoLPedCli( dbfLin, nDec, nVdv, cPorDiv )

   local nCalculo

   if !Empty( nView )
      DEFAULT dbfLin := D():PedidosClientesLineas( nView )
   end if

   DEFAULT nDec      := nDouDiv()
   DEFAULT nVdv      := 1

   nCalculo          := nDtoLPedCli( dbfLin, nDec, nVdv ) * nTotNPedCli( dbfLin )

   if nVdv != 0
      nCalculo       := nCalculo / nVdv
   end if

   nCalculo          := Round( nCalculo, nDec )

RETURN ( if( cPorDiv != nil, Trans( nCalculo, cPorDiv ), nCalculo ) )

//----------------------------------------------------------------------------//

Function oPedidosWeb()

   if !Empty( oDlgPedidosWeb ) .and. !Empty( oBrwPedidosWeb )
      oBrwPedidosWeb:Refresh()
   else
      MuestraPedidosWeb()
   end if

Return nil

//---------------------------------------------------------------------------//

Function MuestraPedidosWeb( oBtnPedidos, lGoPedCli )

   local oError
   local oBlock
	local oCbxOrd
	local cNumPed
   local cDbfIva
   local cDbfDiv
   local cDbfPago
   local dbfPedCliR

   DEFAULT lGoPedCli    := .f.

   if lOpenFiles
      MsgStop( 'Imposible abrir ficheros de pedidos de clientes' )
      Return ( .f. )
   end if

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      TDataCenter():OpenPedCliT( @dbfPedCliT )
      ( dbfPedCliT )->( OrdSetFocus( "lInternet" ) )

      USE ( cPatEmp() + "PEDCLIL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PEDCLIL", @dbfPedCliL ) )
      SET ADSINDEX TO ( cPatEmp() + "PEDCLIL.CDX" ) ADDITIVE

      USE ( cPatEmp() + "PEDCLIR.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PEDCLIR", @dbfPedCliR ) )
      SET ADSINDEX TO ( cPatEmp() + "PEDCLIR.CDX" ) ADDITIVE

      USE ( cPatEmp() + "PEDCLII.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PEDCLII", @dbfPedCliI ) )
      SET ADSINDEX TO ( cPatEmp() + "PEDCLII.CDX" ) ADDITIVE

      USE ( cPatEmp() + "PEDCLID.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PEDCLID", @dbfPedCliD ) )
      SET ADSINDEX TO ( cPatEmp() + "PEDCLID.CDX" ) ADDITIVE

      USE ( cPatEmp() + "PEDCLIP.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PEDCLIP", @dbfPedCliP ) )
      SET ADSINDEX TO ( cPatEmp() + "PEDCLIP.CDX" ) ADDITIVE

      USE ( cPatDat() + "TIVA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIVA", @cdbfIva ) )
      SET ADSINDEX TO ( cPatDat() + "TIVA.CDX" ) ADDITIVE

      USE ( cPatEmp() + "FPAGO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FPAGO", @cDbfPago ) )
      SET ADSINDEX TO ( cPatEmp() + "FPAGO.CDX" ) ADDITIVE

      USE ( cPatDat() + "DIVISAS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "DIVISAS", @cdbfDiv ) )
      SET ADSINDEX TO ( cPatDat() + "DIVISAS.CDX" ) ADDITIVE

      USE ( cPatEmp() + "CLIENT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CLIENT", @dbfClient ) )
      SET ADSINDEX TO ( cPatEmp() + "CLIENT.CDX" ) ADDITIVE

      /*
      Primero Crear la base de datos local-------------------------------------
      */

      cTmpLin        := cGetNewFileName( cPatTmp() + "cPedLin" )

      dbCreate( cTmpLin, aSqlStruct( aColPedCli() ), cLocalDriver() )
      dbUseArea( .t., cLocalDriver(), cTmpLin, cCheckArea( "PedCliL", @dbfTmpLin ), .f. )

      if !NetErr()

         ( dbfTmpLin )->( OrdCondSet( "!Deleted()", {||!Deleted() } ) )
         ( dbfTmpLin )->( OrdCreate( cTmpLin, "nNumLin", "Str( nNumLin, 4 )", {|| Str( Field->nNumLin ) } ) )

         ( dbfTmpLin )->( OrdCondSet( "!Deleted()", {||!Deleted()} ) )
         ( dbfTmpLin )->( OrdCreate( cTmpLin, "Recno", "Str( Recno() )", {|| Str( Recno() ) } ) )

      end if

      DEFINE DIALOG oDlgPedidosWeb RESOURCE "PEDIDOS_INTERNET"

      oBrwPedidosWeb                 := IXBrowse():New( oDlgPedidosWeb )

      oBrwPedidosWeb:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwPedidosWeb:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrwPedidosWeb:cAlias          := dbfPedCliT
      oBrwPedidosWeb:nMarqueeStyle   := 6
      oBrwPedidosWeb:cName           := "Pedido de cliente.Web"
      oBrwPedidosWeb:nRowHeight      := 40

      oBrwPedidosWeb:bLDblClick      := {|| oDlgPedidosWeb:end( IDOK ) }

      oBrwPedidosWeb:bChange         := {|| ChangePedidosWeb() }

      oBrwPedidosWeb:CreateFromResource( 100 )

      with object ( oBrwPedidosWeb:AddCol() )
         :cHeader          := "Es.Estado"
         :bStrData         := {|| "" }
         :bEditValue       := {|| ( ( dbfPedCliT )->nEstado == 1 ) }
         :nWidth           := 20
         :lHide            := .t.
         :SetCheck( { "gc_shape_square_12", "gc_delete_12" } )
      end with

      with object ( oBrwPedidosWeb:AddCol() )
         :cHeader          := "Número"
         :cSortOrder       := "nNumPed"
         :bEditValue       := {|| ( dbfPedCliT )->cSerPed + "/" + Alltrim( Str( ( dbfPedCliT )->nNumPed ) ) + "/" + ( dbfPedCliT )->cSufPed }
         :nWidth           := 60
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrwPedidosWeb:AddCol() )
         :cHeader          := "Fecha"
         :cSortOrder       := "dFecPed"
         :bEditValue       := {|| dtoc( ( dbfPedCliT )->dFecPed ) }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrwPedidosWeb:AddCol() )
         :cHeader          := "Hora"
         :bEditValue       := {|| ( dbfPedCliT )->cTimCre }
         :nWidth           := 40
      end with

      with object ( oBrwPedidosWeb:AddCol() )
         :cHeader          := "Cliente"
         :cSortOrder       := "cCodCli"
         :bEditValue       := {|| AllTrim( ( dbfPedCliT )->cCodCli ) }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrwPedidosWeb:AddCol() )
         :cHeader          := "Nombre"
         :cSortOrder       := "cNomCli"
         :bEditValue       := {|| AllTrim( ( dbfPedCliT )->cNomCli ) }
         :nWidth           := 200
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrwPedidosWeb:AddCol() )
         :cHeader          := "Telefono"
         :bEditValue       := {|| RetFld( ( dbfPedCliT )->cCodCli, dbfClient, "Telefono" ) }
         :nWidth           := 80
      end with

      with object ( oBrwPedidosWeb:AddCol() )
         :cHeader          := "Importe"
         :bEditValue       := {|| nTotPedCli( ( dbfPedCliT )->cSerPed + Str( ( dbfPedCliT )->nNumPed ) + ( dbfPedCliT )->cSufPed, dbfPedCliT, dbfPedCliL, cdbfIva, cdbfDiv, cDbfPago, nil, cDivEmp(), .t. ) }
         :nWidth           := 80
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with


      oBrwDetallesPedidos                 := IXBrowse():New( oDlgPedidosWeb )

      oBrwDetallesPedidos:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwDetallesPedidos:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrwDetallesPedidos:cAlias          := dbfTmpLin
      oBrwDetallesPedidos:nMarqueeStyle   := 6
      oBrwDetallesPedidos:cName           := "Pedido de cliente lineas.Web"

      // oBrwDetallesPedidos:bGoTop          := { || TopFilter( dbfTmpLin, ( dbfPedCliT )->cSerPed + Str( ( dbfPedCliT )->nNumPed ) + ( dbfPedCliT )->cSufPed ) }
      // oBrwDetallesPedidos:bGoBottom       := { || BottomFilter( dbfTmpLin, ( dbfPedCliT )->cSerPed + Str( ( dbfPedCliT )->nNumPed ) + ( dbfPedCliT )->cSufPed ) }
      // oBrwDetallesPedidos:bSkip           := { | n | SkipFilter( dbfTmpLin, ( dbfPedCliT )->cSerPed + Str( ( dbfPedCliT )->nNumPed ) + ( dbfPedCliT )->cSufPed, n ) }

      oBrwDetallesPedidos:CreateFromResource( 110 )

      with object ( oBrwDetallesPedidos:AddCol() )
         :cHeader             := "Num."
         :bEditValue          := {|| ( dbfTmpLin )->nNumLin }
         :cEditPicture        := "9999"
         :nWidth              := 35
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
      end with

      with object ( oBrwDetallesPedidos:AddCol() )
         :cHeader             := "Código"
         :bEditValue          := {|| ( dbfTmpLin )->cRef }
         :nWidth              := 70
      end with

      with object ( oBrwDetallesPedidos:AddCol() )
         :cHeader             := "Descripción"
         :bEditValue          := {|| if( Empty( ( dbfTmpLin )->cRef ), ( dbfTmpLin )->mLngDes, ( dbfTmpLin )->cDetalle ) }
         :nWidth              := 215
      end with

      with object ( oBrwDetallesPedidos:AddCol() )
         :cHeader             := "Prop. 1"
         :bEditValue          := {|| ( dbfTmpLin )->cValPr1 }
         :nWidth              := 40
         :lHide               := .t.
      end with

      with object ( oBrwDetallesPedidos:AddCol() )
         :cHeader             := "Prop. 2"
         :bEditValue          := {|| ( dbfTmpLin )->cValPr2 }
         :nWidth              := 40
         :lHide               := .t.
      end with

      with object ( oBrwDetallesPedidos:AddCol() )
         :cHeader             := "Lote"
         :bEditValue          := {|| ( dbfTmpLin )->cLote }
         :nWidth              := 60
         :lHide               := .t.
      end with

      with object ( oBrwDetallesPedidos:AddCol() )
         :cHeader             := cNombreUnidades()
         :bEditValue          := {|| nTotNPedCli( dbfTmpLin ) }
         :cEditPicture        := cPicUnd
         :nWidth              := 60
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
      end with

      with object ( oBrwDetallesPedidos:AddCol() )
         :cHeader             := "UM. Unidad de medición"
         :bEditValue          := {|| ( dbfTmpLin )->cUnidad }
         :nWidth              := 25
      end with

      with object ( oBrwDetallesPedidos:AddCol() )
         :cHeader             := "Alm."
         :bEditValue          := {|| ( dbfTmpLin )->cAlmLin }
         :nWidth              := 30
      end with

      with object ( oBrwDetallesPedidos:AddCol() )
         :cHeader             := "Precio"
         :bEditValue          := {|| nTotUPedCli( dbfTmpLin, nDouDiv ) }
         :cEditPicture        := cPouDiv
         :nWidth              := 60
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
      end with

      with object ( oBrwDetallesPedidos:AddCol() )
         :cHeader             := "% Dto."
         :bEditValue          := {|| ( dbfTmpLin )->nDto }
         :cEditPicture        := "@E 999.99"
         :nWidth              := 40
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
      end with

      with object ( oBrwDetallesPedidos:AddCol() )
         :cHeader             := "Dto. Lin."
         :bEditValue          := {|| nDtoUPedCli( dbfTmpLin, nDouDiv ) }
         :cEditPicture        := cPouDiv
         :nWidth              := 50
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
         :lHide               := .t.
      end with

      with object ( oBrwDetallesPedidos:AddCol() )
         :cHeader             := "% Prm."
         :bEditValue          := {|| ( dbfTmpLin )->nDtoPrm }
         :cEditPicture        := "@E 99.99"
         :nWidth              := 40
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
         :lHide               := .t.
      end with

      with object ( oBrwDetallesPedidos:AddCol() )
         :cHeader             := "% Age"
         :bEditValue          := {|| ( dbfTmpLin )->nComAge }
         :cEditPicture        := "@E 999.99"
         :nWidth              := 40
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
         :lHide               := .t.
      end with

      with object ( oBrwDetallesPedidos:AddCol() )
         :cHeader             := "% " + cImp()
         :bEditValue          := {|| ( dbfTmpLin )->nIva }
         :cEditPicture        := "@E 99.9"
         :nWidth              := 40
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
      end with

      with object ( oBrwDetallesPedidos:AddCol() )
         :cHeader             := "Portes"
         :bEditValue          := {|| nTrnUPedCli( dbfTmpLin, nDouDiv ) }
         :cEditPicture        := cPouDiv
         :nWidth              := 70
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
         :lHide               := .t.
      end with

      with object ( oBrwDetallesPedidos:AddCol() )
         :cHeader             := "P. verde"
         :bEditValue          := {|| nPntUPedCli( dbfTmpLin, nDpvDiv ) }
         :cEditPicture        := cPouDiv
         :nWidth              := 70
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
         :lHide               := .t.
      end with

      with object ( oBrwDetallesPedidos:AddCol() )
         :cHeader             := "Total"
         :bEditValue          := {|| nTotLPedCli( dbfTmpLin, nDouDiv, nRouDiv ) }
         :cEditPicture        := cPorDiv
         :nWidth              := 80
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
      end with

      oDlgPedidosWeb:bStart   := {|| StartPedidosWeb( oDlgPedidosWeb ) }

      ACTIVATE DIALOG oDlgPedidosWeb CENTER

      /*
      Guradamos el numero del pedido-------------------------------------------
      */

      if oDlgPedidosWeb:nResult == IDOK
         cNumPed              := ( dbfPedCliT )->cSerPed + Str( ( dbfPedCliT )->nNumPed ) + ( dbfPedCliT )->cSufPed
      end if

      /*
      Comprobamos para volver activar el aviso de los pedidos------------------
      */

      if dbSeekInOrd( .t., 'lIntPedCli', dbfPedCliT )
         lStartAvisoPedidos()
      else
         lStopAvisoPedidos()
      end if

      if !Empty( oBtnPedidos )
         oBtnPedidos:lSelected   := .f.
         oBtnPedidos:Refresh()
      end if

   RECOVER USING oError

      msgStop( 'Imposible abrir ficheros de pedidos de clientes' + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   CLOSE ( dbfPedCliT )
   CLOSE ( dbfPedCliL )
   CLOSE ( dbfPedCliP )
   CLOSE ( dbfPedCliR )
   CLOSE ( dbfPedCliI )
   CLOSE ( dbfPedCliD )
   CLOSE ( cDbfPago   )
   CLOSE ( cdbfDiv    )
   CLOSE ( cdbfIva    )
   CLOSE ( dbfClient  )
   CLOSE ( dbfTmpLin  )

   oDlgPedidosWeb          := nil
   oBrwPedidosWeb          := nil
   oBrwDetallesPedidos     := nil

   dbfErase( cTmpLin )

Return ( cNumPed )

//---------------------------------------------------------------------------//

Function lPedidosWeb()

   local nRec
   local oBlock
   local oError
   local dbfPedCliT

   oBlock                     := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      USE ( cPatEmp() + "PedCliT.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PedCliT", @dbfPedCliT ) )
      SET ADSINDEX TO ( cPatEmp() + "PedCliT.Cdx" ) ADDITIVE

      if dbSeekInOrd( .t., "lIntPedCli", dbfPedCliT )
   
         lStartAvisoPedidos()

         // Muestro un aviso en la barra de estado-----------------------------------

         if Empty( oMsgAlarm )
            oMsgAlarm         := TMsgItem():New( oWnd():oMsgBar,,24,,,,.t.,, "gc_earth_16",, "Nuevos pedidos recibidos"  )
            oMsgAlarm:bAction := {|| PedCli() }
         end if

      else

         lStopAvisoPedidos()

         // Elimino aviso en la barra de estado--------------------------------------

         if !Empty( oMsgAlarm )
            oWnd():oMsgBar:DelItem( oMsgAlarm )
         end if

      end if

   RECOVER USING oError

      msgStop( 'Imposible comprobar los pedidos recibidos por internet' + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   if ( dbfPedCliT )->( Used() )
      ( dbfPedCliT )->( dbCloseArea() )
   end if

Return nil

//---------------------------------------------------------------------------//

/*
Cambia el importe unitario de la linea
*/

FUNCTION SetUPedCli( dbfLin, nNewVal )

   if !Empty( nView )
      DEFAULT dbfLin    := D():PedidosClientesLineas( nView )
   end if	

   if ( dbfLin )->lAlquiler
      ( dbfLin )->nPreAlq 		:= nNewVal
   else
      ( dbfLin )->nPreDiv  	:= nNewVal
   end if

RETURN ( nil )

//---------------------------------------------------------------------------//

Function sTotPedCli( cPedido, dbfMaster, dbfLine, cdbfIva, cdbfDiv, cDivRet )

   local sTotal

   nTotPedCli( cPedido, dbfMaster, dbfLine, cdbfIva, cdbfDiv, nil, nil, cDivRet, .f. )

   sTotal                                 := sTotal()
   sTotal:nTotalBruto                     := nTotBrt
   sTotal:nTotalNeto                      := nTotNet
   sTotal:nTotalIva                       := nTotIva
   sTotal:aTotalIva                       := aTotIva
   sTotal:nTotalRecargoEquivalencia       := nTotReq
   sTotal:nTotalDocumento                 := nTotPed
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

STATIC FUNCTION EdtTablet( aTmp, aGet, dbf, oBrw, hHash, bValid, nMode )

   OrderCustomer():Resource()

RETURN ( .t. )

//---------------------------------------------------------------------------//

static function isChangeSerieTablet( lReadyToSend, getSerie )
   
   if lReadyToSend
      ChangeSerieTablet(getSerie)
   end if

Return ( nil )

//---------------------------------------------------------------------------//

static function ChangeSerieTablet( getSerie )

   local cSerie   := getSerie:VarGet()

   do case
      case cSerie == "A"
         getSerie:cText( "B" )

      case cSerie == "B"
         getSerie:cText( "A" )

      otherwise
         getSerie:cText( "A" )

   end case

Return ( nil )

//---------------------------------------------------------------------------//

function defineGetSerie( lSndDoc, cSerDoc, oDlg )

   local getSerie

   TGridUrllink():Build(            {  "nTop"      => 40,;
                                       "nLeft"     => {|| GridWidth( 0.5, oDlg ) },;
                                       "cURL"      => "Serie",;
                                       "oWnd"      => oDlg,;
                                       "oFont"     => oGridFont(),;
                                       "lPixel"    => .t.,;
                                       "nClrInit"  => nGridColor(),;
                                       "nClrOver"  => nGridColor(),;
                                       "nClrVisit" => nGridColor(),;
                                       "bAction"   => {|| isChangeSerieTablet( lSndDoc, getSerie ) } } )

   getSerie    := TGridGet():Build( {  "nRow"      => 40,;
                                       "nCol"      => {|| GridWidth( 2.5, oDlg ) },;
                                       "bSetGet"   => {|u| if( PCount() == 0, cSerDoc, cSerDoc := u ) },;
                                       "oWnd"      => oDlg,;
                                       "nWidth"    => {|| GridWidth( 2, oDlg ) },;
                                       "nHeight"   => 23,;
                                       "cPict"     => "@!",;
                                       "lPixels"   => .t. } )   

Return ( nil )

//---------------------------------------------------------------------------//

function defineGetCliente( aGet, aTmp, getCodCli, getNomCli, nMode, oDlg )

   TGridUrllink():Build({  "nTop"      => 95,;
                           "nLeft"     => {|| GridWidth( 0.5, oDlg ) },;
                           "cURL"      => "Cliente",;
                           "oWnd"      => oDlg,;
                           "oFont"     => oGridFont(),;
                           "lPixel"    => .t.,;
                           "nClrInit"  => nGridColor(),;
                           "nClrOver"  => nGridColor(),;
                           "nClrVisit" => nGridColor(),;
                           "bAction"   => {|| Prueba() } } )

   getCodCli         := TGridGet():Build( {  "nRow"      => 95,;
                                             "nCol"      => {|| GridWidth( 2.5, oDlg ) },;
                                             "bSetGet"   => {|u| if( PCount() == 0, aTmp[ _CCODCLI ], aTmp[ _CCODCLI ] := u ) },;
                                             "oWnd"      => oDlg,;
                                             "nWidth"    => {|| GridWidth( 2, oDlg ) },;
                                             "nHeight"   => 23,;
                                             "lPixels"   => .t.,;
                                             "bValid"    => {|| loaCli( aGet, aTmp, nMode ) } } )
   
   getNomCli         := TGridGet():Build( {  "nRow"      => 95,;
                                             "nCol"      => {|| GridWidth( 4.5, oDlg ) },;
                                             "bSetGet"   => {|u| if( PCount() == 0, aTmp[ _CNOMCLI ], aTmp[ _CNOMCLI ] := u ) },;
                                             "oWnd"      => oDlg,;
                                             "lPixels"   => .t.,;
                                             "nWidth"    => {|| GridWidth( 7, oDlg ) },;
                                             "nHeight"   => 23 } )

Return ( nil )

//---------------------------------------------------------------------------// 

function Prueba()

   local hashDictionaryCabecera
   local hashDictionaryLineas
   
   /*
   Cabecera
   */

   hashDictionaryCabecera     := D():GetPedidoCliente( nView )
   
   MsgInfo( ValToPrg( hashDictionaryCabecera ), Len( hashDictionaryCabecera ) )

   
   hashDictionaryCabecera     := D():GetPedidoClienteById( D():PedidosClientesId( nView ), nView )
   MsgInfo( ValToPrg( hashDictionaryCabecera ), Len( hashDictionaryCabecera ) )
   
   /*
   Cabecera Blank
   */
   
   hashDictionaryCabecera     := D():GetPedidoClienteBlank( nView )
   
   MsgInfo( ValToPrg( hashDictionaryCabecera ), Len( hashDictionaryCabecera ) )

   /*
   Lineas
   */

   hashDictionaryLineas     := D():GetPedidoClienteLineas( nView )
   
   MsgInfo( ValToPrg( hashDictionaryLineas ), Len( hashDictionaryLineas ) )

   /*
   Lineas blank
   */

   hashDictionaryLineas     := D():GetPedidoClienteLineaBlank( nView )
   
   MsgInfo( ValToPrg( hashDictionaryLineas ), Len( hashDictionaryLineas ) )

Return ( nil )

//---------------------------------------------------------------------------//

Function nTotalLineaPedidoCliente( hHash, nDec, nRou, nVdv, lDto, lPntVer, lImpTrn, cPouDiv )

   local nCalculo

   DEFAULT nDec      := nDouDiv()
   DEFAULT nRou      := nRouDiv()
   DEFAULT nVdv      := 1
   DEFAULT lDto      := .t.
   DEFAULT lPntVer   := .t.
   DEFAULT lImpTrn   := .t.

   if hGet( hHash, "LineaTotal" )

      nCalculo       := nTotUPedCli( hHash )
      
   else

      nCalculo       := nTotUPedCli( hHash )

      /*
      Descuentos lineales------------------------------------------------------
      */

      if lDto

         nCalculo    -= Round( hGet( hHash, "DescuentoLineal" ) / nVdv , nDec )
      
         if hGet( hHash, "DescuentoPorcentual" ) != 0
            nCalculo -= nCalculo * hGet( hHash, "DescuentoPorcentual" )    / 100
         end if

         if hGet( hHash, "DescuentoPromocion" ) != 0
            nCalculo -= nCalculo * hGet( hHash, "DescuentoPromocion" ) / 100
         end if

      end if 

      /*
      Punto Verde--------------------------------------------------------------
      */

      if lPntVer
         nCalculo    += hGet( hHash, "PuntoVerde" )
      end if

      /*
      Transporte---------------------------------------------------------------
      */

      if lImpTrn 
         nCalculo    += hGet( hHash, "Portes" )
      end if

      /* 
      Unidades-----------------------------------------------------------------
      */

      nCalculo       *= nTotNPedCli( hHash )

   end if

   if nRou != nil
      nCalculo       := Round( Div( nCalculo, nVdv ), nRou )
   end if

RETURN ( if( cPouDiv != nil, Trans( nCalculo, cPouDiv ), nCalculo ) )

//---------------------------------------------------------------------------//

Static Function cFormatoPedidosClientes( cSerie )

   local cFormato

   DEFAULT cSerie    := ( D():PedidosClientes( nView ) )->cSerPed

   cFormato          := cFormatoDocumento( cSerie, "nPedCli", D():Contadores( nView ) )

   if Empty( cFormato )
      cFormato       := cFirstDoc( "PC", D():Documentos( nView ) )
   end if

Return ( cFormato ) 

//---------------------------------------------------------------------------//   

Function DesignLabelPedidoClientes( oFr, dbfDoc )

   local oLabel   
   local lOpenFiles  := empty( nView ) 

   if lOpenFiles .and. !Openfiles()
      Return .f.
   endif

   oLabel            := TLabelGeneratorPedidoClientes():New( nView )

   // Zona de datos---------------------------------------------------------
   
   oLabel:createTempLabelReport()
   oLabel:loadTempLabelReport()      
   oLabel:dataLabel( oFr )

   // Paginas y bandas------------------------------------------------------

   if !empty( ( dbfDoc )->mReport )
      oFr:LoadFromBlob( ( dbfDoc )->( Select() ), "mReport")
   else
      oFr:AddPage(         "MainPage" )
      oFr:AddBand(         "MasterData",  "MainPage",       frxMasterData )
      oFr:SetProperty(     "MasterData",  "Top",            200 )
      oFr:SetProperty(     "MasterData",  "Height",         100 )
      oFr:SetObjProperty(  "MasterData",  "DataSet",        "Lineas de pedidos" )
   end if

   // Zona de variables--------------------------------------------------------

   variableReport( oFr )

   // Diseño de report------------------------------------------------------

   oFr:DesignReport()
   oFr:DestroyFr()

   oLabel:DestroyTempReport()
   oLabel:End()

   if lOpenFiles
      closeFiles()
   end if 

Return .t.

//---------------------------------------------------------------------------//   

Function getExtraFieldPedidoCliente( cFieldName )

Return ( getExtraField( cFieldName, oDetCamposExtra, D():PedidosClientesId( nView ) ) )

//---------------------------------------------------------------------------//   

Static Function lChangeRegIva( aTmp )

   lImpuestos     := ( aTmp[ _NREGIVA ] <= 1 )

   if !Empty( oImpuestos )
      oImpuestos:Refresh()
   end if

return ( .t. )

//---------------------------------------------------------------------------//

Function lEntregadoPedidoCliente( cNumeroPedido, cPedCliT )

   local lEntregadoPedidoCliente    := .f.

   if dbSeekInOrd( cNumeroPedido, "nNumPed", cPedCliT )
      lEntregadoPedidoCliente       := ( cPedCliT )->nEstado == 3 .or. ( cPedCliT )->lCancel
   end if 

Return ( lEntregadoPedidoCliente )   

//---------------------------------------------------------------------------//

Static Function importarArticulosScaner()

   local memoArticulos

   memoArticulos  := dialogArticulosScaner()
   
   if memoArticulos != nil
      msgStop( memoArticulos, "procesar")
   end if

Return nil       

//---------------------------------------------------------------------------//

Function setPedidosClientesExternalView( nExternalView )

   nView          := nExternalView

Return nil       

//---------------------------------------------------------------------------//
