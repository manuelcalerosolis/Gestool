#include "FiveWin.Ch"
#include "Factu.ch"  
#include "Folder.ch"
#include "Report.ch"
#include "Print.ch"
#include "TWMail.ch"
#include "FastRepH.ch"
#include "Xbrowse.ch" 

#define OFN_PATHMUSTEXIST     0x00000800
#define OFN_NOCHANGEDIR       0x00000008
#define OFN_ALLOWMULTISELECT  0x00000200
#define OFN_EXPLORER          0x00080000     // new look commdlg
#define OFN_LONGNAMES         0x00200000     // force long names for 3.x modules
#define OFN_ENABLESIZING      0x00800000

#define _MENUITEM_            "01058"

#define CLR_BAR               14197607
#define CLR_KIT               Rgb( 239, 239, 239 )

#define fldGeneral            oFld:aDialogs[1]
#define fldData               oFld:aDialogs[2]
#define fldIncidencias        oFld:aDialogs[3]
#define fldDocumentos         oFld:aDialogs[4]
#define fldEntidades          oFld:aDialogs[5]
#define fldSituaciones        oFld:aDialogs[6]
#define fldRecibos            oFld:aDialogs[7]
#define fldAnticipos          oFld:aDialogs[8]

#define _CSERIE              1      //,"C",  1, 0, "Serie de la factura A o B" },;
#define _NNUMFAC             2      //,"N",  9, 0, "Numero de la factura" },;
#define _CSUFFAC             3      //,"C",  2, 0, "Sufijo de la factura" },;
#define _CGUID               4 
#define _CTURFAC             5      //,"C",  2, 0, "Sufijo de la factura" },;
#define _DFECFAC             6      //,"D",  8, 0, "Fecha de la factura" },;
#define _CCODCLI             7      //,"C", 12, 0, "Codigo del cliente" },;
#define _CCODALM             8      //,"C", 16, 0, "Codigo de almacen" },;
#define _CCODCAJ             9      //,"C",  3, 0, "Codigo de almacen" },;Tcome
#define _CNOMCLI            10      //,"C", 50, 0, "Nombre del cliente" },;
#define _CDIRCLI            11      //,"C", 60, 0, "Dirección del cliente" },;
#define _CPOBCLI            12      //,"C", 25, 0, "Población del cliente" },;
#define _CPRVCLI            13      //,"C", 20, 0, "Provincia del cliente" },;
#define _NCODPROV           14      //,"N",  2, 0, "Número de provincia cliente" },;
#define _CPOSCLI            15      //,"C",  5, 0, "Codigos postal del cliente" },;
#define _CDNICLI            16      //,"C", 15, 0, "DNI/CIF del cliente" },;
#define _LMODCLI            17
#define _LMAYOR             18      //,"L",  1, 0, "Lógico de mayorista" },;
#define _NTARIFA            19      //,"L",  1, 0, "Lógico de mayorista" },;
#define _CCODAGE            20      //,"C",  3, 0, "Codigo del agente" },;
#define _CCODRUT            21      //,"C",  4, 0, "Codigo de la ruta" },;
#define _CCODTAR            22      //,"C",  5, 0, "Codigo de la tarifa" },;
#define _CCODOBR            23      //,"C",  3, 0, "Codigo de la Dirección" },;
#define _NPCTCOMAGE         24      //,"N",  6, 2, "Porcentaje de Comisión del agente" },;
#define _LLIQUIDADA         25      //,"L",  1, 0, "Lógico de la liquidación" },;
#define _LCONTAB            26      //,"L",  1, 0, "Lógico de la contabilizaci-n" },;
#define _CCONGUID           27 
#define _DFECENT            28      //,"D",  8, 0, "Fecha de entrega" },;
#define _CSUFAC             29      //,"C", 10, 0, "Su factura" },;
#define _LIMPALB            30      //,"L", 10, 0, "Su pedido" },;
#define _CCONDENT           31      //,"C", 20, 0, "Condición de entrada" },;
#define _MCOMENT            32      //,"M", 10, 0, "Comentarios" },;
#define _MOBSERV            33      //,"M", 10, 0, "Observaciones" },;
#define _CCODPAGO           34      //,"C",  2, 0, "Codigo del tipo de pago" },;
#define _NBULTOS            35      //,"N",  3, 0, "Número de bultos" },;
#define _NPORTES            36      //,"N",  6, 0, "Valor de los portes" },;
#define _NIVAMAN            37      //,"N",  6, 0, "IvaValor de la mano de Dirección" },;
#define _NMANOBR            38      //,"N",  6, 0, "Valor de la mano de Dirección" },;
#define _CNUMALB            39      //,"C", 12, 0, "Número de albaran" },;
#define _CNUMPED            40      //,"C", 12, 0, "Número de pedido
#define _CNUMPRE            41      //,"C", 12, 0, "Número de presupuesto
#define _CNUMSAT            42      //,"C", 12, 0, "Número de presupuesto
#define _NTIPOFAC           43      //,"N",  1, 0, "Número del tipo de factura" },;
#define _CDTOESP            44      //,"N",  5, 2, "Porcentaje de descuento especial" },;
#define _NDTOESP            45      //,"N",  5, 2, "Porcentaje de descuento especial" },;
#define _CDPP               46      //,"N",  5, 2, "Porcentaje de descuento por pronto pago" },;
#define _NDPP               47      //,"N",  5, 2, "Porcentaje de descuento por pronto pago" },;
#define _CDTOUNO            48      //,"C", 25, 0, "Descripción de porcentaje de descuento personalizado"
#define _NDTOUNO            49      //,"N",  4, 1, "Porcentaje de descuento por descuento personalizado"
#define _CDTODOS            50      //,"C", 25, 0, "Descripción de porcentaje de descuento personalizado"
#define _NDTODOS            51      //,"N",  4, 1, "Porcentaje de descuento por descuento personalizado"
#define _NDTOCNT            52      //,"N",  6, 2, "Porcentaje de Descuento por pago de Contado" },;
#define _NDTORAP            53      //,"N",  6, 2, "Porcentaje de Descuento por Rappel" },;
#define _NDTOPUB            54      //,"N",  6, 2, "Porcentaje de Descuento por Publicidad" },;
#define _NDTOPGO            55      //,"N",  6, 2, "Porcentaje de Descuento por Pago Centralizado" },;
#define _NDTOPTF            56      //,"N",  7, 2, "Descuento por plataforma" },;
#define _NTIPOIVA           57      //,"N",  1, 0, "Número del tipo de " + cImp() },;
#define _NPORCIVA           58      //,"N",  4, 1, "Porcentaje de " + cImp() },;
#define _LRECARGO           59      //,"L",  1, 0, "Lógico para recargo" },;
#define _CREMITIDO          60      //,"C", 50, 0, "Campo de remitido" },;
#define _LIVAINC            61      //,"N",  1, 0, "Selección de " + cImp() },;
#define _LSNDDOC            62      //,"L",  1, 0, "Lógico para documento enviado" },;
#define _CDIVFAC            63      //,"C",  3, 0, "Codigo de la divisa" },;
#define _NVDVFAC            64      //,"N", 10, 4, "Cambio de la divisa" },;
#define _CRETPOR            65      //,"C",100, 0, "Retirado por" },;
#define _CRETMAT            66      //,"C",  8, 0, "Matricula" } }
#define _CNUMDOC            67      //,"C",  8, 0, "Matricula" } }
#define _NREGIVA            68
#define _CCODPRO            69
#define _CDOCORG            70
#define _NNUMLIQ            71     //"N",  9, 0, "Número liquidación" }                                  "",                   "", "( cDbf )"} )
#define _CSUFLIQ            72     //"C",  2, 0, "Sufijo liquidación" }                                  "",                   "", "( cDbf )"} )
#define _NIMPLIQ            73     //"N", 16, 6, "Importe liquidación" }                                 "",                   "", "( cDbf )"} )
#define _LLIQUID            74     //"L",  1, 0, "Logico de liquidado" }                                 "",                   "", "( cDbf )"} )
#define _CCODTRN            75     //"L",  1, 0, "Logico de liquidado" }                                 "",                   "", "( cDbf )"} )
#define _NKGSTRN            76     //"L",  1, 0, "Logico de liquidado" }                                 "",                   "", "( cDbf )"} )
#define _LCLOFAC            77     //"L",  1, 0, "Logico de liquidado" }                                 "",                   "", "( cDbf )"} )
#define _CABNFAC            78     //"C", 12, 0, "Número de presupuesto
#define _CANTFAC            79     //"C", 12, 0, "Número de presupuesto
#define _NTIPRET            80
#define _NPCTRET            81
#define _CCODUSR            82
#define _DFECCRE            83
#define _CTIMCRE            84
#define _CCODGRP            85
#define _LIMPRIMIDO         86      //   L      1     0
#define _DFECIMP            87      //   D      8     0
#define _CHORIMP            88      //   C      5     0
#define _CCODDLG            89
#define _NDTOATP            90      //   N      6     2     Porcentaje de descuento atípico
#define _NSBRATP            91      //   N      1     0     Lugar donde aplicar dto atípico
#define _DFECENTR           92
#define _DFECSAL            93
#define _LALQUILER          94
#define _LPAYCLI            95
#define _NPAYCLI            96
#define _CMANOBR            97
#define _LEXPEDI            98
#define _DFECEDI            99
#define _CHOREDI           100
#define _CSUALB            101
#define _LEXPFAC           102
#define _CTLFCLI           103
#define _NTOTNET           104
#define _NTOTSUP           105
#define _NTOTIVA           106
#define _NTOTREQ           107
#define _NTOTFAC           108
#define _NENTINI           109
#define _NPCTDTO           110
#define _CNFC              111
#define _CFACPRV           112
#define _CBANCO            113
#define _CPAISIBAN         114
#define _CCTRLIBAN         115
#define _CENTBNC           116
#define _CSUCBNC           117
#define _CDIGBNC           118
#define _CCTABNC           119
#define _NTOTLIQ           120
#define _NTOTPDT           121
#define _LOPERPV           122
#define _LRECC             123
#define _CCODPRY           124
#define _NDTOTARIFA        125
#define _LMAIL             126
#define _DMAIL             127
#define _TMAIL             128
#define _TFECFAC           129
#define _CCENTROCOSTE      130
#define _MFIRMA            131

/*
Definici-n de la base de datos de lineas de detalle
*/

#define _dCSERIE             1      //   C      1     0
#define _dNNUMFAC            2      //   N      9     0
#define _dCSUFFAC            3      //   C      2     0
#define _CREF                4      //   C     14     0
#define _CDETALLE            5      //   C     50     0
#define _NPREUNIT            6      //   N     13     3
#define _NPNTVER             7      //   N     13     6
#define _NIMPTRN             8      //   N     13     6
#define _NDTO                9      //   N      5     1
#define _NDTOPRM            10      //   N      5     1
#define _NIVA               11      //   N      6     2
#define _NCANENT            12      //   N     13     3
#define _LCONTROL           13      //   L      1     0
#define _NPESOKG            14      //   N      7     3
#define _CPESOKG            15      //   N      7     3
#define _CUNIDAD            16      //   C      2     0
#define __CCODAGE           17      //   N      5     1
#define _NCOMAGE            18      //   N      5     1
#define _NUNICAJA           19      //   N      9     3
#define _NUNDKIT            20      //   N     16     6
#define _DFECHA             21      //   D      8     0
#define _CTIPMOV            22      //   C      2     0
#define _MLNGDES            23      //   M     10     0
#define _CCODALB            24      //   C     12     0
#define _DFECALB            25      //   C     12     0
#define _LTOTLIN            26      //   L      1     0
#define _LIMPLIN            27      //   L      1     0
#define _CCODPR1            28
#define _CCODPR2            29
#define _CVALPR1            30
#define _CVALPR2            31
#define _NFACCNV            32
#define _NDTODIV            33
#define _LSEL               34
#define _NNUMLIN            35
#define _NCTLSTK            36
#define _NCOSDIV            37      //   N     13     3
#define _NPVPREC            38      //   N     13     3
#define _CALMLIN            39      //   C     3      0
#define _LIVALIN            40      //   C     3      0
#define _CCODIMP            41      //   C     3      0
#define _NVALIMP            42      //   N    16      6
#define _LLOTE              43      //   L     1      0
#define _NLOTE              44      //   N     4      0
#define _CLOTE              45      //   N     4      0
#define _DFECCAD            46      //   N     4      0
#define _LKITART            47      //   L     1      0
#define _LKITCHL            48      //   L     1      0
#define _LKITPRC            49      //   L     1      0
#define _NMESGRT            50      //   N     2      0 
#define _LMSGVTA            51
#define _LNOTVTA            52
#define _CCODTIP            53      //   C     3      0
#define _MNUMSER            54
#define _CCODFAM            55      //   C     8      0
#define _CGRPFAM            56      //   C     3      0
#define _NREQ               57      //   N    16      6
#define _MOBSLIN            58      //   M    10      0
#define _CCODPRV            59      //   C    12      0
#define _CNOMPRV            60      //   C    30      0
#define _CIMAGEN            61      //   C    30      0
#define _NPUNTOS            62
#define _NVALPNT            63
#define _NDTOPNT            64
#define _NINCPNT            65
#define _CREFPRV            66
#define _NVOLUMEN           67
#define _CVOLUMEN           68
#define __LALQUILER         69
#define __DFECENT           70
#define __DFECSAL           71
#define _NPREALQ            72
#define _NNUMMED            73
#define _NMEDUNO            74
#define _NMEDDOS            75
#define _NMEDTRE            76
#define _NTARLIN            77      //   L      1     0
#define _LIMPFRA            78
#define __CCODPRY           79
#define _CTXTFRA            80
#define _DESCRIP            81
#define _LLINOFE            82       // L       1    0
#define _LVOLIMP            83
#define _LGASSUP            84
#define __CNUMPED           85
#define __DFECFAC           86
#define _CSUPED             87     
#define __CNUMSAT           88
#define _DFECULTCOM         89
#define __CCODCLI           90
#define _LFROMATP           91
#define _NUNIULTCOM         92
#define __NBULTOS           93
#define _CFORMATO           94
#define __TFECFAC           95
#define __CCENTROCOSTE      96
#define _NLABEL             97
#define _LLABEL             98
#define __CCODOBR           99
#define _CREFAUX           100
#define _CREFAUX2          101
#define _NPOSPRINT         102
#define _CTIPCTR           103
#define _CTERCTR           104
#define _NNUMKIT           105
#define _ID_TIPO_V         106
#define __NREGIVA          107
#define _NPRCULTCOM        108

memvar cDbf
memvar cDbfCol
memvar cDbfCob
memvar cCliente
memvar cDbfCli
memvar cDivisa
memvar cDbfDiv
memvar cFPago
memvar cDbfPgo
memvar cIva
memvar cDbfIva
memvar cAgente
memvar cDbfAge
memvar cTvta
memvar cDbfTvt
memvar cObras
memvar cDbfUsr
memvar cDbfObr
memvar cDbfPedT
memvar cDbfPedL
memvar cDbfAlbT
memvar cDbfAlbL
memvar cDbfAntT
memvar cDbfAlbP
memvar cDbfTrn
memvar cDbfRut
memvar cDbfCajT
memvar aImpVto
memvar aDatVto
memvar aIvaUno
memvar aIvaDos
memvar aIvaTre
memvar aIvmUno
memvar aIvmDos
memvar aIvmTre
memvar aTotTip
memvar cCtaCli
memvar nTotBrt
memvar nTotDto
memvar nTotDpp
memvar nTotUno
memvar nTotDos
memvar nTotNet
memvar nTotSup
memvar nTotIva
memvar nTotReq
memvar nTotFac
memvar nTotPag
memvar nTotImp
memvar nTotPnt
memvar nTotRet
memvar nTotCob
memvar nTotCos
memvar nTotIvm
memvar aTotIvm
memvar nTotPes
memvar nTotAge
memvar nTotTrn
memvar nTotAtp
memvar nTotAnt
memvar nTotRnt
memvar nTotPctRnt
memvar nVdv
memvar nVdvDivFac
memvar cPicUndFac
memvar cPouDivFac
memvar cPorDivFac
memvar cPpvDivFac
memvar nDouDivFac
memvar nRouDivFac
memvar nDpvDivFac
memvar cCodPgo
memvar nTotArt
memvar nTotCaj
memvar lFacCli
memvar lAntCli
memvar oStk
memvar nTotalDto

memvar lEnd
memvar nRow
memvar oInf
memvar nPagina
memvar oReport

memvar aTotIva

/*
Variables Staticas para todo el .prg logico no!--------------------------------
*/

static oWndBrw

static nView

static oBrwIva
static oBrwPgo

static dbfRuta
static dbfTikT
static dbfTikL
static dbfTikS
static dbfPedCliE
static dbfFacRecT
static dbfFacRecL
static dbfFacRecS
static dbfAlbCliL
static dbfAlbCliT
static dbfAlbCliS
static dbfAlbCliP
static dbfAlbCliI
static dbfAlbCliD
static dbfPedCliT
static dbfPedCliL
static dbfPedCliI
static dbfPedCliD
static dbfPedCliP
static dbfPreCliT
static dbfPreCliL
static dbfPreCliI
static dbfPreCliD

static dbfFacCliI
static dbfFacCliD
static dbfFacCliS

static dbfFacPrvL
static dbfFacPrvS

static dbfSatCliT
static dbfSatCliL
static dbfSatCliI
static dbfSatCliD
static dbfSatCliS

static dbfAlbPrvL
static dbfAlbPrvS
static dbfPedCliR
static dbfProSer
static dbfMatSer

static dbfTmpLin
static dbfTmpInc
static dbfTmpDoc
static dbfTmpAnt
static dbfTmpPgo
static dbfTmpSer
Static dbfTmpEntidades
Static dbfTmpEst

static oTlfCli
static cTlfCli

static dbfIva
static dbfClient
static dbfCliBnc
static dbfArtPrv
static dbfPromoT
static dbfPromoL
static dbfPromoC
static dbfAlm
static dbfCodebar
static dbfTarPreT
static dbfTarPreL
static dbfTarPreS
static dbfOferta
static dbfDiv
static dbfObrasT
static dbfFamilia
static dbfProvee
static dbfKit

static dbfArtDiv
static dbfCajT
static dbfUsr
static dbfDelega
static dbfAgeCom
static dbfEmp
static dbfTblCnv
static dbfFacPrvT
static dbfRctPrvL
static dbfRctPrvS
static dbfProLin
static dbfProMat
static dbfHisMov
static dbfHisMovS
static dbfPedPrvL

static oStock
static TComercio

static oCtaRem
static oBandera
static oTrans
static oUndMedicion
static cTmpLin
static cTmpInc
static cTmpDoc
static cTmpAnt
static cTmpPgo
static cTmpSer
static cTmpEnt
static cTmpEst
static oTotFacLin
static oGetTotal
static oGetTarifa
static oGetNet
static oGetTotPnt
static oGetTotIvm
static oGetPctRet
static oGetIva
static oGetReq
static oGetAge
static oGetTotPg

static oGetPes
static oGetDif
static cPouDiv
static oMenu
static oDetMenu
static cPinDiv
static cPorDiv
static cPpvDiv
static cPicUnd
static nVdvDiv
static nDouDiv
static nRouDiv
static nDpvDiv
static oNewImp
static oTipArt
static oGrpFam
static oFraPub
static oBanco
static oPais
static oEntidades

static oImpuestos
static lImpuestos          := .t.

static oRiesgoCliente
static nRiesgoCliente      := 0

static oTotalLinea
static nTotalLinea         := 0
static oRentabilidadLinea
static cRentabilidadLinea  := ""
static oComisionLinea
static nComisionLinea      := 0

static nTotalRecibosPagados

static aNumAlb             := {}
static aNumSat             := {}

static oGetRnt
static cGetRnt             := ""
static oGetEnt
static oGetTrn
static cCodDiv
static oGetDtoEnt

static nTotal              := 0
static nTotalOld           := 0
static nTotalDif           := 0

static oBtnPre
static oBtnPed
static oBtnAlb
static oBtnGrp
static oBtnSat
static oBtnKit
static oBtnAtp
static oBtnPrecio

static cOldCodCli          := ""
static cOldCodArt          := ""
static cOldPrpArt          := ""
static cOldLotArt          := ""
static dOldFecCad          := cToD("")
static cOldUndMed          := ""
static lOpenFiles          := .f.
static lExternal        := .f.

static oClienteRutaNavigator
static oMailingFacturasClientes

static hOrdenRutas         := { "1" => "lVisDom", "2" => "lVisLun", "3" => "lVisMar", "4" => "lVisMie", "5" => "lVisJue", "6" => "lVisVie", "7" => "lVisSab", "8" => "Cod" }

static oTipFac
static aTipFac             := { "Venta", "Alquiler" }

static hCabeceraFactura    := 0
static hLineaFactura       := 0
static hVencimientoFactura := 0
static hDescuentoFactura   := 0
static hImpuestosFactura   := 0

static aImportacion        := {}
static lCancelImportacion  := .f.

static cFiltroUsuario      := ""

static oMeter
static nMeter              := 1

static oDetCamposExtra
static oLinDetCamposExtra
static oCentroCoste
static aEntidades          := {}

static oCbxRuta

static nUltimoCliente      := 0
static cSerieAnterior      := ""
static cCodPagoAnterior    := ""

static Counter

static oTipoCtrCoste
static cTipoCtrCoste
static aTipoCtrCoste       := { "Centro de coste", "Proveedor", "Agente", "Cliente" }

static bEdtRec             := { |aTmp, aGet, cFacCliT, oBrw, bWhen, bValid, nMode, aNumDoc| EdtRec( aTmp, aGet, cFacCliT, oBrw, bWhen, bValid, nMode, aNumDoc ) }
static bEdtDet             := { |aTmp, aGet, cFacCliL, oBrw, bWhen, bValid, nMode, aTmpFac| EdtDet( aTmp, aGet, cFacCliL, oBrw, bWhen, bValid, nMode, aTmpFac ) }
static bEdtInc             := { |aTmp, aGet, dbfFacCliI, oBrw, bWhen, bValid, nMode, aTmpLin| EdtInc( aTmp, aGet, dbfFacCliI, oBrw, bWhen, bValid, nMode, aTmpLin ) }
static bEdtDoc             := { |aTmp, aGet, dbfFacCliD, oBrw, bWhen, bValid, nMode, aTmpLin| EdtDoc( aTmp, aGet, dbfFacCliD, oBrw, bWhen, bValid, nMode, aTmpLin ) }
static bEdtEntidades       := { |aTmp, aGet, dbfTmpEntidades, oBrw, bWhen, bValid, nMode| EdtEntidades( aTmp, aGet, dbfTmpEntidades, oBrw, bWhen, bValid, nMode ) }
static bEdtTablet          := { |aTmp, aGet, cFacCliT, oBrw, bWhen, bValid, nMode, aNumDoc| EdtTablet( aTmp, aGet, cFacCliT, oBrw, bWhen, bValid, nMode, aNumDoc ) }
static bEdtDetTablet       := { |aTmp, aGet, cFacCliL, oBrw, bWhen, bValid, nMode, aTmpFac| EdtDetTablet( aTmp, aGet, cFacCliL, oBrw, bWhen, bValid, nMode, aTmpFac ) }
static bEdtEst             := { |aTmp, aGet, dbf, oBrw, bWhen, bValid, nMode, aTmpFac | EdtEst( aTmp, aGet, dbf, oBrw, bWhen, bValid, nMode, aTmpFac ) }

//---------------------------------------------------------------------------//
//Funciones del programa
//---------------------------------------------------------------------------//

FUNCTION FactCli( oMenuItem, oWnd, hHash )

   local oRpl
   local oSnd
   local oImp
   local oPrv
   local oPdf
   local oMail
   local oLiq
   local oDel
   local oDup
   local oBtnEur
   local lEuro          := .f.
   local nLevel
   local oRotor
   local oScript

   DEFAULT  oMenuItem   := _MENUITEM_
   DEFAULT  oWnd        := oWnd()

   nLevel               := nLevelUsr( oMenuItem )
   if nAnd( nLevel, 1 ) != 0
      msgStop( "Acceso no permitido." )
      Return .f.
   end if

   /*
   Cerramos todas las ventanas
   */

   if oWnd != nil
      SysRefresh(); oWnd:CloseAll(); SysRefresh()
   end if

   if !OpenFiles()
      Return .f.
   end if

   DisableAcceso()

   DEFINE SHELL oWndBrw FROM 0, 0 TO 22, 80 ;
      XBROWSE ;
      TITLE    "Facturas de clientes" ;
      PROMPT   "Número",;
               "Fecha",;
               "Código",;
               "Nombre",;
               "Código postal",;
               "Población",;
               "Provincia",;
               "Dirección",;
               "Agente",;
               "Sesión",;
               "NFC",;
               "Pago",;
               "Envio",;
               "Su albarán",;
               "Total";
      MRU      "gc_document_text_user_16";
      BITMAP   clrTopVentas ;
      ALIAS    ( D():FacturasClientes( nView ) );
      APPEND   ( WinAppRec( oWndBrw:oBrw, bEdtRec, D():FacturasClientes( nView ), hHash ) );
      DUPLICAT ( WinDupRec( oWndBrw:oBrw, bEdtRec, D():FacturasClientes( nView ), hHash ) );
      EDIT     ( WinEdtRec( oWndBrw:oBrw, bEdtRec, D():FacturasClientes( nView ), hHash ) );
      ZOOM     ( WinZooRec( oWndBrw:oBrw, bEdtRec, D():FacturasClientes( nView ) ) );
      DELETE   ( WinDelRec( oWndBrw:oBrw, D():FacturasClientes( nView ), {|| QuiFacCli() } ) );
      LEVEL    nLevel ;
      OF       oWnd

      oWndBrw:lFechado     := .t.

      oWndBrw:SetYearComboBoxChange( {|| YearComboBoxChange() } )

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Sesión cerrada"
         :nHeadBmpNo       := 3
         :bStrData         := {|| if( ( D():FacturasClientes( nView ) )->lCloFac, "Cerrada", "Abierta" ) }
         :bEditValue       := {|| ( D():FacturasClientes( nView ) )->lCloFac }
         :nWidth           := 20
         :SetCheck( { "gc_lock2_12" , "Nil16" } )
         :AddResource( "gc_lock2_16" )
         :bLDClickData     := {|| oWndBrw:RecEdit() }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Cobrado"
         :nHeadBmpNo       := 4
         :bStrData         := {|| cChkPagFacCli( ( D():FacturasClientes( nView ) )->cSerie + str( ( D():FacturasClientes( nView ) )->nNumFac ) + ( D():FacturasClientes( nView ) )->cSufFac, D():FacturasClientes( nView ), D():FacturasClientesCobros( nView ) ) }
         :bBmpData         := {|| nChkPagFacCli( ( D():FacturasClientes( nView ) )->cSerie + str( ( D():FacturasClientes( nView ) )->nNumFac ) + ( D():FacturasClientes( nView ) )->cSufFac, D():FacturasClientes( nView ), D():FacturasClientesCobros( nView ) ) }
         :nWidth           := 20
         :AddResource( "GC_CHECK_12" )
         :AddResource( "GC_SHAPE_SQUARE_12" )
         :AddResource( "GC_DELETE_12" )
         :AddResource( "gc_money2_16" )
         :bLDClickData     := {|| oWndBrw:RecEdit() }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Contabilizado"
         :nHeadBmpNo       := 3
         :bStrData         := {|| if( ( D():FacturasClientes( nView ) )->lContab, "Contabilizado", "Pendiente" ) }
         :bEditValue       := {|| ( D():FacturasClientes( nView ) )->lContab }
         :nWidth           := 20
         :SetCheck( { "gc_folder2_12", "Nil16" } )
         :AddResource( "gc_folder2_16" )
         :bLDClickData     := {|| oWndBrw:RecEdit() }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Envio"
         :cSortOrder       := "lSndDoc"
         :nHeadBmpNo       := 3
         :bStrData         := {|| if( ( D():FacturasClientes( nView ) )->lSndDoc, "Enviado", "No enviado" ) }
         :bEditValue       := {|| ( D():FacturasClientes( nView ) )->lSndDoc }
         :nWidth           := 20
         :SetCheck( { "gc_mail2_12", "Nil16" } )
         :AddResource( "GC_MAIL2_16" )
         :bLDClickData     := {|| oWndBrw:RecEdit() }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Entregado"
         :nHeadBmpNo       := 3
         :bStrData         := {|| "" }
         :bEditValue       := {|| !empty( ( D():FacturasClientes( nView ) )->dFecEnt ) }
         :nWidth           := 20
         :SetCheck( { "GC_HAND_PAPER_12", "Nil16" } )
         :AddResource( "GC_HAND_PAPER_16" )
         :bLDClickData     := {|| oWndBrw:RecEdit() }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Exportado EDI"
         :nHeadBmpNo       := 3
         :bStrData         := {|| "" }
         :bEditValue       := {|| ( D():FacturasClientes( nView ) )->lExpEdi }
         :nWidth           := 20
         :lHide            := .t.
         :SetCheck( { "gc_edi_16", "Nil16" } )
         :AddResource( "gc_edi_16" )
         :bLDClickData     := {|| oWndBrw:RecEdit() }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Exportado a Facturae 3.2 [Factura electrónica]"
         :nHeadBmpNo       := 3
         :bStrData         := {|| "" }
         :bEditValue       := {|| ( D():FacturasClientes( nView ) )->lExpFac }
         :nWidth           := 20
         :lHide            := .t.
         :SetCheck( { "gc_document_empty_world_16", "Nil16" } )
         :AddResource( "gc_document_empty_world_16" )
         :bLDClickData     := {|| oWndBrw:RecEdit() }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Incidencia"
         :nHeadBmpNo       := 4
         :bStrData         := {|| "" }
         :bBmpData         := {|| nEstadoIncidencia( ( D():FacturasClientes( nView ) )->cSerie + str( ( D():FacturasClientes( nView ) )->nNumFac ) + ( D():FacturasClientes( nView ) )->cSufFac ) }
         :nWidth           := 20
         :lHide            := .t.
         :AddResource( "gc_delete_12" )
         :AddResource( "gc_shape_square_12" )
         :AddResource( "gc_check_12" )
         :AddResource( "gc_document_information_16" )
         :bLDClickData     := {|| oWndBrw:RecEdit() }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Rectificada"
         :nHeadBmpNo       := 3
         :bStrData         := {|| "" }
         :bEditValue       := {|| lRectificadaCli( ( D():FacturasClientes( nView ) )->cSerie + str( ( D():FacturasClientes( nView ) )->nNumFac ) + ( D():FacturasClientes( nView ) )->cSufFac, D():FacturasClientes( nView ), dbfFacRecT ) }
         :nWidth           := 20
         :lHide            := .t.
         :SetCheck( { "gc_document_text_delete_12", "Nil16" } )
         :AddResource( "gc_document_text_delete_16" )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Impreso"
         :nHeadBmpNo       := 3
         :bStrData         := {|| "" }
         :bEditValue       := {|| ( D():FacturasClientes( nView ) )->lImprimido }
         :nWidth           := 20
         :lHide            := .t.
         :SetCheck( { "gc_printer2_12", "Nil16" } )
         :AddResource( "gc_printer2_16" )
         :bLDClickData     := {|| oWndBrw:RecEdit() }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "GC_MAIL_EARTH_"
         :nHeadBmpNo       := 3
         :bStrData         := {|| "" }
         :bEditValue       := {|| ( D():FacturasClientes( nView ) )->lMail }
         :nWidth           := 20
         :lHide            := .t.
         :SetCheck( { "gc_mail_earth_12", "Nil16" } )
         :AddResource( "gc_mail_earth_16" )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Número"
         :cSortOrder       := "nNumFac"
         :bEditValue       := {|| D():FacturasClientesIdTextShort( nView ) }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
         :bLDClickData     := {|| oWndBrw:RecEdit() }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Delegación"
         :bEditValue       := {|| ( D():FacturasClientes( nView ) )->cSufFac }
         :nWidth           := 40
         :lHide            := .t.
         :bLDClickData     := {|| oWndBrw:RecEdit() }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "NFC"
         :cSortOrder       := "cNfc"
         :bEditValue       := {|| ( D():FacturasClientes( nView ) )->cNFC }
         :nWidth           := 160
         :lHide            := .t.
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Sesión"
         :cSortOrder       := "cTurFac"
         :bEditValue       := {|| Trans( ( D():FacturasClientes( nView ) )->cTurFac, "######" ) }
         :nWidth           := 40
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
         :lHide            := .t.
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
         :bLDClickData     := {|| oWndBrw:RecEdit() }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Fecha"
         :cSortOrder       := "dFecDes"
         :bEditValue       := {|| Dtoc( ( D():FacturasClientes( nView ) )->dFecFac ) }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
         :bLDClickData     := {|| oWndBrw:RecEdit() }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Hora"
         :bEditValue       := {|| trans( ( D():FacturasClientes( nView ) )->tFecFac, "@R 99:99:99") }
         :nWidth           := 60
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Caja"
         :bEditValue       := {|| ( D():FacturasClientes( nView ) )->cCodCaj }
         :nWidth           := 40
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Usuario"
         :bEditValue       := {|| ( D():FacturasClientes( nView ) )->cCodUsr }
         :nWidth           := 40
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Código"
         :cSortOrder       := "cCodCli"
         :bEditValue       := {|| AllTrim( ( D():FacturasClientes( nView ) )->cCodCli ) }
         :nWidth           := 70
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
         :bLDClickData     := {|| oWndBrw:RecEdit() }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Nombre"
         :cSortOrder       := "cNomCli"
         :bEditValue       := {|| AllTrim( ( D():FacturasClientes( nView ) )->cNomCli ) }
         :nWidth           := 280
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
         :bLDClickData     := {|| oWndBrw:RecEdit() }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Código postal"
         :bEditValue       := {|| alltrim( ( D():FacturasClientes( nView ) )->cPosCli ) }
         :nWidth           := 60
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Población"
         :cSortOrder       := "cPobCli"
         :bEditValue       := {|| AllTrim( ( D():FacturasClientes( nView ) )->cPobCli ) }
         :nWidth           := 180
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
         :lHide            := .t.
         :bLDClickData     := {|| oWndBrw:RecEdit() }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Provincia"
         :bEditValue       := {|| alltrim( ( D():FacturasClientes( nView ) )->cPrvCli ) }
         :nWidth           := 100
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Agente"
         :cSortOrder       := "cCodAge"
         :bEditValue       := {|| ( D():FacturasClientes( nView ) )->cCodAge }
         :nWidth           := 50
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
         :bLDClickData     := {|| oWndBrw:RecEdit() }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Pago"
         :cSortOrder       := "cCodPago"
         :bEditValue       := {|| ( D():FacturasClientes( nView ) )->cCodPago }
         :nWidth           := 40
         :lHide            := .t.
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
         :bLDClickData     := {|| oWndBrw:RecEdit() }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Ruta"
         :bEditValue       := {|| ( D():FacturasClientes( nView ) )->cCodRut }
         :nWidth           := 40
         :bLDClickData     := {|| oWndBrw:RecEdit() }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Almacén"
         :bEditValue       := {|| ( D():FacturasClientes( nView ) )->cCodAlm }
         :nWidth           := 60
         :bLDClickData     := {|| oWndBrw:RecEdit() }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Dirección"
         :cSortOrder       := "cCodObr"
         :bEditValue       := {|| ( D():FacturasClientes( nView ) )->cCodObr }
         :nWidth           := 40
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
         :bLDClickData     := {|| oWndBrw:RecEdit() }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Base"
         :bEditValue       := {|| ( D():FacturasClientes( nView ) )->nTotNet }
         :cEditPicture     := cPorDiv()
         :nWidth           := 80
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := cImp()
         :bEditValue       := {|| ( D():FacturasClientes( nView ) )->nTotIva }
         :cEditPicture     := cPorDiv()
         :nWidth           := 80
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "R.E."
         :bEditValue       := {|| ( D():FacturasClientes( nView ) )->nTotReq }
         :cEditPicture     := cPorDiv()
         :nWidth           := 80
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Total"
         :bEditValue       := {|| ( D():FacturasClientes( nView ) )->nTotFac }
         :cEditPicture     := cPorDiv()
         :nWidth           := 80
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
         :cSortOrder       := "nTotFac"
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Div."
         :bEditValue       := {|| cSimDiv( if( lEuro, cDivChg(), ( D():FacturasClientes( nView ) )->cDivFac ), dbfDiv ) }
         :nWidth           := 30
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
         :bLDClickData     := {|| oWndBrw:RecEdit() }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Centro de coste"
         :bEditValue       := {|| ( D():FacturasClientes( nView ) )->cCtrCoste }
         :nWidth           := 30
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "N. pedido"
         :bEditValue       := {|| cNumeroPedidoFactura( ( D():FacturasClientes( nView ) )->cNumAlb ) }
         :nWidth           := 100
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "N. albarán"
         :bEditValue       := {|| if( !empty( ( D():FacturasClientes( nView ) )->cNumAlb ), Trans( ( D():FacturasClientes( nView ) )->cNumAlb, "@R #/#########/##" ), "" ) }
         :nWidth           := 100
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Su pedido"
         :bEditValue       := {|| ( D():FacturasClientes( nView ) )->cSuFac }
         :nWidth           := 100
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Su albarán"
         :bEditValue       := {|| ( D():FacturasClientes( nView ) )->cSuAlb }
         :nWidth           := 100
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Creación/Modificación"
         :bEditValue       := {|| dtoc( ( D():FacturasClientes( nView ) )->dFecCre ) + space( 1 ) + ( D():FacturasClientes( nView ) )->cTimCre }
         :nWidth           := 120
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Bultos"
         :bEditValue       := {|| ( D():FacturasClientes( nView ) )->nBultos }
         :cEditPicture     := "99999"
         :nWidth           := 95
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
         :lHide            := .t.
         :nEditType        := 1
         :bOnPostEdit      := {|oCol, uNewValue, nKey| ChangeBultos( oCol, uNewValue, nKey ) }
      end with

   oDetCamposExtra:addCamposExtra( oWndBrw )

   oWndBrw:cHtmlHelp    := "Factura a clientes"

   oWndBrw:CreateXFromCode()

   DEFINE BTNSHELL RESOURCE "BUS" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( oWndBrw:SearchSetFocus() ) ;
      TOOLTIP  "(B)uscar" ;
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
         ACTION   ( WinDelRec( oWndBrw:oBrw, D():FacturasClientes( nView ), {|| QuiFacCli() } ) );
         MENU     This:Toggle() ;
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
         ACTION   ( selectedGenFacCli( IS_PRINTER ), oWndBrw:Refresh() ) ;
         TOOLTIP  "(I)mprimir";
         HOTKEY   "I";
         LEVEL    ACC_IMPR

         lGenFacCli( oWndBrw:oBrw, oImp, IS_PRINTER ) 

      DEFINE BTNSHELL RESOURCE "GC_PRINTER2_" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( ImprimirSeriesFacturas() );
         TOOLTIP  "Imp(r)imir series";
         HOTKEY   "R";
         LEVEL    ACC_IMPR

      DEFINE BTNSHELL oPrv RESOURCE "PREV1" OF oWndBrw ;
         NOBORDER ;
         MENU     This:Toggle() ;
         ACTION   ( selectedGenFacCli( IS_SCREEN ), oWndBrw:Refresh() ) ;
         TOOLTIP  "(P)revisualizar";
         HOTKEY   "P";
         LEVEL    ACC_IMPR

         lGenFacCli( oWndBrw:oBrw, oPrv, IS_SCREEN ) ;

      DEFINE BTNSHELL oPdf RESOURCE "DOCLOCK" OF oWndBrw ;
         NOBORDER ;
         MENU     This:Toggle() ;
         ACTION   ( selectedGenFacCli( IS_PDF ) ) ;
         TOOLTIP  "Pd(f)";
         HOTKEY   "F";
         LEVEL    ACC_IMPR

         lGenFacCli( oWndBrw:oBrw, oPdf, IS_PDF ) ;

      DEFINE BTNSHELL oMail RESOURCE "GC_MAIL_EARTH_" OF oWndBrw ;
         NOBORDER ;
         MENU     This:Toggle() ;
         ACTION   ( oMailingFacturasClientes:documentsDialog( oWndBrw:oBrw:aSelected ) ) ;
         TOOLTIP  "Correo electrónico";
         LEVEL    ACC_IMPR

      DEFINE BTNSHELL RESOURCE "GC_MAIL_EARTH_" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( oMailingFacturasClientes:databaseDialog() );
         TOOLTIP  "Correo electrónico series";
         LEVEL    ACC_IMPR 

      DEFINE BTNSHELL RESOURCE "gc_portable_barcode_scanner_" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( TLabelGeneratorFacturasClientes():New( nView ):Dialog() ) ;
         TOOLTIP  "Eti(q)uetas" ;
         HOTKEY   "Q";
         LEVEL    ACC_IMPR

      DEFINE BTNSHELL oLiq RESOURCE "gc_money2_" OF oWndBrw GROUP ;
         NOBORDER ;
         ACTION   ( lLiquida( oWndBrw:oBrw ) ) ;
         TOOLTIP  "C(o)brar" ;
         HOTKEY   "O";
         LEVEL    ACC_APPD

      DEFINE BTNSHELL RESOURCE "gc_money2_" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( aGetSelRec( oWndBrw, {|| lLiquida( oWndBrw:oBrw, ( D():FacturasClientes( nView ) )->cSerie + str( ( D():FacturasClientes( nView ) )->nNumFac ) + ( D():FacturasClientes( nView ) )->cSufFac ) }, "Liquidar series de facturas", .t., nil, .t., nil ) ) ;
         TOOLTIP  "Cobrar series" ;
         FROM     oLiq ;
         CLOSED ;
         LEVEL    ACC_EDIT

      DEFINE BTNSHELL RESOURCE "BMPCONTA" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( aGetSelRec( oWndBrw, {|lChk1, lChk2, oTree| CntFacCli( lChk1, lChk2, nil, .t., oTree, nil, nil, D():FacturasClientes( nView ), D():FacturasClientesLineas( nView ), D():FacturasClientesCobros( nView ), D():AnticiposClientes( nView ), D():Clientes( nView ), dbfDiv, D():Articulos( nView ), D():FormasPago( nView ), dbfIva, oNewImp ) }, "Contabilizar facturas", lAplicacionA3(), "Simular resultados", .f., "Contabilizar recibos", , {|| if( lAplicacionA3(), ( EnlaceA3():GetInstance():WriteASCII(), EnlaceA3():DestroyInstance() ), .t. ) } ) ) ;
         TOOLTIP  "(C)ontabilizar" ;
         HOTKEY   "C";
         LEVEL    ACC_EDIT

   if oUser():lAdministrador()

      DEFINE BTNSHELL RESOURCE "CHGSTATE" OF oWndBrw GROUP;
         NOBORDER ;
         ACTION   ( aGetSelRec( oWndBrw, {| lChk | lChgContabilizado( lChk ) }, "Cambiar estado", .f., "Contabilizado", .t. ) ) ;
         TOOLTIP  "Cambiar es(t)ado" ;
         HOTKEY   "T";
         LEVEL    ACC_EDIT

   end if

      DEFINE BTNSHELL oSnd RESOURCE "LBL" GROUP OF oWndBrw ;
         NOBORDER ;
         MENU     This:Toggle() ;
         TOOLTIP  "En(v)iar" ;
         MESSAGE  "Seleccionar facturas para ser enviadas" ;
         ACTION   lSnd( oWndBrw, D():FacturasClientes( nView ) ) ;
         HOTKEY   "V";
         LEVEL    ACC_EDIT

      DEFINE BTNSHELL RESOURCE "LBL" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( lSelectAll( oWndBrw, D():FacturasClientes( nView ), "lSndDoc", .t., .t., .t. ) );
         TOOLTIP  "Todos" ;
         FROM     oSnd ;
         CLOSED ;
         LEVEL    ACC_EDIT

      DEFINE BTNSHELL RESOURCE "LBL" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( lSelectAll( oWndBrw, D():FacturasClientes( nView ), "lSndDoc", .f., .t., .t. ) );
         TOOLTIP  "Ninguno" ;
         FROM     oSnd ;
         CLOSED ;
         LEVEL    ACC_EDIT

      DEFINE BTNSHELL RESOURCE "LBL" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( lSelectAll( oWndBrw, D():FacturasClientes( nView ), "lSndDoc", .t., .f., .t. ) );
         TOOLTIP  "Abajo" ;
         FROM     oSnd ;
         CLOSED ;
         LEVEL    ACC_EDIT

      DEFINE BTNSHELL RESOURCE "gc_document_text_earth_" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( aGetSelRec( oWndBrw, {|lChk1, lChk2, oTree| CreateFileFacturae( oTree, lChk1, lChk2 ) }, "Exportar facturas electrónicas a Facturae v 3.2", .f., "Firmar digitalmente (necesita runtime de Java)", .t., "Enviar por correo electrónico" ) ) ;
         TOOLTIP  "Exportar a Facturae 3.2" ;
         LEVEL    ACC_EDIT

      DEFINE BTNSHELL RESOURCE "gc_edi_" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( aGetSelRec( oWndBrw, {|lNoExportadas, lChk2, oTree| runEDIScript( lNoExportadas, oTree, nView ) }, "Exportar facturas a EDI", .f., "Solo las no exportadas", .t. ) ) ;
         TOOLTIP  "Exportar a EDI" ;
         LEVEL    ACC_EDIT

      DEFINE BTNSHELL oBtnEur RESOURCE "gc_currency_euro_" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( lEuro := !lEuro, oWndBrw:Refresh() ) ;
         TOOLTIP  "Moneda";
         LEVEL    ACC_ZOOM

   if oUser():lAdministrador()

      DEFINE BTNSHELL oRpl RESOURCE "BMPCHG" GROUP OF oWndBrw ;
         NOBORDER ;
         MENU     This:Toggle() ;
         ACTION   ( ReplaceCreator( oWndBrw, D():FacturasClientes( nView ), aItmFacCli() ) ) ;
         TOOLTIP  "Cambiar campos" ;
         LEVEL    ACC_EDIT

      DEFINE BTNSHELL RESOURCE "BMPCHG" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( ReplaceCreator( oWndBrw, D():FacturasClientesLineas( nView ), aColFacCli() ) ) ;
         TOOLTIP  "Lineas" ;
         FROM     oRpl ;
         CLOSED ;
         LEVEL    ACC_EDIT

   end if

      DEFINE BTNSHELL RESOURCE "INFO" GROUP OF oWndBrw ;
         NOBORDER ;
         ACTION   ( TTrazaDocumento():Activate( FAC_CLI, ( D():FacturasClientes( nView ) )->cSerie + str( ( D():FacturasClientes( nView ) )->nNumFac ) + ( D():FacturasClientes( nView ) )->cSufFac ) ) ;
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

         ImportScript( oWndBrw, oScript, "FacturasClientes" )  

      DEFINE BTNSHELL oRotor RESOURCE "ROTOR" GROUP OF oWndBrw ;
         NOBORDER ;
         MENU     This:Toggle() ;
         ACTION   ( oRotor:Expand() ) ;
         TOOLTIP  "Rotor" ;

      DEFINE BTNSHELL RESOURCE "GC_USER_" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( EdtCli( ( D():FacturasClientes( nView ) )->cCodCli ) );
         TOOLTIP  "Modificar cliente" ;
         FROM     oRotor ;

      DEFINE BTNSHELL RESOURCE "INFO" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( InfCliente( ( D():FacturasClientes( nView ) )->cCodCli ) );
         TOOLTIP  "Informe de cliente" ;
         FROM     oRotor ;

      DEFINE BTNSHELL RESOURCE "GC_CLIPBOARD_EMPTY_USER_" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( EdtObras( ( D():FacturasClientes( nView ) )->cCodCli, ( D():FacturasClientes( nView ) )->cCodObr, dbfObrasT ) );
         TOOLTIP  "Modificar Dirección" ;
         FROM     oRotor ;

      DEFINE BTNSHELL RESOURCE "GC_NOTEBOOK_USER_" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( if( !empty( ( D():FacturasClientes( nView ) )->cNumPre ), ZooPreCli( ( D():FacturasClientes( nView ) )->cNumPre ), MsgStop( "No hay presupusto asociado" ) ) );
         TOOLTIP  "Visualizar presupuesto" ;
         FROM     oRotor ;

      DEFINE BTNSHELL RESOURCE "GC_CLIPBOARD_EMPTY_USER_" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( if( !empty( ( D():FacturasClientes( nView ) )->cNumPed ), ZooPedCli( ( D():FacturasClientes( nView ) )->cNumPed ), MsgStop( "No hay pedido asociado" ) ) );
         TOOLTIP  "Visualizar pedido" ;
         FROM     oRotor ;

      DEFINE BTNSHELL RESOURCE "GC_DOCUMENT_EMPTY_" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( if( !empty( ( D():FacturasClientes( nView ) )->cNumAlb ), ZooAlbCli( ( D():FacturasClientes( nView ) )->cNumAlb ), MsgStop( "No hay albarán asociado" ) ) );
         TOOLTIP  "Visualizar albarán" ;
         FROM     oRotor ;

      DEFINE BTNSHELL RESOURCE "GC_BRIEFCASE2_BUSINESSMAN_" OF oWndBrw ;
         ALLOW    EXIT ;
         ACTION   ( RecCli( , , { ( ( D():FacturasClientes( nView ) )->cSerie + str( ( D():FacturasClientes( nView ) )->nNumFac ) + ( D():FacturasClientes( nView ) )->cSufFac ) } ) );
         TOOLTIP  "Modificar recibo" ;
         FROM     oRotor ;

      DEFINE BTNSHELL RESOURCE "GC_DOCUMENT_TEXT_MONEY2_" OF oWndBrw ;
         ALLOW    EXIT ;
         ACTION   ( FacAntCli( nil, nil, ( D():FacturasClientes( nView ) )->cCodCli ) );
         TOOLTIP  "Generar anticipo" ;
         FROM     oRotor ;

      DEFINE BTNSHELL RESOURCE "GC_NOTE_" OF oWndBrw ;
         ALLOW    EXIT ;
         ACTION   ( FacCliNotas() );
         TOOLTIP  "Generar nota de agenda" ;
         FROM     oRotor ;

   if ( "VI" $ appParamsMain() )

      DEFINE BTNSHELL RESOURCE "GC_DOCUMENT_TEXT_MONEY2_" OF oWndBrw ;
         ALLOW    EXIT ;
         ACTION   ( ExcelIsra() );
         TOOLTIP  "Excel israel" ;
         FROM     oRotor ;

   end if

   DEFINE BTNSHELL RESOURCE "END" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( oWndBrw:End() ) ;
      TOOLTIP  "(S)alir" ;
      HOTKEY   "S" ;
      ALLOW EXIT ;

   if !oUser():lFiltroVentas()
      oWndBrw:oActiveFilter:SetFields( aItmFacCli() )
      oWndBrw:oActiveFilter:SetFilterType( FAC_CLI )
   end if

   ACTIVATE WINDOW oWndBrw VALID ( CloseFiles() )

   enableAcceso()

   if !empty(oWndBrw)

      if uFieldempresa( 'lFltYea' )
         oWndBrw:setYearCombobox()
      end if

      if !empty( hHash ) 
         oWndBrw:RecAdd()
         hHash             := nil
      end if

   end if 

Return .t.

//----------------------------------------------------------------------------//

STATIC FUNCTION GenFacCli( nDevice, cCaption, cCodDoc, cPrinter, nCopies )

   if ( D():FacturasClientes( nView ) )->( lastrec() ) == 0
      return nil
   end if

   DEFAULT nDevice      := IS_PRINTER
   DEFAULT cCaption     := "Imprimiendo facturas a clientes"
   DEFAULT cCodDoc      := cFormatoFacturasClientes()
   DEFAULT cPrinter     := cPrinterFactura( oUser():cCaja(), dbfCajT )

   if empty( nCopies )
      nCopies           := retfld( ( D():FacturasClientes( nView ) )->cCodCli, D():Clientes( nView ), "CopiasF" )
   end if

   if nCopies == 0
      nCopies           := nCopiasDocumento( ( D():FacturasClientes( nView ) )->cSerie, "nFacCli", D():Contadores( nView ) )
   end if

   if nCopies == 0
      nCopies           := 1
   end if 

   if !lExisteDocumento( cCodDoc, D():Documentos( nView ) )
      return nil
   end if

   // Si el documento es de tipo visual-------------------------------------------

   if lVisualDocumento( cCodDoc, D():Documentos( nView ) )
      printReportFacCli( nDevice, nCopies, cPrinter, cCodDoc )
   else
      msgStop( "El formato ya no es soportado" )
   end if

   // Funcion para marcar el documento como imprimido-----------------------------

   lChgImpDoc( D():FacturasClientes( nView ) )

Return ( nil )

//---------------------------------------------------------------------------//

FUNCTION imprimeFacturaCliente( cNumeroFactura, cFormatoDocumento )

   local nLevel         := nLevelUsr( _MENUITEM_ )

   if nAnd( nLevel, 1 ) != 0 .or. nAnd( nLevel, ACC_IMPR ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if OpenFiles()

      if dbSeekInOrd( cNumeroFactura, "nNumFac", D():FacturasClientes( nView ) )

         nTotFacCli()

         genFacCli( IS_PRINTER, nil, cFormatoDocumento )

      else

         msgStop( "Número de factura " + alltrim( cNumeroFactura ) + " no encontrado.", "Stop! " + str( len( cNumeroFactura ) ) )

      end if

      sysrefresh()

      CloseFiles()

   end if

   nView                := nil

Return .t.

//---------------------------------------------------------------------------//

Static Function FacCliReportSkipper( cNumFac )

   if ( D():FacturasClientesLineas( nView ) )->cSerie + str( ( D():FacturasClientesLineas( nView ) )->nNumFac ) + ( D():FacturasClientesLineas( nView ) )->cSufFac = cNumFac .and. !( D():FacturasClientesLineas( nView ) )->( eof() )

      nTotPag              += nTotLFacCli( D():FacturasClientesLineas( nView ) )

      ( D():FacturasClientesLineas( nView ) )->( dbSkip() )

      if ( D():FacturasClientesLineas( nView ) )->cSerie + str( ( D():FacturasClientesLineas( nView ) )->nNumFac ) + ( D():FacturasClientesLineas( nView ) )->cSufFac != cNumFac .or. ( D():FacturasClientesLineas( nView ) )->( eof() )
         lFacCli           := .f.
         lAntCli           := .t.
      end if

   elseif ( D():AnticiposClientes( nView ) )->cNumDoc = cNumFac .and. !( D():AnticiposClientes( nView ) )->( eof() )

      ( D():AnticiposClientes( nView ) )->( dbSkip() )

   end if

Return nil

//---------------------------------------------------------------------------//

Static Function EPage( oInf, cCodDoc )

   private nPagina      := oInf:nPage
   private lEnd         := oInf:lFinish
   private nRow         := oInf:nRow

   /*
   Reposicionamos en las distintas areas
   */

   PrintItems( cCodDoc, oInf )

RETURN NIL

//----------------------------------------------------------------------------//

STATIC FUNCTION OpenFiles()

   local oBlock
   local oError

   if lOpenFiles
      MsgStop( 'Imposible abrir ficheros de facturas de clientes', 'Ficheros actualmente en uso' )
      Return ( .f. )
   end if

   oBlock               := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      DisableAcceso()

      /*
      Apertura de bases de datos de facturas de clientes-------------------------
      */

      nView    := D():CreateView()

      D():FacturasClientes( nView )

      D():FacturasClientesLineas( nView )

      D():FacturasClientesEntidades( nView )

      D():FacturasClientesSituaciones( nView )

      D():Clientes( nView )

      D():objectGruposClientes( nView )

      D():ClientesEntidad( nView )

      D():ArticuloStockAlmacenes( nView )   

      D():Articulos( nView )

      D():Contadores( nView )

      D():Agentes( nView )

      D():Documentos( nView )
      ( D():Documentos( nView ) )->( ordSetFocus( "cTipo" ) )

      D():ArticuloLenguaje( nView )

      D():ClientesEntidad( nView )

      D():GetObject( "UnidadMedicion", nView )

      D():ImpuestosEspeciales( nView )
      
      D():FacturasClientesCobros( nView )
      ( D():FacturasClientesCobros( nView ) )->( ordsetfocus( "fNumFac" ) )

      D():Propiedades( nView )

      D():PropiedadesLineas( nView )

      D():FormasPago( nView )

      D():AnticiposClientes( nView )

      D():EmpresaBancos( nView )

      USE ( cPatEmp() + "FACCLII.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACCLII", @dbfFacCliI ) )
      SET ADSINDEX TO ( cPatEmp() + "FACCLII.CDX" ) ADDITIVE

      USE ( cPatEmp() + "FACCLID.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACCLID", @dbfFacCliD ) )
      SET ADSINDEX TO ( cPatEmp() + "FACCLID.CDX" ) ADDITIVE

      USE ( cPatEmp() + "FACCLIS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACCLIS", @dbfFacCliS ) )
      SET ADSINDEX TO ( cPatEmp() + "FACCLIS.CDX" ) ADDITIVE

      /*
      Atipicas de clientes-----------------------------------------------------
      */

      D():Atipicas( nView )

      D():Get( "CliInc", nView )

      USE ( cPatEmp() + "FACRECT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACRECT", @dbfFacRecT ) )
      SET ADSINDEX TO ( cPatEmp() + "FACRECT.CDX" ) ADDITIVE

      USE ( cPatEmp() + "FACRECL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACRECL", @dbfFacRecL ) )
      SET ADSINDEX TO ( cPatEmp() + "FACRECL.CDX" ) ADDITIVE

      USE ( cPatEmp() + "FACRECS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACRECS", @dbfFacRecS ) )
      SET ADSINDEX TO ( cPatEmp() + "FACRECS.CDX" ) ADDITIVE

      if !TDataCenter():OpenAlbCliT( @dbfAlbCliT )
         lOpenFiles     := .f.
      end if

      USE ( cPatEmp() + "ALBCLIL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALBCLIL", @dbfAlbCliL ) )
      SET ADSINDEX TO ( cPatEmp() + "ALBCLIL.CDX" ) ADDITIVE

      USE ( cPatEmp() + "ALBCLIP.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALBCLIP", @dbfAlbCliP ) )
      SET ADSINDEX TO ( cPatEmp() + "ALBCLIP.CDX" ) ADDITIVE

      USE ( cPatEmp() + "ALBCLII.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALBCLII", @dbfAlbCliI ) )
      SET ADSINDEX TO ( cPatEmp() + "ALBCLII.CDX" ) ADDITIVE

      USE ( cPatEmp() + "ALBCLID.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALBCLID", @dbfAlbCliD ) )
      SET ADSINDEX TO ( cPatEmp() + "ALBCLID.CDX" ) ADDITIVE

      USE ( cPatEmp() + "ALBCLIS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALBCLIS", @dbfAlbCliS ) )
      SET ADSINDEX TO ( cPatEmp() + "ALBCLIS.CDX" ) ADDITIVE

      /*
      Tabla de SAT-------------------------------------------------------------
      */

      if !TDataCenter():OpenSatCliT( @dbfSatCliT )
         lOpenFiles        := .f.
      end if

      USE ( cPatEmp() + "SatCliL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "SatCliL", @dbfSatCliL ) )
      SET ADSINDEX TO ( cPatEmp() + "SatCliL.CDX" ) ADDITIVE

      USE ( cPatEmp() + "SatCliI.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "SatCliI", @dbfSatCliI ) )
      SET ADSINDEX TO ( cPatEmp() + "SatCliI.CDX" ) ADDITIVE

      USE ( cPatEmp() + "SatCliD.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "SatCliD", @dbfSatCliD ) )
      SET ADSINDEX TO ( cPatEmp() + "SatCliD.CDX" ) ADDITIVE

      USE ( cPatEmp() + "SatCliS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "SatCliS", @dbfSatCliS ) )
      SET ADSINDEX TO ( cPatEmp() + "SatCliS.CDX" ) ADDITIVE

      if !TDataCenter():OpenPedCliT( @dbfPedCliT )
         lOpenFiles        := .f.
      end if 

      USE ( cPatEmp() + "PEDCLIL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PEDCLIT", @dbfPedCliL ) )
      SET ADSINDEX TO ( cPatEmp() + "PEDCLIL.CDX" ) ADDITIVE

      USE ( cPatEmp() + "PEDCLIP.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PEDCLIP", @dbfPedCliP ) )
      SET ADSINDEX TO ( cPatEmp() + "PEDCLIP.CDX" ) ADDITIVE

      USE ( cPatEmp() + "PEDCLII.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PEDCLII", @dbfPedCliI ) )
      SET ADSINDEX TO ( cPatEmp() + "PEDCLII.CDX" ) ADDITIVE

      USE ( cPatEmp() + "PEDCLID.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PEDCLID", @dbfPedCliD ) )
      SET ADSINDEX TO ( cPatEmp() + "PEDCLID.CDX" ) ADDITIVE

      USE ( cPatEmp() + "PEDCLIR.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PEDCLIR", @dbfPedCliR ) )
      SET ADSINDEX TO ( cPatEmp() + "PEDCLIR.CDX" ) ADDITIVE

      if !TDataCenter():OpenPreCliT( @dbfPreCliT )
         lOpenFiles     := .f.
      end if 

      USE ( cPatEmp() + "PRECLIL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PRECLIL", @dbfPreCliL ) )
      SET ADSINDEX TO ( cPatEmp() + "PRECLIL.CDX" ) ADDITIVE

      USE ( cPatEmp() + "PRECLII.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PRECLII", @dbfPreCliI ) )
      SET ADSINDEX TO ( cPatEmp() + "PRECLII.CDX" ) ADDITIVE

      USE ( cPatEmp() + "PRECLID.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PRECLID", @dbfPreCliD ) )
      SET ADSINDEX TO ( cPatEmp() + "PRECLID.CDX" ) ADDITIVE

      USE ( cPatEmp() + "TIKET.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIKET", @dbfTikT ) )
      SET ADSINDEX TO ( cPatEmp() + "TIKET.CDX" ) ADDITIVE

      USE ( cPatEmp() + "TIKEL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIKEL", @dbfTikL ) )
      SET ADSINDEX TO ( cPatEmp() + "TIKEL.CDX" ) ADDITIVE

      USE ( cPatEmp() + "TIKES.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIKES", @dbfTikS ) )
      SET ADSINDEX TO ( cPatEmp() + "TIKES.CDX" ) ADDITIVE

      USE ( cPatCli() + "CliBnc.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CLIBNC", @dbfCliBnc ) )
      SET ADSINDEX TO ( cPatCli() + "CliBnc.Cdx" ) ADDITIVE

      USE ( cPatArt() + "PROVART.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PROVART", @dbfArtPrv ) ) 
      SET ADSINDEX TO ( cPatArt() + "PROVART.CDX" ) ADDITIVE

      USE ( cPatArt() + "ArtCodebar.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CODEBAR", @dbfCodebar ) )
      SET ADSINDEX TO ( cPatArt() + "ArtCodebar.Cdx" ) ADDITIVE

      USE ( cPatArt() + "FAMILIAS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FAMILIAS", @dbfFamilia ) )
      SET ADSINDEX TO ( cPatArt() + "FAMILIAS.CDX" ) ADDITIVE

      USE ( cPatArt() + "ARTKIT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ARTTIK", @dbfKit ) )
      SET ADSINDEX TO ( cPatArt() + "ARTKIT.CDX" ) ADDITIVE

      USE ( cPatArt() + "TARPRET.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TARPRET", @dbfTarPreT ) )
      SET ADSINDEX TO ( cPatArt() + "TARPRET.CDX" ) ADDITIVE

      USE ( cPatArt() + "TARPREL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TARPREL", @dbfTarPreL ) )
      SET ADSINDEX TO ( cPatArt() + "TARPREL.CDX" ) ADDITIVE

      USE ( cPatArt() + "TARPRES.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TARPRES", @dbfTarPreS ) )
      SET ADSINDEX TO ( cPatArt() + "TARPRES.CDX" ) ADDITIVE

      USE ( cPatArt() + "PROMOT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PROMOL", @dbfPromoT ) )
      SET ADSINDEX TO ( cPatArt() + "PROMOT.CDX" ) ADDITIVE

      USE ( cPatArt() + "PROMOL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PROMOL", @dbfPromoL ) )
      SET ADSINDEX TO ( cPatArt() + "PROMOL.CDX" ) ADDITIVE

      USE ( cPatArt() + "PROMOC.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PROMOC", @dbfPromoC ) )
      SET ADSINDEX TO ( cPatArt() + "PROMOC.CDX" ) ADDITIVE

      USE ( cPatDat() + "TIVA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIVA", @dbfIva ) )
      SET ADSINDEX TO ( cPatDat() + "TIVA.CDX" ) ADDITIVE

      USE ( cPatDat() + "DIVISAS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "DIVISAS", @dbfDiv ) )
      SET ADSINDEX TO ( cPatDat() + "DIVISAS.CDX" ) ADDITIVE

      USE ( cPatCli() + "ObrasT.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "OBRAST", @dbfObrasT ) )
      SET ADSINDEX TO ( cPatCli() + "ObrasT.Cdx" ) ADDITIVE

      USE ( cPatArt() + "OFERTA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "OFERTA", @dbfOferta ) )
      SET ADSINDEX TO ( cPatArt() + "OFERTA.CDX" ) ADDITIVE

      USE ( cPatCli() + "RUTA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "RUTA", @dbfRuta ) )
      SET ADSINDEX TO ( cPatCli() + "RUTA.CDX" ) ADDITIVE

      USE ( cPatArt() + "ARTDIV.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ARTDIV", @dbfArtDiv ) )
      SET ADSINDEX TO ( cPatArt() + "ARTDIV.CDX" ) ADDITIVE

      USE ( cPatDat() + "Cajas.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CAJAS", @dbfCajT ) )
      SET ADSINDEX TO ( cPatDat() + "Cajas.Cdx" ) ADDITIVE

      USE ( cPatAlm() + "Almacen.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "Almacen", @dbfAlm ) )
      SET ADSINDEX TO ( cPatAlm() + "Almacen.CDX" ) ADDITIVE

      USE ( cPatDat() + "USERS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "USERS", @dbfUsr ) )
      SET ADSINDEX TO ( cPatDat() + "USERS.CDX" ) ADDITIVE

      USE ( cPatDat() + "DELEGA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "DELEGA", @dbfDelega ) )
      SET ADSINDEX TO ( cPatDat() + "DELEGA.CDX" ) ADDITIVE

      USE ( cPatEmp() + "AGECOM.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "AGECOM", @dbfAgeCom ) )
      SET ADSINDEX TO ( cPatEmp() + "AGECOM.CDX" ) ADDITIVE

      USE ( cPatEmp() + "ALBPROVL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALBPROVL", @dbfAlbPrvL ) )
      SET ADSINDEX TO ( cPatEmp() + "ALBPROVL.CDX" ) ADDITIVE

      USE ( cPatEmp() + "ALBPRVS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALBPRVS", @dbfAlbPrvS ) )
      SET ADSINDEX TO ( cPatEmp() + "ALBPRVS.CDX" ) ADDITIVE

      USE ( cPatDat() + "EMPRESA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "EMPRESA", @dbfEmp ) )
      SET ADSINDEX TO ( cPatDat() + "EMPRESA.CDX" ) ADDITIVE

      USE ( cPatDat() + "TBLCNV.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TBLCNV", @dbfTblCnv ) )
      SET ADSINDEX TO ( cPatDat() + "TBLCNV.CDX" ) ADDITIVE

      USE ( cPatEmp() + "FACPRVT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACPRVT", @dbfFacPrvT ) )
      SET ADSINDEX TO ( cPatEmp() + "FACPRVT.CDX" ) ADDITIVE

      USE ( cPatEmp() + "FACPRVS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACPRVS", @dbfFacPrvS ) )
      SET ADSINDEX TO ( cPatEmp() + "FACPRVS.CDX" ) ADDITIVE

      USE ( cPatEmp() + "FACPRVL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACPRVL", @dbfFacPrvL ) )
      SET ADSINDEX TO ( cPatEmp() + "FACPRVL.CDX" ) ADDITIVE
      SET TAG TO "cRef"

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

      USE ( cPatEmp() + "PROSER.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PROSER", @dbfProSer ) )
      SET ADSINDEX TO ( cPatEmp() + "PROSER.CDX" ) ADDITIVE

      USE ( cPatEmp() + "MatSer.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "MatSer", @dbfMatSer ) )
      SET ADSINDEX TO ( cPatEmp() + "MatSer.Cdx" ) ADDITIVE

      USE ( cPatEmp() + "HISMOV.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "HISMOV", @dbfHisMov ) )
      SET ADSINDEX TO ( cPatEmp() + "HISMOV.CDX" ) ADDITIVE
      SET TAG TO "cRefMov"

      USE ( cPatEmp() + "MOVSER.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "MOVSER", @dbfHisMovS ) )
      SET ADSINDEX TO ( cPatEmp() + "MOVSER.CDX" ) ADDITIVE

      USE ( cPatEmp() + "PEDPROVL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PedPrvL", @dbfPedPrvL ) )
      SET ADSINDEX TO ( cPatEmp() + "PEDPROVL.CDX" ) ADDITIVE
      SET TAG TO "cRef"

      USE ( cPatPrv() + "PROVEE.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PROVEE", @dbfProvee ) )
      SET ADSINDEX TO ( cPatPrv() + "PROVEE.CDX" ) ADDITIVE

      oBandera          := TBandera():New()

      oStock            := TStock():Create( cPatEmp() )
      if !oStock:lOpenFiles()
         lOpenFiles     := .f.
      end if

      oCtaRem           := TCtaRem():Create( cPatCli() )
      if !oCtaRem:OpenFiles()
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

      oUndMedicion      := UniMedicion():Create( cPatEmp() )
      if !oUndMedicion:OpenFiles()
         lOpenFiles     := .f.
      end if

      oFraPub           := TFrasesPublicitarias():Create( cPatArt() )
      if !oFraPub:OpenFiles()
         lOpenFiles     := .f.
      end if

      oBanco            := TBancos():Create()
      if !oBanco:OpenFiles()
         lOpenFiles     := .f.
      end if

      oPais             := TPais():Create( cPatDat() )
      if !oPais:OpenFiles()
         lOpenFiles     := .f.
      end if

      oEntidades        := TEntidades():Create()
      if !oEntidades:OpenFiles()
         lOpenFiles     := .f.
      end if

      oCentroCoste        := TCentroCoste():Create( cPatDat() )
      if !oCentroCoste:OpenFiles()
         lOpenFiles     := .f.
      end if

      oClienteRutaNavigator      := ClienteRutaNavigator():New( nView )

      oMailingFacturasClientes   := TGenmailingDatabaseFacturasClientes():New( nView )

      TComercio                  := TComercio():New( nView, oStock )

      Counter                    := TCounter():New( nView, "nFacCli" )

      /*
      Declaramos variables p-blicas--------------------------------------------
      */

      public nTotFac    := 0
      public nTotBrt    := 0
      public nTotDto    := 0
      public nTotDPP    := 0
      public nTotNet    := 0
      public nTotSup    := 0
      public nTotIva    := 0
      public nTotIvm    := 0
      public nTotAge    := 0
      public nTotReq    := 0
      public nTotPnt    := 0
      public nTotUno    := 0
      public nTotDos    := 0
      public nTotRet    := 0
      public nTotTrn    := 0
      public nTotAnt    := 0
      public nTotCos    := 0
      public nTotCob    := 0
      public nTotPes    := 0
      public nTotRnt    := 0
      public nTotAtp    := 0
      public nTotArt    := 0
      public nTotCaj    := 0
      public nTotPctRnt := 0

      public aTotIva    := { { 0,0,nil,0,0,0,0,0,0,0,0 }, { 0,0,nil,0,0,0,0,0,0,0,0 }, { 0,0,nil,0,0,0,0,0,0,0,0 } }
      public aIvaUno    := aTotIva[ 1 ]
      public aIvaDos    := aTotIva[ 2 ]
      public aIvaTre    := aTotIva[ 3 ]

      public aTotIvm    := { { 0,0,0 }, { 0,0,0 }, { 0,0,0 }, }
      public aIvmUno    := aTotIvm[ 1 ]
      public aIvmDos    := aTotIvm[ 2 ]
      public aIvmTre    := aTotIvm[ 3 ]

      public aImpVto    := {}
      public aDatVto    := {}

      /*
      Campos extras------------------------------------------------------------------------
      */

      oDetCamposExtra                  := TDetCamposExtra():New()
      oDetCamposExtra:OpenFiles()
      oDetCamposExtra:setTipoDocumento( "Facturas a clientes" )
      oDetCamposExtra:setbId( {|| D():FacturasClientesId( nView ) } )

      oLinDetCamposExtra               := TDetCamposExtra():New()
      oLinDetCamposExtra:OpenFiles()
      oLinDetCamposExtra:setTipoDocumento( "Lineas de facturas a clientes" )
      oLinDetCamposExtra:setbId( {|| D():FacturasClientesLineasEscandalloId( nView ) } )

      lOpenFiles                       := .t.

      EnableAcceso()

   RECOVER USING oError

      lOpenFiles                       := .f.

      msgStop(  ErrorMessage( oError ), "Imposible abrir todas las bases de datos facturas de clientes.", )

      EnableAcceso()

   END SEQUENCE

   ErrorBlock( oBlock )

   if !lOpenFiles
      CloseFiles()
   end if

RETURN ( lOpenFiles )

//---------------------------------------------------------------------------//

STATIC FUNCTION CloseFiles()

   DisableAcceso()

   DestroyFastFilter( D():FacturasClientes( nView ), .t., .t. )

   if !empty( dbfIva )
      ( dbfIva     )->( dbCloseArea() )
   end if

   if !empty( dbfFacCliI )
      ( dbfFacCliI )->( dbCloseArea() )
   end if

   if !empty( dbfFacCliD )
      ( dbfFacCliD )->( dbCloseArea() )
   end if

   if !empty( dbfFacCliS )
      ( dbfFacCliS )->( dbCloseArea() )
   end if

   if !empty( dbfFacRecT )
      ( dbfFacRecT )->( dbCloseArea() )
   end if

   if !empty( dbfFacRecL )
      ( dbfFacRecL )->( dbCloseArea() )
   end if

   if !empty( dbfFacRecS )
      ( dbfFacRecS )->( dbCloseArea() )
   end if

   if !empty( dbfAlbCliT )
      ( dbfAlbCliT )->( dbCloseArea() )
   end if

   if !empty( dbfAlbCliL )
      ( dbfAlbCliL )->( dbCloseArea() )
   end if

   if !empty( dbfAlbCliP )
      ( dbfAlbCliP )->( dbCloseArea() )
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

   if ( !empty( dbfSatCliT ), ( dbfSatCliT )->( dbCloseArea() ), )
   if ( !empty( dbfSatCliL ), ( dbfSatCliL )->( dbCloseArea() ), )
   if ( !empty( dbfSatCliI ), ( dbfSatCliI )->( dbCloseArea() ), )
   if ( !empty( dbfSatCliD ), ( dbfSatCliD )->( dbCloseArea() ), )
   if ( !empty( dbfSatCliS ), ( dbfSatCliS )->( dbCloseArea() ), )
      
   if !empty( dbfPedCliT )
      ( dbfPedCliT )->( dbCloseArea() )
   end if

   if !empty( dbfPedCliL )
      ( dbfPedCliL )->( dbCloseArea() )
   end if

   if !empty( dbfPedCliP )
      ( dbfPedCliP )->( dbCloseArea() )
   end if

   if !empty( dbfPedCliI )
      ( dbfPedCliI )->( dbCloseArea() )
   end if

   if !empty( dbfPedCliD )
      ( dbfPedCliD )->( dbCloseArea() )
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

   if !empty( dbfTikT )
      ( dbfTikT )->( dbCloseArea() )
   end if

   if !empty( dbfTikL )
      ( dbfTikL )->( dbCloseArea() )
   end if

   if !empty( dbfTikS )
      ( dbfTikS )->( dbCloseArea() )
   end if

   if dbfCodebar != nil
      ( dbfCodebar )->( dbCloseArea() )
   end if

   if !empty( dbfFamilia )
      ( dbfFamilia )->( dbCloseArea() )
   end if

   if !empty( dbfKit )
      ( dbfKit     )->( dbCloseArea() )
   end if

   if !empty( dbfTarPreT )
      ( dbfTarPreT )->( dbCloseArea() )
   end if

   if !empty( dbfTarPreL )
      ( dbfTarPreL )->( dbCloseArea() )
   end if

   if !empty( dbfTarPreS )
      ( dbfTarPreS )->( dbCloseArea() )
   end if

   if !empty( dbfPromoT )
      ( dbfPromoT  )->( dbCloseArea() )
   end if

   if !empty( dbfPromoL )
      ( dbfPromoL  )->( dbCloseArea() )
   end if

   if !empty( dbfPromoC )
      ( dbfPromoC  )->( dbCloseArea() )
   end if

   if !empty( dbfAlm )
      ( dbfAlm    )->( dbCloseArea() )
   end if

   if !empty( dbfDiv )
      ( dbfDiv     )->( dbCloseArea() )
   end if

   if !empty( dbfObrasT )
      ( dbfObrasT  )->( dbCloseArea() )
   end if

   if !empty( dbfOferta )
      ( dbfOferta  )->( dbCloseArea() )
   end if

   if !empty( dbfRuta )
      ( dbfRuta    )->( dbCloseArea() )
   end if

   if !empty( dbfArtDiv )
      ( dbfArtDiv  )->( dbCloseArea() )
   end if

   if !empty( dbfCajT )
      ( dbfCajT    )->( dbCloseArea() )
   end if

   if !empty( dbfUsr )
      ( dbfUsr     )->( dbCloseArea() )
   end if

   if dbfArtPrv != nil
      ( dbfArtPrv )->( dbCloseArea() )
   end if

   if !empty( dbfDelega )
      ( dbfDelega )->( dbCloseArea() )
   end if

   if !empty( dbfAgeCom )
      ( dbfAgeCom )->( dbCloseArea() )
   end if

   if !empty( dbfAlbPrvL )
      ( dbfAlbPrvL )->( dbCloseArea() )
   end if

   if !empty( dbfAlbPrvS )
      ( dbfAlbPrvS )->( dbCloseArea() )
   end if

   if !empty( dbfPedCliR )
      ( dbfPedCliR )->( dbCloseArea() )
   end if

   if !empty( dbfEmp )
      ( dbfEmp )->( dbCloseArea() )
   end if

   if !empty( dbfTblCnv)
      ( dbfTblCnv )->( dbCloseArea() )
   end if

   if !empty( dbfFacPrvT )
      ( dbfFacPrvT )->( dbCloseArea() )
   end if

   if !empty( dbfFacPrvL )
      ( dbfFacPrvL )->( dbCloseArea() )
   end if

   if !empty( dbfFacPrvS )
      ( dbfFacPrvS )->( dbCloseArea() )
   end if

   if !empty( dbfRctPrvL )
      ( dbfRctPrvL )->( dbCloseArea() )
   end if

   if !empty( dbfRctPrvS )
      ( dbfRctPrvS )->( dbCloseArea() )
   end if

   if !empty( dbfProLin )
      ( dbfProLin )->( dbCloseArea() )
   end if

   if !empty( dbfProMat )
      ( dbfProMat )->( dbCloseArea() )
   end if

   if !empty( dbfProSer )
      ( dbfProSer )->( dbCloseArea() )
   end if

   if !empty( dbfMatSer )
      ( dbfMatSer )->( dbCloseArea() )
   end if

   if !empty( dbfHisMov )
      ( dbfHisMov )->( dbCloseArea() )
   end if

   if dbfHisMovS != nil
      ( dbfHisMovS )->( dbCloseArea() )
   end if

   if dbfCliBnc != nil
      ( dbfCliBnc )->( dbCloseArea() )
   end if

   if dbfPedPrvL != nil
      ( dbfPedPrvL )->( dbCloseArea() )
   end if

   if dbfProMat != nil
      ( dbfProMat )->( dbCloseArea() )
   end if

   if dbfProvee != nil
      ( dbfProvee )->( dbCloseArea() )
   end if

   TComercio:end()

   if !empty( oStock )
      oStock:end()
   end if

   if !empty( oCtaRem )
      oCtaRem:end()
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

   if !empty( oTrans )
      oTrans:End()
   end if

   if !empty( oUndMedicion )
      oUndMedicion:End()
   end if

   if !empty( oFraPub )
      oFraPub:end()
   end if

   if !empty( oBanco )
      oBanco:End()
   end if

   if !empty( oPais )
      oPais:End()
   end if

   if !empty( oEntidades )
      oEntidades:End()
   end if 

   if !empty( oCentroCoste )
      oCentroCoste:End()
   end if

   if !empty( oMailingFacturasClientes )
      oMailingFacturasClientes:End()
   end if 

   dbfIva      := nil
   dbfFacCliD  := nil
   dbfFacCliS  := nil
   dbfAlbCliT  := nil
   dbfAlbCliL  := nil
   dbfAlbCliI  := nil
   dbfAlbCliD  := nil
   dbfAlbCliS  := nil
   dbfPedCliT  := nil
   dbfPedCliL  := nil
   dbfPedCliP  := nil
   dbfPedCliI  := nil
   dbfPedCliD  := nil
   dbfPreCliT  := nil
   dbfPreCliL  := nil
   dbfPreCliI  := nil
   dbfPreCliD  := nil
   dbfSatCliT  := nil
   dbfSatCliL  := nil
   dbfSatCliI  := nil
   dbfSatCliD  := nil
   dbfSatCliS  := nil
   
   dbfTikT     := nil
   dbfCodebar  := nil
   dbfFamilia  := nil
   dbfKit      := nil
   dbfTarPreT  := nil
   dbfTarPreL  := nil
   dbfTarPreS  := nil
   dbfPromoT   := nil
   dbfPromoL   := nil
   dbfPromoC   := nil
   dbfAlm      := nil
   dbfDiv      := nil
   oBandera    := nil
   dbfObrasT   := nil
   dbfOferta   := nil
   dbfRuta     := nil
   dbfArtDiv   := nil
   dbfCajT     := nil
   dbfUsr      := nil
   dbfArtPrv   := nil
   dbfDelega   := nil
   dbfAgeCom   := nil
   dbfAlbPrvL  := nil
   dbfAlbPrvS  := nil
   dbfPedCliR  := nil
   dbfEmp      := nil
   dbfTblCnv   := nil
   dbfFacPrvT  := nil
   dbfFacPrvL  := nil
   dbfFacPrvS  := nil
   dbfRctPrvL  := nil
   dbfRctPrvS  := nil
   dbfProLin   := nil
   dbfProMat   := nil
   dbfHisMov   := nil
   dbfPedPrvL  := nil
   dbfProMat   := nil
   dbfProvee   := nil   

   oStock      := nil
   oNewImp     := nil
   oTrans      := nil
   oTipArt     := nil
   oGrpFam     := nil
   oUndMedicion:= nil
   oBanco      := nil
   oPais       := nil

   D():DeleteView( nView )

   lOpenFiles  := .f.

   EnableAcceso()

   if !empty( oDetCamposExtra )
      oDetCamposExtra:CloseFiles()
      oDetCamposExtra:End()
   end if

   if !empty( oLinDetCamposExtra )
      oLinDetCamposExtra:CloseFiles()
      oLinDetCamposExtra:End()
   end if

   SysRefresh()

Return ( !lOpenFiles )

//--------------------------------------------------------------------------//

STATIC FUNCTION EdtRec( aTmp, aGet, dbf, oBrw, hHash, bValid, nMode )

   local n
   local oDlg
   local oFld
   local oBrwLin
   local oBrwInc
   local oBrwDoc
   local oBrwAnt
   local oBrwEntidades
   local oBrwEst
   local oSay              := Array( 12 )
   local cSay              := Array( 12 )
   local oSayLabels        := Array(  5 )
   local oBmpDiv
   local oBmpEmp
   local nOrd
   local oBtn
   local cTlfCli
   local oGetMasDiv
   local cGetMasDiv        := ""
   local cGetPctRet
   local cSerie            := cNewSer( "nFacCli", D():Contadores( nView ) )
   local lWhen             := if( oUser():lAdministrador(), nMode != ZOOM_MODE, if( nMode == EDIT_MODE, !aTmp[ _LCLOFAC ], nMode != ZOOM_MODE ) )
   local oSayGetRnt
   local cTipFac
   local oSayDias
   local hBmp
   local hBmpGeneral       := {  { "Resource" => "gc_document_text_user2_48",  "Dialog" => 1 },;
                                 { "Resource" => "gc_folders2_48",            "Dialog" => 2 },;
                                 { "Resource" => "gc_information_48",      "Dialog" => 3 },;
                                 { "Resource" => "gc_address_book_48",    "Dialog" => 4 },;
                                 { "Resource" => "gc_form_earth_48",              "Dialog" => 5 },;
                                 { "Resource" => "gc_document_attachment_48",    "Dialog" => 6 },;
                                 { "Resource" => "gc_money2_48",            "Dialog" => 7 },;
                                 { "Resource" => "gc_document_text_money2_48", "Dialog" => 8 } }
   
   /*
   Este valor los guaradamos para detectar los posibles cambios----------------
   */

   cOldCodCli              := aTmp[ _CCODCLI ]

   setOldPorcentajeAgente( aTmp[ _NPCTCOMAGE ] )

   /*
   Operaciones segun el mode---------------------------------------------------
   */

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

      aTmp[ _CTURFAC    ]  := cCurSesion()
      aTmp[ _DFECENT    ]  := Ctod("")
      aTmp[ _CCODALM    ]  := oUser():cAlmacen()
      aTmp[ _CCODCAJ    ]  := oUser():cCaja()
      aTmp[ _CCODPAGO   ]  := cDefFpg()
      aTmp[ _CDIVFAC    ]  := cDivEmp()
      aTmp[ _NVDVFAC    ]  := nChgDiv( aTmp[ _CDIVFAC ], dbfDiv )
      aTmp[ _CSUFFAC    ]  := RetSufEmp()
      aTmp[ _LLIQUIDADA ]  := .f.
      aTmp[ _LSNDDOC    ]  := .t.
      aTmp[ _LMAIL      ]  := .t.
      aTmp[ _CCODPRO    ]  := cProCnt()
      aTmp[ _CCODUSR    ]  := cCurUsr()
      aTmp[ _DFECIMP    ]  := Ctod("")
      aTmp[ _CCODDLG    ]  := oUser():cDelegacion()
      aTmp[ _LIVAINC    ]  := uFieldEmpresa( "lIvaInc" )
      aTmp[ _CMANOBR    ]  := padr( getConfigTraslation( "Gastos" ), 250 )
      aTmp[ _NIVAMAN    ]  := nIva( dbfIva, cDefIva() )
      aTmp[ _LRECC      ]  := lRECCEmpresa()
      aTmp[ _TFECFAC    ]  := getSysTime()
      aTmp[ _LSNDDOC    ]  := .t.

   case nMode == DUPL_MODE

      if !lCurSesion()
         MsgStop( "No hay sesiones activas, imposible añadir documentos" )
         Return .f.
      end if

      if !lCajaOpen( oUser():cCaja() ) .and. !oUser():lAdministrador()
         msgStop( "Esta caja " + oUser():cCaja() + " esta cerrada" )
         Return .f.
      end if

      aTmp[ _DFECFAC    ]  := GetSysDate()
      aTmp[ _TFECFAC    ]  := getSysTime()
      aTmp[ _CTURFAC    ]  := cCurSesion()
      aTmp[ _CNUMALB    ]  := ""
      aTmp[ _CNUMPED    ]  := ""
      aTmp[ _CNUMPRE    ]  := ""
      aTmp[ _LCONTAB    ]  := .f.
      aTmp[ _LIMPALB    ]  := .f.
      aTmp[ _LCLOFAC    ]  := .f.
      aTmp[ _LSNDDOC    ]  := .t.
      aTmp[ _LMAIL      ]  := .t.
      aTmp[ _LRECC      ]  := lRECCEmpresa()
      aTmp[ _CCODUSR    ]  := cCurUsr()

   case nMode == EDIT_MODE

      if aTmp[ _LCONTAB ] .and.;
         !ApoloMsgNoYes(  "La modificación de esta factura puede provocar descuadres contables." + CRLF + "¿ Desea continuar ?", "Factura ya contabilizada" )
         return .f.
      end if

      aTmp[ _LSNDDOC    ]   := .t.

      lChangeRegIva( aTmp )

   end case

   /*
   Tipo de presupuesto---------------------------------------------------------
   */

   cTipFac                 := aTipFac[ if( hb_islogical( aTmp[ _LALQUILER ] ) .and. aTmp[ _LALQUILER ], 2, 1  ) ]

   /*
   Comineza la transaccion-----------------------------------------------------
   */

   if BeginTrans( aTmp, nMode )
      Return .f.
   end if

   /*
   Necestamos el orden el la primera clave-------------------------------------
   */

   nOrd                    := ( D():FacturasClientes( nView ) )->( ordSetFocus( 1 ) )

   /*
   Valores por defecto---------------------------------------------------------
   */

   if empty( Rtrim( aTmp[ _CSERIE ] ) )
      aTmp[ _CSERIE ]      := cSerie
   end if

   if empty( aTmp[ _NTARIFA ] )
      aTmp[ _NTARIFA ]     := Max( uFieldEmpresa( "nPreVta" ), 1 )
   end if

   if empty( aTmp[ _CDIVFAC ] )
      aTmp[ _CDIVFAC ]     := cDivEmp()
   end if

   if empty( aTmp[ _CDTOESP ] )
      aTmp[ _CDTOESP ]     := Padr( "General", 50 )
   end if

   if empty( aTmp[ _CDPP ] )
      aTmp[ _CDPP ]        := Padr( "Pronto pago", 50 )
   end if

   /*
   Mostramos datos de clientes-------------------------------------------------
   */

   nRiesgoCliente          := oStock:nRiesgo( aTmp[ _CCODCLI ] )

   if empty( aTmp[ _CTLFCLI ] )
      aTmp[ _CTLFCLI ]     := RetFld( aTmp[ _CCODCLI ], D():Clientes( nView ), "Telefono" )
   end if

   cPicUnd                 := MasUnd()                            // Picture de las unidades
   cPouDiv                 := cPouDiv( aTmp[ _CDIVFAC ], dbfDiv ) // Picture de la divisa
   cPorDiv                 := cPorDiv( aTmp[ _CDIVFAC ], dbfDiv ) // Picture de la divisa redondeada
   cPinDiv                 := cPinDiv( aTmp[ _CDIVFAC ], dbfDiv ) // Picture de la divisa
   nDouDiv                 := nDouDiv( aTmp[ _CDIVFAC ], dbfDiv ) // Decimales de la divisa
   nRouDiv                 := nRouDiv( aTmp[ _CDIVFAC ], dbfDiv ) // Decimales de la divisa redondeada
   cPpvDiv                 := cPpvDiv( aTmp[ _CDIVFAC ], dbfDiv ) // Picture del punto verde
   nDpvDiv                 := nDpvDiv( aTmp[ _CDIVFAC ], dbfDiv ) // Decimales de redondeo del punto verde

   /*
   Etiquetas-------------------------------------------------------------------
   */

   cSay[ 2 ]               := RetFld( aTmp[ _CCODALM ], dbfAlm )
   cSay[ 4 ]               := RetFld( aTmp[ _CCODPAGO], D():FormasPago( nView ) )
   cSay[ 8 ]               := RetFld( aTmp[ _CCODRUT ], dbfRuta )
   cSay[ 3 ]               := RetFld( aTmp[ _CCODAGE ], D():Agentes( nView ) )
   cSay[ 5 ]               := RetFld( aTmp[ _CCODTAR ], dbfTarPreT )
   cSay[ 7 ]               := RetFld( aTmp[ _CCODCLI ] + aTmp[ _CCODOBR ], dbfObrasT, "cNomObr" )
   cSay[ 9 ]               := oTrans:cNombre( aTmp[ _CCODTRN ] )
   cSay[ 10]               := RetFld( aTmp[ _CCODCAJ ], dbfCajT )
   cSay[ 11]               := RetFld( aTmp[ _CCODUSR ], dbfUsr, "cNbrUse" )
   cSay[ 12]               := RetFld( cCodEmp() + aTmp[ _CCODDLG ], dbfDelega, "cNomDlg" )

   /*
   Inicializamos el valor de la tarifa por si cambian--------------------------
   */

   InitTarifaCabecera( aTmp[ _NTARIFA ] )

   /*
   Apertura de la caja de dilogo-----------------------------------------------
   */

   DEFINE DIALOG oDlg RESOURCE "FACCLI" TITLE LblTitle( nMode ) + "facturas a clientes"

      /*
      Define de los Folders
      ------------------------------------------------------------------------
      */

      REDEFINE FOLDER oFld ;
         ID       400 ;
         OF       oDlg ;
         PROMPT   "&Factura",;
                  "Da&tos",;
                  "&Incidencias",;
                  "D&ocumentos",;
                  "&Entidades",;
                  "&Situaciones",;
                  "&Cobros",;
                  "&Anticipos";
         DIALOGS  "FACCLI_1",;
                  "FACCLI_2",;
                  "PEDCLI_3",;
                  "PEDCLI_4",;
                  "VIEW_FACTURAS_ENTIDADES",;
                  "PEDCLI_5",;
                  "FACTURAS_CLIENTES_RECIBOS",;
                  "FACTURAS_CLIENTES_ANTICIPOS"

      /*
      Datos del cliente--------------------------------------------------------
      */

      for each hBmp in hBmpGeneral
         TBitmap():ReDefine( 990, hBmp[ "Resource" ], , oFld:aDialogs[ hBmp[ "Dialog" ] ], , , .f., .f., , , .f., , , .t. )
      next 

      REDEFINE GET aGet[ _CCODCLI ] VAR aTmp[ _CCODCLI ] ;
         ID       170 ;
         WHEN     ( lWhen ) ;
         VALID    ( loaCli( aGet, aTmp, nMode ), RecalculaTotal( aTmp ) ); 
         BITMAP   "Lupa" ;
         ON HELP  ( BrwClient( aGet[ _CCODCLI ], aGet[ _CNOMCLI ] ), ::lValid() ) ;
         OF       fldGeneral

      REDEFINE GET aGet[ _CNOMCLI ] VAR aTmp[ _CNOMCLI ] ;
         ID       180 ;
         WHEN     ( lWhen .and. ( !aTmp[ _LMODCLI ] .or. oUser():lAdministrador() ) ) ;
         OF       fldGeneral

      if uFieldEmpresa( "nCifRut" ) == 1

      REDEFINE GET aGet[ _CDNICLI ] VAR aTmp[ _CDNICLI ] ;
         ID       181 ;
         WHEN     ( lWhen .and. ( !aTmp[ _LMODCLI ] .or. oUser():lAdministrador() ) ) ;
         VALID    ( CheckCif( aGet[ _CDNICLI ] ) );
         OF       fldGeneral

      else

      REDEFINE GET aGet[ _CDNICLI ] VAR aTmp[ _CDNICLI ] ;
         ID       181 ;
         PICTURE  "@R 999999999-9" ;
         WHEN     ( lWhen .and. ( !aTmp[ _LMODCLI ] .or. oUser():lAdministrador() ) ) ;
         VALID    ( CheckRut( aGet[ _CDNICLI ] ) );
         OF       fldGeneral

      end if

      REDEFINE GET aGet[ _CDIRCLI ] VAR aTmp[ _CDIRCLI ] ;
         ID       183 ;
         BITMAP   "gc_earth_lupa_16" ;
         ON HELP  GoogleMaps( aTmp[ _CDIRCLI ], Rtrim( aTmp[ _CPOBCLI ] ) + Space( 1 ) + Rtrim( aTmp[ _CPRVCLI ] ) ) ;
         WHEN     ( lWhen .and. ( !aTmp[ _LMODCLI ] .or. oUser():lAdministrador() ) ) ;
         OF       fldGeneral

      REDEFINE GET aGet[ _CPOSCLI ] VAR aTmp[ _CPOSCLI ] ;
         ID       184 ;
         WHEN     ( lWhen .and. ( !aTmp[ _LMODCLI ] .or. oUser():lAdministrador() ) ) ;
         OF       fldGeneral

      REDEFINE GET aGet[ _CPOBCLI ] VAR aTmp[ _CPOBCLI ] ;
         ID       185 ;
         WHEN     ( lWhen .and. ( !aTmp[ _LMODCLI ] .or. oUser():lAdministrador() ) ) ;
         OF       fldGeneral

      REDEFINE GET aGet[ _CPRVCLI ] VAR aTmp[ _CPRVCLI ] ;
         ID       186 ;
         WHEN     ( lWhen .and. ( !aTmp[ _LMODCLI ] .or. oUser():lAdministrador() ) ) ;
         OF       fldGeneral

      REDEFINE GET aGet[ _CTLFCLI ] VAR aTmp[ _CTLFCLI ] ;
         ID       187 ;
         COLOR    CLR_GET ;
         WHEN     ( lWhen .and. ( !aTmp[ _LMODCLI ] .or. oUser():lAdministrador() ) ) ;
         OF       fldGeneral

      REDEFINE GET oRiesgoCliente VAR nRiesgoCliente;
         ID       182 ;
         WHEN     ( nMode != ZOOM_MODE );
         PICTURE  cPorDiv ;
         OF       fldGeneral

      /*
      Tarifas______________________________________________________________
      */

      oGetTarifa  := comboTarifa():Build( { "idCombo" => 171, "uValue" => aTmp[ _NTARIFA ] } )
      oGetTarifa:Resource( fldGeneral )

      REDEFINE BTNBMP oBtnPrecio ;
         ID       174 ;
         OF       fldGeneral ;
         RESOURCE "gc_arrow_down_16" ;
         NOBORDER ;
         ACTION   ( ChangeTarifaCabecera( oGetTarifa:getTarifa(), dbfTmpLin, oBrwLin ) );
         WHEN     ( nMode != ZOOM_MODE .and. ( lUsrMaster() .or. oUser():lCambiarPrecio() ) )

      /*
      Codigo de Divisas______________________________________________________________
      */

      REDEFINE GET aGet[ _CDIVFAC ] VAR aTmp[ _CDIVFAC ];
         WHEN     ( nMode == APPD_MODE .AND. ( dbfTmpLin )->( LastRec() ) == 0 ) ;
         VALID    ( cDivOut( aGet[ _CDIVFAC ], oBmpDiv, aGet[ _NVDVFAC ], @cPouDiv, @nDouDiv, @cPorDiv, @nRouDiv, @cPpvDiv, @nDpvDiv, oGetMasDiv, dbfDiv, oBandera ) );
         PICTURE  "@!";
         ID       190 ;
         BITMAP   "LUPA" ;
         ON HELP  BrwDiv( aGet[ _CDIVFAC ], oBmpDiv, aGet[ _NVDVFAC ], dbfDiv, oBandera ) ;
         OF       fldGeneral

      REDEFINE BITMAP oBmpDiv ;
         RESOURCE ( cBmpDiv( aTmp[ _CDIVFAC ], dbfDiv ) );
         ID       191;
         OF       fldGeneral

      REDEFINE GET aGet[ _NVDVFAC ] VAR aTmp[ _NVDVFAC ];
         WHEN     ( .f. ) ;
         ID       192 ;
         PICTURE  "@E 999,999.9999" ;
         OF       fldGeneral

      // Segunda caja de dialogo-----------------------------------------------

      REDEFINE GET aGet[ _CCODUSR ] VAR aTmp[ _CCODUSR ];
         ID       125 ;
         WHEN     ( .f. ) ;
         VALID    ( SetUsuario( aGet[ _CCODUSR ], oSay[ 11 ], nil, dbfUsr ) );
         OF       fldData

      REDEFINE GET oSay[ 11 ] VAR cSay[ 11 ] ;
         ID       126 ;
         WHEN     ( .f. ) ;
         OF       fldData

      /*
      impuestos Incluido-------------------------------------------------------------
      */

      REDEFINE CHECKBOX aGet[ _LIVAINC ] ;
         VAR      aTmp[ _LIVAINC ] ;
         ID       200 ;
         WHEN     ( ( dbfTmpLin )->( ordKeyCount() ) == 0 .or. getConfigEmpresa( 'PermitirCambioFacturaIVAIncluido', .f. ) ) ;
         OF       fldGeneral

      /*
      Codigo de Tarifa_______________________________________________________________
      */

      REDEFINE GET aGet[ _CCODTAR ] VAR aTmp[ _CCODTAR ] ;
         ID       210 ;
         WHEN     ( lWhen .and. oUser():lAdministrador() ) ;
         VALID    ( cTarifa( aGet[ _CCODTAR ], oSay[ 5 ] ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwTarifa( aGet[ _CCODTAR ], oSay[ 5 ] ) ) ;
         OF       fldGeneral

      REDEFINE GET oSay[ 5 ] VAR cSay[ 5 ] ;
         WHEN     .F. ;
         ID       211 ;
         OF       fldGeneral

      /*
      Codigo de obra__________________________________________________________________
      */

      REDEFINE GET aGet[ _CCODOBR ] VAR aTmp[ _CCODOBR ] ;
         ID       220 ;
         WHEN     ( lWhen ) ;
         VALID    ( cObras( aGet[ _CCODOBR ], oSay[ 7 ], aTmp[ _CCODCLI ], dbfObrasT ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( brwObras( aGet[ _CCODOBR ], oSay[ 7 ], aTmp[ _CCODCLI ], dbfObrasT ) ) ;
         OF       fldGeneral

      REDEFINE GET oSay[ 7 ] VAR cSay[ 7 ] ;
         WHEN     .F. ;
         ID       221 ;
         OF       fldGeneral

      /*
      Codigo de almacen________________________________________________________________
      */

      REDEFINE GET aGet[ _CCODALM ] VAR aTmp[ _CCODALM ] ;
         ID       230 ;
         PICTURE  "@!" ;
         WHEN     ( lWhen ) ;
         VALID    ( cAlmacen( aGet[ _CCODALM ], , oSay[ 2 ] ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwAlmacen( aGet[ _CCODALM ], oSay[ 2 ] ) ) ;
         OF       fldGeneral

      REDEFINE GET oSay[ 2 ] VAR cSay[ 2 ] ;
         ID       231 ;
         WHEN     ( lWhen ) ;
         BITMAP   "Bot" ;
         ON HELP  ( ExpAlmacen( aTmp[ _CCODALM ], dbfTmpLin, oBrwLin ) ) ;
         OF       fldGeneral

      /*
      Formas de pago_____________________________________________________________________
      */

      REDEFINE GET aGet[ _CCODPAGO ] VAR aTmp[ _CCODPAGO ];
         ID       240 ;
         PICTURE  "@!" ;
         WHEN     ( lWhen .and. !lRecibosPagadosTmp( dbfTmpPgo ) );
         VALID    ( cFPago( aGet[ _CCODPAGO ], D():FormasPago( nView ), oSay[ 4 ] ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwFPago( aGet[ _CCODPAGO ], oSay[ 4 ] ) );
         OF       fldGeneral

      REDEFINE GET oSay[ 4 ] VAR cSay[ 4 ];
         ID       241 ;
         WHEN     .F. ;
         OF       fldGeneral

      /*
      Banco del cliente--------------------------------------------------------
      */

      REDEFINE GET aGet[ _CBANCO ] VAR aTmp[ _CBANCO ];
         ID       410 ;
         WHEN     ( lWhen .and. !lRecibosPagadosTmp( dbfTmpPgo ) );
         BITMAP   "LUPA" ;
         ON HELP  ( BrwBncCli( aGet[ _CBANCO ], aGet[ _CPAISIBAN ], aGet[ _CCTRLIBAN ], aGet[ _CENTBNC ], aGet[ _CSUCBNC ], aGet[ _CDIGBNC ], aGet[ _CCTABNC ], aTmp[ _CCODCLI ] ) );
         OF       fldGeneral

      REDEFINE GET aGet[ _CPAISIBAN ] VAR aTmp[ _CPAISIBAN ] ;
         PICTURE  "@!" ;
         ID       424 ;
         WHEN     ( lWhen .and. !lRecibosPagadosTmp( dbfTmpPgo ) );
         VALID    ( lIbanDigit( aTmp[ _CPAISIBAN ], aTmp[ _CENTBNC ], aTmp[ _CSUCBNC ], aTmp[ _CDIGBNC ], aTmp[ _CCTABNC ], aGet[ _CCTRLIBAN ] ) ) ;
         OF       fldGeneral

      REDEFINE GET aGet[ _CCTRLIBAN ] VAR aTmp[ _CCTRLIBAN ] ;
         ID       425 ;
         WHEN     ( lWhen .and. !lRecibosPagadosTmp( dbfTmpPgo ) );
         VALID    ( lIbanDigit( aTmp[ _CPAISIBAN ], aTmp[ _CENTBNC ], aTmp[ _CSUCBNC ], aTmp[ _CDIGBNC ], aTmp[ _CCTABNC ], aGet[ _CCTRLIBAN ] ) ) ;
         OF       fldGeneral

      REDEFINE GET aGet[ _CENTBNC ] VAR aTmp[ _CENTBNC ];
         ID       420 ;
         WHEN     ( lWhen .and. !lRecibosPagadosTmp( dbfTmpPgo ) );
         VALID    (  lCalcDC( aTmp[ _CENTBNC ], aTmp[ _CSUCBNC ], aTmp[ _CDIGBNC ], aTmp[ _CCTABNC ], aGet[ _CDIGBNC ] ),;
                     aGet[ _CPAISIBAN ]:lValid() ) ;
         OF       fldGeneral

      REDEFINE GET aGet[ _CSUCBNC ] VAR aTmp[ _CSUCBNC ];
         ID       421 ;
         WHEN     ( lWhen .and. !lRecibosPagadosTmp( dbfTmpPgo ) );
         VALID    (  lCalcDC( aTmp[ _CENTBNC ], aTmp[ _CSUCBNC ], aTmp[ _CDIGBNC ], aTmp[ _CCTABNC ], aGet[ _CDIGBNC ] ),;
                     aGet[ _CPAISIBAN ]:lValid() ) ;
         OF       fldGeneral

      REDEFINE GET aGet[ _CDIGBNC ] VAR aTmp[ _CDIGBNC ];
         ID       422 ;
         WHEN     ( lWhen .and. !lRecibosPagadosTmp( dbfTmpPgo ) );
         VALID    (  lCalcDC( aTmp[ _CENTBNC ], aTmp[ _CSUCBNC ], aTmp[ _CDIGBNC ], aTmp[ _CCTABNC ], aGet[ _CDIGBNC ] ),;
                     aGet[ _CPAISIBAN ]:lValid() ) ;
         OF       fldGeneral

      REDEFINE GET aGet[ _CCTABNC ] VAR aTmp[ _CCTABNC ];
         ID       423 ;
         WHEN     ( lWhen .and. !lRecibosPagadosTmp( dbfTmpPgo ) );
         PICTURE  "9999999999" ;
         VALID    (  lCalcDC( aTmp[ _CENTBNC ], aTmp[ _CSUCBNC ], aTmp[ _CDIGBNC ], aTmp[ _CCTABNC ], aGet[ _CDIGBNC ] ),;
                     aGet[ _CPAISIBAN ]:lValid() ) ;
         OF       fldGeneral

      /*
      Codigo de Agente___________________________________________________________________
      */

      REDEFINE GET aGet[ _CCODAGE ] VAR aTmp[ _CCODAGE ] ;
         ID       250 ;
         WHEN     ( lWhen ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( brwAgentes( aGet[ _CCODAGE ], oSay[ 3 ] ) );
         VALID    ( LoadAgente( aGet[ _CCODAGE ], D():Agentes( nView ), oSay[ 3 ], aGet[ _NPCTCOMAGE ], dbfAgeCom, dbfTmpLin, oBrwLin ), RecalculaTotal( aTmp ) ) ;
         OF       fldGeneral

      REDEFINE GET oSay[ 3 ] VAR cSay[ 3 ] ;
         ID       251 ;
         WHEN     ( !empty( aTmp[ _CCODAGE ] ) .AND. lWhen ) ;
         BITMAP   "Bot" ;
         ON HELP  ( changeAgentPercentageInAllLines( aTmp[ _NPCTCOMAGE ], dbfTmpLin, oBrwLin ), RecalculaTotal( aTmp ) ) ;
         OF       fldGeneral

      REDEFINE GET aGet[ _NPCTCOMAGE ] VAR aTmp[ _NPCTCOMAGE ] ;
         ID       252 ;
         WHEN     ( !empty( aTmp[ _CCODAGE ] ) .AND. lWhen ) ;
         VALID    ( validateAgentPercentage( aGet[ _NPCTCOMAGE ], dbfTmpLin, oBrwLin ), RecalculaTotal( aTmp ) );
         PICTURE  "@E 99.99" ;
         SPINNER;
         OF       fldGeneral

      REDEFINE GET oGetAge VAR nTotAge ;
         ID       253 ;
         WHEN     ( .f. );
         OF       fldGeneral

      /*
      Ruta____________________________________________________________________
      */

      REDEFINE GET aGet[ _CCODRUT ] VAR aTmp[ _CCODRUT ] ;
         ID       260 ;
         WHEN     ( lWhen ) ;
         VALID    ( cRuta( aGet[ _CCODRUT ], dbfRuta, oSay[ 8 ] ) );
         BITMAP   "LUPA" ;
         ON HELP  ( BrwRuta( aGet[ _CCODRUT ], dbfRuta, oSay[ 8 ] ) );
         OF       fldGeneral

      REDEFINE GET oSay[ 8 ] VAR cSay[ 8 ] ;
         ID       261 ;
         WHEN     .F. ;
         OF       fldGeneral

      /*
      Botones de acceso________________________________________________________
      */

      REDEFINE BUTTON ;
         ID       500 ;
         OF       fldGeneral ;
         WHEN     ( lWhen .and. !lRecibosPagadosTmp( dbfTmpPgo ) ) ;
         ACTION   ( AppDeta( oBrwLin, bEdtDet, aTmp, .f. ) )

      REDEFINE BUTTON ;
         ID       501 ;
         OF       fldGeneral ;
         WHEN     ( lWhen .AND. !lRecibosPagadosTmp( dbfTmpPgo ) ) ;
         ACTION   ( EdtDeta( oBrwLin, bEdtDet, aTmp, .f., nMode ) )

      REDEFINE BUTTON ;
         ID       502 ;
         OF       fldGeneral ;
         WHEN     ( lWhen .AND. !lRecibosPagadosTmp( dbfTmpPgo )  ) ;
         ACTION   ( WinDelRec( oBrwLin, dbfTmpLin, {|| DelDeta() }, {|| RecalculaTotal( aTmp ) } ) );

      REDEFINE BUTTON ;
         ID       503 ;
         OF       fldGeneral ;
         ACTION   ( WinZooRec( oBrwLin, bEdtDet, dbfTmpLin, .f., nMode, aTmp ) )

      REDEFINE BUTTON ;
         ID       515 ;
         OF       fldGeneral ;
         WHEN     ( lWhen .AND. !lRecibosPagadosTmp( dbfTmpPgo )  ) ;
         ACTION   ( AppDeta( oBrwLin, bEdtDet, aTmp, .t. ) )

      REDEFINE BUTTON ;
         ID       524 ;
         OF       fldGeneral ;
         WHEN     ( lWhen ) ;
         ACTION   ( LineUp( dbfTmpLin, oBrwLin ), RecalculaTotal( aTmp ) )

      REDEFINE BUTTON ;
         ID       525 ;
         OF       fldGeneral ;
         WHEN     ( lWhen ) ;
         ACTION   ( LineDown( dbfTmpLin, oBrwLin ), RecalculaTotal( aTmp ) )

      REDEFINE BUTTON oBtnKit;
         ID       526 ;
         OF       fldGeneral ;
         ACTION   ( lEscandalloEdtRec( .t., oBrwLin ) )

      REDEFINE BUTTON oBtnAtp;
         ID       527 ;
         OF       fldGeneral ;
         ACTION   ( CargaAtipicasCliente( aTmp, oBrwLin, oDlg ) )

	  REDEFINE BUTTON ;
         ID       528 ;
         OF       oFld:aDialogs[1] ;
         ACTION   ( importarArticulosScaner() )

      /*
      Detalle------------------------------------------------------------------
      */

      oBrwLin                 := IXBrowse():New( fldGeneral )
 
      oBrwLin:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwLin:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }
      oBrwLin:bClrStd         := {|| { if( ( dbfTmpLin )->lKitChl, CLR_GRAY, CLR_BLACK ), if( ( dbfTmpLin )->lControl, Rgb( 240, 240, 240 ), GetSysColor( COLOR_WINDOW )) } }

      oBrwLin:cAlias          := dbfTmpLin

      oBrwLin:nMarqueeStyle   := 6
      oBrwLin:lFooter         := .t.   
      oBrwLin:cName           := "Factura de cliente.Detalle"

      // oBrwLin:SetRdd()

      with object ( oBrwLin:AddCol() )
         :cHeader             := "Oferta"
         :bStrData            := {|| "" }
         :bEditValue          := {|| ( dbfTmpLin )->lLinOfe }
         :nWidth              := 60
         :lHide               := .t.   
         :SetCheck( { "gc_star2_16", "Nil16" } )
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader             := "Número"
         :bEditValue          := {|| ( dbfTmpLin )->nNumLin }
         :cSortOrder          := "nNumLin"
         :cEditPicture        := "9999"
         :nWidth              := 55
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
         :bEditValue          := {|| Descrip( dbfTmpLin ) }
         :nWidth              := 300
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader             := "última venta"
         :bEditValue          := {|| Dtoc( ( dbfTmpLin )->dFecUltCom ) }
         :nWidth              := 80
         :lHide               := .t.
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader             := "última unidades"
         :bEditValue          := {|| ( dbfTmpLin )->nUniUltCom }
         :cEditPicture        := MasUnd()
         :nWidth              := 60
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
         :lHide               := .t.
         :nFooterType         := AGGR_SUM
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
         :cHeader             := cNombreCajas()
         :bEditValue          := {|| ( dbfTmpLin )->nCanEnt }
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
         :nEditType          := 1
         :bOnPostEdit        := {|o,x,n| ChangeUnidades( o, x, n, aTmp, dbfTmpLin ) }
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
         :bEditValue          := {|| nTotNFacCli( dbfTmpLin ) }
         :cEditPicture        := cPicUnd
         :nWidth              := 80
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
         :nFooterType         := AGGR_SUM
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader             := "Unidad de medición"
         :bEditValue          := {|| ( dbfTmpLin )->cUnidad }
         :nWidth              := 105
         :lHide           := .t.
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader             := "Alm."
         :bEditValue          := {|| ( dbfTmpLin )->cAlmLin }
         :nWidth              := 34
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader             := "Precio"
         :bEditValue          := {|| nTotUFacCli( dbfTmpLin, nDouDiv ) }
         :cEditPicture        := cPouDiv
         :nWidth              := 60
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
         :nEditType          := 1
         :bOnPostEdit        := {|o,x,n| ChangePrecio( o, x, n, aTmp, dbfTmpLin ) }
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader             := "% Dto."
         :bEditValue          := {|| ( dbfTmpLin )->nDto }
         :cEditPicture        := "@E 999.99"
         :nWidth              := 55
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader             := "Dto. Lin."
         :bEditValue          := {|| nDtoUFacCli( dbfTmpLin, nDouDiv ) }
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
         :nWidth              := 45
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader             := "Portes"
         :bEditValue          := {|| nTrnUFacCli( dbfTmpLin, nDpvDiv ) }
         :cEditPicture        := cPouDiv
         :nWidth              := 70
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
         :lHide               := .t.
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader             := "Punto verde"
         :bEditValue          := {|| nPntUFacCli( dbfTmpLin, nDpvDiv ) }
         :cEditPicture        := cPpvDiv
         :nWidth              := 70
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
         :lHide               := .t.
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader             := "Imp. especiales"
         :bEditValue          := {|| nTotIFacCli( dbfTmpLin, nDouDiv, nRouDiv ) }
         :cEditPicture        := cPorDiv
         :nWidth              := 80
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
         :lHide               := .t.
      end with


      with object ( oBrwLin:AddCol() )
         :cHeader             := "Total"
         :bEditValue          := {|| nTotLFacCli( dbfTmpLin, nDouDiv, nRouDiv, nil, .t., aTmp[ _LOPERPV ], .t. ) }
         :cEditPicture        := cPorDiv
         :nWidth              := 94
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
         :nFooterType         := AGGR_SUM
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader             := "Fecha"
         :bEditValue          := {|| Dtoc( ( dbfTmpLin )->dFecha ) }
         :nWidth              := 80
         :lHide               := .t.
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader             := "Im. Imprimido"
         :bStrData            := {|| "" }
         :bEditValue          := {||( dbfTmpLin )->lImpLin }
         :nWidth              := 20
         :lHide               := .t.
         :SetCheck( { "gc_mail2_16", "Nil16" } )
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader          := "Centro de coste"
         :bEditValue       := {|| ( dbfTmpLin )->cCtrCoste }
         :nWidth           := 20
         :lHide            := .t.
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader             := "Dirección"
         :bEditValue          := {|| ( dbfTmpLin )->cCodObr + Space( 1 ) + RetFld( aTmp[ _CCODCLI ] + ( dbfTmpLin )->cCodObr, dbfObrasT, "cNomObr" ) }
         :nWidth              := 250
         :lHide               := .t.
      end with

      if nMode != ZOOM_MODE
         oBrwLin:bLDblClick   := {|| EdtDeta( oBrwLin, bEdtDet, aTmp, .f., nMode ) }
      end if

      oBrwLin:CreateFromResource( IDOK )
      
      /*
      Descuentos________________________________________________________________
      */

      REDEFINE GET aGet[ _CDTOESP ] VAR aTmp[ _CDTOESP ] ;
         ID       299 ;
         WHEN     ( lWhen .AND. !lRecibosPagadosTmp( dbfTmpPgo ) ) ;
         OF       fldGeneral

     REDEFINE GET aGet[_NDTOESP ] VAR aTmp[ _NDTOESP ] ;
         ID       300 ;
         PICTURE  "@ER 999.999999%" ;
         VALID    ( RecalculaTotal( aTmp ) );
         SPINNER;
         WHEN     ( lWhen .AND. !lRecibosPagadosTmp( dbfTmpPgo ) ) ;
         OF       fldGeneral

      REDEFINE GET aGet[ _CDPP ] VAR aTmp[ _CDPP ] ;
         ID       309 ;
         WHEN     ( lWhen .AND. !lRecibosPagadosTmp( dbfTmpPgo ) ) ;
         OF       fldGeneral

      REDEFINE GET aGet[ _NDPP ] VAR aTmp[ _NDPP ];
         ID       310 ;
         PICTURE  "@ER 999.999999%" ;
         VALID    ( RecalculaTotal( aTmp ) );
         SPINNER;
         WHEN     ( lWhen .AND. !lRecibosPagadosTmp( dbfTmpPgo ) ) ;
         OF       fldGeneral

     /*
     Descuentos definidos por el usuario_______________________________________
     */

      REDEFINE GET aGet[ _CDTOUNO ] VAR aTmp[ _CDTOUNO ] ;
         ID       320 ;
         WHEN     ( lWhen .AND. !lRecibosPagadosTmp( dbfTmpPgo ) ) ;
         OF       fldGeneral

      REDEFINE GET aGet[ _NDTOUNO ] VAR aTmp[ _NDTOUNO ];
         ID       330 ;
         PICTURE  "@ER 999.999999%" ;
         VALID    ( RecalculaTotal( aTmp ) ) ;
         SPINNER;
         WHEN     ( lWhen .AND. !lRecibosPagadosTmp( dbfTmpPgo ) ) ;
         OF       fldGeneral

      REDEFINE GET aGet[ _CDTODOS ] VAR aTmp[ _CDTODOS ] ;
         ID       340 ;
         WHEN     ( lWhen .AND. !lRecibosPagadosTmp( dbfTmpPgo ) ) ;
         OF       fldGeneral

      REDEFINE GET aGet[ _NDTODOS ] VAR aTmp[ _NDTODOS ];
         ID       350 ;
         PICTURE  "@ER 999.999999%" ;
         VALID    ( RecalculaTotal( aTmp ) ) ;
         SPINNER;
         WHEN     ( lWhen .AND. !lRecibosPagadosTmp( dbfTmpPgo ) ) ;
         OF       fldGeneral

      /*
      Descuento de vodafone----------------------------------------------------
      */

      REDEFINE CHECKBOX aGet[ _LPAYCLI ] VAR aTmp[ _LPAYCLI ] ;
         ID       361 ;
         OF       fldGeneral

      REDEFINE GET aGet[ _NPAYCLI ] VAR aTmp[ _NPAYCLI ];
         ID       360 ;
         PICTURE  cPorDiv ;
         WHEN     aTmp[ _LPAYCLI ] ;
         OF       fldGeneral

      REDEFINE GET aGet[ _CMANOBR ] VAR aTmp[ _CMANOBR ] ;
         ID       411 ;
         WHEN     ( lWhen .AND. !lRecibosPagadosTmp( dbfTmpPgo ) ) ;
         OF       fldGeneral

      REDEFINE GET aGet[ _NMANOBR ] VAR aTmp[ _NMANOBR ] ;
         ID       400 ;
         PICTURE  cPorDiv ;
         WHEN     ( lWhen .and. !lRecibosPagadosTmp( dbfTmpPgo ) ) ;
         VALID    ( RecalculaTotal( aTmp ) );
         ON CHANGE( RecalculaTotal( aTmp ) );
         OF       fldGeneral

      REDEFINE GET aGet[ _NIVAMAN ] VAR aTmp[ _NIVAMAN ] ;
         ID       412 ;
         WHEN     ( lWhen .and. !lRecibosPagadosTmp( dbfTmpPgo ) ) ;
         PICTURE  "@E 99.99" ;
         VALID    ( lTiva( dbfIva, aTmp[ _NIVAMAN ] ) .and. RecalculaTotal( aTmp ) );
         ON CHANGE( RecalculaTotal( aTmp ) );
         BITMAP   "LUPA" ;
         ON HELP  ( BrwIva( aGet[ _NIVAMAN ], dbfIva, , .t. ) );
         OF       fldGeneral

      /*
      Cajas Bases de los impuestos____________________________________________________________
      */

      oBrwIva                        := IXBrowse():New( fldGeneral )

      oBrwIva:bClrSel                := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwIva:bClrSelFocus           := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrwIva:SetArray( aTotIva, , , .f. )

      oBrwIva:nMarqueeStyle          := 6
      oBrwIva:lRecordSelector        := .f.
      oBrwIva:lHScroll               := .f.

      oBrwIva:CreateFromResource( 370 )

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
         :bOnPostEdit      := {|o,x| EdtIva( o, x, aTotIva[ oBrwIva:nArrayAt, 3 ], dbfTmpLin, dbfIva, oBrwLin ), RecalculaTotal( aTmp ) }
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
         :bStrData         := {|| if( aTotIva[ oBrwIva:nArrayAt, 3 ] != nil .and. aTmp[ _LRECARGO ],  Trans( aTotIva[ oBrwIva:nArrayAt, 4 ], "@E 999.99"), "" ) }
         :nWidth           := 44
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      with object ( oBrwIva:AddCol() )
         :cHeader          := "R.E."
         :bStrData         := {|| if( aTotIva[ oBrwIva:nArrayAt, 3 ] != nil .and. aTmp[ _LRECARGO ],  Trans( aTotIva[ oBrwIva:nArrayAt, 9 ], cPorDiv ), "" ) }
         :nWidth           := 76
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      /*
      Totales de facturas
      ------------------------------------------------------------------------
      */

      REDEFINE SAY oGetNet VAR nTotNet ;
         ID       401 ;
         OF       fldGeneral

      REDEFINE SAY oGetIva VAR nTotIva ;
         ID       405 ;
         OF       fldGeneral

      REDEFINE CHECKBOX aGet[ _LRECARGO ] ;
         VAR      aTmp[ _LRECARGO ] ;
         ID       406 ;
         WHEN     ( lWhen .and. !lRecibosPagadosTmp( dbfTmpPgo ) ) ;
         ON CHANGE( RecalculaTotal( aTmp ) );
         OF       fldGeneral

      REDEFINE CHECKBOX oImpuestos ;
         VAR      lImpuestos ;
         ID       709 ;
         WHEN     ( .f. ) ;
         OF       fldGeneral

      REDEFINE SAY oGetReq VAR nTotReq ;
         ID       407 ;
         OF       fldGeneral

      REDEFINE SAY oGetTotal VAR nTotal ;
         ID       485 ;
         FONT     oFontTotal() ;
         OF       fldGeneral

      REDEFINE CHECKBOX aGet[ _LOPERPV ] ;
         VAR      aTmp[ _LOPERPV ] ;
         ID       409 ;
         WHEN     ( lWhen .AND. !lRecibosPagadosTmp( dbfTmpPgo ) ) ;
         ON CHANGE( RecalculaTotal( aTmp ), oBrwLin:Refresh() );
         OF       fldGeneral

      REDEFINE SAY oGetTotPnt VAR nTotPnt;
         ID       404 ;
         OF       fldGeneral

      REDEFINE SAY oGetTrn VAR nTotTrn;
         ID       402 ;
         OF       fldGeneral

      REDEFINE SAY oGetTotIvm VAR nTotIvm;
         ID       403 ;
         OF       fldGeneral

      REDEFINE SAY oSayGetRnt ;
         ID       800 ;
         OF       fldGeneral

      REDEFINE GET oGetRnt VAR cGetRnt ;
         ID       408 ;
         OF       fldGeneral

      REDEFINE SAY oGetMasDiv VAR cGetMasDiv;
         ID       488 ;
         FONT     oFontTotal() ;
         OF       fldGeneral

      REDEFINE COMBOBOX aGet[ _NTIPRET ] VAR aTmp[ _NTIPRET ] ;
         ITEMS    { "Ret. S/Base", "Ret. S/Total" };
         ID       440 ;
         WHEN     ( lWhen ) ;
         ON CHANGE( RecalculaTotal( aTmp ) );
         VALID    ( RecalculaTotal( aTmp ) );
         OF       fldGeneral

     REDEFINE GET aGet[ _NPCTRET ] VAR aTmp[ _NPCTRET ] ;
         ID       490 ;
         PICTURE  "@E 999.99" ;
         ON CHANGE( RecalculaTotal( aTmp ) );
         SPINNER;
         WHEN     ( lWhen ) ;
         OF       fldGeneral

      REDEFINE SAY oGetPctRet VAR cGetPctRet;
         ID       491 ;
         OF       fldGeneral

      REDEFINE GET aGet[ _CSERIE ] VAR aTmp[ _CSERIE ] ;
         ID       100 ;
         PICTURE  "@!" ;
         SPINNER ;
         ON UP    ( UpSerie( aGet[ _CSERIE ] ) );
         ON DOWN  ( DwSerie( aGet[ _CSERIE ] ) ); 
         WHEN     ( nMode == APPD_MODE .OR. nMode == DUPL_MODE );
         VALID    ( aTmp[ _CSERIE ] >= "A" .AND. aTmp[ _CSERIE ] <= "Z" ) ;
         OF       fldGeneral

         aGet[ _CSERIE ]:bLostFocus := {|| aGet[ _CCODPRO ]:cText( cProCnt( aTmp[ _CSERIE ] ) ) }

      REDEFINE GET aGet[ _NNUMFAC ] VAR aTmp[ _NNUMFAC ] ;
         ID       110 ;
         PICTURE  "999999999" ;
         WHEN     .f. ;
         OF       fldGeneral

      REDEFINE GET aGet[ _CSUFFAC ] VAR aTmp[ _CSUFFAC ] ;
         ID       120 ;
         PICTURE  "@!" ;
         WHEN     .f. ;
         OF       fldGeneral

      REDEFINE COMBOBOX oTipFac VAR cTipFac ;
         ID       217 ;
         WHEN     ( ( dbfTmpLin )->( LastRec() ) == 0 ) ;
         ITEMS    aTipFac ;
         ON CHANGE( SetDialog( aGet, oSayDias, oSayGetRnt, oGetRnt ) );
         OF       fldGeneral

      REDEFINE GET aGet[ _DFECFAC ] VAR aTmp[ _DFECFAC ] ;
         ID       130 ;
         SPINNER ;
         ON HELP  aGet[ _DFECFAC ]:cText( Calendario( aTmp[ _DFECFAC ] ) ) ;
         WHEN     ( lWhen ) ;
         OF       fldGeneral

      REDEFINE GET aGet[ _TFECFAC ] VAR aTmp[ _TFECFAC ] ;
         ID       131 ;
         PICTURE  "@R 99:99:99" ;
         WHEN     ( lWhen ) ;
         VALID    ( iif(   !validTime( aTmp[ _TFECFAC ] ),;
                           ( msgStop( "El formato de la hora no es correcto" ), .f. ),;
                           .t. ) );
         OF       fldGeneral


      /*
      Criterio de caja_________________________________________________________
      */

      REDEFINE CHECKBOX aGet[ _LRECC ] VAR aTmp[ _LRECC ] ;
         ID       195 ;
         WHEN     ( uFieldEmpresa( "lRECC" ) .and. nMode != ZOOM_MODE ) ;
         OF       fldGeneral

      REDEFINE GET aGet[ _DFECSAL ] VAR aTmp[ _DFECSAL ];
         ID       111 ;
         IDSAY    112 ;
         SPINNER;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ON CHANGE( oSayDias:Refresh() );
         OF       fldGeneral

      REDEFINE GET aGet[ _DFECENTR ] VAR aTmp[ _DFECENTR ];
         ID       113 ;
         IDSAY    114 ;
         SPINNER;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ON CHANGE( oSayDias:Refresh() );
         OF       fldGeneral

      REDEFINE SAY oSayDias ;
         VAR      ( aTmp[ _DFECENTR ] - aTmp[ _DFECSAL ] );
         ID       115 ;
         PICTURE  "9999" ;
         OF       fldGeneral

      REDEFINE BTNBMP oBtnPre ;
         ID       601 ;
         OF       fldGeneral ;
         WHEN     ( lWhen .and. ( dbfTmpLin )->( ordKeyCount() ) == 0 ) ;
         RESOURCE "gc_notebook_user_16" ;
         NOBORDER ;
         TOOLTIP  "Importar presupuesto" ;
         ACTION   ( BrwPreCli( aGet[ _CNUMPRE ], dbfPreCliT, dbfPreCliL, dbfIva, dbfDiv, D():FormasPago( nView ), aGet[ _LIVAINC ] ) )

      REDEFINE BTNBMP oBtnPed ;
         ID       602 ;
         OF       fldGeneral ;
         WHEN     ( lWhen .and. ( dbfTmpLin )->( ordKeyCount() ) == 0 ) ;
         RESOURCE "gc_clipboard_empty_user_16" ;
         NOBORDER ;
         TOOLTIP  "Importar pedido" ;
         ACTION   ( BrwPedCli( aGet[ _CNUMPED ], dbfPedCliT, dbfPedCliL, dbfIva, dbfDiv, D():FormasPago( nView ), aGet[ _LIVAINC ] ) )

      REDEFINE BTNBMP oBtnAlb ;
         ID       603 ;
         OF       fldGeneral ;
         WHEN     ( lWhen .and. ( dbfTmpLin )->( ordKeyCount() ) == 0 ) ;
         RESOURCE "gc_document_empty_16" ;
         NOBORDER ;
         TOOLTIP  "Importar albaran" ;
         ACTION   ( BrwAlbCli( aGet[ _CNUMALB ], aGet[ _LIVAINC ] ) )

      REDEFINE BTNBMP oBtnSat ;
         ID       604 ;
         OF       fldGeneral ;
         WHEN     ( lWhen .and. ( dbfTmpLin )->( ordKeyCount() ) == 0 ) ;
         RESOURCE "gc_power_drill_sat_user_16" ;
         NOBORDER ;
         TOOLTIP  "Importar S.A.T." ;
         ACTION   ( BrwSatCli( aGet[ _CNUMSAT ], dbfSatCliT, dbfSatCliL, dbfIva, dbfDiv, D():FormasPago( nView ), aGet[ _LIVAINC ] ) )

      REDEFINE BUTTON oBtnGrp ;
         ID       512 ;
         OF       fldGeneral ;
         WHEN     ( lWhen .and. ( dbfTmpLin )->( ordKeyCount() ) == 0 ) ;
         ACTION   ( GrpAlb( aGet, aTmp, oBrwLin ) )

      REDEFINE GET aGet[ _CNUMALB ] VAR aTmp[ _CNUMALB ] ;
         ID       150 ;
         WHEN     ( .f. ) ;
         VALID    ( cAlbCli( aGet, aTmp, oBrwLin, oBrwPgo, nMode ), SetDialog( aGet, oSayDias, oSayGetRnt, oGetRnt ), RecalculaTotal( aTmp ) ) ;
         PICTURE  "@R #/#########/##" ;
         OF       fldGeneral

      REDEFINE GET aGet[ _CNUMPED ] VAR aTmp[ _CNUMPED ] ;
         ID       151 ;
         WHEN     ( .f. ) ;
         VALID    ( cPedCli( aGet, aTmp, oBrwLin, oBrwPgo, nMode ), SetDialog( aGet, oSayDias, oSayGetRnt, oGetRnt ), RecalculaTotal( aTmp ) );
         PICTURE  "@R #/#########/##" ;
         OF       fldGeneral

      REDEFINE GET aGet[ _CNUMPRE ] VAR aTmp[ _CNUMPRE ] ;
         ID       152 ;
         WHEN     ( .f. ) ;
         VALID    ( cPreCli( aGet, aTmp, oBrwLin, nMode ), SetDialog( aGet, oSayDias, oSayGetRnt, oGetRnt ), RecalculaTotal( aTmp ) ) ;
         PICTURE  "@R #/#########/##" ;
         OF       fldGeneral

      REDEFINE GET aGet[ _CNUMSAT ] VAR aTmp[ _CNUMSAT ] ;
         ID       153 ;
         WHEN     ( .f. ) ;
         VALID    ( cSatCli( aGet, aTmp, oBrwLin, nMode ), SetDialog( aGet, oSayDias, oSayGetRnt, oGetRnt ), RecalculaTotal( aTmp ) ) ;
         PICTURE  "@R #/#########/##" ;
         OF       fldGeneral

     /*
      Segunda caja de di-logo--------------------------------------------------
      */

      REDEFINE GET aGet[ _CCODDLG ] VAR aTmp[ _CCODDLG ] ;
         ID       300 ;
         WHEN     ( .f. ) ;
         OF       fldData

      REDEFINE GET oSay[ 12 ] VAR cSay[ 12 ] ;
         ID       301 ;
         WHEN     ( .f. ) ;
         OF       fldData

      /*
      Transportistas-----------------------------------------------------------
      */

      REDEFINE GET aGet[ _CCODTRN ] VAR aTmp[ _CCODTRN ] ;
         ID       235 ;
         WHEN     ( lWhen ) ;
         VALID    ( LoadTrans( aTmp, aGet[ _CCODTRN ], aGet[ _NKGSTRN ], oSay[ 9 ] ) );
         BITMAP   "LUPA" ;
         ON HELP  ( oTrans:Buscar( aGet[ _CCODTRN ] ), .t. );
         OF       fldData

      REDEFINE GET oSay[ 9 ] VAR cSay[ 9 ] ;
         ID       236 ;
         WHEN     .F. ;
         OF       fldData

      REDEFINE GET aGet[ _NKGSTRN ] VAR aTmp[ _NKGSTRN ] ;
         ID       237 ;
         WHEN     ( .f. ) ;
         PICTURE  ( MasUnd() ) ;
         OF       fldData

      /*
      Cajas____________________________________________________________________
      */

      REDEFINE GET aGet[ _CCODCAJ ] VAR aTmp[ _CCODCAJ ];
         WHEN     ( lWhen ) ;
         VALID    cCajas( aGet[ _CCODCAJ ], dbfCajT, oSay[ 10 ] ) ;
         ID       165 ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwCajas( aGet[ _CCODCAJ ], oSay[ 10 ] ) ) ;
         OF       fldData

      REDEFINE GET oSay[ 10 ] VAR cSay[ 10 ] ;
         ID       166 ;
         WHEN     .f. ;
         OF       fldData

      REDEFINE GET aGet[_CCODPRO] VAR aTmp[_CCODPRO] ;
         ID       170 ;
         PICTURE  "@R ###.######" ;
         WHEN     ( nLenCuentaContaplus() != 0 .AND. lWhen ) ;
         VALID    ( ChkProyecto( aTmp[_CCODPRO], oSay[ 6 ] ), .t. );
         BITMAP   "LUPA" ;
         ON HELP  ( BrwProyecto( aGet[_CCODPRO], oSay[ 6 ] ) );
         OF       fldData

      REDEFINE GET oSay[ 6 ] VAR cSay[ 6 ] ;
         ID       180 ;
         WHEN     .F.;
         OF       fldData

        REDEFINE GET aGet[ _CCENTROCOSTE ] VAR aTmp[ _CCENTROCOSTE ] ;
            ID       350 ;
            IDTEXT   351 ;
            BITMAP   "LUPA" ;
            VALID    ( oCentroCoste:Existe( aGet[ _CCENTROCOSTE ], aGet[ _CCENTROCOSTE ]:oHelpText, "cNombre" ) );
            ON HELP  ( oCentroCoste:Buscar( aGet[ _CCENTROCOSTE ] ) ) ;
            WHEN     ( nMode != ZOOM_MODE ) ;
            OF       fldData

      REDEFINE GET aGet[_NBULTOS] VAR aTmp[_NBULTOS];
         ID       128 ;
         SPINNER;
         PICTURE  "99999" ;
         WHEN     ( lWhen ) ;
         OF       fldData

      REDEFINE GET aGet[ _CSUFAC ] VAR aTmp[ _CSUFAC ] ;
         ID       181 ;
         WHEN     ( lWhen ) ;
         PICTURE  "@!" ;
         OF       fldData

      REDEFINE GET aGet[ _DFECCRE ] VAR aTmp[ _DFECCRE ] ;
         ID       400 ;
         WHEN     ( .f. ) ;
         OF       fldData

      REDEFINE GET aGet[ _CTIMCRE ] VAR aTmp[ _CTIMCRE ] ;
         ID       401 ;
         WHEN     ( .f. ) ;
         OF       fldData

      /*
      Retirado por________________________________________________________________
      */

      REDEFINE GET aGet[ _DFECENT ] VAR aTmp[ _DFECENT ];
         ID       162 ;
         SPINNER;
         WHEN     ( lWhen ) ;
         ON HELP  aGet[_DFECENT]:cText( Calendario( aTmp[_DFECENT] ) ) ;
         OF       fldData

      REDEFINE GET aGet[ _CSUALB ] VAR aTmp[ _CSUALB ];
         ID       163 ;
         WHEN     ( lWhen ) ;
         OF       fldData

      REDEFINE GET aGet[_CRETPOR] VAR aTmp[_CRETPOR] ;
         ID       160 ;
         WHEN     ( lWhen ) ;
         OF       fldData

      REDEFINE GET aGet[_CRETMAT] VAR aTmp[_CRETMAT] ;
         ID       161 ;
         WHEN     ( lWhen ) ;
         OF       fldData

      REDEFINE GET aGet[_CCONDENT] VAR aTmp[_CCONDENT] ;
         ID       230 ;
         WHEN     ( lWhen ) ;
         OF       fldData

      /*impresión ( informa de si está imprimido o no y de cuando se imprimi- )*/

      REDEFINE CHECKBOX aGet[ _LIMPRIMIDO ] VAR aTmp[ _LIMPRIMIDO ] ;
         ID       120 ;
         WHEN     ( lWhen .and. lUsrMaster() ) ;
         OF       fldData

      REDEFINE GET aGet[ _DFECIMP ] VAR aTmp[ _DFECIMP ] ;
         ID       121 ;
         WHEN     ( lWhen .and. lUsrMaster() ) ;
         OF       fldData

      REDEFINE GET aGet[ _CHORIMP ] VAR aTmp[ _CHORIMP ] ;
         ID       122 ;
         WHEN     ( lWhen .and. lUsrMaster() ) ;
         OF       fldData

      /*
      impuestos----------------------------------------------------------------------
      */

      REDEFINE RADIO aGet[ _NREGIVA ] ;
         VAR      aTmp[ _NREGIVA ] ;
         ID       410,;
                  411,;
                  412,;
                  413 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ON CHANGE( lChangeRegIva( aTmp ) );
         OF       fldData

      /*Exportacion a EDI ( informa de si está exportado o no y de cuando se export- )*/

      REDEFINE CHECKBOX aGet[ _LEXPEDI ] VAR aTmp[ _LEXPEDI ] ;
         ID       130 ;
         WHEN     ( lWhen .and. lUsrMaster() ) ;
         ON CHANGE( lChangeEDI( aGet, aTmp ) ) ;
         OF       fldData

      REDEFINE GET aGet[ _DFECEDI ] VAR aTmp[ _DFECEDI ] ;
         ID       131 ;
         WHEN     ( lWhen .and. lUsrMaster() ) ;
         OF       fldData

      // Envio por mail

      REDEFINE CHECKBOX aGet[ _LMAIL ] VAR aTmp[ _LMAIL ] ;
         ID       135 ;
         WHEN     ( lWhen .and. lUsrMaster() ) ;
         ON CHANGE( iif(   aTmp[ _LMAIL ],;
                           ( aGet[ _DMAIL ]:Hide(), aGet[ _TMAIL ]:Hide() ),;
                           ( aGet[ _DMAIL ]:Show(), aGet[ _TMAIL ]:Show() ) ) );
         OF       fldData

      REDEFINE GET aGet[ _DMAIL ] VAR aTmp[ _DMAIL ] ;
         ID       136 ;
         WHEN     ( .f. ) ;
         OF       fldData

      REDEFINE GET aGet[ _TMAIL ] VAR aTmp[ _TMAIL ] ;
         ID       137 ;
         PICTURE  "@R 99:99:99" ;
         WHEN     ( .f. ) ;
         OF       fldData

      REDEFINE GET aGet[ _CHOREDI ] VAR aTmp[ _CHOREDI ] ;
         ID       132 ;
         WHEN     ( lWhen .and. lUsrMaster() ) ;
         OF       fldData

      REDEFINE GET aGet[ _MOBSERV ] VAR aTmp[ _MOBSERV ];
         MEMO ;
         ID       240 ;
         WHEN     ( lWhen ) ;
         OF       fldData

      REDEFINE GET aGet[ _MCOMENT ] VAR aTmp[ _MCOMENT ];
         MEMO ;
         ID       250 ;
         WHEN     ( lWhen ) ;
         OF       fldData

      /*
      Pagos
      -------------------------------------------------------------------------
      */

      oBrwPgo                 := IXBrowse():New( fldRecibos )

      oBrwPgo:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwPgo:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrwPgo:cAlias          := dbfTmpPgo
      oBrwPgo:cName           := "Factura de cliente.Pagos"

      oBrwPgo:nMarqueeStyle   := 6

      oBrwPgo:lFooter         := .t.
      oBrwPgo:nFooterHeight   := 35
      oBrwPgo:nFooterLines    := 2

      oBrwPgo:CreateFromResource( 200 )

      with object ( oBrwPgo:AddCol() )
         :cHeader             := "Cr. Sesión cerrada"
         :bStrData            := {|| "" }
         :bEditValue          := {|| ( dbfTmpPgo )->lCloPgo }
         :nWidth              := 20
         :lHide               := .t.
         :SetCheck( { "Sel16", "Nil16" } )
      end with

      with object ( oBrwPgo:AddCol() )
         :cHeader             := "Estado"
         :bStrData            := {|| cEstadoRecibo( dbfTmpPgo ) }
         :bBmpData            := {|| nEstadoRecibo( dbfTmpPgo ) }
         :nWidth              := 90
         :AddResource( "Cnt16" )
         :AddResource( "Sel16" )
         :AddResource( "gc_undo_16" )
      end with

      with object ( oBrwPgo:AddCol() )
         :cHeader             := "Cn. Contabilizado"
         :bStrData            := {|| "" }
         :bEditValue          := {|| ( dbfTmpPgo )->lConPgo }
         :nWidth              := 20
         :lHide               := .t.
         :SetCheck( { "Cnt16", "Nil16" } )
      end with

      with object ( oBrwPgo:AddCol() )
         :cHeader             := "Sesión"
         :bEditValue          := {|| ( dbfTmpPgo )->cTurRec }
         :nWidth              := 50
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
      end with

      with object ( oBrwPgo:AddCol() )
         :cHeader             := "Expedido"
         :bEditValue          := {|| DtoC( ( dbfTmpPgo )->dPreCob ) }
         :nWidth              := 82
      end with

      with object ( oBrwPgo:AddCol() )
         :cHeader             := "Vencimiento"
         :bEditValue          := {|| DtoC( ( dbfTmpPgo )->dFecVto ) }
         :nWidth              := 82
      end with

      with object ( oBrwPgo:AddCol() )
         :cHeader             := "Cobro"
         :bEditValue          := {|| DtoC( ( dbfTmpPgo )->dEntrada ) }
         :lHide               := .t.
         :nWidth              := 70
      end with

      with object ( oBrwPgo:AddCol() )
         :cHeader             := "Descripción"
         :bEditValue          := {|| ( dbfTmpPgo )->cDescrip }
         :nWidth              := 182
         :bFooter             := {|| "Total cobrado" + CRLF + "Total pendiente" }
      end with

      with object ( oBrwPgo:AddCol() )
         :cHeader             := "Div."
         :bEditValue          := {|| cSimDiv( ( dbfTmpPgo )->cDivPgo, dbfDiv ) }
         :nWidth              := 30
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
         :lHide               := .t.
      end with

      with object ( oBrwPgo:AddCol() )
         :cHeader             := "Importe"
         :bEditValue          := {|| ( dbfTmpPgo )->nImporte }
         :cEditPicture        := cPorDiv
         :nWidth              := 105
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
         :bFooter             := {|| transform( nTotCob, cPorDiv ) + CRLF + transform( nTotFac - nTotCob, cPorDiv ) }
      end with

      if nMode == EDIT_MODE
         oBrwPgo:bLDblClick   := {|| ExtEdtRecCli( dbfTmpPgo, nView, .t., oCtaRem, oCentroCoste ), oBrwPgo:Refresh(), RecalculaTotal( aTmp ) }
      end if

      REDEFINE BUTTON ;
         ID       500 ;
         OF       fldRecibos;
         WHEN     ( nMode == EDIT_MODE ) ;
         ACTION   ( ExtEdtRecCli( dbfTmpPgo, nView, .t., oCtaRem, oCentroCoste ), oBrwPgo:Refresh(), RecalculaTotal( aTmp ) )

      REDEFINE BUTTON ;
         ID       501 ;
         OF       fldRecibos;
         WHEN     ( nMode == EDIT_MODE ) ;
         ACTION   ( ExtDelRecCli( dbfTmpPgo ), oBrwPgo:Refresh(), RecalculaTotal( aTmp ) )

      REDEFINE BUTTON ;
         ID       502 ;
         OF       fldRecibos;
         WHEN     ( nMode == EDIT_MODE ) ;
         ACTION   ( VisRecCli( ( dbfTmpPgo )->cSerie + str( ( dbfTmpPgo )->nNumFac ) + ( dbfTmpPgo )->cSufFac + str( ( dbfTmpPgo )->nNumRec ) + ( dbfTmpPgo )->cTipRec, .f. ) )

      REDEFINE BUTTON ;
         ID       503 ;
         OF       fldRecibos;
         WHEN     ( nMode == EDIT_MODE ) ;
         ACTION   ( PrnRecCli( ( dbfTmpPgo )->cSerie + str( ( dbfTmpPgo )->nNumFac ) + ( dbfTmpPgo )->cSufFac + str( ( dbfTmpPgo )->nNumRec ) + ( dbfTmpPgo )->cTipRec, .f. ) )

      /*
      Anticipos
      -------------------------------------------------------------------------
      */

      oBrwAnt                 := IXBrowse():New( fldAnticipos )

      oBrwAnt:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwAnt:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrwAnt:cAlias          := dbfTmpAnt
      oBrwAnt:cName           := "Factura de cliente.Anticipos"

      oBrwAnt:nMarqueeStyle   := 6

      oBrwAnt:CreateFromResource( 290 )

      with object ( oBrwAnt:AddCol() )
         :cHeader             := "Número"
         :bEditValue          := {|| ( dbfTmpAnt )->cSerAnt + "/" + AllTrim( str( ( dbfTmpAnt )->nNumAnt ) ) + "/" + ( dbfTmpAnt )->cSufAnt }
         :nWidth              := 70
      end with

      with object ( oBrwAnt:AddCol() )
         :cHeader             := "Fecha"
         :bEditValue          := {|| Dtoc( ( dbfTmpAnt )->dFecAnt ) }
         :nWidth              := 88
      end with

      with object ( oBrwAnt:AddCol() )
         :cHeader             := "Cliente"
         :bEditValue          := {|| Rtrim( ( dbfTmpAnt )->cCodCli ) }
         :nWidth              := 70
      end with

      with object ( oBrwAnt:AddCol() )
         :cHeader             := "Nombre"
         :bEditValue          := {|| AllTrim( ( dbfTmpAnt )->cNomCli ) }
         :nWidth              := 194
      end with

      with object ( oBrwAnt:AddCol() )
         :cHeader             := "Div."
         :bEditValue          := {|| cSimDiv( ( dbfTmpAnt )->cDivAnt, dbfDiv ) }
         :nWidth              := 30
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
         :lHide               := .t.
      end with

      with object ( oBrwAnt:AddCol() )
         :cHeader             := "Importe"
         :bEditValue          := {|| nTotAntCli( dbfTmpAnt, dbfIva, dbfDiv ) }
         :cEditPicture        := cPorDiv
         :nWidth              := 124
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
      end with

      REDEFINE BUTTON ;
         ID       270 ;
         OF       fldAnticipos ;
         WHEN     ( lWhen ) ;
         ACTION   ( BrwAntCli( , D():AnticiposClientes( nView ), dbfIva, dbfDiv, dbfTmpAnt, oBrwAnt ), RecalculaTotal( aTmp ) )

      REDEFINE BUTTON ;
         ID       400 ;
         OF       fldAnticipos ;
         WHEN     ( lWhen ) ;
         ACTION   ( BrwAntCli( aTmp[ _CCODCLI ], D():AnticiposClientes( nView ), dbfIva, dbfDiv, dbfTmpAnt, oBrwAnt ) )

      REDEFINE BUTTON ;
         ID       280 ;
         OF       fldAnticipos ;
         WHEN     ( lWhen ) ;
         ACTION   ( delRecno( dbfTmpAnt, oBrwAnt ), RecalculaTotal( aTmp ) )

      /*
      Pagado y pendiente en facturas
      ------------------------------------------------------------------------
      */

      REDEFINE GET oGetPes VAR nTotPes ;
         WHEN     ( .f. ) ;
         PICTURE  ( MasUnd() ) ;
         ID       570 ;
         OF       fldData

      REDEFINE GET oGetDif VAR nTotalDif ;
         ID       580 ;
         WHEN     ( .f. ) ;
         PICTURE  ( MasUnd() ) ;
         OF       fldData

      /*
      Detalle________________________________________________________________
      */

      oBrwInc                 := IXBrowse():New( fldIncidencias )

      oBrwInc:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwInc:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrwInc:cAlias          := dbfTmpInc

      oBrwInc:nMarqueeStyle   := 6
      oBrwInc:cName           := "Factura de cliente.Incidencia"

         with object ( oBrwInc:AddCol() )
            :cHeader          := "Re. Resuelta"
            :bStrData         := {|| "" }
            :bEditValue       := {|| ( dbfTmpInc )->lListo }
            :nWidth           := 90
            :SetCheck( { "Sel16", "Cnt16" } )
         end with

         with object ( oBrwInc:AddCol() )
            :cHeader          := "Fecha"
            :bEditValue       := {|| Dtoc( ( dbfTmpInc )->dFecInc ) }
            :nWidth           := 100
         end with

         with object ( oBrwInc:AddCol() )
            :cHeader          := "Descripción"
            :bEditValue       := {|| ( dbfTmpInc )->mDesInc }
            :nWidth           := 380
         end with

         if nMode != ZOOM_MODE
            oBrwInc:bLDblClick   := {|| WinEdtRec( oBrwInc, bEdtInc, dbfTmpInc, nil, nil, aTmp ) }
         else
            oBrwInc:bLDblClick   := {|| WinZooRec( oBrwInc, bEdtInc, dbfTmpInc ) }
         end if

         oBrwInc:CreateFromResource( 210 )

      REDEFINE BUTTON ;
         ID       500 ;
         OF       fldIncidencias ;
         WHEN     ( lWhen ) ;
         ACTION   ( WinAppRec( oBrwInc, bEdtInc, dbfTmpInc, nil, nil, aTmp ) )

      REDEFINE BUTTON ;
         ID       501 ;
         OF       fldIncidencias ;
         WHEN     ( lWhen ) ;
         ACTION   ( WinEdtRec( oBrwInc, bEdtInc, dbfTmpInc, nil, nil, aTmp ) )

      REDEFINE BUTTON ;
         ID       502 ;
         OF       fldIncidencias ;
         WHEN     ( lWhen ) ;
         ACTION   ( WinDelRec( oBrwInc, dbfTmpInc ) )

      REDEFINE BUTTON ;
         ID       503 ;
         OF       fldIncidencias ;
         ACTION   ( WinZooRec( oBrwInc, bEdtInc, dbfTmpInc ) )

      //Caja de documentos-----------------------------------------------------

      oBrwDoc                 := IXBrowse():New( fldDocumentos )

      oBrwDoc:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwDoc:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrwDoc:cAlias          := dbfTmpDoc

      oBrwDoc:nMarqueeStyle   := 6
      oBrwDoc:nRowHeight      := 40
      oBrwDoc:nDataLines      := 2

      with object ( oBrwDoc:AddCol() )
         :cHeader          := "Documento"
         :bEditValue       := {|| Rtrim( ( dbfTmpDoc )->cNombre ) + CRLF + Space( 5 ) + Rtrim( ( dbfTmpDoc )->cRuta ) }
         :nWidth           := 940
      end with

      if nMode != ZOOM_MODE
         oBrwDoc:bLDblClick   := {|| ShellExecute( oDlg:hWnd, "open", Rtrim( ( dbfTmpDoc )->cRuta ) ) }
      end if

      oBrwDoc:CreateFromResource( 210 )

      REDEFINE BUTTON ;
         ID       500 ;
         OF       fldDocumentos ;
         WHEN     ( lWhen ) ;
         ACTION   ( WinAppRec( oBrwDoc, bEdtDoc, dbfTmpDoc, nil, nil, aTmp ) )

      REDEFINE BUTTON ;
         ID       501 ;
         OF       fldDocumentos ;
         WHEN     ( lWhen ) ;
         ACTION   ( WinEdtRec( oBrwDoc, bEdtDoc, dbfTmpDoc, nil, nil, aTmp ) )

      REDEFINE BUTTON ;
         ID       502 ;
         OF       fldDocumentos ;
         WHEN     ( lWhen ) ;
         ACTION   ( WinDelRec( oBrwDoc, dbfTmpDoc ) )

      REDEFINE BUTTON ;
         ID       503 ;
         OF       fldDocumentos ;
         ACTION   ( WinZooRec( oBrwDoc, bEdtDoc, dbfTmpDoc ) )

      REDEFINE BUTTON ;
         ID       504 ;
         OF       fldDocumentos ;
         ACTION   ( ShellExecute( oDlg:hWnd, "open", rTrim( ( dbfTmpDoc )->cRuta ) ) )

      //Caja de entidades-----------------------------------------------------

      oBrwEntidades                 := IXBrowse():New( fldEntidades )

      oBrwEntidades:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwEntidades:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrwEntidades:cAlias          := dbfTmpEntidades

      oBrwEntidades:nMarqueeStyle   := 6

      with object ( oBrwEntidades:AddCol() )
         :cHeader          := "Entidades"
         :bEditValue       := {|| ( dbfTmpEntidades )->cCodEnt }
         :nWidth           := 300
      end with

      with object ( oBrwEntidades:AddCol() )
         :cHeader          := "Rol"
         :bEditValue       := {|| ( dbfTmpEntidades )->cRol }
         :nWidth           := 300
      end with

      oBrwEntidades:CreateFromResource( 210 )

      REDEFINE BUTTON ;
         ID       500 ;
         OF       fldEntidades ;
         WHEN     ( lWhen ) ;
         ACTION   ( BrwEntidad( aTmp[ _CCODCLI ], dbfTmpEntidades ), oBrwEntidades:refresh() )

      REDEFINE BUTTON ;
         ID       501 ;
         OF       fldEntidades ;
         WHEN     ( lWhen ) ;
         ACTION   ( WinAppRec( oBrwEntidades, bEdtEntidades, dbfTmpEntidades ) )

      REDEFINE BUTTON ;
         ID       502 ;
         OF       fldEntidades ;
         WHEN     ( lWhen ) ;
         ACTION   ( WinDelRec( oBrwEntidades, dbfTmpEntidades ) )

         /*
      Situaciones--------------------------------------------------------------
      */

      oBrwEst                 := IXBrowse():New( fldSituaciones )

      oBrwEst:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwEst:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrwEst:cAlias          := dbfTmpEst

      oBrwEst:nMarqueeStyle   := 6
      oBrwEst:cName           := "Factura de cliente.Situaciones"

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
        OF       fldSituaciones ;
        WHEN     ( lWhen ) ;
        ACTION   ( WinAppRec( oBrwEst, bEdtEst, dbfTmpEst, nil, nil, aTmp ) )


   REDEFINE BUTTON ;
      ID       501 ;
      OF       fldSituaciones ;
      WHEN     ( lWhen ) ;
      ACTION   ( WinEdtRec( oBrwEst, bEdtEst, dbfTmpEst, nil, nil, aTmp ) )

   REDEFINE BUTTON ;
      ID        502 ;
      OF       fldSituaciones ;
      WHEN     ( lWhen ) ;
      ACTION   ( WinDelRec( oBrwEst, dbfTmpEst ) )

   REDEFINE BUTTON ;
      ID        503 ;
      OF       fldSituaciones ;
      ACTION   ( WinZooRec( oBrwEst, bEdtEst, dbfTmpEst, nil, nil, aTmp ) )

      /*
      Fin de los Folders
      -----------------------------------------------------------------------
      */

      oMeter      := TApoloMeter():ReDefine( 200, { | u | if( pCount() == 0, nMeter, nMeter := u ) }, 10, oDlg, .f., , , .t., Rgb( 255,255,255 ), , Rgb( 128,255,0 ) )

      REDEFINE BUTTON ;
         ID       3 ;
         OF       oDlg ;
         WHEN     ( lWhen ) ;
         ACTION   ( RecFacCli( aTmp ), oBrwLin:Refresh(), RecalculaTotal( aTmp ) )

      REDEFINE BUTTON ;
         ID       4 ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( if( EndTrans( aTmp, aGet, oBrw, oBrwLin, oBrwPgo, aNumAlb, nMode, oDlg ), GenFacCli( IS_PRINTER ), ) )

      REDEFINE BUTTON oBtn ;
         ID       IDOK ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( EndTrans( aTmp, aGet, oBrw, oBrwLin, oBrwPgo, aNumAlb, nMode, oDlg ) )

      REDEFINE BUTTON ;
         ID       IDCANCEL ;
         OF       oDlg ;
         CANCEL ;
         ACTION   ( if( exitNoSave( nMode, dbfTmpLin ), oDlg:end(), ) )

      REDEFINE GROUP oSayLabels[ 1 ] ID 700 OF fldGeneral TRANSPARENT
      REDEFINE SAY   oSayLabels[ 2 ] ID 708 OF fldGeneral
      REDEFINE SAY   oSayLabels[ 4 ] ID 710 OF fldGeneral
      REDEFINE SAY   oSayLabels[ 5 ] ID 712 OF fldGeneral

      /*
      Bitmap________________________________________________________________
      */

      REDEFINE BITMAP oBmpEmp FILE "Bmp\ImgFacCli.bmp" ID 500 OF oDlg

      /*
      Apertura de la caja de Dialogo
      ----------------------------------------------------------------------------
      */

      if nMode != ZOOM_MODE
   
         fldGeneral:AddFastKey( VK_F2, {|| AppDeta( oBrwLin, bEdtDet, aTmp, .f. ) } )
         fldGeneral:AddFastKey( VK_F3, {|| EdtDeta( oBrwLin, bEdtDet, aTmp, .f., nMode ) } )
         fldGeneral:AddFastKey( VK_F4, {|| WinDelRec( oBrwLin, dbfTmpLin, {|| DelDeta() }, {|| RecalculaTotal( aTmp ) } ) } )
   
         fldIncidencias:AddFastKey( VK_F2, {|| WinAppRec( oBrwInc, bEdtInc, dbfTmpInc, nil, nil, aTmp ) } )
         fldIncidencias:AddFastKey( VK_F3, {|| WinEdtRec( oBrwInc, bEdtInc, dbfTmpInc, nil, nil, aTmp ) } )
         fldIncidencias:AddFastKey( VK_F4, {|| WinDelRec( oBrwInc, dbfTmpInc ) } )
   
         fldDocumentos:AddFastKey( VK_F2, {|| WinAppRec( oBrwDoc, bEdtDoc, dbfTmpDoc, nil, nil, aTmp ) } )
         fldDocumentos:AddFastKey( VK_F3, {|| WinEdtRec( oBrwDoc, bEdtDoc, dbfTmpDoc, nil, nil, aTmp ) } )
         fldDocumentos:AddFastKey( VK_F4, {|| WinDelRec( oBrwDoc, dbfTmpDoc ) } )

         fldSituaciones:AddFastKey( VK_F2, {|| WinAppRec( oBrwEst, bEdtEst, dbfTmpEst, nil, nil, aTmp ) } )
         fldSituaciones:AddFastKey( VK_F3, {|| WinEdtRec( oBrwEst, bEdtEst, dbfTmpEst, nil, nil, aTmp ) } )
         fldSituaciones:AddFastKey( VK_F4, {|| WinDelRec( oBrwEst, dbfTmpEst ) } )

         oDlg:AddFastKey( VK_F6,             {|| if( EndTrans( aTmp, aGet, oBrw, oBrwLin, oBrwPgo, aNumAlb, nMode, oDlg ), GenFacCli( IS_PRINTER ), ) } )
         oDlg:AddFastKey( VK_F5,             {|| EndTrans( aTmp, aGet, oBrw, oBrwLin, oBrwPgo, aNumAlb, nMode, oDlg ) } )
         oDlg:AddFastKey( VK_F9,             {|| oDetCamposExtra:Play( Space( 1 ) ) } )
         oDlg:AddFastKey( 65,                {|| if( GetKeyState( VK_CONTROL ), CreateInfoArticulo(), ) } )
   
      end if

      oDlg:SetControlFastKey( "FacturasClientesLineas", nView, aGet, dbfTmpLin )
   
      oDlg:bStart := {|| StartEdtRec( aTmp, aGet, oDlg, nMode, hHash, oBrwLin ) }

   ACTIVATE DIALOG oDlg ;
      ON INIT     ( initDialog( aTmp, oDlg, oBrwLin, oBrwInc, oBrwPgo, oBrwAnt ), SetDialog( aGet, oSayDias, oSayGetRnt, oGetRnt ) );
      ON PAINT    ( recalculaTotal( aTmp ) );
      CENTER

   /*
   Salimos --------------------------------------------------------------------
   */

   if ( oDlg:nResult != IDOK )
      CancelEdtRec( nMode, aGet )
   end if 

   DisableAcceso()

   /*
   Repos-----------------------------------------------------------------------
   */

   ( D():FacturasClientes( nView ) )->( ordSetFocus( nOrd ) )

   /*
   Guardamos los datos del browse---------------------------------------------
   */

   if !empty( oBrwLin )
      oBrwLin:CloseData()
      oBrwLin:end()
   end if

   if !empty( oBrwIva )
      oBrwIva:end()
   end if

   if !empty( oBrwPgo )
      oBrwPgo:CloseData()
      oBrwPgo:end()
   end if

   if !empty( oBrwAnt )
      oBrwAnt:CloseData()
      oBrwAnt:end()
   end if

   if !empty( oBrwInc )
      oBrwInc:CloseData()
      oBrwInc:end()
   end if

   if !empty( oBrwDoc )
      oBrwDoc:end()
   end if

   if !empty( oBtnPre )
      oBtnPre:end()
   end if

   if !empty( oBtnPed )
      oBtnPed:end()
   end if

   if !empty( oBtnAlb )
      oBtnAlb:end()
   end if

   if !empty( oBtnSat )
      oBtnSat:end()
   end if

   if !empty( oMenu )
      oMenu:end()
   end if

   if !empty( oBmpDiv )
      oBmpDiv:end()
   end if

   if !empty( oBmpEmp )
      oBmpEmp:end()
   end if

   /*
   Salida sin grabar-----------------------------------------------------------
   */

   KillTrans()

   SysRefresh()

   EnableAcceso()

RETURN ( oDlg:nResult == IDOK )

//----------------------------------------------------------------------------//

Static Function StartEdtRec( aTmp, aGet, oDlg, nMode, hHash, oBrwLin )

   if nMode == APPD_MODE

      if lRecogerUsuario() .and. !lGetUsuario( aGet[ _CCODUSR ], dbfUsr )
         oDlg:End()
      end if 

      if IsHash( hHash )

         do case
            case HGetKeyAt( hHash, 1 ) == "artículo"
               AppDeta( oBrwLin, bEdtDet, aTmp, nil, HGetValueAt( hHash, 1 ) )

            case HGetKeyAt( hHash, 1 ) == "Cliente"
               aGet[ _CCODCLI ]:cText( HGetValueAt( hHash, 1 ) )
               aGet[ _CCODCLI ]:lValid()

            case HGetKeyAt( hHash, 1 ) == "SAT"
               aGet[ _CNUMSAT ]:cText( HGetValueAt( hHash, 1 ) )
               aGet[ _CNUMSAT ]:lValid()

            case HGetKeyAt( hHash, 1 ) == "Presupuesto"
               aGet[ _CNUMPRE ]:cText( HGetValueAt( hHash, 1 ) )
               aGet[ _CNUMPRE ]:lValid()

            case HGetKeyAt( hHash, 1 ) == "Pedido"
               aGet[ _CNUMPED ]:cText( HGetValueAt( hHash, 1 ) )
               aGet[ _CNUMPED ]:lValid()

            case HGetKeyAt( hHash, 1 ) == "Albaran"
               aGet[ _CNUMALB ]:cText( HGetValueAt( hHash, 1 ) )
               aGet[ _CNUMALB ]:lValid()

            case HGetKeyAt( hHash, 1 ) == "Factura"
               cFacPrv( HGetValueAt( hHash, 1 ), aGet, aTmp, oBrwLin, nMode )
         
         end case
 
      end if

    else

      if !empty( aGet[ _CCENTROCOSTE ] )
         aGet[ _CCENTROCOSTE ]:lValid()
      endif 

   end if 

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

   if !empty( dbfTmpInc ) .and. ( dbfTmpInc )->( Used() ) 

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

Static Function InitDialog( aTmp, oDlg, oBrwLin, oBrwInc, oBrwPgo, oBrwAnt )

   EdtRecMenu( aTmp, oDlg )

   oBrwLin:MakeTotals()
   
   oBrwLin:Load()
   oBrwInc:Load()
   oBrwPgo:Load()
   oBrwAnt:Load()

   oMeter:Set( 0 )

Return ( nil )

//----------------------------------------------------------------------------//

Static Function CancelEdtRec( nMode, aGet )

   local cNumDoc  

   if ( nMode == APPD_MODE .or. nMode == DUPL_MODE )

      CursorWait()

      // Rollback de los albaranes facturados----------------------------------

      if len( aNumAlb ) > 0
         for each cNumDoc in aNumAlb 
            if ( dbfAlbCliT )->( dbSeek( cNumDoc ) )
               SetFacturadoAlbaranCliente( .f., , dbfAlbCliT, dbfAlbCliL, dbfAlbCliS )
            end if
         next
      end if

      // Presupuestos----------------------------------------------------------

      cNumDoc                             := aGet[ _CNUMPRE ]:VarGet()

      if !empty( cNumDoc ) .and. dbSeekInOrd( cNumDoc, "nNumPre", dbfPreCliT )
         if ( dbfPreCliT )->lEstado .and. dbLock( dbfPreCliT )
            ( dbfPreCliT )->lEstado    := .f.
            ( dbfPreCliT )->( dbUnLock() )
         end if
      end if 

      // Pedidos---------------------------------------------------------------

      cNumDoc                             := aGet[ _CNUMPED ]:VarGet()

      if !empty( cNumDoc ) .and. dbSeekInOrd( cNumDoc, "nNumPed", dbfPedCliT )
         if ( dbfPedCliT )->nEstado != 1 .and. dbLock( dbfPedCliT )
            ( dbfPedCliT )->nEstado    := 1
            ( dbfPedCliT )->( dbUnLock() )
         end if
      end if 

      // SAT--------------------------------------------------------------

      cNumDoc                             := aGet[ _CNUMSAT ]:VarGet()

      if !empty( cNumDoc ) .and. dbSeekInOrd( cNumDoc, "nNumSat", dbfSatCliT )
         if ( dbfSatCliT )->lEstado .and. dbLock( dbfSatCliT )
            ( dbfSatCliT )->lEstado    := .f.
            ( dbfSatCliT )->( dbUnLock() )
         end if
      end if 

      CursorWE()

   end if

Return ( nil )

//----------------------------------------------------------------------------//

/*
Edita las lineas de Detalle
*/

STATIC FUNCTION EdtDet( aTmp, aGet, cFacCliL, oBrw, lTotLin, cCodArtEnt, nMode, aTmpFac )

   local oDlg
   local oFld
   local oBtn
   local oGet3
   local cGet3             := ""
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
   local oStkAct
   local nStkAct           := 0
   local oBtnSer
   local oSayGrp
   local cSayGrp           := ""
   local oSayFam
   local cSayFam           := ""
   local cCodArt           := Padr( aTmp[ _CREF ], 32 )
   local oSayDias

   cTipoCtrCoste           := AllTrim( aTmp[ _CTIPCTR ] )

   do case
   case nMode == APPD_MODE

      aTmp[ _NCANENT  ]       := 1
      aTmp[ _DFECHA   ]       := aTmpFac[ _DFECFAC ]
      aTmp[ _LTOTLIN  ]       := lTotLin
      aTmp[ _CALMLIN  ]       := aTmpFac[ _CCODALM ] 
      aTmp[ _LIVALIN  ]       := aTmpFac[ _LIVAINC ]
      aTmp[ _CTIPMOV  ]       := cDefVta()
      aTmp[ __CNUMPED ]       := aTmpFac[ _CNUMPED ]
      aTmp[ __DFECFAC ]       := aTmpFac[ _DFECFAC ]
      aTmp[ __TFECFAC ]       := aTmpFac[ _TFECFAC ]

      aTmp[ _NTARLIN  ]       := oGetTarifa:getTarifa()

      if !empty( cCodArtEnt )
         cCodArt              := Padr( cCodArtEnt, 32 )
      end if

      aTmp[ __DFECSAL ]       := aTmpFac[ _DFECSAL  ]
      aTmp[ __DFECENT ]       := aTmpFac[ _DFECENTR ]

      if !empty( oTipFac ) .and. oTipFac:nAt == 2
         aTmp[ __LALQUILER ]  := .t.
      else
         aTmp[ __LALQUILER ]  := .f.
      end if

      aTmp[ __CCODOBR ]       := aTmpFac[ _CCODOBR ]

      cTipoCtrCoste           := "Centro de coste"

      oLinDetCamposExtra:setTemporalAppend()

   case nMode == EDIT_MODE

      aTmp[ _NPREUNIT ] := Round( aTmp[ _NPREUNIT ], nDouDiv )
      aTmp[ _NPNTVER  ] := Round( aTmp[ _NPNTVER  ], nDpvDiv )
      aTmp[ _NDTODIV  ] := Round( aTmp[ _NDTODIV  ], nDouDiv )
      lTotLin           := aTmp[ _LTOTLIN ]

   case nMode == MULT_MODE

      aTmp[ _NDTODIV  ] := Round( aTmp[ _NDTODIV  ], nDouDiv )
      lTotLin           := aTmp[ _LTOTLIN ]

   end case

   /*
   Este valor los guaradamos para detectar los posibles cambios----------------
   */

   cOldCodArt           := aTmp[ _CREF    ]
   cOldPrpArt           := aTmp[ _CCODPR1 ] + aTmp[ _CCODPR2 ] + aTmp[ _CVALPR1 ] + aTmp[ _CVALPR2 ]
   cOldUndMed           := aTmp[ _CUNIDAD ]

   /*Etiquetas de familias y grupos de familias*/

   cSayGrp              := RetFld( aTmp[ _CGRPFAM ], oGrpFam:GetAlias() )
   cSayFam              := RetFld( aTmp[ _CCODFAM ], dbfFamilia )

   /*
   Caja de dialogo-------------------------------------------------------------
   */

   DEFINE DIALOG oDlg RESOURCE "LFACCLI" TITLE LblTitle( nMode ) + "líneas de facturas de clientes"

      REDEFINE FOLDER oFld ;
         ID       400 ;
         OF       oDlg ;
         PROMPT   "&General",;
                  "Da&tos",;
                  "&Observaciones",;
                  "&Centro coste";
         DIALOGS  "LFACCLI_1",;
                  "LFACCLI_6",;
                  "LFACCLI_3",;
                  "LCTRCOSTE"

      REDEFINE GET aGet[ _CREF ] VAR cCodArt;
         ID       100 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( loaArt( cCodArt, aGet, aTmp, aTmpFac, oStkAct, oSayPr1, oSayPr2, oSayVp1, oSayVp2, bmpImage, nMode, .t. ) );
         BITMAP   "LUPA" ;
         ON HELP  ( BrwArticulo( aGet[ _CREF ], aGet[ _CDETALLE ] , , , , aGet[ _CLOTE ], aTmp[ _CCODPR1 ], aTmp[ _CCODPR2 ], aGet[ _CVALPR1 ], aGet[ _CVALPR2 ], aGet[ _DFECCAD ], if( uFieldEmpresa( "lStockAlm" ), aTmp[ _CALMLIN ], nil ) ) ); 
         OF       fldGeneral

      REDEFINE GET aGet[ _CDETALLE ] VAR aTmp[ _CDETALLE ] ;
         ID       110 ;
         WHEN     ( ( lModDes() .or. empty( aTmp[ _CDETALLE ] ) ) .AND. nMode != ZOOM_MODE .AND. nMode != MULT_MODE ) ;
         OF       fldGeneral

      REDEFINE GET aGet[_MLNGDES] VAR aTmp[_MLNGDES] ;
         MEMO ;
         ID       111 ;
         WHEN     ( ( lModDes() .or. empty( aTmp[ _MLNGDES ] ) ) .AND. nMode != ZOOM_MODE .AND. nMode != MULT_MODE ) ;
         OF       fldGeneral

      /*
      Lotes
      -------------------------------------------------------------------------
      */

      REDEFINE GET aGet[ _CLOTE ] VAR aTmp[ _CLOTE ];
         ID       112 ;
         IDSAY    113 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       fldGeneral

      aGet[ _CLOTE ]:bValid   := {|| loaArt( cCodArt, aGet, aTmp, aTmpFac, oStkAct, oSayPr1, oSayPr2, oSayVp1, oSayVp2, bmpImage, nMode, .t. )  }

      REDEFINE GET aGet[ _DFECCAD ] VAR aTmp[ _DFECCAD ];
         ID       340 ;
         IDSAY    341 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       fldGeneral

      // Propiedades-------------------------------------------------

      BrowseProperties():newInstance( 500, fldGeneral, nView )

      REDEFINE GET aGet[ _CVALPR1 ] VAR aTmp[ _CVALPR1 ];
         ID       270 ;
         BITMAP   "LUPA" ;
         WHEN     ( nMode != ZOOM_MODE .and. nMode != MULT_MODE ) ;
         VALID    ( if( lPrpAct( aTmp[ _CVALPR1 ], oSayVp1, aTmp[ _CCODPR1 ], D():PropiedadesLineas( nView ) ),;
                        loaArt( cCodArt, aGet, aTmp, aTmpFac, oStkAct, oSayPr1, oSayPr2, oSayVp1, oSayVp2, bmpImage, nMode, .f. ),;
                        .f. ) );
         ON HELP  ( brwPropiedadActual( aGet[ _CVALPR1 ], oSayVp1, aTmp[ _CCODPR1 ] ) ) ;
         OF       fldGeneral

         aGet[ _CVALPR1 ]:bChange   := {|| aGet[ _CVALPR1 ]:Assign(), if( !uFieldEmpresa( "lNStkAct" ), oStock:nPutStockActual( aTmp[ _CREF ], aTmp[ _CALMLIN ], aTmp[ _CVALPR1 ], aTmp[ _CVALPR2 ], aTmp[ _CLOTE ], aTmp[ _LKITART ], aTmp[ _NCTLSTK ], oStkAct ), .t. ) }

      REDEFINE SAY oSayPr1 VAR cSayPr1;
         ID       271 ;
         OF       fldGeneral

      REDEFINE GET oSayVp1 VAR cSayVp1;
         ID       272 ;
         WHEN     .f. ;
         OF       fldGeneral

      REDEFINE GET aGet[ _CVALPR2 ] VAR aTmp[ _CVALPR2 ];
         ID       280 ;
         BITMAP   "LUPA" ;
         WHEN     ( nMode != ZOOM_MODE .AND. nMode != MULT_MODE ) ;
         VALID    ( if( lPrpAct( aTmp[ _CVALPR2 ], oSayVp2, aTmp[ _CCODPR2 ], D():PropiedadesLineas( nView ) ),;
                        loaArt( cCodArt, aGet, aTmp, aTmpFac, oStkAct, oSayPr1, oSayPr2, oSayVp1, oSayVp2, bmpImage, nMode, .f. ),;
                        .f. ) );
         ON HELP  ( brwPropiedadActual( aGet[ _CVALPR2 ], oSayVp2, aTmp[ _CCODPR2 ] ) ) ;
         OF       fldGeneral

         aGet[ _CVALPR2 ]:bChange   := {|| aGet[ _CVALPR2 ]:Assign(), if( !uFieldEmpresa( "lNStkAct" ), oStock:nPutStockActual( aTmp[ _CREF ], aTmp[ _CALMLIN ], aTmp[ _CVALPR1 ], aTmp[ _CVALPR2 ], aTmp[ _CLOTE ], aTmp[ _LKITART ], aTmp[ _NCTLSTK ], oStkAct ), .t. ) }

      REDEFINE SAY oSayPr2 VAR cSayPr2;
         ID       281 ;
         OF       fldGeneral

      REDEFINE GET oSayVp2 VAR cSayVp2;
         ID       282 ;
         WHEN     .f. ;
         OF       fldGeneral

      // fin de propiedades----------------------------------------------------

      REDEFINE GET aGet[ _NIMPTRN ] VAR aTmp[ _NIMPTRN ] ;
         ID       350 ;
         IDSAY    351 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE .AND. !lTotLin ) ;
         ON CHANGE( lCalcDeta( aTmp, aTmpFac ) );
         VALID    ( lCalcDeta( aTmp, aTmpFac ) );
         PICTURE  cPouDiv ;
         OF       fldGeneral

      REDEFINE GET aGet[ _NIVA ] VAR aTmp[ _NIVA ] ;
         ID       120 ;
         WHEN     ( lModIva() .AND. nMode != ZOOM_MODE ) ;
         PICTURE  "@E 999.99" ;
         VALID    ( lTiva( dbfIva, aTmp[ _NIVA ], @aTmp[ _NREQ ] ) );
         ON CHANGE( lCalcDeta( aTmp, aTmpFac ) );
         BITMAP   "LUPA" ;
         ON HELP  ( BrwIva( aGet[ _NIVA ], dbfIva, , .t. ) );
         OF       fldGeneral

      REDEFINE GET aGet[ _NVALIMP ] VAR aTmp[ _NVALIMP ] ;
         ID       125 ;
         IDSAY    126 ;
         SPINNER ;
         WHEN     ( uFieldEmpresa( "lModImp" ) .AND. nMode != ZOOM_MODE ) ;
         PICTURE  cPouDiv ;
         ON CHANGE( lCalcDeta( aTmp, aTmpFac ) );
         ON HELP  ( oNewImp:nBrwImp( aGet[ _NVALIMP ] ) );
         OF       fldGeneral

      REDEFINE GET aGet[ __NBULTOS ] VAR aTmp[ __NBULTOS ] ;
         ID       450 ;
         IDSAY    451 ;
         SPINNER ;
         WHEN     ( uFieldEmpresa( "lUseBultos" ) .AND. nMode != ZOOM_MODE ) ;
         PICTURE  cPicUnd ;
         OF       fldGeneral

      aGet[ __NBULTOS ]:Cargo          := "nBultos"
      aGet[ __NBULTOS ]:bPostValidate  := {| oSender | runScript( "FacturasClientes\Lineas\validControl.prg", oSender, aGet, nView, nMode, aTmpFac ) }    

      REDEFINE GET aGet[_NCANENT] VAR aTmp[_NCANENT] ;
         ID       130 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE .AND. lUseCaj() .AND. !lTotLin .AND. nMode != MULT_MODE ) ;
         ON CHANGE( lCalcDeta( aTmp, aTmpFac ), loaArt( cCodArt, aGet, aTmp, aTmpFac, oStkAct, oSayPr1, oSayPr2, oSayVp1, oSayVp2, bmpImage, nMode, .f. ) );
         VALID    ( lCalcDeta( aTmp, aTmpFac ), loaArt( cCodArt, aGet, aTmp, aTmpFac, oStkAct, oSayPr1, oSayPr2, oSayVp1, oSayVp2, bmpImage, nMode, .f. ) );
         PICTURE  cPicUnd ;
         OF       fldGeneral ;
         IDSAY    131

      aGet[ _NCANENT ]:Cargo          := "nCanEnt"
      aGet[ _NCANENT ]:bPostValidate  := {| oSender | runScript( "FacturasClientes\Lineas\validControl.prg", oSender, aGet, nView, nMode, aTmpFac ) } 

      REDEFINE GET aGet[ _NUNICAJA ] ;
         VAR      aTmp[ _NUNICAJA ] ;
         ID       140 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE .AND. !lTotLin .AND. nMode != MULT_MODE .and. oUser():lModificaUnidades() ) ; // .AND. !aTmpFac[ _LIMPALB ]
         ON CHANGE( lCalcDeta( aTmp, aTmpFac ), loaArt( cCodArt, aGet, aTmp, aTmpFac, oStkAct, oSayPr1, oSayPr2, oSayVp1, oSayVp2, bmpImage, nMode, .f. ) );
         VALID    ( lCalcDeta( aTmp, aTmpFac ), loaArt( cCodArt, aGet, aTmp, aTmpFac, oStkAct, oSayPr1, oSayPr2, oSayVp1, oSayVp2, bmpImage, nMode, .f. ) );
         PICTURE  cPicUnd ;
         OF       fldGeneral ;
         IDSAY    141

      aGet[ _NUNICAJA ]:Cargo          := "nUniCaja"
      aGet[ _NUNICAJA ]:bPostValidate  := {| oSender | runScript( "FacturasClientes\Lineas\validControl.prg", oSender, aGet, nView, nMode, aTmpFac ) } 

      BrowseProperties():getInstance():setBindingUnidades( aGet[ _NUNICAJA ] )

      REDEFINE GET aGet[ _CUNIDAD ] VAR aTmp[ _CUNIDAD ] ;
         ID       170 ;
         IDTEXT   171 ;
         BITMAP   "LUPA" ;
         VALID    ( oUndMedicion:Existe( aGet[ _CUNIDAD ], aGet[ _CUNIDAD ]:oHelpText, "cNombre" ), ValidaMedicion( aTmp, aGet ) );
         ON HELP  ( oUndMedicion:Buscar( aGet[ _CUNIDAD ] ), ValidaMedicion( aTmp, aGet ) ) ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       fldGeneral

      /*
      Campos de las descripciones de la unidad de medición---------------------
      */

      REDEFINE GET aGet[ ( D():FacturasClientesLineas( nView ) )->( fieldpos( "nMedUno" ) ) ] ;
         VAR      aTmp[ ( D():FacturasClientesLineas( nView ) )->( fieldpos( "nMedUno" ) ) ] ;
         ID       520 ;
         IDSAY    521 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ON CHANGE( lCalcDeta( aTmp, aTmpFac ) );
         PICTURE  MasUnd() ;
         OF       fldGeneral

         aGet[ ( D():FacturasClientesLineas( nView ) )->( fieldpos( "nMedUno" ) ) ]:oSay:SetColor( CLR_BLUE )

      REDEFINE GET aGet[ ( D():FacturasClientesLineas( nView ) )->( fieldpos( "nMedDos" ) ) ] ;
         VAR      aTmp[ ( D():FacturasClientesLineas( nView ) )->( fieldpos( "nMedDos" ) ) ] ;
         ID       530 ;
         IDSAY    531 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ON CHANGE( lCalcDeta( aTmp, aTmpFac ) );
         PICTURE  MasUnd() ;
         OF       fldGeneral

         aGet[ ( D():FacturasClientesLineas( nView ) )->( fieldpos( "nMedDos" ) ) ]:oSay:SetColor( CLR_BLUE )

      REDEFINE GET aGet[ ( D():FacturasClientesLineas( nView ) )->( fieldpos( "nMedTre" ) ) ] ;
         VAR      aTmp[ ( D():FacturasClientesLineas( nView ) )->( fieldpos( "nMedTre" ) ) ] ;
         ID       540 ;
         IDSAY    541 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ON CHANGE( lCalcDeta( aTmp, aTmpFac ) );
         PICTURE  MasUnd() ;
         OF       fldGeneral

         aGet[ ( D():FacturasClientesLineas( nView ) )->( fieldpos( "nMedTre" ) ) ]:oSay:SetColor( CLR_BLUE )

      REDEFINE GET aGet[ _NPREUNIT ] VAR aTmp[ _NPREUNIT ] ;
         ID       150 ;
         SPINNER ;
         PICTURE  cPouDiv ;
         WHEN     ( nMode != ZOOM_MODE .AND. !lTotLin .AND. nMode != MULT_MODE ) ;
         ON CHANGE( lCalcDeta( aTmp, aTmpFac ) );
         VALID    ( lCalcDeta( aTmp, aTmpFac ) );
         OF       fldGeneral

      REDEFINE GET aGet[ _NTARLIN ] VAR aTmp[ _NTARLIN ];
         ID       156 ;
         SPINNER ;
         MIN      1 ;
         MAX      6 ;
         PICTURE  "9" ;
         VALID    ( aTmp[ _NTARLIN ] >= 1 .AND. aTmp[ _NTARLIN ] <= 6 );
         WHEN     ( nMode != ZOOM_MODE .and. ( lUsrMaster() .or. oUser():lCambiarPrecio() ) );
         ON CHANGE(  changeTarifa( aTmp, aGet, aTmpFac ),;
                     loadComisionAgente( aTmp, aGet, aTmpFac ),;
                     lCalcDeta( aTmp, aTmpFac ) );
         OF       fldGeneral

      REDEFINE GET aGet[ _NPNTVER ] ;
         VAR      aTmp[ _NPNTVER ] ;
         ID       151 ;
         IDSAY    152 ;
         SPINNER ;
         PICTURE  cPpvDiv ;
         WHEN     ( nMode != ZOOM_MODE .AND. !lTotLin .AND. nMode != MULT_MODE ) ;
         ON CHANGE( lCalcDeta( aTmp, aTmpFac ) );
         VALID    ( lCalcDeta( aTmp, aTmpFac ) );
         OF       fldGeneral

      REDEFINE GET aGet[ _NFACCNV ] VAR aTmp[ _NFACCNV ] ;
         ID       295 ;
         WHEN     ( nMode != ZOOM_MODE .AND. !lTotLin .AND. nMode != MULT_MODE ) ;
         PICTURE  "@E 999,999.999999";
         OF       fldGeneral

      REDEFINE GET aGet[ _NPESOKG ] VAR aTmp[ _NPESOKG ] ;
         ID       160 ;
         WHEN     ( nMode != ZOOM_MODE .AND. !lTotLin .AND. nMode != MULT_MODE ) ;
         PICTURE  "@E 999,999.999999";
         OF       fldGeneral

      REDEFINE GET aGet[ _CPESOKG ] VAR aTmp[ _CPESOKG ] ;
         ID       175 ;
         WHEN     ( nMode != ZOOM_MODE .AND. !lTotLin .AND. nMode != MULT_MODE ) ;
         OF       fldGeneral

      REDEFINE GET aGet[ _NVOLUMEN ] VAR aTmp[ _NVOLUMEN ] ;
         ID       400 ;
         WHEN     ( nMode != ZOOM_MODE .AND. !lTotLin .AND. nMode != MULT_MODE ) ;
         PICTURE  "@E 999,999.999999";
         OF       fldGeneral

      REDEFINE GET aGet[ _CVOLUMEN ] VAR aTmp[ _CVOLUMEN ] ;
         ID       410;
         WHEN     ( nMode != ZOOM_MODE .AND. !lTotLin .AND. nMode != MULT_MODE ) ;
         OF       fldGeneral

      REDEFINE GET aGet[ _CFORMATO ] VAR aTmp[ _CFORMATO ];
         ID       460;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       fldGeneral

      REDEFINE CHECKBOX aGet[ _LGASSUP ] VAR aTmp[ _LGASSUP ] ;
         ID       440;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       fldGeneral

      aGet[ _LGASSUP ]:bChange   := {|| if( aTmp[ _LGASSUP ], ( aGet[ _NIVA ]:cText( 0 ), aGet[ _NIVA ]:HardDisable() ), ( aGet[ _NIVA ]:HardEnable() ) ) }

      REDEFINE GET aGet[ _NDTODIV ] VAR aTmp[ _NDTODIV ] ;
         ID       260 ;
         IDSAY    261 ;
         SPINNER ;
         MIN      0 ;
         COLOR    Rgb( 255, 0, 0 ) ;
         ON CHANGE( lCalcDeta( aTmp, aTmpFac ) );
         VALID    ( aTmp[_NDTODIV] >= 0 ) ;
         WHEN     ( nMode != ZOOM_MODE .and. nMode != MULT_MODE .and. !lTotLin ) ;
         PICTURE  cPouDiv ;
         OF       fldGeneral

      REDEFINE GET aGet[ _NDTO ] VAR aTmp[ _NDTO ] ;
         ID       180 ;
         SPINNER ;
         PICTURE  "@E 999.99" ;
         WHEN     ( nMode != ZOOM_MODE .and. nMode != MULT_MODE .and. !lTotLin ) ;
         ON CHANGE( lCalcDeta( aTmp, aTmpFac ) );
         VALID    ( lCalcDeta( aTmp, aTmpFac ) );
         OF       fldGeneral

      REDEFINE GET aGet[ _NDTOPRM ] VAR aTmp[ _NDTOPRM ] ;
         ID       190 ;
         SPINNER ;
         PICTURE  "@E 999.99" ;
         WHEN     ( nMode != ZOOM_MODE .and. nMode != MULT_MODE .and. !lTotLin ) ;
         ON CHANGE( lCalcDeta( aTmp, aTmpFac ) );
         VALID    ( lCalcDeta( aTmp, aTmpFac ) );
         OF       fldGeneral

      REDEFINE GET aGet[ _NCOMAGE ] VAR aTmp[ _NCOMAGE ] ;
         ID       200 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE .and. nMode != MULT_MODE .and. !lTotLin ) ;
         ON CHANGE( lCalcDeta( aTmp, aTmpFac ) );
         VALID    ( lCalcDeta( aTmp, aTmpFac ) );
         PICTURE  "@E 999.99";
         OF       fldGeneral

      REDEFINE GET oComisionLinea VAR nComisionLinea ;
         ID       201 ;
         WHEN     ( .f. ) ;
         PICTURE  cPorDiv ;
         OF       fldGeneral

      REDEFINE GET oTotalLinea VAR nTotalLinea ;
         ID       220 ;
         WHEN     .f. ;
         PICTURE  cPorDiv ;
         OF       fldGeneral

      REDEFINE GET aGet[ _CCODTIP ] VAR aTmp[ _CCODTIP ] ;
         WHEN     ( nMode != ZOOM_MODE .and. nMode != MULT_MODE .and. !lTotLin ) ;
         VALID    ( oTipArt:Existe( aGet[ _CCODTIP ], oGet3 ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( oTipArt:Buscar( aGet[ _CCODTIP ] ) ) ;
         ID       205 ;
         OF       fldGeneral

      REDEFINE GET oGet3 VAR cGet3 ;
         ID       206 ;
         WHEN     ( .F. ) ;
         OF       fldGeneral

      /*
      Tipo de movimiento
      -------------------------------------------------------------------------
      */

      TiposVentasController();
         :Instance();
         :getDialogView();
         :createEditControl(  {  "idGet"  => 290,;
                                 "idText" => 291,;
                                 "idSay"  => 292,;
                                 "dialog" => fldGeneral,;
                                 "when"   => {|| ( nMode != ZOOM_MODE .and. nMode != MULT_MODE .and. !lTotLin ) } },;
                                 @aTmp[ ( D():FacturasClientesLineas( nView ) )->( fieldpos( "id_tipo_v" ) ) ] )

      /*
      Almacen
      -------------------------------------------------------------------------
      */

      REDEFINE GET aGet[ _CALMLIN ] VAR aTmp[ _CALMLIN ] ;
         ID       300 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( cAlmacen( aGet[ _CALMLIN ], , oSayAlm ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwAlmacen( aGet[ _CALMLIN ], oSayAlm ) ) ;
         OF       fldGeneral

      aGet[ _CALMLIN ]:bLostFocus   := {|| if( !uFieldEmpresa( "lNStkAct" ), oStock:lPutStockActual( aTmp[ _CREF ], aTmp[ _CALMLIN ], aTmp[ _CVALPR1 ], aTmp[ _CVALPR2 ], aTmp[ _CLOTE ], aTmp[ _LKITART ], aTmp[ _NCTLSTK ], oStkAct ), .t. ) }

      REDEFINE GET oSayAlm VAR cSayAlm ;
         WHEN     .F. ;
         ID       301 ;
         OF       fldGeneral

      REDEFINE GET oStkAct VAR nStkAct ;
         ID       310 ;
         WHEN     .f. ;
         PICTURE  cPicUnd ;
         OF       fldGeneral

      REDEFINE GET aGet[ _NCOSDIV ] VAR aTmp[ _NCOSDIV ] ;
         ID       320 ;
         WHEN     ( oUser():lAdministrador() .and. nMode != ZOOM_MODE );
         PICTURE  cPouDiv ;
         OF       fldGeneral ;
         IDSAY    321 ;

      /*
      Segunda caja de dilogo---------------------------------------------------
      */

      REDEFINE GET aGet[_NPOSPRINT] VAR aTmp[_NPOSPRINT] ;
         ID       100 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  "9999" ;
         OF       fldData

      REDEFINE CHECKBOX aGet[_LIMPLIN] VAR aTmp[_LIMPLIN]  ;
         ID       110 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       fldData

      REDEFINE GET aGet[_DFECHA] VAR aTmp[_DFECHA] ;
         ID       120 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE .AND. !lTotLin ) ;
         ON HELP  aGet[_DFECHA]:cText( Calendario( aTmp[_DFECHA] ) ) ;
         OF       fldData

      REDEFINE GET aGet[ __DFECFAC ] VAR aTmp[ __DFECFAC ] ;
         ID       360 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE .AND. !lTotLin ) ;
         ON HELP  aGet[ __DFECFAC ]:cText( Calendario( aTmp[ __DFECFAC ] ) ) ;
         OF       fldData

      REDEFINE GET aGet[ __TFECFAC ] VAR aTmp[ __TFECFAC ] ;
         ID       361 ;
         PICTURE  "@R 99:99:99" ;
         WHEN     ( nMode != ZOOM_MODE .AND. !lTotLin ) ;
         VALID    ( iif(   !validTime( aTmp[ __TFECFAC ] ),;
                           ( msgStop( "El formato de la hora no es correcto" ), .f. ),;
                           .t. ) );
         OF       fldData

      REDEFINE CHECKBOX aGet[_LCONTROL] VAR aTmp[_LCONTROL]  ;
         ID       130 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       fldData

      REDEFINE GET aGet[_NPVPREC] VAR aTmp[_NPVPREC] ;
         ID       140 ;
         WHEN     ( .f. ) ;
         PICTURE  cPouDiv ;
         OF       fldData

      REDEFINE GET aGet[ _CIMAGEN ] ;
         VAR      aTmp[ _CIMAGEN ] ;
         BITMAP   "LUPA" ;
         ON HELP  ( GetBmp( aGet[ _CIMAGEN ], bmpImage ) ) ;
         ON CHANGE( ChgBmp( aGet[ _CIMAGEN ], bmpImage ) ) ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ID       220 ;
         OF       fldData

      /*
      Definici-n de familias y grupos de familias------------------------------
      */

      REDEFINE GET aGet[ _CGRPFAM ] VAR aTmp[ _CGRPFAM ] ;
         ID       ( 150 );
         WHEN     ( nMode != ZOOM_MODE );
         BITMAP   "LUPA" ;
         VALID    ( oSayGrp:cText( RetFld( aTmp[ _CGRPFAM  ], oGrpFam:GetAlias() ) ), .t. ) ;
         ON HELP  ( oGrpFam:Buscar( aGet[ _CGRPFAM ] ) ) ;
         OF       fldData

      REDEFINE GET oSayGrp VAR cSayGrp ;
         ID       ( 151 );
         WHEN     .f.;
         OF       fldData

      REDEFINE GET aGet[ _CCODFAM ] VAR aTmp[ _CCODFAM ] ;
         ID       160 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         BITMAP   "LUPA" ;
         VALID    ( oSayFam:cText( RetFld( aTmp[ _CCODFAM  ], dbfFamilia ) ), .t. );
         ON HELP  ( BrwFamilia( aGet[ _CCODFAM ], oSayFam ) );
         OF       fldData

      REDEFINE GET oSayFam VAR cSayFam ;
         WHEN     ( .F. );
         ID       161 ;
         OF       fldData

    REDEFINE GET aGet[ _CCODPRV ] VAR  aTmp[ _CCODPRV ] ;
        ID       320 ;
        IDTEXT     321 ;   
        WHEN     ( nMode != ZOOM_MODE ) ;
        VALID    ( cProvee( aGet[ _CCODPRV ], dbfProvee, aGet[ _CCODPRV ]:oHelpText ) );
        BITMAP   "LUPA" ;
        ON HELP  ( BrwProvee( aGet[ _CCODPRV ], aGet[ _CCODPRV ]:oHelpText ) ) ;
        OF       fldData

      REDEFINE GET aGet[ __CCODOBR ] VAR aTmp[ __CCODOBR ] ;
         ID       330 ;
         IDTEXT   331 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( cObras( aGet[ __CCODOBR ], aGet[ __CCODOBR ]:oHelpText, aTmpFac[ _CCODCLI ], dbfObrasT ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( brwObras( aGet[ __CCODOBR ], aGet[ __CCODOBR ]:oHelpText, aTmpFac[ _CCODCLI ], dbfObrasT ) ) ;
         OF       fldGeneral

      REDEFINE GET oRentabilidadLinea VAR cRentabilidadLinea ;
         ID       300 ;
         IDSAY    301 ;
         OF       fldData

      REDEFINE CHECKBOX aGet[ _LVOLIMP ] VAR aTmp[ _LVOLIMP ] ;
         ID       411;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       fldData

      REDEFINE CHECKBOX aGet[ _LKITART ] VAR aTmp[ _LKITART ]  ;
         ID       331 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       fldData

      REDEFINE CHECKBOX aGet[ _LKITCHL ] VAR aTmp[ _LKITCHL ]  ;
         ID       330 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       fldData

      REDEFINE CHECKBOX aGet[ _LKITPRC ] VAR aTmp[ _LKITPRC ]  ;
         ID       340 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       fldData

      REDEFINE RADIO aGet[ _NCTLSTK ] VAR aTmp[ _NCTLSTK ] ;
         ID       350, 351, 352 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       fldData

    /*
    Tercera caja de dialogo--------------------------------------------------
    */

    REDEFINE GET aGet[ _MOBSLIN ] VAR aTmp[ _MOBSLIN ] ;
        MEMO ;
        ID       100 ;
        WHEN     ( nMode != ZOOM_MODE ) ;
        OF       fldIncidencias

    REDEFINE GET aGet[ _DESCRIP ] VAR aTmp[ _DESCRIP ] ;
        MEMO ;
        ID       110 ;
        WHEN     ( nMode != ZOOM_MODE ) ;
        OF       fldIncidencias

    /*
    Cuarta caja de di-logo-----------------------------------------------------  
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

    REDEFINE BUTTON oBtn;
        ID       IDOK ;
        OF       oDlg ;
        WHEN     ( nMode != ZOOM_MODE ) ;
        ACTION   SaveDeta( aTmp, aTmpFac, aGet, oBrw, oDlg, oFld, oSayPr1, oSayPr2, oSayVp1, oSayVp2, bmpImage, nMode, oTotalLinea, oStkAct, nStkAct, cCodArt, oBtn, oBtnSer )

    REDEFINE BUTTON ;
        ID       IDCANCEL ;
        OF       oDlg ;
        CANCEL ;
        ACTION   ( oDlg:end() )

    REDEFINE BUTTON ;
        ID       9 ;
        OF       oDlg ;
        ACTION   ( ChmHelp( "añadir_v" ) )

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

   oDlg:AddFastKey( VK_F6, {|| oBtnSer:Click() } )
   oDlg:AddFastKey( VK_F9, {|| oLinDetCamposExtra:Play( if( nMode == APPD_MODE, "", Str( ( dbfTmpLin )->( OrdKeyNo() ) ) ) ) } )

   oDlg:bStart    := {||   SetDlgMode( aTmp, aGet, oFld, oSayPr1, oSayPr2, oSayVp1, oSayVp2, oStkAct, nMode, oTotalLinea, aTmpFac, oRentabilidadLinea ),;
                           loadGet( aGet[ _CTERCTR ], cTipoCtrCoste ), aGet[ _CTERCTR ]:lValid(),;
                           if( !empty( cCodArtEnt ), aGet[ _CREF ]:lValid(), ), aGet[ _CCODPRV ]:lValid(), aGet[ __CCODOBR ]:lValid() }

   ACTIVATE DIALOG oDlg ;
      ON INIT     ( menuEdtDet( aGet[ _CREF ], oDlg, , if( nMode == APPD_MODE, "", Str( ( dbfTmpLin )->( OrdKeyNo() ) ) ) ) );
      CENTER

   if !Empty( oDetMenu )
      oDetMenu:End()
   end if

   if !empty( bmpImage )
      bmpImage:End()
   end if

   BrowseProperties():endInstance()

RETURN ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

Static Function EdtInc( aTmp, aGet, dbfFacCliI, oBrw, bWhen, bValid, nMode, aTmpFac )

   local oDlg

   if nMode == APPD_MODE
      aTmp[ _CSERIE   ] := aTmpFac[ _CSERIE  ]
      aTmp[ _NNUMFAC  ] := aTmpFac[ _NNUMFAC ]
      aTmp[ _CSUFFAC  ] := aTmpFac[ _CSUFFAC ]
   end if

   DEFINE DIALOG oDlg RESOURCE "INCIDENCIA" TITLE LblTitle( nMode ) + "incidencias de facturas a clientes"

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

//--------------------------------------------------------------------------//

Static Function EdtEst( aTmp, aGet, dbf, oBrw, bWhen, bValid, nMode, aTmpFac )

      local oDlg

      if nMode == APPD_MODE
         
         aTmp[ (D():FacturasClientesSituaciones( nView ))->(fieldpos("tFecSit")) ]  := GetSysTime()

    end if

      DEFINE DIALOG oDlg RESOURCE "SITUACION_ESTADO" TITLE LblTitle( nMode ) + "Situación del documento del cliente"

         REDEFINE COMBOBOX aGet[ (D():FacturasClientesSituaciones( nView ))->(fieldpos("cSitua")) ] ;
            VAR    aTmp[ (D():FacturasClientesSituaciones( nView ))->(fieldpos("cSitua")) ] ;
            ID       200 ;
            WHEN     ( nMode != ZOOM_MODE );
            ITEMS    ( SituacionesRepository():getNombres() ) ;
            OF       oDlg

        REDEFINE GET aGet[ (D():FacturasClientesSituaciones( nView ))->(fieldpos("dFecSit")) ] ;
         VAR   aTmp[ (D():FacturasClientesSituaciones( nView ))->(fieldpos("dFecSit")) ] ;
         ID       100 ;
         SPINNER ;
            ON HELP  aGet[ (D():FacturasClientesSituaciones( nView ))->(fieldpos("dFecSit")) ]:cText( Calendario( aTmp[ (D():FacturasClientesSituaciones( nView ))->(fieldpos("dFecSit")) ] ) ) ;
         WHEN  ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET aGet[ (D():FacturasClientesSituaciones( nView ))->(fieldpos("tFecSit")) ] ;
         VAR    aTmp[ (D():FacturasClientesSituaciones( nView ))->(fieldpos("tFecSit")) ] ;
            ID       101 ;
            PICTURE  "@R 99:99:99" ;
            WHEN     ( nMode != ZOOM_MODE ) ;
            VALID    ( iif( !validTime( aTmp[ (D():FacturasClientesSituaciones( nView ))->(fieldpos("tFecSit")) ] ),;
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


//--------------------------------------------------------------------------//

Static Function EdtDoc( aTmp, aGet, dbfFacCliD, oBrw, bWhen, bValid, nMode, aTmpLin )

   local oDlg
   local oRuta
   local oNombre
   local oObservacion

   DEFINE DIALOG oDlg RESOURCE "DOCUMENTOS" TITLE LblTitle( nMode ) + "documento de pedidos a proveedor"

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

//--------------------------------------------------------------------------//

Static Function EdtEntidades( aTmp, aGet, dbfTmpEntidades, oBrw, bWhen, bValid, nMode, aTmpLin )

   local oDlg
   local oCodigo

   DEFINE DIALOG oDlg RESOURCE "Facturas_Entidades" TITLE LblTitle( nMode ) + "entidades"

      REDEFINE GET oCodigo ;
         VAR      aTmp[ ( dbfTmpEntidades )->( FieldPos( "cCodEnt" ) ) ] ;
         ID       100 ;
         IDTEXT   101 ;
         PICTURE  "@!" ;
         BITMAP   "LUPA" ;
         OF       oDlg

      oCodigo:bHelp     := {|| oEntidades:Buscar( oCodigo ) }
      oCodigo:bValid    := {|| iif( !empty( oCodigo:varGet() ), oEntidades:Existe( oCodigo, oCodigo:oHelpText, "cDesEnt" ), .t. ) }

      REDEFINE COMBOBOX aTmp[ ( dbfTmpEntidades )->( FieldPos( "cRol" ) ) ] ;
         ITEMS    aRolesValues();
         ID       110 ;
         OF       oDlg

      REDEFINE BUTTON ;
         ID       IDOK ;
         OF       oDlg ;
         ACTION   ( endEdtEntidades( dbfTmpEntidades, aTmp, oBrw, nMode, oDlg, aTmp[ ( dbfTmpEntidades )->( FieldPos( "cCodEnt" ) ) ], aTmp[ ( dbfTmpEntidades )->( FieldPos( "cRol" ) ) ] ) )

      REDEFINE BUTTON ;
         ID       IDCANCEL ;
         OF       oDlg ;
         CANCEL ;
         ACTION   ( oDlg:end() )

   
      oDlg:AddFastKey( VK_F5, {|| endEdtEntidades( dbfTmpEntidades, aTmp, oBrw, nMode, oDlg, aTmp[ ( dbfTmpEntidades )->( FieldPos( "cCodEnt" ) ) ], aTmp[ ( dbfTmpEntidades )->( FieldPos( "cRol" ) ) ] ) } ) 


   oDlg:bStart    := {|| oCodigo:lValid() }

   ACTIVATE DIALOG oDlg CENTER

Return ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

static function lvalid( oDbf, CodigoEntidad, RolEntidad )

   if empty( CodigoEntidad )
         msgInfo( "La entidad no puede estar vacia." )
         Return .f.
      endif 

      if empty( RolEntidad )
         msgInfo( "El rol no puede estar vacio." )
         return .f.
      endif

   if dbSeekInOrd( ( padr( CodigoEntidad, 60 ) + padr( RolEntidad, 60 ) ), "cRolEnt", oDbf )
      msgInfo( "Codigo y rol ya introducidos." )
      return .f.
   endif

return  .t.

//--------------------------------------------------------------------------//

static function  endEdtEntidades( oDbf, aTmp, oBrw, nMode, oDlg, CodEntidad, RolEntidad )

   if lValid( oDbf, CodEntidad, RolEntidad )
      WinGather( aTmp, nil, oDbf, oBrw, nMode )
      oDlg:end( IDOK ) 
   endif

return .t.

//--------------------------------------------------------------------------//

STATIC FUNCTION EdtTablet( aTmp, aGet, dbf, oBrw, hHash, bValid, nMode )

RETURN ( nil )

//---------------------------------------------------------------------------//

Static function startEdtTablet( nMode, aGet, oSayTextRuta )

   if ( nMode == APPD_MODE )
      changeRutaTablet( aGet, oSayTextRuta )
   end if

Return ( nil )
       
//---------------------------------------------------------------------------//

STATIC FUNCTION EdtDetTablet( aTmp, aGet, dbf, oBrw, lTotLin, cCodArtEnt, nMode, aTmpFac )

RETURN ( nil )

//---------------------------------------------------------------------------//

static function EdtResumenTablet( aTmp, aGet, nMode, oDlgFac )

RETURN ( nil )

//---------------------------------------------------------------------------//

Static Function priorClient( aGet, oSayTextRuta )

   oClienteRutaNavigator:gotoPrior( oSayTextRuta )

Return ( moveClient( aGet ) )

//---------------------------------------------------------------------------//

Static Function nextClient( aGet, oSayTextRuta )

   oClienteRutaNavigator:gotoNext( oSayTextRuta )

Return ( moveClient( aGet ) )

//---------------------------------------------------------------------------//

Static Function moveClient( aGet )

   if !empty( aGet[ _CCODCLI ] )
      aGet[ _CCODCLI ]:cText( oClienteRutaNavigator:getSelected() )
      aGet[ _CCODCLI ]:Refresh()
      aGet[ _CCODCLI ]:lValid()
      aGet[ _CCODOBR ]:cText( Space( 10 ) )
      aGet[ _CCODOBR ]:Refresh()
      aGet[ _CCODOBR ]:lValid()
   end if 

Return ( nil )

//---------------------------------------------------------------------------//

static function changeRutaTablet( aGet, oSayTextRuta )

   local cOrder  

   if hhaskey( hOrdenRutas, AllTrim( Str( oCbxRuta:nAt ) ) )

      cOrder      := hOrdenRutas[ AllTrim( Str( oCbxRuta:nAt ) ) ]

      oClienteRutaNavigator:getClientesRutas( cOrder, oSayTextRuta ) 

      oClienteRutaNavigator:gotoLastProcesed( oSayTextRuta )

      moveClient( aGet )

   end if 

Return ( nil )

//---------------------------------------------------------------------------//

static function ChangeSerieTablet( aGet )

   local cSerie   := aGet[ _CSERIE ]:VarGet()

   do case
      case cSerie == "A"
         if !empty( aGet[ _CSERIE ] )
            aGet[ _CSERIE ]:cText( "B" )
         end if   

      case cSerie == "B"
         if !empty( aGet[ _CSERIE ] )
            aGet[ _CSERIE ]:cText( "C" )
         end if   

      case cSerie == "C"
         if !empty( aGet[ _CSERIE ] )
            aGet[ _CSERIE ]:cText( "A" )
         end if   

      otherwise
         if !empty( aGet[ _CSERIE ] )
            aGet[ _CSERIE ]:cText( "A" )
         end if   

   end case

   aGet[ _CSERIE ]:Refresh()

Return ( .t. )

//---------------------------------------------------------------------------//

static function cDocumentoDefecto( cSerie, aCbxOrd )

   local cDocumento     := ""
   local cFormato       := cFormatoFacturasClientes( cSerie ) 
   local nFormato       := aScan( aCbxOrd, {|x| Left( x, 3 ) == cFormato } )
   nFormato             := Max(Min(nFormato,len(aCbxOrd)),1)

return aCbxOrd[ nFormato ]

//---------------------------------------------------------------------------//

Function FacCliTablet()

   local oDlg
   local oBrw
   local oSayGeneral
   local nAltoGet        := 23
   local oBtnSalir
   local oGetSearch
   local cGetSearch      := Space( 100 )
   local oCbxOrd
   local aCbxOrd         := { "Número", "Fecha", "Código", "Nombre" }
   local cCbxOrd         := "Número"
   local oBtnAdd
   local oBtnEdt
   local oBtnDel
   local oBtnUp
   local oBtnDown
   local oBtnUpPage
   local oBtnDownPage
   local cCodigoAgente     := AccessCode():cAgente

   // Abrimos los ficheros-------------------------------------------------------

   if !OpenFiles( .t. )
      Return .f.
   end if

   ( D():FacturasClientes( nView ) )->( OrdSetFocus( "dFecDes" ) )
   ( D():FacturasClientes( nView ) )->( dbGoTop() )

   if !empty(cCodigoAgente)
      ( D():FacturasClientes( nView ) )->( dbsetfilter( {|| Field->cCodAge == cCodigoAgente }, "cCodAge == cCodigoAgente" ) )
      ( D():FacturasClientes( nView ) )->( dbgotop() )
   end if 

   /*
   Di-logo--------------------------------------------------------------------
   */

   oDlg                 := TDialog():New( 1, 5, 40, 100, "GESTOOL TABLET",,, .f., nOR( DS_MODALFRAME, WS_POPUP, WS_CAPTION, WS_SYSMENU, WS_MINIMIZEBOX, WS_MAXIMIZEBOX ),, rgb( 255, 255, 255 ),,, .F.,, oGridFont(),,,, .f.,, "oDlg" )  

   /*
   Cabeceras------------------------------------------------------------------
   */

     oSayGeneral        := TGridSay():Build(    {  "nRow"      => 0,;
                                                   "nCol"      => {|| GridWidth( 0.5, oDlg ) },;
                                                   "bText"     => {|| "Facturas de clientes" },;
                                                   "oWnd"      => oDlg,;
                                                   "oFont"     => oGridFontBold(),;
                                                   "lPixels"   => .t.,;
                                                   "nClrText"  => Rgb( 0, 0, 0 ),;
                                                   "nClrBack"  => Rgb( 255, 255, 255 ),;
                                                   "nWidth"    => {|| GridWidth( 8, oDlg ) },;
                                                   "nHeight"   => 32,;
                                                   "lDesign"   => .f. } )

      oBtnSalir         := TGridImage():Build(  {  "nTop"      => 5,;
                                                   "nLeft"     => {|| GridWidth( 10.5, oDlg ) },;
                                                   "nWidth"    => 64,;
                                                   "nHeight"   => 64,;
                                                   "cResName"  => "flat_end_64",;
                                                   "bLClicked" => {|| oDlg:End() },;
                                                   "oWnd"      => oDlg } )

      /*
      Texto de busqueda----------------------------------------------------------
      */

      oGetSearch        := TGridGet():Build(    {  "nRow"      => 45,;
                                                   "nCol"      => {|| GridWidth( 0.5, oDlg ) },;
                                                   "bSetGet"   => {|u| if( PCount() == 0, cGetSearch, cGetSearch := u ) },;
                                                   "oWnd"      => oDlg,;
                                                   "nWidth"    => {|| GridWidth( 9, oDlg ) },;
                                                   "nHeight"   => 25,;
                                                   "bValid"    => {|| OrdClearScope( oBrw, D():FacturasClientes( nView ) ) },;
                                                   "bChanged"  => {| nKey, nFlags, Self | AutoSeek( nKey, nFlags, Self, oBrw, D():FacturasClientes( nView ), .t. ) } } )

      /*
   Orden----------------------------------------------------------------------
      */

      oCbxOrd           := TGridComboBox():Build({ "nRow"      => 45,;
                                                   "nCol"      => {|| GridWidth( 9.5, oDlg ) },;
                                                   "bSetGet"   => {|u| if( PCount() == 0, cCbxOrd, cCbxOrd := u ) },;
                                                   "oWnd"      => oDlg,;
                                                   "nWidth"    => {|| GridWidth( 2, oDlg ) },;
                                                   "nHeight"   => 25,;
                                                   "aItems"    => aCbxOrd,;
                                                   "bChange"   => {| nKey, nFlags, Self | ( D():FacturasClientes( nView ) )->( OrdSetFocus( oCbxOrd:nAt ) ), oGetSearch:SetFocus() } } )
   
   /*
   Botones de las lineas------------------------------------------------------
      */

      oBtnAdd           := TGridImage():Build(  {  "nTop"      => 75,;
                                                   "nLeft"     => {|| GridWidth( 0.5, oDlg ) },;
                                                   "nWidth"    => 64,;
                                                   "nHeight"   => 64,;
                                                   "cResName"  => "flat_add_64",;
                                                   "bLClicked" => {|| WinAppRec( nil, bEdtTablet, D():FacturasClientes( nView ) ) },;
                                                   "oWnd"      => oDlg } )

      oBtnEdt           := TGridImage():Build(  {  "nTop"      => 75,;
                                                   "nLeft"     => {|| GridWidth( 2, oDlg ) },;
                                                   "nWidth"    => 64,;
                                                   "nHeight"   => 64,;
                                                   "cResName"  => "flat_edit_64",;
                                                   "bLClicked" => {|| WinEdtRec( nil, bEdtTablet, D():FacturasClientes( nView ) ) },;
                                                   "oWnd"      => oDlg } )

      if .f. //oUser():lMaster()
      oBtnDel           := TGridImage():Build(  {  "nTop"      => 75,;
                                                   "nLeft"     => {|| GridWidth( 3.5, oDlg ) },;
                                                   "nWidth"    => 64,;
                                                   "nHeight"   => 64,;
                                                   "cResName"  => "flat_minus_64",;
                                                   "bLClicked" => {|| WinDelRec( oBrw, D():FacturasClientes( nView ), {|| QuiFacCli() }, , , .t. ) },;
                                                   "oWnd"      => oDlg } )
      end if

      oBtnUpPage        := TGridImage():Build(  {  "nTop"      => 75,;
                                                   "nLeft"     => {|| GridWidth( 7.5, oDlg ) },;
                                                   "nWidth"    => 64,;
                                                   "nHeight"   => 64,;
                                                   "cResName"  => "flat_page_up_64",;
                                                   "bLClicked" => {|| oBrw:PageUp(), oBrw:Select( 0 ), oBrw:Select( 1 ), oBrw:Refresh()  },;
                                                   "oWnd"      => oDlg } )

      oBtnUp         := TGridImage():Build(  {     "nTop"      => 75,;
                                                   "nLeft"     => {|| GridWidth( 8.5, oDlg ) },;
                                                   "nWidth"    => 64,;
                                                   "nHeight"   => 64,;
                                                   "cResName"  => "flat_up_64",;
                                                   "bLClicked" => {|| oBrw:GoUp(), oBrw:Select( 0 ), oBrw:Select( 1 ), oBrw:Refresh()  },;
                                                   "oWnd"      => oDlg } )

      oBtnDown          := TGridImage():Build(  {  "nTop"      => 75,;
                                                   "nLeft"     => {|| GridWidth( 9.5, oDlg ) },;
                                                   "nWidth"    => 64,;
                                                   "nHeight"   => 64,;
                                                   "cResName"  => "flat_down_64",;
                                                   "bLClicked" => {|| oBrw:GoDown(), oBrw:Select( 0 ), oBrw:Select( 1 ), oBrw:Refresh() },;
                                                   "oWnd"      => oDlg } )

      oBtnDownPage      := TGridImage():Build(  {  "nTop"      => 75,;
                                                   "nLeft"     => {|| GridWidth( 10.5, oDlg ) },;
                                                   "nWidth"    => 64,;
                                                   "nHeight"   => 64,;
                                                   "cResName"  => "flat_page_down_64",;
                                                   "bLClicked" => {|| oBrw:PageDown(), oBrw:Select( 0 ), oBrw:Select( 1 ), oBrw:Refresh() },;
                                                   "oWnd"      => oDlg } ) 

   /*
   Browse de facturas-------------------------------------------------------
   */

      oBrw                    := TGridIXBrowse():New( oDlg )

      oBrw:nTop               := oBrw:EvalRow( 115 )
      oBrw:nLeft              := oBrw:EvalCol( {|| GridWidth( 0.5, oDlg ) } )
      oBrw:nWidth             := oBrw:EvalWidth( {|| GridWidth( 11, oDlg ) } )
      oBrw:nHeight            := oBrw:EvalHeight( {|| GridHeigth( oDlg ) - oBrw:nTop - 10 } )

      oBrw:cAlias             := D():FacturasClientes( nView )
      oBrw:nMarqueeStyle      := 6
      oBrw:cName              := "Grid facturas"

      with object ( oBrw:AddCol() )
         :cHeader            := "Factura"
        :bEditValue         := {|| ( D():FacturasClientes( nView ) )->cSerie + "/" + AllTrim( Str( ( D():FacturasClientes( nView ) )->nNumFac ) ) + CRLF + Dtoc( ( D():FacturasClientes( nView ) )->dFecFac ) }
        :nWidth             := 160
    end with

    with object ( oBrw:AddCol() )
         :cHeader            := "Cliente"
        :bEditValue         := {|| AllTrim( ( D():FacturasClientes( nView ) )->cCodCli ) + CRLF + AllTrim( ( D():FacturasClientes( nView ) )->cNomCli )  }
        :nWidth             := 320
    end with

    with object ( oBrw:AddCol() )
         :cHeader            := "Base"
        :bEditValue         := {|| ( D():FacturasClientes( nView ) )->nTotNet  }
        :cEditPicture      := cPorDiv()
        :nWidth             := 80
        :nDataStrAlign     := 1
        :nHeadStrAlign     := 1
        :lHide             := .t.
    end with

    with object ( oBrw:AddCol() )
         :cHeader            := cImp()
        :bEditValue         := {|| ( D():FacturasClientes( nView ) )->nTotIva  }
        :cEditPicture      := cPorDiv()
        :nWidth             := 80
        :nDataStrAlign     := 1
        :nHeadStrAlign     := 1
        :lHide             := .t.
    end with

    with object ( oBrw:AddCol() )
         :cHeader            := "R.E."
         :bEditValue         := {|| ( D():FacturasClientes( nView ) )->nTotReq  }
         :cEditPicture        := cPorDiv()
         :nWidth             := 80
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
         :lHide               := .t.
    end with

    with object ( oBrw:AddCol() )
         :cHeader            := "Total"
        :bEditValue         := {|| ( D():FacturasClientes( nView ) )->nTotFac }
        :cEditPicture      := cPorDiv()
        :nWidth             := 190
        :nDataStrAlign     := 1
        :nHeadStrAlign     := 1
    end with

      oBrw:nHeaderHeight      := 48
      oBrw:nFooterHeight      := 48
      oBrw:nRowHeight         := 96
      oBrw:nDataLines         := 2

      oBrw:bLDblClick         := {|| WinEdtRec( nil, bEdtTablet, D():FacturasClientes( nView ) ) }

      oBrw:CreateFromCode( 105 )

      /*
   Redimensionamos y activamos el di-logo-------------------------------------
   */

      oDlg:bResized              := {|| GridResize( oDlg ) }

      ACTIVATE DIALOG oDlg CENTER ON INIT ( GridMaximize( oDlg ) )
   
    /*
   Cerramos los ficheros------------------------------------------------------
    */

    CloseFiles()

RETURN .t.

//---------------------------------------------------------------------------//

STATIC FUNCTION PrnSerie()

   local oDlg
   local oFmtDoc
   local cFmtDoc     := cFormatoFacturasClientes()
   local oRango
   local nRango      := 1
   local oSayFmt
   local cSayFmt
   local oSerIni
   local oSerFin
   local cSerIni     := ( D():FacturasClientes( nView ) )->cSerie
   local cSerFin     := ( D():FacturasClientes( nView ) )->cSerie
   local oDocIni
   local oDocFin
   local nDocIni     := ( D():FacturasClientes( nView ) )->nNumFac
   local nDocFin     := ( D():FacturasClientes( nView ) )->nNumFac
   local cSufIni     := ( D():FacturasClientes( nView ) )->cSufFac
   local cSufFin     := ( D():FacturasClientes( nView ) )->cSufFac
   local oPrinter
   local cPrinter    := PrnGetName()
   local lCopiasPre  := .t.
   local lInvOrden   := .f.
   local dFecDesde   := CtoD( "01/01/" + str( Year( Date() ) ) )
   local dFecHasta   := Date()
   local oNumCop
   local nNumCop     := if( nCopiasDocumento( (D():FacturasClientes( nView ))->cSerie, "nFacCli", D():Contadores( nView ) ) == 0, Max( Retfld( ( D():FacturasClientes( nView ) )->cCodCli, D():Clientes( nView ), "CopiasF" ), 1 ), nCopiasDocumento( (D():FacturasClientes( nView ))->cSerie, "nFacCli", D():Contadores( nView ) ) )

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

   REDEFINE GET oDocIni VAR nDocIni;
      ID       120 ;
      PICTURE  "999999999" ;
      SPINNER ;
      WHEN     ( nRango == 1 );
      OF       oDlg

   REDEFINE GET oDocFin VAR nDocFin;
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
      VALID    ( cDocumento( oFmtDoc, oSayFmt, D():Documentos( nView ) ) ) ;
      BITMAP   "LUPA" ;
      ON HELP  ( BrwDocumento( oFmtDoc, oSayFmt, "FC" ) ) ;
      OF       oDlg

   REDEFINE GET oSayFmt VAR cSayFmt ;
      ID       91 ;
      WHEN     ( .f. );
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
      ACTION   (  StartPrint( Substr( cFmtDoc, 1, 3 ), cSerIni + str( nDocIni, 9 ) + cSufIni, cSerFin + str( nDocFin, 9 ) + cSufFin, oDlg, nil, lCopiasPre, nNumCop, lInvOrden, nRango, dFecDesde, dFecHasta ),;
                  oDlg:end( IDOK ) )

   REDEFINE BUTTON ;
      ID       IDCANCEL ;
      OF       oDlg ;
      CANCEL ;
      ACTION   ( oDlg:end() )

   oDlg:AddFastKey( VK_F5, {|| StartPrint( Substr( cFmtDoc, 1, 3 ), cSerIni + str( nDocIni, 9 ) + cSufIni, cSerFin + str( nDocFin, 9 ) + cSufFin, oDlg, nil, lCopiasPre, nNumCop, lInvOrden, nRango, dFecDesde, dFecHasta ), oDlg:end( IDOK ) } )

   oDlg:bStart := { || oSerIni:SetFocus() }

   ACTIVATE DIALOG oDlg CENTER

   oWndBrw:oBrw:refresh()

RETURN NIL

//--------------------------------------------------------------------------//

STATIC FUNCTION StartPrint( cFmtDoc, cDocIni, cDocFin, oDlg, cPrinter, lCopiasPre, nNumCop, lInvOrden, nRango, dFecDesde, dFecHasta )

   local nCopyClient
   local nRecno
   local nOrdAnt

   oDlg:Disable()

   if nRango == 1

      nRecno      := ( D():FacturasClientes( nView ) )->( recno() )
      nOrdAnt     := ( D():FacturasClientes( nView ) )->( OrdSetFocus( "nNumFac" ) )

      if !lInvOrden

         ( D():FacturasClientes( nView ) )->( dbSeek( cDocIni, .t. ) )

         while ( D():FacturasClientes( nView ) )->cSerie + str( ( D():FacturasClientes( nView ) )->nNumFac ) + ( D():FacturasClientes( nView ) )->cSufFac >= cDocIni .and. ;
               ( D():FacturasClientes( nView ) )->cSerie + str( ( D():FacturasClientes( nView ) )->nNumFac ) + ( D():FacturasClientes( nView ) )->cSufFac <= cDocFin

               lChgImpDoc( D():FacturasClientes( nView ) )

            if lCopiasPre

               nCopyClient := if( nCopiasDocumento( ( D():FacturasClientes( nView ) )->cSerie, "nFacCli", D():Contadores( nView ) ) == 0, Max( Retfld( ( D():FacturasClientes( nView ) )->cCodCli, D():Clientes( nView ), "CopiasF" ), 1 ), nCopiasDocumento( ( D():FacturasClientes( nView ) )->cSerie, "nFacCli", D():Contadores( nView ) ) )

               GenFacCli( IS_PRINTER, "Imprimiendo documento : " + ( D():FacturasClientes( nView ) )->cSerie + str( ( D():FacturasClientes( nView ) )->nNumFac ) + ( D():FacturasClientes( nView ) )->cSufFac, cFmtDoc, cPrinter,  )

            else

               GenFacCli( IS_PRINTER, "Imprimiendo documento : " + ( D():FacturasClientes( nView ) )->cSerie + str( ( D():FacturasClientes( nView ) )->nNumFac ) + ( D():FacturasClientes( nView ) )->cSufFac, cFmtDoc, cPrinter, nNumCop )

            end if

            ( D():FacturasClientes( nView ) )->( dbSkip() )

         end while

      else

         ( D():FacturasClientes( nView ) )->( dbSeek( cDocFin, .t. ) )

         while ( D():FacturasClientes( nView ) )->cSerie + str( ( D():FacturasClientes( nView ) )->nNumFac ) + ( D():FacturasClientes( nView ) )->cSufFac >= cDocIni .and. ;
               ( D():FacturasClientes( nView ) )->cSerie + str( ( D():FacturasClientes( nView ) )->nNumFac ) + ( D():FacturasClientes( nView ) )->cSufFac <= cDocFin .and. ;
               !( D():FacturasClientes( nView ) )->( Bof() )

            lChgImpDoc( D():FacturasClientes( nView ) )

            if lCopiasPre

               GenFacCli( IS_PRINTER, "Imprimiendo documento : " + ( D():FacturasClientes( nView ) )->cSerie + str( ( D():FacturasClientes( nView ) )->nNumFac ) + ( D():FacturasClientes( nView ) )->cSufFac, cFmtDoc, cPrinter )

            else

               GenFacCli( IS_PRINTER, "Imprimiendo documento : " + ( D():FacturasClientes( nView ) )->cSerie + str( ( D():FacturasClientes( nView ) )->nNumFac ) + ( D():FacturasClientes( nView ) )->cSufFac, cFmtDoc, cPrinter, nNumCop )

            end if

            ( D():FacturasClientes( nView ) )->( dbSkip( -1 ) )

         end while

      end if

   else

      nRecno      := ( D():FacturasClientes( nView ) )->( recno() )
      nOrdAnt     := ( D():FacturasClientes( nView ) )->( OrdSetFocus( "DFECFAC" ) )

      if !lInvOrden

         ( D():FacturasClientes( nView ) )->( dbGoTop() )

         while !( D():FacturasClientes( nView ) )->( Eof() ) 

            if ( D():FacturasClientes( nView ) )->dFecFac >= dFecDesde .and. ( D():FacturasClientes( nView ) )->dFecFac <= dFecHasta

               lChgImpDoc( D():FacturasClientes( nView ) ) 

               if lCopiasPre

                  nCopyClient := if( nCopiasDocumento( ( D():FacturasClientes( nView ) )->cSerie, "nFacCli", D():Contadores( nView ) ) == 0, Max( Retfld( ( D():FacturasClientes( nView ) )->cCodCli, D():Clientes( nView ), "CopiasF" ), 1 ), nCopiasDocumento( ( D():FacturasClientes( nView ) )->cSerie, "nFacCli", D():Contadores( nView ) ) )

                  GenFacCli( IS_PRINTER, "Imprimiendo documento : " + ( D():FacturasClientes( nView ) )->cSerie + str( ( D():FacturasClientes( nView ) )->nNumFac ) + ( D():FacturasClientes( nView ) )->cSufFac, cFmtDoc, cPrinter  )

               else

                  GenFacCli( IS_PRINTER, "Imprimiendo documento : " + ( D():FacturasClientes( nView ) )->cSerie + str( ( D():FacturasClientes( nView ) )->nNumFac ) + ( D():FacturasClientes( nView ) )->cSufFac, cFmtDoc, cPrinter, nNumCop )

               end if

            end if   

            ( D():FacturasClientes( nView ) )->( dbSkip() )

         end while

      else 

         ( D():FacturasClientes( nView ) )->( dbGoBottom() )

         while !( D():FacturasClientes( nView ) )->( Bof() )

            if ( D():FacturasClientes( nView ) )->dFecFac >= dFecDesde .and. ( D():FacturasClientes( nView ) )->dFecFac <= dFecHasta

               lChgImpDoc( D():FacturasClientes( nView ) )

               if lCopiasPre

                  GenFacCli( IS_PRINTER, "Imprimiendo documento : " + ( D():FacturasClientes( nView ) )->cSerie + str( ( D():FacturasClientes( nView ) )->nNumFac ) + ( D():FacturasClientes( nView ) )->cSufFac, cFmtDoc, cPrinter  )

               else

                  GenFacCli( IS_PRINTER, "Imprimiendo documento : " + ( D():FacturasClientes( nView ) )->cSerie + str( ( D():FacturasClientes( nView ) )->nNumFac ) + ( D():FacturasClientes( nView ) )->cSufFac, cFmtDoc, cPrinter, nNumCop )

               end if

            end if

            ( D():FacturasClientes( nView ) )->( dbSkip( -1 ) )

         end while

      end if
   
   end if   

   ( D():FacturasClientes( nView ) )->( dbGoTo( nRecNo ) )
   ( D():FacturasClientes( nView ) )->( ordSetFocus( nOrdAnt ) )

   oDlg:Enable()

RETURN NIL

//--------------------------------------------------------------------------//

/*
Crea un movimiento para liquidar la factura
*/

STATIC FUNCTION lLiquida( oBrw, cFactura )

   DEFAULT cFactura  := ( D():FacturasClientes( nView ) )->cSerie + str( ( D():FacturasClientes( nView ) )->nNumFac ) + ( D():FacturasClientes( nView ) )->cSufFac

   if ( D():FacturasClientes( nView ) )->lLiquidada
      msgStop( "Factura ya cobrada", "Imposible añadir cobros" )
      return .f.
   end if

   /*
   Comporbamos si existen recibos de esta factura------------------------------
   */

   if ( D():FacturasClientesCobros( nView ) )->( dbSeek( cFactura ) )

      while ( D():FacturasClientesCobros( nView ) )->cSerie + str( ( D():FacturasClientesCobros( nView ) )->nNumFac ) + ( D():FacturasClientesCobros( nView ) )->cSufFac == cFactura .and. !( D():FacturasClientesCobros( nView ) )->( eof() )

         if empty( ( D():FacturasClientesCobros( nView ) )->cTipRec ) .and. !( D():FacturasClientesCobros( nView ) )->lCobrado

            EdtRecCli( ( D():FacturasClientesCobros( nView ) )->cSerie + str( ( D():FacturasClientesCobros( nView ) )->nNumFac ) + ( D():FacturasClientesCobros( nView ) )->cSufFac + str( ( D():FacturasClientesCobros( nView ) )->nNumRec ) + ( D():FacturasClientesCobros( nView ) )->cTipRec, .f. )

            exit

         end if

         ( D():FacturasClientesCobros( nView ) )->( dbSkip() )

      end do

   end if

   /*
   Chekea el estado de la factura---------------------------------------------
   */

   ChkLqdFacCli( nil, D():FacturasClientes( nView ), D():FacturasClientesLineas( nView ), D():FacturasClientesCobros( nView ), D():AnticiposClientes( nView ), dbfIva, dbfDiv, .f. )

   /*
   Informaci-n para el Auditor-------------------------------------------------
   */

   if !empty( oAuditor() )
      oAuditor():AddEvent( LIQUIDA_FACTURA_CLIENTES, ( D():FacturasClientes( nView ) )->cSerie + str( ( D():FacturasClientes( nView ) )->nNumFac ) + ( D():FacturasClientes( nView ) )->cSufFac, FAC_CLI )
   end if

   oBrw:Refresh()
   oBrw:SetFocus()

Return .t.

//---------------------------------------------------------------------------//

Static Function lChgContabilizado( lContabilizado )

   if ( D():FacturasClientes( nView ) )->( dbRLock() )
      ( D():FacturasClientes( nView ) )->lContab  := lContabilizado
      ( D():FacturasClientes( nView ) )->cConGuid := ""
      ( D():FacturasClientes( nView ) )->lSndDoc  := !( D():FacturasClientes( nView ) )->lSndDoc
      ( D():FacturasClientes( nView ) )->dFecCre  := Date()
      ( D():FacturasClientes( nView ) )->cTimCre  := Time()
      ( D():FacturasClientes( nView ) )->( dbUnlock() )
   end if

Return .t.

//---------------------------------------------------------------------------//

/*
Importa desde un albaran
*/

STATIC FUNCTION cAlbCli( aGet, aTmp, oBrwLin, oBrwPgo, nMode )

   local cDesAlb
   local lValid      := .f.
   local cAlbaran    := aGet[ _CNUMALB ]:varGet()
   local aAlbCliT
   local aAlbCliL
   local nTotEntAlb  := 0
   local cSuPed      := ""

   if ( nMode != APPD_MODE .or. empty( cAlbaran ) )
      return .t.
   end if

   aAlbCliT          := aGetStatus( dbfAlbCliT, .t. )
   aAlbCliL          := aGetStatus( dbfAlbCliL, .t. )

   if ( dbfAlbCliT )->( dbSeek( cAlbaran ) )

      if lFacturado( dbfAlbCliT )

         MsgStop( "albarán facturado" )

      else

         CursorWait()

         aGet[ _CSERIE  ]:cText( ( dbfAlbCliT )->cSerAlb )

         aGet[ _CCODCLI ]:cText( ( dbfAlbCliT )->cCodCli )
         aGet[ _CCODCLI ]:bWhen    := {|| .f. }
         aGet[ _CCODCLI ]:lValid()

         aGet[ _CNOMCLI ]:cText( ( dbfAlbCliT )->cNomCli )
         aGet[ _CDIRCLI ]:cText( ( dbfAlbCliT )->cDirCli )
         aGet[ _CPOBCLI ]:cText( ( dbfAlbCliT )->cPobCli )
         aGet[ _CPRVCLI ]:cText( ( dbfAlbCliT )->cPrvCli )
         aGet[ _CPOSCLI ]:cText( ( dbfAlbCliT )->cPosCli )
         aGet[ _CDNICLI ]:cText( ( dbfAlbCliT )->cDniCli )
         aGet[ _CTLFCLI ]:cText( ( dbfAlbCliT )->cTlfCli )

         aGet[ _CCODALM ]:cText( ( dbfAlbCliT )->cCodAlm )
         aGet[ _CCODALM ]:lValid()

         aGet[ _CCODCAJ ]:cText( ( dbfAlbCliT )->cCodCaj )
         aGet[ _CCODCAJ ]:lValid()

         aGet[ _CCODPAGO ]:cText( ( dbfAlbCliT )->cCodPago )
         aGet[ _CCODPAGO ]:lValid()

         aGet[ _CCODAGE ]:cText( ( dbfAlbCliT )->cCodAge )
         aGet[ _CCODAGE ]:lValid()

         aGet[ _NPCTCOMAGE ]:cText( ( dbfAlbCliT )->nPctComAge )

         aGet[ _CCODTAR ]:cText( ( dbfAlbCliT )->CCODTAR )
         aGet[ _CCODTAR ]:lValid()

         aGet[ _CCODRUT ]:cText( ( D():Clientes( nView ) )->CCODRUT )
         aGet[ _CCODRUT ]:lValid()

         aGet[ _CCODOBR ]:cText( ( dbfAlbCliT )->CCODOBR )
         aGet[ _CCODOBR ]:lValid()

         aGet[ _CCODTRN ]:cText( ( dbfAlbCliT )->cCodTrn )
         aGet[ _CCODTRN ]:lValid()

         aGet[ _CCENTROCOSTE ]:cText( ( dbfAlbCliT )->cCtrCoste )
         aGet[ _CCENTROCOSTE ]:lValid()

         aGet[ _LIVAINC  ]:Click( ( dbfAlbCliT )->lIvaInc )
         aGet[ _LRECARGO ]:Click( ( dbfAlbCliT )->lRecargo )
         aGet[ _LOPERPV  ]:Click( ( dbfAlbCliT )->lOperPv )
         aGet[ _LRECC    ]:Click( lRECCEmpresa() )

         /*
         Pasamos los comentarios
         */

         aGet[ _CCONDENT ]:cText( ( dbfAlbCliT )->cCondEnt )
         aGet[ _MCOMENT  ]:cText( ( dbfAlbCliT )->mComent )
         aGet[ _MOBSERV  ]:cText( ( dbfAlbCliT )->mObserv )
         aGet[ _CSUFAC   ]:cText( ( dbfAlbCliT )->cSuPed  )

         /*
         Pasamos todos los Descuentos
         */

         aGet[ _CDTOESP  ]:cText( ( dbfAlbCliT )->cDtoEsp )
         aGet[ _CDPP     ]:cText( ( dbfAlbCliT )->cDpp    )
         aGet[ _NDTOESP  ]:cText( ( dbfAlbCliT )->nDtoEsp )
         aGet[ _NDPP     ]:cText( ( dbfAlbCliT )->nDpp    )
         aGet[ _CDTOUNO  ]:cText( ( dbfAlbCliT )->cDtoUno )
         aGet[ _NDTOUNO  ]:cText( ( dbfAlbCliT )->nDtoUno )
         aGet[ _CDTODOS  ]:cText( ( dbfAlbCliT )->cDtoDos )
         aGet[ _NDTODOS  ]:cText( ( dbfAlbCliT )->nDtoDos )
         aGet[ _CMANOBR  ]:cText( ( dbfAlbCliT )->cManObr )
         aGet[ _NIVAMAN  ]:cText( ( dbfAlbCliT )->nIvaMan )
         aGet[ _NMANOBR  ]:cText( ( dbfAlbCliT )->nManObr )
         aGet[ _NBULTOS  ]:cText( ( dbfAlbCliT )->nBultos )
         aGet[ _CRETPOR  ]:cText( ( dbfAlbCliT )->cRetPor )
         aGet[ _CRETMAT  ]:cText( ( dbfAlbCliT )->cRetMat )

         aTmp[ _CCODGRP ]              := ( dbfAlbCliT )->cCodGrp
         aTmp[ _LMODCLI ]              := ( dbfAlbCliT )->lModCli
         aTmp[ _LOPERPV ]              := ( dbfAlbCliT )->lOperPv
         aTmp[ _CNUMPRE ]              := ( dbfAlbCliT )->cNumPre

         cSuPed                        := ( dbfAlbCliT )->cSuPed

         /*
         Datos de alquileres---------------------------------------------------
         */

         aTmp[ _LALQUILER ]            := ( dbfAlbCliT )->lAlquiler
         aTmp[ _DFECENTR  ]            := ( dbfAlbCliT )->dFecEntr
         aTmp[ _DFECSAL   ]            := ( dbfAlbCliT )->dFecSal

         if !empty( oTipFac )
            if aTmp[ _LALQUILER ]
               oTipFac:Select( 2 )
            else
               oTipFac:Select( 1 )
            end if
         end if

         /*
         Su albarán------------------------------------------------------------
         */

         aTmp[ _CSUALB ]               := ( dbfAlbCliT )->cCodSuAlb

         /*
         Comprobamos si el albaran tiene lineas de detalle
         */

         if ( dbfAlbCliL )->( dbSeek( cAlbaran ) )

            if lNumAlb() .OR. lSuAlb()
               ( dbfTmpLin )->( dbAppend() )
               cDesAlb                 := ""
               cDesAlb                 += If( lNumObr(), Rtrim( cNumObr() ) + " " + rtrim( (dbfAlbCliT)->CCODOBR ), "" )
               cDesAlb                 += If( lNumAlb(), Rtrim( cNumAlb() ) + " " + rtrim( (dbfAlbCliT)->CSERALB + "/" + AllTrim( str( (dbfAlbCliT)->NNUMALB ) ) + "/" + (dbfAlbCliT)->CSUFALB ), "" )
               cDesAlb                 += If( lSuAlb(),  Rtrim( cSuAlb()  ) + " " + rtrim( (dbfAlbCliT)->CCODSUALB ), "" )
               cDesAlb                 += " - Fecha " + Dtoc( (dbfAlbCliT)->DFECALB )
               (dbfTmpLin)->cDetalle   := cDesAlb
               (dbfTmpLin)->lControl   := .t.
            end if

            /*
            A-ade lineas de Albaran a la Factura
            */

            while ( ( dbfAlbCliL )->cSerAlb + str( ( dbfAlbCliL )->nNumAlb ) + ( dbfAlbCliL )->cSufAlb == cAlbaran .and. !( dbfAlbCliL )->( eof() ) )
               
              appendRegisterByHash( dbfAlbCliL, dbfTmpLin, { "cSerie" => Space(1),;
                                                             "nNumFac" => 0,;
                                                             "cSuPed" => cSuPed,;
                                                             "dFecFac" => ( dbfAlbCliL )->dFecAlb,;
                                                             "tFecFac" => ( dbfAlbCliL )->tFecAlb,;
                                                             "cCodObr" => ( dbfAlbCliL )->cObrLin } )
               
                  ( dbfAlbCliL )->( dbSkip() )

            end while

            /*
            No permitimos mas Facturas----------------------------------------
            */

            HideImportacion( aGet, aGet[ _CNUMALB ] )

            /*
            Guardamos el numero del Albaran pos si no guardamos la factura-----
            */

            if aScan( aNumAlb, cAlbaran ) == 0
               aAdd( aNumAlb, cAlbaran )
            end if

         else

            MsgStop( "albarán no contiene lineas de detalle." )

         end if

         ( dbfTmpLin )->( dbGoTop() )

         /*
         Pasamos todas las series----------------------------------------------
         */

         if ( dbfAlbCliS )->( dbSeek( cAlbaran ) )

            while ( dbfAlbCliS )->cSerAlb + str( ( dbfAlbCliS )->nNumAlb ) + ( dbfAlbCliS )->cSufAlb == cAlbaran .and. !( dbfAlbCliS )->( Eof() )

               ( dbfTmpSer )->( dbAppend() )
               ( dbfTmpSer )->nNumLin  := ( dbfAlbCliS )->nNumLin
               ( dbfTmpSer )->cRef     := ( dbfAlbCliS )->cRef
               ( dbfTmpSer )->cAlmLin  := ( dbfAlbCliS )->cAlmLin
               ( dbfTmpSer )->cNumSer  := ( dbfAlbCliS )->cNumSer

               ( dbfAlbCliS )->( dbSkip() )

            end while

         end if

         if uFieldEmpresa( "lGrpEnt" ) // agrupamos las entregas en una sola

            /*
            Sumamos todos los pagos--------------------------------------------
            */

            if ( dbfAlbCliP )->( dbSeek( cAlbaran ) )

               while ( dbfAlbCliP )->cSerAlb + str( ( dbfAlbCliP )->nNumAlb ) + ( dbfAlbCliP )->cSufAlb == cAlbaran .and. !( dbfAlbCliP )->( Eof() )

                  nTotEntAlb     += ( dbfAlbCliP )->nImporte

                  ( dbfAlbCliP )->( dbSkip() )

               end while

            end if

            ( dbfAlbCliP )->( dbGoTop() )

            /*
            Creamos un solo recibo con las entregas a cuenta-------------------
            */

            if nTotEntAlb != 0

               ( dbfTmpPgo )->( dbAppend() )

               ( dbfTmpPgo )->lCobrado := .t.
               ( dbfTmpPgo )->lConPgo  := .f.
               ( dbfTmpPgo )->lRecImp  := .f.
               ( dbfTmpPgo )->lRecDto  := .f.
               ( dbfTmpPgo )->nNumRec  := ( dbfTmpPgo )->( RecNo() )
               ( dbfTmpPgo )->cCodCaj  := ( dbfAlbCliT )->cCodCaj
               ( dbfTmpPgo )->cCodCli  := ( dbfAlbCliT )->cCodCli
               ( dbfTmpPgo )->cNomCli  := ( dbfAlbCliT )->cNomCli
               ( dbfTmpPgo )->dEntrada := ( dbfAlbCliT )->dFecAlb
               ( dbfTmpPgo )->dPreCob  := ( dbfAlbCliT )->dFecAlb
               ( dbfTmpPgo )->dFecVto  := ( dbfAlbCliT )->dFecAlb
               ( dbfTmpPgo )->nImporte := nTotEntAlb
               ( dbfTmpPgo )->nImpCob  := nTotEntAlb
               ( dbfTmpPgo )->cDivPgo  := ( dbfAlbCliT )->cDivAlb
               ( dbfTmpPgo )->nVdvPgo  := ( dbfAlbCliT )->nVdvAlb
               ( dbfTmpPgo )->cCodAge  := ( dbfAlbCliT )->cCodAge
               ( dbfTmpPgo )->cTurRec  := ( dbfAlbCliT )->cTurAlb
               ( dbfTmpPgo )->lCloPgo  := .t.
               ( dbfTmpPgo )->cCodPgo  := ( dbfAlbCliT )->cCodPago
               ( dbfTmpPgo )->cDescrip := "Suma entregas a cuenta albarán: " + ( dbfAlbCliT )->cSerAlb + "/" + AllTrim( str( ( dbfAlbCliT )->nNumAlb ) ) + "/" + ( dbfAlbCliT )->cSufAlb
               ( dbfTmpPgo )->( dbUnLock() )

            end if

         else  // Pasamos las entregas una a una


            if ( dbfAlbCliP )->( dbSeek( cAlbaran ) )

               while ( dbfAlbCliP )->cSerAlb + str( ( dbfAlbCliP )->nNumAlb ) + ( dbfAlbCliP )->cSufAlb == cAlbaran .and. !( dbfAlbCliP )->( Eof() )

                  ( dbfTmpPgo )->( dbAppend() )

                  ( dbfTmpPgo )->nNumRec  := ( dbfTmpPgo )->( RecNo() )
                  ( dbfTmpPgo )->cCodCaj  := ( dbfAlbCliP )->cCodCaj
                  ( dbfTmpPgo )->cTurRec  := ( dbfAlbCliP )->cTurRec
                  ( dbfTmpPgo )->cCodCli  := ( dbfAlbCliP )->cCodCli
                  ( dbfTmpPgo )->dEntrada := ( dbfAlbCliP )->dEntrega
                  ( dbfTmpPgo )->dPreCob  := ( dbfAlbCliP )->dEntrega
                  ( dbfTmpPgo )->dFecVto  := ( dbfAlbCliP )->dEntrega
                  ( dbfTmpPgo )->nImporte := ( dbfAlbCliP )->nImporte
                  ( dbfTmpPgo )->nImpCob  := ( dbfAlbCliP )->nImporte
                  if !empty( ( dbfAlbCliP )->cDescrip )
                  ( dbfTmpPgo )->cDescrip := ( dbfAlbCliP )->cDescrip
                  else
                  ( dbfTmpPgo )->cDescrip := "Entrega n. " + AllTrim( str( ( dbfTmpPgo )->( RecNo() ) ) ) + " albarán " + ( dbfAlbCliP )->cSerAlb + "/" + AllTrim( str( ( dbfAlbCliP )->nNumAlb ) ) + "/" + ( dbfAlbCliP )->cSufAlb
                  end if
                  ( dbfTmpPgo )->cPgdoPor := ( dbfAlbCliP )->cPgdoPor
                  ( dbfTmpPgo )->cDocPgo  := ( dbfAlbCliP )->cDocPgo
                  ( dbfTmpPgo )->cDivPgo  := ( dbfAlbCliP )->cDivPgo
                  ( dbfTmpPgo )->nVdvPgo  := ( dbfAlbCliP )->nVdvPgo
                  ( dbfTmpPgo )->cCodAge  := ( dbfAlbCliP )->cCodAge
                  ( dbfTmpPgo )->cBncEmp  := ( dbfAlbCliP )->cBncEmp
                  ( dbfTmpPgo )->cBncCli  := ( dbfAlbCliP )->cBncCli
                  ( dbfTmpPgo )->cEntEmp  := ( dbfAlbCliP )->cEntEmp
                  ( dbfTmpPgo )->cSucEmp  := ( dbfAlbCliP )->cSucEmp
                  ( dbfTmpPgo )->cDigEmp  := ( dbfAlbCliP )->cDigEmp
                  ( dbfTmpPgo )->cCtaEmp  := ( dbfAlbCliP )->cCtaEmp
                  ( dbfTmpPgo )->cEntCli  := ( dbfAlbCliP )->cEntCli
                  ( dbfTmpPgo )->cSucCli  := ( dbfAlbCliP )->cSucCli
                  ( dbfTmpPgo )->cDigCli  := ( dbfAlbCliP )->cDigCli
                  ( dbfTmpPgo )->cCtaCli  := ( dbfAlbCliP )->cCtaCli
                  ( dbfTmpPgo )->lCobrado := .t.
                  ( dbfTmpPgo )->lConPgo  := .f.
                  ( dbfTmpPgo )->lRecImp  := .f.
                  ( dbfTmpPgo )->lRecDto  := .f.

                  ( dbfAlbCliP )->( dbSkip() )

               end while

            end if

         end if

         /*
         Pasamos las incidencias del albarán
         */

         if ( dbfAlbCliI )->( dbSeek( cAlbaran ) )

            while ( dbfAlbCliI )->cSerAlb + str( ( dbfAlbCliI )->nNumAlb ) + ( dbfAlbCliI )->cSufAlb == cAlbaran .and. !( dbfAlbCliI )->( Eof() )
               dbPass( dbfAlbCliI, dbfTmpInc, .t. )
               ( dbfAlbCliI )->( dbSkip() )
            end while

         end if

         /*
         Pasamos los documentos de los pedidos
         */

         if ( dbfAlbCliD )->( dbSeek( cAlbaran ) )

            while ( dbfAlbCliD )->cSerAlb + str( ( dbfAlbCliD )->nNumAlb ) + ( dbfAlbCliD )->cSufAlb == cAlbaran .and. !( dbfAlbCliD )->( Eof() )
               dbPass( dbfAlbCliD, dbfTmpDoc, .t. )
               ( dbfAlbCliD )->( dbSkip() )
            end while

         end if

         ( dbfAlbCliD )->( dbGoTop() )

         oBrwLin:Refresh()
         oBrwPgo:Refresh()

         oBrwLin:SetFocus()

         HideImportacion( aGet, aGet[ _CNUMALB ] )

         CursorWE()

      end if

   else

      MsgStop( "albarán : " + cAlbaran + " no encontrado" )

   end if

   SetStatus( dbfAlbCliT, aAlbCliT )
   SetStatus( dbfAlbCliL, aAlbCliL )

   if !empty( oBrwPgo )
      oBrwPgo:Refresh()
   end if

RETURN .T.

//--------------------------------------------------------------------------//
/*
Importa desde una factura de proveedor
*/

STATIC FUNCTION cFacPrv( cFacPrv, aGet, aTmp, oBrw, nMode )

   local aFacPrvT
   local aFacPrvL
   local aFacPrvS

   if nMode != APPD_MODE .OR. empty( cFacPrv )
      return .t.
   end if

   aFacPrvT          := aGetStatus( dbfFacPrvT, .t. )
   aFacPrvL          := aGetStatus( dbfFacPrvL, .t. )
   aFacPrvS          := aGetStatus( dbfFacPrvS, .t. )

   if ( dbfFacPrvT )->( dbSeek( cFacPrv ) )

      /*
      Metemos los datos de la cabecera-----------------------------------------
      */

      aGet[ _CCODALM ]:cText( ( dbfFacPrvT )->cCodAlm )
      aGet[ _CCODALM ]:lValid()
      aGet[ _CCODCAJ ]:cText( ( dbfFacPrvT )->cCodCaj )
      aGet[ _CCODCAJ ]:lValid()
      aGet[ _NBULTOS ]:cText( ( dbfFacPrvT )->nBultos )
      aGet[ _CCONDENT]:cText( ( dbfFacPrvT )->cCondEnt )
      aGet[ _MCOMENT ]:cText( ( dbfFacPrvT )->mComent )
      aGet[ _MOBSERV ]:cText( ( dbfFacPrvT )->cObserv )

      aTmp[ _CFACPRV ]                   := ( dbfFacPrvT )->cSerFac + str( ( dbfFacPrvT )->nNumFac ) + ( dbfFacPrvT )->cSufFac

      /*
      Pasamos las lineas de detalle-----------------------------------------
      */

      if ( dbfFacPrvL )->( dbSeek( cFacPrv ) )

         while ( ( dbfFacPrvL )->cSerFac + str( ( dbfFacPrvL )->nNumFac ) + ( dbfFacPrvL )->cSufFac == cFacPrv .and. !( dbfFacPrvL )->( eof() ) )

            if !( dbfFacPrvL )->lControl

               ( dbfTmpLin )->( dbAppend() )
               ( dbfTmpLin )->nNumLin     := ( dbfFacPrvL )->nNumLin
               ( dbfTmpLin )->nPosPrint   := ( dbfFacPrvL )->nPosPrint
               ( dbfTmpLin )->cRef        := ( dbfFacPrvL )->cRef
               ( dbfTmpLin )->cRefPrv     := ( dbfFacPrvL )->cRefPrv
               ( dbfTmpLin )->cDetalle    := ( dbfFacPrvL )->cDetalle
               ( dbfTmpLin )->mLngDes     := ( dbfFacPrvL )->mLngDes
               ( dbfTmpLin )->mNumSer     := ( dbfFacPrvL )->mNumSer
               ( dbfTmpLin )->nCanEnt     := ( dbfFacPrvL )->nCanEnt
               ( dbfTmpLin )->cUnidad     := ( dbfFacPrvL )->cUnidad
               ( dbfTmpLin )->nUniCaja    := ( dbfFacPrvL )->nUniCaja
               ( dbfTmpLin )->nIva        := ( dbfFacPrvL )->nIva
               ( dbfTmpLin )->nReq        := ( dbfFacPrvL )->nReq
               ( dbfTmpLin )->dFecha      := ( dbfFacPrvT )->dFecFac
               ( dbfTmpLin )->nCtlStk     := ( dbfFacPrvL )->nCtlStk
               ( dbfTmpLin )->cAlmLin     := ( dbfFacPrvL )->cAlmLin
               ( dbfTmpLin )->lIvaLin     := ( dbfFacPrvL )->lIvaLin
               ( dbfTmpLin )->cCodPr1     := ( dbfFacPrvL )->cCodPr1
               ( dbfTmpLin )->cCodPr2     := ( dbfFacPrvL )->cCodPr2
               ( dbfTmpLin )->cValPr1     := ( dbfFacPrvL )->cValPr1
               ( dbfTmpLin )->cValPr2     := ( dbfFacPrvL )->cValPr2
               ( dbfTmpLin )->nCosDiv     := ( dbfFacPrvL )->nPreUnit
               ( dbfTmpLin )->lKitArt     := ( dbfFacPrvL )->lKitArt
               ( dbfTmpLin )->lKitChl     := ( dbfFacPrvL )->lKitChl
               ( dbfTmpLin )->lKitPrc     := ( dbfFacPrvL )->lKitPrc
               ( dbfTmpLin )->lLote       := ( dbfFacPrvL )->lLote
               ( dbfTmpLin )->nLote       := ( dbfFacPrvL )->nLote
               ( dbfTmpLin )->cLote       := ( dbfFacPrvL )->cLote
               ( dbfTmpLin )->dFecCad     := ( dbfFacPrvL )->dFecCad
               ( dbfTmpLin )->cCodFam     := ( dbfFacPrvL )->cCodFam
               ( dbfTmpLin )->cGrpFam     := ( dbfFacPrvL )->cGrpFam
               ( dbfTmpLin )->cCodPrv     := ( dbfFacPrvT )->cCodPrv
               ( dbfTmpLin )->nNumMed     := ( dbfFacPrvL )->nNumMed
               ( dbfTmpLin )->nMedUno     := ( dbfFacPrvL )->nMedUno
               ( dbfTmpLin )->nMedDos     := ( dbfFacPrvL )->nMedDos
               ( dbfTmpLin )->nMedTre     := ( dbfFacPrvL )->nMedTre
               ( dbfTmpLin )->nFacCnv     := ( dbfFacPrvL )->nFacCnv
               ( dbfTmpLin )->mObsLin     := ( dbfFacPrvL )->mObsLin
               ( dbfTmpLin )->nBultos     := ( dbfFacPrvL )->nBultos
               ( dbfTmpLin )->cFormato    := ( dbfFacPrvL )->cFormato

            end if

            ( dbfFacPrvL )->( dbSkip() )

         end while

      else

         MsgStop( "La factura no contiene lineas de detalle." )

      end if

      ( dbfTmpLin )->( dbGoTop() )

      /*
      Pasamos todas las series----------------------------------------------
      */

      if ( dbfFacPrvS )->( dbSeek( cFacPrv ) )

         while ( dbfFacPrvS )->cSerFac + str( ( dbfFacPrvS )->nNumFac ) + ( dbfFacPrvS )->cSufFac == cFacPrv .and. !( dbfFacPrvS )->( Eof() )

            ( dbfTmpSer )->( dbAppend() )
            ( dbfTmpSer )->nNumLin  := ( dbfFacPrvS )->nNumLin
            ( dbfTmpSer )->cRef     := ( dbfFacPrvS )->cRef
            ( dbfTmpSer )->cAlmLin  := ( dbfFacPrvS )->cAlmLin
            ( dbfTmpSer )->cNumSer  := ( dbfFacPrvS )->cNumSer

            ( dbfFacPrvS )->( dbSkip() )

         end while

      end if

      /*
      Recalculamos los precios de los artículos y refrescamos el browse--------
      */

      RecFacCli( aTmp, .f. )

      oBrw:SetFocus()
      oBrw:Refresh()

      RecalculaTotal( aTmp )

   else

      MsgStop( "Factura : " + cFacPrv + " no encontrada" )

   end if

   SetStatus( dbfFacPrvT, aFacPrvT )
   SetStatus( dbfFacPrvL, aFacPrvL )
   SetStatus( dbfFacPrvS, aFacPrvS )

RETURN .T.

//---------------------------------------------------------------------------//

STATIC FUNCTION selectedGenFacCli( nDevice, cTitle, cCodigoDocumento )

   local nPos

   for each nPos in ( oWndBrw:oBrw:aSelected )

      ( D():FacturasClientes( nView ) )->( dbgoto( nPos ) )

      genFacCli( nDevice, cTitle, cCodigoDocumento )

      SysRefresh()

   next

RETURN NIL

//---------------------------------------------------------------------------//

static function lGenFacCli( oBrw, oBtn, nDevice )

   local bAction

   DEFAULT nDevice   := IS_PRINTER

   if empty( oBtn )
      return nil
   end if

   if !( D():Documentos( nView ) )->( dbSeek( "FC" ) )

      DEFINE BTNSHELL RESOURCE "GC_DOCUMENT_WHITE_" OF oWndBrw ;
            NOBORDER ;
            ACTION   ( msgStop( "No hay facturas de clientes predefinidas" ) );
            TOOLTIP  "No hay documentos" ;
            HOTKEY   "N";
            FROM     oBtn ;
            CLOSED ;
            LEVEL    ACC_EDIT

   else

      while ( D():Documentos( nView ) )->cTipo == "FC" .AND. !( D():Documentos( nView ) )->( eof() )

         bAction  := bGenFacCli( nDevice, "Imprimiendo facturas de clientes", ( D():Documentos( nView ) )->Codigo )

         oWndBrw:NewAt( "gc_document_white_", , , bAction, rtrim( ( D():Documentos( nView ) )->cDescrip ) , , , , , oBtn )

         ( D():Documentos( nView ) )->( dbSkip() )

      end do

   end if

   SysRefresh()

return nil

//---------------------------------------------------------------------------//

static function bGenFacCli( nDevice, cTitle, cCodDoc )

   local nDev  := by( nDevice )
   local cTit  := by( cTitle  )
   local cCod  := by( cCodDoc )
   local bGen  := {|| selectedGenFacCli( nDevice, cTit, cCod ) }

return ( bGen )

//---------------------------------------------------------------------------//

static function QuiFacCli()

   local nRec
   local nOrdAnt
   local cSerDoc
   local nNumDoc
   local cSufDoc
   local cNumPed
   local cNumAlb
   local cNumSat
   local cNumPre 

   if ( D():FacturasClientes( nView ) )->lCloFac .and. !oUser():lAdministrador()
      msgStop( "Solo puede eliminar facturas cerradas los administradores." )
      return .f.
   end if

   cSerDoc           := ( D():FacturasClientes( nView ) )->cSerie
   nNumDoc           := ( D():FacturasClientes( nView ) )->nNumFac
   cSufDoc           := ( D():FacturasClientes( nView ) )->cSufFac
   cNumPed           := ( D():FacturasClientes( nView ) )->cNumPed
   cNumAlb           := ( D():FacturasClientes( nView ) )->cNumAlb
   cNumSat           := ( D():FacturasClientes( nView ) )->cNumSat 
   cNumPre           := ( D():FacturasClientes( nView ) )->cNumPre

   TComercio:resetProductsToUpdateStocks()

   /*
   Eliminamos las lineas-------------------------------------------------------
   */

   nOrdAnt           := ( D():FacturasClientesLineas( nView ) )->( OrdSetFocus( "nNumFac" ) )
   while ( D():FacturasClientesLineas( nView ) )->( dbSeek( cSerDoc + str( nNumDoc ) + cSufDoc ) ) .and. !( D():FacturasClientesLineas( nView ) )->( eof() )
      
      TComercio:appendProductsToUpadateStocks( ( D():FacturasClientesLineas( nView ) )->cRef, nView )

      if dbLock( D():FacturasClientesLineas( nView ) )
         ( D():FacturasClientesLineas( nView ) )->( dbDelete() )
         ( D():FacturasClientesLineas( nView ) )->( dbUnLock() )
      end if

      ( D():FacturasClientesLineas( nView ) )->( dbSkip() )

   end do

   // actualiza el stock de prestashop-----------------------------------------


   ( D():FacturasClientesLineas( nView ) )->( OrdSetFocus( nOrdAnt ) )

   /*
   Eliminamos los pagos--------------------------------------------------------
   */

   nOrdAnt           := ( D():FacturasClientesCobros( nView ) )->( OrdSetFocus( "fNumFac" ) )

   while ( D():FacturasClientesCobros( nView ) )->( dbSeek( cSerDoc + str( nNumDoc ) + cSufDoc ) ) .and. !( D():FacturasClientesCobros( nView ) )->( eof() )
      if dbLock( D():FacturasClientesCobros( nView ) )
         ( D():FacturasClientesCobros( nView ) )->( dbDelete() )
         ( D():FacturasClientesCobros( nView ) )->( dbUnLock() )
      end if

      ( D():FacturasClientesCobros( nView ) )->( dbSkip() )
   end do

   ( D():FacturasClientesCobros( nView ) )->( OrdSetFocus( nOrdAnt ) )

   /*
   Eliminamos las incidencias--------------------------------------------------
   */

   nOrdAnt           := ( dbfFacCliI )->( OrdSetFocus( "nNumFac" ) )

   while ( dbfFacCliI )->( dbSeek( cSerDoc + str( nNumDoc ) + cSufDoc ) ) .and. !( dbfFacCliI )->( eof() )
      if dbLock( dbfFacCliI )
         ( dbfFacCliI )->( dbDelete() )
         ( dbfFacCliI )->( dbUnLock() )
      end if

      ( dbfFacCliI )->( dbSkip() )
   end do

   ( dbfFacCliI )->( OrdSetFocus( nOrdAnt ) )

   /*
   Eliminamos los documentos---------------------------------------------------
   */

   nOrdAnt           := ( dbfFacCliD )->( OrdSetFocus( "nNumFac" ) )

   while ( dbfFacCliD )->( dbSeek( cSerDoc + str( nNumDoc ) + cSufDoc ) ) .and. !( dbfFacCliD )->( eof() )
      if dbLock( dbfFacCliD )
         ( dbfFacCliD )->( dbDelete() )
         ( dbfFacCliD )->( dbUnLock() )
      end if

      ( dbfFacCliD )->( dbSkip() )
   end do

   ( dbfFacCliD )->( OrdSetFocus( nOrdAnt ) )

   /*
   Eliminamos las series-------------------------------------------------------
   */

   nOrdAnt           := ( dbfFacCliS )->( OrdSetFocus( "nNumFac" ) )

   while ( dbfFacCliS )->( dbSeek( cSerDoc + str( nNumDoc ) + cSufDoc ) ) .and. !( dbfFacCliS )->( eof() )
      if dbLock( dbfFacCliS )
         ( dbfFacCliS )->( dbDelete() )
         ( dbfFacCliS )->( dbUnLock() )
      end if

      ( dbfFacCliS )->( dbSkip() )
   end do

   ( dbfFacCliS )->( OrdSetFocus( nOrdAnt ) )

   /*
   Desmarcamos las entregas acuenta de pedido----------------------------------
   */

   if !empty( cNumPed )

      if( dbfPedCliP )->( dbSeek( cNumPed ) )

         while ( dbfPedCliP )->cSerPed + str( ( dbfPedCliP )->nNumPed ) + ( dbfPedCliP )->cSufPed == cNumPed .and. !( dbfPedCliP )->( Eof() )

            if dbLock( dbfPedCliP )
               ( dbfPedCliP )->lPasado := .f.
               ( dbfPedCliP )->( dbUnLock() )
            end if

         ( dbfPedCliP )->( dbSkip() )

         end while

      end if

      /*
      Actualizamos el estado del pedido----------------------------------------
      */

      oStock:SetEstadoPedCli( cNumPed, .t., cSerDoc + str( nNumDoc ) + cSufDoc )

   end if

   /*
   Desmarcamos las entregas a cuenta de albab-n--------------------------------
   */

   if !empty( cNumAlb )

      if( dbfAlbCliP )->( dbSeek( cNumAlb ) )

         while ( dbfAlbCliP )->cSerAlb + str( ( dbfAlbCliP )->nNumAlb ) + ( dbfAlbCliP )->cSufAlb == cNumAlb .and. !( dbfAlbCliP )->( Eof() )

            if dbLock( dbfAlbCliP )
               ( dbfAlbCliP )->lPasado := .f.
               ( dbfAlbCliP )->( dbUnLock() )
            end if

            ( dbfAlbCliP )->( dbSkip() )

         end while

      end if

   end if

   /*
   Restaura los Facturas caso de estar facturados-----------------------------
   */

   nOrdAnt  := ( dbfAlbCliT )->( OrdSetFocus( "cNumFac" ) )

   while ( dbfAlbCliT )->( dbSeek( cSerDoc + str( nNumDoc, 9 ) + cSufDoc ) ) .and. !( dbfAlbCliT )->( eof() )
      SetFacturadoAlbaranCliente( .f., , dbfAlbCliT, dbfAlbCliL, dbfAlbCliS )
   end while

   ( dbfAlbCliT )->( OrdSetFocus( nOrdAnt ) )

   /*
   Desmarcamos las entregas a cuenta de sat------------------------------------
   */

   if !empty( cNumSat )

      if( dbfSatCliT )->( dbSeek( cNumSat ) )

         while ( dbfSatCliT )->cSerSat + str( ( dbfSatCliT )->nNumSat ) + ( dbfSatCliT )->cSufSat == cNumSat .and. !( dbfSatCliT )->( Eof() )

            if dbLock( dbfSatCliT )
               ( dbfSatCliT )->lEstado := .f.
               ( dbfSatCliT )->( dbUnLock() )
            end if

            ( dbfSatCliT )->( dbSkip() )

         end while

      end if

   end if

   /*
   Devolvemos los presupuestos a su estado anterior----------------------------
   */

   if !empty( cNumPre )

      if ( dbfPreCliT )->( dbSeek( cNumPre ) )

         while ( dbfPreCliT )->cSerPre + str( ( dbfPreCliT )->nNumPre ) + ( dbfPreCliT )->cSufPre == cNumPre .and. !( dbfPreCliT )->( Eof() )
            
            if ( dbfPreCliT )->( dbRLock() )
               ( dbfPreCliT )->lEstado := .f.
               ( dbfPreCliT )->( dbUnlock() )
            end if

            ( dbfPreCliT )->( dbSkip() )

         end while

      end if

   end if

   /*
   Devolvemos los anticipos a su estado anterior-------------------------------
   */

   nOrdAnt     := ( D():AnticiposClientes( nView ) )->( OrdSetFocus( "cNumDoc" ) )

   if ( D():AnticiposClientes( nView ) )->( dbSeek( ( D():FacturasClientes( nView ) )->cSerie + str( ( D():FacturasClientes( nView ) )->nNumFac ) + ( D():FacturasClientes( nView ) )->cSufFac ) )

      while ( D():AnticiposClientes( nView ) )->cNumDoc == ( D():FacturasClientes( nView ) )->cSerie + str( ( D():FacturasClientes( nView ) )->nNumFac ) + ( D():FacturasClientes( nView ) )->cSufFac .and. !( D():AnticiposClientes( nView ) )->( eof() )

         if dbLock( D():AnticiposClientes( nView ) )
            ( D():AnticiposClientes( nView ) )->lLiquidada := .f.
            ( D():AnticiposClientes( nView ) )->( dbUnLock() )
         end if

         ( D():AnticiposClientes( nView ) )->( dbSkip() )

      end while

   end if

   ( D():AnticiposClientes( nView ) )->( OrdSetFocus( nOrdAnt ) ) 

   /*
   Elimina el documento asociado-----------------------------------------------
   */

   if !empty( ( D():FacturasClientes( nView ) )->cNumDoc ) .and. ( dbfTikT )->( dbSeek( ( D():FacturasClientes( nView ) )->cNumDoc ) )
      DelRecno( dbfTikT, nil, .f. )
   end if

   /*
   Marcamos el contador--------------------------------------------------------
   */

   if uFieldEmpresa( "lRecNumFac" )
      nPutDoc( cSerDoc, nNumDoc, cSufDoc, D():FacturasClientes( nView ), "nFacCli", , D():Contadores( nView ) )
   end if

   /*
   Actualiza los stocks--------------------------------------------------------
   */

   TComercio:updateWebProductStocks()

Return .t.

//--------------------------------------------------------------------------//

STATIC FUNCTION aGetSelRec( oBrw, bAction, cTitle, lHide1, cTitle1, lHide2, cTitle2, bPreAction, bPostAction )

   local oDlg
   local oBtnOk
   local oBtnCancel
   local oRad
   local nRad        := 1
   local aRet        := {}
   local oTree
   local oChk1
   local oChk2
   local lChk1       := .t.
   local lChk2       := .t.
   local nRecno      := ( D():FacturasClientes( nView ) )->( Recno() )
   local nOrdAnt     := ( D():FacturasClientes( nView ) )->( OrdSetFocus( 1 ) )
   local oSerIni
   local oSerFin
   local cSerIni     := ( D():FacturasClientes( nView ) )->cSerie
   local cSerFin     := ( D():FacturasClientes( nView ) )->cSerie
   local oDocIni
   local oDocFin
   local nDocIni     := ( D():FacturasClientes( nView ) )->nNumFac
   local nDocFin     := ( D():FacturasClientes( nView ) )->nNumFac
   local oSufIni
   local oSufFin
   local cSufIni     := ( D():FacturasClientes( nView ) )->cSufFac
   local cSufFin     := ( D():FacturasClientes( nView ) )->cSufFac
   local oMtrInf
   local nMtrInf
   local lFechas     := .t.
   local dDesde      := CtoD( "01/01/" + str( Year( Date() ) ) )
   local dHasta      := Date()
   local oImageList

   DEFAULT cTitle    := ""
   DEFAULT lHide1    := .f.
   DEFAULT cTitle1   := ""
   DEFAULT lHide2    := .f.
   DEFAULT cTitle2   := ""

   oImageList        := TImageList():New( 16, 16 )
   oImageList:AddMasked( TBitmap():Define( "gc_delete_12" ),    Rgb( 255, 0, 255 ) )
   oImageList:AddMasked( TBitmap():Define( "gc_check_12" ),  Rgb( 255, 0, 255 ) )

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
      ACTION   ( dbFirst( D():FacturasClientes( nView ), "nNumFac", oDocIni, cSerIni, "nNumFac" ) )

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
      ACTION   ( dbLast( D():FacturasClientes( nView ), "nNumFac", oDocFin, cSerFin, "nNumFac" ) )

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

   REDEFINE APOLOMETER oMtrInf ;
      VAR      nMtrInf ;
      NOPERCENTAGE ;
      ID       200 ;
      OF       oDlg

   oMtrInf:SetTotal( ( D():FacturasClientes( nView ) )->( OrdKeyCount() ) )

   REDEFINE BUTTON oBtnOk ;
      ID       IDOK ;
      OF       oDlg ;
      ACTION   ( MakSelRec( bAction, bPreAction, bPostAction, cSerIni + str( nDocIni, 9 ) + cSufIni, cSerFin + str( nDocFin, 9 ) + cSufFin, nRad, lChk1, lChk2, lFechas, dDesde, dHasta, oDlg, oBtnCancel, oTree, oBrw, oMtrInf ) )

   REDEFINE BUTTON oBtnCancel ;
      ID       IDCANCEL ;
      OF       oDlg ;
      CANCEL ;
      ACTION   ( oDlg:end() )

   oDlg:AddFastKey( VK_F5, {|| oBtnOk:Click() } )

   oDlg:bStart := {|| StartGetSelRec( oBrw, oRad, oChk1, oChk2, oSerIni, oSerFin, oDocIni, oDocFin, oSufIni, oSufFin, lHide1, lHide2, cTitle1, cTitle2 ) }

   ACTIVATE DIALOG oDlg ;
      CENTER ;
      ON INIT  ( oTree:SetImageList( oImageList ) )

   ( D():FacturasClientes( nView ) )->( ordSetFocus( nOrdAnt ) )
   ( D():FacturasClientes( nView ) )->( dbGoTo( nRecNo ) )

   oImageList:End()

   oTree:Destroy()

   oBrw:SetFocus()
   oBrw:Refresh()

RETURN ( aRet )

//---------------------------------------------------------------------------//

Static Function StartGetSelRec( oBrw, oRad, oChk1, oChk2, oSerIni, oSerFin, oDocIni, oDocFin, oSufIni, oSufFin, lHide1, lHide2, cTitle1, cTitle2 )

   if !empty( oBrw ) .and. ( len( oBrw:oBrw:aSelected ) > 1 )

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
      oChk1:UnCheck()
      oChk1:Hide()
   else
      SetWindowText( oChk1:hWnd, cTitle1 )
      oChk1:Refresh()
   end if

   if lHide2
      oChk2:UnCheck()
      oChk2:Hide()
   else
      SetWindowText( oChk2:hWnd, cTitle2 )
      oChk2:Refresh()
   end if

Return ( nil )

//---------------------------------------------------------------------------//

Static Function TreeChanged( oTree )

   local oItemTree   := oTree:GetItem()

   if !empty( oItemTree ) .and. !empty( oItemTree:bAction )
      Eval( oItemTree:bAction )
   end if

RETURN NIL

//---------------------------------------------------------------------------//

Static Function MakSelRec( bAction, bPreAction, bPostAction, cDocIni, cDocFin, nRad, lChk1, lChk2, lFechas, dDesde, dHasta, oDlg, oBtnCancel, oTree, oBrw, oMtrInf )

   local n        := 0
   local nPos     := 0
   local nRec     := ( D():FacturasClientes( nView ) )->( Recno() )
   local aPos
   local lRet
   local lPre
   local lWhile   := .t.

   /*
   Preparamos la pantalla para mostrar la simulaci-n---------------------------
   */

   if lChk1
      aPos        := { 0, 0 }
      ClientToScreen( oDlg:hWnd, aPos )
      oDlg:Move( aPos[ 1 ] - 26, aPos[ 2 ] - 510 )
   end if

   /*
   Desabilitamos el dialogo para iniciar el proceso----------------------------
   */

   oBtnCancel:bAction   := {|| lWhile := .f. }

   oDlg:Disable()

   oTree:Enable()
   oTree:DeleteAll()

   oBtnCancel:Enable()

   if !empty( bPreAction )
      lPre              := Eval( bPreAction )
   end if

   if !IsLogic( lPre ) .or. lPre

      if ( nRad == 1 )

         oMtrInf:SetTotal( len( oBrw:oBrw:aSelected ) )

         for each nPos in ( oBrw:oBrw:aSelected )

            ( D():FacturasClientes( nView ) )->( dbGoTo( nPos ) )

            if lFechas .or.( ( D():FacturasClientes( nView ) )->dFecFac >= dDesde .and. ( D():FacturasClientes( nView ) )->dFecFac <= dHasta )

               lRet  := Eval( bAction, lChk1, lChk2, oTree, D():FacturasClientes( nView ), D():FacturasClientesLineas( nView ) )

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

         oMtrInf:SetTotal( ( D():FacturasClientes( nView ) )->( OrdKeyCount() ) )

         ( D():FacturasClientes( nView ) )->( dbSeek( cDocIni, .t. ) )

         while ( lWhile )                                                                                      .and. ;
               ( D():FacturasClientes( nView ) )->cSerie + str( ( D():FacturasClientes( nView ) )->nNumFac, 9 ) + ( D():FacturasClientes( nView ) )->cSufFac >= cDocIni .and. ;
               ( D():FacturasClientes( nView ) )->cSerie + str( ( D():FacturasClientes( nView ) )->nNumFac, 9 ) + ( D():FacturasClientes( nView ) )->cSufFac <= cDocFin .and. ;
               !( D():FacturasClientes( nView ) )->( eof() )

            if lFechas .or.( ( D():FacturasClientes( nView ) )->dFecFac >= dDesde .and. ( D():FacturasClientes( nView ) )->dFecFac <= dHasta )

               lRet  := Eval( bAction, lChk1, lChk2, oTree, D():FacturasClientes( nView ), D():FacturasClientesLineas( nView ) )

               if IsFalse( lRet )
                  exit
               end if

            end if

            oMtrInf:Set( ( D():FacturasClientes( nView ) )->( OrdKeyNo() ) )

            ( D():FacturasClientes( nView ) )->( dbSkip() )

            SysRefresh()

         end do

         oMtrInf:Set( ( D():FacturasClientes( nView ) )->( OrdKeyCount() ) )

      end if

      if !empty( bPostAction )
         Eval( bPostAction )
      end if

   end if

   ( D():FacturasClientes( nView ) )->( dbGoTo( nRec ) )

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
//
// Importa pedidos de clientes
//

STATIC FUNCTION cPedCli( aGet, aTmp, oBrwLin, oBrwPgo, nMode )

   local nDiv
   local cDesAlb
   local nTotRet
   local cPedido     := aGet[ _CNUMPED ]:VarGet()
   local lValid      := .F.
   local nTotEntPed  := 0

   if nMode != APPD_MODE .OR. empty( cPedido )
      return .t.
   end if

   if dbSeekInOrd( cPedido, "nNumPed", dbfPedCliT )

      if ( dbfPedCliT )->nEstado == 3

         MsgStop( "Pedido recibido" )
         lValid      := .f.

      else

         CursorWait()

         aGet[_CNUMPED ]:bWhen := {|| .f. }

         aGet[_CCODCLI ]:cText( ( dbfPedCliT )->CCODCLI )
         aGet[_CCODCLI ]:lValid()
         aGet[_CCODCLI ]:Disable()

         aGet[_CNOMCLI ]:cText( (dbfPedCliT)->CNOMCLI )
         aGet[_CDIRCLI ]:cText( (dbfPedCliT)->CDIRCLI )
         aGet[_CPOBCLI ]:cText( (dbfPedCliT)->CPOBCLI )
         aGet[_CPRVCLI ]:cText( (dbfPedCliT)->CPRVCLI )
         aGet[_CPOSCLI ]:cText( (dbfPedCliT)->CPOSCLI )
         aGet[_CDNICLI ]:cText( (dbfPedCliT)->CDNICLI )
         aGet[_CCODALM ]:cText( (dbfPedCliT)->CCODALM )
         aGet[_CTLFCLI ]:cText( (dbfPedCliT)->CTLFCLI )
         aGet[_CCODALM ]:lValid()

         aGet[_CCODCAJ ]:cText( ( dbfPedCliT )->cCodCaj )
         aGet[_CCODCAJ ]:lValid()

         aGet[_CCODPAGO]:cText( ( dbfPedCliT )->cCodPgo )
         aGet[_CCODPAGO]:lValid()

         aGet[_CCODAGE ]:cText( ( dbfPedCliT )->cCodAge )
         aGet[_CCODAGE ]:lValid()

         aGet[_NPCTCOMAGE]:cText( ( dbfPedCliT )->nPctComAge )

         aGet[_CCODTAR ]:cText( ( dbfPedCliT )->cCodTar )
         aGet[_CCODTAR ]:lValid()

         aGet[_CCODOBR ]:cText( ( dbfPedCliT )->cCodObr )
         aGet[_CCODOBR ]:lValid()

         if !empty( oGetTarifa )
            oGetTarifa:setTarifa( ( dbfPedCliT )->nTarifa )
         else 
            aTmp[ _NTARIFA ]  := ( dbfPedCliT )->nTarifa
         end if

         aGet[_CCODTRN ]:cText( ( dbfPedCliT )->cCodTrn )
         aGet[_CCODTRN ]:lValid()

         aGet[_LIVAINC ]:Click( ( dbfPedCliT )->lIvaInc )
         aGet[_LRECARGO]:Click( ( dbfPedCliT )->lRecargo )
         aGet[_LOPERPV ]:Click( ( dbfPedCliT )->lOperPv )
         aGet[_LRECC   ]:Click( lRECCEmpresa() )

         aTmp[_CCODGRP]          := ( dbfPedCliT )->cCodGrp
         aTmp[_LMODCLI]          := ( dbfPedCliT )->lModCli

         /*
         Pasamos los comentarios
         */

         aGet[ _CCONDENT]:cText( ( dbfPedCliT )->cCondEnt )
         aGet[ _MCOMENT ]:cText( ( dbfPedCliT )->mComent  )
         aGet[ _MOBSERV ]:cText( ( dbfPedCliT )->mObserv  )

         /*
         Pasamos todos los Descuentos
         */

         aGet[_CDTOESP]:cText( ( dbfPedCliT )->cDtoEsp )
         aGet[_CDPP   ]:cText( ( dbfPedCliT )->cDpp    )
         aGet[_NDTOESP]:cText( ( dbfPedCliT )->nDtoEsp )
         aGet[_NDPP   ]:cText( ( dbfPedCliT )->nDpp    )
         aGet[_CDTOUNO]:cText( ( dbfPedCliT )->cDtoUno )
         aGet[_NDTOUNO]:cText( ( dbfPedCliT )->nDtoUno )
         aGet[_CDTODOS]:cText( ( dbfPedCliT )->cDtoDos )
         aGet[_NDTODOS]:cText( ( dbfPedCliT )->nDtoDos )
         aGet[_CMANOBR]:cText( ( dbfPedCliT )->cManObr )
         aGet[_NIVAMAN]:cText( ( dbfPedCliT )->nIvaMan )
         aGet[_NMANOBR]:cText( ( dbfPedCliT )->nManObr )
         aGet[_NBULTOS]:cText( ( dbfPedCliT )->nBultos )

         /*
         Datos de alquileres---------------------------------------------------
         */

         aTmp[ _LALQUILER ]      := ( dbfPedCliT )->lAlquiler
         aTmp[ _DFECENTR  ]      := ( dbfPedCliT )->dFecEntr
         aTmp[ _DFECSAL   ]      := ( dbfPedCliT )->dFecSal

         if !empty( oTipFac )
            if ( dbfPedCliT )->lAlquiler
               oTipFac:Select( 2 )
            else
               oTipFac:Select( 1 )
            end if
         end if

         /*
         Si lo encuentra-------------------------------------------------------
         */

         if ( dbfPedCliL )->( dbSeek( cPedido ) )

            (dbfTmpLin)->( dbAppend() )
            cDesAlb                    := ""
            cDesAlb                    += "Pedido Nº " + ( dbfPedCliT )->cSerPed + "/" + AllTrim( str( ( dbfPedCliT )->NNUMPED ) ) + "/" + ( dbfPedCliT )->CSUFPED
            cDesAlb                    += " - Fecha " + Dtoc( (dbfPedCliT)->DFECPED )
            (dbfTmpLin)->MLNGDES       := cDesAlb
            (dbfTmpLin)->LCONTROL      := .t.

            while ( ( dbfPedCliL )->cSerPed + str( ( dbfPedCliL )->nNumPed ) + ( dbfPedCliL )->cSufPed == cPedido )

               nTotRet                 := ( dbfPedCliL )->nUniCaja
               nTotRet                 -= nUnidadesRecibidasAlbaranesClientes( cPedido, ( dbfPedCliL )->cRef, ( dbfPedCliL )->cValPr1, ( dbfPedCliL )->cValPr2, dbfAlbCliL )
               nTotRet                 -= nUnidadesRecibidasFacturasClientes( cPedido, ( dbfPedCliL )->cRef, ( dbfPedCliL )->cValPr1, ( dbfPedCliL )->cValPr2, D():FacturasClientesLineas( nView ) )

               (dbfTmpLin)->( dbAppend() )

               (dbfTmpLin)->nNumLin    := (dbfPedCliL)->nNumLin
               (dbfTmpLin)->nPosPrint  := (dbfPedCliL)->nPosPrint
               (dbfTmpLin)->cRef       := (dbfPedCliL)->cRef
               (dbfTmpLin)->cDetalle   := (dbfPedCliL)->cDetalle
               (dbfTmpLin)->mLngDes    := (dbfPedCliL)->mLngDes
               (dbfTmpLin)->mNumSer    := (dbfPedCliL)->mNumSer
               (dbfTmpLin)->nPreUnit   := (dbfPedCliL)->nPreDiv
               (dbfTmpLin)->nPntVer    := (dbfPedCliL)->nPntVer
               (dbfTmpLin)->nImpTrn    := (dbfPedCliL)->nImpTrn
               (dbfTmpLin)->nPESOKG    := (dbfPedCliL)->nPesOkg
               (dbfTmpLin)->cPESOKG    := (dbfPedCliL)->cPesOkg
               (dbfTmpLin)->cUnidad    := (dbfPedCliL)->cUnidad
               (dbfTmpLin)->nVolumen   := (dbfPedCliL)->nVolumen
               (dbfTmpLin)->cVolumen   := (dbfPedCliL)->cVolumen
               (dbfTmpLin)->nIVA       := (dbfPedCliL)->nIva
               (dbfTmpLin)->nReq       := (dbfPedCliL)->nReq
               (dbfTmpLin)->cUNIDAD    := (dbfPedCliL)->cUnidad
               (dbfTmpLin)->nDTO       := (dbfPedCliL)->nDto
               (dbfTmpLin)->nDTOPRM    := (dbfPedCliL)->nDtoPrm
               (dbfTmpLin)->nCOMAGE    := (dbfPedCliL)->nComAge
               (dbfTmpLin)->lTOTLIN    := (dbfPedCliL)->lTotLin
               (dbfTmpLin)->nDtoDiv    := (dbfPedCliL)->nDtoDiv
               (dbfTmpLin)->nCtlStk    := (dbfPedCliL)->nCtlStk
               (dbfTmpLin)->nCosDiv    := (dbfPedCliL)->nCosDiv
               (dbfTmpLin)->nPvpRec    := (dbfPedCliL)->nPvpRec
               (dbfTmpLin)->cTipMov    := (dbfPedCliL)->cTipMov
               (dbfTmpLin)->cAlmLin    := (dbfPedCliL)->cAlmLin
               (dbfTmpLin)->cCodImp    := (dbfPedCLiL)->cCodImp
               (dbfTmpLin)->nValImp    := (dbfPedCliL)->nValImp
               (dbfTmpLin)->CCODPR1    := (dbfPedCliL)->cCodPr1
               (dbfTmpLin)->CCODPR2    := (dbfPedCliL)->cCodPr2
               (dbfTmpLin)->CVALPR1    := (dbfPedCliL)->cValPr1
               (dbfTmpLin)->CVALPR2    := (dbfPedCliL)->cValPr2
               (dbfTmpLin)->lKitArt    := (dbfAlbCliL)->lKitArt
               (dbfTmpLin)->lKitChl    := (dbfPedCliL)->lKitChl
               (dbfTmpLin)->lKitPrc    := (dbfPedCliL)->lKitPrc
               (dbfTmpLin)->lLote      := (dbfPedCliL)->lLote
               (dbfTmpLin)->nLote      := (dbfPedCliL)->nLote
               (dbfTmpLin)->cLote      := (dbfPedCliL)->cLote
               (dbfTmpLin)->lMsgVta    := (dbfPedCliL)->lMsgVta
               (dbfTmpLin)->lNotVta    := (dbfPedCliL)->lNotVta
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
               (dbfTmpLin)->cNumPed    := cPedido
               (dbfTmpLin)->lLinOfe    := (dbfPedCliL)->lLinOfe
               (dbfTmpLin)->nBultos    := (dbfPedCliL)->nBultos
               (dbfTmpLin)->cFormato   := (dbfPedCliL)->cFormato
               (dbfTmpLin)->cCodObr    := (dbfPedCliL)->cObrLin
               (dbfTmpLin)->cRefAux    := (dbfPedCliL)->cRefAux
               (dbfTmpLin)->cRefAux2   := (dbfPedCliL)->cRefAux2
               (dbfTmpLin)->cCtrCoste  := (dbfPedCliL)->cCtrCoste
               (dbfTmpLin)->cTipCtr    := (dbfPedCliL)->cTipCtr
               (dbfTmpLin)->cTerCtr    := (dbfPedCliL)->cTerCtr

               /*
               Vamos a ver si se estan llavando cajas
               */

               if nTotRet != 0

                  /*
                  Comprobamos si hay calculos por cajas
                  */

                  if lCalCaj()

                     nDiv  := Mod( nTotRet, ( dbfPedCliL )->nUniCaja )
                     if nDiv == 0 .and. ( dbfPedCliL )->nCanPed != 0
                        ( dbfTmpLin )->nCanEnt  := ( dbfPedCliL )->nCanPed
                        ( dbfTmpLin )->nUniCaja := ( dbfPedCliL )->nUniCaja
                     else
                        ( dbfTmpLin )->nCanEnt  := 0
                        ( dbfTmpLin )->nUniCaja := nTotRet
                     end if

                  else

                     ( dbfTmpLin )->nCanEnt     := ( dbfPedCliL )->nCanPed
                     ( dbfTmpLin )->nUniCaja    := nTotRet

                  end if

               end if

               (dbfPedCliL)->( dbSkip( 1 ) )

            end while

            ( dbfTmpLin )->( dbGoTop() )


            if uFieldEmpresa( "lGrpEnt" ) // agrupamos las entregas en una sola

               /*
               Sumamos todos los pagos--------------------------------------------
               */

                if ( dbfPedCliP )->( dbSeek( cPedido ) )

                  while ( dbfPedCliP )->cSerPed + str( ( dbfPedCliP )->nNumPed ) + ( dbfPedCliP )->cSufPed == cPedido .and. !( dbfPedCliP )->( Eof() )

                     nTotEntPed     += ( dbfPedCliP )->nImporte

                     ( dbfPedCliP )->( dbSkip() )

                  end while

               end if

               ( dbfPedCliP )->( dbGoTop() )

               /*
               Creamos un solo recibo con las entregas a cuenta-------------------
               */

               if nTotEntPed != 0

                  ( dbfTmpPgo )->( dbAppend() )

                  ( dbfTmpPgo )->lCobrado := .t.
                  ( dbfTmpPgo )->lConPgo  := .f.
                  ( dbfTmpPgo )->lRecImp  := .f.
                  ( dbfTmpPgo )->lRecDto  := .f.
                  ( dbfTmpPgo )->nNumRec  := ( dbfTmpPgo )->( RecNo() )
                  ( dbfTmpPgo )->cCodCaj  := ( dbfPedCliT )->cCodCaj
                  ( dbfTmpPgo )->cCodCli  := ( dbfPedCliT )->cCodCli
                  ( dbfTmpPgo )->cNomCli  := ( dbfPedCliT )->cNomCli
                  ( dbfTmpPgo )->dEntrada := ( dbfPedCliT )->dFecPed
                  ( dbfTmpPgo )->dPreCob  := ( dbfPedCliT )->dFecPed
                  ( dbfTmpPgo )->dFecVto  := ( dbfPedCliT )->dFecPed
                  ( dbfTmpPgo )->nImporte := nTotEntPed
                  ( dbfTmpPgo )->nImpCob  := nTotEntPed
                  ( dbfTmpPgo )->cDivPgo  := ( dbfPedCliT )->cDivPed
                  ( dbfTmpPgo )->nVdvPgo  := ( dbfPedCliT )->nVdvPed
                  ( dbfTmpPgo )->cCodAge  := ( dbfPedCliT )->cCodAge
                  ( dbfTmpPgo )->cTurRec  := ( dbfPedCliT )->cTurPed
                  ( dbfTmpPgo )->lCloPgo  := .t.
                  ( dbfTmpPgo )->cCodPgo  := ( dbfPedCliT )->cCodPgo
                  ( dbfTmpPgo )->cDescrip := "Suma entregas a cuenta pedido: " + ( dbfPedCliT )->cSerPed + "/" + AllTrim( str( ( dbfPedCliT )->nNumPed ) ) + "/" + ( dbfPedCliT )->cSufPed
                  ( dbfTmpPgo )->( dbUnLock() )

               end if

            else  // Pasamos las entregas una a una

               /*
               Pasamos los pagos-----------------------------------------------------
               */

               if ( dbfPedCliP )->( dbSeek( cPedido ) )

                  while ( dbfPedCliP )->cSerPed + str( ( dbfPedCliP )->nNumPed ) + ( dbfPedCliP )->cSufPed == cPedido .and. !( dbfPedCliP )->( Eof() )

                     ( dbfTmpPgo )->( dbAppend() )

                     ( dbfTmpPgo )->nNumRec  := ( dbfTmpPgo )->( RecNo() )
                     ( dbfTmpPgo )->cCodCaj  := ( dbfPedCliP )->cCodCaj
                     ( dbfTmpPgo )->cTurRec  := ( dbfPedCliP )->cTurRec
                     ( dbfTmpPgo )->cCodCli  := ( dbfPedCliP )->cCodCli
                     ( dbfTmpPgo )->dEntrada := ( dbfPedCliP )->dEntrega
                     ( dbfTmpPgo )->dPreCob  := ( dbfPedCliP )->dEntrega
                     ( dbfTmpPgo )->dFecVto  := ( dbfPedCliP )->dEntrega
                     ( dbfTmpPgo )->nImporte := ( dbfPedCliP )->nImporte
                     ( dbfTmpPgo )->nImpCob  := ( dbfPedCliP )->nImporte
                     if !empty( ( dbfPedCliP )->cDescrip )
                     ( dbfTmpPgo )->cDescrip := ( dbfPedCliP )->cDescrip
                     else
                     ( dbfTmpPgo )->cDescrip := "Entrega Nº " + AllTrim( str( ( dbfTmpPgo )->( RecNo() ) ) ) + " pedido " + ( dbfPedCliP )->cSerPed + "/" + AllTrim( str( ( dbfPedCliP )->nNumPed ) ) + "/" + ( dbfPedCliP )->cSufPed
                     end if
                     ( dbfTmpPgo )->cPgdoPor := ( dbfPedCliP )->cPgdoPor
                     ( dbfTmpPgo )->cDocPgo  := ( dbfPedCliP )->cDocPgo
                     ( dbfTmpPgo )->cDivPgo  := ( dbfPedCliP )->cDivPgo
                     ( dbfTmpPgo )->nVdvPgo  := ( dbfPedCliP )->nVdvPgo
                     ( dbfTmpPgo )->cCodAge  := ( dbfPedCliP )->cCodAge
                     ( dbfTmpPgo )->cBncEmp  := ( dbfPedCliP )->cBncEmp
                     ( dbfTmpPgo )->cBncCli  := ( dbfPedCliP )->cBncCli
                     ( dbfTmpPgo )->cEntEmp  := ( dbfPedCliP )->cEntEmp
                     ( dbfTmpPgo )->cSucEmp  := ( dbfPedCliP )->cSucEmp
                     ( dbfTmpPgo )->cDigEmp  := ( dbfPedCliP )->cDigEmp
                     ( dbfTmpPgo )->cCtaEmp  := ( dbfPedCliP )->cCtaEmp
                     ( dbfTmpPgo )->cEntCli  := ( dbfPedCliP )->cEntCli
                     ( dbfTmpPgo )->cSucCli  := ( dbfPedCliP )->cSucCli
                     ( dbfTmpPgo )->cDigCli  := ( dbfPedCliP )->cDigCli
                     ( dbfTmpPgo )->cCtaCli  := ( dbfPedCliP )->cCtaCli
                     ( dbfTmpPgo )->lCobrado := .t.
                     ( dbfTmpPgo )->lConPgo  := .f.
                     ( dbfTmpPgo )->lRecImp  := .f.
                     ( dbfTmpPgo )->lRecDto  := .f.

                     ( dbfPedCliP )->( dbSkip() )

                  end while

               end if

            end if

            /*
            Pasamos las incidencias de los pedidos-----------------------------
            */

            if ( nMode != DUPL_MODE ) .and. ( dbfPedCliI )->( dbSeek( cPedido ) )

               while ( dbfPedCliI )->cSerPed + str( ( dbfPedCliI )->nNumPed ) + ( dbfPedCliI )->cSufPed == cPedido .and. !( dbfPedCliI )->( Eof() )
                  dbPass( dbfPedCliI, dbfTmpInc, .t. )
                  ( dbfPedCliI )->( dbSkip() )
               end while

            end if

            ( dbfPedCliI )->( dbGoTop() )

            /*
            Pasamos los documentos de los pedidos------------------------------
            */

            if ( dbfPedCliD )->( dbSeek( cPedido ) )

               while ( dbfPedCliD )->cSerPed + str( ( dbfPedCliD )->nNumPed ) + ( dbfPedCliD )->cSufPed == cPedido .and. !( dbfPedCliD )->( Eof() )
                  dbPass( dbfPedCliD, dbfTmpDoc, .t. )
                  ( dbfPedCliD )->( dbSkip() )
               end while

            end if

            ( dbfPedCliD )->( dbGoTop() )

            oBrwLin:Refresh()
            oBrwPgo:Refresh()

            oBrwLin:SetFocus()

         end if

         lValid   := .t.

         CursorWE()

      end if

      HideImportacion( aGet, aGet[ _CNUMPED ] )

   else

      MsgStop( "Pedido no existe" )

   end if

RETURN lValid

//---------------------------------------------------------------------------//
//
// Importa presupuestos de clientes
//

STATIC FUNCTION cPreCli( aGet, aTmp, oBrw, nMode )

   local cDesAlb
   local cPedido  := aGet[ _CNUMPRE ]:VarGet()
   local lValid   := .F.

   if nMode != APPD_MODE .OR. empty( cPedido )
      return .t.
   end if

   if dbSeekInOrd( cPedido, "nNumPre", dbfPreCliT )

      if ( dbfPreCliT )->lEstado

         MsgStop( "Presupuesto ya aprobado" )
         lValid   := .f.

      else

         aGet[_CCODCLI ]:cText( ( dbfPreCliT )->CCODCLI )
         aGet[_CCODCLI ]:lValid()
         aGet[_CCODCLI ]:Disable()

         aGet[_CNOMCLI ]:cText( ( dbfPreCliT )->CNOMCLI )
         aGet[_CDIRCLI ]:cText( ( dbfPreCliT )->CDIRCLI )
         aGet[_CPOBCLI ]:cText( ( dbfPreCliT )->CPOBCLI )
         aGet[_CPRVCLI ]:cText( ( dbfPreCliT )->CPRVCLI )
         aGet[_CPOSCLI ]:cText( ( dbfPreCliT )->CPOSCLI )
         aGet[_CDNICLI ]:cText( ( dbfPreCliT )->CDNICLI )
         aGet[_CTLFCLI ]:cText( ( dbfPreCliT )->CTLFCLI )

         aGet[_CCODALM ]:cText( ( dbfPreCliT )->CCODALM )
         aGet[_CCODALM ]:lValid()

         aGet[_CCODCAJ ]:cText( ( dbfPreCliT )->cCodCaj )
         aGet[_CCODCAJ ]:lValid()

         aGet[_CCODPAGO]:cText( ( dbfPreCliT )->CCODPGO )
         aGet[_CCODPAGO]:lValid()

         aGet[_CCODAGE ]:cText( ( dbfPreCliT )->CCODAGE )
         aGet[_CCODAGE ]:lValid()

         aGet[_NPCTCOMAGE]:cText( ( dbfPreCliT )->nPctComAge )

         aGet[_CCODTAR ]:cText( ( dbfPreCliT )->CCODTAR )
         aGet[_CCODTAR ]:lValid()

         aGet[_CCODOBR ]:cText( ( dbfPreCliT )->CCODOBR )
         aGet[_CCODOBR ]:lValid()

         if !empty( oGetTarifa )
            oGetTarifa:setTarifa( ( dbfPreCliT )->nTarifa )
         else 
            aTmp[ _NTARIFA ]  := ( dbfPreCliT )->nTarifa
         end if

         aGet[_CCODTRN ]:cText( ( dbfPreCliT )->cCodTrn )
         aGet[_CCODTRN ]:lValid()

         aGet[_LIVAINC ]:Click( ( dbfPreCliT )->lIvaInc )
         aGet[_LRECARGO]:Click( ( dbfPreCliT )->lRecargo )
         aGet[_LOPERPV ]:Click( ( dbfPreCliT )->lOperPv )
         aGet[_LRECC   ]:Click( lRECCEmpresa() )

         aGet[_CCONDENT]:cText( ( dbfPreCliT )->cCondEnt )
         aGet[_MCOMENT ]:cText( ( dbfPreCliT )->mComent )
         aGet[_MOBSERV ]:cText( ( dbfPreCliT )->mObserv )

         aGet[_CDTOESP ]:cText( ( dbfPreCliT )->cDtoEsp )
         aGet[_CDPP    ]:cText( ( dbfPreCliT )->cDpp    )
         aGet[_NDTOESP ]:cText( ( dbfPreCliT )->nDtoEsp )
         aGet[_NDPP    ]:cText( ( dbfPreCliT )->nDpp    )
         aGet[_CDTOUNO ]:cText( ( dbfPreCliT )->cDtoUno )
         aGet[_NDTOUNO ]:cText( ( dbfPreCliT )->nDtoUno )
         aGet[_CDTODOS ]:cText( ( dbfPreCliT )->cDtoDos )
         aGet[_NDTODOS ]:cText( ( dbfPreCliT )->nDtoDos )
         aGet[_CMANOBR ]:cText( ( dbfPreCliT )->cManObr )
         aGet[_NIVAMAN ]:cText( ( dbfPreCliT )->nIvaMan )
         aGet[_NMANOBR ]:cText( ( dbfPreCliT )->nManObr )
         aGet[_NBULTOS ]:cText( ( dbfPreCliT )->nBultos )

         aTmp[_CCODGRP]          := ( dbfPreCliT )->cCodGrp
         aTmp[_LMODCLI]          := ( dbfPreCliT )->lModCli

         /*
         Datos de alquileres---------------------------------------------------
         */

         aTmp[ _LALQUILER ]      := ( dbfPreCliT )->lAlquiler
         aTmp[ _DFECENTR  ]      := ( dbfPreCliT )->dFecEntr
         aTmp[ _DFECSAL   ]      := ( dbfPreCliT )->dFecSal

         if !empty( oTipFac )
            if aTmp[ _LALQUILER ]
               oTipFac:Select( 2 )
            else
               oTipFac:Select( 1 )
            end if
         end if

         if (dbfPreCliL)->( dbSeek( cPedido ) )

            (dbfTmpLin)->( dbAppend() )
            cDesAlb              := ""
            cDesAlb              += "Presupuesto Nº " + ( dbfPreCliT )->cSerPre + "/" + AllTrim( str( ( dbfPreCliT )->nNumPre ) ) + "/" + ( dbfPreCliT )->cSufPre
            cDesAlb              += " - Fecha " + Dtoc( ( dbfPreCliT )->dFecPre )
            (dbfTmpLin)->MLNGDES    := cDesAlb
            (dbfTmpLin)->LCONTROL   := .t.

            while ( (dbfPreCliL)->cSerPre + str( (dbfPreCliL)->nNumPre ) + (dbfPreCliL)->cSufPre == cPedido )

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
               (dbfTmpLin)->cCodObr    := (dbfPedCliT)->cCodObr
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

            if ( nMode != DUPL_MODE ) .and. ( dbfPreCliI )->( dbSeek( cPedido ) )

               while ( dbfPreCliI )->cSerPre + str( ( dbfPreCliI )->nNumPre ) + ( dbfPreCliI )->cSufPre == cPedido .and. !( dbfPreCliI )->( Eof() )
                  dbPass( dbfPreCliI, dbfTmpInc, .t. )
                  ( dbfPreCliI )->( dbSkip() )
               end while

            end if

            ( dbfPreCliI )->( dbGoTop() )

            /*
            Pasamos los documentos del presupuesto
            */

            if ( dbfPreCliD )->( dbSeek( cPedido ) )

               while ( dbfPreCliD )->cSerPre + str( ( dbfPreCliD )->nNumPre ) + ( dbfPreCliD )->cSufPre == cPedido .and. !( dbfPreCliD )->( Eof() )
                  dbPass( dbfPreCliD, dbfTmpDoc, .t. )
                  ( dbfPreCliD )->( dbSkip() )
               end while

            end if

            ( dbfPreCliD )->( dbGoTop() )

            oBrw:refresh()
            oBrw:setFocus()

         end if

         lValid   := .T.

         if ( dbfPreCliT )->( dbRLock() )
            ( dbfPreCliT )->lEstado := .t.
            ( dbfPreCliT )->( DbUnlock() )
         end if

      end if

      HideImportacion( aGet, aGet[ _CNUMPRE ] )

   ELSE

      MsgStop( "Presupuesto no existe" )

   END IF

RETURN lValid

//---------------------------------------------------------------------------//

STATIC FUNCTION DelSerie( oWndBrw )

   local oDlg
   local oSerIni
   local oSerFin
   local oTxtDel
   local nTxtDel     := 0
   local nRecno      := ( D():FacturasClientes( nView ) )->( Recno() )
   local nOrdAnt     := ( D():FacturasClientes( nView ) )->( OrdSetFocus( 1 ) )
   local oDesde      := TDesdeHasta():Init( ( D():FacturasClientes( nView ) )->cSerie, ( D():FacturasClientes( nView ) )->nNumFac, ( D():FacturasClientes( nView ) )->cSufFac, GetSysDate() )
   local lCancel     := .f.
   local oBtnAceptar
   local oBtnCancel

   DEFINE DIALOG oDlg ;
      RESOURCE "DELSERDOC" ;
      TITLE    "Eliminar series de facturas" ;
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
      TOTAL    ( D():FacturasClientes( nView ) )->( OrdKeyCount() ) ;
      OF       oDlg

   ACTIVATE DIALOG oDlg CENTER VALID ( lCancel )

   ( D():FacturasClientes( nView ) )->( dbGoTo( nRecNo ) )
   ( D():FacturasClientes( nView ) )->( ordSetFocus( nOrdAnt ) )

   oWndBrw:SetFocus()
   oWndBrw:Refresh()

RETURN NIL

//--------------------------------------------------------------------------//

STATIC FUNCTION DelStart( oDesde, oDlg, oBtnAceptar, oBtnCancel, oTxtDel, lCancel )

   local nOrd
   local nDeleted       := 0
   local nProcesed      := 0

   oBtnAceptar:Hide()
   oBtnCancel:bAction   := {|| lCancel := .t. }

   if oDesde:nRadio == 1

      nOrd              := ( D():FacturasClientes( nView ) )->( OrdSetFocus( "nNumFac" ) )

      ( D():FacturasClientes( nView ) )->( dbSeek( oDesde:cNumeroInicio(), .t. ) )
      while !lCancel .and. ( D():FacturasClientes( nView ) )->( !eof() )

         if ( D():FacturasClientes( nView ) )->cSerie  >= oDesde:cSerieInicio  .and.;
            ( D():FacturasClientes( nView ) )->cSerie  <= oDesde:cSerieFin     .and.;
            ( D():FacturasClientes( nView ) )->nNumFac >= oDesde:nNumeroInicio .and.;
            ( D():FacturasClientes( nView ) )->nNumFac <= oDesde:nNumeroFin    .and.;
            ( D():FacturasClientes( nView ) )->cSufFac >= oDesde:cSufijoInicio .and.;
            ( D():FacturasClientes( nView ) )->cSufFac <= oDesde:cSufijoFin

            ++nDeleted

            oTxtDel:cText  := "Eliminando : " + ( D():FacturasClientes( nView ) )->cSerie + "/" + Alltrim( str( ( D():FacturasClientes( nView ) )->nNumFac ) ) + "/" + ( D():FacturasClientes( nView ) )->cSufFac

            WinDelRec( nil, D():FacturasClientes( nView ), {|| QuiFacCli() } )

         else

            ( D():FacturasClientes( nView ) )->( dbSkip() )

         end if

         ++nProcesed

         oTxtDel:Set( nProcesed )

      end do

      ( D():FacturasClientes( nView ) )->( OrdSetFocus( nOrd ) )

   else

      nOrd              := ( D():FacturasClientes( nView ) )->( OrdSetFocus( "dFecFac" ) )

      ( D():FacturasClientes( nView ) )->( dbSeek( oDesde:dFechaInicio, .t. ) )
      while !lCancel .and. ( D():FacturasClientes( nView ) )->( !eof() )

         if ( D():FacturasClientes( nView ) )->dFecFac >= oDesde:dFechaInicio  .and.;
            ( D():FacturasClientes( nView ) )->dFecFac <= oDesde:dFechaFin

            ++nDeleted

            oTxtDel:cText  := "Eliminando : " + ( D():FacturasClientes( nView ) )->cSerie + "/" + Alltrim( str( ( D():FacturasClientes( nView ) )->nNumFac ) ) + "/" + ( D():FacturasClientes( nView ) )->cSufFac

            WinDelRec( nil, D():FacturasClientes( nView ), {|| QuiFacCli() } )

         else

            ( D():FacturasClientes( nView ) )->( dbSkip() )

         end if

         ++nProcesed

         oTxtDel:Set( nProcesed )

      end do

      ( D():FacturasClientes( nView ) )->( OrdSetFocus( nOrd ) )

   end if

   lCancel              := .t.

   oBtnAceptar:Show()

   if lCancel
      msgStop( "Total de registros borrados : " + str( nDeleted ), "Proceso cancelado" )
   else
      msgInfo( "Total de registros borrados : " + str( nDeleted ), "Proceso finalizado" )
   end if

RETURN ( oDlg:End() )

//---------------------------------------------------------------------------//

static function RecFacCli( aTmpFac, lMessage )

   local nRecno
   local cCodFam
   local nDtoAge     := 0
   local nImpAtp     := 0
   local nImpOfe     := 0
   local hAtipica

   DEFAULT lMessage  := .t.

   if lMessage

      if !ApoloMsgNoYes(  "!Atención!,"                                       + CRLF + ;
                           "todos los precios se recalcularán en función de"  + CRLF + ;
                           "los valores en las bases de datos.",;
                           "¿ Desea proceder ?" )
         return nil
      end if

   end if

   nRecno            := ( dbfTmpLin )->( RecNo() )
   
   ( D():Articulos( nView ) )->( ordSetFocus( "Codigo" ) )

   ( dbfTmpLin )->( dbGotop() )
   while !( dbfTmpLin )->( eof() )

      /*
      Ahora buscamos por el codigo interno
      */

      if ( D():Articulos( nView ) )->( dbSeek( ( dbfTmpLin )->cRef ) )

         do case
            case aTmpFac[ _NREGIVA ] <= 2
               ( dbfTmpLin )->nIva     := nIva( dbfIva, ( D():Articulos( nView ) )->TipoIva )
               ( dbfTmpLin )->nReq     := nReq( dbfIva, ( D():Articulos( nView ) )->TipoIva )
            case aTmpFac[ _NREGIVA ] == 3
               ( dbfTmpLin )->nIva     := 0
               ( dbfTmpLin )->nReq     := 0
         end case 

         /*
         Ahora recogemos el impuesto especial si lo hay
         */

         if !empty( ( D():Articulos( nView ) )->cCodImp )
            ( dbfTmpLin )->cCodImp  := ( D():Articulos( nView ) )->cCodImp
            ( dbfTmpLin )->nValImp  := oNewImp:nValImp( ( D():Articulos( nView ) )->cCodImp, aTmpFac[ _LIVAINC ], ( dbfTmpLin )->nIva )
         end if

         /*
         Tomamos los precios de la base de datos de articulos
         */

         ( dbfTmpLin )->nPreUnit := nRetPreArt( ( dbfTmpLin )->nTarLin, aTmpFac[ _CDIVFAC ], aTmpFac[ _LIVAINC ], D():Articulos( nView ), dbfDiv, dbfKit, dbfIva, , , oNewImp )

         /*
         Cargamos simpre los puntos verdes
         */

         ( dbfTmpLin )->nPntVer  := ( D():Articulos( nView ) )->nPntVer1

         /*
         Linea por contadores--------------------------------------------------
         */

         ( dbfTmpLin )->nCtlStk  := (D():Articulos( nView ))->nCtlStock
         ( dbfTmpLin )->nCosDiv  := nCosto( nil, D():Articulos( nView ), dbfKit )
         ( dbfTmpLin )->nPvpRec  := (D():Articulos( nView ))->PvpRec

         // Chequeamos situaciones especiales

         cCodFam                 := ( dbfTmpLin )->cCodFam

         // Precios en tarifas

         do case
         case !empty( aTmpFac[ _CCODTAR ] )

            nImpOfe     := RetPrcTar( ( dbfTmpLin )->cRef, aTmpFac[ _CCODTAR ], ( dbfTmpLin )->cCodPr1, ( dbfTmpLin )->cCodPr2, ( dbfTmpLin )->cValPr1, ( dbfTmpLin )->cValPr2, dbfTarPreL, ( dbfTmpLin )->nTarLin )
            if nImpOfe != 0
               ( dbfTmpLin )->nPreUnit := nImpOfe
            end if

            nImpOfe     := RetPctTar( ( dbfTmpLin )->cRef, cCodFam, aTmpFac[ _CCODTAR ], ( dbfTmpLin )->cCodPr1, ( dbfTmpLin )->cCodPr2, ( dbfTmpLin )->cValPr1, ( dbfTmpLin )->cValPr2, dbfTarPreL )
            if nImpOfe != 0
               ( dbfTmpLin )->nDto     := nImpOfe
            end if

            nImpOfe     := RetComTar( ( dbfTmpLin )->cRef, cCodFam, aTmpFac[ _CCODTAR ], ( dbfTmpLin )->cCodPr1, ( dbfTmpLin )->cCodPr2, ( dbfTmpLin )->cValPr1, ( dbfTmpLin )->cValPr2, aTmpFac[ _CCODAGE ], dbfTarPreL, dbfTarPreS )
            if nImpOfe  != 0
               ( dbfTmpLin )->nComAge  := nImpOfe
            end if

            /*
            Descuento de promoci-n, esta funci-n comprueba si existe y si es
            asi devuelve el descunto de la promoci-n.
            */

            nImpOfe     := RetDtoPrm( ( dbfTmpLin )->cRef, cCodFam, aTmpFac[ _CCODTAR ], ( dbfTmpLin )->cCodPr1, ( dbfTmpLin )->cCodPr2, ( dbfTmpLin )->cValPr1, ( dbfTmpLin )->cValPr2, aTmpFac[ _DFECFAC ], dbfTarPreL )
            if nImpOfe  != 0
               ( dbfTmpLin )->nDtoPrm  := nImpOfe
            end if

            /*
            Obtenemos el descuento de Agente
            */

            nDtoAge     := RetDtoAge( ( dbfTmpLin )->cRef, cCodFam, aTmpFac[ _CCODTAR ], ( dbfTmpLin )->cCodPr1, ( dbfTmpLin )->cCodPr2, ( dbfTmpLin )->cValPr1, ( dbfTmpLin )->cValPr2, aTmpFac[ _DFECFAC ], aTmpFac[ _CCODAGE ], dbfTarPreL, dbfTarPreS )
            if nDtoAge  != 0
               ( dbfTmpLin )->nComAge  := nDtoAge
            end if

         end case

         /*
         Buscamos si existen atipicas de clientes------------------------------
         */

         hAtipica := hAtipica( hValue( dbfTmpLin, aTmpFac ) )

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

         nImpOfe     := nImpOferta( ( dbfTmpLin )->cRef, aTmpFac[ _CCODCLI ], aTmpFac[ _CCODGRP ], ( dbfTmpLin )->nUniCaja, aTmpFac[ _DFECFAC ], dbfOferta, ( dbfTmpLin )->nTarLin, nil, ( dbfTmpLin )->cCodPr1, ( dbfTmpLin )->cCodPr2, ( dbfTmpLin )->cValPr1, ( dbfTmpLin )->cValPr2 )
         if nImpOfe  != 0
            ( dbfTmpLin )->nPreUnit := nCnv2Div( nImpOfe, cDivEmp(), aTmpFac[ _CDIVFAC ] )
         end if

         /*
         Buscamos si existen descuentos en las ofertas
         */

         /*nImpOfe     := nDtoOferta( ( dbfTmpLin )->cRef, aTmpFac[ _CCODCLI ], aTmpFac[ _CCODGRP ], ( dbfTmpLin )->nUniCaja, aTmpFac[ _DFECFAC ], dbfOferta, ( dbfTmpLin )->cCodPr1, ( dbfTmpLin )->cCodPr2, ( dbfTmpLin )->cValPr1, ( dbfTmpLin )->cValPr2 )
         if nImpOfe  != 0
            ( dbfTmpLin )->nDtoPrm  := nImpOfe
         end if*/

      end if

      ( dbfTmpLin )->( dbSkip() )

   end while

   ( dbfTmpLin )->( dbGoTo( nRecno ) )

return nil

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

   if !empty( oBrwLin )
      oBrwLin:Refresh()
   end if   

Return ( nil )

//---------------------------------------------------------------------------//

/*
Funcion que nos permite añadir a las facturas articulos de Facturas ya
existentes
- Parametros:
   oGet     -> Objeto que contiene el valor del nuevo albaran
   nAlbaran -> Numero del Albaran que se esta creando,
   oBrw     -> Objeto Browse se pasa para hacer los referscos
*/

STATIC FUNCTION GrpAlb( aGet, aTmp, oBrw, nMode )

   local oDlg
   local oBmp
   local oTitle1
   local oTitle2
   local oTitle3
   local oBrwDet
   local nOrd
   local nOrdLineasFacturas
   local nNumLin
   local nPosPrint
   local nItem       := 1
   local nTotDoc     := 0
   local nDtoEsp     := 0
   local nDtoDpp     := 0
   local nDtoUno     := 0
   local nDtoDos     := 0
   local nOffSet     := nLastNum( dbfTmpLin )
   local cDesAlb     := ""
   local cCodCli     := Rtrim( aGet[ _CCODCLI ]:VarGet() )
   local lIvaInc     := aTmp[ _LIVAINC ]
   local lAlquiler   := .f.
   local aFacturas  := {}
   local nTotEntAlb  := 0
   local cSuPed      := ""

   if empty( cCodCli )
      msgStop( "Es necesario codificar un cliente.", "Agrupar Facturas" )
      return .t.
   end if

   nOrd              := ( dbfAlbCliT )->( ordSetFocus( "CCODCLI" ) )   // Orden a Codigo de Cliente
   nOrdLineasFacturas := ( dbfAlbCliL )->( ordSetFocus( "nPosPrint" ) )

   if !empty( oTipFac ) .and. oTipFac:nAt == 2
      lAlquiler      := .t.
   end if

   /*
   Seleccion de Registros
   --------------------------------------------------------------------------
   */

   if ( dbfAlbCliT )->( dbSeek( cCodCli ) )
      do while Rtrim( ( dbfAlbCliT )->cCodCli ) == cCodCli .and. !( dbfAlbCliT )->( eof() )

         if ( dbfAlbCliT )->lAlquiler  == lAlquiler                                          .and.;
            !( dbfAlbCliT )->lFacturado                                                      .and.;
            ( lIvaInc == ( dbfAlbCliT )->lIvaInc  )                                          .and.;
            ( empty( aTmp[ _CCODOBR ] ) .or. ( dbfAlbCliT )->cCodObr == aTmp[ _CCODOBR ] )

            aAdd( aFacturas, {  lFacturado( dbfAlbCliT ) ,;
                                 ( dbfAlbCliT )->cSerAlb + str( ( dbfAlbCliT )->nNumAlb ) + ( dbfAlbCliT )->cSufAlb,;
                                 ( dbfAlbCliT )->cCodSuAlb ,;
                                 ( dbfAlbCliT )->dFecAlb ,;
                                 ( dbfAlbCliT )->cCodCli ,;
                                 ( dbfAlbCliT )->cNomCli ,;
                                 ( dbfAlbCliT )->cRetMat ,;
                                 ( dbfAlbCliT )->cCodObr ,;
                                 sTotAlbCli( ( dbfAlbCliT )->cSerAlb + str( ( dbfAlbCliT )->nNumAlb ) + ( dbfAlbCliT )->cSufAlb, dbfAlbCliT, dbfAlbCliL, dbfIva, dbfDiv, nil, nil, .t. ),;
                                 ( dbfAlbCliT )->cSerAlb ,;
                                 ( dbfAlbCliT )->nNumAlb ,;
                                 ( dbfAlbCliT )->cSufAlb } )
         endif

         ( dbfAlbCliT )->( dbSkip() )

      end do

   else

      msgStop( "No existen Facturas de este cliente." )

      ( dbfAlbCliT )->( ordSetFocus( nOrd ) )
      ( dbfAlbCliS )->( ordSetFocus( nOrdLineasFacturas ) )
      
      return .t.

   end if

   /*
   Reposicionamos el focus en el indice-------------------------------------
   */

   ( dbfAlbCliT )->( ordSetFocus( nOrd ) )

   /*
   Puede que no hay Facturas que facturar
   */

   if Len( aFacturas ) == 0
      MsgStop( "No existen Facturas sin facturar" )
      return .t.
   end if

   /*
   Caja de Dialogo
   --------------------------------------------------------------------------
   */

   DEFINE DIALOG  oDlg ;
      RESOURCE    "SET_ALBARAN" ;
      TITLE       "Agrupando Facturas de clientes"

      REDEFINE BITMAP oBmp ;
         ID       500 ;
         RESOURCE "gc_document_text_gear_48" ;
         TRANSPARENT ;
         OF       oDlg

      REDEFINE SAY oTitle1 PROMPT RTrim( aTmp[_CNOMCLI] );
         ID       501 ;
         OF       oDlg

      REDEFINE SAY oTitle2 PROMPT If( empty( aTmp[_CCODOBR] ), "TODAS", aTmp[_CCODOBR] );
         ID       502 ;
         OF       oDlg

      REDEFINE SAY oTitle3 PROMPT if( aTmp[ _LIVAINC ], "Incluido", "Desglosado" );
         ID       503 ;
         OF       oDlg

      REDEFINE SAY oTitle3 PROMPT "Tipo de " + cImp() + ": ";
         ID       504 ;
         OF       oDlg

      oBrwDet                        := IXBrowse():New( oDlg )

      oBrwDet:bClrSel                := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwDet:bClrSelFocus           := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrwDet:nMarqueeStyle          := 5
      oBrwDet:lRecordSelector        := .f.
      oBrwDet:lHscroll               := .f.
      oBrwDet:lFooter                := .t.
      oBrwDet:cName                  := "Agrupar Facturas clientes"

      oBrwDet:bLDblClick   := {|| aFacturas[ oBrwDet:nArrayAt, 1 ] := !aFacturas[ oBrwDet:nArrayAt, 1 ], oBrwDet:Refresh() }

      with object ( oBrwDet:AddCol() )
         :cHeader          := "Seleccionado"
         :cSortOrder       := 1
         :bStrData         := {|| "" }
         :bEditValue       := {|| aFacturas[ oBrwDet:nArrayAt, 1 ] }
         :nWidth           := 20
         :SetCheck( { "Sel16", "Nil16" } )
      end with

      with object ( oBrwDet:AddCol() )
         :cHeader          := "Número"
         :cSortOrder       := 2
         :bEditValue       := {|| aFacturas[ oBrwDet:nArrayAt, 10 ] + "/" + AllTrim( str( aFacturas[ oBrwDet:nArrayAt, 11 ] ) ) + "/" + aFacturas[ oBrwDet:nArrayAt, 12 ] }
         :nWidth           := 75
      end with

      with object ( oBrwDet:AddCol() )
         :cHeader          := "Su albarán"
         :cSortOrder       := 3
         :bEditValue       := {|| aFacturas[ oBrwDet:nArrayAt, 3 ] }
         :nWidth           := 75
      end with

      with object ( oBrwDet:AddCol() )
         :cHeader          := "Fecha"
         :cSortOrder       := 4
         :bEditValue       := {|| Dtoc( aFacturas[ oBrwDet:nArrayAt, 4 ] ) }
         :nWidth           := 80
      end with

      with object ( oBrwDet:AddCol() )
         :cHeader          := "Cliente"
         :cSortOrder       := 5
         :bEditValue       := {|| Rtrim( aFacturas[ oBrwDet:nArrayAt, 5 ] ) + Space(1) + aFacturas[ oBrwDet:nArrayAt, 6 ] }
         :nWidth           := 225
      end with

      with object ( oBrwDet:AddCol() )
         :cHeader          := "Matrícula"
         :cSortOrder       := 7
         :bEditValue       := {|| Rtrim( aFacturas[ oBrwDet:nArrayAt, 7 ] ) }
         :nWidth           := 80
      end with

      with object ( oBrwDet:AddCol() )
         :cHeader          := "Dirección"
         :cSortOrder       := 8
         :bEditValue       := {|| Rtrim( aFacturas[ oBrwDet:nArrayAt, 8 ] ) + Space(1) + RetFld( aFacturas[ oBrwDet:nArrayAt, 5 ] + aFacturas[ oBrwDet:nArrayAt, 8 ], dbfObrasT, "cNomObr" ) }
         :nWidth           := 225
      end with

      with object ( oBrwDet:AddCol() )
         :cHeader          := "Total"
         :bEditValue       := {|| aFacturas[ oBrwDet:nArrayAt, 9 ]:nTotalDocumento }
         :bFooter          := {|| nTotalFacturasAgrupar( aFacturas ) }
         :nWidth           := 70
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
         :nFootStrAlign    := 1
      end with

      oBrwDet:SetArray( aFacturas, .t., , .f. )

      oBrwDet:CreateFromResource( 130 )

      REDEFINE BUTTON ;
         ID       514 ;
         OF       oDlg ;
         ACTION   (  aFacturas[ oBrwDet:nArrayAt, 1 ] := !aFacturas[ oBrwDet:nArrayAt, 1 ],;
                     oBrwDet:refresh(),;
                     oBrwDet:setFocus() )

      REDEFINE BUTTON ;
         ID       516 ;
         OF       oDlg ;
         ACTION   (  aEval( aFacturas, { |aItem| aItem[1] := .t. } ),;
                     oBrwDet:refresh(),;
                     oBrwDet:setFocus() )

      REDEFINE BUTTON ;
         ID       517 ;
         OF       oDlg ;
         ACTION   (  aEval( aFacturas, { |aItem| aItem[1] := .f. } ),;
                     oBrwDet:refresh(),;
                     oBrwDet:setFocus() )

      REDEFINE BUTTON ;
         ID       518 ;
         OF       oDlg ;
         ACTION   ( ZooAlbCli( aFacturas[ oBrwDet:nArrayAt, 2 ] ) )

      REDEFINE BUTTON ;
         ID       IDOK ;
         OF       oDlg ;
         ACTION   ( oDlg:end( IDOK ) )

      REDEFINE BUTTON ;
         ID       IDCANCEL ;
         OF       oDlg ;
         CANCEL ;
         ACTION   ( oDlg:end() )

      oDlg:AddFastKey( VK_F5, {|| oDlg:end( IDOK ) } )

      oDlg:bStart := {|| oBrwDet:Load() }

   ACTIVATE DIALOG oDlg CENTER

   /*
   Llamda a la funcion que busca el Albaran
   */

   if oDlg:nResult == IDOK .and. Len( aFacturas ) >= 1

      CursorWait()

      /*
      A-adimos los Facturas seleccionado para despues
      */

      for nItem := 1 to Len( aFacturas )
         if ( aFacturas[ nItem, 1 ] )
            if ( dbfAlbCliT )->( dbSeek( aFacturas[ nItem, 2] ) )
               SetFacturadoAlbaranCliente( .t., , dbfAlbCliT, dbfAlbCliL, dbfAlbCliS )
            end if
            aAdd( aNumAlb, aFacturas[ nItem, 2 ] )
         end if
      next

      for nItem := 1 to Len( aFacturas )

         /*
         Cabeceras de Facturas a facturas
         */

         if ( dbfAlbCliT )->( dbSeek( aFacturas[ nItem, 2] ) ) .and. aFacturas[ nItem, 1 ]

            if !empty( ( dbfAlbCliT )->cCodAge ) .and. empty( aTmp[ _CCODAGE ] )
               aGet[ _CCODAGE  ]:cText( ( dbfAlbCliT )->cCodAge )
            end if

            if !empty( ( dbfAlbCliT )->cCodPago ) .and. empty( aTmp[ _CCODPAGO ] )
               aGet[ _CCODPAGO ]:cText( ( dbfAlbCliT )->cCodPago )
            end if

            if ( dbfAlbCliT )->lRecargo
               aGet[ _LRECARGO ]:Click( .t. )
            end if

            if ( dbfAlbCliT )->lOperPv
               aGet[ _LOPERPV ]:Click( .t. )
            end if

            cSuPed               := ( dbfAlbCliT )->cSuPed

         end if

         /*
         Detalle de Facturas a facturas
         */

         if ( dbfAlbCliL )->( dbSeek( aFacturas[ nItem, 2 ] ) ) .and. aFacturas[ nItem, 1 ]

            nNumLin                       := nil
            nPosPrint                     := nil

            if lNumAlb() .or. lNumObr() .or. lSuAlb()

               if nOffSet < nLastNum( dbfTmpLin )
                  ++nOffSet 
               end if

               ( dbfTmpLin )->( dbAppend() )

               cDesAlb                    := ""
               if lNumObr()
                  cDesAlb                 += Alltrim( cNumObr() ) + " " + StrTran( aFacturas[ nItem, 8 ], " ", "" ) + Space( 1 )
                  cDesAlb                 += if( !empty( aFacturas[ nItem, 8 ] ), AllTrim( RetFld( aFacturas[ nItem, 5 ] + aFacturas[ nItem, 8 ], dbfObrasT, "cNomObr" ) ), "" )
               end if
               if lNumAlb()
                  cDesAlb                 += Alltrim( cNumAlb() ) + " " + Left( aFacturas[ nItem, 2 ], 1 ) + "/" + AllTrim( Substr( aFacturas[ nItem, 2 ], 2, 9 ) ) + "/" + Right( aFacturas[ nItem, 2 ], 2 ) + Space( 1 )
               end if
               if lSuAlb()
                  cDesAlb                 += Alltrim( cSuAlb()  ) + " " + StrTran( aFacturas[ nItem, 3 ], " ", "" ) + Space( 1 )
               end if
               cDesAlb                    += " - Fecha " + Dtoc( aFacturas[ nItem, 4] )

               ( dbfTmpLin )->cDetalle    := cDesAlb
               ( dbfTmpLin )->mLngDes     := cDesAlb
               ( dbfTmpLin )->lControl    := .t.
               ( dbfTmpLin )->nNumLin     := nOffSet
               ( dbfTmpLin )->nPosPrint   := nOffSet

            end if

            while ( ( dbfAlbCliL )->cSerAlb + str( ( dbfAlbCliL )->nNumAlb ) + ( dbfAlbCliL )->cSufAlb == aFacturas[ nItem, 2] .and. !( dbfAlbCliL )->( Eof() ) )

               if nNumLin != ( dbfAlbCliL )->nNumLin .and. !( dbfAlbCliL )->lControl
                  ++nOffSet
                  nNumLin              := ( dbfAlbCliL )->nNumLin
               end if

               appendRegisterByHash( dbfAlbCliL, dbfTmpLin, {  "nNumLin"   => nOffSet,;
                                                               "nPosPrint" => nOffSet,;
                                                               "cCodAlb"   => ( dbfAlbCliT )->cSerAlb + str( ( dbfAlbCliT )->nNumAlb ) + ( dbfAlbCliT )->cSufAlb,;
                                                               "dFecFac"   => ( dbfAlbCliT )->dFecAlb,;
                                                               "tFecFac"   => ( dbfAlbCliT )->tFecAlb,;
                                                               "cSuPed"    => cSuPed,;
                                                               "cCodObr"   => aFacturas[ nItem, 8 ] } )

               /*
               Pasamos series de Facturas-------------------------------------
               */

               if ( dbfAlbCliS )->( dbSeek( ( dbfAlbCliL )->cSerAlb + str( ( dbfAlbCliL )->nNumAlb ) + ( dbfAlbCliL )->cSufAlb + str( ( dbfAlbCliL )->nNumLin ) ) )

                  while ( ( dbfAlbCliS )->cSerAlb + str( ( dbfAlbCliS )->nNumAlb ) + ( dbfAlbCliS )->cSufAlb + str( ( dbfAlbCliS )->nNumLin ) == ( dbfAlbCliL )->cSerAlb + str( ( dbfAlbCliL )->nNumAlb ) + ( dbfAlbCliL )->cSufAlb + str( ( dbfAlbCliL )->nNumLin ) .and. !( dbfAlbCliS )->( eof() ) )

                     ( dbfTmpSer )->( dbAppend() )

                     ( dbfTmpSer )->nNumLin     := nOffSet
                     ( dbfTmpSer )->cRef        := ( dbfAlbCliS )->cRef
                     ( dbfTmpSer )->cAlmLin     := ( dbfAlbCliS )->cAlmLin
                     ( dbfTmpSer )->lUndNeg     := ( dbfAlbCliS )->lUndNeg
                     ( dbfTmpSer )->cNumSer     := ( dbfAlbCliS )->cNumSer

                     ( dbfAlbCliS )->( dbSkip() )

                  end while

               end if

               ( dbfAlbCliL )->( dbSkip() )

            end while

            /*
            Lineas de descuento------------------------------------------------
            */

            nTotDoc                       += aFacturas[ nItem, 9 ]:nTotalBruto
            nDtoEsp                       += aFacturas[ nItem, 9 ]:nTotalDescuentoGeneral
            nDtoDpp                       += aFacturas[ nItem, 9 ]:nTotalDescuentoProntoPago
            nDtoUno                       += aFacturas[ nItem, 9 ]:nTotalDescuentoUno
            nDtoDos                       += aFacturas[ nItem, 9 ]:nTotalDescuentoDos

            /*
            Total albaran------------------------------------------------------
            */

            if RetFld( cCodCli, D():Clientes( nView ), "lTotAlb" )
               ( dbfTmpLin )->( dbAppend() )
               ( dbfTmpLin )->nNumLin     := ++nOffSet
               ( dbfTmpLin )->nPosPrint   := nOffSet
               ( dbfTmpLin )->mLngDes     := "Total albarán..."
               ( dbfTmpLin )->lTotLin     := .t.
            end if

            ( dbfTmpLin )->( dbGoTop() )

            /*
            Pasamos las incidencias del albarán--------------------------------
            */

            if ( nMode != DUPL_MODE ) .and. ( dbfAlbCliI )->( dbSeek( aFacturas[ nItem, 2 ] ) )
               while ( dbfAlbCliI )->cSerAlb + str( ( dbfAlbCliI )->nNumAlb ) + ( dbfAlbCliI )->cSufAlb == aFacturas[ nItem, 2 ] .and. !( dbfAlbCliI )->( Eof() )
                  dbPass( dbfAlbCliI, dbfTmpInc, .t. )
                  ( dbfAlbCliI )->( dbSkip() )
               end while
            end if

            ( dbfAlbCliI )->( dbGoTop() )

            /*
            Pasamos los documentos de los pedidos------------------------------
            */

            if ( dbfAlbCliD )->( dbSeek( aFacturas[ nItem, 2 ] ) )
               while ( dbfAlbCliD )->cSerAlb + str( ( dbfAlbCliD )->nNumAlb ) + ( dbfAlbCliD )->cSufAlb == aFacturas[ nItem, 2 ] .and. !( dbfAlbCliD )->( Eof() )
                  dbPass( dbfAlbCliD, dbfTmpDoc, .t. )
                  ( dbfAlbCliD )->( dbSkip() )
               end while
            end if

            ( dbfAlbCliD )->( dbGoTop() )

            oBrw:Refresh()

         end if

         ( dbfTmpLin )->( dbGoTop() )
         ( dbfTmpPgo )->( dbGoTop() )
         ( dbfTmpInc )->( dbGoTop() )
         ( dbfTmpDoc )->( dbGoTop() )

      next

      /*
      Agrupamos todas las entregas a cuenta en un recibo------------------------
      */

      for nItem := 1 to Len( aFacturas )

         if aFacturas[ nItem, 1] .and. ( dbfAlbCliP )->( dbSeek( aFacturas[ nItem, 2 ] ) )

            while ( dbfAlbCliP )->cSerAlb + str( ( dbfAlbCliP )->nNumAlb ) + ( dbfAlbCliP )->cSufAlb == aFacturas[ nItem, 2] .and. !( dbfAlbCliP )->( Eof() )

               nTotEntAlb     += ( dbfAlbCliP )->nImporte

               ( dbfAlbCliP )->( dbSkip() )

            end while

         end if

         ( dbfAlbCliP )->( dbGoTop() )

      next

      /*
      Hacemos el append del recibo---------------------------------------------
      */

      if nTotEntAlb != 0

         ( dbfTmpPgo )->( dbAppend() )

         ( dbfTmpPgo )->lCobrado := .t.
         ( dbfTmpPgo )->lConPgo  := .f.
         ( dbfTmpPgo )->lRecImp  := .f.
         ( dbfTmpPgo )->lRecDto  := .f.
         ( dbfTmpPgo )->nNumRec  := ( dbfTmpPgo )->( RecNo() )
         ( dbfTmpPgo )->cCodCaj  := aTmp[ _CCODCAJ ]
         ( dbfTmpPgo )->cCodCli  := aTmp[ _CCODCLI ]
         ( dbfTmpPgo )->cNomCli  := aTmp[ _CNOMCLI ]
         ( dbfTmpPgo )->dEntrada := aTmp[ _DFECFAC ]
         ( dbfTmpPgo )->dPreCob  := aTmp[ _DFECFAC ]
         ( dbfTmpPgo )->dFecVto  := aTmp[ _DFECFAC ]
         ( dbfTmpPgo )->nImporte := nTotEntAlb
         ( dbfTmpPgo )->nImpCob  := nTotEntAlb
         ( dbfTmpPgo )->cDivPgo  := aTmp[ _CDIVFAC ]
         ( dbfTmpPgo )->nVdvPgo  := aTmp[ _NVDVFAC ]
         ( dbfTmpPgo )->cCodAge  := aTmp[ _CCODAGE ]
         ( dbfTmpPgo )->cTurRec  := ""
         ( dbfTmpPgo )->lCloPgo  := .t.
         ( dbfTmpPgo )->cCodPgo  := aTmp[ _CCODPAGO ]
         ( dbfTmpPgo )->cDescrip := "Suma entregas a cuenta de Facturas"
         ( dbfTmpPgo )->( dbUnLock() )

      end if

      /*
      No permitimos mas Facturas----------------------------------------------
      */

      aGet[ _CNUMALB ]:Hide()
      aGet[ _CNUMPED ]:Hide()
      aGet[ _CNUMPRE ]:Hide()

      oBtnPre:Disable()
      oBtnPed:Disable()
      oBtnAlb:Disable()

      oBtnGrp:bWhen  := {|| .f. }

      /*
      Tratamiento de los descuentos--------------------------------------------
      */

      if !empty( nDtoEsp )
         aGet[ _NDTOESP ]:cText( nDtoEsp / nTotDoc * 100 )
         nTotDoc  -= nDtoEsp
      end if

      if !empty( nDtoDpp )
         aGet[ _NDPP ]:cText( nDtoDpp / nTotDoc * 100 )
         nTotDoc  -= nDtoDpp
      end if

      if !empty( nDtoUno )
         aGet[ _NDTOUNO ]:cText( nDtoUno / nTotDoc * 100 )
         nTotDoc  -= nDtoUno
      end if

      if !empty( nDtoDos )
         aGet[ _NDTODOS ]:cText( nDtoDos / nTotDoc * 100 )
      end if

      HideImportacion( aGet )

      /*
      Recalculo del total del factura------------------------------------------
      */

      RecalculaTotal( aTmp )

      CursorWE()

   end if

   /*
   Guardamos los datos del browse----------------------------------------------
   */

   oBrwDet:CloseData()

   oBmp:End()

RETURN .T.

//---------------------------------------------------------------------------//

static function nTotalFacturasAgrupar( aFacturas )

   local aAlbaran
   local nTotal   := 0

   for each aAlbaran in aFacturas

      if aAlbaran[1]
         nTotal      +=  aAlbaran[9]:nTotalDocumento
      end if

   next

return Trans( nTotal, cPorDiv )

//----------------------------------------------------------------------------//

Static Function EdtRecMenu( aTmp, oDlg )

   MENU oMenu

      MENUITEM    "&1. Rotor"

         MENU

            MENUITEM    "&1. Campos extra [F9]";
               MESSAGE  "Mostramos y rellenamos los campos extra para la familia" ;
               RESOURCE "gc_form_plus2_16" ;
               ACTION   ( oDetCamposExtra:Play( Space( 1 ) ) )

            MENUITEM    "&2. Visualizar presupuesto";
               MESSAGE  "Visualiza el presupueso del que proviene" ;
               RESOURCE "gc_notebook_user_16" ;
               ACTION   ( if( !empty( aTmp[ _CNUMPRE ] ), ZooPreCli( aTmp[ _CNUMPRE ] ), MsgStop( "No hay presupusto asociado" ) ) )

            SEPARATOR

            MENUITEM    "&3. Visualizar pedido";
               MESSAGE  "Visualiza el pedido del que proviene" ;
               RESOURCE "gc_clipboard_empty_user_16" ;
               ACTION   ( if( !empty( aTmp[ _CNUMPED ] ), ZooPedCli( aTmp[ _CNUMPED ] ), MsgStop( "No hay pedido asociado" ) ) );

            SEPARATOR

            MENUITEM    "&4. Visualizar albarán";
               MESSAGE  "Visualiza el albarán del que proviene" ;
               RESOURCE "gc_document_empty_16" ;
               ACTION   ( if( !empty( aTmp[ _CNUMALB ] ), ZooAlbCli( aTmp[ _CNUMALB ] ), MsgStop( "No hay albarán asociado" ) ) );

            SEPARATOR

            MENUITEM    "&5. Generar anticipo";
               MESSAGE  "Genera factura de anticipo" ;
               RESOURCE "gc_document_text_money2_16" ;
               ACTION   ( if( !empty( aTmp[ _CCODCLI ] ), CreateAntCli( aTmp[ _CCODCLI ] ), msgStop("Debe seleccionar un cliente para hacer una factura de anticipo" ) ) )

            MENUITEM    "&6. Modificar cliente";
               MESSAGE  "Modifica la ficha del cliente" ;
               RESOURCE "gc_user_16" ;
               ACTION   ( if( !empty( aTmp[ _CCODCLI ] ), EdtCli( aTmp[ _CCODCLI ] ), MsgStop( "Código de cliente vacío" ) ) )

            MENUITEM    "&7. Modificar cliente contactos";
               MESSAGE  "Modifica la ficha del cliente en contactos" ;
               RESOURCE "gc_user_16" ;
               ACTION   ( if( !empty( aTmp[ _CCODCLI ] ), EdtCli( aTmp[ _CCODCLI ], , 5 ), MsgStop( "Código de cliente vacío" ) ) )

            MENUITEM    "&8. Informe de cliente";
               MESSAGE  "Informe de cliente" ;
               RESOURCE "Info16" ;
               ACTION   ( if( !empty( aTmp[ _CCODCLI ] ), InfCliente( aTmp[ _CCODCLI ] ), MsgStop( "Código de cliente vacío" ) ) );

            MENUITEM    "&9. Modificar Dirección";
               MESSAGE  "Modifica ficha de la Dirección" ;
               RESOURCE "gc_worker2_16" ;
               ACTION   ( if( !empty( aTmp[ _CCODOBR ] ), EdtObras( aTmp[ _CCODCLI ], aTmp[ _CCODOBR ], dbfObrasT ), MsgStop( "Código de obra vacío" ) ) );

            SEPARATOR

            MENUITEM    "&10. Informe del documento";
               MESSAGE  "Informe del documento" ;
               RESOURCE "Info16" ;
               ACTION   ( TTrazaDocumento():Activate( FAC_CLI, aTmp[ _CSERIE ] + str( aTmp[ _NNUMFAC ] ) + aTmp[ _CSUFFAC ] ) );

            MENUITEM    "&11. Firmar documento";
               MESSAGE  "Firmar documento" ;
               RESOURCE "gc_sign_document_16" ;
               ACTION   ( if( empty( aTmp[ _MFIRMA ] ) .or.  msgNoYes( "El documento ya esta firmado, ¿Desea voler a firmarlo?" ),;
                              aTmp[ _MFIRMA ] := signatureToMemo(),;
                              ) ) 

         ENDMENU

   ENDMENU

   oDlg:SetMenu( oMenu )

RETURN ( oMenu )

//--------------------------------------------------------------------------//

Static Function nEstadoIncidencia( cNumFac )

   local nEstado  := 0
   local aBmp     := ""

   if ( dbfFacCliI )->( dbSeek( cNumFac ) )

      while ( dbfFacCliI )->cSerie + str( ( dbfFacCliI )->nNumFac ) + ( dbfFacCliI )->cSufFac == cNumFac .and. !( dbfFacCliI )->( Eof() )

         if ( dbfFacCliI )->lListo
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

         ( dbfFacCliI )->( dbSkip() )

      end while

   end if

Return ( nEstado )

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

   /*comprobamos que no está vacío el artículo*/

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

Static Function FacCliNotas()

   local cObserv  := ""
   local aData    := {}

   aAdd( aData, "Factura " + ( D():FacturasClientes( nView ) )->cSerie + "/" + AllTrim( str( ( D():FacturasClientes( nView ) )->nNumFac ) ) + "/" + Alltrim( ( D():FacturasClientes( nView ) )->cSufFac ) + " de " + Rtrim( ( D():FacturasClientes( nView ) )->cNomCli ) )
   aAdd( aData, FAC_CLI )
   aAdd( aData, ( D():FacturasClientes( nView ) )->cCodCli )
   aAdd( aData, ( D():FacturasClientes( nView ) )->cNomCli )
   aAdd( aData, ( D():FacturasClientes( nView ) )->cSerie + str( ( D():FacturasClientes( nView ) )->nNumFac ) + ( D():FacturasClientes( nView ) )->cSufFac )

   if ( D():Clientes( nView ) )->( dbSeek( ( D():FacturasClientes( nView ) )->cCodCli ) )

      if !empty( ( D():Clientes( nView ) )->cPerCto )
         cObserv  += Rtrim( ( D():Clientes( nView ) )->cPerCto ) + Space( 1 )
      end if

      if !empty( ( D():Clientes( nView ) )->Telefono )
         cObserv  += "Télefono : " + Rtrim( ( D():Clientes( nView ) )->Telefono ) + Space( 1 )
      end if

      if !empty( ( D():Clientes( nView ) )->Movil )
         cObserv  += "Móvil : " + Rtrim( ( D():Clientes( nView ) )->Movil ) + Space( 1 )
      end if

      if !empty( ( D():Clientes( nView ) )->Fax )
         cObserv  += "Fax : " + Rtrim( ( D():Clientes( nView ) )->Fax ) + Space( 1 )
      end if

   end if

   aAdd( aData, cObserv )

   GenerarNotas( aData )

Return ( nil )

//---------------------------------------------------------------------------//

STATIC FUNCTION DupSerie( oWndBrw )

   local oDlg
   local oSerIni
   local oSerFin
   local oTxtDup
   local nTxtDup     := 0
   local nRecno      := ( D():FacturasClientes( nView ) )->( Recno() )
   local nOrdAnt     := ( D():FacturasClientes( nView ) )->( OrdSetFocus( 1 ) )
   local oDesde      := TDesdeHasta():Init( ( D():FacturasClientes( nView ) )->cSerie, ( D():FacturasClientes( nView ) )->nNumFac, ( D():FacturasClientes( nView ) )->cSufFac, GetSysDate() )
   local lCancel     := .f.
   local oBtnAceptar
   local oBtnCancel
   local oFecDoc
   local cFecDoc     := GetSysDate()
   local oActual
   local lActual     := .f.

   DEFINE DIALOG oDlg ;
      RESOURCE "DUPSERDOC" ;
      TITLE    "Duplicar series de facturas" ;
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

   REDEFINE CHECKBOX oActual VAR lActual ;
      ID       210 ;
      OF       oDlg

   REDEFINE GET oFecDoc VAR cFecDoc ;
      ID       200 ;
      SPINNER ;
      OF       oDlg

   REDEFINE BUTTON oBtnAceptar ;
      ID       IDOK ;
      OF       oDlg ;
      ACTION   ( DupStart( oDesde, oDlg, oBtnAceptar, oBtnCancel, oTxtDup, @lCancel, lActual, cFecDoc ) )

   REDEFINE BUTTON oBtnCancel ;
      ID       IDCANCEL ;
      OF       oDlg ;
      CANCEL ;
      ACTION   ( lCancel := .t., oDlg:end() )

 REDEFINE APOLOMETER oTxtDup VAR nTxtDup ;
      ID       160 ;
      NOPERCENTAGE ;
      TOTAL    ( D():FacturasClientes( nView ) )->( OrdKeyCount() ) ;
      OF       oDlg

      oDlg:AddFastKey( VK_F5, {|| DupStart( oDesde, oDlg, oBtnAceptar, oBtnCancel, oTxtDup, @lCancel, lActual, cFecDoc ) } )

   ACTIVATE DIALOG oDlg CENTER VALID ( lCancel )

   ( D():FacturasClientes( nView ) )->( dbGoTo( nRecNo ) )
   ( D():FacturasClientes( nView ) )->( ordSetFocus( nOrdAnt ) )

   oWndBrw:SetFocus()
   oWndBrw:Refresh()

RETURN NIL

//--------------------------------------------------------------------------//

STATIC FUNCTION DupStart( oDesde, oDlg, oBtnAceptar, oBtnCancel, oTxtDup, lCancel, lActual, cFecDoc )

   local nOrd
   local nDuplicados    := 0
   local nProcesed      := 0

   oBtnAceptar:Hide()
   oBtnCancel:bAction   := {|| lCancel := .t. }

   if oDesde:nRadio == 1

      nOrd              := ( D():FacturasClientes( nView ) )->( OrdSetFocus( "nNumFac" ) )

      ( D():FacturasClientes( nView ) )->( dbSeek( oDesde:cNumeroInicio(), .t. ) )

      while !lCancel .and. ( D():FacturasClientes( nView ) )->( !eof() )

         if ( D():FacturasClientes( nView ) )->cSerie  >= oDesde:cSerieInicio  .and.;
            ( D():FacturasClientes( nView ) )->cSerie  <= oDesde:cSerieFin     .and.;
            ( D():FacturasClientes( nView ) )->nNumFac >= oDesde:nNumeroInicio .and.;
            ( D():FacturasClientes( nView ) )->nNumFac <= oDesde:nNumeroFin    .and.;
            ( D():FacturasClientes( nView ) )->cSufFac >= oDesde:cSufijoInicio .and.;
            ( D():FacturasClientes( nView ) )->cSufFac <= oDesde:cSufijoFin

            ++nDuplicados

            oTxtDup:cText  := "Duplicando : " + ( D():FacturasClientes( nView ) )->cSerie + "/" + Alltrim( str( ( D():FacturasClientes( nView ) )->nNumFac ) ) + "/" + ( D():FacturasClientes( nView ) )->cSufFac

            DupFactura( lActual, cFecDoc )

         end if

         ( D():FacturasClientes( nView ) )->( dbSkip() )

         ++nProcesed

         oTxtDup:Set( nProcesed )

      end do

      ( D():FacturasClientes( nView ) )->( OrdSetFocus( nOrd ) )

   else

      nOrd              := ( D():FacturasClientes( nView ) )->( OrdSetFocus( "dFecFac" ) )

      ( D():FacturasClientes( nView ) )->( dbSeek( oDesde:dFechaInicio, .t. ) )

      while !lCancel .and. ( D():FacturasClientes( nView ) )->( !eof() )

         if ( D():FacturasClientes( nView ) )->dFecFac >= oDesde:dFechaInicio  .and.;
            ( D():FacturasClientes( nView ) )->dFecFac <= oDesde:dFechaFin

            ++nDuplicados

            oTxtDup:cText  := "Duplicando : " + ( D():FacturasClientes( nView ) )->cSerie + "/" + Alltrim( str( ( D():FacturasClientes( nView ) )->nNumFac ) ) + "/" + ( D():FacturasClientes( nView ) )->cSufFac

            DupFactura( lActual, cFecDoc )

         end if

         ( D():FacturasClientes( nView ) )->( dbSkip() )

         ++nProcesed

         oTxtDup:Set( nProcesed )

      end do

      ( D():FacturasClientes( nView ) )->( OrdSetFocus( nOrd ) )

   end if

   lCancel              := .t.

   oBtnAceptar:Show()

   if lCancel
      msgStop( "Total de registros duplicados : " + str( nDuplicados ), "Proceso cancelado" )
   else
      msgInfo( "Total de registros duplicados : " + str( nDuplicados ), "Proceso finalizado" )
   end if

RETURN ( oDlg:End() )

//---------------------------------------------------------------------------//

STATIC FUNCTION FacRecDup( cDbf, xField1, xField2, xField3, lCab, lPag, lActual, cFecDoc )

   local nRec           := ( cDbf )->( Recno() )
   local aTabla         := {}
   local nOrdAnt

   DEFAULT lCab         := .f.
   DEFAULT lPag         := .f.
   DEFAULT lActual      := .f.

   aTabla               := DBScatter( cDbf )
   aTabla[ _CSERIE  ]   := xField1
   aTabla[ _NNUMFAC ]   := xField2
   aTabla[ _CSUFFAC ]   := xField3

   if lCab

      if !lActual
         aTabla[ _DFECFAC  ]  := cFecDoc
      end if

      aTabla[ _CTURFAC     ]  := cCurSesion()
      aTabla[ _CCODCAJ     ]  := oUser():cCaja()
      aTabla[ _LCONTAB     ]  := .f.
      aTabla[ _CGUID       ]  := ""
      aTabla[ _CCONGUID    ]  := ""
      aTabla[ _DFECENT     ]  := Ctod("")
      aTabla[ _LIMPALB     ]  := .f.
      aTabla[ _CNUMALB     ]  := Space( 12 )
      aTabla[ _CNUMPED     ]  := Space( 12 )
      aTabla[ _CNUMPRE     ]  := Space( 12 )
      aTabla[ _CABNFAC     ]  := Space( 12 )
      aTabla[ _CANTFAC     ]  := Space( 12 )
      aTabla[ _LSNDDOC     ]  := .t.
      aTabla[ _CDOCORG     ]  := Space( 10 )
      aTabla[ _LCLOFAC     ]  := .f.
      aTabla[ _CCODUSR     ]  := cCurUsr()
      aTabla[ _DFECCRE     ]  := Date()
      aTabla[ _CTIMCRE     ]  := Time()
      aTabla[ _LIMPRIMIDO  ]  := .f.
      aTabla[ _DFECIMP     ]  := Ctod("")
      aTabla[ _CHORIMP     ]  := Space( 5 )
      aTabla[ _CCODDLG     ]  := oUser():cDelegacion()

      nOrdAnt                 := ( cDbf )->( OrdSetFocus( "NNUMFAC" ) )

   end if

   if lPag

      if !lActual
         aTabla[ ( D():FacturasClientesCobros( nView ) )->( FieldPos( "dPreCob") )  ]      := cFecDoc
         if aTabla[ ( D():FacturasClientesCobros( nView ) )->( FieldPos( "lCobrado" ) ) ]
            aTabla[ ( D():FacturasClientesCobros( nView ) )->( FieldPos( "dEntrada" ) ) ]  := cFecDoc
         else
            aTabla[ ( D():FacturasClientesCobros( nView ) )->( FieldPos( "dEntrada" ) ) ]  := Ctod("")
         end if
      end if

      aTabla[ ( D():FacturasClientesCobros( nView ) )->( FieldPos( "cCodCaj" ) )  ]  := oUser():cCaja()
      aTabla[ ( D():FacturasClientesCobros( nView ) )->( FieldPos( "cTurRec" ) )  ]  := cCurSesion()

      aTabla[ ( D():FacturasClientesCobros( nView ) )->( FieldPos( "lConPgo" ) )  ]  := .f.
      aTabla[ ( D():FacturasClientesCobros( nView ) )->( FieldPos( "lRecImp" ) )  ]  := .f.
      aTabla[ ( D():FacturasClientesCobros( nView ) )->( FieldPos( "lRecDto" ) )  ]  := .f.
      aTabla[ ( D():FacturasClientesCobros( nView ) )->( FieldPos( "dFecDto" ) )  ]  := Ctod("")
      aTabla[ ( D():FacturasClientesCobros( nView ) )->( FieldPos( "lCloPgo" ) )  ]  := .f.
      aTabla[ ( D():FacturasClientesCobros( nView ) )->( FieldPos( "dFecImp" ) )  ]  := Ctod("")
      aTabla[ ( D():FacturasClientesCobros( nView ) )->( FieldPos( "cHorImp" ) )  ]  := Space( 5 )
      aTabla[ ( D():FacturasClientesCobros( nView ) )->( FieldPos( "dFecVto" ) )  ]  := cFecDoc

   end if

   if dbLock( cDbf, .t. )
      aEval( aTabla, { | uTmp, n | ( cDbf )->( fieldPut( n, uTmp ) ) } )
      ( cDbf )->( dbUnLock() )
   end if

   if lCab
      ( cDbf )->( OrdSetFocus( nOrdAnt ) )
   end if

   ( cDbf )->( dbGoTo( nRec ) )

RETURN ( .t. )

//---------------------------------------------------------------------------//

STATIC FUNCTION DupFactura( lActual, cFecDoc )

   local nNewNumFac  := 0

   // Recogemos el nuevo numero de factura--------------------------------------

   nNewNumFac        := nNewDoc( ( D():FacturasClientes( nView ) )->cSerie, D():FacturasClientes( nView ), "nFacCli", 9, D():Contadores( nView ) )

   // Duplicamos las cabeceras--------------------------------------------------

   FacRecDup( D():FacturasClientes( nView ), ( D():FacturasClientes( nView ) )->cSerie, nNewNumFac, ( D():FacturasClientes( nView ) )->cSufFac, .t., .f., lActual, cFecDoc )

   // Duplicamos las lineas del documento---------------------------------------

   if ( D():FacturasClientesLineas( nView ) )->( dbSeek( ( D():FacturasClientesId( nView ) ) ) )

      while ( D():FacturasClientesId( nView ) ) == D():FacturasClientesLineasId( nView ) .and. !( D():FacturasClientesLineas( nView ) )->( eof() )

         FacRecDup( D():FacturasClientesLineas( nView ), ( D():FacturasClientes( nView ) )->cSerie, nNewNumFac, ( D():FacturasClientes( nView ) )->cSufFac, .f., .f. )

         ( D():FacturasClientesLineas( nView ) )->( dbSkip() )

      end while

   end if

   //Duplicamos los pagos------------------------------------------------------

   if ( D():FacturasClientesCobros( nView ) )->( dbSeek( ( D():FacturasClientes( nView ) )->cSerie + str( ( D():FacturasClientes( nView ) )->nNumFac ) + ( D():FacturasClientes( nView ) )->cSufFac ) )

      while ( D():FacturasClientes( nView ) )->cSerie + str( ( D():FacturasClientes( nView ) )->nNumFac ) + ( D():FacturasClientes( nView ) )->cSufFac == ( D():FacturasClientesCobros( nView ) )->cSerie + str( ( D():FacturasClientesCobros( nView ) )->nNumFac ) + ( D():FacturasClientesCobros( nView ) )->cSufFac .and. ;
            !( D():FacturasClientesCobros( nView ) )->( Eof() )

         FacRecDup( D():FacturasClientesCobros( nView ), ( D():FacturasClientes( nView ) )->cSerie, nNewNumFac, ( D():FacturasClientes( nView ) )->cSufFac, .f., .t., lActual, cFecDoc )

         ( D():FacturasClientesCobros( nView ) )->( dbSkip() )

      end while

   end if

   //Duplicamos los documentos-------------------------------------------------

   if ( dbfFacCliD )->( dbSeek( ( D():FacturasClientes( nView ) )->cSerie + str( ( D():FacturasClientes( nView ) )->nNumFac ) + ( D():FacturasClientes( nView ) )->cSufFac ) )

      while ( D():FacturasClientes( nView ) )->cSerie + str( ( D():FacturasClientes( nView ) )->nNumFac ) + ( D():FacturasClientes( nView ) )->cSufFac == ( dbfFacCliD )->cSerie + str( ( dbfFacCliD )->nNumFac ) + ( dbfFacCliD )->cSufFac .and. ;
            !( dbfFacCliD )->( Eof() )

         FacRecDup( dbfFacCliD, ( D():FacturasClientes( nView ) )->cSerie, nNewNumFac, ( D():FacturasClientes( nView ) )->cSufFac, .f., .t. )

         ( dbfFacCliD )->( dbSkip() )

      end while

   end if

RETURN ( .t. )

//---------------------------------------------------------------------------//

STATIC FUNCTION SetDialog( aGet, oSayDias, oSayGetRnt, oGetRnt )

   if !empty( oTipFac )

      if oTipFac:nAt == 2
         aGet[ _DFECENTR ]:Show()
         aGet[ _DFECSAL  ]:Show()
         oSayDias:Show()
      else
         aGet[ _DFECENTR ]:Hide()
         aGet[ _DFECSAL  ]:Hide()
         oSayDias:Hide()
      end if

      aGet[ _DFECENTR ]:Refresh()
      aGet[ _DFECSAL  ]:Refresh()

      oSayDias:Refresh()

   end if

   if !lAccArticulo() .or. oUser():lNotRentabilidad()

      if !empty( oSayGetRnt )
         oSayGetRnt:Hide()
      end if

      if !empty( oGetRnt )
         oGetRnt:Hide()
      end if

   end if

Return nil

//---------------------------------------------------------------------------//

STATIC FUNCTION ValidaMedicion( aTmp, aGet )

   local cNewUndMed

      if !empty( aGet[ _CUNIDAD ] )
      cNewUndMed  := aGet[ _CUNIDAD ]:VarGet
   else
      cNewUndMed  := aTmp[ _CUNIDAD ]
      end if

   /*
   Cargamos el codigo de las unidades---------------------------------
   */

   if ( empty( cOldUndMed ) .or. cOldUndMed != cNewUndMed )

      if oUndMedicion:oDbf:Seek( aTmp[ _CUNIDAD ] )

         if oUndMedicion:oDbf:nDimension >= 1 .and. !empty( oUndMedicion:oDbf:cTextoDim1 )
            if !empty( aGet[ ( D():FacturasClientesLineas( nView ) )->( fieldpos( "nMedUno" ) ) ] )
               aGet[ ( D():FacturasClientesLineas( nView ) )->( fieldpos( "nMedUno" ) ) ]:oSay:SetText( oUndMedicion:oDbf:cTextoDim1 )
               aGet[ ( D():FacturasClientesLineas( nView ) )->( fieldpos( "nMedUno" ) ) ]:cText( ( D():Articulos( nView ) )->nLngArt )
               aGet[ ( D():FacturasClientesLineas( nView ) )->( fieldpos( "nMedUno" ) ) ]:Show()
            else
               aTmp[ ( D():FacturasClientesLineas( nView ) )->( fieldpos( "nMedUno" ) ) ]  := ( D():Articulos( nView ) )->nLngArt
            end if
         else
            if !empty( aGet[ ( D():FacturasClientesLineas( nView ) )->( fieldpos( "nMedUno" ) ) ] )
               aGet[ ( D():FacturasClientesLineas( nView ) )->( fieldpos( "nMedUno" ) ) ]:cText( 0 )
               aGet[ ( D():FacturasClientesLineas( nView ) )->( fieldpos( "nMedUno" ) ) ]:Hide()
            else
               aTmp[ ( D():FacturasClientesLineas( nView ) )->( fieldpos( "nMedUno" ) ) ]  := 0
            end if
         end if

         if oUndMedicion:oDbf:nDimension >= 2 .and. !empty( oUndMedicion:oDbf:cTextoDim2 )
            if !empty( aGet[ ( D():FacturasClientesLineas( nView ) )->( fieldpos( "nMedDos" ) ) ] )
               aGet[ ( D():FacturasClientesLineas( nView ) )->( fieldpos( "nMedDos" ) ) ]:oSay:SetText( oUndMedicion:oDbf:cTextoDim2 )
               aGet[ ( D():FacturasClientesLineas( nView ) )->( fieldpos( "nMedDos" ) ) ]:cText( ( D():Articulos( nView ) )->nAltArt )
               aGet[ ( D():FacturasClientesLineas( nView ) )->( fieldpos( "nMedDos" ) ) ]:Show()
            else
               aTmp[ ( D():FacturasClientesLineas( nView ) )->( fieldpos( "nMedDos" ) ) ]  := ( D():Articulos( nView ) )->nAltArt
            end if
         else
            if !empty( aGet[ ( D():FacturasClientesLineas( nView ) )->( fieldpos( "nMedDos" ) ) ] )
               aGet[ ( D():FacturasClientesLineas( nView ) )->( fieldpos( "nMedDos" ) ) ]:cText( 0 )
               aGet[ ( D():FacturasClientesLineas( nView ) )->( fieldpos( "nMedDos" ) ) ]:Hide()
            else
                 aTmp[ ( D():FacturasClientesLineas( nView ) )->( fieldpos( "nMedDos" ) ) ]  := 0
            end if
         end if

         if oUndMedicion:oDbf:nDimension >= 3 .and. !empty( oUndMedicion:oDbf:cTextoDim3 )
            if !empty( aGet[ ( D():FacturasClientesLineas( nView ) )->( fieldpos( "nMedTre" ) ) ] )
               aGet[ ( D():FacturasClientesLineas( nView ) )->( fieldpos( "nMedTre" ) ) ]:oSay:SetText( oUndMedicion:oDbf:cTextoDim3 )
               aGet[ ( D():FacturasClientesLineas( nView ) )->( fieldpos( "nMedTre" ) ) ]:cText( ( D():Articulos( nView ) )->nAncArt )
               aGet[ ( D():FacturasClientesLineas( nView ) )->( fieldpos( "nMedTre" ) ) ]:Show()
            else
               aTmp[ ( D():FacturasClientesLineas( nView ) )->( fieldpos( "nMedTre" ) ) ]  := ( D():Articulos( nView ) )->nAncArt
            end if
         else
            if !empty( aGet[ ( D():FacturasClientesLineas( nView ) )->( fieldpos( "nMedTre" ) ) ] )
               aGet[ ( D():FacturasClientesLineas( nView ) )->( fieldpos( "nMedTre" ) ) ]:cText( 0 )
               aGet[ ( D():FacturasClientesLineas( nView ) )->( fieldpos( "nMedTre" ) ) ]:Hide()
            else
               aTmp[ ( D():FacturasClientesLineas( nView ) )->( fieldpos( "nMedTre" ) ) ]  := 0
            end if
         end if

      else

         if !empty( aGet[ ( D():FacturasClientesLineas( nView ) )->( fieldpos( "nMedUno" ) ) ] )
            aGet[ ( D():FacturasClientesLineas( nView ) )->( fieldpos( "nMedUno" ) ) ]:Hide()
            aGet[ ( D():FacturasClientesLineas( nView ) )->( fieldpos( "nMedUno" ) ) ]:cText( 0 )
         end if

         if !empty( aGet[ ( D():FacturasClientesLineas( nView ) )->( fieldpos( "nMedDos" ) ) ] )
            aGet[ ( D():FacturasClientesLineas( nView ) )->( fieldpos( "nMedDos" ) ) ]:Hide()
            aGet[ ( D():FacturasClientesLineas( nView ) )->( fieldpos( "nMedDos" ) ) ]:cText( 0 )
         end if

         if !empty( aGet[ ( D():FacturasClientesLineas( nView ) )->( fieldpos( "nMedTre" ) ) ] )
            aGet[ ( D():FacturasClientesLineas( nView ) )->( fieldpos( "nMedTre" ) ) ]:Hide()
            aGet[ ( D():FacturasClientesLineas( nView ) )->( fieldpos( "nMedTre" ) ) ]:cText( 0 )
         end if

      end if

      cOldUndMed := cNewUndMed

   end if

RETURN .t.

//-----------------------------------------------------------------------------

Static Function ChangeTarifa( aTmp, aGet, aTmpFac )

    local nPrePro  := 0

   nPrePro     := nPrePro( aTmp[ _CREF ], aTmp[ _CCODPR1 ], aTmp[ _CVALPR1 ], aTmp[ _CCODPR2 ], aTmp[ _CVALPR2 ], aTmp[ _NTARLIN ], aTmpFac[ _LIVAINC ], dbfArtDiv, aTmpFac[ _CCODTAR ] )

   if nPrePro == 0
      nPrePro  := nRetPreArt( aTmp[ _NTARLIN ], aTmpFac[ _CDIVFAC ], aTmpFac[ _LIVAINC ], D():Articulos( nView ), dbfDiv, dbfKit, dbfIva, , , oNewImp )
   end if

   if nPrePro != 0
      aGet[ _NPREUNIT ]:cText( nPrePro )
   end if

return .t.

//-----------------------------------------------------------------------------

static function loadComisionAgente( aTmp, aGet, aTmpFac )

   local nComisionAgenteTarifa   

   nComisionAgenteTarifa         := nComisionAgenteTarifa( aTmpFac[ _CCODAGE ], aTmp[ _NTARLIN ], nView ) 
   if nComisionAgenteTarifa == 0
      nComisionAgenteTarifa      := aTmpFac[ _NPCTCOMAGE ]
   end if 

   if !empty( aGet[ _NCOMAGE ] )
      aGet[ _NCOMAGE ]:cText( nComisionAgenteTarifa )
   end if

return .t.

//-----------------------------------------------------------------------------

Static Function LoadTrans( aTmp, oGetCod, oGetKgs, oSayTrn )

   local uValor   := oGetCod:VarGet()

   if empty( uValor )

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

Static Function DataReport( oFr )

   /*
   Zona de datos------------------------------------------------------------
   */

   oFr:ClearDataSets()

   oFr:SetWorkArea(     "Facturas", ( D():FacturasClientes( nView ) )->( Select() ), .f., { FR_RB_CURRENT, FR_RB_CURRENT, 0 } )
   oFr:SetFieldAliases( "Facturas", cItemsToReport( aItmFacCli() ) )

   oFr:SetWorkArea(     "Lineas de facturas", ( D():FacturasClientesLineas( nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Lineas de facturas", cItemsToReport( aColFacCli() ) )

   oFr:SetWorkArea(     "Series de lineas de facturas", ( dbfFacCliS )->( Select() ) )
   oFr:SetFieldAliases( "Series de lineas de facturas", cItemsToReport( aSerFacCli() ) )

   oFr:SetWorkArea(     "Entidades de la factura", ( D():FacturasClientesEntidades( nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Entidades de la factura", cItemsToReport( aEntidadesFacCli() ) )

   oFr:SetWorkArea(     "Incidencias de facturas", ( dbfFacCliI )->( Select() ) )
   oFr:SetFieldAliases( "Incidencias de facturas", cItemsToReport( aIncFacCli() ) )

   oFr:SetWorkArea(     "Documentos de facturas", ( dbfFacCliD )->( Select() ) )
   oFr:SetFieldAliases( "Documentos de facturas", cItemsToReport( aFacCliDoc() ) )

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

   oFr:SetWorkArea(     "Agentes", ( D():Agentes( nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Agentes", cItemsToReport( aItmAge() ) )

   oFr:SetWorkArea(     "Formas de pago", ( D():FormasPago( nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Formas de pago", cItemsToReport( aItmFPago() ) )

   oFr:SetWorkArea(     "Transportistas", oTrans:Select() )
   oFr:SetFieldAliases( "Transportistas", cObjectsToReport( oTrans:oDbf ) )

   oFr:SetWorkArea(     "Artículos", ( D():Articulos( nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Artículos", cItemsToReport( aItmArt() ) )

   oFr:SetWorkArea(     "Familias", ( dbfFamilia )->( Select() ) )
   oFr:SetFieldAliases( "Familias", cItemsToReport( aItmFam() ) )

   oFr:SetWorkArea(     "Tipo artículo", oTipArt:Select() )
   oFr:SetFieldAliases( "Tipo artículo", cObjectsToReport( oTipArt:oDbf ) )

   oFr:SetWorkArea(     "Recibos", ( D():FacturasClientesCobros( nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Recibos", cItemsToReport( aItmRecCli() ) )

   oFr:SetWorkArea(     "Anticipos", ( D():AnticiposClientes( nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Anticipos", cItemsToReport( aItmAntCli() ) )

   oFr:SetWorkArea(     "Usuarios", ( dbfUsr )->( Select() ) )
   oFr:SetFieldAliases( "Usuarios", cItemsToReport( aItmUsuario() ) )

   oFr:SetWorkArea(     "Ofertas", ( dbfOferta )->( Select() ) )
   oFr:SetFieldAliases( "Ofertas", cItemsToReport( aItmOfe() ) )

   oFr:SetWorkArea(     "Bancos", ( dbfCliBnc )->( Select() ) )
   oFr:SetFieldAliases( "Bancos", cItemsToReport( aCliBnc() ) )

   oFr:SetWorkArea(     "Unidades de medición",  oUndMedicion:Select() )
   oFr:SetFieldAliases( "Unidades de medición",  cObjectsToReport( oUndMedicion:oDbf ) )

   oFr:SetWorkArea(     "País", oPais:Select() )
   oFr:SetFieldAliases( "País", cObjectsToReport( oPais:oDbf ) )

   oFr:SetWorkArea(     "SAT", ( dbfSatCliT )->( Select() ) )
   oFr:SetFieldAliases( "SAT", cItemsToReport( aItmSatCli() ) )

   oFr:SetWorkArea(     "Impuestos especiales",  oNewImp:Select() )
   oFr:SetFieldAliases( "Impuestos especiales",  cObjectsToReport( oNewImp:oDbf ) )

   // TiposVentasController():Instance():setFastReport( oFr )

   oFr:SetMasterDetail( "Facturas", "Lineas de facturas",                     {|| D():FacturasClientesId( nView ) } )
   oFr:SetMasterDetail( "Facturas", "Incidencias de facturas",                {|| D():FacturasClientesId( nView ) } )
   oFr:SetMasterDetail( "Facturas", "Documentos de facturas",                 {|| D():FacturasClientesId( nView ) } )
   oFr:SetMasterDetail( "Facturas", "Clientes",                               {|| ( D():FacturasClientes( nView ) )->cCodCli } )
   oFr:SetMasterDetail( "Facturas", "Obras",                                  {|| ( D():FacturasClientes( nView ) )->cCodCli + ( D():FacturasClientes( nView ) )->cCodObr } )
   oFr:SetMasterDetail( "Facturas", "Almacenes",                              {|| ( D():FacturasClientes( nView ) )->cCodAlm } )
   oFr:SetMasterDetail( "Facturas", "Rutas",                                  {|| ( D():FacturasClientes( nView ) )->cCodRut } )
   oFr:SetMasterDetail( "Facturas", "Agentes",                                {|| ( D():FacturasClientes( nView ) )->cCodAge } )
   oFr:SetMasterDetail( "Facturas", "Formas de pago",                         {|| ( D():FacturasClientes( nView ) )->cCodPago } )
   oFr:SetMasterDetail( "Facturas", "Transportistas",                         {|| ( D():FacturasClientes( nView ) )->cCodTrn } )
   oFr:SetMasterDetail( "Facturas", "Empresa",                                {|| cCodigoEmpresaEnUso() } )
   oFr:SetMasterDetail( "Facturas", "Recibos",                                {|| D():FacturasClientesId( nView ) } )
   oFr:SetMasterDetail( "Facturas", "Anticipos",                              {|| D():FacturasClientesId( nView ) } )
   oFr:SetMasterDetail( "Facturas", "Usuarios",                               {|| ( D():FacturasClientes( nView ) )->cCodUsr } )
   oFr:SetMasterDetail( "Facturas", "Bancos",                                 {|| ( D():FacturasClientes( nView ) )->cCodCli } )
   oFr:SetMasterDetail( "Facturas", "País",                                   {|| retFld( ( D():FacturasClientes( nView ) )->cCodCli, D():Clientes( nView ), "cCodPai" ) } )

   oFr:SetMasterDetail( "Lineas de facturas", "Artículos",                    {|| SynchronizeDetails() } )
   oFr:SetMasterDetail( "Lineas de facturas", "Familia",                      {|| ( D():FacturasClientesLineas( nView ) )->cCodFam } )
   oFr:SetMasterDetail( "Lineas de facturas", "Tipo artículo",                {|| ( D():FacturasClientesLineas( nView ) )->cCodTip } )
   oFr:SetMasterDetail( "Lineas de facturas", "Ofertas",                      {|| ( D():FacturasClientesLineas( nView ) )->cRef } )
   oFr:SetMasterDetail( "Lineas de facturas", "Unidades de medición",         {|| ( D():FacturasClientesLineas( nView ) )->cUnidad } )
   oFr:SetMasterDetail( "Lineas de facturas", "SAT",                          {|| ( D():FacturasClientesLineas( nView ) )->cNumSat } )
   oFr:SetMasterDetail( "Lineas de facturas", "Impuestos especiales",         {|| ( D():FacturasClientesLineas( nView ) )->cCodImp } )
   oFr:SetMasterDetail( "Lineas de facturas", "Series de lineas de facturas", {|| D():FacturasClientesLineasId( nView ) + str( ( D():FacturasClientesLineas( nView ) )->nNumLin ) } )

   oFr:SetResyncPair(   "Facturas", "Lineas de facturas" )
   oFr:SetResyncPair(   "Facturas", "Incidencias de facturas" )
   oFr:SetResyncPair(   "Facturas", "Documentos de facturas" )
   oFr:SetResyncPair(   "Facturas", "Empresa" )
   oFr:SetResyncPair(   "Facturas", "Clientes" )
   oFr:SetResyncPair(   "Facturas", "Obras" )
   oFr:SetResyncPair(   "Facturas", "Almacenes" )
   oFr:SetResyncPair(   "Facturas", "Rutas" )
   oFr:SetResyncPair(   "Facturas", "Agentes" )
   oFr:SetResyncPair(   "Facturas", "Formas de pago" )
   oFr:SetResyncPair(   "Facturas", "Transportistas" )
   oFr:SetResyncPair(   "Facturas", "Recibos" )
   oFr:SetResyncPair(   "Facturas", "Anticipos" )
   oFr:SetResyncPair(   "Facturas", "Usuarios" )
   oFr:SetResyncPair(   "Facturas", "Bancos" )
   oFr:SetResyncPair(   "Facturas", "País" )

   oFr:SetResyncPair(   "Lineas de facturas", "Artículos" )
   oFr:SetResyncPair(   "Lineas de facturas", "Familia" )
   oFr:SetResyncPair(   "Lineas de facturas", "Tipo artículo" )
   oFr:SetResyncPair(   "Lineas de facturas", "Ofertas" )
   oFr:SetResyncPair(   "Lineas de facturas", "Unidades de medición" )
   oFr:SetResyncPair(   "Lineas de facturas", "SAT" )
   oFr:SetResyncPair(   "Lineas de facturas", "Impuestos especiales" )
   oFr:SetResyncPair(   "Lineas de facturas", "Series de lineas de facturas" )

Return nil

//---------------------------------------------------------------------------//

Static Function SynchronizeDetails()

   // TiposVentasController():Instance():findByIdInRowSet( ( D():FacturasClientesLineas( nView ) )->id_tipo_v )

Return ( ( D():FacturasClientesLineas( nView ) )->cRef )

//---------------------------------------------------------------------------//

Static Function VariableReport( oFr )

   oFr:DeleteCategory(  "Facturas" )
   oFr:DeleteCategory(  "Lineas de facturas" )

   /*
   creación de variables----------------------------------------------------
   */

   oFr:AddVariable(     "Facturas",             "Identificador de factura",            "CallHbFunc('FacturasClientesId')" )
   oFr:AddVariable(     "Facturas",             "Total bruto",                         "GetHbVar('nTotBrt')" )
   oFr:AddVariable(     "Facturas",             "Total factura",                       "GetHbVar('nTotFac')" )
   oFr:AddVariable(     "Facturas",             "Total factura texto",                 "CallHbFunc('cTotFacCli')" )
   oFr:AddVariable(     "Facturas",             "Total descuento",                     "GetHbVar('nTotDto')" )
   oFr:AddVariable(     "Facturas",             "Total descuento pronto pago",         "GetHbVar('nTotDpp')" )
   oFr:AddVariable(     "Facturas",             "Total descuentos",                    "GetHbVar('nTotalDto')" )
   oFr:AddVariable(     "Facturas",             "Total neto",                          "GetHbVar('nTotNet')" )
   oFr:AddVariable(     "Facturas",             "Total primer descuento definible",    "GetHbVar('nTotUno')" )
   oFr:AddVariable(     "Facturas",             "Total segundo descuento definible",   "GetHbVar('nTotDos')" )
   oFr:AddVariable(     "Facturas",             "Total " + cImp(),                     "GetHbVar('nTotIva')" )
   oFr:AddVariable(     "Facturas",             "Total RE",                            "GetHbVar('nTotReq')" )
   oFr:AddVariable(     "Facturas",             "Total página",                        "GetHbVar('nTotPag')" )
   oFr:AddVariable(     "Facturas",             "Total retención",                     "GetHbVar('nTotRet')" )
   oFr:AddVariable(     "Facturas",             "Total peso",                          "GetHbVar('nTotPes')" )
   oFr:AddVariable(     "Facturas",             "Total costo",                         "GetHbVar('nTotCos')" )
   oFr:AddVariable(     "Facturas",             "Total anticipado",                    "GetHbVar('nTotAnt')" )
   oFr:AddVariable(     "Facturas",             "Total cobrado",                       "GetHbVar('nTotCob')" )
   oFr:AddVariable(     "Facturas",             "Total artículos",                     "GetHbVar('nTotArt')" )
   oFr:AddVariable(     "Facturas",             "Total cajas",                         "GetHbVar('nTotCaj')" )
   oFr:AddVariable(     "Facturas",             "Total punto verde",                   "GetHbVar('nTotPnt')" )
   oFr:AddVariable(     "Facturas",             "Cuenta por defecto del cliente",      "GetHbVar('cCtaCli')" )

   oFr:AddVariable(     "Facturas",             "Bruto primer tipo de " + cImp(),      "GetHbArrayVar('aIvaUno',1)" )
   oFr:AddVariable(     "Facturas",             "Bruto segundo tipo de " + cImp(),     "GetHbArrayVar('aIvaDos',1)" )
   oFr:AddVariable(     "Facturas",             "Bruto tercer tipo de " + cImp(),      "GetHbArrayVar('aIvaTre',1)" )
   oFr:AddVariable(     "Facturas",             "Base primer tipo de " + cImp(),       "GetHbArrayVar('aIvaUno',2)" )
   oFr:AddVariable(     "Facturas",             "Base segundo tipo de " + cImp(),      "GetHbArrayVar('aIvaDos',2)" )
   oFr:AddVariable(     "Facturas",             "Base tercer tipo de " + cImp(),       "GetHbArrayVar('aIvaTre',2)" )
   oFr:AddVariable(     "Facturas",             "Porcentaje primer tipo " + cImp(),    "GetHbArrayVar('aIvaUno',3)" )
   oFr:AddVariable(     "Facturas",             "Porcentaje segundo tipo " + cImp(),   "GetHbArrayVar('aIvaDos',3)" )
   oFr:AddVariable(     "Facturas",             "Porcentaje tercer tipo " + cImp(),    "GetHbArrayVar('aIvaTre',3)" )
   oFr:AddVariable(     "Facturas",             "Porcentaje primer tipo RE",           "GetHbArrayVar('aIvaUno',4)" )
   oFr:AddVariable(     "Facturas",             "Porcentaje segundo tipo RE",          "GetHbArrayVar('aIvaDos',4)" )
   oFr:AddVariable(     "Facturas",             "Porcentaje tercer tipo RE",           "GetHbArrayVar('aIvaTre',4)" )
   oFr:AddVariable(     "Facturas",             "Importe primer tipo " + cImp(),       "GetHbArrayVar('aIvaUno',8)" )
   oFr:AddVariable(     "Facturas",             "Importe segundo tipo " + cImp(),      "GetHbArrayVar('aIvaDos',8)" )
   oFr:AddVariable(     "Facturas",             "Importe tercer tipo " + cImp(),       "GetHbArrayVar('aIvaTre',8)" )
   oFr:AddVariable(     "Facturas",             "Importe primer RE",                   "GetHbArrayVar('aIvaUno',9)" )
   oFr:AddVariable(     "Facturas",             "Importe segundo RE",                  "GetHbArrayVar('aIvaDos',9)" )
   oFr:AddVariable(     "Facturas",             "Importe tercer RE",                   "GetHbArrayVar('aIvaTre',9)" )

   oFr:AddVariable(     "Facturas",             "Total unidades primer tipo de impuestos especiales",            "GetHbArrayVar('aIvmUno',1 )" )
   oFr:AddVariable(     "Facturas",             "Total unidades segundo tipo de impuestos especiales",           "GetHbArrayVar('aIvmDos',1 )" )
   oFr:AddVariable(     "Facturas",             "Total unidades tercer tipo de impuestos especiales",            "GetHbArrayVar('aIvmTre',1 )" )
   oFr:AddVariable(     "Facturas",             "Importe del primer tipo de impuestos especiales",               "GetHbArrayVar('aIvmUno',2 )" )
   oFr:AddVariable(     "Facturas",             "Importe del segundo tipo de impuestos especiales",              "GetHbArrayVar('aIvmDos',2 )" )
   oFr:AddVariable(     "Facturas",             "Importe del tercer tipo de impuestos especiales",               "GetHbArrayVar('aIvmTre',2 )" )
   oFr:AddVariable(     "Facturas",             "Total importe primer tipo de impuestos especiales",             "GetHbArrayVar('aIvmUno',3 )" )
   oFr:AddVariable(     "Facturas",             "Total importe segundo tipo de impuestos especiales",            "GetHbArrayVar('aIvmDos',3 )" )
   oFr:AddVariable(     "Facturas",             "Total importe tercer tipo de impuestos especiales",             "GetHbArrayVar('aIvmTre',3 )" )

   oFr:AddVariable(     "Facturas",             "Fecha del primer vencimiento",        "GetHbArrayVar('aDatVto',1)" )
   oFr:AddVariable(     "Facturas",             "Fecha del segundo vencimiento",       "GetHbArrayVar('aDatVto',2)" )
   oFr:AddVariable(     "Facturas",             "Fecha del tercer vencimiento",        "GetHbArrayVar('aDatVto',3)" )
   oFr:AddVariable(     "Facturas",             "Fecha del cuarto vencimiento",        "GetHbArrayVar('aDatVto',4)" )
   oFr:AddVariable(     "Facturas",             "Fecha del quinto vencimiento",        "GetHbArrayVar('aDatVto',5)" )
   oFr:AddVariable(     "Facturas",             "Fecha del sexto vencimiento",         "GetHbArrayVar('aDatVto',6)" )
   oFr:AddVariable(     "Facturas",             "Fecha del septimo vencimiento",       "GetHbArrayVar('aDatVto',7)" )
   oFr:AddVariable(     "Facturas",             "Fecha del octavo vencimiento",        "GetHbArrayVar('aDatVto',8)" )
   oFr:AddVariable(     "Facturas",             "Fecha del noveno vencimiento",        "GetHbArrayVar('aDatVto',9)" )
   oFr:AddVariable(     "Facturas",             "Fecha del decimo vencimiento",        "GetHbArrayVar('aDatVto',10)" )
   oFr:AddVariable(     "Facturas",             "Fecha del undecimo vencimiento",      "GetHbArrayVar('aDatVto',11)" )
   oFr:AddVariable(     "Facturas",             "Fecha del duodecimo vencimiento",     "GetHbArrayVar('aDatVto',12)" )

   oFr:AddVariable(     "Facturas",             "Importe del primer vencimiento",      "GetHbArrayVar('aImpVto',1)" )
   oFr:AddVariable(     "Facturas",             "Importe del segundo vencimiento",     "GetHbArrayVar('aImpVto',2)" )
   oFr:AddVariable(     "Facturas",             "Importe del tercero vencimiento",     "GetHbArrayVar('aImpVto',3)" )
   oFr:AddVariable(     "Facturas",             "Importe del cuarto vencimiento",      "GetHbArrayVar('aImpVto',4)" )
   oFr:AddVariable(     "Facturas",             "Importe del quinto vencimiento",      "GetHbArrayVar('aImpVto',5)" )
   oFr:AddVariable(     "Facturas",             "Importe del sexto vencimiento",       "GetHbArrayVar('aImpVto',6)" )
   oFr:AddVariable(     "Facturas",             "Importe del septimo vencimiento",     "GetHbArrayVar('aImpVto',7)" )
   oFr:AddVariable(     "Facturas",             "Importe del octavo vencimiento",      "GetHbArrayVar('aImpVto',8)" )
   oFr:AddVariable(     "Facturas",             "Importe del noveno vencimiento",      "GetHbArrayVar('aImpVto',9)" )
   oFr:AddVariable(     "Facturas",             "Importe del decimo vencimiento",      "GetHbArrayVar('aImpVto',10)" )
   oFr:AddVariable(     "Facturas",             "Importe del undecimo vencimiento",    "GetHbArrayVar('aImpVto',11)" )
   oFr:AddVariable(     "Facturas",             "Importe del duodecimo vencimiento",   "GetHbArrayVar('aImpVto',12)" )
   
   oFr:AddVariable(     "Facturas",             "Cuenta bancaria cliente",                         "CallHbFunc('cCtaFacCli')" )
   oFr:AddVariable(     "Facturas",             "Saldo anterior envase 4",                         "CallHbFunc('nSaldoAnterior4')" )
   oFr:AddVariable(     "Facturas",             "Saldo anterior envase 8",                         "CallHbFunc('nSaldoAnterior8')" )
   oFr:AddVariable(     "Facturas",             "Saldo anterior envase 16",                        "CallHbFunc('nSaldoAnterior16')" )

   oFr:AddVariable(     "Facturas",             "Saldo documento envase 4",                        "CallHbFunc('nSaldoDocumento4')" )
   oFr:AddVariable(     "Facturas",             "Saldo documento envase 8",                        "CallHbFunc('nSaldoDocumento8')" )
   oFr:AddVariable(     "Facturas",             "Saldo documento envase 16",                       "CallHbFunc('nSaldoDocumento16')" )

   oFr:AddVariable(     "Facturas",             "Total saldo envase 4",                            "CallHbFunc('nTotalSaldo4')" )
   oFr:AddVariable(     "Facturas",             "Total saldo envase 8",                            "CallHbFunc('nTotalSaldo8')" )
   oFr:AddVariable(     "Facturas",             "Total saldo envase 16",                           "CallHbFunc('nTotalSaldo16')" )

   oFr:AddVariable(     "Lineas de facturas",   "Detalle del artículo",                            "CallHbFunc('cDesFacCli')" )
   oFr:AddVariable(     "Lineas de facturas",   "Detalle del artículo otro lenguaje",              "CallHbFunc('cDesFacCliLeng')" )
   oFr:AddVariable(     "Lineas de facturas",   "Total unidades artículo",                         "CallHbFunc('nTotNFacCli')" )
   oFr:AddVariable(     "Lineas de facturas",   "Precio unitario del artículo",                    "CallHbFunc('nTotUFacCli')" )
   oFr:AddVariable(     "Lineas de facturas",   "Precio unitario con descuentos",                  "CallHbFunc('nTotPFacCli')" )
   oFr:AddVariable(     "Lineas de facturas",   "Punto verde del artículo",                        "CallHbFunc('nPntUFacCli')" )
   oFr:AddVariable(     "Lineas de facturas",   "Total línea de factura",                          "CallHbFunc('nTotLFacCli')" )
   oFr:AddVariable(     "Lineas de facturas",   "Total peso por línea",                            "CallHbFunc('nPesLFacCli')" )
   oFr:AddVariable(     "Lineas de facturas",   "Total final línea del factura",                   "CallHbFunc('nTotFFacCli')" )
   oFr:AddVariable(     "Lineas de facturas",   "Importe descuento línea del factura",             "CallHbFunc('nDtoLFacCli')" )
   oFr:AddVariable(     "Lineas de facturas",   "Importe impuestos especiales línea del factura",  "CallHbFunc('nTotIFacCli')" )
   oFr:AddVariable(     "Lineas de facturas",   "Total descuento línea del factura",               "CallHbFunc('nTotDtoLFacCli')" )
   oFr:AddVariable(     "Lineas de facturas",   "Fecha en juliano",                                "CallHbFunc('dJulianoFacCli')" )
   oFr:AddVariable(     "Lineas de facturas",   "Fecha en juliano 4 meses",                        "CallHbFunc('dJuliano4FacCli')" )
   oFr:AddVariable(     "Lineas de facturas",   "Precio unitario sin " + cImp(),                   "CallHbFunc('nNoIncUFacCli')"  )
   oFr:AddVariable(     "Lineas de facturas",   "Total linea sin " + cImp(),                       "CallHbFunc('nNoIncLFacCli')"  )
   oFr:AddVariable(     "Lineas de facturas",   "Dirección del SAT",                               "CallHbFunc('cFacturaClienteDireccionSAT')" )
   oFr:AddVariable(     "Lineas de facturas",   "Stock actual en almacén",                         "CallHbFunc('nStockLineaFasCli')" )
   oFr:AddVariable(     "Lineas de facturas",   "Cambia orden",                                    "CallHbFunc('FacturaClienteLineaOrdSetFocus')" )
   oFr:AddVariable(     "Lineas de facturas",   "Total línea "+ cImp() + " incluido",              "CallHbFunc('nIncLFacCli')" )
   oFr:AddVariable(     "Lineas de facturas",   "Precio unitario "+ cImp() + " incluido",          "CallHbFunc('nIncUFacCli')" )

Return nil

//---------------------------------------------------------------------------//

Function DesignReportFacCli( oFr, dbfDoc )

   local lOpen    := .f.
   local lFlag    := .f.
   local nOrdAnt

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

   nOrdAnt        := ( D():AnticiposClientes( nView ) )->( OrdSetFocus( "cNumDoc" ) )

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
                                                   "CallHbFunc('nTotFacCli');"                                 + Chr(13) + Chr(10) + ;
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
         oFr:SetObjProperty(  "MasterData",  "DataSet", "Facturas" )

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

      oFr:SetTabTreeExpanded( FR_tvAll, .f. )

      /*
      Dise-o de report---------------------------------------------------------
      */

      oFr:DesignReport()

      /*
      Destruye el Diseñador----------------------------------------------------
      */

      oFr:DestroyFr()

      ( D():AnticiposClientes( nView ) )->( OrdSetFocus( nOrdAnt ) )

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

Function mailReportFacCli( cCodigoDocumento )

Return ( printReportFacCli( IS_MAIL, 1, prnGetName(), cCodigoDocumento ) )

//---------------------------------------------------------------------------//

Function printReportFacCli( nDevice, nCopies, cPrinter, cCodigoDocumento )

   local oFr
   local nOrdAnt  
   local nOrdFacL            
   local cFilePdf             

   DEFAULT nDevice            := IS_SCREEN
   DEFAULT nCopies            := 1
   DEFAULT cPrinter           := PrnGetName()
   DEFAULT cCodigoDocumento   := cFormatoFacturasClientes()

   if empty( cCodigoDocumento )
      msgStop( "El Código del documento esta vacio" )
      Return ( nil )
   end if 

   SysRefresh()

   nOrdAnt                    := ( D():AnticiposClientes( nView ) )->( OrdSetFocus( "cNumDoc" ) )
   nOrdFacL                   := ( D():FacturasClientesLineas( nView ) )->( ordSetFocus( "nPosPrint" ) )
   cFilePdf                   := cPatTmp() + "FacturasCliente" + StrTran( D():FacturasClientesId( nView ), " ", "" ) + ".Pdf"

   oFr                        := frReportManager():New()
   oFr:LoadLangRes( "Spanish.Xml" )
   oFr:SetIcon( 1 )
   oFr:SetTitle( "Diseñador de documentos" )

   // Manejador de eventos-----------------------------------------------------

   oFr:SetEventHandler( "Designer", "OnSaveReport", {|| oFr:SaveToBlob( ( D():Documentos( nView ) )->( Select() ), "mReport" ) } )

   // Zona de datos------------------------------------------------------------

   dataReport( oFr )

   // Cargar el informe--------------------------------------------------------

   if lMemoDocumento( cCodigoDocumento, D():Documentos( nView ) )

      oFr:LoadFromBlob( ( D():Documentos( nView ) )->( Select() ), "mReport")

      // Zona de variables--------------------------------------------------------
      
      variableReport( oFr )

      // Preparar el report-------------------------------------------------------

      oFr:PrepareReport()

      // Imprimir el informe------------------------------------------------------

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
   Destruye el Diseñador-------------------------------------------------------
   */

   oFr:DestroyFr()

   ( D():AnticiposClientes( nView ) )->( OrdSetFocus( nOrdAnt ) )
   ( D():FacturasClientesLineas( nView ) )->( ordSetFocus( nOrdFacL ) )

Return ( cFilePdf )

//---------------------------------------------------------------------------//

Static Function YearComboBoxChange()

   if ( oWndBrw:oWndBar:cYearComboBox() != __txtAllYearsFilter__ )
      oWndBrw:oWndBar:setYearComboBoxExpression( "year( field->dFecFac ) == " + oWndBrw:oWndBar:cYearComboBox() )
   else
      oWndBrw:oWndBar:setYearComboBoxExpression( "" )
   end if 

   oWndBrw:chgFilter()

Return .t.

//----------------------------------------------------------------------------//

/*
Comienza la edición de la factura
*/

STATIC FUNCTION BeginTrans( aTmp, nMode )

   local nOrd
   local cFac
   local oError
   local oBlock
   local lErrors  := .f.
   local cDbfLin  := "FCliL"
   local cDbfInc  := "FCliI"
   local cDbfDoc  := "FCliD"
   local cDbfAnt  := "FCliA"
   local cDbfPgo  := "FCliP"
   local cDbfSer  := "FCliS"
   local cDbfEnt  := "FCliE"
   local cDbfEst  := "FCliC"

   CursorWait()

   oBlock         := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE
 
   /*
   Inicializaci-n de variables-------------------------------------------------
   */

   cFac           := aTmp[ _CSERIE ] + str( aTmp[ _NNUMFAC ] ) + aTmp[ _CSUFFAC ]
   aNumAlb        := {}

   do case
      case nMode == APPD_MODE
         nTotalOld   := 0
         
      case nMode == DUPL_MODE
         nTotalOld   := 0

      case nMode == EDIT_MODE
         nTotalOld   := nTotFac

   end case

   /*
   Actualizacion de riesgo-----------------------------------------------------
   */

   cTmpLin        := cGetNewFileName( cPatTmp() + cDbfLin )
   cTmpInc        := cGetNewFileName( cPatTmp() + cDbfInc )
   cTmpDoc        := cGetNewFileName( cPatTmp() + cDbfDoc )
   cTmpAnt        := cGetNewFileName( cPatTmp() + cDbfAnt )
   cTmpPgo        := cGetNewFileName( cPatTmp() + cDbfPgo )
   cTmpSer        := cGetNewFileName( cPatTmp() + cDbfSer )
   cTmpEnt        := cGetNewFileName( cPatTmp() + cDbfEnt )
   cTmpEst        := cGetNewFileName( cPatTmp() + cDbfEst )

   /*
   Primero crear la base de datos local----------------------------------------
   */

   dbCreate( cTmpLin, aSqlStruct( aColFacCli() ), cLocalDriver() )
   dbUseArea( .t., cLocalDriver(), cTmpLin, cCheckArea( cDbfLin, @dbfTmpLin ), .f. )

   if !NetErr()

      ( dbfTmpLin )->( OrdCondSet( "!Deleted()", {||!Deleted() } ) )
      ( dbfTmpLin )->( OrdCreate( cTmpLin, "Recno", "Str( Recno() )", {|| Str( Recno() ) } ) )

      ( dbfTmpLin )->( OrdCondSet( "!Deleted()", {||!Deleted() } ) )
      ( dbfTmpLin )->( OrdCreate( cTmpLin, "nNumLin", "str( nNumLin, 4 )", {|| str( Field->nNumLin ) } ) )

      ( dbfTmpLin )->( OrdCondSet( "!Deleted()", {||!Deleted() } ) )
      ( dbfTmpLin )->( OrdCreate( cTmpLin, "cRef", "cRef", {|| Field->cRef } ) )

      ( dbfTmpLin )->( OrdCondSet( "!Deleted()", {||!Deleted() } ) )
      ( dbfTmpLin )->( OrdCreate( cTmpLin, "nPosPrint", "Str( nPosPrint, 4 )", {|| Str( Field->nPosPrint ) } ) )

      oLinDetCamposExtra:initArrayValue()

      if ( D():FacturasClientesLineas( nView ) )->( dbSeek( cFac ) )
        
         while ( ( D():FacturasClientesLineas( nView ) )->cSerie + str( ( D():FacturasClientesLineas( nView ) )->nNumFac ) + ( D():FacturasClientesLineas( nView ) )->cSufFac ) == cFac .and. !( D():FacturasClientesLineas( nView ) )->( eof() )
        
            dbPass( D():FacturasClientesLineas( nView ), dbfTmpLin, .t. )

            oLinDetCamposExtra:SetTemporalLines( ( dbfTmpLin )->cSerie + str( ( dbfTmpLin )->nNumFac ) + ( dbfTmpLin )->cSufFac + str( ( dbfTmpLin )->nNumLin ) + str( ( dbfTmpLin )->nNumKit ), ( dbfTmpLin )->( OrdKeyNo() ), nMode )
        
            ( D():FacturasClientesLineas( nView ) )->( dbSkip() )
        
         end while

      end if

      ( dbfTmpLin )->( dbGoTop() )

      oStock:SetTmpFacCliL( dbfTmpLin )

   else

      lErrors     := .t.

   end if

   /*
   Creamos la tabla temporal de incidencias------------------------------------
   */

   dbCreate( cTmpInc, aSqlStruct( aIncFacCli() ), cLocalDriver() )
   dbUseArea( .t., cLocalDriver(), cTmpInc, cCheckArea( cDbfInc, @dbfTmpInc ), .f. )
   if !NetErr()
      ( dbfTmpInc )->( ordCondSet( "!Deleted()", {||!Deleted() } ) )
      ( dbfTmpInc )->( ordCreate( cTmpInc, "Recno", "Recno()", {|| Recno() } ) )

      if ( nMode != DUPL_MODE ) .and. ( dbfFacCliI )->( dbSeek( cFac ) )
         while ( ( dbfFacCliI )->cSerie + str( ( dbfFacCliI )->nNumFac ) + ( dbfFacCliI )->cSufFac == cFac ) .AND. ( dbfFacCliI )->( !eof() )
            dbPass( dbfFacCliI, dbfTmpInc, .t. )
            ( dbfFacCliI )->( dbSkip() )
         end while
      end if

      ( dbfTmpInc )->( dbGoTop() )
   else
      lErrors     := .t.
   end if

   /*
   Creamos la tabla temporal de documentos-------------------------------------
   */

   dbCreate( cTmpDoc, aSqlStruct( aFacCliDoc() ), cLocalDriver() )
   dbUseArea( .t., cLocalDriver(), cTmpDoc, cCheckArea( cDbfDoc, @dbfTmpDoc ), .f. )
   if !NetErr()
      ( dbfTmpDoc )->( ordCondSet( "!Deleted()", {||!Deleted() } ) )
      ( dbfTmpDoc )->( ordCreate( cTmpDoc, "Recno", "Recno()", {|| Recno() } ) )

      if ( nMode != DUPL_MODE ) .and. ( dbfFacCliD )->( dbSeek( cFac ) )
         while ( ( dbfFacCliD )->cSerFac + str( ( dbfFacCliD )->nNumFac ) + ( dbfFacCliD )->cSufFac == cFac ) .AND. ( dbfFacCliD )->( !eof() )
            dbPass( dbfFacCliD, dbfTmpDoc, .t. )
            ( dbfFacCliD )->( dbSkip() )
         end while
      end if

      ( dbfTmpDoc )->( dbGoTop() )
   else
      lErrors     := .t.
   end if

   /*
   Creamos la tabla temporal de anticipos--------------------------------------
   */

   dbCreate( cTmpAnt, aSqlStruct( aItmAntCli() ), cLocalDriver() )
   dbUseArea( .t., cLocalDriver(), cTmpAnt, cCheckArea( cDbfInc, @dbfTmpAnt ), .f. )
   if !NetErr()
      ( dbfTmpAnt )->( ordCondSet( "!Deleted()", {||!Deleted() } ) )
      ( dbfTmpAnt )->( ordCreate( cTmpAnt, "Recno", "Recno()", {|| Recno() } ) )

      nOrd        := ( D():AnticiposClientes( nView ) )->( OrdSetFocus( "cNumDoc" ) )

      if ( nMode != DUPL_MODE ) .and. ( D():AnticiposClientes( nView ) )->( dbSeek( cFac ) )
         while ( D():AnticiposClientes( nView ) )->cNumDoc == cFac .and. ( D():AnticiposClientes( nView ) )->( !eof() )
            dbPass( D():AnticiposClientes( nView ), dbfTmpAnt, .t. )
            ( D():AnticiposClientes( nView ) )->( dbSkip() )
         end while
      end if

      ( dbfTmpAnt )->( dbGoTop() )
      ( D():AnticiposClientes( nView ) )->( OrdSetFocus( nOrd ) )
   else
      lErrors     := .t.
   end if

   /*
   Creamos la tabla temporal de pagos------------------------------------------
   */

   dbCreate( cTmpPgo, aSqlStruct( aItmRecCli() ), cLocalDriver() )
   dbUseArea( .t., cLocalDriver(), cTmpPgo, cCheckArea( cDbfPgo, @dbfTmpPgo ), .f. )

   if !NetErr()

      ( dbfTmpPgo )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( dbfTmpPgo )->( ordCreate( cTmpPgo , "cRecDev", "cRecDev", {|| Field->cRecDev } ) )

      ( dbfTmpPgo )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( dbfTmpPgo )->( ordCreate( cTmpPgo, "nNumFac", "cSerie + str( nNumFac ) + cSufFac + str( nNumRec ) + cTipRec", {|| Field->cSerie + str( Field->nNumFac ) + Field->cSufFac + str( Field->nNumRec ) + Field->cTipRec } ) )

      ( dbfTmpPgo )->( ordCondSet( "!Deleted() .and. empty( cTipRec )", {|| !Deleted() .and.  empty( Field->cTipRec ) } ) )
      ( dbfTmpPgo )->( ordCreate( cTmpPgo, "fNumFac", "cSerie + str( nNumFac ) + cSufFac + str( nNumRec )", {|| Field->cSerie + str( Field->nNumFac ) + Field->cSufFac + str( Field->nNumRec ) + Field->cTipRec } ) )

      ( dbfTmpPgo )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( dbfTmpPgo )->( ordCreate( cTmpPgo, "cNumMtr", "Field->cNumMtr", {|| Field->cNumMtr } ) )

      nOrd        := ( D():FacturasClientesCobros( nView ) )->( OrdSetFocus( "fNumFac" ) )

      if ( nMode != DUPL_MODE ) .and. ( D():FacturasClientesCobros( nView ) )->( dbSeek( cFac ) ) 
         while ( D():FacturasClientesCobros( nView ) )->cSerie + str( ( D():FacturasClientesCobros( nView ) )->nNumFac ) + ( D():FacturasClientesCobros( nView ) )->cSufFac == cFac .and. ( D():FacturasClientesCobros( nView ) )->( !eof() )
            if empty( ( D():FacturasClientesCobros( nView ) )->cTipRec )
               dbPass( D():FacturasClientesCobros( nView ), dbfTmpPgo, .t. )
            end if
            ( D():FacturasClientesCobros( nView ) )->( dbSkip() )
         end while
      end if

      ( dbfTmpPgo  )->( dbGoTop() )
      ( D():FacturasClientesCobros( nView ) )->( OrdSetFocus( nOrd ) )

   else

      lErrors     := .t.

   end if

   /*
   Creamos el fichero de series------------------------------------------------
   */

   dbCreate( cTmpSer, aSqlStruct( aSerFacCli() ), cLocalDriver() )
   dbUseArea( .t., cLocalDriver(), cTmpSer, cCheckArea( cDbfSer, @dbfTmpSer ), .f. )

   if !( dbfTmpSer )->( NetErr() )

      ( dbfTmpSer )->( OrdCondSet( "!Deleted()", {||!Deleted() } ) )
      ( dbfTmpSer )->( OrdCreate( cTmpSer, "nNumLin", "str( nNumLin, 4 ) + cRef", {|| str( Field->nNumLin, 4 ) + Field->cRef } ) )

      if ( nMode != DUPL_MODE ) .and. ( dbfFacCliS )->( dbSeek( cFac ) )
         while ( ( dbfFacCliS )->cSerFac + str( ( dbfFacCliS )->nNumFac ) + ( dbfFacCliS )->cSufFac == cFac ) .and. !( dbfFacCliS )->( eof() )
            dbPass( dbfFacCliS, dbfTmpSer, .t. )
            ( dbfFacCliS )->( dbSkip() )
         end while
      end if

      ( dbfTmpSer )->( dbGoTop() )

      oStock:SetTmpFacCliS( dbfTmpSer )

   else

      lErrors     := .t.

   end if

   /*
   Creamos el fichero de entidades------------------------------------------------
   */

   dbCreate( cTmpEnt, aSqlStruct( aEntidadesFacCli() ), cLocalDriver() )
   dbUseArea( .t., cLocalDriver(), cTmpEnt, cCheckArea( cDbfSer, @dbfTmpEntidades ), .f. )

   if !( dbfTmpEntidades )->( NetErr() )

      ( dbfTmpEntidades )->( OrdCondSet( "!Deleted()", {||!Deleted() } ) )
      ( dbfTmpEntidades )->( OrdCreate( cTmpEnt, "nRecno", "str( recno() )", {|| str( recno() ) } ) )

      ( dbfTmpEntidades )->( OrdCondSet( "!Deleted()", {||!Deleted() } ) )
      ( dbfTmpEntidades )->( OrdCreate( cTmpEnt, "cRolEnt", "cCodEnt + cRol", {|| Field->cCodEnt + Field->cRol } ) )

      if ( nMode != DUPL_MODE ) .and. D():gotoIdFacturasClientesEntidades( cFac, nView )
         
         while ( D():FacturasClientesEntidadesId( nView ) == cFac .and. !D():eofFacturasClientesEntidades( nView ) )
      
            dbPass( D():FacturasClientesEntidades( nView ), dbfTmpEntidades, .t. )
      
            ( D():FacturasClientesEntidades( nView ) )->( dbSkip() )
      
         end while
      
      end if

      ( dbfTmpEntidades )->( dbGoTop() )

   else

      lErrors     := .t.

   end if

   // A-adimos desde el fichero de situaiones----------------------------------
   
   dbCreate( cTmpEst, aSqlStruct( aFacCliEst() ), cLocalDriver() )
   dbUseArea( .t., cLocalDriver(), cTmpEst, cCheckArea( cDbfEst, @dbfTmpEst ), .f. )

   if !( dbfTmpEst )->( NetErr() )

      ( dbfTmpEst )->( ordCreate( cTmpEst, "nNumFac", "cSerFac + str( nNumFac ) + cSufFac + dtos( dFecSit )  + tFecSit", {|| Field->cSerFac + str( Field->nNumFac ) + Field->cSufFac + dtos( Field->dFecSit )  + Field->tFecSit } ) )
      ( dbfTmpEst )->( ordListAdd( cTmpEst ) )

      if ( nMode != DUPL_MODE ) .and. ( D():FacturasClientesSituaciones( nView ) )->( dbSeek( cFac ) )

         while ( ( D():FacturasClientesSituaciones( nView ) )->cSerFac + Str( ( D():FacturasClientesSituaciones( nView ) )->nNumFac ) + ( D():FacturasClientesSituaciones( nView ) )->cSufFac == cFac ) .AND. ( D():FacturasClientesSituaciones( nView ) )->( !eof() ) 

            dbPass( D():FacturasClientesSituaciones( nView ), dbfTmpEst, .t. )

            ( D():FacturasClientesSituaciones( nView ) )->( dbSkip() )

         end while

      end if

      ( dbfTmpEst )->( dbGoTop() )

   else

      lErrors     := .t.

   end if   

   /*
   Cargamos los temporales de los campos extra---------------------------------
   */

   oDetCamposExtra:SetTemporal( aTmp[ _CSERIE ] + Str( aTmp[ _NNUMFAC ] ) + aTmp[ _CSUFFAC ], "", nMode )

   RECOVER USING oError

      msgStop( "Imposible crear tablas temporales." + CRLF + ErrorMessage( oError ) )

      KillTrans()

      lErrors     := .t.

   END SEQUENCE

   ErrorBlock( oBlock )

   CursorWE()

Return ( lErrors )

//-----------------------------------------------------------------------//

/*
Cargaos los datos del cliente
*/

STATIC FUNCTION loaCli( aGet, aTmp, nMode, oGetEstablecimiento, lShowInc )

   local lValid      := .t.
   local cNewCodCli  := aGet[ _CCODCLI ]:varGet()
   local lChgCodCli  := ( empty( cOldCodCli ) .or. cOldCodCli != cNewCodCli )
   local hash

   DEFAULT lShowInc  := .t.

   if empty( cNewCodCli )
      Return .t.
   elseif At( ".", cNewCodCli ) != 0
      cNewCodCli     := PntReplace( aGet[ _CCODCLI ], "0", RetNumCodCliEmp() )
   else
      cNewCodCli     := Rjust( cNewCodCli, "0", RetNumCodCliEmp() )
   end if

   if ( D():Clientes( nView ) )->( dbSeek( cNewCodCli ) )

      if !( isAviableClient( nView, nMode ) )
         return .f.
      end if

      aGet[ _CCODCLI ]:cText( ( D():Clientes( nView ) )->Cod )

      if oTlfCli != nil
         oTlfCli:SetText( ( D():Clientes( nView ) )->Telefono )
      end if

      if ( D():Clientes( nView ) )->nColor != 0
         aGet[ _CNOMCLI ]:SetColor( , ( D():Clientes( nView ) )->nColor )
      end if

      if !empty( aGet[ _CNOMCLI ] )
         if empty( aGet[ _CNOMCLI ]:varGet() ) .or. lChgCodCli
            aGet[ _CNOMCLI ]:cText( ( D():Clientes( nView ) )->Titulo )
         end if
      else
         aTmp[ _CNOMCLI ]  := ( D():Clientes( nView ) )->Titulo
      end if   

      if !empty( aGet[ _CDIRCLI ] )
         if empty( aGet[ _CDIRCLI ]:varGet() ) .or. lChgCodCli
            aGet[ _CDIRCLI ]:cText( ( D():Clientes( nView ) )->Domicilio )
         end if
      else
         aTmp[ _CDIRCLI ]  := ( D():Clientes( nView ) )->Domicilio
      end if

      if !empty( aGet[ _CTLFCLI ] )
         if empty( aGet[ _CTLFCLI ]:varGet() ) .or. lChgCodCli
            aGet[ _CTLFCLI ]:cText( ( D():Clientes( nView ) )->Telefono )
         end if
      else
         aTmp[ _CTLFCLI ]  := ( D():Clientes( nView ) )->Telefono
      end if   

      if !empty( aGet[_CPOBCLI] )
         if empty( aGet[_CPOBCLI]:varGet() ) .or. lChgCodCli
            aGet[_CPOBCLI]:cText( ( D():Clientes( nView ) )->Poblacion )
         end if
      else
         aTmp[ _CPOBCLI ]  := ( D():Clientes( nView ) )->Poblacion
      end if   

      if !empty( aGet[_CPRVCLI] )
         if empty( aGet[ _CPRVCLI ]:varGet() ) .or. lChgCodCli
            aGet[ _CPRVCLI ]:cText( ( D():Clientes( nView ) )->Provincia )
         end if
      else
         aTmp[ _CPRVCLI ]  := ( D():Clientes( nView ) )->Provincia
      end if

      if !empty( aGet[_CPOSCLI] )
         if empty( aGet[ _CPOSCLI ]:varGet() ) .or. lChgCodCli
            aGet[ _CPOSCLI ]:cText( ( D():Clientes( nView ) )->CodPostal )
         end if
      else
         aTmp[ _CPOSCLI ]  := ( D():Clientes( nView ) )->CodPostal
      end if

      if !empty( aGet[_CDNICLI] )
         if empty( aGet[ _CDNICLI ]:varGet() ) .or. lChgCodCli
            aGet[ _CDNICLI ]:cText( ( D():Clientes( nView ) )->Nif )
         end if
      else
         aTmp[ _CDNICLI ]  := ( D():Clientes( nView ) )->Nif
      end if

      if empty( aTmp[ _CCODGRP ] ) .or. lChgCodCli
         aTmp[ _CCODGRP ]  := ( D():Clientes( nView ) )->cCodGrp
      end if

      if ( lChgCodCli )
         aTmp[ _LMODCLI ]  := ( D():Clientes( nView ) )->lModDat
      end if

      if ( lChgCodCli )
         aTmp[ _LOPERPV ]  := ( D():Clientes( nView ) )->lPntVer
      end if

      if nMode == APPD_MODE

         aTmp[ _NREGIVA ]  := ( D():Clientes( nView ) )->nRegIva
         
         lChangeRegIva( aTmp )

         // Si estamos a-adiendo cargamos todos los datos del cliente

         if empty( aTmp[ _CSERIE ] )

            if !empty( ( D():Clientes( nView ) )->Serie )
               if !empty( aGet[ _CSERIE ] )               
                  aGet[ _CSERIE ]:cText( ( D():Clientes( nView ) )->Serie )
               else
                  aTmp[ _CSERIE ]   := ( D():Clientes( nView ) )->Serie
               end if   
            end if

         else

            if !empty( ( D():Clientes( nView ) )->Serie )               .and.;
               aTmp[ _CSERIE ] != ( D():Clientes( nView ) )->Serie      
               
               if !empty( aGet[ _CSERIE ] )
                  aGet[ _CSERIE ]:cText( ( D():Clientes( nView ) )->Serie )
               else
                  aTmp[ _CSERIE ]   := ( D():Clientes( nView ) )->Serie
               end if   

            end if

         end if

         /*if !empty( aGet[ _CCODALM ] )
            if ( empty( aGet[ _CCODALM ]:varGet() ) .or. lChgCodCli ) .and. !empty( ( D():Clientes( nView ) )->cCodAlm )
               aGet[ _CCODALM ]:cText( ( D():Clientes( nView ) )->cCodAlm )
               aGet[ _CCODALM ]:lValid()
            end if
         else
            aTmp[ _CCODALM ]  := ( D():Clientes( nView ) )->cCodAlm
         end if*/

         if !empty( aGet[ _CCODTAR ] )
            if ( empty( aGet[ _CCODTAR ]:varGet() ) .or. lChgCodCli ) .and. !empty( ( D():Clientes( nView ) )->cCodTar )
               aGet[ _CCODTAR ]:cText( ( D():Clientes( nView ) )->cCodTar )
               aGet[ _CCODTAR ]:lValid()
            end if
         else
            aTmp[ _CCODTAR ]  := ( D():Clientes( nView ) )->cCodTar
         end if

         if !empty( aGet[ _CCODPAGO ] ) .and. ( empty( aGet[ _CCODPAGO ]:varGet() ) .or. lChgCodCli ) .and. !empty( ( D():Clientes( nView ) )->CodPago )

            aGet[ _CCODPAGO ]:cText( ( D():Clientes( nView ) )->CodPago )
            aGet[ _CCODPAGO ]:lValid()

            // Si la forma de pago es un movimiento bancario le asignamos el banco y cuenta por defecto

            if lBancoDefecto( ( D():Clientes( nView ) )->Cod, dbfCliBnc )

               if !empty( aGet[ _CBANCO ] ) .or. lChgCodCli
                  aGet[ _CBANCO ]:cText( ( dbfCliBnc )->cCodBnc )
                  aGet[ _CBANCO ]:lValid()
               else
                  aTmp[ _CBANCO ]   := ( dbfCliBnc )->cCodBnc
               end if

               if !empty( aGet[ _CPAISIBAN ] ) .or. lChgCodCli
                  aGet[ _CPAISIBAN ]:cText( ( dbfCliBnc )->cPaisIBAN )
                  aGet[ _CPAISIBAN ]:lValid()
               else
                  aTmp[ _CPAISIBAN ]   := ( dbfCliBnc )->cPaisIBAN
               end if

               if !empty( aGet[ _CCTRLIBAN ] ) .or. lChgCodCli
                  aGet[ _CCTRLIBAN ]:cText( ( dbfCliBnc )->cCtrlIBAN )
                  aGet[ _CCTRLIBAN ]:lValid()
               else
                  aTmp[ _CCTRLIBAN ]   := ( dbfCliBnc )->cCtrlIBAN
               end if

               if !empty( aGet[ _CENTBNC ] ) .or. lChgCodCli
                  aGet[ _CENTBNC ]:cText( ( dbfCliBnc )->cEntBnc )
                  aGet[ _CENTBNC ]:lValid()
               else
                  aTmp[ _CENTBNC ]  := ( dbfCliBnc )->cEntBnc
               end if

               if !empty( aGet[ _CSUCBNC ] ) .or. lChgCodCli
                  aGet[ _CSUCBNC ]:cText( ( dbfCliBnc )->cSucBnc )
                  aGet[ _CSUCBNC ]:lValid()
               else
                  aTmp[ _CSUCBNC ]  := ( dbfCliBnc )->cSucBnc
               end if

               if !empty( aGet[ _CDIGBNC ] ) .or. lChgCodCli
                  aGet[ _CDIGBNC ]:cText( ( dbfCliBnc )->cDigBnc )
                  aGet[ _CDIGBNC ]:lValid()
               else
                  aTmp[ _CDIGBNC ]  := ( dbfCliBnc )->cDigBnc
               end if

               if !empty( aGet[ _CCTABNC ] ) .or. lChgCodCli
                  aGet[ _CCTABNC ]:cText( ( dbfCliBnc )->cCtaBnc )
                  aGet[ _CCTABNC ]:lValid()
               else
                  aTmp[ _CCTABNC ]  := ( dbfCliBnc )->cCtaBnc
               end if

            end if

         end if

         if aGet[ _CCODAGE ] != nil
            if ( empty( aGet[ _CCODAGE ]:varGet() ) .or. lChgCodCli ) .and. !empty( ( D():Clientes( nView ) )->cAgente )
               aGet[ _CCODAGE ]:cText( ( D():Clientes( nView ) )->cAgente )
               aGet[ _CCODAGE ]:lValid()
            end if
         else
            aTmp[ _CCODAGE ]  := ( D():Clientes( nView ) )->cAgente
         end if

         if !empty( aGet[ _CCODRUT ] )
            if ( empty( aGet[ _CCODRUT ]:varGet() ) .or. lChgCodCli ) .and. !empty( ( D():Clientes( nView ) )->cCodRut )
               aGet[ _CCODRUT ]:cText( ( D():Clientes( nView ))->cCodRut )
               aGet[ _CCODRUT ]:lValid()
            end if
         else
            aTmp[ _CCODRUT ]  := ( D():Clientes( nView ) )->cAgente
         end if   

         if !empty( oGetTarifa )         
            if ( empty( oGetTarifa:varGet() ) .or. lChgCodCli ) .and. !empty( ( D():Clientes( nView ) )->nTarifa )
               oGetTarifa:setTarifa( ( D():Clientes( nView ) )->nTarifa )
            end if
         else
            aTmp[ _NTARIFA ]  := ( D():Clientes( nView ) )->nTarifa
         end if

         if ( empty( aTmp[ _NDTOTARIFA ] ) .or. lChgCodCli )
            aTmp[ _NDTOTARIFA ] := ( D():Clientes( nView ) )->nDtoArt
         end if

         if !empty( aGet[ _CCODTRN ] )
            if !empty( aGet[ _CCODTRN ] ) .and. ( empty( aGet[ _CCODTRN ]:varGet() ) .or. lChgCodCli ) .and. !empty( ( D():Clientes( nView ) )->cCodTrn )
               aGet[ _CCODTRN ]:cText( ( D():Clientes( nView ) )->cCodTrn )
               aGet[ _CCODTRN ]:lValid()
            end if
         else
            aTmp[ _CCODTRN ]  := ( D():Clientes( nView ) )->cCodTrn
         end if   

         if lChgCodCli

            if !empty( aGet[ _LRECARGO ] )
               aGet[ _LRECARGO ]:Click( ( D():Clientes( nView ) )->lReq )
            else
               aTmp[ _LRECARGO ]    := ( D():Clientes( nView ) )->lReq
            end if
            
            if !empty( aGet[ _LRECC ] )
               aGet[ _LRECC ]:Click( lRECCEmpresa() )
            end if

            if !empty( aGet[ _MOBSERV ] )
                  aGet[ _MOBSERV ]:cText( ( D():Clientes( nView ) )->mComent )
            else
               aTmp[ _MOBSERV ]  := ( D():Clientes( nView ) )->mComent
            end if

            if !empty( oRiesgoCliente ) .and. lChgCodCli
               oStock:SetRiesgo( cNewCodCli, oRiesgoCliente, ( D():Clientes( nView ) )->Riesgo )
            end if

            // Retenciones desde la ficha de cliente----------------------------------

            if !empty( aGet[ _NTIPRET ] )
               aGet[ _NTIPRET  ]:Select( if( ( D():Clientes( nView ) )->nTipRet != 0, ( D():Clientes( nView ) )->nTipRet, 1 ) )
            else
               aTmp[ _NTIPRET  ] := if( ( D():Clientes( nView ) )->nTipRet != 0, ( D():Clientes( nView ) )->nTipRet, 1 )
            end if

            if !empty( aGet[ _NPCTRET ] )
               aGet[ _NPCTRET  ]:cText( ( D():Clientes( nView ) )->nPctRet )
            else
               aTmp[ _NPCTRET  ] := ( D():Clientes( nView ) )->nPctRet
            end if

            // Descuentos desde la ficha de cliente----------------------------------

            if !empty( aGet[ _CDTOESP ] )
               aGet[ _CDTOESP ]:cText( ( D():Clientes( nView ) )->cDtoEsp )
            else
               aTmp[ _CDTOESP ]  := ( D():Clientes( nView ) )->cDtoEsp
            end if

            if !empty( aGet[ _NDTOESP ] )
               aGet[ _NDTOESP ]:cText( ( D():Clientes( nView ) )->nDtoEsp )
            else
               aTmp[ _NDTOESP ]  := ( D():Clientes( nView ) )->nDtoEsp
            end if

            if !empty( aGet[ _CDPP    ] )
               aGet[ _CDPP    ]:cText( ( D():Clientes( nView ) )->cDpp )
            else
               aTmp[ _CDPP    ]  := ( D():Clientes( nView ) )->cDpp
            end if

            if !empty( aGet[ _NDPP    ] )
               aGet[ _NDPP    ]:cText( ( D():Clientes( nView ) )->nDpp )
            else
               aTmp[ _NDPP    ]  := ( D():Clientes( nView ) )->nDpp
            end if

            if !empty( aGet[ _CDTOUNO ] )
               aGet[ _CDTOUNO ]:cText( ( D():Clientes( nView ) )->cDtoUno )
            else
               aTmp[ _CDTOUNO ]  := ( D():Clientes( nView ) )->cDtoUno
            end if

            if !empty( aGet[ _CDTODOS ] )
               aGet[ _CDTODOS ]:cText( ( D():Clientes( nView ) )->cDtoDos )
            else
               aTmp[ _CDTODOS ]  := ( D():Clientes( nView ) )->cDtoDos
            end if

            if !empty( aGet[ _NDTOUNO ] )
               aGet[ _NDTOUNO ]:cText( ( D():Clientes( nView ) )->nDtoCnt )
            else
               aTmp[ _NDTOUNO ]  := ( D():Clientes( nView ) )->nDtoCnt
            end if

            if !empty( aGet[ _NDTODOS ] )
               aGet[ _NDTODOS ]:cText( ( D():Clientes( nView ) )->nDtoRap )
            else
               aTmp[ _NDTODOS ]  := ( D():Clientes( nView ) )->nDtoRap
            end if

            aTmp[ _NDTOATP ] := ( D():Clientes( nView ) )->nDtoAtp

            aTmp[ _NSBRATP ] := ( D():Clientes( nView ) )->nSbrAtp

         end if

         cargaEntidadCliente( cNewCodCli, nView, dbfTmpEntidades )

      end if

      if ( D():Clientes( nView ) )->lMosCom .and. !empty( ( D():Clientes( nView ) )->mComent ) .and. lChgCodCli
         MsgStop( Trim( ( D():Clientes( nView ) )->mComent ) )
      end if

      if lShowInc
         ShowIncidenciaCliente( ( D():Clientes( nView ) )->Cod, nView )
      end if   

      cOldCodCli  := ( D():Clientes( nView ) )->Cod

      lValid      := .t.

   ELSE

      msgStop( "Cliente no encontrado" )

      lValid      := .f.

   END IF

RETURN lValid

//----------------------------------------------------------------------------//

STATIC FUNCTION RecalculaTotal( aTmp )

   local nTotAntCli  := nTotAntFacCli( nil, dbfTmpAnt, dbfIva, dbfDiv )

   nTotFacCli( nil, D():FacturasClientes( nView ), dbfTmpLin, dbfIva, dbfDiv, D():FacturasClientesCobros( nView ), dbfTmpAnt, aTmp, nil, .f. )

   nTotCob           := nTotalRecibosPagadosFacturasCliente( nil, D():FacturasClientes( nView ), dbfTmpPgo, dbfIva, dbfDiv )

   /*
   Refrescos en Pantalla_______________________________________________________
   */

   if oBrwIva != nil
      oBrwIva:Refresh()
   end if

   if oBrwPgo != nil
      oBrwPgo:Refresh()
   end if 

   if oGetAge != nil
      oGetAge:SetText( Trans( nTotAge, cPorDiv ) )
   end if

   if oGetNet != nil
      oGetNet:SetText( Trans( nTotNet, cPorDiv ) )
   end if

   if oGetIva != nil
      oGetIva:SetText( Trans( nTotIva, cPorDiv ) )
   end if

   if oGetRnt != nil
      oGetRnt:SetText( alltrim( Trans( nTotRnt, cPorDiv ) ) + space( 1 ) + cSimDiv( cCodDiv, dbfDiv ) + " : " + alltrim( Trans( nTotPctRnt, "999.99" ) ) + "%" ) 
   end if

   if oGetReq != nil
      oGetReq:SetText( Trans( nTotReq, cPorDiv ) )
   end if

   if oGetTotal != nil
      oGetTotal:SetText( Trans( nTotFac, cPorDiv ) )
   end if

   if oTotFacLin != nil
      oTotFacLin:SetText( Trans( nTotFac, cPorDiv ) )
   end if

   if oGetTotPg != nil
      oGetTotPg:SetText( Trans( nTotFac, cPorDiv ) )
   end if

   if oGetTotIvm != nil
      oGetTotIvm:SetText( Trans( nTotIvm, cPorDiv ) )
   end if

   if oGetTotPnt != nil
      oGetTotPnt:SetText( Trans( nTotPnt, cPorDiv ) )
   end if

   if oGetTrn != nil
      oGetTrn:SetText( Trans( nTotTrn, cPorDiv ) )
   end if

   if oGetPctRet != nil
      oGetPctRet:SetText( Trans( nTotRet, cPorDiv ) )
   end if

   /*
   Pagos de la factura_________________________________________________________
   */

   if oGetPes != nil
      oGetPes:cText( nTotPes )
   end if

   if oGetDif != nil
      oGetDif:cText( nTotalDif )
   end if

Return .t.

//--------------------------------------------------------------------------//

/*
Funcion Auxiliar para añadir lineas de detalle a una Factura
*/

STATIC FUNCTION AppDeta( oBrwDet, bEdtDet, aTmp, lTot, cCodArt, aNumDoc )
                
   DEFAULT lTot   := .f.

   if !( "TABLET" $ appParamsMain() )

      if lRecibosPagadosTmp( dbfTmpPgo )
         MsgStop( "No se pueden añadir registros a una factura con recibos cobrados" )
         return .f.
      end if

   end if   

   if ( empty( aNumDoc ) ) .or. lTot // .and. !aTmp[ _LIMPALB ] )

      WinAppRec( oBrwDet, bEdtDet, dbfTmpLin, lTot, cCodArt, aTmp )

   else

      MsgStop( "No se pueden añadir registros a una factura que" + CRLF + ;
               "proviene de Facturas." )

   end if

RETURN RecalculaTotal( aTmp )

//--------------------------------------------------------------------------//

/*
Calcula totales en las lineas de Detalle
*/

STATIC FUNCTION lCalcDeta( aTmp, aTmpFac, lTotal )

   local nCalculo
   local nUnidades
   local nCosto
   local nMargen
   local nRentabilidad
   local nBase
   local nComision

   DEFAULT lTotal := .f.

   if aTmp[ __LALQUILER ]
      nCalculo    := aTmp[ _NPREALQ ]
   else
      nCalculo    := aTmp[ _NPREUNIT ]
   end if

   nCalculo       -= aTmp[ _NDTODIV ]

   nUnidades      := nTotNFacCli( aTmp )

   // IVMH

   if !aTmp[ _LIVALIN ]
      if aTmp[ _LVOLIMP ]
         nCalculo += aTmp[ _NVALIMP ] * NotCero( aTmp[ _NVOLUMEN ] )
      else
         nCalculo += aTmp[ _NVALIMP ]
      end if
   end if

   nCalculo       *= nUnidades

   // Transporte

   if aTmp[ _NIMPTRN ] != 0
      nCalculo    += nUnidades * aTmp[ _NIMPTRN ]
   end if

   // Descuentos

   if aTmp[ _NDTO    ] != 0
      nCalculo    -= nCalculo * aTmp[ _NDTO    ] / 100
   end if

   if aTmp[ _NDTOPRM ] != 0
      nCalculo    -= nCalculo * aTmp[ _NDTOPRM ] / 100
   end if

   /*
   // Calculo del margen y rentabilidad-------------------------------------------
   */

   nCosto            := nUnidades * aTmp[ _NCOSDIV ]

   if aTmp[ _LIVALIN ] .and. aTmp[ _NIVA ] != 0
      nBase          := nCalculo - Round( nCalculo / ( 100 / aTmp[ _NIVA ] + 1 ), nRouDiv )
   else
      nBase          := nCalculo
   end if

   nComision         := ( nBase * aTmp[ _NCOMAGE ] / 100 )
   nMargen           := nBase - nCosto - nComision

   if nCalculo == 0
      nRentabilidad  := 0
   else
      nRentabilidad  := nRentabilidad( nBase - nComision, 0, nCosto )
   end if

   /*
   Punto Verde-----------------------------------------------------------------
   */

   if aTmpFac[ _LOPERPV ]
      nCalculo       += nUnidades * aTmp[ _NPNTVER ]
   end if

   /*
   Ponemos el total el la linea------------------------------------------------
   */

   if !empty( oTotalLinea )
      oTotalLinea:cText( nCalculo )
   end if

   if !empty( oRentabilidadLinea )
      oRentabilidadLinea:cText( AllTrim( Trans( nMargen, cPorDiv ) + AllTrim( cSimDiv( cCodDiv, dbfDiv ) ) + " : " + AllTrim( Trans( nRentabilidad, "999.99" ) ) + "%" ) )
   end if

   if !empty( oComisionLinea )
      oComisionLinea:cText( Round( ( nBase * aTmp[ _NCOMAGE ] / 100 ), nRouDiv ) )
   end if

Return ( if( !lTotal, .t., nCalculo ) )

//---------------------------------------------------------------------------//

/*
Comprueba q no existan recibos pagados
*/

static function lRecibosPagadosTmp( dbfTmpPgo )

   local nRecAct
   local lRecPgd  := .f.

   if empty( Select( dbfTmpPgo ) )
      Return ( lRecPgd )
   end if

   nRecAct        := ( dbfTmpPgo )->( Recno() )

   while !( dbfTmpPgo )->( eof() )
      if ( dbfTmpPgo )->lCobrado .or. ( dbfTmpPgo )->lDevuelto
         lRecPgd  := .t.
         exit
      end if
      ( dbfTmpPgo )->( dbSkip() )
   end while

   ( dbfTmpPgo )->( dbGoTo( nRecAct) )

return ( lRecPgd )

//----------------------------------------------------------------------------//

/*
Comprtamiento de la caja de dialogo
*/

STATIC FUNCTION SetDlgMode( aTmp, aGet, oFld, oSayPr1, oSayPr2, oSayVp1, oSayVp2, oStkAct, nMode, oTotal, aTmpFac, oRentLin, oSayLote )

   local cCodArt        := Left( aGet[ _CREF ]:VarGet(), 18 )

   if !uFieldEmpresa( "lUseBultos" )
      if !empty( aGet[ __NBULTOS ] )
         aGet[ __NBULTOS ]:Hide()
      end if   
   else
      if !empty( aGet[ __NBULTOS ] )
         aGet[ __NBULTOS ]:SetText( uFieldempresa( "cNbrBultos" ) )
      end if 
   end if

   if !lUseCaj()
      
      if !( "TABLET" $ appParamsMain() )

         if !empty( aGet[ _NCANENT ] )
            aGet[ _NCANENT ]:Hide()
         end if

      end if

   end if

   if !empty( aGet[ _LGASSUP ] )
      aGet[ _LGASSUP ]:Show()
   end if

   if aGet[ _NVALIMP ] != nil

      if !uFieldEmpresa( "lUseImp" )

         aGet[ _NVALIMP ]:Hide()
         aGet[ _LVOLIMP ]:Hide()

      else

         if !uFieldEmpresa( "lModImp" )
            aGet[ _NVALIMP ]:Disable()
         end if

         if !uFieldEmpresa( "lIvaImpEsp" )
            if !empty( aGet[ _LVOLIMP ] )
               aGet[ _LVOLIMP ]:Disable()
            end if   
         end if

      end if

   end if

   if aGet[ _NIMPTRN ] != nil
      if !uFieldEmpresa( "lUsePor", .f. )
         aGet[ _NIMPTRN ]:Hide()
      end if
   end if

   if aGet[ _NPNTVER ] != nil
      if !uFieldEmpresa( "lUsePnt", .f. ) .or. !aTmpFac[ _LOPERPV ]
         aGet[ _NPNTVER ]:Hide()
      end if
   end if

   if aGet[ _NDTODIV ] != nil
      if !( "TABLET" $ appParamsMain() ) .and. !uFieldEmpresa( "lDtoLin", .f. )
         aGet[ _NDTODIV ]:Hide()
      end if
   end if

   if oRentLin != nil .and. oUser():lNotRentabilidad()
      oRentLin:Hide()
   end if

   if aTmp[ _LLOTE ]

      if !empty( aGet[ _CLOTE ] )
         aGet[ _CLOTE ]:Show()
      end if

      if !empty( aGet[ _DFECCAD ] )
         aGet[ _DFECCAD ]:Show()
      end if

      if !empty( oSayLote )
         oSayLote:Show()
      end if

   else

      if !empty( aGet[ _CLOTE ] )
         aGet[ _CLOTE ]:Hide()
      end if

      if !empty( aGet[ _DFECCAD ] )
         aGet[ _DFECCAD ]:Hide()
      end if

      if !empty( oSayLote )
         oSayLote:Hide()
      end if

   end if

   do case
   case nMode == APPD_MODE

      if empty( aGet[ _CREF ]:varGet() )
         aGet[ _CREF ]:cText( Space( 200 ) )
      end if 

      aTmp[ _LIVALIN ]  := aTmpFac[ _LIVAINC ]
      aTmp[ _DFECCAD ]  := Ctod( "" )

      aGet[ _NCANENT ]:cText( 1 )
      aGet[ _NUNICAJA]:cText( 1 )

      aTmp[ _NNUMLIN ]  := nLastNum( dbfTmpLin )

      if !empty( aGet[ _NPOSPRINT  ] )
         aGet[ _NPOSPRINT  ]:cText( nLastNum( dbfTmpLin, "nPosPrint" ) )
      else
         aTmp[ _NPOSPRINT  ] := nLastNum( dbfTmpLin, "nPosPrint" )
      end if

      if !empty( aGet[ _CALMLIN ] )
         aGet[ _CALMLIN ]:cText( aTmpFac[ _CCODALM ] )
      else
         aTmp[ _CALMLIN ]  := aTmpFac[ _CCODALM ]
      end if   

      if !empty( aGet[ _CDETALLE] )
         aGet[ _CDETALLE]:Show()
      end if

      if !empty( aGet[ _MLNGDES ] )
         aGet[ _MLNGDES ]:Hide()
      end if   

      if aTmpFac[ _NREGIVA ] <= 2
         if !empty( aGet[ _NIVA ] )
            aGet[ _NIVA ]:cText( nIva( dbfIva, cDefIva() ) )
         else
            aTmp[ _NIVA ]  := nIva( dbfIva, cDefIva() )
         end if   

         aTmp[ _NREQ ]     := nReq( dbfIva, cDefIva() )
      end if

      if !empty( oStkAct )
         if !uFieldEmpresa( "lNStkAct" )
            oStkAct:Show()
            oStkAct:cText( 0 )
         else
            oStkAct:Hide()
         end if
      end if

      if !empty( aGet[ __CCENTROCOSTE ] )
         aGet[ __CCENTROCOSTE ]:cText( aTmpFac[ _CCENTROCOSTE ] )
         aGet[ __CCENTROCOSTE ]:lValid()
      endif

      cTipoCtrCoste        := "Centro de coste"
      oTipoCtrCoste:Refresh()
      clearGet( aGet[ _CTERCTR ] )

   case ( nMode == EDIT_MODE .OR. nMode == ZOOM_MODE )

      if !empty( cCodArt )
       
         if !empty( aGet[_CDETALLE] )
            aGet[_CDETALLE]:show()
         end if

         if !empty( aGet[_MLNGDES ] )
            aGet[_MLNGDES ]:hide()
         end if   

      else
       
         if !aTmp[ _LCONTROL ]

            if !empty( aGet[_CDETALLE] )
               aGet[_CDETALLE]:hide()
            end if

            if !empty( aGet[_MLNGDES ] )
               aGet[_MLNGDES ]:show()
            end if

         else

            if !empty( aGet[_CDETALLE] )
               aGet[_CDETALLE]:show()
            end if

            if !empty( aGet[_MLNGDES ] )
               aGet[_MLNGDES ]:hide()
            end if

         end if

      end if

      if !empty ( oStock )

         oStock:nPutStockActual( cCodArt, aTmp[ _CALMLIN ], aTmp[ _CVALPR1 ], aTmp[ _CVALPR2 ], aTmp[ _CLOTE ], aTmp[ _LKITART ], aTmp[ _NCTLSTK ], oStkAct )

         if uFieldEmpresa( "lNStkAct" )
            oStkAct:Hide()
         end if

      end if

      if !empty( aGet[ __CCENTROCOSTE ] )
         aGet[ __CCENTROCOSTE ]:lValid()
      endif

   end case

   if !empty( aTmp[ _CCODPR1 ] )

      if !empty( aGet[ _CVALPR1 ] )
         aGet[ _CVALPR1 ]:Show()
         aGet[ _CVALPR1 ]:lValid()
      end if
      
      if !empty( oSayPr1 )
         oSayPr1:Show()
         oSayPr1:SetText( retProp( aTmp[ _CCODPR1 ], D():Propiedades( nView ) ) )
      end if
      
      if !empty( oSayVp1 )
         oSayVp1:Show()
      end if

   else

      if !empty( aGet[ _CVALPR1 ] )
         aGet[ _CVALPR1 ]:hide()
      end if
      
      if !empty( oSayPr1 )
         oSayPr1:hide()
      end if
      
      if !empty( oSayVp1 )
         oSayVp1:hide()
      end if

   end if

   if !empty( aTmp[_CCODPR2 ] )

      if !empty( aGet[ _CVALPR2 ] )
         aGet[ _CVALPR2 ]:Show()
         aGet[ _CVALPR2 ]:lValid()
      end if
      if !empty( oSayPr2 )
         oSayPr2:Show()
         oSayPr2:SetText( retProp( aTmp[ _CCODPR2 ], D():Propiedades( nView ) ) )
      end if
      if !empty( oSayVp2 )
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

      if !empty( oTotal )
         oTotal:cText( 0 )
      end if   

      /*
      Ocultamos las tres unidades de medicion-------------------------------------
      */

      if !empty( aGet[ ( D():FacturasClientesLineas( nView ) )->( fieldpos( "nMedUno" ) ) ] )
         aGet[ ( D():FacturasClientesLineas( nView ) )->( fieldpos( "nMedUno" ) ) ]:Hide()
      end if

      if !empty( aGet[ ( D():FacturasClientesLineas( nView ) )->( fieldpos( "nMedDos" ) ) ] )
         aGet[ ( D():FacturasClientesLineas( nView ) )->( fieldpos( "nMedDos" ) ) ]:Hide()
      end if

      if !empty( aGet[ ( D():FacturasClientesLineas( nView ) )->( fieldpos( "nMedTre" ) ) ] )
         aGet[ ( D():FacturasClientesLineas( nView ) )->( fieldpos( "nMedTre" ) ) ]:Hide()
     end if

      if oUndMedicion:oDbf:Seek( aTmp[ _CUNIDAD ] )

         if !empty( aGet[ ( D():FacturasClientesLineas( nView ) )->( fieldpos( "nMedUno" ) ) ] ) .and. oUndMedicion:oDbf:nDimension >= 1 .and. !empty( oUndMedicion:oDbf:cTextoDim1 )
            aGet[ ( D():FacturasClientesLineas( nView ) )->( fieldpos( "nMedUno" ) ) ]:oSay:SetText( oUndMedicion:oDbf:cTextoDim1 )
            aGet[ ( D():FacturasClientesLineas( nView ) )->( fieldpos( "nMedUno" ) ) ]:Show()
         end if

         if !empty( aGet[ ( D():FacturasClientesLineas( nView ) )->( fieldpos( "nMedDos" ) ) ] ) .and. oUndMedicion:oDbf:nDimension >= 2 .and. !empty( oUndMedicion:oDbf:cTextoDim2 )
            aGet[ ( D():FacturasClientesLineas( nView ) )->( fieldpos( "nMedDos" ) ) ]:oSay:SetText( oUndMedicion:oDbf:cTextoDim2 )
            aGet[ ( D():FacturasClientesLineas( nView ) )->( fieldpos( "nMedDos" ) ) ]:Show()
         end if

         if !empty( aGet[ ( D():FacturasClientesLineas( nView ) )->( fieldpos( "nMedTre" ) ) ] ) .and. oUndMedicion:oDbf:nDimension >= 3 .and. !empty( oUndMedicion:oDbf:cTextoDim3 )
            aGet[ ( D():FacturasClientesLineas( nView ) )->( fieldpos( "nMedTre" ) ) ]:oSay:SetText( oUndMedicion:oDbf:cTextoDim3 )
            aGet[ ( D():FacturasClientesLineas( nView ) )->( fieldpos( "nMedTre" ) ) ]:Show()
         end if

      end if

      /*
      Mostramos u ocultamos las tarifas por líneas--------------------------------
      */

      if empty( aTmp[ _NTARLIN ] )
         if !empty( aGet[ _NTARLIN ] )
            if !empty( oGetTarifa )
               aGet[ _NTARLIN ]:cText( oGetTarifa:getTarifa() )
            else
               aGet[ _NTARLIN ]:cText( aTmpFac[ _NTARIFA ] )
            end if
         else
            if !empty( oGetTarifa )
               aTmp[ _NTARLIN ]     := oGetTarifa:getTarifa()
            else
               aTmp[ _NTARLIN ]     := aTmpFac[ _NTARIFA ]
            end if 
         end if
      end if

      if !empty( aGet[ _NTARLIN ] )
         if !uFieldEmpresa( "lPreLin" )
            aGet[ _NTARLIN ]:Hide()
         else
            aGet[ _NTARLIN ]:Show()
         end if
      end if

      /*
      Focus y validación----------------------------------------------------------
      */

      if !empty( aGet[ _CTIPMOV ] )
         aGet[ _CTIPMOV ]:lValid()
      end if

      if !empty( aGet[ _CCODTIP ] )
         aGet[ _CCODTIP ]:lValid()
      end if

      if !empty( aGet[ _CALMLIN ] )
         aGet[ _CALMLIN ]:lValid()
      end if   

      if !lAccArticulo() .or. oUser():lNotCostos()

      if !empty( aGet[ _NCOSDIV ] )
         aGet[ _NCOSDIV ]:Hide()
      end if

   end if

   /*
   Solo pueden modificar los precios los administradores-----------------------
   */

   if ( empty( aTmp[ _NPREUNIT ] ) .or. lUsrMaster() .or. oUser():lCambiarPrecio() ) .and. nMode != ZOOM_MODE

      if !empty( aGet[ _NPREUNIT ] )
         aGet[ _NPREUNIT ]:HardEnable()
      end if

      if !empty( aGet[ _NIMPTRN  ] )
         aGet[ _NIMPTRN  ]:HardEnable()
      end if            

      if !empty( aGet[ _NPNTVER ] )
         aGet[ _NPNTVER ]:HardEnable()
      end if

      if !empty( aGet[ _NDTO     ] )
         aGet[ _NDTO     ]:HardEnable()
      end if

      if !empty( aGet[ _NDTOPRM  ] )
         aGet[ _NDTOPRM  ]:HardEnable()
      end if   

      if !empty( aGet[ _NDTODIV ] )
      aGet[ _NDTODIV  ]:HardEnable()
      end if

   else

      if !empty( aGet[ _NPREUNIT ] )
         aGet[ _NPREUNIT ]:HardDisable()
      end if            

      if !empty( aGet[ _NIMPTRN  ] )
         aGet[ _NIMPTRN  ]:HardDisable()
      end if            

      if !empty( aGet[ _NPNTVER ] )
         aGet[ _NPNTVER  ]:HardDisable()
      end if

      if !empty( aGet[ _NDTO     ] )
         aGet[ _NDTO     ]:HardDisable()
      end if

      if !empty( aGet[ _NDTOPRM  ] )
         aGet[ _NDTOPRM  ]:HardDisable()
      end if

      if !empty(  aGet[ _NDTODIV  ] )
         aGet[ _NDTODIV  ]:HardDisable()
      end if

   end if

   // Empieza la edicion-------------------------------------------------------

   if !empty( oFld )
      oFld:SetOption( 1 )
   end if

   // Propiedades--------------------------------------------------------------

   if !empty( BrowseProperties():getInstance() )
      BrowseProperties():getInstance():Hide()
   end if 

   // Focus al codigo-------------------------------------------------------------

   aGet[ _CREF ]:SetFocus()

Return nil

//--------------------------------------------------------------------------//

/*
Carga los articulos en la factura
*/

STATIC FUNCTION LoaArt( cCodArt, aGet, aTmp, aTmpFac, oStkAct, oSayPr1, oSayPr2, oSayVp1, oSayVp2, bmpImage, nMode, lFocused, oSayLote )

   local hHas128
   local cLote
   local hAtipica
   local dFechaCaducidad
   local nDtoAge
   local nImpAtp
   local nImpOfe
   local nCosPro           := 0
   local cCodFam
   local cProveedor
   local cValPr1           := ""
   local cValPr2           := ""
   local cPrpArt
   local nNumDto           := 0
   local nPrePro           := 0
   local nTarOld           := aTmp[ _NTARLIN ]
   local lChgCodArt        := ( empty( cOldCodArt ) .or. rtrim( cOldCodArt ) != rtrim( cCodArt ) )
   local lChgPrpArt        := ( cOldPrpArt != aTmp[ _CCODPR1 ] + aTmp[ _CCODPR2 ] + aTmp[ _CVALPR1 ] + aTmp[ _CVALPR2 ] )
   local lChgLotArt        := ( cOldLotArt != rtrim( aTmp[ _CLOTE ] ) )
   local nComisionAgenteTarifa
   local nUnidades         := 0

   DEFAULT lFocused        := .t.

   if empty( cCodArt )

      if lRetCodArt()
         MsgStop( "No se pueden añadir líneas sin codificar" )
         return .f.
      end if

      if empty( aTmp[ _NIVA ] ) .and. !aTmp[ _LGASSUP ]
         if !empty( aGet[ _NIVA ] )
            aGet[ _NIVA ]:bWhen  := {|| .t. }
         end if   
      end if

      aGet[ _CDETALLE ]:cText( Space( 50 ) )
      aGet[ _CDETALLE ]:bWhen   := {|| .t. }

      if !( "TABLET" $ appParamsMain() )
         aGet[ _CDETALLE ]:Hide()
      end if

      if !empty( aGet[ _MLNGDES ] )
         aGet[ _MLNGDES ]:Show()
         if lFocused
            aGet[ _MLNGDES ]:SetFocus()
         end if
      end if

      if !empty( aGet[ _CVALPR1 ] )
         aGet[ _CVALPR1 ]:Hide()
      end if

      if !empty( oSayPr1 )
         oSayPr1:Hide()
      end if

      if !empty( oSayVp1 )
         oSayVp1:Hide()
      end if

      if !empty( aGet[ _CVALPR2 ] )
         aGet[ _CVALPR1 ]:Hide()
      end if

      if !empty( oSayPr2 )
         oSayPr1:Hide()
      end if

      if !empty( oSayVp2 )
         oSayVp1:Hide()
      end if

      if !empty( BrowseProperties():getInstance() )
         BrowseProperties():getInstance():Hide()
      end if

      Return .t.

   end if

   if !empty( aGet[ _NIVA ] ) .and. !aTmp[ _LGASSUP ]
      aGet[ _NIVA ]:bWhen  := {|| lModIva() }
   end if

   /*
   Buscamos codificacion GS1-128--------------------------------------------
   */
   
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

   /*
   Ahora buscamos por el codigo interno----------------------------------------
   */

   if aSeekProp( @cCodArt, @cValPr1, @cValPr2, D():Articulos( nView ), D():PropiedadesLineas( nView ) )

      /*
      Estos valores lo recogemos siempre------------------------------------
      */

      aTmp[ _LMSGVTA ]        := ( D():Articulos( nView ) )->lMsgVta
      aTmp[ _LNOTVTA ]        := ( D():Articulos( nView ) )->lNotVta

      /*
      Ahora solo si cambia el codigo-------------------------------------------
      */

      if ( lChgCodArt )

         if ( D():Articulos( nView ) )->lObs
            MsgStop( "artículo catalogado como obsoleto" )
            return .f.
         end if

         CursorWait()

         cCodArt                 := ( D():Articulos( nView ) )->Codigo

         aGet[ _CREF ]:cText( Padr( cCodArt, 200 ) )
         aTmp[ _CREF ]           := cCodArt

         //Pasamos las referencias adicionales------------------------------

         aTmp[ _CREFAUX ]        := ( D():Articulos( nView ) )->cRefAux
         aTmp[ _CREFAUX2 ]       := ( D():Articulos( nView ) )->cRefAux2

         /*
         Buscamos la familia del articulo y anotamos las propiedades-----------
         */

         aTmp[ _CCODPR1 ]        := ( D():Articulos( nView ) )->cCodPrp1
         aTmp[ _CCODPR2 ]        := ( D():Articulos( nView ) )->cCodPrp2

         if !empty( aTmp[ _CCODPR1 ] ) .and. !empty( aGet[ _CVALPR1 ] )

            if !empty( cValPr1 )
               aGet[ _CVALPR1 ]:cText( cCodPrp( aTmp[ _CCODPR1 ], cValPr1, D():PropiedadesLineas( nView ) ) )
            end if

         end if

         if !empty( aTmp[ _CCODPR2 ] ) .and. !empty( aGet[ _CVALPR2 ] )

            if !empty( cValPr2 )
               aGet[ _CVALPR2 ]:cText( cCodPrp( aTmp[ _CCODPR2 ], cValPr2, D():PropiedadesLineas( nView ) ) )
            end if

         end if

         /*
         Imagen del producto---------------------------------------------------
         */

         if !empty( aGet[ _CIMAGEN ] )
            aGet[ _CIMAGEN ]:cText( ( D():Articulos( nView ) )->cImagen )
         else
            aTmp[ _CIMAGEN ]     := ( D():Articulos( nView ) )->cImagen
         end if
   
         if !empty( bmpImage )
            if !empty( aTmp[ _CIMAGEN ] )
               bmpImage:Show()
               bmpImage:LoadBmp( cFileBitmap( cPatImg(), aTmp[ _CIMAGEN ] ) )
            else
               bmpImage:Hide()
            end if
         end if

         if ( D():Articulos( nView ) )->lMosCom .and. !empty( ( D():Articulos( nView ) )->mComent )
            MsgStop( Trim( ( D():Articulos( nView ) )->mComent ) )
         end if

         // Metemos el proveedor por defecto---------------------------------------

         if !empty( aGet[ _CCODPRV ] )
            aGet[ _CCODPRV ]:cText( ( D():Articulos( nView ) )->cPrvHab )
            aGet[ _CCODPRV ]:lValid()
         else
            aTmp[ _CCODPRV ]  := ( D():Articulos( nView ) )->cPrvHab 
         end if   

         aTmp[ _CREFPRV ]  := Padr( cRefPrvArt( aTmp[ _CREF ], ( D():Articulos( nView ) )->cPrvHab , dbfArtPrv ), 18 )

         if !empty( aGet[ _CDETALLE ] )
            aGet[ _CDETALLE ]:show()
            aGet[ _CDETALLE ]:cText( ( D():Articulos( nView ) )->Nombre )
         end if   

         if !empty( aGet[ _MLNGDES ] )
            
            aGet[ _MLNGDES  ]:hide()
            aGet[ _MLNGDES  ]:cText( ( D():Articulos( nView ) )->Nombre )

            if !empty( ( D():Articulos( nView ) )->Descrip )

               if aGet[ _MLNGDES ] != nil
                     aGet[ _MLNGDES ]:cText( ( D():Articulos( nView ) )->Descrip )
               else
                     aTmp[ _MLNGDES ]  := ( D():Articulos( nView ) )->Descrip
               end if

            end if

        end if    

         // Peso y volumen------------------------------------------------------

         if !empty( aGet[ _NPESOKG ] )
            aGet[ _NPESOKG  ]:cText( ( D():Articulos( nView ) )->nPesoKg )
         else
            aTmp[ _NPESOKG  ] := ( D():Articulos( nView ) )->nPesoKg
         end if

         if !empty( aGet[ _CPESOKG ] )
            aGet[ _CPESOKG ]:cText( ( D():Articulos( nView ) )->cUndDim )
         else
            aTmp[ _CPESOKG ] := ( D():Articulos( nView ) )->cUndDim
         end if

         if !empty( aGet[ _NVOLUMEN ] )
            aGet[ _NVOLUMEN ]:cText( ( D():Articulos( nView ) )->nVolumen )
         else
            aGet[ _NVOLUMEN ] := ( D():Articulos( nView ) )->nVolumen
         end if

         if !empty( aGet[ _CUNIDAD ] )
            aGet[ _CUNIDAD ]:cText( ( D():Articulos( nView ) )->cUnidad )
            aGet[ _CUNIDAD ]:lValid()
         else
            aTmp[ _CUNIDAD ] := ( D():Articulos( nView ) )->cUnidad
         end if
         
         if !empty( aGet[ _CVOLUMEN ] )
            aGet[ _CVOLUMEN ]:cText( ( D():Articulos( nView ) )->cVolumen )
         else
            aTmp[ _CVOLUMEN ]:= ( D():Articulos( nView ) )->cVolumen
         end if
         
         if !empty( aGet[_CCODTIP ] )
            aGet[ _CCODTIP ]:cText( ( D():Articulos( nView ) )->cCodTip )
         else
            aTmp[ _CCODTIP ]  := ( D():Articulos( nView ) )->cCodTip
         end if

         // Factor de comversion

         aTmp[ _NFACCNV ]     := 1

         /*
         Cogemos las familias y los grupos de familias-------------------------
         */

         cCodFam                 := ( D():Articulos( nView ) )->Familia

         if !empty( cCodFam )

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

            if aGet[ __CCODPRY ] != nil
               aGet[ __CCODPRY ]:cText( aTmpFac[ _CCODPRY ] )
               aGet[ __CCODPRY ]:lValid()
            else
               aTmp[ __CCODPRY ]  := aTmpFac[ _CCODPRY ]
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

            if aGet[ __CCODPRY ] != nil
               aGet[ __CCODPRY ]:cText( Space( 3 ) )
               aGet[ __CCODPRY ]:lValid()
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
         Preguntamos si el regimen de " + cImp() + " es distinto de Exento
         */

         if aTmpFac[ _NREGIVA ] <= 2
            if !empty( aGet[ _NIVA ] )
               aGet[ _NIVA ]:cText( nIva( dbfIva, ( D():Articulos( nView ) )->TipoIva ) )
            else
               aTmp[ _NIVA ]     := nIva( dbfIva, ( D():Articulos( nView ) )->TipoIva )
            end if   
            aTmp[ _NREQ ]        := nReq( dbfIva, ( D():Articulos( nView ) )->TipoIva )
         end if

         /*
         Ahora recogemos el impuesto especial si lo hay---------------------------
         */

         aTmp[ _CCODIMP ]     := ( D():Articulos( nView ) )->cCodImp
         oNewImp:setCodeAndValue( aTmp[ _CCODIMP ], aGet[ _NVALIMP ] )

         if !empty( ( D():Articulos( nView ) )->cCodImp )
            aTmp[ _LVOLIMP ]     := RetFld( ( D():Articulos( nView ) )->cCodImp, oNewImp:oDbf:cAlias, "lIvaVol" )
         end if

         if ( D():Articulos( nView ) )->nCajEnt != 0
            aGet[ _NCANENT ]:cText(  (D():Articulos( nView ) )->nCajEnt )
         end if

         if !Empty( nUnidades )
            aGet[ _NUNICAJA ]:cText( nUnidades )
         end if

         if Empty( nUnidades ) .and. ( D():Articulos( nView ) )->nUniCaja != 0
            aGet[ _NUNICAJA ]:cText( ( D():Articulos( nView ) )->nUniCaja )
         end if

         // Si la Comisión del articulo hacia el agente es distinto de cero-------

         loadComisionAgente( aTmp, aGet, aTmpFac )

         /*
         Código de la frase publicitaria---------------------------------------
         */

         if !empty( ( D():Articulos( nView ) )->cCodFra )

            if aGet[ __CCODPRY ] != nil
               aGet[ __CCODPRY ]:cText( aTmpFac[ _CCODPRY ] )
               aGet[ __CCODPRY ]:lValid()
            else
               aTmp[ __CCODPRY ] := aTmpFac[ _CCODPRY ]
            end if

         end if

         /*
         Descripciones largas--------------------------------------------------
         */

         if !empty( aGet[ _DESCRIP ] )
            aGet[ _DESCRIP ]:cText( ( D():Articulos( nView ) )->Descrip )
         else
            aTmp[ _DESCRIP ]     := ( D():Articulos( nView ) )->Descrip
         end if

         /*
         Buscamos la familia del articulo y anotamos las propiedades-----------
         */

         aTmp[ _CCODPR1 ]     := ( D():Articulos( nView ) )->cCodPrp1
         aTmp[ _CCODPR2 ]     := ( D():Articulos( nView ) )->cCodPrp2

         if ( !empty( aTmp[ _CCODPR1 ] ) .or. !empty( aTmp[ _CCODPR2 ] ) ) .and. ( uFieldEmpresa( "lUseTbl" ) .and. ( nMode == APPD_MODE ) )

            aGet[ _NCANENT  ]:cText( 0 )
            aGet[ _NUNICAJA ]:cText( 0 )

            BrowseProperties():getInstance():buildPropertiesTable( cCodArt, aTmp[ _CCODPR1 ], aTmp[ _CCODPR2 ] )

         else 

            BrowseProperties():getInstance():hide()

            if !empty( aTmp[ _CCODPR1 ] )

               if aGet[ _CVALPR1 ] != nil
                  aGet[ _CVALPR1 ]:show()
                  if lFocused
                     aGet[ _CVALPR1 ]:SetFocus()
                  end if
               end if

               if oSayPr1 != nil
                  oSayPr1:SetText( retProp( ( D():Articulos( nView ) )->cCodPrp1, D():Propiedades( nView ) ) )
                  oSayPr1:show()
               end if

               if oSayVp1 != nil
                  oSayVp1:SetText( "" )
                  oSayVp1:Show()
               end if

            else

               if !empty( aGet[ _CVALPR1 ] )
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

               if aGet[ _CVALPR2 ] != nil
                  aGet[ _CVALPR2 ]:show()
               end if

               if oSayPr2 != nil
                  oSayPr2:SetText( retProp( ( D():Articulos( nView ) )->cCodPrp2, D():Propiedades( nView ) ) )
                  oSayPr2:show()
               end if

               if !empty( oSayVp2 )
                  oSayVp2:SetText( "" )
                  oSayVp2:Show()
               end if

            else

               if !empty( aGet[ _CVALPR2 ] )
                  aGet[ _CVALPR2 ]:hide()
               end if

               if!empty( oSayPr2 )
                  oSayPr2:hide()
               end if

               if !empty( oSayVp2 )
                  oSayVp2:hide()
               end if

            end if

         end if

      end if 

      /*
      He terminado de meter todo lo que no son precios ahora es cuando meter- los precios con todas las opciones posibles
      */

      cPrpArt              := aTmp[ _CCODPR1 ] + aTmp[ _CCODPR2 ] + aTmp[ _CVALPR1 ] + aTmp[ _CVALPR2 ]

      if ( lChgCodArt ) .or. ( cPrpArt != cOldPrpArt )

         /*
         Guardamos el Código de la familia
         */

         if nMode == APPD_MODE
            cCodFam        := RetFamArt( aTmp[ _CREF ], D():Articulos( nView ) )
         else
            cCodFam        := aTmp[ _CCODFAM ]
         end if

         // Inicializamos el descuento y el logico de oferta

            if !empty( aGet[ _NDTO ] )
               aGet[ _NDTO ]:cText( 0 )
            else
               aTmp[ _NDTO ] := 0
            end if

            if !empty( aGet[ _NDTODIV ] )
               aGet[ _NDTODIV ]:cText( 0 )
            else 
               aTmp[ _NDTODIV ] := 0
            end if 

            if !empty( aGet[ _NDTOPRM ] )
               aGet[ _NDTOPRM ]:cText( 0 )
            else 
               aTmp[ _NDTOPRM ]:= 0
            end if

            aTmp[ _LLINOFE  ] := .f.

         /*
         Cargamos el precio recomendado ,el precio de costo y el punto verde
         */

         if !empty( aGet[ _NPNTVER ] )
             aGet[ _NPNTVER ]:cText( ( D():Articulos( nView ) )->NPNTVER1 )
         else
             aTmp [ _NPNTVER ]   :=  ( D():Articulos( nView ) )->NPNTVER1
         end if

         aTmp[ _NPVPREC ]        := ( D():Articulos( nView ) )->PvpRec

         /*
         Descuento de artículo----------------------------------------------
         */

         nNumDto                 := retFld( aTmpFac[ _CCODCLI ], D():Clientes( nView ), "nDtoArt" )

         if nNumDto != 0

            do case
               case nNumDto == 1

                  if !empty( aGet[ _NDTO ] )
                     aGet[ _NDTO ]:cText( ( D():Articulos( nView ) )->nDtoArt1 )
                     aTmp[ _NDTO ]     := ( D():Articulos( nView ) )->nDtoArt1
                  else
                     aTmp[ _NDTO ]     := ( D():Articulos( nView ) )->nDtoArt1
                  end if

               case nNumDto == 2

                  if !empty( aGet[ _NDTO ] )
                     aGet[ _NDTO ]:cText( ( D():Articulos( nView ) )->nDtoArt2 )
                     aTmp[ _NDTO ]     := ( D():Articulos( nView ) )->nDtoArt2
                  else
                     aTmp[ _NDTO ]     := ( D():Articulos( nView ) )->nDtoArt2
                  end if

               case nNumDto == 3

                  if !empty( aGet[ _NDTO ] )
                     aGet[ _NDTO]:cText( ( D():Articulos( nView ) )->nDtoArt3 )
                     aTmp[ _NDTO ]     := ( D():Articulos( nView ) )->nDtoArt3
                  else
                     aTmp[ _NDTO ]     := ( D():Articulos( nView ) )->nDtoArt3
                  end if

               case nNumDto == 4

                  if !empty( aGet[ _NDTO ] )
                     aGet[ _NDTO ]:cText( ( D():Articulos( nView ) )->nDtoArt4 )
                     aTmp[ _NDTO ]     := ( D():Articulos( nView ) )->nDtoArt4
                  else
                     aTmp[ _NDTO ]     := ( D():Articulos( nView ) )->nDtoArt4
                  end if

               case nNumDto == 5

                  if !empty( aGet[ _NDTO ] )
                     aGet[ _NDTO ]:cText( ( D():Articulos( nView ) )->nDtoArt5 )
                     aTmp[ _NDTO ]     := ( D():Articulos( nView ) )->nDtoArt5
                  else
                     aTmp[ _NDTO ]     := ( D():Articulos( nView ) )->nDtoArt5
                  end if

               case nNumDto == 6

                  if !empty( aGet[ _NDTO ] )
                     aGet[ _NDTO]:cText( ( D():Articulos( nView ) )->nDtoArt6 )
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
            if !empty( aGet[ _NDTO ] )
               aGet[ _NDTO ]:cText( nDescuentoFamilia( cCodFam, dbfFamilia ) )
            else
               aTmp[ _NDTO ]     := nDescuentoFamilia( cCodFam, dbfFamilia )
            end if
         end if

         /*
         Cargamos el codigo de las unidades---------------------------------
         */

         if !empty( aGet[ _CUNIDAD ] )
            aGet[ _CUNIDAD ]:cText( ( D():Articulos( nView ) )->cUnidad )
         else
            aTmp[ _CUNIDAD ]  := ( D():Articulos( nView ) )->cUnidad
         end if

         /*
         Guardamos el precio del artículo dependiendo de las propiedades--//
         */

         if !empty( aGet[ _NPREUNIT ] ) // .and. empty( aTmp[ _NPREUNIT ] )

            nPrePro           := nPrePro( aTmp[ _CREF ], aTmp[ _CCODPR1 ], aTmp[ _CVALPR1 ], aTmp[ _CCODPR2 ], aTmp[ _CVALPR2 ], aTmp[ _NTARLIN ], aTmpFac[ _LIVAINC ], dbfArtDiv, dbfTarPreL, aTmpFac[_CCODTAR] )
            if nPrePro != 0
               aGet[ _NPREUNIT ]:cText( nPrePro )
            else
               aGet[ _NPREUNIT ]:cText( nRetPreArt( aTmp[ _NTARLIN ], aTmpFac[ _CDIVFAC ], aTmpFac[ _LIVAINC ], D():Articulos( nView ), dbfDiv, dbfKit, dbfIva, , aGet[ _NTARLIN ], oNewImp ) )
            end if

         end if

         sysRefresh()

         ValidaMedicion( aTmp, aGet )

      end if

      // Precios en tarifas-------------------------------------------------

      if !empty( aTmpFac[ _CCODTAR ] ) // .and. empty( aTmp[ _NPREUNIT ] )

         // Precio----------------------------------------------------------

         nImpOfe  := RetPrcTar( aTmp[ _CREF ], aTmpFac[ _CCODTAR ], aTmp[ _CCODPR1 ], aTmp[ _CCODPR2 ], aTmp[ _CVALPR1 ], aTmp[ _CVALPR2 ], dbfTarPreL, aTmp[ _NTARLIN ] )
         if nImpOfe != 0
            if !empty( aGet[ _NPREUNIT ] )
               aGet[ _NPREUNIT ]:cText( nImpOfe )
            end if
         end if

         // Descuento porcentual--------------------------------------------

         nImpOfe  := RetPctTar( aTmp[ _CREF ], aTmp[ _CCODFAM ], aTmpFac[ _CCODTAR ], aTmp[ _CCODPR1 ], aTmp[ _CCODPR2 ], aTmp[ _CVALPR1 ], aTmp[ _CVALPR2 ], dbfTarPreL )
         if nImpOfe != 0
            if !empty( aGet[_NDTO ] )
               aGet[_NDTO   ]:cText( nImpOfe )
            end if   
         end if

         // Descuento lineal------------------------------------------------

         nImpOfe  := RetLinTar( aTmp[ _CREF ], aTmp[ _CCODFAM ], aTmpFac[_CCODTAR], aTmp[_CCODPR1], aTmp[_CCODPR2], aTmp[_CVALPR1], aTmp[_CVALPR2], dbfTarPreL )
         if nImpOfe != 0
            if !empty( aGet[ _NDTODIV ] )
               aGet[ _NDTODIV ]:cText( nImpOfe )
            end if   
         end if

         // Comision de agente----------------------------------------------

         nImpOfe  := retComTar( aTmp[ _CREF ], aTmp[ _CCODFAM ], aTmpFac[ _CCODTAR ], aTmp[ _CCODPR1 ], aTmp[ _CCODPR2 ], aTmp[ _CVALPR1 ], aTmp[ _CVALPR2 ], aTmpFac[ _CCODAGE ], dbfTarPreL, dbfTarPreS )
         if nImpOfe != 0
            if !empty( aGet[ _NCOMAGE ] )
               aGet[ _NCOMAGE ]:cText( nImpOfe )
            end if   
         end if

         // Descuento de promoci-n------------------------------------------

         nImpOfe  := RetDtoPrm( aTmp[ _CREF ], aTmp[ _CCODFAM ], aTmpFac[_CCODTAR], aTmp[_CCODPR1], aTmp[_CCODPR2], aTmp[_CVALPR1], aTmp[_CVALPR2], aTmpFac[_DFECFAC], dbfTarPreL )
         if nImpOfe  != 0
            if !empty( aGet[ _NDTOPRM ] )
               aGet[ _NDTOPRM ]:cText( nImpOfe )
            end if   
         end if

         // Descuento de promoci-n para el agente---------------------------

         nDtoAge  := RetDtoAge( aTmp[ _CREF ], aTmp[ _CCODFAM ], aTmpFac[ _CCODTAR ], aTmp[_CCODPR1], aTmp[_CCODPR2], aTmp[_CVALPR1], aTmp[_CVALPR2], aTmpFac[_DFECFAC], aTmpFac[_CCODAGE], dbfTarPreL, dbfTarPreS )
         if nDtoAge  != 0
            if !empty( aGet[ _NCOMAGE] )
               aGet[ _NCOMAGE ]:cText( nDtoAge )
            end if   
         end if

      end if

      /*
      Estudiamos los casos de las atipicas de clientes-----------------------
      */

      hAtipica := hAtipica( hValue( aTmp, aTmpFac ) )
     
      if !empty( hAtipica )

         if hhaskey( hAtipica, "nImporte" ) .and. hAtipica[ "nImporte" ] != 0
            if !empty( aGet[ _NPREUNIT ] )
               aGet[ _NPREUNIT ]:cText( hAtipica[ "nImporte" ] )
            else 
               aTmp[ _NPREUNIT ] := hAtipica[ "nImporte" ] 
            end if
         end if

         if hhaskey( hAtipica, "nDescuentoPorcentual" ) .and. hAtipica[ "nDescuentoPorcentual"] != 0 .and. aTmp[ _NDTO ] == 0
            if !empty( aGet[ _NDTO ] )
               aGet[ _NDTO ]:cText( hAtipica[ "nDescuentoPorcentual"] )   
            else 
               aTmp[ _NDTO ]  := hAtipica[ "nDescuentoPorcentual"]
            end if   
         end if

         if hhaskey( hAtipica, "nDescuentoPromocional" ) .and. hAtipica[ "nDescuentoPromocional" ] != 0 .and. aTmp[ _NDTOPRM ] == 0
            if !empty( aGet[ _NDTOPRM ] )
               aGet[ _NDTOPRM ]:cText( hAtipica[ "nDescuentoPromocional" ] )
            else 
               aTmp[ _NDTOPRM ]  := hAtipica[ "nDescuentoPromocional" ] 
            end if
         end if

         if hhaskey( hAtipica, "nComisionAgente" ) .and. hAtipica[ "nComisionAgente" ] != 0 .and. aTmp[ _NCOMAGE ] == 0
            if !empty( aGet[ _NCOMAGE ] )
               aGet[ _NCOMAGE ]:cText( hAtipica[ "nComisionAgente" ] )
            else 
               atmp[ _NCOMAGE ]  := hAtipica[ "nComisionAgente" ] 
            end if   
         end if

         if hhaskey( hAtipica, "nDescuentoLineal" ) .and. hAtipica[ "nDescuentoLineal" ] != 0 .and. aTmp[ _NDTODIV ] == 0
            if !empty( aGet[ _NDTODIV ] )
               aGet[ _NDTODIV ]:cText( hAtipica[ "nDescuentoLineal" ] )
            else 
               aTmp[ _NDTODIV ]  := hAtipica[ "nDescuentoLineal" ]
            end if
         end if

         if hhaskey( hAtipica, "nTarifaPrecio" ) .and. hAtipica[ "nTarifaPrecio" ] != 0 .and. aTmp[ _NDTODIV ] == 0
            if !empty( aGet[ _NTARLIN ] )
               aGet[ _NTARLIN ]:cText( hAtipica[ "nTarifaPrecio" ] )
            else 
               aTmp[ _NTARLIN ]  := hAtipica[ "nTarifaPrecio" ] 
            end if 
         end if 

      end if

      /*
      Solo si cambia el lote---------------------------------------------------
      */

      if ( lChgCodArt )

      /*
      Lotes---------------------------------------------------------------------
      */

         if ( D():Articulos( nView ) )->lLote

            aTmp[ _LLOTE ]    := ( D():Articulos( nView ) )->lLote

            if empty( cLote )
               cLote          := ( D():Articulos( nView ) )->cLote
            end if

            if !empty( aGet[ _CLOTE ] )

               aGet[ _CLOTE ]:Show()

               if empty( aGet[ _CLOTE ]:VarGet() )
                  aGet[ _CLOTE ]:cText( cLote )
               end if

            else

               if empty( aTmp[ _CLOTE ] )
                  aTmp[ _CLOTE ] := cLote
               end if

            end if

            if !empty( oSayLote )
               oSayLote:Show()
            end if

            if empty( dFechaCaducidad )
               dFechaCaducidad      := dFechaCaducidadLote( aTmp[ _CREF ], aTmp[ _CVALPR1 ], aTmp[ _CVALPR2 ], aTmp[ _CLOTE ], dbfAlbPrvL, dbfFacPrvL, dbfProLin )
            end if 
            
            if !empty( aGet[ _DFECCAD ] )

               aGet[ _DFECCAD ]:Show()

               if empty( aGet[ _DFECCAD ]:VarGet() ) .or. ( dFechaCaducidad != dOldFecCad )
                  aGet[ _DFECCAD ]:cText( dFechaCaducidad )
               end if 

            else 

               if empty( aTmp[ _DFECCAD ] )
                  aTmp[ _DFECCAD ]  := dFechaCaducidad
               end if

            end if

         else

            if !empty( aGet[ _CLOTE ] )
               aGet[ _CLOTE ]:Hide()
            end if

            if !empty( aGet[ _DFECCAD ] )
               aGet[ _DFECCAD ]:Hide()
            end if

            if !empty( oSayLote )
               oSayLote:Hide()
            end if

         end if

         /*
         Cargamos los costos------------------------------------------------------
         */

         if !uFieldEmpresa( "lCosAct" )
            nCosPro              := oStock:nCostoMedio( aTmp[ _CREF ], aTmp[ _CALMLIN ], aTmp[ _CCODPR1 ], aTmp[ _CCODPR2 ], aTmp[ _CVALPR1 ], aTmp[ _CVALPR2 ], aTmp[ _CLOTE ] )
         end if

         if nCosPro == 0
            nCosPro              := nCosto( aTmp[ _CREF ], D():Articulos( nView ), dbfKit, .f., , dbfDiv )
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

         if !uFieldEmpresa( "lNStkAct" ) .and. oStkAct != nil .and. aTmp[ _NCTLSTK ] <= 1
            oStock:nPutStockActual( aTmp[ _CREF ], aTmp[ _CALMLIN ], aTmp[ _CVALPR1 ], aTmp[ _CVALPR2 ], aTmp[ _CLOTE ], aTmp[ _LKITART ], aTmp[ _NCTLSTK ], oStkAct )                                   
            oStkAct:Refresh()
         end if

      end if

      /*
      Buscamos si hay ofertas-----------------------------------------------
      */

      lBuscaOferta( aTmp[ _CREF ], aGet, aTmp, aTmpFac, dbfOferta, dbfDiv, dbfKit, dbfIva  )

      /*
      Cargamos los valores para los cambios---------------------------------
      */

      cOldPrpArt  := cPrpArt
      cOldCodArt  := cCodArt
      cOldLotArt  := aTmp[ _CLOTE ]
      dOldFecCad  := dFechaCaducidad

      /*
      Solo pueden modificar los precios los administradores--------------
      */

      if empty( aTmp[ _NPREUNIT ] ) .or. lUsrMaster() .or. oUser():lCambiarPrecio()

         if !empty( aGet[ _NPREUNIT ] )
            aGet[ _NPREUNIT ]:HardEnable()
         end if   
         
         if !empty( aGet[ _NIMPTRN  ] )
            aGet[ _NIMPTRN  ]:HardEnable()
         end if   

         if !empty( aGet[ _NPNTVER ] )
             aGet[ _NPNTVER ]:HardEnable()
         end if

         if !empty( aGet[ _NDTO ] )
            aGet[ _NDTO    ]:HardEnable()
         end if   
         
         if !empty( aGet[ _NDTOPRM ] )
            aGet[ _NDTOPRM ]:HardEnable()
         end if   

         if !empty( aGet[ _NDTODIV ] )
             aGet[ _NDTODIV ]:HardEnable()
         end if

      else

         if !empty( aGet[ _NPREUNIT ] )
            aGet[ _NPREUNIT ]:HardDisable()
         end if   
         
       if !empty( aGet[ _NIMPTRN  ] ) 
            aGet[ _NIMPTRN  ]:HardDisable() 
         end if   

         if !empty( aGet[ _NPNTVER ] )
             aGet[ _NPNTVER ]:HardEnable() 
         end if
         
         if !empty( aGet[ _NDTO ] )
            aGet[ _NDTO ]:HardDisable()
         end if   
         
         if !empty( aGet[ _NDTOPRM ] )
            aGet[ _NDTOPRM ]:HardDisable()
         end if   

         if !empty( aGet[ _NDTODIV ] )
             aGet[ _NDTODIV ]:HardEnable()
         end if

      end if

      CursorWE()

   else

      MsgStop( "artículo no encontrado" )
      
      Return .f.

   end if

RETURN .t.

//--------------------------------------------------------------------------//

/*
Guarda la linea de detalle
*/

STATIC FUNCTION SaveDeta( aTmp, aTmpFac, aGet, oBrw, oDlg, oFld, oSayPr1, oSayPr2, oSayVp1, oSayVp2, bmpImage, nMode, oTotal, oStkAct, nStkAct, cCodArt, oBtn, oBtnSer, oSayLote )

   local n 
   local i 
   local nRec
   local aClo
   local nTotUnd                 := 0
   local hAtipica
   local lBeforeAppendEvent
   local nPrecioPropiedades      := 0
   local oBrwProperties          := BrowseProperties():getInstance()

   if !empty( oBtn )
      oBtn:SetFocus()
   end if  

   /*if !aGet[ _CREF ]:lValid()
      return .f.
   end if*/

   /*
   Fin de modo de edición multiple
   */

   if !lMoreIva( aTmp[_NIVA] )
      return .f.
   end if

   /*
   Nos aseguramos que la marca de impuestos incluidos está igual que la de la cabecera
   */

   aTmp[ _LIVALIN ]  := aTmpFac[ _LIVAINC ]

   if empty( aTmp[ _CALMLIN ] ) .and. !empty( aGet[ _CALMLIN ] )
      MsgStop( "Código de almacen no puede estar vacio" )
      aGet[ _CALMLIN ]:SetFocus()
      return .f.
   end if

   if !empty( aGet[ _CALMLIN ] ) .and. !cAlmacen( aGet[ _CALMLIN ], dbfAlm )
      return .f.
   end if   

   // control de precios minimos-----------------------------------------------

   if lPrecioMinimo( aTmp[ _CREF ], aTmp[ _NPREUNIT ], nMode, D():Articulos( nView ) )
      msgStop( "El precio de venta es inferior al precio mínimo.")
      return .f.
   end if 

   /*
   Comprobamos si tiene que introducir Números de serie------------------------
   */

   if ( nMode == APPD_MODE ) .and. RetFld( aTmp[ _CREF ], D():Articulos( nView ), "lNumSer" ) .and. !( dbfTmpSer )->( dbSeek( str( aTmp[ _NNUMLIN ], 4 ) + aTmp[ _CREF ] ) )
      msgStop( "Tiene que introducir números de serie para este artículo." )
      if !empty( oBtnSer )
         oBtnSer:Click()
      end if 
      return .f.
   end if

   // lanzamos los scripts-----------------------------------------------------

   if isAppendOrDuplicateMode( nMode )
      if isfalse( runEventScript( "FacturasClientes\Lineas\beforeAppend", aTmp, aTmpFac, nView, dbfTmpLin ) )
         return .f.
      end if
   end if

   aTmp[ _CTIPCTR ]  := cTipoCtrCoste
   
   // fin de los script--------------------------------------------------------

   aClo              := aClone( aTmp )

   // Modo de edición multiple los cambios afectan a todos los registros seleccionados

   if nMode == MULT_MODE

      nRec     := ( dbfTmpLin )->( recno() )

      ( dbfTmpLin )->( dbGoTop() )
      while !( dbfTmpLin )->( eof() )

         if ( dbfTmpLin )->lSel
            aEval( aTmp, {| cFld, n | if( !empty( aTmp[ n ] ), ( dbfTmpLin )->( FieldPut( n, aTmp[ n ] ) ), ) } )
         end if

         ( dbfTmpLin )->( dbSkip() )

      end while

      ( dbfTmpLin )->( dbGoTo( nRec ) )

      oBrw:Refresh()

      oDlg:end( IDOK )

      return nil

   end if

   // Control de stock --------------------------------------------------------

   if !empty( aTmp[ _CREF ] ) .and. ( aTmp[ _LNOTVTA ] .or. aTmp[ _LMSGVTA ] )

      nTotUnd     := nTotNFacCli( aTmp )

      if nMode == EDIT_MODE
         nTotUnd  -= nTotNFacCli( dbfTmpLin )
      end if

      if nTotUnd != 0 .and. !empty( oStkAct )

         do case
            case oStkAct:VarGet() - nTotUnd < 0

               if oUser():lNotAllowSales( aTmp[ _LNOTVTA ] )
                  MsgStop( "No hay stock suficiente, tenemos " + Alltrim( Trans( oStkAct:VarGet(), MasUnd() ) ) + " unidad(es) disponible(s)," + CRLF + "en Almacén " + aTmp[ _CALMLIN ] + "." )
                  return nil
               end if

               if aTmp[ _LMSGVTA ]
                  if !ApoloMsgNoYes( "No hay stock suficiente, tenemos " + Alltrim( Trans( oStkAct:VarGet(), MasUnd() ) ) + " unidad(es) disponible(s)," + CRLF + " en Almacén " + aTmp[ _CALMLIN ] + ".", "¿Desea continuar?" )
                     return nil
                  end if
               end if

            case oStkAct:VarGet() - nTotUnd < nStockMinimo( aTmp[ _CREF ], aTmp[ _CALMLIN ], nView )

               if aTmp[ _LMSGVTA ]
                  if !ApoloMsgNoYes( "El stock está por debajo del minimo.", "¿Desea continuar?" )
                     return nil
                  end if
               end if

         end case

      end if

   end if

   if aTmp[ _NREQ ] == 0
      aTmp[ _NREQ ]     := nPReq( dbfIva, aTmp[ _NIVA ] )
   end if   
   
   if !( "TABLET" $ appParamsMain() )
   
      if nMode == APPD_MODE

         if aTmp[ _LLOTE ]
            saveLoteActual( aTmp[ _CREF ], aTmp[ _CLOTE ], nView )   
         end if

         if !empty( oBrwProperties )

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

                        nPrecioPropiedades   := nPrePro( aTmp[ _CREF ], aTmp[ _CCODPR1 ], aTmp[ _CVALPR1 ], aTmp[ _CCODPR2 ], aTmp[ _CVALPR2 ], aTmp[ _NTARLIN ], aTmpFac[ _LIVAINC ], dbfArtDiv, dbfTarPreL, aTmpFac[ _CCODTAR ] )
                        if !empty( nPrecioPropiedades )
                           aTmp[ _NPREUNIT ] := nPrecioPropiedades
                        end if 

                        // guarda la linea------------------------------------------- 

                        saveDetail( aTmp, aClo, aGet, aTmpFac, dbfTmpLin, oBrw, nMode )

                     end if

                  next

               next

               aCopy( dbBlankRec( dbfTmpLin ), aTmp )

               aEval( aGet, {| o, i | if( "GET" $ o:ClassName(), o:cText( aTmp[ i ] ), ) } )

            else

               saveDetail( aTmp, aClo, aGet, aTmpFac, dbfTmpLin, oBrw, nMode )

            end if

         end if

      else

         saveDetail( aTmp, aClo, aGet, aTmpFac, dbfTmpLin, oBrw, nMode )

      end if

   else

      WinGather( aTmp, aGet, dbfTmpLin, oBrw, nMode )
      
   end if

   /*
   Guardamos la clave para los campos extra de las lineas----------------------
   */

   if nMode == APPD_MODE
      oLinDetCamposExtra:SaveTemporalAppend( ( dbfTmpLin )->( OrdKeyNo() ) )
   end if

   /*
   Liberacion del bitmap-------------------------------------------------------
   */

  if !empty( bmpImage )
      bmpImage:Hide()
      PalBmpFree( bmpImage:hBitmap, bmpImage:hPalette )
   end if

   cOldCodArt        := ""
   cOldUndMed        := ""
   
   if nMode == APPD_MODE .AND. lEntCon()

      recalculaTotal( aTmpFac )

      aCopy( dbBlankRec( dbfTmpLin ), aTmp )
      aEval( aGet, {| o, i | if( "GET" $ o:ClassName(), o:cText( aTmp[ i ] ), ) } )

      setDlgMode( aTmp, aGet, oFld, oSayPr1, oSayPr2, oSayVp1, oSayVp2, oStkAct, nMode, oTotal, aTmpFac, , oSayLote )

      sysRefresh()

      if !empty( aGet[ _CREF ] )
         aGet[ _CREF ]:SetFocus()
      end if

   else

      oDlg:end( IDOK )

   end if

Return nil

//--------------------------------------------------------------------------//

Static Function saveDetail( aTmp, aClo, aGet, aTmpFac, dbfTmpLin, oBrw, nMode )

   local hAtipica
   local sOfertaArticulo
   local nCajasGratis         := 0
   local nUnidadesGratis      := 0

   // Atipicas ----------------------------------------------------------------

   hAtipica                   := hAtipica( hValue( aTmp, aTmpFac ) )
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
      sOfertaArticulo         := structOfertaArticulo( D():getHashArray( aTmpFac, "FacCliT", nView ), D():getHashArray( aTmp, "FacCliL", nView ), nTotLFacCli( aTmp ), nView )
      if !empty( sOfertaArticulo ) 
         nCajasGratis         := sOfertaArticulo:nCajasGratis
         nUnidadesGratis      := sOfertaArticulo:nUnidadesGratis
      end if
   end if 

   // Cajas gratis ---------------------------------------------------------

   if nCajasGratis != 0
      aTmp[ _LLINOFE ]        := .t.
      aTmp[ _NCANENT ]        -= nCajasGratis
      commitDetail( aTmp, aClo, nil, aTmpFac, dbfTmpLin, oBrw, nMode )

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

      commitDetail( aTmp, aClo, nil, aTmpFac, dbfTmpLin, oBrw, nMode )

      aTmp[ _LLINOFE ]        := .t.
      aTmp[ _NUNICAJA]        := nUnidadesGratis 
      aTmp[ _NPREUNIT]        := 0
      aTmp[ _NDTO    ]        := 0
      aTmp[ _NDTODIV ]        := 0
      aTmp[ _NDTOPRM ]        := 0
      aTmp[ _NCOMAGE ]        := 0
   end if 

   commitDetail( aTmp, aClo, aGet, aTmpFac, dbfTmpLin, oBrw, nMode )

Return nil

//--------------------------------------------------------------------------//

Static Function commitDetail( aTmp, aClo, aGet, aTmpFac, dbfTmpLin, oBrw, nMode )

   winGather( aTmp, aGet, dbfTmpLin, oBrw, nMode, nil, .f. )

   if ( nMode == APPD_MODE ) .and. ( aClo[ _LKITART ] )
      appendKit( aClo, aTmpFac )
   end if

Return nil

//--------------------------------------------------------------------------//

STATIC FUNCTION AppendKit( uTmpLin, aTmpFac )

   local cCodArt
   local cSerFac
   local nNumFac
   local cSufFac
   local nCanEnt
   local dFecFac
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
   local nRecAct                       := ( dbfKit    )->( RecNo() )
   local nRecLin                       := ( dbfTmpLin )->( RecNo() )
   local nNumLin                       := ( dbfTmpLin )->nNumLin
   local nPosPrint
   local nUnidades                     := 0
   local nStkActual                    := 0
   local nStockMinimo                  := 0

   if isArray( uTmpLin )
      cCodArt                          := uTmpLin[ _CREF    ]
      cSerFac                          := uTmpLin[ _CSERIE  ]
      nNumFac                          := uTmpLin[ _NNUMFAC ]
      cSufFac                          := uTmpLin[ _CSUFFAC ]
      nCanEnt                          := uTmpLin[ _NCANENT ]
      dFecFac                          := uTmpLin[ _DFECHA  ]
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
      nTarLin                          := uTmpLin[ _NTARLIN ]
   else
      cCodArt                          := ( uTmpLin )->cRef
      cSerFac                          := ( uTmpLin )->cSerie
      nNumFac                          := ( uTmpLin )->nNumFac
      cSufFac                          := ( uTmpLin )->cSufFac
      nCanEnt                          := ( uTmpLin )->nCanEnt
      dFecFac                          := ( uTmpLin )->dFecha
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
            ( dbfTmpLin )->cGrpFam     := cGruFam( ( dbfTmpLin )->cCodFam, dbfFamilia )

            /*
            Datos de la cabecera-----------------------------------------------
            */           

            ( dbfTmpLin )->cSerie      := cSerFac
            ( dbfTmpLin )->nNumFac     := nNumFac
            ( dbfTmpLin )->cSufFac     := cSufFac
            ( dbfTmpLin )->nCanEnt     := nCanEnt
            ( dbfTmpLin )->dFecha      := dFecFac
            ( dbfTmpLin )->cTipMov     := cTipMov
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
               ( dbfTmpLin )->nPreUnit := nRetPreArt( nTarLin, aTmpFac[ _CDIVFAC ], aTmpFac[ _LIVAINC ], D():Articulos( nView ), D():Get( "Divisas", nView ), dbfKit, D():Get( "TIva", nView ), , , oNewImp )
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

            /*
            Si el kit posee un nuevo kit---------------------------------------
            */

            if ( D():Articulos( nView ) )->lKitArt
               AppendKit( dbfTmpLin, aTmpFac )
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

   IF _NPCTIVA1 == nil .OR. _NPCTIVA2 == nil .OR. _NPCTIVA3 == nil
      RETURN .T.
   END IF

   IF _NPCTIVA1 == nCodIva .OR. _NPCTIVA2 == nCodIva .OR. _NPCTIVA3 == nCodIva
      RETURN .T.
   END IF

   MsgStop( "Factura con más de 3 tipos de " + cImp() )

RETURN .F.

//---------------------------------------------------------------------------//

/*
Funcion Auxiliar para la edición de Lineas de Detalle en una Factura
*/

STATIC FUNCTION EdtDeta( oBrwDet, bEdtDet, aTmp, lTot, nFacMod )

   if lRecibosPagadosTmp( dbfTmpPgo )
      MsgStop( "No se pueden modificar registros a una factura con recibos cobrados" )
      return .f.
   end if

   /*
   Comprobar q no traiga mas de un registros seleccionado si es asi estamos en
   modo MULT_MODE o edicion de multiple registros
   */

   if ( dbfTmpLin )->lSel
      WinMulRec( oBrwDet, bEdtDet, dbfTmpLin, lTot, nFacMod, aTmp )
   else
      WinEdtRec( oBrwDet, bEdtDet, dbfTmpLin, lTot, nFacMod, aTmp )
   end if

   /*
   if !empty( aNumAlb ) .or. aTmp[ _LIMPALB ]

      MsgStop( "No se pueden modificar registros a una factura que" + CRLF + ;
               "proviene de Facturas." )

   end if
   */

RETURN ( RecalculaTotal( aTmp ) )

//--------------------------------------------------------------------------//

/*
Funcion Auxiliar para borrar las Lineas de Detalle en una Factura
*/

STATIC FUNCTION DelDeta()

   /*
   if lRecibosPagadosTmp( dbfTmpPgo )
      MsgStop( "No se pueden eliminar registros a una factura con recibos cobrados" )
      return .f.
   end if
   */
   
   CursorWait()

   while ( dbfTmpSer )->( dbSeek( str( ( dbfTmpLin )->nNumLin, 4 ) ) )
      ( dbfTmpSer )->( dbDelete() )
   end while

   if ( dbfTmpLin )->lKitArt
      dbDelKit( , dbfTmpLin, ( dbfTmpLin )->nNumLin )
   end if

   CursorWE()

RETURN .t. //

//--------------------------------------------------------------------------//

/*
Finaliza la transacción de datos
*/

STATIC FUNCTION EndTrans( aTmp, aGet, oBrw, oBrwDet, oBrwPgo, aNumAlb, nMode, oDlg )

   local n
   local nOrd
   local oError
   local oBlock
   local cSerFac
   local nNumFac
   local nNumNFC
   local cSufFac
   local cNumPed
   local cNumAlb
   local dFecFac
   local cCodCli
   local tFecFac

   if empty( aTmp[ _CSERIE ] )
      aTmp[ _CSERIE ]   := "A"
   end if

   cSerFac              := aTmp[ _CSERIE  ]
   nNumFac              := aTmp[ _NNUMFAC ]
   cSufFac              := aTmp[ _CSUFFAC ]
   cNumPed              := aTmp[ _CNUMPED ]
   cNumAlb              := aTmp[ _CNUMALB ]
   dFecFac              := aTmp[ _DFECFAC ]
   tFecFac              := aTmp[ _TFECFAC ]
   cCodCli              := aTmp[ _CCODCLI ]

   /*
   Comprobamos la fecha del documento------------------------------------------
   */

   if !lValidaOperacion( aTmp[ _DFECFAC ] )
      Return .f.
   end if

   if !lValidaSerie( aTmp[ _CSERIE ] )
      Return .f.
   end if

   if lClienteBloqueado( aGet )
      Return .f.
   end if

   /*
   Estos campos no pueden estar vacios-----------------------------------------
   */

   if lNombreVacio( aGet, aTmp[ _CNOMCLI ] )
      Return .f.
   end if

   if empty( aTmp[ _CDNICLI ] )
      msgStop( "D.N.I. / C.I.F. de cliente no puede estar vacío." )
      if !empty( aGet[ _CDNICLI ] )
         aGet[ _CDNICLI ]:SetFocus()
      end if   
      return .f.
   end if

   if empty( aTmp[ _CDIRCLI ] )
      msgStop( "Domicilio de cliente no puede estar vacío." )
      if !empty( aGet[ _CDIRCLI ] )
         aGet[ _CDIRCLI ]:SetFocus()
      end if
      return .f.
   end if

   if lAlmacenVacio( aGet, aTmp[ _CCODALM ] )
      Return .f.
   end if

   if lFormaPagoVacia( aGet, aTmp[ _CCODPAGO ] )
      Return .f.
   end if

   if lDivisaVacia( aGet, aTmp[ _CDIVFAC ] )
      Return .f.
   end if

   if !lFormaPagoCobrado( aTmp[ _CCODPAGO ], D():FormasPago( nView ) )
      if lClienteRiesgoAlcanzado( aTmp[ _CCODCLI ], oStock, D():Clientes( nView ), nTotFac, nMode )
         msgStop( "Este cliente supera el limite de riesgo permitido." )
         if !empty( aGet[ _CCODCLI ] )
            aGet[ _CCODCLI ]:SetFocus()
         end if   
         return .f.
      end if
   end if 

   if empty( aTmp[ _CCODAGE ] ) .and. lRecogerAgentes()
      msgStop( "Agente no puede estar vacío." )
      if !empty( aGet[ _CCODAGE ] )
         aGet[ _CCODAGE ]:SetFocus()
      end if   
      return .f.
   end if

   if empty( aTmp[ _CCODOBR ] ) .and. lObras()
      MsgStop( "Debe de introducir una obra." )
      if !empty( aGet[ _CCODOBR ] )
         aGet[ _CCODOBR ]:SetFocus()
      end if
      return .f.
   end if

   if lLineasVacias()
      return .f.
   end if

   if lPasNil() .and. ( nMode == APPD_MODE .or. nMode == DUPL_MODE )

      ( dbfTmpLin )->( dbGoTop() )
      while !( dbfTmpLin )->( eof() )

         if !( dbfTmpLin )->lControl .and. ( dbfTmpLin )->nPreUnit == 0 .and. !( dbfTmpLin )->lKitPrc
            if !ApoloMsgNoYes( "El artículo " + Rtrim( ( dbfTmpLin )->cRef ) + " - " + Rtrim( Descrip( dbfTmpLin ) ) + " no esta valorado.", "¿ Desea continuar archivando la factura ?" )
               return .f.
            end if
         end if
    
         ( dbfTmpLin )->( dbSkip() )

      end while

   end if

   // Para q nadie toque mientras grabamos----------------------------------------

   DisableAcceso()

   // Ejecutamos script del evento before append-------------------------------

   if isAppendOrDuplicateMode( nMode )
      if isfalse( runEventScript( "FacturasClientes\beforeAppend", aTmp, dbfTmpLin ) )
         return .f.
      end if 
   end if

   if isEditMode( nMode )
      if isfalse( runEventScript( "FacturasClientes\beforeEdit", aTmp, dbfTmpLin ) )
         return .f.
      end if 
   end if

   aTmp[ _DFECCRE ]        := Date()
   aTmp[ _CTIMCRE ]        := Time()
   aTmp[ _NTARIFA ]        := oGetTarifa:getTarifa()
   aTmp[ _LALQUILER ]      := ( !empty( oTipFac ) .and. oTipFac:nAt == 2 )

   oDlg:Disable()

   TComercio:resetProductsToUpdateStocks()

   oBlock      := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      oMsgText( "Archivando" )
      
      if !empty( oMeter )
         oMeter:Set( 1 )
      end if   

      // Quitamos los filtros--------------------------------------------------------

      ( dbfTmpLin )->( dbClearFilter() )

      // Nuevo registro-------------------------------------------------------------

      if isAppendOrDuplicateMode( nMode )

         oMsgText( "Obteniendo nuevo contador" )

         if !empty( oMeter )
            oMeter:set( 2 )
         end if 

         // Obtenemos el nuevo numero de la factura----------------------------------

         nNumFac              := nNewDoc( cSerFac, D():FacturasClientes( nView ), "NFACCLI", , D():Contadores( nView ) )
         aTmp[ _NNUMFAC ]     := nNumFac
         cSufFac              := retSufEmp()
         aTmp[ _CSUFFAC ]     := cSufFac
         aTmp[ _LIMPALB ]     := !empty( aNumAlb )

      end if 

      begintransaction()

      if isEditMode( nMode )
         rollBackFacCli( cSerFac + str( nNumFac ) + cSufFac )
      end if

      /*
      Ahora escribimos en el fichero definitivo-----------------------------------
      Controlando que no metan lineas con unidades a 0 por el tema----------------
      de la importacion de las atipicas-------------------------------------------
      */

      GuardaTemporalesFacCli( cSerFac, nNumFac, cSufFac, dFecFac, tFecFac, cCodCli, aTmp )

      /*
      Rellenamos los campos de totales--------------------------------------------
      */

      oMsgText( "Guardamos los totales" )
      
      if !empty( oMeter )
         oMeter:Set( 4 )
      end if   

      aTmp[ _NTOTNET ]  := nTotNet
      aTmp[ _NTOTIVA ]  := nTotIva
      aTmp[ _NTOTREQ ]  := nTotReq
      aTmp[ _NTOTFAC ]  := nTotFac
      aTmp[ _NTOTSUP ]  := nTotSup
      aTmp[ _NTOTLIQ ]  := nTotCob
      aTmp[ _NTOTPDT ]  := nTotFac - nTotCob

      // Grabamos el registro--------------------------------------------------

      oMsgText( "Guardamos el documento" )
      
      if !empty( oMeter )
         oMeter:Set( 4 )
      end if   

      /*
      Guardamos los campos extra-----------------------------------------------
      */

      oDetCamposExtra:saveExtraField( aTmp[ _CSERIE ] + Str( aTmp[ _NNUMFAC ] ) + aTmp[ _CSUFFAC ], "" )

      /*
      Guardamos definitivamente el registro------------------------------------
      */

      WinGather( aTmp, , D():FacturasClientes( nView ), , nMode )

      // Actualizamos el estado de los Facturas de clientes--------------------

      oMsgText( "Actualizamos el estado de los Facturas" )
      
      if !empty( oMeter )
         oMeter:Set( 5 )
      end if

      if len( aNumAlb ) > 0
         for n := 1 to len( aNumAlb )
            if ( dbfAlbCliT )->( dbSeek( aNumAlb[ n ] ) )
               SetFacturadoAlbaranCliente( .t., , dbfAlbCliT, dbfAlbCliL, dbfAlbCliS, cSerFac + str( nNumFac ) + cSufFac )
            end if
         next
      end if

      /*
      Marcamos como pasadas las entregas de pedidos----------------------------
      */

      oMsgText( "Actualizamos el estado de los pedidos" )
      
      if !empty( oMeter )
         oMeter:Set( 6 )
      end if   

      if !empty( cNumPed )

         /*
         Si la factura proviene de un pedido, le ponemos el estado----------------
         */

         oStock:SetEstadoPedCli( cNumPed, .t., cSerFac + str( nNumFac ) + cSufFac )

         if( dbfPedCliP )->( dbSeek( cNumPed ) )

            while ( dbfPedCliP )->cSerPed + str( ( dbfPedCliP )->nNumPed ) + ( dbfPedCliP )->cSufPed == cNumPed .and. !( dbfPedCliP )->( Eof() )

               if dbLock( dbfPedCliP )
                  ( dbfPedCliP )->lPasado := .t.
                  ( dbfPedCliP )->( dbUnLock() )
               end if

               ( dbfPedCliP )->( dbSkip() )

               SysRefresh()

            end while

         end if

      end if

      /*
      Marcamos como pasadas las entregas de Facturas--------------------------
      */

      oMsgText( "Marcamos las entregas de las facturas" )
      
      if !empty( oMeter )
         oMeter:Set( 7 )
      end if    

      if !empty( cNumAlb )

         if( dbfAlbCliP )->( dbSeek( cNumAlb ) )

            while ( dbfAlbCliP )->cSerAlb + str( ( dbfAlbCliP )->nNumAlb ) + ( dbfAlbCliP )->cSufAlb == cNumAlb .and. !( dbfAlbCliP )->( Eof() )

               if dbLock( dbfAlbCliP )
                  ( dbfAlbCliP )->lPasado := .t.
                  ( dbfAlbCliP )->( dbUnLock() )
               end if

               ( dbfAlbCliP )->( dbSkip() )

               SysRefresh()

            end while

         end if

      end if

      // Escribe los datos pendientes------------------------------------------------

      oMsgText( "Finalizamos la transacción" )

      commitTransaction()

      // Generar los pagos de las facturas-------------------------------------------

      oMsgText( "Generamos los pagos" )
      
      if !empty( oMeter )
         oMeter:Set( 8 )
      end if    

      genPgoFacCli( cSerFac + str( nNumFac, 9 ) + cSufFac, D():FacturasClientes( nView ), D():FacturasClientesLineas( nView ), D():FacturasClientesCobros( nView ), D():AnticiposClientes( nView ), D():Clientes( nView ), D():FormasPago( nView ), dbfDiv, dbfIva, nMode )

      /*
      Comprobamos el estado de la factura-----------------------------------------
      */

      oMsgText( "Comprobamos el estado de la factura" )
      
      if !empty( oMeter )
         oMeter:Set( 9 )
      end if   

      ChkLqdFacCli( nil, D():FacturasClientes( nView ), D():FacturasClientesLineas( nView ), D():FacturasClientesCobros( nView ), D():AnticiposClientes( nView ), dbfIva, dbfDiv )

   RECOVER USING oError

      RollBackTransaction()

      msgStop( "Imposible almacenar documento" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE
   ErrorBlock( oBlock )

   /*
   Cerramos el dialogo---------------------------------------------------------
   */

   oMsgText( "Cerramos el dialogo" )
   
   if !empty( oMeter )
      oMeter:Set( 10 )
   end if   

   TComercio:updateWebProductStocks()

   oDlg:Enable()
   oDlg:End( IDOK )

   EnableAcceso()

Return .t.

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

Static Function runEDIScript( uParam1, uParam2, uParam3, uParam4, uParam5, uParam6, uParam7, uParam8, uParam9, uParam10 )

   runEventScript( "FacturasClientes\EDI", uParam1, uParam2, uParam3, uParam4, uParam5, uParam6, uParam7, uParam8, uParam9, uParam10 )

Return ( nil )

//---------------------------------------------------------------------------//

Static Function CreateFileEDI()

   local cCabeceraFactura     := uFieldEmpresa( "cRutEdi" ) + "\" + "SINCC.TXT"
   local cLineaFactura        := uFieldEmpresa( "cRutEdi" ) + "\" + "SINCL.TXT"
   local cVencimientoFactura  := uFieldEmpresa( "cRutEdi" ) + "\" + "SINCV.TXT"
   local cDescuentoFactura    := uFieldEmpresa( "cRutEdi" ) + "\" + "SINCD.TXT"
   local cImpuestosFactura    := uFieldEmpresa( "cRutEdi" ) + "\" + "SINCI.TXT"

   if file( cCabeceraFactura )
      ferase( cCabeceraFactura )
   end if
   if file( cLineaFactura )
      ferase( cLineaFactura )
   end if
   if file( cVencimientoFactura )
      ferase( cVencimientoFactura )
   end if
   if file( cDescuentoFactura )
      ferase( cDescuentoFactura )
   end if
   if file( cImpuestosFactura )
      ferase( cImpuestosFactura )
   end if

   hCabeceraFactura           := fCreate( cCabeceraFactura     )
   hLineaFactura              := fCreate( cLineaFactura        )
   hVencimientoFactura        := fCreate( cVencimientoFactura  )
   hDescuentoFactura          := fCreate( cDescuentoFactura    )
   hImpuestosFactura          := fCreate( cImpuestosFactura    )

return nil

//---------------------------------------------------------------------------//

Static Function CloseFileEDI()

   fClose( hCabeceraFactura      )
   fClose( hLineaFactura         )
   fClose( hVencimientoFactura   )
   fClose( hDescuentoFactura     )
   fClose( hImpuestosFactura     )

return nil

//---------------------------------------------------------------------------//

Static Function ExportarEDI( lNoExportados, oTree )

   local oNode
   local nDescuento           := 0
   local nNumeroLinea         := 0
   local cNumeroFactura

   if ( D():FacturasClientes( nView ) )->lExpEdi .and. lNoExportados
      oNode                   := oTree:Add( "Factura : " + ( D():FacturasClientes( nView ) )->cSerie + "/" + Alltrim( str( ( D():FacturasClientes( nView ) )->nNumFac ) ) + "/" + Alltrim( ( D():FacturasClientes( nView ) )->cSufFac ) + " anteriormente generada.", 1 )
      oTree:Select( oNode )
      Return .f.
   end if

   cNumeroFactura             := ( D():FacturasClientes( nView ) )->cSerie + str( ( D():FacturasClientes( nView ) )->nNumFac ) + ( D():FacturasClientes( nView ) )->cSufFac

   if hCabeceraFactura        != -1 .and.;
      hLineaFactura           != -1 .and.;
      hVencimientoFactura     != -1 .and.;
      hDescuentoFactura       != -1 .and.;
      hImpuestosFactura       != -1

      nTotFacCli( cNumeroFactura, D():FacturasClientes( nView ), D():FacturasClientesLineas( nView ), dbfIva, dbfDiv, D():FacturasClientesCobros( nView ), D():AnticiposClientes( nView ) )

      /*
      Cabecera de facturas-----------------------------------------------------
      */

      ExportaEDICabecera( hCabeceraFactura )

      /*
      Ahora vamos a ver si hay descuentos en la cabecera-----------------------
      */

      if !empty( ( D():FacturasClientes( nView ) )->nDtoEsp )
         ExportaEDIDescuentoCabecera( ( D():FacturasClientes( nView ) )->nDtoEsp, nTotDto, ++nDescuento, hDescuentoFactura )
      end if

      if !empty( ( D():FacturasClientes( nView ) )->nDpp )
         ExportaEDIDescuentoCabecera( ( D():FacturasClientes( nView ) )->nDpp, nTotDpp, ++nDescuento, hDescuentoFactura )
      end if

      if !empty( ( D():FacturasClientes( nView ) )->nDtoAtp )
         ExportaEDIDescuentoCabecera( ( D():FacturasClientes( nView ) )->nDtoAtp, nTotAtp, ++nDescuento, hDescuentoFactura )
      end if

      if !empty( ( D():FacturasClientes( nView ) )->nDtoUno )
         ExportaEDIDescuentoCabecera( ( D():FacturasClientes( nView ) )->nDtoUno, nTotUno, ++nDescuento, hDescuentoFactura )
      end if

      if !empty( ( D():FacturasClientes( nView ) )->nDtoDos )
         ExportaEDIDescuentoCabecera( ( D():FacturasClientes( nView ) )->nDtoDos, nTotDos, ++nDescuento, hDescuentoFactura )
      end if

      /*
      Impuestos de facturas----------------------------------------------------
      */

      ExportaEDIImpuestos( hImpuestosFactura )

      /*
      Lineas de facturas-------------------------------------------------------
      */

      if ( D():FacturasClientesLineas( nView ) )->( dbSeek( cNumeroFactura ) )

         while ( D():FacturasClientesLineas( nView ) )->cSerie + str( ( D():FacturasClientesLineas( nView ) )->nNumFac ) + ( D():FacturasClientesLineas( nView ) )->cSufFac == cNumeroFactura .and. !( D():FacturasClientesLineas( nView ) )->( eof() )

            if lValLine( D():FacturasClientesLineas( nView ) )

               ExportaEDILinea( ++nNumeroLinea, hLineaFactura  )

               if ( D():FacturasClientesLineas( nView ) )->nDto != 0
                  ExportaEDIDescuentoLinea( ( D():FacturasClientesLineas( nView ) )->nDto, nDtoLFacCli( D():FacturasClientesLineas( nView ), nRouDiv, nVdvDiv ), nNumeroLinea, ++nDescuento, hDescuentoFactura  )
               end if

               if ( D():FacturasClientesLineas( nView ) )->nDtoPrm != 0
                  ExportaEDIDescuentoLinea( ( D():FacturasClientesLineas( nView ) )->nDtoPrm, nPrmLFacCli( D():FacturasClientesLineas( nView ), nRouDiv, nVdvDiv ), nNumeroLinea, ++nDescuento, hDescuentoFactura  )
               end if

            end if

            ( D():FacturasClientesLineas( nView ) )->( dbSkip() )

         end while

      end if

      /*
      Pagos de facturas--------------------------------------------------------
      */

      nNumeroLinea         := 0

      if ( D():FacturasClientesCobros( nView ) )->( dbSeek( cNumeroFactura ) )

         while ( D():FacturasClientesCobros( nView ) )->cSerie + str( ( D():FacturasClientesCobros( nView ) )->nNumFac ) + ( D():FacturasClientesCobros( nView ) )->cSufFac == cNumeroFactura .and. !( D():FacturasClientesCobros( nView ) )->( eof() )

            ExportaEDIRecibo( ++nNumeroLinea, hVencimientoFactura )

            ( D():FacturasClientesCobros( nView ) )->( dbSkip() )

         end while

      end if

      /*
      Marcamos la factura como exportada---------------------------------------
      */

      if dbLock( D():FacturasClientes( nView ) )
         ( D():FacturasClientes( nView ) )->lExpEdi    := .t.
         ( D():FacturasClientes( nView ) )->dFecEdi    := GetSysDate()
         ( D():FacturasClientes( nView ) )->cHorEdi    := Time()
         ( D():FacturasClientesLineas( nView ) )->( dbUnlock() )
      end if

      oNode                := oTree:Add( "Factura : " + ( D():FacturasClientes( nView ) )->cSerie + "/" + Alltrim( str( ( D():FacturasClientes( nView ) )->nNumFac ) ) + "/" + Alltrim( ( D():FacturasClientes( nView ) )->cSufFac ) + " ficheros generados.", 1 )

   else

      oNode                := oTree:Add( "Factura : " + ( D():FacturasClientes( nView ) )->cSerie + "/" + Alltrim( str( ( D():FacturasClientes( nView ) )->nNumFac ) ) + "/" + Alltrim( ( D():FacturasClientes( nView ) )->cSufFac ) + " ficheros no generados.", 0 )

   end if

   oTree:Select( oNode )

Return .t.

//---------------------------------------------------------------------------//

Static Function ExportaEDICabecera( hFicheroFactura )

   local cCabecera         := ""
   local nDescuento        := 0

   // cCabecera         += Padr( "SINCC", 6 )                                                                                       // 6.  Cabecera
   cCabecera         += Padr( "380", 6 )                                                                                         // 12. Factura comercial
   cCabecera         += Padr( Alltrim( ( D():FacturasClientes( nView ) )->cSerie + str( ( D():FacturasClientes( nView ) )->nNumFac ) + ( D():FacturasClientes( nView ) )->cSufFac) , 17 ) // 29. Numero factura
   cCabecera         += Padr( uFieldEmpresa( "cCodEdi" ), 13 )                                                                   // 42. Codigo de Vendedor a quien se pide
   cCabecera         += Padr( Retfld( ( D():FacturasClientes( nView ) )->cCodCli, D():Clientes( nView ), "cCodEdi" ), 13 )                                      // 55. Codigo de Comprador (quien pide)
   cCabecera         += Padr( "", 6 )                                                                                            // 61. Funcion del mensaje
   cCabecera         += Padr( Dtos( ( D():FacturasClientes( nView ) )->dFecFac ), 8 )                                                               // 69. Fecha de la factura
   cCabecera         += Padr( Dtos( ( D():FacturasClientes( nView ) )->dFecFac ) + Dtos( ( D():FacturasClientes( nView ) )->dFecFac ), 16 )                            // 85. Periodo de facturaci-n pongo la misma fecha 2 veces
   cCabecera         += Padr( "42", 6 )                                                                                          // 91. Forma de pago 42 por defecto
   cCabecera         += Padr( uFieldEmpresa( "cCodEdi" ), 13 )                                                                   // 104. Codigo de Emisor de la factura coincide ( quien factura )
   cCabecera         += Padr( Retfld( ( D():FacturasClientes( nView ) )->cCodCli, D():Clientes( nView ), "cCodEdi" ), 13 )                                      // 117. Codigo de Receptor de la factura ( quien recibe )
   if !empty( ( D():FacturasClientes( nView ) )->cCodObr )
      cCabecera      += Padr( Retfld( ( D():FacturasClientes( nView ) )->cCodCli + ( D():FacturasClientes( nView ) )->cCodObr, dbfObrasT, "cCodEdi" ), 13 )            // 130. Codigo del receptor de la mercancia con codigo EDI en la obra
   else
      cCabecera      += Padr( Retfld( ( D():FacturasClientes( nView ) )->cCodCli, D():Clientes( nView ), "cCodEdi" ), 13 )                                      // 130. Codigo del receptor de la mercancia con c-odigo EDI en el cliente
   end if
   cCabecera         += Padr( uFieldEmpresa( "cCodEdi" ), 13 )                                                                   // 143. Codigo receptor del pago
   cCabecera         += Padr( Retfld( ( D():FacturasClientes( nView ) )->cCodCli, D():Clientes( nView ), "cCodEdi" ), 13 )                                      // 156. Codigo del emisor del pago
   cCabecera         += Padr( "", 6 )                                                                                            // 162. Razon o cargo del abono.
   cCabecera         += Padr( ( D():FacturasClientes( nView ) )->cSuFac, 17 )                                                                       // 179. Numero del pedido
   cCabecera         += Padr( ( D():FacturasClientes( nView ) )->cSuAlb, 17 )                                                                       // 196. Numero del albaran
   cCabecera         += Padr( "", 3 )                                                                                            // 199. Calificador documento rectificado sustituido
   cCabecera         += Padr( "", 17 )                                                                                           // 216. Numero documento rectificado sustituido
   cCabecera         += Padr( "", 17 )                                                                                           // 233. Numero de contrato o acuerdo
   cCabecera         += Padr( "", 17 )                                                                                           // 250. Numero de relacion de entregas
   cCabecera         += Padr( ( D():FacturasClientes( nView ) )->cNomCli, 70 )                                                                      // 320. Razon social del receptor de la factura
   cCabecera         += Padr( ( D():FacturasClientes( nView ) )->cDirCli, 70 )                                                                      // 390. Direccion del receptor de la factura
   cCabecera         += Padr( ( D():FacturasClientes( nView ) )->cPobCli, 35 )                                                                      // 425. Población del receptor de la factura
   cCabecera         += Padr( ( D():FacturasClientes( nView ) )->cPosCli, 9 )                                                                       // 434. Codigo postal del receptor de la factura
   cCabecera         += Padr( ( D():FacturasClientes( nView ) )->cDniCli, 17 )                                                                      // 451. Nif del receptor de la factura
   cCabecera         += Padr( uFieldEmpresa( "cDomicilio" ), 70 )                                                                // 521. Domicilio del emisor de la factura
   cCabecera         += Padr( uFieldEmpresa( "cPoblacion" ), 35 )                                                                // 556. Población del emisor de la factura
   cCabecera         += Padr( uFieldEmpresa( "cCodPos" ), 9 )                                                                    // 565. Codigo postal del emisor de la factura
   cCabecera         += Padr( ( D():FacturasClientes( nView ) )->cDivFac, 6 )                                                                       // 571. Codigo de la divisa
   cCabecera         += Padr( "", 8 )                                                                                            // 579. Fecha de vencimiento unico
   cCabecera         += Padl( Trans( nTotNet, "99999999999999.999" ), 18 )                                                       // 599. Importe neto factura
   cCabecera         += Padl( Trans( nTotNet, "99999999999999.999" ), 18 )                                                       // 617. Base imponible factura
   cCabecera         += Padl( Trans( nTotBrt, "99999999999999.999" ), 18 )                                                       // 635. Importe bruto total factura
   cCabecera         += Padl( Trans( nTotImp, "99999999999999.999" ), 18 )                                                       // 653. Impuestos de factura
   cCabecera         += Padl( Trans( nTotFac, "99999999999999.999" ), 18 )                                                       // 671. Total factura
   cCabecera         += Padl( Trans( 0, "99999999999999.999" ), 18 )                                                             // 689. Subvenciones vinculadas a precio
   cCabecera         += Padl( Trans( 0, "99999999999999.999" ), 18 )                                                             // 707. Incrementos del importe bruto
   cCabecera         += Padl( Trans( nTotDto, "99999999999999.999" ), 18 )                                                       // 725. Minoraciones del importe bruto
   cCabecera         += Padr( "", 17 )                                                                                           // 742. Identificacion adicional de la parte
   cCabecera         += Padr( "", 13 )                                                                                           // 755. Receptor del documento
   cCabecera         += Padr( "", 17 )                                                                                           // 773. Identificacion adicional proveedor
   cCabecera         += CRLF

   fWrite( hFicheroFactura, cCabecera )

Return nil

Static Function ExportaEDILinea( nNumeroLinea, hFicheroFactura )

   local cLinea      := ""

   //cLinea            += Padr( "SINCL", 6 )                                                                                     // 6.  Cabecera
   cLinea            += Padr( "380", 6 )                                                                                         // 12. Factura comercial
   cLinea            += Padr( Alltrim( ( D():FacturasClientes( nView ) )->cSerie + str( ( D():FacturasClientes( nView ) )->nNumFac ) + ( D():FacturasClientes( nView ) )->cSufFac) , 17 ) // 29. Numero factura
   cLinea            += Padr( uFieldEmpresa( "cCodEdi" ), 13 )                                                                   // 42. Codigo de Vendedor a quien se pide
   cLinea            += Padr( Retfld( ( D():FacturasClientes( nView ) )->cCodCli, D():Clientes( nView ), "cCodEdi" ), 13 )                                      // 55. Codigo de Comprador (quien pide)
   cLinea            += Padl( Trans( nNumeroLinea, "999999" ), 6 )                                                               // 61. Numero de linea
   cLinea            += Padr( RetFld( ( D():FacturasClientesLineas( nView ) )->cRef, D():Articulos( nView ), "Codebar" ), 15 ) //Padr( ( D():FacturasClientesLineas( nView ) )->cRef, 15 )    // 76. Código articulo / Codigo de barras
   cLinea            += Padr( if( !empty( ( D():FacturasClientesLineas( nView ) )->cDetalle ), ( D():FacturasClientesLineas( nView ) )->cDetalle, ( D():FacturasClientesLineas( nView ) )->mLngDes ), 35 )  // 111. Descripción articulo
   cLinea            += Padr( "M", 1 )                                                                                           // 112. Tipo de articulo
   cLinea            += Padr( "", 15 )                                                                                           // 127. Codigo interno articulo proveedor
   cLinea            += Padr( "", 15 )                                                                                           // 142. Codigo interno articulo cliente
   cLinea            += Padr( "", 15 )                                                                                           // 157. Codigo variable promocional
   cLinea            += Padr( "", 15 )                                                                                           // 172. Codigo unidad expedición
   cLinea            += Padr( ( D():FacturasClientesLineas( nView ) )->cLote, 15 )                                                                        // 187. Numero de lote
   cLinea            += Padl( Trans( nTotNFacCli( D():FacturasClientesLineas( nView ) ), "999999999999.999" ), 16 )                                       // 203. Unidades facturado
   cLinea            += Padl( Trans( 0, "999999999999.999" ), 16 )                                                               // 219. Unidades bonificadas
   cLinea            += Padr( "", 6 )                                                                                            // 225. Unidad de medida
   cLinea            += Padl( Trans( 0, "999999999999.999" ), 16 )                                                               // 241. Unidad entregada
   cLinea            += Padl( Trans( 0, "999999999999.999" ), 16 )                                                               // 257. Unidades de consumo en expedicion
   cLinea            += Padl( Trans( nTotLFacCli( D():FacturasClientesLineas( nView ), nDouDiv, nRouDiv ), "99999999999999.999" ), 18 )                   // 275. Importe total neto
   cLinea            += Padl( Trans( nTotUFacCli( D():FacturasClientesLineas( nView ), nDouDiv ), "99999999999.999" ), 16 )                               // 291. Precio bruto unitario
   cLinea            += Padl( Trans( nTotPFacCli( D():FacturasClientesLineas( nView ), nDouDiv ), "9999999999.9999" ), 16 )                               // 291. Precio neto unitario
   cLinea            += Padr( "", 6 )                                                                                            // 225. Unidad de medida del precio
   cLinea            += Padr( "VAT", 6 )                                                                                         // 225. Calificador de impuesto VAT es impuestos
   cLinea            += Padl( Trans( ( D():FacturasClientesLineas( nView ) )->nIva, "999.99" ), 6 )                                                       // 291. % Impuesto
   cLinea            += Padl( Trans( 0, "9999999999999.999" ), 18 )                                                              // 291. Importe impuesto se aconseja no cumplimentar
   cLinea            += Padl( Trans( if( ( D():FacturasClientes( nView ) )->lRecargo, ( D():FacturasClientesLineas( nView ) )->nReq, 0 ), "999.99" ), 6 )                    // 291. % Recargo de eqivalencia
   cLinea            += Padl( Trans( 0, "9999999999999.999" ), 18 )                                                              // 291. Importe recargo equivalencia se aconseja no cumplimentar
   cLinea            += Padr( "", 6 )                                                                                            // 225. Calificador de otro impuesto VAT es impuestos
   cLinea            += Padl( Trans( 0, "999.99" ), 6 )                                                                          // 291. % otro Impuesto
   cLinea            += Padl( Trans( 0, "9999999999999.999" ), 18 )                                                              // 291. Importe otro impuesto se aconseja no cumplimentar
   cLinea            += Padr( ( D():FacturasClientes( nView ) )->cNumPed, 17 )                                                                      // 179. Numero del pedido
   cLinea            += Padr( ( D():FacturasClientesLineas( nView ) )->cCodAlb, 17 )                                                                      // 196. Numero del albaran
   cLinea            += Padl( Trans( 0, "99999999" ), 8 )                                                                        // 291. Numero de embalajes
   cLinea            += Padr( "", 7 )                                                                                            // 225. Tipo de embalaje
   cLinea            += Padl( Trans( nTotLFacCli( D():FacturasClientesLineas( nView ), nDouDiv, nRouDiv, nVdvDiv, .f. ), "99999999999999.999" ), 18 )     // 275. Importe total bruto
   cLinea            += CRLF

   fWrite( hFicheroFactura, cLinea )

Return nil

Static Function ExportaEDIRecibo( nNumeroRecibo, hFicheroFactura )

   local cRecibo     := ""

   //cRecibo           += Padr( "SINCV", 6 )                                                                                       // 6.  Cabecera
   cRecibo           += Padr( "380", 6 )                                                                                         // 12. Factura comercial
   cRecibo           += Padr( Alltrim( ( D():FacturasClientesCobros( nView ) )->cSerie + str( ( D():FacturasClientesCobros( nView ) )->nNumFac ) + ( D():FacturasClientesCobros( nView ) )->cSufFac ) , 17 )// 29. Numero factura
   cRecibo           += Padr( uFieldEmpresa( "cCodEdi" ), 13 )                                                                   // 42. Codigo de Vendedor a quien se pide
   cRecibo           += Padr( Retfld( ( D():FacturasClientesCobros( nView ) )->cCodCli, D():Clientes( nView ), "cCodEdi" ), 13 )                                      // 55. Codigo de Comprador (quien pide)
   cRecibo           += Padl( Trans( nNumeroRecibo, "999999" ), 6 )                                                              // 61. Numero de Recibo
   cRecibo           += Padr( Dtos( ( D():FacturasClientesCobros( nView ) )->dFecVto ), 8 )                                                               // 76. Código articulo
   cRecibo           += Padl( Trans( nTotRecCli( D():FacturasClientesCobros( nView ), dbfDiv ), "999999999999.999" ), 16 )                                // 203. Unidades facturado
   cRecibo           += CRLF

   fWrite( hFicheroFactura, cRecibo )

Return nil

Static Function ExportaEDIDescuentoCabecera( nPorcentajeDescuento, nTotalDescuento, nDescuento, hFicheroFactura )

   local cCabecera   := ""

   //cCabecera         += Padr( "SINCD", 6 )                                                                                       // 6.  Cabecera
   cCabecera         += Padr( "380", 6 )                                                                                         // 12. Factura comercial
   cCabecera         += Padr( Alltrim( ( D():FacturasClientes( nView ) )->cSerie + str( ( D():FacturasClientes( nView ) )->nNumFac ) + ( D():FacturasClientes( nView ) )->cSufFac ) , 17 )// 29. Numero factura
   cCabecera         += Padr( uFieldEmpresa( "cCodEdi" ), 13 )                                                                   // 42. Codigo de Vendedor a quien se pide
   cCabecera         += Padr( Retfld( ( D():FacturasClientes( nView ) )->cCodCli, D():Clientes( nView ), "cCodEdi" ), 13 )                                      // 55. Codigo de Comprador (quien pide)
   cCabecera         += Padl( Trans( 0, "999999" ), 6 )                                                                          // Numero de linea 0 para cabeceras
   cCabecera         += Padl( Trans( nDescuento, "99" ), 2 )                                                                     // Numero de descuento
   cCabecera         += "A"                                                                                                      // Indicador de descuento
   cCabecera         += Padl( Trans( nDescuento, "999" ), 3 )                                                                    // Numero de descuento
   cCabecera         += Padl( Trans( nPorcentajeDescuento, "9999.9999" ), 9 )                                                    // Porcentaje de descuento atipico
   cCabecera         += Padl( Trans( nTotalDescuento, "99999999999999.999" ), 18 )                                               // Importe descuento atipico
   cCabecera         += Padl( Trans( 0, "99999999999999.999" ), 18 )                                                             // Importe total sujeto a aplicacion
   cCabecera         += Padl( Trans( 0, "999999999999.999" ), 16 )                                                               // Unidades q se descuentan por lineas
   cCabecera         += Padr( "TD", 6 )                                                                                          // Tipo de descuento TD descuento comercial
   cCabecera         += Padl( Trans( 0, "999999999999.999" ), 16 )                                                               // Descuentos monetarios por unidad
   cCabecera         += Padr( "", 6 )                                                                                            // Unidade de medida
   cCabecera         += CRLF

  fWrite( hFicheroFactura, cCabecera )

Return nil

Static Function ExportaEDIDescuentoLinea( nPorcentajeDescuento, nTotalDescuento, nLinea, nDescuento, hFicheroFactura )

   local cLinea      := ""

   //cLinea            += Padr( "SINCD", 6 )                                                                                       // 6.  Cabecera
   cLinea            += Padr( "380", 6 )                                                                                         // 12. Factura comercial
   cLinea            += Padr( Alltrim( ( D():FacturasClientes( nView ) )->cSerie + str( ( D():FacturasClientes( nView ) )->nNumFac ) + ( D():FacturasClientes( nView ) )->cSufFac ) , 17 )// 29. Numero factura
   cLinea            += Padr( uFieldEmpresa( "cCodEdi" ), 13 )                                                                   // 42. Codigo de Vendedor a quien se pide
   cLinea            += Padr( Retfld( ( D():FacturasClientes( nView ) )->cCodCli, D():Clientes( nView ), "cCodEdi" ), 13 )                                      // 55. Codigo de Comprador (quien pide)
   cLinea            += Padl( Trans( nLinea, "999999" ), 6 )                                                                          // Numero de linea 0 para cabeceras
   cLinea            += Padl( Trans( nDescuento, "99" ), 2 )                                                                     // Numero de descuento
   cLinea            += "A"                                                                                                      // Indicador de descuento
   cLinea            += Padl( Trans( nDescuento, "999" ), 3 )                                                                    // Numero de descuento
   cLinea            += Padl( Trans( nPorcentajeDescuento, "9999.9999" ), 9 )                                                    // Porcentaje de descuento atipico
   cLinea            += Padl( Trans( nTotalDescuento, "99999999999999.999" ), 18 )                                               // Importe descuento atipico
   cLinea            += Padl( Trans( 0, "99999999999999.999" ), 18 )                                                             // Importe total sujeto a aplicacion
   cLinea            += Padl( Trans( 0, "999999999999.999" ), 16 )                                                               // Unidades q se descuentan por lineas
   cLinea            += Padr( "TD", 6 )                                                                                          // Tipo de descuento TD descuento comercial
   cLinea            += Padl( Trans( 0, "999999999999.999" ), 16 )                                                               // Descuentos monetarios por unidad
   cLinea            += Padr( "", 6 )                                                                                            // Unidade de medida
   cLinea            += CRLF

  fWrite( hFicheroFactura, cLinea )

Return nil

Static Function ExportaEDIImpuestos( hFicheroFactura )

   local nImpuesto   := 0
   local cImpuesto   := ""

   if !empty( aIvaUno[ 3 ] )
      //cImpuesto      += Padr( "SINCI", 6 )                                                                                       // 6.  Cabecera
      cImpuesto      += Padr( "380", 6 )                                                                                         // 12. Factura comercial
      cImpuesto      += Padr( Alltrim( ( D():FacturasClientes( nView ) )->cSerie + str( ( D():FacturasClientes( nView ) )->nNumFac ) + ( D():FacturasClientes( nView ) )->cSufFac ) , 17 )// 29. Numero factura
      cImpuesto      += Padr( uFieldEmpresa( "cCodEdi" ), 13 )                                                                   // 42. Codigo de Vendedor a quien se pide
      cImpuesto      += Padr( Retfld( ( D():FacturasClientes( nView ) )->cCodCli, D():Clientes( nView ), "cCodEdi" ), 13 )                                      // 55. Codigo de Comprador (quien pide)
      cImpuesto      += Padl( Trans( ++nImpuesto, "99" ), 2 )                                                                    // 61. Numero de impuesto
      cImpuesto      += Padr( "VAT", 6 )                                                                                         // 76. Tipo de impuestos
      cImpuesto      += Padl( Trans( aIvaUno[ 3 ], "999.99" ), 6 )                                                               // 203. % impuestos
      cImpuesto      += Padl( Trans( aIvaUno[ 8 ], "99999999999999.999" ), 18 )                                                  // 203. Importe de tipo de impuesto
      cImpuesto      += Padl( Trans( aIvaUno[ 2 ], "99999999999999.999" ), 18 )                                                  // 203. Base imponible
      cImpuesto      += CRLF
   end if

   if !empty( aIvaDos[ 3 ] )
      //cImpuesto      += Padr( "SINCI", 6 )                                                                                       // 6.  Cabecera
      cImpuesto      += Padr( "380", 6 )                                                                                         // 12. Factura comercial
      cImpuesto      += Padr( Alltrim( ( D():FacturasClientes( nView ) )->cSerie + str( ( D():FacturasClientes( nView ) )->nNumFac ) + ( D():FacturasClientes( nView ) )->cSufFac ) , 17 )// 29. Numero factura
      cImpuesto      += Padr( uFieldEmpresa( "cCodEdi" ), 13 )                                                                   // 42. Codigo de Vendedor a quien se pide
      cImpuesto      += Padr( Retfld( ( D():FacturasClientes( nView ) )->cCodCli, D():Clientes( nView ), "cCodEdi" ), 13 )                                      // 55. Codigo de Comprador (quien pide)
      cImpuesto      += Padl( Trans( ++nImpuesto, "99" ), 2 )                                                                    // 61. Numero de impuesto
      cImpuesto      += Padr( "VAT", 6 )                                                                                         // 76. Tipo de impuestos
      cImpuesto      += Padl( Trans( aIvaDos[ 3 ], "999.99" ), 6 )                                                               // 203. % impuestos
      cImpuesto      += Padl( Trans( aIvaDos[ 8 ], "99999999999999.999" ), 18 )                                                  // 203. Base imponible
      cImpuesto      += Padl( Trans( aIvaDos[ 2 ], "99999999999999.999" ), 18 )                                                  // 203. Importe de tipo de impuesto
      cImpuesto      += CRLF
   end if

   if !empty( aIvaTre[ 3 ] )
      //cImpuesto      += Padr( "SINCI", 6 )                                                                                       // 6.  Cabecera
      cImpuesto      += Padr( "380", 6 )                                                                                         // 12. Factura comercial
      cImpuesto      += Padr( Alltrim( ( D():FacturasClientes( nView ) )->cSerie + str( ( D():FacturasClientes( nView ) )->nNumFac ) + ( D():FacturasClientes( nView ) )->cSufFac ) , 17 )// 29. Numero factura
      cImpuesto      += Padr( uFieldEmpresa( "cCodEdi" ), 13 )                                                                   // 42. Codigo de Vendedor a quien se pide
      cImpuesto      += Padr( Retfld( ( D():FacturasClientes( nView ) )->cCodCli, D():Clientes( nView ), "cCodEdi" ), 13 )                                      // 55. Codigo de Comprador (quien pide)
      cImpuesto      += Padl( Trans( ++nImpuesto, "99" ), 2 )                                                                    // 61. Numero de impuesto
      cImpuesto      += Padr( "VAT", 6 )                                                                                         // 76. Tipo de impuestos
      cImpuesto      += Padl( Trans( aIvaTre[ 3 ], "999.99" ), 6 )                                                               // 203. % impuestos
      cImpuesto      += Padl( Trans( aIvaTre[ 8 ], "99999999999999.999" ), 18 )                                                  // 203. Base imponible
      cImpuesto      += Padl( Trans( aIvaTre[ 2 ], "99999999999999.999" ), 18 )                                                  // 203. Importe de tipo de impuesto
      cImpuesto      += CRLF
   end if

   fWrite( hFicheroFactura, cImpuesto )

Return nil

//---------------------------------------------------------------------------//

static function lChangeEDI( aGet, aTmp )

   if aTmp[ _LEXPEDI ]
      aGet[ _DFECEDI ]:cText( GetSysDate() )
      aGet[ _CHOREDI ]:cText( Time() )
   else
      aGet[ _DFECEDI ]:cText( Ctod( "" ) )
      aGet[ _CHOREDI ]:cText( Space( 5 ) )
   end if

Return .t.

//---------------------------------------------------------------------------//

Static Function CreateFileFacturae( oTree, lFirmar, lEnviar )

   local a
   local oTax
   local nPago
   local nTotal
   local cNumero
   local nNumero
   local oFactura
   local oDiscount
   local nAnticipo
   local oItemLine
   local oInstallment
   local cCodigoEntidad
   local oAdministrativeCentres
   local nOrdAnt

   nNumero              := ( D():FacturasClientes( nView ) )->cSerie + str( ( D():FacturasClientes( nView ) )->nNumFac ) + ( D():FacturasClientes( nView ) )->cSufFac
   cNumero              := ( D():FacturasClientes( nView ) )->cSerie + Alltrim( str( ( D():FacturasClientes( nView ) )->nNumFac ) ) + Rtrim( ( D():FacturasClientes( nView ) )->cSufFac )

   nTotal               := nTotFacCli( nNumero, D():FacturasClientes( nView ), D():FacturasClientesLineas( nView ), dbfIva, dbfDiv, D():FacturasClientesCobros( nView ), D():AnticiposClientes( nView ) )
   nPago                := nTotalRecibosPagadosFacturasCliente( nNumero, D():FacturasClientes( nView ), D():FacturasClientesCobros( nView ), dbfIva, dbfDiv )
   nAnticipo            := nTotAntFacCli( nNumero, D():AnticiposClientes( nView ), dbfIva, dbfDiv )

   oFactura             := TFacturaElectronica():New( oTree )

   with object ( oFactura )

      :cFicheroOrigen            := cPatXml() + cNumero + ".xml"
      :cFicheroDestino           := cPatXml() + cNumero + ".xsig"

      /*
      Datos para el Env-o de  la factura por mail-------------------------------
      */

      :cMailServer               := Rtrim( uFieldEmpresa( "cSrvMai" ) )
      :cMailServerPort           := uFieldEmpresa( "nPrtMai" )
      :cMailServerUserName       := Rtrim( uFieldEmpresa( "cCtaMai" ) )
      :cMailServerPassword       := Rtrim( uFieldEmpresa( "cPssMai" ) )

      /*
      Datos genreales de la factura--------------------------------------------
      */

      :cNif                      := uFieldEmpresa( "cNif" )

      :cInvoiceSeriesCode        := ( D():FacturasClientes( nView ) )->cSerie
      :cInvoiceNumber            := alltrim( str( Year( ( D():FacturasClientes( nView ) )->dFecFac ) ) ) + "/" 
      :cInvoiceNumber            += ( D():FacturasClientes( nView ) )->cSerie + Rtrim( ( D():FacturasClientes( nView ) )->cSufFac ) + "/" 
      :cInvoiceNumber            += alltrim( str( ( D():FacturasClientes( nView ) )->nNumFac ) )
      :cInvoiceCurrencyCode      := ( D():FacturasClientes( nView ) )->cDivFac
      :cTaxCurrencyCode          := ( D():FacturasClientes( nView ) )->cDivFac
      :nInvoiceTotalAmount       := nTotal
      :nTotalOutstandingAmount   := nTotal 
      :nTotalExecutableAmount    := nTotal

      /*
      Parte vendedora----------------------------------------------------------
      */

      :oSellerParty:cTaxIdentificationNumber          := 'ES' + uFieldEmpresa( "cNif" )

      if Val( Left( uFieldEmpresa( "cNif" ), 1 ) ) != 0
         :oSellerParty:cPersonTypeCode                := 'F'
         :oSellerParty:cName                          := uFieldEmpresa( "cNombre" )
         :oSellerParty:cFirstSurname                  := uFieldEmpresa( "cNombre" )
      else
         :oSellerParty:cPersonTypeCode                := 'J'
         :oSellerParty:cCorporateName                 := uFieldEmpresa( "cNombre" )
         :oSellerParty:cTradeName                     := uFieldEmpresa( "cNombre" )
         :oSellerParty:cRegisterOfCompaniesLocation   := uFieldEmpresa( "cNumRegMer" )
      end if

      :oSellerParty:cAddress                          := uFieldEmpresa( "cDomicilio" )
      :oSellerParty:cPostCode                         := uFieldEmpresa( "cCodPos" )
      :oSellerParty:cTown                             := uFieldEmpresa( "cPoblacion" )
      :oSellerParty:cProvince                         := uFieldEmpresa( "cProvincia" )
      :oSellerParty:cTelephone                        := uFieldEmpresa( "cTlf" )
      :oSellerParty:cTelFax                           := uFieldEmpresa( "cFax" )
      :oSellerParty:cWebAddress                       := uFieldEmpresa( "Web" )
      :oSellerParty:cElectronicMail                   := uFieldEmpresa( "EMail" )

      /*
      Parte compradora---------------------------------------------------------
      */

      :oBuyerParty:cTaxIdentificationNumber           := 'ES' + ( D():FacturasClientes( nView ) )->cDniCli

      if Val( Left( ( D():FacturasClientes( nView ) )->cDniCli, 1 ) ) != 0
         :oBuyerParty:cPersonTypeCode                 := 'F'
         :oBuyerParty:cName                           := ( D():FacturasClientes( nView ) )->cNomCli
         :oBuyerParty:cFirstSurname                   := ( D():FacturasClientes( nView ) )->cNomCli
      else
         :oBuyerParty:cPersonTypeCode                 := 'J'
         :oBuyerParty:cCorporateName                  := ( D():FacturasClientes( nView ) )->cNomCli
         :oBuyerParty:cTradeName                      := ( D():FacturasClientes( nView ) )->cNomCli
      end if

      :oBuyerParty:cAddress                           := ( D():FacturasClientes( nView ) )->cDirCli
      :oBuyerParty:cPostCode                          := ( D():FacturasClientes( nView ) )->cPosCli
      :oBuyerParty:cTown                              := ( D():FacturasClientes( nView ) )->cPobCli
      :oBuyerParty:cProvince                          := ( D():FacturasClientes( nView ) )->cPrvCli
      :oBuyerParty:cTelephone                         := RetFld( ( D():FacturasClientes( nView ) )->cCodCli, D():Clientes( nView ), "Telefono" )
      :oBuyerParty:cTelFax                            := RetFld( ( D():FacturasClientes( nView ) )->cCodCli, D():Clientes( nView ), "Fax" )
      :oBuyerParty:cWebAddress                        := RetFld( ( D():FacturasClientes( nView ) )->cCodCli, D():Clientes( nView ), "cWebInt" )
      :oBuyerParty:cElectronicMail                    := RetFld( ( D():FacturasClientes( nView ) )->cCodCli, D():Clientes( nView ), "cMeiInt" )

      /*
      Fechas de emision de factura---------------------------------------------
      */

      :dOperationDate                                 := ( D():FacturasClientes( nView ) )->dFecFac
      :dIssueDate                                     := ( D():FacturasClientes( nView ) )->dFecFac

      :cPlaceOfIssuePostCode                          := uFieldEmpresa( "cCodPos" )
      :cPlaceOfIssueDescription                       := uFieldEmpresa( "cPoblacion" )

      /*
      Totales------------------------------------------------------------------
      */

      :nInvoiceTotal                                  := nTotal
      :nTotalGrossAmount                              := nTotBrt
      :nTotalGrossAmountBeforeTaxes                   := nTotNet

      /*
      Impuestos----------------------------------------------------------------
      */

      for each a in aTotIva

         if !isNil( a[ 3 ] )

            oTax                                      := Tax()
            oTax:nTaxBase                             := a[ 2 ]
            oTax:nTaxRate                             := a[ 3 ]
            oTax:nTaxAmount                           := a[ 8 ]
            oTax:nEquivalenceSurcharge                := a[ 4 ]
            oTax:nEquivalenceSurchargeAmount          := a[ 9 ]

            :addTax( oTax )

         end if

      next

      /*
      Descuentos---------------------------------------------------------------
      */

      if nTotDto != 0

         oDiscount                                 := Discount()
         oDiscount:cDiscountReason                 := ( D():FacturasClientes( nView ) )->cDtoEsp
         oDiscount:nDiscountRate                   := ( D():FacturasClientes( nView ) )->nDtoEsp
         oDiscount:nDiscountAmount                 := nTotDto

         :addDiscount( oDiscount )

      end if

      if nTotDpp != 0

         oDiscount                                 := Discount()
         oDiscount:cDiscountReason                 := ( D():FacturasClientes( nView ) )->cDpp
         oDiscount:nDiscountRate                   := ( D():FacturasClientes( nView ) )->nDpp
         oDiscount:nDiscountAmount                 := nTotDpp

         :addDiscount( oDiscount )

      end if

      if nTotUno != 0

         oDiscount                                 := Discount()
         oDiscount:cDiscountReason                 := ( D():FacturasClientes( nView ) )->cDtoUno
         oDiscount:nDiscountRate                   := ( D():FacturasClientes( nView ) )->nDtoUno
         oDiscount:nDiscountAmount                 := nTotUno

         :addDiscount( oDiscount )

      end if

      if nTotDos != 0

         oDiscount                                 := Discount()
         oDiscount:cDiscountReason                 := ( D():FacturasClientes( nView ) )->cDtoDos
         oDiscount:nDiscountRate                   := ( D():FacturasClientes( nView ) )->nDtoDos
         oDiscount:nDiscountAmount                 := nTotDos

         :addDiscount( oDiscount )

      end if

      if nTotAtp != 0

         oDiscount                                 := Discount()
         oDiscount:cDiscountReason                 := ''
         oDiscount:nDiscountRate                   := ( D():FacturasClientes( nView ) )->nDtoAtp
         oDiscount:nDiscountAmount                 := nTotAtp

         :addDiscount( oDiscount )

      end if

      // Lineas de detalle-----------------------------------------------------

      if ( D():FacturasClientesLineas( nView ) )->( dbSeek( nNumero ) )

         while ( D():FacturasClientesLineas( nView ) )->cSerie + str( ( D():FacturasClientesLineas( nView ) )->nNumFac ) + ( D():FacturasClientesLineas( nView ) )->cSufFac == nNumero .and. !( D():FacturasClientesLineas( nView ) )->( Eof() )

            if lValidLineForFacturae()

               oItemLine                           := ItemLine():New( oFactura )

               oItemLine:cItemDescription          := Descrip( D():FacturasClientesLineas( nView ) )
               oItemLine:nQuantity                 := nTotNFacCli( D():FacturasClientesLineas( nView ) )
               oItemLine:nUnitPriceWithoutTax      := nNetUFacCli( D():FacturasClientesLineas( nView ), nDouDiv ) 
               oItemLine:nUnitPriceWithTax         := nTotUFacCli( D():FacturasClientesLineas( nView ), nDouDiv )

               oItemLine:nIva                      := ( D():FacturasClientesLineas( nView ) )->nIva
               oItemLine:lIvaInc                   := ( D():FacturasClientes( nView ) )->lIvaInc

               // Descuento lineal---------------------------------------------

               if ( D():FacturasClientesLineas( nView ) )->nDtoDiv != 0               

                  oDiscount                        := Discount()
                  oDiscount:nDiscountAmount        := nDescuentoLinealFacCli( D():FacturasClientesLineas( nView ), nDouDiv ) * nTotNFacCli( D():FacturasClientesLineas( nView ) )

                  oItemLine:addDiscount( oDiscount )

               end if

               // Primer descuento en linea---------------------------------------

               if ( D():FacturasClientesLineas( nView ) )->nDto != 0

                  oDiscount                        := Discount()
                  oDiscount:nDiscountRate          := ( D():FacturasClientesLineas( nView ) )->nDto

                  oItemLine:addDiscount( oDiscount )

               end if

               // Descuento de promocion------------------------------------------

               if ( D():FacturasClientesLineas( nView ) )->nDtoPrm != 0

                  oDiscount                        := Discount()
                  oDiscount:nDiscountRate          := ( D():FacturasClientesLineas( nView ) )->nDtoPrm

                  oItemLine:addDiscount( oDiscount )

               end if               

               // Impuestos----------------------------------------------------

               oTax                                := Tax()
               oTax:nTaxRate                       := ( D():FacturasClientesLineas( nView ) )->nIva
               oTax:nTaxBase                       := nNetLFacCli( D():FacturasClientesLineas( nView ), nDouDiv, nRouDiv, , , .f., .f. ) 
               oTax:nTaxAmount                     := nIvaLFacCli( D():FacturasClientesLineas( nView ), nDouDiv, nRouDiv, , , .f., .f. )

               if ( D():FacturasClientes( nView ) )->lRecargo
                  oTax:nEquivalenceSurcharge       := ( D():FacturasClientesLineas( nView ) )->nReq
                  oTax:nEquivalenceSurchargeAmount := nReqLFacCli( D():FacturasClientesLineas( nView ), nDouDiv, nRouDiv, , .f., .f., .f. )
               end if

               oItemLine:addTax( oTax )

               // A-adimos la linea--------------------------------------------

               :addItemLine( oItemLine )

            end if

            ( D():FacturasClientesLineas( nView ) )->( dbSkip() )

         end while

      end if

      // Pagos de factura------------------------------------------------------

      if ( D():FacturasClientesCobros( nView ) )->( dbSeek( nNumero ) )

         while ( D():FacturasClientesCobros( nView ) )->cSerie + str( ( D():FacturasClientesCobros( nView ) )->nNumFac ) + ( D():FacturasClientesCobros( nView ) )->cSufFac == nNumero .and. !( D():FacturasClientesCobros( nView ) )->( Eof() )

            if empty( ( D():FacturasClientesCobros( nView ) )->cTipRec )

               if !empty( cCodigoXmlPago( ( D():FacturasClientesCobros( nView ) )->cCodPgo, D():FormasPago( nView ) ) )

                  oInstallment                           := Installment()
                  oInstallment:dInstallmentDueDate       := ( D():FacturasClientesCobros( nView ) )->dFecVto
                  oInstallment:nInstallmentAmount        := nTotRecCli( D():FacturasClientesCobros( nView ), dbfDiv )
                  oInstallment:cPaymentMeans             := cCodigoXmlPago( ( D():FacturasClientesCobros( nView ) )->cCodPgo, D():FormasPago( nView ) )

                  /*
                  Recibo domiciliado rellenamos con los datos bancarios del cliente
                  */

                  if !Empty( ( D():FormasPago( nView ) )->cCtaBnc )

                     if ( D():FormasPago( nView ) )->( dbSeek( ( D():FacturasClientesCobros( nView ) )->cCodPgo ) )
                           
                           oInstallment:oAccountToBeCredited               := Account()
                           oInstallment:oAccountToBeCredited:cIBAN         := ( D():FormasPago( nView ) )->cPaisIBAN + ( D():FormasPago( nView ) )->cCtrlIBAN + ( D():FormasPago( nView ) )->cEntBnc + ( D():FormasPago( nView ) )->cSucBnc + ( D():FormasPago( nView ) )->cDigBnc + ( D():FormasPago( nView ) )->cCtaBnc
                           oInstallment:oAccountToBeCredited:cBankCode     := ( D():FormasPago( nView ) )->cEntBnc
                           oInstallment:oAccountToBeCredited:cBranchCode   := ( D():FormasPago( nView ) )->cSucBnc

                           if !Empty( ( D():FormasPago( nView ) )->cBanco )

                              nOrdAnt     :=  ( D():EmpresaBancos( nView ) )->( OrdSetFocus( "cNomBnc" ) )
                            
                              if ( D():EmpresaBancos( nView ) )->( dbSeek( ( D():FormasPago( nView ) )->cBanco ) )

                                 oInstallment:oAccountToBeCredited:cAddress   := ( D():EmpresaBancos( nView ) )->cDirBnc
                                 oInstallment:oAccountToBeCredited:cPostCode  := ( D():EmpresaBancos( nView ) )->cCPBnc
                                 oInstallment:oAccountToBeCredited:cTown      := ( D():EmpresaBancos( nView ) )->cPobBnc
                                 oInstallment:oAccountToBeCredited:cProvince  := ( D():EmpresaBancos( nView ) )->cProBnc

                              end if

                           end if

                           oInstallment:oAccountToBeCredited:cCountryCode  := "ESP"

                        end if

                  end if

                  /*do case

                     case oInstallment:cPaymentMeans == "02"

                        if lBancoDefecto( ( D():FacturasClientes( nView ) )->cCodCli, dbfCliBnc )

                           oInstallment:oAccountToBeCredited               := Account()
                           oInstallment:oAccountToBeCredited:cIBAN         := ( dbfCliBnc )->cCtaBnc
                           oInstallment:oAccountToBeCredited:cBankCode     := Left( ( dbfCliBnc )->cCtaBnc, 4 )
                           oInstallment:oAccountToBeCredited:cBranchCode   := Substr( ( dbfCliBnc )->cCtaBnc, 4, 4 )
                           oInstallment:oAccountToBeCredited:cAddress      := ( dbfCliBnc )->cDirBnc
                           oInstallment:oAccountToBeCredited:cPostCode     := ( dbfCliBnc )->cCpBnc
                           oInstallment:oAccountToBeCredited:cTown         := ( dbfCliBnc )->cPobBnc
                           oInstallment:oAccountToBeCredited:cProvince     := ( dbfCliBnc )->cProBnc
                           oInstallment:oAccountToBeCredited:cCountryCode  := "ESP"

                        end if

                     case oInstallment:cPaymentMeans == "04"

                        if ( D():FormasPago( nView ) )->( dbSeek( ( D():FacturasClientesCobros( nView ) )->cCodPgo ) )
                           
                           oInstallment:oAccountToBeCredited               := Account()
                           oInstallment:oAccountToBeCredited:cIBAN         := ( D():FormasPago( nView ) )->cPaisIBAN + ( D():FormasPago( nView ) )->cCtrlIBAN + ( D():FormasPago( nView ) )->cEntBnc + ( D():FormasPago( nView ) )->cSucBnc + ( D():FormasPago( nView ) )->cDigBnc + ( D():FormasPago( nView ) )->cCtaBnc
                           oInstallment:oAccountToBeCredited:cBankCode     := ( D():FormasPago( nView ) )->cEntBnc
                           oInstallment:oAccountToBeCredited:cBranchCode   := ( D():FormasPago( nView ) )->cSucBnc

                           if !Empty( ( D():FormasPago( nView ) )->cBanco )

                              nOrdAnt     :=  ( D():EmpresaBancos( nView ) )->( OrdSetFocus( "cNomBnc" ) )
                            
                              if ( D():EmpresaBancos( nView ) )->( dbSeek( ( D():FormasPago( nView ) )->cBanco ) )

                                 oInstallment:oAccountToBeCredited:cAddress   := ( D():EmpresaBancos( nView ) )->cDirBnc
                                 oInstallment:oAccountToBeCredited:cPostCode  := ( D():EmpresaBancos( nView ) )->cCPBnc
                                 oInstallment:oAccountToBeCredited:cTown      := ( D():EmpresaBancos( nView ) )->cPobBnc
                                 oInstallment:oAccountToBeCredited:cProvince  := ( D():EmpresaBancos( nView ) )->cProBnc

                              end if

                           end if

                           oInstallment:oAccountToBeCredited:cCountryCode  := "ESP"

                        end if

                  end case*/

                  :addInstallment( oInstallment )

               else

                  oTree:Add( "Recibo : " + ( D():FacturasClientesCobros( nView ) )->cSerie + "/" + AllTrim( str( ( D():FacturasClientesCobros( nView ) )->nNumFac ) ) + "/" + ( D():FacturasClientesCobros( nView ) )->cSufFac + "-" + str( ( D():FacturasClientesCobros( nView ) )->nNumRec ) + " no tiene Código de facturae." )

               end if

            end if

            ( D():FacturasClientesCobros( nView ) )->( dbSkip() )

         end do

      end if

      // Entidades----------------------------------------------------------------

      if D():gotoIdFacturasClientesEntidades( nNumero, nView ) 

         while ( D():FacturasClientesEntidadesId( nView ) == nNumero .and. !D():eofFacturasClientesEntidades( nView ) )

            cCodigoEntidad                               := ( D():FacturasClientesEntidades( nView ) )->cCodEnt

            oAdministrativeCentres                       := AdministrativeCentres()
            oAdministrativeCentres:cCentreCode           := cCodigoEntidad
            oAdministrativeCentres:cRoleTypeCode         := getRolCode( ( D():FacturasClientesEntidades( nView ) )->cRol )
            oAdministrativeCentres:cAddress              := oEntidades:getDireccion( cCodigoEntidad )    
            oAdministrativeCentres:cPostCode             := oEntidades:getCodigoPostal( cCodigoEntidad )    
            oAdministrativeCentres:cTown                 := oEntidades:getPoblacion( cCodigoEntidad )    
            oAdministrativeCentres:cProvince             := oEntidades:getProvincia( cCodigoEntidad )    
            oAdministrativeCentres:cCountryCode          := oEntidades:getCodigoPais( cCodigoEntidad ) 
            oAdministrativeCentres:cCentreDescription    := oEntidades:getDescripcion( cCodigoEntidad )    

            :addAdministrativeCentres( oAdministrativeCentres )

            ( D():FacturasClientesEntidades( nView ) )->( dbSkip() )

         end while

      end if 

   end with

   // Genera la factura-----------------------------------------------------------

   oFactura:GeneraXml()

   if !oFactura:lError
      if dbLock( D():FacturasClientes( nView ) )
         ( D():FacturasClientes( nView ) )->lExpFac := .t.
         ( D():FacturasClientes( nView ) )->( dbUnLock() )
      end if
   end if

   // Firma la factura------------------------------------------------------------

   if lFirmar
      oFactura:FirmaJava()
   end if

   if lEnviar
      oFactura:Enviar()
   end if

   oFactura:ShowInWeb()

   hb_gcall( .f. )    

return nil

//---------------------------------------------------------------------------//

static function lValidLineForFacturae()

   RETURN ( .t. )

Return ( lValLine( D():FacturasClientesLineas( nView ) ) .and. !( D():FacturasClientesLineas( nView ) )->lTotLin .and. nTotNFacCli( D():FacturasClientesLineas( nView ) ) != 0 )

//---------------------------------------------------------------------------//

Static Function loadRecCli( aTmp, oBrwPgo )

   local nRec
   local cFac

   DisableAcceso()

   nRec           := ( dbfTmpPgo  )->( recno() )
   cFac           := aTmp[ _CSERIE ] + str( aTmp[ _NNUMFAC ] ) + aTmp[ _CSUFFAC ]

   ( dbfTmpPgo )->( __dbZap() )

   if ( D():FacturasClientesCobros( nView ) )->( dbSeek( cFac ) )

      while ( D():FacturasClientesCobros( nView ) )->cSerie + str( ( D():FacturasClientesCobros( nView ) )->nNumFac ) + ( D():FacturasClientesCobros( nView ) )->cSufFac == cFac .and. ( D():FacturasClientesCobros( nView ) )->( !eof() )

         if empty( ( D():FacturasClientesCobros( nView ) )->cTipRec )
            dbPass( D():FacturasClientesCobros( nView ), dbfTmpPgo, .t. )
         end if

         ( D():FacturasClientesCobros( nView ) )->( dbSkip() )

      end while

   end if

   ( dbfTmpPgo )->( dbgoto( nRec ) )

   if !empty( oBrwPgo )
      oBrwPgo:Refresh()
   end if

   EnableAcceso()

RETURN nil

//---------------------------------------------------------------------------//

Static Function EndPgo( aTmp, aGet, lPgdOld, nImpOld, dbfTmpPgo, oBrw, oDlg, nMode )

   local nImp
   local nCon
   local nRec        := ( dbfTmpPgo )->( Recno() )
   local lImpNeg     := ( dbfTmpPgo )->nImporte < 0
   local nImpTmp     := abs( aTmp[ ( dbfTmpPgo )->( FieldPos( "nImporte" ) ) ] )
   local nImpFld     := abs( ( dbfTmpPgo )->nImporte )

   if !aGet[ ( dbfTmpPgo )->( FieldPos( "nImpCob" ) ) ]:lValid()
      return .f.
   end if

   /*
   El importe no puede ser mayor q el importe anterior-------------------------

   if nImpTmp > nImpFld
      msgStop( "El importe no puede ser superior al actual." )
      return nil
   end if
   */

   oDlg:Disable()

   /*
   Comprobamos q los importes sean distintos-----------------------------------
   */

   if nImpFld != nImpTmp

      /*
      El importe ha cambiado por tanto debemos de hacer un nuevo recibo por la diferencia
      */

      nImp                       := ( nImpFld - nImpTmp ) * if( lImpNeg, - 1 , 1 )

      /*
      A-adimos el nuevo recibo-------------------------------------------------
      */

      ( dbfTmpPgo )->( dbAppend() )
      nCon                       := ( dbfTmpPgo )->( LastRec() )
      ( dbfTmpPgo )->cSerie      := aTmp[ ( dbfTmpPgo )->( FieldPos( "CSERIE"  ) ) ]
      ( dbfTmpPgo )->nNumFac     := aTmp[ ( dbfTmpPgo )->( FieldPos( "NNUMFAC" ) ) ]
      ( dbfTmpPgo )->cSufFac     := aTmp[ ( dbfTmpPgo )->( FieldPos( "CSUFFAC" ) ) ]
      ( dbfTmpPgo )->nNumRec     := nCon
      ( dbfTmpPgo )->cCodCaj     := aTmp[ ( dbfTmpPgo )->( FieldPos( "CCODCAJ" ) ) ]
      ( dbfTmpPgo )->cCodCli     := aTmp[ ( dbfTmpPgo )->( FieldPos( "CCODCLI" ) ) ]
      ( dbfTmpPgo )->dEntrada    := Ctod( "" )
      ( dbfTmpPgo )->nImporte    := nImp
      ( dbfTmpPgo )->nImpGas     := 0
      ( dbfTmpPgo )->cDescrip    := "Recibo n." + AllTrim( str( nCon ) ) + " de factura " + aTmp[ ( dbfTmpPgo )->( FieldPos( "CSERIE" ) ) ] + '/' + AllTrim( str( aTmp[ ( dbfTmpPgo )->( FieldPos( "NNUMFAC" ) ) ] ) ) + '/' + aTmp[ ( dbfTmpPgo )->( FieldPos( "CSUFFAC" ) ) ]
      ( dbfTmpPgo )->dPreCob     := dFecFacCli( aTmp[ ( dbfTmpPgo )->( FieldPos( "CSERIE" ) ) ] + str( aTmp[ ( dbfTmpPgo )->( FieldPos( "NNUMFAC" ) ) ] ) + aTmp[ ( dbfTmpPgo )->( FieldPos( "CSUFFAC" ) ) ], D():FacturasClientes( nView ) )
      ( dbfTmpPgo )->dFecVto     := dFecFacCli( aTmp[ ( dbfTmpPgo )->( FieldPos( "CSERIE" ) ) ] + str( aTmp[ ( dbfTmpPgo )->( FieldPos( "NNUMFAC" ) ) ] ) + aTmp[ ( dbfTmpPgo )->( FieldPos( "CSUFFAC" ) ) ], D():FacturasClientes( nView ) )
      ( dbfTmpPgo )->cPgdoPor    := ""
      ( dbfTmpPgo )->lCobrado    := .f.
      ( dbfTmpPgo )->cDivPgo     := aTmp[ ( dbfTmpPgo )->( FieldPos( "CDIVPGO" ) ) ]
      ( dbfTmpPgo )->nVdvPgo     := aTmp[ ( dbfTmpPgo )->( FieldPos( "NVDVPGO" ) ) ]
      ( dbfTmpPgo )->lConPgo     := .f.
      ( dbfTmpPgo )->cTurRec     := cCurSesion()
      ( dbfTmpPgo )->( dbUnLock() )

   end if

   ( dbfTmpPgo )->( dbGoTo( nRec ) )

   /*
   Grabamos el recibo
   */

   WinGather( aTmp, aGet, dbfTmpPgo, oBrw, nMode )

   /*
   Escribe los datos pendientes------------------------------------------------
   */

   dbCommitAll()

   oDlg:Enable()

   oDlg:End( IDOK )

return .t.

//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//

CLASS sTotal FROM HBPersistent

   DATA nTotalNeto                     INIT 0

   DATA aTotalBase                     INIT { 0, 0, 0 }

   DATA nTotalBruto                    INIT 0
   DATA aTotalBruto                    INIT { 0, 0, 0 }

   DATA nTotalDocumento                INIT 0

   DATA nTotalPuntoVerde               INIT 0
   DATA nTotalTransporte               INIT 0
   DATA nTotalAgente                   INIT 0

   DATA nTotalIva                      INIT 0
   DATA aTotalIva                                                    PERSISTENT 

   DATA aPorcentajeIva                 INIT { nil, nil, nil }

   DATA nTotalRecargoEquivalencia      INIT 0

   DATA nTotalImpuestoHidrocarburos    INIT 0
   DATA aTotalImpuestoHidrocarburos    INIT { 0, 0, 0 }

   DATA nTotalRetencion                INIT 0

   DATA nTotalCosto                    INIT 0
   DATA nTotalRentabilidad             INIT 0

   DATA nTotalDescuentoGeneral         INIT 0
   DATA nTotalDescuentoProntoPago      INIT 0
   DATA nTotalDescuentoUno             INIT 0
   DATA nTotalDescuentoDos             INIT 0

   DATA nTotalSuplidos                 INIT 0

   DATA nTotalCobrado                  INIT 0

   DATA nPromocion                     INIT 0

   DATA nTotalPersona                  INIT 0

   DATA nDecimalesRedondeo             INIT 2

   DATA nCobrado                       INIT 0
   DATA nCambio                        INIT 0

   DATA aBrtTik                        INIT { 0, 0, 0 }
   DATA aBasTik                        INIT { 0, 0, 0 }
   DATA aIvmTik                        INIT { 0, 0, 0 }
   DATA aIvaTik                        INIT { 0, 0, 0 }

   METHOD nTotalPrimerBruto()                   INLINE ( ::aTotalBruto[ 1 ] )
   METHOD nTotalSegundoBruto()                  INLINE ( ::aTotalBruto[ 2 ] )
   METHOD nTotalTercerBruto()                   INLINE ( ::aTotalBruto[ 3 ] )

   METHOD TotalBruto()                          INLINE ( ::aTotalBruto[ 1 ] + ::aTotalBruto[ 2 ] + ::aTotalBruto[ 3 ] )

   METHOD nTotalPrimeraBase()                   INLINE ( ::aTotalBase[ 1 ] )
   METHOD nTotalSegundaBase()                   INLINE ( ::aTotalBase[ 2 ] )
   METHOD nTotalTerceraBase()                   INLINE ( ::aTotalBase[ 3 ] )

   METHOD TotalBase()                           INLINE ( ::aTotalBase[ 1 ] + ::aTotalBase[ 2 ] + ::aTotalBase[ 3 ] )

   METHOD nBasePrimerIva()                      INLINE ( ::aTotalIva[ 1, 2 ] )
   METHOD nBaseSegundoIva()                     INLINE ( ::aTotalIva[ 2, 2 ] )
   METHOD nBaseTercerIva()                      INLINE ( ::aTotalIva[ 3, 2 ] )

   METHOD nPorcentajePrimerIva()                INLINE ( ::aPorcentajeIva[1] )
   METHOD nPorcentajeSegundoIva()               INLINE ( ::aPorcentajeIva[2] )
   METHOD nPorcentajeTercerIva()                INLINE ( ::aPorcentajeIva[3] )

   METHOD nTotalPrimerIva()                     INLINE ( if( empty( ::aTotalIva ), ::aIvaTik[1], ::aTotalIva[ 1, 8 ] ) )
   METHOD nTotalSegundoIva()                    INLINE ( if( empty( ::aTotalIva ), ::aIvaTik[2], ::aTotalIva[ 2, 8 ] ) )
   METHOD nTotalTercerIva()                     INLINE ( if( empty( ::aTotalIva ), ::aIvaTik[3], ::aTotalIva[ 3, 8 ] ) )

   METHOD TotalIva()                            INLINE ( ::nTotalPrimerIva() + ::nTotalSegundoIva() + ::nTotalTercerIva() )

   METHOD nTotalPrimerImpuestoHidrocarburos()   INLINE ( ::aTotalImpuestoHidrocarburos[ 1 ] )
   METHOD nTotalSegundoImpuestoHidrocarburos()  INLINE ( ::aTotalImpuestoHidrocarburos[ 2 ] )
   METHOD nTotalTercerImpuestoHidrocarburos()   INLINE ( ::aTotalImpuestoHidrocarburos[ 3 ] )

   METHOD TotalImpuestoHidrocarburos()          INLINE ( ::aTotalImpuestoHidrocarburos[ 1 ] + ::aTotalImpuestoHidrocarburos[ 2 ] + ::aTotalImpuestoHidrocarburos[ 3 ] )

   METHOD TotalDescuento()                      INLINE ( ::nTotalDescuentoGeneral + ::nTotalDescuentoProntoPago + ::nTotalDescuentoUno + ::nTotalDescuentoDos )

   METHOD TotalDocumento()                      INLINE ( Round( ::nTotalDocumento, ::nDecimalesRedondeo ) )

   METHOD TotalRentabilidad()                   INLINE ( Round( ::aTotalBase - ::nTotalCosto, ::nDecimalesRedondeo ) )
   METHOD PorcentajeRentabilidad()              INLINE ( nRentabilidad( ::aTotalBase, 0, ::nTotalCosto ) )

   METHOD nTotalCobro()                         INLINE ( Round( ::nCobrado - ::nCambio, ::nDecimalesRedondeo ) )

ENDCLASS

//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//

Static Function FacCliExcelImport()

   local n
   local sBancasImportacion
   local cCodigoCliente
   local nVentaBruta
   local nComision
   local nVentaNeta
   local nBeneficio
   local oOleExcel
   local cFileExcel                    := cGetFile( "Excel ( *.Xls ) | *.xls |Excel ( *.Xlsx ) | *.xlsx", "Seleccione la hoja de calculo" )

   if File( cFileExcel )

      oOleExcel                        := TOleExcel():New( "Importando hoja de excel", "Conectando...", .f. )

      oOleExcel:oExcel:Visible         := .t.
      oOleExcel:oExcel:DisplayAlerts   := .f.
      oOleExcel:oExcel:WorkBooks:Open( cFileExcel )
      oOleExcel:oExcel:WorkSheets( 1 ):Activate()

      for n := 1 to 65536

         sBancasImportacion                     := sBancasImportacion()

         sBancasImportacion:cCodigoCliente      := oOleExcel:oExcel:ActiveSheet:Range( "A" + lTrim( str( n ) ) ):Value
         if !empty( sBancasImportacion:cCodigoCliente )

            sBancasImportacion:cCodigoCliente   := Left( sBancasImportacion:cCodigoCliente, 3 )
            sBancasImportacion:cCodigoCliente   := Rjust( sBancasImportacion:cCodigoCliente, "0", RetNumCodCliEmp() )

            sBancasImportacion:nVentaBruta      := oOleExcel:oExcel:ActiveSheet:Range( "D" + lTrim( str( n ) ) ):Value
            sBancasImportacion:nComision        := oOleExcel:oExcel:ActiveSheet:Range( "E" + lTrim( str( n ) ) ):Value
            sBancasImportacion:nVentaNeta       := oOleExcel:oExcel:ActiveSheet:Range( "F" + lTrim( str( n ) ) ):Value
            sBancasImportacion:nBeneficio       := oOleExcel:oExcel:ActiveSheet:Range( "L" + lTrim( str( n ) ) ):Value
            sBancasImportacion:nPremios         := oOleExcel:oExcel:ActiveSheet:Range( "K" + lTrim( str( n ) ) ):Value
            sBancasImportacion:nPorcentaje      := Round( sBancasImportacion:nComision / sBancasImportacion:nVentaBruta * 100, 0 )

            WinAppRec( oWndBrw:oBrw, bEdtRec, D():FacturasClientes( nView ), , , sBancasImportacion )

         else

            exit

         end if

      next

      msgStop( "Proceso de importación finalizazo." )

      oOleExcel:oExcel:Quit()

      oOleExcel:oExcel:DisplayAlerts := .t.

      oOleExcel:End()

   end if

Return nil

//---------------------------------------------------------------------------//

static function AddFichero( aFichero, oBrwFichero )

   local i
   local cFile
   local aFile
   local nFlag    := nOr( OFN_PATHMUSTEXIST, OFN_NOCHANGEDIR, OFN_ALLOWMULTISELECT, OFN_EXPLORER, OFN_LONGNAMES )

   cFile          := cGetFile( "Excel ( *.Xlsx ) | *.xlsx|Excel ( *.Xls ) | *.xls", "Seleccione la hoja de calculo", "*.*" , , .f., .t., nFlag )
   cFile          := Left( cFile, At( Chr( 0 ) + Chr( 0 ), cFile ) - 1 )

   if !empty( cFile ) //.or. Valtype( cFile ) == "N"

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
            aAdd( aFichero, aFile[ i ] ) // if( Substr( aFile[ i ], 4, 1 ) == "\", aFileDisc( aFile[i] ) + "\" + aFileName( aFile[ i ] ), aFile[ i ] ) )
         next

      else

         aAdd( aFichero, aFile )

      endif

   end if

   oBrwFichero:Refresh()

return nil

//---------------------------------------------------------------------------//

Static Function DelFichero( aFichero, oBrwFichero )

   aDel( aFichero, oBrwFichero:nArrayAt, .t. )

   oBrwFichero:Refresh()

return nil

//---------------------------------------------------------------------------//

CLASS sBancasImportacion

   DATA nVentaBruta                    INIT 0
   DATA nComision                      INIT 0
   DATA nVentaNeta                     INIT 0
   DATA nBeneficio                     INIT 0
   DATA nPorcentaje                    INIT 0
   DATA nPremios                       INIT 0

ENDCLASS

//---------------------------------------------------------------------------//

CLASS sNovotecnoImportacion

   DATA cCodigoCliente
   DATA dFecha
   DATA cHora
   DATA cCodigoArticulo
   DATA cNombreArticulo
   DATA nNumeroOperacion

   DATA nImporteClaro                  INIT 0
   DATA nImporteOrange                 INIT 0
   DATA nImporteViva                   INIT 0
   DATA nImporteMount                  INIT 0
   DATA nImporteTricom                 INIT 0
   DATA nImporteLoterias               INIT 0

   DATA cTipo
   DATA lValid                         INIT .t.
   DATA nPrecio                        INIT 0

ENDCLASS

//---------------------------------------------------------------------------//

Static Function ExecuteImportacion( aFichero, oTreeImportacion, oMeterImportacion, oBtnCancel, oDlg )

   local n
   local oNode
   local oError
   local oBlock
   local oError2
   local oBlock2
   local cFichero
   local oOleExcel
   local oActiveSheet
   local nActiveSheetRows
   local nActiveSheetColumns
   local sNovotecnoImportacion

   oDlg:Disable()
   oBtnCancel:Enable()

   aImportacion                           := {}
   lCancelImportacion                     := .f.

   for each cFichero in aFichero

      oBlock                              := ErrorBlock( { | oError | ApoloBreak( oError ) } )
      BEGIN SEQUENCE

         oTreeImportacion:Select( oTreeImportacion:Add( "Importando hoja de excel " + cFichero ) )

         oOleExcel                        := TOleExcel():New( "Importando hoja de excel", "Conectando...", .f. )

         oOleExcel:oExcel:Visible         := .f.
         oOleExcel:oExcel:DisplayAlerts   := .f.

         oOleExcel:oExcel:Workbooks:Add()
         oOleExcel:oExcel:Workbooks:Open( cFichero )

         oActiveSheet                     := oOleExcel:oExcel:ActiveSheet

         nActiveSheetRows                 := oActiveSheet:UsedRange:Rows:Count()
         nActiveSheetColumns              := oActiveSheet:UsedRange:Columns:Count()

         oMeterImportacion:SetTotal( nActiveSheetRows )

         for n := 2 to ( nActiveSheetRows - 1 )

            oBlock2                                         := ErrorBlock( { | oError2 | Break( oError2 ) } )
            BEGIN SEQUENCE

            if !lCancelImportacion

               sNovotecnoImportacion                        := sNovotecnoImportacion()

               // sNovotecnoImportacion:nNumeroOperacion       := Round( oOleExcel:oExcel:ActiveSheet:Range( "A" + lTrim( str( n ) ) ):Value, 0 )

               oNode                                        := oTreeImportacion:Add( "Procesando operación " + lTrim( str( n ) ) )
               oTreeImportacion:Select( oNode )

               sNovotecnoImportacion:cCodigoCliente         := oOleExcel:oExcel:ActiveSheet:Range( "A" + lTrim( str( n ) ) ):Value

               if !empty( sNovotecnoImportacion:cCodigoCliente )

                  if IsNum( sNovotecnoImportacion:cCodigoCliente )
                     sNovotecnoImportacion:cCodigoCliente   := Round( sNovotecnoImportacion:cCodigoCliente, 0 )
                     sNovotecnoImportacion:cCodigoCliente   := str( sNovotecnoImportacion:cCodigoCliente )
                     sNovotecnoImportacion:cCodigoCliente   := Alltrim( sNovotecnoImportacion:cCodigoCliente )
                  end if

                  if dbSeekInOrd( sNovotecnoImportacion:cCodigoCliente, "cCodPos", dbfObrasT )
                     sNovotecnoImportacion:cCodigoCliente   := ( dbfObrasT )->cCodCli
                  else
                     sNovotecnoImportacion:cCodigoCliente   := Rjust( sNovotecnoImportacion:cCodigoCliente, "0", RetNumCodCliEmp() )
                  end if

                  sNovotecnoImportacion:dFecha              := Date()
                  sNovotecnoImportacion:cHora               := Time()

                  sNovotecnoImportacion:nImporteClaro       := oOleExcel:oExcel:ActiveSheet:Range( "B" + lTrim( str( n ) ) ):Value
                  sNovotecnoImportacion:nImporteOrange      := oOleExcel:oExcel:ActiveSheet:Range( "C" + lTrim( str( n ) ) ):Value
                  sNovotecnoImportacion:nImporteViva        := oOleExcel:oExcel:ActiveSheet:Range( "D" + lTrim( str( n ) ) ):Value
                  sNovotecnoImportacion:nImporteMount       := oOleExcel:oExcel:ActiveSheet:Range( "E" + lTrim( str( n ) ) ):Value
                  sNovotecnoImportacion:nImporteTricom      := oOleExcel:oExcel:ActiveSheet:Range( "F" + lTrim( str( n ) ) ):Value
                  sNovotecnoImportacion:nImporteLoterias    := oOleExcel:oExcel:ActiveSheet:Range( "G" + lTrim( str( n ) ) ):Value

                  sNovotecnoImportacion:lValid              := .t.

                  oTreeImportacion:Select( oNode:Add( "Cliente " + sNovotecnoImportacion:cCodigoCliente ) )
                  oTreeImportacion:Select( oNode:Add( "Fecha " + Dtoc( sNovotecnoImportacion:dFecha ) ) )
                  oTreeImportacion:Select( oNode:Add( "Hora " + sNovotecnoImportacion:cHora ) )
                  oTreeImportacion:Select( oNode:Add( "Precio Claro " + Alltrim( cValToChar( sNovotecnoImportacion:nImporteClaro ) ) ) )

                  if sNovotecnoImportacion:lValid
                     aAdd( aImportacion, sNovotecnoImportacion )
                  end if

               end if

            end if

            RECOVER USING oError2

               msgStop( ErrorMessage( oError2 ), "Error al importar facturas" )

            END SEQUENCE

            ErrorBlock( oBlock2 )

            oMeterImportacion:Set( n )

         next

         oOleExcel:oExcel:Quit()
         oOleExcel:oExcel:DisplayAlerts   := .t.

      RECOVER USING oError

         msgStop( ErrorMessage( oError ), "Error al importar facturas" )

      END SEQUENCE

      ErrorBlock( oBlock )

      if !empty( oOleExcel )
         oOleExcel:End()
      end if

      if lCancelImportacion
         oTreeImportacion:Select( oTreeImportacion:Add( "Proceso cancelado por el usuario" ) )
      end if

   next

   if !lCancelImportacion .and. !empty( aImportacion )
      FacturaImportacion( oTreeImportacion )
   end if

   oDlg:Enable()

return nil

//---------------------------------------------------------------------------//

static function FacturaImportacion( oTreeImportacion )

   local s
   local aTotalFactura
   local cCodigoCambio
   local cSerieFactura
   local nNumeroFactura
   local cSufijoFactura
   local nNumeroLinea                  := 1
   local lAppendFactura                := .f.

   aSort( aImportacion, , , {|x,y| x:cCodigoCliente > y:cCodigoCliente } )

   for each s in aImportacion

      /*
      Inicializamos las variables----------------------------------------------
      */

      nNumeroLinea                     := 1
      lAppendFactura                   := .f.

      /*
      Vamos a comprobar q el cliente exista------------------------------------
      */

      if dbSeekInOrd( s:cCodigoCliente, "Cod", D():Clientes( nView ) )

         cSerieFactura                 := if( !empty( ( D():Clientes( nView ) )->Serie ), ( D():Clientes( nView ) )->Serie, "A" )
         nNumeroFactura                := nNewDoc( cSerieFactura, D():FacturasClientes( nView ), "nFacCli", , D():Contadores( nView ) )
         cSufijoFactura                := RetSufEmp()

         ( D():FacturasClientes( nView ) )->( dbAppend() )
         if !( D():FacturasClientes( nView ) )->( NetErr() )

            ( D():FacturasClientes( nView ) )->cSerie     := cSerieFactura
            ( D():FacturasClientes( nView ) )->nNumFac    := nNumeroFactura
            ( D():FacturasClientes( nView ) )->cSufFac    := cSufijoFactura

            ( D():FacturasClientes( nView ) )->cCodCli    := ( D():Clientes( nView ) )->Cod
            ( D():FacturasClientes( nView ) )->cNomCli    := ( D():Clientes( nView ) )->Titulo
            ( D():FacturasClientes( nView ) )->cDirCli    := ( D():Clientes( nView ) )->Domicilio
            ( D():FacturasClientes( nView ) )->cPobCli    := ( D():Clientes( nView ) )->Poblacion
            ( D():FacturasClientes( nView ) )->cPrvCli    := ( D():Clientes( nView ) )->Provincia
            ( D():FacturasClientes( nView ) )->cPosCli    := ( D():Clientes( nView ) )->CodPostal
            ( D():FacturasClientes( nView ) )->cDniCli    := ( D():Clientes( nView ) )->Nif

            ( D():FacturasClientes( nView ) )->cCodPago   := if( !empty( ( D():Clientes( nView ) )->CodPago ), ( D():Clientes( nView ) )->CodPago, cDefFpg() )
            ( D():FacturasClientes( nView ) )->nTarifa    := Max( ( D():Clientes( nView ) )->nTarifa, 1 )
            ( D():FacturasClientes( nView ) )->dFecFac    := s:dFecha
            ( D():FacturasClientes( nView ) )->cTurFac    := cCurSesion()
            ( D():FacturasClientes( nView ) )->cCodAlm    := oUser():cAlmacen()
            ( D():FacturasClientes( nView ) )->cCodUsr    := cCurUsr()
            ( D():FacturasClientes( nView ) )->dFecCre    := Date()
            ( D():FacturasClientes( nView ) )->cTimCre    := Time()
            ( D():FacturasClientes( nView ) )->cCodDlg    := RetFld( cCurUsr(), dbfUsr, "cCodDlg" )
            ( D():FacturasClientes( nView ) )->cCodCaj    := oUser():cCaja()

            lAppendFactura             := .t.

            oTreeImportacion:Select( oTreeImportacion:Add( "Nueva factura creada " + ( D():FacturasClientes( nView ) )->cSerie + "/" + Alltrim( str( ( D():FacturasClientes( nView ) )->nNumFac ) ) + "/" + Alltrim( ( D():FacturasClientes( nView ) )->cSufFac ) ) )

         end if

      else

         oTreeImportacion:Add( "Cliente no encontrado " + s:cCodigoCliente )

      end if

      if lAppendFactura

         if s:nImporteClaro != 0

            ( D():FacturasClientesLineas( nView ) )->( dbAppend() )
            if !( D():FacturasClientesLineas( nView ) )->( NetErr() )

               ( D():FacturasClientesLineas( nView ) )->nNumLin    := nNumeroLinea++
               ( D():FacturasClientesLineas( nView ) )->cSerie     := cSerieFactura
               ( D():FacturasClientesLineas( nView ) )->nNumFac    := nNumeroFactura
               ( D():FacturasClientesLineas( nView ) )->cSufFac    := cSufijoFactura
               ( D():FacturasClientesLineas( nView ) )->cRef       := "CLARO"
               ( D():FacturasClientesLineas( nView ) )->cDetalle   := "CLARO"
               ( D():FacturasClientesLineas( nView ) )->nUniCaja   := 1
               ( D():FacturasClientesLineas( nView ) )->nPreUnit   := s:nImporteClaro
               ( D():FacturasClientesLineas( nView ) )->cAlmLin    := oUser():cAlmacen()

            end if

         end if

         if s:nImporteOrange != 0

            ( D():FacturasClientesLineas( nView ) )->( dbAppend() )
            if !( D():FacturasClientesLineas( nView ) )->( NetErr() )

               ( D():FacturasClientesLineas( nView ) )->nNumLin    := nNumeroLinea++
               ( D():FacturasClientesLineas( nView ) )->cSerie     := cSerieFactura
               ( D():FacturasClientesLineas( nView ) )->nNumFac    := nNumeroFactura
               ( D():FacturasClientesLineas( nView ) )->cSufFac    := cSufijoFactura
               ( D():FacturasClientesLineas( nView ) )->cRef       := "ORANGE"
               ( D():FacturasClientesLineas( nView ) )->cDetalle   := "ORANGE"
               ( D():FacturasClientesLineas( nView ) )->nUniCaja   := 1
               ( D():FacturasClientesLineas( nView ) )->nPreUnit   := s:nImporteOrange
               ( D():FacturasClientesLineas( nView ) )->cAlmLin    := oUser():cAlmacen()

            end if

         end if

         if s:nImporteViva != 0

            ( D():FacturasClientesLineas( nView ) )->( dbAppend() )
            if !( D():FacturasClientesLineas( nView ) )->( NetErr() )

               ( D():FacturasClientesLineas( nView ) )->nNumLin    := nNumeroLinea++
               ( D():FacturasClientesLineas( nView ) )->cSerie     := cSerieFactura
               ( D():FacturasClientesLineas( nView ) )->nNumFac    := nNumeroFactura
               ( D():FacturasClientesLineas( nView ) )->cSufFac    := cSufijoFactura
               ( D():FacturasClientesLineas( nView ) )->cRef       := "VIVA"
               ( D():FacturasClientesLineas( nView ) )->cDetalle   := "VIVA"
               ( D():FacturasClientesLineas( nView ) )->nUniCaja   := 1
               ( D():FacturasClientesLineas( nView ) )->nPreUnit   := s:nImporteViva
               ( D():FacturasClientesLineas( nView ) )->cAlmLin    := oUser():cAlmacen()

            end if

         end if

         if s:nImporteTricom != 0

            ( D():FacturasClientesLineas( nView ) )->( dbAppend() )
            if !( D():FacturasClientesLineas( nView ) )->( NetErr() )

               ( D():FacturasClientesLineas( nView ) )->nNumLin    := nNumeroLinea++
               ( D():FacturasClientesLineas( nView ) )->cSerie     := cSerieFactura
               ( D():FacturasClientesLineas( nView ) )->nNumFac    := nNumeroFactura
               ( D():FacturasClientesLineas( nView ) )->cSufFac    := cSufijoFactura
               ( D():FacturasClientesLineas( nView ) )->cRef       := "TRICOM"
               ( D():FacturasClientesLineas( nView ) )->cDetalle   := "TRICOM"
               ( D():FacturasClientesLineas( nView ) )->nUniCaja   := 1
               ( D():FacturasClientesLineas( nView ) )->nPreUnit   := s:nImporteTricom
               ( D():FacturasClientesLineas( nView ) )->cAlmLin    := oUser():cAlmacen()

            end if

         end if

         if s:nImporteLoterias != 0

            ( D():FacturasClientesLineas( nView ) )->( dbAppend() )
            if !( D():FacturasClientesLineas( nView ) )->( NetErr() )

               ( D():FacturasClientesLineas( nView ) )->nNumLin    := nNumeroLinea++
               ( D():FacturasClientesLineas( nView ) )->cSerie     := cSerieFactura
               ( D():FacturasClientesLineas( nView ) )->nNumFac    := nNumeroFactura
               ( D():FacturasClientesLineas( nView ) )->cSufFac    := cSufijoFactura
               ( D():FacturasClientesLineas( nView ) )->cRef       := "LOTERIAS"
               ( D():FacturasClientesLineas( nView ) )->cDetalle   := "LOTERIAS"
               ( D():FacturasClientesLineas( nView ) )->nUniCaja   := 1
               ( D():FacturasClientesLineas( nView ) )->nPreUnit   := s:nImporteLoterias
               ( D():FacturasClientesLineas( nView ) )->cAlmLin    := oUser():cAlmacen()

            end if

         end if

      end if

      if lAppendFactura .and. !empty( cSerieFactura ) .and. !empty( nNumeroFactura )
         GeneraCobrosImportacion( cSerieFactura, nNumeroFactura, cSufijoFactura )
      end if

   next

   oTreeImportacion:Select( oTreeImportacion:Add( "Proceso de importación finalizado" ) )

return nil

//---------------------------------------------------------------------------//

static function GeneraCobrosImportacion( cSerieFactura, nNumeroFactura, cSufijoFactura )

   local aTotalFactura

   /*
   Generamos los pagos------------------------------------------------
   */

   GenPgoFacCli( cSerieFactura + str( nNumeroFactura ) + cSufijoFactura, D():FacturasClientes( nView ), D():FacturasClientesLineas( nView ), D():FacturasClientesCobros( nView ), D():AnticiposClientes( nView ), D():Clientes( nView ), D():FormasPago( nView ), dbfDiv, dbfIva )

   ChkLqdFacCli( , D():FacturasClientes( nView ), D():FacturasClientesLineas( nView ), D():FacturasClientesCobros( nView ), D():AnticiposClientes( nView ), dbfIva, dbfDiv, .f. )

   /*
   Guardamos los totales----------------------------------------------
   */

   aTotalFactura                 := aTotFacCli( cSerieFactura + str( nNumeroFactura ) + cSufijoFactura, D():FacturasClientes( nView ), D():FacturasClientesLineas( nView ), dbfIva, dbfDiv, D():FacturasClientesCobros( nView ), D():AnticiposClientes( nView ), ( D():FacturasClientes( nView ) )->cDivFac )

   if dbLock( D():FacturasClientes( nView ) )

      ( D():FacturasClientes( nView ) )->nTotNet    := aTotalFactura[ 1 ]
      ( D():FacturasClientes( nView ) )->nTotIva    := aTotalFactura[ 2 ]
      ( D():FacturasClientes( nView ) )->nTotReq    := aTotalFactura[ 3 ]
      ( D():FacturasClientes( nView ) )->nTotFac    := aTotalFactura[ 4 ]

      ( D():FacturasClientes( nView ) )->( dbUnLock() )

   end if

return nil

//---------------------------------------------------------------------------//

static function lBuscaOferta( cCodArt, aGet, aTmp, aTmpFac, dbfOferta, dbfDiv, dbfKit, dbfIva  )

   local sOfeArt
   local nTotalLinea    := 0


   if ( D():Articulos( nView ) )->Codigo == cCodArt .or. ( D():Articulos( nView ) )->( dbSeek( cCodArt ) )

      /*
      Buscamos si existen ofertas por artículo----------------------------
      */

      nTotalLinea       := lCalcDeta( aTmp, aTmpFac, .t. )

      sOfeArt           := sOfertaArticulo( cCodArt, aTmpFac[ _CCODCLI ], aTmpFac[ _CCODGRP ], aTmp[ _NUNICAJA ], aTmpFac[ _DFECFAC ], dbfOferta, aTmp[ _NTARLIN ], aTmpFac[ _LIVAINC ], aTmp[_CCODPR1], aTmp[_CCODPR2], aTmp[_CVALPR1], aTmp[_CVALPR2], aTmp[ _CDIVFAC ], aTmp[ _NCANENT ], nTotalLinea )

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

      if !aTmp[ _LLINOFE ]

         /*
         Buscamos si existen ofertas por familia----------------------------
         */

         sOfeArt        := sOfertaFamilia( ( D():Articulos( nView ) )->Familia, aTmpFac[ _CCODCLI ], aTmpFac[ _CCODGRP ], aTmpFac[ _DFECFAC ], dbfOferta, aTmp[ _NTARLIN ], D():Articulos( nView ), aTmp[ _NUNICAJA ], aTmp[ _NCANENT ], nTotalLinea )

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

      if !aTmp[ _LLINOFE ]

         /*
         Buscamos si existen ofertas por tipos de articulos--------------
         */

         sOfeArt     := sOfertaTipoArticulo( ( D():Articulos( nView ) )->cCodTip, aTmpFac[ _CCODCLI ], aTmpFac[ _CCODGRP ], aTmpFac[ _DFECFAC ], dbfOferta, aTmp[ _NTARLIN ], D():Articulos( nView ), aTmp[ _NUNICAJA ], aTmp[ _NCANENT ], nTotalLinea )

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

      if !aTmp[ _LLINOFE ]

         /*
         Buscamos si existen ofertas por tipos de articulos--------------
         */

         sOfeArt     := sOfertaCategoria( ( D():Articulos( nView ) )->cCodCate, aTmpFac[ _CCODCLI ], aTmpFac[ _CCODGRP ], aTmpFac[ _DFECFAC ], dbfOferta, aTmp[ _NTARLIN ], D():Articulos( nView ), aTmp[ _NUNICAJA ], aTmp[ _NCANENT ], nTotalLinea )

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

      if !aTmp[ _LLINOFE ]

         /*
         Buscamos si existen ofertas por temporadas----------------------
         */

         sOfeArt     := sOfertaTemporada( ( D():Articulos( nView ) )->cCodTemp, aTmpFac[ _CCODCLI ], aTmpFac[ _CCODGRP ], aTmp[ _DFECFAC ], dbfOferta, aTmp[ _NTARLIN ], D():Articulos( nView ), aTmp[ _NUNICAJA ], aTmp[ _NCANENT ], nTotalLinea )

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

      if !aTmp[ _LLINOFE ]

         /*
         Buscamos si existen ofertas por fabricantes---------------------------
         */

         sOfeArt     := sOfertaFabricante( ( D():Articulos( nView ) )->cCodFab, aTmpFac[ _CCODCLI ], aTmpFac[ _CCODGRP ], aTmpFac[ _DFECFAC ], dbfOferta, aTmp[ _NTARLIN ], D():Articulos( nView ), aTmp[ _NUNICAJA ], aTmp[ _NCANENT ], nTotalLinea )

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

   local oNumerosSeries

   with object ( TNumerosSerie() )

      :nMode            := nMode

      :cCodArt          := aTmp[ _CREF    ]
      :cCodAlm          := aTmp[ _CALMLIN ]
      :nNumLin          := aTmp[ _NNUMLIN ]

      :nTotalUnidades   := nTotNFacCli( aTmp )

      :oStock           := oStock

      :uTmpSer          := dbfTmpSer

      :Resource()

   end with

Return ( nil )

//--------------------------------------------------------------------------//

//---------------------------------------------------------------------------//
//
// Importa satsupuestos de clientes
//

STATIC FUNCTION cSatCli( aGet, aTmp, oBrw, nMode )

   local cDesAlb
   local cNumSat  := aGet[ _CNUMSAT ]:VarGet()
   local lValid   := .f.

   if nMode != APPD_MODE .OR. empty( cNumsat )
      return .t.
   end if

   if dbSeekInOrd( cNumSat, "nNumSat", dbfSatCliT )

      if ( dbfSatCliT )->lEstado

         MsgStop( "S.A.T. ya procesado" )
         lValid   := .f.

      else

         CursorWait()

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

         if !empty(oGetTarifa)
            oGetTarifa:setTarifa( ( dbfSatCliT )->nTarifa )
         else
            aTmp[ _NTARIFA ]  := ( dbfSatCliT )->nTarifa
         end if

         aGet[ _CCODTRN ]:cText( ( dbfSatCliT )->cCodTrn )
         aGet[ _CCODTRN ]:lValid() 

         aGet[ _LIVAINC ]:Click( ( dbfSatCliT )->lIvaInc )
         aGet[ _LRECARGO]:Click( ( dbfSatCliT )->lRecargo )
         aGet[ _LOPERPV ]:Click( ( dbfSatCliT )->lOperPv )
         aGet[ _LRECC   ]:Click( lRECCEmpresa() )

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

         aTmp[ _CCODGRP ]        := ( dbfSatCliT )->cCodGrp
         aTmp[ _LMODCLI ]        := ( dbfSatCliT )->lModCli

         /*
         Datos de alquileres---------------------------------------------------
         */

         aTmp[ _LALQUILER ]      := ( dbfSatCliT )->lAlquiler
         aTmp[ _DFECENTR  ]      := ( dbfSatCliT )->dFecEntr
         aTmp[ _DFECSAL   ]      := ( dbfSatCliT )->dFecSal

         if ( dbfSatCliL )->( dbSeek( cNumsat ) )

            ( dbfTmpLin )->( dbAppend() )
            cDesAlb                    := ""
            cDesAlb                    += "S.A.T. Nº " + ( dbfSatCliT )->cSerSat + "/" + AllTrim( str( ( dbfSatCliT )->nNumSat ) ) + "/" + ( dbfSatCliT )->cSufSat
            cDesAlb                    += " - Fecha " + Dtoc( ( dbfSatCliT )->dFecSat )
            ( dbfTmpLin )->MLNGDES     := cDesAlb
            ( dbfTmpLin )->LCONTROL    := .t.

            while ( ( dbfSatCliL )->cSerSat + str( ( dbfSatCliL )->nNumSat ) + ( dbfSatCliL )->cSufSat == cNumsat )

               (dbfTmpLin)->( dbAppend() )

               (dbfTmpLin)->nNumLin    := (dbfSatCliL)->nNumLin
               (dbfTmpLin)->nPosPrint  := (dbfSatCliL)->nPosPrint
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
               (dbfTmpLin)->cCodObr    := (dbfSatCliL)->cObrLin
               (dbfTmpLin)->cRefAux    := (dbfSatCliL)->cRefAux
               (dbfTmpLin)->cRefAux2   := (dbfSatCliL)->cRefAux2
               (dbfTmpLin)->cCtrCoste  := (dbfSatCliL)->cCtrCoste
               (dbfTmpLin)->cTipCtr    := (dbfSatCliL)->cTipCtr
               (dbfTmpLin)->cTerCtr    := (dbfSatCliL)->cTerCtr

               (dbfSatCliL)->( dbSkip() )

            end while

            ( dbfTmpLin )->( dbGoTop() )

            /*
            Pasamos las incidencias del SAT----------------------------
            */

            if ( nMode != DUPL_MODE ) .and. ( dbfSatCliI )->( dbSeek( cNumsat ) )
               while ( dbfSatCliI )->cSerSat + str( ( dbfSatCliI )->nNumSat ) + ( dbfSatCliI )->cSufSat == cNumsat .and. !( dbfSatCliI )->( Eof() )
                  dbPass( dbfSatCliI, dbfTmpInc, .t. )
                  ( dbfSatCliI )->( dbSkip() )
               end while
            end if

            ( dbfSatCliI )->( dbGoTop() )

            /*
            Pasamos los documentos del SAT-----------------------------
            */

            if ( dbfSatCliD )->( dbSeek( cNumsat ) )
               while ( dbfSatCliD )->cSerSat + str( ( dbfSatCliD )->nNumSat ) + ( dbfSatCliD )->cSufSat == cNumsat .and. !( dbfSatCliD )->( Eof() )
                  dbPass( dbfSatCliD, dbfTmpDoc, .t. )
                  ( dbfSatCliD )->( dbSkip() )
               end while
            end if 

            ( dbfSatCliD )->( dbGoTop() )
   
            /*
            Pasamos todas las series----------------------------------------------
            */

            if ( dbfSatCliS )->( dbSeek( cNumsat ) )
               while ( dbfSatCliS )->cSerSat + str( ( dbfSatCliS )->nNumSat ) + ( dbfSatCliS )->cSufSat == cNumsat .and. !( dbfSatCliS )->( Eof() )
                  dbPass( dbfSatCliS, dbfTmpSer, .t. )
                  ( dbfSatCliS )->( dbSkip() )
               end while
            end if 

            ( dbfSatCliS )->( dbGoTop() )

            oBrw:Refresh()
            oBrw:Setfocus()

         end if

         lValid   := .t.

         if ( dbfSatCliT )->( dbRLock() )
            ( dbfSatCliT )->lEstado := .t.
            ( dbfSatCliT )->( dbUnlock() )
         end if

         CursorWE()

      end if

      HideImportacion( aGet, aGet[ _CNUMSAT ] )

   else

      MsgStop( "S.A.T. no existe" )

   end if

RETURN lValid

//---------------------------------------------------------------------------//

Static Function HideImportacion( aGet, oShow )

   aGet[ _LIVAINC ]:Disable()

   aGet[ _CNUMALB ]:Hide()
   aGet[ _CNUMPED ]:Hide()
   aGet[ _CNUMPRE ]:Hide()
   aGet[ _CNUMSAT ]:Hide()

   oBtnPre:Hide()
   oBtnPed:Hide()
   oBtnAlb:Hide()
   oBtnGrp:Hide()
   oBtnSat:Hide()

   if !empty( oShow )
      oShow:Show()
   end if

Return ( nil ) 

//---------------------------------------------------------------------------//

Function cFacturaClienteDireccionSAT()

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

Static Function CargaAtipicasCliente( aTmpFac, oBrwLin, oDlg )

   local nOrder
   local lSearch     := .f.

   /*
   Controlamos que no nos pase Código de cliente vacío------------------------
   */

   if empty( aTmpFac[ _CCODCLI ] )
      MsgStop( "Código de cliente no puede estar vacío para utilizar el asistente." )
      Return .f.
   end if

   /*
   Controlamos que el cliente tenga atipicas----------------------------------
   */

   nOrder            := ( D():Atipicas( nView ) )->( OrdSetFocus( "cCodCli" ) )

   if ( D():Atipicas( nView ) )->( dbSeek( aTmpFac[ _CCODCLI ] ) )

      AutoMeterDialog( oDlg )

      SetTotalAutoMeterDialog( ( D():Atipicas( nView ) )->( LastRec() ) )

      while ( D():Atipicas( nView ) )->cCodCli == aTmpFac[ _CCODCLI ] .and. !( D():Atipicas( nView ) )->( Eof() )

         if lConditionAtipica( nil, D():Atipicas( nView ) ) .and. ( D():Atipicas( nView ) )->lAplFac

            AppendDatosAtipicas( aTmpFac )

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

      if !empty( aTmpFac[ _CCODGRP ] )

         ( D():Atipicas( nView ) )->( OrdSetFocus( "cCodGrp" ) )
      
         if ( D():Atipicas( nView ) )->( dbSeek( aTmpFac[ _CCODGRP ] ) )

            AutoMeterDialog( oDlg )

            SetTotalAutoMeterDialog( ( D():Atipicas( nView ) )->( LastRec() ) )
      
            while ( D():Atipicas( nView ) )->cCodGrp == aTmpFac[ _CCODGRP ] .and. !( D():Atipicas( nView ) )->( Eof() )
      
               if lConditionAtipica( nil, D():Atipicas( nView ) ) .and. ( D():Atipicas( nView ) )->lAplFac
      
                  AppendDatosAtipicas( aTmpFac )
      
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

   RecalculaTotal( aTmpFac )

   if !empty( oBrwLin )
      oBrwLin:GoTop()
      oBrwLin:Refresh()
   end if

Return .t.

//---------------------------------------------------------------------------//

Static Function AppendDatosAtipicas( aTmpFac )

   local nPrecioAtipica
      local hAtipica

      if !dbSeekInOrd( ( D():Atipicas( nView ) )->cCodArt, "cRef", dbfTmpLin )
      
      if ( D():Articulos( nView ) )->( dbSeek( ( D():Atipicas( nView ) )->cCodArt ) ) .and.;
         !( D():Articulos( nView ) )->lObs

         ( dbfTmpLin )->( dbAppend() )

         ( dbfTmpLin )->nNumLin        := nLastNum( dbfTmpLin )
         ( dbfTmpLin )->nPosPrint      := nLastNum( dbfTmpLin, "nPosPrint" )
         ( dbfTmpLin )->cRef           := ( D():Atipicas( nView ) )->cCodArt
         ( dbfTmpLin )->cCodPr1        := ( D():Atipicas( nView ) )->cCodPr1
         ( dbfTmpLin )->cCodPr2        := ( D():Atipicas( nView ) )->cCodPr2
         ( dbfTmpLin )->cValPr1        := ( D():Atipicas( nView ) )->cValPr1
         ( dbfTmpLin )->cValPr2        := ( D():Atipicas( nView ) )->cValPr2
         ( dbfTmpLin )->nCosDiv        := ( D():Atipicas( nView ) )->nPrcCom
         ( dbfTmpLin )->cAlmLin        := aTmpFac[ _CCODALM ]
         ( dbfTmpLin )->lIvaLin        := aTmpFac[ _LIVAINC ]
         ( dbfTmpLin )->dFecFac        := aTmpFac[ _DFECFAC ]
         ( dbfTmpLin )->nTarLin        := oGetTarifa:getTarifa()
         ( dbfTmpLin )->nCanEnt        := 1
         ( dbfTmpLin )->nUniCaja       := 0
         ( dbfTmpLin )->lFromAtp       := .t.
   
         //Datos de la tabla de artículo------------------------------------

         ( dbfTmpLin )->cDetalle       := ( D():Articulos( nView ) )->Nombre
         
         if aTmpFac[ _NREGIVA ] <= 2
            ( dbfTmpLin )->nIva        := nIva( dbfIva, ( D():Articulos( nView ) )->TipoIva )
         end if
           
         ( dbfTmpLin )->cUnidad        := ( D():Articulos( nView ) )->cUnidad
         ( dbfTmpLin )->nCtlStk        := ( D():Articulos( nView ) )->nCtlStock
         ( dbfTmpLin )->lLote          := ( D():Articulos( nView ) )->lLote
         ( dbfTmpLin )->lMsgVta        := ( D():Articulos( nView ) )->lMsgVta
         ( dbfTmpLin )->lNotVta        := ( D():Articulos( nView ) )->lNotVta
         ( dbfTmpLin )->cCodTip        := ( D():Articulos( nView ) )->cCodTip
         ( dbfTmpLin )->cCodFam        := ( D():Articulos( nView ) )->Familia
         ( dbfTmpLin )->nPesoKg        := ( D():Articulos( nView ) )->nPesoKg
   
         ( dbfTmpLin )->dFecUltCom     := dFechaUltimaVenta( aTmpFac[ _CCODCLI ], ( D():Atipicas( nView ) )->cCodArt, dbfAlbCliL, D():FacturasClientesLineas( nView ) )
         ( dbfTmpLin )->nUniUltCom     := nUnidadesUltimaVenta( aTmpFac[ _CCODCLI ], ( D():Atipicas( nView ) )->cCodArt, dbfAlbCliL, D():FacturasClientesLineas( nView ) )
         ( dbfTmpLin )->nPrcUltCom     := nPrecioUltimaVenta( aTmpFac[ _CCODCLI ], ( D():Atipicas( nView ) )->cCodArt, dbfAlbCliL, D():FacturasClientesLineas( nView ) )

         /*
         Vamos a por los catos de la tarifa
         */      

         hAtipica := hAtipica( hValue( dbfTmpLin, aTmpFac ) )

         if !empty( hAtipica )
               
            if hhaskey( hAtipica, "nImporte" )
               if hAtipica[ "nImporte" ] != 0
                  ( dbfTmpLin )->nPreUnit    := hAtipica[ "nImporte" ]
               else 
                  ( dbfTmpLin )->nPreUnit    := nRetPreArt( ( dbfTmpLin )->nTarLin, aTmpFac[ _CDIVFAC ], aTmpFac[ _LIVAINC ], D():Articulos( nView ), dbfDiv, dbfKit, dbfIva, , , oNewImp )
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

      hAtipica := hAtipica( hValue( dbfTmpLin, aTmpFac ) )

      if !empty( hAtipica )
               
         if hhaskey( hAtipica, "nImporte" )
            if hAtipica[ "nImporte" ] != 0
               ( dbfTmpLin )->nPreUnit := hAtipica[ "nImporte" ]
            else
               ( dbfTmpLin )->nPreUnit    := nRetPreArt( ( dbfTmpLin )->nTarLin, aTmpFac[ _CDIVFAC ], aTmpFac[ _LIVAINC ], D():Articulos( nView ), dbfDiv, dbfKit, dbfIva, , , oNewImp )
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

Return .t.

//---------------------------------------------------------------------------//

Static Function ChangeUnidades( oCol, uNewValue, nKey, aTmp, dbfTmpLin )

   /*
   Cambiamos el valor de las unidades de la linea de la factura---------------
   */

   if IsNum( nKey ) .and. ( nKey != VK_ESCAPE ) .and. !IsNil( uNewValue )

      ( dbfTmpLin )->nUnicaja       := uNewValue

      RecalculaTotal( aTmp )

   end if  

Return .t.

//---------------------------------------------------------------------------//

Static Function ChangePrecio( oCol, uNewValue, nKey, aTmp, dbfTmpLin )

   /*
   Cambiamos el valor del precio de la linea de la factura--------------------
   */

   if IsNum( nKey ) .and. ( nKey != VK_ESCAPE ) .and. !IsNil( uNewValue )

      SetUFacCli( dbfTmpLin, uNewValue )

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

Static Function hValue( uTmpLinea, uTmpCabecera )

   local hValue                  := {=>}

   do case 
      case ValType( uTmpLinea ) == "A"

         hValue[ "cCodigoArticulo"   ] := uTmpLinea[ _CREF ]
         hValue[ "cCodigoPropiedad1" ] := uTmpLinea[ _CCODPR1 ]
         hValue[ "cCodigoPropiedad2" ] := uTmpLinea[ _CCODPR2 ]
         hValue[ "cValorPropiedad1"  ] := uTmpLinea[ _CVALPR1 ]
         hValue[ "cValorPropiedad2"  ] := uTmpLinea[ _CVALPR2 ]
         hValue[ "cCodigoFamilia"    ] := uTmpLinea[ _CCODFAM ]
         hValue[ "nTarifaPrecio"     ] := uTmpLinea[ _NTARLIN ]
         hValue[ "nCajas"            ] := uTmpLinea[ _NCANENT ]
         hValue[ "nUnidades"         ] := uTmpLinea[ _NUNICAJA ]

      case ValType( uTmpLinea ) == "C"

         hValue[ "cCodigoArticulo"   ] := ( uTmpLinea )->cRef
         hValue[ "cCodigoPropiedad1" ] := ( uTmpLinea )->cCodPr1
         hValue[ "cCodigoPropiedad2" ] := ( uTmpLinea )->cCodPr2
         hValue[ "cValorPropiedad1"  ] := ( uTmpLinea )->cValPr1
         hValue[ "cValorPropiedad2"  ] := ( uTmpLinea )->cValPr2
         hValue[ "cCodigoFamilia"    ] := ( uTmpLinea )->cCodFam
         hValue[ "nTarifaPrecio"     ] := ( uTmpLinea )->nTarLin         
         hValue[ "nCajas"            ] := ( uTmpLinea )->nCanEnt
         hValue[ "nUnidades"         ] := ( uTmpLinea )->nUniCaja

   end case      

   do case 
      case ValType( uTmpCabecera ) == "A"

         hValue[ "cCodigoCliente"    ] := uTmpCabecera[ _CCODCLI ]
         hValue[ "cCodigoGrupo"      ] := uTmpCabecera[ _CCODGRP ]
         hValue[ "lIvaIncluido"      ] := uTmpCabecera[ _LIVAINC ]
         hValue[ "dFecha"            ] := uTmpCabecera[ _DFECFAC ]
         hValue[ "nDescuentoTarifa"  ] := uTmpCabecera[ _NDTOTARIFA ]

      case ValType( uTmpCabecera ) == "C"
         
         hValue[ "cCodigoCliente"    ] := ( uTmpCabecera )->cCodCli
         hValue[ "cCodigoGrupo"      ] := ( uTmpCabecera )->cCodGrp
         hValue[ "lIvaIncluido"      ] := ( uTmpCabecera )->lIvaInc
         hValue[ "dFecha"            ] := ( uTmpCabecera )->dFecFac
         hValue[ "nDescuentoTarifa"  ] := ( uTmpCabecera )->nDtoTarifa

   end case

   hValue[ "nTipoDocumento"         ] := FAC_CLI
   hValue[ "nView"                  ] := nView

Return ( hValue )

//---------------------------------------------------------------------------//

Static Function ImprimirSeriesFacturas( nDevice, lExt )

   local aStatus
   local oPrinter   
   local cPrinterFactura   := cPrinterFactura( oUser():cCaja(), dbfCajT )


   DEFAULT nDevice         := IS_PRINTER
   DEFAULT lExt            := .f.

   // Cremaos el dialogo-------------------------------------------------------

   oPrinter                := PrintSeries():New( nView ):SetVentas()

   // Establecemos sus valores-------------------------------------------------

   oPrinter:Serie(         ( D():FacturasClientes( nView ) )->cSerie )
   oPrinter:Documento(     ( D():FacturasClientes( nView ) )->nNumFac )
   oPrinter:Sufijo(        ( D():FacturasClientes( nView ) )->cSufFac )

   if lExt

      oPrinter:oFechaInicio:cText( ( D():FacturasClientes( nView ) )->dFecFac )
      oPrinter:oFechaFin:cText( ( D():FacturasClientes( nView ) )->dFecFac )

   end if

   oPrinter:oFormatoDocumento:TypeDocumento( "FC" )   

   // Formato de documento-----------------------------------------------------

   oPrinter:oFormatoDocumento:cText( cFormatoFacturasClientes() )

   // Codeblocks para que trabaje----------------------------------------------

   aStatus           := D():GetInitStatus( "FacCliT", nView )

   oPrinter:bInit    := {||   ( D():FacturasClientes( nView ) )->( dbSeek( oPrinter:DocumentoInicio(), .t. ) ) }

   oPrinter:bWhile   := {||   oPrinter:InRangeDocumento( D():FacturasClientesId( nView ) )                  .and. ;
                              ( D():FacturasClientes( nView ) )->( !eof() ) }

   oPrinter:bFor     := {||   oPrinter:InRangeFecha( ( D():FacturasClientes( nView ) )->dFecFac )           .and. ;
                              oPrinter:InRangeCliente( ( D():FacturasClientes( nView ) )->cCodCli )         .and. ;
                              oPrinter:InRangeAgente( ( D():FacturasClientes( nView ) )->cCodAge )         .and. ;
                              oPrinter:InRangeGrupoCliente( retGrpCli( ( D():FacturasClientes( nView ) )->cCodCli, D():Clientes( nView ) ) ) }

   oPrinter:bSkip    := {||   ( D():FacturasClientes( nView ) )->( dbSkip() ) }

   oPrinter:bAction  := {||   GenFacCli(  nDevice,; 
                                          "Imprimiendo documento : " + D():FacturasClientesId( nView ),;
                                          oPrinter:oFormatoDocumento:uGetValue,;
                                          oPrinter:oImpresora:uGetValue,;
                                          if( !oPrinter:oCopias:lCopiasPredeterminadas, oPrinter:oCopias:uGetValue, ) ) }

   oPrinter:bStart   := {||   if( lExternal, oPrinter:DisableRange(), ),;
                              if( !empty( cPrinterFactura ), oPrinter:setPrinter( cPrinterFactura ), ) }

   // Abrimos el dialogo-------------------------------------------------------

   oPrinter:Resource():End()

   // Restore -----------------------------------------------------------------

   D():SetStatus( "FacCliT", nView, aStatus )
   
   if !empty( oWndBrw )
      oWndBrw:Refresh()
   end if   

Return .t.

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
/*------------------------FUNCIONES GLOBALESS--------------------------------*/
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

FUNCTION nBrtLFacCli( uTmpLin, nDec, nRec, nVdv, cPorDiv )

   local nCalculo    := 0

   DEFAULT nDec      := nDouDiv()
   DEFAULT nVdv      := 1

   nCalculo          := nTotUFacCli( uTmpLin, nDec, nVdv, cPorDiv )
   nCalculo          *= nTotNFacCli( uTmpLin )

   nCalculo          := Round( nCalculo / nVdv, nRec )

Return ( if( cPorDiv != nil, Trans( nCalculo, cPorDiv ), nCalculo ) )

//---------------------------------------------------------------------------//
/*
Devuelve el valor del impuestos de un artículo
*/

FUNCTION nIvaUFacCli( uTmpLin, nDec, nVdv )

   local nCalculo

   DEFAULT uTmpLin   := D():FacturasClientesLineas( nView )
   DEFAULT nDec      := nDouDiv()
   DEFAULT nVdv      := 1

   nCalculo          := nTotUFacCli( uTmpLin, nDec, nVdv )

   if ( uTmpLin )->lIvaLin
      nCalculo       -= nCalculo / ( 1 + ( uTmpLin )->nIva / 100 )
   else
      nCalculo       := nCalculo * ( uTmpLin )->nIva / 100
   end if

   if nVdv != 0
      nCalculo       := nCalculo / nVdv
   end if

RETURN ( Round( nCalculo, nDec ) )

//---------------------------------------------------------------------------//
/*
Devuelve el valor del Req de un artículo
*/

FUNCTION nReqUFacCli( dbfTmpLin, nDec, nVdv )

   local nCalculo

   DEFAULT nDec   := nDouDiv()
   DEFAULT nVdv   := 1

   nCalculo       := nTotUFacCli( dbfTmpLin, nDec, nVdv )

   if !( dbfTmpLin )->lIvaLin
      nCalculo    := nCalculo * ( dbfTmpLin )->nReq / 100
   else
      nCalculo    -= nCalculo / ( 1 + ( dbfTmpLin )->nReq / 100 )
   end if

   if nVdv != 0
      nCalculo    := nCalculo / nVdv
   end if

RETURN ( Round( nCalculo, nDec ) )

//---------------------------------------------------------------------------//
/*
Devuelve el precio unitario impuestos incluido
*/

FUNCTION nIncUFacCli( cTmpLin, nDec, nVdv )

   local nCalculo

   DEFAULT cTmpLin   := D():FacturasClientesLineas( nView )
   DEFAULT nDec      := nDouDiv()
   DEFAULT nVdv      := 1

   nCalculo          := nTotUFacCli( cTmpLin, nDec, nVdv )

   if !( cTmpLin )->lIvaLin
      nCalculo       += nCalculo * ( cTmpLin )->nIva / 100
   end if

   IF nVdv != 0
      nCalculo       := nCalculo / nVdv
   END IF

RETURN ( Round( nCalculo, nDec ) )

//---------------------------------------------------------------------------//

FUNCTION nIvaLFacCli( cFacCliL, nDec, nRou, nVdv, lDto, lPntVer, lImpTrn, cPouDiv )

   local nCalculo    := 0

   DEFAULT cFacCliL  := D():FacturasClientesLineas( nView )
   DEFAULT nDec      := nDouDiv()
   DEFAULT nRou      := nRouDiv()
   DEFAULT nVdv      := 1
   DEFAULT lDto      := .t.
   DEFAULT lPntVer   := .t.
   DEFAULT lImpTrn   := .t.

   if ( cFacCliL )->nRegIva <= 1
      
      nCalculo          := nTotLFacCli( cFacCliL, nDec, nRou, nVdv, lDto, lPntVer, lImpTrn, cPouDiv ) 

      if !( cFacCliL )->lIvaLin
         nCalculo       := nCalculo * ( cFacCliL )->nIva / 100
      else
         nCalculo       -= nCalculo / ( 1 + ( cFacCliL )->nIva / 100 )
      end if

   end if

   nCalculo          := Round( nCalculo, nRou )

RETURN ( if( cPouDiv != nil, Trans( nCalculo, cPouDiv ), nCalculo ) )

//---------------------------------------------------------------------------//

FUNCTION nIvaIFacCli( dbfLin, nDec, nRou, nVdv, cPouDiv )

   local nCalculo := nTotIFacCli( dbfLin, nDec, nRou, nVdv )

   nCalculo       := Round( nCalculo * ( dbfLin )->nIva / 100, nRou )

RETURN ( if( cPouDiv != nil, Trans( nCalculo, cPouDiv ), nCalculo ) )

//---------------------------------------------------------------------------//

FUNCTION nReqLFacCli( dbfLin, nDec, nRou, nVdv, lDto, lPntVer, lImpTrn, cPouDiv )

   local nCalculo := nTotLFacCli( dbfLin, nDec, nRou, nVdv, lDto, lPntVer, lImpTrn, cPouDiv )

   nCalculo       := Round( nCalculo * ( dbfLin )->nReq / 100, nRou )

RETURN ( if( cPouDiv != nil, Trans( nCalculo, cPouDiv ), nCalculo ) )

//---------------------------------------------------------------------------//

/*
Devuelve el total de una lina con impuestos incluido
*/

FUNCTION nIncLFacCli( cDbfLin, nDec, nRouDec, nVdv, lDto, lPntVer, lImpTrn, cPorDiv )

   local lIvaInc  
   local nCalculo    := 0

   DEFAULT nDec      := 0
   DEFAULT nRouDec   := 0111
   DEFAULT nVdv      := 1
   DEFAULT lDto      := .t.
   DEFAULT lPntVer   := .f.
   DEFAULT lImpTrn   := .f.
   DEFAULT cDbfLin   := D():FacturasClientesLineas( nView )          

   nCalculo          := nTotLFacCli( cDbfLin, nDec, nRouDec, nVdv, lDto, lPntVer, lImpTrn )

   if !( cDbfLin )->lIvaLin
      nCalculo       += nCalculo * ( cDbfLin )->nIva / 100
   end if

RETURN ( if( cPorDiv != NIL, Trans( nCalculo, cPorDiv ), nCalculo ) )

//---------------------------------------------------------------------------//
/*
Devuelve el total de una linea sin impuestos incluido
*/

FUNCTION nNoIncLFacCli( dbfLin, nDec, nRouDec, nVdv, lDto, lPntVer, lImpTrn, cPorDiv )

   local nCalculo

   DEFAULT dbfLin := D():FacturasClientesLineas( nView )

   nCalculo       := nTotLFacCli( dbfLin, nDec, nRouDec, nVdv, lDto, lPntVer, lImpTrn )

   if ( dbfLin )->lIvaLin
      nCalculo    := nCalculo / ( ( ( dbfLin )->nIva / 100 ) + 1 )
   end if

RETURN ( if( cPorDiv != NIL, Trans( nCalculo, cPorDiv ), nCalculo ) )

//---------------------------------------------------------------------------//

/*
Devuelve el precio unitario sin impuestos incluido
*/

FUNCTION nNoIncUFacCli( dbfLin, nDec, nVdv )

   local nCalculo

   DEFAULT dbfLin := D():FacturasClientesLineas( nView )

   nCalculo       := nTotUFacCli( dbfLin, nDec, nVdv )

   if ( dbfLin )->lIvaLin
      nCalculo    := nCalculo / ( ( ( dbfLin )->nIva / 100 ) + 1 )
   end if

RETURN ( nCalculo )

//---------------------------------------------------------------------------//

FUNCTION aTotFacCli( cFactura, cFacCliT, cFacCliL, dbfIva, dbfDiv, dbfFacCliP, cAntCliT, cDivRet )

   nTotFacCli( cFactura, cFacCliT, cFacCliL, dbfIva, dbfDiv, dbfFacCliP, cAntCliT, nil, cDivRet )

RETURN ( { nTotNet, nTotIva, nTotReq, nTotFac, nTotPnt, nTotTrn, nTotAge, aTotIva, nTotCos, nTotIvm, nTotRnt, nTotRet, nTotCob } )

//---------------------------------------------------------------------------//

FUNCTION nTotPdtFacCli( cFactura, cFacCliT, cFacCliL, dbfIva, dbfDiv, dbfFacCliP, cAntCliT, cDivRet )

   nTotFacCli( cFactura, cFacCliT, cFacCliL, dbfIva, dbfDiv, dbfFacCliP, cAntCliT, nil, cDivRet )

RETURN ( nTotFac - nTotCob )

//---------------------------------------------------------------------------//

FUNCTION sTotFacCli( cFactura, cFacCliT, cFacCliL, dbfIva, dbfDiv, dbfFacCliP, cAntCliT, cDivRet )

   local sTotal

   nTotFacCli( cFactura, cFacCliT, cFacCliL, dbfIva, dbfDiv, dbfFacCliP, cAntCliT, nil, cDivRet )

   sTotal                                 := sTotal()

   sTotal:nTotalBruto                     := nTotBrt
   sTotal:nTotalNeto                      := nTotNet
   sTotal:nTotalIva                       := nTotIva
   sTotal:nTotalRecargoEquivalencia       := nTotReq
   sTotal:nTotalRetencion                 := nTotRet
   sTotal:nTotalDocumento                 := nTotFac
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

   sTotal:nTotalCobrado                   := nTotCob

   sTotal:aTotalIva                       := aTotIva

   sTotal:aTotalBase[ 1 ]                 := aTotIva[ 1, 2 ]
   sTotal:aTotalBase[ 2 ]                 := aTotIva[ 2, 2 ]
   sTotal:aTotalBase[ 3 ]                 := aTotIva[ 3, 2 ]

   sTotal:aPorcentajeIva[ 1 ]             := aTotIva[ 1, 3 ]
   sTotal:aPorcentajeIva[ 2 ]             := aTotIva[ 2, 3 ]
   sTotal:aPorcentajeIva[ 3 ]             := aTotIva[ 3, 3 ]

Return ( sTotal )

//---------------------------------------------------------------------------//

/*
Devuelve el codigo del Cliente pasando un numero de factura
*/

FUNCTION cCliFacCli( cFacCli, uFacCliT )

   local cCodCli  := ""

   do case
      case ValType( uFacCliT ) == "C"
         if (uFacCliT)->( dbSeek( cFacCli ) )
            cCodCli     := (uFacCliT)->CCODCLI
         end if
      case ValType( uFacCliT ) == "O"
         if uFacCliT:Seek( cFacCli )
            cCodCli     := uFacCliT:cCodCli
         end if
   end case

RETURN ( cCodCli )

//---------------------------------------------------------------------------//

/*
Devuelve el codigo del Cliente pasando un numero de factura
*/

FUNCTION cNbrFacCli( cFacCli, uFacCliT )

   local cNomCli  := ""

   do case
      case ValType( uFacCliT ) == "C"
         if (uFacCliT)->( dbSeek( cFacCli ) )
            cNomCli     := (uFacCliT)->CNOMCLI
         end if
      case ValType( uFacCliT ) == "O"
         if uFacCliT:Seek( cFacCli )
            cNomCli     := uFacCliT:cNomCli
         end if
   end case

RETURN ( cNomCli )

//---------------------------------------------------------------------------//

/*
Devuelve la forma de pago pasando un numero de factura
*/

FUNCTION cPgoFacCli( cFacCli, cFacCliT )

   local cCodPgo  := ""

   if ValType( cFacCliT ) == "O"
      if cFacCliT:Seek( cFacCli )
         cCodPgo  := cFacCliT:cCodPago
      end if
   else
      if ( cFacCliT )->( dbSeek( cFacCli ) )
         cCodPgo  := ( cFacCliT )->cCodPago
      end if
   end if

RETURN ( cCodPgo )

//----------------------------------------------------------------------------//

FUNCTION cProFacCli( cFacCli, cFacCliT )

   local cCodPro  := ""

   if ( cFacCliT )->( dbSeek( cFacCli ) )
      cCodPro     := ( cFacCliT )->CCODPRO
   END IF

RETURN ( cCodPro )

//----------------------------------------------------------------------------//
/*
Devuelve si la factura esta contabilizada o no
*/

FUNCTION lConFacCli( cFacCli, cFacCliT )

   local lConFac  := .f.

   if ( cFacCliT )->( dbSeek( cFacCli ) )
      lConFac     := ( cFacCliT )->lContab
   end if

RETURN ( lConFac )

//----------------------------------------------------------------------------//
/*
Devuelve el codigo de cliente de una factura
*/

FUNCTION cAgeFacCli( cFacCli, cFacCliT )

   local cCliFac  := ""

   if ValType( cFacCliT ) == "O"
      if cFacCliT:Seek( cFacCli )
         cCliFac  := cFacCliT:cCodAge
      end if
   else
      if ( cFacCliT )->( dbSeek( cFacCli ) )
         cCliFac  := ( cFacCliT )->cCodAge
      end if
   end if

RETURN ( cCliFac )

//---------------------------------------------------------------------------//
/*
Devuelve la Descripción de una line de factura
*/

FUNCTION cDesFacCli( cFacCliL, cFacCliS )

   DEFAULT cFacCliL  := D():FacturasClientesLineas( nView )
   DEFAULT cFacCliS  := dbfFacCliS

RETURN ( Descrip( cFacCliL, cFacCliS ) )

//---------------------------------------------------------------------------//

FUNCTION cDesFacCliLeng( cFacCliL, cFacCliS, cArtLeng )

   DEFAULT cFacCliL  := D():FacturasClientesLineas( nView )
   DEFAULT cFacCliS  := dbfFacCliS
   DEFAULT cArtLeng  := D():ArticuloLenguaje( nView )

RETURN ( DescripLeng( cFacCliL, cFacCliS, cArtLeng ) )

//---------------------------------------------------------------------------//

Function cCtaFacCli( cFacCliT, cFacCliP, cBncCli )

   local cCtaFacCli     := ""

   DEFAULT cFacCliT     := D():FacturasClientes( nView )
   DEFAULT cFacCliP     := D():FacturasClientesCobros( nView )
   DEFAULT cBncCli      := dbfCliBnc

   cCtaFacCli           := Rtrim( ( cFacCliT )->cEntBnc + ( cFacCliT )->cSucBnc + ( cFacCliT )->cDigBnc + ( cFacCliT )->cCtaBnc )

   if empty( cCtaFacCli )
      if dbSeekInOrd( ( cFacCliT )->cSerie + str( ( cFacCliT )->nNumFac ) + ( cFacCliT )->cSufFac, "fNumFac", cFacCliP )
         cCtaFacCli     := cClientCuenta( ( cFacCliP )->cCodCli, cBncCli )
      end if
   end if

Return ( cCtaFacCli )

//------------------------------------------------------------------------//

FUNCTION nBas( aIva, nPctIva, nRet )

   local nPos := aScan( aIva, {| aIva | aIva[ 3 ] == nPctIva } )

RETURN ( if( nPos != 0, aIva[ nPos, nRet ], 0 ) )

//---------------------------------------------------------------------------//

FUNCTION nValorArrayIVA( cSerializeTotal, nPorcentajeIva, nValor )

   local nPos
   local aTotalIva   := {}
   local sTotal      := sTotal():New()

   DEFAULT nValor    := 2  // Base

   sTotal:loadFromText( cSerializeTotal )

   aTotalIva         := sTotal:aTotalIva

   if empty( aTotalIva )
      RETURN ( 0 )
   end if 

   nPos              := aScan( aTotalIva, {| aIva | aIva[ 3 ] == nPorcentajeIva } )

RETURN ( if( nPos != 0, aTotalIva[ nPos, nValor ], 0 ) )

//---------------------------------------------------------------------------//
//
// Devuelve el total de la compra en facturas de proveedores de un articulo
//

function nTotDFacCli( cCodArt, dbfFacCliL, cCodAlm )

   local nOrd     := ( D():FacturasClientesLineas( nView ) )->( OrdSetFocus( "cRef" ) )
   local nRec     := ( D():FacturasClientesLineas( nView ) )->( Recno() )
   local nTotVta  := 0

   if ( D():FacturasClientesLineas( nView ) )->( dbSeek( cCodArt ) )

      while ( D():FacturasClientesLineas( nView ) )->cRef == cCodArt .and. !( D():FacturasClientesLineas( nView ) )->( eof() )

         if !( D():FacturasClientesLineas( nView ) )->lTotLin
            if cCodAlm != nil
               if cCodAlm == ( D():FacturasClientesLineas( nView ) )->cAlmLin
                  nTotVta  += nTotNFacCli( D():FacturasClientesLineas( nView ) ) * NotCero( ( D():FacturasClientesLineas( nView ) )->nFacCnv )
               end if
            else
               nTotVta     += nTotNFacCli( D():FacturasClientesLineas( nView ) ) * NotCero( ( D():FacturasClientesLineas( nView ) )->nFacCnv )
            end if
         end if

         ( D():FacturasClientesLineas( nView ) )->( dbSkip() )

      end while

   end if

   ( D():FacturasClientesLineas( nView ) )->( OrdSetFocus( nOrd  ) )
   ( D():FacturasClientesLineas( nView ) )->( dbGoTo( nRec ) )

return ( nTotVta )

//---------------------------------------------------------------------------//

FUNCTION nVolLFacCli( dbfLin )

   local nCalculo    := 0

   if !( dbfLin )->lTotLin
      nCalculo       := nTotNFacCli( dbfLin ) * ( dbfLin )->nVolumen
   end if

RETURN ( nCalculo )

//---------------------------------------------------------------------------//

FUNCTION nTotPFacCli( dbfLin, nDec, nVdv, cPorDiv )

   local nCalculo
   local nDescuentoGeneral
   local nDescuentoPromocional

   DEFAULT dbfLin                := D():FacturasClientesLineas( nView )
   DEFAULT nDec                  := nDouDiv()
   DEFAULT nVdv                  := 1

   if ( dbfLin )->lTotLin

      nCalculo                   := nTotUFacCli( dbfLin, nDec )

   else

      /*
      Tomamos los valores redondeados------------------------------------------
      */

      nCalculo                   := nTotUFacCli( dbfLin, nDec )

      nCalculo                   -= Round( ( dbfLin )->nDtoDiv , nDec )

      if ( dbfLin )->nDto != 0
         nCalculo                -= nCalculo * ( dbfLin )->nDto / 100
      end if

      if ( dbfLin )->nDtoPrm != 0
         nCalculo                -= nCalculo * ( dbfLin )->nDtoPrm / 100
      end if

      /*
      nCalculo                   -= nDescuentoGeneral
      nCalculo                   -= nDescuentoPromocional
      */

   end if

   nCalculo                      := Round( nCalculo / nVdv, nDec )

RETURN ( if( cPorDiv != NIL, Trans( nCalculo, cPorDiv ), nCalculo ) )

//---------------------------------------------------------------------------//
/*
Devuelve el importe de descuento porcentual por cada linea---------------------
*/

FUNCTION nDtoLFacCli( cFacCliL, nDec, nRou, nVdv )

   local nCalculo       := 0

   DEFAULT cFacCliL     := D():FacturasClientesLineas( nView )
   DEFAULT nDec         := nDouDiv()
   DEFAULT nRou         := nRouDiv()
   DEFAULT nVdv         := 1

   if ( cFacCliL )->nDto != 0 .and. !( cFacCliL )->lTotLin

      nCalculo          := nTotUFacCli( cFacCliL, nDec ) * nTotNFacCli( cFacCliL )

      /*
      Descuentos---------------------------------------------------------------
      */

      nCalculo          -= Round( ( cFacCliL )->nDtoDiv / nVdv , nDec )

      nCalculo          := nCalculo * ( cFacCliL )->nDto / 100


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

FUNCTION nPrmLFacCli( cFacCliL, nDec, nRou, nVdv )

   local nCalculo       := 0

   DEFAULT cFacCliL     := D():FacturasClientesLineas( nView )
   DEFAULT nDec         := nDouDiv()
   DEFAULT nRou         := nRouDiv()
   DEFAULT nVdv         := 1

   if ( cFacCliL )->nDtoPrm != 0 .and. !( cFacCliL )->lTotLin

      nCalculo          := nTotUFacCli( cFacCliL, nDec ) * nTotNFacCli( cFacCliL )

      /*
      Descuentos---------------------------------------------------------------
      */

      nCalculo          -= Round( ( cFacCliL )->nDtoDiv / nVdv , nDec )

      if ( cFacCliL )->nDto != 0 
         nCalculo       -= nCalculo * ( cFacCliL )->nDto / 100
      end if

      nCalculo          := nCalculo * ( cFacCliL )->nDtoPrm / 100

      if nVdv != 0
         nCalculo       := nCalculo / nVdv
      end if

      if nRou != nil
         nCalculo       := Round( nCalculo, nRou )
      end if

   end if

RETURN ( nCalculo ) 

//---------------------------------------------------------------------------//

Function nTotDtoLFacCli( dbfLin, nDec, nVdv, cPorDiv )

   local nCalculo

   DEFAULT dbfLin    := D():FacturasClientesLineas( nView )
   DEFAULT nDec      := nDouDiv()
   DEFAULT nVdv      := 1

   nCalculo          := nDtoLFacCli( dbfLin, nDec, nVdv ) * nTotNFacCli( dbfLin )

   if nVdv != 0
      nCalculo       := nCalculo / nVdv
   end if

   nCalculo          := Round( nCalculo, nDec )

RETURN ( if( cPorDiv != nil, Trans( nCalculo, cPorDiv ), nCalculo ) )

//----------------------------------------------------------------------------//

FUNCTION sTotLFacCli( dbfLin, nDec, nRou, nVdv, lDto, lPntVer, lImpTrn, cPorDiv )

   local uTotLFacCli
   local nTotLFacCli := nTotLFacCli( dbfLin, nDec, nRou, nVdv, lDto, lPntVer, lImpTrn )

   if nTotLFacCli == 0 .and. !( dbfLin )->lControl
      uTotLFacCli    := "S/C"
   else
      uTotLFacCli    := if( cPorDiv != NIL, Trans( nTotLFacCli, cPorDiv ), nTotLFacCli )
   end if

RETURN ( uTotLFacCli )

//----------------------------------------------------------------------------//

FUNCTION nDtoAtpFacCli( uFacCliT, uFacCliL, nDec, nRou, nVdv, lPntVer, lImpTrn )

   local nCalculo
   local nDtoAtp     := 0

   DEFAULT nDec      := nDouDiv()
   DEFAULT nRou      := nRouDiv()
   DEFAULT nVdv      := 1
   DEFAULT lPntVer   := .f.
   DEFAULT lImpTrn   := .f.

   nCalculo          := nTotLFacCli( uFacCliL, nDec, nRou, nVdv, .t., lPntVer, lImpTrn )

   if ( uFacCliT )->nSbrAtp <= 1 .and. ( uFacCliT )->nDtoAtp != 0
      nDtoAtp        += Round( nCalculo * ( uFacCliT )->nDtoAtp / 100, nRou )
   end if

   nCalculo          -= Round( nCalculo * ( uFacCliT )->nDtoEsp / 100, nRou )

   if ( uFacCliT )->nSbrAtp == 2 .and. ( uFacCliT )->nDtoAtp != 0
      nDtoAtp        += Round( nCalculo * ( uFacCliT )->nDtoAtp / 100, nRou )
   end if

   nCalculo          -= Round( nCalculo * ( uFacCliT )->nDpp    / 100, nRou )

   if ( uFacCliT )->nSbrAtp == 3 .and. ( uFacCliT )->nDtoAtp != 0
      nDtoAtp        += Round( nCalculo * ( uFacCliT )->nDtoAtp / 100, nRou )
   end if

   nCalculo          -= Round( nCalculo * ( uFacCliT )->nDtoUno / 100, nRou )

   if ( uFacCliT )->nSbrAtp == 4 .and. ( uFacCliT )->nDtoAtp != 0
      nDtoAtp        += Round( nCalculo * ( uFacCliT )->nDtoAtp / 100, nRou )
   end if

   nCalculo          -= Round( nCalculo * ( uFacCliT )->nDtoDos / 100, nRou )

   if ( uFacCliT )->nSbrAtp == 5 .and. ( uFacCliT )->nDtoAtp != 0
      nDtoAtp        += Round( nCalculo * ( uFacCliT )->nDtoAtp / 100, nRou )
   end if

RETURN ( nDtoAtp )

//---------------------------------------------------------------------------//
//
// Devuelve el neto de una linea de articulo
//

FUNCTION nNetLFacCli( cFacCliL, nDec, nRou, nVdv, lDto, lPntVer, lImpTrn, cPouDiv )

   local nCalculo

   DEFAULT cFacCliL  := D():FacturasClientesLineas( nView )
   DEFAULT nDec      := nDouDiv()
   DEFAULT nVdv      := 1
   DEFAULT lDto      := .t.
   DEFAULT lPntVer   := .t.

   nCalculo          := nTotLFacCli( cFacCliL, nDec, nRou, nVdv, lDto, lPntVer, lImpTrn )

   if ( cFacCliL )->nIva != 0 .and. ( cFacCliL )->lIvaLin
      if nRou != nil
         nCalculo -= Round( nCalculo / ( 100 / ( cFacCliL )->nIva + 1 ), nRou )
      else
         nCalculo -= ( nCalculo / ( 100 / ( cFacCliL )->nIva + 1 ) )
      end if
   end if

RETURN ( if( cPouDiv != NIL, Trans( nCalculo, cPouDiv ), nCalculo ) )

//---------------------------------------------------------------------------//
//
// Devuelve el total de la venta en Facturas de un clientes determinado
//

function nVtaFacCli( cCodCli, dDesde, dHasta, cFacCliT, cFacCliL, cFacCliP, cAntCliT, dbfIva, dbfDiv, nYear )

   local nCon     := 0
   local nOrd     := ( cFacCliT )->( OrdSetFocus( "CCODCLI" ) )
   local nRec     := ( cFacCliT )->( Recno() )

   // Facturas a Clientes -------------------------------------------------------

   if ( cFacCliT )->( dbSeek( cCodCli ) )

      while ( cFacCliT )->cCodCli = cCodCli .and. !( cFacCliT )->( Eof() )

         if ( dDesde == nil .or. ( cFacCliT )->DFECFAC >= dDesde ) .and.;
            ( dHasta == nil .or. ( cFacCliT )->DFECFAC <= dHasta ) .and.;
            ( nYear == nil .or. Year( ( cFacCliT )->dFecFac ) == nYear )

            nCon  += nTotFacCli( ( cFacCliT )->cSerie + str( ( cFacCliT )->nNumFac ) + ( cFacCliT )->cSufFac, cFacCliT, cFacCliL, dbfIva, dbfDiv, cFacCliP, cAntCliT, nil, cDivEmp(), .f. )

         end if

         ( cFacCliT )->( dbSkip() )

         SysRefresh()

      end while

   end if

   ( cFacCliT )->( OrdSetFocus( nOrd ) )
   ( cFacCliT )->( dbGoTo( nRec ) )

return nCon

//----------------------------------------------------------------------------//
//
// Devuelve el total de pagos en Facturas de un clientes determinado
//

function nCobFacCli( cCodCli, dDesde, dHasta, cFacCliT, cFacCliL, dbfFacCliP, dbfIva, dbfDiv, lOnlyCob, nYear )

   local nCon        := 0
   local nOrd        := ( dbfFacCliP )->( OrdSetFocus( "CCODCLI" ) )
   local nRec        := ( dbfFacCliP )->( Recno() )

   DEFAULT lOnlyCob  := .t.

   /*
   Facturas a Clientes -------------------------------------------------------
   */

   if ( dbfFacCliP )->( dbSeek( cCodCli ) )

      while ( dbfFacCliP )->cCodCli = cCodCli .and. !( dbfFacCliP )->( Eof() )

         if ( ( dbfFacCliP )->lCobrado .and. !( dbfFacCliP )->lPasado )    .and.;
            ( dDesde == nil .or. ( dbfFacCliP )->dEntrada >= dDesde )      .and.;
            ( dHasta == nil .or. ( dbfFacCliP )->dEntrada <= dHasta )      .and.;
            ( nYear == nil .or. Year( ( dbfFacCliP )->dEntrada ) == nYear )

            nCon     += nTotCobCli( dbfFacCliP, dbfDiv, nil, .f. )

         end if

         ( dbfFacCliP )->( dbSkip() )

         SysRefresh()

      end while

   end if

   ( dbfFacCliP )->( OrdSetFocus( nOrd ) )
   ( dbfFacCliP )->( dbGoTo( nRec ) )

return nCon

//----------------------------------------------------------------------------//

function nPdtFacCli( cCodCli, dDesde, dHasta, cFacCliT, cFacCliL, dbfFacCliP, dbfIva, dbfDiv, lOnlyCob, nYear )

   local nCon        := 0
   local nOrd        := ( dbfFacCliP )->( OrdSetFocus( "CCODCLI" ) )
   local nRec        := ( dbfFacCliP )->( Recno() )

   DEFAULT lOnlyCob  := .t.

   /*
   Facturas a Clientes -------------------------------------------------------
   */

   if ( dbfFacCliP )->( dbSeek( cCodCli ) )

      while ( dbfFacCliP )->cCodCli = cCodCli .and. !( dbfFacCliP )->( Eof() )

         if (!( dbfFacCliP )->lCobrado )                                   .and.;
            ( dDesde == nil .or. ( dbfFacCliP )->dEntrada >= dDesde )      .and.;
            ( dHasta == nil .or. ( dbfFacCliP )->dEntrada <= dHasta )      .and.;
            ( nYear == nil .or. Year( ( dbfFacCliP )->dEntrada ) == nYear )

            nCon     += nTotRecCli( dbfFacCliP, dbfDiv, nil, .f. )

         end if

         ( dbfFacCliP )->( dbSkip() )

         SysRefresh()

      end while

   end if

   ( dbfFacCliP )->( OrdSetFocus( nOrd ) )
   ( dbfFacCliP )->( dbGoTo( nRec ) )

return nCon

//----------------------------------------------------------------------------//

Function ShowKit( dbfMaster, dbfTmpLin, oBrw, lSet, dbfTmpInc, cCodCli, cClient, oGetRnt, aGet, oSayGetRnt )

   local lShwKit     := lShwKit()

   DEFAULT  lSet     := .t.

   if !empty( aGet ) .and. !empty( dbfMaster )

      if !empty( cCodCli )

        aGet[ ( dbfMaster )->( FieldPos( "cCodCli" ) ) ]:cText( cCodCli )
        aGet[ ( dbfMaster )->( FieldPos( "cCodCli" ) ) ]:lValid()

      end if

   end if

   if oGetRnt != nil .and. oUser():lNotRentabilidad()
      oGetRnt:Hide()
   end if

   if oSayGetRnt != nil .and. oUser():lNotRentabilidad()
      oSayGetRnt:Hide()
   end if

   /*
   Hace que salte la incidencia al entrar en el documento----------------------
   */

   if !empty( dbfTmpInc ) .and. ( dbfTmpInc )->( Used() )

      while !( dbfTmpInc )->( Eof() )
         if ( dbfTmpInc )->lAviso .and. !( dbfTmpInc )->lListo
            MsgInfo( Trim( ( dbfTmpInc )->mDesInc ), "!Incidencia!" )
         end if
         ( dbfTmpInc )->( dbSkip() )
      end while

      ( dbfTmpInc )->( dbGoTop() )

   end if

   oBrw:Refresh()

return nil

//---------------------------------------------------------------------------//

FUNCTION lSndInt( oBrw, dbf )

   if ( dbf )->( dbRLock() )
      ( dbf )->lSndDoc  := !( dbf )->lSndDoc
      ( dbf )->( dbUnlock() )
   end if

   oBrw:Refresh()
   oBrw:SetFocus()

RETURN NIL

//-------------------------------------------------------------------------//

//
// Devuelve el numero de unidades reservadas en facturas a clientes
//

function nTotRFacCli( cNumFac, dFecRes, cCodArt, cValPr1, cValPr2, cLote, cFacCliT, cFacCliL )

   local nTot        := 0
   local aStaFac     := aGetStatus( cFacCliT, .t. )
   local aStaLin     := aGetStatus( cFacCliL, .f. )

   DEFAULT cValPr1   := Space( 40 )
   DEFAULT cValPr2   := Space( 40 )

   ( cFacCliL )->( dbGoTop() )

   if ( cFacCliL )->( dbSeek( cNumFac ) )
      while ( cFacCliL )->cSerie + str( ( cFacCliL )->nNumFac, 9 ) + ( cFacCliL )->cSufFac == cNumFac .and. !( cFacCliL )->( eof() )
         if ( cFacCliL )->cRef + ( cFacCliL )->cValPr1 + ( cFacCliL )->cValPr2 == cCodArt + cValPr1 + cValPr2
            if empty( dFecRes ) .or. dFecRes <= dFecFacCli( ( cFacCliL )->cSerFac + str( ( cFacCliL )->nNumFac ) + ( cFacCliL )->cSufFac, cFacCliT ) // empty( dFecRes )
               if ( cFacCliL )->cLote == cLote
                  nTot  += nTotNFacCli( cFacCliL )
               end if
            end if
         end if
         ( cFacCliL )->( dbSkip() )
      end while
   end if

   SetStatus( cFacCliT, aStaFac )
   SetStatus( cFacCliL, aStaLin )

return ( nTot )

//---------------------------------------------------------------------------//

function nUnidadesRecibidasFacturasClientes( cNumPed, cCodArt, cValPr1, cValPr2, cFacCliL )

   local nUnidades   := 0
   local aStatus     := aGetStatus( cFacCliL, .f. )

   DEFAULT cValPr1   := Space( 20 )
   DEFAULT cValPr2   := Space( 20 )

   ( cFacCliL )->( ordsetfocus( "cNumPedRef" ) )

   if ( cFacCliL )->( dbseek( cNumPed + cCodArt + cValPr1 + cValPr2 ) )
      while ( cFacCliL )->cNumPed + ( cFacCliL )->cRef + ( cFacCliL )->cValPr1 + ( cFacCliL )->cValPr2 == cNumPed + cCodArt + cValPr1 + cValPr2 .and. !( cFacCliL )->( eof() )
         nUnidades        += nTotNFacCli( cFacCliL )
         ( cFacCliL )->( dbskip() )
      end while
   end if

   SetStatus( cFacCliL, aStatus )

return ( nUnidades )

//---------------------------------------------------------------------------//

FUNCTION browseFacturasClientes( oGet, oIva, nView )

   local oDlg
   local oBrw
   local nOrd
   local oGet1
   local cGet1
   local oCbxOrd
   local cCbxOrd
   local aCbxOrd

   aCbxOrd        := { "Número", "Fecha", "Cliente", "Nombre" }
   nOrd           := GetBrwOpt( "BrwFacCli" )
   nOrd           := Min( Max( nOrd, 1 ), len( aCbxOrd ) )
   cCbxOrd        := aCbxOrd[ nOrd ]

   D():getStatusFacturasClientes( nView )

   DEFINE DIALOG oDlg RESOURCE "HELPENTRY" TITLE "Facturas de clientes"

      REDEFINE GET oGet1 VAR cGet1;
         ID       104 ;
         ON CHANGE( AutoSeek( nKey, nFlags, Self, oBrw, D():FacturasClientes( nView ), nil, nil, .f. ) );
         VALID    ( OrdClearScope( oBrw, D():FacturasClientes( nView ) ) );
         BITMAP   "FIND" ;
         OF       oDlg

      REDEFINE COMBOBOX oCbxOrd ;
         VAR      cCbxOrd ;
         ID       102 ;
         ITEMS    aCbxOrd ;
         ON CHANGE( ( D():FacturasClientes( nView ) )->( OrdSetFocus( oCbxOrd:nAt ) ), oBrw:refresh(), oGet1:SetFocus() ) ;
         OF       oDlg

      oBrw                 := IXBrowse():New( oDlg )

      oBrw:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrw:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrw:cAlias          := D():FacturasClientes( nView )
      oBrw:nMarqueeStyle   := 5
      oBrw:cName           := "Factura de cliente.Browse"

      oBrw:bLDblClick      := {|| oDlg:end( IDOK ) }

      oBrw:CreateFromResource( 105 )

      with object ( oBrw:AddCol() )
         :cHeader          := "Número"
         :cSortOrder       := "nNumFac"
         :bEditValue       := {|| ( D():FacturasClientes( nView ) )->cSerie + "/" + RTrim( str( ( D():FacturasClientes( nView ) )->nNumFac ) ) }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Delegación"
         :bEditValue       := {|| ( D():FacturasClientes( nView ) )->cSufFac }
         :nWidth           := 40
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Fecha"
         :cSortOrder       := "dFecFac"
         :bEditValue       := {|| Dtoc( ( D():FacturasClientes( nView ) )->dFecFac ) }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Cliente"
         :cSortOrder       := "cCodCli"
         :bEditValue       := {|| Rtrim( ( D():FacturasClientes( nView ) )->cCodCli ) }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Nombre"
         :cSortOrder       := "cNomCli"
         :bEditValue       := {|| Rtrim( ( D():FacturasClientes( nView ) )->cNomCli ) }
         :nWidth           := 300
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Total"
         :bEditValue       := {|| Trans( ( D():FacturasClientes( nView ) )->nTotFac, cPorDiv() ) }
         :nWidth           := 100
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
         :cSortOrder       := "nTotFac"
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
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

      oGet:cText( ( D():FacturasClientes( nView ) )->cSerie + str( ( D():FacturasClientes( nView ) )->nNumFac ) + ( D():FacturasClientes( nView ) )->cSufFac )

      oGet:bWhen   := {|| .f. }

      if !empty( oIva )
         oIva:Click( ( D():FacturasClientes( nView ) )->lIvaInc ):Refresh()
      end if

   end if

   SetBrwOpt( "BrwFacCli", ( D():FacturasClientes( nView ) )->( OrdNumber() ) )

   D():setStatusFacturasClientes( nView )

   oBrw:CloseData()

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

Function AppFacCli( cCodCli, cCodArt, lOpenBrowse )

   local nLevel         := nLevelUsr( _MENUITEM_ )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) != 0 .or. nAnd( nLevel, ACC_APPD ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if lOpenBrowse

      if FactCli( nil, nil, cCodCli, cCodArt )
         oWndBrw:RecAdd()
      end if

   else

      if OpenFiles( .t. )
         nTotFacCli()
         WinAppRec( nil, bEdtRec, D():FacturasClientes( nView ), cCodCli, cCodArt )
         CloseFiles()
      end if

   end if

RETURN .t.

//---------------------------------------------------------------------------//

Function EdtFacCli( cNumFac, lOpenBrowse )

   local nLevel         := nLevelUsr( _MENUITEM_ )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) != 0 .or. nAnd( nLevel, ACC_EDIT ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if lOpenBrowse

      if FactCli()
         if dbSeekInOrd( cNumFac, "nNumFac", D():FacturasClientes( nView ) )
            oWndBrw:RecEdit()
         else
            MsgStop( "No se encuentra factura" )
         end if
      end if

   else

      if OpenFiles( .t. )

         if dbSeekInOrd( cNumFac, "nNumFac", D():FacturasClientes( nView ) )
            nTotFacCli()
            WinEdtRec( nil, bEdtRec, D():FacturasClientes( nView ) )
         end if

         CloseFiles()

      end if

   end if

Return .t.

//----------------------------------------------------------------------------//

FUNCTION ZooFacCli( cNumFac, lOpenBrowse )

   local nLevel         := nLevelUsr( _MENUITEM_ )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) != 0 .or. nAnd( nLevel, ACC_ZOOM ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if lOpenBrowse

      if FactCli()
         if dbSeekInOrd( cNumFac, "nNumFac", D():FacturasClientes( nView ) )
            oWndBrw:RecZoom()
         else
            MsgStop( "No se encuentra factura" )
         end if
      end if

   else

      if OpenFiles( .t. )
         if dbSeekInOrd( cNumFac, "nNumFac", D():FacturasClientes( nView ) )
            nTotFacCli()
            WinZooRec( nil, bEdtRec, D():FacturasClientes( nView ) )
         end if
         CloseFiles()
      end if

   end if

Return .t.

//----------------------------------------------------------------------------//

FUNCTION DelFacCli( cNumFac, lOpenBrowse )

   local nLevel         := nLevelUsr( _MENUITEM_ )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) != 0 .or. nAnd( nLevel, ACC_DELE ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if lOpenBrowse

      if FactCli()
         if dbSeekInOrd( cNumFac, "nNumFac", D():FacturasClientes( nView ) )
            WinDelRec( nil, D():FacturasClientes( nView ), {|| QuiFacCli() } )
         else
            MsgStop( "No se encuentra factura" )
         end if
      end if

   else

      if OpenFiles( .t. )

         if dbSeekInOrd( cNumFac, "nNumFac", D():FacturasClientes( nView ) )
            nTotFacCli()
            WinDelRec( nil, D():FacturasClientes( nView ), {|| QuiFacCli() } )
         end if

         CloseFiles()

      end if

   end if

Return .t.

//----------------------------------------------------------------------------//

FUNCTION PrnFacCli( cNumFac, lOpenBrowse, cCaption, cFormato, cPrinter )

   local nLevel         := nLevelUsr( _MENUITEM_ )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) != 0 .or. nAnd( nLevel, ACC_IMPR ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if lOpenBrowse

      if FactCli()
         if dbSeekInOrd( cNumFac, "nNumFac", D():FacturasClientes( nView ) )
            ImprimirSeriesFacturas( IS_PRINTER, .t. )
            //GenFacCli( IS_PRINTER, cCaption, cFormato, cPrinter )
         else
            MsgStop( "No se encuentra factura" )
         end if
      end if

   else

      if OpenFiles( .t. )

         if dbSeekInOrd( cNumFac, "nNumFac", D():FacturasClientes( nView ) )
            ImprimirSeriesFacturas( IS_PRINTER, .t. )
            //GenFacCli( IS_PRINTER, cCaption, cFormato, cPrinter )
         end if

         CloseFiles()

      end if

   end if

Return .t.

//---------------------------------------------------------------------------//

FUNCTION VisFacCli( cNumFac, lOpenBrowse, cCaption, cFormato, cPrinter )

   local nLevel         := nLevelUsr( _MENUITEM_ )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) != 0 .or. nAnd( nLevel, ACC_IMPR ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if lOpenBrowse

      if FactCli()
         if dbSeekInOrd( cNumFac, "nNumFac", D():FacturasClientes( nView ) )
            ImprimirSeriesFacturas( IS_SCREEN, .t. )
            //GenFacCli( IS_SCREEN, cCaption, cFormato, cPrinter )
         else
            MsgStop( "No se encuentra factura" )
         end if
      end if

   else

      if OpenFiles( .t. )

         if dbSeekInOrd( cNumFac, "nNumFac", D():FacturasClientes( nView ) )
            ImprimirSeriesFacturas( IS_SCREEN, .t. )
            //GenFacCli( IS_SCREEN, cCaption, cFormato, cPrinter )
         end if

         CloseFiles()

      end if

   end if

Return .t.

//---------------------------------------------------------------------------//

Function ExcelIsra()

   local n
   local dFecFac     := ""
   local nNumFac     := ""
   local nImpFac     := 0
   local oOleExcel
   local cFileExcel  := cGetFile( "Excel ( *.Xls ) | " + "*.Xls", "Seleccione la hoja de calculo" )

   if File( cFileExcel )

      CreateWaitMeter( "Importando de Excel", "Hoja para Servital", 365 )

      oOleExcel      := CreateObject( "Excel.Application" )

      oOleExcel:Visible       := .f.
      oOleExcel:DisplayAlerts := .f.
      oOleExcel:WorkBooks:Open( cFileExcel )

      oOleExcel:WorkSheets( 1 ):Activate()

      for n := 1 to 365

         dFecFac  := oOleExcel:ActiveSheet:Range( "A" + lTrim( str( n ) ) ):Text
         dFecFac  := Ctod( dFecFac )
         nNumFac  := oOleExcel:ActiveSheet:Range( "B" + lTrim( str( n ) ) ):Text
         nNumFac  := Val( nNumFac )
         nImpFac  := oOleExcel:ActiveSheet:Range( "C" + lTrim( str( n ) ) ):Value

         if !empty( nNumFac )

            if dbAppe( D():FacturasClientes( nView ) )
               ( D():FacturasClientes( nView ) )->cSerie     := "A"
               ( D():FacturasClientes( nView ) )->nNumFac    := nNumFac
               ( D():FacturasClientes( nView ) )->cSufFac    := RetSufEmp()
               ( D():FacturasClientes( nView ) )->lLiquidada := .t.
               ( D():FacturasClientes( nView ) )->dFecFac    := dFecFac
               ( D():FacturasClientes( nView ) )->cCodAlm    := oUser():cAlmacen()
               ( D():FacturasClientes( nView ) )->cCodCaj    := oUser():cCaja()
               ( D():FacturasClientes( nView ) )->cCodPago   := cDefFpg()
               ( D():FacturasClientes( nView ) )->cDivFac    := cDivEmp()
               ( D():FacturasClientes( nView ) )->nVdvFac    := nChgDiv( cDivEmp(), dbfDiv )
               ( D():FacturasClientes( nView ) )->cCodUsr    := cCurUsr()
               ( D():FacturasClientes( nView ) )->cTurFac    := cCurSesion()
               ( D():FacturasClientes( nView ) )->( dbUnLock() )
            end if

            if dbAppe( D():FacturasClientesLineas( nView ) )
               ( D():FacturasClientesLineas( nView ) )->cSerie     := "A"
               ( D():FacturasClientesLineas( nView ) )->nNumFac    := nNumFac
               ( D():FacturasClientesLineas( nView ) )->cSufFac    := RetSufEmp()
               ( D():FacturasClientesLineas( nView ) )->nUniCaja   := 1
               ( D():FacturasClientesLineas( nView ) )->nPreUnit   := nImpFac
               ( D():FacturasClientesLineas( nView ) )->( dbUnLock() )
            end if

            if dbAppe( D():FacturasClientesCobros( nView ) )
               ( D():FacturasClientesCobros( nView ) )->cSerie     := "A"
               ( D():FacturasClientesCobros( nView ) )->nNumFac    := nNumFac
               ( D():FacturasClientesCobros( nView ) )->cSufFac    := RetSufEmp()
               ( D():FacturasClientesCobros( nView ) )->nNumRec    := 1
               ( D():FacturasClientesCobros( nView ) )->lCobrado   := .t.
               ( D():FacturasClientesCobros( nView ) )->nImporte   := nImpFac
               ( D():FacturasClientesCobros( nView ) )->nImpCob    := nImpFac
               ( D():FacturasClientesCobros( nView ) )->cDescrip   := "Recibo n. 1 de factura A/" + AllTrim( str( nNumFac ) ) + "/" + RetSufEmp()
               ( D():FacturasClientesCobros( nView ) )->cDivPgo    := cDivEmp()
               ( D():FacturasClientesCobros( nView ) )->nVdvPgo    := nChgDiv( cDivEmp(), dbfDiv )
               ( D():FacturasClientesCobros( nView ) )->dEntrada   := dFecFac
               ( D():FacturasClientesCobros( nView ) )->dPreCob    := dFecFac
               ( D():FacturasClientesCobros( nView ) )->( dbUnLock() )
            end if

         end if

         RefreshWaitMeter( n )

      next

      oOleExcel:DisplayAlerts := .t.
      oOleExcel:Quit()

      EndWaitMeter()

   end if

Return nil

//---------------------------------------------------------------------------//

Function NewLineReport( oReport )

   oReport:NewLine()

Return ( "" )

//----------------------------------------------------------------------------//

function SynFacCli( cPath )

   local oBlock
   local oError
   local nOrdAnt
   local cCodFam
   local aTotFac
   local cCodTip
   local cCodImp
   local cNumSer
   local aNumSer
   local cNumPed 
   local aNumPed        := {}
   local nPorCabecera   := 0

   DEFAULT cPath        := cPatEmp()

   oBlock               := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   FacturasClientesModel():defaultSufijo()

   if OpenFiles()

      // Cabeceras ------------------------------------------------------------

      ( D():FacturasClientes( nView ) )->( OrdSetFocus( 0 ) )
      ( D():FacturasClientes( nView ) )->( dbGoTop() )

      while !( D():FacturasClientes( nView ) )->( eof() )

         if !empty( ( D():FacturasClientes( nView ) )->cNumPre ) .and. Len( AllTrim( ( D():FacturasClientes( nView ) )->cNumPre ) ) != 12
            if ( D():FacturasClientes( nView ) )->( dbRLock() )
               ( D():FacturasClientes( nView ) )->cNumPre := AllTrim( ( D():FacturasClientes( nView ) )->cNumPre ) + "00"
               ( D():FacturasClientes( nView ) )->( dbUnLock() )
            end if 
         end if

         if !empty( ( D():FacturasClientes( nView ) )->cNumPed ) .and. Len( AllTrim( ( D():FacturasClientes( nView ) )->cNumPed ) ) != 12
            if ( D():FacturasClientes( nView ) )->( dbRLock() )
               ( D():FacturasClientes( nView ) )->cNumPed := AllTrim( ( D():FacturasClientes( nView ) )->cNumPed ) + "00"
               ( D():FacturasClientes( nView ) )->( dbUnLock() )
            end if
         end if

         if !empty( ( D():FacturasClientes( nView ) )->cNumAlb ) .and. Len( AllTrim( ( D():FacturasClientes( nView ) )->cNumAlb ) ) != 12
            if ( D():FacturasClientes( nView ) )->( dbRLock() )
               ( D():FacturasClientes( nView ) )->cNumAlb := AllTrim( ( D():FacturasClientes( nView ) )->cNumAlb ) + "00"
               ( D():FacturasClientes( nView ) )->( dbUnLock() )
            end if
         end if

         if !empty( ( D():FacturasClientes( nView ) )->cNumSat ) .and. Len( AllTrim( ( D():FacturasClientes( nView ) )->cNumSat ) ) != 12
            if ( D():FacturasClientes( nView ) )->( dbRLock() )
               ( D():FacturasClientes( nView ) )->cNumSat := AllTrim( ( D():FacturasClientes( nView ) )->cNumSat ) + "00"
               ( D():FacturasClientes( nView ) )->( dbUnLock() )
            end if
         end if

         if !empty( ( D():FacturasClientes( nView ) )->cNumDoc ) .and. Len( AllTrim( ( D():FacturasClientes( nView ) )->cNumDoc ) ) != 13
            if ( D():FacturasClientes( nView ) )->( dbRLock() )
               ( D():FacturasClientes( nView ) )->cNumDoc := AllTrim( ( D():FacturasClientes( nView ) )->cNumDoc ) + "00"
               ( D():FacturasClientes( nView ) )->( dbUnLock() )
            end if
         end if

         if !empty( ( D():FacturasClientes( nView ) )->cFacPrv ) .and. Len( AllTrim( ( D():FacturasClientes( nView ) )->cFacPrv ) ) != 12
            if ( D():FacturasClientes( nView ) )->( dbRLock() )
               ( D():FacturasClientes( nView ) )->cFacPrv := AllTrim( ( D():FacturasClientes( nView ) )->cFacPrv ) + "00"
               ( D():FacturasClientes( nView ) )->( dbUnLock() )
            end if
         end if

         if empty( ( D():FacturasClientes( nView ) )->cCodCaj )
            if ( D():FacturasClientes( nView ) )->( dbRLock() )
               ( D():FacturasClientes( nView ) )->cCodCaj := "000"
               ( D():FacturasClientes( nView ) )->( dbUnLock() )
            end if
         end if

         if empty( ( D():FacturasClientes( nView ) )->cNomCli ) .and. !empty ( ( D():FacturasClientes( nView ) )->cCodCli )
            if ( D():FacturasClientes( nView ) )->( dbRLock() )
               ( D():FacturasClientes( nView ) )->cNomCli := RetFld( ( D():FacturasClientes( nView ) )->cCodCli, D():Clientes( nView ), "Titulo" )
               ( D():FacturasClientes( nView ) )->( dbUnLock() )
            end if 
         end if

         /*
         Esto es para la Jaca para que todas las facturas tengan las comisiones de agente bien-------------------------------------
         */

         if !empty( ( D():FacturasClientes( nView ) )->cCodAge )

            if ( D():FacturasClientes( nView ) )->( dbRLock() )
               ( D():FacturasClientes( nView ) )->nPctComAge := RetFld( ( D():FacturasClientes( nView ) )->cCodAge, D():Agentes( nView ), "nCom1" )
               ( D():FacturasClientes( nView ) )->( dbUnLock() )
            end if

         end if

         /*
         GUID localizadores universales para el registo------------------------
         */
        
         if empty( ( D():FacturasClientes( nView ) )->cGuid ) .and. ( D():FacturasClientes( nView ) )->( dbRLock() )
            ( D():FacturasClientes( nView ) )->cGuid  := win_uuidcreatestring()
            ( D():FacturasClientes( nView ) )->( dbUnLock() )
         end if

         if !empty( ( D():FacturasClientes( nView ) )->cNumPed )
            aAdd( aNumPed, ( D():FacturasClientes( nView ) )->cNumPed )
         end if

         ( D():FacturasClientes( nView ) )->( dbSkip() )

      end while

      ( D():FacturasClientes( nView ) )->( OrdSetFocus( 1 ) )

      // Pagos ----------------------------------------------------------------

      ( D():FacturasClientesCobros( nView ) )->( OrdSetFocus( 0 ) )
      ( D():FacturasClientesCobros( nView ) )->( dbGoTop() )

      while !( D():FacturasClientesCobros( nView ) )->( eof() )

         if empty( ( D():FacturasClientesCobros( nView ) )->cSufFac )
            if ( D():FacturasClientesCobros( nView ) )->( dbRLock() )
               ( D():FacturasClientesCobros( nView ) )->cSufFac := "00"
               ( D():FacturasClientesCobros( nView ) )->( dbUnLock() )
            end if
         end if

         if empty( ( D():FacturasClientesCobros( nView ) )->cCodCaj )
            if ( D():FacturasClientesCobros( nView ) )->( dbRLock() )
               ( D():FacturasClientesCobros( nView ) )->cCodCaj := "000"
               ( D():FacturasClientesCobros( nView ) )->( dbUnLock() )
            end if
         end if

         ( D():FacturasClientesCobros( nView ) )->( dbSkip() )

      end while

      ( D():FacturasClientesCobros( nView ) )->( OrdSetFocus( "fNumFac" ) )

      // Lineas ---------------------------------------------------------------

      ( D():FacturasClientesLineas( nView ) )->( OrdSetFocus( 0 ) )
      ( D():FacturasClientesLineas( nView ) )->( dbGoTop() )

      while !( D():FacturasClientesLineas( nView ) )->( eof() )

         if empty( ( D():FacturasClientesLineas( nView ) )->cSufFac )
            if ( D():FacturasClientesLineas( nView ) )->( dbRLock() )
               ( D():FacturasClientesLineas( nView ) )->cSufFac    := "00"
               ( D():FacturasClientesLineas( nView ) )->( dbUnLock() )
            end if
         end if

         if !empty( ( D():FacturasClientesLineas( nView ) )->cNumPed ) .and. Len( AllTrim( ( D():FacturasClientesLineas( nView ) )->cNumPed ) ) != 12
            if ( D():FacturasClientesLineas( nView ) )->( dbRLock() )
               ( D():FacturasClientesLineas( nView ) )->cNumPed := AllTrim( ( D():FacturasClientesLineas( nView ) )->cNumPed ) + "00"
               ( D():FacturasClientesLineas( nView ) )->( dbUnLock() )
            end if
         end if

         if !empty( ( D():FacturasClientesLineas( nView ) )->cCodAlb ) .and. Len( AllTrim( ( D():FacturasClientesLineas( nView ) )->cCodAlb ) ) != 12
            if ( D():FacturasClientesLineas( nView ) )->( dbRLock() )
               ( D():FacturasClientesLineas( nView ) )->cCodAlb := AllTrim( ( D():FacturasClientesLineas( nView ) )->cCodAlb ) + "00"
               ( D():FacturasClientesLineas( nView ) )->( dbUnLock() )
            end if
         end if

         //en el caso de TuRueda,se han rellenado los importes de la ecotasa a Facturas atiguos, que ya la tenian
         /*
         if !empty( ( D():FacturasClientesLineas( nView ) )->cRef ) .and. empty( ( D():FacturasClientesLineas( nView ) )->nValImp )
            cCodImp                    := RetFld( ( D():FacturasClientesLineas( nView ) )->cRef, D():Articulos( nView ), "cCodImp" )
            if !empty( cCodImp )
               if ( D():FacturasClientesLineas( nView ) )->( dbRLock() )
                    ( D():FacturasClientesLineas( nView ) )->nValImp := oNewImp:nValImp( cCodImp )
                    ( D():FacturasClientesLineas( nView ) )->( dbUnLock() )
               end if
            end if
         end if
         */
         /*
         if empty( ( D():FacturasClientesLineas( nView ) )->cCodImp )
            if ( D():FacturasClientesLineas( nView ) )->( dbRLock() )
               ( D():FacturasClientesLineas( nView ) )->nValImp := 0
               ( D():FacturasClientesLineas( nView ) )->( dbUnLock() )
            end if
         end if
         */
         
         if !empty( ( D():FacturasClientesLineas( nView ) )->cRef ) .and. empty( ( D():FacturasClientesLineas( nView ) )->nVolumen )
            if ( D():FacturasClientesLineas( nView ) )->( dbRLock() )
               ( D():FacturasClientesLineas( nView ) )->nVolumen   := RetFld( ( D():FacturasClientesLineas( nView ) )->cRef, D():Articulos( nView ), "nVolumen" )
               ( D():FacturasClientesLineas( nView ) )->( dbUnLock() )
            end if
         end if

         if empty( ( D():FacturasClientesLineas( nView ) )->cLote ) .and. !empty( ( D():FacturasClientesLineas( nView ) )->nLote )
            if ( D():FacturasClientesLineas( nView ) )->( dbRLock() )
               ( D():FacturasClientesLineas( nView ) )->cLote      := AllTrim( str( ( D():FacturasClientesLineas( nView ) )->nLote ) )
               ( D():FacturasClientesLineas( nView ) )->( dbUnLock() )
            end if
         end if

         if ( D():FacturasClientesLineas( nView ) )->lIvaLin != ( D():FacturasClientes( nView ) )->lIvaInc
            if ( D():FacturasClientesLineas( nView ) )->( dbRLock() )
               ( D():FacturasClientesLineas( nView ) )->lIvaLin    := RetFld( ( D():FacturasClientesLineas( nView ) )->cSerie + str( ( D():FacturasClientesLineas( nView ) )->nNumFac ) + ( D():FacturasClientesLineas( nView ) )->cSufFac, D():FacturasClientes( nView ), "lIvaInc" )
               ( D():FacturasClientesLineas( nView ) )->( dbUnLock() )
            end if
         end if

         if !empty( ( D():FacturasClientesLineas( nView ) )->cRef ) .and. empty( ( D():FacturasClientesLineas( nView ) )->cCodFam )
            cCodFam                    := RetFamArt( ( D():FacturasClientesLineas( nView ) )->cRef, D():Articulos( nView ) )
            if !empty( cCodFam )
               if ( D():FacturasClientesLineas( nView ) )->( dbRLock() )
                  ( D():FacturasClientesLineas( nView ) )->cCodFam := cCodFam
                  ( D():FacturasClientesLineas( nView ) )->( dbUnLock() )
               end if
            end if
         end if

         if !empty( ( D():FacturasClientesLineas( nView ) )->cRef ) .and. empty( ( D():FacturasClientesLineas( nView ) )->cCodTip )
            cCodTip                    := RetFld( ( D():FacturasClientesLineas( nView ) )->cRef, D():Articulos( nView ), "cCodTip" )
            if !empty( cCodTip )
               if ( D():FacturasClientesLineas( nView ) )->( dbRLock() )
                  ( D():FacturasClientesLineas( nView ) )->cCodTip := cCodTip
                  ( D():FacturasClientesLineas( nView ) )->( dbUnLock() )
               end if
            end if
         end if

         if !empty( ( D():FacturasClientesLineas( nView ) )->cRef ) .and. !empty( ( D():FacturasClientesLineas( nView ) )->cCodFam )
            cCodFam                    := cGruFam( ( D():FacturasClientesLineas( nView ) )->cCodFam, dbfFamilia )
            if !empty( cCodFam )
               if ( D():FacturasClientesLineas( nView ) )->( dbRLock() )
                    ( D():FacturasClientesLineas( nView ) )->cGrpFam := cCodFam
                    ( D():FacturasClientesLineas( nView ) )->( dbUnLock() )
               end if
            end if
         end if

         if empty( ( D():FacturasClientesLineas( nView ) )->nReq )
            if ( D():FacturasClientesLineas( nView ) )->( dbRLock() )
               ( D():FacturasClientesLineas( nView ) )->nReq       := nPReq( dbfIva, ( D():FacturasClientesLineas( nView ) )->nIva )
               ( D():FacturasClientesLineas( nView ) )->( dbUnLock() )
            end if
         end if

         if empty( ( D():FacturasClientesLineas( nView ) )->cCodAge )
            if ( D():FacturasClientesLineas( nView ) )->( dbRLock() )
               ( D():FacturasClientesLineas( nView ) )->cCodAge    := RetFld( ( D():FacturasClientesLineas( nView ) )->cSerie + str( ( D():FacturasClientesLineas( nView ) )->nNumFac ) + ( D():FacturasClientesLineas( nView ) )->cSufFac, D():FacturasClientes( nView ), "cCodAge" )
               ( D():FacturasClientesLineas( nView ) )->( dbUnLock() )
            end if
         end if

         if ( D():FacturasClientesLineas( nView ) )->nRegIva != RetFld( ( D():FacturasClientesLineas( nView ) )->cSerie + str( ( D():FacturasClientesLineas( nView ) )->nNumFac ) + ( D():FacturasClientesLineas( nView ) )->cSufFac, D():FacturasClientes( nView ), "nRegIva" )
            if ( D():FacturasClientesLineas( nView ) )->( dbRLock() )
               ( D():FacturasClientesLineas( nView ) )->nRegIva    := RetFld( ( D():FacturasClientesLineas( nView ) )->cSerie + str( ( D():FacturasClientesLineas( nView ) )->nNumFac ) + ( D():FacturasClientesLineas( nView ) )->cSufFac, D():FacturasClientes( nView ), "nRegIva" )
               ( D():FacturasClientesLineas( nView ) )->( dbUnLock() )
            end if
         end if

         /*
         Esto es para la jaca para que las líneas tengan la misma Comisión de agente que la cabecera
         */
         
         /*nPorCabecera      := RetFld( ( D():FacturasClientesLineas( nView ) )->cSerie + str( ( D():FacturasClientesLineas( nView ) )->nNumFac ) + ( D():FacturasClientesLineas( nView ) )->cSufFac, D():FacturasClientes( nView ), "nPctComAge" )

         if ( D():FacturasClientesLineas( nView ) )->nComAge != nPorCabecera
            if ( D():FacturasClientesLineas( nView ) )->( dbRLock() )
               ( D():FacturasClientesLineas( nView ) )->nComAge    := nPorCabecera
               ( D():FacturasClientesLineas( nView ) )->( dbUnLock() )
            end if
         end if*/

         // Valor de stock toma la fecha de los Facturas----------------------

         if !empty( ( D():FacturasClientesLineas( nView ) )->cCodAlb )
            if empty( ( D():FacturasClientesLineas( nView ) )->dFecFac )
               if ( D():FacturasClientesLineas( nView ) )->( dbRLock() )
                  ( D():FacturasClientesLineas( nView ) )->dFecFac    := retFld( ( D():FacturasClientesLineas( nView ) )->cCodAlb, dbfAlbCliL, "dFecAlb" )
                  ( D():FacturasClientesLineas( nView ) )->( dbUnLock() )
               end if
            end if
         end if

         if empty( ( D():FacturasClientesLineas( nView ) )->dFecFac )
            if ( D():FacturasClientesLineas( nView ) )->( dbRLock() )
               ( D():FacturasClientesLineas( nView ) )->dFecFac    := RetFld( ( D():FacturasClientesLineas( nView ) )->cSerie + str( ( D():FacturasClientesLineas( nView ) )->nNumFac ) + ( D():FacturasClientesLineas( nView ) )->cSufFac, D():FacturasClientes( nView ), "dFecFac" )
               ( D():FacturasClientesLineas( nView ) )->( dbUnLock() )
            end if
         end if

         if empty( ( D():FacturasClientesLineas( nView ) )->cCodCli )
            if ( D():FacturasClientesLineas( nView ) )->( dbRLock() )
               ( D():FacturasClientesLineas( nView ) )->cCodCli    := RetFld( ( D():FacturasClientesLineas( nView ) )->cSerie + str( ( D():FacturasClientesLineas( nView ) )->nNumFac ) + ( D():FacturasClientesLineas( nView ) )->cSufFac, D():FacturasClientes( nView ), "cCodCli" )
               ( D():FacturasClientesLineas( nView ) )->( dbUnLock() )
            end if
         end if

         if empty( ( D():FacturasClientesLineas( nView ) )->cAlmLin )
            if ( D():FacturasClientesLineas( nView ) )->( dbRLock() )
               ( D():FacturasClientesLineas( nView ) )->cAlmLin    := RetFld( ( D():FacturasClientesLineas( nView ) )->cSerie + str( ( D():FacturasClientesLineas( nView ) )->nNumFac ) + ( D():FacturasClientesLineas( nView ) )->cSufFac, D():FacturasClientes( nView ), "cCodAlm" )
               ( D():FacturasClientesLineas( nView ) )->( dbUnLock() )
            end if
         end if

         if !empty( ( D():FacturasClientesLineas( nView ) )->mNumSer )
            aNumSer                    := hb_aTokens( ( D():FacturasClientesLineas( nView ) )->mNumSer, "," )
            for each cNumSer in aNumSer
               ( dbfFacCliS )->( dbAppend() )
               ( dbfFacCliS )->cSerFac := ( D():FacturasClientesLineas( nView ) )->cSerie
               ( dbfFacCliS )->nNumFac := ( D():FacturasClientesLineas( nView ) )->nNumFac
               ( dbfFacCliS )->cSufFac := ( D():FacturasClientesLineas( nView ) )->cSufFac
               ( dbfFacCliS )->cRef    := ( D():FacturasClientesLineas( nView ) )->cRef
               ( dbfFacCliS )->cAlmLin := ( D():FacturasClientesLineas( nView ) )->cAlmLin
               ( dbfFacCliS )->nNumLin := ( D():FacturasClientesLineas( nView ) )->nNumLin
               ( dbfFacCliS )->cNumSer := cNumSer
            next
            if ( D():FacturasClientesLineas( nView ) )->( dbRLock() )
               ( D():FacturasClientesLineas( nView ) )->mNumSer    := ""
               ( D():FacturasClientesLineas( nView ) )->( dbUnLock() )
            end if
         end if

         //Cargamos el costo medio para marbarroso
         /*
         if !empty( ( D():FacturasClientesLineas( nView ) )->cRef ) .and. empty( ( D():FacturasClientesLineas( nView ) )->nCosDiv )
            if ( D():FacturasClientesLineas( nView ) )->( dbRLock() )
               ( D():FacturasClientesLineas( nView ) )->nCosDiv   := oStock:nCostoMedio( ( D():FacturasClientesLineas( nView ) )->cRef, ( D():FacturasClientesLineas( nView ) )->cAlmLin, ( D():FacturasClientesLineas( nView ) )->cCodPr1, ( D():FacturasClientesLineas( nView ) )->cCodPr2, ( D():FacturasClientesLineas( nView ) )->cValPr1, ( D():FacturasClientesLineas( nView ) )->cValPr2, ( D():FacturasClientesLineas( nView ) )->cLote )   
               ( D():FacturasClientesLineas( nView ) )->( dbUnLock() )              
            end if
         end if 
         */

         if empty( ( D():FacturasClientesLineas( nView ) )->nPosPrint )
            if ( D():FacturasClientesLineas( nView ) )->( dbRLock() )
               ( D():FacturasClientesLineas( nView ) )->nPosPrint    := ( D():FacturasClientesLineas( nView ) )->nNumLin
               ( D():FacturasClientesLineas( nView ) )->( dbUnLock() )
            end if
         end if         

         ( D():FacturasClientesLineas( nView ) )->( dbSkip() )

         SysRefresh()

      end while

      ( D():FacturasClientesLineas( nView ) )->( OrdSetFocus( 1 ) )

      // Incidencias ----------------------------------------------------------

      ( dbfFacCliI )->( OrdSetFocus( 0 ) )
      ( dbfFacCliI )->( dbGoTop() )

      while !( dbfFacCliI )->( eof() )

         if empty( ( dbfFacCliI )->cSufFac )
            if ( dbfFacCliI )->( dbRLock() )
               ( dbfFacCliI )->cSufFac := "00"
               ( dbfFacCliI )->( dbUnLock() )
            end if 
         end if

         ( dbfFacCliI )->( dbSkip() )

         SysRefresh()

      end while

      ( dbfFacCliI )->( OrdSetFocus( 1 ) )

      // Series ---------------------------------------------------------------

      ( dbfFacCliS )->( OrdSetFocus( 0 ) )
      ( dbfFacCliS )->( dbGoTop() )

      while !( dbfFacCliS )->( eof() )

         if empty( ( dbfFacCliS )->cSufFac )
            if ( dbfFacCliS )->( dbRLock() )
               ( dbfFacCliS )->cSufFac := "00"
               ( dbfFacCliS )->( dbUnLock() )
            end if 
         end if

         if empty( ( dbfFacCliS )->dFecFac )
            if ( dbfFacCliS )->( dbRLock() )
               ( dbfFacCliS )->dFecFac := RetFld( ( dbfFacCliS )->cSerFac + str( ( dbfFacCliS )->nNumFac ) + ( dbfFacCliS )->cSufFac, D():FacturasClientes( nView ), "dFecFac" )
               ( dbfFacCliS )->( dbUnLock() )
            end if 
         end if

         ( dbfFacCliS )->( dbSkip() )

         SysRefresh()

      end while

      ( dbfFacCliS )->( OrdSetFocus( 1 ) )

      /*
      Rellenamos los campos de totales-----------------------------------------
      */

      ( D():FacturasClientes( nView ) )->( dbGoTop() )
      while !( D():FacturasClientes( nView ) )->( eof() )

         aTotFac           := aTotFacCli( ( D():FacturasClientes( nView ) )->cSerie + str( ( D():FacturasClientes( nView ) )->nNumFac ) + ( D():FacturasClientes( nView ) )->cSufFac, D():FacturasClientes( nView ), D():FacturasClientesLineas( nView ), dbfIva, dbfDiv, D():FacturasClientesCobros( nView ), D():AnticiposClientes( nView ), ( D():FacturasClientes( nView ) )->cDivFac )

         //if ( D():FacturasClientes( nView ) )->nTotFac == 0
            if ( D():FacturasClientes( nView ) )->( dbRLock() )
              ( D():FacturasClientes( nView ) )->nTotNet := aTotFac[1]
              ( D():FacturasClientes( nView ) )->nTotIva := aTotFac[2]
              ( D():FacturasClientes( nView ) )->nTotReq := aTotFac[3]
              ( D():FacturasClientes( nView ) )->nTotFac := aTotFac[4]
              ( D():FacturasClientes( nView ) )->( dbUnLock() )
           end if 
         //end if

         if ( D():FacturasClientes( nView ) )->nTotLiq == 0
            if ( D():FacturasClientes( nView ) )->( dbRLock() )
              ( D():FacturasClientes( nView ) )->nTotLiq := aTotFac[13]
             ( D():FacturasClientes( nView ) )->nTotPdt := aTotFac[4] - aTotFac[13]
             ( D():FacturasClientes( nView ) )->( dbUnLock() )
          end if 
         end if

         ( D():FacturasClientes( nView ) )->( dbSkip() )

      end while

      // Purgamos los datos----------------------------------------------------
      
      ( D():FacturasClientesLineas( nView ) )->( dbGoTop() )
      while !( D():FacturasClientesLineas( nView ) )->( eof() )

         if !( D():FacturasClientes( nView ) )->( dbSeek( ( D():FacturasClientesLineas( nView ) )->cSerie + str( ( D():FacturasClientesLineas( nView ) )->nNumFac ) + ( D():FacturasClientesLineas( nView ) )->cSufFac ) )
            if ( D():FacturasClientesLineas( nView ) )->( dbRLock() )
               ( D():FacturasClientesLineas( nView ) )->( dbDelete() )
               ( D():FacturasClientesLineas( nView ) )->( dbRUnLock() )
            end if 
         end if

         ( D():FacturasClientesLineas( nView ) )->( dbSkip() )

      end while 

      ( dbfFacCliS )->( dbGoTop() )
      while !( dbfFacCliS )->( eof() )

         if !( D():FacturasClientes( nView ) )->( dbSeek( ( dbfFacCliS )->cSerFac + str( ( dbfFacCliS )->nNumFac ) + ( dbfFacCliS )->cSufFac ) )
            if ( dbfFacCliS )->( dbRLock() )
               ( dbfFacCliS )->( dbDelete() )
            ( dbfFacCliS )->( dbRUnLock() )
         end if 
         end if

         ( dbfFacCliS )->( dbSkip() )

         SysRefresh()

      end while

      ( dbfFacCliI )->( dbGoTop() )
      while !( dbfFacCliI )->( eof() )

         if !( D():FacturasClientes( nView ) )->( dbSeek( ( dbfFacCliI )->cSerie + str( ( dbfFacCliI )->nNumFac ) + ( dbfFacCliI )->cSufFac ) )
            if ( dbfFacCliI )->( dbRLock() )
               ( dbfFacCliI )->( dbDelete() )
               ( dbfFacCliI )->( dbRUnLock() )
            end if
         end if

         ( dbfFacCliI )->( dbSkip() )

         SysRefresh()

      end while

     /*
     Estado de los pedidos en stocks---------------------------------------------
     */

     if !empty( aNumPed )

        for each cNumPed in aNumPed
           oStock:SetEstadoPedCli( cNumPed )
        next 

     end if 

     // Cerramos los ficheros-------------------------------------------------

      CloseFiles()

   end if 
      
   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos de facturas de clientes." + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

Return nil

//---------------------------------------------------------------------------//

Function mailing( cTo,cSubject )

Return ( nil )

//---------------------------------------------------------------------------//

Function isLineaTotalFacCli( uFacCliL )

   if isArray( uFacCliL )
      Return ( uFacCliL[ _LTOTLIN ] )
   end if

Return ( ( uFacCliL )->lTotLin )

//---------------------------------------------------------------------------//

Function nDescuentoLinealFacCli( uFacCliL, nDec, nVdv )

   local nDescuentoLineal

   DEFAULT nVdv         := 1

   if isArray( uFacCliL )
      nDescuentoLineal  := uFacCliL[ _NDTODIV ]
   else 
      nDescuentoLineal  := ( uFacCliL )->nDtoDiv
   end if

Return ( Round( nDescuentoLineal / nVdv, nDec ) )

//---------------------------------------------------------------------------//

Function nDescuentoPorcentualFacCli( uFacCliL )

   local nDescuentoPorcentual

   if isArray( uFacCliL )
      nDescuentoPorcentual  := uFacCliL[ _NDTO ]
   else 
      nDescuentoPorcentual  := ( uFacCliL )->nDto
   end if

Return ( nDescuentoPorcentual )

//---------------------------------------------------------------------------//

Function nDescuentoPromocionFacCli( uFacCliL )

   local nDescuentoPromocion

   if isArray( uFacCliL )
      nDescuentoPromocion  := uFacCliL[ _NDTOPRM ]
   else 
      nDescuentoPromocion  := ( uFacCliL )->nDtoPrm
   end if

Return ( nDescuentoPromocion )

//---------------------------------------------------------------------------//

Function nPuntoVerdeFacCli( uFacCliL )

   local nPuntoVerde

   if isArray( uFacCliL )
      nPuntoVerde  := uFacCliL[ _NPNTVER ]
   else 
      nPuntoVerde  := ( uFacCliL )->nPntVer
   end if

Return ( nPuntoVerde )

//---------------------------------------------------------------------------//

Function nTransporteFacCli( uFacCliL )

   local nTransporte

   if isArray( uFacCliL )
      nTransporte  := uFacCliL[ _NIMPTRN ]
   else 
      nTransporte  := ( uFacCliL )->nImpTrn
   end if

Return ( nTransporte )

//---------------------------------------------------------------------------//

FUNCTION nTotLFacCli( uFacCliL, nDec, nRou, nVdv, lDto, lPntVer, lImpTrn, cPouDiv )

   local nCalculo
   local nUnidades

   DEFAULT uFacCliL     := D():FacturasClientesLineas( nView )
   DEFAULT nDec         := nDouDiv()
   DEFAULT nRou         := nRouDiv()
   DEFAULT nVdv         := 1
   DEFAULT lDto         := .t.
   DEFAULT lPntVer      := .f.
   DEFAULT lImpTrn      := .t.

   if isLineaTotalFacCli( uFacCliL )

      nCalculo          := nTotUFacCli( uFacCliL, nDec, nVdv )

   else

      nUnidades         := nTotNFacCli( uFacCliL )
      nCalculo          := nTotUFacCli( uFacCliL, nDec, nVdv ) * nUnidades

      /*
      Descuentos---------------------------------------------------------------
      */

      if lDto
         nCalculo       -= nDescuentoLinealFacCli( uFacCliL, nDec, nVdv ) * nUnidades
      end if 

      if lDto .and. nDescuentoPorcentualFacCli( uFacCliL ) != 0 
         nCalculo       -= nCalculo * nDescuentoPorcentualFacCli( uFacCliL ) / 100
      end if

      if lDto .and. nDescuentoPromocionFacCli( uFacCliL ) != 0 
         nCalculo       -= nCalculo * nDescuentoPromocionFacCli( uFacCliL ) / 100
      end if

      /*
      Punto Verde--------------------------------------------------------------
      */

      if lPntVer .and. nPuntoVerdeFacCli( uFacCliL ) != 0
         nCalculo       += nPuntoVerdeFacCli( uFacCliL ) * nUnidades
      end if

      /*
      Transporte---------------------------------------------------------------
      */

      if lImpTrn .and. nTransporteFacCli( uFacCliL ) != 0
         nCalculo       += nTransporteFacCli( uFacCliL ) * nUnidades
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

FUNCTION nTotUFacCli( uTmpLin, nDec, nVdv )

   local nCalculo       := 0

   DEFAULT uTmpLin      := D():FacturasClientesLineas( nView )
   DEFAULT nDec         := nDouDiv()
   DEFAULT nVdv         := 1

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

Function nNetUFacCli( dbfLin, nDec, nVdv )

   local nCalculo    := nTotUFacCli( dbfLin, nDec, nVdv )   

   if ( dbfLin )->nIva != 0 .and. ( dbfLin )->lIvaLin
      if nDec != nil
         nCalculo    -= Round( nCalculo / ( 100 / ( dbfLin )->nIva + 1 ), nDec )
      else
         nCalculo    -= ( nCalculo / ( 100 / ( dbfLin )->nIva + 1 ) )
      end if
   end if

RETURN ( nCalculo )

//---------------------------------------------------------------------------//

/*
Cambia el importe unitario de la linea
*/

FUNCTION SetUFacCli( dbfLin, nNewVal )

   DEFAULT dbfLin             := D():FacturasClientesLineas( nView )

   if ( dbfLin )->lAlquiler
      ( dbfLin )->nPreAlq     := nNewVal
   else
      ( dbfLin )->nPreUnit    := nNewVal
   end if

RETURN ( nil )

//---------------------------------------------------------------------------//
//
// Devuelve las unidades de una linea
//

FUNCTION nTotNFacCli( uDbf )

   local nTotUnd

   DEFAULT uDbf   := D():FacturasClientesLineas( nView )

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
         nTotUnd  *=( uDbf )->nUniCaja
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
         nTotUnd  *= uDbf:nUniCaja
         nTotUnd  *= NotCero( uDbf:nUndKit )
         nTotUnd  *= NotCero( uDbf:nMedUno )
         nTotUnd  *= NotCero( uDbf:nMedDos )
         nTotUnd  *= NotCero( uDbf:nMedTre )
      end if

   end case

Return ( nTotUnd )

//--------------------------------------------------------------------------//

function nTotVFacCli( uDbf )

   local nTotUnd

   DEFAULT uDbf   := D():FacturasClientesLineas( nView )

   do case
      case ValType( uDbf ) == "A"

         nTotUnd  := nTotNFacCli( uDbf ) * NotCero( uDbf[ _NFACCNV ] )

      case ValType( uDbf ) == "C"

         nTotUnd  := nTotNFacCli( uDbf ) * NotCero( ( uDbf )->nFacCnv )

      otherwise

         nTotUnd  := nTotNFacCli( uDbf ) * NotCero( uDbf:nFacCnv )

   end case

return ( nTotUnd )

//---------------------------------------------------------------------------//

FUNCTION IsFacCli( cPath )

   DEFAULT cPath  := cPatEmp()

   if !lExistTable( cPath + "FacCliT.Dbf" )
      dbCreate( cPath + "FacCliT.Dbf", aSqlStruct( aItmFacCli() ), cDriver() )
   end if

   if !lExistTable( cPath + "FacCliL.Dbf" )
      dbCreate( cPath + "FacCliL.Dbf", aSqlStruct( aColFacCli() ), cDriver() )
   end if

   if !lExistTable( cPath + "FacCliI.Dbf" )
      dbCreate( cPath + "FacCliI.Dbf", aSqlStruct( aIncFacCli() ), cDriver() )
   end if

   if !lExistTable( cPath + "FacCliD.Dbf" )
      dbCreate( cPath + "FacCliD.Dbf", aSqlStruct( aFacCliDoc() ), cDriver() )
   end if

   if !lExistIndex( cPath + "FacCliT.Cdx" ) .or. ;
      !lExistIndex( cPath + "FacCliT.Cdx" ) .or. ;
      !lExistIndex( cPath + "FacCliI.Cdx" ) .or. ;
      !lExistTable( cPath + "FacCliD.Cdx" )

      rxFacCli( cPath )

   end if

Return ( .t. )

//---------------------------------------------------------------------------//

/*
Crea las bases de datos necesarias para la facturaci-n desde fuera
*/

FUNCTION mkFacCli( cPath, oMeter, lReindex )

   DEFAULT lReindex  := .t.

   if oMeter != nil
      oMeter:cText   := "Generando Bases"
      sysrefresh()
   end if

   if !lExistTable( cPath + "FACCLIT.DBF", cLocalDriver() )
      dbCreate( cPath + "FACCLIT.DBF", aSqlStruct( aItmFacCli() ), cLocalDriver() )
   end if

   if !lExistTable( cPath + "FACCLIL.DBF", cLocalDriver() )
      dbCreate( cPath + "FACCLIL.DBF", aSqlStruct( aColFacCli() ), cLocalDriver() )
   end if

   if !lExistTable( cPath + "FACCLII.DBF", cLocalDriver() )
      dbCreate( cPath + "FACCLII.DBF", aSqlStruct( aIncFacCli() ), cLocalDriver() )
   end if

   if !lExistTable( cPath + "FACCLID.DBF", cLocalDriver() )
      dbCreate( cPath + "FACCLID.DBF", aSqlStruct( aFacCliDoc() ), cLocalDriver() )
   end if

   if !lExistTable( cPath + "FACCLIS.DBF", cLocalDriver() )
      dbCreate( cPath + "FACCLIS.DBF", aSqlStruct( aSerFacCli() ), cLocalDriver() )
   end if

   if !lExistTable( cPath + "FACCLIE.DBF", cLocalDriver() )
      dbCreate( cPath + "FACCLIE.DBF", aSqlStruct( aEntidadesFacCli() ), cLocalDriver() )
   end if

   if !lExistTable( cPath + "FACCLIC.Dbf", cLocalDriver() )
      dbCreate( cPath + "FACCLIC.Dbf", aSqlStruct( aFacCliEst() ), cLocalDriver() )
   end if

   if lReindex
      rxFacCli( cPath, cLocalDriver() )
   end if

RETURN .t.

//---------------------------------------------------------------------------//
/*
Regenera indices
*/

FUNCTION rxFacCli( cPath, cDriver )

   local cFacCliT
   local cFacCliL
   local dbfFacCliI
   local dbfFacCliD

   DEFAULT cPath     := cPatEmp()
   DEFAULT cDriver   := cDriver()

   /*
   Crea los ficheros si no existen
   */

   if !lExistTable( cPath + "FacCliT.Dbf", cDriver )   .or.;
      !lExistTable( cPath + "FacCliL.Dbf", cDriver )   .or.;
      !lExistTable( cPath + "FacCliI.Dbf", cDriver )   .or.;
      !lExistTable( cPath + "FacCliD.Dbf", cDriver )   .or.;
      !lExistTable( cPath + "FacCliS.Dbf", cDriver )   .or.;
      !lExistTable( cPath + "FacCliE.Dbf", cDriver )   .or.;
      !lExistTable( cPath + "FacCliC.Dbf", cDriver )  
      mkFacCli( cPath, nil, .f. )
   end if

   fEraseIndex( cPath + "FacCliT.Cdx", cDriver )
   fEraseIndex( cPath + "FacCliT.Cdx", cDriver )
   fEraseIndex( cPath + "FacCliI.Cdx", cDriver )
   fEraseIndex( cPath + "FacCliD.Cdx", cDriver )
   fEraseIndex( cPath + "FacCliS.Cdx", cDriver )
   fEraseIndex( cPath + "FacCliE.Cdx", cDriver )
   fEraseIndex( cPath + "FacCliC.Cdx", cDriver )

   dbUseArea( .t., cDriver, cPath + "FACCLIL.DBF", cCheckArea( "FACCLIL", @cFacCliL ), .f. )
   if !( cFacCliL )->( neterr() )
      ( cFacCliL )->( __dbPack() )

      ( cFacCliL )->( ordCondSet("!Deleted()", {|| !Deleted() } ) )
      ( cFacCliL )->( ordCreate( cPath + "FacCliL.Cdx", "nNumFac", "cSerie + str( nNumFac ) + cSufFac", {|| Field->cSerie + str( Field->nNumFac ) + Field->cSufFac } ) )

      ( cFacCliL )->( ordCondSet("!Deleted()", {|| !Deleted() } ) )
      ( cFacCliL )->( ordCreate( cPath + "FacCliL.Cdx", "cRef", "cRef", {|| Field->cRef }, ) )

      ( cFacCliL )->( ordCondSet("!Deleted()", {|| !Deleted() } ) )
      ( cFacCliL )->( ordCreate( cPath + "FacCliL.Cdx", "Lote", "cLote", {|| Field->cLote }, ) )

      ( cFacCliL )->( ordCondSet("!Deleted()", {|| !Deleted() } ) )
      ( cFacCliL )->( ordCreate( cPath + "FacCliL.Cdx", "cCodAlb", "cCodAlb", {|| Field->cCodAlb }, ) )

      ( cFacCliL )->( ordCondSet("!Deleted()", {|| !Deleted() } ) )
      ( cFacCliL )->( ordCreate( cPath + "FacCliL.Cdx", "cNumRef", "cSerie + str( nNumFac ) + cSufFac + cRef", {|| Field->cSerie + str( Field->nNumFac ) + Field->cSufFac + Field->cRef } ) )

      ( cFacCliL )->( ordCondSet("!Deleted()", {|| !Deleted() } ) )
      ( cFacCliL )->( ordCreate( cPath + "FacCliL.Cdx", "cNumPedRef", "cNumPed + cRef + cValPr1 + cValPr2", {|| Field->cNumPed + Field->cRef + Field->cValPr1 + Field->cValPr2 } ) )

      ( cFacCliL )->( ordCondSet("!Deleted()", {|| !Deleted() } ) )
      ( cFacCliL )->( ordCreate( cPath + "FacCliL.Cdx", "cNumPed", "cNumPed", {|| Field->cNumPed } ) )

      ( cFacCliL)->( ordCondSet( "!Deleted()", {|| !Deleted() }  ) )
      ( cFacCliL )->( ordCreate( cPath + "FacCliL.Cdx", "iNumFac", "'11' + cSerie + str( nNumFac ) + Space( 1 ) + cSufFac + Str( nNumLin )", {|| '11' + Field->cSerie + str( Field->nNumFac ) + Space( 1 ) + Field->cSufFac + Str( Field->nNumLin ) } ) )

      ( cFacCliL )->( ordCondSet( "!Deleted()", {|| !Deleted() }, , , , , , , , , .t. ) )
      ( cFacCliL )->( ordCreate( cPath + "FacCliL.Cdx", "cRefFec", "cRef + cCodCli + dtos( dFecFac ) + tFecFac", {|| Field->cRef + Field->cCodCli + dtos( Field->dFecFac ) + Field->tFecFac } ) )

      ( cFacCliL )->( ordCondSet( "nCtlStk < 2 .and. !Deleted()", {|| Field->nCtlStk < 2 .and. !Deleted() }, , , , , , , , , .t. ) )
      ( cFacCliL )->( ordCreate( cPath + "FacCliL.Cdx", "cStkFast", "cRef + cAlmLin + dtos( dFecFac ) + tFecFac", {|| Field->cRef + Field->cAlmLin + dtos( Field->dFecFac ) + Field->tFecFac } ) )

      ( cFacCliL )->( ordCondSet( "!Deleted()", {|| !Deleted() }  ) )
      ( cFacCliL )->( ordCreate( cPath + "FacCliL.Cdx", "cCtrCoste", "cCtrCoste", {|| Field->cCtrCoste } ) )

      ( cFacCliL )->( ordCondSet("!Deleted()", {|| !Deleted() } ) )
      ( cFacCliL )->( ordCreate( cPath + "FacCliL.Cdx", "RefAux", "cSerie + str( nNumFac ) + cSufFac + cRefAux", {|| Field->cSerie + str( Field->nNumFac ) + Field->cSufFac + Field->cRefAux } ) )

      ( cFacCliL )->( ordCondSet("!Deleted()", {|| !Deleted() } ) )
      ( cFacCliL )->( ordCreate( cPath + "FacCliL.Cdx", "nNumLin", "cSerie + str( nNumFac ) + cSufFac + str( nNumLin )", {|| Field->cSerie + str( Field->nNumFac ) + Field->cSufFac + str( Field->nNumLin ) } ) )

      ( cFacCliL )->( ordCondSet("!Deleted()", {|| !Deleted() } ) )
      ( cFacCliL )->( ordCreate( cPath + "FacCliL.Cdx", "nPosPrint", "cSerie + str( nNumFac ) + cSufFac + Str( nPosPrint )", {|| Field->cSerie + str( Field->nNumFac ) + Field->cSufFac + str( Field->nPosPrint ) } ) )

      ( cFacCliL )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( cFacCliL )->( ordCreate( cPath + "FacCliL.Cdx", "cVtaFast", "cRef + cAlmLin + dtos( dFecFac )", {|| Field->cRef + Field->cAlmLin + dtos( Field->dFecFac ) } ) )

      ( cFacCliL )->( dbCloseArea() )

   else

      msgStop( "Imposible abrir en modo exclusivo la tabla de facturas de clientes" )

   end if

   dbUseArea( .t., cDriver, cPath + "FacCliI.DBF", cCheckArea( "FacCliI", @dbfFacCliI ), .f. )
   if !( dbfFacCliI )->( neterr() )
      ( dbfFacCliI )->( __dbPack() )

      ( dbfFacCliI )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfFacCliI )->( ordCreate( cPath + "FacCliI.Cdx", "nNumFac", "cSerie + str( nNumFac ) + cSufFac", {|| Field->cSerie + str( Field->nNumFac ) + Field->cSufFac } ) )

      ( dbfFacCliI)->( ordCondSet( "!Deleted()", {|| !Deleted() }  ) )
      ( dbfFacCliI )->( ordCreate( cPath + "FacCliI.Cdx", "iNumFac", "'11' + cSerie + str( nNumFac ) + Space( 1 ) + cSufFac", {|| '11' + Field->cSerie + str( Field->nNumFac ) + Space( 1 ) + Field->cSufFac } ) )

      ( dbfFacCliI )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de facturas de clientes" )
   end if

   dbUseArea( .t., cDriver, cPath + "FacCliD.DBF", cCheckArea( "FacCliD", @dbfFacCliD ), .f. )
   if !( dbfFacCliD )->( neterr() )
      ( dbfFacCliD )->( __dbPack() )

      ( dbfFacCliD )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfFacCliD )->( ordCreate( cPath + "FacCliD.Cdx", "nNumFac", "cSerFac + str( nNumFac ) + cSufFac", {|| Field->cSerFac + str( Field->nNumFac ) + Field->cSufFac } ) )

      ( dbfFacCliD)->( ordCondSet( "!Deleted()", {|| !Deleted() }  ) )
      ( dbfFacCliD )->( ordCreate( cPath + "FacCliD.Cdx", "iNumFac", "'11' + cSerFac + str( nNumFac ) + Space( 1 ) + cSufFac", {|| '11' + Field->cSerFac + str( Field->nNumFac ) + Space( 1 ) + Field->cSufFac } ) )

      ( dbfFacCliD )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de facturas de clientes" )
   end if

   dbUseArea( .t., cDriver, cPath + "FACCLIT.DBF", cCheckArea( "FACCLIT", @cFacCliT ), .f. )

   if !( cFacCliT )->( neterr() )
      ( cFacCliT )->( __dbPack() )

      ( cFacCliT )->( ordCondSet("!Deleted()", {|| !Deleted() } ) )
      ( cFacCliT )->( ordCreate( cPath + "FACCLIT.CDX", "NNUMFAC", "CSERIE + str( NNUMFAC ) + CSUFFAC", {|| Field->cSerie + str( Field->nNumFac ) + Field->cSufFac }, ) )

      ( cFacCliT )->( ordCondSet("!Deleted()", {|| !Deleted() } ) )
      ( cFacCliT )->( ordCreate( cPath + "FACCLIT.CDX", "dFecFac", "dFecFac", {|| Field->dFecFac } ) )

      ( cFacCliT )->( ordCondSet("!Deleted()", {|| !Deleted() } ) )
      ( cFacCliT )->( ordCreate( cPath + "FACCLIT.CDX", "CCODCLI", "CCODCLI", {|| Field->CCODCLI } ) )

      ( cFacCliT )->( ordCondSet("!Deleted()", {|| !Deleted() } ) )
      ( cFacCliT )->( ordCreate( cPath + "FACCLIT.CDX", "CNOMCLI", "Upper( CNOMCLI )", {|| Upper( Field->CNOMCLI ) } ) )

      ( cFacCliT )->( ordCondSet("!Deleted()", {|| !Deleted() } ) )
      ( cFacCliT )->( ordCreate( cPath + "FACCLIT.CDX", "CPOBCLI", "CPOBCLI", {|| Field->CPOBCLI } ) )

      ( cFacCliT )->( ordCondSet("!Deleted()", {|| !Deleted() } ) )
      ( cFacCliT )->( ordCreate( cPath + "FACCLIT.CDX", "CCODOBR", "cCodObr + Dtos( dFecFac )", {|| Field->cCodObr + Dtos( Field->dFecFac ) } ) )

      ( cFacCliT )->( ordCondSet("!Deleted()", {|| !Deleted() } ) )
      ( cFacCliT )->( ordCreate( cPath + "FACCLIT.CDX", "CCODAGE", "cCodAge + Dtos( dFecFac )", {|| Field->cCodAge + Dtos( Field->dFecFac ) } ) )

      ( cFacCliT )->( ordCondSet("!Deleted()", {|| !Deleted() } ) )
      ( cFacCliT )->( ordCreate( cPath + "FACCLIT.CDX", "CTURFAC", "CTURFAC + CSUFFAC + CCODCAJ", {|| Field->CTURFAC + Field->CSUFFAC + Field->CCODCAJ } ) )

      ( cFacCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( cFacCliT )->( ordCreate( cPath + "FacCliT.Cdx", "cCodPago", "cCodPago", {|| Field->cCodPago } ) )

      ( cFacCliT )->( ordCondSet("!Deleted()", {|| !Deleted() } ) )
      ( cFacCliT )->( ordCreate( cPath + "FACCLIT.CDX", "CAGEFEC", "CCODAGE + DtoS( DFECFAC )", {|| Field->CCODAGE + DtoS( Field->DFECFAC ) } ) )

      ( cFacCliT )->( ordCondSet("!Deleted()", {|| !Deleted() } ) )
      ( cFacCliT )->( ordCreate( cPath + "FACCLIT.CDX", "NNUMLIQ", "str( NNUMLIQ ) + CSUFLIQ", {|| str( Field->NNUMLIQ ) + Field->CSUFLIQ } ) )

      ( cFacCliT )->( ordCondSet("!Deleted()", {|| !Deleted()  } ))
      ( cFacCliT )->( ordCreate( cPath + "FACCLIT.CDX", "lSndDoc", "lSndDoc", {|| Field->lSndDoc } ) )

      ( cFacCliT )->( ordCondSet("!Deleted()", {|| !Deleted() } ))
      ( cFacCliT )->( ordCreate( cPath + "FACCLIT.CDX", "cNumDoc", "cNumDoc", {|| Field->cNumDoc } ) )

      ( cFacCliT )->( ordCondSet("!Deleted()", {|| !Deleted() } ))
      ( cFacCliT )->( ordCreate( cPath + "FacCliT.Cdx", "cNumPre", "cNumPre", {|| Field->cNumPre } ) )

      ( cFacCliT )->( ordCondSet("!Deleted()", {|| !Deleted() } ))
      ( cFacCliT )->( ordCreate( cPath + "FacCliT.Cdx", "cNumPed", "cNumPed", {|| Field->cNumPed } ) )

      ( cFacCliT )->( ordCondSet("!Deleted()", {|| !Deleted() } ))
      ( cFacCliT )->( ordCreate( cPath + "FACCLIT.CDX", "cNumAlb", "cNumAlb", {|| Field->cNumAlb } ) )

      ( cFacCliT)->( ordCondSet( "!Deleted()", {|| !Deleted() }  ) )
      ( cFacCliT )->( ordCreate( cPath + "FacCliT.Cdx", "iNumFac", "'11' + cSerie + str( nNumFac ) + Space( 1 ) + cSufFac", {|| '11' + Field->cSerie + str( Field->nNumFac ) + Space( 1 ) + Field->cSufFac } ) )

      ( cFacCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() }, , , , , , , , , .t. ) )
      ( cFacCliT )->( ordCreate( cPath + "FacCliT.Cdx", "dFecDes", "Dtos( dFecFac ) + tFecFac", {|| Dtos( Field->dFecFac ) + Field->tFecFac } ) )

      ( cFacCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() }, , , , , , , , , .t. ) )
      ( cFacCliT )->( ordCreate( cPath + "FacCliT.Cdx", "lMail", "lMail", {|| Field->lMail } ) )

      ( cFacCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() }, , , , , , , , , .t. ) )
      ( cFacCliT )->( ordCreate( cPath + "FacCliT.Cdx", "nTotFac", "nTotFac", {|| Field->nTotFac } ) )

      ( cFacCliT )->( dbCloseArea() )

   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de facturas de clientes" )
   end if

   dbUseArea( .t., cDriver, cPath + "FacCliS.Dbf", cCheckArea( "FacCliS", @cFacCliT ), .f. )

   if !( cFacCliT )->( neterr() )
      ( cFacCliT )->( __dbPack() )

      ( cFacCliT )->( ordCondSet( "!Deleted()", {||!Deleted()}  ) )
      ( cFacCliT )->( ordCreate( cPath + "FacCliS.Cdx", "nNumFac", "cSerFac + str( nNumFac ) + cSufFac + str( nNumLin )", {|| Field->cSerFac + str( Field->nNumFac ) + Field->cSufFac + str( Field->nNumLin ) } ) )

      ( cFacCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( cFacCliT )->( ordCreate( cPath + "FacCliS.Cdx", "cRefSer", "cRef + cAlmLin + cNumSer", {|| Field->cRef + Field->cAlmLin +Field->cNumSer } ) )

      ( cFacCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( cFacCliT )->( ordCreate( cPath + "FacCliS.CDX", "cNumSer", "cNumSer", {|| Field->cNumSer } ) )

      ( cFacCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() }  ) )
      ( cFacCliT )->( ordCreate( cPath + "FacCliS.Cdx", "iNumFac", "'11' + cSerFac + str( nNumFac ) + Space( 1 ) + cSufFac", {|| '11' + Field->cSerFac + str( Field->nNumFac ) + Space( 1 ) + Field->cSufFac } ) )

      ( cFacCliT )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de Números de series de facturas de clientes" )
   end if

   dbUseArea( .t., cDriver, cPath + "FacCliE.Dbf", cCheckArea( "FacCliE", @cFacCliT ), .f. )

   if !( cFacCliT )->( neterr() )
      ( cFacCliT )->( __dbPack() )

      ( cFacCliT )->( ordCondSet( "!Deleted()", {||!Deleted()}  ) )
      ( cFacCliT )->( ordCreate( cPath + "FacCliE.Cdx", "nNumFac", "cSerFac + str( nNumFac ) + cSufFac", {|| Field->cSerFac + str( Field->nNumFac ) + Field->cSufFac } ) )

      ( cFacCliT )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de entidades de facturas de clientes" ) 
   end if

   dbUseArea( .t., cDriver, cPath + "FacCliC.Dbf", cCheckArea( "FacCliC", @cFacCliT ), .f. )

   if !( cFacCliT )->( neterr() )
      ( cFacCliT )->( __dbPack() )

      ( cFacCliT )->( ordCondSet( "!Deleted()", {||!Deleted()}  ) )
      ( cFacCliT )->( ordCreate( cPath + "FacCliC.Cdx", "nNumFac", "cSerFac + str( nNumFac ) + cSufFac", {|| Field->cSerFac + str( Field->nNumFac ) + Field->cSufFac } ) )

      ( cFacCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( cFacCliT )->( ordCreate( cPath + "FacCliC.Cdx", "cSitua", "cSitua", {|| Field->cSitua } ) )

      ( cFacCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( cFacCliT )->( ordCreate( cPath + "FacCliC.Cdx", "idPs", "str( idPs )", {|| str( Field->idPs ) } ) )

      ( cFacCliT )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de situación de facturas de clientes" )
   end if

Return nil

//---------------------------------------------------------------------------//

function aFacCliEst()

   local aFacCliEst  := {}

   aAdd( aFacCliEst, { "cSerFac", "C",    1,  0, "Serie de factura" ,            "",                   "", "( cDbfCol )", nil } )
   aAdd( aFacCliEst, { "nNumFac", "N",    9,  0, "Numero de factura" ,           "'999999999'",        "", "( cDbfCol )", nil } )
   aAdd( aFacCliEst, { "cSufFac", "C",    2,  0, "Sufijo de factura" ,           "",                   "", "( cDbfCol )", nil } )
   aAdd( aFacCliEst, { "cSitua",  "C",  140,  0, "Situación" ,                   "",                   "", "( cDbfCol )", nil } )
   aAdd( aFacCliEst, { "dFecSit", "D",    8,  0, "Fecha de la situación" ,       "",                   "", "( cDbfCol )", nil } )
   aAdd( aFacCliEst, { "tFecSit", "C",    6,  0, "Hora de la situación" ,        "",                   "", "( cDbfCol )", nil } )
   aAdd( aFacCliEst, { "idPs",    "N",   11,  0, "Id prestashop" ,               "",                   "", "( cDbfCol )", nil } )   

return ( aFacCliEst )

//--------------------------------------------------------------------------//

function aIncFacCli()

   local aIncFacCli  := {}

   aAdd( aIncFacCli, { "cSerie",  "C",    1,  0, "Serie de factura" ,              "",                   "", "( cDbfCol )" } )
   aAdd( aIncFacCli, { "nNumFac", "N",    9,  0, "Número de factura" ,             "'999999999'",        "", "( cDbfCol )" } )
   aAdd( aIncFacCli, { "cSufFac", "C",    2,  0, "Sufijo de factura" ,             "",                   "", "( cDbfCol )" } )
   aAdd( aIncFacCli, { "cCodTip", "C",    3,  0, "Tipo de incidencia" ,            "",                   "", "( cDbfCol )" } )
   aAdd( aIncFacCli, { "dFecInc", "D",    8,  0, "Fecha de la incidencia" ,        "",                   "", "( cDbfCol )" } )
   aAdd( aIncFacCli, { "mDesInc", "M",   10,  0, "Descripción de la incidencia" ,  "",                   "", "( cDbfCol )" } )
   aAdd( aIncFacCli, { "lListo",  "L",    1,  0, "Lógico de listo" ,               "",                   "", "( cDbfCol )" } )
   aAdd( aIncFacCli, { "lAviso",  "L",    1,  0, "Lógico de Aviso" ,               "",                   "", "( cDbfCol )" } )

return ( aIncFacCli )

//---------------------------------------------------------------------------//

function aFacCliDoc()

   local aFacCliDoc  := {}

   aAdd( aFacCliDoc, { "cSerFac", "C",    1,  0, "Serie de factura" ,                "",                   "", "( cDbfCol )" } )
   aAdd( aFacCliDoc, { "nNumFac", "N",    9,  0, "Número de factura" ,               "'999999999'",        "", "( cDbfCol )" } )
   aAdd( aFacCliDoc, { "cSufFac", "C",    2,  0, "Sufijo de factura" ,               "",                   "", "( cDbfCol )" } )
   aAdd( aFacCliDoc, { "cNombre", "C",  250,  0, "Nombre del documento" ,            "",                   "", "( cDbfCol )" } )
   aAdd( aFacCliDoc, { "cRuta",   "C",  250,  0, "Ruta del documento" ,              "",                   "", "( cDbfCol )" } )
   aAdd( aFacCliDoc, { "mObsDoc", "M",   10,  0, "Observaciones del documento" ,     "",                   "", "( cDbfCol )" } )

return ( aFacCliDoc )

//---------------------------------------------------------------------------//

function aColFacCli()

   local aColFacCli  := {}

   aAdd( aColFacCli, { "cSerie"     ,"C",  1, 0, ""                                       , "Serie",                       "", "( cDbfCol )", nil } )
   aAdd( aColFacCli, { "nNumFac"    ,"N",  9, 0, ""                                       , "Numero",                      "", "( cDbfCol )", nil } )
   aAdd( aColFacCli, { "cSufFac"    ,"C",  2, 0, ""                                       , "Sufijo",                      "", "( cDbfCol )", nil } )
   aAdd( aColFacCli, { "cRef"       ,"C", 18, 0, "Referencia del artículo"                , "Articulo",                    "", "( cDbfCol )", nil } )
   aAdd( aColFacCli, { "cDetalle"   ,"C",250, 0, "Detalle del artículo"                   , "DescripcionArticulo",         "", "( cDbfCol )", nil } )
   aAdd( aColFacCli, { "nPreUnit"   ,"N", 16, 6, "Precio unitario"                        , "PrecioVenta",                 "", "( cDbfCol )", nil } )
   aAdd( aColFacCli, { "nPntVer"    ,"N", 16, 6, "Importe punto verde"                    , "PuntoVerde",                  "", "( cDbfCol )", nil } )
   aAdd( aColFacCli, { "nImpTrn"    ,"N", 16, 6, "Importe de portes"                      , "Portes",                      "", "( cDbfCol )", nil } )
   aAdd( aColFacCli, { "nDto"       ,"N",  6, 2, "Descuento"                              , "DescuentoPorcentual",         "", "( cDbfCol )", nil } )
   aAdd( aColFacCli, { "nDtoPrm"    ,"N",  6, 2, "Descuento promocional"                  , "DescuentoPromocion",          "", "( cDbfCol )", nil } )
   aAdd( aColFacCli, { "nIva"       ,"N",  6, 2, "Porcentaje de " + cImp()                , "PorcentajeImpuesto",          "", "( cDbfCol )", nil } )
   aAdd( aColFacCli, { "nCanEnt"    ,"N", 16, 6, cNombreCajas()                           , "Cajas",                       "", "( cDbfCol )", nil } )
   aAdd( aColFacCli, { "lControl"   ,"L",  1, 0, "Lógico linea de control"                , "LineaControl",                "", "( cDbfCol )", nil } )
   aAdd( aColFacCli, { "nPesokg"    ,"N", 16, 6, "Peso del producto"                      , "Peso",                        "", "( cDbfCol )", nil } )
   aAdd( aColFacCli, { "cPesokg"    ,"C",  2, 0, "Unidad de peso del producto"            , "UnidadMedicionPeso",          "", "( cDbfCol )", nil } )
   aAdd( aColFacCli, { "cUnidad"    ,"C",  2, 0, "Unidades de venta"                      , "UnidadMedicion",              "", "( cDbfCol )", nil } )
   aAdd( aColFacCli, { "cCodAge"    ,"C",  3, 0, "Código del agente"                      , "Agente",                      "", "( cDbfCol )", nil } )
   aAdd( aColFacCli, { "nComAge"    ,"N",  6, 2, "Comisión del agente"                    , "ComisionAgente",              "", "( cDbfCol )", nil } )
   aAdd( aColFacCli, { "nUniCaja"   ,"N", 16, 6, cNombreUnidades()                        , "Unidades",                    "", "( cDbfCol )", nil } )
   aAdd( aColFacCli, { "nUndKit"    ,"N", 16, 6, "Unidades del producto kit"              , "UnidadesKit",                 "", "( cDbfCol )", nil } )
   aAdd( aColFacCli, { "dFecha"     ,"D",  8, 0, "Fecha de detalle"                       , "FechaEntrega",                "", "( cDbfCol )", nil } )
   aAdd( aColFacCli, { "cTipMov"    ,"C",  2, 0, "Tipo de movimiento"                     , "Tipo",                        "", "( cDbfCol )", nil } )
   aAdd( aColFacCli, { "mLngDes"    ,"M", 10, 0, "Descripción de artículo sin codificar"  , "DescripcionAmpliada",         "", "( cDbfCol )", nil } )
   aAdd( aColFacCli, { "cCodAlb"    ,"C", 12, 0, "Número del albarán de procedencia"      , "",                            "", "( cDbfCol )", nil } )
   aAdd( aColFacCli, { "dFecAlb"    ,"D",  8, 0, "Fecha del albarán de procedencia"       , "",                            "", "( cDbfCol )", nil } )
   aAdd( aColFacCli, { "lTotLin"    ,"L",  1, 0, "Valor Lógico para enviar el documento"  , "LineaTotal",                  "", "( cDbfCol )", nil } )
   aAdd( aColFacCli, { "lImpLin"    ,"L",  1, 0, "línea no imprimible"                    , "LineaNoImprimible",           "", "( cDbfCol )", nil } )
   aAdd( aColFacCli, { "cCodPr1"    ,"C", 20, 0, "Código de primera propiedad"            , "CodigoPropiedad1",            "", "( cDbfCol )", nil } )
   aAdd( aColFacCli, { "cCodPr2"    ,"C", 20, 0, "Código de segunda propiedad"            , "CodigoPropiedad2",            "", "( cDbfCol )", nil } )
   aAdd( aColFacCli, { "cValPr1"    ,"C", 20, 0, "Valor de primera propiedad"             , "ValorPropiedad1",             "", "( cDbfCol )", nil } )
   aAdd( aColFacCli, { "cValPr2"    ,"C", 20, 0, "Valor de segunda propiedad"             , "ValorPropiedad2",             "", "( cDbfCol )", nil } )
   aAdd( aColFacCli, { "nFacCnv"    ,"N", 16, 6, "Factor de conversión de la compra"      , "FactorConversion",            "", "( cDbfCol )", nil } )
   aAdd( aColFacCli, { "nDtoDiv"    ,"N", 16, 6, "Descuento lineal de la compra"          , "DescuentoLineal",             "", "( cDbfCol )", nil } )
   aAdd( aColFacCli, { "lSel"       ,"L",  1, 0, ""                                       , "",                            "", "( cDbfCol )", nil } )
   aAdd( aColFacCli, { "nNumLin"    ,"N",  4, 0, "Número de la línea"                     , "NumeroLinea",                 "", "( cDbfCol )", nil } )
   aAdd( aColFacCli, { "nCtlStk"    ,"N",  1, 0, "Tipo de stock de la línea"              , "TipoStock",                   "", "( cDbfCol )", nil } )
   aAdd( aColFacCli, { "nCosDiv"    ,"N", 16, 6, "Costo del producto"                     , "PrecioCosto",                 "", "( cDbfCol )", nil } )
   aAdd( aColFacCli, { "nPvpRec"    ,"N", 16, 6, "Precio de venta recomendado"            , "PrecioVentaRecomendado",      "", "( cDbfCol )", nil } )
   aAdd( aColFacCli, { "cAlmLin"    ,"C", 16, 0, "Código de almacén"                      , "Almacen",                     "", "( cDbfCol )", {|| oUser():cAlmacen() } } )
   aAdd( aColFacCli, { "lIvaLin"    ,"L",  1, 0, cImp() + " incluido"                     , "LineaImpuestoIncluido",       "", "( cDbfCol )", nil } )
   aAdd( aColFacCli, { "cCodImp"    ,"C",  3, 0, "Código del impuesto especial"           , "ImpuestoEspecial",            "", "( cDbfCol )", nil } )
   aAdd( aColFacCli, { "nValImp"    ,"N", 16, 6, "Importe del impuesto especial"          , "ImporteImpuestoEspecial",     "", "( cDbfCol )", nil } )
   aAdd( aColFacCli, { "lLote"      ,"L",  1, 0, ""                                       , "LogicoLote",                  "", "( cDbfCol )", nil } )
   aAdd( aColFacCli, { "nLote"      ,"N",  9, 0, ""                                       , "",                            "", "( cDbfCol )", nil } )
   aAdd( aColFacCli, { "cLote"      ,"C", 14, 0, "Número de lote"                         , "Lote",                        "", "( cDbfCol )", nil } )
   aAdd( aColFacCli, { "dFecCad"    ,"D",  8, 0, "Fecha de caducidad"                     , "FechaCaducidad",              "", "( cDbfCol )", nil } )
   aAdd( aColFacCli, { "lKitArt"    ,"L",  1, 0, "línea con escandallo"                   , "LineaEscandallo",             "", "( cDbfCol )", nil } )
   aAdd( aColFacCli, { "lKitChl"    ,"L",  1, 0, "línea pertenciente a escandallo"        , "LineaPerteneceEscandallo",    "", "( cDbfCol )", nil } )
   aAdd( aColFacCli, { "lKitPrc"    ,"L",  1, 0, ""                                       , "LineaEscandalloPrecio",       "", "( cDbfCol )", nil } )
   aAdd( aColFacCli, { "nMesGrt"    ,"N",  2, 0, "Meses de garantía"                      , "MesesGarantia",               "", "( cDbfCol )", nil } )
   aAdd( aColFacCli, { "lMsgVta"    ,"L",  1, 0, "Avisar venta sin stocks"                , "AvisarSinStock",              "", "( cDbfCol )", nil } )
   aAdd( aColFacCli, { "lNotVta"    ,"L",  1, 0, "No permitir venta sin stocks"           , "NoPermitirSinStock",          "", "( cDbfCol )", nil } )
   aAdd( aColFacCli, { "cCodTip"    ,"C",  4, 0, "Código del tipo de artículo"            , "TipoArticulo",                "", "( cDbfCol )", nil } )
   aAdd( aColFacCli, { "mNumSer"    ,"M", 10, 0, ""                                       , "",                            "", "( cDbfCol )", nil } )
   aAdd( aColFacCli, { "cCodFam"    ,"C", 16, 0, "Código de familia"                      , "Familia",                     "", "( cDbfCol )", nil } )
   aAdd( aColFacCli, { "cGrpFam"    ,"C",  3, 0, "Código del grupo de familia"            , "GrupoFamilia",                "", "( cDbfCol )", nil } )
   aAdd( aColFacCli, { "nReq"       ,"N", 16, 6, "Recargo de equivalencia"                , "RecargoEquivalencia",         "", "( cDbfCol )", nil } )
   aAdd( aColFacCli, { "mObsLin"    ,"M", 10, 0, "Observaciones de linea"                 , "Observaciones",               "", "( cDbfCol )", nil } )
   aAdd( aColFacCli, { "cCodPrv"    ,"C", 12, 0, "Código del proveedor"                   , "Proveedor",                   "", "( cDbfCol )", nil } )
   aAdd( aColFacCli, { "cNomPrv"    ,"C", 30, 0, "Nombre del proveedor"                   , "NombreProveedor",             "", "( cDbfCol )", nil } )
   aAdd( aColFacCli, { "cImagen"    ,"C",128, 0, "Fichero de imagen"                      , "Imagen",                      "", "( cDbfCol )", nil } )
   aAdd( aColFacCli, { "nPuntos"    ,"N", 15, 6, "Puntos del artículo"                    , "",                            "", "( cDbfCol )", nil } )
   aAdd( aColFacCli, { "nValPnt"    ,"N", 16, 6, "Valor del punto"                        , "",                            "", "( cDbfCol )", nil } )
   aAdd( aColFacCli, { "nDtoPnt"    ,"N",  5, 2, "Descuento puntos"                       , "",                            "", "( cDbfCol )", nil } )
   aAdd( aColFacCli, { "nIncPnt"    ,"N",  5, 2, "Incremento porcentual"                  , "",                            "", "( cDbfCol )", nil } )
   aAdd( aColFacCli, { "cRefPrv"    ,"C", 18, 0, "Referencia proveedor"                   , "ReferenciaProveedor",         "", "( cDbfCol )", nil } )
   aAdd( aColFacCli, { "nVolumen"   ,"N", 16, 6, "Volumen del producto"                   , "Volumen",                     "", "( cDbfCol )", nil } )
   aAdd( aColFacCli, { "cVolumen"   ,"C",  2, 0, "Unidad del volumen"                     , "UnidadMedicionVolumen",       "", "( cDbfCol )", nil } )
   aAdd( aColFacCli, { "lAlquiler"  ,"L",  1, 0, "Lógico de línea de alquiler"            , "Alquiler",                    "", "( cDbfCol )", nil } )
   aAdd( aColFacCli, { "dFecEnt"    ,"D",  8, 0, "Fecha de entrada del alquiler"          , "FechaEntradaAlquiler",        "", "( cDbfCol )", nil } )
   aAdd( aColFacCli, { "dFecSal"    ,"D",  8, 0, "Fecha de salida del alquiler"           , "FechaSalidaAlquiler",         "", "( cDbfCol )", nil } )
   aAdd( aColFacCli, { "nPreAlq"    ,"N", 16, 6, "Precio de alquiler"                     , "PrecioAlquiler",              "", "( cDbfCol )", nil } )
   aAdd( aColFacCli, { "nNumMed"    ,"N",  1, 0, "Número de mediciones"                   , "NumeroMedidiones",            "", "( cDbfCol )", nil } )
   aAdd( aColFacCli, { "nMedUno"    ,"N", 16, 6, "Primera unidad de medición"             , "Medicion1",                   "", "( cDbfCol )", nil } )
   aAdd( aColFacCli, { "nMedDos"    ,"N", 16, 6, "Segunda unidad de medición"             , "Medicion2",                   "", "( cDbfCol )", nil } )
   aAdd( aColFacCli, { "nMedTre"    ,"N", 16, 6, "Tercera unidad de medición"             , "Medicion3",                   "", "( cDbfCol )", nil } )
   aAdd( aColFacCli, { "nTarLin"    ,"N",  1, 0, "Tarifa de precio aplicada"              , "NumeroTarifa",                "", "( cDbfCol )", nil } )
   aAdd( aColFacCli, { "lImpFra",   "L",   1, 0, "Lógico de imprimir frase publicitaria"  , "",                            "", "( cDbfCol )", nil } )
   aAdd( aColFacCli, { "cCodPry",   "C",   4, 0, "Código del proyecto"                    , "Proyecto",                    "", "( cDbfCol )", nil } )
   aAdd( aColFacCli, { "cTxtFra",   "C", 250, 0, "Texto de la frase publicitaria"         , "",                            "", "( cDbfCol )", nil } )
   aAdd( aColFacCli, { "Descrip",   "M",  10, 0, "Descripción larga"                      , "DescripcionTecnica",          "", "( cDbfCol )", nil } )
   aAdd( aColFacCli, { "lLinOfe",   "L",   1, 0, "Linea con oferta"                       , "LineaOferta",                 "", "( cDbfCol )", nil } )
   aAdd( aColFacCli, { "lVolImp",   "L",   1, 0, "Aplicar volumen impuestos especiales"   , "VolumenImpuestosEspeciales",  "", "( cDbfCol )", nil } )
   aAdd( aColFacCli, { "lGasSup",   "L",   1, 0, "Linea de gastos suplidos"               , "GastosSuplidos",              "", "( cDbfCol )", nil } )
   aAdd( aColFacCli, { "cNumPed"   ,"C",  12, 0, "Número del pedido"                      , "NumeroPedido",                "", "( cDbfCol )", nil } )
   aAdd( aColFacCli, { "dFecFac"   ,"D",   8, 0, "Fecha de factura"                       , "Fecha",                       "", "( cDbfCol )", {|| GetSysDate() } } )
   aAdd( aColFacCli, { "cSuPed"    ,"C",  50, 0, "Su pedido (desde albarán)"              , "",                            "", "( cDbfCol )", nil } )
   aAdd( aColFacCli, { "cNumSat"   ,"C",  12, 0, "Número del SAT"                         , "NumeroSAT",                   "", "( cDbfCol )", nil } )
   aAdd( aColFacCli, { "dFecUltCom","D",   8, 0, "Fecha última compra"                    , "FechaUltimaVenta",            "", "( cDbfCol )", nil } ) 
   aAdd( aColFacCli, { "cCodCli"   ,"C",  12, 0, "Código del cliente"                     , "Cliente",                     "", "( cDbfCol )", nil } )
   aAdd( aColFacCli, { "lFromAtp"  ,"L",   1, 0, ""                                       , "",                            "", "( cDbfCol )", nil } )
   aAdd( aColFacCli, { "nUniUltCom","N",  16, 6, "Unidades última compra"                 , "UnidadesUltimaVenta",         "", "( cDbfCol )", nil } ) 
   aAdd( aColFacCli, { "nBultos",   "N",  16, 6, "Numero de bultos en líneas"             , "Bultos",                      "", "( cDbfCol )", nil } )
   aAdd( aColFacCli, { "cFormato",  "C", 100, 0, "Formato de venta"                       , "Formato",                     "", "( cDbfCol )", nil } )
   aAdd( aColFacCli, { "tFecFac",   "C",   6, 0, "Hora de la factura"                     , "Hora",                        "", "( cDbfCol )", {|| GetSysTime() } } )
   aAdd( aColFacCli, { "cCtrCoste", "C",   9, 0, "Código del centro de coste"             , "",                            "", "( cDbfCol )", nil } )
   aAdd( aColFacCli, { "lLabel"   , "L",   1, 0, "Lógico para marca de etiqueta"          , "LogicoEtiqueta",              "", "( cDbfCol )", nil } )
   aAdd( aColFacCli, { "nLabel"   , "N",   6, 0, "Unidades de etiquetas a imprimir"       , "NumeroEtiqueta",              "", "( cDbfCol )", nil } )
   aAdd( aColFacCli, { "cCodObr"  , "C",  10, 0, "Código de la dirección"                 , "Direccion",                   "", "( cDbfCol )", nil } )
   aAdd( aColFacCli, { "cRefAux",   "C",  18, 0, "Referencia auxiliar"                    , "ReferenciaAuxiliar",          "", "( cDbfCol )", nil } )
   aAdd( aColFacCli, { "cRefAux2",  "C",  18, 0, "Segunda referencia auxiliar"            , "ReferenciaAuxiliar2",         "", "( cDbfCol )", nil } )
   aAdd( aColFacCli, { "nPosPrint", "N",   4, 0, "Posición de impresión"                  , "PosicionImpresion",           "", "( cDbfCol )", nil } )
   aAdd( aColFacCli, { "cTipCtr",   "C",  20, 0, "Tipo tercero centro de coste"           , "",                            "", "( cDbfCol )", nil } )
   aAdd( aColFacCli, { "cTerCtr",   "C",  20, 0, "Tercero centro de coste"                , "",                            "", "( cDbfCol )", nil } )
   aAdd( aColFacCli, { "nNumKit",   "N",   4, 0, "Número de línea de escandallo"          , "",                            "", "( cDbfCol )", nil } )
   aAdd( aColFacCli, { "id_tipo_v", "N",  16, 0, "Identificador tipo de venta"            , "IdentificadorTipoVenta",      "", "( cDbfCol )", nil } )
   aAdd( aColFacCli, { "nRegIva",   "N",   1, 0, "Régimen de " + cImp()                   , "TipoImpuesto",                "", "( cDbfCol )", nil } ) 
   aAdd( aColFacCli, { "nPrcUltCom","N",  16, 6, "Precio última compra"                   , "PrecioUltimaVenta",           "", "( cDbfCol )", nil } ) 

return ( aColFacCli )

//---------------------------------------------------------------------------//

function aItmFacCli()

   local aItmFacCli  := {}

   aAdd( aItmFacCli, {"cSerie"      ,"C",  1, 0, "Serie de la factura" ,                                       "Serie",                       "", "( cDbf )", {|| "A" } } )
   aAdd( aItmFacCli, {"nNumFac"     ,"N",  9, 0, "Número de la factura" ,                                      "Numero",                      "", "( cDbf )", nil } )
   aAdd( aItmFacCli, {"cSufFac"     ,"C",  2, 0, "Sufijo de la factura" ,                                      "Sufijo",                      "", "( cDbf )", {|| RetSufEmp() } } )
   aAdd( aItmFacCli, {"cGuid"       ,"C", 40, 0, "Guid de la factura" ,                                        "GUID",                        "", "( cDbf )", {|| win_uuidcreatestring() } } )
   aAdd( aItmFacCli, {"cTurFac"     ,"C",  6, 0, "Sesión de la factura" ,                                      "Turno",                       "", "( cDbf )", {|| cCurSesion( nil, .f.) } } )
   aAdd( aItmFacCli, {"dFecFac"     ,"D",  8, 0, "Fecha de la factura" ,                                       "Fecha",                       "", "( cDbf )", {|| GetSysDate() } } )
   aAdd( aItmFacCli, {"cCodCli"     ,"C", 12, 0, "Código del cliente" ,                                        "Cliente",                     "", "( cDbf )", nil } )
   aAdd( aItmFacCli, {"cCodAlm"     ,"C", 16, 0, "Código de almacén" ,                                         "Almacen",                     "", "( cDbf )", {|| oUser():cAlmacen() } } )
   aAdd( aItmFacCli, {"cCodCaj"     ,"C",  3, 0, "Código de caja" ,                                            "Caja",                        "", "( cDbf )", {|| oUser():cCaja() } } )
   aAdd( aItmFacCli, {"cNomCli"     ,"C", 80, 0, "Nombre del cliente" ,                                        "NombreCliente",               "", "( cDbf )", nil } )
   aAdd( aItmFacCli, {"cDirCli"     ,"C",200, 0, "Domicilio del cliente" ,                                     "DomicilioCliente",            "", "( cDbf )", nil } )
   aAdd( aItmFacCli, {"cPobCli"     ,"C",200, 0, "Población del cliente" ,                                     "PoblacionCliente",            "", "( cDbf )", nil } )
   aAdd( aItmFacCli, {"cPrvCli"     ,"C",100, 0, "Provincia del cliente" ,                                     "ProvinciaCliente",            "", "( cDbf )", nil } )
   aAdd( aItmFacCli, {"nCodProV"    ,"N",  2, 0, "Número de provincia cliente" ,                               "",                            "", "( cDbf )", nil } )
   aAdd( aItmFacCli, {"cPosCli"     ,"C", 15, 0, "Código postal del cliente" ,                                 "CodigoPostalCliente",         "", "( cDbf )", nil } )
   aAdd( aItmFacCli, {"cDniCli"     ,"C", 30, 0, "NIF del cliente" ,                                           "DniCliente",                  "", "( cDbf )", nil } )
   aAdd( aItmFacCli, {"lModCli"     ,"L",  1, 0, "Lógico de modificar datos del cliente" ,                     "ModificarDatosCliente",       "", "( cDbf )", nil } )
   aAdd( aItmFacCli, {"lMayor"      ,"L",  1, 0, "Lógico de mayorista" ,                                       "",                            "", "( cDbf )", nil } )
   aAdd( aItmFacCli, {"nTarifa"     ,"N",  1, 0, "Tarifa de precio aplicada" ,                                 "NumeroTarifa",                "", "( cDbf )", nil } )
   aAdd( aItmFacCli, {"cCodAge"     ,"C",  3, 0, "Código del agente" ,                                         "Agente",                      "", "( cDbf )", {|| AccessCode():cAgente } } )
   aAdd( aItmFacCli, {"cCodRut"     ,"C",  4, 0, "Código de la ruta" ,                                         "Ruta",                        "", "( cDbf )", nil } )
   aAdd( aItmFacCli, {"cCodTar"     ,"C",  5, 0, "Código de la tarifa" ,                                       "Tarifa",                      "", "( cDbf )", nil } )
   aAdd( aItmFacCli, {"cCodObr"     ,"C", 10, 0, "Código de la Dirección" ,                                    "Direccion",                   "", "( cDbf )", nil } )
   aAdd( aItmFacCli, {"nPctComAge"  ,"N",  6, 2, "Porcentaje de Comisión del agente" ,                         "ComisionAgente",              "", "( cDbf )", nil } )
   aAdd( aItmFacCli, {"lLiquidada"  ,"L",  1, 0, "Lógico de la factura pagada" ,                               "Pagada",                      "", "( cDbf )", nil } )
   aAdd( aItmFacCli, {"lContab"     ,"L",  1, 0, "Lógico de la factura contabilizada" ,                        "Contabilizada",               "", "( cDbf )", nil } )
   aAdd( aItmFacCli, {"cConGuid"    ,"C", 40, 0, "Guid del apunte contable" ,                                  "GuidApunteContable",          "", "( cDbf )", nil } )
   aAdd( aItmFacCli, {"dFecEnt"     ,"D",  8, 0, "Fecha de entrega" ,                                          "FechaEntrega",                "", "( cDbf )", nil } )
   aAdd( aItmFacCli, {"cSuFac"      ,"C", 50, 0, "Su pedido" ,                                                 "SuPedido",                    "", "( cDbf )", nil } )
   aAdd( aItmFacCli, {"lImpAlb"     ,"L",  1, 0, "Lógico si la factura se importe de facturas" ,               "ImportadaAlbaran",            "", "( cDbf )", nil } )
   aAdd( aItmFacCli, {"cCondent"    ,"C",100, 0, "Condición de entrada" ,                                      "CondicionEntrada",            "", "( cDbf )", nil } )
   aAdd( aItmFacCli, {"mComEnt"     ,"M", 10, 0, "Comentarios" ,                                               "Comentarios",                 "", "( cDbf )", nil } )
   aAdd( aItmFacCli, {"mObserv"     ,"M", 10, 0, "Observaciones" ,                                             "Observaciones",               "", "( cDbf )", nil } )
   aAdd( aItmFacCli, {"cCodPago"    ,"C",  2, 0, "Código del tipo de pago" ,                                   "Pago",                        "", "( cDbf )", nil } )
   aAdd( aItmFacCli, {"nBultos"     ,"N",  5, 0, "Número de bultos" ,                                          "Bultos",                      "", "( cDbf )", nil } )
   aAdd( aItmFacCli, {"nPortes"     ,"N",  6, 0, "Valor del porte" ,                                           "Portes",                      "", "( cDbf )", nil } )
   aAdd( aItmFacCli, {"nIvaMan"     ,"N",  6, 2, "Porcentaje de " + cImp() + " del gasto" ,                    "ImpuestoGastos",              "", "( cDbf )", nil } )
   aAdd( aItmFacCli, {"nManObr"     ,"N", 16, 6, "Gasto" ,                                                     "Gastos",                      "", "( cDbf )", nil } )
   aAdd( aItmFacCli, {"cNumAlb"     ,"C", 12, 0, "Número de albarán" ,                                         "NumeroAlbaran",               "", "( cDbf )", nil } )
   aAdd( aItmFacCli, {"cNumPed"     ,"C", 12, 0, "Número de pedido" ,                                          "NumeroPedido",                "", "( cDbf )", nil } )
   aAdd( aItmFacCli, {"cNumPre"     ,"C", 12, 0, "Número de presupuesto" ,                                     "NumeroPresupuesto",           "", "( cDbf )", nil } )
   aAdd( aItmFacCli, {"cNumSat"     ,"C", 12, 0, "Número de S.A.T." ,                                          "NumeroSAT",                   "", "( cDbf )", nil } )
   aAdd( aItmFacCli, {"nTipoFac"    ,"N",  1, 0, "" ,                                                          "",                            "", "( cDbf )", nil } )
   aAdd( aItmFacCli, {"cDtoEsp"     ,"C", 50, 0, "Descripción de porcentaje de descuento especial" ,           "DescripcionDescuento1",       "", "( cDbf )", nil } )
   aAdd( aItmFacCli, {"nDtoEsp"     ,"N", 10, 6, "Porcentaje de descuento especial" ,                          "PorcentajeDescuento1",        "", "( cDbf )", nil } )
   aAdd( aItmFacCli, {"cDpp"        ,"C", 50, 0, "Descripción de porcentaje de descuento por pronto pago",     "DescripcionDescuento2",       "", "( cDbf )", nil } )
   aAdd( aItmFacCli, {"nDpp"        ,"N", 10, 6, "Porcentaje de descuento por pronto pago" ,                   "PorcentajeDescuento2",        "", "( cDbf )", nil } )
   aAdd( aItmFacCli, {"cDtoUno"     ,"C", 25, 0, "Descripción de porcentaje de descuento personalizado",       "DescripcionDescuento3",       "", "( cDbf )", nil } )
   aAdd( aItmFacCli, {"nDtoUno"     ,"N", 10, 6, "Porcentaje de descuento por descuento personalizado" ,       "PorcentajeDescuento3",        "", "( cDbf )", nil } )
   aAdd( aItmFacCli, {"cDtoDos"     ,"C", 25, 0, "Descripción de porcentaje de descuento personalizado" ,      "DescripcionDescuento4",       "", "( cDbf )", nil } )
   aAdd( aItmFacCli, {"nDtoDos"     ,"N", 10, 6, "Porcentaje de descuento por descuento personalizado" ,       "PorcentajeDescuento4",        "", "( cDbf )", nil } )
   aAdd( aItmFacCli, {"nDtoCnt"     ,"N",  6, 2, "" ,                                                          "",                            "", "( cDbf )", nil } )
   aAdd( aItmFacCli, {"nDtoRap"     ,"N",  6, 2, "" ,                                                          "",                            "", "( cDbf )", nil } )
   aAdd( aItmFacCli, {"nDtoPub"     ,"N",  6, 2, "" ,                                                          "",                            "", "( cDbf )", nil } )
   aAdd( aItmFacCli, {"nDtoPgo"     ,"N",  6, 2, "" ,                                                          "",                            "", "( cDbf )", nil } )
   aAdd( aItmFacCli, {"nDtoPtf"     ,"N",  7, 2, "" ,                                                          "",                            "", "( cDbf )", nil } )
   aAdd( aItmFacCli, {"nTipoIva"    ,"N",  1, 0, "" ,                                                          "",                            "", "( cDbf )", nil } )
   aAdd( aItmFacCli, {"nPorcIva"    ,"N",  4, 1, "" ,                                                          "",                            "", "( cDbf )", nil } )
   aAdd( aItmFacCli, {"lRecargo"    ,"L",  1, 0, "Lógico para recargo" ,                                       "RecargoEquivalencia",         "", "( cDbf )", nil } )  
   aAdd( aItmFacCli, {"cRemitido"   ,"C", 50, 0, "Campo de remitido" ,                                         "Remitido",                    "", "( cDbf )", nil } )  
   aAdd( aItmFacCli, {"lIvaInc"     ,"L",  1, 0, "Lógico " + cImp() + " incluido" ,                            "ImpuestosIncluidos",          "", "( cDbf )", {|| uFieldEmpresa( "lIvaInc" ) } } )
   aAdd( aItmFacCli, {"lSndDoc"     ,"L",  1, 0, "Lógico para documento enviado" ,                             "Envio",                       "", "( cDbf )", {|| .t. } } )                       
   aAdd( aItmFacCli, {"cDivFac"     ,"C",  3, 0, "Código de la divisa" ,                                       "Divisa",                      "", "( cDbf )", {|| cDivEmp() } } )
   aAdd( aItmFacCli, {"nVdvFac"     ,"N", 10, 4, "Cambio de la divisa" ,                                       "ValorDivisa",                 "", "( cDbf )", {|| nChgDiv() } } )
   aAdd( aItmFacCli, {"cRetPor"     ,"C",100, 0, "Retirado por" ,                                              "RetiradoPor",                 "", "( cDbf )", nil } )                                     
   aAdd( aItmFacCli, {"cRetMat"     ,"C", 20, 0, "Matrícula" ,                                                 "Matricula",                   "", "( cDbf )", nil } )
   aAdd( aItmFacCli, {"cNumDoc"     ,"C", 13, 0, "" ,                                                          "",                            "", "( cDbf )", nil } )
   aAdd( aItmFacCli, {"nRegIva"     ,"N",  1, 0, "Régimen de " + cImp() ,                                      "TipoImpuesto",                "", "( cDbf )", nil } ) 
   aAdd( aItmFacCli, {"cCodPro"     ,"C",  9, 0, "Código de proyecto en contabilidad" ,                        "ProyectoContable",            "", "( cDbf )", nil } ) 
   aAdd( aItmFacCli, {"cDocOrg"     ,"C", 10, 0, "Número del documento origen" ,                               "",                            "", "( cDbf )", nil } )
   aAdd( aItmFacCli, {"nNumLiq"     ,"N",  9, 0, "Número liquidación",                                         "NumeroLiquidacion",           "", "( cDbf )", nil } )
   aAdd( aItmFacCli, {"cSufLiq"     ,"C",  2, 0, "Sufijo de la liquidación",                                   "SufijoLiquidacion",           "", "( cDbf )", nil } )
   aAdd( aItmFacCli, {"nImpLiq"     ,"N", 16, 6, "Importe liquidación",                                        "ImporteLiquidacion",          "", "( cDbf )", nil } )
   aAdd( aItmFacCli, {"dFecLiq"     ,"D",  8, 0, "Fecha liquidación",                                          "FechaLiquidacion",            "", "( cDbf )", nil } )
   aAdd( aItmFacCli, {"cCodTrn"     ,"C",  9, 0, "Código del transportista" ,                                  "Transportista",               "", "( cDbf )", nil } )
   aAdd( aItmFacCli, {"nKgsTrn"     ,"N", 16, 6, "TARA del transportista" ,                                    "TaraTransportista",           "", "( cDbf )", nil } )
   aAdd( aItmFacCli, {"lCloFac"     ,"L",  1, 0, "" ,                                                          "DocumentoCerrado",            "", "( cDbf )", nil } )
   aAdd( aItmFacCli, {"cAbnFac"     ,"C", 12, 0, "" ,                                                          "",                            "", "( cDbf )", nil } )
   aAdd( aItmFacCli, {"cAntFac"     ,"C", 12, 0, "Factura de anticipo" ,                                       "",                            "", "( cDbf )", nil } )
   aAdd( aItmFacCli, {"nTipRet"     ,"N",  1, 0, "Tipo de retención ( 1. Base / 2. Base+IVA )",                "TipoRetencion",               "", "( cDbf )", nil } )
   aAdd( aItmFacCli, {"nPctRet"     ,"N",  6, 2, "Porcentaje de retención",                                    "PorcentajeRetencion",         "", "( cDbf )", nil } )
   aAdd( aItmFacCli, {"cCodUsr"     ,"C",  3, 0, "Código de usuario",                                          "Usuario",                     "", "( cDbf )", {|| cCurUsr() } } )
   aAdd( aItmFacCli, {"dFecCre"     ,"D",  8, 0, "Fecha de creación/modificación del documento",               "FechaCreacion",               "", "( cDbf )", {|| Date() } } )
   aAdd( aItmFacCli, {"cTimCre"     ,"C",  5, 0, "Hora de creación/modificación del documento",                "HoraCreacion",                "", "( cDbf )", {|| Time() } } )
   aAdd( aItmFacCli, {"cCodGrp"     ,"C",  4, 0, "Código de grupo de cliente" ,                                "GrupoCliente",                "", "( cDbf )", nil } )
   aAdd( aItmFacCli, {"lImprimido"  ,"L",  1, 0, "Lógico de imprimido" ,                                       "Imprimido",                   "", "( cDbf )", nil } )
   aAdd( aItmFacCli, {"dFecImp"     ,"D",  8, 0, "última fecha de impresión" ,                                 "FechaImpresion",              "", "( cDbf )", nil } )
   aAdd( aItmFacCli, {"cHorImp"     ,"C",  5, 0, "Hora de la última impresión" ,                               "HoraImpresion",               "", "( cDbf )", nil } )
   aAdd( aItmFacCli, {"cCodDlg"     ,"C",  2, 0, "Código Delegación" ,                                         "Delegacion",                  "", "( cDbf )", {|| oUser():cDelegacion() } } )
   aAdd( aItmFacCli, {"nDtoAtp"     ,"N",  6, 2, "Porcentaje de descuento atípico",                            "DescuentoAtipico",            "", "( cDbf )", nil } )
   aAdd( aItmFacCli, {"nSbrAtp"     ,"N",  1, 0, "Lugar donde aplicar dto atípico",                            "LugarAplicarDescuentoAtipico","", "( cDbf )", nil } )
   aAdd( aItmFacCli, {"dFecEntr"    ,"D",  8,  0, "Fecha de entrada de alquiler",                              "EntradaAlquiler",             "", "( cDbf )", nil } )
   aAdd( aItmFacCli, {"dFecSal"     ,"D",  8,  0, "Fecha de salida de alquiler",                               "SalidaAlquiler",              "", "( cDbf )", nil } )
   aAdd( aItmFacCli, {"lAlquiler"   ,"L",  1,  0, "Lógico de alquiler",                                        "Alquiler",                    "", "( cDbf )", nil } )
   aAdd( aItmFacCli, {"lPayCli"     ,"L",  1,  0, "Lógico a pagar por el cliente",                             "",                            "", "( cDbf )", nil } )
   aAdd( aItmFacCli, {"nPayCli"     ,"N", 16,  6, "A pagar por el cliente",                                    "",                            "", "( cDbf )", nil } )
   aAdd( aItmFacCli, {"cManObr"     ,"C",250,  0, "Literal de gastos",                                         "LiteralGastos",               "", "( cDbf )", {|| padr( getConfigTraslation( "Gastos" ), 250 ) } } )
   aAdd( aItmFacCli, {"lExpEdi"     ,"L",  1,  0, "Lógico de factura exportada a EDI",                         "ExportadaEDI",                "", "( cDbf )", nil } )
   aAdd( aItmFacCli, {"dFecEdi"     ,"D",  8,  0, "Fecha exportación a EDI",                                   "FechaExportadaEDI",           "", "( cDbf )", nil } )
   aAdd( aItmFacCli, {"cHorEdi"     ,"C",  5,  0, "Hora exportación a EDI",                                    "HoraExportadaEDI",            "", "( cDbf )", nil } )
   aAdd( aItmFacCli, {"cSuAlb"      ,"C", 25,  0, "Referencia a su albarán",                                   "",                            "", "( cDbf )", nil } )
   aAdd( aItmFacCli, {"lExpFac"     ,"L",  1,  0, "Lógico de factura exportada a Facturae",                    "ExportadoFacturae",           "", "( cDbf )", nil } )
   aAdd( aItmFacCli, {"cTlfCli"     ,"C", 20,  0, "Teléfono del cliente" ,                                     "TelefonoCliente",             "", "( cDbf )", nil } )
   aAdd( aItmFacCli, {"nTotNet"     ,"N", 16,  6, "Total neto" ,                                               "TotalNeto",                   "", "( cDbf )", nil } )
   aAdd( aItmFacCli, {"nTotSup"     ,"N", 16,  6, "Total gastos suplidos" ,                                    "TotalSuplidos",               "", "( cDbf )", nil } )
   aAdd( aItmFacCli, {"nTotIva"     ,"N", 16,  6, "Total " + cImp() ,                                          "TotalImpuesto",               "", "( cDbf )", nil } )
   aAdd( aItmFacCli, {"nTotReq"     ,"N", 16,  6, "Total recargo" ,                                            "TotalRecargo",                "", "( cDbf )", nil } )
   aAdd( aItmFacCli, {"nTotFac"     ,"N", 16,  6, "Total factura" ,                                            "TotalDocumento",              "", "( cDbf )", nil } )
   aAdd( aItmFacCli, {"nEntIni"     ,"N",  6,  2, "Porcentaje de entrega inicial" ,                            "",                            "", "( cDbf )", nil } )
   aAdd( aItmFacCli, {"nPctDto"     ,"N",  6,  2, "Porcentaje de descuento por entrega inicial" ,              "",                            "", "( cDbf )", nil } )
   aAdd( aItmFacCli, {"cNFC"        ,"C", 20,  0, "Código NFC" ,                                               "NFC",                         "", "( cDbf )", nil } )
   aAdd( aItmFacCli, {"cFacPrv"     ,"C", 12,  0, "Factura de proveedor" ,                                     "FacturaProveedor",            "", "( cDbf )", nil } )
   aAdd( aItmFacCli, {"cBanco"      ,"C", 50,  0, "Nombre del banco del cliente" ,                             "NombreBanco",                 "", "( cDbf )", nil } )
   aAdd( aItmFacCli, {"cPaisIBAN"   ,"C",  2,  0, "País IBAN de la cuenta bancaria del cliente",               "CuentaIBAN",                  "", "( cDbf )", nil } )
   aAdd( aItmFacCli, {"cCtrlIBAN"   ,"C",  2,  0, "Dígito de control IBAN de la cuenta bancaria del cliente",  "DigitoControlIBAN",           "", "( cDbf )", nil } )
   aAdd( aItmFacCli, {"cEntBnc"     ,"C",  4,  0, "Entidad de la cuenta bancaria del cliente" ,                "EntidadCuenta",               "", "( cDbf )", nil } )
   aAdd( aItmFacCli, {"cSucBnc"     ,"C",  4,  0, "Sucursal de la cuenta bancaria del cliente" ,               "SucursalCuenta",              "", "( cDbf )", nil } )
   aAdd( aItmFacCli, {"cDigBnc"     ,"C",  2,  0, "Dígito de control de la cuenta bancaria del cliente" ,      "DigitoControlCuenta",         "", "( cDbf )", nil } )
   aAdd( aItmFacCli, {"cCtaBnc"     ,"C", 10,  0, "Cuenta bancaria del cliente" ,                              "CuentaBancaria",              "", "( cDbf )", nil } )
   aAdd( aItmFacCli, {"nTotLiq"     ,"N", 16,  6, "Total liquidado" ,                                          "TotalLiquidado",              "", "( cDbf )", nil } )
   aAdd( aItmFacCli, {"nTotPdt"     ,"N", 16,  6, "Total pendiente" ,                                          "TotalPendiente",              "", "( cDbf )", nil } )
   aAdd( aItmFacCli, {"lOperPV"     ,"L", 1,   0, "Lógico para operar con punto verde" ,                       "OperarPuntoVerde",            "", "( cDbf )", {|| .f. } } )
   aAdd( aItmFacCli, {"lRECC"       ,"L", 1,   0, "Acogida al Régimen especial del criterio de caja",          "AcogidaRECC",                 "", "( cDbf )", {|| .f. } } )
   aAdd( aItmFacCli, {"cCodPry"     ,"C", 4,   0, "Código del proyecto",                                       "Proyecto",                    "", "( cDbf )", nil } )
   aAdd( aItmFacCli, {"nDtoTarifa"  ,"N", 6,   2, "Descuentos de tarifa",                                      "DescuentoTarifa",             "", "( cDbf )", nil } )
   aAdd( aItmFacCli, {"lMail"       ,"L", 1,   0, "Lógico para enviar mail" ,                                  "EnviarMail",                  "", "( cDbf )", nil } )
   aAdd( aItmFacCli, {"dMail"       ,"D", 8,   0, "Fecha mail enviado" ,                                       "FechaMailEnviado",            "", "( cDbf )", nil } )
   aAdd( aItmFacCli, {"tMail"       ,"C", 6,   0, "Hora mail enviado" ,                                        "HoraMailEnviado",             "", "( cDbf )", nil } )
   aAdd( aItmFacCli, {"tFecFac"     ,"C", 6,   0, "Hora de la factura" ,                                       "HoraFactura",                 "", "( cDbf )", {|| getSysTime() } } )
   aAdd( aItmFacCli, {"cCtrCoste"   ,"C", 9,   0, "Código del centro de coste" ,                               "CentroCoste",                 "", "( cDbf )", nil } )
   aAdd( aItmFacCli, { "mFirma"     ,"M", 10,  0, "Firma" ,                                                    "Firma",                       "", "( cDbf )", nil } )                  

RETURN ( aItmFacCli )

//---------------------------------------------------------------------------//

Function aSerFacCli()

   local aColFacCli  := {}

   aAdd( aColFacCli,  { "cSerFac",     "C",  1,   0, "",                                 "",                  "", "( cDbfCol )" } )
   aAdd( aColFacCli,  { "nNumFac",     "N",  9,   0, "",                                 "",                  "", "( cDbfCol )" } )
   aAdd( aColFacCli,  { "cSufFac",     "C",  2,   0, "",                                 "",                  "", "( cDbfCol )" } )
   aAdd( aColFacCli,  { "dFecFac",     "D",  8,   0, "",                                 "",                  "", "( cDbfCol )" } )
   aAdd( aColFacCli,  { "nNumLin",     "N",  4,   0, "Número de la línea",               "'9999'",            "", "( cDbfCol )" } )
   aAdd( aColFacCli,  { "cRef",        "C", 18,   0, "Referencia del artículo",          "",                  "", "( cDbfCol )" } )
   aAdd( aColFacCli,  { "cAlmLin",     "C", 16,   0, "Almacén del artículo",             "",                  "", "( cDbfCol )" } )
   aAdd( aColfacCli,  { "lUndNeg",     "L",  1,   0, "Lógico de unidades en negativo",   "",                  "", "( cDbfCol )" } )
   aAdd( aColFacCli,  { "cNumSer",     "C", 30,   0, "Número de serie",                  "",                  "", "( cDbfCol )" } )

Return ( aColFacCli )

//---------------------------------------------------------------------------//

Function aEntidadesFacCli()

   local aColFacCli  := {}

   aAdd( aColFacCli,  { "cSerFac",     "C",  1,   0, "",                                 "",                  "", "( cDbfCol )" } )
   aAdd( aColFacCli,  { "nNumFac",     "N",  9,   0, "",                                 "",                  "", "( cDbfCol )" } )
   aAdd( aColFacCli,  { "cSufFac",     "C",  2,   0, "",                                 "",                  "", "( cDbfCol )" } )
   aAdd( aColFacCli,  { "cCodEnt",     "C", 60,   0, "Codigo de la Entidad" ,            "",                  "", "( cDbfCol )" } )
   aAdd( aColFacCli,  { "cRol",        "C", 60,   0, "Rol de la entidad",                "",                  "", "( cDbfCol )" } )

Return ( aColFacCli )

//---------------------------------------------------------------------------//

/*
Esta funcion hace los calculos de los totales en la factura
*/

FUNCTION nTotFacCli( cFactura, cFacCliT, cFacCliL, cIva, cDiv, cFacCliP, cAntCliT, aTmp, cDivRet, lPic, lExcCnt, lNeto )

   local nRec
   local nOrd
   local nTotalArt
   local bCondition
   local lRecargo
   local nDtoUno
   local nDtoDos
   local nDtoEsp
   local nTipRet
   local nPctRet
   local nDtoIni
   local nDtoPP
   local nPorte
   local nManObr
   local nIvaMan
   local lIvaInc
   local nSbrAtp
   local nDtoAtp
   local nKgsTrn
   local nTotalLin         := 0
   local nTotalUnd         := 0
   local aTotalDto         := { 0, 0, 0 }
   local aTotalDPP         := { 0, 0, 0 }
   local aTotalUno         := { 0, 0, 0 }
   local aTotalDos         := { 0, 0, 0 }
   local aTotalAtp         := { 0, 0, 0 }
   local aTotalEnt         := { 0, 0, 0 }
   local aTotalBase        := { 0, 0, 0 }
   local nDescuentosLineas := 0
   local lPntVer           := .f.
   local nRegIva
   local nBaseGasto
   local nIvaGasto

   if !empty( nView )

      DEFAULT cFactura     := D():FacturasClientesId( nView ) 
      DEFAULT cFacCliT     := D():FacturasClientes( nView )
      DEFAULT cFacCliL     := D():FacturasClientesLineas( nView )
      DEFAULT cFacCliP     := D():FacturasClientesCobros( nView )
      DEFAULT cAntCliT     := D():AnticiposClientes( nView )

   end if

   DEFAULT cIva            := dbfIva
   DEFAULT cDiv            := dbfDiv
   DEFAULT lPic            := .f.
   DEFAULT lNeto           := .f.

   if empty( Select( cFacCliT ) )
      Return ( 0 )
   end if

   if empty( Select( cFacCliL ) )
      Return ( 0 )
   end if

   if empty( Select( cIva ) )
      Return ( 0 )
   end if

   if empty( Select( cDiv ) )
      Return ( 0 )
   end if

   /*
   Inicializamos las varialbes-------------------------------------------------
   */

   public nTotFac    := 0
   public nTotBrt    := 0
   public nTotDto    := 0
   public nTotDPP    := 0
   public nTotNet    := 0
   public nTotSup    := 0
   public nTotIva    := 0
   public nTotIvm    := 0
   public nTotAge    := 0
   public nTotReq    := 0
   public nTotPnt    := 0
   public nTotUno    := 0
   public nTotDos    := 0
   public nTotRet    := 0
   public nTotTrn    := 0
   public nTotAnt    := 0
   public nTotCos    := 0
   public nTotCob    := 0
   public nTotPes    := 0
   public nTotRnt    := 0
   public nTotAtp    := 0
   public nTotArt    := 0
   public nTotCaj    := 0
   public nTotImp    := 0
   public nTotPctRnt := 0
   public nTotalDto  := 0
   public cCtaCli    := cClientCuenta( ( cFacCliT )->cCodCli )

   public aTotIva    := { { 0,0,nil,0,0,0,0,0,0,0,0 }, { 0,0,nil,0,0,0,0,0,0,0,0 }, { 0,0,nil,0,0,0,0,0,0,0,0 } }
   public aIvaUno    := aTotIva[ 1 ]
   public aIvaDos    := aTotIva[ 2 ]
   public aIvaTre    := aTotIva[ 3 ]

   public aTotIvm    := { { 0,0,0 }, { 0,0,0 }, { 0,0,0 }, }
   public aIvmUno    := aTotIvm[ 1 ]
   public aIvmDos    := aTotIvm[ 2 ]
   public aIvmTre    := aTotIvm[ 3 ]

   public aImpVto    := {}
   public aDatVto    := {}

   nRec              := ( cFacCliL )->( Recno() )

   if aTmp != nil
      nDtoUno        := aTmp[ _NDTOUNO ]
      nDtoDos        := aTmp[ _NDTODOS ]
      lRecargo       := aTmp[ _LRECARGO]
      nDtoEsp        := aTmp[ _NDTOESP ]
      nDtoPP         := aTmp[ _NDPP    ]
      nPorte         := aTmp[ _NPORTES ]
      nManObr        := aTmp[ _NMANOBR ]
      nIvaMan        := aTmp[ _NIVAMAN ]
      lIvaInc        := aTmp[ _LIVAINC ]
      cCodDiv        := aTmp[ _CDIVFAC ]
      nTipRet        := aTmp[ _NTIPRET ]
      nPctRet        := aTmp[ _NPCTRET ]
      nSbrAtp        := aTmp[ _NSBRATP ]
      nDtoAtp        := aTmp[ _NDTOATP ]
      nKgsTrn        := aTmp[ _NKGSTRN ]
      lPntVer        := aTmp[ _LOPERPV ]
      nRegIva        := aTmp[ _NREGIVA ]
      bCondition     := {|| ( cFacCliL )->( !eof() ) }
      ( cFacCliL )->( dbGoTop() )
   else
      nDtoUno        := ( cFacCliT )->nDtoUno
      nDtoDos        := ( cFacCliT )->nDtoDos
      nDtoEsp        := ( cFacCliT )->nDtoEsp
      nDtoPP         := ( cFacCliT )->nDpp
      lRecargo       := ( cFacCliT )->lRecargo
      nPorte         := ( cFacCliT )->nPortes
      nManObr        := ( cFacCliT )->nManObr
      nIvaMan        := ( cFacCliT )->nIvaMan
      lIvaInc        := ( cFacCliT )->lIvaInc
      cCodDiv        := ( cFacCliT )->cDivFac
      nTipRet        := ( cFacCliT )->nTipRet
      nPctRet        := ( cFacCliT )->nPctRet
      nSbrAtp        := ( cFacCliT )->nSbrAtp
      nDtoAtp        := ( cFacCliT )->nDtoAtp
      nKgsTrn        := ( cFacCliT )->nKgsTrn
      lPntVer        := ( cFacCliT )->lOperPV
      nRegIva        := ( cFacCliT )->nRegIva
      bCondition     := {|| ( cFacCliL )->cSerie + str( ( cFacCliL )->nNumFac ) + ( cFacCliL )->cSufFac == cFactura .and. !( cFacCliL )->( eof() ) }
      ( cFacCliL )->( dbSeek( cFactura ) )
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

   while Eval( bCondition )

      if lValLine( cFacCliL )

         if ( lExcCnt == nil                                .or.;    // Entran todos
            ( lExcCnt .and. ( cFacCliL )->nCtlStk != 2 )    .or.;    // Articulos sin contadores
            ( !lExcCnt .and. ( cFacCliL )->nCtlStk == 2 ) )          // Articulos con contadores

            if ( cFacCliL )->lTotLin

               /*
               Esto es para evitar escirbir en el fichero muchas veces
               */

               if ( cFacCliL )->nPreUnit != nTotalLin .OR. ( cFacCliL )->nUniCaja != nTotalUnd

                  if ( cFacCliL )->( dbRLock() )
                     ( cFacCliL )->nPreUnit := nTotalLin
                     ( cFacCliL )->nUniCaja := nTotalUnd
                     ( cFacCliL )->( dbUnLock() )
                  end if

               end if

               /*
               Limpien
               */

               nTotalLin         := 0
               nTotalUnd         := 0

            else

               nTotalArt         := nTotLFacCli( cFacCliL, nDouDiv, nRouDiv, , , .f., .f. )

               nTotTrn           := nTrnLFacCli( cFacCliL, nDouDiv )
               nTotIvm           := nTotIFacCli( cFacCliL, nDouDiv, nRouDiv )

               nTotPnt           := if( lPntVer, nPntLFacCli( cFacCliL, nDpvDiv ), 0 )
               nTotCos           += nCosLFacCli( cFacCliL, nDouDiv, nRouDiv )
               nTotPes           += nPesLFacCli( cFacCliL )

               nDescuentosLineas += nTotDtoLFacCli( cFacCliL, nDouDiv )

               if aTmp != nil
                  nTotAge        += nComLFacCli( aTmp, cFacCliL, nDouDiv, nRouDiv )
               else
                  nTotAge        += nComLFacCli( cFacCliT, cFacCliL, nDouDiv, nRouDiv )
               end if

               /*
               Acumuladores para las lineas de totales
               */

               nTotalLin         += nTotalArt

               if ( cFacCliL )->lGasSup
                  nTotSup        += nTotalArt
               end if

               nTotalUnd         += nTotNFacCli( cFacCliL )

               nTotArt           += nTotNFacCli( cFacCliL )
               nTotCaj           += ( cFacCliL )->nCanEnt

               /*
               Estudio de impuestos--------------------------------------------------
               */

               do case
               case _NPCTIVA1 == nil .OR. _NPCTIVA1 == ( cFacCliL )->nIva

                  _NPCTIVA1      := ( cFacCliL )->nIva

                  if lRecargo
                     _NPCTREQ1   := ( cFacCliL )->nReq
                  end if

                  _NBRTIVA1      += nTotalArt
                  _NIVMIVA1      += nTotIvm
                  _NTRNIVA1      += nTotTrn
                  _NPNTVER1      += nTotPnt

               case _NPCTIVA2 == nil .OR. _NPCTIVA2 == ( cFacCliL )->nIva

                  _NPCTIVA2      := ( cFacCliL )->nIva
                  
                  if lRecargo
                     _NPCTREQ2   := ( cFacCliL )->nReq
                  end if

                  _NBRTIVA2      += nTotalArt
                  _NIVMIVA2      += nTotIvm
                  _NTRNIVA2      += nTotTrn
                  _NPNTVER2      += nTotPnt

               case _NPCTIVA3 == nil .OR. _NPCTIVA3 == ( cFacCliL )->nIva

                  _NPCTIVA3      := ( cFacCliL )->nIva
                  
                  if lRecargo
                     _NPCTREQ3   := ( cFacCliL )->nReq
                  end if

                  _NBRTIVA3      += nTotalArt
                  _NIVMIVA3      += nTotIvm
                  _NTRNIVA3      += nTotTrn
                  _NPNTVER3      += nTotPnt

               end case

               // Estudio de los impuestos especiales--------------------------

               if ( cFacCliL )->nValImp != 0

                  do case
                  case aTotIvm[ 1, 2 ] == 0 .or. ( aTotIvm[ 1, 2 ] == Round( ( cFacCliL )->nValImp, nDouDiv ) )

                     aTotIvm[ 1, 1 ]   += nTotNFacCli( cFacCliL ) * if( ( cFacCliL )->lVolImp, NotCero( ( cFacCliL )->nVolumen ), 1 )
                     aTotIvm[ 1, 2 ]   := Round( ( cFacCliL )->nValImp, nDouDiv )
                     aTotIvm[ 1, 3 ]   := Round( aTotIvm[ 1, 1 ] * aTotIvm[ 1, 2 ], nRouDiv )

                  case aTotIvm[ 2, 2 ] == 0 .or. ( aTotIvm[ 2, 2 ] == Round( ( cFacCliL )->nValImp, nDouDiv ) )

                     aTotIvm[ 2, 1 ]   += nTotNFacCli( cFacCliL ) * if( ( cFacCliL )->lVolImp, NotCero( ( cFacCliL )->nVolumen ), 1 )
                     aTotIvm[ 2, 2 ]   := Round( ( cFacCliL )->nValImp, nDouDiv )
                     aTotIvm[ 2, 3 ]   := Round( aTotIvm[ 2, 1 ] * aTotIvm[ 2, 2 ], nRouDiv )

                  case aTotIvm[ 3, 2 ] == 0 .or. ( aTotIvm[ 3, 2 ] == Round( ( cFacCliL )->nValImp, nDouDiv ) )

                     aTotIvm[ 3, 1 ]   += nTotNFacCli( cFacCliL ) * if( ( cFacCliL )->lVolImp, NotCero( ( cFacCliL )->nVolumen ), 1 )
                     aTotIvm[ 3, 2 ]   := Round( ( cFacCliL )->nValImp, nDouDiv )
                     aTotIvm[ 3, 3 ]   := Round( aTotIvm[ 3, 1 ] * aTotIvm[ 3, 2 ], nRouDiv )

                  end case

               end if

            end if

         else

            /*
            Limpien tambien si tenemos una linea de control
            */

            nTotalLin   := 0
            nTotalUnd   := 0

         end if

      end if

      ( cFacCliL )->( dbSkip() )

   end while

   ( cFacCliL )->( dbGoTo( nRec ) )

   /*
   Ordenamos los impuestos de menor a mayor
   */

   aTotIva           := aSort( aTotIva,,, {|x,y| if( x[3] != nil, x[3], -1 ) > if( y[3] != nil, y[3], -1 )  } )

   _NBASIVA1         := Round( _NBRTIVA1, nRouDiv )
   _NBASIVA2         := Round( _NBRTIVA2, nRouDiv )
   _NBASIVA3         := Round( _NBRTIVA3, nRouDiv )

   nTotBrt           := _NBRTIVA1 + _NBRTIVA2 + _NBRTIVA3

   /*
   Descuentos atipicos sobre base
   */

   if nSbrAtp <= 1 .and. nDtoAtp != 0

      aTotalAtp[1]   := Round( _NBASIVA1 * nDtoAtp / 100, nRouDiv )
      aTotalAtp[2]   := Round( _NBASIVA2 * nDtoAtp / 100, nRouDiv )
      aTotalAtp[3]   := Round( _NBASIVA3 * nDtoAtp / 100, nRouDiv )

      nTotAtp        := aTotalAtp[ 1 ] + aTotalAtp[ 2 ] + aTotalAtp[ 3 ]

   end if

   if nDtoEsp  != 0

      aTotalDto[1]   := Round( _NBASIVA1 * nDtoEsp / 100, nRouDiv )
      aTotalDto[2]   := Round( _NBASIVA2 * nDtoEsp / 100, nRouDiv )
      aTotalDto[3]   := Round( _NBASIVA3 * nDtoEsp / 100, nRouDiv )

      nTotDto        := aTotalDto[1] + aTotalDto[2] + aTotalDto[3]

      _NBASIVA1      -= aTotalDto[1]
      _NBASIVA2      -= aTotalDto[2]
      _NBASIVA3      -= aTotalDto[3]

   end if

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

   if nDtoPP != 0

      aTotalDPP[1]   := Round( _NBASIVA1 * nDtoPP / 100, nRouDiv )
      aTotalDPP[2]   := Round( _NBASIVA2 * nDtoPP / 100, nRouDiv )
      aTotalDPP[3]   := Round( _NBASIVA3 * nDtoPP / 100, nRouDiv )

      nTotDPP        := aTotalDPP[ 1 ] + aTotalDPP[ 2 ] + aTotalDPP[ 3 ]

      _NBASIVA1      -= aTotalDPP[1]
      _NBASIVA2      -= aTotalDPP[2]
      _NBASIVA3      -= aTotalDPP[3]

   end if

   /*
   Descuentos atipicos sobre Dto Pronto Pago
   */

   if nSbrAtp == 3 .and. nDtoAtp != 0

      aTotalAtp[1]   := Round( _NBASIVA1 * nDtoAtp / 100, nRouDiv )
      aTotalAtp[2]   := Round( _NBASIVA2 * nDtoAtp / 100, nRouDiv )
      aTotalAtp[3]   := Round( _NBASIVA3 * nDtoAtp / 100, nRouDiv )

      nTotAtp        := aTotalAtp[ 1 ] + aTotalAtp[ 2 ] + aTotalAtp[ 3 ]

   end if

   if nDtoUno != 0

      aTotalUno[1]   := Round( _NBASIVA1 * nDtoUno / 100, nRouDiv )
      aTotalUno[2]   := Round( _NBASIVA2 * nDtoUno / 100, nRouDiv )
      aTotalUno[3]   := Round( _NBASIVA3 * nDtoUno / 100, nRouDiv )

      nTotUno        := aTotalUno[ 1 ] + aTotalUno[ 2 ] + aTotalUno[ 3 ]

      _NBASIVA1      -= aTotalUno[ 1 ]
      _NBASIVA2      -= aTotalUno[ 2 ]
      _NBASIVA3      -= aTotalUno[ 3 ]

   end if

   /*
   Descuentos atipicos sobre Dto Definido 1
   */

   if nSbrAtp == 4 .and. nDtoAtp != 0

      aTotalAtp[1]   := Round( _NBASIVA1 * nDtoAtp / 100, nRouDiv )
      aTotalAtp[2]   := Round( _NBASIVA2 * nDtoAtp / 100, nRouDiv )
      aTotalAtp[3]   := Round( _NBASIVA3 * nDtoAtp / 100, nRouDiv )

      nTotAtp        := aTotalAtp[ 1 ] + aTotalAtp[ 2 ] + aTotalAtp[ 3 ]

   end if

   if nDtoDos != 0

      aTotalDos[1]   := Round( _NBASIVA1 * nDtoDos / 100, nRouDiv )
      aTotalDos[2]   := Round( _NBASIVA2 * nDtoDos / 100, nRouDiv )
      aTotalDos[3]   := Round( _NBASIVA3 * nDtoDos / 100, nRouDiv )

      nTotDos        := aTotalDos[ 1 ] + aTotalDos[ 2 ] + aTotalDos[ 3 ]

      _NBASIVA1      -= aTotalDos[ 1 ]
      _NBASIVA2      -= aTotalDos[ 2 ]
      _NBASIVA3      -= aTotalDos[ 3 ]

   end if

   /*
   Descuentos atipicos sobre Dto Definido 2
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

   /*
   Total anticipo--------------------------------------------------------------
   */

   if !empty( cAntCliT )

      if aTmp != nil

         nRec                 := ( cAntCliT )->( Recno() )

         ( cAntCliT )->( dbGoTop() )
         while !( cAntCliT )->( eof() )

            if lIvaInc
               nTotAnt        := nTotAntCli( cAntCliT, cIva, cDiv )
            else
               nTotAnt        := nNetAntCli( cAntCliT, cIva, cDiv )
            end if

            if !IsNil( _NPCTIVA1 )
               _NBASIVA1      -= nTotAnt
            end if

            ( cAntCliT )->( dbSkip() )

         end while

         ( cAntCliT )->( dbGoTo( nRec ) )

      else

         nRec                    := ( cAntCliT )->( Recno() )
         nOrd                    := ( cAntCliT )->( OrdSetFocus( "cNumDoc" ) )

         if ( cAntCliT )->( dbSeek( cFactura ) )

            while ( ( cAntCliT )->cNumDoc == cFactura .and. !( cAntCliT )->( eof() ) )

               if lIvaInc
                  nTotAnt        := nTotAntCli( cAntCliT, cIva, cDiv )
               else
                  nTotAnt        := nNetAntCli( cAntCliT, cIva, cDiv )
               end if

               if _NBASIVA1 != 0
                  _NBASIVA1      -= nTotAnt
               end if

               ( cAntCliT )->( dbSkip() )

            end while

         end if

         ( cAntCliT )->( OrdSetFocus( nOrd ) )
         ( cAntCliT )->( dbGoTo( nRec ) )

      end if

   end if

   nTotCob           := nTotalRecibosPagadosFacturasCliente( cFactura, cFacCliT, cFacCliP, cIva, cDiv )

   /*
   Calculamos los impuestosS---------------------------------------------------------
   */

   if lIvaInc

      if lRecargo

         aTotalBase[ 1 ]   := _NBASIVA1 - if( _NPCTIVA1 != nil, Round( _NBASIVA1 / ( Div( 100, _NPCTIVA1 + _NPCTREQ1 ) + 1 ), nRouDiv ), 0 )
         aTotalBase[ 2 ]   := _NBASIVA2 - if( _NPCTIVA2 != nil, Round( _NBASIVA2 / ( Div( 100, _NPCTIVA2 + _NPCTREQ2 ) + 1 ), nRouDiv ), 0 )
         aTotalBase[ 3 ]   := _NBASIVA3 - if( _NPCTIVA3 != nil, Round( _NBASIVA3 / ( Div( 100, _NPCTIVA3 + _NPCTREQ3 ) + 1 ), nRouDiv ), 0 )

         if nRegIva <= 1

            _NIMPIVA1         := if( _NPCTIVA1 != NIL, Round( ( aTotalBase[ 1 ] ) * _NPCTIVA1 / 100, nRouDiv ), 0 )
            _NIMPIVA2         := if( _NPCTIVA2 != NIL, Round( ( aTotalBase[ 2 ] ) * _NPCTIVA2 / 100, nRouDiv ), 0 )
            _NIMPIVA3         := if( _NPCTIVA3 != NIL, Round( ( aTotalBase[ 3 ] ) * _NPCTIVA3 / 100, nRouDiv ), 0 )
      
            _NIMPREQ1         := _NBASIVA1 - aTotalBase[ 1 ] - _NIMPIVA1
            _NIMPREQ2         := _NBASIVA2 - aTotalBase[ 2 ] - _NIMPIVA2
            _NIMPREQ3         := _NBASIVA3 - aTotalBase[ 3 ] - _NIMPIVA3

            _NBASIVA1         -= ( _NIMPIVA1 + _NIMPREQ1 ) 
            _NBASIVA2         -= ( _NIMPIVA2 + _NIMPREQ2 )
            _NBASIVA3         -= ( _NIMPIVA3 + _NIMPREQ3 )

         end if

      else 

         if !uFieldEmpresa( "lIvaImpEsp" )
            _NBASIVA1         -= _NIVMIVA1
            _NBASIVA2         -= _NIVMIVA2
            _NBASIVA3         -= _NIVMIVA3
         end if  

         if nRegIva <= 1

            _NIMPIVA1         := if( _NPCTIVA1 != nil .and. _NPCTIVA1 != 0, Round( _NBASIVA1 / ( 100 / _NPCTIVA1 + 1 ), nRouDiv ), 0 )
            _NIMPIVA2         := if( _NPCTIVA2 != nil .and. _NPCTIVA2 != 0, Round( _NBASIVA2 / ( 100 / _NPCTIVA2 + 1 ), nRouDiv ), 0 )
            _NIMPIVA3         := if( _NPCTIVA3 != nil .and. _NPCTIVA3 != 0, Round( _NBASIVA3 / ( 100 / _NPCTIVA3 + 1 ), nRouDiv ), 0 )

            _NBASIVA1         -= _NIMPIVA1
            _NBASIVA2         -= _NIMPIVA2
            _NBASIVA3         -= _NIMPIVA3

         end if

      end if

      if uFieldEmpresa( "lIvaImpEsp" )
         _NBASIVA1         -= _NIVMIVA1
         _NBASIVA2         -= _NIVMIVA2
         _NBASIVA3         -= _NIVMIVA3
      end if 

      nTotBrt              := Round( _NBASIVA1 + _NBASIVA2 + _NBASIVA3, nRouDiv )

   else

      if nRegIva <= 1

         _NIMPIVA1            := if( _NPCTIVA1 != NIL, Round( _NBASIVA1 * _NPCTIVA1 / 100, nRouDiv ), 0 )
         _NIMPIVA2            := if( _NPCTIVA2 != NIL, Round( _NBASIVA2 * _NPCTIVA2 / 100, nRouDiv ), 0 )
         _NIMPIVA3            := if( _NPCTIVA3 != NIL, Round( _NBASIVA3 * _NPCTIVA3 / 100, nRouDiv ), 0 )

         if lRecargo
            _NIMPREQ1         := if( _NPCTIVA1 != NIL, Round( _NBASIVA1 * _NPCTREQ1 / 100, nRouDiv ), 0 )
            _NIMPREQ2         := if( _NPCTIVA2 != NIL, Round( _NBASIVA2 * _NPCTREQ2 / 100, nRouDiv ), 0 )
            _NIMPREQ3         := if( _NPCTIVA3 != NIL, Round( _NBASIVA3 * _NPCTREQ3 / 100, nRouDiv ), 0 )
         end if

      end if

      if uFieldEmpresa( "lIvaImpEsp" )
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
         _NEXBIVA1   += nBaseGasto
         _NEXIIVA1   += nIvaGasto

      case _NPCTIVA2 == nil .or. _NPCTIVA2 == nIvaMan
         _NPCTIVA2   := nIvaMan
         _NBASIVA2   += nBaseGasto
         _NIMPIVA2   += nIvaGasto
         _NEXBIVA2   += nBaseGasto
         _NEXIIVA2   += nIvaGasto

      case _NPCTIVA3 == nil .or. _NPCTIVA3 == nIvaMan
         _NPCTIVA3   := nIvaMan
         _NBASIVA3   += nBaseGasto
         _NIMPIVA3   += nIvaGasto
         _NEXBIVA3   += nBaseGasto
         _NEXIIVA3   += nIvaGasto

      end case

   end if

   /*
   Redondeo del neto de la factura---------------------------------------------
   */

   nTotNet           := Round( _NBASIVA1 + _NBASIVA2 + _NBASIVA3, nRouDiv )

   /*
   Sumamos los portes al final-------------------------------------------------
   */

   nTotNet           += nPorte

   /*
   Total IVMH
   */

   nTotIvm           := Round( _NIVMIVA1 + _NIVMIVA2 + _NIVMIVA3, nRouDiv )

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
   Total de R.E.---------------------------------------------------------------
   */

   nTotReq           := Round( _NIMPREQ1 + _NIMPREQ2 + _NIMPREQ3, nRouDiv )

   /*
   Total de impuestos
   */

   nTotImp           := Round( nTotIva + nTotReq + nTotIvm, nRouDiv )

   /*
   Total retenciones
   */

   if nTipRet <= 1
      nTotRet        := Round( ( nTotNet - nTotSup ) * nPctRet / 100, nRouDiv )
   else
      nTotRet        := Round( ( nTotNet - nTotSup + nTotIva ) * nPctRet / 100, nRouDiv )
   end if

   /*
   Total rentabilidad----------------------------------------------------------
   */

   nTotRnt           := Round( nTotNet - nManObr - nTotAge - nTotPnt - nTotAtp - nTotCos, nRouDiv )

   nTotPctRnt        := nRentabilidad( nTotNet - nManObr - nTotAge - nTotPnt, nTotAtp, nTotCos )

   /*
   Total facturas
   */

   nTotFac           := Round( nTotNet + nTotImp - nTotRet, nRouDiv )

   /*
   Total de Agentes
   */

   nTotAge           := Round( nTotAge, nRouDiv )

   /*
   Diferencias de pesos
   */

   if nKgsTrn != 0
      nTotalDif      := nKgsTrn - nTotPes
   else
      nTotalDif      := 0
   end if

   /*
   Total de descuentos de la factura-------------------------------------------
   */

   nTotalDto         := nDescuentosLineas + nTotDto + nTotDpp + nTotUno + nTotDos + nTotAtp

   /*
   Estudio de la Forma de Pago-------------------------------------------------
   */

   if !empty( cFacCliP ) .and. ( cFacCliP )->( Used() )

      nRec           := ( cFacCliP )->( Recno() )
      nOrd           := ( cFacCliP )->( OrdSetFocus( "fNumFac" ) )

      if ( cFacCliP )->( dbSeek( cFactura ) )

         while ( cFacCliP )->cSerie + str( ( cFacCliP )->nNumFac ) + ( cFacCliP )->cSufFac == cFactura .and. !( cFacCliP )->( eof() )

            if empty( ( cFacCliP )->cRecDev )
               aAdd( aImpVto, ( cFacCliP )->nImporte )
               aAdd( aDatVto, if( empty( ( cFacCliP )->dFecVto ), ( cFacCliP )->dPreCob,  ( cFacCliP )->dFecVto ) )
            end if 

            ( cFacCliP )->( dbSkip() )

         end while

      end if

      ( cFacCliP )->( OrdSetFocus( nOrd ) )
      ( cFacCliP )->( dbGoTo( nRec ) )

   end if

   /*
   Solicitan una divisa distinta a la q se hizo originalmente la factura-------
   */

   if cDivRet != nil .and. cDivRet != cCodDiv
      nTotNet        := nCnv2Div( nTotNet, cCodDiv, cDivRet )
      nTotIva        := nCnv2Div( nTotIva, cCodDiv, cDivRet )
      nTotReq        := nCnv2Div( nTotReq, cCodDiv, cDivRet )
      nTotFac        := nCnv2Div( nTotFac, cCodDiv, cDivRet )
      nTotRet        := nCnv2Div( nTotRet, cCodDiv, cDivRet )
      nTotPnt        := nCnv2Div( nTotPnt, cCodDiv, cDivRet )
      nTotTrn        := nCnv2Div( nTotTrn, cCodDiv, cDivRet )
      nTotAnt        := nCnv2Div( nTotAnt, cCodDiv, cDivRet )
      cPorDiv        := cPorDiv( cDivRet, cDiv )
   end if

RETURN ( if( lPic, Trans( if( lNeto, nTotNet, nTotFac ), cPorDiv ), if( lNeto, nTotNet, nTotFac ) ) )

//--------------------------------------------------------------------------//

FUNCTION nComLFacCli( cFacCliT, cFacCliL, nDecOut, nDerOut )

   local nImpLFacCli  := nImpLFacCli( cFacCliT, cFacCliL, nDecOut, nDerOut, , .f., .t., .f., .f. )

RETURN ( Round( ( nImpLFacCli * ( cFacCliL )->nComAge / 100 ), nDerOut ) )

//--------------------------------------------------------------------------//

FUNCTION nPesLFacCli( dbfLin )

   local nCalculo

   DEFAULT dbfLin    := D():FacturasClientesLineas( nView )

   if !( dbfLin )->lTotLin
      nCalculo       := Abs( nTotNFacCli( dbfLin ) ) * ( dbfLin )->nPesoKg
   end if

RETURN ( nCalculo )

//---------------------------------------------------------------------------//

FUNCTION nCosLFacCli( dbfLine, nDec, nRec, nVdv, cPouDiv )

   local nCalculo       := 0

   DEFAULT nDec         := nDouDiv()
   DEFAULT nRec         := 0
   DEFAULT nVdv         := 1

   if !( dbfLine )->lKitChl
      nCalculo          := nTotNFacCli( dbfLine )
      nCalculo          *= ( dbfLine )->nCosDiv
   end if

   if nVdv != 0
      nCalculo          := nCalculo / nVdv
   end if

   nCalculo             := Round( nCalculo, nRec )

RETURN ( if( cPouDiv != nil, Trans( nCalculo, cPouDiv ), nCalculo ) )

//--------------------------------------------------------------------------//

//
// Devuelve el punto verde de una linea
//

FUNCTION nPntLFacCli( dbfLin, nDec, nVdv )

   local nPntVer

   DEFAULT dbfLin    := D():FacturasClientesLineas( nView )
   DEFAULT nDec      := nDouDiv()
   DEFAULT nVdv      := 1

   /*
   Punto Verde-----------------------------------------------------------------
   */

   nPntVer           := nPntUFacCli( dbfLin, nDec, nVdv ) * nTotNFacCli( dbfLin )

RETURN ( Round( nPntVer, nDec ) )

//---------------------------------------------------------------------------//

FUNCTION nTotIFacCli( dbfLin, nDec, nRou, nVdv, cPorDiv )

   local nCalculo    := 0

   DEFAULT dbfLin    := D():FacturasClientesLineas( nView )
   DEFAULT nDec      := nDouDiv()
   DEFAULT nRou      := nRouDiv()
   DEFAULT nVdv      := 1

   if !( dbfLin )->lTotLin

      /*
      Tomamos los valores redondeados------------------------------------------
      */

      nCalculo       := Round( ( dbfLin )->nValImp, nDec )

      /*
      Unidades-----------------------------------------------------------------
      */

      nCalculo       *= nTotNFacCli( dbfLin )

      if ( dbfLin )->lVolImp
         nCalculo    *= NotCero( ( dbfLin )->nVolumen )
      end if

      nCalculo       := Round( nCalculo / nVdv, nRou )

   end if

RETURN ( if( cPorDiv != nil, Trans( nCalculo, cPorDiv ), nCalculo ) )

//----------------------------------------------------------------------------//

FUNCTION nTrnLFacCli( dbfLin, nDec, nRou, nVdv )

   local nImpTrn

   DEFAULT dbfLin    := D():FacturasClientesLineas( nView )
   DEFAULT nDec      := nDouDiv()
   DEFAULT nRou      := nRouDiv()
   DEFAULT nVdv      := 1

   /*
   Punto Verde
   */

   nImpTrn           := nTrnUFacCli( dbfLin, nDec ) * nTotNFacCli( dbfLin )

   IF nVdv != 0
      nImpTrn        := nImpTrn / nVdv
   END IF

RETURN ( Round( nImpTrn, nRou ) )

//---------------------------------------------------------------------------//

/*
Devuelve el importe neto de una linea de factura
*/

FUNCTION nImpUFacCli( uFacCliT, uFacCliL, nDec, nVdv, lIva )

   local lIvaInc
   local nCalculo

   DEFAULT nDec   := nDouDiv()
   DEFAULT nVdv   := 1
   DEFAULT lIva   := .f.

   nCalculo       := nTotUFacCli( uFacCliL, nDec, nVdv )

   if IsArray( uFacCliT )

      nCalculo    -= Round( nCalculo * uFacCliT[ _NDTOESP ]  / 100, nDec )
      nCalculo    -= Round( nCalculo * uFacCliT[ _NDPP    ]  / 100, nDec )
      nCalculo    -= Round( nCalculo * uFacCliT[ _NDTOUNO ]  / 100, nDec )
      nCalculo    -= Round( nCalculo * uFacCliT[ _NDTODOS ]  / 100, nDec )
      lIvaInc     := uFacCliT[ _LIVAINC ]

   else

      nCalculo    -= Round( nCalculo * ( uFacCliT )->nDtoEsp / 100, nDec )
      nCalculo    -= Round( nCalculo * ( uFacCliT )->nDpp    / 100, nDec )
      nCalculo    -= Round( nCalculo * ( uFacCliT )->nDtoUno / 100, nDec )
      nCalculo    -= Round( nCalculo * ( uFacCliT )->nDtoDos / 100, nDec )
      lIvaInc     := ( uFacCliT )->lIvaInc

   end if

   if IsArray( uFacCliL )

      if lIva .and. uFacCliL[ _NIVA ] != 0
         if !lIvaInc
            nCalculo    += nCalculo * uFacCliL[ _NIVA ] / 100
         end if
      else
         if lIvaInc .and. uFacCliL[ _NIVA ] != 0
            nCalculo    -= Round( nCalculo / ( 100 / uFacCliL[ _NIVA ] + 1 ), nDec )
         end if
      end if

   else

      if lIva .and. ( uFacCliL )->nIva != 0
         if !lIvaInc
            nCalculo    += nCalculo * ( uFacCliL )->nIva / 100
         end if
      else
         if lIvaInc .and. ( uFacCliL )->nIva != 0
            nCalculo    -= Round( nCalculo / ( 100 / ( uFacCliL )->nIva + 1 ), nDec )
         end if
      end if

   end if

RETURN ( Round( nCalculo, nDec ) )

//---------------------------------------------------------------------------//

//
// Devuelve el importe real de una linea de articulo
//

FUNCTION nImpLFacCli( uFacCliT, uFacCliL, nDec, nRou, nVdv, lIva, lDto, lPntVer, lImpTrn, cPouDiv )

   local lIvaInc
   local nCalculo

   DEFAULT nDec      := nDouDiv()
   DEFAULT nRou      := nRouDiv()
   DEFAULT nVdv      := 1
   DEFAULT lIva      := .f.
   DEFAULT lDto      := .t.
   DEFAULT lPntVer   := .f.
   DEFAULT lImpTrn   := .f.

   nCalculo          := nTotLFacCli( uFacCliL, nDec, nRou, nVdv, .t., lPntVer, lImpTrn )

   if IsArray( uFacCliT )

      nCalculo       -= Round( nCalculo * uFacCliT[ _NDTOESP ]  / 100, nRou )
      nCalculo       -= Round( nCalculo * uFacCliT[ _NDPP    ]  / 100, nRou )
      nCalculo       -= Round( nCalculo * uFacCliT[ _NDTOUNO ]  / 100, nRou )
      nCalculo       -= Round( nCalculo * uFacCliT[ _NDTODOS ]  / 100, nRou )
      lIvaInc        := uFacCliT[ _LIVAINC ]

   else

      nCalculo       -= Round( nCalculo * ( uFacCliT )->nDtoEsp / 100, nRou )
      nCalculo       -= Round( nCalculo * ( uFacCliT )->nDpp    / 100, nRou )
      nCalculo       -= Round( nCalculo * ( uFacCliT )->nDtoUno / 100, nRou )
      nCalculo       -= Round( nCalculo * ( uFacCliT )->nDtoDos / 100, nRou )
      lIvaInc        := ( uFacCliT )->lIvaInc

   end if

   if IsArray( uFacCliL )

      if lIva .and. uFacCliL[ _NIVA ] != 0
         if !lIvaInc
            nCalculo    += nCalculo * uFacCliL[ _NIVA ] / 100
         end if
      else
         if lIvaInc .and. uFacCliL[ _NIVA ] != 0
            nCalculo    -= Round( nCalculo / ( 100 / uFacCliL[ _NIVA ] + 1 ), nRou )
         end if
      end if

   else

      if lIva .and. ( uFacCliL )->nIva != 0
         if !lIvaInc
            nCalculo    += nCalculo * ( uFacCliL )->nIva / 100
         end if
      else
         if lIvaInc .and. ( uFacCliL )->nIva != 0
            nCalculo    -= Round( nCalculo / ( 100 / ( uFacCliL )->nIva + 1 ), nRou )
         end if
      end if

   end if

RETURN ( if( cPouDiv != nil, Trans( nCalculo, cPouDiv ), nCalculo ) )

//---------------------------------------------------------------------------//

/*
Importe unitario del punto verde
*/

FUNCTION nPntUFacCli( dbfTmpLin, nDec, nVdv )

   local nCalculo

   DEFAULT dbfTmpLin := D():FacturasClientesLineas( nView )
   DEFAULT nDec      := nDouDiv()
   DEFAULT nVdv      := 1

   nCalculo          := ( dbfTmpLin )->nPntVer

   if nVdv != 0
      nCalculo       := nCalculo / nVdv
   end if

RETURN ( Round( nCalculo, nDec ) )

//---------------------------------------------------------------------------//

FUNCTION nTrnUFacCli( dbfTmpLin, nDec, nVdv )

   local nCalculo

   DEFAULT nDec      := nDouDiv()
   DEFAULT nVdv      := 1

   nCalculo          := ( dbfTmpLin )->nImpTrn

   IF nVdv != 0
      nCalculo       := nCalculo / nVdv
   END IF

RETURN ( Round( nCalculo, nDec ) )

//---------------------------------------------------------------------------//

Static Function KillTrans()

   /*
   Borramos los ficheros-------------------------------------------------------
   */

   if !empty( dbfTmpLin ) .and. ( dbfTmpLin )->( Used() )
      ( dbfTmpLin )->( dbCloseArea() )
   end if

   if !empty( dbfTmpInc ) .and. ( dbfTmpInc )->( Used() )
      ( dbfTmpInc )->( dbCloseArea() )
   end if

   if !empty( dbfTmpDoc ) .and. ( dbfTmpDoc )->( Used() )
      ( dbfTmpDoc )->( dbCloseArea() )
   end if

   if !empty( dbfTmpAnt ) .and. ( dbfTmpAnt )->( Used() )
      ( dbfTmpAnt )->( dbCloseArea() )
   end if

   if !empty( dbfTmpPgo ) .and. ( dbfTmpPgo )->( Used() )
      ( dbfTmpPgo )->( dbCloseArea() )
   end if

   if !empty( dbfTmpSer ) .and. ( dbfTmpSer )->( Used() )
      ( dbfTmpSer )->( dbCloseArea() )
   end if

   dbfTmpLin      := nil
   dbfTmpInc      := nil
   dbfTmpDoc      := nil
   dbfTmpAnt      := nil
   dbfTmpPgo      := nil
   dbfTmpSer      := nil

   dbfErase( cTmpLin )
   dbfErase( cTmpInc )
   dbfErase( cTmpDoc )
   dbfErase( cTmpAnt )
   dbfErase( cTmpPgo )
   dbfErase( cTmpSer )

   oStock:SetTmpFacCliL()

RETURN NIL

//---------------------------------------------------------------------------//

FUNCTION nDtoUFacCli( dbfTmpLin, nDec, nVdv )

   local nCalculo := ( dbfTmpLin )->nDtoDiv

   DEFAULT nDec   := nDouDiv()
   DEFAULT nVdv   := 1

   IF nVdv != 0
      nCalculo    := ( dbfTmpLin )->nDtoDiv / nVdv
   END IF

RETURN ( round( nCalculo, nDec ) )

//---------------------------------------------------------------------------//

/*
Devuelve el total de una linea con impuestos incluidos
*/

FUNCTION nTotFFacCli( dbfLin, nDec, nRou, nVdv, lDto, lPntVer, lImpTrn, cPorDiv )

   local nCalculo    := 0

   DEFAULT dbfLin    := D():FacturasClientesLineas( nView )
   DEFAULT nDec      := nDouDiv()
   DEFAULT nRou      := nRouDiv()
   DEFAULT nVdv      := 1
   DEFAULT lDto      := .t.
   DEFAULT lPntVer   := .t.
   DEFAULT lImpTrn   := .t.

   nCalculo          += nNoIncLFacCli( dbfLin )
   nCalculo          += nIvaLFacCli( dbfLin, nDec, nRou, nVdv, lDto, lPntVer, lImpTrn )
   nCalculo          += nReqLFacCli( dbfLin, nDec, nRou, nVdv, lDto, lPntVer, lImpTrn )

return ( if( cPorDiv != nil, Trans( nCalculo, cPorDiv ), nCalculo ) )

//---------------------------------------------------------------------------//

FUNCTION checkPagosFacturaCliente( Id, nView )

Return ( ChkLqdFacCli( nil, D():FacturasClientes( nView ), D():FacturasClientesLineas( nView ), D():FacturasClientesCobros( nView ), D():AnticiposClientes( nView ), D():TiposIva( nView ), D():Divisas( nView ) ) )   

//---------------------------------------------------------------------------//
/*
Comprueba si una factura esta liquidada
*/

FUNCTION ChkLqdFacCli( aTmp, cFacCliT, cFacCliL, cFacCliP, cAntCliT, dbfIva, dbfDiv )

   local lChkLqd
   local cFactura
   local nTotal
   local cDivFac
   local nPagFacCli
   local nRec     := ( cFacCliP )->( RecNo() )
   local lLiqAnt

   if aTmp != nil
      cFactura    := aTmp[ _CSERIE  ] + str( aTmp[ _NNUMFAC ] ) + aTmp[ _CSUFFAC ]
      cDivFac     := aTmp[ _CDIVFAC ]
      lLiqAnt     := aTmp[ _LLIQUIDADA ]
   else
      cFactura    := ( cFacCliT )->cSerie + str( ( cFacCliT )->nNumFac ) + ( cFacCliT )->cSufFac
      cDivFac     := ( cFacCliT )->cDivFac
      lLiqAnt     := ( cFacCliT )->lLiquidada
   end if

   nTotal         := abs( nTotFacCli( cFactura, cFacCliT, cFacCliL, dbfIva, dbfDiv, cFacCliP, cAntCliT, nil, nil, .f. ) )
   
   nPagFacCli     := abs( nTotalRecibosPagadosFacturasCliente( cFactura, cFacCliT, cFacCliP, dbfIva, dbfDiv ) )
   nPagFacCli     += abs( nTotAntFacCli( cFactura, cAntCliT, dbfIva, dbfDiv, nil, .f. ) )

   lChkLqd                       := !lMayorIgual( nTotal, nPagFacCli, 0.001 )

   if aTmp != nil
      aTmp[ _LLIQUIDADA ]        := lChkLqd
   end if

   if dbLock( cFacCliT )
      
      ( cFacCliT )->lLiquidada   := lChkLqd
      
      if lLiqAnt != lChkLqd
         ( cFacCliT )->lSndDoc   := .t.
      end if

      ( cFacCliT )->( dbUnLock() )

   end if

   ( cFacCliP )->( dbGoTo( nRec ) )

RETURN ( lChkLqd )

//---------------------------------------------------------------------------//
/*
Devuelve la fecha de una factura de cliente
*/

FUNCTION dFecFacCli( cFacCli, cFacCliT )

   local aStatus
   local dFecFac  := CtoD("")

   if ValType( cFacCliT ) == "O"
      cFacCliT:GetStatus( .t. )
      if cFacCliT:Seek( cFacCli )
         dFecFac  := cFacCliT:dFecFac
      end if
      cFacCliT:SetStatus()
   else
      aStatus  := aGetStatus( cFacCliT, .t. )
      if ( cFacCliT )->( dbSeek( cFacCli ) )
         dFecFac  := ( cFacCliT )->dFecFac
      end if
      SetStatus( cFacCliT, aStatus )
   end if

RETURN ( dFecFac )

//---------------------------------------------------------------------------//
/*
Devuelve la hora de una factura de cliente
*/

FUNCTION tFecFacCli( cFacCli, cFacCliT )

   local aStatus
   local tFecFac  := Replicate( "0", 6 )

   if IsObject( cFacCliT )
      cFacCliT:GetStatus( .t. )
      if cFacCliT:Seek( cFacCli )
         tFecFac  := cFacCliT:tFecFac
      end if
      cFacCliT:SetStatus()
   else
      aStatus  := aGetStatus( cFacCliT, .t. )
      if ( cFacCliT )->( dbSeek( cFacCli ) )
         tFecFac  := ( cFacCliT )->tFecFac
      end if
      SetStatus( cFacCliT, aStatus )
   end if

RETURN ( tFecFac )

//----------------------------------------------------------------------------//

FUNCTION BrowseInformesFacCli( oGet, oGet2 )

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

   aCbxOrd           := { "Número", "Fecha", "Cliente", "Nombre" }
   nOrd              := GetBrwOpt( "BrwFacCli" )
   nOrd              := Min( Max( nOrd, 1 ), len( aCbxOrd ) )
   cCbxOrd           := aCbxOrd[ nOrd ]

   DEFINE DIALOG oDlg RESOURCE "HELPENTRY" TITLE "Facturas de clientes"

      REDEFINE GET oGet1 VAR cGet1;
         ID       104 ;
         ON CHANGE( AutoSeek( nKey, nFlags, Self, oBrw, D():FacturasClientes( nView ), nil, nil, .f. ) );
         VALID    ( OrdClearScope( oBrw, D():FacturasClientes( nView ) ) );
         BITMAP   "FIND" ;
         OF       oDlg

      REDEFINE COMBOBOX oCbxOrd ;
         VAR      cCbxOrd ;
         ID       102 ;
         ITEMS    aCbxOrd ;
         ON CHANGE( ( D():FacturasClientes( nView ) )->( OrdSetFocus( oCbxOrd:nAt ) ), oBrw:refresh(), oGet1:SetFocus() ) ;
         OF       oDlg

      oBrw                 := IXBrowse():New( oDlg )

      oBrw:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrw:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrw:cAlias          := D():FacturasClientes( nView )
      oBrw:nMarqueeStyle   := 5
      oBrw:cName           := "Factura de cliente.Browse informes"

      oBrw:bLDblClick      := {|| oDlg:end( IDOK ) }

      oBrw:CreateFromResource( 105 )

      with object ( oBrw:AddCol() )
         :cHeader          := "Número"
         :cSortOrder       := "nNumFac"
         :bEditValue       := {|| ( D():FacturasClientes( nView ) )->cSerie + "/" + RTrim( str( ( D():FacturasClientes( nView ) )->nNumFac ) ) + "/" + ( D():FacturasClientes( nView ) )->cSufFac }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Fecha"
         :cSortOrder       := "dFecFac"
         :bEditValue       := {|| Dtoc( ( D():FacturasClientes( nView ) )->dFecFac ) }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Cliente"
         :cSortOrder       := "cCodCli"
         :bEditValue       := {|| Rtrim( ( D():FacturasClientes( nView ) )->cCodCli ) }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Nombre"
         :cSortOrder       := "cNomCli"
         :bEditValue       := {|| Rtrim( ( D():FacturasClientes( nView ) )->cNomCli ) }
         :nWidth           := 180
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Importe"
         :bEditValue       := {|| nTotFacCli( D():FacturasClientesId( nView ), D():FacturasClientes( nView ), D():FacturasClientesLineas( nView ), dbfIva, dbfDiv, D():FacturasClientesCobros( nView ), D():AnticiposClientes( nView ), nil, cDivEmp(), .t. ) }
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
      oGet:cText( ( D():FacturasClientes( nView ) )->cSerie + str( ( D():FacturasClientes( nView ) )->nNumFac ) + ( D():FacturasClientes( nView ) )->cSufFac )
      oGet2:cText( ( D():FacturasClientes( nView ) )->cNomCli )
   end if

   SetBrwOpt( "BrwFacCli", ( D():FacturasClientes( nView ) )->( OrdNumber() ) )

   ( D():FacturasClientes( nView ) )->( dbClearFilter() )

   CloseFiles()

   /*
    Guardamos los datos del browse-------------------------------------------
   */

   oBrw:CloseData()

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

FUNCTION lValidInformeFacCli( oGet, oGet2 )

   local lClose   := .f.
   local lValid   := .f.
   local xValor   := oGet:varGet()

   if empty( xValor )
      return .t.
   end if

   if !OpenFiles()
      Return .f.
   end if

   if ( D():FacturasClientes( nView ) )->( dbSeek( xValor ) )

      oGet:cText( ( D():FacturasClientes( nView ) )->cSerie + str( ( D():FacturasClientes( nView ) )->nNumFac ) + ( D():FacturasClientes( nView ) )->cSufFac )
      oGet2:cText( ( D():FacturasClientes( nView ) )->cNomCli )

      lValid   := .t.

   else

      msgStop( "Factura no encontrada" )

   end if

   CloseFiles()

RETURN lValid

//---------------------------------------------------------------------------//

Function dJuliano4FacCli( cFacCliL )

   DEFAULT cFacCliL  := D():FacturasClientesLineas( nView )

RETURN ( AddMonth( JulianoToDate( , Val( ( cFacCliL )->cLote ) ), 4 ) )

//---------------------------------------------------------------------------//

Function dJulianoFacCli( cFacCliL )

   DEFAULT cFacCliL  := D():FacturasClientesLineas( nView )

RETURN ( AddMonth( JulianoToDate( , Val( ( cFacCliL )->cLote ) ), 6 ) )

//---------------------------------------------------------------------------//

FUNCTION nTotalRecibosGeneradosFacturasCliente( cFactura, cFacCliT, dbfFacCliP, dbfIva, dbfDiv, cDivRet )

Return ( nPagFacCli( cFactura, cFacCliT, dbfFacCliP, dbfIva, dbfDiv, cDivRet, .f., .f. ) )

//---------------------------------------------------------------------------//

FUNCTION nTotalRecibosPagadosFacturasCliente( cFactura, cFacCliT, dbfFacCliP, dbfIva, dbfDiv, cDivRet )

Return ( nPagFacCli( cFactura, cFacCliT, dbfFacCliP, dbfIva, dbfDiv, cDivRet, .t., .f. ) )

//---------------------------------------------------------------------------//
/*
Devuelve el total de pagos de una factura
*/

FUNCTION nPagFacCli( cFactura, cFacCliT, dbfFacCliP, dbfIva, dbfDiv, cDivRet, lOnlyCob, lPic )

   local nOrd
   local nRec
   local cPorDiv
   local nRouDiv        := 2
   local nTotalPagado   := 0
   local cCodDiv        := cDivEmp()

   DEFAULT lOnlyCob     := .t.
   DEFAULT lPic         := .f.

   /*
   Estan todas en uso----------------------------------------------------------
   */

   if empty( Select( cFacCliT ) )
      Return ( 0 )
   end if

   if empty( Select( dbfFacCliP ) )
      Return ( 0 )
   end if

   if empty( Select( dbfIva ) )
      Return ( 0 )
   end if

   if empty( Select( dbfDiv ) )
      Return ( 0 )
   end if

   /*
   Si nos pasan la divisa tomamos el valor de la misma-------------------------
   */

   cCodDiv              := ( dbfFacCliP )->cDivPgo
   cPorDiv              := cPorDiv( cCodDiv, dbfDiv ) // Picture de la divisa redondeada
   nRouDiv              := nRouDiv( cCodDiv, dbfDiv )

   if empty( cFactura )
      
      nRec              := ( dbfFacCliP )->( Recno() )

      ( dbfFacCliP )->( dbGoTop() )
      while !( dbfFacCliP )->( Eof() )

         if ( lOnlyCob .and. ( dbfFacCliP )->lCobrado .and. !( dbfFacCliP )->lDevuelto ) .or. !lOnlyCob .and. !( dbfFacCliP )->lDevuelto

            nTotalPagado+= ( dbfFacCliP )->nImporte

         end if

         ( dbfFacCliP )->( dbSkip() )

      end while

      ( dbfFacCliP )->( dbGoTo( nRec ) )

   else

      nRec              := ( dbfFacCliP )->( Recno() )
      nOrd              := ( dbfFacCliP )->( OrdSetFocus( "fNumFac" ) )

      if ( dbfFacCliP )->( dbSeek( cFactura ) )
         while ( ( dbfFacCliP )->cSerie + str( ( dbfFacCliP )->nNumFac ) + ( dbfFacCliP )->cSufFac == cFactura )

            if ( lOnlyCob .and. ( dbfFacCliP )->lCobrado .and. !( dbfFacCliP )->lDevuelto ) .or. ( !lOnlyCob .and. !( dbfFacCliP )->lDevuelto )

               nTotalPagado+= ( dbfFacCliP )->nImporte

            end if

            ( dbfFacCliP )->( dbSkip() )

         end while
      end if

      ( dbfFacCliP )->( OrdSetFocus( nOrd ) )
      ( dbfFacCliP )->( dbGoTo( nRec ) )

   end if

   if cDivRet != nil .and. cCodDiv != cDivRet
      nTotalPagado      := nCnv2Div( nTotalPagado, cCodDiv, cDivRet )
      cPorDiv           := cPorDiv( cDivRet, dbfDiv ) // Picture de la divisa redondeada
      nRouDiv           := nRouDiv( cDivRet, dbfDiv )
   end if

   nTotalPagado         := Round( nTotalPagado, nRouDiv )

   if lPic
      nTotalPagado      := Trans( nTotalPagado, cPorDiv )
   end if

RETURN ( nTotalPagado )

//---------------------------------------------------------------------------//


FUNCTION cChkPagFacCli( cFacCli, cFacCliT, dbfFacCliP )

   local cChkPag        := ""
   local nChkPag        := nChkPagFacCli( cFacCli, cFacCliT, dbfFacCliP )

   do case
      case nChkPag == 1
         cChkPag        := "Cobrado"

      case nChkPag == 2
         cChkPag        := "Parcialmente"

      case nChkPag == 3
         cChkPag        := "Pendiente"

   end case

RETURN ( cChkPag )

//---------------------------------------------------------------------------//

FUNCTION nChkPagFacCli( cFacCli, cFacCliT, dbfFacCliP )

   local nOrd
   local nBitmap        := 3

   if ( cFacCliT )->lLiquidada
      Return ( 1 )
   end if

   nOrd                 := ( dbfFacCliP )->( ordsetfocus( "fNumFac" ) )
   
   if ( dbfFacCliP )->( dbSeek( cFacCli ) )

      while ( dbfFacCliP )->cSerie + str( ( dbfFacCliP )->nNumFac ) + ( dbfFacCliP )->cSufFac == cFacCli .and. !( dbfFacCliP )->( eof() )

         if ( dbfFaccliP )->lCobrado .and. !( dbfFacCliP )->lDevuelto

            nBitmap     := 2
            
            exit

         end if

         ( dbfFacCliP )->( dbSkip() )

      end while

   end if

   ( dbfFacCliP )->( ordsetfocus( nOrd ) )

RETURN ( nBitmap )

//---------------------------------------------------------------------------//

/*
Funcion exclusiva para envases Bodegas Raposo
*/

Function nStockLineaFacCli()

Return ( oStock:nTotStockAct( ( D():FacturasClientesLineas( nView ) )->cRef, ( D():FacturasClientesLineas( nView ) )->cAlmLin, ( D():FacturasClientesLineas( nView ) )->cValPr1, ( D():FacturasClientesLineas( nView ) )->cValPr2 ) )

//---------------------------------------------------------------------------//

Function FacturasClientesId()

Return ( D():FacturasClientesId( nView ) )

//---------------------------------------------------------------------------//

Function cTotFacCli()

Return ( Num2Text( nTotFac ) )

//---------------------------------------------------------------------------//
/*
Funcion que nos indica si una factura está rectificada o no--------------------
*/

Function lRectificadaCli( cNumFac, cFacCliT, cFacRecT )

   local lRectificada   := .f.

   DEFAULT cFacCliT     := D():FacturasClientes( nView )
   DEFAULT cFacRecT     := dbfFacRecT
   DEFAULT cNumFac      := ( cFacCliT )->cSerie + str( ( cFacCliT )->nNumFac ) + ( cFacCliT )->cSufFac

   if dbSeekInOrd( cNumFac, "CNUMFAC", cFacRecT )
      lRectificada      := .t.
   end if

return ( lRectificada )

//---------------------------------------------------------------------------//

Function dFechaUltimaVenta( cCodCli, cCodArt, dbfAlbCliL, dbfFacCliL, dbfTikL )

   local nRecAlbL          
   local nRecFacL          
   local nOrdAlbL          
   local nOrdFacL          
   local dUltimaFactura    
   local dUltimoAlbaran    

   CursorWait()

   nRecAlbL                := ( dbfAlbCliL )->( Recno() )
   nRecFacL                := ( dbfFacCliL )->( Recno() )
   nOrdAlbL                := ( dbfAlbCliL )->( OrdSetFocus( "cRefFec" ) )
   nOrdFacL                := ( dbfFacCliL )->( OrdSetFocus( "cRefFec" ) )
   dUltimaFactura          := ctod( "" )
   dUltimoAlbaran          := ctod( "" )

   /*
   Buscamos por los albaranes no facturados-----------------------------------
   */

   if ( dbfAlbCliL )->( dbSeek( cCodArt + cCodCli ) )
      dUltimoAlbaran       := ( dbfAlbCliL )->dFecAlb 
   end if

   /*
   Buscamos ahora por las facturas---------------------------------------------
   */
   
   if ( dbfFacCliL )->( dbSeek( cCodArt + cCodCli ) )
      dUltimaFactura       := ( dbfFacCliL )->dFecFac
   end if

   /*
   Dejamos las tablas como estaban---------------------------------------------
   */

   ( dbfAlbCliL )->( OrdSetFocus( nOrdAlbL ) )
   ( dbfFacCliL )->( OrdSetFocus( nOrdFacL ) )
   ( dbfAlbCliL )->( dbGoTo( nRecAlbL ) )
   ( dbfFacCliL )->( dbGoTo( nRecFacL ) )

   CursorWE()

Return ( if( dUltimaFactura > dUltimoAlbaran, dUltimaFactura, dUltimoAlbaran ) )

//---------------------------------------------------------------------------//

Function nUnidadesUltimaVenta( cCodCli, cCodArt, dbfAlbCliL, dbfFacCliL, dbfTikL )

   local nUnidades      := 0
   local nRecAlbL       := ( dbfAlbCliL )->( Recno() )
   local nRecFacL       := ( dbfFacCliL )->( Recno() )
   local nOrdAlbL       := ( dbfAlbCliL )->( OrdSetFocus( "cRefFec" ) )
   local nOrdFacL       := ( dbfFacCliL )->( OrdSetFocus( "cRefFec" ) )
   local dUltimaFactura := ctod( "" )
   local dUltimoAlbaran := ctod( "" )

   CursorWait()

   /*
   Buscamos por los Facturas no facturados-----------------------------------
   */

   if ( dbfAlbCliL )->( dbSeek( cCodArt + cCodCli ) )
      dUltimoAlbaran     := ( dbfAlbCliL )->dFecAlb 
   end if

   /*
   Buscamos ahora por loas facturas--------------------------------------------
   */

   if ( dbfFacCliL )->( dbSeek( cCodArt + cCodCli ) )
      dUltimaFactura     := ( dbfFacCliL )->dFecFac
   end if

   if !empty(dUltimaFactura) .or. !empty(dUltimoAlbaran)

      if ( dUltimaFactura > dUltimoAlbaran )
         nUnidades      := nTotNFacCli( dbfFacCliL )
      else 
         nUnidades      := nTotNAlbCli( dbfAlbCliL )
      end if

   end if

   /*
   Dejamos las tablas como estaban------------------------------------------
   */

   ( dbfAlbCliL )->( OrdSetFocus( nOrdAlbL ) )
   ( dbfFacCliL )->( OrdSetFocus( nOrdFacL ) )
   ( dbfAlbCliL )->( dbGoTo( nRecAlbL ) )
   ( dbfFacCliL )->( dbGoTo( nRecFacL ) )

   CursorWE()

Return ( nUnidades )

//---------------------------------------------------------------------------//

Function nPrecioUltimaVenta( cCodCli, cCodArt, dbfAlbCliL, dbfFacCliL, dbfTikL )

   local nPrecio           := 0
   local nRecAlbL          := ( dbfAlbCliL )->( Recno() )
   local nRecFacL          := ( dbfFacCliL )->( Recno() )
   local nOrdAlbL          := ( dbfAlbCliL )->( OrdSetFocus( "cRefFec" ) )
   local nOrdFacL          := ( dbfFacCliL )->( OrdSetFocus( "cRefFec" ) )
   local dUltimaFactura    := ctod( "" )
   local dUltimoAlbaran    := ctod( "" )

   CursorWait()

   /*
   Buscamos por los Facturas no facturados-----------------------------------
   */

   if ( dbfAlbCliL )->( dbSeek( cCodArt + cCodCli ) )
      dUltimoAlbaran       := ( dbfAlbCliL )->dFecAlb 
   end if

   /*
   Buscamos ahora por loas facturas--------------------------------------------
   */

   if ( dbfFacCliL )->( dbSeek( cCodArt + cCodCli ) )
      dUltimaFactura       := ( dbfFacCliL )->dFecFac
   end if

   if !empty(dUltimaFactura) .or. !empty(dUltimoAlbaran)

      if ( dUltimaFactura > dUltimoAlbaran )
         nPrecio           := ( dbfFacCliL )->nPreUnit
      else 
         nPrecio           := ( dbfAlbCliL )->nPreUnit
      end if

   end if

   /*
   Dejamos las tablas como estaban------------------------------------------
   */

   ( dbfAlbCliL )->( OrdSetFocus( nOrdAlbL ) )
   ( dbfFacCliL )->( OrdSetFocus( nOrdFacL ) )
   ( dbfAlbCliL )->( dbGoTo( nRecAlbL ) )
   ( dbfFacCliL )->( dbGoTo( nRecFacL ) )

   CursorWE()

Return ( nPrecio )

//---------------------------------------------------------------------------//

Function dUltimaVentaCliente( cCodCli )

   local dUltimaFactura    := AlbaranesClientesModel():UltimoDocumento( cCodCli )
   local dUltimoAlbaran    := FacturasClientesModel():UltimoDocumento( cCodCli )

Return ( if( dUltimaFactura > dUltimoAlbaran, dUltimaFactura, dUltimoAlbaran ) )

//---------------------------------------------------------------------------//

Function dPrimeraVentaCliente( cCodCli, nView )

   local dPrimeraVentaCliente    := ctod( "" )

   CursorWait()

   D():getStatusPedidosClientes( nView )
   D():setFocusPedidosClientes( "cCodCli", nView )

   if ( D():PedidosClientes( nView ) )->( dbseek( cCodCli ) )
      while ( D():PedidosClientes( nView ) )->cCodCli == cCodCli .and. !( D():PedidosClientes( nView ) )->( eof() )
         if empty( dPrimeraVentaCliente ) .or. ( ( D():PedidosClientes( nView ) )->dFecPed < dPrimeraVentaCliente )
            dPrimeraVentaCliente := ( D():PedidosClientes( nView ) )->dFecPed
         end if 
         ( D():PedidosClientes( nView ) )->( dbskip() )
      end while
   end if

   D():setStatusPedidosClientes( nView )

   D():getStatusAlbaranesClientes( nView )
   D():setFocusAlbaranesClientes( "cCodCli", nView )

   if ( D():AlbaranesClientes( nView ) )->( dbseek( cCodCli ) )
      while ( D():AlbaranesClientes( nView ) )->cCodCli == cCodCli .and. !( D():AlbaranesClientes( nView ) )->( eof() )
         if empty( dPrimeraVentaCliente ) .or. ( ( D():AlbaranesClientes( nView ) )->dFecAlb < dPrimeraVentaCliente )
            dPrimeraVentaCliente := ( D():AlbaranesClientes( nView ) )->dFecAlb
         end if 
         ( D():AlbaranesClientes( nView ) )->( dbskip() )
      end while
   end if

   D():setStatusFacturasClientes( nView )

   D():getStatusFacturasClientes( nView )
   D():setFocusFacturasClientes( "cCodCli", nView )

   if ( D():FacturasClientes( nView ) )->( dbseek( cCodCli ) )
      while ( D():FacturasClientes( nView ) )->cCodCli == cCodCli .and. !( D():FacturasClientes( nView ) )->( eof() )
         if empty( dPrimeraVentaCliente ) .or. ( ( D():FacturasClientes( nView ) )->dFecFac < dPrimeraVentaCliente )
            dPrimeraVentaCliente := ( D():FacturasClientes( nView ) )->dFecFac
         end if 
         ( D():FacturasClientes( nView ) )->( dbskip() )
      end while
   end if

   D():setStatusFacturasClientes( nView )

   CursorWE()

Return ( dPrimeraVentaCliente )

//---------------------------------------------------------------------------//

Function FacturaClienteLineaOrdSetFocus( cOrd )

   ( D():FacturasClientesLineas( nView ) )->( OrdSetFocus( cOrd ) )

Return .t.

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS TFacturasClientesSenderReciver FROM TSenderReciverItem

   Data lSuccesfullSendFacturas
   Data lSuccesfullSendAnticipos

   Data nFacturaNumberSend
   Data nAnticipoNumberSend

   Method CreateData()
   Method RestoreData()
   Method SendData()
   
   Method ReciveData()
   Method ReciveFrq()

   Method Process()
   Method ProcessFrq()   

   Method nGetFacturaNumberToSend()    INLINE ( ::nFacturaNumberSend    := GetPvProfInt( "Numero", "Facturas clientes", ::nFacturaNumberSend, ::cIniFile ) )
   Method nGetAnticipoNumberToSend()   INLINE ( ::nAnticipoNumberSend   := GetPvProfInt( "Numero", "Anticipos clientes", ::nAnticipoNumberSend, ::cIniFile ) )

   Method IncFacturaNumberToSend()     INLINE ( WritePProString( "Numero", "Facturas clientes",    cValToChar( ++::nFacturaNumberSend ),  ::cIniFile ) )
   Method IncAnticipoNumberToSend()    INLINE ( WritePProString( "Numero", "Anticipos clientes",   cValToChar( ++::nAnticipoNumberSend ), ::cIniFile ) )

   Method validateRecepcion()

   Method validateRecepcionRecibo( tmpFacCliP, dbfFacCliP )

END CLASS

//----------------------------------------------------------------------------//

Method CreateData() CLASS TFacturasClientesSenderReciver

   local nOrd
   local oBlock
   local oError
   local dbfFacCliT
   local dbfFacCliL
   local dbfFacCliI
   local dbfFacCliP
   local dbfAntCliT
   local tmpFacCliT
   local tmpFacCliL
   local tmpFacCliP
   local tmpFacCliI
   local tmpAntCliT
   local lSndFacCli           := .f.
   local lSndAntCli           := .f.
   local cFileNameFacturas
   local cFileNameAnticipos

   if ::oSender:lServer
      cFileNameFacturas       := "FacCli" + StrZero( ::nGetFacturaNumberToSend(), 6 ) + ".All"
      cFileNameAnticipos      := "AntCli" + StrZero( ::nGetAnticipoNumberToSend(), 6 ) + ".All"
   else
      cFileNameFacturas       := "FacCli" + StrZero( ::nGetFacturaNumberToSend(), 6 ) + "." + RetSufEmp()
      cFileNameAnticipos      := "AntCli" + StrZero( ::nGetAnticipoNumberToSend(), 6 ) + "." + RetSufEmp() 
   end if

   oBlock            := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   USE ( cPatEmp() + "FacCliT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FacCliT", @dbfFacCliT ) )
   SET ADSINDEX TO ( cPatEmp() + "FacCliT.CDX" ) ADDITIVE

   USE ( cPatEmp() + "FacCliL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FacCliL", @dbfFacCliL ) )
   SET ADSINDEX TO ( cPatEmp() + "FacCliL.Cdx" ) ADDITIVE

   USE ( cPatEmp() + "FacCliP.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FacCliP", @dbfFacCliP ) )
   SET ADSINDEX TO ( cPatEmp() + "FacCliP.CDX" ) ADDITIVE

   USE ( cPatEmp() + "FacCliI.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FacCliI", @dbfFacCliI ) )
   SET ADSINDEX TO ( cPatEmp() + "FacCliI.CDX" ) ADDITIVE

   USE ( cPatEmp() + "AntCliT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "AntCliT", @dbfAntCliT ) )
   SET ADSINDEX TO ( cPatEmp() + "AntCliT.CDX" ) ADDITIVE
   ( dbfAntCliT )->( OrdSetFocus( "cNumDoc" ) )
 
   // Creamos todas las bases de datos relacionadas 

   mkFacCli( cPatSnd() )

   mkRecCli( cPatSnd() )

   USE ( cPatSnd() + "FacCliT.DBF" ) NEW VIA ( cLocalDriver() ) SHARED ALIAS ( cCheckArea( "FacCliT", @tmpFacCliT ) )
   SET INDEX TO ( cPatSnd() + "FacCliT.CDX" ) ADDITIVE

   USE ( cPatSnd() + "FacCliL.DBF" ) NEW VIA ( cLocalDriver() ) SHARED ALIAS ( cCheckArea( "FacCliL", @tmpFacCliL ) )
   SET INDEX TO ( cPatSnd() + "FacCliL.Cdx" ) ADDITIVE

   USE ( cPatSnd() + "FacCliP.DBF" ) NEW VIA ( cLocalDriver() ) SHARED ALIAS ( cCheckArea( "FacCliP", @tmpFacCliP ) )
   SET INDEX TO ( cPatSnd() + "FacCliP.CDX" ) ADDITIVE

   USE ( cPatSnd() + "FacCliI.DBF" ) NEW VIA ( cLocalDriver() ) SHARED ALIAS ( cCheckArea( "FacCliI", @tmpFacCliI ) )
   SET INDEX TO ( cPatSnd() + "FacCliI.CDX" ) ADDITIVE

   if !empty( ::oSender:oMtr )
      ::oSender:oMtr:nTotal := ( dbfFacCliT )->( LastRec() )
   end if

   ::oSender:SetText( "Enviando facturas de clientes" )

   nOrd  := ( dbfFacCliT )->( OrdSetFocus( "lSndDoc" ) )

   if ( dbfFacCliT )->( dbSeek( .t. ) )
      while !( dbfFacCliT )->( eof() )

         if ( dbfFacCliT )->lSndDoc

            lSndFacCli  := .t.

            dbPass( dbfFacCliT, tmpFacCliT, .t. )
            ::oSender:SetText( ( dbfFacCliT )->cSerie + "/" + AllTrim( str( ( dbfFacCliT )->nNumFac ) ) + "/" + AllTrim( ( dbfFacCliT )->cSufFac ) + "; " + Dtoc( ( dbfFacCliT )->dFecFac ) + ";" + AllTrim( ( dbfFacCliT )->cCodCli ) + "; " + ( dbfFacCliT )->cNomCli )

            if ( dbfFacCliL )->( dbSeek( ( dbfFacCliT )->cSerie + str( ( dbfFacCliT )->nNumFac ) + ( dbfFacCliT )->cSufFac ) )
               while ( ( dbfFacCliL )->cSerie + str( ( dbfFacCliL )->nNumFac ) + ( dbfFacCliL )->cSufFac ) == ( ( dbfFacCliT )->cSerie + str( ( dbfFacCliT )->nNumFac ) + ( dbfFacCliT )->cSufFac ) .AND. !( dbfFacCliL )->( eof() )
                  dbPass( dbfFacCliL, tmpFacCliL, .t. )
                  ( dbfFacCliL )->( dbSkip() )
               end do
            end if

            if ( dbfFacCliI )->( dbSeek( ( dbfFacCliT )->cSerie + str( ( dbfFacCliT )->nNumFac ) + ( dbfFacCliT )->cSufFac ) )
               while ( ( dbfFacCliI )->cSerie + str( ( dbfFacCliI )->nNumFac ) + ( dbfFacCliI )->cSufFac ) == ( ( dbfFacCliT )->cSerie + str( ( dbfFacCliT )->nNumFac ) + ( dbfFacCliT )->cSufFac ) .AND. !( dbfFacCliI )->( eof() )
                  dbPass( dbfFacCliI, tmpFacCliI, .t. )
                  ( dbfFacCliI )->( dbSkip() )
               end do
            end if

            if ( dbfFacCliP )->( dbSeek( ( dbfFacCliT )->cSerie + str( ( dbfFacCliT )->nNumFac ) + ( dbfFacCliT )->cSufFac ) )
               while ( ( dbfFacCliP )->cSerie + str( ( dbfFacCliP )->nNumFac ) + ( dbfFacCliP )->cSufFac ) == ( ( dbfFacCliT )->cSerie + str( ( dbfFacCliT )->nNumFac ) + ( dbfFacCliT )->cSufFac ) .AND. !( dbfFacCliP )->( eof() )
                  dbPass( dbfFacCliP, tmpFacCliP, .t. )
                  ( dbfFacCliP )->( dbSkip() )
               end do
            end if

            if ( dbfAntCliT )->( dbSeek( ( dbfFacCliT )->cSerie + str( ( dbfFacCliT )->nNumFac ) + ( dbfFacCliT )->cSufFac ) )
               while ( ( dbfFacCliT )->cSerie + str( ( dbfFacCliT )->nNumFac ) + ( dbfFacCliT )->cSufFac == ( dbfAntCliT )->cNumDoc .and. !( dbfAntCliT )->( eof() ) )
                  if !( dbfAntCliT )->lSndDoc .and. ( dbfAntCliT )->( dbRLock() )
                     ( dbfAntCliT )->lSndDoc := .t.
                     ( dbfAntCliT )->( dbUnlock() )
                  end if
                  ( dbfAntCliT )->( dbSkip() )
               end while
            end if

         end if

         ( dbfFacCliT )->( dbSkip() )

         if !empty( ::oSender:oMtr )
            ::oSender:oMtr:Set( ( dbfFacCliT )->( OrdKeyNo() ) )
         end if

      end do
   end if

   ( dbfFacCliT )->( OrdSetFocus( nOrd ) )

   CLOSE ( dbfFacCliT )
   CLOSE ( dbfFacCliL )
   CLOSE ( dbfFacCliP )
   CLOSE ( dbfFacCliI )
   CLOSE ( dbfAntCliT )
   CLOSE ( tmpFacCliT )
   CLOSE ( tmpFacCliL )
   CLOSE ( tmpFacCliP )
   CLOSE ( tmpFacCliI )

   if lSndFacCli

      ::oSender:SetText( "Comprimiendo facturas de clientes" )

      if ::oSender:lZipData( cFileNameFacturas )
         ::oSender:SetText( "Ficheros comprimidos" )
      else
         ::oSender:SetText( "ERROR al crear fichero comprimido" )
      end if

   else

      ::oSender:SetText( "No hay facturas de clientes para enviar" )

   end if

   /*
   Anticipos de clientes-------------------------------------------------------
   */

   ::oSender:SetText( "Enviando anticipos de clientes" )

   /*
   Creamos todas las bases de datos relacionadas con Articulos
   */

   mkAntCli( cPatSnd() )

   /*
   Abrimos las tablas----------------------------------------------------------
   */

   USE ( cPatEmp() + "AntCliT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "AntCliT", @dbfAntCliT ) )
   SET ADSINDEX TO ( cPatEmp() + "AntCliT.CDX" ) ADDITIVE

   USE ( cPatSnd() + "AntCliT.DBF" ) NEW VIA ( cLocalDriver() ) SHARED ALIAS ( cCheckArea( "AntCliT", @tmpAntCliT ) )
   SET INDEX TO ( cPatSnd() + "AntCliT.CDX" ) ADDITIVE

   if !empty( ::oSender:oMtr )
      ::oSender:oMtr:nTotal  := ( dbfAntCliT )->( LastRec() )
   end if

   while !( dbfAntCliT )->( eof() )

      if ( dbfAntCliT )->lSndDoc
         lSndAntCli        := .t.
         dbPass( dbfAntCliT, tmpAntCliT, .t. )
         ::oSender:SetText( ( dbfAntCliT )->cSerAnt + "/" + AllTRim( str( ( dbfAntCliT )->nNumAnt ) ) + "/" + AllTrim( ( dbfAntCliT )->cSufAnt ) + "; " + Dtoc( ( dbfAntCliT )->dFecAnt ) + "; " + AllTrim( ( dbfAntCliT )->cCodCli ) + "; " + ( dbfAntCliT )->cNomCli )
      end if

      ( dbfAntCliT )->( dbSkip() )

      if !empty( ::oSender:oMtr )
         ::oSender:oMtr:Set( ( dbfAntCliT )->( OrdKeyNo() ) )
      end if

   end do

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   CLOSE ( dbfAntCliT )
   CLOSE ( tmpAntCliT )

   if lSndAntCli

      ::oSender:SetText( "Comprimiendo anticipos de clientes" )

      if ::oSender:lZipData( cFileNameAnticipos )
         ::oSender:SetText( "Ficheros comprimidos" )
      else
         ::oSender:SetText( "ERROR al crear fichero comprimido" )
      end if

   else

      ::oSender:SetText( "No hay anticipos para enviar" )

   end if

Return ( Self )

//----------------------------------------------------------------------------//

Method RestoreData() CLASS TFacturasClientesSenderReciver

   local oBlock
   local oError
   local dbfFacCliT
   local dbfAntCliT

   oBlock            := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   if ::lSuccesfullSendFacturas

      USE ( cPatEmp() + "FacCliT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FacCliT", @dbfFacCliT ) )
      SET ADSINDEX TO ( cPatEmp() + "FacCliT.CDX" ) ADDITIVE
      ( dbfFacCliT )->( OrdSetFocus( "lSndDoc" ) )

      while ( dbfFacCliT )->( dbSeek( .t. ) ) .and. !( dbfFacCliT )->( eof() )
         if ( dbfFacCliT )->( dbRLock() )
            ( dbfFacCliT )->lSndDoc := .f.
            ( dbfFacCliT )->( dbRUnlock() )
         end if
      end do

      CLOSE ( dbfFacCliT )

   end if

   if ::lSuccesfullSendAnticipos

      USE ( cPatEmp() + "AntCliT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "AntCliT", @dbfAntCliT ) )
      SET ADSINDEX TO ( cPatEmp() + "AntCliT.CDX" ) ADDITIVE
      ( dbfAntCliT )->( OrdSetFocus( "lSndDoc" ) )

      while ( dbfAntCliT )->( dbSeek( .t. ) ) .and. !( dbfAntCliT )->( eof() )
         if ( dbfAntCliT )->( dbRLock() )
            ( dbfAntCliT )->lSndDoc := .f.
            ( dbfAntCliT )->( dbRUnlock() )
         end if
      end do

      CLOSE ( dbfAntCliT )

   end if

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( Self )

//----------------------------------------------------------------------------//

Method SendData() CLASS TFacturasClientesSenderReciver

   local cFileNameFacturas
   local cFileNameAnticipos
   local cDirectory           := ""

   if ::oSender:lFranquiciado
      cDirectory              := "Frq\"
   end if

   if ::oSender:lServer
      cFileNameFacturas       := "FacCli" + StrZero( ::nGetFacturaNumberToSend(), 6 ) + ".All"
      cFileNameAnticipos      := "AntCli" + StrZero( ::nGetAnticipoNumberToSend(), 6 ) + ".All"
   else
      cFileNameFacturas       := "FacCli" + StrZero( ::nGetFacturaNumberToSend(), 6 ) + "." + RetSufEmp()
      cFileNameAnticipos      := "AntCli" + StrZero( ::nGetAnticipoNumberToSend(), 6 ) + "." + RetSufEmp()
   end if

   ::lSuccesfullSendFacturas  := .f.
   ::lSuccesfullSendAnticipos := .f.

   /*
   Enviarlos a internet--------------------------------------------------------
   */

   if File( cPatOut() + cFileNameFacturas )

      if ::oSender:SendFiles( cPatOut() + cFileNameFacturas, cDirectory + cFileNameFacturas, cDirectory )
         ::lSuccesfullSendFacturas  := .t.
         ::oSender:SetText( "Fichero facturas de clientes enviados " + cFileNameFacturas )
      else
         ::oSender:SetText( "ERROR al enviar fichero de facturas de clientes" )
      end if

   end if

   /*
   Enviarlos a internet--------------------------------------------------------
   */

   if File( cPatOut() + cFileNameAnticipos )

      if ::oSender:SendFiles( cPatOut() + cFileNameAnticipos, cFileNameAnticipos, cDirectory )
         ::lSuccesfullSendAnticipos := .t.
         ::oSender:SetText( "Fichero anticipos de clientes enviados " + cFileNameAnticipos )
      else
         ::oSender:SetText( "ERROR al enviar fichero de anticipos de clientes" )
      end if

   end if

   if ::lSuccesfullSendFacturas
      ::IncFacturaNumberToSend()
   end if

   if ::lSuccesfullSendAnticipos
      ::IncAnticipoNumberToSend()
   end if

Return ( Self )

//----------------------------------------------------------------------------//

Method ReciveData() CLASS TFacturasClientesSenderReciver

   local n
   local aExt

   aExt     := ::oSender:aExtensions()

   /*
   Recibirlo de internet-------------------------------------------------------
   */

   ::oSender:SetText( "Recibiendo facturas y anticipos de clientes" )

   for n := 1 to len( aExt )
      ::oSender:GetFiles( "FacCli*." + aExt[ n ], cPatIn() )
      ::oSender:GetFiles( "AntCli*." + aExt[ n ], cPatIn() )
   next

   ::oSender:SetText( "Facturas y anticipos de clientes recibidos" )

Return Self

//----------------------------------------------------------------------------//

Method Process() CLASS TFacturasClientesSenderReciver

   local m
   local oStock

   local dbfIva
   local dbfDiv
   local dbfFacCliT
   local dbfFacCliL
   local dbfFacCliP
   local dbfAntCliT
   
   local tmpFacCliT
   local tmpFacCliL
   local tmpFacCliP
   local tmpAntCliT
   
   local dbfCliente
   local dbfProvee

   local oBlock
   local oError
   local lClient        := ::oSender:lServer
   local aFiles         := directory( cPatIn() + "FacCli*.*" )
   local cSerie
   local nNumero
   local cSufijo

   local cNumeroFactura
   local cTextoFactura  := ""
   local cNumeroRecibo
   local cTextoRecibo   := ""

   for m := 1 to len( aFiles )

      ::oSender:SetText( "Procesando fichero : " + aFiles[ m, 1 ] )

      oBlock            := ErrorBlock( { | oError | ApoloBreak( oError ) } )
      BEGIN SEQUENCE

      /*
      Descomprimimos el fichero
      */

      if ::oSender:lUnZipData( cPatIn() + aFiles[ m, 1 ] )

         /*
         Ficheros temporales
         */

         if file( cPatSnd() + "FacCliT.Dbf" ) .and. file( cPatSnd() + "FacCliL.Dbf" ) .and. file( cPatSnd() + "FacCliP.Dbf" )

            USE ( cPatSnd() + "FacCliT.DBF" ) NEW VIA ( cLocalDriver() ) READONLY ALIAS ( cCheckArea( "FacCliT", @tmpFacCliT ) )
            SET INDEX TO ( cPatSnd() + "FacCliT.CDX" ) ADDITIVE

            USE ( cPatSnd() + "FacCliL.DBF" ) NEW VIA ( cLocalDriver() ) READONLY ALIAS ( cCheckArea( "FacCliL", @tmpFacCliL ) )
            SET INDEX TO ( cPatSnd() + "FacCliL.Cdx" ) ADDITIVE

            USE ( cPatSnd() + "FacCliP.DBF" ) NEW VIA ( cLocalDriver() ) READONLY ALIAS ( cCheckArea( "FacCliP", @tmpFacCliP ) )
            SET INDEX TO ( cPatSnd() + "FacCliP.CDX" ) ADDITIVE

            USE ( cPatEmp() + "FacCliT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FacCliT", @dbfFacCliT ) )
            SET ADSINDEX TO ( cPatEmp() + "FacCliT.CDX" ) ADDITIVE

            USE ( cPatEmp() + "FacCliL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FacCliL", @dbfFacCliL ) )
            SET ADSINDEX TO ( cPatEmp() + "FacCliL.Cdx" ) ADDITIVE

            USE ( cPatEmp() + "FacCliP.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FacCliP", @dbfFacCliP ) )
            SET ADSINDEX TO ( cPatEmp() + "FacCliP.CDX" ) ADDITIVE

            USE ( cPatCli() + "CLIENT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CLIENT", @dbfCliente ) )
            SET ADSINDEX TO ( cPatCli() + "CLIENT.CDX" ) ADDITIVE

            USE ( cPatEmp() + "AntCliT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "AntCliT", @dbfAntCliT ) )
            SET ADSINDEX TO ( cPatEmp() + "AntCliT.CDX" ) ADDITIVE

            USE ( cPatDat() + "TIVA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIVA", @dbfIva ) )
            SET ADSINDEX TO ( cPatDat() + "TIVA.CDX" ) ADDITIVE

            USE ( cPatDat() + "DIVISAS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "DIVISAS", @dbfDiv ) )
            SET ADSINDEX TO ( cPatDat() + "DIVISAS.CDX" ) ADDITIVE

            while ( tmpFacCliT )->( !eof() )

               if ::validateRecepcion( tmpFacCliT, dbfFacCliT )

                  cNumeroFactura    := ( tmpFacCliT )->cSerie + str( ( tmpFacCliT )->nNumFac ) + ( tmpFacCliT )->cSufFac
                  cTextoFactura     := ( tmpFacCliT )->cSerie + "/" + AllTrim( str( ( tmpFacCliT )->nNumFac ) ) + "/" + AllTrim( ( tmpFacCliT )->cSufFac ) + "; " + Dtoc( ( tmpFacCliT )->dFecFac ) + "; " + AllTrim( ( tmpFacCliT )->cCodCli ) + "; " + ( tmpFacCliT )->cNomCli

                  while ( dbfFacCliT )->( dbseek( cNumeroFactura ) )
                     dbLockDelete( dbfFacCliT )
                  end if 

                  while ( dbfFacCliL )->( dbseek( cNumeroFactura ) )
                     dbLockDelete( dbfFacCliL )
                  end if 

                  // Comprobamos que no exista la factura en la base de datos

                  dbPass( tmpFacCliT, dbfFacCliT, .t. )

                  if dbLock( dbfFacCliT )
                     ( dbfFacCliT )->lSndDoc := .f.
                     ( dbfFacCliT )->( dbUnLock() )
                  end if

                  ::oSender:SetText( "Añadida factura : " + cTextoFactura )

                  // Pasamos las lineas----------------------------------------

                  if ( tmpFacCliL )->( dbSeek( cNumeroFactura ) )
                     while ( tmpFacCliL )->cSerie + str( ( tmpFacCliL )->nNumFac ) + ( tmpFacCliL )->cSufFac == cNumeroFactura .and. !( tmpFacCliL )->( eof() )
                        dbPass( tmpFacCliL, dbfFacCliL, .t. )
                        ( tmpFacCliL )->( dbSkip() )
                     end do
                  end if

                  ::oSender:setText( "Añadidas lineas de facturas : " + cTextoFactura )

               else

                  ::oSender:SetText( "Factura fecha invalida : " + cTextoFactura )

               end if 

               ( tmpFacCliT )->( dbSkip() )

            end do

            /*
            Ahora trabajamos sobre los recibos
            */

            ::oSender:SetText( "Empezamos con los recibos" )

            while ( tmpFacCliP )->( !eof() )

               ::oSender:SetText( "Antes de validar el recibo" )

               if ::validateRecepcionRecibo( tmpFacCliP, dbfFacCliP )

                  ::oSender:SetText( "Valido el recibo" )

                  cNumeroRecibo    := ( tmpFacCliP )->cSerie + str( ( tmpFacCliP )->nNumFac ) + ( tmpFacCliP )->cSufFac + Str( ( tmpFacCliP )->nNumRec )
                  cTextoRecibo     := ( tmpFacCliP )->cSerie + "/" + AllTrim( str( ( tmpFacCliP )->nNumFac ) ) + "/" + AllTrim( ( tmpFacCliT )->cSufFac ) + "-" + AllTrim( str( ( tmpFacCliP )->nNumRec ) ) + "; " + Dtoc( ( tmpFacCliP )->dEntrada ) + "; " + AllTrim( ( tmpFacCliP )->cCodCli )

                  while ( dbfFacCliP )->( dbseek( cNumeroRecibo ) )
                     dbLockDelete( dbfFacCliP )
                  end if

                  ::oSender:SetText( "Antes de validar el recibo" )

                  dbPass( tmpFacCliP, dbfFacCliP, .t. )
                  
                  ::oSender:SetText( "Añadido recibo : " + cTextoRecibo )

                  // Actualizamos el estado de la factura----------------------

                  if ( dbfFacCliP )->( dbseek( cNumeroRecibo ) )
                     chkLqdFacCli( nil, dbfFacCliT, dbfFacCliL, dbfFacCliP, dbfAntCliT, dbfIva, dbfDiv )
                  end if 

               end if

               SysRefresh()

               ( tmpFacCliP )->( dbSkip() )

            end do

            CLOSE ( dbfFacCliT )
            CLOSE ( dbfFacCliL )
            CLOSE ( dbfFacCliP )
            CLOSE ( dbfCliente )
            CLOSE ( dbfIva )
            CLOSE ( dbfDiv )

            CLOSE ( tmpFacCliT )
            CLOSE ( tmpFacCliL )
            CLOSE ( tmpFacCliP )

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

      else

         ::oSender:SetText( "Error al descomprimir fichero " + cPatIn() + aFiles[ m, 1 ] )

      end if

      RECOVER USING oError

         CLOSE ( dbfFacCliT )
         CLOSE ( dbfFacCliL )
         CLOSE ( dbfFacCliP )
         CLOSE ( dbfIva )
         CLOSE ( dbfDiv )

         CLOSE ( tmpFacCliT )
         CLOSE ( tmpFacCliL )
         CLOSE ( tmpFacCliP )
         CLOSE ( dbfCliente )

         ::oSender:SetText( "Error procesando fichero " + aFiles[ m, 1 ] )
         ::oSender:SetText( ErrorMessage( oError ) )

      END SEQUENCE

      ErrorBlock( oBlock )

   next

   /*
   Anticipos de clientes-------------------------------------------------------
   */

   ::oSender:SetText( "Recibiendo anticipos de clientes" )

   aFiles            := Directory( cPatIn() + "AntCli*.*" )

   for m := 1 to len( aFiles )

      ::oSender:SetText( "Procesando fichero : " + aFiles[ m, 1 ] )

      oBlock         := ErrorBlock( { | oError | ApoloBreak( oError ) } )

      BEGIN SEQUENCE

         if ::oSender:lUnZipData( cPatIn() + aFiles[ m, 1 ] )

            /*
            Ficheros temporales
            */

            if file( cPatSnd() + "AntCliT.DBF" )

               USE ( cPatSnd() + "AntCliT.DBF" ) NEW VIA ( cLocalDriver() )READONLY ALIAS ( cCheckArea( "AntCliT", @tmpAntCliT ) )
               SET INDEX TO ( cPatSnd() + "AntCliT.CDX" ) ADDITIVE

               USE ( cPatEmp() + "AntCliT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "AntCliT", @dbfAntCliT ) )
               SET ADSINDEX TO ( cPatEmp() + "AntCliT.CDX" ) ADDITIVE

               while ( tmpAntCliT )->( !eof() )

                  /*
                  Comprobamos que no exista el Facido en la base de datos
                  */

                  if !( dbfAntCliT )->( dbSeek( ( tmpAntCliT )->CSERANT + str( ( tmpAntCliT )->NNUMANT ) + ( tmpAntCliT )->CSUFANT ) )
                     
                     dbPass( tmpAntCliT, dbfAntCliT, .t. )

                     if lClient .and. dbLock( dbfAntCliT )
                        ( dbfAntCliT )->lSndDoc := .f.
                        ( dbfAntCliT )->( dbUnLock() )
                     end if

                     ::oSender:SetText( "Añadido : " + ( tmpAntCliT )->cSerAnt + "/" + AllTrim( str( ( tmpAntCliT )->NNUMANT ) ) + "/" + AllTrim( ( tmpAntCliT )->CSUFANT ) + "; " + Dtoc( ( tmpAntCliT )->DFECANT ) + "; " + Alltrim( ( tmpAntCliT )->cCodCli ) + "; " + ( tmpAntCliT )->cNomCli )
                  
                  else
                     
                     if dbLock( dbfAntCliT )
                        ( dbfAntCliT )->lLiquidada := ( tmpAntCliT )->lLiquidada
                        ( dbfAntCliT )->dLiquidada := ( tmpAntCliT )->dLiquidada
                        ( dbfAntCliT )->cNumDoc    := ( tmpAntCliT )->cNumDoc
                        ( dbfAntCliT )->( dbUnLock() )
                     end if

                     ::oSender:SetText( "Actualizado : " + ( tmpAntCliT )->cSerAnt + "/" + AllTrim( str( ( tmpAntCliT )->NNUMANT ) ) + "/" + AllTrim( ( tmpAntCliT )->CSUFANT ) + "; " + Dtoc( ( tmpAntCliT )->DFECANT ) + "; " + Alltrim( ( tmpAntCliT )->cCodCli ) + "; " + ( tmpAntCliT )->cNomCli )
                  
                  end if

                  SysRefresh()

                  ( tmpAntCliT )->( dbSkip() )

               end do

               CLOSE ( dbfAntCliT )
               CLOSE ( tmpAntCliT )

               ::oSender:AppendFileRecive( aFiles[ m, 1 ] )

            else

               ::oSender:SetText( "Falta " + cPatSnd() + "AntCliT.Dbf" )

            end if

         else

            ::oSender:SetText( "Error al descomprimir fichero " + cPatIn() + aFiles[ m, 1 ] )

         end if

      RECOVER USING oError

         ::oSender:SetText( "Error procesando fichero " + aFiles[ m, 1 ] )
         ::oSender:SetText( ErrorMessage( oError ) )

      END SEQUENCE

      ErrorBlock( oBlock )

   next

Return Self

//---------------------------------------------------------------------------//

Method ReciveFrq() CLASS TFacturasClientesSenderReciver

   local n
   local aExt

   if ::oSender:lServer
      aExt  := aRetDlgEmp()
   else
      aExt  := { "All" }
   end if

   /*
   Recibirlo de internet-------------------------------------------------------
   */

   ::oSender:setPathComunication( cRutConFrq() )

   ::oSender:SetText( "Recibiendo facturas y anticipos de clientes" )

   for n := 1 to len( aExt )
      ::oSender:GetFile( "FacCli*." + aExt[ n ], cPatInFrq() )
      ::oSender:GetFile( "AntCli*." + aExt[ n ], cPatInFrq() )
   next

   ::oSender:SetText( "Facturas y anticipos de clientes recibidos" )

Return Self

//----------------------------------------------------------------------------//

Method ProcessFrq() CLASS TFacturasClientesSenderReciver

   local m

   local dbfFacCliT
   local dbfFacCliL
   local dbfFacCliP
   local dbfAntCliT
   
   local tmpFacCliT
   local tmpFacCliL
   local tmpFacCliP
   local tmpAntCliT
   
   local dbfCliente
   local dbfProvee

   local oBlock
   local oError

   local cSerie
   local nNumero
   local cSufijo

   local aFiles      := Directory( cPatInFrq() + "FacCli*.*" )

   if len( aFiles ) == 0
      Return .f.
   end if 

   if empty( uFieldempresa( "cCodCliFrq" ) )
      ::oSender:SetText( "Debe cumplimentar el código de cliente en la configuración de la empresa." )
      Return .f.
   end if 

   if empty( uFieldempresa( "cCodPrvFrq" ) )
      ::oSender:SetText( "Debe cumplimentar el código de proveedor en la configuración de la empresa." )
      Return .f.
   end if 

   for m := 1 to len( aFiles )

      // Descomprimimos el fichero---------------------------------------------

      if ::oSender:lUnZipData( cPatInFrq() + aFiles[ m, 1 ] )

         // Ficheros temporales-------------------------------------------------

         if file( cPatSnd() + "FacCliT.Dbf" ) .and. file( cPatSnd() + "FacCliL.Dbf" ) .and. file( cPatSnd() + "FacCliP.Dbf" )

            USE ( cPatSnd() + "FacCliT.Dbf" ) NEW VIA ( cLocalDriver() ) READONLY ALIAS ( cCheckArea( "FacCliT", @tmpFacCliT ) )
            SET INDEX TO ( cPatSnd() + "FacCliT.Cdx" ) ADDITIVE

            USE ( cPatSnd() + "FacCliL.Dbf" ) NEW VIA ( cLocalDriver() ) READONLY ALIAS ( cCheckArea( "FacCliL", @tmpFacCliL ) )
            SET INDEX TO ( cPatSnd() + "FacCliL.Cdx" ) ADDITIVE

            USE ( cPatSnd() + "FacCliP.Dbf" ) NEW VIA ( cLocalDriver() ) READONLY ALIAS ( cCheckArea( "FacCliP", @tmpFacCliP ) )
            SET INDEX TO ( cPatSnd() + "FacCliP.Cdx" ) ADDITIVE

            while ( tmpFacCliT )->( !eof() )

               AppendFacturaProveedores()

               if rtrim( ( tmpFacCliT )->cCodCli ) == rtrim( uFieldempresa( "cCodCliFrq" ) )

                  ::oSender:SetText( "Procesando factura : " + ( tmpFacCliL )->cSerie + "/" + AllTrim( str( ( tmpFacCliL )->nNumFac ) ) + "/" +  AllTrim( ( tmpFacCliL )->cSufFac ) + "; " + Dtoc( ( tmpFacCliT )->dFecFac ) + "; " + AllTrim( ( tmpFacCliT )->cCodCli ) + "; " + ( tmpFacCliT )->cNomCli )

               else 

                  ::oSender:SetText( "Desestimada factura : " + ( tmpFacCliL )->cSerie + "/" + AllTrim( str( ( tmpFacCliL )->nNumFac ) ) + "/" +  AllTrim( ( tmpFacCliL )->cSufFac ) + "; " + Dtoc( ( tmpFacCliT )->dFecFac ) + "; " + AllTrim( ( tmpFacCliT )->cCodCli ) + "; " + ( tmpFacCliT )->cNomCli )

               end if

               ( tmpFacCliT )->( dbSkip() )

            end do

            CLOSE ( dbfFacCliT )
            CLOSE ( dbfFacCliL )
            CLOSE ( dbfFacCliP )

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

   next

Return Self

//----------------------------------------------------------------------------//

METHOD validateRecepcion( tmpFacCliT, dbfFacCliT ) CLASS TFacturasClientesSenderReciver

   ::cErrorRecepcion       := "Pocesando factura de cliente número " + ( dbfFacCliT )->cSerie + "/" + alltrim( Str( ( dbfFacCliT )->nNumFac ) ) + "/" + alltrim( ( dbfFacCliT )->cSufFac ) + " "

   if !( lValidaOperacion( ( tmpFacCliT )->dFecFac, .f. ) )

      ::cErrorRecepcion    += "la fecha " + dtoc( ( tmpFacCliT )->dFecFac ) + " no es valida en esta empresa"

      ::oSender:SetText( ::cErrorRecepcion )

      RETURN .f. 

   end if 

   if ( dbfFacCliT )->( dbSeek( ( tmpFacCliT )->cSerie + Str( ( tmpFacCliT )->nNumFac ) + ( tmpFacCliT )->cSufFac ) )

      ::cErrorRecepcion    += "el documento ya existe en las facturas de clientes" 

      ::oSender:SetText( ::cErrorRecepcion )
      
      RETURN .f.

   end if 

   /*

   Esto lo quito por problemas en marpicon con las tablets---------------------

   if dtos( ( dbfFacCliT )->dFecCre ) + ( dbfFacCliT )->cTimCre >= dtos( ( tmpFacCliT )->dFecCre ) + ( tmpFacCliT )->cTimCre 
      
      ::cErrorRecepcion    += "la fecha en la empresa " + dtoc( ( dbfFacCliT )->dFecCre ) + " " + ( dbfFacCliT )->cTimCre + " es más reciente que la recepción " + dtoc( ( tmpFacCliT )->dFecCre ) + " " + ( tmpFacCliT )->cTimCre 
      
      ::oSender:SetText( ::cErrorRecepcion )

      RETURN .f.

   end if

   */

   ::oSender:SetText( ::cErrorRecepcion )

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD validateRecepcionRecibo( tmpFacCliP, dbfFacCliP ) CLASS TFacturasClientesSenderReciver

   ::cErrorRecepcion       := "Pocesando recibo de cliente número " + ( dbfFacCliP )->cSerie + "/" + alltrim( Str( ( dbfFacCliP )->nNumFac ) ) + "/" + alltrim( ( dbfFacCliP )->cSufFac ) + alltrim( Str( ( dbfFacCliP )->nNumRec ) ) + " "

   if !( lValidaOperacion( ( tmpFacCliP )->dPreCob, .f. ) )

      ::cErrorRecepcion    += "la fecha " + dtoc( ( tmpFacCliP )->dPreCob ) + " no es valida en esta empresa"

      ::oSender:SetText( ::cErrorRecepcion )

      Return .f. 

   end if 

   if !( ( dbfFacCliP )->( dbSeek( ( tmpFacCliP )->cSerie + Str( ( tmpFacCliP )->nNumFac ) + ( tmpFacCliP )->cSufFac + Str( ( tmpFacCliP )->nNumRec ) ) ) )

      ::oSender:SetText( ::cErrorRecepcion )

      Return .t. 

   end if 

   if dtos( ( dbfFacCliP )->dFecCre ) + ( dbfFacCliP )->cHorCre >= dtos( ( tmpFacCliP )->dFecCre ) + ( tmpFacCliP )->cHorCre 

      ::cErrorRecepcion    += "la fecha en la empresa " + dtoc( ( dbfFacCliP )->dFecCre ) + " " + ( dbfFacCliP )->cHorCre + " es más reciente que la recepción " + dtoc( ( tmpFacCliP )->dFecCre ) + " " + ( tmpFacCliP )->cHorCre

      ::oSender:SetText( ::cErrorRecepcion )

      Return .f. 

   end if

   ::oSender:SetText( ::cErrorRecepcion )

Return ( .t. )

//---------------------------------------------------------------------------//

FUNCTION EdmFacCli( cCodRut, cPathTo, oStru, aSucces )

RETURN ( aSucces )

//---------------------------------------------------------------------------//

Static Function lComprobacionesFactCli( aGet, aTmp )

   local lReturn  := .t.

   if !lValidaOperacion( aTmp[ _DFECFAC ] )
      lReturn     := .f.
   end if

   if !lValidaSerie( aTmp[ _CSERIE ] )
      Return .f.
   end if

   if lClienteBloqueado( aGet )
      lReturn     := .f.
   end if

   if lNombreVacio( aGet, aTmp[ _CNOMCLI ] )
      lReturn     := .f.
   end if

   if lAlmacenVacio( aGet, aTmp[ _CCODALM ] )
      lReturn     := .f.
   end if

   if lFormaPagoVacia( aGet, aTmp[ _CCODPAGO ] )
      lReturn     := .f.
   end if

   if lDivisaVacia( aGet, aTmp[ _CDIVFAC ] )
      lReturn     := .f.
   end if

   if lLineasVacias()
      lReturn     := .f.
   end if

Return ( lReturn )

//------------------------------------------------------------------------//

Static Function lClienteBloqueado( aGet, cCliente )

   if empty( cCliente ) .and. !empty( aGet[ _CCODCLI ] )
      cCliente    := aGet[ _CCODCLI ]:varGet()
   end if   

   if ( D():Clientes( nView ) )->( dbSeek( cCliente ) )
         
      if !( isAviableClient( nView ) )

         if !empty( aGet[ _CCODCLI ] )
            aGet[ _CCODCLI ]:SetFocus()
         end if   

         Return .t.

      end if

   end if

Return ( .f. )

//------------------------------------------------------------------------//

Static Function lNombreVacio( aGet, cNomCli )

   local lReturn  := .f.

   if empty( cNomCli )

      if ( "TABLET" $ appParamsMain() )
         apoloMsgStop( "Nombre de cliente no puede estar vacío.")
      else
         msgStop( "Nombre de cliente no puede estar vacío." )
      end if

      if !empty( aGet[ _CNOMCLI ] )
         aGet[ _CNOMCLI ]:SetFocus()
      end if   

      lReturn := .t.

   end if

Return ( lReturn )

//---------------------------------------------------------------------------//

Static Function lAlmacenVacio( aGet, cCodAlm )

   local lReturn  := .f.

   if empty( cCodAlm )

      if ( "TABLET" $ appParamsMain() )
         apoloMsgStop( "Almacén no puede estar vacío.")
      else
         msgStop( "Almacén no puede estar vacío." )
      end if

      if !empty( aGet[ _CCODALM ] )
         aGet[ _CCODALM ]:SetFocus()
      end if   

      lReturn := .t.

   end if

Return ( lReturn )

//---------------------------------------------------------------------------//

Static Function lFormaPagoVacia( aGet, cCodPago )

   local lReturn  := .f.

   if empty( cCodPago )

      if ( "TABLET" $ appParamsMain() )
         apoloMsgStop( "Forma de pago no puede estar vacía.")
      else
         msgStop( "Forma de pago no puede estar vacía." )
      end if

      if !empty( aGet[ _CCODPAGO ] )
         aGet[ _CCODPAGO ]:SetFocus()
      end if   

      lReturn := .t.

   end if

Return ( lReturn )

//---------------------------------------------------------------------------//

Static Function lDivisaVacia( aGet, cCodDiv )

   local lReturn  := .f.

   if empty( cCodDiv )

      if ( "TABLET" $ appParamsMain() )
         apoloMsgStop( "No puede almacenar documento sin Código de divisa.")
      else
         msgStop( "No puede almacenar documento sin Código de divisa." )
      end if

      if !empty( aGet[ _CDIVFAC ] )
         aGet[ _CDIVFAC ]:SetFocus()
      end if   

      lReturn := .t.

   end if

Return ( lReturn )

//---------------------------------------------------------------------------//

Static Function lLineasVacias()

   local lReturn  := .f.

   if ( dbfTmpLin )->( eof() )

      if ( "TABLET" $ appParamsMain() )
         apoloMsgStop( "No puede almacenar un documento sin lineas.")
      else
         msgStop( "No puede almacenar un documento sin lineas." )
      end if

      lReturn     := .t.

   end if

return ( lReturn )

//---------------------------------------------------------------------------//

Static Function lCambioSerie( aTmp )

   if cSerieAnterior != aTmp[ _CSERIE ]
      Return .t.
   end if

return .f.

//---------------------------------------------------------------------------//   

Static Function GuardaContadorAnterior( nNumFac, cSufFac )

   if uFieldEmpresa( "LRECNUMFAC" )
      nPutDoc( cSerieAnterior, nNumFac, cSufFac, D():FacturasClientes( nView ), "nFacCli", , D():Contadores( nView ) )
   end if

Return .t.

//---------------------------------------------------------------------------//

Static Function RollBackFacCli( cNumeroDocumento )

   local nOrd

   /*
   Rollback de todos los articulos si la factura no se importo de Facturas----
   */

   while ( D():FacturasClientesLineas( nView ) )->( dbSeek( cNumeroDocumento ) ) .and. !( D():FacturasClientesLineas( nView ) )->( eof() ) 

      TComercio:appendProductsToUpadateStocks( ( D():FacturasClientesLineas( nView ) )->cRef, nView )

      if dbLock( D():FacturasClientesLineas( nView ) )
         ( D():FacturasClientesLineas( nView ) )->( dbDelete() )
         ( D():FacturasClientesLineas( nView ) )->( dbUnLock() )
      end if

      SysRefresh()

   end while
   
   /*
   Eliminamos las incidencias anteriores---------------------------------------
   */

   while ( ( dbfFacCliI )->( dbSeek( cNumeroDocumento ) ) .and. !( dbfFacCliI )->( eof() ) )
      if dbLock( dbfFacCliI )
         ( dbfFacCliI )->( dbDelete() )
         ( dbfFacCliI )->( dbUnLock() )
      end if
      SysRefresh()
   end while

   /*
   Eliminamos las incidencias anteriores---------------------------------------
   */

   while ( ( dbfFacCliD )->( dbSeek( cNumeroDocumento ) ) .and. !( dbfFacCliD )->( eof() ) )
      if dbLock( dbfFacCliD )
         ( dbfFacCliD )->( dbDelete() )
         ( dbfFacCliD )->( dbUnLock() )
      end if
      SysRefresh()
   end while

   /*
   Eliminamos los pagos anteriores---------------------------------------------
   */

   while ( ( D():FacturasClientesCobros( nView ) )->( dbSeek( cNumeroDocumento ) ) .and. !( D():FacturasClientesCobros( nView ) )->( eof() ) )
      if dbLock( D():FacturasClientesCobros( nView ) )
         ( D():FacturasClientesCobros( nView ) )->( dbDelete() )
         ( D():FacturasClientesCobros( nView ) )->( dbUnLock() )
      end if
      SysRefresh()
   end while

   /*
   Eliminamos las series anteriores---------------------------------------------
   */

   while ( ( dbfFacCliS )->( dbSeek( cNumeroDocumento ) ) .and. !( dbfFacCliS )->( eof() ) )
      if dbLock( dbfFacCliS )
         ( dbfFacCliS )->( dbDelete() )
         ( dbfFacCliS )->( dbUnLock() )
      end if
      SysRefresh()
   end while

   /*
   Eliminamos las series anteriores---------------------------------------------
   */

   while D():gotoIdFacturasClientesEntidades( cNumeroDocumento, nView ) .and. !D():eofFacturasClientesEntidades( nView )
      D():deleteFacturasClientesEntidades( nView )
      SysRefresh()
   end while

   /*
   Eliminamos los anticipos anteriores-----------------------------------------
   */

   nOrd                             := ( D():AnticiposClientes( nView ) )->( OrdSetFocus( "cNumDoc" ) )
   while ( ( D():AnticiposClientes( nView ) )->( dbSeek( cNumeroDocumento ) ) .and. !( D():AnticiposClientes( nView ) )->( eof() ) )
      if dbLock( D():AnticiposClientes( nView ) )
         ( D():AnticiposClientes( nView ) )->lLiquidada := .f.
         ( D():AnticiposClientes( nView ) )->cNumDoc    := ""
         ( D():AnticiposClientes( nView ) )->( dbUnLock() )
      end if
      SysRefresh()
   end while
   ( D():AnticiposClientes( nView ) )->( OrdSetFocus( nOrd ) )

   /*
   Eliminamos las situaciones anteriores-----------------------------------------
   */

      while ( D():FacturasClientesSituaciones( nView ) )->( dbSeek( cNumeroDocumento ) ) 
       if dbLock( D():FacturasClientesSituaciones( nView ) )
          ( D():FacturasClientesSituaciones( nView ) )->( dbDelete() )
          ( D():FacturasClientesSituaciones( nView ) )->( dbUnLock() )
       end if
   end while

Return .t.

//---------------------------------------------------------------------------//

Static Function GuardaTemporalesFacCli( cSerFac, nNumFac, cSufFac, dFecFac, tFecFac, cCodCli, aTmp )

   ( dbfTmpLin )->( dbGoTop() )
   while ( dbfTmpLin )->( !eof() )

      ( dbfTmpLin )->nRegIva     := aTmp[ _NREGIVA ]

      if !( ( dbfTmpLin )->nUniCaja == 0 .and. ( dbfTmpLin )->lFromAtp )
         
         ( dbfTmpLin )->cCodCli     := cCodCli
         
         if empty( ( dbfTmpLin )->dFecFac )
            ( dbfTmpLin )->dFecFac  := dFecFac 
         end if 

         if empty( (dbfTmpLin)->tFecFac )
            ( dbfTmpLin )->tFecFac  := tFecFac 
         end if 

         TComercio:appendProductsToUpadateStocks( ( dbfTmpLin )->cRef, nView )

         /*
         Guardamos los campos extra--------------------------------------------
         */

         oLinDetCamposExtra:saveExtraField( cSerFac + Str( nNumFac ) + cSufFac + Str( ( dbfTmpLin )->nNumLin ) + Str( ( dbfTmpLin )->nNumKit ), ( dbfTmpLin )->( OrdKeyNo() ) )

         dbPass( dbfTmpLin, D():FacturasClientesLineas( nView ), .t., cSerFac, nNumFac, cSufFac )

      end if   

      ( dbfTmpLin )->( dbSkip() )

      SysRefresh()

   end while

   /*
   Ahora escribimos en el fichero definitivo de inicdencias--------------------
   */

   ( dbfTmpInc )->( dbGoTop() )
   while ( dbfTmpInc )->( !eof() )
      dbPass( dbfTmpInc, dbfFacCliI, .t., cSerFac, nNumFac, cSufFac )
      ( dbfTmpInc )->( dbSkip() )
      SysRefresh()
   end while

   /*
   Ahora escribimos en el fichero definitivo de documentos--------------------
   */

   ( dbfTmpDoc )->( dbGoTop() )
   while ( dbfTmpDoc )->( !eof() )
      dbPass( dbfTmpDoc, dbfFacCliD, .t., cSerFac, nNumFac, cSufFac )
      ( dbfTmpDoc )->( dbSkip() )
      SysRefresh()
   end while

   /*
   Ahora escribimos en el fichero definitivo de series----------------------
   */

   ( dbfTmpSer )->( dbGoTop() )
   while ( dbfTmpSer )->( !eof() )
      dbPass( dbfTmpSer, dbfFacCliS, .t., cSerFac, nNumFac, cSufFac, dFecFac )
      ( dbfTmpSer )->( dbSkip() )
      SysRefresh()
   end while

   /*
   Ahora escribimos en el fichero definitivo de entidades---------------------
   */

   ( dbfTmpEntidades )->( dbGoTop() )
   while ( dbfTmpEntidades )->( !eof() )
      dbPass( dbfTmpEntidades, D():FacturasClientesEntidades( nView ), .t., cSerFac, nNumFac, cSufFac )
      ( dbfTmpEntidades )->( dbSkip() )
      SysRefresh()
   end while

   /*
   Escribimos en el fichero definitivo (Situaciones)
   */

    ( dbfTmpEst )->( DbGoTop() )
      while ( dbfTmpEst )->( !eof() )
         dbPass( dbfTmpEst, D():FacturasClientesSituaciones( nView ), .t., cSerFac, nNumFac, cSufFac ) 
         ( dbfTmpEst )->( dbSkip() )
      end while

   /*
   Ahora escribimos en el fichero definitivo de anticipos----------------------
   */

   ( dbfTmpAnt )->( dbGoTop() )
   while ( dbfTmpAnt )->( !eof() )
      if ( D():AnticiposClientes( nView ) )->( dbSeek( ( dbfTmpAnt )->cSerAnt + str( ( dbfTmpAnt )->nNumAnt ) + ( dbfTmpAnt )->cSufAnt ) )
         if dbLock( D():AnticiposClientes( nView ) )
            ( D():AnticiposClientes( nView ) )->lLiquidada := .t.
            ( D():AnticiposClientes( nView ) )->lSndDoc    := .t.
            ( D():AnticiposClientes( nView ) )->cNumDoc    := cSerFac + str( nNumFac ) + cSufFac
            ( D():AnticiposClientes( nView ) )->dLiquidada := GetSysDate()
            ( D():AnticiposClientes( nView ) )->cTurLiq    := cCurSesion()
            ( D():AnticiposClientes( nView ) )->cCajLiq    := oUser():cCaja()
            ( D():AnticiposClientes( nView ) )->( dbUnLock() )
         end if
      end if
      ( dbfTmpAnt )->( dbSkip() )
      SysRefresh()
   end while

   /*
   Si cambia el cliente en la factura, lo cambiamos en los recibos-------------
   */

   ( dbfTmpPgo )->( dbGoTop() )

   while ( dbfTmpPgo )->( !eof() )

      if ( dbfTmpPgo )-> cCodCli != aTmp[ _CCODCLI ]
         ( dbfTmpPgo )-> cCodCli := aTmp[ _CCODCLI ]
      end if

      if ( dbfTmpPgo )-> cNomCli != aTmp[ _CNOMCLI ]
         ( dbfTmpPgo )-> cNomCli := aTmp[ _CNOMCLI ]
      end if

      ( dbfTmpPgo )->( dbSkip() )

      SysRefresh()

   end while

   /*
   Ahora escribimos en el fichero definitivo de pagos--------------------------
   */

   EscribeTemporalPagos( cSerFac, nNumFac, cSufFac, aTmp )

Return .t.

//---------------------------------------------------------------------------//

Static Function EscribeTemporalPagos( cSerFac, nNumFac, cSufFac,aTmp )

   if !( "TABLET" $ appParamsMain() )
      
      ( dbfTmpPgo )->( dbGoTop() )
      while ( dbfTmpPgo )->( !eof() )

         if !empty( aTmp[ _CCENTROCOSTE ] )
         ( dbfTmpPgo )->cCtrCoste := aTmp[ _CCENTROCOSTE ]
         endif

         dbPass( dbfTmpPgo, D():FacturasClientesCobros( nView ), .t., cSerFac, nNumFac, cSufFac )
         ( dbfTmpPgo )->( dbSkip() )
         SysRefresh()
      end while

   end if

Return .t.

//---------------------------------------------------------------------------//   

Function cFormatoFacturasClientes( cSerie )

   local cFormato

   DEFAULT cSerie          := ( D():FacturasClientes( nView ) )->cSerie

   cFormato                := cFormatoDocumento( cSerie, "nFacCli", D():Contadores( nView ) )

   if empty( cFormato )
      cFormato             := cFirstDoc( "FC", D():Documentos( nView ) )
   end if

Return ( cFormato ) 

//---------------------------------------------------------------------------//   

Function nSaldoAnterior4( cNumDoc )

   DEFAULT cNumDoc := ( D():FacturasClientes( nView ) )->cSerie + Str( ( D():FacturasClientes( nView ) )->nNumFac ) + ( D():FacturasClientes( nView ) )->cSufFac

Return oStock:nSaldoAnterior( Padr( "4", 18 ), cNumDoc )

//---------------------------------------------------------------------------//

Function nSaldoAnterior8( cNumDoc )

   DEFAULT cNumDoc := ( D():FacturasClientes( nView ) )->cSerie + Str( ( D():FacturasClientes( nView ) )->nNumFac ) + ( D():FacturasClientes( nView ) )->cSufFac

Return oStock:nSaldoAnterior( Padr( "8", 18 ), cNumDoc )

//---------------------------------------------------------------------------//

Function nSaldoAnterior16( cNumDoc )

   DEFAULT cNumDoc := ( D():FacturasClientes( nView ) )->cSerie + Str( ( D():FacturasClientes( nView ) )->nNumFac ) + ( D():FacturasClientes( nView ) )->cSufFac

Return oStock:nSaldoAnterior( Padr( "16", 18 ), cNumDoc )

//---------------------------------------------------------------------------//

Function nSaldoDocumento4( cNumDoc )

   DEFAULT cNumDoc := ( D():FacturasClientes( nView ) )->cSerie + Str( ( D():FacturasClientes( nView ) )->nNumFac ) + ( D():FacturasClientes( nView ) )->cSufFac

Return oStock:nSaldoDocumento( Padr("4", 18 ), cNumDoc)

//---------------------------------------------------------------------------//

Function nSaldoDocumento8( cNumDoc )

   DEFAULT cNumDoc := ( D():FacturasClientes( nView ) )->cSerie + Str( ( D():FacturasClientes( nView ) )->nNumFac ) + ( D():FacturasClientes( nView ) )->cSufFac
   
Return oStock:nSaldoDocumento( Padr("8", 18 ), cNumDoc)

//---------------------------------------------------------------------------//

Function nSaldoDocumento16( cNumDoc )

   DEFAULT cNumDoc := ( D():FacturasClientes( nView ) )->cSerie + Str( ( D():FacturasClientes( nView ) )->nNumFac ) + ( D():FacturasClientes( nView ) )->cSufFac
   
Return oStock:nSaldoDocumento( Padr("16", 18 ), cNumDoc)

//---------------------------------------------------------------------------//

Function nTotalSaldo4( cCodCli, dFecFac )

   DEFAULT cCodCli   := ( D():FacturasClientes( nView ) )->cCodCli
   DEFAULT dFecFac   := ( D():FacturasClientes( nView ) )->dFecFac
   
Return oStock:nTotalSaldo( Padr("4", 18 ), cCodCli, dFecFac)

//---------------------------------------------------------------------------//

Function nTotalSaldo8( cCodCli, dFecFac )

   DEFAULT cCodCli   := ( D():FacturasClientes( nView ) )->cCodCli
   DEFAULT dFecFac   := ( D():FacturasClientes( nView ) )->dFecFac
   
Return oStock:nTotalSaldo( Padr("8", 18 ), cCodCli, dFecFac)

//---------------------------------------------------------------------------//

Function nTotalSaldo16( cCodCli, dFecFac )

   DEFAULT cCodCli   := ( D():FacturasClientes( nView ) )->cCodCli
   DEFAULT dFecFac   := ( D():FacturasClientes( nView ) )->dFecFac
   
Return oStock:nTotalSaldo( Padr("16", 18 ), cCodCli, dFecFac)

//---------------------------------------------------------------------------//

Static Function cFormatoPresupuestosClientes( cSerie )

   local cFormato

   DEFAULT cSerie    := ( D():PresupuestosClientes( nView ) )->cSerPre

   cFormato          := cFormatoDocumento( cSerie, "nPreCli", D():Contadores( nView ) )

   if empty( cFormato )
      cFormato       := cFirstDoc( "RC", D():Documentos( nView ) )
   end if

Return ( cFormato ) 

//---------------------------------------------------------------------------//   

Function DesignLabelFacturaClientes( oFr, cDoc )

   local oLabel
   local lOpenFiles  := empty( nView ) 

   if lOpenFiles .and. !Openfiles()
      Return .f.
   endif

   oLabel            := TLabelGeneratorFacturasClientes():New( nView )

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
      oFr:SetObjProperty(  "MasterData",  "DataSet",        "Lineas de facturas" )
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

   if !empty( oImpuestos )
      oImpuestos:Refresh()
   end if

return ( .t. )

//---------------------------------------------------------------------------//

Function SetOrderFacturaClienteLineas( cOrder )

   if empty( cOrder )
      Return .f.
   end if

   D():getStatusFacturasClientes( nView )
      
   ( D():FacturasClientesLineas( nView ) )->( OrdSetFocus( cOrder ) )

Return ( .t. )

//---------------------------------------------------------------------------//

Function RollBackOrderFacturaClienteLineas()

   D():setStatusFacturasClientes( nView )

Return ( .t. )

//---------------------------------------------------------------------------//

Function nombrePrimeraPropiedadFacturasClientesLineas()

Return ( nombrePropiedad( ( D():FacturasClientesLineas( nView ) )->cCodPr1, ( D():FacturasClientesLineas( nView ) )->cValPr1, nView ) )

//---------------------------------------------------------------------------//

Function nombreSegundaPropiedadFacturasClientesLineas()

Return ( nombrePropiedad( ( D():FacturasClientesLineas( nView ) )->cCodPr2, ( D():FacturasClientesLineas( nView ) )->cValPr2, nView ) )

//---------------------------------------------------------------------------//

function cNumeroPedidoFactura( cNumAlb )

   local cPedido  := ""

   if empty( cNumAlb )
      Return cPedido
   end if

   cPedido        := retFld( cNumAlb, dbfAlbCliT, "cNumPed" )

   if !empty( cPedido )
      cPedido     := Trans( cPedido, "@R #/#########/##" )
   end if

return cPedido

//---------------------------------------------------------------------------//

Function EnvaseArticuloFacturasClientesLineas( cCodCli, cCodArt )

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

Static Function ChangeBultos( oCol, uNewValue, nKey )

   if IsNum( nKey ) .and. ( nKey != VK_ESCAPE ) .and. !IsNil( uNewValue )

      if dbLock( D():FacturasClientes( nView ) )
         ( D():FacturasClientes( nView ) )->nBultos    := uNewValue
         ( D():FacturasClientes( nView ) )
      end if

   end if

Return .t.

//---------------------------------------------------------------------------//