#include "FiveWin.Ch" 
#include "Folder.ch"
#include "Report.ch"
#include "Menu.ch"
#include "Xbrowse.ch"
#include "Factu.ch"

#define CLR_BAR                  14197607
#define _MENUITEM_               "01057"

#define impuestos_DESG           1
#define impuestos_INCL           2

#define albNoFacturado           1
#define albParcialmenteFacturado 2
#define albTotalmenteFacturado   3

#define aTextoEstadoFacturado    { "No facturado", "Parcialmente", "Facturado" }

/*
Definición de la base de datos de albaranes a CLIENTES-------------------------
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
#define _CPAISIBAN                96
#define _CCTRLIBAN                97
#define _CENTBNC                  98
#define _CSUCBNC                  99
#define _CDIGBNC                  100
#define _CCTABNC                  101
#define _NDTOTARIFA               102 
#define _NFACTURADO               103
#define _TFECALB                  104
#define _CCENTROCOSTE             105  
#define _MFIRMA                   106

/*
Definici¢n de la base de datos de lineas de detalle
*/

#define _dCSERALB                 1           
#define _dNNUMALB                 2
#define _dCSUFALB                 3
#define _CREF                     4
#define _CDETALLE                 5
#define _NPREUNIT                 6
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
#define __CNUMPED                 27
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
#define _NPREALQ                  70
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
#define __LFACTURADO              90      //   L      1     0
#define _LLINOFE                  91      //   L      1     0
#define _LVOLIMP                  92
#define __DFECALB                 93
#define __CNUMSAT                 94
#define _LFROMATP                 95
#define __CCODCLI                 96
#define _DFECULTCOM               97  
#define _DUNIULTCOM               98
#define __NBULTOS                 99
#define _CFORMATO                100
#define __TFECALB                101
#define __CCENTROCOSTE           102
#define _LLABEL                  103
#define _NLABEL                  104
#define _COBRLIN                 105
#define _CREFAUX                 106
#define _CREFAUX2                107
#define _NPOSPRINT               108
#define _CTIPCTR                 109
#define _CTERCTR                 110
#define _NNUMKIT                 111
#define _ID_TIPO_V               112
#define __NREGIVA                113
#define _NPRCULTCOM              114

/*
Definici¢n de Array para impuestos
*/

memvar cDbf
memvar cDbfCol
memvar cDbfPag
memvar cCliente
memvar cDbfCli
memvar cIva
memvar cDbfIva
memvar cDbfDiv
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
Definici¢n de Array para objetos impuestos
*/

static oWndBrw
static oBrwIva
static nView
static dbfProSer
static dbfMatSer
static dbfAlbPrvL
static dbfAlbPrvS
static dbfTmpLin
static dbfTmpInc
static dbfTmpDoc
static dbfTmpPgo
static dbfTmpEst
static dbfTmpSer
static dbfAlbCliE
static dbfDelega
static cTmpLin
static cTmpInc
static cTmpDoc
static cTmpPgo
static cTmpEst
static cTmpSer
static dbfRuta
static dbfCliBnc
static dbfArtPrv
static dbfAlm
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
static dbfAlbCliT
static dbfAlbCliL
static dbfAlbCliI
static dbfAlbCliD
static dbfAlbCliS
static dbfFacRecT
static dbfFacRecL
static dbfFacRecS
static dbfPedPrvL
static dbfTikT
static dbfTikL
static dbfTikS
static dbfCodebar
static dbfPromoT
static dbfPromoL
static dbfPromoC
static dbfTblPro
static dbfPro
static dbfCajT
static dbfFacPrvL
static dbfFacPrvS
static dbfRctPrvL
static dbfRctPrvS
static dbfProLin
static dbfProMat
static dbfEmp
static oMenu
static oDetMenu
static oStock
static TComercio
static oNewImp
static oUndMedicion
static oCentroCoste
static oBandera
static dbfKit
static dbfOferta
static dbfObrasT
static dbfCentroCoste
static dbfArtDiv
static dbfAgeCom
static oGetTotal
static oGetTarifa
static oGetIvm
static oGetRnt
static cGetRnt          := ""
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
static oPais

static Counter

static oDetCamposExtra
static oLinDetCamposExtra

static oBtnKit
static oBtnAtp

static oBtnPre
static oBtnPed
static oBtnAgruparPedido
static oBtnPrecio

static oRieCli
static nRieCli

static oTlfCli
static cTlfCli

static aNumPed          := {}
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
static cOldLotArt       := ""
static dOldFecCad       := cToD( "" )
static cOldUndMed       := ""
static lOpenFiles       := .f.
static lExternal        := .f.
static aTipAlb          := { "Venta", "Alquiler" }
static oTipAlb
static cFiltroUsuario   := ""
static oTotAlbLin
static oImpuestos
static lImpuestos       := .f.

static oBrwLin
static oBrwInc
static oBrwDoc

static aPedidos         := {}

static oTipoCtrCoste
static cTipoCtrCoste
static aTipoCtrCoste       := { "Centro de coste", "Proveedor", "Agente", "Cliente" }

static bEdtRec          := { | aTmp, aGet, dbf, oBrw, bWhen, bValid, nMode, hHash | EdtRec( aTmp, aGet, dbf, oBrw, bWhen, bValid, nMode, hHash ) }
static bEdtDet          := { | aTmp, aGet, dbf, oBrw, bWhen, bValid, nMode, aTmpAlb | EdtDet( aTmp, aGet, dbf, oBrw, bWhen, bValid, nMode, aTmpAlb ) }
static bEdtInc          := { | aTmp, aGet, dbf, oBrw, bWhen, bValid, nMode, aTmpLin | EdtInc( aTmp, aGet, dbf, oBrw, bWhen, bValid, nMode, aTmpLin ) }
static bEdtDoc          := { | aTmp, aGet, dbf, oBrw, bWhen, bValid, nMode, aTmpLin | EdtDoc( aTmp, aGet, dbf, oBrw, bWhen, bValid, nMode, aTmpLin ) }
static bEdtPgo          := { | aTmp, aGet, dbf, oBrw, bWhen, bValid, nMode, aTmpAlb | EdtEnt( aTmp, aGet, dbf, oBrw, bWhen, bValid, nMode, aTmpAlb ) }
static bEdtEst          := { | aTmp, aGet, dbf, oBrw, bWhen, bValid, nMode, aTmpAlb | EdtEst( aTmp, aGet, dbf, oBrw, bWhen, bValid, nMode, aTmpAlb ) }

static oMailing

static oBrwProperties

static oTransportistaSelector

//--------------------------------------------------------------------------//

FUNCTION AlbCli( oMenuItem, oWnd, hHash )

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
   local oScript
   local lEuro          := .f.

   DEFAULT  oMenuItem   := _MENUITEM_
   DEFAULT  oWnd        := oWnd()

   nLevel               := Auth():Level( oMenuItem )
   if nAnd( nLevel, 1 ) == 0
      msgStop( "Acceso no permitido." )
      return .f.
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
               "Código postal",;
               "Población",;
               "Provincia",;
               "Dirección",;
               "Agente",;
               "Su albarán",;
               "Total";
      MRU      "gc_document_empty_16";
      BITMAP   clrTopArchivos ;
      ALIAS    ( D():Get( "AlbCliT", nView ) );
      APPEND   ( WinAppRec( oWndBrw:oBrw, bEdtRec, D():Get( "AlbCliT", nView ), hHash ) );
      DUPLICAT ( WinDupRec( oWndBrw:oBrw, bEdtRec, D():Get( "AlbCliT", nView ), hHash ) );
      EDIT     ( WinEdtRec( oWndBrw:oBrw, bEdtRec, D():Get( "AlbCliT", nView ), hHash ) );
      ZOOM     ( WinZooRec( oWndBrw:oBrw, bEdtRec, D():Get( "AlbCliT", nView ) ) );
      DELETE   ( WinDelRec( oWndBrw:oBrw, D():Get( "AlbCliT", nView ), {|| QuiAlbCli() } ) ) ;
      LEVEL    nLevel ;
      OF       oWnd

      oWndBrw:lFechado     := .t.

      oWndBrw:SetYearComboBoxChange( {|| YearComboBoxChange() } )

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Sesión cerrada"
         :nHeadBmpNo       := 3
         :bStrData         := {|| "" }
         :bEditValue       := {|| ( D():Get( "AlbCliT", nView ) )->lCloAlb }
         :nWidth           := 20
         :SetCheck( { "gc_lock2_12", "Nil16" } )
         :AddResource( "gc_lock2_16" )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Facturado"
         :nHeadBmpNo       := 4
         :bStrData         := {|| aTextoEstadoFacturado[ max( 1, ( D():Get( "AlbCliT", nView ) )->nFacturado ) ] }
         :bBmpData         := {|| ( D():Get( "AlbCliT", nView ) )->nFacturado }
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
         :bEditValue       := {|| ( D():Get( "AlbCliT", nView ) )->lSndDoc }
         :nWidth           := 20
         :SetCheck( { "gc_mail2_12", "Nil16" } )
         :AddResource( "gc_mail2_16" )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := getConfigTraslation( "Entregado" )
         :nHeadBmpNo       := 3
         :bStrData         := {|| if( ( D():Get( "AlbCliT", nView ) )->lEntregado, getConfigTraslation( "Entregado" ), "" ) }
         :bEditValue       := {|| if( ( D():Get( "AlbCliT", nView ) )->lEntregado, 1, 2 ) }
         :nWidth           := 20
         :nDataStrAlign    := 3
         :nHeadStrAlign    := 3
         :AddResource( "Sel16" )
         :AddResource( "Nil16" )
         :AddResource( "gc_hand_paper_16" )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Incidencia"
         :nHeadBmpNo       := 4
         :bStrData         := {|| "" }
         :bBmpData         := {|| nEstadoIncidencia( ( D():Get( "AlbCliT", nView ) )->cSerAlb + Str( ( D():Get( "AlbCliT", nView ) )->nNumAlb ) + ( D():Get( "AlbCliT", nView ) )->cSufAlb ) }
         :nWidth           := 20
         :lHide            := .t.
         :AddResource( "gc_delete_12" )
         :AddResource( "gc_shape_square_12" )
         :AddResource( "gc_check_12" )
         :AddResource( "gc_document_information_16" )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Impreso"
         :nHeadBmpNo       := 3
         :bStrData         := {|| "" }
         :bEditValue       := {|| ( D():Get( "AlbCliT", nView ) )->lImprimido }
         :nWidth           := 20
         :lHide            := .t.
         :SetCheck( { "Sel16", "Nil16" } )
         :AddResource( "gc_printer2_16" )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Tipo"
         :bEditValue       := {|| aTipAlb[ if( ( D():Get( "AlbCliT", nView ) )->lAlquiler, 2, 1 ) ] }
         :nWidth           := 50
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Número"
         :cSortOrder       := "nNumAlb"
         :bEditValue       := {|| ( D():Get( "AlbCliT", nView ) )->cSerAlb + "/" + Alltrim( Str( ( D():Get( "AlbCliT", nView ) )->nNumAlb ) ) }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Delegación"
         :bEditValue       := {|| ( D():Get( "AlbCliT", nView ) )->cSufAlb }
         :nWidth           := 40
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Sesión"
         :bEditValue       := {|| Trans( ( D():Get( "AlbCliT", nView ) )->cTurAlb, "######" ) }
         :nWidth           := 40
         :lHide            := .t.
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      with object ( oWndBrw:AddXCol() )   
         :cHeader          := "Fecha"
         :cSortOrder       := "dDesFec"
         :bEditValue       := {|| Dtoc( ( D():Get( "AlbCliT", nView ) )->dFecAlb ) }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )   
         :cHeader          := "Hora"
         :cSortOrder       := "tFecAlb"
         :bEditValue       := {|| Trans( ( D():Get( "AlbCliT", nView ) )->tFecAlb, "@R 99:99:99" ) }
         :nWidth           := 60
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Caja"
         :bEditValue       := {|| ( D():Get( "AlbCliT", nView ) )->cCodCaj }
         :nWidth           := 40
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Usuario"
         :bEditValue       := {|| ( D():Get( "AlbCliT", nView ) )->cCodUsr }
         :nWidth           := 40
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Código"
         :cSortOrder       := "cCodCli"
         :bEditValue       := {|| AllTrim( ( D():Get( "AlbCliT", nView ) )->cCodCli ) }
         :nWidth           := 70
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Nombre"
         :cSortOrder       := "cNomCli"
         :bEditValue       := {|| ( D():Get( "AlbCliT", nView ) )->cNomCli }
         :nWidth           := 180
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Su albarán"
         :cSortOrder       := "cCodSuAlb"
         :bEditValue       := {|| ( D():Get( "AlbCliT", nView ) )->cCodSuAlb }
         :nWidth           := 40
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Código postal"
         :cSortOrder       := "CodPostal"
         :bEditValue       := {|| alltrim( ( D():Get( "AlbCliT", nView ) )->cPosCli ) }
         :nWidth           := 60
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Población"
         :cSortOrder       := "Poblacion"
         :bEditValue       := {|| alltrim( ( D():Get( "AlbCliT", nView ) )->cPobCli ) }
         :nWidth           := 180
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Provincia"
         :cSortOrder       := "Provincia"
         :bEditValue       := {|| alltrim( ( D():Get( "AlbCliT", nView ) )->cPrvCli ) }
         :nWidth           := 100
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Agente"
         :cSortOrder       := "cCodAge"
         :bEditValue       := {|| ( D():Get( "AlbCliT", nView ) )->cCodAge }
         :nWidth           := 50
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Ruta"
         :bEditValue       := {|| ( D():Get( "AlbCliT", nView ) )->cCodRut }
         :nWidth           := 40
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Almacén"
         :bEditValue       := {|| ( D():Get( "AlbCliT", nView ) )->cCodAlm }
         :nWidth           := 60
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Dirección"
         :cSortOrder       := "cObra"
         :bEditValue       := {|| ( D():Get( "AlbCliT", nView ) )->cCodObr }
         :nWidth           := 40
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Su pedido"
         :cSortOrder       := "cSuPed"
         :bEditValue       := {|| ( D():Get( "AlbCliT", nView ) )->cSuPed }
         :nWidth           := 60
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Facturado"
         :cSortOrder       := "cNumFac"
         :bEditValue       := {|| ( D():Get( "AlbCliT", nView ) )->cNumFac }
         :nWidth           := 60
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Base"
         :bEditValue       := {|| ( D():Get( "AlbCliT", nView ) )->nTotNet }
         :cEditPicture     := cPorDiv()
         :nWidth           := 80
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := cImp()
         :bEditValue       := {|| ( D():Get( "AlbCliT", nView ) )->nTotIva }
         :cEditPicture     := cPorDiv()
         :nWidth           := 80
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "R.E."
         :bEditValue       := {|| ( D():Get( "AlbCliT", nView ) )->nTotReq }
         :cEditPicture     := cPorDiv()
         :nWidth           := 80
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Total"
         :bEditValue       := {|| ( D():Get( "AlbCliT", nView ) )->nTotAlb }
         :cEditPicture     := cPorDiv()
         :nWidth           := 80
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
         :cSortOrder       := "nTotAlb"
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Div."
         :bEditValue       := {|| cSimDiv( if( lEuro, cDivChg(), ( D():Get( "AlbCliT", nView ) )->cDivAlb ), D():Get( "Divisas", nView ) ) }
         :nWidth           := 30
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with


      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Entregado"
         :bEditValue       := {|| ( D():Get( "AlbCliT", nView ) )->nTotPag }
         :cEditPicture     := cPorDiv()
         :nWidth           := 80
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Total und."
         :bEditValue       := {|| nTotalUnd( ( D():Get( "AlbCliT", nView ) )->cSerAlb + Str( ( D():Get( "AlbCliT", nView ) )->nNumAlb ) + ( D():Get( "AlbCliT", nView ) )->cSufAlb, MasUnd() ) }
         :nWidth           := 95
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Total peso"
         :bEditValue       := {|| nTotalPesoAlbaranCliente( D():AlbaranesClientesId( nView ), nView, MasUnd() ) }
         :nWidth           := 95
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Bultos"
         :bEditValue       := {|| ( D():Get( "AlbCliT", nView ) )->nBultos }
         :cEditPicture     := "99999"
         :nWidth           := 95
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
         :lHide            := .t.
         :nEditType        := 1
         :bOnPostEdit      := {|oCol, uNewValue, nKey| ChangeBultos( oCol, uNewValue, nKey ) }
      end with

      /*with object ( oWndBrw:AddXCol() )
         :cHeader          := "Transportista"
         :bEditValue       := {|| ( D():Get( "AlbCliT", nView ) )->cCodTrn }
         :nWidth           := 60
         :lHide            := .t.
         :nEditType        := 5
         :bOnPostEdit      := {|oCol, uNewValue, nKey| ChangeTrasportista( oCol, uNewValue, nKey ) }
         :bEditBlock       := {|| oTrans:Buscar( ( D():Get( "AlbCliT", nView ) )->cCodTrn ) }
         :nBtnBmp          := 1
         :AddResource( "Lupa" )
      end with*/

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Nombre transportista"
         :bEditValue       := {|| SQLTransportistasModel():getNombreWhereCodigo( ( D():Get( "AlbCliT", nView ) )->cCodTrn ) }
         :nWidth           := 180
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Centro de coste"
         :bEditValue       := {|| ( D():Get( "AlbCliT", nView ) )->cCtrCoste }
         :nWidth           := 30
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Creación/Modificación"
         :bEditValue       := {|| dtoc( ( D():Get( "AlbCliT", nView ) )->dFecCre ) + space( 1 ) + ( D():Get( "AlbCliT", nView ) )->cTimCre }
         :nWidth           := 120
         :lHide            := .t.
      end with

   oDetCamposExtra:addCamposExtra( oWndBrw )

   oWndBrw:cHtmlHelp    := "Albaranes a clientes"

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
      ACTION   ( WinDelRec( oWndBrw:oBrw, D():Get( "AlbCliT", nView ), {|| QuiAlbCli() } ) );
      TOOLTIP  "(E)liminar";
      HOTKEY   "E";
      LEVEL    ACC_DELE

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
      ACTION   ( selectedGenAlbCli( IS_PRINTER ), oWndBrw:Refresh() ) ;
      TOOLTIP  "(I)mprimir";
      HOTKEY   "I";
      LEVEL    ACC_IMPR

      lGenAlbCli( oWndBrw:oBrw, oImp, IS_PRINTER ) ;

   DEFINE BTNSHELL RESOURCE "GC_PRINTER2_" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( ImprimirSeriesAlbaranes() ) ;
      TOOLTIP  "Imp(r)imir series";
      HOTKEY   "R";
      LEVEL    ACC_IMPR

   DEFINE BTNSHELL oPrv RESOURCE "Prev1" OF oWndBrw ;
      NOBORDER ;
      MENU     This:Toggle() ;
      ACTION   ( selectedGenAlbCli( IS_SCREEN ), oWndBrw:Refresh() ) ;
      TOOLTIP  "(P)revisualizar";
      HOTKEY   "P";
      LEVEL    ACC_IMPR

      lGenAlbCli( oWndBrw:oBrw, oPrv, IS_SCREEN ) ;

   DEFINE BTNSHELL oPdf RESOURCE "DOCLOCK" OF oWndBrw ;
      NOBORDER ;
      MENU     This:Toggle() ;
      ACTION   ( selectedGenAlbCli( IS_PDF ) ) ;
      TOOLTIP  "Pd(f)";
      HOTKEY   "F";
      LEVEL    ACC_IMPR

      lGenAlbCli( oWndBrw:oBrw, oPdf, IS_PDF ) ;

   DEFINE BTNSHELL oMail RESOURCE "GC_MAIL_EARTH_" OF oWndBrw ;
      NOBORDER ;
      MENU     This:Toggle() ;
      ACTION   ( oMailing:documentsDialog( oWndBrw:oBrw:aSelected ) ) ;
      TOOLTIP  "Correo electrónico";
      LEVEL    ACC_IMPR

   DEFINE BTNSHELL RESOURCE "gc_portable_barcode_scanner_" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( TLabelGeneratorAlbaranClientes():New( nView ):Dialog() ) ;
      TOOLTIP  "Eti(q)uetas" ;
      HOTKEY   "Q";
      LEVEL    ACC_IMPR

   DEFINE BTNSHELL RESOURCE "gc_document_empty_chart_" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( if( validRunReport( "01118" ), TFastVentasArticulos():New():Play( ALB_CLI ), ) ) ;
      TOOLTIP  "Rep(o)rting";
      HOTKEY   "O" ;
      LEVEL    ACC_IMPR

   DEFINE BTNSHELL RESOURCE "gc_money2_" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( If( !lFacturado( D():Get( "AlbCliT", nView ) ), WinAppRec( oWndBrw:oBrw, bEdtPgo, D():Get( "AlbCliP", nView ) ), MsgStop( "El albarán ya fue facturado." ) ) );
      TOOLTIP  "Entregas a (c)uenta" ;
      HOTKEY   "C";
      LEVEL    ACC_APPD

   if SQLAjustableModel():getRolAsistenteGenerarFacturas( Auth():rolUuid() )

      DEFINE BTNSHELL RESOURCE "gc_gearwheel_" GROUP OF oWndBrw ;
         NOBORDER ;
         ACTION   ( GeneraFacturasClientes():New() );
         TOOLTIP  "(G)enerar facturas";
         HOTKEY   "G";
         LEVEL    ACC_APPD

      DEFINE BTNSHELL RESOURCE "gc_gearwheel_" GROUP OF oWndBrw ;
         NOBORDER ;
         ACTION   ( TGeneracionAlbaranesClientes():New( nView, oStock ):Dialog() );
         TOOLTIP  "Importar pedidos clientes";
         LEVEL    ACC_APPD

   end if

   if SQLAjustableModel():getRolCambiarEstado( Auth():rolUuid() )

      DEFINE BTNSHELL RESOURCE "CHGSTATE" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( if( ApoloMsgNoYes( "¿ Está seguro de cambiar el estado del documento ?", "Elija una opción" ), SetFacturadoAlbaranCliente( !lFacturado( D():Get( "AlbCliT", nView ) ), oWndBrw:oBrw ), ) ) ;
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
      ACTION   lSnd( oWndBrw, D():Get( "AlbCliT", nView ) ) ;
      HOTKEY   "V";
      LEVEL    ACC_EDIT

      DEFINE BTNSHELL RESOURCE "LBL" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( lSelectAll( oWndBrw, D():Get( "AlbCliT", nView ), "lSndDoc", .t., .t., .t. ) );
         TOOLTIP  "Todos" ;
         FROM     oSnd ;
         CLOSED ;
         LEVEL    ACC_EDIT

      DEFINE BTNSHELL RESOURCE "LBL" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( lSelectAll( oWndBrw, D():Get( "AlbCliT", nView ), "lSndDoc", .f., .t., .t. ) );
         TOOLTIP  "Ninguno" ;
         FROM     oSnd ;
         CLOSED ;
         LEVEL    ACC_EDIT

      DEFINE BTNSHELL RESOURCE "LBL" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( lSelectAll( oWndBrw, D():Get( "AlbCliT", nView ), "lSndDoc", .t., .f., .t. ) );
         TOOLTIP  "Abajo" ;
         FROM     oSnd ;
         CLOSED ;
         LEVEL    ACC_EDIT

   DEFINE BTNSHELL oBtnEur RESOURCE "gc_currency_euro_" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( lEuro := !lEuro, oWndBrw:Refresh() ) ;
      TOOLTIP  "M(o)neda";
      HOTKEY   "O"

   if SQLAjustableModel():getRolCambiarCampos( Auth():rolUuid() )

      DEFINE BTNSHELL oRpl RESOURCE "BMPCHG" GROUP OF oWndBrw ;
         NOBORDER ;
         MENU     This:Toggle() ;
         ACTION   ( ReplaceCreator( oWndBrw, D():Get( "AlbCliT", nView ), aItmAlbCli(), ALB_CLI ) ) ;
         TOOLTIP  "Cambiar campos" ;
         LEVEL    ACC_EDIT

         DEFINE BTNSHELL RESOURCE "BMPCHG" OF oWndBrw ;
            ACTION   ( ReplaceCreator( oWndBrw, D():Get( "AlbCliL", nView ), aColAlbCli() ) ) ;
            TOOLTIP  "Líneas" ;
            FROM     oRpl ;
            CLOSED ;
            LEVEL    ACC_EDIT

    end if

   DEFINE BTNSHELL RESOURCE "INFO" GROUP OF oWndBrw ;
      ACTION   ( TTrazaDocumento():Activate( ALB_CLI, ( D():Get( "AlbCliT", nView ) )->cSerAlb + Str( ( D():Get( "AlbCliT", nView ) )->nNumAlb ) + ( D():Get( "AlbCliT", nView ) )->cSufAlb ) ) ;
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

      ImportScript( oWndBrw, oScript, "AlbaranesClientes", nView, oPais )  

   DEFINE BTNSHELL oRotor RESOURCE "ROTOR" GROUP OF oWndBrw ;
      NOBORDER ;
      ACTION   ( oRotor:Expand() ) ;
      TOOLTIP  "Rotor" ;

      DEFINE BTNSHELL RESOURCE "GC_USER_" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( EdtCli( ( D():Get( "AlbCliT", nView ) )->cCodCli ) );
         TOOLTIP  "Modificar cliente" ;
         FROM     oRotor ;

      DEFINE BTNSHELL RESOURCE "INFO" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( InfCliente( ( D():Get( "AlbCliT", nView ) )->cCodCli ) );
         TOOLTIP  "Informe de cliente" ;
         FROM     oRotor ;

      DEFINE BTNSHELL RESOURCE "GC_CLIPBOARD_EMPTY_USER_" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( EdtObras( ( D():Get( "AlbCliT", nView ) )->cCodCli, ( D():Get( "AlbCliT", nView ) )->cCodObr, dbfObrasT ) );
         TOOLTIP  "Modificar dirección" ;
         FROM     oRotor ;

      DEFINE BTNSHELL RESOURCE "GC_CLIPBOARD_EMPTY_USER_" OF oWndBrw ;
         ACTION   ( if( !empty( ( D():Get( "AlbCliT", nView ) )->cNumPed ), ZooPedCli( ( D():Get( "AlbCliT", nView ) )->cNumPed ), MsgStop( "El albarán no procede de un pedido" ) ) );
         TOOLTIP  "Visualizar pedido" ;
         FROM     oRotor ;

      DEFINE BTNSHELL RESOURCE "GC_DOCUMENT_TEXT_USER_" OF oWndBrw ;
         ALLOW    EXIT ;
         ACTION   ( if( !lFacturado( D():Get( "AlbCliT", nView ) ), FactCli( nil, nil, { "Albaran" => ( D():Get( "AlbCliT", nView ) )->cSerAlb + Str( ( D():Get( "AlbCliT", nView ) )->nNumAlb ) + ( D():Get( "AlbCliT", nView ) )->cSufAlb } ), MsgStop( "Albarán facturado" ) ) );
         TOOLTIP  "Generar factura" ;
         FROM     oRotor ;

      DEFINE BTNSHELL RESOURCE "GC_DOCUMENT_TEXT_USER_" OF oWndBrw ;
         ACTION   ( if( !empty( ( D():Get( "AlbCliT", nView ) )->cNumFac ), EdtFacCli( ( D():Get( "AlbCliT", nView ) )->cNumFac ), msgStop( "No hay factura asociada" ) ) );
         TOOLTIP  "Modificar factura" ;
         FROM     oRotor ;

      DEFINE BTNSHELL RESOURCE "GC_DOCUMENT_TEXT_MONEY2_" OF oWndBrw ;
         ALLOW    EXIT ;
         ACTION   ( if( !lFacturado( D():Get( "AlbCliT", nView ) ), FacAntCli( nil, nil, ( D():Get( "AlbCliT", nView ) )->cCodCli ), msgStop( "Albarán ya facturado" ) ) );
         TOOLTIP  "Generar anticipo" ;
         FROM     oRotor ;

      DEFINE BTNSHELL RESOURCE "GC_NOTE_" OF oWndBrw ;
         ALLOW    EXIT ;
         ACTION   ( AlbCliNotas() );
         TOOLTIP  "Generar nota de agenda" ;
         FROM     oRotor ;

      DEFINE BTNSHELL RESOURCE "GC_CASH_REGISTER_USER_" OF oWndBrw ;
         ALLOW    EXIT ;
         ACTION   ( if( !lFacturado( D():Get( "AlbCliT", nView ) ) .and. empty( ( D():Get( "AlbCliT", nView ) )->cNumTik ),;
                        generateTicketFromDocument( { "Albaran" => D():AlbaranesClientesId( nView ) } ),;
                        msgStop( "Albarán facturado o convertido a ticket" ) ) );
         TOOLTIP  "Convertir a ticket" ;
         FROM     oRotor ;

      DEFINE BTNSHELL RESOURCE "GC_CASH_REGISTER_USER_" OF oWndBrw ;
         ALLOW    EXIT ;
         ACTION   ( FacturarLineas() );
         TOOLTIP  "Facturar lineas" ;
         FROM     oRotor ;

   DEFINE BTNSHELL RESOURCE "END" GROUP OF oWndBrw;
      NOBORDER ;
      ACTION   ( oWndBrw:End() ) ;
      TOOLTIP  "(S)alir" ;
      HOTKEY   "S"

      /*
      Datos para el filtro-----------------------------------------------------
      */

   if .t. // SQLAjustableModel():getRolNoFiltrarVentas( Auth():rolUuid() )
      oWndBrw:oActiveFilter:SetFields( aItmAlbCli() )
      oWndBrw:oActiveFilter:SetFilterType( ALB_CLI )
   end if

   ACTIVATE WINDOW oWndBrw VALID ( CloseFiles() )

   EnableAcceso()

   if !empty( oWndBrw )

      if uFieldempresa( 'lFltYea' )
         oWndBrw:setYearCombobox()
      end if

      if !empty( hHash ) 
         oWndBrw:recAdd()
      end if

      hHash    := nil

   end if

Return .t.

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

      lOpenFiles        := .t.

      nView             := D():CreateView()

      D():GetObject( "UnidadMedicion", nView )

      /*
      Tablas de albaranes de clientes------------------------------------------
      */

      D():Get( "AlbCliT", nView )

      D():Get( "AlbCliL", nView )

      D():Get( "AlbCliI", nView )

      D():Get( "AlbCliD", nView )

      D():Get( "AlbCliP", nView )

      D():Get( "AlbCliS", nView )

      /*
      Tablas de albaranes de clientes------------------------------------------
      */

      D():Get( "FacCliT", nView )

      D():Get( "FacCliL", nView )

      D():Get( "FacCliP", nView )

      D():Get( "FacCliS", nView )

      D():Get( "AntCliT", nView )

      D():Get( "CliInc", nView )

      /*
      Contadores---------------------------------------------------------------
      */

      D():Get( "NCount", nView )

      /*
      Formas de Pago-----------------------------------------------------------
      */

      D():Get( "FPago", nView )

      /*
      Clientes-----------------------------------------------------------------
      */

      D():Get( "Client", nView )

      /*
      Divisas------------------------------------------------------------------
      */

      D():Get( "Divisas", nView )

      /*
      IVA----------------------------------------------------------------------
      */

      D():Get( "TIva", nView )

      /*
      DOCUMENTOS ABIERTOS POR TIPO---------------------------------------------
      */

      D():Documentos( nView )
      ( D():Documentos( nView ) )->( OrdSetFocus( "cTipo" ) )

      // DV con objetos-------------------------------------------------

      D():objectGruposClientes( nView )

      /*
      Proveedores--------------------------------------------------------------
      */

      D():Get( "Provee", nView )  

      /*
      Atipicas de clientes-----------------------------------------------------
      */

      D():Atipicas( nView )

      D():Articulos( nView )       

      D():ArticuloStockAlmacenes( nView )  

      D():ArticuloLenguaje( nView )  

      D():AlbaranesClientesSituaciones( nView )  

      D():ImpuestosEspeciales( nView )

      D():Familias( nView )

      D():SatClientes( nView )

      D():SatClientesLineas( nView )

      // Aperturas ------------------------------------------------------------

      if !TDataCenter():OpenPreCliT( @dbfPreCliT )
         lOpenFiles     := .f.
      end if 

      USE ( cPatEmp() + "PreCliL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PreCliT", @dbfPreCliL ) )
      SET ADSINDEX TO ( cPatEmp() + "PreCliL.CDX" ) ADDITIVE

      USE ( cPatEmp() + "PreCliI.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PreCliI", @dbfPreCliI ) )
      SET ADSINDEX TO ( cPatEmp() + "PreCliI.CDX" ) ADDITIVE

      USE ( cPatEmp() + "PreCliD.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PreCliD", @dbfPreCliD ) )
      SET ADSINDEX TO ( cPatEmp() + "PreCliD.CDX" ) ADDITIVE

      USE ( cPatEmp() + "AlbCliL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "AlbCliL", @dbfAlbCliL ) )
      SET ADSINDEX TO ( cPatEmp() + "AlbCliL.CDX" ) ADDITIVE

      USE ( cPatEmp() + "AlbCliI.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "AlbCliI", @dbfAlbCliI ) )
      SET ADSINDEX TO ( cPatEmp() + "AlbCliI.CDX" ) ADDITIVE

      USE ( cPatEmp() + "AlbCliD.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "AlbCliD", @dbfAlbCliD ) )
      SET ADSINDEX TO ( cPatEmp() + "AlbCliD.CDX" ) ADDITIVE

      USE ( cPatEmp() + "AlbCliS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "AlbCliS", @dbfAlbCliS ) )
      SET ADSINDEX TO ( cPatEmp() + "AlbCliS.CDX" ) ADDITIVE

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

      USE ( cPatEmp() + "CliBnc.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CLIBNC", @dbfCliBnc ) )
      SET ADSINDEX TO ( cPatEmp() + "CliBnc.Cdx" ) ADDITIVE

      USE ( cPatEmp() + "PROVART.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PROVART", @dbfArtPrv ) )
      SET ADSINDEX TO ( cPatEmp() + "PROVART.CDX" ) ADDITIVE

      USE ( cPatEmp() + "AGENTES.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "AGENTES", @dbfAgent ) )
      SET ADSINDEX TO ( cPatEmp() + "AGENTES.CDX" ) ADDITIVE

      USE ( cPatEmp() + "TarPreL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TarPreL", @dbfTarPreL ) )
      SET ADSINDEX TO ( cPatEmp() + "TarPreL.CDX" ) ADDITIVE

      USE ( cPatEmp() + "TarPreS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TarPreS", @dbfTarPreS ) )
      SET ADSINDEX TO ( cPatEmp() + "TarPreS.CDX" ) ADDITIVE

      USE ( cPatEmp() + "PROMOT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PROMOT", @dbfPromoT ) )
      SET ADSINDEX TO ( cPatEmp() + "PROMOT.CDX" ) ADDITIVE

      USE ( cPatEmp() + "PROMOL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PROMOL", @dbfPromoL ) )
      SET ADSINDEX TO ( cPatEmp() + "PROMOL.CDX" ) ADDITIVE

      USE ( cPatEmp() + "PROMOC.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PROMOC", @dbfPromoC ) )
      SET ADSINDEX TO ( cPatEmp() + "PROMOC.CDX" ) ADDITIVE

      USE ( cPatEmp() + "ArtCodebar.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CODEBAR", @dbfCodebar ) )
      SET ADSINDEX TO ( cPatEmp() + "ArtCodebar.Cdx" ) ADDITIVE

      USE ( cPatEmp() + "ARTKIT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ARTTIK", @dbfKit ) )
      SET ADSINDEX TO ( cPatEmp() + "ARTKIT.CDX" ) ADDITIVE

      USE ( cPatEmp() + "OFERTA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "OFERTA", @dbfOferta ) )
      SET ADSINDEX TO ( cPatEmp() + "OFERTA.CDX" ) ADDITIVE

      USE ( cPatEmp() + "ObrasT.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "OBRAST", @dbfObrasT ) )
      SET ADSINDEX TO ( cPatEmp() + "ObrasT.Cdx" ) ADDITIVE

      USE ( cPatEmp() + "PRO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PRO", @dbfPro ) )
      SET ADSINDEX TO ( cPatEmp() + "PRO.CDX" ) ADDITIVE

      USE ( cPatEmp() + "TBLPRO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TBLPRO", @dbfTblPro ) )
      SET ADSINDEX TO ( cPatEmp() + "TBLPRO.CDX" ) ADDITIVE

      USE ( cPatEmp() + "RUTA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "RUTA", @dbfRuta ) )
      SET ADSINDEX TO ( cPatEmp() + "RUTA.CDX" ) ADDITIVE

      USE ( cPatEmp() + "ARTDIV.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ARTDIV", @dbfArtDiv ) )
      SET ADSINDEX TO ( cPatEmp() + "ARTDIV.CDX" ) ADDITIVE

      USE ( cPatDat() + "Cajas.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CAJAS", @dbfCajT ) )
      SET ADSINDEX TO ( cPatDat() + "Cajas.Cdx" ) ADDITIVE

      USE ( cPatEmp() + "Almacen.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALMACEN", @dbfAlm ) )
      SET ADSINDEX TO ( cPatEmp() + "Almacen.Cdx" ) ADDITIVE

      USE ( cPatDat() + "DELEGA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "DELEGA", @dbfDelega ) )
      SET ADSINDEX TO ( cPatDat() + "DELEGA.CDX" ) ADDITIVE
      
      USE ( cPatEmp() + "AGECOM.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "AGECOM", @dbfAgeCom ) )
      SET ADSINDEX TO ( cPatEmp() + "AGECOM.CDX" ) ADDITIVE

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

      USE ( cPatEmp() + "PEDPROVL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PedPrvL", @dbfPedPrvL ) )
      SET ADSINDEX TO ( cPatEmp() + "PEDPROVL.CDX" ) ADDITIVE
      SET TAG TO "cRef"

      USE ( cPatEmp() + "PROSER.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PROSER", @dbfProSer ) )
      SET ADSINDEX TO ( cPatEmp() + "PROSER.CDX" ) ADDITIVE

      USE ( cPatEmp() + "MATSER.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "MATSER", @dbfMatSer ) )
      SET ADSINDEX TO ( cPatEmp() + "MATSER.CDX" ) ADDITIVE

      if !TDataCenter():OpenAlbCliT( @dbfAlbCliT )
         lOpenFiles        := .f.
      end if

      if !TDataCenter():OpenPedCliT( @dbfPedCliT )
         lOpenFiles     := .f.
      end if 

      oBandera          := TBandera():New()

      oStock               := TStock():Create( cPatEmp() )
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

      oGrpFam           := TGrpFam():Create( cPatEmp() )
      if !oGrpFam:OpenFiles()
         lOpenFiles     := .f.
      end if

      oUndMedicion      := UniMedicion():Create( cPatEmp() )
      if !oUndMedicion:OpenFiles()
         lOpenFiles     := .f.
      end if

      oCentroCoste      := TCentroCoste():Create( cPatDat() )
      if !oCentroCoste:OpenFiles()
         lOpenFiles     := .f.
      end if

      oFraPub           := TFrasesPublicitarias():Create( cPatEmp() )
      if !oFraPub:OpenFiles()
         lOpenFiles     := .f.
      end if

      oPais             := TPais():Create( cPatDat() )
      if !oPais:OpenFiles()
         lOpenFiles     := .f.
      end if

      oMailing          := TGenmailingDatabaseAlbaranesClientes():New( nView )

      TComercio         := TComercio():New( nView, oStock )

      Counter                    := TCounter():New( nView, "nAlbCli" ) 

      oTransportistaSelector     := TransportistasController():New():oGetSelector
      oTransportistaSelector:setKey( "codigo" )

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

      public aTotIva    := { { 0,0,nil,0,0,0,0,0,0,0,0 }, { 0,0,nil,0,0,0,0,0,0,0,0 }, { 0,0,nil,0,0,0,0,0,0,0,0 } }
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

      if .f. // lAIS() 

         cFiltroUsuario    := "Field->cSufAlb == '" + Application():CodigoDelegacion() + "' .and. Field->cCodCaj == '" + Application():CodigoCaja() + "'"
         
         if SQLAjustableModel():getRolFiltrarVentas( Auth():rolUuid() )         
            cFiltroUsuario += " .and. Field->cCodUsr == '" + Auth():Codigo() + "'"
         end if 

         ( D():Get( "AlbCliT", nView ) )->( AdsSetAOF( cFiltroUsuario ) )

      end if

      /*
      Campos extras------------------------------------------------------------------------
      */

      oDetCamposExtra      := TDetCamposExtra():New()
      oDetCamposExtra:OpenFiles()
      oDetCamposExtra:SetTipoDocumento( "Albaranes a clientes" )
      oDetCamposExtra:setbId( {|| D():AlbaranesClientesId( nView ) } )

      oLinDetCamposExtra   := TDetCamposExtra():New()
      oLinDetCamposExtra:OpenFiles()
      oLinDetCamposExtra:setTipoDocumento( "Lineas de albaranes a clientes" )
      oLinDetCamposExtra:setbId( {|| D():AlbaranesClientesLineasEscandalloId( nView ) } )

   RECOVER USING oError

      lOpenFiles           := .f.

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

   DestroyFastFilter( D():Get( "AlbCliT", nView ), .t., .t. )

   if !empty( dbfTikT )
      ( dbfTikT      )->( dbCloseArea() )
   end if
   if !empty( dbfPreCliT )
      ( dbfPreCliT )->( dbCloseArea() )
   end if
   if !empty( dbfPreCliL )
      ( dbfPreCliL )->( dbCloseArea() )
   end if
   if !empty( dbfPreCliI )
      ( dbfPreCliI )->( dbCloseArea() )
   end if
   if !empty( dbfPreCliD )
      ( dbfPreCliD )->( dbCloseArea() )
   end if
   if !empty( dbfAlbCliT )
      ( dbfAlbCliT )->( dbCloseArea() )
   end if
   if !empty( dbfAlbCliL )
      ( dbfAlbCliL )->( dbCloseArea() )
   end if
   if !empty( dbfAlbCliI )
      ( dbfAlbCliI )->( dbCloseArea() )
   end if
   if !empty( dbfAlbCliD )
      ( dbfAlbCliD )->( dbCloseArea() )
   end if

   if !empty( dbfAlbCliS )
      ( dbfAlbCliS )->( dbCloseArea() )
   end if

   if !empty( dbfPedCliT )
      ( dbfPedCliT   )->( dbCloseArea() )
   end if

   if !empty( dbfPedCliL )
      ( dbfPedCliL   )->( dbCloseArea() )
   end if
   if !empty( dbfPedCliR )
      ( dbfPedCliR   )->( dbCloseArea() )
   end if
   if !empty( dbfPedCliP )
      ( dbfPedCliP   )->( dbCloseArea() )
   end if
   if !empty( dbfPedCliI )
      ( dbfPedCliI   )->( dbCloseArea() )
   end if
   if !empty( dbfPedCliD )
      ( dbfPedCliD   )->( dbCloseArea() )
   end if
   if !empty( dbfAgent )
      ( dbfAgent     )->( dbCloseArea() )
   end if
   if !empty( dbfTarPreL )
      ( dbfTarPreL   )->( dbCloseArea() )
   end if
   if !empty( dbfTarPreS )
      ( dbfTarPreS   )->( dbCloseArea() )
   end if
   if !empty( dbfPromoT )
      ( dbfPromoT    )->( dbCloseArea() )
   end if
   if !empty( dbfPromoL )
      ( dbfPromoL    )->( dbCloseArea() )
   end if
   if !empty( dbfPromoC )
      ( dbfPromoC    )->( dbCloseArea() )
   end if
   if !empty( dbfCodebar )
      ( dbfCodebar   )->( dbCloseArea() )
   end if
   if !empty( dbfKit )
      ( dbfKit       )->( dbCloseArea() )
   end if
   if !empty( dbfAlm )
      ( dbfAlm       )->( dbCloseArea() )
   end if
   if !empty( dbfOferta )
      ( dbfOferta    )->( dbCloseArea() )
   end if
   if !empty( dbfObrasT )
      ( dbfObrasT    )->( dbCloseArea() )
   end if
   if !empty( dbfPro )
      ( dbfPro       )->( dbCloseArea() )
   end if
   if !empty( dbfTblPro )
      ( dbfTblPro    )->( dbCloseArea() )
   end if
   if !empty( dbfRuta )
      ( dbfRuta      )->( dbCloseArea() )
   end if
   if !empty( dbfArtDiv )
      ( dbfArtDiv    )->( dbCloseArea() )
   end if
   if !empty( dbfCajT )
      ( dbfCajT )->( dbCloseArea() )
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
   if dbfPedPrvL != nil
      ( dbfPedPrvL )->( dbCloseArea() )
   end if
   if !empty( dbfCliBnc  )
      ( dbfCliBnc  )->( dbCloseArea() )
   end if

   if !empty( oStock )
      oStock:end()
   end if

   if !empty( oNewImp )
      oNewImp:end()
   end if
   if !empty( oTipArt )
      oTipArt:end()
   end if
   if !empty( oGrpFam )
      oGrpFam:end()
   end if
   if !empty( oUndMedicion )
      oUndMedicion:end()
   end if
   if !empty( oFraPub )
      oFraPub:end()
   end if
   if !empty( oPais )
      oPais:End()
   end if
   if !empty( oCentroCoste )
      oCentroCoste:end()
   end if 

   if !empty( oDetCamposExtra )
      oDetCamposExtra:CloseFiles()
   end if

   if !empty( oLinDetCamposExtra )
      oLinDetCamposExtra:CloseFiles()
      oLinDetCamposExtra:End()
   end if

   if !empty(oMailing)
      oMailing:End()
   end if 

   TComercio:end()

   D():DeleteView( nView )

   dbfPedCliT     := nil
   dbfPedCliL     := nil
   dbfPedCliR     := nil
   dbfPedCliP     := nil
   dbfPedCliI     := nil
   dbfPedCliD     := nil
   dbfTikT        := nil
   dbfAgent       := nil
   dbfAlm         := nil
   dbfTarPreL     := nil
   dbfTarPreS     := nil
   dbfPromoT      := nil
   dbfPromoL      := nil
   dbfPromoC      := nil
   dbfCodebar     := nil
   dbfKit         := nil
   oBandera       := nil
   dbfOferta      := nil
   dbfObrasT      := nil
   dbfPro         := nil
   dbfTblPro      := nil
   dbfRuta        := nil
   dbfArtDiv      := nil
   dbfCajT        := nil
   dbfArtPrv      := nil
   dbfDelega      := nil
   dbfAgeCom      := nil
   dbfFacRecT     := nil
   dbfFacRecL     := nil
   dbfTikT        := nil
   dbfTikL        := nil
   dbfTikS        := nil
   dbfEmp         := nil
   dbfProLin      := nil
   dbfProMat      := nil
   dbfAlbPrvL     := nil
   dbfPedPrvL     := nil
   dbfCliBnc      := nil

   oStock         := nil
   oNewImp        := nil
   oTipArt        := nil
   oGrpFam        := nil
   oUndMedicion   := nil
   oCentroCoste   := nil
   oFraPub        := nil

   nView          := nil

   lOpenFiles     := .f.

   oWndBrw        := nil

   EnableAcceso()

Return .t.

//---------------------------------------------------------------------------//

STATIC FUNCTION selectedGenAlbCli( nDevice, cTitle, cCodigoDocumento )

   local nPos

   for each nPos in ( oWndBrw:oBrw:aSelected )

      ( D():AlbaranesClientes( nView ) )->( dbgoto( nPos ) )

      genAlbCli( nDevice, cTitle, cCodigoDocumento )

      SysRefresh()

   next

RETURN NIL

//--------------------------------------------------------------------------//

STATIC FUNCTION bGenAlbCli( nDevice, cTitle, cCodDoc )

   local bGen
   local nDev  := by( nDevice )
   local cTit  := by( cTitle  )
   local cCod  := by( cCodDoc )

   if nDev == IS_PRINTER
      bGen     := {|| selectedGenAlbCli( nDev, cTit, cCod ) }
   else
      bGen     := {|| selectedGenAlbCli( nDev, cTit, cCod ) }
   end if

RETURN ( bGen )

//---------------------------------------------------------------------------//

STATIC FUNCTION GenAlbCli( nDevice, cCaption, cCodigoDocumento, cPrinter, nCopies )

   local oDevice
   local cAlbaran
   local nOrdAnt

   if ( D():AlbaranesClientes( nView ) )->( lastrec() ) == 0
      return nil
   end if

   DEFAULT nDevice            := IS_PRINTER
   DEFAULT cCaption           := "Imprimiendo albaranes a clientes"
   DEFAULT cCodigoDocumento   := cFormatoAlbaranesClientes()
   DEFAULT cPrinter           := cPrinterAlbaran( Application():CodigoCaja(), dbfCajT )

   nOrdAnt                    := ( D():AlbaranesClientes( nView ) )->( OrdSetFocus() )

   // Existe-------------------------------------------------------------------

   if !lExisteDocumento( cCodigoDocumento, D():Documentos( nView ) )
      return nil
   end if

   // Numero de copias---------------------------------------------------------

   if empty( nCopies )
      nCopies           := retfld( ( D():AlbaranesClientes( nView ) )->cCodCli, D():Get( "Client", nView ), "CopiasF" ) 
   end if

   if nCopies == 0 
      nCopies           := nCopiasDocumento( ( D():Get( "AlbCliT", nView ) )->cSerAlb, "nAlbCli", D():Get( "NCount", nView ) )
   end if 

   if nCopies == 0
      nCopies           := 1
   end if  

   // Numero de albaran--------------------------------------------------------

   cAlbaran             := D():AlbaranesClientesId( nView )

   // Si el documento es de tipo visual----------------------------------------

   if lVisualDocumento( cCodigoDocumento, D():Documentos( nView ) )
      PrintReportAlbCli( nDevice, nCopies, cPrinter, cCodigoDocumento )
   else
      msgStop( "El formato ya no es soportado" )
   end if

   /*
   Funcion para marcar el documento como imprimido-----------------------------
   */

   lChgImpDoc( D():Get( "AlbCliT", nView ) )

   ( D():AlbaranesClientes( nView ) )->( OrdSetFocus( nOrdAnt ) )

Return nil

//---------------------------------------------------------------------------//

FUNCTION imprimeAlbaranCliente( cNumeroAlbaran, cFormatoDocumento )

   local nLevel         := Auth():Level( _MENUITEM_ )

   if nAnd( nLevel, 1 ) == 0 .or. nAnd( nLevel, ACC_IMPR ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if OpenFiles( .t. )

      if dbSeekInOrd( cNumeroAlbaran, "nNumAlb", D():Get( "AlbCliT", nView ) )

         nTotAlbCli()

         genAlbCli( IS_PRINTER, nil, cFormatoDocumento )

      else

         msgStop( "Número de albarán " + alltrim(  cNumeroAlbaran ) + " no encontrado" )

      end if

      CloseFiles()

   end if

Return .t.

//---------------------------------------------------------------------------//

Static Function AlbCliReportSkipper()

   ( D():Get( "AlbCliL", nView ) )->( dbSkip() )

   nTotPage              += nTotLAlbCli( D():Get( "AlbCliL", nView ) )

Return nil

//----------------------------------------------------------------------------//

STATIC FUNCTION EPage( oInf, cCodigoDocumento )

   private nPagina      := oInf:nPage
   private lEnd         := oInf:lFinish
   private nRow         := oInf:nRow

   PrintItems( cCodigoDocumento, oInf )

RETURN NIL

//--------------------------------------------------------------------------//

STATIC FUNCTION EdtRec( aTmp, aGet, dbf, oBrw, hHash, bValid, nMode )

   local oDlg
   local oFld
   local nOrd
   local cEstAlb
   local oSay        := Array( 11 )
   local cSay        := Array( 11 )
   local oSayLabels  := Array( 10 )
   local oBmpDiv
   local oBmpEmp
   local oBrwEst
   local oBrwPgo
   local lWhen       := if( oUser():lAdministrador(), nMode != ZOOM_MODE, if( nMode == EDIT_MODE, !aTmp[ _LCLOALB ], nMode != ZOOM_MODE ) )
   local oSayGetRnt
   local cTipAlb
   local oSayDias
   local oSayTxtDias
   local oBmpGeneral

   /*
   Este valor los guaradamos para detectar los posibles cambios----------------
   */

   cOldCodCli                 := aTmp[ _CCODCLI ]
   
   setOldPorcentajeAgente( aTmp[ _NPCTCOMAGE ] )

   do case
      case nMode == APPD_MODE

         if !lCurSesion()
            MsgStop( "No hay sesiones activas, imposible añadir documentos" )
            Return .f.
         end if

         if !lCajaOpen( Application():CodigoCaja() ) .and. !oUser():lAdministrador()
            msgStop( "Esta caja " + Application():CodigoCaja() + " esta cerrada." )
            Return .f.
         end if

         aTmp[ _CTURALB   ]   := cCurSesion()
         aTmp[ _CCODALM   ]   := Application():codigoAlmacen()
         aTmp[ _CDIVALB   ]   := cDivEmp()
         aTmp[ _CCODPAGO  ]   := cDefFpg()
         aTmp[ _CCODCAJ   ]   := Application():CodigoCaja()
         aTmp[ _CCODUSR   ]   := Auth():Codigo()
         aTmp[ _NVDVALB   ]   := nChgDiv( aTmp[ _CDIVALB ], D():Get( "Divisas", nView ) )
         aTmp[ _LFACTURADO]   := .f.
         aTmp[ _LSNDDOC   ]   := .t.
         aTmp[ _CSUFALB   ]   := RetSufEmp()
         aTmp[ _CSERALB   ]   := cNewSer( "NALBCLI", D():Get( "NCount", nView ) )
         aTmp[ _DFECENV   ]   := Ctod( "" )
         aTmp[ _DFECIMP   ]   := Ctod( "" )
         aTmp[ _CCODDLG   ]   := Application():CodigoDelegacion()
         aTmp[ _LIVAINC   ]   := uFieldEmpresa( "lIvaInc" )
         aTmp[ _NIVAMAN   ]   := nIva( D():Get( "TIva", nView ), cDefIva() )
         aTmp[ _CMANOBR   ]   := Padr( getConfigTraslation( "Gastos" ), 250 )
         aTmp[ _NFACTURADO]   := 1
         aTmp[ _TFECALB   ]   := GetSysTime()

      case nMode == DUPL_MODE

         if !lCurSesion()
            MsgStop( "No hay sesiones activas, imposible añadir documentos" )
            Return .f.
         end if

         if !lCajaOpen( Application():CodigoCaja() ) .and. !oUser():lAdministrador()
            msgStop( "Esta caja " + Application():CodigoCaja() + " esta cerrada." )
            Return .f.
         end if

         aTmp[ _DFECALB   ]   := GetSysDate()
         aTmp[ _TFECALB   ]   := GetSysTime()
         aTmp[ _CTURALB   ]   := cCurSesion()
         aTmp[ _CCODCAJ   ]   := Application():CodigoCaja()
         aTmp[ _LFACTURADO]   := .f.
         aTmp[ _LSNDDOC   ]   := .t.
         aTmp[ _CNUMPED   ]   := ""
         aTmp[ _LCLOALB   ]   := .f.
         aTmp[ _NFACTURADO]   := 1
         aTmp[ _CCODUSR   ]   := Auth():Codigo()

      case nMode == EDIT_MODE

         if aTmp[ _LCLOALB ] .and. !oUser():lAdministrador()
            MsgStop( "El albarán está cerrado." )
            Return .f.
         end if

         if lFacturado( aTmp ) //aTmp[ _LFACTURADO ]
            MsgStop( "El albarán ya fue facturado." )
            return .t.
         end if

         aTmp[ _LSNDDOC   ]   := .t.

         lChangeRegIva( aTmp )

   end case

   if empty( aTmp[ _CSERALB ] )
      aTmp[ _CSERALB ]        := cDefSer()
   end if

   if empty( aTmp[ _NTARIFA ] )
      aTmp[ _NTARIFA ]        := Max( uFieldEmpresa( "nPreVta" ), 1 )
   end if

   if empty( aTmp[ _CDTOESP ] )
      aTmp[ _CDTOESP ]        := Padr( "General", 50 )
   end if

   if empty( aTmp[ _CDPP ] )
      aTmp[ _CDPP ]           := Padr( "Pronto pago", 50 )
   end if

   /*
   tipo de albaran---------------------------------------------------------
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

   nRieCli                    := 0 // ClientesModel():Riesgo( aTmp[ _CCODCLI ] )

   if empty( aTmp[ _CTLFCLI ] )
      aTmp[ _CTLFCLI ]        := RetFld( aTmp[ _CCODCLI ], D():Get( "Client", nView ), "Telefono" )
   end if

   nOrd                       := ( D():Get( "AlbCliT", nView ) )->( ordSetFocus( "nNumAlb" ) )

   cPicUnd                    := MasUnd()                            // Picture de las unidades
   cPouDiv                    := cPouDiv( aTmp[ _CDIVALB ], D():Get( "Divisas", nView ) ) // Picture de la divisa
   cPorDiv                    := cPorDiv( aTmp[ _CDIVALB ], D():Get( "Divisas", nView ) ) // Picture de la divisa redondeada
   cPpvDiv                    := cPpvDiv( aTmp[ _CDIVALB ], D():Get( "Divisas", nView ) ) // Picture del punto verde
   nDouDiv                    := nDouDiv( aTmp[ _CDIVALB ], D():Get( "Divisas", nView ) ) // Numero de decimales de la divisa
   nDorDiv                    := nRouDiv( aTmp[ _CDIVALB ], D():Get( "Divisas", nView ) ) // Numero de decimales de la divisa
   nDpvDiv                    := nDpvDiv( aTmp[ _CDIVALB ], D():Get( "Divisas", nView ) ) // Decimales de redondeo del punto verde

   if lFacturado( aTmp )
      cEstAlb                 := "Facturado"
   else
      cEstAlb                 := "Pendiente"
   end if

   /*
   Etiquetas-------------------------------------------------------------------
   */

   cSay[ 2 ]                  := RetFld( aTmp[ _CCODALM ], dbfAlm )
   cSay[ 3 ]                  := RetFld( aTmp[ _CCODPAGO], D():Get( "FPago", nView ) )
   cSay[ 4 ]                  := RetFld( aTmp[ _CCODAGE ], dbfAgent )
   cSay[ 5 ]                  := RetFld( aTmp[ _CCODTAR ], dbfTarPreS )
   cSay[ 6 ]                  := RetFld( aTmp[ _CCODCLI ] + aTmp[ _CCODOBR ], dbfObrasT, "cNomObr", "cCodCli" )
   cSay[ 7 ]                  := RetFld( aTmp[ _CCODRUT ], dbfRuta )
   cSay[ 9 ]                  := RetFld( aTmp[ _CCODCAJ ], dbfCajT )
   cSay[ 10]                  := SQLUsuariosModel():getNombreWhereCodigo( aTmp[ _CCODUSR ] )
   cSay[ 11]                  := RetFld( cCodEmp() + aTmp[ _CCODDLG ], dbfDelega, "cNomDlg" )

   /*
   Inicializamos el valor de la tarifa por si cambian--------------------------
   */

   InitTarifaCabecera( aTmp[ _NTARIFA ] )

   /*
   Comienza el dialogo---------------------------------------------------------
   */

   DEFINE DIALOG oDlg ;
      RESOURCE    "PEDCLI" ;
      TITLE       LblTitle( nMode ) + "albaranes a clientes"

      REDEFINE FOLDER oFld ;
         ID       200 ;
         OF       oDlg ;
         PROMPT   "Albará&n",;
                  "Da&tos",;
                  "&Incidencias",;
                  "D&ocumentos",;
                  "&Situaciones";
         DIALOGS  "ALBCLI_1",;
                  "ALBCLI_2",;
                  "PEDCLI_3",;
                  "PEDCLI_4",;
                  "PEDCLI_5"

      /*
      Codigo de Cliente________________________________________________________
      */

      REDEFINE BITMAP oBmpGeneral ;
        ID       990 ;
        RESOURCE "gc_document_empty_user_48" ;
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
         ID       170 ;
         WHEN     ( lWhen ) ;
         VALID    ( LoaCli( aGet, aTmp, nMode ), RecalculaTotal( aTmp ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwClient( aGet[ _CCODCLI ], aGet[ _CNOMCLI ] ) );
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[_CNOMCLI] VAR aTmp[_CNOMCLI] ;
         ID       171 ;
         WHEN     ( lWhen .and. ( !aTmp[ _LMODCLI ] .or. oUser():lAdministrador() ) ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[_CDNICLI] VAR aTmp[_CDNICLI] ;
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
         COLOR    CLR_GET ;
         WHEN     ( lWhen .and. ( !aTmp[ _LMODCLI ] .or. oUser():lAdministrador() ) ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CPRVCLI ] VAR aTmp[ _CPRVCLI ] ;
         ID       104 ;
         COLOR    CLR_GET ;
         WHEN     ( lWhen .and. ( !aTmp[ _LMODCLI ] .or. oUser():lAdministrador() ) ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CPOSCLI ] VAR aTmp[ _CPOSCLI ] ;
         ID       107 ;
         COLOR    CLR_GET ;
         WHEN     ( lWhen .and. ( !aTmp[ _LMODCLI ] .or. oUser():lAdministrador() ) ) ;
         OF       oFld:aDialogs[1]

      /*
      Combox tarifa
      */

      oGetTarifa  := comboTarifa():Build( { "idCombo" => 172, "uValue" => aTmp[ _NTARIFA ] } )
      oGetTarifa:Resource( oFld:aDialogs[1] )
  
      REDEFINE BTNBMP oBtnPrecio ;
         ID       174 ;
         OF       oFld:aDialogs[1] ;
         RESOURCE "gc_arrow_down_16" ;
         NOBORDER ;
         ACTION   ( ChangeTarifaCabecera( oGetTarifa:getTarifa(), dbfTmpLin, oBrwLin ) );
         WHEN     ( nMode != ZOOM_MODE .and. ( SQLAjustableModel():getRolCambiarPrecios( Auth():rolUuid() ) ) )

      REDEFINE GET oRieCli VAR nRieCli;
         ID       173 ;
         WHEN     ( nMode != ZOOM_MODE );
         PICTURE  cPorDiv ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CTLFCLI ] VAR aTmp[ _CTLFCLI ] ;
         ID       106 ;
         WHEN     ( lWhen .and. ( !aTmp[ _LMODCLI ] .or. oUser():lAdministrador() ) ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CCODUSR ] VAR aTmp[ _CCODUSR ];
         ID       125 ;
         WHEN     ( .f. ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET oSay[ 10 ] ;
         VAR      cSay[ 10 ] ;
         ID       126 ;
         WHEN     ( .f. ) ;
         OF       oFld:aDialogs[2]

      /*
      Codigo de Tarifa_______________________________________________________________
      */

      REDEFINE GET aGet[ _CCODTAR ] VAR aTmp[ _CCODTAR ] ;
         ID       180 ;
         WHEN     ( lWhen .and. oUser():lAdministrador() ) ;
         VALID    ( cTarifa( aGet[ _CCODTAR ], oSay[ 5 ] ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwTarifa( aGet[ _CCODTAR ], oSay[ 5 ] ) ) ;
         COLOR    CLR_GET ;
         OF       oFld:aDialogs[1]

      REDEFINE GET oSay[ 5 ] VAR cSay[ 5 ] ;
         WHEN     .F. ;
         ID       181 ;
         OF       oFld:aDialogs[1]

      /*
      Codigo de Obra_________________________________________________________________
      */

      REDEFINE GET aGet[ _CCODOBR ] VAR aTmp[ _CCODOBR ] ;
         ID       190 ;
         WHEN     ( lWhen ) ;
         VALID    ( cObras( aGet[ _CCODOBR ], oSay[ 6 ], aTmp[ _CCODCLI ] ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwObras( aGet[ _CCODOBR ], oSay[ 6 ], aTmp[ _CCODCLI ], dbfObrasT ) ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET oSay[ 6 ] VAR cSay[ 6 ] ;
         WHEN     .F. ;
         ID       191 ;
         OF       oFld:aDialogs[1]

      /*
      Codigo de Almacen______________________________________________________________
      */

      REDEFINE GET aGet[ _CCODALM ] ;
         VAR      aTmp[ _CCODALM ] ;
         ID       200 ;
         WHEN     ( lWhen ) ;
         VALID    ( cAlmacen( aGet[ _CCODALM ], , oSay[ 2 ] ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwAlmacen( aGet[ _CCODALM ], oSay[ 2 ] ) ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET oSay[ 2 ] VAR cSay[ 2 ] ;
         ID       201 ;
         WHEN     ( lWhen ) ;
         BITMAP   "Bot" ;
         ON HELP  ( ExpAlmacen( aTmp[ _CCODALM ], dbfTmpLin, oBrwLin ) ) ;
         OF       oFld:aDialogs[1]

      /*
      Formas de pago___________________________________________________________________
      */

      REDEFINE GET aGet[ _CCODPAGO ] VAR aTmp[ _CCODPAGO ] ;
         ID       210 ;
         WHEN     ( lWhen .and. oUser():lAdministrador() ) ;
         PICTURE  "@!" ;
         VALID    ( cFPago( aGet[ _CCODPAGO ], D():Get( "FPago", nView ), oSay[ 3 ] ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwFPago( aGet[ _CCODPAGO ], oSay[ 3 ] ) ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET oSay[ 3 ] VAR cSay[ 3 ] ;
         ID       211 ;
         WHEN     .F. ;
         OF       oFld:aDialogs[1]

      /*
      Banco del cliente--------------------------------------------------------
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
         VALID    (  lCalcDC( aTmp[ _CENTBNC ], aTmp[ _CSUCBNC ], aTmp[ _CDIGBNC ], aTmp[ _CCTABNC ], aGet[ _CDIGBNC ] ),;
                     aGet[ _CPAISIBAN ]:lValid() ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CSUCBNC ] VAR aTmp[ _CSUCBNC ];
         ID       421 ;
         WHEN     ( lWhen );
         VALID    (  lCalcDC( aTmp[ _CENTBNC ], aTmp[ _CSUCBNC ], aTmp[ _CDIGBNC ], aTmp[ _CCTABNC ], aGet[ _CDIGBNC ] ),;
                     aGet[ _CPAISIBAN ]:lValid() ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CDIGBNC ] VAR aTmp[ _CDIGBNC ];
         ID       422 ;
         WHEN     ( lWhen );
         VALID    (  lCalcDC( aTmp[ _CENTBNC ], aTmp[ _CSUCBNC ], aTmp[ _CDIGBNC ], aTmp[ _CCTABNC ], aGet[ _CDIGBNC ] ),;
                     aGet[ _CPAISIBAN ]:lValid() ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CCTABNC ] VAR aTmp[ _CCTABNC ];
         ID       423 ;
         WHEN     ( lWhen );
         PICTURE  "9999999999" ;
         VALID    (  lCalcDC( aTmp[ _CENTBNC ], aTmp[ _CSUCBNC ], aTmp[ _CDIGBNC ], aTmp[ _CCTABNC ], aGet[ _CDIGBNC ] ),;
                     aGet[ _CPAISIBAN ]:lValid() ) ;
         OF       oFld:aDialogs[1]

      /*
      Codigo de Agente_______________________________________________________________
      */

      REDEFINE GET aGet[ _CCODAGE ] VAR aTmp[ _CCODAGE ] ;
         ID       220 ;
         WHEN     ( lWhen ) ;
         VALID    ( LoadAgente( aGet[ _CCODAGE ], dbfAgent, oSay[ 4 ], aGet[ _NPCTCOMAGE ], dbfAgeCom, dbfTmpLin, oBrwLin ), RecalculaTotal( aTmp ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwAgentes( aGet[ _CCODAGE ], oSay[ 4 ] ) ) ;
         COLOR    CLR_GET ;
         OF       oFld:aDialogs[1]

      REDEFINE GET oSay[ 4 ] VAR cSay[ 4 ] ;
         ID       221 ;
         WHEN     ( !empty( aTmp[ _CCODAGE ] ) .and. lWhen ) ;
         BITMAP   "Bot" ;
         ON HELP  ( changeAgentPercentageInAllLines(aTmp[ _NPCTCOMAGE ], dbfTmpLin, oBrwLin ), RecalculaTotal( aTmp ) ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _NPCTCOMAGE ] VAR aTmp[ _NPCTCOMAGE ] ;
         WHEN     ( !empty( aTmp[ _CCODAGE ] ) .and. lWhen ) ;
         VALID    ( validateAgentPercentage( aGet[ _NPCTCOMAGE ], dbfTmpLin, oBrwLin ), RecalculaTotal( aTmp ) );
         PICTURE  "@E 999.99" ;
         SPINNER;
         ID       222 ;
         OF       oFld:aDialogs[1]

      REDEFINE GET oGetAge VAR nTotAge ;
         ID       223 ;
         WHEN     ( .f. );
         OF       oFld:aDialogs[1]

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
         WHEN     .F. ;
         OF       oFld:aDialogs[1]

      REDEFINE GET oSay[ 9 ] VAR cSay[ 9 ] ;
         ID       166 ;
         WHEN     .f. ;
         OF       oFld:aDialogs[2]

      /*
      Codigo de Divisas______________________________________________________________
      */

      REDEFINE GET aGet[ _CDIVALB ] VAR aTmp[ _CDIVALB ];
         WHEN     ( nMode == APPD_MODE .and. ( dbfTmpLin )->( LastRec() ) == 0 ) ;
         VALID    ( cDivOut( aGet[ _CDIVALB ], oBmpDiv, aTmp[ _NVDVALB ], @cPouDiv, @nDouDiv, @cPorDiv, @nDorDiv, @cPpvDiv, @nDpvDiv, oGetMasDiv, D():Get( "Divisas", nView ), oBandera ) );
         PICTURE  "@!";
         ID       230 ;
         BITMAP   "LUPA" ;
         ON HELP  BrwDiv( aGet[ _CDIVALB ], oBmpDiv, aTmp[ _NVDVALB ], D():Get( "Divisas", nView ), oBandera ) ;
         OF       oFld:aDialogs[1]

      REDEFINE BITMAP oBmpDiv ;
         RESOURCE ( cBmpDiv( aTmp[ _CDIVALB ], D():Get( "Divisas", nView ) ) ) ;
         ID       231;
         OF       oFld:aDialogs[1]

      /*
      REDEFINE GET aGet[ _NVDVALB ] VAR aTmp[ _NVDVALB ];
         WHEN     ( .F. ) ;
         ID       232 ;
         VALID    ( aTmp[ _NVDVALB ] > 0 ) ;
         PICTURE  "@E 999,999.9999" ;
         COLOR    CLR_GET ;
         OF       oFld:aDialogs[1]

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
      oBrwLin:bClrStd         := {|| { if( ( dbfTmpLin )->lKitChl, CLR_GRAY, CLR_BLACK ), GetSysColor( COLOR_WINDOW ) } }

      oBrwLin:cAlias          := dbfTmpLin

      oBrwLin:nMarqueeStyle   := 6
      oBrwLin:cName           := "Albaran de cliente.Detalle"
      oBrwLin:lFooter         := .t.
      oBrwLin:lAutoSort       := .t.

      oBrwLin:bExportLector   := {|| stringExport( dbfTmpLin ) }

      oBrwLin:CreateFromResource( 240 )

      with object ( oBrwLin:AddCol() )
         :cHeader             := "Of. Oferta"
         :bStrData            := {|| "" }
         :bEditValue          := {|| ( dbfTmpLin )->lLinOfe }
         :nWidth              := 20
         :SetCheck( { "gc_star2_16", "Nil16" } )
         :lHide               := .t.
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader             := "Número"
         :cSortOrder          := "nNumLin"
         :bEditValue          := {|| ( dbfTmpLin )->nNumLin }
         :bLClickHeader       := {| nMRow, nMCol, nFlags, oCol | if( !empty( oCol ), oCol:SetOrder(), ) }
         :cEditPicture        := "9999"
         :nWidth              := 60
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
         :lHide               := .t.
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
         :nWidth              := 60
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
      end with       

      with object ( oBrwLin:AddCol() )
         :cHeader             := "Código"
         :cSortOrder          := "cRef"
         :bEditValue          := {|| ( dbfTmpLin )->cRef }
         :bLClickHeader       := {| nMRow, nMCol, nFlags, oCol | if( !empty( oCol ), oCol:SetOrder(), ) }
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
         :cSortOrder          := "cDetalle"
         :bEditValue          := {|| Descrip( dbfTmpLin ) }
         :bLClickHeader       := {| nMRow, nMCol, nFlags, oCol | if( !empty( oCol ), oCol:SetOrder(), ) }         
         :nWidth              := 260
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader             := "Última venta"
         :cSortOrder          := "dFecUltCom"
         :bEditValue          := {|| Dtoc( ( dbfTmpLin )->dFecUltCom ) }
         :bClrStd             := {|| { if( ( GetSysDate() - ( dbfTmpLin )->dFecUltCom ) > 30, CLR_HRED, CLR_BLACK ), GetSysColor( COLOR_WINDOW )} }
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
         :bEditValue          := {|| ( dbfTmpLin )->cValPr1 }
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
         :bEditValue          := {|| ( dbfTmpLin )->cValPr2 }
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
         :cHeader             := "Caducidad"
         :bEditValue          := {|| Dtoc( ( dbfTmpLin )->dFecCad ) }
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
         :bEditValue          := {|| ( dbfTmpLin )->nCanEnt }
         :cEditPicture        := MasUnd()
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
         :nFooterType         := AGGR_SUM
         :bOnPostEdit         := {|o,x,n| if( lCompruebaStock( dbfTmpLin, oStock, ( x - nTotNAlbCli( dbfTmpLin ) ) ), ChangeUnidades( o, x, n, aTmp ), ) }
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
         :bEditValue          := {|| nTotNAlbCli( dbfTmpLin ) }
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
         :bEditValue          := {|| nTotUAlbCli( dbfTmpLin, nDouDiv ) }
         :cEditPicture        := cPouDiv
         :nWidth              := 80
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
         :nEditType           := oUser():nEditarPrecio()
         :bOnPostEdit         := {|o,x,n| changeFieldLine( o, x, n, aTmp ) }
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader             := "Precio " + cImp() + " inc."
         :bEditValue          := {|| nIncUAlbCli( dbfTmpLin, nDouDiv ) }
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
         :nEditType           := oUser():nEditarPrecio()
         :bOnPostEdit         := {|o,x,n| changeFieldLine( o, x, n, aTmp, "nDto" ) }
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader             := "Dto. Lin."
         :bEditValue          := {|| nDtoUAlbCli( dbfTmpLin, nDouDiv ) }
         :cEditPicture        := cPouDiv
         :nWidth              := 50
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
         :nEditType           := oUser():nEditarPrecio()
         :bOnPostEdit         := {|o,x,n| changeFieldLine( o, x, n, aTmp, "nDtoDiv" ) }
         :lHide               := .t.
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader             := "% Prm."
         :bEditValue          := {|| ( dbfTmpLin )->nDtoPrm }
         :cEditPicture        := "@E 999.99"
         :nWidth              := 40
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
         :nEditType           := oUser():nEditarPrecio()
         :bOnPostEdit         := {|o,x,n| changeFieldLine( o, x, n, aTmp, "nDtoPrm" ) }
         :lHide               := .t.
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader             := "Codigo agente"
         :bEditValue          := {|| ( dbfTmpLin )->cCodAge }
         :nWidth              := 40
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
         :nFooterType         := AGGR_SUM
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader             := "Centro de coste"
         :bEditValue          := {|| ( dbfTmpLin )->cCtrCoste }
         :nWidth              := 20
         :lHide               := .t.
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader             := "Dirección"
         :bEditValue          := {|| ( dbfTmpLin )->cObrLin + Space( 1 ) + RetFld( aTmp[ _CCODCLI ] + ( dbfTmpLin )->cObrLin, dbfObrasT, "cNomObr" ) }
         :nWidth              := 250
         :lHide               := .t.
      end with

      if nMode != ZOOM_MODE
         oBrwLin:bLDblClick   := {|| EdtDeta( oBrwLin, bEdtDet, aTmp ) }
      end if

      /*
      Cajas para el desglose---------------------------------------------------
      */

      REDEFINE GET aGet[ _CDTOESP ] VAR aTmp[ _CDTOESP ] ;
         ID       249 ;
         WHEN     ( lWhen ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _NDTOESP ] VAR aTmp[ _NDTOESP ] ;
         ID       250 ;
         PICTURE  "@E 999.99" ;
         SPINNER ;
         VALID    ( RecalculaTotal( aTmp ) ) ;
         ON CHANGE( RecalculaTotal( aTmp ) ) ;
         WHEN     ( lWhen ) ;
         OF       oFld:aDialogs[1]

      REDEFINE BUTTON oSayLabels[ 2 ] ;
         ID       248 ;
         OF       oFld:aDialogs[ 1 ] ;
         WHEN     ( lWhen ) ;
         ACTION   ( aGet[ _NDTOESP ]:cText( Val( GetPvProfString( "Descuentos", "Descuento especial", 0, cIniEmpresa() ) ) ), RecalculaTotal( aTmp ) )

      REDEFINE GET aGet[ _CDPP ] VAR aTmp[ _CDPP ] ;
         ID       259 ;
         WHEN     ( lWhen ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _NDPP ] VAR aTmp[ _NDPP ];
         ID       260 ;
         PICTURE  "@E 999.99" ;
         SPINNER ;
         VALID    ( RecalculaTotal( aTmp ) ) ;
         ON CHANGE( RecalculaTotal( aTmp ) ) ;
         WHEN     ( lWhen ) ;
         OF       oFld:aDialogs[1]

      REDEFINE BUTTON oSayLabels[ 3 ] ;
         ID       258 ;
         OF       oFld:aDialogs[ 1 ] ;
         WHEN     ( lWhen ) ;
         ACTION   ( aGet[ _NDPP ]:cText( Val( GetPvProfString( "Descuentos", "Descuento pronto pago", 0, cIniEmpresa() ) ) ), RecalculaTotal( aTmp ) )

      REDEFINE GET aGet[ _CDTOUNO ] VAR aTmp[ _CDTOUNO ] ;
         ID       270 ;
         WHEN     ( lWhen ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _NDTOUNO ] VAR aTmp[ _NDTOUNO ];
         ID       280 ;
         PICTURE  "@E 999.99" ;
         SPINNER ;
         VALID    ( RecalculaTotal( aTmp ) ) ;
         ON CHANGE( RecalculaTotal( aTmp ) ) ;
         WHEN     ( lWhen ) ;
         OF       oFld:aDialogs[1]

      REDEFINE BUTTON oSayLabels[ 4 ] ;
         ID       268 ;
         OF       oFld:aDialogs[ 1 ] ;
         WHEN     ( lWhen ) ;
         ACTION   ( aGet[ _NDTOUNO ]:cText( Val( GetPvProfString( "Descuentos", "Descuento uno", 0, cIniEmpresa() ) ) ), RecalculaTotal( aTmp ) )

      REDEFINE GET aGet[ _CDTODOS ] VAR aTmp[ _CDTODOS ] ;
         ID       290 ;
         WHEN     ( lWhen ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _NDTODOS ] VAR aTmp[ _NDTODOS ];
         ID       300 ;
         PICTURE  "@E 999.99" ;
         SPINNER ;
         VALID    ( RecalculaTotal( aTmp ) ) ;
         ON CHANGE( RecalculaTotal( aTmp ) ) ;
         WHEN     ( lWhen ) ;
         OF       oFld:aDialogs[1]

      REDEFINE BUTTON oSayLabels[ 5 ] ;
         ID       288 ;
         OF       oFld:aDialogs[ 1 ] ;
         WHEN     ( lWhen ) ;
         ACTION   ( aGet[ _NDTODOS ]:cText( Val( GetPvProfString( "Descuentos", "Descuento dos", 0, cIniEmpresa() ) ) ), RecalculaTotal( aTmp ) )

      /*
      Desglose del impuestos---------------------------------------------------------
      */

      oBrwIva                        := IXBrowse():New( oFld:aDialogs[ 1 ] )

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
         :bOnPostEdit      := {|o,x| EdtIva( o, x, aTotIva[ oBrwIva:nArrayAt, 3 ], dbfTmpLin, D():Get( "TIva", nView ), oBrwLin ), RecalculaTotal( aTmp ) }
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
         COLOR    CLR_GET ;
         WHEN     ( lWhen ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _NIVAMAN ] VAR aTmp[ _NIVAMAN ] ;
         ID       412 ;
         WHEN     ( lWhen ) ;
         PICTURE  "@E 99.99" ;
         VALID    ( lTiva( D():Get( "TIva", nView ), aTmp[ _NIVAMAN ] ) .and. RecalculaTotal( aTmp ) );
         ON CHANGE( RecalculaTotal( aTmp ) );
         BITMAP   "LUPA" ;
         ON HELP  ( BrwIva( aGet[ _NIVAMAN ], D():Get( "TIva", nView ), , .t. ) );
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _NMANOBR ] VAR aTmp[ _NMANOBR ] ;
         ID       400 ;
         PICTURE  cPorDiv ;
         WHEN     ( lWhen ) ;
         VALID    ( RecalculaTotal( aTmp ) ) ;
         OF       oFld:aDialogs[1]

      REDEFINE SAY oGetNet VAR nTotNet ;
         ID       401 ;
         OF       oFld:aDialogs[1]

      REDEFINE SAY oGetTrn VAR nTotTrn ;
         ID       402 ;
         OF       oFld:aDialogs[1]

      REDEFINE SAY oSayGetRnt ;
         ID       709 ;
         OF       oFld:aDialogs[1]

      REDEFINE GET oGetRnt VAR cGetRnt ;
         ID       408 ;
         OF       oFld:aDialogs[1]

      REDEFINE SAY oGetIvm VAR nTotIvm;
         ID       403 ;
         OF       oFld:aDialogs[1]

      REDEFINE CHECKBOX aGet[ _LOPERPV ] ;
         VAR      aTmp[ _LOPERPV  ] ;
         ID       409 ;
         WHEN     ( lWhen ) ;
         ON CHANGE( RecalculaTotal( aTmp ), oBrwLin:Refresh() );
         OF       oFld:aDialogs[1]

      REDEFINE SAY oGetPnt VAR nTotPnt;
         ID       404 ;
         OF       oFld:aDialogs[1]

      REDEFINE SAY oGetIva VAR nTotIva ;
         ID       405 ;
         OF       oFld:aDialogs[1]

      REDEFINE CHECKBOX aGet[ _LRECARGO ] ;
         VAR      aTmp[ _LRECARGO ] ;
         ID       406 ;
         WHEN     ( lWhen ) ;
         ON CHANGE( RecalculaTotal( aTmp ) );
         OF       oFld:aDialogs[1]

      REDEFINE CHECKBOX oImpuestos ;
         VAR      lImpuestos ;
         ID       711 ;
         WHEN     ( .f. ) ;
         OF       oFld:aDialogs[1]

      REDEFINE SAY oGetReq VAR nTotReq ;
         ID       407 ;
         OF       oFld:aDialogs[1]

      REDEFINE SAY oGetTotal VAR nTotAlb;
         ID       360 ;
         FONT     oFontTotal() ;
         OF       oFld:aDialogs[1]

      /*
      Botones de la caja de dialogo___________________________________________
      */

      REDEFINE BUTTON ;
         ID       515 ;
         OF       oFld:aDialogs[1] ;
         WHEN     ( lWhen ) ;
         ACTION   ( AppDeta( oBrwLin, bEdtDet, aTmp, .t., nMode ) )

      REDEFINE BUTTON ;
         ID       500 ;
         OF       oFld:aDialogs[1] ;
         WHEN     ( lWhen ) ;
         ACTION   ( AppDeta( oBrwLin, bEdtDet, aTmp, .f., nMode ) )

      REDEFINE BUTTON ;
         ID       501 ;
         OF       oFld:aDialogs[1] ;
         WHEN     ( lWhen ) ;
         ACTION   ( EdtDeta( oBrwLin, bEdtDet, aTmp, .f., nMode ) )

      REDEFINE BUTTON ;
         ID       502 ;
         OF       oFld:aDialogs[1] ;
         WHEN     ( lWhen ) ;
         ACTION   ( WinDelRec( oBrwLin, dbfTmpLin, {|| delDeta() }, {|| RecalculaTotal( aTmp ) } ) )

      REDEFINE BUTTON ;
         ID       503 ;
         OF       oFld:aDialogs[1] ;
         ACTION   ( WinZooRec( oBrwLin, bEdtDet, dbfTmpLin, .f., nMode, aTmp ) )

      REDEFINE BUTTON ;
         ID       524 ;
         OF       oFld:aDialogs[1] ;
         WHEN     ( lWhen ) ;
         ACTION   ( lineUp( dbfTmpLin, oBrwLin ) )

      REDEFINE BUTTON ;
         ID       525 ;
         OF       oFld:aDialogs[1] ;
         WHEN     ( lWhen ) ;
         ACTION   ( lineDown( dbfTmpLin, oBrwLin ) )

      REDEFINE BUTTON oBtnKit;
         ID       526 ;
         OF       oFld:aDialogs[1] ;
         ACTION   ( lEscandalloEdtRec( .t., oBrwLin ) )

      REDEFINE BUTTON oBtnAtp;
         ID       527 ;
         OF       oFld:aDialogs[1] ;
         WHEN     ( lWhen ) ;
         ACTION   ( CargaAtipicasCliente( aTmp, oBrwLin, oDlg ) )

      REDEFINE BUTTON ;
         ID       528 ;
         OF       oFld:aDialogs[1] ;
         WHEN     ( lWhen ) ;
         ACTION   ( TGetDialog():New( {|getDialog| runMasiveAppendLines( getDialog, aTmp ) } ):Run() )

      REDEFINE GET aGet[ _CSERALB ] VAR aTmp[ _CSERALB ] ;
         ID       100 ;
         SPINNER ;
         ON UP    ( UpSerie( aGet[ _CSERALB ] ) );
         ON DOWN  ( DwSerie( aGet[ _CSERALB ] ) );
         PICTURE  "@!" ;
         COLOR    CLR_GET ;
         WHEN     ( nMode == APPD_MODE .OR. nMode == DUPL_MODE );
         VALID    ( aTmp[ _CSERALB ] >= "A" .and. aTmp[ _CSERALB ] <= "Z"  );
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _NNUMALB ] VAR aTmp[ _NNUMALB ] ;
         ID       110 ;
         PICTURE  "999999999" ;
         WHEN     ( .F. ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CSUFALB ] VAR aTmp[ _CSUFALB ] ;
         ID       120 ;
         PICTURE  "@!" ;
         WHEN     ( .F. ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _DFECALB ] VAR aTmp[ _DFECALB ];
         ID       130 ;
         SPINNER ;
         WHEN     ( lWhen ) ;
         ON HELP  aGet[ _DFECALB ]:cText( Calendario( aTmp[ _DFECALB ] ) ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _TFECALB ] VAR aTmp[ _TFECALB ];
         ID       131 ;
         PICTURE  "@R 99:99:99" ;
         WHEN     ( lWhen ) ;
         VALID    ( iif(   !validTime( aTmp[ _TFECALB ] ),;
                           ( msgStop( "El formato de la hora no es correcto" ), .f. ),;
                           .t. ) );
         OF       oFld:aDialogs[1]

      REDEFINE COMBOBOX oTipAlb VAR cTipAlb ;
         ID       217 ;
         WHEN     ( ( dbfTmpLin )->( LastRec() ) == 0 ) ;
         ON CHANGE( SetDialog( aGet, oSayDias, oSayTxtDias ) );
         ITEMS    aTipAlb ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _DFECSAL ] VAR aTmp[ _DFECSAL ];
         ID       111 ;
         IDSAY    112 ;
         SPINNER;
         WHEN     ( nMode != ZOOM_MODE ) ;
         COLOR    CLR_GET ;
         ON CHANGE( oSayDias:Refresh() );
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _DFECENTR ] VAR aTmp[ _DFECENTR ];
         ID       113 ;
         IDSAY    114 ;
         SPINNER;
         WHEN     ( nMode != ZOOM_MODE ) ;
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
         OF       oFld:aDialogs[1]

      REDEFINE BTNBMP oBtnPre ;
         ID       601 ;
         OF       oFld:aDialogs[1] ;
         WHEN     ( lWhen .and. ( dbfTmpLin )->( ordKeyCount() ) == 0 ) ;
         RESOURCE "gc_notebook_user_16" ;
         NOBORDER ;
         TOOLTIP  "Importar presupuesto" ;
         ACTION   ( BrwPreCli( aGet[ _CNUMPRE ], dbfPreCliT, dbfPreCliL, D():Get( "TIva", nView ), D():Get( "Divisas", nView ), D():Get( "FPago", nView ), aGet[ _LIVAINC ] ) )

      REDEFINE BTNBMP oBtnPed ;
         ID       603 ;
         OF       oFld:aDialogs[1] ;
         WHEN     ( lWhen .and. ( dbfTmpLin )->( ordKeyCount() ) == 0 ) ;
         RESOURCE "gc_clipboard_empty_user_16" ;
         NOBORDER ;
         TOOLTIP  "Importar pedido" ;
         ACTION   ( BrwPedCli( aGet[ _CNUMPED ], dbfPedCliT, dbfPedCliL, D():Get( "TIva", nView ), D():Get( "Divisas", nView ), D():Get( "FPago", nView ), aGet[ _LIVAINC ] ) )

      REDEFINE BUTTON oBtnAgruparPedido;
         ID       512 ;
         OF       oFld:aDialogs[1] ;
         WHEN     ( lWhen .and. ( dbfTmpLin )->( ordKeyCount() ) == 0 ) ;
         ACTION   ( GrpPed( aGet, aTmp, oBrwLin  ) )

      REDEFINE BUTTON ;
         ID       513 ;
         OF       oFld:aDialogs[1] ;
         WHEN     ( lWhen ) ;
         ACTION   ( importarLineasPedidosClientes( aTmp, aGet, oBrwLin )  )

      REDEFINE GET aGet[ _CNUMPED ] VAR aTmp[ _CNUMPED ] ;
         ID       150 ;
         PICTURE  "@R A/XXXXXXXXX/XX" ;
         VALID    ( cPedCli( aGet, aTmp, oBrwLin, oBrwPgo, nMode ), RecalculaTotal( aTmp ), SetDialog( aGet, oSayDias, oSayTxtDias ) );
         WHEN     ( lWhen .and. ( dbfTmpLin )->( ordKeyCount() ) == 0 ) ;
         ON HELP  ( BrwPedCli( aGet[ _CNUMPED ], dbfPedCliT, dbfPedCliL, D():Get( "TIva", nView ), D():Get( "Divisas", nView ), D():Get( "FPago", nView ), aGet[ _LIVAINC ] ),;
                    RecalculaTotal( aTmp ) ) ;
         BITMAP   "LUPA" ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CNUMPRE ] VAR aTmp[ _CNUMPRE ] ;
         ID       151 ;
         WHEN     ( .f. ) ;
         VALID    ( cPreCli( aGet, aTmp, oBrwLin, nMode ), RecalculaTotal( aTmp ), SetDialog( aGet, oSayDias, oSayTxtDias ) ) ;
         PICTURE  "@R A/XXXXXXXXX/XX" ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CNUMSAT ] VAR aTmp[ _CNUMSAT ] ;
         ID       153 ;
         WHEN     ( .f. ) ;
         VALID    ( cSatCli( aGet, aTmp, oBrwLin, nMode ), SetDialog( aGet, oSayDias, oSayTxtDias ), RecalculaTotal( aTmp ) ) ;
         PICTURE  "@R A/XXXXXXXXX/XX" ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _LFACTURADO ] VAR cEstAlb;
         WHEN     .f. ;
         ID       160 ;
         OF       oFld:aDialogs[1]

      REDEFINE CHECKBOX aGet[ _LIVAINC ] ;
         VAR      aTmp[ _LIVAINC ] ;
         ID       165 ;
         WHEN     ( lWhen ) ; // .and. ( dbfTmpLin )->( ordKeyCount() ) == 0
         OF       oFld:aDialogs[1]

      // Segunda caja de dialogo-----------------------------------------------

      // Transportistas--------------------------------------------------------

      oTransportistaSelector:Bind( bSETGET( aTmp[ _CCODTRN ] ) )
      aGet[ _CCODTRN ]  := oTransportistaSelector:Activate( 235, 236, oFld:aDialogs[2] )

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
         COLOR    CLR_GET ;
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
         COLOR    CLR_GET ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwCajas( aGet[ _CCODCAJ ], oSay[ 9 ] ) ) ;
         OF       oFld:aDialogs[2]

      /*
      Retirado por________________________________________________________________
      */
      
      REDEFINE GET aGet[_CRETPOR] VAR aTmp[_CRETPOR] ;
         ID       160 ;
         COLOR    CLR_GET ;
         WHEN     ( lWhen ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[_CRETMAT] VAR aTmp[_CRETMAT] ;
         ID       170 ;
         COLOR    CLR_GET ;
         WHEN     ( lWhen ) ;
         OF       oFld:aDialogs[2]

      /*
      Fecha entregado----------------------------------------------------------
      */

      REDEFINE CHECKBOX aGet[ _LENTREGADO ] ;
         VAR      aTmp[ _LENTREGADO ] ;
         PROMPT   getConfigTraslation( "Entregado" ) ;
         ID       200 ;
         ON CHANGE( ValCheck( aGet, aTmp ) ) ;
         WHEN     ( lWhen ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ _DFECENV ] ;
         VAR      aTmp[ _DFECENV ] ;
         ID       127 ;
         SPINNER ;
         WHEN     ( lWhen ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ _DFECCRE ] VAR aTmp[ _DFECCRE ] ;
         ID       400 ;
         WHEN     ( .f. ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ _CTIMCRE ] VAR aTmp[ _CTIMCRE ] ;
         ID       401 ;
         WHEN     ( .f. ) ;
         OF       oFld:aDialogs[2]

      /*
      Comentarios_____________________________________________________________
      */

      REDEFINE GET aGet[_CCONDENT] VAR aTmp[_CCONDENT] ;
         ID       230 ;
         WHEN     ( lWhen ) ;
         OF       oFld:aDialogs[2]

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
         WHEN     ( lWhen ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ _DFECIMP ] VAR aTmp[ _DFECIMP ] ;
         ID       121 ;
         WHEN     ( lWhen ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ _CHORIMP ] VAR aTmp[ _CHORIMP ] ;
         ID       122 ;
         WHEN     ( lWhen ) ;
         OF       oFld:aDialogs[2]

      REDEFINE SAY oGetMasDiv VAR cGetMasDiv;
         ID       488 ;
         FONT     oFontTotal() ;
         OF       oFld:aDialogs[1]

         /* Centro de coste */

      REDEFINE GET aGet[ _CCENTROCOSTE ] VAR aTmp[ _CCENTROCOSTE ] ;
         ID       180 ;
         IDTEXT   181 ;
         BITMAP   "LUPA" ;
         VALID    ( oCentroCoste:Existe( aGet[ _CCENTROCOSTE ], aGet[ _CCENTROCOSTE ]:oHelpText, "cNombre" ) );
         ON HELP  ( oCentroCoste:Buscar( aGet[ _CCENTROCOSTE ] ) ) ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[2]

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
         :bEditValue          := {|| nEntAlbCli( dbfTmpPgo, D():Get( "Divisas", nView ), cDivEmp(), .t. ) }
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

         /*with object ( oBrwInc:AddCol() )
            :cHeader          := "Incidencia"
            :bEditValue       := {|| cNomInci( ( dbfTmpInc )->cCodTip, dbfInci ) }
            :nWidth           := 230
         end with*/

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
         ID       502 ;
         OF       oFld:aDialogs[ 3 ] ;
         WHEN     ( lWhen ) ;
         ACTION   ( WinDelRec( oBrwInc, dbfTmpInc ) )

      REDEFINE BUTTON ;
         ID       503 ;
         OF       oFld:aDialogs[ 3 ] ;
         ACTION   ( WinZooRec( oBrwInc, bEdtInc, dbfTmpInc ) )

      //Caja de documentos

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
         ID       502 ;
         OF       oFld:aDialogs[ 4 ] ;
         WHEN     ( lWhen ) ;
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
         ID        502 ;
         OF       oFld:aDialogs[ 5 ] ;
         WHEN     ( lWhen ) ;
         ACTION   ( WinDelRec( oBrwEst, dbfTmpEst ) )


      REDEFINE BUTTON ;
         ID        503 ;
         OF       oFld:aDialogs[ 5 ] ;
         ACTION   ( WinZooRec( oBrwEst, bEdtEst, dbfTmpEst, nil, nil, aTmp ) ) 

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
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( if( EndTrans( aTmp, aGet, oBrw, oBrwInc, nMode, oDlg ), ImprimirSeriesAlbaranes(), ) )

      REDEFINE BUTTON ;
         ID       IDOK ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( EndTrans( aTmp, aGet, oBrw, oBrwInc, nMode, oDlg ) )

      REDEFINE BUTTON ;
         ID       IDCANCEL ;
         OF       oDlg ;
         CANCEL ;
         ACTION   ( cancelEdtRec( nMode, aGet, oDlg ) )

      REDEFINE GROUP oSayLabels[ 1 ] ID 700 OF oFld:aDialogs[ 1 ] TRANSPARENT
      REDEFINE SAY   oSayLabels[ 6 ] ID 708 OF oFld:aDialogs[ 1 ]
      REDEFINE SAY   oSayLabels[ 7 ] ID 710 OF oFld:aDialogs[ 1 ]
      REDEFINE SAY   oSayLabels[ 9 ] ID 712 OF oFld:aDialogs[ 1 ]

   if nMode != ZOOM_MODE

      oFld:aDialogs[1]:AddFastKey( VK_F2, {|| AppDeta( oBrwLin, bEdtDet, aTmp, .f., nMode ) } )
      oFld:aDialogs[1]:AddFastKey( VK_F3, {|| EdtDeta( oBrwLin, bEdtDet, aTmp, .f., nMode ) } )
      oFld:aDialogs[1]:AddFastKey( VK_F4, {|| WinDelRec( oBrwLin, dbfTmpLin, {|| delDeta() }, {|| RecalculaTotal( aTmp ) } ) } )
      oFld:aDialogs[1]:AddFastKey( VK_F8, {|| TGetDialog():New( {|getDialog| runMasiveAppendLines( getDialog, aTmp ) } ):Run() } )

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

      oDlg:AddFastKey( VK_F6,             {|| if( EndTrans( aTmp, aGet, oBrw, oBrwInc, nMode, oDlg ), ImprimirSeriesAlbaranes(), ) } )
      oDlg:AddFastKey( VK_F5,             {|| EndTrans( aTmp, aGet, oBrw, oBrwInc, nMode, oDlg ) } )
      oDlg:AddFastKey( VK_F9,             {|| oDetCamposExtra:Play( space(1) ) } )
      oDlg:AddFastKey( 65,                {|| if( GetKeyState( VK_CONTROL ), CreateInfoArticulo(), ) } )

   end if

   oDlg:SetControlFastKey( "AlbaranesClientesLineas", nView, aGet, dbfTmpLin, oBrwLin, dbfTblPro )

   oDlg:bStart       := {|| StartEdtRec( aTmp, aGet, oDlg, nMode, hHash, oBrwLin,  ) }

   ACTIVATE DIALOG   oDlg ;
      ON INIT        ( initEdtRec( aTmp, aGet, oDlg, oSayDias, oSayTxtDias, oBrwPgo, hHash ) );
      ON PAINT       ( recalculaTotal( aTmp ) );
      CENTER

   oMenu:end()

   oBmpEmp:end()
   oBmpDiv:end()
   oBmpGeneral:end()

   oBrwLin:CloseData()
   oBrwPgo:CloseData()
   oBrwInc:CloseData()

   ( D():Get( "AlbCliT", nView ) )->( ordSetFocus( nOrd ) )

   KillTrans()

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

Static Function StartEdtRec( aTmp, aGet, oDlg, nMode, hHash, oBrwLin )

   if nMode == APPD_MODE

      if lRecogerUsuario()

         // if !lGetUsuario( aGet[ _CCODUSR ] )
         //    oDlg:End()
         // end if

      end if 

      if IsHash( hHash )

         do case
            case HGetKeyAt( hHash, 1 ) == "Artículo"
               AppDeta( oBrwLin, bEdtDet, aTmp, nil, nMode, HGetValueAt( hHash, 1 ) )

            case HGetKeyAt( hHash, 1 ) == "Cliente"
               aGet[ _CCODCLI ]:cText( HGetValueAt( hHash, 1 ) )
               aGet[ _CCODCLI ]:lValid()

            case HGetKeyAt( hHash, 1 ) == "Presupuesto"
               aGet[ _CNUMPRE ]:cText( HGetValueAt( hHash, 1 ) )
               aGet[ _CNUMPRE ]:lValid()

            case HGetKeyAt( hHash, 1 ) == "Pedido"
               aGet[ _CNUMPED ]:cText( HGetValueAt( hHash, 1 ) )
               aGet[ _CNUMPED ]:lValid()

            case HGetKeyAt( hHash, 1 ) == "SAT"
               aGet[ _CNUMSAT ]:cText( HGetValueAt( hHash, 1 ) )
               aGet[ _CNUMSAT ]:lValid()

         end case
 
      end if 

   else

      aGet[ _CNUMPRE ]:Hide()
      aGet[ _CNUMPED ]:Hide()
      aGet[ _CNUMSAT ]:Hide()

      if !empty( aTmp[ _CNUMPRE ] )
         aGet[ _CNUMPRE ]:Show()
      end if 

      if !empty( aTmp[ _CNUMPED ] )
         aGet[ _CNUMPED ]:Show()
      end if 

      if !empty( aTmp[ _CNUMSAT ] )
         aGet[ _CNUMSAT ]:Show()
      end if 

      if !empty( aGet[ _CCENTROCOSTE ] )
         aGet[ _CCENTROCOSTE ]:lValid()
      endif

   end if 

   /*
   Cargamos valores al iniciar el diálogo--------------------------------------
   */

   oTransportistaSelector:start()

   /*
   Muestra y oculta las rentabilidades-----------------------------------------
   */

   if oGetRnt != nil .and. SQLAjustableModel():getRolNoMostrarRentabilidad( Auth():rolUuid() )
      oGetRnt:Hide()
   end if

   /*
   Mostramos los escandallos---------------------------------------------------
   */

   lEscandalloEdtRec( .f., oBrwLin )

   /*
   Hace que salte la incidencia al entrar en el documento----------------------
   */

   if !empty( dbfTmpInc ) .and. ( dbfTmpInc )->( Used() ) 

      while !( dbfTmpInc )->( Eof() )
         if ( dbfTmpInc )->lAviso .and. !( dbfTmpInc )->lListo
            msginfo( Trim( ( dbfTmpInc )->mDesInc ), "¡Incidencia!" )
         end if
         ( dbfTmpInc )->( dbSkip() )
      end while

      ( dbfTmpInc )->( dbGoTop() )

   end if

Return ( nil )

//---------------------------------------------------------------------------//

Static Function InitEdtRec( aTmp, aGet, oDlg, oSayDias, oSayTxtDias, oBrwPgo, hHash )

   EdtRecMenu( aGet, aTmp, oBrwLin, oDlg )
                        
   SetDialog( aGet, oSayDias, oSayTxtDias )

   oBrwLin:MakeTotals()

   oBrwLin:Load()
   oBrwInc:Load()
   oBrwPgo:Load()

RETURN ( nil )

//---------------------------------------------------------------------------//

Static Function CancelEdtRec( nMode, aGet, oDlg )

   local cNumDoc  

   if ( nMode == APPD_MODE .or. nMode == DUPL_MODE )
      
      if !exitNoSave( nMode, dbfTmpLin )
         Return nil 
      end if          

      CursorWait()

      // Presupuesto-----------------------------------------------------------

      cNumDoc                             := aGet[ _CNUMPRE ]:VarGet()

      if !empty( cNumDoc ) .and. dbSeekInOrd( cNumDoc, "nNumPre", dbfPreCliT )
         if ( dbfPreCliT )->lEstado .and. dbLock( dbfPreCliT )
            ( dbfPreCliT )->cNumAlb    := ""
            ( dbfPreCliT )->lEstado    := .f.
            ( dbfPreCliT )->( dbUnLock() )
         end if
      end if 

      // Pedido----------------------------------------------------------------

      cNumDoc                             := aGet[ _CNUMPED ]:VarGet()

      if !empty( cNumDoc ) .and. dbSeekInOrd( cNumDoc, "nNumPed", dbfPedCliT )
         if ( dbfPedCliT )->nEstado != 3 .and. dbLock( dbfPedCliT )
            ( dbfPedCliT )->cNumAlb    := ""
            ( dbfPedCliT )->nEstado    := 1
            ( dbfPedCliT )->( dbUnLock() )
         end if
      end if 

      // Pedido----------------------------------------------------------------

      cNumDoc                                         := aGet[ _CNUMSAT ]:VarGet()

      if !empty( cNumDoc ) .and. dbSeekInOrd( cNumDoc, "nNumSat", D():SatClientes( nView ) )
         if ( D():SatClientes( nView ) )->lEstado .and. dbLock( D():SatClientes( nView ) )
            ( D():SatClientes( nView ) )->cNumAlb    := ""
            ( D():SatClientes( nView ) )->lEstado    := 1
            ( D():SatClientes( nView ) )->( dbUnLock() )
         end if
      end if 

      CursorWE()

   end if 

   oDlg:end()

Return ( nil )

//---------------------------------------------------------------------------//

Static Function EdtRecMenu( aGet, aTmp, oBrw, oDlg )

   MENU oMenu

      MENUITEM    "&1. Rotor"

         MENU

            MENUITEM    "&1. Campos extra [F9]";
               MESSAGE  "Mostramos y rellenamos los campos extra para la familia" ;
               RESOURCE "GC_FORM_PLUS2_16" ;
               ACTION   ( oDetCamposExtra:Play( Space(1) ) )

            MENUITEM    "&2. Visualizar pedido";
               MESSAGE  "Visualiza el pedido del que proviene" ;
               RESOURCE "gc_clipboard_empty_user_16" ;
               ACTION   ( if( !empty( aTmp[ _CNUMPED ] ), ZooPedCli( aTmp[ _CNUMPED ] ), MsgStop( "El albarán no procede de un pedido" ) ) )

            SEPARATOR

            MENUITEM    "&3. Generar anticipo";
               MESSAGE  "Genera factura de anticipo" ;
               RESOURCE "gc_document_text_money2_16" ;
               ACTION   ( if( !empty( aTmp[ _CCODCLI ] ),;
                              CreateAntCli( aTmp[ _CCODCLI ] ),;
                              msgStop("Debe seleccionar un cliente para hacer una factura de anticipo" ) ) )

            SEPARATOR

            MENUITEM    "&4. Modificar cliente";
               MESSAGE  "Modifica la ficha del cliente" ;
               RESOURCE "gc_user_16" ;
               ACTION   ( if( !empty( aTmp[ _CCODCLI ] ), EdtCli( aTmp[ _CCODCLI ] ), MsgStop( "Código de cliente vacío" ) ) );

            MENUITEM    "&5. Modificar cliente contactos";
               MESSAGE  "Modifica la ficha del cliente en contactos" ;
               RESOURCE "gc_user_16" ;
               ACTION   ( if( !empty( aTmp[ _CCODCLI ] ), EdtCli( aTmp[ _CCODCLI ], , 5 ), MsgStop( "Código de cliente vacío" ) ) )

            MENUITEM    "&6. Informe de cliente";
               MESSAGE  "Informe de cliente" ;
               RESOURCE "Info16" ;
               ACTION   ( if( !empty( aTmp[ _CCODCLI ] ), InfCliente( aTmp[ _CCODCLI ] ), MsgStop( "Código de cliente vacío" ) ) );

            MENUITEM    "&7. Modificar dirección";
               MESSAGE  "Modifica ficha de la dirección" ;
               RESOURCE "gc_worker2_16" ;
               ACTION   ( if( !empty( aTmp[ _CCODOBR ] ), EdtObras( aTmp[ _CCODCLI ], aTmp[ _CCODOBR ], dbfObrasT ), MsgStop( "Código de obra vacío" ) ) );

            SEPARATOR

            MENUITEM    "&8. Informe del documento";
               MESSAGE  "Informe del documento" ;
               RESOURCE "Info16" ;
               ACTION   ( TTrazaDocumento():Activate( ALB_CLI, aTmp[ _CSERALB ] + Str( aTmp[ _NNUMALB ] ) + aTmp[ _CSUFALB ] ) );

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
         ( dbfTmpLin )->( dbSetFilter( {|| ! Field->lKitChl }, "! lKitChl" ) )
      end if
   end if

   if lSet
      lShwKit( lShwKit )
   end if

   if !empty( oBrwLin )
      oBrwLin:Refresh()
   end if   

Return ( nil )

//---------------------------------------------------------------------------//

Static Function ValCheck( aGet, aTmp )

   if aTmp[ _LENTREGADO ]
      aGet[ _DFECENV ]:cText( GetSysDate() )
   else
      aGet[ _DFECENV ]:cText( Ctod( "" ) )
   end if

Return .t.

//---------------------------------------------------------------------------//
/*
Edita las lineas de Detalle
*/

STATIC FUNCTION EdtDet( aTmp, aGet, dbf, oBrw, lTotLin, cCodArtEnt, nMode, aTmpAlb )

   local oDlg
   local oFld
   local oBtn
   local oTotal
   local nTotal               := 0
   local oSayPr1
   local oSayPr2
   local cSayPr1              := ""
   local cSayPr2              := ""
   local oSayVp1
   local oSayVp2
   local cSayVp1              := ""
   local cSayVp2              := ""
   local bmpImage
   local oSayAlm
   local cSayAlm
   local oStkAct
   local nStkAct              := 0
   local oBtnSer
   local oSayGrp
   local cSayGrp              := ""
   local oSayFam
   local cSayFam              := ""
   local cCodArt              := Padr( aTmp[ _CREF ], 200 )
   local oRentLin
   local cRentLin             := ""
   local cCodDiv              := aTmpAlb[ _CDIVALB ]
   local oSayDias

   cTipoCtrCoste              := AllTrim( aTmp[ _CTIPCTR ] )

   do case
   case nMode == APPD_MODE

      aTmp[ _dCSERALB]        := aTmpAlb[ _CSERALB ]
      aTmp[ _dNNUMALB]        := aTmpAlb[ _NNUMALB ]
      aTmp[ _NCANENT ]        := 1
      aTmp[ _NUNICAJA]        := 1
      aTmp[ _DFECHA  ]        := GetSysDate()
      aTmp[ _LTOTLIN ]        := lTotLin
      aTmp[ _LNEWLIN ]        := .t.
      aTmp[ _CALMLIN ]        := aTmpAlb[ _CCODALM ]
      aTmp[ _LIVALIN ]        := aTmpAlb[ _LIVAINC ]
      aTmp[ __CNUMPED]        := aTmpAlb[ _CNUMPED ]
      aTmp[ _NTARLIN ]        := oGetTarifa:getTarifa()
      aTmp[ _DFECCAD ]        := Ctod( "" )

      aTmp[ __DFECSAL ]       := aTmpAlb[ _DFECSAL ]
      aTmp[ __DFECENT ]       := aTmpAlb[ _DFECENTR ]
      aTmp[ __LALQUILER ]     := !empty( oTipAlb ) .and. ( oTipAlb:nAt == 2 )

      aTmp[ _COBRLIN ]        := aTmpAlb[ _CCODOBR ]

      if !empty( cCodArtEnt )
         cCodArt              := cCodArtEnt
      end if

      cTipoCtrCoste           := "Centro de coste"

      oLinDetCamposExtra:setTemporalAppend()

   case nMode == EDIT_MODE

      lTotLin                 := aTmp[ _LTOTLIN ]

   end case

   /*
   Este valor los guaradamos para detectar los posibles cambios----------------
   */

   cOldCodArt           := aTmp[ _CREF ]
   cOldPrpArt           := aTmp[ _CCODPR1 ] + aTmp[ _CCODPR2 ] + aTmp[ _CVALPR1 ] + aTmp[ _CVALPR2 ]
   cOldUndMed           := aTmp[ _CUNIDAD ]

   cSayGrp              := RetFld( aTmp[ _CGRPFAM ], oGrpFam:GetAlias() )
   cSayFam              := RetFld( aTmp[ _CCODFAM ], D():Familias( nView ) )

   /*
   Caja de dialogo-------------------------------------------------------------
   */

   DEFINE DIALOG oDlg RESOURCE "LFACCLI" TITLE LblTitle( nMode ) + "líneas a albaranes de clientes"

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
         BITMAP   "LUPA" ;
         OF       oFld:aDialogs[1]

      aGet[ _CREF ]:bValid       := {|| LoaArt( cCodArt, aTmp, aGet, aTmpAlb, oStkAct, oSayPr1, oSayPr2, oSayVp1, oSayVp2, bmpImage, nMode ) }
      aGet[ _CREF ]:bHelp        := {|| brwArticulo( aGet[ _CREF ], aGet[ _CDETALLE ], .f., .t., oBtn, aGet[ _CLOTE ], aTmp[ _CCODPR1 ], aTmp[ _CCODPR2 ], aGet[ _CVALPR1 ], aGet[ _CVALPR2 ], aGet[ _DFECCAD ], if( uFieldEmpresa( "lStockAlm" ), aTmp[ _CALMLIN ], nil ) ) }
      aGet[ _CREF ]:bLostFocus   := {|| lCalcDeta( aTmp, aTmpAlb, nDouDiv, oTotal, oRentLin, cCodDiv ) }

      REDEFINE GET aGet[ _CDETALLE ] VAR aTmp[ _CDETALLE ] ;
         ID       110 ;
         WHEN     ( ( lModDes() .or. empty( aTmp[ _CDETALLE ] ) ) .and. nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[ 1 ]

      REDEFINE GET aGet[ _MLNGDES ] VAR aTmp[ _MLNGDES ] ;
         MEMO ;
         ID       111 ;
         WHEN     ( ( lModDes() .or. empty( aTmp[ _MLNGDES ] ) ) .and. nMode != ZOOM_MODE ) ;
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

         aGet[ _CLOTE ]:bValid   := {|| LoaArt( cCodArt, aTmp, aGet, aTmpAlb, oStkAct, oSayPr1, oSayPr2, oSayVp1, oSayVp2, bmpImage, nMode ) }

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

      REDEFINE GET aGet[ _CVALPR1 ] VAR aTmp[ _CVALPR1 ];
         ID       270 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         BITMAP   "LUPA" ;
         VALID    ( if( lPrpAct( aTmp[ _CVALPR1 ], oSayVp1, aTmp[ _CCODPR1 ], dbfTblPro ),;
                        LoaArt( cCodArt, aTmp, aGet, aTmpAlb, oStkAct, oSayPr1, oSayPr2, oSayVp1, oSayVp2, bmpImage, nMode, .f. ),;
                        .f. ) );
         ON HELP  ( brwPropiedadActual( aGet[ _CVALPR1 ], oSayVp1, aTmp[ _CCODPR1 ] ) ) ;
         OF       oFld:aDialogs[1]

         aGet[ _CVALPR1 ]:bChange      := {|| aGet[ _CVALPR1 ]:Assign(), if( !uFieldEmpresa( "lNStkAct" ), oStock:nPutStockActual( aTmp[ _CREF ], aTmp[ _CALMLIN ], aTmp[ _CVALPR1 ], aTmp[ _CVALPR2 ], aTmp[ _CLOTE ], aTmp[ _LKITART ], aTmp[ _NCTLSTK ], oStkAct ), .t. ) }
         aGet[ _CVALPR1 ]:bLostFocus   := {|| lCalcDeta( aTmp, aTmpAlb, nDouDiv, oTotal, oRentLin, cCodDiv ) }

      REDEFINE SAY oSayPr1 VAR cSayPr1;
         ID       271 ;
         OF       oFld:aDialogs[1]

      REDEFINE GET oSayVp1 VAR cSayVp1;
         ID       272 ;
         WHEN     .f. ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CVALPR2 ] VAR aTmp[ _CVALPR2 ];
         ID       280 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         BITMAP   "LUPA" ;
         VALID    ( if( lPrpAct( aTmp[ _CVALPR2 ], oSayVp2, aTmp[ _CCODPR2 ], dbfTblPro ),;
                        LoaArt( cCodArt, aTmp, aGet, aTmpAlb, oStkAct, oSayPr1, oSayPr2, oSayVp1, oSayVp2, bmpImage, nMode, .f. ),;
                        .f. ) );
         ON HELP  ( brwPropiedadActual( aGet[ _CVALPR2 ], oSayVp2, aTmp[ _CCODPR2 ] ) ) ;
         OF       oFld:aDialogs[1]

         aGet[ _CVALPR2 ]:bChange      := {|| aGet[ _CVALPR2 ]:Assign(), if( !uFieldEmpresa( "lNStkAct" ), oStock:nPutStockActual( aTmp[ _CREF ], aTmp[ _CALMLIN ], aTmp[ _CVALPR1 ], aTmp[ _CVALPR2 ], aTmp[ _CLOTE ], aTmp[ _LKITART ], aTmp[ _NCTLSTK ], oStkAct ), .t. ) }
         aGet[ _CVALPR2 ]:bLostFocus   := {|| lCalcDeta( aTmp, aTmpAlb, nDouDiv, oTotal, oRentLin, cCodDiv ) }

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

      REDEFINE GET aGet[ _NIVA ] VAR aTmp[ _NIVA ] ;
         ID       120 ;
         PICTURE  "@E 99.99" ;
         WHEN     ( !aTmp[ _LCONTROL ] .and. lModIva() .and. nMode != ZOOM_MODE ) ;
         VALID    ( lTiva( D():Get( "TIva", nView ), aTmp[ _NIVA ], @aTmp[ _NREQ ] ) );
         ON CHANGE( lCalcDeta( aTmp, aTmpAlb, nDouDiv, oTotal, oRentLin, cCodDiv ) );
         BITMAP   "LUPA" ;
         ON HELP  ( BrwIva( aGet[ _NIVA ], D():Get( "TIva", nView ), , .t. ) ) ;
         OF       oFld:aDialogs[1]

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

      REDEFINE GET aGet[ __NBULTOS ] VAR aTmp[ __NBULTOS ] ;
         ID       450 ;
         IDSAY    451 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) .and. uFieldEmpresa( "lUseBultos" ) ;
         PICTURE  cPicUnd ;
         OF       oFld:aDialogs[1] 

      aGet[ __NBULTOS ]:Cargo          := "nBultos"
      aGet[ __NBULTOS ]:bPostValidate  := {| oSender | runScript( "AlbaranesClientes\Lineas\validControl.prg", oSender, aGet, nView, nMode, aTmpAlb ) } 

      REDEFINE GET aGet[ _NCANENT ] VAR aTmp[ _NCANENT ];
         ID       130 ;
         IDSAY    131 ;
         SPINNER ;
         WHEN     ( !aTmp[ _LCONTROL ] .and. lUseCaj() .and. nMode != ZOOM_MODE ) ;
         PICTURE  cPicUnd ;
         ON CHANGE( lCalcDeta( aTmp, aTmpAlb, nDouDiv, oTotal, oRentLin, cCodDiv ), LoaArt( cCodArt, aTmp, aGet, aTmpAlb, oStkAct, oSayPr1, oSayPr2, oSayVp1, oSayVp2, bmpImage, nMode, .f. ) );
         VALID    ( lCalcDeta( aTmp, aTmpAlb, nDouDiv, oTotal, oRentLin, cCodDiv ), LoaArt( cCodArt, aTmp, aGet, aTmpAlb, oStkAct, oSayPr1, oSayPr2, oSayVp1, oSayVp2, bmpImage, nMode, .f. ) );
         OF       oFld:aDialogs[1] ;

      aGet[ _NCANENT ]:Cargo          := "nCanEnt"
      aGet[ _NCANENT ]:bPostValidate  := {| oSender | runScript( "AlbaranesClientes\Lineas\validControl.prg", oSender, aGet, nView, nMode, aTmpAlb ) } 

      REDEFINE GET aGet[ _NUNICAJA ] VAR aTmp[ _NUNICAJA ] ;
         ID       140 ;
         IDSAY    141 ;
         SPINNER ;
         WHEN     ( !aTmp[ _LCONTROL ] .and. nMode != ZOOM_MODE .and. oUser():lModificaUnidades() ) ;
         ON CHANGE( lCalcDeta( aTmp, aTmpAlb, nDouDiv, oTotal, oRentLin, cCodDiv ), LoaArt( cCodArt, aTmp, aGet, aTmpAlb, oStkAct, oSayPr1, oSayPr2, oSayVp1, oSayVp2, bmpImage, nMode, .f. ) );
         PICTURE  cPicUnd ;
         OF       oFld:aDialogs[1] ;

      aGet[ _NUNICAJA ]:Cargo          := "nUniCaja"
      aGet[ _NUNICAJA ]:bPostValidate  := {| oSender | runScript( "AlbaranesClientes\Lineas\validControl.prg", oSender, aGet, nView, nMode, aTmpAlb ) } 

      REDEFINE GET aGet[ _NFACCNV ] VAR aTmp[ _NFACCNV ] ;
         ID       295 ;
         WHEN     ( !aTmp[_LCONTROL] .and. nMode != ZOOM_MODE ) ;
         PICTURE  "@E 999,999.999999";
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _NPREUNIT ] VAR aTmp[ _NPREUNIT ];
         ID       150 ;
         SPINNER ;
         WHEN     ( !aTmp[_LCONTROL] .and. nMode != ZOOM_MODE ) ;
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
         VALID    ( aTmp[ _NTARLIN ] >= 1 .and. aTmp[ _NTARLIN ] <= 6 );
         WHEN     ( nMode != ZOOM_MODE .and. ( SQLAjustableModel():getRolCambiarPrecios( Auth():rolUuid() ) ) ) ;
         ON CHANGE(  ChangeTarifa( aTmp, aGet, aTmpAlb ),;
                     loadComisionAgente( aTmp, aGet, aTmpAlb ),;
                     lCalcDeta( aTmp, aTmpAlb, nDouDiv, oTotal, oRentLin, cCodDiv ) );
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

      REDEFINE GET aGet[ ( D():Get( "AlbCliL", nView ) )->( fieldpos( "nMedUno" ) ) ] ;
         VAR      aTmp[ ( D():Get( "AlbCliL", nView ) )->( fieldpos( "nMedUno" ) ) ] ;
         ID       520 ;
         IDSAY    521 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ON CHANGE( lCalcDeta( aTmp, aTmpAlb, nDouDiv, oTotal, oRentLin, cCodDiv ) );
         PICTURE  MasUnd() ;
         OF       oFld:aDialogs[1]

         aGet[ ( D():Get( "AlbCliL", nView ) )->( fieldpos( "nMedUno" ) ) ]:oSay:SetColor( CLR_BLUE )


      REDEFINE GET aGet[ ( D():Get( "AlbCliL", nView ) )->( fieldpos( "nMedDos" ) ) ] ;
         VAR      aTmp[ ( D():Get( "AlbCliL", nView ) )->( fieldpos( "nMedDos" ) ) ] ;
         ID       530 ;
         IDSAY    531 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ON CHANGE( lCalcDeta( aTmp, aTmpAlb, nDouDiv, oTotal, oRentLin, cCodDiv ) );
         PICTURE  MasUnd() ;
         OF       oFld:aDialogs[1]

         aGet[ ( D():Get( "AlbCliL", nView ) )->( fieldpos( "nMedDos" ) ) ]:oSay:SetColor( CLR_BLUE )


      REDEFINE GET aGet[ ( D():Get( "AlbCliL", nView ) )->( fieldpos( "nMedTre" ) ) ] ;
         VAR      aTmp[ ( D():Get( "AlbCliL", nView ) )->( fieldpos( "nMedTre" ) ) ] ;
         ID       540 ;
         IDSAY    541 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ON CHANGE( lCalcDeta( aTmp, aTmpAlb, nDouDiv, oTotal, oRentLin, cCodDiv ) );
         PICTURE  MasUnd() ;
         OF       oFld:aDialogs[1]

         aGet[ ( D():Get( "AlbCliL", nView ) )->( fieldpos( "nMedTre" ) ) ]:oSay:SetColor( CLR_BLUE )

      if aTmp[ __LALQUILER ]

         REDEFINE GET aGet[ _NPREALQ ] VAR aTmp[ _NPREALQ ] ;
            ID       250 ;
            SPINNER ;
            WHEN     ( nMode != ZOOM_MODE .and. !lTotLin ) ;
            ON CHANGE( lCalcDeta( aTmp, aTmpAlb, nDouDiv, oTotal, oRentLin, cCodDiv ) );
            VALID    ( lCalcDeta( aTmp, aTmpAlb, nDouDiv, oTotal, oRentLin, cCodDiv ) );
            PICTURE  cPouDiv ;
            OF       oFld:aDialogs[1]

      end if

      REDEFINE GET aGet[ _NIMPTRN ] VAR aTmp[ _NIMPTRN ] ;
         ID       350 ;
         IDSAY    351 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE .and. !lTotLin ) ;
         ON CHANGE( lCalcDeta( aTmp, aTmpAlb, nDouDiv, oTotal, oRentLin, cCodDiv ) );
         VALID    ( lCalcDeta( aTmp, aTmpAlb, nDouDiv, oTotal, oRentLin, cCodDiv ) );
         PICTURE  cPouDiv ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _NPNTVER ] VAR aTmp[ _NPNTVER ] ;
         ID       151 ;
         IDSAY    152 ;
         SPINNER ;
         PICTURE  cPpvDiv ;
         WHEN     ( !aTmp[_LCONTROL] .and. nMode != ZOOM_MODE .and. !lTotLin) ;
         VALID    ( lCalcDeta( aTmp, aTmpAlb, nDouDiv, oTotal, oRentLin, cCodDiv ) );
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _NPESOKG ] VAR aTmp[ _NPESOKG ] ;
         ID       160 ;
         WHEN     ( !aTmp[_LCONTROL] .and. nMode != ZOOM_MODE .and. !lTotLin) ;
         PICTURE  "@E 999,999.999999";
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CPESOKG ] VAR aTmp[ _CPESOKG ] ;
         ID       175 ;
         WHEN     ( !aTmp[_LCONTROL] .and. nMode != ZOOM_MODE .and. !lTotLin ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _NVOLUMEN ] VAR aTmp[ _NVOLUMEN ] ;
         ID       400 ;
         WHEN     ( !aTmp[_LCONTROL] .and. nMode != ZOOM_MODE .and. !lTotLin) ;
         PICTURE  "@E 999,999.999999";
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CVOLUMEN ] VAR aTmp[ _CVOLUMEN ] ;
         ID       410;
         WHEN     ( !aTmp[_LCONTROL] .and. nMode != ZOOM_MODE .and. !lTotLin ) ;
         COLOR    CLR_GET ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CFORMATO ] VAR aTmp[ _CFORMATO ];
         ID       460 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[_NDTO] VAR aTmp[_NDTO] ;
         ID       180 ;
         SPINNER ;
         WHEN     ( !aTmp[ _LCONTROL ] .and. nMode != ZOOM_MODE .and. !lTotLin ) ;
         PICTURE  "@E 999.99";
         ON CHANGE( lCalcDeta( aTmp, aTmpAlb, nDouDiv, oTotal, oRentLin, cCodDiv ) );
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _NDTOPRM ] VAR aTmp[ _NDTOPRM ] ;
         ID       190 ;
         SPINNER ;
         WHEN     ( !aTmp[ _LCONTROL ] .and. nMode != ZOOM_MODE .and. !lTotLin ) ;
         PICTURE  "@E 999.99";
         ON CHANGE( lCalcDeta( aTmp, aTmpAlb, nDouDiv, oTotal, oRentLin, cCodDiv ) );
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _NCOMAGE ] VAR aTmp[ _NCOMAGE ] ;
         ID       200 ;
         SPINNER ;
         WHEN     ( !aTmp[ _LCONTROL ] .and. nMode != ZOOM_MODE .and. !lTotLin ) ;
         PICTURE  "@E 999.99";
         OF       oFld:aDialogs[1]

      if !aTmp[ __LALQUILER ]

      REDEFINE GET oComisionLinea VAR nComisionLinea ;
         ID       201 ;
         WHEN     ( .f. ) ;
         PICTURE  cPorDiv ;
         OF       oFld:aDialogs[ 1 ]

      end if

      REDEFINE GET aGet[ _NDTODIV ] VAR aTmp[ _NDTODIV ] ;
         ID       260 ;
         IDSAY    261 ;
         SPINNER ;
         MIN      0 ;
         COLOR    Rgb( 255, 0, 0 ) ;
         ON CHANGE( lCalcDeta( aTmp, aTmpAlb, nDouDiv, oTotal, oRentLin, cCodDiv ) );
         VALID    ( !aTmp[ _LCONTROL ] .and. aTmp[ _NDTODIV ] >= 0 ) ;
         WHEN     ( nMode != ZOOM_MODE .and. !lTotLin ) ;
         PICTURE  cPouDiv ;
         OF       oFld:aDialogs[1]

      /*
      Tipo de articulo---------------------------------------------------------
      */

      REDEFINE GET aGet[ _CCODTIP ] VAR aTmp[ _CCODTIP ] ;
         ID       205 ;
         IDTEXT   206 ;
         WHEN     ( nMode != ZOOM_MODE .and. nMode != MULT_MODE .and. !lTotLin ) ;
         VALID    ( oTipArt:Existe( aGet[ _CCODTIP ], aGet[ _CCODTIP ]:oHelpText ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( oTipArt:Buscar( aGet[ _CCODTIP ] ) ) ;
         OF       oFld:aDialogs[1]

      /*
      Codigo de almacen--------------------------------------------------------
      */

      REDEFINE GET aGet[ _CALMLIN ] VAR aTmp[ _CALMLIN ] ;
         ID       300 ;
         WHEN     ( !aTmp[ _LCONTROL ] .and. nMode != ZOOM_MODE ) ;         
         VALID    ( cAlmacen( aGet[ _CALMLIN ], , oSayAlm ), if( !uFieldEmpresa( "lNStkAct" ), oStock:lPutStockActual( aTmp[ _CREF ], aTmp[ _CALMLIN ], aTmp[ _CVALPR1 ], aTmp[ _CVALPR2 ], aTmp[ _CLOTE ], aTmp[ _LKITART ], aTmp[ _NCTLSTK ], oStkAct ), .t. ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwAlmacen( aGet[ _CALMLIN ], oSayAlm ) ) ;
         COLOR    CLR_GET ;
         OF       oFld:aDialogs[1]

      REDEFINE GET oSayAlm VAR cSayAlm ;
         WHEN     .f. ;
         ID       301 ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _COBRLIN ] VAR aTmp[ _COBRLIN ] ;
         ID       330 ;
         IDTEXT   331 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( cObras( aGet[ _COBRLIN ], aGet[ _COBRLIN ]:oHelpText, aTmpAlb[ _CCODCLI ] ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwObras( aGet[ _COBRLIN ], aGet[ _COBRLIN ]:oHelpText, aTmpAlb[ _CCODCLI ], dbfObrasT ) ) ;
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

      REDEFINE GET aGet[ _NCOSDIV ] VAR aTmp[ _NCOSDIV ] ;
         ID       320 ;
         IDSAY    321 ;
         WHEN     ( oUser():lAdministrador() .and. nMode != ZOOM_MODE );
         PICTURE  cPouDiv ;
         OF       oFld:aDialogs[1]

      /*
      Segunda caja de dialogo -------------------------------------------------
      */

      REDEFINE GET aGet[ _NPOSPRINT ] VAR aTmp[ _NPOSPRINT ] ;
         ID       100 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
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
         ID       160 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         BITMAP   "LUPA" ;
         VALID    ( oSayFam:cText( RetFld( aTmp[ _CCODFAM  ], D():Familias( nView ) ) ), .t. );
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
        VALID    ( cProvee( aGet[ _CCODPRV ], D():Get( "Provee", nView ), aGet[ _CCODPRV ]:oHelpText ) );
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

      REDEFINE GET aGet[ __DFECALB ] VAR aTmp[ __DFECALB ];
         ID       360 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ __TFECALB ] VAR aTmp[ __TFECALB ] ;
         ID       361 ;
         PICTURE  "@R 99:99:99" ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( iif(   !validTime( aTmp[ __TFECALB ] ),;
                           ( msgStop( "El formato de la hora no es correcto" ), .f. ),;
                           .t. ) );
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ __CNUMPED ] VAR aTmp[ __CNUMPED ] ;
         ID       380 ;
         PICTURE  "@R A/XXXXXXXXX/XX" ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[2]

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

      REDEFINE GET aGet[ __CCENTROCOSTE ] VAR aTmp[ __CCENTROCOSTE ] ;
         ID       410 ;
         IDTEXT   411 ;
         BITMAP   "LUPA" ;
         VALID    ( oCentroCoste:Existe( aGet[ __CCENTROCOSTE ], aGet[ __CCENTROCOSTE ]:oHelpText, "cNombre" ) );
         ON HELP  ( oCentroCoste:Buscar( aGet[ __CCENTROCOSTE ] ) ) ;
         WHEN     ( nMode != ZOOM_MODE ) ;
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

      REDEFINE BUTTON oBtn ;
         ID       IDOK ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   SaveDeta( aTmp, aTmpAlb, oFld, aGet, oBrw, bmpImage, oDlg, nMode, oSayPr1, oSayPr2, oSayVp1, oSayVp2, oStkAct, nStkAct, oTotal, cCodArt, oBtn, oBtnSer )

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

   // Keys --------------------------------------------------------------------

   if nMode != ZOOM_MODE
      if uFieldEmpresa( "lGetLot")
         oDlg:AddFastKey( VK_RETURN,   {|| oBtn:SetFocus(), oBtn:Click() } )
      end if 
      oDlg:AddFastKey( VK_F5,          {|| oBtn:SetFocus(), oBtn:Click() } )
   end if

   oDlg:AddFastKey( VK_F9,             {|| oLinDetCamposExtra:Play( if( nMode == APPD_MODE, "", Str( ( dbfTmpLin )->( OrdKeyNo() ) ) ) ) } )
   oDlg:AddFastKey( VK_F6,             {|| oBtnSer:Click() } )

   // Start --------------------------------------------------------------------

   oDlg:bStart    := {||   SetDlgMode( aTmp, aTmpAlb, nMode, aGet, oFld, oSayPr1, oSayPr2, oSayVp1, oSayVp2, oStkAct, oTotal, oRentLin ),;
                           if( !empty( cCodArtEnt ), aGet[ _CREF ]:lValid(), ),;
                           loadGet( aGet[ _CTERCTR ], cTipoCtrCoste ), aGet[ _CTERCTR ]:lValid(),;
                           lCalcDeta( aTmp, aTmpAlb, nDouDiv, oTotal, oRentLin, cCodDiv ) }

   ACTIVATE DIALOG oDlg ;
      ON INIT     ( menuEdtDet( aGet[ _CREF ], oDlg, , if( nMode == APPD_MODE, "", Str( ( dbfTmpLin )->( OrdKeyNo() ) ) ) ) );
      CENTER


   if !Empty( oDetMenu )
      oDetMenu:End()
   end if

RETURN ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

Static Function runMasiveAppendLines( oDialog, aCabeceraAlbaran )

   oDialog:cleanErrors()

   if !empty( oDialog:cGet )
      oneAppendLine( aCabeceraAlbaran, oDialog:cGet )
      oDialog:cleanGet()
   end if 

   if !empty( oDialog:cGetRelacion )
      masiveAppendLines( aCabeceraAlbaran, oDialog )
      oDialog:cleanGet()
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//

Static Function masiveAppendLines( aCabeceraAlbaran, oDialog )

   local aArticulo 
   local aRelacion
   local aArticulos
   local aRelaciones  
   local cRelaciones       := oDialog:cGetRelacion

   oDialog:cleanErrors()

   aRelaciones             := hb_atokens( cRelaciones, CRLF )

   for each aRelacion in aRelaciones

      aArticulo           := hb_atokens( aRelacion, "," )

      if isArray( aArticulo ) .and. len( aArticulo ) >= 2 .and. !empty( aArticulo[1] ) .and. !empty( aArticulo[2] ) 
         if !( oneAppendLine( aCabeceraAlbaran, aArticulo[1], val( aArticulo[2] ) ) )
            msgStop("- Error al añadir el artículo " + alltrim( aArticulo[1] ) )
            aadd( oDialog:aErrors, "- Error al añadir el artículo " + alltrim( aArticulo[1] ) )
         end if 
      end if

   next 

RETURN ( nil )

//---------------------------------------------------------------------------//

Static Function oneAppendLine( aCabeceraAlbaran, cCodigoArticulo, nUnidadesArticulos )

   local aLineasAlbaranes

   DEFAULT nUnidadesArticulos    := 1

   aLineasAlbaranes              := dbBlankRec( dbfAlbCliL )

   setDlgMode( aLineasAlbaranes, aCabeceraAlbaran, APPD_MODE )

   if loaArt( cCodigoArticulo, aLineasAlbaranes, nil, aCabeceraAlbaran )

      aLineasAlbaranes[ _NUNICAJA ] := nUnidadesArticulos

      saveDeta( aLineasAlbaranes, aCabeceraAlbaran, , , , , , APPD_MODE )

      if !empty( oBrwLin )
         oBrwLin:Refresh()
      end if

      recalculaTotal( aCabeceraAlbaran )

      return ( .t. )

   end if 

RETURN ( .f. )

//---------------------------------------------------------------------------//

Static Function EdtInc( aTmp, aGet, dbf, oBrw, bWhen, bValid, nMode, aTmpAlb )

   local oDlg

   if nMode == APPD_MODE
      aTmp[ _CSERALB  ] := aTmpAlb[ _CSERALB ]
      aTmp[ _NNUMALB  ] := aTmpAlb[ _NNUMALB ]
      aTmp[ _CSUFALB  ] := aTmpAlb[ _CSUFALB ]
   end if

   DEFINE DIALOG oDlg RESOURCE "INCIDENCIA" TITLE LblTitle( nMode ) + "incidencias de albaranes a clientes"

      REDEFINE GET   aTmp[ ( dbfTmpInc )->( FieldPos( "dFecInc" ) ) ] ;
         ID          100 ;
         SPINNER ;
         WHEN        ( nMode != ZOOM_MODE ) ;
         OF          oDlg

      REDEFINE CHECKBOX aTmp[ ( dbfTmpInc )->( FieldPos( "lAviso" ) ) ] ;
         ID          150 ;
         WHEN        ( nMode != ZOOM_MODE ) ;
         OF          oDlg

      REDEFINE GET aTmp[ ( dbfTmpInc )->( FieldPos( "mDesInc" ) ) ] ;
         MEMO ;
         ID          110 ;
         WHEN        ( nMode != ZOOM_MODE ) ;
         OF          oDlg

      REDEFINE CHECKBOX aTmp[ ( dbfTmpInc )->( FieldPos( "lListo" ) ) ] ;
         ID          140 ;
         WHEN        ( nMode != ZOOM_MODE ) ;
         OF          oDlg

      REDEFINE BUTTON ;
         ID          IDOK ;
         OF          oDlg ;
         WHEN        ( nMode != ZOOM_MODE ) ;
         ACTION      ( WinGather( aTmp, nil, dbfTmpInc, oBrw, nMode ), oDlg:end( IDOK ) )

      REDEFINE BUTTON ;
         ID          IDCANCEL ;
         OF          oDlg ;
         CANCEL ;
         ACTION      ( oDlg:end() )

   if nMode != ZOOM_MODE
      oDlg:AddFastKey( VK_F5, {|| WinGather( aTmp, nil, dbfTmpInc, oBrw, nMode ), oDlg:end( IDOK ) } )
   end if

   ACTIVATE DIALOG oDlg CENTER

Return ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

Static Function EdtEst( aTmp, aGet, dbf, oBrw, bWhen, bValid, nMode, aTmpAlb )

      local oDlg

      if nMode == APPD_MODE
         
         aTmp[ (D():AlbaranesClientesSituaciones( nView ))->(fieldpos("tFecSit")) ]   := GetSysTime()

    end if

      DEFINE DIALOG oDlg RESOURCE "SITUACION_ESTADO" TITLE LblTitle( nMode ) + "Situación del documento del cliente"

         REDEFINE COMBOBOX aGet[ (D():AlbaranesClientesSituaciones( nView ))->(fieldpos("cSitua")) ] ;
            VAR    aTmp[ (D():AlbaranesClientesSituaciones( nView ))->(fieldpos("cSitua")) ] ;
            ID       200 ;
            WHEN     ( nMode != ZOOM_MODE );
            ITEMS    ( SQLSituacionesModel():getArrayNombres() ) ;
            OF       oDlg

         REDEFINE GET aGet[ (D():AlbaranesClientesSituaciones( nView ))->(fieldpos("dFecSit")) ] ;
            VAR   aTmp[ (D():AlbaranesClientesSituaciones( nView ))->(fieldpos("dFecSit")) ] ;
            ID       100 ;
            SPINNER ;
            ON HELP  aGet[ (D():AlbaranesClientesSituaciones( nView ))->(fieldpos("dFecSit")) ]:cText( Calendario( aTmp[ (D():AlbaranesClientesSituaciones( nView ))->(fieldpos("dFecSit")) ] ) ) ;
            WHEN  ( nMode != ZOOM_MODE ) ;
            OF       oDlg

         REDEFINE GET aGet[ (D():AlbaranesClientesSituaciones( nView ))->(fieldpos("tFecSit")) ] ;
            VAR    aTmp[ (D():AlbaranesClientesSituaciones( nView ))->(fieldpos("tFecSit")) ] ;
            ID       101 ;
            PICTURE  "@R 99:99:99" ;
            WHEN     ( nMode != ZOOM_MODE ) ;
            VALID    ( iif( !validTime( aTmp[ (D():AlbaranesClientesSituaciones( nView ))->(fieldpos("tFecSit")) ] ),;
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

Static Function EdtDoc( aTmp, aGet, dbf, oBrw, bWhen, bValid, nMode, aTmpLin )

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

/*
Total de unidades en un albaran
*/

static function nTotalUnd( nAlbaran, cPicUnd )

   local nTotUnd  := 0
   local nRecNum  := ( D():Get( "AlbCliL", nView ) )->( RecNo() )

   if ( D():Get( "AlbCliL", nView ) )->( DbSeek( nAlbaran ) )
      while  ( D():Get( "AlbCliL", nView ) )->CSERALB + Str( ( D():Get( "AlbCliL", nView ) )->NNUMALB ) + ( D():Get( "AlbCliL", nView ) )->CSUFALB == nAlbaran .and. ( D():Get( "AlbCliL", nView ) )->( !eof() )
         nTotUnd  += nTotNAlbCli( D():Get( "AlbCliL", nView ) )
         ( D():Get( "AlbCliL", nView ) )->( dbSkip() )
      end do
   end if

   ( D():Get( "AlbCliL", nView ) )->( dbGoTo( nRecNum ) )

RETURN ( Trans( nTotUnd, cPicUnd ) )

//--------------------------------------------------------------------------//

/*
Total peso en un albaran
*/

function nTotalPesoAlbaranCliente( nAlbaran, nView, cPicUnd )

   local nTotPeso    := 0

   if ( D():AlbaranesClientesLineas( nView ) )->( dbSeek( nAlbaran ) )
      while D():AlbaranesClientesLineasId( nView ) == nAlbaran .and. ( D():AlbaranesClientesLineas( nView ) )->( !eof() )
         nTotPeso    += nPesLAlbCli( D():AlbaranesClientesLineas( nView ) )
         ( D():AlbaranesClientesLineas( nView ) )->( dbSkip() )
      end do
   end if

RETURN ( if( empty( cPicUnd ), nTotPeso, Trans( nTotPeso, cPicUnd ) ) )

//--------------------------------------------------------------------------//

Static Function QuiAlbCli()

   local nOrdLin
   local nOrdPgo
   local nOrdInc
   local nOrdDoc
   local nOrdSer
   local cNumAlb
   local cNumPed
   local cNumSat
   local aNumPed

   if ( D():Get( "AlbCliT", nView ) )->lCloAlb .and. !oUser():lAdministrador() 
      msgStop( "Solo pueden eliminar albarares cerrados los administradores." )
      Return .f.
   end if

   CursorWait()

   aNumPed        := {}
   cNumAlb        := ( D():Get( "AlbCliT", nView ) )->cSerAlb + Str( ( D():Get( "AlbCliT", nView ) )->nNumAlb ) + ( D():Get( "AlbCliT", nView ) )->cSufAlb
   cNumPed        := ( D():Get( "AlbCliT", nView ) )->cNumPed
   cNumSat        := ( D():Get( "AlbCliT", nView ) )->cNumSat
   nOrdLin        := ( D():Get( "AlbCliL", nView ) )->( OrdSetFocus( "nNumAlb" ) )
   nOrdPgo        := ( D():Get( "AlbCliP", nView ) )->( OrdSetFocus( "nNumAlb" ) )
   nOrdInc        := ( D():Get( "AlbCliI", nView ) )->( OrdSetFocus( "nNumAlb" ) )
   nOrdDoc        := ( D():Get( "AlbCliD", nView ) )->( OrdSetFocus( "nNumAlb" ) )
   nOrdSer        := ( D():Get( "AlbCliS", nView ) )->( OrdSetFocus( "nNumAlb" ) )

   TComercio:resetProductsToUpdateStocks()

   // Eliminamos las entregas-----------------------------------------------------

   while ( D():Get( "AlbCliP", nView ) )->( dbSeek( cNumAlb ) ) .and. !( D():Get( "AlbCliP", nView ) )->( eof() )

      if ( dbfPedCliP )->( dbSeek( ( D():Get( "AlbCliP", nView ) )->cNumRec ) )
         if dbLock( dbfPedCliP )
            ( dbfPedCliP )->lPasado := .f.
            ( dbfPedCliP )->( dbUnLock() )
         end if
      end if

      if dbDialogLock( D():Get( "AlbCliP", nView ) )
         ( D():Get( "AlbCliP", nView ) )->( dbDelete() )
         ( D():Get( "AlbCliP", nView ) )->( dbUnLock() )
      end if

      ( D():Get( "AlbCliP", nView ) )->( dbSkip() )

   end do

   // Detalle---------------------------------------------------------------------

   while ( D():Get( "AlbCliL", nView ) )->( dbSeek( cNumAlb ) ) .and. !( D():Get( "AlbCliL", nView ) )->( eof() )

      if aScan( aNumPed, ( D():Get( "AlbCliL", nView ) )->cNumPed ) == 0
         aAdd( aNumPed, ( D():Get( "AlbCliL", nView ) )->cNumPed )
      end if      

      TComercio:appendProductsToUpadateStocks( ( D():Get( "AlbCliL", nView ) )->cRef, nView )

      if dbLock( D():Get( "AlbCliL", nView ) )
         ( D():Get( "AlbCliL", nView ) )->( dbDelete() )
         ( D():Get( "AlbCliL", nView ) )->( dbUnLock() )
      end if

   end while

   /*
   Incidencias-----------------------------------------------------------------
   */

   while ( D():Get( "AlbCliI", nView ) )->( dbSeek( cNumAlb ) ) .and. !( D():Get( "AlbCliI", nView ) )->( eof() )
      if dbLock( D():Get( "AlbCliI", nView ) )
         ( D():Get( "AlbCliI", nView ) )->( dbDelete() )
         ( D():Get( "AlbCliI", nView ) )->( dbUnLock() )
      end if
   end while

   /*
   Documentos------------------------------------------------------------------
   */

   while ( D():Get( "AlbCliD", nView ) )->( dbSeek( cNumAlb ) ) .and. !( D():Get( "AlbCliD", nView ) )->( eof() )
      if dbLock( D():Get( "AlbCliD", nView ) )
         ( D():Get( "AlbCliD", nView ) )->( dbDelete() )
         ( D():Get( "AlbCliD", nView ) )->( dbUnLock() )
      end if
   end while

   /*
   Series----------------------------------------------------------------------
   */

   while ( D():Get( "AlbCliS", nView ) )->( dbSeek( cNumAlb ) ) .and. !( D():Get( "AlbCliS", nView ) )->( eof() )
      if dbLock( D():Get( "AlbCliS", nView ) )
         ( D():Get( "AlbCliS", nView ) )->( dbDelete() )
         ( D():Get( "AlbCliS", nView ) )->( dbUnLock() )
      end if
   end while

   /*
   Estado del pedido si tiramos de uno-----------------------------------------
   */

   if !empty( cNumPed )
      oStock:SetEstadoPedCli( cNumPed, .t., cNumAlb )
   end if

   /*
   Estado del Sat de clientes--------------------------------------------------
   */

   if !empty( cNumSat ) .and. dbSeekInOrd( cNumSat, "nNumSat", D():SatClientes( nView ) )
      if dbLock( D():SatClientes( nView ) )
         ( D():SatClientes( nView ) )->cNumAlb    := ""
         ( D():SatClientes( nView ) )->lEstado    := .f.
         ( D():SatClientes( nView ) )->( dbUnLock() )
      end if
   end if 

   /*
   Estado de los pedidos cuando es agrupando-----------------------------------
   */

   for each cNumPed in aNumPed
      oStock:SetEstadoPedCli( cNumPed )
   next   

   // actualiza el stock de prestashop-----------------------------------------

   TComercio:updateWebProductStocks()

   /*
   Cerramos las tablas---------------------------------------------------------
   */

   ( D():Get( "AlbCliL", nView ) )->( OrdSetFocus( nOrdLin ) )
   ( D():Get( "AlbCliP", nView ) )->( OrdSetFocus( nOrdPgo ) )
   ( D():Get( "AlbCliI", nView ) )->( OrdSetFocus( nOrdInc ) )
   ( D():Get( "AlbCliD", nView ) )->( OrdSetFocus( nOrdDoc ) )
   ( D():Get( "AlbCliS", nView ) )->( OrdSetFocus( nOrdSer ) )

   CursorWE()

Return .t.

//--------------------------------------------------------------------------//
//
// Importa pedidos de clientes
//

STATIC FUNCTION cPedCli( aGet, aTmp, oBrwLin, oBrwPgo, nMode )

   local nDiv
   local cDesAlb
   local nTotRet
   local cPedido  := aGet[ _CNUMPED ]:VarGet()
   local lValid   := .f.

   if nMode != APPD_MODE .or. empty( cPedido )
      Return .t.
   end if

   if !( dbSeekInOrd( cPedido, "nNumPed", dbfPedCliT ) )
      msgStop( "Pedido " + cPedido + " no existe" )
      Return .t.
   end if

   if ( dbfPedCliT )->nEstado == 3
      msgStop( "Pedido " + cPedido + " ya fue recibido" )
      Return .t.
   end if

   CursorWait()

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

   oGetTarifa:setTarifa( ( dbfPedCliT )->nTarifa )

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

   aGet[ _CDTOESP ]:cText( ( dbfPedCliT )->cDtoEsp )
   aGet[ _NDTOESP ]:cText( ( dbfPedCliT )->nDtoEsp )
   aGet[ _CDPP    ]:cText( ( dbfPedCliT )->cDpp    )
   aGet[ _NDPP    ]:cText( ( dbfPedCliT )->nDpp    )
   aGet[ _CDTOUNO ]:cText( ( dbfPedCLiT )->cDtoUno )
   aGet[ _NDTOUNO ]:cText( ( dbfPedCLiT )->nDtoUno )
   aGet[ _CDTODOS ]:cText( ( dbfPedCLiT )->cDtoDos )
   aGet[ _NDTODOS ]:cText( ( dbfPedCLiT )->nDtoDos )
   aGet[ _CMANOBR ]:cText( ( dbfPedCliT )->cManObr )
   aGet[ _NIVAMAN ]:cText( ( dbfPedCliT )->nIvaMan )
   aGet[ _NMANOBR ]:cText( ( dbfPedCliT )->nManObr )
   aGet[ _NBULTOS ]:cText( ( dbfPedCliT )->nBultos )

   aTmp[ _CSUPED ]                := ( dbfPedCliT )->cSuPed

   /*
   Código de grupo-----------------------------------------------------
   */

   aTmp[ _CCODGRP ]               := ( dbfPedCliT )->cCodGrp
   aTmp[ _LMODCLI ]               := ( dbfPedCliT )->lModCli
   aTmp[ _LOPERPV ]               := ( dbfPedCliT )->lOperPv

   /*
   Datos de alquileres---------------------------------------------------
   */

   aTmp[ _LALQUILER ]            := ( dbfPedCliT )->lAlquiler
   aTmp[ _DFECENTR  ]            := ( dbfPedCliT )->dFecEntr
   aTmp[ _DFECSAL   ]            := ( dbfPedCliT )->dFecSal

   if !empty( oTipAlb )
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
         cDesAlb                 := Rtrim( cNumPed() ) + Space( 1 ) + ( dbfPedCliT )->cSerPed + "/" + AllTrim( Str( ( dbfPedCliT )->nNumPed ) ) + "/" + ( dbfPedCliT )->cSufPed
         cDesAlb                 += " - Fecha " + Dtoc( ( dbfPedCliT )->dFecPed )
         (dbfTmpLin)->cDetalle   := cDesAlb  
         (dbfTmpLin)->lControl   := .t.
      end if

      while ( ( dbfPedCliL )->cSerPed + Str( ( dbfPedCliL )->nNumPed ) + ( dbfPedCliL )->cSufPed == cPedido )

         nTotRet                 := nTotNPedCli( dbfPedCliL )
         nTotRet                 -= nUnidadesRecibidasAlbaranesClientes( cPedido, ( dbfPedCliL )->cRef, ( dbfPedCliL )->cValPr1, ( dbfPedCliL )->cValPr2, D():Get( "AlbCliL", nView ) )
         nTotRet                 -= nUnidadesRecibidasFacturasClientes( cPedido, ( dbfPedCliL )->cRef, ( dbfPedCliL )->cValPr1, ( dbfPedCliL )->cValPr2, D():Get( "FacCliL", nView ) )

         //if ( nTotRet > 0 ) .or. nTotNPedCli( dbfPedCliL ) == 0 Pidió quitar esto Inma de Pepsi y Instalaciones corumbel

            (dbfTmpLin)->( dbAppend() )

            (dbfTmpLin)->nNumAlb    := 0
            (dbfTmpLin)->cNumPed    := cPedido
            (dbfTmpLin)->nNumLin    := (dbfPedCliL)->nNumLin
            (dbfTmpLin)->nPosPrint  := (dbfPedCliL)->nPosPrint
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
            (dbfTmpLin)->id_tipo_v  := (dbfPedCliL)->id_tipo_v
            (dbfTmpLin)->cAlmLin    := (dbfPedCliL)->cAlmLin
            (dbfTmpLin)->lIvaLin    := (dbfPedCliL)->lIvaLin
            (dbfTmpLin)->cCodImp    := (dbfPedCLiL)->cCodImp
            (dbfTmpLin)->nValImp    := (dbfPedCliL)->nValImp
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
            (dbfTmpLin)->lControl   := (dbfPedCliL)->lControl
            (dbfTmpLin)->lLinOfe    := (dbfPedCliL)->lLinOfe
            (dbfTmpLin)->nBultos    := (dbfPedCliL)->nBultos
            (dbfTmpLin)->cFormato   := (dbfPedCliL)->cFormato
            (dbfTmpLin)->cObrLin    := (dbfPedCliL)->cObrLin
            (dbfTmpLin)->cRefAux    := (dbfPedCliL)->cRefAux
            (dbfTmpLin)->cRefAux2   := (dbfPedCliL)->cRefAux2
            (dbfTmpLin)->cCtrCoste  := (dbfPedCliL)->cCtrCoste
            (dbfTmpLin)->cTipCtr    := (dbfPedCliL)->cTipCtr
            (dbfTmpLin)->cTerCtr    := (dbfPedCliL)->cTerCtr
            //(dbfTmpLin)->nUndKit    := (dbfPedCliL)->nNudKit

            if !( dbfPedCliL )->lKitArt

               /*
               Comprobamos si hay calculos por cajas
               */

               if lCalCaj()

                  nDiv                       := DecimalMod( nTotRet, ( dbfPedCliL )->nCanPed )
                  if nDiv == 0 .and. ( dbfPedCliL )->nCanPed != 0
                     ( dbfTmpLin )->nCanEnt  := ( dbfPedCliL )->nCanPed
                     ( dbfTmpLin )->nUniCaja := nTotRet / ( dbfPedCliL )->nCanPed
                  else
                     ( dbfTmpLin )->nCanEnt  := ( dbfPedCliL )->nCanPed
                     ( dbfTmpLin )->nUniCaja := nTotRet
                  end if

               else

                  ( dbfTmpLin )->nCanEnt     := ( dbfPedCliL )->nCanPed
                  ( dbfTmpLin )->nUniCaja    := nTotRet

               end if

            else

               ( dbfTmpLin )->nCanEnt        := ( dbfPedCliL )->nCanPed
               ( dbfTmpLin )->nUniCaja       := ( dbfPedCliL )->nUniCaja

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

               ( dbfTmpPgo )->nNumRec     := ( dbfTmpPgo )->( Recno() )
               ( dbfTmpPgo )->cCodCaj     := ( dbfPedCliP )->cCodCaj
               ( dbfTmpPgo )->cTurRec     := ( dbfPedCliP )->cTurRec
               ( dbfTmpPgo )->cCodCli     := ( dbfPedCliP )->cCodCli
               ( dbfTmpPgo )->dEntrega    := ( dbfPedCliP )->dEntrega
               ( dbfTmpPgo )->nImporte    := ( dbfPedCliP )->nImporte
               ( dbfTmpPgo )->cDescrip    := ( dbfPedCliP )->cDesCrip
               ( dbfTmpPgo )->cPgdoPor    := ( dbfPedCliP )->cPgdoPor
               ( dbfTmpPgo )->cDocPgo     := ( dbfPedCliP )->cDocPgo
               ( dbfTmpPgo )->cDivPgo     := ( dbfPedCliP )->cDivPgo
               ( dbfTmpPgo )->nVdvPgo     := ( dbfPedCliP )->nVdvPgo
               ( dbfTmpPgo )->cCodAge     := ( dbfPedCliP )->cCodAge
               ( dbfTmpPgo )->cCodPgo     := ( dbfPedCliP )->cCodPgo
               ( dbfTmpPgo )->cBncEmp     := ( dbfPedCliP )->cBncEmp
               ( dbfTmpPgo )->cBncCli     := ( dbfPedCliP )->cBncCli
               ( dbfTmpPgo )->cEPaisIBAN  := ( dbfPedCliP )->cEPaisIBAN
               ( dbfTmpPgo )->cECtrlIBAN  := ( dbfPedCliP )->cECtrlIBAN
               ( dbfTmpPgo )->cEntEmp     := ( dbfPedCliP )->cEntEmp
               ( dbfTmpPgo )->cSucEmp     := ( dbfPedCliP )->cSucEmp
               ( dbfTmpPgo )->cDigEmp     := ( dbfPedCliP )->cDigEmp
               ( dbfTmpPgo )->cCtaEmp     := ( dbfPedCliP )->cCtaEmp
               ( dbfTmpPgo )->cPaisIBAN   := ( dbfPedCliP )->cPaisIBAN
               ( dbfTmpPgo )->cCtrlIBAN   := ( dbfPedCliP )->cCtrlIBAN
               ( dbfTmpPgo )->cEntCli     := ( dbfPedCliP )->cEntCli
               ( dbfTmpPgo )->cSucCli     := ( dbfPedCliP )->cSucCli
               ( dbfTmpPgo )->cDigCli     := ( dbfPedCliP )->cDigCli
               ( dbfTmpPgo )->cCtaCli     := ( dbfPedCliP )->cCtaCli
               ( dbfTmpPgo )->lCloPgo     := .f.
               ( dbfTmpPgo )->cNumRec     := ( dbfPedCliP )->cSerPed + Str( ( dbfPedCliP )->nNumPed ) + ( dbfPedCliP )->cSufPed + Str( ( dbfPedCliP )->nNumRec )

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

   aGet[ _CNUMPED ]:Disable()

   CursorWE()

RETURN lValid

//---------------------------------------------------------------------------//

STATIC FUNCTION SelSend( oBrw )

   local oDlg
   local oFecEnv
   local dFecEnv  := GetSysDate()

   if SQLAjustableModel():getRolNoAlbaranEntregado( Auth():rolUuid() )
      msgStop( "Sin autorización para cambio de entrega." )
      RETURN ( nil )
   end if 

   if dbDialogLock( D():Get( "AlbCliT", nView ) )

      if ( D():Get( "AlbCliT", nView ) )->lEntregado

         ( D():Get( "AlbCliT", nView ) )->lEntregado := !( D():Get( "AlbCliT", nView ) )->lEntregado
         ( D():Get( "AlbCliT", nView ) )->dFecEnv    := Ctod( "" )

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
               ACTION   (  ( D():Get( "AlbCliT", nView ) )->lEntregado := !( D():Get( "AlbCliT", nView ) )->lEntregado ,;
                           ( D():Get( "AlbCliT", nView ) )->dFecEnv    := dFecEnv ,;
                           ( D():Get( "AlbCliT", nView ) )->lSndDoc    := .t. ,;
                           oDlg:end() )

            REDEFINE BUTTON ;
               ID       502 ;
               OF       oDlg ;
               ACTION   ( oDlg:end() )

         oDlg:AddFastKey( VK_F5, {|| ( D():Get( "AlbCliT", nView ) )->lEntregado := !( D():Get( "AlbCliT", nView ) )->lEntregado , ( D():Get( "AlbCliT", nView ) )->dFecEnv    := dFecEnv , ( D():Get( "AlbCliT", nView ) )->lSndDoc    := .t. , oDlg:end() } )

         oDlg:bStart := { || oFecEnv:SetFocus() }

         ACTIVATE DIALOG oDlg CENTER

      end if

   ( D():Get( "AlbCliT", nView ) )->( dbUnLock() )

   end if

   oBrw:Refresh()
   oBrw:SetFocus()

RETURN NIL

//-------------------------------------------------------------------------//
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
   local nPosPrint
   local lCodAge     := .f.
   local nOffSet     := 0
   local cDesAlb     := ""
   local cCodCli     := aGet[ _CCODCLI ]:varGet()
   local nTotPed
   local nTotRec
   local nTotPdt
   local lAlquiler   := .f.
   local cCliente    := RTrim( aTmp[ _CNOMCLI ] )
   local cObra       := if( empty( aTmp[ _CCODOBR ] ), "Todas", Rtrim( aTmp[ _CCODOBR ] ) )  
   local cIva        := cImp() + Space( 1 ) + if( aTmp[ _LIVAINC ], "Incluido", "Desglosado" )

   aPedidos          := {}

   if empty( cCodCli )
      msgStop( "Es necesario codificar un cliente", "Agrupar pedidos" )
      return .t.
   end if

   if !empty( aGet[ _CNUMPED ]:VarGet() )
      msgStop( "Ya ha importado un pedido", "Agrupar pedidos" )
      return .t.
   end if

   if !empty( oTipAlb ) .and. oTipAlb:nAt == 2
      lAlquiler      := .t.
   end if

   /*
   Seleccion de Registros
   --------------------------------------------------------------------------
   */

   nOrdAnt           := ( dbfPedCliT )->( ordSetFocus( "cCodCli" ) )

   if ( dbfPedCliT )->( dbSeek( cCodCli ) )

      while ( dbfPedCliT )->cCodCli == cCodCli .and. ( dbfPedCliT )->( !eof() )

         if ( dbfPedCliT )->lAlquiler == lAlquiler                                              .and.;
            ( dbfPedCliT )->nEstado != 3                                                        .and.;
            ( dbfPedCliT )->lIvaInc == aTmp[ _LIVAINC ]                                         .and.;
            if( empty( aTmp[ _CCODOBR ] ), .t., ( dbfPedCliT )->cCodObr == aTmp[ _CCODOBR ] )   .and.;
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

      oBrwLin                       := IXBrowse():New( oDlg )

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
         :SetCheck( { "gc_shape_square_12", "gc_delete_12" } )
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader          := "Número"
         :bEditValue       := {|| aPedidos[ oBrwLin:nArrayAt, 3 ] }
         :cEditPicture     := "@R A/XXXXXXXXX/XX"
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
         :cHeader          := "Dirección"
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

   if oDlg:nResult == IDOK .and. Len( aPedidos ) >= 1

      CursorWait()

      HideImportacion( aGet )

      /*
      Aadimos los albaranes seleccionado para despues-------------------------
      */

      for nItem := 1 to Len( aPedidos )

         if ( aPedidos[ nItem, 1 ] )

            aAdd( aNumPed, aPedidos[ nItem, 3 ] )

            if empty( cCodAge )
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

         if ( dbfPedCliT )->( dbSeek( aPedidos[ nItem, 3 ] ) ) .and. aPedidos[ nItem, 1 ]

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

         if ( dbfPedCliL )->( dbSeek( aPedidos[ nItem, 3] ) ) .and. aPedidos[ nItem, 1]

            /*
            Cabeceras de pedidos-----------------------------------------------
            */

            nNumLin                    := nil
            nPosPrint                  := nil

            if lNumPed()
               (dbfTmpLin)->( dbAppend() )
               cDesAlb                 := Rtrim( cNumPed() )
               cDesAlb                 += " Pedido Nº " + Alltrim( Trans( aPedidos[ nItem, 3 ], "@R A/XXXXXXXXX/XX" ) )
               cDesAlb                 += " - Fecha " + Dtoc( aPedidos[ nItem, 4] )
               (dbfTmpLin)->mLngDes    := cDesAlb
               (dbfTmpLin)->lControl   := .t.
               (dbfTmpLin)->nNumLin    := ++nOffSet
               (dbfTmpLin)->nPosPrint  := nOffSet
            end if

            /*
            Mientras estemos en el mismo pedido--------------------------------
            */

            while ( dbfPedCliL )->cSerPed + Str( ( dbfPedCliL )->nNumPed ) + ( dbfPedCliL )->cSufPed == aPedidos[ nItem, 3]

               if aPedidos[ nItem, 2 ] == 2

                  nTotPed              := nTotNPedCli( dbfPedCliL )
                  nTotRec              := nUnidadesRecibidasAlbaranesClientes( aPedidos[ nItem, 3 ], ( dbfPedCliL )->cRef, ( dbfPedCliL )->cValPr1, ( dbfPedCliL )->cValPr2, D():Get( "AlbCliL", nView ) )
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
                     (dbfTmpLin)->nPosPrint  := nOffSet
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
                     (dbfTmpLin)->id_tipo_v  := (dbfPedCliL)->id_tipo_v
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
                     (dbfTmpLin)->lMsgVta    := (dbfPedCliL)->lMsgVta
                     (dbfTmpLin)->lNotVta    := (dbfPedCliL)->lNotVta
                     (dbfTmpLin)->lLote      := (dbfPedCliL)->lLote
                     (dbfTmpLin)->nLote      := (dbfPedCliL)->nLote
                     (dbfTmpLin)->cLote      := (dbfPedCliL)->cLote
                     (dbfTmpLin)->mObsLin    := (dbfPedCliL)->mObsLin
                     (dbfTmpLin)->Descrip    := (dbfPedCliL)->Descrip
                     (dbfTmpLin)->cCodPrv    := (dbfPedCliL)->cCodPrv
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
                     (dbfTmpLin)->cObrLin    := (dbfPedCliL)->cObrLin
                     (dbfTmpLin)->cRefAux    := (dbfPedCliL)->cRefAux
                     (dbfTmpLin)->cRefAux2   := (dbfPedCliL)->cRefAux2
                     (dbfTmpLin)->cCtrCoste  := (dbfPedCliL)->cCtrCoste
                     (dbfTmpLin)->cTipCtr    := (dbfPedCliL)->cTipCtr
                     (dbfTmpLin)->cTerCtr    := (dbfPedCliL)->cTerCtr
                     //(dbfTmpLin)->nNumKit    := (dbfPedCliL)->nNumKit

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
                  ( dbfTmpLin )->nPosPrint   := nOffSet
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
                  ( dbfTmpLin )->id_tipo_v   := ( dbfPedCliL )->id_tipo_v
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
                  ( dbfTmpLin )->lMsgVta     := ( dbfPedCliL )->lMsgVta
                  ( dbfTmpLin )->lNotVta     := ( dbfPedCliL )->lNotVta
                  ( dbfTmpLin )->lLote       := ( dbfPedCliL )->lLote
                  ( dbfTmpLin )->nLote       := ( dbfPedCliL )->nLote
                  ( dbfTmpLin )->cLote       := ( dbfPedCliL )->cLote
                  ( dbfTmpLin )->mObsLin     := ( dbfPedCliL )->mObsLin
                  ( dbfTmpLin )->Descrip     := ( dbfPedCliL )->Descrip
                  ( dbfTmpLin )->cCodPrv     := ( dbfPedCliL )->cCodPrv
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
                  ( dbfTmpLin )->cObrLin     := ( dbfPedCliL )->cObrLin
                  ( dbfTmpLin )->cRefAux     := ( dbfPedCliL )->cRefAux
                  ( dbfTmpLin )->cRefAux2    := ( dbfPedCliL )->cRefAux2
                  ( dbfTmpLin )->cCtrCoste   := ( dbfPedCliL )->cCtrCoste
                  ( dbfTmpLin )->cTipCtr     := ( dbfPedCliL )->cTipCtr
                  ( dbfTmpLin )->cTerCtr     := ( dbfPedCliL )->cTerCtr
                  //( dbfTmpLin )->nNumKit     := ( dbfPedCliL )->nNumKit
                  ( dbfTmpLin )->nBultos     := ( dbfPedCliL )->nBultos

               end if

               ( dbfPedCliL )->( dbSkip( 1 ) )

            end while

            ( dbfTmpLin )->( dbGoTop() )

            /*
            Pasamos las entregas a cuenta--------------------------------------
            */

            if ( dbfPedCliP )->( dbSeek( aPedidos[ nItem, 3 ] ) ) .and. aPedidos[ nItem, 1 ]

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

Static Function RecAlbCli( aTmpAlb, oDlg )

   local nDtoAge
   local nRecno
   local cCodFam
   local nImpAtp  := 0
   local nImpOfe  := 0
   local hAtipica

   if !ApoloMsgNoYes( "¡Atención!,"                                      + CRLF + ;
                  "todos los precios se recalcularán en función de"  + CRLF + ;
                  "los valores en las bases de datos.",;
                  "¿ Desea proceder ?" )
      return nil
   end if

   oDlg:aEvalWhen()

   ( D():Articulos( nView ) )->( ordSetFocus( "Codigo" ) )

   nRecno         := ( dbfTmpLin )->( RecNo() )

   ( dbfTmpLin )->( dbGotop() )
   while !( dbfTmpLin )->( eof() )

      /*
      Ahora buscamos por el codigo interno
      */

      if ( D():Articulos( nView ) )->( dbSeek( ( dbfTmpLin )->cRef ) )

         do case
            case aTmpAlb[ _NREGIVA ] <= 2
               ( dbfTmpLin )->nIva     := nIva( D():Get( "TIva", nView ), ( D():Articulos( nView ) )->TipoIva )
               ( dbfTmpLin )->nReq     := nReq( D():Get( "TIva", nView ), ( D():Articulos( nView ) )->TipoIva )
            case aTmpAlb[ _NREGIVA ] == 3
               ( dbfTmpLin )->nIva     := 0
               ( dbfTmpLin )->nReq     := 0
         end case

         /*
         Ahora recogemos el impuesto especial si lo hay
         */

         if !empty( ( D():Articulos( nView ) )->cCodImp )
            ( dbfTmpLin )->cCodImp  := ( D():Articulos( nView ) )->cCodImp
            ( dbfTmpLin )->nValImp  := oNewImp:nValImp( ( D():Articulos( nView ) )->cCodImp, aTmpAlb[ _LIVAINC ], ( dbfTmpLin )->nIva )
         end if

         /*
         Tomamos los precios de la base de datos de articulos---------------------
         */

         ( dbfTmpLin )->nPreUnit    := nRetPreArt( ( dbfTmpLin )->nTarLin, aTmpAlb[ _CDIVALB ], aTmpAlb[ _LIVAINC ], D():Articulos( nView ), D():Get( "Divisas", nView ), dbfKit, D():Get( "TIva", nView ), , , oNewImp )

         /*
         Linea por contadores-----------------------------------------------------
         */

         ( dbfTmpLin )->nCtlStk     := ( D():Articulos( nView ) )->nCtlStock
         ( dbfTmpLin )->nPvpRec     := ( D():Articulos( nView ) )->PvpRec
         ( dbfTmpLin )->nCosDiv     := nCosto( nil, D():Articulos( nView ), dbfKit )

         /*
         Punto verde--------------------------------------------------------------
         */

         ( dbfTmpLin )->nPntVer     := ( D():Articulos( nView ) )->nPntVer1

         /*
         Chequeamos situaciones especiales y comprobamos las fechas
         */

         do case

         case !empty( aTmpAlb[ _CCODTAR ] )

            cCodFam  := RetFamArt( ( dbfTmpLin )->cRef, D():Articulos( nView ) )

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
         Buscamos si existen atipicas de clientes------------------------------
         */

         hAtipica := hAtipica( hValue( dbfTmpLin, aTmpAlb ) )

         if !empty( hAtipica )
               
            if hhaskey( hAtipica, "nImporte" )
               if hAtipica[ "nImporte" ] != 0
                  ( dbfTmpLin )->nPreUnit := hAtipica[ "nImporte" ]
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

         nImpOfe     := nImpOferta( ( dbfTmpLin )->cRef, aTmpAlb[ _CCODCLI ], aTmpAlb[ _CCODGRP ], ( dbfTmpLin )->nUniCaja, aTmpAlb[ _DFECALB ], dbfOferta, ( dbfTmpLin )->nTarLin, nil, ( dbfTmpLin )->cCodPr1, ( dbfTmpLin )->cCodPr2, ( dbfTmpLin )->cValPr1, ( dbfTmpLin )->cValPr2 )
         if nImpOfe  != 0
            ( dbfTmpLin )->nPreUnit := nCnv2Div( nImpOfe, cDivEmp(), aTmpAlb[ _CDIVALB ] )
         end if

         /*
         Buscamos si existen descuentos en las ofertas
         */

         /*nImpOfe     := nDtoOferta( ( dbfTmpLin )->cRef, aTmpAlb[ _CCODCLI ], aTmpAlb[ _CCODGRP ], ( dbfTmpLin )->nUniCaja, aTmpAlb[ _DFECALB ], dbfOferta, ( dbfTmpLin )->cCodPr1, ( dbfTmpLin )->cCodPr2, ( dbfTmpLin )->cValPr1, ( dbfTmpLin )->cValPr2 )
         if nImpOfe  != 0
            ( dbfTmpLin )->nDtoPrm  := nImpOfe
         end if*/

      end if

      ( dbfTmpLin )->( dbSkip() )

   end while

   ( dbfTmpLin )->( dbGoTo( nRecno ) )

return nil

//--------------------------------------------------------------------------//

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

   DEFAULT aTmpAlb   := dbScatter( D():Get( "AlbCliT", nView ) )

   do case
      case nMode == APPD_MODE

         aTmp[ ( dbfTmpPgo )->( FieldPos( "cTurRec" ) ) ]      := cCurSesion()
         aTmp[ ( dbfTmpPgo )->( FieldPos( "cCodCaj" ) ) ]      := Application():CodigoCaja()

         aTmp[ ( dbfTmpPgo )->( FieldPos( "cSerAlb" ) ) ]      := aTmpAlb[ _CSERALB ]
         aTmp[ ( dbfTmpPgo )->( FieldPos( "nNumAlb" ) ) ]      := aTmpAlb[ _NNUMALB ]
         aTmp[ ( dbfTmpPgo )->( FieldPos( "cSufAlb" ) ) ]      := aTmpAlb[ _CSUFALB ]
         aTmp[ ( dbfTmpPgo )->( FieldPos( "cCodCli" ) ) ]      := aTmpAlb[ _CCODCLI ]
         aTmp[ ( dbfTmpPgo )->( FieldPos( "cCodAge" ) ) ]      := aTmpAlb[ _CCODAGE ]
         aTmp[ ( dbfTmpPgo )->( FieldPos( "cDivPgo" ) ) ]      := aTmpAlb[ _CDIVALB ]
         aTmp[ ( dbfTmpPgo )->( FieldPos( "cCodPgo" ) ) ]      := aTmpAlb[ _CCODPAGO]

         if dbSeekInOrd( aTmpAlb[ _CCODPAGO ], "cCodPago", D():Get( "FPago", nView ) ) .and. ( D():Get( "FPago", nView ) )->lUtlBnc

            aTmp[ ( dbfTmpPgo )->( FieldPos( "cBncEmp" ) ) ]      := ( D():Get( "FPago", nView ) )->cBanco
            aTmp[ ( dbfTmpPgo )->( FieldPos( "cEPaisIBAN" ) ) ]   := ( D():Get( "FPago", nView ) )->cPaisIBAN
            aTmp[ ( dbfTmpPgo )->( FieldPos( "cECtrlIBAN" ) ) ]   := ( D():Get( "FPago", nView ) )->cCtrlIBAN
            aTmp[ ( dbfTmpPgo )->( FieldPos( "cEntEmp" ) ) ]      := ( D():Get( "FPago", nView ) )->cEntBnc
            aTmp[ ( dbfTmpPgo )->( FieldPos( "cSucEmp" ) ) ]      := ( D():Get( "FPago", nView ) )->cSucBnc
            aTmp[ ( dbfTmpPgo )->( FieldPos( "cDigEmp" ) ) ]      := ( D():Get( "FPago", nView ) )->cDigBnc
            aTmp[ ( dbfTmpPgo )->( FieldPos( "cCtaEmp" ) ) ]      := ( D():Get( "FPago", nView ) )->cCtaBnc

            aTmp[ ( dbfTmpPgo )->( FieldPos( "cBncCli" ) ) ]      := aTmpAlb[ _CBANCO  ]
            aTmp[ ( dbfTmpPgo )->( FieldPos( "cPaisIBAN" ) ) ]    := aTmpAlb[ _CPAISIBAN ]
            aTmp[ ( dbfTmpPgo )->( FieldPos( "cCtrlIBAN" ) ) ]    := aTmpAlb[ _CCTRLIBAN ]
            aTmp[ ( dbfTmpPgo )->( FieldPos( "cEntCli" ) ) ]      := aTmpAlb[ _CENTBNC ]
            aTmp[ ( dbfTmpPgo )->( FieldPos( "cSucCli" ) ) ]      := aTmpAlb[ _CSUCBNC ]
            aTmp[ ( dbfTmpPgo )->( FieldPos( "cDigCli" ) ) ]      := aTmpAlb[ _CDIGBNC ]
            aTmp[ ( dbfTmpPgo )->( FieldPos( "cCtaCli" ) ) ]      := aTmpAlb[ _CCTABNC ]

         end if

      case nMode == EDIT_MODE

         if aTmp[ ( dbfTmpPgo )->( FieldPos( "lCloPgo" ) ) ] .and. !oUser():lAdministrador()
            msgStop( "Solo pueden modificar las entregas cerradas los administradores." )
            return .f.
         end if

   end case

   cGetCli           := RetFld( aTmp[ ( dbfTmpPgo )->( FieldPos( "cCodCli" ) ) ], D():Get( "Client", nView ), "Titulo" )
   cGetAge           := cNbrAgent( aTmp[ ( dbfTmpPgo )->( FieldPos( "cCodAge" ) ) ], dbfAgent )
   cGetCaj           := RetFld( aTmp[ ( dbfTmpPgo )->( FieldPos( "cCodCaj" ) ) ], dbfCajT, "cNomCaj" )
   cPorDiv           := cPorDiv(aTmp[ ( dbfTmpPgo )->( FieldPos( "cDivPgo" ) ) ], D():Get( "Divisas", nView ) )
   cFPago            := RetFld( aTmp[ ( dbfTmpPgo )->( FieldPos( "cCodPgo" ) ) ], D():Get( "FPago", nView ) )

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
         VALID    ( cDivOut( aGet[ ( dbfTmpPgo )->( FieldPos( "cDivPgo" ) ) ], oBmpDiv, aGet[ ( dbfTmpPgo )->( FieldPos( "nVdvPgo" ) ) ], nil, nil, @cPorDiv, nil, nil, nil, nil, D():Get( "Divisas", nView ), oBandera ) );
         PICTURE  "@!";
         ID       150 ;
         BITMAP   "LUPA" ;
         ON HELP  BrwDiv( aGet[ ( dbfTmpPgo )->( FieldPos( "cDivPgo" ) ) ], oBmpDiv, aGet[ ( dbfTmpPgo )->( FieldPos( "nVdvPgo" ) ) ], D():Get( "Divisas", nView ), oBandera ) ;
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
         VALID    ( cFPago( aGet[ ( dbfTmpPgo )->( FieldPos( "cCodPgo" ) ) ], D():Get( "FPago", nView ), oFpago ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwFPago( aGet[ ( dbfTmpPgo )->( FieldPos( "cCodPgo" ) ) ], oFpago ) ) ;
         OF       oFld:aDialogs[ 1 ]

      REDEFINE GET oFpago VAR cFpago ;
         ID       181 ;
         WHEN     .F. ;
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
         VALID    ( cClient( aGet[ ( dbfTmpPgo )->( FieldPos( "cCodCli" ) ) ], D():Get( "Client", nView ), oGetCli ) ) ;
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
         WHEN     ( nMode != ZOOM_MODE ) ;
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
         WHEN     ( nMode != ZOOM_MODE ) ;
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
         VALID    (  lCalcDC( aTmp[ ( dbfTmpPgo )->( FieldPos( "CENTEMP" ) ) ], aTmp[ ( dbfTmpPgo )->( FieldPos( "CSUCEMP" ) ) ], aTmp[ ( dbfTmpPgo )->( FieldPos( "CDIGEMP" ) ) ], aTmp[ ( dbfTmpPgo )->( FieldPos( "CCTAEMP" ) ) ], aGet[ ( dbfTmpPgo )->( FieldPos( "CDIGEMP" ) ) ] ),;
                     aGet[ ( dbfTmpPgo )->( FieldPos( "cEPaisIBAN" ) ) ]:lValid() ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ ( dbfTmpPgo )->( FieldPos( "CSUCEMP" ) ) ] VAR aTmp[ ( dbfTmpPgo )->( FieldPos( "CSUCEMP" ) ) ];
         ID       120 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    (  lCalcDC( aTmp[ ( dbfTmpPgo )->( FieldPos( "CENTEMP" ) ) ], aTmp[ ( dbfTmpPgo )->( FieldPos( "CSUCEMP" ) ) ], aTmp[ ( dbfTmpPgo )->( FieldPos( "CDIGEMP" ) ) ], aTmp[ ( dbfTmpPgo )->( FieldPos( "CCTAEMP" ) ) ], aGet[ ( dbfTmpPgo )->( FieldPos( "CDIGEMP" ) ) ] ),;
                     aGet[ ( dbfTmpPgo )->( FieldPos( "cEPaisIBAN" ) ) ]:lValid() ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ ( dbfTmpPgo )->( FieldPos( "CDIGEMP" ) ) ] VAR aTmp[ ( dbfTmpPgo )->( FieldPos( "CDIGEMP" ) ) ];
         ID       130 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    (  lCalcDC( aTmp[ ( dbfTmpPgo )->( FieldPos( "CENTEMP" ) ) ], aTmp[ ( dbfTmpPgo )->( FieldPos( "CSUCEMP" ) ) ], aTmp[ ( dbfTmpPgo )->( FieldPos( "CDIGEMP" ) ) ], aTmp[ ( dbfTmpPgo )->( FieldPos( "CCTAEMP" ) ) ], aGet[ ( dbfTmpPgo )->( FieldPos( "CDIGEMP" ) ) ] ),;
                     aGet[ ( dbfTmpPgo )->( FieldPos( "cEPaisIBAN" ) ) ]:lValid() ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ ( dbfTmpPgo )->( FieldPos( "CCTAEMP" ) ) ] VAR aTmp[ ( dbfTmpPgo )->( FieldPos( "CCTAEMP" ) ) ];
         ID       140 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    (  lCalcDC( aTmp[ ( dbfTmpPgo )->( FieldPos( "CENTEMP" ) ) ], aTmp[ ( dbfTmpPgo )->( FieldPos( "CSUCEMP" ) ) ], aTmp[ ( dbfTmpPgo )->( FieldPos( "CDIGEMP" ) ) ], aTmp[ ( dbfTmpPgo )->( FieldPos( "CCTAEMP" ) ) ], aGet[ ( dbfTmpPgo )->( FieldPos( "CDIGEMP" ) ) ] ),;
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
         VALID    (  lCalcDC( aTmp[ ( dbfTmpPgo )->( FieldPos( "CENTCLI" ) ) ], aTmp[ ( dbfTmpPgo )->( FieldPos( "CSUCCLI" ) ) ], aTmp[ ( dbfTmpPgo )->( FieldPos( "CDIGCLI" ) ) ], aTmp[ ( dbfTmpPgo )->( FieldPos( "CCTACLI" ) ) ], aGet[ ( dbfTmpPgo )->( FieldPos( "CDIGCLI" ) ) ] ),;
                     aGet[ ( dbfTmpPgo )->( FieldPos( "cPaisIBAN" ) ) ]:lValid() ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ ( dbfTmpPgo )->( FieldPos( "CSUCCLI" ) ) ] VAR aTmp[ ( dbfTmpPgo )->( FieldPos( "CSUCCLI" ) ) ];
         ID       220 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    (  lCalcDC( aTmp[ ( dbfTmpPgo )->( FieldPos( "CENTCLI" ) ) ], aTmp[ ( dbfTmpPgo )->( FieldPos( "CSUCCLI" ) ) ], aTmp[ ( dbfTmpPgo )->( FieldPos( "CDIGCLI" ) ) ], aTmp[ ( dbfTmpPgo )->( FieldPos( "CCTACLI" ) ) ], aGet[ ( dbfTmpPgo )->( FieldPos( "CDIGCLI" ) ) ] ),;
                     aGet[ ( dbfTmpPgo )->( FieldPos( "cPaisIBAN" ) ) ]:lValid() ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ ( dbfTmpPgo )->( FieldPos( "CDIGCLI" ) ) ] VAR aTmp[ ( dbfTmpPgo )->( FieldPos( "CDIGCLI" ) ) ];
         ID       230 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    (  lCalcDC( aTmp[ ( dbfTmpPgo )->( FieldPos( "CENTCLI" ) ) ], aTmp[ ( dbfTmpPgo )->( FieldPos( "CSUCCLI" ) ) ], aTmp[ ( dbfTmpPgo )->( FieldPos( "CDIGCLI" ) ) ], aTmp[ ( dbfTmpPgo )->( FieldPos( "CCTACLI" ) ) ], aGet[ ( dbfTmpPgo )->( FieldPos( "CDIGCLI" ) ) ] ),;
                     aGet[ ( dbfTmpPgo )->( FieldPos( "cPaisIBAN" ) ) ]:lValid() ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ ( dbfTmpPgo )->( FieldPos( "CCTACLI" ) ) ] VAR aTmp[ ( dbfTmpPgo )->( FieldPos( "CCTACLI" ) ) ];
         ID       240 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    (  lCalcDC( aTmp[ ( dbfTmpPgo )->( FieldPos( "CENTCLI" ) ) ], aTmp[ ( dbfTmpPgo )->( FieldPos( "CSUCCLI" ) ) ], aTmp[ ( dbfTmpPgo )->( FieldPos( "CDIGCLI" ) ) ], aTmp[ ( dbfTmpPgo )->( FieldPos( "CCTACLI" ) ) ], aGet[ ( dbfTmpPgo )->( FieldPos( "CDIGCLI" ) ) ] ),;
                     aGet[ ( dbfTmpPgo )->( FieldPos( "cPaisIBAN" ) ) ]:lValid() ) ;
         OF       oFld:aDialogs[2]

      //Botones

      REDEFINE BUTTON ;
         ID       IDOK ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( ValidEdtEnt( aTmp, aGet, oBrw, oDlg, nMode, dbfTmpPgo ) )

      REDEFINE BUTTON ;
         ID       IDCANCEL ;
         OF       oDlg ;
         CANCEL ;
         ACTION   ( oDlg:End() )

   oDlg:bStart    := {|| aGet[ ( dbfTmpPgo )->( FieldPos( "nImporte" ) ) ]:SetFocus() }

   if nMode != ZOOM_MODE
      oDlg:AddFastKey( VK_F5, {|| ValidEdtEnt( aTmp, aGet, oBrw, oDlg, nMode, dbfTmpPgo ) } )
   end if

   ACTIVATE DIALOG oDlg CENTER;
      ON INIT ( CreateMenuEntrega( aTmp, oDlg ) )

   if !empty( oMenu )
      oMenu:End()
   end if

   if !empty( oBmpDiv )
      oBmpDiv:End()
   end if

   if !empty( oBmp )
      oBmp:End()
   end if

   if !empty( oBmpBancos )
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
               RESOURCE "gc_user_16" ;
               ACTION   ( if( !empty( aTmp[ ( dbfTmpPgo )->( FieldPos( "cCodCli" ) ) ] ), EdtCli( aTmp[ ( dbfTmpPgo )->( FieldPos( "cCodCli" ) ) ] ), MsgStop( "Código de cliente vacío" ) ) )

            MENUITEM    "&3. Informe de cliente";
               MESSAGE  "Informe de cliente" ;
               RESOURCE "Info16" ;
               ACTION   ( if( !empty( aTmp[ ( dbfTmpPgo )->( FieldPos( "cCodCli" ) ) ] ), InfCliente( aTmp[ ( dbfTmpPgo )->( FieldPos( "cCodCli" ) ) ] ), MsgStop( "Código de cliente vacío" ) ) );

         ENDMENU

   ENDMENU

   oDlg:SetMenu( oMenu )

RETURN ( oMenu )

//--------------------------------------------------------------------------//

CLASS TAlbaranesClientesSenderReciver FROM TSenderReciverItem

   METHOD CreateData()

   METHOD RestoreData()

   METHOD SendData()

   METHOD ReciveData()

   METHOD Process()

   METHOD validateRecepcion()

END CLASS

//----------------------------------------------------------------------------//

METHOD CreateData()

   local oBlock
   local oError
   local lSnd        := .f.
   local nOrd
   local cAlbCliT
   local cAlbCliL
   local cAlbCliI
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

   USE ( cPatEmp() + "AlbCLIT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "AlbCLIT", @cAlbCliT ) )
   SET ADSINDEX TO ( cPatEmp() + "AlbCLIT.CDX" ) ADDITIVE

   USE ( cPatEmp() + "AlbCLIL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "AlbCLIL", @cAlbCliL ) )
   SET ADSINDEX TO ( cPatEmp() + "AlbCLIL.CDX" ) ADDITIVE

   USE ( cPatEmp() + "AlbCliI.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "AlbCliI", @cAlbCliI ) )
   SET ADSINDEX TO ( cPatEmp() + "AlbCliI.CDX" ) ADDITIVE

   /*
   Creamos todas las bases de datos relacionadas con Articulos
   */

   mkAlbCli( cPatSnd() )

   USE ( cPatSnd() + "AlbCliT.DBF" ) NEW VIA ( cLocalDriver() ) SHARED ALIAS ( cCheckArea( "AlbCliT", @tmpAlbCliT ) )
   SET INDEX TO ( cPatSnd() + "AlbCliT.CDX" ) ADDITIVE

   USE ( cPatSnd() + "AlbCliL.DBF" ) NEW VIA ( cLocalDriver() ) SHARED ALIAS ( cCheckArea( "AlbCliL", @tmpAlbCliL ) )
   SET INDEX TO ( cPatSnd() + "AlbCliL.CDX" ) ADDITIVE

   USE ( cPatSnd() + "AlbCliI.DBF" ) NEW VIA ( cLocalDriver() ) SHARED ALIAS ( cCheckArea( "AlbCliI", @tmpAlbCliI ) )
   SET INDEX TO ( cPatSnd() + "AlbCliI.CDX" ) ADDITIVE

   if !empty( ::oSender:oMtr )
      ::oSender:oMtr:nTotal := ( cAlbCliT )->( LastRec() )
   end if

   nOrd  := ( cAlbCliT )->( OrdSetFocus( "lSndDoc" ) )

   if ( cAlbCliT )->( dbSeek( .t. ) )

      while !( cAlbCliT )->( eof() )

         if ( lEnviarEntregados() .and. ( cAlbCliT )->lEntregado ) .or. !lEnviarEntregados()

            lSnd  := .t.

            dbPass( cAlbCliT, tmpAlbCliT, .t. )
            ::oSender:SetText( ( cAlbCliT )->cSerAlb + "/" + AllTrim( Str( ( cAlbCliT )->nNumAlb ) ) + "/" + AllTrim( ( cAlbCliT )->cSufAlb ) + "; " + Dtoc( ( cAlbCliT )->dFecAlb ) + "; " + AllTrim( ( cAlbCliT )->cCodCli ) + "; " + ( cAlbCliT )->cNomCli )

            if ( cAlbCliL )->( dbSeek( ( cAlbCliT )->cSerAlb + Str( ( cAlbCliT )->NNUMAlb ) + ( cAlbCliT )->CSUFAlb ) )
               while ( ( cAlbCliL )->cSerAlb + Str( ( cAlbCliL )->NNUMAlb ) + ( cAlbCliL )->CSUFAlb ) == ( ( cAlbCliT )->cSerAlb + Str( ( cAlbCliT )->NNUMAlb ) + ( cAlbCliT )->CSUFAlb ) .and. !( cAlbCliL )->( eof() )
                  dbPass( cAlbCliL, tmpAlbCliL, .t. )
                  ( cAlbCliL )->( dbSkip() )
               end do
            end if

            if ( cAlbCliI )->( dbSeek( ( cAlbCliT )->cSerAlb + Str( ( cAlbCliT )->nNumAlb ) + ( cAlbCliT )->cSufAlb ) )
               while ( ( cAlbCliI )->cSerAlb + Str( ( cAlbCliI )->nNumAlb ) + ( cAlbCliI )->cSufAlb ) == ( ( cAlbCliT )->cSerAlb + Str( ( cAlbCliT )->nNumAlb ) + ( cAlbCliT )->cSufAlb ) .and. !( cAlbCliI )->( eof() )
                  dbPass( cAlbCliI, tmpAlbCliI, .t. )
                  ( cAlbCliI )->( dbSkip() )
               end do
            end if

         end if

         SysRefresh()

         ( cAlbCliT )->( dbSkip() )

         if !empty( ::oSender:oMtr )
            ::oSender:oMtr:Set( ( cAlbCliT )->( OrdKeyNo() ) )
         end if

      end do

   end if

   ( cAlbCliT )->( OrdSetFocus( nOrd ) )

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos de albaranes" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE
   ErrorBlock( oBlock )

   CLOSE ( cAlbCliT )
   CLOSE ( cAlbCliL )
   CLOSE ( cAlbCliI )
   CLOSE ( tmpAlbCliT )
   CLOSE ( tmpAlbCliL )
   CLOSE ( tmpAlbCliI )

   if lSnd

      ::oSender:SetText( "Comprimiendo albaranes de clientes" )

      if ::oSender:lZipData( cFileName )
         ::oSender:SetText( "Ficheros comprimidos en " + cFileName )
      else
         ::oSender:SetText( "ERROR al crear fichero comprimido" )
      end if

   else

      ::oSender:SetText( "No hay albaranes de clientes para enviar" )

   end if

Return ( Self )

//----------------------------------------------------------------------------//

METHOD RestoreData()

   local oBlock
   local oError
   local cAlbCliT

   /*
   Retorna el valor anterior
   */

   if ::lSuccesfullSend

      oBlock         := ErrorBlock( { | oError | ApoloBreak( oError ) } )
      BEGIN SEQUENCE

         USE ( cPatEmp() + "AlbCLIT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "AlbCLIT", @cAlbCliT ) )
         SET ADSINDEX TO ( cPatEmp() + "AlbCliT.Cdx" ) ADDITIVE

         ( cAlbCliT )->( OrdSetFocus( "lSndDoc" ) )

         while ( cAlbCliT )->( dbSeek( .t. ) ) .and. !( cAlbCliT )->( eof() )
            if dbLock( cAlbCliT )
               ( cAlbCliT )->lSndDoc := .f.
               ( cAlbCliT )->( dbRUnlock() )
            end if
         end do

      RECOVER USING oError

         msgStop( "Imposible abrir todas las bases de datos de albaranes" + CRLF + ErrorMessage( oError ) )

      END SEQUENCE
      ErrorBlock( oBlock )

      CLOSE ( cAlbCliT )

   end if

Return ( Self )

//---------------------------------------------------------------------------//

METHOD SendData()

   local cFileName

   if ::oSender:lServer
      cFileName         := "AlbCli" + StrZero( ::nGetNumberToSend(), 6 ) + ".All"
   else
      cFileName         := "AlbCli" + StrZero( ::nGetNumberToSend(), 6 ) + "." + RetSufEmp()
   end if

   /*
   Enviarlos a internet--------------------------------------------------------
   */

   if !file( cPatOut() + cFileName )
      ::oSender:SetText( "El fichero " + cPatOut() + cFileName + "no existe" )
      Return ( Self )
   end if 

   if ::oSender:SendFiles( cPatOut() + cFileName, cFileName )
      ::IncNumberToSend()
      ::lSuccesfullSend := .t.
      ::oSender:SetText( "Fichero enviado " + cFileName )
   else
      ::oSender:SetText( "ERROR al enviar fichero" + cFileName )
   end if

Return ( Self )

//---------------------------------------------------------------------------//

METHOD ReciveData()

   local n
   local aExt

   aExt     := ::oSender:aExtensions()

   /*
   Recibirlo de internet
   */

   ::oSender:SetText( "Recibiendo albaranes de clientes" )

   for n := 1 to len( aExt )
      ::oSender:GetFiles( "AlbCli*." + aExt[ n ], cPatIn() )
   next

   ::oSender:SetText( "Albaranes de clientes recibidos" )

Return Self

//----------------------------------------------------------------------------//

METHOD Process()

   local m
   local cAlbCliT
   local cAlbCliL
   local cAlbCliI
   local tmpAlbCliT
   local tmpAlbCliL
   local tmpAlbCliI
   local oBlock
   local oError
   local cNumeroAlbaran
   local aFiles            := directory( cPatIn() + "AlbCli*.*" )
   local lClient           := ::oSender:lServer

   for m := 1 to len( aFiles )

      ::oSender:SetText( "Procesando fichero : " + aFiles[ m, 1 ] )

      oBlock               := ErrorBlock( { | oError | ApoloBreak( oError ) } )
      BEGIN SEQUENCE

         if ::oSender:lUnZipData( cPatIn() + aFiles[ m, 1 ], .f. )

            /*
            Ficheros temporales
            */

            if lExistTable( cPatSnd() + "AlbCliT.DBF", cLocalDriver() )   .and.;
               lExistTable( cPatSnd() + "AlbCliL.DBF", cLocalDriver() )   .and.;
               lExistTable( cPatSnd() + "AlbCliI.DBF", cLocalDriver() )

               USE ( cPatSnd() + "AlbCliT.DBF" ) NEW VIA ( cLocalDriver() )READONLY ALIAS ( cCheckArea( "AlbCliT", @tmpAlbCliT ) )
               SET INDEX TO ( cPatSnd() + "AlbCliT.CDX" ) ADDITIVE

               USE ( cPatSnd() + "AlbCliL.DBF" ) NEW VIA ( cLocalDriver() )READONLY ALIAS ( cCheckArea( "AlbCliL", @tmpAlbCliL ) )
               SET INDEX TO ( cPatSnd() + "AlbCliL.CDX" ) ADDITIVE

               USE ( cPatSnd() + "AlbCliI.DBF" ) NEW VIA ( cLocalDriver() )READONLY ALIAS ( cCheckArea( "AlbCliI", @tmpAlbCliI ) )
               SET INDEX TO ( cPatSnd() + "AlbCliI.CDX" ) ADDITIVE

               USE ( cPatEmp() + "AlbCliT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "AlbCliT", @cAlbCliT ) )
               SET ADSINDEX TO ( cPatEmp() + "AlbCliT.CDX" ) ADDITIVE

               USE ( cPatEmp() + "AlbCliL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "AlbCliL", @cAlbCliL ) )
               SET ADSINDEX TO ( cPatEmp() + "AlbCliL.CDX" ) ADDITIVE

               USE ( cPatEmp() + "AlbCliI.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "AlbCliI", @cAlbCliI ) )
               SET ADSINDEX TO ( cPatEmp() + "AlbCliI.CDX" ) ADDITIVE

               while ( tmpAlbCliT )->( !eof() )

                  if ::validateRecepcion( tmpAlbCliT, cAlbCliT )

                     cNumeroAlbaran    := ( tmpAlbCliT )->cSerAlb + Str( ( tmpAlbCliT )->nNumAlb ) + ( tmpAlbCliT )->cSufAlb

                     while ( cAlbCliT )->( dbseek( cNumeroAlbaran ) )
                        dbLockDelete( cAlbCliT )
                     end if 

                     while ( cAlbCliL )->( dbseek( cNumeroAlbaran ) )
                        dbLockDelete( cAlbCliL )
                     end if 

                     dbPass( tmpAlbCliT, cAlbCliT, .t. )

                     if dbLock( cAlbCliT )

                        ( cAlbCliT )->lSndDoc      := .f.

                        if uFieldempresa( "lRecEnt" )
                           ( cAlbCliT )->lEntregado   := .t.
                        end if 

                        ( cAlbCliT )->( dbUnLock() )

                     end if

                     ::oSender:SetText( "Añadido : " + ( tmpAlbCliT )->cSerAlb + "/" + AllTrim( Str( ( tmpAlbCliT )->nNumAlb ) ) + "/" + AllTrim( ( tmpAlbCliT )->cSufAlb ) + "; " + Dtoc( ( tmpAlbCliT )->dFecAlb ) + "; " + AllTrim( ( tmpAlbCliT )->cCodCli ) + "; " + ( tmpAlbCliT )->cNomCli )

                     if ( tmpAlbCliL )->( dbSeek( cNumeroAlbaran ) )
                        while ( tmpAlbCliL )->cSerAlb + Str( ( tmpAlbCliL )->nNumAlb ) + ( tmpAlbCliL )->cSufAlb == cNumeroAlbaran .and. !( tmpAlbCliL )->( eof() )
                           dbPass( tmpAlbCliL, cAlbCliL, .t. )
                           ( tmpAlbCliL )->( dbSkip() )
                        end do
                     end if

                     if ( tmpAlbCliI )->( dbSeek( cNumeroAlbaran ) )
                        while ( tmpAlbCliI )->cSerAlb + Str( ( tmpAlbCliI )->nNumAlb ) + ( tmpAlbCliI )->cSufAlb == cNumeroAlbaran .and. !( tmpAlbCliI )->( eof() )
                           dbPass( tmpAlbCliI, cAlbCliI, .t. )
                           ( tmpAlbCliI )->( dbSkip() )
                        end do
                     end if

                  else

                     ::oSender:SetText( ::cErrorRecepcion  )

                  end if

                  SysRefresh()

                  ( tmpAlbCliT )->( dbSkip() )

               end do

               CLOSE ( cAlbCliT )
               CLOSE ( cAlbCliL )
               CLOSE ( cAlbCliI )
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

         CLOSE ( cAlbCliT )
         CLOSE ( cAlbCliL )
         CLOSE ( cAlbCliI )
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

METHOD validateRecepcion( tmpAlbCliT, dbfAlbCliT ) CLASS TAlbaranesClientesSenderReciver

   ::cErrorRecepcion       := "Pocesando albaran de cliente número " + ( dbfAlbCliT )->cSerAlb + "/" + alltrim( Str( ( dbfAlbCliT )->nNumAlb ) ) + "/" + alltrim( ( dbfAlbCliT )->cSufAlb ) + " "

   if !( lValidaOperacion( ( tmpAlbCliT )->dFecAlb, .f. ) )
      ::cErrorRecepcion    += "la fecha " + dtoc( ( tmpAlbCliT )->dFecAlb ) + " no es valida en esta empresa"
      Return .f. 
   end if 

   if !( ( dbfAlbCliT )->( dbSeek( ( tmpAlbCliT )->cSerAlb + Str( ( tmpAlbCliT )->nNumAlb ) + ( tmpAlbCliT )->cSufAlb ) ) )
      Return .t.
   end if 

   if dtos( ( dbfAlbCliT )->dFecCre ) + ( dbfAlbCliT )->cTimCre >= dtos( ( tmpAlbCliT )->dFecCre ) + ( tmpAlbCliT )->cTimCre
      ::cErrorRecepcion    += "la fecha en la empresa " + dtoc( ( dbfAlbCliT )->dFecCre ) + " " + ( dbfAlbCliT )->cTimCre + " es más reciente que la recepción " + dtoc( ( tmpAlbCliT )->dFecCre ) + " " + ( tmpAlbCliT )->cTimCre 
      Return .f.
   end if

Return ( .t. )

//---------------------------------------------------------------------------//

STATIC FUNCTION DelSerie( oWndBrw )

   local oDlg
   local oSerIni
   local oSerFin
   local oTxtDel
   local nTxtDel     := 0
   local nRecno      := ( D():Get( "AlbCliT", nView ) )->( Recno() )
   local nOrdAnt     := ( D():Get( "AlbCliT", nView ) )->( OrdSetFocus( 1 ) )
   local oDesde      := TDesdeHasta():Init( ( D():Get( "AlbCliT", nView ) )->cSerAlb, ( D():Get( "AlbCliT", nView ) )->nNumAlb, ( D():Get( "AlbCliT", nView ) )->cSufAlb, GetSysDate() )
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

   REDEFINE BUTTON oBtnAceptar ;
      ID       IDOK ;
      OF       oDlg ;
      ACTION   ( DelStart( oDesde, oDlg, oBtnAceptar, oBtnCancel, oTxtDel, @lCancel ) )

   REDEFINE BUTTON oBtnCancel ;
      ID       IDCANCEL ;
      OF       oDlg ;
      CANCEL ;
      ACTION   ( lCancel := .t., oDlg:end() )

   REDEFINE APOLOMETER oTxtDel VAR nTxtDel ;
      ID       160 ;
      NOPERCENTAGE ;
      TOTAL    ( D():Get( "AlbCliT", nView ) )->( OrdKeyCount() ) ;
      OF       oDlg

   ACTIVATE DIALOG oDlg CENTER VALID ( lCancel )

   ( D():Get( "AlbCliT", nView ) )->( dbGoTo( nRecNo ) )
   ( D():Get( "AlbCliT", nView ) )->( ordSetFocus( nOrdAnt ) )

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

      nOrd                 := ( D():Get( "AlbCliT", nView ) )->( OrdSetFocus( "nNumAlb" ) )

      ( D():Get( "AlbCliT", nView ) )->( dbSeek( oDesde:cNumeroInicio(), .t. ) )
      while !lCancel .and. ( D():Get( "AlbCliT", nView ) )->( !eof() )

         if ( D():Get( "AlbCliT", nView ) )->cSerAlb >= oDesde:cSerieInicio  .and.;
            ( D():Get( "AlbCliT", nView ) )->cSerAlb <= oDesde:cSerieFin     .and.;
            ( D():Get( "AlbCliT", nView ) )->nNumAlb >= oDesde:nNumeroInicio .and.;
            ( D():Get( "AlbCliT", nView ) )->nNumAlb <= oDesde:nNumeroFin    .and.;
            ( D():Get( "AlbCliT", nView ) )->cSufAlb >= oDesde:cSufijoInicio .and.;
            ( D():Get( "AlbCliT", nView ) )->cSufAlb <= oDesde:cSufijoFin

            ++nDeleted

            oTxtDel:cText  := "Eliminando : " + ( D():Get( "AlbCliT", nView ) )->cSerAlb + "/" + Alltrim( Str( ( D():Get( "AlbCliT", nView ) )->nNumAlb ) ) + "/" + ( D():Get( "AlbCliT", nView ) )->cSufAlb

            //AlbRecDel( .t., .t., .f., .f. )

            WinDelRec( nil, D():Get( "AlbCliT", nView ), {|| QuiAlbCli() } )

         else

            ( D():Get( "AlbCliT", nView ) )->( dbSkip() )

         end if

         ++nProcesed

         oTxtDel:Set( ( D():Get( "AlbCliT", nView ) )->( OrdKeyNo() ) )

      end do

      ( D():Get( "AlbCliT", nView ) )->( OrdSetFocus( nOrd ) )

   else

      nOrd                 := ( D():Get( "AlbCliT", nView ) )->( OrdSetFocus( "dFecAlb" ) )

      ( D():Get( "AlbCliT", nView ) )->( dbSeek( oDesde:dFechaInicio, .t. ) )
      while !lCancel .and. ( D():Get( "AlbCliT", nView ) )->( !eof() )

         if ( D():Get( "AlbCliT", nView ) )->dFecAlb >= oDesde:dFechaInicio  .and.;
            ( D():Get( "AlbCliT", nView ) )->dFecAlb <= oDesde:dFechaFin

            ++nDeleted

            oTxtDel:cText  := "Eliminando : " + ( D():Get( "AlbCliT", nView ) )->cSerAlb + "/" + Alltrim( Str( ( D():Get( "AlbCliT", nView ) )->nNumAlb ) ) + "/" + ( D():Get( "AlbCliT", nView ) )->cSufAlb

            //AlbRecDel( .t., .t., .f., .f. )

            WinDelRec( nil, D():Get( "AlbCliT", nView ), {|| QuiAlbCli() } )

         else

            ( D():Get( "AlbCliT", nView ) )->( dbSkip() )

         end if

         ++nProcesed

         oTxtDel:Set( ( D():Get( "AlbCliT", nView ) )->( OrdKeyNo() ) )

      end do

      ( D():Get( "AlbCliT", nView ) )->( OrdSetFocus( nOrd ) )

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
   local nOrdAnt  := ( D():Get( "AlbCliI", nView ) )->( OrdSetFocus( "nNumAlb" ) )

   if ( D():Get( "AlbCliI", nView ) )->( dbSeek( cNumAlb ) )

      while ( D():Get( "AlbCliI", nView ) )->cSerAlb + Str( ( D():Get( "AlbCliI", nView ) )->nNumAlb ) + ( D():Get( "AlbCliI", nView ) )->cSufAlb == cNumAlb .and. !( D():Get( "AlbCliI", nView ) )->( Eof() )

         if ( D():Get( "AlbCliI", nView ) )->lListo
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

         ( D():Get( "AlbCliI", nView ) )->( dbSkip() )

      end while

   end if

   ( D():Get( "AlbCliI", nView ) )->( OrdSetFocus( nOrdAnt ) )

Return ( nEstado )

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

   if empty( cCodArt )
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

Static Function AlbCliNotas()

   local cObserv  := ""
   local aData    := {}

   aAdd( aData, "Albaran " + ( D():Get( "AlbCliT", nView ) )->cSerAlb + "/" + AllTrim( Str( ( D():Get( "AlbCliT", nView ) )->nNumAlb ) ) + "/" + Alltrim( ( D():Get( "AlbCliT", nView ) )->cSufAlb ) + " de " + Rtrim( ( D():Get( "AlbCliT", nView ) )->cNomCli ) )
   aAdd( aData, ALB_CLI )
   aAdd( aData, ( D():Get( "AlbCliT", nView ) )->cCodCli )
   aAdd( aData, ( D():Get( "AlbCliT", nView ) )->cNomCli )
   aAdd( aData, ( D():Get( "AlbCliT", nView ) )->cSerAlb + Str( ( D():Get( "AlbCliT", nView ) )->nNumAlb ) + ( D():Get( "AlbCliT", nView ) )->cSufAlb )

   if ( D():Get( "Client", nView ) )->( dbSeek( ( D():Get( "AlbCliT", nView ) )->cCodCli ) )

      if !empty( ( D():Get( "Client", nView ) )->cPerCto )
         cObserv  += Rtrim( ( D():Get( "Client", nView ) )->cPerCto ) + Space( 1 )
      end if

      if !empty( ( D():Get( "Client", nView ) )->Telefono )
         cObserv  += "Télefono : " + Rtrim( ( D():Get( "Client", nView ) )->Telefono ) + Space( 1 )
      end if

      if !empty( ( D():Get( "Client", nView ) )->Movil )
         cObserv  += "Móvil : " + Rtrim( ( D():Get( "Client", nView ) )->Movil ) + Space( 1 )
      end if

      if !empty( ( D():Get( "Client", nView ) )->Fax )
         cObserv  += "Fax : " + Rtrim( ( D():Get( "Client", nView ) )->Fax ) + Space( 1 )
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
      cFmtEnt        := cFormatoEntregasCuentaEnCaja( Application():CodigoCaja(), dbfCajT )
      cPrinter       := cPrinterEntregasCuenta( Application():CodigoCaja(), dbfCajT )
      nCopPrn        := nCopiasEntregasCuentaEnCaja( Application():CodigoCaja(), dbfCajT )
   else
      cFmtEnt        := cFormatoDocumento( nil, "NENTALB", D():Get( "NCount", nView ) )
      cPrinter       := PrnGetName()
      nCopPrn        := nCopiasDocumento( nil, "NENTALB", D():Get( "NCount", nView ) )
   end if

   cSayEnt           := cNombreDoc( cFmtEnt )

   DEFINE DIALOG oDlg RESOURCE "IMPSERENT"

   REDEFINE GET oFmtEnt VAR cFmtEnt ;
      ID       100 ;
      COLOR    CLR_GET ;
      VALID    ( cDocumento( oFmtEnt, oSayEnt, D():Documentos( nView ) ) ) ;
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

   TBtnBmp():ReDefine( 111, "gc_printer2_check_16",,,,,{|| PrinterPreferences( oPrinter ) }, oDlg, .f., , .f.,  )

   REDEFINE GET oCopPrn VAR nCopPrn;
      ID       120 ;
      VALID    nCopPrn > 0 ;
      PICTURE  "999999999" ;
      SPINNER ;
      MIN      1 ;
      MAX      99999 ;
      OF       oDlg

   REDEFINE BUTTON ;
      ID       500 ;
      OF       oDlg ;
      ACTION   ( GenPrnEntregas( lPrint, cFmtEnt, cPrinter, if( lPrint, nCopPrn, 1 ), cAlbCliP, lTicket ), oDlg:End( IDOK ) )

   REDEFINE BUTTON ;
      ID       550 ;
      OF       oDlg ;
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

   if empty( cFmtEnt )
      MsgStop( "Es necesario elegir un formato" )
      return nil
   end if

   if !lExisteDocumento( cFmtEnt, D():Documentos( nView ) )
      return nil
   end if

   if lVisualDocumento( cFmtEnt, D():Documentos( nView ) )
      PrintReportEntAlbCli( if( lPrint, IS_PRINTER, IS_SCREEN ), nCopies, cPrinter, cAlbCliP, lTicket )
   else

      private cDbf         := D():Get( "AlbCliT", nView )
      private cDbfEnt      := cAlbCliP
      private cCliente     := D():Get( "Client", nView )
      private cDbfCli      := D():Get( "Client", nView )
      private cFPago       := D():Get( "FPago", nView )
      private cDbfPgo      := D():Get( "FPago", nView )
      private cDbfAge      := dbfAgent
      private cDbfDiv      := D():Get( "Divisas", nView )
      private cPorDivEnt   := cPorDiv( ( cAlbCliP )->cDivPgo, D():Get( "Divisas", nView ) )

      while n <= nCopies

         if !empty( cPrinter )
            oDevice           := TPrinter():New( cCaption, .f., .t., cPrinter )
            REPORT oRpt CAPTION cCaption TO DEVICE oDevice
         else
            REPORT oRpt CAPTION cCaption PREVIEW
         end if

         if !empty( oRpt ) .and. oRpt:lCreated
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

         if !empty( oRpt )

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

#ifdef __HARBOUR__

STATIC FUNCTION DupSerie( oWndBrw )

   local oDlg
   local oSerIni
   local oSerFin
   local oTxtDup
   local nTxtDup     := 0
   local nRecno      := ( D():Get( "AlbCliT", nView ) )->( Recno() )
   local nOrdAnt     := ( D():Get( "AlbCliT", nView ) )->( OrdSetFocus( 1 ) )
   local oDesde      := TDesdeHasta():Init( ( D():Get( "AlbCliT", nView ) )->cSerAlb, ( D():Get( "AlbCliT", nView ) )->nNumAlb, ( D():Get( "AlbCliT", nView ) )->cSufAlb, GetSysDate() )
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

   REDEFINE APOLOMETER oTxtDup VAR nTxtDup ;
      ID       160 ;
      NOPERCENTAGE ;
      TOTAL    ( D():Get( "AlbCliT", nView ) )->( OrdKeyCount() ) ;
      OF       oDlg

      oDlg:AddFastKey( VK_F5, {|| DupStart( oDesde, oDlg, oBtnAceptar, oBtnCancel, oTxtDup, @lCancel, cFecDoc ) } )

   ACTIVATE DIALOG oDlg CENTER VALID ( lCancel )

   ( D():Get( "AlbCliT", nView ) )->( dbGoTo( nRecNo ) )
   ( D():Get( "AlbCliT", nView ) )->( ordSetFocus( nOrdAnt ) )

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

      nOrd              := ( D():Get( "AlbCliT", nView ) )->( OrdSetFocus( "nNumAlb" ) )

      ( D():Get( "AlbCliT", nView ) )->( dbSeek( oDesde:cNumeroInicio(), .t. ) )

      while !lCancel .and. ( D():Get( "AlbCliT", nView ) )->( !eof() )

         if ( D():Get( "AlbCliT", nView ) )->cSerAlb >= oDesde:cSerieInicio  .and.;
            ( D():Get( "AlbCliT", nView ) )->cSerAlb <= oDesde:cSerieFin     .and.;
            ( D():Get( "AlbCliT", nView ) )->nNumAlb >= oDesde:nNumeroInicio .and.;
            ( D():Get( "AlbCliT", nView ) )->nNumAlb <= oDesde:nNumeroFin    .and.;
            ( D():Get( "AlbCliT", nView ) )->cSufAlb >= oDesde:cSufijoInicio .and.;
            ( D():Get( "AlbCliT", nView ) )->cSufAlb <= oDesde:cSufijoFin

            ++nDuplicados

            oTxtDup:cText  := "Duplicando : " + ( D():Get( "AlbCliT", nView ) )->cSerAlb + "/" + Alltrim( Str( ( D():Get( "AlbCliT", nView ) )->nNumAlb ) ) + "/" + ( D():Get( "AlbCliT", nView ) )->cSufAlb

            DupAlbaran( cFecDoc )

         end if

         ( D():Get( "AlbCliT", nView ) )->( dbSkip() )

         ++nProcesed

         oTxtDup:Set( nProcesed )

      end do

      ( D():Get( "AlbCliT", nView ) )->( OrdSetFocus( nOrd ) )

   else

      nOrd              := ( D():Get( "AlbCliT", nView ) )->( OrdSetFocus( "dFecAlb" ) )

      ( D():Get( "AlbCliT", nView ) )->( dbSeek( oDesde:dFechaInicio, .t. ) )

      while !lCancel .and. ( D():Get( "AlbCliT", nView ) )->( !eof() )

         if ( D():Get( "AlbCliT", nView ) )->dFecAlb >= oDesde:dFechaInicio  .and.;
            ( D():Get( "AlbCliT", nView ) )->dFecAlb <= oDesde:dFechaFin

            ++nDuplicados

            oTxtDup:cText  := "Duplicando : " + ( D():Get( "AlbCliT", nView ) )->cSerAlb + "/" + Alltrim( Str( ( D():Get( "AlbCliT", nView ) )->nNumAlb ) ) + "/" + ( D():Get( "AlbCliT", nView ) )->cSufAlb

            DupAlbaran( cFecDoc )

         end if

         ( D():Get( "AlbCliT", nView ) )->( dbSkip() )

         ++nProcesed

         oTxtDup:Set( nProcesed )

      end do

      ( D():Get( "AlbCliT", nView ) )->( OrdSetFocus( nOrd ) )

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
      if !empty( cFecDoc )
         aTabla[ _DFECALB  ]  := cFecDoc
      end if
      aTabla[ _CCODCAJ     ]  := Application():CodigoCaja()
      aTabla[ _LENTREGADO  ]  = .f.
      aTabla[ _DFECENT     ]  := Ctod("")
      aTabla[ _CNUMPED     ]  := Space( 12 )
      aTabla[ _CNUMFAC     ]  := Space( 12 )
      aTabla[ _LSNDDOC     ]  := .t.
      aTabla[ _LCLOALB     ]  := .f.
      aTabla[ _DFECENV     ]  := GetSysDate()
      aTabla[ _CCODUSR     ]  := Auth():Codigo()
      aTabla[ _DFECCRE     ]  := GetSysDate()
      aTabla[ _CTIMCRE     ]  := Time()
      aTabla[ _LIMPRIMIDO  ]  := .f.
      aTabla[ _DFECIMP     ]  := Ctod("")
      aTabla[ _CHORIMP     ]  := Space( 5 )
      aTabla[ _CCODDLG     ]  := Application():CodigoDelegacion()
      aTabla[ _LFACTURADO  ]  := .f.
      aTabla[ _NFACTURADO  ]  := 1

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

   nNewNumAlb        := nNewDoc( ( D():Get( "AlbCliT", nView ) )->cSerAlb, D():Get( "AlbCliT", nView ), "NALBCLI", , D():Get( "NCount", nView ) )

   //Duplicamos las cabeceras--------------------------------------------------

   AlbRecDup( D():Get( "AlbCliT", nView ), ( D():Get( "AlbCliT", nView ) )->cSerAlb, nNewNumAlb, ( D():Get( "AlbCliT", nView ) )->cSufAlb, .t., cFecDoc )

   //Duplicamos las lineas del documento---------------------------------------

   if ( D():Get( "AlbCliL", nView ) )->( dbSeek( ( D():Get( "AlbCliT", nView ) )->cSerAlb + Str( ( D():Get( "AlbCliT", nView ) )->nNumAlb ) + ( D():Get( "AlbCliT", nView ) )->cSufAlb ) )

      while ( D():Get( "AlbCliT", nView ) )->cSerAlb + Str( ( D():Get( "AlbCliT", nView ) )->nNumAlb ) + ( D():Get( "AlbCliT", nView ) )->cSufAlb == ( D():Get( "AlbCliL", nView ) )->cSerAlb + Str( ( D():Get( "AlbCliL", nView ) )->nNumAlb ) + ( D():Get( "AlbCliL", nView ) )->cSufAlb .and. ;
            !( D():Get( "AlbCliL", nView ) )->( Eof() )

         AlbRecDup( D():Get( "AlbCliL", nView ), ( D():Get( "AlbCliT", nView ) )->cSerAlb, nNewNumAlb, ( D():Get( "AlbCliT", nView ) )->cSufAlb, .f. )

         ( D():Get( "AlbCliL", nView ) )->( dbSkip() )

      end while

   end if

   //Duplicamos los documentos-------------------------------------------------

   if ( D():Get( "AlbCliD", nView ) )->( dbSeek( ( D():Get( "AlbCliT", nView ) )->cSerAlb + Str( ( D():Get( "AlbCliT", nView ) )->nNumAlb ) + ( D():Get( "AlbCliT", nView ) )->cSufAlb ) )

      while ( D():Get( "AlbCliT", nView ) )->cSerAlb + Str( ( D():Get( "AlbCliT", nView ) )->nNumAlb ) + ( D():Get( "AlbCliT", nView ) )->cSufAlb == ( D():Get( "AlbCliD", nView ) )->cSerAlb + Str( ( D():Get( "AlbCliD", nView ) )->nNumAlb ) + ( D():Get( "AlbCliD", nView ) )->cSufAlb .and. ;
            !( D():Get( "AlbCliD", nView ) )->( Eof() )

         AlbRecDup( D():Get( "AlbCliD", nView ), ( D():Get( "AlbCliT", nView ) )->cSerAlb, nNewNumAlb, ( D():Get( "AlbCliT", nView ) )->cSufAlb, .f. )

         ( D():Get( "AlbCliD", nView ) )->( dbSkip() )

      end while

   end if

RETURN ( .t. )
//---------------------------------------------------------------------------//

#endif

STATIC FUNCTION SetDialog( aGet, oSayDias, oSayTxtDias )

   if !empty( oTipAlb )

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

   if !lAccArticulo() .or. SQLAjustableModel():getRolNoMostrarRentabilidad( Auth():rolUuid() )

      if !empty( oGetRnt )
         oGetRnt:Hide()
      end if

   end if

Return .t.

//---------------------------------------------------------------------------//

Static Function loadComisionAgente( aTmp, aGet, aTmpAlb )

   local nComisionAgenteTarifa   := nComisionAgenteTarifa( aTmpAlb[ _CCODAGE ], aTmp[ _NTARLIN ], nView ) 

   if nComisionAgenteTarifa == 0
      nComisionAgenteTarifa      := aTmpAlb[ _NPCTCOMAGE ]
   end if 

   aTmp[ _NCOMAGE ]              := nComisionAgenteTarifa 

   if !empty( aGet )
      aGet[ _NCOMAGE ]:cText( nComisionAgenteTarifa )
   end if

return .t.

//-----------------------------------------------------------------------------

STATIC FUNCTION ValidaMedicion( aTmp, aGet )

  // local cNewUndMed  := aGet[ _CUNIDAD ]:VarGet

  local cNewUndMed

   if !empty( aGet )
      cNewUndMed  := aGet[ _CUNIDAD ]:VarGet()
   else
      cNewUndMed  := aTmp[ _CUNIDAD ]
   end if

   /*
   Cargamos el codigo de las unidades---------------------------------
   */

   if ( empty( cOldUndMed ) .or. cOldUndMed != cNewUndMed )

      if oUndMedicion:oDbf:Seek( aTmp[ _CUNIDAD ] )

         if oUndMedicion:oDbf:nDimension >= 1 .and. !empty( oUndMedicion:oDbf:cTextoDim1 )
            if !empty( aGet )
               aGet[ ( D():Get( "AlbCliL", nView ) )->( fieldpos( "nMedUno" ) ) ]:oSay:SetText( oUndMedicion:oDbf:cTextoDim1 )
               aGet[ ( D():Get( "AlbCliL", nView ) )->( fieldpos( "nMedUno" ) ) ]:cText( ( D():Articulos( nView ) )->nLngArt )
               aGet[ ( D():Get( "AlbCliL", nView ) )->( fieldpos( "nMedUno" ) ) ]:Show()
            else
               aTmp[ ( D():Get( "AlbCliL", nView ) )->( fieldpos( "nMedUno" ) ) ]  := ( D():Articulos( nView ) )->nLngArt
            end if
         else
            if !empty( aGet )
               aGet[ ( D():Get( "AlbCliL", nView ) )->( fieldpos( "nMedUno" ) ) ]:cText( 0 )
               aGet[ ( D():Get( "AlbCliL", nView ) )->( fieldpos( "nMedUno" ) ) ]:Hide()
            else
               aTmp[ ( D():Get( "AlbCliL", nView ) )->( fieldpos( "nMedUno" ) ) ]  := 0
            end if
         end if

         if oUndMedicion:oDbf:nDimension >= 2 .and. !empty( oUndMedicion:oDbf:cTextoDim2 )
            if !empty( aGet )
               aGet[ ( D():Get( "AlbCliL", nView ) )->( fieldpos( "nMedDos" ) ) ]:oSay:SetText( oUndMedicion:oDbf:cTextoDim2 )
               aGet[ ( D():Get( "AlbCliL", nView ) )->( fieldpos( "nMedDos" ) ) ]:cText( ( D():Articulos( nView ) )->nAltArt )
               aGet[ ( D():Get( "AlbCliL", nView ) )->( fieldpos( "nMedDos" ) ) ]:Show()
            else
               aTmp[ ( D():Get( "AlbCliL", nView ) )->( fieldpos( "nMedDos" ) ) ]  := ( D():Articulos( nView ) )->nAltArt
            end if

         else
            if !empty( aGet )
               aGet[ ( D():Get( "AlbCliL", nView ) )->( fieldpos( "nMedDos" ) ) ]:cText( 0 )
               aGet[ ( D():Get( "AlbCliL", nView ) )->( fieldpos( "nMedDos" ) ) ]:Hide()
            else
               aTmp[ ( D():Get( "AlbCliL", nView ) )->( fieldpos( "nMedDos" ) ) ]  := 0
            end if
         end if

         if oUndMedicion:oDbf:nDimension >= 3 .and. !empty( oUndMedicion:oDbf:cTextoDim3 )
            if !empty( aGet )
               aGet[ ( D():Get( "AlbCliL", nView ) )->( fieldpos( "nMedTre" ) ) ]:oSay:SetText( oUndMedicion:oDbf:cTextoDim3 )
               aGet[ ( D():Get( "AlbCliL", nView ) )->( fieldpos( "nMedTre" ) ) ]:cText( ( D():Articulos( nView ) )->nAncArt )
               aGet[ ( D():Get( "AlbCliL", nView ) )->( fieldpos( "nMedTre" ) ) ]:Show()
            else
               aTmp[ ( D():Get( "AlbCliL", nView ) )->( fieldpos( "nMedTre" ) ) ]  := ( D():Articulos( nView ) )->nAncArt
            end if
         else
            if !empty( aGet )
               aGet[ ( D():Get( "AlbCliL", nView ) )->( fieldpos( "nMedTre" ) ) ]:cText( 0 )
               aGet[ ( D():Get( "AlbCliL", nView ) )->( fieldpos( "nMedTre" ) ) ]:Hide()
            else
               aTmp[ ( D():Get( "AlbCliL", nView ) )->( fieldpos( "nMedTre" ) ) ]  := 0
            end if
         end if

      else

         if !empty( aGet )
            aGet[ ( D():Get( "AlbCliL", nView ) )->( fieldpos( "nMedUno" ) ) ]:Hide()
            aGet[ ( D():Get( "AlbCliL", nView ) )->( fieldpos( "nMedUno" ) ) ]:cText( 0 )
            aGet[ ( D():Get( "AlbCliL", nView ) )->( fieldpos( "nMedDos" ) ) ]:Hide()
            aGet[ ( D():Get( "AlbCliL", nView ) )->( fieldpos( "nMedDos" ) ) ]:cText( 0 )
            aGet[ ( D():Get( "AlbCliL", nView ) )->( fieldpos( "nMedTre" ) ) ]:Hide()
            aGet[ ( D():Get( "AlbCliL", nView ) )->( fieldpos( "nMedTre" ) ) ]:cText( 0 )
         end if

      end if

      cOldUndMed := cNewUndMed

   end if

RETURN .t.

//---------------------------------------------------------------------------//

Static Function ChangeTarifa( aTmp, aGet, aTmpAlb )

    local nPrePro  := 0

   nPrePro     := nPrePro( aTmp[ _CREF ], aTmp[ _CCODPR1 ], aTmp[ _CVALPR1 ], aTmp[ _CCODPR2 ], aTmp[ _CVALPR2 ], aTmp[ _NTARLIN ], aTmpAlb[ _LIVAINC ], dbfArtDiv, aTmpAlb[ _CCODTAR ] )

   if nPrePro == 0
      nPrePro  := nRetPreArt( aTmp[ _NTARLIN ], aTmpAlb[ _CDIVALB ], aTmpAlb[ _LIVAINC ], D():Articulos( nView ), D():Get( "Divisas", nView ), dbfKit, D():Get( "TIva", nView ), , , oNewImp )
   end if

   if nPrePro != 0
      aGet[ _NPREUNIT ]:cText( nPrePro )
   end if

Return .t.

//---------------------------------------------------------------------------//

#include "FastRepH.ch"

Static Function DataReport( oFr )

   oFr:DeleteCategory(  "Albaranes" )
   oFr:DeleteCategory(  "Lineas de albaranes" )
   oFr:DeleteCategory(  "Clientes" )
   oFr:DeleteCategory(  "Clientes.País" )

   /*
   Zona de datos------------------------------------------------------------
   */

   oFr:ClearDataSets()

   oFr:SetWorkArea(     "Albaranes", ( D():Get( "AlbCliT", nView ) )->( Select() ), .f., { FR_RB_CURRENT, FR_RB_CURRENT, 0 } )
   oFr:SetFieldAliases( "Albaranes", cItemsToReport( aItmAlbCli() ) )

   oFr:SetWorkArea(     "Lineas de albaranes", ( D():Get( "AlbCliL", nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Lineas de albaranes", cItemsToReport( aColAlbCli() ) )

   oFr:SetWorkArea(     "Series de lineas de albaranes", ( D():Get( "AlbCliS", nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Series de lineas de albaranes", cItemsToReport( aSerAlbCli() ) )

   oFr:SetWorkArea(     "Incidencias de albaranes", ( D():Get( "AlbCliI", nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Incidencias de albaranes", cItemsToReport( aIncAlbCli() ) )

   oFr:SetWorkArea(     "Documentos de albaranes", ( D():Get( "AlbCliD", nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Documentos de albaranes", cItemsToReport( aAlbCliDoc() ) )

   oFr:SetWorkArea(     "Entregas de albaranes", ( D():Get( "AlbCliP", nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Entregas de albaranes", cItemsToReport( aItmAlbPgo() ) )

    oFr:SetWorkArea(     "Situaciones de Albaranes", ( D():AlbaranesClientesSituaciones( nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Situaciones de Albaranes", cItemsToReport( aAlbCliEst() ) )

   oFr:SetWorkArea(     "Empresa", ( dbfEmp )->( Select() ) )
   oFr:SetFieldAliases( "Empresa", cItemsToReport( aItmEmp() ) )

   oFr:SetWorkArea(     "Clientes", ( D():Get( "Client", nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Clientes", cItemsToReport( aItmCli() ) )

   oFr:SetWorkArea(     "País", oPais:Select() )
   oFr:SetFieldAliases( "País", cObjectsToReport( oPais:oDbf ) )

   oFr:SetWorkArea(     "Obras", ( dbfObrasT )->( Select() ) )
   oFr:SetFieldAliases( "Obras",  cItemsToReport( aItmObr() ) )

   oFr:SetWorkArea(     "Almacenes", ( dbfAlm )->( Select() ) )
   oFr:SetFieldAliases( "Almacenes", cItemsToReport( aItmAlm() ) )

   oFr:SetWorkArea(     "Rutas", ( dbfRuta )->( Select() ) )
   oFr:SetFieldAliases( "Rutas", cItemsToReport( aItmRut() ) )

   oFr:SetWorkArea(     "Agentes", ( dbfAgent )->( Select() ) )
   oFr:SetFieldAliases( "Agentes", cItemsToReport( aItmAge() ) )

   oFr:SetWorkArea(     "Formas de pago", ( D():Get( "FPago", nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Formas de pago", cItemsToReport( aItmFPago() ) )

   oFr:SetWorkArea(     "Artículos", ( D():Articulos( nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Artículos", cItemsToReport( aItmArt() ) )

   oFr:SetWorkArea(     "Tipo artículo",  oTipArt:Select() )
   oFr:SetFieldAliases( "Tipo artículo",  cObjectsToReport( oTipArt:oDbf ) )

   oFr:SetWorkArea(     "Ofertas", ( dbfOferta )->( Select() ) )
   oFr:SetFieldAliases( "Ofertas", cItemsToReport( aItmOfe() ) )

   oFr:SetWorkArea(     "Unidades de medición",  oUndMedicion:Select() )
   oFr:SetFieldAliases( "Unidades de medición",  cObjectsToReport( oUndMedicion:oDbf ) )

   oFr:SetWorkArea(     "SAT", ( dbfAlbCliT )->( Select() ) )
   oFr:SetFieldAliases( "SAT", cItemsToReport( aItmAlbCli() ) )

   oFr:SetWorkArea(     "Impuestos especiales",  oNewImp:Select() )
   oFr:SetFieldAliases( "Impuestos especiales",  cObjectsToReport( oNewImp:oDbf ) )

   oFr:SetMasterDetail( "Albaranes", "Lineas de albaranes",                      {|| ( D():Get( "AlbCliT", nView ) )->cSerAlb + Str( ( D():Get( "AlbCliT", nView ) )->nNumAlb ) + ( D():Get( "AlbCliT", nView ) )->cSufAlb } )
   oFr:SetMasterDetail( "Albaranes", "Incidencias de albaranes",                 {|| ( D():Get( "AlbCliT", nView ) )->cSerAlb + Str( ( D():Get( "AlbCliT", nView ) )->nNumAlb ) + ( D():Get( "AlbCliT", nView ) )->cSufAlb } )
   oFr:SetMasterDetail( "Albaranes", "Documentos de albaranes",                  {|| ( D():Get( "AlbCliT", nView ) )->cSerAlb + Str( ( D():Get( "AlbCliT", nView ) )->nNumAlb ) + ( D():Get( "AlbCliT", nView ) )->cSufAlb } )
   oFr:SetMasterDetail( "Albaranes", "Entregas de albaranes",                    {|| ( D():Get( "AlbCliT", nView ) )->cSerAlb + Str( ( D():Get( "AlbCliT", nView ) )->nNumAlb ) + ( D():Get( "AlbCliT", nView ) )->cSufAlb } )
   oFr:SetMasterDetail( "Albaranes", "Clientes",                                 {|| ( D():Get( "AlbCliT", nView ) )->cCodCli } )
   oFr:SetMasterDetail( "Albaranes", "Obras",                                    {|| ( D():Get( "AlbCliT", nView ) )->cCodCli + ( D():Get( "AlbCliT", nView ) )->cCodObr } )
   oFr:SetMasterDetail( "Albaranes", "Almacenes",                                {|| ( D():Get( "AlbCliT", nView ) )->cCodAlm } )
   oFr:SetMasterDetail( "Albaranes", "Rutas",                                    {|| ( D():Get( "AlbCliT", nView ) )->cCodRut } )
   oFr:SetMasterDetail( "Albaranes", "Agentes",                                  {|| ( D():Get( "AlbCliT", nView ) )->cCodAge } )
   oFr:SetMasterDetail( "Albaranes", "Formas de pago",                           {|| ( D():Get( "AlbCliT", nView ) )->cCodPago} )
   oFr:SetMasterDetail( "Albaranes", "Empresa",                                  {|| cCodigoEmpresaEnUso() } )
   oFr:SetMasterDetail( "Albaranes", "País",                                     {|| RetFld( ( D():Get( "AlbCliT", nView ) )->cCodCli, D():Clientes( nView ), "cCodPai" ) } )
   
   oFr:SetMasterDetail( "Lineas de albaranes", "Artículos",                      {|| SynchronizeDetails() } )
   oFr:SetMasterDetail( "Lineas de albaranes", "Ofertas",                        {|| ( D():AlbaranesClientesLineas( nView ) )->cRef } )
   oFr:SetMasterDetail( "Lineas de albaranes", "Unidades de medición",           {|| ( D():AlbaranesClientesLineas( nView ) )->cUnidad } )
   oFr:SetMasterDetail( "Lineas de albaranes", "Impuestos especiales",           {|| ( D():AlbaranesClientesLineas( nView ) )->cCodImp } )
   oFr:SetMasterDetail( "Lineas de albaranes", "Series de lineas de albaranes",  {|| ( D():AlbaranesClientesLineas( nView ) )->cSerAlb + Str( ( D():AlbaranesClientesLineas( nView ) )->nNumAlb ) + ( D():AlbaranesClientesLineas( nView ) )->cSufAlb + Str( ( D():AlbaranesClientesLineas( nView ) )->nNumLin ) } )
   oFr:SetMasterDetail( "Lineas de albaranes", "SAT",                            {|| ( D():AlbaranesClientesLineas( nView ) )->cNumSat } )

   oFr:SetResyncPair(   "Albaranes", "Lineas de albaranes" )
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
   oFr:SetResyncPair(   "Albaranes", "Pais" )

   oFr:SetResyncPair(   "Lineas de albaranes", "Artículos" )
   oFr:SetResyncPair(   "Lineas de albaranes", "Tipo artículo" )
   oFr:SetResyncPair(   "Lineas de albaranes", "Tipo de venta" )
   oFr:SetResyncPair(   "Lineas de albaranes", "Ofertas" )
   oFr:SetResyncPair(   "Lineas de albaranes", "Unidades de medición" )
   oFr:SetResyncPair(   "Lineas de albaranes", "Impuestos especiales" )
   oFr:SetResyncPair(   "Lineas de albaranes", "Series de lineas de albaranes" )

   oFr:SetResyncPair(   "Lineas de albaranes", "SAT" )

Return nil

//---------------------------------------------------------------------------//

Static Function SynchronizeDetails()

Return ( ( D():AlbaranesClientesLineas( nView ) )->cRef )

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

   oFr:AddVariable(     "Albaranes",             "Saldo anterior envase 4",                                       "CallHbFunc('nSaldoAnteriorAlbCli4')" )
   oFr:AddVariable(     "Albaranes",             "Saldo anterior envase 8",                                       "CallHbFunc('nSaldoAnteriorAlbCli8')" )
   oFr:AddVariable(     "Albaranes",             "Saldo anterior envase 16",                                      "CallHbFunc('nSaldoAnteriorAlbCli16')" )

   oFr:AddVariable(     "Albaranes",             "Saldo documento envase 4",                                      "CallHbFunc('nSaldoDocumentoAlbCli4')" )
   oFr:AddVariable(     "Albaranes",             "Saldo documento envase 8",                                      "CallHbFunc('nSaldoDocumentoAlbCli8')" )
   oFr:AddVariable(     "Albaranes",             "Saldo documento envase 16",                                     "CallHbFunc('nSaldoDocumentoAlbCli16')" )

   oFr:AddVariable(     "Albaranes",             "Total saldo envase 4",                                          "CallHbFunc('nTotalSaldoAlbCli4')" )
   oFr:AddVariable(     "Albaranes",             "Total saldo envase 8",                                          "CallHbFunc('nTotalSaldoAlbCli8')" )
   oFr:AddVariable(     "Albaranes",             "Total saldo envase 16",                                         "CallHbFunc('nTotalSaldoAlbCli16')" )
   
   oFr:AddVariable(     "Lineas de albaranes",   "Detalle del artículo",                     "CallHbFunc('cDesAlbCli')"  )
   oFr:AddVariable(     "Lineas de albaranes",   "Detalle del artículo otro lenguaje",       "CallHbFunc('cDesAlbCliLeng')"  )
   oFr:AddVariable(     "Lineas de albaranes",   "Total unidades artículo",                  "CallHbFunc('nTotNAlbCli')" )
   oFr:AddVariable(     "Lineas de albaranes",   "Precio unitario del artículo",             "CallHbFunc('nTotUAlbCli')" )
   oFr:AddVariable(     "Lineas de albaranes",   "Total línea de albaran",                   "CallHbFunc('nTotLAlbCli')" )
   oFr:AddVariable(     "Lineas de albaranes",   "Total peso por línea",                     "CallHbFunc('nPesLAlbCli')" )
   oFr:AddVariable(     "Lineas de albaranes",   "Total línea sin " + cImp(),                "CallHbFunc('nNetLAlbCli')" )
   oFr:AddVariable(     "Lineas de albaranes",   "Total línea "+ cImp() + " incluido",       "CallHbFunc('nIncLAlbCli')" )
   oFr:AddVariable(     "Lineas de albaranes",   "Precio unitario "+ cImp() + " incluido",   "CallHbFunc('nIncUAlbCli')" )

   oFr:AddVariable(     "Lineas de albaranes",   "Fecha en juliano 4 meses",            "CallHbFunc('dJuliano4AlbCli')" )
   oFr:AddVariable(     "Lineas de albaranes",   "Fecha en juliano 6 meses",            "CallHbFunc('dJulianoAlbCli')" )
   oFr:AddVariable(     "Lineas de albaranes",   "Fecha en juliano 8 meses",            "CallHbFunc('dJulianoAlbAnio')" )
   oFr:AddVariable(     "Lineas de albaranes",   "Dirección del SAT",                   "CallHbFunc('cDireccionSAT')" )

   oFr:AddVariable(     "Transportistas",        "Nombre transportista",                "CallHbFunc('getNombreTransportistaAlbCli')" )

Return nil

//---------------------------------------------------------------------------//

Function getNombreTransportistaAlbCli()

Return SQLTransportistasModel():getNombreWhereCodigo( ( D():AlbaranesClientes( nView ) )->cCodTrn )

//---------------------------------------------------------------------------//

Static Function DataReportEntAlbCli( oFr, cAlbCliP, lTicket )

   DEFAULT lTicket      := .f.

   /*
   Zona de datos------------------------------------------------------------
   */

   oFr:ClearDataSets()

   if !empty( cAlbCliP )
      oFr:SetWorkArea(  "Entrega", ( cAlbCliP )->( Select() ), .f., { FR_RB_CURRENT, FR_RB_CURRENT, 0 } )
   else
      oFr:SetWorkArea(  "Entrega", ( D():Get( "AlbCliP", nView ) )->( Select() ), .f., { FR_RB_CURRENT, FR_RB_CURRENT, 0 } )
   end if
   oFr:SetFieldAliases( "Entrega", cItemsToReport( aItmAlbPgo() ) )

   if lTicket
   oFr:SetWorkArea(     "Albarán de cliente", ( D():Get( "AlbCliT", nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Albarán de cliente", cItemsToReport( aItmAlbCli() ) )
   else
   oFr:SetWorkArea(     "Albarán de cliente", ( D():Get( "AlbCliT", nView ) )->( Select() ), .f., { FR_RB_CURRENT, FR_RB_CURRENT, 0 } )
   oFr:SetFieldAliases( "Albarán de cliente", cItemsToReport( aItmAlbCli() ) )
   end if

   oFr:SetWorkArea(     "Empresa", ( dbfEmp )->( Select() ) )
   oFr:SetFieldAliases( "Empresa", cItemsToReport( aItmEmp() ) )

   oFr:SetWorkArea(     "Clientes", ( D():Get( "Client", nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Clientes", cItemsToReport( aItmCli() ) )

   oFr:SetWorkArea(     "Formas de pago", ( D():Get( "FPago", nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Formas de pago", cItemsToReport( aItmFPago() ) )

   if lTicket
      if !empty( cAlbCliP )
         oFr:SetMasterDetail( "Entrega", "Albarán de cliente", {|| ( cAlbCliP )->cSerAlb + Str( ( cAlbCliP )->nNumAlb ) + ( cAlbCliP )->cSufAlb } )
      else
         oFr:SetMasterDetail( "Entrega", "Albarán de cliente", {|| ( D():Get( "AlbCliP", nView ) )->cSerAlb + Str( ( D():Get( "AlbCliP", nView ) )->nNumAlb ) + ( D():Get( "AlbCliP", nView ) )->cSufAlb } )
      end if
   end if

   if !empty( cAlbCliP )
   oFr:SetMasterDetail( "Entrega", "Clientes",                 {|| ( cAlbCliP )->cCodCli } )
   oFr:SetMasterDetail( "Entrega", "Formas de pago",           {|| ( cAlbCliP )->cCodPgo } )
   else
   oFr:SetMasterDetail( "Entrega", "Clientes",                 {|| ( D():Get( "AlbCliP", nView ) )->cCodCli } )
   oFr:SetMasterDetail( "Entrega", "Formas de pago",           {|| ( D():Get( "AlbCliP", nView ) )->cCodPgo } )
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
   oFr:AddVariable( "Albarán de cliente",    "Fecha del sexto vencimiento",         "GetHbArrayVar('aDatVto',6)" )
   oFr:AddVariable( "Albarán de cliente",    "Fecha del septimo vencimiento",       "GetHbArrayVar('aDatVto',7)" )
   oFr:AddVariable( "Albarán de cliente",    "Fecha del octavovencimiento",         "GetHbArrayVar('aDatVto',8)" )
   oFr:AddVariable( "Albarán de cliente",    "Fecha del noveno vencimiento",        "GetHbArrayVar('aDatVto',9)" )
   oFr:AddVariable( "Albarán de cliente",    "Fecha del decimo vencimiento",        "GetHbArrayVar('aDatVto',10)" )
   oFr:AddVariable( "Albarán de cliente",    "Fecha del undecimo vencimiento",      "GetHbArrayVar('aDatVto',11)" )
   oFr:AddVariable( "Albarán de cliente",    "Fecha del duodecimo vencimiento",     "GetHbArrayVar('aDatVto',12)" )
   
   oFr:AddVariable( "Albarán de cliente",    "Importe del primer vencimiento",      "GetHbArrayVar('aImpVto',1)" )
   oFr:AddVariable( "Albarán de cliente",    "Importe del segundo vencimiento",     "GetHbArrayVar('aImpVto',2)" )
   oFr:AddVariable( "Albarán de cliente",    "Importe del tercero vencimiento",     "GetHbArrayVar('aImpVto',3)" )
   oFr:AddVariable( "Albarán de cliente",    "Importe del cuarto vencimiento",      "GetHbArrayVar('aImpVto',4)" )
   oFr:AddVariable( "Albarán de cliente",    "Importe del quinto vencimiento",      "GetHbArrayVar('aImpVto',5)" )
   oFr:AddVariable( "Albarán de cliente",    "Importe del sexto vencimiento",       "GetHbArrayVar('aImpVto',6)" )
   oFr:AddVariable( "Albarán de cliente",    "Importe del septimo vencimiento",     "GetHbArrayVar('aImpVto',7)" )
   oFr:AddVariable( "Albarán de cliente",    "Importe del octavo vencimiento",      "GetHbArrayVar('aImpVto',8)" )
   oFr:AddVariable( "Albarán de cliente",    "Importe del noveno vencimiento",      "GetHbArrayVar('aImpVto',9)" )
   oFr:AddVariable( "Albarán de cliente",    "Importe del decimo vencimiento",      "GetHbArrayVar('aImpVto',10)" )
   oFr:AddVariable( "Albarán de cliente",    "Importe del undecimo vencimiento",    "GetHbArrayVar('aImpVto',11)" )
   oFr:AddVariable( "Albarán de cliente",    "Importe del duodecimo vencimiento",   "GetHbArrayVar('aImpVto',12)" )

Return nil

//---------------------------------------------------------------------------//

STATIC FUNCTION CreateFiles( cPath )

   if !lExistTable( cPath + "AlbCliT.Dbf", cLocalDriver() )
      dbCreate( cPath + "AlbCliT.Dbf", aSqlStruct( aItmAlbCli() ), cLocalDriver() )
   end if

   if !lExistTable( cPath + "AlbCliL.Dbf", cLocalDriver() )
      dbCreate( cPath + "AlbCliL.Dbf", aSqlStruct( aColAlbCli() ), cLocalDriver() )
   end if

   if !lExistTable( cPath + "AlbCliP.Dbf", cLocalDriver() )
      dbCreate( cPath + "AlbCliP.Dbf", aSqlStruct( aItmAlbPgo() ), cLocalDriver() )
   end if

   if !lExistTable( cPath + "AlbCliI.Dbf", cLocalDriver() )
      dbCreate( cPath + "AlbCliI.Dbf", aSqlStruct( aIncAlbCli() ), cLocalDriver() )
   end if

   if !lExistTable( cPath + "AlbCliD.Dbf", cLocalDriver() )
      dbCreate( cPath + "AlbCliD.Dbf", aSqlStruct( aAlbCliDoc() ), cLocalDriver() )
   end if

   if !lExistTable( cPath + "AlbCliS.Dbf", cLocalDriver() )
      dbCreate( cPath + "AlbCliS.Dbf", aSqlStruct( aSerAlbCli() ), cLocalDriver() )
   end if

   if !lExistTable( cPath + "AlbCliE.Dbf", cLocalDriver() )
      dbCreate( cPath + "AlbCliE.Dbf", aSqlStruct( aAlbCliEst() ), cLocalDriver() )
   end if

RETURN NIL

//--------------------------------------------------------------------//

STATIC FUNCTION KillTrans()

   /*
   Borramos los ficheros-------------------------------------------------------
   */

   if !empty( dbfTmpLin ) .and. ( dbfTmpLin )->( Used() )
      ( dbfTmpLin )->( dbCloseArea() )
   end if

   if !empty( dbfTmpPgo ) .and. ( dbfTmpPgo )->( Used() )
      ( dbfTmpPgo )->( dbCloseArea() )
   end if

   if !empty( dbfTmpInc ) .and. ( dbfTmpInc )->( Used() )
      ( dbfTmpInc )->( dbCloseArea() )
   end if

   if !empty( dbfTmpDoc ) .and. ( dbfTmpDoc )->( Used() )
      ( dbfTmpDoc )->( dbCloseArea() )
   end if

   if !empty( dbfTmpSer ) .and. ( dbfTmpSer )->( Used() )
      ( dbfTmpSer )->( dbCloseArea() )
   end if

   if !empty( dbfTmpEst ) .and. ( dbfTmpEst )->( Used() )
      ( dbfTmpEst )->( dbCloseArea() )
   end if

   dbfTmpLin      := nil
   dbfTmpInc      := nil
   dbfTmpDoc      := nil
   dbfTmpPgo      := nil
   dbfTmpSer      := nil
   dbfTmpEst      := nil

   dbfErase( cTmpLin )
   dbfErase( cTmpPgo )
   dbfErase( cTmpInc )
   dbfErase( cTmpDoc )
   dbfErase( cTmpSer )
   dbfErase( cTmpEst )

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
   local cDbfEst     := "ACliE"
   local cAlbaran

   CursorWait()

   oBlock            := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      TComercio:resetProductsToUpdateStocks()

      aNumPed        := {}

      cAlbaran       := aTmp[ _CSERALB ] + Str( aTmp[ _NNUMALB ] ) + aTmp[ _CSUFALB ]

      cTmpLin        := cGetNewFileName( cPatTmp() + cDbfLin )
      cTmpInc        := cGetNewFileName( cPatTmp() + cDbfInc )
      cTmpDoc        := cGetNewFileName( cPatTmp() + cDbfDoc )
      cTmpPgo        := cGetNewFileName( cPatTmp() + cDbfPgo )
      cTmpSer        := cGetNewFileName( cPatTmp() + cDbfSer )
      cTmpEst        := cGetNewFileName( cPatTmp() + cDbfEst )

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

         ( dbfTmpLin )->( OrdCondSet( "!Deleted()", {||!Deleted() } ) )
         ( dbfTmpLin )->( OrdCreate( cTmpLin, "cRef", "cRef", {|| Field->cRef } ) )

         ( dbfTmpLin )->( OrdCondSet( "!Deleted()", {||!Deleted() } ) )
         ( dbfTmpLin )->( OrdCreate( cTmpLin, "cDetalle", "Left( cDetalle, 100 )", {|| Left( Field->cDetalle, 100 ) } ) )

         ( dbfTmpLin )->( OrdCondSet( "!Deleted()", {|| !Deleted() } ) )
         ( dbfTmpLin )->( OrdCreate( cTmpLin, "nNumAlb", "Str( Recno() )", {|| Str( Recno() ) } ) )

         ( dbfTmpLin )->( OrdCondSet( "!Deleted()", {|| !Deleted() } ) )
         ( dbfTmpLin )->( OrdCreate( cTmpLin, "nUniCaja", "nUniCaja", {|| Field->nUniCaja } ) )

         ( dbfTmpLin )->( OrdCondSet( "!Deleted()", {|| !Deleted() } ) )
         ( dbfTmpLin )->( OrdCreate( cTmpLin, "dFecUltCom", "dFecUltCom", {|| Field->dFecUltCom } ) )

         ( dbfTmpLin )->( OrdCondSet( "!Deleted()", {|| !Deleted() } ) )
         ( dbfTmpLin )->( OrdCreate( cTmpLin, "nUniUltCom", "nUniUltCom", {|| Field->nUniUltCom } ) )

         ( dbfTmpLin )->( OrdCondSet( "!Deleted()", {||!Deleted() } ) )
         ( dbfTmpLin )->( OrdCreate( cTmpLin, "nPosPrint", "Str( nPosPrint, 4 )", {|| Str( Field->nPosPrint ) } ) )

         oLinDetCamposExtra:initArrayValue()

         if ( D():Get( "AlbCliL", nView ) )->( dbSeek( cAlbaran ) )
            while ( ( D():Get( "AlbCliL", nView ) )->cSerAlb + Str( ( D():Get( "AlbCliL", nView ) )->nNumAlb ) + ( D():Get( "AlbCliL", nView ) )->cSufAlb ) == cAlbaran .and. !( D():Get( "AlbCliL", nView ) )->( eof() )
               dbPass( D():Get( "AlbCliL", nView ), dbfTmpLin, .t. )
               oLinDetCamposExtra:SetTemporalLines( ( dbfTmpLin )->cSerAlb + str( ( dbfTmpLin )->nNumAlb ) + ( dbfTmpLin )->cSufAlb + str( ( dbfTmpLin )->nNumLin ) + str( ( dbfTmpLin )->nNumKit ), ( dbfTmpLin )->( OrdKeyNo() ), nMode )
               ( D():Get( "AlbCliL", nView ) )->( dbSkip() )
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

         if ( nMode != DUPL_MODE ) .and. ( D():Get( "AlbCliP", nView ) )->( dbSeek( cAlbaran ) )
            while ( ( D():Get( "AlbCliP", nView ) )->cSerAlb + Str( ( D():Get( "AlbCliP", nView ) )->nNumAlb ) + ( D():Get( "AlbCliP", nView ) )->cSufAlb ) == cAlbaran .and. !( D():Get( "AlbCliP", nView ) )->( eof() )
               dbPass( D():Get( "AlbCliP", nView ), dbfTmpPgo, .t. )
               ( D():Get( "AlbCliP", nView ) )->( dbSkip() )
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

         if ( nMode != DUPL_MODE ) .and. ( D():Get( "AlbCliI", nView ) )->( dbSeek( cAlbaran ) )
            while ( ( D():Get( "AlbCliI", nView ) )->cSerAlb + Str( ( D():Get( "AlbCliI", nView ) )->nNumAlb ) + ( D():Get( "AlbCliI", nView ) )->cSufAlb == cAlbaran ) .and. ( D():Get( "AlbCliI", nView ) )->( !eof() )
               dbPass( D():Get( "AlbCliI", nView ), dbfTmpInc, .t. )
               ( D():Get( "AlbCliI", nView ) )->( dbSkip() )
            end while
         end if

         ( dbfTmpInc )->( dbGoTop() )

      else

         lErrors     := .t.

      end if

      // A¤adimos desde el fichero de situaiones

      dbCreate( cTmpEst, aSqlStruct( aAlbCliEst() ), cLocalDriver() )
      dbUseArea( .t., cLocalDriver(), cTmpEst, cCheckArea( cDbfEst, @dbfTmpEst ), .f. )
      if !NetErr()

         ( dbfTmpEst )->( ordCreate( cTmpEst, "nNumAlb", "cSerAlb + str( nNumAlb ) + cSufAlb + dtos( dFecSit )  + tFecSit", {|| Field->cSerAlb + str( Field->nNumAlb ) + Field->cSufAlb + dtos( Field->dFecSit )  + Field->tFecSit } ) )
         ( dbfTmpEst )->( ordListAdd( cTmpEst ) )

         if ( nMode != DUPL_MODE ) .and. ( D():AlbaranesClientesSituaciones( nView ) )->( dbSeek( cAlbaran ) )

            while ( ( D():AlbaranesClientesSituaciones( nView ) )->cSerAlb + Str( ( D():AlbaranesClientesSituaciones( nView ) )->nNumAlb ) + ( D():AlbaranesClientesSituaciones( nView ) )->cSufAlb == cAlbaran ) .and. ( D():AlbaranesClientesSituaciones( nView ) )->( !eof() ) 
               dbPass( D():AlbaranesClientesSituaciones( nView ), dbfTmpEst, .t. )
               ( D():AlbaranesClientesSituaciones( nView ) )->( dbSkip() )
            end while

         end if

         ( dbfTmpEst )->( dbGoTop() )

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

         if ( nMode != DUPL_MODE ) .and. ( D():Get( "AlbCliD", nView ) )->( dbSeek( cAlbaran ) )
            while ( ( D():Get( "AlbCliD", nView ) )->cSerAlb + Str( ( D():Get( "AlbCliD", nView ) )->nNumAlb ) + ( D():Get( "AlbCliD", nView ) )->cSufAlb == cAlbaran ) .and. ( D():Get( "AlbCliD", nView ) )->( !eof() )
               dbPass( D():Get( "AlbCliD", nView ), dbfTmpDoc, .t. )
               ( D():Get( "AlbCliD", nView ) )->( dbSkip() )
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

         if ( nMode != DUPL_MODE ) .and. ( D():Get( "AlbCliS", nView ) )->( dbSeek( cAlbaran ) )
            while ( ( D():Get( "AlbCliS", nView ) )->cSerAlb + Str( ( D():Get( "AlbCliS", nView ) )->nNumAlb ) + ( D():Get( "AlbCliS", nView ) )->cSufAlb == cAlbaran ) .and. !( D():Get( "AlbCliS", nView ) )->( eof() )
               dbPass( D():Get( "AlbCliS", nView ), dbfTmpSer, .t. )
               ( D():Get( "AlbCliS", nView ) )->( dbSkip() )
            end while
         end if

         ( dbfTmpSer )->( dbGoTop() )

         oStock:SetTmpAlbCliS( dbfTmpSer )

      else

         lErrors     := .t.

      end if

   /*
   Metemos los temporales de los campos extra----------------------------------
   */

   oDetCamposExtra:SetTemporal( aTmp[ _CSERALB ] + Str( aTmp[ _NNUMALB ] ) + aTmp[ _CSUFALB ], "", nMode )

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

   local nTotAlbCli     := nTotAlbCli( nil, D():Get( "AlbCliT", nView ), dbfTmpLin, D():Get( "TIva", nView ), D():Get( "Divisas", nView ), aTmpAlb )
   local nEntAlbCli     := nPagAlbCli( nil, dbfTmpPgo, D():Get( "Divisas", nView ) )

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
      oGetRnt:SetText( AllTrim( Trans( nTotRnt, cPorDiv ) + Space( 1 ) + AllTrim( cSimDiv( aTmpAlb[ _CDIVALB ], D():Get( "Divisas", nView ) ) ) + " : " + AllTrim( Trans( nPctRnt, "999.99" ) ) + "%" ) )
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

STATIC FUNCTION LoaCli( aGet, aTmp, nMode )

   local lValid      := .t.
   local cNewCodCli  := aGet[ _CCODCLI ]:varGet()
   local lChgCodCli  := ( empty( cOldCodCli ) .or. cOldCodCli != cNewCodCli )

   if empty( cNewCodCli )
      Return .t.
   elseif At( ".", cNewCodCli ) != 0
      cNewCodCli     := PntReplace( aGet[ _CCODCLI ], "0", RetNumCodCliEmp() )
   else
      cNewCodCli     := Rjust( cNewCodCli, "0", RetNumCodCliEmp() )
   end if

   /*
   Calculo del reisgo del cliente----------------------------------------------
   */

   if ( D():Get( "Client", nView ) )->( dbSeek( cNewCodCli ) )

      if !( isAviableClient( nView, nMode ) )
         return .f.
      end if

      /*
      Asignamos el codigo siempre
      */

      aGet[ _CCODCLI ]:cText( ( D():Get( "Client", nView ) )->Cod )

      if oTlfCli != nil
         oTlfCli:SetText( ( D():Get( "Client", nView ) )->Telefono )
      end if

      /*
      Color de fondo del cliente
      */

      if ( D():Get( "Client", nView ) )->nColor != 0
         aGet[_CNOMCLI]:SetColor( , ( D():Get( "Client", nView ) )->nColor )
      end if

      if empty( aGet[_CNOMCLI]:varGet() ) .or. lChgCodCli
         aGet[_CNOMCLI]:cText( ( D():Get( "Client", nView ) )->Titulo )
      end if

      if empty( aGet[_CDIRCLI]:varGet() ) .or. lChgCodCli
         aGet[_CDIRCLI]:cText( ( D():Get( "Client", nView ) )->Domicilio )
      end if

      if empty( aGet[ _CTLFCLI ]:varGet() ) .or. lChgCodCli
         aGet[ _CTLFCLI ]:cText( ( D():Get( "Client", nView ) )->Telefono )
      end if

      if empty( aGet[_CPOBCLI]:varGet() ) .or. lChgCodCli
         aGet[_CPOBCLI]:cText( ( D():Get( "Client", nView ) )->Poblacion )
      end if

      if !empty( aGet[_CPRVCLI] )
         if empty( aGet[_CPRVCLI]:varGet() ) .or. lChgCodCli
            aGet[_CPRVCLI]:cText( ( D():Get( "Client", nView ) )->Provincia )
         end if
      end if

      if !empty( aGet[_CPOSCLI] )
         if empty( aGet[_CPOSCLI]:varGet() ) .or. lChgCodCli
            aGet[_CPOSCLI]:cText( ( D():Get( "Client", nView ) )->CodPostal )
         end if
      end if

      if !empty( aGet[_CDNICLI] )
         if empty( aGet[_CDNICLI]:varGet() ) .or. lChgCodCli
            aGet[_CDNICLI]:cText( ( D():Get( "Client", nView ) )->Nif )
         end if
      end if

      if empty( aTmp[_CCODGRP] ) .or. lChgCodCli
         aTmp[_CCODGRP]    := ( D():Get( "Client", nView ) )->cCodGrp
      end if

      // Calculo del reisgo del cliente-------------------------------------

      showClienteRiesgo( ( D():Get( "Client", nView ) )->Cod, ( D():Get( "Client", nView ) )->Riesgo, oRieCli )

      // Si ha cambiado el cliente---------------------------------------------

      if ( lChgCodCli )

         // Calculo del reisgo del cliente-------------------------------------

         showClienteRiesgo( ( D():Get( "Client", nView ) )->Cod, ( D():Get( "Client", nView ) )->Riesgo, oRieCli )

         // Cargamos la obra por defecto---------------------------------------

         if !empty( aGet[ _CCODOBR ] )

            if dbSeekInOrd( cNewCodCli, "lDefObr", dbfObrasT )
               aGet[ _CCODOBR ]:cText( ( dbfObrasT )->cCodObr )
            else
               aGet[ _CCODOBR ]:cText( Space( 10 ) )
            end if

            aGet[ _CCODOBR ]:lValid()

         end if

         aTmp[ _LMODCLI ]  := ( D():Get( "Client", nView ) )->lModDat

         aTmp[ _LOPERPV ]  := ( D():Get( "Client", nView ) )->lPntVer

      end if

      if nMode == APPD_MODE

         aTmp[ _NREGIVA ]  := ( D():Get( "Client", nView ) )->nRegIva

         if !empty( aGet[ _NREGIVA ] )
            aGet[ _NREGIVA ]:Refresh()
         end if

         lChangeRegIva( aTmp )

         /*
         Si estamos a¤adiendo cargamos todos los datos del cliente
         */

         if empty( aTmp[ _CSERALB ] )

            if !empty( ( D():Get( "Client", nView ) )->Serie )
               aGet[ _CSERALB ]:cText( ( D():Get( "Client", nView ) )->Serie )
            end if

         else

            if !empty( ( D():Get( "Client", nView ) )->Serie )                .and.;
               aTmp[ _CSERALB ] != ( D():Get( "Client", nView ) )->Serie      .and.;
               ApoloMsgNoYes( "La serie del cliente seleccionado es distinta a la anterior.", "¿Desea cambiar la serie?" )
               aGet[ _CSERALB ]:cText( ( D():Get( "Client", nView ) )->Serie )
            end if

         end if

         if !empty( aGet[_CCODALM] )
            if ( empty( aGet[_CCODALM]:varGet() ) .or. lChgCodCli ) .and. !empty( ( D():Get( "Client", nView ) )->cCodAlm )
                aGet[_CCODALM]:cText( ( D():Get( "Client", nView ) )->cCodAlm )
                aGet[_CCODALM]:lValid()
            end if
         end if

         if !empty( aGet[_CCODTAR] )
            if ( empty( aGet[_CCODTAR]:varGet() ) .or. lChgCodCli ) .and. !empty( ( D():Get( "Client", nView ) )->cCodTar )
               aGet[_CCODTAR]:cText( ( D():Get( "Client", nView ) )->CCODTAR )
               aGet[_CCODTAR]:lValid()
            end if
         end if

         if ( empty( aGet[_CCODPAGO]:varGet() ) .or. lChgCodCli ) .and. !empty( ( D():Get( "Client", nView ) )->CodPago )
            aGet[_CCODPAGO]:cText( (D():Get( "Client", nView ))->CODPAGO )
            aGet[_CCODPAGO]:lValid()
         end if

         /*
         Si la forma de pago es un movimiento bancario le asignamos el banco y cuenta por defecto
         */

         if ( lChgCodCli .and. lBancoDefecto( ( D():Get( "Client", nView ) )->Cod, dbfCliBnc ) )

            if !empty( aGet[ _CBANCO ] ) .or. lChgCodCli
               aGet[ _CBANCO ]:cText( ( dbfCliBnc )->cCodBnc )
               aGet[ _CBANCO ]:lValid()
            end if

            if !empty( aGet[ _CPAISIBAN ] ) .or. lChgCodCli
               aGet[ _CPAISIBAN ]:cText( ( dbfCliBnc )->cPaisIBAN )
               aGet[ _CPAISIBAN ]:lValid()
            end if

            if !empty( aGet[ _CCTRLIBAN ] ) .or. lChgCodCli
               aGet[ _CCTRLIBAN ]:cText( ( dbfCliBnc )->cCtrlIBAN )
               aGet[ _CCTRLIBAN ]:lValid()
            end if

            if !empty( aGet[ _CENTBNC ] ) .or. lChgCodCli
               aGet[ _CENTBNC ]:cText( ( dbfCliBnc )->cEntBnc )
               aGet[ _CENTBNC ]:lValid()
            end if

            if !empty( aGet[ _CSUCBNC ] ) .or. lChgCodCli
               aGet[ _CSUCBNC ]:cText( ( dbfCliBnc )->cSucBnc )
               aGet[ _CSUCBNC ]:lValid()
            end if

            if !empty( aGet[ _CDIGBNC ] ) .or. lChgCodCli
               aGet[ _CDIGBNC ]:cText( ( dbfCliBnc )->cDigBnc )
               aGet[ _CDIGBNC ]:lValid()
            end if

            if !empty( aGet[ _CCTABNC ] ) .or. lChgCodCli
               aGet[ _CCTABNC ]:cText( ( dbfCliBnc )->cCtaBnc )
               aGet[ _CCTABNC ]:lValid()
            end if

         end if

         if !empty( aGet[_CCODAGE] )
            if ( empty( aGet[_CCODAGE]:varGet() ) .or. lChgCodCli ) .and. !empty( ( D():Get( "Client", nView ) )->cAgente )
                aGet[_CCODAGE]:cText( (D():Get( "Client", nView ) )->CAGENTE )
                aGet[_CCODAGE]:lValid()
            end if
         end if

         if ( empty( aGet[_CCODRUT]:varGet() ) .or. lChgCodCli ) .and. !empty( ( D():Get( "Client", nView ) )->cCodRut )
            aGet[_CCODRUT]:cText( ( D():Get( "Client", nView ) )->CCODRUT )
            aGet[_CCODRUT]:lValid()
         end if

         if !empty( oGetTarifa )         
            if ( empty( oGetTarifa:varGet() ) .or. lChgCodCli ) .and. !empty( ( D():Clientes( nView ) )->nTarifa )
               oGetTarifa:setTarifa( ( D():Clientes( nView ) )->nTarifa )
            end if
         else
            aTmp[ _NTARIFA ]  := ( D():Clientes( nView ) )->nTarifa
         end if

         if ( empty( aTmp[ _NDTOTARIFA ] ) .or. lChgCodCli )
             aTmp[ _NDTOTARIFA ]    := ( D():Get( "Client", nView ) )->nDtoArt
         end if

         if !empty( aGet[ _CCODTRN ] ) .and. ( empty( aGet[ _CCODTRN ]:varGet() ) .or. lChgCodCli ) .and. !empty( ( D():Get( "Client", nView ) )->cCodTrn )
            aGet[ _CCODTRN ]:cText( ( D():Get( "Client", nView ) )->cCodTrn )
            aGet[ _CCODTRN ]:lValid()
         end if

         if lChgCodCli

            aGet[ _LRECARGO ]:Click( ( D():Get( "Client", nView ) )->lReq )
            aGet[ _LRECARGO ]:Refresh()

            aGet[ _LOPERPV  ]:Click( ( D():Get( "Client", nView ) )->lPntVer )
            aGet[ _LOPERPV  ]:Refresh()

            /*
            Descuentos desde la ficha de cliente----------------------------------
            */

            if !empty( aGet[ _CDTOESP ] )
               aGet[ _CDTOESP ]:cText( ( D():Get( "Client", nView ) )->cDtoEsp )
            else
               aTmp[ _CDTOESP ]  := ( D():Get( "Client", nView ) )->cDtoEsp
            end if

            if !empty( aGet[ _NDTOESP ] )
               aGet[ _NDTOESP ]:cText( ( D():Get( "Client", nView ) )->nDtoEsp )
            else
               aTmp[ _NDTOESP ]  := ( D():Get( "Client", nView ) )->nDtoEsp
            end if

            if !empty( aGet[ _CDPP    ] )
               aGet[ _CDPP    ]:cText( ( D():Get( "Client", nView ) )->cDpp )
            else
               aTmp[ _CDPP    ]  := ( D():Get( "Client", nView ) )->cDpp
            end if

            if !empty( aGet[ _NDPP    ] )
               aGet[ _NDPP    ]:cText( ( D():Get( "Client", nView ) )->nDpp )
            else
               aTmp[ _NDPP    ]  := ( D():Get( "Client", nView ) )->nDpp
            end if

            if !empty( aGet[ _CDTOUNO ] )
               aGet[ _CDTOUNO ]:cText( ( D():Get( "Client", nView ) )->cDtoUno )
            else
               aTmp[ _CDTOUNO ]  := ( D():Get( "Client", nView ) )->cDtoUno
            end if

            if !empty( aGet[ _CDTODOS ] )
               aGet[ _CDTODOS ]:cText( ( D():Get( "Client", nView ) )->cDtoDos )
            else
               aTmp[ _CDTODOS ]  := ( D():Get( "Client", nView ) )->cDtoDos
            end if

            if !empty( aGet[ _NDTOUNO ] )
               aGet[ _NDTOUNO ]:cText( ( D():Get( "Client", nView ) )->nDtoCnt )
            else
               aTmp[ _NDTOUNO ]  := ( D():Get( "Client", nView ) )->nDtoCnt
            end if

            if !empty( aGet[ _NDTODOS ] )
               aGet[ _NDTODOS ]:cText( ( D():Get( "Client", nView ) )->nDtoRap )
            else
               aTmp[ _NDTODOS ]  := ( D():Get( "Client", nView ) )->nDtoRap
            end if

            aTmp[ _NSBRATP ]  := ( D():Get( "Client", nView ) )->nSbrAtp

            aTmp[ _NDTOATP ]  := ( D():Get( "Client", nView ) )->nDtoAtp

         end if

      end if

      if lChgCodCli

         if ( D():Get( "Client", nView ) )->lMosCom .and. !empty( ( D():Get( "Client", nView ) )->mComent )
            MsgStop( Trim( ( D():Get( "Client", nView ) )->mComent ) )
         end if

         showIncidenciaCliente( ( D():Get( "Client", nView ) )->Cod, nView )

         if !( D():Get( "Client", nView ) )->lChgPre
            msgStop( "Este cliente no tiene autorización para venta a credito", "Imposible archivar como albarán" )
         end if

      end if

      cOldCodCli  := ( D():Get( "Client", nView ) )->Cod

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

STATIC FUNCTION SetDlgMode( aTmp, aTmpAlb, nMode, aGet, oFld, oSayPr1, oSayPr2, oSayVp1, oSayVp2, oStkAct, oTotal, oRentLin )

   local cCodArt        := left( aTmp[ _CREF ], 18 )

   if !empty(aGet)
   
      if !uFieldEmpresa( "lUseBultos" )
         aGet[ __NBULTOS ]:Hide()
      else
         if !empty( aGet[ __NBULTOS ] )
            aGet[ __NBULTOS ]:SetText( uFieldempresa( "cNbrBultos" ) )
         end if 
      end if

      if !lUseCaj()
         aGet[ _NCANENT ]:Hide()
      else
         if !empty( aGet[ _NCANENT ] )
            aGet[ _NCANENT ]:SetText( cNombreCajas() )
         end if
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

      if aTmp[ __LALQUILER ]
         aGet[ _NPREUNIT ]:Hide()
         aGet[ _NPREALQ  ]:Show()
      end if

   end if 

   if oRentLin != nil .and. SQLAjustableModel():getRolNoMostrarRentabilidad( Auth():rolUuid() )
      oRentLin:Hide()
   end if

   do case
   case nMode == APPD_MODE

      aTmp[ _CREF     ]       := space( 200 )
      aTmp[ _NCANENT  ]       := 1
      aTmp[ _NUNICAJA ]       := 1
      aTmp[ _LIVALIN  ]       := aTmpAlb[ _LIVAINC ]
      aTmp[ _DFECCAD  ]       := Ctod( "" )
      aTmp[ _NNUMLIN  ]       := nLastNum( dbfTmpLin )
      aTmp[ _NPOSPRINT]       := nLastNum( dbfTmpLin, "nPosPrint" )
      aTmp[ _CTIPMOV  ]       := cDefVta()
      aTmp[ _CALMLIN  ]       := aTmpAlb[ _CCODALM ] 
      aTmp[ __CCENTROCOSTE ]  := aTmpAlb[ _CCENTROCOSTE ] 

      if aTmpAlb[ _NREGIVA ] <= 2
         aTmp[ _NIVA  ]       := nIva( D():Get( "TIva", nView ), cDefIva() )
      end if 

      if !empty(aGet)

         aGet[ _CREF     ]:cText( aTmp[ _CREF ] )
         aGet[ _NCANENT  ]:cText( aTmp[ _NCANENT  ] )
         aGet[ _NUNICAJA ]:cText( aTmp[ _NUNICAJA ] )
         aGet[ _NPOSPRINT]:cText( aTmp[ _NPOSPRINT ] )
         aGet[ _CALMLIN  ]:cText( aTmp[ _CALMLIN  ] )
         aGet[ _NIVA     ]:cText( aTmp[ _NIVA] )

         aGet[ _LCONTROL ]:Click( .f. )
         aGet[ _CDETALLE ]:Show()
         aGet[ _MLNGDES  ]:Hide()
         aGet[ _CLOTE    ]:Hide()
         aGet[ _DFECCAD  ]:Hide()
         aGet[ __CCENTROCOSTE ]:cText( aTmp[ __CCENTROCOSTE ] )
         aGet[ __CCENTROCOSTE ]:lValid()

         cTipoCtrCoste        := "Centro de coste"
         oTipoCtrCoste:Refresh()
         clearGet( aGet[ _CTERCTR ] )

         if !empty( oStkAct )

            if !uFieldEmpresa( "lNStkAct" )
               oStkAct:Show()
               oStkAct:cText( 0 )
            else
               oStkAct:Hide()
            end if

         end if

      end if

   case ( nMode == DUPL_MODE .or. nMode == EDIT_MODE .OR. nMode == ZOOM_MODE )

      if !empty(aGet)

         if aTmp[ _LLOTE ]
            aGet[ _CLOTE ]:Show()
            aGet[ _DFECCAD ]:Show()
         else
            aGet[ _CLOTE ]:Hide()
            aGet[ _DFECCAD ]:Hide()
         end if

         if !empty( cCodArt )
            aGet[ _CDETALLE ]:show()
            aGet[ _MLNGDES  ]:hide()
         else
            aGet[ _CDETALLE ]:hide()
            aGet[ _MLNGDES  ]:show()
         end if

         if !empty( oStock )
            oStock:nPutStockActual( cCodArt, aTmp[ _CALMLIN ], aTmp[ _CVALPR1 ], aTmp[ _CVALPR2 ], aTmp[ _CLOTE ], aTmp[ _LKITART ], aTmp[ _NCTLSTK ], oStkAct )

            if uFieldEmpresa( "lNStkAct" )
               oStkAct:Hide()
            end if
         end if

         aGet[ __CCENTROCOSTE ]:lValid()

      end if 
      
   end case

   if !empty(aGet)

      if !empty( aTmp[ _CCODPR1 ] )

         aGet[ _CVALPR1 ]:Show()
         aGet[ _CVALPR1 ]:lValid()
         
         if !empty( oSayPr1 )
            oSayPr1:Show()
            oSayPr1:SetText( retProp( aTmp[_CCODPR1], dbfPro ) )
         end if

         if !empty( oSayVp1 )
            oSayVp1:Show()
         end if

      else

         aGet[ _CVALPR1 ]:hide()

         if !empty( oSayPr1 )
            oSayPr1:hide()
         end if

         if !empty( oSayVp1 )
            oSayVp1:hide()
         end if

      end if

      if !empty( aTmp[ _CCODPR2 ] )

         aGet[ _CVALPR2 ]:Show()
         aGet[ _CVALPR2 ]:lValid()

         if !empty( oSayPr2 )
            oSayPr2:Show()
            oSayPr2:SetText( retProp( aTmp[ _CCODPR2 ], dbfPro ) )
         end if

         if !empty( oSayVp2 )
            oSayVp2:Show()
         end if

      else

         aGet[ _CVALPR2 ]:hide()

         if !empty( oSayPr2 )
            oSayPr2:hide()
         end if
         
         if !empty( oSayVp2 )
            oSayVp2:hide()
         end if

      end if

      // Ocultamos el precio de costo------------------------------------------------

      if !lAccArticulo() .or. oUser():lNotCostos()
         aGet[ _NCOSDIV ]:Hide()
      end if 

      // Solo pueden modificar los precios los administradores-----------------------

      if ( empty( aTmp[ _NPREUNIT ] ) .or. ( SQLAjustableModel():getRolCambiarPrecios( Auth():rolUuid() ) ) ) .and. ( nMode != ZOOM_MODE )

         aGet[ _NPREUNIT ]:HardEnable()
         aGet[ _NIMPTRN  ]:HardEnable()
         aGet[ _NPNTVER  ]:HardEnable()
         aGet[ _NDTO     ]:HardEnable()
         aGet[ _NDTOPRM  ]:HardEnable()
         aGet[ _NDTODIV  ]:HardEnable()

      else

         aGet[ _NPREUNIT ]:HardDisable()
         aGet[ _NIMPTRN  ]:HardDisable()
         aGet[ _NPNTVER  ]:HardDisable()
         aGet[ _NDTO     ]:HardDisable()
         aGet[ _NDTOPRM  ]:HardDisable()
         aGet[ _NDTODIV  ]:HardDisable()

      end if

      // Ocultamos las tres unidades de medicion-------------------------------------

      aGet[ ( D():Get( "AlbCliL", nView ) )->( fieldpos( "nMedUno" ) ) ]:Hide()
      aGet[ ( D():Get( "AlbCliL", nView ) )->( fieldpos( "nMedDos" ) ) ]:Hide()
      aGet[ ( D():Get( "AlbCliL", nView ) )->( fieldpos( "nMedTre" ) ) ]:Hide()

      if oUndMedicion:oDbf:Seek( aTmp[ _CUNIDAD ] )

         aGet[ ( D():Get( "AlbCliL", nView ) )->( fieldpos( "nMedUno" ) ) ]:oSay:SetText( oUndMedicion:oDbf:cTextoDim1 )
         aGet[ ( D():Get( "AlbCliL", nView ) )->( fieldpos( "nMedUno" ) ) ]:Show()
         aGet[ ( D():Get( "AlbCliL", nView ) )->( fieldpos( "nMedDos" ) ) ]:oSay:SetText( oUndMedicion:oDbf:cTextoDim2 )
         aGet[ ( D():Get( "AlbCliL", nView ) )->( fieldpos( "nMedDos" ) ) ]:Show()
         aGet[ ( D():Get( "AlbCliL", nView ) )->( fieldpos( "nMedTre" ) ) ]:oSay:SetText( oUndMedicion:oDbf:cTextoDim3 )
         aGet[ ( D():Get( "AlbCliL", nView ) )->( fieldpos( "nMedTre" ) ) ]:Show()

      end if

   end if 

   // Mostramos u ocultamos las tarifas por líneas--------------------------------

   if empty( aTmp[ _NTARLIN ] )

      aTmp[ _NTARLIN  ]       := oGetTarifa:getTarifa()

      if !empty( aGet )
         aGet[ _NTARLIN ]:cText( aTmp[ _NTARLIN ] )
      end if

   end if

   if !empty( aGet )
      if !uFieldEmpresa( "lPreLin" )
         aGet[ _NTARLIN ]:Hide()
      else
         aGet[ _NTARLIN ]:Show()
      end if
   end if

   // Focus y validaci¢n----------------------------------------------------------

   if !empty( oTotal )
      oTotal:cText( 0 )
   end if

   // Empieza la edicion-------------------------------------------------------

   if !empty( oFld )
      oFld:SetOption( 1 )
   end if

   // Propiedades--------------------------------------------------------------

   hidePropertiesTable( oBrwProperties )

   // Focus al codigo-------------------------------------------------------------

   if !empty( aGet )
      aGet[ _CALMLIN ]:lValid()
      aGet[ _CCODPRV ]:lValid()
      aGet[ _COBRLIN ]:lValid()      
      aGet[ _CREF    ]:SetFocus()
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
   local nBase       := 0
   local nComision   := 0

   DEFAULT lTotal    := .f.

   if aTmp[ __LALQUILER ]
      nCalculo       := aTmp[ _NPREALQ  ]
   else
      nCalculo       := aTmp[ _NPREUNIT  ]
   end if

   nCalculo          -= aTmp[ _NDTODIV  ]

   /*
   Unidades
   */

   nUnidades         := nTotNAlbCli( aTmp )

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
      nBase          := nCalculo - Round( nCalculo / ( 100 / aTmp[ _NIVA ] + 1 ), nRouDiv )
   else
      nBase          := nCalculo
   end if

   nComision         := ( nBase * aTmp[ _NCOMAGE ] / 100 )

   nMargen           := nBase - nComision - nCosto

   if nCalculo == 0
      nRentabilidad  := 0
   else
      nRentabilidad  := nRentabilidad( nBase - nComision, 0, nCosto )
   end if

   /*
   Punto Verde-----------------------------------------------------------------
   */

   if aTmpAlb[ _LOPERPV ]
      nCalculo       += nUnidades * aTmp[ _NPNTVER ]
   end if

   if !empty( oTotal )
      oTotal:cText( Round( nCalculo, nDouDiv ) )
   end if

   if oMargen != nil
      oMargen:cText( AllTrim( Trans( nMargen, cPorDiv ) + AllTrim( cSimDiv( cCodDiv, D():Get( "Divisas", nView ) ) ) + " : " + AllTrim( Trans( nRentabilidad, "999.99" ) ) + "%" ) )
   end if

   if !empty( oComisionLinea )
      oComisionLinea:cText( Round( ( nBase * aTmp[ _NCOMAGE ] / 100 ), nRouDiv ) )
   end if

RETURN ( if( !lTotal, .t., nCalculo ) )

//--------------------------------------------------------------------------//
/*
Funcion Auxiliar para A¤adir lineas de detalle a un albaran
*/

STATIC FUNCTION AppDeta( oBrwLin, bEdtDet, aTmpAlb, lTot, nMode, cCodArt )

   DEFAULT lTot := .f.

   WinAppRec( oBrwLin, bEdtDet, dbfTmpLin, lTot, cCodArt, aTmpAlb )

RETURN ( RecalculaTotal( aTmpAlb ) )

//---------------------------------------------------------------------------//

STATIC FUNCTION LoaArt( cCodArt, aTmp, aGet, aTmpAlb, oStkAct, oSayPr1, oSayPr2, oSayVp1, oSayVp2, bmpImage, nMode, lFocused )

   local hHas128
   local cLote
   local dFechaCaducidad
   local nDtoAge
   local cCodFam
   local cPrpArt
   local nCosPro
   local cValPr1                 := ""
   local cValPr2                 := ""  
   local cProveedor
   local nPrePro                 := 0
   local nImpAtp                 := 0
   local nImpOfe                 := 0
   local nNumDto                 := 0
   local nTarOld                 := aTmp[ _NTARLIN ]
   local lChgCodArt              := ( empty( cOldCodArt ) .or. rtrim( cOldCodArt ) != rtrim( cCodArt ) )
   local lChgPrpArt              := ( cOldPrpArt != aTmp[ _CCODPR1 ] + aTmp[ _CCODPR2 ] + aTmp[ _CVALPR1 ] + aTmp[ _CVALPR2 ] )
   local lChgLotArt              := ( cOldLotArt != Rtrim( aTmp[ _CLOTE ] ) )
   local hAtipica
   local nUnidades               := 0

   DEFAULT lFocused              := .t.

   if empty( aTmp[ _DFECHA ] )
      aTmp[ _DFECHA ]            := GetSysDate()
   end if 

   if empty( aTmp[ _CTIPMOV ] )
      aTmp[ _CTIPMOV ]           := cDefVta()
   end if 

   if empty( aTmp[ _CALMLIN ] ) 
      aTmp[ _CALMLIN ]           := aTmpAlb[ _CCODALM ]
   end if 

   if empty( aTmp[ _LIVALIN ] ) 
      aTmp[ _LIVALIN ]           := aTmpAlb[ _LIVAINC ]
   end if 

   if empty( aTmp[ __CNUMPED ] ) 
      aTmp[ __CNUMPED ]          := aTmpAlb[ _CNUMPED ]
   end if 
      
   if empty( aTmp[ __DFECSAL ] ) 
      aTmp[ __DFECSAL ]          := aTmpAlb[ _DFECSAL ]
   end if 

   if empty( aTmp[ __DFECENT ] ) 
      aTmp[ __DFECENT ]          := aTmpAlb[ _DFECENTR ]
   end if 

   if empty( aTmp[ _COBRLIN ] ) 
      aTmp[ _COBRLIN ]           := aTmpAlb[ _CCODOBR ]
   end if 

   if empty( aTmp[ _NTARLIN ] ) .and. !empty( oGetTarifa:getTarifa() )
      aTmp[ _NTARLIN ]           := oGetTarifa:getTarifa()
   end if 

   if empty( aTmp[ _CALMLIN ] ) .and. !empty( oTipAlb )
      aTmp[ __LALQUILER ]        :=  ( oTipAlb:nAt == 2 )
   end if 

   if empty( cCodArt )

      if lRetCodArt()
         if !empty( aGet )
            msgstop( "No se pueden añadir líneas sin codificar" )
         end if 
         return .f.
      end if

      if empty( aTmp[ _NIVA ] )
         aGet[ _NIVA ]:bWhen     := {|| .t. }
      end if

      if !empty( aGet )
         aGet[ _CDETALLE ]:cText( Space( 50 ) )
         aGet[ _CDETALLE ]:bWhen    := {|| .t. }
         aGet[ _CDETALLE ]:Hide()
         aGet[ _MLNGDES  ]:Show()
         if lFocused 
           aGet[ _MLNGDES ]:SetFocus()
         end if
      end if 

      hidePropertiesTable( oBrwProperties )

   else

      if !empty(aGet)
         aGet[ _NIVA ]:bWhen  := {|| lModIva() }
      end if 

      // Buscamos codificacion GS1-128--------------------------------------------

      if Len( Alltrim( cCodArt ) ) > 18

         hHas128              := ReadHashCodeGS128( cCodArt )
         if !empty( hHas128 )

            cCodArt           := uGetCodigo( hHas128, "00" )
            
            if Empty( cCodArt )
               cCodArt        := uGetCodigo( hHas128, "01" )
            end if

            cLote             := Upper( uGetCodigo( hHas128, "10" ) )

            dFechaCaducidad   := uGetCodigo( hHas128, "15" )

            if Empty( dFechaCaducidad )
               dFechaCaducidad   := uGetCodigo( hHas128, "17" )
            end if

            nUnidades         := uGetCodigo( hHas128, "3103" )

         end if 

      end if

      cCodArt                 := cSeekCodebar( cCodArt, dbfCodebar, D():Articulos( nView ) )

      // Ahora buscamos por el codigo interno-------------------------------------

      if aSeekProp( @cCodArt, @cValPr1, @cValPr2, D():Articulos( nView ), dbfTblPro )

         if ( D():Articulos( nView ) )->lObs
            if !empty( aGet )
               msgstop( "Artículo catalogado como obsoleto" )
            end if
            return .f.
         end if

         if ( lChgCodArt )

            cCodArt              := ( D():Articulos( nView ) )->Codigo

            if !empty(aGet)
               aGet[ _CREF ]:cText( Padr( cCodArt, 200 ) )
            end if 
            aTmp[ _CREF ]        := cCodArt

            // Pasamos las referencias adicionales------------------------------

            aTmp[ _CREFAUX  ]    := ( D():Articulos( nView ) )->cRefAux
            aTmp[ _CREFAUX2 ]    := ( D():Articulos( nView ) )->cRefAux2

            if ( D():Articulos( nView ) )->lMosCom .and. !empty( ( D():Articulos( nView ) )->mComent )
               if !empty( aGet )
                  msgstop( trim( ( D():Articulos( nView ) )->mComent ) )
               end if 
            end if

            // Metemos el proveedor habitual--------------------------------------

            aTmp[ _CCODPRV  ]    := ( D():Articulos( nView ) )->cPrvHab   
            aTmp[ _CREFPRV  ]    := Padr( cRefPrvArt( aTmp[ _CREF ], ( D():Articulos( nView ) )->cPrvHab , dbfArtPrv ), 18 )
            aTmp[ _CDETALLE ]    := ( D():Articulos( nView ) )->Nombre
            aTmp[ _MLNGDES  ]    := ( D():Articulos( nView ) )->Nombre

            if !empty( aGet )
               aGet[ _CCODPRV  ]:cText( aTmp[ _CCODPRV ] )
               aGet[ _CCODPRV  ]:lValid()
               aGet[ _CDETALLE ]:show()
               aGet[ _MLNGDES  ]:hide()
               aGet[ _CDETALLE ]:cText( aTmp[ _CDETALLE ] )
               aGet[ _MLNGDES  ]:cText( aTmp[ _MLNGDES  ] )
            end if 

            // Ultima fecha de venta-------------------------------------------

            aTmp[ _DFECULTCOM ]  := dFechaUltimaVenta( aTmpAlb[ _CCODCLI ], aTmp[ _CREF ], D():Get( "AlbCliL", nView ), D():Get( "FacCliL", nView ), D():Get( "FacCliT", nView ), D():Get( "FacCliL", nView ), dbfTikL )
            aTmp[ _DUNIULTCOM ]  := nUnidadesUltimaVenta( aTmpAlb[ _CCODCLI ], aTmp[ _CREF ], D():Get( "AlbCliL", nView ), D():Get( "FacCliL", nView ), D():Get( "FacCliT", nView ), D():Get( "FacCliL", nView ), dbfTikL )

            // Buscamos la familia del articulo y anotamos las propiedades--------
   
            aTmp[ _CCODPR1 ]     := ( D():Articulos( nView ) )->cCodPrp1
            aTmp[ _CCODPR2 ]     := ( D():Articulos( nView ) )->cCodPrp2
   
            if !empty( aTmp[ _CCODPR1 ] ) .and. !empty( cValPr1 ) 
   
               aTmp[ _CVALPR1 ]  := cCodPrp( aTmp[ _CCODPR1 ], cValPr1, dbfTblPro ) 

               if !empty( aGet )
                  aGet[ _CVALPR1 ]:cText( aTmp[ _CVALPR1 ] )
                  aGet[ _CVALPR1 ]:lValid()
               end if
   
            end if
   
            if !empty( aTmp[ _CCODPR2 ] ) .and. !empty( cValPr2 ) 
   
               aTmp[ _CVALPR2 ]  := cCodPrp( aTmp[ _CCODPR2 ], cValPr2, dbfTblPro )
               
               if !empty( aGet )
                  aGet[ _CVALPR2 ]:cText( aTmp[ _CVALPR2 ] )
                  aGet[ _CVALPR2 ]:lValid()
               end if
   
            end if

            // Descripciones largas--------------------------------------------------

            if !empty( ( D():Articulos( nView ) )->Descrip )

               aTmp[ _MLNGDES ]  := ( D():Articulos( nView ) )->Descrip
               aTmp[ _DESCRIP ]  := ( D():Articulos( nView ) )->Descrip

               if !empty(aGet)
                  aGet[ _MLNGDES ]:cText( aTmp[ _MLNGDES ] )
                  aGet[ _DESCRIP ]:cText( aTmp[ _DESCRIP ] )
               end if

            end if 

            // Peso y volumen-----------------------------------------------------

            aTmp[ _NPESOKG ]        := ( D():Articulos( nView ) )->nPesoKg
            if !empty(aGet)
               aGet[ _NPESOKG ]:cText( aTmp[ _NPESOKG ] )
            end if

            aTmp[ _CPESOKG ]        := ( D():Articulos( nView ) )->cUndDim
            if !empty(aGet)
               aGet[ _CPESOKG ]:cText( aTmp[ _CPESOKG ] )
            end if

            aTmp[ _NVOLUMEN ]       := ( D():Articulos( nView ) )->nVolumen
            if !empty(aGet)
               aGet[ _NVOLUMEN ]:cText( aTmp[ _NVOLUMEN ] )
            end if

            aTmp[ _CUNIDAD ]        := ( D():Articulos( nView ) )->cUnidad
            if !empty(aGet)
               aGet[ _CUNIDAD ]:cText( aTmp[ _CUNIDAD ] )
               aGet[ _CUNIDAD ]:lValid()
            end if

            aTmp[ _CVOLUMEN ]       := ( D():Articulos( nView ) )->cVolumen
            if !empty(aGet)
               aGet[ _CVOLUMEN ]:cText( aTmp[ _CVOLUMEN ]  )
            end if

            // Cogemos las familias y los grupos de familias----------------------

            cCodFam              := ( D():Articulos( nView ) )->Familia

            if !empty( cCodFam )

               aTmp[ _CCODFAM ]  := cCodFam
               aTmp[ _CGRPFAM ]  := cGruFam( cCodFam, D():Familias( nView ) )

               if !empty(aGet)
                  aGet[ _CCODFAM ]:cText( aTmp[ _CCODFAM ] )
                  aGet[ _CCODFAM ]:lValid()
                  aGet[ _CGRPFAM ]:cText( aTmp[ _CGRPFAM ] )
                  aGet[ _CGRPFAM ]:lValid()
               end if

            else

               if !empty(aGet)
                  aGet[ _CCODFAM ]:cText( Space( 8 ) )
                  aGet[ _CCODFAM ]:lValid()
                  aGet[ _CGRPFAM ]:cText( Space( 3 ) )
                  aGet[ _CGRPFAM ]:lValid()
               end if

            end if

            // Tratamientos kits-----------------------------------------------------

            if ( D():Articulos( nView ) )->lKitArt

               aTmp[ _LKITART ]     := ( D():Articulos( nView ) )->lKitArt                                              // Marcamos como padre del kit
               aTmp[ _LIMPLIN ]     := lImprimirCompuesto( ( D():Articulos( nView ) )->Codigo, D():Articulos( nView ) ) // 1 Todos, 2 Compuesto
               aTmp[ _LKITPRC ]     := lPreciosCompuestos( ( D():Articulos( nView ) )->Codigo, D():Articulos( nView ) ) // 1 Todos, 2 Compuesto

               if lStockCompuestos( ( D():Articulos( nView ) )->Codigo, D():Articulos( nView ) )

                  aTmp[ _NCTLSTK ]  := ( D():Articulos( nView ) )->nCtlStock
                  if !empty(aGet)
                     aGet[ _NCTLSTK ]:SetOption( aTmp[ _NCTLSTK ] )
                  end if

               else

                  aTmp[ _NCTLSTK ]  := STOCK_NO_CONTROLAR
                  if !empty(aGet)
                     aGet[ _NCTLSTK ]:SetOption( STOCK_NO_CONTROLAR )
                  end if

               end if

            else

               aTmp[ _LIMPLIN ]     := .f.
               aTmp[ _NCTLSTK ]     := ( D():Articulos( nView ) )->nCtlStock

               if !empty(aGet)
                  aGet[ _NCTLSTK ]:setOption( aTmp[ _NCTLSTK ] )
               end if

            end if

            // Preguntamos si el regimen de impuestos es distinto de Exento-------------

            if aTmpAlb[ _NREGIVA ] <= 2

               aTmp[ _NIVA ]     := nIva( D():Get( "TIva", nView ), ( D():Articulos( nView ) )->TipoIva )
               aTmp[ _NREQ ]     := nReq( D():Get( "TIva", nView ), ( D():Articulos( nView ) )->TipoIva )

               if !empty( aGet )
                  aGet[ _NIVA ]:cText( aTmp[ _NIVA ] )
               end if 

            end if

            // Ahora recogemos el impuesto especial si lo hay------------------
            
            aTmp[ _CCODIMP ]     := ( D():Articulos( nView ) )->cCodImp

            if !empty(aGet)
               oNewImp:setCodeAndValue( aTmp[ _CCODIMP ], aGet[ _NVALIMP ] ) 
               aGet[ _NVALIMP ]:cText( aTmp[ _NVALIMP ] )
            else 
               oNewImp:setCodeAndValue( aTmp[ _CCODIMP ] ) 
               aTmp[ _NVALIMP ]  := aTmp[ _NVALIMP ] 
            end if 

            if !empty( ( D():Articulos( nView ) )->cCodImp )
               aTmp[ _LVOLIMP ]  := RetFld( ( D():Articulos( nView ) )->cCodImp, oNewImp:oDbf:cAlias, "lIvaVol" )
            end if

            // Cajas y unidades------------------------------------------------

            if ( D():Articulos( nView ) )->nCajEnt != 0

               aTmp[ _NCANENT ]  := ( D():Articulos( nView ) )->nCajEnt 
            
               if !empty( aGet )
                  aGet[ _NCANENT ]:Refresh()
               end if 
            
            end if

            if !Empty( nUnidades )
               aTmp[ _NUNICAJA ] := nUnidades
            end if

            if Empty( nUnidades ) .and. ( D():Articulos( nView ) )->nUniCaja != 0
               aTmp[ _NUNICAJA ] := ( D():Articulos( nView ) )->nUniCaja 
            end if

            if !empty( aGet )
               aGet[ _NUNICAJA ]:Refresh()
            end if 

            // Si la comisi¢n del articulo hacia el agente es distinto de cero----

            loadComisionAgente( aTmp, aGet, aTmpAlb )

            // No permitir venta sin stock----------------------------------------

            aTmp[ _LMSGVTA ]     := ( D():Articulos( nView ) )->lMsgVta
            aTmp[ _LNOTVTA ]     := ( D():Articulos( nView ) )->lNotVta

            if ( D():Articulos( nView ) )->lFacCnv
               aTmp[ _NFACCNV ]  := ( D():Articulos( nView ) )->nFacCnv
            end if

            // Tipo de articulo---------------------------------------------------

            aTmp[ _CCODTIP ]     := ( D():Articulos( nView ) )->cCodTip 

            if !empty( aGet )
               aGet[ _CCODTIP ]:cText( aTmp[ _CCODTIP ] )
            end if

            // Imagen del producto------------------------------------------------

            aTmp[ _CIMAGEN ]     := ( D():Articulos( nView ) )->cImagen

            if !empty(aGet)
               aGet[ _CIMAGEN ]:cText( aTmp[ _CIMAGEN ] )
            end if

            if !empty( bmpImage )
               if !empty( aTmp[ _CIMAGEN ] )
                  bmpImage:Show()
                  bmpImage:LoadBmp( cFileBitmap( cPatImg(), aTmp[ _CIMAGEN ] ) )
               else
                  bmpImage:Hide()
               end if
            end if

            aTmp[ _CCODPR1 ]   := ( D():Articulos( nView ) )->cCodPrp1
            aTmp[ _CCODPR2 ]   := ( D():Articulos( nView ) )->cCodPrp2

            // Comprobamos que tenga valores las propiedades----------------------

            if ( !empty( aGet ) )                                                                                                                       .and.;
               ( ( !empty( aTmp[ _CCODPR1 ] ) .and. empty( aTmp[ _CVALPR1 ] ) ) .or. ( !empty( aTmp[ _CCODPR2 ] ) .and. empty( aTmp[ _CVALPR2 ] ) ) )   .and.;
               ( uFieldEmpresa( "lUseTbl" ) )                                                                                                           .and.;
               ( nMode == APPD_MODE ) 

               aGet[ _NCANENT  ]:cText( 0 )
               aGet[ _NUNICAJA ]:cText( 0 )

               setPropertiesTable( cCodArt, aTmp[ _CCODPR1 ], aTmp[ _CCODPR2 ], aGet[ _NPREUNIT ], aGet[ _NUNICAJA ], oBrwProperties, nView )

            else 

               hidePropertiesTable( oBrwProperties )

               if !empty( aTmp[ _CCODPR1 ] )

                  if !empty(aGet)

                     aGet[ _CVALPR1 ]:Show()
                     if lFocused
                        aGet[ _CVALPR1 ]:SetFocus()
                     end if

                     if !empty( aTmp[ _CVALPR1 ] )
                        aGet[ _CVALPR1 ]:lValid()
                     end if 

                  end if

                  if !empty( oSayPr1 )
                     oSayPr1:SetText( retProp( ( D():Articulos( nView ) )->cCodPrp1, dbfPro ) )
                     oSayPr1:Show()
                  end if

                  if !empty( oSayVp1 )
                     oSayVp1:SetText( "" )
                     oSayVp1:Show()
                  end if

               else

                  if !empty(aGet)
                     aGet[ _CVALPR1 ]:hide()
                  end if

                  if !empty( oSayPr1 )
                     oSayPr1:hide()
                  end if

                  if !empty( oSayVp1 )
                     oSayVp1:hide()
                  end if

               end if

               if !empty( aTmp[ _CCODPR2 ] )

                  if !empty(aGet)

                     aGet[ _CVALPR2 ]:show()
                     
                     if !empty( aTmp[ _CVALPR2 ] )
                        aGet[ _CVALPR2 ]:lValid()
                     end if 

                  end if

                  if !empty( oSayPr2 )
                     oSayPr2:SetText( retProp( ( D():Articulos( nView ) )->cCodPrp2, dbfPro ) )
                     oSayPr2:show()
                  end if

                  if !empty( oSayVp2 )
                     oSayVp2:SetText( "" )
                     oSayVp2:Show()
                  end if

               else

                  if !empty(aGet)
                     aGet[ _CVALPR2 ]:hide()
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

         // He terminado de meter todo lo que no son precios----------------------
         // ahora es cuando meteré los precios con todas las opciones posibles----

         cPrpArt              := aTmp[ _CCODPR1 ] + aTmp[ _CCODPR2 ] + aTmp[ _CVALPR1 ] + aTmp[ _CVALPR2 ]

         if ( lChgCodArt ) .or. ( lChgPrpArt )

            // Tomamos el valor de la familia----------------------------------

            if nMode == APPD_MODE
               cCodFam        := RetFamArt( cCodArt, D():Articulos( nView ) )
            else
               cCodFam        := aTmp[ _CCODFAM ]
            end if

            // Inicializamos el descuento y el logico de oferta

            aTmp[ _NDTO ]     := 0
            if !empty( aGet )
               aGet[ _NDTO ]:cText( aTmp[ _NDTO ] )
            end if

            aTmp[ _NDTODIV ]  := 0
            if !empty( aGet )
               aGet[ _NDTODIV ]:cText( aTmp[ _NDTODIV ] )
            end if 

            aTmp[ _NDTOPRM ]  := 0  
            if !empty( aGet )
               aGet[ _NDTOPRM ]:cText( aTmp[ _NDTOPRM ] )
            end if

            aTmp[ _LLINOFE  ] := .f.

            // Tomamos el precio recomendado, el costo y el punto verde---------

            aTmp[ _NPVSATC ]  := ( D():Articulos( nView ) )->PvpRec

            aTmp[ _NPNTVER ]  := ( D():Articulos( nView ) )->nPntVer1 
            if !empty(aGet)
               aGet[ _NPNTVER ]:cText( aTmp[ _NPNTVER ] )
            end if
         
            // Descuento de artículo----------------------------------------------

            nNumDto              := RetFld( aTmpAlb[ _CCODCLI ], D():Get( "Client", nView ), "nDtoArt" )

            if nNumDto != 0
               aTmp[ _NDTO ]     := ( D():Articulos( nView ) )->( fieldGet( fieldPos( "nDtoArt" + alltrim( str( nNumDto ) ) ) ) )

               if !empty( aGet[ _NDTO ] )
                  aGet[ _NDTO ]:cText( aTmp[ _NDTO ] )
               end if

            end if

            // Vemos si hay descuentos en las familias----------------------------

            if aTmp[ _NDTO ] == 0

               aTmp[ _NDTO ]     := nDescuentoFamilia( cCodFam, D():Familias( nView ) )

               if !empty( aGet )
                  aGet[ _NDTO ]:cText( aTmp[ _NDTO ] )
               end if

            end if

            // Cargamos el codigo de las unidades---------------------------------
            
            aTmp[ _CUNIDAD ]     := ( D():Articulos( nView ) )->cUnidad
            if !empty( aGet )
               aGet[ _CUNIDAD ]:cText( aTmp[ _CUNIDAD ] )
            end if

            // Tomamos el precio del articulo dependiento de las propiedades---

            nPrePro              := nPrePro( aTmp[ _CREF ], aTmp[ _CCODPR1 ], aTmp[ _CVALPR1 ], aTmp[ _CCODPR2 ], aTmp[ _CVALPR2 ], aTmp[ _NTARLIN ], aTmpAlb[ _LIVAINC ], dbfArtDiv, dbfTarPreL, aTmpAlb[ _CCODTAR ] )

            if nPrePro == 0
               nPrePro           := nRetPreArt( aTmp[ _NTARLIN ], aTmpAlb[ _CDIVALB ], aTmpAlb[ _LIVAINC ], D():Articulos( nView ), D():Get( "Divisas", nView ), dbfKit, D():Get( "TIva", nView ) , , , oNewImp )
               aTmp[ _NPREUNIT ] := nPrePro
               if !empty( aGet )
                  aGet[ _NPREUNIT ]:cText( nPrePro )
               end if
            end if

            // Alquiler---------------------------------------------------------

            if aTmp[ __LALQUILER ]

               aTmp[ _NPREUNIT ] := 0 
               if !empty( aGet )
                  aGet[ _NPREUNIT ]:cText( aTmp[ _NPREUNIT ] )
               end if 

               aTmp[ _NPREALQ  ] := nPreAlq( aTmp[ _CREF ], aTmp[ _NTARLIN ], aTmpAlb[ _LIVAINC ], D():Articulos( nView ) ) 
               if !empty( aGet )
                  aGet[ _NPREALQ  ]:cText( aTmp[ _NPREALQ  ] )
               end if 

            end if

            SysRefresh()

            ValidaMedicion( aTmp, aGet )

         //end if

         // Precios por tarifas---------------------------------------------

         if !empty( aTmpAlb[ _CCODTAR ] )

            nImpOfe     := RetPrcTar( aTmp[ _CREF ], aTmpAlb[ _CCODTAR ], aTmp[ _CCODPR1 ], aTmp[ _CCODPR2 ], aTmp[ _CVALPR1 ], aTmp[ _CVALPR2 ], dbfTarPreL, aTmp[ _NTARLIN ] )
            if nImpOfe  != 0
               aTmp[ _NPREUNIT ]    := nImpOfe 
               if empty(aGet)
                  aGet[ _NPREUNIT ]:cText( nImpOfe )
               end if 
            end if

            // Descuento porcentual-----------------------------------------

            nImpOfe     := RetPctTar( aTmp[ _CREF ], aTmp[ _CCODFAM ], aTmpAlb[ _CCODTAR ], aTmp[ _CCODPR1 ], aTmp[ _CCODPR2 ], aTmp[ _CVALPR1 ], aTmp[ _CVALPR2 ], dbfTarPreL )
            if nImpOfe  != 0
               aTmp[ _NDTO ]     := nImpOfe 
               if empty(aGet)
                  aGet[ _NDTO ]:cText( aTmp[ _NDTO ] )
               end if
            end if

            // Descuento Lineal---------------------------------------------

            nImpOfe     := RetLinTar( aTmp[ _CREF ], aTmp[ _CCODFAM ], aTmpAlb[_CCODTAR], aTmp[_CCODPR1], aTmp[_CCODPR2], aTmp[_CVALPR1], aTmp[_CVALPR2], dbfTarPreL )
            if nImpOfe  != 0
               aTmp[ _NDTODIV ]  := nImpOfe 
               if empty(aGet)
                  aGet[ _NDTODIV ]:cText( aTmp[ _NDTODIV ] )
               end if
            end if

            // Comisión de agente-------------------------------------------

            nImpOfe     := RetComTar( aTmp[ _CREF ], aTmp[ _CCODFAM ], aTmpAlb[_CCODTAR], aTmp[_CCODPR1], aTmp[_CCODPR2], aTmp[_CVALPR1], aTmp[_CVALPR2], aTmpAlb[_CCODAGE], dbfTarPreL, dbfTarPreS )
            if nImpOfe  != 0
               aTmp[ _NCOMAGE ]  := nImpOfe 
               if !empty(aGet)
                  aGet[ _NCOMAGE ]:cText( aTmp[ _NCOMAGE ] )
               end if 
            end if

            //--Descuento de promocion--------------------------------------

            nImpOfe     := RetDtoPrm( aTmp[ _CREF ], aTmp[ _CCODFAM ], aTmpAlb[_CCODTAR], aTmp[_CCODPR1], aTmp[_CCODPR2], aTmp[_CVALPR1], aTmp[_CVALPR2], aTmpAlb[_DFECALB], dbfTarPreL )
            if nImpOfe  != 0
               aTmp[ _NDTOPRM ]  := nImpOfe 
               if !empty(aGet)
                  aGet[ _NDTOPRM ]:cText( aTmp[ _NDTOPRM ] )
               end if 
            end if

            // Descuento de promoci¢n para agente---------------------------

            nDtoAge     := RetDtoAge( aTmp[ _CREF ], aTmp[ _CCODFAM ], aTmpAlb[ _CCODTAR ], aTmp[ _CCODPR1 ], aTmp[ _CCODPR2 ], aTmp[ _CVALPR1 ], aTmp[ _CVALPR2 ], aTmpAlb[ _DFECALB ], aTmpAlb[ _CCODAGE ], dbfTarPreL, dbfTarPreS )
            if nDtoAge  != 0
               aTmp[ _NCOMAGE ]  := nDtoAge 
               if !empty(aGet)
                  aGet[ _NCOMAGE ]:cText( nDtoAge )
               end if 
            end if

         end if

         // Chequeamos las atipicas del cliente-----------------------------

         hAtipica       := hAtipica( hValue( aTmp, aTmpAlb ) )

         if !empty( hAtipica )

            if hhaskey( hAtipica, "nImporte" )
               if hAtipica[ "nImporte" ] != 0
                  aTmp[ _NPREUNIT ]    := hAtipica[ "nImporte" ] 
                  if empty(aGet)
                     aGet[ _NPREUNIT ]:cText( hAtipica[ "nImporte" ] )
                  end if 
               end if   
            end if

            if hhaskey( hAtipica, "nDescuentoPorcentual" )
               if hAtipica[ "nDescuentoPorcentual"] != 0
                  aTmp[ _NDTO ]        := hAtipica[ "nDescuentoPorcentual" ] 
                  if empty(aGet)
                     aGet[ _NDTO ]:cText( hAtipica[ "nDescuentoPorcentual" ] )   
                  end if 
               end if
            end if

            if hhaskey( hAtipica, "nDescuentoPromocional" )
               if hAtipica[ "nDescuentoPromocional" ] != 0
                  aTmp[ _NDTOPRM ]     := hAtipica[ "nDescuentoPromocional" ] 
                  if empty(aGet)
                     aGet[ _NDTOPRM ]:cText( hAtipica[ "nDescuentoPromocional" ] )
                  end if 
               end if   
            end if

            if hhaskey( hAtipica, "nComisionAgente" )
               if hAtipica[ "nComisionAgente" ] != 0
                  aTmp[ _NCOMAGE ]     := hAtipica[ "nComisionAgente" ] 
                  if !empty(aGet)
                     aGet[ _NCOMAGE ]:cText( hAtipica[ "nComisionAgente" ] )
                  end if 
               end if
            end if

            if hhaskey( hAtipica, "nDescuentoLineal" )
               if hAtipica[ "nDescuentoLineal" ] != 0
                  aTmp[ _NDTODIV ]     := hAtipica[ "nDescuentoLineal" ] 
                  if !empty(aGet)
                     aGet[ _NDTODIV ]:cText( hAtipica[ "nDescuentoLineal" ] )
                  end if 
               end if
            end if

         end if

         end if

         SysRefresh()

         // Solo si cambia el lote, cargamos la fecha de caducidad y el costo--

         if ( lChgCodArt ) .or. ( lChgLotArt )

            // Lotes-----------------------------------------------------------

            if ( D():Articulos( nView ) )->lLote

               aTmp[ _LLOTE ]       := ( D():Articulos( nView ) )->lLote

               if empty( cLote )
                  cLote             := ( D():Articulos( nView ) )->cLote
               end if 

               if !empty( aGet )

                  aGet[ _CLOTE ]:Show()

                  if empty( aGet[ _CLOTE ]:varGet() )
                     aGet[ _CLOTE ]:cText( cLote )
                  end if

               else

                  if empty( aTmp[ _CLOTE ] )
                     aTmp[ _CLOTE ]    := cLote 
                  end if

               end if

               // Fecha de caducidad-------------------------------------------

               if empty( dFechaCaducidad )
                  dFechaCaducidad      := dFechaCaducidadLote( aTmp[ _CREF ], aTmp[ _CVALPR1 ], aTmp[ _CVALPR2 ], aTmp[ _CLOTE ], dbfAlbPrvL, dbfFacPrvL, dbfProLin )
               end if 

               if !empty( aGet )
                  aGet[ _DFECCAD ]:Show()
                  if empty( aGet[ _DFECCAD ]:varget() ) .or. ( dFechaCaducidad != dOldFecCad )
                     aGet[ _DFECCAD ]:cText( dFechaCaducidad )
                  end if
               else 
                  if empty( aTmp[ _DFECCAD ] )
                     aTmp[ _DFECCAD ]  := dFechaCaducidad
                  end if
               end if

            else

               if !empty( aGet )
                  aGet[ _CLOTE   ]:Hide()
                  aGet[ _DFECCAD ]:Hide()
               end if

            end if

            // Cargamos los costos---------------------------------------------

            if !uFieldEmpresa( "lCosAct" )
               nCosPro           := oStock:nCostoMedio( aTmp[ _CREF ], aTmp[ _CALMLIN ], aTmp[ _CCODPR1 ], aTmp[ _CCODPR2 ], aTmp[ _CVALPR1 ], aTmp[ _CVALPR2 ], aTmp[ _CLOTE ] )

               if nCosPro == 0
                  nCosPro        := nCosto( aTmp[ _CREF ], D():Articulos( nView ), dbfKit, .f., , D():Get( "Divisas", nView ) )
               end if
            else
               nCosPro           := nCosto( aTmp[ _CREF ], D():Articulos( nView ), dbfKit, .f., , D():Get( "Divisas", nView ) )
            end if

            aTmp[ _NCOSDIV ]     := nCosPro

            if !empty( aGet )
               aGet[ _NCOSDIV ]:cText( nCosPro )
            end if

         end if 

         // Calculamos el stock del articulo solo si cambian las prop o el lote---

         if ( lChgCodArt ) .or. ( lChgPrpArt ) .or. ( lChgLotArt )

            if !uFieldempresa( "lNStkAct") .and. oStkAct != nil .and. aTmp[ _NCTLSTK ] <= 1
               oStock:nPutStockActual( aTmp[ _CREF ], aTmp[ _CALMLIN ],aTmp[ _CVALPR1 ], aTmp[ _CVALPR2 ], aTmp[ _CLOTE ], aTmp[ _LKITART ], aTmp[ _NCTLSTK ], oStkAct )
            end if

         end if 

         // Buscamos si hay ofertas--------------------------------------------

         lBuscaOferta( aTmp[ _CREF ], aGet, aTmp, aTmpAlb, dbfKit )

         // Cargamos los valores para los cambios------------------------------

         cOldPrpArt     := cPrpArt
         cOldCodArt     := cCodArt
         dOldFecCad     := dFechaCaducidad
         cOldLotArt     := aTmp[ _CLOTE ]

         if !empty(aGet)

            if !empty( aGet[ _NPREUNIT ] )
               aGet[ _NPREUNIT ]:Refresh()
            end if

            if !empty( aGet[ _NDTO ] )
               aGet[ _NDTO ]:Refresh()
            end if

         end if 

         // Solo pueden modificar los precios los administradores--------------

         if !empty(aGet)

            if ( empty( aTmp[ _NPREUNIT ] ) .or. ( SQLAjustableModel():getRolCambiarPrecios( Auth():rolUuid() ) ) ) .and. ( nMode != ZOOM_MODE )
               aGet[ _NPREUNIT ]:HardEnable()
               aGet[ _NIMPTRN  ]:HardEnable()
               aGet[ _NPNTVER  ]:HardEnable()
               aGet[ _NDTO     ]:HardEnable()
               aGet[ _NDTOPRM  ]:HardEnable()
               aGet[ _NDTODIV  ]:HardEnable()
            else
               aGet[ _NPREUNIT ]:HardDisable() 
               aGet[ _NIMPTRN  ]:HardDisable()
               aGet[ _NPNTVER  ]:HardDisable()
               aGet[ _NDTO     ]:HardDisable()
               aGet[ _NDTOPRM  ]:HardDisable()
               aGet[ _NDTODIV  ]:HardDisable()
            end if
         end if 

      else
         
         if !empty( aGet )
            msgStop( "Artículo no encontrado." )
         end if 
         
         Return ( .f. )

      end if

   end if

Return ( .t. )

//--------------------------------------------------------------------------//

STATIC FUNCTION SaveDeta( aTmp, aTmpAlb, oFld, aGet, oBrw, bmpImage, oDlg, nMode, oSayPr1, oSayPr2, oSayVp1, oSayVp2, oStkAct, nStkAct, oTotal, cCodArt, oBtn, oBtnSer )

   local n 
   local i
   local aClo     
   local nTotUnd 
   local hAtipica 
   local lBeforeAppendEvent
   local nPrecioPropiedades   := 0

   if !empty(oBtn)
      oBtn:SetFocus()
   end if 

   /*if !empty(aGet) .and. !( aGet[ _CREF ]:lValid() )
      return nil
   end if*/

   if !lMoreIva( aTmp[ _NIVA ] )
      return nil
   end if

   if empty( aTmp[ _CALMLIN ] )
      msgStop( "Código de almacen no puede estar vacio" )
      if !empty(aGet)
         aGet[ _CALMLIN ]:SetFocus()
      end if 
      return nil
   end if

   if !lValidAlmacen( aTmp[ _CALMLIN ], dbfAlm )
      return nil
   end if

   // control de precios minimos-----------------------------------------------

   if lPrecioMinimo( aTmp[ _CREF ], aTmp[ _NPREUNIT ], nMode, D():Articulos( nView ) )
      msgStop( "El precio de venta es inferior al precio mínimo.")
      return nil
   end if 

   // Comprobamos si tiene que introducir números de serie------------------------

   if ( nMode == APPD_MODE ) .and. RetFld( aTmp[ _CREF ], D():Articulos( nView ), "lNumSer" ) .and. !( dbfTmpSer )->( dbSeek( Str( aTmp[ _NNUMLIN ], 4 ) + aTmp[ _CREF ] ) )
      MsgStop( "Tiene que introducir números de serie para este artículo." )
      if !empty(oBtnSer)
         oBtnSer:Click()
      end if 
      return nil 
   end if

   if !empty( aTmp[ _CREF ] ) .and. ( aTmp[ _LNOTVTA ] .or. aTmp[ _LMSGVTA ] )

      nTotUnd     := nTotNAlbCli( aTmp )

      if nMode == EDIT_MODE
         nTotUnd  -= nTotNAlbCli( dbfTmpLin )
      end if

      if !lCompruebaStock( aTmp, oStock, nTotUnd, nStkAct )
         return nil
      end if   

   end if

   // lanzamos los scripts-----------------------------------------------------

   if ( nMode == APPD_MODE .or. nMode == DUPL_MODE )

      if isfalse( runEventScript( "AlbaranesClientes\Lineas\beforeAppend", aTmp, aTmpAlb, nView, dbfTmpLin ) )
         Return .f.
      end if

   end if

   // comenzamos a grabar el registro------------------------------------------

   CursorWait()

   aTmp[ _CTIPCTR ]  := cTipoCtrCoste

   aTmp[ _NREQ ]     := nPReq( D():Get( "TIva", nView ), aTmp[ _NIVA ] )

   aClo              := aClone( aTmp )

   // si estamos añadiendo-----------------------------------------------------

   if nMode == APPD_MODE

      if aTmp[ _LLOTE ]
         saveLoteActual( aTmp[ _CREF ], aTmp[ _CLOTE ], nView )
      end if

      // Propiedades ----------------------------------------------------------

      if !empty( oBrwProperties ) .and. !empty( oBrwProperties:Cargo )

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

                  nPrecioPropiedades   := nPrePro( aTmp[ _CREF ], aTmp[ _CCODPR1 ], aTmp[ _CVALPR1 ], aTmp[ _CCODPR2 ], aTmp[ _CVALPR2 ], aTmp[ _NTARLIN ], aTmpAlb[ _LIVAINC ], dbfArtDiv, dbfTarPreL, aTmpAlb[ _CCODTAR ] )
                  if !empty(nPrecioPropiedades)
                     aTmp[ _NPREUNIT ] := nPrecioPropiedades
                  end if 

                  // guarda la linea------------------------------------------- 

                  saveDetail( aTmp, aClo, aGet, aTmpAlb, dbfTmpLin, oBrw, nMode )

               end if

            next

         next

         aCopy( dbBlankRec( dbfTmpLin ), aTmp )

         if !empty(aGet)
            aeval( aGet, {| o, i | if( "GET" $ o:className(), o:cText( aTmp[ i ] ), ) } )
         end if

      else

        saveDetail( aTmp, aClo, aGet, aTmpAlb, dbfTmpLin, oBrw, nMode )

      end if

   else

      // Guardamos el registro de manera normal--------------------------------

      WinGather( aTmp, aGet, dbfTmpLin, oBrw, nMode )

   end if

   if nMode == APPD_MODE
      oLinDetCamposExtra:SaveTemporalAppend( ( dbfTmpLin )->( OrdKeyNo() ) )
   end if

   // Liberacion del bitmap----------------------------------------------------

   if !empty( bmpImage )
       bmpImage:Hide()
       PalBmpFree( bmpImage:hBitmap, bmpImage:hPalette )
   end if

   // Limpiamos varaibles para posteriro uso----------------------------------- 

   cOldCodArt     := ""
   cOldUndMed     := ""

   if nMode == APPD_MODE .and. lEntCon()

      recalculaTotal( aTmpAlb )

      acopy( dbBlankRec( dbfTmpLin ), aTmp )

      if !empty( aGet )
         aeval( aGet, {| o, i | if( "GET" $ o:ClassName(), o:cText( aTmp[ i ] ), ) } )
      end if 

      setDlgMode( aTmp, aTmpAlb, nMode, aGet, oFld, oSayPr1, oSayPr2, oSayVp1, oSayVp2, oStkAct, oTotal )

      if !empty( aGet ) .and. !empty( aGet[ _CREF ] )
         aGet[ _CREF ]:SetFocus()
      end if

      sysRefresh()

   else

      if !empty( oDlg ) 
         oDlg:End( IDOK )
      end if 

   end if

   CursorWE()

RETURN NIL

//--------------------------------------------------------------------------//

Static Function saveDetail( aTmp, aClo, aGet, aTmpAlb, dbfTmpLin, oBrw, nMode )

   local hAtipica
   local sOfertaArticulo
   local nCajasGratis         := 0
   local nUnidadesGratis      := 0

   // Atipicas ----------------------------------------------------------------

   hAtipica                   := hAtipica( hValue( aTmp, aTmpAlb ) )

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
      
      sOfertaArticulo         := structOfertaArticulo( D():getHashArray( aTmpAlb, "AlbCliT", nView ), D():getHashArray( aTmp, "AlbCliL", nView ), nTotLAlbCli( aTmp ), nView )

      if !empty( sOfertaArticulo ) 
         nCajasGratis         := sOfertaArticulo:nCajasGratis
         nUnidadesGratis      := sOfertaArticulo:nUnidadesGratis
      end if
   end if 

   // Cajas gratis ---------------------------------------------------------

   if nCajasGratis != 0
      aTmp[ _LLINOFE ]        := .t.
      aTmp[ _NCANENT ]        -= nCajasGratis
      commitDetail( aTmp, aClo, nil, aTmpAlb, dbfTmpLin, oBrw, nMode )

      aTmp[ _LLINOFE ]        := .t.
      aTmp[ _NCANENT ]        := nCajasGratis
      aTmp[ _NPREUNIT]        := 0
      aTmp[ _NDTO    ]        := 0
      aTmp[ _NDTODIV ]        := 0
      aTmp[ _NDTOPRM ]        := 0
      aTmp[ _NCOMAGE ]        := 0
   end if 

   // unidades gratis ---------------------------------------------------------

   if nUnidadesGratis != 0
      aTmp[ _LLINOFE ]        := .t.
      aTmp[ _NUNICAJA]        -= nUnidadesGratis 

      commitDetail( aTmp, aClo, nil, aTmpAlb, dbfTmpLin, oBrw, nMode )

      aTmp[ _LLINOFE ]        := .t.
      aTmp[ _NUNICAJA]        := nUnidadesGratis 
      aTmp[ _NPREUNIT]        := 0
      aTmp[ _NDTO    ]        := 0
      aTmp[ _NDTODIV ]        := 0
      aTmp[ _NDTOPRM ]        := 0
      aTmp[ _NCOMAGE ]        := 0
   end if 

   commitDetail( aTmp, aClo, aGet, aTmpAlb, dbfTmpLin, oBrw, nMode )

Return nil

//--------------------------------------------------------------------------//

Static Function commitDetail( aTmp, aClo, aGet, aTmpAlb, dbfTmpLin, oBrw, nMode )

   winGather( aTmp, aGet, dbfTmpLin, oBrw, nMode, nil, .f. )

   if ( nMode == APPD_MODE ) .and. ( aClo[ _LKITART ] )
      appendKit( aClo, aTmpAlb )
   end if

Return nil

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
   local nPosPrint
   local nRecAct                       := ( dbfKit    )->( RecNo() )
   local nRecLin                       := ( dbfTmpLin )->( RecNo() )
   local nUnidades                     := 0
   local nStkActual                    := 0
   local nStockMinimo                  := 0

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
      nPosPrint                        := uTmpLin[ _NPOSPRINT ]
      cNumPed                          := uTmpLin[ __CNUMPED]
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
      nPosPrint                        := ( uTmpLin )->nPosPrint
      cNumPed                          := ( uTmpLin )->cNumPed
      nTarLin                          := ( uTmpLin )->nTarLin
   end if

   /*
   Guardamos los productos kits------------------------------------------------
   */

   if ( dbfKit )->( dbSeek( cCodArt ) )

      while ( dbfKit )->cCodKit == cCodArt .and. !( dbfKit )->( eof() )

         if ( D():Articulos( nView ) )->( dbSeek( ( dbfKit )->cRefKit ) )

            ( dbfTmpLin )->( dbAppend() )

            if lKitAsociado( cCodArt, D():Articulos( nView ) )
               ( dbfTmpLin )->nNumLin     := nLastNum( dbfTmpLin )   
               ( dbfTmpLin )->nPosPrint   := nLastNum( dbfTmpLin, "nPosPrint" )
               ( dbfTmpLin )->lKitChl     := .f.
            else
               ( dbfTmpLin )->nNumLin     := nNumLin               
               ( dbfTmpLin )->nPosPrint   := nPosPrint               
               ( dbfTmpLin )->lKitChl     := .t.
            end if

            ( dbfTmpLin )->nNumKit     := nLastNum( dbfTmpLin, "nNumKit" )
            ( dbfTmpLin )->cRef        := ( dbfKit )->cRefKit
            ( dbfTmpLin )->cDetalle    := ( D():Articulos( nView ) )->Nombre
            ( dbfTmpLin )->nPntVer     := ( D():Articulos( nView ) )->nPntVer1
            ( dbfTmpLin )->nPesokg     := ( D():Articulos( nView ) )->nPesoKg
            ( dbfTmpLin )->cPesokg     := ( D():Articulos( nView ) )->cUndDim
            ( dbfTmpLin )->cUnidad     := ( D():Articulos( nView ) )->cUnidad
            ( dbfTmpLin )->nVolumen    := ( D():Articulos( nView ) )->nVolumen
            ( dbfTmpLin )->cVolumen    := ( D():Articulos( nView ) )->cVolumen
            ( dbfTmpLin )->nCtlStk     := ( D():Articulos( nView ) )->nCtlStock
            ( dbfTmpLin )->nPvpRec     := ( D():Articulos( nView ) )->PvpRec
            ( dbfTmpLin )->cCodImp     := ( D():Articulos( nView ) )->cCodImp
            ( dbfTmpLin )->lLote       := ( D():Articulos( nView ) )->lLote
            ( dbfTmpLin )->cLote       := ( D():Articulos( nView ) )->cLote

            ( dbfTmpLin )->nCosDiv     := nCosto( nil, D():Articulos( nView ), dbfKit )
            ( dbfTmpLin )->nValImp     := oNewImp:nValImp( ( D():Articulos( nView ) )->cCodImp )

            if ( D():Articulos( nView ) )->lFacCnv
               ( dbfTmpLin )->nFacCnv  := ( D():Articulos( nView ) )->nFacCnv
            end if

            /*
            Valores q arrastramos----------------------------------------------
            */           

            ( dbfTmpLin )->cCodFam     := ( D():Articulos( nView ) )->Familia
            ( dbfTmpLin )->cGrpFam     := cGruFam( ( dbfTmpLin )->cCodFam, D():Familias( nView ) )

            /*
            Datos de la cabecera-----------------------------------------------
            */           

            ( dbfTmpLin )->cSerAlb     := cSerAlb
            ( dbfTmpLin )->nNumAlb     := nNumAlb
            ( dbfTmpLin )->cSufAlb     := cSufAlb
            ( dbfTmpLin )->nCanEnt     := nCanEnt
            ( dbfTmpLin )->dFecha      := dFecAlb
            ( dbfTmpLin )->cTipMov     := cTipMov
            ( dbfTmpLin )->cNumPed     := cNumPed
            ( dbfTmpLin )->cAlmLin     := cAlmLin
            ( dbfTmpLin )->lIvaLin     := lIvaLin

            /*
            Propiedades de los kits-----------------------------------------
            */

            ( dbfTmpLin )->lImpLin     := lImprimirComponente( cCodArt, D():Articulos( nView ) )   // 1 Todos, 2 Compuesto, 3 Componentes
            ( dbfTmpLin )->lKitPrc     := lPreciosComponentes( cCodArt, D():Articulos( nView ) )   // 1 Todos, 2 Compuesto, 3 Componentes

            ( dbfTmpLin )->nComAge     := nComAge
            ( dbfTmpLin )->nUniCaja    := nUniCaj * ( dbfKit )->nUndKit

            /*
            Estudio de los tipos de impuestos si el padre el cero todos cero---------
            */

            if !empty( nIvaLin )
               ( dbfTmpLin )->nIva     := nIva( D():Get( "TIva", nView ), ( D():Articulos( nView ) )->TipoIva )
               ( dbfTmpLin )->nReq     := nReq( D():Get( "TIva", nView ), ( D():Articulos( nView ) )->TipoIva )
            else
               ( dbfTmpLin )->nIva     := 0
               ( dbfTmpLin )->nReq     := 0
            end if

            /*
            Cojemos el precio del kit------------------------------------------
            */

            if ( dbfTmpLin )->lKitPrc
               ( dbfTmpLin )->nPreUnit := nRetPreArt( nTarLin, aTmpAlb[ _CDIVALB ], aTmpAlb[ _LIVAINC ], D():Articulos( nView ), D():Get( "Divisas", nView ), dbfKit, D():Get( "TIva", nView ), , , oNewImp )
            end if

            /*
            Tratamiento de stocks----------------------------------------------
            */

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
               AppendKit( dbfTmpLin, aTmpAlb )
            end if

            /*
            Avisaremos del stock bajo minimo--------------------------------------
            */

            nStockMinimo      := nStockMinimo( cCodArt, cAlmLin, nView )

            if ( D():Articulos( nView ) )->lMsgVta .and. !uFieldEmpresa( "lNStkAct" ) .and. nStockMinimo != 0

               nStkActual     := oStock:nStockAlmacen( ( dbfKit )->cRefKit, cAlmLin )
               nUnidades      := nUniCaj * ( dbfKit )->nUndKit

               do case
                  case nStkActual - nUnidades < 0

                     MsgStop( "No hay stock suficiente para realizar la venta" + CRLF + ;
                              "del componente " + AllTrim( ( dbfKit )->cRefKit ) + " - " + AllTrim( ( D():Articulos( nView ) )->Nombre ),;
                              "¡Atención!" )

                  case nStkActual - nUnidades < nStockMinimo

                     MsgStop( "El stock del componente " + AllTrim( ( dbfKit )->cRefKit ) + " - " + AllTrim( ( D():Articulos( nView ) )->Nombre )  + CRLF + ;
                              "está bajo minimo."                                                                                                  + CRLF + ;
                              "Unidades a vender : " + AllTrim( Trans( nUnidades, MasUnd() ) )                                                     + CRLF + ;
                              "Stock minimo : " + AllTrim( Trans( nStockMinimo, MasUnd() ) )                                                       + CRLF + ;
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

   MsgStop( "Documento con mas de 3 tipos de " + cImp() )

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

   local cSat 
   local aTabla
   local oError
   local oBlock
   local cSerAlb
   local nNumAlb
   local cSufAlb
   local cNumPed
   local dFecAlb
   local cPedido

   if empty( aTmp[ _CSERALB ] )
      aTmp[ _CSERALB ]  := "A"
   end if

   cSerAlb              := aTmp[ _CSERALB ]
   nNumAlb              := aTmp[ _NNUMALB ]
   cSufAlb              := aTmp[ _CSUFALB ]
   cNumPed              := aTmp[ _CNUMPED ]
   dFecAlb              := aTmp[ _DFECALB ]
   cSat                 := aTmp[ _CNUMSAT ]

   /*
   Comprobamos la fecha del documento------------------------------------------
   */

   if !lValidaOperacion( aTmp[ _DFECALB ] )
      Return .f.
   end if

   if !lValidaSerie( aTmp[ _CSERALB ] )
      Return .f.
   end if

   /*
   Estos campos no pueden estar vacios-----------------------------------------
   */

   if empty( aTmp[ _CCODCLI ] )
      msgStop( "Código de cliente no puede estar vacío." )
      aGet[ _CCODCLI ]:SetFocus()
      return .f.
   end if

   if lCliBlq( aTmp[ _CCODCLI ], D():Get( "Client", nView ) )
      msgStop( "Cliente bloqueado, no se pueden realizar operaciones de venta"  + CRLF + ;
               "Motivo: " + AllTrim( RetFld( aTmp[ _CCODCLI ], D():Clientes( nView ), "cMotBlq" ) ),;
               "Imposible archivar como albarán" )
      aGet[ _CCODCLI ]:SetFocus()
      return .f.
   end if

   if !lCliChg( aTmp[ _CCODCLI ], D():Get( "Client", nView ) )
      msgStop( "Este cliente no tiene autorización para venta a credito." )
      aGet[ _CCODCLI ]:SetFocus()
      return .f.
   end if

   if lClienteAlcanzadoRiesgoPermitido( ( D():Get( "Client", nView ) )->lCreSol, ( D():Get( "Client", nView ) )->Riesgo, nRieCli - nTotOld + nTotAlb )
      aGet[ _CCODCLI ]:SetFocus()
      return .f.
   end if

   if empty( aTmp[ _CCODALM ] )
      msgStop( "Almacén no puede estar vacío." )
      aGet[ _CCODALM ]:SetFocus()
      return .f.
   end if

   if empty( aTmp[ _CCODCAJ ] )
      msgStop( "Caja no puede estar vacía." )
      aGet[ _CCODCAJ ]:SetFocus()
      return .f.
   end if

   if empty( aTmp[ _CCODPAGO ] )
      msgStop( "Forma de pago no puede estar vacía." )
      aGet[ _CCODPAGO ]:SetFocus()
      return .f.
   end if

   if empty( aTmp[ _CDIVALB ] )
      MsgStop( "No puede almacenar documento sin código de divisa." )
      aGet[ _CDIVALB ]:SetFocus()
      return .f.
   end if

   if empty( aTmp[ _CCODAGE ] ) .and. lRecogerAgentes()
      msgStop( "Agente no puede estar vacío." )
      aGet[ _CCODAGE ]:SetFocus()
      return .f.
   end if

   if empty( aTmp[ _CCODOBR ] ) .and. lObras()
      MsgStop( "Debe de introducir una obra." )
      aGet[ _CCODOBR ]:SetFocus()
      return .f.
   end if

   if ( dbfTmpLin )->( eof() )
      MsgStop( "No puede almacenar un documento sin líneas." )
      return .f.
   end if

   if nTotDif < 0
      msgInfo( "La carga excede la capacidad del medio de transporte." )
   end if

   // Ejecutamos script del evento before append-------------------------------

   if isAppendOrDuplicateMode( nMode )
      if isfalse( runEventScript( "AlbaranesClientes\beforeAppend", aTmp, nView, dbfTmpLin ) )
         return .f.
      end if 
   end if

   if isEditMode( nMode )
      if isfalse( runEventScript( "AlbaranesClientes\beforeEdit", aTmp, nView, dbfTmpLin ) )
         return .f.
      end if 
   end if

   CursorWait()

   oDlg:Disable()

   oMsgText( "Archivando" )

   oBlock                  := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   // Quitamos los filtros--------------------------------------------------------

   ( dbfTmpLin )->( dbClearFilter() )

   oMsgProgress()
   oMsgProgress():SetRange( 0, ( dbfTmpLin )->( LastRec() ) )

   // Primero hacer el RollBack---------------------------------------------------

   aTmp[ _DFECCRE ]        := Date()
   aTmp[ _CTIMCRE ]        := Time()
   aTmp[ _NTARIFA ]        := oGetTarifa:getTarifa()

   // Guardamos el tipo para alquileres-------------------------------------------
   
   if !empty( oTipAlb ) .and. oTipAlb:nAt == 2
      aTmp[ _LALQUILER ]   := .t.
   else
      aTmp[ _LALQUILER ]   := .f.
   end if

   // obtenemos nuevo contador-------------------------------------------------

   if isAppendOrDuplicateMode( nMode )
      nNumAlb              := nNewDoc( aTmp[ _CSERALB ], D():Get( "AlbCliT", nView ), "NALBCLI", , D():Get( "NCount", nView ) )
      aTmp[ _NNUMALB ]     := nNumAlb
      cSufAlb              := retSufEmp()
      aTmp[ _CSUFALB ]     := cSufAlb
      nTotOld              := 0
   end if 

   // comenzamos la transaccion------------------------------------------------

   BeginTransaction()
   
   if isEditMode( nMode )

      while ( D():Get( "AlbCliL", nView ) )->( dbSeek( cSerAlb + str( nNumAlb ) + cSufAlb ) ) .and. !( D():Get( "AlbCliL", nView ) )->( eof() )

         TComercio:appendProductsToUpadateStocks( (dbfTmpLin)->cRef, nView )

         if dbLock( D():Get( "AlbCliL", nView ) )
            ( D():Get( "AlbCliL", nView ) )->( dbDelete() )
            ( D():Get( "AlbCliL", nView ) )->( dbUnLock() )
         end if

      end while

      while ( D():Get( "AlbCliP", nView ) )->( dbSeek( cSerAlb + str( nNumAlb ) + cSufAlb ) ) .and. !( D():Get( "AlbCliP", nView ) )->( eof() )
         if dbLock( D():Get( "AlbCliP", nView ) )
            ( D():Get( "AlbCliP", nView ) )->( dbDelete() )
            ( D():Get( "AlbCliP", nView ) )->( dbUnLock() )
         end if
      end while

      while ( D():Get( "AlbCliI", nView ) )->( dbSeek( cSerAlb + str( nNumAlb ) + cSufAlb ) ) .and. !( D():Get( "AlbCliI", nView ) )->( eof() )
         if dbLock( D():Get( "AlbCliI", nView ) )
            ( D():Get( "AlbCliI", nView ) )->( dbDelete() )
            ( D():Get( "AlbCliI", nView ) )->( dbUnLock() )
         end if
      end while

      while ( D():Get( "AlbCliD", nView ) )->( dbSeek( cSerAlb + str( nNumAlb ) + cSufAlb ) ) .and. !( D():Get( "AlbCliD", nView ) )->( eof() )
         if dbLock( D():Get( "AlbCliD", nView ) )
            ( D():Get( "AlbCliD", nView ) )->( dbDelete() )
            ( D():Get( "AlbCliD", nView ) )->( dbUnLock() )
         end if
      end while

      while ( D():Get( "AlbCliS", nView ) )->( dbSeek( cSerAlb + Str( nNumAlb ) + cSufAlb ) ) .and. !( D():Get( "AlbCliS", nView ) )->( eof() )
         if dbLock( D():Get( "AlbCliS", nView ) )
            ( D():Get( "AlbCliS", nView ) )->( dbDelete() )
            ( D():Get( "AlbCliS", nView ) )->( dbUnLock() )
         end if
      end while

      while ( D():AlbaranesClientesSituaciones( nView ) )->( dbSeek( cSerAlb + str( nNumAlb ) + cSufAlb ) ) .and. !( D():AlbaranesClientesSituaciones( nView ) )->( eof() )
         if dbLock( D():AlbaranesClientesSituaciones( nView ) )
            ( D():AlbaranesClientesSituaciones( nView ) )->( dbDelete() )
            ( D():AlbaranesClientesSituaciones( nView ) )->( dbUnLock() )
         end if
      end while

   end if

   // Guardamos el albaran--------------------------------------------------------

   ( dbfTmpLin )->( dbGoTop() )
   while !( dbfTmpLin )->( eof() )

      if !( ( dbfTmpLin )->nUniCaja == 0 .and. ( dbfTmpLin )->lFromAtp )

         ( dbfTmpLin )->dFecAlb        := aTmp[ _DFECALB ]
         ( dbfTmpLin )->tFecAlb        := aTmp[ _TFECALB ]
         ( dbfTmpLin )->cCodCli        := aTmp[ _CCODCLI ]
         ( dbfTmpLin )->nRegIva        := aTmp[ _NREGIVA ]
         
         if empty( ( dbfTmpLin )->cCtrCoste )
            ( dbfTmpLin )->cCtrCoste   := aTmp[ _CCENTROCOSTE ]
         endif

         dbPass( dbfTmpLin, D():Get( "AlbCliL", nView ), .t., cSerAlb, nNumAlb, cSufAlb )

      end if   

      TComercio:appendProductsToUpadateStocks( (dbfTmpLin)->cRef, nView )

      oLinDetCamposExtra:saveExtraField( cSerAlb + Str( nNumAlb ) + cSufAlb + Str( ( dbfTmpLin )->nNumLin ) + Str( ( dbfTmpLin )->nNumKit ), ( dbfTmpLin )->( OrdKeyNo() ) )

      ( dbfTmpLin )->( dbSkip() )

      oMsgProgress():deltaPos(1)

   end while

   // Guardamos los totales-------------------------------------------------------

   aTmp[ _NTOTNET ]     := nTotNet
   aTmp[ _NTOTIVA ]     := nTotIva
   aTmp[ _NTOTREQ ]     := nTotReq
   aTmp[ _NTOTALB ]     := nTotAlb
   aTmp[ _NTOTPAG ]     := nTotPag

   /*
   Guardamos los campos extra-----------------------------------------------
   */

   oDetCamposExtra:saveExtraField( aTmp[ _CSERALB ] + Str( aTmp[ _NNUMALB ] ) + aTmp[ _CSUFALB ], "" )

   WinGather( aTmp, , D():Get( "AlbCliT", nView ), , nMode )

   /*
   Ahora escribimos en el fichero definitivo-----------------------------------
   */

   ( dbfTmpPgo )->( dbgotop() )
   while ( dbfTmpPgo )->( !eof() )
      dbPass( dbfTmpPgo, D():Get( "AlbCliP", nView ), .t., cSerAlb, nNumAlb, cSufAlb )
      ( dbfTmpPgo )->( dbSkip() )
   end while

   /*
   Ahora escribimos en el fichero definitivo-----------------------------------
   */

   ( dbfTmpInc )->( dbgotop() ) 
   while ( dbfTmpInc )->( !eof() )
      dbPass( dbfTmpInc, D():Get( "AlbCliI", nView ), .t., cSerAlb, nNumAlb, cSufAlb )
      ( dbfTmpInc )->( dbSkip() )
   end while

   /*
   Ahora escribimos en el fichero definitivo-----------------------------------
   */

   ( dbfTmpDoc )->( dbgotop() )
   while ( dbfTmpDoc )->( !eof() )
      dbPass( dbfTmpDoc, D():Get( "AlbCliD", nView ), .t., cSerAlb, nNumAlb, cSufAlb )
      ( dbfTmpDoc )->( dbSkip() )
   end while

   /*
   Ahora escribimos en el fichero definitivo-----------------------------------
   */

   ( dbfTmpSer )->( dbgotop() )
   while ( dbfTmpSer )->( !eof() )
      dbPass( dbfTmpSer, D():Get( "AlbCliS", nView ), .t., cSerAlb, nNumAlb, cSufAlb, dFecAlb )
      ( dbfTmpSer )->( dbSkip() )
   end while

   /*
   Escribimos en el fichero definitivo (Situaciones)
   */

   ( dbfTmpEst )->( dbgotop() )
   while ( dbfTmpEst )->( !eof() )
      dbPass( dbfTmpEst, D():AlbaranesClientesSituaciones( nView ), .t., cSerAlb, nNumAlb, cSufAlb ) 
      ( dbfTmpEst )->( dbSkip() )
   end while

   /*
   Estado del pedido-----------------------------------------------------------
   */

   if !empty( cNumPed )

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

   if !Empty( cSat ) .and. dbSeekInOrd( cSat, "nNumSat", D():SatClientes( nView ) )
      if dbLock( D():SatClientes( nView ) )
         ( D():SatClientes( nView ) )->cNumAlb    := cSerAlb + Str( nNumAlb ) + cSufAlb
         ( D():SatClientes( nView ) )->( dbUnLock() )
      end if
   end if 

   // Escribe los datos pendientes---------------------------------------------

   CommitTransaction()

   // script-------------------------------------------------------------------

   if ( nMode == APPD_MODE .or. nMode == DUPL_MODE )
      runEventScript( "AlbaranesClientes\afterAppend", aTmp, nView )
   end if

   CursorWE()

   RECOVER USING oError

      RollBackTransaction()

      msgStop( "Imposible almacenar documento" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE
   ErrorBlock( oBlock )

   oMsgText()
   endProgress()

   // actualiza el stock de prestashop-----------------------------------------

   TComercio:updateWebProductStocks()

   oDlg:Enable()
   oDlg:End( IDOK )

RETURN .t.

//---------------------------------------------------------------------------//

Static Function YearComboBoxChange()

   if ( oWndBrw:oWndBar:cYearComboBox() != __txtAllYearsFilter__ )
      oWndBrw:oWndBar:setYearComboBoxExpression( "Year( Field->dFecAlb ) == " + oWndBrw:oWndBar:cYearComboBox() )
   else
      oWndBrw:oWndBar:setYearComboBoxExpression( "" )
   end if 

   oWndBrw:chgFilter()

Return nil

//--------------------------------------------------------------------------//

Static Function lBuscaOferta( cCodArt, aGet, aTmp, aTmpAlb, dbfKit )

   local sOfeArt
   local nTotalLinea    := 0

   if ( D():Articulos( nView ) )->Codigo == cCodArt .or. ( D():Articulos( nView ) )->( dbSeek( cCodArt ) )

      /*
      Buscamos si existen ofertas por artículo----------------------------
      */

      nTotalLinea := lCalcDeta( aTmp, aTmpAlb, nDouDiv, , , aTmpAlb[ _CDIVALB ], .t. )

      sOfeArt     := sOfertaArticulo( cCodArt, aTmpAlb[ _CCODCLI ], aTmpAlb[ _CCODGRP ], aTmp[ _NUNICAJA ], aTmpAlb[ _DFECALB ], dbfOferta, aTmp[ _NTARLIN ], aTmpAlb[ _LIVAINC ], aTmp[_CCODPR1], aTmp[_CCODPR2], aTmp[_CVALPR1], aTmp[_CVALPR2], aTmp[ _CDIVALB ], aTmp[ _NCANENT ], nTotalLinea )

      if !empty( sOfeArt ) 
         if ( sOfeArt:nPrecio != 0 )
            aGet[ _NPREUNIT ]:cText( sOfeArt:nPrecio )
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

         sOfeArt     := sOfertaFamilia( ( D():Articulos( nView ) )->Familia, aTmpAlb[ _CCODCLI ], aTmpAlb[ _CCODGRP ], aTmpAlb[ _DFECALB ], dbfOferta, aTmp[ _NTARLIN ], D():Articulos( nView ), aTmp[ _NUNICAJA ], aTmp[ _NCANENT ], nTotalLinea )

         if !empty( sOfeArt ) 
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

         sOfeArt     := sOfertaTipoArticulo( ( D():Articulos( nView ) )->cCodTip, aTmpAlb[ _CCODCLI ], aTmpAlb[ _CCODGRP ], aTmpAlb[ _DFECALB ], dbfOferta, aTmp[ _NTARLIN ], D():Articulos( nView ), aTmp[ _NUNICAJA ], aTmp[ _NCANENT ], nTotalLinea )

         if !empty( sOfeArt )
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

         sOfeArt     := sOfertaCategoria( ( D():Articulos( nView ) )->cCodCate, aTmpAlb[ _CCODCLI ], aTmpAlb[ _CCODGRP ], aTmpAlb[ _DFECALB ], dbfOferta, aTmp[ _NTARLIN ], D():Articulos( nView ), aTmp[ _NUNICAJA ], aTmp[ _NCANENT ], nTotalLinea )

         if !empty( sOfeArt )
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

         sOfeArt     := sOfertaTemporada( ( D():Articulos( nView ) )->cCodTemp, aTmpAlb[ _CCODCLI ], aTmpAlb[ _CCODGRP ], aTmpAlb[ _DFECALB ], dbfOferta, aTmp[ _NTARLIN ], D():Articulos( nView ), aTmp[ _NUNICAJA ], aTmp[ _NCANENT ], nTotalLinea )

         if !empty( sOfeArt ) .and. ( sOfeArt:nDtoPorcentual != 0 .or. sOfeArt:nDtoLineal != 0 )
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

         sOfeArt     := sOfertaFabricante( ( D():Articulos( nView ) )->cCodFab, aTmpAlb[ _CCODCLI ], aTmpAlb[ _CCODGRP ], aTmpAlb[ _DFECALB ], dbfOferta, aTmp[ _NTARLIN ], D():Articulos( nView ), aTmp[ _NUNICAJA ], aTmp[ _NCANENT ], nTotalLinea )

         if !empty( sOfeArt )
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

   if !empty( oProSer )
      oProSer:Show()
      oProSer:SetTotal( nTotUnd )
   end if

   if !empty( oSaySer )
      oSaySer:SetText( "Calculando disponibilidad del stock..." )
   end if

   for n := 1 to nTotUnd

      if !empty( aNumSer[ n ] )

         aValSer[ n ]   := oStock:lValidNumeroSerie( cCodArt, cCodAlm, aNumSer[ n ] )

         if !aValSer[ n ]
            lValid      := .f.
         end if

      else

         lValid         := .f.

      end if

      if !empty( oProSer ) .and. ( Mod( n, int( nTotUnd / 100 ) ) == 0 )
         oProSer:Set( n )
      end if

   next

   if !empty( oBrwSer )
      oBrwSer:Refresh()
   end if

   if !empty( oProSer )
      oProSer:Set( 0 )
      oProSer:Hide()
   end if

   if !empty( oSaySer )
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

   if !empty( oProSer )
      oProSer:Show()
      oProSer:SetTotal( nTotUnd )
   end if

   for each l in aValSer

      if IsFalse( l )

         lValid            := .f.
         n                 := hb_EnumIndex()
         exit

      else

         if !empty( oProSer ) // .and. ( Mod( n, int( nTotUnd / 10 ) ) == 0 )
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

      if !empty( oBrwSer ) .and. IsNum( n )
         oBrwSer:nArrayAt  := n
         oBrwSer:Refresh()
      end if

   end if

   if !empty( oProSer )
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

   if !empty( oProSer )
      oProSer:SetTotal( nTotUnd )
   end if

   for each cNumSer in aNumSer

      ( dbfTmpSer )->( dbAppend() )
      ( dbfTmpSer )->cRef        := aTmp[ _CREF        ]
      ( dbfTmpSer )->cAlmLin     := aTmp[ _CALMLIN     ]
      ( dbfTmpSer )->nNumLin     := aTmp[ _NNUMLIN     ]
      ( dbfTmpSer )->lFacturado  := aTmp[ __LFACTURADO ]
      ( dbfTmpSer )->cNumSer     := cNumSer

      if !empty( oProSer ) .and. ( Mod( hb_enumindex(), int( nTotUnd / 100 ) ) == 0 )
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
   local cPedido  := aGet[ _CNUMPRE ]:VarGet()
   local lValid   := .f.

   if nMode != APPD_MODE .OR. empty( cPedido )
      return .t.
   end if

   if dbSeekInOrd( cPedido, "nNumPre", dbfPreCliT )

      if ( dbfPreCliT )->lEstado

         MsgStop( "Presupuesto ya aprobado" )
         lValid   := .f.

      else

         CursorWait()

         HideImportacion( aGet )

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

         oGetTarifa:setTarifa( ( dbfPreCliT )->nTarifa )

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

         aTmp[ _CCODGRP ]        := ( dbfPreCliT )->cCodGrp
         aTmp[ _LMODCLI ]        := ( dbfPreCliT )->lModCli

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
               (dbfTmpLin)->nPosPrint  := (dbfPreCliL)->nPosPrint
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
               (dbfTmpLin)->id_tipo_v  := (dbfPreCliL)->id_tipo_v
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
               (dbfTmpLin)->nBultos    := (dbfPreCliL)->nBultos
               (dbfTmpLin)->cFormato   := (dbfPreCliL)->cFormato
               (dbfTmpLin)->cRefAux    := (dbfPreCliL)->cRefAux
               (dbfTmpLin)->cRefAux2   := (dbfPreCliL)->cRefAux2
               (dbfTmpLin)->cCtrCoste  := (dbfPreCliL)->cCtrCoste
               (dbfTmpLin)->cTipCtr    := (dbfPreCliL)->cTipCtr
               (dbfTmpLin)->cTerCtr    := (dbfPreCliL)->cTerCtr

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

      HideImportacion( aGet, aGet[ _CNUMPRE ] )

   else

      MsgStop( "Presupuesto no existe" )

   end if

RETURN lValid

//---------------------------------------------------------------------------//

Static Function HideImportacion( aGet, oShow )

   oBtnPre:Hide()
   oBtnPed:Hide()

   oBtnAgruparPedido:Hide()

   aGet[ _CNUMPRE ]:Hide()
   aGet[ _CNUMPED ]:Hide()
   aGet[ _CNUMSAT ]:Hide()

   if !empty( oShow )
      oShow:Show()
   end if

Return nil 

//---------------------------------------------------------------------------//

STATIC FUNCTION cSatCli( aGet, aTmp, oBrw, nMode )

   local cDescript
   local cSatCliente    := aGet[ _CNUMSAT ]:VarGet()
   local lValid         := .f.

   if nMode != APPD_MODE .OR. empty( cSatCliente )
      return .t.
   end if

   if dbSeekInOrd( cSatCliente, "nNumSat", D():SatClientes( nView ) )

      if ( D():SatClientes( nView ) )->lEstado

         MsgStop( "S.A.T de cliente pasado" )
         lValid   := .f.

      else

         CursorWait()

         HideImportacion( aGet )

         aGet[ _CCODCLI ]:cText( ( D():SatClientes( nView ) )->CCODCLI )
         aGet[ _CCODCLI ]:lValid()
         aGet[ _CCODCLI ]:Disable()

         aGet[ _CNOMCLI ]:cText( ( D():SatClientes( nView ) )->CNOMCLI )
         aGet[ _CDIRCLI ]:cText( ( D():SatClientes( nView ) )->CDIRCLI )
         aGet[ _CPOBCLI ]:cText( ( D():SatClientes( nView ) )->CPOBCLI )
         aGet[ _CPRVCLI ]:cText( ( D():SatClientes( nView ) )->CPRVCLI )
         aGet[ _CPOSCLI ]:cText( ( D():SatClientes( nView ) )->CPOSCLI )
         aGet[ _CDNICLI ]:cText( ( D():SatClientes( nView ) )->CDNICLI )
         aGet[ _CTLFCLI ]:cText( ( D():SatClientes( nView ) )->CTLFCLI )

         aGet[ _CCODALM ]:cText( ( D():SatClientes( nView ) )->CCODALM )
         aGet[ _CCODALM ]:lValid()

         aGet[ _CCODCAJ ]:cText( ( D():SatClientes( nView ) )->cCodCaj )
         aGet[ _CCODCAJ ]:lValid()

         aGet[ _CCODPAGO]:cText( ( D():SatClientes( nView ) )->CCODPGO )
         aGet[ _CCODPAGO]:lValid()

         aGet[ _CCODAGE ]:cText( ( D():SatClientes( nView ) )->CCODAGE )
         aGet[ _CCODAGE ]:lValid()

         aGet[ _NPCTCOMAGE]:cText( ( D():SatClientes( nView ) )->nPctComAge )

         aGet[ _CCODTAR ]:cText( ( D():SatClientes( nView ) )->CCODTAR )
         aGet[ _CCODTAR ]:lValid()

         aGet[ _CCODOBR ]:cText( ( D():SatClientes( nView ) )->CCODOBR )
         aGet[ _CCODOBR ]:lValid()

         oGetTarifa:setTarifa( ( D():SatClientes( nView ) )->nTarifa )

         aGet[ _CCODTRN ]:cText( ( D():SatClientes( nView ) )->cCodTrn )
         aGet[ _CCODTRN ]:lValid() 

         aGet[ _LIVAINC ]:Click( ( D():SatClientes( nView ) )->lIvaInc )
         aGet[ _LRECARGO]:Click( ( D():SatClientes( nView ) )->lRecargo )
         aGet[ _LOPERPV ]:Click( ( D():SatClientes( nView ) )->lOperPv )

         aGet[ _CCONDENT]:cText( ( D():SatClientes( nView ) )->cCondEnt )
         aGet[ _MCOMENT ]:cText( ( D():SatClientes( nView ) )->mComent )
         aGet[ _MOBSERV ]:cText( ( D():SatClientes( nView ) )->mObserv )

         aGet[ _CDTOESP ]:cText( ( D():SatClientes( nView ) )->cDtoEsp )
         aGet[ _CDPP    ]:cText( ( D():SatClientes( nView ) )->cDpp    )
         aGet[ _NDTOESP ]:cText( ( D():SatClientes( nView ) )->nDtoEsp )
         aGet[ _NDPP    ]:cText( ( D():SatClientes( nView ) )->nDpp    )
         aGet[ _CDTOUNO ]:cText( ( D():SatClientes( nView ) )->cDtoUno )
         aGet[ _NDTOUNO ]:cText( ( D():SatClientes( nView ) )->nDtoUno )
         aGet[ _CDTODOS ]:cText( ( D():SatClientes( nView ) )->cDtoDos )
         aGet[ _NDTODOS ]:cText( ( D():SatClientes( nView ) )->nDtoDos )
         aGet[ _CMANOBR ]:cText( ( D():SatClientes( nView ) )->cManObr )
         aGet[ _NIVAMAN ]:cText( ( D():SatClientes( nView ) )->nIvaMan )
         aGet[ _NMANOBR ]:cText( ( D():SatClientes( nView ) )->nManObr )
         aGet[ _NBULTOS ]:cText( ( D():SatClientes( nView ) )->nBultos )

         aTmp[ _CCODGRP ]        := ( D():SatClientes( nView ) )->cCodGrp
         aTmp[ _LMODCLI ]        := ( D():SatClientes( nView ) )->lModCli

         if ( D():SatClientesLineas( nView ) )->( dbSeek( cSatCliente ) )

            ( dbfTmpLin )->( dbAppend() )
            cDescript                    := ""
            cDescript                    += "S.A.T. Nº " + ( D():SatClientes( nView ) )->cSerSat + "/" + AllTrim( Str( ( D():SatClientes( nView ) )->nNumSat ) ) + "/" + ( D():SatClientes( nView ) )->cSufSat
            cDescript                    += " - Fecha " + Dtoc( ( D():SatClientes( nView ) )->dFecSat )
            ( dbfTmpLin )->MLNGDES     := cDescript
            ( dbfTmpLin )->LCONTROL    := .t.

            while ( ( D():SatClientesLineas( nView ) )->cSerSat + Str( ( D():SatClientesLineas( nView ) )->nNumSat ) + ( D():SatClientesLineas( nView ) )->cSufSat == cSatCliente )

               ( dbfTmpLin )->( dbAppend() )

               ( dbfTmpLin )->nNumLin    := ( D():SatClientesLineas( nView ) )->nNumLin
               ( dbfTmpLin )->nPosPrint  := ( D():SatClientesLineas( nView ) )->nPosPrint
               ( dbfTmpLin )->cRef       := ( D():SatClientesLineas( nView ) )->cRef
               ( dbfTmpLin )->cDetalle   := ( D():SatClientesLineas( nView ) )->cDetAlle
               ( dbfTmpLin )->mLngDes    := ( D():SatClientesLineas( nView ) )->mLngDes
               ( dbfTmpLin )->mNumSer    := ( D():SatClientesLineas( nView ) )->mNumSer
               ( dbfTmpLin )->nPreUnit   := ( D():SatClientesLineas( nView ) )->nPreDiv
               ( dbfTmpLin )->nPntVer    := ( D():SatClientesLineas( nView ) )->nPntVer
               ( dbfTmpLin )->nImpTrn    := ( D():SatClientesLineas( nView ) )->nImpTrn
               ( dbfTmpLin )->nPESOKG    := ( D():SatClientesLineas( nView ) )->nPesOkg
               ( dbfTmpLin )->cPESOKG    := ( D():SatClientesLineas( nView ) )->cPesOkg
               ( dbfTmpLin )->cUnidad    := ( D():SatClientesLineas( nView ) )->cUnidad
               ( dbfTmpLin )->nVolumen   := ( D():SatClientesLineas( nView ) )->nVolumen
               ( dbfTmpLin )->cVolumen   := ( D():SatClientesLineas( nView ) )->cVolumen
               ( dbfTmpLin )->nIVA       := ( D():SatClientesLineas( nView ) )->nIva
               ( dbfTmpLin )->nReq       := ( D():SatClientesLineas( nView ) )->nReq
               ( dbfTmpLin )->cUNIDAD    := ( D():SatClientesLineas( nView ) )->cUnidad
               ( dbfTmpLin )->nDTO       := ( D():SatClientesLineas( nView ) )->nDto
               ( dbfTmpLin )->nDTOPRM    := ( D():SatClientesLineas( nView ) )->nDtoPrm
               ( dbfTmpLin )->nCOMAGE    := ( D():SatClientesLineas( nView ) )->nComAge
               ( dbfTmpLin )->lTOTLIN    := ( D():SatClientesLineas( nView ) )->lTotLin
               ( dbfTmpLin )->nDtoDiv    := ( D():SatClientesLineas( nView ) )->nDtoDiv
               ( dbfTmpLin )->nCtlStk    := ( D():SatClientesLineas( nView ) )->nCtlStk
               ( dbfTmpLin )->nCosDiv    := ( D():SatClientesLineas( nView ) )->nCosDiv
               ( dbfTmpLin )->id_tipo_v  := ( D():SatClientesLineas( nView ) )->id_tipo_v
               ( dbfTmpLin )->cAlmLin    := ( D():SatClientesLineas( nView ) )->cAlmLin
               ( dbfTmpLin )->cCodImp    := ( D():SatClientesLineas( nView ) )->cCodImp
               ( dbfTmpLin )->nValImp    := ( D():SatClientesLineas( nView ) )->nValImp
               ( dbfTmpLin )->CCODPR1    := ( D():SatClientesLineas( nView ) )->cCodPr1
               ( dbfTmpLin )->CCODPR2    := ( D():SatClientesLineas( nView ) )->cCodPr2
               ( dbfTmpLin )->CVALPR1    := ( D():SatClientesLineas( nView ) )->cValPr1
               ( dbfTmpLin )->CVALPR2    := ( D():SatClientesLineas( nView ) )->cValPr2
               ( dbfTmpLin )->nCanEnt    := ( D():SatClientesLineas( nView ) )->nCanSat
               ( dbfTmpLin )->nUniCaja   := ( D():SatClientesLineas( nView ) )->nUniCaja
               ( dbfTmpLin )->nUndKit    := ( D():SatClientesLineas( nView ) )->nUndKit
               ( dbfTmpLin )->lKitArt    := ( D():SatClientesLineas( nView ) )->lKitArt
               ( dbfTmpLin )->lKitChl    := ( D():SatClientesLineas( nView ) )->lKitChl
               ( dbfTmpLin )->lKitPrc    := ( D():SatClientesLineas( nView ) )->lKitPrc
               ( dbfTmpLin )->lLote      := ( D():SatClientesLineas( nView ) )->lLote
               ( dbfTmpLin )->nLote      := ( D():SatClientesLineas( nView ) )->nLote
               ( dbfTmpLin )->cLote      := ( D():SatClientesLineas( nView ) )->cLote
               ( dbfTmpLin )->lMsgVta    := ( D():SatClientesLineas( nView ) )->lMsgVta
               ( dbfTmpLin )->lNotVta    := ( D():SatClientesLineas( nView ) )->lNotVta
               ( dbfTmpLin )->lImpLin    := ( D():SatClientesLineas( nView ) )->lImpLin
               ( dbfTmpLin )->cCodTip    := ( D():SatClientesLineas( nView ) )->cCodTip
               ( dbfTmpLin )->mObsLin    := ( D():SatClientesLineas( nView ) )->mObsLin
               ( dbfTmpLin )->Descrip    := ( D():SatClientesLineas( nView ) )->Descrip
               ( dbfTmpLin )->cCodPrv    := ( D():SatClientesLineas( nView ) )->cCodPrv
               ( dbfTmpLin )->cImagen    := ( D():SatClientesLineas( nView ) )->cImagen
               ( dbfTmpLin )->cCodFam    := ( D():SatClientesLineas( nView ) )->cCodFam
               ( dbfTmpLin )->cGrpFam    := ( D():SatClientesLineas( nView ) )->cGrpFam
               ( dbfTmpLin )->cRefPrv    := ( D():SatClientesLineas( nView ) )->cRefPrv
               ( dbfTmpLin )->dFecEnt    := ( D():SatClientesLineas( nView ) )->dFecEnt
               ( dbfTmpLin )->dFecSal    := ( D():SatClientesLineas( nView ) )->dFecSal
               ( dbfTmpLin )->nPreAlq    := ( D():SatClientesLineas( nView ) )->nPreAlq
               ( dbfTmpLin )->lAlquiler  := ( D():SatClientesLineas( nView ) )->lAlquiler
               ( dbfTmpLin )->nNumMed    := ( D():SatClientesLineas( nView ) )->nNumMed
               ( dbfTmpLin )->nMedUno    := ( D():SatClientesLineas( nView ) )->nMedUno
               ( dbfTmpLin )->nMedDos    := ( D():SatClientesLineas( nView ) )->nMedDos
               ( dbfTmpLin )->nMedTre    := ( D():SatClientesLineas( nView ) )->nMedTre
               ( dbfTmpLin )->nPuntos    := ( D():SatClientesLineas( nView ) )->nPuntos
               ( dbfTmpLin )->nValPnt    := ( D():SatClientesLineas( nView ) )->nValPnt
               ( dbfTmpLin )->nDtoPnt    := ( D():SatClientesLineas( nView ) )->nDtoPnt
               ( dbfTmpLin )->nIncPnt    := ( D():SatClientesLineas( nView ) )->nIncPnt
               ( dbfTmpLin )->lControl   := ( D():SatClientesLineas( nView ) )->lControl
               ( dbfTmpLin )->lLinOfe    := ( D():SatClientesLineas( nView ) )->lLinOfe
               ( dbfTmpLin )->nBultos    := ( D():SatClientesLineas( nView ) )->nBultos
               ( dbfTmpLin )->cFormato   := ( D():SatClientesLineas( nView ) )->cFormato
               ( dbfTmpLin )->cRefAux    := ( D():SatClientesLineas( nView ) )->cRefAux
               ( dbfTmpLin )->cRefAux2   := ( D():SatClientesLineas( nView ) )->cRefAux2
               ( dbfTmpLin )->cCtrCoste  := ( D():SatClientesLineas( nView ) )->cCtrCoste
               ( dbfTmpLin )->cTipCtr    := ( D():SatClientesLineas( nView ) )->cTipCtr
               ( dbfTmpLin )->cTerCtr    := ( D():SatClientesLineas( nView ) )->cTerCtr

               ( D():SatClientesLineas( nView ) )->( dbSkip() )

            end while

            ( dbfTmpLin )->( dbGoTop() )

         end if

         lValid   := .t.

         if ( D():SatClientes( nView ) )->( dbRLock() )
            ( D():SatClientes( nView ) )->lEstado := .t.
            ( D():SatClientes( nView ) )->( dbUnlock() )
         end if

         CursorWE()

      end if

      HideImportacion( aGet, aGet[ _CNUMSAT ] )

   else

      MsgStop( "S.A.T. de cliente no existe" )

   end if

   HideImportacion( aGet, aGet[ _CNUMSAT ] )

RETURN lValid

//---------------------------------------------------------------------------//

Static Function CargaAtipicasCliente( aTmpAlb, oBrwLin, oDlg )

   local nOrder
   local lSearch     := .f.

   /*
   Controlamos que no nos pase código de cliente vacío------------------------
   */

   if empty( aTmpAlb[ _CCODCLI ] )
      MsgStop( "Código de cliente no puede estar vacío para utilizar el asistente." )
      Return .f.
   end if

   /*
   Controlamos que el cliente tenga atipicas----------------------------------
   */

   nOrder            := ( D():Atipicas( nView ) )->( OrdSetFocus( "cCodCli" ) )

   if ( D():Atipicas( nView ) )->( dbSeek( aTmpAlb[ _CCODCLI ] ) )

      AutoMeterDialog( oDlg )

      SetTotalAutoMeterDialog( ( D():Atipicas( nView ) )->( LastRec() ) )

      while ( D():Atipicas( nView ) )->cCodCli == aTmpAlb[ _CCODCLI ] .and. !( D():Atipicas( nView ) )->( Eof() )

         if lConditionAtipica( nil, D():Atipicas( nView ) ) .and. ( D():Atipicas( nView ) )->lAplAlb

            AppendDatosAtipicas( aTmpAlb )

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

      if !empty( aTmpAlb[ _CCODGRP ] )

         ( D():Atipicas( nView ) )->( OrdSetFocus( "cCodGrp" ) )
      
         if ( D():Atipicas( nView ) )->( dbSeek( aTmpAlb[ _CCODGRP ] ) )

            AutoMeterDialog( oDlg )

            SetTotalAutoMeterDialog( ( D():Atipicas( nView ) )->( LastRec() ) )
      
            while ( D():Atipicas( nView ) )->cCodGrp == aTmpAlb[ _CCODGRP ] .and. !( D():Atipicas( nView ) )->( Eof() )
      
               if lConditionAtipica( nil, D():Atipicas( nView ) ) .and. ( D():Atipicas( nView ) )->lAplAlb
      
                  AppendDatosAtipicas( aTmpAlb )

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

   RecalculaTotal( aTmpAlb )

   if !empty( oBrwLin )
      oBrwLin:GoTop()
      oBrwLin:Refresh()
   end if

Return .t.

//---------------------------------------------------------------------------//

Static Function AppendDatosAtipicas( aTmpAlb )

   local nPrecioAtipica
   local hAtipica

   if !dbSeekInOrd( ( D():Atipicas( nView ) )->cCodArt, "cRef", dbfTmpLin )
      
      if ( D():Articulos( nView ) )->( dbSeek( ( D():Atipicas( nView ) )->cCodArt ) ) .and. !( D():Articulos( nView ) )->lObs

         ( dbfTmpLin )->( dbAppend() )

         ( dbfTmpLin )->nNumLin        := nLastNum( dbfTmpLin )
         ( dbfTmpLin )->nPosPrint      := nLastNum( dbfTmpLin, "nPosPrint")
         ( dbfTmpLin )->cRef           := ( D():Atipicas( nView ) )->cCodArt
         ( dbfTmpLin )->cCodPr1        := ( D():Atipicas( nView ) )->cCodPr1
         ( dbfTmpLin )->cCodPr2        := ( D():Atipicas( nView ) )->cCodPr2
         ( dbfTmpLin )->cValPr1        := ( D():Atipicas( nView ) )->cValPr1
         ( dbfTmpLin )->cValPr2        := ( D():Atipicas( nView ) )->cValPr2
         ( dbfTmpLin )->nCosDiv        := ( D():Atipicas( nView ) )->nPrcCom
         ( dbfTmpLin )->cAlmLin        := aTmpAlb[ _CCODALM ]
         ( dbfTmpLin )->lIvaLin        := aTmpAlb[ _LIVAINC ]
         ( dbfTmpLin )->nTarLin        := oGetTarifa:getTarifa()  //aTmpAlb[ _NTARIFA ]
         ( dbfTmpLin )->dFecAlb        := aTmpAlb[ _DFECALB ]
         ( dbfTmpLin )->nCanEnt        := 1
         ( dbfTmpLin )->nUniCaja       := 0
         ( dbfTmpLin )->lFromAtp       := .t.
   
         //Datos de la tabla de artículo------------------------------------

         ( dbfTmpLin )->cDetalle       := ( D():Articulos( nView ) )->Nombre
         
         if aTmpAlb[ _NREGIVA ] <= 2
            ( dbfTmpLin )->nIva        := nIva( D():Get( "TIva", nView ), ( D():Articulos( nView ) )->TipoIva )
         end if
           
         ( dbfTmpLin )->cUnidad        := ( D():Articulos( nView ) )->cUnidad
         ( dbfTmpLin )->nCtlStk        := ( D():Articulos( nView ) )->nCtlStock
         ( dbfTmpLin )->lLote          := ( D():Articulos( nView ) )->lLote
         ( dbfTmpLin )->lMsgVta        := ( D():Articulos( nView ) )->lMsgVta
         ( dbfTmpLin )->lNotVta        := ( D():Articulos( nView ) )->lNotVta
         ( dbfTmpLin )->cCodTip        := ( D():Articulos( nView ) )->cCodTip
         ( dbfTmpLin )->cCodFam        := ( D():Articulos( nView ) )->Familia
         ( dbfTmpLin )->nPesoKg        := ( D():Articulos( nView ) )->nPesoKg

         ( dbfTmpLin )->dFecUltCom     := dFechaUltimaVenta( aTmpAlb[ _CCODCLI ], ( D():Atipicas( nView ) )->cCodArt, D():Get( "AlbCliL", nView ), D():Get( "FacCliL", nView ) )
         ( dbfTmpLin )->nUniUltCom     := nUnidadesUltimaVenta( aTmpAlb[ _CCODCLI ], ( D():Atipicas( nView ) )->cCodArt, D():Get( "AlbCliL", nView ), D():Get( "FacCliL", nView ) )
         ( dbfTmpLin )->nPrcUltCom     := nPrecioUltimaVenta( aTmpAlb[ _CCODCLI ], ( D():Atipicas( nView ) )->cCodArt, D():Get( "AlbCliL", nView ), D():Get( "FacCliL", nView ) )
         ( dbfTmpLin )->nPreUnit       := nRetPreArt( ( dbfTmpLin )->nTarLin, aTmpAlb[ _CDIVALB ], aTmpAlb[ _LIVAINC ], D():Articulos( nView ), D():Get( "Divisas", nView ), dbfKit, D():Get( "TIva", nView ), , , oNewImp )

         /*
         Vamos a por los catos de la tarifa
         */ 

         hAtipica := hAtipica( hValue( dbfTmpLin, aTmpAlb ) )

         if !empty( hAtipica )

            if hhaskey( hAtipica, "nImporte" ) .and. hAtipica[ "nImporte" ] != 0
               ( dbfTmpLin )->nPreUnit    := hAtipica[ "nImporte" ]
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

      hAtipica := hAtipica( hValue( dbfTmpLin, aTmpAlb ) )

      if !empty( hAtipica )
               
         if hhaskey( hAtipica, "nImporte" )

            if hAtipica[ "nImporte" ] != 0

               ( dbfTmpLin )->nPreUnit := hAtipica[ "nImporte" ]
            
            else
               
               if ( D():Articulos( nView ) )->( dbSeek( ( dbfTmpLin )->cRef ) ) .and. !( D():Articulos( nView ) )->lObs
                  ( dbfTmpLin )->nPreUnit := nRetPreArt( ( dbfTmpLin )->nTarLin, aTmpAlb[ _CDIVALB ], aTmpAlb[ _LIVAINC ], D():Articulos( nView ), D():Get( "Divisas", nView ), dbfKit, D():Get( "TIva", nView ), , , oNewImp )   
               end if 

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

Static Function lCompruebaStock( uTmpLin, oStock, nTotalUnidades, nStockActual )

   local cCodigoArticulo
   local cCodigoAlmacen
   local lNotVta
   local lMsgVta

   do case
      case ValType( uTmpLin ) == "A"

         cCodigoArticulo   := uTmpLin[ _CREF ]
         cCodigoAlmacen    := uTmpLin[ _CALMLIN ]
         lNotVta           := uTmpLin[ _LNOTVTA ]
         lMsgVta           := uTmpLin[ _LMSGVTA ]

         if empty( nStockActual )
            nStockActual   := oStock:nTotStockAct( uTmpLin[ _CREF ], uTmpLin[ _CALMLIN ], uTmpLin[ _CVALPR1 ], uTmpLin[ _CVALPR2 ], uTmpLin[ _CLOTE ], uTmpLin[ _LKITART ], uTmpLin[ _NCTLSTK ] )
         end if   

      case ValType( uTmpLin ) == "C"

         cCodigoArticulo   := ( uTmpLin )->cRef
         cCodigoAlmacen    := ( uTmpLin )->cAlmLin
         lNotVta           := ( uTmpLin )->lNotVta
         lMsgVta           := ( uTmpLin )->lMsgVta

         if empty( nStockActual )
            nStockActual   := oStock:nTotStockAct( ( uTmpLin )->cRef, ( uTmpLin )->cAlmLin, ( uTmpLin )->cValPr1, ( uTmpLin )->cValPr2, ( uTmpLin )->cLote, ( uTmpLin )->lKitArt, ( uTmpLin )->nCtlStk )
         end if

   end case

   if nTotalUnidades != 0

      do case
         case ( nStockActual - nTotalUnidades ) < 0

            if lNotVta
               msgStop( "No hay stock suficiente, tenemos " + Alltrim( Trans( nStockActual, MasUnd() ) ) + " unidad(es) disponible(s)," + CRLF + "en almacén " + cCodigoAlmacen + "." )
               return .f.
            end if

            if lMsgVta
               Return ApoloMsgNoYes( "No hay stock suficiente, tenemos " + Alltrim( Trans( nStockActual, MasUnd() ) ) + " unidad(es) disponible(s)," + CRLF + " en almacén " + cCodigoAlmacen + ".", "¿Desea continuar?" )
            end if

         case ( nStockActual - nTotalUnidades ) < nStockMinimo( cCodigoArticulo, cCodigoAlmacen, nView )

            if lMsgVta
               Return ApoloMsgNoYes( "El stock está por debajo del mínimo.", "¿Desea continuar?" )
            end if

      end case

   end if

Return .t.

//---------------------------------------------------------------------------//

Static Function ChangeUnidades( oCol, uNewValue, nKey, aTmp )

   /*
   Cambiamos el valor de las unidades de la linea de la factura---------------
   */

   if IsNum( nKey ) .and. ( nKey != VK_ESCAPE ) .and. !IsNil( uNewValue )

      ( dbfTmpLin )->nUnicaja       := uNewValue

      RecalculaTotal( aTmp )

   end if

Return .t.

//---------------------------------------------------------------------------//
/*
Sumamos una unidad a la linea de la factura--------------------------------
*/

Static Function SumaUnidadLinea( aTmp )

   ( dbfTmpLin )->nUniCaja++

   RecalculaTotal( aTmp )

Return .t.

//---------------------------------------------------------------------------//
/*
Restamos una unidad a la linea de la factura-------------------------------
*/

Static Function RestaUnidadLinea( aTmp )

   ( dbfTmpLin )->nUniCaja--

   RecalculaTotal( aTmp )

Return .t.

//---------------------------------------------------------------------------//

Function mailReportAlbCli( cCodigoDocumento )

Return ( printReportAlbCli( IS_MAIL, 1, prnGetName(), cCodigoDocumento ) )

//---------------------------------------------------------------------------//

Static Function PrintReportAlbCli( nDevice, nCopies, cPrinter, cCodigoDocumento )

   local oFr
   local cFilePdf             := cPatTmp() + "AlbaranesCliente" + StrTran( ( D():Get( "AlbCliT", nView ) )->cSerAlb + Str( ( D():Get( "AlbCliT", nView ) )->nNumAlb ) + ( D():Get( "AlbCliT", nView ) )->cSufAlb, " ", "" ) + ".Pdf"
   local nOrd 

   DEFAULT nDevice            := IS_SCREEN
   DEFAULT nCopies            := 1
   DEFAULT cPrinter           := PrnGetName()
   DEFAULT cCodigoDocumento   := cFormatoAlbaranesClientes()
   DEFAULT cCodigoDocumento   := cFormatoAlbaranesClientes()

   if empty( cCodigoDocumento )
      msgStop( "El código del documento esta vacio" )
      Return ( nil )
   end if 

   if !lMemoDocumento( cCodigoDocumento, D():Documentos( nView ) )
      msgStop( "El formato " + cCodigoDocumento + " no se encuentra, o no es un formato visual." )
      Return ( nil )
   end if 

   SysRefresh()

   nOrd                       :=  ( D():Get( "AlbCliL", nView ) )->( ordSetFocus( "nPosPrint" ) )

   oFr                        := frReportManager():New()

   oFr:LoadLangRes( "Spanish.Xml" )
   oFr:SetIcon( 1 )
   oFr:SetTitle( "Diseñador de documentos" )
   oFr:SetEventHandler( "Designer", "OnSaveReport", {|| oFr:SaveToBlob( ( D():Documentos( nView ) )->( Select() ), "mReport" ) } )

   // Zona de datos------------------------------------------------------------

   DataReport( oFr )

   // Cargar el informe--------------------------------------------------------

   oFr:LoadFromBlob( ( D():Documentos( nView ) )->( Select() ), "mReport")

   // Zona de variables--------------------------------------------------------

   VariableReport( oFr )

   // Preparar el report-------------------------------------------------------

   oFr:PrepareReport()

   // Imprimir el informe------------------------------------------------------

   do case
      case nDevice == IS_SCREEN 

         oFr:ShowPreparedReport()

      case nDevice == IS_PRINTER

         oFr:PrintOptions:SetCopies( nCopies )
         oFr:PrintOptions:SetPrinter( cPrinter )
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

   // Destruye el diseñador-------------------------------------------------------

   oFr:DestroyFr()

   ( D():Get( "AlbCliT", nView ) )->( ordSetFocus( nOrd ) )

Return ( cFilePdf )

//---------------------------------------------------------------------------//

Static Function PrintReportEntAlbCli( nDevice, nCopies, cPrinter, cAlbCliP, lTicket )

   local oFr
   local nRecAlbCliT    := ( D():Get( "AlbCliT", nView ) )->( Recno() )

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

   oFr:SetEventHandler( "Designer", "OnSaveReport", {|| oFr:SaveToBlob( ( D():Documentos( nView ) )->( Select() ), "mReport" ) } )

   /*
   Zona de datos------------------------------------------------------------
   */

   DataReportEntAlbCli( oFr, cAlbCliP, lTicket )

   /*
   Cargar el informe-----------------------------------------------------------
   */

   if !empty( ( D():Documentos( nView ) )->mReport )

      oFr:LoadFromBlob( ( D():Documentos( nView ) )->( Select() ), "mReport")

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

   ( D():Get( "AlbCliT", nView ) )->( dbGoTo( nRecAlbCliT ) )

Return .t.

//---------------------------------------------------------------------------//

Static Function FacturarLineas()

   local lPrint   := .f.

   lPrint         := TFacturarLineasAlbaranes():FacturarLineas( nView )

   /*
   Imprimimos si nos han dado a aceptar e imprimir-----------------------------
   */

   if lPrint
      GenAlbCli()
   end if

Return .t.

//---------------------------------------------------------------------------//

Static Function ImprimirSeriesAlbaranes( nDevice, lExternal )

   local aStatus
   local cFormato 
   local oPrinter  
   local cPrinterAlbaran   := cPrinterAlbaran( Application():CodigoCaja(), dbfCajT )

   DEFAULT nDevice         := IS_PRINTER
   DEFAULT lExternal       := .f.

   // Cremaos el dialogo-------------------------------------------------------

   oPrinter                := PrintSeries():New( nView )

   if empty(oPrinter)
      return .f.
   end if       

   oPrinter:SetVentas()

   // Establecemos sus valores-------------------------------------------------

   oPrinter:Serie(      ( D():AlbaranesClientes( nView ) )->cSerAlb )
   oPrinter:Documento(  ( D():AlbaranesClientes( nView ) )->nNumAlb )
   oPrinter:Sufijo(     ( D():AlbaranesClientes( nView ) )->cSufAlb )

   if lExternal
      oPrinter:oFechaInicio:cText(  ( D():AlbaranesClientes( nView ) )->dFecAlb )
      oPrinter:oFechaFin:cText(     ( D():AlbaranesClientes( nView ) )->dFecAlb )
   end if

   oPrinter:oFormatoDocumento:TypeDocumento( "AC" )   

   // Formato de documento-----------------------------------------------------

   cFormato          := cFormatoDocumento( ( D():AlbaranesClientes( nView ) )->cSerAlb, "nAlbCli", D():Contadores( nView ) )
   if empty( cFormato )
      cFormato       := cFirstDoc( "AC", D():Documentos( nView ) )
   end if
   oPrinter:oFormatoDocumento:cText( cFormato )

   // Codeblocks para que trabaje----------------------------------------------

   aStatus           := D():GetInitStatus( "AlbCliT", nView )

   oPrinter:bInit    := {||   ( D():AlbaranesClientes( nView ) )->( dbSeek( oPrinter:DocumentoInicio(), .t. ) ) }

   oPrinter:bWhile   := {||   oPrinter:InRangeDocumento( D():AlbaranesClientesId( nView ) )                 .and. ;
                              ( D():AlbaranesClientes( nView ) )->( !eof() ) }

   oPrinter:bFor     := {||   oPrinter:InRangeFecha( ( D():AlbaranesClientes( nView ) )->dFecAlb )          .and. ;
                              oPrinter:InRangeCliente( ( D():AlbaranesClientes( nView ) )->cCodCli )        .and. ;
                              oPrinter:InRangeAgente( ( D():AlbaranesClientes( nView ) )->cCodAge )         .and. ;
                              oPrinter:InRangeGrupoCliente( retGrpCli( ( D():AlbaranesClientes( nView ) )->cCodCli, D():Clientes( nView ) ) ) }

   oPrinter:bSkip    := {||   ( D():AlbaranesClientes( nView ) )->( dbSkip() ) }

   oPrinter:bAction  := {||   genAlbCli(  nDevice,; 
                                          "Imprimiendo documento : " + D():AlbaranesClientesId( nView ),;
                                          oPrinter:oFormatoDocumento:uGetValue,;
                                          oPrinter:oImpresora:uGetValue,;
                                          if( !oPrinter:oCopias:lCopiasPredeterminadas, oPrinter:oCopias:uGetValue, ) ) }

   oPrinter:bStart   := {||   if( lExternal, oPrinter:DisableRange(), ),;
                              if( !empty( cPrinterAlbaran ), oPrinter:setPrinter( cPrinterAlbaran ), ) }

   // Abrimos el dialogo-------------------------------------------------------

   oPrinter:Resource():End()

   // Restore -----------------------------------------------------------------

   D():SetStatus( "AlbCliT", nView, aStatus )
   
   if !empty( oWndBrw )
      oWndBrw:Refresh()
   end if   

Return .t.

//---------------------------------------------------------------------------//

Static Function GenerarEtiquetas()

Return ( nil )

//---------------------------------------------------------------------------//

/*
Cambiamos el valor de los bultos en el albaran---------------------------------
*/

Static Function ChangeBultos( oCol, uNewValue, nKey )

   if IsNum( nKey ) .and. ( nKey != VK_ESCAPE ) .and. !IsNil( uNewValue )

      if ( D():Lock( "AlbCliT", nView ) )
         ( D():Get( "AlbCliT", nView ) )->nBultos    := uNewValue
         ( D():UnLock( "AlbCliT", nView ) )
      end if

   end if

Return .t.

//---------------------------------------------------------------------------//
/*
Cambiamos el valor de los bultos en el albaran---------------------------------
*/

/*Static Function ChangeTrasportista( oCol, uNewValue, nKey )

   if IsNum( nKey ) .and. ( nKey != VK_ESCAPE ) .and. !IsNil( uNewValue )

      if oTrans:oDbf:SeekInOrd( uNewValue, "cCodTrn" )

         if ( D():Lock( "AlbCliT", nView ) )
            ( D():Get( "AlbCliT", nView ) )->cCodTrn   := uNewValue
            ( D():Get( "AlbCliT", nView ) )->nKgsTrn   := oTrans:oDbf:nKgsTrn
            ( D():UnLock( "AlbCliT", nView ) )
         end if

      else

         msgStop( "Código de transportista no encontrado." )
         Return .f.

      end if

   end if

Return .t.*/

//---------------------------------------------------------------------------//

Static Function hValue( aTmp, aTmpAlb )

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
      case ValType( aTmpAlb ) == "A"

         hValue[ "cCodigoCliente"    ] := aTmpAlb[ _CCODCLI ]
         hValue[ "cCodigoGrupo"      ] := aTmpAlb[ _CCODGRP ]
         hValue[ "lIvaIncluido"      ] := aTmpAlb[ _LIVAINC ]
         hValue[ "dFecha"            ] := aTmpAlb[ _DFECALB ]
         hValue[ "nDescuentoTarifa"  ] := aTmpAlb[ _NDTOTARIFA ]

      case ValType( aTmpAlb ) == "C"   
         
         hValue[ "cCodigoCliente"    ] := ( aTmpAlb )->cCodCli
         hValue[ "cCodigoGrupo"      ] := ( aTmpAlb )->cCodGrp
         hValue[ "lIvaIncluido"      ] := ( aTmpAlb )->lIvaInc
         hValue[ "dFecha"            ] := ( aTmpAlb )->dFecAlb
         hValue[ "nDescuentoTarifa"  ] := ( aTmpAlb )->nDtoTarifa

   end case

   hValue[ "nTipoDocumento"         ] := ALB_CLI
   hValue[ "nView"                  ] := nView

Return ( hValue )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
/*------------------------FUNCIONES GLOBALESS--------------------------------*/
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
/*
NOTA: Esta funcion se utiliza para el estado de generado de pedidos de clientes
*/

function nEstadoGenerado( cNumPed, cPedCliL, cPedPrvL )

   local nEstado     := 0
   local nOrdAnt     := ( cPedPrvL )->( OrdSetFocus( "cPedCliRef" ) )

   ( cPedCliL )->( dbSeek( cNumPed ) )

   while ( cPedCliL )->cSerPed + Str( ( cPedCliL )->nNumPed ) + ( cPedCliL )->cSufPed == cNumPed .and. !( cPedCliL )->( Eof() )

      if( cPedPrvL )->( dbSeek( cNumPed + ( cPedCliL )->cRef ) )
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

   ( cPedCliL )->( dbSkip() )

   end while

   ( cPedPrvL )->( OrdSetFocus( nOrdAnt ) )

return ( Max( nEstado, 1 ) )

//---------------------------------------------------------------------------//

Function AppAlbCli( hHash, lOpenBrowse )

   local nLevel         := Auth():Level( _MENUITEM_ )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) == 0 .or. nAnd( nLevel, ACC_APPD ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if lOpenBrowse

      if AlbCli( nil, nil, hHash )
         oWndBrw:RecAdd()
      end if

   else

      if OpenFiles( nil, .t. )
         nTotAlbCli()
         WinAppRec( nil, bEdtRec, D():Get( "AlbCliT", nView ), hHash )
         CloseFiles()
      end if

   end if

RETURN .t.

//---------------------------------------------------------------------------//

Function EdtAlbCli( cNumAlb, lOpenBrowse )

   local nLevel         := Auth():Level( _MENUITEM_ )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) == 0 .or. nAnd( nLevel, ACC_EDIT ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if lOpenBrowse

      if AlbCli()
         if dbSeekInOrd( cNumAlb, "nNumAlb", D():Get( "AlbCliT", nView ) )
            oWndBrw:RecEdit()
         else
            MsgStop( "No se encuentra albaran" )
         end if
      end if

   else

      if OpenFiles( nil, .t. )

         if dbSeekInOrd( cNumAlb, "nNumAlb", D():Get( "AlbCliT", nView ) )
            nTotAlbCli()
            WinEdtRec( nil, bEdtRec, D():Get( "AlbCliT", nView ) )
         end if

         CloseFiles()

      end if

   end if

Return .t.

//----------------------------------------------------------------------------//

FUNCTION ZooAlbCli( cNumAlb, lOpenBrowse )

   local nLevel         := Auth():Level( _MENUITEM_ )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) == 0 .or. nAnd( nLevel, ACC_ZOOM ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if lOpenBrowse

      if AlbCli()
         if dbSeekInOrd( cNumAlb, "nNumAlb", D():Get( "AlbCliT", nView ) )
            oWndBrw:RecZoom()
         else
            MsgStop( "No se encuentra albaran" )
         end if
      end if

   else

      if OpenFiles( nil, .t. )

         if dbSeekInOrd( cNumAlb, "nNumAlb", D():Get( "AlbCliT", nView ) )
            nTotAlbCli()
            WinZooRec( nil, bEdtRec, D():Get( "AlbCliT", nView ) )
         end if

         CloseFiles()

      end if

   end if

Return .t.

//----------------------------------------------------------------------------//

FUNCTION DelAlbCli( cNumAlb, lOpenBrowse )

   local nLevel         := Auth():Level( _MENUITEM_ )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) == 0 .or. nAnd( nLevel, ACC_DELE ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if lOpenBrowse

      if AlbCli()
         if dbSeekInOrd( cNumAlb, "nNumAlb", D():Get( "AlbCliT", nView ) )
            WinDelRec( nil, D():Get( "AlbCliT", nView ), {|| QuiAlbCli() } )
         else
            MsgStop( "No se encuentra albaran" )
         end if
      end if

   else

      if OpenFiles( nil, .t. )

         if dbSeekInOrd( cNumAlb, "nNumAlb", D():Get( "AlbCliT", nView ) )
            nTotAlbCli()
            WinDelRec( nil, D():Get( "AlbCliT", nView ), {|| QuiAlbCli() } )
         end if

         CloseFiles()

      end if

   end if

Return .t.

//----------------------------------------------------------------------------//

FUNCTION PrnAlbCli( cNumAlb, lOpenBrowse, cCaption, cFormato, cPrinter )

   local nLevel         := Auth():Level( _MENUITEM_ )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) == 0 .or. nAnd( nLevel, ACC_IMPR ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if lOpenBrowse

      if AlbCli()
         if dbSeekInOrd( cNumAlb, "nNumAlb", D():Get( "AlbCliT", nView ) )
            GenAlbCli( IS_PRINTER, cCaption, cFormato, cPrinter )
         else
            MsgStop( "No se encuentra albarán" )
         end if
      end if

   else

      if OpenFiles()

         if dbSeekInOrd( cNumAlb, "nNumAlb", D():Get( "AlbCliT", nView ) )
            nTotAlbCli()
            GenAlbCli( IS_PRINTER, cCaption, cFormato, cPrinter )
         end if

         CloseFiles()

      end if

   end if

Return .t.

//---------------------------------------------------------------------------//

FUNCTION PrnSerieAlbCli( cNumAlb, lOpenBrowse, cCaption, cFormato, cPrinter )

   local nLevel         := Auth():Level( _MENUITEM_ )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) == 0 .or. nAnd( nLevel, ACC_IMPR ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if lOpenBrowse

      if AlbCli()
         if dbSeekInOrd( cNumAlb, "nNumAlb", D():Get( "AlbCliT", nView ) )
            ImprimirSeriesAlbaranes( IS_PRINTER, .t. )
         else
            MsgStop( "No se encuentra albarán" )
         end if
      end if

   else

      if OpenFiles()

         if dbSeekInOrd( cNumAlb, "nNumAlb", D():Get( "AlbCliT", nView ) )
            nTotAlbCli()
            ImprimirSeriesAlbaranes( IS_PRINTER, .t. )
         end if

         CloseFiles()

      end if

   end if

Return .t.

//---------------------------------------------------------------------------//

FUNCTION VisAlbCli( cNumAlb, lOpenBrowse, cCaption, cFormato, cPrinter )

   local nLevel         := Auth():Level( _MENUITEM_ )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) == 0 .or. nAnd( nLevel, ACC_IMPR ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if lOpenBrowse

      if AlbCli()
         if dbSeekInOrd( cNumAlb, "nNumAlb", D():Get( "AlbCliT", nView ) )
            ImprimirSeriesAlbaranes( IS_SCREEN, .t. )
            //GenAlbCli( IS_SCREEN, cCaption, cFormato, cPrinter )
         else
            MsgStop( "No se encuentra albarán" )
         end if
      end if

   else

      if OpenFiles( nil, .t. )

         if dbSeekInOrd( cNumAlb, "nNumAlb", D():Get( "AlbCliT", nView ) )
            nTotAlbCli()
            ImprimirSeriesAlbaranes( IS_SCREEN, .t. )
         end if

         CloseFiles()

      end if

   end if

Return .t.

//---------------------------------------------------------------------------//

Function aTotAlbCli( cAlbaran, dbfMaster, dbfLine, cdbfIva, cdbfDiv, cDivRet, lExcCnt )

   nTotAlbCli( cAlbaran, dbfMaster, dbfLine, cdbfIva, cdbfDiv, nil, cDivRet, .f., lExcCnt )

Return ( { nTotNet, nTotIva, nTotReq, nTotAlb, nTotPnt, nTotTrn, nTotAge, aTotIva, nTotCos, nTotIvm, nTotRnt, nTotDto, nTotDpp, nTotUno, nTotDos, nTotBrt } )

//--------------------------------------------------------------------------//

Function sTotAlbCli( cAlbaran, dbfMaster, dbfLine, cdbfIva, cdbfDiv, cDivRet, lExcCnt )

   local sTotal

   nTotAlbCli( cAlbaran, dbfMaster, dbfLine, cdbfIva, cdbfDiv, nil, cDivRet, .f., lExcCnt )

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

   ( D():Get( "AlbCliT", nView ) )->( dbSetFilter( {|| Field->nFacturado != 3 .and. Field->lIvaInc == lIva }, "nFacturado != 3 .and. lIvaInc == lIva" ) )
   ( D():Get( "AlbCliT", nView ) )->( dbGoTop() )

   DEFINE DIALOG oDlg RESOURCE "HELPENTRY" TITLE if( lIva, "Albaranes de clientes con " + cImp() + " incluido", "Albaranes de clientes con " + cImp() + " desglosado" )

      REDEFINE GET oGet1 VAR cGet1;
         ID       104 ;
         ON CHANGE( AutoSeek( nKey, nFlags, Self, oBrw, D():Get( "AlbCliT", nView ), .t., nil, .t. ) );
         VALID    ( OrdClearScope( oBrw, D():Get( "AlbCliT", nView ) ) );
         BITMAP   "FIND" ;
         OF       oDlg

      REDEFINE COMBOBOX oCbxOrd ;
         VAR      cCbxOrd ;
         ID       102 ;
         ITEMS    aCbxOrd ;
         ON CHANGE( ( D():Get( "AlbCliT", nView ) )->( OrdSetFocus( oCbxOrd:nAt ) ), oBrw:refresh(), oGet1:SetFocus() ) ;
         OF       oDlg

      oBrw                 := IXBrowse():New( oDlg )

      oBrw:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrw:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrw:cAlias          := D():Get( "AlbCliT", nView )
      oBrw:nMarqueeStyle   := 5
      oBrw:cName           := "Albaran de cliente.Browse"

      oBrw:bLDblClick      := {|| oDlg:end( IDOK ) }

      oBrw:CreateFromResource( 105 )

      with object ( oBrw:AddCol() )
         :cHeader          := "Tipo"
         :bEditValue       := {|| aTipAlb[ if( ( D():Get( "AlbCliT", nView ) )->lAlquiler, 2, 1  ) ] }
         :nWidth           := 50
         :lHide            := .t.
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Número"
         :cSortOrder       := "nNumAlb"
         :bEditValue       := {|| ( D():Get( "AlbCliT", nView ) )->cSerAlb + "/" + Alltrim( Str( ( D():Get( "AlbCliT", nView ) )->nNumAlb ) ) + "/" + ( D():Get( "AlbCliT", nView ) )->cSufAlb }
         :nWidth           := 100
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Fecha"
         :cSortOrder       := "dFecAlb"
         :bEditValue       := {|| dtoc( ( D():Get( "AlbCliT", nView ) )->dFecAlb ) }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Cliente"
         :cSortOrder       := "cCodCli"
         :bEditValue       := {|| AllTrim( ( D():Get( "AlbCliT", nView ) )->cCodCli ) }
         :nWidth           := 100
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Nombre"
         :cSortOrder       := "cNomCli"
         :bEditValue       := {|| AllTrim( ( D():Get( "AlbCliT", nView ) )->cNomCli ) }
         :nWidth           := 300
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Importe"
         :bEditValue       := {|| nTotAlbCli( ( D():Get( "AlbCliT", nView ) )->cSerAlb + Str( ( D():Get( "AlbCliT", nView ) )->nNumAlb ) + ( D():Get( "AlbCliT", nView ) )->cSufAlb, D():Get( "AlbCliT", nView ), D():Get( "AlbCliL", nView ), D():Get( "TIva", nView ), D():Get( "Divisas", nView ), nil, cDivEmp(), .t. )  }
         :nWidth           := 80
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      REDEFINE BUTTON ;
         ID       500 ;
         OF       oDlg ;
         ACTION   ( WinAppRec( oBrw, bEdtRec, D():Get( "AlbCliT", nView ) ) )

      REDEFINE BUTTON ;
         ID       501 ;
         OF       oDlg ;
         ACTION   ( WinEdtRec( oBrw, bEdtRec, D():Get( "AlbCliT", nView ) ) )

      REDEFINE BUTTON ;
         ID       IDOK ;
         OF       oDlg ;
         ACTION   ( oDlg:end( IDOK ) )

      REDEFINE BUTTON ;
         ID       IDCANCEL ;
         OF       oDlg ;
         ACTION   ( oDlg:end() )

      oDlg:AddFastKey( VK_F5, {|| oDlg:end( IDOK ) } )

      oDlg:bStart    := {|| oBrw:Refresh( .t. ) }

   ACTIVATE DIALOG oDlg ;
   ON INIT ( oBrw:Load() ) ;
   CENTER

   DestroyFastFilter( D():Get( "AlbCliT", nView ) )

   SetBrwOpt( "BrwAlbCli", ( D():Get( "AlbCliT", nView ) )->( OrdNumber() ) )

   ( D():Get( "AlbCliT", nView ) )->( dbClearFilter() )

   if oDlg:nResult == IDOK
      oGet:cText( ( D():Get( "AlbCliT", nView ) )->cSerAlb + Str( ( D():Get( "AlbCliT", nView ) )->nNumAlb ) + ( D():Get( "AlbCliT", nView ) )->cSufAlb )
      oGet:lValid()
   end if

   CloseFiles()

RETURN ( oDlg:nResult == IDOK )

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
Devuelve el precio unitario impuestos incluido
*/

FUNCTION nIncUAlbCli( cTmpLin, nDec, nVdv )

   local nCalculo    := 0

   DEFAULT cTmpLin   := D():Get( "AlbCliL", nView )
   DEFAULT nDec      := 0
   DEFAULT nVdv      := 1

   nCalculo       := nTotUAlbCli( cTmpLin, nDec, nVdv )

   if !( cTmpLin )->lIvaLin
      nCalculo    += nCalculo * ( cTmpLin )->nIva / 100
   end if

   IF nVdv != 0
      nCalculo    := nCalculo / nVdv
   END IF

RETURN ( Round( nCalculo, nDec ) )

//---------------------------------------------------------------------------//

FUNCTION cDesAlbCli( cAlbCliL, cAlbCliS )

   if !empty( nView )
      DEFAULT cAlbCliL  := D():Get( "AlbCliL", nView )
      DEFAULT cAlbCliS  := D():Get( "AlbCliS", nView )
   end if

RETURN ( Descrip( cAlbCliL, cAlbCliS ) )

//---------------------------------------------------------------------------//

FUNCTION cDesAlbCliLeng( cAlbCliL, cAlbCliS, cArtLeng )

   if !empty( nView )
      DEFAULT cAlbCliL  := D():Get( "AlbCliL", nView )
      DEFAULT cAlbCliS  := D():Get( "AlbCliS", nView )
      DEFAULT cArtLeng  := D():ArticuloLenguaje( nView )
   end if

RETURN ( DescripLeng( cAlbCliL, cAlbCliS, cArtLeng ) )

//---------------------------------------------------------------------------//
/*
Devuelve el total de una linea con impuestos incluido
*/

FUNCTION nIncLAlbCli( cDbfLin, nDec, nRouDec, nVdv, lDto, lPntVer, lImpTrn, cPouDiv )

   local nCalculo    := 0

   DEFAULT cDbfLin   := D():Get( "AlbCliL", nView )
   DEFAULT nDec      := nDouDiv()
   DEFAULT nRouDec   := nRouDiv()
   DEFAULT nVdv      := 1
   DEFAULT lDto      := .t.
   DEFAULT lPntVer   := .t.
   DEFAULT lImpTrn   := .t.

   nCalculo          := nTotLAlbCli( cDbfLin, nDec, nRouDec, nVdv, lDto, lPntVer, lImpTrn, cPouDiv )

   if !( cDbfLin )->lIvaLin
      nCalculo    += nCalculo * ( cDbfLin )->nIva / 100
   end if

RETURN ( if( cPouDiv != NIL, Trans( nCalculo, cPouDiv ), nCalculo ) )

//---------------------------------------------------------------------------//

FUNCTION nIvaLAlbCli( cAlbCliL, nDec, nRou, nVdv, lDto, lPntVer, lImpTrn, cPouDiv )

   local nCalculo    := 0

   DEFAULT cAlbCliL  := D():Get( "AlbCliL", nView )
   DEFAULT nDec      := nDouDiv()
   DEFAULT nRou      := nRouDiv()
   DEFAULT nVdv      := 1
   DEFAULT lDto      := .t.
   DEFAULT lPntVer   := .t.
   DEFAULT lImpTrn   := .t.

   if ( cAlbCliL )->nRegIva <= 1

      nCalculo          := nTotLAlbCli( cAlbCliL, nDec, nRou, nVdv, lDto, lPntVer, lImpTrn, cPouDiv )   

      if !( cAlbCliL )->lIvaLin
         nCalculo       := nCalculo * ( cAlbCliL )->nIva / 100
      else
         nCalculo       -= nCalculo / ( 1 + ( cAlbCliL )->nIva / 100 )
      end if

   end if

   nCalculo          := Round( nCalculo, nRou )

RETURN ( if( cPouDiv != nil, Trans( nCalculo, cPouDiv ), nCalculo ) )

//---------------------------------------------------------------------------//

FUNCTION nReqLAlbCli( cAlbCliL, nDec, nRou, nVdv, lDto, lPntVer, lImpTrn, cPouDiv )

   local nCalculo    := 0

   DEFAULT cAlbCliL  := D():Get( "AlbCliL", nView )
   DEFAULT nDec      := nDouDiv()
   DEFAULT nRou      := nRouDiv()
   DEFAULT nVdv      := 1
   DEFAULT lDto      := .t.
   DEFAULT lPntVer   := .t.
   DEFAULT lImpTrn   := .t.

   nCalculo          := nTotLAlbCli( cAlbCliL, nDec, nRou, nVdv, lDto, lPntVer, lImpTrn, cPouDiv )   

   nCalculo          := nCalculo * ( cAlbCliL )->nReq / 100

   nCalculo          := Round( nCalculo, nRou )

RETURN ( if( cPouDiv != nil, Trans( nCalculo, cPouDiv ), nCalculo ) )

//---------------------------------------------------------------------------//
//
// Devuelve el neto de una linea una vez quitados los Dtos.
//

FUNCTION nNetLAlbCli( cAlbCliT, cAlbCliL, nDec, nRou, nVdv, lIva, lDto, lImpTrn, lPntVer, cPouDiv )

   local nCalculo

   DEFAULT cAlbCliT  := D():Get( "AlbCliT", nView )
   DEFAULT cAlbCliL  := D():Get( "AlbCliL", nView )
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

FUNCTION nDtoAtpAlbCli( uAlbCliT, uAlbCliL, nDec, nRou, nVdv, lImpTrn, lPntVer )

   local nCalculo
   local nDtoAtp  := 0

   DEFAULT nDec   := 0
   DEFAULT nRou   := 0
   DEFAULT nVdv   := 1
   DEFAULT lPntVer:= .f.
   DEFAULT lImpTrn:= .f.

   nCalculo       := nTotLAlbCli( uAlbCliL, nDec, nRou, nVdv, .t., lImpTrn, lPntVer )

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

FUNCTION Ped2AlbCli( cNumPed, cAlbCliT )

   local oBlock
   local oError
   local nOrdAnt
   local cNumAlb

   oBlock         := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      nOrdAnt     := ( cAlbCliT )->( OrdSetFocus( "cNumPed" ) )

      if ( cAlbCliT )->( dbSeek( cNumPed ) )
         cNumAlb  := ( cAlbCliT )->cSerAlb + Str( ( cAlbCliT )->nNumAlb ) + ( cAlbCliT )->cSufAlb
      end if

      if !empty( cNumAlb )
         EdtAlbCli( cNumAlb )
      else
         msgStop( "No hay albarán asociado" )
      end if

      ( cAlbCliT )->( OrdSetFocus( nOrdAnt ) )

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos de albaranes" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE
   
   ErrorBlock( oBlock )

RETURN NIL

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
/*
Devuelve la hora de un albaran de cliente
*/

FUNCTION tFecAlbCli( cAlbCli, uAlbCliT )

   local tFecAlb  := Replicate( "0", 6 )

   if ValType( uAlbCliT ) == "C"
      if dbSeekInOrd( cAlbCli, "nNumAlb", uAlbCliT )
         tFecAlb  := ( uAlbCliT )->tFecAlb
      end if
   else
      if uAlbCliT:SeekInOrd( cAlbCli, "nNumAlb" )
         tFecAlb  := uAlbCliT:tFecAlb
      end if
   end if

RETURN ( tFecAlb )

//---------------------------------------------------------------------------//

FUNCTION cCliAlbCli( cAlbCli, uAlbCliT )

   local cCodCli  := ""

   do case
      case ValType( uAlbCliT ) == "C"
         if (uAlbCliT)->( dbSeek( cAlbCli ) )
            cCodCli     := ( uAlbCliT )->cCodCli
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

Static Function lGenAlbCli( oBrw, oBtn, nDevice )

   local bAction

   DEFAULT nDevice   := IS_PRINTER

   if empty( oBtn )
      return nil
   end if

   IF !( D():Documentos( nView ) )->( dbSeek( "AC" ) )

      DEFINE BTNSHELL RESOURCE "GC_DOCUMENT_WHITE_" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( msgStop( "No hay documentos predefinidos" ) );
         TOOLTIP  "No hay documentos" ;
         FROM     oBtn ;
         CLOSED ;
         LEVEL    ACC_EDIT

   ELSE

      WHILE ( D():Documentos( nView ) )->CTIPO == "AC" .and. !( D():Documentos( nView ) )->( eof() )

         bAction  := bGenAlbCli( nDevice, "Imprimiendo albaranes de clientes", ( D():Documentos( nView ) )->Codigo )

         oWndBrw:NewAt( "gc_document_white_", , , bAction, Rtrim( ( D():Documentos( nView ) )->cDescrip ) , , , , , oBtn )

         ( D():Documentos( nView ) )->( dbSkip() )

      END DO

   END IF

   SysRefresh()

return nil

//---------------------------------------------------------------------------//
//
// Devuelve el total de la compra en albaranes de clientes de un articulo
//

function nTotDAlbCli( cCodArt, cAlbCliL, cAlbCliT, cCodAlm )

   local lFacAlb        := .f.
   local nTotVta        := 0
   local nRecno         := ( cAlbCliL )->( Recno() )

   if ( cAlbCliL )->( dbSeek( cCodArt ) )

      while ( cAlbCliL )->cRef == cCodArt .and. !( cAlbCliL )->( eof() )

         if cAlbCliT != nil
            lFacAlb     := lFacAlbCli( ( cAlbCliL )->cSerAlb + Str( ( cAlbCliL )->nNumAlb ) + ( cAlbCliL )->cSufAlb, cAlbCliT )
         end if

         if !( cAlbCliL )->lTotLin .and. !lFacAlb
            if cCodAlm != nil
               if cCodAlm == ( cAlbCliL )->cAlmLin
                  nTotVta  += nTotNAlbPrv( cAlbCliL ) * NotCero( ( cAlbCliL )->nFacCnv )
               end if
            else
               nTotVta     += nTotNAlbCli( cAlbCliL ) * NotCero( ( cAlbCliL )->nFacCnv )
            end if
         end if

         ( cAlbCliL )->( dbSkip() )

      end while

   end if

   ( cAlbCliL )->( dbGoTo( nRecno ) )

return ( nTotVta )

//---------------------------------------------------------------------------//
//
// Devuelve el total de la venta en albaranes de un clientes determinado
//

function nVtaAlbCli( cCodCli, dDesde, dHasta, cAlbCliT, cAlbCliL, cDbfIva, cDbfDiv, lNotFac, nYear )

   local nCon        := 0
   local nRec        := ( cAlbCliT )->( Recno() )

   DEFAULT lNotFac   := .f.

   /*
   Albaranes a Clientes -------------------------------------------------------
   */

   if ( cAlbCliT )->( dbSeek( cCodCli ) )

      while ( cAlbCliT )->cCodCli == cCodCli .and. !( cAlbCliT )->( Eof() )

         if ( dDesde == nil .or. ( cAlbCliT )->dFecAlb >= dDesde )    .and.;
            ( dHasta == nil .or. ( cAlbCliT )->dFecAlb <= dHasta )    .and.;
            ( if( lNotFac, !lFacturado( cAlbCliT ), .t. ) )         .and.;
            ( nYear == nil .or. Year( ( cAlbCliT )->dFecAlb ) == nYear )

            nCon  += nTotAlbCli( ( cAlbCliT )->cSerAlb + Str( ( cAlbCliT )->nNumAlb ) + ( cAlbCliT )->cSufAlb, cAlbCliT, cAlbCliL, cDbfIva, cDbfDiv, nil, cDivEmp(), .f. )

         end if

         ( cAlbCliT )->( dbSkip() )

         SysRefresh()

      end while

   end if

   ( cAlbCliT )->( dbGoTo( nRec ) )

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
8  45  8   impuestos TIPO 1
9  53  8   impuestos TIPO 2
10 61  8   impuestos TIPO 3
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
      ni punto verde, a las 6 y cuarto de la tarde. El tipo de impuestos fue el 1)


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
11 61  1   tipo impuestos          1, 2 ¢ 3
12 62  1   EUROS S/N         Indica si se hizo en euros o en pts (3)
13 63  7   PVERDE            Cargo unitario por Punto Verde
14 70  2   FINAL REGISTRO    CR LF  ( chr$(13) y chr$(10) )

  (1) Tipos de nota:  1- Factura Contado     2- Factura Credito
                      3- Albaran Contado     4- Albaran Credito
                      5- Adicional Contado   6- Adicional Credito
                      7- Indirecto Contado   8- Indirecto Credito

  (2) Tipos de linea: 0- Venta      1- Devoluci¢n      2- Defectuoso
                      3- Caducado   4- Abono  7- Regalo mercancia Automat.

  (3) Si el cliente est  en euros, los campos precio y desc. vendran en
      euros, y si estaba en ptas, vendr n en ptas.
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

   //cCodRut           := SubStr( cCodRut, -3 )
   cCodRut           := AllTrim( cCodRut )

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

         if dbSeekInOrd( cCodCli, "Cod", D():Get( "Client", nView ) )

            nNumAlb                          := Val( StrTran( cNumDoc, "/", "" ) )

            if empty( ( D():Get( "Client", nView ) )->Serie )
               cSerie                        := "A"
            else
               cSerie                        := ( D():Get( "Client", nView ) )->Serie
            end if

            if !( D():Get( "AlbCliT", nView ) )->( dbSeek( cSerie + Str( nNumAlb, 9 ) + RetSufEmp() ) )

               n  := aScan( aHeadLine, {|a| a[1] == cNumDoc } )
               if n != 0
                  dFecAlb                    := aHeadLine[n,2]

                  ( D():Get( "AlbCliT", nView ) )->( dbAppend() )
                  ( D():Get( "AlbCliT", nView ) )->cSerAlb    := cSerie
                  ( D():Get( "AlbCliT", nView ) )->nNumAlb    := nNumAlb
                  ( D():Get( "AlbCliT", nView ) )->cSufAlb    := RetSufEmp()
                  ( D():Get( "AlbCliT", nView ) )->dFecAlb    := dFecAlb
                  ( D():Get( "AlbCliT", nView ) )->cCodAlm    := Application():codigoAlmacen()
                  ( D():Get( "AlbCliT", nView ) )->cDivAlb    := cDivEmp()
                  ( D():Get( "AlbCliT", nView ) )->nVdvAlb    := nChgDiv( ( D():Get( "AlbCliT", nView ) )->cDivAlb, D():Get( "Divisas", nView ) )
                  ( D():Get( "AlbCliT", nView ) )->lFacturado := .f.
                  ( D():Get( "AlbCliT", nView ) )->nFacturado := 1
                  ( D():Get( "AlbCliT", nView ) )->cCodCli    := ( D():Get( "Client", nView ) )->Cod
                  ( D():Get( "AlbCliT", nView ) )->cNomCli    := ( D():Get( "Client", nView ) )->Titulo
                  ( D():Get( "AlbCliT", nView ) )->cDirCli    := ( D():Get( "Client", nView ) )->Domicilio
                  ( D():Get( "AlbCliT", nView ) )->cPobCli    := ( D():Get( "Client", nView ) )->Poblacion
                  ( D():Get( "AlbCliT", nView ) )->cPrvCli    := ( D():Get( "Client", nView ) )->Provincia
                  ( D():Get( "AlbCliT", nView ) )->cPosCli    := ( D():Get( "Client", nView ) )->CodPostal
                  ( D():Get( "AlbCliT", nView ) )->cDniCli    := ( D():Get( "Client", nView ) )->Nif
                  ( D():Get( "AlbCliT", nView ) )->cCodTar    := ( D():Get( "Client", nView ) )->cCodTar
                  ( D():Get( "AlbCliT", nView ) )->cCodPago   := ( D():Get( "Client", nView ) )->CodPago
                  ( D():Get( "AlbCliT", nView ) )->cCodAge    := ( D():Get( "Client", nView ) )->cAgente
                  ( D():Get( "AlbCliT", nView ) )->cCodRut    := ( D():Get( "Client", nView ) )->cCodRut
                  ( D():Get( "AlbCliT", nView ) )->nTarifa    := ( D():Get( "Client", nView ) )->nTarifa
                  ( D():Get( "AlbCliT", nView ) )->lRecargo   := ( D():Get( "Client", nView ) )->lReq
                  ( D():Get( "AlbCliT", nView ) )->lOperPv    := ( D():Get( "Client", nView ) )->lPntVer
                  ( D():Get( "AlbCliT", nView ) )->cDtoEsp    := ( D():Get( "Client", nView ) )->cDtoEsp
                  ( D():Get( "AlbCliT", nView ) )->cDpp       := ( D():Get( "Client", nView ) )->cDpp
                  ( D():Get( "AlbCliT", nView ) )->nDtoEsp    := ( D():Get( "Client", nView ) )->nDtoEsp
                  ( D():Get( "AlbCliT", nView ) )->nDpp       := ( D():Get( "Client", nView ) )->nDpp
                  ( D():Get( "AlbCliT", nView ) )->nDtoUno    := ( D():Get( "Client", nView ) )->nDtoCnt
                  ( D():Get( "AlbCliT", nView ) )->cDtoUno    := ( D():Get( "Client", nView ) )->cDtoUno
                  ( D():Get( "AlbCliT", nView ) )->nDtoDos    := ( D():Get( "Client", nView ) )->nDtoRap
                  ( D():Get( "AlbCliT", nView ) )->cDtoDos    := ( D():Get( "Client", nView ) )->cDtoDos
                  ( D():Get( "AlbCliT", nView ) )->( dbUnLock() )

                  aAdd( aSucces, { .t., "Nuevo albarán de clientes " + ( D():Get( "AlbCliT", nView ) )->cSerAlb + "/" + AllTrim( Str( ( D():Get( "AlbCliT", nView ) )->nNumAlb ) ) + "/" + ( D():Get( "AlbCliT", nView ) )->cSufAlb } )

                  /*
                  Mientras estemos en el mismo albarán pasamos las lineas------
                  */

                  while cNumDoc == SubStr( oFilEdm:cLine,  8, 10 ) .and. ! oFilEdm:lEoF()

                     if cTipDoc == "3" .or. cTipDoc == "4"

                        if ( D():Get( "AlbCliT", nView ) )->( dbSeek( cSerie + Str( nNumAlb, 9 ) + RetSufEmp() ) )

                           ( D():Get( "AlbCliL", nView ) )->( dbAppend() )
                           ( D():Get( "AlbCliL", nView ) )->cSerAlb       := ( D():Get( "AlbCliT", nView ) )->cSerAlb
                           ( D():Get( "AlbCliL", nView ) )->nNumAlb       := ( D():Get( "AlbCliT", nView ) )->nNumAlb
                           ( D():Get( "AlbCliL", nView ) )->cSufAlb       := ( D():Get( "AlbCliT", nView ) )->cSufAlb
                           ( D():Get( "AlbCliL", nView ) )->cRef          := Ltrim( SubStr( oFilEdm:cLine, 19, 13 ) )
                           ( D():Get( "AlbCliL", nView ) )->cDetalle      := RetFld( ( D():Get( "AlbCliL", nView ) )->cRef, D():Articulos( nView ) )
                           ( D():Get( "AlbCliL", nView ) )->nPreUnit      := Val( SubStr( oFilEdm:cLine, 32,  7 ) )
                           ( D():Get( "AlbCliL", nView ) )->nDtoDiv       := Val( SubStr( oFilEdm:cLine, 39,  5 ) )
                           ( D():Get( "AlbCliL", nView ) )->nDto          := Val( SubStr( oFilEdm:cLine, 44,  5 ) )
                           ( D():Get( "AlbCliL", nView ) )->nIva          := nIvaCodTer( SubStr( oFilEdm:cLine, 61, 1 ), D():Get( "TIva", nView ) )
                           ( D():Get( "AlbCliL", nView ) )->nPntVer       := Val( SubStr( oFilEdm:cLine, 63, 7 ) )
                           ( D():Get( "AlbCliL", nView ) )->nCanEnt       := 1
                           ( D():Get( "AlbCliL", nView ) )->nUniCaja      := Val( SubStr( oFilEdm:cLine, 53,  7 ) )

                           /*
                           Buscamos en el array l numero de lote---------------
                           */

                           if ( n  := aScan( aLotes, {|a| a[1] == cNumDoc .and. a[2] == Ltrim( SubStr( oFilEdm:cLine, 19, 13 ) ) } ) ) != 0
                              ( D():Get( "AlbCliL", nView ) )->lLote      := .t.
                              ( D():Get( "AlbCliL", nView ) )->cLote      := aLotes[ n, 3 ]
                           end if

                           ( D():Get( "AlbCliL", nView ) )->( dbUnLock() )

                        end if

                     end if

                     oFilEdm:Skip()

                  end do

               else

                  aAdd( aSucces, { .f., "Líneas de albarán huerfanas, cliente " + cCodCli + " documento : " + cNumDoc } )
                  oFilEdm:Skip()

               end if

            else

               aAdd( aSucces, { .f., "Albarán de clientes ya existe " + ( D():Get( "AlbCliT", nView ) )->cSerAlb + "/" + AllTrim( Str( ( D():Get( "AlbCliT", nView ) )->nNumAlb ) ) + "/" + ( D():Get( "AlbCliT", nView ) )->cSufAlb } )
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

   aAdd( aCalAlbCli, { "nTotArt",                                                   "N", 18,  8, "Total artículos",             "cPicUndAlb",  "" } )
   aAdd( aCalAlbCli, { "nTotCaj",                                                   "N", 18,  8, "Total cajas",                 "cPicUndAlb",  "" } )
   aAdd( aCalAlbCli, { "aTotIva[1,1]",                                              "N", 18,  8, "Bruto primer tipo de " + cImp(),    "cPorDivAlb",  "aTotIva[1,1] != 0" } )
   aAdd( aCalAlbCli, { "aTotIva[2,1]",                                              "N", 18,  8, "Bruto segundo tipo de " + cImp(),   "cPorDivAlb",  "aTotIva[2,1] != 0" } )
   aAdd( aCalAlbCli, { "aTotIva[3,1]",                                              "N", 18,  8, "Bruto tercer tipo de " + cImp(),    "cPorDivAlb",  "aTotIva[3,1] != 0" } )
   aAdd( aCalAlbCli, { "aTotIva[1,2]",                                              "N", 18,  8, "Base primer tipo de " + cImp(),     "cPorDivAlb",  "aTotIva[1,2] != 0" } )
   aAdd( aCalAlbCli, { "aTotIva[2,2]",                                              "N", 18,  8, "Base segundo tipo de " + cImp(),    "cPorDivAlb",  "aTotIva[2,2] != 0" } )
   aAdd( aCalAlbCli, { "aTotIva[3,2]",                                              "N", 18,  8, "Base tercer tipo de " + cImp(),     "cPorDivAlb",  "aTotIva[3,2] != 0" } )
   aAdd( aCalAlbCli, { "aTotIva[1,3]",                                              "N",  5,  2, "Porcentaje primer tipo " + cImp(),  "'@R 99.99%'", "aTotIva[1,3] != 0" } )
   aAdd( aCalAlbCli, { "aTotIva[2,3]",                                              "N",  5,  2, "Porcentaje segundo tipo " + cImp(), "'@R 99.99%'", "aTotIva[2,3] != 0" } )
   aAdd( aCalAlbCli, { "aTotIva[3,3]",                                              "N",  5,  2, "Porcentaje tercer tipo " + cImp(),  "'@R 99.99%'", "aTotIva[3,3] != 0" } )
   aAdd( aCalAlbCli, { "aTotIva[1,4]",                                              "N",  5,  2, "Porcentaje primer tipo RE",   "'@R 99.99%'", "aTotIva[1,4] != 0" } )
   aAdd( aCalAlbCli, { "aTotIva[2,4]",                                              "N",  5,  2, "Porcentaje segundo tipo RE",  "'@R 99.99%'", "aTotIva[2,4] != 0" } )
   aAdd( aCalAlbCli, { "aTotIva[3,4]",                                              "N",  5,  2, "Porcentaje tercer tipo RE",   "'@R 99.99%'", "aTotIva[3,4] != 0" } )
   aAdd( aCalAlbCli, { "round( aTotIva[1,2] * aTotIva[1,3] / 100, nDouDivAlb )",    "N", 18,  8, "Importe primer tipo " + cImp(),     "cPorDivAlb",  "aTotIva[1,2] != 0" } )
   aAdd( aCalAlbCli, { "round( aTotIva[2,2] * aTotIva[2,3] / 100, nDouDivAlb )",    "N", 18,  8, "Importe segundo tipo " + cImp(),    "cPorDivAlb",  "aTotIva[2,2] != 0" } )
   aAdd( aCalAlbCli, { "round( aTotIva[3,2] * aTotIva[3,3] / 100, nDouDivAlb )",    "N", 18,  8, "Importe tercer tipo " + cImp(),     "cPorDivAlb",  "aTotIva[3,2] != 0" } )
   aAdd( aCalAlbCli, { "round( aTotIva[1,2] * aTotIva[1,4] / 100, nDouDivAlb )",    "N", 18,  8, "Importe primer RE",           "cPorDivAlb",  "aTotIva[1,2] != 0" } )
   aAdd( aCalAlbCli, { "round( aTotIva[2,2] * aTotIva[2,4] / 100, nDouDivAlb )",    "N", 18,  8, "Importe segundo RE",          "cPorDivAlb",  "aTotIva[2,2] != 0" } )
   aAdd( aCalAlbCli, { "round( aTotIva[3,2] * aTotIva[3,4] / 100, nDouDivAlb )",    "N", 18,  8, "Importe tercer RE",           "cPorDivAlb",  "aTotIva[3,2] != 0" } )
   aAdd( aCalAlbCli, { "nTotBrt",                                                   "N", 18,  8, "Total bruto",                 "cPorDivAlb",  "lEnd" }              )
   aAdd( aCalAlbCli, { "nTotDto",                                                   "N", 18,  8, "Total descuento",             "cPorDivAlb",  "lEnd" }              )
   aAdd( aCalAlbCli, { "nTotDpp",                                                   "N", 18,  8, "Total descuento pronto pago", "cPorDivAlb",  "lEnd" }              )
   aAdd( aCalAlbCli, { "nTotUno",                                                   "N", 18,  8, "Total primer descuento personalizable",  "cPorDivAlb",  "lEnd" }   )
   aAdd( aCalAlbCli, { "nTotDos",                                                   "N", 18,  8, "Total segundo descuento personalizable", "cPorDivAlb",  "lEnd" }   )
   aAdd( aCalAlbCli, { "nTotNet",                                                   "N", 18,  8, "Total neto",                  "cPorDivAlb",  "lEnd" }              )
   aAdd( aCalAlbCli, { "nTotIva",                                                   "N", 18,  8, "Total " + cImp(),                   "cPorDivAlb",  "lEnd" }              )
   aAdd( aCalAlbCli, { "nTotIvm",                                                   "N", 18,  8, "Total IVMH",                  "cPorDivAlb",  "lEnd" }              )
   aAdd( aCalAlbCli, { "nTotReq",                                                   "N", 18,  8, "Total RE",                    "cPorDivAlb",  "lEnd" }              )
   aAdd( aCalAlbCli, { "nTotAlb",                                                   "N", 18,  8, "Total albarán",               "cPorDivAlb",  "lEnd" }              )
   aAdd( aCalAlbCli, { "nTotPage",                                                  "N", 18,  8, "Total página",                "cPorDivAlb",  "!lEnd"}              )
   aAdd( aCalAlbCli, { "nTotPes",                                                   "N", 18,  8, "Total peso",                  "'@E 99,999.99'","lEnd" }            )
   aAdd( aCalAlbCli, { "nTotCos",                                                   "N", 18,  8, "Total costo",                 "cPorDivAlb",  "lEnd" }            )
   aAdd( aCalAlbCli, { "nImpEuros( nTotAlb, (cDbf)->cDivAlb, cDbfDiv )",            "N", 18,  8, "Total albarán (Euros)",       "",            "lEnd" }              )
   aAdd( aCalAlbCli, { "nImpPesetas( nTotAlb, (cDbf)->cDivAlb, cDbfDiv )",          "N", 18,  8, "Total albarán (Pesetas)",     "",            "lEnd" }              )
   aAdd( aCalAlbCli, { "nPagina",                                                   "N",  2,  0, "Número de página",            "'99'",        "" }                  )
   aAdd( aCalAlbCli, { "lEnd",                                                      "L",  1,  0, "Fin del documento",           "",            "" }                  )

Return ( aCalAlbCli )

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
   aAdd( aColAlbCli,  { "cAlmLin",     "C", 16,   0, "Almacen del artículo",             "",                  "", "( cDbfCol )" } )
   aAdd( aColAlbCli,  { "cNumSer",     "C", 30,   0, "Número de serie",                  "",                  "", "( cDbfCol )" } )

return ( aColAlbCli )

//---------------------------------------------------------------------------//

function SynAlbCli( cPath )

   local aTotAlb
   local cNumAlb
   local nNumLin     := 0
   local cCodImp
   local cNumSer
   local aNumSer
   local cNumPed
   local aNumPed     := {}
   local cCodGrp

   DEFAULT cPath     := cPatEmp() 

   if OpenFiles()

      ( D():Get( "AlbCliT", nView ) )->( ordSetFocus( 0 ) )
      ( D():Get( "AlbCliT", nView ) )->( dbGoTop() )

      while !( D():Get( "AlbCliT", nView ) )->( eof() )

         /*
         Miramos si estamos usando los campos nuevos de estado, y si no es asi, pasamos el estado
         */

         if ( D():Get( "AlbCliT", nView ) )->nFacturado == 0

            if D():Lock( "AlbCliT", nView )
               ( D():Get( "AlbCliT", nView ) )->nFacturado := if( ( D():Get( "AlbCliT", nView ) )->lFacturado, 3, 1 )
               D():UnLock( "AlbCliT", nView )
            end if

         end if

         if empty( ( D():Get( "AlbCliT", nView ) )->cSufAlb )
            
            if D():Lock( "AlbCliT", nView )
               ( D():Get( "AlbCliT", nView ) )->cSufAlb := "00"
               D():UnLock( "AlbCliT", nView )
            end if

         end if

         if !empty( ( D():Get( "AlbCliT", nView ) )->cNumPre ) .and. Len( AllTrim( ( D():Get( "AlbCliT", nView ) )->cNumPre ) ) != 12
            
            if D():Lock( "AlbCliT", nView )
               ( D():Get( "AlbCliT", nView ) )->cNumPre := AllTrim( ( D():Get( "AlbCliT", nView ) )->cNumPre ) + "00"
               D():UnLock( "AlbCliT", nView )
            end if   

         end if

         if !empty( ( D():Get( "AlbCliT", nView ) )->cNumPed ) .and. Len( AllTrim( ( D():Get( "AlbCliT", nView ) )->cNumPed ) ) != 12
            
            if D():Lock( "AlbCliT", nView )
               ( D():Get( "AlbCliT", nView ) )->cNumPed := AllTrim( ( D():Get( "AlbCliT", nView ) )->cNumPed ) + "00"
               D():UnLock( "AlbCliT", nView )
            end if

         end if

         if !empty( ( D():Get( "AlbCliT", nView ) )->cNumSat ) .and. Len( AllTrim( ( D():Get( "AlbCliT", nView ) )->cNumSat ) ) != 12
            
            if D():Lock( "AlbCliT", nView )
               ( D():Get( "AlbCliT", nView ) )->cNumSat := AllTrim( ( D():Get( "AlbCliT", nView ) )->cNumSat ) + "00"
               D():UnLock( "AlbCliT", nView )
            end if

         end if

         if !empty( ( D():Get( "AlbCliT", nView ) )->cNumFac ) .and. Len( AllTrim( ( D():Get( "AlbCliT", nView ) )->cNumFac ) ) != 12
            
            if D():Lock( "AlbCliT", nView )
               ( D():Get( "AlbCliT", nView ) )->cNumFac := AllTrim( ( D():Get( "AlbCliT", nView ) )->cNumFac ) + "00"
               D():UnLock( "AlbCliT", nView )
            end if   

         end if

         if !empty( ( D():Get( "AlbCliT", nView ) )->cNumDoc ) .and. Len( AllTrim( ( D():Get( "AlbCliT", nView ) )->cNumDoc ) ) != 12
            
            if D():Lock( "AlbCliT", nView )
               ( D():Get( "AlbCliT", nView ) )->cNumDoc := AllTrim( ( D():Get( "AlbCliT", nView ) )->cNumDoc ) + "00"
               D():UnLock( "AlbCliT", nView )
            end if   

         end if

         if !empty( ( D():Get( "AlbCliT", nView ) )->cNumTik ) .and. Len( AllTrim( ( D():Get( "AlbCliT", nView ) )->cNumTik ) ) != 13
            
            if D():Lock( "AlbCliT", nView )
               ( D():Get( "AlbCliT", nView ) )->cNumTik := AllTrim( ( D():Get( "AlbCliT", nView ) )->cNumTik ) + "00"
               D():UnLock( "AlbCliT", nView )
            end if

         end if

         if empty( ( D():Get( "AlbCliT", nView ) )->cCodCaj )
            
            if D():Lock( "AlbCliT", nView )
               ( D():Get( "AlbCliT", nView ) )->cCodCaj := "000"
               D():UnLock( "AlbCliT", nView )
            end if   

         end if

         cCodGrp        := RetGrpCli( ( D():Get( "AlbCliT", nView ) )->cCodCli, D():Get( "Client", nView ) )

         if ( D():Get( "AlbCliT", nView ) )->cCodGrp != cCodGrp
            
            if D():Lock( "AlbCliT", nView )
               ( D():Get( "AlbCliT", nView ) )->cCodGrp := cCodGrp
               D():UnLock( "AlbCliT", nView )
            end if   

         end if

         if empty( ( D():Get( "AlbCliT", nView ) )->cNomCli ) .and. !empty ( ( D():Get( "AlbCliT", nView ) )->cCodCli )
            
            if D():Lock( "AlbCliT", nView )
               ( D():Get( "AlbCliT", nView ) )->cNomCli := RetFld( ( D():Get( "AlbCliT", nView ) )->cCodCli, D():Get( "Client", nView ), "Titulo" )
               D():UnLock( "AlbCliT", nView )
            end if   
         
         end if

         /*
         Esto es para Cafes y zumos para que todos los albaranes tengan la ruta del cliente
         */

         /*if D():Lock( "AlbCliT", nView )
            ( D():Get( "AlbCliT", nView ) )->cCodRut    := RetFld( ( D():Get( "AlbCliT", nView ) )->cCodCli, D():Get( "Client", nView ), "CCODRUT" )
            D():UnLock( "AlbCliT", nView )
         end if*/
         
         /*
         Rellenamos los campos de totales-----------------------------------------
         */

         if ( D():Get( "AlbCliT", nView ) )->nTotAlb == 0 

            if D():Lock( "AlbCliT", nView )

               aTotAlb              := aTotAlbCli( ( D():Get( "AlbCliT", nView ) )->cSerAlb + Str( ( D():Get( "AlbCliT", nView ) )->nNumAlb ) + ( D():Get( "AlbCliT", nView ) )->cSufAlb, D():Get( "AlbCliT", nView ), D():Get( "AlbCliL", nView ), D():Get( "TIva", nView ), D():Get( "Divisas", nView ), ( D():Get( "AlbCliT", nView ) )->cDivAlb )
   
               ( D():Get( "AlbCliT", nView ) )->nTotNet := aTotAlb[1]
               ( D():Get( "AlbCliT", nView ) )->nTotIva := aTotAlb[2]
               ( D():Get( "AlbCliT", nView ) )->nTotReq := aTotAlb[3]
               ( D():Get( "AlbCliT", nView ) )->nTotAlb := aTotAlb[4]
   
               D():UnLock( "AlbCliT", nView )

            end if 

         end if

         /*
         Si el albarán está creado desde un pedido le revisamos el estado---------
         */

         aAdd( aNumPed, ( D():Get( "AlbCliT", nView ) )->cNumPed )

         ( D():Get( "AlbCliT", nView ) )->( dbSkip() )

      end while

      ( D():Get( "AlbCliT", nView ) )->( ordSetFocus( 1 ) )

      /*
      Lineas----------------------------------------------------------------------
      */

      ( D():Get( "AlbCliL", nView ) )->( ordSetFocus( 0 ) )
      ( D():Get( "AlbCliL", nView ) )->( dbGoTop() )

      while !( D():Get( "AlbCliL", nView ) )->( eof() )

         if empty( ( D():Get( "AlbCliL", nView ) )->cSufAlb )
            if dbLock( D():Get( "AlbCliL", nView ) )
               ( D():Get( "AlbCliL", nView ) )->cSufAlb    := "00"
               ( D():Get( "AlbCliL", nView ) )->( dbUnLock() )
            end if
         end if

         if !empty( ( D():Get( "AlbCliL", nView ) )->cNumPed ) .and. Len( AllTrim( ( D():Get( "AlbCliL", nView ) )->cNumPed ) ) != 12
            if dbLock( D():Get( "AlbCliL", nView ) )
               ( D():Get( "AlbCliL", nView ) )->cNumPed := AllTrim( ( D():Get( "AlbCliL", nView ) )->cNumPed ) + "00"
               ( D():Get( "AlbCliL", nView ) )->( dbUnLock() )
            end if   
         end if

         if !empty( ( D():Get( "AlbCliL", nView ) )->cNumSat ) .and. Len( AllTrim( ( D():Get( "AlbCliL", nView ) )->cNumSat ) ) != 12
            if dbLock( D():Get( "AlbCliL", nView ) )
               ( D():Get( "AlbCliL", nView ) )->cNumSat := AllTrim( ( D():Get( "AlbCliL", nView ) )->cNumSat ) + "00"
               ( D():Get( "AlbCliL", nView ) )->( dbUnlock() )
            end if   
         end if

         if empty( ( D():Get( "AlbCliL", nView ) )->cLote ) .and. !empty( ( D():Get( "AlbCliL", nView ) )->nLote )
            if dbLock( D():Get( "AlbCliL", nView ) )
               ( D():Get( "AlbCliL", nView ) )->cLote      := AllTrim( Str( ( D():Get( "AlbCliL", nView ) )->nLote ) )
               ( D():Get( "AlbCliL", nView ) )->( dbUnLock() )
            end if
         end if

         if empty( ( D():Get( "AlbCliL", nView ) )->nVolumen )
            if dbLock( D():Get( "AlbCliL", nView ) )
               ( D():Get( "AlbCliL", nView ) )->nVolumen   := RetFld( ( D():Get( "AlbCliL", nView ) )->CREF, D():Articulos( nView ), "nVolumen" )
               ( D():Get( "AlbCliL", nView ) )->( dbUnlock() )
            end if
         end if

         if ( D():Get( "AlbCliL", nView ) )->lIvaLin != RetFld( ( D():Get( "AlbCliL", nView ) )->cSerAlb + Str( ( D():Get( "AlbCliL", nView ) )->nNumAlb ) + ( D():Get( "AlbCliL", nView ) )->cSufAlb, D():Get( "AlbCliT", nView ), "lIvaInc" )
            if dbLock( D():Get( "AlbCliL", nView ) )
               ( D():Get( "AlbCliL", nView ) )->lIvaLin    := RetFld( ( D():Get( "AlbCliL", nView ) )->cSerAlb + Str( ( D():Get( "AlbCliL", nView ) )->nNumAlb ) + ( D():Get( "AlbCliL", nView ) )->cSufAlb, D():Get( "AlbCliT", nView ), "lIvaInc" )
               ( D():Get( "AlbCliL", nView ) )->( dbUnlock() )
            end if
         end if

         if !empty( ( D():Get( "AlbCliL", nView ) )->cRef ) .and. empty( ( D():Get( "AlbCliL", nView ) )->cCodFam )
            if dbLock( D():Get( "AlbCliL", nView ) )
               ( D():Get( "AlbCliL", nView ) )->cCodFam    := RetFamArt( ( D():Get( "AlbCliL", nView ) )->cRef, D():Articulos( nView ) )
               ( D():Get( "AlbCliL", nView ) )->( dbUnLock() )
            end if   
         end if

         if !empty( ( D():Get( "AlbCliL", nView ) )->cRef ) .and. !empty( ( D():Get( "AlbCliL", nView ) )->cCodFam )
            if dbLock( D():Get( "AlbCliL", nView ) )
               ( D():Get( "AlbCliL", nView ) )->cGrpFam    := cGruFam( ( D():Get( "AlbCliL", nView ) )->cCodFam, D():Familias( nView ) )
               ( D():Get( "AlbCliL", nView ) )->( dbUnLock() )
            end if
         end if

         if empty( ( D():Get( "AlbCliL", nView ) )->nReq )
            if dbLock( D():Get( "AlbCliL", nView ) )
               ( D():Get( "AlbCliL", nView ) )->nReq       := nPReq( D():Get( "TIva", nView ), ( D():Get( "AlbCliL", nView ) )->nIva )
               ( D():Get( "AlbCliL", nView ) )->( dbUnLock() )
            end if
         end if

         if ( D():AlbaranesClientesLineas( nView ) )->nRegIva != RetFld( D():AlbaranesClientesLineasId( nView ), D():AlbaranesClientes( nView ), "nRegIva" )
            if dbLock( D():AlbaranesClientesLineas( nView ) )
               ( D():AlbaranesClientesLineas( nView ) )->nRegIva := RetFld( D():AlbaranesClientesLineasId( nView ), D():AlbaranesClientes( nView ), "nRegIva" )
               ( D():AlbaranesClientesLineas( nView ) )->( dbUnlock() )
            end if
         end if

         // Estado de facturado------------------------------------------------

         if ( D():AlbaranesClientesLineas( nView ) )->lFacturado != RetFld( D():AlbaranesClientesLineasId( nView ), D():AlbaranesClientes( nView ), "lFacturado" )
            if dbLock( D():AlbaranesClientesLineas( nView ) )
               ( D():AlbaranesClientesLineas( nView ) )->lFacturado := RetFld( D():AlbaranesClientesLineasId( nView ), D():AlbaranesClientes( nView ), "lFacturado" )
               ( D():AlbaranesClientesLineas( nView ) )->( dbUnlock() )
            end if
         end if

         // Fecha ----------------------------------------------------------

         if ( D():Get( "AlbCliT", nView ) )->( dbseek( ( D():Get( "AlbCliL", nView ) )->cSerAlb + Str( ( D():Get( "AlbCliL", nView ) )->nNumAlb ) + ( D():Get( "AlbCliL", nView ) )->cSufAlb ) )

            if ( D():Get( "AlbCliL", nView ) )->dFecAlb != ( D():Get( "AlbCliT", nView ) )->dFecAlb
               if dbLock( D():Get( "AlbCliL", nView ) )
                  ( D():Get( "AlbCliL", nView ) )->dFecAlb    := ( D():Get( "AlbCliT", nView ) )->dFecAlb
                  ( D():Get( "AlbCliL", nView ) )->( dbUnlock() )
               end if   
            end if

            if ( D():Get( "AlbCliL", nView ) )->tFecAlb != ( D():Get( "AlbCliT", nView ) )->tFecAlb
               if dbLock( D():Get( "AlbCliL", nView ) )
                  ( D():Get( "AlbCliL", nView ) )->tFecAlb    := ( D():Get( "AlbCliT", nView ) )->tFecAlb
                  ( D():Get( "AlbCliL", nView ) )->( dbUnlock() )
               end if   
            end if

            if ( D():Get( "AlbCliL", nView ) )->cCodCli != ( D():Get( "AlbCliT", nView ) )->cCodCli
               if dbLock( D():Get( "AlbCliL", nView ) )
                  ( D():Get( "AlbCliL", nView ) )->cCodCli    := ( D():Get( "AlbCliT", nView ) )->cCodCli
                  ( D():Get( "AlbCliL", nView ) )->( dbUnlock() )
               end if   
            end if

            if empty( ( D():Get( "AlbCliL", nView ) )->cAlmLin )
               if dbLock( D():Get( "AlbCliL", nView ) )
                  ( D():Get( "AlbCliL", nView ) )->cAlmLin    := ( D():Get( "AlbCliT", nView ) )->cCodAlm
                  ( D():Get( "AlbCliL", nView ) )->( dbUnLock() )
               end if   
            end if

            if empty( ( D():Get( "AlbCliL", nView ) )->nPosPrint )
               if dbLock( D():Get( "AlbCliL", nView ) )
                  ( D():Get( "AlbCliL", nView ) )->nPosPrint    := ( D():Get( "AlbCliL", nView ) )->nNumLin
                  ( D():Get( "AlbCliL", nView ) )->( dbUnLock() )
               end if   
            end if

         end if 

         /*
         Cargamos los costos para Marbaroso------------------------------------
         */
         /*

         if !empty( ( D():Get( "AlbCliL", nView ) )->cRef ) .and. empty( ( D():Get( "AlbCliL", nView ) )->nCosDiv )
            if dbLock( D():Get( "AlbCliL", nView ) )
               ( D():Get( "AlbCliL", nView ) )->nCosDiv := oStock:nCostoMedio( ( D():Get( "AlbCliL", nView ) )->cRef, ( D():Get( "AlbCliL", nView ) )->cAlmLin, ( D():Get( "AlbCliL", nView ) )->cCodPr1, ( D():Get( "AlbCliL", nView ) )->cCodPr2, ( D():Get( "AlbCliL", nView ) )->cValPr1, ( D():Get( "AlbCliL", nView ) )->cValPr2, ( D():Get( "AlbCliL", nView ) )->cLote )
               ( D():Get( "AlbCliL", nView ) )->( dbUnLock() )
            end if
         end if

         */

         // Numeros de serie------------------------------------------------------

         if !empty( ( D():Get( "AlbCliL", nView ) )->mNumSer )

            aNumSer                       := hb_aTokens( ( D():Get( "AlbCliL", nView ) )->mNumSer, "," )
         
            for each cNumSer in aNumSer
               ( D():Get( "AlbCliS", nView ) )->( dbAppend() )
               ( D():Get( "AlbCliS", nView ) )->cSerAlb    := ( D():Get( "AlbCliL", nView ) )->cSerAlb
               ( D():Get( "AlbCliS", nView ) )->nNumAlb    := ( D():Get( "AlbCliL", nView ) )->nNumAlb
               ( D():Get( "AlbCliS", nView ) )->cSufAlb    := ( D():Get( "AlbCliL", nView ) )->cSufAlb
               ( D():Get( "AlbCliS", nView ) )->cRef       := ( D():Get( "AlbCliL", nView ) )->cRef
               ( D():Get( "AlbCliS", nView ) )->cAlmLin    := ( D():Get( "AlbCliL", nView ) )->cAlmLin
               ( D():Get( "AlbCliS", nView ) )->nNumLin    := ( D():Get( "AlbCliL", nView ) )->nNumLin
               ( D():Get( "AlbCliS", nView ) )->lFacturado := ( D():Get( "AlbCliL", nView ) )->lFacturado
               ( D():Get( "AlbCliS", nView ) )->cNumSer    := cNumSer
               ( D():Get( "AlbCliS", nView ) )->( dbUnLock() )
            next
            
            if dbLock( D():Get( "AlbCliL", nView ) )
               ( D():Get( "AlbCliL", nView ) )->mNumSer    := ""
            end if
              
         end if

         ( D():Get( "AlbCliL", nView ) )->( dbSkip() )

         SysRefresh()

      end while

      ( D():Get( "AlbCliL", nView ) )->( ordSetFocus( 1 ) )

      // Incidencias--------------------------------------------------------------

      ( D():Get( "AlbCliI", nView ) )->( ordSetFocus( 0 ) )
      ( D():Get( "AlbCliI", nView ) )->( dbGoTop() )

      while !( D():Get( "AlbCliI", nView ) )->( eof() )

         if empty( ( D():Get( "AlbCliI", nView ) )->cSufAlb )
            if dbLock( D():Get( "AlbCliI", nView ) )
               ( D():Get( "AlbCliI", nView ) )->cSufAlb    := "00"
               ( D():Get( "AlbCliI", nView ) )->( dbUnLock() )
            end if   
         end if

         ( D():Get( "AlbCliI", nView ) )->( dbSkip() )

         SysRefresh()

      end while

      ( D():Get( "AlbCliI", nView ) )->( OrdSetFocus( 1 ) )

      // Series ---------------------------------------------------------------

      ( D():Get( "AlbCliS", nView ) )->( ordSetFocus( 0 ) )
      ( D():Get( "AlbCliS", nView ) )->( dbGoTop() )

      while !( D():Get( "AlbCliS", nView ) )->( eof() )

         if empty( ( D():Get( "AlbCliS", nView ) )->cSufAlb )
            if dbLock( D():Get( "AlbCliS", nView ) )
               ( D():Get( "AlbCliS", nView ) )->cSufAlb    := "00"
               ( D():Get( "AlbCliS", nView ) )->( dbUnLock() )
            end if   
         end if

         if ( D():Get( "AlbCliS", nView ) )->dFecAlb != RetFld( ( D():Get( "AlbCliL", nView ) )->cSerAlb + Str( ( D():Get( "AlbCliL", nView ) )->nNumAlb ) + ( D():Get( "AlbCliL", nView ) )->cSufAlb, D():Get( "AlbCliT", nView ), "dFecAlb" )
            if dbLock( D():Get( "AlbCliS", nView ) )
               ( D():Get( "AlbCliS", nView ) )->dFecAlb    := RetFld( ( D():Get( "AlbCliL", nView ) )->cSerAlb + Str( ( D():Get( "AlbCliL", nView ) )->nNumAlb ) + ( D():Get( "AlbCliL", nView ) )->cSufAlb, D():Get( "AlbCliT", nView ), "dFecAlb" )
               ( D():Get( "AlbCliS", nView ) )->( dbUnlock() )
            end
         end if

         ( D():Get( "AlbCliS", nView ) )->( dbSkip() )

         SysRefresh()

      end while

      ( D():Get( "AlbCliS", nView ) )->( ordSetFocus( 1 ) )

      // Lineas huerfanas------------------------------------------------------

      /*( D():Get( "AlbCliT", nView ) )->( ordsetfocus( 1 ) )
      ( D():Get( "AlbCliL", nView ) )->( ordsetfocus( 1 ) )

      ( D():Get( "AlbCliL", nView ) )->( dbgotop() )
      while !( D():Get( "AlbCliL", nView ) )->( eof() )

         if !( D():Get( "AlbCliT", nView ) )->( dbseek( ( D():Get( "AlbCliL", nView ) )->cSerAlb + Str( ( D():Get( "AlbCliL", nView ) )->nNumAlb ) + ( D():Get( "AlbCliL", nView ) )->cSufAlb ) )
            if dbLock( D():Get( "AlbCliL", nView ) )
	            ( D():Get( "AlbCliL", nView ) )->( dbdelete() )
	        end if
         end if 

         ( D():Get( "AlbCliL", nView ) )->( dbskip( 1 ) )
         
         SysRefresh()

      end while*/

      CloseFiles()

   end if

   /*
   Estado de los pedidos-------------------------------------------------------
   */

   oStock               := TStock():Create()
   if oStock:lOpenFiles()

      for each cNumPed in aNumPed
         oStock:SetEstadoPedCli( cNumPed )
      end if

   end if
       
   if !empty( oStock )
      oStock:end()
   end if

   oStock      := nil

return nil

//------------------------------------------------------------------------//

FUNCTION PrnEntAlb( cNumEnt, lPrint )

   local nLevel         := Auth():Level( _MENUITEM_ )

   if nAnd( nLevel, 1 ) == 0 .or. nAnd( nLevel, ACC_IMPR ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if OpenFiles( nil, .t. )

      if dbSeekInOrd( cNumEnt, "nNumAlb", D():Get( "AlbCliP", nView ) )
         PrnEntregas( lPrint, D():Get( "AlbCliP", nView ) )
      end if

      CloseFiles()

   end if

Return .t.

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

      if !empty( ( dbfDoc )->mReport )

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

         oFr:AddBand(         "MasterData",  "MainPage", frxMasterData )
         oFr:SetProperty(     "MasterData",  "Top", 200 )
         oFr:SetProperty(     "MasterData",  "Height", 0 )
         oFr:SetProperty(     "MasterData",  "StartNewPage", .t. )
         oFr:SetObjProperty(  "MasterData",  "DataSet", "Albaranes" )

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

Function DesignReportEntAlbCli( oFr, dbfDoc )

   if OpenFiles()

      /*
      Zona de datos------------------------------------------------------------
      */

      DataReportEntAlbCli( oFr )

      /*
      Paginas y bandas---------------------------------------------------------
      */

      if !empty( ( dbfDoc )->mReport )

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

         oFr:AddBand(         "MasterData",  "MainPage", frxMasterData )
         oFr:SetProperty(     "MasterData",  "Top", 300 )
         oFr:SetProperty(     "MasterData",  "Height", 0 )
         oFr:SetProperty(     "MasterData",  "StartNewPage", .t. )
         oFr:SetObjProperty(  "MasterData",  "DataSet", "Entrega" )

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

FUNCTION PrnEntAlbCli( cNumDoc, lPrint, dbfTmpEnt )

   local nLevel         := Auth():Level( _MENUITEM_ )

   if nAnd( nLevel, 1 ) == 0 .or. nAnd( nLevel, ACC_IMPR ) == 0
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

//---------------------------------------------------------------------------//

function nUnidadesRecibidasAlbaranesClientesNoFacturados( cNumPed, cCodArt, cValPr1, cValPr2, cAlbCliL )

   local nTot        := 0
   local aStaLin     := aGetStatus( cAlbCliL, .f. )

   DEFAULT cValPr1   := Space( 20 )
   DEFAULT cValPr2   := Space( 20 )

   ( cAlbCliL )->( ordsetfocus( "cRefNoFac" ) )
   if ( cAlbCliL )->( dbseek( cNumPed + cCodArt + cValPr1 + cValPr2 ) )
      
      while ( cAlbCliL )->cNumPed + ( cAlbCliL )->cRef + ( cAlbCliL )->cValPr1 + ( cAlbCliL )->cValPr2 == cNumPed + cCodArt + cValPr1 + cValPr2 .and. !( cAlbCliL )->( eof() )
         nTot        += nTotNAlbCli( cAlbCliL )
         ( cAlbCliL )->( dbskip() )
      end while

   end if

   SetStatus( cAlbCliL, aStaLin )

return ( nTot )

//---------------------------------------------------------------------------//

function nTotNAlbCli( uDbf )

   local nTotUnd

   DEFAULT uDbf   := D():Get( "AlbCliL", nView )

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

      case ValType( uDbf ) == "H"

         nTotUnd  := NotCaja( hGet( uDbf, "Cajas" ) )
         nTotUnd  *= hGet( uDbf, "Unidades" )
         nTotUnd  *= NotCero( hGet( uDbf, "UnidadesKit" ) )
         nTotUnd  *= NotCero( hGet( uDbf, "Medicion1" ) )
         nTotUnd  *= NotCero( hGet( uDbf, "Medicion2" ) )
         nTotUnd  *= NotCero( hGet( uDbf, "Medicion3" ) )

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

   DEFAULT uDbf   := D():Get( "AlbCliL", nView )

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

Function isLineaTotalAlbCli( uAlbCliL )

   if isArray( uAlbCliL )
      Return ( uAlbCliL[ _LTOTLIN ] )
   end if

Return ( ( uAlbCliL )->lTotLin )

//---------------------------------------------------------------------------//

Function nDescuentoLinealAlbCli( uAlbCliL, nDec, nVdv )

   local nDescuentoLineal

   if isArray( uAlbCliL )
      nDescuentoLineal  := uAlbCliL[ _NDTODIV ]
   else 
      nDescuentoLineal  := ( uAlbCliL )->nDtoDiv
   end if

Return ( Round( nDescuentoLineal / nVdv, nDec ) )

//---------------------------------------------------------------------------//

Function nDescuentoPorcentualAlbCli( uAlbCliL )

   local nDescuentoPorcentual

   if isArray( uAlbCliL )
      nDescuentoPorcentual  := uAlbCliL[ _NDTO ]
   else 
      nDescuentoPorcentual  := ( uAlbCliL )->nDto
   end if

Return ( nDescuentoPorcentual )

//---------------------------------------------------------------------------//

Function nDescuentoPromocionAlbCli( uAlbCliL )

   local nDescuentoPromocion

   if isArray( uAlbCliL )
      nDescuentoPromocion  := uAlbCliL[ _NDTOPRM ]
   else 
      nDescuentoPromocion  := ( uAlbCliL )->nDtoPrm
   end if

Return ( nDescuentoPromocion )

//---------------------------------------------------------------------------//

Function nPuntoVerdeAlbCli( uAlbCliL )

   local nPuntoVerde

   if isArray( uAlbCliL )
      nPuntoVerde  := uAlbCliL[ _NPNTVER ]
   else 
      nPuntoVerde  := ( uAlbCliL )->nPntVer
   end if

Return ( nPuntoVerde )

//---------------------------------------------------------------------------//

Function nTransporteAlbCli( uAlbCliL )

   local nTransporte

   if isArray( uAlbCliL )
      nTransporte  := uAlbCliL[ _NIMPTRN ]
   else 
      nTransporte  := ( uAlbCliL )->nImpTrn
   end if

Return ( nTransporte )

//---------------------------------------------------------------------------//

FUNCTION nTotLAlbCli( uAlbCliL, nDec, nRou, nVdv, lDto, lPntVer, lImpTrn, cPouDiv )

   local nCalculo
   local nUnidades

   DEFAULT uAlbCliL  := D():Get( "AlbCliL", nView )
   DEFAULT nDec      := nDouDiv()
   DEFAULT nRou      := nRouDiv()
   DEFAULT nVdv      := 1
   DEFAULT lDto      := .t.
   DEFAULT lPntVer   := .t.
   DEFAULT lImpTrn   := .t.

   if isLineaTotalAlbCli( uAlbCliL )

      nCalculo          := nTotUAlbCli( uAlbCliL, nDec, nVdv )

   else

      nUnidades         := nTotNAlbCli( uAlbCliL )
      nCalculo          := nTotUAlbCli( uAlbCliL, nDec, nVdv ) * nUnidades

      /*
      Descuentos---------------------------------------------------------------
      */

      nCalculo          -= nDescuentoLinealAlbCli( uAlbCliL, nDec, nVdv ) * nUnidades

      if lDto .and. nDescuentoPorcentualAlbCli( uAlbCliL ) != 0 
         nCalculo       -= nCalculo * nDescuentoPorcentualAlbCli( uAlbCliL ) / 100
      end if

      if lDto .and. nDescuentoPromocionAlbCli( uAlbCliL ) != 0 
         nCalculo       -= nCalculo * nDescuentoPromocionAlbCli( uAlbCliL ) / 100
      end if

      /*
      Punto Verde--------------------------------------------------------------
      */

      if lPntVer .and. nPuntoVerdeAlbCli( uAlbCliL ) != 0
         nCalculo       += nPuntoVerdeAlbCli( uAlbCliL ) * nUnidades
      end if

      /*
      Transporte---------------------------------------------------------------
      */

      if lImpTrn .and. nTransporteAlbCli( uAlbCliL ) != 0
         nCalculo       += nTransporteAlbCli( uAlbCliL ) * nUnidades
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

//
// Precio del punto verde por linea
//

FUNCTION nPntLAlbCli( dbfLin, nDec, nVdv )

   local nPntVer

   DEFAULT dbfLin    := D():Get( "AlbCliL", nView )
   DEFAULT nDec      := 0
   DEFAULT nVdv      := 1

   /*
   Punto Verde
   */

   nPntVer           := ( dbfLin )->nPntVer * nTotNAlbCli( dbfLin )

RETURN ( Round( nPntVer, nDec ) )

//---------------------------------------------------------------------------//
/*
Devuelve el importe de descuento porcentual por cada linea---------------------
*/

FUNCTION nDtoLAlbCli( cAlbCliL, nDec, nRou, nVdv )

   local nCalculo       := 0

   DEFAULT cAlbCliL     := D():Get( "AlbCliL", nView )
   DEFAULT nDec         := nDouDiv()
   DEFAULT nRou         := nRouDiv()
   DEFAULT nVdv         := 1

   if ( cAlbCliL )->nDto != 0 .and. !( cAlbCliL )->lTotLin

      nCalculo          := nTotUAlbCli( cAlbCliL, nDec ) * nTotNAlbCli( cAlbCliL )

      /*
      Descuentos---------------------------------------------------------------
      */

      nCalculo          -= Round( ( cAlbCliL )->nDtoDiv / nVdv , nDec )

      nCalculo          := nCalculo * ( cAlbCliL )->nDto / 100


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

FUNCTION nPrmLAlbCli( cAlbCliL, nDec, nRou, nVdv )

   local nCalculo       := 0

   DEFAULT cAlbCliL     := D():Get( "AlbCliL", nView )
   DEFAULT nDec         := nDouDiv()
   DEFAULT nRou         := nRouDiv()
   DEFAULT nVdv         := 1

   if ( cAlbCliL )->nDtoPrm != 0 .and. !( cAlbCliL )->lTotLin

      nCalculo          := nTotUAlbCli( cAlbCliL, nDec ) * nTotNAlbCli( cAlbCliL )

      /*
      Descuentos---------------------------------------------------------------
      */

      nCalculo          -= Round( ( cAlbCliL )->nDtoDiv / nVdv , nDec )

      if ( cAlbCliL )->nDto != 0 
         nCalculo       -= nCalculo * ( cAlbCliL )->nDto / 100
      end if

      nCalculo          := nCalculo * ( cAlbCliL )->nDtoPrm / 100

      if nVdv != 0
         nCalculo       := nCalculo / nVdv
      end if

      if nRou != nil
         nCalculo       := Round( nCalculo, nRou )
      end if

   end if

RETURN ( nCalculo ) 

//---------------------------------------------------------------------------//

//
// Precio unitario
//

FUNCTION nTotUAlbCli( uTmpLin, nDec, nVdv )

   local nCalculo    := 0

   DEFAULT uTmpLin   := D():Get( "AlbCliL", nView )
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
            nCalculo    := uTmpLin[ _NPREALQ ]
         else
            nCalculo    := uTmpLin[ _NPREUNIT ]
         end if

      case IsHash( uTmpLin )

         nCalculo       := hGet( uTmpLin, "PrecioVenta" )

   end case

   if nVdv != 0
      nCalculo          := nCalculo / nVdv
   end if

RETURN ( Round( nCalculo, nDec ) )

//---------------------------------------------------------------------------//

FUNCTION nNetUAlbCli( cAlbCliL, nDec, nVdv, cPouDiv )

   local nCalculo

   DEFAULT cAlbCliL  := D():Get( "AlbCliL", nView )
   DEFAULT nDec      := nDouDiv()
   DEFAULT nVdv      := 1

   nCalculo          := nTotUAlbCli( cAlbCliL, nDec, nVdv )

   if ( cAlbCliL )->nIva != 0
      if ( cAlbCliL )->lIvaLin
         nCalculo -= nCalculo / ( 100 / ( cAlbCliL )->nIva  + 1 )
      end if   
   end if

RETURN ( if( cPouDiv != nil, Trans( nCalculo, cPouDiv ), nCalculo ) )

//---------------------------------------------------------------------------//
//
// Valor del punto verde
//

Function nPntUAlbCli( cDbfTmpLin, nDec, nVdv )

   local nCalculo := ( cDbfTmpLin )->nPntVer

   DEFAULT nDec   := 0
   DEFAULT nVdv   := 1

   IF nVdv != 0
      nCalculo    := ( cDbfTmpLin )->nPntVer / nVdv
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

   if !lExistTable( cPath + "AlbCliE.Dbf" )
      dbCreate( cPath + "AlbCliE.Dbf", aSqlStruct( aAlbCliEst() ), cDriver() )
   end if

   if !lExistIndex( cPath + "AlbCliT.Cdx" ) .or. ;
      !lExistIndex( cPath + "AlbCliL.Cdx" ) .or. ;
      !lExistIndex( cPath + "AlbCliP.Cdx" ) .or. ;
      !lExistIndex( cPath + "AlbCliI.Cdx" ) .or. ;
      !lExistTable( cPath + "AlbCliD.Cdx" ) .or. ;
      !lExistTable( cPath + "AlbCliE.Cdx" )

      rxAlbCli( cPath )

   end if

Return ( .t. )

//---------------------------------------------------------------------------//

FUNCTION mkAlbCli( cPath, lAppend, cPathOld, oMeter, bFor )

   local oBlock
   local oError
   local cAlbCliT
   local cAlbCliL
   local cAlbCliI
   local cAlbCliD
   local cAlbCliP
   local oldAlbCliT
   local oldAlbCliL
   local oldAlbCliI
   local oldAlbCliD
   local oldAlbCliP

   DEFAULT lAppend   := .f.
   DEFAULT bFor      := {|| .t. }

   if oMeter != nil
      oMeter:cText   := "Generando Bases"
      sysrefresh()
   end if

   CreateFiles( cPath )

   rxAlbCli( cPath, cLocalDriver() )

   if lAppend .and. lIsDir( cPathOld )

      oBlock         := ErrorBlock( { | oError | ApoloBreak( oError ) } )
      BEGIN SEQUENCE

      dbUseArea( .t., cDriver(), cPath + "ALBCLIT.DBF", cCheckArea( "ALBCLIT", @cAlbCliT ), .f. )
      ( cAlbCliT )->( ordListAdd( cPath + "ALBCLIT.CDX" ) )

      dbUseArea( .t., cDriver(), cPath + "ALBCLIL.DBF", cCheckArea( "ALBCLIL", @cAlbCliL ), .f. )
      ( cAlbCliL )->( ordListAdd( cPath + "ALBCLIL.CDX" ) )

      dbUseArea( .t., cDriver(), cPath + "AlbCliI.Dbf", cCheckArea( "AlbCliI", @cAlbCliI ), .f. )
      ( cAlbCliI )->( ordListAdd( cPath + "AlbCliI.Cdx"  ) )

      dbUseArea( .t., cDriver(), cPath + "AlbCliD.Dbf", cCheckArea( "AlbCliD", @cAlbCliD ), .f. )
      ( cAlbCliD )->( ordListAdd( cPath + "AlbCliD.Cdx"  ) )

      dbUseArea( .t., cDriver(), cPath + "AlbCliP.Dbf", cCheckArea( "AlbCliP", @cAlbCliP ), .f. )
      ( cAlbCliP )->( ordListAdd( cPath + "AlbCliP.Cdx"  ) )

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
            dbCopy( oldAlbCliT, cAlbCliT, .t. )

            if ( oldAlbCliL )->( dbSeek( (oldAlbCliT)->CSERALB + Str( (oldAlbCliT)->NNUMALB ) + (oldAlbCliT)->CSUFALB ) )
               while ( oldAlbCliL )->CSERALB + Str( ( oldAlbCliL )->NNUMALB ) + ( oldAlbCliL )->CSUFALB == (oldAlbCliT)->CSERALB + Str( (cAlbCliT)->NNUMALB ) + (cAlbCliT)->CSUFALB .and. !(oldAlbCliL)->( eof() )
                  dbCopy( oldAlbCliL, cAlbCliL, .t. )
                  ( oldAlbCliL )->( dbSkip() )
               end while
            end if

            if ( oldAlbCliI )->( dbSeek( (oldAlbCliT)->CSERALB + Str( (oldAlbCliT)->NNUMALB ) + (oldAlbCliT)->CSUFALB ) )
               while ( oldAlbCliI )->CSERALB + Str( ( oldAlbCliI )->NNUMALB ) + ( oldAlbCliI )->CSUFALB == ( oldAlbCliT )->CSERALB + Str( ( cAlbCliT )->NNUMALB ) + ( cAlbCliT )->CSUFALB .and. !( oldAlbCliI )->( eof() )
                  dbCopy( oldAlbCliI, cAlbCliI, .t. )
                  ( oldAlbCliI )->( dbSkip() )
               end while
            end if

            if ( oldAlbCliD )->( dbSeek( (oldAlbCliT)->CSERALB + Str( (oldAlbCliT)->NNUMALB ) + (oldAlbCliT)->CSUFALB ) )
               while ( oldAlbCliD )->CSERALB + Str( ( oldAlbCliD )->NNUMALB ) + ( oldAlbCliD )->CSUFALB == ( oldAlbCliT )->CSERALB + Str( ( cAlbCliT )->NNUMALB ) + ( cAlbCliT )->CSUFALB .and. !( oldAlbCliI )->( eof() )
                  dbCopy( oldAlbCliD, cAlbCliD, .t. )
                  ( oldAlbCliD )->( dbSkip() )
               end while
            end if

            if ( oldAlbCliP )->( dbSeek( ( oldAlbCliT )->CSERALB + Str( ( oldAlbCliT )->NNUMALB ) + ( oldAlbCliT )->CSUFALB ) )
               while ( oldAlbCliP )->CSERALB + Str( ( oldAlbCliP )->NNUMALB ) + ( oldAlbCliP )->CSUFALB == ( oldAlbCliT )->CSERALB + Str( ( cAlbCliT )->NNUMALB ) + ( cAlbCliT )->CSUFALB .and. !( oldAlbCliI )->( eof() )
                  dbCopy( oldAlbCliP, cAlbCliP, .t. )
                  ( oldAlbCliP )->( dbSkip() )
               end while
            end if

         end if

         ( oldAlbCliT )->( dbSkip() )

      end while

      /*
      Reemplaza la antigua sesion----------------------------------------------
      */

      ( cAlbCliT )->( dbEval( {|| ( cAlbCliT )->cTurAlb := Space( 6 ) },,,,, .f. ) )


      ( cAlbCliT )->( dbCloseArea() )
      ( cAlbCliL )->( dbCloseArea() )
      ( cAlbCliI )->( dbCloseArea() )
      ( cAlbCliD )->( dbCloseArea() )
      ( cAlbCliP )->( dbCloseArea() )

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

FUNCTION rxAlbCli( cPath, cDriver )

   local cAlbCliT

   DEFAULT cPath     := cPatEmp()
   DEFAULT cDriver   := cLocalDriver()

   if !lExistTable( cPath + "ALBCLIT.DBF", cDriver )   .OR. ;
      !lExistTable( cPath + "ALBCLIL.DBF", cDriver )   .OR. ;
      !lExistTable( cPath + "ALBCLII.DBF", cDriver )   .OR. ;
      !lExistTable( cPath + "ALBCLID.DBF", cDriver )   .OR. ;
      !lExistTable( cPath + "ALBCLIP.DBF", cDriver )   .OR. ;
      !lExistTable( cPath + "ALBCLIS.DBF", cDriver )   .OR. ;
      !lExistTable( cPath + "ALBCLIE.DBF", cDriver )

      CreateFiles( cPath, cDriver )

   end if

   fEraseIndex( cPath + "ALBCLIT.CDX", cDriver )
   fEraseIndex( cPath + "ALBCLIL.CDX", cDriver )
   fEraseIndex( cPath + "ALBCLII.CDX", cDriver )
   fEraseIndex( cPath + "ALBCLID.CDX", cDriver )
   fEraseIndex( cPath + "ALBCLIP.CDX", cDriver )
   fEraseIndex( cPath + "ALBCLIS.CDX", cDriver )
   fEraseIndex( cPath + "ALBCLIE.CDX", cDriver )

   dbUseArea( .t., cDriver, cPath + "ALBCLIT.DBF", cCheckArea( "ALBCLIT", @cAlbCliT ), .f. )

   if !( cAlbCliT )->( neterr() )
      ( cAlbCliT )->( __dbPack() )

      ( cAlbCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() }  ) )
      ( cAlbCliT )->( ordCreate( cPath + "ALBCLIT.CDX", "NNUMALB", "CSERALB + Str(NNUMALB) + CSUFALB", {|| Field->CSERALB + Str( Field->NNUMALB ) + Field->CSUFALB } ) )

      ( cAlbCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() }  ) )
      ( cAlbCliT )->( ordCreate( cPath + "ALBCLIT.CDX", "dFecAlb", "dFecAlb", {|| Field->dFecAlb } ) )

      ( cAlbCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() }, , , , , , , , , .t.  ) )
      ( cAlbCliT )->( ordCreate( cPath + "ALBCLIT.CDX", "dDesFec", "dFecAlb", {|| Field->dFecAlb } ) )

      ( cAlbCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() }  ) )
      ( cAlbCliT )->( ordCreate( cPath + "ALBCLIT.CDX", "CCODCLI", "CCODCLI", {|| Field->CCODCLI } ) )

      ( cAlbCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() }  ) )
      ( cAlbCliT )->( ordCreate( cPath + "ALBCLIT.CDX", "CNOMCLI", "Upper( CNOMCLI )", {|| Upper( Field->CNOMCLI ) } ) )

      ( cAlbCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() }  ) )
      ( cAlbCliT )->( ordCreate( cPath + "ALBCLIT.CDX", "cObra", "cCodObr + Dtos( dFecAlb )", {|| Field->cCodObr + Dtos( Field->dFecAlb ) } ) )

      ( cAlbCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() }  ) )
      ( cAlbCliT )->( ordCreate( cPath + "ALBCLIT.CDX", "cCodAge", "cCodAge + Dtos( dFecAlb )", {|| Field->cCodAge + Dtos( Field->dFecAlb ) } ) )

      ( cAlbCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() }  ) )
      ( cAlbCliT )->( ordCreate( cPath + "ALBCLIT.CDX", "CCODSUALB", "CCODSUALB", {|| Field->CCODSUALB } ) )

      ( cAlbCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() }  ) )
      ( cAlbCliT )->( ordCreate( cPath + "ALBCLIT.CDX", "LFACTURADO", "LFACTURADO", {|| Field->LFACTURADO } ) )

      ( cAlbCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() }  ) )
      ( cAlbCliT )->( ordCreate( cPath + "ALBCLIT.CDX", "cNumFac", "CNUMFAC", {|| Field->CNUMFAC }, ) )

      ( cAlbCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() }  ) )
      ( cAlbCliT )->( ordCreate( cPath + "ALBCLIT.CDX", "CTURALB", "CTURALB + CSUFALB + CCODCAJ", {|| Field->CTURALB + Field->CSUFALB + Field->CCODCAJ } ) )

      ( cAlbCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() }  ) )
      ( cAlbCliT )->( ordCreate( cPath + "ALBCLIT.CDX", "NNUMORD", "Str( nNumOrd ) + cSufOrd", {|| Str( Field->nNumOrd ) + Field->cSufOrd } ) )

      ( cAlbCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() }  ) )
      ( cAlbCliT )->( ordCreate( cPath + "ALBCLIT.CDX", "CCODTRN", "CCODTRN", {|| Field->CCODTRN } ) )

      ( cAlbCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() }  ) )
      ( cAlbCliT )->( ordCreate( cPath + "ALBCLIT.CDX", "CCODOBR", "CCODCLI + CCODOBR", {|| Field->CCODCLI + Field->CCODOBR } ) )

      ( cAlbCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() }  ))
      ( cAlbCliT )->( ordCreate( cPath + "ALBCLIT.CDX", "lSndDoc", "lSndDoc", {|| Field->lSndDoc } ) )

      ( cAlbCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() }  ) )
      ( cAlbCliT )->( ordCreate( cPath + "AlbCliT.Cdx", "cCodUsr", "Field->cCodUsr + Dtos( Field->dFecCre ) + Field->cTimCre", {|| Field->cCodUsr + Dtos( Field->dFecCre ) + Field->cTimCre } ) )

      ( cAlbCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( cAlbCliT )->( ordCreate( cPath + "AlbCliT.CDX", "cSuPed", "cSuPed", {|| Field->cSuPed } ) )

      ( cAlbCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() }  ) )
      ( cAlbCliT )->( ordCreate( cPath + "ALBCLIT.CDX", "cCtrCoste", "cCtrCoste", {|| Field->cCtrCoste } ) )

      ( cAlbCliT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cAlbCliT )->( ordCreate( cPath + "ALBCLIT.CDX", "Poblacion", "UPPER( Field->cPobCli )", {|| UPPER( Field->cPobCli ) } ) )

      ( cAlbCliT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cAlbCliT )->( ordCreate( cPath + "ALBCLIT.CDX", "Provincia", "UPPER( Field->cPrvCli )", {|| UPPER( Field->cPrvCli ) } ) )

      ( cAlbCliT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cAlbCliT )->( ordCreate( cPath + "ALBCLIT.CDX", "CodPostal", "Field->cPosCli", {|| Field->cPosCli } ) )

      ( cAlbCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() }  ) )
      ( cAlbCliT )->( ordCreate( cPath + "ALBCLIT.CDX", "CNUMPED", "CNUMPED", {|| Field->CNUMPED } ) )

      ( cAlbCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() }  ) )
      ( cAlbCliT )->( ordCreate( cPath + "ALBCLIT.CDX", "CNUMTIK", "CNUMTIK", {|| Field->CNUMTIK } ) )

      // Albaranes no facturado------------------------------------------------

      ( cAlbCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( cAlbCliT )->( ordCreate( cPath + "AlbCliT.Cdx", "iNumAlb", "'10' + cSerAlb + Str( nNumAlb ) + Space( 1 ) + cSufAlb", {|| '10' + Field->cSerAlb + Str( Field->nNumAlb ) + Space( 1 ) + Field->cSufAlb } ) )

      ( cAlbCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() }, , , , , , , , , .t. ) )
      ( cAlbCliT )->( ordCreate( cPath + "ALBCLIT.CDX", "nTotAlb", "nTotAlb", {|| Field->nTotAlb }, ) )

      ( cAlbCliT )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de albaranes de clientes" )
   end if

   dbUseArea( .t., cDriver, cPath + "ALBCLIL.DBF", cCheckArea( "ALBCLIL", @cAlbCliT ), .f. )

   if !( cAlbCliT )->( neterr() )
      ( cAlbCliT )->( __dbPack() )

      ( cAlbCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( cAlbCliT )->( ordCreate( cPath + "ALBCLIL.CDX", "nNumAlb", "cSerAlb + Str( nNumAlb ) + cSufAlb + str( nNumLin )", {|| Field->cSerAlb + Str( Field->nNumAlb ) + Field->cSufAlb + str( Field->nNumLin ) } ) )

      ( cAlbCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( cAlbCliT )->( ordCreate( cPath + "ALBCLIL.CDX", "cRef", "cRef + cCodPr1 + cCodPr2 + cSerAlb + Str( nNumAlb ) + cSufAlb", {|| Field->cRef + Field->cCodPr1 + Field->cCodPr2 + Field->cSerAlb + Str( Field->nNumAlb ) + Field->cSufAlb } ) )

      ( cAlbCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( cAlbCliT )->( ordCreate( cPath + "ALBCLIL.CDX", "Lote", "cLote" , {|| Field->cLote } ) )

      ( cAlbCliT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cAlbCliT )->( ordCreate( cPath + "AlbCLIL.CDX", "cRefLote", "cRef + cLote", {|| Field->cRef + Field->cLote } ) )

      ( cAlbCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( cAlbCliT )->( ordCreate( cPath + "ALBCLIL.CDX", "cNumPed", "cNumPed", {|| Field->cNumPed } ) )

      ( cAlbCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( cAlbCliT )->( ordCreate( cPath + "ALBCLIL.CDX", "cNumPedRef", "cNumPed + cRef + cValPr1 + cValPr2", {|| Field->cNumPed + Field->cRef + Field->cValPr1 + Field->cValPr2 } ) )
      
      ( cAlbCliT )->( ordCondSet( "!Deleted() .and. !lFacturado", {|| !Deleted() .and. !Field->lFacturado } ) )
      ( cAlbCliT )->( ordCreate( cPath + "ALBCLIL.CDX", "cRefNoFac", "cNumPed + cRef + cValPr1 + cValPr2", {|| Field->cNumPed + Field->cRef + Field->cValPr1 + Field->cValPr2 } ) )

      ( cAlbCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( cAlbCliT )->( ordCreate( cPath + "ALBCLIL.CDX", "cNumPedDet", "cNumPed + cRef + cCodPr1 + cCodPr2 + cRefPrv", {|| Field->cNumPed + Field->cRef + Field->cCodPr1 + Field->cCodPr2 + Field->cRefPrv } ) ) // + cDetalle

      ( cAlbCliT )->( ordCondSet("!Deleted()", {|| !Deleted() } ) )
      ( cAlbCliT )->( ordCreate( cPath + "ALBCLIL.CDX", "cNumRef", "cSerAlb + Str( nNumAlb ) + cSufAlb + cRef", {|| Field->cSerAlb + Str( Field->nNumAlb ) + Field->cSufAlb + Field->cRef } ) )

      ( cAlbCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() }, , , , , , , , , .t. ) )
      ( cAlbCliT )->( ordCreate( cPath + "AlbCliL.Cdx", "cRefFec", "cRef + cCodCli + dtos( dFecAlb ) + tFecAlb", {|| Field->cRef + Field->cCodCli + dtos( Field->dFecAlb ) + Field->tFecAlb } ) )

      ( cAlbCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( cAlbCliT )->( ordCreate( cPath + "ALBCLIL.CDX", "cPedRef", "cNumPed + cRef", {|| Field->cNumPed + Field->cRef } ) )

      ( cAlbCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( cAlbCliT )->( ordCreate( cPath + "AlbCliL.Cdx", "iNumAlb", "'10' + cSerAlb + Str( nNumAlb ) + Space( 1 ) + cSufAlb + Str( nNumLin )", {|| '10' + Field->cSerAlb + Str( Field->nNumAlb ) + Space( 1 ) + Field->cSufAlb + Str( Field->nNumLin ) } ) )

      ( cAlbCliT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cAlbCliT )->( ordCreate( cPath + "AlbCliL.Cdx", "nPosPrint", "cSerAlb + Str( nNumAlb ) + cSufAlb + Str( nPosPrint )", {|| Field->cSerAlb + Str( Field->nNumAlb ) + Field->cSufAlb + Str( Field->nPosPrint ) } ) )

      // Albaranes no facturados-----------------------------------------------

      ( cAlbCliT )->( ordCondSet( "!lFacturado .and. nCtlStk < 2 .and. !Deleted()", {|| !Field->lFacturado .and. Field->nCtlStk < 2 .and. !Deleted() }, , , , , , , , , .t. ) )
      ( cAlbCliT )->( ordCreate( cPath + "AlbCliL.Cdx", "cStkFast", "cRef + cAlmLin + dtos( dFecAlb )", {|| Field->cRef + Field->cAlmLin + dtos( Field->dFecAlb ) } ) )

      ( cAlbCliT )->( ordCondSet( "!lFacturado .and. !Deleted()", {|| !Field->lFacturado .and. !Deleted() } ) )
      ( cAlbCliT )->( ordCreate( cPath + "AlbCliL.Cdx", "cVtaFast", "cRef + cAlmLin + dtos( dFecAlb )", {|| Field->cRef + Field->cAlmLin + dtos( Field->dFecAlb ) } ) )

      ( cAlbCliT )->( dbCloseArea() )

   else

      msgStop( "Imposible abrir en modo exclusivo la tabla de albaranes de clientes" )

   end if

   // Pagos de albaranes

   dbUseArea( .t., cDriver, cPath + "ALBCLIP.DBF", cCheckArea( "ALBCLIP", @cAlbCliT ), .f. )

   if !( cAlbCliT )->( neterr() )
      ( cAlbCliT )->( __dbPack() )

      ( cAlbCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( cAlbCliT )->( ordCreate( cPath + "ALBCLIP.CDX", "NNUMALB", "CSERALB + STR( NNUMALB ) + CSUFALB + STR( NNUMREC )", {|| Field->CSERALB + STR( Field->NNUMALB ) + Field->CSUFALB + STR( Field->NNUMREC ) } ) )

      ( cAlbCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( cAlbCliT )->( ordCreate( cPath + "ALBCLIP.CDX", "CTURREC", "cTurRec + cSufAlb + cCodCaj", {|| Field->cTurRec + Field->cSufAlb + Field->cCodCaj } ) )

      ( cAlbCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( cAlbCliT )->( ordCreate( cPath + "ALBCLIP.CDX", "CCODCLI", "cCodCli", {|| Field->cCodCli } ) )

      ( cAlbCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( cAlbCliT )->( ordCreate( cPath + "AlbCliP.CDX", "DENTREGA", "dEntrega", {|| Field->dEntrega } ) )

      ( cAlbCliT )->( ordCondSet("!Deleted() .and. !Field->lPasado", {|| !Deleted() .and. !Field->lPasado } ) )
      ( cAlbCliT )->( ordCreate( cPath + "AlbCliP.Cdx", "lCtaBnc", "cEPaisIBAN + cECtrlIBAN + cEntEmp + cSucEmp + cDigEmp + cCtaEmp", {|| Field->cEPaisIBAN + Field->cECtrlIBAN + Field->cEntEmp + Field->cSucEmp + Field->cDigEmp + Field->cCtaEmp } ) )

      ( cAlbCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( cAlbCliT )->( ordCreate( cPath + "AlbCliP.Cdx", "iNumAlb", "'10' + cSerAlb + Str( nNumAlb ) + Space( 1 ) + cSufAlb", {|| '10' + Field->cSerAlb + Str( Field->nNumAlb ) + Space( 1 ) + Field->cSufAlb } ) )

      ( cAlbCliT )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de albaranes de clientes" )
   end if

   dbUseArea( .t., cDriver, cPath + "AlbCliI.DBF", cCheckArea( "AlbCliI", @cAlbCliT ), .f. )

   if !( cAlbCliT )->( neterr() )
      ( cAlbCliT )->( __dbPack() )

      ( cAlbCliT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cAlbCliT )->( ordCreate( cPath + "AlbCliI.CDX", "NNUMALB", "CSERALB + STR( NNUMALB ) + CSUFALB", {|| Field->CSERALB + STR( Field->NNUMALB ) + Field->CSUFALB } ) )

      ( cAlbCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( cAlbCliT )->( ordCreate( cPath + "AlbCliI.Cdx", "iNumAlb", "'10' + cSerAlb + Str( nNumAlb ) + Space( 1 ) + cSufAlb", {|| '10' + Field->cSerAlb + Str( Field->nNumAlb ) + Space( 1 ) + Field->cSufAlb } ) )

      ( cAlbCliT )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de albaranes de clientes" )
   end if

   dbUseArea( .t., cDriver, cPath + "AlbCliD.DBF", cCheckArea( "AlbCliD", @cAlbCliT ), .f. )

   if !( cAlbCliT )->( neterr() )
      ( cAlbCliT )->( __dbPack() )

      ( cAlbCliT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cAlbCliT )->( ordCreate( cPath + "AlbCliD.CDX", "NNUMALB", "CSERALB + STR( NNUMALB ) + CSUFALB", {|| Field->CSERALB + STR( Field->NNUMALB ) + Field->CSUFALB } ) )

      ( cAlbCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( cAlbCliT )->( ordCreate( cPath + "AlbCliD.Cdx", "iNumAlb", "'10' + cSerAlb + Str( nNumAlb ) + Space( 1 ) + cSufAlb", {|| '10' + Field->cSerAlb + Str( Field->nNumAlb ) + Space( 1 ) + Field->cSufAlb } ) )

      ( cAlbCliT )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de albaranes de clientes" )
   end if

   dbUseArea( .t., cDriver, cPath + "AlbCliS.Dbf", cCheckArea( "AlbCliS", @cAlbCliT ), .f. )

   if !( cAlbCliT )->( neterr() )
      ( cAlbCliT )->( __dbPack() )

      ( cAlbCliT )->( ordCondSet( "!Deleted()", {||!Deleted()}  ) )
      ( cAlbCliT )->( ordCreate( cPath + "AlbCliS.CDX", "nNumAlb", "cSerAlb + Str( nNumAlb ) + cSufAlb + Str( nNumLin )", {|| Field->cSerAlb + Str( Field->nNumAlb ) + Field->cSufAlb + Str( Field->nNumLin ) } ) )

      ( cAlbCliT )->( ordCondSet( "!lFacturado .and. !Deleted()", {|| !Field->lFacturado .and. !Deleted() } ) )
      ( cAlbCliT )->( ordCreate( cPath + "AlbCliS.CDX", "cRefSer", "cRef + cAlmLin + cNumSer", {|| Field->cRef + Field->cAlmLin + Field->cNumSer } ) )

      ( cAlbCliT )->( ordCondSet( "!lFacturado .and. !Deleted()", {|| !Field->lFacturado .and. !Deleted() } ) )
      ( cAlbCliT )->( ordCreate( cPath + "AlbCliS.CDX", "cNumSer", "cNumSer", {|| Field->cNumSer } ) )

      ( cAlbCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( cAlbCliT )->( ordCreate( cPath + "AlbCliS.Cdx", "iNumAlb", "'10' + cSerAlb + Str( nNumAlb ) + Space( 1 ) + cSufAlb", {|| '10' + Field->cSerAlb + Str( Field->nNumAlb ) + Space( 1 ) + Field->cSufAlb } ) )

      ( cAlbCliT )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de numeros de series de albaranes de clientes" )
   end if

   dbUseArea( .t., cDriver, cPath + "AlbCliE.DBF", cCheckArea( "AlbCliE", @cAlbCliT ), .f. )

   if !( cAlbCliT )->( neterr() )

      ( cAlbCliT )->( __dbPack() )

      ( cAlbCliT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cAlbCliT )->( ordCreate( cPath + "AlbCliE.CDX", "NNUMALB", "CSERALB + STR( NNUMALB ) + CSUFALB", {|| Field->CSERALB + STR( Field->NNUMALB ) + Field->CSUFALB } ) )

      ( cAlbCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( cAlbCliT )->( ordCreate( cPath + "AlbCliE.Cdx", "cSitua", "cSitua", {|| Field->cSitua } ) )

      ( cAlbCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( cAlbCliT )->( ordCreate( cPath + "AlbCliE.Cdx", "idPs", "str( idPs )", {|| str( Field->idPs ) } ) )

      ( cAlbCliT )->( dbCloseArea() )

   else

      msgStop( "Imposible abrir en modo exclusivo la tabla de pedidos de clientes" )

   end if

RETURN NIL

//---------------------------------------------------------------------------//

FUNCTION reindexAdsAlbCli( cPath )

   local cStm

   DEFAULT cPath     := cPatEmp()

   adsDDRemoveIndexFile( cPath + 'AlbCliT', 'AlbCliT.Cdx', 1 )

   TDataCenter():SqlCreateIndex( cPath + 'AlbCliT', 'AlbCliT.Cdx', 'nNumAlb', 'cSerAlb + str( nNumAlb ) + cSufAlb', '!Deleted()' )

   TDataCenter():SqlCreateIndex( cPath + 'AlbCliT', 'AlbCliT.Cdx', 'dFecAlb', 'dFecAlb', '!Deleted()' )

   TDataCenter():SqlCreateIndex( cPath + 'AlbCliT', 'AlbCliT.Cdx', 'cCodCli', 'cCodCli', '!Deleted()' )

   TDataCenter():SqlCreateIndex( cPath + 'AlbCliT', 'AlbCliT.Cdx', 'cNomCli', 'upper( cNomCli )', '!Deleted()' )

   TDataCenter():SqlCreateIndex( cPath + 'AlbCliT', 'AlbCliT.Cdx', 'cObra', 'cCodObr + Dtos( dFecAlb )', '!Deleted()' )

   TDataCenter():SqlCreateIndex( cPath + 'AlbCliT', 'AlbCliT.Cdx', 'cCodAge', 'cCodAge + Dtos( dFecAlb )', '!Deleted()' )

   TDataCenter():SqlCreateIndex( cPath + 'AlbCliT', 'AlbCliT.Cdx', 'cCodSuAlb', 'cCodSuAlb', '!Deleted()' )

   TDataCenter():SqlCreateIndex( cPath + 'AlbCliT', 'AlbCliT.Cdx', 'lFacturado', 'lFacturado', '!Deleted()' )

   TDataCenter():SqlCreateIndex( cPath + 'AlbCliT', 'AlbCliT.Cdx', 'cNumFac', 'cNumFac', '!Deleted()' )

   TDataCenter():SqlCreateIndex( cPath + 'AlbCliT', 'AlbCliT.Cdx', 'cTurAlb', 'cTurAlb + cSufAlb + cCodCaj', '!Deleted()' )

   TDataCenter():SqlCreateIndex( cPath + 'AlbCliT', 'AlbCliT.Cdx', 'nNumOrd', 'Str( nNumOrd ) + cSufOrd', '!Deleted()' )

   TDataCenter():SqlCreateIndex( cPath + 'AlbCliT', 'AlbCliT.Cdx', 'cCodTrn', 'cCodTrn', '!Deleted()' )

   TDataCenter():SqlCreateIndex( cPath + 'AlbCliT', 'AlbCliT.Cdx', 'cCodObr', 'cCodCli + cCodObr', '!Deleted()' )

   TDataCenter():SqlCreateIndex( cPath + 'AlbCliT', 'AlbCliT.Cdx', 'cNumPed', 'cNumPed', '!Deleted()' )

   TDataCenter():SqlCreateIndex( cPath + 'AlbCliT', 'AlbCliT.Cdx', 'lSndDoc', 'lSndDoc', '!Deleted()' )

   TDataCenter():SqlCreateIndex( cPath + 'AlbCliT', 'AlbCliT.Cdx', 'cCodUsr', 'cCodUsr + Dtos( dFecCre ) + cTimCre', '!Deleted()' )

   TDataCenter():SqlCreateIndex( cPath + 'AlbCliT', 'AlbCliT.Cdx', 'cNumTik', 'cNumTik', '!Deleted()' )

   TDataCenter():SqlCreateIndex( cPath + 'AlbCliT', 'AlbCliT.Cdx', 'cCtrCoste', 'cCtrCoste', '!Deleted()' )

   TDataCenter():SqlCreateIndex( cPath + 'AlbCliT', 'AlbCliT.Cdx', 'Poblacion', 'Upper( cPobCli )', '!Deleted()' )

   TDataCenter():SqlCreateIndex( cPath + 'AlbCliT', 'AlbCliT.Cdx', 'Provincia', 'Upper( cPrvCli )', '!Deleted()' )

   TDataCenter():SqlCreateIndex( cPath + 'AlbCliT', 'AlbCliT.Cdx', 'CodPostal', 'cPosCli', '!Deleted()' )

   TDataCenter():SqlCreateIndex( cPath + 'AlbCliT', 'AlbCliT.Cdx', 'lCodCli', 'cCodCli', '!Deleted() .and. !lFacturado' )

   TDataCenter():SqlCreateIndex( cPath + 'AlbCliT', 'AlbCliT.Cdx', 'lCliObr', 'cCodCli + cCodObr', '!Deleted() .and. !lFacturado' )

   TDataCenter():SqlCreateIndex( cPath + 'AlbCliT', 'AlbCliT.Cdx', 'cSuPed', 'cSuPed', '!Deleted()' )

   TDataCenter():SqlCreateIndex( cPath + 'AlbCliT', 'AlbCliT.Cdx', 'iNumAlb', '"10" + cSerAlb + Str( nNumAlb ) + Space( 1 ) + cSufAlb', '!Deleted()' )

   TDataCenter():SqlCreateIndex( cPath + 'AlbCliT', 'AlbCliT.Cdx', 'cNumCli', 'cSerAlb + Str( nNumAlb ) + cSufAlb + cCodCli', '!Deleted()' )

   TDataCenter():SqlCreateIndex( cPath + 'AlbCliT', 'AlbCliT.Cdx', 'cCliFec', 'cCodCli + dtos( dFecAlb ) + tFecAlb', '!Deleted()', nAnd( 2, 8 ) )

   TDataCenter():SqlCreateIndex( cPath + 'AlbCliT', 'AlbCliT.Cdx', 'dFecDes', 'dtos( dFecAlb ) + tFecAlb', '!Deleted()', nAnd( 2, 8 ) )

   TDataCenter():SqlCreateIndex( cPath + 'AlbCliT', 'AlbCliT.Cdx', 'nTotAlb', 'nTotAlb', '!Deleted()', nAnd( 2, 8 ) )

   TDataCenter():SqlCreateIndex( cPath + 'AlbCliT', 'AlbCliT.Cdx', 'dDesFec', 'dFecAlb', '!Deleted()', nAnd( 2, 8 ) )

/*

   dbUseArea( .t., cDriver, cPath + "ALBCLIL.DBF", cCheckArea( "ALBCLIL", @cAlbCliT ), .f. )

   if !( cAlbCliT )->( neterr() )
      ( cAlbCliT )->( __dbPack() )

      ( cAlbCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( cAlbCliT )->( ordCreate( cPath + "ALBCLIL.CDX", "nNumAlb", "cSerAlb + Str( nNumAlb ) + cSufAlb + str( nNumLin )", {|| Field->cSerAlb + Str( Field->nNumAlb ) + Field->cSufAlb + str( Field->nNumLin ) } ) )

      ( cAlbCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( cAlbCliT )->( ordCreate( cPath + "ALBCLIL.CDX", "cRef", "cRef + cCodPr1 + cCodPr2 + cSerAlb + Str( nNumAlb ) + cSufAlb", {|| Field->cRef + Field->cCodPr1 + Field->cCodPr2 + Field->cSerAlb + Str( Field->nNumAlb ) + Field->cSufAlb } ) )

      ( cAlbCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( cAlbCliT )->( ordCreate( cPath + "ALBCLIL.CDX", "Lote", "cLote" , {|| Field->cLote } ) )

      ( cAlbCliT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cAlbCliT )->( ordCreate( cPath + "AlbCLIL.CDX", "cRefLote", "cRef + cLote", {|| Field->cRef + Field->cLote } ) )

      ( cAlbCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( cAlbCliT )->( ordCreate( cPath + "ALBCLIL.CDX", "cNumPed", "cNumPed", {|| Field->cNumPed } ) )

      ( cAlbCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( cAlbCliT )->( ordCreate( cPath + "ALBCLIL.CDX", "cNumPedRef", "cNumPed + cRef + cValPr1 + cValPr2", {|| Field->cNumPed + Field->cRef + Field->cValPr1 + Field->cValPr2 } ) )
      
      ( cAlbCliT )->( ordCondSet( "!Deleted() .and. !lFacturado", {|| !Deleted() .and. !Field->lFacturado } ) )
      ( cAlbCliT )->( ordCreate( cPath + "ALBCLIL.CDX", "cRefNoFac", "cNumPed + cRef + cValPr1 + cValPr2", {|| Field->cNumPed + Field->cRef + Field->cValPr1 + Field->cValPr2 } ) )

      ( cAlbCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( cAlbCliT )->( ordCreate( cPath + "ALBCLIL.CDX", "cNumPedDet", "cNumPed + cRef + cCodPr1 + cCodPr2 + cRefPrv", {|| Field->cNumPed + Field->cRef + Field->cCodPr1 + Field->cCodPr2 + Field->cRefPrv } ) ) // + cDetalle

      ( cAlbCliT )->( ordCondSet("!Deleted()", {|| !Deleted() } ) )
      ( cAlbCliT )->( ordCreate( cPath + "ALBCLIL.CDX", "cNumRef", "cSerAlb + Str( nNumAlb ) + cSufAlb + cRef", {|| Field->cSerAlb + Str( Field->nNumAlb ) + Field->cSufAlb + Field->cRef } ) )

      ( cAlbCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() }, , , , , , , , , .t. ) )
      ( cAlbCliT )->( ordCreate( cPath + "AlbCliL.Cdx", "cRefFec", "cRef + cCodCli + dtos( dFecAlb ) + tFecAlb", {|| Field->cRef + Field->cCodCli + dtos( Field->dFecAlb ) + Field->tFecAlb } ) )

      ( cAlbCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( cAlbCliT )->( ordCreate( cPath + "ALBCLIL.CDX", "cPedRef", "cNumPed + cRef", {|| Field->cNumPed + Field->cRef } ) )

      ( cAlbCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( cAlbCliT )->( ordCreate( cPath + "AlbCliL.Cdx", "iNumAlb", "'10' + cSerAlb + Str( nNumAlb ) + Space( 1 ) + cSufAlb", {|| '10' + Field->cSerAlb + Str( Field->nNumAlb ) + Space( 1 ) + Field->cSufAlb } ) )

      ( cAlbCliT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cAlbCliT )->( ordCreate( cPath + "AlbCliL.Cdx", "nPosPrint", "cSerAlb + Str( nNumAlb ) + cSufAlb + Str( nPosPrint )", {|| Field->cSerAlb + Str( Field->nNumAlb ) + Field->cSufAlb + Str( Field->nPosPrint ) } ) )

      // Albaranes no facturados-----------------------------------------------

      ( cAlbCliT )->( ordCondSet( "!lFacturado .and. nCtlStk < 2 .and. !Deleted()", {|| !Field->lFacturado .and. Field->nCtlStk < 2 .and. !Deleted() }, , , , , , , , , .t. ) )
      ( cAlbCliT )->( ordCreate( cPath + "AlbCliL.Cdx", "cStkFast", "cRef + cAlmLin + dtos( dFecAlb )", {|| Field->cRef + Field->cAlmLin + dtos( Field->dFecAlb ) } ) )

      ( cAlbCliT )->( ordCondSet( "!lFacturado .and. !Deleted()", {|| !Field->lFacturado .and. !Deleted() } ) )
      ( cAlbCliT )->( ordCreate( cPath + "AlbCliL.Cdx", "cVtaFast", "cRef + cAlmLin + dtos( dFecAlb )", {|| Field->cRef + Field->cAlmLin + dtos( Field->dFecAlb ) } ) )

      ( cAlbCliT )->( dbCloseArea() )

   else

      msgStop( "Imposible abrir en modo exclusivo la tabla de albaranes de clientes" )

   end if

   // Pagos de albaranes

   dbUseArea( .t., cDriver, cPath + "ALBCLIP.DBF", cCheckArea( "ALBCLIP", @cAlbCliT ), .f. )

   if !( cAlbCliT )->( neterr() )
      ( cAlbCliT )->( __dbPack() )

      ( cAlbCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( cAlbCliT )->( ordCreate( cPath + "ALBCLIP.CDX", "NNUMALB", "CSERALB + STR( NNUMALB ) + CSUFALB + STR( NNUMREC )", {|| Field->CSERALB + STR( Field->NNUMALB ) + Field->CSUFALB + STR( Field->NNUMREC ) } ) )

      ( cAlbCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( cAlbCliT )->( ordCreate( cPath + "ALBCLIP.CDX", "CTURREC", "cTurRec + cSufAlb + cCodCaj", {|| Field->cTurRec + Field->cSufAlb + Field->cCodCaj } ) )

      ( cAlbCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( cAlbCliT )->( ordCreate( cPath + "ALBCLIP.CDX", "CCODCLI", "cCodCli", {|| Field->cCodCli } ) )

      ( cAlbCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( cAlbCliT )->( ordCreate( cPath + "AlbCliP.CDX", "DENTREGA", "dEntrega", {|| Field->dEntrega } ) )

      ( cAlbCliT )->( ordCondSet("!Deleted() .and. !Field->lPasado", {|| !Deleted() .and. !Field->lPasado } ) )
      ( cAlbCliT )->( ordCreate( cPath + "AlbCliP.Cdx", "lCtaBnc", "cEPaisIBAN + cECtrlIBAN + cEntEmp + cSucEmp + cDigEmp + cCtaEmp", {|| Field->cEPaisIBAN + Field->cECtrlIBAN + Field->cEntEmp + Field->cSucEmp + Field->cDigEmp + Field->cCtaEmp } ) )

      ( cAlbCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( cAlbCliT )->( ordCreate( cPath + "AlbCliP.Cdx", "iNumAlb", "'10' + cSerAlb + Str( nNumAlb ) + Space( 1 ) + cSufAlb", {|| '10' + Field->cSerAlb + Str( Field->nNumAlb ) + Space( 1 ) + Field->cSufAlb } ) )

      ( cAlbCliT )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de albaranes de clientes" )
   end if

   dbUseArea( .t., cDriver, cPath + "AlbCliI.DBF", cCheckArea( "AlbCliI", @cAlbCliT ), .f. )

   if !( cAlbCliT )->( neterr() )
      ( cAlbCliT )->( __dbPack() )

      ( cAlbCliT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cAlbCliT )->( ordCreate( cPath + "AlbCliI.CDX", "NNUMALB", "CSERALB + STR( NNUMALB ) + CSUFALB", {|| Field->CSERALB + STR( Field->NNUMALB ) + Field->CSUFALB } ) )

      ( cAlbCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( cAlbCliT )->( ordCreate( cPath + "AlbCliI.Cdx", "iNumAlb", "'10' + cSerAlb + Str( nNumAlb ) + Space( 1 ) + cSufAlb", {|| '10' + Field->cSerAlb + Str( Field->nNumAlb ) + Space( 1 ) + Field->cSufAlb } ) )

      ( cAlbCliT )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de albaranes de clientes" )
   end if

   dbUseArea( .t., cDriver, cPath + "AlbCliD.DBF", cCheckArea( "AlbCliD", @cAlbCliT ), .f. )

   if !( cAlbCliT )->( neterr() )
      ( cAlbCliT )->( __dbPack() )

      ( cAlbCliT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cAlbCliT )->( ordCreate( cPath + "AlbCliD.CDX", "NNUMALB", "CSERALB + STR( NNUMALB ) + CSUFALB", {|| Field->CSERALB + STR( Field->NNUMALB ) + Field->CSUFALB } ) )

      ( cAlbCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( cAlbCliT )->( ordCreate( cPath + "AlbCliD.Cdx", "iNumAlb", "'10' + cSerAlb + Str( nNumAlb ) + Space( 1 ) + cSufAlb", {|| '10' + Field->cSerAlb + Str( Field->nNumAlb ) + Space( 1 ) + Field->cSufAlb } ) )

      ( cAlbCliT )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de albaranes de clientes" )
   end if

   dbUseArea( .t., cDriver, cPath + "AlbCliS.Dbf", cCheckArea( "AlbCliS", @cAlbCliT ), .f. )

   if !( cAlbCliT )->( neterr() )
      ( cAlbCliT )->( __dbPack() )

      ( cAlbCliT )->( ordCondSet( "!Deleted()", {||!Deleted()}  ) )
      ( cAlbCliT )->( ordCreate( cPath + "AlbCliS.CDX", "nNumAlb", "cSerAlb + Str( nNumAlb ) + cSufAlb + Str( nNumLin )", {|| Field->cSerAlb + Str( Field->nNumAlb ) + Field->cSufAlb + Str( Field->nNumLin ) } ) )

      ( cAlbCliT )->( ordCondSet( "!lFacturado .and. !Deleted()", {|| !Field->lFacturado .and. !Deleted() } ) )
      ( cAlbCliT )->( ordCreate( cPath + "AlbCliS.CDX", "cRefSer", "cRef + cAlmLin + cNumSer", {|| Field->cRef + Field->cAlmLin + Field->cNumSer } ) )

      ( cAlbCliT )->( ordCondSet( "!lFacturado .and. !Deleted()", {|| !Field->lFacturado .and. !Deleted() } ) )
      ( cAlbCliT )->( ordCreate( cPath + "AlbCliS.CDX", "cNumSer", "cNumSer", {|| Field->cNumSer } ) )

      ( cAlbCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( cAlbCliT )->( ordCreate( cPath + "AlbCliS.Cdx", "iNumAlb", "'10' + cSerAlb + Str( nNumAlb ) + Space( 1 ) + cSufAlb", {|| '10' + Field->cSerAlb + Str( Field->nNumAlb ) + Space( 1 ) + Field->cSufAlb } ) )

      ( cAlbCliT )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de numeros de series de albaranes de clientes" )
   end if

   dbUseArea( .t., cDriver, cPath + "AlbCliE.DBF", cCheckArea( "AlbCliE", @cAlbCliT ), .f. )

   if !( cAlbCliT )->( neterr() )

      ( cAlbCliT )->( __dbPack() )

      ( cAlbCliT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cAlbCliT )->( ordCreate( cPath + "AlbCliE.CDX", "NNUMALB", "CSERALB + STR( NNUMALB ) + CSUFALB", {|| Field->CSERALB + STR( Field->NNUMALB ) + Field->CSUFALB } ) )

      ( cAlbCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( cAlbCliT )->( ordCreate( cPath + "AlbCliE.Cdx", "cSitua", "cSitua", {|| Field->cSitua } ) )

      ( cAlbCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( cAlbCliT )->( ordCreate( cPath + "AlbCliE.Cdx", "idPs", "str( idPs )", {|| str( Field->idPs ) } ) )

      ( cAlbCliT )->( dbCloseArea() )

   else

      msgStop( "Imposible abrir en modo exclusivo la tabla de pedidos de clientes" )

   end if
*/

RETURN NIL

//---------------------------------------------------------------------------//

function aAlbCliEst()

   local aAlbCliEst  := {}

   aAdd( aAlbCliEst, { "cSerAlb", "C",    1,  0, "Serie de pedido" ,            "",                   "", "( cDbfCol )", nil } )
   aAdd( aAlbCliEst, { "nNumAlb", "N",    9,  0, "Numero de pedido" ,           "'999999999'",        "", "( cDbfCol )", nil } )
   aAdd( aAlbCliEst, { "cSufAlb", "C",    2,  0, "Sufijo de pedido" ,           "",                   "", "( cDbfCol )", nil } )
   aAdd( aAlbCliEst, { "cSitua",  "C",  140,  0, "Situación" ,             "",                   "", "( cDbfCol )", nil } )
   aAdd( aAlbCliEst, { "dFecSit", "D",    8,  0, "Fecha de la situación" ,      "",                   "", "( cDbfCol )", nil } )
   aAdd( aAlbCliEst, { "tFecSit", "C",    6,  0, "Hora de la situación" ,       "",                   "", "( cDbfCol )", nil } )
   aAdd( aAlbCliEst, { "idPs",    "N",   11,  0, "Id prestashop" ,              "",                   "", "( cDbfCol )", nil } )   

return ( aAlbCliEst )

//--------------------------------------------------------------------------//

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

   aAdd( aIncAlbCli, { "cSerAlb",      "C",    1,  0, "Serie de albarán" ,                "",                   "", "( cDbfCol )" } )
   aAdd( aIncAlbCli, { "nNumAlb",      "N",    9,  0, "Número de albarán" ,               "'999999999'",        "", "( cDbfCol )" } )
   aAdd( aIncAlbCli, { "cSufAlb",      "C",    2,  0, "Sufijo de albarán" ,               "",                   "", "( cDbfCol )" } )
   aAdd( aIncAlbCli, { "cCodTip",      "C",    3,  0, "Tipo de incidencia" ,              "",                   "", "( cDbfCol )" } )
   aAdd( aIncAlbCli, { "dFecInc",      "D",    8,  0, "Fecha de la incidencia" ,          "",                   "", "( cDbfCol )" } )
   aAdd( aIncAlbCli, { "mDesInc",      "M",   10,  0, "Descripción de la incidencia" ,    "",                   "", "( cDbfCol )" } )
   aAdd( aIncAlbCli, { "lListo",       "L",    1,  0, "Lógico de listo" ,                 "",                   "", "( cDbfCol )" } )
   aAdd( aIncAlbCli, { "lAviso",       "L",    1,  0, "Lógico de aviso" ,                 "",                   "", "( cDbfCol )" } )

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
   aAdd( aBasRecCli, {"nImporte"    ,"N", 18, 8, "Importe",                            "cPorDivEnt",        "", "( cDbfEnt )" } )
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
   aAdd( aBasRecCli, {"cBncCli"     ,"C", 50, 0, "Banco del cliente para el recibo" ,  "",                  "", "( cDbfEnt )", nil } )
   aAdd( aBasRecCli, {"cEPaisIBAN"  ,"C",  2, 0, "País IBAN de la cuenta bancaria de la empresa",       "", "", "( cDbfEnt )", nil } )
   aAdd( aBasRecCli, {"cECtrlIBAN"  ,"C",  2, 0, "Dígito de control IBAN de la cuenta bancaria de la empresa", "", "", "( cDbfEnt )", nil } )
   aAdd( aBasRecCli, {"cEntEmp"     ,"C",  4, 0, "Entidad de la cuenta de la empresa",  "",                 "", "( cDbfEnt )", nil } )
   aAdd( aBasRecCli, {"cSucEmp"     ,"C",  4, 0, "Sucursal de la cuenta de la empresa", "",                 "", "( cDbfEnt )", nil } )
   aAdd( aBasRecCli, {"cDigEmp"     ,"C",  2, 0, "Dígito de control de la cuenta de la empresa", "",        "", "( cDbfEnt )", nil } )
   aAdd( aBasRecCli, {"cCtaEmp"     ,"C", 10, 0, "Cuenta bancaria de la empresa",       "",                 "", "( cDbfEnt )", nil } )
   aAdd( aBasRecCli, {"cPaisIBAN"   ,"C",  2, 0, "País IBAN de la cuenta bancaria del cliente",           "", "", "( cDbfEnt )", nil } )
   aAdd( aBasRecCli, {"cCtrlIBAN"   ,"C",  2, 0, "Dígito de control IBAN de la cuenta bancaria del cliente", "", "", "( cDbfEnt )", nil } )
   aAdd( aBasRecCli, {"cEntCli"     ,"C",  4, 0, "Entidad de la cuenta del cliente",  "",                   "", "( cDbfEnt )", nil } )
   aAdd( aBasRecCli, {"cSucCli"     ,"C",  4, 0, "Sucursal de la cuenta del cliente",  "",                  "", "( cDbfEnt )", nil } )
   aAdd( aBasRecCli, {"cDigCli"     ,"C",  2, 0, "Dígito de control de la cuenta del cliente", "",          "", "( cDbfEnt )", nil } )
   aAdd( aBasRecCli, {"cCtaCli"     ,"C", 10, 0, "Cuenta bancaria del cliente",        "",                  "", "( cDbfEnt )", nil } )

return ( aBasRecCli )

//---------------------------------------------------------------------------//

Function aColAlbCli()

   local aColAlbCli  := {}

   aAdd( aColAlbCli, { "cSerAlb",   "C",  1, 0, "Serie del albarán" ,                              "Serie",                         "", "( cDbfCol )", nil } )
   aAdd( aColAlbCli, { "nNumAlb",   "N",  9, 0, "Número del albarán" ,                             "Numero",                        "", "( cDbfCol )", nil } )
   aAdd( aColAlbCli, { "cSufAlb",   "C",  2, 0, "Sufijo del albarán" ,                             "Sufijo",                        "", "( cDbfCol )", nil } )
   aAdd( aColAlbCli, { "cRef",      "C", 18, 0, "Referencia de artículo" ,                         "Articulo",                      "", "( cDbfCol )", nil } )
   aAdd( aColAlbCli, { "cDetalle",  "C",250, 0, "Detalle de artículo" ,                            "DescripcionArticulo",           "", "( cDbfCol )", nil } )
   aAdd( aColAlbCli, { "nPreUnit",  "N", 18, 8, "Precio artículo" ,                                "PrecioVenta",                   "", "( cDbfCol )", nil } )
   aAdd( aColAlbCli, { "nPntVer",   "N", 18, 8, "Importe punto verde" ,                            "PuntoVerde",                    "", "( cDbfCol )", nil } )
   aAdd( aColAlbCli, { "nImpTrn",   "N", 18, 8, "Importe del porte" ,                              "Portes",                        "", "( cDbfCol )", nil } )
   aAdd( aColAlbCli, { "nDto",      "N",  6, 2, "Descuento de artículo" ,                          "DescuentoPorcentual",           "", "( cDbfCol )", nil } )
   aAdd( aColAlbCli, { "nDtoPrm",   "N",  6, 2, "Descuento de promoción" ,                         "DescuentoPromocion",            "", "( cDbfCol )", nil } )
   aAdd( aColAlbCli, { "nIva",      "N",  4, 1, cImp() + " del artículo" ,                         "PorcentajeImpuesto",            "", "( cDbfCol )", nil } )
   aAdd( aColAlbCli, { "nCanEnt",   "N", 18, 8, cNombreCajas(),                                    "Cajas",                         "", "( cDbfCol )", nil } )
   aAdd( aColAlbCli, { "nCanFac",   "N", 18, 8, "Cantidad facturada" ,                             "",                              "", "( cDbfCol )", nil } )
   aAdd( aColAlbCli, { "lControl",  "L",  1, 0, "Control reservado" ,                              "",                              "", "( cDbfCol )", nil } )
   aAdd( aColAlbCli, { "nPesoKg",   "N", 18, 8, "Peso del producto" ,                              "Peso",                          "", "( cDbfCol )", nil } )
   aAdd( aColAlbCli, { "cPesoKg",   "C",  2, 0, "Unidad de peso del producto" ,                    "UnidadMedicionPeso",            "", "( cDbfCol )", nil } )
   aAdd( aColAlbCli, { "cUnidad",   "C",  2, 0, "Unidad de venta" ,                                "UnidadMedicion",                "", "( cDbfCol )", nil } )
   aAdd( aColAlbCli, { "nComAge",   "N",  6, 2, "Comisión del agente" ,                            "ComisionAgente",                "", "( cDbfCol )", nil } )
   aAdd( aColAlbCli, { "nUniCaja",  "N", 18, 8, cNombreUnidades(),                                 "Unidades",                      "", "( cDbfCol )", nil } )
   aAdd( aColAlbCli, { "nUndKit",   "N", 18, 8, "Unidades del producto kit",                       "UnidadesKit",                   "", "( cDbfCol )", nil } )
   aAdd( aColAlbCli, { "dFecha",    "D",  8, 0, "Fecha de linea" ,                                 "FechaEntrega",                  "", "( cDbfCol )", nil } )
   aAdd( aColAlbCli, { "cTipMov",   "C",  2, 0, "Tipo de movimiento" ,                             "Tipo",                          "", "( cDbfCol )", nil } )
   aAdd( aColAlbCli, { "mLngDes",   "M", 10, 0, "Descripción larga" ,                              "DescripcionAmpliada",           "", "( cDbfCol )", nil } )
   aAdd( aColAlbCli, { "lTotLin",   "L",  1, 0, "Línea de total" ,                                 "LineaTotal",                    "", "( cDbfCol )", nil } )
   aAdd( aColAlbCli, { "lImpLin",   "L",  1, 0, "Línea no imprimible" ,                            "LineaNoImprimible",             "", "( cDbfCol )", nil } )
   aAdd( aColAlbCli, { "lNewLin",   "L",  1, 0, "" ,                                               "",                              "", "( cDbfCol )", nil } )
   aAdd( aColAlbCli, { "cNumPed",   "C", 12, 0, "Número del pedido" ,                              "NumeroPedido",                  "", "( cDbfCol )", nil } )
   aAdd( aColAlbCli, { "cCodPr1",   "C", 20, 0, "Código de primera propiedad",                     "CodigoPropiedad1",              "", "( cDbfCol )", nil } )
   aAdd( aColAlbCli, { "cCodPr2",   "C", 20, 0, "Código de segunda propiedad",                     "CodigoPropiedad2",              "", "( cDbfCol )", nil } )
   aAdd( aColAlbCli, { "cValPr1",   "C", 20, 0, "Valor de primera propiedad",                      "ValorPropiedad1",               "", "( cDbfCol )", nil } )
   aAdd( aColAlbCli, { "cValPr2",   "C", 20, 0, "Valor de segunda propiedad",                      "ValorPropiedad2",               "", "( cDbfCol )", nil } )
   aAdd( aColAlbCli, { "nFacCnv",   "N", 18, 8, "",                                                "",                              "", "( cDbfCol )", nil } )
   aAdd( aColAlbCli, { "nDtoDiv",   "N", 18, 8, "Descuento en línea",                              "DescuentoLineal",               "", "( cDbfCol )", nil } )
   aAdd( aColAlbCli, { "nNumLin",   "N",  4, 0, "Número de la línea",                              "NumeroLinea",                   "", "( cDbfCol )", nil } )
   aAdd( aColAlbCli, { "nCtlStk",   "N",  1, 0, "Tipo de stock de la linea",                       "TipoStock",                     "", "( cDbfCol )", nil } )
   aAdd( aColAlbCli, { "nCosDiv",   "N", 18, 8, "Precio de costo",                                 "PrecioCosto",                   "", "( cDbfCol )", nil } )
   aAdd( aColAlbCli, { "nPvpRec",   "N", 18, 8, "Precio de venta recomendado",                     "PrecioVentaRecomendado",        "", "( cDbfCol )", nil } )
   aAdd( aColAlbCli, { "cAlmLin",   "C", 16, 0, "Código del almacen",                              "Almacen",                       "", "( cDbfCol )", {|| Application():codigoAlmacen() } } )
   aAdd( aColAlbCli, { "lIvaLin",   "L",  1, 0, cImp() + " incluido",                              "LineaImpuestoIncluido",         "", "( cDbfCol )", nil } )
   aAdd( aColAlbCli, { "nValImp",   "N", 18, 8, "Importe de impuesto",                             "ImporteImpuestoEspecial",       "", "( cDbfCol )", nil } )
   aAdd( aColAlbCli, { "cCodImp",   "C",  3, 0, "Código del IVMH",                                 "ImpuestoEspecial",              "", "( cDbfCol )", nil } )
   aAdd( aColAlbCli, { "lLote",     "L",  1, 0, "",                                                "LogicoLote",                    "", "( cDbfCol )", nil } )
   aAdd( aColAlbCli, { "nLote",     "N",  9, 0, "",                                                "",                              "", "( cDbfCol )", nil } )
   aAdd( aColAlbCli, { "cLote",     "C", 14, 0, "Número de lote",                                  "Lote",                          "", "( cDbfCol )", nil } )
   aAdd( aColAlbCli, { "dFecCad",   "D",  8, 0, "Fecha de caducidad",                              "FechaCaducidad",                "", "( cDbfCol )", nil } )
   aAdd( aColAlbCli, { "lKitArt",   "L",  1, 0, "Línea con escandallo",                            "LineaEscandallo",               "", "( cDbfCol )", nil } )
   aAdd( aColAlbCli, { "lKitChl",   "L",  1, 0, "Línea pertenciente a escandallo",                 "LineaPertenecienteEscandallo",  "", "( cDbfCol )", nil } )
   aAdd( aColAlbCli, { "lKitPrc",   "L",  1, 0, "Línea de escandallos con precio",                 "LineaEscandalloPrecio",         "", "( cDbfCol )", nil } )
   aAdd( aColAlbCli, { "nMesGrt",   "N",  2, 0, "Meses de garantía",                               "MesesGarantia",                 "", "( cDbfCol )", nil } )
   aAdd( aColAlbCli, { "lMsgVta",   "L",  1, 0, "Avisar venta sin stocks",                         "AvisarSinStock",                "", "( cDbfCol )", nil } )
   aAdd( aColAlbCli, { "lNotVta",   "L",  1, 0, "No permitir venta sin stocks",                    "NoPermitirSinStock",            "", "( cDbfCol )", nil } )
   aAdd( aColAlbCli, { "mNumSer",   "M", 10, 0, "" ,                                               "",                              "", "( cDbfCol )", nil } )
   aAdd( aColAlbCli, { "cCodTip",   "C",  4, 0, "Código del tipo de artículo",                     "TipoArticulo",                  "", "( cDbfCol )", nil } )
   aAdd( aColAlbCli, { "cCodFam",   "C", 16, 0, "Código de familia",                               "Familia",                       "", "( cDbfCol )", nil } )
   aAdd( aColAlbCli, { "cGrpFam",   "C",  3, 0, "Código del grupo de familia",                     "GrupoFamilia",                  "", "( cDbfCol )", nil } )
   aAdd( aColAlbCli, { "nReq",      "N", 18, 8, "Recargo de equivalencia",                         "RecargoEquivalencia",           "", "( cDbfCol )", nil } )
   aAdd( aColAlbCli, { "mObsLin",   "M", 10, 0, "Observación de línea",                            "Observaciones",                 "", "( cDbfCol )", nil } )
   aAdd( aColAlbCli, { "cCodPrv",   "C", 12, 0, "Código del proveedor",                            "Proveedor",                     "", "( cDbfCol )", nil } )
   aAdd( aColAlbCli, { "cNomPrv",   "C", 30, 0, "Nombre del proveedor",                            "NombreProveedor",               "", "( cDbfCol )", nil } )
   aAdd( aColAlbCli, { "cImagen",   "C",250, 0, "Fichero de imagen" ,                              "Imagen",                        "", "( cDbfCol )", nil } )
   aAdd( aColAlbCli, { "nPuntos",   "N", 15, 6, "Puntos del artículo",                             "",                              "", "( cDbfCol )", nil } )
   aAdd( aColAlbCli, { "nValPnt",   "N", 18, 8, "Valor del punto",                                 "",                              "", "( cDbfCol )", nil } )
   aAdd( aColAlbCli, { "nDtoPnt",   "N",  5, 2, "Descuento puntos",                                "",                              "", "( cDbfCol )", nil } )
   aAdd( aColAlbCli, { "nIncPnt",   "N",  5, 2, "Incremento porcentual",                           "",                              "", "( cDbfCol )", nil } )
   aAdd( aColAlbCli, { "cRefPrv",   "C", 18, 0, "Referencia proveedor",                            "ReferenciaProveedor",           "", "( cDbfCol )", nil } )
   aAdd( aColAlbCli, { "nVolumen",  "N", 18, 8, "Volumen del producto" ,                           "Volumen",                       "", "( cDbfCol )", nil } )
   aAdd( aColAlbCli, { "cVolumen",  "C",  2, 0, "Unidad del volumen" ,                             "UnidadMedicionVolumen",         "", "( cDbfCol )", nil } )
   aAdd( aColAlbCli, { "dFecEnt" ,  "D",  8, 0, "Fecha de entrada del alquiler",                   "FechaEntradaAlquiler",          "", "( cDbfCol )", nil } )
   aAdd( aColAlbCli, { "dFecSal" ,  "D",  8, 0, "Fecha de salida del alquiler",                    "FechaSalidaAlquiler",           "", "( cDbfCol )", nil } )
   aAdd( aColAlbCli, { "nPreAlq" ,  "N", 18, 8, "Precio de alquiler",                              "PrecioAlquiler",                "", "( cDbfCol )", nil } )
   aAdd( aColAlbCli, { "lAlquiler", "L",  1, 0, "Lógico de alquiler",                              "Alquiler",                      "", "( cDbfCol )", nil } )
   aAdd( aColAlbCli, { "nNumMed",   "N",  1, 0, "Número de mediciones",                            "NumeroMediciones",              "", "( cDbfCol )", nil } )
   aAdd( aColAlbCli, { "nMedUno",   "N", 18, 8, "Primera unidad de medición",                      "Medicion1",                     "", "( cDbfCol )", nil } )
   aAdd( aColAlbCli, { "nMedDos",   "N", 18, 8, "Segunda unidad de medición",                      "Medicion2",                     "", "( cDbfCol )", nil } )
   aAdd( aColAlbCli, { "nMedTre",   "N", 18, 8, "Tercera unidad de medición",                      "Medicion3",                     "", "( cDbfCol )", nil } )
   aAdd( aColAlbCli, { "nTarLin",   "N", 18, 8, "Tarifa de precio aplicada",                       "NumeroTarifa",                  "", "( cDbfCol )", nil } )
   aAdd( aColAlbCli, { "cCodUbi1",  "C",  5, 0, "",                                                "",                              "", "( cDbfCol )", nil } )
   aAdd( aColAlbCli, { "cCodUbi2",  "C",  5, 0, "",                                                "",                              "", "( cDbfCol )", nil } )
   aAdd( aColAlbCli, { "cCodUbi3",  "C",  5, 0, "",                                                "",                              "", "( cDbfCol )", nil } )
   aAdd( aColAlbCli, { "cValUbi1",  "C",  5, 0, "",                                                "",                              "", "( cDbfCol )", nil } )
   aAdd( aColAlbCli, { "cValUbi2",  "C",  5, 0, "",                                                "",                              "", "( cDbfCol )", nil } )
   aAdd( aColAlbCli, { "cValUbi3",  "C",  5, 0, "",                                                "",                              "", "( cDbfCol )", nil } )
   aAdd( aColAlbCli, { "cNomUbi1",  "C", 30, 0, "",                                                "",                              "", "( cDbfCol )", nil } )
   aAdd( aColAlbCli, { "cNomUbi2",  "C", 30, 0, "",                                                "",                              "", "( cDbfCol )", nil } )
   aAdd( aColAlbCli, { "cNomUbi3",  "C", 30, 0, "",                                                "",                              "", "( cDbfCol )", nil } )
   aAdd( aColAlbCli, { "lImpFra",   "L",  1, 0, "Lógico de imprimir frase publicitaria",           "",                              "", "( cDbfCol )", nil } )
   aAdd( aColAlbCli, { "cCodFra",   "C",  3, 0, "Código de frase publicitaria",                    "",                              "", "( cDbfCol )", nil } )
   aAdd( aColAlbCli, { "cTxtFra",   "C",250, 0, "",                                                "",                              "", "( cDbfCol )", nil } )
   aAdd( aColAlbCli, { "Descrip",   "M", 10, 0, "Observación de línea",                            "DescripcionTecnica",            "", "( cDbfCol )", nil } )
   aAdd( aColAlbCli, { "lFacturado","L",  1, 0, "Lógico de facturado",                             "",                              "", "( cDbfCol )", nil } )
   aAdd( aColAlbCli, { "lLinOfe"  , "L",  1, 0, "Línea con oferta",                                "LineaOferta",                   "", "( cDbfCol )", nil } )
   aAdd( aColAlbCli, { "lVolImp",   "L",  1, 0, "Lógico aplicar volumen con impuestos especiales", "VolumenImpuestosEspeciales",    "", "( cDbfCol )", nil } )
   aAdd( aColAlbCli, { "dFecAlb",   "D",  8, 0, "Fecha de albaran",                                "Fecha",                         "", "( cDbfCol )", {|| GetSysDate() } } )
   aAdd( aColAlbCli, { "cNumSat",   "C", 12, 0, "Número del SAT" ,                                 "NumeroSat",                     "", "( cDbfCol )", nil } )
   aAdd( aColAlbCli, { "lFromAtp",  "L",  1, 0, "",                                                "",                              "", "( cDbfCol )", nil } )
   aAdd( aColAlbCli, { "cCodCli",   "C", 12, 0, "Código de cliente",                               "Cliente",                       "", "( cDbfCol )", nil } )
   aAdd( aColAlbCli, { "dFecUltCom","D",  8, 0, "Fecha última compra",                             "FechaUltimaVenta",             "", "( cDbfCol )", nil } )
   aAdd( aColAlbCli, { "nUniUltCom","N", 18, 8, "Unidades última compra",                          "UnidadesUltimaVenta",          "", "( cDbfCol )", nil } )
   aAdd( aColAlbCli, { "nBultos",   "N", 18, 8, "Numero de bultos",                                "",                              "", "( cDbfCol )", nil } )
   aAdd( aColAlbCli, { "cFormato",  "C",100, 0, "Formato de venta",                                "",                              "", "( cDbfCol )", nil } )
   aAdd( aColAlbCli, { "tFecAlb" ,  "C",  6, 0, "Hora del albarán",                                "Hora",                          "", "( cDbfCol )", {|| GetSysTime() } } )
   aAdd( aColAlbCli, { "cCtrCoste", "C",  9, 0, "Código del centro de coste",                      "CentroCoste",                   "", "( cDbfCol )", nil } )
   aAdd( aColAlbCli, { "lLabel",    "L",  1, 0, "Lógico para marca de etiqueta",                   "",                              "", "( cDbfCol )", nil } )
   aAdd( aColAlbCli, { "nLabel",    "N",  6, 0, "Unidades de etiquetas a imprimir",                "",                              "", "( cDbfCol )", nil } )
   aAdd( aColAlbCli, { "cObrLin",   "C", 10, 0, "Dirección de la linea",                           "Direccion",                     "", "( cDbfCol )", nil } )
   aAdd( aColAlbCli, { "cRefAux",   "C", 18, 0, "Referencia auxiliar",                             "ReferenciaAuxiliar",            "", "( cDbfCol )", nil } )
   aAdd( aColAlbCli, { "cRefAux2",  "C", 18, 0, "Segunda referencia auxiliar",                     "ReferenciaAuxiliar2",           "", "( cDbfCol )", nil } )
   aAdd( aColAlbCli, { "nPosPrint", "N",  4, 0, "Posición de impresión",                           "PosicionImpresion",             "", "( cDbfCol )", nil } )
   aAdd( aColAlbCli, { "cTipCtr",   "C", 20, 0, "Tipo tercero centro de coste",                    "",                              "", "( cDbfCol )", nil } )
   aAdd( aColAlbCli, { "cTerCtr",   "C", 20, 0, "Tercero centro de coste",                         "",                              "", "( cDbfCol )", nil } )
   aAdd( aColAlbCli, { "nNumKit",   "N",  4, 0, "Número de línea de escandallo",                   "",                              "", "( cDbfCol )", nil } )
   aAdd( aColAlbCli, { "id_tipo_v", "N", 16, 0, "Identificador tipo de venta",                     "IdentificadorTipoVenta",        "", "( cDbfCol )", nil } )
   aAdd( aColAlbCli, { "nRegIva",   "N",  1, 0, "Régimen de " + cImp(),                            "TipoImpuesto",                  "", "( cDbfCol )", nil } )
   aAdd( aColAlbCli, { "nPrcUltCom","N", 16, 6, "Precio última compra",                            "PrecioUltimaVenta",             "", "( cDbfCol )", nil } ) 

Return ( aColAlbCli )

//---------------------------------------------------------------------------//

Function aItmAlbCli()

   local aItmAlbCli := {}

   aAdd( aItmAlbCli, { "CSERALB"   ,"C",  1, 0, "Serie del albarán" ,                                       "Serie",                         "", "( cDbf )", {|| "A" } } )
   aAdd( aItmAlbCli, { "NNUMALB"   ,"N",  9, 0, "Número del albarán" ,                                      "Numero",                        "", "( cDbf )", nil } )
   aAdd( aItmAlbCli, { "CSUFALB"   ,"C",  2, 0, "Sufijo del albarán" ,                                      "Sufijo",                        "", "( cDbf )", {|| RetSufEmp() } } )
   aAdd( aItmAlbCli, { "CTURALB"   ,"C",  6, 0, "Sesión del albarán",                                       "Turno",                         "", "( cDbf )", {|| cCurSesion( nil, .f.) } } )
   aAdd( aItmAlbCli, { "DFECALB"   ,"D",  8, 0, "Fecha del albarán" ,                                       "Fecha",                         "", "( cDbf )", {|| GetSysDate() } } )
   aAdd( aItmAlbCli, { "CCODCLI"   ,"C", 12, 0, "Código del cliente" ,                                      "Cliente",                       "", "( cDbf )", nil } )
   aAdd( aItmAlbCli, { "CCODALM"   ,"C", 16, 0, "Código de almacén" ,                                       "Almacen",                       "", "( cDbf )", {|| Application():codigoAlmacen() } } )
   aAdd( aItmAlbCli, { "CCODCAJ"   ,"C",  3, 0, "Código de caja" ,                                          "Caja",                          "", "( cDbf )", {|| Application():CodigoCaja() } } )
   aAdd( aItmAlbCli, { "CNOMCLI"   ,"C", 80, 0, "Nombre del cliente" ,                                      "NombreCliente",                 "", "( cDbf )", nil } )
   aAdd( aItmAlbCli, { "CDIRCLI"   ,"C",200, 0, "Domicilio del cliente" ,                                   "DomicilioCliente",              "", "( cDbf )", nil } )
   aAdd( aItmAlbCli, { "CPOBCLI"   ,"C",200, 0, "Población del cliente" ,                                   "PoblacionCliente",              "", "( cDbf )", nil } )
   aAdd( aItmAlbCli, { "CPRVCLI"   ,"C",100, 0, "Provincia del cliente" ,                                   "ProvinciaCliente",              "", "( cDbf )", nil } )
   aAdd( aItmAlbCli, { "CPOSCLI"   ,"C", 15, 0, "Código postal del cliente" ,                               "CodigoPostalCliente",           "", "( cDbf )", nil } )
   aAdd( aItmAlbCli, { "CDNICLI"   ,"C", 30, 0, "DNI/CIF del cliente" ,                                     "DniCliente",                    "", "( cDbf )", nil } )
   aAdd( aItmAlbCli, { "LMODCLI"   ,"L",  1, 0, "Lógico de modificar datos del cliente" ,                   "ModificarDatosCliente",         "", "( cDbf )", nil } )
   aAdd( aItmAlbCli, { "lFacturado","L",  1, 0, "Lógico de facturado" ,                                     "Facturado",                     "", "( cDbf )", nil } )
   aAdd( aItmAlbCli, { "lEntregado","L",  1, 0, "Lógico albarán enviado" ,                                  "Entregado",                     "", "( cDbf )", nil } )
   aAdd( aItmAlbCli, { "DFECENT"   ,"D",  8, 0, "Fecha de entrada del albarán" ,                            "FechaSalida",                   "", "( cDbf )", nil } )
   aAdd( aItmAlbCli, { "CCODSUALB" ,"C", 25, 0, "Referencia a su albarán" ,                                 "DocumentoOrigen",               "", "( cDbf )", nil } )
   aAdd( aItmAlbCli, { "CCONDENT"  ,"C",100, 0, "Condición de entrada" ,                                    "Condiciones",                   "", "( cDbf )", nil } )
   aAdd( aItmAlbCli, { "MCOMENT"   ,"M", 10, 0, "Cometarios del albarán" ,                                  "Comentarios",                   "", "( cDbf )", nil } )
   aAdd( aItmAlbCli, { "MOBSERV"   ,"M", 10, 0, "Observaciones" ,                                           "Observaciones",                 "", "( cDbf )", nil } )
   aAdd( aItmAlbCli, { "CCODPAGO"  ,"C",  2, 0, "Código de la forma de pago" ,                              "Pago",                          "", "( cDbf )", nil } )
   aAdd( aItmAlbCli, { "NBULTOS"   ,"N",  5, 0, "Número de bultos" ,                                        "Bultos",                        "", "( cDbf )", nil } )
   aAdd( aItmAlbCli, { "NPORTES"   ,"N", 18, 8, "Importe de los portes" ,                                   "",                              "", "( cDbf )", nil } )
   aAdd( aItmAlbCli, { "CCODAGE"   ,"C",  3, 0, "Código del agente" ,                                       "Agente",                        "", "( cDbf )", nil } )
   aAdd( aItmAlbCli, { "CCODOBR"   ,"C", 10, 0, "Código de dirección" ,                                     "Direccion",                     "", "( cDbf )", nil } )
   aAdd( aItmAlbCli, { "CCODTAR"   ,"C",  5, 0, "Código de tarifa" ,                                        "Tarifa",                        "", "( cDbf )", nil } )
   aAdd( aItmAlbCli, { "CCODRUT"   ,"C",  4, 0, "Código de ruta" ,                                          "Ruta",                          "", "( cDbf )", nil } )
   aAdd( aItmAlbCli, { "CNUMPED"   ,"C", 12, 0, "Número del pedido" ,                                       "NumeroPedido",                  "", "( cDbf )", nil } )
   aAdd( aItmAlbCli, { "cNumPre"   ,"C", 12, 0, "Número del presupuesto" ,                                  "NumeroPresupuesto",             "", "( cDbf )", nil } )
   aAdd( aItmAlbCli, { "cNumSat"   ,"C", 12, 0, "Número del SAT" ,                                          "NumeroSat",                     "", "( cDbf )", nil } )
   aAdd( aItmAlbCli, { "NTIPOALB"  ,"N",  1, 0, "Tipo de albarán" ,                                         "",                              "", "( cDbf )", nil } )
   aAdd( aItmAlbCli, { "CNUMFAC"   ,"C", 12, 0, "Número del documento facturado" ,                          "NumeroFactura",                 "", "( cDbf )", nil } )
   aAdd( aItmAlbCli, { "LMAYOR"    ,"L",  1, 0, "" ,                                                        "",                              "", "( cDbf )", nil } )
   aAdd( aItmAlbCli, { "NTARIFA"   ,"N",  1, 0, "Tarifa de precio aplicada" ,                               "NumeroTarifa",                  "", "( cDbf )", nil } )
   aAdd( aItmAlbCli, { "CDTOESP"   ,"C", 50, 0, "Descripción porcentaje de descuento",                      "DescripcionDescuento1",         "", "( cDbf )", nil } )
   aAdd( aItmAlbCli, { "NDTOESP"   ,"N",  6, 2, "Porcentaje de descuento",                                  "PorcentajeDescuento1",          "", "( cDbf )", nil } )
   aAdd( aItmAlbCli, { "CDPP"      ,"C", 50, 0, "Descripción pct. de dto. por pronto pago",                 "DescripcionDescuento2",         "", "( cDbf )", nil } )
   aAdd( aItmAlbCli, { "NDPP"      ,"N",  6, 2, "Porcentaje de dto. por pronto pago",                       "PorcentajeDescuento2",          "", "( cDbf )", nil } )
   aAdd( aItmAlbCli, { "CDTOUNO"   ,"C", 25, 0, "Descripción del primer descuento personalizado",           "DescripcionDescuento3",         "", "( cDbf )", nil } )
   aAdd( aItmAlbCli, { "NDTOUNO"   ,"N",  4, 1, "Porcentaje del primer descuento pers.",                    "PorcentajeDescuento3",          "", "( cDbf )", nil } )
   aAdd( aItmAlbCli, { "CDTODOS"   ,"C", 25, 0, "Descripción del segundo descuento pers.",                  "DescripcionDescuento4",         "", "( cDbf )", nil } )
   aAdd( aItmAlbCli, { "NDTODOS"   ,"N",  4, 1, "Descripción del segundo descuento pers.",                  "PorcentajeDescuento4",          "", "( cDbf )", nil } )
   aAdd( aItmAlbCli, { "NDTOCNT"   ,"N",  6, 2, "Pct. de dto. por pago contado",                            "",                              "", "( cDbf )", nil } )
   aAdd( aItmAlbCli, { "NDTORAP"   ,"N",  6, 2, "Pct. de dto. por rappel",                                  "",                              "", "( cDbf )", nil } )
   aAdd( aItmAlbCli, { "NDTOPUB"   ,"N",  6, 2, "Pct. de dto. por publicidad",                              "",                              "", "( cDbf )", nil } )
   aAdd( aItmAlbCli, { "NDTOPGO"   ,"N",  6, 2, "Pct. de dto. por pago centralizado",                       "",                              "", "( cDbf )", nil } )
   aAdd( aItmAlbCli, { "NDTOPTF"   ,"N",  7, 2, ""                                 ,                        "",                              "", "( cDbf )", nil } )
   aAdd( aItmAlbCli, { "LRECARGO"  ,"L",  1, 0, "Lógico recargo de equivalencia",                           "RecargoEquivalencia",           "", "( cDbf )", nil } )
   aAdd( aItmAlbCli, { "NPCTCOMAGE","N",  6, 2, "Pct. de comisión del agente",                              "ComisionAgente",                "", "( cDbf )", nil } )
   aAdd( aItmAlbCli, { "LSNDDOC"   ,"L",  1, 0, "Lógico de documento a enviar",                             "Envio",                         "", "( cDbf )", {|| .t. } } )
   aAdd( aItmAlbCli, { "CDIVALB"   ,"C",  3, 0, "Código de divisa",                                         "Divisa",                        "", "( cDbf )", {|| cDivEmp() } } )
   aAdd( aItmAlbCli, { "NVDVALB"   ,"N", 10, 4, "Valor del cambio de la divisa",                            "ValorDivisa",                   "", "( cDbf )", {|| nChgDiv() } } )
   aAdd( aItmAlbCli, { "CRETPOR"   ,"C",100, 0, "Retirado por" ,                                            "RetiradoPor",                   "", "( cDbf )", nil } )
   aAdd( aItmAlbCli, { "CRETMAT"   ,"C", 20, 0, "Matrícula" ,                                               "Matricula",                     "", "( cDbf )", nil } )
   aAdd( aItmAlbCli, { "CNUMDOC"   ,"C", 12, 0, "",                                                         "NumeroDocumento",               "", "( cDbf )", nil } )
   aAdd( aItmAlbCli, { "CSUPED"    ,"C", 50, 0, "Su pedido",                                                "NumeroSuPedido",                "", "( cDbf )", nil } )
   aAdd( aItmAlbCli, { "LIVAINC"   ,"L",  1, 0, cImp() + " incluido",                                       "ImpuestosIncluidos",            "", "( cDbf )", {|| uFieldEmpresa( "lIvaInc" ) } } )
   aAdd( aItmAlbCli, { "NREGIVA"   ,"N",  1, 0, "Regimen de " + cImp(),                                     "TipoImpuesto",                  "", "( cDbf )", nil } )
   aAdd( aItmAlbCli, { "LGENLQD"   ,"L",  1, 0, "Generado por liquidación",                                 "",                              "", "( cDbf )", nil } )
   aAdd( aItmAlbCli, { "NNUMORD"   ,"N",  9, 0, "Número de la orden de carga" ,                             "NumeroOrdenCarga",              "", "( cDbf )", nil } )
   aAdd( aItmAlbCli, { "CSUFORD"   ,"C",  2, 0, "Sufijo de la orden de carga" ,                             "SufijoOrdenCarga",              "", "( cDbf )", nil } )
   aAdd( aItmAlbCli, { "DFECORD"   ,"D",  8, 0, "Fecha de la orden de carga" ,                              "FechaOrdenCarga",               "", "( cDbf )", nil } )
   aAdd( aItmAlbCli, { "NIVAMAN"   ,"N",  6, 2, "Porcentaje de " + cImp() + " del gasto" ,                  "ImpuestoGastos",                "", "( cDbf )", {|| nIva( nil, cDefIva() ) } } )
   aAdd( aItmAlbCli, { "NMANOBR"   ,"N", 18, 8, "Gastos" ,                                                  "Gastos",                        "", "( cDbf )", nil } )
   aAdd( aItmAlbCli, { "cCodTrn"   ,"C",  9, 0, "Código del transportista" ,                                "Transportista",                 "", "( cDbf )", nil } )
   aAdd( aItmAlbCli, { "nKgsTrn"   ,"N", 18, 8, "TARA del transportista" ,                                  "TaraTransportista",             "", "( cDbf )", nil } )
   aAdd( aItmAlbCli, { "lCloAlb"   ,"L",  1, 0, "" ,                                                        "DocumentoCerrado",              "", "( cDbf )", nil } )
   aAdd( aItmAlbCli, { "cCodUsr"   ,"C",  3, 0, "Código de usuario",                                        "Usuario",                       "", "( cDbf )", {|| Auth():Codigo() } } )
   aAdd( aItmAlbCli, { "dFecCre"   ,"D",  8, 0, "Fecha de creación/modificación del documento",             "FechaCreacion",                 "", "( cDbf )", nil } )
   aAdd( aItmAlbCli, { "cTimCre"   ,"C",  5, 0, "Hora de creación/modificación del documento",              "HoraCreacion",                  "", "( cDbf )", nil } )
   aAdd( aItmAlbCli, { "dFecEnv"   ,"D",  8, 0, "Fecha de envio",                                           "FechaEnvio",                    "", "( cDbf )", {|| cTod( "" ) } } )
   aAdd( aItmAlbCli, { "cCodGrp"   ,"C",  4, 0, "Código de grupo de cliente" ,                              "GrupoCliente",                  "", "( cDbf )", nil } )
   aAdd( aItmAlbCli, { "lImprimido","L",  1, 0, "Lógico de imprimido" ,                                     "Imprimido",                     "", "( cDbf )", nil } )
   aAdd( aItmAlbCli, { "dFecImp"   ,"D",  8, 0, "Última fecha de impresión" ,                               "FechaImpresion",                "", "( cDbf )", {|| cTod( "" ) } } )
   aAdd( aItmAlbCli, { "cHorImp"   ,"C",  5, 0, "Hora de la última impresión" ,                             "HoraImpresion",                 "", "( cDbf )", nil } )
   aAdd( aItmAlbCli, { "cCodDlg"   ,"C",  2, 0, "Código delegación" ,                                       "Delegacion",                    "", "( cDbf )", {|| Application():CodigoDelegacion() } } )
   aAdd( aItmAlbCli, { "nDtoAtp"   ,"N",  6, 2, "Porcentaje de descuento atípico",                          "DescuentoAtipico",              "", "( cDbf )", nil } )
   aAdd( aItmAlbCli, { "nSbrAtp"   ,"N",  1, 0, "Lugar donde aplicar dto atípico",                          "LugarAplicarDescuentoAtipico",  "", "( cDbf )", nil } )
   aAdd( aItmAlbCli, { "nMontaje"  ,"N",  6, 2, "Horas de montaje",                                         "Montaje",                       "", "( cDbf )", nil } )
   aAdd( aItmAlbCli, { "dFecEntr",  "D",  8, 0, "Fecha de entrada de alquiler",                             "EntradaAlquiler",               "", "( cDbf )", nil } )
   aAdd( aItmAlbCli, { "dFecSal",   "D",  8, 0, "Fecha de salida de alquiler",                              "SalidaAlquiler",                "", "( cDbf )", nil } )
   aAdd( aItmAlbCli, { "lAlquiler", "L",  1, 0, "Lógico de alquiler",                                       "Alquiler",                      "", "( cDbf )", nil } )
   aAdd( aItmAlbCli, { "cManObr",   "C",250, 0, "" ,                                                        "LiteralGastos",                 "", "( cDbf )", {|| padr( getConfigTraslation( "Gastos" ), 250 ) } } )
   aAdd( aItmAlbCli, { "lOrdCar",   "L",  1, 0, "Lógico de pertenecer a un orden de carga" ,                "",                              "", "( cDbf )", nil } )
   aAdd( aItmAlbCli, { "cNumTik",   "C", 13, 0, "Número del ticket" ,                                       "NumeroTicket",                  "", "( cDbf )", nil } )
   aAdd( aItmAlbCli, { "cTlfCli",   "C", 20, 0, "Teléfono del cliente" ,                                    "TelefonoCliente",               "", "( cDbf )", nil } )
   aAdd( aItmAlbCli, { "nTotNet",   "N", 18, 8, "Total neto" ,                                              "TotalNeto",                     "", "( cDbf )", nil } )
   aAdd( aItmAlbCli, { "nTotIva",   "N", 18, 8, "Total " + cImp() ,                                         "TotalImpuesto",                 "", "( cDbf )", nil } )
   aAdd( aItmAlbCli, { "nTotReq",   "N", 18, 8, "Total recargo" ,                                           "TotalRecargo",                  "", "( cDbf )", nil } )
   aAdd( aItmAlbCli, { "nTotAlb",   "N", 18, 8, "Total albarán" ,                                           "TotalDocumento",                "", "( cDbf )", nil } )
   aAdd( aItmAlbCli, { "nTotPag",   "N", 18, 8, "Total anticipado" ,                                        "",                              "", "( cDbf )", nil } )
   aAdd( aItmAlbCli, { "lOperPV",   "L",  1, 0, "Lógico para operar con punto verde" ,                      "OperarPuntoVerde",              "", "( cDbf )", nil } )
   aAdd( aItmAlbCli, { "cBanco"   , "C", 50, 0, "Nombre del banco del cliente",                             "NombreBanco",                   "", "( cDbf )", nil } )
   aAdd( aItmAlbCli, { "cPaisIBAN", "C",  2, 0, "País IBAN de la cuenta bancaria del cliente",              "CuentaIBAN",                    "", "( cDbf )", nil } )
   aAdd( aItmAlbCli, { "cCtrlIBAN", "C",  2, 0, "Dígito de control IBAN de la cuenta bancaria del cliente", "DigitoControlIBAN",             "", "( cDbf )", nil } )
   aAdd( aItmAlbCli, { "cEntBnc"  , "C",  4, 0, "Entidad de la cuenta bancaria del cliente",                "EntidadCuenta",                 "", "( cDbf )", nil } )
   aAdd( aItmAlbCli, { "cSucBnc"  , "C",  4, 0, "Sucursal de la cuenta bancaria del cliente",               "Sucursal Cuenta",               "", "( cDbf )", nil } )
   aAdd( aItmAlbCli, { "cDigBnc"  , "C",  2, 0, "Dígito de control de la cuenta bancaria del cliente",      "DigitoControlCuenta",           "", "( cDbf )", nil } )
   aAdd( aItmAlbCli, { "cCtaBnc"  , "C", 10, 0, "Cuenta bancaria del cliente",                              "CuentaBancaria",                "", "( cDbf )", nil } )
   aAdd( aItmAlbCli, { "nDtoTarifa","N",  6, 2, "Descuento de tarifa de cliente",                           "DescuentoTarifa",               "", "( cDbf )", nil } )
   aAdd( aItmAlbCli, { "nFacturado","N",  1, 0, "Estado del albaran" ,                                      "Estado",                        "", "( cDbf )", {|| 1 } } )
   aAdd( aItmAlbCli, { "tFecAlb",   "C",  6, 0, "Hora del albarán" ,                                        "Hora",                          "", "( cDbf )", {|| getSysTime() } } )
   aAdd( aItmAlbCli, { "cCtrCoste", "C",  9, 0, "Código del centro de coste" ,                              "CentroCoste",                   "", "( cDbf )", nil } )
   aAdd( aItmAlbCli, { "mFirma",    "M", 10, 0, "Firma" ,                                                   "Firma",                         "", "( cDbf )", nil } )                  

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
   local nRegIva
   local nBaseGasto
   local nIvaGasto

   DEFAULT cAlbCliT        := D():Get( "AlbCliT", nView )
   DEFAULT cAlbCliL        := D():Get( "AlbCliL", nView )
   DEFAULT cAlbaran        := ( cAlbCliT )->cSerAlb + Str( ( cAlbCliT )->nNumAlb ) + ( cAlbCliT )->cSufAlb
   DEFAULT cIva            := D():Get( "TIva", nView )
   DEFAULT cDiv            := D():Get( "Divisas", nView )
   DEFAULT lPic            := .f.
   DEFAULT lNeto           := .f.

   if empty( Select( cAlbCliT ) )
      Return ( 0 )
   end if

   if empty( Select( cAlbCliL ) )
      Return ( 0 )
   end if

   if empty( Select( cIva ) )
      Return ( 0 )
   end if

   if empty( Select( cDiv ) )
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
      nDtoEsp        := aTmp[ _NDTOESP ]
      nDtoPP         := aTmp[ _NDPP    ]
      nDtoCnt        := aTmp[ _NDTOCNT ]
      nDtoRap        := aTmp[ _NDTORAP ]
      nDtoPub        := aTmp[ _NDTOPUB ]
      nDtoPgo        := aTmp[ _NDTOPGO ]
      nDtoPtf        := aTmp[ _NDTOPTF ]
      lRecargo       := aTmp[ _LRECARGO]
      nIvaMan        := aTmp[ _NIVAMAN ]
      nManObr        := aTmp[ _NMANOBR ]
      cCodDiv        := aTmp[ _CDIVALB ]
      nVdvDiv        := aTmp[ _NVDVALB ]
      cCodPgo        := aTmp[ _CCODPAGO]
      lIvaInc        := aTmp[ _LIVAINC ]
      nDtoAtp        := aTmp[ _NDTOATP ]
      nSbrAtp        := aTmp[ _NSBRATP ]
      nKgsTrn        := aTmp[ _NKGSTRN ]
      lOperarPntVer  := aTmp[ _LOPERPV ]
      nRegIva        := aTmp[ _NREGIVA ]
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
      nRegIva        := ( cAlbCliT )->nRegIva
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

               // Estudio de impuestos-----------------------------------------------

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

   // Ordenamos los impuestos de menor a mayor

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

      _NBASIVA1      -= aTotalDto[1]
      _NBASIVA2      -= aTotalDto[2]
      _NBASIVA3      -= aTotalDto[3]

   end if

   // Descuentos atipicos sobre Descuentos especiales

   if nSbrAtp == 2 .and. nDtoAtp != 0

      aTotalAtp[1]   := Round( _NBASIVA1 * nDtoAtp / 100, nRouDiv )
      aTotalAtp[2]   := Round( _NBASIVA2 * nDtoAtp / 100, nRouDiv )
      aTotalAtp[3]   := Round( _NBASIVA3 * nDtoAtp / 100, nRouDiv )

      nTotAtp        := aTotalAtp[ 1 ] + aTotalAtp[ 2 ] + aTotalAtp[ 3 ]

   end if

   // Descuentos por Pronto Pago estos son los buenos

   IF nDtoPP   != 0

      aTotalDPP[1]   := Round( _NBASIVA1 * nDtoPP / 100, nRouDiv )
      aTotalDPP[2]   := Round( _NBASIVA2 * nDtoPP / 100, nRouDiv )
      aTotalDPP[3]   := Round( _NBASIVA3 * nDtoPP / 100, nRouDiv )

      nTotDPP        := aTotalDPP[1] + aTotalDPP[2] + aTotalDPP[3]

      _NBASIVA1      -= aTotalDPP[1]
      _NBASIVA2      -= aTotalDPP[2]
      _NBASIVA3      -= aTotalDPP[3]

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

      _NBASIVA1      -= aTotalUno[1]
      _NBASIVA2      -= aTotalUno[2]
      _NBASIVA3      -= aTotalUno[3]

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

      _NBASIVA1      -= aTotalDos[1]
      _NBASIVA2      -= aTotalDos[2]
      _NBASIVA3      -= aTotalDos[3]

   END IF

   // Descuentos atipicos sobre Descuento definido 2

   if nSbrAtp == 5 .and. nDtoAtp != 0

      aTotalAtp[1]   := Round( _NBASIVA1 * nDtoAtp / 100, nRouDiv )
      aTotalAtp[2]   := Round( _NBASIVA2 * nDtoAtp / 100, nRouDiv )
      aTotalAtp[3]   := Round( _NBASIVA3 * nDtoAtp / 100, nRouDiv )

      nTotAtp        := aTotalAtp[ 1 ] + aTotalAtp[ 2 ] + aTotalAtp[ 3 ]

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

   if !lIvaInc .and.  uFieldEmpresa( "lIvaImpEsp" )
      _NBASIVA1      += _NIVMIVA1
      _NBASIVA2      += _NIVMIVA2
      _NBASIVA3      += _NIVMIVA3
   end if

   // Calculamos los impuestos-----------------------------------------------------

   if !lIvaInc

      if nRegIva <= 1

         //Calculos de impuestos

         _NIMPIVA1      := if ( _NPCTIVA1 != NIL, Round( _NBASIVA1 * _NPCTIVA1 / 100, nRouDiv ), 0 )
         _NIMPIVA2      := if ( _NPCTIVA2 != NIL, Round( _NBASIVA2 * _NPCTIVA2 / 100, nRouDiv ), 0 )
         _NIMPIVA3      := if ( _NPCTIVA3 != NIL, Round( _NBASIVA3 * _NPCTIVA3 / 100, nRouDiv ), 0 )

         //Calculo de recargo

         if lRecargo
            _NIMPREQ1   := if ( _NPCTIVA1 != NIL, Round( _NBASIVA1 * _NPCTREQ1 / 100, nRouDiv ), 0 )
            _NIMPREQ2   := if ( _NPCTIVA2 != NIL, Round( _NBASIVA2 * _NPCTREQ2 / 100, nRouDiv ), 0 )
            _NIMPREQ3   := if ( _NPCTIVA3 != NIL, Round( _NBASIVA3 * _NPCTREQ3 / 100, nRouDiv ), 0 )
         end if

         if uFieldEmpresa( "lIvaImpEsp")
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
            if _NPCTREQ2 != 0
               _NIMPREQ2   := if( _NPCTIVA2 != NIL, Round( _NBASIVA2 / ( 100 / _NPCTREQ2 + 1 ), nRouDiv ), 0 )
            end if
            if _NPCTREQ3 != 0
               _NIMPREQ3   := if( _NPCTIVA3 != NIL, Round( _NBASIVA3 / ( 100 / _NPCTREQ3 + 1 ), nRouDiv ), 0 )
            end if
         end if

      end if

      _NBASIVA1      -= _NIMPIVA1
      _NBASIVA2      -= _NIMPIVA2
      _NBASIVA3      -= _NIMPIVA3

      if uFieldEmpresa( "lIvaImpEsp")
         _NBASIVA1   -= _NIVMIVA1
         _NBASIVA2   -= _NIVMIVA2
         _NBASIVA3   -= _NIVMIVA3
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

   // Neto del Albaran

   nTotNet           := Round( _NBASIVA1 + _NBASIVA2 + _NBASIVA3, nRouDiv )

   // Total IVMH

   nTotIvm           := Round( aTotIvm[ 1, 3 ] + aTotIvm[ 2, 3 ] + aTotIvm[ 3, 3 ], nRouDiv )

   // Total Transpote

   nTotTrn           := Round( _NTRNIVA1 + _NTRNIVA2 + _NTRNIVA3, nRouDiv )

   // Total punto verde

   nTotPnt           := Round( _NPNTVER1 + _NPNTVER2 + _NPNTVER3, nRouDiv )

   // Total de impuestos

   nTotIva           := Round( _NIMPIVA1 + _NIMPIVA2 + _NIMPIVA3, nRouDiv )

   // Total de R.E.

   nTotReq           := Round( _NIMPREQ1 + _NIMPREQ2 + _NIMPREQ3, nRouDiv )

   // Total de impuestos

   nTotImp           := Round( nTotIva + nTotReq + nTotIvm, nRouDiv )

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
      nTotNet        := nCnv2Div( nTotNet, cCodDiv, cDivRet )
      nTotIvm        := nCnv2Div( nTotIvm, cCodDiv, cDivRet )
      nTotIva        := nCnv2Div( nTotIva, cCodDiv, cDivRet )
      nTotReq        := nCnv2Div( nTotReq, cCodDiv, cDivRet )
      nTotAlb        := nCnv2Div( nTotAlb, cCodDiv, cDivRet )
      nTotPnt        := nCnv2Div( nTotPnt, cCodDiv, cDivRet )
      nTotTrn        := nCnv2Div( nTotTrn, cCodDiv, cDivRet )
      cPorDiv        := cPorDiv( cDivRet, cDiv )
   end if

RETURN ( if( lPic, Trans( if( lNeto, nTotNet, nTotAlb ), cPorDiv ), if( lNeto, nTotNet, nTotAlb ) ) )

//--------------------------------------------------------------------------//

/*
Devuelve la comisi¢n de un agente en una linea de detalle
*/

FUNCTION nComLAlbCli( cAlbCliT, cAlbCliL, nDecOut, nDerOut )

   local nImp  := nImpLAlbCli( cAlbCliT, cAlbCliL, nDecOut, nDerOut, , .f., .t., .f., .f. )

RETURN ( Round( ( nImp * ( cAlbCliL )->nComAge / 100 ), nDerOut ) )

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
      if lIva  // lo quermos con impuestos
         if !lIvaInc
            nCalculo += Round( nCalculo * nIva / 100, nDec )
         end if
      else     // lo queremos sin impuestos
         if lIvaInc
            nCalculo -= Round( nCalculo / ( 100 / nIva  + 1 ), nDec )
         end if
      end if
   end if

RETURN ( if( cPouDiv != nil, Trans( nCalculo, cPouDiv ), nCalculo ) )

//---------------------------------------------------------------------------//

FUNCTION nImpLAlbCli( uAlbCliT, uAlbCliL, nDec, nRou, nVdv, lIva, lDto, lImpTrn, lPntVer, cPouDiv )

   local lIvaInc
   local nCalculo

   DEFAULT nDec      := 0
   DEFAULT nRou      := 0
   DEFAULT nVdv      := 1
   DEFAULT lIva      := .f.
   DEFAULT lDto      := .t.
   DEFAULT lPntVer   := .f.
   DEFAULT lImpTrn   := .f.

   nCalculo          := nTotLAlbCli( uAlbCliL, nDec, nRou, nVdv, .t., lImpTrn, lPntVer )

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

   if ( uAlbCliL )->nIva != 0
      if lIva  // lo quermos con impuestos
         if !lIvaInc
            nCalculo += Round( nCalculo * ( uAlbCliL )->nIva / 100, nRou )
         end if
      else     // lo queremos sin impuestos
         if lIvaInc
            nCalculo -= Round( nCalculo / ( 100 / ( uAlbCliL )->nIva  + 1 ), nRou )
         end if
      end if
   end if

RETURN ( if( cPouDiv != nil, Trans( nCalculo, cPouDiv ), nCalculo ) )

//---------------------------------------------------------------------------//

FUNCTION nPesLAlbCli( cAlbCliL )

   local nCalculo

   DEFAULT cAlbCliL  := D():Get( "AlbCliL", nView )

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

   DEFAULT dbfLin    := D():Get( "AlbCliL", nView )
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

   DEFAULT dbfLin    := D():Get( "AlbCliL", nView )
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

FUNCTION nTrnUAlbCli( dbfLin, nDec, nVdv )

   local nCalculo

   DEFAULT nDec   := 0
   DEFAULT nVdv   := 1

   nCalculo       := ( dbfLin )->nImpTrn

   IF nVdv != 0
      nCalculo    := nCalculo / nVdv
   END IF

RETURN ( Round( nCalculo, nDec ) )

//---------------------------------------------------------------------------//

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

   DEFAULT cAlbCliP     := D():Get( "AlbCliP", nView )
   DEFAULT cDiv         := D():Get( "Divisas", nView )
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
      nTotPag           := nCnv2Div( nTotPag, cCodDiv, cDivRet )
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

   DEFAULT uAlbCliP  := D():Get( "AlbCliP", nView )
   DEFAULT cDbfDiv   := D():Get( "Divisas", nView )
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
      nTotRec        := nCnv2Div( nTotRec, cDivPgo, cDivRet )
   end if

RETURN if( lPic, Trans( nTotRec, cPorDiv ), nTotRec )

//---------------------------------------------------------------------------//

FUNCTION nDtoUAlbCli( dbfLin, nDec, nVdv )

   local nCalculo := ( dbfLin )->nDtoDiv

   DEFAULT nDec   := 0
   DEFAULT nVdv   := 1

   IF nVdv != 0
      nCalculo    := ( dbfLin )->nDtoDiv / nVdv
   END IF

RETURN ( round( nCalculo, nDec ) )

//---------------------------------------------------------------------------//

function nTotFAlbCli( cAlbCliL, nDec, nRou, nVdv, lDto, lPntVer, lImpTrn, cPouDiv )

   local nCalculo := 0

   nCalculo       += nTotLAlbCli( cAlbCliL, nDec, nRou, nVdv, lDto, lPntVer, lImpTrn, cPouDiv )
   nCalculo       += nIvaLAlbCli( cAlbCliL, nDec, nRou, nVdv, lDto, lPntVer, lImpTrn, cPouDiv )

return ( nCalculo )

//----------------------------------------------------------------------------//

FUNCTION lFacAlbCli( cAlbCli, uAlbCliT )

   local lFacAlb  := .f.

   if ValType( uAlbCliT ) == "C"

      if ( uAlbCliT )->( dbSeek( cAlbCli ) )
         lFacAlb  := lFacturado( uAlbCliT )
      end if

   else

      if uAlbCliT:Seek( cAlbCli )
         lFacAlb  := lFacturado( uAlbCliT )
      end if

   end if

RETURN ( lFacAlb )

//---------------------------------------------------------------------------//

FUNCTION SetFacturadoAlbaranCliente( lFacturado, oBrw, cAlbCliT, cAlbCliL, cAlbCliS, cNumFac )

   local nOrd
   local nRec
   local nRecHead             := ( cAlbCliT )->( Recno() )

   DEFAULT lFacturado         := .f.
   DEFAULT cNumFac            := Space( 12 )
   DEFAULT cAlbCliT           := D():Get( "AlbCliT", nView )
   DEFAULT cAlbCliL           := D():Get( "AlbCliL", nView )
   DEFAULT cAlbCliS           := D():Get( "AlbCliS", nView )

   if oBrw != nil

      for each nRec in ( oBrw:aSelected )

         nRecHead             := nRec

         ( cAlbCliT )->( dbGoTo( nRec ) )

         /*
         Restauramos los datos de cabecera----------------------------------------
         */

         if dbLock( cAlbCliT )
            ( cAlbCliT )->lFacturado := lFacturado
            ( cAlbCliT )->nFacturado := if( lFacturado, 3, 1 )
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
         ( cAlbCliT )->nFacturado := if( lFacturado, 3, 1 )
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

   /*
   Marcamos el albarán para envio-----------------------------------------------
   */

   if dbDialogLock( cAlbCliT )
      ( cAlbCliT )->lSndDoc  := .t.
      ( cAlbCliT )->dFecCre  := Date()
      ( cAlbCliT )->cTimCre  := Time()
      ( cAlbCliT )->( dbUnlock() )
   end if

   if oBrw != nil
      oBrw:Refresh()
      oBrw:SetFocus()
   end if

RETURN NIL

//---------------------------------------------------------------------------//

Function nTotDtoLAlbCli( dbfLin, nDec, nVdv, cPorDiv )

   local nCalculo

   DEFAULT dbfLin    := D():Get( "AlbCliL", nView )
   DEFAULT nDec      := nDouDiv()
   DEFAULT nVdv      := 1

   nCalculo          := nDtoLAlbCli( dbfLin, nDec, nVdv ) * nTotNAlbCli( dbfLin )

   if nVdv != 0
      nCalculo       := nCalculo / nVdv
   end if

   nCalculo          := Round( nCalculo, nDec )

RETURN ( if( cPorDiv != nil, Trans( nCalculo, cPorDiv ), nCalculo ) )

//----------------------------------------------------------------------------//

Function dJuliano4AlbCli( cAlbCliL )

   local cPrefijo
   local cLote

   DEFAULT cAlbCliL  := D():Get( "AlbCliL", nView )

   cLote             := ( cAlbCliL )->cLote

   cPrefijo          := Substr( ( cAlbCliL )->cLote, 1, 1 )

   if Val( cPrefijo ) == 0
      cLote          := Substr( ( cAlbCliL )->cLote, 2 )
   end if

RETURN ( AddMonth( JulianoToDate( Year( ( cAlbCliL )->dFecAlb ), Val( cLote ) ), 4 ) )

//---------------------------------------------------------------------------//

Function dJulianoAlbCli( cAlbCliL )

   local cPrefijo
   local cLote

   DEFAULT cAlbCliL  := D():Get( "AlbCliL", nView )

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

   DEFAULT cAlbCliL  := D():Get( "AlbCliL", nView )

   cLote             := ( cAlbCliL )->cLote

   cPrefijo          := Substr( ( cAlbCliL )->cLote, 1, 1 )

   if Val( cPrefijo ) == 0
      cLote          := Substr( ( cAlbCliL )->cLote, 2 )
   end if

RETURN ( AddMonth( JulianoToDate( Year( ( cAlbCliL )->dFecAlb ), Val( cLote ) ), 8 ) )

//---------------------------------------------------------------------------//

Function cDireccionSAT()

   local dbfObras
   local cDireccion  := ""

   USE ( cPatEmp() + "ObrasT.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "Obras", @dbfObras ) )
   SET ADSINDEX TO ( cPatEmp() + "ObrasT.Cdx" ) ADDITIVE

   if ( dbfObras )->( dbSeek( ( dbfAlbCliT )->cCodCli + ( dbfAlbCliT )->cCodObr ) )
      cDireccion     := ( dbfObras )->cNomObr
   end if

   CLOSE ( dbfObras )

Return ( cDireccion )

//---------------------------------------------------------------------------//

function lFacturado( cAlbCliT )

   local lReturn  := .f.

   do case
      case ValType( cAlbCliT ) == "A"

         lReturn  := cAlbCliT[ _NFACTURADO ] == 3

      case ValType( cAlbCliT ) == "C"         

         lReturn  := ( cAlbCliT )->nFacturado == 3

      case ValType( cAlbCliT ) == "O"         

         lReturn  := cAlbCliT:nFacturado == 3   

   end case

Return ( lReturn )

//---------------------------------------------------------------------------//

FUNCTION nTotalLineaAlbaranCliente( hHash, nDec, nRou, nVdv, lDto, lPntVer, lImpTrn, cPouDiv )

   local nCalculo

   DEFAULT nDec      := nDouDiv()
   DEFAULT nRou      := nRouDiv()
   DEFAULT nVdv      := 1
   DEFAULT lDto      := .t.
   DEFAULT lPntVer   := .t.
   DEFAULT lImpTrn   := .t.

   if hGet( hHash, "LineaTotal" )

      nCalculo       := nTotUAlbCli( hHash )

   else

      /*
      Tomamos los valores redondeados------------------------------------------
      */

      nCalculo       := nTotUAlbCli( hHash )

      /*
      Descuentos---------------------------------------------------------------
      */

      if lDto

         nCalculo    -= Round( hGet( hHash, "DescuentoLineal" ) , nDec )

         if hGet( hHash, "DescuentoPorcentual" ) != 0
            nCalculo -= nCalculo * hGet( hHash, "DescuentoPorcentual" ) / 100
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

      nCalculo       *= nTotNAlbCli( hHash )

      /*
      Redondeo-----------------------------------------------------------------
      */

      if nRou != nil
         nCalculo    := Round( nCalculo, nRou )
      end if

   end if

RETURN ( if( cPouDiv != nil, Trans( nCalculo, cPouDiv ), nCalculo ) )

//---------------------------------------------------------------------------//

Static Function cFormatoAlbaranesClientes( cSerie )

   local cFormato

   DEFAULT cSerie    := ( D():AlbaranesClientes( nView ) )->cSerAlb

   cFormato          := cFormatoDocumento( cSerie, "nAlbCli", D():Contadores( nView ) )

   if empty( cFormato )
      cFormato       := cFirstDoc( "AC", D():Documentos( nView ) )
   end if

Return ( cFormato ) 

//---------------------------------------------------------------------------// 

Static Function changeFieldLine( oCol, uNewValue, nKey, aTmp, cFieldToChange )

   DEFAULT cFieldToChange           := "nPreUnit"

   if isNum( nKey ) .and. ( nKey != VK_ESCAPE ) .and. !isNil( uNewValue )

      ( dbfTmpLin )->( fieldput( fieldpos( cFieldToChange ), uNewValue ) )

      recalculaTotal( aTmp )

   end if

Return .t.  

//---------------------------------------------------------------------------//

Function nSaldoAnteriorAlbCli4( cNumDoc )

   DEFAULT cNumDoc := ( D():AlbaranesClientes( nView ) )->cSerAlb + Str( ( D():AlbaranesClientes( nView ) )->nNumAlb ) + ( D():AlbaranesClientes( nView ) )->cSufAlb

Return oStock:nSaldoAntAlb( Padr( "4", 18 ), cNumDoc ) 

//---------------------------------------------------------------------------//

Function nSaldoAnteriorAlbCli8( cNumDoc )

   DEFAULT cNumDoc := ( D():AlbaranesClientes( nView ) )->cSerAlb + Str( ( D():AlbaranesClientes( nView ) )->nNumAlb ) + ( D():AlbaranesClientes( nView ) )->cSufAlb

Return oStock:nSaldoAntAlb( Padr( "8", 18 ), cNumDoc )

//---------------------------------------------------------------------------//

Function nSaldoAnteriorAlbCli16( cNumDoc )

   DEFAULT cNumDoc := ( D():AlbaranesClientes( nView ) )->cSerAlb + Str( ( D():AlbaranesClientes( nView ) )->nNumAlb ) + ( D():AlbaranesClientes( nView ) )->cSufAlb

Return oStock:nSaldoAntAlb( Padr( "16", 18 ), cNumDoc )

//---------------------------------------------------------------------------//

Function nSaldoDocumentoAlbCli4( cNumDoc )

   DEFAULT cNumDoc := ( D():AlbaranesClientes( nView ) )->cSerAlb + Str( ( D():AlbaranesClientes( nView ) )->nNumAlb ) + ( D():AlbaranesClientes( nView ) )->cSufAlb

Return oStock:nSaldoDocAlb( Padr("4", 18 ), cNumDoc)

//---------------------------------------------------------------------------//

Function nSaldoDocumentoAlbCli8( cNumDoc )

   DEFAULT cNumDoc := ( D():AlbaranesClientes( nView ) )->cSerAlb + Str( ( D():AlbaranesClientes( nView ) )->nNumAlb ) + ( D():AlbaranesClientes( nView ) )->cSufAlb
   
Return oStock:nSaldoDocAlb( Padr("8", 18 ), cNumDoc)

//---------------------------------------------------------------------------//

Function nSaldoDocumentoAlbCli16( cNumDoc )

   DEFAULT cNumDoc := ( D():AlbaranesClientes( nView ) )->cSerAlb + Str( ( D():AlbaranesClientes( nView ) )->nNumAlb ) + ( D():AlbaranesClientes( nView ) )->cSufAlb
   
Return oStock:nSaldoDocAlb( Padr("16", 18 ), cNumDoc )

//---------------------------------------------------------------------------//

Function nTotalSaldoAlbCli4( cCodCli, dFecAlb )

   DEFAULT cCodCli  := ( D():AlbaranesClientes( nView ) )->cCodCli
   DEFAULT dFecAlb  := ( D():AlbaranesClientes( nView ) )->dFecAlb
   
Return oStock:nTotalSaldo( Padr("4", 18 ), cCodCli, dFecAlb )

//---------------------------------------------------------------------------//

Function nTotalSaldoAlbCli8( cCodCli, dFecAlb )

   DEFAULT cCodCli  := ( D():AlbaranesClientes( nView ) )->cCodCli
   DEFAULT dFecAlb  := ( D():AlbaranesClientes( nView ) )->dFecAlb
   
Return oStock:nTotalSaldo( Padr("8", 18 ), cCodCli, dFecAlb ) 

//---------------------------------------------------------------------------//

Function nTotalSaldoAlbCli16( cCodCli, dFecAlb )

   DEFAULT cCodCli  := ( D():AlbaranesClientes( nView ) )->cCodCli
   DEFAULT dFecAlb  := ( D():AlbaranesClientes( nView ) )->dFecAlb
   
Return oStock:nTotalSaldo( Padr("16", 18 ), cCodCli, dFecAlb )

//---------------------------------------------------------------------------//

Function DesignLabelAlbaranClientes( oFr, cDoc )

   local oLabel
   local lOpenFiles  := empty( nView ) 

   if lOpenFiles .and. !Openfiles()
      Return .f.
   endif

   oLabel            := TLabelGeneratorAlbaranClientes():New( nView )

   // Zona de datos---------------------------------------------------------
   
   oLabel:createTempLabelReport()
   oLabel:loadTempLabelReport()      
   oLabel:dataLabel( oFr )

   // Paginas y bandas------------------------------------------------------

   if !empty( ( cDoc )->mReport )
      oFr:LoadFromBlob( ( cDoc )->( Select() ), "mReport")
   else
      oFr:AddPage(         "MainPage" )
      oFr:AddBand(         "MasterData",  "MainPage",       frxMasterData )
      oFr:SetProperty(     "MasterData",  "Top",            200 )
      oFr:SetProperty(     "MasterData",  "Height",         100 )
      oFr:SetObjProperty(  "MasterData",  "DataSet",        "Lineas de albaranes" )
   end if

   oFr:DesignReport()
   oFr:DestroyFr()

   oLabel:DestroyTempReport()
   oLabel:End()

   if lOpenFiles
      closeFiles()
   end if 

Return .t.

//--------------------------------------------------------------------------//

Function getExtraFieldAlbaranCliente( cFieldName )

Return ( getExtraField( cFieldName, oDetCamposExtra, D():AlbaranesClientesId( nView ) ) )

//---------------------------------------------------------------------------//

Static Function lChangeRegIva( aTmp )

   lImpuestos     := ( aTmp[ _NREGIVA ] <= 1 )

   if !empty( oImpuestos )
      oImpuestos:Refresh()
   end if

return ( .t. )

//---------------------------------------------------------------------------//

Function nombrePrimeraPropiedadAlbaranesClientesLineas()

Return ( nombrePropiedad( ( D():AlbaranesClientesLineas( nView ) )->cCodPr1, ( D():AlbaranesClientesLineas( nView ) )->cValPr1, nView ) )

//---------------------------------------------------------------------------//

Function nombreSegundaPropiedadAlbaranesClientesLineas()

Return ( nombrePropiedad( ( D():AlbaranesClientesLineas( nView ) )->cCodPr2, ( D():AlbaranesClientesLineas( nView ) )->cValPr2, nView ) )

//---------------------------------------------------------------------------//

Function EnvaseArticuloAlbaranesClientesLineas( cCodCli, cCodArt )

   local nRec     := ( D():Atipicas( nView ) )->( Recno() )
   local nOrdAnt  := ( D():Atipicas( nView ) )->( OrdSetFocus( "cCliArt" ) )
   local cCodEnv  := ""

   if ( D():Atipicas( nView ) )->( dbSeek( Padr( cCodCli, 12 ) + Padr( cCodArt, 18 ) + Space( 80 ) ) ) .and. !Empty( ( D():Atipicas( nView ) )->cCodEnv )
      cCodEnv  := ( D():Atipicas( nView ) )->cCodEnv
   else
      cCodEnv  := RetFld( Padr( cCodArt, 18 ), D():Articulos( nView ), "cCodFra", "Codigo" )                    
   end if

   ( D():Atipicas( nView ) )->( OrdSetFocus( nOrdAnt ) )
   ( D():Atipicas( nView ) )->( dbGoTo( nRec ) )
   
Return ( cCodEnv )

//---------------------------------------------------------------------------//

Static Function importarLineasPedidosClientes( aTmp, aGet, oBrwLin )

   local oLine
   local cCodigoCliente
   local cNombreCliente
   local oConversionPedidosClientes

   cCodigoCliente                 := aGet[ _CCODCLI ]:varGet()
   cNombreCliente                 := aGet[ _CNOMCLI ]:varGet() 

   if empty( cCodigoCliente )
      msgStop( "Es necesario codificar un cliente.", "Importar pedidos" )
      return .t.
   end if

   oConversionPedidosClientes    := TConversionPedidosClientes():New( nView, oStock )

   if empty( oConversionPedidosClientes )
      Return .f.
   end if 

   oConversionPedidosClientes:setCodigoCliente( cCodigoCliente ) 
   
   oConversionPedidosClientes:setTitle( "Importando pedidos de " + alltrim( cCodigoCliente ) + " - " + alltrim( cNombreCliente ) )
   
   if oConversionPedidosClientes:Dialog()
      appendLineasPedidosCliente( oConversionPedidosClientes:oDocumentLines:aLines, oBrwLin )
   end if 

   recalculaTotal( aTmp )

   oBrwLin:refresh()

Return .t.

//---------------------------------------------------------------------------//

Static Function appendLineasPedidosCliente( aLines )

   local oLine

   for each oLine in aLines

      if oLine:isSelectLine()

         oLine:setValue( "NumeroLinea",         nLastNum( dbfTmpLin ) )
         oLine:setValue( "PosicionImpresion",   nLastNum( dbfTmpLin, "nPosPrint" ) )
         
         D():appendHashRecordInWorkarea( oLine:hDictionary, "AlbCliL", dbfTmpLin )

         if aScan( aNumPed, oLine:getvalue( "NumeroPedido" ) ) == 0
            aAdd( aNumPed, oLine:getvalue( "NumeroPedido" ) )
         end if      

      end if 

   next 

Return .t.

//---------------------------------------------------------------------------//

Static Function importarArticulosScaner()

   local memoArticulos

   memoArticulos  := dialogArticulosScaner()
   
   if memoArticulos != nil
      msgstop( memoArticulos, "procesar")
   end if

Return nil       

//---------------------------------------------------------------------------//

static Function menuEdtDet( oCodArt, oDlg, lOferta, nIdLin )

   DEFAULT lOferta      := .f.

   MENU oDetMenu

      MENUITEM    "&1. Rotor  " ;
         RESOURCE "Rotor16"

         MENU

            MENUITEM    "&1. Campos extra [F9]";
               MESSAGE  "Mostramos y rellenamos los campos extra" ;
               RESOURCE "GC_FORM_PLUS2_16" ;
               ACTION   ( oLinDetCamposExtra:Play( nIdLin ) )

            MENUITEM    "&2. Modificar artículo";
               MESSAGE  "Modificar la ficha del artículo" ;
               RESOURCE "gc_object_cube_16";
               ACTION   ( EdtArticulo( oCodArt:VarGet() ) );

            MENUITEM    "&3. Informe de artículo";
               MESSAGE  "Abrir el informe del artículo" ;
               RESOURCE "Info16";
               ACTION   ( if( oUser():lNotCostos(), msgStop( "No tiene permiso para ver los precios de costo" ), InfArticulo( oCodArt:VarGet() ) ) );

         ENDMENU

   ENDMENU

   oDlg:SetMenu( oDetMenu )

Return ( oDetMenu )

//---------------------------------------------------------------------------//

Static Function stringExport( dbfTmpLin )
   
   local stringExport   := alltrim( ( dbfTmpLin )->cRef ) + "," 
   stringExport         += alltrim( strtran( trans( nTotNAlbCli( dbfTmpLin ), cPicUnd ), ",", "." ) ) + ","
   stringExport         += alltrim( ( dbfTmpLin )->cCodPr1 ) + "," 
   stringExport         += alltrim( ( dbfTmpLin )->cValPr1 ) + "," 
   stringExport         += alltrim( ( dbfTmpLin )->cCodPr2 ) + "," 
   stringExport         += alltrim( ( dbfTmpLin )->cValPr2 ) + CRLF

Return ( stringExport )

//---------------------------------------------------------------------------//
