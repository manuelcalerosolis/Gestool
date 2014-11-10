#include "FiveWin.Ch" 
#include "Folder.ch"
#include "Report.ch"
#include "Menu.ch"
#include "Xbrowse.ch"
#include "Factu.ch"

#define CLR_BAR                   14197607
#define _MENUITEM_                "01057"

#define impuestos_DESG            1
#define impuestos_INCL            2

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
#define _dLFACTURADO              90      //   L      1     0
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
#define __NFACTURADO             101

/*
Definici¢n de Array para impuestos
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
Definici¢n de Array para objetos impuestos
*/

static oWndBrw
static oBrwIva
static nView
static dbfUsr
static dbfProSer
static dbfMatSer
static dbfAlbPrvL
static dbfAlbPrvS
static dbfTmpLin
static dbfTmpInc
static dbfTmpDoc
static dbfTmpPgo
static dbfTmpSer
static dbfDelega
static cTmpLin
static cTmpInc
static cTmpDoc
static cTmpPgo
static cTmpSer
static dbfInci
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
static dbfSatCliT
static dbfSatCliL
static dbfSatCliI
static dbfSatCliD
static dbfSatCliS
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
static oTrans
static oNewImp
static oUndMedicion
static oBandera
static dbfKit
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
static oPais

static oBtnKit
static oBtnAtp

static oBtnPre
static oBtnSat
static oBtnPed
static oBtnAgruparPedido
static oBtnAgruparSAT

static oRieCli
static nRieCli

static oTlfCli
static cTlfCli

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
static cOldLotArt       := ""
static dOldFecCad       := cToD( "" )
static cOldUndMed       := ""
static lOpenFiles       := .f.
static lExternal        := .f.
static aTipAlb          := { "Venta", "Alquiler" }
static oTipAlb
static cFiltroUsuario   := ""
static oTotAlbLin

static oBrwLin
static oBrwInc
static oBrwDoc

static aPedidos         := {}
static aSats            := {}

static bEdtRec          := { | aTmp, aGet, dbf, oBrw, bWhen, bValid, nMode, hHash | EdtRec( aTmp, aGet, dbf, oBrw, bWhen, bValid, nMode, hHash ) }
static bEdtDet          := { | aTmp, aGet, dbf, oBrw, bWhen, bValid, nMode, aTmpAlb | EdtDet( aTmp, aGet, dbf, oBrw, bWhen, bValid, nMode, aTmpAlb ) }
static bEdtInc          := { | aTmp, aGet, dbf, oBrw, bWhen, bValid, nMode, aTmpLin | EdtInc( aTmp, aGet, dbf, oBrw, bWhen, bValid, nMode, aTmpLin ) }
static bEdtDoc          := { | aTmp, aGet, dbf, oBrw, bWhen, bValid, nMode, aTmpLin | EdtDoc( aTmp, aGet, dbf, oBrw, bWhen, bValid, nMode, aTmpLin ) }
static bEdtPgo          := { | aTmp, aGet, dbf, oBrw, bWhen, bValid, nMode, aTmpAlb | EdtEnt( aTmp, aGet, dbf, oBrw, bWhen, bValid, nMode, aTmpAlb ) }

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

   nLevel               := nLevelUsr( oMenuItem )
   if nAnd( nLevel, 1 ) != 0
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
               "Dirección",;
               "Agente",;
               "Su albarán";
      MRU      "Document_plain_user1_16";
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
         :SetCheck( { "Sel16", "Nil16" } )
         :AddResource( "Zoom16" )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Facturado"
         :nHeadBmpNo       := 4
         :bStrData         := {|| "" }
         :bBmpData         := {|| ( D():Get( "AlbCliT", nView ) )->nFacturado }
         :nWidth           := 20
         :AddResource( "Bullet_Square_Red_16" )
         :AddResource( "Bullet_Square_Yellow_16" )
         :AddResource( "Bullet_Square_Green_16" )
         :AddResource( "trafficlight_on_16" )
      end with

      /*with object ( oWndBrw:AddXCol() )
         :cHeader          := "Facturado"
         :nHeadBmpNo       := 3
         :cSortOrder       := "lFacturado"
         :bStrData         := {|| "" }
         :bEditValue       := {|| ( D():Get( "AlbCliT", nView ) )->lFacturado }
         :nWidth           := 20
         :SetCheck( { "Bullet_Square_Green_16", "Bullet_Square_Red_16" } )
         :AddResource( "trafficlight_on_16" )
      end with*/

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Envio"
         :nHeadBmpNo       := 3
         :bStrData         := {|| "" }
         :bEditValue       := {|| ( D():Get( "AlbCliT", nView ) )->lSndDoc }
         :nWidth           := 20
         :SetCheck( { "Sel16", "Nil16" } )
         :AddResource( "Lbl16" )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Entregado"
         :nHeadBmpNo       := 3
         :bStrData         := {|| "" }
         :bEditValue       := {|| ( D():Get( "AlbCliT", nView ) )->lEntregado }
         :nWidth           := 20
         :SetCheck( { "Sel16", "Nil16" } )
         :AddResource( "hand_paper_16" )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Incidencia"
         :nHeadBmpNo       := 4
         :bStrData         := {|| "" }
         :bBmpData         := {|| nEstadoIncidencia( ( D():Get( "AlbCliT", nView ) )->cSerAlb + Str( ( D():Get( "AlbCliT", nView ) )->nNumAlb ) + ( D():Get( "AlbCliT", nView ) )->cSufAlb ) }
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
         :bEditValue       := {|| ( D():Get( "AlbCliT", nView ) )->lImprimido }
         :nWidth           := 20
         :lHide            := .t.
         :SetCheck( { "Sel16", "Nil16" } )
         :AddResource( "IMP16" )
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
         :cSortOrder       := "dFecAlb"
         :bEditValue       := {|| Dtoc( ( D():Get( "AlbCliT", nView ) )->dFecAlb ) }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
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

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Transportista"
         :bEditValue       := {|| ( D():Get( "AlbCliT", nView ) )->cCodTrn }
         :nWidth           := 60
         :lHide            := .t.
         :nEditType        := 5
         :bOnPostEdit      := {|oCol, uNewValue, nKey| ChangeTrasportista( oCol, uNewValue, nKey ) }
         :bEditBlock       := {|| oTrans:Buscar( ( D():Get( "AlbCliT", nView ) )->cCodTrn ) }
         :nBtnBmp          := 1
         :AddResource( "Lupa" )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Nombre transportista"
         :bEditValue       := {|| oTrans:GetField( ( D():Get( "AlbCliT", nView ) )->cCodTrn, "cNomTrn" ) }
         :nWidth           := 180
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
      ACTION   ( GenAlbCli( IS_PRINTER ), oWndBrw:Refresh() ) ;
      TOOLTIP  "(I)mprimir";
      HOTKEY   "I";
      LEVEL    ACC_IMPR

      lGenAlbCli( oWndBrw:oBrw, oImp, IS_PRINTER ) ;

   DEFINE BTNSHELL RESOURCE "SERIE1" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( ImprimirSeriesAlbaranes() ) ;
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

   DEFINE BTNSHELL RESOURCE "Document_Chart_" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( TFastVentasArticulos():New():Play( ALB_CLI ) ) ;
      TOOLTIP  "Rep(o)rting";
      HOTKEY   "O" ;
      LEVEL    ACC_IMPR

   DEFINE BTNSHELL RESOURCE "Money2_" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( If( !lFacturado( D():Get( "AlbCliT", nView ) ), WinAppRec( oWndBrw:oBrw, bEdtPgo, D():Get( "AlbCliP", nView ) ), MsgStop( "El albarán ya fue facturado." ) ) );
      TOOLTIP  "Entregas a (c)uenta" ;
      HOTKEY   "C";
      LEVEL    ACC_APPD

   if oUser():lAdministrador()

      DEFINE BTNSHELL RESOURCE "GENFAC" GROUP OF oWndBrw ;
         NOBORDER ;
         ACTION   ( GenFCli( oWndBrw:oBrw, D():Get( "AlbCliT", nView ), D():Get( "AlbCliL", nView ), D():Get( "AlbCliP", nView ), D():Get( "AlbCliS", nView ), D():Get( "Client", nView ), D():Atipicas( nView ), D():Get( "TIva", nView ), D():Get( "Divisas", nView ), D():Get( "FPago", nView ), dbfUsr, D():Get( "NCount", nView ), D():GruposClientes( nView ), oStock ) );
         TOOLTIP  "(G)enerar facturas";
         HOTKEY   "G";
         LEVEL    ACC_APPD

      DEFINE BTNSHELL RESOURCE "CHGSTATE" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( if( ApoloMsgNoYes(  "¿ Está seguro de cambiar el estado del documento ?", "Elija una opción" ), SetFacturadoAlbaranCliente( !lFacturado( D():Get( "AlbCliT", nView ) ), oWndBrw:oBrw ), ) ) ;
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

   DEFINE BTNSHELL oBtnEur RESOURCE "BAL_EURO" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( lEuro := !lEuro, oWndBrw:Refresh() ) ;
      TOOLTIP  "M(o)neda";
      HOTKEY   "O"

   if oUser():lAdministrador()

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

   DEFINE BTNSHELL oScript RESOURCE "Folder_document_" GROUP OF oWndBrw ;
      NOBORDER ;
      ACTION   ( oScript:Expand() ) ;
      TOOLTIP  "Scripts" ;

      ImportScript( oWndBrw, oScript, "AlbaranesClientes" )  

   DEFINE BTNSHELL oRotor RESOURCE "ROTOR" GROUP OF oWndBrw ;
      NOBORDER ;
      ACTION   ( oRotor:Expand() ) ;
      TOOLTIP  "Rotor" ;

      DEFINE BTNSHELL RESOURCE "USER1_" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( EdtCli( ( D():Get( "AlbCliT", nView ) )->cCodCli ) );
         TOOLTIP  "Modificar cliente" ;
         FROM     oRotor ;

      DEFINE BTNSHELL RESOURCE "INFO" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( InfCliente( ( D():Get( "AlbCliT", nView ) )->cCodCli ) );
         TOOLTIP  "Informe de cliente" ;
         FROM     oRotor ;

      DEFINE BTNSHELL RESOURCE "WORKER" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( EdtObras( ( D():Get( "AlbCliT", nView ) )->cCodCli, ( D():Get( "AlbCliT", nView ) )->cCodObr, dbfObrasT ) );
         TOOLTIP  "Modificar dirección" ;
         FROM     oRotor ;

      DEFINE BTNSHELL RESOURCE "CLIPBOARD_EMPTY_USER1_" OF oWndBrw ;
         ACTION   ( if( !Empty( ( D():Get( "AlbCliT", nView ) )->cNumPed ), ZooPedCli( ( D():Get( "AlbCliT", nView ) )->cNumPed ), MsgStop( "El albarán no procede de un pedido" ) ) );
         TOOLTIP  "Visualizar pedido" ;
         FROM     oRotor ;

      DEFINE BTNSHELL RESOURCE "DOCUMENT_USER1_" OF oWndBrw ;
         ALLOW    EXIT ;
         ACTION   ( if( !lFacturado( D():Get( "AlbCliT", nView ) ), FactCli( nil, nil, { "Albaran" => ( D():Get( "AlbCliT", nView ) )->cSerAlb + Str( ( D():Get( "AlbCliT", nView ) )->nNumAlb ) + ( D():Get( "AlbCliT", nView ) )->cSufAlb } ), MsgStop( "Albarán facturado" ) ) );
         TOOLTIP  "Generar factura" ;
         FROM     oRotor ;

      DEFINE BTNSHELL RESOURCE "DOCUMENT_USER1_" OF oWndBrw ;
         ACTION   ( if( !Empty( ( D():Get( "AlbCliT", nView ) )->cNumFac ), EdtFacCli( ( D():Get( "AlbCliT", nView ) )->cNumFac ), msgStop( "No hay factura asociada" ) ) );
         TOOLTIP  "Modificar factura" ;
         FROM     oRotor ;

      DEFINE BTNSHELL RESOURCE "DOCUMENT_MONEY2_" OF oWndBrw ;
         ALLOW    EXIT ;
         ACTION   ( if( !lFacturado( D():Get( "AlbCliT", nView ) ), FacAntCli( nil, nil, ( D():Get( "AlbCliT", nView ) )->cCodCli ), msgStop( "Albarán ya facturado" ) ) );
         TOOLTIP  "Generar anticipo" ;
         FROM     oRotor ;

      DEFINE BTNSHELL RESOURCE "Note_" OF oWndBrw ;
         ALLOW    EXIT ;
         ACTION   ( AlbCliNotas() );
         TOOLTIP  "Generar nota de agenda" ;
         FROM     oRotor ;

      DEFINE BTNSHELL RESOURCE "CASHIER_USER1_" OF oWndBrw ;
         ALLOW    EXIT ;
         ACTION   ( if( !lFacturado( D():Get( "AlbCliT", nView ) ) .and. Empty( ( D():Get( "AlbCliT", nView ) )->cNumTik ), FrontTpv( nil, nil, nil, nil, .f., .f., { nil, nil, ( D():Get( "AlbCliT", nView ) )->cSerAlb + Str( ( D():Get( "AlbCliT", nView ) )->nNumAlb ) + ( D():Get( "AlbCliT", nView ) )->cSufAlb } ), MsgStop( "Albarán facturado o convertido a ticket" ) ) );
         TOOLTIP  "Convertir a ticket" ;
         FROM     oRotor ;

      DEFINE BTNSHELL RESOURCE "CASHIER_USER1_" OF oWndBrw ;
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

   if !oUser():lFiltroVentas()
      oWndBrw:oActiveFilter:SetFields( aItmAlbCli() )
      oWndBrw:oActiveFilter:SetFilterType( ALB_CLI )
   end if

   ACTIVATE WINDOW oWndBrw VALID ( CloseFiles() )

   EnableAcceso()

   if !Empty( hHash ) 

      if !Empty( oWndBrw )
         oWndBrw:RecAdd()
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

      D():GruposClientes( nView )

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

      USE ( cPatEmp() + "SatCliL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "SatCliL", @dbfSatCliL ) )
      SET ADSINDEX TO ( cPatEmp() + "SatCliL.CDX" ) ADDITIVE

      USE ( cPatEmp() + "SatCliI.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "SatCliI", @dbfSatCliI ) )
      SET ADSINDEX TO ( cPatEmp() + "SatCliI.CDX" ) ADDITIVE

      USE ( cPatEmp() + "SatCliD.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "SatCliD", @dbfSatCliD ) )
      SET ADSINDEX TO ( cPatEmp() + "SatCliD.CDX" ) ADDITIVE

      USE ( cPatEmp() + "SatCliS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "SatCliS", @dbfSatCliS ) )
      SET ADSINDEX TO ( cPatEmp() + "SatCliS.CDX" ) ADDITIVE

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

      USE ( cPatCli() + "CliBnc.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CLIBNC", @dbfCliBnc ) )
      SET ADSINDEX TO ( cPatCli() + "CliBnc.Cdx" ) ADDITIVE

      USE ( cPatArt() + "PROVART.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PROVART", @dbfArtPrv ) )
      SET ADSINDEX TO ( cPatArt() + "PROVART.CDX" ) ADDITIVE

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

      USE ( cPatArt() + "ArtCodebar.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CODEBAR", @dbfCodebar ) )
      SET ADSINDEX TO ( cPatArt() + "ArtCodebar.Cdx" ) ADDITIVE

      USE ( cPatArt() + "FAMILIAS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FAMILIAS", @dbfFamilia ) )
      SET ADSINDEX TO ( cPatArt() + "FAMILIAS.CDX" ) ADDITIVE

      USE ( cPatArt() + "ARTKIT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ARTTIK", @dbfKit ) )
      SET ADSINDEX TO ( cPatArt() + "ARTKIT.CDX" ) ADDITIVE

      USE ( cPatDat() + "TVTA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TVTA", @dbfTVta ) )
      SET ADSINDEX TO ( cPatDat() + "TVTA.CDX" ) ADDITIVE

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

      USE ( cPatDat() + "DELEGA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "DELEGA", @dbfDelega ) )
      SET ADSINDEX TO ( cPatDat() + "DELEGA.CDX" ) ADDITIVE
      
      USE ( cPatAlm() + "UBICAL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "UBICAL", @dbfUbicaL ) )
      SET ADSINDEX TO ( cPatAlm() + "UBICAL.CDX" ) ADDITIVE

      USE ( cPatGrp() + "AGECOM.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "AGECOM", @dbfAgeCom ) )
      SET ADSINDEX TO ( cPatGrp() + "AGECOM.CDX" ) ADDITIVE

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

      if !TDataCenter():OpenSatCliT( @dbfSatCliT )
         lOpenFiles        := .f.
      end if

      if !TDataCenter():OpenPedCliT( @dbfPedCliT )
         lOpenFiles     := .f.
      end if 

      oBandera          := TBandera():New()

      oStock               := TStock():Create( cPatGrp() )
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

      oUndMedicion      := UniMedicion():Create( cPatGrp() )
      if !oUndMedicion:OpenFiles()
         lOpenFiles     := .f.
      end if

      oFraPub           := TFrasesPublicitarias():Create( cPatArt() )
      if !oFraPub:OpenFiles()
         lOpenFiles     := .f.
      end if

      oPais             := TPais():Create( cPatDat() )
      if !oPais:OpenFiles()
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

         ( D():Get( "AlbCliT", nView ) )->( AdsSetAOF( cFiltroUsuario ) )

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

   DestroyFastFilter( D():Get( "AlbCliT", nView ), .t., .t. )

   if !Empty( oFont )
      oFont:end()
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
   if !Empty( dbfTVta )
      ( dbfTVta      )->( dbCloseArea() )
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
   if dbfDelega != nil
      ( dbfDelega )->( dbCloseArea() )
   end if
   if dbfUbicaL != nil
      ( dbfUbicaL )->( dbCloseArea() )
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
   if dbfPedPrvL != nil
      ( dbfPedPrvL )->( dbCloseArea() )
   end if
   if !Empty( dbfCliBnc  )
      ( dbfCliBnc  )->( dbCloseArea() )
   end if

   if !Empty( oStock )
      oStock:end()
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
   if !Empty( oPais )
      oPais:End()
   end if 

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
   dbfFamilia     := nil
   dbfKit         := nil
   dbfTVta        := nil
   oBandera       := nil
   dbfTblCnv      := nil
   dbfOferta      := nil
   dbfObrasT      := nil
   dbfPro         := nil
   dbfTblPro      := nil
   dbfRuta        := nil
   dbfArtDiv      := nil
   dbfCajT        := nil
   dbfUsr         := nil
   dbfInci        := nil
   dbfArtPrv      := nil
   dbfDelega      := nil
   dbfUbicaL      := nil
   dbfAgeCom      := nil
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
   dbfPedPrvL     := nil
   dbfCliBnc      := nil

   oStock         := nil
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

   if ( D():Get( "AlbCliT", nView ) )->( Lastrec() ) == 0
      Return nil
   end if

   cAlbaran             := ( D():Get( "AlbCliT", nView ) )->cSerAlb + Str( ( D():Get( "AlbCliT", nView ) )->nNumAlb ) + ( D():Get( "AlbCliT", nView ) )->cSufAlb

   DEFAULT nDevice      := IS_PRINTER
   DEFAULT cCaption     := "Imprimiendo albaranes a clientes"
   DEFAULT cCodDoc      := cFormatoDocumento( ( D():Get( "AlbCliT", nView ) )->cSerAlb, "nAlbCli", D():Get( "NCount", nView ) )
   //DEFAULT nCopies      := if( nCopiasDocumento( ( D():Get( "AlbCliT", nView ) )->cSerAlb, "nAlbCli", D():Get( "NCount", nView ) ) == 0, Max( Retfld( ( D():Get( "AlbCliT", nView ) )->cCodCli, D():Get( "Client", nView ), "CopiasF" ), 1 ), nCopiasDocumento( ( D():Get( "AlbCliT", nView ) )->cSerAlb, "nAlbCli", D():Get( "NCount", nView ) ) )

   if Empty( nCopies )
      nCopies           := Retfld( ( D():Get( "AlbCliT", nView ) )->cCodCli, D():Get( "Client", nView ), "CopiasF" ) 
   end if

   if nCopies == 0 
      nCopies           := nCopiasDocumento( ( D():Get( "AlbCliT", nView ) )->cSerAlb, "nAlbCli", D():Get( "NCount", nView ) )
   end if 

   if nCopies == 0
      nCopies           := 1
   end if  

   if Empty( cCodDoc )
      cCodDoc           := cFirstDoc( "AC", D():Documentos( nView ) )
   end if

   if !lExisteDocumento( cCodDoc, D():Documentos( nView ) )
      return nil
   end if

   /*
   Si el documento es de tipo visual-------------------------------------------
   */

   if lVisualDocumento( cCodDoc, D():Documentos( nView ) )

      PrintReportAlbCli( nDevice, nCopies, cPrinter, D():Documentos( nView ) )

   else

      /*
      Recalculamos el albaran
      */

      nTotAlbCli( cAlbaran, D():Get( "AlbCliT", nView ), D():Get( "AlbCliL", nView ), D():Get( "TIva", nView ), D():Get( "Divisas", nView ) )
      nPagAlbCli( cAlbaran, D():Get( "AlbCliP", nView ), D():Get( "Divisas", nView ) )

      /*
      Buscamos el primer registro
      */

      ( D():Get( "AlbCliL", nView ) )->( dbSeek( cAlbaran ) )
      ( D():Get( "AlbCliP", nView ) )->( dbSeek( cAlbaran ) )

      /*
      Posicionamos en ficheros auxiliares
      */

      ( D():Get( "Client", nView ))->( dbSeek( ( D():Get( "AlbCliT", nView ) )->cCodCli ) )
      ( D():Get( "FPago", nView ) )->( dbSeek( ( D():Get( "AlbCliT", nView ) )->cCodPago ) )
      ( dbfAgent  )->( dbSeek( ( D():Get( "AlbCliT", nView ) )->cCodAge ) )
      ( dbfObrasT )->( dbSeek( ( D():Get( "AlbCliT", nView ) )->cCodCli + ( D():Get( "AlbCliT", nView ) )->cCodObr ) )
      ( dbfDelega )->( dbSeek( ( D():Get( "AlbCliT", nView ) )->cCodDlg ) )

      oTrans:oDbf:Seek( ( D():Get( "AlbCliT", nView ) )->cCodTrn )

      private oInf
      private cDbf         := D():Get( "AlbCliT", nView )
      private cDbfCol      := D():Get( "AlbCliL", nView )
      private cDbfPag      := D():Get( "AlbCliP", nView )
      private cCliente     := D():Get( "Client", nView )
      private cDbfCli      := D():Get( "Client", nView )
      private cDbfDiv      := D():Get( "Divisas", nView )
      private cIva         := D():Get( "TIva", nView )
      private cDbfIva      := D():Get( "TIva", nView )
      private cFPago       := D():Get( "FPago", nView )
      private cDbfPgo      := D():Get( "FPago", nView )
      private cAgent       := dbfAgent
      private cDbfAge      := dbfAgent
      private cTvta        := dbfTvta
      private cObras       := dbfObrasT
      private cDbfObr      := dbfObrasT
      private cTarPreL     := dbfTarPreL
      private cTarPreS     := dbfTarPreS
      private cDbfRut      := dbfRuta
      private cDbfUsr      := dbfUsr
      private cDbfAnt      := D():Get( "AntCliT", nView )
      private cDbfDlg      := dbfDelega
      private cDbfTrn      := oTrans:GetAlias()
      private cDbfPro      := dbfPro
      private cDbfTblPro   := dbfTblPro

      private nTotPage     := nTotLAlbCli( D():Get( "AlbCliL", nView ) )
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
         oInf:bSkip        := {|| AlbCliReportSkipper( D():Get( "AlbCliL", nView ) ) }

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
            WHILE       ( ( D():Get( "AlbCliL", nView ) )->cSerAlb + Str( ( D():Get( "AlbCliL", nView ) )->nNumAlb ) + ( D():Get( "AlbCliL", nView ) )->cSufAlb == cAlbaran .and. !( D():Get( "AlbCliL", nView ) )->( Eof() ) ) ;
            FOR         ( !( D():Get( "AlbCliL", nView ) )->lImpLin ) ;
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

   lChgImpDoc( D():Get( "AlbCliT", nView ) )

Return nil

//----------------------------------------------------------------------------//

Static Function AlbCliReportSkipper()

   ( D():Get( "AlbCliL", nView ) )->( dbSkip() )

   nTotPage              += nTotLAlbCli( D():Get( "AlbCliL", nView ) )

Return nil

//----------------------------------------------------------------------------//

STATIC FUNCTION EPage( oInf, cCodDoc )

   private nPagina      := oInf:nPage
   private lEnd         := oInf:lFinish
   private nRow         := oInf:nRow

   PrintItems( cCodDoc, oInf )

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
         aTmp[ _NVDVALB   ]   := nChgDiv( aTmp[ _CDIVALB ], D():Get( "Divisas", nView ) )
         aTmp[ _LFACTURADO]   := .f.
         aTmp[ _LSNDDOC   ]   := .t.
         aTmp[ _CSUFALB   ]   := RetSufEmp()
         aTmp[ _CSERALB   ]   := cNewSer( "NALBCLI", D():Get( "NCount", nView ) )
         aTmp[ _DFECENV   ]   := Ctod( "" )
         aTmp[ _DFECIMP   ]   := Ctod( "" )
         aTmp[ _CCODDLG   ]   := oUser():cDelegacion()
         aTmp[ _LIVAINC   ]   := uFieldEmpresa( "lIvaInc" )
         aTmp[ _NIVAMAN   ]   := nIva( D():Get( "TIva", nView ), cDefIva() )
         aTmp[ _CMANOBR   ]   := Padr( "Gastos", 250 )
         aTmp[ _NFACTURADO]   := 1

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
         aTmp[ _NFACTURADO]   := 1

      case nMode == EDIT_MODE

         if aTmp[ _LCLOALB ] .and. !oUser():lAdministrador()
            MsgStop( "El albarán está cerrado." )
            Return .f.
         end if

         if lFacturado( aTmp ) //aTmp[ _LFACTURADO ]
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

   nRieCli                    := oStock:nRiesgo( aTmp[ _CCODCLI ] )

   if Empty( aTmp[ _CTLFCLI ] )
      aTmp[ _CTLFCLI ]        := RetFld( aTmp[ _CCODCLI ], D():Get( "Client", nView ), "Telefono" )
   end if

   nOrd                       := ( D():Get( "AlbCliT", nView ) )->( ordSetFocus( "nNumAlb" ) )

   oFont                      := TFont():New( "Arial", 8, 26, .f., .t. )

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

   DEFINE DIALOG oDlg ;
      RESOURCE    "PEDCLI" ;
      TITLE       LblTitle( nMode ) + "albaranes a clientes"

      REDEFINE FOLDER oFld ;
         ID       200 ;
         OF       oDlg ;
         PROMPT   "Albará&n",;
                  "Da&tos",;
                  "&Incidencias",;
                  "D&ocumentos" ;
         DIALOGS  "ALBCLI_1",;
                  "ALBCLI_2",;
                  "PEDCLI_3",;
                  "PEDCLI_4"

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
         BITMAP   "Environnment_View_16" ;
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
         OF       oFld:aDialogs[1]

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
         VALID    ( cObras( aGet[ _CCODOBR ], oSay[ 6 ], aTmp[ _CCODCLI ], dbfObrasT ) ) ;
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

      REDEFINE GET aGet[ _CCODALM ] VAR aTmp[ _CCODALM ] ;
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
         VALID    ( cAgentes( aGet[_CCODAGE], dbfAgent, oSay[ 4 ], aGet[ _NPCTCOMAGE ], dbfAgeCom ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwAgentes( aGet[_CCODAGE], oSay[ 4 ] ) ) ;
         COLOR    CLR_GET ;
         OF       oFld:aDialogs[1]

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

      oBrwLin:CreateFromResource( 240 )

      with object ( oBrwLin:AddCol() )
         :cHeader             := "Of. Oferta"
         :bStrData            := {|| "" }
         :bEditValue          := {|| ( dbfTmpLin )->lLinOfe }
         :nWidth              := 20
         :SetCheck( { "Star_Red_16", "Nil16" } )
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader             := "Número"
         :cSortOrder          := "nNumLin"
         :bEditValue          := {|| ( dbfTmpLin )->nNumLin }
         :bLClickHeader       := {| nMRow, nMCol, nFlags, oCol | if( !empty( oCol ), oCol:SetOrder(), ) }
         :cEditPicture        := "9999"
         :nWidth              := 65
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
         :nFooterType         := AGGR_SUM
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
         ACTION   ( aGet[ _NDTOESP ]:cText( Val( GetPvProfString( "Descuentos", "Descuento especial", 0, cPatEmp() + "Empresa.Ini" ) ) ), RecalculaTotal( aTmp ) )

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
         ACTION   ( aGet[ _NDPP ]:cText( Val( GetPvProfString( "Descuentos", "Descuento pronto pago", 0, cPatEmp() + "Empresa.Ini" ) ) ), RecalculaTotal( aTmp ) )

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
         ACTION   ( aGet[ _NDTOUNO ]:cText( Val( GetPvProfString( "Descuentos", "Descuento uno", 0, cPatEmp() + "Empresa.Ini" ) ) ), RecalculaTotal( aTmp ) )

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
         ACTION   ( aGet[ _NDTODOS ]:cText( Val( GetPvProfString( "Descuentos", "Descuento dos", 0, cPatEmp() + "Empresa.Ini" ) ) ), RecalculaTotal( aTmp ) )

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
         :bOnPostEdit      := {|o,x| EdtIva( o, x, aTotIva[ oBrwIva:nArrayAt, 3 ], dbfTmpLin, D():Get( "TIva", nView ), oBrwLin ), RecalculaTotal( aTmp ) }
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

      REDEFINE GET oGetRnt VAR nTotRnt ;
         ID       408 ;
         IDTEXT   709 ;
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

      REDEFINE SAY oGetReq VAR nTotReq ;
         ID       407 ;
         OF       oFld:aDialogs[1]

      REDEFINE SAY oGetTotal VAR nTotAlb;
         ID       360 ;
         FONT     oFont ;
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
         ACTION   ( LineUp( dbfTmpLin, oBrwLin ) )

      REDEFINE BUTTON ;
         ID       525 ;
         OF       oFld:aDialogs[1] ;
         WHEN     ( lWhen ) ;
         ACTION   ( LineDown( dbfTmpLin, oBrwLin ) )

      REDEFINE BUTTON oBtnKit;
         ID       526 ;
         OF       oFld:aDialogs[1] ;
         ACTION   ( lEscandalloEdtRec( .t., oBrwLin ) )

      REDEFINE BUTTON oBtnAtp;
         ID       527 ;
         OF       oFld:aDialogs[1] ;
         WHEN     ( lWhen ) ;
         ACTION   ( CargaAtipicasCliente( aTmp, oBrwLin, oDlg ) )

      REDEFINE GET aGet[ _CSERALB ] VAR aTmp[ _CSERALB ] ;
         ID       100 ;
         SPINNER ;
         ON UP    ( UpSerie( aGet[ _CSERALB ] ) );
         ON DOWN  ( DwSerie( aGet[ _CSERALB ] ) );
         PICTURE  "@!" ;
         COLOR    CLR_GET ;
         WHEN     ( nMode == APPD_MODE .OR. nMode == DUPL_MODE );
         VALID    ( aTmp[ _CSERALB ] >= "A" .AND. aTmp[ _CSERALB ] <= "Z"  );
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
         RESOURCE "Notebook_user1_16" ;
         NOBORDER ;
         TOOLTIP  "Importar presupuesto" ;
         ACTION   ( BrwPreCli( aGet[ _CNUMPRE ], dbfPreCliT, dbfPreCliL, D():Get( "TIva", nView ), D():Get( "Divisas", nView ), D():Get( "FPago", nView ), aGet[ _LIVAINC ] ) )

      REDEFINE BTNBMP oBtnSat ;
         ID       602 ;
         OF       oFld:aDialogs[1] ;
         RESOURCE "Power-drill_user1_16" ;
         NOBORDER ;
         TOOLTIP  "Importar SAT" ;
         ACTION   ( BrwSatCli( aGet[ _CNUMSAT ], dbfSatCliT, dbfSatCliL, D():Get( "TIva", nView ), D():Get( "Divisas", nView ), D():Get( "FPago", nView ), aGet[ _LIVAINC ] ) )

      REDEFINE BTNBMP oBtnPed ;
         ID       603 ;
         OF       oFld:aDialogs[1] ;
         RESOURCE "Clipboard_empty_user1_16" ;
         NOBORDER ;
         TOOLTIP  "Importar pedido" ;
         ACTION   ( BrwPedCli( aGet[ _CNUMPED ], dbfPedCliT, dbfPedCliL, D():Get( "TIva", nView ), D():Get( "Divisas", nView ), D():Get( "FPago", nView ), aGet[ _LIVAINC ] ) )

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
         VALID    ( cPedCli( aGet, aTmp, oBrwLin, oBrwPgo, nMode ), RecalculaTotal( aTmp ), SetDialog( aGet, oSayDias, oSayTxtDias ) );
         WHEN     ( nMode == APPD_MODE ) ;
         ON HELP  ( BrwPedCli( aGet[ _CNUMPED ], dbfPedCliT, dbfPedCliL, D():Get( "TIva", nView ), D():Get( "Divisas", nView ), D():Get( "FPago", nView ), aGet[ _LIVAINC ] ),;
                    RecalculaTotal( aTmp ) ) ;
         BITMAP   "LUPA" ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CNUMPRE ] VAR aTmp[ _CNUMPRE ] ;
         ID       151 ;
         WHEN     ( .f. ) ;
         VALID    ( cPreCli( aGet, aTmp, oBrwLin, nMode ), RecalculaTotal( aTmp ), SetDialog( aGet, oSayDias, oSayTxtDias ) ) ;
         PICTURE  "@R #/#########/##" ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CNUMSAT ] VAR aTmp[ _CNUMSAT ] ;
         ID       152 ;
         WHEN     ( .f. ) ;
         VALID    ( cSatCli( aGet, aTmp, oBrwLin, nMode ), RecalculaTotal( aTmp ), SetDialog( aGet, oSayDias, oSayTxtDias ) ) ;
         PICTURE  "@R #/#########/##" ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _LFACTURADO ] VAR cEstAlb;
         WHEN     .f. ;
         ID       160 ;
         OF       oFld:aDialogs[1]

      REDEFINE CHECKBOX aGet[ _LIVAINC ] VAR aTmp[ _LIVAINC ] ;
         ID       165 ;
         WHEN     ( lWhen .and. ( dbfTmpLin )->( LastRec() ) == 0 ) ;
         OF       oFld:aDialogs[1]

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
         FONT     oFont ;
         OF       oFld:aDialogs[1]

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
         ACTION   ( CancelEdtRec( nMode, aGet, oDlg ) )

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

      oDlg:AddFastKey( VK_F6,             {|| if( EndTrans( aTmp, aGet, oBrw, oBrwInc, nMode, oDlg ), ImprimirSeriesAlbaranes(), ) } )
      oDlg:AddFastKey( VK_F5,             {|| EndTrans( aTmp, aGet, oBrw, oBrwInc, nMode, oDlg ) } )
      oDlg:AddFastKey( 65,                {|| if( GetKeyState( VK_CONTROL ), CreateInfoArticulo(), ) } )

   end if

   oDlg:bStart       := {|| StartEdtRec( aTmp, aGet, oDlg, nMode, hHash, oBrwLin ) }

   oDlg:AddFastKey(  VK_F1, {|| ChmHelp( "Albaranes2" ) } )

   ACTIVATE DIALOG   oDlg ;
      ON INIT        (  InitEdtRec( aTmp, aGet, oDlg, oSayDias, oSayTxtDias, oBrwPgo, hHash ) );
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

   ( D():Get( "AlbCliT", nView ) )->( ordSetFocus( nOrd ) )

   KillTrans()

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

Static Function StartEdtRec( aTmp, aGet, oDlg, nMode, hHash, oBrwLin )

   if nMode == APPD_MODE

      if lRecogerUsuario()

         if !lGetUsuario( aGet[ _CCODUSR ], dbfUsr )
            oDlg:End()
         end if

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

   end if 

   oBrwLin:Load()

   /*
   Muestra y oculta las rentabilidades-----------------------------------------
   */

   if oGetRnt != nil .and. oUser():lNotRentabilidad()
      oGetRnt:Hide()
   end if

   /*
   Mostramos los escandallos---------------------------------------------------
   */

   lEscandalloEdtRec( .f., oBrwLin )

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

//---------------------------------------------------------------------------//

Static Function InitEdtRec( aTmp, aGet, oDlg, oSayDias, oSayTxtDias, oBrwPgo, hHash )

   EdtRecMenu( aGet, aTmp, oBrwLin, oDlg )
                        
   SetDialog( aGet, oSayDias, oSayTxtDias )

   oBrwLin:Load()
   oBrwInc:Load()
   oBrwPgo:Load()

RETURN ( nil )

//---------------------------------------------------------------------------//

Static Function CancelEdtRec( nMode, aGet, oDlg )

   local cNumDoc  

   if ExitNoSave( nMode, dbfTmpLin )

      if ( nMode == APPD_MODE .or. nMode == DUPL_MODE )

         CursorWait()
   
         // Presupuesto-----------------------------------------------------------
   
         cNumDoc                             := aGet[ _CNUMPRE ]:VarGet()
   
         if !Empty( cNumDoc ) .and. dbSeekInOrd( cNumDoc, "nNumPre", dbfPreCliT )
            if ( dbfPreCliT )->lEstado .and. dbLock( dbfPreCliT )
               ( dbfPreCliT )->cNumAlb    := ""
               ( dbfPreCliT )->lEstado    := .f.
               ( dbfPreCliT )->( dbUnLock() )
            end if
         end if 

         // Pedido----------------------------------------------------------------
   
         cNumDoc                             := aGet[ _CNUMPED ]:VarGet()
   
         if !Empty( cNumDoc ) .and. dbSeekInOrd( cNumDoc, "nNumPed", dbfPedCliT )
            if ( dbfPedCliT )->nEstado != 3 .and. dbLock( dbfPedCliT )
               ( dbfPedCliT )->cNumAlb    := ""
               ( dbfPedCliT )->nEstado    := 1
               ( dbfPedCliT )->( dbUnLock() )
            end if
         end if 

         // SAT----------------------------------------------------------------

         cNumDoc                             := aGet[ _CNUMSAT ]:VarGet()

         if !Empty( cNumDoc ) .and. dbSeekInOrd( cNumDoc, "nNumSat", dbfSatCliT )
            if ( dbfSatCliT )->lEstado .and. dbLock( dbfSatCliT )
               ( dbfSatCliT )->cNumAlb    := ""
               ( dbfSatCliT )->lEstado    := .f.
               ( dbfSatCliT )->( dbUnLock() )
            end if
         end if 

         CursorWE()

      end if 

      oDlg:end()

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

            MENUITEM    "&4. Modificar cliente contactos";
               MESSAGE  "Modifica la ficha del cliente en contactos" ;
               RESOURCE "User1_16" ;
               ACTION   ( if( !Empty( aTmp[ _CCODCLI ] ), EdtCli( aTmp[ _CCODCLI ], , 5 ), MsgStop( "Código de cliente vacío" ) ) )

            MENUITEM    "&5. Informe de cliente";
               MESSAGE  "Informe de cliente" ;
               RESOURCE "Info16" ;
               ACTION   ( if( !Empty( aTmp[ _CCODCLI ] ), InfCliente( aTmp[ _CCODCLI ] ), MsgStop( "Código de cliente vacío" ) ) );

            MENUITEM    "&6. Modificar dirección";
               MESSAGE  "Modifica ficha de la dirección" ;
               RESOURCE "Worker16" ;
               ACTION   ( if( !Empty( aTmp[ _CCODOBR ] ), EdtObras( aTmp[ _CCODCLI ], aTmp[ _CCODOBR ], dbfObrasT ), MsgStop( "Código de obra vacío" ) ) );

            SEPARATOR

            MENUITEM    "&7. Informe del documento";
               MESSAGE  "Informe del documento" ;
               RESOURCE "Info16" ;
               ACTION   ( TTrazaDocumento():Activate( ALB_CLI, aTmp[ _CSERALB ] + Str( aTmp[ _NNUMALB ] ) + aTmp[ _CSUFALB ] ) );

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
   local oGet2
   local cGet2
   local oGet3
   local cGet3
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

   do case
   case nMode == APPD_MODE

      aTmp[ _dCSERALB]        := aTmpAlb[_CSERALB]
      aTmp[ _dNNUMALB]        := aTmpAlb[_NNUMALB]
      aTmp[ _NCANENT ]        := 1
      aTmp[ _NUNICAJA]        := 1
      aTmp[ _DFECHA  ]        := GetSysDate()
      aTmp[ _CTIPMOV ]        := cDefVta()
      aTmp[ _LTOTLIN ]        := lTotLin
      aTmp[ _LNEWLIN ]        := .t.
      aTmp[ _CALMLIN ]        := aTmpAlb[ _CCODALM ]
      aTmp[ _LIVALIN ]        := aTmpAlb[ _LIVAINC ]
      aTmp[ _dCNUMPED]        := aTmpAlb[ _CNUMPED ]
      aTmp[ _NTARLIN ]        := aTmpAlb[ _NTARIFA ]
      aTmp[ _DFECCAD ]        := Ctod( "" )

      aTmp[ __DFECSAL ]       := aTmpAlb[ _DFECSAL ]
      aTmp[ __DFECENT ]       := aTmpAlb[ _DFECENTR ]
      aTmp[ __LALQUILER ]     := !Empty( oTipAlb ) .and. oTipAlb:nAt == 2

      aTmp[ __NFACTURADO ]    := 1

      if !Empty( cCodArtEnt )
         cCodArt              := cCodArtEnt
      end if

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
         ID       100 ;
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
         ID       111 ;
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

         aGet[ _CLOTE ]:bValid   := {|| LoaArt( cCodArt, aTmp, aGet, aTmpAlb, oStkAct, oSayPr1, oSayPr2, oSayVp1, oSayVp2, bmpImage, nMode ) }

      if !aTmp[ __LALQUILER ]

      REDEFINE GET aGet[ _DFECCAD ] VAR aTmp[ _DFECCAD ];
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

      end if

      /*
      fin de propiedades
      -------------------------------------------------------------------------
      */

      REDEFINE GET aGet[ _NIVA ] VAR aTmp[ _NIVA ] ;
         ID       120 ;
         PICTURE  "@E 99.99" ;
         WHEN     ( !aTmp[ _LCONTROL ] .AND. lModIva() .and. nMode != ZOOM_MODE ) ;
         VALID    ( lTiva( D():Get( "TIva", nView ), aTmp[ _NIVA ], @aTmp[ _NREQ ] ) );
         ON CHANGE( lCalcDeta( aTmp, aTmpAlb, nDouDiv, oTotal, oRentLin, cCodDiv ) );
         BITMAP   "LUPA" ;
         ON HELP  ( BrwIva( aGet[ _NIVA ], D():Get( "TIva", nView ), , .t. ) ) ;
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

      REDEFINE GET aGet[ __NBULTOS ] VAR aTmp[ __NBULTOS ] ;
         ID       610 ;
         SPINNER ;
         WHEN ( nMode != ZOOM_MODE ) .AND. uFieldEmpresa( "lUseBultos" ) ;
         PICTURE  cPicUnd ;
         OF       oFld:aDialogs[1] ;
         IDSAY    611

      REDEFINE GET aGet[ _NCANENT ] VAR aTmp[ _NCANENT ];
         ID       130;
         SPINNER ;
         WHEN     ( !aTmp[ _LCONTROL ] .AND. lUseCaj() .AND. nMode != ZOOM_MODE ) ;
         PICTURE  cPicUnd ;
         ON CHANGE( lCalcDeta( aTmp, aTmpAlb, nDouDiv, oTotal, oRentLin, cCodDiv ), LoaArt( cCodArt, aTmp, aGet, aTmpAlb, oStkAct, oSayPr1, oSayPr2, oSayVp1, oSayVp2, bmpImage, nMode, .f. ) );
         VALID    ( lCalcDeta( aTmp, aTmpAlb, nDouDiv, oTotal, oRentLin, cCodDiv ), LoaArt( cCodArt, aTmp, aGet, aTmpAlb, oStkAct, oSayPr1, oSayPr2, oSayVp1, oSayVp2, bmpImage, nMode, .f. ) );
         OF       oFld:aDialogs[1] ;
         IDSAY    131

      REDEFINE GET aGet[ _NUNICAJA ] VAR aTmp[ _NUNICAJA ] ;
         ID       140;
         IDSAY    141;
         SPINNER ;
         WHEN     ( !aTmp[ _LCONTROL ] .AND. nMode != ZOOM_MODE ) ;
         ON CHANGE( lCalcDeta( aTmp, aTmpAlb, nDouDiv, oTotal, oRentLin, cCodDiv ), LoaArt( cCodArt, aTmp, aGet, aTmpAlb, oStkAct, oSayPr1, oSayPr2, oSayVp1, oSayVp2, bmpImage, nMode, .f. ) );
         PICTURE  cPicUnd ;
         OF       oFld:aDialogs[1] ;

//         VALID    ( lCalcDeta( aTmp, aTmpAlb, nDouDiv, oTotal, oRentLin, cCodDiv ), LoaArt( cCodArt, aTmp, aGet, aTmpAlb, oStkAct, oSayPr1, oSayPr2, oSayVp1, oSayVp2, bmpImage, nMode, .f. ) );

      REDEFINE GET aGet[ _NFACCNV ] VAR aTmp[ _NFACCNV ] ;
         ID       295 ;
         WHEN     ( !aTmp[_LCONTROL] .AND. nMode != ZOOM_MODE ) ;
         PICTURE  "@E 999,999.999999";
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _NPREUNIT ] VAR aTmp[ _NPREUNIT ];
         ID       150 ;
         SPINNER ;
         WHEN     ( !aTmp[_LCONTROL] .AND. nMode != ZOOM_MODE ) ;
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
         COLOR    CLR_GET ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CFORMATO ] VAR aTmp[ _CFORMATO ];
         ID       620;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[_NDTO] VAR aTmp[_NDTO] ;
         ID       180 ;
         SPINNER ;
         WHEN     ( !aTmp[_LCONTROL] .AND. nMode != ZOOM_MODE .AND. !lTotLin ) ;
         COLOR    CLR_GET ;
         PICTURE  "@E 999.99";
         ON CHANGE( lCalcDeta( aTmp, aTmpAlb, nDouDiv, oTotal, oRentLin, cCodDiv ) );
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[_NDTOPRM] VAR aTmp[_NDTOPRM] ;
         ID       190 ;
         SPINNER ;
         WHEN     ( !aTmp[_LCONTROL] .AND. nMode != ZOOM_MODE .AND. !lTotLin ) ;
         COLOR    CLR_GET ;
         PICTURE  "@E 999.99";
         ON CHANGE( lCalcDeta( aTmp, aTmpAlb, nDouDiv, oTotal, oRentLin, cCodDiv ) );
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[_NCOMAGE] VAR aTmp[_NCOMAGE] ;
         ID       200 ;
         SPINNER ;
         WHEN     ( !aTmp[_LCONTROL] .AND. nMode != ZOOM_MODE .AND. !lTotLin ) ;
         COLOR    CLR_GET ;
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

      REDEFINE GET aGet[ _CALMLIN ] VAR aTmp[ _CALMLIN ] ;
         ID       300 ;
         WHEN     ( !aTmp[ _LCONTROL ] .AND. nMode != ZOOM_MODE ) ;         
         VALID    ( cAlmacen( aGet[ _CALMLIN ], , oSayAlm ), if( !uFieldEmpresa( "lNStkAct" ), oStock:lPutStockActual( aTmp[ _CREF ], aTmp[ _CALMLIN ], aTmp[ _CVALPR1 ], aTmp[ _CVALPR2 ], aTmp[ _CLOTE ], aTmp[ _LKITART ], aTmp[ _NCTLSTK ], oStkAct ), .t. ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwAlmacen( aGet[ _CALMLIN ], oSayAlm ) ) ;
         COLOR    CLR_GET ;
         OF       oFld:aDialogs[1]

//VALID    ( cNomUbica( aTmp, aGet, dbfAlm ), cAlmacen( aGet[ _CALMLIN ], , oSayAlm ), if( !uFieldEmpresa( "lNStkAct" ), oStock:lPutStockActual( aTmp[ _CREF ], aTmp[ _CALMLIN ], aTmp[ _CVALPR1 ], aTmp[ _CVALPR2 ], aTmp[ _CLOTE ], aTmp[ _LKITART ], aTmp[ _NCTLSTK ], oStkAct ), .t. ) ) ;

      REDEFINE GET oSayAlm VAR cSayAlm ;
         WHEN     .f. ;
         ID       301 ;
         OF       oFld:aDialogs[1]

/*
      REDEFINE SAY aGet[_CCODUBI1] VAR aTmp[_CCODUBI1];
         ID       612 ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[_CVALUBI1] VAR aTmp[_CVALUBI1] ;
         ID       610 ;
         BITMAP   "LUPA" ;
         WHEN     ( nMode != ZOOM_MODE ) ;
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
         WHEN     ( nMode != ZOOM_MODE ) ;
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
         WHEN     ( nMode != ZOOM_MODE ) ;
         ON HELP  ( BrwUbiLin( aGet[_CVALUBI3], aGet[_CNOMUBI3], aTmp[_CCODUBI3], dbfUbicaL ) ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[_CNOMUBI3] VAR aTmp[_CNOMUBI3];
         WHEN     .F. ;
         ID       631 ;
         OF       oFld:aDialogs[1]
*/

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
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   SaveDeta( aTmp, aTmpAlb, oFld, aGet, oBrw, bmpImage, oDlg, nMode, oSayPr1, oSayPr2, oSayVp1, oSayVp2, oGet2, oStkAct, nStkAct, oTotal, cCodArt, oBtn, oBtnSer )

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

   oDlg:AddFastKey( VK_F6,             {|| oBtnSer:Click() } )

   // Start --------------------------------------------------------------------

   oDlg:bStart    := {||   mSginfo( aTmp[_LCONTROL] ),;
                           SetDlgMode( aTmp, aGet, oFld, nMode, oSayPr1, oSayPr2, oSayVp1, oSayVp2, oStkAct, oGet2, oTotal, aTmpAlb, oRentLin ),;
                           mSginfo( aTmp[_LCONTROL] ),;
                           if( !Empty( cCodArtEnt ), aGet[ _CREF ]:lValid(), ),;
                           mSginfo( aTmp[_LCONTROL] ),;
                           lCalcDeta( aTmp, aTmpAlb, nDouDiv, oTotal, oRentLin, cCodDiv ),;
                           mSginfo( aTmp[_LCONTROL] ),;
                           aGet[ _CCODPRV ]:lValid(), mSginfo( aTmp[_LCONTROL] ) }

   ACTIVATE DIALOG oDlg ;
      ON INIT     ( EdtDetMenu( aGet[ _CREF ], oDlg ) );
      CENTER

   EndDetMenu()

RETURN ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

Static Function EdtInc( aTmp, aGet, dbf, oBrw, bWhen, bValid, nMode, aTmpAlb )

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

   DEFINE DIALOG oDlg RESOURCE "INCIDENCIA" TITLE LblTitle( nMode ) + "incidencias de albaranes a clientes"

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

Return ( oDlg:nResult == IDOK )

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

RETURN ( if( Empty( cPicUnd ), nTotPeso, Trans( nTotPeso, cPicUnd ) ) )

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

   /*
   Eliminamos las entregas-----------------------------------------------------
   */

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

   /*
   Detalle---------------------------------------------------------------------
   */

   while ( D():Get( "AlbCliL", nView ) )->( dbSeek( cNumAlb ) ) .and. !( D():Get( "AlbCliL", nView ) )->( eof() )
      
      if aScan( aNumPed, ( D():Get( "AlbCliL", nView ) )->cNumPed ) == 0
         aAdd( aNumPed, ( D():Get( "AlbCliL", nView ) )->cNumPed )
      end if      

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

   if !Empty( cNumPed )
      oStock:SetEstadoPedCli( cNumPed, .t., cNumAlb )
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
      oStock:SetEstadoSatCli( cNumSat, .t., cNumAlb )
   end if

   /*
   Estado de los sat cuando es agrupando-----------------------------------
   */

   while dbSeekInOrd( cNumAlb, "cNumAlb", dbfSatCliT ) .and. !( dbfSatCliT )->( Eof() )

      if dbLock( dbfSatCliT )
         ( dbfSatCliT )->cNumAlb    := ""
         ( dbfSatCliT )->lEstado    := .f.
         ( dbfSatCliT )->( dbUnLock() )
      end if

   end while

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

   if nMode != APPD_MODE .or. Empty( cPedido )
      Return .t.
   end if

   if dbSeekInOrd( cPedido, "nNumPed", dbfPedCliT )

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
               cDesAlb                 := Rtrim( cNumPed() ) + Space( 1 ) + ( dbfPedCliT )->cSerPed + "/" + AllTrim( Str( ( dbfPedCliT )->nNumPed ) ) + "/" + ( dbfPedCliT )->cSufPed
               cDesAlb                 += " - Fecha " + Dtoc( ( dbfPedCliT )->dFecPed )
               (dbfTmpLin)->cDetalle   := cDesAlb  
               (dbfTmpLin)->lControl   := .t.
            end if

            while ( ( dbfPedCliL )->cSerPed + Str( ( dbfPedCliL )->nNumPed ) + ( dbfPedCliL )->cSufPed == cPedido )

               nTotRet                 := ( dbfPedCliL )->nUniCaja
               nTotRet                 -= nUnidadesRecibidasAlbCli( cPedido, ( dbfPedCliL )->cRef, ( dbfPedCliL )->cCodPr1, ( dbfPedCliL )->cCodPr2, ( dbfPedCliL )->cRefPrv, ( dbfPedCliL )->cDetalle, D():Get( "AlbCliL", nView ) )
               nTotRet                 -= nUnidadesRecibidasFacCli( cPedido, ( dbfPedCliL )->cRef, ( dbfPedCliL )->cCodPr1, ( dbfPedCliL )->cCodPr2, D():Get( "FacCliL", nView ) )

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
                  (dbfTmpLin)->cNumPed    := cPedido
                  (dbfTmpLin)->lControl   := (dbfPedCliL)->lControl
                  (dbfTmpLin)->lLinOfe    := (dbfPedCliL)->lLinOfe
                  (dbfTmpLin)->nBultos    := (dbfPedCliL)->nBultos
                  (dbfTmpLin)->cFormato   := (dbfPedCliL)->cFormato

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

      end if

      aGet[ _CNUMPED ]:Disable()

      CursorWE()

   else

      MsgStop( "Pedido no existe" )

   end if

RETURN lValid

//---------------------------------------------------------------------------//

STATIC FUNCTION SelSend( oBrw )

   local oDlg
   local oFecEnv
   local dFecEnv  := GetSysDate()

   if dbDialogLock( D():Get( "AlbCliT", nView ) )

      if ( D():Get( "AlbCliT", nView ) )->lEntregado

         if lUsrMaster()

            ( D():Get( "AlbCliT", nView ) )->lEntregado := !( D():Get( "AlbCliT", nView ) )->lEntregado
            ( D():Get( "AlbCliT", nView ) )->dFecEnv    := Ctod( "" )

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

   if oDlg:nResult == IDOK .AND. Len( aPedidos ) >= 1

      CursorWait()

      HideImportacion( aGet )

      /*
      Aadimos los albaranes seleccionado para despues-------------------------
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
                  nTotRec              := nUnidadesRecibidasAlbCli( aPedidos[ nItem, 3 ], ( dbfPedCliL )->cRef, ( dbfPedCliL )->cCodPr1, ( dbfPedCliL )->cCodPr2, ( dbfPedCliL )->cRefPrv, ( dbfPedCliL )->cDetalle, D():Get( "AlbCliL", nView ) )
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

         if aTmpAlb[ _NREGIVA ] <= 1
            ( dbfTmpLin )->nIva     := nIva( D():Get( "TIva", nView ), ( D():Articulos( nView ) )->TipoIva )
            ( dbfTmpLin )->nReq     := nReq( D():Get( "TIva", nView ), ( D():Articulos( nView ) )->TipoIva )
         end if

         /*
         Ahora recogemos el impuesto especial si lo hay
         */

         if !Empty( ( D():Articulos( nView ) )->cCodImp )
            ( dbfTmpLin )->cCodImp  := ( D():Articulos( nView ) )->cCodImp
            ( dbfTmpLin )->nValImp  := oNewImp:nValImp( ( D():Articulos( nView ) )->cCodImp, aTmpAlb[ _LIVAINC ], ( dbfTmpLin )->nIva )
         end if

         /*
         Tomamos los precios de la base de datos de articulos---------------------
         */

         ( dbfTmpLin )->nPreUnit    := nRetPreArt( ( dbfTmpLin )->nTarLin, aTmpAlb[ _CDIVALB ], aTmpAlb[ _LIVAINC ], D():Articulos( nView ), D():Get( "Divisas", nView ), dbfKit, D():Get( "TIva", nView ) )

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

         case !Empty( aTmpAlb[ _CCODTAR ] )

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

         if !Empty( hAtipica )
               
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
         aTmp[ ( dbfTmpPgo )->( FieldPos( "cCodCaj" ) ) ]      := oUser():cCaja()

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
         WHEN     ( nMode != ZOOM_MODE .and. lUsrMaster() ) ;
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

   rxAlbCli( cPatSnd() )

   USE ( cPatSnd() + "AlbCliT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "AlbCliT", @tmpAlbCliT ) )
   SET ADSINDEX TO ( cPatSnd() + "AlbCliT.CDX" ) ADDITIVE

   USE ( cPatSnd() + "AlbCliL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "AlbCliL", @tmpAlbCliL ) )
   SET ADSINDEX TO ( cPatSnd() + "AlbCliL.CDX" ) ADDITIVE

   USE ( cPatSnd() + "AlbCliI.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "AlbCliI", @tmpAlbCliI ) )
   SET ADSINDEX TO ( cPatSnd() + "AlbCliI.CDX" ) ADDITIVE

   if !Empty( ::oSender:oMtr )
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
               while ( ( cAlbCliL )->cSerAlb + Str( ( cAlbCliL )->NNUMAlb ) + ( cAlbCliL )->CSUFAlb ) == ( ( cAlbCliT )->cSerAlb + Str( ( cAlbCliT )->NNUMAlb ) + ( cAlbCliT )->CSUFAlb ) .AND. !( cAlbCliL )->( eof() )
                  dbPass( cAlbCliL, tmpAlbCliL, .t. )
                  ( cAlbCliL )->( dbSkip() )
               end do
            end if

            if ( cAlbCliI )->( dbSeek( ( cAlbCliT )->cSerAlb + Str( ( cAlbCliT )->nNumAlb ) + ( cAlbCliT )->cSufAlb ) )
               while ( ( cAlbCliI )->cSerAlb + Str( ( cAlbCliI )->nNumAlb ) + ( cAlbCliI )->cSufAlb ) == ( ( cAlbCliT )->cSerAlb + Str( ( cAlbCliT )->nNumAlb ) + ( cAlbCliT )->cSufAlb ) .AND. !( cAlbCliI )->( eof() )
                  dbPass( cAlbCliI, tmpAlbCliI, .t. )
                  ( cAlbCliI )->( dbSkip() )
               end do
            end if

         end if

         SysRefresh()

         ( cAlbCliT )->( dbSkip() )

         if !Empty( ::oSender:oMtr )
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

      if ftpSndFile( cPatOut() + cFileName, cFileName, ::oSender )
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
      ftpGetFiles( "AlbCli*." + aExt[ n ], cPatIn(), ::oSender )
   next

   ::oSender:SetText( "Albaranes de clientes recibidos" )

Return Self

//----------------------------------------------------------------------------//

Method Process()

   local m
   local cAlbCliT
   local cAlbCliL
   local cAlbCliI
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

               USE ( cPatEmp() + "AlbCliT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "AlbCliT", @cAlbCliT ) )
               SET ADSINDEX TO ( cPatEmp() + "AlbCliT.CDX" ) ADDITIVE

               USE ( cPatEmp() + "AlbCliL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "AlbCliL", @cAlbCliL ) )
               SET ADSINDEX TO ( cPatEmp() + "AlbCliL.CDX" ) ADDITIVE

               USE ( cPatEmp() + "AlbCliI.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "AlbCliI", @cAlbCliI ) )
               SET ADSINDEX TO ( cPatEmp() + "AlbCliI.CDX" ) ADDITIVE

               while ( tmpAlbCliT )->( !eof() )

                  if lValidaOperacion( ( tmpAlbCliT )->dFecAlb, .f. ) .and. ;
                     !( cAlbCliT )->( dbSeek( ( tmpAlbCliT )->cSerAlb + Str( ( tmpAlbCliT )->nNumAlb ) + ( tmpAlbCliT )->cSufAlb ) )

                     dbPass( tmpAlbCliT, cAlbCliT, .t. )

                     if lClient .and. dbLock( cAlbCliT )
                        ( cAlbCliT )->lSndDoc := .f.
                        ( cAlbCliT )->( dbUnLock() )
                     end if

                     ::oSender:SetText( "Añadido     : " + ( tmpAlbCliT )->cSerAlb + "/" + AllTrim( Str( ( tmpAlbCliT )->nNumAlb ) ) + "/" + AllTrim( ( tmpAlbCliT )->cSufAlb ) + "; " + Dtoc( ( tmpAlbCliT )->dFecAlb ) + "; " + AllTrim( ( tmpAlbCliT )->cCodCli ) + "; " + ( tmpAlbCliT )->cNomCli )

                     if ( tmpAlbCliL )->( dbSeek( ( tmpAlbCliT )->cSerAlb + Str( ( tmpAlbCliT )->nNumAlb ) + ( tmpAlbCliT )->cSufAlb ) )
                        while ( tmpAlbCliL )->cSerAlb + Str( ( tmpAlbCliL )->nNumAlb ) + ( tmpAlbCliL )->cSufAlb == ( tmpAlbCliT )->cSerAlb + Str( ( tmpAlbCliT )->nNumAlb ) + ( tmpAlbCliT )->cSufAlb .and. !( tmpAlbCliL )->( eof() )
                           dbPass( tmpAlbCliL, cAlbCliL, .t. )
                           ( tmpAlbCliL )->( dbSkip() )
                        end do
                     end if

                     if ( tmpAlbCliI )->( dbSeek( ( tmpAlbCliT )->cSerAlb + Str( ( tmpAlbCliT )->nNumAlb ) + ( tmpAlbCliT )->cSufAlb ) )
                        while ( tmpAlbCliI )->cSerAlb + Str( ( tmpAlbCliI )->nNumAlb ) + ( tmpAlbCliI )->cSufAlb == ( tmpAlbCliT )->cSerAlb + Str( ( tmpAlbCliT )->nNumAlb ) + ( tmpAlbCliT )->cSufAlb .and. !( tmpAlbCliI )->( eof() )
                           dbPass( tmpAlbCliI, cAlbCliI, .t. )
                           ( tmpAlbCliI )->( dbSkip() )
                        end do
                     end if

                  else

                     ::oSender:SetText( "Desestimado : " + ( tmpAlbCliT )->cSerAlb + "/" + AllTrim( Str( ( tmpAlbCliT )->nNumAlb ) ) + "/" + AllTrim( ( tmpAlbCliT )->cSufAlb ) + "; " + Dtoc( ( tmpAlbCliT )->dFecAlb ) + "; " + AllTrim( ( tmpAlbCliT )->cCodCli ) + "; " + ( tmpAlbCliT )->cNomCli )

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

Static Function AlbCliNotas()

   local cObserv  := ""
   local aData    := {}

   aAdd( aData, "Albaran " + ( D():Get( "AlbCliT", nView ) )->cSerAlb + "/" + AllTrim( Str( ( D():Get( "AlbCliT", nView ) )->nNumAlb ) ) + "/" + Alltrim( ( D():Get( "AlbCliT", nView ) )->cSufAlb ) + " de " + Rtrim( ( D():Get( "AlbCliT", nView ) )->cNomCli ) )
   aAdd( aData, ALB_CLI )
   aAdd( aData, ( D():Get( "AlbCliT", nView ) )->cCodCli )
   aAdd( aData, ( D():Get( "AlbCliT", nView ) )->cNomCli )
   aAdd( aData, ( D():Get( "AlbCliT", nView ) )->cSerAlb + Str( ( D():Get( "AlbCliT", nView ) )->nNumAlb ) + ( D():Get( "AlbCliT", nView ) )->cSufAlb )

   if ( D():Get( "Client", nView ) )->( dbSeek( ( D():Get( "AlbCliT", nView ) )->cCodCli ) )

      if !Empty( ( D():Get( "Client", nView ) )->cPerCto )
         cObserv  += Rtrim( ( D():Get( "Client", nView ) )->cPerCto ) + Space( 1 )
      end if

      if !Empty( ( D():Get( "Client", nView ) )->Telefono )
         cObserv  += "Télefono : " + Rtrim( ( D():Get( "Client", nView ) )->Telefono ) + Space( 1 )
      end if

      if !Empty( ( D():Get( "Client", nView ) )->Movil )
         cObserv  += "Móvil : " + Rtrim( ( D():Get( "Client", nView ) )->Movil ) + Space( 1 )
      end if

      if !Empty( ( D():Get( "Client", nView ) )->Fax )
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
      cFmtEnt        := cFormatoEntregasCuentaEnCaja( oUser():cCaja(), dbfCajT )
      cPrinter       := cPrinterEntregasCuenta( oUser():cCaja(), dbfCajT )
      nCopPrn        := nCopiasEntregasCuentaEnCaja( oUser():cCaja(), dbfCajT )
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

   TBtnBmp():ReDefine( 111, "Printer_preferences_16",,,,,{|| PrinterPreferences( oPrinter ) }, oDlg, .f., , .f.,  )

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

   if Empty( cFmtEnt )
      MsgStop( "Es necesario elegir un formato" )
      return nil
   end if

   if !lExisteDocumento( cFmtEnt, D():Documentos( nView ) )
      return nil
   end if

   if lVisualDocumento( cFmtEnt, D():Documentos( nView ) )

      PrintReportEntAlbCli( if( lPrint, IS_PRINTER, IS_SCREEN ), nCopies, cPrinter, D():Documentos( nView ), cAlbCliP, lTicket )

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

STATIC FUNCTION ValidaMedicion( aTmp, aGet )

   local cNewUndMed  := aGet[ _CUNIDAD ]:VarGet

   /*
   Cargamos el codigo de las unidades---------------------------------
   */

   if ( Empty( cOldUndMed ) .or. cOldUndMed != cNewUndMed )

      if oUndMedicion:oDbf:Seek( aTmp[ _CUNIDAD ] )

         if oUndMedicion:oDbf:nDimension >= 1 .and. !Empty( oUndMedicion:oDbf:cTextoDim1 )
            if !Empty( aGet[ ( D():Get( "AlbCliL", nView ) )->( fieldpos( "nMedUno" ) ) ] )
               aGet[ ( D():Get( "AlbCliL", nView ) )->( fieldpos( "nMedUno" ) ) ]:oSay:SetText( oUndMedicion:oDbf:cTextoDim1 )
               aGet[ ( D():Get( "AlbCliL", nView ) )->( fieldpos( "nMedUno" ) ) ]:cText( ( D():Articulos( nView ) )->nLngArt )
               aGet[ ( D():Get( "AlbCliL", nView ) )->( fieldpos( "nMedUno" ) ) ]:Show()
            else
               aTmp[ ( D():Get( "AlbCliL", nView ) )->( fieldpos( "nMedUno" ) ) ]  := ( D():Articulos( nView ) )->nLngArt
            end if
         else
            if !Empty( aGet[ ( D():Get( "AlbCliL", nView ) )->( fieldpos( "nMedUno" ) ) ] )
               aGet[ ( D():Get( "AlbCliL", nView ) )->( fieldpos( "nMedUno" ) ) ]:cText( 0 )
               aGet[ ( D():Get( "AlbCliL", nView ) )->( fieldpos( "nMedUno" ) ) ]:Hide()
            else
               aTmp[ ( D():Get( "AlbCliL", nView ) )->( fieldpos( "nMedUno" ) ) ]  := 0
            end if
         end if

         if oUndMedicion:oDbf:nDimension >= 2 .and. !Empty( oUndMedicion:oDbf:cTextoDim2 )
            if !Empty( aGet[ ( D():Get( "AlbCliL", nView ) )->( fieldpos( "nMedDos" ) ) ] )
               aGet[ ( D():Get( "AlbCliL", nView ) )->( fieldpos( "nMedDos" ) ) ]:oSay:SetText( oUndMedicion:oDbf:cTextoDim2 )
               aGet[ ( D():Get( "AlbCliL", nView ) )->( fieldpos( "nMedDos" ) ) ]:cText( ( D():Articulos( nView ) )->nAltArt )
               aGet[ ( D():Get( "AlbCliL", nView ) )->( fieldpos( "nMedDos" ) ) ]:Show()
            else
               aTmp[ ( D():Get( "AlbCliL", nView ) )->( fieldpos( "nMedDos" ) ) ]  := ( D():Articulos( nView ) )->nAltArt
            end if

         else
            if !Empty( aGet[ ( D():Get( "AlbCliL", nView ) )->( fieldpos( "nMedDos" ) ) ] )
               aGet[ ( D():Get( "AlbCliL", nView ) )->( fieldpos( "nMedDos" ) ) ]:cText( 0 )
               aGet[ ( D():Get( "AlbCliL", nView ) )->( fieldpos( "nMedDos" ) ) ]:Hide()
            else
                 aTmp[ ( D():Get( "AlbCliL", nView ) )->( fieldpos( "nMedDos" ) ) ]  := 0
            end if
         end if

         if oUndMedicion:oDbf:nDimension >= 3 .and. !Empty( oUndMedicion:oDbf:cTextoDim3 )
            if !Empty( aGet[ ( D():Get( "AlbCliL", nView ) )->( fieldpos( "nMedTre" ) ) ] )
               aGet[ ( D():Get( "AlbCliL", nView ) )->( fieldpos( "nMedTre" ) ) ]:oSay:SetText( oUndMedicion:oDbf:cTextoDim3 )
               aGet[ ( D():Get( "AlbCliL", nView ) )->( fieldpos( "nMedTre" ) ) ]:cText( ( D():Articulos( nView ) )->nAncArt )
               aGet[ ( D():Get( "AlbCliL", nView ) )->( fieldpos( "nMedTre" ) ) ]:Show()
            else
               aTmp[ ( D():Get( "AlbCliL", nView ) )->( fieldpos( "nMedTre" ) ) ]  := ( D():Articulos( nView ) )->nAncArt
            end if
         else
            if !Empty( aGet[ ( D():Get( "AlbCliL", nView ) )->( fieldpos( "nMedTre" ) ) ] )
               aGet[ ( D():Get( "AlbCliL", nView ) )->( fieldpos( "nMedTre" ) ) ]:cText( 0 )
               aGet[ ( D():Get( "AlbCliL", nView ) )->( fieldpos( "nMedTre" ) ) ]:Hide()
            else
               aTmp[ ( D():Get( "AlbCliL", nView ) )->( fieldpos( "nMedTre" ) ) ]  := 0
            end if
         end if

      else

         if !Empty( aGet[ ( D():Get( "AlbCliL", nView ) )->( fieldpos( "nMedUno" ) ) ] )
            aGet[ ( D():Get( "AlbCliL", nView ) )->( fieldpos( "nMedUno" ) ) ]:Hide()
            aGet[ ( D():Get( "AlbCliL", nView ) )->( fieldpos( "nMedUno" ) ) ]:cText( 0 )
         end if

         if !Empty( aGet[ ( D():Get( "AlbCliL", nView ) )->( fieldpos( "nMedDos" ) ) ] )
            aGet[ ( D():Get( "AlbCliL", nView ) )->( fieldpos( "nMedDos" ) ) ]:Hide()
            aGet[ ( D():Get( "AlbCliL", nView ) )->( fieldpos( "nMedDos" ) ) ]:cText( 0 )
         end if

         if !Empty( aGet[ ( D():Get( "AlbCliL", nView ) )->( fieldpos( "nMedTre" ) ) ] )
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

   if !aTmp[ __LALQUILER ]

      nPrePro     := nPrePro( aTmp[ _CREF ], aTmp[ _CCODPR1 ], aTmp[ _CVALPR1 ], aTmp[ _CCODPR2 ], aTmp[ _CVALPR2 ], aTmp[ _NTARLIN ], aTmpAlb[ _LIVAINC ], dbfArtDiv, aTmpAlb[ _CCODTAR ] )

      if nPrePro == 0
         nPrePro  := nRetPreArt( aTmp[ _NTARLIN ], aTmpAlb[ _CDIVALB ], aTmpAlb[ _LIVAINC ], D():Articulos( nView ), D():Get( "Divisas", nView ), dbfKit, D():Get( "TIva", nView ) )
      end if

      if nPrePro != 0
         aGet[ _NPREUNIT ]:cText( nPrePro )
      end if

   else

      aGet[ _NPREUNIT ]:cText( 0 )
      aGet[ _NPREALQ  ]:cText( nPreAlq( aTmp[ _CREF ], aTmp[ _NTARLIN ], aTmpAlb[ _LIVAINC ], D():Articulos( nView ) ) )

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

   oFr:SetWorkArea(     "Empresa", ( dbfEmp )->( Select() ) )
   oFr:SetFieldAliases( "Empresa", cItemsToReport( aItmEmp() ) )

   oFr:SetWorkArea(     "Clientes", ( D():Get( "Client", nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Clientes", cItemsToReport( aItmCli() ) )

   oFr:SetWorkArea(     "Clientes.País", oPais:Select() )
   oFr:SetFieldAliases( "Clientes.País", cObjectsToReport( oPais:oDbf ) )

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

   oFr:SetWorkArea(     "Transportistas", oTrans:Select() )
   oFr:SetFieldAliases( "Transportistas", cObjectsToReport( oTrans:oDbf ) )

   oFr:SetWorkArea(     "Artículos", ( D():Articulos( nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Artículos", cItemsToReport( aItmArt() ) )

   oFr:SetWorkArea(     "Tipo de venta", ( dbfTVta )->( Select() ) )
   oFr:SetFieldAliases( "Tipo de venta", cItemsToReport( aItmTVta() ) )

   oFr:SetWorkArea(     "Usuarios", ( dbfUsr )->( Select() ) )
   oFr:SetFieldAliases( "Usuarios", cItemsToReport( aItmUsuario() ) )

   oFr:SetWorkArea(     "Ofertas", ( dbfOferta )->( Select() ) )
   oFr:SetFieldAliases( "Ofertas", cItemsToReport( aItmOfe() ) )

   oFr:SetWorkArea(     "Unidades de medición",  oUndMedicion:Select() )
   oFr:SetFieldAliases( "Unidades de medición",  cObjectsToReport( oUndMedicion:oDbf ) )

   oFr:SetWorkArea(     "SAT", ( dbfSatCliT )->( Select() ) )
   oFr:SetFieldAliases( "SAT", cItemsToReport( aItmSatCli() ) )

   oFr:SetMasterDetail( "Albaranes", "Lineas de albaranes",             {|| ( D():Get( "AlbCliT", nView ) )->cSerAlb + Str( ( D():Get( "AlbCliT", nView ) )->nNumAlb ) + ( D():Get( "AlbCliT", nView ) )->cSufAlb } )
   oFr:SetMasterDetail( "Albaranes", "Series de lineas de albaranes",   {|| ( D():Get( "AlbCliT", nView ) )->cSerAlb + Str( ( D():Get( "AlbCliT", nView ) )->nNumAlb ) + ( D():Get( "AlbCliT", nView ) )->cSufAlb } )
   oFr:SetMasterDetail( "Albaranes", "Incidencias de albaranes",        {|| ( D():Get( "AlbCliT", nView ) )->cSerAlb + Str( ( D():Get( "AlbCliT", nView ) )->nNumAlb ) + ( D():Get( "AlbCliT", nView ) )->cSufAlb } )
   oFr:SetMasterDetail( "Albaranes", "Documentos de albaranes",         {|| ( D():Get( "AlbCliT", nView ) )->cSerAlb + Str( ( D():Get( "AlbCliT", nView ) )->nNumAlb ) + ( D():Get( "AlbCliT", nView ) )->cSufAlb } )
   oFr:SetMasterDetail( "Albaranes", "Entregas de albaranes",           {|| ( D():Get( "AlbCliT", nView ) )->cSerAlb + Str( ( D():Get( "AlbCliT", nView ) )->nNumAlb ) + ( D():Get( "AlbCliT", nView ) )->cSufAlb } )
   oFr:SetMasterDetail( "Albaranes", "Clientes",                        {|| ( D():Get( "AlbCliT", nView ) )->cCodCli } )
   oFr:SetMasterDetail( "Albaranes", "Obras",                           {|| ( D():Get( "AlbCliT", nView ) )->cCodCli + ( D():Get( "AlbCliT", nView ) )->cCodObr } )
   oFr:SetMasterDetail( "Albaranes", "Almacen",                         {|| ( D():Get( "AlbCliT", nView ) )->cCodAlm } )
   oFr:SetMasterDetail( "Albaranes", "Rutas",                           {|| ( D():Get( "AlbCliT", nView ) )->cCodRut } )
   oFr:SetMasterDetail( "Albaranes", "Agentes",                         {|| ( D():Get( "AlbCliT", nView ) )->cCodAge } )
   oFr:SetMasterDetail( "Albaranes", "Formas de pago",                  {|| ( D():Get( "AlbCliT", nView ) )->cCodPago} )
   oFr:SetMasterDetail( "Albaranes", "Transportistas",                  {|| ( D():Get( "AlbCliT", nView ) )->cCodTrn } )
   oFr:SetMasterDetail( "Albaranes", "Empresa",                         {|| cCodigoEmpresaEnUso() } )
   oFr:SetMasterDetail( "Albaranes", "Usuarios",                        {|| ( D():Get( "AlbCliT", nView ) )->cCodUsr } )

   oFr:SetMasterDetail( "Clientes", "Clientes.Pais",                    {|| ( D():Get( "Client", nView ) )->cCodPai } )

   oFr:SetMasterDetail( "Lineas de albaranes", "Artículos",             {|| ( D():Get( "AlbCliL", nView ) )->cRef } )
   oFr:SetMasterDetail( "Lineas de albaranes", "Tipo de venta",         {|| ( D():Get( "AlbCliL", nView ) )->cTipMov } )
   oFr:SetMasterDetail( "Lineas de albaranes", "Ofertas",               {|| ( D():Get( "AlbCliL", nView ) )->cRef } )
   oFr:SetMasterDetail( "Lineas de albaranes", "Unidades de medición",  {|| ( D():Get( "AlbCliL", nView ) )->cUnidad } )

   oFr:SetMasterDetail( "Lineas de albaranes", "SAT",                   {|| ( D():Get( "AlbCliL", nView ) )->cNumSat } )

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

   oFr:SetResyncPair(   "Lineas de albaranes", "SAT" )

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
   
   oFr:AddVariable(     "Lineas de albaranes",   "Detalle del artículo",                "CallHbFunc('cDesAlbCli')"  )
   oFr:AddVariable(     "Lineas de albaranes",   "Total unidades artículo",             "CallHbFunc('nTotNAlbCli')" )
   oFr:AddVariable(     "Lineas de albaranes",   "Precio unitario del artículo",        "CallHbFunc('nTotUAlbCli')" )
   oFr:AddVariable(     "Lineas de albaranes",   "Total línea de albaran",              "CallHbFunc('nTotLAlbCli')" )
   oFr:AddVariable(     "Lineas de albaranes",   "Total peso por línea",                "CallHbFunc('nPesLAlbCli')" )
   oFr:AddVariable(     "Lineas de albaranes",   "Total línea sin " + cImp(),           "CallHbFunc('nNetLAlbCli')" )

   oFr:AddVariable(     "Lineas de albaranes",   "Fecha en juliano 4 meses",            "CallHbFunc('dJuliano4AlbCli')" )
   oFr:AddVariable(     "Lineas de albaranes",   "Fecha en juliano 6 meses",            "CallHbFunc('dJulianoAlbCli')" )
   oFr:AddVariable(     "Lineas de albaranes",   "Fecha en juliano 8 meses",            "CallHbFunc('dJulianoAlbAnio')" )

   oFr:AddVariable(     "Lineas de albaranes",   "dirección del SAT",                   "CallHbFunc('cDireccionSAT')" )

Return nil

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
      if !Empty( cAlbCliP )
         oFr:SetMasterDetail( "Entrega", "Albarán de cliente",       {|| ( cAlbCliP )->cSerAlb + Str( ( cAlbCliP )->nNumAlb ) + ( cAlbCliP )->cSufAlb } )
      else
         oFr:SetMasterDetail( "Entrega", "Albarán de cliente",       {|| ( D():Get( "AlbCliP", nView ) )->cSerAlb + Str( ( D():Get( "AlbCliP", nView ) )->nNumAlb ) + ( D():Get( "AlbCliP", nView ) )->cSufAlb } )
      end if
   end if

   if !Empty( cAlbCliP )
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
   oFr:AddVariable( "Albarán de cliente",    "Importe del primer vencimiento",      "GetHbArrayVar('aImpVto',1)" )
   oFr:AddVariable( "Albarán de cliente",    "Importe del segundo vencimiento",     "GetHbArrayVar('aImpVto',2)" )
   oFr:AddVariable( "Albarán de cliente",    "Importe del tercero vencimiento",     "GetHbArrayVar('aImpVto',3)" )
   oFr:AddVariable( "Albarán de cliente",    "Importe del cuarto vencimiento",      "GetHbArrayVar('aImpVto',4)" )
   oFr:AddVariable( "Albarán de cliente",    "Importe del quinto vencimiento",      "GetHbArrayVar('aImpVto',5)" )

Return nil

//---------------------------------------------------------------------------//

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

         if ( D():Get( "AlbCliL", nView ) )->( dbSeek( cAlbaran ) )
            while ( ( D():Get( "AlbCliL", nView ) )->cSerAlb + Str( ( D():Get( "AlbCliL", nView ) )->nNumAlb ) + ( D():Get( "AlbCliL", nView ) )->cSufAlb ) == cAlbaran .and. !( D():Get( "AlbCliL", nView ) )->( eof() )
               dbPass( D():Get( "AlbCliL", nView ), dbfTmpLin, .t. )
               ( D():Get( "AlbCliL", nView ) )->( dbSkip() )
            end while
         end if

         ( dbfTmpLin )->( ordSetFocus( "nNumLin" ) )
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

         if ( D():Get( "AlbCliP", nView ) )->( dbSeek( cAlbaran ) )
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

         if ( D():Get( "AlbCliI", nView ) )->( dbSeek( cAlbaran ) )
            while ( ( D():Get( "AlbCliI", nView ) )->cSerAlb + Str( ( D():Get( "AlbCliI", nView ) )->nNumAlb ) + ( D():Get( "AlbCliI", nView ) )->cSufAlb == cAlbaran ) .and. ( D():Get( "AlbCliI", nView ) )->( !eof() )
               dbPass( D():Get( "AlbCliI", nView ), dbfTmpInc, .t. )
               ( D():Get( "AlbCliI", nView ) )->( dbSkip() )
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

         if ( D():Get( "AlbCliD", nView ) )->( dbSeek( cAlbaran ) )
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

         if ( D():Get( "AlbCliS", nView ) )->( dbSeek( cAlbaran ) )
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
   local lChgCodCli  := ( Empty( cOldCodCli ) .or. cOldCodCli != cNewCodCli )

   if Empty( cNewCodCli )
      Return .t.
   elseif At( ".", cNewCodCli ) != 0
      cNewCodCli     := PntReplace( aGet[ _CCODCLI ], "0", RetNumCodCliEmp() )
   else
      cNewCodCli     := Rjust( cNewCodCli, "0", RetNumCodCliEmp() )
   end if

   /*
   Calculo del reisgo del cliente
   */

   if ( D():Get( "Client", nView ) )->( dbSeek( cNewCodCli ) )

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

      if Empty( aGet[_CNOMCLI]:varGet() ) .or. lChgCodCli
         aGet[_CNOMCLI]:cText( ( D():Get( "Client", nView ) )->Titulo )
      end if

      if Empty( aGet[_CDIRCLI]:varGet() ) .or. lChgCodCli
         aGet[_CDIRCLI]:cText( ( D():Get( "Client", nView ) )->Domicilio )
      end if

      if Empty( aGet[ _CTLFCLI ]:varGet() ) .or. lChgCodCli
         aGet[ _CTLFCLI ]:cText( ( D():Get( "Client", nView ) )->Telefono )
      end if

      if Empty( aGet[_CPOBCLI]:varGet() ) .or. lChgCodCli
         aGet[_CPOBCLI]:cText( ( D():Get( "Client", nView ) )->Poblacion )
      end if

      if !Empty( aGet[_CPRVCLI] )
         if Empty( aGet[_CPRVCLI]:varGet() ) .or. lChgCodCli
            aGet[_CPRVCLI]:cText( ( D():Get( "Client", nView ) )->Provincia )
         end if
      end if

      if !Empty( aGet[_CPOSCLI] )
         if Empty( aGet[_CPOSCLI]:varGet() ) .or. lChgCodCli
            aGet[_CPOSCLI]:cText( ( D():Get( "Client", nView ) )->CodPostal )
         end if
      end if

      if !Empty( aGet[_CDNICLI] )
         if Empty( aGet[_CDNICLI]:varGet() ) .or. lChgCodCli
            aGet[_CDNICLI]:cText( ( D():Get( "Client", nView ) )->Nif )
         end if
      end if

      if Empty( aTmp[_CCODGRP] ) .or. lChgCodCli
         aTmp[_CCODGRP]    := ( D():Get( "Client", nView ) )->cCodGrp
      end if
     
      if ( lChgCodCli )

         /*
         Cargamos la obra por defecto------------------------------------------
         */

         if !Empty( aGet[ _CCODOBR ] )

            if dbSeekInOrd( cNewCodCli, "lDefObr", dbfObrasT )
               aGet[ _CCODOBR ]:cText( ( dbfObrasT )->cCodObr )
            else
               aGet[ _CCODOBR ]:cText( Space( 10 ) )
            end if

            aGet[ _CCODOBR ]:lValid()

         end if

         aTmp[ _LMODCLI ]  := ( D():Get( "Client", nView ) )->lModDat

         aTmp[ _LOPERPV ]  := ( D():Get( "Client", nView ) )->lPntVer

         /*
         Calculo del reisgo del cliente-------------------------------------------
         */

         oStock:SetRiesgo( cNewCodCli, oRieCli, ( D():Get( "Client", nView ) )->Riesgo )

      end if

      if nMode == APPD_MODE

         aTmp[ _NREGIVA ]  := ( D():Get( "Client", nView ) )->nRegIva

         /*
         Si estamos a¤adiendo cargamos todos los datos del cliente
         */

         if Empty( aTmp[ _CSERALB ] )

            if !Empty( ( D():Get( "Client", nView ) )->Serie )
               aGet[ _CSERALB ]:cText( ( D():Get( "Client", nView ) )->Serie )
            end if

         else

            if !Empty( ( D():Get( "Client", nView ) )->Serie )                .and.;
               aTmp[ _CSERALB ] != ( D():Get( "Client", nView ) )->Serie      .and.;
               ApoloMsgNoYes( "La serie del cliente seleccionado es distinta a la anterior.", "¿Desea cambiar la serie?" )
               aGet[ _CSERALB ]:cText( ( D():Get( "Client", nView ) )->Serie )
            end if

         end if

         if !Empty( aGet[_CCODALM] )
            if ( Empty( aGet[_CCODALM]:varGet() ) .or. lChgCodCli ) .and. !Empty( ( D():Get( "Client", nView ) )->cCodAlm )
                aGet[_CCODALM]:cText( ( D():Get( "Client", nView ) )->cCodAlm )
                aGet[_CCODALM]:lValid()
            end if
         end if

         if !Empty( aGet[_CCODTAR] )
            if ( Empty( aGet[_CCODTAR]:varGet() ) .or. lChgCodCli ) .and. !Empty( ( D():Get( "Client", nView ) )->cCodTar )
               aGet[_CCODTAR]:cText( ( D():Get( "Client", nView ) )->CCODTAR )
               aGet[_CCODTAR]:lValid()
            end if
         end if

         if ( Empty( aGet[_CCODPAGO]:varGet() ) .or. lChgCodCli ) .and. !Empty( ( D():Get( "Client", nView ) )->CodPago )
            aGet[_CCODPAGO]:cText( (D():Get( "Client", nView ))->CODPAGO )
            aGet[_CCODPAGO]:lValid()
         end if

         /*
         Si la forma de pago es un movimiento bancario le asignamos el banco y cuenta por defecto
         */

         if ( lChgCodCli .and. lBancoDefecto( ( D():Get( "Client", nView ) )->Cod, dbfCliBnc ) )

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

         if !Empty( aGet[_CCODAGE] )
            if ( Empty( aGet[_CCODAGE]:varGet() ) .or. lChgCodCli ) .and. !Empty( ( D():Get( "Client", nView ) )->cAgente )
                aGet[_CCODAGE]:cText( (D():Get( "Client", nView ))->CAGENTE )
                aGet[_CCODAGE]:lValid()
            end if
         end if

         if ( Empty( aGet[_CCODRUT]:varGet() ) .or. lChgCodCli ) .and. !Empty( ( D():Get( "Client", nView ) )->cCodRut )
            aGet[_CCODRUT]:cText( ( D():Get( "Client", nView ))->CCODRUT )
            aGet[_CCODRUT]:lValid()
         end if

         if ( Empty( aGet[ _NTARIFA ]:varGet() ) .or. lChgCodCli ) .and. !Empty( ( D():Get( "Client", nView ) )->nTarifa )
             aGet[ _NTARIFA ]:cText( ( D():Get( "Client", nView ) )->nTarifa )
         end if

         if ( Empty( aTmp[ _NDTOTARIFA ] ) .or. lChgCodCli )
             aTmp[ _NDTOTARIFA ]    := ( D():Get( "Client", nView ) )->nDtoArt
         end if

         if !Empty( aGet[ _CCODTRN ] ) .and. ( Empty( aGet[ _CCODTRN ]:varGet() ) .or. lChgCodCli ) .and. !Empty( ( D():Get( "Client", nView ) )->cCodTrn )
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

            if !Empty( aGet[ _CDTOESP ] )
               aGet[ _CDTOESP ]:cText( ( D():Get( "Client", nView ) )->cDtoEsp )
            else
               aTmp[ _CDTOESP ]  := ( D():Get( "Client", nView ) )->cDtoEsp
            end if

            if !Empty( aGet[ _NDTOESP ] )
               aGet[ _NDTOESP ]:cText( ( D():Get( "Client", nView ) )->nDtoEsp )
            else
               aTmp[ _NDTOESP ]  := ( D():Get( "Client", nView ) )->nDtoEsp
            end if

            if !Empty( aGet[ _CDPP    ] )
               aGet[ _CDPP    ]:cText( ( D():Get( "Client", nView ) )->cDpp )
            else
               aTmp[ _CDPP    ]  := ( D():Get( "Client", nView ) )->cDpp
            end if

            if !Empty( aGet[ _NDPP    ] )
               aGet[ _NDPP    ]:cText( ( D():Get( "Client", nView ) )->nDpp )
            else
               aTmp[ _NDPP    ]  := ( D():Get( "Client", nView ) )->nDpp
            end if

            if !Empty( aGet[ _CDTOUNO ] )
               aGet[ _CDTOUNO ]:cText( ( D():Get( "Client", nView ) )->cDtoUno )
            else
               aTmp[ _CDTOUNO ]  := ( D():Get( "Client", nView ) )->cDtoUno
            end if

            if !Empty( aGet[ _CDTODOS ] )
               aGet[ _CDTODOS ]:cText( ( D():Get( "Client", nView ) )->cDtoDos )
            else
               aTmp[ _CDTODOS ]  := ( D():Get( "Client", nView ) )->cDtoDos
            end if

            if !Empty( aGet[ _NDTOUNO ] )
               aGet[ _NDTOUNO ]:cText( ( D():Get( "Client", nView ) )->nDtoCnt )
            else
               aTmp[ _NDTOUNO ]  := ( D():Get( "Client", nView ) )->nDtoCnt
            end if

            if !Empty( aGet[ _NDTODOS ] )
               aGet[ _NDTODOS ]:cText( ( D():Get( "Client", nView ) )->nDtoRap )
            else
               aTmp[ _NDTODOS ]  := ( D():Get( "Client", nView ) )->nDtoRap
            end if

            aTmp[ _NSBRATP ]  := ( D():Get( "Client", nView ) )->nSbrAtp

            aTmp[ _NDTOATP ]  := ( D():Get( "Client", nView ) )->nDtoAtp

         end if

      end if

      if lChgCodCli

         if ( D():Get( "Client", nView ) )->lMosCom .and. !Empty( ( D():Get( "Client", nView ) )->mComent )
            MsgStop( Trim( ( D():Get( "Client", nView ) )->mComent ) )
         end if

         ShowIncidenciaCliente( ( D():Get( "Client", nView ) )->Cod, nView )

         if ( D():Get( "Client", nView ) )->lBlqCli
            msgStop( "Cliente bloqueado, no se pueden realizar operaciones de venta" , "Imposible archivar como albarán" )
         end if

         if !( D():Get( "Client", nView ) )->lChgPre
            msgStop( "Este cliente no tiene autorización para venta a credito", "Imposible archivar como albarán" )
         end if

         if ( ( D():Get( "Client", nView ) )->lCreSol ) .and. ( nRieCli >= ( D():Get( "Client", nView ) )->Riesgo )
            msgStop( "Este cliente supera el limite de riesgo permitido.", "Imposible archivar como albarán" )
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

STATIC FUNCTION SetDlgMode( aTmp, aGet, oFld, nMode, oSayPr1, oSayPr2, oSayVp1, oSayVp2, oStkAct, oGet2, oTotal, aTmpAlb, oRentLin )

   local cCodArt        := Left( aGet[ _CREF ]:VarGet(), 18 )

   if !uFieldEmpresa( "lUseBultos" )
      aGet[ __NBULTOS ]:Hide()
   else
      if !Empty( aGet[ __NBULTOS ] )
         aGet[ __NBULTOS ]:SetText( uFieldempresa( "cNbrBultos" ) )
      end if 
   end if

   if !lUseCaj()
      aGet[ _NCANENT ]:Hide()
   else
      if !Empty( aGet[ _NCANENT ] )
         aGet[ _NCANENT ]:SetText( cNombreCajas() )
      end if
   end if

   // aGet[ _NUNICAJA ]:SetText( cNombreUnidades() )

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
      aGet[ _NPREUNIT ]:Hide()
      aGet[ _NPREALQ  ]:Show()
   end if

   do case
   case nMode == APPD_MODE

      aGet[ _CREF     ]:cText( Space( 200 ) )

      aTmp[ _LIVALIN  ] := aTmpAlb[ _LIVAINC ]
      aTmp[ _DFECCAD  ] := Ctod( "" )


      aGet[ _NCANENT  ]:cText( 1 )
      aGet[ _NUNICAJA ]:cText( 1 )

      if !Empty( aGet[ _NNUMLIN ] )
         aGet[ _NNUMLIN ]:cText( nLastNum( dbfTmpLin )  )
      end if

      aGet[ _CALMLIN ]:cText( aTmpAlb[ _CCODALM ] )

      if lTipMov() .and. aGet[ _CTIPMOV ] != nil
         aGet[ _CTIPMOV ]:cText( cDefVta() )
      end if

      /*if !Empty( aGet[ _LCONTROL] )
         aGet[ _LCONTROL]:Click( .f. )
      end if*/

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
         aGet[ _NIVA ]:cText( nIva( D():Get( "TIva", nView ), cDefIva() ) )
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

      if !Empty( cCodArt )
         aGet[ _CDETALLE ]:show()
         aGet[ _MLNGDES  ]:hide()
      else
         aGet[ _CDETALLE ]:hide()
         aGet[ _MLNGDES  ]:show()
      end if

   if !Empty( oStock )

      oStock:nPutStockActual( cCodArt, aTmp[ _CALMLIN ], aTmp[ _CVALPR1 ], aTmp[ _CVALPR2 ], aTmp[ _CLOTE ], aTmp[ _LKITART ], aTmp[ _NCTLSTK ], oStkAct )

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

   if ( Empty( aTmp[ _NPREUNIT ] ) .or. lUsrMaster() .or. oUser():lCambiarPrecio() ) .and. nMode != ZOOM_MODE

      if !Empty( aGet[ _NPREUNIT ] )
         aGet[ _NPREUNIT ]:HardEnable()
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

      aGet[ _NPREUNIT ]:HardDisable()
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

   if !Empty( aGet[ ( D():Get( "AlbCliL", nView ) )->( fieldpos( "nMedUno" ) ) ] )
      aGet[ ( D():Get( "AlbCliL", nView ) )->( fieldpos( "nMedUno" ) ) ]:Hide()
   end if

   if !Empty( aGet[ ( D():Get( "AlbCliL", nView ) )->( fieldpos( "nMedDos" ) ) ] )
      aGet[ ( D():Get( "AlbCliL", nView ) )->( fieldpos( "nMedDos" ) ) ]:Hide()
   end if

   if !Empty( aGet[ ( D():Get( "AlbCliL", nView ) )->( fieldpos( "nMedTre" ) ) ] )
      aGet[ ( D():Get( "AlbCliL", nView ) )->( fieldpos( "nMedTre" ) ) ]:Hide()
   end if

   if oUndMedicion:oDbf:Seek( aTmp[ _CUNIDAD ] )

      if !Empty( aGet[ ( D():Get( "AlbCliL", nView ) )->( fieldpos( "nMedUno" ) ) ] ) .and. oUndMedicion:oDbf:nDimension >= 1 .and. !Empty( oUndMedicion:oDbf:cTextoDim1 )
         aGet[ ( D():Get( "AlbCliL", nView ) )->( fieldpos( "nMedUno" ) ) ]:oSay:SetText( oUndMedicion:oDbf:cTextoDim1 )
         aGet[ ( D():Get( "AlbCliL", nView ) )->( fieldpos( "nMedUno" ) ) ]:Show()
      end if

      if !Empty( aGet[ ( D():Get( "AlbCliL", nView ) )->( fieldpos( "nMedDos" ) ) ] ) .and. oUndMedicion:oDbf:nDimension >= 2 .and. !Empty( oUndMedicion:oDbf:cTextoDim2 )
         aGet[ ( D():Get( "AlbCliL", nView ) )->( fieldpos( "nMedDos" ) ) ]:oSay:SetText( oUndMedicion:oDbf:cTextoDim2 )
         aGet[ ( D():Get( "AlbCliL", nView ) )->( fieldpos( "nMedDos" ) ) ]:Show()
      end if

      if !Empty( aGet[ ( D():Get( "AlbCliL", nView ) )->( fieldpos( "nMedTre" ) ) ] ) .and. oUndMedicion:oDbf:nDimension >= 3 .and. !Empty( oUndMedicion:oDbf:cTextoDim3 )
         aGet[ ( D():Get( "AlbCliL", nView ) )->( fieldpos( "nMedTre" ) ) ]:oSay:SetText( oUndMedicion:oDbf:cTextoDim3 )
         aGet[ ( D():Get( "AlbCliL", nView ) )->( fieldpos( "nMedTre" ) ) ]:Show()
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

   /*
   Focus al codigo-------------------------------------------------------------
   */

   aGet[ _CREF ]:SetFocus()

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

   if !Empty( oTotal )
      oTotal:cText( Round( nCalculo, nDouDiv ) )
   end if

   if oMargen != nil
      oMargen:cText( AllTrim( Trans( nMargen, cPorDiv ) + AllTrim( cSimDiv( cCodDiv, D():Get( "Divisas", nView ) ) ) + " : " + AllTrim( Trans( nRentabilidad, "999.99" ) ) + "%" ) )
   end if

   if !Empty( oComisionLinea )
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

   DEFAULT lFocused              := .t.

   if Empty( cCodArt )

      if lRetCodArt()
         MsgStop( "No se pueden añadir líneas sin codificar" )
         return .f.
      end if

      if Empty( aTmp[ _NIVA ] )
         aGet[ _NIVA ]:bWhen     := {|| .t. }
      end if

      if !Empty( aGet[ _CDETALLE ] )
          aGet[ _CDETALLE ]:cText( Space( 50 ) )
      end if

      aGet[ _CDETALLE ]:bWhen    := {|| .t. }
      aGet[ _CDETALLE ]:Hide()

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

      cCodArt                 := cSeekCodebar( cCodArt, dbfCodebar, D():Articulos( nView ) )

      /*
      Ahora buscamos por el codigo interno-------------------------------------
      */

      if aSeekProp( @cCodArt, @cValPr1, @cValPr2, D():Articulos( nView ), dbfTblPro )

         if ( D():Articulos( nView ) )->lObs
            MsgStop( "Artículo catalogado como obsoleto" )
            return .f.
         end if

         if ( lChgCodArt )

            cCodArt              := ( D():Articulos( nView ) )->Codigo

            aGet[ _CREF ]:cText( Padr( cCodArt, 200 ) )
            aTmp[ _CREF ]        := cCodArt

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

            aTmp[ _CREFPRV ]     := Padr( cRefPrvArt( aTmp[ _CREF ], ( D():Articulos( nView ) )->cPrvHab , dbfArtPrv ), 18 )

            aGet[ _CDETALLE ]:show()
            aGet[ _MLNGDES  ]:hide()

            aGet[ _CDETALLE ]:cText( ( D():Articulos( nView ) )->Nombre )
            aGet[ _MLNGDES  ]:cText( ( D():Articulos( nView ) )->Nombre )

            // Ultima fecha de venta-------------------------------------------

            aTmp[ _DFECULTCOM ]  := dFechaUltimaVenta( aTmpAlb[ _CCODCLI ], aTmp[ _CREF ], D():Get( "AlbCliL", nView ), D():Get( "FacCliL", nView ), D():Get( "FacCliT", nView ), D():Get( "FacCliL", nView ), dbfTikL )
            aTmp[ _DUNIULTCOM ]  := nUnidadesUltimaVenta( aTmpAlb[ _CCODCLI ], aTmp[ _CREF ], D():Get( "AlbCliL", nView ), D():Get( "FacCliL", nView ), D():Get( "FacCliT", nView ), D():Get( "FacCliL", nView ), dbfTikL )

            // Buscamos la familia del articulo y anotamos las propiedades--------
   
            aTmp[ _CCODPR1 ]     := ( D():Articulos( nView ) )->cCodPrp1
            aTmp[ _CCODPR2 ]     := ( D():Articulos( nView ) )->cCodPrp2
   
            if !Empty( aTmp[ _CCODPR1 ] ) .and. !Empty( aGet[ _CVALPR1 ] )
   
               if !Empty( cValPr1 )
                  aGet[ _CVALPR1 ]:cText( cCodPrp( aTmp[ _CCODPR1 ], cValPr1, dbfTblPro ) )
                  aGet[ _CVALPR1 ]:lValid()
               end if
   
            end if
   
            if !empty( aTmp[ _CCODPR2 ] ) .and. !Empty( aGet[ _CVALPR2 ] )
   
               if !Empty( cValPr2 )
                  aGet[ _CVALPR2 ]:cText( cCodPrp( aTmp[ _CCODPR2 ], cValPr2, dbfTblPro ) )
                  aGet[ _CVALPR2 ]:lValid()
               end if
   
            end if

            /*
            Descripciones largas--------------------------------------------------
            */

            if !empty( ( D():Articulos( nView ) )->Descrip )

               if aGet[ _MLNGDES ] != nil
                  aGet[ _MLNGDES ]:cText( ( D():Articulos( nView ) )->Descrip )
               else
                  aTmp[ _MLNGDES ]  := ( D():Articulos( nView ) )->Descrip
               end if           
   
               if !Empty( aGet[ _DESCRIP ] )
                  aGet[ _DESCRIP ]:cText( ( D():Articulos( nView ) )->Descrip )
               else
                  aTmp[ _DESCRIP ]  := ( D():Articulos( nView ) )->Descrip
               end if

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
            Cogemos las familias y los grupos de familias----------------------
            */

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
            Tratamientos kits-----------------------------------------------------
            */

            if ( D():Articulos( nView ) )->lKitArt

               aTmp[ _LKITART ]     := ( D():Articulos( nView ) )->lKitArt                        // Marcamos como padre del kit
               aTmp[ _LIMPLIN ]     := lImprimirCompuesto( ( D():Articulos( nView ) )->Codigo, D():Articulos( nView ) ) // 1 Todos, 2 Compuesto
               aTmp[ _LKITPRC ]     := lPreciosCompuestos( ( D():Articulos( nView ) )->Codigo, D():Articulos( nView ) ) // 1 Todos, 2 Compuesto

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
            Preguntamos si el regimen de impuestos es distinto de Exento-------------
            */

            if aTmpAlb[ _NREGIVA ] <= 1
               aGet[ _NIVA ]:cText( nIva( D():Get( "TIva", nView ), ( D():Articulos( nView ) )->TipoIva ) )
               aTmp[ _NREQ ]        := nReq( D():Get( "TIva", nView ), ( D():Articulos( nView ) )->TipoIva )
            end if

            /*
            Ahora recogemos el impuesto especial si lo hay---------------------
            */

            if !Empty( ( D():Articulos( nView ) )->cCodImp )

               aTmp[ _CCODIMP ]     := ( D():Articulos( nView ) )->cCodImp
               aGet[ _NVALIMP ]:cText( oNewImp:nValImp( ( D():Articulos( nView ) )->cCodImp ) )
               aTmp[ _LVOLIMP ]     := RetFld( ( D():Articulos( nView ) )->cCodImp, oNewImp:oDbf:cAlias, "lIvaVol" )

            end if

            if ( D():Articulos( nView ) )->nCajEnt != 0
               aGet[ _NCANENT ]:cText( ( D():Articulos( nView ) )->nCajEnt )
            end if

            if ( D():Articulos( nView ) )->nUniCaja != 0
               aGet[ _NUNICAJA ]:cText( ( D():Articulos( nView ) )->nUniCaja )
            end if

            /*
            Si la comisi¢n del articulo hacia el agente es distinto de cero----
            */

            aGet[ _NCOMAGE ]:cText( aTmpAlb[ _NPCTCOMAGE ] )

            /*
            No permitir venta sin stock----------------------------------------
            */

            aTmp[ _LMSGVTA ]     := ( D():Articulos( nView ) )->lMsgVta
            aTmp[ _LNOTVTA ]     := ( D():Articulos( nView ) )->lNotVta

            if ( D():Articulos( nView ) )->lFacCnv
               aTmp[ _NFACCNV ]  := ( D():Articulos( nView ) )->nFacCnv
            end if

            /*
            Tipo de articulo---------------------------------------------------
            */

            if !Empty( aGet[ _CCODTIP ] )
               aGet[ _CCODTIP ]:cText( ( D():Articulos( nView ) )->cCodTip )
            end if

            /*
            Imagen del producto------------------------------------------------
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
            Buscamos la familia del articulo y anotamos las propiedades--------
            */

            aTmp[ _CCODPR1 ]   := ( D():Articulos( nView ) )->cCodPrp1
            aTmp[ _CCODPR2 ]   := ( D():Articulos( nView ) )->cCodPrp2

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
                  oSayPr2:SetText( retProp( ( D():Articulos( nView ) )->cCodPrp2, dbfPro ) )
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

         if ( lChgCodArt ) .or. ( lChgPrpArt )

            // Tomamos el valor de la familia----------------------------------

            if nMode == APPD_MODE
               cCodFam        := RetFamArt( cCodArt, D():Articulos( nView ) )
            else
               cCodFam        := aTmp[ _CCODFAM ]
            end if

            //--Tomamos el precio recomendado, el costo y el punto verde--//

            aTmp[ _NPVSATC ]      := ( D():Articulos( nView ) )->PvpRec

            if !Empty( aGet[ _NPNTVER ] )
               aGet[ _NPNTVER ]:cText( ( D():Articulos( nView ) )->nPntVer1 )
            end if
         
            /*
            Descuento de artículo----------------------------------------------
            */

            nNumDto              := RetFld( aTmpAlb[ _CCODCLI ], D():Get( "Client", nView ), "nDtoArt" )

            if nNumDto != 0

               do case
                  case nNumDto == 1

                     if !Empty( aGet[ _NDTO ] )
                        aGet[ _NDTO ]:cText( ( D():Articulos( nView ) )->nDtoArt1 )
                        aTmp[ _NDTO ]     := ( D():Articulos( nView ) )->nDtoArt1
                     else
                        aTmp[ _NDTO ]     := ( D():Articulos( nView ) )->nDtoArt1
                     end if

                  case nNumDto == 2

                     if !Empty( aGet[ _NDTO ] )
                        aGet[ _NDTO ]:cText( ( D():Articulos( nView ) )->nDtoArt2 )
                        aTmp[ _NDTO ]     := ( D():Articulos( nView ) )->nDtoArt2
                     else
                        aTmp[ _NDTO ]     := ( D():Articulos( nView ) )->nDtoArt2
                     end if

                  case nNumDto == 3

                     if !Empty( aGet[ _NDTO ] )
                        aGet[ _NDTO ]:cText( ( D():Articulos( nView ) )->nDtoArt3 )
                        aTmp[ _NDTO ]     := ( D():Articulos( nView ) )->nDtoArt3
                     else
                        aTmp[ _NDTO ]     := ( D():Articulos( nView ) )->nDtoArt3
                     end if

                  case nNumDto == 4

                     if !Empty( aGet[ _NDTO ] )
                        aGet[ _NDTO ]:cText( ( D():Articulos( nView ) )->nDtoArt4 )
                        aTmp[ _NDTO ]     := ( D():Articulos( nView ) )->nDtoArt4
                     else
                        aTmp[ _NDTO ]     := ( D():Articulos( nView ) )->nDtoArt4
                     end if

                  case nNumDto == 5

                     if !Empty( aGet[ _NDTO ] )
                        aGet[ _NDTO ]:cText( ( D():Articulos( nView ) )->nDtoArt5 )
                        aTmp[ _NDTO ]     := ( D():Articulos( nView ) )->nDtoArt5
                     else
                        aTmp[ _NDTO ]     := ( D():Articulos( nView ) )->nDtoArt5
                     end if

                  case nNumDto == 6

                     if !Empty( aGet[ _NDTO ] )
                        aGet[ _NDTO ]:cText( ( D():Articulos( nView ) )->nDtoArt6 )
                        aTmp[ _NDTO ]     := ( D():Articulos( nView ) )->nDtoArt6
                     else
                        aTmp[ _NDTO ]     := ( D():Articulos( nView ) )->nDtoArt6
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
               aGet[ _CUNIDAD ]:cText( ( D():Articulos( nView ) )->cUnidad )
            else
               aTmp[ _CUNIDAD ]  := ( D():Articulos( nView ) )->cUnidad
            end if

            // Tomamos el precio del articulo dependiento de las propiedades---

            nPrePro           := nPrePro( aTmp[ _CREF ], aTmp[ _CCODPR1 ], aTmp[ _CVALPR1 ], aTmp[ _CCODPR2 ], aTmp[ _CVALPR2 ], aTmp[ _NTARLIN ], aTmpAlb[ _LIVAINC ], dbfArtDiv, dbfTarPreL, aTmpAlb[_CCODTAR] )
            if nPrePro == 0
               if !Empty( aGet[ _NPREUNIT ] )
                  aGet[ _NPREUNIT ]:cText( nRetPreArt( aTmp[ _NTARLIN ], aTmpAlb[ _CDIVALB ], aTmpAlb[_LIVAINC], D():Articulos( nView ), D():Get( "Divisas", nView ), dbfKit, D():Get( "TIva", nView ) ) )
               end if
            else
               aGet[ _NPREUNIT ]:cText( nPrePro )
            end if

            if aTmp[ __LALQUILER ]
               aGet[ _NPREUNIT ]:cText( 0 )
               aGet[ _NPREALQ ]:cText( nPreAlq( aTmp[ _CREF ], aTmp[ _NTARLIN ], aTmpAlb[_LIVAINC], D():Articulos( nView ) ) )
            end if

            /*
            Precios por tarifas------------------------------------------------
            */

            if !Empty( aTmpAlb[ _CCODTAR ] )

               /*
               Precio
               */

               nImpOfe     := RetPrcTar( aTmp[ _CREF ], aTmpAlb[ _CCODTAR ], aTmp[ _CCODPR1 ], aTmp[ _CCODPR2 ], aTmp[ _CVALPR1 ], aTmp[ _CVALPR2 ], dbfTarPreL, aTmp[ _NTARLIN ] )
               if nImpOfe  != 0
                  aGet[ _NPREUNIT ]:cText( nImpOfe )
               end if

               //--Descuento porcentual--//

               nImpOfe     := RetPctTar( aTmp[ _CREF ], cCodFam, aTmpAlb[ _CCODTAR ], aTmp[ _CCODPR1 ], aTmp[ _CCODPR2 ], aTmp[ _CVALPR1 ], aTmp[ _CVALPR2 ], dbfTarPreL )
               if nImpOfe  != 0
                  aGet[ _NDTO    ]:cText( nImpOfe )
               end if

               //--Descuento Lineal--//
               nImpOfe     := RetLinTar( aTmp[ _CREF ], cCodFam, aTmpAlb[_CCODTAR], aTmp[_CCODPR1], aTmp[_CCODPR2], aTmp[_CVALPR1], aTmp[_CVALPR2], dbfTarPreL )
               if nImpOfe  != 0
                  aGet[ _NDTODIV ]:cText( nImpOfe )
               end if

               //--comisión de agente--//

               nImpOfe     := RetComTar( aTmp[ _CREF ], cCodFam, aTmpAlb[_CCODTAR], aTmp[_CCODPR1], aTmp[_CCODPR2], aTmp[_CVALPR1], aTmp[_CVALPR2], aTmpAlb[_CCODAGE], dbfTarPreL, dbfTarPreS )

               if nImpOfe  != 0
                  aGet[ _NCOMAGE ]:cText( nImpOfe )
               end if

               //--Descuento de promoci¢n--//

               nImpOfe     := RetDtoPrm( aTmp[ _CREF ], cCodFam, aTmpAlb[_CCODTAR], aTmp[_CCODPR1], aTmp[_CCODPR2], aTmp[_CVALPR1], aTmp[_CVALPR2], aTmpAlb[_DFECALB], dbfTarPreL )
               if nImpOfe  != 0
                  aGet[ _NDTOPRM ]:cText( nImpOfe )
               end if

               //--Descuento de promoci¢n para agente--//

               nDtoAge     := RetDtoAge( aTmp[ _CREF ], cCodFam, aTmpAlb[_CCODTAR], aTmp[_CCODPR1], aTmp[_CCODPR2], aTmp[_CVALPR1], aTmp[_CVALPR2], aTmpAlb[_DFECALB], aTmpAlb[_CCODAGE], dbfTarPreL, dbfTarPreS )
               if nDtoAge  != 0
                  aGet[ _NCOMAGE ]:cText( nDtoAge )
               end if

            end if

            /*
            Chequeamos las atipicas del cliente--------------------------------
            */

            hAtipica := hAtipica( hValue( aTmp, aTmpAlb ) )

            if !Empty( hAtipica )

               if hhaskey( hAtipica, "nImporte" )
                  if hAtipica[ "nImporte" ] != 0
                     aGet[ _NPREUNIT ]:cText( hAtipica[ "nImporte" ] )
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

            ValidaMedicion( aTmp, aGet )

         end if

         /*
         Solo si cambia el lote, cargamos la fecha de caducidad y el costo
         */

         if ( lChgCodArt ) .or. ( lChgLotArt)

            //Lotes------------------------------------------------------------

            if ( D():Articulos( nView ) )->lLote

               aTmp[ _LLOTE ]       := ( D():Articulos( nView ) )->lLote

               if Empty( cLote )
                  cLote             := ( D():Articulos( nView ) )->cLote
               end if 

               if !Empty( aGet[ _CLOTE ] )

                  aGet[ _CLOTE ]:Show()

                  if Empty( aGet[ _CLOTE ]:VarGet() )
                     aGet[ _CLOTE ]:cText( cLote )
                  end if

               else

                  if Empty( aTmp[ _CLOTE ] )
                     aTmp[ _CLOTE ] := cLote 
                  end if

               end if

               //Fecha de caducidad--------------------------------------------

               if Empty( dFechaCaducidad )
                  dFechaCaducidad      := dFechaCaducidadLote( aTmp[ _CREF ], aTmp[ _CVALPR1 ], aTmp[ _CVALPR2 ], aTmp[ _CLOTE ], dbfAlbPrvL, dbfFacPrvL, dbfProLin )
               end if 

               if !Empty( aGet[ _DFECCAD ] )

                  aGet[ _DFECCAD ]:Show()

                  if Empty( aGet[ _DFECCAD ]:VarGet() ) .or. ( dFechaCaducidad != dOldFecCad )
                     aGet[ _DFECCAD ]:cText( dFechaCaducidad )
                  end if

               else 

                  if Empty( aTmp[ _DFECCAD ] )
                     aTmp[ _DFECCAD ]  := dFechaCaducidad
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
            Cargamos los costos
            */

            if !uFieldEmpresa( "lCosAct" )

               nCosPro           := oStock:nCostoMedio( aTmp[ _CREF ], aTmp[ _CALMLIN ], aTmp[ _CCODPR1 ], aTmp[ _CCODPR2 ], aTmp[ _CVALPR1 ], aTmp[ _CVALPR2 ], aTmp[ _CLOTE ] )

               if nCosPro == 0
                  nCosPro        := nCosto( aTmp[ _CREF ], D():Articulos( nView ), dbfKit, .f., , D():Get( "Divisas", nView ) )
               end if
            else
               nCosPro           := nCosto( aTmp[ _CREF ], D():Articulos( nView ), dbfKit, .f., , D():Get( "Divisas", nView ) )
            end if

            if aGet[ _NCOSDIV ] != nil
               aGet[ _NCOSDIV ]:cText( nCosPro )
            else
               aTmp[ _NCOSDIV ]  := nCosPro
            end if

         end if 

         /*
         Calculamos el stock del articulo solo si cambian las prop o el lote---
         */

         if ( lChgCodArt ) .or. ( lChgPrpArt ) .or. ( lChgLotArt )

            if !uFieldempresa( "lNStkAct") .and. oStkAct != nil .and. aTmp[ _NCTLSTK ] <= 1
               oStock:nPutStockActual( aTmp[ _CREF ], aTmp[ _CALMLIN ],aTmp[ _CVALPR1 ], aTmp[ _CVALPR2 ], aTmp[ _CLOTE ], aTmp[ _LKITART ], aTmp[ _NCTLSTK ], oStkAct )
            end if

         end if 

         /*
         Buscamos si hay ofertas-----------------------------------------------
         */

         lBuscaOferta( aTmp[ _CREF ], aGet, aTmp, aTmpAlb, dbfKit )

         /*
         Cargamos los valores para los cambios---------------------------------
         */

         cOldPrpArt     := cPrpArt
         cOldCodArt     := cCodArt
         cOldLotArt     := aTmp[ _CLOTE ]
         dOldFecCad     := dFechaCaducidad

         /*
         Solo pueden modificar los precios los administradores--------------
         */

         if Empty( aTmp[ _NPREUNIT ] ) .or. lUsrMaster() .or. oUser():lCambiarPrecio()

            if !Empty( aGet[ _NPREUNIT ] )
                aGet[ _NPREUNIT ]:HardEnable()
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

            aGet[ _NPREUNIT ]:HardDisable() 
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

   local aClo     
   local aXbyStr     := { 0, 0 }
   local nTotUnd 
   local hAtipica 

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
      return nil
   end if

   if !cAlmacen( aGet[ _CALMLIN ], dbfAlm )
      return nil
   end if

   // control de precios minimos-----------------------------------------------

   if lPrecioMinimo( aTmp[ _CREF ], aTmp[ _NPREUNIT ], nMode, D():Articulos( nView ) )
      msgStop( "El precio de venta es inferior al precio mínimo.")
      return nil
   end if 

   /*
   Comprobamos si tiene que introducir números de serie------------------------
   */

   if ( nMode == APPD_MODE ) .and. RetFld( aTmp[ _CREF ], D():Articulos( nView ), "lNumSer" ) .and. !( dbfTmpSer )->( dbSeek( Str( aTmp[ _NNUMLIN ], 4 ) + aTmp[ _CREF ] ) )
      MsgStop( "Tiene que introducir números de serie para este artículo." )
      oBtnSer:Click()
      return nil 
   end if

   if !Empty( aTmp[ _CREF ] ) .and. ( aTmp[ _LNOTVTA ] .or. aTmp[ _LMSGVTA ] )

      nTotUnd     := nTotNAlbCli( aTmp )

      if nMode == EDIT_MODE
         nTotUnd  -= nTotNAlbCli( dbfTmpLin )
      end if

      if !lCompruebaStock( aTmp, oStock, nTotUnd, nStkAct )
         return nil
      end if   

   end if

   CursorWait()

   aClo              := aClone( aTmp )

   aTmp[ _NREQ ]     := nPReq( D():Get( "TIva", nView ), aTmp[ _NIVA ] )

   if nMode == APPD_MODE

      if aTmp[ _LLOTE ]
         GraLotArt( aTmp[ _CREF ], D():Articulos( nView ), aTmp[ _CLOTE ] )
      end if

      /*
      Buscamos si existen atipicas de clientes---------------------------------
      */

      hAtipica := hAtipica( hValue( aTmp, aTmpAlb ) )

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

            aXbyStr              := nXbYOferta( RetFld( aTmp[ _CREF ], D():Articulos( nView ), "FAMILIA", "CODIGO" ), aTmpAlb[ _CCODCLI ], aTmpAlb[ _CCODGRP ], aTmp[ _NCANENT ], aTmp[ _NUNICAJA ], aTmpAlb[ _DFECALB ], dbfOferta, 2 )

            if aXbYStr[ 1 ] != 0
               aTmp[ _LLINOFE ]  := .t.
            end if

         end if

         /*
         Chequeamos las ofertas por tipo de artículos X  *  Y------------------
         */

         if !aTmp[ _LLINOFE ]

            aXbyStr              := nXbYOferta( RetFld( aTmp[ _CREF ], D():Articulos( nView ), "CCODTIP", "CODIGO" ), aTmpAlb[ _CCODCLI ], aTmpAlb[ _CCODGRP ], aTmp[ _NCANENT ], aTmp[ _NUNICAJA ], aTmpAlb[ _DFECALB ], dbfOferta, 3 )

            if aXbYStr[ 1 ] != 0
               aTmp[ _LLINOFE ]  := .t.
            end if

         end if

         /*
         Chequeamos las ofertas por categoria X  *  Y--------------------------
         */

         if !aTmp[ _LLINOFE ]

            aXbyStr              := nXbYOferta( RetFld( aTmp[ _CREF ], D():Articulos( nView ), "CCODCATE", "CODIGO" ), aTmpAlb[ _CCODCLI ], aTmpAlb[ _CCODGRP ], aTmp[ _NCANENT ], aTmp[ _NUNICAJA ], aTmpAlb[ _DFECALB ], dbfOferta, 4 )

            if aXbYStr[ 1 ] != 0
               aTmp[ _LLINOFE ]  := .t.
            end if

         end if

         /*
         Chequeamos las ofertas por temporada X  *  Y--------------------------
         */

         if !aTmp[ _LLINOFE ]

            aXbyStr              := nXbYOferta( RetFld( aTmp[ _CREF ], D():Articulos( nView ), "CCODTEMP", "CODIGO" ), aTmpAlb[ _CCODCLI ], aTmpAlb[ _CCODGRP ], aTmp[ _NCANENT ], aTmp[ _NUNICAJA ], aTmpAlb[ _DFECALB ], dbfOferta, 5 )

            if aXbYStr[ 1 ] != 0
               aTmp[ _LLINOFE ]  := .t.
            end if

         end if

         /*
         Chequeamos las ofertas por fabricante X  *  Y-------------------------
         */

         if !aTmp[ _LLINOFE ]

            aXbyStr              := nXbYOferta( RetFld( aTmp[ _CREF ], D():Articulos( nView ), "CCODFAB", "CODIGO" ), aTmpAlb[ _CCODCLI ], aTmpAlb[ _CCODGRP ], aTmp[ _NCANENT ], aTmp[ _NUNICAJA ], aTmpAlb[ _DFECALB ], dbfOferta, 6 )

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

            WinGather( aTmp, , dbfTmpLin, oBrw, nMode, nil, .f. )

            if aClo[ _LKITART ]
               AppendKit( aClo, aTmpAlb )
            end if

            /*
            Cajas a regalar----------------------------------------------------
            */

            aTmp[ _NCANENT  ] := aXbYStr[ 2 ]
            aTmp[ _NPREUNIT ] := 0
            aTmp[ _NDTO ]     := 0
            aTmp[ _NDTODIV ]  := 0
            aTmp[ _NDTOPRM ]  := 0
            aTmp[ _NCOMAGE ]  := 0

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

            aTmp[ _NPREUNIT ] := 0
            aTmp[ _NDTO ]     := 0
            aTmp[ _NDTODIV ]  := 0
            aTmp[ _NDTOPRM ]  := 0
            aTmp[ _NCOMAGE ]  := 0

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

      aTmp[ __NFACTURADO ]    := 1

      SysRefresh()

      if !Empty( aGet[ _CREF ] )
         aGet[ _CREF ]:SetFocus()
      end if

   else

      oDlg:End( IDOK )

   end if

   CursorWE()

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
   Guardamos los productos kits------------------------------------------------
   */

   if ( dbfKit )->( dbSeek( cCodArt ) )

      while ( dbfKit )->cCodKit == cCodArt .and. !( dbfKit )->( eof() )

         if ( D():Articulos( nView ) )->( dbSeek( ( dbfKit )->cRefKit ) )

            ( dbfTmpLin )->( dbAppend() )

            if lKitAsociado( cCodArt, D():Articulos( nView ) )
               ( dbfTmpLin )->nNumLin  := nLastNum( dbfTmpLin )
               ( dbfTmpLin )->lKitChl  := .f.
            else
               ( dbfTmpLin )->nNumLin  := nNumLin
               ( dbfTmpLin )->lKitChl  := .t.
            end if

            ( dbfTmpLin )->cRef        := ( dbfKit      )->cRefKit
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
            ( dbfTmpLin )->cGrpFam     := cGruFam( ( dbfTmpLin )->cCodFam, dbfFamilia )

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

            if !Empty( nIvaLin )
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
               ( dbfTmpLin )->nPreUnit := nRetPreArt( nTarLin, aTmpAlb[ _CDIVALB ], aTmpAlb[ _LIVAINC ], D():Articulos( nView ), D():Get( "Divisas", nView ), dbfKit, D():Get( "TIva", nView ) )
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

   if !lValidaOperacion( aTmp[ _DFECALB ] )
      Return .f.
   end if

   /*
   Estos campos no pueden estar vacios-----------------------------------------
   */

   if Empty( aTmp[ _CCODCLI ] )
      msgStop( "Código de cliente no puede estar vacío." )
      aGet[ _CCODCLI ]:SetFocus()
      return .f.
   end if

   if lCliBlq( aTmp[ _CCODCLI ], D():Get( "Client", nView ) )
      msgStop( "Cliente bloqueado, no se pueden realizar operaciones de venta" , "Imposible archivar como albarán" )
      aGet[ _CCODCLI ]:SetFocus()
      return .f.
   end if

   if !lCliChg( aTmp[ _CCODCLI ], D():Get( "Client", nView ) )
      msgStop( "Este cliente no tiene autorización para venta a credito.", "Imposible archivar como albarán" )
      aGet[ _CCODCLI ]:SetFocus()
      return .f.
   end if

   if lClienteEvaluarRiesgo( aTmp[ _CCODCLI ], oStock, D():Get( "Client", nView ) )
      msgStop( "Este cliente supera el limite de riesgo permitido.", "Imposible archivar como albarán" )
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
   Guardamos el tipo para alquileres-------------------------------------------
   */

   if !Empty( oTipAlb ) .and. oTipAlb:nAt == 2
      aTmp[ _LALQUILER ]   := .t.
   else
      aTmp[ _LALQUILER ]   := .f.
   end if

   do case
   case nMode == APPD_MODE .or. nMode == DUPL_MODE

      nNumAlb              := nNewDoc( aTmp[ _CSERALB ], D():Get( "AlbCliT", nView ), "NALBCLI", , D():Get( "NCount", nView ) )
      aTmp[ _NNUMALB ]     := nNumAlb
      nTotOld              := 0

   case nMode == EDIT_MODE

      while ( D():Get( "AlbCliL", nView ) )->( dbSeek( cSerAlb + str( nNumAlb ) + cSufAlb ) ) .and. !( D():Get( "AlbCliL", nView ) )->( eof() )
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

   end case

   /*
   Guardamos el albaran--------------------------------------------------------
   */

   ( dbfTmpLin )->( dbGoTop() )
   while !( dbfTmpLin )->( eof() )

      if !( ( dbfTmpLin )->nUniCaja == 0 .and. ( dbfTmpLin )->lFromAtp )

         ( dbfTmpLin )->dFecAlb  := aTmp[ _DFECALB ]
         ( dbfTmpLin )->cCodCli  := aTmp[ _CCODCLI ]

         dbPass( dbfTmpLin, D():Get( "AlbCliL", nView ), .t., cSerAlb, nNumAlb, cSufAlb )

      end if   

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

   WinGather( aTmp, , D():Get( "AlbCliT", nView ), , nMode )

   /*
   Actualizamos el stock en la web------------------------------------------
   */

   ActualizaStockWeb( cSerAlb + Str( nNumAlb ) + cSufAlb )

   /*
   Ahora escribimos en el fichero definitivo-----------------------------------
   */

   ( dbfTmpPgo )->( dbGoTop() )
   while ( dbfTmpPgo )->( !eof() )
      dbPass( dbfTmpPgo, D():Get( "AlbCliP", nView ), .t., cSerAlb, nNumAlb, cSufAlb )
      ( dbfTmpPgo )->( dbSkip() )
   end while

   /*
   Ahora escribimos en el fichero definitivo-----------------------------------
   */

   ( dbfTmpInc )->( dbGoTop() ) 
   while ( dbfTmpInc )->( !eof() )
      dbPass( dbfTmpInc, D():Get( "AlbCliI", nView ), .t., cSerAlb, nNumAlb, cSufAlb )
      ( dbfTmpInc )->( dbSkip() )
   end while

   /*
   Ahora escribimos en el fichero definitivo-----------------------------------
   */

   ( dbfTmpDoc )->( dbGoTop() )
   while ( dbfTmpDoc )->( !eof() )
      dbPass( dbfTmpDoc, D():Get( "AlbCliD", nView ), .t., cSerAlb, nNumAlb, cSufAlb )
      ( dbfTmpDoc )->( dbSkip() )
   end while

   /*
   Ahora escribimos en el fichero definitivo-----------------------------------
   */

   ( dbfTmpSer )->( dbGoTop() )
   while ( dbfTmpSer )->( !eof() )
      dbPass( dbfTmpSer, D():Get( "AlbCliS", nView ), .t., cSerAlb, nNumAlb, cSufAlb, dFecAlb )
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

Static Function YearComboBoxChange()

   if oWndBrw:oWndBar:lAllYearComboBox()
      DestroyFastFilter( D():Get( "AlbCliT", nView ) )
      CreateUserFilter( "", D():Get( "AlbCliT", nView ), .f., , , "all" )
   else
      DestroyFastFilter( D():Get( "AlbCliT", nView ) )
      CreateUserFilter( "Year( Field->dFecAlb ) == " + oWndBrw:oWndBar:cYearComboBox(), D():Get( "AlbCliT", nView ), .f., , , "Year( Field->dFecAlb ) == " + oWndBrw:oWndBar:cYearComboBox() )
   end if

   ( D():Get( "AlbCliT", nView ) )->( dbGoTop() )

   oWndBrw:Refresh()

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

      sOfeArt     := sOfertaArticulo( cCodArt, aTmpAlb[ _CCODCLI ], aTmpAlb[ _CCODGRP ], aTmp[ _NUNICAJA ], aTmpAlb[ _DFECALB ], dbfOferta, aTmp[ _NTARLIN ], , aTmp[_CCODPR1], aTmp[_CCODPR2], aTmp[_CVALPR1], aTmp[_CVALPR2], aTmp[ _CDIVALB ], D():Articulos( nView ), D():Get( "Divisas", nView ), dbfKit, D():Get( "TIva", nView ), aTmp[ _NCANENT ], nTotalLinea )

      if !Empty( sOfeArt ) 
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

         sOfeArt     := sOfertaTipoArticulo( ( D():Articulos( nView ) )->cCodTip, aTmpAlb[ _CCODCLI ], aTmpAlb[ _CCODGRP ], aTmpAlb[ _DFECALB ], dbfOferta, aTmp[ _NTARLIN ], D():Articulos( nView ), aTmp[ _NUNICAJA ], aTmp[ _NCANENT ], nTotalLinea )

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

         sOfeArt     := sOfertaCategoria( ( D():Articulos( nView ) )->cCodCate, aTmpAlb[ _CCODCLI ], aTmpAlb[ _CCODGRP ], aTmpAlb[ _DFECALB ], dbfOferta, aTmp[ _NTARLIN ], D():Articulos( nView ), aTmp[ _NUNICAJA ], aTmp[ _NCANENT ], nTotalLinea )

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

         sOfeArt     := sOfertaTemporada( ( D():Articulos( nView ) )->cCodTemp, aTmpAlb[ _CCODCLI ], aTmpAlb[ _CCODGRP ], aTmpAlb[ _DFECALB ], dbfOferta, aTmp[ _NTARLIN ], D():Articulos( nView ), aTmp[ _NUNICAJA ], aTmp[ _NCANENT ], nTotalLinea )

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

         sOfeArt     := sOfertaFabricante( ( D():Articulos( nView ) )->cCodFab, aTmpAlb[ _CCODCLI ], aTmpAlb[ _CCODGRP ], aTmpAlb[ _DFECALB ], dbfOferta, aTmp[ _NTARLIN ], D():Articulos( nView ), aTmp[ _NUNICAJA ], aTmp[ _NCANENT ], nTotalLinea )

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
      ( dbfTmpSer )->nFacturado  := aTmp[ __NFACTURADO ]
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
   local cPedido  := aGet[ _CNUMPRE ]:VarGet()
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

STATIC FUNCTION cSatCli( aGet, aTmp, oBrw, nMode )

   local lValid   := .f.
   local cDesAlb
   local cNumSat  := aGet[ _CNUMSAT ]:VarGet()

   if nMode != APPD_MODE .OR. Empty( cNumSat )
      return .t.
   end if

   if dbSeekInOrd( cNumSat, "nNumSat", dbfSatCliT )

      if ( dbfSatCliT )->lEstado

         MsgStop( "S.A.T. ya procesado" )
         lValid   := .f.

      else

         CursorWait()

         HideImportacion( aGet, aGet[ _CNUMSAT ] )

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

         if ( dbfSatCliL )->( dbSeek( cNumSat ) )

            ( dbfTmpLin )->( dbAppend() )
            cDesAlb                    := ""
            cDesAlb                    += "S.A.T. Nº " + ( dbfSatCliT )->cSerSat + "/" + AllTrim( Str( ( dbfSatCliT )->nNumSat ) ) + "/" + ( dbfSatCliT )->cSufSat
            cDesAlb                    += " - Fecha " + Dtoc( ( dbfSatCliT )->dFecSat )
            ( dbfTmpLin )->MLNGDES     := cDesAlb
            ( dbfTmpLin )->LCONTROL    := .t.

            while ( (dbfSatCliL)->cSerSat + Str( (dbfSatCliL)->nNumSat ) + (dbfSatCliL)->cSufSat == cNumSat )

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
               (dbfTmpLin)->cNumSat    := cNumSat
               (dbfTmpLin)->nBultos    := (dbfSatCliL)->nBultos
               (dbfTmpLin)->cFormato   := (dbfSatCliL)->cFormato

               (dbfSatCliL)->( dbSkip() )

            end while

            ( dbfTmpLin )->( dbGoTop() )

            /*
            Pasamos las incidencias del SAT----------------------------
            */

            if ( dbfSatCliI )->( dbSeek( cNumSat ) )

               while ( dbfSatCliI )->cSerSat + Str( ( dbfSatCliI )->nNumSat ) + ( dbfSatCliI )->cSufSat == cNumSat .and. !( dbfSatCliI )->( Eof() )
                  dbPass( dbfSatCliI, dbfTmpInc, .t. )
                  ( dbfSatCliI )->( dbSkip() )
               end while

            end if

            ( dbfSatCliI )->( dbGoTop() )

            /*
            Pasamos los documentos del SAT-----------------------------
            */

            if ( dbfSatCliD )->( dbSeek( cNumSat ) )

               while ( dbfSatCliD )->cSerSat + Str( ( dbfSatCliD )->nNumSat ) + ( dbfSatCliD )->cSufSat == cNumSat .and. !( dbfSatCliD )->( Eof() )
                  dbPass( dbfSatCliD, dbfTmpDoc, .t. )
                  ( dbfSatCliD )->( dbSkip() )
               end while

            end if 
   
            /*
            Pasamos todas las series----------------------------------------------
            */

            if ( dbfSatCliS )->( dbSeek( cNumSat ) )

               while ( dbfSatCliS )->cSerSat + Str( ( dbfSatCliS )->nNumSat ) + ( dbfSatCliS )->cSufSat == cNumSat .and. !( dbfSatCliS )->( Eof() )
                  dbPass( dbfSatCliS, dbfTmpSer, .t. )
                  ( dbfSatCliS )->( dbSkip() )
               end while

            end if 

            oBrw:Refresh()
            oBrw:SetFocus()

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

      oBrwLin                       := IXBrowse():New( oDlg )

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
         :cHeader          := "Dirección"
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
         :cEditPicture     := cPorDiv()
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

      HideImportacion( aGet )      

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
               ( dbfTmpLin )->lMsgVta     := ( dbfSatCliL )->lMsgVta
               ( dbfTmpLin )->lNotVta     := ( dbfSatCliL )->lNotVta
               ( dbfTmpLin )->lLote       := ( dbfSatCliL )->lLote
               ( dbfTmpLin )->nLote       := ( dbfSatCliL )->nLote
               ( dbfTmpLin )->cLote       := ( dbfSatCliL )->cLote
               ( dbfTmpLin )->mObsLin     := ( dbfSatCliL )->mObsLin
               ( dbfTmpLin )->Descrip     := ( dbfSatCliL )->Descrip
               ( dbfTmpLin )->cCodPrv     := ( dbfSatCliL )->cCodPrv
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

Static Function HideImportacion( aGet, oShow )

   oBtnPre:Hide()
   oBtnPed:Hide()
   oBtnSat:Hide()

   oBtnAgruparPedido:Hide()
   oBtnAgruparSat:Hide()

   aGet[ _CNUMSAT ]:Hide()
   aGet[ _CNUMPRE ]:Hide()
   aGet[ _CNUMPED ]:Hide()

   if !Empty( oShow )
      oShow:Show()
   end if

Return nil 

//---------------------------------------------------------------------------//

Static Function ActualizaStockWeb( cNumDoc )

   local nRec     := ( D():Get( "AlbCliL", nView ) )->( Recno() )
   local nOrdAnt  := ( D():Get( "AlbCliL", nView ) )->( OrdSetFocus( "nNumAlb" ) )

   if uFieldEmpresa( "lRealWeb" )

      with object ( TComercio():New())

         if ( D():Get( "AlbCliL", nView ) )->( dbSeek( cNumDoc ) )

            while ( D():Get( "AlbCliL", nView ) )->cSerAlb + Str( ( D():Get( "AlbCliL", nView ) )->nNumAlb ) + ( D():Get( "AlbCliL", nView ) )->cSufAlb == cNumDoc .and. !( D():Get( "AlbCliL", nView ) )->( Eof() )

               if Retfld( ( D():Get( "AlbCliL", nView ) )->cRef, D():Articulos( nView ), "lPubInt", "Codigo" )

                  :ActualizaStockProductsPrestashop( ( D():Get( "AlbCliL", nView ) )->cRef, ( D():Get( "AlbCliL", nView ) )->cCodPr1, ( D():Get( "AlbCliL", nView ) )->cCodPr2, ( D():Get( "AlbCliL", nView ) )->cValPr1, ( D():Get( "AlbCliL", nView ) )->cValPr2 )

               end if   

               ( D():Get( "AlbCliL", nView ) )->( dbSkip() )

            end while

        end if
        
      end with

   end if 

   ( D():Get( "AlbCliL", nView ) )->( OrdSetFocus( nOrdAnt ) )
   ( D():Get( "AlbCliL", nView ) )->( dbGoTo( nRec ) )  

Return .t.

//---------------------------------------------------------------------------//

Static Function CargaAtipicasCliente( aTmpAlb, oBrwLin, oDlg )

   local nOrder
   local lSearch     := .f.

   /*
   Controlamos que no nos pase código de cliente vacío------------------------
   */

   if Empty( aTmpAlb[ _CCODCLI ] )
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

   // Recalculamos la factura y refrescamos la pantalla--------------------------

   RecalculaTotal( aTmpAlb )

   if !Empty( oBrwLin )
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
         ( dbfTmpLin )->cRef           := ( D():Atipicas( nView ) )->cCodArt
         ( dbfTmpLin )->cCodPr1        := ( D():Atipicas( nView ) )->cCodPr1
         ( dbfTmpLin )->cCodPr2        := ( D():Atipicas( nView ) )->cCodPr2
         ( dbfTmpLin )->cValPr1        := ( D():Atipicas( nView ) )->cValPr1
         ( dbfTmpLin )->cValPr2        := ( D():Atipicas( nView ) )->cValPr2
         ( dbfTmpLin )->nCosDiv        := ( D():Atipicas( nView ) )->nPrcCom
         ( dbfTmpLin )->cAlmLin        := aTmpAlb[ _CCODALM ]
         ( dbfTmpLin )->lIvaLin        := aTmpAlb[ _LIVAINC ]
         ( dbfTmpLin )->nTarLin        := aTmpAlb[ _NTARIFA ]
         ( dbfTmpLin )->dFecAlb        := aTmpAlb[ _DFECALB ]
         ( dbfTmpLin )->nCanEnt        := 1
         ( dbfTmpLin )->nUniCaja       := 0
         ( dbfTmpLin )->lFromAtp       := .t.
   
         //Datos de la tabla de artículo------------------------------------

         ( dbfTmpLin )->cDetalle       := ( D():Articulos( nView ) )->Nombre
         
         if aTmpAlb[ _NREGIVA ] <= 1
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
         ( dbfTmpLin )->nPreUnit       := nRetPreArt( ( dbfTmpLin )->nTarLin, aTmpAlb[ _CDIVALB ], aTmpAlb[ _LIVAINC ], D():Articulos( nView ), D():Get( "Divisas", nView ), dbfKit, D():Get( "TIva", nView ) )

         /*
         Vamos a por los catos de la tarifa
         */      

         hAtipica := hAtipica( hValue( dbfTmpLin, aTmpAlb ) )

         if !Empty( hAtipica )
               
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

      if !Empty( hAtipica )
               
         if hhaskey( hAtipica, "nImporte" )

            if hAtipica[ "nImporte" ] != 0

               ( dbfTmpLin )->nPreUnit := hAtipica[ "nImporte" ]
            
            else
               
               if ( D():Articulos( nView ) )->( dbSeek( ( dbfTmpLin )->cRef ) ) .and. !( D():Articulos( nView ) )->lObs
                  ( dbfTmpLin )->nPreUnit := nRetPreArt( ( dbfTmpLin )->nTarLin, aTmpAlb[ _CDIVALB ], aTmpAlb[ _LIVAINC ], D():Articulos( nView ), D():Get( "Divisas", nView ), dbfKit, D():Get( "TIva", nView ) )   
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

         if Empty( nStockActual )
            nStockActual   := oStock:nTotStockAct( uTmpLin[ _CREF ], uTmpLin[ _CALMLIN ], uTmpLin[ _CVALPR1 ], uTmpLin[ _CVALPR2 ], uTmpLin[ _CLOTE ], uTmpLin[ _LKITART ], uTmpLin[ _NCTLSTK ] )
         end if   

      case ValType( uTmpLin ) == "C"

         cCodigoArticulo   := ( uTmpLin )->cRef
         cCodigoAlmacen    := ( uTmpLin )->cAlmLin
         lNotVta           := ( uTmpLin )->lNotVta
         lMsgVta           := ( uTmpLin )->lMsgVta

         if Empty( nStockActual )
            nStockActual   := oStock:nTotStockAct( ( uTmpLin )->cRef, ( uTmpLin )->cAlmLin, ( uTmpLin )->cValPr1, ( uTmpLin )->cValPr2, ( uTmpLin )->cLote, ( uTmpLin )->lKitArt, ( uTmpLin )->nCtlStk )
         end if

   end case

   if nTotalUnidades  != 0

      do case
         case ( nStockActual - nTotalUnidades ) < 0

            if lNotVta
               MsgStop( "No hay stock suficiente, tenemos " + Alltrim( Trans( nStockActual, MasUnd() ) ) + " unidad(es) disponible(s)," + CRLF + "en almacén " + cCodigoAlmacen + "." )
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

Static Function PrintReportAlbCli( nDevice, nCopies, cPrinter )

   local oFr
   local cFilePdf       := cPatTmp() + "AlbaranesCliente" + StrTran( ( D():Get( "AlbCliT", nView ) )->cSerAlb + Str( ( D():Get( "AlbCliT", nView ) )->nNumAlb ) + ( D():Get( "AlbCliT", nView ) )->cSufAlb, " ", "" ) + ".Pdf"

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

   oFr:SetEventHandler( "Designer", "OnSaveReport", {|| oFr:SaveToBlob( ( D():Documentos( nView ) )->( Select() ), "mReport" ) } )

   /*
   Zona de datos------------------------------------------------------------
   */

   DataReport( oFr )

   /*
   Cargar el informe-----------------------------------------------------------
   */

   if !Empty( ( D():Documentos( nView ) )->mReport )

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

            if file( cFilePdf )

               with object ( TGenMailing():New() )

                  if :IsMailServer()

                     :SetTypeDocument( "nAlbCli" )
                     :SetDe(           uFieldEmpresa( "cNombre" ) )
                     :SetCopia(        uFieldEmpresa( "cCcpMai" ) )
                     :SetAdjunto(      cFilePdf )
                     :SetPara(         RetFld( ( D():Get( "AlbCliT", nView ) )->cCodCli, D():Get( "Client", nView ), "cMeiInt" ) )
                     :SetAsunto(       "Envio de albaran de cliente número " + ( D():Get( "AlbCliT", nView ) )->cSerAlb + "/" + Alltrim( Str( ( D():Get( "AlbCliT", nView ) )->nNumAlb ) ) )
                     :SetMensaje(      "Adjunto le remito nuestro albaran de cliente " + ( D():Get( "AlbCliT", nView ) )->cSerAlb + "/" + Alltrim( Str( ( D():Get( "AlbCliT", nView ) )->nNumAlb ) ) + Space( 1 ) )
                     :SetMensaje(      "de fecha " + Dtoc( ( D():Get( "AlbCliT", nView ) )->dFecAlb ) + Space( 1 ) )
                     :SetMensaje(      CRLF )
                     :SetMensaje(      CRLF )
                     :SetMensaje(      "Reciba un cordial saludo." )

                     :GeneralResource( D():Get( "AlbCliT", nView ), aItmAlbCli() )

                  end if 

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

   if !Empty( ( D():Documentos( nView ) )->mReport )

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
   local oPrinter   
   local cFormato 

   DEFAULT nDevice   := IS_PRINTER
   DEFAULT lExternal := .f.

   // Cremaos el dialogo-------------------------------------------------------

   oPrinter          := PrintSeries():New( nView ):SetVentas()

   // Establecemos sus valores-------------------------------------------------

   oPrinter:Serie(      ( D():AlbaranesClientes( nView ) )->cSerAlb )
   oPrinter:Documento(  ( D():AlbaranesClientes( nView ) )->nNumAlb )
   oPrinter:Sufijo(     ( D():AlbaranesClientes( nView ) )->cSufAlb )

   if lExternal

      oPrinter:oFechaInicio:cText( ( D():AlbaranesClientes( nView ) )->dFecAlb )
      oPrinter:oFechaFin:cText( ( D():AlbaranesClientes( nView ) )->dFecAlb )

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

   oPrinter:bWhile   := {||   oPrinter:InRangeDocumento( D():AlbaranesClientesId( nView ) )                  .and. ;
                              ( D():AlbaranesClientes( nView ) )->( !eof() ) }

   oPrinter:bFor     := {||   oPrinter:InRangeFecha( ( D():AlbaranesClientes( nView ) )->dFecAlb )           .and. ;
                              oPrinter:InRangeCliente( ( D():AlbaranesClientes( nView ) )->cCodCli )         .and. ;
                              oPrinter:InRangeGrupoCliente( retGrpCli( ( D():AlbaranesClientes( nView ) )->cCodCli, D():Clientes( nView ) ) ) }

   oPrinter:bSkip    := {||   ( D():AlbaranesClientes( nView ) )->( dbSkip() ) }

   //oPrinter:bAction  := {||   GenAlbCli( nDevice, "Imprimiendo documento : " + D():AlbaranesClientesId( nView ), oPrinter:oFormatoDocumento:uGetValue, oPrinter:oImpresora:uGetValue, oPrinter:oCopias:uGetValue ) }
   oPrinter:bAction  := {||   GenAlbCli( nDevice, "Imprimiendo documento : " + D():AlbaranesClientesId( nView ), oPrinter:oFormatoDocumento:uGetValue, oPrinter:oImpresora:uGetValue ) }

   oPrinter:bStart   := {||   if( lExternal, oPrinter:DisableRange(), ) }

   // Abrimos el dialogo-------------------------------------------------------

   oPrinter:Resource():End()

   // Restore -----------------------------------------------------------------

   D():SetStatus( "AlbCliT", nView, aStatus )
   
   if !Empty( oWndBrw )
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

Static Function ChangeTrasportista( oCol, uNewValue, nKey )

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

Return .t.

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
   local nOrdAnt     := ( cPedPrvL )->( OrdSetFocus( "CPEDCLIREF" ) )

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

   local nLevel         := nLevelUsr( _MENUITEM_ )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) != 0 .or. nAnd( nLevel, ACC_APPD ) == 0
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

   local nLevel         := nLevelUsr( _MENUITEM_ )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) != 0 .or. nAnd( nLevel, ACC_EDIT ) == 0
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

   local nLevel         := nLevelUsr( _MENUITEM_ )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) != 0 .or. nAnd( nLevel, ACC_ZOOM ) == 0
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

   local nLevel         := nLevelUsr( _MENUITEM_ )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) != 0 .or. nAnd( nLevel, ACC_DELE ) == 0
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

   local nLevel         := nLevelUsr( _MENUITEM_ )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) != 0 .or. nAnd( nLevel, ACC_IMPR ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if lOpenBrowse

      if AlbCli()
         if dbSeekInOrd( cNumAlb, "nNumAlb", D():Get( "AlbCliT", nView ) )
            ImprimirSeriesAlbaranes( IS_PRINTER, .t. )
            //GenAlbCli( IS_PRINTER, cCaption, cFormato, cPrinter )
         else
            MsgStop( "No se encuentra albarán" )
         end if
      end if

   else

      if OpenFiles()

         if dbSeekInOrd( cNumAlb, "nNumAlb", D():Get( "AlbCliT", nView ) )
            nTotAlbCli()
            ImprimirSeriesAlbaranes( IS_PRINTER, .t. )
            //GenAlbCli( IS_PRINTER, cCaption, cFormato, cPrinter )
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
         :nWidth           := 60
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
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Nombre"
         :cSortOrder       := "cNomCli"
         :bEditValue       := {|| AllTrim( ( D():Get( "AlbCliT", nView ) )->cNomCli ) }
         :nWidth           := 200
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

   local nCalculo

   DEFAULT nDec   := 0
   DEFAULT nVdv   := 1

   nCalculo       := nTotUAlbCli( cTmpLin, nDec, nVdv )

   if !( dbfTmpLin )->lIvaLin
      nCalculo    += nCalculo * ( cTmpLin )->nIva / 100
   end if

   IF nVdv != 0
      nCalculo    := nCalculo / nVdv
   END IF

RETURN ( Round( nCalculo, nDec ) )

//---------------------------------------------------------------------------//

FUNCTION cDesAlbCli( cAlbCliL, cAlbCliS )

   DEFAULT cAlbCliL  := D():Get( "AlbCliL", nView )
   DEFAULT cAlbCliS  := D():Get( "AlbCliS", nView )

RETURN ( Descrip( cAlbCliL, cAlbCliS ) )

//---------------------------------------------------------------------------//
/*
Devuelve el total de una linea con impuestos incluido
*/

FUNCTION nIncLAlbCli( cDbfLin, nDec, nRouDec, nVdv, lDto, lPntVer, lImpTrn, cPouDiv )

   local nCalculo := nTotLAlbCli( cDbfLin, nDec, nRouDec, nVdv, lDto, lPntVer, lImpTrn, cPouDiv )

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

   nCalculo          := nTotLAlbCli( cAlbCliL, nDec, nRou, nVdv, lDto, lPntVer, lImpTrn, cPouDiv )   

   if !( cAlbCliL )->lIvaLin
      nCalculo       := nCalculo * ( cAlbCliL )->nIva / 100
   else
      nCalculo       -= nCalculo / ( 1 + ( cAlbCliL )->nIva / 100 )
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

      if !Empty( cNumAlb )
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

   if Empty( oBtn )
      return nil
   end if

   IF !( D():Documentos( nView ) )->( dbSeek( "AC" ) )

      DEFINE BTNSHELL RESOURCE "DOCUMENT" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( msgStop( "No hay documentos predefinidos" ) );
         TOOLTIP  "No hay documentos" ;
         FROM     oBtn ;
         CLOSED ;
         LEVEL    ACC_EDIT

   ELSE

      WHILE ( D():Documentos( nView ) )->CTIPO == "AC" .AND. !( D():Documentos( nView ) )->( eof() )

         bAction  := bGenAlbCli( nDevice, "Imprimiendo albaranes de clientes", ( D():Documentos( nView ) )->Codigo )

         oWndBrw:NewAt( "Document", , , bAction, Rtrim( ( D():Documentos( nView ) )->cDescrip ) , , , , , oBtn )

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

         if dbSeekInOrd( cCodCli, "Cod", D():Get( "Client", nView ) )

            nNumAlb                          := Val( StrTran( cNumDoc, "/", "" ) )

            if Empty( ( D():Get( "Client", nView ) )->Serie )
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
                  ( D():Get( "AlbCliT", nView ) )->cCodAlm    := oUser():cAlmacen()
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
   aAdd( aColAlbCli,  { "nFacturado",  "N",  1,   0, "Estado de la linea de albarán",    "",                  "", "( cDbfCol )" } )

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

   DEFAULT cPath     := cPatEmp() 

   if OpenFiles()

      ( D():Get( "AlbCliT", nView ) )->( ordSetFocus( 0 ) )
      ( D():Get( "AlbCliT", nView ) )->( dbGoTop() )

      while !( D():Get( "AlbCliT", nView ) )->( eof() )

         /*
         Miramos si estamos usando los campos nuevos de estado, y si no es asi, pasamos el estado
         */

         if ( D():Get( "AlbCliT", nView ) )->nFacturado == 0

            if ( D():Get( "AlbCliT", nView ) )->lFacturado
               
               if D():Lock( "AlbCliT", nView )

                  ( D():Get( "AlbCliT", nView ) )->nFacturado := 3

                  D():UnLock( "AlbCliT", nView )

               end if

            else
               
               if D():Lock( "AlbCliT", nView )

                  ( D():Get( "AlbCliT", nView ) )->nFacturado := 1

                  D():UnLock( "AlbCliT", nView )

               end if
                  
            end if

         end if

         if Empty( ( D():Get( "AlbCliT", nView ) )->cSufAlb )
            
            if D():Lock( "AlbCliT", nView )

               ( D():Get( "AlbCliT", nView ) )->cSufAlb := "00"

               D():UnLock( "AlbCliT", nView )
            
            end if

         end if

         if !Empty( ( D():Get( "AlbCliT", nView ) )->cNumPre ) .and. Len( AllTrim( ( D():Get( "AlbCliT", nView ) )->cNumPre ) ) != 12
            
            if D():Lock( "AlbCliT", nView )

               ( D():Get( "AlbCliT", nView ) )->cNumPre := AllTrim( ( D():Get( "AlbCliT", nView ) )->cNumPre ) + "00"

               D():UnLock( "AlbCliT", nView )

            end if   

         end if

         if !Empty( ( D():Get( "AlbCliT", nView ) )->cNumPed ) .and. Len( AllTrim( ( D():Get( "AlbCliT", nView ) )->cNumPed ) ) != 12
            
            if D():Lock( "AlbCliT", nView )
               
               ( D():Get( "AlbCliT", nView ) )->cNumPed := AllTrim( ( D():Get( "AlbCliT", nView ) )->cNumPed ) + "00"
            
               D():UnLock( "AlbCliT", nView )

            end if

         end if

         if !Empty( ( D():Get( "AlbCliT", nView ) )->cNumSat ) .and. Len( AllTrim( ( D():Get( "AlbCliT", nView ) )->cNumSat ) ) != 12
            
            if D():Lock( "AlbCliT", nView )

               ( D():Get( "AlbCliT", nView ) )->cNumSat := AllTrim( ( D():Get( "AlbCliT", nView ) )->cNumSat ) + "00"

               D():UnLock( "AlbCliT", nView )

            end if

         end if

         if !Empty( ( D():Get( "AlbCliT", nView ) )->cNumFac ) .and. Len( AllTrim( ( D():Get( "AlbCliT", nView ) )->cNumFac ) ) != 12
            
            if D():Lock( "AlbCliT", nView )

               ( D():Get( "AlbCliT", nView ) )->cNumFac := AllTrim( ( D():Get( "AlbCliT", nView ) )->cNumFac ) + "00"

               D():UnLock( "AlbCliT", nView )

            end if   

         end if

         if !Empty( ( D():Get( "AlbCliT", nView ) )->cNumDoc ) .and. Len( AllTrim( ( D():Get( "AlbCliT", nView ) )->cNumDoc ) ) != 12
            
            if D():Lock( "AlbCliT", nView )
            
               ( D():Get( "AlbCliT", nView ) )->cNumDoc := AllTrim( ( D():Get( "AlbCliT", nView ) )->cNumDoc ) + "00"

               D():UnLock( "AlbCliT", nView )

            end if   

         end if

         if !Empty( ( D():Get( "AlbCliT", nView ) )->cNumTik ) .and. Len( AllTrim( ( D():Get( "AlbCliT", nView ) )->cNumTik ) ) != 13
            
            if D():Lock( "AlbCliT", nView )
            
               ( D():Get( "AlbCliT", nView ) )->cNumTik := AllTrim( ( D():Get( "AlbCliT", nView ) )->cNumTik ) + "00"

               D():UnLock( "AlbCliT", nView )

            end if

         end if

         if Empty( ( D():Get( "AlbCliT", nView ) )->cCodCaj )
            
            if D():Lock( "AlbCliT", nView )

               ( D():Get( "AlbCliT", nView ) )->cCodCaj := "000"

               D():UnLock( "AlbCliT", nView )

            end if   

         end if

         if Empty( ( D():Get( "AlbCliT", nView ) )->cCodGrp )
            
            if D():Lock( "AlbCliT", nView )

               ( D():Get( "AlbCliT", nView ) )->cCodGrp := RetGrpCli( ( D():Get( "AlbCliT", nView ) )->cCodCli, D():Get( "Client", nView ) )

               D():UnLock( "AlbCliT", nView )

            end if   

         end if

         if Empty( ( D():Get( "AlbCliT", nView ) )->cNomCli ) .and. !Empty ( ( D():Get( "AlbCliT", nView ) )->cCodCli )
            
            if D():Lock( "AlbCliT", nView )

               ( D():Get( "AlbCliT", nView ) )->cNomCli    := RetFld( ( D():Get( "AlbCliT", nView ) )->cCodCli, D():Get( "Client", nView ), "Titulo" )

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

         if Empty( ( D():Get( "AlbCliL", nView ) )->cSufAlb )
            if dbLock( D():Get( "AlbCliL", nView ) )
               ( D():Get( "AlbCliL", nView ) )->cSufAlb    := "00"
               ( D():Get( "AlbCliL", nView ) )->( dbUnLock() )
            end if
         end if

         if !Empty( ( D():Get( "AlbCliL", nView ) )->cNumPed ) .and. Len( AllTrim( ( D():Get( "AlbCliL", nView ) )->cNumPed ) ) != 12
            if dbLock( D():Get( "AlbCliL", nView ) )
               ( D():Get( "AlbCliL", nView ) )->cNumPed := AllTrim( ( D():Get( "AlbCliL", nView ) )->cNumPed ) + "00"
               ( D():Get( "AlbCliL", nView ) )->( dbUnLock() )
            end if   
         end if

         if !Empty( ( D():Get( "AlbCliL", nView ) )->cNumSat ) .and. Len( AllTrim( ( D():Get( "AlbCliL", nView ) )->cNumSat ) ) != 12
            if dbLock( D():Get( "AlbCliL", nView ) )
               ( D():Get( "AlbCliL", nView ) )->cNumSat := AllTrim( ( D():Get( "AlbCliL", nView ) )->cNumSat ) + "00"
               ( D():Get( "AlbCliL", nView ) )->( dbUnlock() )
            end if   
         end if

         if Empty( ( D():Get( "AlbCliL", nView ) )->cLote ) .and. !Empty( ( D():Get( "AlbCliL", nView ) )->nLote )
            if dbLock( D():Get( "AlbCliL", nView ) )
               ( D():Get( "AlbCliL", nView ) )->cLote      := AllTrim( Str( ( D():Get( "AlbCliL", nView ) )->nLote ) )
               ( D():Get( "AlbCliL", nView ) )->( dbUnLock() )
            end if
         end if

         if Empty( ( D():Get( "AlbCliL", nView ) )->nValImp )
            cCodImp                    := RetFld( ( D():Get( "AlbCliL", nView ) )->CREF, D():Articulos( nView ), "cCodImp" )
            if !Empty( cCodImp )
               if dbLock( D():Get( "AlbCliL", nView ) )
                  ( D():Get( "AlbCliL", nView ) )->nValImp := oNewImp:nValImp( cCodImp )
                  ( D():Get( "AlbCliL", nView ) )->( dbUnlock() )
               end if   
            end if
         end if

         if Empty( ( D():Get( "AlbCliL", nView ) )->nVolumen )
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

         if !Empty( ( D():Get( "AlbCliL", nView ) )->cRef ) .and. Empty( ( D():Get( "AlbCliL", nView ) )->cCodFam )
            if dbLock( D():Get( "AlbCliL", nView ) )
               ( D():Get( "AlbCliL", nView ) )->cCodFam    := RetFamArt( ( D():Get( "AlbCliL", nView ) )->cRef, D():Articulos( nView ) )
               ( D():Get( "AlbCliL", nView ) )->( dbUnLock() )
            end if   
         end if

         if !Empty( ( D():Get( "AlbCliL", nView ) )->cRef ) .and. !Empty( ( D():Get( "AlbCliL", nView ) )->cCodFam )
            if dbLock( D():Get( "AlbCliL", nView ) )
               ( D():Get( "AlbCliL", nView ) )->cGrpFam    := cGruFam( ( D():Get( "AlbCliL", nView ) )->cCodFam, dbfFamilia )
               ( D():Get( "AlbCliL", nView ) )->( dbUnLock() )
            end if
         end if

         if Empty( ( D():Get( "AlbCliL", nView ) )->nReq )
            if dbLock( D():Get( "AlbCliL", nView ) )
               ( D():Get( "AlbCliL", nView ) )->nReq       := nPReq( D():Get( "TIva", nView ), ( D():Get( "AlbCliL", nView ) )->nIva )
               ( D():Get( "AlbCliL", nView ) )->( dbUnLock() )
            end if
         end if

         if ( D():Get( "AlbCliL", nView ) )->lFacturado != RetFld( ( D():Get( "AlbCliL", nView ) )->cSerAlb + Str( ( D():Get( "AlbCliL", nView ) )->nNumAlb ) + ( D():Get( "AlbCliL", nView ) )->cSufAlb, D():Get( "AlbCliT", nView ), "lFacturado" )
            if dbLock( D():Get( "AlbCliL", nView ) )
               ( D():Get( "AlbCliL", nView ) )->lFacturado := RetFld( ( D():Get( "AlbCliL", nView ) )->cSerAlb + Str( ( D():Get( "AlbCliL", nView ) )->nNumAlb ) + ( D():Get( "AlbCliL", nView ) )->cSufAlb, D():Get( "AlbCliT", nView ), "lFacturado" )
               ( D():Get( "AlbCliL", nView ) )->( dbUnlock() )
            end if
         end if

         if ( D():Get( "AlbCliL", nView ) )->dFecAlb != RetFld( ( D():Get( "AlbCliL", nView ) )->cSerAlb + Str( ( D():Get( "AlbCliL", nView ) )->nNumAlb ) + ( D():Get( "AlbCliL", nView ) )->cSufAlb, D():Get( "AlbCliT", nView ), "dFecAlb" )
            if dbLock( D():Get( "AlbCliL", nView ) )
               ( D():Get( "AlbCliL", nView ) )->dFecAlb    := RetFld( ( D():Get( "AlbCliL", nView ) )->cSerAlb + Str( ( D():Get( "AlbCliL", nView ) )->nNumAlb ) + ( D():Get( "AlbCliL", nView ) )->cSufAlb, D():Get( "AlbCliT", nView ), "dFecAlb" )
               ( D():Get( "AlbCliL", nView ) )->( dbUnlock() )
            end if   
         end if

         if ( D():Get( "AlbCliL", nView ) )->cCodCli != RetFld( ( D():Get( "AlbCliL", nView ) )->cSerAlb + Str( ( D():Get( "AlbCliL", nView ) )->nNumAlb ) + ( D():Get( "AlbCliL", nView ) )->cSufAlb, D():Get( "AlbCliT", nView ), "cCodCli" )
            if dbLock( D():Get( "AlbCliL", nView ) )
               ( D():Get( "AlbCliL", nView ) )->cCodCli    := RetFld( ( D():Get( "AlbCliL", nView ) )->cSerAlb + Str( ( D():Get( "AlbCliL", nView ) )->nNumAlb ) + ( D():Get( "AlbCliL", nView ) )->cSufAlb, D():Get( "AlbCliT", nView ), "cCodCli" )
               ( D():Get( "AlbCliL", nView ) )->( dbUnlock() )
            end if   
         end if

         if Empty( ( D():Get( "AlbCliL", nView ) )->cAlmLin )
            if dbLock( D():Get( "AlbCliL", nView ) )
               ( D():Get( "AlbCliL", nView ) )->cAlmLin    := RetFld( ( D():Get( "AlbCliL", nView ) )->cSerAlb + Str( ( D():Get( "AlbCliL", nView ) )->nNumAlb ) + ( D():Get( "AlbCliL", nView ) )->cSufAlb, D():Get( "AlbCliT", nView ), "cCodAlm" )
               ( D():Get( "AlbCliL", nView ) )->( dbUnLock() )
            end if   
         end if

         /*
         Cargamos los costos para Marbaroso------------------------------------
         */
         /*

         if !Empty( ( D():Get( "AlbCliL", nView ) )->cRef ) .and. Empty( ( D():Get( "AlbCliL", nView ) )->nCosDiv )
            if dbLock( D():Get( "AlbCliL", nView ) )
               ( D():Get( "AlbCliL", nView ) )->nCosDiv := oStock:nCostoMedio( ( D():Get( "AlbCliL", nView ) )->cRef, ( D():Get( "AlbCliL", nView ) )->cAlmLin, ( D():Get( "AlbCliL", nView ) )->cCodPr1, ( D():Get( "AlbCliL", nView ) )->cCodPr2, ( D():Get( "AlbCliL", nView ) )->cValPr1, ( D():Get( "AlbCliL", nView ) )->cValPr2, ( D():Get( "AlbCliL", nView ) )->cLote )
               ( D():Get( "AlbCliL", nView ) )->( dbUnLock() )
            end if
         end if

         */

         // Numeros de serie------------------------------------------------------

         if !Empty( ( D():Get( "AlbCliL", nView ) )->mNumSer )

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
               ( D():Get( "AlbCliS", nView ) )->nFacturado := ( D():Get( "AlbCliL", nView ) )->nFacturado
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

         if Empty( ( D():Get( "AlbCliI", nView ) )->cSufAlb )
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

         if Empty( ( D():Get( "AlbCliS", nView ) )->cSufAlb )
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

      // Lineas huerfanas---------------------------------------------------------

/*
      ( D():Get( "AlbCliT", nView ) )->( ordSetFocus( 1 ) )
      ( D():Get( "AlbCliL", nView ) )->( ordSetFocus( 1 ) )
      ( D():Get( "AlbCliL", nView ) )->( dbGoTop() )

      while !( D():Get( "AlbCliL", nView ) )->( eof() )

         if !( D():Get( "AlbCliT", nView ) )->( dbSeek( ( D():Get( "AlbCliL", nView ) )->cSerAlb + Str( ( D():Get( "AlbCliL", nView ) )->nNumAlb ) + ( D():Get( "AlbCliL", nView ) )->cSufAlb ) )
            if dbLock( D():Get( "AlbCliL", nView ) )
	            ( D():Get( "AlbCliL", nView ) )->( dbDelete() )
	        end if
         end if 

         ( D():Get( "AlbCliL", nView ) )->( dbSkip( 1 ) )
         
         SysRefresh()

      end while
*/
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
       
   if !Empty( oStock )
      oStock:end()
   end if

   oStock      := nil

return nil

//------------------------------------------------------------------------//

FUNCTION PrnEntAlb( cNumEnt, lPrint )

   local nLevel         := nLevelUsr( _MENUITEM_ )

   if nAnd( nLevel, 1 ) != 0 .or. nAnd( nLevel, ACC_IMPR ) == 0
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

//---------------------------------------------------------------------------//
//
// Devuelve el numero de unidades recibidas en albaranes a clientes
//

function nUnidadesRecibidasAlbCli( cNumPed, cCodArt, cCodPr1, cCodPr2, cRefPrv, cDetalle, cAlbCliL )

   local nTot        := 0
   local aStaLin     := aGetStatus( cAlbCliL, .f. )

   DEFAULT cCodPr1   := Space( 20 )
   DEFAULT cCodPr2   := Space( 20 )
   DEFAULT cRefPrv   := Space( 18 )
   DEFAULT cDetalle  := Space( 250 )

   ( cAlbCliL )->( OrdSetFocus( "cNumPedRef" ) )

   if ( cAlbCliL )->( dbSeek( cNumPed + cCodArt + cCodPr1 + cCodPr2 ) )
      
      while ( cAlbCliL )->cNumPed + ( cAlbCliL )->cRef + ( cAlbCliL )->cCodPr1 + ( cAlbCliL )->cCodPr2 == cNumPed + cCodArt + cCodPr1 + cCodPr2 .and. !( cAlbCliL )->( eof() )
         nTot     += nTotNAlbCli( cAlbCliL )
         ( cAlbCliL )->( dbSkip() )
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

FUNCTION nTotLAlbCli( cAlbCliL, nDec, nRou, nVdv, lDto, lPntVer, lImpTrn, cPouDiv )

   local nCalculo

   DEFAULT cAlbCliL  := D():Get( "AlbCliL", nView )
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
      Tomamos los valores redondeados------------------------------------------
      */

      nCalculo       := nTotUAlbCli( cAlbCliL, nDec, nVdv )

      /*
      Descuentos---------------------------------------------------------------
      */

      if lDto

         nCalculo    -= Round( ( cAlbCliL )->nDtoDiv , nDec )

         if ( cAlbCliL )->nDto != 0
            nCalculo -= nCalculo * ( cAlbCliL )->nDto / 100
         end if

         if ( cAlbCliL )->nDtoPrm != 0
            nCalculo -= nCalculo * ( cAlbCliL )->nDtoPrm / 100
         end if

      end if

      /*
      Punto Verde--------------------------------------------------------------
      */

      if lPntVer
         nCalculo    += ( cAlbCliL )->nPntVer
      end if

      /*
      Transporte---------------------------------------------------------------
      */

      if lImpTrn 
         nCalculo    += ( cAlbCliL )->nImpTrn 
      end if

      /*
      Unidades-----------------------------------------------------------------
      */

      nCalculo       *= nTotNAlbCli( cAlbCliL )

      /*
      Redondeo-----------------------------------------------------------------
      */

      if nRou != nil
         nCalculo    := Round( nCalculo, nRou )
      end if

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

   rxAlbCli( cPath, oMeter )

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

FUNCTION rxAlbCli( cPath, oMeter )

   local cAlbCliT

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

   dbUseArea( .t., cDriver(), cPath + "ALBCLIT.DBF", cCheckArea( "ALBCLIT", @cAlbCliT ), .f. )

   if !( cAlbCliT )->( neterr() )
      ( cAlbCliT )->( __dbPack() )

      ( cAlbCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() }  ) )
      ( cAlbCliT )->( ordCreate( cPath + "ALBCLIT.CDX", "NNUMALB", "CSERALB + Str(NNUMALB) + CSUFALB", {|| Field->CSERALB + Str( Field->NNUMALB ) + Field->CSUFALB } ) )

      ( cAlbCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() }  ) )
      ( cAlbCliT )->( ordCreate( cPath + "ALBCLIT.CDX", "DFECALB", "DFECALB", {|| Field->DFECALB } ) )

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

      ( cAlbCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() }  ) )
      ( cAlbCliT )->( ordCreate( cPath + "ALBCLIT.CDX", "CNUMPED", "CNUMPED", {|| Field->CNUMPED } ) )

      ( cAlbCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() }  ))
      ( cAlbCliT )->( ordCreate( cPath + "ALBCLIT.CDX", "lSndDoc", "lSndDoc", {|| Field->lSndDoc } ) )

      ( cAlbCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() }  ) )
      ( cAlbCliT )->( ordCreate( cPath + "AlbCliT.Cdx", "cCodUsr", "Field->cCodUsr + Dtos( Field->dFecCre ) + Field->cTimCre", {|| Field->cCodUsr + Dtos( Field->dFecCre ) + Field->cTimCre } ) )

      ( cAlbCliT )->( ordCondSet( "!Deleted() .and. nFacturado == 3", {|| !Deleted() .and. Field->nFacturado == 3 }  ) )
      ( cAlbCliT )->( ordCreate( cPath + "AlbCliT.Cdx", "lCodCli", "Field->cCodCli", {|| Field->cCodCli } ) )

      ( cAlbCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( cAlbCliT )->( ordCreate( cPath + "AlbCliT.CDX", "cSuPed", "cSuPed", {|| Field->cSuPed } ) )

      ( cAlbCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( cAlbCliT )->( ordCreate( cPath + "AlbCliT.Cdx", "iNumAlb", "'10' + cSerAlb + Str( nNumAlb ) + Space( 1 ) + cSufAlb", {|| '10' + Field->cSerAlb + Str( Field->nNumAlb ) + Space( 1 ) + Field->cSufAlb } ) )

      ( cAlbCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() }  ) )
      ( cAlbCliT )->( ordCreate( cPath + "ALBCLIT.CDX", "CNUMCLI", "CSERALB + Str(NNUMALB) + CSUFALB + CCODCLI", {|| Field->CSERALB + Str( Field->NNUMALB ) + Field->CSUFALB + Field->CCODCLI } ) )

      ( cAlbCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() }, , , , , , , , , .t. ) )
      ( cAlbCliT )->( ordCreate( cPath + "AlbCliT.Cdx", "cCliFec", "cCodCli + dtos( dFecAlb )", {|| Field->cCodCli + dtos( Field->dFecAlb ) } ) )

      ( cAlbCliT )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de albaranes de clientes" )
   end if

   dbUseArea( .t., cDriver(), cPath + "ALBCLIL.DBF", cCheckArea( "ALBCLIL", @cAlbCliT ), .f. )

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
      ( cAlbCliT )->( ordCreate( cPath + "ALBCLIL.CDX", "cNumPedRef", "cNumPed + cRef + cCodPr1 + cCodPr2", {|| Field->cNumPed + Field->cRef + Field->cCodPr1 + Field->cCodPr2 } ) )

      ( cAlbCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( cAlbCliT )->( ordCreate( cPath + "ALBCLIL.CDX", "cNumPedDet", "cNumPed + cRef + cCodPr1 + cCodPr2 + cRefPrv", {|| Field->cNumPed + Field->cRef + Field->cCodPr1 + Field->cCodPr2 + Field->cRefPrv } ) ) // + cDetalle

      ( cAlbCliT )->( ordCondSet("!Deleted()", {|| !Deleted() } ) )
      ( cAlbCliT )->( ordCreate( cPath + "ALBCLIL.CDX", "cNumRef", "cSerAlb + Str( nNumAlb ) + cSufAlb + cRef", {|| Field->cSerAlb + Str( Field->nNumAlb ) + Field->cSufAlb + Field->cRef } ) )

      ( cAlbCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() }, , , , , , , , , .t. ) )
      ( cAlbCliT )->( ordCreate( cPath + "AlbCliL.Cdx", "cRefFec", "cRef + cCodCli + dtos( dFecAlb )", {|| Field->cRef + Field->cCodCli + dtos( Field->dFecAlb ) } ) )

      ( cAlbCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( cAlbCliT )->( ordCreate( cPath + "ALBCLIL.CDX", "cPedRef", "cNumPed + cRef", {|| Field->cNumPed + Field->cRef } ) )

      ( cAlbCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( cAlbCliT )->( ordCreate( cPath + "AlbCliL.Cdx", "iNumAlb", "'10' + cSerAlb + Str( nNumAlb ) + Space( 1 ) + cSufAlb", {|| '10' + Field->cSerAlb + Str( Field->nNumAlb ) + Space( 1 ) + Field->cSufAlb } ) )

      ( cAlbCliT )->( ordCondSet( "nFacturado == 3 .and. nCtlStk < 2 .and. !Deleted()", {|| Field->nFacturado == 3 .and. Field->nCtlStk < 2 .and. !Deleted()}, , , , , , , , , .t. ) )
      ( cAlbCliT )->( ordCreate( cPath + "AlbCliL.Cdx", "cStkFast", "cRef + cAlmLin + dtos( dFecAlb )", {|| Field->cRef + Field->cAlmLin + dtos( Field->dFecAlb ) } ) )

      ( cAlbCliT )->( dbCloseArea() )

   else

      msgStop( "Imposible abrir en modo exclusivo la tabla de albaranes de clientes" )

   end if

   // Pagos de albaranes

   dbUseArea( .t., cDriver(), cPath + "ALBCLIP.DBF", cCheckArea( "ALBCLIP", @cAlbCliT ), .f. )

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

   dbUseArea( .t., cDriver(), cPath + "AlbCliI.DBF", cCheckArea( "AlbCliI", @cAlbCliT ), .f. )

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

   dbUseArea( .t., cDriver(), cPath + "AlbCliD.DBF", cCheckArea( "AlbCliD", @cAlbCliT ), .f. )

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

   dbUseArea( .t., cDriver(), cPath + "AlbCliS.Dbf", cCheckArea( "AlbCliS", @cAlbCliT ), .f. )

   if !( cAlbCliT )->( neterr() )
      ( cAlbCliT )->( __dbPack() )

      ( cAlbCliT )->( ordCondSet( "!Deleted()", {||!Deleted()}  ) )
      ( cAlbCliT )->( ordCreate( cPath + "AlbCliS.CDX", "nNumAlb", "cSerAlb + Str( nNumAlb ) + cSufAlb + Str( nNumLin )", {|| Field->cSerAlb + Str( Field->nNumAlb ) + Field->cSufAlb + Str( Field->nNumLin ) } ) )

      ( cAlbCliT )->( ordCondSet( "nFacturado == 3 .and. !Deleted()", {|| Field->nFacturado == 3 .and. !Deleted() } ) )
      ( cAlbCliT )->( ordCreate( cPath + "AlbCliS.CDX", "cRefSer", "cRef + cAlmLin + cNumSer", {|| Field->cRef + Field->cAlmLin + Field->cNumSer } ) )

      ( cAlbCliT )->( ordCondSet( "nFacturado == 3 .and. !Deleted()", {|| Field->nFacturado == 3 .and. !Deleted() } ) )
      ( cAlbCliT )->( ordCreate( cPath + "AlbCliS.CDX", "cNumSer", "cNumSer", {|| Field->cNumSer } ) )

      ( cAlbCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( cAlbCliT )->( ordCreate( cPath + "AlbCliS.Cdx", "iNumAlb", "'10' + cSerAlb + Str( nNumAlb ) + Space( 1 ) + cSufAlb", {|| '10' + Field->cSerAlb + Str( Field->nNumAlb ) + Space( 1 ) + Field->cSufAlb } ) )

      ( cAlbCliT )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de numeros de series de albaranes de clientes" )
   end if

RETURN NIL

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
   aAdd( aBasRecCli, {"cEPaisIBAN"  ,"C",  2, 0, "País IBAN de la cuenta bancaria de la empresa",       "", "", "( cDbfEnt )", nil } )
   aAdd( aBasRecCli, {"cECtrlIBAN"  ,"C",  2, 0, "Dígito de control IBAN de la cuenta bancaria de la empresa", "", "", "( cDbfEnt )", nil } )
   aAdd( aBasRecCli, {"cEntEmp"     ,"C",  4, 0, "Entidad de la cuenta de la empresa",  "",                 "", "( cDbfEnt )", nil } )
   aAdd( aBasRecCli, {"cSucEmp"     ,"C",  4, 0, "Sucursal de la cuenta de la empresa",  "",                "", "( cDbfEnt )", nil } )
   aAdd( aBasRecCli, {"cDigEmp"     ,"C",  2, 0, "Dígito de control de la cuenta de la empresa", "",        "", "( cDbfEnt )", nil } )
   aAdd( aBasRecCli, {"cCtaEmp"     ,"C", 10, 0, "Cuenta bancaria de la empresa",  "",                      "", "( cDbfEnt )", nil } )
   aAdd( aBasRecCli, {"cPaisIBAN"   ,"C",  2, 0, "País IBAN de la cuenta bancaria del cliente",           "", "", "( cDbfEnt )", nil } )
   aAdd( aBasRecCli, {"cCtrlIBAN"   ,"C",  2, 0, "Dígito de control IBAN de la cuenta bancaria del cliente", "", "", "( cDbfEnt )", nil } )
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
   aAdd( aColAlbCli, { "nIva",      "N",  4, 1, cImp() + " del artículo" ,       "'@E 99'",           "", "( cDbfCol )" } )
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
   aAdd( aColAlbCli, { "cCodPr1",   "C", 20, 0, "Código de primera propiedad",   "",                  "", "( cDbfCol )" } )
   aAdd( aColAlbCli, { "cCodPr2",   "C", 20, 0, "Código de segunda propiedad",   "",                  "", "( cDbfCol )" } )
   aAdd( aColAlbCli, { "cValPr1",   "C", 40, 0, "Valor de primera propiedad",    "",                  "", "( cDbfCol )" } )
   aAdd( aColAlbCli, { "cValPr2",   "C", 40, 0, "Valor de segunda propiedad",    "",                  "", "( cDbfCol )" } )
   aAdd( aColAlbCli, { "nFacCnv",   "N", 16, 6, "",                              "",                  "", "( cDbfCol )" } )
   aAdd( aColAlbCli, { "nDtoDiv",   "N", 16, 6, "Descuento en línea",            "cPouDivAlb",        "", "( cDbfCol )" } )
   aAdd( aColAlbCli, { "nNumLin",   "N",  4, 0, "Número de la línea",            "'9999'",            "", "( cDbfCol )" } )
   aAdd( aColAlbCli, { "nCtlStk",   "N",  1, 0, "Tipo de stock de la linea",     "9",                 "", "( cDbfCol )" } )
   aAdd( aColAlbCli, { "nCosDiv",   "N", 16, 6, "Precio de costo",               "cPouDivAlb",        "", "( cDbfCol )" } )
   aAdd( aColAlbCli, { "nPvpRec",   "N", 16, 6, "Precio de venta recomendado",   "cPouDivAlb",        "", "( cDbfCol )" } )
   aAdd( aColAlbCli, { "cAlmLin",   "C", 16, 0, "Código del almacen",            "",                  "", "( cDbfCol )" } )
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
   aAdd( aColAlbCli, { "lVolImp",   "L",  1, 0, "Lógico aplicar volumen con impuestos especiales","", "", "( cDbfCol )" } )
   aAdd( aColAlbCli, { "dFecAlb",   "D",  8, 0, "Fecha de albaran",              "",                  "", "( cDbfCol )" } )
   aAdd( aColAlbCli, { "cNumSat",   "C", 12, 0, "Número del SAT" ,               "",                  "", "( cDbfCol )" } )
   aAdd( aColAlbCli, { "lFromAtp",  "L",  1, 0, "",                              "",                  "", "( cDbfCol )" } )
   aAdd( aColAlbCli, { "cCodCli",   "C", 12, 0, "Código de cliente",             "",                  "", "( cDbfCol )" } )
   aAdd( aColAlbCli, { "dFecUltCom","D",  8, 0, "Fecha última compra",           "",                  "", "( cDbfCol )" } )
   aAdd( aColAlbCli, { "nUniUltCom","N", 16, 6, "Unidades última compra",        "",                  "", "( cDbfCol )" } )
   aAdd( aColAlbCli, { "nBultos",   "N", 16, 6, "Numero de bultos",              "",                  "", "( cDbfCol )" } )
   aAdd( aColAlbCli, { "cFormato",  "C",100, 0, "Formato de venta",              "",                  "", "( cDbfCol )" } )
   aAdd( aColAlbCli, { "nFacturado","N",  1, 0, "Estado de la línea del albarán","",                  "", "( cDbfCol )", 1 } )

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
   aAdd( aItmAlbCli, { "CCODALM"   ,"C", 16, 0, "Código de almacén" ,                                    "'@!'",               "", "( cDbf )"} )
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
   aAdd( aItmAlbCli, { "CCODOBR"   ,"C", 10, 0, "Código de dirección" ,                                       "'@!'",               "", "( cDbf )"} )
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
   aAdd( aItmAlbCli, { "LIVAINC"   ,"L",  1, 0, cImp() + " incluido",                                    "",                   "", "( cDbf )"} )
   aAdd( aItmAlbCli, { "NREGIVA"   ,"N",  1, 0, "Regimen de " + cImp(),                                  "",                   "", "( cDbf )"} )
   aAdd( aItmAlbCli, { "LGENLQD"   ,"L",  1, 0, "Generado por liquidación",                              "",                   "", "( cDbf )"} )
   aAdd( aItmAlbCli, { "NNUMORD"   ,"N",  9, 0, "Número de la orden de carga" ,                          "'999999999'",        "", "( cDbf )"} )
   aAdd( aItmAlbCli, { "CSUFORD"   ,"C",  2, 0, "Sufijo de la orden de carga" ,                          "",                   "", "( cDbf )"} )
   aAdd( aItmAlbCli, { "DFECORD"   ,"D",  8, 0, "Fecha de la orden de carga" ,                           "",                   "", "( cDbf )"} )
   aAdd( aItmAlbCli, { "NIVAMAN"   ,"N",  6, 2, "Porcentaje de " + cImp() + " del gasto" ,               "'@EZ 999,99'",       "", "( cDbf )"} )
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
   aAdd( aItmAlbCli, { "cNumTik",   "C", 13, 0, "Número del ticket" ,                                    "",                   "", "( cDbf )"} )
   aAdd( aItmAlbCli, { "cTlfCli",   "C", 20, 0, "Teléfono del cliente" ,                                 "",                   "", "( cDbf )"} )
   aAdd( aItmAlbCli, { "nTotNet",   "N", 16, 6, "Total neto" ,                                           "",                   "", "( cDbf )"} )
   aAdd( aItmAlbCli, { "nTotIva",   "N", 16, 6, "Total " + cImp() ,                                      "",                   "", "( cDbf )"} )
   aAdd( aItmAlbCli, { "nTotReq",   "N", 16, 6, "Total recargo" ,                                        "",                   "", "( cDbf )"} )
   aAdd( aItmAlbCli, { "nTotAlb",   "N", 16, 6, "Total albarán" ,                                        "",                   "", "( cDbf )"} )
   aAdd( aItmAlbCli, { "nTotPag",   "N", 16, 6, "Total anticipado" ,                                     "",                   "", "( cDbf )"} )
   aAdd( aItmAlbCli, { "lOperPV",   "L",  1, 0, "Lógico para operar con punto verde" ,                   "",                   "", "( cDbf )"} )
   aAdd( aItmAlbCli, { "cBanco"   , "C", 50, 0, "Nombre del banco del cliente",                          "",                   "", "( cDbf )", nil } )
   aAdd( aItmAlbCli, { "cPaisIBAN", "C",  2, 0, "País IBAN de la cuenta bancaria del cliente",           "",                   "", "( cDbf )", nil } )
   aAdd( aItmAlbCli, { "cCtrlIBAN", "C",  2, 0, "Dígito de control IBAN de la cuenta bancaria del cliente", "",                "", "( cDbf )", nil } )
   aAdd( aItmAlbCli, { "cEntBnc"  , "C",  4, 0, "Entidad de la cuenta bancaria del cliente",             "",                   "", "( cDbf )", nil } )
   aAdd( aItmAlbCli, { "cSucBnc"  , "C",  4, 0, "Sucursal de la cuenta bancaria del cliente",            "",                   "", "( cDbf )", nil } )
   aAdd( aItmAlbCli, { "cDigBnc"  , "C",  2, 0, "Dígito de control de la cuenta bancaria del cliente",   "",                   "", "( cDbf )", nil } )
   aAdd( aItmAlbCli, { "cCtaBnc"  , "C", 10, 0, "Cuenta bancaria del cliente",                           "",                   "", "( cDbf )", nil } )
   aAdd( aItmAlbCli, { "nDtoTarifa","N",  6, 2, "Descuento de tarifa de cliente",                        "",                   "", "( cDbf )", nil } )
   aAdd( aItmAlbCli, { "nFacturado","N",  1, 0, "Estado del albarán",                                    "",                   "", "( cDbf )", 1} )

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

   DEFAULT cAlbCliT        := D():Get( "AlbCliT", nView )
   DEFAULT cAlbCliL        := D():Get( "AlbCliL", nView )
   DEFAULT cAlbaran        := ( cAlbCliT )->cSerAlb + Str( ( cAlbCliT )->nNumAlb ) + ( cAlbCliT )->cSufAlb
   DEFAULT cIva            := D():Get( "TIva", nView )
   DEFAULT cDiv            := D():Get( "Divisas", nView )
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

   // Ordenamos los impuestosS de menor a mayor

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

   /*
   Estudio de impuestos para el Gasto despues de los descuentos----------------------
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

   // Calculamos los impuestosS-----------------------------------------------------

   if !lIvaInc

      //Calculos de impuestos

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

   //Total de impuestos

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
            ( cAlbCliT )->cNumFac    := cNumFac
            ( cAlbCliT )->( dbUnLock() )
         end if

         if lFacturado

            if dbLock( cAlbCliT )
               ( cAlbCliT )->nFacturado := 3
               ( cAlbCliT )->( dbUnLock() )
            end if

         else

            if dbLock( cAlbCliT )
               ( cAlbCliT )->nFacturado := 1
               ( cAlbCliT )->( dbUnLock() )
            end if

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

                if lFacturado

                  if dbLock( cAlbCliL )
                     ( cAlbCliL )->nFacturado := 3
                     ( cAlbCliL )->( dbUnLock() )
                  end if

               else

                  if dbLock( cAlbCliL )
                     ( cAlbCliL )->nFacturado := 1
                     ( cAlbCliL )->( dbUnLock() )
                  end if

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

                if lFacturado

                  if dbLock( cAlbCliS )
                     ( cAlbCliS )->nFacturado := 3
                     ( cAlbCliS )->( dbUnLock() )
                  end if

               else

                  if dbLock( cAlbCliS )
                     ( cAlbCliS )->nFacturado := 1
                     ( cAlbCliS )->( dbUnLock() )
                  end if

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

      if lFacturado

         if dbLock( cAlbCliT )
            ( cAlbCliT )->nFacturado := 3
            ( cAlbCliT )->( dbUnLock() )
         end if

      else

         if dbLock( cAlbCliT )
            ( cAlbCliT )->nFacturado := 1
            ( cAlbCliT )->( dbUnLock() )
         end if

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

   USE ( cPatCli() + "ObrasT.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "Obras", @dbfObras ) )
   SET ADSINDEX TO ( cPatCli() + "ObrasT.Cdx" ) ADDITIVE

   if ( dbfObras )->( dbSeek( ( dbfSatCliT )->cCodCli + ( dbfSatCliT )->cCodObr ) )
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