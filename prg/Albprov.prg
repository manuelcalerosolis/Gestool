#include "FiveWin.ch"
#include "Folder.ch"
#include "Report.ch"
#include "Label.ch"
#include "Factu.ch" 
#include "Menu.ch"
#include "Xbrowse.ch"
#include "FastRepH.ch" 
#include "dbInfo.ch" 

#define albNoFacturado              1
#define albParcialmenteFacturado    2
#define albTotalmenteFacturado      3

#define _MENUITEM_                  "01047"

#define _ICG_LINE_LEN_              211

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
#define _CALMORIGEN               61  
#define _NFACTURADO               62
#define _TFECALB                  63     //   D      8     0 "",  
#define _CCENTROCOSTE             64
#define _DFECCRE                  65
#define _CTIMCRE                  66 

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
#define _NPNTVER                 108
#define __CALMORIGEN             109
#define __NBULTOS                110
#define _CFORMATO                111
#define __CNUMFAC                112
#define _CCODIMP                 113
#define _NVALIMP                 114
#define _DAPERTURA               115
#define _TAPERTURA               116
#define _DCIERRE                 117
#define _TCIERRE                 118
#define __TFECALB                119     //   D      8     0 "",  
#define __CCENTROCOSTE           120
#define __CSUALB                 121    //   C      2     0 "CSUFALB",
#define _CREFAUX                 122
#define _CREFAUX2                123
#define _NPOSPRINT               124
#define _CTIPCTR                 125
#define _CTERCTR                 126

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
memvar nTotIvm
memvar nTotReq
memvar nTotAlb
memvar nTotImp
memvar nTotUno
memvar nTotDos

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
static nView
static oGetTot
static dbfTmp
static dbfTmpInc
static dbfTmpDoc
static dbfTmpSer
static tmpAlbPrvL
static tmpAlbPrvS
static filAlbPrvL
static oBandera
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
static oGetIvm
static oUsr
static cUsr
static nOldEst
static oBrwIva

static oStock
static TComercio

static oDetMenu

static oNewImp
static oFont
static oMenu
static oDetCamposExtra
static oLinDetCamposExtra
static oCentroCoste
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

static oMailing

static bEdtRec          := { |aTmp, aGet, dbf, oBrw, bWhen, bValid, nMode, cCodPed | EdtRec( aTmp, aGet, dbf, oBrw, bWhen, bValid, nMode, cCodPed ) }
static bEdtDet          := { |aTmp, aGet, dbf, oBrw, bWhen, bValid, nMode, aTmpAlbaranProveedor | EdtDet( aTmp, aGet, dbf, oBrw, bWhen, bValid, nMode, aTmpAlbaranProveedor ) }
static bEdtInc          := { |aTmp, aGet, dbf, oBrw, bWhen, bValid, nMode, aTmpLin | EdtInc( aTmp, aGet, dbf, oBrw, bWhen, bValid, nMode, aTmpLin ) }
static bEdtDoc          := { |aTmp, aGet, dbf, oBrw, bWhen, bValid, nMode, aTmpLin | EdtDoc( aTmp, aGet, dbf, oBrw, bWhen, bValid, nMode, aTmpLin ) }

static cFiltroUsuario   := ""
static cInforme

static oNumerosSerie
static oBtnNumerosSerie

static lIncidencia      := .f.

static Counter

static oTipoCtrCoste
static cTipoCtrCoste
static aTipoCtrCoste   := { "Centro de coste", "Proveedor", "Agente", "Cliente" }

//----------------------------------------------------------------------------//

Static FUNCTION initPublics()

   public nTotAlb       := 0
   public nTotBrt       := 0
   public nTotDto       := 0
   public nTotDPP       := 0
   public nTotUno       := 0
   public nTotDos       := 0
   public nTotNet       := 0
   public nTotIva       := 0
   public nTotReq       := 0
   public nTotImp       := 0
   public nTotIvm       := 0
   public aTotIva       := { { 0,0,nil,0,0,0,0,0,0,0,0 }, { 0,0,nil,0,0,0,0,0,0,0,0 }, { 0,0,nil,0,0,0,0,0,0,0,0 } }
   public aIvaUno       := aTotIva[ 1 ]
   public aIvaDos       := aTotIva[ 2 ]
   public aIvaTre       := aTotIva[ 3 ]
   public aImpVto       := {}
   public aDatVto       := {}

RETURN nil 

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
   local oScript
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

   nLevel            := Auth():Level( oMenuItem )
   if nAnd( nLevel, 1 ) == 0
      msgStop( "Acceso no permitido." )
      RETURN .f.
   end if

   /*
   Cerramos todas las ventanas
   */

   if oWnd != nil
      SysRefresh(); oWnd:CloseAll(); SysRefresh()
   end if

   if !OpenFiles()
      RETURN .f.
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
      MRU      "gc_document_empty_businessman_16";
      BITMAP   Rgb( 0, 114, 198 ) ;
      ALIAS    ( D():AlbaranesProveedores( nView ) );
      APPEND   ( WinAppRec( oWndBrw:oBrw, bEdtRec, D():AlbaranesProveedores( nView ), cCodPrv, cCodArt, cCodPed ) );
      DUPLICAT ( WinDupRec( oWndBrw:oBrw, bEdtRec, D():AlbaranesProveedores( nView ), cCodPrv, cCodArt, cCodPed ) );
      EDIT     ( WinEdtRec( oWndBrw:oBrw, bEdtRec, D():AlbaranesProveedores( nView ), cCodPrv, cCodArt, cCodPed ) );
      ZOOM     ( WinZooRec( oWndBrw:oBrw, bEdtRec, D():AlbaranesProveedores( nView ) ) );
      DELETE   ( WinDelRec( oWndBrw:oBrw, D():AlbaranesProveedores( nView ), {|| QuiAlbPrv() } ) );
      LEVEL    nLevel ;
      OF       oWnd

     oWndBrw:lFechado     := .t.

     oWndBrw:bChgIndex    := {|| if( SQLAjustableModel():getRolFiltrarVentas( Auth():rolUuid() ), CreateFastFilter( cFiltroUsuario, D():AlbaranesProveedores( nView ), .f., , cFiltroUsuario ), CreateFastFilter( "", D():AlbaranesProveedores( nView ), .f. ) ) }

     oWndBrw:SetYearComboBoxChange( {|| YearComboBoxChange() } )

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Sesión cerrada"
         :nHeadBmpNo       := 3
         :bStrData         := {|| "" }
         :bEditValue       := {|| ( D():AlbaranesProveedores( nView ) )->lCloAlb }
         :nWidth           := 20
         :lHide            := .t.
         :SetCheck( { "gc_lock2_12", "Nil16" } )
         :AddResource( "gc_lock2_16" )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Envio"
         :nHeadBmpNo       := 3
         :bStrData         := {|| "" }
         :bEditValue       := {|| ( D():AlbaranesProveedores( nView ) )->lSndDoc }
         :nWidth           := 20
         :SetCheck( { "gc_mail2_12", "Nil16" } )
         :AddResource( "gc_mail2_16" )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Facturado"
         :nHeadBmpNo       := 4
         :bStrData         := {|| "" }
         :bBmpData         := {|| ( D():AlbaranesProveedores( nView ) )->nFacturado }
         :nWidth           := 20
         :AddResource( "gc_delete_12" )
         :AddResource( "gc_shape_square_12" )
         :AddResource( "gc_check_12" )
         :AddResource( "gc_trafficlight_on_16" )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Incidencia"
         :nHeadBmpNo       := 4
         :bStrData         := {|| "" }
         :bBmpData         := {|| nEstadoIncidencia( ( D():AlbaranesProveedores( nView ) )->cSerAlb + Str( ( D():AlbaranesProveedores( nView ) )->nNumAlb ) + ( D():AlbaranesProveedores( nView ) )->cSufAlb ) }
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
         :bEditValue       := {|| ( D():AlbaranesProveedores( nView ) )->lImprimido }
         :nWidth           := 20
         :lHide            := .t.
         :SetCheck( { "gc_printer2_12", "Nil16" } )
         :AddResource( "gc_printer2_16" )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Número"
         :cSortOrder       := "nNumAlb"
         :bEditValue       := {|| ( D():AlbaranesProveedores( nView ) )->cSerAlb + "/" + Alltrim( Str( ( D():AlbaranesProveedores( nView ) )->nNumAlb ) ) }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Su albarán"
         :cSortOrder       := "cSuAlb"
         :bEditValue       := {|| ( D():AlbaranesProveedores( nView ) )->cSuAlb }
         :nWidth           := 60
         :lHide            := .t.
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Delegación"
         :bEditValue       := {|| ( D():AlbaranesProveedores( nView ) )->cSufAlb }
         :nWidth           := 60
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Sesión"
         :bEditValue       := {|| Trans( ( D():AlbaranesProveedores( nView ) )->cTurAlb, "######" ) }
         :nWidth           := 60
         :lHide            := .t.
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Fecha"
         :cSortOrder       := "dDesFec"
         :bEditValue       := {|| Dtoc( ( D():AlbaranesProveedores( nView ) )->dFecAlb ) }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Hora"
         :bEditValue       := {|| trans( ( D():AlbaranesProveedores( nView ) )->tFecAlb, "@R 99:99:99") }
         :nWidth           := 60
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Caja"
         :bEditValue       := {|| ( D():AlbaranesProveedores( nView ) )->cCodCaj }
         :nWidth           := 40
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Usuario"
         :bEditValue       := {|| ( D():AlbaranesProveedores( nView ) )->cCodUsr }
         :nWidth           := 40
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Entrada"
         :cSortOrder       := "dFecEnt"
         :bEditValue       := {|| Dtoc( ( D():AlbaranesProveedores( nView ) )->dFecEnt ) }
         :nWidth           := 80
         :lHide            := .t.
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Código"
         :cSortOrder       := "cCodPrv"
         :bEditValue       := {|| ( D():AlbaranesProveedores( nView ) )->cCodPrv }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Nombre proveedor"
         :cSortOrder       := "cNomPrv"
         :bEditValue       := {|| ( D():AlbaranesProveedores( nView ) )->cNomPrv }
         :nWidth           := 180
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Base"
         :bEditValue       := {|| ( D():AlbaranesProveedores( nView ) )->nTotNet }
         :cEditPicture     := cPirDiv()
         :nWidth           := 80
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := cImp()
         :bEditValue       := {|| ( D():AlbaranesProveedores( nView ) )->nTotIva }
         :cEditPicture     := cPirDiv()
         :nWidth           := 80
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "R.E."
         :bEditValue       := {|| ( D():AlbaranesProveedores( nView ) )->nTotReq }
         :cEditPicture     := cPirDiv()
         :nWidth           := 80
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Total"
         :bEditValue       := {|| ( D():AlbaranesProveedores( nView ) )->nTotAlb }
         :cEditPicture     := cPirDiv()
         :nWidth           := 80
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Div."
         :bEditValue       := {|| cSimDiv( if( lEuro, cDivChg(), ( D():AlbaranesProveedores( nView ) )->cDivAlb ), D():Divisas( nView ) ) }
         :nWidth           := 30
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Total unidades"
         :bEditValue       := {|| nTotalUnd( D():AlbaranesProveedoresId( nView ), cPicUnd ) }
         :nWidth           := 80
         :lHide            := .t.
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Centro de coste"
         :bEditValue       := {|| ( D():AlbaranesProveedores( nView ) )->cCtrCoste }
         :nWidth           := 50
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Creación/Modificación"
         :bEditValue       := {|| dtoc( ( D():AlbaranesProveedores( nView ) )->dFecCre ) + space( 1 ) + ( D():AlbaranesProveedores( nView ) )->cTimCre }
         :nWidth           := 120
         :lHide            := .t.
      end with

      oDetCamposExtra:addCamposExtra( oWndBrw )

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

   DEFINE BTNSHELL RESOURCE "GC_PRINTER2_" OF oWndBrw ;
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

   DEFINE BTNSHELL oMail RESOURCE "GC_MAIL_EARTH_" OF oWndBrw ;
      NOBORDER ;
      MENU     This:Toggle() ;
      ACTION   ( oMailing:documentsDialog( oWndBrw:oBrw:aSelected ) ) ;
      TOOLTIP  "Correo electrónico";
      LEVEL    ACC_IMPR

   DEFINE BTNSHELL RESOURCE "gc_portable_barcode_scanner_" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( TLabelGeneratorAlbaranProveedores():New( nView, oNewImp ):Dialog() ) ;
         TOOLTIP  "Eti(q)uetas" ;
         HOTKEY   "Q";
         LEVEL    ACC_IMPR

   if oUser():lAdministrador()

      DEFINE BTNSHELL RESOURCE "ChgState" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( SetFacturadoAlbaranProveedores( nView ) );
         TOOLTIP  "Cambiar es(t)ado" ;
         HOTKEY   "T";
         LEVEL    ACC_EDIT

   end if

   DEFINE BTNSHELL oSnd RESOURCE "Lbl" GROUP OF oWndBrw ;
      NOBORDER ;
      MENU     This:Toggle() ;
      TOOLTIP  "En(v)iar" ;
      MESSAGE  "Seleccionar albaranes para ser enviados" ;
      ACTION   lSnd( oWndBrw, D():AlbaranesProveedores( nView ) ) ;
      HOTKEY   "V";
      LEVEL    ACC_EDIT

   DEFINE BTNSHELL oBtnEur RESOURCE "gc_currency_euro_" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( lEuro := !lEuro, oWndBrw:Refresh() ) ;
      TOOLTIP  "M(o)neda";
      HOTKEY   "O";

   if oUser():lAdministrador()

      //Condicionamos para que sólo el administrador toque los campos

      DEFINE BTNSHELL oRpl RESOURCE "BMPCHG" GROUP OF oWndBrw ;
         NOBORDER ;
         MENU     This:Toggle() ;
         ACTION   ( ReplaceCreator( oWndBrw, D():AlbaranesProveedores( nView ), aItmAlbPrv(), ALB_PRV ) ) ;
         TOOLTIP  "Cambiar campos" ;
         LEVEL    ACC_EDIT

         DEFINE BTNSHELL RESOURCE "BMPCHG" OF oWndBrw ;
            NOBORDER ;
            ACTION   ( ReplaceCreator( oWndBrw, D():AlbaranesProveedoresLineas( nView ), aColAlbPrv() ) ) ;
            TOOLTIP  "Lineas" ;
            FROM     oRpl ;
            CLOSED ;
            LEVEL    ACC_EDIT

   end if

   DEFINE BTNSHELL RESOURCE "INFO" GROUP OF oWndBrw ;
      NOBORDER ;
      ACTION   ( TTrazaDocumento():Activate( ALB_PRV, ( D():AlbaranesProveedores( nView ) )->cSerAlb + Str( ( D():AlbaranesProveedores( nView ) )->nNumAlb ) + ( D():AlbaranesProveedores( nView ) )->cSufAlb ) ) ;
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

      ImportScript( oWndBrw, oScript, "AlbaranesProveedores", nView )  

   DEFINE BTNSHELL oRotor RESOURCE "ROTOR" GROUP OF oWndBrw ;
      NOBORDER ;
      ACTION   ( oRotor:Expand() ) ;
      TOOLTIP  "Rotor" ;
      LEVEL    ACC_EDIT

      DEFINE BTNSHELL RESOURCE "GC_BUSINESSMAN_" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( EdtPrv( ( D():AlbaranesProveedores( nView ) )->cCodPrv ) );
         TOOLTIP  "Modificar proveedor" ;
         FROM     oRotor ;
         LEVEL    ACC_EDIT

      DEFINE BTNSHELL RESOURCE "INFO" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( InfProveedor( ( D():AlbaranesProveedores( nView ) )->cCodPrv ) );
         TOOLTIP  "Informe proveedor" ;
         FROM     oRotor ;
         LEVEL    ACC_EDIT

      DEFINE BTNSHELL RESOURCE "gc_cash_register_user_" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( if( !Empty( ( D():AlbaranesProveedores( nView ) )->cNumPed ), ZooPedPrv( ( D():AlbaranesProveedores( nView ) )->cNumPed ), msgStop( "No hay pedido asociado" ) ) );
         TOOLTIP  "Visualizar pedido" ;
         FROM     oRotor ;
         LEVEL    ACC_EDIT

      DEFINE BTNSHELL RESOURCE "gc_document_text_businessman_" OF oWndBrw ;
         ALLOW    EXIT ;
         ACTION   ( if( lFacturado( D():AlbaranesProveedores( nView ) ), MsgStop( "Albarán facturado" ), FacPrv( nil, oWnd, nil, nil, ( D():AlbaranesProveedores( nView ) )->cSerAlb + Str( ( D():AlbaranesProveedores( nView ) )->nNumAlb ) + ( D():AlbaranesProveedores( nView ) )->cSufAlb ) ) );
         TOOLTIP  "Generar factura" ;
         FROM     oRotor ;
         LEVEL    ACC_EDIT

      DEFINE BTNSHELL RESOURCE "gc_document_text_businessman_" OF oWndBrw ;
         ACTION   ( if( !Empty( ( D():AlbaranesProveedores( nView ) )->cNumFac ), EdtFacPrv( ( D():AlbaranesProveedores( nView ) )->cNumFac ), msgStop( "No hay factura asociada" ) ) );
         TOOLTIP  "Modificar factura" ;
         FROM     oRotor ;
         LEVEL    ACC_EDIT

      DEFINE BTNSHELL RESOURCE "gc_document_text_businessman_" OF oWndBrw ;
         ALLOW    EXIT ;
         ACTION   ( TFacturarLineasAlbaranesProveedor():New( nView ) );
         TOOLTIP  "Facturas parciales" ;
         FROM     oRotor

   if ( "ICG" $ appParamsMain() )

   DEFINE BTNSHELL RESOURCE "GC_DOCUMENT_EMPTY_" GROUP OF oWndBrw;
      NOBORDER ;
      ACTION   ( IcgMotor() ) ;
      TOOLTIP  "ICG" ;

   end if

   DEFINE BTNSHELL RESOURCE "END" GROUP OF oWndBrw ;
      ALLOW    EXIT ;
      ACTION   ( oWndBrw:End() ) ;
      TOOLTIP  "(S)alir";
      HOTKEY   "S"

   if .t. // SQLAjustableModel():getRolNoFiltrarVentas( Auth():rolUuid() )
      oWndBrw:oActiveFilter:SetFields( aItmAlbPrv() )
      oWndBrw:oActiveFilter:SetFilterType( ALB_PRV )
   end if

   ACTIVATE WINDOW oWndBrw VALID ( CloseFiles() )

   enableAcceso()

   if !Empty( oWndBrw )

      if uFieldempresa( 'lFltYea' )
         oWndBrw:setYearCombobox()
      end if

      if !Empty( cCodPrv ) .or. !Empty( cCodArt ) .or. !Empty( cCodPed )
         oWndBrw:RecAdd()
      end if

      cCodPrv  := nil
      cCodArt  := nil
      cCodPed  := nil

   end if

RETURN .t.

//----------------------------------------------------------------------------//

STATIC FUNCTION OpenFiles( lExt )

   local oBlock

   if lOpenFiles
      MsgStop( 'Ficheros de albaranes de proveedores ya abiertos' )
      RETURN ( .f. )
   end if

   DEFAULT lExt         := .f.

   lExternal            := lExt

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      DisableAcceso()

      lOpenFiles        := .t.

      nView             := D():CreateView()

      /*
      Compras------------------------------------------------------------------
      */

      D():AlbaranesProveedores( nView )
      D():AlbaranesProveedoresLineas( nView )
      D():AlbaranesProveedoresIncidencias( nView )
      D():AlbaranesProveedoresDocumentos( nView )
      D():AlbaranesProveedoresSeries( nView )

      D():Proveedores( nView )

      D():PedidosProveedores( nView )
      D():PedidosProveedoresLineas( nView )

      D():FacturasProveedores( nView )
      D():FacturasProveedoresLineas( nView )
      D():FacturasProveedoresPagos( nView )

      D():PartesProduccionMaterialProducido( nView )

      /*
      Articulos----------------------------------------------------------------
      */

      D():Articulos( nView )
      D():ArticulosCodigosBarras( nView )

      D():ProveedorArticulo( nView )
      ( D():ProveedorArticulo( nView ) )->( OrdSetFocus( "cCodPrv" ) ) 

      D():Familias( nView )

      D():Kit( nView )

      D():ArticuloPrecioPropiedades( nView )

      D():Propiedades( nView )

      D():PropiedadesLineas( nView )

      /*
      Generales----------------------------------------------------------------
      */

      D():Empresa( nView )

      D():Contadores( nView )

      D():Delegaciones( nView )

      D():Cajas( nView )

      D():FormasPago( nView )

      D():TiposIva( nView )

      D():Divisas( nView )

      D():Documentos( nView )
      ( D():Documentos( nView ) )->( OrdSetFocus( "cTipo" ) )

      D():GetObject( "UnidadMedicion", nView )

      D():ArticuloLenguaje( nView )

      D():ImpuestosEspeciales( nView )

      /*
      Almacenes----------------------------------------------------------------
      */

      D():Almacen( nView )

      D():UbicacionLineas( nView )

      /*
      Ventas-------------------------------------------------------------------
      */

      D():PedidosClientes( nView )

      oMailing          := TGenmailingDatabaseAlbaranesProveedor():New( nView )

      /*
      Stocks-------------------------------------------------------------------
      */

      oStock               := TStock():Create( cPatEmp() )
      if !oStock:lOpenFiles()
         lOpenFiles        := .f.
      end if

      /*
      Centro de coste-----------------------------------------------------------
      */
      oCentroCoste      := TCentroCoste():Create( cPatDat() )
      if !oCentroCoste:OpenFiles()
         lOpenFiles     := .f.
      end if

      oNewImp           := TNewImp():Create( cPatEmp() )
      if !oNewImp:OpenFiles()
         lOpenFiles     := .f.
      end if

      CodigosPostales():GetInstance():OpenFiles()

      oBandera          := TBandera():New()

      TComercio         := TComercio():New( nView, oStock )

      cPicUnd           := MasUnd()                               // Picture de las unidades

      Counter           := TCounter():New( nView, "nAlbPrv" )

      initPublics()

      /*
      Numeros de serie---------------------------------------------------------
      */

      oNumerosSerie           := TNumerosSerie()
      oNumerosSerie:lCompras  := .t.
      oNumerosSerie:oStock    := oStock

      EnableAcceso()

      /*
      Campos extras------------------------------------------------------------------------
      */

      oDetCamposExtra         := TDetCamposExtra():New()
      oDetCamposExtra:OpenFiles()
      oDetCamposExtra:SetTipoDocumento( "Albaranes a proveedores" )
      oDetCamposExtra:setbId( {|| D():AlbaranesProveedoresId( nView ) } )

      oLinDetCamposExtra               := TDetCamposExtra():New()
      oLinDetCamposExtra:OpenFiles()
      oLinDetCamposExtra:setTipoDocumento( "Lineas albaranes a proveedores" )
      oLinDetCamposExtra:setbId( {|| D():AlbaranesProveedoresLineasNumero( nView ) } )

   RECOVER

      lOpenFiles              := .f.

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

   DestroyFastFilter( D():AlbaranesProveedores( nView ), .t., .t. )

   if !Empty( oFont )
      oFont:end()
   end if

   if oStock != nil
      oStock:end()
   end if

   if !Empty( oDetCamposExtra )
      oDetCamposExtra:CloseFiles()
   end if

   if !empty( oLinDetCamposExtra )
      oLinDetCamposExtra:CloseFiles()
      oLinDetCamposExtra:End()
   end if

   if !Empty( oCentroCoste )
      oCentroCoste:end()
   end if

   if !empty( oNewImp )
      oNewImp:end()
   end if

   if !empty(oMailing)
      oMailing:end()
   end if 

   D():DeleteView( nView )

   CodigosPostales():GetInstance():CloseFiles()

   TComercio:end()

   oBandera    := nil
   oStock      := nil

   lOpenFiles  := .f.

   oWndBrw     := nil

   oNewImp     := nil

   nView       := nil

   EnableAcceso()

RETURN .T.

//----------------------------------------------------------------------------//

STATIC FUNCTION EdtRec( aTmp, aGet, dbf, oBrw, cCodPrv, cCodArt, nMode, cCodPed )

   local nOrd
   local oDlg
   local oFld
   local oBrwLin
   local oBrwInc
   local oBrwDoc
   local oBmpDiv
   local oSay           := Array( 7 )
   local cSay           := Array( 7 )
   local oSayLabels     := Array( 7 )
   local oGetMasDiv
   local cGetMasDiv     := ""
   local oBmpEmp
   local cEstado        := if( aTmp[ _NFACTURADO ] == 3, "Facturado", "No facturado" )
   local cTlfPrv
   local oTlfPrv
   local oBmpGeneral

   cTlfPrv              := RetFld( aTmp[ _CCODPRV ], D():Proveedores( nView ), "Telefono" )

	DO CASE
   CASE nMode == APPD_MODE

      if !lCajaOpen( Application():CodigoCaja() ) .and. !oUser():lAdministrador()
         msgStop( "Esta caja " + Application():CodigoCaja() + " esta cerrada." )
         RETURN .f.
      end if

      aTmp[ _CSERALB ]     := cNewSer( "NALBPRV", D():Contadores( nView ) )
      aTmp[ _CTURALB ]     := cCurSesion()
      aTmp[ _CCODALM ]     := Application():codigoAlmacen()
      aTmp[ _CCODCAJ ]     := Application():CodigoCaja()
      aTmp[ _CDIVALB ]     := cDivEmp()
      aTmp[ _NVDVALB ]     := nChgDiv( aTmp[ _CDIVALB ], D():Divisas( nView ) )
      aTmp[ _CSUFALB ]     := RetSufEmp()
      aTmp[ _LSNDDOC ]     := .t.
      aTmp[ _CCODUSR ]     := Auth():Codigo()
      aTmp[ _CCODDLG ]     := Application():CodigoDelegacion()
      aTmp[ _DFECIMP ]     := Ctod( "" )
      aTmp[ _DSUALB  ]     := Ctod( "" )
      aTmp[ _NFACTURADO ]  := 1
      aTmp[ _TFECALB ]     := getSysTime()

      if !Empty( cCodPrv )
         aTmp[ _CCODPRV ]  := cCodPrv
      end if

      if !Empty( cCodPed )
         aTmp[ _CNUMPED ]  := cCodPed
      end if

   CASE nMode == DUPL_MODE

      if !lCajaOpen( Application():CodigoCaja() ) .and. !oUser():lAdministrador()
         msgStop( "Esta caja " + Application():CodigoCaja() + " esta cerrada." )
         RETURN .f.
      end if

      aTmp[ _CTURALB ]     := cCurSesion()
      aTmp[ _CCODCAJ ]     := Application():CodigoCaja()
      aTmp[ _LSNDDOC ]     := .t.
      aTmp[ _DFECIMP ]     := Ctod( "" )
      aTmp[ _LCLOALB ]     := .f.
      aTmp[ _NFACTURADO ]  := 1

   CASE nMode == EDIT_MODE

      if aTmp[ _NFACTURADO ] == 3
         msgStop( "Albarán ya fue facturado." )
         RETURN .t.
      end if

      if aTmp[ _LCLOALB ] .AND. !oUser():lAdministrador()
         msgStop( "Solo puede modificar los albaranes cerrados los administradores." )
         RETURN .f.
      end if

   END CASE

   if Empty( aTmp[ _CDTOESP ] )
      aTmp[ _CDTOESP ]  := Padr( "General", 50 )
   end if

   if Empty( aTmp[ _CDPP ] )
      aTmp[ _CDPP ]     := Padr( "Pronto pago", 50 )
   end if

   if BeginTrans( aTmp, nMode )
      RETURN .f.
   end if

   /*
   Este valor los guaradamos para detectar los posibles cambios
   */

   cOldCodCli           := aTmp[ _CCODPRV ]

   /*
   Necestamos el orden el la primera clave
   */

   nOrd                 := ( D():AlbaranesProveedores( nView ) )->( ordSetFocus( 1 ) )

   cPicUnd              := MasUnd()                               // Picture de las unidades
   cPinDiv              := cPinDiv( aTmp[ _CDIVALB ], D():Divisas( nView ) ) // Picture de la divisa
   cPirDiv              := cPirDiv( aTmp[ _CDIVALB ], D():Divisas( nView ) ) // Picture de la divisa redondeada
   nDinDiv              := nDinDiv( aTmp[ _CDIVALB ], D():Divisas( nView ) ) // Decimales de la divisa
   nDirDiv              := nRouDiv( aTmp[ _CDIVALB ], D():Divisas( nView ) ) // Decimales de la divisa redondeada

   oFont                := TFont():New( "Arial", 8, 26, .F., .T. )

   /*
   Etiquetas-------------------------------------------------------------------
   */

   cSay[ 2 ]            := RetFld( aTmp[ _CCODALM ], D():Almacen( nView ) )
   cSay[ 3 ]            := RetFld( aTmp[ _CCODPGO ], D():FormasPago( nView ) )
   cSay[ 4 ]            := RetFld( aTmp[ _CCODCAJ ], D():Cajas( nView ) )
   cSay[ 5 ]            := RetFld( aTmp[ _CCODPRV ], D():Proveedores( nView ) )
   cSay[ 6 ]            := RetFld( cCodEmp() + aTmp[ _CCODDLG ], D():Delegaciones( nView ), "cNomDlg" )
   cSay[ 7 ]            := RetFld( aTmp[ _CALMORIGEN ], D():Almacen( nView ) )

   cUsr                 := SQLUsuariosModel():getNombreWhereCodigo( aTmp[ _CCODUSR ] )

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
        RESOURCE "gc_document_empty_48" ;
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
        RESOURCE "gc_folders_48" ;
        TRANSPARENT ;
        OF       oFld:aDialogs[4]

      REDEFINE GET aGet[ _CCODUSR ] VAR aTmp[ _CCODUSR ];
         ID       220 ;
         WHEN     ( .f. ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET oUsr VAR cUsr ;
         ID       221 ;
         WHEN     ( .f. ) ;
         OF       oFld:aDialogs[2]


      /*
      Datos del Proveedor______________________________________________________
      */

      REDEFINE GET aGet[_CCODPRV] VAR aTmp[_CCODPRV] ;
			ID 		140 ;
			COLOR 	CLR_GET ;
			PICTURE	( RetPicCodPrvEmp() ) ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         VALID    ( LoaPrv( aGet, aTmp, nMode, oSay[ 5 ], oTlfPrv ) ) ;
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
         BITMAP   "gc_earth_lupa_16" ;
         ON HELP  GoogleMaps( aTmp[ _CDIRPRV ], Rtrim( aTmp[ _CPOBPRV ] ) + Space( 1 ) + Rtrim( aTmp[ _CPROPRV ] ) ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CPOSPRV ] VAR aTmp[ _CPOSPRV ] ;
         ID       102 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         VALID    ( CodigosPostales():GetInstance():validCodigoPostal() );
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

		REDEFINE GET aGet[ _CCODPGO ] VAR aTmp[ _CCODPGO ];
			ID 		160 ;
			PICTURE 	"@!" ;
			COLOR 	CLR_GET ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         VALID    cFPago( aGet[ _CCODPGO ], D():FormasPago( nView ), oSay[ 3 ] ) ;
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
         VALID    cCajas( aGet[ _CCODCAJ ], D():Cajas( nView ), oSay[ 4 ] ) ;
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
         VALID    ( cDivIn( aGet[ _CDIVALB ], oBmpDiv, aGet[ _NVDVALB ], @cPinDiv, @nDinDiv, @cPirDiv, @nDirDiv, oGetMasDiv, D():Divisas( nView ), oBandera ) );
			PICTURE	"@!";
			ID 		170 ;
			COLOR 	CLR_GET ;
         BITMAP   "LUPA" ;
         ON HELP  BrwDiv( aGet[ _CDIVALB ], oBmpDiv, aGet[ _NVDVALB ], D():Divisas( nView ), oBandera ) ;
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

      REDEFINE GET aGet[ _CALMORIGEN ] VAR aTmp[ _CALMORIGEN ]  ;
         ID       340 ;
         IDSAY    342 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( cAlmacen( aGet[ _CALMORIGEN ], , oSay[ 7 ] ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwAlmacen( aGet[ _CALMORIGEN ], oSay[ 7 ] ) ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET oSay[ 7 ] VAR cSay[ 7 ] ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ID       341 ;
         BITMAP   "Bot" ;
         ON HELP  ( ExpAlmacen( aTmp[ _CALMORIGEN ], dbfTmp, oBrwLin ) ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET   aGet[ _CCODALM ] ;
         VAR         aTmp[ _CCODALM ] ;
			ID          150 ;
			WHEN        ( nMode != ZOOM_MODE ) ;
         VALID       ( cAlmacen( aGet[ _CCODALM ], , oSay[ 2 ] ) ) ;
         BITMAP      "Lupa" ;
         ON HELP     ( BrwAlmacen( Self, oSay[ 2 ] ) ) ;
			OF          oFld:aDialogs[1]

      REDEFINE GET   oSay[ 2 ] ;
         VAR         cSay[ 2 ] ;
         WHEN        ( nMode != ZOOM_MODE ) ;
			ID          151 ;
         BITMAP      "Bot" ;
         ON HELP     ( ExpAlmacen( aTmp[ _CCODALM ], dbfTmp, oBrwLin ) ) ;
         OF          oFld:aDialogs[1]

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
      oBrwLin:lFooter         := .t.
      oBrwLin:cName           := "Lineas de albaranes a proveedor"

         with object ( oBrwLin:AddCol() )
            :cHeader             := "Facturado"
            :bStrData            := {|| "" }
            :bEditValue          := {|| ( dbfTmp )->lFacturado }
            :nWidth              := 20
            :SetCheck( { "gc_check_12", "gc_delete_12" } )
         end with

         with object ( oBrwLin:AddCol() )
            :cHeader          := "Número"
            :bEditValue       := {|| if( ( dbfTmp )->lKitChl, "", Trans( ( dbfTmp )->nNumLin, "9999" ) ) }
            :nWidth           := 65
            :nDataStrAlign    := 1
            :nHeadStrAlign    := 1
            :lHide            := .t.
         end with

         with object ( oBrwLin:AddCol() )
            :cHeader             := "Posición"
            :cSortOrder          := "nPosPrint"
            :bEditValue          := {|| ( dbfTmp )->nPosPrint }
            :bLClickHeader       := {| nMRow, nMCol, nFlags, oCol | if( !empty( oCol ), oCol:SetOrder(), ) }
            :cEditPicture        := "9999"
            :nWidth              := 60
            :nDataStrAlign       := 1
            :nHeadStrAlign       := 1
         end with 

         with object ( oBrwLin:AddCol() )
            :cHeader          := "Código"
            :bEditValue       := {|| ( dbfTmp )->cRef }
            :nWidth           := 80
         end with

         with object ( oBrwLin:AddCol() )
            :cHeader          := "C. Barras"
            :bEditValue       := {|| cCodigoBarrasDefecto( ( dbfTmp )->cRef, D():ArticulosCodigosBarras( nView ) ) }
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
            :cHeader          := "Valor prop. 1"
            :bEditValue       := {|| nombrePropiedad( ( dbfTmp )->cCodPr1, ( dbfTmp )->cValPr1, nView ) }
            :nWidth           := 40
            :lHide            := .t.
         end with

         with object ( oBrwLin:AddCol() )
            :cHeader          := "Prop. 2"
            :bEditValue       := {|| ( dbfTmp )->cValPr2 }
            :nWidth           := 60
            :lHide            := .t.
         end with

         with object ( oBrwLin:AddCol() )
            :cHeader          := "Valor prop. 2"
            :bEditValue       := {|| nombrePropiedad( ( dbfTmp )->cCodPr2, ( dbfTmp )->cValPr2, nView ) }
            :nWidth           := 40
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
            :cHeader          := "Bultos"
            :bEditValue       := {|| ( dbfTmp )->nBultos }
            :cEditPicture     := cPicUnd
            :nWidth           := 60
            :nDataStrAlign    := 1
            :nHeadStrAlign    := 1
            :lHide            := .t.
         end with

         with object ( oBrwLin:AddCol() )
            :cHeader          := cNombreCajas()
            :bEditValue       := {|| ( dbfTmp )->nCanPed }
            :cEditPicture     := cPicUnd
            :nWidth           := 60
            :nDataStrAlign    := 1
            :nHeadStrAlign    := 1
            :lHide            := .t.
            :nEditType        := 1
            :bOnPostEdit      := {|o,x,n| ChangeCajas( o, x, n, aTmp ) }
         end with

         with object ( oBrwLin:AddCol() )
            :cHeader          := cNombreUnidades()
            :bEditValue       := {|| ( dbfTmp )->nUniCaja }
            :cEditPicture     := cPicUnd
            :nWidth           := 60
            :nDataStrAlign    := 1
            :nHeadStrAlign    := 1
            :nFooterType      := AGGR_SUM
            :lHide            := .t.
            :nEditType        := 1
            :bOnPostEdit      := {|o,x,n| ChangeUnidades( o, x, n, aTmp ) }
         end with

         with object ( oBrwLin:AddCol() )
            :cHeader          := "Tot. " + cNombreUnidades()
            :bEditValue       := {|| nTotNAlbPrv( dbfTmp ) }
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
            :nWidth           := 60
         end with

         with object ( oBrwLin:AddCol() )
            :cHeader          := "Importe"
            :bEditValue       := {|| nTotUAlbPrv( dbfTmp, nDinDiv ) }
            :cEditPicture     := cPinDiv
            :nWidth           := 90
            :nDataStrAlign    := 1
            :nHeadStrAlign    := 1
            :nEditType        := 1
            :bOnPostEdit      := {|o,x,n| ChangePrecio( o, x, n, aTmp ) }
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
            :nFooterType      := AGGR_SUM
         end with

         with object ( oBrwLin:AddCol() )
            :cHeader          := "Centro de coste"
            :bEditValue       := {|| ( dbfTmp )->cCtrCoste }
            :nWidth           := 40
            :lHide            := .t.
         end with

         if nMode != ZOOM_MODE
            oBrwLin:bLDblClick   := {|| EditDetail( oBrwLin, bEdtDet, aTmp ) }
         end if

         oBrwLin:CreateFromResource( 190 )

		REDEFINE BUTTON ;
			ID 		500 ;
			OF 		oFld:aDialogs[1] ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( AppendDetail( oBrwLin, bEdtDet, aTmp ) )

		REDEFINE BUTTON ;
			ID 		501 ;
			OF 		oFld:aDialogs[1] ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( EditDetail( oBrwLin, bEdtDet, aTmp ) )

		REDEFINE BUTTON ;
			ID 		502 ;
			OF 		oFld:aDialogs[1] ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( WinDelRec( oBrwLin, dbfTmp, {|| delDeta() }, {|| RecalculaTotal( aTmp ) } ) )

		REDEFINE BUTTON ;
			ID 		503 ;
			OF 		oFld:aDialogs[1] ;
         ACTION   ( ZoomDetail( oBrwLin, bEdtDet, aTmp ) )

		REDEFINE BUTTON ;
			ID 		524 ;
			OF 		oFld:aDialogs[1] ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( LineUp( dbfTmp, oBrwLin ) )

		REDEFINE BUTTON ;
			ID 		525 ;
			OF 		oFld:aDialogs[1] ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( LineDown( dbfTmp, oBrwLin ) )

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
      Desglose del impuestos---------------------------------------------------
      */

      oBrwIva                        := IXBrowse():New( oFld:aDialogs[ 1 ] )

      oBrwIva:bClrSel                := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwIva:bClrSelFocus           := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrwIva:SetArray( aTotIva, , , .f. )

      oBrwIva:lHScroll               := .f.
      oBrwIva:lVScroll               := .f.
      oBrwIva:lRecordSelector        := .f.
      oBrwIva:nMarqueeStyle          := 5

      oBrwIva:CreateFromResource( 490 )

      with object ( oBrwIva:AddCol() )
         :cHeader          := "Base"
         :bStrData         := {|| if( aTotIva[ oBrwIva:nArrayAt, 3 ] != nil, Trans( aTotIva[ oBrwIva:nArrayAt, 2 ], cPirDiv ), "" ) }
         :nWidth           := 76
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      with object ( oBrwIva:AddCol() )
         :cHeader          := "Imp. esp."
         :bStrData         := {|| if( aTotIva[ oBrwIva:nArrayAt, 3 ] != nil, Trans( aTotIva[ oBrwIva:nArrayAt, 6 ], cPirDiv ), "" ) }
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
         :bOnPostEdit      := {|o,x| EdtIva( o, x, aTotIva[ oBrwIva:nArrayAt, 3 ], dbfTmp, D():TiposIva( nView ), oBrwLin ), RecalculaTotal( aTmp ) }
      end with

      with object ( oBrwIva:AddCol() )
         :cHeader          := cImp()
         :bStrData         := {|| if( aTotIva[ oBrwIva:nArrayAt, 3 ] != nil, Trans( aTotIva[ oBrwIva:nArrayAt, 8 ], cPirDiv ), "" ) }
         :nWidth           := 76
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      with object ( oBrwIva:AddCol() )
         :cHeader          := "% R.E."
         :bStrData         := {|| if( aTotIva[ oBrwIva:nArrayAt, 3 ] != nil .and. aTmp[ _LRECARGO ],  Trans( aTotIva[ oBrwIva:nArrayAt, 4 ], "@E 999.99"), "" ) }
         :nWidth           := 44
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      with object ( oBrwIva:AddCol() )
         :cHeader          := "R.E."
         :bStrData         := {|| if( aTotIva[ oBrwIva:nArrayAt, 3 ] != nil .and. aTmp[ _LRECARGO ],  Trans( aTotIva[ oBrwIva:nArrayAt, 9 ], cPirDiv ), "" ) }
         :nWidth           := 76
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
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

      REDEFINE SAY oGetIvm VAR nTotIvm;
         ID       403 ;
         OF       oFld:aDialogs[1]

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
			OF 		oFld:aDialogs[1]

      REDEFINE GET aGet[ _TFECALB ] VAR aTmp[ _TFECALB ] ;
         ID       111 ;
         PICTURE  "@R 99:99:99" ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( iif(   !validTime( aTmp[ _TFECALB ] ),;
                           ( msgStop( "El formato de la hora no es correcto" ), .f. ),;
                           .t. ) );
         OF       oFld:aDialogs[1]

      REDEFINE BUTTON ;
         ID       557 ;
         OF       oFld:aDialogs[1] ;
         ACTION   ( importarLineasPedidosProveedor( aTmp, aGet, oBrwLin )  )

      REDEFINE BUTTON ;
         ID       558 ;
         OF       oFld:aDialogs[1] ;
         WHEN     ( nMode == APPD_MODE .and. Empty( aTmp[ _CNUMPED ] ) ) ;
         ACTION   ( GrpPed( aGet, aTmp, oBrwLin, nMode ) )

      REDEFINE GET aGet[ _CNUMPED ] VAR aTmp[ _CNUMPED ];
			ID 		120 ;
         PICTURE  "@R #/#########/##" ;
         WHEN     ( nMode == APPD_MODE );
         VALID    ( cPedPrv( aGet, aTmp, oBrwLin, nMode ) );
			COLOR 	CLR_GET ;
         BITMAP   "LUPA" ;
         ON HELP  (  brwPedPrv( aGet[ _CNUMPED ], D():PedidosProveedores( nView ), D():PedidosProveedoresLineas( nView ), D():TiposIva( nView ), D():Divisas( nView ), D():FormasPago( nView ) ),;
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

      // Centro de coste

      REDEFINE GET aGet[ _CCENTROCOSTE ] VAR aTmp[ _CCENTROCOSTE ] ;
         ID       310 ;
         IDTEXT   311 ;
         BITMAP   "LUPA" ;
         VALID    ( oCentroCoste:Existe( aGet[ _CCENTROCOSTE ], aGet[ _CCENTROCOSTE ]:oHelpText, "cNombre" ) );
         ON HELP  ( oCentroCoste:Buscar( aGet[ _CCENTROCOSTE ] ) ) ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

      // Segunda caja de dialogo

      REDEFINE GET aGet[ _CCODDLG ] VAR aTmp[ _CCODDLG ] ;
         ID       300 ;
         WHEN     ( .f. ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET oSay[ 6 ] VAR cSay[ 6 ] ;
         ID       301 ;
         WHEN     ( .f. ) ;
         OF       oFld:aDialogs[2]

      // Regimen de impuestos-----------------------------------------------------------

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

      oBrwDoc                 := IXBrowse():New( oFld:aDialogs[ 4 ] )

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
         ACTION   ( EndTrans( aTmp, aGet, nDinDiv, nDirDiv, oBrw, nMode, oDlg ) )

      REDEFINE BUTTON ;
         ID       3 ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( if( EndTrans( aTmp, aGet, nDinDiv, nDirDiv, oBrw, nMode, oDlg ), GenAlbPrv( IS_PRINTER ), ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
         CANCEL ;
         ACTION   ( If( ExitNoSave( nMode, dbfTmp ), oDlg:end(), ) )

   CodigosPostales():GetInstance():setBinding( { "CodigoPostal" => aGet[ _CPOSPRV ], "Poblacion" => aGet[ _CPOBPRV ], "Provincia" => aGet[ _CPROPRV ] } )

   if nMode != ZOOM_MODE
      oFld:aDialogs[1]:AddFastKey( VK_F2, {|| AppendDetail( oBrwLin, bEdtDet, aTmp ) } )
      oFld:aDialogs[1]:AddFastKey( VK_F3, {|| EditDetail( oBrwLin, bEdtDet, aTmp ) } )
      oFld:aDialogs[1]:AddFastKey( VK_F4, {|| WinDelRec( oBrwLin, dbfTmp, {|| delDeta() }, {|| RecalculaTotal( aTmp ) } ) } )

      oFld:aDialogs[3]:AddFastKey( VK_F2, {|| WinAppRec( oBrwInc, bEdtInc, dbfTmpInc, nil, nil, aTmp ) } )
      oFld:aDialogs[3]:AddFastKey( VK_F3, {|| WinEdtRec( oBrwInc, bEdtInc, dbfTmpInc, nil, nil, aTmp ) } )
      oFld:aDialogs[3]:AddFastKey( VK_F4, {|| DbDelRec( oBrwInc, dbfTmpInc, nil, nil, .t. ) } )

      oFld:aDialogs[4]:AddFastKey( VK_F2, {|| WinAppRec( oBrwDoc, bEdtDoc, dbfTmpDoc, nil, nil, aTmp ) } )
      oFld:aDialogs[4]:AddFastKey( VK_F3, {|| WinEdtRec( oBrwDoc, bEdtDoc, dbfTmpDoc, nil, nil, aTmp ) } )
      oFld:aDialogs[4]:AddFastKey( VK_F4, {|| DbDelRec( oBrwDoc, dbfTmpDoc, nil, nil, .f. ) } )

      oDlg:AddFastKey( VK_F7, {|| ExcelImport( aTmp, dbfTmp, D():Articulos( nView ), D():ArticuloPrecioPropiedades( nView ), D():Familias( nView ), D():Divisas( nView ), oBrwLin, , D():Kit( nView ) ) } )
      oDlg:AddFastKey( VK_F5, {|| EndTrans( aTmp, aGet, nDinDiv, nDirDiv, oBrw, nMode, oDlg ) } )
      oDlg:AddFastKey( VK_F6, {|| if( EndTrans( aTmp, aGet, nDinDiv, nDirDiv, oBrw, nMode, oDlg ), GenAlbPrv( IS_PRINTER ), ) } )
      oDlg:AddFastKey( VK_F9,{|| oDetCamposExtra:Play( space(1) ) } )
      oDlg:AddFastKey( 65,    {|| if( GetKeyState( VK_CONTROL ), CreateInfoArticulo(), ) } )
   end if

   oDlg:AddFastKey ( VK_F1, {|| GoHelp() } )

   do case
      case nMode == APPD_MODE .and. lRecogerUsuario() .and. Empty( cCodArt )
         oDlg:bStart := {|| if( lGetUsuario( aGet[ _CCODUSR ] ),;
                              ( ShowKitCom( D():AlbaranesProveedores( nView ), dbfTmp, oBrwLin, cCodPrv, dbfTmpInc, aGet ), StartEdtRecAlbProv( aGet, oSay, nMode ) ),;
                              oDlg:end() ) }

      case nMode == APPD_MODE .and. lRecogerUsuario() .and. !Empty( cCodArt )
         oDlg:bStart := {|| if( lGetUsuario( aGet[ _CCODUSR ] ),;
                              ( AppendDetail( oBrwLin, bEdtDet, aTmp, cCodArt ), ShowKitCom( D():AlbaranesProveedores( nView ), dbfTmp, oBrwLin, cCodPrv, dbfTmpInc, aGet ), StartEdtRecAlbProv( aGet, oSay, nMode ) ),;
                              oDlg:end() ) }

      case nMode == APPD_MODE .and. !lRecogerUsuario() .and. !Empty( cCodArt )
         oDlg:bStart := {|| AppendDetail( oBrwLin, bEdtDet, aTmp, cCodArt ), ShowKitCom( D():AlbaranesProveedores( nView ), dbfTmp, oBrwLin, cCodPrv, dbfTmpInc, aGet ), StartEdtRecAlbProv( aGet, oSay, nMode ) }

      otherwise
         oDlg:bStart := {|| ShowKitCom( D():AlbaranesProveedores( nView ), dbfTmp, oBrwLin, cCodPrv, dbfTmpInc, aGet ), StartEdtRecAlbProv( aGet, oSay, nMode ) }

   end case

	ACTIVATE DIALOG oDlg	;
      ON INIT     (  initEdtRec( cCodPed, aTmp, oDlg, oBrwLin, aGet) ) ;
      ON PAINT    ( RecalculaTotal( aTmp ) );
      CENTER

   EndEdtRecMenu() 

   oBmpEmp:end()
   oBmpDiv:end()
   oFont:end()
   oBmpGeneral:End()

   ( D():AlbaranesProveedores( nView ) )->( OrdSetFocus( nOrd ) )

   /*
   Estado anterior del pedido si lo hay----------------------------------------
   */

   if !Empty( aTmp[_CNUMPED] ) .and. nOldEst != nil
      if dbLock( D():PedidosProveedores( nView ) )
         ( D():PedidosProveedores( nView ) )->nEstado := nOldEst
         ( D():PedidosProveedores( nView ) )->( dbUnLock() )
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

Static FUNCTION initEdtRec( cCodPed, aTmp, oDlg, oBrwLin, aGet )

   if !Empty( cCodPed )
      aGet[ _CNUMPED ]:lValid()
   endif
                     
   EdtRecMenu( aTmp, aGet, oBrwLin, oDlg )

   oBrwLin:MakeTotals()

   oBrwLin:Load()

return( .t. )

//----------------------------------------------------------------------------//

Static FUNCTION ChangePrecio( oCol, uNewValue, nKey, aTmp )

   /*
   Cambiamos el valor de las unidades de la linea de la factura---------------
   */

   if IsNum( nKey ) .and. ( nKey != VK_ESCAPE ) .and. !IsNil( uNewValue )

      ( dbfTmp )->nPreDiv       := uNewValue

      RecalculaTotal( aTmp )

   end if

RETURN .t.

//----------------------------------------------------------------------------//

Static FUNCTION ChangeCajas( oCol, uNewValue, nKey, aTmp )

   /*
   Cambiamos el valor de las unidades de la linea de la factura---------------
   */

   if IsNum( nKey ) .and. ( nKey != VK_ESCAPE ) .and. !IsNil( uNewValue )

      ( dbfTmp )->nCanPed       := uNewValue

      RecalculaTotal( aTmp )

   end if

RETURN .t.

//----------------------------------------------------------------------------//

Static FUNCTION ChangeUnidades( oCol, uNewValue, nKey, aTmp )

   /*
   Cambiamos el valor de las unidades de la linea de la factura---------------
   */

   if IsNum( nKey ) .and. ( nKey != VK_ESCAPE ) .and. !IsNil( uNewValue )

      ( dbfTmp )->nUniCaja       := uNewValue

      RecalculaTotal( aTmp )

   end if

RETURN .t.

//----------------------------------------------------------------------------//

Static FUNCTION StartEdtRecAlbProv( aGet, oSay, nMode )

   if uFieldEmpresa( "lShowOrg" )
      aGet[ _CALMORIGEN ]:Show()
      oSay[7]:Show()
   else
      aGet[ _CALMORIGEN ]:Hide()
      oSay[7]:Hide()
   end if

   if nMode != APPD_MODE

      if !empty( aGet[ _CCENTROCOSTE ] )
         aGet[ _CCENTROCOSTE ]:lValid()
      endif

   endif



RETURN ( .t. )

//----------------------------------------------------------------------------//

Static FUNCTION edtRecMenu( aTmp, aGet, oBrwLin, oDlg )

   MENU oMenu

      MENUITEM    "&1. Rotor"

         MENU

            if !lExternal

            MENUITEM    "&1. Campos extra [F9]";
               MESSAGE  "Mostramos y rellenamos los campos extra para la familia" ;
               RESOURCE "GC_FORM_PLUS2_16" ;
               ACTION   ( oDetCamposExtra:Play( space(1) ) )

            MENUITEM    "&2. Visualizar pedido";
               MESSAGE  "Visualiza el pedido del que proviene" ;
               RESOURCE "gc_clipboard_empty_businessman_16" ;
               ACTION   ( if(!Empty( aTmp[ _CNUMPED ] ), ZooPedPrv( aTmp[ _CNUMPED ] ), msgStop( "No hay pedido asociado" ) ) )

            SEPARATOR

            MENUITEM    "&3. Modificar proveedor";
               MESSAGE  "Modificar la ficha del proveedor" ;
               RESOURCE "gc_businessman_16" ;
               ACTION   ( EdtPrv( aTmp[ _CCODPRV ] ) )

            MENUITEM    "&4. Informe de proveedor";
               MESSAGE  "Abrir el informe del proveedor" ;
               RESOURCE "Info16" ;
               ACTION   ( InfProveedor( aTmp[ _CCODPRV ] ) );

            SEPARATOR

            end if

            MENUITEM    "&5. Informe del documento";
               MESSAGE  "Abrir el informe del documento" ;
               RESOURCE "Info16" ;
               ACTION   ( TTrazaDocumento():Activate( ALB_PRV, ( D():AlbaranesProveedores( nView ) )->cSerAlb + Str( ( D():AlbaranesProveedores( nView ) )->nNumAlb ) + ( D():AlbaranesProveedores( nView ) )->cSufAlb ) )

         ENDMENU

   ENDMENU

   oDlg:SetMenu( oMenu )

RETURN ( oMenu )

//----------------------------------------------------------------------------//

Static FUNCTION EndEdtRecMenu()

RETURN ( oMenu:End() )

//---------------------------------------------------------------------------//

Static FUNCTION RecalculaAlbaranProveedores( aTmp, oDlg )

   local nRecNum
   local nPreCom
   local cCodPrv                    := aTmp[ _CCODPRV ]

   if !ApoloMsgNoYes( "¡Atención!,"                                      + CRLF + ;
                  "todos los precios se recalcularán en función de"  + CRLF + ;
                  "los valores en las bases de datos.",;
                  "¿ Desea proceder ?" )
      RETURN nil
   end if

   oDlg:Disable()

   ( D():Articulos( nView ) )->( ordSetFocus( "Codigo" ) )

   nRecNum                          := ( dbfTmp )->( RecNo() )

   ( dbfTmp )->( dbGotop() )
   while !( dbfTmp )->( eof() )

      /*
      Ahora buscamos por el codigo interno
      */

      nPreCom                       := nComPro( ( dbfTmp )->cRef, ( dbfTmp )->cCodPr1, ( dbfTmp )->cValPr1, ( dbfTmp )->cCodPr2, ( dbfTmp )->cValPr2, D():ArticuloPrecioPropiedades( nView ) )

      if nPrecom  != 0

         ( dbfTmp )->nPreDiv        := nPreCom

      else

         if uFieldEmpresa( "lCosPrv", .f. )
            nPreCom                 := nPrecioReferenciaProveedor( cCodPrv, ( dbfTmp )->cRef, D():ProveedorArticulo( nView ) )
         end if

         if nPreCom != 0
            ( dbfTmp )->nPreDiv     := nPreCom
         else
            ( dbfTmp )->nPreDiv     := nCosto( ( dbfTmp )->cRef, D():Articulos( nView ), D():Kit( nView ), .f., aTmp[ _CDIVALB ], D():Divisas( nView ) )
         end if

         /*
         Descuento de articulo----------------------------------------------
         */

         if uFieldEmpresa( "lCosPrv", .f. )

            nPreCom                 := nDescuentoReferenciaProveedor( cCodPrv, ( dbfTmp )->cRef, D():ProveedorArticulo( nView ) )

            if nPreCom != 0
               ( dbfTmp )->nPreDiv  := nPreCom
            end if

            /*
            Descuento de promocional-------------------------------------------
            */

            nPreCom                 := nPromocionReferenciaProveedor( cCodPrv, ( dbfTmp )->cRef, D():ProveedorArticulo( nView ) )

            if nPreCom != 0
               ( dbfTmp )->nDtoPrm  := nPreCom
            end if

         end if

      end if

      ( dbfTmp )->( dbSkip() )

   end while

   ( dbfTmp )->( dbGoTo( nRecNum ) )

   oDlg:Enable()

RETURN nil

//----------------------------------------------------------------------------//

/*
Carga los datos del proveedor
*/

STATIC FUNCTION LoaPrv( aGet, aTmp, nMode, oSay, oTlfPrv )

   local lValid      := .f.
   local cNewCodCli  := aGet[ _CCODPRV ]:VarGet()
   local lChgCodCli  := ( Empty( cOldCodCli ) .or. cOldCodCli != cNewCodCli )

   if Empty( cNewCodCli )
      RETURN .t.
   elseif At( ".", cNewCodCli ) != 0
      cNewCodCli     := PntReplace( aGet[ _CCODPRV ], "0", RetNumCodPrvEmp() )
   else
      cNewCodCli     := Rjust( cNewCodCli, "0", RetNumCodPrvEmp() )
   end if

   if ( D():Proveedores( nView ) )->( dbSeek( cNewCodCli ) )

      if ( D():Proveedores( nView ) )->lBlqPrv
         msgStop( "Proveedor bloqueado, no se pueden realizar operaciones de compra" )
         RETURN .f.
      end if

      aGet[ _CCODPRV ]:cText( ( D():Proveedores( nView ) )->Cod )

      if Empty( aGet[ _CNOMPRV ]:varGet() ) .or. lChgCodCli
         aGet[ _CNOMPRV ]:cText( ( D():Proveedores( nView ) )->Titulo )
      end if

      if oTlfPrv != nil
         oTlfPrv:cText( ( D():Proveedores( nView ) )->Telefono )
      end if

      if Empty( aGet[ _CDIRPRV ]:varGet() ) .or. lChgCodCli
         aGet[ _CDIRPRV ]:cText( ( D():Proveedores( nView ) )->Domicilio )
      endif

      if Empty( aGet[ _CPOBPRV ]:varGet() ) .or. lChgCodCli
         aGet[ _CPOBPRV ]:cText( ( D():Proveedores( nView ) )->Poblacion )
      endif

      if Empty( aGet[ _CPROPRV ]:varGet() ) .or. lChgCodCli
         aGet[ _CPROPRV ]:cText( ( D():Proveedores( nView ) )->Provincia )
      endif

      if Empty( aGet[ _CPOSPRV ]:varGet() ) .or. lChgCodCli
         aGet[ _CPOSPRV ]:cText( ( D():Proveedores( nView ) )->CodPostal )
      endif

      if Empty( aGet[ _CDNIPRV ]:varGet() ) .or. lChgCodCli
         aGet[ _CDNIPRV ]:cText( ( D():Proveedores( nView ) )->Nif )
      endif

      /*
      Descuentos
      */

      if lChgCodCli
         aGet[ _CDTOESP ]:cText( ( D():Proveedores( nView ) )->cDtoEsp )
         aGet[ _NDTOESP ]:cText( ( D():Proveedores( nView ) )->nDtoEsp )
         aGet[ _CDPP    ]:cText( ( D():Proveedores( nView ) )->cDtoPp )
         aGet[ _NDPP    ]:cText( ( D():Proveedores( nView ) )->DtoPp )
      end if

      if Empty( aGet[ _CCODPGO ]:VarGet() )
         aGet[ _CCODPGO ]:cText( ( D():Proveedores( nView ) )->fPago )
         aGet[ _CCODPGO ]:lValid()
      end if

      if nMode == APPD_MODE

         aGet[ _NREGIVA ]:nOption( Max( ( D():Proveedores( nView ) )->nRegIva, 1 ) )
         aGet[ _NREGIVA ]:Refresh()

         if Empty( aTmp[ _CSERALB ] )

            if !Empty( ( D():Proveedores( nView ) )->Serie )
               aGet[ _CSERALB ]:cText( ( D():Proveedores( nView ) )->Serie )
            end if

         else

            if !Empty( ( D():Proveedores( nView ) )->Serie ) .and. aTmp[ _CSERALB ] != ( D():Proveedores( nView ) )->Serie .and. ApoloMsgNoYes( "La serie del proveedor seleccionado es distinta a la anterior.", "¿Desea cambiar la serie?" )
               aGet[ _CSERALB ]:cText( ( D():Proveedores( nView ) )->Serie )
            end if

         end if

      end if

      if lChgCodCli
         aTmp[ _LRECARGO ] := ( D():Proveedores( nView ) )->lReq
         aGet[ _LRECARGO ]:Refresh()
      end if

      if ( D():Proveedores( nView ) )->lMosCom .and. !Empty( ( D():Proveedores( nView ) )->mComent ) .and. lChgCodCli
         MsgStop( AllTrim( ( D():Proveedores( nView ) )->mComent ) )
      end if

      cOldCodCli  := ( D():Proveedores( nView ) )->Cod

      lValid      := .t.

   else

      msgStop( "Proveedor no encontrado" )

   end if

RETURN lValid

//----------------------------------------------------------------------------//

/*
Funcion Auxiliar para A¤adir lineas de detalle a un albaran
*/

STATIC FUNCTION AppendDetail( oBrwLin, bEdtDet, aTmp, cCodArt )

   WinAppRec( oBrwLin, bEdtDet, dbfTmp, aTmp, cCodArt )

RETURN ( RecalculaTotal( aTmp ) )

//--------------------------------------------------------------------------//

/*
Funcion Auxiliar para la Edici¢n de Lineas de Detalle en un albaran
*/

STATIC FUNCTION EditDetail( oBrwLin, bEdtDet, aTmp )

   WinEdtRec( oBrwLin, bEdtDet, dbfTmp, aTmp )

RETURN ( RecalculaTotal( aTmp ) )

//--------------------------------------------------------------------------//

/*
Funcion Auxiliar para la Visualizaci¢n de Lineas de Detalle en una Abono
*/

STATIC FUNCTION ZoomDetail( oBrwLin, bEdtDet, aTmp )

   WinZooRec( oBrwLin, bEdtDet, dbfTmp, aTmp )

RETURN NIL

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

RETURN ( .t. )

//--------------------------------------------------------------------------//
/*
Edita las lineas de Detalle
*/

STATIC FUNCTION EdtDet( aTmp, aGet, dbf, oBrw, aTmpAlb, cCodArtEnt, nMode )

	local oDlg
   local oFld
   local oBmp
   local oBtn
   local oGet1
   local oSayFam
   local cSayFam           := ""
   local oTotal
	local nTotal
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
   local oSayLote
   local cCodArt           := Padr( aTmp[ _CREF ], 200 )

	/*
	Modificamos los valores por defecto
	*/

   cTipoCtrCoste           := AllTrim( aTmp[ _CTIPCTR ] )

   do case
   case nMode == APPD_MODE

      aTmp[ _NUNICAJA ]    := 1
      aTmp[ __CALMORIGEN ] := aTmpAlb[ _CALMORIGEN ]
      aTmp[ _CALMLIN  ]    := aTmpAlb[ _CCODALM ]
      aTmp[ _CCODPED  ]    := aTmpAlb[ _CNUMPED ]
      aTmp[ _LCHGLIN  ]    := lActCos()
      aTmp[ _DFECCAD  ]    := ctod( "" )
      aTmp[ _DAPERTURA]    := ctod( "" )
      aTmp[ _DCIERRE  ]    := ctod( "" )
      aTmp[ _NNUMLIN  ]    := nLastNum( dbfTmp )
      aTmp[ _NPOSPRINT  ]  := nLastNum( dbfTmp, "nPosPrint" )

      if !Empty( cCodArtEnt )
         cCodArt           := cCodArtEnt
      end if

      cTipoCtrCoste        := "Centro de coste"

      oLinDetCamposExtra:setTemporalAppend()

   case nMode == EDIT_MODE

      if !Empty( aTmp[ _CREF ] )
         ( D():Articulos( nView ) )->( dbSeek( Alltrim( aTmp[ _CREF ] ) ) )
      end if

   end case

   cOldCodArt              := aTmp[ _CREF    ]
   cOldPrpArt              := aTmp[ _CCODPR1 ] + aTmp[ _CCODPR2 ] + aTmp[ _CVALPR1 ] + aTmp[ _CVALPR2 ]
   cOldUndMed              := aTmp[ _CUNIDAD ]

   cBeneficioSobre[ 1 ]    := aBeneficioSobre[ Max( aTmp[ _NBNFSBR1 ], 1 ) ]
   cBeneficioSobre[ 2 ]    := aBeneficioSobre[ Max( aTmp[ _NBNFSBR2 ], 1 ) ]
   cBeneficioSobre[ 3 ]    := aBeneficioSobre[ Max( aTmp[ _NBNFSBR3 ], 1 ) ]
   cBeneficioSobre[ 4 ]    := aBeneficioSobre[ Max( aTmp[ _NBNFSBR4 ], 1 ) ]
   cBeneficioSobre[ 5 ]    := aBeneficioSobre[ Max( aTmp[ _NBNFSBR5 ], 1 ) ]
   cBeneficioSobre[ 6 ]    := aBeneficioSobre[ Max( aTmp[ _NBNFSBR6 ], 1 ) ]

   DEFINE DIALOG oDlg RESOURCE "LAlbPrv" TITLE LblTitle( nMode ) + "líneas a albaranes de proveedores"

      REDEFINE FOLDER oFld ;
         ID       400 ;
         OF       oDlg ;
         PROMPT   "&General",;
                  "&Precios",;
                  "&Observaciones",;
                  "&Centro coste" ;
         DIALOGS  "LALBPRV_1",;
                  "LALBPRV_2",;
                  "LALBPRV_4",;
                  "LCTRCOSTE"  

      oFld:aEnable         := { .t., !Empty( aTmp[ _CREF ] ), .t., .t. }

      REDEFINE GET aGet[ _CREF ] VAR cCodArt ;
			ID 		110 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( loaArt( cCodArt, aGet, aTmp, aTmpAlb, oFld, oSayPr1, oSayPr2, oSayVp1, oSayVp2, oBmp, oBrwPrp, oDlg, oSayLote, oBeneficioSobre, oTotal, nMode ) );
         BITMAP   "LUPA" ;
         ON HELP  ( BrwArticulo( aGet[ _CREF ], aGet[ _CDETALLE ], .f., .t., oBtn, aGet[ _CLOTE ], , , , , aGet[ _DFECCAD ], if( uFieldEmpresa( "lStockAlm" ), aTmp[ _CALMLIN ], nil ) ) ) ;
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
         VALID    ( if( lTiva( D():TiposIva( nView ), aTmp[ _NIVA ], @aTmp[ _NREQ ] ), ( aGet[ _NIVALIN ]:cText( aTmp[ _NIVA ] ), .t. ), .f. ) );
         BITMAP   "LUPA" ;
         ON HELP  ( BrwIva( Self, D():TiposIva( nView ), , .t. ) ) ;
			OF 		oFld:aDialogs[1]

      // IVMH------------------------------------------------------------------

      REDEFINE GET aGet[ _NVALIMP ] VAR aTmp[ _NVALIMP ] ;
         ID       125 ;
         IDSAY    126 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  cPinDiv ;
         ON CHANGE( lCalcDeta( aTmp, aTmpAlb, aGet, oTotal ) );
         OF       oFld:aDialogs[1]

      /*
      Propiedades
      -------------------------------------------------------------------------
      */

      REDEFINE GET aGet[ _CVALPR1 ] VAR aTmp[ _CVALPR1 ];
         ID       220 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         BITMAP   "LUPA" ;
         VALID    ( if( lPrpAct( aGet[ _CVALPR1 ], oSayVp1, aTmp[ _CCODPR1 ], D():PropiedadesLineas( nView ) ),;
                        loaArt( cCodArt, aGet, aTmp, aTmpAlb, oFld, oSayPr1, oSayPr2, oSayVp1, oSayVp2, oBmp, oBrwPrp, oDlg, oSayLote, oBeneficioSobre, oTotal, nMode ),;
                        .f. ) ) ;
         ON HELP  ( brwPropiedadActual( aGet[ _CVALPR1 ], oSayVp1, aTmp[ _CCODPR1 ] ) ) ;
			OF 		oFld:aDialogs[1]

         aGet[ _CVALPR1 ]:bChange   := {|| aGet[ _CVALPR1 ]:Assign() }

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
         VALID    ( if( lPrpAct( aGet[ _CVALPR2 ], oSayVp2, aTmp[ _CCODPR2 ], D():PropiedadesLineas( nView ) ),;
                        loaArt( cCodArt, aGet, aTmp, aTmpAlb, oFld, oSayPr1, oSayPr2, oSayVp1, oSayVp2, oBmp, oBrwPrp, oDlg, oSayLote, oBeneficioSobre, oTotal, nMode ),;
                        .f. ) ) ;
         ON HELP  ( brwPropiedadActual( aGet[ _CVALPR2 ], oSayVp2, aTmp[ _CCODPR2 ] ) ) ;
			OF 		oFld:aDialogs[1]

         aGet[ _CVALPR2 ]:bChange   := {|| aGet[ _CVALPR2 ]:Assign() }

      REDEFINE SAY oSayPr2 VAR cSayPr2;
         ID       231 ;
			OF 		oFld:aDialogs[1]

      REDEFINE GET oSayVp2 VAR cSayVp2;
         ID       232 ;
         WHEN     .f. ;
         OF       oFld:aDialogs[1]

      // Familia del articulo--------------------------------------------------

      REDEFINE GET   aGet[ _CCODFAM ] ;
         VAR         aTmp[ _CCODFAM ] ;
         ID          270 ;
         WHEN        ( nMode != ZOOM_MODE ) ;
         BITMAP      "LUPA" ;
         VALID       ( oSayFam:cText( RetFld( aTmp[ _CCODFAM  ], D():Familias( nView ) ) ), .t. );
         ON HELP     ( brwFamilia( aGet[ _CCODFAM ], oSayFam ) );
         OF          oFld:aDialogs[ 1 ]

      REDEFINE GET   oSayFam ;
         VAR         cSayFam ;
         WHEN        ( .f. ) ;
         ID          271 ;
         OF          oFld:aDialogs[ 1 ]

      // Browse de propiedades-------------------------------------------------

      oBrwPrp                       := IXBrowse():New( oFld:aDialogs[1] )

      oBrwPrp:nDataType             := DATATYPE_ARRAY

      oBrwPrp:bClrSel               := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwPrp:bClrSelFocus          := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrwPrp:lHScroll              := .t.
      oBrwPrp:lVScroll              := .t.

      oBrwPrp:nMarqueeStyle         := 3
      oBrwPrp:lRecordSelector       := .f.
      oBrwPrp:lFastEdit             := .t.
      oBrwPrp:nFreeze               := 1
      oBrwPrp:lFooter               := .t.

      oBrwPrp:SetArray( {}, .f., 0, .f. )

      oBrwPrp:MakeTotals()

      oBrwPrp:CreateFromResource( 100 )

      /*
      fin de propiedades
      -------------------------------------------------------------------------
      */

      REDEFINE GET aGet[ __NBULTOS ] ;
         VAR      aTmp[ __NBULTOS ] ;
         ID       450 ;
         IDSAY    451 ;
         SPINNER ;
         WHEN     ( uFieldEmpresa( "lUseBultos" ) .AND. nMode != ZOOM_MODE ) ;
         PICTURE  cPicUnd ;
         OF       oFld:aDialogs[1]

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
         VALID    ( D():GetObject( "UnidadMedicion", nView ):Existe( aGet[ _CUNIDAD ], aGet[ _CUNIDAD ]:oHelpText, "cNombre" ), ValidaMedicion( aTmp, aGet) );
         ON HELP  ( D():GetObject( "UnidadMedicion", nView ):Buscar( aGet[ _CUNIDAD ] ), ValidaMedicion( aTmp, aGet ) ) ;
         OF       oFld:aDialogs[1]

      // Campos de las descripciones de la unidad de medición

      REDEFINE GET aGet[ ( D():AlbaranesProveedoresLineas( nView ) )->( fieldpos( "nMedUno" ) ) ] ;
         VAR      aTmp[ ( D():AlbaranesProveedoresLineas( nView ) )->( fieldpos( "nMedUno" ) ) ] ;
         ID       420 ;
         IDSAY    421 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ON CHANGE( lCalcDeta( aTmp, aTmpAlb, aGet, oTotal ) );
         PICTURE  MasUnd() ;
         OF       oFld:aDialogs[1]

      aGet[ ( D():AlbaranesProveedoresLineas( nView ) )->( fieldpos( "nMedUno" ) ) ]:oSay:SetColor( CLR_BLUE )

      REDEFINE GET aGet[ ( D():AlbaranesProveedoresLineas( nView ) )->( fieldpos( "nMedDos" ) ) ] ;
         VAR      aTmp[ ( D():AlbaranesProveedoresLineas( nView ) )->( fieldpos( "nMedDos" ) ) ] ;
         ID       430 ;
         IDSAY    431 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ON CHANGE( lCalcDeta( aTmp, aTmpAlb, aGet, oTotal ) );
         PICTURE  MasUnd() ;
         OF       oFld:aDialogs[1]

      aGet[ ( D():AlbaranesProveedoresLineas( nView ) )->( fieldpos( "nMedDos" ) ) ]:oSay:SetColor( CLR_BLUE )

      REDEFINE GET aGet[ ( D():AlbaranesProveedoresLineas( nView ) )->( fieldpos( "nMedTre" ) ) ] ;
         VAR      aTmp[ ( D():AlbaranesProveedoresLineas( nView ) )->( fieldpos( "nMedTre" ) ) ] ;
         ID       440 ;
         IDSAY    441 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ON CHANGE( lCalcDeta( aTmp, aTmpAlb, aGet, oTotal ) );
         PICTURE  MasUnd() ;
         OF       oFld:aDialogs[1]

      aGet[ ( D():AlbaranesProveedoresLineas( nView ) )->( fieldpos( "nMedTre" ) ) ]:oSay:SetColor( CLR_BLUE )

      REDEFINE GET aGet[ _NPNTVER ] VAR aTmp[ _NPNTVER ] ;
         ID       171 ;
         IDSAY    172 ;
         SPINNER ;
         PICTURE  cPirDiv ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( lCalcDeta( aTmp, aTmpAlb, aGet, oTotal  ) );
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _NPREDIV ] VAR aTmp[ _NPREDIV ] ;
			ID 		160 ;
			SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( lCalcDeta( aTmp, aTmpAlb, aGet, oTotal ) );
         ON CHANGE( lCalcDeta( aTmp, aTmpAlb, aGet, oTotal ) );
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

      REDEFINE GET aGet[ _CFORMATO ] VAR aTmp[ _CFORMATO ];
         ID       460;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ __CALMORIGEN ] VAR aTmp[ __CALMORIGEN ]  ;
         ID       330 ;
         IDTEXT   331 ;
         IDSAY    332 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    (  cAlmacen( aGet[ __CALMORIGEN ], , aGet[ __CALMORIGEN ]:oHelpText ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwAlmacen( aGet[ __CALMORIGEN ], aGet[ __CALMORIGEN ]:oHelpText ) ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CALMLIN ] VAR aTmp[ _CALMLIN ]  ;
         ID       240 ;
         IDTEXT   241 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         VALID    (  cAlmacen( aGet[ _CALMLIN ], , aGet[ _CALMLIN ]:oHelpText ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwAlmacen( Self, aGet[ _CALMLIN ]:oHelpText ) ) ;
			OF 		oFld:aDialogs[1]

      REDEFINE GET oTotal VAR nTotal ;
			ID 		210 ;
			WHEN 		.F. ;
         PICTURE  cPirDiv ;
			OF 		oFld:aDialogs[1]

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

      REDEFINE GET aGet[ _NBNFLIN1 ] ;
         VAR      aTmp[ _NBNFLIN1 ] ;
         ID       510 ;
         SPINNER ;
         WHEN     ( aTmp[ _LBNFLIN1 ] .and. nMode != ZOOM_MODE ) ;
         PICTURE  "@E 999.99" ;
         OF       oFld:aDialogs[ 2 ]

      aGet[ _NBNFLIN1 ]:bChange     := {|| aGet[ _NBNFLIN1 ]:lValid() }
      aGet[ _NBNFLIN1 ]:bValid      := {|| lCalPre( oBeneficioSobre[ 1 ]:nAt <= 1, aTmp[ _NPRECOM ], aTmp[ _LBNFLIN1 ], aTmp[ _NBNFLIN1 ], aTmp[ _NIVA ], aGet[ _NPVPLIN1 ], aGet[ _NIVALIN1 ], nDinDiv ) }

      REDEFINE COMBOBOX oBeneficioSobre[ 1 ] ;
         VAR      cBeneficioSobre[ 1 ] ;
         ITEMS    aBeneficioSobre ;
         ID       520 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[ 2 ]

      oBeneficioSobre[ 1 ]:bChange  := {|| if( aTmp[ _LBNFLIN1 ], aGet[ _NBNFLIN1 ]:lValid(), aGet[ _NPVPLIN1 ]:lValid() ) }

      REDEFINE GET   aGet[ _NPVPLIN1 ] ;
         VAR         aTmp[ _NPVPLIN1 ] ;
         ID          530 ;
         WHEN        ( !aTmp[ _LIVALIN ] .and. nMode != ZOOM_MODE ) ;
         PICTURE     cPinDiv ;
         OF          oFld:aDialogs[ 2 ]

      aGet[ _NPVPLIN1 ]:bChange  := {|| aGet[ _NPVPLIN1 ]:lValid() }
      aGet[ _NPVPLIN1 ]:bValid   := {|| CalBnfPts( oBeneficioSobre[ 1 ]:nAt <= 1, aTmp[ _LIVALIN ], aTmp[ _NPRECOM ], aTmp[ _NPVPLIN1 ], aGet[ _NBNFLIN1 ], aTmp[ _NIVA ], aGet[ _NIVALIN1 ], nDinDiv ) }

      REDEFINE GET   aGet[ _NIVALIN1 ] ;
         VAR         aTmp[ _NIVALIN1 ] ;
         ID          540 ;
         WHEN        ( aTmp[ _LIVALIN ] .and. nMode != ZOOM_MODE ) ;
         PICTURE     cPinDiv ;
         OF          oFld:aDialogs[ 2 ]

      aGet[ _NIVALIN1 ]:bChange  := {|| aGet[ _NIVALIN1 ]:lValid() }
      aGet[ _NIVALIN1 ]:bValid   := {|| CalBnfIva( oBeneficioSobre[ 1 ]:nAt <= 1, aTmp[ _LIVALIN ], aTmp[ _NPRECOM ], aTmp[ _NIVALIN1 ], aGet[ _NBNFLIN1 ], aTmp[ _NIVA ], aGet[ _NPVPLIN1 ], nDinDiv ) }

      REDEFINE CHECKBOX aGet[ _LBNFLIN2 ] ;
            VAR      aTmp[ _LBNFLIN2 ] ;
            ID       550 ;
            WHEN     ( nMode != ZOOM_MODE ) ;
            OF       oFld:aDialogs[ 2 ]

      REDEFINE GET   aGet[ _NBNFLIN2 ] ;
            VAR      aTmp[ _NBNFLIN2 ] ;
            ID       560 ;
            SPINNER ;
            WHEN     ( aTmp[ _LBNFLIN2 ] .and. nMode != ZOOM_MODE ) ;
            PICTURE  "@E 999.99" ;
            OF       oFld:aDialogs[ 2 ]
            
      aGet[ _NBNFLIN2 ]:bChange  := {|| aGet[ _NBNFLIN2 ]:lValid() }
      aGet[ _NBNFLIN2 ]:bValid   := {|| lCalPre( oBeneficioSobre[ 2 ]:nAt <= 1, aTmp[ _NPRECOM ], aTmp[ _LBNFLIN2 ], aTmp[ _NBNFLIN2 ], aTmp[ _NIVA ], aGet[ _NPVPLIN2 ], aGet[ _NIVALIN2 ], nDinDiv ) }

      REDEFINE COMBOBOX oBeneficioSobre[ 2 ] ;
            VAR      cBeneficioSobre[ 2 ] ;
            ITEMS    aBeneficioSobre ;
            ID       570 ;
            WHEN     ( nMode != ZOOM_MODE ) ;
            OF       oFld:aDialogs[ 2 ]

      oBeneficioSobre[ 2 ]:bChange  := {|| if( aTmp[ _LBNFLIN2 ], aGet[ _NBNFLIN2 ]:lValid(), aGet[ _NPVPLIN2 ]:lValid() ) }

      REDEFINE GET   aGet[ _NPVPLIN2 ] ;
            VAR      aTmp[ _NPVPLIN2 ] ;
            ID       580 ;
            WHEN     ( !aTmp[ _LIVALIN ] .and. nMode != ZOOM_MODE ) ;
            PICTURE  cPinDiv ;
            OF       oFld:aDialogs[ 2 ]

      aGet[ _NPVPLIN2 ]:bChange  := {|| aGet[ _NPVPLIN2 ]:lValid() }
      aGet[ _NPVPLIN2 ]:bValid   := {|| CalBnfPts( oBeneficioSobre[ 2 ]:nAt <= 1, aTmp[ _LIVALIN ], aTmp[ _NPRECOM ], aTmp[ _NPVPLIN2 ], aGet[ _NBNFLIN2 ], aTmp[ _NIVA ], aGet[ _NIVALIN2 ], nDinDiv ) }

      REDEFINE GET   aGet[ _NIVALIN2 ] ;
            VAR      aTmp[ _NIVALIN2 ] ;
            ID       590 ;
            ON CHANGE( ::lValid() ) ;
            WHEN     ( aTmp[ _LIVALIN ] .and. nMode != ZOOM_MODE ) ;
            PICTURE  cPinDiv ;
            OF       oFld:aDialogs[ 2 ]

      aGet[ _NIVALIN2 ]:bChange     := {|| aGet[ _NIVALIN2 ]:lValid() }
      aGet[ _NIVALIN2 ]:bValid      := {|| CalBnfIva( oBeneficioSobre[ 2 ]:nAt <= 1, aTmp[ _LIVALIN ], aTmp[ _NPRECOM ], aTmp[ _NIVALIN2 ], aGet[ _NBNFLIN2 ], aTmp[ _NIVA ], aGet[ _NPVPLIN2 ], nDinDiv ) }

      REDEFINE CHECKBOX aGet[ _LBNFLIN3 ] ;
            VAR      aTmp[ _LBNFLIN3 ] ;
            ID       600 ;
            WHEN     ( nMode != ZOOM_MODE ) ;
            OF       oFld:aDialogs[ 2 ]

      REDEFINE GET   aGet[ _NBNFLIN3 ] ;
            VAR      aTmp[ _NBNFLIN3 ] ;
            ID       610 ;
            SPINNER ;
            WHEN     ( aTmp[ _LBNFLIN3 ] .AND. nMode != ZOOM_MODE ) ;
            PICTURE  "@E 999.99" ;
            OF       oFld:aDialogs[ 2 ]

      aGet[ _NBNFLIN3 ]:bChange  := {|| aGet[ _NBNFLIN3 ]:lValid() }
      aGet[ _NBNFLIN3 ]:bValid   := {|| lCalPre( oBeneficioSobre[ 3 ]:nAt <= 1, aTmp[ _NPRECOM ], aTmp[ _LBNFLIN3 ], aTmp[ _NBNFLIN3 ], aTmp[ _NIVA ], aGet[ _NPVPLIN3 ], aGet[ _NIVALIN3 ], nDinDiv ) }

      REDEFINE COMBOBOX oBeneficioSobre[ 3 ] VAR cBeneficioSobre[ 3 ] ;
            ITEMS    aBeneficioSobre ;
            ID       620 ;
            WHEN     ( nMode != ZOOM_MODE ) ;
            ON CHANGE( if( aTmp[ _LBNFLIN3 ], aGet[ _NBNFLIN3 ]:lValid(), aGet[ _NPVPLIN3 ]:lValid() ) );
            OF       oFld:aDialogs[ 2 ]

      REDEFINE GET   aGet[ _NPVPLIN3 ] ;
            VAR      aTmp[ _NPVPLIN3 ] ;
            ID       630 ;
            WHEN     ( !aTmp[ _LIVALIN ] .and. nMode != ZOOM_MODE ) ;
            PICTURE  cPinDiv ;
            OF       oFld:aDialogs[ 2 ]

      aGet[ _NPVPLIN3 ]:bChange  := {|| aGet[ _NPVPLIN3 ]:lValid() }
      aGet[ _NPVPLIN3 ]:bValid   := {|| CalBnfPts( oBeneficioSobre[ 3 ]:nAt <= 1, aTmp[ _LIVALIN ], aTmp[ _NPRECOM ], aTmp[ _NPVPLIN3 ], aGet[ _NBNFLIN3 ], aTmp[ _NIVA ], aGet[ _NIVALIN3 ], nDinDiv ) }

      REDEFINE GET   aGet[ _NIVALIN3 ] ;
            VAR      aTmp[ _NIVALIN3 ] ;
            ID       640 ;
            WHEN     ( aTmp[ _LIVALIN ] .and. nMode != ZOOM_MODE ) ;
            PICTURE  cPinDiv ;
            OF       oFld:aDialogs[ 2 ]

      aGet[ _NIVALIN3 ]:bChange  := {|| aGet[ _NIVALIN3 ]:lValid()  }
      aGet[ _NIVALIN3 ]:bValid   := {|| CalBnfIva( oBeneficioSobre[ 3 ]:nAt <= 1, aTmp[ _LIVALIN ], aTmp[ _NPRECOM ], aTmp[ _NIVALIN3 ], aGet[ _NBNFLIN3 ], aTmp[ _NIVA ], aGet[ _NPVPLIN3 ], nDinDiv ) }

      REDEFINE CHECKBOX aGet[ _LBNFLIN4 ] ;
            VAR      aTmp[ _LBNFLIN4 ] ;
            ID       650 ;
            WHEN     ( nMode != ZOOM_MODE ) ;
            OF       oFld:aDialogs[ 2 ]

      REDEFINE GET   aGet[ _NBNFLIN4 ] ;
            VAR      aTmp[ _NBNFLIN4 ] ;
            ID       660 ;
            SPINNER ;
            WHEN     ( aTmp[ _LBNFLIN4 ] .AND. nMode != ZOOM_MODE ) ;
            PICTURE  "@E 999.99" ;
            OF       oFld:aDialogs[ 2 ]

      aGet[ _NBNFLIN4 ]:bChange  := {|| aGet[ _NBNFLIN4 ]:lValid() }
      aGet[ _NBNFLIN4 ]:bValid   := {|| lCalPre( oBeneficioSobre[ 4 ]:nAt <= 1, aTmp[ _NPRECOM ], aTmp[ _LBNFLIN4 ], aTmp[ _NBNFLIN4 ], aTmp[ _NIVA ], aGet[ _NPVPLIN4 ], aGet[ _NIVALIN4 ], nDinDiv ) }

      REDEFINE COMBOBOX oBeneficioSobre[ 4 ] ;
            VAR      cBeneficioSobre[ 4 ] ;
            ITEMS    aBeneficioSobre ;
            ID       670 ;
            WHEN     ( nMode != ZOOM_MODE ) ;
            OF       oFld:aDialogs[ 2 ]

      oBeneficioSobre[ 4 ]:bChange  := {|| if( aTmp[ _LBNFLIN4 ], aGet[ _NBNFLIN4 ]:lValid(), aGet[ _NPVPLIN4 ]:lValid() ) }

      REDEFINE GET   aGet[ _NPVPLIN4 ] ;
            VAR      aTmp[ _NPVPLIN4 ] ;
            ID       680 ;
            WHEN     ( !aTmp[ _LIVALIN ] .and. nMode != ZOOM_MODE ) ;
            PICTURE  cPinDiv ;
            OF       oFld:aDialogs[ 2 ]

      aGet[ _NPVPLIN4 ]:bChange  := {|| aGet[ _NPVPLIN4 ]:lValid()  }
      aGet[ _NPVPLIN4 ]:bValid   := {|| CalBnfPts( oBeneficioSobre[ 4 ]:nAt <= 1, aTmp[ _LIVALIN ], aTmp[ _NPRECOM ], aTmp[ _NPVPLIN4 ], aGet[ _NBNFLIN4 ], aTmp[ _NIVA ], aGet[ _NIVALIN4 ], nDinDiv ) }

      REDEFINE GET   aGet[ _NIVALIN4 ] ;
            VAR      aTmp[ _NIVALIN4 ] ;
            ID       690 ;
            WHEN     ( aTmp[ _LIVALIN ] .and. nMode != ZOOM_MODE ) ;
            PICTURE  cPinDiv ;
            OF       oFld:aDialogs[ 2 ]

      aGet[ _NIVALIN4 ]:bChange  := {|| aGet[ _NIVALIN4 ]:lValid() }
      aGet[ _NIVALIN4 ]:bValid   := {|| CalBnfIva( oBeneficioSobre[ 4 ]:nAt <= 1, aTmp[ _LIVALIN ], aTmp[ _NPRECOM ], aTmp[ _NIVALIN4 ], aGet[ _NBNFLIN4 ], aTmp[ _NIVA ], aGet[ _NPVPLIN4 ], nDinDiv ) }

      REDEFINE CHECKBOX aGet[ _LBNFLIN5 ] ;
            VAR      aTmp[ _LBNFLIN5 ] ;
            ID       700 ;
            WHEN     ( nMode != ZOOM_MODE ) ;
            OF       oFld:aDialogs[ 2 ]

      REDEFINE GET   aGet[ _NBNFLIN5 ] ;
            VAR      aTmp[ _NBNFLIN5 ] ;
            ID       710 ;
            SPINNER ;
            WHEN     ( aTmp[ _LBNFLIN5 ] .AND. nMode != ZOOM_MODE ) ;
            PICTURE  "@E 999.99" ;
            OF       oFld:aDialogs[ 2 ]

      aGet[ _NBNFLIN5 ]:bChange  := {|| aGet[ _NBNFLIN5 ]:lValid() }
      aGet[ _NBNFLIN5 ]:bValid   := {|| lCalPre( oBeneficioSobre[ 5 ]:nAt <= 1, aTmp[ _NPRECOM ], aTmp[ _LBNFLIN5 ], aTmp[ _NBNFLIN5 ], aTmp[ _NIVA ], aGet[ _NPVPLIN5 ], aGet[ _NIVALIN5 ], nDinDiv ) }

      REDEFINE COMBOBOX oBeneficioSobre[ 5 ] ;
            VAR      cBeneficioSobre[ 5 ] ;
            ITEMS    aBeneficioSobre ;
            ID       720 ;
            WHEN     ( nMode != ZOOM_MODE ) ;
            OF       oFld:aDialogs[ 2 ]

      oBeneficioSobre[ 5 ]:bChange  := {|| if( aTmp[ _LBNFLIN5 ], aGet[ _NBNFLIN5 ]:lValid(), aGet[ _NPVPLIN5 ]:lValid() ) }

      REDEFINE GET   aGet[ _NPVPLIN5 ] ;
            VAR      aTmp[ _NPVPLIN5 ] ;
            ID       730 ;
            WHEN     ( !aTmp[ _LIVALIN ] .and. nMode != ZOOM_MODE ) ;
            PICTURE  cPinDiv ;
            OF       oFld:aDialogs[ 2 ]

      aGet[ _NPVPLIN5 ]:bChange  := {|| aGet[ _NPVPLIN5 ]:lValid() }
      aGet[ _NPVPLIN5 ]:bValid   := {|| CalBnfPts( oBeneficioSobre[ 5 ]:nAt <= 1, aTmp[ _LIVALIN ], aTmp[ _NPRECOM ], aTmp[ _NPVPLIN5 ], aGet[ _NBNFLIN5 ], aTmp[ _NIVA ], aGet[ _NIVALIN5 ], nDinDiv ) }

      REDEFINE GET   aGet[ _NIVALIN5 ] ;
            VAR      aTmp[ _NIVALIN5 ] ;
            ID       740 ;
            WHEN     ( aTmp[ _LIVALIN ] .and. nMode != ZOOM_MODE ) ;
            PICTURE  cPinDiv ;
            OF       oFld:aDialogs[ 2 ]

      aGet[ _NIVALIN5 ]:bChange  := {|| aGet[ _NIVALIN5 ]:lValid() }
      aGet[ _NIVALIN5 ]:bValid   := {|| CalBnfIva( oBeneficioSobre[ 5 ]:nAt <= 1, aTmp[ _LIVALIN ], aTmp[ _NPRECOM ], aTmp[ _NIVALIN5 ], aGet[ _NBNFLIN5 ], aTmp[ _NIVA ], aGet[ _NPVPLIN5 ], nDinDiv ) }

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
            PICTURE  "@E 999.99" ;
            OF       oFld:aDialogs[ 2 ]

      aGet[ _NBNFLIN6 ]:bChange  := {|| aGet[ _NBNFLIN6 ]:lValid() }
      aGet[ _NBNFLIN6 ]:bValid   := {|| lCalPre( oBeneficioSobre[ 6 ]:nAt <= 1, aTmp[ _NPRECOM ], aTmp[ _LBNFLIN6 ], aTmp[ _NBNFLIN6 ], aTmp[ _NIVA ], aGet[ _NPVPLIN6 ], aGet[ _NIVALIN6 ], nDinDiv ) }

      REDEFINE COMBOBOX oBeneficioSobre[ 6 ] ;
            VAR      cBeneficioSobre[ 6 ] ;
            ITEMS    aBeneficioSobre ;
            ID       770 ;
            WHEN     ( nMode != ZOOM_MODE ) ;
            OF       oFld:aDialogs[ 2 ]

      oBeneficioSobre[ 6 ]:bChange  := {|| if( aTmp[ _LBNFLIN6 ], aGet[ _NBNFLIN6 ]:lValid(), aGet[ _NPVPLIN6 ]:lValid() ) }

      REDEFINE GET   aGet[ _NPVPLIN6 ] ;
            VAR      aTmp[ _NPVPLIN6 ] ;
            ID       780 ;
            WHEN     ( !aTmp[ _LIVALIN ] .and. nMode != ZOOM_MODE ) ;
            PICTURE  cPinDiv ;
            OF       oFld:aDialogs[ 2 ]

      aGet[ _NPVPLIN6 ]:bChange  := {|| aGet[ _NPVPLIN6 ]:lValid() }
      aGet[ _NPVPLIN6 ]:bValid   := {|| CalBnfPts( oBeneficioSobre[ 6 ]:nAt <= 1, aTmp[ _LIVALIN ], aTmp[ _NPRECOM ], aTmp[ _NPVPLIN6 ], aGet[ _NBNFLIN6 ], aTmp[ _NIVA ], aGet[ _NIVALIN6 ], nDinDiv ) }

      REDEFINE GET   aGet[ _NIVALIN6 ] ;
            VAR      aTmp[ _NIVALIN6 ] ;
            ID       790 ;
            WHEN     ( aTmp[ _LIVALIN ] .and. nMode != ZOOM_MODE ) ;
            PICTURE  cPinDiv ;
            OF       oFld:aDialogs[ 2 ]

      aGet[ _NIVALIN6 ]:bChange  := {|| aGet[ _NIVALIN6 ]:lValid() }
      aGet[ _NIVALIN6 ]:bValid   := {|| CalBnfIva( oBeneficioSobre[ 6 ]:nAt <= 1, aTmp[ _LIVALIN ], aTmp[ _NPRECOM ], aTmp[ _NIVALIN6 ], aGet[ _NBNFLIN6 ], aTmp[ _NIVA ], aGet[ _NPVPLIN6 ], nDinDiv ) }

      /*
      Control de stock
      -------------------------------------------------------------------------
      */

      REDEFINE RADIO aGet[ _NCTLSTK ] ;
            VAR      aTmp[ _NCTLSTK ] ;
            ID       350, 351, 352 ;
            WHEN     ( nMode != ZOOM_MODE ) ;
            OF       oFld:aDialogs[ 2 ]

      REDEFINE CHECKBOX aGet[ _LCHGLIN ] ;
            VAR      aTmp[ _LCHGLIN ];
            ID       420 ;
            WHEN     ( nMode != ZOOM_MODE .and. lActCos() );
            OF       oFld:aDialogs[2]

      REDEFINE CHECKBOX aGet[ __LFACTURADO ] ;
            VAR         aTmp[ __LFACTURADO ] ;
            WHEN        ( nMode != ZOOM_MODE ) ;
            ID          360 ;
            OF          oFld:aDialogs[2]

      REDEFINE GET   aGet[ __CNUMFAC ] ;
         VAR         aTmp[ __CNUMFAC ] ;
         ID          361 ;
         PICTURE     "@R #/#########/##" ;
         WHEN        ( .f. ) ;
         OF          oFld:aDialogs[2]

      REDEFINE GET aTmp[ __DFECALB ];
         ID       370 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ __TFECALB ] VAR aTmp[ __TFECALB ] ;
         ID       371 ;
         PICTURE  "@R 99:99:99" ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( if( !validTime( aTmp[ __TFECALB ] ), ( msgStop( "El formato de la hora no es correcto" ), .f. ), .t. ) );
         OF       oFld:aDialogs[2]

      // Terced dialogo--------------------------------------------------------

      REDEFINE GET aGet[ _DAPERTURA ] ;
         VAR      aTmp[ _DAPERTURA ];
         ID       370 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[3]

      REDEFINE GET aGet[ _TAPERTURA ] ;
         VAR      aTmp[ _TAPERTURA ];
         ID       371 ;
         PICTURE  "@R 99:99:99" ;
         VALID    ( validTime( aTmp[ _TAPERTURA ] ) ) ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[3]

      REDEFINE GET aGet[ _DCIERRE ] ;
         VAR      aTmp[ _DCIERRE ];
         ID       380 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[3]

      REDEFINE GET aGet[ _TCIERRE ] ;
         VAR      aTmp[ _TCIERRE ];
         ID       381 ;
         PICTURE  "@R 99:99:99" ;
         VALID    ( validTime( aTmp[ _TCIERRE ] ) ) ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[3]

      REDEFINE GET aGet[ _MOBSLIN ] ;
         VAR      aTmp[ _MOBSLIN ] ;
         MEMO ;
         ID       100 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[3]

      /*
      Cuarta caja de diálogo---------------------------------------------------
      */

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

      REDEFINE BUTTON oBtn ;
         ID       IDOK ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( SaveDeta( aTmp, aGet, oDlg, oFld, oBrw, nMode, oTotal, oGet1, aTmpAlb, oSayPr1, oSayPr2, oSayVp1, oSayVp2, oBrwPrp, oBmp, oSayLote, oBtn ) )

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
         oDlg:AddFastKey( VK_F9, {|| oLinDetCamposExtra:Play( if( nMode == APPD_MODE, "", Str( ( dbfTmp )->( OrdKeyNo() ) ) ) ) } )
      end if

      oDlg:AddFastKey ( VK_F1, {|| GoHelp() } )

      oDlg:bStart := {|| SetDlgMode( aGet, aTmp, aTmpAlb, nMode, oSayPr1, oSayPr2, oSayVp1, oSayVp2, oBrwPrp, oBmp, oDlg, oSayLote, oTotal ),;
                         loadGet( aGet[ _CTERCTR ], cTipoCtrCoste ), aGet[ _CTERCTR ]:lValid(),;
                         if( !Empty( cCodArtEnt ), aGet[ _CREF ]:lValid(), ) }

   ACTIVATE DIALOG oDlg ;
      ON INIT     ( menuEdtDet( aGet[ _CREF ], oDlg, if( nMode == APPD_MODE, "", Str( ( dbfTmp )->( OrdKeyNo() ) ) ) ) );
      CENTER

   if !Empty( oDetMenu )
      oDetMenu:End()
   end if

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

Static FUNCTION SetDlgMode( aGet, aTmp, aTmpAlb, nMode, oSayPr1, oSayPr2, oSayVp1, oSayVp2, oBrwPrp, oBmp, oDlg, oSayLote, oTotal )

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
      aGet[ _NCANENT ]:SetText( cNombreCajas() )
   end if

   aGet[ _NUNICAJA ]:SetText( cNombreUnidades() )

   if Empty( aTmp[_CALMLIN ] )
      aTmp[ _CALMLIN ]  := aTmpAlb[ _CCODALM ]
   end if

   if Empty( aTmp[ __CALMORIGEN ] )
      aTmp[ __CALMORIGEN ]  := aTmpAlb[ _CALMORIGEN ]
   end if
  
   if uFieldEmpresa( "lShowOrg" )
      aGet[ __CALMORIGEN ]:Show()
   else
      aGet[ __CALMORIGEN ]:Hide()
   end if

   if aGet[ _NPNTVER ] != nil
      if !uFieldEmpresa( "lUsePnt", .f. ) 
         aGet[ _NPNTVER ]:Hide()
      end if
   end if

   aGet[ __LFACTURADO ]:Show()
   aGet[ __CNUMFAC    ]:Show()

   oBrwPrp:Hide()

   oSayPr1:SetText( "" )
   oSayVp1:SetText( "" )

   oSayPr2:SetText( "" )
   oSayVp2:SetText( "" )

   do case
   case nMode == APPD_MODE

      aGet[ _CREF    ]:show()
      aGet[ _CREF    ]:cText( Space( 200 ) )

      aGet[ _CDETALLE]:show()
      aGet[ _MLNGDES ]:Hide()
      aGet[ _CLOTE   ]:Hide()
      aGet[ _DFECCAD ]:Hide()
      aGet[ _NCANENT ]:cText( 1 )
      aGet[ _NUNICAJA]:cText( 1 )
      aGet[ __CALMORIGEN ]:cText( aTmpAlb[ _CALMORIGEN ] )
      aGet[ _CALMLIN ]:cText( aTmpAlb[ _CCODALM ] )

      aGet[ _NIVA    ]:cText( nIva( D():TiposIva( nView ), cDefIva() ) )
      aGet[ _NIVALIN ]:cText( nIva( D():TiposIva( nView ), cDefIva() ) )

      aTmp[ _NREQ    ]  := nReq( D():TiposIva( nView ), cDefIva() )
      aTmp[ _NNUMLIN ]  := nLastNum( dbfTmp )
      aTmp[ _NPOSPRINT ]:= nLastNum( dbfTmp, "nPosPrint" )
      aTmp[ _CLOTE   ]  := ""

      oSayLote:Hide()

      aGet[ __CCENTROCOSTE ]:cText( aTmpAlb[ _CCENTROCOSTE ] )

      if !empty( aGet[ __CCENTROCOSTE ] )
         aGet[ __CCENTROCOSTE ]:lValid()
      endif 

      cTipoCtrCoste        := "Centro de coste"
      oTipoCtrCoste:Refresh()
      clearGet( aGet[ _CTERCTR ] )

   case nMode != APPD_MODE .AND. empty( cCodArt )

      aGet[ _CREF    ]:Hide()
      aGet[ _CDETALLE]:Hide()
      aGet[ _MLNGDES ]:show()
      aGet[ _CLOTE   ]:Hide()
      aGet[ _DFECCAD ]:Hide()

      oSayLote:Hide()

      if !empty( aGet[ __CCENTROCOSTE ] )
         aGet[ __CCENTROCOSTE ]:lValid()
      endif 

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

      if !empty( aGet[ __CCENTROCOSTE ] )
         aGet[ __CCENTROCOSTE ]:lValid()
      endif 

   end case

   lCalcDeta( aTmp, aTmpAlb, aGet, oTotal )

   IF !empty( aTmp[ _CCODPR1 ] )
      aGet[ _CVALPR1 ]:Show()
      aGet[ _CVALPR1 ]:lValid()
      oSayPr1:Show()
      oSayPr1:SetText( retProp( aTmp[_CCODPR1], D():Propiedades( nView ) ) )
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
      oSayPr2:SetText( retProp( aTmp[ _CCODPR2 ], D():Propiedades( nView ) ) )
      oSayVp2:Show()
   ELSE
      aGet[ _CVALPR2 ]:Hide()
      oSayPr2:Hide()
      oSayVp2:Hide()
   END IF

   //Ocultamos las tres unidades de medicion

   aGet[ ( D():AlbaranesProveedoresLineas( nView ) )->( fieldpos( "nMedUno" ) ) ]:Hide()
   aGet[ ( D():AlbaranesProveedoresLineas( nView ) )->( fieldpos( "nMedDos" ) ) ]:Hide()
   aGet[ ( D():AlbaranesProveedoresLineas( nView ) )->( fieldpos( "nMedTre" ) ) ]:Hide()

   if D():GetObject( "UnidadMedicion", nView ):oDbf:Seek( aTmp[ _CUNIDAD ] )

      if D():GetObject( "UnidadMedicion", nView ):oDbf:nDimension >= 1 .and. !Empty( D():GetObject( "UnidadMedicion", nView ):oDbf:cTextoDim1 )
         aGet[ ( D():AlbaranesProveedoresLineas( nView ) )->( fieldpos( "nMedUno" ) ) ]:oSay:SetText( D():GetObject( "UnidadMedicion", nView ):oDbf:cTextoDim1 )
         aGet[ ( D():AlbaranesProveedoresLineas( nView ) )->( fieldpos( "nMedUno" ) ) ]:Show()
      end if

      if D():GetObject( "UnidadMedicion", nView ):oDbf:nDimension >= 2 .and. !Empty( D():GetObject( "UnidadMedicion", nView ):oDbf:cTextoDim2 )
         aGet[ ( D():AlbaranesProveedoresLineas( nView ) )->( fieldpos( "nMedDos" ) ) ]:oSay:SetText( D():GetObject( "UnidadMedicion", nView ):oDbf:cTextoDim2 )
         aGet[ ( D():AlbaranesProveedoresLineas( nView ) )->( fieldpos( "nMedDos" ) ) ]:Show()
      end if

      if D():GetObject( "UnidadMedicion", nView ):oDbf:nDimension >= 3 .and. !Empty( D():GetObject( "UnidadMedicion", nView ):oDbf:cTextoDim3 )
         aGet[ ( D():AlbaranesProveedoresLineas( nView ) )->( fieldpos( "nMedTre" ) ) ]:oSay:SetText( D():GetObject( "UnidadMedicion", nView ):oDbf:cTextoDim3 )
         aGet[ ( D():AlbaranesProveedoresLineas( nView ) )->( fieldpos( "nMedTre" ) ) ]:Show()
      end if

   end if

   aGet[ __CALMORIGEN  ]:lValid()
   aGet[ _CALMLIN  ]:lValid()
   aGet[ _CUNIDAD  ]:lValid()
   aGet[ _CCODFAM  ]:lValid()
   aGet[ _CREF     ]:SetFocus()

   /*
   IF oDlg != nil
      aRect := GetWndRect( oDlg:hWnd )
      oDlg:Move( aRect[1], aRect[2], 520, oDlg:nHeight, .t. )
   END IF
   */

RETURN .t.

//--------------------------------------------------------------------------//

STATIC FUNCTION SaveDeta( aTmp, aGet, oDlg, oFld, oBrw, nMode, oTotal, oGet, aTmpAlb, oSayPr1, oSayPr2, oSayVp1, oSayVp2, oBrwPrp, oBmp, oSayLote, oBtn, oBtnSer )

   local n, i

   oBtn:SetFocus()

   if !aGet[ _CREF ]:lValid()
      RETURN nil
   end if

   if !lMoreIva( aTmp[ _NIVA ] )
      RETURN nil
   end if

   if Empty( aTmp[ _CALMLIN ] )
      MsgStop( "Código de almacén no puede estar vacio" )
      aGet[ _CALMLIN ]:SetFocus()
      RETURN nil
   end if

   if ( aTmp[ _CALMLIN ] == aTmp[ __CALMORIGEN ] )
      MsgStop( "El almacén de origen debe ser distinto al almacén de destino" )
      aGet[ __CALMORIGEN ]:SetFocus()
      RETURN nil
   end if

   if !cAlmacen( aGet[ _CALMLIN ] )
      MsgStop( "Código de almacén no encontrado" )
      RETURN nil
   end if

   aTmp[ __CSUALB ]  := aTmpAlb[ _CSUALB ]
   aTmp[ _CTIPCTR ]  := cTipoCtrCoste

   /*
   Comprobamos si tiene que introducir números de serie------------------------
   */

   if ( nMode == APPD_MODE ) .and. ( aTmp[ _LNUMSER ] )

      if ( aTmp[ _LAUTSER ] )

         AutoNumerosSerie( aTmp, nMode )

      elseif !( dbfTmpSer )->( dbSeek( Str( aTmp[ _NNUMLIN ], 4 ) + aTmp[ _CREF ] ) )

         msgStop( "Tiene que introducir números de serie para este artículo." )

         EditarNumerosSerie( aTmp, nMode )

         RETURN .f.

      end if

   end if
  
   // Cambio de la moneda---------------------------------------------------------
   
   if aTmp[ _LLOTE ] .AND. nMode == APPD_MODE
      saveLoteActual( aTmp[ _CREF ], aTmp[ _CLOTE ], nView )
   end if

   if nMode == APPD_MODE

      if !Empty( oBrwPrp:Cargo )

         for n := 1 to len( oBrwPrp:Cargo )

            for i := 1 to len( oBrwPrp:Cargo[ n ] )

               if IsNum( oBrwPrp:Cargo[ n, i ]:Value ) .and. oBrwPrp:Cargo[ n, i ]:Value != 0

                  aTmp[ _NNUMLIN ]     := nLastNum( dbfTmp )
                  aTmp[ _NPOSPRINT ]   := nLastNum( dbfTmp, "nPosPrint" )
                  aTmp[ _NUNICAJA]     := oBrwPrp:Cargo[ n, i ]:Value
                  aTmp[ _CCODPR1 ]     := oBrwPrp:Cargo[ n, i ]:cCodigoPropiedad1
                  aTmp[ _CVALPR1 ]     := oBrwPrp:Cargo[ n, i ]:cValorPropiedad1
                  aTmp[ _CCODPR2 ]     := oBrwPrp:Cargo[ n, i ]:cCodigoPropiedad2
                  aTmp[ _CVALPR2 ]     := oBrwPrp:Cargo[ n, i ]:cValorPropiedad2

                  if oBrwPrp:Cargo[ n, i ]:nPrecioCompra != 0
                     aTmp[ _NPREDIV ]  := oBrwPrp:Cargo[ n, i ]:nPrecioCompra
                  end if

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

         SetDlgMode( aGet, aTmp, aTmpalb, nMode, oSayPr1, oSayPr2, oSayVp1, oSayVp2, oBrwPrp, oBmp, oDlg, oSayLote, oTotal )

         nTotAlbPrv( nil, D():AlbaranesProveedores( nView ), dbfTmp, D():TiposIva( nView ), D():Divisas( nView ), aTmpAlb )

      else

         oDlg:End( IDOK )

      end if

   else

      WinGather( aTmp, aGet, dbfTmp, oBrw, nMode )

      oDlg:end( IDOK )

   end if

   if nMode == APPD_MODE
      oLinDetCamposExtra:SaveTemporalAppend( ( dbfTmp )->( OrdKeyNo() ) )
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

RETURN NIL

//---------------------------------------------------------------------------//

Static FUNCTION EdtInc( aTmp, aGet, dbf, oBrw, bWhen, bValid, nMode, aTmpAlb )

   local oDlg

   if nMode == APPD_MODE
      aTmp[ _CSERALB  ] := aTmpAlb[ _CSERALB ]
      aTmp[ _NNUMALB  ] := aTmpAlb[ _NNUMALB ]
      aTmp[ _CSUFALB  ] := aTmpAlb[ _CSUFALB ]
      if IsMuebles()
         aTmp[ ( dbfTmpInc )->( FieldPos( "lAviso" ) ) ]  := .t.
      end if
   end if

   DEFINE DIALOG oDlg RESOURCE "INCIDENCIA" TITLE LblTitle( nMode ) + "incidencias de albaranes a proveedores"

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

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

Static FUNCTION EdtDoc( aTmp, aGet, dbf, oBrw, bWhen, bValid, nMode, aTmpLin )

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

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

STATIC FUNCTION PrnSerie( oBrw )

	local oDlg
   local oFmtDoc
   local cFmtDoc     := cFormatoDocumento( ( D():AlbaranesProveedores( nView ) )->cSerAlb, "nAlbPrv", D():Contadores( nView ) )
   local oSayFmt
   local cSayFmt
   local oSerIni
   local oSerFin   
   local cSerIni     := ( D():AlbaranesProveedores( nView ) )->cSerAlb
   local cSerFin     := ( D():AlbaranesProveedores( nView ) )->cSerAlb
   local nDocIni     := ( D():AlbaranesProveedores( nView ) )->nNumAlb
   local nDocFin     := ( D():AlbaranesProveedores( nView ) )->nNumAlb
   local cSufIni     := ( D():AlbaranesProveedores( nView ) )->CSUFALB
   local cSufFin     := ( D():AlbaranesProveedores( nView ) )->CSUFALB
   local oPrinter
   local cPrinter    := PrnGetName()
   local lCopiasPre  := .t.
   local lInvOrden   := .f.
   local oNumCop
   local nNumCop     := if( nCopiasDocumento( ( D():AlbaranesProveedores( nView ) )->cSerAlb, "nAlbPrv", D():Contadores( nView ) ) == 0, Max( Retfld( ( D():AlbaranesProveedores( nView ) )->cCodPrv, D():Proveedores( nView ), "nCopiasF" ), 1 ), nCopiasDocumento( ( D():AlbaranesProveedores( nView ) )->cSerAlb, "nAlbPrv", D():Contadores( nView ) ) )
   local oRango
   local nRango      := 1
   local dFecDesde   := CtoD( "01/01/" + Str( Year( Date() ) ) )
   local dFecHasta   := Date()

   if Empty( cFmtDoc )
      cFmtDoc        := cSelPrimerDoc( "AP" )
   end if

   cSayFmt           := cNombreDoc( cFmtDoc )

   DEFINE DIALOG oDlg RESOURCE "IMPSERIES" TITLE "Imprimir series de albaranes"

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
      ON HELP  ( BrwDocumento( oFmtDoc, oSayFmt, "AP" ) ) ;
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
      ACTION   (  StartPrint( SubStr( cFmtDoc, 1, 3 ), cSerIni + Str( nDocIni, 9 ) + cSufIni, cSerFin + Str( nDocFin, 9 ) + cSufFin, oDlg, cPrinter, lCopiasPre, nNumCop, lInvOrden, nRango, dFecDesde, dFecHasta ),;
                  oDlg:end( IDOK ) )

   REDEFINE BUTTON ;
      ID       IDCANCEL ;
		OF 		oDlg ;
		ACTION 	( oDlg:end() )

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

      nRecno      := ( D():AlbaranesProveedores( nView ) )->( Recno() )
      nOrdAnt     := ( D():AlbaranesProveedores( nView ) )->( OrdSetFocus( "NNUMALB" ) )

      if !lInvOrden

         ( D():AlbaranesProveedores( nView ) )->( dbSeek( cDocIni, .t. ) )

         while ( D():AlbaranesProveedores( nView ) )->cSerAlb + Str( ( D():AlbaranesProveedores( nView ) )->nNumAlb ) + ( D():AlbaranesProveedores( nView ) )->cSufAlb >= cDocIni .AND. ;
               ( D():AlbaranesProveedores( nView ) )->cSerAlb + Str( ( D():AlbaranesProveedores( nView ) )->nNumAlb ) + ( D():AlbaranesProveedores( nView ) )->cSufAlb <= cDocFin

               lChgImpDoc( D():AlbaranesProveedores( nView ) )

            if lCopiasPre

               nCopyProvee := if( nCopiasDocumento( ( D():AlbaranesProveedores( nView ) )->cSerAlb, "nAlbPrv", D():Contadores( nView ) ) == 0, Max( Retfld( ( D():AlbaranesProveedores( nView ) )->cCodPrv, D():Proveedores( nView ), "nCopiasF" ), 1 ), nCopiasDocumento( ( D():AlbaranesProveedores( nView ) )->cSerAlb, "nAlbPrv", D():Contadores( nView ) ) )

               GenAlbPrv( IS_PRINTER, "Imprimiendo documento : " + ( D():AlbaranesProveedores( nView ) )->cSerAlb + Str( ( D():AlbaranesProveedores( nView ) )->nNumAlb ) + ( D():AlbaranesProveedores( nView ) )->cSufAlb, cFmtDoc, cPrinter, nCopyProvee )

            else

               GenAlbPrv( IS_PRINTER, "Imprimiendo documento : " + ( D():AlbaranesProveedores( nView ) )->cSerAlb + Str( ( D():AlbaranesProveedores( nView ) )->nNumAlb ) + ( D():AlbaranesProveedores( nView ) )->cSufAlb, cFmtDoc, cPrinter, nNumCop )

            end if

         ( D():AlbaranesProveedores( nView ) )->( dbSkip() )

         end while

      else

         ( D():AlbaranesProveedores( nView ) )->( dbSeek( cDocFin ) )

         while ( D():AlbaranesProveedores( nView ) )->cSerAlb + Str( ( D():AlbaranesProveedores( nView ) )->nNumAlb ) + ( D():AlbaranesProveedores( nView ) )->cSufAlb >= cDocIni .and.;
               ( D():AlbaranesProveedores( nView ) )->cSerAlb + Str( ( D():AlbaranesProveedores( nView ) )->nNumAlb ) + ( D():AlbaranesProveedores( nView ) )->cSufAlb <= cDocFin .and.;
               !( D():AlbaranesProveedores( nView ) )->( Bof() )

               lChgImpDoc( D():AlbaranesProveedores( nView ) )

            if lCopiasPre

               nCopyProvee := if( nCopiasDocumento( ( D():AlbaranesProveedores( nView ) )->cSerAlb, "nAlbPrv", D():Contadores( nView ) ) == 0, Max( Retfld( ( D():AlbaranesProveedores( nView ) )->cCodPrv, D():Proveedores( nView ), "nCopiasF" ), 1 ), nCopiasDocumento( ( D():AlbaranesProveedores( nView ) )->cSerAlb, "nAlbPrv", D():Contadores( nView ) ) )

               GenAlbPrv( IS_PRINTER, "Imprimiendo documento : " + ( D():AlbaranesProveedores( nView ) )->cSerAlb + Str( ( D():AlbaranesProveedores( nView ) )->nNumAlb ) + ( D():AlbaranesProveedores( nView ) )->cSufAlb, cFmtDoc, cPrinter, nCopyProvee )

            else

               GenAlbPrv( IS_PRINTER, "Imprimiendo documento : " + ( D():AlbaranesProveedores( nView ) )->cSerAlb + Str( ( D():AlbaranesProveedores( nView ) )->nNumAlb ) + ( D():AlbaranesProveedores( nView ) )->cSufAlb, cFmtDoc, cPrinter, nNumCop )

            end if

         ( D():AlbaranesProveedores( nView ) )->( dbSkip( -1 ) )

         end while

      end if

   else

      nRecno      := ( D():AlbaranesProveedores( nView ) )->( Recno() )
      nOrdAnt     := ( D():AlbaranesProveedores( nView ) )->( OrdSetFocus( "DFECALB" ) )

      if !lInvOrden

         ( D():AlbaranesProveedores( nView ) )->( dbGoTop() )

         while !( D():AlbaranesProveedores( nView ) )->( Eof() )

            if ( D():AlbaranesProveedores( nView ) )->dFecAlb >= dFecDesde .and. ( D():AlbaranesProveedores( nView ) )->dFecAlb <= dFecHasta

               lChgImpDoc( D():AlbaranesProveedores( nView ) )

               if lCopiasPre

                  nCopyProvee := if( nCopiasDocumento( ( D():AlbaranesProveedores( nView ) )->cSerAlb, "nAlbPrv", D():Contadores( nView ) ) == 0, Max( Retfld( ( D():AlbaranesProveedores( nView ) )->cCodPrv, D():Proveedores( nView ), "nCopiasF" ), 1 ), nCopiasDocumento( ( D():AlbaranesProveedores( nView ) )->cSerAlb, "nAlbPrv", D():Contadores( nView ) ) )

                  GenAlbPrv( IS_PRINTER, "Imprimiendo documento : " + ( D():AlbaranesProveedores( nView ) )->cSerAlb + Str( ( D():AlbaranesProveedores( nView ) )->nNumAlb ) + ( D():AlbaranesProveedores( nView ) )->cSufAlb, cFmtDoc, cPrinter, nCopyProvee )

               else

                  GenAlbPrv( IS_PRINTER, "Imprimiendo documento : " + ( D():AlbaranesProveedores( nView ) )->cSerAlb + Str( ( D():AlbaranesProveedores( nView ) )->nNumAlb ) + ( D():AlbaranesProveedores( nView ) )->cSufAlb, cFmtDoc, cPrinter, nNumCop )

               end if

            end if   

         ( D():AlbaranesProveedores( nView ) )->( dbSkip() )

         end while

      else

         ( D():AlbaranesProveedores( nView ) )->( dbGoBottom() )

         while !( D():AlbaranesProveedores( nView ) )->( Bof() )

            if ( D():AlbaranesProveedores( nView ) )->dFecAlb >= dFecDesde .and. ( D():AlbaranesProveedores( nView ) )->dFecAlb <= dFecHasta

               lChgImpDoc( D():AlbaranesProveedores( nView ) )

               if lCopiasPre

                  nCopyProvee := if( nCopiasDocumento( ( D():AlbaranesProveedores( nView ) )->cSerAlb, "nAlbPrv", D():Contadores( nView ) ) == 0, Max( Retfld( ( D():AlbaranesProveedores( nView ) )->cCodPrv, D():Proveedores( nView ), "nCopiasF" ), 1 ), nCopiasDocumento( ( D():AlbaranesProveedores( nView ) )->cSerAlb, "nAlbPrv", D():Contadores( nView ) ) )

                  GenAlbPrv( IS_PRINTER, "Imprimiendo documento : " + ( D():AlbaranesProveedores( nView ) )->cSerAlb + Str( ( D():AlbaranesProveedores( nView ) )->nNumAlb ) + ( D():AlbaranesProveedores( nView ) )->cSufAlb, cFmtDoc, cPrinter, nCopyProvee )

               else

                  GenAlbPrv( IS_PRINTER, "Imprimiendo documento : " + ( D():AlbaranesProveedores( nView ) )->cSerAlb + Str( ( D():AlbaranesProveedores( nView ) )->nNumAlb ) + ( D():AlbaranesProveedores( nView ) )->cSufAlb, cFmtDoc, cPrinter, nNumCop )

               end if

            end if

         ( D():AlbaranesProveedores( nView ) )->( dbSkip( -1 ) )

         end while

      end if
   
   end if   

   ( D():AlbaranesProveedores( nView ) )->( ordSetFocus( nOrdAnt ) )
   ( D():AlbaranesProveedores( nView ) )->( dbGoTo( nRecNo ) )

   oDlg:enable()

RETURN NIL

//--------------------------------------------------------------------------//

STATIC FUNCTION GenAlbPrv( nDevice, cCaption, cCodDoc, cPrinter, nCopies )

   local oDevice
   local nAlbaran

   if ( D():AlbaranesProveedores( nView ) )->( Lastrec() ) == 0
      RETURN nil
   end if

   nAlbaran             := ( D():AlbaranesProveedores( nView ) )->cSerAlb + Str( ( D():AlbaranesProveedores( nView ) )->nNumAlb ) + ( D():AlbaranesProveedores( nView ) )->CSUFALB

   DEFAULT nDevice      := IS_PRINTER
   DEFAULT cCaption     := "Imprimiendo albarán"
   DEFAULT cCodDoc      := cFormatoDocumento( ( D():AlbaranesProveedores( nView ) )->cSerAlb, "nAlbPrv", D():Contadores( nView ) )
   DEFAULT nCopies      := if( nCopiasDocumento( ( D():AlbaranesProveedores( nView ) )->cSerAlb, "nAlbPrv", D():Contadores( nView ) ) == 0, Max( Retfld( ( D():AlbaranesProveedores( nView ) )->cCodPrv, D():Proveedores( nView ), "nCopiasF" ), 1 ), nCopiasDocumento( ( D():AlbaranesProveedores( nView ) )->cSerAlb, "nAlbPrv", D():Contadores( nView ) ) )

   if Empty( cCodDoc )
      cCodDoc           := cFirstDoc( "AP", D():Documentos( nView ) )
   end if

   if !lExisteDocumento( cCodDoc, D():Documentos( nView ) )
      RETURN nil
   end if

   /*
   Si el documento es de tipo visual-------------------------------------------
   */

   if lVisualDocumento( cCodDoc, D():Documentos( nView ) )
      PrintReportAlbPrv( nDevice, nCopies, cPrinter )
   else
      msgStop( "El formato ya no es soportado" )
   end if

   lChgImpDoc( D():AlbaranesProveedores( nView ) )

RETURN NIL

//---------------------------------------------------------------------------//

static FUNCTION nGenAlbPrv( nDevice, cTitle, cCodDoc, cPrinter, nCopy )

   local nImpYet     := 1
   local nCopyClient := Retfld( ( D():AlbaranesProveedores( nView ) )->cCodPrv, D():Proveedores( nView ), "nCopiasF" )

   DEFAULT nDevice   := IS_PRINTER
   DEFAULT nCopy     := Max( nCopyClient, nCopiasDocumento( ( D():AlbaranesProveedores( nView ) )->cSerAlb, "nAlbPrv", D():Contadores( nView ) ) )

   nCopy             := Max( nCopy, 1 )

   while nImpYet <= nCopy
      GenAlbPrv( nDevice, cTitle, cCodDoc, cPrinter )
      nImpYet++
   end while

   //Funcion para marcar el documento como imprimido
   lChgImpDoc( D():AlbaranesProveedores( nView ) )

RETURN nil

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

static FUNCTION nTotalUnd( nAlbaran, cPicUnd )

   local nTotUnd  := 0

   if ( D():AlbaranesProveedoresLineas( nView ) )->( dbSeek( nAlbaran ) )
      while  ( D():AlbaranesProveedoresLineas( nView ) )->cSerAlb + Str( ( D():AlbaranesProveedoresLineas( nView ) )->nNumAlb ) + ( D():AlbaranesProveedoresLineas( nView ) )->CSUFALB == nAlbaran .and. ( D():AlbaranesProveedoresLineas( nView ) )->( !eof() )
         nTotUnd  += nTotNAlbPrv( D():AlbaranesProveedoresLineas( nView ) )
         ( D():AlbaranesProveedoresLineas( nView ) )->( dbSkip() )
      end do
   end if

RETURN ( Trans( nTotUnd, cPicUnd ) )

//--------------------------------------------------------------------------//

Static FUNCTION RecalculaTotal( aTmp )

   nTotAlbPrv( nil, D():AlbaranesProveedores( nView ), dbfTmp, D():TiposIva( nView ), D():Divisas( nView ), aTmp )

   oBrwIva:Refresh()

   oGetNet:SetText( Trans( nTotNet, cPirDiv ) )

   oGetIva:SetText( Trans( nTotIva, cPirDiv ) )

   oGetReq:SetText( Trans( nTotReq, cPirDiv ) )

   oGetTot:SetText( Trans( nTotAlb, cPirDiv ) )

   oGetIvm:SetText( Trans( nTotIvm, cPirDiv ) )

RETURN .t.

//--------------------------------------------------------------------------//

Static FUNCTION GetArtPrv( cRefPrv, cCodPrv, aGet )

   local nOrdAnt  := ( D():ProveedorArticulo( nView ) )->( ordSetFocus( "cRefPrv" ) )

   if Empty( cRefPrv )

      RETURN .t.

   else

      if ( D():ProveedorArticulo( nView ) )->( dbSeek( cCodPrv + cRefPrv ) )

         aGet[ _CREF ]:cText( ( D():ProveedorArticulo( nView ) )->cCodArt )
			aGet[ _CREF ]:lValid()

      else

         msgStop( "Referencia de proveedor no encontrada" )

      end if

		( D():ProveedorArticulo( nView ) )->( ordSetFocus( nOrdAnt ) )

   end if

RETURN .t.

//----------------------------------------------------------------------------//

Static FUNCTION LoaArt( cCodArt, aGet, aTmp, aTmpAlb, oFld, oSayPr1, oSayPr2, oSayVp1, oSayVp2, oBmp, oBrwPrp, oDlg, oSayLote, oBeneficioSobre, oTotal, nMode )

   local hHas128
   local cLote
   local dFechaCaducidad
   local nIva
   local nOrdAnt
   local cCodFam
   local nPreCos
   local cCodPrv
   local cPrpArt
   local nPreCom
   local lChgCodArt
   local lSeek       := .f.

   nIva              := 0
   nPreCom           := 0
   cCodPrv           := aTmpAlb[ _CCODPRV ]
   cPrpArt           := aTmp[ _CCODPR1 ] + aTmp[ _CCODPR2 ] + aTmp[ _CVALPR1 ] + aTmp[ _CVALPR2 ]
   lChgCodArt        := ( Rtrim( cOldCodArt ) != Rtrim( cCodArt ) .or. Rtrim( cOldPrpArt ) != Rtrim( cPrpArt ) )

   if Empty( cCodArt )

      if lRetCodArt()
         MsgStop( "No se pueden añadir lineas sin codificar" )
         RETURN .f.
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
      Buscamos codificacion GS1-128--------------------------------------------
      */

      if Len( Alltrim( cCodArt ) ) > 18

         hHas128              := ReadHashCodeGS128( cCodArt )
         if !Empty( hHas128 )
            cCodArt           := uGetCodigo( hHas128, "01" )
            cLote             := Upper( uGetCodigo( hHas128, "10" ) )
            dFechaCaducidad   := uGetCodigo( hHas128, "15" )
         end if 

      end if

      if lIntelliArtciculoSearch( cCodArt, cCodPrv, D():Articulos( nView ), D():ProveedorArticulo( nView ), D():ArticulosCodigosBarras( nView ) )

         if ( lChgCodArt )

            if ( D():Articulos( nView ) )->lObs
               MsgStop( "Artículo catalogado como obsoleto" )
               RETURN .f.
            end if

            oFld:aEnable         := { .t., .t., .t., .t. }
            oFld:Refresh()

            EliminarNumeroSerie( aTmp )

            cCodArt              := ( D():Articulos( nView ) )->Codigo

            aGet[ _CREF ]:cText( Padr( cCodArt, 200 ) )
            aTmp[ _CREF ]        := cCodArt

            //Pasamos las referencias adicionales------------------------------

            aTmp[ _CREFAUX ]     := ( D():Articulos( nView ) )->cRefAux
            aTmp[ _CREFAUX2 ]    := ( D():Articulos( nView ) )->cRefAux2

            /*
            Preguntamos si el regimen de impuestos es distinto de Exento-------------
            */

            if aTmpAlb[ _NREGIVA ] <= 1

               nIva                 := nIva( D():TiposIva( nView ), ( D():Articulos( nView ) )->TipoIva )

               aGet[ _NIVA    ]:cText( nIva )
               aGet[ _NIVALIN ]:cText( nIva )
               aGet[ _LIVALIN ]:Click( ( D():Articulos( nView ) )->lIvaInc )

               aTmp[ _NREQ    ]  := nReq( D():TiposIva( nView ), ( D():Articulos( nView ) )->TipoIva )

            end if   

            aGet[ _CDETALLE ]:cText( ( D():Articulos( nView ) )->Nombre )

            // Ahora recogemos el impuesto especial si lo hay---------------------

            aTmp[ _CCODIMP ]     := ( D():Articulos( nView ) )->cCodImp

            oNewImp:setCodeAndValue( aTmp[ _CCODIMP ], aGet[ _NVALIMP ] )

            if ( D():Articulos( nView ) )->nCajEnt != 0
               aGet[ _NCANENT ]:cText( ( D():Articulos( nView ) )->nCajEnt )
            end if

            if ( D():Articulos( nView ) )->nUniCaja != 0
               aGet[ _NUNICAJA ]:cText( ( D():Articulos( nView ) )->nUniCaja )
            end if

            // Lotes

            aTmp[ _LLOTE ]       := ( D():Articulos( nView ) )->lLote

            if ( D():Articulos( nView ) )->lLote

               if Empty( cLote )
                  cLote          := ( D():Articulos( nView ) )->cLote
               end if 

               oSayLote:Show()
               aGet[ _CLOTE   ]:Show()
               aGet[ _CLOTE   ]:cText( cLote )
 
               /*
               Fecha de caducidad----------------------------------------------
               */

               if Empty( dFechaCaducidad )
                  dFechaCaducidad      := dFechaCaducidadLote( aTmp[ _CREF ], aTmp[ _CVALPR1 ], aTmp[ _CVALPR2 ], aTmp[ _CLOTE ], D():AlbaranesProveedoresLineas( nView ), D():FacturasProveedoresLineas( nView ), D():PartesProduccionMaterialProducido( nView ) )
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

            // Comentarios-----------------------------------------------------

            if ( D():Articulos( nView ) )->lMosCom .and. !Empty( ( D():Articulos( nView ) )->mComent )
               MsgStop( Trim( ( D():Articulos( nView ) )->mComent ) )
            end if

            /*
            Series
            -------------------------------------------------------------------
            */

            aTmp[ _LNUMSER ]     := ( D():Articulos( nView ) )->lNumSer
            aTmp[ _LAUTSER ]     := ( D():Articulos( nView ) )->lAutSer

            /*
            Tomamos el valor de las familias y los grupos de familias----------
            */

            cCodFam              := ( D():Articulos( nView ) )->Familia
            if !Empty( cCodFam )
               aTmp[ _CCODFAM ]  := cCodFam
               aTmp[ _CGRPFAM ]  := cGruFam( cCodFam, D():Familias( nView ) )
            end if

            /*
            Control de stocks--------------------------------------------------
            */

            aTmp[ _NCTLSTK ]     := ( D():Articulos( nView ) )->nCtlStock

            /*
            Tratamientos kits-----------------------------------------------------
            */

            if ( D():Articulos( nView ) )->lKitArt

               aTmp[ _LKITART ]     := ( D():Articulos( nView ) )->lKitArt                        // Marcamos como padre del kit
               aTmp[ _LIMPLIN ]     := lImprimirCompuesto( ( D():Articulos( nView ) )->Codigo, D():Articulos( nView ) ) // 1 Todos, 2 Compuesto
               aTmp[ _LKITPRC ]     := lPreciosCompuestos( ( D():Articulos( nView ) )->Codigo, D():Articulos( nView ) ) // 1 Todos, 2 Compuesto

               if lStockCompuestos( ( D():Articulos( nView ) )->Codigo, D():Articulos( nView ) )
                  aTmp[ _NCTLSTK ]  := ( D():Articulos( nView ) )->nCtlStock
               else
                  aTmp[ _NCTLSTK ]  := STOCK_NO_CONTROLAR // No controlar Stock
               end if

            else

               aTmp[ _LIMPLIN ]     := .f.
               aTmp[ _NCTLSTK ]     := ( D():Articulos( nView ) )->nCtlStock

            end if

            /*
            Referencia de proveedor-----------------------------------------------
            */

            nOrdAnt                 := ( D():ProveedorArticulo( nView ) )->( OrdSetFocus( "cCodPrv" ) )

            if ( D():ProveedorArticulo( nView ) )->( dbSeek( cCodPrv + cCodArt ) )

               if !Empty( aGet[ _CREFPRV ] )
                  aGet[ _CREFPRV ]:cText( ( D():ProveedorArticulo( nView ) )->cRefPrv )
               end if

            else

               if !Empty( aGet[ _CREFPRV ] )
                  aGet[ _CREFPRV ]:cText( Space( 20 ) )
               end if

            end if

            ( D():ProveedorArticulo( nView ) )->( ordSetFocus( nOrdAnt ) )

            /*
            Buscamos la familia del articulo y anotamos las propiedades-----------
            */

            aTmp[_CCODPR1 ]         := ( D():Articulos( nView ) )->cCodPrp1
            aTmp[_CCODPR2 ]         := ( D():Articulos( nView ) )->cCodPrp2

            if ( !Empty( aTmp[ _CCODPR1 ] ) .or. !Empty( aTmp[ _CCODPR2 ] ) ) .and. ;
               ( uFieldEmpresa( "lUseTbl" )                                   .and. ;
               ( nMode == APPD_MODE ) )

               nPreCom              := nCosto( nil, D():Articulos( nView ), D():Kit( nView ), .f., aTmpAlb[ _CDIVALB ], D():Divisas( nView ) )

               setPropertiesTable( cCodArt, aTmp[ _CCODPR1 ], aTmp[ _CCODPR2 ], nPreCom, aGet[ _NUNICAJA ], oBrwPrp, nView )

            else
               
               hidePropertiesTable( oBrwPrp )
               
               if !Empty( aTmp[ _CCODPR1 ] )

                  if aGet[ _CVALPR1 ] != nil
                     aGet[ _CVALPR1 ]:Show()
                     aGet[ _CVALPR1 ]:SetFocus()
                  end if

                  if oSayPr1 != nil
                     oSayPr1:SetText( retProp( ( D():Articulos( nView ) )->cCodPrp1, D():Propiedades( nView ) ) )
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
                     oSayPr2:SetText( retProp( ( D():Articulos( nView ) )->cCodPrp2, D():Propiedades( nView ) ) )
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
               aGet[ _CUNIDAD ]:cText( ( D():Articulos( nView ) )->cUnidad )
               aGet[ _CUNIDAD ]:lValid()
            else
               aTmp[ _CUNIDAD ]  := ( D():Articulos( nView ) )->cUnidad
            end if

            ValidaMedicion( aTmp, aGet )

         end if

         cPrpArt                 := aTmp[ _CCODPR1 ] + aTmp[ _CCODPR2 ] + aTmp[ _CVALPR1 ] + aTmp[ _CVALPR2 ]

         if ( lChgCodArt ) .or. ( cPrpArt != cOldPrpArt )

            nPreCom              := nComPro( aTmp[ _CREF ], aTmp[ _CCODPR1 ], aTmp[ _CVALPR1 ], aTmp[ _CCODPR2 ], aTmp[ _CVALPR2 ], D():ArticuloPrecioPropiedades( nView ) )

            if nPrecom  != 0

               aGet[ _NPREDIV ]:cText( nPreCom )

            else

               if uFieldEmpresa( "lCosPrv" )
                  nPreCom        := nPrecioReferenciaProveedor( cCodPrv, cCodArt, D():ProveedorArticulo( nView ) )
               end if

               if nPreCom != 0
                  aGet[ _NPREDIV ]:cText( nPreCom )
               else
                  aGet[ _NPREDIV ]:cText( nCosto( nil, D():Articulos( nView ), D():Kit( nView ), .f., aTmpAlb[ _CDIVALB ], D():Divisas( nView ) ) )
               end if

               /*
               Descuento de articulo----------------------------------------------
               */

               if uFieldEmpresa( "lCosPrv", .f. )

                  nPreCom           := nDescuentoReferenciaProveedor( cCodPrv, cCodArt, D():ProveedorArticulo( nView ) )

                  if nPreCom != 0
                     aGet[ _NDTOLIN ]:cText( nPreCom )
                  end if

                  /*
                  Descuento de promocional----------------------------------------------
                  */

                  nPreCom           := nPromocionReferenciaProveedor( cCodPrv, cCodArt, D():ProveedorArticulo( nView ) )

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
            Punto verde
            */

            if !Empty( aGet[ _NPNTVER ] )
               aGet[ _NPNTVER ]:cText( ( D():Articulos( nView ) )->nPntVer1 )
            end if

            /*
            Ponemos el precio de venta recomendado-----------------------------
            */

            aTmp[ _NPVPREC ]        := nCnv2Div( ( D():Articulos( nView ) )->PvpRec, cDivEmp(), aTmpAlb[ _CDIVALB ] )

            // Situacion posterior------------------------------------------------

            aGet[ _NBNFLIN1 ]:cText( ( D():Articulos( nView ) )->Benef1 )
            aGet[ _NBNFLIN2 ]:cText( ( D():Articulos( nView ) )->Benef2 )
            aGet[ _NBNFLIN3 ]:cText( ( D():Articulos( nView ) )->Benef3 )
            aGet[ _NBNFLIN4 ]:cText( ( D():Articulos( nView ) )->Benef4 )
            aGet[ _NBNFLIN5 ]:cText( ( D():Articulos( nView ) )->Benef5 )
            aGet[ _NBNFLIN6 ]:cText( ( D():Articulos( nView ) )->Benef6 )

            aGet[ _LBNFLIN1 ]:Click( ( D():Articulos( nView ) )->lBnf1 )
            aGet[ _LBNFLIN2 ]:Click( ( D():Articulos( nView ) )->lBnf2 )
            aGet[ _LBNFLIN3 ]:Click( ( D():Articulos( nView ) )->lBnf3 )
            aGet[ _LBNFLIN4 ]:Click( ( D():Articulos( nView ) )->lBnf4 )
            aGet[ _LBNFLIN5 ]:Click( ( D():Articulos( nView ) )->lBnf5 )
            aGet[ _LBNFLIN6 ]:Click( ( D():Articulos( nView ) )->lBnf6 )

            aGet[ _NPVPLIN1 ]:cText( ( D():Articulos( nView ) )->pVenta1  )
            aGet[ _NPVPLIN2 ]:cText( ( D():Articulos( nView ) )->pVenta2  )
            aGet[ _NPVPLIN3 ]:cText( ( D():Articulos( nView ) )->pVenta3  )
            aGet[ _NPVPLIN4 ]:cText( ( D():Articulos( nView ) )->pVenta4  )
            aGet[ _NPVPLIN5 ]:cText( ( D():Articulos( nView ) )->pVenta5  )
            aGet[ _NPVPLIN6 ]:cText( ( D():Articulos( nView ) )->pVenta6  )

            aGet[ _NIVALIN1 ]:cText( ( D():Articulos( nView ) )->pVtaIva1 )
            aGet[ _NIVALIN2 ]:cText( ( D():Articulos( nView ) )->pVtaIva2 )
            aGet[ _NIVALIN3 ]:cText( ( D():Articulos( nView ) )->pVtaIva3 )
            aGet[ _NIVALIN4 ]:cText( ( D():Articulos( nView ) )->pVtaIva4 )
            aGet[ _NIVALIN5 ]:cText( ( D():Articulos( nView ) )->pVtaIva5 )
            aGet[ _NIVALIN6 ]:cText( ( D():Articulos( nView ) )->pVtaIva6 )

            oBeneficioSobre[ 1 ]:Select( Max( ( D():Articulos( nView ) )->nBnfSbr1, 1 ) )
            oBeneficioSobre[ 2 ]:Select( Max( ( D():Articulos( nView ) )->nBnfSbr2, 1 ) )
            oBeneficioSobre[ 3 ]:Select( Max( ( D():Articulos( nView ) )->nBnfSbr3, 1 ) )
            oBeneficioSobre[ 4 ]:Select( Max( ( D():Articulos( nView ) )->nBnfSbr4, 1 ) )
            oBeneficioSobre[ 5 ]:Select( Max( ( D():Articulos( nView ) )->nBnfSbr5, 1 ) )
            oBeneficioSobre[ 6 ]:Select( Max( ( D():Articulos( nView ) )->nBnfSbr6, 1 ) )

            // Guardamos el precio de costo para posteriores comprobaciones

            nPreCos  := nCnv2Div( ( D():Articulos( nView ) )->pCosto, cDivEmp(), aTmpAlb[ _CDIVALB ] )

         end if

         /*
         Recalculo de totales--------------------------------------------------
         */

         lCalcDeta( aTmp, aTmpAlb, aGet, oTotal )

      else

         msgStop( "Artículo no encontrado" )

         RETURN .f.

      end if

   end if

   cOldCodArt        := cCodArt
   cOldPrpArt        := cPrpArt

RETURN .t.

//----------------------------------------------------------------------------//

Static FUNCTION cPedPrv( aGet, aTmp, oBrw, nMode )

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
      RETURN .t.
   end if

   if ( D():PedidosProveedores( nView ) )->( dbSeek( cPedido ) )

      if ( D():PedidosProveedores( nView ) )->nEstado == 3

         MsgStop( "Pedido recibido", "Opción cancelada" )
         lValid      := .f.

      else

         /*
         Guardamos el estado del pedido por si no se guarda el albaran
         */

         cOldEst  := ( D():PedidosProveedores( nView ) )->nEstado

         aGet[ _CNUMPED ]:cText( ( D():PedidosProveedores( nView ) )->cSerPed + Str( ( D():PedidosProveedores( nView ) )->nNumPed ) + ( D():PedidosProveedores( nView ) )->cSufPed )
         aGet[ _CNUMPED ]:bWhen := {|| .F. }

         aGet[ _CCODPRV ]:cText( ( D():PedidosProveedores( nView ) )->cCodPrv )
         aGet[ _CCODPRV ]:lValid()

         aGet[ _CCODCAJ ]:cText( ( D():PedidosProveedores( nView ) )->cCodCaj )
         aGet[ _CCODCAJ ]:lValid()

         aGet[ _CCODALM ]:cText( ( D():PedidosProveedores( nView ) )->cCodAlm )
         aGet[ _CCODALM ]:lValid()

         aGet[ _LRECARGO]:Click( ( D():PedidosProveedores( nView ) )->lRecargo )

         aGet[ _CCODPGO ]:cText( ( D():PedidosProveedores( nView ) )->cCodPgo )
         aGet[ _CCODPGO ]:lValid()

         aGet[ _CDTOESP ]:cText( ( D():PedidosProveedores( nView ) )->cDtoEsp )
         aGet[ _NDTOESP ]:cText( ( D():PedidosProveedores( nView ) )->nDtoEsp )

         aGet[ _CDPP    ]:cText( ( D():PedidosProveedores( nView ) )->cDpp )
         aGet[ _NDPP    ]:cText( ( D():PedidosProveedores( nView ) )->nDpp )

         aGet[ _CDTOUNO ]:cText( ( D():PedidosProveedores( nView ) )->cDtoUno )
         aGet[ _NDTOUNO ]:cText( ( D():PedidosProveedores( nView ) )->nDtoUno )

         aGet[ _CDTODOS ]:cText( ( D():PedidosProveedores( nView ) )->cDtoDos )
         aGet[ _NDTODOS ]:cText( ( D():PedidosProveedores( nView ) )->nDtoDos )

         aGet[ _NREGIVA ]:nOption( Max( ( D():Proveedores( nView ) )->nRegIva, 1 ) )
         aGet[ _NREGIVA ]:Refresh()

         aGet[ _COBSERV ]:cText( ( D():PedidosProveedores( nView ) )->cObserv )

         cPedCli           := ( D():PedidosProveedores( nView ) )->cNumPedCli

         /*
         Si lo encuentra-------------------------------------------------------
			*/

         if ( D():PedidosProveedoresLineas( nView ) )->( dbSeek( cPedido ) )

            while ( ( D():PedidosProveedoresLineas( nView ) )->cSerPed + Str( ( D():PedidosProveedoresLineas( nView ) )->nNumPed ) + ( D():PedidosProveedoresLineas( nView ) )->cSufPed == cPedido )

               /*
               Calculamos el total de unidades q se tienen q llevar------------
               */

               nTotPed                 := nTotNPedPrv( D():PedidosProveedoresLineas( nView ) )
               nTotRec                 := nUnidadesRecibidasPedPrv( ( D():PedidosProveedoresLineas( nView ) )->cSerPed + Str( ( D():PedidosProveedoresLineas( nView ) )->nNumPed ) + ( D():PedidosProveedoresLineas( nView ) )->cSufPed, ( D():PedidosProveedoresLineas( nView ) )->cRef, ( D():PedidosProveedoresLineas( nView ) )->cValPr1, ( D():PedidosProveedoresLineas( nView ) )->cValPr2, ( D():PedidosProveedoresLineas( nView ) )->cRefPrv, D():AlbaranesProveedoresLineas( nView ) )
               nTotPdt                 := nTotPed - nTotRec

               /*
               Vamos a ver si quedan unidades por recibir
               */

               if nTotPdt != 0

                  (dbfTmp)->( dbAppend() )

                  (dbfTmp)->nNumAlb    := nAlbaran
                  (dbfTmp)->cCodPed    := cPedido
                  (dbfTmp)->cNumPed    := cPedCli
                  (dbfTmp)->cRef       := ( D():PedidosProveedoresLineas( nView ) )->cRef
                  (dbfTmp)->nIva       := ( D():PedidosProveedoresLineas( nView ) )->nIva
                  (dbfTmp)->nIvaLin    := ( D():PedidosProveedoresLineas( nView ) )->nIva
                  (dbfTmp)->nReq       := ( D():PedidosProveedoresLineas( nView ) )->nReq
                  (dbfTmp)->cDetalle   := ( D():PedidosProveedoresLineas( nView ) )->cDetalle
                  (dbfTmp)->mLngDes    := ( D():PedidosProveedoresLineas( nView ) )->mLngDes
                  (dbfTmp)->mNumSer    := ( D():PedidosProveedoresLineas( nView ) )->mNumSer
                  (dbfTmp)->nPreDiv    := ( D():PedidosProveedoresLineas( nView ) )->nPreDiv                              // Precios
                  (dbfTmp)->nPreCom    := ( D():PedidosProveedoresLineas( nView ) )->nPreDiv                              // Precios
                  (dbfTmp)->nCanPed    := ( D():PedidosProveedoresLineas( nView ) )->nCanPed                              // Cajas pedidas
                  (dbfTmp)->nUniPed    := ( D():PedidosProveedoresLineas( nView ) )->nUniCaja                             // Unidades pedidas
                  (dbfTmp)->cCodPr1    := ( D():PedidosProveedoresLineas( nView ) )->cCodPr1                              // Cod. prop. 1
                  (dbfTmp)->cCodPr2    := ( D():PedidosProveedoresLineas( nView ) )->cCodPr2                              // Cod. prop. 2
                  (dbfTmp)->cValPr1    := ( D():PedidosProveedoresLineas( nView ) )->cValPr1                              // Val. prop. 1
                  (dbfTmp)->cValPr2    := ( D():PedidosProveedoresLineas( nView ) )->cValPr2                              // Val. prop. 2
                  (dbfTmp)->nFacCnv    := ( D():PedidosProveedoresLineas( nView ) )->nFacCnv                              // Factor de conversion
                  (dbfTmp)->cAlmLin    := ( D():PedidosProveedoresLineas( nView ) )->cAlmLin                              // Almacen en linea
                  (dbfTmp)->nCtlStk    := ( D():PedidosProveedoresLineas( nView ) )->nCtlStk                              // Control de Stock
                  (dbfTmp)->nNumLin    := ( D():PedidosProveedoresLineas( nView ) )->nNumLin
                  (dbfTmp)->nUndKit    := ( D():PedidosProveedoresLineas( nView ) )->nUndKit
                  (dbfTmp)->lKitChl    := ( D():PedidosProveedoresLineas( nView ) )->lKitChl
                  (dbfTmp)->lKitArt    := ( D():PedidosProveedoresLineas( nView ) )->lKitArt
                  (dbfTmp)->lKitPrc    := ( D():PedidosProveedoresLineas( nView ) )->lKitPrc
                  (dbfTmp)->nDtoLin    := ( D():PedidosProveedoresLineas( nView ) )->nDtoLin
                  (dbfTmp)->nDtoPrm    := ( D():PedidosProveedoresLineas( nView ) )->nDtoPrm
                  (dbfTmp)->nDtoRap    := ( D():PedidosProveedoresLineas( nView ) )->nDtoRap
                  (dbfTmp)->lImpLin    := ( D():PedidosProveedoresLineas( nView ) )->lImpLin
                  (dbfTmp)->lLote      := ( D():PedidosProveedoresLineas( nView ) )->lLote
                  (dbfTmp)->nLote      := ( D():PedidosProveedoresLineas( nView ) )->nLote
                  (dbfTmp)->cLote      := ( D():PedidosProveedoresLineas( nView ) )->cLote
                  (dbfTmp)->mObsLin    := ( D():PedidosProveedoresLineas( nView ) )->mObsLin
                  (dbfTmp)->cRefPrv    := ( D():PedidosProveedoresLineas( nView ) )->cRefPrv
                  (dbfTmp)->cUnidad    := ( D():PedidosProveedoresLineas( nView ) )->cUnidad
                  (dbfTmp)->nNumMed    := ( D():PedidosProveedoresLineas( nView ) )->nNumMed
                  (dbfTmp)->nMedUno    := ( D():PedidosProveedoresLineas( nView ) )->nMedUno
                  (dbfTmp)->nMedDos    := ( D():PedidosProveedoresLineas( nView ) )->nMedDos
                  (dbfTmp)->nMedTre    := ( D():PedidosProveedoresLineas( nView ) )->nMedTre
                  (dbfTmp)->nBultos    := ( D():PedidosProveedoresLineas( nView ) )->nBultos
                  (dbfTmp)->cFormato   := ( D():PedidosProveedoresLineas( nView ) )->cFormato
                  (dbfTmp)->cCodImp    := ( D():PedidosProveedoresLineas( nView ) )->cCodImp
                  (dbfTmp)->nValImp    := ( D():PedidosProveedoresLineas( nView ) )->nValImp
                  (dbfTmp)->cCodFam    := ( D():PedidosProveedoresLineas( nView ) )->cCodFam
                  (dbfTmp)->cRefAux    := ( D():PedidosProveedoresLineas( nView ) )->cRefAux
                  (dbfTmp)->cRefAux2   := ( D():PedidosProveedoresLineas( nView ) )->cRefAux2
                  (dbfTmp)->nPosPrint  := ( D():PedidosProveedoresLineas( nView ) )->nPosPrint
                  (dbfTmp)->cCtrCoste  := ( D():PedidosProveedoresLineas( nView ) )->cCtrCoste
                  (dbfTmp)->cTipCtr    := ( D():PedidosProveedoresLineas( nView ) )->cTipCtr
                  (dbfTmp)->cTerCtr    := ( D():PedidosProveedoresLineas( nView ) )->cTerCtr

                 /*
                  Comprobamos si hay calculos por cajas
                  */

                  if lCalCaj()

                     if nTotRec != 0

                        nDiv  := Mod( nTotPdt, ( D():PedidosProveedoresLineas( nView ) )->nUniCaja )
                        if nDiv == 0 .and. ( D():PedidosProveedoresLineas( nView ) )->nCanPed != 0
                           ( dbfTmp )->nCanEnt  := Div( nTotPdt, ( D():PedidosProveedoresLineas( nView ) )->nUniCaja )
                           ( dbfTmp )->nUniCaja := ( D():PedidosProveedoresLineas( nView ) )->nUniCaja
                        else
                           ( dbfTmp )->nCanEnt  := 0
                           ( dbfTmp )->nUniCaja := nTotPdt
                        end if

                     else

                        ( dbfTmp )->nCanEnt     := ( D():PedidosProveedoresLineas( nView ) )->nCanPed
                        ( dbfTmp )->nUniCaja    := ( D():PedidosProveedoresLineas( nView ) )->nUniCaja

                     end if

                  else

                     ( dbfTmp )->nUniCaja       := nTotPdt

                  end if

                  /*
                  Tomamos datos de la ficha de articulos-----------------------
                  */

                  if ( D():Articulos( nView ) )->( dbSeek( ( D():PedidosProveedoresLineas( nView ) )->cRef ) )

                     ( dbfTmp )->lIvaLin  := ( D():Articulos( nView ) )->lIvaInc

                     ( dbfTmp )->nBnfLin1 := ( D():Articulos( nView ) )->Benef1
                     ( dbfTmp )->nBnfLin2 := ( D():Articulos( nView ) )->Benef2
                     ( dbfTmp )->nBnfLin3 := ( D():Articulos( nView ) )->Benef3
                     ( dbfTmp )->nBnfLin4 := ( D():Articulos( nView ) )->Benef4
                     ( dbfTmp )->nBnfLin5 := ( D():Articulos( nView ) )->Benef5
                     ( dbfTmp )->nBnfLin6 := ( D():Articulos( nView ) )->Benef6

                     ( dbfTmp )->lBnfLin1 := ( D():Articulos( nView ) )->lBnf1
                     ( dbfTmp )->lBnfLin2 := ( D():Articulos( nView ) )->lBnf2
                     ( dbfTmp )->lBnfLin3 := ( D():Articulos( nView ) )->lBnf3
                     ( dbfTmp )->lBnfLin4 := ( D():Articulos( nView ) )->lBnf4
                     ( dbfTmp )->lBnfLin5 := ( D():Articulos( nView ) )->lBnf5
                     ( dbfTmp )->lBnfLin6 := ( D():Articulos( nView ) )->lBnf6

                     ( dbfTmp )->nBnfSbr1 := ( D():Articulos( nView ) )->nBnfSbr1
                     ( dbfTmp )->nBnfSbr2 := ( D():Articulos( nView ) )->nBnfSbr2
                     ( dbfTmp )->nBnfSbr3 := ( D():Articulos( nView ) )->nBnfSbr3
                     ( dbfTmp )->nBnfSbr4 := ( D():Articulos( nView ) )->nBnfSbr4
                     ( dbfTmp )->nBnfSbr5 := ( D():Articulos( nView ) )->nBnfSbr5
                     ( dbfTmp )->nBnfSbr6 := ( D():Articulos( nView ) )->nBnfSbr6

                     ( dbfTmp )->nPvpLin1 := ( D():Articulos( nView ) )->pVenta1
                     ( dbfTmp )->nPvpLin2 := ( D():Articulos( nView ) )->pVenta2
                     ( dbfTmp )->nPvpLin3 := ( D():Articulos( nView ) )->pVenta3
                     ( dbfTmp )->nPvpLin4 := ( D():Articulos( nView ) )->pVenta4
                     ( dbfTmp )->nPvpLin5 := ( D():Articulos( nView ) )->pVenta5
                     ( dbfTmp )->nPvpLin6 := ( D():Articulos( nView ) )->pVenta6

                     ( dbfTmp )->nIvaLin1 := ( D():Articulos( nView ) )->pVtaIva1
                     ( dbfTmp )->nIvaLin2 := ( D():Articulos( nView ) )->pVtaIva2
                     ( dbfTmp )->nIvaLin3 := ( D():Articulos( nView ) )->pVtaIva3
                     ( dbfTmp )->nIvaLin4 := ( D():Articulos( nView ) )->pVtaIva4
                     ( dbfTmp )->nIvaLin5 := ( D():Articulos( nView ) )->pVtaIva5
                     ( dbfTmp )->nIvaLin6 := ( D():Articulos( nView ) )->pVtaIva6

                     ( dbfTmp )->lNumSer  := ( D():Articulos( nView ) )->lNumSer
                     ( dbfTmp )->lAutSer  := ( D():Articulos( nView ) )->lAutSer

                     if ( ( dbfTmp )->lNumSer )

                        if ( ( dbfTmp )->lAutSer )

                              AutoNumerosSerie( dbfTmp, nMode )

                        elseif !( dbfTmpSer )->( dbSeek( Str( ( dbfTmp )->nNumLin, 4 ) + ( dbfTmp )->cRef ) )

                           msgStop( "Tiene que introducir números de serie para el artículo: " + (dbfTmp)->cDetalle )

                           EditarNumerosSerie( dbfTmp, nMode )

                        end if

                     end if

                  end if

                  if lActCos()
                     ( dbfTmp )->lChgLin     := .t.
                  end if

               end if

               ( D():PedidosProveedoresLineas( nView ) )->( dbSkip() )

            end while

            ( dbfTmp )->( dbGoTop() )

            oBrw:Refresh()

         end if

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

   nTotAlbPrv( nil, D():AlbaranesProveedores( nView ), dbfTmp, D():TiposIva( nView ), D():Divisas( nView ), aTmp )

RETURN lValid

//---------------------------------------------------------------------------//

/*
Calcula totales en las lineas de Detalle
*/

Static FUNCTION lCalcDeta( aTmp, aTmpAlb, aGet, oTotal )

   oTotal:cText( nTotLAlbPrv( aTmp, nDinDiv, nDirDiv ) )

   /*
   Situacion posterior---------------------------------------------------------
   */

   aGet[ _NPRECOM ]:cText( nNetUAlbPrv( aTmp, aTmpAlb, nDinDiv, nDirDiv ) )
  
   if aTmp[ _LBNFLIN1 ]
      aGet[ _NBNFLIN1 ]:lValid()
   else
      aGet[ _NIVALIN1 ]:lValid()
      aGet[ _NPVPLIN1 ]:lValid()
   end if

   if aTmp[ _LBNFLIN2 ]
      aGet[ _NBNFLIN2 ]:lValid()
   else
      aGet[ _NIVALIN2 ]:lValid()
      aGet[ _NPVPLIN2 ]:lValid()
   end if

   if aTmp[ _LBNFLIN3 ]
      aGet[ _NBNFLIN3 ]:lValid()
   else
      aGet[ _NIVALIN3 ]:lValid()
      aGet[ _NPVPLIN3 ]:lValid()
   end if

   if aTmp[ _LBNFLIN4 ]
      aGet[ _NBNFLIN4 ]:lValid()
   else
      aGet[ _NIVALIN4 ]:lValid()
      aGet[ _NPVPLIN4 ]:lValid()
   end if

   if aTmp[ _LBNFLIN5 ]
      aGet[ _NBNFLIN5 ]:lValid()
   else
      aGet[ _NIVALIN5 ]:lValid()
      aGet[ _NPVPLIN5 ]:lValid()
   end if

   if aTmp[ _LBNFLIN6 ]
      aGet[ _NBNFLIN6 ]:lValid()
   else
      aGet[ _NIVALIN6 ]:lValid()
      aGet[ _NPVPLIN6 ]:lValid()
   end if

   if lActCos()
      aGet[ _LCHGLIN ]:Click( aTmp[ _NPREDIV ] != 0 )
   end if

RETURN .t.

//---------------------------------------------------------------------------//

STATIC FUNCTION BeginTrans( aTmp, nMode )

   local oBlock
   local lErrors     := .f.
   local cDbf        := "AProL"
   local cDbfInc     := "AProI"
   local cDbfDoc     := "AProD"
   local cDbfSer     := "AProS"
   local hDuplicate  := {=>}
   local nAlbaran    := aTmp[ _CSERALB ] + Str( aTmp[ _NNUMALB ] ) + aTmp[ _CSUFALB ]

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      TComercio:resetProductsToUpdateStocks()

      CursorWait()

      if nMode == DUPL_MODE
         hDuplicate  := { "cSerAlb" => Space(1), "nNumAlb" => 0, "lFacturado" => .f., "cNumFac" => "" }
      end if 

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

         ( dbfTmp )->( OrdCondSet( "!Deleted()", {||!Deleted() } ) )
         ( dbfTmp )->( OrdCreate( cNewFile, "nPosPrint", "Str( nPosPrint, 4 )", {|| Str( Field->nPosPrint ) } ) )

      end if

      /*
      Añadimos desde el fichero de lineas
      */

      oLinDetCamposExtra:initArrayValue()

      if ( D():AlbaranesProveedoresLineas( nView ) )->( dbSeek( nAlbaran ) )
         while ( ( D():AlbaranesProveedoresLineas( nView ) )->cSerAlb + Str( ( D():AlbaranesProveedoresLineas( nView ) )->nNumAlb ) + ( D():AlbaranesProveedoresLineas( nView ) )->cSufAlb == nAlbaran .AND. !( D():AlbaranesProveedoresLineas( nView ) )->( eof() ) )
            appendRegisterByHash( D():AlbaranesProveedoresLineas( nView ), dbfTmp, hDuplicate ) 
            oLinDetCamposExtra:SetTemporalLines( ( dbfTmp )->cSerAlb + str( ( dbfTmp )->nNumAlb ) + ( dbfTmp )->cSufAlb + str( ( dbfTmp )->nNumLin ), ( dbfTmp )->( OrdKeyNo() ), nMode )
            ( D():AlbaranesProveedoresLineas( nView ) )->( DbSkip() )
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

      if ( nMode != DUPL_MODE ) .and. ( D():AlbaranesProveedoresIncidencias( nView ) )->( dbSeek( nAlbaran ) )
         while ( ( D():AlbaranesProveedoresIncidencias( nView ) )->cSerAlb + Str( ( D():AlbaranesProveedoresIncidencias( nView ) )->nNumAlb ) + ( D():AlbaranesProveedoresIncidencias( nView ) )->cSufAlb == nAlbaran ) .AND. ( D():AlbaranesProveedoresIncidencias( nView ) )->( !eof() )
            dbPass( D():AlbaranesProveedoresIncidencias( nView ), dbfTmpInc, .t. )
            ( D():AlbaranesProveedoresIncidencias( nView ) )->( dbSkip() )
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

      if ( nMode != DUPL_MODE ) .and. ( D():AlbaranesProveedoresDocumentos( nView ) )->( dbSeek( nAlbaran ) )
         while ( ( D():AlbaranesProveedoresDocumentos( nView ) )->cSerAlb + Str( ( D():AlbaranesProveedoresDocumentos( nView ) )->nNumAlb ) + ( D():AlbaranesProveedoresDocumentos( nView ) )->cSufAlb == nAlbaran ) .AND. ( D():AlbaranesProveedoresDocumentos( nView ) )->( !eof() )
            dbPass( D():AlbaranesProveedoresDocumentos( nView ), dbfTmpDoc, .t. )
            ( D():AlbaranesProveedoresDocumentos( nView ) )->( dbSkip() )
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

      if ( nMode != DUPL_MODE ) .and. ( D():AlbaranesProveedoresSeries( nView ) )->( dbSeek( nAlbaran ) )
         do while ( ( D():AlbaranesProveedoresSeries( nView ) )->cSerAlb + Str( ( D():AlbaranesProveedoresSeries( nView ) )->nNumAlb ) + ( D():AlbaranesProveedoresSeries( nView ) )->cSufAlb == nAlbaran )
            dbPass( D():AlbaranesProveedoresSeries( nView ), dbfTmpSer, .t. )
            ( D():AlbaranesProveedoresSeries( nView ) )->( dbSkip() )
         end while
      end if

      ( dbfTmpSer )->( dbGoTop() )

      /*
      Cargamos los temporales de los campos extra---------------------------------
      */

      oDetCamposExtra:SetTemporal( aTmp[ _CSERALB ] + Str( aTmp[ _NNUMALB ] ) + aTmp[ _CSUFALB ], "", nMode )

      CursorWE()

   RECOVER

      msgStop( "Imposible crear tablas temporales." )

      KillTrans()

      lErrors     := .t.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lErrors )

//---------------------------------------------------------------------------//

STATIC FUNCTION EndTrans( aTmp, aGet, nDec, nRec, oBrw, nMode, oDlg )

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

   if !lValidaOperacion( aTmp[ _DFECALB ] )
      RETURN .f.
   end if

   /*
   Estos campos no pueden estar vacios
   */

   if Empty( aTmp[ _CCODPRV ] )
      msgStop( "Código de proveedor no puede estar vacío." )
      aGet[ _CCODPRV ]:SetFocus()
      RETURN .f.
   end if

   if Empty( aTmp[ _CCODCAJ ] )
      msgStop( "Caja no puede estar vacía." )
      aGet[ _CCODCAJ ]:SetFocus()
      RETURN .f.
   end if

   if Empty( aTmp[ _CCODALM ] )
      msgStop( "Almacén no puede estar vacío." )
      aGet[ _CCODALM ]:SetFocus()
      RETURN .f.
   end if

   if ( aTmp[ _CCODALM ] == aTmp[ _CALMORIGEN ] )
      msgStop( "Almacén origen debe ser distinto al almacén destino" )
      aGet[ _CALMORIGEN ]:SetFocus()
      RETURN .f.
   end if

   if ( dbfTmp )->( eof() )
      MsgStop( "No puede almacenar un documento sin líneas." )
      RETURN .f.
   end if

   // Paramos las pantallas----------------------------------------------------

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
      case isAppendOrDuplicateMode( nMode )

         nNumAlb           := nNewDoc( cSerAlb, D():AlbaranesProveedores( nView ), "nAlbPrv", , D():Contadores( nView ) )
         aTmp[ _NNUMALB ]  := nNumAlb
         cSufAlb           := retSufEmp()      
         aTmp[ _CSUFALB ]  := cSufAlb

      case isEditMode( nMode )

         /*
         Resetea los pedidos de proveedores------------------------------------
         */

         while ( D():AlbaranesProveedoresLineas( nView ) )->( dbSeek( cSerAlb + Str( nNumAlb ) + cSufAlb ) ) .and. !( D():AlbaranesProveedoresLineas( nView ) )->( eof() )
            
            TComercio:appendProductsToUpadateStocks( ( D():AlbaranesProveedoresLineas( nView ) )->cRef, nView )

            if dbLock( D():AlbaranesProveedoresLineas( nView ) )
               ( D():AlbaranesProveedoresLineas( nView ) )->( dbDelete() )
               ( D():AlbaranesProveedoresLineas( nView ) )->( dbUnLock() )
            end if

         end while

         while ( D():AlbaranesProveedoresIncidencias( nView ) )->( dbSeek( cSerAlb + Str( nNumAlb ) + cSufAlb ) ) .and. !( D():AlbaranesProveedoresIncidencias( nView ) )->( eof() )
            if dbLock( D():AlbaranesProveedoresIncidencias( nView ) )
               ( D():AlbaranesProveedoresIncidencias( nView ) )->( dbDelete() )
               ( D():AlbaranesProveedoresIncidencias( nView ) )->( dbUnLock() )
            end if
         end while

         while ( D():AlbaranesProveedoresDocumentos( nView ) )->( dbSeek( cSerAlb + Str( nNumAlb ) + cSufAlb ) ) .and. !( D():AlbaranesProveedoresDocumentos( nView ) )->( eof() )
            if dbLock( D():AlbaranesProveedoresDocumentos( nView ) )
               ( D():AlbaranesProveedoresDocumentos( nView ) )->( dbDelete() )
               ( D():AlbaranesProveedoresDocumentos( nView ) )->( dbUnLock() )
            end if
         end while

         while ( D():AlbaranesProveedoresSeries( nView ) )->( dbSeek( cSerAlb + Str( nNumAlb ) + cSufAlb ) ) .and. !( D():AlbaranesProveedoresSeries( nView ) )->( eof() )
            if dbLock( D():AlbaranesProveedoresSeries( nView ) )
               ( D():AlbaranesProveedoresSeries( nView ) )->( dbDelete() )
               ( D():AlbaranesProveedoresSeries( nView ) )->( dbUnLock() )
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

         aTbl                 := dbScatter( dbfTmp )
         aTbl[ _CSERALB ]     := cSerAlb
         aTbl[ _NNUMALB ]     := nNumAlb
         aTbl[ _CSUFALB ]     := cSufAlb
         aTbl[ _LCHGLIN ]     := .f.
         aTbl[ _NPRECOM ]     := nNetUAlbPrv( aTbl, aTmp, nDinDiv, nDirDiv, aTmp[ _NVDVALB ] )
         aTbl[ __DFECALB]     := aTmp[ _DFECALB ]
         aTbl[ __TFECALB]     := aTmp[ _TFECALB ]

         AppendReferenciaProveedor( aTbl[ _CREFPRV ], aTmp[ _CCODPRV ], aTbl[ _CREF ], aTbl[ _NDTOLIN ], aTbl[ _NDTOPRM ], aTmp[ _CDIVALB ], aTbl[ _NPREDIV ], D():ProveedorArticulo( nView ), nMode )

         AppendPropiedadesArticulos( aTbl, aTmp )

         /*
         Cambios de precios-------------------------------------------------------
         */

         if ( D():Articulos( nView ) )->( dbSeek( ( dbfTmp )->cRef ) ) .and. ( dbfTmp )->lChgLin
            CambioPrecio( aTmp[ _DFECALB ], D():Articulos( nView ), dbfTmp )
         end if

         /*
         Grabamos-----------------------------------------------------------------
         */

         dbGather( aTbl, D():AlbaranesProveedoresLineas( nView ), .t. )

         oLinDetCamposExtra:saveExtraField( cSerAlb + Str( nNumAlb ) + cSufAlb + Str( ( dbfTmp )->nNumLin ), ( dbfTmp )->( OrdKeyNo() ) )

         TComercio:appendProductsToUpadateStocks( (dbfTmp)->cRef, nView )

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
      Guardamos los campos extra-----------------------------------------------
      */

      oDetCamposExtra:saveExtraField( aTmp[ _CSERALB ] + Str( aTmp[ _NNUMALB ] ) + aTmp[ _CSUFALB ], "" )

      /*
      Grabamos las cabeceras de los albaranes----------------------------------
      */

      WinGather( aTmp, , D():AlbaranesProveedores( nView ), , nMode )

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
         dbPass( dbfTmpInc, D():AlbaranesProveedoresIncidencias( nView ), .t., cSerAlb, nNumAlb, cSufAlb )
         ( dbfTmpInc )->( dbSkip() )
      end while

      /*
      Escribimos el fichero definitivo de documentos
      */

      ( dbfTmpDoc )->( dbGoTop() )
      while ( dbfTmpDoc )->( !eof() )
         dbPass( dbfTmpDoc, D():AlbaranesProveedoresDocumentos( nView ), .t., cSerAlb, nNumAlb, cSufAlb )
         ( dbfTmpDoc )->( dbSkip() )
      end while

      /*
      Escribimos el fichero definitivo de series
      */

      ( dbfTmpSer )->( dbGoTop() )
      while ( dbfTmpSer )->( !eof() )
         dbPass( dbfTmpSer, D():AlbaranesProveedoresSeries( nView ), .t., cSerAlb, nNumAlb, cSufAlb, dFecAlb )
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

            if dbSeekInOrd( aNumPed[ 3 ], "nNumPed", D():PedidosProveedores( nView ) )

               if dbLock( D():PedidosProveedores( nView ) )
                  ( D():PedidosProveedores( nView ) )->cNumAlb    := cSerAlb + Str( nNumAlb ) + cSufAlb
                  ( D():PedidosProveedores( nView ) )->( dbUnLock() )
               end if

            end if

         next

      end if

      // Escribe los datos pendientes---------------------------------------------

      CommitTransaction()

   RECOVER USING oError

      RollBackTransaction()

      msgStop( "Imposible guardar el documento" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   oMsgText()
   endProgress()

   // actualiza el stock de prestashop-----------------------------------------

   TComercio:updateWebProductStocks()

   oDlg:Enable()
   oDlg:End( IDOK )

   CursorWE()

RETURN .t.

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

   if !lExistTable( cPath + "ALBPROVT.DBF", cLocalDriver() )
      dbCreate( cPath + "ALBPROVT.DBF", aSqlStruct( aItmAlbPrv() ), cLocalDriver() )
   end if

   if !lExistTable( cPath + "ALBPROVL.DBF", cLocalDriver() )
      dbCreate( cPath + "ALBPROVL.DBF", aSqlStruct( aColAlbPrv() ), cLocalDriver() )
   end if

   if !lExistTable( cPath + "ALBPRVI.DBF", cLocalDriver() )
      dbCreate( cPath + "ALBPRVI.DBF", aSqlStruct( aIncAlbPrv() ), cLocalDriver() )
   end if

   if !lExistTable( cPath + "ALBPRVD.DBF", cLocalDriver() )
      dbCreate( cPath + "ALBPRVD.DBF", aSqlStruct( aAlbPrvDoc() ), cLocalDriver() )
   end if

   if !lExistTable( cPath + "ALBPRVS.DBF", cLocalDriver() )
      dbCreate( cPath + "ALBPRVS.DBF", aSqlStruct( aSerAlbPrv() ), cLocalDriver() )
   end if

RETURN NIL

//-------------------------------------------------------------------------//
/*
Cambia el estado de un albaran
*/

STATIC FUNCTION ChgState( oBrw )

   if dbDialogLock( D():AlbaranesProveedores( nView ) )

      ( D():AlbaranesProveedores( nView ) )->lFacturado := !( D():AlbaranesProveedores( nView ) )->lFacturado
      ( D():AlbaranesProveedores( nView ) )->cNumFac    := Space( 12 )
      ( D():AlbaranesProveedores( nView ) )->( dbUnlock() )

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

static FUNCTION lNotOpen()

   if NetErr()
      MsgStop( 'Imposible abrir ficheros de albaranes de proveedores' )
      CloseFiles()
      RETURN .t.
   end if

RETURN .f.

//---------------------------------------------------------------------------//

static FUNCTION lGenAlb( oBrw, oBtn, nDevice )

   local bAction

   DEFAULT nDevice   := IS_PRINTER

   if Empty( oBtn )
      RETURN nil
   end if

   if !( D():Documentos( nView ) )->( dbSeek( "AP" ) )

         DEFINE BTNSHELL RESOURCE "gc_document_white_" OF oWndBrw ;
            NOBORDER ;
            ACTION   ( msgStop( "No hay albaranes de proveedores predefinidos" ) );
            TOOLTIP  "No hay documentos" ;
            HOTKEY   "N";
            FROM     oBtn ;
            CLOSED ;
            LEVEL    ACC_EDIT

   else

      while ( D():Documentos( nView ) )->cTipo == "AP" .and. !( D():Documentos( nView ) )->( eof() )

         bAction  := bGenAlb( nDevice, "Imprimiendo albaranes de proveedores", ( D():Documentos( nView ) )->Codigo )

         oWndBrw:NewAt( "gc_document_white_", , , bAction, Rtrim( ( D():Documentos( nView ) )->cDescrip ) , , , , , oBtn )

         ( D():Documentos( nView ) )->( dbSkip() )

      end do

   end if

   SysRefresh()

RETURN nil

//---------------------------------------------------------------------------//

static FUNCTION nCanEnt()

RETURN ( If( ( D():AlbaranesProveedoresLineas( nView ) )->NCANENT != 0, ( D():AlbaranesProveedoresLineas( nView ) )->NCANENT, 1 ) * ( D():AlbaranesProveedoresLineas( nView ) )->NUNICAJA )

//---------------------------------------------------------------------------//

static FUNCTION nTotUnd( uDbf )

   local nTotUnd

   if ValType( uDbf ) == "A"
      nTotUnd  := NotCaja( uDbf[ _NCANENT ] ) * uDbf[ _NUNICAJA ]
   else
      nTotUnd  := NotCaja( ( uDbf )->NCANENT ) * ( uDbf )->NUNICAJA
   end if

RETURN ( nTotUnd )

//---------------------------------------------------------------------------//
/*
Borra todas las lineas de detalle de un Albarán
*/

Static FUNCTION QuiAlbPrv( lDetail )

   local cNumPed
   local nRecAnt
   local nOrdAnt
   local nRecPed
   local nOrdPed
   local aNumPedCli  := {}
   local cNumPedPrv  := ( D():AlbaranesProveedores( nView ) )->cNumPed

   DEFAULT lDetail   := .t.

   if ( D():AlbaranesProveedores( nView ) )->lCloAlb .and. !oUser():lAdministrador()
      msgStop( "Solo puede eliminar albaranes cerrados los administradores." )
      RETURN .f.
   end if

   CursorWait()

   nRecAnt           := ( D():AlbaranesProveedoresLineas( nView ) )->( Recno() )
   nOrdAnt           := ( D():AlbaranesProveedoresLineas( nView ) )->( OrdSetFocus( "nNumAlb" ) )

   if ( D():AlbaranesProveedoresLineas( nView ) )->( dbSeek( ( D():AlbaranesProveedores( nView ) )->cSerAlb + Str( ( D():AlbaranesProveedores( nView ) )->nNumAlb ) + ( D():AlbaranesProveedores( nView ) )->cSufAlb ) )

      while ( D():AlbaranesProveedores( nView ) )->cSerAlb + Str( ( D():AlbaranesProveedores( nView ) )->nNumAlb ) + ( D():AlbaranesProveedores( nView ) )->cSufAlb == ( D():AlbaranesProveedoresLineas( nView ) )->cSerAlb + Str( ( D():AlbaranesProveedoresLineas( nView ) )->nNumAlb ) + ( D():AlbaranesProveedoresLineas( nView ) )->cSufAlb .and. ;
            !( D():AlbaranesProveedoresLineas( nView ) )->( Eof() )

         if aScan( aNumPedCli, ( D():AlbaranesProveedoresLineas( nView ) )->cNumPed ) == 0
            aAdd( aNumPedCli, ( D():AlbaranesProveedoresLineas( nView ) )->cNumPed )
         end if

         ( D():AlbaranesProveedoresLineas( nView ) )->( dbSkip() )

      end while

   end if

   ( D():AlbaranesProveedoresLineas( nView ) )->( OrdSetFocus( nOrdAnt ) )
   ( D():AlbaranesProveedoresLineas( nView ) )->( dbGoTo( nRecAnt ) )

   /*
   Detalle---------------------------------------------------------------------
   */

   TComercio:resetProductsToUpdateStocks()

   while ( D():AlbaranesProveedoresLineas( nView ) )->( dbSeek( ( D():AlbaranesProveedores( nView ) )->cSerAlb + Str( ( D():AlbaranesProveedores( nView ) )->nNumAlb ) + ( D():AlbaranesProveedores( nView ) )->cSufAlb ) ) .and. !( D():AlbaranesProveedoresLineas( nView ) )->( eof() )

      TComercio:appendProductsToUpadateStocks( ( D():AlbaranesProveedoresLineas( nView ) )->cRef, nView )

      if dbLock( D():AlbaranesProveedoresLineas( nView ) )
         ( D():AlbaranesProveedoresLineas( nView ) )->( dbDelete() )
         ( D():AlbaranesProveedoresLineas( nView ) )->( dbUnLock() )
      end if

   end while

   /*
   Incidencias-----------------------------------------------------------------
   */

   while ( D():AlbaranesProveedoresIncidencias( nView ) )->( dbSeek( ( D():AlbaranesProveedores( nView ) )->cSerAlb + Str( ( D():AlbaranesProveedores( nView ) )->nNumAlb ) + ( D():AlbaranesProveedores( nView ) )->cSufAlb ) ) .and. !( D():AlbaranesProveedoresIncidencias( nView ) )->( eof() )

      if dbLock( D():AlbaranesProveedoresIncidencias( nView ) )
         ( D():AlbaranesProveedoresIncidencias( nView ) )->( dbDelete() )
         ( D():AlbaranesProveedoresIncidencias( nView ) )->( dbUnLock() )
      end if

   end while

   /*
   Documentos------------------------------------------------------------------
   */

   while ( D():AlbaranesProveedoresDocumentos( nView ) )->( dbSeek( ( D():AlbaranesProveedores( nView ) )->cSerAlb + Str( ( D():AlbaranesProveedores( nView ) )->nNumAlb ) + ( D():AlbaranesProveedores( nView ) )->cSufAlb ) ) .and. !( D():AlbaranesProveedoresDocumentos( nView ) )->( eof() )

      if dbLock( D():AlbaranesProveedoresDocumentos( nView ) )
         ( D():AlbaranesProveedoresDocumentos( nView ) )->( dbDelete() )
         ( D():AlbaranesProveedoresDocumentos( nView ) )->( dbUnLock() )
      end if

   end while

   /*
   Numeros de serie------------------------------------------------------------
   */

   while ( D():AlbaranesProveedoresSeries( nView ) )->( dbSeek( ( D():AlbaranesProveedores( nView ) )->cSerAlb + Str( ( D():AlbaranesProveedores( nView ) )->nNumAlb ) + ( D():AlbaranesProveedores( nView ) )->cSufAlb ) ) .and. !( D():AlbaranesProveedoresSeries( nView ) )->( eof() )

      if dbLock( D():AlbaranesProveedoresSeries( nView ) )
         ( D():AlbaranesProveedoresSeries( nView ) )->( dbDelete() )
         ( D():AlbaranesProveedoresSeries( nView ) )->( dbUnLock() )
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

   nRecPed  := ( D():PedidosProveedores( nView ) )->( RecNo() )
   nOrdPed  := ( D():PedidosProveedores( nView ) )->( OrdSetFocus( "cNumAlb" ) )

   if ( D():PedidosProveedores( nView ) )->( dbSeek( ( D():AlbaranesProveedores( nView ) )->cSerAlb + Str( ( D():AlbaranesProveedores( nView ) )->nNumAlb ) + ( D():AlbaranesProveedores( nView ) )->cSufAlb ) )

      while ( D():PedidosProveedores( nView ) )->cNumAlb == ( D():AlbaranesProveedores( nView ) )->cSerAlb + Str( ( D():AlbaranesProveedores( nView ) )->nNumAlb ) + ( D():AlbaranesProveedores( nView ) )->cSufAlb .and. !( D():PedidosProveedores( nView ) )->( Eof() )

         if dbLock( D():PedidosProveedores( nView ) )
            ( D():PedidosProveedores( nView ) )->cNumAlb    := ""
            ( D():PedidosProveedores( nView ) )->nEstado    := 1
            ( D():PedidosProveedores( nView ) )->( dbUnLock() )
         end if

         ( D():PedidosProveedores( nView ) )->( dbSkip() )

      end while

   end if

   ( D():PedidosProveedores( nView ) )->( OrdSetFocus( nOrdPed ) )
   ( D():PedidosProveedores( nView ) )->( dbGoTo( nRecPed ) )

   // actualiza el stock de prestashop-----------------------------------------

   TComercio:updateWebProductStocks()

   CursorWE()

RETURN .t.

//--------------------------------------------------------------------------//

STATIC FUNCTION nClrText( dbfTmp )

   local cClr

   if ( dbfTmp )->lKitChl
      cClr     := CLR_GRAY
   else
      cClr     := CLR_BLACK
   end if

RETURN cClr

//----------------------------------------------------------------------------//

STATIC FUNCTION GrpPed( aGet, aTmp, oBrw, nMode )

   local a
   local oDlg
   local nDiv
   local nOrdAnt
   local oBrwLin
   local nNumLin
   local nPosPrint
   local nTotPed
   local nTotRec
   local nTotPdt
   local nItem       := 1
   local nOffSet     := 0
   local cDesAlb     := ""
   local cCodPrv     := aGet[ _CCODPRV ]:varGet()

   aNumAlb           := {}
   aAlbaranes        := {}

   //Comprueba si hay proveedor seleccionado

   if Empty( cCodPrv )
      msgStop( "Es necesario codificar un proveedor", "Agrupar pedidos" )
      RETURN .t.
   end if

   //Captura en una array los pedidos del proveedor seleccionado
   //Ordena la base de datos de pedidos de proveedores por el codigo de proveedor

   nOrdAnt           := ( D():PedidosProveedores( nView ) )->( ordSetFocus( "CCODPRV" ) )

   //si hay registros los mete en una array

   if !( D():PedidosProveedores( nView ) )->( dbSeek( cCodPrv ) )
       msgStop( "No existen pedidos de este proveedor" )
      RETURN .T.
   else

      do while ( D():PedidosProveedores( nView ) )->cCodPrv == cCodPrv .AND. ( D():PedidosProveedores( nView ) )->( !eof() )

         if ( D():PedidosProveedores( nView ) )->nEstado != 3

            aAdd( aAlbaranes, {  .f. ,;
                                 ( if( ( D():PedidosProveedores( nView ) )->nEstado <= 1, 3, ( D():PedidosProveedores( nView ) )->nEstado ) ),;
                                 ( D():PedidosProveedores( nView ) )->cSerPed + Str( ( D():PedidosProveedores( nView ) )->nNumPed ) + ( D():PedidosProveedores( nView ) )->cSufPed,;
                                 ( D():PedidosProveedores( nView ) )->dFecPed ,;
                                 ( D():PedidosProveedores( nView ) )->cCodPrv ,;
                                 ( D():PedidosProveedores( nView ) )->cNomPrv ,;
                                 ( D():PedidosProveedores( nView ) )->cNumPedCli } )

         endif

         ( D():PedidosProveedores( nView ) )->( dbSkip( 1 ) )

      end do

   end if

   if Len( aAlbaranes ) == 0
      msgStop( "No existen pedidos de este proveedor" )
      RETURN .t.
   end if

   //Ordena la base de datos de pedidos de proveedores por el codigo de proveedor

   ( D():PedidosProveedores( nView ) )->( ordSetFocus( nOrdAnt ) )

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
         :AddResource( "gc_delete_12" )
         :AddResource( "gc_shape_square_12" )
         :AddResource( "gc_check_12" )
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

      for nItem := 1 TO Len( aAlbaranes )

         //Cabeceras de pedidos a albaranes

         IF ( D():PedidosProveedores( nView ) )->( dbSeek( aAlbaranes[ nItem, 3] ) ) .AND. aAlbaranes[ nItem, 1]

            if ( D():PedidosProveedores( nView ) )->lRecargo
               aTmp[ _LRECARGO ] := .t.
               aGet[ _LRECARGO ]:Refresh()
            end if

         END IF

         //Detalle de pedidos a albaranes

         IF ( D():PedidosProveedoresLineas( nView ) )->( dbSeek( aAlbaranes[ nItem, 3] ) ) .AND. aAlbaranes[ nItem, 1]

            //Cabeceras de pedidos

            ++nOffSet
            nNumLin              := nil
            nPosPrint            := nil

            if lNumPed()
            (dbfTmp)->( dbAppend() )
            cDesAlb              := "Pedido Nº " + Alltrim( Trans( aAlbaranes[ nItem, 3 ], "@R #/999999999/##" ) )
            cDesAlb              += " - Fecha " + Dtoc( aAlbaranes[ nItem, 4] )
            (dbfTmp)->mLngDes    := cDesAlb
            (dbfTmp)->lControl   := .t.
            (dbfTmp)->nNumLin    := nOffSet
            (dbfTmp)->nPosPrint  := nOffSet
            end if

            //Mientras estemos en el mismo pedido pasamos los datos al albarán

            WHILE ( ( D():PedidosProveedoresLineas( nView ) )->cSerPed + Str( ( D():PedidosProveedoresLineas( nView ) )->nNumPed ) + ( D():PedidosProveedoresLineas( nView ) )->cSufPed == aAlbaranes[ nItem, 3 ] )

               if aAlbaranes[ nItem, 2 ] == 2

                  nTotPed              := nTotNPedPrv( D():PedidosProveedoresLineas( nView ) )
                  nTotRec              := nUnidadesRecibidasPedPrv( aAlbaranes[ nItem, 3 ], ( D():PedidosProveedoresLineas( nView ) )->cRef, ( D():PedidosProveedoresLineas( nView ) )->cValPr1, ( D():PedidosProveedoresLineas( nView ) )->cValPr2, ( D():PedidosProveedoresLineas( nView ) )->cRefPrv, D():AlbaranesProveedoresLineas( nView ) )
                  nTotPdt              := nTotPed - nTotRec

                  if nTotPdt > 0

                     if nNumLin != (D():PedidosProveedoresLineas( nView ))->nNumLin
                        ++nOffSet
                        nNumLin           := (D():PedidosProveedoresLineas( nView ))->nNumLin
                     end if

                     (dbfTmp)->( dbAppend() )
                     (dbfTmp)->nNumAlb    := 0
                     (dbfTmp)->nNumLin    := nOffSet
                     (dbfTmp)->nPosPrint  := nOffSet
                     (dbfTmp)->cRef       := ( D():PedidosProveedoresLineas( nView ) )->cRef
                     (dbfTmp)->cRefPrv    := ( D():PedidosProveedoresLineas( nView ) )->cRefPrv
                     (dbfTmp)->cDetalle   := ( D():PedidosProveedoresLineas( nView ) )->cDetalle
                     (dbfTmp)->mLngDes    := ( D():PedidosProveedoresLineas( nView ) )->mLngDes
                     (dbfTmp)->nPreDiv    := ( D():PedidosProveedoresLineas( nView ) )->nPreDiv
                     (dbfTmp)->cUnidad    := ( D():PedidosProveedoresLineas( nView ) )->cUnidad
                     (dbfTmp)->nIva       := ( D():PedidosProveedoresLineas( nView ) )->nIva
                     (dbfTmp)->nReq       := ( D():PedidosProveedoresLineas( nView ) )->nReq
                     (dbfTmp)->nDtoLin    := ( D():PedidosProveedoresLineas( nView ) )->nDtoLin
                     (dbfTmp)->nDtoPrm    := ( D():PedidosProveedoresLineas( nView ) )->nDtoPrm
                     (dbfTmp)->nUndKit    := ( D():PedidosProveedoresLineas( nView ) )->nUndKit
                     (dbfTmp)->lKitArt    := ( D():PedidosProveedoresLineas( nView ) )->lKitArt
                     (dbfTmp)->lKitChl    := ( D():PedidosProveedoresLineas( nView ) )->lKitChl
                     (dbfTmp)->lKitPrc    := ( D():PedidosProveedoresLineas( nView ) )->lKitPrc
                     (dbfTmp)->lImpLin    := ( D():PedidosProveedoresLineas( nView ) )->lImpLin
                     (dbfTmp)->cCodPr1    := ( D():PedidosProveedoresLineas( nView ) )->cCodPr1
                     (dbfTmp)->cCodPr2    := ( D():PedidosProveedoresLineas( nView ) )->cCodPr2
                     (dbfTmp)->cValPr1    := ( D():PedidosProveedoresLineas( nView ) )->cValPr1
                     (dbfTmp)->cValPr2    := ( D():PedidosProveedoresLineas( nView ) )->cValPr2
                     (dbfTmp)->nCanPed    := ( D():PedidosProveedoresLineas( nView ) )->nCanPed
                     (dbfTmp)->nDtoRap    := ( D():PedidosProveedoresLineas( nView ) )->nDtoRap
                     (dbfTmp)->mNumSer    := ( D():PedidosProveedoresLineas( nView ) )->mNumSer
                     (dbfTmp)->lLote      := ( D():PedidosProveedoresLineas( nView ) )->lLote
                     (dbfTmp)->nLote      := ( D():PedidosProveedoresLineas( nView ) )->nLote
                     (dbfTmp)->cLote      := ( D():PedidosProveedoresLineas( nView ) )->cLote
                     (dbfTmp)->nFacCnv    := ( D():PedidosProveedoresLineas( nView ) )->nFacCnv
                     (dbfTmp)->cAlmLin    := ( D():PedidosProveedoresLineas( nView ) )->cAlmLin
                     (dbfTmp)->nCtlStk    := ( D():PedidosProveedoresLineas( nView ) )->nCtlStk
                     (dbfTmp)->lControl   := ( D():PedidosProveedoresLineas( nView ) )->lControl
                     (dbfTmp)->cUnidad    := ( D():PedidosProveedoresLineas( nView ) )->cUnidad
                     (dbfTmp)->nNumMed    := ( D():PedidosProveedoresLineas( nView ) )->nNumMed
                     (dbfTmp)->nMedUno    := ( D():PedidosProveedoresLineas( nView ) )->nMedUno
                     (dbfTmp)->nMedDos    := ( D():PedidosProveedoresLineas( nView ) )->nMedDos
                     (dbfTmp)->nMedTre    := ( D():PedidosProveedoresLineas( nView ) )->nMedTre
                     (dbfTmp)->cCodImp    := ( D():PedidosProveedoresLineas( nView ) )->cCodImp
                     (dbfTmp)->nValImp    := ( D():PedidosProveedoresLineas( nView ) )->nValImp
                     (dbfTmp)->cRefAux    := ( D():PedidosProveedoresLineas( nView ) )->cRefAux
                     (dbfTmp)->cRefAux2   := ( D():PedidosProveedoresLineas( nView ) )->cRefAux2
                     (dbfTmp)->cCtrCoste  := ( D():PedidosProveedoresLineas( nView ) )->cCtrCoste
                     (dbfTmp)->cTipCtr    := ( D():PedidosProveedoresLineas( nView ) )->cTipCtr
                     (dbfTmp)->cTerCtr    := ( D():PedidosProveedoresLineas( nView ) )->cTerCtr

                     (dbfTmp)->cCodPed    := aAlbaranes[ nItem, 3 ]
                     (dbfTmp)->cNumPed    := aAlbaranes[ nItem, 7 ]

                     if dbSeekInOrd( ( D():PedidosProveedoresLineas( nView ) )->cRef, "Codigo", D():Articulos( nView ) )

                        ( dbfTmp )->lIvaLin  := ( D():Articulos( nView ) )->lIvaInc

                        ( dbfTmp )->nBnfLin1 := ( D():Articulos( nView ) )->Benef1
                        ( dbfTmp )->nBnfLin2 := ( D():Articulos( nView ) )->Benef2
                        ( dbfTmp )->nBnfLin3 := ( D():Articulos( nView ) )->Benef3
                        ( dbfTmp )->nBnfLin4 := ( D():Articulos( nView ) )->Benef4
                        ( dbfTmp )->nBnfLin5 := ( D():Articulos( nView ) )->Benef5
                        ( dbfTmp )->nBnfLin6 := ( D():Articulos( nView ) )->Benef6

                        ( dbfTmp )->lBnfLin1 := ( D():Articulos( nView ) )->lBnf1
                        ( dbfTmp )->lBnfLin2 := ( D():Articulos( nView ) )->lBnf2
                        ( dbfTmp )->lBnfLin3 := ( D():Articulos( nView ) )->lBnf3
                        ( dbfTmp )->lBnfLin4 := ( D():Articulos( nView ) )->lBnf4
                        ( dbfTmp )->lBnfLin5 := ( D():Articulos( nView ) )->lBnf5
                        ( dbfTmp )->lBnfLin6 := ( D():Articulos( nView ) )->lBnf6

                        ( dbfTmp )->nBnfSbr1 := ( D():Articulos( nView ) )->nBnfSbr1
                        ( dbfTmp )->nBnfSbr2 := ( D():Articulos( nView ) )->nBnfSbr2
                        ( dbfTmp )->nBnfSbr3 := ( D():Articulos( nView ) )->nBnfSbr3
                        ( dbfTmp )->nBnfSbr4 := ( D():Articulos( nView ) )->nBnfSbr4
                        ( dbfTmp )->nBnfSbr5 := ( D():Articulos( nView ) )->nBnfSbr5
                        ( dbfTmp )->nBnfSbr6 := ( D():Articulos( nView ) )->nBnfSbr6

                        ( dbfTmp )->nPvpLin1 := ( D():Articulos( nView ) )->pVenta1
                        ( dbfTmp )->nPvpLin2 := ( D():Articulos( nView ) )->pVenta2
                        ( dbfTmp )->nPvpLin3 := ( D():Articulos( nView ) )->pVenta3
                        ( dbfTmp )->nPvpLin4 := ( D():Articulos( nView ) )->pVenta4
                        ( dbfTmp )->nPvpLin5 := ( D():Articulos( nView ) )->pVenta5
                        ( dbfTmp )->nPvpLin6 := ( D():Articulos( nView ) )->pVenta6

                        ( dbfTmp )->nIvaLin1 := ( D():Articulos( nView ) )->pVtaIva1
                        ( dbfTmp )->nIvaLin2 := ( D():Articulos( nView ) )->pVtaIva2
                        ( dbfTmp )->nIvaLin3 := ( D():Articulos( nView ) )->pVtaIva3
                        ( dbfTmp )->nIvaLin4 := ( D():Articulos( nView ) )->pVtaIva4
                        ( dbfTmp )->nIvaLin5 := ( D():Articulos( nView ) )->pVtaIva5
                        ( dbfTmp )->nIvaLin6 := ( D():Articulos( nView ) )->pVtaIva6

                        ( dbfTmp )->lNumSer  := ( D():Articulos( nView ) )->lNumSer
                        ( dbfTmp )->lAutSer  := ( D():Articulos( nView ) )->lAutSer

                        if ( ( dbfTmp )->lNumSer )

                           if ( ( dbfTmp )->lAutSer )
   
                              AutoNumerosSerie( dbfTmp, nMode )
   
                           elseif !( dbfTmpSer )->( dbSeek( Str( ( dbfTmp )->nNumLin, 4 ) + ( dbfTmp )->cRef ) )
   
                              msgStop( "Tiene que introducir números de serie para el artículo: " + (dbfTmp)->cDetalle )
   
                              EditarNumerosSerie( dbfTmp, nMode )
   
                           end if
   
                        end if 

                     end if

                     if lCalCaj()

                        if nTotRec != 0

                           nDiv  := Mod( nTotPdt, ( D():PedidosProveedoresLineas( nView ) )->nUniCaja )
                           if nDiv == 0 .and. ( D():PedidosProveedoresLineas( nView ) )->nCanPed != 0
                              ( dbfTmp )->nCanEnt  := Div( nTotPdt, ( D():PedidosProveedoresLineas( nView ) )->nUniCaja )
                              ( dbfTmp )->nUniCaja := ( D():PedidosProveedoresLineas( nView ) )->nUniCaja
                           else
                              ( dbfTmp )->nCanEnt  := 0
                              ( dbfTmp )->nUniCaja := nTotPdt
                           end if

                        else

                           ( dbfTmp )->nCanEnt     := ( D():PedidosProveedoresLineas( nView ) )->nCanPed
                           ( dbfTmp )->nUniCaja    := ( D():PedidosProveedoresLineas( nView ) )->nUniCaja

                        end if

                     else

                        ( dbfTmp )->nUniCaja       := nTotPdt

                     end if

                  end if

               else

                  if nNumLin != ( D():PedidosProveedoresLineas( nView ) )->nNumLin
                     ++nOffSet
                     nNumLin           := ( D():PedidosProveedoresLineas( nView ) )->nNumLin
                  end if

                  (dbfTmp)->( dbAppend() )
                  (dbfTmp)->nNumAlb    := 0
                  (dbfTmp)->nNumLin    := nOffSet
                  (dbfTmp)->nPosPrint  := nOffSet
                  (dbfTmp)->cRef       := ( D():PedidosProveedoresLineas( nView ) )->cRef
                  (dbfTmp)->cRefPrv    := ( D():PedidosProveedoresLineas( nView ) )->cRefPrv
                  (dbfTmp)->cDetalle   := ( D():PedidosProveedoresLineas( nView ) )->cDetalle
                  (dbfTmp)->mLngDes    := ( D():PedidosProveedoresLineas( nView ) )->mLngDes
                  (dbfTmp)->nPreDiv    := ( D():PedidosProveedoresLineas( nView ) )->nPreDiv
                  (dbfTmp)->cUnidad    := ( D():PedidosProveedoresLineas( nView ) )->cUnidad
                  (dbfTmp)->nIva       := ( D():PedidosProveedoresLineas( nView ) )->nIva
                  (dbfTmp)->nReq       := ( D():PedidosProveedoresLineas( nView ) )->nReq
                  (dbfTmp)->nDtoLin    := ( D():PedidosProveedoresLineas( nView ) )->nDtoLin
                  (dbfTmp)->nDtoPrm    := ( D():PedidosProveedoresLineas( nView ) )->nDtoPrm
                  (dbfTmp)->nUniCaja   := ( D():PedidosProveedoresLineas( nView ) )->nUniCaja
                  (dbfTmp)->nCanEnt    := ( D():PedidosProveedoresLineas( nView ) )->nCanEnt
                  (dbfTmp)->nUndKit    := ( D():PedidosProveedoresLineas( nView ) )->nUndKit
                  (dbfTmp)->lKitArt    := ( D():PedidosProveedoresLineas( nView ) )->lKitArt
                  (dbfTmp)->lKitChl    := ( D():PedidosProveedoresLineas( nView ) )->lKitChl
                  (dbfTmp)->lKitPrc    := ( D():PedidosProveedoresLineas( nView ) )->lKitPrc
                  (dbfTmp)->lImpLin    := ( D():PedidosProveedoresLineas( nView ) )->lImpLin
                  (dbfTmp)->cCodPr1    := ( D():PedidosProveedoresLineas( nView ) )->cCodPr1
                  (dbfTmp)->cCodPr2    := ( D():PedidosProveedoresLineas( nView ) )->cCodPr2
                  (dbfTmp)->cValPr1    := ( D():PedidosProveedoresLineas( nView ) )->cValPr1
                  (dbfTmp)->cValPr2    := ( D():PedidosProveedoresLineas( nView ) )->cValPr2
                  (dbfTmp)->nCanPed    := ( D():PedidosProveedoresLineas( nView ) )->nCanPed
                  (dbfTmp)->nDtoRap    := ( D():PedidosProveedoresLineas( nView ) )->nDtoRap
                  (dbfTmp)->mNumSer    := ( D():PedidosProveedoresLineas( nView ) )->mNumSer
                  (dbfTmp)->lLote      := ( D():PedidosProveedoresLineas( nView ) )->lLote
                  (dbfTmp)->nLote      := ( D():PedidosProveedoresLineas( nView ) )->nLote
                  (dbfTmp)->cLote      := ( D():PedidosProveedoresLineas( nView ) )->cLote
                  (dbfTmp)->nFacCnv    := ( D():PedidosProveedoresLineas( nView ) )->nFacCnv
                  (dbfTmp)->cAlmLin    := ( D():PedidosProveedoresLineas( nView ) )->cAlmLin
                  (dbfTmp)->nCtlStk    := ( D():PedidosProveedoresLineas( nView ) )->nCtlStk
                  (dbfTmp)->lControl   := ( D():PedidosProveedoresLineas( nView ) )->lControl
                  (dbfTmp)->mObsLin    := ( D():PedidosProveedoresLineas( nView ) )->mObsLin
                  (dbfTmp)->cUnidad    := ( D():PedidosProveedoresLineas( nView ) )->cUnidad
                  (dbfTmp)->nNumMed    := ( D():PedidosProveedoresLineas( nView ) )->nNumMed
                  (dbfTmp)->nMedUno    := ( D():PedidosProveedoresLineas( nView ) )->nMedUno
                  (dbfTmp)->nMedDos    := ( D():PedidosProveedoresLineas( nView ) )->nMedDos
                  (dbfTmp)->nMedTre    := ( D():PedidosProveedoresLineas( nView ) )->nMedTre
                  (dbfTmp)->cCodImp    := ( D():PedidosProveedoresLineas( nView ) )->cCodImp
                  (dbfTmp)->nValImp    := ( D():PedidosProveedoresLineas( nView ) )->nValImp
                  (dbfTmp)->cRefAux    := ( D():PedidosProveedoresLineas( nView ) )->cRefAux
                  (dbfTmp)->cRefAux2   := ( D():PedidosProveedoresLineas( nView ) )->cRefAux2
                  (dbfTmp)->cCtrCoste  := ( D():PedidosProveedoresLineas( nView ) )->cCtrCoste
                  (dbfTmp)->cTipCtr    := ( D():PedidosProveedoresLineas( nView ) )->cTipCtr
                  (dbfTmp)->cTerCtr    := ( D():PedidosProveedoresLineas( nView ) )->cTerCtr

                  (dbfTmp)->cCodPed    := aAlbaranes[ nItem, 3 ]
                  (dbfTmp)->cNumPed    := aAlbaranes[ nItem, 7 ]

                  if dbSeekInOrd( ( D():PedidosProveedoresLineas( nView ) )->cRef, "Codigo", D():Articulos( nView ) )

                     ( dbfTmp )->lIvaLin  := ( D():Articulos( nView ) )->lIvaInc

                     ( dbfTmp )->nBnfLin1 := ( D():Articulos( nView ) )->Benef1
                     ( dbfTmp )->nBnfLin2 := ( D():Articulos( nView ) )->Benef2
                     ( dbfTmp )->nBnfLin3 := ( D():Articulos( nView ) )->Benef3
                     ( dbfTmp )->nBnfLin4 := ( D():Articulos( nView ) )->Benef4
                     ( dbfTmp )->nBnfLin5 := ( D():Articulos( nView ) )->Benef5
                     ( dbfTmp )->nBnfLin6 := ( D():Articulos( nView ) )->Benef6

                     ( dbfTmp )->lBnfLin1 := ( D():Articulos( nView ) )->lBnf1
                     ( dbfTmp )->lBnfLin2 := ( D():Articulos( nView ) )->lBnf2
                     ( dbfTmp )->lBnfLin3 := ( D():Articulos( nView ) )->lBnf3
                     ( dbfTmp )->lBnfLin4 := ( D():Articulos( nView ) )->lBnf4
                     ( dbfTmp )->lBnfLin5 := ( D():Articulos( nView ) )->lBnf5
                     ( dbfTmp )->lBnfLin6 := ( D():Articulos( nView ) )->lBnf6

                     ( dbfTmp )->nBnfSbr1 := ( D():Articulos( nView ) )->nBnfSbr1
                     ( dbfTmp )->nBnfSbr2 := ( D():Articulos( nView ) )->nBnfSbr2
                     ( dbfTmp )->nBnfSbr3 := ( D():Articulos( nView ) )->nBnfSbr3
                     ( dbfTmp )->nBnfSbr4 := ( D():Articulos( nView ) )->nBnfSbr4
                     ( dbfTmp )->nBnfSbr5 := ( D():Articulos( nView ) )->nBnfSbr5
                     ( dbfTmp )->nBnfSbr6 := ( D():Articulos( nView ) )->nBnfSbr6

                     ( dbfTmp )->nPvpLin1 := ( D():Articulos( nView ) )->pVenta1
                     ( dbfTmp )->nPvpLin2 := ( D():Articulos( nView ) )->pVenta2
                     ( dbfTmp )->nPvpLin3 := ( D():Articulos( nView ) )->pVenta3
                     ( dbfTmp )->nPvpLin4 := ( D():Articulos( nView ) )->pVenta4
                     ( dbfTmp )->nPvpLin5 := ( D():Articulos( nView ) )->pVenta5
                     ( dbfTmp )->nPvpLin6 := ( D():Articulos( nView ) )->pVenta6

                     ( dbfTmp )->nIvaLin1 := ( D():Articulos( nView ) )->pVtaIva1
                     ( dbfTmp )->nIvaLin2 := ( D():Articulos( nView ) )->pVtaIva2
                     ( dbfTmp )->nIvaLin3 := ( D():Articulos( nView ) )->pVtaIva3
                     ( dbfTmp )->nIvaLin4 := ( D():Articulos( nView ) )->pVtaIva4
                     ( dbfTmp )->nIvaLin5 := ( D():Articulos( nView ) )->pVtaIva5
                     ( dbfTmp )->nIvaLin6 := ( D():Articulos( nView ) )->pVtaIva6

                     ( dbfTmp )->lNumSer  := ( D():Articulos( nView ) )->lNumSer
                     ( dbfTmp )->lAutSer  := ( D():Articulos( nView ) )->lAutSer

                     if ( ( dbfTmp )->lNumSer )

                        if ( ( dbfTmp )->lAutSer )
   
                           AutoNumerosSerie( dbfTmp, nMode )
   
                        elseif !( dbfTmpSer )->( dbSeek( Str( ( dbfTmp )->nNumLin, 4 ) + ( dbfTmp )->cRef ) )
   
                           msgStop( "Tiene que introducir números de serie para el artículo: " + (dbfTmp)->cDetalle )
   
                           EditarNumerosSerie( dbfTmp, nMode )
   
                        end if
   
                     end if 

                  end if

               end if

               ( D():PedidosProveedoresLineas( nView ) )->( dbSkip( 1 ) )

            END WHILE

            ( dbfTmp )->( dbGoTop() )

            //refrescamos el brws
            oBrw:refresh()

         END IF

      NEXT

      //No dejamos importar pedidos directos

      aGet[_CNUMPED]:Disable()

      //Recalculo de totales

      nTotAlbPrv( nil, D():AlbaranesProveedores( nView ), dbfTmp, D():TiposIva( nView ), D():Divisas( nView ), aTmp )

  END IF

RETURN .T.

//---------------------------------------------------------------------------//

Static FUNCTION nEstadoIncidencia( cNumAlb )

   local nEstado  := 0

   if ( D():AlbaranesProveedoresIncidencias( nView ) )->( dbSeek( cNumAlb ) )

      while ( D():AlbaranesProveedoresIncidencias( nView ) )->cSerAlb + Str( ( D():AlbaranesProveedoresIncidencias( nView ) )->nNumAlb ) + ( D():AlbaranesProveedoresIncidencias( nView ) )->cSufAlb == cNumAlb .and. !( D():AlbaranesProveedoresIncidencias( nView ) )->( Eof() )

         if ( D():AlbaranesProveedoresIncidencias( nView ) )->lListo
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

         ( D():AlbaranesProveedoresIncidencias( nView ) )->( dbSkip() )

      end while

   end if

RETURN ( nEstado )

//---------------------------------------------------------------------------//

Static FUNCTION GetCliente( cNumPed )

   local nRec     := ( D():PedidosClientes( nView ) )->( Recno() )
   local nOrdAnt  := ( D():PedidosClientes( nView ) )->( OrdSetFocus( "NNUMPED" ) )
   local cCliente := ""

   if ( D():PedidosClientes( nView ) )->( dbSeek( cNumPed ) )
      cCliente    := AllTrim( ( D():PedidosClientes( nView ) )->cCodCli ) + " - " + AllTrim( ( D():PedidosClientes( nView ) )->cNomCli )
   end if

   ( D():PedidosClientes( nView ) )->( nOrdAnt )
   ( D():PedidosClientes( nView ) )->( dbGoTo( nRec ) )

RETURN cCliente

//----------------------------------------------------------------------------//

STATIC FUNCTION ValidaMedicion( aTmp, aGet )

   local cNewUndMed  := aGet[ _CUNIDAD ]:VarGet

   /*
   Cargamos el codigo de las unidades---------------------------------
   */

   if ( Empty( cOldUndMed ) .or. cOldUndMed != cNewUndMed )

      if D():GetObject( "UnidadMedicion", nView ):oDbf:Seek( aTmp[ _CUNIDAD ] )

         if D():GetObject( "UnidadMedicion", nView ):oDbf:nDimension >= 1 .and. !Empty( D():GetObject( "UnidadMedicion", nView ):oDbf:cTextoDim1 )
            if !Empty( aGet[ ( D():AlbaranesProveedoresLineas( nView ) )->( fieldpos( "nMedUno" ) ) ] )
               aGet[ ( D():AlbaranesProveedoresLineas( nView ) )->( fieldpos( "nMedUno" ) ) ]:oSay:SetText( D():GetObject( "UnidadMedicion", nView ):oDbf:cTextoDim1 )
               aGet[ ( D():AlbaranesProveedoresLineas( nView ) )->( fieldpos( "nMedUno" ) ) ]:cText( ( D():Articulos( nView ) )->nLngArt )
               aGet[ ( D():AlbaranesProveedoresLineas( nView ) )->( fieldpos( "nMedUno" ) ) ]:Show()
            else
               aTmp[ ( D():AlbaranesProveedoresLineas( nView ) )->( fieldpos( "nMedUno" ) ) ]  := ( D():Articulos( nView ) )->nLngArt
            end if
         else
            if !Empty( aGet[ ( D():AlbaranesProveedoresLineas( nView ) )->( fieldpos( "nMedUno" ) ) ] )
               aGet[ ( D():AlbaranesProveedoresLineas( nView ) )->( fieldpos( "nMedUno" ) ) ]:cText( 0 )
               aGet[ ( D():AlbaranesProveedoresLineas( nView ) )->( fieldpos( "nMedUno" ) ) ]:Hide()
            else
               aTmp[ ( D():AlbaranesProveedoresLineas( nView ) )->( fieldpos( "nMedUno" ) ) ]  := 0
            end if
         end if

         if D():GetObject( "UnidadMedicion", nView ):oDbf:nDimension >= 2 .and. !Empty( D():GetObject( "UnidadMedicion", nView ):oDbf:cTextoDim2 )
            if !Empty( aGet[ ( D():AlbaranesProveedoresLineas( nView ) )->( fieldpos( "nMedDos" ) ) ] )
               aGet[ ( D():AlbaranesProveedoresLineas( nView ) )->( fieldpos( "nMedDos" ) ) ]:oSay:SetText( D():GetObject( "UnidadMedicion", nView ):oDbf:cTextoDim2 )
               aGet[ ( D():AlbaranesProveedoresLineas( nView ) )->( fieldpos( "nMedDos" ) ) ]:cText( ( D():Articulos( nView ) )->nAltArt )
               aGet[ ( D():AlbaranesProveedoresLineas( nView ) )->( fieldpos( "nMedDos" ) ) ]:Show()
            else
               aTmp[ ( D():AlbaranesProveedoresLineas( nView ) )->( fieldpos( "nMedDos" ) ) ]  := ( D():Articulos( nView ) )->nAltArt
            end if

         else
            if !Empty( aGet[ ( D():AlbaranesProveedoresLineas( nView ) )->( fieldpos( "nMedDos" ) ) ] )
               aGet[ ( D():AlbaranesProveedoresLineas( nView ) )->( fieldpos( "nMedDos" ) ) ]:cText( 0 )
               aGet[ ( D():AlbaranesProveedoresLineas( nView ) )->( fieldpos( "nMedDos" ) ) ]:Hide()
            else
                 aTmp[ ( D():AlbaranesProveedoresLineas( nView ) )->( fieldpos( "nMedDos" ) ) ]  := 0
            end if
         end if

         if D():GetObject( "UnidadMedicion", nView ):oDbf:nDimension >= 3 .and. !Empty( D():GetObject( "UnidadMedicion", nView ):oDbf:cTextoDim3 )
            if !Empty( aGet[ ( D():AlbaranesProveedoresLineas( nView ) )->( fieldpos( "nMedTre" ) ) ] )
               aGet[ ( D():AlbaranesProveedoresLineas( nView ) )->( fieldpos( "nMedTre" ) ) ]:oSay:SetText( D():GetObject( "UnidadMedicion", nView ):oDbf:cTextoDim3 )
               aGet[ ( D():AlbaranesProveedoresLineas( nView ) )->( fieldpos( "nMedTre" ) ) ]:cText( ( D():Articulos( nView ) ) ->nAncArt )
               aGet[ ( D():AlbaranesProveedoresLineas( nView ) )->( fieldpos( "nMedTre" ) ) ]:Show()
            else
               aTmp[ ( D():AlbaranesProveedoresLineas( nView ) )->( fieldpos( "nMedTre" ) ) ]  := ( D():Articulos( nView ) )->nAncArt
            end if
         else
            if !Empty( aGet[ ( D():AlbaranesProveedoresLineas( nView ) )->( fieldpos( "nMedTre" ) ) ] )
               aGet[ ( D():AlbaranesProveedoresLineas( nView ) )->( fieldpos( "nMedTre" ) ) ]:cText( 0 )
               aGet[ ( D():AlbaranesProveedoresLineas( nView ) )->( fieldpos( "nMedTre" ) ) ]:Hide()
            else
               aTmp[ ( D():AlbaranesProveedoresLineas( nView ) )->( fieldpos( "nMedTre" ) ) ]  := 0
            end if
         end if

      else

         if !Empty( aGet[ ( D():AlbaranesProveedoresLineas( nView ) )->( fieldpos( "nMedUno" ) ) ] )
            aGet[ ( D():AlbaranesProveedoresLineas( nView ) )->( fieldpos( "nMedUno" ) ) ]:Hide()
            aGet[ ( D():AlbaranesProveedoresLineas( nView ) )->( fieldpos( "nMedUno" ) ) ]:cText( 0 )
         end if

         if !Empty( aGet[ ( D():AlbaranesProveedoresLineas( nView ) )->( fieldpos( "nMedDos" ) ) ] )
            aGet[ ( D():AlbaranesProveedoresLineas( nView ) )->( fieldpos( "nMedDos" ) ) ]:Hide()
            aGet[ ( D():AlbaranesProveedoresLineas( nView ) )->( fieldpos( "nMedDos" ) ) ]:cText( 0 )
         end if

         if !Empty( aGet[ ( D():AlbaranesProveedoresLineas( nView ) )->( fieldpos( "nMedTre" ) ) ] )
            aGet[ ( D():AlbaranesProveedoresLineas( nView ) )->( fieldpos( "nMedTre" ) ) ]:Hide()
            aGet[ ( D():AlbaranesProveedoresLineas( nView ) )->( fieldpos( "nMedTre" ) ) ]:cText( 0 )
         end if

      end if

      cOldUndMed := cNewUndMed

   end if

RETURN .t.

//-------------------------------------------------------------------------//

Static FUNCTION DataReport( oFr )

   /*
   Zona de datos------------------------------------------------------------
   */

   oFr:ClearDataSets()

   oFr:SetWorkArea(     "Albaranes", ( D():AlbaranesProveedores( nView ) )->( Select() ), .f., { FR_RB_CURRENT, FR_RB_CURRENT, 0 } )
   oFr:SetFieldAliases( "Albaranes", cItemsToReport( aItmAlbPrv() ) )

   oFr:SetWorkArea(     "Lineas de albaranes", ( D():AlbaranesProveedoresLineas( nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Lineas de albaranes", cItemsToReport( aColAlbPrv() ) )

   oFr:SetWorkArea(     "Series de lineas de albaranes", ( D():AlbaranesProveedoresSeries( nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Series de lineas de albaranes", cItemsToReport( aSerAlbPrv() ) )

   oFr:SetWorkArea(     "Incidencias de albaranes", ( D():AlbaranesProveedoresIncidencias( nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Incidencias de albaranes", cItemsToReport( aIncAlbPrv() ) )

   oFr:SetWorkArea(     "Documentos de albaranes", ( D():AlbaranesProveedoresDocumentos( nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Documentos de albaranes", cItemsToReport( aAlbPrvDoc() ) )

   oFr:SetWorkArea(     "Empresa", ( D():Empresa( nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Empresa", cItemsToReport( aItmEmp() ) )

   oFr:SetWorkArea(     "Proveedor", ( D():Proveedores( nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Proveedor", cItemsToReport( aItmPrv() ) )

   oFr:SetWorkArea(     "Almacenes", ( D():Almacen( nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Almacenes", cItemsToReport( aItmAlm() ) )

   oFr:SetWorkArea(     "Formas de pago", ( D():FormasPago( nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Formas de pago", cItemsToReport( aItmFPago() ) )

   oFr:SetWorkArea(     "Artículos", ( D():Articulos( nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Artículos", cItemsToReport( aItmArt() ) )

   oFr:SetWorkArea(     "Código de proveedores", ( D():ProveedorArticulo( nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Código de proveedores", cItemsToReport( aItmArtPrv() ) )

   oFr:SetWorkArea(     "Unidades de medición",  D():GetObject( "UnidadMedicion", nView ):Select() )
   oFr:SetFieldAliases( "Unidades de medición",  cObjectsToReport( D():GetObject( "UnidadMedicion", nView ):oDbf ) )

   oFr:SetWorkArea(     "Centro de coste",  D():CentroCoste( nView ):Select() )
   oFr:SetFieldAliases( "Centro de coste",  cObjectsToReport( D():CentroCoste( nView ):oDbf ) )

   oFr:SetMasterDetail( "Albaranes", "Lineas de albaranes",             {|| ( D():AlbaranesProveedores( nView ) )->cSerAlb + Str( ( D():AlbaranesProveedores( nView ) )->nNumAlb ) + ( D():AlbaranesProveedores( nView ) )->cSufAlb } )
   oFr:SetMasterDetail( "Albaranes", "Series de lineas de albaranes",   {|| ( D():AlbaranesProveedores( nView ) )->cSerAlb + Str( ( D():AlbaranesProveedores( nView ) )->nNumAlb ) + ( D():AlbaranesProveedores( nView ) )->cSufAlb } )
   oFr:SetMasterDetail( "Albaranes", "Incidencias de albaranes",        {|| ( D():AlbaranesProveedores( nView ) )->cSerAlb + Str( ( D():AlbaranesProveedores( nView ) )->nNumAlb ) + ( D():AlbaranesProveedores( nView ) )->cSufAlb } )
   oFr:SetMasterDetail( "Albaranes", "Documentos de albaranes",         {|| ( D():AlbaranesProveedores( nView ) )->cSerAlb + Str( ( D():AlbaranesProveedores( nView ) )->nNumAlb ) + ( D():AlbaranesProveedores( nView ) )->cSufAlb } )
   oFr:SetMasterDetail( "Albaranes", "Empresa",                         {|| cCodigoEmpresaEnUso() } )
   oFr:SetMasterDetail( "Albaranes", "Proveedor",                       {|| ( D():AlbaranesProveedores( nView ) )->cCodPrv } )
   oFr:SetMasterDetail( "Albaranes", "Almacenes",                       {|| ( D():AlbaranesProveedores( nView ) )->cCodAlm } )
   oFr:SetMasterDetail( "Albaranes", "Formas de pago",                  {|| ( D():AlbaranesProveedores( nView ) )->cCodPgo } )
   oFr:SetMasterDetail( "Albaranes", "Centro de coste",                 {|| ( D():AlbaranesProveedores( nView ) )->cCtrCoste } )
   oFr:SetMasterDetail( "Lineas de albaranes", "Artículos",             {|| ( D():AlbaranesProveedoresLineas( nView ) )->cRef } )
   oFr:SetMasterDetail( "Lineas de albaranes", "Código de proveedores", {|| ( D():AlbaranesProveedores( nView ) )->cCodPrv + ( D():AlbaranesProveedoresLineas( nView ) )->cRef } )
   oFr:SetMasterDetail( "Lineas de albaranes", "Unidades de medición",  {|| ( D():AlbaranesProveedoresLineas( nView ) )->cUnidad } )

   oFr:SetResyncPair(   "Albaranes", "Lineas de albaranes" )
   oFr:SetResyncPair(   "Albaranes", "Series de lineas de albaranes" )
   oFr:SetResyncPair(   "Albaranes", "Incidencias de albaranes" )
   oFr:SetResyncPair(   "Albaranes", "Documentos de albaranes" )
   oFr:SetResyncPair(   "Albaranes", "Empresa" )
   oFr:SetResyncPair(   "Albaranes", "Proveedor" )
   oFr:SetResyncPair(   "Albaranes", "Almacenes" )
   oFr:SetResyncPair(   "Albaranes", "Formas de pago" )
   oFr:SetResyncPair(   "Albaranes", "Centro de coste" )

   oFr:SetResyncPair(   "Lineas de albaranes", "Artículos" )
   oFr:SetResyncPair(   "Lineas de albaranes", "Código de proveedores" )
   oFr:SetResyncPair(   "Lineas de albaranes", "Unidades de medición" )

RETURN nil

//---------------------------------------------------------------------------//

Static FUNCTION VariableReport( oFr )

   oFr:DeleteCategory(  "Albaranes" )
   oFr:DeleteCategory(  "Lineas de albaranes" )

   /*
   Creación de variables----------------------------------------------------
   */

   oFr:AddVariable(     "Albaranes",             "Total albaran",                            "GetHbVar('nTotAlb')" )
   oFr:AddVariable(     "Albaranes",             "Total bruto",                              "GetHbVar('nTotBrt')" )
   oFr:AddVariable(     "Albaranes",             "Total descuento",                          "GetHbVar('nTotDto')" )
   oFr:AddVariable(     "Albaranes",             "Total descuento pronto pago",              "GetHbVar('nTotDpp')" )
   oFr:AddVariable(     "Albaranes",             "Total bruto",                              "GetHbVar('nTotBrt')" )
   oFr:AddVariable(     "Albaranes",             "Total neto",                               "GetHbVar('nTotNet')" )
   oFr:AddVariable(     "Albaranes",             "Total primer descuento definible",         "GetHbVar('nTotUno')" )
   oFr:AddVariable(     "Albaranes",             "Total segundo descuento definible",        "GetHbVar('nTotDos')" )
   oFr:AddVariable(     "Albaranes",             "Total " + cImp(),                          "GetHbVar('nTotIva')" )
   oFr:AddVariable(     "Albaranes",             "Total RE",                                 "GetHbVar('nTotReq')" )
   oFr:AddVariable(     "Albaranes",             "Total retención",                          "GetHbVar('nTotRet')" )
   oFr:AddVariable(     "Albaranes",             "Total impuestos especiales",               "GetHbVar('nTotIvm')" )
   oFr:AddVariable(     "Albaranes",             "Bruto primer tipo de " + cImp(),           "GetHbArrayVar('aIvaUno',1)" )
   oFr:AddVariable(     "Albaranes",             "Bruto segundo tipo de " + cImp(),          "GetHbArrayVar('aIvaDos',1)" )
   oFr:AddVariable(     "Albaranes",             "Bruto tercer tipo de " + cImp(),           "GetHbArrayVar('aIvaTre',1)" )
   oFr:AddVariable(     "Albaranes",             "Base primer tipo de " + cImp(),            "GetHbArrayVar('aIvaUno',2)" )
   oFr:AddVariable(     "Albaranes",             "Base segundo tipo de " + cImp(),           "GetHbArrayVar('aIvaDos',2)" )
   oFr:AddVariable(     "Albaranes",             "Base tercer tipo de " + cImp(),            "GetHbArrayVar('aIvaTre',2)" )
   oFr:AddVariable(     "Albaranes",             "Porcentaje primer tipo " + cImp(),         "GetHbArrayVar('aIvaUno',3)" )
   oFr:AddVariable(     "Albaranes",             "Porcentaje segundo tipo " + cImp(),        "GetHbArrayVar('aIvaDos',3)" )
   oFr:AddVariable(     "Albaranes",             "Porcentaje tercer tipo " + cImp(),         "GetHbArrayVar('aIvaTre',3)" )
   oFr:AddVariable(     "Albaranes",             "Porcentaje primer tipo RE",                "GetHbArrayVar('aIvaUno',4)" )
   oFr:AddVariable(     "Albaranes",             "Porcentaje segundo tipo RE",               "GetHbArrayVar('aIvaDos',4)" )
   oFr:AddVariable(     "Albaranes",             "Porcentaje tercer tipo RE",                "GetHbArrayVar('aIvaTre',4)" )
   oFr:AddVariable(     "Albaranes",             "Importe primer tipo " + cImp(),            "GetHbArrayVar('aIvaUno',5)" )
   oFr:AddVariable(     "Albaranes",             "Importe segundo tipo " + cImp(),           "GetHbArrayVar('aIvaDos',5)" )
   oFr:AddVariable(     "Albaranes",             "Importe tercer tipo " + cImp(),            "GetHbArrayVar('aIvaTre',5)" )
   oFr:AddVariable(     "Albaranes",             "Importe primer RE",                        "GetHbArrayVar('aIvaUno',6)" )
   oFr:AddVariable(     "Albaranes",             "Importe segundo RE",                       "GetHbArrayVar('aIvaDos',6)" )
   oFr:AddVariable(     "Albaranes",             "Importe tercer RE",                        "GetHbArrayVar('aIvaTre',6)" )

   oFr:AddVariable(     "Lineas de albaranes",   "Código del artículo con propiedades",      "CallHbFunc('cCodAlbPrv')" )
   oFr:AddVariable(     "Lineas de albaranes",   "Detalle del artículo",                     "CallHbFunc('cDesAlbPrv')" )
   oFr:AddVariable(     "Lineas de albaranes",   "Detalle del artículo otro lenguaje",       "CallHbFunc('cDesAlbPrvLeng')" )
   oFr:AddVariable(     "Lineas de albaranes",   "Total unidades artículo",                  "CallHbFunc('nTotNAlbPrv')" )
   oFr:AddVariable(     "Lineas de albaranes",   "Precio unitario del artículo",             "CallHbFunc('nTotUAlbPrv')" )
   oFr:AddVariable(     "Lineas de albaranes",   "Total línea de albaran",                   "CallHbFunc('nTotLAlbPrv')" )
   oFr:AddVariable(     "Lineas de albaranes",   "Código de barras para primera propiedad",  "CallHbFunc('cBarPrp1')" )
   oFr:AddVariable(     "Lineas de albaranes",   "Código de barras para segunda propiedad",  "CallHbFunc('cBarPrp2')" )

   oFr:AddVariable(     "Lineas de albaranes",   "Stock actual en almacén",                  "CallHbFunc('nStockLineaAlbPrv')" )

RETURN nil

//---------------------------------------------------------------------------//

Static FUNCTION YearComboBoxChange()

   if ( oWndBrw:oWndBar:cYearComboBox() != __txtAllYearsFilter__ )
      oWndBrw:oWndBar:setYearComboBoxExpression( "Year( Field->dFecAlb ) == " + oWndBrw:oWndBar:cYearComboBox() )
   else
      oWndBrw:oWndBar:setYearComboBoxExpression( "" )
   end if 

   oWndBrw:chgFilter()

RETURN nil

//---------------------------------------------------------------------------//

#define OFN_PATHMUSTEXIST            0x00000800
#define OFN_NOCHANGEDIR              0x00000008
#define OFN_ALLOWMULTISELECT         0x00000200
#define OFN_EXPLORER                 0x00080000     // new look commdlg
#define OFN_LONGNAMES                0x00200000     // force long names for 3.x modules
#define OFN_ENABLESIZING             0x00800000

//---------------------------------------------------------------------------//

Static FUNCTION AddFicheroICG( aFichero, oBrwFichero )

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

Static FUNCTION DelFicheroICG( aFichero, oBrwFichero )

   aDel( aFichero, oBrwFichero:nArrayAt, .t. )

   oBrwFichero:Refresh()

RETURN ( nil )

//---------------------------------------------------------------------------//

Static FUNCTION IcgCabAlbPrv( cSerDoc, nNumDoc, cSufDoc, dFecDoc )

   local lApp
   local cCodPrv                 := Replicate( "0", RetNumCodPrvEmp() )

   if dbSeekInOrd( cSerDoc + nNumDoc + cSufDoc, "cSuAlb", D():AlbaranesProveedores( nView ) )

      lApp                       := .f.
      cSerDoc                    := ( D():AlbaranesProveedores( nView ) )->cSerAlb
      nNumAlb                    := ( D():AlbaranesProveedores( nView ) )->nNumAlb
      cSufDoc                    := ( D():AlbaranesProveedores( nView ) )->cSufAlb

      while ( D():AlbaranesProveedoresLineas( nView ) )->( dbSeek( cSerDoc + Str( nNumAlb ) + cSufDoc ) )
         if dbLock( D():AlbaranesProveedoresLineas( nView ) )
            ( D():AlbaranesProveedoresLineas( nView ) )->( dbDelete() )
            ( D():AlbaranesProveedoresLineas( nView ) )->( dbUnLock() )
         end if
      end while

   else

      lApp                       := .t.
      nNumAlb                    := nNewDoc( cSerDoc, D():AlbaranesProveedores( nView ), "nAlbPrv", , D():Contadores( nView ) )

   end if

   if lApp
      dbAppe( D():AlbaranesProveedores( nView ) )
   else
      dbLock( D():AlbaranesProveedores( nView ) )
   end if

      ( D():AlbaranesProveedores( nView ) )->cSerAlb    := cSerDoc
      ( D():AlbaranesProveedores( nView ) )->nNumAlb    := nNumAlb
      ( D():AlbaranesProveedores( nView ) )->cSufAlb    := cSufDoc
      ( D():AlbaranesProveedores( nView ) )->dFecAlb    := Stod( dFecDoc )
      ( D():AlbaranesProveedores( nView ) )->cCodAlm    := Application():codigoAlmacen()
      ( D():AlbaranesProveedores( nView ) )->cDivAlb    := cDivEmp()
      ( D():AlbaranesProveedores( nView ) )->nVdvAlb    := nChgDiv( cDivEmp(), D():Divisas( nView ) )
      ( D():AlbaranesProveedores( nView ) )->cSuAlb     := cSerDoc + nNumDoc + cSufDoc
      ( D():AlbaranesProveedores( nView ) )->cCodUsr    := Auth():Codigo()
      ( D():AlbaranesProveedores( nView ) )->cCodDlg    := Application():CodigoDelegacion()
      ( D():AlbaranesProveedores( nView ) )->cCodCaj    := Application():CodigoCaja()
      ( D():AlbaranesProveedores( nView ) )->cTurAlb    := cCurSesion()

      ( D():AlbaranesProveedores( nView ) )->cCodPrv    := cCodPrv

      if ( D():Proveedores( nView ) )->( dbSeek( cCodPrv ) )
         ( D():AlbaranesProveedores( nView ) )->cNomPrv := ( D():Proveedores( nView ) )->Titulo
         ( D():AlbaranesProveedores( nView ) )->cDirPrv := ( D():Proveedores( nView ) )->Domicilio
         ( D():AlbaranesProveedores( nView ) )->cPobPrv := ( D():Proveedores( nView ) )->Poblacion
         ( D():AlbaranesProveedores( nView ) )->cProPrv := ( D():Proveedores( nView ) )->Provincia
         ( D():AlbaranesProveedores( nView ) )->cPosPrv := ( D():Proveedores( nView ) )->CodPostal
         ( D():AlbaranesProveedores( nView ) )->cDniPrv := ( D():Proveedores( nView ) )->Nif
      end if

   ( D():AlbaranesProveedores( nView ) )->( dbUnlock() )

RETURN ( nil )

//---------------------------------------------------------------------------//

Static FUNCTION IcgDetAlbPrv( cSerDoc, cSufDoc, cDesLin, nUntLin, nPvpLin, nDtoLin, cRefLin )

   if !dbSeekInOrd( cRefLin, "Codigo", D():Articulos( nView ) )
      cInforme                += "Articulo " + cRefLin + " no existe en la base de datos, albaran número " + cSerDoc + "/" + Alltrim( Str( nNumAlb ) ) + "/" + RetSufEmp() + CRLF
      lIncidencia             := .t.
   else 
      if ( Round( ( D():Articulos( nView ) )->pCosto, 2 ) != ( Round( ( nPvpLin ) - ( nPvpLin * nDtoLin / 100 ), 2 ) ) )
         cInforme             += "Articulo " + cRefLin + " ha variado su precio de costo, percio nuevo " + Alltrim( Str( Round( ( nPvpLin ) - ( nPvpLin * nDtoLin / 100 ), 2 ) ) ) + CRLF
         lIncidencia          := .t.
      end if
   end if

   ( D():AlbaranesProveedoresLineas( nView ) )->( dbAppend() )
   ( D():AlbaranesProveedoresLineas( nView ) )->cSerAlb    := cSerDoc
   ( D():AlbaranesProveedoresLineas( nView ) )->nNumAlb    := nNumAlb
   ( D():AlbaranesProveedoresLineas( nView ) )->cSufAlb    := cSufDoc
   ( D():AlbaranesProveedoresLineas( nView ) )->cAlmLin    := Application():codigoAlmacen()
   ( D():AlbaranesProveedoresLineas( nView ) )->cRef       := cRefLin
   ( D():AlbaranesProveedoresLineas( nView ) )->cDetalle   := cDesLin
   ( D():AlbaranesProveedoresLineas( nView ) )->mLngDes    := cDesLin
   ( D():AlbaranesProveedoresLineas( nView ) )->nUniCaja   := nUntLin
   ( D():AlbaranesProveedoresLineas( nView ) )->nPreDiv    := nPvpLin
   ( D():AlbaranesProveedoresLineas( nView ) )->nDtoLin    := nDtoLin
   ( D():AlbaranesProveedoresLineas( nView ) )->nIva       := nIva( D():TiposIva( nView ), "G" )
   ( D():AlbaranesProveedoresLineas( nView ) )->( dbUnlock() )

RETURN ( nil )

//---------------------------------------------------------------------------//

Static FUNCTION EditarNumerosSerie( aTmp, nMode )

   oNumerosSerie:nMode              := nMode

   if IsArray( aTmp )

      oNumerosSerie:cCodArt            := aTmp[ _CREF    ]
      oNumerosSerie:cCodAlm            := aTmp[ _CALMLIN ]
      oNumerosSerie:nNumLin            := aTmp[ _NNUMLIN ]
      oNumerosSerie:lAutoSerializacion := aTmp[ _LAUTSER ]
      
   else 

      oNumerosSerie:cCodArt            := ( aTmp )->cRef   
      oNumerosSerie:cCodAlm            := ( aTmp )->cAlmLin
      oNumerosSerie:nNumLin            := ( aTmp )->nNumLin
      oNumerosSerie:lAutoSerializacion := ( aTmp )->lAutSer

   end if 

   oNumerosSerie:nTotalUnidades     := nTotNAlbPrv( aTmp )

   oNumerosSerie:uTmpSer            := dbfTmpSer

   if oNumerosSerie:lAutoSerializacion
       oNumerosSerie:AutoSerializa()
   end if

   oNumerosSerie:Resource()

RETURN ( nil )

//--------------------------------------------------------------------------//

Static FUNCTION AutoNumerosSerie( aTmp, nMode )

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

RETURN ( nil )

//----------------------------------------------------------------------------//

Static FUNCTION EliminarNumeroSerie( aTmp )

   while ( ( dbfTmpSer )->( dbSeek( Str( aTmp[ _NNUMLIN ], 4 ) + aTmp[ _CREF ] ) ) ) .and. !( dbfTmpSer )->( Eof() )
      ( dbfTmpSer )->( dbDelete() )
   end while

RETURN ( nil )

//----------------------------------------------------------------------------//
FUNCTION mailReportAlbPrv( cCodigoDocumento )

RETURN ( printReportAlbPrv( IS_MAIL, 1, prnGetName(), cCodigoDocumento ) )

//---------------------------------------------------------------------------//

static FUNCTION PrintReportAlbPrv( nDevice, nCopies, cPrinter, cDoc )

   local oFr
   local cFilePdf       := cPatTmp() + "AlbaranProveedor" +  ( D():AlbaranesProveedores( nView ) )->cSerAlb + Alltrim( Str( ( D():AlbaranesProveedores( nView ) )->nNumAlb ) ) + ".Pdf"
   local nOrd

   DEFAULT nCopies      := 1
   DEFAULT nDevice      := IS_SCREEN
   DEFAULT cPrinter     := PrnGetName()

   SysRefresh()

   nOrd                 := ( D():AlbaranesProveedoresLineas( nView ) )->( ordSetFocus( "nPosPrint" ) )

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

   ( D():AlbaranesProveedoresLineas( nView ) )->( ordSetFocus( nOrd ) )

RETURN cFilePdf

//---------------------------------------------------------------------------//

Static FUNCTION IcgMotor()

   local oDlg
   local aFichero
   local oInforme
   local oBrwFichero
   local oTreeImportacion
   local oImageImportacion

   aFichero                         := {}
   cInforme                         := ""
   lIncidencia                      := .f.

   DEFINE DIALOG oDlg RESOURCE "ImportarICG"

      /*
      Browse de ficheros a importar--------------------------------------------
      */

      oBrwFichero                   := IXBrowse():New( oDlg )

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
         OF       oDlg

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

STATIC FUNCTION IcgAlbPrv( aFichero, oDlg, oInforme )

   hb_freadline()

RETURN ( nil )

//---------------------------------------------------------------------------//


//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//----------------------FUNCIONES GLOBALES-----------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

FUNCTION ExcelImport( aTmpAlb, dbfTmp, cArticulo, cArtCom, cFamilia, cDiv, oBrw, lPedido, cKit )

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

               if ( cArticulo )->( dbSeek( cCodigo ) )

                  ( dbfTmp )->( dbAppend() )

                  ( dbfTmp )->nNumLin     := nLastNum( dbfTmp )
                  ( dbfTmp )->nPosPrint   := nLastNum( dbfTmp, "nPosPrint" )
                  ( dbfTmp )->cRef        := ( cArticulo )->Codigo
                  ( dbfTmp )->cDetalle    := ( cArticulo )->Nombre
                  ( dbfTmp )->cCodPr1     := "1"
                  ( dbfTmp )->cValPr1     := cProp1
                  ( dbfTmp )->cCodPr2     := "2"
                  ( dbfTmp )->cValPr2     := cProp2
                  ( dbfTmp )->nIva        := nIva( D():TiposIva( nView ), ( cArticulo )->TipoIva )
                  ( dbfTmp )->nUniCaja    := nUnidad
                  ( dbfTmp )->cCodFam     := ( cArticulo )->Familia
                  ( dbfTmp )->cGrpFam     := cGruFam( ( cArticulo )->Familia, cFamilia )

                  if lPedido

                     ( dbfTmp )->nCanPed  := nCajas / 100
                     ( dbfTmp )->nPreDiv  := nRetPreArt( 1, cDivEmp(), .f., cArticulo, cDiv, cKit, D():TiposIva( nView ) )

                  else

                     ( dbfTmp )->nCanEnt     := nCajas / 100

                     nComPro                 := nComPro( ( dbfTmp )->cRef, ( dbfTmp )->cCodPr1, ( dbfTmp )->cValPr1, ( dbfTmp )->cCodPr2, ( dbfTmp )->cValPr2, cArtCom )
                     if nComPro != 0
                        ( dbfTmp )->nPreDiv  := nComPro // nCnv2Div( nComPro, cDivEmp(), aTmpAlb[ _CDIVALB ], cDiv, .f. )
                     else
                        ( dbfTmp )->nPreDiv  := ( cArticulo )->pCosto // nCnv2Div( ( cArticulo )->pCosto, cDivEmp(), aTmpAlb[ _CDIVALB ], cDiv, .f. )
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

RETURN nil

//---------------------------------------------------------------------------//

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
   local nImpuestoEspecial   
   local aTotalDto   := { 0, 0, 0 }
   local aTotalDPP   := { 0, 0, 0 }
   local aTotalUno   := { 0, 0, 0 }
   local aTotalDos   := { 0, 0, 0 }
   
   if !Empty( nView )
      DEFAULT cAlbPrvT  := D():AlbaranesProveedores( nView )
      DEFAULT cAlbPrvL  := D():AlbaranesProveedoresLineas( nView )
   end if

   DEFAULT cIva      := cIva
   DEFAULT cDiv      := cDiv
   DEFAULT nAlbaran  := ( cAlbPrvT )->cSerAlb + Str( ( cAlbPrvT )->nNumAlb ) + ( cAlbPrvT )->cSufAlb
   DEFAULT lPic      := .f.

   initPublics()

   nRecno            := ( cAlbPrvL )->( Recno() )

   IF aTmp != NIL
      dFecFac        := aTmp[ _DFECALB ]
      lRecargo       := aTmp[ _LRECARGO]
      nDtoEsp        := aTmp[ _NDTOESP ]
      nDtoPP         := aTmp[ _NDPP    ]
      nDtoUno        := aTmp[ _NDTOUNO ]
      nDtoDos        := aTmp[ _NDTODOS ]
      nPorte         := aTmp[ _NPORTES ]
      cCodDiv        := aTmp[ _CDIVALB ]
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
      bCondition     := {|| ( cAlbPrvL )->cSerAlb + Str( ( cAlbPrvL )->nNumAlb ) + ( cAlbPrvL )->cSufAlb == nAlbaran .and. (cAlbPrvL)->( !eof() ) }
      ( cAlbPrvL )->( dbSeek( nAlbaran ) )
   END IF

   cPinDiv           := cPinDiv( cCodDiv, cDiv )
   cPirDiv           := cPirDiv( cCodDiv, cDiv )
   nDinDiv           := nDinDiv( cCodDiv, cDiv )
   nDirDiv           := nRinDiv( cCodDiv, cDiv )

   while Eval( bCondition )

      if lValLine( cAlbPrvL )

         nTotArt           := nTotLAlbPrv( cAlbPrvL, nDinDiv, nDirDiv )
         nImpuestoEspecial := nTotIAlbPrv( cAlbPrvL, nDinDiv, nDirDiv )

         if nTotArt != 0

            /*
            Estudio de impuestos
            */

            do case
            case _NPCTIVA1 == nil .OR. _NPCTIVA1 == ( cAlbPrvL )->nIva
               _NPCTIVA1   := ( cAlbPrvL )->nIva
               _NPCTREQ1   := ( cAlbPrvL )->nReq
               _NBRTIVA1   += nTotArt
               _NIVMIVA1   += nImpuestoEspecial

            case _NPCTIVA2 == nil .OR. _NPCTIVA2 == ( cAlbPrvL )->nIva
               _NPCTIVA2   := ( cAlbPrvL )->nIva
               _NPCTREQ2   := ( cAlbPrvL )->nReq
               _NBRTIVA2   += nTotArt
               _NIVMIVA2   += nImpuestoEspecial

            case _NPCTIVA3 == nil .OR. _NPCTIVA3 == ( cAlbPrvL )->nIva
               _NPCTIVA3   := ( cAlbPrvL )->nIva
               _NPCTREQ3   := ( cAlbPrvL )->nReq
               _NBRTIVA3   += nTotArt
               _NIVMIVA3   += nImpuestoEspecial

            end case

         end if

      end if

      ( cAlbPrvL )->( dbSkip() )

   end while

   ( cAlbPrvL )->( dbGoTo( nRecno) )

   /*
   Ordenamos los impuestosS de menor a mayor
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
      aTotalDto[1]   := Round( _NBASIVA1 * nDtoEsp / 100, nDinDiv )
      aTotalDto[2]   := Round( _NBASIVA2 * nDtoEsp / 100, nDinDiv )
      aTotalDto[3]   := Round( _NBASIVA3 * nDtoEsp / 100, nDinDiv )

      nTotDto        := aTotalDto[1] + aTotalDto[2] + aTotalDto[3]

      _NBASIVA1      -= aTotalDto[1]
      _NBASIVA2      -= aTotalDto[2]
      _NBASIVA3      -= aTotalDto[3]
   end if

   if nDtoPP != 0
      aTotalDPP[1]   := Round( _NBASIVA1 * nDtoPP / 100, nDinDiv )
      aTotalDPP[2]   := Round( _NBASIVA2 * nDtoPP / 100, nDinDiv )
      aTotalDPP[3]   := Round( _NBASIVA3 * nDtoPP / 100, nDinDiv )

      nTotDPP        := aTotalDPP[1] + aTotalDPP[2] + aTotalDPP[3]

      _NBASIVA1      -= aTotalDPP[1]
      _NBASIVA2      -= aTotalDPP[2]
      _NBASIVA3      -= aTotalDPP[3]
   end if

   if nDtoUno != 0
      aTotalUno[1]   := Round( _NBASIVA1 * nDtoUno / 100, nDirDiv )
      aTotalUno[2]   := Round( _NBASIVA2 * nDtoUno / 100, nDirDiv )
      aTotalUno[3]   := Round( _NBASIVA3 * nDtoUno / 100, nDirDiv )

      nTotUno        := aTotalUno[1] + aTotalUno[2] + aTotalUno[3]

      _NBASIVA1      -= aTotalUno[1]
      _NBASIVA2      -= aTotalUno[2]
      _NBASIVA3      -= aTotalUno[3]
   end if

   if nDtoDos != 0
      aTotalDos[1]   := Round( _NBASIVA1 * nDtoDos / 100, nDirDiv )
      aTotalDos[2]   := Round( _NBASIVA2 * nDtoDos / 100, nDirDiv )
      aTotalDos[3]   := Round( _NBASIVA3 * nDtoDos / 100, nDirDiv )

      nTotDos        := aTotalDos[1] + aTotalDos[2] + aTotalDos[3]

      _NBASIVA1      -= aTotalDos[1]
      _NBASIVA2      -= aTotalDos[2]
      _NBASIVA3      -= aTotalDos[3]
   end if

   if uFieldEmpresa( "lIvaImpEsp" )
      _NBASIVA1      += _NIVMIVA1
      _NBASIVA2      += _NIVMIVA2
      _NBASIVA3      += _NIVMIVA3
   end if

   // Total neto

   nTotNet           := Round( _NBASIVA1 + _NBASIVA2 + _NBASIVA3, nDirDiv )

   // Calculos de impuestos

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
   Total impuestos
   */

   nTotIva           := Round( _NIMPIVA1 + _NIMPIVA2 + _NIMPIVA3, nDirDiv )

   /*
   Total de R.E.
   */

   nTotReq           := Round( _NIMPREQ1 + _NIMPREQ2 + _NIMPREQ3, nDirDiv )

   // Total impuesto

   nTotIvm           := Round( _NIVMIVA1 + _NIVMIVA2 + _NIVMIVA3, nDirDiv )

   // Total de impuestos

   nTotImp           := Round( nTotIva + nTotReq , nDirDiv )
   if !uFieldEmpresa( "lIvaImpEsp" )
      nTotImp        += Round( nTotIvm , nDirDiv )
   end if 

   /*
   Total facturas
   */

   nTotAlb        := nTotNet + nTotImp

   aTotIva        := aSort( aTotIva,,, {|x,y| abs( x[1] ) > abs( y[1] ) } )

   /*
   Solicitan una divisa distinta a la q se hizo originalmente la factura-------
   */

   if cDivRet != nil .and. cDivRet != cCodDiv
      nTotNet     := nCnv2Div( nTotNet, cCodDiv, cDivRet )
      nTotIva     := nCnv2Div( nTotIva, cCodDiv, cDivRet )
      nTotReq     := nCnv2Div( nTotReq, cCodDiv, cDivRet )
      nTotAlb     := nCnv2Div( nTotAlb, cCodDiv, cDivRet )
      cPirDiv     := cPirDiv( cDivRet, cDiv )
   end if

RETURN ( if( lPic, Trans( nTotAlb, cPirDiv ), nTotAlb ) )

//---------------------------------------------------------------------------//

FUNCTION aTotAlbPrv( cAlbaran, cAlbPrvT, cAlbPrvL, cIva, cDiv, cDivRet )

   nTotAlbPrv( cAlbaran, cAlbPrvT, cAlbPrvL, cIva, cDiv, nil, cDivRet, .f. )

RETURN ( { nTotNet, nTotIva, nTotReq, nTotAlb, aTotIva } )

//--------------------------------------------------------------------------//

FUNCTION sTotAlbPrv( cAlbaran, dbfMaster, dbfLine, cIva, cDiv, cDivRet )

   local sTotal

   nTotAlbPrv( cAlbaran, dbfMaster, dbfLine, cIva, cDiv, nil, cDivRet, .f. )

   sTotal                                 := sTotal()
   sTotal:nTotalBruto                     := nTotBrt
   sTotal:nTotalNeto                      := nTotNet
   sTotal:nTotalIva                       := nTotIva
   sTotal:aTotalIva                       := aTotIva
   sTotal:nTotalRecargoEquivalencia       := nTotReq
   sTotal:nTotalDocumento                 := nTotAlb
   sTotal:nTotalDescuentoGeneral          := nTotDto
   sTotal:nTotalDescuentoProntoPago       := nTotDpp
   sTotal:nTotalDescuentoUno              := nTotUno
   sTotal:nTotalDescuentoDos              := nTotDos

RETURN ( sTotal )

//--------------------------------------------------------------------------//

//Total de una linea con impuestos incluidos

FUNCTION nTotFAlbPrv( uAlbPrvL, nDec, nRec, nVdv, cPirDiv )

   local nCalculo := 0

   nCalculo       += nTotLAlbPrv( uAlbPrvL, nDec, nRec, nVdv, cPirDiv )
   nCalculo       += nIvaLAlbPrv( uAlbPrvL, nDec, nRec, nVdv, cPirDiv )

RETURN ( if( cPirDiv != nil, Trans( nCalculo, cPirDiv ), nCalculo ) )

//---------------------------------------------------------------------------//
// Precio del articulo

FUNCTION nTotUAlbPrv( uAlbPrvL, nDec, nVdv, cPinDiv )

   local nCalculo

   DEFAULT uAlbPrvL  := if( !Empty( tmpAlbPrvL ), tmpAlbPrvL, D():AlbaranesProveedoresLineas( nView ) )
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

/*
Devuelve el importe de descuento porcentual por cada linea---------------------
*/

FUNCTION nDtoLAlbPrv( cAlbPrvL, nDec, nRou, nVdv )

   local nCalculo       := 0

   DEFAULT cAlbPrvL     := D():AlbaranesProveedoresLineas( nView )
   DEFAULT nDec         := nDouDiv()
   DEFAULT nRou         := nRouDiv()
   DEFAULT nVdv         := 1

   if ( cAlbPrvL )->nDtoLin != 0 

      nCalculo          := nTotUAlbPrv( cAlbPrvL, nDec ) * nTotNAlbPrv( cAlbPrvL )

      /*
      Descuentos---------------------------------------------------------------
      */

      nCalculo          := nCalculo * ( cAlbPrvL )->nDtoLin / 100


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

FUNCTION nPrmLAlbPrv( cAlbPrvL, nDec, nRou, nVdv )

   local nCalculo       := 0

   DEFAULT cAlbPrvL     := D():AlbaranesProveedoresLineas( nView )
   DEFAULT nDec         := nDouDiv()
   DEFAULT nRou         := nRouDiv()
   DEFAULT nVdv         := 1

   if ( cAlbPrvL )->nDtoPrm != 0 

      nCalculo          := nTotUAlbPrv( cAlbPrvL, nDec ) * nTotNAlbPrv( cAlbPrvL )

      /*
      Descuentos---------------------------------------------------------------
      */

      if ( cAlbPrvL )->nDtoLin != 0 
         nCalculo       -= nCalculo * ( cAlbPrvL )->nDtoLin / 100
      end if

      nCalculo          := nCalculo * ( cAlbPrvL )->nDtoPrm / 100

      if nVdv != 0
         nCalculo       := nCalculo / nVdv
      end if

      if nRou != nil
         nCalculo       := Round( nCalculo, nRou )
      end if

   end if

RETURN ( nCalculo ) 

//---------------------------------------------------------------------------//
// Total de linea

FUNCTION nTotLAlbPrv( uAlbPrvL, nDec, nRec, nVdv, cPirDiv )

   local nCalculo
   local nDtoLin
   local nDtoPrm
   local nTotDto     := 0

   DEFAULT uAlbPrvL  := if( !Empty( tmpAlbPrvL ), tmpAlbPrvL, D():AlbaranesProveedoresLineas( nView ) )
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

   if !Empty( nView )
      DEFAULT uAlbPrvT  := D():AlbaranesProveedores( nView )
   end if

   DEFAULT uAlbPrvL  := if( !Empty( tmpAlbPrvL ), tmpAlbPrvL, D():AlbaranesProveedoresLineas( nView ) )
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

   if !Empty( nView )
      DEFAULT uAlbPrvT  := D():AlbaranesProveedores( nView )
   end if
     
   DEFAULT uAlbPrvL  := if( !Empty( tmpAlbPrvL ), tmpAlbPrvL, D():AlbaranesProveedoresLineas( nView ) )
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

FUNCTION nTotIAlbPrv( dbfLin, nDec, nRouDec, nVdv, cPorDiv )

   local nCalculo    := 0

   DEFAULT dbfLin    := D():Get( "AlbPrvL", nView )
   DEFAULT nDec      := 0
   DEFAULT nRouDec   := 0
   DEFAULT nVdv      := 1

   nCalculo          := Round( ( dbfLin )->nValImp, nDec )
   nCalculo          *= nTotNAlbPrv( dbfLin )
   nCalculo          := Round( nCalculo / nVdv, nRouDec )

RETURN ( if( cPorDiv != NIL, Trans( nCalculo, cPorDiv ), nCalculo ) )

//----------------------------------------------------------------------------//

FUNCTION nStockLineaAlbPrv()

RETURN ( oStock:nTotStockAct( ( D():AlbaranesProveedoresLineas( nView ) )->cRef, ( D():AlbaranesProveedoresLineas( nView ) )->cAlmLin, ( D():AlbaranesProveedoresLineas( nView ) )->cValPr1, ( D():AlbaranesProveedoresLineas( nView ) )->cValPr2 ) )

//---------------------------------------------------------------------------//

FUNCTION BrwAlbPrv( oGetNum, cAlbPrvT, cAlbPrvL, cIva, cDiv )

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
   nOrd           := ( cAlbPrvT )->( OrdSetFocus( nOrd ) )

   ( cAlbPrvT )->( dbSetFilter( {|| Field->nFacturado < 3 }, "nFacturado < 3" ) )
   ( cAlbPrvT )->( dbGoTop() )

   DEFINE DIALOG oDlg RESOURCE "HELPENTRY" TITLE "Albaranes de proveedores"

      REDEFINE GET oGet1 VAR cGet1;
         ID       104 ;
         ON CHANGE( AutoSeek( nKey, nFlags, Self, oBrw, cAlbPrvT ) );
         VALID    ( OrdClearScope( oBrw, cAlbPrvT ) );
         BITMAP   "FIND" ;
         OF       oDlg

      REDEFINE COMBOBOX oCbxOrd ;
         VAR      cCbxOrd ;
         ID       102 ;
         ITEMS    aCbxOrd ;
         ON CHANGE( ( cAlbPrvT )->( OrdSetFocus( oCbxOrd:nAt ) ), oBrw:refresh(), oGet1:SetFocus() ) ;
         OF       oDlg

      oBrw                 := IXBrowse():New( oDlg )

      oBrw:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrw:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrw:cAlias          := cAlbPrvT
      oBrw:nMarqueeStyle   := 5
      oBrw:cName           := "Albaran de proveedor.Browse"

      oBrw:bLDblClick      := {|| oDlg:end( IDOK ) }

      oBrw:CreateFromResource( 105 )

      with object ( oBrw:AddCol() )
         :cHeader          := "Es. Estado"
         :bStrData         := {|| "" }
         :bBmpData         := {|| ( cAlbPrvT )->nFacturado }
         :nWidth           := 20
         :AddResource( "gc_delete_12" )
         :AddResource( "gc_shape_square_12" )
         :AddResource( "gc_check_12" )
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "N. albarán"
         :cSortOrder       := "nNumAlb"
         :bEditValue       := {|| ( cAlbPrvT )->cSerAlb + "/" + AllTrim( Str( ( cAlbPrvT )->nNumAlb ) ) + "/" + ( cAlbPrvT )->cSufAlb }
         :nWidth           := 60
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Fecha"
         :cSortOrder       := "dFecAlb"
         :bEditValue       := {|| dToc( ( cAlbPrvT )->dFecAlb ) }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Cod. proveedor"
         :cSortOrder       := "cCodPrv"
         :bEditValue       := {|| Rtrim( ( cAlbPrvT )->cCodPrv ) }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Nom. proveedor"
         :cSortOrder       := "cNomPrv"
         :bEditValue       := {|| Rtrim( ( cAlbPrvT )->cNomPrv ) }
         :nWidth           := 200
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Importe"
         :bEditValue       := {|| nTotAlbPrv( ( cAlbPrvT )->cSerAlb + Str( ( cAlbPrvT)->nNumAlb ) + ( cAlbPrvT)->cSufAlb, cAlbPrvT, cAlbPrvL, cIva, cDiv, nil, cDivEmp(), .t. ) }
         :nWidth           := 60
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

   oDlg:AddFastKey( VK_RETURN, {|| oDlg:end( IDOK ) } )
   oDlg:AddFastKey( VK_F5, {|| oDlg:end( IDOK ) } )

   oDlg:bStart    := {|| oBrw:Load() }

   ACTIVATE DIALOG oDlg CENTER

   if oDlg:nResult == IDOK
      oGetNum:cText( ( cAlbPrvT )->cSerAlb + Str( ( cAlbPrvT )->nNumAlb ) + ( cAlbPrvT )->cSufAlb )
      oGetNum:disable()
   end if

   DestroyFastFilter( cAlbPrvT )

   SetBrwOpt( "BrwAlbPrv", ( cAlbPrvT )->( OrdNumber() ) )

   ( cAlbPrvT )->( dbSetFilter() )
   ( cAlbPrvT )->( OrdSetFocus( nOrd ) )

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
   local oldAlbPrvT
   local oldAlbPrvL
   local oldAlbPrvI
   local oldAlbPrvD
   local cAlbPrvT
   local cAlbPrvL
   local cAlbPrvI
   local cAlbPrvD

   DEFAULT lAppend   := .f.
   DEFAULT bFor      := {|| .t. }

   IF oMeter != NIL
      oMeter:cText   := "Generando bases"
      sysrefresh()
   END IF

   createFiles( cPath )

   rxAlbPrv( cPath, cLocalDriver() )

   if lAppend .and. lIsDir( cPathOld )

      oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
      BEGIN SEQUENCE

      dbUseArea( .t., cDriver(), cPath + "ALBPROVT.DBF", cCheckArea( "ALBPROVT", @cAlbPrvT ), .f. )
      ordListAdd( cPath + "AlbProvT.Cdx"  )

      dbUseArea( .t., cDriver(), cPath + "ALBPROVL.DBF", cCheckArea( "ALBPROVL", @cAlbPrvL ), .f. )
      ordListAdd( cPath + "AlbProvL.Cdx"  )

      dbUseArea( .t., cDriver(), cPath + "AlbPrvI.Dbf", cCheckArea( "AlbPrvI", @cAlbPrvI ), .f. )
      ( cAlbPrvI )->( ordListAdd( cPath + "AlbPrvI.Cdx"  ) )

      dbUseArea( .t., cDriver(), cPath + "AlbPrvD.Dbf", cCheckArea( "AlbPrvD", @cAlbPrvD ), .f. )
      ( cAlbPrvD )->( ordListAdd( cPath + "AlbPrvD.Cdx"  ) )

      dbUseArea( .t., cDriver(), cPathOld + "ALBPROVT.DBF", cCheckArea( "ALBPROVT", @oldAlbPrvT ), .f. )
      ordListAdd( cPathOld + "AlbProvT.Cdx"  )

      dbUseArea( .t., cDriver(), cPathOld + "ALBPROVL.DBF", cCheckArea( "ALBPROVL", @oldAlbPrvL ), .f. )
      ordListAdd( cPathOld + "AlbProvL.Cdx"  )

      dbUseArea( .t., cDriver(), cPathOld + "ALBPRVI.Dbf", cCheckArea( "ALBPRVI", @oldAlbPrvI ), .f. )
      ( oldAlbPrvI )->( ordListAdd( cPathOld + "AlbPrvI.Cdx"  ) )

      dbUseArea( .t., cDriver(), cPathOld + "ALBPRVD.Dbf", cCheckArea( "ALBPRVD", @oldAlbPrvD ), .f. )
      ( oldAlbPrvD )->( ordListAdd( cPathOld + "AlbPrvD.Cdx"  ) )

      /*
      Pasamos los datos
      */

      while !( oldAlbPrvT )->( eof() )

         if eval( bFor, oldAlbPrvT )

            dbCopy( oldAlbPrvT, cAlbPrvT, .t. )

            if ( oldAlbPrvL )->( dbSeek( (oldAlbPrvT)->CSERALB + Str( (oldAlbPrvT)->NNUMALB ) + (oldAlbPrvT)->CSUFALB ) )
               while ( oldAlbPrvL )->CSERALB + Str( ( oldAlbPrvL )->NNUMALB ) + ( oldAlbPrvL )->CSUFALB == (oldAlbPrvT)->CSERALB + Str( (cAlbPrvT)->NNUMALB ) + (cAlbPrvT)->CSUFALB .and. !(oldAlbPrvL)->( eof() )
                  dbCopy( oldAlbPrvL, cAlbPrvL, .t. )
                  ( oldAlbPrvL )->( dbSkip() )
               end while
            end if

            if ( oldAlbPrvI )->( dbSeek( (oldAlbPrvT)->CSERALB + Str( (oldAlbPrvT)->NNUMALB ) + (oldAlbPrvT)->CSUFALB ) )
               while ( oldAlbPrvI )->CSERALB + Str( ( oldAlbPrvI )->NNUMALB ) + ( oldAlbPrvI )->CSUFALB == ( oldAlbPrvT )->CSERALB + Str( ( cAlbPrvT )->NNUMALB ) + ( cAlbPrvT )->CSUFALB .and. !( oldAlbPrvI )->( eof() )
                  dbCopy( oldAlbPrvI, cAlbPrvI, .t. )
                  ( oldAlbPrvI )->( dbSkip() )
               end while
            end if

            if ( oldAlbPrvD )->( dbSeek( (oldAlbPrvT)->CSERALB + Str( (oldAlbPrvT)->NNUMALB ) + (oldAlbPrvT)->CSUFALB ) )
               while ( oldAlbPrvD )->CSERALB + Str( ( oldAlbPrvD )->NNUMALB ) + ( oldAlbPrvD )->CSUFALB == ( oldAlbPrvT )->CSERALB + Str( ( cAlbPrvT )->NNUMALB ) + ( cAlbPrvT )->CSUFALB .and. !( oldAlbPrvI )->( eof() )
                  dbCopy( oldAlbPrvD, cAlbPrvD, .t. )
                  ( oldAlbPrvD )->( dbSkip() )
               end while
            end if

         end if

         ( oldAlbPrvT )->( dbSkip() )

      end while

      /*
      Cerramos las bases de datos----------------------------------------------
      */

      ( cAlbPrvT )->( dbCloseArea() )
      ( cAlbPrvL )->( dbCloseArea() )
      ( cAlbPrvI )->( dbCloseArea() )
      ( cAlbPrvD )->( dbCloseArea() )

      ( oldAlbPrvT )->( dbCloseArea() )
      ( oldAlbPrvL )->( dbCloseArea() )
      ( oldAlbPrvI )->( dbCloseArea() )
      ( oldAlbPrvD )->( dbCloseArea() )

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos de agentes" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   END IF

RETURN nil

//---------------------------------------------------------------------------//

FUNCTION rxAlbPrv( cPath, cDriver )

   local cAlbPrvT

   DEFAULT cPath     := cPatEmp()
   DEFAULT cDriver   := cDriver()

   if !lExistTable( cPath + "ALBPROVT.DBF", cDriver ) .or. ;
      !lExistTable( cPath + "ALBPROVL.DBF", cDriver ) .or. ;
      !lExistTable( cPath + "ALBPRVI.DBF", cDriver )  .or. ;
      !lExistTable( cPath + "ALBPRVD.DBF", cDriver )  .or. ;
      !lExistTable( cPath + "AlbPrvS.DBF", cDriver )
      createFiles( cPath )
   end if

   /*
   Eliminamos los indices
   */

   fEraseIndex( cPath + "AlbProvT.Cdx", cDriver )
   fEraseIndex( cPath + "AlbProvL.Cdx", cDriver )
   fEraseIndex( cPath + "AlbPrvI.Cdx", cDriver )
   fEraseIndex( cPath + "AlbPrvD.Cdx", cDriver )
   fEraseIndex( cPath + "AlbPrvS.Cdx", cDriver )

   dbUseArea( .t., cDriver, cPath + "ALBPROVT.DBF", cCheckArea( "ALBPROVT", @cAlbPrvT ), .f. )

   if !( cAlbPrvT )->( neterr() )
      ( cAlbPrvT)->( __dbPack() )

      ( cAlbPrvT)->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cAlbPrvT)->( ordCreate( cPath + "AlbProvT.Cdx", "NNUMALB", "CSERALB + STR( NNUMALB ) + CSUFALB", {|| Field->cSerAlb + STR( Field->nNumAlb ) + Field->CSUFALB } ) )

      ( cAlbPrvT)->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cAlbPrvT)->( ordCreate( cPath + "AlbProvT.Cdx", "DFECALB", "DFECALB", {|| Field->DFECALB } ) )

      ( cAlbPrvT)->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cAlbPrvT)->( ordCreate( cPath + "AlbProvT.Cdx", "CCODPRV", "CCODPRV", {|| Field->CCODPRV } ) )

      ( cAlbPrvT)->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cAlbPrvT)->( ordCreate( cPath + "AlbProvT.Cdx", "CNOMPRV", "Upper( CNOMPRV )", {|| Upper( Field->CNOMPRV ) } ) )

      ( cAlbPrvT)->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cAlbPrvT)->( ordCreate( cPath + "AlbProvT.Cdx", "CSUALB", "CSUALB", {|| Field->CSUALB } ) )

      ( cAlbPrvT)->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( cAlbPrvT)->( ordCreate( cPath + "AlbProvT.Cdx", "CNUMFAC", "CNUMFAC", {|| Field->CNUMFAC }, ) )

      ( cAlbPrvT)->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cAlbPrvT)->( ordCreate( cPath + "AlbProvT.Cdx", "CTURALB", "CTURALB + CSUFALB + cCodCaj", {|| Field->CTURALB + Field->CSUFALB + Field->cCodCaj } ) )

      ( cAlbPrvT)->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cAlbPrvT)->( ordCreate( cPath + "AlbProvT.Cdx", "CNUMPED", "CNUMPED", {|| Field->CNUMPED } ) )

      ( cAlbPrvT)->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cAlbPrvT)->( ordCreate( cPath + "AlbProvT.Cdx", "cCodUsr", "Field->cCodUsr + Dtos( Field->dFecChg ) + Field->cTimChg", {|| Field->cCodUsr + Dtos( Field->dFecChg ) + Field->cTimChg } ) )

      ( cAlbPrvT)->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cAlbPrvT)->( ordCreate( cPath + "AlbProvT.Cdx", "iNumAlb", "'02' + CSERALB + STR( NNUMALB ) + Space( 1 ) + CSUFALB", {|| '02' + Field->cSerAlb + STR( Field->nNumAlb ) + Space( 1 ) + Field->CSUFALB } ) )

      ( cAlbPrvT)->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cAlbPrvT)->( ordCreate( cPath + "AlbProvT.Cdx", "cCtrCoste", "cCtrCoste", {|| Field->cCtrCoste } ) )

      ( cAlbPrvT)->( ordCondSet("!Deleted()", {||!Deleted()}, , , , , , , , , .t.  ) )
      ( cAlbPrvT)->( ordCreate( cPath + "AlbProvT.Cdx", "DDESFEC", "DFECALB", {|| Field->DFECALB } ) )

      ( cAlbPrvT )->( dbCloseArea() )

   else

      msgStop( "Imposible abrir en modo exclusivo la tabla de albaranes de proveedores" )

   end if

   dbUseArea( .t., cDriver, cPath + "ALBPROVL.DBF", cCheckArea( "ALBPROVL", @cAlbPrvT ), .f. )

   if !( cAlbPrvT )->( neterr() )
      ( cAlbPrvT)->( __dbPack() )

      ( cAlbPrvT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cAlbPrvT )->( ordCreate( cPath + "AlbProvL.Cdx", "nNumAlb", "cSerAlb + Str( nNumAlb ) + cSufAlb", {|| Field->cSerAlb + STR( Field->nNumAlb ) + Field->cSufAlb } ) )

      ( cAlbPrvT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cAlbPrvT )->( ordCreate( cPath + "AlbProvL.Cdx", "nNumLin", "cSerAlb + Str( nNumAlb ) + cSufAlb + Str( nNumLin )", {|| Field->cSerAlb + Str( Field->nNumAlb ) + Field->cSufAlb + Str( Field->nNumLin ) } ) )

      ( cAlbPrvT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cAlbPrvT )->( ordCreate( cPath + "AlbProvL.Cdx", "cRef", "cRef + cValPr1 + cValPr2", {|| Field->cRef + Field->cValPr1 + Field->cValPr2 } ) )

      ( cAlbPrvT )->( ordCondSet( "!Deleted()", {||!Deleted()}  ) )
      ( cAlbPrvT )->( ordCreate( cPath + "AlbProvL.Cdx", "Lote", "cLote", {|| Field->cLote } ) )

      ( cAlbPrvT)->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cAlbPrvT)->( ordCreate( cPath + "AlbProvL.Cdx", "cNumPed", "cNumPed", {|| Field->cNumPed } ) )

      ( cAlbPrvT)->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cAlbPrvT)->( ordCreate( cPath + "AlbProvL.Cdx", "cPedCliRef", "cNumPed + cRef + cCodPr1 + cCodPr2 + cValPr1 + cValPr2", {|| Field->cNumPed + Field->cRef + Field->cCodPr1 + Field->cCodPr2  + Field->cValPr1 + Field->cValPr2 } ) )

      ( cAlbPrvT)->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cAlbPrvT)->( ordCreate( cPath + "AlbProvL.Cdx", "cCodPed", "cCodPed", {|| Field->cCodPed } ) )

      ( cAlbPrvT)->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cAlbPrvT)->( ordCreate( cPath + "AlbProvL.Cdx", "cPedPrvRef", "cCodPed + cRef + cValPr1 + cValPr2 + cLote", {|| Field->cCodPed + Field->cRef + Field->cValPr1 + Field->cValPr2 + Field->cLote } ) )

      ( cAlbPrvT)->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cAlbPrvT)->( ordCreate( cPath + "AlbProvL.Cdx", "cPedPrvDet", "cCodPed + cRef + cValPr1 + cValPr2 + cRefPrv ", {|| Field->cCodPed + Field->cRef + Field->cValPr1 + Field->cValPr2 + Field->cRefPrv } ) ) // + cDetalle

      ( cAlbPrvT )->( ordCondSet( "!lFacturado .and. !Deleted()", {|| !Field->lFacturado .and. !Deleted()}, , , , , , , , , .f. ) )
      ( cAlbPrvT )->( ordCreate( cPath + "AlbProvL.Cdx", "cStkRef", "cRef + cValPr1 + cValPr2 + cLote", {|| Field->cRef + Field->cValPr1 + Field->cValPr2 + Field->cLote } ) )

      ( cAlbPrvT)->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cAlbPrvT)->( ordCreate( cPath + "AlbProvL.Cdx", "cPCliDet", "cNumPed + cRef + cValPr1 + cValPr2 + cLote ", {|| Field->cNumPed + Field->cRef + Field->cValPr1 + Field->cValPr2 + Field->cLote } ) ) // + cDetalle

      ( cAlbPrvT)->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cAlbPrvT)->( ordCreate( cPath + "AlbProvL.Cdx", "cPedRef", "cCodPed + cRef", {|| Field->cCodPed + Field->cRef } ) )

      ( cAlbPrvT)->( ordCondSet("!Deleted() .and. !lFacturado", {||!Deleted() .and. !Field->lFacturado }, , , , , , , , , .t.  ) )
      ( cAlbPrvT)->( ordCreate( cPath + "AlbProvL.Cdx", "cRefFec", "cRef + dtos( dFecAlb )", {|| Field->cRef + dtos( Field->dFecAlb ) } ) )

      ( cAlbPrvT)->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cAlbPrvT)->( ordCreate( cPath + "AlbProvL.Cdx", "iNumAlb", "'02' + CSERALB + STR( NNUMALB ) + CSUFALB", {|| '02' + Field->cSerAlb + STR( Field->nNumAlb ) + Field->cSufAlb } ) )

      ( cAlbPrvT )->( ordCondSet( "!lFacturado .and. !Deleted()", {|| !Field->lFacturado .and. !Deleted() } ) )
      ( cAlbPrvT )->( ordCreate( cPath + "AlbProvL.Cdx", "cArtLote", "cRef + cLote", {|| Field->cRef + Field->cLote } ) )

      ( cAlbPrvT )->( ordCondSet( "!lFacturado .and. nCtlStk < 2 .and. !Deleted()", {|| !Field->lFacturado .and. Field->nCtlStk < 2 .and. !Deleted()}, , , , , , , , , .t. ) )
      ( cAlbPrvT )->( ordCreate( cPath + "AlbProvL.Cdx", "cStkFastIn", "cRef + cAlmLin + dtos( dFecAlb ) + tFecAlb", {|| Field->cRef + Field->cAlmLin + dtos( Field->dFecAlb ) + Field->tFecAlb } ) )

      ( cAlbPrvT )->( ordCondSet( "!lFacturado .and. nCtlStk < 2 .and. !Deleted()", {|| !Field->lFacturado .and. Field->nCtlStk < 2 .and. !Deleted()}, , , , , , , , , .t. ) )
      ( cAlbPrvT )->( ordCreate( cPath + "AlbProvL.Cdx", "cStkFastOu", "cRef + cAlmOrigen + dtos( dFecAlb ) + tFecAlb", {|| Field->cRef + Field->cAlmOrigen + dtos( Field->dFecAlb ) + Field->tFecAlb } ) )

      ( cAlbPrvT )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( cAlbPrvT )->( ordCreate( cPath + "AlbProvL.Cdx", "cRefFec", "cRef + cLote + dTos( dFecAlb )", {|| Field->cRef + Field->cLote + dTos( Field->dFecAlb ) } ) )

      ( cAlbPrvT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cAlbPrvT )->( ordCreate( cPath + "AlbProvL.Cdx", "nPosPrint", "cSerAlb + Str( nNumAlb ) + cSufAlb + Str( nPosPrint )", {|| Field->cSerAlb + Str( Field->nNumAlb ) + Field->cSufAlb + Str( Field->nPosPrint ) } ) )

      ( cAlbPrvT )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de albaranes de proveedores" )
   end if

   dbUseArea( .t., cDriver, cPath + "AlbPrvI.DBF", cCheckArea( "AlbPrvI", @cAlbPrvT ), .f. )

   if !( cAlbPrvT )->( neterr() )
      ( cAlbPrvT )->( __dbPack() )

      ( cAlbPrvT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cAlbPrvT )->( ordCreate( cPath + "AlbPrvI.Cdx", "NNUMALB", "CSERALB + STR( NNUMALB ) + CSUFALB", {|| Field->cSerAlb + Str( Field->nNumAlb ) + Field->cSufAlb } ) )

      ( cAlbPrvT )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de albaranes de proveedores" )
   end if

   dbUseArea( .t., cDriver, cPath + "AlbPrvD.DBF", cCheckArea( "AlbPrvD", @cAlbPrvT ), .f. )

   if !( cAlbPrvT )->( neterr() )
      ( cAlbPrvT )->( __dbPack() )

      ( cAlbPrvT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cAlbPrvT )->( ordCreate( cPath + "AlbPrvD.Cdx", "NNUMALB", "CSERALB + STR( NNUMALB ) + CSUFALB", {|| Field->cSerAlb + Str( Field->nNumAlb ) + Field->cSufAlb } ) )

      ( cAlbPrvT )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de albaranes de proveedores" )
   end if

   dbUseArea( .t., cDriver, cPath + "AlbPrvS.DBF", cCheckArea( "AlbPrvS", @cAlbPrvT ), .f. )
   if !( cAlbPrvT )->( neterr() )
      ( cAlbPrvT )->( __dbPack() )

      ( cAlbPrvT )->( ordCondSet( "!Deleted()", {||!Deleted()}  ) )
      ( cAlbPrvT )->( ordCreate( cPath + "AlbPrvS.CDX", "nNumAlb", "cSerAlb + Str( nNumAlb ) + cSufAlb + Str( nNumLin )", {|| Field->cSerAlb + Str( Field->nNumAlb ) + Field->cSufAlb + Str( Field->nNumLin ) } ) )

      ( cAlbPrvT )->( ordCondSet( "!lFacturado .and. !Deleted()", {|| !Field->lFacturado .and. !Deleted() }  ) )
      ( cAlbPrvT )->( ordCreate( cPath + "AlbPrvS.CDX", "cRefSer", "cRef + cAlmLin + cNumSer", {|| Field->cRef + Field->cAlmLin + Field->cNumSer } ) )

      ( cAlbPrvT )->( ordCondSet( "!Deleted()", {|| !Field->lFacturado .and. !Deleted() }  ) )
      ( cAlbPrvT )->( ordCreate( cPath + "AlbPrvS.CDX", "cNumSer", "cNumSer", {|| Field->cNumSer } ) )

      ( cAlbPrvT )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de numeros de series de albaranes de proveedores" )
   end if

RETURN NIL

//--------------------------------------------------------------------------//

FUNCTION aIncAlbPrv()

   local aIncAlbPrv  := {}

   aAdd( aIncAlbPrv, { "cSerAlb", "C",    1,  0, "Serie de albarán" ,                "",                   "", "( cDbfCol )" } )
   aAdd( aIncAlbPrv, { "nNumAlb", "N",    9,  0, "Número de albarán" ,               "'999999999'",        "", "( cDbfCol )" } )
   aAdd( aIncAlbPrv, { "cSufAlb", "C",    2,  0, "Sufijo de albarán" ,               "",                   "", "( cDbfCol )" } )
   aAdd( aIncAlbPrv, { "cCodTip", "C",    3,  0, "Tipo de incidencia" ,              "",                   "", "( cDbfCol )" } )
   aAdd( aIncAlbPrv, { "dFecInc", "D",    8,  0, "Fecha de la incidencia" ,          "",                   "", "( cDbfCol )" } )
   aAdd( aIncAlbPrv, { "mDesInc", "M",   10,  0, "Descripción de la incidencia" ,    "",                   "", "( cDbfCol )" } )
   aAdd( aIncAlbPrv, { "lListo",  "L",    1,  0, "Lógico de listo" ,                 "",                   "", "( cDbfCol )" } )
   aAdd( aIncAlbPrv, { "lAviso",  "L",    1,  0, "Lógico de aviso" ,                 "",                   "", "( cDbfCol )" } )

RETURN ( aIncAlbPrv )

//---------------------------------------------------------------------------//

FUNCTION aAlbPrvDoc()

   local aAlbPrvDoc  := {}

   aAdd( aAlbPrvDoc, { "cSerAlb", "C",    1,  0, "Serie del albarán" ,               "",                   "", "( cDbfCol )" } )
   aAdd( aAlbPrvDoc, { "nNumAlb", "N",    9,  0, "Número del albarán" ,              "'999999999'",        "", "( cDbfCol )" } )
   aAdd( aAlbPrvDoc, { "cSufAlb", "C",    2,  0, "Sufijo del albarán" ,              "",                   "", "( cDbfCol )" } )
   aAdd( aAlbPrvDoc, { "cNombre", "C",  240,  0, "Nombre del documento" ,            "",                   "", "( cDbfCol )" } )
   aAdd( aAlbPrvDoc, { "cRuta",   "C",  240,  0, "Ruta del documento" ,              "",                   "", "( cDbfCol )" } )
   aAdd( aAlbPrvDoc, { "mObsDoc", "M",   10,  0, "Observaciones del documento" ,     "",                   "", "( cDbfCol )" } )

RETURN ( aAlbPrvDoc )

//---------------------------------------------------------------------------//

/*
Devuelve la fecha de un albaran de proveedor
*/

FUNCTION dFecAlbPrv( cAlbPrv, cAlbPrvT )

   local dFecFac  := CtoD("")

   if ( cAlbPrvT )->( dbSeek( cAlbPrv ) )
      dFecFac     := ( cAlbPrvT )->dFecAlb
   end if

RETURN ( dFecFac )

//---------------------------------------------------------------------------//

/*
Devuelve la Hora de un albaran de proveedor
*/

FUNCTION tFecAlbPrv( cAlbPrv, cAlbPrvT )

   local tFecFac  := Replicate( "0", 6 )

   if ( cAlbPrvT )->( dbSeek( cAlbPrv ) )
      tFecFac     := ( cAlbPrvT )->tFecAlb
   end if

RETURN ( tFecFac )

//----------------------------------------------------------------------------//

/*
Devuelve el nombre del proveedor de un albaran de proveedor
*/

FUNCTION cNbrAlbPrv( cAlbPrv, cAlbPrvT )

   local cNomPrv  := ""

   if ( cAlbPrvT )->( dbSeek( cAlbPrv ) )
      cNomPrv     := ( cAlbPrvT )->cNomPrv
   end if

RETURN ( cNomPrv )

//----------------------------------------------------------------------------//

/*
Devuelve si el albaran esta facturado
*/

FUNCTION lFacAlbPrv( cAlbPrv, cAlbPrvT )

   local lFacAlb  := .f.

   if ( cAlbPrvT )->( dbSeek( cAlbPrv ) )
      lFacAlb     := ( ( cAlbPrvT )->nFacturado == 3 )
   end if

RETURN ( lFacAlb )

//----------------------------------------------------------------------------//
//
// Devuelve el total de la compra en albaranes de proveedores de un articulo
//

FUNCTION nTotVAlbPrv( cCodArt, cAlbPrvL )

   local nTotVta  := 0
   local nRecno   := ( cAlbPrvL )->( Recno() )

   if ( cAlbPrvL )->( dbSeek( cCodArt ) )

      while ( cAlbPrvL )->CREF == cCodArt .and. !( cAlbPrvL )->( eof() )

         nTotVta += nTotLAlbPrv( cAlbPrvL, 0 )
         ( cAlbPrvL )->( dbSkip() )

      end while

   end if

   ( cAlbPrvL )->( dbGoTo( nRecno ) )

RETURN ( nTotVta )

//----------------------------------------------------------------------------//
//
// Devuelve el total de unidades de la compra en albaranes de proveedores de un articulo
//

FUNCTION nTotDAlbPrv( cCodArt, cAlbPrvL, cAlbPrvT, cCodAlm )

   local lFacAlb  := .f.
   local nTotVta  := 0
   local nRecno   := ( cAlbPrvL )->( Recno() )

   if ( cAlbPrvL )->( dbSeek( cCodArt ) )

      while ( cAlbPrvL )->cRef == cCodArt .and. !( cAlbPrvL )->( eof() )

         if cAlbPrvT != nil
            lFacAlb     := lFacAlbPrv( ( cAlbPrvL )->cSerAlb + Str( ( cAlbPrvL )->nNumAlb ) + ( cAlbPrvL )->CSUFALB, cAlbPrvT )
         end if

         if !lFacAlb
            if cCodAlm != nil
               if cCodAlm == ( cAlbPrvL )->cAlmLin
                  nTotVta  += nTotNAlbPrv( cAlbPrvL )
               end if
            else
               nTotVta     += nTotNAlbPrv( cAlbPrvL )
            end if
         end if

         ( cAlbPrvL )->( dbSkip() )

      end while

   end if

   ( cAlbPrvL )->( dbGoTo( nRecno ) )

RETURN ( nTotVta )

//---------------------------------------------------------------------------//
//
// Devuelve el precio de compra real de un articulo una vez aplicados los descuentos
//

FUNCTION nPreAlbPrv( cAlbPrvL, uTmp, nDec, nRec )

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

   if !Empty( nView )
   DEFAULT nDec   := nDinDiv( cDivAlb, D():Divisas( nView ) )
   DEFAULT nRec   := nRinDiv( cDivAlb, D():Divisas( nView ) )
   end if

   nCalculo       := nTotLAlbPrv( cAlbPrvL, nDec, nRec )

   If nDtoEsp != 0
      nCalculo    -= nCalculo * nDtoEsp / 100
   end if

   If nDtoPp != 0
      nCalculo    -= nCalculo * nDtoPp / 100
   end if

RETURN ( round( nCalculo, nDec ) )

//---------------------------------------------------------------------------//

static FUNCTION bGenAlb( nDevice, cTitle, cCodDoc )

   local bGen
   local nDev  := by( nDevice )
   local cTit  := by( cTitle  )
   local cCod  := by( cCodDoc )

   if nDev == IS_PRINTER
      bGen     := {|| nGenAlbPrv( nDevice, cTit, cCod ) }
   else
      bGen     := {|| GenAlbPrv( nDevice, cTit, cCod ) }
   end if

RETURN bGen

//---------------------------------------------------------------------------//

FUNCTION Ped2Alb( cNumPed, lZoom )

   local oBlock
   local oError
   local cNumAlb
   local cAlbPrvT

   DEFAULT lZoom  := .f.

   oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   USE ( cPatEmp() + "ALBPROVT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALBPROVT", @cAlbPrvT ) )
   SET ADSINDEX TO ( cPatEmp() + "AlbProvT.Cdx" ) ADDITIVE
   ( cAlbPrvT )->( OrdSetFocus( "cNumPed" ) )

   if ( cAlbPrvT )->( dbSeek( cNumPed ) )
      cNumAlb     := ( cAlbPrvT )->cSerAlb + Str( ( cAlbPrvT )->nNumAlb ) + ( cAlbPrvT )->cSufAlb
   end if

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos de albaranes de proveedores" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   CLOSE( cAlbPrvT )

   if !Empty( cNumAlb )
      if lZoom
         ZooAlbPrv( cNumAlb )
      else
         EdtAlbPrv( cNumAlb )
      end if
   else
      msgStop( "No hay albarán asociado" )
   end if

RETURN NIL

//---------------------------------------------------------------------------//

FUNCTION nVtaAlbPrv( cCodPrv, dDesde, dHasta, cAlbPrvT, cAlbPrvL, cIva, cDiv )

   local nCon     := 0
   local nRec     := ( cAlbPrvT )->( Recno() )

   /*
   Facturas a Clientes -------------------------------------------------------
   */

   if ( cAlbPrvT )->( dbSeek( cCodPrv ) )

      while ( cAlbPrvT )->cCodPrv == cCodPrv .and. !( cAlbPrvT )->( Eof() )

         if ( dDesde == nil .or. ( cAlbPrvT )->dFecAlb >= dDesde )    .and.;
            ( dHasta == nil .or. ( cAlbPrvT )->dFecAlb <= dHasta )

            nCon  += nTotAlbPrv( ( cAlbPrvT )->cSerAlb + Str( ( cAlbPrvT )->nNumAlb ) + ( cAlbPrvT )->cSufAlb, cAlbPrvT, cAlbPrvL, cIva, cDiv, nil, cDivEmp(), .f. )

         end if

         ( cAlbPrvT )->( dbSkip() )

      end while

   end if

   ( cAlbPrvT )->( dbGoTo( nRec ) )

RETURN nCon

//---------------------------------------------------------------------------//

/*
Cambia el precio
*/

FUNCTION CambioPrecio( dFecha, cArticulo, dbfTmp )

   if dbDialogLock( cArticulo )

      if ( dbfTmp )->nPreCom > 0
         ( cArticulo )->pCosto    := ( dbfTmp )->nPreCom
      end if

      ( cArticulo )->lBnf1        := ( dbfTmp )->lBnfLin1
      ( cArticulo )->lBnf2        := ( dbfTmp )->lBnfLin2
      ( cArticulo )->lBnf3        := ( dbfTmp )->lBnfLin3
      ( cArticulo )->lBnf4        := ( dbfTmp )->lBnfLin4
      ( cArticulo )->lBnf5        := ( dbfTmp )->lBnfLin5
      ( cArticulo )->lBnf6        := ( dbfTmp )->lBnfLin6

      ( cArticulo )->Benef1       := ( dbfTmp )->nBnfLin1
      ( cArticulo )->Benef2       := ( dbfTmp )->nBnfLin2
      ( cArticulo )->Benef3       := ( dbfTmp )->nBnfLin3
      ( cArticulo )->Benef4       := ( dbfTmp )->nBnfLin4
      ( cArticulo )->Benef5       := ( dbfTmp )->nBnfLin5
      ( cArticulo )->Benef6       := ( dbfTmp )->nBnfLin6

      ( cArticulo )->lIvaInc      := ( dbfTmp )->lIvaLin

      ( cArticulo )->pVenta1      := ( dbfTmp )->nPvpLin1
      ( cArticulo )->pVtaIva1     := ( dbfTmp )->nIvaLin1
      ( cArticulo )->pVenta2      := ( dbfTmp )->nPvpLin2
      ( cArticulo )->pVtaIva2     := ( dbfTmp )->nIvaLin2
      ( cArticulo )->pVenta3      := ( dbfTmp )->nPvpLin3
      ( cArticulo )->pVtaIva3     := ( dbfTmp )->nIvaLin3
      ( cArticulo )->pVenta4      := ( dbfTmp )->nPvpLin4
      ( cArticulo )->pVtaIva4     := ( dbfTmp )->nIvaLin4
      ( cArticulo )->pVenta5      := ( dbfTmp )->nPvpLin5
      ( cArticulo )->pVtaIva5     := ( dbfTmp )->nIvaLin5
      ( cArticulo )->pVenta6      := ( dbfTmp )->nPvpLin6
      ( cArticulo )->pVtaIva6     := ( dbfTmp )->nIvaLin6

      /*
      Marca para etiqueta
      */

      ( cArticulo )->lLabel       := .t.
      ( cArticulo )->nLabel       := Max( ( cArticulo )->nLabel, 1 )

      /*
      Marca para el cambio
      */

      ( cArticulo )->dFecChg      := date()

      if dFecha >= ( cArticulo )->LastIn
         ( cArticulo )->LastIn    := dFecha
      end if

      ( cArticulo )->lSndDoc      := .t.
      ( cArticulo )->LastChg      := GetSysDate()

      /*
      Pasamos tambien la unidad de medición------------------------------------
      */

      ( cArticulo )->cUnidad      := ( dbfTmp )->cUnidad

      /*
      Desbloqueo del registro
      */

      ( cArticulo )->( dbRUnLock() )

   end if

RETURN NIL

//---------------------------------------------------------------------------//

FUNCTION nTotNAlbPrv( uDbf )

   local nTotUnd

   DEFAULT uDbf   := if( !Empty( tmpAlbPrvL ), tmpAlbPrvL, D():AlbaranesProveedoresLineas( nView ) )

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

RETURN ( if( cPorDiv != nil, Trans( nCalculo, cPorDiv ), nCalculo ) )

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

FUNCTION nIvaLAlbPrv( uAlbPrvL, nDec, nRou, nVdv, cPorDiv )

   local nCalculo 

   DEFAULT uAlbPrvL  := D():AlbaranesProveedoresLineas( nView )
   DEFAULT nDec      := nDinDiv()
   DEFAULT nRou      := nRinDiv()
   DEFAULT nVdv      := 1

   nCalculo          := nTotLAlbPrv( uAlbPrvL, nDec, nRou, nVdv )

   nCalculo          := Round( nCalculo * ( uAlbPrvL )->nIva / 100, nRou )

RETURN ( if( cPorDiv != nil, Trans( nCalculo, cPorDiv ), nCalculo ) )

//---------------------------------------------------------------------------//

FUNCTION aItmAlbPrv()

   local aItmAlbPrv  := {}

   aAdd( aItmAlbPrv, { "CSERALB",      "C",  1,  0, "Serie del albarán",           "",                   "", "( cDbf )"} )
   aAdd( aItmAlbPrv, { "NNUMALB",      "N",  9,  0, "Número del albarán",          "'999999999'",        "", "( cDbf )"} )
   aAdd( aItmAlbPrv, { "CSUFALB",      "C",  2,  0, "Sufijo de albarán",           "",                   "", "( cDbf )"} )
   aAdd( aItmAlbPrv, { "CTURALB",      "C",  6,  0, "Sesión del albarán",          "",                   "", "( cDbf )"} )
   aAdd( aItmAlbPrv, { "DFECALB",      "D",  8,  0, "Fecha del albarán",           "",                   "", "( cDbf )"} )
   aAdd( aItmAlbPrv, { "CCODPRV",      "C", 12,  0, "Código del proveedor",        "",                   "", "( cDbf )"} )
   aAdd( aItmAlbPrv, { "CCODALM",      "C", 16,  0, "Código de almacén",           "",                   "", "( cDbf )"} )
   aAdd( aItmAlbPrv, { "CCODCAJ",      "C",  3,  0, "Código de caja",              "",                   "", "( cDbf )"} )
   aAdd( aItmAlbPrv, { "CNOMPRV",      "C",150,  0, "Nombre del proveedor",        "'@!'",               "", "( cDbf )"} )
   aAdd( aItmAlbPrv, { "CDIRPRV",      "C",200,  0, "Domicilio del proveedor",     "'@!'",               "", "( cDbf )"} )
   aAdd( aItmAlbPrv, { "CPOBPRV",      "C",200,  0, "Población del proveedor",     "'@!'",               "", "( cDbf )"} )
   aAdd( aItmAlbPrv, { "CPROPRV",      "C",100,  0, "Provincia del proveedor",     "'@!'",               "", "( cDbf )"} )
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
   aAdd( aItmAlbPrv, { "LFACTURADO",   "L",  1,  0, "",                            "",                   "", "( cDbf )"} )
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
   aAdd( aItmAlbPrv, { "nRegIva",      "N",  1,  0, "Regimen de " + cImp(),        "",                   "", "( cDbf )"} )
   aAdd( aItmAlbPrv, { "nTotNet",      "N", 16,  6, "Total neto",                  "",                   "", "( cDbf )"} )
   aAdd( aItmAlbPrv, { "nTotIva",      "N", 16,  6, "Total " + cImp(),             "",                   "", "( cDbf )"} )
   aAdd( aItmAlbPrv, { "nTotReq",      "N", 16,  6, "Total R.E.",                  "",                   "", "( cDbf )"} )
   aAdd( aItmAlbPrv, { "nTotAlb",      "N", 16,  6, "Total albarán",               "",                   "", "( cDbf )"} )
   aAdd( aItmAlbPrv, { "cAlmOrigen",   "C", 16,  0, "Almacén de origen de la mercancía","",              "", "( cDbf )"} )
   aAdd( aItmAlbPrv, { "nFacturado",   "N",  1,  0, "Estado del albarán",          "",                   "", "( cDbf )"} )
   aAdd( aItmAlbPrv, { "tFecAlb",      "C",  6,  0, "Hora del albarán" ,           "",                   "", "( cDbf )"} )
   aAdd( aItmAlbPrv, { "cCtrCoste",    "C",  9,  0, "Código del centro de coste" , "",                   "", "( cDbf )"} )

RETURN ( aItmAlbPrv )

//---------------------------------------------------------------------------//

FUNCTION aColAlbPrv()

   local aColAlbPrv  := {}

   aAdd( aColAlbPrv, { "cSerAlb",      "C",  1,  0, "Serie del albarán",                     "Serie",                      "", "( cDbfCol )", nil } )
   aAdd( aColAlbPrv, { "nNumAlb",      "N",  9,  0, "Número de albarán",                     "Numero",                     "", "( cDbfCol )", nil } )
   aAdd( aColAlbPrv, { "cSufAlb",      "C",  2,  0, "Sufijo de albarán",                     "Sufijo",                     "", "( cDbfCol )", nil } )
   aAdd( aColAlbPrv, { "cRef",         "c", 18,  0, "Código de artículo",                    "Articulo",                   "", "( cDbfCol )", nil } )
   aAdd( aColAlbPrv, { "cRefPrv",      "C", 18,  0, "Referencia del proveedor",              "",                           "", "( cDbfCol )", nil } )
   aAdd( aColAlbPrv, { "cDetAlle",     "C",240,  0, "Nombre del artículo",                   "DescripcionArticulo",        "", "( cDbfCol )", nil } )
   aAdd( aColAlbPrv, { "nIva",         "n",  6,  2, cImp() + " del artículo",                "PorcentajeImpuesto",         "", "( cDbfCol )", nil } )
   aAdd( aColAlbPrv, { "nUniCaja",     "N", 16,  6, "Unidades por caja",                     "Unidades",                   "", "( cDbfCol )", nil } )
   aAdd( aColAlbPrv, { "nCanEnt",      "N", 16,  6, "Cantidad recibida",                     "Cajas",                      "", "( cDbfCol )", nil } )
   aAdd( aColAlbPrv, { "nPreDiv",      "N", 16,  6, "Precio",                                "PrecioVenta",                "", "( cDbfCol )", nil } )
   aAdd( aColAlbPrv, { "nCanPed",      "N", 16,  6, "Cajas pedidas",                         "",                           "", "( cDbfCol )", nil } )
   aAdd( aColAlbPrv, { "nUniPed",      "N", 16,  6, "Unidades pedidas",                      "",                           "", "( cDbfCol )", nil } )
   aAdd( aColAlbPrv, { "cUniDad",      "C",  2,  0, cNombreUnidades(),                       "UnidadMedicion",             "", "( cDbfCol )", nil } )
   aAdd( aColAlbPrv, { "mLngDes",      "M", 10,  0, "Descripción de artículo sin codificar", "DescripcionAmpliada",        "", "( cDbfCol )", nil } )
   aAdd( aColAlbPrv, { "nDtoLin",      "N",  6,  2, "Descuento en líneas",                   "DescuentoPorcentual",        "", "( cDbfCol )", nil } )
   aAdd( aColAlbPrv, { "nDtoPrm",      "N",  6,  2, "Descuento por promociones",             "DescuentoPromocion",         "", "( cDbfCol )", nil } )
   aAdd( aColAlbPrv, { "nDtoRap",      "N",  6,  2, "Descuento por rappels",                 "",                           "", "( cDbfCol )", nil } )
   aAdd( aColAlbPrv, { "nPreCom",      "N", 16,  6, "Precio real de la compra",              "",                           "", "( cDbfCol )", nil } )
   aAdd( aColAlbPrv, { "lBnfLin1",     "L",  1,  0, "",                                      "",                           "", "( cDbfCol )", nil } )
   aAdd( aColAlbPrv, { "lBnfLin2",     "L",  1,  0, "",                                      "",                           "", "( cDbfCol )", nil } )
   aAdd( aColAlbPrv, { "lBnfLin3",     "L",  1,  0, "",                                      "",                           "", "( cDbfCol )", nil } )
   aAdd( aColAlbPrv, { "lBnfLin4",     "L",  1,  0, "",                                      "",                           "", "( cDbfCol )", nil } )
   aAdd( aColAlbPrv, { "lBnfLin5",     "L",  1,  0, "",                                      "",                           "", "( cDbfCol )", nil } )
   aAdd( aColAlbPrv, { "lBnfLin6",     "L",  1,  0, "",                                      "",                           "", "( cDbfCol )", nil } )
   aAdd( aColAlbPrv, { "nBnfLin1",     "N",  6,  2, "",                                      "",                           "", "( cDbfCol )", nil } )
   aAdd( aColAlbPrv, { "nBnfLin2",     "N",  6,  2, "",                                      "",                           "", "( cDbfCol )", nil } )
   aAdd( aColAlbPrv, { "nBnfLin3",     "N",  6,  2, "",                                      "",                           "", "( cDbfCol )", nil } )
   aAdd( aColAlbPrv, { "nBnfLin4",     "N",  6,  2, "",                                      "",                           "", "( cDbfCol )", nil } )
   aAdd( aColAlbPrv, { "nBnfLin5",     "N",  6,  2, "",                                      "",                           "", "( cDbfCol )", nil } )
   aAdd( aColAlbPrv, { "nBnfLin6",     "N",  6,  2, "",                                      "",                           "", "( cDbfCol )", nil } )
   aAdd( aColAlbPrv, { "nBnfSbr1",     "N",  1,  0, "",                                      "",                           "", "( cDbfCol )", nil } )
   aAdd( aColAlbPrv, { "nBnfSbr2",     "N",  1,  0, "",                                      "",                           "", "( cDbfCol )", nil } )
   aAdd( aColAlbPrv, { "nBnfSbr3",     "N",  1,  0, "",                                      "",                           "", "( cDbfCol )", nil } )
   aAdd( aColAlbPrv, { "nBnfSbr4",     "N",  1,  0, "",                                      "",                           "", "( cDbfCol )", nil } )
   aAdd( aColAlbPrv, { "nBnfSbr5",     "N",  1,  0, "",                                      "",                           "", "( cDbfCol )", nil } )
   aAdd( aColAlbPrv, { "nBnfSbr6",     "N",  1,  0, "",                                      "",                           "", "( cDbfCol )", nil } )
   aAdd( aColAlbPrv, { "nPvpLin1",     "N", 16,  6, "",                                      "",                           "", "( cDbfCol )", nil } )
   aAdd( aColAlbPrv, { "nPvpLin2",     "N", 16,  6, "",                                      "",                           "", "( cDbfCol )", nil } )
   aAdd( aColAlbPrv, { "nPvpLin3",     "N", 16,  6, "",                                      "",                           "", "( cDbfCol )", nil } )
   aAdd( aColAlbPrv, { "nPvpLin4",     "N", 16,  6, "",                                      "",                           "", "( cDbfCol )", nil } )
   aAdd( aColAlbPrv, { "nPvpLin5",     "N", 16,  6, "",                                      "",                           "", "( cDbfCol )", nil } )
   aAdd( aColAlbPrv, { "nPvpLin6",     "N", 16,  6, "",                                      "",                           "", "( cDbfCol )", nil } )
   aAdd( aColAlbPrv, { "nIvaLin1",     "N", 16,  6, "",                                      "",                           "", "( cDbfCol )", nil } )
   aAdd( aColAlbPrv, { "nIvaLin2",     "N", 16,  6, "",                                      "",                           "", "( cDbfCol )", nil } )
   aAdd( aColAlbPrv, { "nIvaLin3",     "N", 16,  6, "",                                      "",                           "", "( cDbfCol )", nil } )
   aAdd( aColAlbPrv, { "nIvaLin4",     "N", 16,  6, "",                                      "",                           "", "( cDbfCol )", nil } )
   aAdd( aColAlbPrv, { "nIvaLin5",     "N", 16,  6, "",                                      "",                           "", "( cDbfCol )", nil } )
   aAdd( aColAlbPrv, { "nIvaLin6",     "N", 16,  6, "",                                      "",                           "", "( cDbfCol )", nil } )
   aAdd( aColAlbPrv, { "nIvaLin",      "N",  6,  2, "",                                      "",                           "", "( cDbfCol )", nil } )
   aAdd( aColAlbPrv, { "lIvaLin",      "L",  1,  0, "",                                      "",                           "", "( cDbfCol )", nil } )
   aAdd( aColAlbPrv, { "lChgLin",      "L",  1,  0, "",                                      "",                           "", "( cDbfCol )", nil } )
   aAdd( aColAlbPrv, { "cCodPr1",      "C", 20,  0, "Código de primera propiedad",           "CodigoPropiedad1",           "", "( cDbfCol )", nil } )
   aAdd( aColAlbPrv, { "cCodPr2",      "C", 20,  0, "Código de segunda propiedad",           "CodigoPropiedad2",           "", "( cDbfCol )", nil } )
   aAdd( aColAlbPrv, { "cValPr1",      "C", 20,  0, "Valor de primera propiedad",            "ValorPropiedad1",            "", "( cDbfCol )", nil } )
   aAdd( aColAlbPrv, { "cValPr2",      "C", 20,  0, "Valor de segunda propiedad",            "ValorPropiedad2",            "", "( cDbfCol )", nil } )
   aAdd( aColAlbPrv, { "nFacCnv",      "N", 13,  4, "Factor de conversión de la compra",     "",                           "", "( cDbfCol )", nil } )
   aAdd( aColAlbPrv, { "cCodPed",      "C", 12,  0, "Número del pedido",                     "NumeroPedidoProveedor",      "", "( cDbfCol )", nil } )
   aAdd( aColAlbPrv, { "cAlmLin",      "C", 16,  0, "Código del almacén",                    "Almacen",                    "", "( cDbfCol )", nil } )
   aAdd( aColAlbPrv, { "nCtlStk",      "N",  1,  0, "Control de stock (1,2,3)",              "ControlStock",               "", "( cDbfCol )", nil } )
   aAdd( aColAlbPrv, { "llote",        "L",  1,  0, "",                                      "LogicoLote",                 "", "( cDbfCol )", nil } )
   aAdd( aColAlbPrv, { "nlote",        "N",  9,  0, "",                                      "",                           "", "( cDbfCol )", nil } )
   aAdd( aColAlbPrv, { "clote",        "C", 14,  0, "Número de lote",                        "Lote",                       "", "( cDbfCol )", nil } )
   aAdd( aColAlbPrv, { "nNumLin",      "N",  4,  0, "Número de la línea",                    "NumeroLinea",                "", "( cDbfCol )", nil } )
   aAdd( aColAlbPrv, { "nUndKit",      "N", 16,  6, "Unidades del producto kit",             "",                           "", "( cDbfCol )", nil } )
   aAdd( aColAlbPrv, { "lKitArt",      "L",  1,  0, "Línea con escandallo",                  "",                           "", "( cDbfCol )", nil } )
   aAdd( aColAlbPrv, { "lKitChl",      "L",  1,  0, "Línea pertenciente a escandallo",       "",                           "", "( cDbfCol )", nil } )
   aAdd( aColAlbPrv, { "lKitPrc",      "L",  1,  0, "",                                      "",                           "", "( cDbfCol )", nil } )
   aAdd( aColAlbPrv, { "lImpLin",      "L",  1,  0, "Imprimir línea",                        "Imprimir",                   "", "( cDbfCol )", nil } )
   aAdd( aColAlbPrv, { "lConTrol",     "L",  1,  0, "" ,                                     "Control",                    "", "( cDbfCol )", nil } )
   aAdd( aColAlbPrv, { "mNumSer",      "M", 10,  0, "" ,                                     "NumerosSerie",               "", "( cDbfCol )", nil } )
   aAdd( aColAlbPrv, { "ndto1",        "N",  5,  2, "",                                      "",                           "", "( cDbfCol )", nil } )
   aAdd( aColAlbPrv, { "ndto2",        "N",  5,  2, "",                                      "",                           "", "( cDbfCol )", nil } )
   aAdd( aColAlbPrv, { "ndto3",        "N",  5,  2, "",                                      "",                           "", "( cDbfCol )", nil } )
   aAdd( aColAlbPrv, { "ndto4",        "N",  5,  2, "",                                      "",                           "", "( cDbfCol )", nil } )
   aAdd( aColAlbPrv, { "ndto5",        "N",  5,  2, "",                                      "",                           "", "( cDbfCol )", nil } )
   aAdd( aColAlbPrv, { "nrap1",        "N",  5,  2, "",                                      "",                           "", "( cDbfCol )", nil } )
   aAdd( aColAlbPrv, { "nrap2",        "N",  5,  2, "",                                      "",                           "", "( cDbfCol )", nil } )
   aAdd( aColAlbPrv, { "nrap3",        "N",  5,  2, "",                                      "",                           "", "( cDbfCol )", nil } )
   aAdd( aColAlbPrv, { "nrap4",        "N",  5,  2, "",                                      "",                           "", "( cDbfCol )", nil } )
   aAdd( aColAlbPrv, { "nrap5",        "N",  5,  2, "",                                      "",                           "", "( cDbfCol )", nil } )
   aAdd( aColAlbPrv, { "cCodUbi1",     "C",  5,  0, "",                                      "",                           "", "( cDbfCol )", nil } )
   aAdd( aColAlbPrv, { "cCodUbi2",     "C",  5,  0, "",                                      "",                           "", "( cDbfCol )", nil } )
   aAdd( aColAlbPrv, { "cCodUbi3",     "C",  5,  0, "",                                      "",                           "", "( cDbfCol )", nil } )
   aAdd( aColAlbPrv, { "cValUbi1",     "C",  5,  0, "",                                      "",                           "", "( cDbfCol )", nil } )
   aAdd( aColAlbPrv, { "cValUbi2",     "C",  5,  0, "",                                      "",                           "", "( cDbfCol )", nil } )
   aAdd( aColAlbPrv, { "cValUbi3",     "C",  5,  0, "",                                      "",                           "", "( cDbfCol )", nil } )
   aAdd( aColAlbPrv, { "cNomUbi1",     "C", 30,  0, "",                                      "",                           "", "( cDbfCol )", nil } )
   aAdd( aColAlbPrv, { "cNomUbi2",     "C", 30,  0, "",                                      "",                           "", "( cDbfCol )", nil } )
   aAdd( aColAlbPrv, { "cNomUbi3",     "C", 30,  0, "",                                      "",                           "", "( cDbfCol )", nil } )
   aAdd( aColAlbPrv, { "cCodFam",      "C", 16,  0, "Código de familia",                     "Familia",                    "", "( cDbfCol )", nil } )
   aAdd( aColAlbPrv, { "cGrpFam",      "C",  3,  0, "Código del grupo de familia",           "GrupoFamilia",               "", "( cDbfCol )", nil } )
   aAdd( aColAlbPrv, { "nReq",         "N", 16,  6, "Recargo de equivalencia",               "PorcentajeRecargo",          "", "( cDbfCol )", nil } )
   aAdd( aColAlbPrv, { "mObsLin",      "M", 10,  0, "Observación de la línea",               "Observaciones",              "", "( cDbfCol )", nil } )
   aAdd( aColAlbPrv, { "cNumPed",      "C", 12,  0, "Número del pedido de cliente" ,         "NumeroPedidoCliente",        "", "( cDbfCol )", nil } )
   aAdd( aColAlbPrv, { "nPvpRec",      "N", 16,  6, "Precio de venta recomendado",           "PrecioVentaRecomendado",     "", "( cDbfCol )", nil } )
   aAdd( aColAlbPrv, { "nNumMed",      "N",  1,  0, "Número de mediciones",                  "NumeroMediciones",           "", "( cDbfCol )", nil } )
   aAdd( aColAlbPrv, { "nMedUno",      "N", 16,  6, "Primera unidad de medición",            "Medicion1",                  "", "( cDbfCol )", nil } )
   aAdd( aColAlbPrv, { "nMedDos",      "N", 16,  6, "Segunda unidad de medición",            "Medicion2",                  "", "( cDbfCol )", nil } )
   aAdd( aColAlbPrv, { "nMedTre",      "N", 16,  6, "Tercera unidad de medición",            "Medicion3",                  "", "( cDbfCol )", nil } )
   aAdd( aColAlbPrv, { "lFacturado",   "L",  1,  0, "Estado del albarán",                    "Facturda",                   "", "( cDbfCol )", nil } )
   aAdd( aColAlbPrv, { "dFecCad",      "D",  8,  0, "Fecha de caducidad",                    "",                           "", "( cDbfCol )", nil } )
   aAdd( aColAlbPrv, { "nUndLin",      "N", 16,  6, "",                                      "",                           "", "( cDbfCol )", nil } )
   aAdd( aColAlbPrv, { "lLabel",       "L",  1,  0, "Lógico para marca de etiqueta",         "LogicoEtiqueta",             "", "( cDbfCol )", nil } )
   aAdd( aColAlbPrv, { "nLabel",       "N",  6,  0, "Unidades de etiquetas a imprimir",      "NumeroEtiqueta",             "", "( cDbfCol )", nil } )
   aAdd( aColAlbPrv, { "dFecAlb",      "D",  8,  0, "Fecha de albaran",                      "",                           "", "( cDbfCol )", nil } )
   aAdd( aColAlbPrv, { "lNumSer",      "L",  1,  0, "Lógico solicitar numero de serie",      "LogicoNumeroSerie",          "", "( cDbfCol )", nil } )
   aAdd( aColAlbPrv, { "lAutSer",      "L",  1,  0, "Lógico de autoserializar",              "LogicoAutoserializar",       "", "( cDbfCol )", nil } )
   aAdd( aColAlbPrv, { "nPntVer",      "N", 16,  6, "Importe punto verde" ,                  "PuntoVerde",                 "", "( cDbfCol )", nil } )
   aAdd( aColAlbPrv, { "cAlmOrigen",   "C", 16,  0, "Almacén de origen de la mercancía" ,    "",                           "", "( cDbfCol )", nil } )
   aAdd( aColAlbPrv, { "nBultos",      "N", 16,  6, "Numero de bultos en líneas",            "",                           "", "( cDbfCol )", nil } )
   aAdd( aColAlbPrv, { "cFormato",     "C",100,  0, "Formato de compra",                     "",                           "", "( cDbfCol )", nil } )
   aAdd( aColAlbPrv, { "cNumFac",      "C", 12,  0, "Número de la factura de cliente" ,      "",                           "", "( cDbfCol )", nil } )
   aAdd( aColAlbPrv, { "cCodImp",      "C",  3,  0, "Código de impuesto especial",           "",                           "", "( cDbfCol )", nil } )
   aAdd( aColAlbPrv, { "nValImp",      "N", 16,  6, "Importe de impuesto especial",          "",                           "", "( cDbfCol )", nil } )
   aAdd( aColAlbPrv, { "dApertura",    "D",  8,  0, "Fecha apertura de lote",                "",                           "", "( cDbfCol )", nil } )
   aAdd( aColAlbPrv, { "tApertura",    "C",  6,  0, "Hora apertura de lote",                 "",                           "", "( cDbfCol )", nil } )
   aAdd( aColAlbPrv, { "dCierre",      "D",  8,  0, "Fecha cierre de lote",                  "",                           "", "( cDbfCol )", nil } )
   aAdd( aColAlbPrv, { "tCierre",      "C",  6,  0, "Hora cierre de lote",                   "",                           "", "( cDbfCol )", nil } )
   aAdd( aColAlbPrv, { "tFecAlb",      "C",  6,  0, "Hora del albarán" ,                     "",                           "", "( cDbfCol )", nil } )
   aAdd( aColAlbPrv, { "cCtrCoste",    "C",  9,  0, "Código del centro de coste" ,           "CentroCoste",                "", "( cDbfCol )", nil } )
   aAdd( aColAlbPrv, { "cSuAlb",       "C", 12,  0, "Número de su albarán",                  "",                           "", "( cDbfCol )", nil } )
   aAdd( aColAlbPrv, { "cRefAux",      "C", 18,  0, "Referencia auxiliar",                   "CodigoAuxiliar1",            "", "( cDbfCol )", nil } )
   aAdd( aColAlbPrv, { "cRefAux2",     "C", 18,  0, "Segunda referencia auxiliar",           "CodigoAuxiliar2",            "", "( cDbfCol )", nil } )
   aAdd( aColAlbPrv, { "nPosPrint",    "N",  4,  0, "Posición de impresión",                 "PosicionImpresion",          "", "( cDbfCol )", nil } )
   aAdd( aColAlbPrv, { "cTipCtr",      "C", 20,  0, "Tipo tercero centro de coste",          "",                           "", "( cDbfCol )", nil } )
   aAdd( aColAlbPrv, { "cTerCtr",      "C", 20,  0, "Tercero centro de coste" ,              "",                           "", "( cDbfCol )", nil } )

RETURN ( aColAlbPrv )

//---------------------------------------------------------------------------//

FUNCTION aSerAlbPrv()

   local aColAlbPrv  := {}

   aAdd( aColAlbPrv,  { "cSerAlb",     "C",  1,   0, "",                                 "",                  "", "(cDbfCol)" } )
   aAdd( aColAlbPrv,  { "nNumAlb",     "N",  9,   0, "",                                 "",                  "", "(cDbfCol)" } )
   aAdd( aColAlbPrv,  { "cSufAlb",     "C",  2,   0, "",                                 "",                  "", "(cDbfCol)" } )
   aAdd( aColAlbPrv,  { "dFecAlb",     "D",  8,   0, "",                                 "",                  "", "(cDbfCol)" } )
   aAdd( aColAlbPrv,  { "nNumLin",     "N",  4,   0, "Número de la línea",               "'9999'",            "", "(cDbfCol)" } )
   aAdd( aColAlbPrv,  { "cRef",        "C", 18,   0, "Referencia del artículo",          "",                  "", "(cDbfCol)" } )
   aAdd( aColAlbPrv,  { "cAlmLin",     "C", 16,   0, "Código de almacen",                "",                  "", "(cDbfCol)" } )
   aAdd( aColAlbPrv,  { "lFacturado",  "L",  1,   0, "Lógico de facturado",              "",                  "", "(cDbfCol)" } )
   aAdd( aColAlbPrv,  { "lUndNeg",     "L",  1,   0, "Lógico de unidades en negativo",   "",                  "", "(cDbfCol)" } )
   aAdd( aColAlbPrv,  { "cNumSer",     "C", 30,   0, "Numero de serie",                  "",                  "", "(cDbfCol)" } )

RETURN ( aColAlbPrv )

//---------------------------------------------------------------------------//

//
// Unidades recibidas en albaranes de proveedor desde un pedido de cliente
//

FUNCTION nUnidadesRecibidasPedCli( cPedCli, cCodArt, cValPr1, cValPr2, cRefPrv, cDetalle, cAlbPrvL )

   local nRec
   local nOrd
   local nTot        := 0

   DEFAULT cValPr1   := Space( 20 )
   DEFAULT cValPr2   := Space( 20 )

   nRec              := ( cAlbPrvL )->( Recno() )
   nOrd              := ( cAlbPrvL )->( OrdSetFocus( "cPedCliRef" ) )

   if ( cAlbPrvL )->( dbSeek( cPedCli + cCodArt + cValPr1 + cValPr2 ) )

      while ( cAlbPrvL )->cNumPed + ( cAlbPrvL )->cRef + ( cAlbPrvL )->cValPr1 + ( cAlbPrvL )->cValPr2 == cPedCli + cCodArt + cValPr1 + cValPr2 .and. !( cAlbPrvL )->( eof() )

         nTot        += nTotNAlbPrv( cAlbPrvL )

         ( cAlbPrvL )->( dbSkip() )

      end while

   end if

   ( cAlbPrvL )->( OrdSetFocus( nOrd ) )
   ( cAlbPrvL )->( dbGoTo( nRec ) )

RETURN ( nTot )

//-----------------------------------------------------------------------------//

FUNCTION nUnidadesRecibidasPedPrv( cPedPrv, cCodArt, cValPr1, cValPr2, cRefPrv, cAlbPrvL )

   local nRec
   local nOrd
   local nTot        := 0

   DEFAULT cValPr1   := Space( 40 )
   DEFAULT cValPr2   := Space( 40 )

   nRec              := ( cAlbPrvL )->( Recno() )
   nOrd              := ( cAlbPrvL )->( OrdSetFocus( "cPedPrvRef" ) )

   if ( cAlbPrvL )->( dbSeek( cPedPrv + cCodArt + cValPr1 + cValPr2 ) )

      while ( cAlbPrvL )->cCodPed + ( cAlbPrvL )->cRef + ( cAlbPrvL )->cValPr1 + ( cAlbPrvL )->cValPr2 == cPedPrv + cCodArt + cValPr1 + cValPr2 .and. !( cAlbPrvL )->( eof() )

         nTot     += nTotNAlbPrv( cAlbPrvL )

         ( cAlbPrvL )->( dbSkip() )

      end while

   end if

   ( cAlbPrvL )->( OrdSetFocus( nOrd ) )
   ( cAlbPrvL )->( dbGoTo( nRec ) )

RETURN ( nTot )

//-----------------------------------------------------------------------------//

FUNCTION SynAlbPrv( cPath )

   local oError
   local oBlock      
   local aTotAlb
   local cCodPrv
   local cNumSer
   local aNumSer
   local nRecPed
   local nOrdPed
   local cPedPrv
   local aPedPrv     := {}
   local cAlbPrvT
   local cAlbPrvL
   local cAlbPrvI
   local cAlbPrvS
   local cFamilia
   local cArticulo
   local cArtPrv
   local cIva
   local cDiv
   local cPedPrvT
   local cPedPrvL
   local cArtDiv

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   dbUseArea( .t., cDriver(), cPath + "ALBPROVT.DBF", cCheckArea( "ALBPROVT", @cAlbPrvT ), .f. )
   if !lAIS(); ordListAdd( cPath + "AlbProvT.Cdx" ); else ; ordSetFocus( 1 ) ; end

   dbUseArea( .t., cDriver(), cPath + "ALBPROVL.DBF", cCheckArea( "ALBPROVL", @cAlbPrvL ), .f. )
   if !lAIS(); ordListAdd( cPath + "AlbProvL.Cdx" ); else ; ordSetFocus( 1 ) ; end

   dbUseArea( .t., cDriver(), cPath + "ALBPRVS.DBF", cCheckArea( "ALBPRVS", @cAlbPrvS ), .f. )
   if !lAIS(); ordListAdd( cPath + "ALBPRVS.CDX" ); else ; ordSetFocus( 1 ) ; end

   dbUseArea( .t., cDriver(), cPath + "ALBPRVI.DBF", cCheckArea( "ALBPRVI", @cAlbPrvI ), .f. )
   if !lAIS(); ordListAdd( cPath + "AlbPrvI.Cdx" ); else ; ordSetFocus( 1 ) ; end

   dbUseArea( .t., cDriver(), cPatEmp() + "FAMILIAS.DBF", cCheckArea( "FAMILIAS", @cFamilia ), .f. )
   if !lAIS(); ordListAdd( cPatEmp() + "FAMILIAS.CDX" ); else ; ordSetFocus( 1 ) ; end

   dbUseArea( .t., cDriver(), cPatEmp() + "ARTICULO.DBF", cCheckArea( "ARTICULO", @cArticulo ), .f. )
   if !lAIS(); ordListAdd( cPatEmp() + "ARTICULO.CDX" ); else ; ordSetFocus( 1 ) ; end

   dbUseArea( .t., cDriver(), cPatEmp() + "PROVART.DBF", cCheckArea( "PROVART", @cArtPrv ), .f. )
   if !lAIS(); ordListAdd( cPatEmp() + "PROVART.CDX" ); else ; ordSetFocus( 1 ) ; end

   dbUseArea( .t., cDriver(), cPatDat() + "TIVA.DBF", cCheckArea( "TIVA", @cIva ), .t. )
   if !lAIS(); ordListAdd( cPatDat() + "TIVA.CDX" ); else ; ordSetFocus( 1 ) ; end

   dbUseArea( .t., cDriver(), cPatDat() + "DIVISAS.DBF", cCheckArea( "DIVISAS", @cDiv ), .t. )
   if !lAIS(); ordListAdd( cPatDat() + "DIVISAS.CDX" ); else ; ordSetFocus( 1 ) ; end

   dbUseArea( .t., cDriver(), cPath + "PEDPROVT.DBF", cCheckArea( "PEDPROVT", @cPedPrvT ), .f. )
   if !lAIS(); ordListAdd( cPath + "PEDPROVT.CDX" ); else ; ordSetFocus( 1 ) ; end

   dbUseArea( .t., cDriver(), cPath + "PEDPROVL.DBF", cCheckArea( "PEDPROVL", @cPedPrvL ), .f. )
   if !lAIS(); ordListAdd( cPath + "PEDPROVL.CDX" ); else ; ordSetFocus( 1 ) ; end

   dbUseArea( .t., cDriver(), cPath + "ArtDiv.DBF", cCheckArea( "ArtDiv", @cArtDiv ), .f. )
   if !lAIS(); ordListAdd( cPath + "ArtDiv.CDX" ); else ; ordSetFocus( 1 ) ; end

   ( cAlbPrvT )->( ordSetFocus( 0 ) )
   ( cAlbPrvT )->( dbGoTop() )

   while !( cAlbPrvT )->( eof() )

      if Empty( ( cAlbPrvT )->cSufAlb )
         ( cAlbPrvT )->cSufAlb := "00"
      end if

      if Empty( ( cAlbPrvT )->cCodCaj )
         ( cAlbPrvT )->cCodCaj := "000"
      end if

      if !Empty( ( cAlbPrvT )->cNumPed ) .and. Len( AllTrim( ( cAlbPrvT )->cNumPed ) ) != 12
         ( cAlbPrvT )->cNumPed := AllTrim( ( cAlbPrvT )->cNumPed ) + "00"
      end if

      if !Empty( ( cAlbPrvT )->cNumFac ) .and. Len( AllTrim( ( cAlbPrvT )->cNumFac ) ) != 12
         ( cAlbPrvT )->cNumFac := AllTrim( ( cAlbPrvT )->cNumFac ) + "00"
      end if

      // Estado del albaran

      if ( cAlbPrvT )->nFacturado != 0
         if ( cAlbPrvT )->nFacturado == 1
            ( cAlbPrvT )->lFacturado   := .f.
         end if
         if ( cAlbPrvT )->nFacturado == 3
            ( cAlbPrvT )->lFacturado   := .t.
         end if
      else     
         if ( cAlbPrvT )->lFacturado  
            ( cAlbPrvT )->nFacturado   := 3
         else
            ( cAlbPrvT )->nFacturado   := 1
         end if
      end if 

      /*
      Rellenamos los campos de totales-----------------------------------------
      */

      if ( cAlbPrvT )->nTotAlb == 0 .and. dbLock( cAlbPrvT )

         aTotAlb                 := aTotAlbPrv( ( cAlbPrvT )->cSerAlb + Str( ( cAlbPrvT )->nNumAlb ) + ( cAlbPrvT )->cSufAlb, cAlbPrvT, cAlbPrvL, cIva, cDiv, ( cAlbPrvT )->cDivAlb )

         ( cAlbPrvT )->nTotNet := aTotAlb[ 1 ]
         ( cAlbPrvT )->nTotIva := aTotAlb[ 2 ]
         ( cAlbPrvT )->nTotReq := aTotAlb[ 3 ]
         ( cAlbPrvT )->nTotAlb := aTotAlb[ 4 ]

      end if

      /*
      Estado de los pedidos cuando es agrupando--------------------------------
      */

      nRecPed  := ( cPedPrvT )->( RecNo() )
      nOrdPed  := ( cPedPrvT )->( OrdSetFocus( "cNumAlb" ) )

      if ( cPedPrvT )->( dbSeek( ( cAlbPrvT )->cSerAlb + Str( ( cAlbPrvT )->nNumAlb ) + ( cAlbPrvT )->cSufAlb ) )

         while ( cPedPrvT )->cNumAlb == ( cAlbPrvT )->cSerAlb + Str( ( cAlbPrvT )->nNumAlb ) + ( cAlbPrvT  )->cSufAlb .and. !( cPedPrvT )->( Eof() )
            
            aAdd( aPedPrv, ( cPedPrvT )->cSerPed + Str( ( cPedPrvT )->nNumPed ) + ( cPedPrvT )->cSufPed )

            ( cPedPrvT )->( dbSkip() )

         end while

      end if

      ( cPedPrvT )->( OrdSetFocus( nOrdPed ) )
      ( cPedPrvT )->( dbGoTo( nRecPed ) )

      ( cAlbPrvT )->( dbSkip() )

   end while
   
   ( cAlbPrvT )->( ordSetFocus( 1 ) )

   /*
   Lineas----------------------------------------------------------------------
   */
   
   ( cAlbPrvL )->( ordSetFocus( 0 ) )
   ( cAlbPrvL )->( dbGoTop() )

   while !( cAlbPrvL )->( eof() )

      if Empty( ( cAlbPrvL )->cSufAlb )
         ( cAlbPrvL )->cSufAlb    := "00"
      end if

      if !Empty( ( cAlbPrvL )->cCodPed ) .and. Len( AllTrim( ( cAlbPrvL )->cCodPed ) ) != 12
         ( cAlbPrvL )->cCodPed    := AllTrim( ( cAlbPrvL )->cCodPed ) + "00"
      end if

      if !Empty( ( cAlbPrvL )->cNumPed ) .and. Len( AllTrim( ( cAlbPrvL )->cNumPed ) ) != 12
         ( cAlbPrvL )->cNumPed    := AllTrim( ( cAlbPrvL )->cNumPed ) + "00"
      end if

      if Empty( ( cAlbPrvL )->cLote ) .and. !Empty( ( cAlbPrvL )->nLote )
         ( cAlbPrvL )->cLote      := AllTrim( Str( ( cAlbPrvL )->nLote ) )
      end if

      if !Empty( ( cAlbPrvL )->cRef ) .and. Empty( ( cAlbPrvL )->cCodFam )
         ( cAlbPrvL )->cCodFam    := RetFamArt( ( cAlbPrvL )->cRef, cArticulo )
      end if

      if !Empty( ( cAlbPrvL )->cRef ) .and. !Empty( ( cAlbPrvL )->cCodFam )
         ( cAlbPrvL )->cGrpFam    := cGruFam( ( cAlbPrvL )->cCodFam, cFamilia )
      end if

      if Empty( ( cAlbPrvL )->nReq )
         ( cAlbPrvL )->nReq       := nPReq( cIva, ( cAlbPrvL )->nIva )
      end if
   
      if Empty( ( cAlbPrvL )->cAlmLin )
         ( cAlbPrvL )->cAlmLin    := RetFld( ( cAlbPrvL )->cSerAlb + Str( ( cAlbPrvL )->nNumAlb ) + ( cAlbPrvL )->cSufAlb, cAlbPrvT, "cCodAlm" )
      end if

/*  Esto da problemas en Distribumar en el caso de albaranes facturados parcialmente, quita la marca de facturado de la linea

      if ( cAlbPrvL )->lFacturado != RetFld( ( cAlbPrvL )->cSerAlb + Str( ( cAlbPrvL )->nNumAlb ) + ( cAlbPrvL )->cSufAlb, cAlbPrvT, "lFacturado" ) 
         ( cAlbPrvL )->lFacturado := RetFld( ( cAlbPrvL )->cSerAlb + Str( ( cAlbPrvL )->nNumAlb ) + ( cAlbPrvL )->cSufAlb, cAlbPrvT, "lFacturado" )
      end if
*/
      if ( cAlbPrvL )->dFecAlb != RetFld( ( cAlbPrvL )->cSerAlb + Str( ( cAlbPrvL )->nNumAlb ) + ( cAlbPrvL )->cSufAlb, cAlbPrvT, "dFecAlb" )
         ( cAlbPrvL )->dFecAlb   := RetFld( ( cAlbPrvL )->cSerAlb + Str( ( cAlbPrvL )->nNumAlb ) + ( cAlbPrvL )->cSufAlb, cAlbPrvT, "dFecAlb" )
      end if

      if empty( ( cAlbPrvL )->cNumFac )
         ( cAlbPrvL )->cNumFac   := RetFld( ( cAlbPrvL )->cSerAlb + Str( ( cAlbPrvL )->nNumAlb ) + ( cAlbPrvL )->cSufAlb, cAlbPrvT, "cNumFac" )
      end if 

      if !Empty( ( cAlbPrvL )->mNumSer )
         aNumSer                       := hb_aTokens( ( cAlbPrvL )->mNumSer, "," )
         for each cNumSer in aNumSer
            ( cAlbPrvS )->( dbAppend() )
            ( cAlbPrvS )->cSerAlb      := ( cAlbPrvL )->cSerAlb
            ( cAlbPrvS )->nNumAlb      := ( cAlbPrvL )->nNumAlb
            ( cAlbPrvS )->cSufAlb      := ( cAlbPrvL )->cSufAlb
            ( cAlbPrvS )->cRef         := ( cAlbPrvL )->cRef
            ( cAlbPrvS )->cAlmLin      := ( cAlbPrvL )->cAlmLin
            ( cAlbPrvS )->nNumLin      := ( cAlbPrvL )->nNumLin
            ( cAlbPrvS )->lFacturado   := ( cAlbPrvL )->lFacturado
            ( cAlbPrvS )->cNumSer      := cNumSer
         next
         ( cAlbPrvL )->mNumSer         := ""
      end if

      /*
      Referencias segun las compras--------------------------------------------
      */

      if !Empty( ( cAlbPrvL )->cRefPrv )
         cCodPrv                       := RetFld( ( cAlbPrvL )->cSerAlb + Str( ( cAlbPrvL )->nNumAlb ) + ( cAlbPrvL )->cSufAlb, cAlbPrvT, "cCodPrv" )
         if !Empty( cCodPrv )
            appendReferenciaProveedor( ( cAlbPrvL )->cRefPrv, cCodPrv, ( cAlbPrvL )->cRef, ( cAlbPrvL )->nDtoLin, ( cAlbPrvL )->nDtoPrm, ( cAlbPrvT )->cDivAlb, ( cAlbPrvL )->nPreDiv, cArtPrv )
         end if 
      end if

      /*
      Precios por propiedades de articulos-------------------------------------
      */

      if !( cArtDiv )->( dbSeek( ( cAlbPrvL )->CREF +  ( cAlbPrvL )->CCODPR1 + ( cAlbPrvL )->CCODPR2 + ( cAlbPrvL )->CVALPR1 + ( cAlbPrvL )->CVALPR2 ) )
      
         ( cArtDiv )->( dbAppend() )
         ( cArtDiv )->cCodDiv    := cDivEmp()
         ( cArtDiv )->cCodArt    := ( cAlbPrvL )->CREF
         ( cArtDiv )->cCodPr1    := ( cAlbPrvL )->CCODPR1 
         ( cArtDiv )->cCodPr2    := ( cAlbPrvL )->CCODPR2
         ( cArtDiv )->cValPr1    := ( cAlbPrvL )->CVALPR1 
         ( cArtDiv )->cValPr2    := ( cAlbPrvL )->CVALPR2
         ( cArtDiv )->nPreCom    := ( cAlbPrvL )->NPREDIV
         ( cArtDiv )->( dbUnlock() )

      end if

      if Empty( ( cAlbPrvL )->cAlmOrigen ) .and. !Empty( RetFld( ( cAlbPrvL )->cSerAlb + Str( ( cAlbPrvL )->nNumAlb ) + ( cAlbPrvL )->cSufAlb, cAlbPrvT, "cAlmOrigen" ) )
         ( cAlbPrvL )->cAlmOrigen := RetFld( ( cAlbPrvL )->cSerAlb + Str( ( cAlbPrvL )->nNumAlb ) + ( cAlbPrvL )->cSufAlb, cAlbPrvT, "cAlmOrigen" )
      end if 

      if Empty( ( cAlbPrvL )->nPosPrint )
         ( cAlbPrvL )->nPosPrint       := ( cAlbPrvL )->nNumLin
      end if

      // Michel loubet rellenar las líneas de albaranes que no tienen centro de coste, con el codigo que aparece en la cabecera
/*
      if Empty( ( cAlbPrvL )->cCtrCoste )
         ( cAlbPrvL )->cCtrCoste    := RetFld( ( cAlbPrvL )->cSerAlb + Str( ( cAlbPrvL )->nNumAlb ) + ( cAlbPrvL )->cSufAlb, cAlbPrvT, "cCtrCoste" )
      end if
*/
      //------------------------

      ( cAlbPrvL )->( dbSkip() )

      SysRefresh()

   end while

   ( cAlbPrvL )->( ordSetFocus( 1 ) )

   // Incidencias -------------------------------------------------------------
   
   ( cAlbPrvI )->( ordSetFocus( 0 ) )
   ( cAlbPrvI )->( dbGoTop() )

   while !( cAlbPrvI )->( eof() )

      if Empty( ( cAlbPrvI )->cSufAlb )
         ( cAlbPrvI )->cSufAlb       := "00"
      end if 

      ( cAlbPrvI )->( dbSkip() )

      SysRefresh()

   end while

   ( cAlbPrvI )->( ordSetFocus( 1 ) )

   // Series ---------------------------------------------------------------

   ( cAlbPrvS )->( ordSetFocus( 0 ) )
   ( cAlbPrvS )->( dbGoTop() )

   while !( cAlbPrvS )->( eof() )

      if Empty( ( cAlbPrvS )->cSufAlb )
         ( cAlbPrvS )->cSufAlb := "00"
      end if 
      
      if ( cAlbPrvS )->dFecAlb != RetFld( ( cAlbPrvS )->cSerAlb + Str( ( cAlbPrvS )->nNumAlb ) + ( cAlbPrvS )->cSufAlb, cAlbPrvT, "dFecAlb" )
         ( cAlbPrvS )->dFecAlb := RetFld( ( cAlbPrvS )->cSerAlb + Str( ( cAlbPrvS )->nNumAlb ) + ( cAlbPrvS )->cSufAlb, cAlbPrvT, "dFecAlb" )
      end if

      ( cAlbPrvS )->( dbSkip() )

      SysRefresh()

   end while

   ( cAlbPrvS )->( ordSetFocus( 1 ) )

   // Lineas huerfanas---------------------------------------------------------

   ( cAlbPrvT )->( ordSetFocus( 1 ) )

   // Lineas-------------------------------------------------------------------

   ( cAlbPrvL )->( ordSetFocus( 1 ) )
   ( cAlbPrvL )->( dbGoTop() )

   while !( cAlbPrvL )->( eof() )

      if !( cAlbPrvT )->( dbSeek( ( cAlbPrvL )->cSerAlb + Str( (cAlbPrvL )->nNumAlb ) + ( cAlbPrvL )->cSufAlb ) )
         ( cAlbPrvL )->( dbDelete() )
      end if 
      ( cAlbPrvL )->( dbSkip( 1 ) )
      
      SysRefresh()

   end while

   // Series-------------------------------------------------------------------

   ( cAlbPrvS )->( ordSetFocus( 1 ) )
   ( cAlbPrvS )->( dbGoTop() )

   while !( cAlbPrvS )->( eof() )

      if !( cAlbPrvT )->( dbSeek( ( cAlbPrvS )->cSerAlb + Str( ( cAlbPrvS )->nNumAlb ) + ( cAlbPrvS )->cSufAlb ) )
         ( cAlbPrvS )->( dbDelete() )
      end if 
      ( cAlbPrvS )->( dbSkip( 1 ) )

      SysRefresh()

   end while

   // Incidencias-------------------------------------------------------------------

   ( cAlbPrvI )->( ordSetFocus( 1 ) )
   ( cAlbPrvI )->( dbGoTop() )

   while !( cAlbPrvI )->( eof() )

      if !( cAlbPrvT )->( dbSeek( ( cAlbPrvI )->cSerAlb + Str( ( cAlbPrvI )->nNumAlb ) + ( cAlbPrvI )->cSufAlb ) )
         ( cAlbPrvI )->( dbDelete() )
      end if 
      ( cAlbPrvI )->( dbSkip( 1 ) )

      SysRefresh()

   end while

   // Fin lineas huerfanas-----------------------------------------------------

   RECOVER USING oError

      msgStop( "Imposible sincronizar albaranes de proveedores" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   if !Empty( cAlbPrvT ) .and. ( cAlbPrvT )->( Used() )
      ( cAlbPrvT )->( dbCloseArea() )
   end if

   if !Empty( cAlbPrvL ) .and. ( cAlbPrvL )->( Used() )
      ( cAlbPrvL )->( dbCloseArea() )
   end if

   if !Empty( cAlbPrvI ) .and. ( cAlbPrvI )->( Used() )
      ( cAlbPrvI )->( dbCloseArea() )
   end if

   if !Empty( cAlbPrvS ) .and. ( cAlbPrvS )->( Used() )
      ( cAlbPrvS )->( dbCloseArea() )
   end if

   if !Empty( cArticulo ) .and. ( cArticulo )->( Used() )
      ( cArticulo )->( dbCloseArea() )
   end if

   if !Empty( cFamilia ) .and. ( cFamilia )->( Used() )
      ( cFamilia )->( dbCloseArea() )
   end if

   if !Empty( cArtPrv ) .and. ( cArtPrv )->( Used() )
      ( cArtPrv )->( dbCloseArea() )
   end if

   if !Empty( cIva ) .and. ( cIva )->( Used() )
      ( cIva )->( dbCloseArea() )
   end if

   if !Empty( cDiv ) .and. ( cDiv )->( Used() )
      ( cDiv )->( dbCloseArea() )
   end if

   if !Empty( cPedPrvT ) .and. ( cPedPrvT )->( Used() )
      ( cPedPrvT )->( dbCloseArea() )
   end if

   if !Empty( cPedPrvL ) .and. ( cPedPrvL )->( Used() )
      ( cPedPrvL )->( dbCloseArea() )
   end if

   if !Empty( cArtDiv ) .and. ( cArtDiv )->( Used() )
      ( cArtDiv )->( dbCloseArea() )
   end if

   /*
   Calculo d stocks------------------------------------------------------------
   */

   if !Empty( aPedPrv )

      oStock      := TStock():Create()
      if oStock:lOpenFiles()

         for each cPedPrv in aPedPrv      
            oStock:SetPedPrv( cPedPrv )
         next

      end if 

      if !Empty( oStock )
         oStock:end()
      end if
 
      oStock      := nil

   end if       

RETURN nil

//------------------------------------------------------------------------//

FUNCTION AppAlbPrv( cCodPrv, cCodArt, lOpenBrowse )

   local nLevel         := Auth():Level( _MENUITEM_ )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) == 0 .or. nAnd( nLevel, ACC_APPD ) == 0
      msgStop( 'Acceso no permitido.' )
      RETURN .t.
   end if

   if lOpenBrowse

      if AlbPrv( nil, nil, cCodPrv, cCodArt )
         oWndBrw:RecAdd()
      end if

   else

      if OpenFiles( .t. )
         WinAppRec( nil, bEdtRec, D():AlbaranesProveedores( nView ), cCodPrv, cCodArt )
         CloseFiles()
      end if

   end if

RETURN .t.

//----------------------------------------------------------------------------//

FUNCTION EdtAlbPrv( nNumAlb, lOpenBrowse )

   local nLevel         := Auth():Level( _MENUITEM_ )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) == 0 .or. nAnd( nLevel, ACC_EDIT ) == 0
      msgStop( 'Acceso no permitido.' )
      RETURN .t.
   end if

   if lOpenBrowse

      if AlbPrv()
         if dbSeekInOrd( nNumAlb, "nNumAlb", D():AlbaranesProveedores( nView ) )
            oWndBrw:RecEdit()
         else
            MsgStop( "No se encuentra albaran" )
         end if
      end if

   else

      if OpenFiles( .t. )
         if dbSeekInOrd( nNumAlb, "nNumAlb", D():AlbaranesProveedores( nView ) )
            WinEdtRec( nil, bEdtRec, D():AlbaranesProveedores( nView ) )
         else
            MsgStop( "No se encuentra albaran" )
         end if
         CloseFiles()
      end if

   end if

RETURN NIL

//----------------------------------------------------------------------------//

FUNCTION ZooAlbPrv( nNumAlb, lOpenBrowse )

   local nLevel         := Auth():Level( _MENUITEM_ )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) == 0 .or. nAnd( nLevel, ACC_ZOOM ) == 0
      msgStop( 'Acceso no permitido.' )
      RETURN .t.
   end if

   if lOpenBrowse

      if AlbPrv()
         if dbSeekInOrd( nNumAlb, "nNumAlb", D():AlbaranesProveedores( nView ) )
            oWndBrw:RecZoom()
         else
            MsgStop( "No se encuentra albaran" )
         end if
      end if

   else

      if OpenFiles( .t. )
         if dbSeekInOrd( nNumAlb, "nNumAlb", D():AlbaranesProveedores( nView ) )
            WinZooRec( nil, bEdtRec, D():AlbaranesProveedores( nView ) )
         else
            MsgStop( "No se encuentra albaran" )
         end if
         CloseFiles()
      end if

   end if

RETURN NIL

//----------------------------------------------------------------------------//

FUNCTION DelAlbPrv( nNumAlb, lOpenBrowse )

   local nLevel         := Auth():Level( _MENUITEM_ )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) == 0 .or. nAnd( nLevel, ACC_ZOOM ) == 0
      msgStop( 'Acceso no permitido.' )
      RETURN .t.
   end if

   if lOpenBrowse

      if AlbPrv()
         if dbSeekInOrd( nNumAlb, "nNumAlb", D():AlbaranesProveedores( nView ) )
            WinDelRec( nil, D():AlbaranesProveedores( nView ), {|| QuiAlbPrv() } )
         else
            MsgStop( "No se encuentra albaran" )
         end if
      end if

   else

      if OpenFiles( .t. )
         if dbSeekInOrd( nNumAlb, "nNumAlb", D():AlbaranesProveedores( nView ) )
            WinDelRec( nil, D():AlbaranesProveedores( nView ), {|| QuiAlbPrv() } )
         else
            MsgStop( "No se encuentra albaran" )
         end if
         CloseFiles()
      end if

   end if

RETURN nil

//----------------------------------------------------------------------------//

FUNCTION PrnAlbPrv( nNumAlb, lOpenBrowse )

   local nLevel         := Auth():Level( _MENUITEM_ )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) == 0 .or. nAnd( nLevel, ACC_ZOOM ) == 0
      msgStop( 'Acceso no permitido.' )
      RETURN .t.
   end if

   if lOpenBrowse

      if AlbPrv()
         if dbSeekInOrd( nNumAlb, "nNumAlb", D():AlbaranesProveedores( nView ) )
            GenAlbPrv( IS_PRINTER )
         else
            MsgStop( "No se encuentra albaran" )
         end if
      end if

   else

      if OpenFiles( .t. )
         if dbSeekInOrd( nNumAlb, "nNumAlb", D():AlbaranesProveedores( nView ) )
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

   local nLevel         := Auth():Level( _MENUITEM_ )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) == 0 .or. nAnd( nLevel, ACC_ZOOM ) == 0
      msgStop( 'Acceso no permitido.' )
      RETURN .t.
   end if

   if lOpenBrowse

      if AlbPrv()
         if dbSeekInOrd( nNumAlb, "nNumAlb", D():AlbaranesProveedores( nView ) )
            GenAlbPrv( IS_SCREEN )
         else
            MsgStop( "No se encuentra albaran" )
         end if
      end if

   else

      if OpenFiles( .t. )
         if dbSeekInOrd( nNumAlb, "nNumAlb", D():AlbaranesProveedores( nView ) )
            GenAlbPrv( IS_SCREEN )
         else
            MsgStop( "No se encuentra albaran" )
         end if
         CloseFiles()
      end if

   end if

RETURN nil

//---------------------------------------------------------------------------//

FUNCTION setNoFacturadoAlbaranProveedorLinea( nView )

   local id := ( D():FacturasProveedoresLineas( nView ) )->iNumAlb

RETURN ( setEstadoFacturadoAlbaranProveedorLinea( .f., id, nView ) )

//---------------------------------------------------------------------------//

FUNCTION setFacturadoAlbaranProveedorLinea( cSerFac, nNumFac, cSufFac, nView )

   local id := ( D():FacturasProveedoresLineas( nView ) )->iNumAlb

RETURN ( setEstadoFacturadoAlbaranProveedorLinea( .t., id, nView, cSerFac, nNumFac, cSufFac ) )

//---------------------------------------------------------------------------//

FUNCTION setEstadoFacturadoAlbaranProveedorLinea( lFacturado, id, nView, cSerFac, nNumFac, cSufFac )

   DEFAULT lFacturado := .f.

   D():getStatusAlbaranesProveedoresLineas( nView )
   D():setFocusAlbaranesProveedoresLineas( "nNumLin", nView )

   if ( D():AlbaranesProveedoresLineas( nView ) )->( dbSeek( id ) )
      
      if dbDialogLock( D():AlbaranesProveedoresLineas( nView ) )

         ( D():AlbaranesProveedoresLineas( nView ) )->lFacturado  := lFacturado

         if lFacturado
            ( D():AlbaranesProveedoresLineas( nView ) )->cNumFac  := cSerFac + str( nNumFac ) + cSufFac
         else 
            ( D():AlbaranesProveedoresLineas( nView ) )->cNumFac  := ""
         end if 
      
         ( D():AlbaranesProveedoresLineas( nView ) )->( dbUnlock() )
      
      end if

   end if

   D():restoreFocusAlbaranesProveedoresLineas( nView )
   D():setStatusAlbaranesProveedoresLineas( nView )

RETURN ( nil )

//---------------------------------------------------------------------------//

FUNCTION setFacturadoAlbaranProveedorCabecera( lFacturado, nView, cNumFac )

   local nRec
   local nOrd

   DEFAULT lFacturado   := .f.
   DEFAULT cNumFac      := Space( 12 )

   /*
   Cambiamos las cabeceras-----------------------------------------------------
   */

   if dbDialogLock( D():AlbaranesProveedores( nView ) )
      ( D():AlbaranesProveedores( nView ) )->lFacturado := lFacturado
      ( D():AlbaranesProveedores( nView ) )->cNumFac    := cNumFac
      ( D():AlbaranesProveedores( nView ) )->nFacturado := if( lFacturado, 3, 1 )
      ( D():AlbaranesProveedores( nView ) )->( dbUnlock() )
   end if

RETURN NIL

//---------------------------------------------------------------------------//

FUNCTION setFacturadoAlbaranProveedores( nView )

   local nRec
   local cTxt
   local nSelected
   local nRecHead          

   cTxt                 := "¿Desea cambiar el estado del documento?"

   if isNil( oWndBrw )
      RETURN .f.
   end if 

   nSelected            := len( oWndBrw:oBrw:aSelected  )
   if nSelected > 1
      cTxt              := "¿Desea cambiar el estado de " + alltrim( str( nSelected, 3 ) ) + " documentos ?"
   end if

   if !apoloMsgNoYes( cTxt, "Elija una opción" )
      RETURN .f.
   end if 

   nRecHead                := ( D():AlbaranesProveedores( nView ) )->( recNo() )

   for each nRec in ( oWndBrw:oBrw:aSelected )

      ( D():AlbaranesProveedores( nView ) )->( dbGoTo( nRec ) )

      setFacturadoAlbaranProveedor( !( D():AlbaranesProveedores( nView ) )->lFacturado, nView )

   next

   ( D():AlbaranesProveedores( nView ) )->( dbGoTo( nRecHead ) )

   oWndBrw:Refresh()

RETURN .t.

//---------------------------------------------------------------------------//

FUNCTION setFacturadoAlbaranProveedor( lFacturado, nView, cNumFac )

   local nRec
   local nOrd

   DEFAULT lFacturado   := .f.
   DEFAULT cNumFac      := Space( 12 )

   CursorWait()

   /*
   Cambiamos las cabeceras-----------------------------------------------------
   */

   setFacturadoAlbaranProveedorCabecera( lFacturado, nView, cNumFac )      

   /*
   Cambiamos el estado en las lineas-------------------------------------------
   */

   D():getStatusAlbaranesProveedoresLineas( nView )
   D():setFocusAlbaranesProveedoresLineas( "nNumAlb", nView )

   if ( D():AlbaranesProveedoresLineas( nView ) )->( dbSeek( D():AlbaranesProveedoresId( nView ) ) )

      while D():AlbaranesProveedoresLineasId( nView ) == D():AlbaranesProveedoresId( nView ) .and. !( D():AlbaranesProveedoresLineas( nView ) )->( eof() )

         if dbDialogLock( D():AlbaranesProveedoresLineas( nView ) )
            ( D():AlbaranesProveedoresLineas( nView ) )->lFacturado := lFacturado
            ( D():AlbaranesProveedoresLineas( nView ) )->cNumFac    := cNumFac
            ( D():AlbaranesProveedoresLineas( nView ) )->( dbUnlock() )
          end if

         ( D():AlbaranesProveedoresLineas( nView ) )->( dbSkip() )

      end while

   end if

   D():restoreFocusAlbaranesProveedoresLineas( nView )
   D():setStatusAlbaranesProveedoresLineas( nView )

   /*
   Cambiamos el estado de las series-------------------------------------------
   */

   D():getStatusAlbaranesProveedoresSeries( nView )
   D():setFocusAlbaranesProveedoresSeries( "nNumAlb", nView )

   if ( D():AlbaranesProveedoresSeries( nView ) )->( dbSeek( D():AlbaranesProveedoresId( nView ) ) )

      while D():AlbaranesProveedoresSeriesId( nView ) == D():AlbaranesProveedoresId( nView ) .and. !( D():AlbaranesProveedoresSeries( nView ) )->( eof() )

         if dbDialogLock( D():AlbaranesProveedoresSeries( nView ) )
            ( D():AlbaranesProveedoresSeries( nView ) )->lFacturado := lFacturado
            ( D():AlbaranesProveedoresSeries( nView ) )->( dbUnlock() )
          end if

         ( D():AlbaranesProveedoresSeries( nView ) )->( dbSkip() )

      end while

   end if

   D():restoreFocusAlbaranesProveedoresSeries( nView )
   D():setStatusAlbaranesProveedoresSeries( nView )

   CursorWE()

RETURN NIL

//---------------------------------------------------------------------------//

FUNCTION getEstadoAlbaranProveedor( id, nView )

   local nOrd
   local nLineasProcesadas := 0
   local nLineasFacturadas := 0
   local nEstadoAlbaran    := 0

   CursorWait()

   // Comprobamos las lineas de albaran----------------------------------------

   nOrd                    := ( D():AlbaranesProveedoresLineas( nView ) )->( OrdSetFocus( "nNumAlb" ) )

   if ( D():AlbaranesProveedoresLineas( nView ) )->( dbSeek( id ) )

      while ( D():AlbaranesProveedoresLineasId( nView ) == id ) .and. !( D():AlbaranesProveedoresLineas( nView ) )->( eof() )

         nLineasProcesadas++

         if ( D():AlbaranesProveedoresLineas( nView ) )->lFacturado 
            nLineasFacturadas++
         end if 

         (  D():AlbaranesProveedoresLineas( nView ) )->( dbSkip() )

      end while

   end if

   (  D():AlbaranesProveedoresLineas( nView ) )->( OrdSetFocus( nOrd ) )

   // Comprobamos las lineas q se han procesado--------------------------------

   do case
      case nLineasFacturadas == 0
         nEstadoAlbaran    := albNoFacturado
      case nLineasFacturadas > 0 .and. nLineasFacturadas < nLineasProcesadas
         nEstadoAlbaran    := albParcialmenteFacturado
      otherwise
         nEstadoAlbaran    := albTotalmenteFacturado
   end case

   CursorWE()

RETURN ( nEstadoAlbaran )

//---------------------------------------------------------------------------//

FUNCTION setEstadoAlbaranProveedor( id, nView )

   local nOrd
   local nFacturado     := 0

   if empty( id )
      RETURN ( nFacturado )
   end if 

   nOrd                 := ( D():AlbaranesProveedores( nView ) )->( OrdSetFocus( "nNumAlb" ) )

   if ( D():AlbaranesProveedores( nView ) )->( dbSeek( id ) )
      nFacturado        := getEstadoAlbaranProveedor( id, nView )
      if ( D():AlbaranesProveedores( nView ) )->nFacturado != nFacturado
         if ( D():AlbaranesProveedores( nView ) )->( dbrlock() )
            ( D():AlbaranesProveedores( nView ) )->nFacturado  := nFacturado
            ( D():AlbaranesProveedores( nView ) )->( dbrunlock() )
         end if 
      end if 
   end if 

   (  D():AlbaranesProveedoresLineas( nView ) )->( OrdSetFocus( nOrd ) )

RETURN ( nFacturado )

//---------------------------------------------------------------------------//

FUNCTION IsAlbPrv( cPath )

RETURN ( .t. )

//---------------------------------------------------------------------------//

FUNCTION cCodAlbPrv( cAlbPrvL )

   local cRETURN     := ""

   DEFAULT cAlbPrvL  := if( !Empty( tmpAlbPrvL ), tmpAlbPrvL, D():AlbaranesProveedoresLineas( nView ) )

   cRETURN           += Alltrim( ( cAlbPrvL )->cRef )

   if !Empty( ( cAlbPrvL )->cValPr1 )
      cRETURN        += "."
      cRETURN        += Alltrim( ( cAlbPrvL )->cValPr1 )
   end if

   if !Empty( ( cAlbPrvL )->cValPr2 )
      cRETURN        += "."
      cRETURN        += Alltrim( ( cAlbPrvL )->cValPr2 )
   end if

RETURN ( cRETURN )

//---------------------------------------------------------------------------//

FUNCTION cDesAlbPrv( cAlbPrvL, cAlbPrvS )

   DEFAULT cAlbPrvL  := D():AlbaranesProveedoresLineas( nView )
   DEFAULT cAlbPrvS  := D():AlbaranesProveedoresSeries( nView )

RETURN ( Descrip( cAlbPrvL, cAlbPrvS ) )

//---------------------------------------------------------------------------//

FUNCTION cDesAlbPrvLeng( cAlbPrvL, cAlbPrvS, cArtLeng )

   DEFAULT cAlbPrvL  := D():AlbaranesProveedoresLineas( nView )
   DEFAULT cAlbPrvS  := D():AlbaranesProveedoresSeries( nView )
   DEFAULT cArtLeng  := D():ArticuloLenguaje( nView )

RETURN ( DescripLeng( cAlbPrvL, cAlbPrvS, cArtLeng ) )

//---------------------------------------------------------------------------//

FUNCTION DesignLabelAlbaranProveedor( oFr, cDbfDoc )

   local oLabel   
   local lOpenFiles  := empty( nView ) 

   if lOpenFiles .and. !Openfiles()
      RETURN .f.
   endif

   oLabel            := TLabelGeneratorAlbaranProveedores():New( nView, oNewImp )

   // Zona de datos---------------------------------------------------------
   
   oLabel:createTempLabelReport()
   oLabel:loadTempLabelReport()      

   oLabel:dataLabel( oFr )

   // Paginas y bandas------------------------------------------------------

   if !empty( ( cDbfDoc )->mReport )
      oFr:LoadFromBlob( ( cDbfDoc )->( Select() ), "mReport")
   else
      oFr:AddPage(         "MainPage" )
      oFr:AddBand(         "MasterData",  "MainPage",       frxMasterData )
      oFr:SetProperty(     "MasterData",  "Top",            200 )
      oFr:SetProperty(     "MasterData",  "Height",         100 )
      oFr:SetObjProperty(  "MasterData",  "DataSet",        "Lineas de albaranes" )
   end if

   // Zona de variables--------------------------------------------------------

   VariableReport( oFr )

   // Diseño de report------------------------------------------------------

   oFr:DesignReport()

   // Destruye el diseñador-------------------------------------------------

   oFr:DestroyFr()

   oLabel:DestroyTempReport()
   oLabel:End()

   if lOpenFiles
      closeFiles()
   end if 

RETURN .t.

//---------------------------------------------------------------------------//

FUNCTION DesignReportAlbPrv( oFr, dbfDoc )

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

      RETURN .f.

   end if

RETURN .t.

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

FUNCTION cBarPrp1( uAlbPrvL, uTblPro )

   local cBarPrp1    := ""

   DEFAULT uAlbPrvL  := if( !Empty( tmpAlbPrvL ), tmpAlbPrvL, D():AlbaranesProveedoresLineas( nView ) )
   DEFAULT uTblPro   := D():PropiedadesLineas( nView )

   if dbSeekInOrd( ( uAlbPrvL )->cCodPr1 + ( uAlbPrvL )->cValPr1, "cCodPro", uTblPro )
      cBarPrp1       := ( uTblPro )->nBarTbl
   end if

RETURN ( cBarPrp1 )

//---------------------------------------------------------------------------//

FUNCTION cBarPrp2( uAlbPrvL, uTblPro )

   local cBarPrp2    := ""

   DEFAULT uAlbPrvL  := if( !Empty( tmpAlbPrvL ), tmpAlbPrvL, D():AlbaranesProveedoresLineas( nView ) )
   DEFAULT uTblPro   := D():PropiedadesLineas( nView )

   if dbSeekInOrd( ( uAlbPrvL )->cCodPr2 + ( uAlbPrvL )->cValPr2, "cCodPro", uTblPro )
      cBarPrp2       := ( uTblPro )->nBarTbl
   end if

RETURN ( cBarPrp2 )

//---------------------------------------------------------------------------//

FUNCTION dFechaCaducidadLote( cCodArt, cValPr1, cValPr2, cLote, cAlbPrvL, cFacPrvL, cProLin )

   local dFechaCaducidad      := Ctod( "" )

   if dbSeekInOrd( cCodArt + cValPr1 + cValPr2 + cLote, "cStkRef", cAlbPrvL )
      dFechaCaducidad         := ( cAlbPrvL )->dFecCad
      RETURN( dFechaCaducidad )
   endif

   if dbSeekInOrd( cCodArt + cValPr1 + cValPr2 + cLote, "cRefLote", cFacPrvL )
      dFechaCaducidad         := ( cFacPrvL )->dFecCad
      RETURN( dFechaCaducidad )
   endif
   
   if !empty( cProLin )
      if dbSeekInOrd( cCodArt + cValPr1 + cValPr2 + cLote, "cArtLot", cProLin )
         dFechaCaducidad      := ( cProLin )->dFecCad
      end if
   end if

RETURN ( dFechaCaducidad )

//---------------------------------------------------------------------------//

Static FUNCTION AppendPropiedadesArticulos( aTbl, aTmp )

   if !( D():ArticuloPrecioPropiedades( nView ) )->( dbSeek( aTbl[ _CREF ] +  aTbl[ _CCODPR1 ] + aTbl[ _CCODPR2 ] + aTbl[ _CVALPR1 ] + aTbl[ _CVALPR2 ] ) )
      
      ( D():ArticuloPrecioPropiedades( nView ) )->( dbAppend() )
      ( D():ArticuloPrecioPropiedades( nView ) )->cCodDiv    := aTmp[ _CDIVALB ]
      ( D():ArticuloPrecioPropiedades( nView ) )->cCodArt    := aTbl[ _CREF    ]
      ( D():ArticuloPrecioPropiedades( nView ) )->cCodPr1    := aTbl[ _CCODPR1 ] 
      ( D():ArticuloPrecioPropiedades( nView ) )->cCodPr2    := aTbl[ _CCODPR2 ]
      ( D():ArticuloPrecioPropiedades( nView ) )->cValPr1    := aTbl[ _CVALPR1 ] 
      ( D():ArticuloPrecioPropiedades( nView ) )->cValPr2    := aTbl[ _CVALPR2 ]
      ( D():ArticuloPrecioPropiedades( nView ) )->nPreCom    := aTbl[ _NPREDIV ]
      ( D():ArticuloPrecioPropiedades( nView ) )->( dbUnlock() )

   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//--------------------------------CLASES-------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS TAlbaranesProveedorSenderReciver FROM TSenderReciverItem

   Method CreateData()

   Method RestoreData()

   Method SendData()

   Method ReciveData()

   Method Process()

   METHOD validateRecepcion()

END CLASS

//----------------------------------------------------------------------------//

Method CreateData() CLASS TAlbaranesProveedorSenderReciver

   local oBlock
   local oError
   local lSnd        := .f.
   local dbfAlbPrvT
   local dbfAlbPrvL
   local tmpAlbPrvT
   local tmpAlbPrvL

   if ::oSender:lServer
      ::cFileName    := "AlbPrv" + StrZero( ::nGetNumberToSend(), 6 ) + ".All"
   else
      ::cFileName    := "AlbPrv" + StrZero( ::nGetNumberToSend(), 6 ) + "." + RetSufEmp()
   end if

   ::oSender:SetText( "Enviando albaranes a proveedores" )

//   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
//   BEGIN SEQUENCE

   USE ( cPatEmp() + "AlbProvT.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "AlbProvT", @dbfAlbPrvT ) )
   SET ADSINDEX TO ( cPatEmp() + "AlbProvT.Cdx" ) ADDITIVE

   USE ( cPatEmp() + "AlbProvL.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "AlbProvL", @dbfAlbPrvL ) )
   SET ADSINDEX TO ( cPatEmp() + "AlbProvL.Cdx" ) ADDITIVE

   /*
   Creamos todas las bases de datos relacionadas con Articulos
   */

   mkAlbPrv( cPatSnd() )

   USE ( cPatSnd() + "AlbProvT.Dbf" ) NEW VIA ( cLocalDriver() ) SHARED ALIAS ( cCheckArea( "AlbProvT", @tmpAlbPrvT ) )
   SET INDEX TO ( cPatSnd() + "AlbProvT.Cdx" ) ADDITIVE

   USE ( cPatSnd() + "AlbProvL.Dbf" ) NEW VIA ( cLocalDriver() ) SHARED ALIAS ( cCheckArea( "AlbProvL", @tmpAlbPrvL ) )
   SET INDEX TO ( cPatSnd() + "AlbProvL.Cdx" ) ADDITIVE

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

//   RECOVER USING oError
//
//      msgStop( "Imposible abrir todas las bases de datos de albaranes de proveedores" + CRLF + ErrorMessage( oError ) )
//
//   END SEQUENCE
//
//   ErrorBlock( oBlock )

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

      if ::oSender:lZipData( ::cFileName )
         ::oSender:SetText( "Ficheros comprimidos" )
      else
         ::oSender:SetText( "ERROR al crear fichero comprimido" )
      end if

   else

      ::oSender:SetText( "No hay albaranes de proveedores para enviar" )

   end if

RETURN ( Self )

//----------------------------------------------------------------------------//
/*
Retorna el valor anterior
*/

Method RestoreData() CLASS TAlbaranesProveedorSenderReciver

   local oBlock
   local oError
   local cAlbPrvT

   if ::lSuccesfullSend

      oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
      BEGIN SEQUENCE

         USE ( cPatEmp() + "AlbProvT.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "AlbProvT", @cAlbPrvT ) )
         SET ADSINDEX TO ( cPatEmp() + "AlbProvT.Cdx" ) ADDITIVE

         lSelectAll( nil, cAlbPrvT, "lSndDoc", .f., .t., .f. )

      RECOVER USING oError

         msgStop( "Imposible abrir todas las bases de datos de agentes" + CRLF + ErrorMessage( oError ) )

      END SEQUENCE

      ErrorBlock( oBlock )

      CLOSE ( cAlbPrvT )

   end if

RETURN ( Self )

//----------------------------------------------------------------------------//
/*
Enviarlos a internet
*/

Method SendData() CLASS TAlbaranesProveedorSenderReciver

   if file( cPatOut() + ::cFileName )

      if ::oSender:SendFiles( cPatOut() + ::cFileName, ::cFileName )
         ::lSuccesfullSend := .t.
         ::IncNumberToSend()
         ::oSender:SetText( "Fichero enviado " + ::cFileName  )
      else
         ::oSender:SetText( "ERROR al enviar fichero" )
      end if

   else 

      ::oSender:SetText( "No existe el fichero " + ( cPatOut() + ::cFileName ) )

   end if

RETURN ( Self )

//----------------------------------------------------------------------------//

Method ReciveData() CLASS TAlbaranesProveedorSenderReciver

   local n
   local aExt
   
   aExt     := ::oSender:aExtensions()

   /*
   Recibirlo de internet
   */

   ::oSender:SetText( "Recibiendo albaranes de proveedores" )

   for n := 1 to len( aExt )
      ::oSender:GetFiles( "AlbPrv*." + aExt[ n ], cPatIn() )
   next

   ::oSender:SetText( "Albaranes de proveedores recibidos" )

RETURN Self

//----------------------------------------------------------------------------//

Method Process() CLASS TAlbaranesProveedorSenderReciver

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

      if ::oSender:lUnZipData( cPatIn() + aFiles[ m, 1 ] )

         dbUseArea(.t., cLocalDriver(), cPatSnd() + "AlbProvT.Dbf", cCheckArea( "AlbProvT", @tmpAlbPrvT ), .f., .t. )
         ( tmpAlbPrvT )->( ordListAdd( cPatSnd() + "AlbProvT.Cdx" ) )

         dbUseArea(.t., cLocalDriver(), cPatSnd() + "AlbProvL.Dbf", cCheckArea( "AlbProvL", @tmpAlbPrvL ), .f., .t. )
         ( tmpAlbPrvL )->( ordListAdd( cPatSnd() + "AlbProvL.Cdx" ) )

         USE ( cPatEmp() + "AlbProvT.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "AlbProvT", @dbfAlbPrvT ) )
         SET ADSINDEX TO ( cPatEmp() + "AlbProvT.Cdx" ) ADDITIVE

         USE ( cPatEmp() + "AlbProvL.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "AlbProvL", @dbfAlbPrvL ) )
         SET ADSINDEX TO ( cPatEmp() + "AlbProvL.Cdx" ) ADDITIVE

         while ( tmpAlbPrvT )->( !eof() )

            // Comprobamos que no exista el pedido en la base de datos

            if ::validateRecepcion( tmpAlbPrvT, dbfAlbPrvT )

               while ( dbfAlbPrvT )->( dbseek( ( tmpAlbPrvT )->cSerAlb + Str( ( tmpAlbPrvT )->nNumAlb ) + ( tmpAlbPrvT )->cSufAlb ) )
                  dbLockDelete( dbfAlbPrvT )
               end if 

               while ( dbfAlbPrvL )->( dbseek( ( tmpAlbPrvT )->cSerAlb + Str( ( tmpAlbPrvT )->nNumAlb ) + ( tmpAlbPrvT )->cSufAlb ) )
                  dbLockDelete( dbfAlbPrvL )
               end if 

               dbPass( tmpAlbPrvT, dbfAlbPrvT, .t. )

               if dbLock( dbfAlbPrvT )
                  ( dbfAlbPrvT )->lSndDoc := .f.
                  ( dbfAlbPrvT )->( dbUnLock() )
               end if
               
               ::oSender:SetText( "Añadido : " + ( tmpAlbPrvT )->cSerAlb + "/" + AllTrim( Str( ( tmpAlbPrvT )->nNumAlb ) ) + "/" + AllTrim( ( tmpAlbPrvT )->cSufAlb ) + "; " + Dtoc( ( tmpAlbPrvT )->dFecAlb ) + "; " + AllTrim( ( dbfAlbPrvT )->cCodPrv ) + "; " + ( dbfAlbPrvT )->cNomPrv )

               if ( tmpAlbPrvL )->( dbSeek( ( tmpAlbPrvT )->cSerAlb + Str( ( tmpAlbPrvT )->nNumAlb ) + ( tmpAlbPrvT )->CSUFAlb ) )

                  do while ( ( tmpAlbPrvL )->cSerAlb + Str( ( tmpAlbPrvL )->nNumAlb ) + ( tmpAlbPrvL )->CSUFAlb ) == ( ( tmpAlbPrvT )->cSerAlb + Str( ( tmpAlbPrvT )->nNumAlb ) + ( tmpAlbPrvT )->CSUFAlb ) .AND. !( tmpAlbPrvL )->( eof() )
                     dbPass( tmpAlbPrvL, dbfAlbPrvL, .t. )
                     ( tmpAlbPrvL )->( dbSkip() )
                  end do

               end if

            end if

            ( tmpAlbPrvT )->( dbSkip() )

         end do

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

RETURN Self

//---------------------------------------------------------------------------//

METHOD validateRecepcion( tmpAlbPrvT, dbfAlbPrvT ) CLASS TAlbaranesProveedorSenderReciver

   ::cErrorRecepcion       := "Pocesando albaran de proveedor número " + ( dbfAlbPrvT )->cSerAlb + "/" + alltrim( Str( ( dbfAlbPrvT )->nNumAlb ) ) + "/" + alltrim( ( dbfAlbPrvT )->cSufAlb ) + " "

   if !( lValidaOperacion( ( tmpAlbPrvT )->dFecAlb, .f. ) )
      ::cErrorRecepcion    += "la fecha " + dtoc( ( tmpAlbPrvT )->dFecAlb ) + " no es valida en esta empresa"
      RETURN .f. 
   end if 

   if !( ( dbfAlbPrvT )->( dbSeek( ( tmpAlbPrvT )->cSerAlb + Str( ( tmpAlbPrvT )->nNumAlb ) + ( tmpAlbPrvT )->cSufAlb ) ) )
      RETURN .t.
   end if 

   if dtos( ( dbfAlbPrvT )->dFecChg ) + ( dbfAlbPrvT )->cTimChg >= dtos( ( tmpAlbPrvT )->dFecChg ) + ( tmpAlbPrvT )->cTimChg 
      ::cErrorRecepcion    += "la fecha en la empresa " + dtoc( ( dbfAlbPrvT )->dFecChg ) + " " + ( dbfAlbPrvT )->cTimChg + " es más reciente que la recepción " + dtoc( ( tmpAlbPrvT )->dFecChg ) + " " + ( tmpAlbPrvT )->cTimChg 
      RETURN .f.
   end if

RETURN ( .t. )

//---------------------------------------------------------------------------//

FUNCTION getNumeroAlbaranProveedorLinea( nView )

RETURN ( substr( ( D():FacturasProveedoresLineas( nView ) )->iNumAlb, 1, 12 ) )

//---------------------------------------------------------------------------//

FUNCTION getExtraFieldAlbaranProveedor( cFieldName )

RETURN ( getExtraField( cFieldName, oDetCamposExtra, D():AlbaranesProveedoresId( nView ) ) )

//---------------------------------------------------------------------------//

Static FUNCTION ImportarLineasPedidosProveedor( aTmp, aGet, oBrwLin )

   local oLine
   local cCodigoProveedor
   local cNombreProveedor
   local oConversionPedidosProveedores

   cCodigoProveedor                 := aGet[ _CCODPRV ]:varGet()
   cNombreProveedor                 := aGet[ _CNOMPRV ]:varGet() 

   if empty( cCodigoProveedor )
      msgStop( "Es necesario codificar un proveedor.", "Importar pedidos" )
      RETURN .t.
   end if

   oConversionPedidosProveedores    := TConversionPedidosProveedores():New( nView, oStock )

   if empty( oConversionPedidosProveedores )
      RETURN .f.
   end if 

   oConversionPedidosProveedores:setCodigoProveedor( cCodigoProveedor ) 
   oConversionPedidosProveedores:setTitle( "Importando pedidos de " + alltrim( cCodigoProveedor ) + " - " + alltrim( cNombreProveedor ) )

   if oConversionPedidosProveedores:Dialog()
      appendLineasPedidosProveedor( oConversionPedidosProveedores:oDocumentLines:aLines, oBrwLin )
   end if 

   recalculaTotal( aTmp )

   oBrwLin:refresh()

RETURN .t.

//---------------------------------------------------------------------------//

Static FUNCTION appendLineasPedidosProveedor( aLines )

   local oLine

   for each oLine in aLines

      if oLine:isSelectLine()

         // calculateUnidadesPendientesRecepcion( oLine )

         oLine:setValue( "NumeroPedidoProveedor",  oLine:getDocumentId() )
         oLine:setValue( "NumeroLinea",            nLastNum( dbfTmp ) )
         oLine:setValue( "PosicionImpresion",      nLastNum( dbfTmp, "nPosPrint" ) )
         
         D():appendHashRecordInWorkarea( oLine:hDictionary, "AlbProvL", dbfTmp )

      end if 
   next 

RETURN .t.

//---------------------------------------------------------------------------//

Static FUNCTION calculateUnidadesPendientesRecepcion( oLine )

   local nMod
   local nUnidadesRecibidas
   local nUnidadesPendientes

   nUnidadesRecibidas   := oLine:getUnitsReceived()
   nUnidadesPendientes  := oLine:getTotalUnits() - nUnidadesRecibidas

   if lCalCaj() .and. nUnidadesRecibidas != 0

      nMod              := mod( nUnidadesPendientes, oLine:getUnits() )
      if nMod == 0 .and. oLine:getBoxes() != 0
         oLine:setBoxes( div( nUnidadesPendientes, oLine:getBoxes() ) )
      else
         oLine:setBoxes( 0 )
         oLine:setUnits( nUnidadesPendientes )
      end if

   end if

RETURN ( oLine )

//---------------------------------------------------------------------------//

FUNCTION nombrePrimeraPropiedadAlbaranProveedoresLineas( view )

   DEFAULT view   := nView

RETURN ( nombrePropiedad( ( D():AlbaranesProveedoresLineas( view ) )->cCodPr1, ( D():AlbaranesProveedoresLineas( view ) )->cValPr1, view ) )

//---------------------------------------------------------------------------//

FUNCTION nombreSegundaPropiedadAlbaranProveedoresLineas( view )

   DEFAULT view   := nView

RETURN ( nombrePropiedad( ( D():AlbaranesProveedoresLineas( view ) )->cCodPr2, ( D():AlbaranesProveedoresLineas( view ) )->cValPr2, view ) )

//---------------------------------------------------------------------------//

static FUNCTION menuEdtDet( oCodArt, oDlg, nIdLin )

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

RETURN ( oDetMenu )

//---------------------------------------------------------------------------//