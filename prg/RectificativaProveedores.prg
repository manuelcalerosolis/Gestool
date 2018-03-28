#include "FiveWin.Ch"
#include "Font.ch"
#include "Folder.ch"
#include "Factu.ch" 
#include "Report.ch"
#include "Label.ch"
#include "FastRepH.ch"
#include "Xbrowse.ch"

#define CLR_BAR                  14197607
#define _MENUITEM_               "01099"

#define _CSERFAC                 1    //   C      1     0
#define _NNUMFAC                 2    //   N      9     0
#define _CSUFFAC                 3    //   N      9     0
#define _CTURFAC                 4    //   C      6     0
#define _DFECFAC                 5    //   D      8     0
#define _CCODPRV                 6    //   C      7     0
#define _CCODALM                 7    //   C      3     0
#define _CCODCAJ                 8    //   C      3     0
#define _CNOMPRV                 9    //   C     35     0
#define _CDIRPRV                 10   //   C     35     0
#define _CPOBPRV                 11   //   C     25     0
#define _CPROVPROV               12   //   C     20     0
#define _CPOSPRV                 13   //   C      5     0
#define _CDNIPRV                 14   //   C     15     0
#define _LLIQUIDADA              15   //   L      1     0
#define _LCONTAB                 16   //   L      1     0
#define _DFECENT                 17   //   D      8     0
#define _CSUPED                  18   //   C     10     0
#define _CCONDENT                19   //   C     20     0
#define _MCOMENT                 20   //   M     10     0  Comentarios
#define _CEXPED                  21   //   C     20     0
#define _COBSERV                 22   //   C     20     0
#define _CCODPAGO                23   //   C      2     0
#define _NBULTOS                 24   //   N      3     0
#define _NPORTES                 25   //   N      6     0
#define _CNUMFAC                 26   //   C     12     0
#define _LIMPALB                 27   //   L      1     0
#define _CDTOESP                 28   //   N      4     1
#define _NDTOESP                 29   //   N      4     1
#define _CDPP                    30   //   N      4     1
#define _NDPP                    31   //   N      4     1
#define _LRECARGO                32   //   L      1     0
#define _NIRPF                   33   //   N      4     1
#define _CCODAGE                 34   //   C      3     0
#define _CDIVFAC                 35   //   C      3     0
#define _NVDVFAC                 36   //   N     10     4
#define _LSNDDOC                 37   //   L      1     0
#define _CDTOUNO                 38   //   N      4     1
#define _NDTOUNO                 39   //   N      4     1
#define _CDTODOS                 40   //   N      4     1
#define _NDTODOS                 41   //   N      4     1
#define _CCODPRO                 42   //
#define _LRECDOC                 43   //   L      1     0
#define _LCLOFAC                 44   //   L      1     0
#define _CNUMDOC                 45   //   C     20     0
#define _CCODUSR                 46
#define _LIMPRIMIDO              47   //   L      1     0
#define _DFECIMP                 48   //   D      8     0
#define _CHORIMP                 49   //   C      5     0
#define _NTIPRET                 50
#define _NPCTRET                 51
#define _DFECCHG                 52   //   D      8     0
#define _CTIMCHG                 53   //   C      5     0
#define _CCODDLG                 54   //   C      2     0
#define _NREGIVA                 55   //   L      1     0
#define _LFACGAS                 56
#define _MCOMGAS                 57
#define _NNETGAS1                58
#define _NNETGAS2                59
#define _NNETGAS3                60
#define _NIVAGAS1                61
#define _NIVAGAS2                62
#define _NIVAGAS3                63
#define _NREGAS1                 64
#define _NREGAS2                 65
#define _NREGAS3                 66
#define _CMOTREC                 67    //   C     35     0
#define _CCAUREC                 68    //   C     35     0
#define _NTOTNET                 69
#define _NTOTIVA                 70
#define _NTOTREQ                 71
#define _NTOTFAC                 72
#define _NTOTSUP                 73
#define _CBANCO                  74
#define _CPAISIBAN               75
#define _CCTRLIBAN               76
#define _CENTBNC                 77
#define _CSUCBNC                 78
#define _CDIGBNC                 79
#define _CCTABNC                 80
#define _TFECFAC                 81
#define _CCENTROCOSTE            82
#define _CALMORIGEN              83
 
/*
Lineas de Detalle
*/

#define _CREF                       4      //   C     10     0
#define _CREFPRV                    5      //
#define _CDETALLE                   6      //   C     50     0
#define _NPREUNIT                   7      //   N     13     4
#define _NDTO                       8      //   N      5     1
#define _NIVA                       9      //   N      6     2
#define _NCANENT                   10      //   N     13     4
#define _LCONTROL                  11      //   L      1     0
#define _CUNIDAD                   12      //   C      2     0
#define _NUNICAJA                  13      //   N      8     3
#define _LCHGLIN                   14      //   L      1     0
#define _MLNGDES                   15      //   M     10     0
#define _NDTOLIN                   16      //   N      5     2
#define _NDTOPRM                   17      //   N      5     2
#define _NDTORAP                   18      //   N      5     2
#define _NPRECOM                   19      //   N      5     2
#define _LBNFLIN1                  20      //   N      5     1
#define _LBNFLIN2                  21      //   N      5     1
#define _LBNFLIN3                  22      //   N      5     1
#define _LBNFLIN4                  23      //   N      5     1
#define _LBNFLIN5                  24      //   N      5     1
#define _LBNFLIN6                  25      //   N      5     1
#define _NBNFLIN1                  26      //   N      5     1
#define _NBNFLIN2                  27      //   N      5     1
#define _NBNFLIN3                  28      //   N      5     1
#define _NBNFLIN4                  29      //   N      5     1
#define _NBNFLIN5                  30      //   N      5     1
#define _NBNFLIN6                  31      //   N      5     1
#define _NBNFSBR1                  32      //   N     13     3
#define _NBNFSBR2                  33      //   N     13     3
#define _NBNFSBR3                  34      //   N     13     3
#define _NBNFSBR4                  35      //   N     13     3
#define _NBNFSBR5                  36      //   N     13     3
#define _NBNFSBR6                  37      //   N     13     3
#define _NPVPLIN1                  38      //   N      6     2
#define _NPVPLIN2                  39      //   L      1     0
#define _NPVPLIN3                  40      //   C      5     0
#define _NPVPLIN4                  41      //   C      5     0
#define _NPVPLIN5                  42      //   C      5     0
#define _NPVPLIN6                  43      //   C      5     0
#define _NIVALIN1                  44      //   N     13     4
#define _NIVALIN2                  45      //   C      3     0
#define _NIVALIN3                  46      //   C      3     0
#define _NIVALIN4                  47      //   L      1     0
#define _NIVALIN5                  48      //   N      4     0
#define _NIVALIN6                  49
#define _NIVALIN                   50
#define _LIVALIN                   51      //   L     1      0
#define _CCODPR1                   52
#define _CCODPR2                   53      //   L     4      0
#define _CVALPR1                   54
#define _CVALPR2                   55
#define _NFACCNV                   56
#define _CALMLIN                   57
#define _NCTLSTK                   58
#define _LLOTE                     59
#define _NLOTE                     60
#define _CLOTE                     61
#define _DFECCAD                   62
#define _NNUMLIN                   63
#define _NUNDKIT                   64
#define _LKITART                   65
#define _LKITCHL                   66
#define _LKITPRC                   67
#define _LIMPLIN                   68
#define _MNUMSER                   69
#define _CCODUBI1                  70
#define _CCODUBI2                  71
#define _CCODUBI3                  72
#define _CVALUBI1                  73
#define _CVALUBI2                  74
#define _CVALUBI3                  75
#define _CNOMUBI1                  76
#define _CNOMUBI2                  77
#define _CNOMUBI3                  78
#define _CCODFAM                   79   //    C    8    0
#define _CGRPFAM                   80   //    C    3    0
#define _NREQ                      81   //    N   16    6
#define _MOBSLIN                   82   //    M   10    0
#define _NPVPREC                   83
#define _NNUMMED                   84
#define _NMEDUNO                   85
#define _NMEDDOS                   86
#define _NMEDTRE                   87
#define _LGASSUP                   88
#define __DFECFAC                  89 
#define __NBULTOS                  90  
#define _CFORMATO                  91
#define _CCODIMP                   92
#define _NVALIMP                   93
#define __TFECFAC                  94
#define __CCENTROCOSTE             95
#define __CALMORIGEN               96
#define _CREFAUX                   97 
#define _CREFAUX2                  98
#define _CTIPCTR                   99
#define _CTERCTR                  100

/*
Variables memvar para todo el .prg logico no!
*/

memvar cDbf
memvar cDbfCol
memvar cDbfRec
memvar cDbfAlm
memvar cDbfPrv
memvar cDbfPgo
memvar cDbfIva
memvar cDbfDiv
memvar cDbfArt
memvar cDbfKit
memvar cDbfPro
memvar cDbfTblPro
memvar aTotIva
memvar aIvaUno
memvar aIvaDos
memvar aIvaTre
memvar aDatVcto
memvar aImpVcto
memvar nTotBrt
memvar nTotNet
memvar nTotSup
memvar nTotIva
memvar nTotReq
memvar nTotRet
memvar nTotFac
memvar nTotDto
memvar nTotDpp
memvar nTotUno
memvar nTotDos
memvar nTotImp
memvar nTotUnd
memvar nTotIvm
memvar nPagFac
memvar nTipRet
memvar nTotPage
memvar cPinDivFac
memvar cPirDivFac
memvar cPicEurFac
memvar nDinDivFac
memvar nDirDivFac
memvar nVdvDivFac
memvar nPagina
memvar lEnd
memvar aImpVto
memvar aDatVto

/*
Variables Staticas para todo el .prg logico no!
*/

static oWndBrw
static oBrwIva
static oInf

static dbfRctPrvT
static dbfRctPrvL
static dbfRctPrvS
static filRctPrvL
static tmpRctPrvT
static tmpRctPrvP
static tmpRctPrvL
static tmpRctPrvI
static dbfRctPrvP
static dbfRctPrvI
static dbfRctPrvD

static dbfIva
static dbfPrv
static dbfFPago
static dbfTmp
static dbfArticulo
static dbfFamilia
static dbfCajT
static dbfDiv

static oBandera

static oStock
static TComercio

static oNewImp
static cNewFile
static cPicEur
static cPicUnd
static cPinDiv
static cPouDiv
static cPorDiv
static cTmpInc
static cTmpDoc
static cTmpPgo
static cTmpSer

static dbfTmpInc
static dbfTmpDoc
static dbfTmpPgo
static dbfTmpSer

static cPirDiv
static nDinDiv
static nRinDiv

static oGetTotal
static oGetTotPg
static oGetRet
static oGetNet
static oGetIva
static oGetReq
static oGetPgd
static oGetPdt
static oGetIvm
static oUsr
static cUsr
static oFntTot

static nView

static oMnuPgo
static oMnuRec

static aNumAlb          := {}
static nGetNeto         := 0
static nGetIva          := 0
static nGetReq          := 0
static nGetPgd          := 0

static oDetCamposExtra
static oCentroCoste

static oMailing

static cOldCodCli       := ""
static cOldCodArt       := ""
static cOldPrpArt       := ""
static cOldUndMed       := ""
static lOpenFiles       := .f.
static lExternal        := .f.
static nLabels          := 1
static cFiltroUsuario   := ""
static bEdtRec          := { |aTmp, aGet, dbf, oBrw, bWhen, bValid, nMode, cNumFac | EdtRec( aTmp, aGet, dbf, oBrw, bWhen, bValid, nMode, cNumFac ) }
static bEdtDet          := { |aTmp, aGet, dbf, oBrw, bWhen, bValid, nMode, aFac    | EdtDet( aTmp, aGet, dbf, oBrw, bWhen, bValid, nMode ) }
static bEdtInc          := { |aTmp, aGet, dbf, oBrw, bWhen, bValid, nMode, aTmpLin | EdtInc( aTmp, aGet, dbf, oBrw, bWhen, bValid, nMode, aTmpLin ) }
static bEdtDoc          := { |aTmp, aGet, dbf, oBrw, bWhen, bValid, nMode, aTmpLin | EdtDoc( aTmp, aGet, dbf, oBrw, bWhen, bValid, nMode, aTmpLin ) }
static bEdtPgo          := { |aTmp, aGet, dbf, oBrw, bWhen, bValid, nMode, aTmpFac | EdtPgo( aTmp, aGet, dbf, oBrw, bWhen, bValid, nMode, aTmpFac ) }

static Counter
static oTipoCtrCoste
static cTipoCtrCoste
static aTipoCtrCoste    := { "Centro de coste", "Proveedor", "Agente", "Cliente" }

// Declaración variables públicas-------------------------------------------

Static Function initPublics()

   public nTotBrt    := 0
   public nTotNet    := 0
   public nTotSup    := 0
   public nTotIva    := 0
   public nTotReq    := 0
   public nTotRet    := 0
   public nTotFac    := 0
   public nTotDto    := 0
   public nTotDpp    := 0
   public nTotUno    := 0
   public nTotDos    := 0
   public nTotImp    := 0
   public nTotUnd    := 0
   public nPagFac    := 0
   public nTipRet    := 0
   public nTotIvm    := 0 
   public aTotIva    := { { 0,0,nil,0,0,0,0,0,0,0,0 }, { 0,0,nil,0,0,0,0,0,0,0,0 }, { 0,0,nil,0,0,0,0,0,0,0,0 } }
   public aIvaUno    := aTotIva[ 1 ]
   public aIvaDos    := aTotIva[ 2 ]
   public aIvaTre    := aTotIva[ 3 ]

Return ( nil )

//----------------------------------------------------------------------------//
//Funciones del programa
//----------------------------------------------------------------------------//

STATIC FUNCTION OpenFiles( lExt )

   local oBlock

   if lOpenFiles
      MsgStop( 'Imposible abrir ficheros de facturas rectificativas a proveedores' )
      Return ( .f. )
   end if

   DEFAULT lExt         := .f.

   lExternal            := lExt

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      DisableAcceso()

      lOpenFiles        := .t.

      nView             := D():CreateView()

      D():FacturasRectificativasProveedores( nView )

      D():Proveedores( nView )

      D():GruposProveedores( nView )

      D():FacturasRectificativasProveedoresLineas( nView )

      D():FacturasRectificativasProveedoresIncidencias( nView )

      D():FacturasRectificativasProveedoresDocumentos( nView )

      D():FacturasRectificativasProveedoresSeries( nView )

      D():FacturasProveedoresPagos( nView )
      ( D():FacturasProveedoresPagos( nView ) )->( ordSetFocus( "rNumFac" ) )

      D():TiposIva( nView )

      D():ProveedorArticulo( nView )

      D():Articulos( nView )

      D():ArticulosCodigosBarras( nView )

      D():Familias( nView )

      D():Kit( nView )

      D():FormasPago( nView )

      D():ArticuloPrecioPropiedades( nView )

      D():Divisas( nView )

      D():Cajas( nView )

      // Documentos de compras-------------------------------------------------

      D():AlbaranesProveedores( nView )

      D():AlbaranesProveedoresLineas( nView )

      D():FacturasProveedores( nView )

      D():FacturasProveedoresLineas( nView )

      D():Propiedades( nView )

      D():PropiedadesLineas( nView )

      D():Almacen( nView )

      D():Documentos( nView )
      ( D():Documentos( nView ) )->( ordSetFocus( "cTipo" ) )

      D():Usuarios( nView )

      D():UbicacionLineas( nView )

      D():Delegaciones( nView )

      D():Contadores( nView )

      D():Empresa( nView )

      D():BancosProveedores( nView )

      D():GetObject( "UnidadMedicion", nView )

      D():GetObject( "Bancos", nView )

      D():ArticuloLenguaje( nView )

      oStock            := TStock():Create( cPatEmp() )
      if !oStock:lOpenFiles()
         lOpenFiles     := .f.
      end if 

      oNewImp           := TNewImp():Create( cPatEmp() )
      if !oNewImp:OpenFiles()
         lOpenFiles     := .f.
      end if
      
      oBandera          := TBandera():New()

      CodigosPostales():GetInstance():OpenFiles()

      TComercio         := TComercio():New( nView, oStock )

      oFntTot           := TFont():New( "Arial", 8, 26, .F., .T. )// Font del total

      oMailing          := TGenmailingDatabaseFacturaRectificativaProveedor():New( nView )

      Counter           := TCounter():New( nView, "nRctPrv" )

      initPublics()

      /*
      Limitaciones de cajero y cajas--------------------------------------------------------
      */

      if SQLAjustableModel():getRolFiltrarVentas( Auth():rolUuid() )
         cFiltroUsuario := "Field->cCodUsr == '" + Auth():Codigo()  + "' .and. Field->cCodCaj == '" + Application():CodigoCaja() + "'"
      end if

      /*
      Campos extras------------------------------------------------------------------------
      */

      oDetCamposExtra      := TDetCamposExtra():New()
      oDetCamposExtra:OpenFiles()
      oDetCamposExtra:SetTipoDocumento( "Facturas rectificativa a proveedores" )
      oDetCamposExtra:setbId( {|| D():FacturasRectificativasProveedoresId( nView ) } )


      /*
      Centro de coste-----------------------------------------------------------------------
      */

      oCentroCoste            := TCentroCoste():Create( cPatDat() )
      if !oCentroCoste:OpenFiles()
         lOpenFiles     := .f.
      end if 

      EnableAcceso()

   RECOVER

      lOpenFiles        := .f.

      EnableAcceso()

      msgStop( "Imposible abrir ficheros de facturas rectificativas a proveedores" )

   END SEQUENCE

   ErrorBlock( oBlock )

   if !lOpenFiles
      CloseFiles()
   end if


Return ( lOpenFiles )

//---------------------------------------------------------------------------//

Static Function CloseFiles()

   DisableAcceso()

   DestroyFastFilter( D():FacturasRectificativasProveedores( nView ), .t., .t. )

   if oStock != nil
      oStock:end()
   end if

   if !empty( oDetCamposExtra )
      oDetCamposExtra:CloseFiles()
   end if

   if !empty( oCentroCoste )
      oCentroCoste:CloseFiles()
   end if

   if !empty( oNewImp )
      oNewImp:end()
   end if

   if !empty(oMailing)
      oMailing:end()
   end if
   
   D():DeleteView( nView )

   CodigosPostales():GetInstance():CloseFiles()

   oBandera    := nil
   oStock      := nil
   oNewImp     := nil

   lOpenFiles  := .f.

   TComercio:end()

   EnableAcceso()

RETURN ( !lOpenFiles )

//------------------------------------------------------------------------//

FUNCTION RctPrv( oMenuItem, oWnd, cCodPrv, cCodArt, cNumFac )

   local oSnd
   local oRpl
   local oImp
   local oRotor
   local oDel
   local oPrv
   local oPdf
   local oMail
   local oBtnEur
   local nLevel
   local lEuro          := .f.
   local oLiq

   DEFAULT oMenuItem    := _MENUITEM_
   DEFAULT oWnd         := oWnd()
   DEFAULT cCodPrv      := ""
   DEFAULT cCodArt      := ""
   DEFAULT cNumFac      := ""

   /*
   Obtenemos el nivel de acceso
   */

   nLevel            := Auth():Level( oMenuItem )
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

   /*
   Anotamos el movimiento para el navegador
   */

   DisableAcceso()

   DEFINE SHELL oWndBrw FROM 0, 0 TO 22, 80 ;
      XBROWSE ;
      TITLE    "Facturas rectificativa de proveedores" ;
      PROMPTS  "Número",;
               "Fecha",;
               "Código",;
               "Proveedor",;
               "Número documento",;
               "Pago";
      MRU      "gc_document_text_delete2_16";
      BITMAP   Rgb( 0, 114, 198 ) ;
      ALIAS    ( D():FacturasRectificativasProveedores( nView ) );
      APPEND   ( WinAppRec( oWndBrw:oBrw, bEdtRec, D():FacturasRectificativasProveedores( nView ), cCodPrv, cCodArt, cNumFac ) );
      DUPLICAT ( WinDupRec( oWndBrw:oBrw, bEdtRec, D():FacturasRectificativasProveedores( nView ), cCodPrv, cCodArt, cNumFac ) );
      EDIT     ( WinEdtRec( oWndBrw:oBrw, bEdtRec, D():FacturasRectificativasProveedores( nView ), cCodPrv, cCodArt, cNumFac ) );
      ZOOM     ( WinZooRec( oWndBrw:oBrw, bEdtRec, D():FacturasRectificativasProveedores( nView ) ) );
      DELETE   ( WinDelRec( oWndBrw:oBrw, D():FacturasRectificativasProveedores( nView ), {|| QuiRctPrv() } ) );
      LEVEL    nLevel ;
      OF       oWnd

     oWndBrw:lFechado      := .t.

     oWndBrw:bChgIndex     := {|| if( SQLAjustableModel():getRolFiltrarVentas( Auth():rolUuid() ), CreateFastFilter( cFiltroUsuario, D():FacturasRectificativasProveedores( nView ), .f., , cFiltroUsuario ), CreateFastFilter( "", D():FacturasRectificativasProveedores( nView ), .f. ) ) }

      oWndBrw:SetYearComboBoxChange( {|| YearComboBoxChange() } )

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Sesión cerrada"
         :nHeadBmpNo       := 3
         :bStrData         := {|| "" }
         :bEditValue       := {|| ( D():FacturasRectificativasProveedores( nView ) )->lCloFac }
         :nWidth           := 20
         :lHide            := .t.
         :SetCheck( { "gc_lock2_12", "Nil16" } )
         :AddResource( "gc_lock2_16" )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Envio"
         :nHeadBmpNo       := 3
         :bStrData         := {|| "" }
         :bEditValue       := {|| ( D():FacturasRectificativasProveedores( nView ) )->lSndDoc }
         :nWidth           := 20
         :SetCheck( { "gc_mail2_12", "Nil16" } )
         :AddResource( "gc_mail2_16" )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Pagado"
         :nHeadBmpNo       := 4
         :bStrData         := {|| "" }
         :bBmpData         := {|| ChkPagRctPrv( D():FacturasRectificativasProveedores( nView ), D():FacturasProveedoresPagos( nView ) ) }
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
         :bEditValue       := {|| ( D():FacturasRectificativasProveedores( nView ) )->lContab }
         :nWidth           := 20
         :SetCheck( { "gc_folder2_12", "Nil16" } )
         :AddResource( "gc_folder2_16" )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Incidencia"
         :nHeadBmpNo       := 4
         :bStrData         := {|| "" }
         :bBmpData         := {|| nEstadoIncidencia( ( D():FacturasRectificativasProveedores( nView ) )->cSerFac + Str( ( D():FacturasRectificativasProveedores( nView ) )->nNumFac ) + ( D():FacturasRectificativasProveedores( nView ) )->cSufFac ) }
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
         :bEditValue       := {|| ( D():FacturasRectificativasProveedores( nView ) )->lImprimido }
         :nWidth           := 20
         :lHide            := .t.
         :SetCheck( { "gc_printer2_12", "Nil16" } )
         :AddResource( "gc_printer2_16" )

      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Número"
         :cSortOrder       := "nNumFac"
         :bEditValue       := {|| ( D():FacturasRectificativasProveedores( nView ) )->cSerFac + "/" + Alltrim( Str( ( D():FacturasRectificativasProveedores( nView ) )->nNumFac ) ) }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Delegación"
         :bEditValue       := {|| ( D():FacturasRectificativasProveedores( nView ) )->cSufFac }
         :nWidth           := 60
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Sesión"
         :bEditValue       := {|| Trans( ( D():FacturasRectificativasProveedores( nView ) )->cTurFac, "######" ) }
         :nWidth           := 60
         :lHide            := .t.
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Numero documento"
         :cSortOrder       := "cNumDoc"
         :bEditValue       := {|| ( D():FacturasRectificativasProveedores( nView ) )->cNumDoc }
         :nWidth           := 80
         :lHide            := .t.
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Fecha"
         :cSortOrder       := "dDesFec"
         :bEditValue       := {|| Dtoc( ( D():FacturasRectificativasProveedores( nView ) )->dFecFac ) }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Hora"
         :bEditValue       := {|| trans( ( D():FacturasRectificativasProveedores( nView ) )->tFecFac, "@R 99:99:99") }
         :nWidth           := 60
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Caja"
         :bEditValue       := {|| ( D():FacturasRectificativasProveedores( nView ) )->cCodCaj }
         :nWidth           := 40
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Usuario"
         :bEditValue       := {|| ( D():FacturasRectificativasProveedores( nView ) )->cCodUsr }
         :nWidth           := 40
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Código"
         :cSortOrder       := "cCodPrv"
         :bEditValue       := {|| ( D():FacturasRectificativasProveedores( nView ) )->cCodPrv }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Nombre"
         :cSortOrder       := "cNomPrv"
         :bEditValue       := {|| ( D():FacturasRectificativasProveedores( nView ) )->cNomPrv }
         :nWidth           := 180
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Pago"
         :cSortOrder       := "cCodPago"
         :bEditValue       := {|| ( D():FacturasRectificativasProveedores( nView ) )->cCodPago }
         :nWidth           := 40
         :lHide            := .t.
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Base"
         :bEditValue       := {|| ( D():FacturasRectificativasProveedores( nView ) )->nTotNet }
         :cEditPicture     := cPirDiv( ( D():FacturasRectificativasProveedores( nView ) )->cDivFac, D():Divisas( nView ) )
         :nWidth           := 80
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := cImp()
         :bEditValue       := {|| ( D():FacturasRectificativasProveedores( nView ) )->nTotIva }
         :cEditPicture     := cPirDiv( ( D():FacturasRectificativasProveedores( nView ) )->cDivFac, D():Divisas( nView ) )
         :nWidth           := 80
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "R.E."
         :bEditValue       := {|| ( D():FacturasRectificativasProveedores( nView ) )->nTotReq }
         :cEditPicture     := cPirDiv( ( D():FacturasRectificativasProveedores( nView ) )->cDivFac, D():Divisas( nView ) )
         :nWidth           := 80
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Total"
         :bEditValue       := {|| ( D():FacturasRectificativasProveedores( nView ) )->nTotFac }
         :cEditPicture     := cPirDiv( ( D():FacturasRectificativasProveedores( nView ) )->cDivFac, D():Divisas( nView ) )
         :nWidth           := 80
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Div."
         :bEditValue       := {|| cSimDiv( if( lEuro, cDivChg(), ( D():FacturasRectificativasProveedores( nView ) )->cDivFac ), D():Divisas( nView ) ) }
         :nWidth           := 30
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Centro de coste"
         :bEditValue       := {|| ( D():FacturasRectificativasProveedores( nView ) )->cCtrCoste }
         :nWidth           := 30
         :lHide            := .t.
      end with

      oWndBrw:lAutoSeek    := .f.

      oDetCamposExtra:addCamposExtra( oWndBrw )

      oWndBrw:cHtmlHelp    := "Factura rectificativa de proveedor"

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

   DEFINE BTNSHELL RESOURCE "EDIT" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( oWndBrw:RecEdit() );
      TOOLTIP  "(M)odificar";
      MRU ;
      HOTKEY   "M";
      LEVEL    ACC_EDIT

   DEFINE BTNSHELL RESOURCE "ZOOM" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( oWndBrw:RecZoom() );
      TOOLTIP  "(Z)oom";
      MRU ;
      HOTKEY   "Z";
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
      ACTION   ( nGenRctPrv( IS_PRINTER ) ) ;
      MENU     This:Toggle() ;
      TOOLTIP  "(I)mprimir";
      HOTKEY   "I";
      LEVEL    ACC_IMPR

      lGenFac( oWndBrw:oBrw, oImp, IS_PRINTER ) ;

   DEFINE BTNSHELL RESOURCE "GC_PRINTER2_" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( ImprimirSeriesFacturasRectificativasProveedores() ) ;
      TOOLTIP  "Imp(r)imir series";
      HOTKEY   "R";
      LEVEL    ACC_IMPR

   DEFINE BTNSHELL oPrv RESOURCE "PREV1" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( nGenRctPrv( IS_SCREEN ), oWndBrw:Refresh() ) ;
      MENU     This:Toggle() ;
      TOOLTIP  "(P)revisualizar";
      HOTKEY   "P";
      LEVEL    ACC_IMPR

      lGenFac( oWndBrw:oBrw, oPrv, IS_SCREEN ) ;

   DEFINE BTNSHELL oPdf RESOURCE "DOCLOCK" OF oWndBrw ;
      NOBORDER ;
      MENU     This:Toggle() ;
      ACTION   ( nGenRctPrv( IS_PDF ) ) ;
      TOOLTIP  "Pd(f)";
      HOTKEY   "F";
      LEVEL    ACC_IMPR

      lGenFac( oWndBrw:oBrw, oPdf, IS_PDF ) ;

   DEFINE BTNSHELL oMail RESOURCE "GC_MAIL_EARTH_" OF oWndBrw ;
      NOBORDER ;
      MENU     This:Toggle() ;
      ACTION   ( oMailing:documentsDialog( oWndBrw:oBrw:aSelected ) ) ;
      TOOLTIP  "Correo electrónico";
      LEVEL    ACC_IMPR

   DEFINE BTNSHELL RESOURCE "gc_portable_barcode_scanner_" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( TLabelGeneratorFacturaRectificativaProveedores():New( nView ):Dialog() ) ;
      TOOLTIP  "E(t)iquetas" ;
      HOTKEY   "T";
      LEVEL    ACC_IMPR

   DEFINE BTNSHELL oLiq RESOURCE "gc_money2_" GROUP OF oWndBrw ;
      NOBORDER ;
      ACTION   ( lLiquida( oWndBrw:oBrw ) ) ;
      TOOLTIP  "Pagar" ;
      LEVEL    ACC_EDIT

   DEFINE BTNSHELL RESOURCE "gc_money2_" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( aGetSelRec( oWndBrw, {|| lLiquida( oWndBrw:oBrw, ( D():FacturasRectificativasProveedores( nView ) )->cSerFac + Str( ( D():FacturasRectificativasProveedores( nView ) )->nNumFac ) + ( D():FacturasRectificativasProveedores( nView ) )->cSufFac ) }, "Liquidar series de facturas", .t., nil, .t., nil ) ) ;
      TOOLTIP  "Pagar series" ;
      FROM     oLiq ;
      CLOSED ;
      LEVEL    ACC_EDIT

   DEFINE BTNSHELL RESOURCE "BmpConta" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( aGetSelRec( oWndBrw, {|lChk1, lChk2, oTree | CntRctPrv( lChk1, lChk2, .t., oTree, nil, nil, D():FacturasRectificativasProveedores( nView ), D():FacturasRectificativasProveedoresLineas( nView ), D():FacturasProveedoresPagos( nView ), D():Proveedores( nView ), D():Divisas( nView ), D():Articulos( nView ), D():FormasPago( nView ), D():TiposIva( nView ) ) }, "Contabilizar facturas rectificativas", .f., "Simular resultados", .f., "Contabilizar pagos" ) ) ;
      TOOLTIP  "(C)ontabilizar" ;
      HOTKEY   "C";
      LEVEL    ACC_EDIT

   if oUser():lAdministrador()

      DEFINE BTNSHELL RESOURCE "ChgState" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( aGetSelRec( oWndBrw, {|lChk1| lCntRctPrv( lChk1, D():FacturasRectificativasProveedores( nView ) ) }, "Cambiar estado", .f., "Contabilizado", .t., nil ) ) ;
         TOOLTIP  "Cambiar Es(t)ado" ;
         HOTKEY   "T";
         LEVEL    ACC_EDIT

   end if

   DEFINE BTNSHELL oSnd RESOURCE "Lbl" GROUP OF oWndBrw ;
      NOBORDER ;
      MENU     This:Toggle() ;
      TOOLTIP  "En(v)iar" ;
      MESSAGE  "Seleccionar facturas para ser enviados" ;
      ACTION   lSnd( oWndBrw, D():FacturasRectificativasProveedores( nView ) ) ;
      HOTKEY   "V";
      LEVEL    ACC_EDIT

   DEFINE BTNSHELL oBtnEur RESOURCE "gc_currency_euro_" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( lEuro := !lEuro, oWndBrw:Refresh() ) ;
      TOOLTIP  "M(o)neda";
      HOTKEY   "O"

   DEFINE BTNSHELL RESOURCE "INFO" GROUP OF oWndBrw ;
      NOBORDER ;
      ACTION   ( TTrazaDocumento():Activate( RCT_PRV, ( D():FacturasRectificativasProveedores( nView ) )->cSerFac + Str( ( D():FacturasRectificativasProveedores( nView ) )->nNumFac ) + ( D():FacturasRectificativasProveedores( nView ) )->cSufFac ) ) ;
      TOOLTIP  "I(n)forme documento" ;
      HOTKEY   "N" ;
      LEVEL    ACC_EDIT

   DEFINE BTNSHELL RESOURCE "gc_document_text_pencil_" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( Counter:OpenDialog() ) ;
      TOOLTIP  "Establecer contadores" 

   if oUser():lAdministrador()

      DEFINE BTNSHELL oRpl RESOURCE "BMPCHG" GROUP OF oWndBrw ;
         NOBORDER ;
         MENU     This:Toggle() ;
         ACTION   ( ReplaceCreator( oWndBrw, D():FacturasRectificativasProveedores( nView ), aItmRctPrv() ) ) ;      
         TOOLTIP  "Cambiar campos" ;
         LEVEL    ACC_EDIT

      DEFINE BTNSHELL RESOURCE "BMPCHG" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( ReplaceCreator( oWndBrw, D():FacturasRectificativasProveedoresLineas( nView ), aColRctPrv() ) ) ;      
         TOOLTIP  "Lineas" ;
         FROM     oRpl ;
         CLOSED ;
         LEVEL    ACC_EDIT

   end if

   DEFINE BTNSHELL oRotor RESOURCE "ROTOR" GROUP OF oWndBrw ;
      ACTION   ( oRotor:Expand() ) ;
      TOOLTIP  "Rotor" ;
      LEVEL    ACC_EDIT

      DEFINE BTNSHELL RESOURCE "gc_businessman_" OF oWndBrw ;
         ACTION   ( EdtPrv( ( D():FacturasRectificativasProveedores( nView ) )->cCodPrv ) );
         TOOLTIP  "Modificar proveedor";
         FROM     oRotor ;
         LEVEL    ACC_EDIT

      DEFINE BTNSHELL RESOURCE "INFO" OF oWndBrw ;
         ACTION   ( InfProveedor( ( D():FacturasRectificativasProveedores( nView ) )->cCodPrv ) );
         TOOLTIP  "Informe proveedor";
         FROM     oRotor ;
         LEVEL    ACC_EDIT

      DEFINE BTNSHELL RESOURCE "gc_document_empty_businessman_" OF oWndBrw ;
         ACTION   ( if( !empty( ( D():FacturasRectificativasProveedores( nView ) )->cNumFac ), ZooFacPrv( ( D():FacturasRectificativasProveedores( nView ) )->cNumFac ), MsgStop( "La factura no proviene de un albarán" ) ) );
         TOOLTIP  "Visualizar factura";
         FROM     oRotor ;
         LEVEL    ACC_EDIT

      DEFINE BTNSHELL RESOURCE "GC_BRIEFCASE2_BUSINESSMAN_" OF oWndBrw ;
         ALLOW    EXIT ;
         ACTION   ( RecPrv( , , { ( D():FacturasRectificativasProveedores( nView ) )->cSerFac + Str( ( D():FacturasRectificativasProveedores( nView ) )->nNumFac ) + ( D():FacturasRectificativasProveedores( nView ) )->cSufFac } ) );
         TOOLTIP  "Modificar recibo" ;
         FROM     oRotor ;
         LEVEL    ACC_EDIT

   DEFINE BTNSHELL RESOURCE "END" GROUP OF oWndBrw ;
      ALLOW    EXIT ;
      ACTION   ( oWndBrw:End() ) ;
      TOOLTIP  "(S)alir" ;
      HOTKEY   "S"

   if SQLAjustableModel():getRolNoFiltrarVentas( Auth():rolUuid() )
      oWndBrw:oActiveFilter:SetFields( aItmRctPrv() )
      oWndBrw:oActiveFilter:SetFilterType( FAC_PRV )
   end if

   ACTIVATE WINDOW oWndBrw VALID ( CloseFiles() )

   enableAcceso()

   if !empty( oWndBrw )

      if uFieldempresa( 'lFltYea' )
         oWndBrw:setYearCombobox()
      end if

      if !empty( cCodPrv ) .or. !empty( cCodArt ) .or. !empty( cNumFac )
         oWndBrw:RecAdd()
      end if

      cCodPrv  := nil
      cCodArt  := nil
      cNumFac  := nil

   end if

Return .t.

//----------------------------------------------------------------------------//

STATIC FUNCTION EdtRec( aTmp, aGet, cRctPrvT, oBrw, cCodPrv, cCodArt, nMode, cNumFac )

   local n
   local oDlg
	local oFld
   local oBtnOk
   local oBrwLin
   local oBrwPgo
   local oBrwInc
   local oBrwDoc
   local cGetRet
   local oGet        := Array( 7 )
   local cGet        := Array( 7 )
   local oSayLabels  := Array( 7 )
   local cTlfPrv
   local oTlfPrv
   local oBmpDiv
   local oBmpEmp
   local nOrd        := ( D():FacturasRectificativasProveedores( nView ) )->( ordSetFocus( 1 ) )
   local aControl    := Array( 6 )
   local oSayGas     := Array( 16 )
   local oBmpGeneral

   cTlfPrv           := RetFld( aTmp[ _CCODPRV ], D():Proveedores( nView ), "Telefono" )
   cUsr              := RetFld( aTmp[ _CCODUSR ], D():Usuarios( nView ), "cNbrUse" )

   do case
   case nMode == APPD_MODE

      if !lCajaOpen( Application():CodigoCaja() ) .and. !oUser():lAdministrador()
         msgStop( "Esta caja " + Application():CodigoCaja() + " esta cerrada." )
         Return .f.
      end if

      aTmp[ _CSERFAC ]  := cNewSer( "nRctPrv", D():Contadores( nView ) )
      aTmp[ _CTURFAC ]  := cCurSesion()
      aTmp[ _CDIVFAC ]  := cDivEmp()
      aTmp[ _CCODALM ]  := Application():codigoAlmacen()
      aTmp[ _CCODCAJ ]  := Application():CodigoCaja()
      aTmp[ _NVDVFAC ]  := nChgDiv( aTmp[ _CDIVFAC ], D():Divisas( nView ) )
      aTmp[ _CSUFFAC ]  := RetSufEmp()
      aTmp[ _LSNDDOC ]  := .t.
      aTmp[ _CCODPRO ]  := cProCnt()
      aTmp[ _DFECENT ]  := Ctod( "" )
      aTmp[ _CCODUSR ]  := Auth():Codigo()
      aTmp[ _CCODDLG ]  := Application():CodigoDelegacion()
      aTmp[ _DFECIMP ]  := Ctod( "" )
      aTmp[ _TFECFAC ]  := getSysTime()

      if !empty( cCodPrv )
         aTmp[ _CCODPRV ]  := cCodPrv
      end if

      if !empty( cNumFac )
         aTmp[ _CNUMFAC ]  := cNumFac
      end if

   case nMode == DUPL_MODE

      if !lCajaOpen( Application():CodigoCaja() ) .and. !oUser():lAdministrador()
         msgStop( "Esta caja " + Application():CodigoCaja() + " esta cerrada." )
         Return .f.
      end if

      aTmp[ _CTURFAC ]  := cCurSesion()
      aTmp[ _CCODCAJ ]  := Application():CodigoCaja()
      aTmp[ _LSNDDOC ]  := .t.
      aTmp[ _DFECENT ]  := Ctod( "" )
      aTmp[ _DFECIMP ]  := Ctod( "" )
      aTmp[ _LCLOFAC ]  := .f.
      aTmp[ _LCONTAB ]  := .f.

   case nMode == EDIT_MODE

      if aTmp[ _LCONTAB ] .and. !ApoloMsgNoYes( "La modificación de esta factura rectificativa puede provocar descuadres contables." + CRLF + "¿ Desea continuar ?", "Factura ya contabilizada" )
         return .f.
      end if

      if aTmp[ _LRECDOC ]
         MsgStop( "El documento ha sido recibido por internet", "Imposible modificar" )
         return .f.
      end if

      if aTmp[ _LCLOFAC ] .AND. !oUser():lAdministrador()
         msgStop( "Solo puede modificar los facturas rectificativas cerradas los administradores." )
         return .f.
      end if

   end case

   if empty( aTmp[ _CDTOESP ] )
      aTmp[ _CDTOESP ]  := Padr( "General", 50 )
   end if

   if empty( aTmp[ _CDPP ] )
      aTmp[ _CDPP ]     := Padr( "Pronto pago", 50 )
   end if

   /*
   Comienza la transaccion-----------------------------------------------------
   */

   if BeginTrans( aTmp, nMode )
      Return .f.
   end if

   /*
   Este valor los guaradamos para detectar los posibles cambios
   */

   cOldCodCli  := aTmp[ _CCODPRV ]

   cPicUnd     := MasUnd()                               // Picture de las unidades
   cPinDiv     := cPinDiv( aTmp[ _CDIVFAC ], D():Divisas( nView ) )    // Picture de la divisa
   cPirDiv     := cPirDiv( aTmp[ _CDIVFAC ], D():Divisas( nView ) )    // Picture de la divisa redondeada
   nDinDiv     := nDinDiv( aTmp[ _CDIVFAC ], D():Divisas( nView ) )    // Decimales de la divisa
   nRinDiv     := nRinDiv( aTmp[ _CDIVFAC ], D():Divisas( nView ) )    // Decimales de la divisa redondeada
   cPouDiv     := cPouDiv( aTmp[ _CDIVFAC ], D():Divisas( nView ) ) // Picture de la divisa
   cPorDiv     := cPorDiv( aTmp[ _CDIVFAC ], D():Divisas( nView ) ) // Picture de la divisa redondeada

   /*
   Etiquetas-------------------------------------------------------------------
   */

   cGet[ 1 ]   := RetFld( aTmp[ _CCODALM ], D():Almacen( nView ) )
   cGet[ 2 ]   := RetFld( aTmp[ _CCODPRV ], D():Proveedores( nView ) )
   cGet[ 3 ]   := RetFld( aTmp[ _CCODPAGO], D():FormasPago( nView ) )
   cGet[ 5 ]   := RetFld( aTmp[ _CCODCAJ ], D():Cajas( nView ) )
   cGet[ 6 ]   := RetFld( cCodEmp() + aTmp[ _CCODDLG ], D():Delegaciones( nView ), "cNomDlg" )
   cGet[ 7 ]   := RetFld( aTmp[ _CALMORIGEN ], D():Almacen( nView ) )

   DEFINE DIALOG oDlg RESOURCE "RECTPRV" TITLE LblTitle( nMode ) + "facturas rectificativas de proveedores"

      REDEFINE FOLDER   oFld ;
         ID             400 ;
         OF             oDlg ;
         PROMPT         "&Factura",    "Da&tos",      "&Incidencias",   "D&ocumentos" ;
         DIALOGS        "RCTPRV_1",    "RCTPRV_2",    "PEDCLI_3",       "PEDCLI_4"

      REDEFINE BITMAP oBmpGeneral ;
        ID       990 ;
        RESOURCE "gc_document_text_blue_48" ;
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

      REDEFINE GET aGet[ _CCODUSR ] VAR aTmp[ _CCODUSR ];
         ID       125 ;
         WHEN     ( .f. ) ;
         VALID    ( SetUsuario( aGet[ _CCODUSR ], oUsr, nil, D():Usuarios( nView ) ) );
         OF       oFld:aDialogs[2]

      REDEFINE GET oUsr VAR cUsr ;
         ID       126 ;
         WHEN     ( .f. ) ;
         OF       oFld:aDialogs[2]

      /*
      Datos del proveedor------------------------------------------------------
      */

		REDEFINE GET aGet[ _CCODPRV ] VAR aTmp[ _CCODPRV ] ;
			ID 		140 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			COLOR 	CLR_GET ;
			PICTURE	( RetPicCodPrvEmp() ) ;
         VALID    ( loaPrv( aGet, aTmp, D():Proveedores( nView ), nMode, oGet[ 2 ], oTlfPrv ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwProvee( aGet[ _CCODPRV ], oGet[ 2 ] ) );
			OF 		oFld:aDialogs[1]

      REDEFINE GET aGet[ _CNOMPRV ] VAR aTmp[ _CNOMPRV ];
			ID 		141 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         COLOR    CLR_GET ;
			OF 		oFld:aDialogs[1]

      REDEFINE GET aGet[ _CDNIPRV ] VAR aTmp[ _CDNIPRV ] ;
         ID       106 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			COLOR 	CLR_GET ;
         OF       oFld:aDialogs[1]

      REDEFINE GET oTlfPrv VAR cTlfPrv ;
         ID       107 ;
         WHEN     ( .f. );
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CDIRPRV ] VAR aTmp[ _CDIRPRV ] ;
         ID       103 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         BITMAP   "gc_earth_lupa_16" ;
         ON HELP  GoogleMaps( aTmp[ _CDIRPRV ], Rtrim( aTmp[ _CPOBPRV ] ) + Space( 1 ) + Rtrim( aTmp[ _CPROVPROV ] ) ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CPOBPRV ] VAR aTmp[ _CPOBPRV ] ;
         ID       105 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			COLOR 	CLR_GET ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CPROVPROV ] VAR aTmp[ _CPROVPROV ] ;
         ID       108 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			COLOR 	CLR_GET ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CPOSPRV ] VAR aTmp[ _CPOSPRV ] ;
         ID       104 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         VALID    ( CodigosPostales():GetInstance():validCodigoPostal() );
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CCODALM ] VAR aTmp[ _CCODALM ] ;
			ID 		150 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         VALID    cAlmacen( aGet[_CCODALM], , oGet[ 1 ] );
         BITMAP   "LUPA" ;
         ON HELP  brwAlmacen( aGet[ _CCODALM ], oGet[ 1 ] );
			OF 		oFld:aDialogs[1]

      REDEFINE GET oGet[1] VAR cGet[1] ;
			ID 		151 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         BITMAP   "Bot" ;
         ON HELP  ( ExpAlmacen( aTmp[ _CCODALM ], dbfTmp, oBrwLin ) ) ;
			OF 		oFld:aDialogs[1]

      REDEFINE GET aGet[ _CALMORIGEN ] VAR aTmp[ _CALMORIGEN ]  ;
         ID       340 ;
         IDSAY    342 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( cAlmacen( aGet[ _CALMORIGEN ], , oGet[ 7 ] ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwAlmacen( aGet[ _CALMORIGEN ], oGet[ 7 ] ) ) ;
         COLOR    CLR_GET ;
         OF       oFld:aDialogs[1]

      REDEFINE GET oGet[ 7 ] VAR cGet[ 7 ] ;
         WHEN     .F. ;
         ID       341 ;
         OF       oFld:aDialogs[1]

		REDEFINE GET aGet[_CCODPAGO] VAR aTmp[_CCODPAGO];
			ID 		160 ;
			PICTURE 	"@!" ;
			COLOR 	CLR_GET ;
         WHEN     ( nMode != ZOOM_MODE .and. !lRecibosPagadosTmp( dbfTmpPgo ) ) ;
         VALID    cFPago( aGet[_CCODPAGO], D():FormasPago( nView ), oGet[3] ) ;
         BITMAP   "LUPA" ;
         ON HELP  BrwFPago( aGet[_CCODPAGO ], oGet[3] ) ;
			OF 		oFld:aDialogs[1]

      REDEFINE GET oGet[3] VAR cGet[3];
			ID 		161 ;
			WHEN 		.F. ;
			COLOR 	CLR_GET ;
			OF 		oFld:aDialogs[1]

      /*
      Bancos-------------------------------------------------------------------
      */

      REDEFINE GET aGet[ _CBANCO ] VAR aTmp[ _CBANCO ];
         ID       300 ;
         WHEN     ( nMode != ZOOM_MODE .and. !lRecibosPagadosTmp( dbfTmpPgo ) );
         BITMAP   "LUPA" ;
         ON HELP  ( BrwBncPrv( aGet[ _CBANCO ], aGet[ _CPAISIBAN ], aGet[ _CCTRLIBAN ], aGet[ _CENTBNC ], aGet[ _CSUCBNC ], aGet[ _CDIGBNC ], aGet[ _CCTABNC ], aTmp[ _CCODPRV ] ) );
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CPAISIBAN ] VAR aTmp[ _CPAISIBAN ] ;
         PICTURE  "@!" ;
         ID       301 ;
         WHEN     ( nMode != ZOOM_MODE .and. !lRecibosPagadosTmp( dbfTmpPgo ) );
         VALID    ( lIbanDigit( aTmp[ _CPAISIBAN ], aTmp[ _CENTBNC ], aTmp[ _CSUCBNC ], aTmp[ _CDIGBNC ], aTmp[ _CCTABNC ], aGet[ _CCTRLIBAN ] ) ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CCTRLIBAN ] VAR aTmp[ _CCTRLIBAN ] ;
         ID       302 ;
         WHEN     ( nMode != ZOOM_MODE .and. !lRecibosPagadosTmp( dbfTmpPgo ) );
         VALID    ( lIbanDigit( aTmp[ _CPAISIBAN ], aTmp[ _CENTBNC ], aTmp[ _CSUCBNC ], aTmp[ _CDIGBNC ], aTmp[ _CCTABNC ], aGet[ _CCTRLIBAN ] ) ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CENTBNC ] VAR aTmp[ _CENTBNC ];
         ID       303 ;
         WHEN     ( nMode != ZOOM_MODE .and. !lRecibosPagadosTmp( dbfTmpPgo ) );
         VALID    (  lCalcDC( aTmp[ _CENTBNC ], aTmp[ _CSUCBNC ], aTmp[ _CDIGBNC ], aTmp[ _CCTABNC ], aGet[ _CDIGBNC ] ),;
                     aGet[ _CPAISIBAN ]:lValid() ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CSUCBNC ] VAR aTmp[ _CSUCBNC ];
         ID       304 ;
         WHEN     ( nMode != ZOOM_MODE .and. !lRecibosPagadosTmp( dbfTmpPgo ) );
         VALID    (  lCalcDC( aTmp[ _CENTBNC ], aTmp[ _CSUCBNC ], aTmp[ _CDIGBNC ], aTmp[ _CCTABNC ], aGet[ _CDIGBNC ] ),;
                     aGet[ _CPAISIBAN ]:lValid() ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CDIGBNC ] VAR aTmp[ _CDIGBNC ];
         ID       305 ;
         WHEN     ( nMode != ZOOM_MODE .and. !lRecibosPagadosTmp( dbfTmpPgo ) );
         VALID    (  lCalcDC( aTmp[ _CENTBNC ], aTmp[ _CSUCBNC ], aTmp[ _CDIGBNC ], aTmp[ _CCTABNC ], aGet[ _CDIGBNC ] ),;
                     aGet[ _CPAISIBAN ]:lValid() ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CCTABNC ] VAR aTmp[ _CCTABNC ];
         ID       306 ;
         PICTURE  "9999999999" ;
         WHEN     ( nMode != ZOOM_MODE .and. !lRecibosPagadosTmp( dbfTmpPgo ) );
         VALID    (  lCalcDC( aTmp[ _CENTBNC ], aTmp[ _CSUCBNC ], aTmp[ _CDIGBNC ], aTmp[ _CCTABNC ], aGet[ _CDIGBNC ] ),;
                     aGet[ _CPAISIBAN ]:lValid() ) ;
         OF       oFld:aDialogs[1]

      /*
		Cajas____________________________________________________________________
		*/

      REDEFINE GET aGet[ _CCODCAJ ] VAR aTmp[ _CCODCAJ ];
			WHEN 		( nMode != ZOOM_MODE ) ;
         VALID    cCajas( aGet[ _CCODCAJ ], D():Cajas( nView ), oGet[ 5 ] ) ;
         ID       165 ;
			COLOR 	CLR_GET ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwCajas( aGet[ _CCODCAJ ], oGet[ 5 ] ) ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET oGet[ 5 ] VAR cGet[ 5 ] ;
         ID       166 ;
         WHEN     .f. ;
			COLOR 	CLR_GET ;
         OF       oFld:aDialogs[1]

		/*
		Moneda__________________________________________________________________
		*/

		REDEFINE GET aGet[ _CDIVFAC ] VAR aTmp[ _CDIVFAC ];
         WHEN     ( nMode == APPD_MODE ) ;
         VALID    ( cDivIn( aGet[ _CDIVFAC ], oBmpDiv, aGet[ _NVDVFAC ], @cPinDiv, @nDinDiv, @cPirDiv, @nRinDiv, nil, D():Divisas( nView ), oBandera ) );
			PICTURE	"@!";
			ID 		170 ;
         BITMAP   "LUPA" ;
         ON HELP  BrwDiv( aGet[ _CDIVFAC ], oBmpDiv, aGet[ _NVDVFAC ], D():Divisas( nView ), oBandera ) ;
			OF 		oFld:aDialogs[1]

		REDEFINE BITMAP oBmpDiv ;
         RESOURCE "BAN_EURO" ;
			ID 		171;
			OF 		oFld:aDialogs[1]

		REDEFINE GET aGet[ _NVDVFAC ] VAR aTmp[ _NVDVFAC ];
			WHEN		( .F. ) ;
			ID 		180 ;
			PICTURE	"@E 999,999.9999" ;
			OF 		oFld:aDialogs[1]

		/*
		Bitmap________________________________________________________________
      */

      REDEFINE BITMAP oBmpEmp ;
         FILE     "Bmp\ImgFacPrv.bmp" ;
         ID       500 ;
         OF       oDlg

      /*
		Botones_________________________________________________________________
		*/

      REDEFINE BUTTON aControl[1] ;
			ID 		500 ;
			OF 		oFld:aDialogs[1] ;
         WHEN     ( nMode != ZOOM_MODE .and. !lRecibosPagadosTmp( dbfTmpPgo ) ) ;
         ACTION   ( AppDeta( oBrwLin, bEdtDet, aTmp) )

      REDEFINE BUTTON aControl[2] ;
			ID 		501 ;
			OF 		oFld:aDialogs[1] ;
         WHEN     ( nMode != ZOOM_MODE .and. !lRecibosPagadosTmp( dbfTmpPgo )  ) ;
         ACTION   ( EdtDeta( oBrwLin, bEdtDet, aTmp ) )

      REDEFINE BUTTON aControl[3] ;
			ID 		502 ;
			OF 		oFld:aDialogs[1] ;
         WHEN     ( nMode != ZOOM_MODE .and. !lRecibosPagadosTmp( dbfTmpPgo ) ) ;
         ACTION   ( WinDelRec( oBrwLin, dbfTmp, {|| delDeta() }, {|| RecalculaTotal( aTmp ) } ) )

      REDEFINE BUTTON aControl[4] ;
			ID 		503 ;
			OF 		oFld:aDialogs[1] ;
         ACTION   ( if( !( dbfTmp )->lControl, WinZooRec( oBrwLin, bEdtDet, dbfTmp, aTmp ), ) )

      /*
      REDEFINE BUTTON ;
			ID 		530 ;
			OF 		oFld:aDialogs[1] ;
         WHEN     ( nMode != ZOOM_MODE .AND. !lRecibosPagados( aTmp, dbfTmpPgo ) ) ;
         ACTION   ( ImpFactura( oBrwLin, aGet, aTmp ) )
      */

      REDEFINE BUTTON aControl[5] ;
			ID 		524 ;
			OF 		oFld:aDialogs[1] ;
         WHEN     ( nMode != ZOOM_MODE .AND. !lRecibosPagadosTmp( dbfTmpPgo ) ) ;
         ACTION   ( DbSwapUp( dbfTmp, oBrwLin ) )

      REDEFINE BUTTON aControl[6] ;
			ID 		525 ;
			OF 		oFld:aDialogs[1] ;
         WHEN     ( nMode != ZOOM_MODE .AND. !lRecibosPagadosTmp( dbfTmpPgo ) ) ;
         ACTION   ( DbSwapDown( dbfTmp, oBrwLin ) )

		/*
		Detalle________________________________________________________________
      */

      oBrwLin                 := IXBrowse():New( oFld:aDialogs[1] )

      oBrwLin:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwLin:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrwLin:cAlias          := dbfTmp

      oBrwLin:nMarqueeStyle   := 6
      oBrwLin:lFooter         := .t.
      oBrwLin:cName           := "Lineas de facturas a proveedor"

         with object ( oBrwLin:AddCol() )
            :cHeader          := "Número"
            :bEditValue       := {|| if( ( dbfTmp )->lKitChl, "", Trans( ( dbfTmp )->nNumLin, "9999" ) ) }
            :nWidth           := 65
            :nDataStrAlign    := 1
            :nHeadStrAlign    := 1
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
            :bEditValue       := {|| if( empty( ( dbfTmp )->cRef ) .and. !( dbfTmp )->lControl, ( dbfTmp )->mLngDes, ( dbfTmp )->cDetalle ) }
            :nWidth           := 292
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
            :bEditValue       := {|| Dtoc( ( dbfTmp )->dFecCad ) }
            :nWidth           := 60
            :lHide            := .t.
         end with

         with object ( oBrwLin:AddCol() )
            :cHeader          := "Bultos"
            :bEditValue       := {|| ( dbfTmp )->nBultos }
            :cEditPicture     := cPicUnd
            :nWidth           := 60
            :nDataStrAlign    := 1
            :nHeadStrAlign    := 1
            :nFooterType      := AGGR_SUM
         end with

         with object ( oBrwLin:AddCol() )
            :cHeader          := cNombreCajas()
            :bEditValue       := {|| ( dbfTmp )->nCanEnt }
            :cEditPicture     := cPicUnd
            :nWidth           := 60
            :nDataStrAlign    := 1
            :nHeadStrAlign    := 1
            :nFooterType      := AGGR_SUM
         end with

         with object ( oBrwLin:AddCol() )
            :cHeader          := cNombreUnidades()
            :bEditValue       := {|| nTotNRctPrv( dbfTmp ) }
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
            :nWidth           := 65
         end with

         with object ( oBrwLin:AddCol() )
            :cHeader          := "Importe"
            :bEditValue       := {|| nTotURctPrv( dbfTmp, nDinDiv ) }
            :cEditPicture     := cPinDiv
            :nWidth           := 90
            :nDataStrAlign    := 1
            :nHeadStrAlign    := 1
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
            :bEditValue       := {|| nTotLRctPrv( dbfTmp, nDinDiv, nRinDiv ) }
            :cEditPicture     := cPirDiv
            :nWidth           := 90
            :nDataStrAlign    := 1
            :nHeadStrAlign    := 1
            :nFooterType      := AGGR_SUM
         end with

         with object ( oBrwLin:AddCol() )
         :cHeader          := "Centro de coste"
         :bEditValue       := {|| ( dbfTmp )->cCtrCoste }
         :nWidth           := 20
         :lHide            := .t.
      end with

         if nMode != ZOOM_MODE
            oBrwLin:bLDblClick   := {|| EdtDeta( oBrwLin, bEdtDet, aTmp ) }
         end if

      oBrwLin:CreateFromResource( 190 )

      /*
      Comentario para la factura de gastos_____________________________________
      */

      REDEFINE GET aGet[ _MCOMGAS ] VAR aTmp[ _MCOMGAS ] MEMO ;
         ID       290 ;
			COLOR 	CLR_GET ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

       /*
       Primer tipo de " + cImp() + " de gastos____________________________________________
       */

       REDEFINE GET aGet[ _NNETGAS1 ] VAR aTmp[ _NNETGAS1 ] ;
         ID       600 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  cPirDiv ;
         VALID    ( oSayGas[11]:Refresh(), oSayGas[12]:Refresh(), .t. );
         ON CHANGE( RecalculaTotal( aTmp ) );
         OF       oFld:aDialogs[1]

       REDEFINE GET aGet[ _NIVAGAS1 ] VAR aTmp[ _NIVAGAS1 ] ;
         ID       601 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  "@ER 99.99%" ;
         SPINNER ;
         VALID    ( oSayGas[11]:Refresh(), oSayGas[12]:Refresh(), .t. );
         ON CHANGE( RecalculaTotal( aTmp ) );
         OF       oFld:aDialogs[1]

      REDEFINE SAY oSayGas[11] PROMPT Trans( aTmp[ _NNETGAS1 ] * aTmp[ _NIVAGAS1 ] / 100, cPirDiv ) ;
         ID       602 ;
         COLOR    CLR_GET ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _NREGAS1 ] VAR aTmp[ _NREGAS1 ] ;
         ID       603 ;
         WHEN     ( nMode != ZOOM_MODE .and. aTmp[ _LRECARGO ] ) ;
         PICTURE  "@ER 99.99%" ;
         SPINNER ;
         VALID    ( oSayGas[11]:Refresh(), oSayGas[12]:Refresh(), .t. );
         ON CHANGE( RecalculaTotal( aTmp ) );
         OF       oFld:aDialogs[1]

      REDEFINE SAY oSayGas[12] PROMPT Trans( aTmp[ _NNETGAS1 ] * aTmp[ _NREGAS1 ] / 100, cPirDiv ) ;
         ID       604 ;
         COLOR    CLR_GET ;
         OF       oFld:aDialogs[1]

      /*
      Segundo tipo de " + cImp() + " de gastos____________________________________________
      */

      REDEFINE GET aGet[ _NNETGAS2 ] VAR aTmp[ _NNETGAS2 ] ;
         ID       610 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  cPirDiv ;
         VALID    ( oSayGas[13]:Refresh(), oSayGas[14]:Refresh(), .t. );
         ON CHANGE( RecalculaTotal( aTmp ) );
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _NIVAGAS2 ] VAR aTmp[ _NIVAGAS2 ] ;
         ID       611 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  "@ER 99.99%" ;
         SPINNER ;
         VALID    ( oSayGas[13]:Refresh(), oSayGas[14]:Refresh(), .t. );
         ON CHANGE( RecalculaTotal( aTmp ) );
         OF       oFld:aDialogs[1]

      REDEFINE SAY oSayGas[13] PROMPT Trans( aTmp[ _NNETGAS2 ] * aTmp[ _NIVAGAS2 ] / 100, cPirDiv ) ;
         ID       612 ;
         COLOR    CLR_GET ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _NREGAS2 ] VAR aTmp[ _NREGAS2 ] ;
         ID       613 ;
         WHEN     ( nMode != ZOOM_MODE .and. aTmp[ _LRECARGO ] ) ;
         PICTURE  "@ER 99.99%" ;
         SPINNER ;
         VALID    ( oSayGas[13]:Refresh(), oSayGas[14]:Refresh(), .t. );
         ON CHANGE( RecalculaTotal( aTmp ) );
         OF       oFld:aDialogs[1]

      REDEFINE SAY oSayGas[14] PROMPT Trans( aTmp[ _NNETGAS2 ] * aTmp[ _NREGAS2 ] / 100, cPirDiv ) ;
         ID       614 ;
         COLOR    CLR_GET ;
         OF       oFld:aDialogs[1]

      /*
      Tercer tipo de " + cImp() + " de gastos____________________________________________
      */

      REDEFINE GET aGet[ _NNETGAS3 ] VAR aTmp[ _NNETGAS3 ] ;
         ID       620 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  cPirDiv ;
         VALID    ( oSayGas[15]:Refresh(), oSayGas[16]:Refresh(), .t. );
         ON CHANGE( RecalculaTotal( aTmp ) );
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _NIVAGAS3 ] VAR aTmp[ _NIVAGAS3 ] ;
         ID       621 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  "@ER 99.99%" ;
         SPINNER ;
         VALID    ( oSayGas[15]:Refresh(), oSayGas[16]:Refresh(), .t. );
         ON CHANGE( RecalculaTotal( aTmp ) );
         OF       oFld:aDialogs[1]

      REDEFINE SAY oSayGas[15] PROMPT Trans( aTmp[ _NNETGAS3 ] * aTmp[ _NIVAGAS3 ] / 100, cPirDiv ) ;
         ID       622 ;
         COLOR    CLR_GET ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _NREGAS3 ] VAR aTmp[ _NREGAS3 ] ;
         ID       623 ;
         WHEN     ( nMode != ZOOM_MODE .and. aTmp[ _LRECARGO ] ) ;
         PICTURE  "@ER 99.99%" ;
         SPINNER ;
         VALID    ( oSayGas[15]:Refresh(), oSayGas[16]:Refresh(), .t. );
         ON CHANGE( RecalculaTotal( aTmp ) );
         OF       oFld:aDialogs[1]

      REDEFINE SAY oSayGas[16] PROMPT Trans( aTmp[ _NNETGAS3 ] * aTmp[ _NREGAS3 ] / 100, cPirDiv ) ;
         ID       624 ;
         COLOR    CLR_GET ;
         OF       oFld:aDialogs[1]

      /*
      Descuentos_______________________________________________________________
      */

      REDEFINE GET aGet[ _CDTOESP ] VAR aTmp[ _CDTOESP ] ;
         ID       199 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ON CHANGE( RecalculaTotal( aTmp ) );
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _NDTOESP ] VAR aTmp[ _NDTOESP ] ;
			ID 		200 ;
         WHEN     ( nMode != ZOOM_MODE .AND. !lRecibosPagadosTmp( dbfTmpPgo ) ) ;
         PICTURE  "@E 99.99" ;
         SPINNER ;
         ON CHANGE( RecalculaTotal( aTmp ) );
			OF 		oFld:aDialogs[1]

      REDEFINE GET aGet[ _CDPP ] VAR aTmp[ _CDPP ] ;
         ID       209 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ON CHANGE( RecalculaTotal( aTmp ) );
         OF       oFld:aDialogs[1]

		REDEFINE GET aGet[ _NDPP ] VAR aTmp[ _NDPP ];
			ID 		210 ;
         WHEN     ( nMode != ZOOM_MODE .AND. !lRecibosPagadosTmp( dbfTmpPgo ) ) ;
         PICTURE  "@E 99.99" ;
         SPINNER ;
         ON CHANGE( RecalculaTotal( aTmp ) );
			OF 		oFld:aDialogs[1]

      REDEFINE GET aGet[ _CDTOUNO ] VAR aTmp[ _CDTOUNO ] ;
			ID 		240 ;
			PICTURE 	"@!" ;
			COLOR 	CLR_GET ;
         WHEN     ( nMode != ZOOM_MODE .AND. !lRecibosPagadosTmp( dbfTmpPgo ) ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _NDTOUNO ] VAR aTmp[ _NDTOUNO ];
			ID 		250 ;
			PICTURE 	"@E 99.99" ;
         SPINNER ;
         ON CHANGE( RecalculaTotal( aTmp ) );
         WHEN     ( nMode != ZOOM_MODE .AND. !lRecibosPagadosTmp( dbfTmpPgo ) ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CDTODOS ] VAR aTmp[ _CDTODOS ] ;
         ID       260 ;
			PICTURE 	"@!" ;
         WHEN     ( nMode != ZOOM_MODE .AND. !lRecibosPagadosTmp( dbfTmpPgo ) ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _NDTODOS ] VAR aTmp[ _NDTODOS ];
         ID       270 ;
			PICTURE 	"@E 99.99" ;
         SPINNER ;
         ON CHANGE( RecalculaTotal( aTmp ) );
         WHEN     ( nMode != ZOOM_MODE .AND. !lRecibosPagadosTmp( dbfTmpPgo ) ) ;
         OF       oFld:aDialogs[1]

      /*
      Desglose del impuestos---------------------------------------------------------
      */

      oBrwIva                        := IXBrowse():New( oFld:aDialogs[ 1 ] )

      oBrwIva:bClrSel                := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwIva:bClrSelFocus           := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrwIva:SetArray( aTotIva )

      oBrwIva:lHScroll               := .f.
      oBrwIva:lVScroll               := .f.
      oBrwIva:nMarqueeStyle          := 5
      oBrwIva:lRecordSelector        := .f.

      oBrwIva:CreateFromResource( 490 )

      with object ( oBrwIva:aCols[ 1 ] )
         :cHeader       := "Bruto"
         :bStrData      := {|| if( !empty( aTotIva[ oBrwIva:nArrayAt, 1 ] ), Trans( aTotIva[ oBrwIva:nArrayAt, 2 ], cPirDiv ), "" ) }
         :nWidth        := 80
         :nDataStrAlign := 1
         :nHeadStrAlign := 1
         :nFootStrAlign := 1
      end with

      with object ( oBrwIva:aCols[ 2 ] )
         :cHeader       := "Base"
         :bStrData      := {|| if( !empty( aTotIva[ oBrwIva:nArrayAt, 2 ] ), Trans( aTotIva[ oBrwIva:nArrayAt, 2 ], cPirDiv ), "" ) }
         :nWidth        := 80
         :cEditPicture  := cPirDiv
         :nDataStrAlign := 1
         :nHeadStrAlign := 1
         :nFootStrAlign := 1
      end with

      with object ( oBrwIva:aCols[ 3 ] )
         :cHeader       := "%" + cImp()
         :bStrData      := {|| if( !IsNil( aTotIva[ oBrwIva:nArrayAt, 3 ] ), aTotIva[ oBrwIva:nArrayAt, 3 ], "" ) }
         :bEditValue    := {|| aTotIva[ oBrwIva:nArrayAt, 3 ] }
         :nWidth        := 45
         :cEditPicture  := "@E 999.99"
         :nDataStrAlign := 1
         :nHeadStrAlign := 1
         :nFootStrAlign := 1
         :nEditType     := 1
         :bEditWhen     := {|| !IsNil( aTotIva[ oBrwIva:nArrayAt, 3 ] ) }
         :bOnPostEdit   := {|o,x| EdtIva( o, x, aTotIva[ oBrwIva:nArrayAt, 3 ], dbfTmp, D():TiposIva( nView ), oBrwLin ), RecalculaTotal( aTmp ) }
      end with

      with object ( oBrwIva:aCols[ 4 ] )
         :cHeader       := "%R.E."
         :bStrData      := {|| if( !empty( aTotIva[ oBrwIva:nArrayAt, 4 ] ) .and. aTmp[ _LRECARGO ], Trans( aTotIva[ oBrwIva:nArrayAt, 4 ], "@E 99.9" ), "" ) }
         :nWidth        := 45
         :nDataStrAlign := 1
         :nHeadStrAlign := 1
         :nFootStrAlign := 1
      end with

      with object ( oBrwIva:aCols[ 5 ] )
         :cHeader       := cImp()
         :bStrData      := {|| if( !empty( aTotIva[ oBrwIva:nArrayAt, 5 ] ), Trans( aTotIva[ oBrwIva:nArrayAt, 5 ], cPirDiv ), "" ) }
         :nWidth        := 80
         :nDataStrAlign := 1
         :nHeadStrAlign := 1
         :nFootStrAlign := 1
      end with

      with object ( oBrwIva:aCols[ 6 ] )
         :cHeader       := "R.E."
         :bStrData      := {|| if( !empty( aTotIva[ oBrwIva:nArrayAt, 6 ] ) .and. aTmp[ _LRECARGO ], Trans( aTotIva[ oBrwIva:nArrayAt, 6 ], cPirDiv ), "" ) }
         :nWidth        := 80
         :cEditPicture  := cPirDiv
         :nDataStrAlign := 1
         :nHeadStrAlign := 1
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
         OF       oFld:aDialogs[ 1 ]

      REDEFINE SAY oGetIvm VAR nTotIvm;
         ID       403 ;
         OF       oFld:aDialogs[1]

      REDEFINE CHECKBOX aGet[ _LRECARGO ] VAR aTmp[ _LRECARGO ] ;
			ID 		400 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ON CHANGE( RecalculaTotal( aTmp ) );
         OF       oFld:aDialogs[ 1 ]

      REDEFINE SAY oGetTotal VAR nTotFac ;
			ID 		410 ;
         FONT     oFntTot ;
         OF       oFld:aDialogs[ 1 ]

      REDEFINE GET aGet[_CSERFAC] VAR aTmp[_CSERFAC] ;
         ID       100 ;
         PICTURE  "@!" ;
         SPINNER ;
         ON UP    ( UpSerie( aGet[_CSERFAC] ) );
         ON DOWN  ( DwSerie( aGet[_CSERFAC] ) );
         COLOR    CLR_GET ;
         WHEN     ( nMode == APPD_MODE .OR. nMode == DUPL_MODE );
         VALID    ( aTmp[_CSERFAC] >= "A" .AND. aTmp[_CSERFAC] <= "Z"  );
         OF       oFld:aDialogs[1]

         aGet[ _CSERFAC ]:bLostFocus := {|| aGet[ _CCODPRO ]:cText( cProCnt( aTmp[ _CSERFAC ] ) ) }

		REDEFINE GET aGet[_NNUMFAC] VAR aTmp[_NNUMFAC] ;
         ID       101 ;
			PICTURE 	"999999999";
			WHEN		.F. ;
			OF 		oFld:aDialogs[1]

		REDEFINE GET aGet[_CSUFFAC] VAR aTmp[_CSUFFAC];
         ID       102 ;
			WHEN 		.F. ;
			OF 		oFld:aDialogs[1]

		REDEFINE GET aGet[_DFECFAC] VAR aTmp[_DFECFAC] ;
			ID 		110 ;
			SPINNER ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			COLOR 	CLR_GET ;
			OF 		oFld:aDialogs[1]

      REDEFINE GET aGet[ _TFECFAC ] VAR aTmp[ _TFECFAC ] ;
         ID       111 ;
         PICTURE  "@R 99:99:99" ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( iif(   !validTime( aTmp[ _TFECFAC ] ),;
                           ( msgStop( "El formato de la hora no es correcto" ), .f. ),;
                           .t. ) );
         OF       oFld:aDialogs[1]

		REDEFINE GET aGet[_CSUPED] VAR aTmp[_CSUPED] ;
			ID 		120 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			COLOR	 	CLR_GET ;
			OF 		oFld:aDialogs[1]

      REDEFINE GET aGet[ _CNUMFAC ] VAR aTmp[ _CNUMFAC ] ;
			ID 		130 ;
         WHEN     ( nMode == APPD_MODE ) ;
         VALID    ( cFacPrv( aGet, oBrwLin, nMode, aTmp ), RecalculaTotal( aTmp ) ) ;
         ON HELP  ( brwFacPrv( aGet[ _CNUMFAC ], nView ) );
         BITMAP   "LUPA" ;
         OF       oFld:aDialogs[1]
      // PICTURE  "@R A/#########/##" ;

      REDEFINE CHECKBOX aGet[ _LFACGAS ] VAR aTmp[ _LFACGAS ] ;
         ID       550;
         WHEN     ( nMode == APPD_MODE ) ;
         ON CHANGE( ShowKitRctPrv( D():FacturasRectificativasProveedores( nView ), oBrwLin, cCodPrv, nil, aGet, aTmp, aControl, oSayGas, oSayLabels, oBrwIva ),;
                    RecalculaTotal( aTmp ), .t. );
         OF       oFld:aDialogs[1]

      REDEFINE COMBOBOX aGet[ _NTIPRET ] VAR aTmp[ _NTIPRET ] ;
         ITEMS    { "Ret. S/Base", "Ret. S/Total" };
         ID       440 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( RecalculaTotal( aTmp ) );
         ON CHANGE( RecalculaTotal( aTmp ) );
         OF       oFld:aDialogs[ 1 ]

      REDEFINE GET aGet[ _NPCTRET ] VAR aTmp[ _NPCTRET ] ;
         ID       450 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( RecalculaTotal( aTmp ) );
         ON CHANGE( RecalculaTotal( aTmp ) );
         PICTURE  "@E 99.9" ;
         OF       oFld:aDialogs[ 1 ]

      REDEFINE SAY oGetRet VAR cGetRet;
         ID       491 ;
			OF 		oFld:aDialogs[1]

      REDEFINE GROUP oSayLabels[ 1 ] ID 700 OF oFld:aDialogs[ 1 ] TRANSPARENT
      REDEFINE SAY   oSayLabels[ 2 ] ID 701 OF oFld:aDialogs[ 1 ]
      REDEFINE SAY   oSayLabels[ 3 ] ID 702 OF oFld:aDialogs[ 1 ]
      REDEFINE SAY   oSayLabels[ 4 ] ID 703 OF oFld:aDialogs[ 1 ]
      REDEFINE SAY   oSayLabels[ 5 ] ID 704 OF oFld:aDialogs[ 1 ]
      REDEFINE SAY   oSayLabels[ 6 ] ID 705 OF oFld:aDialogs[ 1 ]
      REDEFINE SAY   oSayLabels[ 7 ] ID 706 OF oFld:aDialogs[ 1 ]

      REDEFINE SAY   oSayGas[ 1 ]    ID 707 OF oFld:aDialogs[ 1 ]
      REDEFINE SAY   oSayGas[ 2 ]    ID 708 OF oFld:aDialogs[ 1 ]
      REDEFINE SAY   oSayGas[ 3 ]    ID 709 OF oFld:aDialogs[ 1 ]
      REDEFINE SAY   oSayGas[ 4 ]    ID 710 OF oFld:aDialogs[ 1 ]
      REDEFINE SAY   oSayGas[ 5 ]    ID 711 OF oFld:aDialogs[ 1 ]
      REDEFINE SAY   oSayGas[ 6 ]    ID 712 OF oFld:aDialogs[ 1 ]
      REDEFINE SAY   oSayGas[ 7 ]    ID 713 OF oFld:aDialogs[ 1 ]
      REDEFINE SAY   oSayGas[ 8 ]    ID 714 OF oFld:aDialogs[ 1 ]
      REDEFINE SAY   oSayGas[ 9 ]    ID 715 OF oFld:aDialogs[ 1 ]
      REDEFINE SAY   oSayGas[ 10]    ID 716 OF oFld:aDialogs[ 1 ]

      /*
		Redefinición de la segunda caja de dialogo
		------------------------------------------------------------------------
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

      REDEFINE GET aGet[ _DFECENT ] VAR aTmp[ _DFECENT ] ;
         ID       131 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[ 2 ]

      REDEFINE GET aGet[ _CNUMDOC ] VAR aTmp[ _CNUMDOC ] ;
         ID       142 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[ 2 ]

      /*
      Regimen de impuestos-----------------------------------------------------------
      */

      REDEFINE RADIO aGet[ _NREGIVA ] VAR aTmp[ _NREGIVA ] ;
         ID       270, 271, 272, 273 ;
         WHEN     ( .f. ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ _CCODDLG ] VAR aTmp[ _CCODDLG ] ;
         ID       300 ;
         WHEN     ( .f. ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET oGet[ 6 ] VAR cGet[ 6 ] ;
         ID       301 ;
         WHEN     ( .f. ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ _CCENTROCOSTE ] VAR aTmp[ _CCENTROCOSTE ] ;
            ID       350 ;
            IDTEXT   351 ;
            BITMAP   "LUPA" ;
            VALID    ( oCentroCoste:Existe( aGet[ _CCENTROCOSTE ], aGet[ _CCENTROCOSTE ]:oHelpText, "cNombre" ) );
            ON HELP  ( oCentroCoste:Buscar( aGet[ _CCENTROCOSTE ] ) ) ;
            WHEN     ( nMode != ZOOM_MODE ) ;
            OF       oFld:aDialogs[2]


      REDEFINE GET aGet[ _CCODPRO ] VAR aTmp[ _CCODPRO ] ;
         ID       170 ;
         PICTURE  "@R ###.######" ;
			COLOR 	CLR_GET ;
         WHEN     ( nLenCuentaContaplus() != 0 .AND. nMode != ZOOM_MODE ) ;
         VALID    ( ChkProyecto( aTmp[ _CCODPRO ], oGet[ 4 ] ), .t. );
         BITMAP   "LUPA" ;
         ON HELP  ( BrwProyecto( aGet[ _CCODPRO ], oGet[ 4 ] ) );
         OF       oFld:aDialogs[2]

      REDEFINE GET oGet[ 4 ] VAR cGet[ 4 ] ;
         ID       171 ;
			WHEN 		.F.;
			COLOR 	CLR_GET ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ _NBULTOS ] VAR aTmp[ _NBULTOS ] ;
         ID       132 ;
         PICTURE  "999999" ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[2]

      /*
      Campo para los comentarios---------------------------------------------
      */

      REDEFINE GET aGet[_MCOMENT] VAR aTmp[_MCOMENT];
			MEMO ;
         ID       210 ;
			COLOR 	CLR_GET ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			OF 		oFld:aDialogs[2]

      /*
		Redefine de la Zona de pagos-------------------------------------------
      */

      oBrwPgo                 := IXBrowse():New( oFld:aDialogs[2] )

      oBrwPgo:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwPgo:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrwPgo:cAlias          := dbfTmpPgo

      oBrwPgo:nMarqueeStyle   := 5
      oBrwPgo:cName           := "Pagos de facturas rectifiactivas de proveedor"

         with object ( oBrwPgo:AddCol() )
            :cHeader          := "Pg. Pagado"
            :bStrData         := {|| "" }
            :bBmpData         := {|| nEstadoReciboProveedor( dbfTmpPgo ) }
            :nWidth           := 22
            :AddResource( "Cnt16" )
            :AddResource( "Sel16" )
            :AddResource( "gc_undo_16" )
         end with

         with object ( oBrwPgo:AddCol() )
            :cHeader          := "Cn. Contabilizado"
            :bStrData         := {|| "" }
            :bEditValue       := {|| ( dbfTmpPgo )->lConPgo }
            :nWidth           := 22
            :SetCheck( { "Sel16", "Nil16" } )
         end with

         with object ( oBrwPgo:AddCol() )
            :cHeader          := "Sesión"
            :bEditValue       := {|| Trans( ( dbfTmpPgo )->cTurRec, "######" ) }
            :nWidth           := 40
            :nDataStrAlign    := 1
            :nHeadStrAlign    := 1
         end with

         with object ( oBrwPgo:AddCol() )
            :cHeader          := "Fecha"
            :bEditValue       := {|| Dtoc( ( dbfTmpPgo )->dPreCob ) }
            :nWidth           := 75
         end with

         with object ( oBrwPgo:AddCol() )
            :cHeader          := "Vencimiento"
            :bEditValue       := {|| Dtoc( ( dbfTmpPgo )->dFecVto ) }
            :lHide            := .t.
            :nWidth           := 70
         end with

         with object ( oBrwPgo:AddCol() )
            :cHeader          := "Cobro"
            :bEditValue       := {|| Dtoc( ( dbfTmpPgo )->dEntrada ) }
            :nWidth           := 75
         end with

         with object ( oBrwPgo:AddCol() )
            :cHeader          := "Descripción"
            :bEditValue       := {|| ( dbfTmpPgo )->cDescrip }
            :nWidth           := 175
         end with

         with object ( oBrwPgo:AddCol() )
            :cHeader          := "Importe"
            :bEditValue       := {|| nTotRecPrv( dbfTmpPgo, D():Divisas( nView ), nil, .t. ) }
            :nWidth           := 85
            :nDataStrAlign    := 1
            :nHeadStrAlign    := 1
         end with

         with object ( oBrwPgo:AddCol() )
            :cHeader          := "Divisa"
            :bEditValue       := {|| cSimDiv( ( dbfTmpPgo )->cDivPgo, D():Divisas( nView ) ) }
            :nWidth           := 60
         end with

         if nMode != ZOOM_MODE
            oBrwPgo:bLDblClick   := {|| ExtEdtRecPrv( dbfTmpPgo, nView, , oCentroCoste ), oBrwPgo:Refresh(), RecalculaTotal( aTmp ) }
         end if

      oBrwPgo:CreateFromResource( 220 )

      REDEFINE BUTTON ;
			ID 		501 ;
			OF 		oFld:aDialogs[2];
			WHEN 		( nMode == EDIT_MODE ) ;
         ACTION   ( ExtEdtRecPrv( dbfTmpPgo, nView, , oCentroCoste ), oBrwPgo:Refresh(), RecalculaTotal( aTmp ) )

		REDEFINE BUTTON ;
			ID 		502 ;
			OF 		oFld:aDialogs[2];
			WHEN 		( nMode == EDIT_MODE ) ;
         ACTION   ( ExtDelRecPrv( dbfTmpPgo ), oBrwPgo:Refresh(), RecalculaTotal( aTmp ) )

      REDEFINE BUTTON ;
         ID       505 ;
         OF       oFld:aDialogs[2];
         WHEN     ( nMode == EDIT_MODE ) ;
         ACTION   ( PrnRecPrv( ( dbfTmpPgo )->cSerFac + Str( ( dbfTmpPgo )->nNumFac ) + ( dbfTmpPgo )->cSufFac + Str( ( dbfTmpPgo )->nNumRec ), .f. ) )

      REDEFINE BUTTON ;
         ID       506 ;
         OF       oFld:aDialogs[2];
         WHEN     ( nMode == EDIT_MODE ) ;
         ACTION   ( VisRecPrv( ( dbfTmpPgo )->cSerFac + Str( ( dbfTmpPgo )->nNumFac ) + ( dbfTmpPgo )->cSufFac + Str( ( dbfTmpPgo )->nNumRec ), .f. ) )

      REDEFINE SAY oGetTotPg VAR nTotFac ;
         ID       405 ;
         OF       oFld:aDialogs[2]

		REDEFINE SAY oGetPgd VAR nGetPgd ;
			ID 		400 ;
			OF 		oFld:aDialogs[2]

      REDEFINE SAY oGetPdt VAR ( nTotFac - nGetPgd ) ;
			ID 		410 ;
			OF 		oFld:aDialogs[2]

      /*Impresión ( informa de si está impreimido o no y de cuando se imprimió )*/

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
      Caja de dialogo de incidencias
      */

      oBrwInc                 := IXBrowse():New( oFld:aDialogs[ 3 ] )

      oBrwInc:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwInc:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrwInc:cAlias          := dbfTmpInc

      oBrwInc:nMarqueeStyle   := 5
      oBrwInc:cName           := "Incidencias de facturas rectificativas de proveedor"

         with object ( oBrwInc:AddCol() )
            :cHeader          := "Resuelta"
            :bStrData         := {|| "" }
            :bEditValue       := {|| ( dbfTmpInc )->lListo }
            :nWidth           := 60
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
            :nWidth           := 425
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
      Caja de dialogo de incidencias
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

     REDEFINE BUTTON ;
         ID       10 ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( RecalculaFacturaRectificativas( aTmp, oDlg ), ( oBrwLin:Refresh() ), RecalculaTotal( aTmp ) )

      REDEFINE BUTTON oBtnOk;
         ID       IDOK ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( EndTrans( aTmp, aGet, oBrw, oBrwLin, nMode, nDinDiv, oDlg, oFld ) )

      REDEFINE BUTTON ;
         ID       3 ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( if( EndTrans( aTmp, aGet, oBrw, oBrwLin, nMode, nDinDiv, oDlg, oFld ), GenRctPrv( IS_PRINTER ), ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
         CANCEL ;
         ACTION   ( If( ExitNoSave( nMode, dbfTmp ), ( oDlg:end() ), ) )

   CodigosPostales():GetInstance():setBinding( { "CodigoPostal" => aGet[ _CPOSPRV ], "Poblacion" => aGet[ _CPOBPRV ], "Provincia" => aGet[ _CPROVPROV ] } )

   if nMode != ZOOM_MODE
      oFld:aDialogs[1]:AddFastKey( VK_F2, {|| AppDeta( oBrwLin, bEdtDet, aTmp) } )
      oFld:aDialogs[1]:AddFastKey( VK_F3, {|| EdtDeta( oBrwLin, bEdtDet, aTmp ) } )
      oFld:aDialogs[1]:AddFastKey( VK_F4, {|| WinDelRec( oBrwLin, dbfTmp, {|| delDeta() }, {|| RecalculaTotal( aTmp ) } ) } )

      oFld:aDialogs[2]:AddFastKey( VK_F3, {|| ExtEdtRecPrv( dbfTmpPgo, nView ), oBrwPgo:Refresh(), RecalculaTotal( aTmp ) } )
      oFld:aDialogs[2]:AddFastKey( VK_F4, {|| ExtDelRecPrv( dbfTmpPgo ), oBrwPgo:Refresh(), RecalculaTotal( aTmp ) } )

      oFld:aDialogs[3]:AddFastKey( VK_F2, {|| WinAppRec( oBrwInc, bEdtInc, dbfTmpInc, nil, nil, aTmp ) } )
      oFld:aDialogs[3]:AddFastKey( VK_F3, {|| WinEdtRec( oBrwInc, bEdtInc, dbfTmpInc, nil, nil, aTmp ) } )
      oFld:aDialogs[3]:AddFastKey( VK_F4, {|| DbDelRec( oBrwInc, dbfTmpInc, nil, nil, .t. ) } )

      oFld:aDialogs[4]:AddFastKey( VK_F2, {|| WinAppRec( oBrwDoc, bEdtDoc, dbfTmpDoc, nil, nil, aTmp ) } )
      oFld:aDialogs[4]:AddFastKey( VK_F3, {|| WinEdtRec( oBrwDoc, bEdtDoc, dbfTmpDoc, nil, nil, aTmp ) } )
      oFld:aDialogs[4]:AddFastKey( VK_F4, {|| DbDelRec( oBrwDoc, dbfTmpDoc, nil, nil, .f. ) } )

      oDlg:AddFastKey( VK_F5,             {|| EndTrans( aTmp, aGet, oBrw, oBrwLin, nMode, nDinDiv, oDlg, oFld ) } )
      oDlg:AddFastKey( VK_F6,             {|| if( EndTrans( aTmp, aGet, oBrw, oBrwLin, nMode, nDinDiv, oDlg, oFld ), GenRctPrv( IS_PRINTER ), ) } )
      oDlg:AddFastKey( VK_F9,             {|| oDetCamposExtra:Play( space(1) ) } )
      oDlg:AddFastKey( 65,                {|| if( GetKeyState( VK_CONTROL ), CreateInfoArticulo(), ) } )
   end if

   oDlg:AddFastKey ( VK_F1, {|| GoHelp() } )

   do case
      case nMode == APPD_MODE .and. lRecogerUsuario() .and. empty( cCodArt )
         oDlg:bStart := {|| if( lGetUsuario( aGet[ _CCODUSR ], D():Usuarios( nView ) ), , oDlg:end() ) }

      case nMode == APPD_MODE .and. lRecogerUsuario() .and. !empty( cCodArt )
         oDlg:bStart := {|| if( lGetUsuario( aGet[ _CCODUSR ], D():Usuarios( nView ) ), AppDeta( oBrwLin, bEdtDet, aTmp, cCodArt ), oDlg:end() ) }

      case nMode == APPD_MODE .and. !lRecogerUsuario() .and. !empty( cCodArt )
         oDlg:bStart := {|| AppDeta( oBrwLin, bEdtDet, aTmp, cCodArt ) }

      otherwise
         oDlg:bStart := {|| StartEdtRec( aGet, oGet, nMode ) }

   end case

	ACTIVATE DIALOG oDlg	;
      ON INIT     (  initEdtRec( cNumFac, aGet, aTmp, oDlg, oBrwLin, oBrwPgo, oBrwInc, cCodPrv, dbfTmpInc, aControl, oSayGas, oSayLabels, oBrwIva ) ) ;
      ON PAINT    (  RecalculaTotal( aTmp ) );
		CENTER

   oBmpEmp:End()
   oBmpGeneral:End()

   ( D():FacturasRectificativasProveedores( nView ) )->( OrdSetFocus( nOrd ) )

   /*
   Chequea si la factura esta liquidada----------------------------------------
   */

   ChkLqdRctPrv( nil, D():FacturasRectificativasProveedores( nView ), D():FacturasRectificativasProveedoresLineas( nView ), D():FacturasProveedoresPagos( nView ), D():TiposIva( nView ), D():Divisas( nView ) )

   /*
   Cerramos los ficheros-------------------------------------------------------
   */

   KillTrans( oBrwLin )

RETURN ( oDlg:nResult == IDOK )

//----------------------------------------------------------------------------//

Static Function StartEdtRec( aGet, oGet, nMode )
  
   if uFieldEmpresa( "lShowOrg" )
      aGet[ _CALMORIGEN ]:Show()
      oGet[7]:Show()
   else
      aGet[ _CALMORIGEN ]:Hide()
      oGet[7]:Hide()
   end if

   if nMode != APPD_MODE

      if !empty( aGet[ _CCENTROCOSTE ] )
         aGet[ _CCENTROCOSTE ]:lValid()
      endif 

   end if 

Return ( nil )

//---------------------------------------------------------------------------//

Static Function initEdtRec( cNumFac, aGet, aTmp, oDlg, oBrwLin, oBrwPgo, oBrwInc, cCodPrv, dbfTmpInc, aControl, oSayGas, oSayLabels, oBrwIva )

   if !empty( cNumFac )
      aGet[ _CNUMFAC ]:lValid()
   endif

   EdtRecMenu( aTmp, oDlg )
   ShowKitRctPrv( D():FacturasRectificativasProveedores( nView ), oBrwLin, cCodPrv, dbfTmpInc, aGet, aTmp, aControl, oSayGas, oSayLabels, oBrwIva )
   
   oBrwLin:MakeTotals()

   oBrwLin:Load()
   oBrwPgo:Load()
   oBrwInc:Load()

return( .t. )

//---------------------------------------------------------------------------//

Static Function RecalculaFacturaRectificativas( aTmp, oDlg )

   local nRecNum
   local nPreCom

   if !ApoloMsgNoYes( "¡Atención!,"                                      + CRLF + ;
                  "todos los precios se recalcularán en función de"  + CRLF + ;
                  "los valores en las bases de datos.",;
                  "¿ Desea proceder ?" )
      return nil
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

         ( dbfTmp )->nPreUnit       := nPreCom

      else

         if uFieldEmpresa( "lCosPrv", .f. )
            nPreCom                 := nPrecioReferenciaProveedor( aTmp[ _CCODPRV ], ( dbfTmp )->cRef, D():ProveedorArticulo( nView ) )
         end if

         if nPreCom != 0
            ( dbfTmp )->nPreUnit    := nPreCom
         else

            ( dbfTmp )->nPreUnit    := nCosto( ( dbfTmp )->cRef, D():Articulos( nView ), D():Kit( nView ), .f., aTmp[ _CDIVFAC ], D():Divisas( nView ) )
         end if

      end if

      ( dbfTmp )->( dbSkip() )

   end while

   ( dbfTmp )->( dbGoTo( nRecNum ) )

   oDlg:Enable()

return nil

//----------------------------------------------------------------------------//

Static Function EdtPgo( aTmp, aGet, dbfTmpPgo, oBrw, cDiv, oBandera, nMode, aTmpFac )

	local oDlg
   local oGetPrv
   local cGetPrv        := RetProvee( aTmp[ ( dbfTmpPgo )->( FieldPos( "CCODPRV" ) ) ], D():Proveedores( nView ) )
   local oSay
   local cSay           := Num2Text( aTmp[ ( dbfTmpPgo )->( FieldPos( "NIMPORTE" ) ) ] )
   local oBmpDiv
   local oGetSubCta
   local cGetSubCta
   local cPirDiv        := cPirDiv( aTmp[ ( dbfTmpPgo )->( FieldPos( "CDIVPGO" ) ) ], D():Divisas( nView ) )
   local nDinDiv        := nRinDiv( aTmp[ ( dbfTmpPgo )->( FieldPos( "CDIVPGO" ) ) ], D():Divisas( nView ) )
   local nImpOld        := Abs( aTmp[ ( dbfTmpPgo )->( FieldPos( "NIMPORTE" ) ) ] )

   if empty( aTmp[ ( dbfTmpPgo )->( FieldPos( "CCODCAJ" ) ) ] )
      aTmp[ ( dbfTmpPgo )->( FieldPos( "CCODCAJ" ) ) ]   := Application():CodigoCaja()
   end if

   DEFINE DIALOG oDlg RESOURCE "PGO_PRV" TITLE LblTitle( nMode ) + "recibos de proveedores"

      REDEFINE GET aGet[ ( dbfTmpPgo )->( FieldPos( "DPRECOB" ) ) ];
         VAR      aTmp[ ( dbfTmpPgo )->( FieldPos( "DPRECOB" ) ) ];
			ID 		100 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ON HELP  aGet[ ( dbfTmpPgo )->( FieldPos( "DPRECOB" ) ) ]:cText( Calendario( aTmp[ ( dbfTmpPgo )->( FieldPos( "DPRECOB" ) ) ] ) ) ;
         COLOR    CLR_GET ;
			OF 		oDlg

      REDEFINE GET aGet[ ( dbfTmpPgo )->( FieldPos( "DFECVTO" ) ) ];
         VAR      aTmp[ ( dbfTmpPgo )->( FieldPos( "DFECVTO" ) ) ];
         ID       250 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ON HELP  aGet[ ( dbfTmpPgo )->( FieldPos( "DFECVTO" ) ) ]:cText( Calendario( aTmp[ ( dbfTmpPgo )->( FieldPos( "DFECVTO" ) ) ] ) ) ;
         COLOR    CLR_GET ;
			OF 		oDlg

      REDEFINE GET aGet[ ( dbfTmpPgo )->( FieldPos( "DENTRADA" ) ) ];
         VAR      aTmp[ ( dbfTmpPgo )->( FieldPos( "DENTRADA" ) ) ];
			ID 		110 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ON HELP  aGet[ ( dbfTmpPgo )->( FieldPos( "DENTRADA" ) ) ]:cText( Calendario( aTmp[ ( dbfTmpPgo )->( FieldPos( "DENTRADA" ) ) ] ) ) ;
         COLOR    CLR_GET ;
         OF       oDlg

      REDEFINE GET aGet[ ( dbfTmpPgo )->( FieldPos( "CCODPRV" ) ) ];
         VAR      aTmp[ ( dbfTmpPgo )->( FieldPos( "CCODPRV" ) ) ];
         ID       120 ;
         WHEN     ( .f. ) ;
			OF 		oDlg

      REDEFINE GET oGetPrv VAR cGetPrv ;
         ID       121 ;
         WHEN     .f.;
         OF       oDlg

      REDEFINE GET aGet[ ( dbfTmpPgo )->( FieldPos( "CCODPGO" ) ) ] ;
         VAR      aTmp[ ( dbfTmpPgo )->( FieldPos( "CCODPGO" ) ) ] ;
         ID       310 ;
         IDTEXT   311 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			PICTURE  "@!" ;
         VALID    ( cFPago( aGet[ ( dbfTmpPgo )->( FieldPos( "CCODPGO" ) ) ], D():FormasPago( nView ), aGet[ ( dbfTmpPgo )->( FieldPos( "CCODPGO" ) ) ]:oHelpText ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwFPago( aGet[ ( dbfTmpPgo )->( FieldPos( "CCODPGO" ) ) ], aGet[ ( dbfTmpPgo )->( FieldPos( "CCODPGO" ) ) ]:oHelpText ) ) ;
         OF       oDlg

      REDEFINE GET aGet[ ( dbfTmpPgo )->( FieldPos( "CCODBNC" ) ) ] ;
         VAR      aTmp[ ( dbfTmpPgo )->( FieldPos( "CCODBNC" ) ) ];
         ID       320 ;
         IDTEXT   321 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( D():GetObject( "Bancos", nView ):Existe( aGet[ ( dbfTmpPgo )->( FieldPos( "CCODBNC" ) ) ], aGet[ ( dbfTmpPgo )->( FieldPos( "CCODBNC" ) ) ]:oHelpText, "cNomBnc", .t., .t., "0" ) );
         ON HELP  ( D():GetObject( "Bancos", nView ):Buscar( aGet[ ( dbfTmpPgo )->( FieldPos( "CCODBNC" ) ) ] ) ) ;
         BITMAP   "LUPA" ;
         OF       oDlg

      REDEFINE GET aGet[ ( dbfTmpPgo )->( FieldPos( "CDESCRIP" ) ) ];
         VAR      aTmp[ ( dbfTmpPgo )->( FieldPos( "CDESCRIP" ) ) ];
         ID       140 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         COLOR    CLR_GET ;
         OF       oDlg

      REDEFINE GET aGet[ ( dbfTmpPgo )->( FieldPos( "CPGDOPOR" ) ) ];
         VAR      aTmp[ ( dbfTmpPgo )->( FieldPos( "CPGDOPOR" ) ) ];
         ID       150 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         COLOR    CLR_GET ;
			OF 		oDlg

      REDEFINE GET aGet[ ( dbfTmpPgo )->( FieldPos( "NIMPORTE" ) ) ];
         VAR      aTmp[ ( dbfTmpPgo )->( FieldPos( "NIMPORTE" ) ) ];
         ID       180 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( oSay:SetText( Num2Text( aTmp[ ( dbfTmpPgo )->( FieldPos( "NIMPORTE" ) ) ] ) ), .t. ) ;
         COLOR    CLR_GET ;
         PICTURE  ( cPirDiv ) ;
			OF 		oDlg

      REDEFINE CHECKBOX aGet[ ( dbfTmpPgo )->( FieldPos( "LRECIMP" ) ) ];
         VAR      aTmp[ ( dbfTmpPgo )->( FieldPos( "LRECIMP" ) ) ];
         ID       160 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET aGet[ ( dbfTmpPgo )->( FieldPos( "CDIVPGO" ) ) ];
         VAR      aTmp[ ( dbfTmpPgo )->( FieldPos( "CDIVPGO" ) ) ];
         WHEN     ( .f. ) ;
         VALID    ( cDivOut( aGet[ ( dbfTmpPgo )->( FieldPos( "CDIVPGO" ) ) ], oBmpDiv, aGet[ ( dbfTmpPgo )->( FieldPos( "NVDVPGO" ) ) ], @cPirDiv, @nDinDiv, nil, nil, nil, nil, nil, D():Divisas( nView ), oBandera ) );
         PICTURE  "@!";
         ID       170 ;
			COLOR 	CLR_GET ;
         BITMAP   "LUPA" ;
         ON HELP  BrwDiv( aGet[ ( dbfTmpPgo )->( FieldPos( "CDIVPGO" ) ) ], oBmpDiv, aGet[ ( dbfTmpPgo )->( FieldPos( "NVDVPGO" ) ) ], D():Divisas( nView ), oBandera ) ;
         OF       oDlg

		REDEFINE BITMAP oBmpDiv ;
         ID       171;
         OF       oDlg

      REDEFINE GET aGet[ ( dbfTmpPgo )->( FieldPos( "NVDVPGO" ) ) ];
         VAR      aTmp[ ( dbfTmpPgo )->( FieldPos( "NVDVPGO" ) ) ];
			WHEN		( .F. ) ;
         ID       172 ;
         VALID    ( aTmp[ ( dbfTmpPgo )->( FieldPos( "NVDVPGO" ) ) ] > 0 ) ;
         PICTURE  "@E 999,999.9999" ;
         COLOR    CLR_GET ;
         OF       oDlg

      REDEFINE CHECKBOX aGet[ ( dbfTmpPgo )->( FieldPos( "LCOBRADO" ) ) ];
         VAR      aTmp[ ( dbfTmpPgo )->( FieldPos( "LCOBRADO" ) ) ];
         ID       220 ;
         ON CHANGE( aGet[ ( dbfTmpPgo )->( FieldPos( "DENTRADA" ) ) ]:cText( if( aTmp[ ( dbfTmpPgo )->( FieldPos( "LCOBRADO" ) ) ], date(), ctod("") ) ) ) ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE CHECKBOX aGet[ ( dbfTmpPgo )->( FieldPos( "LNOTARQUEO" ) ) ];
         VAR      aTmp[ ( dbfTmpPgo )->( FieldPos( "LNOTARQUEO" ) ) ];
         ID       330 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE SAY oSay VAR cSay ;
         ID       190 ;
         COLOR    CLR_GET ;
         OF       oDlg

      REDEFINE GET aGet[ ( dbfTmpPgo )->( FieldPos( "CCTAREC" ) ) ];
         VAR      aTmp[ ( dbfTmpPgo )->( FieldPos( "CCTAREC" ) ) ];
         ID       240 ;
			COLOR 	CLR_GET ;
         PICTURE  ( Replicate( "X", nLenSubcuentaContaplus() ) ) ;
         WHEN     ( nLenCuentaContaplus() != 0 .AND. nMode != ZOOM_MODE ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwChkSubcuenta( aGet[ ( dbfTmpPgo )->( FieldPos( "CCTAREC" ) ) ], oGetSubCta ) ) ;
         VALID    ( MkSubcuenta( aGet[ ( dbfTmpPgo )->( FieldPos( "CCTAREC" ) ) ], { aTmp[ ( dbfTmpPgo )->( FieldPos( "CCTAREC" ) ) ] }, oGetSubCta ) );
         OF       oDlg

		REDEFINE GET oGetSubCta VAR cGetSubCta ;
         ID       241 ;
			COLOR 	CLR_GET ;
			WHEN 		.F. ;
         OF       oDlg

      /*
      Botones__________________________________________________________________
      */

      REDEFINE BUTTON ;
         ID       IDOK ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( EndPgo( nImpOld, aTmp, aGet, dbfTmpPgo, oBrw, nMode, oDlg ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
         CANCEL ;
         ACTION   ( oDlg:end() )

      REDEFINE BUTTON ;
         ID       998 ;
			OF 		oDlg ;
         ACTION   ( GoHelp() )

   if nMode != ZOOM_MODE
      oDlg:AddFastKey( VK_F5, {|| EndPgo( nImpOld, aTmp, aGet, dbfTmpPgo, oBrw, nMode, oDlg ) } )
   end if

   oDlg:AddFastKey( VK_F1, {|| GoHelp() } )

   ACTIVATE DIALOG oDlg CENTER;
      ON INIT ( EdtRecPgoMenu( aTmp, aGet, oDlg ),;
                aGet[ ( dbfTmpPgo )->( FieldPos( "CCODBNC" ) ) ]:lValid(),;
                aGet[ ( dbfTmpPgo )->( FieldPos( "CCODPGO" ) ) ]:lValid() )

   oMnuPgo:End()
   oBmpDiv:End()

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

Static Function EdtRecPgoMenu( aTmp, aGet, oDlg )

   local cCodPrv  := aTmp[ ( dbfTmpPgo )->( FieldPos( "CCODPRV" ) ) ]

   MENU oMnuPgo

      MENUITEM    "&1. Rotor"

         MENU

            MENUITEM "&1. Modificar proveedor";
            MESSAGE  "Modifica el proveedor de la factura rectificativa" ;
            RESOURCE "gc_businessman_16";
            ACTION   ( EdtPrv( cCodPrv ) )

            MENUITEM "&2. Informe proveedor";
            MESSAGE  "Informe del proveedor de la factura" ;
            RESOURCE "Info16";
            ACTION   ( InfProveedor( cCodPrv ) )

         ENDMENU

   ENDMENU

   oDlg:SetMenu( oMnuPgo )

   aGet[ ( dbfTmpPgo )->( FieldPos( "CDIVPGO" ) ) ]:lValid()
   aGet[ ( dbfTmpPgo )->( FieldPos( "CCTAREC" ) ) ]:lValid()

   aGet[ ( dbfTmpPgo )->( FieldPos( "DPRECOB" ) ) ]:SetFocus()

Return ( oMnuPgo )

//---------------------------------------------------------------------------//

Static Function EndPgo( nImpOld, aTmp, aGet, dbfTmpPgo, oBrw, nMode, oDlg )

   local nCon
   local nImp
   local nRec        := ( dbfTmpPgo )->( Recno() )
   local lImpNeg     := aTmp[ ( dbfTmpPgo )->( FieldPos( "nImporte" ) ) ] < 0
   local nImpAct     := Abs( aTmp[ ( dbfTmpPgo )->( FieldPos( "nImporte" ) ) ] )

   /*
   El importe no puede ser mayor q el importe anterior-------------------------

   if nImpAct > nImpOld
      msgStop( "El importe no puede ser superior al actual." )
      return nil
   end if
   */

   aTmp[ ( dbfTmpPgo )->( FieldPos( "DFECCHG" ) ) ]  := GetSysDate()
   aTmp[ ( dbfTmpPgo )->( FieldPos( "CTIMCHG" ) ) ]  := Time()

   /*
   Comprobamos q los importes sean distintos-----------------------------------
   */

   if nImpAct != nImpOld

      /*
      El importe ha cambiado por tanto debemos de hacer un nuevo recibo por la diferencia
      */

      nImp                       := ( nImpOld - nImpAct ) * if( lImpNeg, - 1 , 1 )

      /*
      Añadimos el nuevo recibo
      */

      ( dbfTmpPgo )->( dbAppend() )

      nCon                       := ( dbfTmpPgo )->( LastRec() )

      ( dbfTmpPgo )->cTurRec     := cCurSesion()

      ( dbfTmpPgo )->cSerFac     := aTmp[ ( dbfTmpPgo )->( FieldPos( "cSerFac"  ) ) ]
      ( dbfTmpPgo )->nNumFac     := aTmp[ ( dbfTmpPgo )->( FieldPos( "nNumFac" ) ) ]
      ( dbfTmpPgo )->cSufFac     := aTmp[ ( dbfTmpPgo )->( FieldPos( "cSufFac" ) ) ]
      ( dbfTmpPgo )->nNumRec     := nCon
      ( dbfTmpPgo )->cTipRec     := "R"
      ( dbfTmpPgo )->cCodCaj     := aTmp[ ( dbfTmpPgo )->( FieldPos( "cCodCaj" ) ) ]
      ( dbfTmpPgo )->cCodPrv     := aTmp[ ( dbfTmpPgo )->( FieldPos( "cCodPrv" ) ) ]
      ( dbfTmpPgo )->dEntrada    := Ctod( "" )
      ( dbfTmpPgo )->nImporte    := nImp
      ( dbfTmpPgo )->cDescrip    := "Recibo nº" + AllTrim( Str( nCon ) ) + " de factura rectificativa " + aTmp[ ( dbfTmpPgo )->( FieldPos( "cSerFac" ) ) ] + '/' + AllTrim( Str( aTmp[ ( dbfTmpPgo )->( FieldPos( "nNumFac" ) ) ] ) ) + '/' + aTmp[ ( dbfTmpPgo )->( FieldPos( "cSufFac" ) ) ]
      ( dbfTmpPgo )->dPreCob     := dFecRctPrv( aTmp[ ( dbfTmpPgo )->( FieldPos( "cSerFac" ) ) ] + Str( aTmp[ ( dbfTmpPgo )->( FieldPos( "nNumFac" ) ) ] ) + aTmp[ ( dbfTmpPgo )->( FieldPos( "cSufFac" ) ) ], D():FacturasRectificativasProveedores( nView ) )
      ( dbfTmpPgo )->dFecVto     := dFecRctPrv( aTmp[ ( dbfTmpPgo )->( FieldPos( "cSerFac" ) ) ] + Str( aTmp[ ( dbfTmpPgo )->( FieldPos( "nNumFac" ) ) ] ) + aTmp[ ( dbfTmpPgo )->( FieldPos( "cSufFac" ) ) ], D():FacturasRectificativasProveedores( nView ) )
      ( dbfTmpPgo )->cPgdoPor    := ""
      ( dbfTmpPgo )->lCobrado    := .f.
      ( dbfTmpPgo )->cDivPgo     := aTmp[ ( dbfTmpPgo )->( FieldPos( "CDIVPGO" ) ) ]
      ( dbfTmpPgo )->nVdvPgo     := aTmp[ ( dbfTmpPgo )->( FieldPos( "NVDVPGO" ) ) ]
      ( dbfTmpPgo )->lConPgo     := .f.

      ( dbfTmpPgo )->( dbUnLock() )

   end if

   ( dbfTmpPgo )->( dbGoTo( nRec ) )

   WinGather( aTmp, aGet, dbfTmpPgo, oBrw, nMode )

   oDlg:End( IDOK )

Return nil

//---------------------------------------------------------------------------//

Static Function DelCobPrv( oBrw, cRctPrvP )

   if ( D():FacturasProveedoresPagos( nView ) )->lCobrado .and. !oUser():lAdministrador()
      msgStop( "Este recibo está cobrado.", "Imposible eliminar" )
      return .f.
   end if

   if SQLAjustableModel():getRolNoConfirmacionEliminacion( Auth():rolUuid() ) .or. ApoloMsgNoYes("¿ Desea eliminar definitivamente este registro ?", "Confirme supersión" )
      DelRecno( D():FacturasProveedoresPagos( nView ), oBrw, .f. )
   end if

return .t.

//---------------------------------------------------------------------------//

Static Function EdtRecMenu( aTmp, oDlg )

   MENU oMnuRec

      MENUITEM    "&1. Rotor"

         MENU

            if !lExternal

            MENUITEM    "&1. Campos extra [F9]";
               MESSAGE  "Mostramos y rellenamos los campos extra para la familia" ;
               RESOURCE "gc_form_plus2_16" ;
               ACTION   ( oDetCamposExtra:Play( space(1) ) )


            MENUITEM    "&2. Visualizar albarán";
               MESSAGE  "Visualiza la factura del la que proviene" ;
               RESOURCE "gc_document_empty_businessman_16" ;
               ACTION   ( if( !empty( ( D():FacturasRectificativasProveedores( nView ) )->cNumFac ), ZooFacPrv( ( D():FacturasRectificativasProveedores( nView ) )->cNumFac ), MsgStop( "La factura rectificativa no proviene de una factura" ) ))

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
               ACTION   ( TTrazaDocumento():Activate( FAC_PRV, ( D():FacturasRectificativasProveedores( nView ) )->cSerFac + Str( ( D():FacturasRectificativasProveedores( nView ) )->nNumFac ) + ( D():FacturasRectificativasProveedores( nView ) )->cSufFac ) )

         ENDMENU

   ENDMENU

   oDlg:SetMenu( oMnuRec )

Return ( oMnuRec )

//----------------------------------------------------------------------------//

Static Function EdtInc( aTmp, aGet, dbf, oBrw, bWhen, bValid, nMode, aTmpFac )

   local oDlg

   if nMode == APPD_MODE
      aTmp[ _CSERFAC  ] := aTmpFac[ _CSERFAC  ]
      aTmp[ _NNUMFAC  ] := aTmpFac[ _NNUMFAC ]
      aTmp[ _CSUFFAC  ] := aTmpFac[ _CSUFFAC ]
   end if

   DEFINE DIALOG oDlg RESOURCE "INCIDENCIA" TITLE LblTitle( nMode ) + "incidencias de facturas rectificativas de proveedores"

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

//---------------------------------------------------------------------------//

Static Function EdtDoc( aTmp, aGet, dbfAlbPrvD, oBrw, bWhen, bValid, nMode, aTmpLin )

   local oDlg
   local oRuta
   local oNombre
   local oObservacion

   DEFINE DIALOG oDlg RESOURCE "DOCUMENTOS" TITLE LblTitle( nMode ) + "documento de facturas a proveedor"

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
/*
Edita las lineas de Detalle
*/

STATIC FUNCTION EdtDet( aTmp, aGet, dbf, oBrw, aTmpFac, cCodArtEnt, nMode )

	local oDlg
	local oFld
   local oBtn
	local oTotal
   local cSay2
   local oSay2
   local oBmp
   local oBrwPrp
   local oSayPr1
   local oSayPr2
   local oSayVp1
   local oSayVp2
   local cSayVp1           := ""
   local cSayVp2           := ""
   local cSayPr1           := ""
   local cSayPr2           := ""
   local nTotal            := 0
   local oBtnSer
   local cCodArt           := Padr( aTmp[ _CREF ], 200 )


   /*
   Este valor los guaradamos para detectar los posibles cambios----------------
   */

   cOldCodArt              := aTmp[ _CREF    ]
   cOldPrpArt              := aTmp[ _CCODPR1 ] + aTmp[ _CCODPR2 ] + aTmp[ _CVALPR1 ] + aTmp[ _CVALPR2 ]
   cOldUndMed              := aTmp[ _CUNIDAD ]
   cTipoCtrCoste           := AllTrim( aTmp[ _CTIPCTR ] )

   do case
   case nMode == APPD_MODE

      aTmp[ _NUNICAJA ]    := 1
      aTmp[ _CALMLIN  ]    := aTmpFac[ _CCODALM ]
      aTmp[ _NNUMLIN  ]    := nLastNum( dbfTmp )
      aTmp[ _DFECCAD  ]    := Ctod( "" )

      if !empty( cCodArtEnt )
         cCodArt           := cCodArtEnt
      end if

      cTipoCtrCoste        := "Centro de coste"

   case nMode == EDIT_MODE

      if !empty( aTmp[ _CREF ] )
         ( D():Articulos( nView ) )->( dbSeek( Alltrim( aTmp[ _CREF ] ) ) )
      end if

   end case

   /*
   Caja de dialogo-------------------------------------------------------------
   */

   DEFINE DIALOG oDlg RESOURCE "LALBPRV" TITLE LblTitle( nMode ) + "lineas a facturas de proveedores"

      REDEFINE FOLDER oFld ;
         ID       400 ;
         OF       oDlg ;
         PROMPT   "&General",;
                  "&Stock",;
                  "&Observaciones",;
                  "&Centro coste" ;
         DIALOGS  "LFACPRV_7",;
                  "LALBPRV_3",;
                  "LFACPRV_5",;
                  "LCTRCOSTE"

      REDEFINE GET aGet[ _CREF ] VAR cCodArt ;
			ID 		110 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( LoaArt( cCodArt, aGet, aTmp, aTmpFac, oFld, oSayPr1, oSayPr2, oSayVp1, oSayVp2, oBmp, oBrwPrp, oDlg, oTotal ) );
         BITMAP   "LUPA" ;
         ON HELP  ( BrwArticulo( aGet[ _CREF ], aGet[ _CDETALLE ], .f., .t., oBtn, aGet[ _CLOTE ], aTmp[ _CCODPR1 ], aTmp[ _CCODPR2 ], aGet[ _CVALPR1 ], aGet[ _CVALPR2 ], aGet[ _DFECCAD ], if( uFieldEmpresa( "lStockAlm" ), aTmp[ _CALMLIN ], nil ) ) ) ;
			OF 		oFld:aDialogs[1]

      /*
      Lotes
      ------------------------------------------------------
      */

      REDEFINE GET aGet[ _CLOTE ] VAR aTmp[ _CLOTE ];
         ID       112 ;
         IDSAY    111 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
			OF 		oFld:aDialogs[1]

      REDEFINE GET aGet[ _DFECCAD ] VAR aTmp[ _DFECCAD ];
         ID       113 ;
         IDSAY    114 ;
			SPINNER ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			COLOR 	CLR_GET ;
         OF       oFld:aDialogs[1]

		REDEFINE GET aGet[_CDETALLE] VAR aTmp[_CDETALLE] ;
         ID 		120 ;
         WHEN     ( ( lModDes() .or. empty( aTmp[ _CDETALLE ] ) ) .AND. nMode != ZOOM_MODE ) ;
			COLOR 	CLR_GET ;
			OF 		oFld:aDialogs[1]

		REDEFINE GET aGet[_MLNGDES] VAR aTmp[_MLNGDES] ;
			MEMO ;
			ID 		121 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			COLOR 	CLR_GET ;
			OF 		oFld:aDialogs[1]

      REDEFINE GET aGet[ _NIVA ] VAR aTmp[ _NIVA ] ;
			ID 		130 ;
         WHEN     ( lModIva() .AND. nMode != ZOOM_MODE ) ;
			PICTURE 	"@E 99.99" ;
         ON CHANGE( lCalcDeta( aTmp, aTmpFac, aGet, oTotal ) );
         VALID    ( lTiva( D():TiposIva( nView ), aTmp[ _NIVA ], @aTmp[ _NREQ ] ) );
         BITMAP   "LUPA" ;
         ON HELP  ( BrwIva( aGet[ _NIVA ], D():TiposIva( nView ), , .t. ) ) ;
			OF 		oFld:aDialogs[1]

      // IVMH------------------------------------------------------------------

      REDEFINE GET aGet[ _NVALIMP ] VAR aTmp[ _NVALIMP ] ;
         ID       125 ;
         IDSAY    126 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  cPinDiv ;
         ON CHANGE( lCalcDeta( aTmp, aTmpFac, aGet, oTotal ) );
         OF       oFld:aDialogs[1]

      /*
      Propiedades
      -------------------------------------------------------------------------
      */

      REDEFINE GET aGet[_CVALPR1] VAR aTmp[_CVALPR1];
         ID       220 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
			COLOR 	CLR_GET ;
         BITMAP   "LUPA" ;
         VALID    ( if( lPrpAct( aGet[ _CVALPR1 ], oSayVp1, aTmp[_CCODPR1 ], D():PropiedadesLineas( nView ) ),;
                        LoaArt( cCodArt, aGet, aTmp, aTmpFac, oFld, oSayPr1, oSayPr2, oSayVp1, oSayVp2, oBmp, oBrwPrp, oDlg, oTotal ),;
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
         COLOR    CLR_GET ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CVALPR2 ] VAR aTmp[ _CVALPR2 ];
         ID       230 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         BITMAP   "LUPA" ;
         VALID    ( if( lPrpAct( aGet[ _CVALPR2 ], oSayVp2, aTmp[ _CCODPR2 ], D():PropiedadesLineas( nView ) ),;
                        LoaArt( cCodArt, aGet, aTmp, aTmpFac, oFld, oSayPr1, oSayPr2, oSayVp1, oSayVp2, oBmp, oBrwPrp, oDlg, oTotal ),;
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

      // Browse de propiedades-------------------------------------------------

      oBrwPrp                       := IXBrowse():New( oFld:aDialogs[1] )

      oBrwPrp:nDataType             := DATATYPE_ARRAY

      oBrwPrp:bClrSel               := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwPrp:bClrSelFocus          := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrwPrp:lHScroll              := .t.
      oBrwPrp:lVScroll              := .t.

      oBrwPrp:nMarqueeStyle         := 3
      oBrwPrp:nFreeze               := 1

      oBrwPrp:lRecordSelector       := .f.
      oBrwPrp:lFastEdit             := .t.
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
         ID       470 ;
         IDSAY    471 ;
         SPINNER ;
         WHEN     ( uFieldEmpresa( "lUseBultos" ) .AND. nMode != ZOOM_MODE ) ;
         PICTURE  cPicUnd ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[_CUNIDAD] VAR aTmp[_CUNIDAD] ;
         ID       152 ;
         IDTEXT   153 ;
         BITMAP   "LUPA" ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( D():GetObject( "UnidadMedicion", nView ):Existe( aGet[ _CUNIDAD ], aGet[ _CUNIDAD ]:oHelpText, "cNombre" ), ValidaMedicion( aTmp, aGet) );
         ON HELP  ( D():GetObject( "UnidadMedicion", nView ):Buscar( aGet[ _CUNIDAD ] ), ValidaMedicion( aTmp, aGet ) ) ;
         OF       oFld:aDialogs[1]

      // Campos de las descripciones de la unidad de medición

      REDEFINE GET aGet[ ( D():FacturasRectificativasProveedoresLineas( nView ) )->( fieldpos( "nMedUno" ) ) ] ;
         VAR      aTmp[ ( D():FacturasRectificativasProveedoresLineas( nView ) )->( fieldpos( "nMedUno" ) ) ] ;
         ID       420 ;
         IDSAY    421 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ON CHANGE( lCalcDeta( aTmp, aTmpFac, aGet, oTotal ) );
         PICTURE  MasUnd() ;
         OF       oFld:aDialogs[1]

      aGet[ ( D():FacturasRectificativasProveedoresLineas( nView ) )->( fieldpos( "nMedUno" ) ) ]:oSay:SetColor( CLR_BLUE )

      REDEFINE GET aGet[ ( D():FacturasRectificativasProveedoresLineas( nView ) )->( fieldpos( "nMedDos" ) ) ] ;
         VAR      aTmp[ ( D():FacturasRectificativasProveedoresLineas( nView ) )->( fieldpos( "nMedDos" ) ) ] ;
         ID       430 ;
         IDSAY    431 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ON CHANGE( lCalcDeta( aTmp, aTmpFac, aGet, oTotal ) );
         PICTURE  MasUnd() ;
         OF       oFld:aDialogs[1]

      aGet[ ( D():FacturasRectificativasProveedoresLineas( nView ) )->( fieldpos( "nMedDos" ) ) ]:oSay:SetColor( CLR_BLUE )

      REDEFINE GET aGet[ ( D():FacturasRectificativasProveedoresLineas( nView ) )->( fieldpos( "nMedTre" ) ) ] ;
         VAR      aTmp[ ( D():FacturasRectificativasProveedoresLineas( nView ) )->( fieldpos( "nMedTre" ) ) ] ;
         ID       440 ;
         IDSAY    441 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ON CHANGE( lCalcDeta( aTmp, aTmpFac, aGet, oTotal ) );
         PICTURE  MasUnd() ;
         OF       oFld:aDialogs[1]

      aGet[ ( D():FacturasRectificativasProveedoresLineas( nView ) )->( fieldpos( "nMedTre" ) ) ]:oSay:SetColor( CLR_BLUE )

		REDEFINE GET aGet[_NCANENT] VAR aTmp[_NCANENT] ;
			ID 		140 ;
         WHEN     ( lUseCaj() .AND. nMode != ZOOM_MODE ) ;
         VALID    ( lCalcDeta( aTmp, aTmpFac, aGet, oTotal ) );
         ON CHANGE( lCalcDeta( aTmp, aTmpFac, aGet, oTotal ) );
			SPINNER ;
			PICTURE 	cPicUnd ;
         OF       oFld:aDialogs[1] ;
         IDSAY    141

		REDEFINE GET aGet[_NUNICAJA] VAR aTmp[_NUNICAJA] ;
			ID 		150 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         VALID    ( lCalcDeta( aTmp, aTmpFac, aGet, oTotal ) );
         ON CHANGE( lCalcDeta( aTmp, aTmpFac, aGet, oTotal ) );
			SPINNER ;
			PICTURE 	cPicUnd;
         OF       oFld:aDialogs[1] ;
         IDSAY    151

		REDEFINE GET aGet[_NPREUNIT] VAR aTmp[_NPREUNIT] ;
			SPINNER ;
			ID 		160 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         VALID    ( lCalcDeta( aTmp, aTmpFac, aGet, oTotal ) );
         ON CHANGE( lCalcDeta( aTmp, aTmpFac, aGet, oTotal ) );
         COLOR    CLR_GET ;
			PICTURE 	cPinDiv ;
			OF 		oFld:aDialogs[1]

      REDEFINE GET aGet[_NDTOLIN] VAR aTmp[_NDTOLIN] ;
			ID 		180 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         VALID    ( lCalcDeta( aTmp, aTmpFac, aGet, oTotal ) );
         ON CHANGE( lCalcDeta( aTmp, aTmpFac, aGet, oTotal ) );
         COLOR    CLR_GET ;
			SPINNER ;
         PICTURE  "@E 999.99" ;
			OF 		oFld:aDialogs[1]

      REDEFINE GET aGet[_NDTOPRM] VAR aTmp[_NDTOPRM] ;
         ID       250 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         VALID    ( lCalcDeta( aTmp, aTmpFac, aGet, oTotal ) );
         ON CHANGE( lCalcDeta( aTmp, aTmpFac, aGet, oTotal ) );
         COLOR    CLR_GET ;
			SPINNER ;
			PICTURE 	"@E 99.99" ;
			OF 		oFld:aDialogs[1]

      REDEFINE GET aGet[_NDTORAP] VAR aTmp[_NDTORAP] ;
         ID       260 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			SPINNER ;
			PICTURE	"@E 99.99" ;
			COLOR 	CLR_GET ;
			OF 		oFld:aDialogs[1]

      REDEFINE CHECKBOX aGet[ _LGASSUP ] VAR aTmp[ _LGASSUP ] ;
         ID       460;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

      aGet[ _LGASSUP ]:bChange   := {|| if( aTmp[ _LGASSUP ], ( aGet[ _NIVA ]:cText( 0 ), aGet[ _NIVA ]:HardDisable() ), ( aGet[ _NIVA ]:HardEnable() ) ) }

      REDEFINE GET aGet[ _CFORMATO ] VAR aTmp[ _CFORMATO ];
         ID       480;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CREFPRV ] VAR aTmp[ _CREFPRV ];
         ID       400 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

		REDEFINE GET oTotal VAR nTotal ;
			ID 		210 ;
         PICTURE  cPirDiv ;
			WHEN 		.F. ;
			OF 		oFld:aDialogs[1]

      REDEFINE GET aGet[ __CALMORIGEN ] VAR aTmp[ __CALMORIGEN ]  ;
         ID       330 ;
         IDTEXT   331 ;
         IDSAY    332 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    (  cAlmacen( aGet[ __CALMORIGEN ], , aGet[ __CALMORIGEN ]:oHelpText ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwAlmacen( aGet[ __CALMORIGEN ], aGet[ __CALMORIGEN ]:oHelpText ) ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[_CALMLIN] VAR aTmp[_CALMLIN]  ;
         ID       240 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         VALID    ( cAlmacen( aGet[_CALMLIN], , oSay2 ) ) ; 
         BITMAP   "LUPA" ;
         ON HELP  ( BrwAlmacen( Self, oSay2 ) ) ;
			COLOR 	CLR_GET ;
			OF 		oFld:aDialogs[1]

		REDEFINE GET oSay2 VAR cSay2 ;
			WHEN 		.F. ;
         ID       241 ;
			OF 		oFld:aDialogs[1]
   
      /*
      Segunda caja de diálogo _________________________________________________
      */

      REDEFINE RADIO aGet[ _NCTLSTK ] ;
         VAR      aTmp[ _NCTLSTK ] ;
         ID       350, 351, 352 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[ 2 ]

      REDEFINE GET aGet[ __DFECFAC ] VAR aTmp[ __DFECFAC ] ;
         ID       360 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ __TFECFAC ] VAR aTmp[ __TFECFAC ] ;
         ID       361 ;
         PICTURE  "@R 99:99:99" ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( iif(   !validTime( aTmp[ __TFECFAC ] ),;
                           ( msgStop( "El formato de la hora no es correcto" ), .f. ),;
                           .t. ) );
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[_MOBSLIN] VAR aTmp[_MOBSLIN] ;
         MEMO ;
         ID       100 ;
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

      REDEFINE BUTTON oBtn;
         ID       IDOK ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( SaveDeta( aTmp, aGet, oBrw, oDlg, nMode, oTotal, oFld, aTmpFac, oSayPr1, oSayPr2, oSayVp1, oSayVp2, oBrwPrp, oBtn, oBtnSer ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
         OF       oDlg ;
         CANCEL ;
         ACTION   ( oDlg:end() )

      REDEFINE BUTTON ;
         ID       9 ;
         OF       oDlg ;
         ACTION   ( GoHelp() )

      REDEFINE BUTTON oBtnSer ;
         ID       552 ;
			OF 		oDlg ;
         ACTION   ( EditarNumeroSerie( aTmp, nMode ) )

   if nMode != ZOOM_MODE
      oDlg:AddFastKey( VK_F5, {|| oBtn:SetFocus(), oBtn:Click() } )
   end if

   oDlg:AddFastKey( VK_F6, {|| oBtnSer:Click() } )
   oDlg:AddFastKey( VK_F1, {|| GoHelp() } )

   oDlg:bStart    := {|| SetDlgMode( aGet, aTmp, oFld, aTmpFac, nMode, oSayPr1, oSayPr2, oSayVp1, oSayVp2, oTotal, oBrwPrp ),;
                         loadGet( aGet[ _CTERCTR ], cTipoCtrCoste ), aGet[ _CTERCTR ]:lValid(),;
                         aGet[ _CUNIDAD ]:lValid() }

	ACTIVATE DIALOG oDlg ;
      ON INIT     ( EdtDetMenu( aGet[ _CREF ], oDlg ) );
      CENTER

   EndDetMenu()

RETURN ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

STATIC FUNCTION SetDlgMode( aGet, aTmp, oFld, aTmpFac, nMode, oSayPr1, oSayPr2, oSayVp1, oSayVp2, oTotal, oBrwPrp )

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

   if empty( aTmp[ __CALMORIGEN ] )
      aTmp[ __CALMORIGEN ]  := aTmpFac[ _CALMORIGEN ]
   end if
  
   if uFieldEmpresa( "lShowOrg" )
      aGet[ __CALMORIGEN ]:Show()
   else
      aGet[ __CALMORIGEN ]:Hide()
   end if

   oBrwPrp:Hide()

   oSayPr1:SetText( "" )
   oSayVp1:SetText( "" )

   oSayPr2:SetText( "" )
   oSayVp2:SetText( "" )

   /*
   Colocamos nuevamente los folders
   */

   oFld:aEnable   := { .t., !empty( aTmp[ _CREF ] ), .t., .t. }
   oFld:SetOption( 1 )

   do case
   case nMode == APPD_MODE

      aGet[ _CREF    ]:Show()
      aGet[ _CREF    ]:cText( Space( 200 ) )

      aGet[ _CDETALLE]:show()

      aGet[ _MLNGDES ]:hide()
      aGet[ _CLOTE   ]:hide()
      aGet[ _DFECCAD ]:hide()
      aGet[ _NCANENT ]:cText( 1 )
      aGet[ _NUNICAJA]:cText( 1 )
      aGet[ __CALMORIGEN ]:cText( aTmpFac[ _CALMORIGEN ] )
      aGet[ _CALMLIN ]:cText( aTmpFac[ _CCODALM ] )
      aGet[ _NIVA    ]:cText( nIva( D():TiposIva( nView ), cDefIva() ) )

      aGet[ __CCENTROCOSTE ]:cText( aTmpFac[ _CCENTROCOSTE ] )

      if !empty( aGet[ __CCENTROCOSTE ] )
         aGet[ __CCENTROCOSTE ]:lValid()
      endif

      cTipoCtrCoste        := "Centro de coste"
      oTipoCtrCoste:Refresh()
      clearGet( aGet[ _CTERCTR ] )

   case nMode != APPD_MODE .AND. empty( cCodArt )

      aGet[ _CREF    ]:hide()
		aGet[ _CDETALLE]:hide()
		aGet[ _MLNGDES ]:show()
      aGet[ _CLOTE   ]:hide()
      aGet[ _DFECCAD ]:hide()

      if !empty( aGet[ __CCENTROCOSTE ] )
         aGet[ __CCENTROCOSTE ]:lValid()
      endif

   case nMode != APPD_MODE .AND. !empty( cCodArt )

      aGet[ _CREF    ]:show()
		aGet[ _CDETALLE]:show()
		aGet[ _MLNGDES ]:hide()

      if aTmp[ _LLOTE   ]
         aGet[ _CLOTE   ]:Show()
         aGet[ _DFECFAC ]:Show()
      else
         aGet[ _CLOTE   ]:Hide()
         aGet[ _DFECCAD ]:Hide()
      end if

      if !empty( aGet[ __CCENTROCOSTE ] )
         aGet[ __CCENTROCOSTE ]:lValid()
      endif

   end case

   lCalcDeta( aTmp, aTmpFac, aGet, oTotal )

   if !empty( aTmp[ _CCODPR1 ] )
      aGet[ _CVALPR1 ]:Show()
      aGet[ _CVALPR1 ]:lValid()
      oSayPr1:Show()
      oSayVp1:Show()
      oSayPr1:SetText( retProp( aTmp[_CCODPR1], D():Propiedades( nView ) ) )
   else
      aGet[ _CVALPR1 ]:hide()
      oSayPr1:Hide()
      oSayVp1:Hide()
   end if

   if !empty( aTmp[_CCODPR2 ] )
      aGet[ _CVALPR2 ]:Show()
      aGet[ _CVALPR2 ]:lValid()
      oSayPr2:Show()
      oSayVp2:Show()
      oSayPr2:SetText( retProp(  aTmp[_CCODPR2], D():Propiedades( nView ) ) )
   else
      aGet[ _CVALPR2 ]:hide()
      oSayPr2:hide()
      oSayVp2:hide()
   end if

   /*
   Ocultamos las tres unidades de medicion-------------------------------------
   */

   aGet[ ( D():FacturasRectificativasProveedoresLineas( nView ) )->( fieldpos( "nMedUno" ) ) ]:Hide()
   aGet[ ( D():FacturasRectificativasProveedoresLineas( nView ) )->( fieldpos( "nMedDos" ) ) ]:Hide()
   aGet[ ( D():FacturasRectificativasProveedoresLineas( nView ) )->( fieldpos( "nMedTre" ) ) ]:Hide()

   /*if D():GetObject( "UnidadMedicion", nView ):oDbf:Seek( aTmp[ _CUNIDAD ] )

      if D():GetObject( "UnidadMedicion", nView ):oDbf:nDimension >= 1 .and. !empty( D():GetObject( "UnidadMedicion", nView ):oDbf:cTextoDim1 )
         aGet[ ( D():FacturasRectificativasProveedoresLineas( nView ) )->( fieldpos( "nMedUno" ) ) ]:oSay:SetText( D():GetObject( "UnidadMedicion", nView ):oDbf:cTextoDim1 )
         aGet[ ( D():FacturasRectificativasProveedoresLineas( nView ) )->( fieldpos( "nMedUno" ) ) ]:Show()
      end if

      if D():GetObject( "UnidadMedicion", nView ):oDbf:nDimension >= 2 .and. !empty( D():GetObject( "UnidadMedicion", nView ):oDbf:cTextoDim2 )
         aGet[ ( D():FacturasRectificativasProveedoresLineas( nView ) )->( fieldpos( "nMedDos" ) ) ]:oSay:SetText( D():GetObject( "UnidadMedicion", nView ):oDbf:cTextoDim2 )
         aGet[ ( D():FacturasRectificativasProveedoresLineas( nView ) )->( fieldpos( "nMedDos" ) ) ]:Show()
      end if

      if D():GetObject( "UnidadMedicion", nView ):oDbf:nDimension >= 3 .and. !empty( D():GetObject( "UnidadMedicion", nView ):oDbf:cTextoDim3 )
         aGet[ ( D():FacturasRectificativasProveedoresLineas( nView ) )->( fieldpos( "nMedTre" ) ) ]:oSay:SetText( D():GetObject( "UnidadMedicion", nView ):oDbf:cTextoDim3 )
         aGet[ ( D():FacturasRectificativasProveedoresLineas( nView ) )->( fieldpos( "nMedTre" ) ) ]:Show()
      end if

   end if*/

   aGet[ _CALMLIN ]     :lValid()
   aGet[ __CALMORIGEN ] :lValid()
   aGet[ _CUNIDAD ]     :lValid()

   aGet[ _CREF    ]     :SetFocus()

Return Nil

//--------------------------------------------------------------------------//

STATIC FUNCTION SaveDeta( aTmp, aGet, oBrw, oDlg2, nMode, oTotal, oFld, aTmpFac, oSayPr1, oSayPr2, oSayVp1, oSayVp2, oBrwPrp, oBtn, oBtnSer )

   local n
   local i

   oBtn:SetFocus()

   if empty( aTmp[ _CREF ] ) .and. lRetCodArt()
      MsgStop( "No se pueden añadir lineas sin codificar" )
      return .f.
   end if

   if !lMoreIva( aTmp[_NIVA] )
      return nil
   end if

   if empty( aTmp[ _CALMLIN ] )
      MsgStop( "Código de almacen no puede estar vacio" )
      aGet[ _CALMLIN ]:SetFocus()
      Return nil
   end if

   if !cAlmacen( aGet[ _CALMLIN ] )
      MsgStop( "Código de almacen no encontrado" )
      Return nil
   end if

   if ( aTmp[ _CALMLIN ] == aTmp[ __CALMORIGEN ] )
      MsgStop( "El almacén de origen debe ser distinto al almacén de destino" )
      aGet[ __CALMORIGEN ]:SetFocus()
      Return nil
   end if

   /*
   Comprobamos si tiene que introducir números de serie------------------------
   */

   if nMode == APPD_MODE .and. RetFld( aTmp[ _CREF ], D():Articulos( nView ), "lNumSer" ) .and. !( dbfTmpSer )->( dbSeek( Str( aTmp[ _NNUMLIN ], 4 ) + aTmp[ _CREF ] ) )

      MsgStop( "Tiene que introducir números de serie para este artículo." )

      oBtnSer:Click()

      Return .f.

   end if

   /*
   Grabamos el registro--------------------------------------------------------
   */

   cOldCodArt        := ""
   cOldUndMed        := ""
   aTmp[ _CTIPCTR ]  := cTipoCtrCoste

   if nMode == APPD_MODE

      if aTmp[ _LLOTE ]
         saveLoteActual( aTmp[ _CREF ], aTmp[ _CLOTE ], nView )   
      end if

      if !empty( oBrwPrp:Cargo )

         for n := 1 to len( oBrwPrp:Cargo )

            for i := 1 to len( oBrwPrp:Cargo[ n ] )

               if IsNum( oBrwPrp:Cargo[ n, i ]:Value ) .and. oBrwPrp:Cargo[ n, i ]:Value != 0 //  .and.

                  aTmp[ _NNUMLIN ]     := nLastNum( dbfTmp )
                  aTmp[ _NUNICAJA]     := oBrwPrp:Cargo[ n, i ]:Value
                  aTmp[ _CCODPR1 ]     := oBrwPrp:Cargo[ n, i ]:cCodigoPropiedad1
                  aTmp[ _CVALPR1 ]     := oBrwPrp:Cargo[ n, i ]:cValorPropiedad1
                  aTmp[ _CCODPR2 ]     := oBrwPrp:Cargo[ n, i ]:cCodigoPropiedad2
                  aTmp[ _CVALPR2 ]     := oBrwPrp:Cargo[ n, i ]:cValorPropiedad2

                  if oBrwPrp:Cargo[ n, i ]:nPrecioCompra != 0
                     aTmp[ _NPREUNIT]  := oBrwPrp:Cargo[ n, i ]:nPrecioCompra
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
         RecalculaTotal( aTmpFac )
         SetDlgMode( aGet, aTmp, oFld, aTmpFac, nMode, oSayPr1, oSayPr2, oSayVp1, oSayVp2, oTotal, oBrwPrp, )
      else
         oDlg2:End( IDOK )
      end if

   else

      WinGather( aTmp, aGet, dbfTmp, oBrw, nMode )

      oDlg2:end( IDOK )

   end if

   if !empty( aGet[ _CUNIDAD ] )
      aGet[ _CUNIDAD ]:lValid()
   end if

   if !empty( oBrwPrp )
      oBrwPrp:Cargo  := nil
   end if

RETURN NIL

//--------------------------------------------------------------------------//

/*
Funcion Auxiliar para A¤adir lineas de detalle a una Factura
*/

STATIC FUNCTION AppDeta( oBrwLin, bEdtDet, aTmp, cCodArt )

   /*
   if !empty( aNumAlb ) .or. aTmp[ _LIMPALB ]
      MsgStop( "No se pueden modificar registros a una factura que" + CRLF + ;
               "proviene de albaranes." )
      return .f.
   end if
   */

   if lRecibosPagadosTmp( dbfTmpPgo )
      MsgStop( "No se pueden modificar registros de una factura con pagos" )
      return .f.
   end if

   WinAppRec( oBrwLin, bEdtDet, dbfTmp, aTmp, cCodArt )

RETURN ( RecalculaTotal( aTmp ) )

//---------------------------------------------------------------------------//

/*
Funcion Auxiliar para la Edici¢n de Lineas de Detalle en una Factura
*/

STATIC FUNCTION EdtDeta( oBrwLin, bEdtDet, aTmp, cLoop )

   if lRecibosPagadosTmp( dbfTmpPgo )
      MsgStop( "No se pueden modificar registros de una factura con pagos" )
      return .f.
   end if

   if !( dbfTmp )->lControl
      WinEdtRec( oBrwLin, bEdtDet, dbfTmp, aTmp )
   end if

RETURN ( RecalculaTotal( aTmp ) )

//--------------------------------------------------------------------------//
/*
Funcion Auxiliar para borrar las Lineas de Detalle en una Factura
*/

STATIC FUNCTION DelDeta()

   if lRecibosPagadosTmp( dbfTmpPgo )
      MsgStop( "No se pueden eliminar registros de una factura con pagos" )
      return .f.
   end if

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

STATIC FUNCTION PrnSerie( oBrw )

	local oDlg
   local oFmtDoc
   local cFmtDoc     := cFormatoDocumento( ( D():FacturasRectificativasProveedores( nView ) )->cSerFac, "nRctPrv", D():Contadores( nView ) )
   local oSayFmt
   local cSayFmt
   local oSerIni
   local oSerFin   
   local cSerIni     := ( D():FacturasRectificativasProveedores( nView ) )->cSerFac
   local cSerFin     := ( D():FacturasRectificativasProveedores( nView ) )->cSerFac
   local nDocIni     := ( D():FacturasRectificativasProveedores( nView ) )->nNumFac
   local nDocFin     := ( D():FacturasRectificativasProveedores( nView ) )->nNumFac
   local cSufIni     := ( D():FacturasRectificativasProveedores( nView ) )->cSufFac
   local cSufFin     := ( D():FacturasRectificativasProveedores( nView ) )->cSufFac
   local oPrinter
   local cPrinter    := PrnGetName()
   local lCopiasPre  := .t.
   local lInvOrden   := .f.
   local oNumCop
   local nNumCop     := if( nCopiasDocumento( ( D():FacturasRectificativasProveedores( nView ) )->cSerFac, "nRctPrv", D():Contadores( nView ) ) == 0, Max( Retfld( ( D():FacturasRectificativasProveedores( nView ) )->cCodPrv, D():Proveedores( nView ), "nCopiasF" ), 1 ), nCopiasDocumento( ( D():FacturasRectificativasProveedores( nView ) )->cSerFac, "nRctPrv", D():Contadores( nView ) ) )
   local oRango
   local nRango      := 1
   local dFecDesde   := CtoD( "01/01/" + Str( Year( Date() ) ) )
   local dFecHasta   := Date()

   if empty( cFmtDoc )
      cFmtDoc        := cSelPrimerDoc( "TP" )
   end if

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
      ON HELP  ( BrwDocumento( oFmtDoc, oSayFmt, "TP" ) ) ;
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

      nRecno      := ( D():FacturasRectificativasProveedores( nView ) )->( Recno() )
      nOrdAnt     := ( D():FacturasRectificativasProveedores( nView ) )->( OrdSetFocus( "NNUMFAC" ) )

      if !lInvOrden

         ( D():FacturasRectificativasProveedores( nView ) )->( dbSeek( cDocIni, .t. ) )

         while ( D():FacturasRectificativasProveedores( nView ) )->cSerFac + Str( ( D():FacturasRectificativasProveedores( nView ) )->nNumFac ) + (D():FacturasRectificativasProveedores( nView ))->cSufFac >= cDocIni .AND. ;
               ( D():FacturasRectificativasProveedores( nView ) )->cSerFac + Str( ( D():FacturasRectificativasProveedores( nView ) )->nNumFac ) + (D():FacturasRectificativasProveedores( nView ))->cSufFac <= cDocFin

               lChgImpDoc( D():FacturasRectificativasProveedores( nView ) )

            if lCopiasPre

               nCopyProvee    := if( nCopiasDocumento( ( D():FacturasRectificativasProveedores( nView ) )->cSerFac, "nRctPrv", D():Contadores( nView ) ) == 0, Max( Retfld( ( D():FacturasRectificativasProveedores( nView ) )->cCodPrv, D():Proveedores( nView ), "nCopiasF" ), 1 ), nCopiasDocumento( ( D():FacturasRectificativasProveedores( nView ) )->cSerFac, "nRctPrv", D():Contadores( nView ) ) )

               GenRctPrv( IS_PRINTER, "Imprimiendo documento : " + ( D():FacturasRectificativasProveedores( nView ) )->cSerFac + Str( ( D():FacturasRectificativasProveedores( nView ) )->nNumFac ) + (D():FacturasRectificativasProveedores( nView ))->cSufFac, cFmtDoc, cPrinter, nCopyProvee )

            else

               GenRctPrv( IS_PRINTER, "Imprimiendo documento : " + ( D():FacturasRectificativasProveedores( nView ) )->cSerFac + Str( ( D():FacturasRectificativasProveedores( nView ) )->nNumFac ) + (D():FacturasRectificativasProveedores( nView ))->cSufFac, cFmtDoc, cPrinter, nNumCop )

            end if

         (D():FacturasRectificativasProveedores( nView ))->( dbSkip() )

         end while

      else

         ( D():FacturasRectificativasProveedores( nView ) )->( dbSeek( cDocFin ) )

         while ( D():FacturasRectificativasProveedores( nView ) )->cSerFac + Str( ( D():FacturasRectificativasProveedores( nView ) )->nNumFac ) + ( D():FacturasRectificativasProveedores( nView ) )->cSufFac >= cDocIni .and. ;
               ( D():FacturasRectificativasProveedores( nView ) )->cSerFac + Str( ( D():FacturasRectificativasProveedores( nView ) )->nNumFac ) + ( D():FacturasRectificativasProveedores( nView ) )->cSufFac <= cDocFin .and.;
               !( D():FacturasRectificativasProveedores( nView ) )->( Bof() )

               lChgImpDoc( D():FacturasRectificativasProveedores( nView ) )

            if lCopiasPre

               nCopyProvee    := if( nCopiasDocumento( ( D():FacturasRectificativasProveedores( nView ) )->cSerFac, "nRctPrv", D():Contadores( nView ) ) == 0, Max( Retfld( ( D():FacturasRectificativasProveedores( nView ) )->cCodPrv, D():Proveedores( nView ), "nCopiasF" ), 1 ), nCopiasDocumento( ( D():FacturasRectificativasProveedores( nView ) )->cSerFac, "nRctPrv", D():Contadores( nView ) ) )

               GenRctPrv( IS_PRINTER, "Imprimiendo documento : " + ( D():FacturasRectificativasProveedores( nView ) )->cSerFac + Str( ( D():FacturasRectificativasProveedores( nView ) )->nNumFac ) + (D():FacturasRectificativasProveedores( nView ))->cSufFac, cFmtDoc, cPrinter, nCopyProvee )

            else

               GenRctPrv( IS_PRINTER, "Imprimiendo documento : " + ( D():FacturasRectificativasProveedores( nView ) )->cSerFac + Str( ( D():FacturasRectificativasProveedores( nView ) )->nNumFac ) + (D():FacturasRectificativasProveedores( nView ))->cSufFac, cFmtDoc, cPrinter, nNumCop )

            end if

         ( D():FacturasRectificativasProveedores( nView ) )->( dbSkip( -1 ) )

         end while

      end if

   else

      nRecno      := ( D():FacturasRectificativasProveedores( nView ) )->( Recno() )
      nOrdAnt     := ( D():FacturasRectificativasProveedores( nView ) )->( OrdSetFocus( "DFECFAC" ) )

      if !lInvOrden

         ( D():FacturasRectificativasProveedores( nView ) )->( dbGoTop() )

         while !( D():FacturasRectificativasProveedores( nView ) )->( Eof() )

            if ( D():FacturasRectificativasProveedores( nView ) )->dFecFac >= dFecDesde .and. ( D():FacturasRectificativasProveedores( nView ) )->dFecFac <= dFecHasta

               lChgImpDoc( D():FacturasRectificativasProveedores( nView ) )

               if lCopiasPre

                  nCopyProvee    := if( nCopiasDocumento( ( D():FacturasRectificativasProveedores( nView ) )->cSerFac, "nRctPrv", D():Contadores( nView ) ) == 0, Max( Retfld( ( D():FacturasRectificativasProveedores( nView ) )->cCodPrv, D():Proveedores( nView ), "nCopiasF" ), 1 ), nCopiasDocumento( ( D():FacturasRectificativasProveedores( nView ) )->cSerFac, "nRctPrv", D():Contadores( nView ) ) )

                  GenRctPrv( IS_PRINTER, "Imprimiendo documento : " + ( D():FacturasRectificativasProveedores( nView ) )->cSerFac + Str( ( D():FacturasRectificativasProveedores( nView ) )->nNumFac ) + (D():FacturasRectificativasProveedores( nView ))->cSufFac, cFmtDoc, cPrinter, nCopyProvee )

               else

                  GenRctPrv( IS_PRINTER, "Imprimiendo documento : " + ( D():FacturasRectificativasProveedores( nView ) )->cSerFac + Str( ( D():FacturasRectificativasProveedores( nView ) )->nNumFac ) + (D():FacturasRectificativasProveedores( nView ))->cSufFac, cFmtDoc, cPrinter, nNumCop )

               end if

            end if   

         (D():FacturasRectificativasProveedores( nView ))->( dbSkip() )

         end while

      else

         ( D():FacturasRectificativasProveedores( nView ) )->( dbSeek( cDocFin ) )

         while !( D():FacturasRectificativasProveedores( nView ) )->( Bof() )

            if ( D():FacturasRectificativasProveedores( nView ) )->dFecFac >= dFecDesde .and. ( D():FacturasRectificativasProveedores( nView ) )->dFecFac <= dFecHasta   

               lChgImpDoc( D():FacturasRectificativasProveedores( nView ) )

               if lCopiasPre

                  nCopyProvee    := if( nCopiasDocumento( ( D():FacturasRectificativasProveedores( nView ) )->cSerFac, "nRctPrv", D():Contadores( nView ) ) == 0, Max( Retfld( ( D():FacturasRectificativasProveedores( nView ) )->cCodPrv, D():Proveedores( nView ), "nCopiasF" ), 1 ), nCopiasDocumento( ( D():FacturasRectificativasProveedores( nView ) )->cSerFac, "nRctPrv", D():Contadores( nView ) ) )

                  GenRctPrv( IS_PRINTER, "Imprimiendo documento : " + ( D():FacturasRectificativasProveedores( nView ) )->cSerFac + Str( ( D():FacturasRectificativasProveedores( nView ) )->nNumFac ) + (D():FacturasRectificativasProveedores( nView ))->cSufFac, cFmtDoc, cPrinter, nCopyProvee )

               else

                  GenRctPrv( IS_PRINTER, "Imprimiendo documento : " + ( D():FacturasRectificativasProveedores( nView ) )->cSerFac + Str( ( D():FacturasRectificativasProveedores( nView ) )->nNumFac ) + (D():FacturasRectificativasProveedores( nView ))->cSufFac, cFmtDoc, cPrinter, nNumCop )

               end if

            end if   

         ( D():FacturasRectificativasProveedores( nView ) )->( dbSkip( -1 ) )

         end while

      end if

   end if   

   ( D():FacturasRectificativasProveedores( nView ) )->( ordSetFocus( nOrdAnt ) )
   ( D():FacturasRectificativasProveedores( nView ) )->( dbGoTo( nRecNo ) )

   oDlg:Enable()

RETURN NIL

//--------------------------------------------------------------------------//

/*
Calcula totales en las lineas de Detalle
*/

STATIC FUNCTION lCalcDeta( aTmp, aTmpFac, aGet, oTotal )

   oTotal:cText( nTotLRctPrv( aTmp, nDinDiv, nRinDiv ) )

RETURN .T.

//---------------------------------------------------------------------------//

Static Function RecalculaTotal( aTmp )

   nTotRctPrv( nil, D():FacturasRectificativasProveedores( nView ), dbfTmp, D():TiposIva( nView ), D():Divisas( nView ), dbfTmpPgo, aTmp )

   if oBrwIva != nil
      oBrwIva:refresh()
   end if

   if oGetNet != nil
      oGetNet:SetText( Trans( nTotNet, cPirDiv ) )
   end if

   if oGetIva != nil
      oGetIva:SetText( Trans( nTotIva, cPirDiv ) )
   end if

   if oGetReq != nil
      oGetReq:SetText( Trans( nTotReq, cPirDiv ) )
   end if

   if oGetTotal != nil
      oGetTotal:SetText( Trans( nTotFac, cPirDiv ) )
   end if

   if oGetRet != nil
      oGetRet:SetText( Trans( nTotRet, cPirDiv ) )
   end if

   if oGetTotPg != nil
      oGetTotPg:SetText( Trans( nTotFac, cPirDiv ) )
   end if

   if oGetPgd != nil
      oGetPgd:SetText( Trans( nPagFac, cPirDiv ) )
   end if

   if oGetPdt != nil
      oGetPdt:SetText( Trans( nTotFac - nPagFac, cPirDiv ) )
   end if

   if oGetIvm != nil 
      oGetIvm:SetText( Trans( nTotIvm, cPirDiv ) )
   end if

Return .t.

//---------------------------------------------------------------------------//

Static Function nGenRctPrv( nDevice, cCaption, cCodDoc, cPrinter, nCopies )

   local nFac

   CursorWait()

   for each nFac in ( oWndBrw:oBrw:aSelected )

      ( D():FacturasRectificativasProveedores( nView ) )->( dbGoTo( nFac ) )

      GenRctPrv( nDevice, cCaption, cCodDoc, cPrinter, nCopies )

   next

   CursorWE()

Return ( nil )

//----------------------------------------------------------------------------//

Static Function GenRctPrv( nDevice, cCaption, cCodDoc, cPrinter, nCopies )

   local oDevice
   local nFactura

   if ( D():FacturasRectificativasProveedores( nView ) )->( Lastrec() ) == 0
      Return nil
   end if

   nFactura             := ( D():FacturasRectificativasProveedores( nView ) )->cSerFac + Str( ( D():FacturasRectificativasProveedores( nView ) )->nNumFac ) + ( D():FacturasRectificativasProveedores( nView ) )->cSufFac

   DEFAULT nDevice      := IS_PRINTER
   DEFAULT cCaption     := "Imprimiendo facturas rectificativas de proveedores"
   DEFAULT cCodDoc      := cFormatoDocumento( ( D():FacturasRectificativasProveedores( nView ) )->cSerFac, "nRctPrv", D():Contadores( nView ) )
   DEFAULT nCopies      := if( nCopiasDocumento( ( D():FacturasRectificativasProveedores( nView ) )->cSerFac, "nRctPrv", D():Contadores( nView ) ) == 0, Max( Retfld( ( D():FacturasRectificativasProveedores( nView ) )->cCodPrv, D():Proveedores( nView ), "nCopiasF" ), 1 ), nCopiasDocumento( ( D():FacturasRectificativasProveedores( nView ) )->cSerFac, "nRctPrv", D():Contadores( nView ) ) )

   if empty( cCodDoc )
      cCodDoc           := cFirstDoc( "TP", D():Documentos( nView ) )
   end if

   if !lExisteDocumento( cCodDoc, D():Documentos( nView ) )
      return nil
   end if

   /*
   Si el documento es de tipo visual-------------------------------------------
   */

   if lVisualDocumento( cCodDoc, D():Documentos( nView ) )
      PrintReportRctPrv( nDevice, nCopies, cPrinter, D():Documentos( nView ) )
   else
      msgStop( "El formato ya no es soportado" )
   end if

   lChgImpDoc( D():FacturasRectificativasProveedores( nView ) )

RETURN NIL

//---------------------------------------------------------------------------//

Static Function FacPrvReportSkipper()

   ( D():FacturasRectificativasProveedoresLineas( nView ) )->( dbSkip() )

   nTotPage              += nTotLRctPrv( D():FacturasRectificativasProveedoresLineas( nView ) )

Return nil

//---------------------------------------------------------------------------//

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

   MsgStop( "Factura con mas de 3 tipos de " + cImp(), "Imposible añadir" )

RETURN .F.

//---------------------------------------------------------------------------//

STATIC FUNCTION ChgFactu( cRctPrvT, oBrw )

   if dbLock( D():FacturasRectificativasProveedores( nView ) )
      ( D():FacturasRectificativasProveedores( nView ) )->lLiquidada := !( D():FacturasRectificativasProveedores( nView ) )->lLiquidada
      ( D():FacturasRectificativasProveedores( nView ) )->( dbUnLock() )
   end if

	oBrw:refresh()

RETURN NIL

//----------------------------------------------------------------------------//

STATIC FUNCTION loaPrv( aGet, aTmp, cPrv, nMode, oSay, oTlfPrv )

   local lValid      := .f.
   local cNewCodCli  := aGet[ _CCODPRV ]:VarGet()
   local lChgCodCli  := ( empty( cOldCodCli ) .or. cOldCodCli != cNewCodCli )

   if empty( cNewCodCli )
      Return .t.
   elseif At( ".", cNewCodCli ) != 0
      cNewCodCli := PntReplace( aGet[_CCODPRV], "0", RetNumCodPrvEmp() )
   else
      cNewCodCli := Rjust( cNewCodCli, "0", RetNumCodPrvEmp() )
   end if

   if ( D():Proveedores( nView ) )->( dbSeek( cNewCodCli ) )

      if ( D():Proveedores( nView ) )->lBlqPrv
         msgStop( "Proveedor bloqueado, no se pueden realizar operaciones de compra" )
         return .f.
      end if

      aGet[_CCODPRV ]:cText( ( D():Proveedores( nView ) )->Cod )

      if empty( aGet[_CNOMPRV]:varGet() ) .or. lChgCodCli
         aGet[_CNOMPRV]:cText( ( D():Proveedores( nView ) )->Titulo )
      end if

      if oTlfPrv != nil
         oTlfPrv:SetText( ( D():Proveedores( nView ) )->Telefono )
      end if

      if empty( aGet[_CDIRPRV]:varGet() ) .or. lChgCodCli
         aGet[_CDIRPRV]:cText( ( D():Proveedores( nView ) )->Domicilio )
      endif

      if empty( aGet[_CPOBPRV]:varGet() ) .or. lChgCodCli
         aGet[_CPOBPRV]:cText( (D():Proveedores( nView ))->POBLACION )
      endif

      if empty( aGet[_CPROVPROV]:varGet() ) .or. lChgCodCli
         aGet[_CPROVPROV]:cText( (D():Proveedores( nView ))->PROVINCIA )
      endif

      if empty( aGet[_CPOSPRV]:varGet() ) .or. lChgCodCli
         aGet[_CPOSPRV]:cText( (D():Proveedores( nView ))->CODPOSTAL )
      endif

      if empty( aGet[_CDNIPRV]:varGet() ) .or. lChgCodCli
         aGet[_CDNIPRV]:cText( (D():Proveedores( nView ))->NIF )
      endif

      if lChgCodCli
         aGet[ _CDTOESP ]:cText( ( D():Proveedores( nView ) )->cDtoEsp )
         aGet[ _NDTOESP ]:cText( ( D():Proveedores( nView ) )->nDtoEsp )
         aGet[ _CDPP    ]:cText( ( D():Proveedores( nView ) )->cDtoPP )
         aGet[ _NDPP    ]:cText( ( D():Proveedores( nView ) )->DtoPP )
      end if

      if empty( aGet[ _CCODPAGO ]:VarGet() ) .or. lChgCodCli

         aGet[ _CCODPAGO ]:cText( ( D():Proveedores( nView ) )->fPago )
         aGet[ _CCODPAGO ]:lValid()

         /*
         Si la forma de pago es un movimiento bancario le asignamos el banco y cuenta por defecto
         */

         if RetFld( aTmp[ _CCODPAGO ], D():FormasPago( nView ), "lUtlBnc" )

            if dbSeekInOrd( ( D():Proveedores( nView ) )->Cod, "cCodDef", D():BancosProveedores( nView ) )

               if !empty( aGet[ _CBANCO ] )
                  aGet[ _CBANCO ]:cText( ( D():BancosProveedores( nView ) )->cCodBnc )
                  aGet[ _CBANCO ]:lValid()
               end if

               if !empty( aGet[ _CPAISIBAN ] )
                  aGet[ _CPAISIBAN ]:cText( ( D():BancosProveedores( nView ) )->cPaisIBAN )
                  aGet[ _CPAISIBAN ]:lValid()
               end if

               if !empty( aGet[ _CCTRLIBAN ] )
                  aGet[ _CCTRLIBAN ]:cText( ( D():BancosProveedores( nView ) )->cCtrlIBAN )
                  aGet[ _CCTRLIBAN ]:lValid()
               end if

               if !empty( aGet[ _CENTBNC ] )
                  aGet[ _CENTBNC ]:cText( ( D():BancosProveedores( nView ) )->cEntBnc )
                  aGet[ _CENTBNC ]:lValid()
               end if

               if !empty( aGet[ _CSUCBNC ] )
                  aGet[ _CSUCBNC ]:cText( ( D():BancosProveedores( nView ) )->cSucBnc )
                  aGet[ _CSUCBNC ]:lValid()
               end if

               if !empty( aGet[ _CDIGBNC ] )
                  aGet[ _CDIGBNC ]:cText( ( D():BancosProveedores( nView ) )->cDigBnc )
                  aGet[ _CDIGBNC ]:lValid()
               end if

               if !empty( aGet[ _CCTABNC ] )
                  aGet[ _CCTABNC ]:cText( ( D():BancosProveedores( nView ) )->cCtaBnc )
                  aGet[ _CCTABNC ]:lValid()
               end if

            end if

         end if

      end if

      if empty( aGet[ _NTIPRET ]:VarGet() ) .or. lChgCodCli
         aGet[ _NTIPRET ]:oGet:cText(  ( D():Proveedores( nView ) )->nTipRet )
         aGet[ _NTIPRET ]:Select(      ( D():Proveedores( nView ) )->nTipRet )
      end if

      if empty( aGet[ _NPCTRET ]:VarGet() ) .or. lChgCodCli
         aGet[ _NPCTRET ]:cText( ( D():Proveedores( nView ) )->nPctRet )
      end if

      if nMode == APPD_MODE
         aGet[ _NREGIVA ]:nOption( Max( ( D():Proveedores( nView ) )->nRegIva, 1 ) )
         aGet[ _NREGIVA ]:Refresh()

         if empty( aTmp[ _CSERFAC ] )

            if !empty( ( D():Proveedores( nView ) )->Serie )
               aGet[ _CSERFAC ]:cText( ( D():Proveedores( nView ) )->Serie )
            end if

         else

            if !empty( ( D():Proveedores( nView ) )->Serie ) .and. aTmp[ _CSERFAC ] != ( D():Proveedores( nView ) )->Serie .and. ApoloMsgNoYes( "La serie del proveedor seleccionado es distinta a la anterior.", "¿Desea cambiar la serie?" )
               aGet[ _CSERFAC ]:cText( ( D():Proveedores( nView ) )->Serie )
            end if

         end if

      end if

      if lChgCodCli
         aTmp[ _LRECARGO ] := ( D():Proveedores( nView ) )->lReq
         aGet[ _LRECARGO ]:Refresh()
      end if

      if ( D():Proveedores( nView ) )->lMosCom .and. !empty( ( D():Proveedores( nView ) )->mComent ) .and. lChgCodCli
         MsgStop( AllTrim( ( D():Proveedores( nView ) )->mComent ) )
      end if

      cOldCodCli  := ( D():Proveedores( nView ) )->Cod
      lValid      := .t.

	ELSE

		msgStop( "Proveedor no encontrado" )

	END IF

RETURN lValid

//----------------------------------------------------------------------------//

/*
Carga los articulos
*/

STATIC FUNCTION LoaArt( cCodArt, aGet, aTmp, aTmpFac, oFld, oSayPr1, oSayPr2, oSayVp1, oSayVp2, oBmp, oBrwPrp, oDlg, oTotal )

   local hHas128
   local cLote
   local dFechaCaducidad
   local nIva
   local nOrdAnt
   local nPreUnt
   local nPreCom
   local cCodFam
   local cPrpArt
   local cCodPrv
   local lChgCodArt
   local lSeek       := .f.

   nIva              := 0
   cCodPrv           := aTmpFac[ _CCODPRV ]
   cPrpArt           := aTmp[ _CCODPR1 ] + aTmp[ _CCODPR2 ] + aTmp[ _CVALPR1 ] + aTmp[ _CVALPR2 ]
   lChgCodArt        := ( Rtrim( cOldCodArt ) != Rtrim( cCodArt ) .or. Rtrim( cOldPrpArt ) != Rtrim( cPrpArt ) )

   if empty( cCodArt )

      if lRetCodArt()
         MsgStop( "No se pueden añadir lineas sin codificar" )
         return .f.
      end if

		aGet[ _NIVA    ]:bWhen	:= {|| .t. }

      aGet[ _CDETALLE]:Hide()

      aGet[ _MLNGDES ]:Show()
      aGet[ _MLNGDES ]:SetFocus()

      if !empty( oBrwPrp )
         oBrwPrp:Hide()
      end if

   else

      if lModIva()
			aGet[ _NIVA ]:bWhen	:= {|| .t. }
      else
			aGet[ _NIVA ]:bWhen	:= {|| .f. }
      end if

		aGet[ _CREF    ]:show()
		aGet[ _CDETALLE]:show()
		aGet[ _MLNGDES ]:hide()

      /*
      Buscamos codificacion GS1-128--------------------------------------------
      */

      if Len( Alltrim( cCodArt ) ) > 18

         hHas128              := ReadHashCodeGS128( cCodArt )
         if !empty( hHas128 )
            cCodArt           := uGetCodigo( hHas128, "01" )
            cLote             := uGetCodigo( hHas128, "10" )
            dFechaCaducidad   := uGetCodigo( hHas128, "15" )
         end if 

      end if

      /*
      Ahora buscamos por el codigo interno-------------------------------------
      */

      if lIntelliArtciculoSearch( cCodArt, cCodPrv, D():Articulos( nView ), D():ProveedorArticulo( nView ), D():ArticulosCodigosBarras( nView ) )

         if ( lChgCodArt )

            if ( D():Articulos( nView ) )->lObs
               MsgStop( "Artículo catalogado como obsoleto" )
               return .f.
            end if

            cCodArt              := ( D():Articulos( nView ) )->Codigo

            aGet[ _CREF ]:cText( Padr( cCodArt, 200 ) )
            aTmp[ _CREF ]        := cCodArt

            //Pasamos las referencias adicionales------------------------------

            aTmp[ _CREFAUX ]     := ( D():Articulos( nView ) )->cRefAux
            aTmp[ _CREFAUX2 ]    := ( D():Articulos( nView ) )->cRefAux2

            if ( D():Articulos( nView ) )->lLote

               if empty( cLote )
                  cLote          := ( D():Articulos( nView ) )->cLote
               end if 

               aGet[ _CLOTE   ]:Show()
               aGet[ _CLOTE   ]:cText( cLote )

               /*
               Fecha de caducidad----------------------------------------------
               */

               if empty( dFechaCaducidad )
                  dFechaCaducidad   := dFechaCaducidadLote( cCodArt, aTmp[ _CVALPR1 ], aTmp[ _CVALPR2 ], aTmp[ _CLOTE ], D():AlbaranesProveedoresLineas( nView ), D():FacturasProveedoresLineas( nView ) )
               end if 

               aGet[ _DFECCAD ]:Show()

               if empty( aTmp[ _DFECCAD ] )
                  aGet[ _DFECCAD ]:cText( dFechaCaducidad )
               end if

            else

               aGet[ _CLOTE   ]:Hide()
               aGet[ _DFECCAD ]:Hide()

            end if

            /*
            Cogemos las familias y grupos de familias-----------------------------
            */

            cCodFam                 := ( D():Articulos( nView ) )->Familia
            if !empty( cCodFam )
               aTmp[ _CCODFAM ]     := cCodFam
               aTmp[ _CGRPFAM ]     := cGruFam( cCodFam, D():Familias( nView ) )
            end if

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

            // Tomamos el valor del precio unitario

            nPreUnt                 := aGet[ _NPREUNIT ]:VarGet()

            // habilitamos la segunda caja de dialogo

            oFld:aEnable := { .t., .t., .t., .t. }
            oFld:refresh()

            aGet[ _CREF     ]:cText( ( D():Articulos( nView ) )->Codigo )
            aGet[ _CDETALLE ]:cText( ( D():Articulos( nView ) )->Nombre )

            /*
            Preguntamos si el regimen de " + cImp() + " es distinto de Exento
            */

            if aTmpFac[ _NREGIVA ] <= 1

               nIva           := nIva( D():TiposIva( nView ), ( D():Articulos( nView ) )->TipoIva )
               aGet[ _NIVA    ]:cText( nIva )

               aTmp[ _NREQ ]  := nReq( D():TiposIva( nView ), ( D():Articulos( nView ) )->TipoIva )

            end if

            if ( D():Articulos( nView ) )->nCajEnt != 0
               aGet[ _NCANENT ]:cText( ( D():Articulos( nView ) )->nCajEnt )
            end if

            if ( D():Articulos( nView ) )->nUniCaja != 0
               aGet[ _NUNICAJA ]:cText( ( D():Articulos( nView ) )->nUniCaja )
            end if

            // Ahora recogemos el impuesto especial si lo hay---------------------

            aTmp[ _CCODIMP ]  := ( D():Articulos( nView ) )->cCodImp

            oNewImp:setCodeAndValue( aTmp[ _CCODIMP ], aGet[ _NVALIMP ] )

            // Comentarios

            if ( D():Articulos( nView ) )->lMosCom .and. !empty( ( D():Articulos( nView ) )->mComent )
               MsgStop( Trim( ( D():Articulos( nView ) )->mComent ) )
            end if

            // Referencia de proveedor-----------------------------------------------

            nOrdAnt                 := ( D():ProveedorArticulo( nView ) )->( OrdSetFocus( "cCodPrv" ) )

            if ( D():ProveedorArticulo( nView ) )->( dbSeek( cCodPrv + cCodArt ) )

               if !empty( aGet[ _CREFPRV ] )
                  aGet[ _CREFPRV ]:cText( ( D():ProveedorArticulo( nView ) )->cRefPrv )
               end if

            else

               if !empty( aGet[ _CREFPRV ] )
                  aGet[ _CREFPRV ]:cText( Space( 20 ) )
               end if

            end if

            ( D():ProveedorArticulo( nView ) )->( ordSetFocus( nOrdAnt ) )

            /*
            Ponemos el precio de venta recomendado--------------------------------
            */

            aTmp[ _NPVPREC ]     := ( D():Articulos( nView ) )->PvpRec

            /*
            Buscamos la familia del articulo y anotamos las propiedades-----------
            */

            aTmp[ _CCODPR1 ]     := ( D():Articulos( nView ) )->cCodPrp1
            aTmp[ _CCODPR2 ]     := ( D():Articulos( nView ) )->cCodPrp2

            if ( !empty( aTmp[ _CCODPR1 ] ) .or. !empty( aTmp[ _CCODPR2 ] ) ) .and. uFieldEmpresa( "lUseTbl" )

               nPreCom           := nCosto( nil, D():Articulos( nView ), D():Kit( nView ), .f., aTmpFac[ _CDIVFAC ], D():Divisas( nView ) )

               setPropertiesTable( cCodArt, aTmp[ _CCODPR1 ], aTmp[ _CCODPR2 ], nPreCom, aGet[ _NUNICAJA ], oBrwPrp, nView )

            else

               oBrwPrp:Hide()

               if !empty( aTmp[ _CCODPR1 ] )

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

               if !empty( aTmp[_CCODPR2 ] )

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

            if !empty( aGet[ _CUNIDAD ] )
               aGet[ _CUNIDAD ]:cText( ( D():Articulos( nView ) )->cUnidad )
               aGet[ _CUNIDAD ]:lValid()
            else
               aTmp[ _CUNIDAD ]  := ( D():Articulos( nView ) )->cUnidad
            end if

            ValidaMedicion( aTmp, aGet)

         end if

         cPrpArt                 := aTmp[ _CCODPR1 ] + aTmp[ _CCODPR2 ] + aTmp[ _CVALPR1 ] + aTmp[ _CVALPR2 ]

         if ( lChgCodArt ) .or. ( cPrpArt != cOldPrpArt )

            /*
            Precios de Compra-----------------------------------------------------
            */

            nPreCom              := nComPro( aTmp[ _CREF ], aTmp[ _CCODPR1 ], aTmp[ _CVALPR1 ], aTmp[ _CCODPR2 ], aTmp[ _CVALPR2 ], D():ArticuloPrecioPropiedades( nView ) )
            if nPrecom  != 0

               aGet[ _NPREUNIT ]:cText( nPreCom )

            else

               if uFieldEmpresa( "lCosPrv", .f. )
                  nPreCom     := nPrecioReferenciaProveedor( cCodPrv, cCodArt, D():ProveedorArticulo( nView ) )
               end if

               if nPreCom != 0
                  aGet[ _NPREUNIT ]:cText( nPreCom )
               else
                  aGet[ _NPREUNIT ]:cText( nCosto( nil, D():Articulos( nView ), D():Kit( nView ), .f., aTmpFac[ _CDIVFAC ], D():Divisas( nView ) ) )
               end if

            end if

         end if

         /*
         Recalculamos los totales de la linea----------------------------------
         */

         lCalcDeta( aTmp, aTmpFac, aGet, oTotal )

      else

         MsgStop( "Artículo no encontrado" )
         Return .f.

      end if

   end if

   cOldCodArt                    := cCodArt
   cOldPrpArt                    := cPrpArt

Return .t.

//--------------------------------------------------------------------------//

STATIC FUNCTION LoadPreCosto( aGet, oGet )

	local xValor   := aGet[_CREF]:varGet()

	IF empty( xValor )
		RETURN .F.
	END IF

   if oGet == nil
      return .f.
   end if

   IF ( D():Articulos( nView ) )->( dbSeek( xValor ) )
      oGet:cText( ( D():Articulos( nView ) )->pCosto )
	END IF

	aGet[_CREF]:bWhen := {|| .F. }

RETURN .F.

//--------------------------------------------------------------------------//

STATIC FUNCTION LoadArtPed( aGet )

   local lValid               := .f.
   local xValor               := aGet[_CREF]:varGet()

	IF empty( xValor )

		aGet[_NIVA]:cText( 0 )
      aGet[_NIVA]:bWhen       := {|| .t. }

		aGet[_CDETALLE]:cText( Space( 50 ) )
      aGet[_CDETALLE]:bWhen   := {|| .t. }

		RETURN .T.

	END IF

   if ( D():Articulos( nView ) )->( dbSeek( xValor ) )

      aGet[_CREF    ]:cText( ( D():Articulos( nView ) )->Codigo )
      aGet[_CREF    ]:bWhen   := {|| .t. }

      aGet[_CDETALLE]:cText( ( D():Articulos( nView ) )->Nombre )
      aGet[_NPREUNIT]:cText( ( D():Articulos( nView ) )->pCosto )

      lValid                  := .t.

   else

      MsgStop( "Artículo no encontrado" )

   end if

RETURN lValid

//--------------------------------------------------------------------------//

STATIC FUNCTION GetArtPrv( cRefPrv, cCodPrv, aGet )

	local nOrdAnt

   if empty( cRefPrv )

      return .t.

   else

		nOrdAnt  := ( D():ProveedorArticulo( nView ) )->( ordSetFocus( 3 ) )

      if ( D():ProveedorArticulo( nView ) )->( dbSeek( cCodPrv + cRefPrv ) )

         aGet[ _CREF ]:cText( ( D():ProveedorArticulo( nView ) )->cCodArt )
			aGet[ _CREF ]:lValid()

      else

         msgStop( "Referencia de proveedor no encontrada" )

      end if

		( D():ProveedorArticulo( nView ) )->( ordSetFocus( nOrdAnt ) )

   end if

return .t.

//----------------------------------------------------------------------------//

STATIC FUNCTION SearchFact( oBrw )

	local oDlg
	local xToSearch
	local nNumFac	:= 0
   local cCodCli  := (D():FacturasRectificativasProveedores( nView ))->CCODPRV
	local dFactura	:= date()
   local nIndex   := (D():FacturasRectificativasProveedores( nView ))->(OrdNumber())

	DEFINE DIALOG oDlg RESOURCE "FINFACPRV"

		REDEFINE GET nNumFac ;
			ID 		130 ;
			PICTURE 	"999999999" ;
			WHEN 		( nIndex == 1 ) ;
			VALID 	( xToSearch := nNumFac, .T. ) ;
			COLOR 	CLR_GET ;
			OF 		oDlg

		REDEFINE GET dFactura ;
			ID 		140 ;
			WHEN 		( nIndex == 2 ) ;
			VALID 	( xToSearch := dFactura, .T. ) ;
			COLOR 	CLR_GET ;
			OF 		oDlg

		REDEFINE GET cCodCli ;
			ID 		150 ;
			WHEN 		( nIndex == 3 ) ;
         VALID    ( xToSearch := cCodCli, .T. ) ;
			COLOR 	CLR_GET ;
			OF 		oDlg

		REDEFINE BUTTON ;
			ID 		504 ;
			OF 		oDlg ;
         ACTION   ( (D():FacturasRectificativasProveedores( nView ))->( dbSeek( xToSearch ) ), oBrw:Refresh() )

		REDEFINE BUTTON ;
			ID 		510 ;
			OF 		oDlg ;
         CANCEL ;
         ACTION   ( oDlg:end() )

	ACTIVATE DIALOG oDlg	CENTER

RETURN NIL

//-------------------------------------------------------------------------//

STATIC FUNCTION EPage( oInf, cCodDoc )

   private nPagina      := oInf:nPage
	private lEnd			:= oInf:lFinish

	/*
	Ahora montamos los Items
	*/

   PrintItems( cCodDoc, oInf )

RETURN NIL

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
   local nRecno      := ( D():FacturasRectificativasProveedores( nView ) )->( Recno() )
   local nOrdAnt     := ( D():FacturasRectificativasProveedores( nView ) )->( OrdSetFocus( 1 ) )
   local oSerIni
   local oSerFin
   local cSerIni     := ( D():FacturasRectificativasProveedores( nView ) )->cSerFac
   local cSerFin     := ( D():FacturasRectificativasProveedores( nView ) )->cSerFac
   local oDocIni
   local oDocFin
   local nDocIni     := ( D():FacturasRectificativasProveedores( nView ) )->nNumFac
   local nDocFin     := ( D():FacturasRectificativasProveedores( nView ) )->nNumFac
   local oSufIni
   local oSufFin
   local cSufIni     := ( D():FacturasRectificativasProveedores( nView ) )->cSufFac
   local cSufFin     := ( D():FacturasRectificativasProveedores( nView ) )->cSufFac
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
      ACTION   ( dbFirst( D():FacturasRectificativasProveedores( nView ), "nNumFac", oDocIni, cSerIni, "nNumFac" ) )

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
      ACTION   ( dbLast( D():FacturasRectificativasProveedores( nView ), "nNumFac", oDocFin, cSerFin, "nNumFAc" ) )

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
      NOPERCENTAGE ;
      ID       200 ;
      OF       oDlg

   oMtrInf:SetTotal( ( D():FacturasRectificativasProveedores( nView ) )->( OrdKeyCount() ) )

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

   ( D():FacturasRectificativasProveedores( nView ) )->( ordSetFocus( nOrdAnt ) )
   ( D():FacturasRectificativasProveedores( nView ) )->( dbGoTo( nRecNo ) )

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
   local nRec     := ( D():FacturasRectificativasProveedores( nView ) )->( Recno() )
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

            ( D():FacturasRectificativasProveedores( nView ) )->( dbGoTo( nPos ) )

            if lFechas .or.( ( D():FacturasRectificativasProveedores( nView ) )->dFecFac >= dDesde .and. ( D():FacturasRectificativasProveedores( nView ) )->dFecFac <= dHasta )

               lRet  := Eval( bAction, lChk1, lChk2, oTree, D():FacturasRectificativasProveedores( nView ), D():FacturasRectificativasProveedoresLineas( nView ) )

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

         ( D():FacturasRectificativasProveedores( nView ) )->( dbSeek( cDocIni, .t. ) )

         while ( lWhile )                                                                                      .and. ;
               ( D():FacturasRectificativasProveedores( nView ) )->cSerFac + Str( ( D():FacturasRectificativasProveedores( nView ) )->nNumFac, 9 ) + ( D():FacturasRectificativasProveedores( nView ) )->cSufFac >= cDocIni .and. ;
               ( D():FacturasRectificativasProveedores( nView ) )->cSerFac + Str( ( D():FacturasRectificativasProveedores( nView ) )->nNumFac, 9 ) + ( D():FacturasRectificativasProveedores( nView ) )->cSufFac <= cDocFin .and. ;
               !( D():FacturasRectificativasProveedores( nView ) )->( eof() )

            if lFechas .or.( ( D():FacturasRectificativasProveedores( nView ) )->dFecFac >= dDesde .and. ( D():FacturasRectificativasProveedores( nView ) )->dFecFac <= dHasta )

               lRet  := Eval( bAction, lChk1, lChk2, oTree, D():FacturasRectificativasProveedores( nView ), D():FacturasRectificativasProveedoresLineas( nView ) )

               if IsFalse( lRet )
                  exit
               end if

            end if

            oMtrInf:Set( ++n )

            ( D():FacturasRectificativasProveedores( nView ) )->( dbSkip() )

            SysRefresh()

         end do

      end if

      if !empty( bPostAction )
         Eval( bPostAction )
      end if

   end if

   oMtrInf:Set( ( D():FacturasRectificativasProveedores( nView ) )->( OrdKeyCount() ) )

   ( D():FacturasRectificativasProveedores( nView ) )->( dbGoTo( nRec ) )

   if lChk1
      WndCenter( oDlg:hWnd )
   end if

   oBtnCancel:bAction   := {|| oDlg:End() }

   oDlg:Enable()

   if oBrw != nil
      oBrw:Refresh()
   end if

RETURN ( nil )

//---------------------------------------------------------------------------//
/*
Realiza asientos en Contaplus, partiendo de la factura
*/

STATIC FUNCTION ContabilizaRectificativa( lSimula, lPago, oTree )

	local n
   local nAsiento    := 0
	local cCtaVent
	local nPosicion
	local nPosIva
	local dFecha
   local aTotFac
   local nTotFac
   local nTotRet
	local cConcepto
   local cConCompr
	local cSubCtaIva
	local cSubCtaReq
   local cRuta
   local cCodEmp
   local nImpDeta
   local nDinDiv     := nDinDiv( ( D():FacturasRectificativasProveedores( nView ) )->cDivFac, D():Divisas( nView ) )
   local nRinDiv     := nRinDiv( ( D():FacturasRectificativasProveedores( nView ) )->cDivFac, D():Divisas( nView ) )
	local aSimula		:= {}
	local aIva			:= {}
	local aVentas		:= {}
   local cCodDiv     := ( D():FacturasRectificativasProveedores( nView ) )->cDivFac
   local cCtaPrv     := cPrvCta( ( D():FacturasRectificativasProveedores( nView ) )->cCodPrv, D():Proveedores( nView ) )
   local cCtaPrvVta  := cPrvCtaVta( ( D():FacturasRectificativasProveedores( nView ) )->cCodPrv, D():Proveedores( nView ) )
   local nFactura    := ( D():FacturasRectificativasProveedores( nView ) )->cSerFac + Str( ( D():FacturasRectificativasProveedores( nView ) )->nNumFac ) + ( D():FacturasRectificativasProveedores( nView ) )->cSufFac
   local cFactura    := ( D():FacturasRectificativasProveedores( nView ) )->cSerFac + "/" + Ltrim( Str( ( D():FacturasRectificativasProveedores( nView ) )->nNumFac ) ) + "/" + ( D():FacturasRectificativasProveedores( nView ) )->cSufFac
   local nNumFac     := ( D():FacturasRectificativasProveedores( nView ) )->nNumFac
   local cCodPro     := Left( ( D():FacturasRectificativasProveedores( nView ) )->cCodPro, 3 )
   local cClave      := Right( ( D():FacturasRectificativasProveedores( nView ) )->cCodPro, 6 )
   local lErrorFound := .f.
   local cTerNif     := ( D():FacturasRectificativasProveedores( nView ) )->cDniPrv
   local cTerNom     := ( D():FacturasRectificativasProveedores( nView ) )->cNomPrv
   local lReturn

	/*
	Chequeando antes de pasar a Contaplus
	*/

   IF ( D():FacturasRectificativasProveedores( nView ) )->lContab
      oTree:Add( "Factura rectificativa : " + Rtrim( cFactura ) + " ya contabilizada.", 0 )
      lErrorFound    := .t.
   END IF

   IF !ChkRuta( cRutCnt() )
      oTree:Add( "Factura rectificativa : " + rtrim( cFactura ) + " ruta no valida.", 0 )
      lErrorFound    := .t.
   END IF

   /*
	Chequeamos todos los valores
	*/

   cRuta             := cRutCnt()
   cCodEmp           := cCodEmpCnt( ( D():FacturasRectificativasProveedores( nView ) )->cSerFac )

   if empty( cCtaPrvVta )
      cCtaPrvVta     := cCtaPrv()
   end if

   if !ChkSubcuenta( cRutCnt(), cCodEmp, cCtaPrv, , .f., .f. )
      oTree:Add( "Factura rectificativa : " + rtrim( cFactura ) + " subcuenta " + cCtaPrv + " no encontada.", 0 )
      lErrorFound    := .t.
   end if

   /*
   Totales de las facturas
   */

   aTotFac           := aTotRctPrv( nFactura, D():FacturasRectificativasProveedores( nView ), D():FacturasRectificativasProveedoresLineas( nView ), D():TiposIva( nView ), D():Divisas( nView ), D():FacturasProveedoresPagos( nView ) )
   nTotFac           := aTotFac[ 4 ]
   nTotRet           := aTotFac[ 6 ]

	/*
	Estudio de los Articulos de una factura
	*/

   if ( D():FacturasRectificativasProveedoresLineas( nView ) )->( dbSeek( nFactura ) )

      while ( ( D():FacturasRectificativasProveedoresLineas( nView ) )->cSerFac + Str( ( D():FacturasRectificativasProveedoresLineas( nView ) )->nNumFac ) + ( D():FacturasRectificativasProveedoresLineas( nView ) )->cSufFac == nFactura .and. !( D():FacturasRectificativasProveedoresLineas( nView ) )->( eof() ) )

         nImpDeta    := nTotLRctPrv( D():FacturasRectificativasProveedoresLineas( nView ), nDinDiv, nRinDiv, ( D():FacturasRectificativasProveedores( nView ) )->nVdvFac )

         if nImpDeta != 0

            cCtaVent    := RetCtaCom( ( D():FacturasRectificativasProveedoresLineas( nView ) )->cRef, ( nImpDeta < 0 ), D():Articulos( nView ) )
            if empty( cCtaVent )
               cCtaVent := cCtaPrvVta + RetGrpVta( ( D():FacturasRectificativasProveedoresLineas( nView ) )->cRef, cRuta, cCodEmp, D():Articulos( nView ), ( D():FacturasRectificativasProveedoresLineas( nView ) )->nIva )
            end if

            nPosicion   := aScan( aVentas, {|x| x[1] == cCtaVent } )
            if nPosicion == 0
               aadd( aVentas, { cCtaVent, nImpDeta } )
            else
               aVentas[ nPosicion, 2 ] += nImpDeta
            end if

            /*
            Construimos las bases de los impuestosS
            */

            if ( D():FacturasRectificativasProveedores( nView ) )->nRegIva == 2
               cSubCtaIva  := uFieldEmpresa( "cCtaCeeRpt" )
               cSubCtaReq  := uFieldEmpresa( "cCtaCeeSpt" )
            else
               cSubCtaIva  := cSubCuentaIva( ( D():FacturasRectificativasProveedoresLineas( nView ) )->nIva, ( D():FacturasRectificativasProveedores( nView ) )->lRecargo, cRuta, cCodEmp, D():TiposIva( nView ), .f. )
               cSubCtaReq  := cSubCuentaRecargo( ( D():FacturasRectificativasProveedoresLineas( nView ) )->nIva, ( D():FacturasRectificativasProveedores( nView ) )->lRecargo, cRuta, cCodEmp, D():TiposIva( nView ) )
            end if

            nPosIva     := aScan( aIva, {|x| x[1] == ( D():FacturasRectificativasProveedoresLineas( nView ) )->nIva } )
            if nPosIva == 0
               aadd( aIva, { ( D():FacturasRectificativasProveedoresLineas( nView ) )->nIva, cSubCtaIva, cSubCtaReq, nImpDeta } )
            else
               aIva[ nPosIva, 4 ]   += nImpDeta
            end if

         end if

         ( D():FacturasRectificativasProveedoresLineas( nView ) )->( dbSkip() )

      end while

   else

      oTree:Add( "Factura rectificativa : " + rtrim( cFactura ) + " factura sin artículos.", 0 )
      lErrorFound    := .t.

   end if

   /*
	Descuentos sobres grupos de Venta
	*/

   for n := 1 TO Len( aVentas )

      if ( D():FacturasRectificativasProveedores( nView ) )->nDtoEsp != 0
         aVentas[ n, 2 ] -= Round( aVentas[ n, 2 ] * ( D():FacturasRectificativasProveedores( nView ) )->nDtoEsp / 100, nRinDiv )
      end if

      if ( D():FacturasRectificativasProveedores( nView ) )->nDpp != 0
         aVentas[ n, 2 ] -= Round( aVentas[ n, 2 ] * ( D():FacturasRectificativasProveedores( nView ) )->nDpp / 100, nRinDiv )
      end if

      if ( D():FacturasRectificativasProveedores( nView ) )->nDtoUno != 0
         aVentas[ n, 2 ] -= Round( aVentas[ n, 2 ] * ( D():FacturasRectificativasProveedores( nView ) )->nDtoUno / 100, nRinDiv )
      end if

      if ( D():FacturasRectificativasProveedores( nView ) )->nDtoDos != 0
         aVentas[ n, 2 ] -= Round( aVentas[ n, 2 ] * ( D():FacturasRectificativasProveedores( nView ) )->nDtoDos / 100, nRinDiv )
      end if

   next

   /*
   Descuentos sobres grupos de impuestos
	*/

   for n := 1 TO Len( aIva )

      if ( D():FacturasRectificativasProveedores( nView ) )->nDtoEsp != 0
         aIva[ n, 4 ] -= Round( aIva[ n, 4 ] * ( D():FacturasRectificativasProveedores( nView ) )->nDtoEsp / 100, nRinDiv )
      end if

      if ( D():FacturasRectificativasProveedores( nView ) )->nDpp != 0
         aIva[ n, 4 ] -= Round( aIva[ n, 4 ] * ( D():FacturasRectificativasProveedores( nView ) )->nDpp / 100, nRinDiv )
      end if

      if ( D():FacturasRectificativasProveedores( nView ) )->nDtoUno != 0
         aIva[ n, 4 ] -= Round( aIva[ n, 4 ] * ( D():FacturasRectificativasProveedores( nView ) )->nDtoUno / 100, nRinDiv )
      end if

      if ( D():FacturasRectificativasProveedores( nView ) )->nDtoDos != 0
         aIva[ n, 2 ] -= Round( aIva[ n, 4 ] * ( D():FacturasRectificativasProveedores( nView ) )->nDtoDos / 100, nRinDiv )
      end if

   next

	/*
   Chequeo de Cuentas de Ventas------------------------------------------------
	*/

   for n := 1 TO len( aVentas )

      if !ChkSubcuenta( cRutCnt(), cCodEmp, aVentas[ n, 1 ], , .f., .f. )

         oTree:Add( "Factura rectificativa : " + rtrim( cFactura ) + " subcuenta " + aVentas[ n, 1 ] + " no encontada.", 0 )
         lErrorFound    := .t.

      end if

   next

	/*
   Chequeo de Cuentas de impuestos---------------------------------------------------
	*/

   for n := 1 to len( aIva )

      if !ChkSubcuenta( cRuta, cCodEmp, aIva[ n, 2 ], , .f., .f. )
         oTree:Add( "Factura rectificativa : " + Rtrim( cFactura ) + " subcuenta " + aIva[ n, 2 ] + " no encontada.", 0 )
         lErrorFound    := .t.
      end if

      if !ChkSubcuenta( cRuta, cCodEmp, aIva[ n, 3 ], , .f., .f. )
         oTree:Add( "Factura rectificativa : " + Rtrim( cFactura ) + " subcuenta " + aIva[ n, 3 ] + " no encontada.", 0 )
         lErrorFound    := .t.
      end if

   next

   if nTotRet != 0

      if !ChkSubcuenta( cRuta, cCodEmp, cCtaRet(), , .f., .f. )
         oTree:Add( "Factura rectificativa : " + Rtrim( cFactura ) + " subcuenta " + cCtaRet() + " no encontada.", 0 )
         lErrorFound    := .t.
      end if

   end if

	/*
   Comprobamos fechas----------------------------------------------------------
	*/

   if !ChkFecha( , , ( D():FacturasRectificativasProveedores( nView ) )->dFecFac, .f., oTree )
      lErrorFound    := .t.
   end if

   /*
   Datos comunes a todos los Asientos------------------------------------------
   */

   if lSimula .or. !lErrorFound

      if empty( ( D():FacturasRectificativasProveedores( nView ) )->dFecEnt )
         dFecha      := ( D():FacturasRectificativasProveedores( nView ) )->dFecFac
      else
         dFecha      := ( D():FacturasRectificativasProveedores( nView ) )->dFecEnt
      end if

      cConCompr      := "S/Rect."
      if !empty( ( D():FacturasRectificativasProveedores( nView ) )->cSuPed )
         nNumFac     := Val( ( D():FacturasRectificativasProveedores( nView ) )->cSuPed )
         cConCompr   += " N." + Rtrim( ( D():FacturasRectificativasProveedores( nView ) )->cSuPed )
      elseif !empty( ( D():FacturasRectificativasProveedores( nView ) )->cNumDoc )
         cConCompr   += " Doc. " + Rtrim( ( D():FacturasRectificativasProveedores( nView ) )->cNumDoc )
      else
         cConCompr   += " N." + Rtrim( cFactura )
      end if
      cConcepto      := cConCompr + Space( 1 ) + DtoC( ( D():FacturasRectificativasProveedores( nView ) )->dFecFac )
      cConCompr      += Space( 1 ) + Rtrim( ( D():FacturasRectificativasProveedores( nView ) )->cNomPrv )

      /*
      Realizaci¢n de Asientos-----------------------------------------------------
      */

      if OpenDiario( , cCodEmp )
         nAsiento := contaplusUltimoAsiento()
      else
         oTree:Add( "Factura rectificativa : " + Rtrim( cFactura ) + " imposible abrir ficheros de contaplus.", 0 )
         return .f.
      end if

      /*
      Asiento de Proveedor________________________________________________________
      */

      aAdd( aSimula, MkAsiento(  nAsiento,;
                                 cCodDiv,;
                                 dFecha,;
                                 cCtaPrv,;
                                 ,;
                                 ,;
                                 cConcepto,;
                                 nTotFac,;
                                 nNumFac,;
                                 ,;
                                 ,;
                                 ,;
                                 ( D():FacturasRectificativasProveedores( nView ) )->cNumDoc,;
                                 cCodPro,;
                                 cClave,;
                                 ,;
                                 ,;
                                 ,;
                                 lSimula,;
                                 cTerNif,;
                                 cTerNom ) )

      /*
      Asientos de Compras_________________________________________________________
      */

      for n := 1 TO len( aVentas )

         aAdd( aSimula, MkAsiento(  nAsiento,;
                                    cCodDiv,;
                                    dFecha,;
                                    aVentas[ n, 1 ],;
                                    ,;
                                    aVentas[ n, 2 ],;
                                    cConCompr,;
                                    ,;
                                    nNumFac,;
                                    ,;
                                    ,;
                                    ,;
                                    ( D():FacturasRectificativasProveedores( nView ) )->cNumDoc,;
                                    cCodPro,;
                                    cClave,;
                                    ,;
                                    ,;
                                    ,;
                                    lSimula,;
                                    cTerNif,;
                                    cTerNom ) )

      next

      if ( D():FacturasRectificativasProveedores( nView ) )->nRegIva == 2

      for n := 1 to len( aIva )

         aadd( aSimula, MkAsiento(  nAsiento, ;
                                    cCodDiv,;
                                    dFecha, ;
                                    aIva[ n, 3 ],;                                        // Cuenta de impuestos
                                    aIva[ n, 2 ],;                                        // Contrapartida
                                    Round( aIva[ n, 1 ] * aIva[ n, 4 ] / 100, nRinDiv ),; // Ptas. Debe
                                    cConCompr,;
                                    Round( aIva[ n, 1 ] * aIva[ n, 4 ] / 100, nRinDiv ),; // Ptas. Haber
                                    nNumFac,;
                                    aIva[ n, 4 ],;
                                    aIva[ n, 1 ],;
                                    If( ( D():FacturasRectificativasProveedores( nView ) )->lRecargo, nPReq( D():TiposIva( nView ), aIva[ n, 1 ] ), 0 ),;
                                    ( D():FacturasRectificativasProveedores( nView ) )->cNumDoc,;
                                    cCodPro,;
                                    cClave,;
                                    ,;
                                    ,;
                                    ,;
                                    lSimula,;
                                    cTerNif,;
                                    cTerNom ) )

      next

      else

      /*
      Asientos de impuestos_____________________________________________________________
      */

      for n := 1 TO len( aIva )

         aadd( aSimula, MkAsiento(  nAsiento, ;
                                    cCodDiv,;
                                    dFecha, ;
                                    aIva[ n, 2 ],;    // Cuenta de impuestos
                                    cCtaPrv,;         // Contrapartida
                                    Round( aIva[ n, 1 ] * aIva[ n, 4 ] / 100, nRinDiv ),;
                                    cConCompr,;
                                    ,;                // Ptas. Haber
                                    nNumFac,;
                                    aIva[ n, 4 ],;
                                    aIva[ n, 1 ],;
                                    If( ( D():FacturasRectificativasProveedores( nView ) )->lRecargo, nPReq( D():TiposIva( nView ), aIva[ n, 1 ] ), 0 ),;
                                    ( D():FacturasRectificativasProveedores( nView ) )->cNumDoc,;
                                    cCodPro,;
                                    cClave,;
                                    ,;
                                    ,;
                                    ,;
                                    lSimula,;
                                    cTerNif,;
                                    cTerNom ) )

      next

      /*
      Asientos del Recargo________________________________________________________
      */

      if ( D():FacturasRectificativasProveedores( nView ) )->lRecargo

         for n := 1 TO len( aIva )

            aadd( aSimula, MkAsiento(  nAsiento,;
                                       cCodDiv,;
                                       dFecha,;
                                       aIva[ n, 3 ],; // Cuenta de impuestos
                                       ,;
                                       Round( nPReq( D():TiposIva( nView ), aIva[ n, 1 ] ) * aIva[ n, 4 ] / 100, nRinDiv ),;
                                       cConCompr,;
                                       ,;
                                       nNumFac,;
                                       ,;
                                       ,;
                                       ,;
                                       ( D():FacturasRectificativasProveedores( nView ) )->cNumDoc,;
                                       cCodPro,;
                                       cClave,;
                                       ,;
                                       ,;
                                       ,;
                                       lSimula,;
                                       cTerNif,;
                                       cTerNom ) )

         next

      end if

      end if

      /*
      Asientos del retenciones________________________________________________________
      */

      if nTotRet != 0

         aadd( aSimula, MkAsiento(  nAsiento,;
                                    cCodDiv,;
                                    dFecha,;
                                    cCtaRet(),;   // Cuenta de retencion
                                    ,;
                                    ,;
                                    cConCompr,;
                                    nTotRet,;
                                    nNumFac,;
                                    ,;
                                    ,;
                                    ,;
                                    ( D():FacturasRectificativasProveedores( nView ) )->cNumDoc,;
                                    cCodPro,;
                                    cClave,;
                                    ,;
                                    ,;
                                    ,;
                                    lSimula,;
                                    cTerNif,;
                                    cTerNom ) )

      end if

      /*
      Contabilizaci¢n de Pagos
      --------------------------------------------------------------------------
      */

      if lPago .and. ( D():FacturasProveedoresPagos( nView ) )->( dbSeek( nFactura ) )

         while ( ( D():FacturasProveedoresPagos( nView ) )->cSerFac + Str( ( D():FacturasProveedoresPagos( nView ) )->nNumFac ) + ( D():FacturasProveedoresPagos( nView ) )->cSufFac == nFactura ) .AND.;
               !( D():FacturasProveedoresPagos( nView ) )->( eof() )

            lReturn  := CntRecPrv( lSimula, oTree, nAsiento, aSimula, .t., D():FacturasRectificativasProveedores( nView ), D():FacturasProveedoresPagos( nView ), D():Proveedores( nView ), D():FormasPago( nView ), D():Divisas( nView ) )

            if IsFalse( lReturn )
               exit
            end if

            ( D():FacturasProveedoresPagos( nView ) )->( dbSkip() )

         end while

      end if

      /*
      Ponemos la factura como Contabilizada---------------------------------------
      */

      if !lSimula .and. !lErrorFound

         lReturn  := ChgContabilizado( .t., cFactura, nAsiento, oTree )

      else

         lReturn  := msgTblCon( aSimula, cCodDiv, D():Divisas( nView ), !lErrorFound, cFactura, {|| aWriteAsiento( aSimula, cCodDiv, .t., oTree, cFactura, nAsiento ), ChgContabilizado( .t., cFactura, nAsiento, oTree ) } )

      end if

      CloseDiario()

   end if

Return ( lReturn )

//----------------------------------------------------------------------------//
/*
Procesa los albaranes de proveedores
*/

STATIC FUNCTION cFacPrv( aGet, oBrw, nMode, aTmp )

   local lValid   := .f.
   local cFactura := aGet[ _CNUMFAC ]:varGet()
   local nOption  := 0

   if nMode != APPD_MODE .OR. empty( cFactura )
      return .t.
   end if

   if ( D():FacturasProveedores( nView ) )->( dbSeek( cFactura ) )

      if empty( aTmp[ _CCODPRV ] )
         aGet[ _CCODPRV ]:cText( ( D():FacturasProveedores( nView ) )->cCodPrv )
         aGet[ _CCODPRV ]:lValid()
      end if

      aGet[ _CCODALM ]:cText( ( D():FacturasProveedores( nView ) )->cCodAlm )
      aGet[ _CCODALM ]:lValid()

      aGet[ _CALMORIGEN ]:cText( ( D():FacturasProveedores( nView ) )->cAlmOrigen )
      aGet[ _CALMORIGEN ]:lValid()

      if empty( aTmp[ _CCODCAJ ] )
         aGet[ _CCODCAJ ]:cText( ( D():FacturasProveedores( nView ) )->cCodCaj )
         aGet[ _CCODCAJ ]:lValid()
      end if

      if empty( aTmp[ _CCODPAGO ] )
         aGet[ _CCODPAGO ]:cText( ( D():FacturasProveedores( nView ) )->cCodPago )
         aGet[ _CCODPAGO ]:lValid()
      end if

      if empty( aTmp[ _CDTOESP ] )
         aGet[ _CDTOESP ]:cText( ( D():FacturasProveedores( nView ) )->cDtoEsp )
      end if

      if empty( aTmp[ _NDTOESP ] )
         aGet[ _NDTOESP ]:cText( ( D():FacturasProveedores( nView ) )->nDtoEsp )
      end if

      if empty( aTmp[ _CDPP ] )
         aGet[ _CDPP    ]:cText( ( D():FacturasProveedores( nView ) )->cDpp )
      end if

      if empty( aTmp[ _NDPP ] )
         aGet[ _NDPP    ]:cText( ( D():FacturasProveedores( nView ) )->nDpp )
      end if

      if empty( aTmp[ _CDTOUNO ] )
         aGet[ _CDTOUNO ]:cText( ( D():FacturasProveedores( nView ) )->cDtoUno )
      end if

      if empty( aTmp[ _NDTOUNO ] )
         aGet[ _NDTOUNO ]:cText( ( D():FacturasProveedores( nView ) )->nDtoUno )
      end if

      if empty( aTmp[ _CDTODOS ] )
         aGet[ _CDTODOS ]:cText( ( D():FacturasProveedores( nView ) )->cDtoDos )
      end if

      if empty( aTmp[ _NDTODOS ] )
         aGet[ _NDTODOS ]:cText( ( D():FacturasProveedores( nView ) )->nDtoDos )
      end if

      if empty( aTmp[ _MCOMENT ] )
         aGet[ _MCOMENT ]:cText( ( D():FacturasProveedores( nView ) )->cObserv )
      end if

      aGet[ _NREGIVA ]:nOption( Max( ( D():Proveedores( nView ) )->nRegIva, 1 ) )
      aGet[ _NREGIVA ]:Refresh()


      if !empty( nTipRet )
         aGet[ _NTIPRET ]:Select( ( D():FacturasProveedores( nView ) )->nTipRet )
         aGet[ _NTIPRET ]:Refresh()
      end if

      if empty( aTmp[ _MCOMENT ] )
         aGet[ _NPCTRET ]:cText( ( D():FacturasProveedores( nView ) )->nPctRet )
      end if

      if !empty ( ( D():FacturasProveedores( nView ) )->cCtrCoste )

         aGet[ _CCENTROCOSTE ]:cText( ( D():FacturasProveedores( nView ) )->cCtrCoste )
         aGet[ _CCENTROCOSTE ]:lValid()

     endif

      /*
      Si lo encuentra----------------------------------------------------------
      */

      nOption           := nImportaLineas()

      if nOption >= 1                              .and.;
         ( D():FacturasProveedoresLineas( nView ) )->( dbSeek( cFactura ) )

         while ( ( D():FacturasProveedoresLineas( nView ) )->cSerFac + Str( ( D():FacturasProveedoresLineas( nView ) )->nNumFac ) + ( D():FacturasProveedoresLineas( nView ) )->cSufFac == cFactura )

            ( dbfTmp )->( dbAppend() )

            ( dbfTmp )->cRef        := ( D():FacturasProveedoresLineas( nView ) )->cRef
            ( dbfTmp )->cDetalle    := ( D():FacturasProveedoresLineas( nView ) )->cDetalle
            ( dbfTmp )->mLngDes     := ( D():FacturasProveedoresLineas( nView ) )->mLngDes
            ( dbfTmp )->lControl    := ( D():FacturasProveedoresLineas( nView ) )->lControl
            ( dbfTmp )->mNumSer     := ( D():FacturasProveedoresLineas( nView ) )->mNumSer
            ( dbfTmp )->nIva        := ( D():FacturasProveedoresLineas( nView ) )->nIva
            ( dbfTmp )->nReq        := ( D():FacturasProveedoresLineas( nView ) )->nReq
            ( dbfTmp )->nPreUnit    := ( D():FacturasProveedoresLineas( nView ) )->nPreUnit
            ( dbfTmp )->nUniCaja    := if( nOption == 2, ( ( D():FacturasProveedoresLineas( nView ) )->nUniCaja * -1 ), ( D():FacturasProveedoresLineas( nView ) )->nUniCaja )
            ( dbfTmp )->nCanEnt     := ( D():FacturasProveedoresLineas( nView ) )->nCanEnt
            ( dbfTmp )->nDtoLin     := ( D():FacturasProveedoresLineas( nView ) )->nDtoLin
            ( dbfTmp )->nDtoPrm     := ( D():FacturasProveedoresLineas( nView ) )->nDtoPrm
            ( dbfTmp )->nDtoRap     := ( D():FacturasProveedoresLineas( nView ) )->nDtoRap
            ( dbfTmp )->cAlmLin     := ( D():FacturasProveedoresLineas( nView ) )->cAlmLin
            ( dbfTmp )->cAlmOrigen  := ( D():FacturasProveedoresLineas( nView ) )->cAlmOrigen
            ( dbfTmp )->nNumLin     := ( D():FacturasProveedoresLineas( nView ) )->nNumLin
            ( dbfTmp )->nUndKit     := ( D():FacturasProveedoresLineas( nView ) )->nUndKit
            ( dbfTmp )->lKitChl     := ( D():FacturasProveedoresLineas( nView ) )->lKitChl
            ( dbfTmp )->lKitArt     := ( D():FacturasProveedoresLineas( nView ) )->lKitArt
            ( dbfTmp )->lKitPrc     := ( D():FacturasProveedoresLineas( nView ) )->lKitPrc
            ( dbfTmp )->cCodPr1     := ( D():FacturasProveedoresLineas( nView ) )->cCodPr1                              // Cod. prop. 1
            ( dbfTmp )->cCodPr2     := ( D():FacturasProveedoresLineas( nView ) )->cCodPr2                              // Cod. prop. 2
            ( dbfTmp )->cValPr1     := ( D():FacturasProveedoresLineas( nView ) )->cValPr1                              // Val. prop. 1
            ( dbfTmp )->cValPr2     := ( D():FacturasProveedoresLineas( nView ) )->cValPr2                              // Val. prop. 2
            ( dbfTmp )->lLote       := ( D():FacturasProveedoresLineas( nView ) )->lLote
            ( dbfTmp )->nLote       := ( D():FacturasProveedoresLineas( nView ) )->nLote
            ( dbfTmp )->cLote       := ( D():FacturasProveedoresLineas( nView ) )->cLote
            ( dbfTmp )->mObsLin     := ( D():FacturasProveedoresLineas( nView ) )->mObsLin
            ( dbfTmp )->cRefPrv     := ( D():FacturasProveedoresLineas( nView ) )->cRefPrv
            ( dbfTmp )->cUnidad     := ( D():FacturasProveedoresLineas( nView ) )->cUnidad
            ( dbfTmp )->nNumMed     := ( D():FacturasProveedoresLineas( nView ) )->nNumMed
            ( dbfTmp )->nMedUno     := ( D():FacturasProveedoresLineas( nView ) )->nMedUno
            ( dbfTmp )->nMedDos     := ( D():FacturasProveedoresLineas( nView ) )->nMedDos
            ( dbfTmp )->nMedTre     := ( D():FacturasProveedoresLineas( nView ) )->nMedTre
            ( dbfTmp )->dFecCad     := ( D():FacturasProveedoresLineas( nView ) )->dFecCad
            ( dbfTmp )->lGasSup     := ( D():FacturasProveedoresLineas( nView ) )->lGasSup
            ( dbfTmp )->nBultos     := ( D():FacturasProveedoresLineas( nView ) )->nBultos
            ( dbfTmp )->cFormato    := ( D():FacturasProveedoresLineas( nView ) )->cFormato   
            ( dbfTmp )->cCodImp     := ( D():FacturasProveedoresLineas( nView ) )->cCodImp    
            ( dbfTmp )->nValImp     := ( D():FacturasProveedoresLineas( nView ) )->nValImp
            ( dbfTmp )->dFecFac     := ( D():FacturasProveedoresLineas( nView ) )->dFecFac
            ( dbfTmp )->tFecFac     := ( D():FacturasProveedoresLineas( nView ) )->tFecFac
            ( dbfTmp )->cCtrCoste   := ( D():FacturasProveedoresLineas( nView ) )->cCtrCoste
            ( dbfTmp )->cCodFam     := ( D():FacturasProveedoresLineas( nView ) )->cCodFam
            ( dbfTmp )->cRefAux     := ( D():FacturasProveedoresLineas( nView ) )->cRefAux
            ( dbfTmp )->cRefAux2    := ( D():FacturasProveedoresLineas( nView ) )->cRefAux2
            ( dbfTmp )->cCtrCoste   := ( D():FacturasProveedoresLineas( nView ) )->cCtrCoste
            ( dbfTmp )->cTipCtr     := ( D():FacturasProveedoresLineas( nView ) )->cTipCtr
            ( dbfTmp )->cTerCtr     := ( D():FacturasProveedoresLineas( nView ) )->cTerCtr

            ( D():FacturasProveedoresLineas( nView ) )->( dbSkip() )

         end while

         ( dbfTmp )->( dbGoTop() )

         oBrw:Refresh()

      end if

      aGet[ _CNUMFAC ]:bWhen     := {|| .f. }

   end if

   nTotRctPrv( nil, D():FacturasRectificativasProveedores( nView ), dbfTmp, D():TiposIva( nView ), D():Divisas( nView ), D():FacturasProveedoresPagos( nView ), aTmp )

RETURN ( .t. )

//---------------------------------------------------------------------------//

STATIC FUNCTION BeginTrans( aTmp, nMode )

   local oError
   local oBlock
   local lErrors     := .f.
   local cDbf        := "FPrvL"
   local cDbfInc     := "FPrvI"
   local cDbfDoc     := "FPrvD"
   local cDbfPgo     := "FPrvP"
   local cDbfSer     := "FPrvS"
   local nFactura    := aTmp[ _CSERFAC ] + Str( aTmp[ _NNUMFAC ] ) + aTmp[ _CSUFFAC ]

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      aNumAlb        := {}

      cNewFile       := cGetNewFileName( cPatTmp() + cDbf )
      cTmpInc        := cGetNewFileName( cPatTmp() + cDbfInc )
      cTmpDoc        := cGetNewFileName( cPatTmp() + cDbfDoc )
      cTmpPgo        := cGetNewFileName( cPatTmp() + cDbfPgo )
      cTmpSer        := cGetNewFileName( cPatTmp() + cDbfSer )

      /*
      Primero Crear la base de datos local
      */

      dbCreate( cNewFile, aSqlStruct( aColRctPrv() ), cLocalDriver() )
      dbUseArea( .t., cLocalDriver(), cNewFile, cCheckArea( cDbf, @dbfTmp ), .f. )

      if !( dbfTmp )->( neterr() )

         ( dbfTmp )->( OrdCondSet( "!Deleted()", {||!Deleted() } ) )
         ( dbfTmp )->( OrdCreate( cNewFile, "nNumLin", "Str( nNumLin, 4 )", {|| Str( Field->nNumLin ) } ) )

         ( dbfTmp )->( OrdCondSet( "!Deleted()", {||!Deleted() } ) )
         ( dbfTmp )->( OrdCreate( cNewFile, "Recno", "Str( Recno() )", {|| Str( Recno() ) } ) )

      end if

      /*
      A¤adimos desde el fichero de lineas
      */

      if ( D():FacturasRectificativasProveedoresLineas( nView ) )->( dbSeek( nFactura ) )

         while ( ( D():FacturasRectificativasProveedoresLineas( nView ) )->CSERFAC + Str( ( D():FacturasRectificativasProveedoresLineas( nView ) )->NNUMFAC ) + ( D():FacturasRectificativasProveedoresLineas( nView ) )->CSUFFAC == nFactura .AND. !( D():FacturasRectificativasProveedoresLineas( nView ) )->( eof() ) )

            dbPass( D():FacturasRectificativasProveedoresLineas( nView ), dbfTmp, .t. )
            ( D():FacturasRectificativasProveedoresLineas( nView ) )->( dbSkip() )

         end while

      end if

      ( dbfTmp )->( dbGoTop() )

      /*
      Creamos la tabla temporal de incidencias
      */

      dbCreate( cTmpInc, aSqlStruct( aIncRctPrv() ), cLocalDriver() )
      dbUseArea( .t., cLocalDriver(), cTmpInc, cCheckArea( cDbfInc, @dbfTmpInc ), .f. )
      if !( dbfTmpInc )->( neterr() )
         ( dbfTmpInc )->( ordCondSet( "!Deleted()", {||!Deleted() } ) )
         ( dbfTmpInc )->( ordCreate( cTmpInc, "Recno", "Recno()", {|| Recno() } ) )
      end if

      /*
      A¤adimos desde el fichero de incidencias
      */

      if ( nMode != DUPL_MODE ) .and. ( D():FacturasRectificativasProveedoresIncidencias( nView ) )->( dbSeek( nFactura ) )

         while ( ( D():FacturasRectificativasProveedoresIncidencias( nView ) )->cSerFac + Str( ( D():FacturasRectificativasProveedoresIncidencias( nView ) )->nNumFac ) + ( D():FacturasRectificativasProveedoresIncidencias( nView ) )->cSufFac == nFactura ) .AND. ( D():FacturasRectificativasProveedoresIncidencias( nView ) )->( !eof() )

            dbPass( D():FacturasRectificativasProveedoresIncidencias( nView ), dbfTmpInc, .t. )
            ( D():FacturasRectificativasProveedoresIncidencias( nView ) )->( dbSkip() )

         end while

      end if

      ( dbfTmpInc )->( dbGoTop() )

      /*
      Creamos la tabla temporal de documentos
      */

      dbCreate( cTmpDoc, aSqlStruct( aFacPrvDoc() ), cLocalDriver() )
      dbUseArea( .t., cLocalDriver(), cTmpDoc, cCheckArea( cDbfDoc, @dbfTmpDoc ), .f. )
      if !( dbfTmpDoc )->( neterr() )
         ( dbfTmpDoc )->( ordCondSet( "!Deleted()", {||!Deleted() } ) )
         ( dbfTmpDoc )->( ordCreate( cTmpDoc, "Recno", "Recno()", {|| Recno() } ) )
      end if

      /*
      A¤adimos desde el fichero de documetos
      */

      if ( nMode != DUPL_MODE ) .and. ( D():FacturasRectificativasProveedoresDocumentos( nView ) )->( dbSeek( nFactura ) )
         while ( ( D():FacturasRectificativasProveedoresDocumentos( nView ) )->cSerFac + Str( ( D():FacturasRectificativasProveedoresDocumentos( nView ) )->nNumFac ) + ( D():FacturasRectificativasProveedoresDocumentos( nView ) )->cSufFac == nFactura ) .AND. ( D():FacturasRectificativasProveedoresDocumentos( nView ) )->( !eof() )
            dbPass( D():FacturasRectificativasProveedoresDocumentos( nView ), dbfTmpDoc, .t. )
            ( D():FacturasRectificativasProveedoresDocumentos( nView ) )->( dbSkip() )
         end while
      end if

      ( dbfTmpDoc )->( dbGoTop() )

      /*
      Creamos el fichero de series------------------------------------------------
      */

      dbCreate( cTmpSer, aSqlStruct( aSerRctPrv() ), cLocalDriver() )
      dbUseArea( .t., cLocalDriver(), cTmpSer, cCheckArea( cDbf, @dbfTmpSer ), .f. )

      if !( dbfTmpSer )->( neterr() )
         ( dbfTmpSer )->( OrdCondSet( "!Deleted()", {||!Deleted() } ) )
         ( dbfTmpSer )->( OrdCreate( cTmpSer, "nNumLin", "Str( nNumLin, 4 ) + cRef", {|| Str( Field->nNumLin, 4 ) + Field->cRef } ) )
      end if

      /*
      A¤adimos desde el fichero de series-----------------------------------------
      */

      if ( nMode != DUPL_MODE ) .and. ( D():FacturasRectificativasProveedoresDocumentos( nView ) )->( dbSeek( nFactura ) )
         while ( ( D():FacturasRectificativasProveedoresDocumentos( nView ) )->cSerFac + Str( ( D():FacturasRectificativasProveedoresDocumentos( nView ) )->nNumFac ) + ( D():FacturasRectificativasProveedoresDocumentos( nView ) )->cSufFac == nFactura .and. !( D():FacturasRectificativasProveedoresDocumentos( nView ) )->( eof() ) )
            dbPass( D():FacturasRectificativasProveedoresDocumentos( nView ), dbfTmpSer, .t. )
            ( D():FacturasRectificativasProveedoresDocumentos( nView ) )->( dbSkip() )
         end while
      end if

      ( dbfTmpSer )->( dbGoTop() )

      /*
      Creamos la tabla temporal de pagos a proveedores
      */

      dbCreate( cTmpPgo, aSqlStruct( aItmRecPrv() ), cLocalDriver() )
      dbUseArea( .t., cLocalDriver(), cTmpPgo, cCheckArea( cDbfPgo, @dbfTmpPgo ), .f. )
      if !( dbfTmpPgo )->( neterr() )

         ( dbfTmpPgo )->( ordCondSet( "!Deleted() .and. !empty( cTipRec )", {|| !Deleted() .and. !empty( Field->cTipRec ) } ) )
         ( dbfTmpPgo )->( ordCreate( cTmpPgo, "rNumFac", "cSerFac + Str( nNumFac ) + cSufFac + Str( nNumRec )", {|| Field->cSerFac + Str( Field->nNumFac ) + Field->cSufFac + Str( Field->nNumRec ) }, ) )

         ( dbfTmpPgo )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
         ( dbfTmpPgo )->( ordCreate( cTmpPgo, "cRecDev", "CRECDEV", {|| Field->CRECDEV } ) )

         ( dbfTmpPgo )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
         ( dbfTmpPgo )->( ordCreate( cTmpPgo, "nNumFac", "cSerFac + Str( nNumFac ) + cSufFac + Str( nNumRec )", {|| Field->cSerFac + Str( Field->nNumFac ) + Field->cSufFac + Str( Field->nNumRec ) }, ) )

         ( dbfTmpPgo )->( ordCondSet( "!Deleted()", {||!Deleted() } ) )
         ( dbfTmpPgo )->( ordCreate( cTmpPgo, "Recno", "Recno()", {|| Recno() } ) )

      end if

      /*
      A¤adimos desde el fichero de pagos
      */

      if ( nMode != DUPL_MODE ) .and. ( D():FacturasProveedoresPagos( nView ) )->( dbSeek( nFactura ) ) .and. nMode != DUPL_MODE

         while ( ( D():FacturasProveedoresPagos( nView ) )->cSerFac + Str( ( D():FacturasProveedoresPagos( nView ) )->nNumFac ) + ( D():FacturasProveedoresPagos( nView ) )->cSufFac == nFactura ) .and. ( D():FacturasProveedoresPagos( nView ) )->( !eof() )

            dbPass( D():FacturasProveedoresPagos( nView ), dbfTmpPgo, .t. )

            ( D():FacturasProveedoresPagos( nView ) )->( dbSkip() )

         end while

      end if

      ( dbfTmpPgo )->( dbGoTop() )

   oDetCamposExtra:SetTemporal( aTmp[ _CSERFAC ] + Str( aTmp[ _NNUMFAC ] ) + aTmp[ _CSUFFAC ], "", nMode )

   RECOVER USING oError

      msgStop( "Imposible crear tablas temporales." + CRLF + ErrorMessage( oError ) )

      KillTrans()

      lErrors     := .t.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lErrors )

//---------------------------------------------------------------------------//

STATIC FUNCTION EndTrans( aTmp, aGet, oBrw, oBrwLin, nMode, nDec, oDlg, oFld )

   local aTbl
   local nItem
   local nNumLin
   local cSerFac
   local nNumFac
   local cSufFac
   local oError
   local oBlock

   if empty( aTmp[ _CSERFAC ] )
      aTmp[ _CSERFAC ]  := "A"
   end if

   nNumLin              := 1
   cSerFac              := aTmp[ _CSERFAC ]
   nNumFac              := aTmp[ _NNUMFAC ]
   cSufFac              := aTmp[ _CSUFFAC ]

   if !lValidaOperacion( aTmp[ _DFECFAC ] )
      Return .f.
   end if

   if !lValidaSerie( aTmp[ _CSERFAC ] )
      Return .f.
   end if

   if empty( aTmp[ _CCODPRV ] )
      msgStop( "Proveedor no puede estar vacío." )
      aGet[ _CCODPRV ]:SetFocus()
      return .f.
   end if

   if empty( aTmp[ _CCODALM ] )
      msgStop( "Almacen no puede estar vacío." )
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

   if empty( aTmp[ _CNUMFAC ] )
      msgStop( "Número de factura no puede estar vacia." )
      aGet[ _CNUMFAC ]:SetFocus()
      return .f.
   end if

   if !aTmp[ _LFACGAS ] .and. ( dbfTmp )->( lastrec() ) == 0
      MsgStop( "No puede almacenar un documento sin líneas." )
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

   /*
   Para q nadie toque mientras grabamos----------------------------------------
   */

   CursorWait()

   oDlg:Disable()

   oMsgText( "Archivando" )

   TComercio:resetProductsToUpdateStocks()

   oBlock      := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   aTmp[ _DFECCHG ]  := GetSysDate()
   aTmp[ _CTIMCHG ]  := Time()

   do case
   case isAppendOrDuplicateMode( nMode )

      // Nuevo numero de la factura--------------------------------------------

      nNumFac           := nNewDoc( cSerFac, D():FacturasRectificativasProveedores( nView ), "nRctPrv", , D():Contadores( nView ) )
      aTmp[ _NNUMFAC ]  := nNumFac
      cSufFac           := retSufEmp()
      aTmp[ _CSUFFAC ]  := cSufFac

   case isEditMode( nMode )

      while ( D():FacturasRectificativasProveedoresLineas( nView ) )->( dbSeek( cSerFac + str( nNumFac ) + cSufFac ) .and. !( D():FacturasRectificativasProveedoresLineas( nView ) )->( eof() ) )

         TComercio:appendProductsToUpadateStocks( ( D():FacturasRectificativasProveedoresLineas( nView ) )->cRef, nView )

         if dbLock( D():FacturasRectificativasProveedoresLineas( nView ) )
            ( D():FacturasRectificativasProveedoresLineas( nView ) )->( dbDelete() )
            ( D():FacturasRectificativasProveedoresLineas( nView ) )->( dbUnLock() )
         end if

      end while

      while ( D():FacturasRectificativasProveedoresIncidencias( nView ) )->( dbSeek( cSerFac + str( nNumFac ) + cSufFac ) .and. !( D():FacturasRectificativasProveedoresIncidencias( nView ) )->( eof() ) )
         if dbLock( D():FacturasRectificativasProveedoresIncidencias( nView ) )
            ( D():FacturasRectificativasProveedoresIncidencias( nView ) )->( dbDelete() )
            ( D():FacturasRectificativasProveedoresIncidencias( nView ) )->( dbUnLock() )
         end if
      end while

      while ( D():FacturasRectificativasProveedoresDocumentos( nView ) )->( dbSeek( cSerFac + str( nNumFac ) + cSufFac ) .and. !( D():FacturasRectificativasProveedoresDocumentos( nView ) )->( eof() ) )
         if dbLock( D():FacturasRectificativasProveedoresDocumentos( nView ) )
            ( D():FacturasRectificativasProveedoresDocumentos( nView ) )->( dbDelete() )
            ( D():FacturasRectificativasProveedoresDocumentos( nView ) )->( dbUnLock() )
         end if
      end while

      while ( D():FacturasProveedoresPagos( nView ) )->( dbSeek( cSerFac + str( nNumFac ) + cSufFac ) .and. !( D():FacturasProveedoresPagos( nView ) )->( eof() ) )
         if dbLock( D():FacturasProveedoresPagos( nView ) )
            ( D():FacturasProveedoresPagos( nView ) )->( dbDelete() )
            ( D():FacturasProveedoresPagos( nView ) )->( dbUnLock() )
         end if
      end while

      while ( D():FacturasRectificativasProveedoresSeries( nView ) )->( dbSeek( cSerFac + Str( nNumFac ) + cSufFac ) )
         if dbLock( D():FacturasRectificativasProveedoresSeries( nView ) )
            ( D():FacturasRectificativasProveedoresSeries( nView ) )->( dbDelete() )
            ( D():FacturasRectificativasProveedoresSeries( nView ) )->( dbUnLock() )
         end if
      end while

   end case

   /*
   Quitamos los filtros--------------------------------------------------------
   */

   ( dbfTmp )->( dbClearFilter() )

   oMsgProgress()
   oMsgProgress():SetRange( 0, ( dbfTmp )->( LastRec() ) )

	/*
   Ahora escribimos en el fichero definitivo-----------------------------------
	*/

   ( dbfTmp )->( dbGoTop() )
   while !( dbfTmp )->( eof() )

      aTbl               := dbScatter( dbfTmp )
      aTbl[ _CSERFAC ]   := cSerFac
      aTbl[ _NNUMFAC ]   := nNumFac
      aTbl[ _CSUFFAC ]   := cSufFac
      aTbl[ __DFECFAC ]  := aTmp[ _DFECFAC ]
      aTbl[ __TFECFAC ]  := aTmp[ _TFECFAC ]

      dbGather( aTbl, D():FacturasRectificativasProveedoresLineas( nView ), .t. )

      TComercio:appendProductsToUpadateStocks( ( dbfTmp )->cRef, nView )

      ( dbfTmp )->( dbSkip() )

      oMsgProgress():Deltapos( 1 )

   end while

   /*
   Ahora escribimos en el fichero definitivo de incidencias--------------------
	*/

   ( dbfTmpInc )->( dbGoTop() )
   while ( dbfTmpInc )->( !eof() )
      dbPass( dbfTmpInc, D():FacturasRectificativasProveedoresIncidencias( nView ), .t., cSerFac, nNumFac, cSufFac )
      ( dbfTmpInc )->( dbSkip() )
   end while

   /*
   Ahora escribimos en el fichero definitivo de documentos---------------------
	*/

   ( dbfTmpDoc )->( dbGoTop() )
   while ( dbfTmpDoc )->( !eof() )
      dbPass( dbfTmpDoc, D():FacturasRectificativasProveedoresDocumentos( nView ), .t., cSerFac, nNumFac, cSufFac )
      ( dbfTmpDoc )->( dbSkip() )
   end while

   /*
   Escribimos el fichero definitivo de series---------------------------------
   */

   ( dbfTmpSer )->( dbGoTop() )
   while ( dbfTmpSer )->( !eof() )
      dbPass( dbfTmpSer, D():FacturasRectificativasProveedoresSeries( nView ), .t., cSerFac, nNumFac, cSufFac )
      ( dbfTmpSer )->( dbSkip() )
   end while

   /*
   Si cambia el cliente en la factura, lo cambiamos en los recibos-------------
   */

   ( dbfTmpPgo )->( dbGoTop() )

   while ( dbfTmpPgo )->( !eof() )

      if ( dbfTmpPgo )->cCodPrv != aTmp[ _CCODPRV ]
         ( dbfTmpPgo )->cCodPrv := aTmp[ _CCODPRV ]
      end if

      if ( dbfTmpPgo )->cNomPrv != aTmp[ _CNOMPRV ]
         ( dbfTmpPgo )->cNomPrv := aTmp[ _CNOMPRV ]
      end if

      ( dbfTmpPgo )->( dbSkip() )

   end while

   /*
   Ahora escribimos en el fichero definitivo de pagos--------------------------
	*/

   ( dbfTmpPgo )->( dbGoTop() )
   while ( dbfTmpPgo )->( !eof() )

      if !empty( aTmp[ _CCENTROCOSTE ] )
         ( dbfTmpPgo )->cCtrCoste := aTmp[ _CCENTROCOSTE ]
      endif

      dbPass( dbfTmpPgo, D():FacturasProveedoresPagos( nView ), .t., cSerFac, nNumFac, cSufFac )
      
      ( dbfTmpPgo )->( dbSkip() )

   end while

   /*
   Guardamos los campos de totales--------------------------------------------
   */

   aTmp[ _NTOTNET ]   := nTotNet
   aTmp[ _NTOTSUP ]   := nTotSup
   aTmp[ _NTOTIVA ]   := nTotIva
   aTmp[ _NTOTREQ ]   := nTotReq
   aTmp[ _NTOTFAC ]   := nTotFac

   /*
   Guardamos los campos extra-----------------------------------------------
   */

   oDetCamposExtra:saveExtraField( aTmp[ _CSERFAC ] + Str( aTmp[ _NNUMFAC ] ) + aTmp[ _CSUFFAC ], "" )

   /*
   Grabamos las cabeceras de los albaranes
   */

   WinGather( aTmp, , D():FacturasRectificativasProveedores( nView ), , nMode )

   /*
   Generar los pagos de las facturas
   */

   GenPgoRctPrv( cSerFac + Str( nNumFac ) + cSufFac, D():FacturasRectificativasProveedores( nView ), D():FacturasRectificativasProveedoresLineas( nView ), D():FacturasProveedoresPagos( nView ), D():Proveedores( nView ),D():TiposIva( nView ), D():FormasPago( nView ), D():Divisas( nView ) )

   /*
   Escribe los datos pendientes------------------------------------------------
   */

   dbCommitAll()

   //------------------------------------------------------------------------//

   RECOVER USING oError

      RollBackTransaction()
      msgStop( "Imposible almacenar documentos" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   oMsgText()
   EndProgress()

   // actualiza el stock de prestashop-----------------------------------------

   TComercio:updateWebProductStocks()

   oDlg:Enable()
   oDlg:End( IDOK )

   CursorWE()

RETURN .T.

//------------------------------------------------------------------------//

STATIC FUNCTION KillTrans( oBrwLin )

	/*
	Borramos los ficheros
	*/

   if !empty( dbfTmp ) .and. ( dbfTmp )->( Used() )
      ( dbfTmp )->( dbCloseArea() )
   end if

   if !empty( dbfTmpInc ) .and. ( dbfTmpInc )->( Used() )
      ( dbfTmpInc )->( dbCloseArea() )
   end if

   if !empty( dbfTmpDoc ) .and. ( dbfTmpDoc )->( Used() )
      ( dbfTmpDoc )->( dbCloseArea() )
   end if

   if !empty( dbfTmpPgo ) .and. ( dbfTmpPgo )->( Used() )
      ( dbfTmpPgo )->( dbCloseArea() )
   end if

   if !empty( dbfTmpSer ) .and. ( dbfTmpSer )->( Used() )
      ( dbfTmpSer )->( dbCloseArea() )
   end if

   dbfTmp            := nil
   dbfTmpInc         := nil
   dbfTmpDoc         := nil
   dbfTmpPgo         := nil
   dbfTmpSer         := nil

   dbfErase( cNewFile )
   dbfErase( cTmpInc  )
   dbfErase( cTmpDoc  )
   dbfErase( cTmpPgo  )
   dbfErase( cTmpSer  )

   if !empty( oMnuRec )
      oMnuRec:End()
   end if

   memory( -1 )

   if oBrwLin != nil
      oBrwLin:CloseData()
   end if

RETURN NIL

//------------------------------------------------------------------------//

STATIC FUNCTION CreateFiles( cPath )

   if !lExistTable( cPath + "RctPrvT.DBF", cLocalDriver() )
      dbCreate( cPath + "RctPrvT.DBF", aSqlStruct( aItmRctPrv() ), cLocalDriver() )
   end if
   if !lExistTable( cPath + "RctPrvL.DBF", cLocalDriver() )
      dbCreate( cPath + "RctPrvL.DBF", aSqlStruct( aColRctPrv() ), cLocalDriver() )
   end if
   if !lExistTable( cPath + "RctPrvI.DBF", cLocalDriver() )
      dbCreate( cPath + "RctPrvI.DBF", aSqlStruct( aIncRctPrv() ), cLocalDriver() )
   end if
   if !lExistTable( cPath + "RctPrvD.DBF", cLocalDriver() )
      dbCreate( cPath + "RctPrvD.DBF", aSqlStruct( aFacPrvDoc() ), cLocalDriver() )
   end if
   if !lExistTable( cPath + "RctPrvS.Dbf", cLocalDriver() )
      dbCreate( cPath + "RctPrvS.Dbf", aSqlStruct( aSerRctPrv() ), cLocalDriver() )
   end if

RETURN NIL

//----------------------------------------------------------------------------//

/*
Cambia el estado de un pedido
*/

STATIC FUNCTION ChgContabilizado( lContabilizado, cFactura, nAsiento, oTree )

   if dbDialogLock( D():FacturasRectificativasProveedores( nView ) )
      ( D():FacturasRectificativasProveedores( nView ) )->lContab := lContabilizado
      ( D():FacturasRectificativasProveedores( nView ) )->( dbUnlock() )
   end if

   if !empty( oTree )
      oTree:Add( "Factura rectificativa : " + Rtrim( cFactura ) + " asiento generado num. " + Alltrim( Str( nAsiento ) ), 1 )
   end if

RETURN NIL

//-------------------------------------------------------------------------//

STATIC FUNCTION ImpFactura( oBrw, aGet, aTmp )

	local oDlg
	local oBrwFac
	local oGetDes
	local cGetDes
	local cSelFac	:= ""
	local aLinFac	:= {}

	local nChgDiv	:= aTmp[ _NVDVFAC ]

	IF empty( aGet[ _CCODPRV ]:varGet() )
		msgStop( "Es necesario codificar un proveedor" )
		RETURN .T.
	END IF

	DEFINE DIALOG oDlg RESOURCE "IMPFACPRV"

		REDEFINE GET oGetDes VAR cGetDes;
			ID 		110 ;
			COLOR 	CLR_GET ;
			VALID		( loadFac( cGetDes, oBrwFac, @aLinFac ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( oGetDes:cText( cGetFile( "*.dat", "Seleccione el fichero de la factura" ) ) );
			OF 		oDlg

		REDEFINE LISTBOX oBrwFac ;
			VAR 		cSelFac ;
			ITEMS 	{} ;
			ID 		120 ;
			OF	 		oDlg

		REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
			ACTION 	(  appdFac( aGet, cSelFac, oBrwFac:aItems, aLinFac, nChgDiv ),;
                     oDlg:end( IDOK ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
         CANCEL ;
         ACTION   ( oDlg:end() )

		ACTIVATE DIALOG oDlg	CENTER

RETURN NIL

//--------------------------------------------------------------------------//

/*
Esta funcion carga las facturas y sus lineas en dos arrays
*/

STATIC FUNCTION loadFac( cGetDes, oBrwFac, aLinFac )

	local	a1
	local a2
   local cIni
	local cSep
	local oText
	local nCont		:= 0

	IF empty( cGetDes )
		RETURN .T.
	END IF

	CursorWait()

	IF	file( cGetDes )

		oText 			:= TTxtFile():New( cGetDes )
		oText:Open()

		/*
		Inicializamos los valores
		*/

		aLinFac			:= {}
		oBrwFac:reset()

		/*
		Cabeceras de la factura
		*/

		WHILE !oText:lEof()

			a1	:= oText:cGetStr( 6 )
					oText:cGetStr( 1 )
			a2	:= oText:cGetStr( 6 )
					oText:cGetStr( 1 )

			++nCont
			aadd( aLinFac, {} )

			oBrwFac:Add( a1 + space( 1 ) + substr( a2, 1, 2 ) + "/" + substr( a2, 3, 2 ) + "/" + substr( a2, 5, 2 ) )

			WHILE !oText:lEof()

				/*
				Avanzadilla en la lectura
				*/

				cIni	:= oText:cGetStr( 1 )

				IF cIni == chr( 255 )
					EXIT
				END IF

				/*
				A¤adimos la linea de detalle a un array
				*/

				aadd( aLinFac[ nCont ],;
                              {  cIni + oText:cGetStr( 5 ),;   // "Codigo interno"
                                 oText:cGetStr( 13 ),;         // "Codigo Barras"
											oText:cGetStr( 30 ),;			// "Descripción"
											oText:cGetStr(  7 ),;			// "Unidades"
											oText:cGetStr(  7 ),;			// "Coste"
                                 oText:cGetStr(  1 ) } )       // "tipo " + cImp()

				/*
				Estudiamos el separador
				*/

				cSep	:= oText:cGetStr( 1 )

				IF cSep == chr( 254 )
					LOOP
				END IF

			END WHILE

		END WHILE

      oText:Close()

	ELSE

		msgStop( "Fichero no encontrado" )

	END IF

	oBrwFac:setFocus()

	CursorWe()

RETURN .T.

//--------------------------------------------------------------------------//

/*
A¤ade las lineas de detalle al fichero definitivamente
*/

STATIC FUNCTION appdFac( aGet, cSelFac, aSelFac, aLinFac, nChgDiv )

   local n
	local nIva
	local nSelFac := AScan( aSelFac,;
						  { | cItem | Upper( AllTrim( cItem ) ) == ;
										  Upper( AllTrim( cSelFac ) ) } )

	IF nSelFac	!= 0

		aGet[_CSUPED]:cText( substr( cSelFac, 1, 6 ) )

		FOR n := 1 TO len( aLinFac[ nSelFac ] )

			(dbfTmp)->( dbAppend() )

			(dbfTmp)->CREF			:= aLinFac[ nSelFac, n, 1 ]
			(dbfTmp)->CDETALLE 	:= aLinFac[ nSelFac, n, 3 ]
			(dbfTmp)->NUNICAJA	:= val( aLinFac[ nSelFac, n, 4 ] ) / 100
			(dbfTmp)->NPREUNIT 	:= val( aLinFac[ nSelFac, n, 5 ] ) / 100

			/*
			Ojo esto es una chapuza para FECA
			*/

			DO CASE
			CASE aLinFac[ nSelFac, n, 6 ] == "1"
				nIva	:= 7
			CASE aLinFac[ nSelFac, n, 6 ] == "2"
				nIva	:= 16
			CASE aLinFac[ nSelFac, n, 6 ] == "3"
				nIva	:= 4
			END CASE

			(dbfTmp)->NIVA			:= nIva

		NEXT

		(dbfTmp)->( dbGoTop() )

	END IF

RETURN NIL

//---------------------------------------------------------------------------//

static function lNotOpen()

   if NetErr()
      msgStop( "Imposible abrir ficheros." )
      CloseFiles()
      return .t.
   end if

return .f.

//--------------------------------------------------------------------------//

/*
Comprueba q no existan recibos pagados
*/

Static Function lRecibosPagados( uFacPrv, cRctPrvP )

   local cNumFac
   local nRecAct  	
   local nOrdAct  	
   local lRecPgd  	:= .f.

   DEFAULT cRctPrvP 	:= D():FacturasProveedoresPagos( nView )

   nRecAct  			:= ( cRctPrvP )->( Recno() )
   nOrdAct  			:= ( cRctPrvP )->( OrdSetFocus( "NNUMFAC" ) )

   if ValType( uFacPrv ) == "A"
      cNumFac     	:= uFacPrv[ _CSERFAC ] + Str( uFacPrv[ _NNUMFAC ], 9 ) + uFacPrv[ _CSUFFAC ]
   else
      cNumFac     	:= ( uFacPrv )->CSERFAC + Str( ( uFacPrv )->NNUMFAC ) + ( uFacPrv )->CSUFFAC
   end if

   if ( cRctPrvP )->( dbSeek( cNumFac ) )
      while cNumFac == ( cRctPrvP )->cSerFac + Str( ( cRctPrvP )->nNumFac ) + ( cRctPrvP )->cSufFac .and. !( cRctPrvP )->( eof() )
         if ( cRctPrvP )->lCobrado .and. !( cRctPrvP )->lDevuelto
            lRecPgd  := .t.
            exit
         end if
         ( cRctPrvP )->( dbSkip() )
      end while
   end if

   ( cRctPrvP )->( OrdSetFocus( nOrdAct ) )
   ( cRctPrvP )->( dbGoTo( nRecAct) )

return ( lRecPgd )

//----------------------------------------------------------------------------//

static function lGenFac( oBrw, oBtn, nDevice )

   local bAction

   DEFAULT nDevice   := IS_PRINTER

   if empty( oBtn )
      return nil
   end if

   IF !( D():Documentos( nView ) )->( dbSeek( "TP" ) )

         DEFINE BTNSHELL RESOURCE "GC_DOCUMENT_WHITE_" OF oWndBrw ;
            NOBORDER ;
            ACTION   ( msgStop( "No hay facturas de proveedores predefinidos" ) );
            TOOLTIP  "No hay documentos" ;
            HOTKEY   "N";
            FROM     oBtn ;
            CLOSED ;
            LEVEL    ACC_EDIT

   ELSE

      WHILE ( D():Documentos( nView ) )->cTipo == "TP" .AND. !( D():Documentos( nView ) )->( eof() )

         bAction  := bGenFac( nDevice, "Imprimiendo facturas de proveedores", ( D():Documentos( nView ) )->CODIGO )

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
      bGen     := {|| nGenRctPrv( nDevice, cTit, cCod ) }
   else
      bGen     := {|| nGenRctPrv( nDevice, cTit, cCod ) }
   end if

return bGen

//---------------------------------------------------------------------------//

static function QuiRctPrv()

   if ( D():FacturasRectificativasProveedores( nView ) )->lCloFac .and. !oUser():lAdministrador()
      msgStop( "Solo puede eliminar facturas cerradas los administradores." )
      Return .f.
   end if

   CursorWait()

   DeleteRelacionRectificativasProveedores()

   if uFieldEmpresa( "lRecNumFac" )
      nPutDoc( ( D():FacturasRectificativasProveedores( nView ) )->cSerFac, ( D():FacturasRectificativasProveedores( nView ) )->nNumFac, ( D():FacturasRectificativasProveedores( nView ) )->cSufFac, D():FacturasRectificativasProveedores( nView ), "nRctPrv", , D():Contadores( nView ) )
   end if

   CursorWE()

Return .t.

//----------------------------------------------------------------------------//

STATIC FUNCTION DeleteRelacionRectificativasProveedores( cFactura )

   local nOrdAnt

   DEFAULT cFactura  := D():FacturasRectificativasProveedoresId( nView ) 

   CursorWait()

   /*
   Eliminamos los apuntes de stocks--------------------------------------------
   */

   TComercio:resetProductsToUpdateStocks()

   while ( D():FacturasRectificativasProveedoresLineas( nView ) )->( dbSeek( cFactura ) ) .and. !( D():FacturasRectificativasProveedoresLineas( nView ) )->( eof() )

      TComercio:appendProductsToUpadateStocks( ( D():FacturasRectificativasProveedoresLineas( nView ) )->cRef, nView )

      dbLockDelete( D():FacturasRectificativasProveedoresLineas( nView ) )

   end while

   /*
   Eliminamos los pagos--------------------------------------------------------
   */

   while ( D():FacturasProveedoresPagos( nView ) )->( dbSeek( cFactura ) ) .and. !( D():FacturasProveedoresPagos( nView ) )->( eof() )
      dbLockDelete( D():FacturasProveedoresPagos( nView ) )
   end while

   while ( D():FacturasRectificativasProveedoresIncidencias( nView ) )->( dbSeek( cFactura ) .and. !( D():FacturasRectificativasProveedoresIncidencias( nView ) )->( eof() ) )
      dbLockDelete( D():FacturasRectificativasProveedoresIncidencias( nView ) )
   end while

   while ( D():FacturasRectificativasProveedoresDocumentos( nView ) )->( dbSeek( cFactura ) .and. !( D():FacturasRectificativasProveedoresDocumentos( nView ) )->( eof() ) )
      dbLockDelete( D():FacturasRectificativasProveedoresDocumentos( nView ) )
   end while

   while ( D():FacturasRectificativasProveedoresSeries( nView ) )->( dbSeek( cFactura ) .and. !( D():FacturasRectificativasProveedoresSeries( nView ) )->( eof() ) )
      dbLockDelete( D():FacturasRectificativasProveedoresSeries( nView ) )
   end while

   // actualiza el stock de prestashop-----------------------------------------

   TComercio:updateWebProductStocks()

   CursorWe()

Return .t.

//--------------------------------------------------------------------------//

Static Function lLiquida( oBrw, cFactura, cDivFac )

   DEFAULT cFactura  := D():FacturasRectificativasProveedoresId( nView ) 
   DEFAULT cDivFac   := ( D():FacturasRectificativasProveedores( nView ) )->cDivFac

   if ( D():FacturasRectificativasProveedores( nView ) )->lLiquidada
      MsgStop( "Factura ya pagada" )
      return .f.
   end if

   /*
   Comporbamos si existen recibos de esta factura
   */

   ( D():FacturasProveedoresPagos( nView ) )->( dbGoTop() )

   if ( D():FacturasProveedoresPagos( nView ) )->( dbSeek( cFactura ) )

      while ( D():FacturasProveedoresPagos( nView ) )->cSerFac + Str( ( D():FacturasProveedoresPagos( nView ) )->nNumFac ) + ( D():FacturasProveedoresPagos( nView ) )->cSufFac == cFactura .and. !( D():FacturasProveedoresPagos( nView ) )->( eof() )

         if !empty( ( D():FacturasProveedoresPagos( nView ) )->cTipRec ) .and. !( D():FacturasProveedoresPagos( nView ) )->lCobrado

            EdtRecPrv( ( D():FacturasProveedoresPagos( nView ) )->cSerFac + Str( ( D():FacturasProveedoresPagos( nView ) )->nNumFac ) + ( D():FacturasProveedoresPagos( nView ) )->cSufFac, .f. )

            exit

         end if

         ( D():FacturasProveedoresPagos( nView ) )->( dbSkip() )

      end do

      /*
      Chequea si la factura esta liquidada----------------------------------------
      */

      ChkLqdRctPrv( nil, D():FacturasRectificativasProveedores( nView ), D():FacturasRectificativasProveedoresLineas( nView ), D():FacturasProveedoresPagos( nView ), D():TiposIva( nView ), D():Divisas( nView ) )

   end if

   oBrw:Refresh()
   oBrw:SetFocus()

Return .t.

//---------------------------------------------------------------------------//

Static Function nEstadoIncidencia( cNumFac )

   local nEstado  := 0

   if ( D():FacturasRectificativasProveedoresIncidencias( nView ) )->( dbSeek( cNumFac ) )

      while ( D():FacturasRectificativasProveedoresIncidencias( nView ) )->cSerFac + Str( ( D():FacturasRectificativasProveedoresIncidencias( nView ) )->nNumFac ) + ( D():FacturasRectificativasProveedoresIncidencias( nView ) )->cSufFac == cNumFac .and. !( D():FacturasRectificativasProveedoresIncidencias( nView ) )->( Eof() )

         if ( D():FacturasRectificativasProveedoresIncidencias( nView ) )->lListo
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

         ( D():FacturasRectificativasProveedoresIncidencias( nView ) )->( dbSkip() )

      end while

   end if

Return ( nEstado )

//---------------------------------------------------------------------------//

Static Function lRecibosPagadosTmp( dbfTmpPgo )

   local lRecPgd  := .f.
   local nRecAct  := ( dbfTmpPgo )->( Recno() )

   while !( dbfTmpPgo )->( eof() )
      if ( dbfTmpPgo )->lCobrado .and. !( dbfTmpPgo )->lDevuelto
         lRecPgd  := .t.
         exit
      end if
      ( dbfTmpPgo )->( dbSkip() )
   end while

   ( dbfTmpPgo )->( dbGoTo( nRecAct) )

return ( lRecPgd )

//---------------------------------------------------------------------------//

static function ShowKitRctPrv( dbfMaster, oBrw, cCodPrv, dbfTmpInc, aGet, aTmp, aControl, oSayGas, oSayLabels, oBrwIva )

   if !empty( aGet )

      if ( SQLAjustableModel():getRolCambiarPrecios( Auth():rolUuid() ) )
         aGet[ ( dbfMaster )->( FieldPos( "lRecargo" ) ) ]:HardEnable()
      else
         aGet[ ( dbfMaster )->( FieldPos( "lRecargo" ) ) ]:HardDisable()
      end if

      if !empty( cCodPrv )
         aGet[ ( dbfMaster )->( FieldPos( "cCodPrv" ) ) ]:cText( cCodPrv )
         aGet[ ( dbfMaster )->( FieldPos( "cCodPrv" ) ) ]:lValid()
      end if

      aGet[ ( dbfMaster )->( FieldPos( "cCodPrv" ) ) ]:SetFocus()

      if !empty( aTmp ) .and. aTmp[ _LFACGAS ]

         oBrw:Hide()
         oBrwIva:Hide()
         aEval( aControl, {| o | o:Hide() } )
         oSayLabels[1]:Hide()
         oSayLabels[2]:Hide()
         oSayLabels[3]:Hide()
         oSayLabels[4]:Hide()
         oSayLabels[5]:Hide()
         aGet[ _CDTOESP ]:Hide()
         aGet[ _CDPP    ]:Hide()
         aGet[ _NDTOESP ]:Hide()
         aGet[ _NDPP    ]:Hide()
         aGet[ _CDTOUNO ]:Hide()
         aGet[ _NDTOUNO ]:Hide()
         aGet[ _CDTODOS ]:Hide()
         aGet[ _NDTODOS ]:Hide()

         aEval( oSayGas, {| o | o:Show() } )
         aGet[ _MCOMGAS  ]:Show()
         aGet[ _NNETGAS1 ]:Show()
         aGet[ _NNETGAS2 ]:Show()
         aGet[ _NNETGAS3 ]:Show()
         aGet[ _NIVAGAS1 ]:Show()
         aGet[ _NIVAGAS2 ]:Show()
         aGet[ _NIVAGAS3 ]:Show()
         aGet[ _NREGAS1  ]:Show()
         aGet[ _NREGAS2  ]:Show()
         aGet[ _NREGAS3  ]:Show()

      else

         oBrw:Show()
         oBrwIva:Show()
         aEval( aControl, {| o | o:Show() } )
         oSayLabels[1]:Show()
         oSayLabels[2]:Show()
         oSayLabels[3]:Show()
         oSayLabels[4]:Show()
         oSayLabels[5]:Show()
         aGet[ _CDTOESP ]:Show()
         aGet[ _CDPP    ]:Show()
         aGet[ _NDTOESP ]:Show()
         aGet[ _NDPP    ]:Show()
         aGet[ _CDTOUNO ]:Show()
         aGet[ _NDTOUNO ]:Show()
         aGet[ _CDTODOS ]:Show()
         aGet[ _NDTODOS ]:Show()

         aEval( oSayGas, {| o | o:Hide() } )
         aGet[ _MCOMGAS  ]:Hide()
         aGet[ _MCOMGAS  ]:Hide()
         aGet[ _NNETGAS1 ]:Hide()
         aGet[ _NNETGAS2 ]:Hide()
         aGet[ _NNETGAS3 ]:Hide()
         aGet[ _NIVAGAS1 ]:Hide()
         aGet[ _NIVAGAS2 ]:Hide()
         aGet[ _NIVAGAS3 ]:Hide()
         aGet[ _NREGAS1  ]:Hide()
         aGet[ _NREGAS2  ]:Hide()
         aGet[ _NREGAS3  ]:Hide()

      end if

   end if

   /*
   Hace que salte la incidencia al entrar en el documento----------------------
   */

   if !empty( dbfTmpInc )

      while !( dbfTmpInc )->( Eof() )
         if ( dbfTmpInc )->lAviso .and. !( dbfTmpInc )->lListo
            MsgInfo( Trim( ( dbfTmpInc )->mDesInc ), "¡Incidencia!" )
         end if
         ( dbfTmpInc )->( dbSkip() )
      end while

      ( dbfTmpInc )->( dbGoTop() )

   end if

   oBrw:Refresh()

return nil

//----------------------------------------------------------------------------//

STATIC FUNCTION ValidaMedicion( aTmp, aGet )

   local cNewUndMed  := aGet[ _CUNIDAD ]:VarGet

   /*
   Cargamos el codigo de las unidades---------------------------------
   */

   if ( empty( cOldUndMed ) .or. cOldUndMed != cNewUndMed )

      if D():GetObject( "UnidadMedicion", nView ):oDbf:Seek( aTmp[ _CUNIDAD ] )

         if D():GetObject( "UnidadMedicion", nView ):oDbf:nDimension >= 1 .and. !empty( D():GetObject( "UnidadMedicion", nView ):oDbf:cTextoDim1 )
            if !empty( aGet[ ( D():FacturasRectificativasProveedoresLineas( nView ) )->( fieldpos( "nMedUno" ) ) ] )
               aGet[ ( D():FacturasRectificativasProveedoresLineas( nView ) )->( fieldpos( "nMedUno" ) ) ]:oSay:SetText( D():GetObject( "UnidadMedicion", nView ):oDbf:cTextoDim1 )
               aGet[ ( D():FacturasRectificativasProveedoresLineas( nView ) )->( fieldpos( "nMedUno" ) ) ]:cText( ( D():Articulos( nView ) )->nLngArt )
               aGet[ ( D():FacturasRectificativasProveedoresLineas( nView ) )->( fieldpos( "nMedUno" ) ) ]:Show()
            else
               aTmp[ ( D():FacturasRectificativasProveedoresLineas( nView ) )->( fieldpos( "nMedUno" ) ) ]  := ( D():Articulos( nView ) )->nLngArt
            end if
         else
            if !empty( aGet[ ( D():FacturasRectificativasProveedoresLineas( nView ) )->( fieldpos( "nMedUno" ) ) ] )
               aGet[ ( D():FacturasRectificativasProveedoresLineas( nView ) )->( fieldpos( "nMedUno" ) ) ]:cText( 0 )
               aGet[ ( D():FacturasRectificativasProveedoresLineas( nView ) )->( fieldpos( "nMedUno" ) ) ]:Hide()
            else
               aTmp[ ( D():FacturasRectificativasProveedoresLineas( nView ) )->( fieldpos( "nMedUno" ) ) ]  := 0
            end if
         end if

         if D():GetObject( "UnidadMedicion", nView ):oDbf:nDimension >= 1 .and. !empty( D():GetObject( "UnidadMedicion", nView ):oDbf:cTextoDim2 )
            if !empty( aGet[ ( D():FacturasRectificativasProveedoresLineas( nView ) )->( fieldpos( "nMedDos" ) ) ] )
               aGet[ ( D():FacturasRectificativasProveedoresLineas( nView ) )->( fieldpos( "nMedDos" ) ) ]:oSay:SetText( D():GetObject( "UnidadMedicion", nView ):oDbf:cTextoDim2 )
               aGet[ ( D():FacturasRectificativasProveedoresLineas( nView ) )->( fieldpos( "nMedDos" ) ) ]:cText( ( D():Articulos( nView ) )->nAltArt )
               aGet[ ( D():FacturasRectificativasProveedoresLineas( nView ) )->( fieldpos( "nMedDos" ) ) ]:Show()
            else
               aTmp[ ( D():FacturasRectificativasProveedoresLineas( nView ) )->( fieldpos( "nMedDos" ) ) ]  := ( D():Articulos( nView ) )->nAltArt
            end if

         else
            if !empty( aGet[ ( D():FacturasRectificativasProveedoresLineas( nView ) )->( fieldpos( "nMedDos" ) ) ] )
               aGet[ ( D():FacturasRectificativasProveedoresLineas( nView ) )->( fieldpos( "nMedDos" ) ) ]:cText( 0 )
               aGet[ ( D():FacturasRectificativasProveedoresLineas( nView ) )->( fieldpos( "nMedDos" ) ) ]:Hide()
            else
                 aTmp[ ( D():FacturasRectificativasProveedoresLineas( nView ) )->( fieldpos( "nMedDos" ) ) ]  := 0
            end if
         end if

         if D():GetObject( "UnidadMedicion", nView ):oDbf:nDimension >= 1 .and. !empty( D():GetObject( "UnidadMedicion", nView ):oDbf:cTextoDim3 )
            if !empty( aGet[ ( D():FacturasRectificativasProveedoresLineas( nView ) )->( fieldpos( "nMedTre" ) ) ] )
               aGet[ ( D():FacturasRectificativasProveedoresLineas( nView ) )->( fieldpos( "nMedTre" ) ) ]:oSay:SetText( D():GetObject( "UnidadMedicion", nView ):oDbf:cTextoDim3 )
               aGet[ ( D():FacturasRectificativasProveedoresLineas( nView ) )->( fieldpos( "nMedTre" ) ) ]:cText( ( D():Articulos( nView ) ) ->nAncArt )
               aGet[ ( D():FacturasRectificativasProveedoresLineas( nView ) )->( fieldpos( "nMedTre" ) ) ]:Show()
            else
               aTmp[ ( D():FacturasRectificativasProveedoresLineas( nView ) )->( fieldpos( "nMedTre" ) ) ]  := ( D():Articulos( nView ) )->nAncArt
            end if
         else
            if !empty( aGet[ ( D():FacturasRectificativasProveedoresLineas( nView ) )->( fieldpos( "nMedTre" ) ) ] )
               aGet[ ( D():FacturasRectificativasProveedoresLineas( nView ) )->( fieldpos( "nMedTre" ) ) ]:cText( 0 )
               aGet[ ( D():FacturasRectificativasProveedoresLineas( nView ) )->( fieldpos( "nMedTre" ) ) ]:Hide()
            else
               aTmp[ ( D():FacturasRectificativasProveedoresLineas( nView ) )->( fieldpos( "nMedTre" ) ) ]  := 0
            end if
         end if

      else

         if !empty( aGet[ ( D():FacturasRectificativasProveedoresLineas( nView ) )->( fieldpos( "nMedUno" ) ) ] )
            aGet[ ( D():FacturasRectificativasProveedoresLineas( nView ) )->( fieldpos( "nMedUno" ) ) ]:Hide()
            aGet[ ( D():FacturasRectificativasProveedoresLineas( nView ) )->( fieldpos( "nMedUno" ) ) ]:cText( 0 )
         end if

         if !empty( aGet[ ( D():FacturasRectificativasProveedoresLineas( nView ) )->( fieldpos( "nMedDos" ) ) ] )
            aGet[ ( D():FacturasRectificativasProveedoresLineas( nView ) )->( fieldpos( "nMedDos" ) ) ]:Hide()
            aGet[ ( D():FacturasRectificativasProveedoresLineas( nView ) )->( fieldpos( "nMedDos" ) ) ]:cText( 0 )
         end if

         if !empty( aGet[ ( D():FacturasRectificativasProveedoresLineas( nView ) )->( fieldpos( "nMedTre" ) ) ] )
            aGet[ ( D():FacturasRectificativasProveedoresLineas( nView ) )->( fieldpos( "nMedTre" ) ) ]:Hide()
            aGet[ ( D():FacturasRectificativasProveedoresLineas( nView ) )->( fieldpos( "nMedTre" ) ) ]:cText( 0 )
         end if

      end if

      cOldUndMed := cNewUndMed

   end if

RETURN .t.

//---------------------------------------------------------------------------//

Static Function DataReport( oFr )

   /*
   Zona de datos------------------------------------------------------------
   */

   oFr:ClearDataSets()

   oFr:SetWorkArea(     "Facturas rectificativas", ( D():FacturasRectificativasProveedores( nView ) )->( Select() ), .f., { FR_RB_CURRENT, FR_RB_CURRENT, 0 } )
   oFr:SetFieldAliases( "Facturas rectificativas", cItemsToReport( aItmRctPrv() ) )

   oFr:SetWorkArea(     "Lineas de facturas rectificativas", ( D():FacturasRectificativasProveedoresLineas( nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Lineas de facturas rectificativas", cItemsToReport( aColRctPrv() ) )

   oFr:SetWorkArea(     "Incidencias de facturas rectificativas", ( D():FacturasRectificativasProveedoresIncidencias( nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Incidencias de facturas rectificativas", cItemsToReport( aIncRctPrv() ) )

   oFr:SetWorkArea(     "Documentos de facturas rectificativas", ( D():FacturasRectificativasProveedoresDocumentos( nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Documentos de facturas rectificativas", cItemsToReport( aFacPrvDoc() ) )

   oFr:SetWorkArea(     "Series de facturas rectificativas", ( D():FacturasRectificativasProveedoresSeries( nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Series de facturas rectificativas", cItemsToReport( aSerRctPrv() ) )

   oFr:SetWorkArea(     "Empresa", ( D():Empresa( nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Empresa", cItemsToReport( aItmEmp() ) )

   oFr:SetWorkArea(     "Proveedores", ( D():Proveedores( nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Proveedores", cItemsToReport( aItmPrv() ) )

   oFr:SetWorkArea(     "Almacenes", ( D():Almacen( nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Almacenes", cItemsToReport( aItmAlm() ) )

   oFr:SetWorkArea(     "Formas de pago", ( D():FormasPago( nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Formas de pago", cItemsToReport( aItmFPago() ) )

   oFr:SetWorkArea(     "Unidades de medición",  D():GetObject( "UnidadMedicion", nView ):Select() )
   oFr:SetFieldAliases( "Unidades de medición",  cObjectsToReport( D():GetObject( "UnidadMedicion", nView ):oDbf ) )

   oFr:SetWorkArea(     "Bancos", ( D():BancosProveedores( nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Bancos", cItemsToReport( aPrvBnc() ) )

   oFr:SetWorkArea(     "Impuestos especiales",  oNewImp:Select() )
   oFr:SetFieldAliases( "Impuestos especiales",  cObjectsToReport( oNewImp:oDbf ) )

   oFr:SetWorkArea(     "Centro de coste",  D():CentroCoste( nView ):Select() )
   oFr:SetFieldAliases( "Centro de coste",  cObjectsToReport( D():CentroCoste( nView ):oDbf ) )

   oFr:SetMasterDetail( "Facturas rectificativas", "Lineas de facturas rectificativas",      {|| ( D():FacturasRectificativasProveedores( nView ) )->cSerFac + Str( ( D():FacturasRectificativasProveedores( nView ) )->nNumFac ) + ( D():FacturasRectificativasProveedores( nView ) )->cSufFac } )
   oFr:SetMasterDetail( "Facturas rectificativas", "Incidencias de facturas rectificativas", {|| ( D():FacturasRectificativasProveedores( nView ) )->cSerFac + Str( ( D():FacturasRectificativasProveedores( nView ) )->nNumFac ) + ( D():FacturasRectificativasProveedores( nView ) )->cSufFac } )
   oFr:SetMasterDetail( "Facturas rectificativas", "Documentos de facturas rectificativas",  {|| ( D():FacturasRectificativasProveedores( nView ) )->cSerFac + Str( ( D():FacturasRectificativasProveedores( nView ) )->nNumFac ) + ( D():FacturasRectificativasProveedores( nView ) )->cSufFac } )
   oFr:SetMasterDetail( "Facturas rectificativas", "Series de facturas rectificativas",      {|| ( D():FacturasRectificativasProveedores( nView ) )->cSerFac + Str( ( D():FacturasRectificativasProveedores( nView ) )->nNumFac ) + ( D():FacturasRectificativasProveedores( nView ) )->cSufFac } )
   oFr:SetMasterDetail( "Facturas rectificativas", "Proveedores",                            {|| ( D():FacturasRectificativasProveedores( nView ) )->cCodPrv } )
   oFr:SetMasterDetail( "Facturas rectificativas", "Almacenes",                              {|| ( D():FacturasRectificativasProveedores( nView ) )->cCodAlm } )
   oFr:SetMasterDetail( "Facturas rectificativas", "Formas de pago",                         {|| ( D():FacturasRectificativasProveedores( nView ) )->cCodPago} )
   oFr:SetMasterDetail( "Facturas rectificativas", "Empresa",                                {|| cCodigoEmpresaEnUso() } )
   oFr:SetMasterDetail( "Facturas rectificativas", "Bancos",                                 {|| ( D():FacturasRectificativasProveedores( nView ) )->cCodPrv } )
   oFr:SetMasterDetail( "Facturas rectificativas", "Centro de coste",                        {|| ( D():FacturasRectificativasProveedores( nView ) )->cCtrCoste } )

   oFr:SetMasterDetail( "Lineas de facturas rectificativas", "Unidades de medición",         {|| ( D():FacturasRectificativasProveedoresLineas( nView ) )->cUnidad } )
   oFr:SetMasterDetail( "Lineas de facturas rectificativas", "Impuestos especiales",         {|| ( D():FacturasRectificativasProveedoresLineas( nView ) )->cCodImp } )

   oFr:SetResyncPair(   "Facturas rectificativas", "Lineas de facturas rectificativas" )
   oFr:SetResyncPair(   "Facturas rectificativas", "Incidencias de facturas rectificativas" )
   oFr:SetResyncPair(   "Facturas rectificativas", "Documentos de facturas rectificativas" )
   oFr:SetResyncPair(   "Facturas rectificativas", "Series de facturas rectificativas" )
   oFr:SetResyncPair(   "Facturas rectificativas", "Proveedores" )
   oFr:SetResyncPair(   "Facturas rectificativas", "Almacenes" )
   oFr:SetResyncPair(   "Facturas rectificativas", "Formas de pago" )
   oFr:SetResyncPair(   "Facturas rectificativas", "Bancos" )
   oFr:SetResyncPair(   "Facturas rectificativas", "Centro de coste" )

   oFr:SetResyncPair(   "Lineas de facturas rectificativas", "Unidades de medición" )
   oFr:SetResyncPair(   "Lineas de facturas rectificativas", "Impuestos especiales" )

Return nil

//---------------------------------------------------------------------------//

Static Function VariableReport( oFr )

   oFr:DeleteCategory(  "Facturas rectificativas" )
   oFr:DeleteCategory(  "Lineas de facturas rectificativas" )

   /*
   Creación de variables----------------------------------------------------
   */

   oFr:AddVariable(     "Facturas rectificativas",             "Total bruto",                         "GetHbVar('nTotBrt')" )
   oFr:AddVariable(     "Facturas rectificativas",             "Total factura",                       "GetHbVar('nTotFac')" )
   oFr:AddVariable(     "Facturas rectificativas",             "Total descuento",                     "GetHbVar('nTotDto')" )
   oFr:AddVariable(     "Facturas rectificativas",             "Total descuento pronto pago",         "GetHbVar('nTotDpp')" )
   oFr:AddVariable(     "Facturas rectificativas",             "Total primer descuento definible",    "GetHbVar('nTotDto')" )
   oFr:AddVariable(     "Facturas rectificativas",             "Total segundo descuento definible",   "GetHbVar('nTotDpp')" )
   oFr:AddVariable(     "Facturas rectificativas",             "Total neto",                          "GetHbVar('nTotNet')" )
   oFr:AddVariable(     "Facturas rectificativas",             "Total " + cImp(),                     "GetHbVar('nTotIva')" )
   oFr:AddVariable(     "Facturas rectificativas",             "Total RE",                            "GetHbVar('nTotReq')" )
   oFr:AddVariable(     "Facturas rectificativas",             "Total retenciones por IRPF",          "GetHbVar('nTotRet')" )
   oFr:AddVariable(     "Facturas rectificativas",             "Total impuestos",                     "GetHbVar('nTotImp')" )
   oFr:AddVariable(     "Facturas rectificativas",             "Total unidades",                      "GetHbVar('nTotUnd')" )
   oFr:AddVariable(     "Facturas rectificativas",             "Total impuestos especiales",          "GetHbVar('nTotIvm')" )
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
   oFr:AddVariable(     "Facturas rectificativas",             "Importe primer tipo " + cImp(),       "GetHbArrayVar('aIvaUno',5)" )
   oFr:AddVariable(     "Facturas rectificativas",             "Importe segundo tipo " + cImp(),      "GetHbArrayVar('aIvaDos',5)" )
   oFr:AddVariable(     "Facturas rectificativas",             "Importe tercer tipo " + cImp(),       "GetHbArrayVar('aIvaTre',5)" )
   oFr:AddVariable(     "Facturas rectificativas",             "Importe primer RE",                   "GetHbArrayVar('aIvaUno',6)" )
   oFr:AddVariable(     "Facturas rectificativas",             "Importe segundo RE",                  "GetHbArrayVar('aIvaDos',6)" )
   oFr:AddVariable(     "Facturas rectificativas",             "Importe tercer RE",                   "GetHbArrayVar('aIvaTre',6)" )

   oFr:AddVariable(     "Facturas rectificativas",             "Cuenta bancaria proveedor",           "CallHbFunc('cCtaRctPrv')" )

   oFr:AddVariable(     "Lineas de facturas rectificativas",   "Código del artículo con propiedades", "CallHbFunc('cPrpRctPrv')" )
   oFr:AddVariable(     "Lineas de facturas rectificativas",   "Detalle del artículo",                "CallHbFunc('cDesRctPrv')" )
   oFr:AddVariable(     "Lineas de facturas rectificativas",   "Detalle del artículo otro lenguaje",  "CallHbFunc('cDesRctPrvLeng')" )
   oFr:AddVariable(     "Lineas de facturas rectificativas",   "Total unidades artículo",             "CallHbFunc('nTotNRctPrv')" )
   oFr:AddVariable(     "Lineas de facturas rectificativas",   "Precio unitario de factura",          "CallHbFunc('nTotURctPrv')" )
   oFr:AddVariable(     "Lineas de facturas rectificativas",   "Total línea de factura",              "CallHbFunc('nTotLRctPrv')" )

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

Static Function EditarNumeroSerie( aTmp, nMode )

   with object ( TNumerosSerie() )

      :lCompras         := .t.
      :nMode            := nMode

      :cCodArt          := aTmp[ _CREF    ]
      :cCodAlm          := aTmp[ _CALMLIN ]
      :nNumLin          := aTmp[ _NNUMLIN ]

      :nTotalUnidades   := nTotNRctPrv( aTmp )

      :oStock           := oStock

      :uTmpSer          := dbfTmpSer

      :Resource()

   end with

Return ( nil )

//--------------------------------------------------------------------------//

Static Function OldEditarNumeroSerie( aTmp, nMode )

   local n        := 1
   local oDlg
   local oBrwSer
   local oProSer
   local nProSer
   local aNumSer
   local cPreFix  := Space( 18 )
   local oSerIni
   local nSerIni  := 0
   local oSerFin
   local nSerFin  := 0
   local oNumGen
   local nNumGen  := 0
   local nTotUnd

   DEFAULT nMode  := APPD_MODE

   nTotUnd        := Abs( nTotNRctPrv( aTmp ) )

   if nTotUnd == 0
      MsgStop( "No hay unidades para asignar números de serie." )
      Return ( nil )
   end if

   aNumSer        := Afill( Array( nTotUnd ), Space( 40 ) )

   if ( dbfTmpSer )->( dbSeek( Str( aTmp[ _NNUMLIN ], 4 ) + aTmp[ _CREF ] ) )
      while ( Str( ( dbfTmpSer )->nNumLin, 4 ) + ( dbfTmpSer )->cRef == Str( aTmp[ _NNUMLIN ], 4 ) + aTmp[ _CREF ] ) .and. !( dbfTmpSer )->( Eof() )
         if ( n <= nTotUnd )
            aNumSer[ n ]   := ( dbfTmpSer )->cNumSer
         end if
         ( dbfTmpSer )->( dbSkip() )
         n++
      end while
   end if

   DEFINE DIALOG oDlg RESOURCE "VtaNumSer"

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
         ACTION   ( GenNumSer( cPreFix, aNumSer, nSerIni, nNumGen, oBrwSer ) )

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
         :cHeader       := "N."
         :bStrData      := {|| Trans( oBrwSer:nArrayAt, "999999999" ) }
         :nWidth        := 60
         :nDataStrAlign := 1
         :nHeadStrAlign := 1
      end with

      with object ( oBrwSer:addCol() )
         :cHeader       := "Serie"
         :bEditValue    := {|| aNumSer[ oBrwSer:nArrayAt ] }
         :nWidth        := 240
         :nEditType     := 1
         :bOnPostEdit   := {|o,x| aNumSer[ oBrwSer:nArrayAt ] := x }
      end with

      oBrwSer:CreateFromResource( 150 )

      oProSer     := TApoloMeter():ReDefine( 240, { | u | if( pCount() == 0, nProSer, nProSer := u ) }, 10, oDlg, .f., , , .t., rgb( 255,255,255 ), , rgb( 128,255,0 ) )

      REDEFINE BUTTON ;
         ID       510 ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( SalvarNumeroSerie( aNumSer, aTmp, oProSer, nMode ), oDlg:End() )

      REDEFINE BUTTON ;
         ID       520 ;
         OF       oDlg ;
         ACTION   ( oDlg:End() )

      oDlg:AddFastKey( VK_F5, {|| SalvarNumeroSerie( aNumSer, aTmp, oProSer, nMode ), oDlg:End() } )

   ACTIVATE DIALOG oDlg CENTER

Return ( aNumSer )

//----------------------------------------------------------------------------//

Static Function SalvarNumeroSerie( aNumSer, aTmp, oProSer, nMode )

   local cNumSer
   local nTotUnd              := len( aNumSer )

   while ( ( dbfTmpSer )->( dbSeek( Str( aTmp[ _NNUMLIN ], 4 ) + aTmp[ _CREF ] ) ) ) .and. !( dbfTmpSer )->( Eof() )
      ( dbfTmpSer )->( dbDelete() )
   end while

   if !empty( oProSer )
      oProSer:SetTotal( nTotUnd )
   end if

   for each cNumSer in aNumSer

      ( dbfTmpSer )->( dbAppend() )
      ( dbfTmpSer )->cRef     := aTmp[ _CREF    ]
      ( dbfTmpSer )->nNumLin  := aTmp[ _NNUMLIN ]
      ( dbfTmpSer )->cAlmLin  := aTmp[ _CALMLIN ]
      ( dbfTmpSer )->cNumSer  := cNumSer

      if !empty( oProSer ) .and. ( Mod( hb_enumindex(), int( nTotUnd / 100 ) ) == 0 )
         oProSer:Set( hb_enumindex() )
      end if

   next

Return ( nil )

//----------------------------------------------------------------------------//

Static Function ImprimirSeriesFacturasRectificativasProveedores( nDevice, lExt )

   local aStatus
   local oPrinter   
   local cFormato 

   DEFAULT nDevice   := IS_PRINTER
   DEFAULT lExt      := .f.

   // Cremaos el dialogo-------------------------------------------------------

   oPrinter          := PrintSeries():New( nView ):SetCompras()

   // Establecemos sus valores-------------------------------------------------

   oPrinter:Serie(      ( D():FacturasRectificativasProveedores( nView ) )->cSerFac )
   oPrinter:Documento(  ( D():FacturasRectificativasProveedores( nView ) )->nNumFac )
   oPrinter:Sufijo(     ( D():FacturasRectificativasProveedores( nView ) )->cSufFac )

   if lExt

      oPrinter:oFechaInicio:cText( ( D():FacturasRectificativasProveedores( nView ) )->dFecFac )
      oPrinter:oFechaFin:cText( ( D():FacturasRectificativasProveedores( nView ) )->dFecFac )

   end if

   oPrinter:oFormatoDocumento:TypeDocumento( "TP" )   

   // Formato de documento-----------------------------------------------------

   cFormato          := cFormatoDocumento( ( D():FacturasRectificativasProveedores( nView ) )->cSerFac, "nRctPrv", D():Contadores( nView ) )
   if empty( cFormato )
      cFormato       := cFirstDoc( "TP", D():Documentos( nView ) )
   end if
   oPrinter:oFormatoDocumento:cText( cFormato )

   // Codeblocks para que trabaje----------------------------------------------

   aStatus           := D():GetInitStatus( "RctPrvT", nView )

   oPrinter:bInit    := {||   ( D():FacturasRectificativasProveedores( nView ) )->( dbSeek( oPrinter:DocumentoInicio(), .t. ) ) }

   oPrinter:bWhile   := {||   oPrinter:InRangeDocumento( D():FacturasRectificativasProveedoresId( nView ) )                  .and. ;
                              ( D():FacturasRectificativasProveedores( nView ) )->( !eof() ) }

   oPrinter:bFor     := {||   oPrinter:InRangeFecha( ( D():FacturasRectificativasProveedores( nView ) )->dFecFac )           .and. ;
                              oPrinter:InRangeProveedor( ( D():FacturasRectificativasProveedores( nView ) )->cCodPrv )         .and. ;
                              oPrinter:InRangeGrupoProveedor( RetFld( ( D():FacturasRectificativasProveedores( nView ) )->cCodPrv, D():Proveedores( nView ), "cCodGrp" ) ) }

   oPrinter:bSkip    := {||   ( D():FacturasRectificativasProveedores( nView ) )->( dbSkip() ) }

   oPrinter:bAction  := {||   GenRctPrv( nDevice, "Imprimiendo documento : " + D():FacturasRectificativasProveedoresId( nView ), oPrinter:oFormatoDocumento:uGetValue, oPrinter:oImpresora:uGetValue, oPrinter:oCopias:uGetValue ) }

   oPrinter:bStart   := {||   if( lExt, oPrinter:DisableRange(), ) }

   // Abrimos el dialogo-------------------------------------------------------

   oPrinter:Resource():End()

   // Restore -----------------------------------------------------------------

   D():SetStatus( "RctPrvT", nView, aStatus )
   
   if !empty( oWndBrw )
      oWndBrw:Refresh()
   end if   

Return .t.

//---------------------------------------------------------------------------//

/*
Devuelve el importe total de pagos de una factura de proveedores
*/

FUNCTION nPagRctPrv( cFactura, cFacPrvP, cDivRet, cDiv, lOnlyCob, aTmp )

   local nRec
   local nOrd
   local nRinDiv
   local cCodDiv
   local nTotalPagado   := 0

   DEFAULT cFacPrvP     := D():FacturasProveedoresPagos( nView )
   DEFAULT cDivRet      := cDivEmp()
   DEFAULT lOnlyCob     := .t.

   nRinDiv              := nRinDiv( cDivRet, cDiv )

   /*
   Si nos pasan la divisa tomamos el valor de la misma-------------------------
   */

   nRec                    := ( cFacPrvP )->( Recno() )

   if !empty( aTmp )

      cCodDiv              := ( cFacPrvP )->cDivPgo

      ( cFacPrvP )->( dbGoTop() )
      while !( cFacPrvP )->( Eof() )

         if ( lOnlyCob .and. ( cFacPrvP )->lCobrado .and. !( cFacPrvP )->lDevuelto ) .or. ( !lOnlyCob .and. !( cFacPrvP )->lDevuelto )

            nTotalPagado   += ( cFacPrvP )->nImporte

         end if

         ( cFacPrvP )->( dbSkip() )

      end while

      ( cFacPrvP )->( dbGoTo( nRec ) )

   else

      nOrd                 := ( cFacPrvP )->( OrdSetFocus( "rNumFac" ) )

      if ( cFacPrvP )->( dbSeek( cFactura, .t. ) )

         cCodDiv           := ( cFacPrvP )->cDivPgo

         while ( ( cFacPrvP )->cSerFac + Str( ( cFacPrvP )->nNumFac ) + ( cFacPrvP )->cSufFac = cFactura )

            if ( lOnlyCob .and. ( cFacPrvP )->lCobrado .and. !( cFacPrvP )->lDevuelto ) .or. ( !lOnlyCob .and. !( cFacPrvP )->lDevuelto )

               nTotalPagado   += ( cFacPrvP )->nImporte

            end if

            ( cFacPrvP )->( dbSkip() )

         end while

      end if

      ( cFacPrvP )->( OrdSetFocus( nOrd ) )

   end if

   ( cFacPrvP )->( dbGoTo( nRec ) )

   if cDivRet != nil .and. cCodDiv != cDivRet
      nTotalPagado   := nCnv2Div( nTotalPagado, cCodDiv, cDivRet )
   else
      nTotalPagado   := Round( nTotalPagado, nRinDiv )
   end if

RETURN ( nTotalPagado )

//---------------------------------------------------------------------------//

FUNCTION ChkPagRctPrv( cRctPrvT, cRctPrvP )

   local nBitmap

   do case
   case ( cRctPrvT )->lLiquidada
      nBitmap  := 1
   case lRecibosPagados( cRctPrvT, cRctPrvP )
      nBitmap  := 2
   otherwise
      nBitmap  := 3
   end case

RETURN nBitmap

//---------------------------------------------------------------------------//
/*
Comprueba si una factura esta liquidada
*/

FUNCTION ChkLqdRctPrv( aTmp, cRctPrvT, cRctPrvL, cRctPrvP, cIva, cDiv )

   local cFactura
   local nPagFacPrv
   local nTotal
   local cDivFac

   IF aTmp != NIL
      cFactura := aTmp[ _CSERFAC ] + Str( aTmp[ _NNUMFAC ] ) + aTmp[ _CSUFFAC ]
      cDivFac  := aTmp[ _CDIVFAC ]
   ELSE
      cFactura := (cRctPrvT)->CSERFAC + Str( (cRctPrvT)->NNUMFAC ) + (cRctPrvT)->CSUFFAC
      cDivFac  := (cRctPrvT)->CDIVFAC
   END IF

   nPagFacPrv  := abs( nPagRctPrv( cFactura, cRctPrvP, cDivFac, cDiv ) )
   nTotal      := abs( nTotRctPrv( cFactura, cRctPrvT, cRctPrvL, cIva, cDiv, cRctPrvP, nil, nil, .f. ) )

   if aTmp != NIL

      if nPagFacPrv == nTotal
         aTmp[ _LLIQUIDADA ] := .t.
      elseif nPagFacPrv > nTotal
         // msgStop( "Importe cobrado supera al total de la factura", "Revise cobros" )
         aTmp[ _LLIQUIDADA ] := .t.
      else
         aTmp[ _LLIQUIDADA ] := .f.
      end if

   else

      if dbLock( cRctPrvT )
         if nPagFacPrv == nTotal
            ( cRctPrvT )->lLiquidada := .t.
         elseif  nPagFacPrv > nTotal
            // msgStop( "Importe cobrado supera al total de la factura", "Revise cobros" )
            ( cRctPrvT )->lLiquidada := .t.
         else
            ( cRctPrvT )->lliquidada := .f.
         end if
         ( cRctPrvT )->( dbRUnLock() )
      end if

   END IF

RETURN NIL

//---------------------------------------------------------------------------//

FUNCTION nNetURctPrv( uFacPrvL, uFacPrvT, nDec, nRec, nVdv, cPinDiv )

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

   nCalculo       := nTotURctPrv( uFacPrvL, nDec, nVdv )

   if ValType( uFacPrvL ) == "A"
      nDtoLin     := uFacPrvL[ _NDTOLIN ]
      nDtoPrm     := uFacPrvL[ _NDTOPRM ]
   else
      nDtoLin     := ( uFacPrvL )->nDtoLin
      nDtoPrm     := ( uFacPrvL )->nDtoPrm
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

   if ValType( uFacPrvT ) == "A"
      nDtoEsp     := uFacPrvT[ _NDTOESP ]
      nDtoPP      := uFacPrvT[ _NDPP    ]
      nDtoUno     := uFacPrvT[ _NDTOUNO ]
      nDtoDos     := uFacPrvT[ _NDTODOS ]
      nPorte      := uFacPrvT[ _NPORTES ]
   else
      nDtoEsp     := (uFacPrvT)->NDTOESP
      nDtoPP      := (uFacPrvT)->NDPP
      nDtoUno     := (uFacPrvT)->NDTOUNO
      nDtoDos     := (uFacPrvT)->NDTODOS
      nPorte      := (uFacPrvT)->NPORTES
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

FUNCTION nImpURctPrv( uFacPrvT, cRctPrvL, nDec, nVdv, lIva, cPouDiv )

   local nCalculo

   DEFAULT nDec   := 0
   DEFAULT nVdv   := 1
   DEFAULT lIva   := .f.

   nCalculo       := nTotURctPrv( cRctPrvL, nDec, nVdv )

   if ValType( uFacPrvT ) == "A"
      nCalculo    -= Round( nCalculo * uFacPrvT[ _NDTOESP ]  / 100, nDec )
      nCalculo    -= Round( nCalculo * uFacPrvT[ _NDPP    ]  / 100, nDec )
      nCalculo    -= Round( nCalculo * uFacPrvT[ _NDTOUNO ]  / 100, nDec )
      nCalculo    -= Round( nCalculo * uFacPrvT[ _NDTODOS ]  / 100, nDec )
   else
      nCalculo    -= Round( nCalculo * ( uFacPrvT )->nDtoEsp / 100, nDec )
      nCalculo    -= Round( nCalculo * ( uFacPrvT )->nDpp    / 100, nDec )
      nCalculo    -= Round( nCalculo * ( uFacPrvT )->nDtoUno / 100, nDec )
      nCalculo    -= Round( nCalculo * ( uFacPrvT )->nDtoDos / 100, nDec )
   end if

   if lIva .and. ( cRctPrvL )->nIva != 0
      nCalculo    += nCalculo * ( cRctPrvL )->nIva / 100
   end if

RETURN ( if( cPouDiv != nil, Trans( nCalculo, cPouDiv ), nCalculo ) )

//---------------------------------------------------------------------------//

FUNCTION nImpLRctPrv( uFacPrvT, cRctPrvL, nDec, nRou, nVdv, lIva, cPouDiv )

   local nCalculo

   DEFAULT nDec   := 0
   DEFAULT nRou   := 0
   DEFAULT nVdv   := 1
   DEFAULT lIva   := .f.

   nCalculo       := nTotLRctPrv( cRctPrvL, nDec, nRou, nVdv )

   if ValType( uFacPrvT ) == "A"
      nCalculo    -= Round( nCalculo * uFacPrvT[ _NDTOESP ]  / 100, nRou )
      nCalculo    -= Round( nCalculo * uFacPrvT[ _NDPP    ]  / 100, nRou )
      nCalculo    -= Round( nCalculo * uFacPrvT[ _NDTOUNO ]  / 100, nRou )
      nCalculo    -= Round( nCalculo * uFacPrvT[ _NDTODOS ]  / 100, nRou )
   else
      nCalculo    -= Round( nCalculo * ( uFacPrvT )->nDtoEsp / 100, nRou )
      nCalculo    -= Round( nCalculo * ( uFacPrvT )->nDpp    / 100, nRou )
      nCalculo    -= Round( nCalculo * ( uFacPrvT )->nDtoUno / 100, nRou )
      nCalculo    -= Round( nCalculo * ( uFacPrvT )->nDtoDos / 100, nRou )
   end if

   if lIva .and. ( cRctPrvL )->nIva != 0
      nCalculo    += nCalculo * ( cRctPrvL )->nIva / 100
   end if

RETURN ( if( cPouDiv != nil, Trans( nCalculo, cPouDiv ), nCalculo ) )

//---------------------------------------------------------------------------//

FUNCTION nTotFRctPrv( cRctPrvL, nDec, nRou, nVdv, cPorDiv )

   local nCalculo := 0

   nCalculo       += nTotLRctPrv( cRctPrvL, nDec, nRou, nVdv )
   nCalculo       += nIvaLRctPrv( cRctPrvL, nDec, nRou, nVdv )

return ( if( cPorDiv != nil, Trans( nCalculo, cPorDiv ), nCalculo ) )

//---------------------------------------------------------------------------//

FUNCTION nTotRctPrv( cFactura, cFacPrvT, cFacPrvL, cIva, cDiv, cFacPrvP, aTmp, cDivRet, lPic )

   local bCondition
   local nTotalArt
   local lRecargo
   local dFecFac
   local nDtoEsp
   local nDtoPP
   local nDtoUno
   local nDtoDos
   local nPorte
   local nPctRet
   local nRecno
   local cCodDiv
   local cCodPgo
   local nRegIva
   local lFacGas     := .f.
   local aTotalUno   := { 0, 0, 0 }
   local aTotalDos   := { 0, 0, 0 }
   local aTotalDto   := { 0, 0, 0 }
   local aTotalDPP   := { 0, 0, 0 }
   local aNetGas     := { 0, 0, 0 }
   local aPIvGas     := { 0, 0, 0 }
   local aPReGas     := { 0, 0, 0 }
   local nImpuestoEspecial

   DEFAULT cFacPrvT  := D():FacturasRectificativasProveedores( nView )
   DEFAULT cFacPrvL  := D():FacturasRectificativasProveedoresLineas( nView )
   DEFAULT cFacPrvP  := D():FacturasProveedoresPagos( nView )
   DEFAULT cIva      := D():TiposIva( nView )
   DEFAULT cDiv      := D():Divisas( nView )
   DEFAULT cFactura  := ( cFacPrvT )->cSerFac + Str( ( cFacPrvT )->nNumFac ) + ( cFacPrvT )->cSufFac
   DEFAULT lPic      := .f.

   initPublics()

   nRecno            := ( cFacPrvL )->( recno() )

   if aTmp != nil
      dFecFac        := aTmp[ _DFECFAC ]
      lRecargo       := aTmp[ _LRECARGO]
      nDtoEsp        := aTmp[ _NDTOESP ]
      nDtoPP         := aTmp[ _NDPP    ]
      nDtoUno        := aTmp[ _NDTOUNO ]
      nDtoDos        := aTmp[ _NDTODOS ]
      nPorte         := aTmp[ _NPORTES ]
      cCodDiv        := aTmp[ _CDIVFAC ]
      cCodPgo        := aTmp[ _CCODPAGO]
      nTipRet        := aTmp[ _NTIPRET ]
      nPctRet        := aTmp[ _NPCTRET ]
      nRegIva        := aTmp[ _NREGIVA ]
      lFacGas        := aTmp[ _LFACGAS ]
      aNetGas        := { aTmp[ _NNETGAS1 ], aTmp[ _NNETGAS2 ], aTmp[ _NNETGAS3 ] }
      aPIvGas        := { aTmp[ _NIVAGAS1 ], aTmp[ _NIVAGAS2 ], aTmp[ _NIVAGAS3 ] }
      aPReGas        := { aTmp[ _NREGAS1  ], aTmp[ _NREGAS2  ], aTmp[ _NREGAS3  ] }
      bCondition     := {|| ( cFacPrvL )->( !eof() ) }
      ( cFacPrvL )->( dbGoTop() )
   else
      dFecFac        := ( cFacPrvT )->dFecFac
      lRecargo       := ( cFacPrvT )->lRecargo
      nDtoEsp        := ( cFacPrvT )->nDtoEsp
      nDtoPP         := ( cFacPrvT )->nDpp
      nDtoUno        := ( cFacPrvT )->nDtoUno
      nDtoDos        := ( cFacPrvT )->nDtoDos
      nPorte         := ( cFacPrvT )->nPortes
      cCodDiv        := ( cFacPrvT )->cDivFac
      cCodPgo        := ( cFacPrvT )->cCodPago
      nTipRet        := ( cFacPrvT )->nTipRet
      nPctRet        := ( cFacPrvT )->nPctRet
      nRegIva        := ( cFacPrvT )->nRegIva
      lFacGas        := ( cFacPrvT )->lFacGas
      aNetGas        := { ( cFacPrvT )->nNetGas1, ( cFacPrvT )->nNetGas2, ( cFacPrvT )->nNetGas3 }
      aPIvGas        := { ( cFacPrvT )->nIvaGas1, ( cFacPrvT )->nIvaGas2, ( cFacPrvT )->nIvaGas3 }
      aPReGas        := { ( cFacPrvT )->nReGas1,  ( cFacPrvT )->nReGas2,  ( cFacPrvT )->nReGas3  }
      bCondition     := {|| ( cFacPrvL )->cSerFac + Str( ( cFacPrvL )->nNumFac ) + ( cFacPrvL )->cSufFac == cFactura .AND. ( cFacPrvL )->( !eof() ) }
      ( cFacPrvL )->( dbSeek( cFactura ) )
   end if

   /*
   Cargamos los pictures dependiendo de la moneda
   */

   cPinDiv           := cPinDiv( cCodDiv, cDiv )
   cPirDiv           := cPirDiv( cCodDiv, cDiv )
   nDinDiv           := nDinDiv( cCodDiv, cDiv )
   nRinDiv           := nRinDiv( cCodDiv, cDiv )

   if !lFacGas

      while Eval( bCondition )

         if lValLine( cFacPrvL )

            nTotalArt            := nTotLRctPrv( cFacPrvL, nDinDiv, nRinDiv )
            nImpuestoEspecial    := nTotIFacPrv( cFacPrvL, nDinDiv, nRinDiv )

            if nTotalArt != 0

               if ( cFacPrvL )->lGasSup
                  nTotSup        += nTotalArt
               end if

               /*
               Estudio de impuestos
               */

               do case
               case _NPCTIVA1 == NIL .OR. _NPCTIVA1 == ( cFacPrvL )->NIVA
                  _NPCTIVA1   := (cFacPrvL)->nIva
                  _NPCTREQ1   := (cFacPrvL)->nReq
                  _NBRTIVA1   += nTotalArt
                  _NIVMIVA1   += nImpuestoEspecial

               case _NPCTIVA2 == NIL .OR. _NPCTIVA2 == ( cFacPrvL )->NIVA
                  _NPCTIVA2   := (cFacPrvL)->nIva
                  _NPCTREQ2   := (cFacPrvL)->nReq
                  _NBRTIVA2   += nTotalArt
                  _NIVMIVA2   += nImpuestoEspecial

               case _NPCTIVA3 == NIL .OR. _NPCTIVA3 == ( cFacPrvL )->NIVA
                  _NPCTIVA3   := (cFacPrvL)->nIva
                  _NPCTREQ3   := (cFacPrvL)->nReq
                  _NBRTIVA3   += nTotalArt
                  _NIVMIVA3   += nImpuestoEspecial

               end case

            end if

            nTotUnd           += nTotNRctPrv( cFacPrvL )

         end if

         ( cFacPrvL )->( dbSkip() )

      end while

      ( cFacPrvL )->( dbGoto( nRecno ) )

   else

      _NBRTIVA1   := aNetGas[1]
      _NPCTIVA1   := aPIvGas[1]
      _NPCTREQ1   := aPReGas[1]

      _NBRTIVA2   := aNetGas[2]
      _NPCTIVA2   := aPIvGas[2]
      _NPCTREQ2   := aPReGas[2]

      _NBRTIVA3   := aNetGas[3]
      _NPCTIVA3   := aPIvGas[3]
      _NPCTREQ3   := aPReGas[3]

   end if

   /*
   Ordenamos los impuestosS de menor a mayor
   */

   aTotIva              := aSort( aTotIva,,, {|x,y| abs( x[1] ) > abs( y[1] ) } )

   _NBASIVA1            := Round( _NBRTIVA1, nRinDiv )
   _NBASIVA2            := Round( _NBRTIVA2, nRinDiv )
   _NBASIVA3            := Round( _NBRTIVA3, nRinDiv )

   nTotBrt              := _NBASIVA1 + _NBASIVA2 + _NBASIVA3

   /*
   Portes de la Factura
   */

   nTotBrt              += nPorte

   /*
   Descuentos de la Facturas
   */

   if !lFacGas

      IF nDtoEsp != 0

         aTotalDto[1]   := Round( _NBASIVA1 * nDtoEsp / 100, nRinDiv )
         aTotalDto[2]   := Round( _NBASIVA2 * nDtoEsp / 100, nRinDiv )
         aTotalDto[3]   := Round( _NBASIVA3 * nDtoEsp / 100, nRinDiv )

         nTotDto      := aTotalDto[1] + aTotalDto[2] + aTotalDto[3]

         _NBASIVA1      -= aTotalDto[1]
         _NBASIVA2      -= aTotalDto[2]
         _NBASIVA3      -= aTotalDto[3]

      END IF

      IF nDtoPP != 0

         aTotalDPP[1]   := Round( _NBASIVA1 * nDtoPP / 100, nRinDiv )
         aTotalDPP[2]   := Round( _NBASIVA2 * nDtoPP / 100, nRinDiv )
         aTotalDPP[3]   := Round( _NBASIVA3 * nDtoPP / 100, nRinDiv )

         nTotDPP      := aTotalDPP[1] + aTotalDPP[2] + aTotalDPP[3]

         _NBASIVA1      -= aTotalDPP[1]
         _NBASIVA2      -= aTotalDPP[2]
         _NBASIVA3      -= aTotalDPP[3]

      END IF

      IF nDtoUno != 0

         aTotalUno[1]   := Round( _NBASIVA1 * nDtoUno / 100, nRinDiv )
         aTotalUno[2]   := Round( _NBASIVA2 * nDtoUno / 100, nRinDiv )
         aTotalUno[3]   := Round( _NBASIVA3 * nDtoUno / 100, nRinDiv )

         nTotUno        := aTotalUno[1] + aTotalUno[2] + aTotalUno[3]

         _NBASIVA1      -= aTotalUno[1]
         _NBASIVA2      -= aTotalUno[2]
         _NBASIVA3      -= aTotalUno[3]

      END IF

      IF nDtoDos != 0

         aTotalDos[1]   := Round( _NBASIVA1 * nDtoDos / 100, nRinDiv )
         aTotalDos[2]   := Round( _NBASIVA2 * nDtoDos / 100, nRinDiv )
         aTotalDos[3]   := Round( _NBASIVA3 * nDtoDos / 100, nRinDiv )

         nTotDos        := aTotalDos[1] + aTotalDos[2] + aTotalDos[3]

         _NBASIVA1      -= aTotalDos[1]
         _NBASIVA2      -= aTotalDos[2]
         _NBASIVA3      -= aTotalDos[3]

      END IF

   end if

   if uFieldEmpresa( "lIvaImpEsp" )
      _NBASIVA1      += _NIVMIVA1
      _NBASIVA2      += _NIVMIVA2
      _NBASIVA3      += _NIVMIVA3
   end if

   // Total neto

   nTotNet           := Round( _NBASIVA1 + _NBASIVA2 + _NBASIVA3, nRinDiv )

   /*
   Calculos de impuestos
   */

   if nRegIva <= 1

      _NIMPIVA1         := if( _NPCTIVA1 != NIL, Round( _NBASIVA1 * _NPCTIVA1 / 100, nRinDiv ), 0 )
      _NIMPIVA2         := if( _NPCTIVA2 != NIL, Round( _NBASIVA2 * _NPCTIVA2 / 100, nRinDiv ), 0 )
      _NIMPIVA3         := if( _NPCTIVA3 != NIL, Round( _NBASIVA3 * _NPCTIVA3 / 100, nRinDiv ), 0 )

      /*
      Calculo de recargo
      */

      if lRecargo
         _NIMPREQ1   := if( _NPCTIVA1 != NIL, Round( _NBASIVA1 * _NPCTREQ1 / 100, nRinDiv ), 0 )
         _NIMPREQ2   := if( _NPCTIVA2 != NIL, Round( _NBASIVA2 * _NPCTREQ2 / 100, nRinDiv ), 0 )
         _NIMPREQ3   := if( _NPCTIVA3 != NIL, Round( _NBASIVA3 * _NPCTREQ3 / 100, nRinDiv ), 0 )
      end if

   end if

   // Total impuestos

   nTotIva           := Round( _NIMPIVA1 + _NIMPIVA2 + _NIMPIVA3, nRinDiv )

   // Total de R.E.

   nTotReq           := Round( _NIMPREQ1 + _NIMPREQ2 + _NIMPREQ3, nRinDiv )

   // Total impuesto

   nTotIvm           := Round( _NIVMIVA1 + _NIVMIVA2 + _NIVMIVA3, nRinDiv )

   // Total de impuestos

   nTotImp           := Round( nTotIva + nTotReq , nRinDiv )
   if !uFieldEmpresa( "lIvaImpEsp" )
      nTotImp        += Round( nTotIvm , nRinDiv )
   end if 

   // Total retenciones

   if isNum( nTipRet )
      if nTipRet <= 1
         nTotRet     := Round( ( nTotNet - nTotSup ) * nPctRet / 100, nRinDiv )
      else
         nTotRet     := Round( ( nTotNet - nTotSup + nTotIva ) * nPctRet / 100, nRinDiv )
      end if
   end if

   // Total facturas

   nTotFac           := Round( nTotNet + nTotImp - nTotRet, nRinDiv )

   // Calculo de pagos

   if cFacPrvP != nil
      nPagFac        := nPagRctPrv( cFactura, cFacPrvP, cCodDiv, cDiv, .t., aTmp )
   end if

   aTotIva           := aSort( aTotIva,,, {|x,y| abs( x[1] ) > abs( y[1] ) } )

   // Solicitan una divisa distinta a la q se hizo originalmente la factura

   if cDivRet != nil .and. cDivRet != cCodDiv
      nTotNet     := nCnv2Div( nTotNet, cCodDiv, cDivRet )
      nTotIva     := nCnv2Div( nTotIva, cCodDiv, cDivRet )
      nTotReq     := nCnv2Div( nTotReq, cCodDiv, cDivRet )
      nTotFac     := nCnv2Div( nTotFac, cCodDiv, cDivRet )
      cPirDiv     := cPirDiv( cDivRet, cDiv )
   end if

RETURN ( if( lPic, Trans( nTotFac, cPirDiv ), nTotFac ) )

//--------------------------------------------------------------------------//

function nVtaRctPrv( cCodPrv, dDesde, dHasta, cRctPrvT, cRctPrvL, cIva, cDiv, nYear )

   local nCon     := 0
   local nRec     := ( cRctPrvT )->( Recno() )

   /*
   Facturas a Clientes -------------------------------------------------------
   */

   if ( cRctPrvT )->( dbSeek( cCodPrv ) )

      while ( cRctPrvT )->cCodPrv == cCodPrv .and. !( cRctPrvT )->( Eof() )

         if ( dDesde == nil .or. ( cRctPrvT )->dFecFac >= dDesde )    .and.;
            ( dHasta == nil .or. ( cRctPrvT )->dFecFac <= dHasta )    .and.;
            ( nYear == nil .or. Year( ( cRctPrvT )->dFecFac ) == nYear )

            nCon  += nTotRctPrv( ( cRctPrvT )->cSerFac + Str( (cRctPrvT)->nNumFac ) + (cRctPrvT)->cSufFac, cRctPrvT, cRctPrvL, cIva, cDiv, nil, nil, cDivEmp(), .f. )

         end if

         ( cRctPrvT )->( dbSkip() )

      end while

   end if

   ( cRctPrvT )->( dbGoTo( nRec ) )

return nCon

//----------------------------------------------------------------------------//
//
// Devuelve el total de pagos en Facturas de un clientes determinado
//

function nCobRctPrv( cCodPrv, dDesde, dHasta, cRctPrvT, cRctPrvP, cIva, cDiv, lOnlyCob, nYear )

   local nCob        := 0
   local nOrd        := ( cRctPrvT )->( OrdSetFocus( "cCodPrv" ) )
   local nRec        := ( cRctPrvT )->( Recno() )

   DEFAULT lOnlyCob  := .t.

   /*
   Facturas a Prventes -------------------------------------------------------
   */

   if ( cRctPrvT )->( dbSeek( cCodPrv ) )

      while ( cRctPrvT )->cCodPrv = cCodPrv .and. !( cRctPrvT )->( Eof() )

         if ( dDesde == nil .or. ( cRctPrvT )->DFECFAC >= dDesde ) .and.;
            ( dHasta == nil .or. ( cRctPrvT )->DFECFAC <= dHasta ) .and.;
            ( nYear == nil .or. Year( ( cRctPrvT )->dFecFac ) == nYear )

            nCob  += nPagRctPrv( ( cRctPrvT )->cSerFac + Str( (cRctPrvT)->nNumFac ) + (cRctPrvT)->cSufFac, cRctPrvP, cDivEmp(), cDiv, lOnlyCob )

         end if

         ( cRctPrvT )->( dbSkip() )

      end while

   end if

   ( cRctPrvT )->( OrdSetFocus( nOrd ) )
   ( cRctPrvT )->( dbGoTo( nRec ) )

return nCob

//----------------------------------------------------------------------------//

FUNCTION mkRctPrv( cPath, oMeter, cDriver )

   if oMeter != nil
      oMeter:cText   := "Generando Bases"
      sysrefresh()
   end if

   CreateFiles( cPath )

   rxRctPrv( cPath, oMeter, cDriver )

RETURN NIL

//---------------------------------------------------------------------------//

FUNCTION rxRctPrv( cPath, oMeter, cDriver )

   local cRctPrvT
   local cRctPrvL

   DEFAULT cPath     := cPatEmp()
   DEFAULT cDriver   := cDriver()

   if !lExistTable( cPath + "RctPrvT.Dbf" ) .OR. ;
      !lExistTable( cPath + "RctPrvL.Dbf" ) .OR. ;
      !lExistTable( cPath + "RctPrvI.Dbf" ) .OR. ;
      !lExistTable( cPath + "RctPrvD.Dbf" ) .OR. ;
      !lExistTable( cPath + "RctPrvS.Dbf" )
      CreateFiles( cPath )
   end if

   /*
   Eliminamos los indices
   */

   fEraseIndex( cPath + "RctPrvT.Cdx" )
   fEraseIndex( cPath + "RctPrvL.Cdx" )
   fEraseIndex( cPath + "RctPrvI.Cdx" )
   fEraseIndex( cPath + "RctPrvD.Cdx" )
   fEraseIndex( cPath + "RctPrvS.Cdx" )

   dbUseArea( .t., cDriver, cPath + "RctPrvT.DBF", cCheckArea( "FACPRVT", @cRctPrvT ), .f. )

   if !( cRctPrvT )->( neterr() )

      ( cRctPrvT )->( __dbPack() )

      ( cRctPrvT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cRctPrvT )->( ordCreate( cPath + "RctPrvT.CDX", "NNUMFAC", "CSERFAC + STR( NNUMFAC ) + CSUFFAC", {|| Field->CSERFAC + STR( Field->NNUMFAC ) + Field->CSUFFAC } ) )

      ( cRctPrvT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cRctPrvT )->( ordCreate( cPath + "RctPrvT.CDX", "DFECFAC", "DFECFAC", {|| Field->DFECFAC } ) )

      ( cRctPrvT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cRctPrvT )->( ordCreate( cPath + "RctPrvT.CDX", "CCODPRV", "CCODPRV", {|| Field->CCODPRV } ) )

      ( cRctPrvT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cRctPrvT )->( ordCreate( cPath + "RctPrvT.CDX", "CNOMPRV", "Upper( CNOMPRV )", {|| Upper( Field->CNOMPRV ) } ) )

      ( cRctPrvT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cRctPrvT )->( ordCreate( cPath + "RctPrvT.CDX", "cNumDoc", "Upper( cNumDoc )", {|| Upper( Field->cNumDoc ) } ) )

      ( cRctPrvT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cRctPrvT )->( ordCreate( cPath + "RctPrvT.CDX", "cTurFac", "cTurFac + cSufFac + cCodCaj", {|| Field->CTURFAC + Field->CSUFFAC + Field->cCodCaj } ) )

      ( cRctPrvT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cRctPrvT )->( ordCreate( cPath + "RctPrvT.Cdx", "cCodUsr", "Field->cCodUsr + Dtos( Field->dFecChg ) + Field->cTimChg", {|| Field->cCodUsr + Dtos( Field->dFecChg ) + Field->cTimChg } ) )

      ( cRctPrvT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cRctPrvT )->( ordCreate( cPath + "RctPrvT.Cdx", "cCodPago", "cCodPago", {|| Field->cCodPago } ) )

      ( cRctPrvT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cRctPrvT )->( ordCreate( cPath + "RctPrvT.Cdx", "cNumFac", "cNumFac", {|| Field->cNumFac } ) )

      ( cRctPrvT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cRctPrvT )->( ordCreate( cPath + "RctPrvT.CDX", "iNumRct", "'04' + CSERFAC + STR( NNUMFAC ) + CSUFFAC", {|| '04' + Field->CSERFAC + STR( Field->NNUMFAC ) + Field->CSUFFAC } ) )

      ( cRctPrvT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cRctPrvT )->( ordCreate( cPath + "RctPrvT.CDX", "DDESFEC", "DFECFAC", {|| Field->DFECFAC } ) )

      ( cRctPrvT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cRctPrvT )->( ordCreate( cPath + "RctPrvT.CDX", "lSndDoc", "lSndDoc", {|| Field->lSndDoc } ) )

      ( cRctPrvT )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de facturas rectificativas de proveedores" )
   end if

   /*
   Nuevo Area------------------------------------------------------------------
   */

   dbUseArea( .t., cDriver, cPath + "RctPrvL.DBF", cCheckArea( "FACPRVL", @dbfRctPrvL ), .f. )
   if !( dbfRctPrvL )->( neterr() )
      ( dbfRctPrvL )->( __dbPack() )

      ( dbfRctPrvL )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfRctPrvL )->( ordCreate( cPath + "RctPrvL.Cdx", "NNUMFAC", "CSERFAC + STR( NNUMFAC ) + CSUFFAC", {|| Field->CSERFAC + STR( Field->NNUMFAC ) + Field->CSUFFAC } ) )

      ( dbfRctPrvL )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfRctPrvL )->( ordCreate( cPath + "RctPrvL.Cdx", "cRef", "cRef + cValPr1 + cValPr2", {|| Field->cRef + Field->cValPr1 + Field->cValPr2 }, ) )

      ( dbfRctPrvL )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfRctPrvL )->( ordCreate( cPath + "RctPrvL.Cdx", "Lote", "cLote", {|| Field->cLote }, ) )

      ( dbfRctPrvL )->( ordCondSet( "nCtlStk < 2 .and. !Deleted()", {|| Field->nCtlStk < 2 .and. !Deleted()}, , , , , , , , , .t. ) )
      ( dbfRctPrvL )->( ordCreate( cPath + "RctPrvL.Cdx", "cStkFast", "cRef + cAlmLin + dtos( dFecFac ) + tFecFac", {|| Field->cRef + Field->cAlmLin + dtos( Field->dFecFac ) + Field->tFecFac } ) )

      ( dbfRctPrvL )->( ordCondSet( "nCtlStk < 2 .and. !Deleted()", {|| Field->nCtlStk < 2 .and. !Deleted()}, , , , , , , , , .t. ) )
      ( dbfRctPrvL )->( ordCreate( cPath + "RctPrvL.Cdx", "cStkFastOu", "cRef + cAlmOrigen + dtos( dFecFac ) + tFecFac", {|| Field->cRef + Field->cAlmOrigen + dtos( Field->dFecFac ) + Field->tFecFac } ) )

      ( dbfRctPrvL )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfRctPrvL )->( ordCreate( cPath + "RctPrvL.Cdx", "iNumRct", "'04' + CSERFAC + STR( NNUMFAC ) + CSUFFAC", {|| '04' + Field->CSERFAC + STR( Field->NNUMFAC ) + Field->CSUFFAC } ) )

      ( dbfRctPrvL )->( dbCloseArea() )

   else

      msgStop( "Imposible abrir en modo exclusivo la tabla de facturas rectificativas de proveedores" )

   end if

   dbUseArea( .t., cDriver, cPath + "RctPrvI.DBF", cCheckArea( "FacPrvI", @cRctPrvT ), .f. )
   if !( cRctPrvT )->( neterr() )
      ( cRctPrvT )->( __dbPack() )

      ( cRctPrvT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cRctPrvT )->( ordCreate( cPath + "RctPrvI.CDX", "nNumFac", "cSerFac + Str( nNumFac ) + cSufFac", {|| Field->cSerFac + STR( Field->nNumFac ) + Field->cSufFac } ) )

      ( cRctPrvT )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de facturas rectificativas de proveedores" )
   end if

   dbUseArea( .t., cDriver, cPath + "RctPrvD.DBF", cCheckArea( "FacPrvD", @cRctPrvT ), .f. )
   if !( cRctPrvT )->( neterr() )
      ( cRctPrvT )->( __dbPack() )

      ( cRctPrvT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cRctPrvT )->( ordCreate( cPath + "RctPrvD.CDX", "nNumFac", "cSerFac + STR( nNumFac ) + cSufFac", {|| Field->cSerFac + STR( Field->nNumFac ) + Field->cSufFac } ) )

      ( cRctPrvT )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de facturas rectificativas de proveedores" )
   end if

   dbUseArea( .t., cDriver, cPath + "RctPrvS.DBF", cCheckArea( "RctPrvS", @cRctPrvT ), .f. )
   if !( cRctPrvT )->( neterr() )
      ( cRctPrvT )->( __dbPack() )

      ( cRctPrvT )->( ordCondSet( "!Deleted()", {||!Deleted()}  ) )
      ( cRctPrvT )->( ordCreate( cPath + "RctPrvS.CDX", "nNumFac", "cSerFac + Str( nNumFac ) + cSufFac + Str( nNumLin )", {|| Field->cSerFac + Str( Field->nNumFac ) + Field->cSufFac + Str( Field->nNumLin ) } ) )

      ( cRctPrvT )->( ordCondSet( "!Deleted()", {||!Deleted()}  ) )
      ( cRctPrvT )->( ordCreate( cPath + "RctPrvS.CDX", "cRefSer", "cRef + cAlmLin + cNumSer", {|| Field->cRef + Field->cAlmLin + Field->cNumSer } ) )

      ( cRctPrvT )->( ordCondSet( "!Deleted()", {||!Deleted()}  ) )
      ( cRctPrvT )->( ordCreate( cPath + "RctPrvS.CDX", "cNumSer", "cNumSer", {|| Field->cNumSer } ) )

      ( cRctPrvT )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de numeros de series de facturas rectificativas de proveedores" )
   end if

RETURN NIL

//--------------------------------------------------------------------------//

Function aIncRctPrv()

   local aIncFacPrv  := {}

   aAdd( aIncFacPrv, { "cSerFac", "C",    1,  0, "Serie de factura" ,              "",                   "", "( cDbfCol )" } )
   aAdd( aIncFacPrv, { "nNumFac", "N",    9,  0, "Número de factura" ,             "'999999999'",        "", "( cDbfCol )" } )
   aAdd( aIncFacPrv, { "cSufFac", "C",    2,  0, "Sufijo de factura" ,             "",                   "", "( cDbfCol )" } )
   aAdd( aIncFacPrv, { "cCodTip", "C",    3,  0, "Tipo de incidencia" ,            "",                   "", "( cDbfCol )" } )
   aAdd( aIncFacPrv, { "dFecInc", "D",    8,  0, "Fecha de la incidencia" ,        "",                   "", "( cDbfCol )" } )
   aAdd( aIncFacPrv, { "mDesInc", "M",   10,  0, "Descripción de la incidencia" ,  "",                   "", "( cDbfCol )" } )
   aAdd( aIncFacPrv, { "lListo",  "L",    1,  0, "Lógico de listo" ,               "",                   "", "( cDbfCol )" } )
   aAdd( aIncFacPrv, { "lAviso",  "L",    1,  0, "Lógico de aviso" ,               "",                   "", "( cDbfCol )" } )

Return ( aIncFacPrv )

//---------------------------------------------------------------------------//

Function aRctPrvDoc()

   local aFacPrvDoc  := {}

   aAdd( aFacPrvDoc, { "cSerFac", "C",    1,  0, "Serie de facturas" ,               "",                   "", "( cDbfCol )" } )
   aAdd( aFacPrvDoc, { "nNumFac", "N",    9,  0, "Número de facturas" ,              "'999999999'",        "", "( cDbfCol )" } )
   aAdd( aFacPrvDoc, { "cSufFac", "C",    2,  0, "Sufijo de facturas" ,              "",                   "", "( cDbfCol )" } )
   aAdd( aFacPrvDoc, { "cNombre", "C",  250,  0, "Nombre del documento" ,            "",                   "", "( cDbfCol )" } )
   aAdd( aFacPrvDoc, { "cRuta",   "C",  250,  0, "Ruta del documento" ,              "",                   "", "( cDbfCol )" } )
   aAdd( aFacPrvDoc, { "mObsDoc", "M",   10,  0, "Observaciones del documento" ,     "",                   "", "( cDbfCol )" } )

Return ( aFacPrvDoc )

//---------------------------------------------------------------------------//

Function aSerRctPrv()

   local aColFacPrv  := {}

   aAdd( aColFacPrv,  { "cSerFac", "C",  1,   0, "",                                 "",                  "", "( cDbfCol )" } )
   aAdd( aColFacPrv,  { "nNumFac", "N",  9,   0, "",                                 "",                  "", "( cDbfCol )" } )
   aAdd( aColFacPrv,  { "cSufFac", "C",  2,   0, "",                                 "",                  "", "( cDbfCol )" } )
   aAdd( aColFacPrv,  { "nNumLin", "N",  4,   0, "Número de la línea",               "'9999'",            "", "( cDbfCol )" } )
   aAdd( aColFacPrv,  { "cRef",    "C", 18,   0, "Referencia del artículo",          "",                  "", "( cDbfCol )" } )
   aAdd( aColFacPrv,  { "cAlmLin", "C", 16,   0, "Código de almacen",                "",                  "", "( cDbfCol )" } )
   aAdd( aColFacPrv,  { "lUndNeg", "L",  1,   0, "Lógico de unidades en negativo",   "",                  "", "( cDbfCol )" } )
   aAdd( aColFacPrv,  { "cNumSer", "C", 30,   0, "Numero de serie",                  "",                  "", "( cDbfCol )" } )

Return ( aColFacPrv )

//---------------------------------------------------------------------------//

/*
Devuelve la fecha de una factura de proveedor
*/

FUNCTION dFecRctPrv( cFacPrv, cRctPrvT )

   local dFecFac  := Ctod("")

   IF (cRctPrvT)->( dbSeek( cFacPrv ) )
      dFecFac  := (cRctPrvT)->DFECFAC
   END IF

RETURN ( dFecFac )

//---------------------------------------------------------------------------//

/*
Devuelve la hora de una factura rectificativa de proveedor
*/

FUNCTION tFecRctPrv( cFacPrv, cRctPrvT )

   local tFecFac  := Replicate( "0", 6 )

   IF (cRctPrvT)->( dbSeek( cFacPrv ) )
      tFecFac  := (cRctPrvT)->TFECFAC
   END IF

RETURN ( tFecFac )

//----------------------------------------------------------------------------//
/*
Devuelve el codigo del Proveedor pasando un numero de factura
*/

FUNCTION cPrvRctPrv( cFacPrv, cRctPrvT )

   local cCodPrv  := ""

   IF (cRctPrvT)->( dbSeek( cFacPrv ) )
      cCodPrv  := (cRctPrvT)->CCODPRV
   END IF

RETURN ( cCodPrv )

//----------------------------------------------------------------------------//
/*
Devuelve el Nombre del Proveedor pasando un numero de factura
*/

FUNCTION cNbrRctPrv( cFacPrv, cRctPrvT )

   local cNomPrv  := ""

   IF (cRctPrvT)->( dbSeek( cFacPrv ) )
      cNomPrv  := (cRctPrvT)->CNOMPRV
   END IF

RETURN ( cNomPrv )

//--------------------------------------------------------------------------//

FUNCTION nEstRctPrv( cFacPrv, cRctPrvT, cRctPrvP )

   local nBitmap  := 3

   if ( cRctPrvT )->( dbSeek( cFacPrv ) )
      nBitmap     := ChkPagRctPrv( cRctPrvT, cRctPrvP )
   end if

RETURN nBitmap

//---------------------------------------------------------------------------//

/*
Genera los recibos de una factura
*/

FUNCTION GenPgoRctPrv( cNumFac, cRctPrvT, cRctPrvL, cRctPrvP, cPrv, cIva, cFPago, cDiv, aTmp )

   local nCobro
   local cCodPgo
   local cSerFac
   local nNumFac
   local cSufFac
   local cDivFac
   local nVdvFac
   local dFecFac
   local cCodPrv
   local cNomPrv
   local cCodUsr
   local cCodCaj
   local nTotal
   local nTotCob
   local nDec
   local nInc        := 0
   local n           := 0
   local nTotAcu     := 0
   local nPlazos     := 0
   local cBanco
   local cPaisIBAN
   local cCtrlIBAN
   local cEntidad
   local cSucursal
   local cControl
   local cCuenta

   if aTmp != nil
      cSerFac        := aTmp[ _CSERFAC    ]
      nNumFac        := aTmp[ _NNUMFAC    ]
      cSufFac        := aTmp[ _CSUFFAC    ]
      cDivFac        := aTmp[ _CDIVFAC    ]
      nVdvFac        := aTmp[ _NVDVFAC    ]
      dFecFac        := aTmp[ _DFECFAC    ]
      cCodPgo        := aTmp[ _CCODPAGO   ]
      cCodPrv        := aTmp[ _CCODPRV    ]
      cNomPrv        := aTmp[ _CNOMPRV    ]
      cCodUsr        := aTmp[ _CCODUSR    ]
      cCodCaj        := aTmp[ _CCODCAJ    ]
      cBanco         := aTmp[ _CBANCO     ]
      cPaisIBAN      := aTmp[ _CPAISIBAN  ]
      cCtrlIBAN      := aTmp[ _CCTRLIBAN  ]
      cEntidad       := aTmp[ _CENTBNC    ]
      cSucursal      := aTmp[ _CSUCBNC    ]
      cControl       := aTmp[ _CDIGBNC    ]
      cCuenta        := aTmp[ _CCTABNC    ]
   else
      cSerFac        := ( cRctPrvT )->cSerFac
      nNumFac        := ( cRctPrvT )->nNumFac
      cSufFac        := ( cRctPrvT )->cSufFac
      cDivFac        := ( cRctPrvT )->cDivFac
      nVdvFac        := ( cRctPrvT )->nVdvFac
      dFecFac        := ( cRctPrvT )->dFecFac
      cCodPgo        := ( cRctPrvT )->cCodPago
      cCodPrv        := ( cRctPrvT )->cCodPrv
      cNomPrv        := ( cRctPrvT )->cNomPrv
      cCodUsr        := ( cRctPrvT )->cCodUsr
      cCodCaj        := ( cRctPrvT )->cCodCaj
      cBanco         := ( cRctPrvT )->cBanco
      cPaisIBAN      := ( cRctPrvT )->cPaisIBAN
      cCtrlIBAN      := ( cRctPrvT )->cCtrlIBAN
      cEntidad       := ( cRctPrvT )->cEntBnc
      cSucursal      := ( cRctPrvT )->cSucBnc
      cControl       := ( cRctPrvT )->cDigBnc
      cCuenta        := ( cRctPrvT )->cCtaBnc
   end if

   /*
   Comprobar q el total de factura no es igual al de pagos
   */

   nTotal            := nTotRctPrv( cNumFac, cRctPrvT, cRctPrvL, cIva, cDiv, cRctPrvP, nil, nil, .f. )
   nTotCob           := nPagRctPrv( cNumFac, cRctPrvP, nil, cDiv, .f. )
   nDec              := nRouDiv( cDivFac, cDiv ) // Decimales de la divisa redondeada

   if nTotal != nTotCob

      /*
      Si no hay recibos pagados eliminamos los recibos y se vuelven a generar
      */

      if ( cRctPrvP )->( dbSeek( cNumFac ) )

         while cNumFac == ( cRctPrvP )->cSerFac + Str( ( cRctPrvP )->nNumFac ) + ( cRctPrvP )->cSufFac .and. !( cRctPrvP )->( eof() )

            if !( cRctPrvP )->lCobrado .and. dbLock( cRctPrvP )
               ( cRctPrvP )->( dbDelete() )
               ( cRctPrvP )->( dbUnLock() )
            end if

            ( cRctPrvP )->( dbSkip() )

         end while

      end if

      nTotal            -= nPagRctPrv( cNumFac, cRctPrvP, nil, cDiv, .f. )

      /*
      Genera pagos-------------------------------------------------------------
      */

      if ( cFPago )->( dbSeek( cCodPgo ) )

         nTotAcu        := nTotal
         nPlazos        := Max( ( cFPago )->nPlazos, 1 )

         for n := 1 to nPlazos

            if n != nPlazos
               nTotAcu  -= Round( nTotal / nPlazos, nDec )
            end if

            nInc        := nNewReciboProveedor( cSerFac + Str( nNumFac ) + cSufFac, "R", cRctPrvP )

            ( cRctPrvP )->( dbAppend() )

            ( cRctPrvP )->cSerFac       := cSerFac
            ( cRctPrvP )->nNumFac       := nNumFac
            ( cRctPrvP )->cSufFac       := cSufFac
            ( cRctPrvP )->cCodPrv       := cCodPrv
            ( cRctPrvP )->cNomPrv       := cNomPrv
            ( cRctPrvP )->nNumRec       := nInc
            ( cRctPrvP )->cTipRec       := "R"
            ( cRctPrvP )->nImporte      := if( n != nPlazos, Round( nTotal / nPlazos, nDec ), Round( nTotAcu, nDec ) )
            ( cRctPrvP )->cTurRec       := cCurSesion()
            ( cRctPrvP )->cDescrip      := "Recibo nº" + AllTrim( Str( nInc ) ) + " de factura rectificativa " + cSerFac  + '/' + allTrim( Str( nNumFac ) ) + '/' + cSufFac
            ( cRctPrvP )->cDivPgo       := cDivFac
            ( cRctPrvP )->nVdvPgo       := nVdvFac
            ( cRctPrvP )->lCobRado      := ( ( cFPago )->nCobRec == 1 )
            ( cRctPrvP )->dPreCob       := dFecFac
            ( cRctPrvP )->dFecVto       := dNexDay( dFecFac + ( cFPago )->nPlaUno + ( ( cFPago )->nDiaPla * ( n - 1 ) ), cPrv )
            ( cRctPrvP )->cCtaRec       := ( cFPago )->cCtaCobro
            ( cRctPrvP )->dFecChg       := GetSysDate()
            ( cRctPrvP )->cTimChg       := Time()
            ( cRctPrvP )->cCodPgo       := cCodPgo
            ( cRctPrvP )->lNotArqueo    := .f.
            ( cRctPrvP )->cCodCaj       := cCodCaj
            ( cRctPrvP )->cCodUsr       := cCodUsr

            if !empty( ( cRctPrvT )->cCtrCoste )
               ( cRctPrvP )->cCtrCoste  := ( cRctPrvT )->cCtrCoste
            endif

            if ( cFPago )->lUtlBnc
               ( cRctPrvP )->cEPaisIBAN := ( cFPago )->cPaisIBAN
               ( cRctPrvP )->cECtrlIBAN := ( cFPago )->cCtrlIBAN
               ( cRctPrvP )->cBncEmp    := ( cFPago )->cBanco
               ( cRctPrvP )->cEntEmp    := ( cFPago )->cEntBnc
               ( cRctPrvP )->cSucEmp    := ( cFPago )->cSucBnc
               ( cRctPrvP )->cDigEmp    := ( cFPago )->cDigBnc
               ( cRctPrvP )->cCtaEmp    := ( cFPago )->cCtaBnc
            end if

            ( cRctPrvP )->cPaisIBAN     := cPaisIBAN
            ( cRctPrvP )->cCtrlIBAN     := cCtrlIBAN
            ( cRctPrvP )->cBncPrv       := cBanco
            ( cRctPrvP )->cEntPrv       := cEntidad
            ( cRctPrvP )->cSucPrv       := cSucursal
            ( cRctPrvP )->cDigPrv       := cControl
            ( cRctPrvP )->cCtaPrv       := cCuenta

            if ( cFPago )->nCobRec == 1
               ( cRctPrvP )->dEntrada   := dNexDay( dFecFac + ( cFPago )->nPlaUno + ( ( cFPago )->nDiaPla * ( n - 1 ) ), cPrv )
            end if

            ( cRctPrvP )->( dbUnLock() )

         next

      end if

   end if

RETURN NIL

//---------------------------------------------------------------------------//
//
// Devuelve el total de la compra en facturas de proveedores de un articulo
//

function nTotVRctPrv( cCodArt, cRctPrvL, nDinDiv, nDirDiv )

   local nTotVta  := 0
   local nRecno   := ( cRctPrvL )->( Recno() )

   if ( cRctPrvL )->( dbSeek( cCodArt ) )

      while ( cRctPrvL )->cRef == cCodArt .and. !( cRctPrvL )->( eof() )

         nTotVta  += nTotLRctPrv( cRctPrvL, nDinDiv, nDirDiv )

         ( cRctPrvL )->( dbSkip() )

      end while

   end if

   ( cRctPrvL )->( dbGoTo( nRecno ) )

return ( nTotVta )

//---------------------------------------------------------------------------//
//
// Devuelve el total de unidades de la compra en facturas de proveedores de un articulo
//

function nTotDRctPrv( cCodArt, cRctPrvL, cCodAlm )

   local nTotVta  := 0
   local nRecno   := ( cRctPrvL )->( Recno() )

   if ( cRctPrvL )->( dbSeek( cCodArt ) )

      while ( cRctPrvL )->CREF == cCodArt .and. !( cRctPrvL )->( eof() )

         if cCodAlm != nil
            if cCodAlm == ( cRctPrvL )->cAlmLin
               nTotVta  += nTotNRctPrv( cRctPrvL )
            end if
         else
            nTotVta     += nTotNRctPrv( cRctPrvL )
         end if

         ( cRctPrvL )->( dbSkip() )

      end while

   end if

   ( cRctPrvL )->( dbGoTo( nRecno ) )

return ( nTotVta )

//---------------------------------------------------------------------------//

/*
Devuelve si la factura esta contabilizada o no
*/

FUNCTION lConRctPrv( cFacPrv, cRctPrvT )

   local lConFac  := .f.

   IF ( cRctPrvT )->( dbSeek( cFacPrv ) )
      lConFac     := ( cRctPrvT )->LCONTAB
   END IF

RETURN ( lConFac )

//----------------------------------------------------------------------------//

/*
Devuelve el codigo del Prvente pasando un numero de factura
*/

FUNCTION dPrvRctPrv( cFacPrv, cRctPrvT )

   local cCodPrv  := ""

   IF ( cRctPrvT )->( dbSeek( cFacPrv ) )
      cCodPrv     := (cRctPrvT)->cCodPrv
   END IF

RETURN ( cCodPrv )

//----------------------------------------------------------------------------//

/*
Devuelve la forma de pago pasando un numero de factura
*/

FUNCTION cPgoRctPrv( cFacPrv, cRctPrvT )

   local cCodPgo  := ""

   IF ( cRctPrvT )->( dbSeek( cFacPrv ) )
      cCodPgo     := ( cRctPrvT )->cCodPago
   END IF

RETURN ( cCodPgo )

//----------------------------------------------------------------------------//

FUNCTION cNomRctPrv( cFacPrv, cRctPrvT )

   local cNomPrv := ""

   IF ( cRctPrvT )->( dbSeek( cFacPrv ) )
      cNomPrv  := ( cRctPrvT )->cNomPrv
   END IF

RETURN ( cNomPrv )

//----------------------------------------------------------------------------//

FUNCTION cCodRctPrv( cFacPrv, uFacPrvT )

   local cCodPrv := ""

   if ValType( uFacPrvT ) == "O"

      if uFacPrvT:Seek( cFacPrv )
         cCodPrv  := uFacPrvT:cCodPrv
      end if

   else

      if ( uFacPrvT )->( dbSeek( cFacPrv ) )
         cCodPrv  := ( uFacPrvT )->cCodPrv
      end if

   end if

RETURN ( cCodPrv )

//----------------------------------------------------------------------------//

function dFecVtoRct( nVto )

   local dVto     := Ctod( "  /  /  " )

   DEFAULT nVto   := 1

   if nVto <= len( aDatVcto )
      dVto        := aDatVcto[ nVto ]
   end if

return ( dVto )

//----------------------------------------------------------------------------//

function nImpVtoRct( nVto )

   local nImp     := 0

   DEFAULT nVto   := 1

   if nVto <= len( aImpVcto )
      nImp        := aImpVcto[ nVto ]
   end if

return ( nImp )

//----------------------------------------------------------------------------//

//
// Devuelve el precio neto de un articulo en un factura
//

FUNCTION nNetLFacRct( uFacPrvL, uFacPrvT, nDec, nRec, nVdv, cPirDiv )

   local nCalculo

   DEFAULT nDec   := 0
   DEFAULT nRec   := 0
   DEFAULT nVdv   := 1

   nCalculo       := nNetURctPrv( uFacPrvL, nDec, nRec, nVdv )

   nCalculo       *= nTotNRctPrv( uFacPrvL )

   /*
   Comprobamos los parametros--------------------------------------------------------------------
   */

   if ValType( uFacPrvL ) == "A"

      if uFacPrvL[ _NDTO ]!= 0
         nCalculo    -= nCalculo * uFacPrvL[ _NDTO ] / 100
      end if

   else

      if ( uFacPrvL )->nDto != 0
         nCalculo    -= nCalculo * ( uFacPrvL )->nDto / 100
      end if

   end if

   nCalculo          := Round( nCalculo, nRec )

RETURN ( if( cPirDiv != NIL, Trans( nCalculo, cPirDiv ), nCalculo ) )

//---------------------------------------------------------------------------//

FUNCTION nBrtLRctPrv( uTmpLin, nDec, nRec, nVdv, cPorDiv )

   local nCalculo := 0

   DEFAULT nDec   := 2
   DEFAULT nVdv   := 1

   nCalculo       := nTotURctPrv( uTmpLin, nDec, nVdv, cPorDiv )
   nCalculo       *= nTotNRctPrv( uTmpLin )

   nCalculo       := Round( nCalculo / nVdv, nRec )

Return ( if( cPorDiv != nil, Trans( nCalculo, cPorDiv ), nCalculo ) )

//---------------------------------------------------------------------------//

FUNCTION cProFacRct( cFacPro, cRctPrvT )

   local cCodPro := ""

   IF ( cRctPrvT )->( dbSeek( cFacPro ) )
      cCodPro  := ( cRctPrvT )->CCODPRO
   END IF

RETURN ( cCodPro )

//----------------------------------------------------------------------------//

FUNCTION nTotNRctPrv( uDbf )

   local nTotUnd

   DEFAULT uDbf   := D():FacturasRectificativasProveedoresLineas( nView )

   do case
      case ValType( uDbf ) == "A"
         nTotUnd  := uDbf[ _NUNICAJA ]
         nTotUnd  *= NotCaja( uDbf[ _NCANENT ] )
         nTotUnd  *= NotCero( uDbf[ _NUNDKIT ] )
         nTotUnd  *= NotCero( uDbf[ _NMEDUNO ] )
         nTotUnd  *= NotCero( uDbf[ _NMEDDOS ] )
         nTotUnd  *= NotCero( uDbf[ _NMEDTRE ] )

      case ValType( uDbf ) == "O"
         nTotUnd  := uDbf:nUniCaja
         nTotUnd  *= NotCaja( uDbf:nCanEnt )
         nTotUnd  *= NotCero( uDbf:nUndKit )
         nTotUnd  *= NotCero( uDbf:nMedUno )
         nTotUnd  *= NotCero( uDbf:nMedDos )
         nTotUnd  *= NotCero( uDbf:nMedTre )

      otherwise
         nTotUnd  := ( uDbf )->nUniCaja
         nTotUnd  *= NotCaja( ( uDbf )->nCanEnt )
         nTotUnd  *= NotCero( ( uDbf )->nUndKit )
         nTotUnd  *= NotCero( ( uDbf )->nMedUno )
         nTotUnd  *= NotCero( ( uDbf )->nMedDos )
         nTotUnd  *= NotCero( ( uDbf )->nMedTre )

   end case

RETURN ( nTotUnd )

//--------------------------------------------------------------------------//

FUNCTION nIvaURctPrv( dbfTmp, nDec, nVdv )

   local nCalculo

   DEFAULT nDec   := 0
   DEFAULT nVdv   := 1

   nCalculo       := nTotURctPrv( dbfTmp, nDec, nVdv )

   if !( dbfTmp )->lIvaLin
      nCalculo    += nCalculo * ( dbfTmp )->nIva / 100
   end if

   if nVdv != 0
      nCalculo    := nCalculo / nVdv
   end if

RETURN ( Round( nCalculo, nDec ) )

//---------------------------------------------------------------------------//

FUNCTION nIvaLRctPrv( dbfLin, nDec, nRou, nVdv, cPorDiv )

   local nCalculo 

   DEFAULT nDec   := nDinDiv()
   DEFAULT nRou   := nRinDiv()
   DEFAULT nVdv   := 1

   nCalculo       := nTotLRctPrv( dbfLin, nDec, nRou, nVdv )

   if !( dbfLin )->lIvaLin
      nCalculo    := nCalculo * ( dbfLin )->nIva / 100
   end if

RETURN ( if( cPorDiv != NIL, Trans( nCalculo, cPorDiv ), nCalculo ) )

//---------------------------------------------------------------------------//

/*
Devuelve un array con el neto, impuestos, recargo y total
*/

FUNCTION aTotRctPrv( cFactura, cRctPrvT, cRctPrvL, cIva, cDiv, cRctPrvP, cDivRet )

   nTotRctPrv( cFactura, cRctPrvT, cRctPrvL, cIva, cDiv, cRctPrvP, nil, cDivRet )

RETURN ( { nTotNet, nTotIva, nTotReq, nTotFac, aTotIva, nTotRet } )

//---------------------------------------------------------------------------//

Function sTotRctPrv( cFactura, cRctPrvT, cRctPrvL, cIva, cDiv, cRctPrvP, cDivRet )

   local sTotal

   nTotRctPrv( cFactura, cRctPrvT, cRctPrvL, cIva, cDiv, cRctPrvP, nil, cDivRet )

   sTotal                                 := sTotal()
   sTotal:nTotalBruto                     := nTotBrt
   sTotal:nTotalNeto                      := nTotNet
   sTotal:nTotalIva                       := nTotIva
   sTotal:aTotalIva                       := aTotIva
   sTotal:nTotalRecargoEquivalencia       := nTotReq
   sTotal:nTotalDocumento                 := nTotFac
   sTotal:nTotalDescuentoGeneral          := nTotDto
   sTotal:nTotalDescuentoProntoPago       := nTotDpp
   sTotal:nTotalDescuentoUno              := nTotUno
   sTotal:nTotalDescuentoDos              := nTotDos

Return ( sTotal )

//--------------------------------------------------------------------------//

function aItmRctPrv()

   local aItmFacPrv  := {}

   aAdd( aItmFacPrv, { "CSERFAC"    ,"C",  1, 0, "Serie de factura"                         ,            "",                   "", "( cDbf )"} )
   aAdd( aItmFacPrv, { "NNUMFAC"    ,"N",  9, 0, "Número de factura"                        ,            "'999999999'",        "", "( cDbf )"} )
   aAdd( aItmFacPrv, { "CSUFFAC"    ,"C",  2, 0, "Sufijo de factura"                        ,            "",                   "", "( cDbf )"} )
   aAdd( aItmFacPrv, { "CTURFAC"    ,"C",  6, 0, "Sesión del factura"                       ,            "",                   "", "( cDbf )"} )
   aAdd( aItmFacPrv, { "DFECFAC"    ,"D",  8, 0, "Fecha de la factura"                      ,            "",                   "", "( cDbf )"} )
   aAdd( aItmFacPrv, { "CCODPRV"    ,"C", 12, 0, "Código del proveedor"                     ,            "",                   "", "( cDbf )"} )
   aAdd( aItmFacPrv, { "CCODALM"    ,"C", 16, 0, "Código de almacen"                        ,            "",                   "", "( cDbf )"} )
   aAdd( aItmFacPrv, { "CCODCAJ"    ,"C",  3, 0, "Código de caja"                           ,            "",                   "", "( cDbf )"} )
   aAdd( aItmFacPrv, { "CNOMPRV"    ,"C",150, 0, "Nombre del proveedor"                     ,            "'@!'",               "", "( cDbf )"} )
   aAdd( aItmFacPrv, { "CDIRPRV"    ,"C",200, 0, "Domicilio del proveedor"                  ,            "'@!'",               "", "( cDbf )"} )
   aAdd( aItmFacPrv, { "CPOBPRV"    ,"C",200, 0, "Población del proveedor"                  ,            "'@!'",               "", "( cDbf )"} )
   aAdd( aItmFacPrv, { "CPROVPROV"  ,"C",100, 0, "Provincia del proveedor"                  ,            "'@!'",               "", "( cDbf )"} )
   aAdd( aItmFacPrv, { "CPOSPRV"    ,"C",  5, 0, "Código postal del proveedor"              ,            "",                   "", "( cDbf )"} )
   aAdd( aItmFacPrv, { "CDNIPRV"    ,"C", 30, 0, "DNI/CIF del proveedor"                    ,            "",                   "", "( cDbf )"} )
   aAdd( aItmFacPrv, { "LLIQUIDADA" ,"L",  1, 0, "Lógico de la liquidación"                 ,            "",                   "", "( cDbf )"} )
   aAdd( aItmFacPrv, { "LCONTAB"    ,"L",  1, 0, "Lógico de la contabilización"             ,            "",                   "", "( cDbf )"} )
   aAdd( aItmFacPrv, { "DFECENT"    ,"D",  8, 0, "Fecha de entrada"                         ,            "",                   "", "( cDbf )"} )
   aAdd( aItmFacPrv, { "CSUPED"     ,"C", 10, 0, "Su pedido"                                ,            "",                   "", "( cDbf )"} )
   aAdd( aItmFacPrv, { "CCONDENT"   ,"C", 20, 0, "Condición de entrada"                     ,            "",                   "", "( cDbf )"} )
   aAdd( aItmFacPrv, { "MCOMENT"    ,"M", 10, 0, "Comentarios"                              ,            "",                   "", "( cDbf )"} )
   aAdd( aItmFacPrv, { "CEXPED"     ,"C", 20, 0, "Expedición"                               ,            "",                   "", "( cDbf )"} )
   aAdd( aItmFacPrv, { "COBSERV"    ,"C", 20, 0, "Observaciones"                            ,            "",                   "", "( cDbf )"} )
   aAdd( aItmFacPrv, { "CCODPAGO"   ,"C",  2, 0, "Codigo del tipo de pago"                  ,            "",                   "", "( cDbf )"} )
   aAdd( aItmFacPrv, { "NBULTOS"    ,"N",  3, 0, "Número de bultos"                         ,            "",                   "", "( cDbf )"} )
   aAdd( aItmFacPrv, { "NPORTES"    ,"N",  6, 0, "Valor de los portes"                      ,            "",                   "", "( cDbf )"} )
   aAdd( aItmFacPrv, { "cNumFac"    ,"C", 12, 0, "Número de la factura"                     ,            "",                   "", "( cDbf )"} )
   aAdd( aItmFacPrv, { "LIMPALB"    ,"L",  1, 0, "Factura importada desde albaranes"        ,            "",                   "", "( cDbf )"} )
   aAdd( aItmFacPrv, { "CDTOESP"    ,"C", 50, 0, "Descripción de descuento especial"        ,            "",                   "", "( cDbf )"} )
   aAdd( aItmFacPrv, { "NDTOESP"    ,"N",  5, 2, "Porcentaje de descuento especial"         ,            "'@EZ 99.99'",        "", "( cDbf )"} )
   aAdd( aItmFacPrv, { "CDPP"       ,"C", 50, 0, "Descripción descuento por pronto pago"    ,            "",                   "", "( cDbf )"} )
   aAdd( aItmFacPrv, { "NDPP"       ,"N",  5, 2, "Porcentaje de descuento por pronto pago"  ,            "'@EZ 99.99'",        "", "( cDbf )"} )
   aAdd( aItmFacPrv, { "LRECARGO"   ,"L",  1, 0, "Lógico para recargo"                      ,            "",                   "", "( cDbf )"} )
   aAdd( aItmFacPrv, { "NIRPF"      ,"N",  4, 1, "Porcentaje de IRPF"                       ,            "'@EZ 99.99'",        "", "( cDbf )"} )
   aAdd( aItmFacPrv, { "CCODAGE"    ,"C",  3, 0, "Código del agente"                        ,            "",                   "", "( cDbf )"} )
   aAdd( aItmFacPrv, { "CDIVFAC"    ,"C",  3, 0, "Código de divisa"                         ,            "",                   "", "( cDbf )"} )
   aAdd( aItmFacPrv, { "NVDVFAC"    ,"N", 13, 6, "Valor del cambio de la divisa"            ,            "'@E 999,999.999999'","", "( cDbf )"} )
   aAdd( aItmFacPrv, { "LSNDDOC"    ,"L",  1, 0, "Enviar documento por internet"            ,            "",                   "", "( cDbf )"} )
   aAdd( aItmFacPrv, { "CDTOUNO"    ,"C", 25, 0, "Descripción de primer descuento personalizado",        "",               "", "( cDbf )"} )
   aAdd( aItmFacPrv, { "NDTOUNO"    ,"N",  5, 2, "Porcentaje de primer descuento personalizado",         "",               "", "( cDbf )"} )
   aAdd( aItmFacPrv, { "CDTODOS"    ,"C", 25, 0, "Descripción de segundo descuento personalizado",       "",               "", "( cDbf )"} )
   aAdd( aItmFacPrv, { "NDTODOS"    ,"N",  5, 2, "Porcentaje de segundo descuento personalizado",        "",               "", "( cDbf )"} )
   aAdd( aItmFacPrv, { "CCODPRO"    ,"C",  9, 0, "Código de proyecto en contabilidad",                   "",               "", "( cDbf )"} )
   aAdd( aItmFacPrv, { "LRECDOC"    ,"L",  1, 0, "Documento recibido por internet"          ,            "",               "", "( cDbf )"} )
   aAdd( aItmFacPrv, { "LCLOFAC"    ,"L",  1, 0, ""                                         ,            "",               "", "( cDbf )"} )
   aAdd( aItmFacPrv, { "CNUMDOC"    ,"C", 20, 0, "Número de documento"                      ,            "",               "", "( cDbf )"} )
   aAdd( aItmFacPrv, { "cCodUsr"    ,"C",  3, 0, "Código de usuario",                                    "",               "", "( cDbf )"} )
   aAdd( aItmFacPrv, { "lImprimido" ,"L",  1, 0, "Lógico de imprimido del documento",                    "",               "", "( cDbf )"} )
   aAdd( aItmFacPrv, { "dFecImp"    ,"D",  8, 0, "Última fecha de impresión del documento",              "",               "", "( cDbf )"} )
   aAdd( aItmFacPrv, { "cHorImp"    ,"C",  5, 0, "Hora de la última impresión del documento",            "",               "", "( cDbf )"} )
   aAdd( aItmFacPrv, { "nTipRet"    ,"N",  1, 0, "Tipo de retención ( 1. Base / 2. Base+IVA )",          "",               "", "( cDbf )"} )
   aAdd( aItmFacPrv, { "nPctRet"    ,"N",  6, 2, "Porcentaje de retención",                              "",               "", "( cDbf )"} )
   aAdd( aItmFacPrv, { "dFecChg"    ,"D",  8, 0, "Fecha de modificación del documento",                  "",               "", "( cDbf )"} )
   aAdd( aItmFacPrv, { "cTimChg"    ,"C",  5, 0, "Hora de modificación del documento",                   "",               "", "( cDbf )"} )
   aAdd( aItmFacPrv, { "cCodDlg"    ,"C",  2, 0, "Código delegación",                                    "",               "", "( cDbf )"} )
   aAdd( aItmFacPrv, { "nRegIva"    ,"N",  1, 0, "Régimen de " + cImp(),                                 "",               "", "( cDbf )"} )
   aAdd( aItmFacPrv, { "lFacGas"    ,"L",  1, 0, "Lógico factura de gastos",                             "",               "", "( cDbf )"} )
   aAdd( aItmFacPrv, { "mComGas"    ,"M", 10, 0, "Comentario de gastos",                                 "",               "", "( cDbf )"} )
   aAdd( aItmFacPrv, { "nNetGas1"   ,"N", 16, 6, "Neto de fac. de gastos 1",                             "cPirDivFac",     "", "( cDbf )"} )
   aAdd( aItmFacPrv, { "nNetGas2"   ,"N", 16, 6, "Neto de fac. de gastos 2",                             "cPirDivFac",     "", "( cDbf )"} )
   aAdd( aItmFacPrv, { "nNetGas3"   ,"N", 16, 6, "Neto de fac. de gastos 3",                             "cPirDivFac",     "", "( cDbf )"} )
   aAdd( aItmFacPrv, { "nIvaGas1"   ,"N",  6, 2, "Porcentaje " + cImp() + " 1 de gastos",                "'@EZ 99.99'",    "", "( cDbf )"} )
   aAdd( aItmFacPrv, { "nIvaGas2"   ,"N",  6, 2, "Porcentaje " + cImp() + " 2 de gastos",                "'@EZ 99.99'",    "", "( cDbf )"} )
   aAdd( aItmFacPrv, { "nIvaGas3"   ,"N",  6, 2, "Porcentaje " + cImp() + " 3 de gastos",                "'@EZ 99.99'",    "", "( cDbf )"} )
   aAdd( aItmFacPrv, { "nReGas1"    ,"N",  6, 2, "Porcentaje R.E. 1 de gastos",                          "'@EZ 99.99'",    "", "( cDbf )"} )
   aAdd( aItmFacPrv, { "nReGas2"    ,"N",  6, 2, "Porcentaje R.E. 2 de gastos",                          "'@EZ 99.99'",    "", "( cDbf )"} )
   aAdd( aItmFacPrv, { "nReGas3"    ,"N",  6, 2, "Porcentaje R.E. 3 de gastos",                          "'@EZ 99.99'",    "", "( cDbf )"} )
   aAdd( aItmFacPrv, { "cMotRec"    ,"C",250, 0, "Motivo de la factura rectificativa",                   "",               "", "( cDbf )"} )
   aAdd( aItmFacPrv, { "cCauRec"    ,"C",250, 0, "Causa de la factura rectificativa",                    "",               "", "( cDbf )"} )
   aAdd( aItmFacPrv, { "nTotNet"    ,"N", 16, 6, "Total neto",                                           "",               "", "( cDbf )"} )
   aAdd( aItmFacPrv, { "nTotIva"    ,"N", 16, 6, "Total " + cImp(),                                      "",               "", "( cDbf )"} )
   aAdd( aItmFacPrv, { "nTotReq"    ,"N", 16, 6, "Total recargo",                                        "",               "", "( cDbf )"} )
   aAdd( aItmFacPrv, { "nTotFac"    ,"N", 16, 6, "Total factura rectificativa",                          "",               "", "( cDbf )"} )
   aAdd( aItmFacPrv, { "nTotSup"    ,"N", 16, 6, "Total gastos suplidos",                                "",               "", "( cDbf )"} )
   aAdd( aItmFacPrv, { "cBanco"     ,"C", 50, 0, "Nombre del banco del proveedor" ,                      "",               "", "( cDbf )", nil } )
   aAdd( aItmFacPrv, { "cPaisIBAN"  ,"C",  2, 0, "País IBAN de la cuenta bancaria del cliente",         "",                "", "( cDbf )"} )
   aAdd( aItmFacPrv, { "cCtrlIBAN"  ,"C",  2, 0, "Dígito de control IBAN de la cuenta bancaria del cliente", "",           "", "( cDbf )"} )
   aAdd( aItmFacPrv, { "cEntBnc"    ,"C",  4, 0, "Entidad de la cuenta bancaria del proveedor" ,         "",               "", "( cDbf )", nil } )
   aAdd( aItmFacPrv, { "cSucBnc"    ,"C",  4, 0, "Sucursal de la cuenta bancaria del proveedor" ,        "",               "", "( cDbf )", nil } )
   aAdd( aItmFacPrv, { "cDigBnc"    ,"C",  2, 0, "Dígito de control de la cuenta bancaria del proveedor","",               "", "( cDbf )", nil } )
   aAdd( aItmFacPrv, { "cCtaBnc"    ,"C", 10, 0, "Cuenta bancaria del proveedor" ,                       "",               "", "( cDbf )", nil } )
   aAdd( aItmFacPrv, { "tFecFac"    ,"C",  6, 0, "Hora de la Factura rectificativa" ,                    "",               "", "( cDbf )", nil } )
   aAdd( aItmFacPrv, { "cCtrCoste"  ,"C",  9, 0, "Código del centro de coste",                           "",               "", "( cDbf )", nil } )
   aAdd( aItmFacPrv, { "cAlmOrigen" ,"C", 16, 0, "Almacén de origen de la mercancía" ,                   "",               "", "( cDbf )", nil } )

return ( aItmFacPrv )

//---------------------------------------------------------------------------//

function aColRctPrv()

   local aColFacPrv  := {}

   aAdd( aColFacPrv, { "CSERFAC"    ,"C",  1, 0, "Serie de factura"            ,"",                    "", "( cDbfCol )" } )
   aAdd( aColFacPrv, { "NNUMFAC"    ,"N",  9, 0, "Número de factura"           ,"'999999999'",         "", "( cDbfCol )" } )
   aAdd( aColFacPrv, { "CSUFFAC"    ,"C",  2, 0, "Sufijo de factura"           ,"",                    "", "( cDbfCol )" } )
   aAdd( aColFacPrv, { "CREF"       ,"C", 18, 0, "Referencia artículo"         ,"",                    "", "( cDbfCol )" } )
   aAdd( aColFacPrv, { "CREFPRV"    ,"C", 20, 0, "Referencia del proveedor"    ,"",                    "", "( cDbfCol )" } )
   aAdd( aColFacPrv, { "CDETALLE"   ,"C",250, 0, "Detalle de articulo"         ,"",                    "", "( cDbfCol )" } )
   aAdd( aColFacPrv, { "NPREUNIT"   ,"N", 16, 6, "Precio unitario"             ,"cPinDivFac",          "", "( cDbfCol )" } )
   aAdd( aColFacPrv, { "NDTO"       ,"N",  6, 2, ""                            ,"'@E 99,99'",          "", "( cDbfCol )" } )
   aAdd( aColFacPrv, { "NIVA"       ,"N",  6, 2, "Porcentaje de " + cImp()     ,"'@E 99,99'",          "", "( cDbfCol )" } )
   aAdd( aColFacPrv, { "NCANENT"    ,"N", 16, 6, "Cantidad recibida"           ,"MasUnd()",            "", "( cDbfCol )" } )
   aAdd( aColFacPrv, { "LCONTROL"   ,"L",  1, 0, "Control reservado"           ,"",                    "", "( cDbfCol )" } )
   aAdd( aColFacPrv, { "CUNIDAD"    ,"C",  2, 0, "Unidad de venta"             ,"",                    "", "( cDbfCol )" } )
   aAdd( aColFacPrv, { "NUNICAJA"   ,"N", 16, 6, "Unidades por caja"           ,"MasUnd()",            "", "( cDbfCol )" } )
   aAdd( aColFacPrv, { "LCHGLIN"    ,"L",  1, 0, "Cambio de precio"            ,"",                    "", "( cDbfCol )" } )
   aAdd( aColFacPrv, { "MLNGDES"    ,"M", 10, 0, ""                            ,""          ,          "", "( cDbfCol )" } )
   aAdd( aColFacPrv, { "NDTOLIN"    ,"N",  6, 2, "Descuento lineal"            ,"'@E 999,99'",         "", "( cDbfCol )" } )
   aAdd( aColFacPrv, { "NDTOPRM"    ,"N",  6, 2, "Descuento por promoción"     ,"'@E 999,99'",         "", "( cDbfCol )" } )
   aAdd( aColFacPrv, { "NDTORAP"    ,"N",  6, 2, "Descuento por rappels"       ,"'@E 999,99'",         "", "( cDbfCol )" } )
   aAdd( aColFacPrv, { "NPRECOM"    ,"N", 16, 6, "Precio de compra"            ,"cPinDivFac",          "", "( cDbfCol )" } )
   aAdd( aColFacPrv, { "LBNFLIN1"   ,"L",  1, 0, "" }                                                                      )
   aAdd( aColFacPrv, { "LBNFLIN2"   ,"L",  1, 0, "" }                                                                      )
   aAdd( aColFacPrv, { "LBNFLIN3"   ,"L",  1, 0, "" }                                                                      )
   aAdd( aColFacPrv, { "LBNFLIN4"   ,"L",  1, 0, "" }                                                                      )
   aAdd( aColFacPrv, { "LBNFLIN5"   ,"L",  1, 0, "" }                                                                      )
   aAdd( aColFacPrv, { "LBNFLIN6"   ,"L",  1, 0, "" }                                                                      )
   aAdd( aColFacPrv, { "NBNFLIN1"   ,"N",  6, 2, "" }                                                                      )
   aAdd( aColFacPrv, { "NBNFLIN2"   ,"N",  6, 2, "" }                                                                      )
   aAdd( aColFacPrv, { "NBNFLIN3"   ,"N",  6, 2, "" }                                                                      )
   aAdd( aColFacPrv, { "NBNFLIN4"   ,"N",  6, 2, "" }                                                                      )
   aAdd( aColFacPrv, { "NBNFLIN5"   ,"N",  6, 2, "" }                                                                      )
   aAdd( aColFacPrv, { "NBNFLIN6"   ,"N",  6, 2, "" }                                                                      )
   aAdd( aColFacPrv, { "NBNFSBR1"   ,"N",  1, 0, "" }                                                                      )
   aAdd( aColFacPrv, { "NBNFSBR2"   ,"N",  1, 0, "" }                                                                      )
   aAdd( aColFacPrv, { "NBNFSBR3"   ,"N",  1, 0, "" }                                                                      )
   aAdd( aColFacPrv, { "NBNFSBR4"   ,"N",  1, 0, "" }                                                                      )
   aAdd( aColFacPrv, { "NBNFSBR5"   ,"N",  1, 0, "" }                                                                      )
   aAdd( aColFacPrv, { "NBNFSBR6"   ,"N",  1, 0, "" }                                                                      )
   aAdd( aColFacPrv, { "NPVPLIN1"   ,"N", 16, 6, "" }                                                                      )
   aAdd( aColFacPrv, { "NPVPLIN2"   ,"N", 16, 6, "" }                                                                      )
   aAdd( aColFacPrv, { "NPVPLIN3"   ,"N", 16, 6, "" }                                                                      )
   aAdd( aColFacPrv, { "NPVPLIN4"   ,"N", 16, 6, "" }                                                                      )
   aAdd( aColFacPrv, { "NPVPLIN5"   ,"N", 16, 6, "" }                                                                      )
   aAdd( aColFacPrv, { "NPVPLIN6"   ,"N", 16, 6, "" }                                                                      )
   aAdd( aColFacPrv, { "NIVALIN1"   ,"N", 16, 6, "" }                                                                      )
   aAdd( aColFacPrv, { "NIVALIN2"   ,"N", 16, 6, "" }                                                                      )
   aAdd( aColFacPrv, { "NIVALIN3"   ,"N", 16, 6, "" }                                                                      )
   aAdd( aColFacPrv, { "NIVALIN4"   ,"N", 16, 6, "" }                                                                      )
   aAdd( aColFacPrv, { "NIVALIN5"   ,"N", 16, 6, "" }                                                                      )
   aAdd( aColFacPrv, { "NIVALIN6"   ,"N", 16, 6, "" }                                                                      )
   aAdd( aColFacPrv, { "NIVALIN"    ,"N",  6, 2, "" }                                                                      )
   aAdd( aColFacPrv, { "LIVALIN"    ,"L",  1, 0, "" }                                                                      )
   aAdd( aColFacPrv, { "CCODPR1"    ,"C", 20, 0, "Código de la propiedad 1",     "",                    "", "( cDbfCol )" } )
   aAdd( aColFacPrv, { "CCODPR2"    ,"C", 20, 0, "Código de la propiedad 2",     "",                    "", "( cDbfCol )" } )
   aAdd( aColFacPrv, { "CVALPR1"    ,"C", 20, 0, "Valor de la propiedad 1" ,     "",                    "", "( cDbfCol )" } )
   aAdd( aColFacPrv, { "CVALPR2"    ,"C", 20, 0, "Valor de la propiedad 2" ,     "",                    "", "( cDbfCol )" } )
   aAdd( aColFacPrv, { "NFACCNV"    ,"N", 16, 6, "Factor de conversión de la compra", "",               "", "( cDbfCol )" } )
   aAdd( aColFacPrv, { "CALMLIN"    ,"C", 16, 0, "Código del almacen" ,          "",                    "", "( cDbfCol )" } )
   aAdd( aColFacPrv, { "NCTLSTK"    ,"N",  1, 0, "Tipo de stock de la línea",    "'9'",                 "", "( cDbfCol )" } )
   aAdd( aColFacPrv, { "LLOTE"      ,"L",  1, 0, "",                             "",                    "", "( cDbfCol )" } )
   aAdd( aColFacPrv, { "NLOTE"      ,"N",  9, 0, "",                             "'999999999'",         "", "( cDbfCol )" } )
   aAdd( aColFacPrv, { "cLote"      ,"C", 14, 0, "Número de lote",               "",                    "", "( cDbfCol )" } )
   aAdd( aColFacPrv, { "dFecCad"    ,"D",  8, 0, "Fecha de caducidad",           "",                    "", "( cDbfCol )" } )
   aAdd( aColFacPrv, { "NNUMLIN"    ,"N",  4, 0, "Número de la línea",           "9999",                "", "( cDbfCol )" } )
   aAdd( aColFacPrv, { "NUNDKIT"    ,"N", 16, 6, "Unidades del producto kit",    "MasUnd()",            "", "( cDbfCol )" } )
   aAdd( aColFacPrv, { "LKITART"    ,"L",  1, 0, "Línea con escandallo",         "",                    "", "( cDbfCol )" } )
   aAdd( aColFacPrv, { "LKITCHL"    ,"L",  1, 0, "Línea pertenciente a escandallo", "",                 "", "( cDbfCol )" } )
   aAdd( aColFacPrv, { "LKITPRC"    ,"L",  1, 0, "",                             "",                    "", "( cDbfCol )" } )
   aAdd( aColFacPrv, { "LIMPLIN"    ,"L",  1, 0, "Imprimir linea",               "",                    "", "( cDbfCol )" } )
   aAdd( aColFacPrv, { "MNUMSER"    ,"M", 10, 0, "" ,                            "",                    "", "( cDbfCol )" } )
   aAdd( aColFacPrv, { "CCODUBI1"   ,"C",  5, 0, "",                             "",                    "", "( cDbfCol )" } )
   aAdd( aColFacPrv, { "CCODUBI2"   ,"C",  5, 0, "",                             "",                    "", "( cDbfCol )" } )
   aAdd( aColFacPrv, { "CCODUBI3"   ,"C",  5, 0, "",                             "",                    "", "( cDbfCol )" } )
   aAdd( aColFacPrv, { "CVALUBI1"   ,"C",  5, 0, "",                             "",                    "", "( cDbfCol )" } )
   aAdd( aColFacPrv, { "CVALUBI2"   ,"C",  5, 0, "",                             "",                    "", "( cDbfCol )" } )
   aAdd( aColFacPrv, { "CVALUBI3"   ,"C",  5, 0, "",                             "",                    "", "( cDbfCol )" } )
   aAdd( aColFacPrv, { "CNOMUBI1"   ,"C", 30, 0, "",                             "",                    "", "( cDbfCol )" } )
   aAdd( aColFacPrv, { "CNOMUBI2"   ,"C", 30, 0, "",                             "",                    "", "( cDbfCol )" } )
   aAdd( aColFacPrv, { "CNOMUBI3"   ,"C", 30, 0, "",                             "",                    "", "( cDbfCol )" } )
   aAdd( aColFacPrv, { "CCODFAM"    ,"C", 16, 0, "Código de familia",            "",                    "", "( cDbfCol )" } )
   aAdd( aColFacPrv, { "CGRPFAM"    ,"C",  3, 0, "Código del grupo de familia",  "",                    "", "( cDbfCol )" } )
   aAdd( aColFacPrv, { "NREQ"       ,"N", 16, 6, "Recargo de equivalencia",      "",                    "", "( cDbfCol )" } )
   aAdd( aColFacPrv, { "MOBSLIN"    ,"M", 10, 0, "Observacion de línea",         "",                    "", "( cDbfCol )" } )
   aAdd( aColFacPrv, { "nPvpRec"    ,"N", 16, 6, "Precio de venta recomendado",  "cPinDivFac",          "", "( cDbfCol )" } )
   aAdd( aColFacPrv, { "nNumMed"    ,"N",  1, 0, "Número de mediciones",         "MasUnd()",            "", "( cDbfCol )" } )
   aAdd( aColFacPrv, { "nMedUno"    ,"N", 16, 6, "Primera unidad de medición",   "MasUnd()",            "", "( cDbfCol )" } )
   aAdd( aColFacPrv, { "nMedDos"    ,"N", 16, 6, "Segunda unidad de medición",   "MasUnd()",            "", "( cDbfCol )" } )
   aAdd( aColFacPrv, { "nMedTre"    ,"N", 16, 6, "Tercera unidad de medición",   "MasUnd()",            "", "( cDbfCol )" } )
   aAdd( aColFacPrv, { "lGasSup"    ,"L",  1, 0, "Linea de gastos suplidos",     "",                    "", "( cDbfCol )" } )
   aAdd( aColFacPrv, { "dFecFac"    ,"D",  8, 0, "Fecha de la factura",          "",                    "", "( cDbfCol )" } )
   aAdd( aColFacPrv, { "nBultos"    ,"N", 16, 6, "Numero de bultos en líneas",   "",                    "", "( cDbfCol )" } )
   aAdd( aColFacPrv, { "cFormato"   ,"C",100, 0, "Formato de compra",            "",                    "", "( cDbfCol )" } )
   aAdd( aColFacPrv, { "cCodImp"    ,"C",  3, 0, "Código de impuesto especial",  "",                   "", "( cDbfCol )" } )
   aAdd( aColFacPrv, { "nValImp"    ,"N", 16, 6, "Importe de impuesto especial", "",                   "", "( cDbfCol )" } )
   aAdd( aColFacPrv, { "tFecFac"    ,"C",  6, 0, "Hora de la Factura" ,          "",                   "", "( cDbfCol )" } )
   aAdd( aColFacPrv, { "cCtrCoste"  ,"C",  9, 0, "Código del centro de coste" ,  "",                   "", "( cDbfCol )" } )
   aAdd( aColFacPrv, { "cAlmOrigen" ,"C", 16, 0, "Almacén de origen de la mercancía", "",              "", "( cDbfCol )", nil } )
   aAdd( aColFacPrv, { "cRefAux"    ,"C", 18, 0, "Referencia auxiliar",          "",                   "", "( cDbfCol )" } )
   aAdd( aColFacPrv, { "cRefAux2"   ,"C", 18, 0, "Segunda referencia auxiliar",  "",                   "", "( cDbfCol )" } )
   aAdd( aColFacPrv, { "cTipCtr"    ,"C", 20, 0, "Tipo tercero centro de coste", "",                   "", "( cDbfCol )", nil } )
   aAdd( aColFacPrv, { "cTerCtr"    ,"C", 20, 0, "Tercero centro de coste" ,     "",                   "", "( cDbfCol )", nil } )

Return ( aColFacPrv )

//---------------------------------------------------------------------------//

Function SynRctPrv( cPath )

   local oBlock
   local oError
   local aTotFac

   DEFAULT cPath     := cPatEmp()

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   USE ( cPatEmp() + "RctPrvT.DBF" ) NEW VIA ( cDriver() ) EXCLUSIVE ALIAS ( cCheckArea( "FACPRVT", @dbfRctPrvT ) )
   SET ADSINDEX TO ( cPatEmp() + "RctPrvT.CDX" ) ADDITIVE

   USE ( cPatEmp() + "RctPrvL.DBF" ) NEW VIA ( cDriver() ) EXCLUSIVE ALIAS ( cCheckArea( "FACPRVL", @dbfRctPrvL ) )
   SET ADSINDEX TO ( cPatEmp() + "RctPrvL.CDX" ) ADDITIVE

   USE ( cPatEmp() + "RctPrvI.DBF" ) NEW VIA ( cDriver() ) EXCLUSIVE ALIAS ( cCheckArea( "FACPRVI", @dbfRctPrvI ) )
   SET ADSINDEX TO ( cPatEmp() + "RctPrvI.CDX" ) ADDITIVE

   USE ( cPatEmp() + "RctPrvD.DBF" ) NEW VIA ( cDriver() ) EXCLUSIVE ALIAS ( cCheckArea( "FACPRVD", @dbfRctPrvD ) )
   SET ADSINDEX TO ( cPatEmp() + "RctPrvD.CDX" ) ADDITIVE

   USE ( cPatEmp() + "RctPrvS.DBF" ) NEW VIA ( cDriver() ) EXCLUSIVE ALIAS ( cCheckArea( "FACPRVS", @dbfRctPrvS ) )
   SET ADSINDEX TO ( cPatEmp() + "RctPrvS.CDX" ) ADDITIVE

   USE ( cPatEmp() + "FACPRVP.DBF" ) NEW VIA ( cDriver() ) EXCLUSIVE ALIAS ( cCheckArea( "FACPRVP", @dbfRctPrvP ) )
   SET ADSINDEX TO ( cPatEmp() + "FACPRVP.CDX" ) ADDITIVE
      ( dbfRctPrvP )->( OrdSetFocus( "rNumFac" ) )

   USE ( cPatEmp() + "PROVEE.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PROVEE", @dbfPrv ) )
   SET ADSINDEX TO ( cPatEmp() + "PROVEE.CDX" ) ADDITIVE

   USE ( cPatDat() + "TIVA.DBF" ) NEW VIA ( cDriver() ) EXCLUSIVE ALIAS ( cCheckArea( "TIVA", @dbfIva ) )
   SET ADSINDEX TO ( cPatDat() + "TIVA.CDX" ) ADDITIVE

   USE ( cPatEmp() + "FPAGO.DBF" ) NEW VIA ( cDriver() ) EXCLUSIVE ALIAS ( cCheckArea( "FPAGO", @dbfFPago ) )
   SET ADSINDEX TO ( cPatEmp() + "FPAGO.CDX" ) ADDITIVE

   USE ( cPatDat() + "DIVISAS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "DIVISAS", @dbfDiv ) )
   SET ADSINDEX TO ( cPatDat() + "DIVISAS.CDX" ) ADDITIVE

   USE ( cPatDat() + "Cajas.Dbf" ) NEW VIA ( cDriver() ) EXCLUSIVE ALIAS ( cCheckArea( "CAJAS", @dbfCajT ) )
   SET ADSINDEX TO ( cPatDat() + "Cajas.Cdx" ) ADDITIVE

   USE ( cPatEmp() + "FAMILIAS.DBF" ) NEW VIA ( cDriver() ) EXCLUSIVE ALIAS ( cCheckArea( "FAMILIAS", @dbfFamilia ) ) 
   SET ADSINDEX TO ( cPatEmp() + "FAMILIAS.CDX" ) ADDITIVE

   USE ( cPatEmp() + "ARTICULO.DBF" ) NEW VIA ( cDriver() ) EXCLUSIVE ALIAS ( cCheckArea( "ARTICULO", @dbfArticulo ) )
   SET ADSINDEX TO ( cPatEmp() + "ARTICULO.CDX" ) ADDITIVE

   // Cabeceras ------------------------------------------------------------

   ( dbfRctPrvT )->( OrdSetFocus( 0 ) )
   ( dbfRctPrvT )->( dbGoTop() )

   while !( dbfRctPrvT )->( eof() )

      if empty( ( dbfRctPrvT )->cSufFac )
         ( dbfRctPrvT )->cSufFac := "00"
      end if

      if !empty( ( dbfRctPrvT )->cNumFac ) .and. Len( AllTrim( ( dbfRctPrvT )->cNumFac ) ) != 12
         ( dbfRctPrvT )->cNumFac := AllTrim( ( dbfRctPrvT )->cNumFac ) + "00"
      end if

      if empty( ( dbfRctPrvT )->cCodCaj )
         ( dbfRctPrvT )->cCodCaj := "000"
      end if

      ( dbfRctPrvT )->( dbSkip() )

   end while

   ( dbfRctPrvT )->( OrdSetFocus( 1 ) )

   // Lineas ----------------------------------------------------------------

   ( dbfRctPrvL )->( OrdSetFocus( 0 ) )
   ( dbfRctPrvL )->( dbGoTop() )

   while !( dbfRctPrvL )->( eof() )

      if empty( ( dbfRctPrvL )->cSufFac )
         ( dbfRctPrvL )->cSufFac := "00"
      end if

      if empty( ( dbfRctPrvL )->cLote ) .and. !empty( ( dbfRctPrvL )->nLote )
         ( dbfRctPrvL )->cLote   := AllTrim( Str( ( dbfRctPrvL )->nLote ) )
      end if

      if !empty( ( dbfRctPrvL )->cRef ) .and. empty( ( dbfRctPrvL )->cCodFam )
         ( dbfRctPrvL )->cCodFam := RetFamArt( ( dbfRctPrvL )->cRef, dbfArticulo )
      end if

      if !empty( ( dbfRctPrvL )->cRef ) .and. !empty( ( dbfRctPrvL )->cCodFam )
         ( dbfRctPrvL )->cGrpFam := cGruFam( ( dbfRctPrvL )->cCodFam, dbfFamilia )
      end if

      if empty( ( dbfRctPrvL )->nReq )
         ( dbfRctPrvL )->nReq    := nPReq( dbfIva, ( dbfRctPrvL )->nIva )
      end if

      if empty( ( dbfRctPrvL )->cAlmLin )
         ( dbfRctPrvL )->cAlmLin := RetFld( ( dbfRctPrvL )->cSerRct + Str( ( dbfRctPrvL )->nNumRct ) + ( dbfRctPrvL )->cSufRct, dbfRctPrvT, "cCodAlm" )
      end if

      ( dbfRctPrvL )->( dbSkip() )

      SysRefresh()

   end while

   ( dbfRctPrvL )->( OrdSetFocus( 1 ) )

   // Pagos ----------------------------------------------------------------

   ( dbfRctPrvP )->( OrdSetFocus( 0 ) )
   ( dbfRctPrvP )->( dbGoTop() )
      
      while !( dbfRctPrvP )->( eof() )

         if empty( ( dbfRctPrvP )->cSufFac )
            ( dbfRctPrvP )->cSufFac := "00"
         end if

         if empty( ( dbfRctPrvP )->cCodCaj )
            ( dbfRctPrvP )->cCodCaj := "000"
         end if

         ( dbfRctPrvP )->( dbSkip() )

         SysRefresh()

      end while

   ( dbfRctPrvP )->( OrdSetFocus( 1 ) )

   // Incidencias ----------------------------------------------------------------

   ( dbfRctPrvI )->( OrdSetFocus( 0 ) )
   ( dbfRctPrvI )->( dbGoTop() )

   while !( dbfRctPrvI )->( eof() )

      if empty( ( dbfRctPrvI )->cSufFac )
         ( dbfRctPrvI )->cSufFac := "00"
      end if

      ( dbfRctPrvI )->( dbSkip() )

      SysRefresh()

   end while

   ( dbfRctPrvI )->( OrdSetFocus( 1 ) )

      /*
      Rellenamos los campos de totales-----------------------------------------
      */

      ( dbfRctPrvT )->( ordSetFocus( 1 ) )
      ( dbfRctPrvT )->( dbGoTop() )

      while !( dbfRctPrvT )->( eof() )

         if ( dbfRctPrvT )->nTotFac == 0

            aTotFac                 := aTotRctPrv( ( dbfRctPrvT )->cSerFac + Str( ( dbfRctPrvT )->nNumFac ) + ( dbfRctPrvT )->cSufFac, dbfRctPrvT, dbfRctPrvL, dbfIva, dbfDiv, dbfRctPrvP, ( dbfRctPrvT )->cDivFac )

            ( dbfRctPrvT )->nTotNet := aTotFac[1]
            ( dbfRctPrvT )->nTotIva := aTotFac[2]
            ( dbfRctPrvT )->nTotReq := aTotFac[3]
            ( dbfRctPrvT )->nTotFac := aTotFac[4]

            ( dbfRctPrvT )->( dbUnLock() )

         end if

         ( dbfRctPrvT )->( dbSkip() )

         SysRefresh()

      end while

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   CLOSE ( dbfRctPrvT )
   CLOSE ( dbfRctPrvL )
   CLOSE ( dbfRctPrvI )
   CLOSE ( dbfRctPrvD )
   CLOSE ( dbfRctPrvS )
   CLOSE ( dbfRctPrvP )
   CLOSE ( dbfPrv     )
   CLOSE ( dbfIva     )
   CLOSE ( dbfFPago   )
   CLOSE ( dbfDiv     )
   CLOSE ( dbfCajT    )
   CLOSE ( dbfFamilia )
   CLOSE ( dbfArticulo)

return nil

//------------------------------------------------------------------------//

Function AppRctPrv( cCodPrv, cCodArt, lOpenBrowse )

   local nLevel         := Auth():Level( _MENUITEM_ )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) == 0 .or. nAnd( nLevel, ACC_APPD ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if lOpenBrowse

      if RctPrv( nil, nil, cCodPrv, cCodArt )
         oWndBrw:RecAdd()
      end if

   else

      if OpenFiles( .t. )
         WinAppRec( nil, bEdtRec, D():FacturasRectificativasProveedores( nView ), cCodPrv, cCodArt )
         CloseFiles()
      end if

   end if

RETURN .t.

//----------------------------------------------------------------------------//

FUNCTION EdtRctPrv( nNumFac, lOpenBrowse )

   local nLevel         := Auth():Level( _MENUITEM_ )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) == 0 .or. nAnd( nLevel, ACC_EDIT ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if lOpenBrowse

      if RctPrv()
         if dbSeekInOrd( nNumFac, "nNumFac", D():FacturasRectificativasProveedores( nView ) )
            oWndBrw:RecEdit()
         else
            MsgStop( "No se encuentra factura" )
         end if
      end if

   else

      if OpenFiles( .t. )
         if dbSeekInOrd( nNumFac, "nNumFac", D():FacturasRectificativasProveedores( nView ) )
            nTotRctPrv()
            WinEdtRec( nil, bEdtRec, D():FacturasRectificativasProveedores( nView ) )
         else
            MsgStop( "No se encuentra factura" )
         end if
         CloseFiles()
      end if

   end if

RETURN NIL

//----------------------------------------------------------------------------//

FUNCTION ZooRctPrv( nNumFac, lOpenBrowse )

   local nLevel         := Auth():Level( _MENUITEM_ )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) == 0 .or. nAnd( nLevel, ACC_ZOOM ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if lOpenBrowse

      if RctPrv()
         if dbSeekInOrd( nNumFac, "nNumFac", D():FacturasRectificativasProveedores( nView ) )
            oWndBrw:RecZoom()
         else
            MsgStop( "No se encuentra factura" )
         end if
      end if

   else

      if OpenFiles( .t. )
         if dbSeekInOrd( nNumFac, "nNumFac", D():FacturasRectificativasProveedores( nView ) )
            nTotRctPrv()
            WinZooRec( nil, bEdtRec, D():FacturasRectificativasProveedores( nView ) )
         else
            MsgStop( "No se encuentra factura" )
         end if
         CloseFiles()
      end if

   end if

RETURN NIL

//----------------------------------------------------------------------------//

FUNCTION DelRctPrv( nNumFac, lOpenBrowse )

   local nLevel         := Auth():Level( _MENUITEM_ )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) == 0 .or. nAnd( nLevel, ACC_ZOOM ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if lOpenBrowse

      if RctPrv()
         if dbSeekInOrd( nNumFac, "nNumFac", D():FacturasRectificativasProveedores( nView ) )
            WinDelRec( nil, D():FacturasRectificativasProveedores( nView ), {|| QuiRctPrv() } )
         else
            MsgStop( "No se encuentra factura" )
         end if
      end if

   else

      if OpenFiles( .t. )
         if dbSeekInOrd( nNumFac, "nNumFac", D():FacturasRectificativasProveedores( nView ) )
            WinDelRec( nil, D():FacturasRectificativasProveedores( nView ), {|| QuiRctPrv() } )
         else
            MsgStop( "No se encuentra factura" )
         end if
         CloseFiles()
      end if

   end if

Return nil

//----------------------------------------------------------------------------//

FUNCTION PrnRctPrv( nNumFac, lOpenBrowse )

   local nLevel         := Auth():Level( _MENUITEM_ )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) == 0 .or. nAnd( nLevel, ACC_ZOOM ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if lOpenBrowse

      if RctPrv()
         if dbSeekInOrd( nNumFac, "nNumFac", D():FacturasRectificativasProveedores( nView ) )
            GenRctPrv( IS_PRINTER )
         else
            MsgStop( "No se encuentra factura" )
         end if
      end if

   else

      if OpenFiles( .t. )
         if dbSeekInOrd( nNumFac, "nNumFac", D():FacturasRectificativasProveedores( nView ) )
            nTotRctPrv()
            GenRctPrv( IS_PRINTER )
         else
            MsgStop( "No se encuentra factura" )
         end if
         CloseFiles()
      end if

   end if

RETURN NIL

//---------------------------------------------------------------------------//

FUNCTION VisRctPrv( nNumFac, lOpenBrowse )

   local nLevel         := Auth():Level( _MENUITEM_ )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) == 0 .or. nAnd( nLevel, ACC_ZOOM ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if lOpenBrowse

      if RctPrv()
         if dbSeekInOrd( nNumFac, "nNumFac", D():FacturasRectificativasProveedores( nView ) )
            GenRctPrv( IS_SCREEN )
         else
            MsgStop( "No se encuentra factura" )
         end if
      end if

   else

      if OpenFiles( .t. )
         if dbSeekInOrd( nNumFac, "nNumFac", D():FacturasRectificativasProveedores( nView ) )
            nTotRctPrv()
            GenRctPrv( IS_SCREEN )
         else
            MsgStop( "No se encuentra factura" )
         end if
         CloseFiles()
      end if

   end if

Return nil

//---------------------------------------------------------------------------//

Function IsRctPrv( cPath )

   DEFAULT cPath  := cPatEmp()

   if !lExistTable( cPath + "RctPrvT.Dbf" )
      dbCreate( cPath + "RctPrvT.Dbf", aSqlStruct( aItmRctPrv() ), cDriver() )
   end if

   if !lExistTable( cPath + "RctPrvL.Dbf" )
      dbCreate( cPath + "RctPrvL.Dbf", aSqlStruct( aColRctPrv() ), cDriver() )
   end if

   if !lExistTable( cPath + "RctPrvI.Dbf" )
      dbCreate( cPath + "RctPrvI.Dbf", aSqlStruct( aIncRctPrv() ), cDriver() )
   end if

   if !lExistTable( cPath + "RctPrvD.Dbf" )
      dbCreate( cPath + "RctPrvD.Dbf", aSqlStruct( aFacPrvDoc() ), cDriver() )
   end if

   if !lExistIndex( cPath + "RctPrvT.Cdx" ) .OR. ;
      !lExistIndex( cPath + "RctPrvL.Cdx" ) .OR. ;
      !lExistIndex( cPath + "RctPrvI.Cdx" ) .OR. ;
      !lExistIndex( cPath + "RctPrvD.Cdx" )

      rxRctPrv( cPath )

   end if

Return ( nil )

//---------------------------------------------------------------------------//

FUNCTION cPrpRctPrv( cFacPrvL )

   local cReturn     := ""

   DEFAULT cFacPrvL  := if( !empty( tmpRctPrvL ), tmpRctPrvL, D():FacturasRectificativasProveedoresLineas( nView ) )

   cReturn           += Alltrim( ( cFacPrvL )->cRef )

   if !empty( ( cFacPrvL )->cValPr1 )
      cReturn        += "."
      cReturn        += Alltrim( ( cFacPrvL )->cValPr1 )
   end if

   if !empty( ( cFacPrvL )->cValPr2 )
      cReturn        += "."
      cReturn        += Alltrim( ( cFacPrvL )->cValPr2 )
   end if

RETURN ( cReturn )

//---------------------------------------------------------------------------//

/*
Devuelve la descripción de una linea de factura
*/


FUNCTION cDesRctPrv( cFacPrvL, cFacPrvS )

   DEFAULT cFacPrvL  := D():FacturasRectificativasProveedoresLineas( nView )
   DEFAULT cFacPrvS  := D():FacturasRectificativasProveedoresDocumentos( nView )

RETURN ( Descrip( cFacPrvL, cFacPrvS ) )

//---------------------------------------------------------------------------//

FUNCTION cDesRctPrvLeng( cFacPrvL, cFacPrvS, cArtLeng )

   DEFAULT cFacPrvL  := D():FacturasRectificativasProveedoresLineas( nView )
   DEFAULT cFacPrvS  := D():FacturasRectificativasProveedoresDocumentos( nView )
   DEFAULT cArtLeng  := D():ArticuloLenguaje( nView )

RETURN ( DescripLeng( cFacPrvL, cFacPrvS, cArtLeng ) )

//---------------------------------------------------------------------------//

Function cCtaRctPrv( cRctPrvT, cRctPrvP, cBncPrv )

   local cCtaRctPrv  := ""

   DEFAULT cRctPrvT  := D():FacturasRectificativasProveedores( nView )
   DEFAULT cRctPrvP  := D():FacturasProveedoresPagos( nView )
   DEFAULT cBncPrv   := D():BancosProveedores( nView )

   cCtaRctPrv        := Rtrim( ( cRctPrvT )->cPaisIBAN + ( cRctPrvT )->cCtrlIBAN + ( cRctPrvT )->cEntBnc + ( cRctPrvT )->cSucBnc + ( cRctPrvT )->cDigBnc + ( cRctPrvT )->cCtaBnc )

   if empty( cCtaRctPrv )
      if dbSeekInOrd( ( cRctPrvT )->cSerFac + Str( ( cRctPrvT )->nNumFac ) + ( cRctPrvT )->cSufFac, "nNumFac", cRctPrvP )
         cCtaRctPrv  := cProveeCuenta( ( cRctPrvP )->cCodPrv, cBncPrv )
      end if
   end if

Return ( cCtaRctPrv )

//------------------------------------------------------------------------//

/*
Calcula el total de linea de factura
*/

FUNCTION nTotLRctPrv( uFacPrvL, nDec, nRec, nVdv, cPirDiv )

   local nCalculo
   local nDtoLin
   local nDtoPrm

   DEFAULT uFacPrvL  := D():FacturasRectificativasProveedoresLineas( nView )
   DEFAULT nDec      := nDinDiv()
   DEFAULT nRec      := nRinDiv()
   DEFAULT nVdv      := 1

   nCalculo       := nTotURctPrv( uFacPrvL, nDec, nVdv )

   do case
   case ValType( uFacPrvL ) == "A"
      nDtoLin     := uFacPrvL[ _NDTOLIN ]
      nDtoPrm     := uFacPrvL[ _NDTOPRM ]
   case ValType( uFacPrvL ) == "C"
      nDtoLin     := ( uFacPrvL )->nDtoLin
      nDtoPrm     := ( uFacPrvL )->nDtoPrm
   case ValType( uFacPrvL ) == "O"
      nDtoLin     := uFacPrvL:nDtoLin
      nDtoPrm     := uFacPrvL:nDtoPrm
   end case

   if nDtoLin != 0
      nCalculo    -= nCalculo * nDtoLin / 100
   end if

   if nDtoPrm != 0
      nCalculo    -= nCalculo * nDtoPrm / 100
   end if

   nCalculo       *= nTotNRctPrv( uFacPrvL )

   if nRec != nil
      nCalculo       := Round( nCalculo, nRec )
   end if

RETURN ( if( cPirDiv != NIL, Trans( nCalculo, cPirDiv ), nCalculo ) )

//---------------------------------------------------------------------------//

/*
Devuelve el importe de descuento porcentual por cada linea---------------------
*/

FUNCTION nDtoLRctPrv( cRctPrvL, nDec, nRou, nVdv )

   local nCalculo       := 0

   DEFAULT cRctPrvL     := D():FacturasRectificativasProveedoresLineas( nView )
   DEFAULT nDec         := nDinDiv()
   DEFAULT nRou         := nRinDiv()
   DEFAULT nVdv         := 1

   if ( cRctPrvL )->nDtoLin != 0 

      nCalculo          := nTotURctPrv( cRctPrvL, nDec ) * nTotNRctPrv( cRctPrvL )

      /*
      Descuentos---------------------------------------------------------------
      */

      nCalculo          := nCalculo * ( cRctPrvL )->nDtoLin / 100

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

FUNCTION nPrmLRctPrv( cRctPrvL, nDec, nRou, nVdv )

   local nCalculo       := 0

   DEFAULT cRctPrvL     := D():FacturasRectificativasProveedoresLineas( nView )
   DEFAULT nDec         := nDinDiv()
   DEFAULT nRou         := nRinDiv()
   DEFAULT nVdv         := 1

   if ( cRctPrvL )->nDtoPrm != 0 

      nCalculo          := nTotURctPrv( cRctPrvL, nDec ) * nTotNRctPrv( cRctPrvL )

      /*
      Descuentos---------------------------------------------------------------
      */

      if ( cRctPrvL )->nDtoLin != 0 
         nCalculo       -= nCalculo * ( cRctPrvL )->nDtoLin / 100
      end if

      nCalculo          := nCalculo * ( cRctPrvL )->nDtoPrm / 100

      if nVdv != 0
         nCalculo       := nCalculo / nVdv
      end if

      if nRou != nil
         nCalculo       := Round( nCalculo, nRou )
      end if

   end if

RETURN ( nCalculo ) 

//---------------------------------------------------------------------------//

FUNCTION nTotURctPrv( uFacPrvL, nDec, nVdv, cPinDiv )

   local nCalculo

   DEFAULT uFacPrvL  := D():FacturasRectificativasProveedoresLineas( nView )
   DEFAULT nDec      := 0
   DEFAULT nVdv      := 1

   do case
   case ValType( uFacPrvL ) == "O"
      nCalculo    := uFacPrvL:nPreUnit / nVdv
   case ValType( uFacPrvL ) == "A"
      nCalculo    := uFacPrvL[ _NPREUNIT ] / nVdv
   case ValType( uFacPrvL ) == "C"
      nCalculo    := ( uFacPrvL )->nPreUnit / nVdv
   end case

   nCalculo       := Round( nCalculo, nDec )

RETURN ( ( if( cPinDiv != nil, Trans( nCalculo, cPinDiv ), nCalculo ) )  )

//---------------------------------------------------------------------------//

FUNCTION nTotIRctPrv( dbfLin, nDec, nRouDec, nVdv, cPorDiv )

   local nCalculo    := 0

   DEFAULT dbfLin    := D():Get( "RctPrvT", nView )
   DEFAULT nDec      := 0
   DEFAULT nRouDec   := 0
   DEFAULT nVdv      := 1

   nCalculo          := Round( ( dbfLin )->nValImp, nDec )
   nCalculo          *= nTotNRctPrv( dbfLin )
   nCalculo          := Round( nCalculo / nVdv, nRouDec )

RETURN ( if( cPorDiv != NIL, Trans( nCalculo, cPorDiv ), nCalculo ) )

//----------------------------------------------------------------------------//

Function DesignLabelFacturaRectificativaProveedor( oFr, cDbfDoc )

   local oLabel   
   local lOpenFiles  := empty( nView ) 

   if lOpenFiles .and. !Openfiles()
      Return .f.
   endif

   oLabel            := TLabelGeneratorFacturaRectificativaProveedores():New( nView )

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
      oFr:SetObjProperty(  "MasterData",  "DataSet",        "Lineas de facturas rectificativas" )
   end if

   // Zona de variables--------------------------------------------------------

   variableReport( oFr )

   // Diseño de report------------------------------------------------------

   oFr:DesignReport()

   // Destruye el diseñador-------------------------------------------------

   oFr:DestroyFr()

   oLabel:DestroyTempReport()
   oLabel:End()

   if lOpenFiles
      closeFiles()
   end if 

Return .t.

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

Function aLblRctPrv()

   local aLblFacPrv  := {}

   aAdd( aLblFacPrv, { "CSERFAC"    ,"C",  1, 0, "Serie de factura"            ,"",                    "", "( cDbfCol )" } )
   aAdd( aLblFacPrv, { "NNUMFAC"    ,"N",  9, 0, "Número de factura"           ,"'999999999'",         "", "( cDbfCol )" } )
   aAdd( aLblFacPrv, { "CSUFFAC"    ,"C",  2, 0, "Sufijo de factura"           ,"",                    "", "( cDbfCol )" } )
   aAdd( aLblFacPrv, { "CREF"       ,"C", 18, 0, "Referencia artículo"         ,"",                    "", "( cDbfCol )" } )
   aAdd( aLblFacPrv, { "CREFPRV"    ,"C", 20, 0, "Referencia del proveedor"    ,"",                    "", "( cDbfCol )" } )
   aAdd( aLblFacPrv, { "CDETALLE"   ,"C",100, 0, "Detalle de articulo"         ,"",                    "", "( cDbfCol )" } )
   aAdd( aLblFacPrv, { "NPREUNIT"   ,"N", 16, 6, "Precio unitario"             ,"cPinDivFac",          "", "( cDbfCol )" } )
   aAdd( aLblFacPrv, { "NDTO"       ,"N",  6, 2, ""                            ,"'@E 99,99'",          "", "( cDbfCol )" } )
   aAdd( aLblFacPrv, { "NIVA"       ,"N",  6, 2, "Porcentaje de " + cImp()     ,"'@E 99,99'",          "", "( cDbfCol )" } )
   aAdd( aLblFacPrv, { "NCANENT"    ,"N", 16, 6, "Cantidad recibida"           ,"cMasUnd()",           "", "( cDbfCol )" } )
   aAdd( aLblFacPrv, { "LCONTROL"   ,"L",  1, 0, "Control reservado"           ,"",                    "", "( cDbfCol )" } )
   aAdd( aLblFacPrv, { "CUNIDAD"    ,"C",  2, 0, "Unidad de venta"             ,"",                    "", "( cDbfCol )" } )
   aAdd( aLblFacPrv, { "NUNICAJA"   ,"N", 16, 6, "Unidades por caja"           ,"cMasUnd()",           "", "( cDbfCol )" } )
   aAdd( aLblFacPrv, { "LCHGLIN"    ,"L",  1, 0, "Cambio de precio"            ,"",                    "", "( cDbfCol )" } )
   aAdd( aLblFacPrv, { "MLNGDES"    ,"M", 10, 0, ""                            ,""          ,          "", "( cDbfCol )" } )
   aAdd( aLblFacPrv, { "NDTOLIN"    ,"N",  6, 2, "Descuento lineal"            ,"'@E 999,99'",         "", "( cDbfCol )" } )
   aAdd( aLblFacPrv, { "NDTOPRM"    ,"N",  6, 2, "Descuento por promoción"     ,"'@E 999,99'",         "", "( cDbfCol )" } )
   aAdd( aLblFacPrv, { "NDTORAP"    ,"N",  6, 2, "Descuento por rappel"        ,"'@E 999,99'",         "", "( cDbfCol )" } )
   aAdd( aLblFacPrv, { "NPRECOM"    ,"N", 16, 6, "Precio de compra"            ,"cPinDivFac",          "", "( cDbfCol )" } )
   aAdd( aLblFacPrv, { "LBNFLIN1"   ,"L",  1, 0, "" }                                                                      )
   aAdd( aLblFacPrv, { "LBNFLIN2"   ,"L",  1, 0, "" }                                                                      )
   aAdd( aLblFacPrv, { "LBNFLIN3"   ,"L",  1, 0, "" }                                                                      )
   aAdd( aLblFacPrv, { "LBNFLIN4"   ,"L",  1, 0, "" }                                                                      )
   aAdd( aLblFacPrv, { "LBNFLIN5"   ,"L",  1, 0, "" }                                                                      )
   aAdd( aLblFacPrv, { "LBNFLIN6"   ,"L",  1, 0, "" }                                                                      )
   aAdd( aLblFacPrv, { "NBNFLIN1"   ,"N",  6, 2, "" }                                                                      )
   aAdd( aLblFacPrv, { "NBNFLIN2"   ,"N",  6, 2, "" }                                                                      )
   aAdd( aLblFacPrv, { "NBNFLIN3"   ,"N",  6, 2, "" }                                                                      )
   aAdd( aLblFacPrv, { "NBNFLIN4"   ,"N",  6, 2, "" }                                                                      )
   aAdd( aLblFacPrv, { "NBNFLIN5"   ,"N",  6, 2, "" }                                                                      )
   aAdd( aLblFacPrv, { "NBNFLIN6"   ,"N",  6, 2, "" }                                                                      )
   aAdd( aLblFacPrv, { "NBNFSBR1"   ,"N",  1, 0, "" }                                                                      )
   aAdd( aLblFacPrv, { "NBNFSBR2"   ,"N",  1, 0, "" }                                                                      )
   aAdd( aLblFacPrv, { "NBNFSBR3"   ,"N",  1, 0, "" }                                                                      )
   aAdd( aLblFacPrv, { "NBNFSBR4"   ,"N",  1, 0, "" }                                                                      )
   aAdd( aLblFacPrv, { "NBNFSBR5"   ,"N",  1, 0, "" }                                                                      )
   aAdd( aLblFacPrv, { "NBNFSBR6"   ,"N",  1, 0, "" }                                                                      )
   aAdd( aLblFacPrv, { "NPVPLIN1"   ,"N", 16, 6, "" }                                                                      )
   aAdd( aLblFacPrv, { "NPVPLIN2"   ,"N", 16, 6, "" }                                                                      )
   aAdd( aLblFacPrv, { "NPVPLIN3"   ,"N", 16, 6, "" }                                                                      )
   aAdd( aLblFacPrv, { "NPVPLIN4"   ,"N", 16, 6, "" }                                                                      )
   aAdd( aLblFacPrv, { "NPVPLIN5"   ,"N", 16, 6, "" }                                                                      )
   aAdd( aLblFacPrv, { "NPVPLIN6"   ,"N", 16, 6, "" }                                                                      )
   aAdd( aLblFacPrv, { "NIVALIN1"   ,"N", 16, 6, "" }                                                                      )
   aAdd( aLblFacPrv, { "NIVALIN2"   ,"N", 16, 6, "" }                                                                      )
   aAdd( aLblFacPrv, { "NIVALIN3"   ,"N", 16, 6, "" }                                                                      )
   aAdd( aLblFacPrv, { "NIVALIN4"   ,"N", 16, 6, "" }                                                                      )
   aAdd( aLblFacPrv, { "NIVALIN5"   ,"N", 16, 6, "" }                                                                      )
   aAdd( aLblFacPrv, { "NIVALIN6"   ,"N", 16, 6, "" }                                                                      )
   aAdd( aLblFacPrv, { "NIVALIN"    ,"N",  6, 2, "" }                                                                      )
   aAdd( aLblFacPrv, { "LIVALIN"    ,"L",  1, 0, "" }                                                                      )
   aAdd( aLblFacPrv, { "CCODPR1"    ,"C", 20, 0, "Código de la propiedad 1",    "",                    "", "( cDbfCol )" } )
   aAdd( aLblFacPrv, { "CCODPR2"    ,"C", 20, 0, "Código de la propiedad 2",    "",                    "", "( cDbfCol )" } )
   aAdd( aLblFacPrv, { "CVALPR1"    ,"C", 20, 0, "Valor de la propiedad 1" ,    "",                    "", "( cDbfCol )" } )
   aAdd( aLblFacPrv, { "CVALPR2"    ,"C", 20, 0, "Valor de la propiedad 2" ,    "",                    "", "( cDbfCol )" } )
   aAdd( aLblFacPrv, { "NFACCNV"    ,"N", 16, 6, "Factor de conversión de la compra", "",              "", "( cDbfCol )" } )
   aAdd( aLblFacPrv, { "CALMLIN"    ,"C", 16, 0, "Código del almacen" ,         "",                    "", "( cDbfCol )" } )
   aAdd( aLblFacPrv, { "NCTLSTK"    ,"N",  1, 0, "Tipo de stock de la línea",   "'9'",                 "", "( cDbfCol )" } )
   aAdd( aLblFacPrv, { "LLOTE"      ,"L",  1, 0, "",                            "",                    "", "( cDbfCol )" } )
   aAdd( aLblFacPrv, { "NLOTE"      ,"N",  9, 0, "",                            "'999999999'",         "", "( cDbfCol )" } )
   aAdd( aLblFacPrv, { "cLote"      ,"C", 14, 0, "Número de lote",              "",                    "", "( cDbfCol )" } )
   aAdd( aLblFacPrv, { "NNUMLIN"    ,"N",  4, 0, "Número de la línea",          "9999",                "", "( cDbfCol )" } )
   aAdd( aLblFacPrv, { "NUNDKIT"    ,"N", 16, 6, "Unidades del producto kit",   "MasUnd()",            "", "( cDbfCol )" } )
   aAdd( aLblFacPrv, { "LKITART"    ,"L",  1, 0, "Línea con escandallo",        "",                    "", "( cDbfCol )" } )
   aAdd( aLblFacPrv, { "LKITCHL"    ,"L",  1, 0, "Línea pertenciente a escandallo", "",                "", "( cDbfCol )" } )
   aAdd( aLblFacPrv, { "LKITPRC"    ,"L",  1, 0, "",                            "",                    "", "( cDbfCol )" } )
   aAdd( aLblFacPrv, { "LIMPLIN"    ,"L",  1, 0, "Imprimir línea",              "",                    "", "( cDbfCol )" } )
   aAdd( aLblFacPrv, { "MNUMSER"    ,"M", 10, 0, "" ,                           "",                    "", "( cDbfCol )" } )
   aAdd( aLblFacPrv, { "CCODUBI1"   ,"C",  5, 0, "",                            "",                    "", "( cDbfCol )" } )
   aAdd( aLblFacPrv, { "CCODUBI2"   ,"C",  5, 0, "",                            "",                    "", "( cDbfCol )" } )
   aAdd( aLblFacPrv, { "CCODUBI3"   ,"C",  5, 0, "",                            "",                    "", "( cDbfCol )" } )
   aAdd( aLblFacPrv, { "CVALUBI1"   ,"C",  5, 0, "",                            "",                    "", "( cDbfCol )" } )
   aAdd( aLblFacPrv, { "CVALUBI2"   ,"C",  5, 0, "",                            "",                    "", "( cDbfCol )" } )
   aAdd( aLblFacPrv, { "CVALUBI3"   ,"C",  5, 0, "",                            "",                    "", "( cDbfCol )" } )
   aAdd( aLblFacPrv, { "CNOMUBI1"   ,"C", 30, 0, "",                            "",                    "", "( cDbfCol )" } )
   aAdd( aLblFacPrv, { "CNOMUBI2"   ,"C", 30, 0, "",                            "",                    "", "( cDbfCol )" } )
   aAdd( aLblFacPrv, { "CNOMUBI3"   ,"C", 30, 0, "",                            "",                    "", "( cDbfCol )" } )
   aAdd( aLblFacPrv, { "CCODFAM"    ,"C", 16, 0, "Código de familia",           "",                    "", "( cDbfCol )" } )
   aAdd( aLblFacPrv, { "CGRPFAM"    ,"C",  3, 0, "Código del grupo de familia", "",                    "", "( cDbfCol )" } )
   aAdd( aLblFacPrv, { "NREQ"       ,"N", 16, 6, "Recargo de equivalencia",     "",                    "", "( cDbfCol )" } )
   aAdd( aLblFacPrv, { "MOBSLIN"    ,"M", 10, 0, "Observación de línea",        "",                    "", "( cDbfCol )" } )
   aAdd( aLblFacPrv, { "nPvpRec"    ,"N", 16, 6, "Precio de venta recomendado", "cPinDivFac",          "", "( cDbfCol )" } )
   aAdd( aLblFacPrv, { "NUNDLIN"    ,"N",  5, 0, "",                            "",                    "", "( cDbfCol )" } )
   aAdd( aLblFacPrv, { "LLABEL"     ,"L",  1, 0, "Lógico de etiqueta",          "",                    "", "( cDbfCol )" } )
   aAdd( aLblFacPrv, { "NLABEL"     ,"N",  5, 0, "Número de etiquetas",         "",                    "", "( cDbfCol )" } )

return ( aLblFacPrv )

//---------------------------------------------------------------------------//

Function DesignReportRctPrv( oFr, cDoc )

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

      if !empty( ( cDoc )->mReport )

         oFr:LoadFromBlob( ( cDoc )->( Select() ), "mReport")

      else

         oFr:SetProperty(     "Report",            "ScriptLanguage", "PascalScript" )
         oFr:SetProperty(     "Report.ScriptText", "Text",;
                                                   + ;
                                                   "procedure DetalleOnMasterDetail(Sender: TfrxComponent);"   + Chr(13) + Chr(10) + ;
                                                   "begin"                                                     + Chr(13) + Chr(10) + ;
                                                   "CallHbFunc('nTotRctPrv');"                                 + Chr(13) + Chr(10) + ;
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

      oFr:SetTabTreeExpanded( FR_tvAll, .f. )
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

Function mailReportRctPrv( cCodigoDocumento )

Return ( printReportRctPrv( IS_MAIL, 1, prnGetName(), cCodigoDocumento ) )

//---------------------------------------------------------------------------//

Function PrintReportRctPrv( nDevice, nCopies, cPrinter, cDoc )

   local oFr
   local cFilePdf

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

   cFilePdf             := cPatTmp() + "RectificativaProveedor" + StrTran( ( D():FacturasRectificativasProveedores( nView ) )->cSerFac + Str( ( D():FacturasRectificativasProveedores( nView ) )->nNumFac ) + ( D():FacturasRectificativasProveedores( nView ) )->cSufFac, " ", "" ) + ".Pdf"

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
            oFr:PrepareReport()
            oFr:ShowPreparedReport()

         case nDevice == IS_PRINTER
            oFr:PrintOptions:SetPrinter( cPrinter )
            oFr:PrintOptions:SetCopies( nCopies )
            oFr:PrintOptions:SetShowDialog( .f. )
            oFr:PrepareReport()
            oFr:Print()

         case nDevice == IS_PDF
            oFr:PrintOptions:SetShowDialog( .f. )
            oFr:SetProperty(  "PDFExport", "DefaultPath",      cPatTmp() )
            oFr:SetProperty(  "PDFExport", "FileName",         cFilePdf )
            oFr:SetProperty(  "PDFExport", "ShowDialog",       .f. )
            oFr:SetProperty(  "PDFExport", "EmbeddedFonts",    .t. )
            oFr:SetProperty(  "PDFExport", "PrintOptimized",   .t. )
            oFr:SetProperty(  "PDFExport", "Outline",          .t. )
            oFr:SetProperty(  "PDFExport", "OpenAfterExport",  .t. )
            oFr:DoExport(     "PDFExport" )

         case nDevice == IS_MAIL

            oFr:SetProperty(  "PDFExport", "ShowDialog",       .f. )
            oFr:SetProperty(  "PDFExport", "DefaultPath",      cPatTmp() )
            oFr:SetProperty(  "PDFExport", "FileName",         cFilePdf  )
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
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

FUNCTION nIncURctPrv( dbfTmpLin, nDec, nVdv )

   local nCalculo

   DEFAULT nDec   := 0
   DEFAULT nVdv   := 1

   nCalculo       := nTotURctPrv( dbfTmpLin, nDec, nVdv )

   if !( dbfTmpLin )->lIvaLin
      nCalculo    += nCalculo * ( dbfTmpLin )->nIva / 100
   end if

   IF nVdv != 0
      nCalculo    := nCalculo / nVdv
   END IF

RETURN ( Round( nCalculo, nDec ) )

//---------------------------------------------------------------------------//

FUNCTION nIncLRctPrv( dbfLin, nDec, nRouDec, nVdv )

   local nCalculo := nTotLRctPrv( dbfLin, nDec, nRouDec, nVdv )

   if !( dbfLin )->lIvaLin
      nCalculo    += nCalculo * ( dbfLin )->nIva / 100
   end if

RETURN ( nCalculo )

//---------------------------------------------------------------------------//

/*
Obtnenemos el nuevo numero del contador
*/

function nNewReciboProveedor( cNumFac, cTipRec, dbfFacPrvP )

   local nCon
   local nRec
   local nOrd

   DEFAULT cTipRec         := .f.

   nCon                    := 1
   nRec                    := ( dbfFacPrvP )->( Recno() )

   if empty( cTipRec )
      nOrd                 := ( dbfFacPrvP )->( OrdSetFocus( "nNumFac" ) )
   else
      nOrd                 := ( dbfFacPrvP )->( OrdSetFocus( "rNumFac" ) )
   end if

   if ( dbfFacPrvP )->( dbSeek( cNumFac ) )

      while ( dbfFacPrvP )->cSerFac + Str( ( dbfFacPrvP )->nNumFac ) + ( dbfFacPrvP )->cSufFac == cNumFac .and. !( dbfFacPrvP )->( eof() )

         ++nCon

         ( dbfFacPrvP )->( dbSkip() )

      end do

   end if

   ( dbfFacPrvP )->( OrdSetFocus( nOrd ) )
   ( dbfFacPrvP )->( dbGoTo( nRec ) )

return ( nCon )

//------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS TRectificativasProveedorSenderReciver FROM TSenderReciverItem

   Data lSuccesfullSendFacturas

   Data nFacturaNumberSend

   Method CreateData()

   Method RestoreData()

   Method SendData()

   Method ReciveData()

   Method Process()

   Method nGetFacturaNumberToSend()    INLINE ( ::nFacturaNumberSend     := GetPvProfInt( "Numero", "Rectificativas proveedor", ::nFacturaNumberSend, ::cIniFile ) )

   Method IncFacturaNumberToSend()     INLINE ( WritePProString( "Numero", "Rectificativas proveedor",    cValToChar( ++::nFacturaNumberSend ),  ::cIniFile ) )

   METHOD validateRecepcion( tmpRctPrvT, dbfRctPrvT )

END CLASS

//----------------------------------------------------------------------------//

Method CreateData() CLASS TRectificativasProveedorSenderReciver

   local oBlock
   local oError
   local nOrd
   local lSnd        := .f.
   local dbfRctPrvT
   local dbfRctPrvL
   local cFileName

   if ::oSender:lServer
      cFileName      := "RectPrv" + StrZero( ::nGetFacturaNumberToSend(), 6 ) + ".All"
   else
      cFileName      := "RectPrv" + StrZero( ::nGetFacturaNumberToSend(), 6 ) + "." + RetSufEmp()
   end if

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   USE ( cPatEmp() + "RctPrvT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "RCTPRVT", @dbfRctPrvT ) )
   SET ADSINDEX TO ( cPatEmp() + "RctPrvT.CDX" ) ADDITIVE

   USE ( cPatEmp() + "RctPrvL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "RCTPRVL", @dbfRctPrvL ) )
   SET ADSINDEX TO ( cPatEmp() + "RctPrvL.CDX" ) ADDITIVE

   /*
   Creamos todas las bases de datos relacionadas con Articulos
   */

   mkRctPrv( cPatSnd(), , cLocalDriver() )

   USE ( cPatSnd() + "RctPrvT.DBF" ) NEW VIA ( cLocalDriver() ) SHARED ALIAS ( cCheckArea( "FACPRVT", @tmpRctPrvT ) )
   SET INDEX TO ( cPatSnd() + "RctPrvT.CDX" ) ADDITIVE

   USE ( cPatSnd() + "RctPrvL.DBF" ) NEW VIA ( cLocalDriver() ) SHARED ALIAS ( cCheckArea( "FACPRVL", @tmpRctPrvL ) )
   SET INDEX TO ( cPatSnd() + "RctPrvL.CDX" ) ADDITIVE

   if !empty( ::oSender:oMtr )
      ::oSender:oMtr:nTotal := ( dbfRctPrvT )->( LastRec() )
   end if

   ::oSender:SetText( "Enviando facturas rectificativas de proveedores" )

   nOrd  := ( dbfRctPrvT )->( OrdSetFocus( "lSndDoc" ) )

   if ( dbfRctPrvT )->( dbSeek( .t. ) )

      while ( dbfRctPrvT )->lSndDoc .and. !( dbfRctPrvT )->( eof() )

         lSnd  := .t.

         dbPass( dbfRctPrvT, tmpRctPrvT, .t. )
         ::oSender:SetText( ( dbfRctPrvT )->cSerFac + "/" + AllTrim( Str( ( dbfRctPrvT )->nNumFac ) ) + "/" + AllTrim( ( dbfRctPrvT )->cSufFac ) + "; " + Dtoc( ( dbfRctPrvT )->dFecFac ) + "; " + AllTrim( ( dbfRctPrvT )->cCodPrv ) + "; " + ( dbfRctPrvT )->cNomPrv )

         if ( dbfRctPrvL )->( dbSeek( ( dbfRctPrvT )->cSerFac + Str( ( dbfRctPrvT )->nNumFac ) + ( dbfRctPrvT )->cSufFac ) )
            do while ( dbfRctPrvL )->cSerFac + Str( ( dbfRctPrvL )->nNumFac ) + ( dbfRctPrvL )->cSufFac == ( dbfRctPrvT )->cSerFac + Str( ( dbfRctPrvT )->nNumFac ) + ( dbfRctPrvT )->cSufFac .AND. !( dbfRctPrvL )->( eof() )
               dbPass( dbfRctPrvL, tmpRctPrvL, .t. )
               ( dbfRctPrvL )->( dbSkip() )
            end do
         end if

         ( dbfRctPrvT )->( dbSkip() )

         if !empty( ::oSender:oMtr )
            ::oSender:oMtr:Set( ( dbfRctPrvT )->( OrdKeyNo() ) )
         end if

      end while

   end if

   ( dbfRctPrvT )->( OrdSetFocus( nOrd ) )

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   CLOSE ( dbfRctPrvT )
   CLOSE ( dbfRctPrvL )
   CLOSE ( tmpRctPrvT )
   CLOSE ( tmpRctPrvL )

   if lSnd

      /*
      Comprimir los archivos---------------------------------------------------
      */

      ::oSender:SetText( "Comprimiendo facturas de proveedores" )

      if ::oSender:lZipData( cFileName )
         ::oSender:SetText( "Ficheros comprimidos" )
      else
         ::oSender:SetText( "ERROR al crear fichero comprimido" )
      end if

   else

      ::oSender:SetText( "No hay facturas de proveedores para enviar" )

   end if

Return ( Self )

//----------------------------------------------------------------------------//

Method RestoreData() CLASS TRectificativasProveedorSenderReciver

   local oBlock
   local oError
   local dbfRctPrvT

   if ::lSuccesfullSend

      oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
      BEGIN SEQUENCE

      USE ( cPatEmp() + "RctPrvT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FacPrvT", @dbfRctPrvT ) )
      SET ADSINDEX TO ( cPatEmp() + "RctPrvT.CDX" ) ADDITIVE

      ( dbfRctPrvT )->( OrdSetFocus( "lSndDoc" ) )

      while ( dbfRctPrvT )->( dbSeek( .t. ) ) .and. !( dbfRctPrvT )->( eof() )
         if ( dbfRctPrvT )->( dbRLock() )
            ( dbfRctPrvT )->lSndDoc := .f.
            ( dbfRctPrvT )->( dbRUnlock() )
         end if
      end do

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

      CLOSE ( dbfRctPrvT )

   end if

Return ( Self )

//----------------------------------------------------------------------------//

Method SendData() CLASS TRectificativasProveedorSenderReciver

   local cFileName
   local cDirectory           := ""

   if ::oSender:lServer
      cFileName               := "RectPrv" + StrZero( ::nGetFacturaNumberToSend(), 6 ) + ".All"
   else
      cFileName               := "RectPrv" + StrZero( ::nGetFacturaNumberToSend(), 6 ) + "." + RetSufEmp()
   end if

   ::lSuccesfullSend  := .f.

   if File( cPatOut() + cFileName )

      /*
      Enviarlos a internet
      */

      if ::oSender:SendFiles( cPatOut() + cFileName, cDirectory + cFileName, cDirectory  )
         ::lSuccesfullSend := .t.
         ::oSender:SetText( "Fichero enviado " + cFileName )
      else
         ::oSender:SetText( "ERROR al enviar fichero" )
      end if

   end if

   /*
   Enviarlos a internet--------------------------------------------------------
   */

   if ::lSuccesfullSend
      ::IncFacturaNumberToSend()
   end if

Return ( Self )

//----------------------------------------------------------------------------//

Method ReciveData() CLASS TRectificativasProveedorSenderReciver

   local n
   local aExt

   aExt     := ::oSender:aExtensions()

   /*
   Recibirlo de internet
   */

   ::oSender:SetText( "Recibiendo rectificativas de proveedores" )

   for n := 1 to len( aExt )
      ::oSender:GetFiles( "RectPrv*." + aExt[ n ], cPatIn() )
   next

   ::oSender:SetText( "Facturas rectificativas de proveedores recibidas" )

Return Self

//----------------------------------------------------------------------------//

Method Process() CLASS TRectificativasProveedorSenderReciver

   local m
   local dbfRctPrvT
   local dbfRctPrvL
   local aFiles         := Directory( cPatIn() + "RectPrv*.*" )
   local lClient        := ::oSender:lServer
   local oBlock
   local oError
   local cNumeroFactura
   local cTextoFactura  := ""

   /*
   Recibirlo de internet
   */

   ::oSender:SetText( "Recibiendo facturas rectificativas de proveedores" )

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

         if file( cPatSnd() + "RctPrvT.DBF" ) .and.;
            file( cPatSnd() + "RctPrvL.DBF" )

            USE ( cPatSnd() + "RctPrvT.DBF" ) NEW VIA ( cLocalDriver() )   SHARED ALIAS ( cCheckArea( "RctPrvT", @tmpRctPrvT ) )

            USE ( cPatSnd() + "RctPrvL.DBF" ) NEW VIA ( cLocalDriver() )   SHARED ALIAS ( cCheckArea( "RctPrvT", @tmpRctPrvL ) )
            SET INDEX TO ( cPatSnd() + "RctPrvL.CDX" ) ADDITIVE

            USE ( cPatEmp() + "RctPrvT.DBF" ) NEW VIA ( cDriver() )        SHARED ALIAS ( cCheckArea( "RctPrvT", @dbfRctPrvT ) )
            SET ADSINDEX TO ( cPatEmp() + "RctPrvT.CDX" ) ADDITIVE

            USE ( cPatEmp() + "RctPrvL.DBF" ) NEW VIA ( cDriver() )        SHARED ALIAS ( cCheckArea( "RctPrvT", @dbfRctPrvL ) )
            SET ADSINDEX TO ( cPatEmp() + "RctPrvL.CDX" ) ADDITIVE

            while ( tmpRctPrvT )->( !eof() )

               /*
               Comprobamos que no exista el Facido en la base de datos
               */

               if ::validateRecepcion( tmpRctPrvT, dbfRctPrvT )

                  cNumeroFactura    := ( tmpRctPrvT )->cSerFac + str( ( tmpRctPrvT )->nNumFac ) + ( tmpRctPrvT )->cSufFac
                  cTextoFactura     := ( tmpRctPrvT )->cSerFac + "/" + AllTrim( str( ( tmpRctPrvT )->nNumFac ) ) + "/" + AllTrim( ( tmpRctPrvT )->cSufFac ) + "; " + Dtoc( ( tmpRctPrvT )->dFecFac ) + "; " + AllTrim( ( tmpRctPrvT )->cCodPrv ) + "; " + ( tmpRctPrvT )->cNomPrv

                  while ( dbfRctPrvT )->( dbseek( cNumeroFactura ) )
                     dbLockDelete( dbfRctPrvT )
                  end if 

                  while ( dbfRctPrvL )->( dbseek( cNumeroFactura ) )
                     dbLockDelete( dbfRctPrvL )
                  end if

                  dbPass( tmpRctPrvT, dbfRctPrvT, .t. )
                  
                  if dbLock( dbfRctPrvT )
                     ( dbfRctPrvT )->lSndDoc := .f.
                     ( dbfRctPrvT )->( dbUnLock() )
                  end if

                  ::oSender:SetText( "Añadido rectificativa proveedor : " + cTextoFactura )

                  if ( tmpRctPrvL )->( dbSeek( ( tmpRctPrvT )->cSerFac + Str( ( tmpRctPrvT )->nNumFac ) + ( tmpRctPrvT )->cSufFac ) )
                     while ( tmpRctPrvL )->cSerFac + Str( ( tmpRctPrvL )->nNumFac ) + ( tmpRctPrvL )->cSufFac == ( tmpRctPrvT )->cSerFac + Str( ( tmpRctPrvT )->nNumFac ) + ( tmpRctPrvT )->cSufFac .and. !( tmpRctPrvL )->( eof() )
                        dbPass( tmpRctPrvL, dbfRctPrvL, .t. )
                        ( tmpRctPrvL )->( dbSkip() )
                     end do
                  end if

                  ::oSender:SetText( "Añadido lineas de rectificativa proveedor : " + cTextoFactura )

               else

                  ::oSender:SetText( "Factura fecha invalida" + cTextoFactura )

               end if

               ( tmpRctPrvT )->( dbSkip() )

            end do

            CLOSE ( dbfRctPrvT )
            CLOSE ( dbfRctPrvL )
            CLOSE ( tmpRctPrvT )
            CLOSE ( tmpRctPrvL )

            ::oSender:AppendFileRecive( aFiles[ m, 1 ] )

         else

            ::oSender:SetText( "Faltan ficheros" )

            if !file( cPatSnd() + "RctPrvT.Dbf" )
               ::oSender:SetText( "Falta" + cPatSnd() + "RctPrvT.Dbf" )
            end if

            if !file( cPatSnd() + "RctPrvL.Dbf" )
               ::oSender:SetText( "Falta" + cPatSnd() + "RctPrvL.Dbf" )
            end if  

         end if

      else
      
          ::oSender:SetText( "Error al descomprimir los ficheros" )  

      end if

      RECOVER USING oError

         CLOSE ( dbfRctPrvT )
         CLOSE ( dbfRctPrvL )
         CLOSE ( tmpRctPrvT )
         CLOSE ( tmpRctPrvL )

         ::oSender:SetText( "Error procesando fichero " + aFiles[ m, 1 ] )
         ::oSender:SetText( ErrorMessage( oError ) )

      END SEQUENCE

      ErrorBlock( oBlock )

   next

Return Self

//---------------------------------------------------------------------------//

METHOD validateRecepcion( tmpRctPrvT, dbfRctPrvT ) CLASS TRectificativasProveedorSenderReciver

   ::cErrorRecepcion       := "Pocesando rectificativa de cliente número " + ( dbfRctPrvT )->cSerFac + "/" + alltrim( Str( ( dbfRctPrvT )->nNumFac ) ) + "/" + alltrim( ( dbfRctPrvT )->cSufFac ) + " "

   if !( lValidaOperacion( ( tmpRctPrvT )->dFecFac, .f. ) )
      ::cErrorRecepcion    += "la fecha " + dtoc( ( tmpRctPrvT )->dFecFac ) + " no es valida en esta empresa"
      Return .f. 
   end if 

   if !( ( dbfRctPrvT )->( dbSeek( ( tmpRctPrvT )->cSerFac + Str( ( tmpRctPrvT )->nNumFac ) + ( tmpRctPrvT )->cSufFac ) ) )
      Return .t.
   end if 

   if dtos( ( dbfRctPrvT )->dFecChg ) + ( dbfRctPrvT )->cTimChg >= dtos( ( tmpRctPrvT )->dFecChg ) + ( tmpRctPrvT )->cTimChg 
      ::cErrorRecepcion    += "la fecha en la empresa " + dtoc( ( dbfRctPrvT )->dFecChg ) + " " + ( dbfRctPrvT )->cTimChg + " es más reciente que la recepción " + dtoc( ( tmpRctPrvT )->dFecChg ) + " " + ( tmpRctPrvT )->cTimChg 
      Return .f.
   end if

Return ( .t. )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//