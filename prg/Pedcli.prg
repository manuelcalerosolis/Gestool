#include "FiveWin.Ch"
#include "Folder.ch"
#include "Report.ch"
#include "Menu.ch"
#include "Xbrowse.ch"

#include "Factu.ch" 

#define CLR_BAR                    14197607
#define _MENUITEM_                 "01056"

/*
Definici�n de la base de datos de pedidos a clientes
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
#define _CPAISIBAN 				  93
#define _CCTRLIBAN 				  94
#define _CENTBNC                  95
#define _CSUCBNC                  96
#define _CDIGBNC                  97
#define _CCTABNC                  98
#define _LPRODUC                  99
#define _NDTOTARIFA              100

/*
Definici�n de la base de datos de lineas de detalle
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

/*
Array para impuestos
*/

#define _NBRTIVA1                aTotIva[ 1, 1 ]
#define _NBASIVA1                aTotIva[ 1, 2 ]
#define _NPCTIVA1                aTotIva[ 1, 3 ]
#define _NPCTREQ1                aTotIva[ 1, 4 ]
#define _NPNTVER1                aTotIva[ 1, 5 ]
#define _NIVMIVA1                aTotIva[ 1, 6 ]
#define _NTRNIVA1                aTotIva[ 1, 7 ]
#define _NIMPIVA1                aTotIva[ 1, 8 ]
#define _NIMPREQ1                aTotIva[ 1, 9 ]
#define _NBRTIVA2                aTotIva[ 2, 1 ]
#define _NBASIVA2                aTotIva[ 2, 2 ]
#define _NPCTIVA2                aTotIva[ 2, 3 ]
#define _NPCTREQ2                aTotIva[ 2, 4 ]
#define _NPNTVER2                aTotIva[ 2, 5 ]
#define _NIVMIVA2                aTotIva[ 2, 6 ]
#define _NTRNIVA2                aTotIva[ 2, 7 ]
#define _NIMPIVA2                aTotIva[ 2, 8 ]
#define _NIMPREQ2                aTotIva[ 2, 9 ]
#define _NBRTIVA3                aTotIva[ 3, 1 ]
#define _NBASIVA3                aTotIva[ 3, 2 ]
#define _NPCTIVA3                aTotIva[ 3, 3 ]
#define _NPCTREQ3                aTotIva[ 3, 4 ]
#define _NPNTVER3                aTotIva[ 3, 5 ]
#define _NIVMIVA3                aTotIva[ 3, 6 ]
#define _NTRNIVA3                aTotIva[ 3, 7 ]
#define _NIMPIVA3                aTotIva[ 3, 8 ]
#define _NIMPREQ3                aTotIva[ 3, 9 ]

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
memvar cDbfUsr
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
static bEdtDet       := { |aTmp, aGet, dbfPedCliL, oBrw, bWhen, bValid, nMode, aTmpPed | EdtDet( aTmp, aGet, dbfPedCliL, oBrw, bWhen, bValid, nMode, aTmpPed ) }
static bEdtRes       := { |aTmp, aGet, dbfPedCliR, oBrw, bWhen, bValid, nMode, aTmpLin | EdtRes( aTmp, aGet, dbfPedCliR, oBrw, bWhen, bValid, nMode, aTmpLin ) }
static bEdtDoc       := { |aTmp, aGet, dbfPedCliD, oBrw, bWhen, bValid, nMode, aTmpLin | EdtDoc( aTmp, aGet, dbfPedCliD, oBrw, bWhen, bValid, nMode, aTmpLin ) }
static bEdtPgo       := { |aTmp, aGet, dbfPedCliP, oBrw, bWhen, bValid, nMode, aTmpPed | EdtEnt( aTmp, aGet, dbfPedCliP, oBrw, bWhen, bValid, nMode, aTmpPed ) }

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
static dbfPedCliR
static dbfPreCliT
static dbfPreCliL
static dbfPreCliI
static dbfPreCliD
static dbfPedPrvT
static dbfPedPrvL
static dbfAlbCliT
static dbfAlbCliL
static dbfAlbCliP
static dbfAlbPrvT
static dbfAlbPrvL
static dbfClient
static dbfCliBnc
static dbfIva
static dbfTarPreL
static dbfTarPreS
static dbfPromoT
static dbfPromoL
static dbfPromoC
static dbfAgent
static dbfArticulo
static dbfCodebar
static dbfFamilia
static dbfFPago
static dbfDiv
static dbfKit
static dbfArtDiv
static dbfRuta
static dbfTblCnv
static dbfAlm
static dbfUsr
static dbfCount
static dbfPrv
static dbfObrasT
static oBrwIva
static dbfArtPrv
static dbfInci
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
static dbfHisMov
static cOrdAnt
static oBandera
static oTrans
static oNewImp
static dbfTmpLin
static dbfTmpPedLin
static dbfTmpFin
static dbfTmpRes
static dbfTmpInc
static dbfTmpDoc
static dbfTmpPgo
static dbfTVta
static dbfPro

static dbfTblPro
static dbfDoc
static dbfAgeCom
static dbfCajT
static oStock
static cTmpLin
static cTmpRes
static cTmpInc
static cTmpDoc
static cTmpPgo
static oGetNet
static oGetTrn
static oGetIvm
static oGetPnt
static oGetIva
static oGetReq
static oGetAge
static oGetRnt
static oGetTotal
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
static oFraPub
static oTipArt
static oUndMedicion
static oTipPed

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

static aEstadoProduccion   := { "Producido", "En producci�n", "Pendiente de producci�n" }

//---------------------------------------------------------------------------//
//Comenzamos la parte de c�digo que se compila para el ejecutable normal
//---------------------------------------------------------------------------//

FUNCTION GenPedCli( nDevice, cCaption, cCodDoc, cPrinter, nCopies )

   local oInf
   local oDevice
   local nNumPed

   if ( TDataView():PedidosClientes( nView ) )->( Lastrec() ) == 0
      return nil
   end if

   nNumPed              := ( TDataView():PedidosClientes( nView ) )->cSerPed + Str( ( TDataView():PedidosClientes( nView ) )->nNumPed ) + ( TDataView():PedidosClientes( nView ) )->cSufPed

   DEFAULT nDevice      := IS_PRINTER
   DEFAULT cCaption     := "Imprimiendo pedido"
   DEFAULT cCodDoc      := cFormatoDocumento( ( TDataView():PedidosClientes( nView ) )->cSerPed, "nPedCli", dbfCount )
   DEFAULT nCopies      := if( nCopiasDocumento( ( TDataView():PedidosClientes( nView ) )->cSerPed, "nPedCli", dbfCount ) == 0, Max( Retfld( ( TDataView():PedidosClientes( nView ) )->cCodCli, TDataView():Clientes( nView ), "CopiasF" ), 1 ), nCopiasDocumento( ( TDataView():PedidosClientes( nView ) )->cSerPed, "nPedCli", dbfCount ) )

   if Empty( cCodDoc )
      cCodDoc           := cFirstDoc( "PC", dbfDoc )
   end if

   if !lExisteDocumento( cCodDoc, dbfDoc )
      return nil
   end if

   /*
   Informacion al Auditor------------------------------------------------------
   */

   if !Empty( oAuditor() )
      if nDevice == IS_PRINTER
         oAuditor():AddEvent( PRINT_PEDIDO_CLIENTES,    nNumPed, PED_CLI )
      else
         oAuditor():AddEvent( PREVIEW_PEDIDO_CLIENTES,  nNumPed, PED_CLI )
      end if
   end if

   /*
   Si el documento es de tipo visual-------------------------------------------
   */

   if lVisualDocumento( cCodDoc, dbfDoc )

      PrintReportPedCli( nDevice, nCopies, cPrinter, dbfDoc )

   else

      nTotPedCli( nNumPed, TDataView():PedidosClientes( nView ), dbfPedCliL, dbfIva, dbfDiv, dbfFPago, nil, cDivEmp() )
      nPagPedCli( nNumPed, dbfPedCliP, dbfDiv, cDivEmp() )

      ( dbfPedCliL )->( dbSeek( nNumPed ) )
      ( dbfPedCliP )->( dbSeek( nNumPed ) )
      ( TDataView():Clientes( nView )  )->( dbSeek( ( TDataView():PedidosClientes( nView ) )->CCODCLI ) )
      ( dbfAgent   )->( dbSeek( ( TDataView():PedidosClientes( nView ) )->CCODAGE ) )
      ( dbfFPago   )->( dbSeek( ( TDataView():PedidosClientes( nView ) )->CCODPGO ) )
      ( dbfObrasT  )->( dbSeek( ( TDataView():PedidosClientes( nView ) )->CCODCLI + ( TDataView():PedidosClientes( nView ) )->CCODOBR ) )

      oTrans:oDbf:Seek( ( TDataView():PedidosClientes( nView ) )->cCodTrn )

      private cDbf         := TDataView():PedidosClientes( nView )
      private cDbfCol      := dbfPedCliL
      private cDbfPag      := dbfPedCliP
      private cCliente     := TDataView():Clientes( nView )
      private cDbfCli      := TDataView():Clientes( nView )
      private cDbfObr      := dbfObrasT
      private cAgente      := dbfAgent
      private cDbfAge      := dbfAgent
      private cIva         := dbfIva
      private cDbfIva      := dbfIva
      private cFPago       := dbfFPago
      private cDbfPgo      := dbfFPago
      private cDbfObr      := dbfObrasT
      private cTarPreL     := dbfTarPreL
      private cTarPreS     := dbfTarPreS
      private cPromoL      := dbfPromoL
      private cDbfRut      := dbfRuta
      private cDbfUsr      := dbfUsr
      private cDbfTrn      := oTrans:GetAlias()
      private cDbfPro      := dbfPro
      private cDbfTblPro   := dbfTblPro

      private nTotPage     := nTotLPedCli( dbfPedCliL )
      private nVdv         := nVdvDiv
      private nVdvDivPed   := nVdvDiv
      private cPicUndPed   := cPicUnd
      private cPouDivPed   := cPouDiv
      private cPorDivPed   := cPorDiv
      private cPouChgPed   := cPouDiv( cDivChg(), dbfDiv )            // Picture del euro
      private nDouDivPed   := nDouDiv
      private nRouDivPed   := nRouDiv

      private nTotArt      := nNumArt
      private nTotCaj      := nNumCaj

      if !Empty( cPrinter )
         oDevice           := TPrinter():New( cCaption, .f., .t., cPrinter )
         REPORT oInf CAPTION cCaption TO DEVICE oDevice
      else
         REPORT oInf CAPTION cCaption PREVIEW
      end if

      if !Empty( oInf ) .and. oInf:lCreated

         oInf:lAutoland    := .f.
         oInf:lFinish      := .f.
         oInf:lNoCancel    := .t.
         oInf:bSkip        := {|| PedCliReportSkipper( dbfPedCliL ) }

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

      end if

      END REPORT

      if !Empty( oInf )

         ACTIVATE REPORT oInf ;
            WHILE       ( ( dbfPedCliL )->cSerPed + Str( ( dbfPedCliL )->nNumPed ) + ( dbfPedCliL )->cSufPed == nNumPed .and. !( dbfPedCliL )->( Eof() ) );
            FOR         ( !( dbfPedCliL )->lImpLin ) ;
            ON ENDPAGE  ( ePage( oInf, cCodDoc ) )

         if nDevice == IS_PRINTER
            oInf:oDevice:end()
         end if 

      end if

      oInf                 := nil

   end if

   lChgImpDoc( TDataView():PedidosClientes( nView ) )

RETURN NIL

//--------------------------------------------------------------------------//

Static Function PedCliReportSkipper( dbfPedCliL )

   ( dbfPedCliL )->( dbSkip() )

   nTotPage              += nTotLPedCli( dbfPedCliL )

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

      nView             := TDataView():CreateView()

      /*
    	Atipicas de clientes-----------------------------------------------------
      */

      TDataView():Atipicas( nView )

      TDataView():PedidosClientes( nView )

      TDataView():Clientes( nView )

      TDataView():GruposClientes( nView )

      TDataView():Get( "CliInc", nView )

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

      USE ( cPatEmp() + "PEDPROVT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PEDPROVT", @dbfPedPrvT ) )
      SET ADSINDEX TO ( cPatEmp() + "PEDPROVT.CDX" ) ADDITIVE

      USE ( cPatEmp() + "PEDPROVL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PEDPROVL", @dbfPedPrvL ) )
      SET ADSINDEX TO ( cPatEmp() + "PEDPROVL.CDX" ) ADDITIVE

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

      USE ( cPatDat() + "TIVA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIVA", @dbfIva ) )
      SET ADSINDEX TO ( cPatDat() + "TIVA.CDX" ) ADDITIVE
/*
      USE ( cPatCli() + "CLIENT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CLIENT", @TDataView():Clientes( nView ) ) )
      SET ADSINDEX TO ( cPatCli() + "CLIENT.CDX" ) ADDITIVE
*/
      USE ( cPatCli() + "AGENTES.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "AGENTES", @dbfAgent ) )
      SET ADSINDEX TO ( cPatCli() + "AGENTES.CDX" ) ADDITIVE

      USE ( cPatArt() + "ARTICULO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ARTICULO", @dbfArticulo ) )
      SET ADSINDEX TO ( cPatArt() + "ARTICULO.CDX" ) ADDITIVE

      USE ( cPatArt() + "ArtCodebar.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CODEBAR", @dbfCodebar ) )
      SET ADSINDEX TO ( cPatArt() + "ArtCodebar.Cdx" ) ADDITIVE

      USE ( cPatArt() + "FAMILIAS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FAMILIAS", @dbfFamilia ) )
      SET ADSINDEX TO ( cPatArt() + "FAMILIAS.CDX" ) ADDITIVE

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

      USE ( cPatGrp() + "FPAGO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FPAGO", @dbfFPago ) )
      SET ADSINDEX TO ( cPatGrp() + "FPAGO.CDX" ) ADDITIVE

      USE ( cPatDat() + "DIVISAS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "DIVISAS", @dbfDiv ) )
      SET ADSINDEX TO ( cPatDat() + "DIVISAS.CDX" ) ADDITIVE

      USE ( cPatCli() + "ObrasT.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "OBRAST", @dbfObrasT ) )
      SET ADSINDEX TO ( cPatCli() + "ObrasT.Cdx" ) ADDITIVE

      USE ( cPatDat() + "TVTA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TVTA", @dbfTVta ) )
      SET ADSINDEX TO ( cPatDat() + "TVTA.CDX" ) ADDITIVE

      USE ( cPatEmp() + "RDOCUMEN.DBF" ) NEW SHARED VIA ( cDriver() )ALIAS ( cCheckArea( "RDOCUMEN", @dbfDoc ) )
      SET ADSINDEX TO ( cPatEmp() + "RDOCUMEN.CDX" ) ADDITIVE
      SET TAG TO "CTIPO"

      USE ( cPatArt() + "OFERTA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "OFERTA", @dbfOferta ) )
      SET ADSINDEX TO ( cPatArt() + "OFERTA.CDX" ) ADDITIVE

      USE ( cPatArt() + "PRO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PRO", @dbfPro ) )
      SET ADSINDEX TO ( cPatArt() + "PRO.CDX" ) ADDITIVE

      USE ( cPatArt() + "TBLPRO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TBLPRO", @dbfTblPro ) )
      SET ADSINDEX TO ( cPatArt() + "TBLPRO.CDX" ) ADDITIVE

      USE ( cPatArt() + "ARTKIT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ARTTIK", @dbfKit ) )
      SET ADSINDEX TO ( cPatArt() + "ARTKIT.CDX" ) ADDITIVE

      USE ( cPatArt() + "ArtDiv.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ARTDIV", @dbfArtDiv ) )
      SET ADSINDEX TO ( cPatArt() + "ArtDiv.Cdx" ) ADDITIVE

      USE ( cPatCli() + "RUTA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "RUTA", @dbfRuta ) )
      SET ADSINDEX TO ( cPatCli() + "RUTA.CDX" ) ADDITIVE

      USE ( cPatDat() + "TBLCNV.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TBLCNV", @dbfTblCnv ) )
      SET ADSINDEX TO ( cPatDat() + "TBLCNV.CDX" ) ADDITIVE

      USE ( cPatDat() + "Cajas.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CAJAS", @dbfCajT ) )
      SET ADSINDEX TO ( cPatDat() + "Cajas.Cdx" ) ADDITIVE

      USE ( cPatAlm() + "Almacen.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALMACEN", @dbfAlm ) )
      SET ADSINDEX TO ( cPatAlm() + "Almacen.Cdx" ) ADDITIVE

      USE ( cPatPrv() + "PROVEE.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PROVEEDOR", @dbfPrv ) )
      SET ADSINDEX TO ( cPatPrv() + "PROVEE.CDX" ) ADDITIVE

      USE ( cPatArt() + "PROVART.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PROVART", @dbfArtPrv ) )
      SET ADSINDEX TO ( cPatArt() + "PROVART.CDX" ) ADDITIVE

      USE ( cPatDat() + "USERS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "USERS", @dbfUsr ) )
      SET ADSINDEX TO ( cPatDat() + "USERS.CDX" ) ADDITIVE

      USE ( cPatEmp() + "TIPINCI.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIPINCI", @dbfInci ) )
      SET ADSINDEX TO ( cPatEmp() + "TIPINCI.CDX" ) ADDITIVE

      USE ( cPatDat() + "DELEGA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "DELEGA", @dbfDelega ) )
      SET ADSINDEX TO ( cPatDat() + "DELEGA.CDX" ) ADDITIVE

      USE ( cPatEmp() + "NCOUNT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "NCOUNT", @dbfCount ) )
      SET ADSINDEX TO ( cPatEmp() + "NCOUNT.CDX" ) ADDITIVE

      USE ( cPatGrp() + "AGECOM.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "AGECOM", @dbfAgeCom ) )
      SET ADSINDEX TO ( cPatGrp() + "AGECOM.CDX" ) ADDITIVE

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

      USE ( cPatEmp() + "HISMOV.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "HISMOV", @dbfHisMov ) )
      SET ADSINDEX TO ( cPatEmp() + "HISMOV.CDX" ) ADDITIVE
      SET TAG TO "cRefMov"

      USE ( cPatCli() + "CliBnc.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CLIBNC", @dbfCliBnc ) )
      SET ADSINDEX TO ( cPatCli() + "CliBnc.Cdx" ) ADDITIVE

   	if !TDataCenter():OpenPreCliT( @dbfPreCliT )
		lOpenFiles     := .f.
	end if 

    if !TDataCenter():OpenAlbCliT( @dbfAlbCliT )
   		lOpenFiles     := .f.
	end if

    if !TDataCenter():OpenFacCliT( @dbfFacCliT )
       lOpenFiles     	:= .f.
    end if

	if !TDataCenter():OpenFacCliP( @dbfFacCliP )
	   lOpenFiles     	:= .f.
	end if

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

      oFraPub           := TFrasesPublicitarias():Create( cPatArt() )
      if !oFraPub:OpenFiles()
         lOpenFiles     := .f.
      end if

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

      /*
      Limitaciones de cajero y cajas--------------------------------------------------------
      */

      if lAIS() .and. !oUser():lAdministrador()
      
         cFiltroUsuario    := "Field->cSufPed == '" + oUser():cDelegacion() + "' .and. Field->cCodCaj == '" + oUser():cCaja() + "'"
         if oUser():lFiltroVentas()         
            cFiltroUsuario += " .and. Field->cCodUsr == '" + oUser():cCodigo() + "'"
         end if 

         ( TDataView():PedidosClientes( nView ) )->( AdsSetAOF( cFiltroUsuario ) )

      end if

      EnableAcceso()

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
   local oDel
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

   DEFINE SHELL oWndBrw FROM 0, 0 TO 22, 80 ;
      XBROWSE ;
      TITLE    "Pedidos de clientes" ;
      PROMPT   "N�mero",;
               "Fecha",;
               "C�digo",;
               "Nombre",;
               "Direcci�n",;
               "Agente",;
               "Entrada",;
               "Comercio electr�nico";
      MRU      "Clipboard_empty_user1_16";
      BITMAP   clrTopArchivos ;
      ALIAS    ( TDataView():PedidosClientes( nView ) );
      APPEND   ( WinAppRec( oWndBrw:oBrw, bEdtRec, TDataView():PedidosClientes( nView ), cCodCli, cCodArt, cCodPre ) ) ;
      DUPLICAT ( WinDupRec( oWndBrw:oBrw, bEdtRec, TDataView():PedidosClientes( nView ), cCodCli, cCodArt, cCodPre ) ) ;
      EDIT     ( WinEdtRec( oWndBrw:oBrw, bEdtRec, TDataView():PedidosClientes( nView ), cCodCli, cCodArt, cCodPre ) ) ;
      ZOOM     ( WinZooRec( oWndBrw:oBrw, bEdtRec, TDataView():PedidosClientes( nView ) ) ) ;
      DELETE   ( WinDelRec( oWndBrw:oBrw, TDataView():PedidosClientes( nView ), {|| QuiPedCli() } ) ) ;
      LEVEL    nLevel ;
      OF       oWnd

	  oWndBrw:lFechado     := .t.

	  oWndBrw:SetYearComboBoxChange( {|| YearComboBoxChange() } )

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Sesi�n cerrada"
         :nHeadBmpNo       := 3
         :bStrData         := {|| "" }
         :bEditValue       := {|| ( TDataView():PedidosClientes( nView ) )->lCloPed }
         :nWidth           := 20
         :SetCheck( { "Sel16", "Nil16" } )
         :AddResource( "Zoom16" )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Estado"
         :nHeadBmpNo       := 4
         :bStrData         := {|| "" }
         :bBmpData         := {|| ( TDataView():PedidosClientes( nView ) )->nEstado }
         :nWidth           := 20
         :AddResource( "Bullet_Square_Red_16" )
         :AddResource( "Bullet_Square_Yellow_16" )
         :AddResource( "Bullet_Square_Green_16" )
         :AddResource( "Trafficlight_on_16" )
      end with

     with object ( oWndBrw:AddXCol() )
         :cHeader          := "Envio"
         :nHeadBmpNo       := 3
         :bStrData         := {|| "" }
         :bEditValue       := {|| ( TDataView():PedidosClientes( nView ) )->lSndDoc }
         :nWidth           := 20
         :SetCheck( { "Sel16", "Nil16" } )
         :AddResource( "Lbl16" )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Incidencia"
         :nHeadBmpNo       := 4
         :bStrData         := {|| "" }
         :bBmpData         := {|| nEstadoIncidencia( ( TDataView():PedidosClientes( nView ) )->cSerPed + Str( ( TDataView():PedidosClientes( nView ) )->nNumPed ) + ( TDataView():PedidosClientes( nView ) )->cSufPed ) }
         :nWidth           := 20
         :lHide            := .t.
         :AddResource( "Bullet_Square_Red_16" )
         :AddResource( "Bullet_Square_Yellow_16" )
         :AddResource( "Bullet_Square_Green_16" )
         :AddResource( "informacion_16" )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Producci�n"
         :nHeadBmpNo       := 4
         :bStrData         := {|| cEstadoProduccion( ( TDataView():PedidosClientes( nView ) )->cSerPed + Str( ( TDataView():PedidosClientes( nView ) )->nNumPed ) + ( TDataView():PedidosClientes( nView ) )->cSufPed ) }
         :bBmpData         := {|| nEstadoProduccion( ( TDataView():PedidosClientes( nView ) )->cSerPed + Str( ( TDataView():PedidosClientes( nView ) )->nNumPed ) + ( TDataView():PedidosClientes( nView ) )->cSufPed ) }
         :nWidth           := 20
         :lHide            := .t.
         :AddResource( "Bullet_Square_Green_16" )
         :AddResource( "Bullet_Square_Yellow_16" )
         :AddResource( "Bullet_Square_Red_16" )
         :AddResource( "Worker2_16" )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Impreso"
         :nHeadBmpNo       := 3
         :bStrData         := {|| "" }
         :bEditValue       := {|| ( TDataView():PedidosClientes( nView ) )->lImprimido }
         :nWidth           := 20
         :lHide            := .t.
         :SetCheck( { "Sel16", "Nil16" } )
         :AddResource( "Imp16" )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Comercio electr�nico"
         :cSortOrder       := "lInternet"
         :nHeadBmpNo       := 3
         :bStrData         := {|| "" }
         :bEditValue       := {|| ( TDataView():PedidosClientes( nView ) )->lInternet }
         :nWidth           := 20
         :lHide            := .t.
         :SetCheck( { "Sel16", "Nil16" } )
         :AddResource( "SndInt16" )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Listo para entregar"
         :nHeadBmpNo       := 3
         :bStrData         := {|| "" }
         :bEditValue       := {|| ( TDataView():PedidosClientes( nView ) )->lPdtCrg }
         :nWidth           := 20
         :lHide            := .t.
         :SetCheck( { "Sel16", "Nil16" } )
         :AddResource( "clipboard_ok_16" )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Generado"
         :bEditValue       := {|| aEstGen[ Max( Min( ( TDataView():PedidosClientes( nView ) )->nGenerado, len( aEstGen ) ), 1 ) ] }
         :nWidth           := 60
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Recibido"
         :bEditValue       := {|| aEstGen[ Max( Min( ( TDataView():PedidosClientes( nView ) )->nRecibido, len( aEstGen ) ), 1 ) ] }
         :nWidth           := 60
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Entrega"
         :cSortOrder       := "dFecEnt"
         :bEditValue       := {|| Dtoc( ( TDataView():PedidosClientes( nView ) )->dFecEnt ) }
         :nWidth           := 80
         :lHide            := .t.
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Tipo"
         :bEditValue       := {|| aTipPed[ if( ( TDataView():PedidosClientes( nView ) )->lAlquiler, 2, 1 ) ] }
         :nWidth           := 50
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "N�mero"
         :cSortOrder       := "nNumPed"
         :bEditValue       := {|| ( TDataView():PedidosClientes( nView ) )->cSerPed + "/" + AllTrim( Str( ( TDataView():PedidosClientes( nView ) )->nNumPed ) ) }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Delegaci�n"
         :bEditValue       := {|| ( TDataView():PedidosClientes( nView ) )->cSufPed }
         :nWidth           := 40
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Sesi�n"
         :bEditValue       := {|| Trans( ( TDataView():PedidosClientes( nView ) )->cTurPed, "######" ) }
         :nWidth           := 40
         :lHide            := .t.
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Fecha"
         :cSortOrder       := "dFecPed"
         :bEditValue       := {|| Dtoc( ( TDataView():PedidosClientes( nView ) )->dFecPed ) }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Caja"
         :bEditValue       := {|| ( TDataView():PedidosClientes( nView ) )->cCodCaj }
         :nWidth           := 40
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Usuario"
         :bEditValue       := {|| ( TDataView():PedidosClientes( nView ) )->cCodUsr }
         :nWidth           := 40
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Situaci�n"
         :bEditValue       := {|| AllTrim( ( TDataView():PedidosClientes( nView ) )->cSituac ) }
         :nWidth           := 80
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "C�digo"
         :cSortOrder       := "cCodCli"
         :bEditValue       := {|| AllTrim( ( TDataView():PedidosClientes( nView ) )->cCodCli ) }
         :nWidth           := 70
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Nombre"
         :cSortOrder       := "cNomCli"
         :bEditValue       := {|| ( TDataView():PedidosClientes( nView ) )->cNomCli }
         :nWidth           := 180
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Agente"
         :cSortOrder       := "cCodAge"
         :bEditValue       := {|| ( TDataView():PedidosClientes( nView ) )->cCodAge }
         :nWidth           := 50
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Ruta"
         :bEditValue       := {|| ( TDataView():PedidosClientes( nView ) )->cCodRut }
         :nWidth           := 40
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Forma pago"
         :bEditValue       := {|| if( !Empty( ( TDataView():PedidosClientes( nView ) )->cCodPgo ), ( TDataView():PedidosClientes( nView ) )->cCodPgo + " - " + AllTrim( RetFld( ( TDataView():PedidosClientes( nView ) )->cCodPgo, dbfFPago, "cDesPago" ) ), "" ) }
         :nWidth           := 200
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Almac�n"
         :bEditValue       := {|| ( TDataView():PedidosClientes( nView ) )->cCodAlm }
         :nWidth           := 60
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Direcci�n"
         :cSortOrder       := "cCodObr"
         :bEditValue       := {|| ( TDataView():PedidosClientes( nView ) )->cCodObr }
         :nWidth           := 50
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Entregado " + cDivEmp()
         :bEditValue       := {|| nPagPedCli( ( TDataView():PedidosClientes( nView ) )->cSerPed + Str( ( TDataView():PedidosClientes( nView ) )->nNumPed ) + ( TDataView():PedidosClientes( nView ) )->cSufPed, dbfPedCliP, dbfDiv, if( lEuro, cDivChg(), cDivEmp() ), .t. ) }
         :nWidth           := 100
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Base"
         :bEditValue       := {|| ( TDataView():PedidosClientes( nView ) )->nTotNet }
         :cEditPicture     := cPorDiv( ( TDataView():PedidosClientes( nView ) )->cDivPed, dbfDiv )
         :nWidth           := 80
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := cImp()
         :bEditValue       := {|| ( TDataView():PedidosClientes( nView ) )->nTotIva }
         :cEditPicture     := cPorDiv( ( TDataView():PedidosClientes( nView ) )->cDivPed, dbfDiv )
         :nWidth           := 80
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "R.E."
         :bEditValue       := {|| ( TDataView():PedidosClientes( nView ) )->nTotReq }
         :cEditPicture     := cPorDiv( ( TDataView():PedidosClientes( nView ) )->cDivPed, dbfDiv )
         :nWidth           := 80
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Total"
         :bEditValue       := {|| ( TDataView():PedidosClientes( nView ) )->nTotPed }
         :cEditPicture     := cPorDiv( ( TDataView():PedidosClientes( nView ) )->cDivPed, dbfDiv )
         :nWidth           := 80
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Div."
         :bEditValue       := {|| cSimDiv( if( lEuro, cDivChg(), ( TDataView():PedidosClientes( nView ) )->cDivPed ), dbfDiv ) }
         :nWidth           := 30
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Pendiente"
         :bEditValue       := {|| ( nTotPedCli( ( TDataView():PedidosClientes( nView ) )->cSerPed + Str( ( TDataView():PedidosClientes( nView ) )->nNumPed ) + ( TDataView():PedidosClientes( nView ) )->cSufPed, TDataView():PedidosClientes( nView ), dbfPedCliL, dbfIva, dbfDiv, dbfFPago, nil, nil, .f. ) - nPagPedCli( ( TDataView():PedidosClientes( nView ) )->cSerPed + Str( ( TDataView():PedidosClientes( nView ) )->nNumPed ) + ( TDataView():PedidosClientes( nView ) )->cSufPed, dbfPedCliP, dbfDiv, nil, .f. ) ) }
         :nWidth           := 100
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
         :cEditPicture     := cPorDiv
         :lHide            := .t. 
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Comisi�n agente"
         :bEditValue       := {|| sTotPedCli( ( TDataView():PedidosClientes( nView ) )->cSerPed + Str( ( TDataView():PedidosClientes( nView ) )->nNumPed ) + ( TDataView():PedidosClientes( nView ) )->cSufPed, TDataView():PedidosClientes( nView ), dbfPedCliL, dbfIva, dbfDiv ):nTotalAgente }
         :nWidth           := 100
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
         :cEditPicture     := cPorDiv
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Transportista"
         :bEditValue       := {|| if( Empty( ( TDataView():PedidosClientes( nView ) )->cCodTrn ), "", ( TDataView():PedidosClientes( nView ) )->cCodTrn + " - " + AllTrim( RetFld( ( TDataView():PedidosClientes( nView ) )->cCodTrn, oTrans:GetAlias(), "cNomTrn" ) ) ) }
         :nWidth           := 200
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Horas montaje"
         :bEditValue       := {|| ( TDataView():PedidosClientes( nView ) )->nMontaje }
         :nWidth           := 70
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
         :cEditPicture     := "@E 999.99"
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Su Pedido"
         :bEditValue       := {|| ( TDataView():PedidosClientes( nView ) )->cSuPed }
         :nWidth           := 100
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Condici�n"
         :bEditValue       := {|| AllTrim( ( TDataView():PedidosClientes( nView ) )->cCondEnt ) }
         :nWidth           := 200
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
      TOOLTIP  "(A)�adir";
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

   DEFINE BTNSHELL oDel RESOURCE "DEL" OF oWndBrw ;
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

   DEFINE BTNSHELL RESOURCE "SERIE1" OF oWndBrw ;
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

   DEFINE BTNSHELL oMail RESOURCE "Mail" OF oWndBrw ;
      NOBORDER ;
      MENU     This:Toggle() ;
      ACTION   ( GenPedCli( IS_MAIL ) ) ;
      TOOLTIP  "Correo electr�nico";
      LEVEL    ACC_IMPR

      lGenPedCli( oWndBrw:oBrw, oMail, IS_MAIL ) ;

   DEFINE BTNSHELL RESOURCE "Money2_" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( WinAppRec( oWndBrw:oBrw, bEdtPgo, dbfPedCliP ) ) ;
      TOOLTIP  "Entregas a (c)uenta" ;
      HOTKEY   "C";
      LEVEL    ACC_APPD

   if oUser():lAdministrador()

      DEFINE BTNSHELL RESOURCE "CHGSTATE" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( ChgSta( oWndBrw:oBrw ) ) ;
         TOOLTIP  "Cambiar es(t)ado" ;
         HOTKEY   "T";
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
      ACTION   lSnd( oWndBrw, TDataView():PedidosClientes( nView ) ) ;
      HOTKEY   "V";
      LEVEL    ACC_EDIT

      DEFINE BTNSHELL RESOURCE "LBL" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( lSelectAll( oWndBrw, TDataView():PedidosClientes( nView ), "lSndDoc", .t., .t., .t. ) );
         TOOLTIP  "Todos" ;
         FROM     oSnd ;
         CLOSED ;
         LEVEL    ACC_EDIT

      DEFINE BTNSHELL RESOURCE "LBL" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( lSelectAll( oWndBrw, TDataView():PedidosClientes( nView ), "lSndDoc", .f., .t., .t. ) );
         TOOLTIP  "Ninguno" ;
         FROM     oSnd ;
         CLOSED ;
         LEVEL    ACC_EDIT

      DEFINE BTNSHELL RESOURCE "LBL" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( lSelectAll( oWndBrw, TDataView():PedidosClientes( nView ), "lSndDoc", .t., .f., .t. ) );
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
         ACTION   ( ReplaceCreator( oWndBrw, TDataView():PedidosClientes( nView ), aItmPedCli() ) ) ;
         TOOLTIP  "Cambiar campos" ;
         LEVEL    ACC_EDIT

         DEFINE BTNSHELL RESOURCE "BMPCHG" OF oWndBrw ;
            NOBORDER ;
         	ACTION   ( ReplaceCreator( oWndBrw, dbfPedCliL, aColPedCli() ) ) ;
            TOOLTIP  "Lineas" ;
            FROM     oRpl ;
            CLOSED ;
            LEVEL    ACC_EDIT

   end if

   DEFINE BTNSHELL RESOURCE "SHOPPINGCART" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( TPedidosClientes2PedidosProveedor():New( ( TDataView():PedidosClientes( nView ) )->cSerPed, ( TDataView():PedidosClientes( nView ) )->nNumPed, ( TDataView():PedidosClientes( nView ) )->cSufPed, oStock ):Dialog() ) ;
      TOOLTIP  "(G)enerar pedido a proveedores" ;
      HOTKEY   "G";

   DEFINE BTNSHELL RESOURCE "INFO" GROUP OF oWndBrw ;
      NOBORDER ;
      ACTION   ( TTrazaDocumento():Activate( PED_CLI, ( TDataView():PedidosClientes( nView ) )->cSerPed + Str( ( TDataView():PedidosClientes( nView ) )->nNumPed ) + ( TDataView():PedidosClientes( nView ) )->cSufPed ) ) ;
      TOOLTIP  "I(n)forme documento" ;
      HOTKEY   "N" ;
      LEVEL    ACC_EDIT

   DEFINE BTNSHELL oScript RESOURCE "Folder_document_" GROUP OF oWndBrw ;
      NOBORDER ;
      ACTION   ( oScript:Expand() ) ;
      TOOLTIP  "Scripts" ;

      ImportScript( oWndBrw, oScript, "PedidosClientes" )  

   DEFINE BTNSHELL oRotor RESOURCE "ROTOR" GROUP OF oWndBrw ;
         ACTION   ( oRotor:Expand() ) ;
         TOOLTIP  "Rotor" ;

      DEFINE BTNSHELL RESOURCE "USER1_" OF oWndBrw ;
            ACTION   ( EdtCli( ( TDataView():PedidosClientes( nView ) )->cCodCli ) );
            TOOLTIP  "Modificar cliente" ;
            FROM     oRotor ;

      DEFINE BTNSHELL RESOURCE "INFO" OF oWndBrw ;
            ACTION   ( InfCliente( ( TDataView():PedidosClientes( nView ) )->cCodCli ) );
            TOOLTIP  "Informe de cliente" ;
            FROM     oRotor ;

      DEFINE BTNSHELL RESOURCE "Worker" OF oWndBrw ;
            ACTION   ( EdtObras( ( TDataView():PedidosClientes( nView ) )->cCodCli, ( TDataView():PedidosClientes( nView ) )->cCodObr, dbfObrasT ) );
            TOOLTIP  "Modificar direcci�n" ;
            FROM     oRotor ;

      DEFINE BTNSHELL RESOURCE "NOTEBOOK_USER1_" OF oWndBrw ;
            ACTION   ( if( !Empty( ( TDataView():PedidosClientes( nView ) )->cNumPre ), ZooPreCli( ( TDataView():PedidosClientes( nView ) )->cNumPre ), MsgStop( "El pedido no proviene de presupuesto" ) ) );
            TOOLTIP  "Visualizar presupuesto" ;
            FROM     oRotor ;

      DEFINE BTNSHELL RESOURCE "DOCUMENT_PLAIN_USER1_" OF oWndBrw ;
            ALLOW    EXIT ;
            ACTION   ( if( ( TDataView():PedidosClientes( nView ) )->nEstado != 3, AlbCli( nil, nil, { "Pedido" => ( TDataView():PedidosClientes( nView ) )->cSerPed + Str( ( TDataView():PedidosClientes( nView ) )->nNumPed ) + ( TDataView():PedidosClientes( nView ) )->cSufPed } ), MsgInfo( "Pedido entregado o cancelado" ) ) );
            TOOLTIP  "Generar albar�n" ;
            FROM     oRotor ;

      DEFINE BTNSHELL RESOURCE "DOCUMENT_PLAIN_USER1_" OF oWndBrw ;
            NOBORDER ;
            ACTION   ( Ped2AlbCli( ( TDataView():PedidosClientes( nView ) )->cSerPed + Str( ( TDataView():PedidosClientes( nView ) )->nNumPed ) + ( TDataView():PedidosClientes( nView ) )->cSufPed, dbfAlbCliT ) );
            TOOLTIP  "Modificar albar�n" ;
            FROM     oRotor ;
            CLOSED ;

      DEFINE BTNSHELL RESOURCE "DOCUMENT_USER1_" OF oWndBrw ;
            ALLOW    EXIT ;
            ACTION   ( if( ( TDataView():PedidosClientes( nView ) )->nEstado <= 2, FactCli( nil, nil, { "Pedido" => ( TDataView():PedidosClientes( nView ) )->cSerPed + Str( ( TDataView():PedidosClientes( nView ) )->nNumPed ) + ( TDataView():PedidosClientes( nView ) )->cSufPed } ), MsgInfo( "Pedido entregado o cancelado" ) ) );
            TOOLTIP  "Generar factura" ;
            FROM     oRotor ;

      DEFINE BTNSHELL RESOURCE "DOCUMENT_USER1_" OF oWndBrw ;
            ACTION   ( Ped2FacCli( ( TDataView():PedidosClientes( nView ) )->cSerPed + Str( ( TDataView():PedidosClientes( nView ) )->nNumPed ) + ( TDataView():PedidosClientes( nView ) )->cSufPed, dbfFacCliT ) );
            TOOLTIP  "Modificar factura" ;
            FROM     oRotor ;

      DEFINE BTNSHELL RESOURCE "DOCUMENT_MONEY2_" OF oWndBrw ;
            ALLOW    EXIT ;
            ACTION   ( FacAntCli( , , ( TDataView():PedidosClientes( nView ) )->cCodCli ) );
            TOOLTIP  "Generar anticipo" ;
            FROM     oRotor ;

      DEFINE BTNSHELL RESOURCE "Note_" OF oWndBrw ;
            ALLOW    EXIT ;
            ACTION   ( PedCliNotas() );
            TOOLTIP  "Generar nota de agenda" ;
            FROM     oRotor ;

      DEFINE BTNSHELL RESOURCE "CASHIER_USER1_" OF oWndBrw ;
            ALLOW    EXIT ;
            ACTION   ( if( ( TDataView():PedidosClientes( nView ) )->nEstado <=1 .and. Empty( ( TDataView():PedidosClientes( nView ) )->cNumTik ), FrontTpv( nil, nil, nil, nil, .f., .f., { nil, ( TDataView():PedidosClientes( nView ) )->cSerPed + Str( ( TDataView():PedidosClientes( nView ) )->nNumPed ) + ( TDataView():PedidosClientes( nView ) )->cSufPed, nil } ), MsgStop( "Pedido albaranado, cancelado o convertido a ticket" ) ) );
            TOOLTIP  "Convertir a ticket" ;
            FROM     oRotor ;

   DEFINE BTNSHELL RESOURCE "END" GROUP OF oWndBrw ;
      ALLOW    EXIT ;
      ACTION   ( oWndBrw:End() ) ;
      TOOLTIP  "(S)alir";
      HOTKEY   "S"

   if !oUser():lFiltroVentas()
      oWndBrw:oActiveFilter:SetFields( aItmPedCli() )
      oWndBrw:oActiveFilter:SetFilterType( PED_CLI )
   end if

   if lPedWeb
      ( TDataView():PedidosClientes( nView ) )->( OrdSetFocus( "lInternet" ) )
      ( TDataView():PedidosClientes( nView ) )->( dbGoTop() )
   end if

   ACTIVATE SHELL oWndBrw VALID ( CloseFiles() )

   EnableAcceso()

   if !Empty( cCodCli ) .or. !Empty( cCodArt ) .or. !Empty( cCodPre )

      if !Empty( oWndBrw )
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
   local oSayDias
   local oSayTxtDias
   local cSerie         := cNewSer( "nPedCli", dbfCount )
   local oBmpGeneral

   lWhen                := if( oUser():lAdministrador(), ( nMode != ZOOM_MODE ), if( nMode == EDIT_MODE, !aTmp[ _LCLOPED ], ( nMode != ZOOM_MODE ) ) )

   /*
   Este valor los guaradamos para detectar los posibles cambios
   */

   cOldCodCli           := aTmp[ _CCODCLI ]

   do case
      case nMode == APPD_MODE

         if !lCurSesion()
            MsgStop( "No hay sesiones activas, imposible a�adir documentos" )
            Return .f.
         end if

         if !lCajaOpen( oUser():cCaja() ) .and. !oUser():lAdministrador()
            msgStop( "Esta caja " + oUser():cCaja() + " esta cerrada." )
            Return .f.
         end if

         aTmp[ _CTURPED ]     := cCurSesion()
         aTmp[ _CCODALM ]     := oUser():cAlmacen()
         aTmp[ _CCODCAJ ]     := oUser():cCaja()
         aTmp[ _CDIVPED ]     := cDivEmp()
         aTmp[ _CCODPGO ]     := cDefFpg()
         aTmp[ _NVDVPED ]     := nChgDiv( aTmp[ _CDIVPED ], dbfDiv )
         aTmp[ _CSUFPED ]     := RetSufEmp()
         aTmp[ _NESTADO ]     := 1
         aTmp[ _CCODUSR ]     := cCurUsr()
         aTmp[ _CCODDLG ]     := oUser():cDelegacion()
         aTmp[ _LIVAINC ]     := uFieldEmpresa( "lIvaInc" )
         aTmp[ _CMANOBR ]     := Padr( "Gastos", 250 )
         aTmp[ _NIVAMAN ]     := nIva( dbfIva, cDefIva() )

         if !Empty( cCodPre )
            aTmp[ _CNUMPRE ]  := cCodPre
         end if

      case nMode == DUPL_MODE

         if !lCurSesion()
            MsgStop( "No hay sesiones activas, imposible a�adir documentos" )
            Return .f.
         end if

         if !lCajaOpen( oUser():cCaja() ) .and. !oUser():lAdministrador()
           msgStop( "Esta caja " + oUser():cCaja() + " esta cerrada." )
            Return .f.
         end if

         aTmp[ _DFECPED ]  := GetSysDate()
         aTmp[ _CTURPED ]  := cCurSesion()
         aTmp[ _NESTADO ]  := 1
         aTmp[ _LCLOPED ]  := .f.

      case nMode == EDIT_MODE

         if aTmp[ _LCLOPED ] .and. !oUser():lAdministrador()
            MsgStop( "El pedido est� cerrado." )
            Return .f.
         end if

         if aTmp[ _NESTADO ] == 3 .and. !aTmp[ _LCANCEL ]
            MsgStop( "El pedido ya fue entregado." )
            Return .f.
         end if

   end case

   if Empty( Rtrim( aTmp[ _CSERPED ] ) )
      aTmp[ _CSERPED ]     := cSerie
   end if

   if Empty( aTmp[ _NTARIFA ] )
      aTmp[ _NTARIFA ]     := Max( uFieldEmpresa( "nPreVta" ), 1 )
   end if

   if Empty( aTmp[ _CDTOESP ] )
      aTmp[ _CDTOESP ]     := Padr( "General", 50 )
   end if

   if Empty( aTmp[ _CDPP ] )
      aTmp[ _CDPP ]        := Padr( "Pronto pago", 50 )
   end if

   /*
   tipo de presupuesto
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
      aTmp[ _CTLFCLI ] := RetFld( aTmp[ _CCODCLI ], TDataView():Clientes( nView ), "Telefono" )
   end if

   nRieCli              := oStock:nRiesgo( aTmp[ _CCODCLI ] )

   /*
   Necestamos el orden el la primera clave-------------------------------------
   */

   nOrd                 := ( TDataView():PedidosClientes( nView ) )->( ordSetFocus( 1 ) )

   cPouDiv              := cPouDiv( aTmp[ _CDIVPED ], dbfDiv ) // Picture de la divisa
   cPorDiv              := cPorDiv( aTmp[ _CDIVPED ], dbfDiv ) // Picture de la divisa
   nDouDiv              := nDouDiv( aTmp[ _CDIVPED ], dbfDiv )
   nRouDiv              := nRouDiv( aTmp[ _CDIVPED ], dbfDiv )
   cPpvDiv              := cPpvDiv( aTmp[ _CDIVPED ], dbfDiv ) // Picture del punto verde
   nDpvDiv              := nDpvDiv( aTmp[ _CDIVPED ], dbfDiv ) // Decimales de redondeo del punto verde
   cPicEur              := cPouDiv( "EUR", dbfDiv )            // Picture del euro
   cPicUnd              := MasUnd()

   DO CASE
      CASE  aTmp[ _NESTADO ] == 1
         cEstPed        := "Pendiente"
      CASE  aTmp[ _NESTADO ] == 2
         cEstPed        := "Parcial"
      CASE  aTmp[ _NESTADO ] == 3
         cEstPed        := "Entregado"
   END CASE

   /*
   Etiquetas-------------------------------------------------------------------
   */

   cSay[ 2 ]        := RetFld( aTmp[ _CCODTAR ], dbfTarPreS )
   cSay[ 3 ]        := RetFld( aTmp[ _CCODCLI ] + aTmp[ _CCODOBR ], dbfObrasT, "cNomObr" )
   cSay[ 4 ]        := RetFld( aTmp[ _CCODALM ], dbfAlm )
   cSay[ 5 ]        := RetFld( aTmp[ _CCODPGO ], dbfFPago )
   cSay[ 6 ]        := RetFld( aTmp[ _CCODAGE ], dbfAgent )
   cSay[ 7 ]        := RetFld( aTmp[ _CCODRUT ], dbfRuta )
   cSay[ 8 ]        := oTrans:cNombre( aTmp[ _CCODTRN ] )
   cSay[ 9 ]        := RetFld( aTmp[ _CCODCAJ ], dbfCajT )
   cSay[10 ]        := RetFld( aTmp[ _CCODUSR ], dbfUsr, "cNbrUse" )
   cSay[11 ]        := RetFld( cCodEmp() + aTmp[ _CCODDLG ], dbfDelega, "cNomDlg" )

   /*
   Inicializamos el valor de la tarifa por si cambian--------------------------
   */

   InitTarifaCabecera( aTmp[ _NTARIFA ] )

   /*
   Comienza el dialogo---------------------------------------------------------
   */

   DEFINE DIALOG oDlg RESOURCE "PEDCLI" TITLE LblTitle( nMode ) + "pedidos de clientes"

      REDEFINE FOLDER oFld ID 200 OF oDlg ;
         PROMPT   "&Pedido",  "Da&tos",   "&Incidencias", "D&ocumentos";
         DIALOGS  "PEDCLI_1", "PEDCLI_2", "PEDCLI_3",     "PEDCLI_4"

      /*
		Cliente_________________________________________________________________
		*/

      REDEFINE BITMAP oBmpGeneral ;
        ID       990 ;
        RESOURCE "pedidos_clientes_48_alpha" ;
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
         BITMAP   "Environnment_View_16" ;
         ON HELP  GoogleMaps( aTmp[ _CDIRCLI ], Rtrim( aTmp[ _CPOBCLI ] ) + Space( 1 ) + Rtrim( aTmp[ _CPRVCLI ] ) ) ;
         WHEN     ( lWhen .and. ( !aTmp[ _LMODCLI ] .or. oUser():lAdministrador() ) ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CPOBCLI ] VAR aTmp[ _CPOBCLI ] ;
         ID       103 ;
         WHEN     ( lWhen .and. ( !aTmp[ _LMODCLI ] .or. oUser():lAdministrador() ) ) ;
         OF       oFld:aDialogs[1]

		REDEFINE GET aGet[_CPRVCLI] VAR aTmp[_CPRVCLI] ;
         ID       104 ;
         WHEN     ( lWhen .and. ( !aTmp[ _LMODCLI ] .or. oUser():lAdministrador() ) ) ;
         OF       oFld:aDialogs[1]

		REDEFINE GET aGet[_CPOSCLI] VAR aTmp[_CPOSCLI] ;
         ID       107 ;
         WHEN     ( lWhen .and. ( !aTmp[ _LMODCLI ] .or. oUser():lAdministrador() ) ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _NTARIFA ] VAR aTmp[ _NTARIFA ] ;
			ID 		132 ;
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
         VALID    ( cObras( aGet[ _CCODOBR ], oSay[ 3 ], aTmp[ _CCODCLI ], dbfObrasT ) ) ;
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
         VALID    ( cAgentes( aGet[ _CCODAGE ], dbfAgent, oSay[ 6 ], aGet[ _NPCTCOMAGE ], dbfAgeCom ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwAgentes( aGet[ _CCODAGE ], oSay[ 6 ] ) ) ;
			OF 		oFld:aDialogs[1]

      REDEFINE GET oSay[ 6 ] VAR cSay[ 6 ] ;
			ID 		181 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         BITMAP   "Bot" ;
         ON HELP  ( ExpAgente( aTmp[ _CCODAGE ], aTmp[ _NPCTCOMAGE ], dbfTmpLin, oBrwLin ), RecalculaTotal( aTmp ) ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _NPCTCOMAGE ] VAR aTmp[ _NPCTCOMAGE ] ;
         WHEN     ( !Empty( aTmp[ _CCODAGE] ) .AND. lWhen ) ;
         VALID    ( RecalculaTotal( aTmp ) ) ;
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
         VALID    (  cDivOut( aGet[ _CDIVPED ], oBmpDiv, aGet[ _NVDVPED ], @cPouDiv, @nDouDiv, @cPorDiv, @nRouDiv, @cPpvDiv, @nDpvDiv, oGetMasDiv, dbfDiv, oBandera ) );
			PICTURE	"@!";
			ID 		200 ;
			COLOR 	CLR_GET ;
         BITMAP   "LUPA" ;
         ON HELP  BrwDiv( aGet[ _CDIVPED ], oBmpDiv, aGet[ _NVDVPED ], dbfDiv, oBandera ) ;
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
      oBrwLin:lFooter 		  := .t.
      oBrwLin:cName           := "Pedido a cliente.Detalle"

      oBrwLin:CreateFromResource( 210 )

      with object ( oBrwLin:AddCol() )
         :cHeader             := "Oferta"
         :bStrData            := {|| "" }
         :bEditValue          := {|| ( dbfTmpLin )->lLinOfe }
         :nWidth              := 50
         :SetCheck( { "Star_Red_16", "Nil16" } )
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader             := "Re. Recibido"
         :bStrData            := {|| "" }
         :bBmpData            := {|| if( nTotNPedCli( dbfTmpLin ) == 0, 3, nEstadoRecPedCli( dbfPedPrvL, dbfAlbPrvL, dbfTmpLin ) ) }
         :nWidth              := 20
         :AddResource( "Bullet_Square_Red_16" )
         :AddResource( "Bullet_Square_Yellow_16" )
         :AddResource( "Bullet_Square_Green_16" )
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader             := "Pr. Estado producci�n"
         :bStrData            := {|| "" }
         :bBmpData            := {|| Min( Max( ( dbfTmpLin )->nProduc + 1, 1 ), 3 ) }
         :nWidth              := 20
         :AddResource( "Bullet_Square_Green_16" )
         :AddResource( "Bullet_Square_Yellow_16" )
         :AddResource( "Bullet_Square_Red_16" )
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader             := "N�mero"
         :bEditValue          := {|| ( dbfTmpLin )->nNumLin }
         :cEditPicture        := "9999"
         :nWidth              := 54
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader             := "C�digo"
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
         :cHeader             := "Descripci�n"
         :bEditValue          := {|| if( Empty( ( dbfTmpLin )->cRef ), ( dbfTmpLin )->mLngDes, ( dbfTmpLin )->cDetalle ) }
         :nWidth              := 250
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader             := "�ltima venta"
         :bEditValue          := {|| Dtoc( ( dbfTmpLin )->dFecUltCom ) }
         :nWidth              := 80
         :lHide               := .t.
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader             := "�ltima unidades"
         :bEditValue          := {|| ( dbfTmpLin )->nUniUltCom }
         :cEditPicture        := MasUnd()
         :nWidth              := 60
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
         :lHide               := .t.
         :nFooterType         := AGGR_SUM
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
         :bEditValue          := {|| ( dbfTmpLin )->nUniCaja }
         :cEditPicture        := cPicUnd
         :nWidth              := 60
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
         :lHide               := .t.
         :nEditType     	  := 1
         :bOnPostEdit   	  := {|o,x,n| ChangeUnidades( o, x, n, aTmp, dbfTmpLin ) }
         :nFooterType         := AGGR_SUM
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
         :AddResource( "Navigate_Plus_16" )
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
         :AddResource( "Navigate_Minus_16" )
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
         :cHeader             := "Unidad de medici�n"
         :bEditValue          := {|| ( dbfTmpLin )->cUnidad }
         :nWidth              := 24
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader             := "Alm."
         :bEditValue          := {|| ( dbfTmpLin )->cAlmLin }
         :nWidth              := 30
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader             := "Entregado"
         :bEditValue          := {|| nUnidadesRecibidasAlbCli( ( dbfTmpLin )->cSerPed + Str( ( dbfTmpLin )->nNumPed ) + ( dbfTmpLin )->cSufPed, ( dbfTmpLin )->cRef, ( dbfTmpLin )->cCodPr1, ( dbfTmpLin )->cCodPr2, ( dbfTmpLin )->cRefPrv, ( dbfTmpLin )->cDetalle, dbfAlbCliL ) }
         :cEditPicture        := cPicUnd
         :nWidth              := 60
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
         :lHide               := .t.
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader             := "Precio"
         :bEditValue          := {|| nTotUPedCli( dbfTmpLin, nDouDiv ) }
         :cEditPicture        := cPouDiv
         :nWidth              := 70
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
         :nEditType     	  := 1
         :bOnPostEdit   	  := {|o,x,n| ChangePrecio( o, x, n, aTmp, dbfTmpLin ) }
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
         :nWidth           := 108
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      with object ( oBrwIva:AddCol() )
         :cHeader          := "%" + cImp()
         :bStrData         := {|| if( !IsNil( aTotIva[ oBrwIva:nArrayAt, 3 ] ), aTotIva[ oBrwIva:nArrayAt, 3 ], "" ) }
         :bEditValue       := {|| aTotIva[ oBrwIva:nArrayAt, 3 ] }
         :nWidth           := 60
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
         :nWidth           := 66
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      with object ( oBrwIva:AddCol() )
         :cHeader          := "% R.E."
         :bStrData         := {|| if( aTotIva[ oBrwIva:nArrayAt, 3 ] != nil .and. aTmp[ _LRECARGO ], Trans( aTotIva[ oBrwIva:nArrayAt, 4 ], "@E 99.9"), "" ) }
         :nWidth           := 60
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      with object ( oBrwIva:AddCol() )
         :cHeader          := "R.E."
         :bStrData         := {|| if( aTotIva[ oBrwIva:nArrayAt, 3 ] != nil .and. aTmp[ _LRECARGO ], Trans( aTotIva[ oBrwIva:nArrayAt, 9 ], cPorDiv ), "" ) }
         :nWidth           := 60
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
         VALID    ( lTiva( dbfIva, aTmp[ _NIVAMAN ] ) );
         ON CHANGE( nTotPedCli( nil, TDataView():PedidosClientes( nView ), dbfTmpLin, dbfIva, dbfDiv, dbfFPago, aTmp ) );
         BITMAP   "LUPA" ;
         ON HELP  ( BrwIva( aGet[ _NIVAMAN ], dbfIva, , .t. ) );
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _NMANOBR ] VAR aTmp[ _NMANOBR ] ;
         ID       400 ;
         PICTURE  cPorDiv ;
         WHEN     ( lWhen ) ;
         VALID    ( nTotPedCli( nil, TDataView():PedidosClientes( nView ), dbfTmpLin, dbfIva, dbfDiv, dbfFPago, aTmp ), .t. ) ;
         ON CHANGE( nTotPedCli( nil, TDataView():PedidosClientes( nView ), dbfTmpLin, dbfIva, dbfDiv, dbfFPago, aTmp ) );
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
         ACTION   ( DbSwapUp( dbfTmpLin, oBrwLin ) )

		REDEFINE BUTTON ;
			ID 		525 ;
			OF 		oFld:aDialogs[1] ;
         WHEN     ( lWhen ) ;
         ACTION   ( DbSwapDown( dbfTmpLin, oBrwLin ) )

      REDEFINE BUTTON oBtnKit;
        ID       	526 ;
		OF 			oFld:aDialogs[1] ;
        ACTION   	( lEscandalloEdtRec( .t., oBrwLin ) )

	  REDEFINE BUTTON oBtnAtp;
        ID       	527 ;
        OF       	oFld:aDialogs[1] ;
        ACTION   	( CargaAtipicasCliente( aTmp, oBrwLin, oDlg ) )

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

		REDEFINE GET aGet[_CSUFPED] VAR aTmp[_CSUFPED];
			ID 		105 ;
			WHEN 		.F. ;
			OF 		oFld:aDialogs[1]

      REDEFINE GET aGet[ _DFECPED ] VAR aTmp[ _DFECPED ];
			ID 		110 ;
			SPINNER;
         WHEN     ( lWhen ) ;
			COLOR 	CLR_GET ;
			OF 		oFld:aDialogs[1]

      REDEFINE GET aGet[ _NESTADO ] VAR cEstPed;
         WHEN     .f. ;
         ID       120 ;
         IDSAY    121 ;
			OF 		oFld:aDialogs[1]

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
         ID       117 ;
         PICTURE  "9999" ;
         OF       oFld:aDialogs[1]

      REDEFINE SAY oSayTxtDias ;
         ID       118 ;
         OF       oFld:aDialogs[1]

      // Codigo del usuario----------------------------------------------------

      REDEFINE GET aGet[ _CCODUSR ] VAR aTmp[ _CCODUSR ];
         ID       115 ;
         WHEN     ( .f. ) ;
         VALID    ( SetUsuario( aGet[ _CCODUSR ], oSay[ 10 ], nil, dbfUsr ) );
         OF       oFld:aDialogs[2]

      REDEFINE GET oSay[ 10 ] VAR cSay[ 10 ] ;
         ID       116 ;
         WHEN     ( .f. ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[_CNUMPRE] VAR aTmp[_CNUMPRE];
         ID       125 ;
         IDSAY    124 ;
         PICTURE  "@R #/#########/##" ;
         WHEN     ( nMode == APPD_MODE ) ;
         COLOR    CLR_GET ;
         BITMAP   "LUPA" ;
         VALID    (  cPreCli( aTmp, aGet, oBrwLin, nMode ), SetDialog( aGet, oSayDias, oSayTxtDias, oSayGetRnt, oGetRnt ) );
         ON HELP  (  BrwPreCli( aGet[ _CNUMPRE ], dbfPreCliT, dbfPreCliL, dbfIva, dbfDiv, dbfFPago, aGet[ _LIVAINC ] ) );
			OF 		oFld:aDialogs[1]

      REDEFINE COMBOBOX aGet[ _CSITUAC ] VAR aTmp[ _CSITUAC ] ;
         ID       218 ;
         WHEN     ( lWhen );
         ITEMS    ( TSituaciones():GetInstance():GetSituaciones() ) ;
         OF       oFld:aDialogs[1]

      REDEFINE COMBOBOX oTipPed VAR cTipPed ;
         ID       217 ;
         WHEN     ( ( dbfTmpLin )->( LastRec() ) == 0 ) ;
         ITEMS    aTipPed ;
         ON CHANGE( SetDialog( aGet, oSayDias, oSayTxtDias, oSayGetRnt, oGetRnt ) );
         OF       oFld:aDialogs[1]

      REDEFINE CHECKBOX aGet[ _LIVAINC ] VAR aTmp[ _LIVAINC ] ;
         ID       129 ;
         WHEN     ( ( dbfTmpLin )->( LastRec() ) == 0 ) ;
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

      REDEFINE GET aGet[_CCODTRN] VAR aTmp[_CCODTRN] ;
         ID       235 ;
         WHEN     ( lWhen ) ;
         VALID    ( LoadTrans( aTmp, aGet[ _CCODTRN ], aGet[ _NKGSTRN ], oSay[ 8 ] ) );
         BITMAP   "LUPA" ;
         ON HELP  ( oTrans:Buscar( aGet[_CCODTRN] ), .t. );
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

      REDEFINE GET aGet[ _NBULTOS ] VAR aTmp[ _NBULTOS ];
         ID       128 ;
			SPINNER;
         PICTURE  "999" ;
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
         ID       180 ;
         WHEN     ( lWhen ) ;
			COLOR 	CLR_GET ;
         OF       oFld:aDialogs[2]

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
      Impresi�n ( informa de si est� imprimido o no y de cuando se imprimi� )--
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

      /*
      Cancelado ( informa de si est� cancelado o no, la fecha y el motivo de cancelaci�n )
      */

      REDEFINE CHECKBOX aGet[ _LCANCEL ] VAR aTmp[ _LCANCEL ] ;
         ID       130 ;
         ON CHANGE( lChangeCancel( aGet, aTmp, dbfTmpLin ) ) ;
         WHEN     ( nMode != ZOOM_MODE .and. lUsrMaster() .and. aTmp[ _NESTADO ] != 2 ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ _DCANCEL ] VAR aTmp[ _DCANCEL ] ;
         ID       131 ;
         WHEN     ( nMode != ZOOM_MODE .and. lUsrMaster() .and. aTmp[ _LCANCEL ] ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ _CCANCEL ] VAR aTmp[ _CCANCEL ] ;
         ID       132 ;
         WHEN     ( nMode != ZOOM_MODE .and. lUsrMaster() .and. aTmp[ _LCANCEL ] ) ;
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
         :cHeader             := "Sesi�n cerrada"
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
         :cHeader             := "Sesi�n"
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
         :bEditValue          := {|| nEntPedCli( dbfTmpPgo, dbfDiv, cDivEmp(), .t. ) }
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
            :cHeader          := "C�digo"
            :bEditValue       := {|| ( dbfTmpInc )->cCodTip }
            :nWidth           := 80
         end with

         with object ( oBrwInc:AddCol() )
            :cHeader          := "Incidencia"
            :bEditValue       := {|| cNomInci( ( dbfTmpInc )->cCodTip, dbfInci ) }
            :nWidth           := 200
         end with

         with object ( oBrwInc:AddCol() )
            :cHeader          := "Fecha"
            :bEditValue       := {|| Dtoc( ( dbfTmpInc )->dFecInc ) }
            :nWidth           := 90
         end with

         with object ( oBrwInc:AddCol() )
            :cHeader          := "Descripci�n"
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

      //Caja de dialogo de docuentos

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
         ACTION   ( if( ExitNoSave( nMode, dbfTmpLin ), oDlg:end(), ) )

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

      oDlg:AddFastKey( VK_F5, {|| EndTrans( aTmp, aGet, oBrwLin, oBrwInc, nMode, oDlg ) } )
      oDlg:AddFastKey( VK_F6, {|| if( EndTrans( aTmp, aGet, oBrwLin, oBrwInc, nMode, oDlg ), GenPedCli( IS_PRINTER ), ) } )
      oDlg:AddFastKey( VK_F7, {|| ExcelImport( aTmp, dbfTmpLin, dbfArticulo, dbfArtDiv, dbfFamilia, dbfDiv, oBrwLin, .t. ) } )

      oDlg:AddFastKey( 65,    {|| if( GetKeyState( VK_CONTROL ), CreateInfoArticulo(), ) } )

   end if

   oDlg:AddFastKey ( VK_F1, {|| ChmHelp( "Pedido" ) } )

   oDlg:bStart 		:= {|| StartEdtRec( aTmp, aGet, oDlg, nMode, cCodArt, cCodPre, oBrwLin, cCodCli ) }

	ACTIVATE DIALOG oDlg;
      ON INIT  (  InitEdtRec( aTmp, aGet, oDlg, oBrwLin, oBrwInc, oBrwPgo ), SetDialog( aGet, oSayDias, oSayTxtDias, oSayGetRnt, oGetRnt ) );
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

   ( TDataView():PedidosClientes( nView ) )->( ordSetFocus( nOrd ) )

   oBmpGeneral:End()

   /*
   Muestra los avisos para nuevos pedidos por internet-------------------------
   */

   lPedidosWeb( TDataView():PedidosClientes( nView ) )

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

	         	if !lGetUsuario( aGet[ _CCODUSR ], dbfUsr )
         			oDlg:End()
         		end if

      		case lRecogerUsuario() .and. !Empty( cCodArt )
	      		
      			if lGetUsuario( aGet[ _CCODUSR ], dbfUsr )
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

   	/*
   	Hace que salte la incidencia al entrar en el documento----------------------
   	*/

   	if !Empty( dbfTmpInc ) .and. ( dbfTmpInc )->( Used() ) 

      	while !( dbfTmpInc )->( Eof() )
         	if ( dbfTmpInc )->lAviso .and. !( dbfTmpInc )->lListo
            	MsgInfo( Trim( ( dbfTmpInc )->mDesInc ), "�Incidencia!" )
         	end if
         	( dbfTmpInc )->( dbSkip() )
      	end while

      	( dbfTmpInc )->( dbGoTop() )

   	end if

Return ( nil )

//--------------------------------------------------------------------------//

Static Function InitEdtRec( aTmp, aGet, oDlg, oBrwLin, oBrwInc, oBrwPgo )

   EdtRecMenu( aTmp, oDlg )
   
   oBrwLin:Load()
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

   DEFAULT aTmpPed   := dbScatter( TDataView():PedidosClientes( nView ) )

   do case
      case nMode == APPD_MODE

         aTmp[ ( dbfTmpPgo )->( FieldPos( "cTurRec" ) ) ]      	:= cCurSesion()
         aTmp[ ( dbfTmpPgo )->( FieldPos( "cCodCaj" ) ) ]      	:= oUser():cCaja()

         aTmp[ ( dbfTmpPgo )->( FieldPos( "cSerPed" ) ) ]      	:= aTmpPed[ _CSERPED ]
         aTmp[ ( dbfTmpPgo )->( FieldPos( "nNumPed" ) ) ]      	:= aTmpPed[ _NNUMPED ]
         aTmp[ ( dbfTmpPgo )->( FieldPos( "cSufPed" ) ) ]      	:= aTmpPed[ _CSUFPED ]
         aTmp[ ( dbfTmpPgo )->( FieldPos( "cCodCli" ) ) ]      	:= aTmpPed[ _CCODCLI ]
         aTmp[ ( dbfTmpPgo )->( FieldPos( "cCodAge" ) ) ]      	:= aTmpPed[ _CCODAGE ]
         aTmp[ ( dbfTmpPgo )->( FieldPos( "cDivPgo" ) ) ]      	:= aTmpPed[ _CDIVPED ]
         aTmp[ ( dbfTmpPgo )->( FieldPos( "cCodPgo" ) ) ]      	:= aTmpPed[ _CCODPGO ]

         if dbSeekInOrd( aTmpPed[ _CCODPGO ], "cCodPago", dbfFPago ) .and. ( dbfFPago )->lUtlBnc

            aTmp[ ( dbfTmpPgo )->( FieldPos( "cBncEmp" ) ) ]   	:= ( dbfFPago )->cBanco
            aTmp[ ( dbfTmpPgo )->( FieldPos( "cEPaisIBAN" ) ) ]   := ( dbfFPago )->cPaisIBAN
            aTmp[ ( dbfTmpPgo )->( FieldPos( "cECtrlIBAN" ) ) ]   := ( dbfFPago )->cCtrlIBAN
            aTmp[ ( dbfTmpPgo )->( FieldPos( "cEntEmp" ) ) ]   	:= ( dbfFPago )->cEntBnc
            aTmp[ ( dbfTmpPgo )->( FieldPos( "cSucEmp" ) ) ]   	:= ( dbfFPago )->cSucBnc
            aTmp[ ( dbfTmpPgo )->( FieldPos( "cDigEmp" ) ) ]   	:= ( dbfFPago )->cDigBnc
            aTmp[ ( dbfTmpPgo )->( FieldPos( "cCtaEmp" ) ) ]   	:= ( dbfFPago )->cCtaBnc

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

   cGetCli           := RetFld( aTmp[ ( dbfTmpPgo )->( FieldPos( "cCodCli" ) ) ], TDataView():Clientes( nView ), "Titulo" )
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
                  "RecibosProveedoresBancos"

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
         VALID    ( cClient( aGet[ ( dbfTmpPgo )->( FieldPos( "cCodCli" ) ) ], TDataView():Clientes( nView ), oGetCli ) ) ;
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

      //Descripci�n

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
      Pesta�a de bancos--------------------------------------------------------
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
               RESOURCE "User1_16" ;
               ACTION   ( if( !Empty( aTmp[ ( dbfTmpPgo )->( FieldPos( "cCodCli" ) ) ] ), EdtCli( aTmp[ ( dbfTmpPgo )->( FieldPos( "cCodCli" ) ) ] ), MsgStop( "C�digo de cliente vac�o" ) ) )

            MENUITEM    "&2. Modificar cliente contactos";
               MESSAGE  "Modifica la ficha del cliente en contactos" ;
               RESOURCE "User1_16" ;
               ACTION   ( if( !Empty( aTmp[ ( dbfTmpPgo )->( FieldPos( "cCodCli" ) ) ] ), EdtCli( aTmp[ ( dbfTmpPgo )->( FieldPos( "cCodCli" ) ) ], , 5 ), MsgStop( "C�digo de cliente vac�o" ) ) )

            MENUITEM    "&3. Informe de cliente";
               MESSAGE  "Informe de cliente" ;
               RESOURCE "Info16" ;
               ACTION   ( if( !Empty( aTmp[ ( dbfTmpPgo )->( FieldPos( "cCodCli" ) ) ] ), InfCliente( aTmp[ ( dbfTmpPgo )->( FieldPos( "cCodCli" ) ) ] ), MsgStop( "C�digo de cliente vac�o" ) ) );

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

            MENUITEM    "&1. Visualizar presupuesto";
               MESSAGE  "Visualiza el presupuesto del cliente" ;
               RESOURCE "Notebook_User1_16";
               ACTION   ( if( !Empty( aTmp[ _CNUMPRE ] ), ZooPreCli( aTmp[ _CNUMPRE ] ), MsgStop( "El pedido no proviene de presupuesto" ) ) )

            SEPARATOR

            MENUITEM    "&2. Generar anticipo";
               MESSAGE  "Genera anticipo de cliente" ;
               RESOURCE "Document_Money2_16";
               ACTION   ( if( !Empty( aTmp[ _CCODCLI ] ), CreateAntCli( aTmp[ _CCODCLI ] ), msgStop("Debe seleccionar un cliente para hacer una factura de anticipo" ) ) );

            SEPARATOR

            MENUITEM    "&3. Modificar cliente";
               MESSAGE  "Modificar la ficha del cliente" ;
               RESOURCE "User1_16";
               ACTION   ( if( !Empty( aTmp[ _CCODCLI ] ), EdtCli( aTmp[ _CCODCLI ] ), MsgStop( "C�digo de cliente vac�o" ) ) )

            MENUITEM    "&4. Modificar cliente contactos";
               MESSAGE  "Modifica la ficha del cliente en contactos" ;
               RESOURCE "User1_16" ;
               ACTION   ( if( !Empty( aTmp[ _CCODCLI ] ), EdtCli( aTmp[ _CCODCLI ], , 5 ), MsgStop( "C�digo de cliente vac�o" ) ) )

            MENUITEM    "&5. Informe de cliente";
               MESSAGE  "Abrir el informe del cliente" ;
               RESOURCE "Info16";
               ACTION   ( if( !Empty( aTmp[ _CCODCLI ] ), InfCliente( aTmp[ _CCODCLI ] ), MsgStop( "C�digo de cliente vac�o" ) ) );

            MENUITEM    "&6. Modificar direcci�n";
               MESSAGE  "Modifica la obra del documento" ;
               RESOURCE "Worker16";
               ACTION   ( if( !Empty( aTmp[ _CCODOBR ] ), EdtObras( aTmp[ _CCODCLI ], aTmp[ _CCODOBR ], dbfObrasT ), MsgStop( "C�digo de obra vac�o" ) ) );

            SEPARATOR

            end if

            MENUITEM    "&7. Informe del documento";
               MESSAGE  "Informe del documento" ;
               RESOURCE "Info16";
               ACTION   ( TTrazaDocumento():Activate( PED_CLI, aTmp[ _CSERPED ] + Str( aTmp[ _NNUMPED ] ) + aTmp[ _CSUFPED ] ) );

         ENDMENU

   ENDMENU

   oDlg:SetMenu( oMenu )

Return ( oMenu )

//--------------------------------------------------------------------------//

/*
Edita las lineas de Detalle
*/

STATIC FUNCTION EdtDet( aTmp, aGet, dbfPedCliL, oBrw, lTotLin, cCodArtEnt, nMode, aTmpPed )

   local oDlg
   local oFld
   local oBtn
   local oBrwResCli
   local oBrwAlbCli
   local oBrwFacCli
   local oBrwAlbPrv
   local oGet2
   local cGet2
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
   local oSayDias
   local oGetCaducidad
   local dGetCaducidad
   local nOrdFacCliL
   local oBtnSer
   local oEstadoProduccion
   local cEstadoProduccion 


   do case
   case nMode == APPD_MODE

      aTmp[ _NNUMPED    ] 	:= aTmpPed[ _NNUMPED ]
      aTmp[ _NUNICAJA   ] 	:= 1
      aTmp[ _DFECHA     ] 	:= Ctod( "" )
      aTmp[ _CTIPMOV    ] 	:= cDefVta()
      aTmp[ _LTOTLIN    ] 	:= lTotLin
      aTmp[ _NCANPED    ] 	:= 1
      aTmp[ _CALMLIN    ] 	:= aTmpPed[ _CCODALM ]
      aTmp[ _LIVALIN    ] 	:= aTmpPed[ _LIVAINC ]
      aTmp[ _NTARLIN    ] 	:= aTmpPed[ _NTARIFA ]
      aTmp[ _DFECCAD    ] 	:= Ctod( "" )
		aTmp[ _NPRODUC    ]	:= 0
      aTmp[ __DFECSAL   ] 	:= aTmpPed[ _DFECSAL ]
      aTmp[ __DFECENT   ] 	:= aTmpPed[ _DFECENTR]
      aTmp[ __LALQUILER ]	:= !Empty( oTipPed ) .and. ( oTipPed:nAt == 2 )

      if aTmpPed[ _NREGIVA ] <= 1
         aTmp[ _NIVA ]  	:= nIva( dbfIva, cDefIva() )
      end if

      if !Empty( cCodArtEnt )
         cCodArt        	:= Padr( cCodArtEnt, 200 )
      end if

   case nMode == EDIT_MODE

      lTotLin           	:= aTmp[ _LTOTLIN ]

   end case

   /*
   Este valor los guaradamos para detectar los posibles cambios----------------
   */

   cOldCodArt           	:= aTmp[ _CREF    ]
   cOldPrpArt           	:= aTmp[ _CCODPR1 ] + aTmp[ _CCODPR2 ] + aTmp[ _CVALPR1 ] + aTmp[ _CVALPR2 ]
   cOldUndMed           	:= aTmp[ _CUNIDAD ]

   nOrdPedPrv           	:= ( dbfPedPrvL )->( OrdSetFocus( "cPedCliRef" ) )

   dFecRes              	:= dTmpPdtRec( aTmp[ _CREF ], aTmp[ _CVALPR1 ], aTmp[ _CVALPR2 ], dbfTmpRes )
   nTotRes              	:= nUnidadesRecibidasAlbCli( cNumPed, aTmp[ _CREF ], aTmp[ _CCODPR1 ], aTmp[ _CCODPR2 ], aTmp[ _CREFPRV ], aTmp[ _CDETALLE ], dbfAlbCliL )
   nTotRes              	+= nUnidadesRecibidasFacCli( cNumPed, aTmp[ _CREF ], aTmp[ _CCODPR1 ], aTmp[ _CCODPR2 ], dbfFacCliL )

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
   cSayFam              	:= RetFld( aTmp[ _CCODFAM ], dbfFamilia )

   /*
   Filtros---------------------------------------------------------------------
   */

   nOrdAnt              	:= ( dbfAlbCliL )->( OrdSetFocus( "cNumPedRef" ) )

   ( dbfAlbCliL )->( OrdScope( 0, aTmp[ _CSERPED ] + Str( aTmp[ _NNUMPED ] ) + aTmp[ _CSUFPED ] + aTmp[ _CREF ] + aTmp[ _CVALPR1 ] + aTmp[ _CVALPR2 ] ) )
   ( dbfAlbCliL )->( OrdScope( 1, aTmp[ _CSERPED ] + Str( aTmp[ _NNUMPED ] ) + aTmp[ _CSUFPED ] + aTmp[ _CREF ] + aTmp[ _CVALPR1 ] + aTmp[ _CVALPR2 ] ) )
   ( dbfAlbCliL )->( dbGoTop() )

   /*
   Hacemos un Scope para saber qu� facturas est�n vinculadas con este pedido---
   */

   nOrdFacCliL          	:= ( dbfFacCliL )->( OrdSetFocus( "cNumPedRef" ) )

   ( dbfFacCliL )->( OrdScope( 0, aTmp[ _CSERPED ] + Str( aTmp[ _NNUMPED ] ) + aTmp[ _CSUFPED ] + aTmp[ _CREF ] ) )
   ( dbfFacCliL )->( OrdScope( 1, aTmp[ _CSERPED ] + Str( aTmp[ _NNUMPED ] ) + aTmp[ _CSUFPED ] + aTmp[ _CREF ] ) )
   ( dbfFacCliL )->( dbGoTop() )

   nOrdAlbPrv           	:= ( dbfAlbPrvL )->( OrdSetFocus( "cPedCliRef" ) )

   ( dbfAlbPrvL )->( OrdScope( 0, aTmp[ _CSERPED ] + Str( aTmp[ _NNUMPED ] ) + aTmp[ _CSUFPED ] + aTmp[ _CREF ] + aTmp[ _CVALPR1 ] + aTmp[ _CVALPR2 ] ) )
   ( dbfAlbPrvL )->( OrdScope( 1, aTmp[ _CSERPED ] + Str( aTmp[ _NNUMPED ] ) + aTmp[ _CSUFPED ] + aTmp[ _CREF ] + aTmp[ _CVALPR1 ] + aTmp[ _CVALPR2 ] ) )
   ( dbfAlbPrvL )->( dbGoTop() )

   ( dbfTmpRes )->( OrdScope( 0, aTmp[ _CREF ] + aTmp[ _CVALPR1 ] + aTmp[ _CVALPR2 ] ) )
   ( dbfTmpRes )->( OrdScope( 1, aTmp[ _CREF ] + aTmp[ _CVALPR1 ] + aTmp[ _CVALPR2 ] ) )
   ( dbfTmpRes )->( dbGoTop() )

   DEFINE DIALOG oDlg RESOURCE "LFACCLI" TITLE LblTitle( nMode ) + "lineas a pedidos de clientes"

      if aTmp[ __LALQUILER ]

         REDEFINE FOLDER oFld ;
            ID       400 ;
            OF       oDlg ;
            PROMPT   "&General",;
                     "Da&tos",;
                     "R&ecepciones",;
                     "Reser&vas",;
                     "Entre&gas",;
                     "&Anular",;
                     "&Observaciones" ;
            DIALOGS  "LPRECLI_4",;
                     "LPEDCLI_2",;
                     "LPEDCLI_6",;
                     "LPEDCLI_4",;
                     "LPEDCLI_5",;
                     "LPEDCLI_3",;
                     "LFACCLI_3"

      else

         REDEFINE FOLDER oFld ;
            ID       400 ;
            OF       oDlg ;
            PROMPT   "&General",;
                     "Da&tos",;
                     "R&ecepciones",;
                     "Reser&vas",;
                     "Entre&gas",;
                     "&Anular",;
                     "&Observaciones" ;
            DIALOGS  "LFACCLI_1",;
                     "LPEDCLI_2",;
                     "LPEDCLI_6",;
                     "LPEDCLI_4",;
                     "LPEDCLI_5",;
                     "LPEDCLI_3",;
                     "LFACCLI_3"

      end if

      REDEFINE GET aGet[ _CREF ] VAR cCodArt;
			ID 		100 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( LoaArt( cCodArt, aTmp, aGet, aTmpPed, oStkAct, oSayPr1, oSayPr2, oSayVp1, oSayVp2, bmpImage, nMode ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwArticulo( aGet[ _CREF ], aGet[ _CDETALLE ] ) ) ;
			COLOR 	CLR_GET ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CDETALLE ] VAR aTmp[ _CDETALLE ] ;
         ID       110 ;
         WHEN     ( ( lModDes() .or. Empty( aTmp[ _CDETALLE ] ) ) .AND. nMode != ZOOM_MODE );
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

      if !aTmp[ __LALQUILER ]

      REDEFINE GET oGetCaducidad VAR dGetCaducidad ;
         ID       340 ;
         IDSAY    341 ;
			SPINNER ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

      end if

      REDEFINE GET aGet[ _MLNGDES ] VAR aTmp[ _MLNGDES ] ;
			MEMO ;
			ID 		111 ;
         WHEN     ( ( lModDes() .or. Empty( aTmp[ _MLNGDES ] ) ) .AND. nMode != ZOOM_MODE );
         OF       oFld:aDialogs[1]

      /*
      Propiedades
      -------------------------------------------------------------------------
      */

      if !aTmp[ __LALQUILER ]

      REDEFINE GET aGet[ _CVALPR1 ] VAR aTmp[ _CVALPR1 ];
         ID       270 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
			COLOR 	CLR_GET ;
         BITMAP   "LUPA" ;
         VALID    ( if( lPrpAct( aTmp[ _CVALPR1 ], oSayVp1, aTmp[ _CCODPR1 ], dbfTblPro ),;
                        LoaArt( cCodArt, aTmp, aGet, aTmpPed, oStkAct, oSayPr1, oSayPr2, oSayVp1, oSayVp2, bmpImage, nMode, .f. ),;
                        .f. ) );
         ON HELP  ( brwPrpAct( aGet[ _CVALPR1 ], oSayVp1, aTmp[ _CCODPR1 ] ) ) ;
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
         VALID    ( if( lPrpAct( aTmp[ _CVALPR2 ], oSayVp2, aTmp[ _CCODPR2 ], dbfTblPro ),;
                        LoaArt( cCodArt, aTmp, aGet, aTmpPed, oStkAct, oSayPr1, oSayPr2, oSayVp1, oSayVp2, bmpImage, nMode, .f. ),;
                        .f. ) );
         ON HELP  ( brwPrpAct( aGet[_CVALPR2], oSayVp2, aTmp[_CCODPR2 ] ) ) ;
         OF       oFld:aDialogs[1]

      REDEFINE SAY oSayPr2 VAR cSayPr2;
         ID       281 ;
         OF       oFld:aDialogs[1]

      REDEFINE GET oSayVp2 VAR cSayVp2;
         ID       282 ;
         WHEN     .f. ;
         COLOR    CLR_GET ;
         OF       oFld:aDialogs[1]

      end if

      REDEFINE GET aGet[ _CUNIDAD ] VAR aTmp[ _CUNIDAD ] ;
         ID       170 ;
         IDTEXT   171 ;
         BITMAP   "LUPA" ;
         VALID    ( oUndMedicion:Existe( aGet[ _CUNIDAD ], aGet[ _CUNIDAD ]:oHelpText, "cNombre" ), ValidaMedicion( aTmp, aGet ) );
         ON HELP  ( oUndMedicion:Buscar( aGet[ _CUNIDAD ] ), ValidaMedicion( aTmp, aGet ) ) ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

      // Campos de las descripciones de la unidad de medici�n

      REDEFINE GET aGet[ ( dbfPedCliL )->( fieldpos( "nMedUno" ) ) ] ;
         VAR      aTmp[ ( dbfPedCliL )->( fieldpos( "nMedUno" ) ) ] ;
         ID       520 ;
         IDSAY    521 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ON CHANGE( RecalculaLinea( aTmp, aTmpPed, nDouDiv, oTotal, oTot, oRentLin, cCodDiv ) );
         PICTURE  MasUnd() ;
         OF       oFld:aDialogs[1]

         aGet[ ( dbfPedCliL )->( fieldpos( "nMedUno" ) ) ]:oSay:SetColor( CLR_BLUE )

      REDEFINE GET aGet[ ( dbfPedCliL )->( fieldpos( "nMedDos" ) ) ] ;
         VAR      aTmp[ ( dbfPedCliL )->( fieldpos( "nMedDos" ) ) ] ;
         ID       530 ;
         IDSAY    531 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ON CHANGE( RecalculaLinea( aTmp, aTmpPed, nDouDiv, oTotal, oTot, oRentLin, cCodDiv ) );
         PICTURE  MasUnd() ;
         OF       oFld:aDialogs[1]

         aGet[ ( dbfPedCliL )->( fieldpos( "nMedDos" ) ) ]:oSay:SetColor( CLR_BLUE )

      REDEFINE GET aGet[ ( dbfPedCliL )->( fieldpos( "nMedTre" ) ) ] ;
         VAR      aTmp[ ( dbfPedCliL )->( fieldpos( "nMedTre" ) ) ] ;
         ID       540 ;
         IDSAY    541 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ON CHANGE( RecalculaLinea( aTmp, aTmpPed, nDouDiv, oTotal, oTot, oRentLin, cCodDiv ) );
         PICTURE  MasUnd() ;
         OF       oFld:aDialogs[1]

         aGet[ ( dbfPedCliL )->( fieldpos( "nMedTre" ) ) ]:oSay:SetColor( CLR_BLUE )

      /*
      Tipo de impuestos
      -------------------------------------------------------------------------
      */

      if IsMuebles()

         REDEFINE GET aGet[ _CREFPRV ] VAR aTmp[ _CREFPRV ] ;
            ID       500 ;
            IDSAY    501 ;
            WHEN     ( nMode != ZOOM_MODE ) ;
            OF       oFld:aDialogs[1]

      end if

      REDEFINE GET aGet[ _NIVA ] VAR aTmp[ _NIVA ] ;
			ID 		120 ;
         WHEN     ( lModIva() .AND. nMode != ZOOM_MODE .AND. !lTotLin ) ;
         PICTURE  "@E 99.99" ;
			COLOR 	CLR_GET ;
         ON CHANGE( RecalculaLinea( aTmp, aTmpPed, nDouDiv, oTotal, oTot, oRentLin, cCodDiv ) );
         VALID    ( lTiva( dbfIva, aTmp[ _NIVA ], @aTmp[ _NREQ ] ) );
         BITMAP   "LUPA" ;
         ON HELP  ( BrwIva( aGet[ _NIVA ], dbfIva, , .t. ) ) ;
         OF       oFld:aDialogs[1]

      if aTmp[ __LALQUILER ]

      REDEFINE GET aGet[ __DFECSAL ] VAR aTmp[ __DFECSAL ];
         ID       420 ;
			SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( RecalculaLinea( aTmp, aTmpPed, nDouDiv, oTotal, oTot, oRentLin, cCodDiv ) );
         ON CHANGE( RecalculaLinea( aTmp, aTmpPed, nDouDiv, oTotal, oTot, oRentLin, cCodDiv ), oSayDias:Refresh() );
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ __DFECENT ] VAR aTmp[ __DFECENT ];
         ID       430 ;
			SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( RecalculaLinea( aTmp, aTmpPed, nDouDiv, oTotal, oTot, oRentLin, cCodDiv ) );
         ON CHANGE( RecalculaLinea( aTmp, aTmpPed, nDouDiv, oTotal, oTot, oRentLin, cCodDiv ), oSayDias:Refresh() );
         OF       oFld:aDialogs[1]

      REDEFINE SAY oSayDias ;
         VAR      ( aTmp[ __DFECENT ] - aTmp[ __DFECSAL ] );
         PICTURE  "9999";
         ID       440;
         OF       oFld:aDialogs[1]

      else

      REDEFINE GET aGet[ _NVALIMP ] VAR aTmp[ _NVALIMP ] ;
         ID       125 ;
         SPINNER ;
         WHEN     ( uFieldEmpresa( "lModImp" ) .AND. nMode != ZOOM_MODE ) ;
         PICTURE  cPouDiv ;
         COLOR    CLR_GET ;
         ON CHANGE( RecalculaLinea( aTmp, aTmpPed, nDouDiv, oTotal, oTot, oRentLin, cCodDiv ) );
         ON HELP  ( oNewImp:nBrwImp( aGet[ _NVALIMP ] ) );
         IDSAY    126 ;
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

		REDEFINE GET aGet[_NCANPED] VAR aTmp[_NCANPED];
			ID 		130 ;
			SPINNER ;
         WHEN     ( lUseCaj() .AND. nMode != ZOOM_MODE .AND. !lTotLin ) ;
         ON CHANGE( RecalculaLinea( aTmp, aTmpPed, nDouDiv, oTotal, oTot, oRentLin, cCodDiv ), LoaArt( cCodArt, aTmp, aGet, aTmpPed, oStkAct, oSayPr1, oSayPr2, oSayVp1, oSayVp2, bmpImage, nMode, .f. ) ) ;
         VALID    ( RecalculaLinea( aTmp, aTmpPed, nDouDiv, oTotal, oTot, oRentLin, cCodDiv ), LoaArt( cCodArt, aTmp, aGet, aTmpPed, oStkAct, oSayPr1, oSayPr2, oSayVp1, oSayVp2, bmpImage, nMode, .f. ) ) ;
			PICTURE 	cPicUnd ;
         OF       oFld:aDialogs[1] ;
         IDSAY    131

		REDEFINE GET aGet[_NUNICAJA] VAR aTmp[_NUNICAJA];
			ID 		140 ;
			SPINNER ;
         WHEN     ( nMode != ZOOM_MODE .AND. !lTotLin ) ;
         ON CHANGE( RecalculaLinea( aTmp, aTmpPed, nDouDiv, oTotal, oTot, oRentLin, cCodDiv ), LoaArt( cCodArt, aTmp, aGet, aTmpPed, oStkAct, oSayPr1, oSayPr2, oSayVp1, oSayVp2, bmpImage, nMode, .f. ) ) ;
         VALID    ( RecalculaLinea( aTmp, aTmpPed, nDouDiv, oTotal, oTot, oRentLin, cCodDiv ), LoaArt( cCodArt, aTmp, aGet, aTmpPed, oStkAct, oSayPr1, oSayPr2, oSayVp1, oSayVp2, bmpImage, nMode, .f. ) ) ;
			PICTURE 	cPicUnd ;
         OF       oFld:aDialogs[1] ;
         IDSAY    141

      /*
      Precios
      -------------------------------------------------------------------------
      */

      REDEFINE GET aGet[ _NPREDIV ] VAR aTmp[ _NPREDIV ] ;
			ID 		150 ;
			SPINNER ;
         WHEN     ( nMode != ZOOM_MODE .AND. !lTotLin ) ;
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
         VALID    ( aTmp[ _NTARLIN ] >= 1 .AND. aTmp[ _NTARLIN ] <= 6 );
         WHEN     ( nMode != ZOOM_MODE .and. ( lUsrMaster() .or. oUser():lCambiarPrecio() ) );
         ON CHANGE( ChangeTarifa( aTmp, aGet, aTmpPed ), RecalculaLinea( aTmp, aTmpPed, nDouDiv, oTotal, oTot, oRentLin, cCodDiv ) );
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
      Tipo de moviminto
      -------------------------------------------------------------------------
      */

		REDEFINE GET aGet[_CTIPMOV] VAR aTmp[ _CTIPMOV ] ;
         WHEN     ( nMode != ZOOM_MODE .AND. !lTotLin ) ;
			VALID		( cTVta( aGet[_CTIPMOV], dbfTVta, oGet2 ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwTVta( aGet[_CTIPMOV], dbfTVta, oGet2 ) ) ;
         ID       290 ;
         OF       oFld:aDialogs[1] ;
         IDSAY    292 ;

		REDEFINE GET oGet2 VAR cGet2 ;
         ID       291 ;
			WHEN 		( .F. ) ;
			COLOR 	CLR_GET ;
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

      REDEFINE GET oStkAct VAR nStkAct ;
         ID       310 ;
         WHEN     .f. ;
         PICTURE  cPicUnd ;
         OF       oFld:aDialogs[1]

      /*
      Segunda caja de dialogo--------------------------------------------------
      */

      REDEFINE GET aGet[ _NNUMLIN ] VAR aTmp[ _NNUMLIN ] ;
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

      REDEFINE CHECKBOX aGet[_LCONTROL] VAR aTmp[_LCONTROL]  ;
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
      Definici�n de familias y grupos de familias------------------------------
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

      aGet[ _CCODPRV ]:bValid  := {|| cProvee( aGet[ _CCODPRV ], dbfPrv, aGet[ _CCODPRV ]:oHelpText ) }
      aGet[ _CCODPRV ]:bHelp   := {|| brwProvee( aGet[ _CCODPRV ], aGet[ _CCODPRV ]:oHelpText ) }

      REDEFINE COMBOBOX oEstadoProduccion ;
         VAR      cEstadoProduccion ;
         ITEMS    aEstadoProduccion ;
         ID       380 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[ 2 ]

      /*
      Tercera caja de di�logo--------------------------------------------------
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
         :cHeader             := "Albar�n"
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
         :cHeader             := "UM. Unidad de medici�n"
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
      Cuarta caja de di�logo---------------------------------------------------
      */

      REDEFINE SAY oTot[ 4 ] PROMPT nTotRPedCli( , aTmp[ _CREF ], aTmp[ _CVALPR1 ], aTmp[ _CVALPR2 ], dbfTmpRes ) ;
         ID       190 ;
         COLOR    "B/W*" ;
         PICTURE  cPicUnd ;
         OF       oFld:aDialogs[4]

      REDEFINE SAY oTot[ 5 ] PROMPT nUnidadesRecibidasAlbCli( cNumPed, aTmp[ _CREF ], aTmp[ _CCODPR1 ], aTmp[ _CCODPR2 ], aTmp[ _CREFPRV ], aTmp[ _CDETALLE ], dbfAlbCliL ) ;
         ID       200 ;
         COLOR    "G/W*" ;
			PICTURE 	cPicUnd ;
         OF       oFld:aDialogs[4]

      REDEFINE SAY oTot[ 6 ] PROMPT NotMinus( nTotRPedCli( , aTmp[ _CREF ], aTmp[ _CVALPR1 ], aTmp[ _CVALPR2 ], dbfTmpRes ) - nUnidadesRecibidasAlbCli( cNumPed, aTmp[ _CREF ], aTmp[ _CCODPR1 ], aTmp[ _CCODPR2 ], aTmp[ _CREFPRV ], aTmp[ _CDETALLE ], dbfAlbCliL ) ) ;
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
      Quinta caja de di�logo---------------------------------------------------
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
         :cHeader             := "Albar�n"
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
         :cHeader             := "UM. Unidad de medici�n"
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
      Relaci�n de facturas-----------------------------------------------------
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
         :cHeader             := "UM. Unidad de medici�n"
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
      Sexta caja de di�logo----------------------------------------------------
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
      Septima caja de di�logo--------------------------------------------------
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
         ACTION   ( SaveDeta( aTmp, aTmpPed, aGet, oFld, oDlg, oBrw, bmpImage, nMode, oStkAct, oSayPr1, oSayPr2, oSayVp1, oSayVp2, oGet2, oTotal, oEstadoProduccion, oBtn ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
         OF       oDlg ;
         CANCEL ;
         ACTION   ( oDlg:end() )

      REDEFINE BUTTON ;
         ID       9 ;
         OF       oDlg ;
         ACTION   ( ChmHelp( "A�adir_v" ) )

      if nMode != ZOOM_MODE

         if uFieldEmpresa( "lGetLot")
            oDlg:AddFastKey( VK_RETURN,   {|| oBtn:SetFocus(), oBtn:Click() } )
         end if 

         oDlg:AddFastKey( VK_F5, 			{|| oBtn:SetFocus(), oBtn:Click() } )

         oFld:aDialogs[4]:AddFastKey( VK_F2, {|| WinAppRec( oBrwResCli, bEdtRes, dbfTmpRes, oTot, nil, aTmp ) } )
         oFld:aDialogs[4]:AddFastKey( VK_F3, {|| WinEdtRec( oBrwResCli, bEdtRes, dbfTmpRes, oTot, nil, aTmp ) } )
         oFld:aDialogs[4]:AddFastKey( VK_F4, {|| DbDelRec( oBrwResCli, dbfTmpRes ), oTot[4]:Refresh(), oTot[5]:Refresh(), oTot[6]:Refresh() } )

      end if

      oDlg:AddFastKey( VK_F1, {|| ChmHelp( "A�adir_v" ) } )

      oDlg:bStart := {||   SetDlgMode( aTmp, aGet, nMode, oStkAct, oSayPr1, oSayPr2, oSayVp1, oSayVp2, oGet2, oTotal, aTmpPed, oFld, oRentLin, oBrwAlbCli, oBrwAlbPrv, oBrwFacCli ),;
                           if( !Empty( oBtnSer ), oBtnSer:Hide(), ),;
                           if( !Empty( cCodArtEnt ), aGet[ _CREF ]:lValid(), ),;
                           aGet[ _CUNIDAD ]:lValid(), aGet[ _CCODPRV ]:lValid() }

   ACTIVATE DIALOG oDlg ; 
         ON INIT     ( EdtDetMenu( aGet[ _CREF ], oDlg ), oBrwResCli:Load() );
         ON PAINT    ( RecalculaLinea( aTmp, aTmpPed, nDouDiv, oTotal, oTot, oRentLin, cCodDiv ) );
         CENTER

   EndDetMenu()

   ( dbfPedPrvL )->( OrdSetFocus( nOrdPedPrv ) )

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

      REDEFINE GET aTmp[ ( dbfPedCliR )->( fieldPos( "DFECRES" ) ) ];
			ID 		100 ;
         SPINNER ;
			COLOR 	CLR_GET ;
         OF       oDlg

      REDEFINE GET oGet VAR aTmp[ ( dbfPedCliR )->( fieldPos( "NCAJRES" ) ) ] ;
			ID 		110 ;
         PICTURE  cPicUnd ;
			COLOR 	CLR_GET ;
         ON CHANGE( oSay:Refresh() ) ;
         SPINNER ;
         OF       oDlg

      REDEFINE GET aTmp[ ( dbfPedCliR )->( fieldPos( "NUNDRES" ) ) ] ;
         ID       120 ;
         PICTURE  cPicUnd ;
         COLOR    CLR_GET ;
         ON CHANGE( oSay:Refresh() ) ;
         SPINNER ;
         OF       oDlg

      REDEFINE SAY oSay PROMPT NotCaja( aTmp[ ( dbfPedCliR )->( fieldPos( "NCAJRES" ) ) ] ) * aTmp[ ( dbfPedCliR )->( fieldPos( "NUNDRES" ) ) ] ;
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
   local cFmtDoc     := cFormatoDocumento( ( TDataView():PedidosClientes( nView ) )->cSerPed, "nPedCli", dbfCount )
   local oSayFmt
   local cSayFmt
   local oSerIni
   local oSerFin
   local cSerIni     := (TDataView():PedidosClientes( nView ))->cSerPed
   local cSerFin     := (TDataView():PedidosClientes( nView ))->cSerPed
   local nDocIni     := (TDataView():PedidosClientes( nView ))->nNumPed
   local nDocFin     := (TDataView():PedidosClientes( nView ))->nNumPed
   local cSufIni     := (TDataView():PedidosClientes( nView ))->cSufPed
   local cSufFin     := (TDataView():PedidosClientes( nView ))->cSufPed
   local dFecDesde   := CtoD( "01/01/" + Str( Year( Date() ) ) )
   local dFecHasta   := Date()
   local oRango
   local nRango      := 1
   local oPrinter
   local cPrinter    := PrnGetName()
   local lCopiasPre  := .t.
   local lInvOrden   := .f.
   local oNumCop
   local nNumCop     := if( nCopiasDocumento( ( TDataView():PedidosClientes( nView ) )->cSerPed, "nPedCli", dbfCount ) == 0, Max( Retfld( ( TDataView():PedidosClientes( nView ) )->cCodCli, TDataView():Clientes( nView ), "CopiasF" ), 1 ), nCopiasDocumento( ( TDataView():PedidosClientes( nView ) )->cSerPed, "nPedCli", dbfCount ) )

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
      	VALID    ( cDocumento( oFmtDoc, oSayFmt, dbfDoc ) ) ;
      	BITMAP   "LUPA" ;
     	ON HELP  ( BrwDocumento( oFmtDoc, oSayFmt, "PC" ) ) ;
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

   		nRecno      := (TDataView():PedidosClientes( nView ))->( recno() )
   		nOrdAnt     := (TDataView():PedidosClientes( nView ))->( OrdSetFocus("NNUMPED") )

   		if !lInvOrden

      		( TDataView():PedidosClientes( nView ) )->( dbSeek( cDocIni, .t. ) )

      		while ( TDataView():PedidosClientes( nView ) )->cSerPed + Str( ( TDataView():PedidosClientes( nView ) )->nNumPed ) + ( TDataView():PedidosClientes( nView ) )->cSufPed >= cDocIni .and. ;
            		( TDataView():PedidosClientes( nView ) )->cSerPed + Str( ( TDataView():PedidosClientes( nView ) )->nNumPed ) + ( TDataView():PedidosClientes( nView ) )->cSufPed <= cDocFin .and. ;
            		!( TDataView():PedidosClientes( nView ) )->( eof() )

            		lChgImpDoc( TDataView():PedidosClientes( nView ) )

         		if lCopiasPre

		            nCopyClient := if( nCopiasDocumento( ( TDataView():PedidosClientes( nView ) )->cSerPed, "nPedCli", dbfCount ) == 0, Max( Retfld( ( TDataView():PedidosClientes( nView ) )->cCodCli, TDataView():Clientes( nView ), "CopiasF" ), 1 ), nCopiasDocumento( ( TDataView():PedidosClientes( nView ) )->cSerPed, "nPedCli", dbfCount ) )

            		GenPedCli( IS_PRINTER, "Imprimiendo documento : " + ( TDataView():PedidosClientes( nView ) )->cSerPed + Str( ( TDataView():PedidosClientes( nView ) )->nNumPed ) + ( TDataView():PedidosClientes( nView ) )->cSufPed, cFmtDoc, cPrinter, nCopyClient )

         		else

		            GenPedCli( IS_PRINTER, "Imprimiendo documento : " + ( TDataView():PedidosClientes( nView ) )->cSerPed + Str( ( TDataView():PedidosClientes( nView ) )->nNumPed ) + ( TDataView():PedidosClientes( nView ) )->cSufPed, cFmtDoc, cPrinter, nNumCop )

         		end if

         		( TDataView():PedidosClientes( nView ) )->( dbSkip() )

      		end do

   		else

      		( TDataView():PedidosClientes( nView ) )->( DbSeek( cDocFin ) )

      		while ( TDataView():PedidosClientes( nView ) )->cSerPed + Str( ( TDataView():PedidosClientes( nView ) )->nNumPed ) + ( TDataView():PedidosClientes( nView ) )->cSufPed >= cDocIni .and.;
            		( TDataView():PedidosClientes( nView ) )->cSerPed + Str( ( TDataView():PedidosClientes( nView ) )->nNumPed ) + ( TDataView():PedidosClientes( nView ) )->cSufPed <= cDocFin .and.;
            		!( TDataView():PedidosClientes( nView ) )->( Bof() )

            		lChgImpDoc( TDataView():PedidosClientes( nView ) )

         		if lCopiasPre

		            nCopyClient := if( nCopiasDocumento( ( TDataView():PedidosClientes( nView ) )->cSerPed, "nPedCli", dbfCount ) == 0, Max( Retfld( ( TDataView():PedidosClientes( nView ) )->cCodCli, TDataView():Clientes( nView ), "CopiasF" ), 1 ), nCopiasDocumento( ( TDataView():PedidosClientes( nView ) )->cSerPed, "nPedCli", dbfCount ) )

            		GenPedCli( IS_PRINTER, "Imprimiendo documento : " + ( TDataView():PedidosClientes( nView ) )->cSerPed + Str( ( TDataView():PedidosClientes( nView ) )->nNumPed ) + ( TDataView():PedidosClientes( nView ) )->cSufPed, cFmtDoc, cPrinter, nCopyClient )

         		else

		            GenPedCli( IS_PRINTER, "Imprimiendo documento : " + ( TDataView():PedidosClientes( nView ) )->cSerPed + Str( ( TDataView():PedidosClientes( nView ) )->nNumPed ) + ( TDataView():PedidosClientes( nView ) )->cSufPed, cFmtDoc, cPrinter, nNumCop )

         		end if

         		( TDataView():PedidosClientes( nView ) )->( dbSkip( -1 ) )

      		end while

   		end if

   	else

   		nRecno      := (TDataView():PedidosClientes( nView ))->( recno() )
   		nOrdAnt     := (TDataView():PedidosClientes( nView ))->( OrdSetFocus( "DFECPED" ) )

   		if !lInvOrden

      		( TDataView():PedidosClientes( nView ) )->( dbGoTop() )

      		while !( TDataView():PedidosClientes( nView ) )->( eof() )

            	if ( TDataView():PedidosClientes( nView ) )->dFecPed >= dFecDesde .and. ( TDataView():PedidosClientes( nView ) )->dFecPed <= dFecHasta

            		lChgImpDoc( TDataView():PedidosClientes( nView ) )

         			if lCopiasPre

			            nCopyClient := if( nCopiasDocumento( ( TDataView():PedidosClientes( nView ) )->cSerPed, "nPedCli", dbfCount ) == 0, Max( Retfld( ( TDataView():PedidosClientes( nView ) )->cCodCli, TDataView():Clientes( nView ), "CopiasF" ), 1 ), nCopiasDocumento( ( TDataView():PedidosClientes( nView ) )->cSerPed, "nPedCli", dbfCount ) )

	            		GenPedCli( IS_PRINTER, "Imprimiendo documento : " + ( TDataView():PedidosClientes( nView ) )->cSerPed + Str( ( TDataView():PedidosClientes( nView ) )->nNumPed ) + ( TDataView():PedidosClientes( nView ) )->cSufPed, cFmtDoc, cPrinter, nCopyClient )

         			else

		            	GenPedCli( IS_PRINTER, "Imprimiendo documento : " + ( TDataView():PedidosClientes( nView ) )->cSerPed + Str( ( TDataView():PedidosClientes( nView ) )->nNumPed ) + ( TDataView():PedidosClientes( nView ) )->cSufPed, cFmtDoc, cPrinter, nNumCop )

         			end if

         		end if	

         		( TDataView():PedidosClientes( nView ) )->( dbSkip() )

      		end do

   		else

      		( TDataView():PedidosClientes( nView ) )->( dbGobottom() )

      		while !( TDataView():PedidosClientes( nView ) )->( Bof() )

            	if ( TDataView():PedidosClientes( nView ) )->dFecPed >= dFecDesde .and. ( TDataView():PedidosClientes( nView ) )->dFecPed <= dFecHasta

            		lChgImpDoc( TDataView():PedidosClientes( nView ) )

         			if lCopiasPre

			            nCopyClient := if( nCopiasDocumento( ( TDataView():PedidosClientes( nView ) )->cSerPed, "nPedCli", dbfCount ) == 0, Max( Retfld( ( TDataView():PedidosClientes( nView ) )->cCodCli, TDataView():Clientes( nView ), "CopiasF" ), 1 ), nCopiasDocumento( ( TDataView():PedidosClientes( nView ) )->cSerPed, "nPedCli", dbfCount ) )

            			GenPedCli( IS_PRINTER, "Imprimiendo documento : " + ( TDataView():PedidosClientes( nView ) )->cSerPed + Str( ( TDataView():PedidosClientes( nView ) )->nNumPed ) + ( TDataView():PedidosClientes( nView ) )->cSufPed, cFmtDoc, cPrinter, nCopyClient )

         			else

			            GenPedCli( IS_PRINTER, "Imprimiendo documento : " + ( TDataView():PedidosClientes( nView ) )->cSerPed + Str( ( TDataView():PedidosClientes( nView ) )->nNumPed ) + ( TDataView():PedidosClientes( nView ) )->cSufPed, cFmtDoc, cPrinter, nNumCop )

         			end if

         		end if	

         		( TDataView():PedidosClientes( nView ) )->( dbSkip( -1 ) )

      		end while

   		end if

   	end if

   	( TDataView():PedidosClientes( nView ) )->( dbGoTo( nRecNo ) )
   	( TDataView():PedidosClientes( nView ) )->( ordSetFocus( nOrdAnt ) )	

   	oDlg:enable()

RETURN NIL

//--------------------------------------------------------------------------//

/*
Borra todas las lineas de detalle de un pedido
*/

STATIC FUNCTION DelDetalle( cNumPed )

   DEFAULT cNumPed   := ( TDataView():PedidosClientes( nView ) )->cSerPed + Str( ( TDataView():PedidosClientes( nView ) )->nNumPed ) + ( TDataView():PedidosClientes( nView )  )->cSufPed

   // Stock -------------------------------------------------------------------

   //oStock:PedCli( cNumPed, ( TDataView():PedidosClientes( nView ) )->cCodAlm, .t., .f. )

   // Lineas ------------------------------------------------------------------

   if ( dbfPedCliL )->( dbSeek( cNumPed ) )
      while ( dbfPedCliL )->cSerPed + Str( ( dbfPedCliL )->nNumPed ) + ( dbfPedCliL )->cSufPed == cNumPed
         if dbLock( dbfPedCliL )
            ( dbfPedCliL )->( dbDelete() )
            ( dbfPedCliL )->( dbUnLock() )
         end if
         ( dbfPedCliL )->( dbSkip() )
      end while
   end if

   // Reservas ----------------------------------------------------------------

   if ( dbfPedCliR )->( dbSeek( cNumPed ) )
      while ( dbfPedCliR )->cSerPed + Str( ( dbfPedCliR )->nNumPed ) + ( dbfPedCliR )->cSufPed == cNumPed
         if dbLock( dbfPedCliR )
            ( dbfPedCliR )->( dbDelete() )
            ( dbfPedCliR )->( dbUnLock() )
         end if
         ( dbfPedCliR )->( dbSkip() )
      end while
   end if

   //Entregas------------------------------------------------------------------

   if ( dbfPedCliP )->( dbSeek( cNumPed ) )
      while ( dbfPedCliP )->( dbSeek( ( TDataView():PedidosClientes( nView ) )->cSerPed + Str( ( TDataView():PedidosClientes( nView ) )->nNumPed ) + ( TDataView():PedidosClientes( nView ) )->cSufPed ) ) .and. !( dbfPedCliP )->( eof() )
         if dbDialogLock( dbfPedCliP )
            ( dbfPedCliP )->( dbDelete() )
            ( dbfPedCliP )->( dbUnLock() )
         end if
         ( dbfPedCliP )->( dbSkip() )
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

   if ApoloMsgNoYes( "Al cambiar el estado perder� la referencia a cualquier documento que est� asociado.", "�Desea cambiarlo?" )

      for each nRec in ( oBrw:aSelected )

         ( TDataView():PedidosClientes( nView ) )->( dbGoTo( nRec ) )

         lQuit                         := .f.

         cNumPed                       := ( TDataView():PedidosClientes( nView ) )->cSerPed + Str( ( TDataView():PedidosClientes( nView ) )->nNumPed ) + ( TDataView():PedidosClientes( nView ) )->cSufPed

         /*
         Cambiamos el estado---------------------------------------------------
         */

         if dbLock( TDataView():PedidosClientes( nView ) )

            if ( TDataView():PedidosClientes( nView ) )->nEstado == 1
               ( TDataView():PedidosClientes( nView ) )->nEstado := 3
            else
               lQuit                   := .t.
               ( TDataView():PedidosClientes( nView ) )->nEstado := 1
            end if

            ( TDataView():PedidosClientes( nView ) )->( dbRUnlock() )

         end if

         if lQuit

            /*
            Borramos la referencia a cualquier cabecera de albar�n asociado-------
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
            Borramos la referencia a cualquier linea de albar�n asociado-------
            */

            nRecAlb  := ( dbfAlbCliL )->( RecNo() )
            nOrdAnt  := ( dbfAlbCliL )->( OrdSetFocus( "cNumPed" ) )

            while ( dbfAlbCliL )->( dbSeek( cNumPed ) ) .and. !( dbfAlbCliL )->( Eof() )

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
            Borramos la referencia a cualquier linea de albar�n asociado-------
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

   IF !( dbfDoc )->( dbSeek( "PC" ) )

         DEFINE BTNSHELL RESOURCE "DOCUMENT" OF oWndBrw ;
            NOBORDER ;
            ACTION   ( msgStop( "No hay facturas de clientes predefinidas" ) );
            TOOLTIP  "No hay documentos" ;
            FROM     oBtn ;
            CLOSED ;
            LEVEL    ACC_EDIT

   ELSE

      WHILE ( dbfDoc )->CTIPO == "PC" .AND. !( dbfDoc )->( eof() )

         bAction  := bGenFac( nDevice, "Imprimiendo pedidos de clientes", ( dbfDoc )->CODIGO )

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
      bGen     := {|| GenPedCli( nDev, cTit, cCod ) }
   else
      bGen     := {|| GenPedCli( nDev, cTit, cCod ) }
   end if

return ( bGen )

//----------------------------------------------------------------------------//

/*
static function ImpRec()

   local oDlg
   local oPag
   local oBrwEmp
   local oBrwPed
   local oBtnPev
   local oBtnNxt
   local oBtnPrv
   local dbfEmp
   local cPatEmp
   local cCodEmp  := "02"

   MsgGet( "Seleccione", "Empresa origen :", @cCodEmp )

   cPatEmp        := "EMP" + cCodEmp

   USE ( cPatEmp + "\PEDCLIT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PEDCLIT", @dbfPedT ) )
   SET ADSINDEX TO ( cPatEmp + "\PEDCLIT.CDX" ) ADDITIVE

   USE ( cPatEmp + "\PEDCLIL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PEDCLIL", @dbfPedL ) )
   SET ADSINDEX TO ( cPatEmp + "\PEDCLIL.CDX" ) ADDITIVE

   DEFINE DIALOG oDlg RESOURCE "ASS_LIQAGE" TITLE "Asistente para importar pedidos"

   REDEFINE PAGES oPag ID 110 OF oDlg DIALOGS "IMPREC_1"

   REDEFINE LISTBOX oBrwPed ;
         FIELDS      (dbfPedT)->CSERPED + "/" + Str( (dbfPedT)->NNUMPED ) + "/" + (dbfPedT)->CSUFPED,;
                     Trans( (dbfPedT)->cTurPed, "######" ),;
                     Dtoc( (dbfPedT)->DFECPED ),;
                     (dbfPedT)->CCODCLI + Space(1) + (dbfPedT)->CNOMCLI,;
                     (dbfPedT)->cCodAge,;
                     (dbfPedT)->cCodRut,;
                     (dbfPedT)->cCodAlm,;
                     (dbfPedT)->cCodObr,;
                     hBmpDiv( (dbfPedT)->CDIVPED, dbfDiv, oBandera ),;
                     nTotPedCli( (dbfPedT)->CSERPED + Str( (dbfPedT)->NNUMPED ) + (dbfPedT)->CSUFPED, dbfPedT, dbfPedL, dbfIva, dbfDiv, dbfFPago, nil, cDivEmp(), .t. ) ;
         HEAD        "N�mero",;
                     "Sesi�n",;
                     "Fecha",;
                     "Cliente",;
                     "Agente" ,;
                     "Ruta" ,;
                     "Almacen",;
                     "Direcci�n" ,;
                     "Div.",;
                     "Importe " + cDivEmp();
         FIELDSIZES  80,;
                     40,;
                     80,;
                     220,;
                     80,;
                     80,;
                     80,;
                     80,;
                     25,;
                     100 ;
         ID          100 ;
         ALIAS       ( dbfPedT ) ;
         OF          oPag:aDialogs[ 1 ]

         oBrwPed:aJustify  := {  .f., .t., .f., .f., .f., .f., .f., .f., .f., .t. }


   REDEFINE BUTTON oBtnPrv ;                          // Boton de Anterior
         ID          401 ;
         OF          oDlg ;
         ACTION      ( IntBtnPrv( oPag, oBtnPrv, oBtnNxt, oDlg, oBrwPed, dbfEmp ) )

   REDEFINE BUTTON oBtnNxt ;                          // Boton de Siguiente
         ID          402 ;
         OF          oDlg ;
         ACTION      ( IntBtnNxt( oPag, oBtnPrv, oBtnNxt, oDlg, oBrwPed, dbfEmp ) )

   REDEFINE BUTTON ;                                  // Boton de salida
         ID          403 ;
         OF          oDlg ;
         ACTION      ( oDlg:end() )

   ACTIVATE DIALOG oDlg CENTER ON INIT ( oBtnPrv:Hide() )

   CLOSE ( dbfPedT )
   CLOSE ( dbfPedL )

RETURN ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

static function IntBtnPrv( oPag, oBtnPrv, oBtnNxt, oDlg, oBrw, dbfEmp )

return nil

//---------------------------------------------------------------------------//

static function IntBtnNxt( oPag, oBtnPrv, oBtnNxt, oDlg, oBrw, dbfEmp )

   local nNumPed
   local cSerPed     := "A"
   local aTabla

   MsgGet( "Seleccione", "Serie destino :", @cSerPed )

   nNumPed           := nNewDoc( cSerPed, TDataView():PedidosClientes( nView ), "NPEDCLI" )

   aTabla            := DBScatter( dbfPedT )
   aTabla[_CSERPED]  := cSerPed
   aTabla[_NNUMPED]  := nNumPed
   ( TDataView():PedidosClientes( nView ) )->( dbAppend() )
   dbGather( aTabla, TDataView():PedidosClientes( nView ) )

   if ( dbfPedL )->( dbSeek( ( dbfPedT )->CSERPED + Str( ( dbfPedT )->NNUMPED ) + ( dbfPedT )->CSUFPED ) )

      while ( dbfPedL )->CSERPED + Str( ( dbfPedL )->NNUMPED ) + ( dbfPedL )->CSUFPED == ( dbfPedT )->CSERPED + Str( ( dbfPedT )->NNUMPED ) + ( dbfPedT )->CSUFPED .and. !( dbfPedL )->( eof() )

         aTabla            := DBScatter( dbfPedL )
         aTabla[_CSERPED]  := cSerPed
         aTabla[_NNUMPED]  := nNumPed

         ( dbfPedCliL )->( dbAppend() )
         dbGather( aTabla, dbfPedCliL )

         ( dbfPedL )->( dbSkip() )

      end while

   end if

   msginfo( nNumPed, "Nuevo pedido importado" )

   oDlg:End()

return nil

//---------------------------------------------------------------------------//
*/

STATIC FUNCTION RecPedCli( aTmpPed )

   local nDtoAge
   local nImpAtp  := 0
   local nImpOfe  := 0
   local nRecno
   local cCodFam
   local hAtipica

   if !ApoloMsgNoYes(   "�Atenci�n!,"                                      + CRLF + ;
                        "todos los precios se recalcular�n en funci�n de"  + CRLF + ;
                        "los valores en las bases de datos.",;
                        "�Desea proceder?" )
      return nil
   end if

   nRecno         := ( dbfTmpLin )->( RecNo() )

   ( dbfArticulo )->( ordSetFocus( "Codigo" ) )

   ( dbfTmpLin )->( dbGotop() )
   while !( dbfTmpLin )->( eof() )

      /*
      Ahora buscamos por el codigo interno
      */

      if ( dbfArticulo )->( dbSeek( ( dbfTmpLin )->cRef ) )

         if aTmpPed[ _NREGIVA ] <= 1
            ( dbfTmpLin )->nIva     := nIva( dbfIva, ( dbfArticulo )->TipoIva )
            ( dbfTmpLin )->nReq     := nReq( dbfIva, ( dbfArticulo )->TipoIva )
         end if

         /*
         Ahora recogemos el impuesto especial si lo hay
         */

         if !Empty( ( dbfArticulo )->cCodImp )
            ( dbfTmpLin )->cCodImp  := ( dbfArticulo )->cCodImp
            ( dbfTmpLin )->nValImp  := oNewImp:nValImp( ( dbfArticulo )->cCodImp, aTmpPed[ _LIVAINC ], ( dbfTmpLin )->nIva )
         end if

         /*
         Ahora recogemos el impuesto especial si lo hay
         */

         if !Empty( ( dbfArticulo )->cCodImp )
            ( dbfTmpLin )->cCodImp  := ( dbfArticulo )->cCodImp
            ( dbfTmpLin )->nValImp  := oNewImp:nValImp( ( dbfArticulo )->cCodImp )
         end if

         /*
         Tomamos los precios de la base de datos de articulos---------------------
         */

         ( dbfTmpLin )->nPreDiv  := nRetPreArt( ( dbfTmpLin )->nTarLin, aTmpPed[ _CDIVPED ], aTmpPed[ _LIVAINC ], dbfArticulo, dbfDiv, dbfKit, dbfIva )

         /*
         Linea por contadores-----------------------------------------------------
         */

         ( dbfTmpLin )->nPvpRec  := ( dbfArticulo )->PvpRec
         ( dbfTmpLin )->nCosDiv  := nCosto( nil, dbfArticulo, dbfKit )

         /*
         Punto verde--------------------------------------------------------------
         */

         ( dbfTmpLin )->nPntVer  := ( dbfArticulo )->nPntVer1

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
            Descuento de promoci�n, esta funci�n comprueba si existe y si es
            asi devuelve el descunto de la promoci�n.
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
   local nOrdAnt  := ( dbfPedPrvT )->( OrdSetFocus( "CPEDCLI" ) )
   local nOrdAnt2 := ( dbfPedPrvL )->( OrdSetFocus( "NNUMPED" ) )

   ( dbfPedPrvT )->( dbGoTop() )

   if (dbfPedPrvT)->( dbSeek( cSerie + Str( nNumero ) + cSufijo ) )

      while ( dbfPedPrvT )->cNumPedCli == cSerie + Str( nNumero ) + cSufijo .and.;
            !( dbfPedPrvT )->( eof() )

          if ( dbfPedPrvL )->( dbSeek( ( dbfPedPrvT )->cSerPed + Str( ( dbfPedPrvT )->nNumPed ) + ( dbfPedPrvT )->cSufPed ) )

          while ( dbfPedPrvT )->cSerPed + str( ( dbfPedPrvT )->nNumPed ) + ( dbfPedPrvT )->cSufPed == ( dbfPedPrvL )->cSerPed + str( ( dbfPedPrvL )->nNumPed ) + ( dbfPedPrvL )->cSufPed .and.;
                !( dbfPedPrvL )->( eof() )

                  if ( dbfPedPrvL )->cRef + ( dbfPedPrvL )->cCodPr1 + ( dbfPedPrvL )->cCodPr2 + ( dbfPedPrvL )->cDetalle == cCodArt + cCodPr1 + cCodPr2 + cDetalle
                     lCheck   := .f.
                  end if

                  ( dbfPedPrvL )->( dbSkip() )

              end while

          end if

          ( dbfPedPrvT )->( dbSkip() )

      end while

   end if

   ( dbfPedPrvT )->( OrdSetFocus( nOrdAnt ) )
   ( dbfPedPrvL )->( OrdSetFocus( nOrdAnt2 ) )
   ( dbfPedPrvT )->( dbGoTop() )

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
   Comprobamos que no est� vac�o el art�culo
   */

   if Empty( cCodArt )
      MsgInfo( "Debe seleccinar un art�culo", "C�digo vac�o" )
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

Static Function PedCliNotas()

   local cObserv  := ""
   local aData    := {}

   aAdd( aData, "Pedido " + ( TDataView():PedidosClientes( nView ) )->cSerPed + "/" + AllTrim( Str( ( TDataView():PedidosClientes( nView ) )->nNumPed ) ) + "/" + Alltrim( ( TDataView():PedidosClientes( nView ) )->cSufPed ) + " de " + Rtrim( ( TDataView():PedidosClientes( nView ) )->cNomCli ) )
   aAdd( aData, PED_CLI )
   aAdd( aData, ( TDataView():PedidosClientes( nView ) )->cCodCli )
   aAdd( aData, ( TDataView():PedidosClientes( nView ) )->cNomCli )
   aAdd( aData, ( TDataView():PedidosClientes( nView ) )->cSerPed + Str( ( TDataView():PedidosClientes( nView ) )->nNumPed ) + ( TDataView():PedidosClientes( nView ) )->cSufPed )

   if ( TDataView():Clientes( nView ) )->( dbSeek( ( TDataView():PedidosClientes( nView ) )->cCodCli ) )

      if !Empty( ( TDataView():Clientes( nView ) )->cPerCto )
         cObserv  += Rtrim( ( TDataView():Clientes( nView ) )->cPerCto ) + Space( 1 )
      end if

      if !Empty( ( TDataView():Clientes( nView ) )->Telefono )
         cObserv  += "T�lefono : " + Rtrim( ( TDataView():Clientes( nView ) )->Telefono ) + Space( 1 )
      end if

      if !Empty( ( TDataView():Clientes( nView ) )->Movil )
         cObserv  += "M�vil : " + Rtrim( ( TDataView():Clientes( nView ) )->Movil ) + Space( 1 )
      end if

      if !Empty( ( TDataView():Clientes( nView ) )->Fax )
         cObserv  += "Fax : " + Rtrim( ( TDataView():Clientes( nView ) )->Fax ) + Space( 1 )
      end if

   end if

   aAdd( aData, cObserv )

   GenerarNotas( aData )

Return ( nil )

//---------------------------------------------------------------------------//
/*Esta funcion se usa para lanzar el di�logo para imprimir o visualizar las entregas a cuenta*/

STATIC FUNCTION PrnEntregas( lPrint, dbfPedCliP )

	local oDlg
   local oFmtEnt
   local cFmtEnt     := cFormatoDocumento(   nil, "NENTPED", dbfCount )
   local oSayEnt
   local cSayEnt
   local aPrinters   := GetPrinters()
   local cPrinter    := PrnGetName()
   local oPrinter
   local oCopPrn
   local nCopPrn     := nCopiasDocumento(    nil, "NENTPED", dbfCount )

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
      ACTION   ( GenPrnEntregas( lPrint, cFmtEnt, cPrinter, if( lPrint, nCopPrn, 1 ), dbfPedCliP ), oDlg:End( IDOK ) )

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

static function GenPrnEntregas( lPrint, cFmtEnt, cPrinter, nCopies, dbfPedCliP )

   local n              := 1
   local oInf
   local oDevice
   local cCaption       := 'Imprimiendo entrega a cuenta'
   local nRecno         := ( dbfPedCliP )->( Recno() )

   DEFAULT lPrint       := .t.
   DEFAULT nCopies      := 1

   if Empty( cFmtEnt )
      MsgStop( "Es necesario elegir un formato" )
      return nil
   end if

   if !lExisteDocumento( cFmtEnt, dbfDoc )
      return nil
   end if

   if lVisualDocumento( cFmtEnt, dbfDoc )

      PrintReportEntPedCli( if( lPrint, IS_PRINTER, IS_SCREEN ), nCopies, cPrinter, dbfDoc, dbfPedCliP )

   else

      private cDbf         := TDataView():PedidosClientes( nView )
      private cDbfEnt      := dbfPedCliP
      private cCliente     := TDataView():Clientes( nView )
      private cDbfCli      := TDataView():Clientes( nView )
      private cFPago       := dbfFPago
      private cDbfPgo      := dbfFPago
      private cDbfAge      := dbfAgent
      private cDbfDiv      := dbfDiv
      private cPorDivEnt   := cPorDiv( ( dbfPedCliP )->cDivPgo, dbfDiv )

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

         ( dbfPedCliP )->( dbGoTo( nRecno ) )

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
   local nRecno      := ( TDataView():PedidosClientes( nView ) )->( Recno() )
   local nOrdAnt     := ( TDataView():PedidosClientes( nView ) )->( OrdSetFocus( 1 ) )
   local oDesde      := TDesdeHasta():Init( ( TDataView():PedidosClientes( nView ) )->cSerPed, ( TDataView():PedidosClientes( nView ) )->nNumPed, ( TDataView():PedidosClientes( nView ) )->cSufPed, GetSysDate() )
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
      TOTAL    ( TDataView():PedidosClientes( nView ) )->( OrdKeyCount() ) ;
      OF       oDlg

      oDlg:AddFastKey( VK_F5, {|| DupStart( oDesde, oDlg, oBtnAceptar, oBtnCancel, oTxtDup, @lCancel, cFecDoc ) } )

   ACTIVATE DIALOG oDlg CENTER VALID ( lCancel )

   ( TDataView():PedidosClientes( nView ) )->( dbGoTo( nRecNo ) )
   ( TDataView():PedidosClientes( nView ) )->( ordSetFocus( nOrdAnt ) )

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

      nOrd              := ( TDataView():PedidosClientes( nView ) )->( OrdSetFocus( "nNumPed" ) )

      ( TDataView():PedidosClientes( nView ) )->( dbSeek( oDesde:cNumeroInicio(), .t. ) )

      while !lCancel .and. ( TDataView():PedidosClientes( nView ) )->( !eof() )

         if ( TDataView():PedidosClientes( nView ) )->cSerPed >= oDesde:cSerieInicio  .and.;
            ( TDataView():PedidosClientes( nView ) )->cSerPed <= oDesde:cSerieFin     .and.;
            ( TDataView():PedidosClientes( nView ) )->nNumPed >= oDesde:nNumeroInicio .and.;
            ( TDataView():PedidosClientes( nView ) )->nNumPed <= oDesde:nNumeroFin    .and.;
            ( TDataView():PedidosClientes( nView ) )->cSufPed >= oDesde:cSufijoInicio .and.;
            ( TDataView():PedidosClientes( nView ) )->cSufPed <= oDesde:cSufijoFin

            ++nDuplicados

            oTxtDup:cText  := "Duplicando : " + ( TDataView():PedidosClientes( nView ) )->cSerPed + "/" + Alltrim( Str( ( TDataView():PedidosClientes( nView ) )->nNumPed ) ) + "/" + ( TDataView():PedidosClientes( nView ) )->cSufPed

            DupPedido( cFecDoc )

         end if

         ( TDataView():PedidosClientes( nView ) )->( dbSkip() )

         ++nProcesed

         oTxtDup:Set( nProcesed )

      end do

      ( TDataView():PedidosClientes( nView ) )->( OrdSetFocus( nOrd ) )

   else

      nOrd              := ( TDataView():PedidosClientes( nView ) )->( OrdSetFocus( "dFecPed" ) )

      ( TDataView():PedidosClientes( nView ) )->( dbSeek( oDesde:dFechaInicio, .t. ) )

      while !lCancel .and. ( TDataView():PedidosClientes( nView ) )->( !eof() )

         if ( TDataView():PedidosClientes( nView ) )->dFecPed >= oDesde:dFechaInicio  .and.;
            ( TDataView():PedidosClientes( nView ) )->dFecPed <= oDesde:dFechaFin

            ++nDuplicados

            oTxtDup:cText  := "Duplicando : " + ( TDataView():PedidosClientes( nView ) )->cSerPed + "/" + Alltrim( Str( ( TDataView():PedidosClientes( nView ) )->nNumPed ) ) + "/" + ( TDataView():PedidosClientes( nView ) )->cSufPed

            DupPedido( cFecDoc )

         end if

         ( TDataView():PedidosClientes( nView ) )->( dbSkip() )

         ++nProcesed

         oTxtDup:Set( nProcesed )

      end do

      ( TDataView():PedidosClientes( nView ) )->( OrdSetFocus( nOrd ) )

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
      aTabla[ _CCODCAJ     ]  := oUser():cCaja()
      aTabla[ _DFECENT     ]  := Ctod("")
      aTabla[ _CNUMPRE     ]  := Space( 12 )
      aTabla[ _LSNDDOC     ]  := .t.
      aTabla[ _LCLOPED     ]  := .f.
      aTabla[ _CCODUSR     ]  := cCurUsr()
      aTabla[ _DFECCRE     ]  := GetSysDate()
      aTabla[ _CTIMCRE     ]  := Time()
      aTabla[ _LIMPRIMIDO  ]  := .f.
      aTabla[ _DFECIMP     ]  := Ctod("")
      aTabla[ _CHORIMP     ]  := Space( 5 )
      aTabla[ _CCODDLG     ]  := oUser():cDelegacion()
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

   nNewNumPed  := nNewDoc( ( TDataView():PedidosClientes( nView ) )->cSerPed, TDataView():PedidosClientes( nView ), "NPEDCLI", , dbfCount )

   //Duplicamos las cabeceras--------------------------------------------------

   PedRecDup( TDataView():PedidosClientes( nView ), ( TDataView():PedidosClientes( nView ) )->cSerPed, nNewNumPed, ( TDataView():PedidosClientes( nView ) )->cSufPed, .t., cFecDoc )

   //Duplicamos las lineas del documento---------------------------------------

   if ( dbfPedCliL )->( dbSeek( ( TDataView():PedidosClientes( nView ) )->cSerPed + Str( ( TDataView():PedidosClientes( nView ) )->nNumPed ) + ( TDataView():PedidosClientes( nView ) )->cSufPed ) )

      while ( TDataView():PedidosClientes( nView ) )->cSerPed + Str( ( TDataView():PedidosClientes( nView ) )->nNumPed ) + ( TDataView():PedidosClientes( nView ) )->cSufPed == ( dbfPedCliL )->cSerPed + Str( ( dbfPedCliL )->nNumPed ) + ( dbfPedCliL )->cSufPed .and. ;
            !( dbfPedCliL )->( Eof() )

            PedRecDup( dbfPedCliL, ( TDataView():PedidosClientes( nView ) )->cSerPed, nNewNumPed, ( TDataView():PedidosClientes( nView ) )->cSufPed, .f. )

         ( dbfPedCliL )->( dbSkip() )

      end while

   end if

   //Duplicamos los documentos-------------------------------------------------

   if ( dbfPedCliD )->( dbSeek( ( TDataView():PedidosClientes( nView ) )->cSerPed + Str( ( TDataView():PedidosClientes( nView ) )->nNumPed ) + ( TDataView():PedidosClientes( nView ) )->cSufPed ) )

      while ( TDataView():PedidosClientes( nView ) )->cSerPed + Str( ( TDataView():PedidosClientes( nView ) )->nNumPed ) + ( TDataView():PedidosClientes( nView ) )->cSufPed == ( dbfPedCliD )->cSerPed + Str( ( dbfPedCliD )->nNumPed ) + ( dbfPedCliD )->cSufPed .and. ;
            !( dbfPedCliD )->( Eof() )

            PedRecDup( dbfPedCliD, ( TDataView():PedidosClientes( nView ) )->cSerPed, nNewNumPed, ( TDataView():PedidosClientes( nView ) )->cSufPed, .f. )

         ( dbfPedCliD )->( dbSkip() )

      end while

   end if

RETURN ( .t. )

//---------------------------------------------------------------------------//

STATIC FUNCTION SetDialog( aGet, oSayDias, oSayTxtDias, oSayGetRnt, oGetRnt )

   if oTipPed:nAt == 2
      aGet[ _DFECENTR ]:Show()
      aGet[ _DFECSAL ]:Show()
      oSayDias:Show()
      oSayTxtDias:Show()
      aGet[ _NESTADO ]:Hide()
   else
      aGet[ _DFECENTR ]:Hide()
      aGet[ _DFECSAL ]:Hide()
      oSayDias:Hide()
      oSayTxtDias:Hide()
      aGet[ _NESTADO ]:Show()
   end if

   aGet[ _DFECENTR ]:Refresh()
   aGet[ _DFECSAL ]:Refresh()
   oSayDias:Refresh()
   oSayTxtDias:Refresh()
   aGet[ _NESTADO ]:Refresh()

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

STATIC FUNCTION ValidaMedicion( aTmp, aGet )

   local cNewUndMed  := aGet[ _CUNIDAD ]:VarGet

   /*
   Cargamos el codigo de las unidades---------------------------------
   */

   if ( Empty( cOldUndMed ) .or. cOldUndMed != cNewUndMed )

      if oUndMedicion:oDbf:Seek( aTmp[ _CUNIDAD ] )

         if oUndMedicion:oDbf:nDimension >= 1 .and. !Empty( oUndMedicion:oDbf:cTextoDim1 )
            if !Empty( aGet[ ( dbfPedCliL )->( fieldpos( "nMedUno" ) ) ] )
               aGet[ ( dbfPedCliL )->( fieldpos( "nMedUno" ) ) ]:oSay:SetText( oUndMedicion:oDbf:cTextoDim1 )
               aGet[ ( dbfPedCliL )->( fieldpos( "nMedUno" ) ) ]:cText( ( dbfArticulo )->nLngArt )
               aGet[ ( dbfPedCliL )->( fieldpos( "nMedUno" ) ) ]:Show()
            else
               aTmp[ ( dbfPedCliL )->( fieldpos( "nMedUno" ) ) ]  := ( dbfArticulo )->nLngArt
            end if
         else
            if !Empty( aGet[ ( dbfPedCliL )->( fieldpos( "nMedUno" ) ) ] )
               aGet[ ( dbfPedCliL )->( fieldpos( "nMedUno" ) ) ]:cText( 0 )
               aGet[ ( dbfPedCliL )->( fieldpos( "nMedUno" ) ) ]:Hide()
            else
               aTmp[ ( dbfPedCliL )->( fieldpos( "nMedUno" ) ) ]  := 0
            end if
         end if

         if oUndMedicion:oDbf:nDimension >= 2 .and. !Empty( oUndMedicion:oDbf:cTextoDim2 )
            if !Empty( aGet[ ( dbfPedCliL )->( fieldpos( "nMedDos" ) ) ] )
               aGet[ ( dbfPedCliL )->( fieldpos( "nMedDos" ) ) ]:oSay:SetText( oUndMedicion:oDbf:cTextoDim2 )
               aGet[ ( dbfPedCliL )->( fieldpos( "nMedDos" ) ) ]:cText( ( dbfArticulo )->nAltArt )
               aGet[ ( dbfPedCliL )->( fieldpos( "nMedDos" ) ) ]:Show()
            else
               aTmp[ ( dbfPedCliL )->( fieldpos( "nMedDos" ) ) ]  := ( dbfArticulo )->nAltArt
            end if

         else
            if !Empty( aGet[ ( dbfPedCliL )->( fieldpos( "nMedDos" ) ) ] )
               aGet[ ( dbfPedCliL )->( fieldpos( "nMedDos" ) ) ]:cText( 0 )
               aGet[ ( dbfPedCliL )->( fieldpos( "nMedDos" ) ) ]:Hide()
            else
                 aTmp[ ( dbfPedCliL )->( fieldpos( "nMedDos" ) ) ]  := 0
            end if
         end if

         if oUndMedicion:oDbf:nDimension >= 3 .and. !Empty( oUndMedicion:oDbf:cTextoDim3 )
            if !Empty( aGet[ ( dbfPedCliL )->( fieldpos( "nMedTre" ) ) ] )
               aGet[ ( dbfPedCliL )->( fieldpos( "nMedTre" ) ) ]:oSay:SetText( oUndMedicion:oDbf:cTextoDim3 )
               aGet[ ( dbfPedCliL )->( fieldpos( "nMedTre" ) ) ]:cText( ( dbfArticulo ) ->nAncArt )
               aGet[ ( dbfPedCliL )->( fieldpos( "nMedTre" ) ) ]:Show()
            else
               aTmp[ ( dbfPedCliL )->( fieldpos( "nMedTre" ) ) ]  := ( dbfArticulo )->nAncArt
            end if
         else
            if !Empty( aGet[ ( dbfPedCliL )->( fieldpos( "nMedTre" ) ) ] )
               aGet[ ( dbfPedCliL )->( fieldpos( "nMedTre" ) ) ]:cText( 0 )
               aGet[ ( dbfPedCliL )->( fieldpos( "nMedTre" ) ) ]:Hide()
            else
               aTmp[ ( dbfPedCliL )->( fieldpos( "nMedTre" ) ) ]  := 0
            end if
         end if

      else

         if !Empty( aGet[ ( dbfPedCliL )->( fieldpos( "nMedUno" ) ) ] )
            aGet[ ( dbfPedCliL )->( fieldpos( "nMedUno" ) ) ]:Hide()
            aGet[ ( dbfPedCliL )->( fieldpos( "nMedUno" ) ) ]:cText( 0 )
         end if

         if !Empty( aGet[ ( dbfPedCliL )->( fieldpos( "nMedDos" ) ) ] )
            aGet[ ( dbfPedCliL )->( fieldpos( "nMedDos" ) ) ]:Hide()
            aGet[ ( dbfPedCliL )->( fieldpos( "nMedDos" ) ) ]:cText( 0 )
         end if

         if !Empty( aGet[ ( dbfPedCliL )->( fieldpos( "nMedTre" ) ) ] )
            aGet[ ( dbfPedCliL )->( fieldpos( "nMedTre" ) ) ]:Hide()
            aGet[ ( dbfPedCliL )->( fieldpos( "nMedTre" ) ) ]:cText( 0 )
         end if

      end if

      cOldUndMed := cNewUndMed

   end if

RETURN .t.

//-----------------------------------------------------------------------------

Static Function ChangeTarifa( aTmp, aGet, aTmpPed )

    local nPrePro  := 0

   if !aTmp[ __LALQUILER ]

      nPrePro     := nPrePro( aTmp[ _CREF ], aTmp[ _CCODPR1 ], aTmp[ _CVALPR1 ], aTmp[ _CCODPR2 ], aTmp[ _CVALPR2 ], aTmp[ _NTARLIN ], aTmpPed[ _LIVAINC ], dbfArtDiv, aTmpPed[ _CCODTAR ] )

      if nPrePro == 0
         nPrePro  := nRetPreArt( aTmp[ _NTARLIN ], aTmpPed[ _CDIVPED ], aTmpPed[ _LIVAINC ], dbfArticulo, dbfDiv, dbfKit, dbfIva )
      end if

      if nPrePro != 0
         aGet[ _NPREDIV ]:cText( nPrePro )
      end if

   else

      aGet[ _NPREDIV ]:cText( 0 )

      nPrePro := nPreAlq( aTmp[ _CREF ], aTmp[ _NTARLIN ], aTmpPed[ _LIVAINC ], dbfArticulo )

      if nPrePro != 0
         aGet[ _NPREALQ ]:cText( nPrePro )
      end if

   end if

return .t.

//---------------------------------------------------------------------------//

CLASS TPedidosClientes2PedidosProveedor

   DATA cSerie
   DATA nNumero
   DATA cSufijo

   DATA oDlg
   DATA oPag
   DATA oBmp

   DATA oBtnPrev
   DATA oBtnNext

   DATA oMtr
   DATA nMtr

   DATA cProveedorDesde
   DATA cProveedorHasta
   DATA oProveedorDesde
   DATA oProveedorHasta
   DATA oSayProveedorDesde
   DATA oSayProveedorHasta
   DATA cSayProveedorDesde
   DATA cSayProveedorHasta

   DATA oArticuloDesde
   DATA oArticuloHasta
   DATA oCodigoAlmacen
   DATA oNombreAlmacen
   DATA oSayArticuloDesde
   DATA oSayArticuloHasta

   DATA cArticuloDesde
   DATA cArticuloHasta
   DATA cSayArticuloDesde
   DATA cSayArticuloHasta
   DATA cCodigoAlmacen
   DATA cNombreAlmacen

   DATA oStock
   DATA nStockDisponible
   DATA nStockFin

   DATA oBrw
   DATA oBrwFin

   DATA oDlgEditLine
   DATA oGetProveedor
   DATA oGetArticulo

   DATA oGetValorPropiedad1
   DATA oGetValorPropiedad2

   DATA oGetCajas
   DATA oGetUnidades

   DATA oGetMedUno
   DATA oGetMedDos
   DATA oGetMedTre

   Method New()

   Method CreateLines()

   Method DestroyLines()

   Method Dialog()

   Method Next()

   Method Prev()

   Method CreaPedidoProveedor()

   Method Select()

   Method SelectArticulo()

   Method SelectAllArticulo( lSel )

   Method EditLine()

   Method StartEditLine()

END CLASS

//----------------------------------------------------------------------------//

Method New( cSerie, nNumero, cSufijo, oStock ) CLASS TPedidosClientes2PedidosProveedor

   ::cSerie                := cSerie
   ::nNumero               := nNumero
   ::cSufijo               := cSufijo

   ::cSayProveedorDesde    := dbFirst( dbfPrv, 2 )
   ::cSayProveedorHasta    := dbLast ( dbfPrv, 2 )
   ::cProveedorDesde       := dbFirst( dbfPrv, 1 )
   ::cProveedorHasta       := dbLast ( dbfPrv, 1 )

   ::cCodigoAlmacen        := dbFirst( dbfAlm, 1 )

   ::cNombreAlmacen        := dbFirst( dbfAlm, 2 )

   ::oStock                := oStock
   ::nStockDisponible      := 4
   ::nStockFin             := 3

Return ( Self )

//----------------------------------------------------------------------------//

Method Dialog() CLASS TPedidosClientes2PedidosProveedor

   if !::CreateLines()
   	Return .f.
   end if 

   /*
   Dialogo---------------------------------------------------------------------
   */

   DEFINE DIALOG ::oDlg RESOURCE "ASS_PEDCLI"

      REDEFINE BITMAP ::oBmp ;
         RESOURCE "GenerarPedidoProveedor" ;
         ID       500 ;
         OF       ::oDlg

      REDEFINE PAGES ::oPag ;
         ID       110 ;
         OF       ::oDlg ;
         DIALOGS  "ASS_PEDCLI1",;
                  "ASS_PEDCLI2",;
                  "ASS_PEDCLI3"

      REDEFINE GET ::oProveedorDesde VAR ::cProveedorDesde ;
         ID       110;
         BITMAP   "LUPA" ;
         OF       ::oPag:aDialogs[1]

      ::oProveedorDesde:bValid   := {|| cProvee( ::oProveedorDesde, dbfPrv, ::oSayProveedorDesde ) }
      ::oProveedorDesde:bHelp    := {|| BrwProvee( ::oProveedorDesde, ::oSayProveedorDesde ) }

      REDEFINE GET ::oSayProveedorDesde VAR ::cSayProveedorDesde ;
         ID       120;
         WHEN     .f.;
         OF       ::oPag:aDialogs[1]

      REDEFINE GET ::oProveedorHasta VAR ::cProveedorHasta ;
         ID       130;
         BITMAP   "LUPA" ;
         OF       ::oPag:aDialogs[1]

      ::oProveedorHasta:bValid   := {|| cProvee( ::oProveedorHasta, dbfPrv, ::oSayProveedorHasta ) }
      ::oProveedorHasta:bHelp    := {|| BrwProvee( ::oProveedorHasta, ::oSayProveedorHasta ) }

      REDEFINE GET ::oSayProveedorHasta VAR ::cSayProveedorHasta ;
         ID       140;
         WHEN     .f.;
         OF       ::oPag:aDialogs[1]

      REDEFINE GET ::oArticuloDesde VAR ::cArticuloDesde ;
         ID       150 ;
         BITMAP   "LUPA" ;
         OF       ::oPag:aDialogs[1]

      ::oArticuloDesde:bValid := {|| cArticulo( ::oArticuloDesde, dbfArticulo, ::oSayArticuloDesde ) }
      ::oArticuloDesde:bHelp  := {|| brwArtPed( ::oArticuloDesde, dbfTmpPedLin, dbfDiv, dbfIva ) }

      REDEFINE GET ::oSayArticuloDesde VAR ::cSayArticuloDesde ;
         WHEN     .f.;
         ID       160 ;
         OF       ::oPag:aDialogs[1]

      REDEFINE GET ::oArticuloHasta VAR ::cArticuloHasta ;
         ID       170 ;
         BITMAP   "LUPA" ;
         OF       ::oPag:aDialogs[1]

      ::oArticuloHasta:bValid := {|| cArticulo( ::oArticuloHasta, dbfArticulo, ::oSayArticuloHasta ) }
      ::oArticuloHasta:bHelp  := {|| brwArtPed( ::oArticuloHasta, dbfTmpPedLin, dbfDiv, dbfIva ) }

      REDEFINE GET ::oSayArticuloHasta VAR ::cSayArticuloHasta ;
         WHEN     .f.;
         ID       180 ;
         OF       ::oPag:aDialogs[1]

      REDEFINE GET ::oCodigoAlmacen VAR ::cCodigoAlmacen ;
         ID       190 ;
         BITMAP   "LUPA" ;
         OF       ::oPag:aDialogs[1]

     ::oCodigoAlmacen:bValid  := {|| cAlmacen( ::oCodigoAlmacen, , ::oNombreAlmacen ) }
     ::oCodigoAlmacen:bHelp   := {|| BrwAlmacen( ::oCodigoAlmacen, ::oNombreAlmacen ) }

      REDEFINE GET ::oNombreAlmacen VAR ::cNombreAlmacen ;
         WHEN     .f. ;
         ID       200 ;
         OF       ::oPag:aDialogs[1]

      REDEFINE RADIO ::nStockDisponible ;
         ID       201, 202, 203, 204 ;
         OF       ::oPag:aDialogs[1]

      REDEFINE RADIO ::nStockFin ;
         ID       212, 213, 214 ;
         OF       ::oPag:aDialogs[1]

	REDEFINE APOLOMETER ::oMtr VAR ::nMtr ;
         PROMPT   "Procesando" ;
         ID       220 ;
         TOTAL    ( dbfTmpPedLin )->( LastRec() ) ;
         OF       ::oPag:aDialogs[1]

      ::oBrw               := IXBrowse():New( ::oPag:aDialogs[2] )

      ::oBrw:bClrSel       := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      ::oBrw:bClrSelFocus  := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      ::oBrw:cAlias        := dbfTmpPedLin

      ::oBrw:nMarqueeStyle := 5
      ::oBrw:cName         := "Pedido de cliente.Generar"

      ::oBrw:bLDblClick    := {|| ::EditLine() }

      ::oBrw:CreateFromResource( 100 )

      with object ( ::oBrw:AddCol() )
         :cHeader          := "Se. Seleccionado"
         :bStrData         := {|| "" }
         :bEditValue       := {|| ( dbfTmpPedLin )->lSelArt }
         :nWidth           := 20
         :SetCheck( { "Sel16", "Cnt16" } )
      end with

      with object ( ::oBrw:AddCol() )
         :cHeader          := "Proveedor"
         :bEditValue       := {|| AllTrim( ( dbfTmpPedLin )->cCodPrv ) + " - " + AllTrim( RetProvee( ( dbfTmpPedLin )->cCodPrv ) ) }
         :nWidth           := 200
      end with

      with object ( ::oBrw:AddCol() )
         :cHeader          := "C�digo"
         :bEditValue       := {|| ( dbfTmpPedLin )->cRef }
         :nWidth           := 70
      end with

      with object ( ::oBrw:AddCol() )
         :cHeader          := "Nombre"
         :bEditValue       := {|| if( !Empty( ( dbfTmpPedLin )->cRef ), ( dbfTmpPedLin )->cDetalle, ( dbfTmpPedLin )->mLngDes ) }
         :nWidth           := 155
      end with

      with object ( ::oBrw:AddCol() )
         :cHeader          := "Propiedad 1"
         :bEditValue       := {|| ( dbfTmpPedLin )->cValPr1 }
         :nWidth           := 80
         :lHide            := .t.
      end with

      with object ( ::oBrw:AddCol() )
         :cHeader          := "Propiedad 2"
         :bEditValue       := {|| ( dbfTmpPedLin )->cValPr2 }
         :nWidth           := 80
         :lHide            := .t.
      end with

      with object ( ::oBrw:AddCol() )
         :cHeader          := cNombreCajas()
         :bEditValue       := {|| ( dbfTmpPedLin )->nNumCaj }
         :cEditPicture     := MasUnd()
         :nWidth           := 50
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      with object ( ::oBrw:AddCol() )
         :cHeader          := cNombreUnidades()
         :bEditValue       := {|| ( dbfTmpPedLin )->nNumUni }
         :cEditPicture     := MasUnd()
         :nWidth           := 60
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      with object ( ::oBrw:AddCol() )
         :cHeader          := "Stk. f�sico"
         :bEditValue       := {|| ( dbfTmpPedLin )->nStkFis }
         :cEditPicture     := MasUnd()
         :nWidth           := 60
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      with object ( ::oBrw:AddCol() )
         :cHeader          := "Stk. disponible"
         :bEditValue       := {|| ( dbfTmpPedLin )->nStkDis }
         :cEditPicture     := MasUnd()
         :nWidth           := 90
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      REDEFINE BUTTON ;
         ID       110;
         OF       ::oPag:aDialogs[2] ;
         ACTION   ( ::EditLine() )

      REDEFINE BUTTON ;
         ID       120;
         OF       ::oPag:aDialogs[2] ;
         ACTION   ( ::SelectArticulo() )

      REDEFINE BUTTON ;
         ID       130;
         OF       ::oPag:aDialogs[2] ;
         ACTION   ( ::SelectAllArticulo( .t. ) )

      REDEFINE BUTTON ;
         ID       140;
         OF       ::oPag:aDialogs[2] ;
         ACTION   ( ::SelectAllArticulo( .f. ) )

      ::oBrwFin                  := IXBrowse():New( ::oPag:aDialogs[3] )

      ::oBrwFin:bClrSel          := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      ::oBrwFin:bClrSelFocus     := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      ::oBrwFin:cAlias           := dbfTmpFin

      ::oBrwFin:nMarqueeStyle    := 5

      ::oBrwFin:bLDblClick       := {|| ZooPedPrv( ( dbfTmpFin )->cSerie + Str( ( dbfTmpFin )->nNumero ) + ( dbfTmpFin )->cSufijo ) }

      ::oBrwFin:CreateFromResource( 100 )

      with object ( ::oBrwFin:AddCol() )
         :cHeader                := "Documento"
         :bEditValue             := {|| AllTrim( ( dbfTmpFin )->cSerie ) + "/" + AllTrim( Str( ( dbfTmpFin )->nNumero ) ) + "/" + AllTrim( ( dbfTmpFin )->cSufijo ) }
         :nWidth                 := 80
      end with

      with object ( ::oBrwFin:AddCol() )
         :cHeader                := "Fecha"
         :bEditValue             := {|| dtoc( ( dbfTmpFin )->dFecDoc ) }
         :nWidth                 := 80
      end with

      with object ( ::oBrwFin:AddCol() )
         :cHeader                := "Proveedor"
         :bEditValue             := {|| AllTrim( ( dbfTmpFin )->cCodPrv ) + " - " + AllTrim( ( dbfTmpFin )->cNomPrv ) }
         :nWidth                 := 250
      end with

      with object ( ::oBrwFin:AddCol() )
         :cHeader                := "Total"
         :bEditValue             := {|| nTotPedPrv( ( dbfTmpFin )->cSerie + Str( ( dbfTmpFin )->nNumero ) + ( dbfTmpFin )->cSufijo, dbfPedPrvT, dbfPedPrvL, dbfIva, dbfDiv, nil, cDivEmp(), .t. ) }
         :nWidth                 := 80
         :nDataStrAlign          := 1
         :nHeadStrAlign          := 1
      end with

      REDEFINE BUTTON ;
         ID       110;
         OF       ::oPag:aDialogs[3] ;
         ACTION   ( EdtPedPrv( ( dbfTmpFin )->cSerie + Str( ( dbfTmpFin )->nNumero ) + ( dbfTmpFin )->cSufijo ), ::oBrwFin:Refresh() )

      REDEFINE BUTTON ;
         ID       120;
         OF       ::oPag:aDialogs[3] ;
         ACTION   ( ZooPedPrv( ( dbfTmpFin )->cSerie + Str( ( dbfTmpFin )->nNumero ) + ( dbfTmpFin )->cSufijo ) )

      REDEFINE BUTTON ;
         ID       130;
         OF       ::oPag:aDialogs[3] ;
         ACTION   (  DelPedPrv( ( dbfTmpFin )->cSerie + Str( ( dbfTmpFin )->nNumero ) + ( dbfTmpFin )->cSufijo ),;
                     if( dbLock( dbfTmpFin ), ( ( dbfTmpFin )->( dbDelete() ), ( dbfTmpFin )->( dbUnLock() ) ),;
                     ::oBrwFin:Referesh() ) )

      REDEFINE BUTTON ;
         ID       140;
         OF       ::oPag:aDialogs[3] ;
         ACTION   ( VisPedPrv( ( dbfTmpFin )->cSerie + Str( ( dbfTmpFin )->nNumero ) + ( dbfTmpFin )->cSufijo ) )

      REDEFINE BUTTON ;
         ID       150;
         OF       ::oPag:aDialogs[3] ;
         ACTION   ( PrnPedPrv( ( dbfTmpFin )->cSerie + Str( ( dbfTmpFin )->nNumero ) + ( dbfTmpFin )->cSufijo ) )

      REDEFINE BUTTON ::oBtnPrev ;
         ID       401 ;
         OF       ::oDlg;
         ACTION   ( ::Prev() )

      REDEFINE BUTTON ::oBtnNext ;
         ID       402 ;
         OF       ::oDlg;
         ACTION   ( ::Next() )

      REDEFINE BUTTON ;
         ID       403 ;
         OF       ::oDlg ;
         ACTION   ( ::DestroyLines() )

      ::oDlg:bStart  := {|| ::oBtnPrev:Hide(), ::oBrwFin:GoTop() }

   ACTIVATE DIALOG ::oDlg CENTER

   ::oBmp:End()

   if ( ::oDlg:nResult == IDOK )
		::oStock:SetGeneradoPedCli( ::cSerie + Str( ::nNumero ) + ::cSufijo )
   end if 

RETURN ( ::oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

Method CreateLines() CLASS TPedidosClientes2PedidosProveedor

   local oError
   local oBlock
   local cTmpLin
   local cTmpFin
   local lErrors  := .f.

   CursorWait()

   oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE
   
   cTmpLin        := cGetNewFileName( cPatTmp() + "PTmpCliL" )
   cTmpFin        := cGetNewFileName( cPatTmp() + "PTmpFinL" )

   dbCreate( cTmpLin, aSqlStruct( aColTmpLin() ), cLocalDriver() )

   dbUseArea( .t., cLocalDriver(), cTmpLin, cCheckArea( "PTmpCliL", @dbfTmpPedLin ), .f. )

   if !NetErr()
      ( dbfTmpPedLin )->( ordCondSet( "!Deleted()", {|| !Deleted() }  ) )
      ( dbfTmpPedLin )->( ordCreate( cTmpLin, "nNumLin", "Str( nNumLin, 4 )", {|| Str( Field->nNumLin, 4 ) } ) )

      ( dbfTmpPedLin )->( ordCondSet( "!Deleted()", {|| !Deleted() }  ) )
      ( dbfTmpPedLin )->( ordCreate( cTmpLin, "cRef", "cRef", {|| Field->cRef } ) )

      ( dbfTmpPedLin )->( ordCondSet( "!Deleted()", {|| !Deleted() }  ) )
      ( dbfTmpPedLin )->( ordCreate( cTmpLin, "lShow", "lShow", {|| Field->lShow } ) )

      ( dbfTmpPedLin )->( ordCondSet( "lShow .and. lSelArt .and. !Deleted()", {|| Field->lShow .and. Field->lSelArt .and. !Deleted() }  ) )
      ( dbfTmpPedLin )->( ordCreate( cTmpLin, "cCodPrv", "cCodPrv", {|| Field->cCodPrv } ) )
   else
      lErrors     := .t.
   end if

   dbCreate( cTmpFin, aSqlStruct( aColTmpFin() ), cLocalDriver() )

   dbUseArea( .t., cLocalDriver(), cTmpFin, cCheckArea( "PTmpFinL", @dbfTmpFin ), .f. )

   if !NetErr()
      ( dbfTmpFin )->( ordCondSet( "!Deleted()", {||!Deleted()}  ) )
      ( dbfTmpFin )->( ordCreate( cTmpFin, "cNumDoc", "cNumDoc", {|| Field->cSerie + str( Field->nNumero ) + Field->cSufijo } ) )
   else
      lErrors     := .t.
   end if

   if !lErrors

      ( dbfPedCliL )->( dbGoTop() )
      while !( dbfPedCliL )->( Eof() )

         if ( dbfPedCliL )->cSerPed + Str( ( dbfPedCliL )->nNumPed ) + ( dbfPedCliL )->cSufPed == ::cSerie + Str( ::nNumero ) + ::cSufijo .and. nTotNPedCli( dbfPedCliL ) != 0

            ( dbfTmpPedLin )->( dbAppend() )

            ( dbfTmpPedLin )->lShow    	:= .t.
            ( dbfTmpPedLin )->lSelArt  	:= .t.
            ( dbfTmpPedLin )->cRef     	:= ( dbfPedCliL )->cRef
            ( dbfTmpPedLin )->cDetalle 	:= ( dbfPedCliL )->cDetalle
            ( dbfTmpPedLin )->mLngDes 		:= ( dbfPedCliL )->mLngDes
            ( dbfTmpPedLin )->cCodPrv  	:= ( dbfPedCliL )->cCodPrv
            ( dbfTmpPedLin )->cCodPr1  	:= ( dbfPedCliL )->cCodPr1
            ( dbfTmpPedLin )->cCodPr2  	:= ( dbfPedCliL )->cCodPr2
            ( dbfTmpPedLin )->cValPr1  	:= ( dbfPedCliL )->cValPr1
            ( dbfTmpPedLin )->cValPr2  	:= ( dbfPedCliL )->cValPr2
            ( dbfTmpPedLin )->nNumUni  	:= ( dbfPedCliL )->nUniCaja
            ( dbfTmpPedLin )->nNumCaj  	:= ( dbfPedCliL )->nCanPed
            ( dbfTmpPedLin )->nStkFis  	:= oStock:nTotStockAct( ( dbfPedCliL )->cRef, , , , , RetFld( ( dbfPedCliL )->cRef, dbfArticulo, "lKitArt" ), RetFld( ( dbfPedCliL )->cRef, dbfArticulo, "nKitStk" ) )
            ( dbfTmpPedLin )->nStkDis  	:= oStock:nTotStockAct( ( dbfPedCliL )->cRef, , , , , RetFld( ( dbfPedCliL )->cRef, dbfArticulo, "lKitArt" ), RetFld( ( dbfPedCliL )->cRef, dbfArticulo, "nKitStk" ) ) - nTotReserva( ( dbfPedCliL )->cRef )
            ( dbfTmpPedLin )->nIva     	:= ( dbfPedCliL )->nIva
            ( dbfTmpPedLin )->nReq     	:= ( dbfPedCliL )->nReq
            ( dbfTmpPedLin )->nDto     	:= ( dbfPedCliL )->nDto
            ( dbfTmpPedLin )->nDtoPrm  	:= ( dbfPedCliL )->nDtoPrm
            ( dbfTmpPedLin )->cUniDad  	:= ( dbfPedCliL )->cUniDad
            ( dbfTmpPedLin )->lLote    	:= ( dbfPedCliL )->lLote
            ( dbfTmpPedLin )->nLote    	:= ( dbfPedCliL )->nLote
            ( dbfTmpPedLin )->cLote    	:= ( dbfPedCliL )->cLote
            ( dbfTmpPedLin )->mObsLin  	:= ( dbfPedCliL )->mObsLin
            ( dbfTmpPedLin )->cRefPrv  	:= ( dbfPedCliL )->cRefPrv
            ( dbfTmpPedLin )->cUnidad  	:= ( dbfPedCliL )->cUnidad
            ( dbfTmpPedLin )->nMedUno  	:= ( dbfPedCliL )->nMedUno
            ( dbfTmpPedLin )->nMedDos  	:= ( dbfPedCliL )->nMedDos
            ( dbfTmpPedLin )->nMedTre  	:= ( dbfPedCliL )->nMedTre
            ( dbfTmpPedLin )->nPreDiv  	:= nCosto( ( dbfPedCliL )->cRef, dbfArticulo, dbfKit, .f., , dbfDiv )

         end if

         ( dbfPedCliL )->( dbSkip() )

      end while

      ( dbfTmpPedLin )->( dbGoTop() )

	   ( dbfTmpPedLin )->( ordSetFocus( "cRef" ) )
	   ( dbfTmpPedLin )->( dbGoTop() )

   	::cArticuloDesde     					:= dbFirst( dbfTmpPedLin, 1 )
   	::cArticuloHasta     					:= dbLast ( dbfTmpPedLin, 1 )
   	::cSayArticuloDesde  					:= dbFirst( dbfTmpPedLin, 2 )
   	::cSayArticuloHasta  					:= dbLast ( dbfTmpPedLin, 2 )

   end if

   RECOVER USING oError

      lErrors     								:= .t.

      msgStop( "Imposible crear las bases de datos temporales" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   CursorWE()

Return ( !lErrors )

//---------------------------------------------------------------------------//

Method Prev() CLASS TPedidosClientes2PedidosProveedor

   do case
   case ::oPag:nOption == 2

      ( dbfTmpPedLin )->( OrdClearScope() )
      ( dbfTmpPedLin )->( OrdSetFocus( cOrdAnt ) )
      ( dbfTmpPedLin )->( dbGoTop() )

      while !( dbfTmpPedLin )->( eof() )

         if dbLock( dbfTmpPedLin )
            ( dbfTmpPedLin )->lShow := .f.
            ( dbfTmpPedLin )->( dbUnLock() )
         end if

         ( dbfTmpPedLin )->( dbSkip() )

      end while

      ::oPag:GoPrev()

      SetWindowText( ::oBtnNext:hWnd, "Siguien&te >" )

      ::oBtnPrev:Hide()

   case ::oPag:nOption == 3

      ::DestroyLines( .t. )

   end if

Return ( .t. )

//---------------------------------------------------------------------------//

Method Next() CLASS TPedidosClientes2PedidosProveedor

   do case
      case ::oPag:nOption == 1

         ::Select()

         ::oPag:GoNext()

         ::oBtnPrev:Show()

         SetWindowText( ::oBtnNext:hWnd, "&Procesar" )

      case ::oPag:nOption == 2

         ::CreaPedidoProveedor()

         ::oBrwFin:Refresh()

         ::oPag:GoNext()

         SetWindowText( ::oBtnPrev:hWnd, "Terminar e &imprimir" )

         SetWindowText( ::oBtnNext:hWnd, "&Terminar" )

      case ::oPag:nOption == 3

         ::DestroyLines()

   end case

Return ( .t. )

//---------------------------------------------------------------------------//

Method SelectArticulo() CLASS TPedidosClientes2PedidosProveedor

   if dbDialogLock( dbfTmpPedLin )
      ( dbfTmpPedLin )->lSelArt := !( dbfTmpPedLin )->lSelArt
      ( dbfTmpPedLin )->( dbUnlock() )
   end if

   ::oBrw:Refresh()

return nil

//---------------------------------------------------------------------------//

Method SelectAllArticulo( lSel ) CLASS TPedidosClientes2PedidosProveedor

   local nRec  := ( dbfTmpPedLin )->( Recno() )

   ( dbfTmpPedLin )->( dbGoTop() )
   while !( dbfTmpPedLin )->( eof() )

      if dbDialogLock( dbfTmpPedLin )
         ( dbfTmpPedLin )->lSelArt := lSel
         ( dbfTmpPedLin )->( dbUnlock() )
      end if

      ( dbfTmpPedLin )->( dbSkip() )
   
   end while

   ( dbfTmpPedLin )->( dbGoTo( nRec ) )

   ::oBrw:Refresh()

return nil

//---------------------------------------------------------------------------//

Method Select() CLASS TPedidosClientes2PedidosProveedor

   local nStk := 0

   ( dbfTmpPedLin )->( dbGoTop() )
   while !( dbfTmpPedLin )->( eof() )

      if ( Empty( ( dbfTmpPedLin )->cCodPrv ) .or. ( ( dbfTmpPedLin )->cCodPrv >= ::cProveedorDesde .and. ( dbfTmpPedLin )->cCodPrv <= ::cProveedorHasta ) ) .and.;
         ( ( dbfTmpPedLin )->cRef >= ::cArticuloDesde .and. ( dbfTmpPedLin )->cRef <= ::cArticuloHasta )

         nStk  := oStock:nTotStockAct( ( dbfTmpPedLin )->cRef, , , , , RetFld( ( dbfTmpPedLin )->cRef, dbfArticulo, "lKitArt" ), RetFld( ( dbfTmpPedLin )->cRef, dbfArticulo, "nKitStk" ) ) - nTotReserva( ( dbfTmpPedLin)->cRef )

         do case
            case ::nStockDisponible == 1 .and. nStk < 0

               if dbLock( dbfTmpPedLin )
                  ( dbfTmpPedLin )->lShow := lCheckGenerado( ::cSerie, ::nNumero, ::cSufijo, ( dbfTmpPedLin )->cRef, ( dbfTmpPedLin )->cCodPr1, ( dbfTmpPedLin )->cCodPr2, ( dbfTmpPedLin )->cDetalle )
                  ( dbfTmpPedLin )->( dbUnLock() )
               end if

            case ::nStockDisponible == 2 .and. nStk <= 0

               if dbLock( dbfTmpPedLin )
                  ( dbfTmpPedLin )->lShow := lCheckGenerado( ::cSerie, ::nNumero, ::cSufijo, ( dbfTmpPedLin )->cRef, ( dbfTmpPedLin )->cCodPr1, ( dbfTmpPedLin )->cCodPr2, ( dbfTmpPedLin )->cDetalle )
                  ( dbfTmpPedLin )->( dbUnLock() )
               end if

            case ::nStockDisponible == 3 .and. nStk < RetFld( ( dbfTmpPedLin )->cRef, dbfArticulo, "nMinimo" )

               if dbLock( dbfTmpPedLin )
                  ( dbfTmpPedLin )->lShow := lCheckGenerado( ::cSerie, ::nNumero, ::cSufijo, ( dbfTmpPedLin )->cRef, ( dbfTmpPedLin )->cCodPr1, ( dbfTmpPedLin )->cCodPr2, ( dbfTmpPedLin )->cDetalle )
                  ( dbfTmpPedLin )->( dbUnLock() )
               end if

            case ::nStockDisponible == 4

               if dbLock( dbfTmpPedLin )
                  ( dbfTmpPedLin )->lShow := lCheckGenerado( ::cSerie, ::nNumero, ::cSufijo, ( dbfTmpPedLin )->cRef, ( dbfTmpPedLin )->cCodPr1, ( dbfTmpPedLin )->cCodPr2, ( dbfTmpPedLin )->cDetalle )
                  ( dbfTmpPedLin )->( dbUnLock() )
               end if

          end case

      end if

      ( dbfTmpPedLin )->( dbSkip() )

      ::oMtr:Set( ( dbfTmpPedLin )->( OrdKeyNo() ) )

   end while

   ::oMtr:Set( ( dbfTmpPedLin )->( LastRec() ) )

   cOrdAnt := ( dbfTmpPedLin )->( OrdSetFocus( "lShow" ) )

   ( dbfTmpPedLin )->( OrdScope( 0, .t. ) )
   ( dbfTmpPedLin )->( OrdScope( 1, .t. ) )

   ( dbfTmpPedLin )->( dbGotop() )

return nil

//---------------------------------------------------------------------------//

Method CreaPedidoProveedor() CLASS TPedidosClientes2PedidosProveedor

   local cSeriePedido
   local nNumeroPedido
   local cSufijoPedido
   local cLastProveedor := ""

   ( dbfTmpPedLin )->( OrdSetFocus( "cCodPrv" ) )
   ( dbfTmpPedLin )->( dbGoTop() )

   while !( dbfTmpPedLin )->( eof() )

      if ( dbfPrv )->( dbSeek( ( dbfTmpPedLin )->cCodPrv ) )

         // Creo la cabecera del pedido a proveedor----------------------------

         if cLastProveedor != ( dbfTmpPedLin )->cCodPrv

            cSeriePedido               := cNewSer( "nPedPrv", dbfCount )
            nNumeroPedido              := nNewDoc( cSeriePedido, dbfPedPrvT, "nPedPrv", , dbfCount )
            cSufijoPedido              := RetSufEmp()

            ( dbfTmpFin )->( dbAppend() )
            ( dbfTmpFin )->cSerie      := cSeriePedido
            ( dbfTmpFin )->nNumero     := nNumeroPedido
            ( dbfTmpFin )->cSufijo     := cSufijoPedido
            ( dbfTmpFin )->dFecDoc     := GetSysDate()
            ( dbfTmpFin )->cCodPrv     := ( dbfTmpPedLin )->cCodPrv
            ( dbfTmpFin )->cNomPrv     := ( dbfPrv )->Titulo
            ( dbfTmpFin )->( dbRUnLock() )

            ( dbfPedPrvT )->( dbAppend() )
            ( dbfPedPrvT )->cSerPed    := cSeriePedido
            ( dbfPedPrvT )->nNumPed    := nNumeroPedido
            ( dbfPedPrvT )->cSufPed    := cSufijoPedido
            ( dbfPedPrvT )->cTurPed    := cCurSesion()
            ( dbfPedPrvT )->dFecPed    := GetSysDate()
            ( dbfPedPrvT )->cCodPrv    := ( dbfTmpPedLin )->cCodPrv
            ( dbfPedPrvT )->cCodAlm    := ::cCodigoAlmacen
            ( dbfPedPrvT )->cCodCaj    := oUser():cCaja()
            ( dbfPedPrvT )->cNomPrv    := ( dbfPrv )->Titulo
            ( dbfPedPrvT )->cDirPrv    := ( dbfPrv )->Domicilio
            ( dbfPedPrvT )->cPobPrv    := ( dbfPrv )->Poblacion
            ( dbfPedPrvT )->cProPrv    := ( dbfPrv )->Provincia
            ( dbfPedPrvT )->cPosPrv    := ( dbfPrv )->cCodPai
            ( dbfPedPrvT )->cDniPrv    := ( dbfPrv )->Nif
            ( dbfPedPrvT )->dFecEnt    := GetSysDate() + ( dbfPrv )->nPlzEnt
            ( dbfPedPrvT )->nEstado    := 1
            ( dbfPedPrvT )->cDivPed    := cDivEmp()
            ( dbfPedPrvT )->nVdvPed    := nChgDiv( ( dbfPedPrvT )->cDivPed, dbfDiv )
            ( dbfPedPrvT )->lSndDoc    := .t.
            ( dbfPedPrvT )->cCodUsr    := cCurUsr()
            ( dbfPedPrvT )->cNumPedCli := ::cSerie + Str( ::nNumero ) + ::cSufijo
            ( dbfPedPrvT )->lRecargo   := ( dbfPrv )->lReq
            ( dbfPedPrvT )->( dbRUnLock() )

            cLastProveedor             := ( dbfTmpPedLin )->cCodPrv

         end if

         /*
         Creo las lineas del pedido a proveedor--------------------------------
         */

         ( dbfPedPrvL )->( dbAppend() )

         ( dbfPedPrvL )->cSerPed          := cSeriePedido
         ( dbfPedPrvL )->nNumPed          := nNumeroPedido
         ( dbfPedPrvL )->cSufPed          := cSufijoPedido
         ( dbfPedPrvL )->cRef             := ( dbfTmpPedLin )->cRef
         ( dbfPedPrvL )->cDetalle         := ( dbfTmpPedLin )->cDetalle
		 ( dbfPedPrvL )->mLngDes          := ( dbfTmpPedLin )->mLngDes
         ( dbfPedPrvL )->nIva             := ( dbfTmpPedLin )->nIva
         ( dbfPedPrvL )->nReq             := ( dbfTmpPedLin )->nReq
         ( dbfPedPrvL )->cPedCli          := ::cSerie + Str( ::nNumero ) + ::cSufijo
         ( dbfPedPrvL )->cAlmLin          := ::cCodigoAlmacen
         ( dbfPedPrvL )->nCanPed          := ( dbfTmpPedLin )->nNumCaj
         ( dbfPedPrvL )->nPreDiv          := ( dbfTmpPedLin )->nPreDiv
         ( dbfPedPrvL )->cUniDad          := ( dbfTmpPedLin )->cUniDad
         ( dbfPedPrvL )->nDtoLin          := ( dbfTmpPedLin )->nDto
         ( dbfPedPrvL )->nDtoPrm          := ( dbfTmpPedLin )->nDtoPrm
         ( dbfPedPrvL )->cCodPr1          := ( dbfTmpPedLin )->cCodPr1
         ( dbfPedPrvL )->cCodPr2          := ( dbfTmpPedLin )->cCodPr2
         ( dbfPedPrvL )->cValPr1          := ( dbfTmpPedLin )->cValPr1
         ( dbfPedPrvL )->cValPr2          := ( dbfTmpPedLin )->cValPr2
         ( dbfPedPrvL )->lLote            := ( dbfTmpPedLin )->lLote
         ( dbfPedPrvL )->nLote            := ( dbfTmpPedLin )->nLote
         ( dbfPedPrvL )->cLote            := ( dbfTmpPedLin )->cLote
         ( dbfPedPrvL )->mObsLin          := ( dbfTmpPedLin )->mObsLin
         ( dbfPedPrvL )->cRefPrv          := ( dbfTmpPedLin )->cRefPrv
         ( dbfPedPrvL )->nMedUno          := ( dbfTmpPedLin )->nMedUno
         ( dbfPedPrvL )->nMedDos          := ( dbfTmpPedLin )->nMedDos
         ( dbfPedPrvL )->nMedTre          := ( dbfTmpPedLin )->nMedTre
         ( dbfPedPrvL )->cUnidad          := ( dbfTmpPedLin )->cUnidad

         do case
            case ::nStockFin == 1

               ( dbfPedPrvL )->nUniCaja   := Calculaunidades( ( dbfTmpPedLin )->nNumUni, ( dbfTmpPedLin )->nStkDis, RetFld( ( dbfTmpPedLin )->cRef, dbfArticulo, "nMinimo" ) )

            case ::nStockFin == 2

               ( dbfPedPrvL )->nUniCaja   := Calculaunidades( ( dbfTmpPedLin )->nNumUni, ( dbfTmpPedLin )->nStkDis, RetFld( ( dbfTmpPedLin )->cRef, dbfArticulo, "nMaximo" ) )

            case ::nStockFin == 3

               ( dbfPedPrvL )->nUniCaja   := ( dbfTmpPedLin )->nNumUni

         end case

         ( dbfPedPrvL )->( dbRUnLock() )

      end if

      ( dbfTmpPedLin )->( dbSkip() )

   end while

   ( dbfTmpFin )->( dbGoTop() )

return nil

//---------------------------------------------------------------------------//

Method DestroyLines( lPrint ) CLASS TPedidosClientes2PedidosProveedor

   DEFAULT lPrint    := .f.

   /*
   Impresi�n de pedidos de proveedor-------------------------------------------
	*/

   if lPrint

      ( dbfTmpFin )->( dbGoTop() )

      while !( dbfTmpFin )->( eof() )

         PrnPedPrv( ( dbfTmpFin )->cSerie + Str( ( dbfTmpFin )->nNumero ) + ( dbfTmpFin )->cSufijo )

         ( dbfTmpFin )->( dbSkip() )

      end while

   end if

	/*
   Cerramos los ficheros-------------------------------------------------------
	*/

   if !Empty( dbfTmpPedLin ) .and. ( dbfTmpPedLin )->( Used() )
      ( dbfTmpPedLin )->( dbCloseArea() )
   end if

   if !Empty( dbfTmpFin ) .and. ( dbfTmpFin )->( Used() )
      ( dbfTmpFin )->( dbCloseArea() )
   end if

   /*
   Eliminamos los temporales---------------------------------------------------
   */

   dbfErase( dbfTmpPedLin )
   dbfErase( dbfTmpFin    )

   ::oDlg:end()

Return .t.

//---------------------------------------------------------------------------//

Method EditLine() CLASS TPedidosClientes2PedidosProveedor

   local cPic     := MasUnd()
   local aTmp     := dbScatter( dbfTmpPedLin )

   DEFINE DIALOG ::oDlgEditLine RESOURCE "EdtPedPrv"

      REDEFINE CHECKBOX aTmp[ ( dbfTmpPedLin )->( FieldPos( "lSelArt" ) ) ] ;
         ID       100 ;
         OF       ::oDlgEditLine

      REDEFINE GET ::oGetProveedor VAR aTmp[ ( dbfTmpPedLin )->( FieldPos( "cCodPrv" ) ) ] ;
			ID 		110 ;
         IDTEXT   111 ;
         PICTURE  ( RetPicCodPrvEmp() ) ;
         BITMAP   "LUPA" ;
         OF       ::oDlgEditLine

      ::oGetProveedor:bValid  := {|| cProvee( ::oGetProveedor, dbfPrv, ::oGetProveedor:oHelpText ) }
      ::oGetProveedor:bHelp   := {|| brwProvee( ::oGetProveedor, ::oGetProveedor:oHelpText ) }

      REDEFINE GET ::oGetArticulo VAR aTmp[ ( dbfTmpPedLin )->( FieldPos( "cRef" ) ) ];
         ID       120 ;
         IDTEXT   121 ;
         BITMAP   "LUPA" ;
         WHEN     .f. ;
         OF       ::oDlgEditLine

      ::oGetArticulo:bValid   := {|| cArticulo( ::oGetArticulo, dbfArticulo, ::oGetArticulo:oHelpText ) }
      ::oGetArticulo:bHelp    := {|| brwArticulo( ::oGetArticulo, ::oGetArticulo:oHelpText ) }

      REDEFINE GET ::oGetValorPropiedad1 VAR aTmp[ ( dbfTmpPedLin )->( FieldPos( "cValPr1" ) ) ];
         ID       130 ;
         IDTEXT   131 ;
         IDSAY    132 ;
         BITMAP   "LUPA" ;
         WHEN     .f. ;
         OF       ::oDlgEditLine

      ::oGetValorPropiedad1:bValid  := {|| lPrpAct( ::oGetValorPropiedad1, ::oGetValorPropiedad1:oSay, aTmp[ ( dbfTmpPedLin )->( FieldPos( "cCodPr1" ) ) ], dbfTblPro ) }
      ::oGetValorPropiedad1:bHelp   := {|| brwPrpAct( ::oGetValorPropiedad1, ::oGetValorPropiedad1:oSay, aTmp[ ( dbfTmpPedLin )->( FieldPos( "cCodPr1" ) ) ], dbfTblPro ) }

      REDEFINE GET ::oGetValorPropiedad2 VAR aTmp[ ( dbfTmpPedLin )->( FieldPos( "cValPr2" ) ) ];
         ID       140 ;
         IDTEXT   141 ;
         IDSAY    142 ;
         BITMAP   "LUPA" ;
         WHEN     .f. ;
         OF       ::oDlgEditLine

      ::oGetValorPropiedad2:bValid  := {|| lPrpAct( ::oGetValorPropiedad2, ::oGetValorPropiedad2:oSay, aTmp[ ( dbfTmpPedLin )->( FieldPos( "cCodPr2" ) ) ], dbfTblPro ) }
      ::oGetValorPropiedad2:bHelp   := {|| brwPrpAct( ::oGetValorPropiedad2, ::oGetValorPropiedad2:oSay, aTmp[ ( dbfTmpPedLin )->( FieldPos( "cCodPr2" ) ) ], dbfTblPro ) }

      /*
      Cajas y unidades
      -------------------------------------------------------------------------
      */

      REDEFINE GET ::oGetCajas VAR aTmp[ ( dbfTmpPedLin )->( FieldPos( "nNumCaj" ) ) ];
         ID       150 ;
         IDSAY    151 ;
         SPINNER ;
         PICTURE  cPic ;
         OF       ::oDlgEditLine

      REDEFINE GET ::oGetUnidades VAR aTmp[ ( dbfTmpPedLin )->( FieldPos( "nNumUni" ) ) ];
         ID       160 ;
         IDSAY    161 ;
			SPINNER ;
         PICTURE  cPic ;
         OF       ::oDlgEditLine

      REDEFINE GET aTmp[ ( dbfTmpPedLin )->( FieldPos( "cUnidad" ) ) ];
         ID       210 ;
         WHEN     .f. ;
         OF       ::oDlgEditLine

      REDEFINE GET ::oGetMedUno VAR aTmp[ ( dbfTmpPedLin )->( fieldpos( "nMedUno" ) ) ] ;
         ID       170 ;
         IDSAY    171 ;
         SPINNER ;
         PICTURE  cPic ;
         OF       ::oDlgEditLine

      ::oGetMedUno:oSay:SetColor( CLR_BLUE )

      REDEFINE GET ::oGetMedDos VAR aTmp[ ( dbfTmpPedLin )->( fieldpos( "nMedDos" ) ) ] ;
         ID       180 ;
         IDSAY    181 ;
         SPINNER ;
         PICTURE  cPic ;
         OF       ::oDlgEditLine

      ::oGetMedDos:oSay:SetColor( CLR_BLUE )

      REDEFINE GET ::oGetMedTre VAR aTmp[ ( dbfTmpPedLin )->( fieldpos( "nMedTre" ) ) ] ;
         ID       190 ;
         IDSAY    191 ;
         SPINNER ;
         PICTURE  cPic ;
         OF       ::oDlgEditLine

      ::oGetMedTre:oSay:SetColor( CLR_BLUE )

      REDEFINE GET aTmp[ ( dbfTmpPedLin )->( fieldpos( "nStkFis" ) ) ] ;
         ID       220 ;
         WHEN     .f. ;
         PICTURE  cPouDiv ;
         OF       ::oDlgEditLine

      REDEFINE GET aTmp[ ( dbfTmpPedLin )->( fieldpos( "nStkDis" ) ) ] ;
         ID       230 ;
         WHEN     .f. ;
         PICTURE  cPouDiv ;
         OF       ::oDlgEditLine

      REDEFINE BUTTON ;
         ID       IDOK ;
         OF       ::oDlgEditLine ;
         ACTION   ( WinGather( aTmp, , dbfTmpPedLin, ::oBrw, EDIT_MODE ), ::oDlgEditLine:End() )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
         OF       ::oDlgEditLine ;
         CANCEL ;
         ACTION   ( ::oDlgEditLine:end() )

      ::oDlgEditLine:bStart   := {|| ::StartEditLine( aTmp ) }

   ACTIVATE DIALOG ::oDlgEditLine CENTER

   ::oBrw:CloseData()

RETURN ( Self )

//---------------------------------------------------------------------------//

Method StartEditLine( aTmp ) CLASS TPedidosClientes2PedidosProveedor

   ::oGetProveedor:lValid()
   ::oGetArticulo:lValid()

   if lUseCaj()
      ::oGetCajas:SetText( cNombreCajas() )
   else
      ::oGetCajas:Hide()
   end if

   ::oGetUnidades:SetText( cNombreUnidades() )

   // Propiedades--------------------------------------------------------------

   if !Empty( aTmp[ ( dbfTmpPedLin )->( FieldPos( "cCodPr1" ) ) ] )
      ::oGetValorPropiedad1:Show()
   else
      ::oGetValorPropiedad1:Hide()
   end if

   if !Empty( aTmp[ ( dbfTmpPedLin )->( FieldPos( "cCodPr2" ) ) ] )
      ::oGetValorPropiedad2:Show()
   else
      ::oGetValorPropiedad2:Hide()
   end if

   // Ocultamos las tres unidades de medicion----------------------------------

   ::oGetMedUno:Hide()
   ::oGetMedDos:Hide()
   ::oGetMedTre:Hide()

   if !Empty( aTmp[ ( dbfTmpPedLin )->( FieldPos( "cUnidad" ) ) ] ) .and. oUndMedicion:oDbf:Seek( aTmp[ ( dbfTmpPedLin )->( FieldPos( "cUnidad" ) ) ] )

      if oUndMedicion:oDbf:nDimension >= 1 .and. !Empty( oUndMedicion:oDbf:cTextoDim1 )
         ::oGetMedUno:oSay:SetText( oUndMedicion:oDbf:cTextoDim1 )
         ::oGetMedUno:Show()
      end if

      if oUndMedicion:oDbf:nDimension >= 2 .and. !Empty( oUndMedicion:oDbf:cTextoDim2 )
         ::oGetMedDos:oSay:SetText( oUndMedicion:oDbf:cTextoDim2 )
         ::oGetMedDos:Show()
      end if

      if oUndMedicion:oDbf:nDimension >= 3 .and. !Empty( oUndMedicion:oDbf:cTextoDim3 )
         ::oGetMedTre:oSay:SetText( oUndMedicion:oDbf:cTextoDim3 )
         ::oGetMedTre:Show()
      end if

   end if

RETURN ( Self )

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

   if dbDialogLock( TDataView():PedidosClientes( nView ) )
      ( TDataView():PedidosClientes( nView ) )->lPdtCrg := !( TDataView():PedidosClientes( nView ) )->lPdtCrg
      ( TDataView():PedidosClientes( nView ) )->( dbUnLock() )
   end if

   oBrw:Refresh()
   oBrw:SetFocus()

RETURN NIL

//-------------------------------------------------------------------------//

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
         msgStop( "C�digo de transportista no encontrado." )
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

   oFr:SetWorkArea(     "Pedidos", ( TDataView():PedidosClientes( nView ) )->( Select() ), .f., { FR_RB_CURRENT, FR_RB_CURRENT, 0 } )
   oFr:SetFieldAliases( "Pedidos", cItemsToReport( aItmPedCli() ) )

   oFr:SetWorkArea(     "Lineas de pedidos", ( dbfPedCliL )->( Select() ) )
   oFr:SetFieldAliases( "Lineas de pedidos", cItemsToReport( aColPedCli() ) )

   oFr:SetWorkArea(     "Incidencias de pedidos", ( dbfPedCliI )->( Select() ) )
   oFr:SetFieldAliases( "Incidencias de pedidos", cItemsToReport( aIncPedCli() ) )

   oFr:SetWorkArea(     "Documentos de pedidos", ( dbfPedCliD )->( Select() ) )
   oFr:SetFieldAliases( "Documentos de pedidos", cItemsToReport( aPedCliDoc() ) )

   oFr:SetWorkArea(     "Empresa", ( dbfEmp )->( Select() ) )
   oFr:SetFieldAliases( "Empresa", cItemsToReport( aItmEmp() ) )

   oFr:SetWorkArea(     "Clientes", ( TDataView():Clientes( nView ) )->( Select() ) )
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

   oFr:SetWorkArea(     "Art�culos", ( dbfArticulo )->( Select() ) )
   oFr:SetFieldAliases( "Art�culos", cItemsToReport( aItmArt() ) )

   oFr:SetWorkArea(     "Ofertas", ( dbfOferta )->( Select() ) )
   oFr:SetFieldAliases( "Ofertas", cItemsToReport( aItmOfe() ) )

   oFr:SetWorkArea(     "Unidades de medici�n",  oUndMedicion:Select() )
   oFr:SetFieldAliases( "Unidades de medici�n",  cObjectsToReport( oUndMedicion:oDbf ) )

   oFr:SetWorkArea(     "Usuarios", ( dbfUsr )->( Select() ) )
   oFr:SetFieldAliases( "Usuarios", cItemsToReport( aItmUsuario() ) )

   oFr:SetMasterDetail( "Pedidos", "Lineas de pedidos",                 {|| ( TDataView():PedidosClientes( nView ) )->cSerPed + Str( ( TDataView():PedidosClientes( nView ) )->nNumPed ) + ( TDataView():PedidosClientes( nView ) )->cSufPed } )
   oFr:SetMasterDetail( "Pedidos", "Incidencias de pedidos",            {|| ( TDataView():PedidosClientes( nView ) )->cSerPed + Str( ( TDataView():PedidosClientes( nView ) )->nNumPed ) + ( TDataView():PedidosClientes( nView ) )->cSufPed } )
   oFr:SetMasterDetail( "Pedidos", "Documentos de pedidos",             {|| ( TDataView():PedidosClientes( nView ) )->cSerPed + Str( ( TDataView():PedidosClientes( nView ) )->nNumPed ) + ( TDataView():PedidosClientes( nView ) )->cSufPed } )
   oFr:SetMasterDetail( "Pedidos", "Empresa",                           {|| cCodigoEmpresaEnUso() } )
   oFr:SetMasterDetail( "Pedidos", "Clientes",                          {|| ( TDataView():PedidosClientes( nView ) )->cCodCli } )
   oFr:SetMasterDetail( "Pedidos", "Obras",                             {|| ( TDataView():PedidosClientes( nView ) )->cCodCli + ( TDataView():PedidosClientes( nView ) )->cCodObr } )
   oFr:SetMasterDetail( "Pedidos", "Almacen",                           {|| ( TDataView():PedidosClientes( nView ) )->cCodAlm } )
   oFr:SetMasterDetail( "Pedidos", "Rutas",                             {|| ( TDataView():PedidosClientes( nView ) )->cCodRut } )
   oFr:SetMasterDetail( "Pedidos", "Agentes",                           {|| ( TDataView():PedidosClientes( nView ) )->cCodAge } )
   oFr:SetMasterDetail( "Pedidos", "Formas de pago",                    {|| ( TDataView():PedidosClientes( nView ) )->cCodPgo } )
   oFr:SetMasterDetail( "Pedidos", "Transportistas",                    {|| ( TDataView():PedidosClientes( nView ) )->cCodTrn } )
   oFr:SetMasterDetail( "Pedidos", "Usuarios",                        	{|| ( TDataView():PedidosClientes( nView ) )->cCodUsr } )

   oFr:SetMasterDetail( "Lineas de pedidos", "Art�culos",               {|| ( dbfPedCliL )->cRef } )
   oFr:SetMasterDetail( "Lineas de pedidos", "Ofertas",                 {|| ( dbfPedCliL )->cRef } )
   oFr:SetMasterDetail( "Lineas de pedidos", "Unidades de medici�n",    {|| ( dbfPedCliL )->cUnidad } )

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
   oFr:SetResyncPair( "Pedidos", "Transportistas" )
   oFr:SetResyncPair( "Pedidos", "Usuarios" )

   oFr:SetResyncPair( "Lineas de pedidos", "Art�culos" )
   oFr:SetResyncPair( "Lineas de pedidos", "Ofertas" )
   oFr:SetResyncPair( "Lineas de pedidos", "Unidades de medici�n" )


Return nil

//---------------------------------------------------------------------------//

Static Function VariableReport( oFr )

   oFr:DeleteCategory(  "Pedidos" )
   oFr:DeleteCategory(  "Lineas de Pedidos" )

   /*
   Creaci�n de variables----------------------------------------------------
   */

   oFr:AddVariable(     "Pedidos",             "Total bruto",                         "GetHbVar('nTotBrt')" )
   oFr:AddVariable(     "Pedidos",             "Total pedido",                        "GetHbVar('nTotPed')" )
   oFr:AddVariable(     "Pedidos",             "Total descuento",                     "GetHbVar('nTotDto')" )
   oFr:AddVariable(     "Pedidos",             "Total descuento pronto pago",         "GetHbVar('nTotDpp')" )
   oFr:AddVariable(     "Pedidos",             "Total descuentos",                    "GetHbVar('nTotalDto')" )
   oFr:AddVariable(     "Pedidos",             "Total neto",                          "GetHbVar('nTotNet')" )
   oFr:AddVariable(     "Pedidos",             "Total primer descuento definible",    "GetHbVar('nTotUno')" )
   oFr:AddVariable(     "Pedidos",             "Total segundo descuento definible",   "GetHbVar('nTotDos')" )
   oFr:AddVariable(     "Pedidos",             "Total " + cImp(),                           "GetHbVar('nTotIva')" )
   oFr:AddVariable(     "Pedidos",             "Total RE",                            "GetHbVar('nTotReq')" )
   oFr:AddVariable(     "Pedidos",             "Total p�gina",                        "GetHbVar('nTotPag')" )
   oFr:AddVariable(     "Pedidos",             "Total peso",                          "GetHbVar('nTotPes')" )
   oFr:AddVariable(     "Pedidos",             "Total costo",                         "GetHbVar('nTotCos')" )
   oFr:AddVariable(     "Pedidos",             "Total art�culos",                     "GetHbVar('nTotArt')" )
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


   oFr:AddVariable(     "Pedidos",             "Fecha del primer vencimiento",        "GetHbArrayVar('aDatVto',1)" )
   oFr:AddVariable(     "Pedidos",             "Fecha del segundo vencimiento",       "GetHbArrayVar('aDatVto',2)" )
   oFr:AddVariable(     "Pedidos",             "Fecha del tercer vencimiento",        "GetHbArrayVar('aDatVto',3)" )
   oFr:AddVariable(     "Pedidos",             "Fecha del cuarto vencimiento",        "GetHbArrayVar('aDatVto',4)" )
   oFr:AddVariable(     "Pedidos",             "Fecha del quinto vencimiento",        "GetHbArrayVar('aDatVto',5)" )
   oFr:AddVariable(     "Pedidos",             "Importe del primer vencimiento",      "GetHbArrayVar('aImpVto',1)" )
   oFr:AddVariable(     "Pedidos",             "Importe del segundo vencimiento",     "GetHbArrayVar('aImpVto',2)" )
   oFr:AddVariable(     "Pedidos",             "Importe del tercero vencimiento",     "GetHbArrayVar('aImpVto',3)" )
   oFr:AddVariable(     "Pedidos",             "Importe del cuarto vencimiento",      "GetHbArrayVar('aImpVto',4)" )
   oFr:AddVariable(     "Pedidos",             "Importe del quinto vencimiento",      "GetHbArrayVar('aImpVto',5)" )

   oFr:AddVariable(     "Lineas de Pedidos",   "Detalle del art�culo",                "CallHbFunc('cDesPedCli')"  )
   oFr:AddVariable(     "Lineas de Pedidos",   "Total unidades art�culo",             "CallHbFunc('nTotNPedCli')" )
   oFr:AddVariable(     "Lineas de Pedidos",   "Precio unitario del art�culo",        "CallHbFunc('nTotUPedCli')" )
   oFr:AddVariable(     "Lineas de Pedidos",   "Total l�nea de pedido",               "CallHbFunc('nTotLPedCli')" )
   oFr:AddVariable(     "Lineas de Pedidos",   "Total peso por l�nea",                "CallHbFunc('nPesLPedCli')" )
   oFr:AddVariable(     "Lineas de Pedidos",   "Total final l�nea del pedido",        "CallHbFunc('nTotFPedCli')" )

Return nil

//---------------------------------------------------------------------------//

Static Function DataReportEntPedCli( oFr, cPedCliP )

   /*
   Zona de datos------------------------------------------------------------
   */

   oFr:ClearDataSets()

   if !Empty( cPedCliP )
   oFr:SetWorkArea(     "Entrega", ( cPedCliP )->( Select() ), .f., { FR_RB_CURRENT, FR_RB_CURRENT, 0 } )
   else
   oFr:SetWorkArea(     "Entrega", ( dbfPedCliP )->( Select() ), .f., { FR_RB_CURRENT, FR_RB_CURRENT, 0 } )
   end if
   oFr:SetFieldAliases( "Entrega", cItemsToReport( aPedCliPgo() ) )

   oFr:SetWorkArea(     "Pedido de cliente", ( TDataView():PedidosClientes( nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Pedido de cliente", cItemsToReport( aItmPedCli() ) )

   oFr:SetWorkArea(     "Empresa", ( dbfEmp )->( Select() ) )
   oFr:SetFieldAliases( "Empresa", cItemsToReport( aItmEmp() ) )

   oFr:SetWorkArea(     "Clientes", ( TDataView():Clientes( nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Clientes", cItemsToReport( aItmCli() ) )

   oFr:SetWorkArea(     "Formas de pago", ( dbfFpago )->( Select() ) )
   oFr:SetFieldAliases( "Formas de pago", cItemsToReport( aItmFPago() ) )

   if !Empty( cPedCliP )
   oFr:SetMasterDetail( "Entrega", "Pedido de cliente",        {|| ( cPedCliP )->cSerPed + Str( ( cPedCliP )->nNumPed ) + ( cPedCliP )->cSufPed } )
   oFr:SetMasterDetail( "Entrega", "Clientes",                 {|| ( cPedCliP )->cCodCli } )
   oFr:SetMasterDetail( "Entrega", "Formas de pago",           {|| ( cPedCliP )->cCodPgo } )
   else
   oFr:SetMasterDetail( "Entrega", "Pedido de cliente",        {|| ( dbfPedCliP )->cSerPed + Str( ( dbfPedCliP )->nNumPed ) + ( dbfPedCliP )->cSufPed } )
   oFr:SetMasterDetail( "Entrega", "Clientes",                 {|| ( dbfPedCliP )->cCodCli } )
   oFr:SetMasterDetail( "Entrega", "Formas de pago",           {|| ( dbfPedCliP )->cCodPgo } )
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
   Creaci�n de variables----------------------------------------------------
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
   oFr:AddVariable( "Pedido de cliente",     "Total p�gina",                        "GetHbVar('nTotPag')" )
   oFr:AddVariable( "Pedido de cliente",     "Total peso",                          "GetHbVar('nTotPes')" )
   oFr:AddVariable( "Pedido de cliente",     "Total costo",                         "GetHbVar('nTotCos')" )
   oFr:AddVariable( "Pedido de cliente",     "Total art�culos",                     "GetHbVar('nTotArt')" )
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

RETURN NIL

//-------------------------------------------------------------------------//

Static Function aPedCliRes()

   local aPedCliRes  := {}

   aAdd( aPedCliRes, { "cSerPed", "C",    1,  0, "",                                "",                   "", "( cDbfCol )", nil } )
   aAdd( aPedCliRes, { "nNumPed", "N",    9,  0, "",                                "'999999999'",        "", "( cDbfCol )", nil } )
   aAdd( aPedCliRes, { "cSufPed", "C",    2,  0, "",                                "",                   "", "( cDbfCol )", nil } )
   aAdd( aPedCliRes, { "cRef",    "C",   18,  0, "Referencia del art�culo",         "",                   "", "( cDbfCol )", nil } )
   aAdd( aPedCliRes, { "cCodPr1", "C",   20,  0, "C�digo de la primera propiedad",  "",                   "", "( cDbfCol )", nil } )
   aAdd( aPedCliRes, { "cCodPr2", "C",   20,  0, "C�digo de la segunda propiedad",  "",                   "", "( cDbfCol )", nil } )
   aAdd( aPedCliRes, { "cValPr1", "C",   40,  0, "Valor de la primera propiedad",   "",                   "", "( cDbfCol )", nil } )
   aAdd( aPedCliRes, { "cValPr2", "C",   40,  0, "Valor de la segunda propiedad",   "",                   "", "( cDbfCol )", nil } )
   aAdd( aPedCliRes, { "dFecRes", "D",    8,  0, "Fecha de la reserva",             "",                   "", "( cDbfCol )", nil } )
   aAdd( aPedCliRes, { "nCajRes", "N",   16,  6, "Cajas reservadas",                "MasUnd()",           "", "( cDbfCol )", nil } )
   aAdd( aPedCliRes, { "nUndRes", "N",   16,  6, "Unidades reservadas",             "MasUnd()",           "", "( cDbfCol )", nil } )
   aAdd( aPedCliRes, { "nLote",   "N",    9,  0, "",                                "'999999999'",        "", "( cDbfCol )", nil } )
   aAdd( aPedCliRes, { "cLote",   "C",   12,  0, "N�mero del lote",                 "",                   "", "( cDbfCol )", nil } )

return ( aPedCliRes )

//---------------------------------------------------------------------------//

STATIC FUNCTION CloseFiles()

   DisableAcceso()

   lPedidosWeb( TDataView():PedidosClientes( nView ) )

   DestroyFastFilter( TDataView():PedidosClientes( nView ), .t., .t. )

   if !Empty( oFont )
      oFont:end()
   end if

   if( !Empty( dbfPedCliL ), ( dbfPedCliL )->( dbCloseArea() ), )
   if( !Empty( dbfPedCliR ), ( dbfPedCliR )->( dbCloseArea() ), )
   if( !Empty( dbfPedCliI ), ( dbfPedCliI )->( dbCloseArea() ), )
   if( !Empty( dbfPedCliD ), ( dbfPedCliD )->( dbCloseArea() ), )
   if( !Empty( dbfPedCliP ), ( dbfPedCliP )->( dbCloseArea() ), )
   if( !Empty( dbfPreCliT ), ( dbfPreCliT )->( dbCloseArea() ), )
   if( !Empty( dbfPedPrvT ), ( dbfPedPrvT )->( dbCloseArea() ), )
   if( !Empty( dbfPedPrvL ), ( dbfPedPrvL )->( dbCloseArea() ), )
   if( !Empty( dbfPreCliL ), ( dbfPreCliL )->( dbCloseArea() ), )
   if( !Empty( dbfPreCliI ), ( dbfPreCliI )->( dbCloseArea() ), )
   if( !Empty( dbfPreCliD ), ( dbfPreCliD )->( dbCloseArea() ), )
   if( !Empty( dbfAlbCliT ), ( dbfAlbCliT )->( dbCloseArea() ), )
   if( !Empty( dbfAlbCliL ), ( dbfAlbCliL )->( dbCloseArea() ), )
   if( !Empty( dbfAlbCliP ), ( dbfAlbCliP )->( dbCloseArea() ), )
   if( !Empty( dbfAlbPrvT ), ( dbfAlbPrvT )->( dbCloseArea() ), )
   if( !Empty( dbfAlbPrvL ), ( dbfAlbPrvL )->( dbCloseArea() ), )
   if( !Empty( dbfIva     ), ( dbfIva     )->( dbCloseArea() ), )
   if( !Empty( dbfTarPreL ), ( dbfTarPreL )->( dbCloseArea() ), )
   if( !Empty( dbfTarPreS ), ( dbfTarPreS )->( dbCloseArea() ), )
   if( !Empty( dbfPromoT  ), ( dbfPromoT  )->( dbCloseArea() ), )
   if( !Empty( dbfPromoL  ), ( dbfPromoL  )->( dbCloseArea() ), )
   if( !Empty( dbfPromoC  ), ( dbfPromoC  )->( dbCloseArea() ), )
   if( !Empty( dbfAgent   ), ( dbfAgent   )->( dbCloseArea() ), )
   if( !Empty( dbfArticulo), ( dbfArticulo)->( dbCloseArea() ), )
   if( !Empty( dbfCodebar ), ( dbfCodebar )->( dbCloseArea() ), )
   if( !Empty( dbfFamilia ), ( dbfFamilia )->( dbCloseArea() ), )
   if( !Empty( dbfPrv     ), ( dbfPrv     )->( dbCloseArea() ), )
   if( !Empty( dbfFPago   ), ( dbfFPago   )->( dbCloseArea() ), )
   if( !Empty( dbfDiv     ), ( dbfDiv     )->( dbCloseArea() ), )
   if( !Empty( dbfObrasT  ), ( dbfObrasT  )->( dbCloseArea() ), )
   if( !Empty( dbfTVta    ), ( dbfTVta    )->( dbCloseArea() ), )
   if( !Empty( dbfDoc     ), ( dbfDoc     )->( dbCloseArea() ), )
   if( !Empty( dbfOferta  ), ( dbfOferta  )->( dbCloseArea() ), )
   if( !Empty( dbfPro     ), ( dbfPro     )->( dbCloseArea() ), )
   if( !Empty( dbfTblPro  ), ( dbfTblPro  )->( dbCloseArea() ), )
   if( !Empty( dbfKit     ), ( dbfKit     )->( dbCloseArea() ), )
   if( !Empty( dbfRuta    ), ( dbfRuta    )->( dbCloseArea() ), )
   if( !Empty( dbfAlm     ), ( dbfAlm     )->( dbCloseArea() ), )
   if( !Empty( dbfArtDiv  ), ( dbfArtDiv  )->( dbCloseArea() ), )
   if( !Empty( dbfTblCnv  ), ( dbfTblCnv  )->( dbCloseArea() ), )
   if( !Empty( dbfCajT    ), ( dbfCajT    )->( dbCloseArea() ), )
   if( !Empty( dbfUsr     ), ( dbfUsr     )->( dbCloseArea() ), )
   if( !Empty( dbfInci    ), ( dbfInci    )->( dbCloseArea() ), )
   if( !Empty( dbfArtPrv  ), ( dbfArtPrv  )->( dbCloseArea() ), )
   if( !Empty( dbfDelega  ), ( dbfDelega  )->( dbCloseArea() ), )
   if( !Empty( dbfCount   ), ( dbfCount   )->( dbCloseArea() ), )
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
   if( !Empty( dbfHisMov  ), ( dbfHisMov  )->( dbCloseArea() ), )
   if( !Empty( dbfCliBnc  ), ( dbfCliBnc  )->( dbCloseArea() ), )

   if( !Empty( oStock     ), oStock:end(),  )
   if( !Empty( oTrans     ), oTrans:end(),  )
   if( !Empty( oNewImp    ), oNewImp:end(), )
   if( !Empty( oTipArt    ), oTipArt:end(), )
   if( !Empty( oGrpFam    ), oGrpFam:end(), )

   if !Empty( oFraPub )
      oFraPub:end()
   end if

   if !Empty( oUndMedicion )
      oUndMedicion:end()
   end if

   TDataView():DeleteView( nView )

   dbfPedCliL     := nil
   dbfPedCliI     := nil
   dbfPedCliD     := nil
   dbfPedCliP     := nil
   dbfPreCliT     := nil
   dbfPreCliL     := nil
   dbfPreCliI     := nil
   dbfPreCliD     := nil
   dbfPedCliR     := nil
   dbfPedPrvT     := nil
   dbfPedPrvL     := nil
   dbfAlbCliT     := nil
   dbfAlbCliL     := nil
   dbfAlbCliP     := nil
   dbfAlbPrvT     := nil
   dbfAlbPrvL     := nil
   dbfIva         := nil
   dbfTarPreL     := nil
   dbfTarPreS     := nil
   dbfPromoT      := nil
   dbfPromoL      := nil
   dbfPromoC      := nil
   dbfAgent       := nil
   dbfArticulo    := nil
   dbfPrv         := nil
   dbfArtPrv      := nil
   dbfCodebar     := nil
   dbfFpago       := nil
   dbfDiv         := nil
   dbfObrasT      := nil
   dbfTVta        := nil
   dbfDoc         := nil
   dbfOferta      := nil
   dbfPro         := nil
   dbfTblPro      := nil
   dbfKit         := nil
   dbfRuta        := nil
   dbfAlm         := nil
   dbfArtDiv      := nil
   dbfTblCnv      := nil
   dbfCajT        := nil
   dbfUsr         := nil
   dbfInci        := nil
   dbfCount       := nil
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
   dbfHisMov      := nil
   dbfCliBnc      := nil

   oStock         := nil
   oBandera       := nil
   oNewImp        := nil
   oTrans         := nil
   oTipArt        := nil
   oGrpFam        := nil

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

   /*
   Eliminamos los temporales
   */

   dbfErase( cTmpLin )
   dbfErase( cTmpInc )
   dbfErase( cTmpDoc )
   dbfErase( cTmpPgo )
   dbfErase( cTmpRes )

Return .t.

//------------------------------------------------------------------------//

STATIC FUNCTION EndTrans( aTmp, aGet, oBrwLin, oBrwInc, nMode, oDlg )

   local oError
   local oBlock
   local aTabla
   local cSerPed
   local nNumPed
   local cSufPed

   if Empty( aTmp[ _CSERPED ] )
      aTmp[ _CSERPED ]  := "A"
   end if

   cSerPed              := aTmp[ _CSERPED ]
   nNumPed              := aTmp[ _NNUMPED ]
   CSufPed              := aTmp[ _CSUFPED ]

   aTmp[ _LSNDDOC ]     := .t.

   /*
   Comprobamos la fecha del documento------------------------------------------
   */
   if !lValidaOperacion( aTmp[_DFECPED] )
      Return .f.
   end if

   /*
   Estos campos no pueden estar vacios
   */

   if lCliBlq( aTmp[ _CCODCLI ], TDataView():Clientes( nView ) )
      msgStop( "Cliente bloqueado, no se pueden realizar operaciones de venta." )
      aGet[ _CCODCLI ]:SetFocus()
      return .f.
   end if

   if Empty( aTmp[ _CCODCLI ] )
      msgStop( "C�digo de cliente no puede estar vac�o." )
      aGet[ _CCODCLI ]:SetFocus()
      return .f.
   end if

   if Empty( aTmp[ _CCODALM ] )
      msgStop( "Almac�n no puede estar vac�o." )
      aGet[ _CCODALM ]:SetFocus()
      return .f.
   end if

   if Empty( aTmp[ _CCODCAJ ] )
      msgStop( "Caja no puede estar vac�a." )
      aGet[ _CCODCAJ ]:SetFocus()
      return .f.
   end if

   if Empty( aTmp[ _CDIVPED ] )
      MsgStop( "No puede almacenar documento sin c�digo de divisa." )
      aGet[ _CDIVPED ]:SetFocus()
      return .f.
   end if

   if Empty( aTmp[ _CCODAGE ] ) .and. lRecogerAgentes()
      msgStop( "Agente no puede estar vac�o." )
      aGet[ _CCODAGE ]:SetFocus()
      return .f.
   end if

   if ( dbfTmpLin )->( eof() )
      MsgStop( "No puede almacenar un documento sin l�neas." )
      return .f.
   end if

   oDlg:Disable()

   oMsgText( "Archivando" )

   oBlock      := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   BeginTransaction()

   /*
   Quitamos los filtros
   */

   ( dbfTmpLin )->( dbClearFilter() )

	/*
	Primero hacer el RollBack
	*/

   aTmp[ _DFECCRE ]     := Date()
   aTmp[ _CTIMCRE ]     := Time()

   /*
   Guardamos el tipo para alquileres
   */

   if !Empty( oTipPed ) .and. oTipPed:nAt == 2
      aTmp[ _LALQUILER ]   := .t.
   else
      aTmp[ _LALQUILER ]   := .f.
   end if

   do case

       case nMode == APPD_MODE .or. nMode == DUPL_MODE

         nNumPed           := nNewDoc( cSerPed, TDataView():PedidosClientes( nView ), "NPEDCLI", , dbfCount )
         aTmp[ _NNUMPED ]  := nNumPed

       case nMode == EDIT_MODE

   /*if !Empty( oStock )
         oStock:PedCli( cSerPed + Str( nNumPed ) + cSufPed, ( TDataView():PedidosClientes( nView ) )->cCodAlm, .t., .f. )
   end if*/

         if nNumPed != 0

            while ( dbfPedCliL )->( dbSeek( cSerPed + str( nNumPed ) + cSufPed ) )
               if dbLock( dbfPedCliL )
                  ( dbfPedCliL )->( dbDelete() )
                  ( dbfPedCliL )->( dbUnLock() )
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

            while ( dbfPedCliP )->( dbSeek( cSerPed + str( nNumPed ) + cSufPed ) )
               if dbLock( dbfPedCliP )
                  ( dbfPedCliP )->( dbDelete() )
                  ( dbfPedCliP )->( dbUnLock() )
               end if
            end while

         end if

       end case

   if !( "PDA" $ cParamsMain() )
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

      if nMode == APPD_MODE
         if dbLock( dbfTmpLin )
            ( dbfTmpLin )->lAnulado    := aTmp[ _LCANCEL ]
            ( dbfTmpLin )->dAnulado    := aTmp[ _DCANCEL ]
            ( dbfTmpLin )->mAnulado    := aTmp[ _CCANCEL ]
            ( dbfTmpLin )->nProduc     := 2
            ( dbfTmpLin )->( dbUnLock() )
         end if
      end if

      if !( ( dbfTmpLin )->nUniCaja == 0 .and. ( dbfTmpLin )->lFromAtp )

      	dbPass( dbfTmpLin, dbfPedCliL, .t., cSerPed, nNumPed, cSufPed )

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

   ( dbfTmpPgo )->( dbGoTop() )
   while ( dbfTmpPgo )->( !eof() )
      dbPass( dbfTmpPgo, dbfPedCliP, .t., cSerPed, nNumPed, cSufPed )
      ( dbfTmpPgo )->( dbSkip() )
   end while

   /*
   Fichero de las reservas
   */

   ( dbfTmpRes )->( DbGoTop() )
   while ( dbfTmpRes )->( !eof() )
      dbPass( dbfTmpRes, dbfPedCliR, .t., cSerPed, nNumPed, cSufPed )
      ( dbfTmpRes )->( dbSkip() )
   end while

   /*
   Acualizamos las cantidades pendientes de entregar---------------------------
   */

   /*if !Empty( oStock )
      oStock:PedCli( cSerPed + Str( nNumPed ) + cSufPed, aTmp[ _CCODALM ], .f., .t. )
   end if*/

   /*
   Si el pedido est� cancelado ponemos el estado a 3---------------------------
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

   /*
   Escritura en el fichero definitivo------------------------------------------
   */

   WinGather( aTmp, aGet, TDataView():PedidosClientes( nView ), , nMode )

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

   EndProgress()

   /*
   Encendemos el dialogo-------------------------------------------------------
   */

   oDlg:Enable()

   oDlg:end( IDOK )

Return .t.

//------------------------------------------------------------------------//

Static Function RecalculaTotal( aTmp )

   local nTotPedCli  := nTotPedCli( nil, TDataView():PedidosClientes( nView ), dbfTmpLin, dbfIva, dbfDiv, dbfFPago, aTmp, nil, .f. )
   local nEntPedCli  := nPagPedCli( nil, dbfTmpPgo, dbfDiv )

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
      oGetRnt:SetText( AllTrim( Trans( nTotRnt, cPorDiv ) + Space( 1 ) +  AllTrim( cSimDiv( aTmp[ _CDIVPED ], dbfDiv ) ) + " : " + AllTrim( Trans( nPctRnt, "999.99" ) ) + "%" ) )
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
Funcion Auxiliar para A�adir lineas de detalle a un pedido
*/

STATIC FUNCTION AppDeta( oBrwLin, bEdtDet, aTmp, lTot, cCodArt )

   DEFAULT lTot := .f.

   WinAppRec( oBrwLin, bEdtDet, dbfTmpLin, lTot, cCodArt, aTmp )

RETURN RecalculaTotal( aTmp )

//--------------------------------------------------------------------------//

/*
Funcion Auxiliar para la Edici�n de Lineas de Detalle en un pedido
*/
STATIC FUNCTION EdtDeta( oBrwLin, bEdtDet, aTmp )

   WinEdtRec( oBrwLin, bEdtDet, dbfTmpLin, nil, nil, aTmp )

RETURN RecalculaTotal( aTmp )

//--------------------------------------------------------------------------//

STATIC FUNCTION LoaCli( aGet, aTmp, nMode, oRieCli, oTlfCli )

	local lValid 		:= .T.
   local cNewCodCli  := aGet[ _CCODCLI ]:varGet()
   local lChgCodCli  := ( Empty( cOldCodCli ) .or. cOldCodCli != cNewCodCli )

   if Empty( cNewCodCli )
      Return .t.
   elseif At( ".", cNewCodCli ) != 0
      cNewCodCli     := PntReplace( aGet[ _CCODCLI ], "0", RetNumCodCliEmp() )
   else
      cNewCodCli     := Rjust( cNewCodCli, "0", RetNumCodCliEmp() )
   end if

   if ( TDataView():Clientes( nView ) )->( dbSeek( cNewCodCli ) )

      /*
      Si tenemos parcado en la empresa que mostremos el saldo pendiente del cliente
      */


      /*
      Asignamos el codigo siempre----------------------------------------------
      */

      aGet[ _CCODCLI ]:cText( ( TDataView():Clientes( nView ) )->Cod )

      /*
      Color de fondo del cliente-----------------------------------------------
      */

      if ( TDataView():Clientes( nView ) )->nColor != 0
         aGet[ _CNOMCLI ]:SetColor( , ( TDataView():Clientes( nView ) )->nColor )
      end if

      if Empty( aGet[ _CNOMCLI ]:varGet() ) .or. lChgCodCli
         aGet[ _CNOMCLI ]:cText( ( TDataView():Clientes( nView ) )->Titulo )
      end if

      if Empty( aGet[ _CDIRCLI ]:varGet() ) .or. lChgCodCli
         aGet[ _CDIRCLI ]:cText( ( TDataView():Clientes( nView ) )->Domicilio )
      end if

      if Empty( aGet[ _CPOBCLI ]:varGet() ) .or. lChgCodCli
         aGet[ _CPOBCLI ]:cText( ( TDataView():Clientes( nView ) )->Poblacion )
      end if

      if aGet[ _CPRVCLI ] != nil

         if Empty( aGet[ _CPRVCLI ]:varGet() ) .or. lChgCodCli
            aGet[ _CPRVCLI ]:cText( ( TDataView():Clientes( nView ) )->Provincia )
         end if

      end if

      if Empty( aGet[ _CPOSCLI ]:varGet() ) .or. lChgCodCli
         aGet[ _CPOSCLI ]:cText( ( TDataView():Clientes( nView ) )->CodPostal )
      end if

      if Empty( aGet[ _CTLFCLI ]:varGet() ) .or. lChgCodCli
         aGet[ _CTLFCLI ]:cText( ( TDataView():Clientes( nView ) )->Telefono )
      end if

      if !Empty( aGet[ _CDNICLI ] )

         if Empty( aGet[ _CDNICLI ]:varGet() ) .or. lChgCodCli
            aGet[ _CDNICLI ]:cText( ( TDataView():Clientes( nView ) )->Nif )
         end if

      else

         if Empty( aTmp[ _CDNICLI ] ) .or. lChgCodCli
            aTmp[ _CDNICLI ]  := ( TDataView():Clientes( nView ) )->Nif
         end if

      end if

      if Empty( aTmp[ _CCODGRP ] ) .or. lChgCodCli
         aTmp[ _CCODGRP ]     := ( TDataView():Clientes( nView ) )->cCodGrp
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
            oStock:SetRiesgo( cNewCodCli, oRieCli, ( TDataView():Clientes( nView ) )->Riesgo )
         end if

         aTmp[ _LMODCLI ]     := ( TDataView():Clientes( nView ) )->lModDat

      end if

      if ( lChgCodCli )
         aTmp[ _LOPERPV ]     := ( TDataView():Clientes( nView ) )->lPntVer
      end if

      if nMode == APPD_MODE

         aTmp[_NREGIVA ]      := ( TDataView():Clientes( nView ) )->nRegIva

         /*
         Si estamos a�adiendo cargamos todos los datos del cliente
         */

         if Empty( aTmp[ _CSERPED ] )

            if !Empty( ( TDataView():Clientes( nView ) )->Serie )
               aGet[ _CSERPED ]:cText( ( TDataView():Clientes( nView ) )->Serie )
            end if

         else

            if !Empty( ( TDataView():Clientes( nView ) )->Serie )                .and.;
               aTmp[ _CSERPED ] != ( TDataView():Clientes( nView ) )->Serie      .and.;
               ApoloMsgNoYes( "La serie del cliente seleccionado es distinta a la anterior.", "�Desea cambiar la serie?" )
               aGet[ _CSERPED ]:cText( ( TDataView():Clientes( nView ) )->Serie )
            end if

         end if

         if aGet[ _CCODALM ] != nil

            if ( Empty( aGet[ _CCODALM ]:varGet() ) .or. lChgCodCli ) .and. !Empty( ( TDataView():Clientes( nView ) )->cCodAlm )
               aGet[ _CCODALM ]:cText( ( TDataView():Clientes( nView ) )->cCodAlm )
               aGet[ _CCODALM ]:lValid()
            end if

         end if

         if aGet[ _CCODTAR ] != nil

            if ( Empty( aGet[ _CCODTAR ]:varGet() ) .or. lChgCodCli ) .and. !Empty( ( TDataView():Clientes( nView ) )->cCodTar )
               aGet[ _CCODTAR ]:cText( ( TDataView():Clientes( nView ) )->CCODTAR )
               aGet[ _CCODTAR ]:lValid()
            end if

         end if

         if ( Empty( aGet[ _CCODPGO ]:varGet() ) .or. lChgCodCli ) .and. !Empty( ( TDataView():Clientes( nView ) )->CodPago )
            aGet[ _CCODPGO ]:cText( ( TDataView():Clientes( nView ) )->CodPago )
            aGet[ _CCODPGO ]:lValid()
         end if

         /*
         Si la forma de pago es un movimiento bancario le asignamos el banco y cuenta por defecto
         */

         if ( lChgCodCli .and. lBancoDefecto( ( TDataView():Clientes( nView ) )->Cod, dbfCliBnc ) )

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
            if ( Empty( aGet[ _CCODAGE ]:varGet() ) .or. lChgCodCli ) .and. !Empty( ( TDataView():Clientes( nView ) )->cAgente )
               aGet[ _CCODAGE ]:cText( ( TDataView():Clientes( nView ) )->cAgente )
               aGet[ _CCODAGE ]:lValid()
            end if
         end if

         if ( Empty( aGet[ _CCODRUT ]:varGet() ) .or. lChgCodCli ) .and. !Empty( ( TDataView():Clientes( nView ) )->cCodRut )
            aGet[ _CCODRUT ]:cText( ( TDataView():Clientes( nView ))->CCODRUT )
            aGet[ _CCODRUT ]:lValid()
         end if

         if ( Empty( aGet[ _NTARIFA ]:varGet() ) .or. lChgCodCli ) .and. !Empty( ( TDataView():Clientes( nView ) )->nTarifa )
            aGet[ _NTARIFA ]:cText( ( TDataView():Clientes( nView ) )->nTarifa )
         end if

         if ( Empty( aTmp[ _NDTOTARIFA ] ) .or. lChgCodCli )
             aTmp[ _NDTOTARIFA ]    := ( TDataView():Clientes( nView ) )->nDtoArt
         end if

         if !Empty( aGet[ _CCODTRN ] ) .and. ( Empty( aGet[ _CCODTRN ]:varGet() ) .or. lChgCodCli ) .and. !Empty( ( TDataView():Clientes( nView ) )->cCodTrn )
            aGet[ _CCODTRN ]:cText( ( TDataView():Clientes( nView ) )->cCodTrn )
            aGet[ _CCODTRN ]:lValid()
         end if

         if lChgCodCli

            aGet[ _LRECARGO ]:Click( ( TDataView():Clientes( nView ) )->lReq ):Refresh()

            aGet[ _LOPERPV  ]:Click( ( TDataView():Clientes( nView ) )->lPntVer ):Refresh()

            /*
            Retenciones desde la ficha de cliente----------------------------------

            if !Empty( aGet[ _NTIPRET ] )
               aGet[ _NTIPRET  ]:Select( ( TDataView():Clientes( nView ) )->nTipRet )
            else
               aTmp[ _NTIPRET  ] := ( TDataView():Clientes( nView ) )->nTipRet
            end if

            if !Empty( aGet[ _NPCTRET ] )
               aGet[ _NPCTRET  ]:cText( ( TDataView():Clientes( nView ) )->nPctRet )
            else
               aTmp[ _NPCTRET  ] := ( TDataView():Clientes( nView ) )->nPctRet
            end if
            */

            /*
            Descuentos desde la ficha de cliente----------------------------------
            */

            aGet[ _CDTOESP ]:cText( ( TDataView():Clientes( nView ) )->cDtoEsp )

            aGet[ _NDTOESP ]:cText( ( TDataView():Clientes( nView ) )->nDtoEsp )

            aGet[ _CDPP    ]:cText( ( TDataView():Clientes( nView ) )->cDpp )

            aGet[ _NDPP    ]:cText( ( TDataView():Clientes( nView ) )->nDpp )

            aGet[ _CDTOUNO ]:cText( ( TDataView():Clientes( nView ) )->cDtoUno )

            aGet[ _CDTODOS ]:cText( ( TDataView():Clientes( nView ) )->cDtoDos )

            aGet[ _NDTOUNO ]:cText( ( TDataView():Clientes( nView ) )->nDtoCnt )

            aGet[ _NDTODOS ]:cText( ( TDataView():Clientes( nView ) )->nDtoRap )

            aTmp[ _NDTOATP ] := ( TDataView():Clientes( nView ) )->nDtoAtp

            aTmp[ _NSBRATP ] := ( TDataView():Clientes( nView ) )->nSbrAtp

         end if

      end if

      cOldCodCli  := ( TDataView():Clientes( nView ) )->Cod

      if ( TDataView():Clientes( nView ) )->lMosCom .and. !Empty( ( TDataView():Clientes( nView ) )->mComent ) .and. lChgCodCli
         MsgStop( Trim( ( TDataView():Clientes( nView ) )->mComent ) )
      end if

      ShowIncidenciaCliente( ( TDataView():Clientes( nView ) )->Cod, nView )

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

	/*
	Primero Crear la base de datos local
	*/

   dbCreate( cTmpLin, aSqlStruct( aColPedCli() ), cLocalDriver() )
   dbUseArea( .t., cLocalDriver(), cTmpLin, cCheckArea( cDbfLin, @dbfTmpLin ), .f. )

   if !NetErr()

      ( dbfTmpLin )->( OrdCondSet( "!Deleted()", {||!Deleted() } ) )
      ( dbfTmpLin )->( OrdCreate( cTmpLin, "Recno", "Str( Recno() )", {|| Str( Recno() ) } ) )

      ( dbfTmpLin )->( OrdCondSet( "!Deleted()", {||!Deleted() } ) )
      ( dbfTmpLin )->( OrdCreate( cTmpLin, "cRef", "cRef", {|| Field->cRef } ) )

      ( dbfTmpLin )->( OrdCondSet( "!Deleted()", {||!Deleted() } ) )
      ( dbfTmpLin )->( OrdCreate( cTmpLin, "nNumLin", "Str( nNumLin, 4 )", {|| Str( Field->nNumLin ) } ) )

   else

      lErrors     := .t.

   end if

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

      ( dbfTmpRes )->( ordCreate( cTmpRes, "CREF", "CREF + CVALPR1 + CVALPR2", {|| Field->CREF + Field->CVALPR1 + Field->CVALPR2 } ) )
      ( dbfTmpRes )->( ordListAdd( cTmpRes ) )

   else

      lErrors     := .t.

   end if

	/*
	A�adimos desde el fichero de lineas
	*/

   if ( dbfPedCliL )->( dbSeek( cPedido ) )

      while ( ( dbfPedCliL )->CSERPED + Str( ( dbfPedCliL )->NNUMPED ) + ( dbfPedCliL )->CSUFPED == cPedido ) .AND. ( dbfPedCliL )->( !eof() )

         ( dbfTmpLin )->( dbAppend() )
         if ( dbfPedCliL )->nNumLin == 0 .and. dbLock( dbfPedCliL )
            ( dbfPedCliL )->nNumLin := ( dbfTmpLin )->( Recno() )
            ( dbfPedCliL )->( dbRUnLock() )
         end if
         dbPass( dbfPedCliL, dbfTmpLin )

			( dbfPedCliL )->( dbSkip() )

      end while

   end if

	( dbfTmpLin )->( OrdSetFocus( "Recno" ) )
   ( dbfTmpLin )->( dbGoTop() )

   /*
   A�adimos desde el fichero de incidencias
	*/

   if ( dbfPedCliI )->( dbSeek( cPedido ) )

      while ( ( dbfPedCliI )->cSerPed + Str( ( dbfPedCliI )->nNumPed ) + ( dbfPedCliI )->cSufPed == cPedido ) .AND. ( dbfPedCliI )->( !eof() )

         dbPass( dbfPedCliI, dbfTmpInc, .t. )
         ( dbfPedCliI )->( dbSkip() )

      end while

   end if

   ( dbfTmpInc )->( dbGoTop() )

   /*
   A�adimos desde el fichero de documentos
	*/

   if ( dbfPedCliD )->( dbSeek( cPedido ) )

      while ( ( dbfPedCliD )->cSerPed + Str( ( dbfPedCliD )->nNumPed ) + ( dbfPedCliD )->cSufPed == cPedido ) .AND. ( dbfPedCliD )->( !eof() )

         dbPass( dbfPedCliD, dbfTmpDoc, .t. )
         ( dbfPedCliD )->( dbSkip() )

      end while

   end if

   ( dbfTmpDoc )->( dbGoTop() )

   /*
   A�adimos desde el fichero de entregas a cuenta
	*/

   if ( dbfPedCliP )->( dbSeek( cPedido ) )

      while ( ( dbfPedCliP )->cSerPed + Str( ( dbfPedCliP )->nNumPed ) + ( dbfPedCliP )->cSufPed == cPedido ) .AND. ( dbfPedCliP )->( !eof() )

         dbPass( dbfPedCliP, dbfTmpPgo, .t. )
         ( dbfPedCliP )->( dbSkip() )

      end while

   end if

   ( dbfTmpPgo )->( dbGoTop() )

	/*
	A�adimos desde el fichero de lineas
	*/

   if ( dbfPedCliR )->( DbSeek( cPedido ) )

      while ( ( dbfPedCliR )->cSerPed + Str( ( dbfPedCliR )->nNumPed ) + ( dbfPedCliR )->cSufPed == cPedido ) .and. ( dbfPedCliR )->( !eof() )

         dbPass( dbfPedCliR, dbfTmpRes, .t. )
         ( dbfPedCliR )->( DbSkip() )

      end while

   end if

   ( dbfTmpRes )->( dbGoTop() )

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
   local cNomInci         	:= RetFld( aTmp[ ( dbfTmpInc )->( FieldPos( "cCodTip" ) ) ], dbfInci )

   if nMode == APPD_MODE
      aTmp[ _CSERPED  ]    := aTmpPed[ _CSERPED ]
      aTmp[ _NNUMPED  ]    := aTmpPed[ _NNUMPED ]
      aTmp[ _CSUFPED  ]    := aTmpPed[ _CSUFPED ]

      if IsMuebles()
         aTmp[ ( dbfTmpInc )->( FieldPos( "lAviso" ) ) ]  := .t.
      end if
   end if

   DEFINE DIALOG oDlg RESOURCE "INCIDENCIA" TITLE LblTitle( nMode ) + "incidencias de presupuestos a clientes"

      REDEFINE GET aGet[ ( dbfTmpInc )->( FieldPos( "cCodTip" ) ) ];
         VAR      aTmp[ ( dbfTmpInc )->( FieldPos( "cCodTip" ) ) ];
         ID       120 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
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

/*
Estudiamos la posiblidades que se pueden dar en una linea de detalle
*/

STATIC FUNCTION SetDlgMode( aTmp, aGet, nMode, oStkAct, oSayPr1, oSayPr2, oSayVp1, oSayVp2, oGet2, oTotal, aTmpPed, oFld, oRentLin, oBrwAlbCli, oBrwAlbPrv, oBrwFacCli )

   local cCodArt        := Left( aGet[ _CREF ]:VarGet(), 18 )

   
   if !uFieldEmpresa( "lUseBultos" )
      aGet[ __NBULTOS ]:Hide()
   else
      if !Empty( aGet[ __NBULTOS ] )
         aGet[ __NBULTOS ]:SetText( uFieldempresa( "cNbrBultos" ) )
      end if 
   end if

   if !lUseCaj()
      aGet[ _NCANPED ]:Hide()
   else
      aGet[ _NCANPED ]:SetText( cNombreCajas() )
   end if

   if nMode == APPD_MODE

      if !Empty( aGet[ _DFECHA ] )
         aTmp[ _DFECHA ]   := Ctod( "" )
         aGet[ _DFECHA ]:Refresh()
      end if

   end if

   aGet[ _NUNICAJA ]:SetText( cNombreUnidades() )

   if !lTipMov()
      if !Empty( aGet[ _CTIPMOV ] ) .and. !Empty( oGet2 )
         aGet[ _CTIPMOV ]:hide()
         oGet2:hide()
      end if
   end if

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

   if oRentLin != nil .and. oUser():lNotRentabilidad()
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

      if !Empty( aGet[ _NNUMLIN  ] )
         aGet[ _NNUMLIN  ]:cText( nLastNum( dbfTmpLin ) )
      else
         aTmp[ _NNUMLIN  ] := nLastNum( dbfTmpLin )
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
            oSayPr1:SetText( retProp( aTmp[ _CCODPR1 ], dbfPro ) )
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

   end if

   /*
   Mostramos u ocultamos las tarifas por l�neas--------------------------------
   */

   if Empty( aTmp[ _NTARLIN ] )
      if !Empty( aGet[ _NTARLIN ] )
         aGet[ _NTARLIN ]:cText( aTmpPed[ _NTARIFA ] )
      else
         aTmp[ _NTARLIN ]     := aTmpPed[ _NTARIFA ]
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
   Focus y validaci�n----------------------------------------------------------
   */
   if !Empty( aGet[ _CTIPMOV ] )
      aGet[ _CTIPMOV ]:lValid()
   end if

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

   if ( Empty( aTmp[ _NPREDIV ] ) .or. lUsrMaster() .or. oUser():lCambiarPrecio() ) .and. nMode != ZOOM_MODE

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

   if !Empty( aGet[ ( dbfPedCliL )->( fieldpos( "nMedUno" ) ) ] )
      aGet[ ( dbfPedCliL )->( fieldpos( "nMedUno" ) ) ]:Hide()
   end if

   if !Empty( aGet[ ( dbfPedCliL )->( fieldpos( "nMedDos" ) ) ] )
      aGet[ ( dbfPedCliL )->( fieldpos( "nMedDos" ) ) ]:Hide()
   end if

   if !Empty( aGet[ ( dbfPedCliL )->( fieldpos( "nMedTre" ) ) ] )
      aGet[ ( dbfPedCliL )->( fieldpos( "nMedTre" ) ) ]:Hide()
   end if

   if oUndMedicion:oDbf:Seek(  aTmp[ _CUNIDAD ] )

      if !Empty( aGet[ ( dbfPedCliL )->( fieldpos( "nMedUno" ) ) ] ) .and. oUndMedicion:oDbf:nDimension >= 1 .and. !Empty( oUndMedicion:oDbf:cTextoDim1 )
         aGet[ ( dbfPedCliL )->( fieldpos( "nMedUno" ) ) ]:oSay:SetText( oUndMedicion:oDbf:cTextoDim1 )
         aGet[ ( dbfPedCliL )->( fieldpos( "nMedUno" ) ) ]:Show()
      end if

      if !Empty( aGet[ ( dbfPedCliL )->( fieldpos( "nMedDos" ) ) ] ) .and. oUndMedicion:oDbf:nDimension >= 2 .and. !Empty( oUndMedicion:oDbf:cTextoDim2 )
         aGet[ ( dbfPedCliL )->( fieldpos( "nMedDos" ) ) ]:oSay:SetText( oUndMedicion:oDbf:cTextoDim2 )
         aGet[ ( dbfPedCliL )->( fieldpos( "nMedDos" ) ) ]:Show()
      end if

      if !Empty( aGet[ ( dbfPedCliL )->( fieldpos( "nMedTre" ) ) ] ) .and. oUndMedicion:oDbf:nDimension >= 3 .and. !Empty( oUndMedicion:oDbf:cTextoDim3 )
         aGet[ ( dbfPedCliL )->( fieldpos( "nMedTre" ) ) ]:oSay:SetText( oUndMedicion:oDbf:cTextoDim3 )
         aGet[ ( dbfPedCliL )->( fieldpos( "nMedTre" ) ) ]:Show()
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

   /*
   Focus al codigo-------------------------------------------------------------
   */

   aGet[ _CREF ]:SetFocus()

Return nil

//--------------------------------------------------------------------------//

STATIC FUNCTION SaveDeta( aTmp, aTmpPed, aGet, oFld, oDlg2, oBrw, bmpImage, nMode, oStkAct, oSayPr1, oSayPr2, oSayVp1, oSayVp2, oGet2, oTotal, oEstadoProduccion, oBtn )

   local aClo     
   local nRec
   local aXbyStr 	:= { 0, 0 }
   local hAtipica

   oBtn:SetFocus()

   if !aGet[ _CREF ]:lValid()
      return nil
   end if

   if !lMoreIva( aTmp[ _NIVA ] )
      msgStop( "Demasiados tipos de " + cImp() + " en un mismo documento.", "Atenci�n" )
      return nil
   end if

   if Empty( aTmp[ _CALMLIN ] ) .and. !Empty( aTmp[ _CREF ] )
      msgStop( "C�digo de almac�n no puede estar vac�o", "Atenci�n" )
      return nil
   end if

   if !cAlmacen( aGet[ _CALMLIN ], dbfAlm )
      return nil
   end if

   CursorWait()

   aClo     							:= aClone( aTmp )
   nRec                          := ( dbfTmpLin )->( RecNo() )

   // Estado de la produccion--------------------------------------------------

   aTmp[ _NPRODUC ]  				:= oEstadoProduccion:nAt - 1

   if nMode == APPD_MODE

      if !Empty( aTmp[ _CLOTE ] )
         GraLotArt( aTmp[ _CREF ], dbfArticulo, aTmp[ _CLOTE ] )
      end if

      /*
      Chequeamos las ofertas X * Y
      */

      /*
      Buscamos si existen atipicas de clientes---------------------------------
      */

      hAtipica := hAtipica( hValue( aTmp, aTmpPed ) )

      if !Empty( hAtipica )

         if hhaskey( hAtipica, "nTipoXY" )               .and.;
            hhaskey( hAtipica, "nUnidadesGratis" )

            if hAtipica[ "nUnidadesGratis" ] != 0
               aXbYStr     := { hAtipica[ "nTipoXY" ], hAtipica[ "nUnidadesGratis" ] }
            end if

         end if

      end if

      if aXbYStr[ 1 ] == 0

         /*
         Chequeamos las ofertas por art�culos X  *  Y--------------------------
         */

         if !aTmp[ _LLINOFE ]
            aXbyStr  			:= nXbYOferta( aTmp[ _CREF ], aTmpPed[ _CCODCLI ], aTmpPed[ _CCODGRP ], aTmp[ _NCANPED ], aTmp[ _NUNICAJA ], aTmpPed[ _DFECPED ], dbfOferta, 1 )
            aTmp[ _LLINOFE ]  := ( aXbYStr[ 1 ] != 0 )
         end if

         /*
         Chequeamos las ofertas por familia X  *  Y----------------------------
         */

         if !aTmp[ _LLINOFE ]
            aXbyStr  			:= nXbYOferta( RetFld( aTmp[ _CREF ], dbfArticulo, "Familia", "Codigo" ), aTmpPed[ _CCODCLI ], aTmpPed[ _CCODGRP ], aTmp[ _NCANPED ], aTmp[ _NUNICAJA ], aTmpPed[ _DFECPED ], dbfOferta, 2 )
            aTmp[ _LLINOFE ]  := ( aXbYStr[ 1 ] != 0 )
         end if

         /*
         Chequeamos las ofertas por tipo de art�culos X  *  Y------------------
         */

         if !aTmp[ _LLINOFE ]
            aXbyStr  			:= nXbYOferta( RetFld( aTmp[ _CREF ], dbfArticulo, "CCODTIP", "CODIGO" ), aTmpPed[ _CCODCLI ], aTmpPed[ _CCODGRP ], aTmp[ _NCANPED ], aTmp[ _NUNICAJA ], aTmpPed[ _DFECPED ], dbfOferta, 3 )
            aTmp[ _LLINOFE ]  := ( aXbYStr[ 1 ] != 0 )
         end if

         /*
         Chequeamos las ofertas por categoria X  *  Y--------------------------
         */

         if !aTmp[ _LLINOFE ]
            aXbyStr  			:= nXbYOferta( RetFld( aTmp[ _CREF ], dbfArticulo, "CCODCATE", "CODIGO" ), aTmpPed[ _CCODCLI ], aTmpPed[ _CCODGRP ], aTmp[ _NCANPED ], aTmp[ _NUNICAJA ], aTmpPed[ _DFECPED ], dbfOferta, 4 )
            aTmp[ _LLINOFE ]  := ( aXbYStr[ 1 ] != 0 )
         end if

         /*
         Chequeamos las ofertas por temporada X  *  Y--------------------------
         */

         if !aTmp[ _LLINOFE ]
            aXbyStr  			:= nXbYOferta( RetFld( aTmp[ _CREF ], dbfArticulo, "CCODTEMP", "CODIGO" ), aTmpPed[ _CCODCLI ], aTmpPed[ _CCODGRP ], aTmp[ _NCANPED ], aTmp[ _NUNICAJA ], aTmpPed[ _DFECPED ], dbfOferta, 5 )
            aTmp[ _LLINOFE ]  := ( aXbYStr[ 1 ] != 0 )
         end if

         /*
         Chequeamos las ofertas por fabricante X  *  Y-------------------------
         */

         if !aTmp[ _LLINOFE ]
            aXbyStr  			:= nXbYOferta( RetFld( aTmp[ _CREF ], dbfArticulo, "CCODFAB", "CODIGO" ), aTmpPed[ _CCODCLI ], aTmpPed[ _CCODGRP ], aTmp[ _NCANPED ], aTmp[ _NUNICAJA ], aTmpPed[ _DFECPED ], dbfOferta, 6 )
            aTmp[ _LLINOFE ]  := ( aXbYStr[ 1 ] != 0 )
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
            Ofertas de cajas
            */

            aTmp[ _NCANPED  ] -= aXbYStr[ 2 ]

            WinGather( aTmp, , dbfTmpLin, oBrw, nMode, nil, .f. )

            aTmp[ _NCANPED  ] := aXbYStr[ 2 ]
            aTmp[ _NPREDIV  ] := 0
            aTmp[ _NDTO ]     := 0
            aTmp[ _NDTODIV ]  := 0
            aTmp[ _NDTOPRM ]  := 0
            aTmp[ _NCOMAGE ]  := 0

            WinGather( aTmp, aGet, dbfTmpLin, oBrw, nMode )

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
               AppendKit( aClo, aTmpPed )
            end if

            if aTmp[ _NUNICAJA ] < 0
               aTmp[ _NUNICAJA ] := -( aXbYStr[ 2 ] )
            else
               aTmp[ _NUNICAJA ] := aXbYStr[ 2 ]
            end if

            aTmp[ _NPREDIV  ] := 0
            aTmp[ _NDTO ]     := 0
            aTmp[ _NDTODIV ]  := 0
            aTmp[ _NDTOPRM ]  := 0
            aTmp[ _NCOMAGE ]  := 0

            WinGather( aTmp, aGet, dbfTmpLin, oBrw, nMode )

            if aClo[ _LKITART ]
               AppendKit( aClo, aTmpPed )
            end if

         end if

      else

         // Guardamos el registro de manera normal-----------------------------

         WinGather( aTmp, aGet, dbfTmpLin, oBrw, nMode )

         if aClo[ _LKITART ]
            AppendKit( aClo, aTmpPed )
         end if

      end if

   else

      aTmp[ _NREQ ]                    := nPReq( dbfIva, aTmp[ _NIVA ] )

      /*
      Eliminamos los elementos de tipo kit-------------------------------------
      */

      if aClo[ _LKITART ]
			DbDelKit( oBrw, dbfTmpLin, aClo[ _NNUMLIN ] )	      
	   end if

      /*
      Guardamos el registro de manera normal-----------------------------------
      */

      WinGather( aTmp, aGet, dbfTmpLin, oBrw, nMode )

      /*
      A�adimos los kits--------------------------------------------------------
      */

      if aClo[ _LKITART ]
         AppendKit( aClo, aTmpPed )
      end if

   end if

   ( dbfTmpLin )->( dbGoTo( nRec ) )

   /*
	Si estamos a�adiendo y hay entradas continuas-------------------------------
	*/

   cOldCodArt                          := ""
   cOldUndMed                          := ""

   if !Empty( aGet[ _CUNIDAD ] )
      aGet[ _CUNIDAD ]:lValid()
   end if

   /*
   Liberacion del bitmap-------------------------------------------------------
   */

   if !Empty( bmpImage )
      bmpImage:Hide()
      PalBmpFree( bmpImage:hBitmap, bmpImage:hPalette )
   end if

	/*
   Si estamos a�adiendo y hay entradas continuas-------------------------------
	*/

   if nMode == APPD_MODE .AND. lEntCon()

      RecalculaTotal( aTmpPed )

      SetDlgMode( aTmp, aGet, nMode, oStkAct, oSayPr1, oSayPr2, oSayVp1, oSayVp2, oGet2, oTotal, aTmpPed, oFld )

      SysRefresh()

      if !Empty( aGet[ _CREF ] )
         aGet[ _CREF ]:SetFocus()
      end if

   else

      oDlg2:end( IDOK )

   end if

   CursorWE()

Return nil

//--------------------------------------------------------------------------//

Static Function AppendKit( uTmpLin, aTmpPed )

   local cCodArt
   local cSerPed
   local nNumPed
   local cSufPed
   local nCanPed
   local dFecPed
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
   local nUnidades                     := 0
   local nStkActual                    := 0
   local nRecAct                       := ( dbfKit 	)->( Recno() )
   local nRecLin 								:= ( dbfTmpLin )->( Recno() )

   if IsArray( uTmpLin )
      cCodArt                          := uTmpLin[ _CREF    ]
      cSerPed                          := uTmpLin[ _CSERPED ]
      nNumPed                          := uTmpLin[ _NNUMPED ]
      cSufPed                          := uTmpLin[ _CSUFPED ]
      nCanPed                          := uTmpLin[ _NCANPED ]
      dFecPed                          := uTmpLin[ _DFECHA  ]
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
      cSerPed                          := ( uTmpLin )->cSerPed
      nNumPed                          := ( uTmpLin )->nNumPed
      cSufPed                          := ( uTmpLin )->cSufPed
      nCanPed                          := ( uTmpLin )->nCanPed
      dFecPed                          := ( uTmpLin )->dFecha
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
            ( dbfTmpLin )->nPesoKg     := ( dbfArticulo )->nPesoKg
            ( dbfTmpLin )->cPesoKg     := ( dbfArticulo )->cUndDim
            ( dbfTmpLin )->cUnidad     := ( dbfArticulo )->cUnidad
            ( dbfTmpLin )->nVolumen    := ( dbfArticulo )->nVolumen
            ( dbfTmpLin )->cVolumen    := ( dbfArticulo )->cVolumen

            ( dbfTmpLin )->nPvpRec     := ( dbfArticulo )->PvpRec
            ( dbfTmpLin )->cCodImp     := ( dbfArticulo )->cCodImp
            ( dbfTmpLin )->lLote       := ( dbfarticulo )->lLote
            ( dbfTmpLin )->nLote       := ( dbfarticulo )->nLote
            ( dbfTmpLin )->cLote       := ( dbfarticulo )->cLote

            ( dbfTmpLin )->nValImp     := oNewImp:nValImp( ( dbfArticulo )->cCodImp )
            ( dbfTmpLin )->nCosDiv     := nCosto( nil, dbfArticulo, dbfKit )

            if ( dbfArticulo )->lFacCnv
               ( dbfTmpLin )->nFacCnv  := ( dbfArticulo )->nFacCnv
            end if

            /*
            Valores q arrastramos----------------------------------------------
				*/           

            ( dbfTmpLin )->cCodFam 		:= ( dbfArticulo )->Familia
            ( dbfTmpLin )->cGrpFam 		:= cGruFam( ( dbfTmpLin )->cCodFam, dbfFamilia )

            /*
            Datos de la cabecera-----------------------------------------------
            */

            ( dbfTmpLin )->cSerPed     := cSerPed
            ( dbfTmpLin )->nNumPed     := nNumPed
            ( dbfTmpLin )->cSufPed     := cSufPed
            ( dbfTmpLin )->nCanPed     := nCanPed
            ( dbfTmpLin )->dFecha      := dFecPed
            ( dbfTmpLin )->cTipMov     := cTipMov
            ( dbfTmpLin )->cAlmLin     := cAlmLin
            ( dbfTmpLin )->lIvaLin     := lIvaLin
            ( dbfTmpLin )->nComAge     := nComAge

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

            /*
            Propiedades de los kits-----------------------------------------
            */

            ( dbfTmpLin )->lImpLin     := lImprimirComponente( cCodArt, dbfArticulo )   // 1 Todos, 2 Compuesto, 3 Componentes
            ( dbfTmpLin )->lKitPrc     := lPreciosComponentes( cCodArt, dbfArticulo )

            ( dbfTmpLin )->nUniCaja    := nUniCaj * ( dbfKit )->nUndKit

            if ( dbfTmpLin )->lKitPrc
               ( dbfTmpLin )->nPreDiv  := nRetPreArt( nTarLin, aTmpPed[ _CDIVPED ], aTmpPed[ _LIVAINC ], dbfArticulo, dbfDiv, dbfKit, dbfIva )
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
               AppendKit( dbfTmpLin, aTmpPed )
            end if

            /*
            Avisaremos del stock bajo minimo--------------------------------------
            */

            if ( dbfArticulo)->lMsgVta .and. !uFieldEmpresa( "lNStkAct" ) .and. ( dbfArticulo)->nMinimo > 0

               nStkActual     := oStock:nStockAlmacen( ( dbfKit )->cRefKit, cAlmLin )
               nUnidades      := nUniCaj * ( dbfKit )->nUndKit

               do case
                  case nStkActual - nUnidades < 0

                       MsgStop( 	"No hay stock suficiente para realizar la venta" + CRLF + ;
                                 "del componente " + AllTrim( ( dbfKit )->cRefKit ) + " - " + AllTrim( ( dbfArticulo )->Nombre ),;
                                 "�Atenci�n!" )

                  case nStkActual - nUnidades < ( dbfArticulo)->nMinimo

                       MsgStop( 	"El stock del componente " + AllTrim( ( dbfKit )->cRefKit ) + " - " + AllTrim( ( dbfArticulo )->Nombre ) + CRLF + ;
                                 "est� bajo minimo." + CRLF + ;
                                 "Unidades a vender : " + AllTrim( Trans( nUnidades, MasUnd() ) ) + CRLF + ;
                                 "Stock minimo : " + AllTrim( Trans( ( dbfArticulo)->nMinimo, MasUnd() ) ) + CRLF + ;
                                 "Stock actual : " + AllTrim( Trans( nStkActual, MasUnd() ) ),;
                                 "�Atenci�n!" )

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
         nCalculo += aTmp[ _NVALIMP ] * NotCero( aTmp[ _NVOLUMEN ] )
      else
         nCalculo += aTmp[ _NVALIMP ]
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
      oMargen:cText( AllTrim( Trans( nMargen, cPorDiv ) + Space( 1 ) + AllTrim( cSimDiv( cCodDiv, dbfDiv ) ) + " : " + AllTrim( Trans( nRentabilidad, "999.99" ) ) + "%" ) )
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
   local nImpAtp     := 0
   local nImpOfe     := 0
   local nPrePro     := 0
   local nNumDto     := 0
   local cProveedor
   local lChgCodArt  := ( Empty( cOldCodArt ) .or. Rtrim( cOldCodArt ) != Rtrim( cCodArt ) )
   local nTarOld     := aTmp[ _NTARLIN ]
   local dFecPed 		:= aTmpPed[ _DFECPED ]
   local hAtipica

   DEFAULT lFocused  := .t.

   if !Empty( aTmpPed[ _DFECENT ] )
   	dFecPed 			:= aTmpPed[ _DFECENT ]
   end if 

   if Empty( cCodArt )

      if lRetCodArt()
         MsgStop( "No se pueden a�adir l�neas sin codificar" )
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

         hHas128                 := ReadCodeGS128( cCodArt )
         if !Empty( hHas128 )
            cCodArt              := uGetCodigo( hHas128, "01" )
            cLote                := uGetCodigo( hHas128, "10" )
         end if 

      end if 

      cCodArt                    := cSeekCodebar( cCodArt, dbfCodebar, dbfArticulo )

      if ( dbfArticulo )->( dbSeek( cCodArt ) ) .or. ( dbfArticulo )->( dbSeek( Upper( cCodArt ) ) )

         if ( dbfArticulo )->lObs
            MsgStop( "Art�culo catalogado como obsoleto" )
            return .f.
         end if

         // Entramos siempre que cambie el c�digo del art�culo-----------------

         if ( lChgCodArt )

            cCodArt              := ( dbfArticulo )->Codigo

            aGet[ _CREF ]:cText( Padr( cCodArt, 200 ) )
            aTmp[ _CREF ]        := cCodArt

            if ( dbfArticulo )->lMosCom .and. !Empty( ( dbfArticulo )->mComent )
               MsgStop( Trim( ( dbfArticulo )->mComent ) )
            end if

            /*
			Proveedor del art�culo---------------------------------------------
            */

            if !Empty( aGet[ _CCODPRV ] )
                aGet[ _CCODPRV ]:cText( ( dbfArticulo )->cPrvHab )
                aGet[ _CCODPRV ]:lValid()
            end if

            aTmp[ _CREFPRV ]  := Padr( cRefPrvArt( aTmp[ _CREF ], ( dbfArticulo )->cPrvHab , dbfArtPrv ) , 18 )

            /*
            Descripciones largas--------------------------------------------------
            */

            if !Empty( aGet[ _DESCRIP ] )
               aGet[ _DESCRIP ]:cText( ( dbfArticulo )->Descrip )
            else
               aTmp[ _DESCRIP ]     := ( dbfArticulo )->Descrip
            end if

            /*
            Lotes
            ---------------------------------------------------------------------
            */

            if ( dbfArticulo )->lLote

               aTmp[ _LLOTE ]       := ( dbfArticulo )->lLote

               if Empty( cLote )
                  cLote          	:= ( dbfArticulo )->cLote
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

            if ( dbfArticulo )->lKitArt

               aTmp[ _LKITART ]        := ( dbfArticulo )->lKitArt                        				// Marcamos como padre del kit
               aTmp[ _LIMPLIN ]        := lImprimirCompuesto( ( dbfArticulo )->Codigo, dbfArticulo ) 	// 1 Todos, 2 Compuesto
               aTmp[ _LKITPRC ]        := lPreciosCompuestos( ( dbfArticulo )->Codigo, dbfArticulo )	// 1 Todos, 2 Compuesto

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
            Coger el tipo de venta------------------------------------------------
            */

            aTmp[ _LMSGVTA ]        := ( dbfArticulo )->lMsgVta
            aTmp[ _LNOTVTA ]        := ( dbfArticulo )->lNotVta

            /*
            Cogemos las familias y los grupos de familias
            */

            cCodFam               	:= ( dbfArticulo )->Familia
            if !Empty( cCodFam )

               if !Empty( aGet[ _CCODFAM ] )
                  aGet[ _CCODFAM ]:cText( cCodFam )
                  aGet[ _CCODFAM ]:lValid()
               else
                  aTmp[ _CCODFAM ]  := cCodFam
               end if

               if !Empty( aGet[ _CGRPFAM ] )
                  aGet[ _CGRPFAM ]:cText( cGruFam( cCodFam, dbfFamilia ) )
                  aGet[ _CGRPFAM ]:lValid()
               else
                  aTmp[ _CGRPFAM ]  := cGruFam( cCodFam, dbfFamilia )
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
               aGet[ _CDETALLE ]:cText( ( dbfArticulo )->Nombre )
            else
               aTmp[ _CDETALLE ] := ( dbfArticulo )->Nombre
            end if

            if aGet[ _MLNGDES ] != nil
               aGet[ _MLNGDES ]:cText( ( dbfArticulo )->Descrip )
            else
               aTmp[ _MLNGDES ] := ( dbfArticulo )->Descrip
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
               aGet[ _CPESOKG  ]:cText( ( dbfArticulo )->cUndDim )
            else
               aGet[ _CPESOKG  ] := ( dbfArticulo )->cUndDim
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
            Tipo de articulo---------------------------------------------------
            */

            if !Empty( aGet[ _CCODTIP ] )
               aGet[ _CCODTIP ]:cText( ( dbfArticulo )->cCodTip )
            else
               aTmp[ _CCODTIP ] := ( dbfArticulo )->cCodTip
            end if

            if (dbfArticulo)->nCajEnt != 0
               aGet[ _NCANPED ]:cText( (dbfArticulo)->nCajEnt )
            end if

            if ( dbfArticulo )->nUniCaja != 0
               aGet[ _NUNICAJA ]:cText( ( dbfArticulo )->nUniCaja )
            end if

            /*
            Preguntamos si el regimen de " + cImp() + " es distinto de Exento
            */

            if aTmpPed[ _NREGIVA ] <= 1
               aGet[ _NIVA ]:cText( nIva( dbfIva, ( dbfArticulo )->TipoIva ) )
               aTmp[ _NREQ ]     := nReq( dbfIva, ( dbfArticulo )->TipoIva )
            end if

            /*
            Ahora recogemos el impuesto especial si lo hay
            */

            if !Empty( ( dbfArticulo )->cCodImp )
               aTmp[ _CCODIMP ]  := ( dbfArticulo )->cCodImp
               if !Empty( aGet[ _NVALIMP ] )
                  aGet[ _NVALIMP ]:cText( oNewImp:nValImp( ( dbfArticulo )->cCodImp, aTmpPed[ _LIVAINC ], aTmp[ _NIVA ] ) )
               else
                  aTmp[ _NVALIMP ]  := oNewImp:nValImp( ( dbfArticulo )->cCodImp, aTmpPed[ _LIVAINC ], aTmp[ _NIVA ] )
               end if

               aTmp[ _LVOLIMP ]     := RetFld( ( dbfArticulo )->cCodImp, oNewImp:oDbf:cAlias, "lIvaVol" )

            end if

            /*
            Buscamos si el articulo tiene factor de conversion--------------------
            */

            if ( dbfArticulo )->lFacCnv
               aTmp[ _NFACCNV ]     := ( dbfArticulo )->nFacCnv
            end if

            /*
            Si la comisi�n del articulo hacia el agente es distinto de cero----
            */

            aGet[ _NCOMAGE ]:cText( aTmpPed[ _NPCTCOMAGE ] )

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
            Tomamos el valor del stock y anotamos si nos dejan vender sin stock
            */

            if oStkAct != nil .and. !uFieldEmpresa( "lNStkAct" ) .and. aTmp[ _NCTLSTK ] <= 1
               oStock:nPutStockActual( aTmp[ _CREF ], aTmp[ _CALMLIN ], , , , aTmp[ _LKITART ], aTmp[ _NCTLSTK ], oStkAct )
            end if

            /*
            Buscamos la familia del articulo y anotamos las propiedades-----------
            */

            aTmp[_CCODPR1 ] := ( dbfArticulo )->cCodPrp1
            aTmp[_CCODPR2 ] := ( dbfArticulo )->cCodPrp2

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

               if !Empty( aGet[ _CVALPR1 ] ) .and. !Empty( oSayPr1 ) .and. !Empty( oSayVp1 )
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
                  oSayPr2:SetText( retProp( ( dbfArticulo )->cCodPrp2, dbfPro ) )
                  oSayPr2:show()
               end if

               if oSayVp2 != nil
                   oSayVp2:SetText( "" )
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

         end if

         /*
         He terminado de meter todo lo que no son precios ahora es cuando meter� los precios con todas las opciones posibles
         */

         cPrpArt              := aTmp[ _CCODPR1 ] + aTmp[ _CCODPR2 ] + aTmp[ _CVALPR1 ] + aTmp[ _CVALPR2 ]

         if ( lChgCodArt ) .or. ( cPrpArt != cOldPrpArt )

            if nMode == APPD_MODE
               cCodFam        := RetFamArt( aTmp[ _CREF ], dbfArticulo )
            else
               cCodFam        := aTmp[ _CCODFAM ]
            end if

            /*
            Cargamos el precio-------------------------------------------------
            */

            aTmp[ _NPVPREC ] := (dbfArticulo)->PvpRec

            if !Empty( aGet[_NPNTVER ] )
                aGet[ _NPNTVER ]:cText( ( dbfArticulo )->NPNTVER1 )
            else
                aTmp [ _NPNTVER ] :=  ( dbfArticulo )->NPNTVER1
            end if

            /*
            Cargamos los costos------------------------------------------------
            */

            if !uFieldEmpresa( "lCosAct" )
               nCosPro           := oStock:nCostoMedio( aTmp[ _CREF ], aTmp[ _CALMLIN ], aTmp[ _CCODPR1 ], aTmp[ _CVALPR1 ], aTmp[ _CCODPR2 ], aTmp[ _CVALPR2 ], aTmp[ _CLOTE ] )
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
            Descuento de art�culo----------------------------------------------
            */

            nNumDto              := RetFld( aTmpPed[ _CCODCLI ], TDataView():Clientes( nView ), "nDtoArt" )

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

            //Cargamos el precio del art�culo

            nPrePro           := nPrePro( aTmp[ _CREF ], aTmp[ _CCODPR1 ], aTmp[ _CVALPR1 ], aTmp[ _CCODPR2 ], aTmp[ _CVALPR2 ], aTmp[ _NTARLIN ], aTmpPed[ _LIVAINC ], dbfArtDiv, dbfTarPreL, aTmpPed[_CCODTAR] )

            if nPrePro == 0
               aGet[_NPREDIV]:cText( nRetPreArt( aTmp[ _NTARLIN ], aTmpPed[ _CDIVPED ], aTmpPed[ _LIVAINC ], dbfArticulo, dbfDiv, dbfKit, dbfIva ) )
            else
               aGet[_NPREDIV]:cText( nPrePro )
            end if

            if aTmp[ __LALQUILER ]
               aGet[ _NPREDIV ]:cText( 0 )
               aGet[ _NPREALQ ]:cText( nPreAlq( aTmp[ _CREF ], aTmp[ _NTARLIN ], aTmpPed[_LIVAINC], dbfArticulo ) )
            end if

            /*
            Usando tarifas-----------------------------------------------------
            */

            if !Empty( aTmpPed[_CCODTAR] )

               //--Precio--//
               nImpOfe     := RetPrcTar( aTmp[ _CREF ], aTmpPed[_CCODTAR], aTmp[_CCODPR1], aTmp[_CCODPR2], aTmp[_CVALPR1], aTmp[_CVALPR2], dbfTarPreL, aTmp[ _NTARLIN ] )
               if nImpOfe  != 0
                  aGet[_NPREDIV]:cText( nImpOfe )
               end if

               //--Descuento porcentual--//
               nImpOfe  := RetPctTar( aTmp[ _CREF ], cCodFam, aTmpPed[_CCODTAR], aTmp[_CCODPR1], aTmp[_CCODPR2], aTmp[_CVALPR1], aTmp[_CVALPR2], dbfTarPreL )
               if nImpOfe  != 0
                  aGet[_NDTO   ]:cText( nImpOfe )
               end if

               //--Descuento lineal--//
               nImpOfe  := RetLinTar( aTmp[ _CREF ], cCodFam, aTmpPed[_CCODTAR], aTmp[_CCODPR1], aTmp[_CCODPR2], aTmp[_CVALPR1], aTmp[_CVALPR2], dbfTarPreL )
               if nImpOfe != 0
                  aGet[_NDTODIV]:cText( nImpOfe )
               end if

               //--Comision de agente--//
               nImpOfe  := RetComTar( aTmp[ _CREF ], cCodFam, aTmpPed[_CCODTAR], aTmp[_CCODPR1], aTmp[_CCODPR2], aTmp[_CVALPR1], aTmp[_CVALPR2], aTmpPed[_CCODAGE], dbfTarPreL, dbfTarPreS )
               if nImpOfe != 0
                  aGet[_NCOMAGE ]:cText( nImpOfe )
               end if

               //--Descuento de promoci�n--//

               nImpOfe  := RetDtoPrm( aTmp[ _CREF ], cCodFam, aTmpPed[_CCODTAR], aTmp[_CCODPR1], aTmp[_CCODPR2], aTmp[_CVALPR1], aTmp[_CVALPR2], dFecPed, dbfTarPreL )
               if nImpOfe  != 0
                  aGet[_NDTOPRM]:cText( nImpOfe )
               end if

               //--Descuento de promocion para el agente--//

               nDtoAge  := RetDtoAge( aTmp[ _CREF ], cCodFam, aTmpPed[_CCODTAR], aTmp[_CCODPR1], aTmp[_CCODPR2], aTmp[_CVALPR1], aTmp[_CVALPR2], dFecPed, aTmpPed[_CCODAGE], dbfTarPreL, dbfTarPreS )
               if nDtoAge  != 0
                  aGet[ _NCOMAGE ]:cText( nDtoAge )
               end if

            end if

            /*
            Chequeamos las atipicas del cliente--------------------------------
            */

            hAtipica := hAtipica( hValue( aTmp, aTmpPed ) )

            if !Empty( hAtipica )
               
               	if hhaskey( hAtipica, "nImporte" )
               		if hAtipica[ "nImporte" ] != 0
                  		aGet[ _NPREDIV ]:cText( hAtipica[ "nImporte" ] )
                	end if
               	end if

               	if hhaskey( hAtipica, "nDescuentoPorcentual" ) .and. aTmp[ _NDTO ] == 0
               		if hAtipica[ "nDescuentoPorcentual"] != 0
                  		aGet[ _NDTO ]:cText( hAtipica[ "nDescuentoPorcentual"] )   
                  	end if	
               	end if

               	if hhaskey( hAtipica, "nDescuentoPromocional" ) .and. aTmp[ _NDTOPRM ] == 0
               		if hAtipica[ "nDescuentoPromocional" ] != 0
                  		aGet[ _NDTOPRM ]:cText( hAtipica[ "nDescuentoPromocional" ] )
                  	end if	
               	end if

               	if hhaskey( hAtipica, "nComisionAgente" ) .and. aTmp[ _NCOMAGE ] == 0
                  	if hAtipica[ "nComisionAgente" ] != 0
                  		aGet[ _NCOMAGE ]:cText( hAtipica[ "nComisionAgente" ] )
                  	end if
               	end if

               	if hhaskey( hAtipica, "nDescuentoLineal" ) .and. aTmp[ _NDTODIV ] == 0
               		if hAtipica[ "nDescuentoLineal" ] != 0
                  		aGet[ _NDTODIV ]:cText( hAtipica[ "nDescuentoLineal" ] )
                  	end if
               	end if

            end if

            //--Buscamos si existen ofertas para este articulo y le cambiamos el precio--//

            nImpOfe     := nImpOferta( aTmp[ _CREF ], aTmpPed[ _CCODCLI ], aTmpPed[ _CCODGRP ], aTmp[ _NUNICAJA ], dFecPed, dbfOferta, aTmp[ _NTARLIN ], , aTmp[ _CCODPR1 ], aTmp[_CCODPR2], aTmp[_CVALPR1], aTmp[_CVALPR2] )
            if nImpOfe  != 0
               aGet[ _NPREDIV ]:cText( nImpOfe )
            end if

            //--Buscamos si existen descuentos en las ofertas--//

            nImpOfe     := nDtoOferta( aTmp[ _CREF ], aTmpPed[ _CCODCLI ], aTmpPed[ _CCODGRP ], aTmp[ _NUNICAJA ], dFecPed, dbfOferta, aTmp[_CCODPR1], aTmp[_CCODPR2], aTmp[_CVALPR1], aTmp[_CVALPR2] )
            if nImpOfe  != 0
               aGet[ _NDTO ]:cText( nImpOfe )
            end if

            //--Buscamos si existen descuentos lineales en las ofertas--//

            nImpOfe     := nDtoLineal( aTmp[ _CREF ], aTmpPed[ _CCODCLI ], aTmpPed[ _CCODGRP ], aTmp[ _NUNICAJA ], dFecPed, dbfOferta, aTmp[_CCODPR1], aTmp[_CCODPR2], aTmp[_CVALPR1], aTmp[_CVALPR2] )
            if nImpOfe  != 0
               if !Empty( aGet[ _NDTODIV ] )
                  aGet[ _NDTODIV ]:cText( nImpOfe )
               else
                  aGet[ _NDTODIV ]  := nImpOfe
               end if
            end if

            ValidaMedicion( aTmp, aGet )

         end if

         /*
         Buscamos si hay ofertas-----------------------------------------------
         */

         lBuscaOferta( aTmp[ _CREF ], aGet, aTmp, aTmpPed, dbfOferta, dbfArticulo, dbfDiv, dbfKit, dbfIva  )

         /*
         Cargamos los valores para los cambios---------------------------------
         */

         cOldPrpArt := cPrpArt
         cOldCodArt := cCodArt

         /*
         Solo pueden modificar los precios los administradores--------------
         */

         if Empty( aTmp[ _NPREDIV ] ) .or. lUsrMaster() .or. oUser():lCambiarPrecio()

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

         MsgStop( "Art�culo no encontrado" )
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

   if ( dbfPedCliL )->( dbSeek( cNumPed ) )

      while ( dbfPedCliL )->cSerPed + Str( ( dbfPedCliL )->nNumPed ) + ( dbfPedCliL )->cSufPed == cNumPed .and. !( dbfPedCliL )->( Eof() )

      	/*
      	Las lineas hijas no pintan nada---------------------------------------
      	*/

   		if !( dbfPedCliL )->lKitChl

	         do case
   	         case ( dbfPedCliL )->nProduc == 0 	// No se ha producido nada

   	         	if nEstado == 3
    	         		nEstado  := 2
    	         		exit 
    	         	end if 

   	         case ( dbfPedCliL )->nProduc == 1 	// Producido parcialmente

    	         	nEstado  	:= 2
    	         	exit 

	            case ( dbfPedCliL )->nProduc == 2 	// Linea producida

   	            nEstado  	:= 3

      	   end case

         end if 

         ( dbfPedCliL )->( dbSkip() )

      end while

   end if

Return ( nEstado )

//---------------------------------------------------------------------------//

Static Function cEstadoProduccion( cNumPed )

Return ( aEstadoProduccion[ Max( Min( nEstadoProduccion( cNumPed ), 3 ), 1 ) ] )


//---------------------------------------------------------------------------//

Static Function ChangePedidosWeb()

   /*
   A�adimos desde el fichero de lineas-----------------------------------------
	*/

   ( dbfTmpLin )->( __dbZap() )

   if ( dbfPedCliL )->( dbSeek( ( TDataView():PedidosClientes( nView ) )->cSerPed + Str( ( TDataView():PedidosClientes( nView ) )->nNumPed ) + ( TDataView():PedidosClientes( nView ) )->cSufPed ) )

      while ( ( dbfPedCliL )->cSerPed + Str( ( dbfPedCliL )->nNumPed ) + ( dbfPedCliL )->cSufPed == ( TDataView():PedidosClientes( nView ) )->cSerPed + Str( ( TDataView():PedidosClientes( nView ) )->nNumPed ) + ( TDataView():PedidosClientes( nView ) )->cSufPed ) .AND. ( dbfPedCliL )->( !eof() )

         dbPass( dbfPedCliL, dbfTmpLin, .t. )

         ( dbfPedCliL )->( dbSkip() )

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

   oBoton                     := TDotNetButton():New( 60, oGrupo, "Procesar32",        "Procesar",       1, {|| oDlgPedidosWeb:End( IDOK ) }, , , .f., .f., .f. )
   oBoton                     := TDotNetButton():New( 60, oGrupo, "Garbage_Empty_32",  "Eliminar",       2, {|| WinDelRec( oBrwPedidosWeb, TDataView():PedidosClientes( nView ), {|| QuiPedCli() } ), ChangePedidosWeb() } , , , .f., .f., .f. )

   oGrupo                     := TDotNetGroup():New( oCarpeta, 66, "Salir", .f. )

   oBoton                     := TDotNetButton():New( 60, oGrupo, "End32",             "Salida",         1, {|| oDlgPedidosWeb:End() }, , , .f., .f., .f. )

   ChangePedidosWeb()

Return ( nil )

//---------------------------------------------------------------------------//

Static Function YearComboBoxChange()

	 if oWndBrw:oWndBar:lAllYearComboBox()
		DestroyFastFilter( TDataView():PedidosClientes( nView ) )
      CreateUserFilter( "", TDataView():PedidosClientes( nView ), .f., , , "all" )
	 else
		DestroyFastFilter( TDataView():PedidosClientes( nView ) )
      CreateUserFilter( "Year( Field->dFecPed ) == " + oWndBrw:oWndBar:cYearComboBox(), TDataView():PedidosClientes( nView ), .f., , , "Year( Field->dFecPed ) == " + oWndBrw:oWndBar:cYearComboBox() )
	 end if

	 ( TDataView():PedidosClientes( nView ) )->( dbGoTop() )

	 oWndBrw:Refresh()

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

static function lBuscaOferta( cCodArt, aGet, aTmp, aTmpPed, dbfOferta, dbfArticulo, dbfDiv, dbfKit, dbfIva  )

   local sOfeArt
   local nTotalLinea    := 0
   local dFecPed 			:= aTmpPed[ _DFECPED ]

   if !Empty( aTmpPed[ _DFECENT ] )
   	dFecPed 				:= aTmpPed[ _DFECENT ]
   end if

   if ( dbfArticulo )->Codigo == cCodArt .or. ( dbfArticulo )->( dbSeek( cCodArt ) )

      /*
      Buscamos si existen ofertas por art�culo----------------------------
      */

      nTotalLinea := RecalculaLinea( aTmp, aTmpPed, nDouDiv, , , , aTmpPed[ _CDIVPED ], .t. )

      sOfeArt     := sOfertaArticulo( cCodArt, aTmpPed[ _CCODCLI ], aTmpPed[ _CCODGRP ], aTmp[ _NUNICAJA ], dFecPed, dbfOferta, aTmp[ _NTARLIN ], , aTmp[_CCODPR1], aTmp[_CCODPR2], aTmp[_CVALPR1], aTmp[_CVALPR2], aTmp[ _CDIVPED ], dbfArticulo, dbfDiv, dbfKit, dbfIva, aTmp[ _NCANPED ], nTotalLinea )

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

         sOfeArt     := sOfertaFamilia( ( dbfArticulo )->Familia, aTmpPed[ _CCODCLI ], aTmpPed[ _CCODGRP ], dFecPed, dbfOferta, aTmp[ _NTARLIN ], dbfArticulo, aTmp[ _NUNICAJA ], aTmp[ _NCANPED ], nTotalLinea )

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

         sOfeArt     := sOfertaTipoArticulo( ( dbfArticulo )->cCodTip, aTmpPed[ _CCODCLI ], aTmpPed[ _CCODGRP ], dFecPed, dbfOferta, aTmp[ _NTARLIN ], dbfArticulo, aTmp[ _NUNICAJA ], aTmp[ _NCANPED ], nTotalLinea )

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

         sOfeArt     := sOfertaCategoria( ( dbfArticulo )->cCodCate, aTmpPed[ _CCODCLI ], aTmpPed[ _CCODGRP ], dFecPed, dbfOferta, aTmp[ _NTARLIN ], dbfArticulo, aTmp[ _NUNICAJA ], aTmp[ _NCANPED ], nTotalLinea )

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

         sOfeArt     := sOfertaTemporada( ( dbfArticulo )->cCodTemp, aTmpPed[ _CCODCLI ], aTmpPed[ _CCODGRP ], dFecPed, dbfOferta, aTmp[ _NTARLIN ], dbfArticulo, aTmp[ _NUNICAJA ], aTmp[ _NCANPED ], nTotalLinea )

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

         sOfeArt     := sOfertaFabricante( ( dbfArticulo )->cCodFab, aTmpPed[ _CCODCLI ], aTmpPed[ _CCODGRP ], dFecPed, dbfOferta, aTmp[ _NTARLIN ], dbfArticulo, aTmp[ _NUNICAJA ], aTmp[ _NCANPED ], nTotalLinea )

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
   Controlamos que no nos pase c�digo de cliente vac�o------------------------
   */

   if Empty( aTmpPed[ _CCODCLI ] )
      MsgStop( "C�digo de cliente no puede estar vac�o para utilizar el asistente." )
      Return .f.
   end if

   /*
   Controlamos que el cliente tenga atipicas----------------------------------
   */

   nOrder            := ( TDataView():Atipicas( nView ) )->( OrdSetFocus( "cCodCli" ) )

   if ( TDataView():Atipicas( nView ) )->( dbSeek( aTmpPed[ _CCODCLI ] ) )

      AutoMeterDialog( oDlg )

      SetTotalAutoMeterDialog( ( TDataView():Atipicas( nView ) )->( LastRec() ) )

      while ( TDataView():Atipicas( nView ) )->cCodCli == aTmpPed[ _CCODCLI ] .and. !( TDataView():Atipicas( nView ) )->( Eof() )

         if lConditionAtipica( nil, TDataView():Atipicas( nView ) ) .and. ( TDataView():Atipicas( nView ) )->lAplPed

            AppendDatosAtipicas( aTmpPed )

         end if

         SetAutoMeterDialog( ( TDataView():Atipicas( nView ) )->( Recno() ) )

         ( TDataView():Atipicas( nView ) )->( dbSkip() )

      end while

      EndAutoMeterDialog( ( TDataView():Atipicas( nView ) )->( LastRec() ) )

   end if

   /*
   Controlamos el grupo del cliente tenga atipicas----------------------------------
   */

   if !lSearch

      ( TDataView():Atipicas( nView ) )->( OrdSetFocus( "cCodGrp" ) )
   
      if ( TDataView():Atipicas( nView ) )->( dbSeek( aTmpPed[ _CCODGRP ] ) )

         AutoMeterDialog( oDlg )

         SetTotalAutoMeterDialog( ( TDataView():Atipicas( nView ) )->( LastRec() ) )
   
         while ( TDataView():Atipicas( nView ) )->cCodGrp == aTmpPed[ _CCODGRP ] .and. !( TDataView():Atipicas( nView ) )->( Eof() )
   
            if lConditionAtipica( nil, TDataView():Atipicas( nView ) ) .and. ( TDataView():Atipicas( nView ) )->lAplAlb
   
               AppendDatosAtipicas( aTmpPed )
   
            end if

            SetAutoMeterDialog( ( TDataView():Atipicas( nView ) )->( Recno() ) )
   
            ( TDataView():Atipicas( nView ) )->( dbSkip() )
   
         end while

         EndAutoMeterDialog( ( TDataView():Atipicas( nView ) )->( LastRec() ) )
   
      end if
   
      ( TDataView():Atipicas( nView ) )->( OrdSetFocus( nOrder ) )

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

   if !dbSeekInOrd( ( TDataView():Atipicas( nView ) )->cCodArt, "cRef", dbfTmpLin )
      
      if ( dbfArticulo )->( dbSeek( ( TDataView():Atipicas( nView ) )->cCodArt ) ) .and.;
         !( dbfArticulo )->lObs

         ( dbfTmpLin )->( dbAppend() )

         ( dbfTmpLin )->nNumLin        := nLastNum( dbfTmpLin )
         ( dbfTmpLin )->cRef           := ( TDataView():Atipicas( nView ) )->cCodArt
         ( dbfTmpLin )->cCodPr1        := ( TDataView():Atipicas( nView ) )->cCodPr1
         ( dbfTmpLin )->cCodPr2        := ( TDataView():Atipicas( nView ) )->cCodPr2
         ( dbfTmpLin )->cValPr1        := ( TDataView():Atipicas( nView ) )->cValPr1
         ( dbfTmpLin )->cValPr2        := ( TDataView():Atipicas( nView ) )->cValPr2
         ( dbfTmpLin )->nCosDiv        := ( TDataView():Atipicas( nView ) )->nPrcCom
         ( dbfTmpLin )->cAlmLin        := aTmpPed[ _CCODALM ]
         ( dbfTmpLin )->lIvaLin        := aTmpPed[ _LIVAINC ]
         ( dbfTmpLin )->nTarLin        := aTmpPed[ _NTARIFA ]
         ( dbfTmpLin )->nCanEnt        := 1
         ( dbfTmpLin )->nUniCaja       := 0
         ( dbfTmpLin )->lFromAtp       := .t.
   
         //Datos de la tabla de art�culo------------------------------------

         ( dbfTmpLin )->cDetalle       := ( dbfArticulo )->Nombre
         
         if aTmpPed[ _NREGIVA ] <= 1
            ( dbfTmpLin )->nIva        := nIva( dbfIva, ( dbfArticulo )->TipoIva )
         end if
           
         ( dbfTmpLin )->cUnidad        := ( dbfArticulo )->cUnidad
         ( dbfTmpLin )->nCtlStk        := ( dbfArticulo )->nCtlStock
         ( dbfTmpLin )->lLote          := ( dbfArticulo )->lLote
         ( dbfTmpLin )->lMsgVta        := ( dbfArticulo )->lMsgVta
         ( dbfTmpLin )->lNotVta        := ( dbfArticulo )->lNotVta
         ( dbfTmpLin )->cCodTip        := ( dbfArticulo )->cCodTip
         ( dbfTmpLin )->cCodFam        := ( dbfArticulo )->Familia
         ( dbfTmpLin )->nPesoKg        := ( dbfArticulo )->nPesoKg
   
         ( dbfTmpLin )->dFecUltCom     := dFechaUltimaVenta( aTmpPed[ _CCODCLI ], ( TDataView():Atipicas( nView ) )->cCodArt, dbfAlbCliL, dbfFacCliL )
         ( dbfTmpLin )->nUniUltCom     := nUnidadesUltimaVenta( aTmpPed[ _CCODCLI ], ( TDataView():Atipicas( nView ) )->cCodArt, dbfAlbCliL, dbfFacCliL )

         /*
         Vamos a por los catos de la tarifa
         */      

         hAtipica := hAtipica( hValue( dbfTmpLin, aTmpPed ) )

         if !Empty( hAtipica )
               
            if hhaskey( hAtipica, "nImporte" )
               if hAtipica[ "nImporte" ] != 0
                  ( dbfTmpLin )->nPreDiv    := hAtipica[ "nImporte" ]
               else 
                  ( dbfTmpLin )->nPreDiv    := nRetPreArt( ( dbfTmpLin )->nTarLin, aTmpPed[ _CDIVPED ], aTmpPed[ _LIVAINC ], dbfArticulo, dbfDiv, dbfKit, dbfIva )
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
            	nRetPreArt( ( dbfTmpLin )->nTarLin, aTmpPed[ _CDIVPED ], aTmpPed[ _LIVAINC ], dbfArticulo, dbfDiv, dbfKit, dbfIva )
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
         hValue[ "nCajas"            ] := aTmp[ _NCANENT ]
         hValue[ "nUnidades"         ] := aTmp[ _NUNICAJA ]

      case ValType( aTmp ) == "C"

         hValue[ "cCodigoArticulo"   ] := ( aTmp )->cRef
         hValue[ "cCodigoPropiedad1" ] := ( aTmp )->cCodPr1
         hValue[ "cCodigoPropiedad2" ] := ( aTmp )->cCodPr2
         hValue[ "cValorPropiedad1"  ] := ( aTmp )->cValPr1
         hValue[ "cValorPropiedad2"  ] := ( aTmp )->cValPr2
         hValue[ "cCodigoFamilia"    ] := ( aTmp )->cCodFam
         hValue[ "nTarifaPrecio"     ] := ( aTmp )->nTarLin         
         hValue[ "nCajas"            ] := ( aTmp )->nCanEnt
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

   oPrinter:Serie(      ( TDataView():PedidosClientes( nView ) )->cSerPed )
   oPrinter:Documento(  ( TDataView():PedidosClientes( nView ) )->nNumPed )
   oPrinter:Sufijo(     ( TDataView():PedidosClientes( nView ) )->cSufPed )

   if lExt

      oPrinter:oFechaInicio:cText( ( TDataView():PedidosClientes( nView ) )->dFecPed )
      oPrinter:oFechaFin:cText( ( TDataView():PedidosClientes( nView ) )->dFecPed )

   end if

   oPrinter:oFormatoDocumento:TypeDocumento( "PC" )   

   // Formato de documento-----------------------------------------------------

   cFormato          := cFormatoDocumento( ( TDataView():PedidosClientes( nView ) )->cSerPed, "nPedCli", TDataView():Contadores( nView ) )
   if empty( cFormato )
      cFormato       := cFirstDoc( "PC", TDataView():Documentos( nView ) )
   end if
   oPrinter:oFormatoDocumento:cText( cFormato )

   // Codeblocks para que trabaje----------------------------------------------

   aStatus           := TDataview():GetInitStatus( "PedCliT", nView )

   oPrinter:bInit    := {||   ( TDataview():PedidosClientes( nView ) )->( dbSeek( oPrinter:DocumentoInicio(), .t. ) ) }

   oPrinter:bWhile   := {||   oPrinter:InRangeDocumento( TDataView():PedidosClientesId( nView ) )                  .and. ;
                              ( TDataView():PedidosClientes( nView ) )->( !eof() ) }

   oPrinter:bFor     := {||   oPrinter:InRangeFecha( ( TDataView():PedidosClientes( nView ) )->dFecPed )           .and. ;
                              oPrinter:InRangeCliente( ( TDataView():PedidosClientes( nView ) )->cCodCli )         .and. ;
                              oPrinter:InRangeGrupoCliente( retGrpCli( ( TDataView():PedidosClientes( nView ) )->cCodCli, TDataView():Clientes( nView ) ) ) }

   oPrinter:bSkip    := {||   ( TDataView():PedidosClientes( nView ) )->( dbSkip() ) }

   oPrinter:bAction  := {||   GenPedCli( nDevice, "Imprimiendo documento : " + TDataView():PedidosClientesId( nView ), oPrinter:oFormatoDocumento:uGetValue, oPrinter:oImpresora:uGetValue, oPrinter:oCopias:uGetValue ) }

   oPrinter:bStart   := {||   if( lExt, oPrinter:DisableRange(), ) }

   // Abrimos el dialogo-------------------------------------------------------

   oPrinter:Resource():End()

   // Restore -----------------------------------------------------------------

   TDataview():SetStatus( "PedCliT", nView, aStatus )
   
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
Funci�n creada para ejecutar el modo pedidos web desde la web de fondo del rograma
*/

FUNCTION PedCliWeb()

   PedCli( "01056", oWnd(), nil, nil, nil, .t. )

Return .t.

//--------------------------------------------------------------------------//

FUNCTION aTotPedCli( cPed, cPedCliT, dbfPedCliL, dbfIva, dbfDiv, dbfFPago, cDivRet )

   nTotPedCli( cPed, cPedCliT, dbfPedCliL, dbfIva, dbfDiv, dbfFPago, nil, cDivRet, .f. )

RETURN ( { nTotNet, nTotIva, nTotReq, nTotPed, nTotPnt, nTotTrn, nTotAge, nTotCos } )

//--------------------------------------------------------------------------//

FUNCTION BrwPedCli( oGet, cPedCliT, dbfPedCliL, dbfIva, dbfDiv, dbfFPago, oIva )

	local oDlg
	local oBrw
	local oGet1
	local cGet1
	local nOrd     := GetBrwOpt( "BrwPedCli" )
	local nOrdAnt
	local nRecAnt
	local oCbxOrd
	local aCbxOrd  := { "N�mero", "Fecha", "Cliente", "Nombre" }
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
         :SetCheck( { "Bullet_Square_Yellow_16", "Bullet_Square_Red_16" } )
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Tipo"
         :bEditValue       := {|| aTipPed[ if( ( cPedCliT )->lAlquiler, 2, 1  ) ] }
         :nWidth           := 50
         :lHide            := .t.
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "N�mero"
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
        :cHeader          	:= "Importe"
        :bEditValue       	:= {|| ( cPedCliT )->nTotPed }
		:cEditPicture     	:= cPorDiv()
        :nWidth           	:= 80
        :nDataStrAlign    	:= 1
        :nHeadStrAlign    	:= 1
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

FUNCTION nImpUPedCli( uPedCliT, dbfPedCliL, nDec, nVdv, cPouDiv )

   local nCalculo
   local lIvaInc

   DEFAULT nDec      := 0
   DEFAULT nVdv      := 1

   nCalculo          := nTotUPedCli( dbfPedCliL, nDec, nVdv )

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

   if ( dbfPedCliL )->nIva != 0 .and. !lIvaInc
      nCalculo    	 += Round( nCalculo * ( dbfPedCliL )->nIva / 100, nDec )
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

   DEFAULT cPedCliL  := dbfPedCliL

RETURN ( Descrip( cPedCliL ) )

//---------------------------------------------------------------------------//

FUNCTION nIvaLPedCli( dbfLin, nDec, nRouDec, nVdv, lDto, lPntVer, lImpTrn, cPouDiv )

   local nCalculo 	:= nTotLPedCli( dbfLin, nDec, nRouDec, nVdv, lDto, lPntVer, lImpTrn, cPouDiv )

   if !( dbfLin )->lIvaLin
      nCalculo       := nCalculo * ( dbfLin )->nIva / 100
   else
      nCalculo       -= nCalculo / ( 1 + ( dbfLin )->nIva / 100 )
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
         C�digo de grupo-------------------------------------------------------
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

         if aTmp[ _LALQUILER ]
            oTipPed:Select( 2 )
         else
            oTipPed:Select( 1 )
         end if

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
      msgWait( "No existe el fichero " + cFilEdm, "Atenci�n", 1 )
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

      if ( TDataView():Clientes( nView ) )->( dbSeek( cCodCli ) )

         nNumPed                    := nNewDoc( ( TDataView():Clientes( nView ) )->Serie, TDataView():PedidosClientes( nView ), "NPEDCLI", , dbfCount )
         ( TDataView():PedidosClientes( nView ) )->( dbAppend() )
         ( TDataView():PedidosClientes( nView ) )->cSerPed    := ( TDataView():Clientes( nView ) )->Serie
         ( TDataView():PedidosClientes( nView ) )->cSufPed    := RetSufEmp()
         ( TDataView():PedidosClientes( nView ) )->nNumPed    := nNumPed
         ( TDataView():PedidosClientes( nView ) )->dFecPed    := dFecPed
         ( TDataView():PedidosClientes( nView ) )->cCodAlm    := oUser():cAlmacen()
         ( TDataView():PedidosClientes( nView ) )->cDivPed    := cDivEmp()
         ( TDataView():PedidosClientes( nView ) )->nVdvPed    := nChgDiv( ( TDataView():PedidosClientes( nView ) )->cDivPed, dbfDiv )
         ( TDataView():PedidosClientes( nView ) )->nEstado    := 1
         ( TDataView():PedidosClientes( nView ) )->cCodCli    := ( TDataView():Clientes( nView ) )->Cod
         ( TDataView():PedidosClientes( nView ) )->cNomCli    := ( TDataView():Clientes( nView ) )->Titulo
         ( TDataView():PedidosClientes( nView ) )->cDirCli    := ( TDataView():Clientes( nView ) )->Domicilio
         ( TDataView():PedidosClientes( nView ) )->cPobCli    := ( TDataView():Clientes( nView ) )->Poblacion
         ( TDataView():PedidosClientes( nView ) )->cPrvCli    := ( TDataView():Clientes( nView ) )->Provincia
         ( TDataView():PedidosClientes( nView ) )->cPosCli    := ( TDataView():Clientes( nView ) )->CodPostal
         ( TDataView():PedidosClientes( nView ) )->cDniCli    := ( TDataView():Clientes( nView ) )->Nif
         ( TDataView():PedidosClientes( nView ) )->cCodTar    := ( TDataView():Clientes( nView ) )->cCodTar
         ( TDataView():PedidosClientes( nView ) )->cCodPgo    := ( TDataView():Clientes( nView ) )->CodPago
         ( TDataView():PedidosClientes( nView ) )->cCodAge    := ( TDataView():Clientes( nView ) )->cAgente
         ( TDataView():PedidosClientes( nView ) )->cCodRut    := ( TDataView():Clientes( nView ) )->cCodRut
         ( TDataView():PedidosClientes( nView ) )->nTarifa    := ( TDataView():Clientes( nView ) )->nTarifa
         ( TDataView():PedidosClientes( nView ) )->lRecargo   := ( TDataView():Clientes( nView ) )->lReq
         ( TDataView():PedidosClientes( nView ) )->lOperPv    := ( TDataView():Clientes( nView ) )->lPntVer
         ( TDataView():PedidosClientes( nView ) )->cDtoEsp    := ( TDataView():Clientes( nView ) )->cDtoEsp
         ( TDataView():PedidosClientes( nView ) )->cDpp       := ( TDataView():Clientes( nView ) )->cDpp
         ( TDataView():PedidosClientes( nView ) )->nDtoEsp    := ( TDataView():Clientes( nView ) )->nDtoEsp
         ( TDataView():PedidosClientes( nView ) )->nDpp       := ( TDataView():Clientes( nView ) )->nDpp
         ( TDataView():PedidosClientes( nView ) )->nDtoCnt    := ( TDataView():Clientes( nView ) )->nDtoCnt
         ( TDataView():PedidosClientes( nView ) )->nDtoRap    := ( TDataView():Clientes( nView ) )->nDtoRap
         ( TDataView():PedidosClientes( nView ) )->nDtoUno    := ( TDataView():Clientes( nView ) )->nDtoCnt
         ( TDataView():PedidosClientes( nView ) )->nDtoDos    := ( TDataView():Clientes( nView ) )->nDtoRap

         aAdd( aSucces, { .f., "Nuevo pedido de clientes " + ( TDataView():PedidosClientes( nView ) )->cSerPed + "/" + Str( ( TDataView():PedidosClientes( nView ) )->nNumPed ) + "/" + ( TDataView():PedidosClientes( nView ) )->cSufPed } )

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

         ( dbfPedCliL )->( dbAppend() )
         ( dbfPedCliL )->cSerPed := ( TDataView():PedidosClientes( nView ) )->cSerPed
         ( dbfPedCliL )->nNumPed := ( TDataView():PedidosClientes( nView ) )->nNumPed
         ( dbfPedCliL )->cSufPed := ( TDataView():PedidosClientes( nView ) )->cSufPed
         ( dbfPedCliL )->cRef    := Ltrim( SubStr( cLine, 18, 13 ) )
         ( dbfPedCliL )->cDetalle:= RetFld( ( dbfPedCliL )->cRef, dbfArticulo )
         ( dbfPedCliL )->nPreDiv := Val( SubStr( cLine, 31,  7 ) )
         ( dbfPedClil )->nDtoDiv := Val( SubStr( cLine, 38,  4 ) )
         ( dbfPedClil )->nDto    := Val( SubStr( cLine, 42,  5 ) )
         ( dbfPedClil )->nCanPed := Val( SubStr( cLine, 47,  4 ) )
         ( dbfPedClil )->nUniCaja:= Val( SubStr( cLine, 51,  7 ) )

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

FUNCTION nDtoAtpPedCli( uPedCliT, dbfPedCliL, nDec, nRou, nVdv, lPntVer, lImpTrn )

   local nCalculo
   local nDtoAtp     := 0

   DEFAULT nDec      := 0
   DEFAULT nRou      := 0
   DEFAULT nVdv      := 1
   DEFAULT lPntVer   := .f.
   DEFAULT lImpTrn   := .f.

   nCalculo          := nTotLPedCli( dbfPedCliL, nDec, nRou, nVdv, .t., lImpTrn, lPntVer )

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

   local bWhile
   local nRec     := ( dbfPedCliR )->( Recno() )
   local nTotRes  := 0

   if cPedido == nil
      bWhile      := {|| !( dbfPedCliR )->( eof() ) }
      ( dbfPedCliR )->( dbGoTop() )
   else
      bWhile      := {|| cPedido + ( dbfPedCliR )->cRef + ( dbfPedCliR )->cValPr1 + ( dbfPedCliR )->cValPr2 == cPedido + cRef + cValPr1 + cValPr2 .and. !( dbfPedCliR )->( eof() ) }
      ( dbfPedCliR )->( dbSeek( cPedido + cRef + cValPr1 + cValPr2 ) )
   end if

   while Eval( bWhile )

      nTotRes     += nTotNResCli( dbfPedCliR )

      ( dbfPedCliR )->( dbSkip() )

   end while

   ( dbfPedCliR )->( dbGoTo( nRec ) )

return ( nTotRes )

//---------------------------------------------------------------------------//

function dFecPdtRec( cPedido, cRef, cValPr1, cValPr2, dbfPedCliR )

   local dFecAct  := Ctod( "" )
   local nRec     := ( dbfPedCliR )->( Recno() )

   if ( dbfPedCliR )->( dbSeek( cPedido + cRef + cValPr1 + cValPr2 ) )

      while ( dbfPedCliR )->cSerPed + Str( ( dbfPedCliR )->nNumPed ) + ( dbfPedCliR )->cSufPed == cPedido .and.  !( dbfPedCliR )->( eof() )

         if Empty( dFecAct ) .or. dFecAct > ( dbfPedCliR )->dFecRes
            dFecAct  := ( dbfPedCliR )->dFecRes
         end if

         ( dbfPedCliR )->( dbSkip() )

      end while

   end if

   ( dbfPedCliR )->( dbGoTo( nRec ) )

return ( dFecAct )

//-----------------------------------------------------------------------------//

function dTmpPdtRec( cRef, cValPr1, cValPr2, dbfPedCliR )

   local dFecAct  := Ctod( "" )
   local nRec     := ( dbfPedCliR )->( Recno() )

   ( dbfPedCliR )->( dbGoTop() )
   while !( dbfPedCliR )->( eof() )

      if ( dbfPedCliR )->cRef == cRef .and. ( dbfPedCliR )->cValPr1 == cValPr1 .and. ( dbfPedCliR )->cValPr2 == cValPr2

         if Empty( dFecAct ) .or. dFecAct > ( dbfPedCliR )->dFecRes
            dFecAct  := ( dbfPedCliR )->dFecRes
         end if

      end if

      ( dbfPedCliR )->( dbSkip() )

   end while

   ( dbfPedCliR )->( dbGoTo( nRec ) )

return ( dFecAct )

//-----------------------------------------------------------------------------//

FUNCTION dFecPedCli( cPedCli, cPedCliT )

   local dFecPed  := CtoD("")

   IF ( cPedCliT )->( dbSeek( cPedCli ) )
      dFecPed  := ( cPedCliT )->dFecPed
   END IF

RETURN ( dFecPed )

//---------------------------------------------------------------------------//

/*FUNCTION nEstPedCli( cPedCli, cPedCliT )

   local nEstPed  := 1

   IF ( cPedCliT )->( dbSeek( cPedCli ) )
      nEstPed     := ( cPedCliT )->nEstado
   END IF

RETURN ( nEstPed )*/

//---------------------------------------------------------------------------//

FUNCTION cNbrPedCli( cPedCli, cPedCliT )

   local cNomCli  := ""

   IF ( cPedCliT )->( dbSeek( cPedCli ) )
      cNomCli  := ( cPedCliT )->CNOMCLI
	END IF

RETURN ( cNomCli )

//----------------------------------------------------------------------------//

/*
Actualiza pedido a clientes
*/

/*FUNCTION ActPedCli( nAlbCli, oStock, cPedCliT, dbfPedCliL, dbfAlbCliT, dbfAlbCliL, lInc )

   local nEstPed  := 2
   local aPedCliT := aGetStatus( cPedCliT, 1 )
   local aPedCliL := aGetStatus( dbfPedCliL, 1 )
   local aAlbCliT := aGetStatus( dbfAlbCliT, 1 )
   local aAlbCliL := aGetStatus( dbfAlbCliL, 1 )

   DEFAULT lInc   := .t.

   //Nos posicionamos en el albaran de Proveedor

   IF ( dbfAlbCliT )->( dbSeek( nAlbCli ) )                 .and. ;     // posicionamos en albaran proveedores
      ( dbfAlbCliL )->( dbSeek( nAlbCli ) )                 .and. ;     // posicionamos en lineas de albaran proveedores
      ( cPedCliT )->( dbSeek( ( dbfAlbCliT )->cNumPed ) )             // posicionamos en pedidos de proveedores

      //Mientras tengamos lineas de albaran a procesar

      WHILE ( ( dbfAlbCliL )->CSERALB + Str( ( dbfAlbCliL )->NNUMALB ) + ( dbfAlbCliL )->CSUFALB == nAlbCli ) .AND. !( dbfAlbCliL )->( eof() )

         //Mientras sea el mismo pedido

         if ( dbfPedCliL )->( dbSeek( ( dbfAlbCliT )->cNumPed ) )             // posicionamos en lineas de pedidos a proveedores

            WHILE ( dbfPedCliL )->CSERPED + Str( ( dbfPedCliL )->NNUMPED ) + ( dbfPedCliL )->CSUFPED == ( dbfAlbCliT )->cNumPed

               IF ( dbfPedCliL )->CREF == ( dbfAlbCliL )->CREF

                  if dbLock( dbfPedCliL )

                     IF lInc
                        ( dbfPedCliL )->nUniEnt += nTotUnt( dbfAlbCliL )
                     ELSE
                        ( dbfPedCliL )->nUniEnt -= nTotUnt( dbfAlbCliL )
                     END IF

                     ( dbfPedCliL )->( dbrUnLock() )

                  end if

               END IF

               ( dbfPedCliL )->( dbSkip() )

            END DO

      end if

      ( dbfAlbCliL )->( dbSkip() )

      END DO

      //Ahora comprobamos el estado de todos los pedidos procesados--------------

      IF ( dbfPedCliL )->( dbSeek( ( dbfAlbCliT )->CNUMPED ) )

         WHILE ( dbfPedCliL )->CSERPED + Str( ( dbfPedCliL )->NNUMPED ) + ( dbfPedCliL )->CSUFPED == ( dbfAlbCliT )->CNUMPED .AND. !( dbfPedCliL )->( eof() )

            IF nTotNPedCli( dbfPedCliL ) > nTotUnt( dbfPedCliL )

               //Parcialmente recibido

               nEstPed := 2
               EXIT

            ELSE

               //Recibido completo

               nEstPed := 3

            END IF

            ( dbfPedCliL )->( dbSkip() )

         END DO

         if dbLock( cPedCliT )
            ( cPedCliT )->nEstado := nEstPed
            ( cPedCliT )->( dbRUnlock() )
         end if

      END IF

   END IF

   //Reposicionamos todas las bases de datos utilizadas

   SetStatus( cPedCliT, aPedCliT )
   SetStatus( dbfPedCliL, aPedCliL )
   SetStatus( dbfAlbCliT, aAlbCliT )
   SetStatus( dbfAlbCliL, aAlbCliL )

RETURN NIL*/

//-------------------------------------------------------------------------//

//
// Devuelve el total de la compra en albaranes de clientes de un articulo
//

/*function nTotDPedCli( cCodArt, dbfPedCliL )

   local nTotVta  := 0
   local nRecno   := ( dbfPedCliL )->( Recno() )

   if ( dbfPedCliL )->( dbSeek( cCodArt ) )

      while ( dbfPedCliL )->CREF == cCodArt .and. !( dbfPedCliL )->( eof() )

         If !( dbfPedCliL )->LTOTLIN
            nTotVta += nTotNPedCli( dbfPedCliL )
         end if

         ( dbfPedCliL )->( dbSkip() )

      end while

   end if

   ( dbfPedCliL )->( dbGoTo( nRecno ) )

return ( nTotVta )*/

//---------------------------------------------------------------------------//
//
// Devuelve el total de la venta en albaranes de clientes de un articulo
//

function nTotVPedCli( cCodArt, dbfPedCliL, nDec, nDor )

   local nTotVta  := 0
   local nRecno   := ( dbfPedCliL )->( Recno() )

   if ( dbfPedCliL )->( dbSeek( cCodArt ) )

      while ( dbfPedCliL )->CREF == cCodArt .and. !( dbfPedCliL )->( eof() )

         if !( dbfPedCliL )->LTOTLIN
            nTotVta += nTotLPedCli( dbfPedCliL, nDec, nDor )
         end if

         ( dbfPedCliL )->( dbSkip() )

      end while

   end if

   ( dbfPedCliL )->( dbGoTo( nRecno ) )

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

   local aCalPedCli :=  {{"nTotArt",                                                   "N", 16,  6, "Total art�culos",             "cPicUndPed",  "" },;
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
                        { "nTotPage",                                                  "N", 16,  6, "Total p�gina",                "'cPorDivPed'", "!lEnd" },;
                        { "nImpEuros( nTotPed, (cDbf)->cDivPed, cDbfDiv )",            "N", 16,  6, "Total pedido (Euros)",        "",            "lEnd" },;
                        { "nImpPesetas( nTotPed, (cDbf)->cDivPed, cDbfDiv )",          "N", 16,  6, "Total pedido (Pesetas)",      "",            "lEnd" },;
                        { "nPagina",                                                   "N",  2,  0, "Numero de p�gina",            "'99'",        "" },;
                        { "lEnd",                                                      "L",  1,  0, "Fin del documento",           "",            "" } }

return ( aCalPedCli )

//---------------------------------------------------------------------------//

function aCocPedCli()

   local aCocPedCli  := {{"Descrip( cDbfCol )",                                         "C", 50, 0, "Detalle del art�culo",       "",            "Descripci�n", "" },;
                        { "nTotNPedCli( cDbfCol ) )",                                   "N", 16, 6, "Total unidades",             "cPicUndPed",  "Unds.",       "" },;
                        { "nTotUPedCli( cDbfCol, nRouDivPed, nVdvDivPed )",             "N", 16, 6, "Precio unitario de pedido",  "cPouDivPed",  "Importe",     "" },;
                        { "nTotLPedCli( cDbfCol, nDouDivPed, nRouDivPed )",             "N", 16, 6, "Total l�nea de pedido",      "cPorDivPed",  "Total",       "" },;
                        { "nTotFPedCli( cDbfCol, nDouDivPed, nRouDivPed )",             "N", 16, 6, "Total final l�nea de pedido","cPorDivPed",  "Total",       "" },;
                        { "cFrasePublicitaria( cDbfCol )",                              "C", 50, 0, "Texto de frase publicitaria","",            "Publicidad",  "" } }


return ( aCocPedCli )

//---------------------------------------------------------------------------//

FUNCTION QuiPedCli()

   local nOrdDet
   local nOrdPgo
   local nOrdRes
   local nOrdInc
   local nOrdDoc

   if ( TDataView():PedidosClientes( nView ) )->lCloPed .and. !oUser():lAdministrador()
      msgStop( "Solo puede eliminar pedidos cerrados los administradores." )
      Return .f.
   end if

   nOrdDet        := ( dbfPedCliL )->( OrdSetFocus( "NNUMPED" ) )
   nOrdPgo        := ( dbfPedCliP )->( OrdSetFocus( "NNUMPED" ) )
   nOrdRes        := ( dbfPedCliR )->( OrdSetFocus( "NNUMPED" ) )
   nOrdInc        := ( dbfPedCliI )->( OrdSetFocus( "NNUMPED" ) )
   nOrdDoc        := ( dbfPedCliD )->( OrdSetFocus( "NNUMPED" ) )

   /*
   Cambiamos el estado del presupuesto del que viene el pedido-----------------
   */

   if !Empty( dbfPreCliT )
      if dbSeekInOrd( ( TDataView():PedidosClientes( nView ) )->cNumPre, 'nNumPre', dbfPreCliT ) .and. ( dbfPreCliT )->( dbRLock() )
         ( dbfPreCliT )->lEstado := .f.
         ( dbfPreCliT )->( dbUnLock() )
      end if
   end if

   /*
   Lineas--------------------------------------------------------------------
   */

   while ( dbfPedCliL )->( dbSeek( ( TDataView():PedidosClientes( nView ) )->cSerPed + Str( ( TDataView():PedidosClientes( nView ) )->nNumPed ) + ( TDataView():PedidosClientes( nView ) )->cSufPed ) ) .and. !( dbfPedCliL )->( eof() )
      if dbLock( dbfPedCliL )
         ( dbfPedCliL )->( dbDelete() )
         ( dbfPedCliL )->( dbUnLock() )
      end if
   end while

   /*
   Reservas--------------------------------------------------------------------
   */

   while ( dbfPedCliR )->( dbSeek( ( TDataView():PedidosClientes( nView ) )->cSerPed + Str( ( TDataView():PedidosClientes( nView ) )->nNumPed ) + ( TDataView():PedidosClientes( nView ) )->cSufPed ) ) .and. !( dbfPedCliR )->( eof() )
      if dbLock( dbfPedCliR )
         ( dbfPedCliR )->( dbDelete() )
         ( dbfPedCliR )->( dbUnLock() )
      end if
   end while

   /*
   Entregas--------------------------------------------------------------------
   */

   while ( dbfPedCliP )->( dbSeek( ( TDataView():PedidosClientes( nView ) )->cSerPed + Str( ( TDataView():PedidosClientes( nView ) )->nNumPed ) + ( TDataView():PedidosClientes( nView ) )->cSufPed ) ) .and. !( dbfPedCliP )->( eof() )
      if dbDialogLock( dbfPedCliP )
         ( dbfPedCliP )->( dbDelete() )
         ( dbfPedCliP )->( dbUnLock() )
      end if
   end while

   /*
   Incidencias-----------------------------------------------------------------
   */

   while ( dbfPedCliI )->( dbSeek( ( TDataView():PedidosClientes( nView ) )->cSerPed + Str( ( TDataView():PedidosClientes( nView ) )->nNumPed ) + ( TDataView():PedidosClientes( nView )  )->cSufPed ) ) .and. !( dbfPedCliI )->( eof() )
      if dbLock( dbfPedCliI )
         ( dbfPedCliI )->( dbDelete() )
         ( dbfPedCliI )->( dbUnLock() )
      end if
   end while

   /*
   Documentos------------------------------------------------------------------
   */

   while ( dbfPedCliD )->( dbSeek( ( TDataView():PedidosClientes( nView ) )->cSerPed + Str( ( TDataView():PedidosClientes( nView ) )->nNumPed ) + ( TDataView():PedidosClientes( nView )  )->cSufPed ) ) .and. !( dbfPedCliD )->( eof() )
      if dbLock( dbfPedCliD )
         ( dbfPedCliD )->( dbDelete() )
         ( dbfPedCliD )->( dbUnLock() )
      end if
   end while

   ( dbfPedCliL )->( OrdSetFocus( nOrdDet ) )
   ( dbfPedCliP )->( OrdSetFocus( nOrdPgo ) )
   ( dbfPedCliR )->( OrdSetFocus( nOrdRes ) )
   ( dbfPedCliI )->( OrdSetFocus( nOrdInc ) )
   ( dbfPedCliD )->( OrdSetFocus( nOrdDoc ) )

Return ( .t. )

//----------------------------------------------------------------------------//

Function SynPedCli( cPath )

   local oError
   local oBlock
   local nOrdAnt
   local aTotPed

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

   USE ( cPatEmp() + "PEDCLID.DBF" ) NEW VIA ( cDriver() ) EXCLUSIVE ALIAS ( cCheckArea( "PEDCLID", @dbfPedCliD ) )
   SET ADSINDEX TO ( cPatEmp() + "PEDCLID.CDX" ) ADDITIVE

   USE ( cPatEmp() + "PEDCLIP.DBF" ) NEW VIA ( cDriver() ) EXCLUSIVE ALIAS ( cCheckArea( "PEDCLIP", @dbfPedCliP ) )
   SET ADSINDEX TO ( cPatEmp() + "PEDCLIP.CDX" ) ADDITIVE

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

        ( dbfPedCliT )->( dbSkip() )

      end while

   	( dbfPedCliT )->( ordSetFocus( 1 ) )

   	( dbfPedCliT )->( dbGoTop() )

    while !( dbfPedCliT )->( eof() )

        /*
        Rellenamos los campos de totales--------------------------------------
        */

        if ( dbfPedCliT )->nTotPed == 0 .and. dbLock( dbfPedCliT )

           	aTotPed                 := aTotPedCli( ( dbfPedCliT )->cSerPed + Str( ( dbfPedCliT )->nNumPed ) + ( dbfPedCliT )->cSufPed, dbfPedCliT, dbfPedCliL, dbfIva, dbfDiv, dbfFPago, ( dbfPedCliT )->cDivPed )

            ( dbfPedCliT )->nTotNet := aTotPed[1]
            ( dbfPedCliT )->nTotIva := aTotPed[2]
            ( dbfPedCliT )->nTotReq := aTotPed[3]
            ( dbfPedCliT )->nTotPed := aTotPed[4]

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
              ( dbfPedCliL )->nReq    := nPReq( dbfIva, ( dbfPedCliL )->nIva )
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
   CLOSE ( dbfIva     )
   CLOSE ( dbfDiv     )
   CLOSE ( dbfFPago   )

Return nil

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS TPedidosClientesSenderReciver FROM TSenderReciverItem

   Method CreateData()

   Method RestoreData()

   Method SendData()

   Method ReciveData()

   Method Process()

END CLASS

//----------------------------------------------------------------------------//

Method CreateData() CLASS TPedidosClientesSenderReciver

   local lSnd              := .f.
   local cPedCliT
   local dbfPedCliL
   local dbfPedCliI
   local tmpPedCliT
   local tmpPedCliL
   local tmpPedCliI
   local cFileName         := "PedCli" + StrZero( ::nGetNumberToSend(), 6 ) + "." + RetSufEmp()

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

   rxPedCli( cPatSnd() )

   USE ( cPatSnd() + "PedCliT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PedCliT", @tmpPedCliT ) )
   SET ADSINDEX TO ( cPatSnd() + "PedCliT.CDX" ) ADDITIVE

   USE ( cPatSnd() + "PedCliL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PedCliL", @tmpPedCliL ) )
   SET ADSINDEX TO ( cPatSnd() + "PedCliL.CDX" ) ADDITIVE

   USE ( cPatSnd() + "PedCliI.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PedCliI", @tmpPedCliI ) )
   SET ADSINDEX TO ( cPatSnd() + "PedCliI.CDX" ) ADDITIVE

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

   if lSnd

      /*
      Comprimir los archivos
      */

      ::oSender:SetText( "Comprimiendo pedidos de clientes" )

      if ::oSender:lZipData( cFileName )
         ::oSender:SetText( "Ficheros comprimidos" )
      else
         ::oSender:SetText( "ERROR al crear fichero comprimido" )
      end if

   else

      ::oSender:SetText( "No hay pedidos de clientes para enviar" )

   end if

Return ( Self )

//----------------------------------------------------------------------------//

Method RestoreData() CLASS TPedidosClientesSenderReciver

   local cPedCliT

   if ::lSuccesfullSend

      /*
      Retorna el valor anterior
      */

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

Method SendData() CLASS TPedidosClientesSenderReciver

   local cFileName         := "PedCli" + StrZero( ::nGetNumberToSend(), 6 ) + "." + RetSufEmp()

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

Method ReciveData() CLASS TPedidosClientesSenderReciver

   	local n
   	local aExt        := aRetDlgEmp()

   	/*
   	Recibirlo de internet
   	*/

   	::oSender:SetText( "Recibiendo pedidos de clientes" )

   	if !::oSender:lFranquiciado

   		for n := 1 to len( aExt )
      		ftpGetFiles( "PedCli*." + aExt[ n ], cPatIn(), 2000, ::oSender )
   		next

   	else

		for n := 1 to len( aExt )
      		ftpGetFiles( "PedPrv*." + aExt[ n ], cPatIn(), 2000, ::oSender )
   		next   	

   	end if	

   ::oSender:SetText( "Pedidos de clientes recibidos" )

Return Self

//----------------------------------------------------------------------------//

Method Process() CLASS TPedidosClientesSenderReciver

   local m
   local oBlock
   local oError
   local cPedCliT
   local dbfPedCliL
   local dbfPedCliI
   local tmpPedCliT
   local tmpPedCliL
   local tmpPedCliI
   local dbfCount
   local aFiles
   local cSerie
   local nNumero
   local cSufijo

   if !::oSender:lFranquiciado
      aFiles      := Directory( cPatIn() + "PedCli*.*" )
   else
      aFiles      := Directory( cPatIn() + "PedPrv*.*" )
   end if

   for m := 1 to len( aFiles )

      ::oSender:SetText( "Procesando fichero : " + aFiles[ m, 1 ] )

      oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )

      BEGIN SEQUENCE

        if ::oSender:lUnZipData( cPatIn() + aFiles[ m, 1 ] )

            if !::oSender:lFranquiciado

            	/*
            	Ficheros temporales
            	*/

            	if file( cPatSnd() + "PedCliT.DBF" )   .and.;
               	   file( cPatSnd() + "PedCliL.DBF" )   .and.;
               	   file( cPatSnd() + "PedCliI.DBF" )

               		USE ( cPatSnd() + "PedCliT.DBF" ) NEW VIA ( cDriver() ) READONLY ALIAS ( cCheckArea( "PedCliT", @tmpPedCliT ) )
               		SET ADSINDEX TO ( cPatSnd() + "PedCliT.CDX" ) ADDITIVE

               		USE ( cPatSnd() + "PedCliL.DBF" ) NEW VIA ( cDriver() ) READONLY ALIAS ( cCheckArea( "PedCliL", @tmpPedCliL ) )
               		SET ADSINDEX TO ( cPatSnd() + "PedCliL.CDX" ) ADDITIVE

               		USE ( cPatSnd() + "PedCliI.DBF" ) NEW VIA ( cDriver() ) READONLY ALIAS ( cCheckArea( "PedCliI", @tmpPedCliI ) )
               		SET ADSINDEX TO ( cPatSnd() + "PedCliI.CDX" ) ADDITIVE

               		USE ( cPatEmp() + "PedCliT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PedCliT", @cPedCliT ) )
               		SET ADSINDEX TO ( cPatEmp() + "PedCliT.CDX" ) ADDITIVE

               		USE ( cPatEmp() + "PedCliL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PedCliL", @dbfPedCliL ) )
               		SET ADSINDEX TO ( cPatEmp() + "PedCliL.CDX" ) ADDITIVE

               		USE ( cPatEmp() + "PedCliI.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PedCliI", @dbfPedCliI ) )
               		SET ADSINDEX TO ( cPatEmp() + "PedCliI.CDX" ) ADDITIVE

               		while ( tmpPedCliT )->( !eof() )

                  		if lValidaOperacion( ( tmpPedCliT )->dFecPed, .f. ) .and. ;
                     		!( cPedCliT )->( dbSeek( ( tmpPedCliT )->cSerPed + Str( ( tmpPedCliT )->nNumPed ) + ( tmpPedCliT )->cSufPed ) )

                     		dbPass( tmpPedCliT, cPedCliT, .t. )
                     		::oSender:SetText( "A�adido     : " + ( tmpPedCliL )->cSerPed + "/" + AllTrim( Str( ( tmpPedCliL )->nNumPed ) ) + "/" + AllTrim( ( tmpPedCliL )->cSufPed ) + "; " + Dtoc( ( tmpPedCliT )->dFecPed ) + "; " + AllTrim( ( tmpPedCliT )->cCodCli ) + "; " + ( tmpPedCliT )->cNomCli )

                     		if ( tmpPedCliL )->( dbSeek( ( tmpPedCliT )->cSerPed + Str( ( tmpPedCliT )->nNumPed ) + ( tmpPedCliT )->cSufPed ) )
                        		do while ( tmpPedCliL )->cSerPed + Str( ( tmpPedCliL )->nNumPed ) + ( tmpPedCliL )->cSufPed == ( tmpPedCliT )->cSerPed + Str( ( tmpPedCliT )->nNumPed ) + ( tmpPedCliT )->cSufPed .and. !( tmpPedCliL )->( eof() )
                           			dbPass( tmpPedCliL, dbfPedCliL, .t. )
                           			( tmpPedCliL )->( dbSkip() )
                        		end do
                     		end if

                     		if ( tmpPedCliI )->( dbSeek( ( tmpPedCliT )->cSerPed + Str( ( tmpPedCliT )->nNumPed ) + ( tmpPedCliT )->cSufPed ) )
                        		do while ( tmpPedCliI )->cSerPed + Str( ( tmpPedCliI )->nNumPed ) + ( tmpPedCliI )->cSufPed == ( tmpPedCliT )->cSerPed + Str( ( tmpPedCliT )->nNumPed ) + ( tmpPedCliT )->cSufPed .and. !( tmpPedCliI )->( eof() )
                           			dbPass( tmpPedCliI, dbfPedCliI, .t. )
                           			( tmpPedCliI )->( dbSkip() )
                        		end do
                     		end if

                  		else

                     		::oSender:SetText( "Desestimado : " + ( tmpPedCliL )->cSerPed + "/" + AllTrim( Str( ( tmpPedCliL )->nNumPed ) ) + "/" + AllTrim( ( tmpPedCliL )->cSufPed ) + "; " + Dtoc( ( tmpPedCliT )->dFecPed ) + "; " + AllTrim( ( tmpPedCliT )->cCodCli ) + "; " + ( tmpPedCliT )->cNomCli )

                  		end if

                  		( tmpPedCliT )->( dbSkip() )

               		end do

               		CLOSE ( cPedCliT )
               		CLOSE ( dbfPedCliL )
               		CLOSE ( dbfPedCliI )
               		CLOSE ( tmpPedCliT )
               		CLOSE ( tmpPedCliL )
               		CLOSE ( tmpPedCliI )

            	else

               		::oSender:SetText( "Faltan ficheros" )

            	end if

            	fErase( cPatSnd() + "PedCliT.DBF" )
            	fErase( cPatSnd() + "PedCliL.DBF" )
            	fErase( cPatSnd() + "PedCliI.DBF" )

            else

            /*
			Modo franquicia----------------------------------------------------
            */

            	if file( cPatSnd() + "PedProvT.dbf" )   .and.;
               	   file( cPatSnd() + "PedProvL.dbf" )

               		USE ( cPatSnd() + "PedProvT.DBF" ) NEW VIA ( cDriver() ) READONLY ALIAS ( cCheckArea( "PedProvT", @tmpPedCliT ) )
               		SET ADSINDEX TO ( cPatSnd() + "PedProvT.CDX" ) ADDITIVE

               		USE ( cPatSnd() + "PedProvL.DBF" ) NEW VIA ( cDriver() ) READONLY ALIAS ( cCheckArea( "PedProvL", @tmpPedCliL ) )
               		SET ADSINDEX TO ( cPatSnd() + "PedProvL.CDX" ) ADDITIVE

               		USE ( cPatEmp() + "PedCliT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PedCliT", @cPedCliT ) )
               		SET ADSINDEX TO ( cPatEmp() + "PedCliT.CDX" ) ADDITIVE

               		USE ( cPatEmp() + "PedCliL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PedCliL", @dbfPedCliL ) )
               		SET ADSINDEX TO ( cPatEmp() + "PedCliL.CDX" ) ADDITIVE

               		USE ( cPatEmp() + "NCOUNT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "NCOUNT", @dbfCount ) )
               		SET ADSINDEX TO ( cPatEmp() + "NCOUNT.CDX" ) ADDITIVE


               		while ( tmpPedCliT )->( !eof() )

                  		/*
                  		Comprobamos que no exista la factura en la base de datos---
                  		*/

                  		( cPedCliT )->( OrdSetFocus( "cSuPed" ) )

                  		if !( cPedCliT )->( dbSeek( ( tmpPedCliT )->cSerPed + Str( ( tmpPedCliT )->nNumPed ) + ( tmpPedCliT )->cSufPed ) )

	                     	/*
                     		Pasamos las cabeceras----------------------------------
                     		*/

                     		cSerie      := ( tmpPedCliT )->cSerPed
                     		nNumero     := nNewDoc( ( tmpPedCliT )->cSerPed, cPedCliT, "NPEDCLI", , dbfCount )
                     		cSufijo  	:= oUser():cDelegacion()

                     		( cPedCliT)->( dbAppend() )

							( cPedCliT)->CSERPED 			:= cSerie
   						 	( cPedCliT)->NNUMPED 			:= nNumero
   						 	( cPedCliT)->CSUFPED 			:= cSufijo
   						 	( cPedCliT)->CTURPED 			:= cCurSesion()
   						 	( cPedCliT)->DFECPED 			:= ( tmpPedCliT )->dFecPed
   						 	( cPedCliT)->CCODCLI 			:= ( tmpPedCliT )->cCodPrv
   						 	( cPedCliT)->CNOMCLI 			:= ( tmpPedCliT )->cNomPrv
   						 	( cPedCliT)->CDIRCLI 			:= ( tmpPedCliT )->cDirPrv
   						 	( cPedCliT)->CPOBCLI 			:= ( tmpPedCliT )->cPobPrv
   						 	( cPedCliT)->CPRVCLI 			:= ( tmpPedCliT )->cProPrv
   						 	( cPedCliT)->CPOSCLI 			:= ( tmpPedCliT )->cPosPrv
   						 	( cPedCliT)->CDNICLI 			:= ( tmpPedCliT )->cDniPrv
   						 	( cPedCliT)->LMODCLI 			:= .t.
   						 	( cPedCliT)->CCODALM 			:= oUser():cAlmacen()
   						 	( cPedCliT)->CCODCAJ 			:= oUser():cCaja()
   						 	( cPedCliT)->CCODPGO 			:= ( tmpPedCliT )->cCodPgo
   						 	( cPedCliT)->NESTADO 			:= 1
   						 	( cPedCliT)->CSUPED  			:= ( tmpPedCliT )->cSerPed + Str( ( tmpPedCliT )->nNumPed ) + ( tmpPedCliT )->cSufPed
   						 	( cPedCliT)->CCONDENT			:= ( tmpPedCliT )->cCondEnt
   						 	( cPedCliT)->MOBSERV 			:= ( tmpPedCliT )->cObserv
   						 	( cPedCliT)->NTARIFA 			:= 1
   						 	( cPedCliT)->CDTOESP 			:= ( tmpPedCliT )->cDtoEsp
   						 	( cPedCliT)->NDTOESP 			:= ( tmpPedCliT )->nDtoEsp
   						 	( cPedCliT)->CDPP    			:= ( tmpPedCliT )->cDpp
   						 	( cPedCliT)->NDPP    			:= ( tmpPedCliT )->nDpp
   						 	( cPedCliT)->CDTOUNO 			:= ( tmpPedCliT )->cDtoUno
   						 	( cPedCliT)->NDTOUNO 			:= ( tmpPedCliT )->nDtoUno
   						 	( cPedCliT)->CDTODOS 			:= ( tmpPedCliT )->cDtoDos
   						 	( cPedCliT)->NDTODOS 			:= ( tmpPedCliT )->nDtoDos
   						 	( cPedCliT)->LRECARGO			:= ( tmpPedCliT )->lRecargo
   						 	( cPedCliT)->NBULTOS 			:= ( tmpPedCliT )->nBultos
   						 	( cPedCliT)->CDIVPED 			:= ( tmpPedCliT )->cDivPed
   						 	( cPedCliT)->NVDVPED 			:= ( tmpPedCliT )->nVdvPed
   						 	( cPedCliT)->LSNDDOC 			:= .t.
   						 	( cPedCliT)->NREGIVA 			:= ( tmpPedCliT )->nRegIva
   						 	( cPedCliT)->LCLOPED 			:= .f.
   						 	( cPedCliT)->CCODUSR 			:= cCurUsr()
   						 	( cPedCliT)->DFECCRE 			:= GetSysDate()
   						 	( cPedCliT)->CTIMCRE 			:= Time()
   						 	( cPedCliT)->cCodDlg 			:= oUser():cDelegacion()
   						 	( cPedCliT)->nTotNet 			:= ( tmpPedCliT )->nTotNet       // "N",  16,  6, "Total neto" ,                     "",                   "", "( cDbf )", nil } )
   						 	( cPedCliT)->nTotIva 			:= ( tmpPedCliT )->nTotIva       // "N",  16,  6, "Total " + cImp() ,                "",                   "", "( cDbf )", nil } )
   						 	( cPedCliT)->nTotReq 			:= ( tmpPedCliT )->nTotReq       // "N",  16,  6, "Total recago" ,                   "",                   "", "( cDbf )", nil } )
   						 	( cPedCliT)->nTotPed 			:= ( tmpPedCliT )->nTotPed       // "N",  16,  6, "Total pedido" ,                   "",                   "", "( cDbf )", nil } )

                     		( cPedCliT )->( dbUnLock() )

                     		::oSender:SetText( "A�adido pedido     : " + cSerie + "/" + AllTrim( Str( nNumero ) ) + "/" +  AllTrim( cSufijo ) )

                     		/*
							Pasamos las lineas de los pedidos------------------
                     		*/

                     		if ( tmpPedCliL )->( dbSeek( ( tmpPedCliT )->cSerPed + Str( ( tmpPedCliT )->nNumPed ) + ( tmpPedCliT )->cSufPed ) )
                           
                        		while ( tmpPedCliL )->cSerPed + Str( ( tmpPedCliL )->nNumPed ) + ( tmpPedCliL )->cSufPed == ( tmpPedCliT )->cSerPed + Str( ( tmpPedCliT )->nNumPed ) + ( tmpPedCliT )->cSufPed .and. !( tmpPedCliL )->( eof() )
                              
                           		( dbfPedCliL)->( dbAppend() )

								( dbfPedCliL )->cSerPed   	:= cSerie
   							 	( dbfPedCliL )->nNumPed   	:= nNumero
   							 	( dbfPedCliL )->cSufPed   	:= cSufijo
   							 	( dbfPedCliL )->cRef      	:= ( tmpPedCliL )->cRef
   							 	( dbfPedCliL )->cCodPr1   	:= ( tmpPedCliL )->cCodPr1
   							 	( dbfPedCliL )->cCodPr2   	:= ( tmpPedCliL )->cCodPr2
   							 	( dbfPedCliL )->cValPr1   	:= ( tmpPedCliL )->cValPr1
   							 	( dbfPedCliL )->cValPr2   	:= ( tmpPedCliL )->cValPr2
   							 	( dbfPedCliL )->cDetalle  	:= ( tmpPedCliL )->cDetalle
   							 	( dbfPedCliL )->nIva  		:= ( tmpPedCliL )->nIva
   							 	( dbfPedCliL )->nCanPed  	:= ( tmpPedCliL )->nCanPed
   							 	( dbfPedCliL )->nUniCaja  	:= ( tmpPedCliL )->nUniCaja
   							 	( dbfPedCliL )->nUndKit   	:= ( tmpPedCliL )->nUndKit
   							 	( dbfPedCliL )->nPreDiv  	:= ( tmpPedCliL )->nPreDiv
   							 	( dbfPedCliL )->NDTO      	:= ( tmpPedCliL )->nDtoLin
   							 	( dbfPedCliL )->NDTOPRM   	:= ( tmpPedCliL )->nDtoPrm
   							 	( dbfPedCliL )->NCANENT   	:= ( tmpPedCliL )->nCanEnt
   							 	( dbfPedCliL )->NUNIENT   	:= ( tmpPedCliL )->nUniEnt
   							 	( dbfPedCliL )->CUNIDAD   	:= ( tmpPedCliL )->cUnidad
   							 	( dbfPedCliL )->MLNGDES   	:= ( tmpPedCliL )->mLngDes
   							 	( dbfPedCliL )->NFACCNV   	:= ( tmpPedCliL )->nFacCnv
   							 	( dbfPedCliL )->NNUMLIN   	:= ( tmpPedCliL )->nNumLin
   							 	( dbfPedCliL )->NCTLSTK   	:= ( tmpPedCliL )->nCtlStk
   							 	( dbfPedCliL )->NCOSDIV   	:= ( tmpPedCliL )->nPreDiv
   							 	( dbfPedCliL )->CALMLIN   	:= oUser():cAlmacen()
   							 	( dbfPedCliL )->LLOTE     	:= ( tmpPedCliL )->lLote
   							 	( dbfPedCliL )->NLOTE     	:= ( tmpPedCliL )->nLote
   							 	( dbfPedCliL )->CLOTE     	:= ( tmpPedCliL )->cLote
   							 	( dbfPedCliL )->LKITART   	:= ( tmpPedCliL )->lKitArt
   							 	( dbfPedCliL )->LKITCHL   	:= ( tmpPedCliL )->lKitChl
   							 	( dbfPedCliL )->LKITPRC   	:= ( tmpPedCliL )->lKitPrc
   							 	( dbfPedCliL )->LCONTROL  	:= ( tmpPedCliL )->lControl
   							 	( dbfPedCliL )->CCODFAM   	:= ( tmpPedCliL )->cCodFam
   							 	( dbfPedCliL )->CGRPFAM   	:= ( tmpPedCliL )->cGrpFam
   							 	( dbfPedCliL )->NREQ      	:= ( tmpPedCliL )->nReq
   							 	( dbfPedCliL )->MOBSLIN   	:= ( tmpPedCliL )->mObsLin
   							 	( dbfPedCliL )->CREFPRV   	:= ( tmpPedCliL )->cRefPrv
   							 	( dbfPedCliL )->nNumMed   	:= ( tmpPedCliL )->nNumMed
   							 	( dbfPedCliL )->nMedUno   	:= ( tmpPedCliL )->nMedUno
   							 	( dbfPedCliL )->nMedDos   	:= ( tmpPedCliL )->nMedDos
   							 	( dbfPedCliL )->nMedTre   	:= ( tmpPedCliL )->nMedTre

                           		( dbfPedCliL )->( dbUnLock() )

                           		( tmpPedCliL )->( dbSkip() )

                        		end while

                     		end if

                     	else

                     		::oSender:SetText( "Desestimado pedido : " + ( tmpPedCliT )->cSerPed + "/" + AllTrim( Str( ( tmpPedCliT )->nNumPed ) ) + "/" +  AllTrim( ( tmpPedCliL )->cSufPed ) )

                  		end if

                  	( tmpPedCliT )->( dbSkip() )

               		end while

               		CLOSE ( tmpPedCliT )
               		CLOSE ( tmpPedCliL )
               		CLOSE ( cPedCliT )
               		CLOSE ( dbfPedCliL )

            	else

               		::oSender:SetText( "Faltan ficheros" )

            	end if

            	fErase( cPatSnd() + "PedProvT.DBF" )
            	fErase( cPatSnd() + "PedProvL.DBF" )

            end if	

        else

           	::oSender:SetText( "Error al descomprimir los ficheros" )

        end if

        ::oSender:AppendFileRecive( aFiles[ m, 1 ] )

      RECOVER USING oError

         CLOSE ( cPedCliT )
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

function aColTmpLin()

   local aColTmpLin  := {}

   aAdd( aColTmpLin, { "cRef",    "C",   18,  0, "Referencia del art�culo",         "",         "", "( cDbfCol )" } )
   aAdd( aColTmpLin, { "cDetalle","C",  250,  0, "Nombre del art�culo",             "",         "", "( cDbfCol )" } )
   aAdd( aColTmpLin, { "mLngDes", "M",   10,  0, "Descripciones largas",            "",         "", "( cDbfCol )" } )
   aAdd( aColTmpLin, { "lSelArt", "L",    1,  0, "L�gico de selecci�n de art�culo", "",         "", "( cDbfCol )" } )
   aAdd( aColTmpLin, { "cCodPrv", "C",   12,  0, "C�digo de proveedor",             "",         "", "( cDbfCol )" } )
   aAdd( aColTmpLin, { "cCodPr1", "C",   20,  0, "C�digo propiedad 1",              "",         "", "( cDbfCol )" } )
   aAdd( aColTmpLin, { "cCodPr2", "C",   20,  0, "C�digo propiedad 2",              "",         "", "( cDbfCol )" } )
   aAdd( aColTmpLin, { "cValPr1", "C",   40,  0, "Valor propiedad 1",               "",         "", "( cDbfCol )" } )
   aAdd( aColTmpLin, { "cValPr2", "C",   40,  0, "Valor propiedad 2",               "",         "", "( cDbfCol )" } )
   aAdd( aColTmpLin, { "nNumUni", "N",   16,  6, "Unidades pedidas",                "",         "", "( cDbfCol )" } )
   aAdd( aColTmpLin, { "nNumCaj", "N",   16,  6, "Cajas pedidas",                   "",         "", "( cDbfCol )" } )
   aAdd( aColTmpLin, { "nStkFis", "N",   16,  6, "Stock fisico",                    "",         "", "( cDbfCol )" } )
   aAdd( aColTmpLin, { "nStkDis", "N",   16,  6, "Stock disponible",                "",         "", "( cDbfCol )" } )
   aAdd( aColTmpLin, { "lShow",   "L",    1,  0, "L�gico de mostrar",               "",         "", "( cDbfCol )" } )
   aAdd( aColTmpLin, { "nIva",    "N",    6,  2, "Porcentaje de " + cImp(),         "",         "", "( cDbfCol )" } )
   aAdd( aColTmpLin, { "nReq",    "N",    6,  2, "Porcentaje de recargo",           "",         "", "( cDbfCol )" } )
   aAdd( aColTmpLin, { "nPreDiv", "N",   16,  6, "Precio del art�culo",             "",         "", "( cDbfCol )" } )
   aAdd( aColTmpLin, { "nDto",    "N",    6,  2, "Descuento del producto",          "",         "", "( cDbfCol )" } )
   aAdd( aColTmpLin, { "nDtoPrm", "N",    6,  2, "Descuento de promoci�n",          "",         "", "( cDbfCol )" } )
   aAdd( aColTmpLin, { "cUnidad", "C",    2,  0, "Unidad de medici�n",              "",         "", "( cDbfCol )" } )
   aAdd( aColTmpLin, { "lLote",   "L",    1,  0, "",                                "",         "", "( cDbfCol )" } )
   aAdd( aColTmpLin, { "nLote",   "N",    9,  0, "",                                "",         "", "( cDbfCol )" } )
   aAdd( aColTmpLin, { "cLote",   "C",   12,  0, "N�mero de lote",                  "",         "", "( cDbfCol )" } )
   aAdd( aColTmpLin, { "mObsLin", "M",   10,  0, "Observaciones de lineas",         "",         "", "( cDbfCol )" } )
   aAdd( aColTmpLin, { "cRefPrv", "C",   18,  0, "Referencia proveedor",            "",         "", "( cDbfCol )" } )
   aAdd( aColTmpLin, { "cUnidad", "C",    2,  0, "Unidad de medici�n",              "",         "", "( cDbfCol )" } )
   aAdd( aColTmpLin, { "nMedUno", "N",   16,  6, "Primera unidad de medici�n",      "MasUnd()", "", "( cDbfCol )" } )
   aAdd( aColTmpLin, { "nMedDos", "N",   16,  6, "Segunda unidad de medici�n",      "MasUnd()", "", "( cDbfCol )" } )
   aAdd( aColTmpLin, { "nMedTre", "N",   16,  6, "Tercera unidad de medici�n",      "MasUnd()", "", "( cDbfCol )" } )
   aAdd( aColTmpLin, { "nNumLin", "N",    4,  0, "N�mero de l�nea",      			"", 		"", "( cDbfCol )" } )

return ( aColTmpLin )

//---------------------------------------------------------------------------//

function aColTmpFin()

   local aColTmpFin  := {}

   aAdd( aColTmpFin, { "cSerie",  "C",    1,  0, "Serie del documento",             "",  "", "( cDbfCol )" } )
   aAdd( aColTmpFin, { "nNumero", "N",    9,  0, "N�mero del documento",            "",  "", "( cDbfCol )" } )
   aAdd( aColTmpFin, { "cSufijo", "C",    2,  0, "Sufijo del documento",            "",  "", "( cDbfCol )" } )
   aAdd( aColTmpFin, { "dFecDoc", "D",    8,  0, "Fecha del documento",             "",  "", "( cDbfCol )" } )
   aAdd( aColTmpFin, { "cCodPrv", "C",   12,  0, "C�digo de proveedor",             "",  "", "( cDbfCol )" } )
   aAdd( aColTmpFin, { "cNomPrv", "C",   30,  0, "Nombre de proveedor",             "",  "", "( cDbfCol )" } )

return ( aColTmpFin )

//---------------------------------------------------------------------------//

FUNCTION BrwArtPed( aGet, dbfTmpPedLin, dbfDiv, dbfIva )

	local oDlg
	local oBrw
	local oGet1
	local cGet1
	local oCbxOrd
   local cCbxOrd     := "C�digo"
   local aCbxOrd     := { "C�digo", "Nombre" }
   local nRecAnt     := ( dbfTmpPedLin )->( recno() )
   local nOrdAnt     := ( dbfTmpPedLin )->( OrdSetFocus( 1 ) )

   ( dbfTmpPedLin )->( DbGoTop() )

   DEFINE DIALOG oDlg RESOURCE "HELPENTRY" TITLE "Art�culos"

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
                  "C�digo" ,;
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

   local nLevel         := nLevelUsr( _MENUITEM_ )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) != 0 .or. nAnd( nLevel, ACC_APPD ) == 0
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
         WinAppRec( nil, bEdtRec, TDataView():PedidosClientes( nView ), cCodCli, cCodArt )
         CloseFiles()
      end if

   end if

RETURN .t.

//----------------------------------------------------------------------------//

Function EdtPedCli( cNumPed, lOpenBrowse )

   local nLevel         := nLevelUsr( _MENUITEM_ )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) != 0 .or. nAnd( nLevel, ACC_EDIT ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if lOpenBrowse

      if PedCli()
         if dbSeekInOrd( cNumPed, "nNumPed", TDataView():PedidosClientes( nView ) )
            oWndBrw:RecEdit()
         else
            MsgStop( "No se encuentra pedido" )
         end if
      end if

   else

      if OpenFiles( .t. )

         if dbSeekInOrd( cNumPed, "nNumPed", TDataView():PedidosClientes( nView ) )
            nTotPedCli()
            WinEdtRec( nil, bEdtRec, TDataView():PedidosClientes( nView ) )
         end if

         CloseFiles()

      end if

   end if

Return .t.

//----------------------------------------------------------------------------//

FUNCTION ZooPedCli( cNumPed, lOpenBrowse )

   local nLevel         := nLevelUsr( _MENUITEM_ )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) != 0 .or. nAnd( nLevel, ACC_ZOOM ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if lOpenBrowse

      if PedCli()
         if dbSeekInOrd( cNumPed, "nNumPed", TDataView():PedidosClientes( nView ) )
            oWndBrw:RecZoom()
         else
            MsgStop( "No se encuentra pedido" )
         end if
      end if

   else

      if OpenFiles( .t. )

         if dbSeekInOrd( cNumPed, "nNumPed", TDataView():PedidosClientes( nView ) )
            nTotPedCli()
            WinZooRec( nil, bEdtRec, TDataView():PedidosClientes( nView ) )
         end if

         CloseFiles()

      end if

   end if

Return .t.

//----------------------------------------------------------------------------//

FUNCTION DelPedCli( cNumPed, lOpenBrowse )

   local nLevel         := nLevelUsr( _MENUITEM_ )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) != 0 .or. nAnd( nLevel, ACC_DELE ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if lOpenBrowse

      if PedCli()
         if dbSeekInOrd( cNumPed, "nNumPed", TDataView():PedidosClientes( nView ) )
            WinDelRec( nil, TDataView():PedidosClientes( nView ), {|| QuiPedCli() } )
         else
            MsgStop( "No se encuentra pedido" )
         end if
      end if

   else

      if OpenFiles( .t. )

         if dbSeekInOrd( cNumPed, "nNumPed", TDataView():PedidosClientes( nView ) )
            nTotPedCli()
            WinDelRec( nil, TDataView():PedidosClientes( nView ), {|| QuiPedCli() } )
         end if

         CloseFiles()

      end if

   end if

Return .t.

//----------------------------------------------------------------------------//

FUNCTION PrnPedCli( cNumPed, lOpenBrowse )

   local nLevel         := nLevelUsr( _MENUITEM_ )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) != 0 .or. nAnd( nLevel, ACC_IMPR ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if lOpenBrowse

      if PedCli()
         if dbSeekInOrd( cNumPed, "nNumPed", TDataView():PedidosClientes( nView ) )
            ImprimirSeriesPedidosClientes( IS_PRINTER, .t. )
            //GenPedCli( IS_PRINTER )
         else
            MsgStop( "No se encuentra pedido" )
         end if
      end if

   else

      if OpenFiles( .t. )

         if dbSeekInOrd( cNumPed, "nNumPed", TDataView():PedidosClientes( nView ) )
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

   local nLevel         := nLevelUsr( _MENUITEM_ )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) != 0 .or. nAnd( nLevel, ACC_IMPR ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if lOpenBrowse

      if PedCli()
         if dbSeekInOrd( cNumPed, "nNumPed", TDataView():PedidosClientes( nView ) )
            ImprimirSeriesPedidosClientes( IS_SCREEN, .t. )
            //GenPedCli( IS_SCREEN )
         else
            MsgStop( "No se encuentra pedido" )
         end if
      end if

   else

      if OpenFiles( .t. )

         if dbSeekInOrd( cNumPed, "nNumPed", TDataView():PedidosClientes( nView ) )
            nTotPedCli()
            ImprimirSeriesPedidosClientes( IS_SCREEN, .t. )
            //GenPedCli( IS_SCREEN )
         end if

         CloseFiles()

      end if

   end if

Return .t.

//---------------------------------------------------------------------------//

FUNCTION PrnEntPed( cNumEnt, lPrint, dbfPedCliP )

   local nLevel         := nLevelUsr( _MENUITEM_ )

   if nAnd( nLevel, 1 ) != 0 .or. nAnd( nLevel, ACC_IMPR ) == 0
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

   ( dbfPedCliR )->( OrdSetFocus( "cRef" ) )

   if ( dbfPedCliR )->( dbSeek( cCodArt ) )

      while ( dbfPedCliR )->cRef == cCodArt .and. !(dbfPedCliR)->(Eof())

         nTotal += nTotRPedCli( (dbfPedCliR)->cSerPed + Str( (dbfPedCliR)->nNumPed ) + (dbfPedCliR)->cSufPed, (dbfPedCliR)->cRef, (dbfPedCliR)->cValPr1, (dbfPedCliR)->cValPr2, dbfPedCliR )

      (dbfPedCliR)->(dbSkip())

      end while

   end if

return ( nTotal )

//---------------------------------------------------------------------------//

//
// NOTA: Esta funcion se utiliza para el estado de recibido de pedidos de clientes
//

function nEstadoRecPedCli( dbfPedPrvL, dbfAlbPrvL, dbfTmpLin )

   local nTotUni
   local nOrdAnt
   local nEstado     := 1
   local nTotRec     := 0

   if IsMuebles()

      nOrdAnt        := ( dbfPedPrvL )->( OrdSetFocus( "cPedCliDet" ) )

      if ( dbfPedPrvL )->( dbSeek( ( dbfTmpLin )->cSerPed + Str( ( dbfTmpLin )->nNumPed ) + ( dbfTmpLin )->cSufPed + ( dbfTmpLin )->cRef + ( dbfTmpLin )->cValPr1 + ( dbfTmpLin )->cValPr2 + ( dbfTmpLin )->cRefPrv + ( dbfTmpLin )->cDetalle ) )

         nTotUni     := nTotNPedCli( dbfTmpLin )
         nTotRec     := nUnidadesRecibidasPedPrv( ( dbfPedPrvL )->cSerPed + Str( ( dbfPedPrvL )->nNumPed ) + ( dbfPedPrvL )->cSufPed, ( dbfTmpLin)->cRef, ( dbfTmpLin )->cValPr1, ( dbfTmpLin )->cValPr2, ( dbfTmpLin )->cRefPrv, ( dbfTmpLin )->cDetalle, dbfAlbPrvL )

      end if

      ( dbfPedPrvL )->( OrdSetFocus( nOrdAnt ) )

   else

      nOrdAnt        := ( dbfPedPrvL )->( OrdSetFocus( "cPedCliRef" ) )

      if ( dbfPedPrvL )->( dbSeek( ( dbfTmpLin )->cSerPed + Str( ( dbfTmpLin )->nNumPed ) + ( dbfTmpLin )->cSufPed + ( dbfTmpLin )->cRef + ( dbfTmpLin )->cValPr1 + ( dbfTmpLin )->cValPr2 ) )

         nTotUni     := nTotNPedCli( dbfTmpLin )
         nTotRec     := nUnidadesRecibidasPedPrv( ( dbfPedPrvL )->cSerPed + Str( ( dbfPedPrvL )->nNumPed ) + ( dbfPedPrvL )->cSufPed, ( dbfTmpLin)->cRef, ( dbfTmpLin )->cValPr1, ( dbfTmpLin )->cValPr2, ( dbfTmpLin )->cRefPrv, ( dbfTmpLin )->cDetalle, dbfAlbPrvL )

      end if

      ( dbfPedPrvL )->( OrdSetFocus( nOrdAnt ) )

   end if

   do case
      case nTotRec == 0
         nEstado     := 1
      case nTotRec < nTotUni
         nEstado     := 2
      case nTotRec >= nTotUni
         nEstado     := 3
   end case

Return nEstado

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

         oFr:AddBand(         "CabeceraColumnas",  "MainPage", frxMasterData )
         oFr:SetProperty(     "CabeceraColumnas",  "Top", 200 )
         oFr:SetProperty(     "CabeceraColumnas",  "Height", 0 )
         oFr:SetProperty(     "CabeceraColumnas",  "StartNewPage", .t. )
         oFr:SetObjProperty(  "CabeceraColumnas",  "DataSet", "Pedidos" )

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
      Dise�o de report---------------------------------------------------------
      */

      oFr:DesignReport()

      /*
      Destruye el dise�ador----------------------------------------------------
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

Function PrintReportPedCli( nDevice, nCopies, cPrinter, dbfDoc )

   local oFr
   local cFilePdf       := cPatTmp() + "PedidoCliente" + StrTran( ( TDataView():PedidosClientes( nView ) )->cSerPed + Str( ( TDataView():PedidosClientes( nView ) )->nNumPed ) + ( TDataView():PedidosClientes( nView ) )->cSufPed, " ", "" ) + ".Pdf"

   DEFAULT nDevice      := IS_SCREEN
   DEFAULT nCopies      := 1
   DEFAULT cPrinter     := PrnGetName()

   SysRefresh()

   oFr                  := frReportManager():New()

   oFr:LoadLangRes(     "Spanish.Xml" )

   oFr:SetIcon( 1 )

   oFr:SetTitle(        "Dise�ador de documentos" )

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

                  :SetTypeDocument( "nPedCli" )
                  :SetDe(           uFieldEmpresa( "cNombre" ) )
                  :SetCopia(        uFieldEmpresa( "cCcpMai" ) )
                  :SetAdjunto(      cFilePdf )
                  :SetPara(         RetFld( ( TDataView():PedidosClientes( nView ) )->cCodCli, TDataView():Clientes( nView ), "cMeiInt" ) )
                  :SetAsunto(       "Envio de pedido de cliente n�mero " + ( TDataView():PedidosClientes( nView ) )->cSerPed + "/" + Alltrim( Str( ( TDataView():PedidosClientes( nView ) )->nNumPed ) ) )
                  :SetMensaje(      "Adjunto le remito nuestro pedido de cliente " + ( TDataView():PedidosClientes( nView ) )->cSerPed + "/" + Alltrim( Str( ( TDataView():PedidosClientes( nView ) )->nNumPed ) ) + Space( 1 ) )
                  :SetMensaje(      "de fecha " + Dtoc( ( TDataView():PedidosClientes( nView ) )->dfecPed ) + Space( 1 ) )
                  :SetMensaje(      CRLF )
                  :SetMensaje(      CRLF )
                  :SetMensaje(      "Reciba un cordial saludo." )

                  :GeneralResource( TDataView():PedidosClientes( nView ), aItmPedCli() )

               end with

            end if

      end case

   end if

   /*
   Destruye el dise�ador-------------------------------------------------------
   */

   oFr:DestroyFr()

Return .t.

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

         oFr:AddBand(         "CabeceraColumnas",  "MainPage", frxMasterData )
         oFr:SetProperty(     "CabeceraColumnas",  "Top", 300 )
         oFr:SetProperty(     "CabeceraColumnas",  "Height", 0 )
         oFr:SetProperty(     "CabeceraColumnas",  "StartNewPage", .t. )
         oFr:SetObjProperty(  "CabeceraColumnas",  "DataSet", "Entrega" )

      end if

      /*
      Zona de variables--------------------------------------------------------
      */

      VariableReportEntPedCli( oFr )

      /*
      Dise�o de report---------------------------------------------------------
      */

      oFr:DesignReport()

      /*
      Destruye el dise�ador----------------------------------------------------
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

   oFr:SetTitle(        "Dise�ador de documentos" )

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
   Destruye el dise�ador-------------------------------------------------------
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

   if !lExistIndex( cPath + "PedCliT.Cdx" ) .or. ;
      !lExistIndex( cPath + "PedCliL.Cdx" ) .or. ;
      !lExistIndex( cPath + "PedCliR.Cdx" ) .or. ;
      !lExistIndex( cPath + "PedCliI.Cdx" ) .or. ;
      !lExistIndex( cPath + "PedCliP.Cdx" ) .or. ;
      !lExistTable( cPath + "PedCliD.Cdx" )

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

   DEFAULT cPath     := cPatEmp()
   DEFAULT lAppend   := .f.
   DEFAULT bFor      := {|| .t. }

	IF oMeter != NIL
		oMeter:cText	:= "Generando Bases"
		sysrefresh()
	END IF

   CreateFiles( cPath )

   rxPedCli( cPath, oMeter )

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
                  ( dbfPedCliL )->nUniCaja   -= nUnidadesRecibidasAlbCli( ( oldPedCliT )->cSerPed + Str( ( oldPedCliT )->nNumPed ) + ( oldPedCliT )->cSufPed, ( oldPedCliL )->cRef, ( oldPedCliL )->cValPr1, ( oldPedCliL )->cValPr2, ( oldPedCliL )->cRefPrv, ( oldPedCliL )->cDetalle, oldAlbCliL )
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

      ( oldAlbCliT )->( dbCloseArea() )
      ( oldAlbCliL )->( dbCloseArea() )

	END IF

RETURN .t.

//---------------------------------------------------------------------------//

FUNCTION rxPedCli( cPath, oMeter )

	local cPedCliT

   DEFAULT cPath  := cPatEmp()

   if !lExistTable( cPath + "PEDCLIT.DBF" ) .OR. ;
      !lExistTable( cPath + "PEDCLIL.DBF" ) .OR. ;
      !lExistTable( cPath + "PEDCLIR.DBF" ) .OR. ;
      !lExistTable( cPath + "PEDCLII.DBF" ) .OR. ;
      !lExistTable( cPath + "PEDCLID.DBF" ) .OR. ;
      !lExistTable( cPath + "PEDCLIP.DBF" )
      CreateFiles( cPath )
   end if

   fEraseIndex( cPath + "PEDCLIT.CDX" )
   fEraseIndex( cPath + "PEDCLIL.CDX" )
   fEraseIndex( cPath + "PEDCLIR.CDX" )
   fEraseIndex( cPath + "PEDCLII.CDX" )
   fEraseIndex( cPath + "PEDCLID.CDX" )
   fEraseIndex( cPath + "PEDCLIP.CDX" )

   dbUseArea( .t., cDriver(), cPath + "PEDCLIT.DBF", cCheckArea( "PEDCLIT", @cPedCliT ), .f. )
   if !( cPedCliT )->( neterr() )
      ( cPedCliT )->( __dbPack() )

      ( cPedCliT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cPedCliT )->( ordCreate( cPath + "PEDCLIT.CDX", "NNUMPED", "CSERPED + STR( NNUMPED ) + CSUFPED", {|| Field->CSERPED + STR( Field->NNUMPED ) + Field->CSUFPED } ) )

      ( cPedCliT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cPedCliT )->( ordCreate( cPath + "PEDCLIT.CDX", "DFECPED", "DFECPED", {|| Field->DFECPED } ) )

      ( cPedCliT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cPedCliT )->( ordCreate( cPath + "PEDCLIT.CDX", "CCODCLI", "CCODCLI", {|| Field->CCODCLI } ) )

      ( cPedCliT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cPedCliT )->( ordCreate( cPath + "PEDCLIT.CDX", "CNOMCLI", "Upper( CNOMCLI )", {|| Upper( Field->CNOMCLI ) } ) )

      ( cPedCliT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cPedCliT )->( ordCreate( cPath + "PEDCLIT.CDX", "cCodObr", "cCodObr + Dtos( dFecPed )", {|| Field->cCodObr + Dtos( Field->dFecPed ) } ) )

      ( cPedCliT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cPedCliT )->( ordCreate( cPath + "PEDCLIT.CDX", "cCodAge", "cCodAge + Dtos( dFecPed )", {|| Field->cCodAge + Dtos( Field->dFecPed ) } ) )

      ( cPedCliT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cPedCliT )->( ordCreate( cPath + "PEDCLIT.CDX", "dFecEnt", "Dtos( dFecEnt )", {|| Dtos( Field->dFecEnt ) } ) )

      ( cPedCliT )->( ordCondSet( "!Deleted() .and. lInternet", {||!Deleted() .and. Field->lInternet } ) )
      ( cPedCliT )->( ordCreate( cPath + "PedCliT.Cdx", "lInternet", "Dtos( dFecCre ) + cTimCre", {|| Dtos( Field->dFecCre ) + Field->cTimCre } ) )

      ( cPedCliT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cPedCliT )->( ordCreate( cPath + "PEDCLIT.CDX", "CTURPED", "CTURPED + CSUFPED + CCODCAJ", {|| Field->CTURPED + Field->CSUFPED + Field->CCODCAJ} ) )

      ( cPedCliT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cPedCliT )->( ordCreate( cPath + "PEDCLIT.CDX", "cNumPre", "cNumPre", {|| Field->cNumPre } ) )

      ( cPedCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() } ))
      ( cPedCliT )->( ordCreate( cPath + "PedCliT.Cdx", "lSndDoc", "lSndDoc", {|| Field->lSndDoc } ) )

      ( cPedCliT )->( ordCondSet( "!Deleted()", {||!Deleted()}  ) )
      ( cPedCliT )->( ordCreate( cPath + "PedCliT.Cdx", "cCodUsr", "cCodUsr + Dtos( dFecCre ) + cTimCre", {|| Field->cCodUsr + Dtos( Field->dFecCre ) + Field->cTimCre } ) )

      ( cPedCliT )->( ordCondSet( "!Deleted() .and. lInternet .and. nEstado != 3", {|| !Deleted() .and. Field->lInternet .and. Field->nEstado != 3 } ) )
      ( cPedCliT )->( ordCreate( cPath + "PedCliT.Cdx", "lIntPedCli", "dFecPed", {|| Field->dFecPed } ) )

      ( cPedCliT )->( ordCondSet( "!Deleted()", {||!Deleted()}  ) )
      ( cPedCliT )->( ordCreate( cPath + "PedCliT.Cdx", "cNumAlb", "cNumAlb", {|| Field->cNumAlb } ) )

      ( cPedCliT )->( ordCondSet( "!Deleted()", {||!Deleted()}  ) )
      ( cPedCliT )->( ordCreate( cPath + "PedCliT.Cdx", "cCodWeb", "Str( cCodWeb )", {|| Str( Field->cCodWeb ) } ) )

      ( cPedCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( cPedCliT )->( ordCreate( cPath + "PedCliT.Cdx", "iNumPed", "'09' + cSerPed + Str( nNumPed ) + Space( 1 ) + cSufPed", {|| '09' + Field->cSerPed + Str( Field->nNumPed ) + Space( 1 ) + Field->cSufPed } ) )

      ( cPedCliT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cPedCliT )->( ordCreate( cPath + "PEDCLIT.CDX", "CSUPED", "CSUPED", {|| Field->CSUPED } ) )

      ( cPedCliT )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de pedidos de clientes" )
   end if

   dbUseArea( .t., cDriver(), cPath + "PEDCLIL.DBF", cCheckArea( "PEDCLIL", @cPedCliT ), .f. )
   if !( cPedCliT )->( neterr() )
      ( cPedCliT )->( __dbPack() )

      ( cPedCliT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cPedCliT )->( ordCreate( cPath + "PEDCLIL.CDX", "NNUMPED", "CSERPED + STR( NNUMPED ) + CSUFPED", {|| Field->CSERPED + STR( Field->NNUMPED ) + Field->CSUFPED } ) )

      ( cPedCliT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cPedCliT )->( ordCreate( cPath + "PEDCLIL.CDX", "cRef", "cRef", {|| Field->CREF } ) )

      ( cPedCliT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cPedCliT )->( ordCreate( cPath + "PEDCLIL.CDX", "Lote", "cLote", {|| Field->cLote } ) )

      ( cPedCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( cPedCliT )->( ordCreate( cPath + "PedCliL.Cdx", "iNumPed", "'09' + cSerPed + Str( nNumPed ) + Space( 1 ) + cSufPed", {|| '09' + Field->cSerPed + Str( Field->nNumPed ) + Space( 1 ) + Field->cSufPed } ) )

      ( cPedCliT )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de pedidos de clientes" )
   end if

   dbUseArea( .t., cDriver(), cPath + "PEDCLIR.DBF", cCheckArea( "PEDCLIR", @cPedCliT ), .f. )
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

   dbUseArea( .t., cDriver(), cPath + "PedCliI.DBF", cCheckArea( "PedCliI", @cPedCliT ), .f. )
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

   dbUseArea( .t., cDriver(), cPath + "PedCliD.DBF", cCheckArea( "PedCliD", @cPedCliT ), .f. )

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

   dbUseArea( .t., cDriver(), cPath + "PedCliP.DBF", cCheckArea( "PedCliP", @cPedCliT ), .f. )

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

RETURN NIL

//--------------------------------------------------------------------------//

function aItmPedCli()

   local aItmPedCli := {}

   aAdd( aItmPedCli, { "CSERPED", "C",    1,  0, "Serie del pedido",                "",                   "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "NNUMPED", "N",    9,  0, "N�mero del pedido",               "'999999999'",        "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "CSUFPED", "C",    2,  0, "Sufijo de pedido",                "",                   "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "CTURPED", "C",    6,  0, "Sesi�n del pedido",               "",                   "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "DFECPED", "D",    8,  0, "Fecha del pedido",                "",                   "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "CCODCLI", "C",   12,  0, "C�digo del cliente",              "",                   "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "CNOMCLI", "C",   80,  0, "Nombre del cliente",              "'@!'",               "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "CDIRCLI", "C",  100,  0, "Domicilio del cliente",           "'@!'",               "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "CPOBCLI", "C",   35,  0, "Poblaci�n del cliente",           "'@!'",               "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "CPRVCLI", "C",   20,  0, "Provincia del cliente",           "'@!'",               "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "CPOSCLI", "C",   15,  0, "C�digo postal del cliente",       "'@!'",               "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "CDNICLI", "C",   30,  0, "DNI del cliente",                 "'@!'",               "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "LMODCLI", "L",    1,  0, "Modificar datos del cliente",     "'@!'",               "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "CCODAGE", "C",    3,  0, "C�digo del agente",               "",                   "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "CCODOBR", "C",   10,  0, "C�digo de direcci�n",                  "",                   "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "CCODTAR", "C",    5,  0, "C�digo de tarifa",                "",                   "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "CCODALM", "C",   16,  0, "C�digo del almacen",              "",                   "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "CCODCAJ", "C",    3,  0, "C�digo de caja",                  "",                   "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "CCODPGO", "C",    2,  0, "C�digo de pago",                  "",                   "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "CCODRUT", "C",    4,  0, "C�digo de la ruta",               "",                   "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "DFECENT", "D",    8,  0, "Fecha de salida",                 "",                   "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "NESTADO", "N",    1,  0, "Estado del pedido",               "",                   "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "CSUPED",  "C",   35,  0, "Su pedido",                       "",                   "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "CCONDENT","C",  100,  0, "Condiciones del pedido",          "",                   "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "MCOMENT", "M",   10,  0, "Comentarios",                     "",                   "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "MOBSERV", "M",   10,  0, "Observaciones",                   "",                   "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "LMAYOR",  "L",    1,  0, "",                                "",                   "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "NTARIFA", "N",    1,  0, "Tarifa de precio aplicada",       "",                   "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "CDTOESP", "C",   50,  0, "Descripci�n de porcentaje de descuento","",             "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "NDTOESP", "N",    5,  2, "Porcentaje de descuento",         "'@EZ 99,99'",        "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "CDPP",    "C",   50,  0, "Descripci�n porcentaje de descuento por pronto pago","","", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "NDPP",    "N",    5,  2, "Pct. de dto. por pronto pago",    "'@EZ 99,99'",        "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "CDTOUNO", "C",   25,  0, "Desc. del primer descuento pers.","'@!'",               "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "NDTOUNO", "N",    5,  2, "Pct. del primer descuento pers.", "'@EZ 99,99'",        "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "CDTODOS", "C",   25,  0, "Desc. del segundo descuento pers.","'@!'",              "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "NDTODOS", "N",    5,  2, "Pct. del segundo descuento pers.","'@EZ 99,99'",        "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "NDTOCNT", "N",    5,  2, "Pct. de dto. por pago contado",   "'@EZ 99,99'",        "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "NDTORAP", "N",    5,  2, "Pct. de dto. por rappel",         "'@EZ 99,99'",        "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "NDTOPUB", "N",    5,  2, "Pct. de dto. por publicidad",     "'@EZ 99,99'",        "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "NDTOPGO", "N",    5,  2, "Pct. de dto. por pago centralizado", "'@EZ 99,99'",     "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "NDTOPTF", "N",    7,  2, "",                                "",                   "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "LRECARGO","L",    1,  0, "Aplicar recargo de equivalencia", "",                   "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "NPCTCOMAGE","N",  5,  2, "Pct. de comisi�n del agente",     "",                   "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "NBULTOS", "N",    3,  0, "N�mero de bultos",                "'999'",              "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "CNUMPRE", "C",   12,  0, "",                                "",                   "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "CDIVPED", "C",    3,  0, "C�digo de divisa",                "",                   "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "NVDVPED", "N",   10,  4, "Valor del cambio de la divisa",   "'@EZ 999,999.9999'", "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "LSNDDOC", "L",    1,  0, "Valor l�gico documento enviado",  "",                   "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "LPDTCRG", "L",    1,  0, "L�gico para ser entregado",       "",                   "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "NREGIVA", "N",    1,  0, "Regimen de " + cImp() ,           "",                   "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "LIVAINC", "L",    1,  0, "impuestos incluido" ,                  "",                   "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "NIVAMAN", "N",    6,  2, "Porcentaje de " + cImp() + " del gasto" , "'@EZ 999,99'","","( cDbf )", nil } )
   aAdd( aItmPedCli, { "NMANOBR", "N",   16,  6, "Gastos" ,                         "cPorDivPed",         "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "CCODTRN", "C",    9,  0, "C�digo de transportista" ,        "",                   "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "nKgsTrn", "N",   16,  6, "TARA del transportista" ,         "",                   "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "LCLOPED", "L",    1,  0, "L�gico de pedido cerrado" ,       "",                   "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "CCODUSR", "C",    3,  0, "C�digo de usuario",               "",                   "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "DFECCRE", "D",    8,  0, "Fecha de creaci�n del documento", "",                   "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "CTIMCRE", "C",    5,  0, "Hora de creaci�n del documento",  "",                   "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "CRETMAT", "C",   20,  0, "Matricula",                       "",                   "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "CRETPOR", "C",   20,  0, "Retirado por",                    "",                   "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "NPEDPROV","N",    1,  0, "",                                "",                   "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "NMONTAJE","N",    6 , 2, "Horas de montaje",                "'@EZ 999,99'",       "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "CCODGRP", "C",    4,  0, "C�digo de grupo de cliente",      "",                   "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "LIMPRIMIDO","L",  1,  0, "L�gico de imprimido",             "",                   "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "DFECIMP", "D",    8,  0, "�ltima fecha de impresi�n",       "",                   "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "CHORIMP", "C",    5,  0, "Hora de la �ltima impresi�n",     "",                   "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "cCodDlg", "C",    2,  0, "C�digo delegaci�n" ,              "",                   "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "nDtoAtp", "N",    6,  2, "Porcentaje de descuento at�pico", "",                   "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "nSbrAtp", "N",    1,  0, "Lugar donde aplicar dto at�pico", "",                   "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "cSituac", "C",   20,  0, "Situaci�n del documento",         "",                   "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "lWeb",    "L",    1,  0, "L�gico de recibido por web",      "",                   "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "lAlquiler","L",   1,  0, "L�gico de alquiler",              "",                   "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "DFECENTR","D",    8,  0, "Fecha de entrada de alquiler",    "",                   "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "DFECSAL", "D",    8,  0, "Fecha de salida de alquiler",     "",                   "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "CMANOBR", "C",  250,  0, "Literal de gastos" ,              "",                   "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "NGENERADO","N",   1,  0, "Estado generado" ,                "",                   "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "NRECIBIDO","N",   1,  0, "Estado recibido" ,                "",                   "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "LINTERNET","L",   1,  0, "Pedido desde internet" ,          "",                   "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "CNUMTIK",  "C",  13,  0, "N�mero del ticket generado" ,     "",                   "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "LCANCEL",  "L",   1,  0, "L�gico pedido cancelado" ,        "",                   "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "DCANCEL",  "D",   8,  0, "Fecha cancelaci�n" ,              "",                   "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "CCANCEL",  "C", 100,  0, "Motivo cancelaci�n" ,             "",                   "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "CCODWEB",  "N",  11,  0, "Codigo del pedido en la web" ,    "",                   "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "CTLFCLI",  "C",  20,  0, "Tel�fono del cliente" ,           "",                   "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "nTotNet",  "N",  16,  6, "Total neto" ,                     "",                   "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "nTotIva",  "N",  16,  6, "Total " + cImp() ,                "",                   "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "nTotReq",  "N",  16,  6, "Total recago" ,                   "",                   "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "nTotPed",  "N",  16,  6, "Total pedido" ,                   "",                   "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "cNumAlb",  "C",  12,  0, "N�mero del albar�n donde se agrupa" , "",               "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "lOperPV",  "L",   1,  0, "L�gico para operar con punto verde" , "",               "", "( cDbf )", .t. } )
   aAdd( aItmPedCli, { "cBanco",   "C",  50,  0, "Nombre del banco del cliente", "",                      "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "cPaisIBAN","C",   2,  0, "Pa�s IBAN de la cuenta bancaria del cliente", "",       "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "cCtrlIBAN","C",   2,  0, "D�gito de control IBAN de la cuenta bancaria del cliente", "", "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "cEntBnc",  "C",   4,  0, "Entidad de la cuenta bancaria del cliente", "",         "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "cSucBnc",  "C",   4,  0, "Sucursal de la cuenta bancaria del cliente", "",        "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "cDigBnc",  "C",   2,  0, "D�gito de control de la cuenta bancaria del cliente","","", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "cCtaBnc",  "C",  10,  0, "Cuenta bancaria del cliente", "",                       "", "( cDbf )", nil } )
   aAdd( aItmPedCli, { "lProduc",  "L",   1,  0, "L�gico para incluir en producci�n" , "",                "", "( cDbf )", .t. } )
   aAdd( aItmPedCli, { "nDtoTarifa","N",  6,  2, "Descuentos de tarifa", 			"", 		 	 	  "", "( cDbf )" } )

return ( aItmPedCli )

//---------------------------------------------------------------------------//

function aColPedCli()

   local aColPedCli  := {}

   aAdd( aColPedCli, { "cSerPed",   "C",    1,  0, "",                                "",                   "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "nNumPed",   "N",    9,  0, "",                                "'999999999'",        "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "cSufPed",   "C",    2,  0, "",                                "",                   "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "cRef",      "C",   18,  0, "Referencia del art�culo",         "",                   "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "cCodPr1",   "C",   20,  0, "C�digo de la primera propiedad",  "",                   "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "cCodPr2",   "C",   20,  0, "C�digo de la segunda propiedad",  "",                   "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "cValPr1",   "C",   40,  0, "Valor de la primera propiedad",   "",                   "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "cValPr2",   "C",   40,  0, "Valor de la segunda propiedad",   "",                   "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "cDetalle",  "C",  250,  0, "Descripci�n de art�culo",         "",                   "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "nIva"    ,  "N",    6,  2, "Porcentaje de impuesto",          "'@E 99.99'",         "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "nCanPed" ,  "N",   16,  6, "Cantidad pedida",                 "MasUnd()",           "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "nUniCaja",  "N",   16,  6, "Unidades por caja",               "MasUnd()",           "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "nUndKit",   "N",   16,  6, "Unidades del producto kit",       "MasUnd()",           "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "nPreDiv" ,  "N",   16,  6, "Precio del art�culo",             "cPorDivPed",         "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "nPntVer",   "N",   16,  6, "Importe punto verde",             "cPorDivPed",         "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "nImpTrn",   "N",   16,  6, "Importe de portes",               "cPorDivPed",         "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "NDTO",      "N",    6,  2, "Descuento del producto",          "'@E 99.9'",          "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "NDTOPRM",   "N",    6,  2, "Descuento de la promoci�n",       "'@E 99.9'",          "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "NCOMAGE",   "N",    6,  2, "Comisi�n del agente",             "'@E 99.9'",          "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "NCANENT",   "N",   16,  6, "",                                "",                   "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "NUNIENT",   "N",   16,  6, "",                                "",                   "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "CUNIDAD",   "C",    2,  0, "Unidad de medici�n",              "",                   "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "NPESOKG",   "N",   16,  6, "Peso del producto",               "",                   "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "CPESOKG",   "C",    2,  0, "Unidad de peso del producto",     "",                   "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "DFECHA",    "D",    8,  0, "Fecha de entrega",                "",                   "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "CTIPMOV",   "C",    2,  0, "Tipo de movimiento",              "",                   "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "MLNGDES",   "M",   10,  0, "Descripci�n de art�culo sin codificar", "",             "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "LTOTLIN",   "L",    1,  0, "L�nea de total",                  "",                   "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "LIMPLIN",   "L",    1,  0, "L�nea no imprimible",             "",                   "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "NFACCNV",   "N",   13,  4, "",                                "",                   "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "NDTODIV",   "N",   16,  6, "Descuento lineal de la compra",   "cPorDivPed",         "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "LRESUND",   "L",    1,  0, "Reservar unidades del stock",     "",                   "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "NRESUND",   "N",   16,  6, "Unidades reservadas de del stock","",                   "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "NRETUND",   "N",   16,  6, "Und. entregadas de las reservadas","",                  "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "NNUMLIN",   "N",    4,  0, "Numero de la l�nea",              "'9999'",             "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "NCTLSTK",   "N",    1,  0, "Tipo de stock de la linea",       "'9'",                "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "NCOSDIV",   "N",   16,  6, "Costo del producto" ,             "cPorDivPre",         "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "NPVPREC",   "N",   16,  6, "Precio de venta recomendado" ,    "cPorDivPre",         "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "CALMLIN",   "C",   16,  0, "C�digo de almac�n" ,              "",                   "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "CCODIMP",   "C",    3,  0, "C�digo del IVMH",                 "",                   "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "NVALIMP",   "N",   16,  6, "Importe de impuesto",             "",                   "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "LIVALIN",   "L",    1,  0, "L�nea con impuesto incluido",     "",                   "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "LLOTE",     "L",    1,  0, "",                                "",                   "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "NLOTE",     "N",    9,  0, "",                                "'999999999'",        "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "CLOTE",     "C",   12,  0, "N�mero de lote",                  "",                   "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "LKITART",   "L",    1,  0, "L�nea con escandallo",            "",                   "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "LKITCHL",   "L",    1,  0, "L�nea pertenciente a escandallo", "",                   "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "LKITPRC",   "L",    1,  0, "L�nea de escandallos con precio", "",                   "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "NMESGRT",   "N",    2,  0, "Meses de garant�a",               "'99'",               "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "LMSGVTA",   "L",    1,  0, "Avisar en venta sin stocks",      "",                   "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "LNOTVTA",   "L",    1,  0, "No permitir venta sin stocks",    "",                   "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "LCONTROL",  "L",    1,  0, "" ,                               "",                   "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "MNUMSER",   "M",   10,  0, "" ,                               "",                   "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "cCodTip",   "C",    3,  0, "C�digo del tipo de art�culo",     "",                   "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "LANULADO",  "L",    1,  0, "Anular linea",                    "",                   "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "DANULADO",  "D",    8,  0, "Fecha de anulacion",              "",                   "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "MANULADO",  "M",  100,  0, "Motivo anulacion",                "",                   "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "CCODFAM",   "C",   16,  0, "C�digo de familia",               "",                   "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "CGRPFAM",   "C",    3,  0, "C�digo de grupo de familia",      "",                   "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "NREQ",      "N",   16,  6, "Recargo de equivalencia",         "",                   "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "MOBSLIN",   "M",   10,  0, "Observaciones de linea",          "",                   "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "NRECIBIDA", "N",    1,  0, "Estado si recibido del art�culo", "",                   "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "CCODPRV",   "C",   12,  0, "C�digo del proveedor",            "",                   "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "CNOMPRV",   "C",   30,  0, "Nombre del proveedor",            "",                   "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "CIMAGEN",   "C",  250,  0, "Fichero de imagen" ,              "",                   "", "( cDbfCol )", .t. } )
   aAdd( aColPedCli, { "NPUNTOS",   "N",   15,  6, "Puntos del art�culo",             "",                   "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "NVALPNT",   "N",   16,  6, "Valor del punto",                 "",                   "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "NDTOPNT",   "N",    6,  2, "Descuento puntos",                "",                   "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "NINCPNT",   "N",    6,  2, "Incremento porcentual",           "",                   "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "CREFPRV",   "C",   18,  0, "Referencia proveedor",            "",                   "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "NVOLUMEN",  "N",   16,  6, "Volumen del producto" ,           "'@E 9,999.99'",      "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "CVOLUMEN",  "C",    2,  0, "Unidad del volumen" ,             "",                   "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "DFECENT" ,  "D",    8,  0, "Fecha de entrada del alquiler",   "",                   "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "dFecSal" ,  "D",    8,  0, "Fecha de salida del alquiler",    "",                   "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "lAlquiler" ,"L",    1,  0, "L�gico de alquiler",              "",                   "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "nPreAlq",   "N",   16,  6, "Precio de alquiler",              "",                   "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "nNumMed",   "N",    1,  0, "N�mero de mediciones",            "MasUnd()",           "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "nMedUno",   "N",   16,  6, "Primera unidad de medici�n",      "MasUnd()",           "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "nMedDos",   "N",   16,  6, "Segunda unidad de medici�n",      "MasUnd()",           "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "nMedTre",   "N",   16,  6, "Tercera unidad de medici�n",      "MasUnd()",           "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "nTarLin",   "N",    1,  0, "Tarifa de precio aplicada" ,      "",                   "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "lImpFra",   "L",    1,  0, "L�gico de imprimir frase publicitaria", "",             "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "cCodFra",   "C",    3,  0, "C�digo de frase publicitaria",     "",                  "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "cTxtFra",   "C",  250,  0, "",                                 "",                  "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "Descrip",   "M",   10,  0, "Descripci�n larga",                "",                  "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "lLinOfe",   "L",    1,  0, "Linea con oferta",                 "",                  "", "( cDbfCol )", .f. } )
   aAdd( aColPedCli, { "lVolImp",   "L",    1,  0, "L�gico aplicar volumen con impuestos especiales",  "",  "", "( cDbfCol )", .f. } )
   aAdd( aColPedCli, { "nProduc",   "N",    1,  0, "L�gico de producido",              "",                  "", "( cDbfCol )", .f. } )
   aAdd( aColPedCli, { "dFecCad",   "D",    8,  0, "Fecha de caducidad",               "",                  "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "dFecUltCom","D",    8,  0, "Fecha ultima venta",               "",                  "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "lFromAtp"  ,"L",    1,  0, "", 								   "",          		"", "( cDbfCol )", .f. } )
   aAdd( aColPedCli, { "nUniUltCom","N",   16,  6, "Unidades �ltima compra",		   "",                  "", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "nBultos",   "N",   16,  6, "Numero de bultos en l�neas", 	   "",              	"", "( cDbfCol )", nil } )
   aAdd( aColPedCli, { "cFormato",  "C",  100,  0, "Formato de venta",                 "",              	"", "( cDbfCol )", nil } )

return ( aColPedCli )

//---------------------------------------------------------------------------//

function aIncPedCli()

   local aIncPedCli  := {}

   aAdd( aIncPedCli, { "cSerPed", "C",    1,  0, "Serie de pedido" ,                      "",                   "", "( cDbfCol )", nil } )
   aAdd( aIncPedCli, { "nNumPed", "N",    9,  0, "N�mero de pedido" ,                     "'999999999'",        "", "( cDbfCol )", nil } )
   aAdd( aIncPedCli, { "cSufPed", "C",    2,  0, "Sufijo de pedido" ,                     "",                   "", "( cDbfCol )", nil } )
   aAdd( aIncPedCli, { "cCodTip", "C",    3,  0, "Tipo de incidencia" ,                   "",                   "", "( cDbfCol )", nil } )
   aAdd( aIncPedCli, { "dFecInc", "D",    8,  0, "Fecha de la incidencia" ,               "",                   "", "( cDbfCol )", nil } )
   aAdd( aIncPedCli, { "mDesInc", "M",   10,  0, "Descripci�n de la incidencia" ,         "",                   "", "( cDbfCol )", nil } )
   aAdd( aIncPedCli, { "lListo",  "L",    1,  0, "L�gico de listo" ,                      "",                   "", "( cDbfCol )", nil } )
   aAdd( aIncPedCli, { "lAviso",  "L",    1,  0, "L�gico de aviso" ,                      "",                   "", "( cDbfCol )", nil } )
   aAdd( aIncPedCli, { "lSndWeb", "L",    1,  0, "L�gico de incidencia subia a la web" ,  "",                   "", "( cDbfCol )", nil } )

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

function aPedCliPgo()

   local aPedCliPgo  := {}

   aAdd( aPedCliPgo, {"cSerPed"     ,"C",  1, 0, "Serie de pedido" ,            "",                   "", "( cDbfEnt )", nil } )
   aAdd( aPedCliPgo, {"nNumPed"     ,"N",  9, 0, "Numero de pedido" ,           "'999999999'",        "", "( cDbfEnt )", nil } )
   aAdd( aPedCliPgo, {"cSufPed"     ,"C",  2, 0, "Sufijo de pedido" ,           "",                   "", "( cDbfEnt )", nil } )
   aAdd( aPedCliPgo, {"nNumRec"     ,"N",  2, 0, "Numero del recibo",           "",                   "", "( cDbfEnt )", nil } )
   aAdd( aPedCliPgo, {"cCodCaj"     ,"C",  3, 0, "C�digo de caja",              "",                   "", "( cDbfEnt )", nil } )
   aAdd( aPedCliPgo, {"cTurRec"     ,"C",  6, 0, "Sesi�n del recibo",           "######",             "", "( cDbfEnt )", nil } )
   aAdd( aPedCliPgo, {"cCodCli"     ,"C", 12, 0, "C�digo de cliente",           "",                   "", "( cDbfEnt )", nil } )
   aAdd( aPedCliPgo, {"dEntrega"    ,"D",  8, 0, "Fecha de cobro",              "",                   "", "( cDbfEnt )", nil } )
   aAdd( aPedCliPgo, {"nImporte"    ,"N", 16, 6, "Importe",                     "cPorDivEnt",         "", "( cDbfEnt )", nil } )
   aAdd( aPedCliPgo, {"cDescrip"    ,"C",100, 0, "Concepto del pago",           "",                   "", "( cDbfEnt )", nil } )
   aAdd( aPedCliPgo, {"cPgdoPor"    ,"C", 50, 0, "Pagado por",                  "",                   "", "( cDbfEnt )", nil } )
   aAdd( aPedCliPgo, {"cDocPgo"     ,"C", 50, 0, "Documento de pago",           "",                   "", "( cDbfEnt )", nil } )
   aAdd( aPedCliPgo, {"cDivPgo"     ,"C",  3, 0, "C�digo de la divisa",         "",                   "", "( cDbfEnt )", nil } )
   aAdd( aPedCliPgo, {"nVdvPgo"     ,"N", 10, 6, "Valor de la divisa",          "",                   "", "( cDbfEnt )", nil } )
   aAdd( aPedCliPgo, {"cCodAge"     ,"C",  3, 0, "C�digo del agente",           "",                   "", "( cDbfEnt )", nil } )
   aAdd( aPedCliPgo, {"cCodPgo"     ,"C",  2, 0, "C�digo de pago",              "",                   "", "( cDbfEnt )", nil } )
   aAdd( aPedCliPgo, {"lCloPgo"     ,"L",  1, 0, "L�gico cerrado turno",        "",                   "", "( cDbfEnt )", nil } )
   aAdd( aPedCliPgo, {"lPasado"     ,"L",  1, 0, "L�gico pasado albar�n",       "",                   "", "( cDbfEnt )", nil } )
   aAdd( aPedCliPgo, {"cBncEmp"     ,"C", 50, 0, "Banco de la empresa para el recibo" ,"",            "", "( cDbfEnt )", nil } )
   aAdd( aPedCliPgo, {"cBncCli"     ,"C", 50, 0, "Banco del cliente para el recibo" ,"",              "", "( cDbfEnt )", nil } )
   aAdd( aPedCliPgo, {"cEPaisIBAN"  ,"C",  2, 0, "Pa�s IBAN de la cuenta de la empresa",  "",        	"", "( cDbfEnt )", nil } )
   aAdd( aPedCliPgo, {"cECtrlIBAN"  ,"C",  2, 0, "Digito de control IBAN de la cuenta de la empresa", "", "", "( cDbfEnt )", nil } )
   aAdd( aPedCliPgo, {"cEntEmp"     ,"C",  4, 0, "Entidad de la cuenta de la empresa",  "",           "", "( cDbfEnt )", nil } )
   aAdd( aPedCliPgo, {"cSucEmp"     ,"C",  4, 0, "Sucursal de la cuenta de la empresa",  "",          "", "( cDbfEnt )", nil } )
   aAdd( aPedCliPgo, {"cDigEmp"     ,"C",  2, 0, "D�gito de control de la cuenta de la empresa", "",  "", "( cDbfEnt )", nil } )
   aAdd( aPedCliPgo, {"cCtaEmp"     ,"C", 10, 0, "Cuenta bancaria de la empresa",  "",                "", "( cDbfEnt )", nil } )
   aAdd( aPedCliPgo, {"cPaisIBAN"   ,"C",  2, 0, "Pa�s IBAN de la cuenta del cliente",  "",        	"", "( cDbfEnt )", nil } )
   aAdd( aPedCliPgo, {"cCtrlIBAN"   ,"C",  2, 0, "Digito de control IBAN de la cuenta del cliente", "", "", "( cDbfEnt )", nil } )
   aAdd( aPedCliPgo, {"cEntCli"     ,"C",  4, 0, "Entidad de la cuenta del cliente",  "",             "", "( cDbfEnt )", nil } )
   aAdd( aPedCliPgo, {"cSucCli"     ,"C",  4, 0, "Sucursal de la cuenta del cliente",  "",            "", "( cDbfEnt )", nil } )
   aAdd( aPedCliPgo, {"cDigCli"     ,"C",  2, 0, "D�gito de control de la cuenta del cliente", "",    "", "( cDbfEnt )", nil } )
   aAdd( aPedCliPgo, {"cCtaCli"     ,"C", 10, 0, "Cuenta bancaria del cliente",  "",                  "", "( cDbfEnt )", nil } )

return ( aPedCliPgo )

//---------------------------------------------------------------------------//

//
// Numero de unidades por linea
//

function nTotNPedCli( uDbf )

   local nTotUnd

   DEFAULT uDbf   := dbfPedCliL

   do case
   case ValType( uDbf ) == "A"

      if uDbf[ __LALQUILER ]

         nTotUnd  := NotCaja( uDbf[ _NCANPED ] )
         nTotUnd  *= uDbf[ _NUNICAJA ]
         nTotUnd  *= NotCero( uDbf[ _NUNDKIT ] )
         nTotUnd  *= NotCero( uDbf[ __DFECENT ] - uDbf[ __DFECSAL ] )
         nTotUnd  *= NotCero( uDbf[ _NMEDUNO ] )
         nTotUnd  *= NotCero( uDbf[ _NMEDDOS ] )
         nTotUnd  *= NotCero( uDbf[ _NMEDTRE ] )

      else

         nTotUnd  := NotCaja( uDbf[ _NCANPED ] )
         nTotUnd  *= uDbf[ _NUNICAJA ]
         nTotUnd  *= NotCero( uDbf[ _NUNDKIT ] )
         nTotUnd  *= NotCero( uDbf[ _NMEDUNO ] )
         nTotUnd  *= NotCero( uDbf[ _NMEDDOS ] )
         nTotUnd  *= NotCero( uDbf[ _NMEDTRE ] )

      end if

   case ValType( uDbf ) == "O"

      if uDbf:lAlquiler

         nTotUnd  := NotCaja( uDbf:nCanPed )
         nTotUnd  *= uDbf:nUniCaja
         nTotUnd  *= NotCero( uDbf:nUndKit )
         nTotUnd  *= NotCero( uDbf:dFecEnt - uDbf:dFecSal )
         nTotUnd  *= NotCero( uDbf:nMedUno )
         nTotUnd  *= NotCero( uDbf:nMedDos )
         nTotUnd  *= NotCero( uDbf:nMedTre )

      else

         nTotUnd  := NotCaja( uDbf:nCanPed )
         nTotUnd  *= uDbf:nUniCaja
         nTotUnd  *= NotCero( uDbf:nUndKit )
         nTotUnd  *= NotCero( uDbf:nMedUno )
         nTotUnd  *= NotCero( uDbf:nMedDos )
         nTotUnd  *= NotCero( uDbf:nMedTre )

      end if

   otherwise

      if ( uDbf )->lAlquiler

         nTotUnd  := NotCaja( ( uDbf )->nCanPed )
         nTotUnd  *= ( uDbf )->nUniCaja
         nTotUnd  *= NotCero( ( uDbf )->nUndKit )
         nTotUnd  *= NotCero( ( uDbf )->dFecEnt - ( uDbf )->dFecSal )
         nTotUnd  *= NotCero( ( uDbf )->nMedUno )
         nTotUnd  *= NotCero( ( uDbf )->nMedDos )
         nTotUnd  *= NotCero( ( uDbf )->nMedTre )

      else
         nTotUnd  := NotCaja( ( uDbf )->nCanPed )
         nTotUnd  *= ( uDbf )->nUniCaja
         nTotUnd  *= NotCero( ( uDbf )->nUndKit )
         nTotUnd  *= NotCero( ( uDbf )->nMedUno )
         nTotUnd  *= NotCero( ( uDbf )->nMedDos )
         nTotUnd  *= NotCero( ( uDbf )->nMedTre )
      end if

   end case

return ( nTotUnd )

//---------------------------------------------------------------------------//

FUNCTION nTotRPedCli( cPedido, cRef, cValPr1, cValPr2, dbfPedCliR )

   local nTotRes     := 0
   local nOrd
   local nRec        := ( dbfPedCliR )->( Recno() )

   DEFAULT cValPr1   := Space( 40 )
   DEFAULT cValPr2   := Space( 40 )

   if cPedido == nil

      nOrd           := ( dbfPedCliR )->( OrdSetFocus( "cRef" ) )

      if ( dbfPedCliR )->( dbSeek( cRef + cValPr1 + cValPr2 ) )
         while ( dbfPedCliR )->cRef + ( dbfPedCliR )->cValPr1 + ( dbfPedCliR )->cValPr2 == cRef + cValPr1 + cValPr2 .and. !( dbfPedCliR )->( eof() )
            nTotRes  += nTotNResCli( dbfPedCliR )
            ( dbfPedCliR )->( dbSkip() )
         end while
      end if

      ( dbfPedCliR )->( OrdSetFocus( nOrd ) )

   else

      nOrd           := ( dbfPedCliR )->( OrdSetFocus( "nNumPed" ) )

      if ( dbfPedCliR )->( dbSeek( cPedido + cRef + cValPr1 + cValPr2 ) )
         while ( dbfPedCliR )->cSerPed + Str( ( dbfPedCliR )->nNumPed ) + ( dbfPedCliR )->cSufPed + ( dbfPedCliR )->cRef + ( dbfPedCliR )->cValPr1 + ( dbfPedCliR )->cValPr2 == cPedido + cRef + cValPr1 + cValPr2 .and. !( dbfPedCliR )->( eof() )
            nTotRes  += nTotNResCli( dbfPedCliR )
            ( dbfPedCliR )->( dbSkip() )
         end while
      end if

      ( dbfPedCliR )->( OrdSetFocus( nOrd ) )

   end if

   ( dbfPedCliR )->( dbGoTo( nRec ) )

return ( nTotRes )

//---------------------------------------------------------------------------//

/*
Calcula el Total del pedido
*/

FUNCTION nTotPedCli( cPedido, cPedCliT, cPedCliL, cIva, cDiv, cFpago, aTmp, cDivRet, lPic, cClient )

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
   	local n
   	local nDescuentosLineas := 0
   	local lPntVer           := .f.

   	if !Empty( nView )
   		DEFAULT cPedCliT   	:= TDataView():PedidosClientes( nView )
		DEFAULT cClient   	:= TDataView():Clientes( nView )
	end if	
   	
   	DEFAULT cPedCliL        := dbfPedCliL
   	DEFAULT cIva            := dbfIva
   	DEFAULT cDiv            := dbfDiv
   	DEFAULT cFPago          := dbfFPago
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

   nTotImp           := nTotIva + nTotReq + nTotIvm


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

   DEFAULT uTmpLin      := dbfPedCliL
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

//
// Total anticipos de un pedido
//

FUNCTION nPagPedCli( cNumPed, dbfPedCliP, dbfDiv, cDivRet, lPic, lAll )

   local nRec           := ( dbfPedCliP )->( Recno() )
   local nOrd           := ( dbfPedCliP )->( OrdSetFocus( "nNumPed" ) )
   local cCodDiv        := cDivEmp()
   local cPorDiv        := cPorDiv( cCodDiv, dbfDiv ) // Picture de la divisa redondeada
   local nRouDiv        := nRouDiv( cCodDiv, dbfDiv )

   nTotPag              := 0

   DEFAULT lPic         := .f.
   DEFAULT lAll         := .t.

   if Empty( cNumPed )

      ( dbfPedCliP )->( dbGoTop() )
      while !( dbfPedCliP )->( Eof() )

         if lAll .or. !( dbfPedCliP )->lPasado
            nTotPag     += nEntPedCli( dbfPedCliP, dbfDiv, cDivRet )
         end if

         ( dbfPedCliP )->( dbSkip() )

      end while

   else

      if ( dbfPedCliP )->( dbSeek( cNumPed ) )

         while ( dbfPedCliP )->cSerPed + Str( ( dbfPedCliP )->nNumPed ) + ( dbfPedCliP )->cSufPed == cNumPed .and. !( dbfPedCliP )->( eof() )

            if lAll .or. !( dbfPedCliP )->lPasado
               nTotPag   += nEntPedCli( dbfPedCliP, dbfDiv, cDivRet )
            end if

            ( dbfPedCliP )->( dbSkip() )

         end while

      end if

   end if

   if cDivRet != nil .and. cCodDiv != cDivRet
      nTotPag           := nCnv2Div( nTotPag, cCodDiv, cDivRet )
      cPorDiv           := cPorDiv( cDivRet, dbfDiv ) // Picture de la divisa redondeada
      nRouDiv           := nRouDiv( cDivRet, dbfDiv )
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

   DEFAULT uPedCliP  := dbfPedCliP
   DEFAULT cDbfDiv   := dbfDiv
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

FUNCTION nComLPedCli( uPedCliT, dbfPedCliL, nDecOut, nDerOut )

   local nImpLPedCli  := nImpLPedCli( uPedCliT, dbfPedCliL, nDecOut, nDerOut, , .f., .t., .f. )

RETURN ( nImpLPedCli * ( dbfPedCliL )->nComAge / 100 )

//--------------------------------------------------------------------------//

/*
 C�lculo del neto, sin descuentos para las comisiones de los agentes
*/

FUNCTION nImpLPedCli( uPedCliT, dbfPedCliL, nDec, nRou, nVdv, lIva, lDto, lPntVer, lImpTrn, cPouDiv )

   local nCalculo
   local lIvaInc

   DEFAULT nDec      := 0
   DEFAULT nRou      := 0
   DEFAULT nVdv      := 1
   DEFAULT lIva      := .f.
   DEFAULT lDto      := .t.
   DEFAULT lPntVer   := .f.
   DEFAULT lImpTrn   := .f.

   nCalculo          := nTotLPedCli( dbfPedCliL, nDec, nRou, nVdv, .t., lImpTrn, lPntVer )

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

   if ( dbfPedCliL )->nIva != 0
      if lIva  // lo quermos con impuestos
         if !lIvaInc
            nCalculo += Round( nCalculo * ( dbfPedCliL )->nIva / 100, nRou )
         end if
      else     // lo queremos sin impuestos
         if lIvaInc
            nCalculo -= Round( nCalculo / ( 100 / ( dbfPedCliL )->nIva  + 1 ), nRou )
         end if
      end if
   end if

RETURN ( if( cPouDiv != NIL, Trans( nCalculo, cPouDiv ), nCalculo ) )

//---------------------------------------------------------------------------//

FUNCTION nPesLPedCli( cPedCliL )

	local nCalculo

   DEFAULT cPedCliL  := dbfPedCliL

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

   local nCalculo    := 0

   DEFAULT dbfLin    := dbfPedCliL
   DEFAULT nDec      := 0
   DEFAULT nRouDec   := 0
   DEFAULT nVdv      := 1

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

   DEFAULT dbfLin    := dbfPedCliL
   DEFAULT nDec      := 2
   DEFAULT nRou      := 2
   DEFAULT nVdv      := 1

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

   DEFAULT dbfLin    := dbfPedCliL
   DEFAULT nDec      := 2
   DEFAULT nVdv      := 1

   /*
   Punto Verde
   */

   nPntVer           := ( dbfLin )->nPntVer / nVdv
   nPntVer           *= nTotNPedCli( dbfLin )

RETURN ( Round( nPntVer, nDec ) )

//---------------------------------------------------------------------------//

FUNCTION nTotLPedCli( cPedCliL, nDec, nRou, nVdv, lDto, lPntVer, lImpTrn, cPouDiv )

   local nCalculo

   DEFAULT cPedCliL  := dbfPedCliL
   DEFAULT nDec      := nDouDiv()
   DEFAULT nRou      := nRouDiv()
   DEFAULT nVdv      := 1
   DEFAULT lDto      := .t.
   DEFAULT lPntVer   := .t.
   DEFAULT lImpTrn   := .t.

   if ( cPedCliL )->lTotLin

      nCalculo       := nTotUPedCli( cPedCliL, nDec )
      
   else

      nCalculo       := nTotUPedCli( cPedCliL, nDec )

      /*
      Descuentos lineales------------------------------------------------------
      */

      if lDto

      	nCalculo  	-= Round( ( cPedCliL )->nDtoDiv / nVdv , nDec )
      
      	if ( cPedCliL )->nDto != 0
         	nCalculo -= nCalculo * ( cPedCliL )->nDto    / 100
      	end if

      	if ( cPedCliL )->nDtoPrm != 0
         	nCalculo -= nCalculo * ( cPedCliL )->nDtoPrm / 100
      	end if

      end if 

      /*
      Punto Verde--------------------------------------------------------------
      */

      if lPntVer
         nCalculo    += ( cPedCliL )->nPntVer
      end if

      /*
      Transporte---------------------------------------------------------------
      */

      if lImpTrn 
         nCalculo    += ( cPedCliL )->nImpTrn
      end if

      /* 
      Unidades-----------------------------------------------------------------
      */

      nCalculo       *= nTotNPedCli( cPedCliL )

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

   DEFAULT cPedCliL     := dbfPedCliL
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

   DEFAULT cPedCliL     := dbfPedCliL
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

   DEFAULT dbfLin    := dbfPedCliL
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

      USE ( cPatDat() + "TIVA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIVA", @dbfIva ) )
      SET ADSINDEX TO ( cPatDat() + "TIVA.CDX" ) ADDITIVE

      USE ( cPatGrp() + "FPAGO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FPAGO", @dbfFPago ) )
      SET ADSINDEX TO ( cPatGrp() + "FPAGO.CDX" ) ADDITIVE

      USE ( cPatDat() + "DIVISAS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "DIVISAS", @dbfDiv ) )
      SET ADSINDEX TO ( cPatDat() + "DIVISAS.CDX" ) ADDITIVE

      USE ( cPatCli() + "CLIENT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CLIENT", @dbfClient ) )
      SET ADSINDEX TO ( cPatCli() + "CLIENT.CDX" ) ADDITIVE

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
         :SetCheck( { "Bullet_Square_Yellow_16", "Bullet_Square_Red_16" } )
      end with

      with object ( oBrwPedidosWeb:AddCol() )
         :cHeader          := "N�mero"
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
         :bEditValue       := {|| nTotPedCli( ( dbfPedCliT )->cSerPed + Str( ( dbfPedCliT )->nNumPed ) + ( dbfPedCliT )->cSufPed, dbfPedCliT, dbfPedCliL, dbfIva, dbfDiv, dbfFPago, nil, cDivEmp(), .t. ) }
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
         :cHeader             := "C�digo"
         :bEditValue          := {|| ( dbfTmpLin )->cRef }
         :nWidth              := 70
      end with

      with object ( oBrwDetallesPedidos:AddCol() )
         :cHeader             := "Descripci�n"
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
         :cHeader             := "UM. Unidad de medici�n"
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
   CLOSE ( dbfFPago   )
   CLOSE ( dbfDiv     )
   CLOSE ( dbfIva     )
   CLOSE ( dbfClient  )
   CLOSE ( dbfTmpLin  )

   oDlgPedidosWeb          := nil
   oBrwPedidosWeb          := nil
   oBrwDetallesPedidos     := nil

   dbfErase( cTmpLin )

Return ( cNumPed )

//---------------------------------------------------------------------------//

Function lPedidosWeb( cPedCliT )

   local nRec
   local oBlock
   local oError
   local lClose               := .f.

   oBlock                     := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      if Empty( cPedCliT )
	    USE ( cPatEmp() + "PedCliT.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PedCliT", @cPedCliT ) )
    	SET ADSINDEX TO ( cPatEmp() + "PEDCLIT.CDX" ) ADDITIVE
        lClose               := .t.
      else
         nRec                := ( cPedCliT )->( Recno() )
      end if

      if dbSeekInOrd( .t., "lIntPedCli", cPedCliT )

         lStartAvisoPedidos()

         /*
         Muestro un aviso en la barra de estado-----------------------------------
         */

         if Empty( oMsgAlarm )
            oMsgAlarm         := TMsgItem():New( oWnd():oMsgBar,,24,,,,.t.,, "Sndint16",, "Nuevos pedidos recibidos"  )
            oMsgAlarm:bAction := {|| PedCli() }
         end if

      else

         lStopAvisoPedidos()

         /*
         Elimino aviso en la barra de estado--------------------------------------
         */

         if !Empty( oMsgAlarm )
            oWnd():oMsgBar:DelItem( oMsgAlarm )
         end if

      end if

   RECOVER USING oError

   END SEQUENCE

   ErrorBlock( oBlock )

   if ( cPedCliT )->( Used() )
      if lClose
         ( cPedCliT )->( dbCloseArea() )
      else
         ( cPedCliT )->( dbGoTo( nRec ) )
      end if
   end if

Return nil

//---------------------------------------------------------------------------//

/*
Cambia el importe unitario de la linea
*/

FUNCTION SetUPedCli( dbfLin, nNewVal )

   	DEFAULT dbfLin    			:= dbfPedCliL

    if ( dbfLin )->lAlquiler
       ( dbfLin )->nPreAlq 		:= nNewVal
    else
       ( dbfLin )->nPreDiv  	:= nNewVal
    end if

RETURN ( nil )

//---------------------------------------------------------------------------//

Function sTotPedCli( cPedido, dbfMaster, dbfLine, dbfIva, dbfDiv, cDivRet )

   local sTotal

   nTotPedCli( cPedido, dbfMaster, dbfLine, dbfIva, dbfDiv, nil, nil, cDivRet, .f. )

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

//--------------------------------------------------------------------------//