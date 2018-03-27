#include "FiveWin.Ch"
#include "Folder.ch" 
#include "Factu.ch" 
#include "Report.ch"
#include "Print.ch"
#include "Xbrowse.ch"

#define _MENUITEM_           "01082"

#define CLR_BAR              14197607
#define CLR_KIT              Rgb( 239, 239, 239 )

#define _CSERIE              1      //,"C",  1, 0, "Serie de la factura A o B" },;
#define _NNUMFAC             2      //,"N",  9, 0, "Número de la factura" },;
#define _CSUFFAC             3      //,"C",  2, 0, "Sufijo de la factura" },;
#define _CGUID               4  
#define _CTURFAC             5      //,"C",  2, 0, "Sufijo de la factura" },;
#define _DFECFAC             6      //,"D",  8, 0, "Fecha de la factura" },;
#define _CCODCLI             7      //,"C", 12, 0, "Codigo del cliente" },;
#define _CCODALM             8      //,"C", 16, 0, "Codigo de almacen" },;
#define _CCODCAJ             9      //,"C",  3, 0, "Codigo de almacen" },;
#define _CNOMCLI            10      //,"C", 50, 0, "Nombre del cliente" },;
#define _CDIRCLI            11      //,"C", 60, 0, "dirección del cliente" },;
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
#define _CCODOBR            23      //,"C",  3, 0, "Codigo de la dirección" },;
#define _NPCTCOMAGE         24      //,"N",  6, 2, "Porcentaje de comisión del agente" },;
#define _LLIQUIDADA         25      //,"L",  1, 0, "Lógico de la liquidación" },;
#define _LCONTAB            26       //,"L",  1, 0, "Lógico de la contabilización" },;
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
#define _NIVAMAN            37      //,"N",  6, 0, "Valor de la mano de dirección" },;
#define _NMANOBR            38      //,"N",  6, 0, "Valor de la mano de dirección" },;
#define _CNUMFAC            39      //,"C", 12, 0, "Número de albaran" },;
#define _NTIPOFAC           40      //,"N",  1, 0, "Número del tipo de factura" },;
#define _CDTOESP            41      //,"N",  5, 2, "Porcentaje de descuento especial" },;
#define _NDTOESP            42      //,"N",  5, 2, "Porcentaje de descuento especial" },;
#define _CDPP               43      //,"N",  5, 2, "Porcentaje de descuento por pronto pago" },;
#define _NDPP               44      //,"N",  5, 2, "Porcentaje de descuento por pronto pago" },;
#define _CDTOUNO            45      //,"C", 25, 0, "Descripción de porcentaje de descuento personalizado"
#define _NDTOUNO            46      //,"N",  4, 1, "Porcentaje de descuento por descuento personalizado"
#define _CDTODOS            47      //,"C", 25, 0, "Descripción de porcentaje de descuento personalizado"
#define _NDTODOS            48      //,"N",  4, 1, "Porcentaje de descuento por descuento personalizado"
#define _NDTOCNT            49      //,"N",  6, 2, "Porcentaje de Descuento por pago de Contado" },;
#define _NDTORAP            50      //,"N",  6, 2, "Porcentaje de Descuento por Rappel" },;
#define _NDTOPUB            51      //,"N",  6, 2, "Porcentaje de Descuento por Publicidad" },;
#define _NDTOPGO            52      //,"N",  6, 2, "Porcentaje de Descuento por Pago Centralizado" },;
#define _NDTOPTF            53      //,"N",  7, 2, "Descuento por plataforma" },;
#define _NTIPOIVA           54      //,"N",  1, 0, "Número del tipo de " + cImp() },;
#define _NPORCIVA           55      //,"N",  4, 1, "Porcentaje de " + cImp() },;
#define _LRECARGO           56      //,"L",  1, 0, "Lógico para recargo" },;
#define _CREMITIDO          57      //,"C", 50, 0, "Campo de remitido" },;
#define _LIVAINC            58      //,"N",  1, 0, "Selección de " + cImp() },;
#define _LSNDDOC            59      //,"L",  1, 0, "Lógico para documento enviado" },;
#define _CDIVFAC            60      //,"C",  3, 0, "Codigo de la divisa" },;
#define _NVDVFAC            61      //,"N", 10, 4, "Cambio de la divisa" },;
#define _CRETPOR            62      //,"C",100, 0, "Retirado por" },;
#define _CRETMAT            63      //,"C",  8, 0, "Matricula" } }
#define _CNUMDOC            64      //,"C",  8, 0, "Matricula" } }
#define _NREGIVA            65
#define _CCODPRO            66
#define _CDOCORG            67
#define _NNUMLIQ            68     //"N",  9, 0, "Número liquidación" }                                  "",                   "", "( cDbf )"} )
#define _CSUFLIQ            69     //"C",  2, 0, "Sufijo liquidación" }                                  "",                   "", "( cDbf )"} )
#define _NIMPLIQ            70     //"N", 16, 6, "Importe liquidación" }                                 "",                   "", "( cDbf )"} )
#define _LLIQUID            71     //"L",  1, 0, "Logico de liquidado" }                                 "",                   "", "( cDbf )"} )
#define _CCODTRN            72     //"L",  1, 0, "Logico de liquidado" }                                 "",                   "", "( cDbf )"} )
#define _NKGSTRN            73     //"L",  1, 0, "Logico de liquidado" }                                 "",                   "", "( cDbf )"} )
#define _LCLOFAC            74     //"L",  1, 0, "Logico de liquidado" }                                 "",                   "", "( cDbf )"} )
#define _CABNFAC            75     //"C", 12, 0, "Número de presupuesto
#define _CANTFAC            76     //"C", 12, 0, "Número de presupuesto
#define _NPCTRET            77
#define _CCODUSR            78
#define _DFECCRE            79
#define _CTIMCRE            80
#define _CCODGRP            81
#define _LIMPRIMIDO         82      //   L      1     0
#define _DFECIMP            83      //   D      8     0
#define _CHORIMP            84      //   C      5     0
#define _CCODDLG            85
#define _CMANOBR            86
#define _CMOTREC            87      //   C     35     0
#define _CCAUREC            88      //   C     35     0
#define _CTLFCLI            89      //   C     20     0
#define _NTOTNET            90
#define _NTOTIVA            91
#define _NTOTREQ            92
#define _NTOTFAC            93
#define _CBANCO             94
#define _CPAISIBAN          95
#define _CCTRLIBAN          96
#define _CENTBNC            97
#define _CSUCBNC            98
#define _CDIGBNC            99
#define _CCTABNC           100
#define _LOPERPV           101
#define _NDTOTARIFA 	      102
#define _TFECFAC 		      103
#define _CCENTROCOSTE	   104

/*
Definici¢n de la base de datos de lineas de detalle
*/

#define _dCSERIE                  1      //   C      1     0
#define _dNNUMFAC                 2      //   N      9     0
#define _dCSUFFAC                 3      //   C      2     0
#define _CREF                     4      //   C     14     0
#define _CDETALLE                 5      //   C     50     0
#define _NPREUNIT                 6      //   N     13     3
#define _NPNTVER                  7      //   N     13     6
#define _NIMPTRN                  8      //   N     13     6
#define _NDTO                     9      //   N      5     1
#define _NDTOPRM                 10      //   N      5     1
#define _NIVA                    11      //   N      6     2
#define _NCANENT                 12      //   N     13     3
#define _LCONTROL                13      //   L      1     0
#define _NPESOKG                 14      //   N      7     3
#define _CPESOKG                 15      //   N      7     3
#define _CUNIDAD                 16      //   C      2     0
#define _NCOMAGE                 17      //   N      5     1
#define _NUNICAJA                18      //   N      9     3
#define _NUNDKIT                 19      //   N     16     6
#define _DFECHA                  20      //   D      8     0
#define _CTIPMOV                 21      //   C      2     0
#define _MLNGDES                 22      //   M     10     0
#define _CCODALB                 23      //   C     12     0
#define _DFECALB                 24      //   C     12     0
#define _LTOTLIN                 25      //   L      1     0
#define _LIMPLIN                 26      //   L      1     0
#define _CCODPR1                 27
#define _CCODPR2                 28
#define _CVALPR1                 29
#define _CVALPR2                 30
#define _NFACCNV                 31
#define _NDTODIV                 32
#define _LSEL                    33
#define _NNUMLIN                 34
#define _NCTLSTK                 35
#define _NCOSDIV                 36      //   N     13     3
#define _NPVPREC                 37      //   N     13     3
#define _CALMLIN                 38      //   C     3      0
#define _LIVALIN                 39      //   C     3      0
#define _CCODIMP                 40      //   C     3      0
#define _NVALIMP                 41      //   N    16      6
#define _LLOTE                   42      //   L     1      0
#define _NLOTE                   43      //   N     4      0
#define _CLOTE                   44      //   N     4      0
#define _DFECCAD                 45      //   N     4      0
#define _LKITART                 46      //   L     1      0
#define _LKITCHL                 47      //   L     1      0
#define _LKITPRC                 48      //   L     1      0
#define _NMESGRT                 49      //   N     2      0
#define _LNOTVTA                 50
#define _CCODTIP                 51      //   C     3      0
#define _MNUMSER                 52
#define _CCODFAM                 53      //   C     8      0
#define _CGRPFAM                 54      //   C     3      0
#define _NREQ                    55      //   N    16      6
#define _MOBSLIN                 56      //   M    10      0
#define _CCODPRV                 57      //   C    12      0
#define _CNOMPRV                 58      //   C    30      0
#define _CIMAGEN                 59      //   C    30      0
#define _NPUNTOS                 60
#define _NVALPNT                 61
#define _NDTOPNT                 62
#define _NINCPNT                 63
#define _CREFPRV                 64
#define _NVOLUMEN                65
#define _CVOLUMEN                66
#define _NNUMMED                 67
#define _NMEDUNO                 68
#define _NMEDDOS                 69
#define _NMEDTRE                 70
#define _NTARLIN                 71      //   L      1     0
#define _DESCRIP                 72
#define _LLINOFE                 73      //   L      1     0
#define _LVOLIMP                 74
#define __DFECFAC				      75
#define __NBULTOS 				   76
#define _CFORMATO 				   77
#define __TFECFAC                78      //   C      6    0
#define __CCENTROCOSTE	   		79
#define _LLABEL                  80
#define _NLABEL                  81
#define _COBRLIN                 82
#define _CREFAUX                 83
#define _CREFAUX2                84
#define _NPOSPRINT         		85
#define _CTIPCTR                 86
#define _CTERCTR                 87
#define _ID_TIPO_V               88
#define __NREGIVA                89

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
memvar aImpVto
memvar aDatVto
memvar aTotIva
memvar nTotIvm
memvar aTotIvm
memvar nTotAge
memvar nTotTrn
memvar nTotAnt
memvar nTotCos
memvar nTotRnt
memvar aIvaUno
memvar aIvaDos
memvar aIvaTre
memvar aIvmUno
memvar aIvmDos
memvar aIvmTre
memvar nPctRnt
memvar nTotDif
memvar aTotTip
memvar cCtaCli
memvar nTotBrt
memvar nTotDto
memvar nTotDpp
memvar nTotUno
memvar nTotDos
memvar nTotNet
memvar nTotIva
memvar nTotReq
memvar nTotFac
memvar nTotImp
memvar nTotPnt
memvar nTotRet
memvar nTotCob
memvar nTotPes
memvar nTotArt
memvar nTotPage
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
memvar nTotCaj
memvar lFacRec
memvar lAntCli
memvar nNumArt
memvar nNumCaj
memvar nTotalDto

memvar lEnd
memvar nRow
memvar nPagina
memvar oReport

/*
Variables Staticas para todo el .prg logico no!
*/

static oWndBrw

static nView

static oBrwIva
static dbfRuta
static dbfTikCliT
static dbfFacRecT
static dbfFacRecI
static dbfFacRecD
static dbfFacRecS
static dbfFacRecE
static dbfFacCliT
static dbfFacCliL
static dbfFacCliS
static dbfAlbCliL
static dbfAlbCliS
static dbfAlbCliT
static dbfAlbCliP
static dbfPedCliT
static dbfPedCliL
static dbfPreCliT
static dbfPreCliL
static dbfPedPrvL
static dbfFacCliP
static dbfAntCliT
static dbfTmpLin
static dbfTmpInc
static dbfTmpDoc
static dbfTmpAnt
static dbfTmpPgo
static dbfTmpSer
static dbfTmpEst
static dbfIva
static dbfCount
static dbfClient
static dbfArtPrv
static dbfFPago
static dbfAgent
static dbfPromoT
static dbfPromoL
static dbfPromoC
static dbfAlm
static dbfPro

static dbfCodebar
static dbfTarPreL
static dbfTarPreS
static dbfOferta
static dbfDiv
static dbfObrasT
static dbfFamilia
static dbfKit
static dbfArtDiv
static dbfCliBnc
static dbfCajT
static dbfUsr
static dbfDelega
static dbfAgeCom
static dbfEmp
static dbfTblCnv
static dbfAlbPrvL
static dbfAlbPrvS
static dbfFacPrvL
static dbfFacPrvS
static dbfRctPrvL
static dbfRctPrvS
static dbfTikCliL
static dbfTikCliS
static dbfProLin
static dbfProMat
static dbfProSer
static dbfMatSer
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
static cTmpEst
static oGetTotal
static oGetNet
static oGetTotPnt
static oGetTotIvm
static oGetIva
static oGetReq
static oGetAge
static oGetTotPg
static oGetPag
static oGetPdt
static oGetPes
static oGetDif
static oGetTarifa
static cPouDiv
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
static oGetRnt
static oGetTrn
static nTotOld
static cCodDiv
static oBanco

static lImpuestos
static oImpuestos

static oBtnPrecio

static oTotalLinea
static nTotalLinea         := 0
static oRentabilidadLinea
static cRentabilidadLinea  := ""
static oComisionLinea
static nComisionLinea      := 0

static oFont
static oMenu

static oDetCamposExtra
static oCentroCoste

static aTip                := {}
static aNumAlb             := {}
static cOldCodCli          := ""
static cOldCodArt          := ""
static cOldPrpArt          := ""
static cOldUndMed          := ""
static lOpenFiles          := .f.
static lExternal           := .f.
static cFiltroUsuario      := ""
static oMailing

static Counter

static oTipoCtrCoste
static cTipoCtrCoste
static aTipoCtrCoste       := { "Centro de coste", "Proveedor", "Agente", "Cliente" }

static bEdtRec             := { |aTmp, aGet, cFacRecT, oBrw, bWhen, bValid, nMode, aNumDoc| EdtRec( aTmp, aGet, cFacRecT, oBrw, bWhen, bValid, nMode, aNumDoc ) }
static bEdtDet             := { |aTmp, aGet, cFacRecT, oBrw, bWhen, bValid, nMode, aTmpFac| EdtDet( aTmp, aGet, cFacRecT, oBrw, bWhen, bValid, nMode, aTmpFac ) }
static bEdtInc             := { |aTmp, aGet, dbfFacRecI, oBrw, bWhen, bValid, nMode, aTmpLin| EdtInc( aTmp, aGet, dbfFacRecI, oBrw, bWhen, bValid, nMode, aTmpLin ) }
static bEdtDoc             := { |aTmp, aGet, dbfFacRecD, oBrw, bWhen, bValid, nMode, aTmpLin| EdtDoc( aTmp, aGet, dbfFacRecD, oBrw, bWhen, bValid, nMode, aTmpLin ) }
static bEdtEst	            := { |aTmp, aGet, dbf, oBrw, bWhen, bValid, nMode, aTmpFac | EdtEst( aTmp, aGet, dbf, oBrw, bWhen, bValid, nMode, aTmpFac ) }

static oBrwProperties

//---------------------------------------------------------------------------//
//Funciones del programa
//---------------------------------------------------------------------------//

STATIC FUNCTION GenFacRec( nDevice, cCaption, cCodDoc, cPrinter, nCopies )

   local oInf
   local oDevice
   local cNumFac

   if ( D():FacturasRectificativas( nView ) )->( Lastrec() ) == 0
      return nil
   end if

   cNumFac              := ( D():FacturasRectificativas( nView ) )->cSerie + Str( ( D():FacturasRectificativas( nView ) )->nNumFac ) + ( D():FacturasRectificativas( nView ) )->cSufFac

   DEFAULT nDevice      := IS_PRINTER
   DEFAULT cCaption     := "Imprimiendo facturas rectificativas a clientes"
   DEFAULT cCodDoc      := cFormatoDocumento( ( D():FacturasRectificativas( nView ) )->cSerie, "nFacRec", dbfCount )
   DEFAULT nCopies      := if( nCopiasDocumento( ( D():FacturasRectificativas( nView ) )->cSerie, "nFacRec", dbfCount ) == 0, Max( Retfld( ( D():FacturasRectificativas( nView ) )->cCodCli, D():Clientes( nView ), "CopiasF" ), 1 ), nCopiasDocumento( ( D():FacturasRectificativas( nView ) )->cSerie, "nFacRec", dbfCount ) )

   if empty( cCodDoc )
      cCodDoc           := cFirstDoc( "FR", D():Documentos( nView ) )
   end if

   if !lExisteDocumento( cCodDoc, D():Documentos( nView ) )
      return nil
   end if

   /*
   Informacion al Auditor------------------------------------------------------
   */

   if !empty( oAuditor() )
      if nDevice == IS_PRINTER
         oAuditor():AddEvent( PRINT_FACTURA_RECTIFICATIVA,    cNumFac, FAC_REC )
      else
         oAuditor():AddEvent( PREVIEW_FACTURA_RECTIFICATIVA,  cNumFac, FAC_REC )
      end if
   end if

   /*
   Si el documento es de tipo visual-------------------------------------------
   */

   if lVisualDocumento( cCodDoc, D():Documentos( nView ) )
      PrintReportFacRec( nDevice, nCopies, cPrinter )
   else
      msgStop( "El formato ya no es soportado" )
   end if

   lChgImpDoc( D():FacturasRectificativas( nView ) )

Return nil

//--------------------------------------------------------------------------//

Static Function FacRecReportSkipper( cNumFac, dbfFacRecL )

   if ( dbfFacRecL )->cSerie + Str( ( dbfFacRecL )->nNumFac ) + ( dbfFacRecL )->cSufFac = cNumFac .and. !( dbfFacRecL )->( eof() )

      ( dbfFacRecL )->( dbSkip() )

      nTotPage              += nTotLFacRec( dbfFacRecL )

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

STATIC FUNCTION OpenFiles( lExt )

   local oError
   local oBlock

   if lOpenFiles
      MsgStop( 'Imposible abrir ficheros de facturas rectificativas a clientes' )
      Return ( .f. )
   end if

   DEFAULT lExt         := .f.

   lExternal            := lExt

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      lOpenFiles        := .t.

      nView             := D():CreateView()

      /*
      Atipicas de clientes-----------------------------------------------------
      */

      D():Atipicas( nView )

      D():FacturasRectificativas( nView )

      D():FacturasRectificativasSituaciones( nView )

      D():Clientes( nView )

      D():objectGruposClientes( nView )
      
      D():Get( "CliInc", nView )

      D():ArticuloStockAlmacenes( nView )

      D():Articulos( nView )

      D():ArticuloLenguaje( nView )

      D():GetObject( "UnidadMedicion", nView )

      D():ImpuestosEspeciales( nView )

      D():Documentos( nView )

      D():PropiedadesLineas( nView )

      D():FacturasRectificativasLineas( nView ) 

      USE ( cPatEmp() + "FacRecI.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FacRecI", @dbfFacRecI ) )
      SET ADSINDEX TO ( cPatEmp() + "FacRecI.CDX" ) ADDITIVE

      USE ( cPatEmp() + "FacRecD.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FacRecD", @dbfFacRecD ) )
      SET ADSINDEX TO ( cPatEmp() + "FacRecD.CDX" ) ADDITIVE

      USE ( cPatEmp() + "FacRecS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FacRecS", @dbfFacRecS ) )
      SET ADSINDEX TO ( cPatEmp() + "FacRecS.CDX" ) ADDITIVE

      USE ( cPatEmp() + "FacCliL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FacCliL", @dbfFacCliL ) )
      SET ADSINDEX TO ( cPatEmp() + "FacCliL.CDX" ) ADDITIVE

      USE ( cPatEmp() + "FacCliS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FacCliS", @dbfFacCliS ) )
      SET ADSINDEX TO ( cPatEmp() + "FacCliS.CDX" ) ADDITIVE

      USE ( cPatEmp() + "ALBCLIL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALBCLIL", @dbfAlbCliL ) )
      SET ADSINDEX TO ( cPatEmp() + "ALBCLIL.CDX" ) ADDITIVE 

      USE ( cPatEmp() + "ALBCLIS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALBCLIS", @dbfAlbCliS ) )
      SET ADSINDEX TO ( cPatEmp() + "ALBCLIS.CDX" ) ADDITIVE

      USE ( cPatEmp() + "ALBCLIP.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALBCLIP", @dbfAlbCliP ) )
      SET ADSINDEX TO ( cPatEmp() + "ALBCLIP.CDX" ) ADDITIVE

      USE ( cPatEmp() + "PEDCLIL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PEDCLIT", @dbfPedCliL ) )
      SET ADSINDEX TO ( cPatEmp() + "PEDCLIL.CDX" ) ADDITIVE

       USE ( cPatEmp() + "PRECLIL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PRECLIT", @dbfPreCliL ) )
      SET ADSINDEX TO ( cPatEmp() + "PRECLIL.CDX" ) ADDITIVE

      USE ( cPatEmp() + "TIKET.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIKET", @dbfTikCliT ) )
      SET ADSINDEX TO ( cPatEmp() + "TIKET.CDX" ) ADDITIVE

      USE ( cPatEmp() + "PROVART.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PROVART", @dbfArtPrv ) )
      SET ADSINDEX TO ( cPatEmp() + "PROVART.CDX" ) ADDITIVE

      USE ( cPatEmp() + "AGENTES.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "AGENTES", @dbfAgent ) )
      SET ADSINDEX TO ( cPatEmp() + "AGENTES.CDX" ) ADDITIVE

      USE ( cPatEmp() + "ArtCodebar.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CODEBAR", @dbfCodebar ) )
      SET ADSINDEX TO ( cPatEmp() + "ArtCodebar.Cdx" ) ADDITIVE

      USE ( cPatEmp() + "FAMILIAS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FAMILIAS", @dbfFamilia ) )
      SET ADSINDEX TO ( cPatEmp() + "FAMILIAS.CDX" ) ADDITIVE

      USE ( cPatEmp() + "ARTKIT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ARTTIK", @dbfKit ) )
      SET ADSINDEX TO ( cPatEmp() + "ARTKIT.CDX" ) ADDITIVE

      USE ( cPatEmp() + "TARPREL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TARPREL", @dbfTarPreL ) )
      SET ADSINDEX TO ( cPatEmp() + "TARPREL.CDX" ) ADDITIVE

      USE ( cPatEmp() + "TARPRES.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TARPRES", @dbfTarPreS ) )
      SET ADSINDEX TO ( cPatEmp() + "TARPRES.CDX" ) ADDITIVE

      USE ( cPatEmp() + "PROMOT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PROMOL", @dbfPromoT ) )
      SET ADSINDEX TO ( cPatEmp() + "PROMOT.CDX" ) ADDITIVE

      USE ( cPatEmp() + "PROMOL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PROMOL", @dbfPromoL ) )
      SET ADSINDEX TO ( cPatEmp() + "PROMOL.CDX" ) ADDITIVE

      USE ( cPatEmp() + "PROMOC.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PROMOC", @dbfPromoC ) )
      SET ADSINDEX TO ( cPatEmp() + "PROMOC.CDX" ) ADDITIVE

      USE ( cPatDat() + "TIVA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIVA", @dbfIva ) )
      SET ADSINDEX TO ( cPatDat() + "TIVA.CDX" ) ADDITIVE

      USE ( cPatEmp() + "FPAGO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FPAGO", @dbfFPago ) )
      SET ADSINDEX TO ( cPatEmp() + "FPAGO.CDX" ) ADDITIVE

      USE ( cPatDat() + "DIVISAS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "DIVISAS", @dbfDiv ) )
      SET ADSINDEX TO ( cPatDat() + "DIVISAS.CDX" ) ADDITIVE

      USE ( cPatEmp() + "ObrasT.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "OBRAST", @dbfObrasT ) )
      SET ADSINDEX TO ( cPatEmp() + "ObrasT.Cdx" ) ADDITIVE

      USE ( cPatEmp() + "OFERTA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "OFERTA", @dbfOferta ) )
      SET ADSINDEX TO ( cPatEmp() + "OFERTA.CDX" ) ADDITIVE

      USE ( cPatEmp() + "PRO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PRO", @dbfPro ) )
      SET ADSINDEX TO ( cPatEmp() + "PRO.CDX" ) ADDITIVE

      USE ( cPatEmp() + "RUTA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "RUTA", @dbfRuta ) )
      SET ADSINDEX TO ( cPatEmp() + "RUTA.CDX" ) ADDITIVE

      USE ( cPatEmp() + "ARTDIV.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ARTDIV", @dbfArtDiv ) )
      SET ADSINDEX TO ( cPatEmp() + "ARTDIV.CDX" ) ADDITIVE

      USE ( cPatDat() + "Cajas.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CAJAS", @dbfCajT ) )
      SET ADSINDEX TO ( cPatDat() + "Cajas.Cdx" ) ADDITIVE

      USE ( cPatEmp() + "Almacen.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "Almacen", @dbfAlm ) )
      SET ADSINDEX TO ( cPatEmp() + "Almacen.CDX" ) ADDITIVE

      USE ( cPatDat() + "USERS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "USERS", @dbfUsr ) )
      SET ADSINDEX TO ( cPatDat() + "USERS.CDX" ) ADDITIVE

      USE ( cPatEmp() + "NCOUNT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "NCOUNT", @dbfCount ) )
      SET ADSINDEX TO ( cPatEmp() + "NCOUNT.CDX" ) ADDITIVE

      USE ( cPatDat() + "DELEGA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "DELEGA", @dbfDelega ) )
      SET ADSINDEX TO ( cPatDat() + "DELEGA.CDX" ) ADDITIVE

      USE ( cPatEmp() + "AGECOM.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "AGECOM", @dbfAgeCom ) )
      SET ADSINDEX TO ( cPatEmp() + "AGECOM.CDX" ) ADDITIVE

      USE ( cPatDat() + "EMPRESA.DBF" ) NEW SHARED VIA ( cDriver() )ALIAS ( cCheckArea( "EMPRESA", @dbfEmp ) )
      SET ADSINDEX TO ( cPatDat() + "EMPRESA.CDX" ) ADDITIVE

      USE ( cPatDat() + "TBLCNV.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TBLCNV", @dbfTblCnv ) )
      SET ADSINDEX TO ( cPatDat() + "TBLCNV.CDX" ) ADDITIVE

      USE ( cPatEmp() + "TIKEL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIKEL", @dbfTikCliL ) )
      SET ADSINDEX TO ( cPatEmp() + "TIKEL.CDX" ) ADDITIVE
      SET TAG TO "CSTKFAST"

      USE ( cPatEmp() + "TIKES.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIKES", @dbfTikCliS ) )
      SET ADSINDEX TO ( cPatEmp() + "TIKES.CDX" ) ADDITIVE

      USE ( cPatEmp() + "ALBPROVL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALBPROVL", @dbfAlbPrvL ) )
      SET ADSINDEX TO ( cPatEmp() + "ALBPROVL.CDX" ) ADDITIVE
      SET TAG TO "cStkFast"

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

      USE ( cPatEmp() + "ProSer.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ProSer", @dbfProSer ) )
      SET ADSINDEX TO ( cPatEmp() + "ProSer.CDX" ) ADDITIVE

      USE ( cPatEmp() + "MatSer.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "MatSer", @dbfMatSer ) )
      SET ADSINDEX TO ( cPatEmp() + "MatSer.CDX" ) ADDITIVE

      USE ( cPatEmp() + "PEDPROVL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PedPrvL", @dbfPedPrvL ) )
      SET ADSINDEX TO ( cPatEmp() + "PEDPROVL.CDX" ) ADDITIVE
      SET TAG TO "cRef"

      USE ( cPatEmp() + "AntCliT.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "AntCliT", @dbfAntCliT ) )
      SET ADSINDEX TO ( cPatEmp() + "AntCliT.Cdx" ) ADDITIVE

      USE ( cPatEmp() + "CliBnc.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CLIBNC", @dbfCliBnc ) )
      SET ADSINDEX TO ( cPatEmp() + "CliBnc.Cdx" ) ADDITIVE

	    if !TDataCenter():OpenPreCliT( @dbfPreCliT )
			lOpenFiles     := .f.
		end if 

		if !TDataCenter():OpenPedCliT( @dbfPedCliT )
        	lOpenFiles     := .f.
      	end if 

		if !TDataCenter():OpenAlbCliT( @dbfAlbCliT )
   		lOpenFiles     := .f.
		end if

		if !TDataCenter():OpenFacCliT( @dbfFacCliT )
         lOpenFiles     := .f.
      end if

	  	if !TDataCenter():OpenFacCliP( @dbfFacCliP )
   		lOpenFiles     := .f.
   	else
			( dbfFacCliP )->( OrdSetFocus( "rNumFac" ) )
		end if

      oBandera          := TBandera():New()

      oStock            := TStock():Create( cPatEmp() )
      if !oStock:lOpenFiles()
         lOpenFiles     := .f.
      end if

      oCtaRem           := TCtaRem():Create( cPatEmp() )
      if !oCtaRem:OpenFiles()
         lOpenFiles     := .f.
      end if

      oNewImp           := TNewImp():Create( cPatEmp() )
      if !oNewImp:OpenFiles()
         lOpenFiles     := .f.
      end if

      oTrans            := TTrans():Create( cPatEmp() )
      if !oTrans:OpenFiles()
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

      oBanco           := TBancos():Create()
      if !oBanco:OpenFiles()
         lOpenFiles     := .f.
      end if

      oCentroCoste		:= TCentroCoste():Create( cPatDat() )
      if !oCentroCoste:OpenFiles()
         lOpenFiles     := .f.
      end if

      oMailing          := TGenmailingDatabaseFacturaRectificativaCliente():New( nView )

      TComercio         := TComercio():New( nView, oStock)
     
      Counter           := TCounter():New( nView, "nFacRec" )

      /*
      Declaración de variables publicas----------------------------------------
      */

      public nTotFac    := 0
      public nTotBrt    := 0
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
      public nTotRet    := 0
      public nTotTrn    := 0
      public nTotAnt    := 0
      public nTotCos    := 0
      public nTotPes    := 0
      public nTotRnt    := 0
      public nPctRnt    := 0
      public nTotDif    := 0

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

      public nNumArt    := 0
      public nNumCaj    := 0
      public cCtaCli    := ""

      /*
      Limitaciones de cajero y cajas--------------------------------------------------------
      */

      if lAIS() .and. !oUser():lAdministrador()
      
         cFiltroUsuario    := "Field->cSufFac == '" + Application():CodigoDelegacion() + "' .and. Field->cCodCaj == '" + Application():CodigoCaja() + "'"
         if SQLAjustableModel():getRolFiltrarVentas( Auth():rolUuid() )         
            cFiltroUsuario += " .and. Field->cCodUsr == '" + Auth():Codigo()  + "'"
         end if 

         ( D():FacturasRectificativas( nView ) )->( AdsSetAOF( cFiltroUsuario ) )

      end if

      /*
      Campos extras------------------------------------------------------------------------
      */

      oDetCamposExtra      := TDetCamposExtra():New()
      oDetCamposExtra:OpenFiles()
      oDetCamposExtra:SetTipoDocumento( "Facturas rectificativa a clientes" )
      oDetCamposExtra:setbId( {|| D():FacturasRectificativasId( nView ) } )


   RECOVER USING oError

      lOpenFiles        := .f.

      msgStop( ErrorMessage( oError ), "Imposible abrir todas las bases de datos" )

   END SEQUENCE
   ErrorBlock( oBlock )

   if !lOpenFiles
      CloseFiles()
   end if

RETURN ( lOpenFiles )

//---------------------------------------------------------------------------//

STATIC FUNCTION CloseFiles()

   DestroyFastFilter( D():FacturasRectificativas( nView ), .t., .t. )

   if !empty( oFont )
      oFont:end()
   end if

   if !empty( dbfIva )
      ( dbfIva     )->( dbCloseArea() )
   end if

   if !empty( dbfFPago )
      ( dbfFPago   )->( dbCloseArea() )
   end if

   if !empty( dbfAgent )
      ( dbfAgent   )->( dbCloseArea() )
   end if

   if !empty( dbfFacRecS )
      ( dbfFacRecS )->( dbCloseArea() )
   end if

   if !empty( dbfFacRecI )
      ( dbfFacRecI )->( dbCloseArea() )
   end if

   if !empty( dbfFacRecD )
      ( dbfFacRecD )->( dbCloseArea() )
   end if

   if !empty( dbfFacCliT )
      ( dbfFacCliT )->( dbCloseArea() )
   end if

   if !empty( dbfFacCliL )
      ( dbfFacCliL )->( dbCloseArea() )
   end if

   if !empty( dbfFacCliS )
      ( dbfFacCliS )->( dbCloseArea() )
   end if

   if !empty( dbfFacCliP )
      ( dbfFacCliP )->( dbCloseArea() )
   end if

   if !empty( dbfAlbCliT )
      ( dbfAlbCliT )->( dbCloseArea() )
   end if

   if !empty( dbfAlbCliL )
      ( dbfAlbCliL )->( dbCloseArea() )
   end if

   if !empty( dbfAlbCliS )
      ( dbfAlbCliS )->( dbCloseArea() )
   end if

   if !empty( dbfAlbCliP )
      ( dbfAlbCliP )->( dbCloseArea() )
   end if

   if !empty( dbfPedCliT )
      ( dbfPedCliT )->( dbCloseArea() )
   end if

   if !empty( dbfPedCliL )
      ( dbfPedCliL )->( dbCloseArea() )
   end if

   if !empty( dbfPreCliT )
      ( dbfPreCliT )->( dbCloseArea() )
   end if

   if !empty( dbfPreCliL )
      ( dbfPreCliL )->( dbCloseArea() )
   end if

   if !empty( dbfTikCliT )
      ( dbfTikCliT )->( dbCloseArea() )
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

   if !empty( dbfPro )
      ( dbfPro     )->( dbCloseArea() )
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

   if !empty( dbfCount )
      ( dbfCount   )->( dbCloseArea() )
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

   if !empty( dbfEmp )
      ( dbfEmp )->( dbCloseArea() )
   end if

   if !empty( dbfTblCnv )
      ( dbfTblCnv )->( dbCloseArea() )
   end if

   if !empty( dbfAlbPrvL )
      ( dbfAlbPrvL )->( dbCloseArea() )
   end if

   if !empty( dbfAlbPrvS )
      ( dbfAlbPrvS )->( dbCloseArea() )
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

   if !empty( dbfTikCliL )
      ( dbfTikCliL )->( dbCloseArea() )
   end if

   if !empty( dbfTikCliS )
      ( dbfTikCliS )->( dbCloseArea() )
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

   if dbfPedPrvL != nil
      ( dbfPedPrvL )->( dbCloseArea() )
   end if

   if !empty( dbfAntCliT )
      ( dbfAntCliT )->( dbCloseArea() )
   end if

   if !empty( dbfCliBnc )
      ( dbfCliBnc )->( dbClosearea() )
   end if

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
      oUndMedicion:end()
   end if

   if !empty( oBanco )
      oBanco:End()
   end if

   if !empty( oDetCamposExtra )
      oDetCamposExtra:CloseFiles()
   end if

   if !empty( oCentroCoste )
      oCentroCoste:End()
   end if

   if !empty(oMailing)
      oMailing:end()
   end if 

   TComercio:end()

   D():DeleteView( nView )

   dbfIva      := nil
   dbfFPago    := nil
   dbfAgent    := nil
   dbfFacRecD  := nil
   dbfFacRecS  := nil
   dbfFacCliT  := nil
   dbfFacCliL  := nil
   dbfFacCliP  := nil
   dbfAlbCliT  := nil
   dbfAlbCliL  := nil
   dbfAlbCliS  := nil
   dbfPedCliT  := nil
   dbfPedCliL  := nil
   dbfPreCliT  := nil
   dbfPreCliL  := nil
   dbfTikCliT  := nil
   dbfCodebar  := nil
   dbfFamilia  := nil
   dbfKit      := nil
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
   dbfPro      := nil
   dbfRuta     := nil
   dbfArtDiv   := nil
   dbfCajT     := nil
   dbfUsr      := nil
   dbfArtPrv   := nil
   dbfDelega   := nil
   dbfAgeCom   := nil
   dbfEmp      := nil
   dbfTblCnv   := nil
   dbfAlbPrvL  := nil
   dbfAlbPrvS  := nil
   dbfFacPrvL  := nil
   dbfFacPrvS  := nil
   dbfRctPrvL  := nil
   dbfRctPrvS  := nil

   dbfTikCliL  := nil
   dbfTikCliS  := nil
   dbfProLin   := nil
   dbfProMat   := nil
   dbfPedPrvL  := nil
   dbfCliBnc   := nil

   oStock      := nil
   oNewImp     := nil
   oTrans      := nil
   oTipArt     := nil
   oGrpFam     := nil
   oUndMedicion:= nil
   oBanco      := nil

   oWndBrw     := nil

   lOpenFiles  := .f.

RETURN .T.

//--------------------------------------------------------------------------//

FUNCTION FacRec( oMenuItem, oWnd, cCodCli, cCodArt, cCodPed, aNumDoc )

   local oRpl
   local oSnd
   local oImp
   local oPrv
   local oDel
   local oPdf
   local oMail
   local oDup
   local oBtnEur
   local lEuro          := .f.
   local nLevel
   local oRotor
   local oLiq
   local oScript

   DEFAULT  oMenuItem   := _MENUITEM_
   DEFAULT  oWnd        := oWnd()
   DEFAULT  aNumDoc     := Array(3)
   DEFAULT  cCodCli     := ""
   DEFAULT  cCodArt     := ""
   DEFAULT  cCodPed     := ""

   nLevel            := Auth():Level( oMenuItem )
   if nAnd( nLevel, 1 ) == 0
      msgStop( "Acceso no permitido." )
      Return Nil
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

   DEFINE SHELL oWndBrw FROM 0, 0 TO 22, 80 ;
      XBROWSE ;
      TITLE    "Facturas rectificativas" ;
      PROMPT   "Número",;
               "Fecha",;
               "Código",;
               "Nombre",;
               "Código postal",;
               "Población",;
               "Provincia",;
               "Dirección",;
               "Sesión",;
               "Agente",;
               "Pago",;
               "Total";
      MRU      "gc_document_text_delete_16";
      BITMAP   clrTopArchivos ;
      ALIAS    ( D():FacturasRectificativas( nView ) );
      APPEND   ( WinAppRec( oWndBrw:oBrw, bEdtRec, D():FacturasRectificativas( nView ), cCodCli, cCodArt, aNumDoc ) ) ;
      DUPLICAT ( WinDupRec( oWndBrw:oBrw, bEdtRec, D():FacturasRectificativas( nView ), cCodCli, cCodArt, aNumDoc ) ) ;
      EDIT     ( WinEdtRec( oWndBrw:oBrw, bEdtRec, D():FacturasRectificativas( nView ), cCodCli, cCodArt, aNumDoc ) ) ;
      DELETE   ( WinDelRec( oWndBrw:oBrw, D():FacturasRectificativas( nView ), {|| QuiFacRec() } ) ) ;
      LEVEL    nLevel ;
      OF       oWnd

	  oWndBrw:lFechado     := .t.

	  oWndBrw:SetYearComboBoxChange( {|| YearComboBoxChange() } )

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Sesión cerrada"
         :nHeadBmpNo       := 3
         :bStrData         := {|| "" }
         :bEditValue       := {|| ( D():FacturasRectificativas( nView ) )->lCloFac }
         :nWidth           := 20
         :SetCheck( { "Sel16", "Nil16" } )
         :AddResource( "gc_lock2_16" )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Cobrado"
         :nHeadBmpNo       := 4
         :bStrData         := {|| "" }
         :bBmpData         := {|| nChkPagFacRec( ( D():FacturasRectificativas( nView ) )->cSerie + Str( ( D():FacturasRectificativas( nView ) )->nNumFac ) + ( D():FacturasRectificativas( nView ) )->cSufFac, D():FacturasRectificativas( nView ), dbfFacCliP ) }
         :nWidth           := 20
         :AddResource( "gc_check_12" )
         :AddResource( "gc_shape_square_12" )
         :AddResource( "gc_delete_12" )
         :AddResource( "gc_money2_16" )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Contabilizado"
         :nHeadBmpNo       := 3
         :bStrData         := {|| "" }
         :bEditValue       := {|| ( D():FacturasRectificativas( nView ) )->lConTab }
         :nWidth           := 20
         :SetCheck( { "gc_folder2_12", "Nil16" } )
         :AddResource( "gc_folder2_16" )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Envio"
         :nHeadBmpNo       := 3
         :bStrData         := {|| "" }
         :bEditValue       := {|| ( D():FacturasRectificativas( nView ) )->lSndDoc }
         :nWidth           := 20
         :SetCheck( { "gc_mail2_12", "Nil16" } )
         :AddResource( "gc_mail2_16" )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Entregado"
         :nHeadBmpNo       := 3
         :bStrData         := {|| "" }
         :bEditValue       := {|| !empty( ( D():FacturasRectificativas( nView ) )->dFecEnt ) }
         :nWidth           := 20
         :SetCheck( { "Sel16", "Nil16" } )
         :AddResource( "gc_document_text_check_16" )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Incidencia"
         :nHeadBmpNo       := 4
         :bStrData         := {|| "" }
         :bBmpData         := {|| nEstadoIncidencia( ( D():FacturasRectificativas( nView ) )->cSerie + Str( ( D():FacturasRectificativas( nView ) )->nNumFac ) + ( D():FacturasRectificativas( nView ) )->cSufFac ) }
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
         :bEditValue       := {|| ( D():FacturasRectificativas( nView ) )->lImprimido }
         :nWidth           := 20
         :lHide            := .t.
         :SetCheck( { "gc_printer2_12", "Nil16" } )
         :AddResource( "gc_printer2_16" )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Número"
         :cSortOrder       := "nNumFac"
         :bEditValue       := {|| ( D():FacturasRectificativas( nView ) )->cSerie + "/" + alltrim( Str( ( D():FacturasRectificativas( nView ) )->nNumFac ) )  }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Delegación"
         :bEditValue       := {|| ( D():FacturasRectificativas( nView ) )->cSufFac }
         :nWidth           := 40
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Sesión"
         :cSortOrder       := "cTurFac"
         :bEditValue       := {|| ( D():FacturasRectificativas( nView ) )->cTurFac }
         :nWidth           := 40
         :lHide            := .t.
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Fecha"
         :cSortOrder       := "dDesFec"
         :bEditValue       := {|| Dtoc( ( D():FacturasRectificativas( nView ) )->dFecFac ) }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Hora"
         :bEditValue       := {|| trans( ( D():FacturasRectificativas( nView ) )->tFecFac, "@R 99:99:99") }
         :nWidth           := 60
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Caja"
         :bEditValue       := {|| ( D():FacturasRectificativas( nView ) )->cCodCaj }
         :nWidth           := 40
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Usuario"
         :bEditValue       := {|| ( D():FacturasRectificativas( nView ) )->cCodUsr }
         :nWidth           := 40
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Código"
         :cSortOrder       := "cCodCli"
         :bEditValue       := {|| alltrim( ( D():FacturasRectificativas( nView ) )->cCodCli ) }
         :nWidth           := 70
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Nombre"
         :cSortOrder       := "cNomCli"
         :bEditValue       := {|| alltrim( ( D():FacturasRectificativas( nView ) )->cNomCli ) }
         :nWidth           := 180
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Código postal"
         :cSortOrder       := "CodPostal"
         :bEditValue       := {|| alltrim( ( D():FacturasRectificativas( nView ) )->cPosCli ) }
         :nWidth           := 60
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Población"
         :cSortOrder       := "cPobCli"
         :bEditValue       := {|| alltrim( ( D():FacturasRectificativas( nView ) )->cPobCli ) }
         :nWidth           := 180
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Provincia"
         :cSortOrder       := "Provincia"
         :bEditValue       := {|| alltrim( ( D():FacturasRectificativas( nView ) )->cPrvCli ) }
         :nWidth           := 100
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Agente"
         :cSortOrder       := "cCodAge"
         :bEditValue       := {|| ( D():FacturasRectificativas( nView ) )->cCodAge }
         :nWidth           := 50
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
         :bLDClickData     := {|| oWndBrw:RecEdit() }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Pago"
         :cSortOrder       := "cCodPago"
         :bEditValue       := {|| ( D():FacturasRectificativas( nView ) )->cCodPago }
         :nWidth           := 40
         :lHide            := .t.
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
         :bLDClickData     := {|| oWndBrw:RecEdit() }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Ruta"
         :bEditValue       := {|| ( D():FacturasRectificativas( nView ) )->cCodRut }
         :nWidth           := 40
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Almacén"
         :bEditValue       := {|| ( D():FacturasRectificativas( nView ) )->cCodAlm }
         :nWidth           := 60
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Dirección"
         :cSortOrder       := "cCodObr"
         :bEditValue       := {|| ( D():FacturasRectificativas( nView ) )->cCodObr }
         :nWidth           := 50
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Base"
         :bEditValue       := {|| ( D():FacturasRectificativas( nView ) )->nTotNet }
         :cEditPicture     := cPorDiv( ( D():FacturasRectificativas( nView ) )->cDivFac, dbfDiv )
         :nWidth           := 80
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := cImp()
         :bEditValue       := {|| ( D():FacturasRectificativas( nView ) )->nTotIva }
         :cEditPicture     := cPorDiv( ( D():FacturasRectificativas( nView ) )->cDivFac, dbfDiv )
         :nWidth           := 80
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "R.E."
         :bEditValue       := {|| ( D():FacturasRectificativas( nView ) )->nTotReq }
         :cEditPicture     := cPorDiv( ( D():FacturasRectificativas( nView ) )->cDivFac, dbfDiv )
         :nWidth           := 80
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Total"
         :bEditValue       := {|| ( D():FacturasRectificativas( nView ) )->nTotFac }
         :cEditPicture     := cPorDiv( ( D():FacturasRectificativas( nView ) )->cDivFac, dbfDiv )
         :nWidth           := 80
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
         :cSortOrder       := "nTotFac"
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Div."
         :bEditValue       := {|| cSimDiv( if( lEuro, cDivChg(), ( D():FacturasRectificativas( nView ) )->cDivFac ), dbfDiv ) }
         :nWidth           := 30
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Centro de coste"
         :bEditValue       := {|| ( D():FacturasRectificativas( nView ) )->cCtrCoste }
         :nWidth           := 30
         :lHide            := .t.
      end with

   oDetCamposExtra:addCamposExtra( oWndBrw )

   oWndBrw:cHtmlHelp    := "Rectificativas de clientes"
   
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

   DEFINE BTNSHELL RESOURCE "EDIT" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( oWndBrw:RecEdit() );
      TOOLTIP  "(M)odificar";
      HOTKEY   "M" ;
      MRU;
      LEVEL    ACC_EDIT

   DEFINE BTNSHELL RESOURCE "ZOOM" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( WinZooRec( oWndBrw:oBrw, bEdtRec, D():FacturasRectificativas( nView ) ) );
      TOOLTIP  "(Z)oom";
      HOTKEY   "Z" ;
      MRU;
      LEVEL    ACC_ZOOM

   DEFINE BTNSHELL oDel RESOURCE "DEL" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( WinDelRec( oWndBrw:oBrw, D():FacturasRectificativas( nView ), {|| QuiFacRec() } ) );
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
      ACTION   ( GenFacRec( IS_PRINTER ), oWndBrw:Refresh() ) ;
      TOOLTIP  "(I)mprimir";
      HOTKEY   "I";
      LEVEL    ACC_IMPR

      lGenFacRec( oWndBrw:oBrw, oImp, IS_PRINTER ) ;

   DEFINE BTNSHELL RESOURCE "GC_PRINTER2_" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( ImprimirSeriesFacturasRectificativas() );
      TOOLTIP  "Imp(r)imir series";
      HOTKEY   "R";
      LEVEL    ACC_IMPR

   DEFINE BTNSHELL oPrv RESOURCE "PREV1" OF oWndBrw ;
      NOBORDER ;
      MENU     This:Toggle() ;
      ACTION   ( GenFacRec( IS_SCREEN ), oWndBrw:Refresh() ) ;
      TOOLTIP  "(P)revisualizar";
      HOTKEY   "P";
      LEVEL    ACC_IMPR

      lGenFacRec( oWndBrw:oBrw, oPrv, IS_SCREEN ) ;

   DEFINE BTNSHELL oPdf RESOURCE "DOCLOCK" OF oWndBrw ;
      NOBORDER ;
      MENU     This:Toggle() ;
      ACTION   ( GenFacRec( IS_PDF ) ) ;
      TOOLTIP  "Pd(f)";
      HOTKEY   "F";
      LEVEL    ACC_IMPR

      lGenFacRec( oWndBrw:oBrw, oPdf, IS_PDF ) ;

   DEFINE BTNSHELL oMail RESOURCE "GC_MAIL_EARTH_" OF oWndBrw ;
      NOBORDER ;
      MENU     This:Toggle() ;
      ACTION   ( oMailing:documentsDialog( oWndBrw:oBrw:aSelected ) ) ;
      TOOLTIP  "Correo electrónico";
      LEVEL    ACC_IMPR

   DEFINE BTNSHELL RESOURCE "gc_portable_barcode_scanner_" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( TLabelGeneratorFacturasRectificativaClientes():New( nView ):Dialog() ) ;
      TOOLTIP  "Eti(q)uetas" ;
      HOTKEY   "Q";
      LEVEL    ACC_IMPR

   DEFINE BTNSHELL oLiq RESOURCE "gc_money2_" GROUP OF oWndBrw ;
      NOBORDER ;
      ACTION   ( lLiquida( oWndBrw:oBrw ) ) ;
      TOOLTIP  "Cobrar" ;
      LEVEL    ACC_EDIT

   DEFINE BTNSHELL RESOURCE "gc_money2_" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( aGetSelRec( oWndBrw, {|| lLiquida( oWndBrw:oBrw, ( D():FacturasRectificativas( nView ) )->cSerie + Str( ( D():FacturasRectificativas( nView ) )->nNumFac ) + ( D():FacturasRectificativas( nView ) )->cSufFac ) }, "Liquidar series de facturas", .t., nil, .t., nil ) ) ;
      TOOLTIP  "Cobrar series" ;
      FROM     oLiq ;
      CLOSED ;
      LEVEL    ACC_EDIT

   DEFINE BTNSHELL RESOURCE "BMPCONTA" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( aGetSelRec( oWndBrw, {|lChk1, lChk2, oTree| CntFacRec( lChk1, lChk2, nil, .t., oTree, nil, nil, D():FacturasRectificativas( nView ), D():FacturasRectificativasLineas( nView ), dbfFacCliP, D():Clientes( nView ), dbfDiv, D():Articulos( nView ), dbfFPago, dbfIva, oNewImp ) }, "Contabilizar facturas rectificativas", .f., "Simular resultados", .f., "Contabilizar recibos", {|| oDiario() }, {|| cDiario() } ) ) ;
      TOOLTIP  "(C)ontabilizar" ;
      HOTKEY   "C";
      LEVEL    ACC_EDIT

   if oUser():lAdministrador()

   DEFINE BTNSHELL RESOURCE "CHGSTATE" OF oWndBrw GROUP;
      NOBORDER ;
      ACTION   ( aGetSelRec( oWndBrw, {| lChk1 | if( ( D():FacturasRectificativas( nView ) )->( dbRLock() ), ( ( D():FacturasRectificativas( nView ) )->lContab := lChk1, ( D():FacturasRectificativas( nView ) )->( dbUnlock() ) ), ) }, "Cambiar estado", .f., "Contabilizado", .t. ) ) ;
      TOOLTIP  "Cambiar es(t)ado" ;
      HOTKEY   "T";
      LEVEL    ACC_EDIT

   end if

   DEFINE BTNSHELL oSnd RESOURCE "LBL" GROUP OF oWndBrw ;
      NOBORDER ;
      MENU     This:Toggle() ;
      TOOLTIP  "En(v)iar" ;
      MESSAGE  "Seleccionar albaranes para ser enviados" ;
      ACTION   lSnd( oWndBrw, D():FacturasRectificativas( nView ) ) ;
      HOTKEY   "V";
      LEVEL    ACC_EDIT

   DEFINE BTNSHELL RESOURCE "LBL" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( lSelectAll( oWndBrw, D():FacturasRectificativas( nView ), "lSndDoc", .t., .t., .t. ) );
      TOOLTIP  "Todos" ;
      FROM     oSnd ;
      CLOSED ;
      LEVEL    ACC_EDIT

   DEFINE BTNSHELL RESOURCE "LBL" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( lSelectAll( oWndBrw, D():FacturasRectificativas( nView ), "lSndDoc", .f., .t., .t. ) );
      TOOLTIP  "Ninguno" ;
      FROM     oSnd ;
      CLOSED ;
      LEVEL    ACC_EDIT

   DEFINE BTNSHELL RESOURCE "LBL" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( lSelectAll( oWndBrw, D():FacturasRectificativas( nView ), "lSndDoc", .t., .f., .t. ) );
      TOOLTIP  "Abajo" ;
      FROM     oSnd ;
      CLOSED ;
      LEVEL    ACC_EDIT

   DEFINE BTNSHELL oBtnEur RESOURCE "gc_currency_euro_" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( lEuro := !lEuro, oWndBrw:Refresh() ) ;
      TOOLTIP  "M(o)neda";
      HOTKEY   "O";
      LEVEL    ACC_ZOOM

   DEFINE BTNSHELL RESOURCE "gc_document_text_pencil_" OF oWndBrw ;
	   NOBORDER ;
	   ACTION   ( Counter:OpenDialog() ) ;
	   TOOLTIP  "Establecer contadores" 

   if oUser():lAdministrador()

   DEFINE BTNSHELL oRpl RESOURCE "BMPCHG" GROUP OF oWndBrw ;
      NOBORDER ;
      MENU     This:Toggle() ;
      ACTION   ( ReplaceCreator( oWndBrw, D():FacturasRectificativas( nView ), aItmFacRec() ) ) ;
      TOOLTIP  "Cambiar campos" ;
      LEVEL    ACC_EDIT

   DEFINE BTNSHELL RESOURCE "BMPCHG" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( ReplaceCreator( oWndBrw, D():FacturasRectificativasLineas( nView ), aColFacRec() ) ) ;
      TOOLTIP  "Lineas" ;
      FROM     oRpl ;
      CLOSED ;
      LEVEL    ACC_EDIT

   end if

   DEFINE BTNSHELL oRotor RESOURCE "ROTOR" GROUP OF oWndBrw ;
      NOBORDER ;
      MENU     This:Toggle() ;
      ACTION   ( oRotor:Expand() ) ;
      TOOLTIP  "Rotor" ;

   DEFINE BTNSHELL RESOURCE "GC_USER_" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( EdtCli( ( D():FacturasRectificativas( nView ) )->cCodCli ) );
      TOOLTIP  "Modificar cliente" ;
      FROM     oRotor ;
      CLOSED ;

   DEFINE BTNSHELL RESOURCE "INFO" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( InfCliente( ( D():FacturasRectificativas( nView ) )->cCodCli ) );
      TOOLTIP  "Informe de cliente" ;
      FROM     oRotor ;
      CLOSED ;

	DEFINE BTNSHELL oScript RESOURCE "gc_folder_document_" GROUP OF oWndBrw ;
      NOBORDER ;
      ACTION   ( oScript:Expand() ) ;
      TOOLTIP  "Scripts" ;

      ImportScript( oWndBrw, oScript, "FacturasRectificativasClientes" )  

   DEFINE BTNSHELL RESOURCE "GC_CLIPBOARD_EMPTY_USER_" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( EdtObras( ( D():FacturasRectificativas( nView ) )->cCodCli, ( D():FacturasRectificativas( nView ) )->cCodObr, dbfObrasT ) );
      TOOLTIP  "Modificar dirección" ;
      FROM     oRotor ;
      CLOSED ;

   DEFINE BTNSHELL RESOURCE "END"  GROUP OF oWndBrw ;
      NOBORDER ;
      ACTION   ( oWndBrw:End() ) ;
      TOOLTIP  "(S)alir";
      HOTKEY   "S"

   /*
   Datos para el filtro-----------------------------------------------------
   */

   if SQLAjustableModel():getRolNoFiltrarVentas( Auth():rolUuid() )
      oWndBrw:oActiveFilter:SetFields( aItmFacRec() )
      oWndBrw:oActiveFilter:SetFilterType( FAC_REC )
   end if

   ACTIVATE WINDOW oWndBrw VALID ( CloseFiles() )

   if !empty( oWndBrw )

      if uFieldempresa( 'lFltYea' )
         oWndBrw:setYearCombobox()
      end if

      if !empty( cCodCli ) .or. !empty( cCodArt ) .or. !empty( aNumDoc[ 1 ] ) .or. !empty( aNumDoc[ 2 ] ) .or. !empty( aNumDoc[ 3 ] )
         oWndBrw:RecAdd()
         cCodCli        := nil
         cCodArt        := nil
         aNumDoc        := Array( 3 )
      end if

   end if 

Return .t.

//----------------------------------------------------------------------------//

STATIC FUNCTION EdtRec( aTmp, aGet, dbf, oBrw, cCodCli, cCodArt, nMode, aNumDoc )

   local oDlg
	local oFld
   local oBrwLin
   local oBrwInc
   local oBrwDoc
   local oBrwPgo
   local oBrwEst
   local oSay              := Array( 12 )
   local cSay              := Array( 12 )
   local oSayLabels        := Array( 9 )
   local oBmpDiv
   local oBmpEmp
   local nOrd
   local oBtnKit
   local oTlfCli
   local cTlfCli
   local oRieCli
   local nRieCli
   local oGetMasDiv
   local cGetMasDiv        := ""
   local cSerie
   local oSayGetRnt
   local oBmpGeneral

   DEFAULT cSerie          := cNewSer( "nFacRec", dbfCount )
   DEFAULT aNumDoc         := Array( 3 )

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

      aTmp[ _CTURFAC    ]  := cCurSesion()
      aTmp[ _DFECENT    ]  := cToD("")
      aTmp[ _CCODALM    ]  := Application():codigoAlmacen()
      aTmp[ _CCODCAJ    ]  := Application():CodigoCaja()
      aTmp[ _CCODPAGO   ]  := cDefFpg()
      aTmp[ _CDIVFAC    ]  := cDivEmp()
      aTmp[ _NVDVFAC    ]  := nChgDiv( aTmp[ _CDIVFAC ], dbfDiv )
      aTmp[ _CSUFFAC    ]  := RetSufEmp()
      aTmp[ _LSNDDOC    ]  := .t.
      aTmp[ _CCODPRO    ]  := cProCnt()
      aTmp[ _CCODUSR    ]  := Auth():Codigo()
      aTmp[ _CTIPMOV    ]  := cDefVta()
      aTmp[ _CCODDLG    ]  := Application():CodigoDelegacion()
      aTmp[ _LIVAINC    ]  := uFieldEmpresa( "lIvaInc" )
      aTmp[ _CMANOBR    ]  := padr( getConfigTraslation( "Gastos" ), 250 )
      aTmp[ _TFECFAC    ]  := getSysTime()

      if !empty( cCodCli )
         aTmp[ _CCODCLI ]  := cCodCli
      end if

      aTmp[ _NIVAMAN    ]  := nIva( dbfIva, cDefIva() )

   case nMode == DUPL_MODE

      if !lCurSesion()
         MsgStop( "No hay sesiones activas, imposible añadir documentos" )
         Return .f.
      end if

      if !lCajaOpen( Application():CodigoCaja() ) .and. !oUser():lAdministrador()
         msgStop( "Esta caja " + Application():CodigoCaja() + " esta cerrada." )
         Return .f.
      end if

      aTmp[ _DFECFAC  ]    := GetSysDate()
      aTmp[ _CNUMFAC  ]    := ""
      aTmp[ _LIMPALB  ]    := .f.
      aTmp[ _LCLOFAC  ]    := .f.
      aTmp[ _LCONTAB  ]    := .f.
      aTmp[ _LSNDDOC  ]    := .t.
      aTmp[ _CCODUSR    ]  := Auth():Codigo()

   case nMode == EDIT_MODE

      if aTmp[ _LCLOFAC ] .AND. !oUser():lAdministrador()
         msgStop( "Solo puede modificar las facturas cerradas los administradores." )
         return .f.
      end if

      if aTmp[ _LCONTAB ] .and.;
         !ApoloMsgNoYes(  "La modificación de esta factura puede provocar descuadres contables." + CRLF + "¿ Desea continuar ?", "Factura ya contabilizada" )
         return .f.
      end if

      lChangeRegIva( aTmp )

   end case

   /*
   Este valor los guaradamos para detectar los posibles cambios
   */

   cOldCodCli              := aTmp[_CCODCLI]

   /*
   Necestamos el orden el la primera clave
   */

   nOrd                    := ( D():FacturasRectificativas( nView ) )->( ordSetFocus( 1 ) )

   /*
   Valores por defecto---------------------------------------------------------
   */

   if empty( Rtrim( aTmp[ _CSERIE ] ) )
      aTmp[ _CSERIE ]      := cSerie
   end if

   if empty( aTmp[_NTARIFA] )
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

   nRieCli                 := oStock:nRiesgo( aTmp[ _CCODCLI ] )

   if empty( aTmp[ _CTLFCLI ] )
      aTmp[ _CTLFCLI ]     := RetFld( aTmp[ _CCODCLI ], D():Clientes( nView ), "Telefono" )
   end if

   if BeginTrans( aTmp, nMode )
      Return .f.
   end if

   cPicUnd                 := MasUnd()                            // Picture de las unidades
   cPouDiv                 := cPouDiv( aTmp[ _CDIVFAC ], dbfDiv ) // Picture de la divisa
   cPorDiv                 := cPorDiv( aTmp[ _CDIVFAC ], dbfDiv ) // Picture de la divisa redondeada
   cPinDiv                 := cPinDiv( aTmp[ _CDIVFAC ], dbfDiv ) // Picture de la divisa
   nDouDiv                 := nDouDiv( aTmp[ _CDIVFAC ], dbfDiv ) // Decimales de la divisa
   nRouDiv                 := nRouDiv( aTmp[ _CDIVFAC ], dbfDiv ) // Decimales de la divisa redondeada
   cPpvDiv                 := cPpvDiv( aTmp[ _CDIVFAC ], dbfDiv ) // Picture del punto verde
   nDpvDiv                 := nDpvDiv( aTmp[ _CDIVFAC ], dbfDiv ) // Decimales de redondeo del punto verde

   oFont                   := TFont():New( "Arial", 8, 26, .F., .T. )

   /*
   Etiquetas-------------------------------------------------------------------
   */

   cSay[ 2 ]               := RetFld( aTmp[ _CCODALM ], dbfAlm )
   cSay[ 4 ]               := RetFld( aTmp[ _CCODPAGO], dbfFPago )
   cSay[ 8 ]               := RetFld( aTmp[ _CCODRUT ], dbfRuta )
   cSay[ 3 ]               := RetFld( aTmp[ _CCODAGE ], dbfAgent )
   cSay[ 5 ]               := RetFld( aTmp[ _CCODTAR ], dbfTarPreS )
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

   DEFINE DIALOG oDlg RESOURCE "FacCli" TITLE LblTitle( nMode ) + "facturas rectificativas"

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
                  "&Situaciones" ;
         DIALOGS  "FACREC_01",;
                  "FACREC_02",;
                  "PEDCLI_3",;
                  "PEDCLI_4",;
                  "PEDCLI_5"

      /*
      Datos del cliente--------------------------------------------------------
      */

      REDEFINE BITMAP oBmpGeneral ;
        ID       990 ;
        RESOURCE "gc_document_text_delete_48" ;
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
        RESOURCE "gc_document_attachment_48" ;
        TRANSPARENT ;
        OF       oFld:aDialogs[5]

		REDEFINE GET aGet[ _CCODCLI] VAR aTmp[_CCODCLI] ;
         ID       170 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( loaCli( aGet, aTmp, nMode, oRieCli ), RecalculaTotal( aTmp ) );
         BITMAP   "LUPA" ;
         ON HELP  ( BrwClient( aGet[ _CCODCLI ], aGet[ _CNOMCLI ] ), ::lValid() ) ;
			OF 		oFld:aDialogs[1]

      REDEFINE GET aGet[ _CNOMCLI ] VAR aTmp[ _CNOMCLI ] ;
         ID       180 ;
         WHEN     ( nMode != ZOOM_MODE .and. ( !aTmp[ _LMODCLI ] .or. oUser():lAdministrador() ) ) ;
			OF 		oFld:aDialogs[1]

      if uFieldEmpresa( "nCifRut" ) == 1

      REDEFINE GET aGet[ _CDNICLI ] VAR aTmp[ _CDNICLI ] ;
         ID       181 ;
         WHEN     ( nMode != ZOOM_MODE .and. ( !aTmp[ _LMODCLI ] .or. oUser():lAdministrador() ) ) ;
         VALID    ( CheckCif( aGet[ _CDNICLI ] ) );
         OF       oFld:aDialogs[1]

      else

      REDEFINE GET aGet[ _CDNICLI ] VAR aTmp[ _CDNICLI ] ;
         ID       181 ;
         WHEN     ( nMode != ZOOM_MODE .and. ( !aTmp[ _LMODCLI ] .or. oUser():lAdministrador() ) ) ;
         PICTURE  "@R 999999999-9" ;
         VALID    ( CheckRut( aGet[ _CDNICLI ] ) );
         OF       oFld:aDialogs[1]

      end if

      REDEFINE GET aGet[ _CDIRCLI ] VAR aTmp[ _CDIRCLI ] ;
         ID       183 ;
         BITMAP   "gc_earth_lupa_16" ;
         ON HELP  GoogleMaps( aTmp[ _CDIRCLI ], Rtrim( aTmp[ _CPOBCLI ] ) + Space( 1 ) + Rtrim( aTmp[ _CPRVCLI ] ) ) ;
         WHEN     ( nMode != ZOOM_MODE .and. ( !aTmp[ _LMODCLI ] .or. oUser():lAdministrador() ) ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CPOSCLI] VAR aTmp[_CPOSCLI] ;
         ID       184 ;
         WHEN     ( nMode != ZOOM_MODE .and. ( !aTmp[ _LMODCLI ] .or. oUser():lAdministrador() ) ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CPOBCLI] VAR aTmp[_CPOBCLI] ;
         ID       185 ;
         WHEN     ( nMode != ZOOM_MODE .and. ( !aTmp[ _LMODCLI ] .or. oUser():lAdministrador() ) ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CPRVCLI] VAR aTmp[_CPRVCLI] ;
         ID       186 ;
         WHEN     ( nMode != ZOOM_MODE .and. ( !aTmp[ _LMODCLI ] .or. oUser():lAdministrador() ) ) ;
         OF       oFld:aDialogs[1]

   	REDEFINE GET aGet[ _CTLFCLI] VAR aTmp[_CTLFCLI] ;
      	ID       187 ;
      	WHEN     ( nMode != ZOOM_MODE .and. ( !aTmp[ _LMODCLI ] .or. oUser():lAdministrador() ) ) ;
      	OF       oFld:aDialogs[1]

   	REDEFINE GET oRieCli VAR nRieCli;
      	ID       182 ;
      	WHEN     ( nMode != ZOOM_MODE );
      	PICTURE  cPorDiv ;
      	OF       oFld:aDialogs[1]

     	/*
		Tarifas----------------------------------
      */

      oGetTarifa 		:= comboTarifa():Build( { "idCombo" => 171, "uValue" => aTmp[ _NTARIFA ] } )
      oGetTarifa:Resource( oFld:aDialogs[1] )
      oGetTarifa:setWhen( {|| nMode != ZOOM_MODE .and. ( SQLAjustableModel():getRolCambiarPrecios( Auth():rolUuid() ) ) } )

      REDEFINE BTNBMP oBtnPrecio ;
         ID       174 ;
         OF       oFld:aDialogs[1] ;
         RESOURCE "gc_arrow_down_16" ;
         NOBORDER ;
         ACTION   ( ChangeTarifaCabecera( oGetTarifa:getTarifa(), dbfTmpLin, oBrwLin ) );
         WHEN     ( nMode != ZOOM_MODE .and. ( SQLAjustableModel():getRolCambiarPrecios( Auth():rolUuid() ) ) )

      /*
      Bancos-------------------------------------------------------------------
      */

      REDEFINE GET aGet[ _CBANCO ] VAR aTmp[ _CBANCO ];
      	ID       410 ;
      	COLOR    CLR_GET ;
      	WHEN     ( nMode != ZOOM_MODE );
      	BITMAP   "LUPA" ;
      	ON HELP  ( BrwBncCli( aGet[ _CBANCO ], aGet[ _CPAISIBAN ], aGet[ _CCTRLIBAN ], aGet[ _CENTBNC ], aGet[ _CSUCBNC ], aGet[ _CDIGBNC ], aGet[ _CCTABNC ], aTmp[ _CCODCLI ] ) );
      	OF       oFld:aDialogs[1]

   	REDEFINE GET aGet[ _CPAISIBAN ] VAR aTmp[ _CPAISIBAN ] ;
      	PICTURE  "@!" ;
      	ID       305 ;
      	COLOR    CLR_GET ;
      	WHEN     ( nMode != ZOOM_MODE );
        	VALID    ( lIbanDigit( aTmp[ _CPAISIBAN ], aTmp[ _CENTBNC ], aTmp[ _CSUCBNC ], aTmp[ _CDIGBNC ], aTmp[ _CCTABNC ], aGet[ _CCTRLIBAN ] ) ) ;
      	OF       oFld:aDialogs[1]

   	REDEFINE GET aGet[ _CCTRLIBAN ] VAR aTmp[ _CCTRLIBAN ] ;
      	ID       306 ;
      	COLOR    CLR_GET ;
      	WHEN     ( nMode != ZOOM_MODE );
      	VALID    ( lIbanDigit( aTmp[ _CPAISIBAN ], aTmp[ _CENTBNC ], aTmp[ _CSUCBNC ], aTmp[ _CDIGBNC ], aTmp[ _CCTABNC ], aGet[ _CCTRLIBAN ] ) ) ;
      	OF       oFld:aDialogs[1]

   	REDEFINE GET aGet[ _CENTBNC ] VAR aTmp[ _CENTBNC ];
      	ID       301 ;
      	COLOR    CLR_GET ;
      	WHEN     ( nMode != ZOOM_MODE );
      	VALID    (  lCalcDC( aTmp[ _CENTBNC ], aTmp[ _CSUCBNC ], aTmp[ _CDIGBNC ], aTmp[ _CCTABNC ], aGet[ _CDIGBNC ] ),;
                  aGet[ _CPAISIBAN ]:lValid() ) ;
      	OF       oFld:aDialogs[1]

   	REDEFINE GET aGet[ _CSUCBNC ] VAR aTmp[ _CSUCBNC ];
      	ID       302 ;
      	COLOR    CLR_GET ;
      	WHEN     ( nMode != ZOOM_MODE );
      	VALID    (  lCalcDC( aTmp[ _CENTBNC ], aTmp[ _CSUCBNC ], aTmp[ _CDIGBNC ], aTmp[ _CCTABNC ], aGet[ _CDIGBNC ] ),;
                  aGet[ _CPAISIBAN ]:lValid() ) ;
      	OF       oFld:aDialogs[1]

   	REDEFINE GET aGet[ _CDIGBNC ] VAR aTmp[ _CDIGBNC ];
      	ID       303 ;
      	COLOR    CLR_GET ;
      	WHEN     ( nMode != ZOOM_MODE );
      	VALID    (  lCalcDC( aTmp[ _CENTBNC ], aTmp[ _CSUCBNC ], aTmp[ _CDIGBNC ], aTmp[ _CCTABNC ], aGet[ _CDIGBNC ] ),;
                  aGet[ _CPAISIBAN ]:lValid() ) ;
      	OF       oFld:aDialogs[1]

   	REDEFINE GET aGet[ _CCTABNC ] VAR aTmp[ _CCTABNC ];
      	ID       304 ;
      	COLOR    CLR_GET ;
      	WHEN     ( nMode != ZOOM_MODE );
      	PICTURE  "9999999999" ;
      	VALID    (  lCalcDC( aTmp[ _CENTBNC ], aTmp[ _CSUCBNC ], aTmp[ _CDIGBNC ], aTmp[ _CCTABNC ], aGet[ _CDIGBNC ] ),;
                  aGet[ _CPAISIBAN ]:lValid() ) ;
        	OF       oFld:aDialogs[1]

      /*
      Codigo de Divisas________________________________________________________
		*/

   	REDEFINE GET aGet[ _CDIVFAC ] VAR aTmp[ _CDIVFAC ];
      	WHEN     ( nMode == APPD_MODE .AND. ( dbfTmpLin )->( LastRec() ) == 0 ) ;
      	VALID    ( cDivOut( aGet[ _CDIVFAC ], oBmpDiv, aTmp[ _NVDVFAC ], @cPouDiv, @nDouDiv, @cPorDiv, @nRouDiv, @cPpvDiv, @nDpvDiv, oGetMasDiv, dbfDiv, oBandera ) );
      	PICTURE  "@!";
      	ID       190 ;
      	BITMAP   "LUPA" ;
      	ON HELP  BrwDiv( aGet[ _CDIVFAC ], oBmpDiv, aTmp[ _NVDVFAC ], dbfDiv, oBandera ) ;
			OF 		oFld:aDialogs[1]

		REDEFINE BITMAP oBmpDiv ;
      	RESOURCE "BAN_EURO" ;
      	ID       191;
         OF 		oFld:aDialogs[1]

      REDEFINE GET aGet[ _NVDVFAC ] VAR aTmp[ _NVDVFAC ];
         WHEN     ( .f. ) ;
         ID       192 ;
         PICTURE  "@E 999,999.9999" ;
         OF       oFld:aDialogs[1]

   	REDEFINE GET aGet[ _CCODUSR ] VAR aTmp[ _CCODUSR ];
      	ID       125 ;
      	WHEN     ( .f. ) ;
      	VALID    ( SetUsuario( aGet[ _CCODUSR ], oSay[ 11 ], nil, dbfUsr ) );
      	OF       oFld:aDialogs[2]

   	REDEFINE GET oSay[ 11 ] VAR cSay[ 11 ] ;
      	ID       126 ;
      	WHEN     ( .f. ) ;
      	OF       oFld:aDialogs[2]

      /*
      impuestos Incluido-------------------------------------------------------------
      */

   	REDEFINE CHECKBOX aGet[ _LIVAINC] VAR aTmp[_LIVAINC] ;
      	ID       200 ;
      	WHEN     ( ( dbfTmpLin )->( LastRec() ) == 0 ) ;
      	OF       oFld:aDialogs[1]

      /*
		Codigo de Tarifa_______________________________________________________________
		*/

   	REDEFINE GET aGet[ _CCODTAR] VAR aTmp[_CCODTAR] ;
      	ID       210 ;
      	WHEN     ( nMode != ZOOM_MODE .and. oUser():lAdministrador() ) ;
      	VALID    ( cTarifa( aGet[ _CCODTAR], oSay[ 5 ] ) ) ;
      	BITMAP   "LUPA" ;
      	ON HELP  ( BrwTarifa( aGet[ _CCODTAR], oSay[ 5 ] ) ) ;
			OF 		oFld:aDialogs[1]

   	REDEFINE GET oSay[ 5 ] VAR cSay[ 5 ] ;
			WHEN 		.F. ;
      	ID       211 ;
			OF 		oFld:aDialogs[1]

		/*
      Codigo de obra__________________________________________________________________
		*/

		REDEFINE GET aGet[ _CCODOBR] VAR aTmp[_CCODOBR] ;
      	ID       220 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
      	VALID    ( cObras( aGet[ _CCODOBR], oSay[ 7 ], aTmp[_CCODCLI] ) ) ;
      	BITMAP   "LUPA" ;
      	ON HELP  ( brwObras( aGet[ _CCODOBR], oSay[ 7 ], aTmp[_CCODCLI], dbfObrasT ) ) ;
			OF 		oFld:aDialogs[1]

   	REDEFINE GET oSay[ 7 ] VAR cSay[ 7 ] ;
			WHEN 		.F. ;
      	ID       221 ;
			OF 		oFld:aDialogs[1]

		/*
      Codigo de almacen________________________________________________________________
		*/

		REDEFINE GET aGet[ _CCODALM ] VAR aTmp[ _CCODALM ] ;
      	ID       230 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
      	VALID    ( cAlmacen( aGet[ _CCODALM ], , oSay[ 2 ] ) ) ;
      	BITMAP   "LUPA" ;
      	ON HELP  ( BrwAlmacen( aGet[ _CCODALM ], oSay[ 2 ] ) ) ;
			OF 		oFld:aDialogs[1]

   	REDEFINE GET oSay[ 2 ] VAR cSay[ 2 ] ;
      	ID       231 ;
      	WHEN     ( nMode != ZOOM_MODE );
      	BITMAP   "Bot" ;
      	ON HELP  ( ExpAlmacen( aTmp[ _CCODALM ], dbfTmpLin, oBrwLin ) ) ;
   		OF 		oFld:aDialogs[1]

		/*
      Formas de pago_____________________________________________________________________
		*/

   	REDEFINE GET aGet[ _CCODPAGO ] VAR aTmp[ _CCODPAGO ];
      	ID       240 ;
			PICTURE 	"@!" ;
      	WHEN     ( nMode != ZOOM_MODE );
      	VALID    ( cFPago( aGet[ _CCODPAGO ], dbfFPago, oSay[ 4 ] ) ) ;
      	BITMAP   "LUPA" ;
      	ON HELP  ( BrwFPago( aGet[ _CCODPAGO ], oSay[ 4 ] ) );
			OF 		oFld:aDialogs[1]

   	REDEFINE GET oSay[ 4 ] VAR cSay[ 4 ];
      	ID       241 ;
			WHEN 		.F. ;
			COLOR 	CLR_GET ;
			OF 		oFld:aDialogs[1]

		/*
      Codigo de Agente___________________________________________________________________
		*/

   	REDEFINE GET aGet[ _CCODAGE ] VAR aTmp[ _CCODAGE ] ;
         ID       250 ;
         WHEN 		( nMode != ZOOM_MODE ) ;
         VALID    ( LoadAgente( aGet[ _CCODAGE], dbfAgent, oSay[ 3 ], aGet[ _NPCTCOMAGE], dbfAgeCom, dbfTmpLin, oBrwLin ), RecalculaTotal( aTmp ) );
         BITMAP   "LUPA" ;
         ON HELP  ( BrwAgentes( aGet[ _CCODAGE], oSay[ 3 ] ) );
         OF 		oFld:aDialogs[1]

      REDEFINE GET oSay[ 3 ] VAR cSay[ 3 ] ;
      	ID       251 ;
      	WHEN     ( !empty( aTmp[ _CCODAGE ] ) .and. nMode != ZOOM_MODE ) ;
      	BITMAP   "Bot" ;
      	ON HELP  ( changeAgentPercentageInAllLines( aTmp[ _NPCTCOMAGE ], dbfTmpLin, oBrwLin ), RecalculaTotal( aTmp ) ) ;
      	OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _NPCTCOMAGE ] VAR aTmp[ _NPCTCOMAGE ] ;
      	ID       252 ;
      	WHEN     ( !empty( aTmp[ _CCODAGE ] ) .and. nMode != ZOOM_MODE ) ;
      	VALID    ( validateAgentPercentage( aGet[ _NPCTCOMAGE ], dbfTmpLin, oBrwLin ), RecalculaTotal( aTmp ) ) ;
      	PICTURE  "@E 99.99" ;
      	SPINNER ;
      	OF       oFld:aDialogs[1]

      REDEFINE GET oGetAge VAR nTotAge ;
      	ID       253 ;
      	WHEN     ( .f. );
      	OF       oFld:aDialogs[1]

      /*
		Ruta____________________________________________________________________
		*/

		REDEFINE GET aGet[ _CCODRUT] VAR aTmp[_CCODRUT] ;
        	ID       260 ;
			COLOR 	CLR_GET ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         VALID    ( cRuta( aGet[ _CCODRUT], dbfRuta, oSay[ 8 ] ) );
         BITMAP   "LUPA" ;
         ON HELP  ( BrwRuta( aGet[ _CCODRUT ], dbfRuta, oSay[ 8 ] ) );
         OF       oFld:aDialogs[1]

   	REDEFINE GET oSay[ 8 ] VAR cSay[ 8 ] ;
         ID       261 ;
         WHEN 		.F. ;
         OF       oFld:aDialogs[1]

      /*
       Botones de acceso________________________________________________________________
       */

		REDEFINE BUTTON ;
			ID 		500 ;
			OF 		oFld:aDialogs[1] ;
      	WHEN     ( nMode != ZOOM_MODE ) ;
      	ACTION   ( AppDeta( oBrwLin, bEdtDet, aTmp, .f. ) )

		REDEFINE BUTTON ;
			ID 		501 ;
			OF 		oFld:aDialogs[1] ;
      	WHEN     ( nMode != ZOOM_MODE ) ;
      	ACTION   ( EdtDeta( oBrwLin, bEdtDet, aTmp, .f., nMode ) )

		REDEFINE BUTTON ;
			ID 		502 ;
			OF 		oFld:aDialogs[1] ;
      	WHEN     ( nMode != ZOOM_MODE ) ;
      	ACTION   ( WinDelRec( oBrwLin, dbfTmpLin, {|| DelDeta() }, {|| RecalculaTotal( aTmp ) } ) );

		REDEFINE BUTTON ;
			ID 		503 ;
			OF 		oFld:aDialogs[1] ;
         ACTION   ( WinZooRec( oBrwLin, bEdtDet, dbfTmpLin, .f., nMode, aTmp ) )

      	REDEFINE BUTTON ;
			ID 		515 ;
			OF 		oFld:aDialogs[1] ;
      	WHEN     ( nMode != ZOOM_MODE ) ;
      	ACTION   ( AppDeta( oBrwLin, bEdtDet, aTmp, .t. ) )

      	REDEFINE BUTTON ;
			ID 		524 ;
			OF 		oFld:aDialogs[1] ;
			WHEN 		( nMode != ZOOM_MODE ) ;
      	ACTION   ( LineUp( dbfTmpLin, oBrwLin ), RecalculaTotal( aTmp ) )

		REDEFINE BUTTON ;
			ID 		525 ;
			OF 		oFld:aDialogs[1] ;
			WHEN 		( nMode != ZOOM_MODE ) ;
      	ACTION   ( LineDown( dbfTmpLin, oBrwLin ), RecalculaTotal( aTmp ) )

      REDEFINE BUTTON oBtnKit;
      	ID       526 ;
			OF 		oFld:aDialogs[1] ;
      	ACTION   ( ShowKit( D():FacturasRectificativas( nView ), dbfTmpLin, oBrwLin, .t. ) )

		REDEFINE BUTTON ;
         ID       527 ;
         OF       oFld:aDialogs[1] ;
         ACTION   ( importarArticulosScaner() )

      /*
      Detalle___________________________________________________________________________
      */

      oBrwLin                 := IXBrowse():New( oFld:aDialogs[1] )

      oBrwLin:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwLin:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }
      oBrwLin:bClrStd         := {|| { if( ( dbfTmpLin )->lKitChl, CLR_GRAY, CLR_BLACK ), GetSysColor( COLOR_WINDOW ) } }

      oBrwLin:cAlias          := dbfTmpLin

      oBrwLin:nMarqueeStyle   := 6
      oBrwLin:lFooter 		  := .t.
      oBrwLin:cName           := "Rectificativa.Detalle"

      oBrwLin:CreateFromResource( IDOK )

      with object ( oBrwLin:AddCol() )
         :cHeader             := "Oferta"
         :bStrData            := {|| "" }
         :bEditValue          := {|| ( dbfTmpLin )->lLinOfe }
         :nWidth              := 20
         :lHide               := .t.
         :SetCheck( { "gc_star2_16", "Nil16" } )
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader             := "Número"
         :bEditValue          := {|| ( dbfTmpLin )->nNumLin }
         :cEditPicture        := "9999"
         :nWidth              := 52
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
         :lHide 					:= .t.
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
         :nWidth              := 50
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
         :nWidth              := 254
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
         :cEditPicture        := cPicUnd
         :nWidth              := 60
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
         :lHide               := .t.
         :nFooterType         := AGGR_SUM
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader             := cNombreUnidades()
         :bEditValue          := {|| nTotNFacRec( dbfTmpLin ) }
         :cEditPicture        := cPicUnd
         :nWidth              := 60
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
         :nFooterType         := AGGR_SUM
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader             := "Unidad de medición"
         :bEditValue          := {|| ( dbfTmpLin )->cUnidad }
         :nWidth              := 100
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader             := "Alm."
         :bEditValue          := {|| ( dbfTmpLin )->cAlmLin }
         :nWidth              := 40
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader             := "Precio"
         :bEditValue          := {|| nTotUFacRec( dbfTmpLin, nDouDiv ) }
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
         :bEditValue          := {|| nDtoUFacRec( dbfTmpLin, nDouDiv ) }
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
         :cEditPicture        := "@E 999.9"
         :nWidth              := 40
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader             := "Portes"
         :bEditValue          := {|| nTrnUFacRec( dbfTmpLin, nDpvDiv ) }
         :cEditPicture        := cPpvDiv
         :nWidth              := 70
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
         :lHide               := .t.
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader             := "P. verde"
         :bEditValue          := {|| nPntUFacRec( dbfTmpLin, nDpvDiv ) }
         :cEditPicture        := cPpvDiv
         :nWidth              := 70
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
         :lHide               := .t.
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader             := "Total"
         :bEditValue          := {|| nTotLFacRec( dbfTmpLin, nDouDiv, nRouDiv, nil, .t., aTmp[ _LOPERPV ], .t. ) }
         :cEditPicture        := cPorDiv
         :nWidth              := 80
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
         :nFooterType         := AGGR_SUM
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader             := "Fecha"
         :bEditValue          := {|| Dtoc( ( dbfTmpLin )->dFecha ) }
         :nWidth              := 40
         :lHide               := .t.
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader          := "No imp."
         :bStrData         := {|| "" }
         :bEditValue       := {|| ( dbfTmpLin )->lImpLin }
         :nWidth           := 20
         :lHide            := .t.
         :SetCheck( { "Sel16", "Nil16" } )
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader          := "Centro de coste"
         :bEditValue       := {|| ( dbfTmpLin )->cCtrCoste }
         :nWidth           := 20
         :lHide            := .t.
      end with

      if nMode != ZOOM_MODE
         oBrwLin:bLDblClick  := {|| EdtDeta( oBrwLin, bEdtDet, aTmp ) }
      end if

     /*
     Descuentos________________________________________________________________
     */

     REDEFINE GET aGet[ _CDTOESP ] VAR aTmp[ _CDTOESP ] ;
         ID       299 ;
			COLOR 	CLR_GET ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

     REDEFINE GET aGet[ _NDTOESP ] VAR aTmp[ _NDTOESP ] ;
         ID       300 ;
         PICTURE  "@E 999.99" ;
			COLOR 	CLR_GET ;
         VALID    ( RecalculaTotal( aTmp ) );
         SPINNER;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

     REDEFINE GET aGet[ _CDPP ] VAR aTmp[ _CDPP ] ;
         ID       309 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

		REDEFINE GET aGet[ _NDPP ] VAR aTmp[ _NDPP ];
         ID       310 ;
         PICTURE  "@E 999.99" ;
			COLOR 	CLR_GET ;
         VALID    ( RecalculaTotal( aTmp ) );
         SPINNER;
         WHEN     ( nMode != ZOOM_MODE ) ;
			OF 		oFld:aDialogs[1]

     /*
     Descuentos definidos por el usuario_______________________________________
     */

		REDEFINE GET aGet[ _CDTOUNO ] VAR aTmp[ _CDTOUNO ] ;
         ID       320 ;
			PICTURE 	"@!" ;
			COLOR 	CLR_GET ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

		REDEFINE GET aGet[ _NDTOUNO ] VAR aTmp[ _NDTOUNO ];
         ID       330 ;
         PICTURE  "@E 999.99" ;
			COLOR 	CLR_GET ;
         VALID    ( RecalculaTotal( aTmp ) ) ;
         SPINNER;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

		REDEFINE GET aGet[ _CDTODOS ] VAR aTmp[ _CDTODOS ] ;
         ID       340 ;
			PICTURE 	"@!" ;
			COLOR 	CLR_GET ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

		REDEFINE GET aGet[ _NDTODOS ] VAR aTmp[ _NDTODOS ];
         ID       350 ;
         PICTURE  "@E 999.99" ;
			COLOR 	CLR_GET ;
         VALID    ( RecalculaTotal( aTmp ) ) ;
         SPINNER;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CMANOBR ] VAR aTmp[ _CMANOBR ] ;
         ID       411 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _NIVAMAN ] VAR aTmp[ _NIVAMAN ] ;
         ID       412 ;
         PICTURE  "@E 99.9" ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( lTiva( dbfIva, aTmp[ _NIVAMAN ] ) .and. RecalculaTotal( aTmp ) );
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
			OF 		oFld:aDialogs[1]

		/*
      Cajas Bases de los impuestosS____________________________________________________________
		*/

      oBrwIva                        := IXBrowse():New( oFld:aDialogs[1] )

      oBrwIva:bClrSel                := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwIva:bClrSelFocus           := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrwIva:SetArray( aTotIva, , , .f. )

      oBrwIva:nMarqueeStyle          := 6
      oBrwIva:lRecordSelector        := .f.
      oBrwIva:lHScroll               := .f.

      oBrwIva:CreateFromResource( 370 )

      with object ( oBrwIva:AddCol() )
         :cHeader          := "Base"
         :bStrData      := {|| if( aTotIva[ oBrwIva:nArrayAt, 3 ] != nil, Trans( aTotIva[ oBrwIva:nArrayAt, 2 ], cPorDiv ), "" ) }
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
         :bStrData         := {|| if( aTotIva[ oBrwIva:nArrayAt, 3 ] != nil .and. aTmp[ _LRECARGO ], Trans( aTotIva[ oBrwIva:nArrayAt, 4 ], "@E 999.99"), "" ) }
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
		Totales de facturas
		------------------------------------------------------------------------
		*/

      REDEFINE SAY oGetNet VAR nTotNet ;
         ID       401 ;
			OF 		oFld:aDialogs[1]

      REDEFINE SAY oGetTrn VAR nTotTrn ;
         ID       402 ;
         OF       oFld:aDialogs[1]

      REDEFINE SAY oGetIva VAR nTotIva ;
         ID       405 ;
			OF 		oFld:aDialogs[1]

      REDEFINE CHECKBOX aGet[ _LRECARGO ] VAR aTmp[ _LRECARGO ] ;
         ID       406 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ON CHANGE( RecalculaTotal( aTmp ) );
			OF 		oFld:aDialogs[1]

      REDEFINE SAY oGetReq VAR nTotReq ;
         ID       407 ;
			OF 		oFld:aDialogs[1]

      REDEFINE CHECKBOX oImpuestos VAR lImpuestos ;
         ID       709 ;
         WHEN     ( .t. ) ;
         OF       oFld:aDialogs[1]

      REDEFINE SAY oGetTotal VAR nTotFac ;
         ID       485 ;
			FONT 		oFont ;
			OF 		oFld:aDialogs[1]

      REDEFINE CHECKBOX aGet[ _LOPERPV ] VAR aTmp[ _LOPERPV ] ;
         ID       409 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ON CHANGE( RecalculaTotal( aTmp ), oBrwLin:Refresh() );
			OF 		oFld:aDialogs[1]

      REDEFINE SAY oGetTotPnt VAR nTotPnt;
         ID       404 ;
			OF 		oFld:aDialogs[1]

      REDEFINE SAY oGetTotIvm VAR nTotIvm;
         ID       403 ;
			OF 		oFld:aDialogs[1]

      REDEFINE SAY oGetMasDiv VAR cGetMasDiv;
         ID       488 ;
			FONT 		oFont ;
			OF 		oFld:aDialogs[1]

      REDEFINE GET aGet[ _CSERIE ] VAR aTmp[ _CSERIE ] ;
         ID       100 ;
         PICTURE  "@!" ;
         SPINNER ;
         ON UP    ( UpSerie( aGet[ _CSERIE ] ) );
         ON DOWN  ( DwSerie( aGet[ _CSERIE ] ) );
         COLOR    CLR_GET ;
         WHEN     ( nMode == APPD_MODE .OR. nMode == DUPL_MODE );
         VALID    ( aTmp[_CSERIE] >= "A" .AND. aTmp[_CSERIE] <= "Z" ) ;
         OF       oFld:aDialogs[1]

         aGet[ _CSERIE ]:bLostFocus := {|| aGet[ _CCODPRO ]:cText( cProCnt( aTmp[ _CSERIE ] ) ) }

		REDEFINE GET aGet[ _NNUMFAC] VAR aTmp[_NNUMFAC] ;
			ID 		110 ;
			PICTURE 	"999999999" ;
         WHEN     .f. ;
			OF 		oFld:aDialogs[1]

		REDEFINE GET aGet[ _CSUFFAC] VAR aTmp[_CSUFFAC] ;
			ID       120 ;
			PICTURE  "@!" ;
         WHEN     .f. ;
			OF 		oFld:aDialogs[1]

      REDEFINE GET aGet[ _DFECFAC ] VAR aTmp[ _DFECFAC ] ;
			ID 		130 ;
			SPINNER ;
         ON HELP  aGet[ _DFECFAC ]:cText( Calendario( aTmp[ _DFECFAC ] ) ) ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			OF 		oFld:aDialogs[1]

	  	REDEFINE GET aGet[ _TFECFAC ] VAR aTmp[ _TFECFAC ] ;
         ID       131 ;
         PICTURE  "@R 99:99:99" ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( iif(   !validTime( aTmp[ _TFECFAC ] ),;
                        ( msgStop( "El formato de la hora no es correcto" ), .f. ),;
                        .t. ) );
         OF       oFld:aDialogs[1]

   	REDEFINE GET aGet[ _CNUMFAC ] VAR aTmp[ _CNUMFAC ] ;
			ID 		150 ;
         WHEN     ( nMode == APPD_MODE .or. nMode == DUPL_MODE ) ;
         BITMAP   "LUPA" ;
         VALID    ( cFacCli( aGet, aTmp, oBrwLin, oBrwIva, nMode ), RecalculaTotal( aTmp ) ) ;
         ON HELP  ( browseFacturasClientes( aGet[ _CNUMFAC ], aGet[ _LIVAINC ], nView ) );
         OF       oFld:aDialogs[ 1 ]

      /*
      Causas y motivos de las facturas rectificativas--------------------------
      */

      REDEFINE COMBOBOX aGet[ _CMOTREC ] VAR aTmp[ _CMOTREC ] ;
      	ITEMS    RECTIFICATIVA_ITEMS ;
      	ID       100 ;
      	WHEN     ( nMode != ZOOM_MODE ) ;
      	OF       oFld:aDialogs[ 2 ]

      REDEFINE GET aGet[ _CCAUREC ] VAR aTmp[ _CCAUREC ] ;
      	ID       110 ;
      	SPINNER ;
      	WHEN     ( nMode != ZOOM_MODE ) ;
      	OF       oFld:aDialogs[ 2 ]

      /*
      Transportistas-----------------------------------------------------------
      */

      	REDEFINE GET aGet[ _CCODDLG ] VAR aTmp[ _CCODDLG ] ;
         	ID       300 ;
         	WHEN     ( .f. ) ;
         	OF       oFld:aDialogs[2]

      	REDEFINE GET oSay[ 12 ] VAR cSay[ 12 ] ;
         	ID       301 ;
         	WHEN     ( .f. ) ;
         	OF       oFld:aDialogs[2]

     	REDEFINE GET aGet[ _CCODTRN ] VAR aTmp[ _CCODTRN ] ;
         	ID       235 ;
			COLOR 	CLR_GET ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         	VALID    ( LoadTrans( aTmp, aGet[ _CCODTRN ], aGet[ _NKGSTRN ], oSay[ 9 ] ) );
         	BITMAP   "LUPA" ;
         	ON HELP  ( oTrans:Buscar( aGet[ _CCODTRN ] ), .t. );
         	OF       oFld:aDialogs[2]

      	REDEFINE GET oSay[ 9 ] VAR cSay[ 9 ] ;
         	ID       236 ;
			WHEN 		.F. ;
			COLOR 	CLR_GET ;
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
			WHEN 		( nMode != ZOOM_MODE ) ;
         	VALID    cCajas( aGet[ _CCODCAJ ], dbfCajT, oSay[ 10 ] ) ;
         	ID       165 ;
			COLOR 	CLR_GET ;
         	BITMAP   "LUPA" ;
         	ON HELP  ( BrwCajas( aGet[ _CCODCAJ ], oSay[ 10 ] ) ) ;
         	OF       oFld:aDialogs[2]

      	REDEFINE GET oSay[ 10 ] VAR cSay[ 10 ] ;
         	ID       166 ;
         	WHEN     .f. ;
			COLOR 	CLR_GET ;
         	OF       oFld:aDialogs[2]

      	REDEFINE GET aGet[ _CCODPRO] VAR aTmp[_CCODPRO] ;
         	ID       170 ;
         	PICTURE  "@R ###.######" ;
         	COLOR    CLR_GET ;
         	WHEN     ( nLenCuentaContaplus() != 0 .AND. nMode != ZOOM_MODE ) ;
         	VALID    ( ChkProyecto( aTmp[_CCODPRO], oSay[ 6 ] ), .t. );
         	BITMAP   "LUPA" ;
         	ON HELP  ( BrwProyecto( aGet[ _CCODPRO], oSay[ 6 ] ) );
         	OF       oFld:aDialogs[2]

	    REDEFINE GET oSay[ 6 ] VAR cSay[ 6 ] ;
	        ID       180 ;
	        WHEN     .F.;
	        OF       oFld:aDialogs[2]

        REDEFINE GET aGet[ _CCENTROCOSTE ] VAR aTmp[ _CCENTROCOSTE ] ;
         	ID       190 ;
         	IDTEXT   191 ;
         	BITMAP   "LUPA" ;
         	VALID    ( oCentroCoste:Existe( aGet[ _CCENTROCOSTE ], aGet[ _CCENTROCOSTE ]:oHelpText, "cNombre" ) );
         	ON HELP  ( oCentroCoste:Buscar( aGet[ _CCENTROCOSTE ] ) ) ;
         	WHEN     ( nMode != ZOOM_MODE ) ;
         	OF       oFld:aDialogs[2]

      	REDEFINE GET aGet[ _NBULTOS ] VAR aTmp[ _NBULTOS ];
         	ID       128 ;
			SPINNER;
         	PICTURE  "99999" ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         	OF       oFld:aDialogs[2]

      	REDEFINE GET aGet[ _CSUFAC ] VAR aTmp[ _CSUFAC ] ;
         	ID       181 ;
			COLOR 	CLR_GET ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			PICTURE	"@!" ;
         	OF       oFld:aDialogs[2]

      /*
      Retirado por________________________________________________________________
      */

      REDEFINE GET aGet[ _DFECENT ] VAR aTmp[ _DFECENT ];
         ID       162 ;
         COLOR    CLR_GET ;
         SPINNER;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ON HELP  aGet[ _DFECENT]:cText( Calendario( aTmp[_DFECENT] ) ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ _CRETPOR] VAR aTmp[_CRETPOR] ;
         ID       160 ;
         COLOR    CLR_GET ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ _CRETMAT] VAR aTmp[_CRETMAT] ;
         ID       161 ;
         COLOR    CLR_GET ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ _CCONDENT] VAR aTmp[_CCONDENT] ;
         ID       230 ;
         COLOR    CLR_GET ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[2]

      /*Impresión ( informa de si está imprimido o no y de cuando se imprimió )*/

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

      REDEFINE GET aGet[ _MCOMENT] VAR aTmp[_MCOMENT];
         MEMO ;
         ID       240 ;
         COLOR    CLR_GET ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[2]

      /*
      impuestos----------------------------------------------------------------------
      */

      REDEFINE RADIO aGet[ _NREGIVA ] ;
         VAR      aTmp[ _NREGIVA ] ;
         ID       410,;
                  411,;
                  412,;
                  413 ;
         ON CHANGE( lChangeRegIva( aTmp ) );
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
      oBrwPgo:cName           := "Factura rectificativa.Pagos"

      oBrwPgo:nMarqueeStyle   := 6

      oBrwPgo:CreateFromResource( 260 )

      with object ( oBrwPgo:AddCol() )
         :cHeader             := "Cr. Sesión cerrada"
         :bStrData            := {|| "" }
         :bEditValue          := {|| ( dbfTmpPgo )->lCloPgo }
         :nWidth              := 20
         :lHide               := .t.
         :SetCheck( { "Sel16", "Nil16" } )
      end with

      with object ( oBrwPgo:AddCol() )
         :cHeader             := "Co. Cobrado"
         :bStrData            := {|| "" }
         :bBmpData            := {|| nEstadoRecibo( dbfTmpPgo ) }
         :nWidth              := 20
         :AddResource( "Cnt16" )
         :AddResource( "Sel16" )
         :AddResource( "gc_undo_16" )
      end with

      with object ( oBrwPgo:AddCol() )
         :cHeader             := "Contabilizado"
         :bStrData            := {|| "" }
         :bEditValue          := {|| ( dbfTmpPgo )->lConPgo }
         :nWidth              := 70
         :SetCheck( { "Sel16", "Nil16" } )
      end with

      with object ( oBrwPgo:AddCol() )
         :cHeader             := "Sesión"
         :bEditValue          := {|| Rtrim( ( dbfTmpPgo )->cTurRec ) }
         :nWidth              := 40
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
      end with

      with object ( oBrwPgo:AddCol() )
         :cHeader             := "Expedido"
         :bEditValue          := {|| DtoC( ( dbfTmpPgo )->dPreCob ) }
         :nWidth              := 76
      end with

      with object ( oBrwPgo:AddCol() )
         :cHeader             := "Cobro"
         :bEditValue          := {|| DtoC( ( dbfTmpPgo )->dEntrada ) }
         :nWidth              := 76
      end with

      with object ( oBrwPgo:AddCol() )
         :cHeader             := "Descripción"
         :bEditValue          := {|| ( dbfTmpPgo )->cDescrip }
         :nWidth              := 190
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
         :nWidth              := 70
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
      end with

      if nMode == EDIT_MODE
         oBrwPgo:bLDblClick   := {|| ExtEdtRecCli( dbfTmpPgo, nView, .t., oCtaRem, oCentroCoste ), oBrwPgo:Refresh(), RecalculaTotal( aTmp ) }
      end if

      REDEFINE BUTTON ;
         ID       501 ;
         OF       oFld:aDialogs[2];
         WHEN     ( nMode == EDIT_MODE ) ;
         ACTION   ( ExtEdtRecCli( dbfTmpPgo, nView, .t., oCtaRem, oCentroCoste ), oBrwPgo:Refresh(), RecalculaTotal( aTmp ) )

      REDEFINE BUTTON ;
         ID       502 ;
         OF       oFld:aDialogs[2];
         WHEN     ( nMode == EDIT_MODE ) ;
         ACTION   ( ExtDelRecCli( dbfTmpPgo ), oBrwPgo:Refresh(), RecalculaTotal( aTmp ) )

      REDEFINE BUTTON ;
         ID       506 ;
         OF       oFld:aDialogs[2];
         WHEN     ( nMode == EDIT_MODE ) ;
         ACTION   ( VisRecCli( ( dbfTmpPgo )->cSerie + Str( ( dbfTmpPgo )->nNumFac ) + ( dbfTmpPgo )->cSufFac + Str( ( dbfTmpPgo )->nNumRec ) + ( dbfTmpPgo )->cTipRec, .f. ) )

      REDEFINE BUTTON ;
         ID       505 ;
         OF       oFld:aDialogs[2];
         WHEN     ( nMode == EDIT_MODE ) ;
         ACTION   ( PrnRecCli( ( dbfTmpPgo )->cSerie + Str( ( dbfTmpPgo )->nNumFac ) + ( dbfTmpPgo )->cSufFac + Str( ( dbfTmpPgo )->nNumRec ) + ( dbfTmpPgo )->cTipRec, .f. ) )

      REDEFINE SAY oSayGetRnt ;
         ID       800 ;
         OF       oFld:aDialogs[1]

      REDEFINE GET oGetRnt VAR nTotRnt;
         ID       408 ;
         OF       oFld:aDialogs[1]

      /*
      Pagado y pendiente en facturas
      ------------------------------------------------------------------------
      */

      REDEFINE SAY oGetTotPg VAR nTotFac ;
         ID       455 ;
         OF       oFld:aDialogs[2]

      REDEFINE SAY oGetPag VAR 0 ;
         ID       460 ;
         OF       oFld:aDialogs[2]

      REDEFINE SAY oGetPdt VAR 0 ;
         ID       480 ;
         OF       oFld:aDialogs[2]

      REDEFINE GET oGetPes VAR nTotPes ;
         WHEN     ( .f. ) ;
         PICTURE  ( MasUnd() ) ;
         ID       570 ;
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
      oBrwInc:cName           := "Factura rectificativa.Incidencia"

         with object ( oBrwInc:AddCol() )
            :cHeader          := "Resuelta"
            :bStrData         := {|| "" }
            :bEditValue       := {|| ( dbfTmpInc )->lListo }
            :nWidth           := 64
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
            :nWidth           := 450
         end with

         if nMode != ZOOM_MODE
            oBrwInc:bLDblClick   := {|| WinEdtRec( oBrwInc, bEdtInc, dbfTmpInc, nil, nil, aTmp ) }
         else
            oBrwInc:bLDblClick   := {|| WinZooRec( oBrwInc, bEdtInc, dbfTmpInc ) }
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


      // Caja de documentos----------------------------------------------------

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
         :nWidth           := 900
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
         ACTION   ( ShellExecute( oDlg:hWnd, "open", Rtrim( ( dbfTmpDoc )->cRuta ) ) )


         /*
      Situaciones--------------------------------------------------------------
      */

      oBrwEst                 := IXBrowse():New( oFld:aDialogs[ 5 ] )

      oBrwEst:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwEst:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrwEst:cAlias          := dbfTmpEst

      oBrwEst:nMarqueeStyle   := 6
      oBrwEst:cName           := "Factura rectificativa de cliente.Situaciones"

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
		ID 		 502 ;
        OF       oFld:aDialogs[ 5 ] ;
        WHEN     ( nMode != ZOOM_MODE ) ;
        ACTION   ( WinDelRec( oBrwEst, dbfTmpEst ) )


	REDEFINE BUTTON ;
		ID 		 503 ;
        OF       oFld:aDialogs[ 5 ] ;
        ACTION   ( WinZooRec( oBrwEst, bEdtEst, dbfTmpEst, nil, nil, aTmp ) )



      /*
		Fin de los Folders
		-----------------------------------------------------------------------
		*/

      REDEFINE BUTTON ;
         ID       3 ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( RecFacRec( aTmp ), oBrwLin:Refresh(), RecalculaTotal( aTmp ) )

      REDEFINE BUTTON ;
         ID       4 ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( if( EndTrans( aTmp, aGet, oBrw, oBrwLin, oBrwPgo, aNumAlb, nMode, oDlg, oFld ), GenFacRec( IS_PRINTER ), ) )

		REDEFINE BUTTON ;
         ID       IDOK ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( EndTrans( aTmp, aGet, oBrw, oBrwLin, oBrwPgo, aNumAlb, nMode, oDlg, oFld ) )

      REDEFINE BUTTON ;
         ID       IDCANCEL ;
         OF       oDlg ;
         CANCEL ;
         ACTION   ( If( ExitNoSave( nMode, dbfTmpLin ), oDlg:end(), ) )

      REDEFINE GROUP oSayLabels[ 1 ] ID 700 OF oFld:aDialogs[ 1 ] TRANSPARENT
      REDEFINE SAY   oSayLabels[ 2 ] ID 703 OF oFld:aDialogs[ 1 ]
      REDEFINE SAY   oSayLabels[ 3 ] ID 704 OF oFld:aDialogs[ 1 ]
      REDEFINE SAY   oSayLabels[ 4 ] ID 705 OF oFld:aDialogs[ 1 ]
      REDEFINE SAY   oSayLabels[ 5 ] ID 706 OF oFld:aDialogs[ 1 ]
      REDEFINE SAY   oSayLabels[ 6 ] ID 708 OF oFld:aDialogs[ 1 ]
      REDEFINE SAY   oSayLabels[ 8 ] ID 710 OF oFld:aDialogs[ 1 ]
      REDEFINE SAY   oSayLabels[ 9 ] ID 712 OF oFld:aDialogs[ 1 ]

      /*
      Bitmap________________________________________________________________
      */

      REDEFINE BITMAP oBmpEmp;
         FILE     "Bmp\ImgFacRec.bmp" ;
         ID       500 ;
         OF       oDlg ;

   /*
   Apertura de la caja de Dialogo
   ----------------------------------------------------------------------------
	*/

   if nMode != ZOOM_MODE

      oFld:aDialogs[1]:AddFastKey( VK_F2, {|| AppDeta( oBrwLin, bEdtDet, aTmp, .f. ) } )
      oFld:aDialogs[1]:AddFastKey( VK_F3, {|| EdtDeta( oBrwLin, bEdtDet, aTmp, .f., nMode ) } )
      oFld:aDialogs[1]:AddFastKey( VK_F4, {|| WinDelRec( oBrwLin, dbfTmpLin, {|| DelDeta() }, {|| RecalculaTotal( aTmp ) } ) } )

      oFld:aDialogs[2]:AddFastKey( VK_F3, {|| ExtEdtRecCli( dbfTmpPgo, nView, .t., oCtaRem, oCentroCoste ), RecalculaTotal( aTmp ) } )
      oFld:aDialogs[2]:AddFastKey( VK_F4, {|| ExtDelRecCli( dbfTmpPgo ), RecalculaTotal( aTmp ) } )

      oFld:aDialogs[3]:AddFastKey( VK_F2, {|| WinAppRec( oBrwInc, bEdtInc, dbfTmpInc, nil, nil, aTmp ) } )
      oFld:aDialogs[3]:AddFastKey( VK_F3, {|| WinEdtRec( oBrwInc, bEdtInc, dbfTmpInc, nil, nil, aTmp ) } )
      oFld:aDialogs[3]:AddFastKey( VK_F4, {|| WinDelRec( oBrwInc, dbfTmpInc ) } )

      oFld:aDialogs[4]:AddFastKey( VK_F2, {|| WinAppRec( oBrwDoc, bEdtDoc, dbfTmpDoc, nil, nil, aTmp ) } )
      oFld:aDialogs[4]:AddFastKey( VK_F3, {|| WinEdtRec( oBrwDoc, bEdtDoc, dbfTmpDoc, nil, nil, aTmp ) } )
      oFld:aDialogs[4]:AddFastKey( VK_F4, {|| WinDelRec( oBrwDoc, dbfTmpDoc ) } )

      oDlg:AddFastKey( 65,                {|| if( GetKeyState( VK_CONTROL ), CreateInfoArticulo(), ) } )
      oDlg:AddFastKey( VK_F5,             {|| EndTrans( aTmp, aGet, oBrw, oBrwLin, oBrwPgo, aNumAlb, nMode, oDlg, oFld ) } )
      oDlg:AddFastKey( VK_F6,             {|| if( EndTrans( aTmp, aGet, oBrw, oBrwLin, oBrwPgo, aNumAlb, nMode, oDlg, oFld ), GenFacRec( IS_PRINTER ), ) } )
      oDlg:AddFastKey( VK_F9,             {|| oDetCamposExtra:Play( space(1) ) } )

   end if

   oDlg:AddFastKey( VK_F1, {|| ChmHelp( "Facturas_rectificativa" ) } )

   do case
      case nMode == APPD_MODE .and. lRecogerUsuario() .and. empty( cCodArt )
         oDlg:bStart := {|| if( lGetUsuario( aGet[ _CCODUSR ], dbfUsr ), , oDlg:End() ) }

      case nMode == APPD_MODE .and. lRecogerUsuario() .and. !empty( cCodArt )
         oDlg:bStart := {|| if( lGetUsuario( aGet[ _CCODUSR ], dbfUsr ), AppDeta( oBrwLin, bEdtDet, aTmp, .f., cCodArt ), oDlg:End() ) }

      case nMode == APPD_MODE .and. !lRecogerUsuario() .and. !empty( cCodArt )
         oDlg:bStart := {|| AppDeta( oBrwLin, bEdtDet, aTmp, .f., cCodArt ) }

      otherwise
         oDlg:bStart := {|| StartEdtRec( aGet, nMode ),;
         					ShowKit( D():FacturasRectificativas( nView ), dbfTmpLin, oBrwLin, .f., dbfTmpInc, aTmp[ _CCODCLI ], D():Clientes( nView ), nil, aGet, oSayGetRnt ) }
   end case

   ACTIVATE DIALOG oDlg ;
         ON INIT 	 (   initEdtRec( cCodCli, aGet, aTmp, oDlg, oBrwLin, oBrwPgo, oBrwInc, oSayGetRnt, oGetRnt ) );
         ON PAINT    (  RecalculaTotal( aTmp ) );
         CENTER

   EndEdtRecMenu()

   oFont:end()

   oBmpEmp:end()

   oBmpDiv:end()

   oBmpGeneral:End()

   /*
   Repos-----------------------------------------------------------------------
   */

   ( D():FacturasRectificativas( nView ) )->( ordSetFocus( nOrd ) )

   oBrwLin:CloseData()

   /*
   Salida sin grabar
   */

   KillTrans( oBrwLin, oBrwInc, oBrwPgo )

RETURN ( oDlg:nResult == IDOK )

//----------------------------------------------------------------------------//

Static Function StartEdtRec( aGet, nMode )

   if nMode != APPD_MODE

    	if !empty( aGet[ _CCENTROCOSTE ] )
    		aGet[ _CCENTROCOSTE ]:lValid()
    	endif 

   end if 

Return ( nil )

//----------------------------------------------------------------------------//

Static Function initEdtRec( cCodCli, aGet, aTmp, oDlg, oBrwLin, oBrwPgo, oBrwInc, oSayGetRnt, oGetRnt )

   if !empty( cCodCli )
      aGet[ _CCODCLI ]:lValid()
   endif

   EdtRecMenu( aTmp, oDlg )
   SetDialog( oSayGetRnt, oGetRnt )
   
   oBrwLin:MakeTotals()

   oBrwLin:Load()
   oBrwPgo:Load()
   oBrwInc:Load()

return( .t. )

//----------------------------------------------------------------------------//

STATIC FUNCTION SetDialog( oSayGetRnt, oGetRnt )

   if !lAccArticulo() .or. SQLAjustableModel():getRolNoMostrarRentabilidad( Auth():rolUuid() )

      if !empty( oSayGetRnt )
         oSayGetRnt:Hide()
      end if

      if !empty( oGetRnt )
         oGetRnt:Hide()
      end if

   end if

Return .t.

//----------------------------------------------------------------------------//

/*
Edita las lineas de Detalle
*/

STATIC FUNCTION EdtDet( aTmp, aGet, dbfFacRecL, oBrw, lTotLin, cCodArtEnt, nMode, aTmpFac )

	local oDlg
   local oFld
   local oBtn
   local oSayPr1
   local oSayPr2
   local cSayPr1  := ""
   local cSayPr2  := ""
   local oSayVp1
   local oSayVp2
   local cSayVp1  := ""
   local cSayVp2  := ""
   local oSayAlm
   local cSayAlm  := ""
   local bmpImage
   local oStkAct
   local nStkAct  := 0
   local oBtnSer
   local oSayGrp
   local cSayGrp  := ""
   local oSayFam
   local cSayFam  := ""
   local cCodArt  := Padr( aTmp[ _CREF ], 32 )

   cTipoCtrCoste  := alltrim( aTmp[ _CTIPCTR ] )

   do case
   case nMode == APPD_MODE
      aTmp[ _NCANENT  ] := 1
      aTmp[ _DFECHA   ] := GetSysDate()
      aTmp[ _dCSERIE  ] := aTmpFac[ _CSERIE  ]
      aTmp[ _dNNUMFAC ] := aTmpFac[ _NNUMFAC ]
      aTmp[ _LTOTLIN  ] := lTotLin
      aTmp[ _CALMLIN  ] := aTmpFac[ _CCODALM ]
      aTmp[ _LIVALIN  ] := aTmpFac[ _LIVAINC ]
      aTmp[ _NTARLIN  ] := oGetTarifa:getTarifa()
      aTmp[ __DFECFAC ] := aTmpFac[ _DFECFAC ]
      aTmp[ __TFECFAC ] := aTmpFac[ _TFECFAC ]
      if !empty( cCodArtEnt )
         cCodArt        := Padr( cCodArtEnt, 32 )
      end if

      aTmp[ _COBRLIN ]  := aTmpFac[ _CCODOBR ]

      cTipoCtrCoste     := "Centro de coste"

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

   cOldCodArt           := aTmp[ _CREF ]
   cOldPrpArt           := aTmp[ _CCODPR1 ] + aTmp[ _CCODPR2 ] + aTmp[ _CVALPR1 ] + aTmp[ _CVALPR2 ]
   cOldUndMed           := aTmp[ _CUNIDAD ]

   /*Etiquetas de familias y grupos de familias*/

   if nMode != APPD_MODE
      cSayGrp           := RetFld( aTmp[ _CGRPFAM  ], oGrpFam:GetAlias() )
      cSayFam           := RetFld( aTmp[ _CCODFAM ], dbfFamilia )
   end if

   /*
   Caja de dialogo-------------------------------------------------------------
   */

   DEFINE DIALOG oDlg RESOURCE "LFacCli" TITLE LblTitle( nMode ) + "lineas de facturas rectificativas de clientes"

      REDEFINE FOLDER oFld ID 400 OF oDlg ;
         PROMPT   "&General",    "Da&tos",    "&Observaciones", "&Centro coste" ;
         DIALOGS  "LFacCli_1",   "LFacCli_7", "LFacCli_3"     , "LCTRCOSTE"

      REDEFINE GET aGet[ _CREF] VAR cCodArt;
         ID       100 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( loaArt( cCodArt, aGet, aTmp, aTmpFac, oStkAct, oSayPr1, oSayPr2, oSayVp1, oSayVp2, bmpImage, nMode ) );
         BITMAP   "LUPA" ;
         ON HELP  ( BrwArticulo( aGet[ _CREF ], aGet[ _CDETALLE ] , , , , aGet[ _CLOTE ], aTmp[ _CCODPR1 ], aTmp[ _CCODPR2 ], aGet[ _CVALPR1 ], aGet[ _CVALPR2 ], aGet[ _DFECCAD ], if( uFieldEmpresa( "lStockAlm" ), aTmp[ _CALMLIN ], nil ) ) );
         OF       oFld:aDialogs[1]

		REDEFINE GET aGet[ _CDETALLE ] VAR aTmp[_CDETALLE] ;
         ID 		110 ;
         WHEN     ( ( lModDes() .or. empty( aTmp[ _CDETALLE ] ) ) .AND. nMode != ZOOM_MODE .AND. nMode != MULT_MODE ) ;
			COLOR 	CLR_GET ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _MLNGDES] VAR aTmp[_MLNGDES] ;
			MEMO ;
			ID 		111 ;
         WHEN     ( ( lModDes() .or. empty( aTmp[ _MLNGDES ] ) ) .AND. nMode != ZOOM_MODE .AND. nMode != MULT_MODE ) ;
			COLOR 	CLR_GET ;
         OF       oFld:aDialogs[1]

      /*
      Lotes
      -------------------------------------------------------------------------
      */

      REDEFINE GET aGet[ _CLOTE ] VAR aTmp[ _CLOTE ];
         ID       112 ;
         IDSAY    113 ;
         SPINNER ;
         PICTURE  "999999999" ;
         WHEN     ( nMode != ZOOM_MODE ) ;
			OF 		oFld:aDialogs[1]

      aGet[ _CLOTE ]:bValid   := {|| lValidLote( aTmp, aGet, oStkAct ) }

      REDEFINE GET aGet[ _DFECCAD ] VAR aTmp[ _DFECCAD ];
         ID       340 ;
         IDSAY    341 ;
			SPINNER ;
			WHEN 		( nMode != ZOOM_MODE ) ;
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
         BITMAP   "LUPA" ;
         WHEN     ( nMode != ZOOM_MODE .and. nMode != MULT_MODE ) ;
         VALID    ( if( lPrpAct( aTmp[ _CVALPR1 ], oSayVp1, aTmp[ _CCODPR1 ], D():PropiedadesLineas( nView ) ),;
                        loaArt( cCodArt, aGet, aTmp, aTmpFac, oStkAct, oSayPr1, oSayPr2, oSayVp1, oSayVp2, bmpImage, nMode, .f. ),;
                        .f. ) );
         ON HELP  ( brwPropiedadActual( aGet[ _CVALPR1 ], oSayVp1, aTmp[ _CCODPR1 ] ) ) ;
         OF       oFld:aDialogs[1]

         aGet[ _CVALPR1 ]:bChange            := {|| aGet[ _CVALPR1 ]:Assign(), if( !uFieldEmpresa( "lNStkAct" ), oStock:nPutStockActual( aTmp[ _CREF ], aTmp[ _CALMLIN ], aTmp[ _CVALPR1 ], aTmp[ _CVALPR2 ], aTmp[ _CLOTE ], aTmp[ _LKITART ], aTmp[ _NCTLSTK ], oStkAct ), ) }

      REDEFINE SAY oSayPr1 VAR cSayPr1;
         ID       271 ;
         OF       oFld:aDialogs[1]

      REDEFINE GET oSayVp1 VAR cSayVp1;
         ID       272 ;
         WHEN     .f. ;
         COLOR    CLR_GET ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CVALPR2 ] ;
         VAR      aTmp[ _CVALPR2 ];
         ID       280 ;
         BITMAP   "LUPA" ;
         WHEN     ( nMode != ZOOM_MODE .AND. nMode != MULT_MODE ) ;
         VALID    ( if( lPrpAct( aTmp[ _CVALPR2 ], oSayVp2, aTmp[ _CCODPR2 ], D():PropiedadesLineas( nView ) ),;
                        loaArt( cCodArt, aGet, aTmp, aTmpFac, oStkAct, oSayPr1, oSayPr2, oSayVp1, oSayVp2, bmpImage, nMode, .f. ),;
                        .f. ) );
         ON HELP  ( brwPropiedadActual( aGet[ _CVALPR2 ], oSayVp2, aTmp[ _CCODPR2 ] ) ) ;
         OF       oFld:aDialogs[1]

         aGet[ _CVALPR2 ]:bChange   := {|| aGet[ _CVALPR2 ]:Assign(), if( !uFieldEmpresa( "lNStkAct" ), oStock:nPutStockActual( aTmp[ _CREF ], aTmp[ _CALMLIN ], aTmp[ _CVALPR1 ], aTmp[ _CVALPR2 ], aTmp[ _CLOTE ], aTmp[ _LKITART ], aTmp[ _NCTLSTK ], oStkAct ), ) }

      REDEFINE SAY oSayPr2 VAR cSayPr2;
         ID       281 ;
         OF       oFld:aDialogs[1]

      REDEFINE GET oSayVp2 VAR cSayVp2;
         ID       282 ;
         WHEN     .f. ;
         OF       oFld:aDialogs[1]

      // fin de propiedades----------------------------------------------------

      REDEFINE GET aGet[ _NIMPTRN ] VAR aTmp[ _NIMPTRN ] ;
         ID       350 ;
         IDSAY    351 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE .AND. !lTotLin ) ;
         ON CHANGE( lCalcDeta( aTmp, aTmpFac ) );
         VALID    ( lCalcDeta( aTmp, aTmpFac ) );
         PICTURE  cPouDiv ;
         OF       oFld:aDialogs[1]


      REDEFINE GET aGet[ _NIVA ] VAR aTmp[ _NIVA ] ;
			ID 		120 ;
         WHEN     ( lModIva() .AND. nMode != ZOOM_MODE ) ;
         PICTURE  "@E 99.99" ;
         VALID    ( lTiva( dbfIva, aTmp[ _NIVA ], @aTmp[ _NREQ ] ) );
         ON CHANGE( lCalcDeta( aTmp, aTmpFac ) );
         BITMAP   "LUPA" ;
         ON HELP  ( BrwIva( aGet[ _NIVA ], dbfIva, , .t. ) );
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _NVALIMP ] VAR aTmp[ _NVALIMP ] ;
         ID       125 ;
         IDSAY    126 ;
         SPINNER ;
         WHEN     ( uFieldEmpresa( "lModImp" ) .AND. nMode != ZOOM_MODE ) ;
         PICTURE  cPouDiv ;
         ON CHANGE( lCalcDeta( aTmp, aTmpFac ) );
         ON HELP  ( oNewImp:nBrwImp( aGet[ _NVALIMP ] ) );
         OF       oFld:aDialogs[1]

      /*
      Bultos, cajas y unidades
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

		REDEFINE GET aGet[ _NCANENT] VAR aTmp[_NCANENT] ;
			ID 		130 ;
			SPINNER ;
         WHEN     ( nMode != ZOOM_MODE .AND. lUseCaj() .AND. !lTotLin .AND. nMode != MULT_MODE ) ;
         ON CHANGE( lCalcDeta( aTmp, aTmpFac ), loaArt( cCodArt, aGet, aTmp, aTmpFac, oStkAct, oSayPr1, oSayPr2, oSayVp1, oSayVp2, bmpImage, nMode, .f. ) );
         VALID    ( lCalcDeta( aTmp, aTmpFac ), loaArt( cCodArt, aGet, aTmp, aTmpFac, oStkAct, oSayPr1, oSayPr2, oSayVp1, oSayVp2, bmpImage, nMode, .f. ) );
			PICTURE 	cPicUnd ;
         OF       oFld:aDialogs[1] ;
         IDSAY    131

		REDEFINE GET aGet[ _NUNICAJA] VAR aTmp[_NUNICAJA] ;
			ID 		140 ;
			SPINNER ;
         WHEN     ( nMode != ZOOM_MODE .AND. !lTotLin .AND. nMode != MULT_MODE ) ; // .AND. !aTmpFac[ _LIMPALB ]
         ON CHANGE( lCalcDeta( aTmp, aTmpFac ), loaArt( cCodArt, aGet, aTmp, aTmpFac, oStkAct, oSayPr1, oSayPr2, oSayVp1, oSayVp2, bmpImage, nMode, .f. ) );
         VALID    ( lCalcDeta( aTmp, aTmpFac ), loaArt( cCodArt, aGet, aTmp, aTmpFac, oStkAct, oSayPr1, oSayPr2, oSayVp1, oSayVp2, bmpImage, nMode, .f. ) );
			PICTURE 	cPicUnd ;
         OF       oFld:aDialogs[1] ;
         IDSAY    141

      REDEFINE GET aGet[ _CUNIDAD ] VAR aTmp[ _CUNIDAD ] ;
			ID 		170 ;
         IDTEXT   171 ;
         BITMAP   "LUPA" ;
         VALID    ( oUndMedicion:Existe( aGet[ _CUNIDAD ], aGet[ _CUNIDAD ]:oHelpText, "cNombre" ), ValidaMedicion( aTmp, aGet ) );
         ON HELP  ( oUndMedicion:Buscar( aGet[ _CUNIDAD ] ), ValidaMedicion( aTmp, aGet ) ) ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

      // Campos de las descripciones de la unidad de medición

      REDEFINE GET aGet[ ( D():FacturasRectificativasLineas( nView ) )->( fieldpos( "nMedUno" ) ) ] ;
         VAR      aTmp[ ( D():FacturasRectificativasLineas( nView ) )->( fieldpos( "nMedUno" ) ) ] ;
         ID       520 ;
         IDSAY    521 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ON CHANGE( lCalcDeta( aTmp, aTmpFac ) );
         PICTURE  MasUnd() ;
         OF       oFld:aDialogs[1]

         aGet[ ( D():FacturasRectificativasLineas( nView ) )->( fieldpos( "nMedUno" ) ) ]:oSay:SetColor( CLR_BLUE )

      REDEFINE GET aGet[ ( D():FacturasRectificativasLineas( nView ) )->( fieldpos( "nMedDos" ) ) ] ;
         VAR      aTmp[ ( D():FacturasRectificativasLineas( nView ) )->( fieldpos( "nMedDos" ) ) ] ;
         ID       530 ;
         IDSAY    531 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ON CHANGE( lCalcDeta( aTmp, aTmpFac ) );
         PICTURE  MasUnd() ;
         OF       oFld:aDialogs[1]

         aGet[ ( dbfFacRecL )->( fieldpos( "nMedDos" ) ) ]:oSay:SetColor( CLR_BLUE )

      REDEFINE GET aGet[ ( dbfFacRecL )->( fieldpos( "nMedTre" ) ) ] ;
         VAR      aTmp[ ( dbfFacRecL )->( fieldpos( "nMedTre" ) ) ] ;
         ID       540 ;
         IDSAY    541 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ON CHANGE( lCalcDeta( aTmp, aTmpFac ) );
         PICTURE  MasUnd() ;
         OF       oFld:aDialogs[1]

         aGet[ ( dbfFacRecL )->( fieldpos( "nMedTre" ) ) ]:oSay:SetColor( CLR_BLUE )

      REDEFINE GET aGet[ _NPREUNIT ] VAR aTmp[ _NPREUNIT ] ;
         ID       150 ;
			SPINNER ;
			PICTURE 	cPouDiv ;
         WHEN     ( nMode != ZOOM_MODE .AND. !lTotLin .AND. nMode != MULT_MODE ) ;
         ON CHANGE( lCalcDeta( aTmp, aTmpFac ) );
         VALID    ( lCalcDeta( aTmp, aTmpFac ) );
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _NTARLIN ] VAR aTmp[ _NTARLIN ];
         ID       156 ;
         SPINNER ;
         MIN      1 ;
         MAX      6 ;
         PICTURE  "9" ;
         VALID    ( aTmp[ _NTARLIN ] >= 1 .AND. aTmp[ _NTARLIN ] <= 6 );
         WHEN     ( nMode != ZOOM_MODE .and. ( SQLAjustableModel():getRolCambiarPrecios( Auth():rolUuid() ) ) );
         ON CHANGE(  changeTarifa( aTmp, aGet, aTmpFac ),;
                     loadComisionAgente( aTmp, aGet, aTmpFac ),;
                     lCalcDeta( aTmp, aTmpFac ) );
         OF       oFld:aDialogs[1]

      aGet[ _NPREUNIT ]:bHelp := {|| DesgPnt( cCodArt, aTmp, aTmp[ _NTARLIN ], aGet[ _NPREUNIT ], aGet[ _NCOSDIV ], nMode ), lCalcDeta( aTmp, aTmpFac ) }

      REDEFINE GET aGet[ _NPNTVER] VAR aTmp[_NPNTVER] ;
         ID       151 ;
         IDSAY    152 ;
			SPINNER ;
			COLOR 	CLR_GET ;
         PICTURE  cPpvDiv ;
         WHEN     ( nMode != ZOOM_MODE .AND. !lTotLin .AND. nMode != MULT_MODE ) ;
         ON CHANGE( lCalcDeta( aTmp, aTmpFac ) );
         VALID    ( lCalcDeta( aTmp, aTmpFac ) );
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _NFACCNV ] VAR aTmp[ _NFACCNV ] ;
         ID       295 ;
         WHEN     ( nMode != ZOOM_MODE .AND. !lTotLin .AND. nMode != MULT_MODE ) ;
         PICTURE  "@E 999,999.999999";
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _NPESOKG ] VAR aTmp[ _NPESOKG ] ;
			ID 		160 ;
         WHEN     ( nMode != ZOOM_MODE .AND. !lTotLin .AND. nMode != MULT_MODE ) ;
         PICTURE  "@E 999,999.999999";
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _NVOLUMEN ] VAR aTmp[ _NVOLUMEN ] ;
         ID       400 ;
         WHEN     ( nMode != ZOOM_MODE .AND. !lTotLin .AND. nMode != MULT_MODE ) ;
         PICTURE  "@E 999,999.999999";
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CVOLUMEN ] VAR aTmp[ _CVOLUMEN ] ;
         ID       410;
         WHEN     ( nMode != ZOOM_MODE .AND. !lTotLin .AND. nMode != MULT_MODE ) ;
			COLOR 	CLR_GET ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CFORMATO ] VAR aTmp[ _CFORMATO ];
         ID       460;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

      REDEFINE CHECKBOX aGet[ _LVOLIMP ] VAR aTmp[ _LVOLIMP ] ;
         ID       411;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ _CPESOKG ] VAR aTmp[ _CPESOKG ] ;
         ID       175 ;
         WHEN     ( nMode != ZOOM_MODE .AND. !lTotLin .AND. nMode != MULT_MODE ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _NDTODIV ] VAR aTmp[ _NDTODIV ] ;
         ID       260 ;
         IDSAY    261 ;
			SPINNER ;
         MIN      0 ;
         COLOR    Rgb( 255, 0, 0 ) ;
         ON CHANGE( lCalcDeta( aTmp, aTmpFac ) );
         VALID    ( aTmp[_NDTODIV] >= 0 ) ;
         WHEN     ( nMode != ZOOM_MODE .AND. !lTotLin ) ;
         PICTURE  cPouDiv ;
         OF       oFld:aDialogs[1]

		REDEFINE GET aGet[ _NDTO] VAR aTmp[_NDTO] ;
			ID 		180 ;
			SPINNER ;
			COLOR 	CLR_GET ;
         PICTURE  "@E 999.99" ;
         WHEN     ( nMode != ZOOM_MODE .AND. !lTotLin ) ;
         ON CHANGE( lCalcDeta( aTmp, aTmpFac ) );
         VALID    ( lCalcDeta( aTmp, aTmpFac ) ) ;
         OF       oFld:aDialogs[1]

		REDEFINE GET aGet[ _NDTOPRM] VAR aTmp[_NDTOPRM] ;
			ID 		190 ;
			SPINNER ;
			COLOR 	CLR_GET ;
         PICTURE  "@E 999.99" ;
         WHEN     ( nMode != ZOOM_MODE .AND. !lTotLin ) ;
         ON CHANGE( lCalcDeta( aTmp, aTmpFac ) );
         VALID    ( lCalcDeta( aTmp, aTmpFac ) ) ;
         OF       oFld:aDialogs[1]

		REDEFINE GET aGet[ _NCOMAGE] VAR aTmp[_NCOMAGE] ;
			ID 		200 ;
			SPINNER ;
         WHEN     ( nMode != ZOOM_MODE .AND. !lTotLin ) ;
         PICTURE  "@E 999.99";
         ON CHANGE( lCalcDeta( aTmp, aTmpFac ) );
         VALID    ( lCalcDeta( aTmp, aTmpFac ) ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET oComisionLinea VAR nComisionLinea ;
         ID       201 ;
         WHEN     ( .f. ) ;
         PICTURE  cPorDiv ;
         OF       oFld:aDialogs[ 1 ]

      REDEFINE GET oTotalLinea VAR nTotalLinea ;
         ID       220 ;
			WHEN 		.f. ;
         PICTURE  cPorDiv ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CCODTIP ] ;
         VAR      aTmp[ _CCODTIP ] ;
         WHEN     ( nMode != ZOOM_MODE .and. nMode != MULT_MODE .and. !lTotLin ) ;
         VALID    ( oTipArt:existe( aGet[ _CCODTIP ], aGet[ _CCODTIP ]:oHelpText ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( oTipArt:Buscar( aGet[ _CCODTIP ] ) ) ;
         ID       205 ;
         IDTEXT   206 ;
         OF       oFld:aDialogs[1]

      /*
      Almacen
      -------------------------------------------------------------------------
      */

      REDEFINE GET aGet[ _CALMLIN ] VAR aTmp[ _CALMLIN ] ;
         ID       300 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( cAlmacen( aGet[ _CALMLIN ], , oSayAlm ), if( !uFieldEmpresa( "lNStkAct" ), oStock:lPutStockActual( aTmp[ _CREF ], aTmp[ _CALMLIN ], aTmp[ _CVALPR1 ], aTmp[ _CVALPR2 ], aTmp[ _CLOTE ], aTmp[ _LKITART ], aTmp[ _NCTLSTK ], oStkAct ), .t. ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwAlmacen( aGet[ _CALMLIN], oSayAlm ) ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET oSayAlm VAR cSayAlm ;
			WHEN 		.F. ;
         ID       301 ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _COBRLIN ] VAR aTmp[ _COBRLIN ] ;
         ID       330 ;
         IDTEXT   331 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( cObras( aGet[ _COBRLIN ], aGet[ _COBRLIN ]:oHelpText, aTmpFac[ _CCODCLI ] ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwObras( aGet[ _COBRLIN ], aGet[ _COBRLIN ]:oHelpText, aTmpFac[ _CCODCLI ], dbfObrasT ) ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET oStkAct VAR nStkAct ;
         ID       310 ;
			COLOR 	CLR_GET ;
         WHEN     .f. ;
         PICTURE  cPicUnd ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _NCOSDIV] VAR aTmp[_NCOSDIV] ;
         ID       320 ;
			COLOR 	CLR_GET ;
         WHEN     ( nMode != ZOOM_MODE );
         PICTURE  cPouDiv ;
         OF       oFld:aDialogs[1] ;
         IDSAY    321 ;

      /*
      Segunda caja de dilogo---------------------------------------------------
      */

      REDEFINE GET aGet[ _NPOSPRINT] VAR aTmp[_NPOSPRINT] ;
         ID       100 ;
         SPINNER ;
			COLOR 	CLR_GET ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  "9999" ;
         OF       oFld:aDialogs[2]

      REDEFINE CHECKBOX aGet[ _LIMPLIN] VAR aTmp[_LIMPLIN]  ;
         ID       110 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ _DFECHA] VAR aTmp[_DFECHA] ;
         ID       120 ;
			SPINNER ;
         WHEN     ( nMode != ZOOM_MODE .AND. !lTotLin ) ;
         ON HELP  aGet[ _DFECHA]:cText( Calendario( aTmp[_DFECHA] ) ) ;
			COLOR 	CLR_GET ;
         OF       oFld:aDialogs[2]

      REDEFINE CHECKBOX aGet[ _LCONTROL] VAR aTmp[_LCONTROL]  ;
         ID       130 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ _NPVPREC] VAR aTmp[_NPVPREC] ;
         ID       140 ;
			COLOR 	CLR_GET ;
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

      /*Definición de familias y grupos de familias*/

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

	REDEFINE GET aGet[ _CCODPRV ] VAR  aTmp[ _CCODPRV ] ;
        ID       200 ;
        IDTEXT 	 201 ;	
        WHEN     ( nMode != ZOOM_MODE ) ;
        VALID    ( cProvee( aGet[ _CCODPRV ], D():Proveedores( nView ), aGet[ _CCODPRV ]:oHelpText ) );
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

      REDEFINE Get aGet[ __DFECFAC ] VAR aTmp[ __DFECFAC ] ;
      	ID 		  360 ;
      	SPINNER ;
      	WHEN      (nMode != ZOOM_MODE .AND. !lTotLin ) ;
      	ON HELP   aGet [ __DFECFAC ]:cText( Calendario( aTmp[ __DFECFAC ] ) ) ;
      	OF        oFld:aDialogs[2]

      REDEFINE GET aGet[ __TFECFAC ] VAR aTmp[ __TFECFAC ] ;
      	ID 		  361 ;
      	PICTURE   "@R 99:99:99" ;
      	WHEN      ( nMode != ZOOM_MODE .AND. !lTotLin ) ;
      	VALID     ( iif(	!validTime( aTmp[ __TFECFAC ] ),;
      						( msgStop( "El mensaje de la hora no es correcto" ), .f. ),;
      						.t. ) );
      	OF 		  oFld:aDialogs[2]

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
      Cuarta caja de diálogo---------------------------------------------------
      */

      REDEFINE GET aGet[ __CCENTROCOSTE ] VAR  aTmp[ __CCENTROCOSTE ] ;
         ID       410 ;
         IDTEXT   411 ;
         BITMAP   "LUPA" ;  
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( oCentroCoste:Existe( aGet[ __CCENTROCOSTE ], aGet[ __CCENTROCOSTE ]:oHelpText, "cNombre" ) );
         ON HELP  ( oCentroCoste:Buscar( aGet[ __CCENTROCOSTE ] ) ) ;
         OF       oFld:aDialogs[ 4 ]

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
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   SaveDeta( aTmp, aTmpFac, aGet, oFld, oBrw, oDlg, oSayPr1, oSayPr2, oSayVp1, oSayVp2, bmpImage, nMode, oTotalLinea, oStkAct, nStkAct, cCodArt, oBtn, oBtnSer )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
         CANCEL ;
			ACTION 	( oDlg:end() )

      REDEFINE BUTTON ;
         ID       9 ;
			OF 		oDlg ;
         ACTION   ( ChmHelp( "Añadir_v" ) )

      REDEFINE BUTTON oBtnSer ;
         ID       552 ;
			OF 		oDlg ;
         ACTION   ( EditarNumeroSerie( aTmp, oStock, nMode ) )

   // Keys --------------------------------------------------------------------

   if nMode != ZOOM_MODE
      if uFieldEmpresa( "lGetLot")
         oDlg:AddFastKey( VK_RETURN,   {|| oBtn:SetFocus(), oBtn:Click() } )
      end if 
     	oDlg:AddFastKey( VK_F5, 			{|| oBtn:SetFocus(), oBtn:Click() } )
   end if

   oDlg:AddFastKey( VK_F6, {|| oBtnSer:Click() } )

   oDlg:bStart    := {|| SetDlgMode( aTmp, aGet, oFld, oSayPr1, oSayPr2, oSayVp1, oSayVp2, oStkAct, nMode, oTotalLinea, aTmpFac ),;
                         loadGet( aGet[ _CTERCTR ], cTipoCtrCoste ), aGet[ _CTERCTR ]:lValid(),;
   						    aGet[ _CCODPRV ]:lValid(), aGet[ _COBRLIN ]:lValid() }

   ACTIVATE DIALOG oDlg ;
      ON INIT     ( EdtDetMenu( aGet[ _CREF ], oDlg ) );
      ON PAINT    ( lCalcDeta( aTmp, aTmpFac ) );
      CENTER

   EndDetMenu()

   if !empty( bmpImage )
      bmpImage:End()
   end if

RETURN ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//
/*
Comprtamiento de la caja de dialogo
*/

STATIC FUNCTION SetDlgMode( aTmp, aGet, oFld, oSayPr1, oSayPr2, oSayVp1, oSayVp2, oStkAct, nMode, oTotal, aTmpFac )

   local cCodArt        := Left( aGet[ _CREF ]:VarGet(), 18 )

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
      aGet[ _NCANENT ]:SetText( cNombreCajas() )
   end if

   aGet[ _NUNICAJA ]:SetText( cNombreUnidades() )

   if aGet[ _NVALIMP ] != nil
      if !uFieldEmpresa( "lUseImp" )
         aGet[ _NVALIMP ]:Hide()
         aGet[ _LVOLIMP ]:Hide()
      else
         if !uFieldEmpresa( "lModImp" )
            aGet[ _NVALIMP ]:Disable()
         end if
         if !uFieldEmpresa( "lIvaImpEsp" )
            aGet[ _LVOLIMP ]:Disable()
         end if
      end if
   end if

   if !uFieldEmpresa( "lUsePor" )
      aGet[ _NIMPTRN ]:Hide()
   end if

   if !uFieldEmpresa( "lUsePnt" ) .or. !aTmpFac[ _LOPERPV ]
      aGet[ _NPNTVER ]:Hide()
   end if

   if aGet[ _NDTODIV ] != nil
      if !uFieldEmpresa( "lDtoLin" )
         aGet[ _NDTODIV ]:Hide()
      end if
   end if

   do case
   case nMode == APPD_MODE

      aGet[ _CREF    ]:cText( Space( 200 ) )

      aTmp[ _LIVALIN ]  := aTmpFac[ _LIVAINC ]

      aGet[ _NCANENT ]:cText( 1 )
      aGet[ _NUNICAJA]:cText( 1 )
      aTmp[ _NNUMLIN ]  := nLastNum( dbfTmpLin )
      aGet[ _NPOSPRINT]:cText( nLastNum( dbfTmpLin, "nPosPrint" ) )
      aGet[ _CALMLIN ]:cText( aTmpFac[ _CCODALM ])

      aGet[ _CDETALLE]:Show()
      aGet[ _MLNGDES ]:Hide()
      aGet[ _CLOTE   ]:Hide()
      aGet[ _DFECCAD ]:Hide()

      if aTmpFac[ _NREGIVA ] <= 2
      aGet[ _NIVA    ]:cText( nIva( dbfIva, cDefIva() ) )
      end if

      if !empty( oStkAct )

         if !uFieldEmpresa( "lNStkAct" )
            oStkAct:Show()
            oStkAct:cText( 0 )
         else
            oStkAct:Hide()
         end if

      end if

      aGet[ __CCENTROCOSTE ]:cText( aTmpFac[ _CCENTROCOSTE ] )

		if !empty( aGet[ __CCENTROCOSTE ] )
			aGet[ __CCENTROCOSTE ]:lValid()
		endif

      cTipoCtrCoste        := "Centro de coste"
      oTipoCtrCoste:Refresh()
      clearGet( aGet[ _CTERCTR ] )

   case ( nMode == EDIT_MODE .OR. nMode == ZOOM_MODE )

      if aTmp[ _LLOTE   ]
         aGet[ _CLOTE   ]:Show()
         aGet[ _DFECCAD ]:Show()
      else
         aGet[ _CLOTE   ]:Hide()
         aGet[ _DFECCAD ]:Hide()
      end if

      if !empty( cCodArt )

         aGet[ _CDETALLE ]:show()
         aGet[ _MLNGDES  ]:hide()

      else

         if !aTmp[ _LCONTROL ]
            aGet[ _CDETALLE ]:hide()
            aGet[ _MLNGDES  ]:show()
         else
            aGet[ _CDETALLE ]:show()
            aGet[ _MLNGDES  ]:hide()
         end if

      end if

      if oStkAct != nil

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
      aGet[ _CVALPR1 ]:Show()
      oSayPr1:Show()
      oSayVp1:Show()
      oSayPr1:SetText( retProp( aTmp[ _CCODPR1 ], dbfPro ) )
      aGet[ _CVALPR1 ]:lValid()
   else
      aGet[ _CVALPR1 ]:hide()
      oSayPr1:hide()
      oSayVp1:hide()
   end if

   if !empty( aTmp[ _CCODPR2 ] )
      aGet[ _CVALPR2 ]:Show()
      oSayPr2:Show()
      oSayVp2:Show()
      oSayPr2:SetText( retProp(  aTmp[ _CCODPR2 ], dbfPro ) )
      aGet[ _CVALPR2 ]:lValid()
   else
      aGet[ _CVALPR2 ]:hide()
      oSayPr2:hide()
      oSayVp2:hide()
   end if

   oTotal:cText( 0 )

   /*
   Ocultamos las tres unidades de medicion-------------------------------------
   */

   if !empty( aGet[ ( D():FacturasRectificativasLineas( nView ) )->( fieldpos( "nMedUno" ) ) ] )
      aGet[ ( D():FacturasRectificativasLineas( nView ) )->( fieldpos( "nMedUno" ) ) ]:Hide()
   end if

   if !empty( aGet[ ( D():FacturasRectificativasLineas( nView ) )->( fieldpos( "nMedDos" ) ) ] )
      aGet[ ( D():FacturasRectificativasLineas( nView ) )->( fieldpos( "nMedDos" ) ) ]:Hide()
   end if

   if !empty( aGet[ ( D():FacturasRectificativasLineas( nView ) )->( fieldpos( "nMedTre" ) ) ] )
      aGet[ ( D():FacturasRectificativasLineas( nView ) )->( fieldpos( "nMedTre" ) ) ]:Hide()
   end if

   if oUndMedicion:oDbf:Seek( aTmp[ _CUNIDAD ] )

      if !empty( aGet[ ( D():FacturasRectificativasLineas( nView ) )->( fieldpos( "nMedUno" ) ) ] ) .and. oUndMedicion:oDbf:nDimension >= 1 .and. !empty( oUndMedicion:oDbf:cTextoDim1 )
         aGet[ ( D():FacturasRectificativasLineas( nView ) )->( fieldpos( "nMedUno" ) ) ]:oSay:SetText( oUndMedicion:oDbf:cTextoDim1 )
         aGet[ ( D():FacturasRectificativasLineas( nView ) )->( fieldpos( "nMedUno" ) ) ]:Show()
      end if

      if !empty( aGet[ ( D():FacturasRectificativasLineas( nView ) )->( fieldpos( "nMedDos" ) ) ] ) .and. oUndMedicion:oDbf:nDimension >= 2 .and. !empty( oUndMedicion:oDbf:cTextoDim2 )
         aGet[ ( D():FacturasRectificativasLineas( nView ) )->( fieldpos( "nMedDos" ) ) ]:oSay:SetText( oUndMedicion:oDbf:cTextoDim2 )
         aGet[ ( D():FacturasRectificativasLineas( nView ) )->( fieldpos( "nMedDos" ) ) ]:Show()
      end if

      if !empty( aGet[ ( D():FacturasRectificativasLineas( nView ) )->( fieldpos( "nMedTre" ) ) ] ) .and. oUndMedicion:oDbf:nDimension >= 3 .and. !empty( oUndMedicion:oDbf:cTextoDim3 )
         aGet[ ( D():FacturasRectificativasLineas( nView ) )->( fieldpos( "nMedTre" ) ) ]:oSay:SetText( oUndMedicion:oDbf:cTextoDim3 )
         aGet[ ( D():FacturasRectificativasLineas( nView ) )->( fieldpos( "nMedTre" ) ) ]:Show()
      end if

   end if

   //Ocultamos las tres unidades de medicion

   if !empty( aGet[ ( D():FacturasRectificativasLineas( nView ) )->( fieldpos( "nMedUno" ) ) ] )
      aGet[ ( D():FacturasRectificativasLineas( nView ) )->( fieldpos( "nMedUno" ) ) ]:Hide()
   end if

   if !empty( aGet[ ( D():FacturasRectificativasLineas( nView ) )->( fieldpos( "nMedDos" ) ) ] )
      aGet[ ( D():FacturasRectificativasLineas( nView ) )->( fieldpos( "nMedDos" ) ) ]:Hide()
   end if

   if !empty( aGet[ ( D():FacturasRectificativasLineas( nView ) )->( fieldpos( "nMedTre" ) ) ] )
      aGet[ ( D():FacturasRectificativasLineas( nView ) )->( fieldpos( "nMedTre" ) ) ]:Hide()
   end if

   if oUndMedicion:oDbf:Seek(  aTmp[ _CUNIDAD ] )

      if !empty( aGet[ ( D():FacturasRectificativasLineas( nView ) )->( fieldpos( "nMedUno" ) ) ] ) .and. oUndMedicion:oDbf:nDimension >= 1 .and. !empty( oUndMedicion:oDbf:cTextoDim1 )
         aGet[ ( D():FacturasRectificativasLineas( nView ) )->( fieldpos( "nMedUno" ) ) ]:oSay:SetText( oUndMedicion:oDbf:cTextoDim1 )
         aGet[ ( D():FacturasRectificativasLineas( nView ) )->( fieldpos( "nMedUno" ) ) ]:Show()
      end if

      if !empty( aGet[ ( D():FacturasRectificativasLineas( nView ) )->( fieldpos( "nMedDos" ) ) ] ) .and. oUndMedicion:oDbf:nDimension >= 2 .and. !empty( oUndMedicion:oDbf:cTextoDim2 )
         aGet[ ( D():FacturasRectificativasLineas( nView ) )->( fieldpos( "nMedDos" ) ) ]:oSay:SetText( oUndMedicion:oDbf:cTextoDim2 )
         aGet[ ( D():FacturasRectificativasLineas( nView ) )->( fieldpos( "nMedDos" ) ) ]:Show()
      end if

      if !empty( aGet[ ( D():FacturasRectificativasLineas( nView ) )->( fieldpos( "nMedTre" ) ) ] ) .and. oUndMedicion:oDbf:nDimension >= 3 .and. !empty( oUndMedicion:oDbf:cTextoDim3 )
         aGet[ ( D():FacturasRectificativasLineas( nView ) )->( fieldpos( "nMedTre" ) ) ]:oSay:SetText( oUndMedicion:oDbf:cTextoDim3 )
         aGet[ ( D():FacturasRectificativasLineas( nView ) )->( fieldpos( "nMedTre" ) ) ]:Show()
      end if

   end if

   /*
   Mostramos u ocultamos las tarifas por líneas--------------------------------
   */

   if empty( aTmp[ _NTARLIN ] )
      if !empty( aGet[ _NTARLIN ] )
         aGet[ _NTARLIN ]:cText( oGetTarifa:getTarifa() )
      else
         aTmp[ _NTARLIN ]     := oGetTarifa:getTarifa()
      end if
   end if

   if !uFieldEmpresa( "lPreLin" )
      aGet[ _NTARLIN ]:Hide()
   else
      aGet[ _NTARLIN ]:Show()
   end if

   /*
   Focus y validaci¢n----------------------------------------------------------
   */

   aGet[ _CCODTIP ]:lValid()
   aGet[ _CALMLIN ]:lValid()
   aGet[ _CREF    ]:SetFocus()

   if !lAccArticulo() .or. oUser():lNotCostos()

      if !empty( aGet[ _NCOSDIV ] )
         aGet[ _NCOSDIV ]:Hide()
      end if

   end if

  /*
  Ocultamos las tres unidades de medicion--------------------------------------
  */

   if !empty( aGet[ ( D():FacturasRectificativasLineas( nView ) )->( fieldpos( "nMedUno" ) ) ] )
      aGet[ ( D():FacturasRectificativasLineas( nView ) )->( fieldpos( "nMedUno" ) ) ]:Hide()
   end if

   if !empty( aGet[ ( D():FacturasRectificativasLineas( nView ) )->( fieldpos( "nMedDos" ) ) ] )
      aGet[ ( D():FacturasRectificativasLineas( nView ) )->( fieldpos( "nMedDos" ) ) ]:Hide()
   end if

   if !empty( aGet[ ( D():FacturasRectificativasLineas( nView ) )->( fieldpos( "nMedTre" ) ) ] )
      aGet[ ( D():FacturasRectificativasLineas( nView ) )->( fieldpos( "nMedTre" ) ) ]:Hide()
   end if

   if oUndMedicion:oDbf:Seek(  aTmp[ _CUNIDAD ] )

      if !empty( aGet[ ( D():FacturasRectificativasLineas( nView ) )->( fieldpos( "nMedUno" ) ) ] ) .and. oUndMedicion:oDbf:nDimension >= 1 .and. !empty( oUndMedicion:oDbf:cTextoDim1 )
         aGet[ ( D():FacturasRectificativasLineas( nView ) )->( fieldpos( "nMedUno" ) ) ]:oSay:SetText( oUndMedicion:oDbf:cTextoDim1 )
         aGet[ ( D():FacturasRectificativasLineas( nView ) )->( fieldpos( "nMedUno" ) ) ]:Show()
      end if

      if !empty( aGet[ ( D():FacturasRectificativasLineas( nView ) )->( fieldpos( "nMedDos" ) ) ] ) .and. oUndMedicion:oDbf:nDimension >= 2 .and. !empty( oUndMedicion:oDbf:cTextoDim2 )
         aGet[ ( D():FacturasRectificativasLineas( nView ) )->( fieldpos( "nMedDos" ) ) ]:oSay:SetText( oUndMedicion:oDbf:cTextoDim2 )
         aGet[ ( D():FacturasRectificativasLineas( nView ) )->( fieldpos( "nMedDos" ) ) ]:Show()
      end if

      if !empty( aGet[ ( D():FacturasRectificativasLineas( nView ) )->( fieldpos( "nMedTre" ) ) ] ) .and. oUndMedicion:oDbf:nDimension >= 3 .and. !empty( oUndMedicion:oDbf:cTextoDim3 )
         aGet[ ( D():FacturasRectificativasLineas( nView ) )->( fieldpos( "nMedTre" ) ) ]:oSay:SetText( oUndMedicion:oDbf:cTextoDim3 )
         aGet[ ( D():FacturasRectificativasLineas( nView ) )->( fieldpos( "nMedTre" ) ) ]:Show()
      end if

   end if

   //Solo pueden modificar los precios los administradores-----------------------

   if ( empty( aTmp[ _NPREUNIT ] ) .or. ( SQLAjustableModel():getRolCambiarPrecios( Auth():rolUuid() ) ) ) .and. nMode != ZOOM_MODE
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

   // Empieza la edicion-------------------------------------------------------

   if !empty( oFld )
      oFld:SetOption( 1 )
   end if

   // Propiedades--------------------------------------------------------------

   if !empty( oBrwProperties )
      oBrwProperties:Hide()
      oBrwProperties:Cargo    := nil
   end if 

   // Focus al codigo-------------------------------------------------------------

   aGet[ _CREF ]:SetFocus()

RETURN NIL

//--------------------------------------------------------------------------//
/*
Guarda la linea de detalle
*/

STATIC FUNCTION SaveDeta( aTmp, aTmpFac, aGet, oFld, oBrw, oDlg, oSayPr1, oSayPr2, oSayVp1, oSayVp2, bmpImage, nMode, oTotal, oStkAct, nStkAct, cCodArt, oBtn, oBtnSer )

   local n 
   local i

   local nRec     
   local aClo     
   local aXbyStr              := { 0, 0 }
   local nTotUnd              := 0
   local hAtipica
   local nPrecioPropiedades   := 0

   oBtn:SetFocus()

   if !aGet[ _CREF ]:lValid()
      return nil
   end if

   if !lMoreIva( aTmp[_NIVA] )
      Return nil
   end if

   if empty( aTmp[ _CALMLIN ] ) .and. !empty( aTmp[ _CREF ] )
      msgStop( "Código de almacén no puede estar vacío", "Atención" )
      Return nil
   end if

   if !cAlmacen( aGet[ _CALMLIN ], dbfAlm )
      Return nil
   end if

   /*
   Comprobamos si tiene que introducir números de serie------------------------
   */

   if ( nMode == APPD_MODE ) .and. RetFld( aTmp[ _CREF ], D():Articulos( nView ), "lNumSer" ) .and. !( dbfTmpSer )->( dbSeek( Str( aTmp[ _NNUMLIN ], 4 ) + aTmp[ _CREF ] ) )
      MsgStop( "Tiene que introducir números de serie para este artículo." )
      oBtnSer:Click()
      Return nil
   end if

   if !lMoreIva( aTmp[ _NIVA ] )
      return nil
   end if

   /*
   Modo de edición multiple los cambios afectan a todos los registros seleccionados
   */

   if nMode == MULT_MODE

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

      Return nil

   end if

   /*
   Fin de modo de edición multiple---------------------------------------------
   */

   aTmp[ _CTIPCTR ]   := cTipoCtrCoste
   nRec     		    := ( dbfTmpLin )->( RecNo() )
   aClo     		    := aClone( aTmp )

   if !empty( aTmp[ _CREF ] ) .and. aTmp[ _LNOTVTA ]

      nTotUnd     := nTotNFacRec( aTmp ) - nTotNFacRec( dbfTmpLin )

      if ( nTotUnd != 0 .and. ( nStkAct - nTotUnd ) < 0 )
         MsgStop( "No hay stock suficiente." )
         return nil
      end if

   end if

   aTmp[ _NREQ ]  := nPReq( dbfIva, aTmp[ _NIVA ] )

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

                  // Precio por propiedades

                  nPrecioPropiedades   := nPrePro( aTmp[ _CREF ], aTmp[ _CCODPR1 ], aTmp[ _CVALPR1 ], aTmp[ _CCODPR2 ], aTmp[ _CVALPR2 ], aTmp[ _NTARLIN ], aTmpFac[ _LIVAINC ], dbfArtDiv, dbfTarPreL, aTmpFac[ _CCODTAR ] )
                  if !empty(nPrecioPropiedades)
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

         //WinGather( aTmp, aGet, dbfTmpLin, oBrw, nMode )

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

   bmpImage:Hide()

   if !empty( bmpImage:hBitmap )
      PalBmpFree( bmpImage:hBitmap, bmpImage:hPalette )
   endif

   cOldCodArt     := ""
   cOldUndMed     := ""

   if !empty( aGet[ _CUNIDAD ] )
      aGet[ _CUNIDAD ]:lValid()
   end if

   if nMode == APPD_MODE .AND. lEntCon()

      recalculaTotal( aTmpFac )

      aCopy( dbBlankRec( dbfTmpLin ), aTmp )
      aEval( aGet, {| o, i | if( "GET" $ o:ClassName(), o:cText( aTmp[ i ] ), ) } )

      SetDlgMode( aTmp, aGet, oFld, oSayPr1, oSayPr2, oSayVp1, oSayVp2, oStkAct, nMode, oTotal, aTmpFac )

      SysRefresh()

   else

      oDlg:end( IDOK )

   end if

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
   local nPosPrint
   local nRecAct                       := ( dbfKit    )->( RecNo() )
   local nRecLin                       := ( dbfTmpLin )->( RecNo() )
   local nUnidades                     := 0
   local nStkActual                    := 0
   local nStockMinimo                  := 0

   if ValType( uTmpLin ) == "A"
      cCodArt                          := uTmpLin[ _CREF    ]
      cSerAlb                          := uTmpLin[ _CSERIE  ]
      nNumAlb                          := uTmpLin[ _NNUMFAC ]
      cSufAlb                          := uTmpLin[ _CSUFFAC ]
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
      nTarLin                          := uTmpLin[ _NTARLIN ]
   else
      cCodArt                          := ( uTmpLin )->cRef
      cSerAlb                          := ( uTmpLin )->cSerie
      nNumAlb                          := ( uTmpLin )->nNumFac
      cSufAlb                          := ( uTmpLin )->cSufFac
      nCanEnt                          := ( uTmpLin )->nCanEnt
      dFecAlb                          := ( uTmpLin )->dFecha
      cTipMov                          := ( uTmpLin )->id_tipo_v      
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
               ( dbfTmpLin )->nNumLin  	:= nLastNum( dbfTmpLin )
               ( dbfTmpLin )->nPosPrint   := nLastNum( dbfTmpLin , "nPosPrint" )
               ( dbfTmpLin )->lKitChl  	:= .f.
            else
               ( dbfTmpLin )->nNumLin  	:= nNumLin
               ( dbfTmpLin )->nPosPrint   := nPosPrint
               ( dbfTmpLin )->lKitChl  	:= .t.
            end if

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

            ( dbfTmpLin )->cSerie      := cSerAlb
            ( dbfTmpLin )->nNumFac     := nNumAlb
            ( dbfTmpLin )->cSufFac     := cSufAlb
            ( dbfTmpLin )->nCanEnt     := nCanEnt
            ( dbfTmpLin )->dFecha      := dFecAlb
            ( dbfTmpLin )->id_tipo_v   := cTipMov
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
               ( dbfTmpLin )->nPreUnit := nRetPreArt( nTarLin, aTmpAlb[ _CDIVFAC ], aTmpAlb[ _LIVAINC ], D():Articulos( nView ), D():Get( "Divisas", nView ), dbfKit, D():Get( "TIva", nView ), , , oNewImp )
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
                  case oUser():lNotAllowSales( nStkActual - nUnidades < 0 )

                     MsgStop( "No hay stock suficiente para realizar la venta" + CRLF + ;
                              "del componente " + alltrim( ( dbfKit )->cRefKit ) + " - " + alltrim( ( D():Articulos( nView ) )->Nombre ),;
                              "¡Atención!" )

                  case oUser():lNotAllowSales( nStkActual - nUnidades < nStockMinimo )

                     MsgStop( "El stock del componente " + alltrim( ( dbfKit )->cRefKit ) + " - " + alltrim( ( D():Articulos( nView ) )->Nombre )  + CRLF + ;
                              "está bajo minimo."                                                                                                  + CRLF + ;
                              "Unidades a vender : " + alltrim( Trans( nUnidades, MasUnd() ) )                                                     + CRLF + ;
                              "Stock minimo : " + alltrim( Trans( nStockMinimo, MasUnd() ) )                                                       + CRLF + ;
                              "Stock actual : " + alltrim( Trans( nStkActual, MasUnd() ) ),;
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
      sOfertaArticulo         := structOfertaArticulo( D():getHashArray( aTmpFac, "FacRecT", nView ), D():getHashArray( aTmp, "FacRecL", nView ), nTotLFacRec( aTmp ), nView )
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

Static Function EdtInc( aTmp, aGet, dbfFacRecI, oBrw, bWhen, bValid, nMode, aTmpFac )

   local oDlg

   if nMode == APPD_MODE
      aTmp[ _CSERIE   ] := aTmpFac[ _CSERIE  ]
      aTmp[ _NNUMFAC  ] := aTmpFac[ _NNUMFAC ]
      aTmp[ _CSUFFAC  ] := aTmpFac[ _CSUFFAC ]
   end if

   DEFINE DIALOG oDlg RESOURCE "INCIDENCIA" TITLE LblTitle( nMode ) + "incidencias de facturas rectificativas"

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

Return ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

Static Function EdtEst( aTmp, aGet, dbf, oBrw, bWhen, bValid, nMode, aTmpFac )

   	local oDlg

   	if nMode == APPD_MODE
      	
      	aTmp[ (D():FacturasRectificativasSituaciones( nView ))->(fieldpos("tFecSit")) ]	:= GetSysTime()

    end if

   	DEFINE DIALOG oDlg RESOURCE "SITUACION_ESTADO" TITLE LblTitle( nMode ) + "Situación del documento del cliente"

   		REDEFINE COMBOBOX aGet[ (D():FacturasRectificativasSituaciones( nView ))->(fieldpos("cSitua")) ] ;
   			VAR 	 aTmp[ (D():FacturasRectificativasSituaciones( nView ))->(fieldpos("cSitua")) ] ;
         	ID       200 ;
         	WHEN     ( nMode != ZOOM_MODE );
         	ITEMS    ( SituacionesRepository():getNombres() ) ;
         	OF       oDlg

        REDEFINE GET aGet[ (D():FacturasRectificativasSituaciones( nView ))->(fieldpos("dFecSit")) ] ;
        	VAR 	aTmp[ (D():FacturasRectificativasSituaciones( nView ))->(fieldpos("dFecSit")) ] ;
			ID 		100 ;
			SPINNER ;
         	ON HELP  aGet[ (D():FacturasRectificativasSituaciones( nView ))->(fieldpos("dFecSit")) ]:cText( Calendario( aTmp[ (D():FacturasRectificativasSituaciones( nView ))->(fieldpos("dFecSit")) ] ) ) ;
			WHEN 	( nMode != ZOOM_MODE ) ;
			OF 		oDlg

	  	REDEFINE GET aGet[ (D():FacturasRectificativasSituaciones( nView ))->(fieldpos("tFecSit")) ] ;
	  		VAR 	 aTmp[ (D():FacturasRectificativasSituaciones( nView ))->(fieldpos("tFecSit")) ] ;
         	ID       101 ;
         	PICTURE  "@R 99:99:99" ;
         	WHEN     ( nMode != ZOOM_MODE ) ;
         	VALID    ( iif( !validTime( aTmp[ (D():FacturasRectificativasSituaciones( nView ))->(fieldpos("tFecSit")) ] ),;
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

Static Function EdtDoc( aTmp, aGet, dbfFacRecD, oBrw, bWhen, bValid, nMode, aTmpLin )

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

STATIC FUNCTION AppKit( aClo, aTmpFac, dbfTmpLin, dbfKit )

   local nRec           := ( dbfTmpLin )->( RecNo() )
   local nNumLin        := ( dbfTmpLin )->nNumLin
   local nUnidades      := 0
   local nStkActual     := 0
   local nStockMinimo   := 0

   if aClo[ _LKITART ] .and. ( dbfKit )->( dbSeek( aClo[ _CREF ] ) )

      while ( dbfKit )->cCodKit == aClo[ _CREF ] .and. !( dbfKit )->( eof() )

         if ( D():Articulos( nView ) )->( dbSeek( ( dbfKit )->cRefKit ) )

            ( dbfTmpLin )->( dbAppend() )

            if lKitAsociado( aClo[ _CREF ], D():Articulos( nView ) )
               ( dbfTmpLin )->nNumLin  := nLastNum( dbfTmpLin )
               ( dbfTmpLin )->lKitChl  := .f.
            else
               ( dbfTmpLin )->nNumLin  := nNumLin
               ( dbfTmpLin )->lKitChl  := .t.
            end if

            ( dbfTmpLin )->cRef        := ( dbfKit      )->cRefKit
            ( dbfTmpLin )->nPreUnit    := ( dbfKit      )->nPreKit
            ( dbfTmpLin )->cDetalle    := ( D():Articulos( nView ) )->Nombre
            ( dbfTmpLin )->nPntVer     := ( D():Articulos( nView ) )->nPntVer1
            ( dbfTmpLin )->nPesokg     := ( D():Articulos( nView ) )->nPesoKg
            ( dbfTmpLin )->cPesokg     := ( D():Articulos( nView ) )->cUndDim
            ( dbfTmpLin )->cUnidad     := ( D():Articulos( nView ) )->cUnidad
            ( dbfTmpLin )->nCtlStk     := ( D():Articulos( nView ) )->nCtlStock
            ( dbfTmpLin )->cCodImp     := ( D():Articulos( nView ) )->cCodImp
            ( dbfTmpLin )->lLote       := ( D():Articulos( nView ) )->lLote
            ( dbfTmpLin )->nLote       := ( D():Articulos( nView ) )->nLote
            ( dbfTmpLin )->cLote       := ( D():Articulos( nView ) )->cLote
            ( dbfTmpLin )->nPvpRec     := ( D():Articulos( nView ) )->PvpRec

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

            ( dbfTmpLin )->cSerie      := aClo[ _CSERIE  ]
            ( dbfTmpLin )->nNumFac     := aClo[ _NNUMFAC ]
            ( dbfTmpLin )->cSufFac     := aClo[ _CSUFFAC ]
            ( dbfTmpLin )->nCanEnt     := aClo[ _NCANENT ]
            ( dbfTmpLin )->dFecha      := aClo[ _DFECHA  ]
            ( dbfTmpLin )->id_tipo_v   := aClo[ _CTIPMOV ]
            ( dbfTmpLin )->nNumLin     := aClo[ _NNUMLIN ]
            ( dbfTmpLin )->cAlmLin     := aClo[ _CALMLIN ]
            ( dbfTmpLin )->lIvaLin     := aClo[ _LIVALIN ]
            ( dbfTmpLin )->nComAge     := aClo[ _NCOMAGE ]
            ( dbfTmpLin )->nUniCaja    := aClo[ _NUNICAJA] * ( dbfKit )->nUndKit

            /*
            Estudio de los tipos de impuestos si el padre el cero todos cero---------
            */

            if !empty( aClo[ _NIVA ] )
               ( dbfTmpLin )->nIva     := nIva( dbfIva, ( D():Articulos( nView ) )->TipoIva )
               ( dbfTmpLin )->nReq     := nReq( dbfIva, ( D():Articulos( nView ) )->TipoIva )
            else
               ( dbfTmpLin )->nIva     := 0
               ( dbfTmpLin )->nReq     := 0
            end if

            /*
            Propiedades de los kits--------------------------------------------
            */

            ( dbfTmpLin )->lImpLin     := lImprimirComponente( aClo[ _CREF ], D():Articulos( nView ) )   // 1 Todos, 2 Compuesto, 3 Componentes
            ( dbfTmpLin )->lKitPrc     := lPreciosComponentes( aClo[ _CREF ], D():Articulos( nView ) )   // 1 Todos, 2 Compuesto, 3 Componentes

            if ( dbfTmpLin )->lKitPrc
               ( dbfTmpLin )->nPreUnit := nRetPreArt( aClo[ _NTARLIN ], aTmpFac[ _CDIVFAC ], aTmpFac[ _LIVAINC ], D():Articulos( nView ), dbfDiv, dbfKit, dbfIva, , , oNewImp )
            end if

            if lStockComponentes( aClo[ _CREF ], D():Articulos( nView ) )
               ( dbfTmpLin )->nCtlStk  := ( D():Articulos( nView ) )->nCtlStock
            else
               ( dbfTmpLin )->nCtlstk  := STOCK_NO_CONTROLAR // No controlar Stock
            end if

            /*
            Descuentos------------------------------------------------------
            */

            if ( dbfKit )->lAplDto
               ( dbfTmpLin )->nDto     := aClo[ _NDTO    ]
               ( dbfTmpLin )->nDtoPrm  := aClo[ _NDTOPRM ]
               ( dbfTmpLin )->nDtoDiv  := aClo[ _NDTODIV ]
            end if

            /*
            Avisaremos del stock bajo minimo--------------------------------------
            */

            nStockMinimo      := nStockMinimo( aClo[ _CREF ], aClo[ _CALMLIN ], nView )

            if ( D():Articulos( nView ))->lMsgVta .and. !uFieldEmpresa( "lNStkAct" ) .and. nStockMinimo > 0

               nStkActual     := oStock:nStockAlmacen( ( dbfKit )->cRefKit, ( dbfTmpLin )->cAlmLin )
               nUnidades      := aClo[ _NUNICAJA ] * ( dbfKit )->nUndKit

               do case
                  case nStkActual - nUnidades < 0

                        MsgStop( "No hay stock suficiente para realizar la venta" + CRLF + ;
                                 "del componente " + alltrim( ( dbfKit )->cRefKit ) + " - " + alltrim( ( D():Articulos( nView ) )->Nombre ),;
                                 "¡Atención!" )

                  case nStkActual - nUnidades < nStockMinimo

                        MsgStop( "El stock del componente " + alltrim( ( dbfKit )->cRefKit ) + " - " + alltrim( ( D():Articulos( nView ) )->Nombre ) + CRLF + ;
                                 "está bajo minimo." + CRLF + ;
                                 "Unidades a vender : " + alltrim( Trans( nUnidades, MasUnd() ) ) + CRLF + ;
                                 "Stock minimo : " + alltrim( Trans( nStockMinimo, MasUnd() ) ) + CRLF + ;
                                 "Stock actual : " + alltrim( Trans( nStkActual, MasUnd() ) ),;
                                 "¡Atención!" )
               end case

            end if

         end if

         ( dbfKit )->( dbSkip() )

      end while

      ( dbfTmpLin )->( dbGoTo( nRec ) )

   end if

RETURN NIL

//---------------------------------------------------------------------------//

/*
Funcion Auxiliar para A¤adir lineas de detalle a una Factura
*/

STATIC FUNCTION AppDeta( oBrwDet, bEdtDet, aTmp, lTot, cCodArt )

   DEFAULT lTot   := .f.

   if ( empty( aNumAlb ) ) .or. lTot // .and. !aTmp[ _LIMPALB ] )

      WinAppRec( oBrwDet, bEdtDet, dbfTmpLin, lTot, cCodArt, aTmp )

   else

      MsgStop( "No se pueden añadir registros a una factura que" + CRLF + ;
               "proviene de albaranes." )

   end if

RETURN RecalculaTotal( aTmp )

//--------------------------------------------------------------------------//
/*
Funcion Auxiliar para la Edici¢n de Lineas de Detalle en una Factura
*/

STATIC FUNCTION EdtDeta( oBrwDet, bEdtDet, aTmp, lTot, nFacMod )

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
               "proviene de albaranes." )

   end if
   */

RETURN RecalculaTotal( aTmp )

//--------------------------------------------------------------------------//
/*
Funcion Auxiliar para borrar las Lineas de Detalle en una Factura
*/

STATIC FUNCTION DelDeta()

   CursorWait()

   while ( dbfTmpSer )->( dbSeek( Str( ( dbfTmpLin )->nNumLin, 4 ) ) )
      ( dbfTmpSer )->( dbDelete() )
   end while

   if ( dbfTmpLin )->lKitArt
      dbDelKit( , dbfTmpLin, ( dbfTmpLin )->nNumLin )
   end if

   CursorWE()

RETURN ( .t. )

//--------------------------------------------------------------------------//

STATIC FUNCTION PrnSerie()

	local oDlg
   local oFmtDoc
   local cFmtDoc     := cFormatoDocumento( ( D():FacturasRectificativas( nView ) )->cSerie, "nFacRec", dbfCount )
   local oSayFmt
   local cSayFmt
   local oSerIni
   local oSerFin
   local cSerIni     := ( D():FacturasRectificativas( nView ) )->cSerie
   local cSerFin     := ( D():FacturasRectificativas( nView ) )->cSerie
   local nDocIni     := ( D():FacturasRectificativas( nView ) )->nNumFac
   local nDocFin     := ( D():FacturasRectificativas( nView ) )->nNumFac
   local cSufIni     := ( D():FacturasRectificativas( nView ) )->cSufFac
   local cSufFin     := ( D():FacturasRectificativas( nView ) )->cSufFac
   local oPrinter
   local cPrinter    := PrnGetName()
   local lCopiasPre  := .t.
   local lInvOrden   := .f.
   local oRango
   local nRango      := 1
   local dFecDesde   := CtoD( "01/01/" + Str( Year( Date() ) ) )
   local dFecHasta   := Date()
   local oNumCop
   local nNumCop     := if( nCopiasDocumento( ( D():FacturasRectificativas( nView ) )->cSerie, "nFacRec", dbfCount ) == 0, Max( Retfld( ( D():FacturasRectificativas( nView ) )->cCodCli, D():Clientes( nView ), "CopiasF" ), 1 ), nCopiasDocumento( ( D():FacturasRectificativas( nView ) )->cSerie, "nFacRec", dbfCount ) )

   if empty( cFmtDoc )
      cFmtDoc           := cSelPrimerDoc( "FR" )
   end if

   cSayFmt           := cNombreDoc( cFmtDoc )

   DEFINE DIALOG oDlg RESOURCE "IMPSERIES" TITLE "Imprimir series de facturas rectificativas"

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
      ON HELP  ( BrwDocumento( oFmtDoc, oSayFmt, "FR" ) ) ;
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
      CANCEL ;
      ACTION   ( oDlg:end() )

   oDlg:bStart := { || oSerIni:SetFocus() }

   oDlg:AddFastKey( VK_F5, {|| StartPrint( SubStr( cFmtDoc, 1, 3 ), cSerIni + Str( nDocIni, 9 ) + cSufIni, cSerFin + Str( nDocFin, 9 ) + cSufFin, oDlg, cPrinter, lCopiasPre, nNumCop, lInvOrden, nRango, dFecDesde, dFecHasta ), oDlg:end( IDOK ) } )

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

   		nRecno      := ( D():FacturasRectificativas( nView ) )->( Recno() )
   		nOrdAnt     := ( D():FacturasRectificativas( nView ) )->( OrdSetFocus( "NNUMFAC" ) )

   		if !lInvOrden

      		( D():FacturasRectificativas( nView ) )->( dbSeek( cDocIni, .t. ) )

      		while ( D():FacturasRectificativas( nView ) )->cSerie + Str( ( D():FacturasRectificativas( nView ) )->nNumFac ) + (D():FacturasRectificativas( nView ))->cSufFac >= cDocIni .AND. ;
        		( D():FacturasRectificativas( nView ) )->cSerie + Str( ( D():FacturasRectificativas( nView ) )->nNumFac ) + (D():FacturasRectificativas( nView ))->cSufFac <= cDocFin

	        	lChgImpDoc( D():FacturasRectificativas( nView ) )

         		if lCopiasPre

            		nCopyClient := if( nCopiasDocumento( ( D():FacturasRectificativas( nView ) )->cSerie, "nFacRec", dbfCount ) == 0, Max( Retfld( ( D():FacturasRectificativas( nView ) )->cCodCli, D():Clientes( nView ), "CopiasF" ), 1 ), nCopiasDocumento( ( D():FacturasRectificativas( nView ) )->cSerie, "nFacRec", dbfCount ) )

            		GenFacRec( IS_PRINTER, "Imprimiendo documento : " + ( D():FacturasRectificativas( nView ) )->cSerie + Str( ( D():FacturasRectificativas( nView ) )->nNumFac ) + ( D():FacturasRectificativas( nView ) )->cSufFac, cFmtDoc, cPrinter, nCopyClient )

         		else

            		GenFacRec( IS_PRINTER, "Imprimiendo documento : " + ( D():FacturasRectificativas( nView ) )->cSerie + Str( ( D():FacturasRectificativas( nView ) )->nNumFac ) + ( D():FacturasRectificativas( nView ) )->cSufFac, cFmtDoc, cPrinter, nNumCop )

         		end if

      		( D():FacturasRectificativas( nView ) )->( dbSkip() )

      		end while

   		else

      		( D():FacturasRectificativas( nView ) )->( dbSeek( cDocFin ) )

      		while ( D():FacturasRectificativas( nView ) )->cSerie + Str( ( D():FacturasRectificativas( nView ) )->nNumFac ) + ( D():FacturasRectificativas( nView ) )->cSufFac >= cDocIni .and.;
            		( D():FacturasRectificativas( nView ) )->cSerie + Str( ( D():FacturasRectificativas( nView ) )->nNumFac ) + ( D():FacturasRectificativas( nView ) )->cSufFac <= cDocFin .and.;
            		!( D():FacturasRectificativas( nView ) )->( Bof() )

            		lChgImpDoc( D():FacturasRectificativas( nView ) )

        		 if lCopiasPre

            		nCopyClient := if( nCopiasDocumento( ( D():FacturasRectificativas( nView ) )->cSerie, "nFacRec", dbfCount ) == 0, Max( Retfld( ( D():FacturasRectificativas( nView ) )->cCodCli, D():Clientes( nView ), "CopiasF" ), 1 ), nCopiasDocumento( ( D():FacturasRectificativas( nView ) )->cSerie, "nFacRec", dbfCount ) )

            		GenFacRec( IS_PRINTER, "Imprimiendo documento : " + ( D():FacturasRectificativas( nView ) )->cSerie + Str( ( D():FacturasRectificativas( nView ) )->nNumFac ) + ( D():FacturasRectificativas( nView ) )->cSufFac, cFmtDoc, cPrinter, nCopyClient )

         		else

           		 GenFacRec( IS_PRINTER, "Imprimiendo documento : " + ( D():FacturasRectificativas( nView ) )->cSerie + Str( ( D():FacturasRectificativas( nView ) )->nNumFac ) + ( D():FacturasRectificativas( nView ) )->cSufFac, cFmtDoc, cPrinter, nNumCop )

        		 end if

      		( D():FacturasRectificativas( nView ) )->( dbSkip( -1 ) )

      		end while

		end if

	else

		nRecno      := ( D():FacturasRectificativas( nView ) )->( Recno() )
   		nOrdAnt     := ( D():FacturasRectificativas( nView ) )->( OrdSetFocus( "DFECFAC" ) )

   		if !lInvOrden

      		( D():FacturasRectificativas( nView ) )->( dbGoTop() )

      		while !( D():FacturasRectificativas( nView ) )->( Eof() )

	        	if ( D():FacturasRectificativas( nView ) )->dFecFac >= dFecDesde .and. ( D():FacturasRectificativas( nView ) )->dFecFac <= dFecHasta

	        		lChgImpDoc( D():FacturasRectificativas( nView ) )

         			if lCopiasPre

	            		nCopyClient := if( nCopiasDocumento( ( D():FacturasRectificativas( nView ) )->cSerie, "nFacRec", dbfCount ) == 0, Max( Retfld( ( D():FacturasRectificativas( nView ) )->cCodCli, D():Clientes( nView ), "CopiasF" ), 1 ), nCopiasDocumento( ( D():FacturasRectificativas( nView ) )->cSerie, "nFacRec", dbfCount ) )

            			GenFacRec( IS_PRINTER, "Imprimiendo documento : " + ( D():FacturasRectificativas( nView ) )->cSerie + Str( ( D():FacturasRectificativas( nView ) )->nNumFac ) + ( D():FacturasRectificativas( nView ) )->cSufFac, cFmtDoc, cPrinter, nCopyClient )

         			else

	            		GenFacRec( IS_PRINTER, "Imprimiendo documento : " + ( D():FacturasRectificativas( nView ) )->cSerie + Str( ( D():FacturasRectificativas( nView ) )->nNumFac ) + ( D():FacturasRectificativas( nView ) )->cSufFac, cFmtDoc, cPrinter, nNumCop )

         			end if

         		end if

      		( D():FacturasRectificativas( nView ) )->( dbSkip() )

      		end while

   		else

      		( D():FacturasRectificativas( nView ) )->( dbGobottom() )

      		while !( D():FacturasRectificativas( nView ) )->( Bof() )

            	if ( D():FacturasRectificativas( nView ) )->dFecFac >= dFecDesde .and. ( D():FacturasRectificativas( nView ) )->dFecFac <= dFecHasta

            		lChgImpDoc( D():FacturasRectificativas( nView ) )

        			if lCopiasPre

	            		nCopyClient := if( nCopiasDocumento( ( D():FacturasRectificativas( nView ) )->cSerie, "nFacRec", dbfCount ) == 0, Max( Retfld( ( D():FacturasRectificativas( nView ) )->cCodCli, D():Clientes( nView ), "CopiasF" ), 1 ), nCopiasDocumento( ( D():FacturasRectificativas( nView ) )->cSerie, "nFacRec", dbfCount ) )

            			GenFacRec( IS_PRINTER, "Imprimiendo documento : " + ( D():FacturasRectificativas( nView ) )->cSerie + Str( ( D():FacturasRectificativas( nView ) )->nNumFac ) + ( D():FacturasRectificativas( nView ) )->cSufFac, cFmtDoc, cPrinter, nCopyClient )

         			else

	           			GenFacRec( IS_PRINTER, "Imprimiendo documento : " + ( D():FacturasRectificativas( nView ) )->cSerie + Str( ( D():FacturasRectificativas( nView ) )->nNumFac ) + ( D():FacturasRectificativas( nView ) )->cSufFac, cFmtDoc, cPrinter, nNumCop )

        			end if

        		end if	

      		( D():FacturasRectificativas( nView ) )->( dbSkip( -1 ) )

      		end while

		end if
	
	end if	

   	(D():FacturasRectificativas( nView ))->( dbGoTo( nRecNo ) )
   	(D():FacturasRectificativas( nView ))->( ordSetFocus( nOrdAnt ) )

   	oDlg:enable()

RETURN NIL

//--------------------------------------------------------------------------//

/*
Calcula totales en las lineas de Detalle
*/

STATIC FUNCTION lCalcDeta( aTmp, aTmpFac, lTotal )

   local nBase
   local nCosto
   local nMargen
   local nCalculo
   local nUnidades
   local nRentabilidad

   DEFAULT lTotal := .f.

   nCalculo       := aTmp[ _NPREUNIT ]
   nCalculo       -= aTmp[ _NDTODIV  ]

   nUnidades      := nTotNFacRec( aTmp )

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
      nCalculo    += nUnidades * aTmp[ _NIMPTRN ]
   end if

   /*
   Descuentos
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

   nMargen           := nBase - nCosto

   if nCalculo == 0
      nRentabilidad  := 0
   else
      nRentabilidad  := nRentabilidad( nCalculo, 0, nCosto )
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
      oRentabilidadLinea:cText( alltrim( Trans( nMargen, cPorDiv ) + alltrim( cSimDiv( cCodDiv, dbfDiv ) ) + " : " + alltrim( Trans( nRentabilidad, "999.99" ) ) + "%" ) )
   end if

   if !empty( oComisionLinea )
      oComisionLinea:cText( Round( ( nBase * aTmp[ _NCOMAGE ] / 100 ), nRouDiv ) )
   end if

RETURN ( if( !lTotal, .t., nCalculo ) )

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

   MsgStop( "Factura con más de 3 tipos de " + cImp() )

RETURN .F.

//---------------------------------------------------------------------------//
//----------------------------------------------------------------------------//
/*
Carga los articulos en la factura
*/

STATIC FUNCTION LoaArt( cCodArt, aGet, aTmp, aTmpFac, oStkAct, oSayPr1, oSayPr2, oSayVp1, oSayVp2, bmpImage, nMode, lFocused )

   local hHas128
   local cLote
   local dFechaCaducidad
   local nDtoAge
   local nImpAtp
   local nImpOfe
   local nCosPro
   local cCodFam
   local cPrpArt
   local nPrePro     			:= 0
   local nNumDto     			:= 0
   local cProveedor
   local nTarOld     			:= aTmp[ _NTARLIN ]
   local lChgCodArt
   local hAtipica
   local nUnidades            := 0

   DEFAULT lFocused           := .t.

   lChgCodArt           		:= ( empty( cOldCodArt ) .or. Rtrim( cOldCodArt ) != Rtrim( cCodArt ) )

   if empty( cCodArt )

      if lRetCodArt()
         MsgStop( "No se pueden añadir líneas sin codificar" )
         return .f.
      end if

      if empty( aTmp[ _NIVA ] )
         aGet[ _NIVA ]:bWhen  := {|| .t. }
      end if

		aGet[ _CDETALLE ]:cText( Space( 50 ) )
      aGet[ _CDETALLE ]:bWhen := {|| .t. }
      aGet[ _CDETALLE ]:Hide()

      if !empty( aGet[ _MLNGDES ] )
         aGet[ _MLNGDES ]:Show()
	      if lFocused 
   	     aGet[ _MLNGDES ]:SetFocus()
      	end if
      end if

      aGet[ _CVALPR1 ]:Hide()
      oSayPr1:Hide()
      oSayVp1:Hide()

      aGet[ _CVALPR2 ]:Hide()
      oSayPr2:Hide()
      oSayVp2:Hide()

      Return .t.

   end if

   IF lModIva()
      aGet[ _NIVA ]:bWhen  := {|| .t. }
   ELSE
      aGet[ _NIVA ]:bWhen 	:= {|| .f. }
   END IF

   /*
   Buscamos codificacion GS1-128--------------------------------------------
   */
   
   if Len( alltrim( cCodArt ) ) > 18

      hHas128              := ReadHashCodeGS128( )

      if !empty( hHas128 )
         
         cCodArt           := uGetCodigo( hHas128, "00" )

         if Empty( cCodArt )
            cCodArt        := uGetCodigo( hHas128, "01" )
         end if

         cLote             := uGetCodigo( hHas128, "10" )

         dFechaCaducidad   := uGetCodigo( hHas128, "15" )    

         if Empty( dFechaCaducidad )
            dFechaCaducidad   := uGetCodigo( hHas128, "17" )
         end if

         nUnidades         := uGetCodigo( hHas128, "3103" )

      end if 

   end if

   cCodArt                 := cSeekCodebar( cCodArt, dbfCodebar, D():Articulos( nView ) )

   /*
   Ahora buscamos por el codigo interno
   */

   if ( D():Articulos( nView ) )->( dbSeek( cCodArt ) ) .or. ( D():Articulos( nView ) )->( dbSeek( Upper( cCodArt ) ) )

      if ( lChgCodArt )

         if ( D():Articulos( nView ) )->lObs
            MsgStop( "Artículo catalogado como obsoleto" )
            return .f.
         end if

         CursorWait()

         cCodArt              := ( D():Articulos( nView ) )->Codigo

         aGet[ _CREF ]:cText( Padr( cCodArt, 200 ) )
         aTmp[ _CREF ]        := cCodArt

         //Pasamos las referencias adicionales------------------------------

         aTmp[ _CREFAUX ]     := ( D():Articulos( nView ) )->cRefAux
         aTmp[ _CREFAUX2 ]    := ( D():Articulos( nView ) )->cRefAux2

         if ( D():Articulos( nView ) )->lMosCom .and. !empty( ( D():Articulos( nView ) )->mComent )
            MsgStop( Trim( ( D():Articulos( nView ) )->mComent ) )
         end if

         /*
         Metemos el proveedor habitual--------------------------------------
         */

         if !empty( aGet[ _CCODPRV ] )
            aGet[ _CCODPRV ]:cText( ( D():Articulos( nView ) )->cPrvHab )
            aGet[ _CCODPRV ]:lValid()
         else
            aTmp[ _CCODPRV ]  := ( D():Articulos( nView ) )->cPrvHab   
         end if

         aTmp[ _CREFPRV ]  := Padr( cRefPrvArt( cCodArt, (D():Articulos( nView ))->cPrvHab, dbfArtPrv ), 18 )

         aGet[ _CDETALLE ]:show()
         aGet[ _MLNGDES  ]:hide()

         aGet[ _CDETALLE ]:cText( ( D():Articulos( nView ) )->Nombre )
         aGet[ _MLNGDES  ]:cText( ( D():Articulos( nView ) )->Nombre )

         /*
         Descripciones largas--------------------------------------------------
         */

         if !empty( ( D():Articulos( nView ) )->Descrip )
            if !empty( aGet[ _DESCRIP ] )
               aGet[ _DESCRIP ]:cText( ( D():Articulos( nView ) )->Descrip )
            else
               aTmp[ _DESCRIP ]     := ( D():Articulos( nView ) )->Descrip
            end if 
         end if

         /*
         Peso y volumen
         -------------------------------------------------------------------
         */

         if !empty( aGet[ _NPESOKG ] )
            aGet[ _NPESOKG  ]:cText( ( D():Articulos( nView ) )->nPesoKg )
         else
            aGet[ _NPESOKG  ] := ( D():Articulos( nView ) )->nPesoKg
         end if

         if !empty( aGet[ _CPESOKG ] )
             aGet[ _CPESOKG ]:cText( ( D():Articulos( nView ) )->cUndDim )
         else
             aGet[ _CPESOKG ] := ( D():Articulos( nView ) )->cUndDim
         end if

         if !empty( aGet[ _CUNIDAD ] )
             aGet[ _CUNIDAD ]:cText( ( D():Articulos( nView ) )->cUnidad )
             aGet[ _CUNIDAD ]:lValid()
         else
             aTmp[ _CUNIDAD ] := ( D():Articulos( nView ) )->cUnidad
         end if

         if !empty( aGet[ _CCODTIP ] )
            aGet[ _CCODTIP ]:cText( ( D():Articulos( nView ) )->cCodTip )
         else
            aTmp[ _CCODTIP ]  := ( D():Articulos( nView ) )->cCodTip
         end if

         /*
         Factor de conversion
         ----------------------------------------------------------------------
         */

         if ( D():Articulos( nView ) )->lFacCnv
            aTmp[ _NFACCNV ]  := ( D():Articulos( nView ) )->nFacCnv
         end if

         /*
         Lotes
         ----------------------------------------------------------------------
         */

         if ( D():Articulos( nView ) )->lLote

         	if empty( cLote )
         		cLote 			:= ( D():Articulos( nView ) )->cLote
         	end if 

            if !empty( aGet[ _CLOTE ] )
               aGet[ _CLOTE ]:Show()
               aGet[ _CLOTE ]:cText( cLote )
               aGet[ _CLOTE ]:lValid()
            else
               aTmp[ _CLOTE ] := cLote
            end if

            aTmp[ _LLOTE ]    := .t.

            /*
            Fecha de caducidad-------------------------------------------------
            */

            if empty( dFechaCaducidad )
               dFechaCaducidad 	:= dFechaCaducidadLote( aTmp[ _CREF ], aTmp[ _CVALPR1 ], aTmp[ _CVALPR2 ], aTmp[ _CLOTE ], dbfAlbPrvL, dbfFacPrvL, dbfProLin )
            end if 
            
            if !empty( aGet[ _DFECCAD ] )

               aGet[ _DFECCAD ]:Show()

               if empty( aTmp[ _DFECCAD ] )
                  aGet[ _DFECCAD ]:cText( dFechaCaducidad )
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
         Tomamos el código de la familia y del grupo de familia----------------
         */

         cCodFam              := ( D():Articulos( nView ) )->Familia
         if !empty( cCodFam )
            aTmp[_CCODFAM]    := cCodFam
            aTmp[_CGRPFAM]    := cGruFam( cCodFam, dbfFamilia )
            aGet[ _CCODFAM]:cText( cCodFam )
            aGet[ _CGRPFAM]:cText( cGruFam( cCodFam, dbfFamilia ) )
            aGet[ _CCODFAM]:lValid()
            aGet[ _CGRPFAM]:lValid()
         else
            aGet[ _CCODFAM]:cText( Space( 8 ) )
            aGet[ _CGRPFAM]:cText( Space( 3 ) )
            aGet[ _CCODFAM]:lValid()
            aGet[ _CGRPFAM]:lValid()
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
         Preguntamos si el regimen de impuestos es distinto de Exento----------------
         */

         if aTmpFac[_NREGIVA] <= 2
            aGet[ _NIVA ]:cText( nIva( dbfIva, ( D():Articulos( nView ) )->TIPOIVA ) )
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

         if (D():Articulos( nView ))->nCajEnt != 0
            aGet[ _NCANENT ]:cText( (D():Articulos( nView ))->nCajEnt )
         end if

         if !Empty( nUnidades )
               aGet[ _NUNICAJA ]:cText( nUnidades )
            end if

            if Empty( nUnidades ) .and. ( D():Articulos( nView ) )->nUniCaja != 0
               aGet[ _NUNICAJA ]:cText( ( D():Articulos( nView ) )->nUniCaja  )
            end if

         /*
         Si la comisi¢n del articulo hacia el agente es distinto de cero----------
         */

         loadComisionAgente( aTmp, aGet, aTmpFac )

         /*
         Tomamos el valor del stock y anotamos si nos dejan vender sin stock
         */

         if oStkAct != nil .and. !uFieldEmpresa( "lNStkAct" ) .and. aTmp[ _NCTLSTK ] <= 1
            oStock:nPutStockActual( cCodArt, aTmp[ _CALMLIN ], , , , aTmp[ _LKITART ], aTmp[ _NCTLSTK ], oStkAct )
         end if

         aTmp[ _LNOTVTA ]     := ( D():Articulos( nView ) )->lNotVta

         /*
         Cargamos los costos------------------------------------------------
         */

         if !uFieldEmpresa( "lCosAct" )
            nCosPro              := oStock:nCostoMedio( aTmp[ _CREF ], aTmp[ _CALMLIN ], aTmp[ _CCODPR1 ], aTmp[ _CVALPR1 ], aTmp[ _CCODPR2 ], aTmp[ _CVALPR2 ], aTmp [ _CLOTE ] )
            if nCosPro == 0
               nCosPro           := nCosto( aTmp[ _CREF ], D():Articulos( nView ), dbfKit, .f., , dbfDiv )
            end if
         else
            nCosPro              := nCosto( aTmp[ _CREF ], D():Articulos( nView ), dbfKit, .f., , dbfDiv )
         end if

         if aGet[ _NCOSDIV ] != nil
            aGet[ _NCOSDIV ]:cText( nCosPro )
         else
            aTmp[ _NCOSDIV ]  := nCosPro
         end if

         /*
         Descuento de artículo----------------------------------------------
         */

         nNumDto              := RetFld( aTmpFac[ _CCODCLI ], D():Clientes( nView ), "nDtoArt" )

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
         Imagen del producto------------------------------------------------
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

         /*
         Buscamos la familia del articulo y anotamos las propiedades-----------
         */

         aTmp[ _CCODPR1 ]  := ( D():Articulos( nView ) )->cCodPrp1
         aTmp[ _CCODPR2 ]  := ( D():Articulos( nView ) )->cCodPrp2

         if ( !empty( aTmp[ _CCODPR1 ] ) .or. !empty( aTmp[ _CCODPR2 ] ) ) .and. ( uFieldEmpresa( "lUseTbl" ) .and. ( nMode == APPD_MODE ) )

            aGet[ _NCANENT  ]:cText( 0 )
            aGet[ _NUNICAJA ]:cText( 0 )

            setPropertiesTable( cCodArt, aTmp[ _CCODPR1 ], aTmp[ _CCODPR2 ], 0, aGet[ _NUNICAJA ], oBrwProperties, nView )

         else 

            hidePropertiesTable( oBrwProperties )

            if !empty( aTmp[ _CCODPR1 ] )
               aGet[ _CVALPR1 ]:Show()
               if lFocused
                  aGet[ _CVALPR1 ]:SetFocus()
               end if
               oSayPr1:SetText( retProp( ( D():Articulos( nView ) )->cCodPrp1, dbfPro ) )
               oSayPr1:Show()
               oSayVp1:Show()
            else
               aGet[ _CVALPR1 ]:hide()
               oSayPr1:hide()
               oSayVp1:hide()
            end if

            if !empty( aTmp[ _CCODPR2 ] )
               aGet[ _CVALPR2 ]:Show()
               oSayPr2:SetText( retProp( ( D():Articulos( nView ) )->cCodPrp2, dbfPro ) )
               oSayPr2:Show()
               oSayVp2:Show()
            else
               aGet[ _CVALPR2 ]:hide()
               oSayPr2:Hide()
               oSayVp2:Hide()
            end if

         end if

      end if

      /*
      He terminado de meter todo lo que no son precios ahora es cuando meteré los precios con todas las opciones posibles
      */

      cPrpArt              := aTmp[ _CCODPR1 ] + aTmp[ _CCODPR2 ] + aTmp[ _CVALPR1 ] + aTmp[ _CVALPR2 ]

      if ( lChgCodArt ) .or. ( cPrpArt != cOldPrpArt )

         //--guardamos el código de la familia--//

         if nMode == APPD_MODE
            cCodFam        := RetFamArt( cCodArt, D():Articulos( nView ) )
         else
            cCodFam        := aTmp[_CCODFAM]
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

         aGet[ _NPNTVER ]:cText( ( D():Articulos( nView ) )->nPntVer1 )
         aTmp[ _NPVPREC ]   := ( D():Articulos( nView ) )->PvpRec

         /*
         Cargamos el codigo de las unidades---------------------------------
         */

         if !empty( aGet[ _CUNIDAD ] )
            aGet[ _CUNIDAD ]:cText( ( D():Articulos( nView ) )->cUnidad )
         else
            aTmp[ _CUNIDAD ]  := ( D():Articulos( nView ) )->cUnidad
         end if

         //--guardamos el precio del artículo dependiendo de las propiedades--//

         nPrePro           := nPrePro( aTmp[ _CREF ], aTmp[ _CCODPR1 ], aTmp[ _CVALPR1 ], aTmp[ _CCODPR2 ], aTmp[ _CVALPR2 ], aTmp[ _NTARLIN ], aTmpFac[ _LIVAINC ], dbfArtDiv, dbfTarPreL, aTmpFac[_CCODTAR] )

         if nPrePro == 0
            aGet[ _NPREUNIT]:cText( nRetPreArt( aTmp[ _NTARLIN ], aTmpFac[ _CDIVFAC ], aTmpFac[ _LIVAINC ], D():Articulos( nView ), dbfDiv, dbfKit, dbfIva, , , oNewImp ) )
         else
            aGet[ _NPREUNIT]:cText( nPrePro )
         end if

         //--Precios en tarifas--//

         if !empty( aTmpFac[ _CCODTAR ] )

            //--Precio--//
            nImpOfe  := RetPrcTar( cCodArt, aTmpFac[ _CCODTAR ], aTmp[ _CCODPR1 ], aTmp[ _CCODPR2 ], aTmp[ _CVALPR1 ], aTmp[ _CVALPR2 ], dbfTarPreL, aTmp[ _NTARLIN ] )
            if nImpOfe != 0
               aGet[ _NPREUNIT]:cText( nImpOfe )
            end if

            //--Descuento porcentual--//
            nImpOfe  := RetPctTar( cCodArt, cCodFam, aTmpFac[ _CCODTAR ], aTmp[ _CCODPR1 ], aTmp[ _CCODPR2 ], aTmp[ _CVALPR1 ], aTmp[ _CVALPR2 ], dbfTarPreL )
            if nImpOfe != 0
               aGet[ _NDTO   ]:cText( nImpOfe )
            end if

            //--Descuento lineal--//
            nImpOfe  := RetLinTar( cCodArt, cCodFam, aTmpFac[_CCODTAR], aTmp[_CCODPR1], aTmp[_CCODPR2], aTmp[_CVALPR1], aTmp[_CVALPR2], dbfTarPreL )
            if nImpOfe != 0
               aGet[ _NDTODIV]:cText( nImpOfe )
            end if

            //--Comision de agente--//
            nImpOfe  := RetComTar( cCodArt, cCodFam, aTmpFac[_CCODTAR], aTmp[_CCODPR1], aTmp[_CCODPR2], aTmp[_CVALPR1], aTmp[_CVALPR2], aTmpFac[_CCODAGE], dbfTarPreL, dbfTarPreS )
            if nImpOfe != 0
               aGet[ _NCOMAGE]:cText( nImpOfe )
            end if

            //--Descuento de promoci¢n--//

            nImpOfe  := RetDtoPrm( cCodArt, cCodFam, aTmpFac[_CCODTAR], aTmp[_CCODPR1], aTmp[_CCODPR2], aTmp[_CVALPR1], aTmp[_CVALPR2], aTmpFac[_DFECFAC], dbfTarPreL )
            if nImpOfe  != 0
               aGet[ _NDTOPRM]:cText( nImpOfe )
            end if

            //--Descuento de promoci¢n para el agente--//

            nDtoAge     := RetDtoAge( cCodArt, cCodFam, aTmpFac[_CCODTAR], aTmp[_CCODPR1], aTmp[_CCODPR2], aTmp[_CVALPR1], aTmp[_CVALPR2], aTmpFac[_DFECFAC], aTmpFac[_CCODAGE], dbfTarPreL, dbfTarPreS )
            if nDtoAge  != 0
               aGet[ _NCOMAGE ]:cText( nDtoAge )
            end if

         end if

        /*
        Chequeamos las atipicas del cliente--------------------------------
        */

        hAtipica := hAtipica( hValue( aTmp, aTmpFac ) )

        if !empty( hAtipica )
               
            if hhaskey( hAtipica, "nImporte" )
            	if hAtipica[ "nImporte" ] != 0
                	aGet[ _NPREUNIT ]:cText( hAtipica[ "nImporte" ] )
                end if
            end if

            if hhaskey( hAtipica, "nDescuentoPorcentual" )
                if hAtipica[ "nDescuentoPorcentual"] != 0
                	aGet[ _NDTO ]:cText( hAtipica[ "nDescuentoPorcentual"] )   
                end if	
            end if

            if hhaskey( hAtipica, "nDescuentoPromocional" )
                if hAtipica[ "nDescuentoPromocional" ] != 0
                	aGet[ _NDTOPRM ]:cText( hAtipica[ "nDescuentoPromocional" ] )
                end if	
            end if

            if hhaskey( hAtipica, "nComisionAgente" )
                if hAtipica[ "nComisionAgente" ] != 0
                	aGet[ _NCOMAGE ]:cText( hAtipica[ "nComisionAgente" ] )
                end if	
            end if

            if hhaskey( hAtipica, "nDescuentoLineal" )
                if hAtipica[ "nDescuentoLineal" ] != 0
                	aGet[ _NDTODIV ]:cText( hAtipica[ "nDescuentoLineal" ] )
                end if
            end if

        end if

         // Buscamos si existen ofertas para este articulo y le cambiamos el precio--

         nImpOfe     := nImpOferta( cCodArt, aTmpFac[ _CCODCLI ], aTmpFac[_CCODGRP], aTmp[ _NUNICAJA ], aTmpFac[ _DFECFAC ], dbfOferta, aTmp[ _NTARLIN ], , aTmp[_CCODPR1], aTmp[_CCODPR2], aTmp[_CVALPR1], aTmp[_CVALPR2] )
         if nImpOfe  != 0
            aGet[ _NPREUNIT ]:cText( nCnv2Div( nImpOfe, cDivEmp(), aTmpFac[ _CDIVFAC ] ) )
         end if

         // Buscamos si existen descuentos en las ofertas----------------------

         nImpOfe     := nDtoOferta( cCodArt, aTmpFac[ _CCODCLI ], aTmpFac[_CCODGRP], aTmp[ _NUNICAJA ], aTmpFac[ _DFECFAC ], dbfOferta, aTmp[_CCODPR1], aTmp[_CCODPR2], aTmp[_CVALPR1], aTmp[_CVALPR2] )
         if nImpOfe  != 0
            aGet[ _NDTO]:cText( nImpOfe )
         end if

         // Buscamos si existen descuentos lineales en las ofertas-------------

         nImpOfe     := nDtoLineal( cCodArt, aTmpFac[ _CCODCLI ], aTmpFac[_CCODGRP], aTmp[ _NUNICAJA ], aTmpFac[ _DFECFAC ], dbfOferta, aTmp[_CCODPR1], aTmp[_CCODPR2], aTmp[_CVALPR1], aTmp[_CVALPR2] )
         if nImpOfe  != 0
            aGet[ _NDTODIV ]:cText( nImpOfe )
         end if

         ValidaMedicion( aTmp, aGet )

      end if

      /*
      Buscamos si hay ofertas-----------------------------------------------
      */

      lBuscaOferta( cCodArt, aGet, aTmp, aTmpFac, dbfOferta, dbfDiv, dbfKit, dbfIva  )

      /*
      Cargamos los valores para los cambios---------------------------------
      */

      cOldPrpArt  := cPrpArt
      cOldCodArt  := cCodArt

      /*
      Solo pueden modificar los precios los administradores--------------
      */

      if empty( aTmp[ _NPREUNIT ] ) .or. ( SQLAjustableModel():getRolCambiarPrecios( Auth():rolUuid() ) )
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

      CursorWE()

   else

      MsgStop( "Artículo no encontrado" )
      Return .f.

   end if

RETURN .t.

//--------------------------------------------------------------------------//

/*
Cargaos los datos del cliente
*/

STATIC FUNCTION loaCli( aGet, aTmp, nMode, oRieCli, oTlfCli )

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

   if ( D():Clientes( nView ) )->( dbSeek( cNewCodCli ) )

      /*
      Asignamos el codigo siempre
      */

      aGet[ _CCODCLI ]:cText( ( D():Clientes( nView ) )->Cod )

      if oTlfCli != nil
         oTlfCli:SetText( ( D():Clientes( nView ) )->Telefono )
      end if

      if ( D():Clientes( nView ) )->nColor != 0
         aGet[ _CNOMCLI]:SetColor( , ( D():Clientes( nView ) )->nColor )
      end if

      if empty( aGet[ _CNOMCLI]:varGet() ) .or. lChgCodCli
         aGet[ _CNOMCLI]:cText( ( D():Clientes( nView ) )->Titulo )
      end if

      if empty( aGet[ _CDIRCLI]:varGet() ) .or. lChgCodCli
         aGet[ _CDIRCLI]:cText( ( D():Clientes( nView ) )->Domicilio )
      end if

      if empty( aGet[ _CTLFCLI ]:varGet() ) .or. lChgCodCli
         aGet[ _CTLFCLI ]:cText( ( D():Clientes( nView ) )->Telefono )
      end if

      if empty( aGet[ _CPOBCLI]:varGet() ) .or. lChgCodCli
         aGet[ _CPOBCLI]:cText( ( D():Clientes( nView ) )->Poblacion )
      end if

      if empty( aGet[ _CPRVCLI]:varGet() ) .or. lChgCodCli
         aGet[ _CPRVCLI]:cText( ( D():Clientes( nView ) )->Provincia )
      end if

      if empty( aGet[ _CPOSCLI]:varGet() ) .or. lChgCodCli
         aGet[ _CPOSCLI]:cText( ( D():Clientes( nView ) )->CodPostal )
      end if

      if empty( aGet[ _CDNICLI ]:varGet() ) .or. lChgCodCli
         aGet[ _CDNICLI ]:cText( ( D():Clientes( nView ) )->Nif )
      end if

      /*
      Cargamos la obra por defecto-------------------------------------
      */

      if ( lChgCodCli ) .and. !empty( aGet[ _CCODOBR ] )

         if dbSeekInOrd( cNewCodCli, "lDefObr", dbfObrasT )
            aGet[ _CCODOBR ]:cText( ( dbfObrasT )->cCodObr )
         else
            aGet[ _CCODOBR ]:cText( Space( 10 ) )
         end if

         aGet[ _CCODOBR ]:lValid()

      end if

      if empty( aTmp[ _CCODGRP ] ) .or. lChgCodCli
         aTmp[ _CCODGRP ]  := ( D():Clientes( nView ) )->cCodGrp
      end if

      if lChgCodCli
         aTmp[ _LMODCLI ]  := ( D():Clientes( nView ) )->lModDat
      end if

      if ( lChgCodCli )
         aTmp[ _LOPERPV ]  := ( D():Clientes( nView ) )->lPntVer
      end if

      if nMode == APPD_MODE

         aTmp[_NREGIVA ]   := ( D():Clientes( nView ) )->nRegIva

         /*if !empty( aGet[ _NREGIVA ] )
            aGet[ _NREGIVA ]:Refresh()
         end if*/

         lChangeRegIva( aTmp )

         /*
         Si estamos a¤adiendo cargamos todos los datos del cliente
         */

         if empty( aTmp[ _CSERIE ] )

            if !empty( ( D():Clientes( nView ) )->Serie )
               aGet[ _CSERIE ]:cText( ( D():Clientes( nView ) )->Serie )
            end if

         else

            if !empty( ( D():Clientes( nView ) )->Serie )               .and.;
               aTmp[ _CSERIE ] != ( D():Clientes( nView ) )->Serie      .and.;
               ApoloMsgNoYes( "La serie del cliente seleccionado es distinta a la anterior.", "¿Desea cambiar la serie?" )
               aGet[ _CSERIE ]:cText( ( D():Clientes( nView ) )->Serie )
            end if

         end if

         if ( empty( aGet[ _CCODALM]:varGet() ) .or. lChgCodCli ) .and. !empty( ( D():Clientes( nView ) )->cCodAlm )
            aGet[ _CCODALM]:cText( ( D():Clientes( nView ) )->cCodAlm )
            aGet[ _CCODALM]:lValid()
         end if

         if ( empty( aGet[ _CCODTAR]:varGet() ) .or. lChgCodCli ) .and. !empty( ( D():Clientes( nView ) )->cCodTar )
            aGet[ _CCODTAR]:cText( ( D():Clientes( nView ) )->CCODTAR )
            aGet[ _CCODTAR]:lValid()
         end if

         if ( empty( aGet[ _CCODPAGO]:varGet() ) .or. lChgCodCli ) .and. !empty( ( D():Clientes( nView ) )->CodPago )

            aGet[ _CCODPAGO]:cText( (D():Clientes( nView ))->CODPAGO )
            aGet[ _CCODPAGO]:lValid()

            /*
            Si la forma de pago es un movimiento bancario le asignamos el banco y cuenta por defecto
            */

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

         if ( empty( aGet[ _CCODAGE]:varGet() ) .or. lChgCodCli ) .and. !empty( ( D():Clientes( nView ) )->cAgente )
            aGet[ _CCODAGE]:cText( (D():Clientes( nView ))->CAGENTE )
            aGet[ _CCODAGE]:lValid()
         end if

         if ( empty( aGet[ _CCODRUT]:varGet() ) .or. lChgCodCli ) .and. !empty( ( D():Clientes( nView ) )->cCodRut )
            aGet[ _CCODRUT]:cText( ( D():Clientes( nView ))->CCODRUT )
            aGet[ _CCODRUT]:lValid()
         end if

         if !empty( oGetTarifa )
	         if ( empty( oGetTarifa:varGet() ) .or. lChgCodCli ) .and. !empty( ( D():Clientes( nView ) )->nTarifa )
	            oGetTarifa:getTarifa( ( D():Clientes( nView ) )->nTarifa )
	         end if
         endif

         if ( empty( aTmp[ _NDTOTARIFA ] ) .or. lChgCodCli )
             aTmp[ _NDTOTARIFA ]    := ( D():Clientes( nView ) )->nDtoArt
         end if

         if !empty( aGet[ _CCODTRN ] ) .and. ( empty( aGet[ _CCODTRN ]:varGet() ) .or. lChgCodCli ) .and. !empty( ( D():Clientes( nView ) )->cCodTrn )
            aGet[ _CCODTRN ]:cText( ( D():Clientes( nView ) )->cCodTrn )
            aGet[ _CCODTRN ]:lValid()
         end if

         if lChgCodCli

            aGet[ _LRECARGO ]:Click( ( D():Clientes( nView ) )->lReq )

            aGet[ _LOPERPV  ]:Click( ( D():Clientes( nView ) )->lPntVer )

            /*
            Retenciones desde la ficha de cliente----------------------------------
            */
            /*
            if !empty( aGet[ _NTIPRET ] )
               aGet[ _NTIPRET  ]:Select( ( D():Clientes( nView ) )->nTipRet )
            else
               aTmp[ _NTIPRET  ] := ( D():Clientes( nView ) )->nTipRet
            end if
            */
            if !empty( aGet[ _NPCTRET ] )
               aGet[ _NPCTRET  ]:cText( ( D():Clientes( nView ) )->nPctRet )
            else
               aTmp[ _NPCTRET  ] := ( D():Clientes( nView ) )->nPctRet
            end if

            /*
            Descuentos desde la ficha de cliente----------------------------------
            */

            aGet[ _CDTOESP ]:cText( ( D():Clientes( nView ) )->cDtoEsp )

            aGet[ _NDTOESP ]:cText( ( D():Clientes( nView ) )->nDtoEsp )

            aGet[ _CDPP    ]:cText( ( D():Clientes( nView ) )->cDpp    )

            aGet[ _NDPP    ]:cText( ( D():Clientes( nView ) )->nDpp    )

            aGet[ _CDTOUNO ]:cText( ( D():Clientes( nView ) )->cDtoUno )

            aGet[ _CDTODOS ]:cText( ( D():Clientes( nView ) )->cDtoDos )

            aGet[ _NDTOUNO ]:cText( ( D():Clientes( nView ) )->nDtoCnt )

            aGet[ _NDTODOS ]:cText( ( D():Clientes( nView ) )->nDtoRap )

         end if

      end if

      if ( D():Clientes( nView ) )->lMosCom .and. !empty( ( D():Clientes( nView ) )->mComent ) .and. lChgCodCli
         MsgStop( Trim( ( D():Clientes( nView ) )->mComent ) )
      end if

      if !empty( oRieCli ) .and. lChgCodCli
         oStock:SetRiesgo( cNewCodCli, oRieCli, ( D():Clientes( nView ) )->Riesgo )
      end if

      ShowIncidenciaCliente( ( D():Clientes( nView ) )->Cod, nView )

      cOldCodCli  := ( D():Clientes( nView ) )->Cod

      lValid      := .t.

   else

		msgStop( "Cliente no encontrado" )

      lValid      := .f.

   end if

RETURN lValid

//----------------------------------------------------------------------------//

/*
Comienza la edición de la factura
*/

STATIC FUNCTION BeginTrans( aTmp, nMode )

   local oError
   local oBlock
   local lErrors  := .f.
   local cDbfLin  := "FCliL"
   local cDbfInc  := "FCliI"
   local cDbfDoc  := "FCliD"
   local cDbfAnt  := "FCliA"
   local cDbfPgo  := "FCliP"
   local cDbfSer  := "FCliS"
   local cDbfEst  := "FCliE"
   local nOrd
   local cFac     := aTmp[ _CSERIE ] + Str( aTmp[ _NNUMFAC ] ) + aTmp[ _CSUFFAC ]

   CursorWait()

   oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   cTmpLin        := cGetNewFileName( cPatTmp() + cDbfLin )
   cTmpInc        := cGetNewFileName( cPatTmp() + cDbfInc )
   cTmpDoc        := cGetNewFileName( cPatTmp() + cDbfDoc )
   cTmpAnt        := cGetNewFileName( cPatTmp() + cDbfAnt )
   cTmpPgo        := cGetNewFileName( cPatTmp() + cDbfPgo )
   cTmpSer        := cGetNewFileName( cPatTmp() + cDbfSer )
   cTmpEst        := cGetNewFileName( cPatTmp() + cDbfEst )

   /*
   Inicialización de variables-------------------------------------------------
   */

   aNumAlb        := {}

   /*
   Actualizacion de riesgo
   */

   do case
   case nMode == APPD_MODE .or. nMode == DUPL_MODE

      nTotOld     := 0

   case nMode == EDIT_MODE

      nTotOld     := nTotFac

   end case

	/*
   Primero crear la base de datos local----------------------------------------
	*/

   dbCreate( cTmpLin, aSqlStruct( aColFacRec() ), cLocalDriver() )
   dbUseArea( .t., cLocalDriver(), cTmpLin, cCheckArea( cDbfLin, @dbfTmpLin ), .f. )
   if !NetErr()

      ( dbfTmpLin )->( OrdCondSet( "!Deleted()", {||!Deleted() } ) )
      ( dbfTmpLin )->( OrdCreate( cTmpLin, "nNumLin", "Str( nNumLin, 4 )", {|| Str( Field->nNumLin ) } ) )

      ( dbfTmpLin )->( OrdCondSet( "!Deleted()", {||!Deleted() } ) )
      ( dbfTmpLin )->( OrdCreate( cTmpLin, "Recno", "Str( Recno() )", {|| Str( Recno() ) } ) )

      ( dbfTmpLin )->( OrdCondSet( "!Deleted()", {||!Deleted() } ) )
      ( dbfTmpLin )->( OrdCreate( cTmpLin, "nPosPrint", "Str( nPosPrint, 4 )", {|| Str( Field->nPosPrint ) } ) )

      if ( D():FacturasRectificativasLineas( nView ) )->( dbSeek( cFac ) )
         while ( ( D():FacturasRectificativasLineas( nView ) )->CSERIE + Str( ( D():FacturasRectificativasLineas( nView ) )->NNUMFAC ) + ( D():FacturasRectificativasLineas( nView ) )->CSUFFAC ) == cFac .AND. !( D():FacturasRectificativasLineas( nView ) )->( eof() )
            dbPass( D():FacturasRectificativasLineas( nView ), dbfTmpLin, .t. )
            ( D():FacturasRectificativasLineas( nView ) )->( DbSkip() )
         end while
      endif

      ( dbfTmpLin )->( dbGoTop() )

   else

      lErrors     := .t.

   end if

   /*
   Creamos la tabla temporal
   */

   dbCreate( cTmpInc, aSqlStruct( aIncFacRec() ), cLocalDriver() )
   dbUseArea( .t., cLocalDriver(), cTmpInc, cCheckArea( cDbfInc, @dbfTmpInc ), .f. )
   if !NetErr()
      ( dbfTmpInc )->( ordCondSet( "!Deleted()", {||!Deleted() } ) )
      ( dbfTmpInc )->( ordCreate( cTmpInc, "Recno", "Recno()", {|| Recno() } ) )

      if ( dbfFacRecI )->( dbSeek( cFac ) )
         while ( ( dbfFacRecI )->cSerie + Str( ( dbfFacRecI )->nNumFac ) + ( dbfFacRecI )->cSufFac == cFac ) .AND. ( dbfFacRecI )->( !eof() )
            dbPass( dbfFacRecI, dbfTmpInc, .t. )
            ( dbfFacRecI )->( dbSkip() )
         end while
      end if

      ( dbfTmpInc )->( dbGoTop() )

   else

      lErrors     := .t.

   end if

   /*
   Creamos la tabla temporal
   */

   dbCreate( cTmpDoc, aSqlStruct( aFacRecDoc() ), cLocalDriver() )
   dbUseArea( .t., cLocalDriver(), cTmpDoc, cCheckArea( cDbfDoc, @dbfTmpDoc ), .f. )
   if !NetErr()
      ( dbfTmpDoc )->( ordCondSet( "!Deleted()", {||!Deleted() } ) )
      ( dbfTmpDoc )->( ordCreate( cTmpDoc, "Recno", "Recno()", {|| Recno() } ) )

      if ( dbfFacRecD )->( dbSeek( cFac ) )
         while ( ( dbfFacRecD )->cSerFac + Str( ( dbfFacRecD )->nNumFac ) + ( dbfFacRecD )->cSufFac == cFac ) .AND. ( dbfFacRecD )->( !eof() )
            dbPass( dbfFacRecD, dbfTmpDoc, .t. )
            ( dbfFacRecD )->( dbSkip() )
         end while
      end if

      ( dbfTmpDoc )->( dbGoTop() )

   else

      lErrors     := .t.

   end if

   /*
   Creamos el fichero de series------------------------------------------------
   */

   dbCreate( cTmpSer, aSqlStruct( aSerFacRec() ), cLocalDriver() )
   dbUseArea( .t., cLocalDriver(), cTmpSer, cCheckArea( cDbfSer, @dbfTmpSer ), .f. )

   if !( dbfTmpSer )->( NetErr() )

      ( dbfTmpSer )->( OrdCondSet( "!Deleted()", {||!Deleted() } ) )
      ( dbfTmpSer )->( OrdCreate( cTmpSer, "nNumLin", "Str( nNumLin, 4 ) + cRef", {|| Str( Field->nNumLin, 4 ) + Field->cRef } ) )

      if ( dbfFacRecS )->( dbSeek( cFac ) )
         while ( ( dbfFacRecS )->cSerFac + Str( ( dbfFacRecS )->nNumFac ) + ( dbfFacRecS )->cSufFac == cFac ) .and. !( dbfFacRecS )->( eof() )
            dbPass( dbfFacRecS, dbfTmpSer, .t. )
            ( dbfFacRecS )->( dbSkip() )
         end while
      end if

      ( dbfTmpSer )->( dbGoTop() )

      oStock:SetTmpFacRecS( dbfTmpSer )

   end if

   /*
   Creamos la tabla temporal de pagos------------------------------------------
   */

   dbCreate( cTmpPgo, aSqlStruct( aItmRecCli() ), cLocalDriver() )
   dbUseArea( .t., cLocalDriver(), cTmpPgo, cCheckArea( cDbfPgo, @dbfTmpPgo ), .f. )

   if !NetErr()

      ( dbfTmpPgo )->( ordCondSet("!Deleted()", {|| !Deleted() } ) )
      ( dbfTmpPgo )->( ordCreate( cTmpPgo , "cRecDev", "cRecDev", {|| Field->cRecDev } ) )

      ( dbfTmpPgo )->( ordCondSet( "!Deleted()", {||!Deleted() } ) )
      ( dbfTmpPgo )->( ordCreate( cTmpPgo, "nNumFac", "cSerie + Str( nNumFac ) + cSufFac + Str( nNumRec ) + cTipRec", {|| Field->cSerie + Str( Field->nNumFac ) + Field->cSufFac + Str( Field->nNumRec ) + Field->cTipRec } ) )

      ( dbfTmpPgo )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( dbfTmpPgo )->( ordCreate( cTmpPgo, "cNumMtr", "Field->cNumMtr", {|| Field->cNumMtr } ) )

      ( dbfTmpPgo )->( ordCondSet("!Deleted() .and. Field->cTipRec == 'R'", {|| !Deleted() .and. Field->cTipRec == 'R' } ) )
      ( dbfTmpPgo )->( ordCreate( cTmpPgo, "rNumFac", "cSerie + str( nNumFac ) + cSufFac + str( nNumRec )", {|| Field->CSERIE + str( Field->NNUMFAC ) + Field->CSUFFAC + str( Field->NNUMREC ) } ) )

      nOrd        := ( dbfFacCliP )->( OrdSetFocus( "rNumFac" ) )

      if ( dbfFacCliP )->( dbSeek( cFac ) ) .and. nMode != DUPL_MODE
         while ( dbfFacCliP )->cSerie + Str( ( dbfFacCliP )->nNumFac ) + ( dbfFacCliP )->cSufFac == cFac .and. ( dbfFacCliP )->( !eof() )
            dbPass( dbfFacCliP, dbfTmpPgo, .t. )
            ( dbfFacCliP )->( dbSkip() )
         end while
      end if

      ( dbfTmpPgo  )->( dbGoTop() )

      ( dbfFacCliP )->( OrdSetFocus( nOrd ) )

   else

      lErrors     := .t.

   end if

   /*
   A¤adimos desde el fichero de situaiones
   */
	
	dbCreate( cTmpEst, aSqlStruct( aFacRecEst() ), cLocalDriver() )
   	dbUseArea( .t., cLocalDriver(), cTmpEst, cCheckArea( cDbfEst, @dbfTmpEst ), .f. )

  	if !NetErr()

  		( dbfTmpEst )->( ordCreate( cTmpEst, "nNumFac", "cSerFac + str( nNumFac ) + cSufFac + dtos( dFecSit )  + tFecSit", {|| Field->cSerFac + str( Field->nNumFac ) + Field->cSufFac + dtos( Field->dFecSit )  + Field->tFecSit } ) )
   	( dbfTmpEst )->( ordListAdd( cTmpEst ) )

    	if ( D():FacturasRectificativasSituaciones( nView ) )->( dbSeek( cFac ) )

        	while ( ( D():FacturasRectificativasSituaciones( nView ) )->cSerFac + Str( ( D():FacturasRectificativasSituaciones( nView ) )->nNumFac ) + ( D():FacturasRectificativasSituaciones( nView ) )->cSufFac == cFac ) .AND. ( D():FacturasRectificativasSituaciones( nView ) )->( !eof() ) 

            dbPass( D():FacturasRectificativasSituaciones( nView ), dbfTmpEst, .t. )
         
            ( D():FacturasRectificativasSituaciones( nView ) )->( dbSkip() )

         end while

  	   end if

  	   ( dbfTmpEst )->( dbGoTop() )

  	else

      lErrors     := .t.

  	end if

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
Finaliza la transacción de datos
*/

STATIC FUNCTION EndTrans( aTmp, aGet, oBrw, oBrwDet, oBrwPgo, aNumAlb, nMode, oDlg, oFld )

   local n
   local cSerFac
   local nNumFac
   local cSufFac
   local dFecFac
   local oError
   local oBlock

   if empty( aTmp[ _CSERIE ] )
      aTmp[ _CSERIE ]   := "A"
   end if

   cSerFac              := aTmp[ _CSERIE  ]
   nNumFac              := aTmp[ _NNUMFAC ]
   cSufFac              := aTmp[ _CSUFFAC ]
   dFecFac              := aTmp[ _DFECFAC ]

   if !lValidaOperacion( aTmp[ _DFECFAC ] )
      Return .f.
   end if

   if !lValidaSerie( aTmp[ _CSERIE ] )
      Return .f.
   end if

   if ( nMode == APPD_MODE .or. nMode == DUPL_MODE ) .and. empty( aTmp[ _CNUMFAC ] )
      MsgStop( "Debe de indicar la factura que quiere rectificar." )
      aGet[ _CNUMFAC ]:SetFocus()
      return .f.
   end if

   if !( isAviableClient( nView ) )
      return .f.
   end if

   if empty( aTmp[ _CNOMCLI ] )
      msgStop( "Nombre de cliente no puede estar vacio." )
      aGet[ _CNOMCLI ]:SetFocus()
      return .f.
   end if

   if empty( aTmp[ _CDIRCLI ] )
      msgStop( "Domicilio de cliente no puede estar vacio." )
      aGet[ _CDIRCLI ]:SetFocus()
      return .f.
   end if

   if empty( aTmp[ _CDNICLI ] )
      msgStop( "D.N.I. / C.I.F. de cliente no puede estar vacio." )
      aGet[ _CDNICLI ]:SetFocus()
      return .f.
   end if

   if empty( aTmp[ _CCODALM ] )
      msgStop( "Almacén no puede estar vacio." )
      aGet[ _CCODALM ]:SetFocus()
      return .f.
   end if

   if empty( aTmp[ _CCODPAGO ] )
      msgStop( "Forma de pago no puede estar vacia." )
      aGet[ _CCODPAGO ]:SetFocus()
      return .f.
   end if

   if empty( aTmp[ _CDIVFAC ] )
      MsgStop( "No puede almacenar documento sin código de divisa." )
      aGet[ _CDIVFAC ]:SetFocus()
      return .f.
   end if

   if empty( aTmp[ _CCODAGE ] ) .and. lRecogerAgentes()
      msgStop( "Agente no puede estar vacio." )
      aGet[ _CCODAGE ]:SetFocus()
      return .f.
   end if

   if empty( aTmp[ _CCODOBR ] ) .and. lObras()
      MsgStop( "Debe de introducir una obra." )
      aGet[ _CCODOBR ]:SetFocus()
      return .f.
   end if

   if empty( aTmp[ _CMOTREC ] )
      MsgStop( "Debe indicar un motivo para la factura rectificativa." )
      oFld:SetOption( 2 )
      aGet[ _CMOTREC ]:SetFocus()
      return .f.
   end if

   if empty( aTmp[ _CCAUREC ] )
      MsgStop( "Debe indicar una causa por la que se emite la factura rectificativa." )
      oFld:SetOption( 2 )
      aGet[ _CCAUREC ]:SetFocus()
      return .f.
   end if

   if ( dbfTmpLin )->( eof() )
      MsgStop( "No puede almacenar un documento sin lineas." )
      return .f.
   end if

   if lPasNil() .and. ( nMode == APPD_MODE .or. nMode == DUPL_MODE )

      ( dbfTmpLin )->( dbGoTop() )
      while !( dbfTmpLin )->( eof() )

         if !( dbfTmpLin )->lControl .and. ( dbfTmpLin )->nPreUnit == 0 .and. !( dbfTmpLin )->lKitPrc
            if !ApoloMsgNoYes( "El artículo " + Rtrim( ( dbfTmpLin )->cRef ) + " - " + Rtrim( Descrip( dbfTmpLin ) ) + " no esta valorado.", "¿Desea continuar archivando la factura?" )
               return .f.
            end if
         end if

         ( dbfTmpLin )->( dbSkip() )

      end while

   end if

   /*
   Para q nadie toque mientras grabamos----------------------------------------
   */

   CursorWait()

   oDlg:Disable()

   oMsgText( "Archivando" )

   BeginTransaction()

   aTmp[ _DFECCRE ]     := GetSysDate()
   aTmp[ _CTIMCRE ]     := Time()
   aTmp[ _NTARIFA ] 	   := oGetTarifa:getTarifa()

   TComercio:resetProductsToUpdateStocks()

   ( dbfTmpLin )->( dbClearFilter() )

   /*
   Primero hacer el RollBack---------------------------------------------------
   */

   do case
   case isAppendOrDuplicateMode( nMode )

		/*
      Obtenemos el nuevo numero de la factura----------------------------------
		*/

      nNumFac           := nNewDoc( cSerFac, D():FacturasRectificativas( nView ), "nFacRec", , dbfCount )
      aTmp[ _NNUMFAC ]  := nNumFac
      cSufFac           := retSufEmp()
      aTmp[ _CSUFFAC ]  := cSufFac
      aTmp[ _LIMPALB ]  := !empty( aNumAlb )

   case isEditMode( nMode )

      while ( D():FacturasRectificativasLineas( nView ) )->( dbSeek( cSerFac + Str( nNumFac ) + cSufFac ) ) .and. !( D():FacturasRectificativasLineas( nView ) )->( eof() )

         TComercio:appendProductsToUpadateStocks( ( D():FacturasRectificativasLineas( nView ) )->cRef, nView )

         if dbLock( D():FacturasRectificativasLineas( nView ) )
            ( D():FacturasRectificativasLineas( nView ) )->( dbDelete() )
            ( D():FacturasRectificativasLineas( nView ) )->( dbUnLock() )
         end if

      end while

      /*
      Eliminamos las incidencias anteriores------------------------------------
      */

      while ( dbfFacRecI )->( dbSeek( cSerFac + Str( nNumFac ) + cSufFac ) ) .and. !( dbfFacRecI )->( eof() )
         if dbLock( dbfFacRecI )
            ( dbfFacRecI )->( dbDelete() )
            ( dbfFacRecI )->( dbUnLock() )
         end if
      end while

      /*
      Eliminamos las incidencias anteriores------------------------------------
      */

      while ( dbfFacRecD )->( dbSeek( cSerFac + Str( nNumFac ) + cSufFac ) ) .and. !( dbfFacRecD )->( eof() )
         if dbLock( dbfFacRecD )
            ( dbfFacRecD )->( dbDelete() )
            ( dbfFacRecD )->( dbUnLock() )
         end if
      end while

      /*
      Eliminamos las series----------------------------------------------------
      */

      while ( dbfFacRecS )->( dbSeek( cSerFac + Str( nNumFac ) + cSufFac ) ) .and. !( dbfFacRecS )->( eof() )
         if dbLock( dbfFacRecS )
            ( dbfFacRecS )->( dbDelete() )
            ( dbfFacRecS )->( dbUnLock() )
         end if
      end while

      /*
      Eliminamos los pagos anteriores------------------------------------------
      */

      while ( dbfFacCliP )->( dbSeek( cSerFac + Str( nNumFac ) + cSufFac ) .and. !( dbfFacCliP )->( eof() ) )
         if dbLock( dbfFacCliP )
            ( dbfFacCliP )->( dbDelete() )
            ( dbfFacCliP )->( dbUnLock() )
         end if
      end while

      /*
      Eliminamos las situaciones anteriores------------------------------------------
      */

      while ( D():FacturasRectificativasSituaciones( nView ) )->( dbSeek( cSerFac + str( nNumFac ) + cSufFac ) ) 
         if dbLock( D():FacturasRectificativasSituaciones( nView ) )
           ( D():FacturasRectificativasSituaciones( nView ) )->( dbDelete() )
           ( D():FacturasRectificativasSituaciones( nView ) )->( dbUnLock() )
         end if
      end while

   end case

   /*
   Actualizacion de riesgo-----------------------------------------------------
   */

   oMsgProgress()
   oMsgProgress():SetRange( 0, ( dbfTmpLin )->( LastRec() ) )

	/*
   Ahora escribimos en el fichero definitivo-----------------------------------
	*/

   ( dbfTmpLin )->( dbGoTop() )
   while ( dbfTmpLin )->( !eof() )

      ( dbfTmpLin )->nRegIva    := aTmp[ _NREGIVA ]

      if ( dbfTmpLin )->dFecFac != aTmp[ _DFECFAC ]
         ( dbfTmpLin )->dFecFac := aTmp[ _DFECFAC ]
      end if

      TComercio:appendProductsToUpadateStocks( ( dbfTmpLin )->cRef, nView )

      dbPass( dbfTmpLin, D():FacturasRectificativasLineas( nView ), .t., cSerFac, nNumFac, cSufFac )

      ( dbfTmpLin )->( dbSkip() )

      oMsgProgress():Deltapos(1)

   end while

   /*
   Ahora escribimos en el fichero definitivo de inicdencias--------------------
	*/

   ( dbfTmpInc )->( dbGoTop() )
   while ( dbfTmpInc )->( !eof() )
      dbPass( dbfTmpInc, dbfFacRecI, .t., cSerFac, nNumFac, cSufFac )
      ( dbfTmpInc )->( dbSkip() )
   end while

   /*
   Ahora escribimos en el fichero definitivo de documentos--------------------
	*/

   ( dbfTmpDoc )->( dbGoTop() )
   while ( dbfTmpDoc )->( !eof() )
      dbPass( dbfTmpDoc, dbfFacRecD, .t., cSerFac, nNumFac, cSufFac )
      ( dbfTmpDoc )->( dbSkip() )
   end while

   /*
   Ahora escribimos en el fichero definitivo de series--------------------
	*/

   ( dbfTmpSer )->( dbGoTop() )
   while ( dbfTmpSer )->( !eof() )
      dbPass( dbfTmpSer, dbfFacRecS, .t., cSerFac, nNumFac, cSufFac, dFecFac )
      ( dbfTmpSer )->( dbSkip() )
   end while

   /*
   Ahora escribimos en el fichero definitivo de pagos--------------------------
	*/

   ( dbfTmpPgo )->( dbGoTop() )
   while ( dbfTmpPgo )->( !eof() )

      if ( dbfTmpPgo )->cCodCli != aTmp[ _CCODCLI ]
         ( dbfTmpPgo )->cCodCli := aTmp[ _CCODCLI ]
      end if

      if ( dbfTmpPgo )->cNomCli != aTmp[ _CNOMCLI ]
         ( dbfTmpPgo )->cNomCli := aTmp[ _CNOMCLI ]
      end if


      if !empty( aTmp[ _CCENTROCOSTE ] )
         ( dbfTmpPgo )->cCtrCoste := aTmp[ _CCENTROCOSTE ]
      endif

      dbPass( dbfTmpPgo, dbfFacCliP, .t., cSerFac, nNumFac, cSufFac )

      ( dbfTmpPgo )->( dbSkip() )

   end while

   /*
   Escribimos en el fichero definitivo de Situaciones-------------------------
   */

   ( dbfTmpEst )->( dbgotop() )
	while ( dbfTmpEst )->( !eof() )
      dbPass( dbfTmpEst, D():FacturasRectificativasSituaciones( nView ), .t., cSerFac, nNumFac, cSufFac ) 
      ( dbfTmpEst )->( dbSkip() )
   end while

   /*
   Rellenamos  los campos de los totales---------------------------------------
   */

   aTmp[ _NTOTNET ]  := nTotNet
   aTmp[ _NTOTIVA ]  := nTotIva
   aTmp[ _NTOTREQ ]  := nTotReq
   aTmp[ _NTOTFAC ]  := nTotFac

   oDetCamposExtra:saveExtraField( aTmp[ _CSERIE ] + Str( aTmp[ _NNUMFAC ] ) + aTmp[ _CSUFFAC ], "" )

   /*
   Grabamos el registro--------------------------------------------------------
   */

   WinGather( aTmp, , D():FacturasRectificativas( nView ), , nMode )

   /*
   Actualizamos el estado de los albaranes de clientes-------------------------
   */

   if len( aNumAlb ) > 0
      for n := 1 to len( aNumAlb )
         if ( dbfAlbCliT )->( dbSeek( aNumAlb[n] ) )
            if dbLock( dbfAlbCliT )
               delRiesgo( nTotAlbCli( aNumAlb[ n ], dbfAlbCliT, dbfAlbCliL, dbfIva, dbfDiv ), ( dbfAlbCliT )->cCodCli, D():Clientes( nView ) )
               ( dbfAlbCliT )->lFacturado := .t.
               ( dbfAlbCliT )->cNumFac    := cSerFac + Str( nNumFac ) + cSufFac
               ( dbfAlbCliT )->( dbUnlock() )
            end if
         end if
      next
   end if

   CommitTransaction()

   /*
   Generar los pagos de las facturas-------------------------------------------
   */

   GenPgoFacRec( cSerFac + Str( nNumFac ) + cSufFac, D():FacturasRectificativas( nView ), D():FacturasRectificativasLineas( nView ), dbfFacCliP, D():Clientes( nView ), dbfFPago, dbfDiv, dbfIva, nMode )

   /*
   Comprobamos el estado de la factura-----------------------------------------
   */

   ChkLqdFacRec( nil, D():FacturasRectificativas( nView ), D():FacturasRectificativasLineas( nView ), dbfFacCliP, dbfIva, dbfDiv )

   /*
   Cerramos el dialogo---------------------------------------------------------
   */

   oMsgText()

   EndProgress()

   // actualiza el stock de prestashop-----------------------------------------

   TComercio:updateWebProductStocks()

   oDlg:Enable()
   oDlg:end( IDOK )

   CursorWE()

Return .t.

//------------------------------------------------------------------------//

Static Function KillTrans( oBrwDet, oBrwInc, oBrwPgo )

	/*
	Borramos los ficheros
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

RETURN NIL

//--------------------------------------------------------------------------//
/*
Crea los ficheros de la facturaci¢n
*/

STATIC FUNCTION CreateFiles( cPath, lReindex )

   DEFAULT lReindex  := .t.

   if !lExistTable( cPath + "FacRecT.DBF", cLocalDriver() )
      dbCreate( cPath + "FacRecT.DBF", aSqlStruct( aItmFacRec() ), cLocalDriver() )
   end if

   if !lExistTable( cPath + "FacRecL.DBF", cLocalDriver() )
      dbCreate( cPath + "FacRecL.DBF", aSqlStruct( aColFacRec() ), cLocalDriver() )
   end if

   if !lExistTable( cPath + "FacRecI.DBF", cLocalDriver() )
      dbCreate( cPath + "FacRecI.DBF", aSqlStruct( aIncFacRec() ), cLocalDriver() )
   end if

   if !lExistTable( cPath + "FacRecD.DBF", cLocalDriver() )
      dbCreate( cPath + "FacRecD.DBF", aSqlStruct( aFacRecDoc() ), cLocalDriver() )
   end if

   if !lExistTable( cPath + "FacRecS.Dbf", cLocalDriver() )
      dbCreate( cPath + "FacRecS.Dbf", aSqlStruct( aSerFacRec() ), cLocalDriver() )
   end if

   if !lExistTable( cPath + "FacRecE.Dbf", cLocalDriver() )
      dbCreate( cPath + "FacRecE.Dbf", aSqlStruct( aFacRecEst() ), cLocalDriver() )
   end if

   if lReindex
      rxFacRec( cPath, , cLocalDriver() )
   end if

RETURN NIL

//---------------------------------------------------------------------------//

static function lGenFacRec( oBrw, oBtn, nDevice )

   local bAction

   DEFAULT nDevice   := IS_PRINTER

   if empty( oBtn )
      return nil
   end if

   if !( D():Documentos( nView ) )->( dbSeek( "FR" ) )

         DEFINE BTNSHELL RESOURCE "GC_DOCUMENT_WHITE_" OF oWndBrw ;
            NOBORDER ;
            ACTION   ( msgStop( "No hay facturas rectificativas de clientes predefinidas" ) );
            TOOLTIP  "No hay documentos" ;
            HOTKEY   "N";
            FROM     oBtn ;
            CLOSED ;
            LEVEL    ACC_EDIT

   ELSE

      WHILE ( D():Documentos( nView ) )->CTIPO == "FR" .AND. !( D():Documentos( nView ) )->( eof() )

         bAction  := bGenFacRec( nDevice, "Imprimiendo facturas rectificativas de clientes", ( D():Documentos( nView ) )->CODIGO )

         oWndBrw:NewAt( "gc_document_white_", , , bAction, Rtrim( ( D():Documentos( nView ) )->cDescrip ) , , , , , oBtn )

         ( D():Documentos( nView ) )->( dbSkip() )

      END DO

   END IF

   SysRefresh()

return nil

//---------------------------------------------------------------------------//

static function bGenFacRec( nDevice, cTitle, cCodDoc )

   local bGen
   local nDev  := by( nDevice )
   local cTit  := by( cTitle  )
   local cCod  := by( cCodDoc )

   if nDev == IS_PRINTER
      bGen     := {|| GenFacRec( nDev, cTit, cCod ) }
   else
      bGen     := {|| GenFacRec( nDev, cTit, cCod ) }
   end if

return ( bGen )

//---------------------------------------------------------------------------//

static function QuiFacRec()

   local nOrdAnt
   local cSerDoc
   local nNumDoc
   local cSufDoc

   if ( D():FacturasRectificativas( nView ) )->lCloFac .and. !oUser():lAdministrador()
      msgStop( "Solo puede eliminar facturas cerradas los administradores." )
      return .f.
   end if

   cSerDoc     := ( D():FacturasRectificativas( nView ) )->cSerie
   nNumDoc     := ( D():FacturasRectificativas( nView ) )->nNumFac
   cSufDoc     := ( D():FacturasRectificativas( nView ) )->cSufFac

   // Eliminamos las lineas----------------------------------------------------

   TComercio:resetProductsToUpdateStocks()

   nOrdAnt     := ( D():FacturasRectificativasLineas( nView ) )->( ordsetfocus( "nNumFac" ) )
   while ( D():FacturasRectificativasLineas( nView ) )->( dbseek( cSerDoc + Str( nNumDoc ) + cSufDoc ) ) .and. !( D():FacturasRectificativasLineas( nView ) )->( eof() )

      TComercio:appendProductsToUpadateStocks( ( D():FacturasRectificativasLineas( nView ) )->cRef, nView )

      if dbDialogLock( D():FacturasRectificativasLineas( nView ) )
         ( D():FacturasRectificativasLineas( nView ) )->( dbdelete() )
         ( D():FacturasRectificativasLineas( nView ) )->( dbunlock() )
      end if

      sysrefresh()

      ( D():FacturasRectificativasLineas( nView ) )->( dbskip() )

   end do
   ( D():FacturasRectificativasLineas( nView ) )->( ordsetfocus( nOrdAnt ) )

   TComercio:updateWebProductStocks()

   // Eliminamos los pagos-----------------------------------------------------

   nOrdAnt     := ( dbfFacCliP )->( ordsetfocus( "rNumFac" ) )
   while ( dbfFacCliP )->( dbSeek( cSerDoc + Str( nNumDoc ) + cSufDoc ) ) .and. !( dbfFacCliP )->( eof() )

      if dbDialogLock( dbfFacCliP )
         ( dbfFacCliP )->( dbdelete() )
         ( dbfFacCliP )->( dbunlock() )
      end if

      sysrefresh()

      ( dbfFacCliP )->( dbSkip() )

   end do

   ( dbfFacCliP )->( ordsetfocus( nOrdAnt ) )

   /*
   Eliminamos las incidencias--------------------------------------------------
   */

   nOrdAnt     := ( dbfFacRecI )->( ordsetfocus( "nNumFac" ) )
   while ( dbfFacRecI )->( dbseek( cSerDoc + Str( nNumDoc ) + cSufDoc ) ) .and. !( dbfFacRecI )->( eof() )

      if dbDialogLock( dbfFacRecI )
         ( dbfFacRecI )->( dbdelete() )
         ( dbfFacRecI )->( dbunlock() )
      end if

      sysrefresh()

      ( dbfFacRecI )->( dbskip() )

   end do

   ( dbfFacRecI )->( ordsetfocus( nOrdAnt ) )

   /*
   Eliminamos los documentos---------------------------------------------------
   */

   nOrdAnt     := ( dbfFacRecD )->( ordsetfocus( "nNumFac" ) )
   while ( dbfFacRecD )->( dbseek( cSerDoc + Str( nNumDoc ) + cSufDoc ) ) .and. !( dbfFacRecD )->( eof() )

      if dbDialogLock( dbfFacRecD )
         ( dbfFacRecD )->( dbdelete() )
         ( dbfFacRecD )->( dbunlock() )
      end if

      sysrefresh()

      ( dbfFacRecD )->( dbskip() )

   end do

   ( dbfFacRecD )->( ordsetfocus( nOrdAnt ) )

   /*
   Eliminamos las series-------------------------------------------------------
   */

   nOrdAnt     := ( dbfFacRecS )->( OrdSetFocus( "nNumFac" ) )
   while ( dbfFacRecS )->( dbSeek( cSerDoc + Str( nNumDoc ) + cSufDoc ) ) .and. !( dbfFacRecS )->( eof() )

      if dbDialogLock( dbfFacRecS )
         ( dbfFacRecS )->( dbDelete() )
         ( dbfFacRecS )->( dbUnLock() )
      end if

      sysrefresh()

      ( dbfFacRecS )->( dbSkip() )

   end do

   ( dbfFacRecS )->( OrdSetFocus( nOrdAnt ) )

   /*
   Recuperamos contadores------------------------------------------------------
   */
   
   if uFieldEmpresa( "LRECNUMFAC" )
		nPutDoc( cSerDoc, nNumDoc, cSufDoc, D():FacturasRectificativas( nView ), "nFacRec", , dbfCount )
   end if

   /*
   Refresh---------------------------------------------------------------------
   */

   if oWndBrw != nil
      oWndBrw:Refresh()
   end if

return .t.

//--------------------------------------------------------------------------//

STATIC FUNCTION aGetSelRec( oBrw, bAction, cTitle, lHide1, cTitle1, lHide2, cTitle2, bPreAction, bPostAction )

   local oDlg
   local oRad
   local nRad        := 1
   local aRet        := {}
   local oTree
   local oChk1
   local oChk2
   local lChk1       := .t.
   local lChk2       := .t.
   local nRecno      := ( D():FacturasRectificativas( nView ) )->( Recno() )
   local nOrdAnt     := ( D():FacturasRectificativas( nView ) )->( OrdSetFocus( 1 ) )
   local oSerIni
   local oSerFin
   local cSerIni     := ( D():FacturasRectificativas( nView ) )->cSerie
   local cSerFin     := ( D():FacturasRectificativas( nView ) )->cSerie
   local oDocIni
   local oDocFin
   local nDocIni     := ( D():FacturasRectificativas( nView ) )->nNumFac
   local nDocFin     := ( D():FacturasRectificativas( nView ) )->nNumFac
   local oSufIni
   local oSufFin
   local cSufIni     := ( D():FacturasRectificativas( nView ) )->cSufFac
   local cSufFin     := ( D():FacturasRectificativas( nView ) )->cSufFac
   local oMtrInf
   local nMtrInf
   local lFechas     := .t.
   local dDesde      := CtoD( "01/01/" + Str( Year( Date() ) ) )
   local dHasta      := Date()
   local oImageList
   local oBtnCancel

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
      ACTION   ( dbFirst( D():FacturasRectificativas( nView ), "nNumFac", oDocIni, cSerIni, "nNumFac" ) )

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
      ACTION   ( dbLast( D():FacturasRectificativas( nView ), "nNumFac", oDocFin, cSerFin, "nNumFac" ) )

   REDEFINE GET oDocIni VAR nDocIni;
      ID       120 ;
		PICTURE 	"999999999" ;
      SPINNER ;
      WHEN     ( nRad == 2 ) ;
      OF       oDlg

   REDEFINE GET oDocFin VAR nDocFin;
      ID       130 ;
		PICTURE 	"999999999" ;
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
		OF 		oDlg

   REDEFINE CHECKBOX oChk2 VAR lChk2 ;
      ID       180 ;
		OF 		oDlg

   /*
   Rango de fechas-------------------------------------------------------------
   */

   REDEFINE CHECKBOX lFechas ;
      ID       300 ;
		OF 		oDlg

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
      PROMPT   "Proceso" ;
      ID       200 ;
      OF       oDlg

   oMtrInf:SetTotal( ( D():FacturasRectificativas( nView ) )->( OrdKeyCount() ) )

   REDEFINE BUTTON ;
      ID       IDOK ;
		OF 		oDlg ;
      ACTION   ( MakSelRec( bAction, bPreAction, bPostAction, cSerIni + Str( nDocIni, 9 ) + cSufIni, cSerFin + Str( nDocFin, 9 ) + cSufFin, nRad, lChk1, lChk2, lFechas, dDesde, dHasta, oDlg, oTree, oBrw, oMtrInf, oBtnCancel ) )

   REDEFINE BUTTON oBtnCancel ;
      ID       IDCANCEL ;
		OF 		oDlg ;
      CANCEL ;
      ACTION   ( oDlg:end() )

   oDlg:bStart := {|| StartGetSelRec( oBrw, oRad, oChk1, oChk2, oSerIni, oSerFin, oDocIni, oDocFin, oSufIni, oSufFin, lHide1, lHide2, cTitle1, cTitle2 ) }

   oDlg:AddFastKey( VK_F5, {|| MakSelRec( bAction, bPreAction, bPostAction, cSerIni + Str( nDocIni, 9 ) + cSufIni, cSerFin + Str( nDocFin, 9 ) + cSufFin, nRad, lChk1, lChk2, lFechas, dDesde, dHasta, oDlg, oTree, oBrw, oMtrInf, oBtnCancel ) } )

   ACTIVATE DIALOG oDlg ;
      CENTER ;
      ON INIT  ( oTree:SetImageList( oImageList ) )

   ( D():FacturasRectificativas( nView ) )->( ordSetFocus( nOrdAnt ) )
   ( D():FacturasRectificativas( nView ) )->( dbGoTo( nRecNo ) )

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

   if !empty( oItemTree ) .and. !empty( oItemTree:bAction )
      Eval( oItemTree:bAction )
   end if

RETURN NIL

//---------------------------------------------------------------------------//

Static Function MakSelRec( bAction, bPreAction, bPostAction, cDocIni, cDocFin, nRad, lChk1, lChk2, lFechas, dDesde, dHasta, oDlg, oTree, oBrw, oMtrInf, oBtnCancel )

   local n        := 0
   local nPos     := 0
   local nRec     := ( D():FacturasRectificativas( nView ) )->( Recno() )
   local aPos
   local lRet
   local lPre
   local lWhile   := .t.

   /*
   Preparamos la pantalla para mostrar la simulación---------------------------
   */

   if lChk1
      aPos        := { 0, 0 }
      ClientToScreen( oDlg:hWnd, aPos )
      oDlg:Move( aPos[ 1 ] - 26, aPos[ 2 ] - 510 )
   end if

   /*
   Desabilitamos el dialogo para iniciar el proceso----------------------------
   */

   oDlg:Disable()

   oTree:Enable()
   oTree:DeleteAll()

   oBtnCancel:bAction   := {|| lWhile := .f. }
   oBtnCancel:Enable()

   if !empty( bPreAction )
      lPre              := Eval( bPreAction )
   end if

   if !IsLogic( lPre ) .or. lPre

      if nRad == 1

         for each nPos in ( oBrw:oBrw:aSelected )

            ( D():FacturasRectificativas( nView ) )->( dbGoTo( nPos ) )

            if lFechas .or.( ( D():FacturasRectificativas( nView ) )->dFecFac >= dDesde .and. ( D():FacturasRectificativas( nView ) )->dFecFac <= dHasta )

               lRet  := Eval( bAction, lChk1, lChk2, oTree, D():FacturasRectificativas( nView ), D():FacturasRectificativasLineas( nView ) )

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

         ( D():FacturasRectificativas( nView ) )->( dbSeek( cDocIni, .t. ) )

         while ( lWhile )                                                                                      .and. ;
               ( D():FacturasRectificativas( nView ) )->cSerie + Str( ( D():FacturasRectificativas( nView ) )->nNumFac, 9 ) + ( D():FacturasRectificativas( nView ) )->cSufFac >= cDocIni .and. ;
               ( D():FacturasRectificativas( nView ) )->cSerie + Str( ( D():FacturasRectificativas( nView ) )->nNumFac, 9 ) + ( D():FacturasRectificativas( nView ) )->cSufFac <= cDocFin .and. ;
               !( D():FacturasRectificativas( nView ) )->( eof() )

            if lFechas .or.( ( D():FacturasRectificativas( nView ) )->dFecFac >= dDesde .and. ( D():FacturasRectificativas( nView ) )->dFecFac <= dHasta )

               lRet  := Eval( bAction, lChk1, lChk2, oTree, D():FacturasRectificativas( nView ), D():FacturasRectificativasLineas( nView ) )

               if IsFalse( lRet )
                  exit
               end if

            end if

            oMtrInf:Set( ++n )

            ( D():FacturasRectificativas( nView ) )->( dbSkip() )

            SysRefresh()

         end do

      end if

      if !empty( bPostAction )
         Eval( bPostAction )
      end if

   end if

   oMtrInf:Set( ( D():FacturasRectificativas( nView ) )->( OrdKeyCount() ) )

   ( D():FacturasRectificativas( nView ) )->( dbGoTo( nRec ) )

   if lChk1
      WndCenter( oDlg:hWnd )
   end if

   oBtnCancel:bAction   := {|| oDlg:End() }

   oDlg:Enable()

   if oBrw != nil
      oBrw:Refresh()
   end if

RETURN ( lRet )

//---------------------------------------------------------------------------//

STATIC FUNCTION DelSerie( oWndBrw )

	local oDlg
   local oSerIni
   local oSerFin
   local oTxtDel
   local nTxtDel     := 0
   local nRecno      := ( D():FacturasRectificativas( nView ) )->( Recno() )
   local nOrdAnt     := ( D():FacturasRectificativas( nView ) )->( OrdSetFocus( 1 ) )
   local oDesde      := TDesdeHasta():Init( ( D():FacturasRectificativas( nView ) )->cSerie, ( D():FacturasRectificativas( nView ) )->nNumFac, ( D():FacturasRectificativas( nView ) )->cSufFac, GetSysDate() )
   local lCancel     := .f.
   local oBtnAceptar
   local oBtnCancel

   DEFINE DIALOG oDlg ;
      RESOURCE "DELSERDOC" ;
      TITLE    "Eliminar series de facturas rectificativas" ;
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

   REDEFINE BUTTON oBtnAceptar ;
      ID       IDOK ;
		OF 		oDlg ;
      ACTION   ( DelStart( oDesde, oDlg, oBtnAceptar, oBtnCancel, oTxtDel, @lCancel ) )

   REDEFINE BUTTON oBtnCancel ;
      ID       IDCANCEL ;
		OF 		oDlg ;
      CANCEL ;
      ACTION   ( lCancel := .t., oDlg:end() )

   REDEFINE APOLOMETER oTxtDel VAR nTxtDel ;
      ID       160 ;
      NOPERCENTAGE ;
      TOTAL    ( D():FacturasRectificativas( nView ) )->( OrdKeyCount() ) ;
      OF       oDlg

   ACTIVATE DIALOG oDlg CENTER VALID ( lCancel )

   ( D():FacturasRectificativas( nView ) )->( dbGoTo( nRecNo ) )
   ( D():FacturasRectificativas( nView ) )->( ordSetFocus( nOrdAnt ) )

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

      nOrd              := ( D():FacturasRectificativas( nView ) )->( OrdSetFocus( "nNumFac" ) )

      ( D():FacturasRectificativas( nView ) )->( dbSeek( oDesde:cNumeroInicio(), .t. ) )
      while !lCancel .and. ( D():FacturasRectificativas( nView ) )->( !eof() )

         if ( D():FacturasRectificativas( nView ) )->cSerie  >= oDesde:cSerieInicio  .and.;
            ( D():FacturasRectificativas( nView ) )->cSerie  <= oDesde:cSerieFin     .and.;
            ( D():FacturasRectificativas( nView ) )->nNumFac >= oDesde:nNumeroInicio .and.;
            ( D():FacturasRectificativas( nView ) )->nNumFac <= oDesde:nNumeroFin    .and.;
            ( D():FacturasRectificativas( nView ) )->cSufFac >= oDesde:cSufijoInicio .and.;
            ( D():FacturasRectificativas( nView ) )->cSufFac <= oDesde:cSufijoFin

            ++nDeleted

            oTxtDel:cText  := "Eliminando : " + ( D():FacturasRectificativas( nView ) )->cSerie + "/" + alltrim( Str( ( D():FacturasRectificativas( nView ) )->nNumFac ) ) + "/" + ( D():FacturasRectificativas( nView ) )->cSufFac

            WinDelRec( nil, D():FacturasRectificativas( nView ), {|| QuiFacRec() } )

         else

            ( D():FacturasRectificativas( nView ) )->( dbSkip() )

         end if

         ++nProcesed

         oTxtDel:Set( nProcesed )

      end do

      ( D():FacturasRectificativas( nView ) )->( OrdSetFocus( nOrd ) )

   else

      nOrd              := ( D():FacturasRectificativas( nView ) )->( OrdSetFocus( "dFecFac" ) )

      ( D():FacturasRectificativas( nView ) )->( dbSeek( oDesde:dFechaInicio, .t. ) )
      while !lCancel .and. ( D():FacturasRectificativas( nView ) )->( !eof() )

         if ( D():FacturasRectificativas( nView ) )->dFecFac >= oDesde:dFechaInicio  .and.;
            ( D():FacturasRectificativas( nView ) )->dFecFac <= oDesde:dFechaFin

            ++nDeleted

            oTxtDel:cText  := "Eliminando : " + ( D():FacturasRectificativas( nView ) )->cSerie + "/" + alltrim( Str( ( D():FacturasRectificativas( nView ) )->nNumFac ) ) + "/" + ( D():FacturasRectificativas( nView ) )->cSufFac

            WinDelRec( nil, D():FacturasRectificativas( nView ), {|| QuiFacRec() } )

         else

            ( D():FacturasRectificativas( nView ) )->( dbSkip() )

         end if

         ++nProcesed

         oTxtDel:Set( nProcesed )

      end do

      ( D():FacturasRectificativas( nView ) )->( OrdSetFocus( nOrd ) )

   end if

   lCancel              := .t.

   oBtnAceptar:Show()

   if lCancel
      msgStop( "Total de registros borrados : " + Str( nDeleted ), "Proceso cancelado" )
   else
      msgInfo( "Total de registros borrados : " + Str( nDeleted ), "Proceso finalizado" )
   end if

RETURN ( oDlg:End() )

//---------------------------------------------------------------------------//

static function RecFacRec( aTmpFac )

   local nDtoAge  := 0
   local nImpAtp  := 0
   local nImpOfe  := 0
   local cCodFam
   local nRecno
   local hAtipica

   if !ApoloMsgNoYes(  "¡Atención!,"                                      + CRLF + ;
                  "todos los precios se recalcularán en función de"  + CRLF + ;
                  "los valores en las bases de datos.",;
                  "¿Desea proceder?" )
      return nil
   end if

   nRecno         := ( dbfTmpLin )->( RecNo() )

   ( dbfTmpLin )->( dbGotop() )
   ( D():Articulos( nView ) )->( ordSetFocus( "CODIGO" ) )

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

         ( dbfTmpLin )->nPreUnit    := nRetPreArt( ( dbfTmpLin )->nTarLin, aTmpFac[ _CDIVFAC ], aTmpFac[ _LIVAINC ], D():Articulos( nView ), dbfDiv, dbfKit, dbfIva, , , oNewImp )

         /*
         Cargamos simpre los puntos verdes
         */

         ( dbfTmpLin )->nPntVer  := ( D():Articulos( nView ) )->nPntVer1

         /*
         Linea por contadores--------------------------------------------------
         */

         ( dbfTmpLin )->nCtlStk     := ( D():Articulos( nView ) )->nCtlStock
         ( dbfTmpLin )->nCosDiv     := nCosto( nil, D():Articulos( nView ), dbfKit )
         ( dbfTmpLin )->nPvpRec     := ( D():Articulos( nView ) )->PvpRec

         // Chequeamos situaciones especiales----------------------------------

         cCodFam                    := ( D():Articulos( nView ) )->Familia

         // Precios en tarifas-------------------------------------------------

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
            Descuento de promoci¢n, esta funci¢n comprueba si existe y si es---
            asi devuelve el descunto de la promoción---------------------------
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

         nImpOfe     := nDtoOferta( ( dbfTmpLin )->cRef, aTmpFac[ _CCODCLI ], aTmpFac[ _CCODGRP ], ( dbfTmpLin )->nUniCaja, aTmpFac[ _DFECFAC ], dbfOferta, ( dbfTmpLin )->cCodPr1, ( dbfTmpLin )->cCodPr2, ( dbfTmpLin )->cValPr1, ( dbfTmpLin )->cValPr2 )
         if nImpOfe  != 0
            ( dbfTmpLin )->nDtoPrm  := nImpOfe
         end if

      end if

      ( dbfTmpLin )->( dbSkip() )

   end while

   ( dbfTmpLin )->( dbGoTo( nRecno ) )

return nil

//----------------------------------------------------------------------------//

Static Function EdtRecMenu( aTmp, oDlg )

   MENU oMenu

      MENUITEM    "&1. Rotor"

         MENU 

         	MENUITEM    "&1. Campos extra [F9]";
               MESSAGE  "Mostramos y rellenamos los campos extra para la familia" ;
               RESOURCE "gc_form_plus2_16" ;
               ACTION   ( oDetCamposExtra:Play( space(1) ) )

            MENUITEM    "&2. Modificar cliente";
               MESSAGE  "Modifica la ficha del cliente" ;
               RESOURCE "gc_user_16" ;
               ACTION   ( if( !empty( aTmp[ _CCODCLI ] ), EdtCli( aTmp[ _CCODCLI ] ), MsgStop( "Código de cliente vacío" ) ) )

            MENUITEM    "&3. Modificar cliente contactos";
               MESSAGE  "Modifica la ficha del cliente en contactos" ;
               RESOURCE "gc_user_16" ;
               ACTION   ( if( !empty( aTmp[ _CCODCLI ] ), EdtCli( aTmp[ _CCODCLI ], , 5 ), MsgStop( "Código de cliente vacío" ) ) )              

            MENUITEM    "&4. Informe de cliente";
               MESSAGE  "Informe de cliente" ;
               RESOURCE "Info16" ;
               ACTION   ( if( !empty( aTmp[ _CCODCLI ] ), InfCliente( aTmp[ _CCODCLI ] ), MsgStop( "Código de cliente vacío" ) ) );

            MENUITEM    "&5. Modificar dirección";
               MESSAGE  "Modifica ficha de la dirección" ;
               RESOURCE "gc_worker2_16" ;
               ACTION   ( if( !empty( aTmp[ _CCODOBR ] ), EdtObras( aTmp[ _CCODCLI ], aTmp[ _CCODOBR ], dbfObrasT ), MsgStop( "Código de obra vacío" ) ) );

         ENDMENU

   ENDMENU

   oDlg:SetMenu( oMenu )

RETURN ( oMenu )

//---------------------------------------------------------------------------//

Static Function EndEdtRecMenu()

Return( oMenu:End() )

//---------------------------------------------------------------------------//

Static Function nEstadoIncidencia( cNumFac )

   local nEstado  := 0

   if ( dbfFacRecI )->( dbSeek( cNumFac ) )

      while ( dbfFacRecI )->cSerie + Str( ( dbfFacRecI )->nNumFac ) + ( dbfFacRecI )->cSufFac == cNumFac .and. !( dbfFacRecI )->( Eof() )

         if ( dbfFacRecI )->lListo
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

         ( dbfFacRecI )->( dbSkip() )

      end while

   end if

Return ( nEstado )

//---------------------------------------------------------------------------//

STATIC FUNCTION cFacCli( aGet, aTmp, oBrw, oBrwiva, nMode )

   local nOption     := 0
   local aFacCliT
   local aFacCliL
   local cFactura    := aGet[ _CNUMFAC ]:varGet()

   if nMode != APPD_MODE .or. empty( cFactura )
      RETURN .T.
   end if

   aFacCliT          := aGetStatus( dbfFacCliT, .t. )
   aFacCliL          := aGetStatus( dbfFacCliL, .t. )

   if ( dbfFacCliT )->( dbSeek( cFactura ) )

      aGet[ _CCODCLI ]:cText( (dbfFacCliT)->cCodCli )
      aGet[ _CCODCLI ]:bWhen    := {|| .f. }
      aGet[ _CCODCLI ]:lValid()

      aGet[ _CNOMCLI ]:cText( ( dbfFacCliT )->cNomCli )
      aGet[ _CDIRCLI ]:cText( ( dbfFacCliT )->cDirCli )
      aGet[ _CPOBCLI ]:cText( ( dbfFacCliT )->cPobCli )
      aGet[ _CPRVCLI ]:cText( ( dbfFacCliT )->cPrvCli )
      aGet[ _CPOSCLI ]:cText( ( dbfFacCliT )->cPosCli )
      aGet[ _CDNICLI ]:cText( ( dbfFacCliT )->cDniCli )

      aGet[ _CCODALM ]:cText( ( dbfFacCliT )->cCodAlm )
      aGet[ _CCODALM ]:lValid()

      aGet[ _CCODCAJ ]:cText( ( dbfFacCliT )->cCodCaj )
      aGet[ _CCODCAJ ]:lValid()

      aGet[ _CCODPAGO]:cText( ( dbfFacCliT )->cCodPago )
      aGet[ _CCODPAGO]:lValid()

      aGet[ _CCODAGE ]:cText( ( dbfFacCliT )->cCodAge )
      aGet[ _CCODAGE ]:lValid()

      aGet[ _CCODTAR ]:cText( ( dbfFacCliT )->cCodTar )
      aGet[ _CCODTAR ]:lValid()

      aGet[ _CCODRUT ]:cText( ( dbfFacCliT )->cCodRut )
      aGet[ _CCODRUT ]:lValid()

      aGet[ _CCODOBR ]:cText( ( dbfFacCliT )->cCodObr )
      aGet[ _CCODOBR ]:lValid()

      aGet[ _CCODTRN ]:cText( ( dbfFacCliT )->cCodTrn )
      aGet[ _CCODTRN ]:lValid()

      aGet[ _LRECARGO ]:Click( ( dbfFacCliT )->lRecargo )
      aGet[ _LOPERPV  ]:Click( ( dbfFacCliT )->lOperPv )

      aGet[ _LIVAINC ]:Click( ( dbfFacCliT )->lIvaInc )

      aGet[ _CBANCO  ]:cText( ( dbfFacCliT )->cBanco )
      aGet[ _CBANCO  ]:lValid()

      aGet[ _CPAISIBAN ]:cText( ( dbfFacCliT )->cPaisIBAN )
      aGet[ _CPAISIBAN ]:lValid()

      aGet[ _CCTRLIBAN ]:cText( ( dbfFacCliT )->cCtrlIBAN )
      aGet[ _CCTRLIBAN ]:lValid()

      aGet[ _CENTBNC ]:cText( ( dbfFacCliT )->cEntBnc )
      aGet[ _CENTBNC ]:lValid()

      aGet[ _CSUCBNC ]:cText( ( dbfFacCliT )->cSucBnc )
      aGet[ _CSUCBNC ]:lValid()

      aGet[ _CDIGBNC ]:cText( ( dbfFacCliT )->cDigBnc )
      aGet[ _CDIGBNC ]:lValid()

      aGet[ _CCTABNC ]:cText( ( dbfFacCliT )->cCtaBnc )
      aGet[ _CCTABNC ]:lValid()

      if !empty( ( dbfFacCliT )->cCtrCoste )
	      aGet[ _CCENTROCOSTE ]:cText( ( dbfFacCliT )->cCtrCoste )
	      aGet[ _CCENTROCOSTE ]:lValid()
      endif

      oGetTarifa:setTarifa( ( dbfFacCliT )->nTarifa )

      // Pasamos los comentarios-----------------------------------------------

      aGet[ _MCOMENT ]:cText( ( dbfFacCliT )->mComEnt )
      aTmp[ _MOBSERV ]  := ( dbfFacCliT )->mObsErv

      // Pasamos todos los descuentos------------------------------------------

      if empty( ( dbfFacCliT )->cDtoEsp )
         aGet[ _CDTOESP ]:cText( "General" )
      else
         aGet[ _CDTOESP ]:cText( ( dbfFacCliT )->cDtoEsp )
      end if

      if empty( ( dbfFacCliT )->cDpp )
         aGet[ _CDPP    ]:cText( "Pronto pago" )
      else
         aGet[ _CDPP    ]:cText( ( dbfFacCliT )->cDpp )
      end if

      aGet[ _NDTOESP ]:cText( ( dbfFacCliT )->nDtoEsp )
      aGet[ _NDPP    ]:cText( ( dbfFacCliT )->nDpp    )
      aGet[ _CDTOUNO ]:cText( ( dbfFacCliT )->cDtoUno )
      aGet[ _NDTOUNO ]:cText( ( dbfFacCliT )->nDtoUno )
      aGet[ _CDTODOS ]:cText( ( dbfFacCliT )->cDtoDos )
      aGet[ _NDTODOS ]:cText( ( dbfFacCliT )->nDtoDos )
      aGet[ _CMANOBR ]:cText( ( dbfFacCliT )->cManObr )
      aGet[ _NIVAMAN ]:cText( ( dbfFacCliT )->nIvaMan )
      aGet[ _NMANOBR ]:cText( ( dbfFacCliT )->nManObr )

      aTmp[ _CCODGRP ] := ( dbfFacCliT )->cCodGrp
      aTmp[ _LMODCLI ] := ( dbfFacCliT )->lModCli

      aTmp[ _LOPERPV ] := ( dbfFacCliT )->lOperPv

      // Comprobamos si la factura tiene lineas de detalle---------------------

      nOption           := nImportaLineas()

      if nOption >= 1

         CursorWait()

         if ( dbfFacCliL )->( dbSeek( cFactura ) )

            while ( ( dbfFacCliL )->cSerie + Str( ( dbfFacCliL )->nNumFac ) + ( dbfFacCliL )->cSufFac == cFactura )

               if !( dbfFacCliL )->lTotLin  .and. !( dbfFacCliL )->lControl

                  ( dbfTmpLin )->( dbAppend() )
                  ( dbfTmpLin )->cSerie     := " "
                  ( dbfTmpLin )->nNumFac    := 0
                  ( dbfTmpLin )->nNumLin    := ( dbfFacCliL )->nNumLin
                  ( dbfTmpLin )->nPosPrint  := ( dbfFacCliL )->nPosPrint
                  ( dbfTmpLin )->cRef       := ( dbfFacCliL )->cRef
                  ( dbfTmpLin )->cDetalle   := ( dbfFacCliL )->cDetalle
                  ( dbfTmpLin )->mLngDes    := ( dbfFacCliL )->mLngDes
                  ( dbfTmpLin )->mNumSer    := ( dbfFacCliL )->mNumSer
                  ( dbfTmpLin )->nPreUnit   := ( dbfFacCliL )->nPreUnit
                  ( dbfTmpLin )->nPntVer    := ( dbfFacCliL )->nPntVer
                  ( dbfTmpLin )->nImpTrn    := ( dbfFacCliL )->nImpTrn
                  ( dbfTmpLin )->nCanEnt    := ( dbfFacCliL )->nCanEnt
                  ( dbfTmpLin )->cUnidad    := ( dbfFacCliL )->cUnidad
                  ( dbfTmpLin )->nUniCaja   := if( nOption == 2, ( ( dbfFacCliL )->nUniCaja * -1 ), ( dbfFacCliL )->nUniCaja )
                  ( dbfTmpLin )->nDto       := ( dbfFacCliL )->nDto
                  ( dbfTmpLin )->nDtoPrm    := ( dbfFacCliL )->nDtoPrm
                  ( dbfTmpLin )->nIva       := ( dbfFacCliL )->nIva
                  ( dbfTmpLin )->nReq       := ( dbfFacCliL )->nReq
                  ( dbfTmpLin )->nPesoKg    := ( dbfFacCliL )->nPesoKg
                  ( dbfTmpLin )->cPesoKg    := ( dbfFacCliL )->cPesoKg
                  ( dbfTmpLin )->nComAge    := ( dbfFacCliL )->nComAge
                  ( dbfTmpLin )->dFecha     := ( dbfFacCliL )->dFecha
                  ( dbfTmpLin )->id_tipo_v  := ( dbfFacCliL )->id_tipo_v
                  ( dbfTmpLin )->cCodAlb    := ( dbfFacCliL )->cSerie + Str( ( dbfFacCliL )->nNumFac ) + ( dbfFacCliL )->cSufFac
                  ( dbfTmpLin )->lTotLin    := ( dbfFacCliL )->lTotLin
                  ( dbfTmpLin )->nDtoDiv    := ( dbfFacCliL )->nDtoDiv
                  ( dbfTmpLin )->nCtlStk    := ( dbfFacCliL )->nCtlStk
                  ( dbfTmpLin )->cAlmLin    := ( dbfFacCliL )->cAlmLin
                  ( dbfTmpLin )->lIvaLin    := ( dbfFacCliL )->lIvaLin
                  ( dbfTmpLin )->lImpLin    := ( dbfFacCliL )->lImpLin
                  ( dbfTmpLin )->nValImp    := ( dbfFacCliL )->nValImp
                  ( dbfTmpLin )->cCodImp    := ( dbfFacCliL )->cCodImp
                  ( dbfTmpLin )->cCodPr1    := ( dbfFacCliL )->cCodPr1
                  ( dbfTmpLin )->cCodPr2    := ( dbfFacCliL )->cCodPr2
                  ( dbfTmpLin )->cValPr1    := ( dbfFacCliL )->cValPr1
                  ( dbfTmpLin )->cValPr2    := ( dbfFacCliL )->cValPr2
                  ( dbfTmpLin )->nCosDiv    := ( dbfFacCliL )->nCosDiv
                  ( dbfTmpLin )->lKitArt    := ( dbfFacCliL )->lKitArt
                  ( dbfTmpLin )->lKitChl    := ( dbfFacCliL )->lKitChl
                  ( dbfTmpLin )->lKitPrc    := ( dbfFacCliL )->lKitPrc
                  ( dbfTmpLin )->lLote      := ( dbfFacCliL )->lLote
                  ( dbfTmpLin )->nLote      := ( dbfFacCliL )->nLote
                  ( dbfTmpLin )->cLote      := ( dbfFacCliL )->cLote
                  ( dbfTmpLin )->lControl   := ( dbfFacCliL )->lControl
                  ( dbfTmpLin )->lNotVta    := ( dbfFacCliL )->lNotVta
                  ( dbfTmpLin )->cCodTip    := ( dbfFacCliL )->cCodTip
                  ( dbfTmpLin )->mObsLin    := ( dbfFacCliL )->mObsLin
                  ( dbfTmpLin )->Descrip    := ( dbfFacCliL )->Descrip
                  ( dbfTmpLin )->cCodPrv    := ( dbfFacCliL )->cCodPrv
                  ( dbfTmpLin )->cImagen    := ( dbfFacCliL )->cImagen
                  ( dbfTmpLin )->cCodFam    := ( dbfFacCliL )->cCodFam
                  ( dbfTmpLin )->cGrpFam    := ( dbfFacCliL )->cGrpFam
                  ( dbfTmpLin )->nNumMed    := ( dbfFacCliL )->nNumMed
                  ( dbfTmpLin )->nMedUno    := ( dbfFacCliL )->nMedUno
                  ( dbfTmpLin )->nMedDos    := ( dbfFacCliL )->nMedDos
                  ( dbfTmpLin )->nMedTre    := ( dbfFacCliL )->nMedTre
                  ( dbfTmpLin )->lVolImp    := ( dbfFacCliL )->lVolImp
                  ( dbfTmpLin )->nVolumen   := ( dbfFacCliL )->nVolumen
                  ( dbfTmpLin )->lLinOfe    := ( dbfFacCliL )->lLinOfe
                  ( dbfTmpLin )->dFecCad    := ( dbfFacCliL )->dFecCad
                  ( dbfTmpLin )->nBultos    := ( dbfFacCliL )->nBultos
                  ( dbfTmpLin )->cFormato   := ( dbfFacCliL )->cFormato
                  ( dbfTmpLin )->dFecFac    := ( dbfFacCliL )->dFecFac
                  ( dbfTmpLin )->tFecfac    := ( dbfFacCliL )->tFecfac
                  ( dbfTmpLin )->cCtrCoste  := ( dbfFacCliL )->cCtrCoste
                  ( dbfTmpLin )->nTarLin 	  := ( dbfFacCliL )->nTarLin
                  ( dbfTmpLin )->cObrLin    := ( dbfFacCliL )->cCodObr
                  ( dbfTmpLin )->cCtrCoste  := ( dbfFacCliL )->cCtrCoste
                  ( dbfTmpLin )->cTipCtr    := ( dbfFacCliL )->cTipCtr
                  ( dbfTmpLin )->cTerCtr    := ( dbfFacCliL )->cTerCtr

               end if

               ( dbfFacCliL )->( dbSkip() )

            end while

         else

            MsgStop( "La factura no contiene líneas de detalle." )

         end if

         ( dbfTmpLin )->( dbGoTop() )

         // Pasamos todas las series-------------------------------------------

         if ( dbfFacCliS )->( dbSeek( cFactura ) )

            while ( dbfFacCliS )->cSerFac + Str( ( dbfFacCliS )->nNumFac ) + ( dbfFacCliS )->cSufFac == cFactura .and. !( dbfFacCliS )->( Eof() )

               ( dbfTmpSer )->( dbAppend() )
               ( dbfTmpSer )->nNumLin  := ( dbfFacCliS )->nNumLin
               ( dbfTmpSer )->cRef     := ( dbfFacCliS )->cRef
               ( dbfTmpSer )->cAlmLin  := ( dbfFacCliS )->cAlmLin
               ( dbfTmpSer )->cNumSer  := ( dbfFacCliS )->cNumSer

               ( dbfFacCliS )->( dbSkip() )

            end while

         end if

         CursorWE()

      end if

      oBrw:SetFocus()
      oBrw:Refresh()

      oBrwIva:SetFocus()

   end if

   SetStatus( dbfFacCliT, aFacCliT )
   SetStatus( dbfFacCliL, aFacCliL )

RETURN .T.

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

Static Function EdtPgo( aTmp, aGet, dbfTmpPgo, oBrw, dbfDiv, oCtaRem, nMode, oBandera )

	local oDlg
   local oBmpDiv
   local oGetCli
   local oGetAge
   local oGetCaj
   local oGetSubCta
   local cGetSubCta
   local oGetCtaRem
   local cGetCtaRem
   local oGetSubGas
   local cGetSubGas
   local lPgdOld
   local nImpOld
   local cGetCli     := RetClient( ( dbfTmpPgo )->cCodCli, D():Clientes( nView ) )
   local cGetAge     := cNbrAgent( ( dbfTmpPgo )->cCodAge, dbfAgent )
   local cGetCaj     := RetFld( ( dbfTmpPgo )->cCodCaj, dbfCajT, "cNomCaj" )
   local cPorDiv     := cPorDiv( aTmp[ ( dbfTmpPgo )->( FieldPos( "cDivPgo" ) ) ], dbfDiv )

   if nMode == EDIT_MODE   .and.;
      aTmp[ ( dbfTmpPgo )->( FieldPos( "LCONPGO" ) ) ]     .and.;
      !ApoloMsgNoYes( 'La modificación de este recibo puede provocar descuadres contables.' + CRLF + '¿ Desea continuar ?', 'Recibo ya contabilizado' )
      return .f.
   end if

   if nMode == EDIT_MODE
      if aTmp[ ( dbfTmpPgo )->( FieldPos( "lCloPgo" ) ) ] .and. !oUser():lAdministrador()
         msgStop( "Solo pueden modificar los recibos cerrados los administradores." )
         return .f.
      end if
   end if

   if empty( aTmp[ ( dbfTmpPgo )->( FieldPos( "CCODCAJ" ) ) ] )
      aTmp[ ( dbfTmpPgo )->( FieldPos( "CCODCAJ" ) ) ]   := Application():CodigoCaja()
   end if

   lPgdOld              := ( dbfTmpPgo )->lCobrado .or. ( dbfTmpPgo )->lRecDto
   nImpOld              := ( dbfTmpPgo )->nImporte

   DEFINE DIALOG oDlg RESOURCE "PAGOS" TITLE LblTitle( nMode ) + "recibos de clientes"

      REDEFINE GET aGet[ ( dbfTmpPgo )->( FieldPos( "DPRECOB" ) ) ];
         VAR      aTmp[ ( dbfTmpPgo )->( FieldPos( "DPRECOB" ) ) ];
         ID       100 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ON HELP  aGet[ ( dbfTmpPgo )->( FieldPos( "DPRECOB" ) ) ]:cText( Calendario( aTmp[ ( dbfTmpPgo )->( FieldPos( "DPRECOB" ) ) ] ) ) ;
         BITMAP   "LUPA" ;
         COLOR    CLR_GET ;
			OF 		oDlg

      REDEFINE GET aGet[ ( dbfTmpPgo )->( FieldPos( "DFECVTO" ) ) ];
         VAR      aTmp[ ( dbfTmpPgo )->( FieldPos( "DFECVTO" ) ) ];
         ID       110 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ON HELP  aGet[ ( dbfTmpPgo )->( FieldPos( "DFECVTO" ) ) ]:cText( Calendario( aTmp[ ( dbfTmpPgo )->( FieldPos( "DFECVTO" ) ) ] ) ) ;
         BITMAP   "LUPA" ;
         COLOR    CLR_GET ;
			OF 		oDlg

      REDEFINE GET aGet[ ( dbfTmpPgo )->( FieldPos( "CCODCLI" ) ) ];
         VAR      aTmp[ ( dbfTmpPgo )->( FieldPos( "CCODCLI" ) ) ];
         ID       120 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( cClient( aGet[ ( dbfTmpPgo )->( FieldPos( "CCODCLI" ) ) ], D():Clientes( nView ), oGetCli ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwClient( aGet[ ( dbfTmpPgo )->( FieldPos( "CCODCLI" ) ) ], oGetCli ) ) ;
         OF       oDlg

      REDEFINE GET oGetCli VAR cGetCli ;
         ID       121 ;
         WHEN     .f.;
         OF       oDlg

      REDEFINE GET aGet[ ( dbfTmpPgo )->( FieldPos( "CCODAGE" ) ) ];
         VAR      aTmp[ ( dbfTmpPgo )->( FieldPos( "CCODAGE" ) ) ];
         ID       130 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         VALID    ( cAgentes( aGet[ ( dbfTmpPgo )->( FieldPos( "CCODAGE" ) ) ], dbfAgent, oGetAge ) );
         BITMAP   "LUPA" ;
         ON HELP  ( BrwAgentes( aGet[ ( dbfTmpPgo )->( FieldPos( "CCODAGE" ) ) ], oGetAge ) );
         OF       oDlg

      REDEFINE GET oGetAge VAR cGetAge ;
         ID       131 ;
         WHEN     .f.;
         OF       oDlg

      REDEFINE GET aGet[ ( dbfTmpPgo )->( FieldPos( "CDESCRIP" ) ) ] ;
         VAR      aTmp[ ( dbfTmpPgo )->( FieldPos( "CDESCRIP" ) ) ] ;
         ID       140 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
			OF 		oDlg

      REDEFINE GET aGet[ ( dbfTmpPgo )->( FieldPos( "CPGDOPOR" ) ) ] ;
         VAR      aTmp[ ( dbfTmpPgo )->( FieldPos( "CPGDOPOR" ) ) ];
         ID       150 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
			OF 		oDlg

      REDEFINE GET aGet[ ( dbfTmpPgo )->( FieldPos( "CDOCPGO" ) ) ];
         VAR      aTmp[ ( dbfTmpPgo )->( FieldPos( "CDOCPGO" ) ) ];
         ID       155 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
			OF 		oDlg

      REDEFINE CHECKBOX aGet[ ( dbfTmpPgo )->( FieldPos( "LRECIMP" ) ) ] ;
         VAR      aTmp[ ( dbfTmpPgo )->( FieldPos( "LRECIMP" ) ) ];
         ID       160 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET aGet[ ( dbfTmpPgo )->( FieldPos( "CDIVPGO" ) ) ];
         VAR      aTmp[ ( dbfTmpPgo )->( FieldPos( "CDIVPGO" ) ) ];
         WHEN     ( .f. ) ;
         VALID    ( cDivOut( aGet[ ( dbfTmpPgo )->( FieldPos( "CDIVPGO" ) ) ], oBmpDiv, aGet[ ( dbfTmpPgo )->( FieldPos( "NVDVPGO" ) ) ], nil, nil, @cPorDiv, nil, nil, nil, nil, dbfDiv, oBandera ) );
         PICTURE  "@!";
         ID       170 ;
			COLOR 	CLR_GET ;
         BITMAP   "LUPA" ;
         ON HELP  BrwDiv( aGet[ ( dbfTmpPgo )->( FieldPos( "CDIVPGO" ) ) ], oBmpDiv, aGet[ ( dbfTmpPgo )->( FieldPos( "NVDVPGO" ) ) ], dbfDiv, oBandera ) ;
         OF       oDlg

		REDEFINE BITMAP oBmpDiv ;
         RESOURCE "BAN_EURO" ;
         ID       171;
         OF       oDlg

      REDEFINE GET aGet[ ( dbfTmpPgo )->( FieldPos( "NVDVPGO" ) ) ] ;
         VAR      aTmp[ ( dbfTmpPgo )->( FieldPos( "NVDVPGO" ) ) ];
			WHEN		( .F. ) ;
         ID       172 ;
         VALID    ( aTmp[ ( dbfTmpPgo )->( FieldPos( "NVDVPGO" ) ) ] > 0 ) ;
         PICTURE  "@E 999,999.9999" ;
         COLOR    CLR_GET ;
         OF       oDlg

      REDEFINE GET aGet[ ( dbfTmpPgo )->( FieldPos( "NIMPORTE" ) ) ] ;
         VAR      aTmp[ ( dbfTmpPgo )->( FieldPos( "NIMPORTE" ) ) ] ;
         ID       180 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( aGet[ ( dbfTmpPgo )->( FieldPos( "NIMPCOB" ) ) ]:cText( aTmp[ ( dbfTmpPgo )->( FieldPos( "NIMPORTE" ) ) ] ), .t. ) ;
         COLOR    CLR_GET ;
         PICTURE  ( cPorDiv ) ;
			OF 		oDlg

      REDEFINE GET aGet[ ( dbfTmpPgo )->( FieldPos( "NIMPCOB" ) ) ] ;
         VAR      aTmp[ ( dbfTmpPgo )->( FieldPos( "NIMPCOB" ) ) ];
         ID       190 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( ValCobro( aGet, aTmp ) ) ;
         COLOR    CLR_GET ;
         PICTURE  ( cPorDiv ) ;
			OF 		oDlg

      REDEFINE GET aGet[ ( dbfTmpPgo )->( FieldPos( "NIMPGAS" ) ) ];
         VAR      aTmp[ ( dbfTmpPgo )->( FieldPos( "NIMPGAS" ) ) ];
         ID       260 ;
         WHEN     ( .f. ) ;
         COLOR    CLR_GET ;
         PICTURE  ( cPorDiv ) ;
			OF 		oDlg

      REDEFINE CHECKBOX aGet[ ( dbfTmpPgo )->( FieldPos( "lNotArqueo" ) ) ] ;
         VAR      aTmp[ ( dbfTmpPgo )->( FieldPos( "lNotArqueo" ) ) ];
         ID       200 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE CHECKBOX aGet[ ( dbfTmpPgo )->( FieldPos( "LCOBRADO" ) ) ] ;
         VAR      aTmp[ ( dbfTmpPgo )->( FieldPos( "LCOBRADO" ) ) ];
         ID       220 ;
         ON CHANGE( ValCheck( aGet, aTmp ) ) ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET aGet[ ( dbfTmpPgo )->( FieldPos( "DENTRADA" ) ) ] ;
         VAR      aTmp[ ( dbfTmpPgo )->( FieldPos( "DENTRADA" ) ) ];
         ID       230 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ON HELP  aGet[ ( dbfTmpPgo )->( FieldPos( "DENTRADA" ) ) ]:cText( Calendario( aTmp[ ( dbfTmpPgo )->( FieldPos( "DENTRADA" ) ) ] ) ) ;
         BITMAP   "LUPA" ;
         COLOR    CLR_GET ;
			OF 		oDlg

      REDEFINE GET aGet[ ( dbfTmpPgo )->( FieldPos( "CCTAREC" ) ) ] ;
         VAR      aTmp[ ( dbfTmpPgo )->( FieldPos( "CCTAREC" ) ) ] ;
         ID       240 ;
			COLOR 	CLR_GET ;
         PICTURE  ( Replicate( "X", nLenSubcuentaContaplus() ) ) ;
         WHEN     ( nLenCuentaContaplus() != 0 .AND. nMode != ZOOM_MODE ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwChkSubcuenta( aGet[ ( dbfTmpPgo )->( FieldPos( "CCTAREC" ) ) ], oGetSubCta ) ) ;
         VALID    ( MkSubcuenta( aGet[ ( dbfTmpPgo )->( FieldPos( "CCTAREC" ) ) ], nil, oGetSubCta ) );
         OF       oDlg

		REDEFINE GET oGetSubCta VAR cGetSubCta ;
         ID       241 ;
			COLOR 	CLR_GET ;
			WHEN 		.F. ;
         OF       oDlg

      REDEFINE GET aGet[ ( dbfTmpPgo )->( FieldPos( "CCTAGAS" ) ) ] ;
         VAR      aTmp[ ( dbfTmpPgo )->( FieldPos( "CCTAGAS" ) ) ] ;
         ID       270 ;
			COLOR 	CLR_GET ;
         PICTURE  ( Replicate( "X", nLenSubcuentaContaplus() ) ) ;
         WHEN     ( nLenCuentaContaplus() != 0 .AND. nMode != ZOOM_MODE ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwChkSubcuenta( aGet[ ( dbfTmpPgo )->( FieldPos( "CCTAGAS" ) ) ], oGetSubGas ) ) ;
         VALID    ( MkSubcuenta( aGet[ ( dbfTmpPgo )->( FieldPos( "CCTAGAS" ) ) ], nil, oGetSubGas ) );
         OF       oDlg

      REDEFINE GET oGetSubGas VAR cGetSubGas ;
         ID       271 ;
			COLOR 	CLR_GET ;
			WHEN 		.F. ;
         OF       oDlg

      REDEFINE GET aGet[ ( dbfTmpPgo )->( FieldPos( "CCTAREM" ) ) ] ;
         VAR      aTmp[ ( dbfTmpPgo )->( FieldPos( "CCTAREM" ) ) ] ;
         ID       250 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         BITMAP   "LUPA" ;
         VALID    ( oGetCtaRem:cText( retFld( aTmp[ ( dbfTmpPgo )->( FieldPos( "CCTAREM" ) ) ], oCtaRem:GetAlias() ) ), .t. );
         ON HELP  ( oCtaRem:Buscar( aGet[ ( dbfTmpPgo )->( FieldPos( "CCTAREM" ) ) ] ) ) ;
         OF       oDlg

      REDEFINE GET oGetCtaRem VAR cGetCtaRem ;
         ID       251 ;
			COLOR 	CLR_GET ;
			WHEN 		.F. ;
         OF       oDlg

      /*
		Cajas____________________________________________________________________
		*/

      REDEFINE GET aGet[ ( dbfTmpPgo )->( FieldPos( "CCODCAJ" ) ) ];
         VAR      aTmp[ ( dbfTmpPgo )->( FieldPos( "CCODCAJ" ) ) ];
			WHEN 		( nMode != ZOOM_MODE ) ;
         VALID    cCajas( aGet[ ( dbfTmpPgo )->( FieldPos( "CCODCAJ" ) ) ], dbfCajT, oGetCaj ) ;
         ID       280 ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwCajas( aGet[ ( dbfTmpPgo )->( FieldPos( "CCODCAJ" ) ) ], oGetCaj ) ) ;
         OF       oDlg

      REDEFINE GET oGetCaj VAR cGetCaj ;
         ID       281 ;
         WHEN     .f. ;
         OF       oDlg

      /*
      Banco____________________________________________________________________
		*/

      REDEFINE GET aGet[ ( dbfTmpPgo )->( FieldPos( "CCODBNC" ) ) ] ;
         VAR      aTmp[ ( dbfTmpPgo )->( FieldPos( "CCODBNC" ) ) ];
         ID       310 ;
         IDTEXT   311 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( oBanco:Existe( aGet[ ( dbfTmpPgo )->( FieldPos( "CCODBNC" ) ) ], aGet[ ( dbfTmpPgo )->( FieldPos( "CCODBNC" ) ) ]:oHelpText, "cNomBnc", .t., .t., "0" ) );
         ON HELP  ( oBanco:Buscar( aGet[ ( dbfTmpPgo )->( FieldPos( "CCODBNC" ) ) ] ) ) ;
         BITMAP   "LUPA" ;
         OF       oDlg

      /*
      Botones__________________________________________________________________
		*/

      REDEFINE BUTTON ;
         ID       IDOK ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( EndPgo( aTmp, aGet, lPgdOld, nImpOld, dbfTmpPgo, oBrw, oDlg, nMode ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
         CANCEL ;
         ACTION   ( oDlg:End() )

   if nMode != ZOOM_MODE
      oDlg:AddFastKey( VK_F5, {|| EndPgo( aTmp, aGet, lPgdOld, nImpOld, dbfTmpPgo, oBrw, oDlg, nMode ) } )
   end if

   ACTIVATE DIALOG oDlg CENTER ;
         ON INIT  (  aGet[ ( dbfTmpPgo )->( FieldPos( "CDIVPGO" ) ) ]:lValid(),;
                     aGet[ ( dbfTmpPgo )->( FieldPos( "CCTAREC" ) ) ]:lValid(),;
                     aGet[ ( dbfTmpPgo )->( FieldPos( "CCTAGAS" ) ) ]:lValid(),;
                     aGet[ ( dbfTmpPgo )->( FieldPos( "CCTAREM" ) ) ]:lValid(),;
                     aGet[ ( dbfTmpPgo )->( FieldPos( "DPRECOB" ) ) ]:SetFocus() )

   oBmpDiv:End()

RETURN ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

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
      Añadimos el nuevo recibo
      */

      ( dbfTmpPgo )->( dbAppend() )
      nCon                       := ( dbfTmpPgo )->( Recno() )
      ( dbfTmpPgo )->cSerie      := aTmp[ ( dbfTmpPgo )->( FieldPos( "CSERIE"  ) ) ]
      ( dbfTmpPgo )->nNumFac     := aTmp[ ( dbfTmpPgo )->( FieldPos( "NNUMFAC" ) ) ]
      ( dbfTmpPgo )->cSufFac     := aTmp[ ( dbfTmpPgo )->( FieldPos( "CSUFFAC" ) ) ]
      ( dbfTmpPgo )->nNumRec     := nCon
      ( dbfTmpPgo )->cTipRec     := "R"
      ( dbfTmpPgo )->cCodCaj     := aTmp[ ( dbfTmpPgo )->( FieldPos( "CCODCAJ" ) ) ]
      ( dbfTmpPgo )->cCodCli     := aTmp[ ( dbfTmpPgo )->( FieldPos( "CCODCLI" ) ) ]
      ( dbfTmpPgo )->dEntrada    := Ctod( "" )
      ( dbfTmpPgo )->nImporte    := nImp
      ( dbfTmpPgo )->nImpGas     := 0
      ( dbfTmpPgo )->cDescrip    := "Recibo nº" + alltrim( Str( nCon ) ) + " de factura " + aTmp[ ( dbfTmpPgo )->( FieldPos( "CSERIE" ) ) ] + '/' + alltrim( Str( aTmp[ ( dbfTmpPgo )->( FieldPos( "NNUMFAC" ) ) ] ) ) + '/' + aTmp[ ( dbfTmpPgo )->( FieldPos( "CSUFFAC" ) ) ]
      ( dbfTmpPgo )->dPreCob     := dFecFacRec( aTmp[ ( dbfTmpPgo )->( FieldPos( "CSERIE" ) ) ] + Str( aTmp[ ( dbfTmpPgo )->( FieldPos( "NNUMFAC" ) ) ] ) + aTmp[ ( dbfTmpPgo )->( FieldPos( "CSUFFAC" ) ) ], D():FacturasRectificativas( nView ) )
      ( dbfTmpPgo )->dFecVto     := dFecFacRec( aTmp[ ( dbfTmpPgo )->( FieldPos( "CSERIE" ) ) ] + Str( aTmp[ ( dbfTmpPgo )->( FieldPos( "NNUMFAC" ) ) ] ) + aTmp[ ( dbfTmpPgo )->( FieldPos( "CSUFFAC" ) ) ], D():FacturasRectificativas( nView ) )
      ( dbfTmpPgo )->cPgdoPor    := ""
      ( dbfTmpPgo )->lCobrado    := .f.
      ( dbfTmpPgo )->cTurRec     := cCurSesion()
      ( dbfTmpPgo )->cDivPgo     := aTmp[ ( dbfTmpPgo )->( FieldPos( "CDIVPGO" ) ) ]
      ( dbfTmpPgo )->nVdvPgo     := aTmp[ ( dbfTmpPgo )->( FieldPos( "NVDVPGO" ) ) ]
      ( dbfTmpPgo )->lConPgo     := .f.
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

STATIC FUNCTION DupStart( oDesde, oDlg, oBtnAceptar, oBtnCancel, oTxtDup, lCancel, cFecDoc )

   local nOrd
   local nDuplicados    := 0
   local nProcesed      := 0

   oBtnAceptar:Hide()
   oBtnCancel:bAction   := {|| lCancel := .t. }

   if oDesde:nRadio == 1

      nOrd              := ( D():FacturasRectificativas( nView ) )->( OrdSetFocus( "nNumFac" ) )

      ( D():FacturasRectificativas( nView ) )->( dbSeek( oDesde:cNumeroInicio(), .t. ) )

      while !lCancel .and. ( D():FacturasRectificativas( nView ) )->( !eof() )

         if ( D():FacturasRectificativas( nView ) )->cSerie  >= oDesde:cSerieInicio  .and.;
            ( D():FacturasRectificativas( nView ) )->cSerie  <= oDesde:cSerieFin     .and.;
            ( D():FacturasRectificativas( nView ) )->nNumFac >= oDesde:nNumeroInicio .and.;
            ( D():FacturasRectificativas( nView ) )->nNumFac <= oDesde:nNumeroFin    .and.;
            ( D():FacturasRectificativas( nView ) )->cSufFac >= oDesde:cSufijoInicio .and.;
            ( D():FacturasRectificativas( nView ) )->cSufFac <= oDesde:cSufijoFin

            ++nDuplicados

            oTxtDup:cText  := "Duplicando : " + ( D():FacturasRectificativas( nView ) )->cSerie + "/" + alltrim( Str( ( D():FacturasRectificativas( nView ) )->nNumFac ) ) + "/" + ( D():FacturasRectificativas( nView ) )->cSufFac

            DupFactura( cFecDoc )

         end if

         ( D():FacturasRectificativas( nView ) )->( dbSkip() )

         ++nProcesed

         oTxtDup:Set( nProcesed )

      end do

      ( D():FacturasRectificativas( nView ) )->( OrdSetFocus( nOrd ) )

   else

      nOrd              := ( D():FacturasRectificativas( nView ) )->( OrdSetFocus( "dFecFac" ) )

      ( D():FacturasRectificativas( nView ) )->( dbSeek( oDesde:dFechaInicio, .t. ) )

      while !lCancel .and. ( D():FacturasRectificativas( nView ) )->( !eof() )

         if ( D():FacturasRectificativas( nView ) )->dFecFac >= oDesde:dFechaInicio  .and.;
            ( D():FacturasRectificativas( nView ) )->dFecFac <= oDesde:dFechaFin

            ++nDuplicados

            oTxtDup:cText  := "Duplicando : " + ( D():FacturasRectificativas( nView ) )->cSerie + "/" + alltrim( Str( ( D():FacturasRectificativas( nView ) )->nNumFac ) ) + "/" + ( D():FacturasRectificativas( nView ) )->cSufFac

            DupFactura( cFecDoc )

         end if

         ( D():FacturasRectificativas( nView ) )->( dbSkip() )

         ++nProcesed

         oTxtDup:Set( nProcesed )

      end do

      ( D():FacturasRectificativas( nView ) )->( OrdSetFocus( nOrd ) )

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

STATIC FUNCTION FacRecDup( cDbf, xField1, xField2, xField3, lCab, cFecDoc, lPag )

   local nRec                 := ( cDbf )->( Recno() )
   local aTabla               := {}
   local nOrdAnt

   DEFAULT lCab               := .f.
   DEFAULT lPag               := .f.

   aTabla                     := DBScatter( cDbf )
   aTabla[ _CSERIE  ]         := xField1
   aTabla[ _NNUMFAC ]         := xField2
   aTabla[ _CSUFFAC ]         := xField3

   if lCab

      aTabla[ _CTURFAC     ]  := cCurSesion()
      if !empty( cFecDoc )
         aTabla[ _DFECFAC  ]  := cFecDoc
      end if
      aTabla[ _CCODCAJ     ]  := Application():CodigoCaja()
      aTabla[ _LCONTAB     ]  := .f.
      aTabla[ _DFECENT     ]  := Ctod("")
      aTabla[ _LIMPALB     ]  := .f.
      aTabla[ _CNUMFAC     ]  := Space( 12 )
      aTabla[ _LSNDDOC     ]  := .t.
      aTabla[ _LCLOFAC     ]  := .f.
      aTabla[ _CABNFAC     ]  := Space( 12 )
      aTabla[ _CANTFAC     ]  := Space( 12 )
      aTabla[ _CCODUSR     ]  := Auth():Codigo()
      aTabla[ _DFECCRE     ]  := GetSysDate()
      aTabla[ _CTIMCRE     ]  := Time()
      aTabla[ _LIMPRIMIDO  ]  := .f.
      aTabla[ _DFECIMP     ]  := Ctod("")
      aTabla[ _CHORIMP     ]  := Space( 5 )
      aTabla[ _CCODDLG     ]  := Application():CodigoDelegacion()

      nOrdAnt                 := ( cDbf )->( OrdSetFocus( "NNUMFAC" ) )

   end if

   if lPag

      aTabla[ ( dbfFacCliP )->( FieldPos( "lConPgo" ) ) ]      := .f.
      aTabla[ ( dbfFacCliP )->( FieldPos( "lRecImp" ) ) ]      := .f.
      aTabla[ ( dbfFacCliP )->( FieldPos( "lRecDto" ) ) ]      := .f.
      aTabla[ ( dbfFacCliP )->( FieldPos( "lCloPgo" ) ) ]      := .f.
      aTabla[ ( dbfFacCliP )->( FieldPos( "dPreCob" ) ) ]      := cFecDoc
      aTabla[ ( dbfFacCliP )->( FieldPos( "dFecDto" ) ) ]      := Ctod("")
      aTabla[ ( dbfFacCliP )->( FieldPos( "dFecImp" ) ) ]      := Ctod("")
      aTabla[ ( dbfFacCliP )->( FieldPos( "cHorImp" ) ) ]      := Space( 5 )
      aTabla[ ( dbfFacCliP )->( FieldPos( "dFecVto" ) ) ]      := cFecDoc
      aTabla[ ( dbfFacCliP )->( FieldPos( "cTurRec" ) ) ]      := cCurSesion()
      aTabla[ ( dbfFacCliP )->( FieldPos( "cCodCaj" ) ) ]      := Application():CodigoCaja()

      if aTabla[ ( dbfFacCliP )->( FieldPos( "lCobrado" ) ) ]
         aTabla[ ( dbfFacCliP )->( FieldPos( "dEntrada" ) ) ]  := cFecDoc
      else
         aTabla[ ( dbfFacCliP )->( FieldPos( "dEntrada" ) ) ]  := Ctod("")
      end if

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

STATIC FUNCTION DupFactura( cFecDoc )

   local nNewNumFac  := 0

   //Recogemos el nuevo numero de factura--------------------------------------

   nNewNumFac  := nNewDoc( ( D():FacturasRectificativas( nView ) )->cSerie, D():FacturasRectificativas( nView ), "NFACREC", , dbfCount )

   //Duplicamos las cabeceras--------------------------------------------------

   FacRecDup( D():FacturasRectificativas( nView ), ( D():FacturasRectificativas( nView ) )->cSerie, nNewNumFac, ( D():FacturasRectificativas( nView ) )->cSufFac, .t., cFecDoc )

   //Duplicamos las lineas del documento---------------------------------------

   if ( D():FacturasRectificativasLineas( nView ) )->( dbSeek( ( D():FacturasRectificativas( nView ) )->cSerie + Str( ( D():FacturasRectificativas( nView ) )->nNumFac ) + ( D():FacturasRectificativas( nView ) )->cSufFac ) )

      while ( D():FacturasRectificativas( nView ) )->cSerie + Str( ( D():FacturasRectificativas( nView ) )->nNumFac ) + ( D():FacturasRectificativas( nView ) )->cSufFac == ( D():FacturasRectificativasLineas( nView ) )->cSerie + Str( ( D():FacturasRectificativasLineas( nView ) )->nNumFac ) + ( D():FacturasRectificativasLineas( nView ) )->cSufFac .and. ;
            !( D():FacturasRectificativasLineas( nView ) )->( Eof() )

            FacRecDup( D():FacturasRectificativasLineas( nView ), ( D():FacturasRectificativas( nView ) )->cSerie, nNewNumFac, ( D():FacturasRectificativas( nView ) )->cSufFac, .f. )

         ( D():FacturasRectificativasLineas( nView ) )->( dbSkip() )

      end while

   end if

   //Duplicamos los pagos------------------------------------------------------

   if ( dbfFacCliP )->( dbSeek( ( D():FacturasRectificativas( nView ) )->cSerie + Str( ( D():FacturasRectificativas( nView ) )->nNumFac ) + ( D():FacturasRectificativas( nView ) )->cSufFac ) )

      while ( D():FacturasRectificativas( nView ) )->cSerie + Str( ( D():FacturasRectificativas( nView ) )->nNumFac ) + ( D():FacturasRectificativas( nView ) )->cSufFac == ( dbfFacCliP )->cSerie + Str( ( dbfFacCliP )->nNumFac ) + ( dbfFacCliP )->cSufFac .and. ;
            !empty( ( dbfFacCliP )->cTipRec ) .and.;
            !( dbfFacCliP )->( Eof() )

            FacRecDup( dbfFacCliP, ( D():FacturasRectificativas( nView ) )->cSerie, nNewNumFac, ( dbfFacCliT )->cSufFac, .f., cFecDoc, .t. )

         ( dbfFacCliP )->( dbSkip() )

      end while

   end if

   //Duplicamos los documentos-------------------------------------------------

   if ( dbfFacRecD )->( dbSeek( ( D():FacturasRectificativas( nView ) )->cSerie + Str( ( D():FacturasRectificativas( nView ) )->nNumFac ) + ( D():FacturasRectificativas( nView ) )->cSufFac ) )

      while ( D():FacturasRectificativas( nView ) )->cSerie + Str( ( D():FacturasRectificativas( nView ) )->nNumFac ) + ( D():FacturasRectificativas( nView ) )->cSufFac == ( dbfFacRecD )->cSerie + Str( ( dbfFacRecD )->nNumFac ) + ( dbfFacRecD )->cSufFac .and. ;
            !( dbfFacRecD )->( Eof() )

            FacRecDup( dbfFacRecD, ( D():FacturasRectificativas( nView ) )->cSerie, nNewNumFac, ( D():FacturasRectificativas( nView ) )->cSufFac, .f. )

         ( dbfFacRecD )->( dbSkip() )

      end while

   end if

RETURN ( .t. )

//---------------------------------------------------------------------------//

STATIC FUNCTION ValidaMedicion( aTmp, aGet )

   local cNewUndMed  := aGet[ _CUNIDAD ]:VarGet

   /*
   Cargamos el codigo de las unidades---------------------------------
   */

   if ( empty( cOldUndMed ) .or. cOldUndMed != cNewUndMed )

      if oUndMedicion:oDbf:Seek( aTmp[ _CUNIDAD ] )

         if oUndMedicion:oDbf:nDimension >= 1 .and. !empty( oUndMedicion:oDbf:cTextoDim1 )
            if !empty( aGet[ ( D():FacturasRectificativasLineas( nView ) )->( fieldpos( "nMedUno" ) ) ] )
               aGet[ ( D():FacturasRectificativasLineas( nView ) )->( fieldpos( "nMedUno" ) ) ]:oSay:SetText( oUndMedicion:oDbf:cTextoDim1 )
               aGet[ ( D():FacturasRectificativasLineas( nView ) )->( fieldpos( "nMedUno" ) ) ]:cText( ( D():Articulos( nView ) )->nLngArt )
               aGet[ ( D():FacturasRectificativasLineas( nView ) )->( fieldpos( "nMedUno" ) ) ]:Show()
            else
               aTmp[ ( D():FacturasRectificativasLineas( nView ) )->( fieldpos( "nMedUno" ) ) ]  := ( D():Articulos( nView ) )->nLngArt
            end if
         else
            if !empty( aGet[ ( D():FacturasRectificativasLineas( nView ) )->( fieldpos( "nMedUno" ) ) ] )
               aGet[ ( D():FacturasRectificativasLineas( nView ) )->( fieldpos( "nMedUno" ) ) ]:cText( 0 )
               aGet[ ( D():FacturasRectificativasLineas( nView ) )->( fieldpos( "nMedUno" ) ) ]:Hide()
            else
               aTmp[ ( D():FacturasRectificativasLineas( nView ) )->( fieldpos( "nMedUno" ) ) ]  := 0
            end if
         end if

         if oUndMedicion:oDbf:nDimension >= 2 .and.!empty( oUndMedicion:oDbf:cTextoDim2 )
            if !empty( aGet[ ( D():FacturasRectificativasLineas( nView ) )->( fieldpos( "nMedDos" ) ) ] )
               aGet[ ( D():FacturasRectificativasLineas( nView ) )->( fieldpos( "nMedDos" ) ) ]:oSay:SetText( oUndMedicion:oDbf:cTextoDim2 )
               aGet[ ( D():FacturasRectificativasLineas( nView ) )->( fieldpos( "nMedDos" ) ) ]:cText( ( D():Articulos( nView ) )->nAltArt )
               aGet[ ( D():FacturasRectificativasLineas( nView ) )->( fieldpos( "nMedDos" ) ) ]:Show()
            else
               aTmp[ ( D():FacturasRectificativasLineas( nView ) )->( fieldpos( "nMedDos" ) ) ]  := ( D():Articulos( nView ) )->nAltArt
            end if

         else
            if !empty( aGet[ ( D():FacturasRectificativasLineas( nView ) )->( fieldpos( "nMedDos" ) ) ] )
               aGet[ ( D():FacturasRectificativasLineas( nView ) )->( fieldpos( "nMedDos" ) ) ]:cText( 0 )
               aGet[ ( D():FacturasRectificativasLineas( nView ) )->( fieldpos( "nMedDos" ) ) ]:Hide()
            else
                 aTmp[ ( D():FacturasRectificativasLineas( nView ) )->( fieldpos( "nMedDos" ) ) ]  := 0
            end if
         end if

         if oUndMedicion:oDbf:nDimension >= 3 .and. !empty( oUndMedicion:oDbf:cTextoDim3 )

            if !empty( aGet[ ( D():FacturasRectificativasLineas( nView ) )->( fieldpos( "nMedTre" ) ) ] )
               aGet[ ( D():FacturasRectificativasLineas( nView ) )->( fieldpos( "nMedTre" ) ) ]:oSay:SetText( oUndMedicion:oDbf:cTextoDim3 )
               aGet[ ( D():FacturasRectificativasLineas( nView ) )->( fieldpos( "nMedTre" ) ) ]:cText( ( D():Articulos( nView ) ) ->nAncArt )
               aGet[ ( D():FacturasRectificativasLineas( nView ) )->( fieldpos( "nMedTre" ) ) ]:Show()
            else
               aTmp[ ( D():FacturasRectificativasLineas( nView ) )->( fieldpos( "nMedTre" ) ) ]  := ( D():Articulos( nView ) )->nAncArt
            end if

         else

            if !empty( aGet[ ( D():FacturasRectificativasLineas( nView ) )->( fieldpos( "nMedTre" ) ) ] )
               aGet[ ( D():FacturasRectificativasLineas( nView ) )->( fieldpos( "nMedTre" ) ) ]:cText( 0 )
               aGet[ ( D():FacturasRectificativasLineas( nView ) )->( fieldpos( "nMedTre" ) ) ]:Hide()
            else
               aTmp[ ( D():FacturasRectificativasLineas( nView ) )->( fieldpos( "nMedTre" ) ) ]  := 0
            end if

         end if

      else

         if !empty( aGet[ ( D():FacturasRectificativasLineas( nView ) )->( fieldpos( "nMedUno" ) ) ] )
            aGet[ ( D():FacturasRectificativasLineas( nView ) )->( fieldpos( "nMedUno" ) ) ]:Hide()
            aGet[ ( D():FacturasRectificativasLineas( nView ) )->( fieldpos( "nMedUno" ) ) ]:cText( 0 )
         end if

         if !empty( aGet[ ( D():FacturasRectificativasLineas( nView ) )->( fieldpos( "nMedDos" ) ) ] )
            aGet[ ( D():FacturasRectificativasLineas( nView ) )->( fieldpos( "nMedDos" ) ) ]:Hide()
            aGet[ ( D():FacturasRectificativasLineas( nView ) )->( fieldpos( "nMedDos" ) ) ]:cText( 0 )
         end if

         if !empty( aGet[ ( D():FacturasRectificativasLineas( nView ) )->( fieldpos( "nMedTre" ) ) ] )
            aGet[ ( D():FacturasRectificativasLineas( nView ) )->( fieldpos( "nMedTre" ) ) ]:Hide()
            aGet[ ( D():FacturasRectificativasLineas( nView ) )->( fieldpos( "nMedTre" ) ) ]:cText( 0 )
         end if

      end if

      cOldUndMed := cNewUndMed

   end if

RETURN .t.

//-----------------------------------------------------------------------------------------

Static Function ChangeTarifa( aTmp, aGet, aTmpFac )

   local nPrePro

   nPrePro        := nPrePro( aTmp[ _CREF ], aTmp[ _CCODPR1 ], aTmp[ _CVALPR1 ], aTmp[ _CCODPR2 ], aTmp[ _CVALPR2 ], aTmp[ _NTARLIN ], aTmpFac[ _LIVAINC ], dbfArtDiv, aTmpFac[ _CCODTAR ] )

   if nPrePro == 0
      nPrePro     := nRetPreArt( aTmp[ _NTARLIN ], aTmpFac[ _CDIVFAC ], aTmpFac[ _LIVAINC ], D():Articulos( nView ), dbfDiv, dbfKit, dbfIva, , , oNewImp )
   end if

   if nPrePro != 0
      aGet[ _NPREUNIT ]:cText( nPrePro )
   end if

return .t.

//-----------------------------------------------------------------------------

Static Function loadComisionAgente( aTmp, aGet, aTmpFac )

   local nComisionAgenteTarifa   

   nComisionAgenteTarifa      := nComisionAgenteTarifa( aTmpFac[ _CCODAGE ], aTmp[ _NTARLIN ], nView ) 
   if nComisionAgenteTarifa == 0
      nComisionAgenteTarifa   := aTmpFac[ _NPCTCOMAGE ]
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

#include "FastRepH.ch"

Static Function DataReport( oFr )

   /*
   Zona de datos------------------------------------------------------------
   */

   oFr:ClearDataSets()

   oFr:SetWorkArea(     "Facturas rectificativas", ( D():FacturasRectificativas( nView ) )->( Select() ), .f., { FR_RB_CURRENT, FR_RB_CURRENT, 0 } )
   oFr:SetFieldAliases( "Facturas rectificativas", cItemsToReport( aItmFacRec() ) )

   oFr:SetWorkArea(     "Lineas de facturas rectificativas", ( D():FacturasRectificativasLineas( nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Lineas de facturas rectificativas", cItemsToReport( aColFacRec() ) )

   oFr:SetWorkArea(     "Series de lineas de facturas rectificativas", ( dbfFacRecS )->( Select() ) )
   oFr:SetFieldAliases( "Series de lineas de facturas rectificativas", cItemsToReport( aSerFacRec() ) )

   oFr:SetWorkArea(     "Incidencias de facturas rectificativas", ( dbfFacRecI )->( Select() ) )
   oFr:SetFieldAliases( "Incidencias de facturas rectificativas", cItemsToReport( aIncFacRec() ) )

   oFr:SetWorkArea(     "Documentos de facturas rectificativas", ( dbfFacRecD )->( Select() ) )
   oFr:SetFieldAliases( "Documentos de facturas rectificativas", cItemsToReport( aFacRecDoc() ) )

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

   oFr:SetWorkArea(     "Tipo de artículo",  oTipArt:Select() )
   oFr:SetFieldAliases( "Tipo de artículo",  cObjectsToReport( oTipArt:oDbf ) )

   oFr:SetWorkArea(     "Ofertas", ( dbfOferta )->( Select() ) )
   oFr:SetFieldAliases( "Ofertas", cItemsToReport( aItmOfe() ) )

   oFr:SetWorkArea(     "Bancos", ( dbfCliBnc )->( Select() ) )
   oFr:SetFieldAliases( "Bancos", cItemsToReport( aCliBnc() ) )

   oFr:SetWorkArea(     "Unidades de medición",  oUndMedicion:Select() )
   oFr:SetFieldAliases( "Unidades de medición",  cObjectsToReport( oUndMedicion:oDbf ) )

   oFr:SetWorkArea(     "Impuestos especiales",  oNewImp:Select() )
   oFr:SetFieldAliases( "Impuestos especiales",  cObjectsToReport( oNewImp:oDbf ) )

   oFr:SetMasterDetail( "Facturas rectificativas", "Lineas de facturas rectificativas",            {|| ( D():FacturasRectificativas( nView ) )->cSerie + Str( ( D():FacturasRectificativas( nView ) )->nNumFac ) + ( D():FacturasRectificativas( nView ) )->cSufFac } )
   oFr:SetMasterDetail( "Facturas rectificativas", "Incidencias de facturas rectificativas",       {|| ( D():FacturasRectificativas( nView ) )->cSerie + Str( ( D():FacturasRectificativas( nView ) )->nNumFac ) + ( D():FacturasRectificativas( nView ) )->cSufFac } )
   oFr:SetMasterDetail( "Facturas rectificativas", "Documentos de facturas rectificativas",        {|| ( D():FacturasRectificativas( nView ) )->cSerie + Str( ( D():FacturasRectificativas( nView ) )->nNumFac ) + ( D():FacturasRectificativas( nView ) )->cSufFac } )
   oFr:SetMasterDetail( "Facturas rectificativas", "Empresa",                                      {|| cCodigoEmpresaEnUso() } )
   oFr:SetMasterDetail( "Facturas rectificativas", "Clientes",                                     {|| ( D():FacturasRectificativas( nView ) )->cCodCli } )
   oFr:SetMasterDetail( "Facturas rectificativas", "Obras",                                        {|| ( D():FacturasRectificativas( nView ) )->cCodCli + ( D():FacturasRectificativas( nView ) )->cCodObr } )
   oFr:SetMasterDetail( "Facturas rectificativas", "Almacen",                                      {|| ( D():FacturasRectificativas( nView ) )->cCodAlm } )
   oFr:SetMasterDetail( "Facturas rectificativas", "Rutas",                                        {|| ( D():FacturasRectificativas( nView ) )->cCodRut } )
   oFr:SetMasterDetail( "Facturas rectificativas", "Agentes",                                      {|| ( D():FacturasRectificativas( nView ) )->cCodAge } )
   oFr:SetMasterDetail( "Facturas rectificativas", "Formas de pago",                               {|| ( D():FacturasRectificativas( nView ) )->cCodPago } )
   oFr:SetMasterDetail( "Facturas rectificativas", "Transportistas",                               {|| ( D():FacturasRectificativas( nView ) )->cCodTrn } )
   oFr:SetMasterDetail( "Facturas rectificativas", "Bancos",                                       {|| ( D():FacturasRectificativas( nView ) )->cCodCli } )

   oFr:SetMasterDetail( "Lineas de facturas rectificativas", "Artículos",                          {|| SynchronizeDetails() } )
   oFr:SetMasterDetail( "Lineas de facturas rectificativas", "Tipo de artículo",                   {|| ( D():FacturasRectificativasLineas( nView ) )->cCodTip } )
   oFr:SetMasterDetail( "Lineas de facturas rectificativas", "Ofertas",                            {|| ( D():FacturasRectificativasLineas( nView ) )->cRef } )
   oFr:SetMasterDetail( "Lineas de facturas rectificativas", "Unidades de medición",               {|| ( D():FacturasRectificativasLineas( nView ) )->cUnidad } )
   oFr:SetMasterDetail( "Lineas de facturas rectificativas", "Impuestos especiales",               {|| ( D():FacturasRectificativasLineas( nView ) )->cCodImp } )
   oFr:SetMasterDetail( "Lineas de facturas rectificativas", "Series de lineas de facturas rectificativas",  	{|| ( D():FacturasRectificativasLineas( nView ) )->cSerie + Str( ( D():FacturasRectificativasLineas( nView ) )->nNumFac ) + ( D():FacturasRectificativasLineas( nView ) )->cSufFac + Str( ( D():FacturasRectificativasLineas( nView ) )->nNumLin ) } )
																																																
   oFr:SetResyncPair(   "Facturas rectificativas", "Lineas de facturas rectificativas" )
   oFr:SetResyncPair(   "Facturas rectificativas", "Incidencias de facturas rectificativas" )
   oFr:SetResyncPair(   "Facturas rectificativas", "Documentos de facturas rectificativas" )
   oFr:SetResyncPair(   "Facturas rectificativas", "Empresa" )
   oFr:SetResyncPair(   "Facturas rectificativas", "Clientes" )
   oFr:SetResyncPair(   "Facturas rectificativas", "Obras" )
   oFr:SetResyncPair(   "Facturas rectificativas", "Almacenes" )
   oFr:SetResyncPair(   "Facturas rectificativas", "Rutas" )
   oFr:SetResyncPair(   "Facturas rectificativas", "Agentes" )
   oFr:SetResyncPair(   "Facturas rectificativas", "Formas de pago" )
   oFr:SetResyncPair(   "Facturas rectificativas", "Transportistas" )
   oFr:SetResyncPair(   "Facturas rectificativas", "Bancos" )

   oFr:SetResyncPair(   "Lineas de facturas rectificativas", "Artículos" )
   oFr:SetResyncPair(   "Lineas de facturas rectificativas", "Tipo de artículo" )
   oFr:SetResyncPair(   "Lineas de facturas rectificativas", "Ofertas" )
   oFr:SetResyncPair(   "Lineas de facturas rectificativas", "Unidades de medición" )
   oFr:SetResyncPair(   "Lineas de facturas rectificativas", "Impuestos especiales" )
   oFr:SetResyncPair(   "Lineas de facturas rectificativas", "Series de lineas de facturas rectificativas" )

Return nil

//---------------------------------------------------------------------------//

Static Function SynchronizeDetails()

Return ( ( D():FacturasRectificativasLineas( nView ) )->cRef )

//---------------------------------------------------------------------------//

Static Function VariableReport( oFr )

   oFr:DeleteCategory(  "Facturas rectificativas" )
   oFr:DeleteCategory(  "Lineas de facturas rectificativas" )

   /*
   Creación de variables----------------------------------------------------
   */

   oFr:AddVariable(     "Facturas rectificativas",             "Total factura",                       "GetHbVar('nTotFac')" )
   oFr:AddVariable(     "Facturas rectificativas",             "Total descuento",                     "GetHbVar('nTotDto')" )
   oFr:AddVariable(     "Facturas rectificativas",             "Total descuento pronto pago",         "GetHbVar('nTotDpp')" )
   oFr:AddVariable(     "Facturas rectificativas",             "Total bruto",                         "GetHbVar('nTotBrt')" )
   oFr:AddVariable(     "Facturas rectificativas",             "Total descuentos",                    "GetHbVar('nTotalDto')" )
   oFr:AddVariable(     "Facturas rectificativas",             "Total neto",                          "GetHbVar('nTotNet')" )
   oFr:AddVariable(     "Facturas rectificativas",             "Total primer descuento definible",    "GetHbVar('nTotUno')" )
   oFr:AddVariable(     "Facturas rectificativas",             "Total segundo descuento definible",   "GetHbVar('nTotDos')" )
   oFr:AddVariable(     "Facturas rectificativas",             "Total " + cImp(),                     "GetHbVar('nTotIva')" )
   oFr:AddVariable(     "Facturas rectificativas",             "Total RE",                            "GetHbVar('nTotReq')" )
   oFr:AddVariable(     "Facturas rectificativas",             "Total página",                        "GetHbVar('nTotPag')" )
   oFr:AddVariable(     "Facturas rectificativas",             "Total retención",                     "GetHbVar('nTotRet')" )
   oFr:AddVariable(     "Facturas rectificativas",             "Total peso",                          "GetHbVar('nTotPes')" )
   oFr:AddVariable(     "Facturas rectificativas",             "Total costo",                         "GetHbVar('nTotCos')" )
   oFr:AddVariable(     "Facturas rectificativas",             "Total anticipado",                    "GetHbVar('nTotAnt')" )
   oFr:AddVariable(     "Facturas rectificativas",             "Total cobrado",                       "GetHbVar('nTotCob')" )
   oFr:AddVariable(     "Facturas rectificativas",             "Total artículos",                     "GetHbVar('nTotArt')" )
   oFr:AddVariable(     "Facturas rectificativas",             "Total cajas",                         "GetHbVar('nTotCaj')" )
   oFr:AddVariable(     "Facturas rectificativas",             "Cuenta por defecto del cliente",      "GetHbVar('cCtaCli')" )

   oFr:AddVariable(     "Facturas rectificativas",             "Bruto primer tipo de " + cImp(),      "GetHbArrayVar('aIvaUno',1)" )
   oFr:AddVariable(     "Facturas rectificativas",             "Bruto segundo tipo de " + cImp(),     "GetHbArrayVar('aIvaDos',1)" )
   oFr:AddVariable(     "Facturas rectificativas",             "Bruto tercer tipo de " + cImp(),      "GetHbArrayVar('aIvaTre',1)" )
   oFr:AddVariable(     "Facturas rectificativas",             "Base primer tipo de " + cImp(),       "GetHbArrayVar('aIvaUno',2)" )
   oFr:AddVariable(     "Facturas rectificativas",             "Base segundo tipo de " + cImp(),      "GetHbArrayVar('aIvaDos',2)" )
   oFr:AddVariable(     "Facturas rectificativas",             "Base tercer tipo de " + cImp(),       "GetHbArrayVar('aIvaTre',2)" )
   oFr:AddVariable(     "Facturas rectificativas",             "Porcentaje primer tipo " + cImp(),    "GetHbArrayVar('aIvaUno',3)" )
   oFr:AddVariable(     "Facturas rectificativas",             "Porcentaje segundo tipo " + cImp(),   "GetHbArrayVar('aIvaDos',3)" )
   oFr:AddVariable(     "Facturas rectificativas",             "Porcentaje tercer tipo " + cImp(),    "GetHbArrayVar('aIvaTre',3)" )
   oFr:AddVariable(     "Facturas rectificativas",             "Porcentaje primer tipo RE",           "GetHbArrayVar('aIvaUno',4)" )
   oFr:AddVariable(     "Facturas rectificativas",             "Porcentaje segundo tipo RE",          "GetHbArrayVar('aIvaDos',4)" )
   oFr:AddVariable(     "Facturas rectificativas",             "Porcentaje tercer tipo RE",           "GetHbArrayVar('aIvaTre',4)" )
   oFr:AddVariable(     "Facturas rectificativas",             "Importe primer tipo " + cImp(),       "GetHbArrayVar('aIvaUno',8)" )
   oFr:AddVariable(     "Facturas rectificativas",             "Importe segundo tipo " + cImp(),      "GetHbArrayVar('aIvaDos',8)" )
   oFr:AddVariable(     "Facturas rectificativas",             "Importe tercer tipo " + cImp(),       "GetHbArrayVar('aIvaTre',8)" )
   oFr:AddVariable(     "Facturas rectificativas",             "Importe primer RE",                   "GetHbArrayVar('aIvaUno',9)" )
   oFr:AddVariable(     "Facturas rectificativas",             "Importe segundo RE",                  "GetHbArrayVar('aIvaDos',9)" )
   oFr:AddVariable(     "Facturas rectificativas",             "Importe tercer RE",                   "GetHbArrayVar('aIvaTre',9)" )

   oFr:AddVariable(     "Facturas rectificativas",             "Fecha del primer vencimiento",        "GetHbArrayVar('aDatVto',1)" )
   oFr:AddVariable(     "Facturas rectificativas",             "Fecha del segundo vencimiento",       "GetHbArrayVar('aDatVto',2)" )
   oFr:AddVariable(     "Facturas rectificativas",             "Fecha del tercer vencimiento",        "GetHbArrayVar('aDatVto',3)" )
   oFr:AddVariable(     "Facturas rectificativas",             "Fecha del cuarto vencimiento",        "GetHbArrayVar('aDatVto',4)" )
   oFr:AddVariable(     "Facturas rectificativas",             "Fecha del quinto vencimiento",        "GetHbArrayVar('aDatVto',5)" )
   oFr:AddVariable(     "Facturas rectificativas",             "Fecha del sexto vencimiento",         "GetHbArrayVar('aDatVto',6)" )
   oFr:AddVariable(     "Facturas rectificativas",             "Fecha del septimo vencimiento",       "GetHbArrayVar('aDatVto',7)" )
   oFr:AddVariable(     "Facturas rectificativas",             "Fecha del octavovencimiento",         "GetHbArrayVar('aDatVto',8)" )
   oFr:AddVariable(     "Facturas rectificativas",             "Fecha del noveno vencimiento",        "GetHbArrayVar('aDatVto',9)" )
   oFr:AddVariable(     "Facturas rectificativas",             "Fecha del decimo vencimiento",        "GetHbArrayVar('aDatVto',10)" )
   oFr:AddVariable(     "Facturas rectificativas",             "Fecha del undecimo vencimiento",      "GetHbArrayVar('aDatVto',11)" )
   oFr:AddVariable(     "Facturas rectificativas",             "Fecha del duodecimo vencimiento",     "GetHbArrayVar('aDatVto',12)" )

   oFr:AddVariable(     "Facturas rectificativas",             "Importe del primer vencimiento",      "GetHbArrayVar('aImpVto',1)" )
   oFr:AddVariable(     "Facturas rectificativas",             "Importe del segundo vencimiento",     "GetHbArrayVar('aImpVto',2)" )
   oFr:AddVariable(     "Facturas rectificativas",             "Importe del tercero vencimiento",     "GetHbArrayVar('aImpVto',3)" )
   oFr:AddVariable(     "Facturas rectificativas",             "Importe del cuarto vencimiento",      "GetHbArrayVar('aImpVto',4)" )
   oFr:AddVariable(     "Facturas rectificativas",             "Importe del quinto vencimiento",      "GetHbArrayVar('aImpVto',5)" )
   oFr:AddVariable(     "Facturas rectificativas",             "Importe del sexto vencimiento",       "GetHbArrayVar('aImpVto',6)" )
   oFr:AddVariable(     "Facturas rectificativas",             "Importe del septimo vencimiento",     "GetHbArrayVar('aImpVto',7)" )
   oFr:AddVariable(     "Facturas rectificativas",             "Importe del octavo vencimiento",      "GetHbArrayVar('aImpVto',8)" )
   oFr:AddVariable(     "Facturas rectificativas",             "Importe del noveno vencimiento",      "GetHbArrayVar('aImpVto',9)" )
   oFr:AddVariable(     "Facturas rectificativas",             "Importe del decimo vencimiento",      "GetHbArrayVar('aImpVto',10)" )
   oFr:AddVariable(     "Facturas rectificativas",             "Importe del undecimo vencimiento",    "GetHbArrayVar('aImpVto',11)" )
   oFr:AddVariable(     "Facturas rectificativas",             "Importe del duodecimo vencimiento",   "GetHbArrayVar('aImpVto',12)" )

   oFr:AddVariable(     "Facturas rectificativas",             "Total unidades primer tipo de impuestos especiales",            "GetHbArrayVar('aIvmUno',1 )" )
   oFr:AddVariable(     "Facturas rectificativas",             "Total unidades segundo tipo de impuestos especiales",           "GetHbArrayVar('aIvmDos',1 )" )
   oFr:AddVariable(     "Facturas rectificativas",             "Total unidades tercer tipo de impuestos especiales",            "GetHbArrayVar('aIvmTre',1 )" )
   oFr:AddVariable(     "Facturas rectificativas",             "Importe del primer tipo de impuestos especiales",               "GetHbArrayVar('aIvmUno',2 )" )
   oFr:AddVariable(     "Facturas rectificativas",             "Importe del segundo tipo de impuestos especiales",              "GetHbArrayVar('aIvmDos',2 )" )
   oFr:AddVariable(     "Facturas rectificativas",             "Importe del tercer tipo de impuestos especiales",               "GetHbArrayVar('aIvmTre',2 )" )
   oFr:AddVariable(     "Facturas rectificativas",             "Total importe primer tipo de impuestos especiales",             "GetHbArrayVar('aIvmUno',3 )" )
   oFr:AddVariable(     "Facturas rectificativas",             "Total importe segundo tipo de impuestos especiales",            "GetHbArrayVar('aIvmDos',3 )" )
   oFr:AddVariable(     "Facturas rectificativas",             "Total importe tercer tipo de impuestos especiales",             "GetHbArrayVar('aIvmTre',3 )" )

   oFr:AddVariable(     "Facturas rectificativas",             "Cuenta bancaria cliente",             "CallHbFunc('cCtaFacRec')" )

   oFr:AddVariable(     "Lineas de facturas rectificativas",   "Detalle del artículo",                "CallHbFunc('cDesFacRec')" )
   oFr:AddVariable(     "Lineas de facturas rectificativas",   "Detalle del artículo otro lenguaje",  "CallHbFunc('cDesFacRecLeng')" )
   oFr:AddVariable(     "Lineas de facturas rectificativas",   "Total unidades artículo",             "CallHbFunc('nTotNFacRec')" )
   oFr:AddVariable(     "Lineas de facturas rectificativas",   "Precio unitario del artículo",        "CallHbFunc('nTotUFacRec')" )
   oFr:AddVariable(     "Lineas de facturas rectificativas",   "Precio unitario con descuentos",      "CallHbFunc('nTotPFacRec')" )
   oFr:AddVariable(     "Lineas de facturas rectificativas",   "Punto verde del artículo",            "CallHbFunc('nPntUFacRec')" )
   oFr:AddVariable(     "Lineas de facturas rectificativas",   "Total línea de factura",              "CallHbFunc('nTotLFacRec')" )
   oFr:AddVariable(     "Lineas de facturas rectificativas",   "Total peso por línea",                "CallHbFunc('nPesLFacRec')" )
   oFr:AddVariable(     "Lineas de facturas rectificativas",   "Total final línea del factura",       "CallHbFunc('nTotFFacRec')" )
   oFr:AddVariable(     "Lineas de facturas rectificativas",   "Importe descuento línea del factura", "CallHbFunc('nDtoLFacRec')" )
   oFr:AddVariable(     "Lineas de facturas rectificativas",   "Total descuento línea del factura",   "CallHbFunc('nTotDtoLFacRec')" )

Return nil

//---------------------------------------------------------------------------//

Static Function YearComboBoxChange()

   if ( oWndBrw:oWndBar:cYearComboBox() != __txtAllYearsFilter__ )
      oWndBrw:oWndBar:setYearComboBoxExpression( "Year( Field->dFecFac ) == " + oWndBrw:oWndBar:cYearComboBox() )
   else
      oWndBrw:oWndBar:setYearComboBoxExpression( "" )
   end if 

   oWndBrw:chgFilter()

Return nil

//---------------------------------------------------------------------------//

STATIC FUNCTION lLiquida( oBrw, cFactura )

   DEFAULT cFactura  := ( D():FacturasRectificativas( nView ) )->cSerie + Str( ( D():FacturasRectificativas( nView ) )->nNumFac ) + ( D():FacturasRectificativas( nView ) )->cSufFac

   if ( D():FacturasRectificativas( nView ) )->lLiquidada
      msgStop( "Factura ya cobrada", "Imposible añadir cobros" )
      return .f.
   end if

   /*
   Comprobamos si existen recibos de esta factura------------------------------
   */

   ( dbfFacCliP )->( dbGoTop() )

   if ( dbfFacCliP )->( dbSeek( cFactura ) )

      while ( dbfFacCliP )->cSerie + Str( ( dbfFacCliP )->nNumFac ) + ( dbfFacCliP )->cSufFac == cFactura .and. !( dbfFacCliP )->( eof() )

         if !empty( ( dbfFacCliP )->cTipRec ) .and. !( dbfFacCliP )->lCobrado

            EdtRecCli( ( dbfFacCliP )->cSerie + Str( ( dbfFacCliP )->nNumFac ) + ( dbfFacCliP )->cSufFac + Str( ( dbfFacCliP )->nNumRec ) + ( dbfFacCliP )->cTipRec, .f. )

            exit

         end if

         ( dbfFacCliP )->( dbSkip() )

      end do

   end if

   /*
   Chekea el estado de la factura---------------------------------------------
   */

   ChkLqdFacRec( nil, D():FacturasRectificativas( nView ), D():FacturasRectificativasLineas( nView ), dbfFacCliP, dbfIva, dbfDiv )

   oBrw:Refresh()
   oBrw:SetFocus()

Return .t.

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

         sOfeArt     := sOfertaFamilia( ( D():Articulos( nView ) )->Familia, aTmpFac[ _CCODCLI ], aTmpFac[ _CCODGRP ], aTmpFac[ _DFECFAC ], dbfOferta, aTmp[ _NTARLIN ], D():Articulos( nView ), aTmp[ _NUNICAJA ], aTmp[ _NCANENT ], nTotalLinea )

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

         sOfeArt     := sOfertaTemporada( ( D():Articulos( nView ) )->cCodTemp, aTmpFac[ _CCODCLI ], aTmpFac[ _CCODGRP ], aTmpFac[ _DFECFAC ], dbfOferta, aTmp[ _NTARLIN ], D():Articulos( nView ), aTmp[ _NUNICAJA ], aTmp[ _NCANENT ], nTotalLinea )

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

   if !empty( aGet[ _DFECCAD ] )
      aGet[ _DFECCAD ]:cText( dFechaCaducidadLote( aTmp[ _CREF ], aTmp[ _CVALPR1 ], aTmp[ _CVALPR2 ], aTmp[ _CLOTE ], dbfAlbPrvL, dbfFacPrvL, dbfProLin ) )
   end if

Return ( .t. )

//--------------------------------------------------------------------------//

Static Function EditarNumeroSerie( aTmp, oStock, nMode )

   with object ( TNumerosSerie() )

      :nMode            := nMode

      :cCodArt          := aTmp[ _CREF    ]
      :cCodAlm          := aTmp[ _CALMLIN ]
      :nNumLin          := aTmp[ _NNUMLIN ]

      :nTotalUnidades   := nTotNFacRec( aTmp )

      :oStock           := oStock

      :uTmpSer          := dbfTmpSer

      :Resource()

   end with

Return ( nil )

//--------------------------------------------------------------------------//

Static Function OldEditarNumeroSerie( aTmp, oStock, nMode )

   local n
   local oDlg
   local nTotUnd
   local cCodArt
   local cCodAlm
   local oBrwSer
   local aNumSer
   local aValSer
   local cPreFix  := Space( 18 )
   local oSerIni
   local nSerIni  := 0
   local oSerFin
   local nSerFin  := 0
   local oNumGen
   local nNumGen  := 0
   local oSaySer
   local cSaySer  := ""
   local oProSer
   local nProSer

   DEFAULT nMode  := APPD_MODE

   nTotUnd        := Abs( nTotNFacRec( aTmp ) )

   if nTotUnd == 0
      MsgStop( "No hay unidades para asignar números de serie." )
      Return ( nil )
   end if

   n              := 1

   cCodArt        := aTmp[ _CREF    ]
   cCodAlm        := aTmp[ _CALMLIN ]

   aNumSer        := Afill( Array( nTotUnd ), Space( 30 ) )
   aValSer        := Afill( Array( nTotUnd ), .f. )

   if ( dbfTmpSer )->( dbSeek( Str( aTmp[ _NNUMLIN ], 4 ) + aTmp[ _CREF ] ) )
      while ( Str( ( dbfTmpSer )->nNumLin, 4 ) + ( dbfTmpSer )->cRef == Str( aTmp[ _NNUMLIN ], 4 ) + aTmp[ _CREF ] ) .and. !( dbfTmpSer )->( Eof() )
         if ( n <= nTotUnd )
            aNumSer[ n ]   := ( dbfTmpSer )->cNumSer
         end if
         ( dbfTmpSer )->( dbSkip() )
         n++
      end while
   end if

   DEFINE DIALOG oDlg RESOURCE "VTANUMSER"

      REDEFINE GET nTotUnd ;
			ID 		100 ;
         PICTURE  MasUnd() ;
         WHEN     .f. ;
         OF       oDlg

      REDEFINE GET cPreFix ;
         ID       110 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET oSerIni VAR nSerIni ;
         ID       120 ;
         PICTURE  "99999999999999999999" ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( oSerFin:cText( nSerIni + nTotUnd ), .t. ) ;
         OF       oDlg

      REDEFINE GET oSerFin VAR nSerFin ;
         ID       130 ;
         PICTURE  "99999999999999999999" ;
         WHEN     .f. ;
         OF       oDlg

      REDEFINE GET oNumGen VAR nNumGen ;
         ID       140 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  "99999999999999999999" ;
         OF       oDlg

      REDEFINE BUTTON ;
         ID       500 ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( oDlg:Disable(), GenNumSer( cPreFix, aNumSer, nSerIni, nNumGen, oBrwSer, oProSer ), lValSer( cCodArt, cCodAlm, aNumSer, aValSer, nTotUnd, oStock, oBrwSer, oProSer, oSaySer ), oDlg:Enable() )

      oBrwSer                 := IXBrowse():New( oDlg )

      oBrwSer:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwSer:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrwSer:lHScroll        := .f.
      oBrwSer:lRecordSelector := .t.
      oBrwSer:lFastEdit       := .t.

      oBrwSer:nMarqueeStyle   := MARQSTYLE_HIGHLCELL

      oBrwSer:SetArray( aNumSer, , , .f. )

      oBrwSer:nColSel         := 2

      with object ( oBrwSer:addCol() )
         :cHeader             := "N."
         :bStrData            := {|| Trans( oBrwSer:nArrayAt, "999999" ) }
         :nWidth              := 60
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
      end with

      with object ( oBrwSer:addCol() )
         :cHeader             := "Serie"
         :bEditValue          := {|| aNumSer[ oBrwSer:nArrayAt ] }
         :nWidth              := 220
         if nMode != ZOOM_MODE
            :nEditType        := 1
         end if
         :bOnPostEdit         := {|o,x| aNumSer[ oBrwSer:nArrayAt ] := x, aValSer[ oBrwSer:nArrayAt ] := oStock:lValidNumeroSerie( cCodArt, cCodAlm, x ) }
      end whit

      with object ( oBrwSer:addCol() )
         :cHeader             := "Es."
         :nHeadBmpNo          := 4
         :bStrData            := {|| "" }
         :bBmpData            := {|| if( aValSer[ oBrwSer:nArrayAt ], 3, 1 ) }
         :nWidth              := 20
         :AddResource( "gc_delete_12" )
         :AddResource( "gc_shape_square_12" )
         :AddResource( "gc_check_12" )
         :AddResource( "gc_document_information_16" )
      end with

      oBrwSer:CreateFromResource( 150 )

      REDEFINE SAY oSaySer VAR cSaySer ;
         ID       230 ;
         OF       oDlg

      oProSer     := TApoloMeter():ReDefine( 240, { | u | if( pCount() == 0, nProSer, nProSer := u ) }, 10, oDlg, .f., , , .t., rgb( 255,255,255 ), , rgb( 128,255,0 ) )

      REDEFINE BUTTON ;
         ID       510 ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( if( lChkSer( aValSer, nTotUnd, oProSer, oBrwSer ), SalvarNumeroSerie( aNumSer, aTmp, oProSer, oDlg ), ) )

      REDEFINE BUTTON ;
         ID       520 ;
         OF       oDlg ;
         ACTION   ( oDlg:End() )

      oDlg:bStart := {|| oDlg:Disable(), lValSer( cCodArt, cCodAlm, aNumSer, aValSer, nTotUnd, oStock, oBrwSer, oProSer, oSaySer ), oDlg:Enable() }

      oDlg:AddFastKey( VK_F5, {|| if( lChkSer( aValSer, nTotUnd, oProSer, oBrwSer ), SalvarNumeroSerie( aNumSer, aTmp, oProSer, oDlg ),  ) } )

   ACTIVATE DIALOG oDlg CENTER

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

//----------------------------------------------------------------------------//

Static Function hValue( aTmp, aTmpFac )

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
      case ValType( aTmpFac ) == "A"

         hValue[ "cCodigoCliente"    ] := aTmpFac[ _CCODCLI ]
         hValue[ "cCodigoGrupo"      ] := aTmpFac[ _CCODGRP ]
         hValue[ "lIvaIncluido"      ] := aTmpFac[ _LIVAINC ]
         hValue[ "dFecha"            ] := aTmpFac[ _DFECFAC ]
         hValue[ "nDescuentoTarifa"  ] := aTmpFac[ _NDTOTARIFA ]

      case ValType( aTmpFac ) == "C"
         
         hValue[ "cCodigoCliente"    ] := ( aTmpFac )->cCodCli
         hValue[ "cCodigoGrupo"      ] := ( aTmpFac )->cCodGrp
         hValue[ "lIvaIncluido"      ] := ( aTmpFac )->lIvaInc
         hValue[ "dFecha"            ] := ( aTmpFac )->dFecFac
         hValue[ "nDescuentoTarifa"  ] := ( aTmpFac )->nDtoTarifa

   end case

   hValue[ "nTipoDocumento"         ] := FAC_REC
   hValue[ "nView"                  ] := nView

Return ( hValue )

//---------------------------------------------------------------------------//

Static Function ImprimirSeriesFacturasRectificativas( nDevice, lExt )

   local aStatus
   local oPrinter   
   local cFormato 

   DEFAULT nDevice   := IS_PRINTER
   DEFAULT lExt      := .f.

   // Cremaos el dialogo-------------------------------------------------------

   oPrinter          := PrintSeries():New( nView ):SetVentas()

   // Establecemos sus valores-------------------------------------------------

   oPrinter:Serie(      ( D():FacturasRectificativas( nView ) )->cSerie )
   oPrinter:Documento(  ( D():FacturasRectificativas( nView ) )->nNumFac )
   oPrinter:Sufijo(     ( D():FacturasRectificativas( nView ) )->cSufFac )

   if lExt

      oPrinter:oFechaInicio:cText( ( D():FacturasRectificativas( nView ) )->dFecFac )
      oPrinter:oFechaFin:cText( ( D():FacturasRectificativas( nView ) )->dFecFac )

   end if

   oPrinter:oFormatoDocumento:TypeDocumento( "FR" )   

   // Formato de documento-----------------------------------------------------

   cFormato          := cFormatoDocumento( ( D():FacturasRectificativas( nView ) )->cSerie, "nFacRec", D():Contadores( nView ) )
   if empty( cFormato )
      cFormato       := cFirstDoc( "FR", D():Documentos( nView ) )
   end if
   oPrinter:oFormatoDocumento:cText( cFormato )

   // Codeblocks para que trabaje----------------------------------------------

   aStatus           := D():GetInitStatus( "FacRecT", nView )

   oPrinter:bInit    := {||   ( D():FacturasRectificativas( nView ) )->( dbSeek( oPrinter:DocumentoInicio(), .t. ) ) }

   oPrinter:bWhile   := {||   oPrinter:InRangeDocumento( D():FacturasRectificativasId( nView ) )                  .and. ;
                              ( D():FacturasRectificativas( nView ) )->( !eof() ) }

   oPrinter:bFor     := {||   oPrinter:InRangeFecha( ( D():FacturasRectificativas( nView ) )->dFecFac )           .and. ;
                              oPrinter:InRangeCliente( ( D():FacturasRectificativas( nView ) )->cCodCli )         .and. ;
                              oPrinter:InRangeGrupoCliente( retGrpCli( ( D():FacturasRectificativas( nView ) )->cCodCli, D():Clientes( nView ) ) ) }

   oPrinter:bSkip    := {||   ( D():FacturasRectificativas( nView ) )->( dbSkip() ) }

   oPrinter:bAction  := {||   GenFacRec(  nDevice,;
                                          "Imprimiendo documento : " + D():FacturasRectificativasId( nView ),;
                                          oPrinter:oFormatoDocumento:uGetValue,;
                                          oPrinter:oImpresora:uGetValue,;
                                          if( !oPrinter:oCopias:lCopiasPredeterminadas, oPrinter:oCopias:uGetValue, ) ) }

   oPrinter:bStart   := {||   if( lExt, oPrinter:DisableRange(), ) }

   // Abrimos el dialogo-------------------------------------------------------

   oPrinter:Resource():End()

   // Restore -----------------------------------------------------------------

   D():SetStatus( "FacRecT", nView, aStatus )
   
   if !empty( oWndBrw )
      oWndBrw:Refresh()
   end if   

Return .t.


//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
/*------------------------FUNCIONES GLOBALESS--------------------------------*/
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

FUNCTION nBrtLFacRec( uTmpLin, nDec, nRec, nVdv, cPorDiv )

   local nCalculo    := 0

   DEFAULT nDec      := 2
   DEFAULT nVdv      := 1

   nCalculo          := nTotUFacRec( uTmpLin, nDec, nVdv, cPorDiv )
   nCalculo          *= nTotNFacRec( uTmpLin )

   nCalculo          := Round( nCalculo / nVdv, nRec )

Return ( if( cPorDiv != nil, Trans( nCalculo, cPorDiv ), nCalculo ) )

//---------------------------------------------------------------------------//

/*
Devuelve el valor del impuestos de un artículo
*/

FUNCTION nIvaUFacRec( dbfTmpLin, nDec, nVdv )

   local nCalculo

   DEFAULT nDec   := 0
   DEFAULT nVdv   := 1

   nCalculo       := nTotUFacRec( dbfTmpLin, nDec, nVdv )

   if !( dbfTmpLin )->lIvaLin
      nCalculo    := nCalculo * ( dbfTmpLin )->nIva / 100
   else
      nCalculo    -= nCalculo / ( 1 + ( dbfTmpLin )->nIva / 100 )
   end if

   if nVdv != 0
      nCalculo    := nCalculo / nVdv
   end if

RETURN ( Round( nCalculo, nDec ) )

//---------------------------------------------------------------------------//
/*
Devuelve el precio unitario impuestos incluido
*/

FUNCTION nIncUFacRec( dbfTmpLin, nDec, nVdv )

   local nCalculo

   DEFAULT nDec   := 0
   DEFAULT nVdv   := 1

   nCalculo       := nTotUFacRec( dbfTmpLin, nDec, nVdv )

   if !( dbfTmpLin )->lIvaLin
      nCalculo    += nCalculo * ( dbfTmpLin )->nIva / 100
   end if

	IF nVdv != 0
      nCalculo    := nCalculo / nVdv
	END IF

RETURN ( Round( nCalculo, nDec ) )

//---------------------------------------------------------------------------//

FUNCTION nDtoUFacRec( dbfTmpLin, nDec, nVdv )

   local nCalculo := ( dbfTmpLin )->nDtoDiv

   DEFAULT nDec   := 0
   DEFAULT nVdv   := 1

	IF nVdv != 0
      nCalculo    := ( dbfTmpLin )->nDtoDiv / nVdv
	END IF

RETURN ( round( nCalculo, nDec ) )

//---------------------------------------------------------------------------//

FUNCTION nIvaLFacRec( cFacRecL, nDec, nRou, nVdv, lDto, lPntVer, lImpTrn, cPouDiv )

   local nCalculo    := 0

   DEFAULT cFacRecL  := D():FacturasRectificativasLineas( nView )
   DEFAULT nDec      := nDouDiv()
   DEFAULT nRou      := nRouDiv()
   DEFAULT nVdv      := 1
   DEFAULT lDto      := .t.
   DEFAULT lPntVer   := .t.
   DEFAULT lImpTrn   := .t.

   if ( cFacRecL )->nRegIva <= 1

      nCalculo          := nTotLFacRec( cFacRecL, nDec, nRou, nVdv, lDto, lPntVer, lImpTrn, cPouDiv )   

      if !( cFacRecL )->lIvaLin
         nCalculo       := nCalculo * ( cFacRecL )->nIva / 100
      else
         nCalculo       -= nCalculo / ( 1 + ( cFacRecL )->nIva / 100 )
      end if

   end if

   nCalculo          := Round( nCalculo, nRou )

RETURN ( if( cPouDiv != nil, Trans( nCalculo, cPouDiv ), nCalculo ) )

//---------------------------------------------------------------------------//
/*
Devuelve el total de una lina con impuestos incluido
*/

FUNCTION nIncLFacRec( dbfLin, nDec, nRouDec, nVdv, lDto, lPntVer, lImpTrn, cPorDiv )

   local nCalculo := nTotLFacRec( dbfLin, nDec, nRouDec, nVdv, lDto, lPntVer, lImpTrn )

   if !( dbfLin )->lIvaLin
      nCalculo    += nCalculo * ( dbfLin )->nIva / 100
   end if

RETURN ( if( cPorDiv != NIL, Trans( nCalculo, cPorDiv ), nCalculo ) )

//---------------------------------------------------------------------------//

/*
Importe unitario del punto verde
*/

FUNCTION nPntUFacRec( cFacRecL, nDec, nVdv )

   local nCalculo

   DEFAULT cFacRecL  := D():FacturasRectificativasLineas( nView )
   DEFAULT nDec      := nDouDiv()
   DEFAULT nVdv      := 1

   nCalculo          := ( cFacRecL )->nPntVer

   if nVdv != 0
      nCalculo       := nCalculo / nVdv
   end if

RETURN ( Round( nCalculo, nDec ) )

//---------------------------------------------------------------------------//
//
// Devuelve el punto verde de una linea
//

FUNCTION nPntLFacRec( cFacRecL, nDec, nVdv )

   local nPntVer

   DEFAULT cFacRecL  := D():FacturasRectificativasLineas( nView )
   DEFAULT nDec      := nDouDiv()
   DEFAULT nVdv      := 1

   /*
   Punto Verde
   */

   nPntVer           := nPntUFacRec( cFacRecL, nDec, nVdv ) * nTotNFacRec( cFacRecL )

RETURN ( Round( nPntVer, nDec ) )

//---------------------------------------------------------------------------//

FUNCTION nTrnUFacRec( dbfTmpLin, nDec, nVdv )

	local nCalculo

   DEFAULT nDec   := 0
   DEFAULT nVdv   := 1

   nCalculo       := ( dbfTmpLin )->nImpTrn

	IF nVdv != 0
      nCalculo    := nCalculo / nVdv
	END IF

RETURN ( Round( nCalculo, nDec ) )

//---------------------------------------------------------------------------//

FUNCTION nTrnLFacRec( dbfLin, nDec, nRou, nVdv )

   local nImpTrn

   DEFAULT dbfLin    := D():FacturasRectificativasLineas( nView )
   DEFAULT nDec      := 2
   DEFAULT nRou      := 2
   DEFAULT nVdv      := 1

   /*
   Punto Verde
   */

   nImpTrn           := nTrnUFacRec( dbfLin, nDec ) * nTotNFacRec( dbfLin )

   IF nVdv != 0
      nImpTrn        := nImpTrn / nVdv
	END IF

RETURN ( Round( nImpTrn, nRou ) )

//---------------------------------------------------------------------------//

FUNCTION nComLFacRec( cFacRecT, dbfFacRecL, nDecOut, nDerOut )

   local nImpLFacRec  := nImpLFacRec( cFacRecT, dbfFacRecL, nDecOut, nDerOut, , .f., .t., .f., .f. )

RETURN ( nImpLFacRec * ( dbfFacRecL )->nComAge / 100 )

//--------------------------------------------------------------------------//

FUNCTION aTotFacRec( cFactura, cFacRecT, dbfFacRecL, dbfIva, dbfDiv, cDivRet )

   nTotFacRec( cFactura, cFacRecT, dbfFacRecL, dbfIva, dbfDiv, nil, cDivRet )

RETURN ( { nTotNet, nTotIva, nTotReq, nTotFac, nTotPnt, nTotTrn, nTotAge, aTotIva, nTotCos, nTotIvm, nTotRnt, nTotRet } )

//--------------------------------------------------------------------------//

/*
Devuelve el neto de una factura
*/

FUNCTION nNetFacRec( cFactura, dbfFact, dbfLine, dbfIva, dbfDiv )

   nTotFacRec( cFactura, dbfFact, dbfLine, dbfIva, dbfDiv )

RETURN nTotNet

//--------------------------------------------------------------------------//

FUNCTION nCosLFacRec( dbfLine, nDec, nRec, nVdv, cPouDiv )

   local nCalculo       := 0

   DEFAULT nDec         := 0
   DEFAULT nRec         := 0
   DEFAULT nVdv         := 1

   if !( dbfLine )->lKitChl
      nCalculo          := nTotNFacRec( dbfLine )
      nCalculo          *= ( dbfLine )->nCosDiv
   end if

   if nVdv != 0
      nCalculo          := nCalculo / nVdv
   end if

   nCalculo             := Round( nCalculo, nRec )

RETURN ( if( cPouDiv != nil, Trans( nCalculo, cPouDiv ), nCalculo ) )

//--------------------------------------------------------------------------//

/*
Esta funcion hace los calculos de los totales en la factura
*/

FUNCTION nTotFacRec( cFactura, cFacRecT, cFacRecL, cIva, cDiv, aTmp, cDivRet, lPic, lExcCnt )

   local nRec
   local bCondition
   local lRecargo
   local nDtoUno
   local nDtoDos
   local nDtoEsp
   local nPctRet
   local nDtoPP
   local nPorte
   local nIvaMan
   local nManObr
   local lIvaInc
   local nKgsTrn
   local nTotArt           := 0
   local nTotLin           := 0
   local nTotUnd           := 0
   local aTotalDto         := { 0, 0, 0 }
   local aTotalDPP         := { 0, 0, 0 }
   local aTotalUno         := { 0, 0, 0 }
   local aTotalDos         := { 0, 0, 0 }
   local aTotalBase		   := { 0, 0, 0 }	
   local nDescuentosLineas := 0
   local lPntVer           := .f.
   local nRegIva
   local nBaseGasto
   local nIvaGasto
   
   if !empty( nView )
      DEFAULT cFacRecT     := D():FacturasRectificativas( nView )
      DEFAULT cFacRecL     := D():FacturasRectificativasLineas( nView )
   end if

   DEFAULT cIva            := cIva
   DEFAULT cDiv            := cDiv
   DEFAULT cFactura        := ( cFacRecT )->cSerie + Str( ( cFacRecT )->nNumFac ) + ( cFacRecT )->cSufFac
   DEFAULT lPic            := .f.

   public nTotFac          := 0
   public nTotBrt          := 0
   public nTotDto          := 0
   public nTotDPP          := 0
   public nTotNet          := 0
   public nTotIva          := 0
   public nTotIvm          := 0
   public nTotAge          := 0
   public nTotReq          := 0
   public nTotPnt          := 0
   public nTotUno          := 0
   public nTotDos          := 0
   public nTotRet          := 0
   public nTotTrn          := 0
   public nTotAnt          := 0
   public nTotCos          := 0
   public nTotPes          := 0
   public nTotRnt          := 0
   public nPctRnt          := 0
   public nTotDif          := 0
   public cCtaCli          := cClientCuenta( ( cFacRecT )->cCodCli )

   public aTotIva          := { { 0,0,nil,0,0,0,0,0,0,0,0 }, { 0,0,nil,0,0,0,0,0,0,0,0 }, { 0,0,nil,0,0,0,0,0,0,0,0 } }
   public aIvaUno          := aTotIva[ 1 ]
   public aIvaDos          := aTotIva[ 2 ]
   public aIvaTre          := aTotIva[ 3 ]

   public aTotIvm          := { { 0,0,0 }, { 0,0,0 }, { 0,0,0 }, }
   public aIvmUno          := aTotIvm[ 1 ]
   public aIvmDos          := aTotIvm[ 2 ]
   public aIvmTre          := aTotIvm[ 3 ]

   public aImpVto          := {}
   public aDatVto          := {}

   public nNumArt          := 0
   public nNumCaj          := 0

   public nTotalDto        := 0

   nRec                    := ( cFacRecL )->( Recno() )

   if aTmp != nil
      nDtoUno              := aTmp[ _NDTOUNO ]
      nDtoDos              := aTmp[ _NDTODOS ]
      lRecargo             := aTmp[ _LRECARGO]
      nDtoEsp              := aTmp[ _NDTOESP ]
      nDtoPP               := aTmp[ _NDPP    ]
      nPorte               := aTmp[ _NPORTES ]
      nIvaMan              := aTmp[ _NIVAMAN ]
      nManObr              := aTmp[ _NMANOBR ]
      lIvaInc              := aTmp[ _LIVAINC ]
      cCodDiv              := aTmp[ _CDIVFAC ]
      nPctRet              := aTmp[ _NPCTRET ]
      nKgsTrn              := aTmp[ _NKGSTRN ]
      lPntVer              := aTmp[ _LOPERPV ]
      nRegIva              := aTmp[ _NREGIVA ]
      bCondition           := {|| ( cFacRecL )->( !eof() ) }
      ( cFacRecL )->( dbGoTop() )
   else
      nDtoUno              := ( cFacRecT )->nDtoUno
      nDtoDos              := ( cFacRecT )->nDtoDos
      nDtoEsp              := ( cFacRecT )->nDtoEsp
      nDtoPP               := ( cFacRecT )->nDpp
      lRecargo             := ( cFacRecT )->lRecargo
      nPorte               := ( cFacRecT )->nPorTes
      nIvaMan              := ( cFacRecT )->nIvaMan
      nManObr              := ( cFacRecT )->nManObr
      lIvaInc              := ( cFacRecT )->lIvaInc
      cCodDiv              := ( cFacRecT )->cDivFac
      nPctRet              := ( cFacRecT )->nPctRet
      nKgsTrn              := ( cFacRecT )->nKgsTrn
      lPntVer              := ( cFacRecT )->lOperPV
      nRegIva              := ( cFacRecT )->nRegIva
      bCondition           := {|| ( cFacRecL )->cSerie + Str( ( cFacRecL )->nNumFac ) + ( cFacRecL )->cSufFac == cFactura .and. !( cFacRecL)->( eof() ) }
      ( cFacRecL )->( dbSeek( cFactura ) )
   end if

   /*
	Cargamos los pictures dependiendo de la moneda
	*/

   cPouDiv                 := cPouDiv( cCodDiv, cDiv ) // Picture de la divisa redondeada
   cPorDiv                 := cPorDiv( cCodDiv, cDiv ) // Picture de la divisa redondeada
   cPpvDiv                 := cPpvDiv( cCodDiv, cDiv ) // Picture del punto verde
   nDouDiv                 := nDouDiv( cCodDiv, cDiv ) // Decimales
   nRouDiv                 := nRouDiv( cCodDiv, cDiv ) // Decimales de redondeo
   nDpvDiv                 := nDpvDiv( cCodDiv, cDiv ) // Decimales de redondeo del punto verde

   while Eval( bCondition )

      if lValLine( cFacRecL )

         if ( lExcCnt == nil                             	.or.;   // Entran todos
            ( lExcCnt .and. ( cFacRecL )->nCtlStk != 2 )  	.or.;   // Articulos sin contadores
            ( !lExcCnt .and. ( cFacRecL )->nCtlStk == 2 ) )        	// Articulos con contadores

            if ( cFacRecL )->lTotLin

               /*
               Esto es para evitar escirbir en el fichero muchas veces---------
               */

               if ( cFacRecL )->nPreUnit != nTotLin .OR. ( cFacRecL )->nUniCaja != nTotUnd

                  if ( cFacRecL )->( dbRLock() )
                     ( cFacRecL )->nPreUnit := nTotLin
                     ( cFacRecL )->nUniCaja := nTotUnd
                     ( cFacRecL )->( dbUnLock() )
                  end if

               end if

               /*
               Limpien---------------------------------------------------------
               */

               nTotLin           := 0
               nTotUnd           := 0

            else

               nTotArt           := nTotLFacRec( cFacRecL, nDouDiv, nRouDiv, , , .f., .f. )
               nTotTrn           := nTrnLFacRec( cFacRecL, nDouDiv )
               nTotIvm           := nTotIFacRec( cFacRecL, nDouDiv, nRouDiv )
               nTotPnt           := if( lPntVer, nPntLFacRec( cFacRecL, nDpvDiv ), 0 )
               nTotCos           += nCosLFacRec( cFacRecL, nDouDiv, nRouDiv )
               nTotPes           += nPesLFacRec( cFacRecL )
               nDescuentosLineas += nTotDtoLFacRec( cFacRecL, nDouDiv )

               if aTmp != nil
                  nTotAge        += nComLFacRec( aTmp, cFacRecL, nDouDiv, nRouDiv )
               else
                  nTotAge        += nComLFacRec( cFacRecT, cFacRecL, nDouDiv, nRouDiv )
               end if

               /*
               Acumuladores para las lineas de totales-------------------------
               */

               nTotLin           += nTotArt
               nNumArt           += nTotNFacRec( cFacRecL )
               nNumCaj           += ( cFacRecL )->nCanEnt

               /*
               Estudio de impuestos--------------------------------------------------
               */

               do case
               case _NPCTIVA1 == nil .OR. _NPCTIVA1 == ( cFacRecL )->nIva
                  _NPCTIVA1      := ( cFacRecL )->nIva
                  _NPCTREQ1      := ( cFacRecL )->nReq
                  _NBRTIVA1      += nTotArt
                  _NIVMIVA1      += nTotIvm
                  _NTRNIVA1      += nTotTrn
                  _NPNTVER1      += nTotPnt

               case _NPCTIVA2 == nil .OR. _NPCTIVA2 == ( cFacRecL )->nIva
                  _NPCTIVA2      := ( cFacRecL )->nIva
                  _NPCTREQ2      := ( cFacRecL )->nReq
                  _NBRTIVA2      += nTotArt
                  _NIVMIVA3      += nTotIvm
                  _NTRNIVA3      += nTotTrn
                  _NPNTVER2      += nTotPnt

               case _NPCTIVA3 == nil .OR. _NPCTIVA3 == ( cFacRecL )->nIva
                  _NPCTIVA3      := ( cFacRecL )->nIva
                  _NPCTREQ3      := ( cFacRecL )->nReq
                  _NBRTIVA3      += nTotArt
                  _NIVMIVA3      += nTotIvm
                  _NTRNIVA3      += nTotTrn
                  _NPNTVER3      += nTotPnt

               end case

                //Estudio de los impuestos especiales------------------------

                if ( cFacRecL )->nValImp != 0

                  do case
                     case aTotIvm[ 1, 2 ] == 0 .or. aTotIvm[ 1, 2 ] == ( cFacRecL )->nValImp
                        aTotIvm[ 1, 1 ]      += nTotNFacRec ( cFacRecL ) * if( ( cFacRecL )->lVolImp, NotCero( ( cFacRecL )->nVolumen ), 1 )
                        aTotIvm[ 1, 2 ]      := ( cFacRecL )->nValImp
                        aTotIvm[ 1, 3 ]      := aTotIvm[ 1, 1 ] * aTotIvm[ 1, 2 ]

                     case aTotIvm[ 2, 2 ] == 0 .or. aTotIvm[ 2, 2 ] == ( cFacRecL )->nValImp
                        aTotIvm[ 2, 1 ]      += nTotNFacRec( cFacRecL ) * if( ( cFacRecL )->lVolImp, NotCero( ( cFacRecL )->nVolumen ), 1 )
                        aTotIvm[ 2, 2 ]      := ( cFacRecL )->nValImp
                        aTotIvm[ 2, 3 ]      := aTotIvm[ 2, 1 ] * aTotIvm[ 2, 2 ]

                     case aTotIvm[ 3, 2 ] == 0 .or. aTotIvm[ 3, 2 ] == ( cFacRecL )->nValImp
                        aTotIvm[ 3, 1 ]      += nTotNFacRec( cFacRecL ) * if( ( cFacRecL )->lVolImp, NotCero( ( cFacRecL )->nVolumen ), 1 )
                        aTotIvm[ 3, 2 ]      := ( cFacRecL )->nValImp
                        aTotIvm[ 3, 3 ]      := aTotIvm[ 3, 1 ] * aTotIvm[ 3, 2 ]

                  end case

                end if

            end if

         else

            /*
            Limpien tambien si tenemos una linea de control
            */

            nTotLin  := 0
            nTotUnd  := 0

         end if

      end if

      ( cFacRecL )->( dbSkip() )

   end while

   ( cFacRecL )->( dbGoTo( nRec ) )

   /*
   Ordenamos los impuestosS de menor a mayor-----------------------------------------
   */

   aTotIva           := aSort( aTotIva,,, {|x,y| abs( x[1] ) > abs( y[1] ) } )

   _NBASIVA1         := Round( _NBRTIVA1, nRouDiv )
   _NBASIVA2         := Round( _NBRTIVA2, nRouDiv )
   _NBASIVA3         := Round( _NBRTIVA3, nRouDiv )

   nTotBrt           := _NBASIVA1 + _NBASIVA2 + _NBASIVA3

   /*
   Descuentos de la Facturas---------------------------------------------------
	*/

   if nDtoEsp  != 0

      aTotalDto[1]   := Round( _NBASIVA1 * nDtoEsp / 100, nRouDiv )
      aTotalDto[2]   := Round( _NBASIVA2 * nDtoEsp / 100, nRouDiv )
      aTotalDto[3]   := Round( _NBASIVA3 * nDtoEsp / 100, nRouDiv )

      nTotDto        := aTotalDto[1] + aTotalDto[2] + aTotalDto[3]

		_NBASIVA1		-= aTotalDto[1]
		_NBASIVA2		-= aTotalDto[2]
		_NBASIVA3		-= aTotalDto[3]

   end if

	/*
	Descuentos por Pronto Pago estos son los buenos
	*/

	IF nDtoPP	!= 0

      aTotalDPP[1]   := Round( _NBASIVA1 * nDtoPP / 100, nRouDiv )
      aTotalDPP[2]   := Round( _NBASIVA2 * nDtoPP / 100, nRouDiv )
      aTotalDPP[3]   := Round( _NBASIVA3 * nDtoPP / 100, nRouDiv )

      nTotDPP        := aTotalDPP[1] + aTotalDPP[2] + aTotalDPP[3]

		_NBASIVA1		-= aTotalDPP[1]
		_NBASIVA2		-= aTotalDPP[2]
		_NBASIVA3		-= aTotalDPP[3]

	END IF

	IF nDtoUno != 0

      aTotalUno[1]   := Round( _NBASIVA1 * nDtoUno / 100, nRouDiv )
      aTotalUno[2]   := Round( _NBASIVA2 * nDtoUno / 100, nRouDiv )
      aTotalUno[3]   := Round( _NBASIVA3 * nDtoUno / 100, nRouDiv )

      nTotUno        := aTotalUno[1] + aTotalUno[2] + aTotalUno[3]

		_NBASIVA1		-= aTotalUno[1]
		_NBASIVA2		-= aTotalUno[2]
		_NBASIVA3		-= aTotalUno[3]

	END IF

	IF nDtoDos != 0

      aTotalDos[1]   := Round( _NBASIVA1 * nDtoDos / 100, nRouDiv )
      aTotalDos[2]   := Round( _NBASIVA2 * nDtoDos / 100, nRouDiv )
      aTotalDos[3]   := Round( _NBASIVA3 * nDtoDos / 100, nRouDiv )

      nTotDos        := aTotalDos[1] + aTotalDos[2] + aTotalDos[3]

		_NBASIVA1		-= aTotalDos[1]
		_NBASIVA2		-= aTotalDos[2]
		_NBASIVA3		-= aTotalDos[3]

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
   Una vez echos los descuentos le sumamos los IVMH----------------------------
	*/

   if !lIvaInc .and. uFieldEmpresa( "lIvaImpEsp" )
      _NBASIVA1      += _NIVMIVA1
      _NBASIVA2      += _NIVMIVA2
      _NBASIVA3      += _NIVMIVA3
   end if

   /*
   Calculamos los impuestosS---------------------------------------------------------
   */

   if lIvaInc

      if nRegIva <= 1

         if lRecargo

            aTotalBase[ 1 ]   := _NBASIVA1 - if( _NPCTIVA1 != nil, Round( _NBASIVA1 / ( Div( 100, _NPCTIVA1 + _NPCTREQ1 ) + 1 ), nRouDiv ), 0 )
            aTotalBase[ 2 ]   := _NBASIVA2 - if( _NPCTIVA2 != nil, Round( _NBASIVA2 / ( Div( 100, _NPCTIVA2 + _NPCTREQ2 ) + 1 ), nRouDiv ), 0 )
            aTotalBase[ 3 ]   := _NBASIVA3 - if( _NPCTIVA3 != nil, Round( _NBASIVA3 / ( Div( 100, _NPCTIVA3 + _NPCTREQ3 ) + 1 ), nRouDiv ), 0 )

            _NIMPIVA1         := if( _NPCTIVA1 != NIL, Round( ( aTotalBase[ 1 ] ) * _NPCTIVA1 / 100, nRouDiv ), 0 )
            _NIMPIVA2         := if( _NPCTIVA2 != NIL, Round( ( aTotalBase[ 2 ] ) * _NPCTIVA2 / 100, nRouDiv ), 0 )
            _NIMPIVA3         := if( _NPCTIVA3 != NIL, Round( ( aTotalBase[ 3 ] ) * _NPCTIVA3 / 100, nRouDiv ), 0 )
      
            _NIMPREQ1         := _NBASIVA1 - aTotalBase[ 1 ] - _NIMPIVA1
            _NIMPREQ2         := _NBASIVA2 - aTotalBase[ 2 ] - _NIMPIVA2
            _NIMPREQ3         := _NBASIVA3 - aTotalBase[ 3 ] - _NIMPIVA3

            _NBASIVA1         -= ( _NIMPIVA1 + _NIMPREQ1 ) 
            _NBASIVA2         -= ( _NIMPIVA2 + _NIMPREQ2 )
            _NBASIVA3         -= ( _NIMPIVA3 + _NIMPREQ3 )

         else 

         	if !uFieldEmpresa( "lIvaImpEsp")
         		_NBASIVA1      -= _NIVMIVA1
            	_NBASIVA2      -= _NIVMIVA2
            	_NBASIVA3      -= _NIVMIVA3
         	end if 

            _NIMPIVA1         := if( _NPCTIVA1 != nil .and. _NPCTIVA1 != 0, Round( _NBASIVA1 / ( 100 / _NPCTIVA1 + 1 ), nRouDiv ), 0 )
            _NIMPIVA2         := if( _NPCTIVA2 != nil .and. _NPCTIVA1 != 0, Round( _NBASIVA2 / ( 100 / _NPCTIVA2 + 1 ), nRouDiv ), 0 )
            _NIMPIVA3         := if( _NPCTIVA3 != nil .and. _NPCTIVA1 != 0, Round( _NBASIVA3 / ( 100 / _NPCTIVA3 + 1 ), nRouDiv ), 0 )
      
            _NBASIVA1         -= _NIMPIVA1
            _NBASIVA2         -= _NIMPIVA2
            _NBASIVA3         -= _NIMPIVA3

         end if

      end if

      if uFieldempresa( "lIvaImpEsp")
      	_NBASIVA1            -= _NIVMIVA1
         _NBASIVA2            -= _NIVMIVA2
         _NBASIVA3            -= _NIVMIVA3 
      end if

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

      if uFieldEmpresa( "lIvaImpEsp") 
      	_NBASIVA1            -= _NIVMIVA1
      	_NBASIVA2            -= _NIVMIVA2
      	_NBASIVA3            -= _NIVMIVA3
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

   nTotNet           += nPorte

   /*
   Total punto verde
   */

   nTotPnt           := Round( _NPNTVER1 + _NPNTVER2 + _NPNTVER3, nRouDiv )

   // Total IVMH

   nTotIvm           := Round( aTotIvm[ 1, 3 ] + aTotIvm[ 2, 3 ] + aTotIvm[ 3, 3 ], nRouDiv )

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
   Total retenciones
   */

   nTotRet           := Round( nTotNet * nPctRet / 100, nRouDiv )

   /*
   Total rentabilidad----------------------------------------------------------
   */

   nTotRnt           := Round(         nTotNet - nManObr - nTotAge - nTotPnt - nTotCos, nRouDiv )

   nPctRnt           := nRentabilidad( nTotNet - nManObr - nTotAge - nTotPnt, 0, nTotCos )

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
      nTotDif        := nKgsTrn - nTotPes
   else
      nTotDif        := 0
   end if

   /*
   Total de descuentos de la factura rectificativas----------------------------
   */

   nTotalDto         := nDescuentosLineas + nTotDto + nTotDpp + nTotUno + nTotDos

   /*
   Solicitan una divisa distinta a la q se hizo originalmente la factura
   */

   if cDivRet != nil .and. cDivRet != cCodDiv
      nTotNet     	:= nCnv2Div( nTotNet, cCodDiv, cDivRet )
      nTotIva     	:= nCnv2Div( nTotIva, cCodDiv, cDivRet )
      nTotReq     	:= nCnv2Div( nTotReq, cCodDiv, cDivRet )
      nTotFac     	:= nCnv2Div( nTotFac, cCodDiv, cDivRet )
      nTotRet     	:= nCnv2Div( nTotRet, cCodDiv, cDivRet )
      nTotPnt     	:= nCnv2Div( nTotPnt, cCodDiv, cDivRet )
      nTotTrn     	:= nCnv2Div( nTotTrn, cCodDiv, cDivRet )
      nTotAnt     	:= nCnv2Div( nTotAnt, cCodDiv, cDivRet )
      cPorDiv     	:= cPorDiv( cDivRet, cDiv )
   end if

RETURN ( if( lPic, Trans( nTotFac, cPorDiv ), nTotFac ) ) //

//--------------------------------------------------------------------------//

STATIC FUNCTION RecalculaTotal( aTmp )

   local nPagFacCli     := nPagFacRec( nil, D():FacturasRectificativas( nView ), dbfTmpPgo, dbfIva, dbfDiv, nil, .t. )
   local nTotFacCli     := nTotFacRec( nil, D():FacturasRectificativas( nView ), dbfTmpLin, dbfIva, dbfDiv, aTmp, nil, .f. )

   /*
   Refrescos en Pantalla_______________________________________________________
	*/

   if oBrwIva != nil
      oBrwIva:Refresh()
   end if

   if oGetAge != nil
      oGetAge:SetText( Trans( nTotAge, cPorDiv ) )
   end if

   if oGetNet != nil
      oGetNet:SetText( Trans( nTotNet, cPorDiv ) )
   end if


   IF oGetIva != nil
      oGetIva:SetText( Trans( nTotIva, cPorDiv ) )
   END IF

   IF oGetReq != nil
      oGetReq:SetText( Trans( nTotReq, cPorDiv ) )
   END IF

   IF oGetTotal != nil
      oGetTotal:SetText( Trans( nTotFac, cPorDiv ) )
   END IF

   IF oGetTotPg != nil
      oGetTotPg:SetText( Trans( nTotFac, cPorDiv ) )
   END IF

   IF oGetTotIvm != nil
      oGetTotIvm:SetText( Trans( nTotIvm, cPorDiv ) )
   END IF

   IF oGetTotPnt != nil
      oGetTotPnt:SetText( Trans( nTotPnt, cPorDiv ) )
   END IF

   IF oGetTrn != nil
      oGetTrn:SetText( Trans( nTotTrn, cPorDiv ) )
   END IF

   /*
   Pagos de la factura_________________________________________________________
   */

   if oGetPag != nil
      oGetPag:SetText( Trans( nPagFacCli, cPorDiv ) )
   end if

   if oGetPdt != nil
      oGetPdt:SetText( Trans( nTotFacCli - nPagFacCli, cPorDiv ) )
   end if

   if oGetPes != nil
      oGetPes:cText( nTotPes )
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
Crea las bases de datos necesarias para la facturación desde fuera
*/

FUNCTION mkFacRec( cPath, oMeter, nLenCodCli )

   if oMeter != nil
		oMeter:cText	:= "Generando Bases"
		sysrefresh()
	END IF

   CreateFiles( cPath, .t. )

RETURN NIL

//---------------------------------------------------------------------------//
/*
Regenera indices
*/

FUNCTION rxFacRec( cPath, oMeter, cDriver )

   local cFacRecT
   local dbfFacRecL
   local dbfFacRecI
   local dbfFacRecD
   local dbfFacRecS
   local dbfFacRecE

   DEFAULT cPath     := cPatEmp()
   DEFAULT cDriver   := cDriver()

   /*
   Crea los ficheros si no existen
   */

   if !lExistTable( cPath + "FacRecT.Dbf" )   .or.;
      !lExistTable( cPath + "FacRecL.Dbf" )   .or.;
      !lExistTable( cPath + "FacRecI.Dbf" )   .or.;
      !lExistTable( cPath + "FacRecD.Dbf" )   .or.;
      !lExistTable( cPath + "FacRecS.Dbf" )   .or.;
      !lExistTable( cPath + "FacRecE.Dbf" )
      mkfacrec( cPath, nil, .f. )
   end if

   fEraseIndex( cPath + "FacRecT.Cdx" )
   fEraseIndex( cPath + "FacRecL.Cdx" )
   fEraseIndex( cPath + "FacRecI.Cdx" )
   fEraseIndex( cPath + "FacRecD.Cdx" )
   fEraseIndex( cPath + "FacRecS.Cdx" )
   fEraseIndex( cPath + "FacRecE.Cdx" )

   dbUseArea( .t., cDriver, cPath + "FacRecL.DBF", cCheckArea( "FacRecL", @dbfFacRecL ), .f. )
   if !( dbfFacRecL )->( neterr() )
      ( dbfFacRecL )->( __dbPack() )

      ( dbfFacRecL )->( ordCondSet("!Deleted()", {|| !Deleted() } ) )
      ( dbfFacRecL )->( ordCreate( cPath + "FacRecL.CDX", "NNUMFAC", "CSERIE + Str(NNUMFAC) + CSUFFAC", {|| Field->CSERIE + Str( Field->NNUMFAC ) + Field->CSUFFAC }, ) )

      ( dbfFacRecL )->( ordCondSet("!Deleted()", {|| !Deleted() } ) )
      ( dbfFacRecL )->( ordCreate( cPath + "FacRecL.CDX", "CFACREF", "CSERIE + Str(NNUMFAC) + CSUFFAC + CREF", {|| Field->CSERIE + Str( Field->NNUMFAC ) + Field->CSUFFAC + Field->CREF }, ) )

      ( dbfFacRecL )->( ordCondSet("!Deleted()", {|| !Deleted() } ) )
      ( dbfFacRecL )->( ordCreate( cPath + "FacRecL.CDX", "CREF", "CREF", {|| Field->CREF }, ) )

      ( dbfFacRecL )->( ordCondSet("!Deleted()", {|| !Deleted() } ) )
      ( dbfFacRecL )->( ordCreate( cPath + "FacRecL.CDX", "Lote", "cLote", {|| Field->cLote }, ) )

      ( dbfFacRecL )->( ordCondSet( "nCtlStk < 2 .and. !Deleted()", {|| Field->nCtlStk < 2 .and. !Deleted() }, , , , , , , , , .t. ) )
      ( dbfFacRecL )->( ordCreate( cPath + "FacRecL.Cdx", "cStkFast", "cRef + cAlmLin + dtos( dFecFac ) + tFecFac", {|| Field->cRef + Field->cAlmLin + dtos( Field->dFecFac ) + Field->tFecFac } ) )

      ( dbfFacRecL)->( ordCondSet( "!Deleted()", {|| !Deleted() }  ) )
      ( dbfFacRecL )->( ordCreate( cPath + "FacRecL.Cdx", "iNumFac", "'14' + cSerie + Str( nNumFac ) + Space( 1 ) + cSufFac + Str( nNumLin )", {|| '14' + Field->cSerie + Str( Field->nNumFac ) + Space( 1 ) + Field->cSufFac + Str( Field->nNumLin ) } ) )

      ( dbfFacRecL )->( ordCondSet("!Deleted()", {|| !Deleted() } ) )
      ( dbfFacRecL )->( ordCreate( cPath + "FacRecL.CDX", "nPosPrint", "cSerie + Str(nNumFac) + cSufFac + str( nPosPrint )", {|| Field->cSerie + Str( Field->nNumFac ) + Field->cSufFac + Str( Field->nPosPrint ) }, ) )

      ( dbfFacRecL )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de facturas rectificativas de clientes" )
   end if

   dbUseArea( .t., cDriver, cPath + "FacRecI.DBF", cCheckArea( "FacRecI", @dbfFacRecI ), .f. )
   if !( dbfFacRecI )->( neterr() )
      ( dbfFacRecI )->( __dbPack() )

      ( dbfFacRecI )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfFacRecI )->( ordCreate( cPath + "FacRecI.Cdx", "nNumFac", "cSerie + STR( nNumFac ) + cSufFac", {|| Field->cSerie + Str( Field->nNumFac ) + Field->cSufFac } ) )

      ( dbfFacRecI )->( ordCondSet( "!Deleted()", {|| !Deleted() }  ) )
      ( dbfFacRecI )->( ordCreate( cPath + "FacRecI.Cdx", "iNumFac", "'14' + cSerie + Str( nNumFac ) + Space( 1 ) + cSufFac", {|| '14' + Field->cSerie + Str( Field->nNumFac ) + Space( 1 ) + Field->cSufFac } ) )

      ( dbfFacRecI )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de facturas rectificativas de clientes" )
   end if

   dbUseArea( .t., cDriver, cPath + "FacRecD.DBF", cCheckArea( "FacRecD", @dbfFacRecD ), .f. )
   if !( dbfFacRecD )->( neterr() )
      ( dbfFacRecD )->( __dbPack() )

      ( dbfFacRecD )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfFacRecD )->( ordCreate( cPath + "FacRecD.Cdx", "nNumFac", "cSerFac + STR( nNumFac ) + cSufFac", {|| Field->cSerFac + Str( Field->nNumFac ) + Field->cSufFac } ) )

      ( dbfFacRecD )->( ordCondSet( "!Deleted()", {|| !Deleted() }  ) )
      ( dbfFacRecD )->( ordCreate( cPath + "FacRecD.Cdx", "iNumFac", "'14' + cSerFac + Str( nNumFac ) + Space( 1 ) + cSufFac", {|| '14' + Field->cSerFac + Str( Field->nNumFac ) + Space( 1 ) + Field->cSufFac } ) )

      ( dbfFacRecD )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de facturas rectificativas de clientes" )
   end if

   dbUseArea( .t., cDriver, cPath + "FacRecT.DBF", cCheckArea( "FacRecT", @cFacRecT ), .f. )
   if !( cFacRecT )->( neterr() )
      ( cFacRecT )->( __dbPack() )

      ( cFacRecT )->( ordCondSet("!Deleted()", {|| !Deleted() } ) )
      ( cFacRecT )->( ordCreate( cPath + "FacRecT.CDX", "NNUMFAC", "CSERIE + Str( NNUMFAC ) + CSUFFAC", {|| Field->cSerie + Str( Field->nNumFac ) + Field->cSufFac }, ) )

      ( cFacRecT )->( ordCondSet("!Deleted()", {|| !Deleted() } ) )
      ( cFacRecT )->( ordCreate( cPath + "FacRecT.CDX", "dFecFac", "dFecFac", {|| Field->dFecFac } ) )

      ( cFacRecT )->( ordCondSet("!Deleted()", {|| !Deleted() } ) )
      ( cFacRecT )->( ordCreate( cPath + "FacRecT.CDX", "CCODCLI", "CCODCLI", {|| Field->CCODCLI } ) )

      ( cFacRecT )->( ordCondSet("!Deleted()", {|| !Deleted() } ) )
      ( cFacRecT )->( ordCreate( cPath + "FacRecT.CDX", "CNOMCLI", "Upper( CNOMCLI )", {|| Upper( Field->CNOMCLI ) } ) )

      ( cFacRecT )->( ordCondSet("!Deleted()", {|| !Deleted() } ) )
      ( cFacRecT )->( ordCreate( cPath + "FacRecT.CDX", "CCODOBR", "CCODOBR", {|| Field->CCODOBR } ) )

      ( cFacRecT )->( ordCondSet("!Deleted()", {|| !Deleted() } ) )
      ( cFacRecT )->( ordCreate( cPath + "FacRecT.CDX", "CTURFAC", "CTURFAC + CSUFFAC + CCODCAJ", {|| Field->CTURFAC + Field->CSUFFAC + Field->CCODCAJ } ) )

      ( cFacRecT )->( ordCondSet("!Deleted()", {|| !Deleted() } ) )
      ( cFacRecT )->( ordCreate( cPath + "FacRecT.CDX", "cCodAge", "cCodAge", {|| Field->cCodAge } ) )

      ( cFacRecT )->( ordCondSet("!Deleted()", {|| !Deleted() } ) )
      ( cFacRecT )->( ordCreate( cPath + "FacRecT.CDX", "CCODRUT", "CCODRUT", {|| Field->CCODRUT } ) )

      ( cFacRecT )->( ordCondSet("!Deleted()", {|| !Deleted() } ) )
      ( cFacRecT )->( ordCreate( cPath + "FacRecT.CDX", "cCodPago", "cCodPago", {|| Field->cCodPago } ) )

      ( cFacRecT )->( ordCondSet("!Deleted()", {|| !Deleted() } ) )
      ( cFacRecT )->( ordCreate( cPath + "FacRecT.CDX", "CPOBCLI", "CPOBCLI + CNOMCLI", {|| Field->CPOBCLI + Field->CNOMCLI } ) )

      ( cFacRecT )->( ordCondSet("!Deleted()", {|| !Deleted() } ) )
      ( cFacRecT )->( ordCreate( cPath + "FacRecT.CDX", "CDOCORG", "CDOCORG", {|| Field->CDOCORG } ) )

      ( cFacRecT )->( ordCondSet("!Deleted()", {|| !Deleted() } ) )
      ( cFacRecT )->( ordCreate( cPath + "FacRecT.CDX", "CAGEFEC", "CCODAGE + DtoS( DFECFAC )", {|| Field->CCODAGE + DtoS( Field->DFECFAC ) } ) )

      ( cFacRecT )->( ordCondSet("!Deleted()", {|| !Deleted() } ) )
      ( cFacRecT )->( ordCreate( cPath + "FacRecT.CDX", "NNUMLIQ", "Str( NNUMLIQ ) + CSUFLIQ", {|| Str( Field->NNUMLIQ ) + Field->CSUFLIQ } ) )

      ( cFacRecT )->( ordCondSet("!Deleted()", {|| !Deleted() } ))
      ( cFacRecT )->( ordCreate( cPath + "FacRecT.CDX", "CABNFAC", "CABNFAC", {|| Field->CABNFAC } ) )

      ( cFacRecT )->( ordCondSet("!Deleted()", {|| !Deleted() } ))
      ( cFacRecT )->( ordCreate( cPath + "FacRecT.CDX", "lSndDoc", "lSndDoc", {|| Field->lSndDoc } ) )

      ( cFacRecT )->( ordCondSet("!Deleted()", {|| !Deleted() } ))
      ( cFacRecT )->( ordCreate( cPath + "FacRecT.CDX", "cNumDoc", "cNumDoc", {|| Field->cNumDoc } ) )

      ( cFacRecT )->( ordCondSet( "!Deleted()", {||!Deleted()}  ) )
      ( cFacRecT )->( ordCreate( cPath + "FacRecT.Cdx", "cCodUsr", "Field->cCodUsr + Dtos( Field->dFecCre ) + Field->cTimCre", {|| Field->cCodUsr + Dtos( Field->dFecCre ) + Field->cTimCre } ) )

      ( cFacRecT )->( ordCondSet( "!Deleted()", {||!Deleted()}  ) )
      ( cFacRecT )->( ordCreate( cPath + "FacRecT.Cdx", "cNumFac", "Field->cNumFac", {|| Field->cNumFac } ) )

      ( cFacRecT )->( ordCondSet( "!Deleted()", {|| !Deleted() }  ) )
      ( cFacRecT )->( ordCreate( cPath + "FacRecT.Cdx", "iNumFac", "'14' + cSerie + Str( nNumFac ) + Space( 1 ) + cSufFac", {|| '14' + Field->cSerie + Str( Field->nNumFac ) + Space( 1 ) + Field->cSufFac } ) )

      ( cFacRecT )->( ordCondSet( "!Deleted()", {|| !Deleted() }  ) )
      ( cFacRecT )->( ordCreate( cPath + "FacRecT.Cdx", "cCtrCoste", "cCtrCoste", {|| Field->cCtrCoste } ) )

      ( cFacRecT )->( ordCondSet( "!Deleted()", {|| !Deleted() }  ) )
      ( cFacRecT )->( ordCreate( cPath + "FacRecT.Cdx", "nTotFac", "nTotFac", {|| Field->nTotFac } ) )

      ( cFacRecT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cFacRecT )->( ordCreate( cPath + "FacRecT.CDX", "Poblacion", "UPPER( Field->cPobCli )", {|| UPPER( Field->cPobCli ) } ) )

      ( cFacRecT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cFacRecT )->( ordCreate( cPath + "FacRecT.CDX", "Provincia", "UPPER( Field->cPrvCli )", {|| UPPER( Field->cPrvCli ) } ) )

      ( cFacRecT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cFacRecT )->( ordCreate( cPath + "FacRecT.CDX", "CodPostal", "Field->cPosCli", {|| Field->cPosCli } ) )

      ( cFacRecT )->( ordCondSet("!Deleted()", {|| !Deleted() }, , , , , , , , , .t. ) )
      ( cFacRecT )->( ordCreate( cPath + "FacRecT.CDX", "dDesFec", "dFecFac", {|| Field->dFecFac } ) )

      ( cFacRecT )->( dbCloseArea() )

   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de facturas rectificativas de clientes" )
   end if

   dbUseArea( .t., cDriver, cPath + "FacRecS.Dbf", cCheckArea( "FacRecS", @dbfFacRecS ), .f. )

   if !( dbfFacRecS )->( neterr() )
      ( dbfFacRecS )->( __dbPack() )

      ( dbfFacRecS )->( ordCondSet( "!Deleted()", {||!Deleted()}  ) )
      ( dbfFacRecS )->( ordCreate( cPath + "FacRecS.Cdx", "nNumFac", "cSerFac + Str( nNumFac ) + cSufFac + Str( nNumLin )", {|| Field->cSerFac + Str( Field->nNumFac ) + Field->cSufFac + Str( Field->nNumLin ) } ) )

      ( dbfFacRecS )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( dbfFacRecS )->( ordCreate( cPath + "FacRecS.Cdx", "cRefSer", "cRef + cAlmLin + cNumSer", {|| Field->cRef + Field->cAlmLin + Field->cNumSer } ) )

      ( dbfFacRecS )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( dbfFacRecS )->( ordCreate( cPath + "FacRecS.CDX", "cNumSer", "cNumSer", {|| Field->cNumSer } ) )

      ( dbfFacRecS )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( dbfFacRecS )->( ordCreate( cPath + "FacRecS.Cdx", "iNumFac", "'14' + cSerFac + Str( nNumFac ) + Space( 1 ) + cSufFac", {|| '14' + Field->cSerFac + Str( Field->nNumFac ) + Space( 1 ) + Field->cSufFac } ) )

      ( dbfFacRecS )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de números de series de facturas rectificativas de clientes" )
   end if

   dbUseArea( .t., cDriver, cPath + "FacRecE.Dbf", cCheckArea( "FacRecE", @dbfFacrecE ), .f. )

   if !( dbfFacrecE )->( neterr() )
      ( dbfFacrecE )->( __dbPack() )

      ( dbfFacrecE )->( ordCondSet( "!Deleted()", {||!Deleted()}  ) )
      ( dbfFacrecE )->( ordCreate( cPath + "FacRecE.Cdx", "nNumFac", "cSerFac + str( nNumFac ) + cSufFac", {|| Field->cSerFac + str( Field->nNumFac ) + Field->cSufFac } ) )

      ( dbfFacrecE )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( dbfFacrecE )->( ordCreate( cPath + "FacRecE.Cdx", "cSitua", "cSitua", {|| Field->cSitua } ) )

      ( dbfFacrecE )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( dbfFacrecE )->( ordCreate( cPath + "FacRecE.Cdx", "idPs", "str( idPs )", {|| str( Field->idPs ) } ) )

      ( dbfFacrecE )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de entidades de facturas de clientes" )
   end if

Return nil

//--------------------------------------------------------------------------//

/*
Devuelve la fecha de una factura de cliente
*/

FUNCTION dFecFacRec( cFacRec, cFacRecT )

   local aStatus
	local dFecFac	:= CtoD("")
	
   if IsObject( cFacRecT )

      cFacRecT:GetStatus( .t. )

      if cFacRecT:Seek( cFacRec )
         dFecFac  := cFacRecT:dFecFac
      end if

      cFacRecT:SetStatus()

   else

      aStatus     := aGetStatus( cFacRecT, .t. )
      
      if ( cFacRecT )->( dbSeek( cFacRec ) )
         dFecFac  := ( cFacRecT )->dFecFac
      end if

      SetStatus( cFacRecT, aStatus )

   end if

RETURN ( dFecFac )

//--------------------------------------------------------------------------//

/*
Devuelve la hora de una factura rectificativa de cliente
*/

FUNCTION tFecFacRec( cFacRec, cFacRecT )

   local aStatus
   local tFecFac	:= Replicate( "0", 6 )

   if IsObject( cFacRecT )
      cFacRecT:GetStatus( .t. )
      if cFacRecT:Seek( cFacRec )
         tFecFac  := cFacRecT:tFecFac
      end if
      cFacRecT:SetStatus()
   else
      aStatus     := aGetStatus( cFacRecT, .t. )
      if ( cFacRecT )->( dbSeek( cFacRec ) )
         tFecFac  := ( cFacRecT )->tFecFac
      end if
      SetStatus( cFacRecT, aStatus )
   end if

RETURN ( tFecFac )

//----------------------------------------------------------------------------//
/*
Devuelve el codigo del Cliente pasando un numero de factura
*/

FUNCTION cCliFacRec( cFacRecT, uFacRecT )

   local cCodCli  := ""

   do case
      case ValType( uFacRecT ) == "C"
         if (uFacRecT)->( dbSeek( cFacRecT ) )
            cCodCli     := (uFacRecT)->CCODCLI
         end if
      case ValType( uFacRecT ) == "O"
         if uFacRecT:Seek( cFacRecT )
            cCodCli     := uFacRecT:cCodCli
         end if
   end case

RETURN ( cCodCli )

//----------------------------------------------------------------------------//

/*
Devuelve el Nombre del cliente pasando un numero de factura
*/

FUNCTION cNbrFacRec( cFacRec, cFacRecT )

   local cNomCli  := ""

   if ( cFacRecT )->( dbSeek( cFacRecT ) )
      cNomCli     := ( cFacRecT )->CNOMCLI
	END IF

RETURN ( cNomCli )

//---------------------------------------------------------------------------//

/*
Devuelve la forma de pago pasando un numero de factura
*/

FUNCTION cPgoFacRec( cFacRec, cFacRecT )

   local cCodPgo  := ""

   if ValType( cFacRecT ) == "O"
      if cFacRecT:Seek( cFacRecT )
         cCodPgo  := cFacRecT:cCodPago
      end if
   else
      if ( cFacRecT )->( dbSeek( cFacRecT ) )
         cCodPgo  := ( cFacRecT )->cCodPago
      end if
   end if

RETURN ( cCodPgo )

//----------------------------------------------------------------------------//

FUNCTION cProFacRec( cFacRec, cFacRecT )

   local cCodPro  := ""

   if ( cFacRecT )->( dbSeek( cFacRecT ) )
      cCodPro     := ( cFacRecT )->CCODPRO
	END IF

RETURN ( cCodPro )

//----------------------------------------------------------------------------//
/*
Devuelve si la factura esta contabilizada o no
*/

FUNCTION lConFacRec( cFacRec, cFacRecT )

   local lConFac  := .f.

   if ( cFacRecT )->( dbSeek( cFacRecT ) )
      lConFac     := ( cFacRecT )->lContab
	END IF

RETURN ( lConFac )

//----------------------------------------------------------------------------//
/*
Devuelve el codigo de cliente de una factura
*/

FUNCTION cAgeFacRec( cFacRec, cFacRecT )

   local cCliFac  := ""

   if ValType( cFacRecT ) == "O"
      if cFacRecT:Seek( cFacRecT )
         cCliFac  := cFacRecT:cCodAge
      end if
   else
      if ( cFacRecT )->( dbSeek( cFacRecT ) )
         cCliFac  := ( cFacRecT )->cCodAge
      end if
   end if

RETURN ( cCliFac )

//---------------------------------------------------------------------------//

//
// Devuelve el total de la compra en facturas de proveedores de un articulo
//

function nTotDFacRec( cCodArt, dbfFacRecL, cCodAlm )

   local nOrd     := ( dbfFacRecL )->( OrdSetFocus( "cRef" ) )
   local nRec     := ( dbfFacRecL )->( Recno() )
   local nTotVta  := 0

   if ( dbfFacRecL )->( dbSeek( cCodArt ) )

      while ( dbfFacRecL )->CREF == cCodArt .and. !( dbfFacRecL )->( eof() )

         if !( dbfFacRecL )->LTOTLIN
            if cCodAlm != nil
               if cCodAlm == ( dbfFacRecL )->cAlmLin
                  nTotVta  += nTotNFacRec( dbfFacRecL ) * NotCero( ( dbfFacRecL )->nFacCnv )
               end if
            else
               nTotVta     += nTotNFacRec( dbfFacRecL ) * NotCero( ( dbfFacRecL )->nFacCnv )
            end if
         end if

         ( dbfFacRecL )->( dbSkip() )

      end while

   end if

   ( dbfFacRecL )->( OrdSetFocus( nOrd  ) )
   ( dbfFacRecL )->( dbGoTo( nRec ) )

return ( nTotVta )

//---------------------------------------------------------------------------//

FUNCTION nVolLFacRec( dbfLin )

   local nCalculo    := 0

   if !( dbfLin )->lTotLin
      nCalculo       := nTotNFacRec( dbfLin ) * ( dbfLin )->nVolumen
   end if

RETURN ( nCalculo )

//---------------------------------------------------------------------------//
/*
Devuelve el total de una linea con impuestos incluidos
*/

FUNCTION nTotFFacRec( cFacRecL, nDec, nRouDec, nVdv, lDto, lPntVer, lImpTrn, cPorDiv )

   local nCalculo := 0

   nCalculo       += nTotLFacRec( cFacRecL, nDec, nRouDec, nVdv, lDto, lPntVer, lImpTrn )
   nCalculo       += nIvaLFacRec( cFacRecL, nDec, nRouDec, nVdv, lDto, lPntVer, lImpTrn )

return ( if( cPorDiv != nil, Trans( nCalculo, cPorDiv ), nCalculo ) )

//----------------------------------------------------------------------------//

FUNCTION nTotPFacRec( cFacRecL, nDec, nVdv, cPorDiv )

   local nCalculo

   DEFAULT cFacRecL  := D():FacturasRectificativasLineas( nView )
   DEFAULT nDec      := nDouDiv()
   DEFAULT nVdv      := 1

   if ( cFacRecL )->lTotLin

      nCalculo       := nTotUFacRec( cFacRecL, nDec )

   else

      /*
      Tomamos los valores redondeados------------------------------------------
      */

      nCalculo       := nTotUFacRec( cFacRecL, nDec )
      nCalculo       -= Round( ( cFacRecL )->nDtoDiv , nDec )

      if ( cFacRecL )->nDto != 0
         nCalculo    -= nCalculo * ( cFacRecL )->nDto / 100
      end if

      if ( cFacRecL )->nDtoPrm != 0
         nCalculo    -= nCalculo * ( cFacRecL )->nDtoPrm / 100
      end if

   end if

   nCalculo          := Round( nCalculo / nVdv, nDec )

RETURN ( if( cPorDiv != nil, Trans( nCalculo, cPorDiv ), nCalculo ) )


//---------------------------------------------------------------------------//
/*
Devuelve el importe de descuento porcentual por cada linea---------------------
*/

FUNCTION nDtoLFacRec( cFacRecL, nDec, nRou, nVdv )

   local nCalculo       := 0

   DEFAULT cFacRecL     := D():FacturasRectificativasLineas( nView )
   DEFAULT nDec         := nDouDiv()
   DEFAULT nRou         := nRouDiv()
   DEFAULT nVdv         := 1

   if ( cFacRecL )->nDto != 0 .and. !( cFacRecL )->lTotLin

      nCalculo          := nTotUFacRec( cFacRecL, nDec ) * nTotNFacRec( cFacRecL )

      /*
      Descuentos---------------------------------------------------------------
      */

      nCalculo          -= Round( ( cFacRecL )->nDtoDiv / nVdv , nDec )

      nCalculo          := nCalculo * ( cFacRecL )->nDto / 100


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

FUNCTION nPrmLFacRec( cFacRecL, nDec, nRou, nVdv )

   local nCalculo       := 0

   DEFAULT cFacRecL     := D():FacturasRectificativasLineas( nView )
   DEFAULT nDec         := nDouDiv()
   DEFAULT nRou         := nRouDiv()
   DEFAULT nVdv         := 1

   if ( cFacRecL )->nDtoPrm != 0 .and. !( cFacRecL )->lTotLin

      nCalculo          := nTotUFacRec( cFacRecL, nDec ) * nTotNFacRec( cFacRecL )

      /*
      Descuentos---------------------------------------------------------------
      */

      nCalculo          -= Round( ( cFacRecL )->nDtoDiv / nVdv , nDec )

      if ( cFacRecL )->nDto != 0 
         nCalculo       -= nCalculo * ( cFacRecL )->nDto / 100
      end if

      nCalculo          := nCalculo * ( cFacRecL )->nDtoPrm / 100

      if nVdv != 0
         nCalculo       := nCalculo / nVdv
      end if

      if nRou != nil
         nCalculo       := Round( nCalculo, nRou )
      end if

   end if

RETURN ( nCalculo ) 


//---------------------------------------------------------------------------//

Function nTotDtoLFacRec( cFacRecL, nDec, nVdv, cPorDiv )

   local nCalculo

   DEFAULT cFacRecL  := D():FacturasRectificativasLineas( nView )
   DEFAULT nDec      := nDouDiv()
   DEFAULT nVdv      := 1

   nCalculo          := nDtoLFacRec( cFacRecL, nDec, nVdv ) * nTotNFacRec( cFacRecL )

   if nVdv != 0
      nCalculo       := nCalculo / nVdv
   end if

   nCalculo          := Round( nCalculo, nDec )

RETURN ( if( cPorDiv != nil, Trans( nCalculo, cPorDiv ), nCalculo ) )

//----------------------------------------------------------------------------//

FUNCTION sTotLFacRec( dbfLin, nDec, nRou, nVdv, lDto, lPntVer, lImpTrn, cPorDiv )

   local uTotLFacRec
   local nTotLFacRec := nTotLFacRec( dbfLin, nDec, nRou, nVdv, lDto, lPntVer, lImpTrn )

   if nTotLFacRec == 0 .and. !( dbfLin )->lControl
      uTotLFacRec    := "S/C"
   else
      uTotLFacRec    := if( cPorDiv != NIL, Trans( nTotLFacRec, cPorDiv ), nTotLFacRec )
   end if

RETURN ( uTotLFacRec )

//----------------------------------------------------------------------------//

FUNCTION nTotIFacRec( dbfLin, nDec, nRouDec, nVdv, cPorDiv )

   local nCalculo    := 0

   DEFAULT dbfLin    := D():FacturasRectificativasLineas( nView )
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

      nCalculo       *= nTotNFacRec( dbfLin )

      if ( dbfLin )->lVolImp
         nCalculo    *= NotCero( ( dbfLin )->nVolumen )
      end if

      nCalculo       := Round( nCalculo / nVdv, nRouDec )

   end if

RETURN ( if( cPorDiv != nil, Trans( nCalculo, cPorDiv ), nCalculo ) )

//----------------------------------------------------------------------------//

FUNCTION nImpUFacRec( uFacRecT, uFacRecL, nDec, nVdv, lIva )

   local lIvaInc
   local nCalculo

   DEFAULT nDec   := 0
   DEFAULT nVdv   := 1
   DEFAULT lIva   := .f.

   nCalculo       := nTotUFacRec( uFacRecL, nDec, nVdv )

   if IsArray( uFacRecT )

      nCalculo    -= Round( nCalculo * uFacRecT[ _NDTOESP ]  / 100, nDec )
      nCalculo    -= Round( nCalculo * uFacRecT[ _NDPP    ]  / 100, nDec )
      nCalculo    -= Round( nCalculo * uFacRecT[ _NDTOUNO ]  / 100, nDec )
      nCalculo    -= Round( nCalculo * uFacRecT[ _NDTODOS ]  / 100, nDec )
      lIvaInc     := uFacRecT[ _LIVAINC ]

   else

      nCalculo    -= Round( nCalculo * ( uFacRecT )->nDtoEsp / 100, nDec )
      nCalculo    -= Round( nCalculo * ( uFacRecT )->nDpp    / 100, nDec )
      nCalculo    -= Round( nCalculo * ( uFacRecT )->nDtoUno / 100, nDec )
      nCalculo    -= Round( nCalculo * ( uFacRecT )->nDtoDos / 100, nDec )
      lIvaInc     := ( uFacRecT )->lIvaInc

   end if

   if IsArray( uFacRecL )

      if lIva .and. uFacRecL[ _NIVA ] != 0
         if !lIvaInc
            nCalculo    += nCalculo * uFacRecL[ _NIVA ] / 100
         end if
      else
         if lIvaInc .and. uFacRecL[ _NIVA ] != 0
            nCalculo    -= Round( nCalculo / ( 100 / uFacRecL[ _NIVA ] + 1 ), nDec )
         end if
      end if

   else

      if lIva .and. ( uFacRecL )->nIva != 0
         if !lIvaInc
            nCalculo    += nCalculo * ( uFacRecL )->nIva / 100
         end if
      else
         if lIvaInc .and. ( uFacRecL )->nIva != 0
            nCalculo    -= Round( nCalculo / ( 100 / ( uFacRecL )->nIva + 1 ), nDec )
         end if
      end if

   end if

RETURN ( Round( nCalculo, nDec ) )

//---------------------------------------------------------------------------//

//
// Devuelve el importe real de una linea de articulo
//

FUNCTION nImpLFacRec( uFacRecT, dbfFacRecL, nDec, nRou, nVdv, lIva, lDto, lPntVer, lImpTrn, cPouDiv )

   local lIvaInc
   local nCalculo

   DEFAULT nDec   := 0
   DEFAULT nRou   := 0
   DEFAULT nVdv   := 1
   DEFAULT lIva   := .f.
   DEFAULT lDto   := .t.
   DEFAULT lPntVer:= .f.
   DEFAULT lImpTrn:= .f.

   nCalculo       := nTotLFacRec( dbfFacRecL, nDec, nRou, nVdv, .t., lPntVer, lImpTrn )

   if ValType( uFacRecT ) == "A"
      nCalculo    -= Round( nCalculo * uFacRecT[ _NDTOESP ]  / 100, nRou )
      nCalculo    -= Round( nCalculo * uFacRecT[ _NDPP    ]  / 100, nRou )
      nCalculo    -= Round( nCalculo * uFacRecT[ _NDTOUNO ]  / 100, nRou )
      nCalculo    -= Round( nCalculo * uFacRecT[ _NDTODOS ]  / 100, nRou )
      lIvaInc     := uFacRecT[ _LIVAINC ]
   else
      nCalculo    -= Round( nCalculo * ( uFacRecT )->nDtoEsp / 100, nRou )
      nCalculo    -= Round( nCalculo * ( uFacRecT )->nDpp    / 100, nRou )
      nCalculo    -= Round( nCalculo * ( uFacRecT )->nDtoUno / 100, nRou )
      nCalculo    -= Round( nCalculo * ( uFacRecT )->nDtoDos / 100, nRou )
      lIvaInc     := ( uFacRecT )->lIvaInc
   end if

   if lIva .and. ( dbfFacRecL )->nIva != 0
      if !lIvaInc
         nCalculo += nCalculo * ( dbfFacRecL )->nIva / 100
      end if
   else
      if lIvaInc .and. ( dbfFacRecL )->nIva != 0
         nCalculo -= Round( nCalculo / ( 100 / ( dbfFacRecL )->nIva + 1 ), nRou )
      end if
   end if

RETURN ( if( cPouDiv != nil, Trans( nCalculo, cPouDiv ), nCalculo ) )

//---------------------------------------------------------------------------//
//
// Devuelve el neto de una linea de articulo
//

FUNCTION nNetLFacRec( dbfFacRecL, nDec, nRou, nVdv, lDto, lPntVer, lImpTrn, cPouDiv )

   local nCalculo

   DEFAULT nDec   := 2
   DEFAULT nVdv   := 1
   DEFAULT lDto   := .t.
   DEFAULT lPntVer:= .t.

   nCalculo       := nTotLFacRec( dbfFacRecL, nDec, nRou, nVdv, lDto, lPntVer, lImpTrn )

   if ( dbfFacRecL )->nIva != 0 .and. ( dbfFacRecL )->lIvaLin
      if nRou != nil
         nCalculo -= Round( nCalculo / ( 100 / ( dbfFacRecL )->nIva + 1 ), nRou )
      else
         nCalculo -= ( nCalculo / ( 100 / ( dbfFacRecL )->nIva + 1 ) )
      end if
   end if

RETURN ( if( cPouDiv != NIL, Trans( nCalculo, cPouDiv ), nCalculo ) )

//---------------------------------------------------------------------------//

function nVtaFacRec( cCodCli, dDesde, dHasta, cFacRecT, dbfFacRecL, dbfIva, dbfDiv, nYear )

   local nCon     := 0
   local nOrd     := ( cFacRecT )->( OrdSetFocus( "CCODCLI" ) )
   local nRec     := ( cFacRecT )->( Recno() )

   /*
   Facturas a Clientes -------------------------------------------------------
   */

   if ( cFacRecT )->( dbSeek( cCodCli ) )

      while ( cFacRecT )->cCodCli = cCodCli .and. !( cFacRecT )->( Eof() )

         if ( dDesde == nil .or. ( cFacRecT )->DFECFAC >= dDesde ) .and.;
            ( dHasta == nil .or. ( cFacRecT )->DFECFAC <= dHasta ) .and.;
            ( nYear == nil .or. Year( ( cFacRecT )->dFecFac ) == nYear )

            nCon  += nTotFacRec( ( cFacRecT )->cSerie + Str( ( cFacRecT )->nNumFac ) + ( cFacRecT )->cSufFac, cFacRecT, dbfFacRecL, dbfIva, dbfDiv, nil, cDivEmp(), .f. )

         end if

         ( cFacRecT )->( dbSkip() )

         SysRefresh()

      end while

   end if

   ( cFacRecT )->( OrdSetFocus( nOrd ) )
   ( cFacRecT )->( dbGoTo( nRec ) )

return nCon

//----------------------------------------------------------------------------//

//
// Devuelve las unidades de una linea
//

FUNCTION nTotNFacRec( uDbf )

   local nTotUnd

   DEFAULT uDbf   := D():FacturasRectificativasLineas( nView )

   do case
   case ValType( uDbf ) == "C"
      nTotUnd     := NotCaja( ( uDbf )->nCanEnt )
      nTotUnd     *= ( uDbf )->nUniCaja
      nTotUnd     *= NotCero( ( uDbf )->nUndKit )
      nTotUnd     *= NotCero( ( uDbf )->nMedUno )
      nTotUnd     *= NotCero( ( uDbf )->nMedDos )
      nTotUnd     *= NotCero( ( uDbf )->nMedTre )

   case ValType( uDbf ) == "A"
      nTotUnd     := NotCaja( uDbf[ _NCANENT ] )
      nTotUnd     *= uDbf[ _NUNICAJA ]
      nTotUnd     *= NotCero( uDbf[ _NUNDKIT ] )
      nTotUnd     *= NotCero( uDbf[ _NMEDUNO ] )
      nTotUnd     *= NotCero( uDbf[ _NMEDDOS ] )
      nTotUnd     *= NotCero( uDbf[ _NMEDTRE ] )

   otherwise
      nTotUnd     := NotCaja( uDbf:nCanEnt )
      nTotUnd     *= uDbf:nUniCaja
      nTotUnd     *= NotCero( uDbf:nUndKit )
      nTotUnd     *= NotCero( uDbf:nMedUno )
      nTotUnd     *= NotCero( uDbf:nMedDos )
      nTotUnd     *= NotCero( uDbf:nMedTre )

   end case

RETURN ( nTotUnd )

//--------------------------------------------------------------------------//

Function nTotVFacRec( uDbf )

   local nTotUnd

   DEFAULT uDbf   := D():FacturasRectificativasLineas( nView )

   do case
      case ValType( uDbf ) == "A"

         nTotUnd  := nTotNFacRec( uDbf ) * NotCero( uDbf[ _NFACCNV ] )

      case ValType( uDbf ) == "C"

         nTotUnd  := nTotNFacRec( uDbf ) * NotCero( ( uDbf )->nFacCnv )

      otherwise

         nTotUnd  := nTotNFacRec( uDbf ) * NotCero( uDbf:nFacCnv )

   end case

Return ( nTotUnd )

//--------------------------------------------------------------------------//

Static function lImpLin( dbfTmpLin, oBrwDet )

   ( dbfTmpLin )->lImpLin  := !( dbfTmpLin )->lImpLin

   oBrwDet:Refresh()

Return nil

//---------------------------------------------------------------------------//

FUNCTION aDocFacRec()

   local aDoc  := {}

   /*
   Itmes-----------------------------------------------------------------------
   */

   aAdd( aDoc, { "Empresa",         "EM" } )
   aAdd( aDoc, { "Factura Rec.",    "FR" } )
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

function aItmFacRec()

   local aItmFacRec  := {}

   aAdd( aItmFacRec, { "cSerie"      ,"C",  1, 0, "Serie de la factura " ,                                   "Serie",                   "", "( cDbf )", nil } )
   aAdd( aItmFacRec, { "nNumFac"     ,"N",  9, 0, "Número de la factura" ,                                   "Numero",                  "", "( cDbf )", nil } )
   aAdd( aItmFacRec, { "cSufFac"     ,"C",  2, 0, "Sufijo de la factura" ,                                   "Sufijo",                  "", "( cDbf )", nil } )
   aAdd( aItmFacRec, { "cGuid"       ,"C", 40, 0, "Guid de la factura" ,                                     "GUID",                        "", "( cDbf )", {|| win_uuidcreatestring() } } )
   aAdd( aItmFacRec, { "cTurFac"     ,"C",  6, 0, "Sesión de la factura" ,                                   "Turno",                   "", "( cDbf )", nil } )
   aAdd( aItmFacRec, { "dFecFac"     ,"D",  8, 0, "Fecha de la factura" ,                                    "Fecha",                   "", "( cDbf )", nil } )
   aAdd( aItmFacRec, { "cCodCli"     ,"C", 12, 0, "Código del cliente" ,                                     "Cliente",                 "", "( cDbf )", nil } )
   aAdd( aItmFacRec, { "cCodAlm"     ,"C", 16, 0, "Código de almacén" ,                                      "Almacen",                 "", "( cDbf )", nil } )
   aAdd( aItmFacRec, { "cCodCaj"     ,"C",  3, 0, "Código de caja" ,                                         "Caja",                    "", "( cDbf )", nil } )
   aAdd( aItmFacRec, { "cNomCli"     ,"C", 80, 0, "Nombre del cliente" ,                                     "NombreCliente",           "", "( cDbf )", nil } )
   aAdd( aItmFacRec, { "cDirCli"     ,"C",100, 0, "Domicilio del cliente" ,                                  "DomicilioCliente",        "", "( cDbf )", nil } )
   aAdd( aItmFacRec, { "cPobCli"     ,"C", 25, 0, "Población del cliente" ,                                  "PoblacionCliente",        "", "( cDbf )", nil } )
   aAdd( aItmFacRec, { "cPrvCli"     ,"C", 20, 0, "Provincia del cliente" ,                                  "",                        "", "( cDbf )", nil } )
   aAdd( aItmFacRec, { "nCodProv"    ,"N",  2, 0, "Número de provincia cliente" ,                            "ProvinciaCliente",        "", "( cDbf )", nil } )
   aAdd( aItmFacRec, { "cPosCli"     ,"C", 15, 0, "Código postal del cliente" ,                              "CodigoPostalCliente",     "", "( cDbf )", nil } )
   aAdd( aItmFacRec, { "cDniCli"     ,"C", 30, 0, "DNI/Cif del cliente" ,                                    "DniCliente",              "", "( cDbf )", nil } )
   aAdd( aItmFacRec, { "lModCli"     ,"L",  1, 0, "Lógico de modificar datos del cliente" ,                  "ModificarDatosCliente",   "", "( cDbf )", nil } )
   aAdd( aItmFacRec, { "lMayor"      ,"L",  1, 0, "Lógico de mayorista" ,                                    "",                        "", "( cDbf )", nil } )
   aAdd( aItmFacRec, { "nTarifa"     ,"N",  1, 0, "Tarifa de precio aplicada" ,                              "NumeroTarifa",            "", "( cDbf )", nil } )
   aAdd( aItmFacRec, { "cCodAge"     ,"C",  3, 0, "Código del agente" ,                                      "Agente",                  "", "( cDbf )", nil } )
   aAdd( aItmFacRec, { "cCodRut"     ,"C",  4, 0, "Código de la ruta" ,                                      "Ruta",                    "", "( cDbf )", nil } )
   aAdd( aItmFacRec, { "cCodTar"     ,"C",  5, 0, "Código de la tarifa" ,                                    "Tarifa",                  "", "( cDbf )", nil } )
   aAdd( aItmFacRec, { "cCodObr"     ,"C", 10, 0, "Código de la dirección" ,                                 "Direccion",               "", "( cDbf )", nil } )
   aAdd( aItmFacRec, { "nPctComAge"  ,"N",  6, 2, "Porcentaje de comisión del agente" ,                      "ComisionAgente",          "", "( cDbf )", nil } )
   aAdd( aItmFacRec, { "lLiquidada"  ,"L",  1, 0, "Lógico de la liquidación" ,                               "",                        "", "( cDbf )", nil } )
   aAdd( aItmFacRec, { "lContab"     ,"L",  1, 0, "Lógico de la contabilización" ,                           "Contabilizada",           "", "( cDbf )", nil } )
   aAdd( aItmFacRec, { "cConGuid"    ,"C", 40, 0, "Guid del apunte contable" ,                               "GuidApunteContable",      "", "( cDbf )", nil } )
   aAdd( aItmFacRec, { "dFecEnt"     ,"D",  8, 0, "Fecha de entrega" ,                                       "FechaEntrega",            "", "( cDbf )", nil } )
   aAdd( aItmFacRec, { "cSufac"      ,"C", 10, 0, "Su factura" ,                                             "SuFactura",               "", "( cDbf )", nil } )
   aAdd( aItmFacRec, { "lImpAlb"     ,"L",  1, 0, "Lógico si la factura se importó de albaranes" ,           "ImportadaAlbaran",        "", "( cDbf )", nil } )
   aAdd( aItmFacRec, { "cCondEnt"    ,"C",100, 0, "Condición de entrada" ,                                   "CondicionEntrada",        "", "( cDbf )", nil } )
   aAdd( aItmFacRec, { "mComent"     ,"M", 10, 0, "Comentarios" ,                                            "Comentarios",             "", "( cDbf )", nil } )
   aAdd( aItmFacRec, { "mObserv"     ,"M", 10, 0, "Observaciones" ,                                          "Observaciones",           "", "( cDbf )", nil } )
   aAdd( aItmFacRec, { "cCodPago"    ,"C",  2, 0, "Código del tipo de pago" ,                                "Pago",                    "", "( cDbf )", nil } )
   aAdd( aItmFacRec, { "nBultos"     ,"N",  5, 0, "Número de bultos" ,                                       "Bultos",                  "", "( cDbf )", nil } )
   aAdd( aItmFacRec, { "nPortes"     ,"N",  6, 0, "Valor del porte" ,                                        "Portes",                  "", "( cDbf )", nil } )
   aAdd( aItmFacRec, { "nIvaMan"     ,"N",  6, 2, "Porcentaje de " + cImp() + " del gasto" ,                 "ImpuestoGastos",          "", "( cDbf )", nil } )
   aAdd( aItmFacRec, { "nManObr"     ,"N", 16, 6, "Gastos" ,                                                 "Gastos",                  "", "( cDbf )", nil } )
   aAdd( aItmFacRec, { "cNumFac"     ,"C", 12, 0, "Número de factura" ,                                      "NumeroFactura",           "", "( cDbf )", nil } )
   aAdd( aItmFacRec, { "nTipoFac"    ,"N",  1, 0, "" ,                                                       "",                        "", "( cDbf )", nil } )
   aAdd( aItmFacRec, { "cDtoEsp"     ,"C", 50, 0, "Descripción de porcentaje de descuento especial" ,        "DescripcionDescuento1",   "", "( cDbf )", nil } )
   aAdd( aItmFacRec, { "nDtoEsp"     ,"N",  6, 2, "Porcentaje de descuento especial" ,                       "PorcentajeDescuento1",    "", "( cDbf )", nil } )
   aAdd( aItmFacRec, { "cDpp"        ,"C", 50, 0, "Descripción de porcentaje de descuento por pronto pago",  "DescripcionDescuento2",   "", "( cDbf )", nil } )
   aAdd( aItmFacRec, { "nDpp"        ,"N",  6, 2, "Porcentaje de descuento por pronto pago" ,                "PorcentajeDescuento2",    "", "( cDbf )", nil } )
   aAdd( aItmFacRec, { "cDtoUno"     ,"C", 25, 0, "Descripción de porcentaje de descuento personalizado",    "DescripcionDescuento3",   "", "( cDbf )", nil } )
   aAdd( aItmFacRec, { "nDtoUno"     ,"N",  6, 2, "Porcentaje de descuento por descuento personalizado" ,    "PorcentajeDescuento3",    "", "( cDbf )", nil } )
   aAdd( aItmFacRec, { "cDtoDos"     ,"C", 25, 0, "Descripción de porcentaje de descuento personalizado" ,   "DescripcionDescuento4",   "", "( cDbf )", nil } )
   aAdd( aItmFacRec, { "nDtoDos"     ,"N",  4, 1, "Porcentaje de descuento por descuento personalizado" ,    "PorcentajeDescuento4",    "", "( cDbf )", nil } )
   aAdd( aItmFacRec, { "nDtoCnt"     ,"N",  6, 2, "" ,                                                       "",                        "", "( cDbf )", nil } )
   aAdd( aItmFacRec, { "nDtoRap"     ,"N",  6, 2, "" ,                                                       "",                        "", "( cDbf )", nil } )
   aAdd( aItmFacRec, { "nDtoPub"     ,"N",  6, 2, "" ,                                                       "",                        "", "( cDbf )", nil } )
   aAdd( aItmFacRec, { "nDtoPgo"     ,"N",  6, 2, "" ,                                                       "",                        "", "( cDbf )", nil } )
   aAdd( aItmFacRec, { "nDtoPtf"     ,"N",  7, 2, "" ,                                                       "",                        "", "( cDbf )", nil } )
   aAdd( aItmFacRec, { "nTipoIva"    ,"N",  1, 0, "" ,                                                       "",                        "", "( cDbf )", nil } )
   aAdd( aItmFacRec, { "nPorcIva"    ,"N",  4, 1, "" ,                                                       "",                        "", "( cDbf )", nil } )
   aAdd( aItmFacRec, { "lRecargo"    ,"L",  1, 0, "Lógico para recargo" ,                                    "RecargoEquivalencia",     "", "( cDbf )", nil } )
   aAdd( aItmFacRec, { "cRemitido"   ,"C", 50, 0, "Campo de remitido" ,                                      "Remitido",                "", "( cDbf )", nil } )
   aAdd( aItmFacRec, { "lIvaInc"     ,"L",  1, 0, cImp() + " incluido" ,                                     "ImpuestosIncluidos",      "", "( cDbf )", nil } )
   aAdd( aItmFacRec, { "lSndDoc"     ,"L",  1, 0, "Lógico para documento enviado" ,                          "Envio",                   "", "( cDbf )", nil } )
   aAdd( aItmFacRec, { "cDivFac"     ,"C",  3, 0, "Código de la divisa" ,                                    "Divisa",                  "", "( cDbf )", nil } )
   aAdd( aItmFacRec, { "nVdvFac"     ,"N", 10, 4, "Cambio de la divisa" ,                                    "ValorDivisa",             "", "( cDbf )", nil } )
   aAdd( aItmFacRec, { "cRetPor"     ,"C",100, 0, "Retirado por" ,                                           "RetiradoPor",             "", "( cDbf )", nil } )
   aAdd( aItmFacRec, { "cRetMat"     ,"C", 20, 0, "Matrícula" ,                                              "Matricula",               "", "( cDbf )", nil } )
   aAdd( aItmFacRec, { "cNumDoc"     ,"C", 13, 0, "" ,                                                       "",                        "", "( cDbf )", nil } )
   aAdd( aItmFacRec, { "nRegIva"     ,"N",  1, 0, "Regimen de " + cImp() ,                                   "TipoImpuesto",            "", "( cDbf )", nil } )
   aAdd( aItmFacRec, { "cCodPro"     ,"C",  9, 0, "Código de proyecto en contabilidad" ,                     "ProyectoContable",        "", "( cDbf )", nil } )
   aAdd( aItmFacRec, { "cDocOrg"     ,"C", 10, 0, "Número del documento origen" ,                            "DocumentoOrigen",         "", "( cDbf )", nil } )
   aAdd( aItmFacRec, { "nNumLiq"     ,"N",  9, 0, "Número liquidación",                                      "NumeroLiquidacion",       "", "( cDbf )", nil } )
   aAdd( aItmFacRec, { "cSufLiq"     ,"C",  2, 0, "Sufijo de la liquidación",                                "SufijoLiquidacion",       "", "( cDbf )", nil } )
   aAdd( aItmFacRec, { "nImpLiq"     ,"N", 16, 6, "Importe liquidación",                                     "ImporteLiquidacion",      "", "( cDbf )", nil } )
   aAdd( aItmFacRec, { "dFecLiq"     ,"D",  8, 0, "Fecha liquidación",                                       "FechaLiquidacion",        "", "( cDbf )", nil } )
   aAdd( aItmFacRec, { "cCodTrn"     ,"C",  9, 0, "Código del transportista" ,                               "Transportista",           "", "( cDbf )", nil } )
   aAdd( aItmFacRec, { "nKgsTrn"     ,"N", 16, 6, "TARA del transportista" ,                                 "TaraTransportista",       "", "( cDbf )", nil } )
   aAdd( aItmFacRec, { "lCloFac"     ,"L",  1, 0, "" ,                                                       "DocumentoCerrado",        "", "( cDbf )", nil } )
   aAdd( aItmFacRec, { "cAbnFac"     ,"C", 12, 0, "" ,                                                       "",                        "", "( cDbf )", nil } )
   aAdd( aItmFacRec, { "cAntFac"     ,"C", 12, 0, "Factura de anticipo" ,                                    "",                        "", "( cDbf )", nil } )
   aAdd( aItmFacRec, { "nPctRet"     ,"N",  6, 2, "Porcentaje de retención",                                 "PorcentajeRetencion",     "", "( cDbf )", nil } )
   aAdd( aItmFacRec, { "cCodUsr"     ,"C",  3, 0, "Código de usuario",                                       "Usuario",                 "", "( cDbf )", nil } )
   aAdd( aItmFacRec, { "dFecCre"     ,"D",  8, 0, "Fecha de creación del documento",                         "FechaCreacion",           "", "( cDbf )", nil } )
   aAdd( aItmFacRec, { "cTimCre"     ,"C",  5, 0, "Hora de creación del documento",                          "HoraCreacion",            "", "( cDbf )", nil } )
   aAdd( aItmFacRec, { "cCodGrp"     ,"C",  4, 0, "Código de grupo de cliente" ,                             "GrupoCliente",            "", "( cDbf )", nil } )
   aAdd( aItmFacRec, { "lImprimido"  ,"L",  1, 0, "Lógico de imprimido" ,                                    "Imprimido",               "", "( cDbf )", nil } )
   aAdd( aItmFacRec, { "dFecImp"     ,"D",  8, 0, "Última fecha de impresión" ,                              "FechaImpresion",          "", "( cDbf )", nil } )
   aAdd( aItmFacRec, { "cHorImp"     ,"C",  5, 0, "Hora de la última impresión" ,                            "HoraImpresion",           "", "( cDbf )", nil } )
   aAdd( aItmFacRec, { "cCodDlg"     ,"C",  2, 0, "Código delegación" ,                                      "Delegacion",              "", "( cDbf )", nil } )
   aAdd( aItmFacRec, { "cManObr"     ,"C",250, 0, "Literal de gastos" ,                                      "LiteralGastos",           "", "( cDbf )", nil } )
   aAdd( aItmFacRec, { "cMotRec"     ,"C",250, 0, "Motivo de la factura rectificativa",                      "MotivoRectificativa",     "", "( cDbf )", nil } )
   aAdd( aItmFacRec, { "cCauRec"     ,"C",250, 0, "Causa de la factura rectificativa",                       "CausaRectificativa",      "", "( cDbf )", nil } )
   aAdd( aItmFacRec, { "cTlfCli"     ,"C", 20, 0, "Teléfono del cliente" ,                                   "TelefonoCliente",         "", "( cDbf )", nil } )
   aAdd( aItmFacRec, { "nTotNet"     ,"N", 16, 6, "Total neto" ,                                             "TotalNeto",               "", "( cDbf )", nil } )
   aAdd( aItmFacRec, { "nTotIva"     ,"N", 16, 6, "Total " + cImp() ,                                        "TotalImpuesto",           "", "( cDbf )", nil } )
   aAdd( aItmFacRec, { "nTotReq"     ,"N", 16, 6, "Total recargo" ,                                          "TotalRecargo",            "", "( cDbf )", nil } )
   aAdd( aItmFacRec, { "nTotFac"     ,"N", 16, 6, "Total factura" ,                                          "TotalDocumento",          "", "( cDbf )", nil } )
   aAdd( aItmFacRec, { "cBanco"      ,"C", 50, 0, "Nombre del banco del cliente" ,                           "NombreBanco",             "", "( cDbf )", nil } )
   aAdd( aItmFacRec, { "cPaisIBAN"   ,"C",  2, 0, "País IBAN de la cuenta bancaria del cliente",             "CuentaIBAN", 		       "", "( cDbf )", nil } )
   aAdd( aItmFacRec, { "cCtrlIBAN"   ,"C",  2, 0, "Dígito de control IBAN de la cuenta bancaria del cliente","DigitoControlIBAN",       "", "( cDbf )", nil } )
   aAdd( aItmFacRec, { "cEntBnc"     ,"C",  4, 0, "Entidad de la cuenta bancaria del cliente" ,              "EntidadCuenta",           "", "( cDbf )", nil } )
   aAdd( aItmFacRec, { "cSucBnc"     ,"C",  4, 0, "Sucursal de la cuenta bancaria del cliente" ,             "SucursalCuenta",          "", "( cDbf )", nil } )
   aAdd( aItmFacRec, { "cDigBnc"     ,"C",  2, 0, "Dígito de control de la cuenta bancaria del cliente" ,    "DigitoControlCuenta",     "", "( cDbf )", nil } )
   aAdd( aItmFacRec, { "cCtaBnc"     ,"C", 10, 0, "Cuenta bancaria del cliente" ,                            "CuentaBancaria",          "", "( cDbf )", nil } )
   aAdd( aItmFacRec, { "lOperpv"     ,"L",  1, 0, "Lógico para operar con punto verde" ,                     "OperarPuntoVerde",        "", "( cDbf )", nil } )
   aAdd( aItmFacRec, { "nDtoTarifa"  ,"N",  6, 2, "Descuento de tarifa de cliente",                          "DescuentoTarifa",         "", "( cDbf )", nil } )
   aAdd( aItmFacRec, { "tFecFac"     ,"C",  9, 0, "Hora de la factura rectificativa",                        "HoraFactura",             "", "( cDbf )", nil } )
   aAdd( aItmFacRec, { "cCtrCoste"   ,"C",  9, 0, "Código del centro de coste",                              "CentroCoste",             "", "( cDbf )", nil } )

RETURN ( aItmFacRec )

//---------------------------------------------------------------------------//

function aCalFacRec()

   local aCalFacRec  := {}

   aAdd( aCalFacRec, { "nTotArt",                                                   "N", 16,  6, "Total artículos",             "cPicUndFac",  "" } )
   aAdd( aCalFacRec, { "nTotCaj",                                                   "N", 16,  6, "Total cajas",                 "cPicUndFac",  "" } )
   aAdd( aCalFacRec, { "aTotIva[1,1]",                                              "N", 16,  6, "Bruto primer tipo de " + cImp(),    "cPorDivFac",  "!empty( aTotIva[1,1] ) .and. lEnd" } )
   aAdd( aCalFacRec, { "aTotIva[2,1]",                                              "N", 16,  6, "Bruto segundo tipo de " + cImp(),   "cPorDivFac",  "!empty( aTotIva[2,1] ) .and. lEnd" } )
   aAdd( aCalFacRec, { "aTotIva[3,1]",                                              "N", 16,  6, "Bruto tercer tipo de " + cImp(),    "cPorDivFac",  "!empty( aTotIva[3,1] ) .and. lEnd" } )
   aAdd( aCalFacRec, { "aTotIva[1,2]",                                              "N", 16,  6, "Base primer tipo de " + cImp(),     "cPorDivFac",  "!empty( aTotIva[1,2] ) .and. lEnd" } )
   aAdd( aCalFacRec, { "aTotIva[2,2]",                                              "N", 16,  6, "Base segundo tipo de " + cImp(),    "cPorDivFac",  "!empty( aTotIva[2,2] ) .and. lEnd" } )
   aAdd( aCalFacRec, { "aTotIva[3,2]",                                              "N", 16,  6, "Base tercer tipo de " + cImp(),     "cPorDivFac",  "!empty( aTotIva[3,2] ) .and. lEnd" } )
   aAdd( aCalFacRec, { "aTotIva[1,3]",                                              "N",  5,  2, "Porcentaje primer tipo " + cImp(),  "'@R 99.99%'", "!empty( aTotIva[1,3] ) .and. lEnd" } )
   aAdd( aCalFacRec, { "aTotIva[2,3]",                                              "N",  5,  2, "Porcentaje segundo tipo " + cImp(), "'@R 99.99%'", "!empty( aTotIva[2,3] ) .and. lEnd" } )
   aAdd( aCalFacRec, { "aTotIva[3,3]",                                              "N",  5,  2, "Porcentaje tercer tipo " + cImp(),  "'@R 99.99%'", "!empty( aTotIva[3,3] ) .and. lEnd" } )
   aAdd( aCalFacRec, { "aTotIva[1,4]",                                              "N",  5,  2, "Porcentaje primer tipo RE",   "'@R 99.99%'", "!empty( aTotIva[1,4] ) .and. lEnd" } )
   aAdd( aCalFacRec, { "aTotIva[2,4]",                                              "N",  5,  2, "Porcentaje segundo tipo RE",  "'@R 99.99%'", "!empty( aTotIva[2,4] ) .and. lEnd" } )
   aAdd( aCalFacRec, { "aTotIva[3,4]",                                              "N",  5,  2, "Porcentaje tercer tipo RE",   "'@R 99.99%'", "!empty( aTotIva[3,4] ) .and. lEnd" } )
   aAdd( aCalFacRec, { "round( aTotIva[1,2] * aTotIva[1,3] / 100, nDouDivFac )",    "N", 16,  6, "Importe primer tipo " + cImp(),     "cPorDivFac",  "!empty( aTotIva[1,2] ) .and. lEnd" } )
   aAdd( aCalFacRec, { "round( aTotIva[2,2] * aTotIva[2,3] / 100, nDouDivFac )",    "N", 16,  6, "Importe segundo tipo " + cImp(),    "cPorDivFac",  "!empty( aTotIva[2,2] ) .and. lEnd" } )
   aAdd( aCalFacRec, { "round( aTotIva[3,2] * aTotIva[3,3] / 100, nDouDivFac )",    "N", 16,  6, "Importe tercer tipo " + cImp(),     "cPorDivFac",  "!empty( aTotIva[3,2] ) .and. lEnd" } )
   aAdd( aCalFacRec, { "round( aTotIva[1,2] * aTotIva[1,4] / 100, nDouDivFac )",    "N", 16,  6, "Importe primer RE",           "cPorDivFac",  "!empty( aTotIva[1,2] ) .and. lEnd" } )
   aAdd( aCalFacRec, { "round( aTotIva[2,2] * aTotIva[2,4] / 100, nDouDivFac )",    "N", 16,  6, "Importe segundo RE",          "cPorDivFac",  "!empty( aTotIva[2,2] ) .and. lEnd" } )
   aAdd( aCalFacRec, { "round( aTotIva[3,2] * aTotIva[3,4] / 100, nDouDivFac )",    "N", 16,  6, "Importe tercer RE",           "cPorDivFac",  "!empty( aTotIva[3,2] ) .and. lEnd" } )
   aAdd( aCalFacRec, { "nTotBrt",                                                   "N", 16,  6, "Total bruto",                 "cPorDivFac",  "lEnd" }                              )
   aAdd( aCalFacRec, { "nTotDto",                                                   "N", 16,  6, "Total descuento",             "cPorDivFac",  "lEnd" }                              )
   aAdd( aCalFacRec, { "nTotDpp",                                                   "N", 16,  6, "Total descuento pronto pago", "cPorDivFac",  "lEnd" }                              )
   aAdd( aCalFacRec, { "nTotNet",                                                   "N", 16,  6, "Total neto",                  "cPorDivFac",  "lEnd" }                              )
   aAdd( aCalFacRec, { "nTotUno",                                                   "N", 16,  6, "Total primer descuento definible", "cPorDivFac",  "lEnd" }                         )
   aAdd( aCalFacRec, { "nTotDos",                                                   "N", 16,  6, "Total segundo descuento definible", "cPorDivFac",  "lEnd" }                        )
   aAdd( aCalFacRec, { "nTotIva",                                                   "N", 16,  6, "Total " + cImp(),                   "cPorDivFac",  "lEnd" }                              )
   aAdd( aCalFacRec, { "nTotReq",                                                   "N", 16,  6, "Total RE",                    "cPorDivFac",  "lEnd" }                              )
   aAdd( aCalFacRec, { "nTotFac",                                                   "N", 16,  6, "Total factura",               "cPorDivFac",  "lEnd" }                              )
   aAdd( aCalFacRec, { "nTotRet",                                                   "N", 16,  6, "Total retención",             "cPorDivFac",  "lEnd" }                              )
   aAdd( aCalFacRec, { "nTotPage",                                                  "N", 16,  6, "Total página",                "cPorDivFac",  "!lEnd" }                             )
   aAdd( aCalFacRec, { "nImpEuros( nTotFac, (cDbf)->cDivFac, cDbfDiv )",            "N", 16,  6, "Total factura (Euros)",       "",             "lEnd" }                             )
   aAdd( aCalFacRec, { "nImpPesetas( nTotFac, (cDbf)->cDivFac, cDbfDiv )",          "N", 16,  6, "Total factura (Pesetas)",     "",             "lEnd" }                             )
   aAdd( aCalFacRec, { "nTotCob",                                                   "N", 16,  6, "Total cobrado",               "cPorDivFac",   "lEnd" }                             )
   aAdd( aCalFacRec, { "nPagina",                                                   "N",  2,  0, "Número de página",            "'99'",         "" }                                 )
   aAdd( aCalFacRec, { "lEnd",                                                      "L",  1,  0, "Fin del documento",           "",             "" }                                 )
   aAdd( aCalFacRec, { "nTotPes",                                                   "N", 16,  6, "Total peso",                  "'@E 99,999.99'","lEnd" }                            )
   aAdd( aCalFacRec, { "aDatVto[ 1 ]",                                              "D",  8,  0, "Fecha del primer vencimiento","",             "!empty( aDatVto ) .and. len( aDatVto ) >= 1 .and. lEnd" } )
   aAdd( aCalFacRec, { "aDatVto[ 2 ]",                                              "D",  8,  0, "Fecha del segundo vencimiento","",            "!empty( aDatVto ) .and. len( aDatVto ) >= 2 .and. lEnd" } )
   aAdd( aCalFacRec, { "aDatVto[ 3 ]",                                              "D",  8,  0, "Fecha del tercer vencimiento","",             "!empty( aDatVto ) .and. len( aDatVto ) >= 3 .and. lEnd" } )
   aAdd( aCalFacRec, { "aDatVto[ 4 ]",                                              "D",  8,  0, "Fecha del cuarto vencimiento","",             "!empty( aDatVto ) .and. len( aDatVto ) >= 4 .and. lEnd" } )
   aAdd( aCalFacRec, { "aDatVto[ 5 ]",                                              "D",  8,  0, "Fecha del quinto vencimiento","",             "!empty( aDatVto ) .and. len( aDatVto ) >= 5 .and. lEnd" } )
   aAdd( aCalFacRec, { "aImpVto[ 1 ]",                                              "N", 16,  6, "Importe del primer vencimiento","cPorDivFac", "!empty( aImpVto ) .and. len( aImpVto ) >= 1 .and. lEnd" } )
   aAdd( aCalFacRec, { "aImpVto[ 2 ]",                                              "N", 16,  6, "Importe del segundo vencimiento","cPorDivFac","!empty( aImpVto ) .and. len( aImpVto ) >= 2 .and. lEnd" } )
   aAdd( aCalFacRec, { "aImpVto[ 3 ]",                                              "N", 16,  6, "Importe del tercero vencimiento","cPorDivFac","!empty( aImpVto ) .and. len( aImpVto ) >= 3 .and. lEnd" } )
   aAdd( aCalFacRec, { "aImpVto[ 4 ]",                                              "N", 16,  6, "Importe del cuarto vencimiento","cPorDivFac", "!empty( aImpVto ) .and. len( aImpVto ) >= 4 .and. lEnd" } )
   aAdd( aCalFacRec, { "aImpVto[ 5 ]",                                              "N", 16,  6, "Importe del quinto vencimiento","cPorDivFac", "!empty( aImpVto ) .and. len( aImpVto ) >= 5 .and. lEnd" } )
   aAdd( aCalFacRec, { "aImpVto[ 5 ]",                                              "N", 16,  6, "Importe del quinto vencimiento","cPorDivFac", "!empty( aImpVto ) .and. len( aImpVto ) >= 5 .and. lEnd" } )

return ( aCalFacRec )

//---------------------------------------------------------------------------//

function aColFacRec()

   local aColFacRec  := {}

   aAdd( aColFacRec, { "cSerie"      ,"C",  1, 0, ""                                      , "Serie",                       "", "( cDbfCol )", nil } )
   aAdd( aColFacRec, { "nNumFac"     ,"N",  9, 0, ""                                      , "Numero",                      "", "( cDbfCol )", nil } )
   aAdd( aColFacRec, { "cSufFac"     ,"C",  2, 0, ""                                      , "Sufijo",                      "", "( cDbfCol )", nil } )
   aAdd( aColFacRec, { "cRef"        ,"C", 18, 0, "Referencia del artículo"               , "Articulo",                    "", "( cDbfCol )", nil } )
   aAdd( aColFacRec, { "cDetalle"    ,"C",250, 0, "Detalle del artículo"                  , "DescripcionArticulo",         "", "( cDbfCol )", nil } )
   aAdd( aColFacRec, { "nPreUnit"    ,"N", 16, 6, ""                                      , "PrecioVenta",                 "", "( cDbfCol )", nil } )
   aAdd( aColFacRec, { "nPntVer"     ,"N", 16, 6, "Importe punto verde"                   , "PuntoVerde",                  "", "( cDbfCol )", nil } )
   aAdd( aColFacRec, { "nImpTrn"     ,"N", 16, 6, "Importe de portes"                     , "Portes",                      "", "( cDbfCol )", nil } )
   aAdd( aColFacRec, { "nDto"        ,"N",  6, 2, "Descuento"                             , "DescuentoPorcentual",         "", "( cDbfCol )", nil } )
   aAdd( aColFacRec, { "nDtoPrm"     ,"N",  6, 2, "Descuento promocional"                 , "DescuentoPromocion",          "", "( cDbfCol )", nil } )
   aAdd( aColFacRec, { "nIva"        ,"N",  6, 2, "Porcentaje de " + cImp()               , "PorcentajeImpuesto",          "", "( cDbfCol )", nil } )
   aAdd( aColFacRec, { "nCanEnt"     ,"N", 16, 6, "Cajas"                                 , "Cajas",                       "", "( cDbfCol )", nil } )
   aAdd( aColFacRec, { "lControl"    ,"L",  1, 0, ""                                      , "LineaControl",                "", "( cDbfCol )", nil } )
   aAdd( aColFacRec, { "nPesoKg"     ,"N", 16, 6, "Peso del producto"                     , "Peso",                        "", "( cDbfCol )", nil } )
   aAdd( aColFacRec, { "cPesoKg"     ,"C",  2, 0, "Unidad de peso del producto"           , "UnidadMedicionPeso",          "", "( cDbfCol )", nil } )
   aAdd( aColFacRec, { "cUnidad"     ,"C",  2, 0, "Unidades de venta"                     , "UnidadMedicion",              "", "( cDbfCol )", nil } )
   aAdd( aColFacRec, { "nComAge"     ,"N",  6, 2, "Comisión del agente"                   , "ComisionAgente",              "", "( cDbfCol )", nil } )
   aAdd( aColFacRec, { "nUniCaja"    ,"N", 16, 6, "Unidades por caja"                     , "Unidades",                    "", "( cDbfCol )", nil } )
   aAdd( aColFacRec, { "nUndKit"     ,"N", 16, 6, "Unidades del producto kit"             , "UnidadesKit",                 "", "( cDbfCol )", nil } )
   aAdd( aColFacRec, { "dFecha"      ,"D",  8, 0, "Fecha de detalle"                      , "FechaEntrega",                "", "( cDbfCol )", nil } )
   aAdd( aColFacRec, { "cTipMov"     ,"C",  2, 0, "Tipo de movimiento"                    , "Tipo",                        "", "( cDbfCol )", nil } )
   aAdd( aColFacRec, { "mLngDes"     ,"M", 10, 0, "Descripción de artículo sin codificar" , "DescripcionAmpliada",         "", "( cDbfCol )", nil } )
   aAdd( aColFacRec, { "cCodAlb"     ,"C", 12, 0, "Código del albarán de procedencia"     , "",                            "", "( cDbfCol )", nil } )
   aAdd( aColFacRec, { "dFecAlb"     ,"D",  8, 0, "Fecha del albarán de procedencia"      , "",                            "", "( cDbfCol )", nil } )
   aAdd( aColFacRec, { "lTotLin"     ,"L",  1, 0, "Valor lógico para línea de total"      , "LineaTotal",                  "", "( cDbfCol )", nil } )
   aAdd( aColFacRec, { "lImpLin"     ,"L",  1, 0, "Valor lógico línea no imprimible"      , "LineaNoImprimible",           "", "( cDbfCol )", nil } )
   aAdd( aColFacRec, { "cCodPr1"     ,"C", 20, 0, "Código de primera propiedad"           , "CodigoPropiedad1",            "", "( cDbfCol )", nil } )
   aAdd( aColFacRec, { "cCodPr2"     ,"C", 20, 0, "Código de segunda propiedad"           , "CodigoPropiedad2",            "", "( cDbfCol )", nil } )
   aAdd( aColFacRec, { "cValPr1"     ,"C", 20, 0, "Valor de primera propiedad"            , "ValorPropiedad1",             "", "( cDbfCol )", nil } )
   aAdd( aColFacRec, { "cValPr2"     ,"C", 20, 0, "Valor de segunda propiedad"            , "ValorPropiedad2",             "", "( cDbfCol )", nil } )
   aAdd( aColFacRec, { "nFacCnv"     ,"N", 16, 6, "Factor de conversión de la compra"     , "FactorConversion",            "", "( cDbfCol )", nil } )
   aAdd( aColFacRec, { "nDtoDiv"     ,"N", 16, 6, "Descuento lineal de la compra"         , "DescuentoLineal",             "", "( cDbfCol )", nil } )
   aAdd( aColFacRec, { "lSel"        ,"L",  1, 0, ""                                      , "",                            "", "( cDbfCol )", nil } )
   aAdd( aColFacRec, { "nNumLin"     ,"N",  4, 0, "Número de la línea"                    , "NumeroLinea",                 "", "( cDbfCol )", nil } )
   aAdd( aColFacRec, { "nCtlStk"     ,"N",  1, 0, "Tipo de stock de la linea"             , "TipoStock",                   "", "( cDbfCol )", nil } )
   aAdd( aColFacRec, { "nCosDiv"     ,"N", 16, 6, "Costo del producto"                    , "PrecioCosto",                 "", "( cDbfCol )", nil } )
   aAdd( aColFacRec, { "nPvpRec"     ,"N", 16, 6, "Precio de venta recomendado"           , "PrecioVentaRecomendado",      "", "( cDbfCol )", nil } )
   aAdd( aColFacRec, { "cAlmLin"     ,"C", 16, 0, "Código de almacén"                     , "Almacen",                     "", "( cDbfCol )", nil } )
   aAdd( aColFacRec, { "lIvaLin"     ,"L",  1, 0, cImp() + " incluido"                    , "LineaImpuestoIncluido",       "", "( cDbfCol )", nil } )
   aAdd( aColFacRec, { "cCodImp"     ,"C",  3, 0, "Código del impuesto especial"          , "ImpuestoEspecial",            "", "( cDbfCol )", nil } )
   aAdd( aColFacRec, { "nValImp"     ,"N", 16, 6, "Importe del impuesto especial"         , "ImporteImpuestoEspecial",     "", "( cDbfCol )", nil } )
   aAdd( aColFacRec, { "lLote"       ,"L",  1, 0, ""                                      , "LogicoLote",                  "", "( cDbfCol )", nil } )
   aAdd( aColFacRec, { "nLote"       ,"N",  9, 0, ""                                      , "",                            "", "( cDbfCol )", nil } )
   aAdd( aColFacRec, { "cLote"       ,"C", 14, 0, "Número de lote"                        , "Lote",                        "", "( cDbfCol )", nil } )
   aAdd( aColFacRec, { "dFecCad"     ,"D",  8, 0, "Fecha de caducidad"                    , "FechaCaducidad",              "", "( cDbfCol )", nil } )
   aAdd( aColFacRec, { "lKitArt"     ,"L",  1, 0, "Línea con escandallo"                  , "LineaEscandallo",             "", "( cDbfCol )", nil } )
   aAdd( aColFacRec, { "lKitChl"     ,"L",  1, 0, "Línea pertenciente a escandallo"       , "LineaPerteneceEscandallo",    "", "( cDbfCol )", nil } )
   aAdd( aColFacRec, { "lKitPrc"     ,"L",  1, 0, ""                                      , "LineaEscandalloPrecio",       "", "( cDbfCol )", nil } )
   aAdd( aColFacRec, { "nMesGrt"     ,"N",  2, 0, "Meses de garantía"                     , "MesesGarantia",               "", "( cDbfCol )", nil } )
   aAdd( aColFacRec, { "lNotVta"     ,"L",  1, 0, "No permitir venta sin stocks"          , "NoPermitirSinStock",          "", "( cDbfCol )", nil } )
   aAdd( aColFacRec, { "cCodTip"     ,"C",  4, 0, "Código del tipo de artículo"           , "TipoArticulo",                "", "( cDbfCol )", nil } )
   aAdd( aColFacRec, { "mNumSer"     ,"M", 10, 0, ""                                      , "",                            "", "( cDbfCol )", nil } )
   aAdd( aColFacRec, { "cCodFam"     ,"C", 16, 0, "Código de familia"                     , "Familia",                     "", "( cDbfCol )", nil } )
   aAdd( aColFacRec, { "cGrpFam"     ,"C",  3, 0, "Código del grupo de familia"           , "GrupoFamilia",                "", "( cDbfCol )", nil } )
   aAdd( aColFacRec, { "nReq"        ,"N", 16, 6, "Recargo de equivalencia"               , "RecargoEquivalencia",         "", "( cDbfCol )", nil } )
   aAdd( aColFacRec, { "mObsLin"     ,"M", 10, 0, "Observaciones de linea"                , "Observaciones",               "", "( cDbfCol )", nil } )
   aAdd( aColFacRec, { "cCodPrv"     ,"C", 12, 0, "Código del proveedor"                  , "Proveedor",                   "", "( cDbfCol )", nil } )
   aAdd( aColFacRec, { "cNomPrv"     ,"C", 30, 0, "Nombre del proveedor"                  , "NombreProveedor",             "", "( cDbfCol )", nil } )
   aAdd( aColFacRec, { "cImagen"     ,"C",128, 0, "Fichero de imagen"                     , "Imagen",                      "", "( cDbfCol )", nil } )
   aAdd( aColFacRec, { "nPunTos"     ,"N", 15, 6, "Puntos del artículo"                   , "",                            "", "( cDbfCol )", nil } )
   aAdd( aColFacRec, { "nValPnt"     ,"N", 16, 6, "Valor del punto"                       , "",                            "", "( cDbfCol )", nil } )
   aAdd( aColFacRec, { "nDtoPnt"     ,"N",  5, 2, "Descuento puntos"                      , "",                            "", "( cDbfCol )", nil } )
   aAdd( aColFacRec, { "nIncPnt"     ,"N",  5, 2, "Incremento porcentual"                 , "",                            "", "( cDbfCol )", nil } )
   aAdd( aColFacRec, { "cRefPrv"     ,"C", 18, 0, "Referencia proveedor"                  , "ReferenciaProveedor",         "", "( cDbfCol )", nil } )
   aAdd( aColFacRec, { "nVolumen"    ,"N", 16, 6, "Volumen del producto"                  , "Volumen",                     "", "( cDbfCol )", nil } )
   aAdd( aColFacRec, { "cVolumen"    ,"C",  2, 0, "Unidad del volumen"                    , "UnidadMedicionVolumen",       "", "( cDbfCol )", nil } )
   aAdd( aColFacRec, { "nNumMed"     ,"N",  1, 0, "Número de mediciones"                  , "NumeroMedidiones",            "", "( cDbfCol )", nil } )
   aAdd( aColFacRec, { "nMedUno"     ,"N", 16, 6, "Primera unidad de medición"            , "Medicion1",                   "", "( cDbfCol )", nil } )
   aAdd( aColFacRec, { "nMedDos"     ,"N", 16, 6, "Segunda unidad de medición"            , "Medicion2",                   "", "( cDbfCol )", nil } )
   aAdd( aColFacRec, { "nMedTre"     ,"N", 16, 6, "Tercera unidad de medición"            , "Medicion3",                   "", "( cDbfCol )", nil } )
   aAdd( aColFacRec, { "nTarLin"     ,"N",  1, 0, "Tarifa de precio aplicada"             , "NumeroTarifa",                "", "( cDbfCol )", nil } )
   aAdd( aColFacRec, { "Descrip"     ,"M", 10, 0, "Descripción larga del artículo"        , "DescripcionTecnica",          "", "( cDbfCol )", nil } )
   aAdd( aColFacRec, { "lLinOfe"     ,"L",  1, 0, "Linea con oferta"                      , "LineaOferta",                 "", "( cDbfCol )", nil } )
   aAdd( aColFacRec, { "lVolImp"     ,"L",  1, 0, "Aplicar volumen impuestos especiales " , "VolumenImpuestosEspeciales",  "", "( cDbfCol )", nil } )
   aAdd( aColFacRec, { "dFecFac"     ,"D",  8, 0, "Fecha de la factura rectificativa"     , "",                            "", "( cDbfCol )", nil } )
   aAdd( aColFacRec, { "nBultos"  	 ,"N", 16, 6, "Numero de bultos en líneas"		      , "",                            "", "( cDbfCol )", nil } )
   aAdd( aColFacRec, { "cFormato" 	 ,"C",100, 0, "Formato de venta"					         , "",                            "", "( cDbfCol )", nil } )
   aAdd( aColFacRec, { "tFecfac" 	 ,"C",  6, 0, "Hora de la factura rectificativa"      , "HoraFactura",                 "", "( cDbfCol )", nil } )
   aAdd( aColFacRec, { "cCtrCoste" 	 ,"C",  9, 0, "Código del centro de coste"            , "",                            "", "( cDbfCol )", nil } )
   aAdd( aColFacRec, { "lLabel"      ,"L",  1, 0, "Lógico para marca de etiqueta"         , "LogicoEtiqueta",              "", "( cDbfCol )", nil } )
   aAdd( aColFacRec, { "nLabel"      ,"N",  6, 0, "Unidades de etiquetas a imprimir"      , "NumeroEtiqueta",              "", "( cDbfCol )", nil } )
   aAdd( aColFacRec, { "cObrLin"     ,"C", 10, 0, "Dirección de la linea"                 , "Direccion",                   "", "( cDbfCol )", nil } )
   aAdd( aColFacRec, { "cRefAux"     ,"C", 18, 0, "Referencia auxiliar"                   , "ReferenciaAuxiliar",          "", "( cDbfCol )", nil } )
   aAdd( aColFacRec, { "cRefAux2"    ,"C", 18, 0, "Segunda referencia auxiliar"           , "ReferenciaAuxiliar2",         "", "( cDbfCol )", nil } )
   aAdd( aColFacRec, { "nPosPrint"   ,"N",  4, 0, "Posición de impresión"                 , "PosicionImpresion",           "", "( cDbfCol )", nil } )
   aAdd( aColFacRec, { "cTipCtr"     ,"C", 20, 0, "Tipo tercero centro de coste"          , "",                            "", "( cDbfCol )", nil } )
   aAdd( aColFacRec, { "cTerCtr"     ,"C", 20, 0, "Tercero centro de coste"               , "",                            "", "( cDbfCol )", nil } )
   aAdd( aColFacRec, { "id_tipo_v"   ,"N", 16, 0, "Identificador tipo de venta"           , "IdentificadorTipoVenta",      "", "( cDbfCol )", nil } )
   aAdd( aColFacRec, { "nRegIva"     ,"N",  1, 0, "Régimen de " + cImp()                  , "TipoImpuesto",                "", "( cDbfCol )", nil } ) 

return ( aColFacRec )

//---------------------------------------------------------------------------//

function aCocFacRec()

   local aCocFacRec  := {}

   aAdd( aCocFacRec, {"( Descrip( cDbfCol ) )",                                 "C", 50, 0, "Detalle del artículo",              "",            "Descripción", "" } )
   aAdd( aCocFacRec, {"( nTotNFacRec( cDbfCol ) )",                             "N", 16, 6, "Total unidades artículo",           "MasUnd()",    "Unidades",    "" } )
   aAdd( aCocFacRec, {"( nTotUFacRec( cDbfCol, nDouDivFac ) )",                 "N", 16, 6, "Precio unitario del artículo",      "cPouDivFac",  "Precio",      "" } )
   aAdd( aCocFacRec, {"( nTotPFacRec( cDbfCol, nDouDivFac, nVdvDivFac ) )",     "N", 16, 6, "Precio unitario con descuentos",    "cPouDivFac",  "Precio neto", "" } )
   aAdd( aCocFacRec, {"( nPntUFacRec( cDbfCol, nDpvDivFac ) )",                 "N", 16, 6, "Punto verde del artículo",          "cPpvDivFac",  "Punto verde", "" } )
   aAdd( aCocFacRec, {"( nTotLFacRec( cDbfCol, nDouDivFac, nRouDivFac ) )",     "N", 16, 6, "Total línea del factura",           "cPorDivFac",  "Total",       "" } )
   aAdd( aCocFacRec, {"( nTotFFacRec( cDbfCol, nDouDivFac, nRouDivFac ) )",     "N", 16, 6, "Total final línea del factura ",    "cPorDivFac",  "Total neto",  "" } )
   aAdd( aCocFacRec, {"( nDtoLFacRec( cDbfCol, nDouDivFac, nVdvDivFac ) )",     "N", 16, 6, "Importe descuento línea del factura","cPouDivFac", "Dto.",        "" } )
   aAdd( aCocFacRec, {"( nTotDtoLFacRec( cDbfCol, nDouDivFac, nVdvDivFac ) )",  "N", 16, 6, "Total descuento línea del factura ","cPouDivFac",  "Total dto.",  "" } )

return ( aCocFacRec )

//---------------------------------------------------------------------------//

function aIncFacRec()

   local aIncFacRec  := {}

   aAdd( aIncFacRec, { "cSerie",  "C",    1,  0, "Serie de factura" ,              "",                   "", "( cDbfCol )" } )
   aAdd( aIncFacRec, { "nNumFac", "N",    9,  0, "Número de factura" ,             "'999999999'",        "", "( cDbfCol )" } )
   aAdd( aIncFacRec, { "cSufFac", "C",    2,  0, "Sufijo de factura" ,             "",                   "", "( cDbfCol )" } )
   aAdd( aIncFacRec, { "cCodTip", "C",    3,  0, "Tipo de incidencia" ,            "",                   "", "( cDbfCol )" } )
   aAdd( aIncFacRec, { "dFecInc", "D",    8,  0, "Fecha de la incidencia" ,        "",                   "", "( cDbfCol )" } )
   aAdd( aIncFacRec, { "mDesInc", "M",   10,  0, "Descripción de la incidencia" ,  "",                   "", "( cDbfCol )" } )
   aAdd( aIncFacRec, { "lListo",  "L",    1,  0, "Lógico de listo" ,               "",                   "", "( cDbfCol )" } )
   aAdd( aIncFacRec, { "lAviso",  "L",    1,  0, "Lógico de Aviso" ,               "",                   "", "( cDbfCol )" } )

return ( aIncFacRec )

//---------------------------------------------------------------------------//

function aFacRecDoc()

   local aFacRecDoc  := {}

   aAdd( aFacRecDoc, { "cSerFac", "C",    1,  0, "Serie de factura" ,                "",                   "", "( cDbfCol )" } )
   aAdd( aFacRecDoc, { "nNumFac", "N",    9,  0, "Número de factura" ,               "'999999999'",        "", "( cDbfCol )" } )
   aAdd( aFacRecDoc, { "cSufFac", "C",    2,  0, "Sufijo de factura" ,               "",                   "", "( cDbfCol )" } )
   aAdd( aFacRecDoc, { "cNombre", "C",  250,  0, "Nombre del documento" ,            "",                   "", "( cDbfCol )" } )
   aAdd( aFacRecDoc, { "cRuta",   "C",  250,  0, "Ruta del documento" ,              "",                   "", "( cDbfCol )" } )
   aAdd( aFacRecDoc, { "mObsDoc", "M",   10,  0, "Observaciones del documento" ,     "",                   "", "( cDbfCol )" } )

return ( aFacRecDoc )

//---------------------------------------------------------------------------//

function aSerFacRec()

   local aColFacRec  := {}

   aAdd( aColFacRec,  { "cSerFac",     "C",  1,   0, "",                                 "",                  "", "( cDbfCol )" } )
   aAdd( aColFacRec,  { "nNumFac",     "N",  9,   0, "",                                 "",                  "", "( cDbfCol )" } )
   aAdd( aColFacRec,  { "cSufFac",     "C",  2,   0, "",                                 "",                  "", "( cDbfCol )" } )
   aAdd( aColFacRec,  { "dFecFac",     "D",  8,   0, "",                                 "",                  "", "( cDbfCol )" } )
   aAdd( aColFacRec,  { "nNumLin",     "N",  4,   0, "Número de la línea",               "'9999'",            "", "( cDbfCol )" } )
   aAdd( aColFacRec,  { "cRef",        "C", 18,   0, "Referencia del artículo",          "",                  "", "( cDbfCol )" } )
   aAdd( aColFacRec,  { "cAlmLin",     "C", 16,   0, "Almacen del artículo",             "",                  "", "( cDbfCol )" } )
   aAdd( aColFacRec,  { "lUndNeg",     "L",  1,   0, "Lógico de unidades negativas",     "",                  "", "( cDbfCol )" } )
   aAdd( aColFacRec,  { "cNumSer",     "C", 30,   0, "Número de serie",                  "",                  "", "( cDbfCol )" } )

return ( aColFacRec )

//---------------------------------------------------------------------------//

function aFacRecEst()

   local aFacRecEst  := {}

   aAdd( aFacRecEst, { "cSerFac", "C",    1,  0, "Serie de Factura rectificativa" ,               "",         "", "( cDbfCol )" } )
   aAdd( aFacRecEst, { "nNumFac", "N",    9,  0, "Numero de Factura rectificativa" ,   "'999999999'",         "", "( cDbfCol )" } )
   aAdd( aFacRecEst, { "cSufFac", "C",    2,  0, "Sufijo de Factura rectificativa" ,              "",         "", "( cDbfCol )" } )
   aAdd( aFacRecEst, { "cSitua",  "C",  140,  0, "Situación" ,   	    		                  "",         "", "( cDbfCol )" } )
   aAdd( aFacRecEst, { "dFecSit", "D",    8,  0, "Fecha de la situación" ,                        "",         "", "( cDbfCol )" } )
   aAdd( aFacRecEst, { "tFecSit", "C",    6,  0, "Hora de la situación" ,                         "",         "", "( cDbfCol )" } )
   aAdd( aFacRecEst, { "idPs",    "N",   11,  0, "Id prestashop" ,                                "",         "", "( cDbfCol )" } )   

return ( aFacRecEst )

//---------------------------------------------------------------------------//

//
// Devuelve el numero de unidades reservadas en facturas a clientes
//

function nTotRFacRec( cNumFac, dFecRes, cCodArt, cValPr1, cValPr2, cLote, cFacRecT, dbfFacRecL )

   local nTot        := 0
   local aStaFac     := aGetStatus( cFacRecT, .t. )
   local aStaLin     := aGetStatus( dbfFacRecL, .f. )

   DEFAULT cValPr1   := Space( 40 )
   DEFAULT cValPr2   := Space( 40 )

   ( dbfFacRecL )->( dbGoTop() )

   if ( dbfFacRecL )->( dbSeek( cNumFac ) )
      while ( dbfFacRecL )->cSerie + str( ( dbfFacRecL )->nNumFac, 9 ) + ( dbfFacRecL )->cSufFac == cNumFac .and. !( dbfFacRecL )->( eof() )
         if ( dbfFacRecL )->cRef + ( dbfFacRecL )->cValPr1 + ( dbfFacRecL )->cValPr2 == cCodArt + cValPr1 + cValPr2
            if empty( dFecRes ) .or. dFecRes <= dFecFacRec( ( dbfFacRecL )->cSerFac + Str( ( dbfFacRecL )->nNumFac ) + ( dbfFacRecL )->cSufFac, cFacRecT ) // empty( dFecRes )
               if ( dbfFacRecL )->nLote == cLote
                  nTot  += nTotNFacRec( dbfFacRecL )
               end if
            end if
         end if
         ( dbfFacRecL )->( dbSkip() )
      end while
   end if

   SetStatus( cFacRecT, aStaFac )
   SetStatus( dbfFacRecL, aStaLin )

return ( nTot )

//--------------------------------------------------------------------------//

Function AppFacRec( cCodCli, cCodArt, lOpenBrowse )

   local nLevel         := Auth():Level( _MENUITEM_ )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) == 0 .or. nAnd( nLevel, ACC_APPD ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if lOpenBrowse

      if FacRec( nil, nil, cCodCli, cCodArt )
         oWndBrw:RecAdd()
      end if

   else

      if OpenFiles( .t. )
         WinAppRec( nil, bEdtRec, D():FacturasRectificativas( nView ), cCodCli, cCodArt )
         CloseFiles()
      end if

   end if

RETURN .t.

//---------------------------------------------------------------------------//

Function EdtFacRec( cNumFac, lOpenBrowse )

   local nLevel         := Auth():Level( _MENUITEM_ )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) == 0 .or. nAnd( nLevel, ACC_EDIT ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if lOpenBrowse

      if FacRec()
         if dbSeekInOrd( cNumFac, "nNumFac", D():FacturasRectificativas( nView ) )
            oWndBrw:RecEdit()
         else
            MsgStop( "No se encuentra factura" )
         end if
      end if

   else

      if OpenFiles( .t. )

         if dbSeekInOrd( cNumFac, "nNumFac", D():FacturasRectificativas( nView ) )
            WinEdtRec( nil, bEdtRec, D():FacturasRectificativas( nView ) )
         end if

         CloseFiles()

      end if

   end if

Return .t.

//----------------------------------------------------------------------------//

FUNCTION ZooFacRec( cNumFac, lOpenBrowse )

   local nLevel         := Auth():Level( _MENUITEM_ )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) == 0 .or. nAnd( nLevel, ACC_ZOOM ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if lOpenBrowse

      if FacRec()
         if dbSeekInOrd( cNumFac, "nNumFac", D():FacturasRectificativas( nView ) )
            oWndBrw:RecZoom()
         else
            MsgStop( "No se encuentra factura" )
         end if
      end if

   else

      if OpenFiles( .t. )
         if dbSeekInOrd( cNumFac, "nNumFac", D():FacturasRectificativas( nView ) )
            WinZooRec( nil, bEdtRec, D():FacturasRectificativas( nView ) )
         end if
         CloseFiles()
      end if

   end if

Return .t.

//----------------------------------------------------------------------------//

FUNCTION DelFacRec( cNumFac, lOpenBrowse )

   local nLevel         := Auth():Level( _MENUITEM_ )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) == 0 .or. nAnd( nLevel, ACC_DELE ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if lOpenBrowse

      if FacRec()
         if dbSeekInOrd( cNumFac, "nNumFac", D():FacturasRectificativas( nView ) )
            WinDelRec( nil, D():FacturasRectificativas( nView ), {|| QuiFacRec() } )
         else
            MsgStop( "No se encuentra factura" )
         end if
      end if

   else

      if OpenFiles( .t. )

         if dbSeekInOrd( cNumFac, "nNumFac", D():FacturasRectificativas( nView ) )
            WinDelRec( nil, D():FacturasRectificativas( nView ), {|| QuiFacRec() } )
         end if

         CloseFiles()

      end if

   end if

Return .t.

//----------------------------------------------------------------------------//

FUNCTION PrnFacRec( cNumFac, lOpenBrowse )

   local nLevel         := Auth():Level( _MENUITEM_ )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) == 0 .or. nAnd( nLevel, ACC_IMPR ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if lOpenBrowse

      if FacRec()
         if dbSeekInOrd( cNumFac, "nNumFac", D():FacturasRectificativas( nView ) )
            GenFacRec( IS_PRINTER )
         else
            MsgStop( "No se encuentra factura" )
         end if
      end if

   else

      if OpenFiles( .t. )

         if dbSeekInOrd( cNumFac, "nNumFac", D():FacturasRectificativas( nView ) )
            GenFacRec( IS_PRINTER )
         end if

         CloseFiles()

      end if

   end if

Return .t.

//---------------------------------------------------------------------------//

FUNCTION VisFacRec( cNumFac, lOpenBrowse )

   local nLevel         := Auth():Level( _MENUITEM_ )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) == 0 .or. nAnd( nLevel, ACC_IMPR ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if lOpenBrowse

      if FacRec()
         if dbSeekInOrd( cNumFac, "nNumFac", D():FacturasRectificativas( nView ) )
            GenFacRec( IS_SCREEN )
         else
            MsgStop( "No se encuentra factura" )
         end if
      end if

   else

      if OpenFiles( .t. )

         if dbSeekInOrd( cNumFac, "nNumFac", D():FacturasRectificativas( nView ) )
            GenFacRec( IS_SCREEN )
         end if

         CloseFiles()

      end if

   end if

Return .t.

//---------------------------------------------------------------------------//

function SynFacRec( cPath )

   local oBlock
   local oError
   local aTotFac
   local cCodImp
   local cNumSer
   local aNumSer
   local dbfFacRecL
   local dbfArticulo

   DEFAULT cPath     := cPatEmp()

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      USE ( cPath + "FacRecT.DBF" ) NEW VIA ( cDriver() ) ALIAS ( cCheckArea( "FacRecT", @dbfFacRecT ) ) EXCLUSIVE
      SET ADSINDEX TO ( cPath + "FacRecT.CDX" ) ADDITIVE

      USE ( cPath + "FacRecL.DBF" ) NEW VIA ( cDriver() ) ALIAS ( cCheckArea( "FacRecL", @dbfFacRecL ) ) EXCLUSIVE
      SET ADSINDEX TO ( cPath + "FacRecL.CDX" ) ADDITIVE

      USE ( cPath + "FacRecS.Dbf" ) NEW VIA ( cDriver() )  ALIAS ( cCheckArea( "FacRecS", @dbfFacRecS ) ) EXCLUSIVE
      SET ADSINDEX TO ( cPath + "FacRecS.Cdx" ) ADDITIVE

      USE ( cPath + "FacRecI.DBF" ) NEW VIA ( cDriver() ) ALIAS ( cCheckArea( "FacRecI", @dbfFacRecI ) ) EXCLUSIVE
      SET ADSINDEX TO ( cPath + "FacRecI.CDX" ) ADDITIVE

      USE ( cPath + "FacRecE.DBF" ) NEW VIA ( cDriver() ) ALIAS ( cCheckArea( "FacRecE", @dbfFacRecE ) ) EXCLUSIVE
      SET ADSINDEX TO ( cPath + "FacRecE.CDX" ) ADDITIVE

      USE ( cPatEmp() + "FacCliP.DBF" ) NEW VIA ( cDriver() ) ALIAS ( cCheckArea( "FacCliP", @dbfFacCliP ) ) EXCLUSIVE
      SET ADSINDEX TO ( cPatEmp() + "FacCliP.CDX" ) ADDITIVE
      ( dbfFacCliP )->( OrdSetFocus( "rNumFac" ) )

      USE ( cPatEmp() + "FAMILIAS.DBF" ) NEW VIA ( cDriver() ) ALIAS ( cCheckArea( "FAMILIAS", @dbfFamilia ) ) EXCLUSIVE
      SET ADSINDEX TO ( cPatEmp() + "FAMILIAS.CDX" ) ADDITIVE

      USE ( cPatEmp() + "ARTICULO.DBF" ) NEW VIA ( cDriver() ) ALIAS ( cCheckArea( "ARTICULO", @dbfArticulo ) ) EXCLUSIVE
      SET ADSINDEX TO ( cPatEmp() + "ARTICULO.CDX" ) ADDITIVE

      USE ( cPatDat() + "TIVA.DBF" ) NEW VIA ( cDriver() ) ALIAS ( cCheckArea( "TIVA", @dbfIva ) ) SHARED
      SET ADSINDEX TO ( cPatDat() + "TIVA.CDX" ) ADDITIVE

      USE ( cPatDat() + "DIVISAS.DBF" ) NEW VIA ( cDriver() ) ALIAS ( cCheckArea( "DIVISAS", @dbfDiv ) ) SHARED
      SET ADSINDEX TO ( cPatDat() + "DIVISAS.CDX" ) ADDITIVE

      USE ( cPatEmp() + "AntCliT.DBF" ) NEW VIA ( cDriver() ) ALIAS ( cCheckArea( "AntCliT", @dbfAntCliT ) ) EXCLUSIVE
      SET ADSINDEX TO ( cPatEmp() + "AntCliT.CDX" ) ADDITIVE

      USE ( cPatEmp() + "Client.DBF" ) NEW VIA ( cDriver() ) ALIAS ( cCheckArea( "Client", @dbfClient ) ) SHARED
      SET ADSINDEX TO ( cPatEmp() + "Client.CDX" ) ADDITIVE

      oNewImp        := TNewImp():Create( cPatEmp() )
      oNewImp:OpenFiles()

      // Cabeceras-------------------------------------------------------------

		( dbfFacRecT )->( ordSetFocus( 0 ) )
		( dbfFacRecT )->( dbGoTop() )

      while !( dbfFacRecT )->( eof() )

         if empty( ( dbfFacRecT )->cSufFac )
            ( dbfFacRecT )->cSufFac := "00"
         end if

         if !empty( ( dbfFacRecT )->cNumFac ) .and. Len( alltrim( ( dbfFacRecT )->cNumFac ) ) != 12
        	   ( dbfFacRecT )->cNumFac := alltrim( ( dbfFacRecT )->cNumFac ) + "00"
      	end if

         if empty( ( dbfFacRecT )->cCodCaj )
            ( dbfFacRecT )->cCodCaj := "000"
         end if

         /*
         GUID localizadores universales para el registo------------------------
         */
        
         if empty( ( dbfFacRecT )->cGuid )
            ( dbfFacRecT )->cGuid  := win_uuidcreatestring()
         end if

         ( dbfFacRecT )->( dbSkip() )

      end while

		( dbfFacRecT )->( ordSetFocus( 1 ) )

      // Lineas----------------------------------------------------------------

		( dbfFacRecL )->( ordSetFocus( 0 ) )
		( dbfFacRecL )->( dbGoTop() )

      while !( dbfFacRecL )->( eof() )

         if empty( ( dbfFacRecL )->cSufFac )
	      	( dbfFacRecL )->cSufFac 	:= "00"
         end if

         if !empty( ( dbfFacRecL )->cCodAlb ) .and. Len( alltrim( ( dbfFacRecL )->cCodAlb ) ) != 12
        	   ( dbfFacRecL )->cCodAlb    := alltrim( ( dbfFacRecL )->cCodAlb ) + "00"
      	end if
	        
	      if empty( ( dbfFacRecL )->cLote ) .and. !empty( ( dbfFacRecL )->nLote )
	         ( dbfFacRecL )->cLote      := alltrim( Str( ( dbfFacRecL )->nLote ) )
	      end if

	      if empty( ( dbfFacRecL )->nVolumen )
	         ( dbfFacRecL )->nVolumen   :=  RetFld( ( dbfFacRecL )->cRef, dbfArticulo, "nVolumen" )
	      end if
	      
         if empty( ( dbfFacRecL )->cAlmLin )
            ( dbfFacRecL )->cAlmLin    := RetFld( ( dbfFacRecL )->cSerie + Str( ( dbfFacRecL )->nNumFac ) + ( dbfFacRecL )->cSufFac, dbfFacRecT, "cCodAlm" )
         end if

         if ( dbfFacRecL )->nRegIva != RetFld( ( dbfFacRecL )->cSerie + str( ( dbfFacRecL )->nNumFac ) + ( dbfFacRecL )->cSufFac, dbfFacRecT, "nRegIva" )
            if ( dbfFacRecL )->( dbRLock() )
               ( dbfFacRecL )->nRegIva    := RetFld( ( dbfFacRecL )->cSerie + str( ( dbfFacRecL )->nNumFac ) + ( dbfFacRecL )->cSufFac, dbfFacRecT, "nRegIva" )
               ( dbfFacRecL )->( dbUnLock() )
            end if
         end if

	      if !empty( ( dbfFacRecL )->mNumSer )

	         aNumSer                       := hb_aTokens( ( dbfFacRecL )->mNumSer, "," )
	         for each cNumSer in aNumSer
	            ( dbfFacRecS )->( dbAppend() )
	            ( dbfFacRecS )->cSerFac    := ( dbfFacRecL )->cSerie
	            ( dbfFacRecS )->nNumFac    := ( dbfFacRecL )->nNumFac
	            ( dbfFacRecS )->cSufFac    := ( dbfFacRecL )->cSufFac
	            ( dbfFacRecS )->cRef       := ( dbfFacRecL )->cRef
	            ( dbfFacRecS )->cAlmLin    := ( dbfFacRecL )->cAlmLin
	            ( dbfFacRecS )->nNumLin    := ( dbfFacRecL )->nNumLin
	            ( dbfFacRecS )->cNumSer    := cNumSer
	         next

            ( dbfFacRecL )->mNumSer       := ""

         end if

         if empty( ( dbfFacRecL )->nPosPrint )
            ( dbfFacRecL )->nPosPrint    	:= ( dbfFacRecL )->nPosPrint
         end if

         ( dbfFacRecL )->( dbSkip() )

         SysRefresh()

      end while
		
		( dbfFacRecL )->( ordSetFocus( 1 ) )

      // Series ---------------------------------------------------------------

		( dbfFacRecS )->( ordSetFocus( 0 ) ) 
		( dbfFacRecS )->( dbGoTop() ) 

      while !( dbfFacRecS )->( eof() )

      	if empty( ( dbfFacRecS )->cSufFac )
          	( dbfFacRecS )->cSufFac := "00"
       	end if

        	if empty( ( dbfFacRecS )->dFecFac )
           	( dbfFacRecS )->dFecFac 	:= RetFld( ( dbfFacRecS )->cSerie + Str( ( dbfFacRecS )->nNumFac ) + ( dbfFacRecS )->cSufFac, dbfFacRecT, "dFecFac" )
        	end if

        	( dbfFacRecS )->( dbSkip() )

        	SysRefresh()

      end while

      ( dbfFacRecS )->( ordSetFocus( 1 ) )

      /*
      Rellenamos los campos con los totales---------------------------------
      */

		( dbfFacRecT )->( dbGoTop() )
      while !( dbfFacRecT )->( eof() )

         if ( dbfFacRecT )->nTotFac == 0
            aTotFac                 := aTotFacRec( ( dbfFacRecT )->cSerie + Str( ( dbfFacRecT )->nNumFac ) + ( dbfFacRecT )->cSufFac, dbfFacRecT, dbfFacRecL, dbfIva, dbfDiv, ( dbfFacRecT )->cDivFac )
            ( dbfFacRecT )->nTotNet := aTotFac[1]
            ( dbfFacRecT )->nTotIva := aTotFac[2]
            ( dbfFacRecT )->nTotReq := aTotFac[3]
            ( dbfFacRecT )->nTotFac := aTotFac[4]
         end if

         ( dbfFacRecT )->( dbSkip() )

      end while

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos de facturas rectificativas de clientes." + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   CLOSE ( dbfFacRecT  )
   CLOSE ( dbfFacRecL  )
   CLOSE ( dbfFacRecS  )
   CLOSE ( dbfFacRecI  )
   CLOSE ( dbfFacRecE  )
   CLOSE ( dbfFacCliP  )
   CLOSE ( dbfAntCliT  )
   CLOSE ( dbfFamilia  )
   CLOSE ( dbfIva      )
   CLOSE ( dbfArticulo )
   CLOSE ( dbfDiv      )
   CLOSE ( dbfClient   )

   if !empty( oNewImp )
      oNewImp:end()
   end if

   oNewImp              := nil

Return nil

//------------------------------------------------------------------------//

FUNCTION nTotalRecibosGeneradosRectificativasCliente( cFactura, cFacCliT, dbfFacCliP, dbfIva, dbfDiv, cDivRet )

Return ( nPagFacRec( cFactura, cFacCliT, dbfFacCliP, dbfIva, dbfDiv, cDivRet, .f., .f. ) )

//---------------------------------------------------------------------------//

FUNCTION nTotalRecibosPagadosRectificativasCliente( cFactura, cFacCliT, dbfFacCliP, dbfIva, dbfDiv, cDivRet )

Return ( nPagFacRec( cFactura, cFacCliT, dbfFacCliP, dbfIva, dbfDiv, cDivRet, .t., .f. ) )

//---------------------------------------------------------------------------//

/*
Devuelve el total de pagos de una factura
*/

FUNCTION nPagFacRec( cFactura, cFacRecT, dbfFacCliP, dbfIva, dbfDiv, cDivRet, lOnlyCob, lPic )

   local nOrd
   local nRec
   local cPorDiv
   local nRouDiv        := 2
   local nTotalPagado   := 0
   local cCodDiv        := cDivEmp()

   DEFAULT lOnlyCob     := .t.
   DEFAULT lPic         := .f.

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

         if ( lOnlyCob .and. ( dbfFacCliP )->lCobrado .and. !( dbfFacCliP )->lDevuelto ) .or. ( !lOnlyCob .and. !( dbfFacCliP )->lDevuelto )
            nTotalPagado+= ( dbfFacCliP )->nImporte
         end if

         ( dbfFacCliP )->( dbSkip() )

      end while

      ( dbfFacCliP )->( dbGoTo( nRec ) )

   else

      nRec              := ( dbfFacCliP )->( Recno() )
      nOrd              := ( dbfFacCliP )->( OrdSetFocus( "rNumFac" ) )

      if ( dbfFacCliP )->( dbSeek( cFactura ) )

         while ( ( dbfFacCliP )->cSerie + Str( ( dbfFacCliP )->nNumFac ) + ( dbfFacCliP )->cSufFac == cFactura )

            if ( lOnlyCob .and. ( dbfFacCliP )->lCobrado .and. !( dbfFacCliP )->lDevuelto ) .or. ( !lOnlyCob .and. !( dbfFacCliP )->lDevuelto )
               nTotalPagado   += ( dbfFacCliP )->nImporte
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

FUNCTION nChkPagFacRec( cFacRec, cFacRecT, dbfFacCliP )

   local nBitmap        := 3

   if ( cFacRecT )->lLiquidada

      nBitmap           := 1

   elseif ( dbfFacCliP )->( dbSeek( cFacRec ) )

      while ( dbfFacCliP )->cSerie + Str( ( dbfFacCliP )->nNumFac ) + ( dbfFacCliP )->cSufFac == cFacRec .and. !( dbfFacCliP )->( eof() )

         if ( dbfFacCliP )->lCobrado

            nBitmap     := 2
            exit

         end if

         ( dbfFacCliP )->( dbSkip() )

      end while

   end if

RETURN nBitmap

//---------------------------------------------------------------------------//

FUNCTION cChkPagFacRec( cFacRec, cFacRecT, dbfFacCliP )

   local cChkPag        := ""
   local nChkPag        := nChkPagFacRec( cFacRec, cFacRecT, dbfFacCliP )

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

FUNCTION ChkLqdFacRec( aTmp, cFacRecT, dbfFacRecL, dbfFacCliP, dbfIva, dbfDiv )

   local nTotal
   local lChkLqd
   local cDivFac
   local cFactura
   local nPagFacCli
   local nRec                    := ( dbfFacCliP )->( RecNo() )

   if aTmp != nil
      cFactura                   := aTmp[_CSERIE ] + Str( aTmp[_NNUMFAC] ) + aTmp[_CSUFFAC]
      cDivFac                    := aTmp[_CDIVFAC]
   else
      cFactura                   := ( cFacRecT )->CSERIE + Str( ( cFacRecT )->NNUMFAC ) + ( cFacRecT )->CSUFFAC
      cDivFac                    := ( cFacRecT )->CDIVFAC
   end if

   nTotal                        := abs( nTotFacRec( cFactura, cFacRecT, dbfFacRecL, dbfIva, dbfDiv, nil, nil, .f. ) )
   nPagFacCli                    := abs( nPagFacRec( cFactura, cFacRecT, dbfFacCliP, dbfIva, dbfDiv, nil, .t. ) )

   lChkLqd                       := !lMayorIgual( nTotal, nPagFacCli, 0.1 )

   if aTmp != nil
      aTmp[ _LLIQUIDADA ]        := lChkLqd
   end if

   if dbLock( cFacRecT )
      ( cFacRecT )->lLiquidada   := lChkLqd
      ( cFacRecT )->( dbUnLock() )
   end if

   ( dbfFacCliP )->( dbGoTo( nRec ) )

RETURN ( lChkLqd )

//---------------------------------------------------------------------------//

FUNCTION nPesLFacRec( cFacRecL )

   local nCalculo    := 0

   DEFAULT cFacRecL  := D():FacturasRectificativasLineas( nView )

   if !( cFacRecL )->lTotLin
      nCalculo       := Abs( nTotNFacRec( cFacRecL ) ) * ( cFacRecL )->nPesoKg
   end if

RETURN ( nCalculo )

//---------------------------------------------------------------------------//

STATIC FUNCTION DupSerie( oWndBrw )

   local oDlg
   local oSerIni
   local oSerFin
   local oTxtDup
   local nTxtDup     := 0
   local nRecno      := ( D():FacturasRectificativas( nView ) )->( Recno() )
   local nOrdAnt     := ( D():FacturasRectificativas( nView ) )->( OrdSetFocus( 1 ) )
   local oDesde      := TDesdeHasta():Init( ( D():FacturasRectificativas( nView ) )->cSerie, ( D():FacturasRectificativas( nView ) )->nNumFac, ( D():FacturasRectificativas( nView ) )->cSufFac, GetSysDate() )
   local lCancel     := .f.
   local oBtnAceptar
   local oBtnCancel
   local oFecDoc
   local cFecDoc     := GetSysDate()

   DEFINE DIALOG oDlg ;
      RESOURCE "DUPSERDOC" ;
      TITLE    "Duplicar series de facturas rectificativas" ;
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
      TOTAL    ( D():FacturasRectificativas( nView ) )->( OrdKeyCount() ) ;
      OF       oDlg

      oDlg:AddFastKey( VK_F5, {|| DupStart( oDesde, oDlg, oBtnAceptar, oBtnCancel, oTxtDup, @lCancel, cFecDoc ) } )

   ACTIVATE DIALOG oDlg CENTER VALID ( lCancel )

   ( D():FacturasRectificativas( nView ) )->( dbGoTo( nRecNo ) )
   ( D():FacturasRectificativas( nView ) )->( ordSetFocus( nOrdAnt ) )

   oWndBrw:SetFocus()
   oWndBrw:Refresh()

RETURN NIL

//--------------------------------------------------------------------------//

FUNCTION IsFacRec( cPath )

   DEFAULT cPath  := cPatEmp()

   if !lExistTable( cPath + "FacRecT.Dbf" )
      dbCreate( cPath + "FacRecT.Dbf", aSqlStruct( aItmFacRec() ), cDriver() )
   end if

   if !lExistTable( cPath + "FacRecL.Dbf" )
      dbCreate( cPath + "FacRecL.Dbf", aSqlStruct( aColFacRec() ), cDriver() )
   end if

   if !lExistTable( cPath + "FacRecI.Dbf" )
      dbCreate( cPath + "FacRecI.Dbf", aSqlStruct( aIncFacRec() ), cDriver() )
   end if

   if !lExistTable( cPath + "FacRecD.Dbf" )
      dbCreate( cPath + "FacRecD.Dbf", aSqlStruct( aFacRecDoc() ), cDriver() )
   end if

   if !lExistIndex( cPath + "FacRecT.Cdx" ) .or. ;
      !lExistIndex( cPath + "FacRecL.Cdx" ) .or. ;
      !lExistIndex( cPath + "FacRecI.Cdx" ) .or. ;
      !lExistTable( cPath + "FacRecD.Cdx" )

      rxFacRec( cPath )

   end if

Return ( nil )

//---------------------------------------------------------------------------//

Function DesignReportFacRec( oFr, dbfDoc)

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
                                                   "CallHbFunc('nTotFacRec');"                                 + Chr(13) + Chr(10) + ;
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
         oFr:SetObjProperty(  "MasterData",  "DataSet", "Facturas rectificativas" )

         oFr:AddBand(         "DetalleColumnas",   "MainPage", frxDetailData  )
         oFr:SetProperty(     "DetalleColumnas",   "Top", 230 )
         oFr:SetProperty(     "DetalleColumnas",   "Height", 28 )
         oFr:SetObjProperty(  "DetalleColumnas",   "DataSet", "Lineas de facturas rectificativas" )
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

Function mailReportFacRec( cCodigoDocumento )

Return ( printReportFacRec( IS_MAIL, 1, prnGetName(), cCodigoDocumento ) )

//---------------------------------------------------------------------------//

Function PrintReportFacRec( nDevice, nCopies, cPrinter )

   local oFr
   local cFilePdf       := cPatTmp() + "FacturasRectificativasCliente" + StrTran( ( D():FacturasRectificativas( nView ) )->cSerie + Str( ( D():FacturasRectificativas( nView ) )->nNumFac ) + ( D():FacturasRectificativas( nView ) )->cSufFac, " ", "" ) + ".Pdf"
   local nOrd

   DEFAULT nDevice      := IS_SCREEN
   DEFAULT nCopies      := 1
   DEFAULT cPrinter     := PrnGetName()

   SysRefresh()

   nOrd 						:= ( D():FacturasRectificativasLineas( nView) )->( ordSetFocus( "nPosPrint" ) )

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

   if !empty( ( D():Documentos( nView ) )->mReport )

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

   ( D():FacturasRectificativasLineas( nView) )->( ordSetFocus( nOrd ) )

Return cFilePdf

//---------------------------------------------------------------------------//

/*
Devuelve la descripción de una line de factura
*/

FUNCTION cDesFacRec( cFacRecL, cFacRecS )

   DEFAULT cFacRecL  := D():FacturasRectificativasLineas( nView)
   DEFAULT cFacRecS  := dbfFacRecS

RETURN ( Descrip( cFacRecL, cFacRecS ) )

//---------------------------------------------------------------------------//

FUNCTION cDesFacRecLeng( cFacRecL, cFacRecS, cArtLeng )

   DEFAULT cFacRecL  := D():FacturasRectificativasLineas( nView)
   DEFAULT cFacRecS  := dbfFacRecS
   DEFAULT cArtLeng  := D():ArticuloLenguaje( nView )

RETURN ( DescripLeng( cFacRecL, cFacRecS, cArtLeng ) )

//------------------------------------------------------------------------//

Function cCtaFacRec( cFacRecT, cFacCliP, cBncCli )

   local cCtaFacRec  := ""

   DEFAULT cFacRecT  := D():FacturasRectificativas( nView )
   DEFAULT cFacCliP  := dbfFacCliP
   DEFAULT cBncCli   := dbfCliBnc

   cCtaFacRec        := Rtrim( ( cFacRecT )->cEntBnc + ( cFacRecT )->cSucBnc + ( cFacRecT )->cDigBnc + ( cFacRecT )->cCtaBnc )

   if empty( cCtaFacRec )
      if dbSeekInOrd( ( cFacRecT )->cSerie + Str( ( cFacRecT )->nNumFac ) + ( cFacRecT )->cSufFac, "rNumFac", cFacCliP )
         cCtaFacRec  := cClientCuenta( ( cFacCliP )->cCodCli, cBncCli )
      end if
   end if

Return ( cCtaFacRec )


//---------------------------------------------------------------------------//

Function isLineaTotalFacRec( uFacRecL )

   if isArray( uFacRecL )
      Return ( uFacRecL[ _LTOTLIN ] )
   end if

Return ( ( uFacRecL )->lTotLin )

//---------------------------------------------------------------------------//

Function nDescuentoLinealFacRec( uFacRecL, nDec, nVdv )

   local nDescuentoLineal

   if isArray( uFacRecL )
      nDescuentoLineal  := uFacRecL[ _NDTODIV ]
   else 
      nDescuentoLineal  := ( uFacRecL )->nDtoDiv
   end if

Return ( Round( nDescuentoLineal / nVdv, nDec ) )

//---------------------------------------------------------------------------//

Function nDescuentoPorcentualFacRec( uFacRecL )

   local nDescuentoPorcentual

   if isArray( uFacRecL )
      nDescuentoPorcentual  := uFacRecL[ _NDTO ]
   else 
      nDescuentoPorcentual  := ( uFacRecL )->nDto
   end if

Return ( nDescuentoPorcentual )

//---------------------------------------------------------------------------//

Function nDescuentoPromocionFacRec( uFacRecL )

   local nDescuentoPromocion

   if isArray( uFacRecL )
      nDescuentoPromocion  := uFacRecL[ _NDTOPRM ]
   else 
      nDescuentoPromocion  := ( uFacRecL )->nDtoPrm
   end if

Return ( nDescuentoPromocion )

//---------------------------------------------------------------------------//

Function nPuntoVerdeFacRec( uFacRecL )

   local nPuntoVerde

   if isArray( uFacRecL )
      nPuntoVerde  := uFacRecL[ _NPNTVER ]
   else 
      nPuntoVerde  := ( uFacRecL )->nPntVer
   end if

Return ( nPuntoVerde )

//---------------------------------------------------------------------------//

Function nTransporteFacRec( uFacRecL )

   local nTransporte

   if isArray( uFacRecL )
      nTransporte  := uFacRecL[ _NIMPTRN ]
   else 
      nTransporte  := ( uFacRecL )->nImpTrn
   end if

Return ( nTransporte )

//------------------------------------------------------------------------//
// Lineas de total

FUNCTION nTotLFacRec( uFacRecL, nDec, nRou, nVdv, lDto, lPntVer, lImpTrn, cPouDiv )

   local nCalculo
   local nUnidades

   DEFAULT uFacRecL     := D():FacturasRectificativasLineas( nView )
   DEFAULT nDec         := nDouDiv()
   DEFAULT nRou         := nRouDiv()
   DEFAULT nVdv         := 1
   DEFAULT lDto         := .t.
   DEFAULT lPntVer      := .t.
   DEFAULT lImpTrn      := .t.

   if isLineaTotalFacRec( uFacRecL )

      nCalculo          := nTotUFacRec( uFacRecL, nDec, nVdv )

   else

      nUnidades         := nTotNFacRec( uFacRecL )
      nCalculo          := nTotUFacRec( uFacRecL, nDec, nVdv ) * nUnidades

      /*
      Descuentos---------------------------------------------------------------
      */

      nCalculo          -= nDescuentoLinealFacRec( uFacRecL, nDec, nVdv ) * nUnidades

      if lDto .and. nDescuentoPorcentualFacRec( uFacRecL ) != 0 
         nCalculo       -= nCalculo * nDescuentoPorcentualFacRec( uFacRecL ) / 100
      end if

      if lDto .and. nDescuentoPromocionFacRec( uFacRecL ) != 0 
         nCalculo       -= nCalculo * nDescuentoPromocionFacRec( uFacRecL ) / 100
      end if

      /*
      Punto Verde--------------------------------------------------------------
      */

      if lPntVer .and. nPuntoVerdeFacRec( uFacRecL ) != 0
         nCalculo       += nPuntoVerdeFacRec( uFacRecL ) * nUnidades
      end if

      /*
      Transporte---------------------------------------------------------------
      */

      if lImpTrn .and. nTransporteFacRec( uFacRecL ) != 0
         nCalculo       += nTransporteFacRec( uFacRecL ) * nUnidades
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

/*
Devuelve el total de una linea de factura
*/

FUNCTION nTotUFacRec( uTmpLin, nDec, nVdv )

   local nCalculo    := 0

   DEFAULT uTmpLin   := D():FacturasRectificativasLineas( nView )
   DEFAULT nDec      := nDouDiv()
   DEFAULT nVdv      := 1

   do case
      case IsChar( uTmpLin )
         nCalculo    := ( uTmpLin )->nPreUnit

      case IsObject( uTmpLin )
         nCalculo    := uTmpLin:nPreUnit

      case IsArray( uTmpLin )
         nCalculo    := uTmpLin[ _NPREUNIT ]

      case IsHash( uTmpLin )
         nCalculo    := hGet( uTmpLin, "PrecioVenta" )
   end case 

   nCalculo          := nCalculo / nVdv

RETURN ( Round( nCalculo, nDec ) )

//---------------------------------------------------------------------------//

Function nImportaLineas()

   local oDlg
   local oBmp
   local oBtnOk
   local oBtnCancel
   local oOption
   local nOption  := 1
   local cText    := "¿Desea importar las lineas de la factura?"

   DEFINE DIALOG oDlg RESOURCE "IMPFACREC"

   REDEFINE BITMAP oBmp       ID 500         OF oDlg RESOURCE "gc_question_48" TRANSPARENT

   REDEFINE SAY PROMPT cText  ID 100         OF oDlg

   REDEFINE RADIO oOption VAR nOption ;
         ID       110, 120 ;
         OF       oDlg

   REDEFINE BUTTON oBtnOk     ID IDOK        OF oDlg ACTION ( oDlg:end( IDOK ) )

   REDEFINE BUTTON oBtnCancel ID IDCANCEL    OF oDlg ACTION ( oDlg:end() )

   oDlg:AddFastKey( VK_F5, {|| oDlg:end( IDOK ) } )

   ACTIVATE DIALOG oDlg CENTER

   if oDlg:nResult != IDOK
      nOption     := 0
   end if

   if !empty( oBmp )
      oBmp:End()
   end if

RETURN ( nOption )

//----------------------------------------------------------------------------//

FUNCTION sTotFacRec( cFactura, cFacRecT, dbfFacRecL, dbfIva, dbfDiv, dbfFacCliP, cDivRet )

   local sTotal
   local nCobro

   nTotFacRec( cFactura, cFacRecT, dbfFacRecL, dbfIva, dbfDiv, nil, cDivRet, .f. )

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

   sTotal:aTotalIva                       := aTotIva

   nCobro                                 := nPagFacRec( cFactura, cFacRecT, dbfFacCliP, dbfIva, dbfDiv, nil, .t. )

   sTotal:nTotalCobrado                   := nCobro

Return ( sTotal )

//--------------------------------------------------------------------------//

FUNCTION browseFacturasRectificativas( oGet, oIva, nView )

	local oDlg
	local oBrw
   local oGet1
   local cGet1
   local oCbxOrd
   local cCbxOrd
   local nOrd
   local aCbxOrd

   aCbxOrd        := { "Número", "Fecha", "Cliente", "Nombre" }
   nOrd           := GetBrwOpt( "BrwFacRec" )
   nOrd           := Min( Max( nOrd, 1 ), len( aCbxOrd ) )
   cCbxOrd        := aCbxOrd[ nOrd ]

   D():getStatusFacturasRectificativas( nView )  

   DEFINE DIALOG oDlg RESOURCE "HELPENTRY" TITLE "Facturas rectificativas de clientes"

		REDEFINE GET oGet1 VAR cGet1;
			ID 		104 ;
         ON CHANGE( AutoSeek( nKey, nFlags, Self, oBrw, D():FacturasRectificativas( nView ), nil, nil, .f. ) );
         VALID    ( OrdClearScope( oBrw, D():FacturasRectificativas( nView ) ) );
         BITMAP   "FIND" ;
         OF       oDlg

		REDEFINE COMBOBOX oCbxOrd ;
			VAR 		cCbxOrd ;
			ID 		102 ;
         ITEMS    aCbxOrd ;
         ON CHANGE( ( D():FacturasRectificativas( nView ) )->( OrdSetFocus( oCbxOrd:nAt ) ), oBrw:refresh(), oGet1:SetFocus() ) ;
			OF 		oDlg

      oBrw                 := IXBrowse():New( oDlg )

      oBrw:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrw:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrw:cAlias          := D():FacturasRectificativas( nView )
      oBrw:nMarqueeStyle   := 5
      oBrw:cName           := "Factura de cliente.Browse"

      oBrw:bLDblClick      := {|| oDlg:end( IDOK ) }

      oBrw:CreateFromResource( 105 )

      with object ( oBrw:AddCol() )
         :cHeader          := "Número"
         :cSortOrder       := "nNumFac"
         :bEditValue       := {|| ( D():FacturasRectificativas( nView ) )->cSerie + "/" + RTrim( Str( ( D():FacturasRectificativas( nView ) )->nNumFac ) ) + "/" + ( D():FacturasRectificativas( nView ) )->cSufFac }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Fecha"
         :cSortOrder       := "dFecFac"
         :bEditValue       := {|| Dtoc( ( D():FacturasRectificativas( nView ) )->dFecFac ) }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Cliente"
         :cSortOrder       := "cCodCli"
         :bEditValue       := {|| Rtrim( ( D():FacturasRectificativas( nView ) )->cCodCli ) }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Nombre"
         :cSortOrder       := "cNomCli"
         :bEditValue       := {|| Rtrim( ( D():FacturasRectificativas( nView ) )->cNomCli ) }
         :nWidth           := 180
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Total"
         :bEditValue       := {|| ( D():FacturasRectificativas( nView ) )->nTotFac }
         :cEditPicture     := cPorDiv( ( D():FacturasRectificativas( nView ) )->cDivFac, dbfDiv )
         :nWidth           := 80
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
         :cSortOrder       := "nTotFac"
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

		REDEFINE BUTTON ;
			ID 		500 ;
			OF 		oDlg ;
         WHEN     ( .f. ) ;
         ACTION   ( nil )

		REDEFINE BUTTON ;
			ID 		501 ;
			OF 		oDlg ;
         WHEN     ( .f. ) ;
         ACTION   ( nil )

		REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
         ACTION   ( oDlg:end( IDOK ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
			ACTION 	( oDlg:end() )

   oDlg:AddFastKey( VK_F5, {|| oDlg:end( IDOK ) } )

   ACTIVATE DIALOG oDlg ON INIT ( oBrw:Load() ) CENTER

   if oDlg:nResult == IDOK

      oGet:cText( ( D():FacturasRectificativas( nView ) )->cSerie + Str( ( D():FacturasRectificativas( nView ) )->nNumFac ) + ( D():FacturasRectificativas( nView ) )->cSufFac )

      oGet:bWhen   := {|| .f. }

      if !empty( oIva )
         oIva:Click( ( D():FacturasRectificativas( nView ) )->lIvaInc ):Refresh()
      end if

   end if

   SetBrwOpt( "BrwFacRec", ( D():FacturasRectificativas( nView ) )->( OrdNumber() ) )

   D():setStatusFacturasRectificativas( nView )  

   /*
   Guardamos los datos del browse----------------------------------------------
   */

   oBrw:CloseData()

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//   

Function DesignLabelFacturaRectificativaClientes( oFr, cDoc )

   local oLabel
   local lOpenFiles  := empty( nView ) 

   if lOpenFiles .and. !Openfiles()
      Return .f.
   endif

   oLabel            := TLabelGeneratorFacturasRectificativaClientes():New( nView )

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

Return .t.

//--------------------------------------------------------------------------//

Static Function lChangeRegIva( aTmp )

   lImpuestos     := ( aTmp[ _NREGIVA ] <= 1 )

   if !empty( oImpuestos )
      oImpuestos:Refresh()
   end if

return ( .t. )
//---------------------------------------------------------------------------//

Function getExtraFieldFacturaRectificativa( cFieldName )

Return ( getExtraField( cFieldName, oDetCamposExtra, D():FacturasRectificativasId( nView ) ) )

//---------------------------------------------------------------------------//

Function nombrePrimeraPropiedadFacturasRectificativasLineas()

Return ( nombrePropiedad( ( D():FacturasRectificativasLineas( nView ) )->cCodPr1, ( D():FacturasRectificativasLineas( nView ) )->cValPr1, nView ) )

//---------------------------------------------------------------------------//

Function nombreSegundaPropiedadFacturasRectificativasLineas()

Return ( nombrePropiedad( ( D():FacturasRectificativasLineas( nView ) )->cCodPr2, ( D():FacturasRectificativasLineas( nView ) )->cValPr2, nView ) )

//---------------------------------------------------------------------------//

Function FacturasRectificativasId()

Return ( D():FacturasRectificativasId( nView ) )

//---------------------------------------------------------------------------//

CLASS TFacturasRectificativasSenderReciver FROM TSenderReciverItem

   Data lSuccesfullSendFacturas

   Data nFacturaNumberSend

   Method CreateData()

   Method RestoreData()

   Method SendData()

   Method ReciveData()

   Method Process()

   Method nGetFacturaNumberToSend()    INLINE ( ::nFacturaNumberSend     := GetPvProfInt( "Numero", "Facturas rectificativas", ::nFacturaNumberSend, ::cIniFile ) )

   Method IncFacturaNumberToSend()     INLINE ( WritePProString( "Numero", "Facturas rectificativas",    cValToChar( ++::nFacturaNumberSend ),  ::cIniFile ) )

   Method validateRecepcion( tmpFacRecT, cFacRecT )

END CLASS

//----------------------------------------------------------------------------//

Method CreateData() CLASS TFacturasRectificativasSenderReciver

   local oBlock
   local oError
   local nOrd
   local cFacRecT
   local dbfFacRecL
   local dbfFacRecI
   local tmpFacRecT
   local tmpFacRecL
   local tmpFacRecI
   local lSndFacRec           := .f.
   local cFileNameFacturas

   if ::oSender:lServer
      cFileNameFacturas       := "FacRec" + StrZero( ::nGetFacturaNumberToSend(), 6 ) + ".All"
   else
      cFileNameFacturas       := "FacRec" + StrZero( ::nGetFacturaNumberToSend(), 6 ) + "." + RetSufEmp()
   end if

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   USE ( cPatEmp() + "FacRecT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FacRecT", @cFacRecT ) )
   SET ADSINDEX TO ( cPatEmp() + "FacRecT.CDX" ) ADDITIVE

   USE ( cPatEmp() + "FacRecL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FacRecL", @dbfFacRecL ) )
   SET ADSINDEX TO ( cPatEmp() + "FacRecL.CDX" ) ADDITIVE

   USE ( cPatEmp() + "FacRecI.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FacRecI", @dbfFacRecI ) )
   SET ADSINDEX TO ( cPatEmp() + "FacRecI.CDX" ) ADDITIVE

   /*
   Creamos todas las bases de datos relacionadas
   */

   mkFacRec( cPatSnd() )

   USE ( cPatSnd() + "FacRecT.DBF" ) NEW VIA ( cLocalDriver() ) SHARED ALIAS ( cCheckArea( "FacRecT", @tmpFacRecT ) )
   SET INDEX TO ( cPatSnd() + "FacRecT.CDX" ) ADDITIVE

   USE ( cPatSnd() + "FacRecL.DBF" ) NEW VIA ( cLocalDriver() ) SHARED ALIAS ( cCheckArea( "FacRecL", @tmpFacRecL ) )
   SET INDEX TO ( cPatSnd() + "FacRecL.CDX" ) ADDITIVE

   USE ( cPatSnd() + "FacRecI.DBF" ) NEW VIA ( cLocalDriver() ) SHARED ALIAS ( cCheckArea( "FacRecI", @tmpFacRecI ) )
   SET INDEX TO ( cPatSnd() + "FacRecI.CDX" ) ADDITIVE

   if !empty( ::oSender:oMtr )
      ::oSender:oMtr:nTotal := ( cFacRecT )->( LastRec() )
   end if

   ::oSender:SetText( "Enviando facturas rectificativas de clientes" )

   nOrd  := ( cFacRecT )->( OrdSetFocus( "lSndDoc" ) )

   if ( cFacRecT )->( dbSeek( .t. ) )
      while !( cFacRecT )->( eof() )

         if ( cFacRecT )->lSndDoc

            lSndFacRec  := .t.

            dbPass( cFacRecT, tmpFacRecT, .t. )
            ::oSender:SetText( ( cFacRecT )->cSerie + "/" + alltrim( Str( ( cFacRecT )->nNumFac ) ) + "/" + alltrim( ( cFacRecT )->cSufFac ) + "; " + Dtoc( ( cFacRecT )->dFecFac ) + ";" + alltrim( ( cFacRecT )->cCodCli ) + "; " + ( cFacRecT )->cNomCli )

            if ( dbfFacRecL )->( dbSeek( ( cFacRecT )->cSerie + Str( ( cFacRecT )->nNumFac ) + ( cFacRecT )->cSufFac ) )
               while ( ( dbfFacRecL )->cSerie + Str( ( dbfFacRecL )->nNumFac ) + ( dbfFacRecL )->cSufFac ) == ( ( cFacRecT )->cSerie + Str( ( cFacRecT )->nNumFac ) + ( cFacRecT )->cSufFac ) .AND. !( dbfFacRecL )->( eof() )
                  dbPass( dbfFacRecL, tmpFacRecL, .t. )
                  ( dbfFacRecL )->( dbSkip() )
               end do
            end if

            if ( dbfFacRecI )->( dbSeek( ( cFacRecT )->cSerie + Str( ( cFacRecT )->nNumFac ) + ( cFacRecT )->cSufFac ) )
               while ( ( dbfFacRecI )->cSerie + Str( ( dbfFacRecI )->nNumFac ) + ( dbfFacRecI )->cSufFac ) == ( ( cFacRecT )->cSerie + Str( ( cFacRecT )->nNumFac ) + ( cFacRecT )->cSufFac ) .AND. !( dbfFacRecI )->( eof() )
                  dbPass( dbfFacRecI, tmpFacRecI, .t. )
                  ( dbfFacRecI )->( dbSkip() )
               end do
            end if

         end if

         ( cFacRecT )->( dbSkip() )

         if !empty( ::oSender:oMtr )
            ::oSender:oMtr:Set( ( cFacRecT )->( OrdKeyNo() ) )
         end if

      end do
   end if

   ( cFacRecT )->( OrdSetFocus( nOrd ) )

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   CLOSE ( cFacRecT )
   CLOSE ( dbfFacRecL )
   CLOSE ( dbfFacRecI )
   CLOSE ( tmpFacRecT )
   CLOSE ( tmpFacRecL )
   CLOSE ( tmpFacRecI )

   if lSndFacRec

      /*
      Comprimir los archivos---------------------------------------------------
      */

      ::oSender:SetText( "Comprimiendo facturas rectificativas" )

      if ::oSender:lZipData( cFileNameFacturas )
         ::oSender:SetText( "Ficheros comprimidos" )
      else
         ::oSender:SetText( "ERROR al crear fichero comprimido" )
      end if

   else

      ::oSender:SetText( "No hay facturas rectificativas de clientes para enviar" )

   end if

Return ( Self )

//----------------------------------------------------------------------------//

Method RestoreData() CLASS TFacturasRectificativasSenderReciver

   local cFacRecT

   if ::lSuccesfullSendFacturas

      USE ( cPatEmp() + "FacRecT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FacRecT", @cFacRecT ) )
      SET ADSINDEX TO ( cPatEmp() + "FacRecT.CDX" ) ADDITIVE
      ( cFacRecT )->( OrdSetFocus( "lSndDoc" ) )

      while ( cFacRecT )->( dbSeek( .t. ) ) .and. !( cFacRecT )->( eof() )
         if ( cFacRecT )->( dbRLock() )
            ( cFacRecT )->lSndDoc := .f.
            ( cFacRecT )->( dbRUnlock() )
         end if
      end do


      CLOSE ( cFacRecT )

   end if

Return ( Self )

//----------------------------------------------------------------------------//

Method SendData() CLASS TFacturasRectificativasSenderReciver

   local cFileNameFacturas
   local cDirectory           := ""

   if ::oSender:lServer
      cFileNameFacturas       := "FacRec" + StrZero( ::nGetFacturaNumberToSend(), 6 ) + ".All"
   else
      cFileNameFacturas       := "FacRec" + StrZero( ::nGetFacturaNumberToSend(), 6 ) + "." + RetSufEmp()
   end if

   ::lSuccesfullSendFacturas  := .f.

   /*
   Enviarlos a internet--------------------------------------------------------
   */

   if File( cPatOut() + cFileNameFacturas )

      if ::oSender:SendFiles( cPatOut() + cFileNameFacturas, cDirectory + cFileNameFacturas, cDirectory )
         ::lSuccesfullSendFacturas  := .t.
         ::oSender:SetText( "Fichero facturas rectificativas enviados " + cFileNameFacturas )
      else
         ::oSender:SetText( "ERROR al enviar fichero de facturas rectificativas" )
      end if

   end if

   /*
   Enviarlos a internet--------------------------------------------------------
   */

   if ::lSuccesfullSendFacturas
      ::IncFacturaNumberToSend()
   end if

Return ( Self )

//----------------------------------------------------------------------------//

Method ReciveData() CLASS TFacturasRectificativasSenderReciver

   local n
   local aExt

   aExt     := ::oSender:aExtensions()

   /*
   Recibirlo de internet
   */

   ::oSender:SetText( "Recibiendo facturas rectificativas de clientes" )

   for n := 1 to len( aExt )
      ::oSender:GetFiles( "FacRec*." + aExt[ n ], cPatIn() )
   next

   ::oSender:SetText( "Facturas rectificativas de clientes recibidos" )

Return Self

//----------------------------------------------------------------------------//

Method Process() CLASS TFacturasRectificativasSenderReciver

   local m
   local cFacRecT
   local dbfFacRecL
   local tmpFacRecT
   local tmpFacRecL
   local oBlock
   local oError
   local lClient        := ::oSender:lServer
   local aFiles         := Directory( cPatIn() + "FacRec*.*" )
   local cNumeroFactura
   local cTextoFactura  := ""

   for m := 1 to len( aFiles )

      ::oSender:SetText( "Procesando fichero : " + aFiles[ m, 1 ] )

      oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
      BEGIN SEQUENCE

      /*
      descomprimimos el fichero
      */

      if ::oSender:lUnZipData( cPatIn() + aFiles[ m, 1 ] )

         /*
         Ficheros temporales
         */

         if file( cPatSnd() + "FacRecT.Dbf" ) .and.;
            file( cPatSnd() + "FacRecL.Dbf" )

            USE ( cPatSnd() + "FacRecT.DBF" ) NEW VIA ( cLocalDriver() ) SHARED ALIAS ( cCheckArea( "FacRecT", @tmpFacRecT ) )

            USE ( cPatSnd() + "FacRecL.DBF" ) NEW VIA ( cLocalDriver() ) SHARED ALIAS ( cCheckArea( "FacRecL", @tmpFacRecL ) )
            SET INDEX TO ( cPatSnd() + "FacRecL.CDX" ) ADDITIVE

            USE ( cPatEmp() + "FacRecT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FacRecT", @cFacRecT ) )
            SET ADSINDEX TO ( cPatEmp() + "FacRecT.CDX" ) ADDITIVE

            USE ( cPatEmp() + "FacRecL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FacRecL", @dbfFacRecL ) )
            SET ADSINDEX TO ( cPatEmp() + "FacRecL.CDX" ) ADDITIVE

            ( tmpFacRecT )->( dbGoTop() )

            while ( tmpFacRecT )->( !eof() )

               /*
               Comprobamos que no exista la factura en la base de datos
               */

               if ::validateRecepcion( tmpFacRecT, cFacRecT )

                  cNumeroFactura    := ( tmpFacRecT )->cSerie + str( ( tmpFacRecT )->nNumFac ) + ( tmpFacRecT )->cSufFac
                  cTextoFactura     := ( tmpFacRecT )->cSerie + "/" + alltrim( str( ( tmpFacRecT )->nNumFac ) ) + "/" + alltrim( ( tmpFacRecT )->cSufFac ) + "; " + Dtoc( ( tmpFacRecT )->dFecFac ) + "; " + alltrim( ( tmpFacRecT )->cCodCli ) + "; " + ( tmpFacRecT )->cNomCli

                  while ( cFacRecT )->( dbseek( cNumeroFactura ) )
                     dbLockDelete( cFacRecT )
                  end if 

                  while ( dbfFacRecL )->( dbseek( cNumeroFactura ) )
                     dbLockDelete( dbfFacRecL )
                  end if

                  dbPass( tmpFacRecT, cFacRecT, .t. )

                  if dbLock( cFacRecT )
                     ( cFacRecT )->lSndDoc := .f.
                     ( cFacRecT )->( dbUnLock() )
                  end if

                  ::oSender:SetText( "Añadida rectificativa : " + cTextoFactura )

                  if ( tmpFacRecL )->( dbSeek( ( tmpFacRecT )->cSerie + Str( ( tmpFacRecT )->nNumFac ) + ( tmpFacRecT )->cSufFac ) )
                     while ( tmpFacRecL )->cSerie + Str( ( tmpFacRecL )->nNumFac ) + ( tmpFacRecL )->cSufFac == cNumeroFactura .and. !( tmpFacRecL )->( eof() )
                        dbPass( tmpFacRecL, dbfFacRecL, .t. )
                        ( tmpFacRecL )->( dbSkip() )
                     end do
                  end if

                  ::oSender:setText( "Añadidas lineas de rectificativa : " + cTextoFactura )

               else

                  ::oSender:SetText( "Factura fecha invalida : " + cTextoFactura )

               end if

               ( tmpFacRecT )->( dbSkip() )

            end while

            CLOSE ( cFacRecT )
            CLOSE ( dbfFacRecL )
            CLOSE ( tmpFacRecT )
            CLOSE ( tmpFacRecL )
            
            ::oSender:AppendFileRecive( aFiles[ m, 1 ] )

         else

            ::oSender:SetText( "Faltan ficheros" )

            if !file( cPatSnd() + "FacRecT.Dbf" )
               ::oSender:SetText( "Falta" + cPatSnd() + "FacRecT.Dbf" )
            end if

            if !file( cPatSnd() + "FacRecL.Dbf" )
               ::oSender:SetText( "Falta" + cPatSnd() + "FacRecL.Dbf" )
            end if

         end if

      else

         ::oSender:SetText( "Error al descomprimir los ficheros" )

      end if

      RECOVER USING oError

         CLOSE ( cFacRecT )
         CLOSE ( dbfFacRecL )
         CLOSE ( tmpFacRecT )
         CLOSE ( tmpFacRecL )

         ::oSender:SetText( "Error procesando fichero " + aFiles[ m, 1 ] )
         ::oSender:SetText( ErrorMessage( oError ) )

      END SEQUENCE

      ErrorBlock( oBlock )

   next

Return Self

//---------------------------------------------------------------------------//

METHOD validateRecepcion( tmpFacRecT, cFacRecT ) CLASS TFacturasRectificativasSenderReciver

   ::cErrorRecepcion       := "Pocesando rectificativa de cliente número " + ( cFacRecT )->cSerie + "/" + alltrim( Str( ( cFacRecT )->nNumFac ) ) + "/" + alltrim( ( cFacRecT )->cSufFac ) + " "

   if !( lValidaOperacion( ( tmpFacRecT )->dFecFac, .f. ) )
      ::cErrorRecepcion    += "la fecha " + dtoc( ( tmpFacRecT )->dFecFac ) + " no es valida en esta empresa"
      Return .f. 
   end if 

   if !( ( cFacRecT )->( dbSeek( ( tmpFacRecT )->cSerie + Str( ( tmpFacRecT )->nNumFac ) + ( tmpFacRecT )->cSufFac ) ) )
      Return .t.
   end if 

   if dtos( ( cFacRecT )->dFecCre ) + ( cFacRecT )->cTimCre >= dtos( ( tmpFacRecT )->dFecCre ) + ( tmpFacRecT )->cTimCre 
      ::cErrorRecepcion    += "la fecha en la empresa " + dtoc( ( cFacRecT )->dFecCre ) + " " + ( cFacRecT )->cTimCre + " es más reciente que la recepción " + dtoc( ( tmpFacRecT )->dFecCre ) + " " + ( tmpFacRecT )->cTimCre 
      Return .f.
   end if

Return ( .t. )

//---------------------------------------------------------------------------//

Static Function importarArticulosScaner()

   local memoArticulos

   memoArticulos  := dialogArticulosScaner()
   
   if memoArticulos != nil
      msgstop( memoArticulos, "procesar")
   end if

Return nil       

//---------------------------------------------------------------------------//